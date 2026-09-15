#!/usr/bin/env python3
"""Conservative fresh installation and optional prompt command generation."""
import argparse
import ast
from contextlib import contextmanager
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import re
import stat
import subprocess
import sys
import tempfile

sys.dont_write_bytecode = True
from axiarch_state import atomic, digest, inside, native_language, language_settings, markdown_source_lines, protect_artifacts, privacy_check, read_json, fcntl
from axiarch_upgrade import upgrade_lock_path, distribution_path, DistributionNames

MARKER = '<!-- AXIARCH_GENERATED_COMMAND: do not edit; regenerate via axiarch-scripts/axiarch-prompts-install.sh -->'
HASH_KEY = 'axiarch-generated-sha256: '


@contextmanager
def locked(root):
    # Share the upgrade lock; keep it outside the adopter, including on previews.
    fd = os.open(upgrade_lock_path(root), os.O_RDWR | os.O_CREAT | os.O_NOFOLLOW, 0o600)
    try:
        info = os.fstat(fd)
        if not stat.S_ISREG(info.st_mode) or info.st_uid != os.getuid():
            raise ValueError('unsafe lock file')
        fcntl.flock(fd, fcntl.LOCK_EX | fcntl.LOCK_NB)
        yield
    finally:
        os.close(fd)


def checked(root, rel):
    path = inside(root, rel)
    if any(p.exists() and not p.is_dir() for p in path.parents):
        raise ValueError(f'parent is not a directory: {rel}')
    return path


def write_bytes(path, content, mode=0o644):
    path.parent.mkdir(parents=True, exist_ok=True)
    fd, tmp = tempfile.mkstemp(prefix='.axiarch-setup-', dir=path.parent)
    try:
        with os.fdopen(fd, 'wb') as stream:
            stream.write(content); stream.flush(); os.fsync(stream.fileno())
        os.chmod(tmp, mode)
        os.replace(tmp, path)
    finally:
        if os.path.exists(tmp):
            os.unlink(tmp)


def owned(content):
    # Lossy decoding can make altered bytes match an earlier generated hash.
    # Unreadable existing commands must remain outside the replacement plan.
    try:
        text = content.decode('utf-8')
    except UnicodeDecodeError:
        return False
    lines = text.splitlines(keepends=True)
    hashes = [line for line in lines if line.startswith(HASH_KEY)]
    if not text.startswith('---\n') or len(hashes) != 1 or '\n' + MARKER + '\n' not in text:
        return False
    expected = hashes[0][len(HASH_KEY):].strip()
    return expected == hashlib.sha256(''.join(line for line in lines if line != hashes[0]).encode()).hexdigest()


def render(prompt, rel, lang):
    title = next((line[2:].strip() for line in prompt.read_text(encoding='utf-8').splitlines() if line.startswith('# ')), 'Axiarch prompt')
    protocol = f'axiarch-rules/{lang}/LOADING_PROTOCOL.md'
    if lang == 'ja':
        body = (f'正本プロンプト `{rel}` を実際に読み、適用範囲に応じた手順を実行してください。\n'
                f'`AXIARCH.md` と `{protocol}` を参照し、必要な内容を読んだ後に実際の読込範囲だけを報告してください。\n'
                'このポインターの表示はロード完了の証拠ではありません。H0/H1にH2の記録を要求しません。\n\n'
                'ユーザーからの追加入力:\n$ARGUMENTS\n')
        hint = 'タスク内容・対象・方針'
    else:
        body = (f'Read the canonical prompt `{rel}` and follow its applicable procedure.\n'
                f'Apply `AXIARCH.md` and `{protocol}`; report only the ranges actually read.\n'
                'Displaying this pointer is not proof of loading. Do not impose H2 records on H0/H1 work.\n\n'
                'User-provided input:\n$ARGUMENTS\n')
        hint = 'task, target, policy'
    # JSON strings are YAML-compatible scalars, including colons and quotes.
    text = ('---\ndescription: ' + json.dumps(title, ensure_ascii=False) + '\nargument-hint: '
            + json.dumps(hint, ensure_ascii=False) + '\n---\n' + MARKER + '\n\n' + body)
    sha = hashlib.sha256(text.encode()).hexdigest()
    return text.replace('---\n', '---\n' + HASH_KEY + sha + '\n', 1).encode()


