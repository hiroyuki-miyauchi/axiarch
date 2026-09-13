#!/usr/bin/env python3
"""Portable task evidence store. Python 3 standard library; POSIX local filesystems.

The schema checks claims and file snapshots, not the meaning of those claims.
See axiarch-harness/{ja,en}/TASK_STATE_PROTOCOL.md for the public contract.
"""

import argparse
import copy
from contextlib import contextmanager
from datetime import datetime, timezone
import fcntl
import hashlib
import json
import math
import os
from pathlib import Path
import re
import shutil
import stat
import subprocess
import sys
import tempfile
import uuid

DOCS = ("task.md", "implementation_plan.md", "walkthrough.md")
STATES = {"not_started", "in_progress", "done", "discarded"}
PLACEHOLDER = re.compile(r"_\([^\n]*\)_|\b(?:TODO|TBD|PLACEHOLDER)\b|\[(?:Project Name|YYYY-MM-DD)\]", re.I)
PRIVATE_DIRS = ('tasks', 'sessions', 'upgrades', 'conflicts', 'process-doc-history', 'process-doc-state')
PRIVATE_FILES = ('task-state.lock', 'privacy.lock', 'upgrade-result.json', 'install-result.json', 'install-health.log')
PRIVATE_PATTERNS = tuple('/' + name + '/' for name in PRIVATE_DIRS) + tuple('/' + name for name in PRIVATE_FILES)


def now():
    return datetime.now(timezone.utc).isoformat(timespec="seconds")


def identifier(value):
    if not re.fullmatch(r"[A-Za-z0-9][A-Za-z0-9._-]{0,127}", value or ""):
        raise ValueError("ID must be 1–128 ASCII letters/digits/dots/hyphens/underscores")
    return value


def inside(root, relative):
    if not isinstance(relative, str) or not relative or Path(relative).is_absolute():
        raise ValueError("expected a project-relative path")
    if any(ord(char) < 32 or ord(char) == 127 for char in relative):
        raise ValueError("control characters are not supported in paths")
    path = root / relative
    if ".." in Path(relative).parts or any(p.is_symlink() for p in (path, *path.parents) if p != root.parent):
        raise ValueError("parent traversal or symlink is not supported")
    path.resolve().relative_to(root.resolve())
    return path


def digest(path):
    if not path.is_file() or path.is_symlink():
        raise ValueError(f"regular file required: {path}")
    return hashlib.sha256(path.read_bytes()).hexdigest()


def strict_json(text):
    def unique(pairs):
        result = {}
        for key, value in pairs:
            if key in result:
                raise ValueError('duplicate JSON key')
            result[key] = value
        return result

    def invalid_constant(value):
        raise ValueError('non-finite JSON number')

    def finite_float(value):
        parsed = float(value)
        if not math.isfinite(parsed):
            raise ValueError('JSON number exceeds finite runtime range')
        return parsed

    return json.loads(text, object_pairs_hook=unique, parse_constant=invalid_constant, parse_float=finite_float)


def read_json(path):
    # Opening a FIFO must not wait for a writer before it can be rejected.
    fd = os.open(path, os.O_RDONLY | os.O_NONBLOCK | os.O_NOFOLLOW)
    with os.fdopen(fd, 'r', encoding='utf-8') as stream:
        if not stat.S_ISREG(os.fstat(stream.fileno()).st_mode):
            raise ValueError(f'regular file required: {path}')
        data = strict_json(stream.read())
    if not isinstance(data, dict):
        raise ValueError(f"JSON object required: {path}")
    return data


def markdown_source_lines(text):
    """Physical Markdown lines, preserving LF/CRLF/CR and all other characters."""
    return re.findall(r'[^\r\n]*(?:\r\n|\r|\n|$)', text)[:-1]


