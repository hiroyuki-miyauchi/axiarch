"""Offline reference checks for Markdown, AI text entrypoints and bilingual paths.

Checks inline/image/reference links, concrete inline rule paths and ATX headings used here, not a full
Markdown renderer, external link availability or correctness of rule meaning.
"""
import html
from contextlib import ExitStack
import os
from pathlib import Path
import re
import stat
import sys
import unicodedata
from urllib.parse import unquote, urlsplit

sys.dont_write_bytecode = True
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'axiarch-scripts'))
from axiarch_state import markdown_prose_lines

prose_lines = markdown_prose_lines


def slug(text):
    text = re.sub(r"<[^>]*>", "", text)
    text = re.sub(r"\[([^]]+)\]\([^)]+\)", r"\1", text)
    text = html.unescape(text).lower().replace("`", "").replace("*", "")
    return "".join(c for c in text if c in " -_" or unicodedata.category(c)[0] in "LNM").replace(" ", "-")


def anchors(text):
    found = set()
    for _, line in prose_lines(text):
        found.update(re.findall(r'<a\s+(?:id|name)=["\']([^"\']+)["\']', line))
        heading = re.match(r"^#{1,6}\s+(.+?)\s*#*\s*$", line)
        if heading:
            base = slug(heading[1])
            candidate, suffix = base, 0
            while candidate in found:
                suffix += 1
                candidate = f"{base}-{suffix}"
            found.add(candidate)
    return found


def source_documents(root):
    yield from sorted(root.glob("*.md"))
    # These published AI entrypoints contain Markdown links and rule paths too.
    # Do not glob arbitrary .txt files: logs and examples are not guidance.
    for name in ('llms.txt', 'llms-full.txt'):
        path = root / name
        if path.exists() or path.is_symlink():
            yield path
    for folder in ("axiarch-rules", "axiarch-harness", "axiarch-prompts", "axiarch-scripts"):
        tree = root / folder
        if tree.is_symlink() or (tree.exists() and not tree.is_dir()):
            yield tree  # Report the invalid boundary without traversing it.
            continue
        if not tree.exists():
            continue  # Minimal fixtures and optional source trees may be absent.

        def unreadable(error):
            raise error

        for directory, folders, files in os.walk(tree, followlinks=False, onerror=unreadable):
            folders.sort()
            for name in folders[:]:
                path = Path(directory) / name
                if path.is_symlink():
                    yield path
                    folders.remove(name)
            for name in sorted(files):
                if name.endswith('.md'):
                    yield Path(directory) / name


def source_bytes(root, path):
    """Open each component relative to the root; never follow links or wait on FIFOs."""
    parts = path.relative_to(root).parts
    if not parts or '..' in parts:
        raise ValueError('source must remain inside the repository')
    with ExitStack() as handles:
        parent = os.open(root, os.O_RDONLY | os.O_DIRECTORY | os.O_NOFOLLOW)
        handles.callback(os.close, parent)
        for part in parts[:-1]:
            parent = os.open(part, os.O_RDONLY | os.O_DIRECTORY | os.O_NOFOLLOW, dir_fd=parent)
            handles.callback(os.close, parent)
        fd = os.open(parts[-1], os.O_RDONLY | os.O_NOFOLLOW | os.O_NONBLOCK, dir_fd=parent)
        handles.callback(os.close, fd)
        info = os.fstat(fd)
        if not stat.S_ISREG(info.st_mode) or info.st_nlink != 1:
            raise ValueError('single-link regular source file required')
        with os.fdopen(fd, 'rb', closefd=False) as stream:
            return stream.read()


def inspect_prompt(text):
    """Check known instruction regressions inside the copyable fenced body.

    Normal prose link checking deliberately ignores fences. Prompt instructions
    are executable guidance inside fences, so they need this separate check.
    This is not a semantic proof of every instruction or of agent compliance.
    """
    issues = []
    body = re.search(r'^````[^\n]*\n(.*?)^````\s*$', text, re.M | re.S)
    if not body:
        return ['missing copyable prompt body']
    body = body[1]
    for required in ('AXIARCH.md', 'axiarch-rules/{lang}/LOADING_PROTOCOL.md',
                     'axiarch-rules/{lang}/universal/core/300_goal_and_current_state.md'):
        if required not in body:
            issues.append('missing canonical prompt reference: ' + required)
    for obsolete in ('Stop & Wait', 'Ack Only', 'Override Power', '/tmp/axiarch-upgrade.sh',
                     'bash -n init.sh axiarch-scripts/*.sh'):
        if obsolete in body:
            issues.append('obsolete prompt instruction: ' + obsolete)
    loading = re.search(r'^# Phase [01]:.*?\n(.*?)(?=^# |\Z)', body, re.M | re.S)
    if loading and re.search(r'All files under|配下の全ファイル|内の全ファイル', loading[1]):
        issues.append('unconditional whole-rule loading in prompt')
    return issues