def prompts(args):
    root = Path(args.target).resolve(strict=True)
    with locked(root):
        commands = checked(root, '.claude/commands')
        if commands.exists() and not commands.is_dir():
            raise ValueError('command directory is not a directory')
        existing = {}
        for p in sorted(commands.iterdir()) if commands.is_dir() else []:
            if not (p.name.casefold().startswith('axiarch-') and p.name.casefold().endswith('.md')):
                continue
            p = checked(root, p.relative_to(root).as_posix())
            if not p.is_file():
                raise ValueError(f'command is not a regular file: {p.name}')
            existing[p.name] = p.read_bytes()
        generated = {name for name, content in existing.items() if owned(content)}
        existing_names = {name.casefold(): name for name in existing}
        if len(existing_names) != len(existing):
            raise ValueError('command names collide on case-insensitive filesystems')
        desired = {}
        if not args.clean:
            lang = args.lang
            if lang == 'auto':
                lang = native_language(root)
            library = checked(root, f'axiarch-prompts/{lang}')
            if not library.is_dir():
                raise ValueError('install the selected prompt library into the target first; --source does not copy it')
            for rel in ('AXIARCH.md', f'axiarch-rules/{lang}/LOADING_PROTOCOL.md'):
                if not checked(root, rel).is_file():
                    raise ValueError('canonical protocol missing: ' + rel)
            for p in sorted(library.glob('*/*.md')):
                rel = p.relative_to(root).as_posix()
                p = checked(root, rel)
                if not p.is_file() or not re.fullmatch(r'[A-Za-z0-9_-]+', p.stem):
                    raise ValueError(f'unsupported prompt filename: {rel}')
                name = 'axiarch-' + p.stem.replace('_', '-').lower() + '.md'
                if name in desired:
                    raise ValueError(f'duplicate command name: {name}')
                desired[name] = render(p, rel, lang)
            if not desired:
                raise ValueError('no canonical prompts found; existing commands retained')
        # No deletions or replacements until the whole plan is safe.
        conflicts = [name for name in desired if name.casefold() in existing_names
                     and existing_names[name.casefold()] not in generated]
        edited = [name for name, content in existing.items() if name not in generated and MARKER.encode() in content]
        if conflicts or edited:
            raise ValueError('preserved custom, edited or legacy commands; review/move them before retry: '
                             + ', '.join(sorted(set(conflicts + edited))))
        for name in sorted(generated - desired.keys()):
            print(('Would remove: ' if args.dry_run else 'Remove: ') + name)
            if not args.dry_run:
                checked(root, '.claude/commands/' + name).unlink()
        for name, content in desired.items():
            if existing.get(name) == content:
                continue
            print(('Would generate: ' if args.dry_run else 'Generate: ') + name)
            if not args.dry_run:
                write_bytes(checked(root, '.claude/commands/' + name), content)
        print('Preview only; no files changed.' if args.dry_run else 'Command file operation complete.')
        print('Claude adapter output is not an agent execution test. Other agents: use the canonical prompt directly.')
    return 0


def check_source(args):
    root = Path(args.source).resolve(strict=True)
    names = DistributionNames()
    for rel in args.paths + args.files + args.directories:
        names.add(rel)
    for rel in args.files:
        if not checked(root, rel).is_file():
            raise ValueError(f'required distribution file missing or wrong type: {rel}')
    for rel in args.directories:
        if not checked(root, rel).is_dir():
            raise ValueError(f'required distribution directory missing or wrong type: {rel}')
    for rel in dict.fromkeys(args.paths + args.files + args.directories):
        distribution_path(rel)
        path = checked(root, rel)
        if not path.exists():
            raise ValueError(f'required distribution path missing: {rel}')
        for child in [path] + (list(path.rglob('*')) if path.is_dir() else []):
            names.add(child.relative_to(root).as_posix())
            distribution_path(child.relative_to(root).as_posix())
            checked(root, child.relative_to(root).as_posix())
            if not child.is_file() and not child.is_dir():
                raise ValueError(f'unsupported distribution entry: {child}')
            if child.is_file() and child.suffix == '.json':
                read_json(child)
    return 0