def markdown_prose_lines(text, *, mask_code_spans=False):
    """Lexical view for top-level Axiarch fields, lessons and local links.

    Keep source columns while hiding comments and code examples. This is not a
    Markdown renderer: nested containers and arbitrary HTML are outside scope.
    """
    lines = [line.rstrip('\r\n') for line in markdown_source_lines(text)]

    def marker_at(line):
        return re.match(r'^ {0,3}(`{3,}|~{3,})(.*)$', line)

    def opening(marker):
        return marker and (marker[1][0] == '~' or '`' not in marker[2])

    def code_end(number, column, width):
        # Inline spans may cross soft line breaks, but not a new block. Exact
        # delimiter width matters; an unmatched run remains literal text.
        for index in range(number, len(lines)):
            line = lines[index]
            if index != number and (not line.strip() or opening(marker_at(line))
                                    or re.match(r'^(?: {4}|\t| {0,3}(?:#{1,6}\s|>|[-+*]\s|\d+[.)]\s|<!--))', line)):
                break
            for run in re.finditer(r'`+', line[column:] if index == number else line):
                if len(run[0]) == width:
                    return index, run.end() + (column if index == number else 0)
        return None

    fence, comment, span_end = None, False, None
    for number, line in enumerate(lines):
        marker = marker_at(line)
        if fence is not None:
            if marker and marker[1][0] == fence[0] and len(marker[1]) >= len(fence) and not marker[2].strip():
                fence = None
            continue
        if not comment and span_end is None and opening(marker):
            fence = marker[1]
            continue
        if not comment and span_end is None and line.startswith(('    ', '\t')):
            continue
        visible, column = list(line), 0
        while column < len(line):
            if span_end is not None:
                end = span_end[1] if span_end[0] == number else len(line)
                if mask_code_spans:
                    visible[column:end] = ' ' * (end - column)
                column = end
                if span_end[0] == number:
                    span_end = None
                continue
            if comment:
                end = line.find('-->', column)
                comment = end < 0
                end = len(line) if comment else end + 3
                visible[column:end] = ' ' * (end - column)
                column = end
            elif line[column] == '\\':
                column += 2  # Escaped punctuation cannot start a comment/span.
            elif line.startswith('<!--', column):
                comment = True
            elif line[column] == '`':
                run = re.match(r'`+', line[column:])[0]
                span_end = code_end(number, column + len(run), len(run))
                if span_end is None:
                    column += len(run)
            else:
                column += 1
        yield number + 1, ''.join(visible)


def language_settings(text, *, with_spans=False):
    """Actual column-zero settings; optionally include the editable value span."""
    settings = []
    literal_values = dict(markdown_prose_lines(text))
    for number, line in markdown_prose_lines(text, mask_code_spans=True):
        if re.match(r'Project Native Language:', line, re.I):
            # Mask examples when identifying a field, but do not silently remove
            # code markup from its value and accept a different configuration.
            setting = re.fullmatch(r'Project Native Language:[ \t]*(.*)', literal_values[number], re.I)
            value = setting[1].strip()
            start = setting.start(1) + len(setting[1]) - len(setting[1].lstrip())
            item = (number - 1, value)
            settings.append(item + (start, start + len(value)) if with_spans else item)
    return settings


def native_language(root):
    """Read actual configuration, excluding fenced and commented examples."""
    for name in ('AXIARCH.md', 'AGENTS.md'):
        path = inside(root, name)
        if not path.exists():
            continue
        if not path.is_file():
            raise ValueError('language protocol must be a regular file: ' + name)
        settings = language_settings(path.read_text())
        if len(settings) > 1:
            raise ValueError('ambiguous Project Native Language; resolve the canonical setting or specify a language')
        if settings:
            value = settings[0][1].lower()
            default = re.fullmatch(r'\[japanese\s*\|\s*english\]\s*\(default:\s*(japanese|english)\)', value)
            if default:
                value = default[1]
            elif value.startswith('[') and value.endswith(']'):
                value = value[1:-1]
            if value not in ('japanese', 'english'):
                raise ValueError('unsupported Project Native Language; specify ja/en explicitly or fix the setting')
            return 'en' if value == 'english' else 'ja'
    return 'en' if (root / 'axiarch-rules/en').is_dir() and not (root / 'axiarch-rules/ja').is_dir() else 'ja'


def atomic(path, value):
    content = json.dumps(value, ensure_ascii=False, indent=2, allow_nan=False) + "\n"
    path.parent.mkdir(parents=True, exist_ok=True)
    fd, tmp = tempfile.mkstemp(prefix=".write-", dir=path.parent)
    try:
        with os.fdopen(fd, "w", encoding="utf-8") as stream:
            stream.write(content)
            stream.flush()
            os.fsync(stream.fileno())
        os.replace(tmp, path)
    finally:
        if os.path.exists(tmp):
            os.unlink(tmp)