def diagnostic_text(message):
    """Keep each issue on one inert display line, including untrusted filenames."""
    visible = ''.join(char if char.isprintable() else ascii(char)[1:-1] for char in message)
    # Both current and legacy GitHub runner command markers are log syntax.
    return visible.replace('::', r'\x3a\x3a').replace('##[', r'\x23\x23[')


def inspect(root):
    return [diagnostic_text(issue) for issue in inspect_sources(root)]


def inspect_sources(root):
    root = root.resolve()
    problems = []
    contents = {}

    def text(path):
        if path not in contents:
            try:
                contents[path] = source_bytes(root, path).decode('utf-8')
            except (OSError, ValueError):
                # Do not include exception text: it can expose rejected bytes or link targets.
                problems.append(f'{path.relative_to(root)}: unreadable UTF-8 source or non-regular/linked file')
                contents[path] = ''
        return contents[path]

    try:
        docs = list(source_documents(root))
    except OSError:
        return ['Document source tree cannot be enumerated; inspection incomplete']
    by_path = {p: anchors(text(p)) for p in docs}
    if problems:
        return problems  # No secondary traversal through invalid source directories.
    for path in docs:
        # Released changelog paths describe their original release layout.
        # Check present guidance and Unreleased, not rewritten history.
        current = text(path)
        if path == root / 'CHANGELOG.md':
            current = re.split(r'^## \[(?!Unreleased\])', current, maxsplit=1, flags=re.M)[0]
        for number, line in prose_lines(current):
            for target in re.findall(r'`([^`\n]+\.md)`', line):
                if re.fullmatch(r'[0-9]{3}_[a-z][a-z0-9_]*\.md', target):
                    problems.append(f'{path.relative_to(root)}:{number}: ambiguous numbered filename: {target}; include its directory')
                # Domain-relative references use the language/layer of the rule.
                # Explicit examples are illustrative paths, not required files.
                if re.match(r'^(core|design|engineering|operations|product|quality|security|ai)/', target):
                    relative = path.relative_to(root).parts
                    if (len(relative) > 3 and relative[0] == 'axiarch-rules'
                            and relative[2] in ('universal', 'blueprint')
                            and not any(char in target for char in '{}*| <>')
                            and not re.search(r'例[:：]|e\.g\.,?', line)):
                        base = root.joinpath(*relative[:3])
                        if not (base / target).is_file():
                            problems.append(f'{path.relative_to(root)}:{number}: missing layer-relative path: {target}')
                if not target.startswith(('axiarch-rules/', 'axiarch-harness/', 'axiarch-prompts/', 'axiarch-scripts/')):
                    continue
                if any(char in target for char in '{}*| <>'):
                    continue  # Explicit templates are not concrete references.
                if not (root / target).is_file():
                    problems.append(f'{path.relative_to(root)}:{number}: missing inline path: {target}')
        for number, line in prose_lines(text(path), mask_code_spans=True):
            destinations = [m[1] for m in re.finditer(r'!?\[[^]\n]+\]\((<[^>]+>|[^)\s]+)(?:\s+"[^"]*")?\)', line)]
            reference = re.match(r'^ {0,3}\[[^]]+\]:\s*(<[^>]+>|\S+)', line)
            if reference:
                destinations.append(reference[1])
            for target in destinations:
                target = target.strip("<>")
                try:
                    if any(unicodedata.category(c) in ('Cc', 'Zl', 'Zp') for c in target):
                        raise ValueError('control character in link')
                    parts = urlsplit(target)
                except ValueError:
                    problems.append(f'{path.relative_to(root)}:{number}: invalid link syntax or encoding')
                    continue
                if parts.scheme or parts.netloc or any(c in target for c in "{}*"):
                    continue
                try:
                    decoded_path = unquote(parts.path, errors='strict')
                    fragment = unquote(parts.fragment, errors='strict')
                    if any(unicodedata.category(c) in ('Cc', 'Zl', 'Zp') for c in decoded_path + fragment):
                        raise ValueError('control character in local link')
                except ValueError:
                    problems.append(f'{path.relative_to(root)}:{number}: invalid link syntax or encoding')
                    continue
                try:
                    destination = (path.parent / decoded_path).resolve(strict=True) if decoded_path else path.resolve(strict=True)
                    exists = destination.exists()
                except UnicodeError:
                    raise  # Keep the CLI's filesystem-codec retry guidance.
                except FileNotFoundError:
                    exists = False
                except (OSError, RuntimeError, ValueError):
                    problems.append(f'{path.relative_to(root)}:{number}: unreadable link target')
                    continue
                if not exists:
                    problems.append(f"{path.relative_to(root)}:{number}: missing path: {target}")
                elif fragment and destination in by_path and fragment not in by_path[destination]:
                    problems.append(f"{path.relative_to(root)}:{number}: missing anchor: {target}")
    for tree in ("axiarch-rules", "axiarch-harness", "axiarch-prompts"):
        sets = [{p.relative_to(root / tree / lang).as_posix() for p in (root / tree / lang).rglob("*.md")}
                for lang in ("ja", "en")]
        for missing in sorted(sets[0] ^ sets[1]):
            problems.append(f"{tree}: bilingual path mismatch: {missing}")
    for lang in ('ja', 'en'):
        for path in sorted((root / 'axiarch-prompts' / lang).rglob('*.md')):
            problems.extend(f'{path.relative_to(root)}: {issue}' for issue in inspect_prompt(text(path)))
    if (root / 'init.sh').is_file():
        for name in ('LICENSE', 'NOTICE'):
            original, distributed = root / name, root / 'axiarch-rules' / name
            if not original.is_file() or not distributed.is_file():
                problems.append(f'axiarch-rules/{name}: missing source/distribution notice')
            else:
                try:
                    if source_bytes(root, original) != source_bytes(root, distributed):
                        problems.append(f'axiarch-rules/{name}: distribution notice differs from source')
                except (OSError, ValueError):
                    problems.append(f'axiarch-rules/{name}: unreadable or linked source/distribution notice')
    for lang in ("ja", "en"):
        for layer in ("universal", "blueprint"):
            for folder in (root / "axiarch-rules" / lang / layer).glob("*/"):
                prefixes = set()
                for path in sorted(folder.glob("[0-9][0-9][0-9]_*.md")):
                    prefix = path.name[:3]
                    if prefix in prefixes:
                        problems.append(f"{path.relative_to(root)}: duplicate prefix within folder: {prefix}")
                    prefixes.add(prefix)
    current_status = [root / p for p in ("README.md", "llms.txt", "llms-full.txt", "MARKET_STRATEGY.md")]
    current_status += [root / "axiarch-rules" / lang / p for lang in ("ja", "en")
                       for p in ("README.md", "LOADING_PROTOCOL.md")]
    for path in current_status:
        if (path.exists() or path.is_symlink()) and re.search(r"are all validated through real operational use|いずれも実運用（ドッグフーディング）で稼働を確認済み", text(path)):
            problems.append(f"{path.relative_to(root)}: obsolete all-agent validation claim")
    contracts = [root / f"axiarch-harness/{lang}/TASK_STATE_PROTOCOL.md" for lang in ("ja", "en")]
    contracts += [root / "axiarch-scripts/axiarch-init-task-md.sh", root / "llms.txt"]
    for path in contracts:
        # ASCII boundaries also catch tokens immediately followed by Japanese.
        if (path.exists() or path.is_symlink()) and re.search(r"(?<![A-Za-z0-9])L[0-4](?![A-Za-z0-9])", text(path)):
            problems.append(f"{path.relative_to(root)}: obsolete harness level; use H0-H4")
    return problems


def main(root):
    # CLI output must preserve Japanese paths even under inherited ascii:replace.
    for stream in (sys.stdout, sys.stderr):
        if hasattr(stream, 'reconfigure'):
            stream.reconfigure(encoding='utf-8', errors='backslashreplace')
    try:
        issues = inspect(root)
    except UnicodeError:
        print('Filename encoding unavailable; retry with PYTHONUTF8=1 / '
              'ファイル名を解釈できません。PYTHONUTF8=1で再検査してください。', file=sys.stderr)
        return 2
    print("\n".join(issues) if issues else "Local document references and bilingual paths: passed")
    return int(bool(issues))


if __name__ == "__main__":
    sys.exit(main(Path(__file__).resolve().parents[1]))