def configure_language(args):
    """Configure the one real setting in init's isolated staging directory."""
    if args.lang not in ('ja', 'en'):
        raise ValueError('configure-language requires an explicit ja/en language')
    path = checked(Path(args.target).resolve(strict=True), 'AXIARCH.md')
    text = path.read_bytes().decode('utf-8')
    settings = language_settings(text, with_spans=True)
    if len(settings) != 1:
        raise ValueError('exactly one real Project Native Language setting required')
    lines = markdown_source_lines(text)
    index, value, start, end = settings[0]
    if not value or '`' in value or lines[index][start:end] != value:
        raise ValueError('language value must be plain text without embedded markup')
    lines[index] = lines[index][:start] + ('Japanese' if args.lang == 'ja' else 'English') + lines[index][end:]
    write_bytes(path, ''.join(lines).encode('utf-8'), stat.S_IMODE(path.stat().st_mode))
    return 0


def precommit_plan(root):
    git = checked(root, '.git')
    if not git.is_dir():
        return None, 'manual: no local .git directory (worktrees require manual integration)'
    configured = subprocess.run(['git', '-C', str(root), 'config', '--get', 'core.hooksPath'],
                                capture_output=True, text=True, check=False)
    if configured.returncode not in (0, 1):
        raise ValueError('cannot inspect Git hooks configuration')
    if configured.stdout.strip() or any((root / p).exists() for p in (
            'lefthook.yml', '.lefthook.yml', '.pre-commit-config.yaml', '.husky')):
        return None, 'manual: existing hook manager or core.hooksPath preserved'
    hook = checked(root, '.git/hooks/pre-commit')
    if hook.exists():
        return None, 'manual: existing pre-commit preserved; integrate the health command yourself'
    content = (b'#!/usr/bin/env bash\nset -uo pipefail\n'
               b'# Axiarch optional structure check; this does not prove AI adherence.\n'
               b'if [[ -z "${AXIARCH_PRECOMMIT_SKIP:-}" ]]; then\n'
               b'  bash axiarch-scripts/check-axiarch-health.sh --quiet || exit $?\nfi\n')
    return (hook, content), 'installed'