def privacy_check(root):
    """Check accidental Git exposure, never inspect or print private file contents."""
    meta = inside(root, '.axiarch')
    # Do not let inherited repository overrides or configured callbacks redirect
    # this read-only check to another checkout or execute user filters.
    env = {k: v for k, v in os.environ.items() if not k.startswith('GIT_')}
    env.update(GIT_CONFIG_GLOBAL=os.devnull, GIT_CONFIG_NOSYSTEM='1', GIT_OPTIONAL_LOCKS='0')
    command = ['git', '-c', 'core.fsmonitor=false', '-C', str(root)]

    def git(*args, content=None):
        try:
            return subprocess.run(command + list(args), input=content, capture_output=True,
                                  env=env, timeout=10, check=False)
        except (OSError, subprocess.TimeoutExpired) as exc:
            raise ValueError('private artifact Git check unavailable; inspect locally before sharing') from exc

    repository = git('rev-parse', '--is-inside-work-tree') if shutil.which('git') else None
    if repository is None or repository.returncode != 0 or repository.stdout.strip() != b'true':
        if any((parent / '.git').exists() for parent in (root, *root.parents)):
            raise ValueError('private artifact Git check failed; repository state unassessed')
        if not meta.exists():
            return 'No managed artifacts or Git worktree; tracking unassessed.'
        policy = inside(root, '.axiarch/.gitignore')
        if not policy.is_file() or not set(PRIVATE_PATTERNS) <= set(policy.read_text().splitlines()):
            raise ValueError('private artifact exclusions missing; run session resume or an approved install/upgrade')
        return 'Local exclusion policy present; no Git worktree, so index tracking is unassessed.'
    paths = ['.axiarch/' + name for name in PRIVATE_DIRS + PRIVATE_FILES]
    tracked = git('ls-files', '-z', '--', *paths)
    unignored = git('ls-files', '--others', '--exclude-standard', '-z', '--', *paths)
    if tracked.returncode or unignored.returncode:
        raise ValueError('private artifact Git check failed; tracking/exclusions unassessed')
    if tracked.stdout:
        raise ValueError('tracked private artifacts detected; review the index and history locally; no files were untracked')
    if unignored.stdout:
        raise ValueError('unignored private artifacts detected; inspect local ignore rules before sharing')
    probes = [('.axiarch/' + name + '/axiarch-private-probe').encode() for name in PRIVATE_DIRS]
    probes += [('.axiarch/' + name).encode() for name in PRIVATE_FILES]
    ignored = git('check-ignore', '--no-index', '-z', '--stdin', content=b'\0'.join(probes) + b'\0')
    if ignored.returncode != 0 or set(ignored.stdout.rstrip(b'\0').split(b'\0')) != set(probes):
        raise ValueError('private artifact exclusions missing; inspect local ignore rules before sharing')
    return 'Private artifact Git exclusions/index checked; contents, history and other sharing channels require review.'


def protect_artifacts(root):
    """Append narrow local exclusions under a separate cooperating-writer lock.

    Existing project rules are retained. This is not encryption, redaction, or
    protection against forced staging, historical commits or non-Git uploaders.
    """
    meta = inside(root, '.axiarch')
    meta.mkdir(mode=0o700, parents=True, exist_ok=True)
    policy = inside(root, '.axiarch/.gitignore')
    lock = inside(root, '.axiarch/privacy.lock')
    fd = os.open(lock, os.O_RDWR | os.O_CREAT | os.O_NOFOLLOW | os.O_NONBLOCK, 0o600)
    try:
        info = os.fstat(fd)
        if not stat.S_ISREG(info.st_mode) or info.st_uid != os.geteuid() or info.st_nlink != 1:
            raise ValueError('unsafe private artifact lock')
        fcntl.flock(fd, fcntl.LOCK_EX | fcntl.LOCK_NB)
        content = b''
        mode = 0o600
        if policy.exists():
            policy_fd = os.open(policy, os.O_RDONLY | os.O_NOFOLLOW | os.O_NONBLOCK)
            with os.fdopen(policy_fd, 'rb') as stream:
                info = os.fstat(stream.fileno())
                if not stat.S_ISREG(info.st_mode) or info.st_uid != os.geteuid() or info.st_nlink != 1:
                    raise ValueError('private artifact exclusions require an owned, unlinked regular file')
                content = stream.read()
                mode = stat.S_IMODE(info.st_mode)
        lines = content.decode('utf-8').splitlines()
        missing = [p for p in PRIVATE_PATTERNS if p not in lines]
        if missing:
            addition = '\n# Axiarch local runtime artifacts; review before sharing\n' + '\n'.join(missing) + '\n'
            write_fd, tmp = tempfile.mkstemp(prefix='.privacy-', dir=meta)
            try:
                with os.fdopen(write_fd, 'wb') as stream:
                    stream.write(content + addition.encode('utf-8'))
                    stream.flush(); os.fsync(stream.fileno())
                    os.fchmod(stream.fileno(), mode)
                os.replace(tmp, policy)
            finally:
                if os.path.exists(tmp):
                    os.unlink(tmp)
        privacy_check(root)
    finally:
        os.close(fd)