def install(args):
    root, stage = Path(args.target).resolve(), Path(args.stage).resolve(strict=True)
    with locked(root):
        if root.exists() and not root.is_dir():
            raise ValueError('target must be a directory')
        files, directories = [], []
        names = DistributionNames()
        for p in sorted(stage.rglob('*')):
            rel = p.relative_to(stage).as_posix()
            names.add(rel)
            distribution_path(rel)
            src, dst = checked(stage, rel), checked(root, rel)
            if src.is_dir():
                if dst.exists() and not dst.is_dir():
                    raise ValueError(f'file/directory collision: {rel}')
                directories.append(dst)
                continue
            if not src.is_file() or (dst.exists() and (not dst.is_file() or digest(dst) != digest(src))):
                raise ValueError(f'existing or unsupported file preserved: {rel}; use safe upgrade/manual integration')
            files.append((src, dst, rel))
        for rel in ('.axiarch/version.json', '.axiarch/install-result.json', '.axiarch/install-health.log', '.axiarch/files.sha256'):
            if checked(root, rel).exists():
                raise ValueError(f'existing installation metadata preserved: {rel}; use safe upgrade')
        for src, _, rel in files:
            if rel.startswith('axiarch-scripts/') and src.suffix in ('.sh', '.py'):
                if src.suffix == '.py':
                    ast.parse(src.read_text(encoding='utf-8'))
                elif subprocess.run(['bash', '-n', str(src)], check=False).returncode:
                    raise ValueError(f'shell syntax failure: {rel}')
        hook, hook_status = precommit_plan(root) if args.precommit else (None, 'not_selected')
        if args.dry_run:
            print(f'Preview only: {len(files)} files checked; no installation applied.')
            return 0
        protect_artifacts(root)
        scope = dict(languages=args.languages, agent=args.agent, with_prompts=args.with_prompts)
        result = dict(schema_version=1, mode='install', application='in_progress', selection=scope,
                      requested_version=args.version, health=dict(status='not_run', exit_code=None),
                      started_at=datetime.now(timezone.utc).isoformat(), optional_precommit=hook_status)
        meta = root / '.axiarch'
        version = dict(version=None, requestedVersion=args.version, requestedScope=scope,
                       sourceRef=args.source_ref, language=args.lang, agent=args.agent,
                       applicationStatus='in_progress', healthStatus='not_run')
        atomic(meta / 'install-result.json', result)
        atomic(meta / 'version.json', version)
        try:
            for directory in directories:
                directory.mkdir(parents=True, exist_ok=True)
            for src, dst, _ in files:
                if not dst.exists():
                    write_bytes(dst, src.read_bytes(), stat.S_IMODE(src.stat().st_mode))
            write_bytes(meta / 'files.sha256', ''.join(f'{digest(dst)}  {rel}\n' for _, dst, rel in files).encode())
            if hook:
                write_bytes(hook[0], hook[1], 0o755)
            print('Optional pre-commit: ' + hook_status)
            result['application'] = 'complete'
            health = subprocess.run(['bash', str(root / 'axiarch-scripts/check-axiarch-health.sh'), str(root)],
                                    cwd=root, capture_output=True, check=False)
            write_bytes(meta / 'install-health.log', health.stdout + health.stderr, 0o600)
            rc = 0 if health.returncode == 0 else 4
            result['health'] = dict(status='passed' if rc == 0 else 'failed', exit_code=health.returncode)
            try:
                privacy_check(root)
            except (OSError, ValueError) as exc:
                result['health'].update(status='failed', exit_code=health.returncode or 2,
                                        script_exit_code=health.returncode, privacy_error=str(exc)); rc = 4
            if rc == 0:
                version.update(version=args.version, confirmedScope=scope)
        except (OSError, ValueError) as exc:
            result.update(application='failed', error=str(exc)); rc = 5
        version.update(applicationStatus=result['application'], healthStatus=result['health']['status'])
        result.update(exit_code=rc, confirmed_version=version['version'],
                      finished_at=datetime.now(timezone.utc).isoformat())
        atomic(meta / 'install-result.json', result)
        atomic(meta / 'version.json', version)
        print('Install result: ' + json.dumps(result, ensure_ascii=False))
        return rc


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('mode', choices=['prompts', 'install', 'check-source', 'configure-language'])
    parser.add_argument('--target', default=os.getcwd())
    parser.add_argument('--source', default='')  # compatibility; pointers always use installed files
    parser.add_argument('--stage', default='')
    parser.add_argument('--lang', choices=['ja', 'en', 'auto'], default='auto')
    parser.add_argument('--languages', choices=['ja', 'en', 'both'], default='both')
    for name in ('version', 'source-ref', 'agent'):
        parser.add_argument('--' + name, default='')
    for name in ('clean', 'dry-run', 'precommit', 'with-prompts'):
        parser.add_argument('--' + name, action='store_true')
    parser.add_argument('--paths', nargs='*', default=[])
    parser.add_argument('--files', nargs='*', default=[])
    parser.add_argument('--directories', nargs='*', default=[])
    args = parser.parse_args()
    if args.mode == 'install' and (not args.stage or not args.version or args.lang == 'auto'):
        parser.error('install requires --stage, --version and explicit --lang')
    if args.clean and args.mode != 'prompts':
        parser.error('--clean applies only to prompts')
    return dict(prompts=prompts, install=install, **{'check-source': check_source, 'configure-language': configure_language})[args.mode](args)


if __name__ == '__main__':
    try:
        sys.exit(main())
    except BlockingIOError:
        print('Setup busy: another install, command generation or upgrade is using this target.', file=sys.stderr)
        sys.exit(6)
    except (OSError, ValueError, SyntaxError) as exc:
        print(f'Setup stopped: {exc}', file=sys.stderr)
        sys.exit(3)