@contextmanager
def locked(root):
    state_root = inside(root, ".axiarch")
    state_root.mkdir(exist_ok=True)
    lock = inside(root, ".axiarch/task-state.lock")
    fd = os.open(lock, os.O_RDWR | os.O_CREAT | os.O_NOFOLLOW | os.O_NONBLOCK, 0o600)
    with os.fdopen(fd, "a") as stream:
        info = os.fstat(stream.fileno())
        if not stat.S_ISREG(info.st_mode) or info.st_uid != os.geteuid() or info.st_nlink != 1:
            raise ValueError('task lock must be a regular file owned by this user with one link')
        try:
            fcntl.flock(stream, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError as exc:
            raise ValueError("task state is busy; retry after the other writer finishes") from exc
        try:
            yield
        finally:
            fcntl.flock(stream, fcntl.LOCK_UN)


def concrete(value):
    return isinstance(value, str) and bool(value.strip()) and not PLACEHOLDER.search(value)


def validate(data, root, phase, current=None):
    errors = []

    def need(ok, message):
        if not ok:
            errors.append(message)

    if not isinstance(data, dict):
        return ["state must be an object"]
    need(type(data.get("schema_version")) is int and data["schema_version"] == 1, "schema_version must be 1")
    for key in ("task_id", "owner", "goal", "phase"):
        need(isinstance(data.get(key), str), f"{key}: string required")
    try:
        identifier(data.get("task_id"))
    except (ValueError, TypeError):
        errors.append("task_id: invalid ID")
    need(type(data.get("revision")) is int and data["revision"] >= 0, "invalid revision")
    need(data.get("phase") in {"draft", "active", "complete"}, "invalid phase")
    need(type(data.get("max_age_seconds")) is int and data["max_age_seconds"] > 0, "max_age_seconds must be positive")
    criteria = data.get("criteria")
    if not isinstance(criteria, list):
        return errors + ["criteria must be a list"]
    strict = phase != "structure" or data.get("phase") in {"active", "complete"}
    current = phase != "structure" if current is None else current
    closing = phase == "completion" or data.get("phase") == "complete"
    if strict:
        need(concrete(data.get("goal")) and concrete(data.get("owner")), "goal and owner must be filled in")
        need(bool(criteria), "at least one completion criterion is required")
    ids = set()
    for c in criteria:
        if not isinstance(c, dict):
            errors.append("criterion must be an object")
            continue
        cid = c.get("id")
        try:
            identifier(cid)
        except (ValueError, TypeError):
            errors.append("invalid criterion ID")
            continue
        need(cid not in ids, f"{cid}: duplicate criterion ID")
        ids.add(cid)
        need(c.get("state") in STATES, f"{cid}: invalid state")
        need(type(c.get("verified")) is bool, f"{cid}: verified must be boolean")
        for field in ("owner", "description", "verification"):
            need(isinstance(c.get(field), str), f"{cid}: {field} must be a string")
            if strict:
                need(concrete(c.get(field)), f"{cid}: {field} is blank or a template")
        evidence = c.get("evidence")
        need(isinstance(evidence, list), f"{cid}: evidence must be a list")
        checked = c.get("checked_at")
        verified = c.get("verified") is True
        if c.get("state") == "done":
            need(verified, f"{cid}: done requires verified=true")
        if c.get("state") == "discarded":
            need(concrete(c.get("reason")), f"{cid}: discarded requires a reason")
        if closing:
            need(c.get("state") == "done", f"{cid}: completion criterion not done; discarded is not completion")
        if not verified:
            need(checked is None and not evidence, f"{cid}: unverified cannot claim a check time or evidence")
            need(c.get("target") is None, f"{cid}: unverified target snapshot must be null")
            continue
        need(bool(evidence), f"{cid}: verified requires evidence")
        try:
            stamp = datetime.fromisoformat(checked.replace("Z", "+00:00"))
            age = (datetime.now(timezone.utc) - stamp).total_seconds()
            need(age >= -60, f"{cid}: check time is in the future")
            if current:
                need(age <= data.get("max_age_seconds", 0), f"{cid}: verification expired; recheck or mark unverified")
        except (AttributeError, TypeError, ValueError):
            errors.append(f"{cid}: checked_at requires an ISO timestamp with timezone")
        refs = [c.get("target")] + (evidence if isinstance(evidence, list) else [])
        for ref in refs:
            try:
                if not isinstance(ref, dict) or not re.fullmatch(r"[a-f0-9]{64}", ref.get("sha256", "")):
                    raise ValueError("path and SHA-256 required")
                path = inside(root, ref.get("path"))
                if current:
                    need(digest(path) == ref["sha256"], f"{cid}: changed snapshot {ref['path']}")
            except (OSError, ValueError, TypeError) as exc:
                errors.append(f"{cid}: invalid target/evidence: {exc}")
    return errors


def scaffold(args, root, task_id, session_id, session_dir):
    session_dir.parent.mkdir(parents=True, exist_ok=True)
    staging = Path(tempfile.mkdtemp(prefix=".session-", dir=session_dir.parent))
    try:
        env = dict(os.environ, AXIARCH_PROCESS_DOC_LANG=args.lang)
        subprocess.run(["bash", str(Path(__file__).with_name("axiarch-task-state.sh")),
                        "--project", str(staging), "--mode", "render", "--quiet"],
                       env=env, check=True)
        for doc in DOCS:
            dest = inside(staging, doc)
            if not dest.is_file() or not dest.read_text(encoding='utf-8').strip():
                raise ValueError(f'renderer did not create a nonempty regular document: {doc}')
            legacy = root / doc
            if args.import_legacy and (legacy.exists() or legacy.is_symlink()):
                legacy = inside(root, doc)
                if not legacy.is_file():
                    raise ValueError(f'legacy evidence must be a regular file: {doc}')
                # Copy content into the new writable document, not the legacy
                # file's read-only permission bits. The original is untouched.
                shutil.copyfile(legacy, dest)
            with dest.open("a", encoding="utf-8") as stream:
                stream.write(f"\n<!-- AXIARCH_BINDING task_id={task_id} session_id={session_id} -->\n")
                stream.write(f"\n`state.json`: `.axiarch/tasks/{task_id}/state.json`\n")
        atomic(staging / "binding.json", {"task_id": task_id, "session_id": session_id, "created_at": now()})
        os.rename(staging, session_dir)
    finally:
        if staging.exists():
            shutil.rmtree(staging)


def resolve_ids(args, root):
    sid = args.session or os.environ.get("AXIARCH_SESSION_ID") or os.environ.get("CODEX_THREAD_ID")
    tid = args.task or os.environ.get("AXIARCH_TASK_ID")
    if sid:
        identifier(sid)
        binding = inside(root, f".axiarch/sessions/{sid}/binding.json")
        if binding.exists():
            record = read_json(binding)
            if record.get("session_id") != sid:
                raise ValueError("session ID/binding path mismatch")
            bound = identifier(record["task_id"])
            if tid and tid != bound:
                raise ValueError("session is already bound to another task; use a new session ID")
            tid = bound
    if tid:
        identifier(tid)
    return tid, sid


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--project", default=".")
    parser.add_argument("--mode", choices=["session-start", "new", "resume", "ensure", "status", "publish", "check", "path", "snapshot", "language", "privacy-check"], default="status")
    parser.add_argument("--task")
    parser.add_argument("--session")
    parser.add_argument("--owner", default="")
    parser.add_argument("--lang", choices=["ja", "en"], default="ja")
    parser.add_argument("--phase", choices=["structure", "readiness", "completion"], default="structure")
    parser.add_argument("--input")
    parser.add_argument("--expected-revision", type=int)
    parser.add_argument("--import-legacy", action="store_true")
    parser.add_argument("--quiet", action="store_true")
    args = parser.parse_args()
    root = Path(args.project).resolve(strict=True)
    if args.mode == 'privacy-check':
        result = privacy_check(root)
        if not args.quiet:
            print(result)
        return
    if args.mode == 'language':
        print(native_language(root))
        return
    if args.mode == "snapshot":
        path = inside(root, args.input)
        print(json.dumps({"path": args.input, "sha256": digest(path)}))
        return
    tid, sid = resolve_ids(args, root)
    if args.mode in {"session-start", "new", "resume", "ensure"}:
        with locked(root):
            tid, sid = resolve_ids(args, root)
            if args.mode == "resume" and not tid:
                raise ValueError("resume requires a known task or session ID")
            sid = sid or "session-" + uuid.uuid4().hex
            tid = tid or "task-" + uuid.uuid4().hex
            state_path = inside(root, f".axiarch/tasks/{tid}/state.json")
            session_dir = inside(root, f".axiarch/sessions/{sid}")
            if state_path.parent.exists() and not state_path.exists():
                raise ValueError(f'incomplete task directory: {tid}; inspect history and restore/reconcile before retrying')
            if session_dir.exists():
                if not (session_dir / 'binding.json').is_file():
                    raise ValueError('incomplete session directory; preserve it and use a new session ID')
                if not state_path.is_file():
                    raise ValueError('bound task state is missing; restore/reconcile it before resuming')
                for doc in DOCS:
                    if not inside(root, f'.axiarch/sessions/{sid}/{doc}').is_file():
                        raise ValueError(f'incomplete session document: {doc}; restore/reconcile before resuming')
            if args.mode == "new" and state_path.exists():
                raise ValueError("task already exists; use resume")
            if args.mode == "resume" and not state_path.is_file():
                raise ValueError("task does not exist")
            if state_path.exists():
                record = read_json(state_path)
                errors = validate(record, root, "structure")
                if record.get("task_id") != tid:
                    errors.append("task ID/path mismatch")
                if errors:
                    raise ValueError("; ".join(errors))
            new_task, new_session = not state_path.exists(), not session_dir.exists()
            protect_artifacts(root)
            try:
                if new_task:
                    atomic(state_path, {"schema_version": 1, "task_id": tid, "revision": 0,
                                        "owner": args.owner, "goal": "", "phase": "draft", "criteria": [],
                                        "max_age_seconds": 86400, "updated_at": now()})
                if new_session:
                    scaffold(args, root, tid, sid, session_dir)
            except Exception:
                # Cooperating writers hold this lock. Roll back only records that
                # were absent on entry; never remove a task being joined/resumed.
                # SIGKILL/power loss cannot use this cleanup; preserve leftovers
                # for explicit inspection instead of inventing replacement state.
                try:
                    if new_session and session_dir.exists():
                        shutil.rmtree(session_dir)
                    if new_task:
                        state_path.unlink(missing_ok=True)
                        if state_path.parent.exists():
                            state_path.parent.rmdir()
                except OSError as cleanup_error:
                    print(f'AXIARCH state: incomplete bootstrap task={tid} session={sid}; inspect retained files: {cleanup_error}', file=sys.stderr)
                raise
            # Root files are compatibility pointers only when absent. Never rotate another session.
            for doc in DOCS:
                pointer = root / doc
                try:
                    with pointer.open("x", encoding="utf-8") as stream:
                        stream.write("# Axiarch\n\n" + ("共有参照。作業記録はセッション別に保持します。" if args.lang == "ja" else "Shared reference. Work evidence is stored per session.") + "\n\n")
                        stream.write("`bash axiarch-scripts/axiarch-task-state.sh --mode status`\n\n")
                        stream.write("`.axiarch/tasks/` / `.axiarch/sessions/`\n")
                except FileExistsError:
                    pass
                except OSError as pointer_error:
                    # Compatibility references are optional; managed records have
                    # already been published and are usable even without them.
                    print(f'AXIARCH state: optional root pointer unavailable ({doc}): {pointer_error}', file=sys.stderr)
        if not args.quiet:
            print(f"[AXIARCH TASK STATE] task_id={tid} session_id={sid} docs={session_dir} state={state_path}")
        return
    if args.mode == "status":
        task_root = inside(root, ".axiarch/tasks")
        records = sorted(task_root.iterdir()) if task_root.exists() else []
        for directory in records:
            identifier(directory.name)
            directory = inside(root, directory.relative_to(root).as_posix())
            path = inside(root, f'.axiarch/tasks/{directory.name}/state.json')
            if not directory.is_dir() or not path.is_file():
                raise ValueError(f'incomplete task directory: {directory.name}; inspect and restore/reconcile')
            record = read_json(path)
            errors = validate(record, root, "structure")
            if record.get("task_id") != path.parent.name:
                errors.append("task ID/path mismatch")
            if errors:
                raise ValueError(f"{path}: " + "; ".join(errors))
            print(json.dumps({k: record[k] for k in ("task_id", "owner", "phase", "revision", "updated_at")}, ensure_ascii=False))
        if not records and not args.quiet:
            print("No managed tasks; legacy root documents are preserved.")
        return
    if args.mode == "path":
        if not sid or not inside(root, f".axiarch/sessions/{sid}/binding.json").is_file():
            raise ValueError("known session ID required")
        print(inside(root, f".axiarch/sessions/{sid}"))
        return
    if not tid:
        raise ValueError("explicit task or bound session ID required; never select another session implicitly")
    state_path = inside(root, f".axiarch/tasks/{tid}/state.json")
    if args.mode == "publish":
        if not sid or not inside(root, f".axiarch/sessions/{sid}/binding.json").is_file():
            raise ValueError("publish requires a bound session")
        candidate = read_json(Path(args.input))
        with locked(root):
            old = read_json(state_path)
            errors = validate(old, root, "structure") + validate(candidate, root, "structure", current=True)
            if old.get("task_id") != tid:
                errors.append("stored task ID/path mismatch")
            if errors:
                raise ValueError("; ".join(errors))
            if args.expected_revision != old["revision"] or candidate.get("revision") != old["revision"]:
                raise ValueError("revision conflict; reread state, reconcile and retry")
            if candidate.get("task_id") != tid:
                raise ValueError("task ID mismatch")
            if old.get("phase") != "draft" and candidate.get("phase") == "draft":
                raise ValueError("active/complete task cannot return to an uninitialized draft")
            def scope(record):
                return (record.get("goal"), [(c.get("id"), c.get("description"), c.get("verification"))
                                             for c in record.get("criteria", [])])
            if old.get("phase") != "draft" and scope(old) != scope(candidate):
                change = candidate.get("scope_change", {})
                if not isinstance(change, dict) or not all(concrete(change.get(k)) for k in ("reason", "approval_ref")):
                    raise ValueError("frozen goal/criteria changed; record scope_change reason and approval_ref")
            # Publication makes a new claim now; structure-only reads of historical
            # records deliberately do not claim that their snapshots remain current.
            if candidate.get("phase") == "complete":
                errors += check_docs(root, sid, tid)
            if errors:
                raise ValueError("; ".join(errors))
            new = copy.deepcopy(candidate)
            new.update(revision=old["revision"] + 1, updated_at=now(), updated_by=sid)
            # Immutable prior revisions survive an interrupted publication; retry is idempotent.
            history = inside(root, f".axiarch/tasks/{tid}/history/{old['revision']}.json")
            if history.exists() and read_json(history) != old:
                raise ValueError("history conflict; manual reconciliation required")
            atomic(history, old)
            atomic(state_path, new)
        if not args.quiet:
            print(f"revision={new['revision']}")
    else:
        data = read_json(state_path)
        errors = validate(data, root, args.phase)
        if data.get("task_id") != tid:
            errors.append("task ID/path mismatch")
        if args.phase == "completion":
            errors += check_docs(root, sid or data.get("updated_by"), tid)
        if errors:
            raise ValueError("; ".join(errors))
        if not args.quiet:
            print(f"{args.phase}: PASS (record consistency only; semantic review required)")


def check_docs(root, sid, tid):
    if not sid:
        return ["completion needs a session with reviewed Markdown evidence"]
    identifier(sid)
    errors = []
    binding = read_json(inside(root, f".axiarch/sessions/{sid}/binding.json"))
    if binding.get("session_id") != sid or binding.get("task_id") != tid:
        errors.append("completion evidence session is not bound to this task")
    for name in DOCS:
        path = inside(root, f".axiarch/sessions/{sid}/{name}")
        if not path.is_file() or not path.read_text().strip() or PLACEHOLDER.search(path.read_text()):
            errors.append(f"{name}: missing, empty or remaining template")
    return errors


if __name__ == "__main__":
    try:
        main()
    except (ValueError, OSError, KeyError, TypeError, subprocess.CalledProcessError) as error:
        print(f"AXIARCH state: {error}", file=sys.stderr)
        sys.exit(2)
