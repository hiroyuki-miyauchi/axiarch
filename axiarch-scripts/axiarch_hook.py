#!/usr/bin/env python3
"""Strict hook input, JSON context output and disposable reminder cache."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import stat
import sys
import tempfile
import time

sys.dont_write_bytecode = True
from axiarch_state import identifier, strict_json


def codex_command(script):
    """Portable launcher: nearest canonical project, including non-Git folders.

    This fixed command is also recognized by the read-only wiring inspector.
    Never evaluate arbitrary configuration while diagnosing it.
    """
    if script not in ('axiarch-init-task-md.sh', 'axiarch-boot-reminder.sh',
                      'axiarch-protect-antifull.sh', 'axiarch-diff-guard.sh'):
        raise ValueError('unsupported hook script')
    return ('axiarch_root="$PWD"; while [ ! -f "$axiarch_root/AXIARCH.md" ]; do '
            '[ "$axiarch_root" != / ] || { printf "%s\\n" '
            '"Axiarch hook: project root unresolved / 正本の場所を特定できません" >&2; exit 2; }; '
            'axiarch_root=${axiarch_root%/*}; '
            '[ -n "$axiarch_root" ] || axiarch_root=/; done; '
            'CLAUDE_PROJECT_DIR="$axiarch_root" AXIARCH_HOOK_AGENT=codex '
            'bash "$axiarch_root/axiarch-scripts/' + script + '"')


def working_directory(data, project):
    value = data.get('cwd', project)
    if not isinstance(value, str) or not value or '\x00' in value or not os.path.isabs(value):
        raise ValueError('hook cwd must be an absolute directory')
    if not os.path.isdir(value):
        raise ValueError('hook cwd is unavailable')
    return value


def active_project(data, project):
    if 'cwd' not in data:
        return project  # Backward-compatible direct invocation without a payload.
    directory = Path(working_directory(data, project)).resolve()
    for candidate in (directory, *directory.parents):
        if (candidate / 'AXIARCH.md').is_file():
            return str(candidate)
    raise ValueError('no AXIARCH.md above hook cwd; original checkout was not substituted')


def patch_destinations(data, project):
    """Inspect the native apply_patch envelope; never run or modify the patch.

    Add and move destinations are checked against the original filesystem,
    including delete/add pairs. Update hunks remain the agent's diff review.
    Unknown patch syntax fails closed rather than guessing a destination.
    """
    cwd = working_directory(data, project)
    value = data.get('tool_input')
    patch = value.get('command') if isinstance(value, dict) else None
    if not isinstance(patch, str) or '\x00' in patch:
        raise ValueError('apply_patch requires tool_input.command patch text')
    # Native Rust str::lines splits LF/CRLF only. Python splitlines also splits
    # NEL, vertical tab and Unicode separators that may be part of a filename;
    # treating them as patch boundaries could miss an existing destination.
    lines = [line[:-1] if line.endswith('\r') else line
             for line in patch.strip().split('\n')]
    if len(lines) < 3 or lines[0] != '*** Begin Patch' or lines[-1] != '*** End Patch':
        raise ValueError('unsupported apply_patch envelope')
    kind = None
    destinations = []
    can_move = False
    for line in lines[1:-1]:
        operation = next((op for op in ('Add File', 'Update File', 'Delete File', 'Move to')
                          if line.startswith('*** ' + op + ': ')), None)
        if operation:
            name = line[len('*** ' + operation + ': '):]
            if not name:
                raise ValueError('empty patch path')
            if name != name.strip():
                raise ValueError('ambiguous whitespace in patch path; use the exact unpadded path')
            if operation == 'Move to':
                if kind != 'Update File' or not can_move:
                    raise ValueError('misplaced patch move')
                can_move = False
            else:
                kind = operation
                can_move = kind == 'Update File'
            if operation in ('Add File', 'Move to'):
                destinations.append(os.path.join(cwd, name))
        elif kind == 'Add File' and line.startswith('+'):
            pass
        elif kind == 'Update File' and (line.startswith((' ', '+', '-', '@@'))
                                       or line == '*** End of File' or not line):
            can_move = False
        else:
            raise ValueError('unsupported apply_patch body')
    return destinations


def protect_patch(data, project):
    import fnmatch
    allow = Path(project) / '.codex/axiarch-overwrite-allow.txt'
    patterns = []
    if allow.exists() or allow.is_symlink():
        fd = os.open(allow, os.O_RDONLY | os.O_NOFOLLOW | os.O_NONBLOCK)
        with os.fdopen(fd) as stream:
            if not stat.S_ISREG(os.fstat(stream.fileno()).st_mode):
                raise ValueError('overwrite allowlist must be a regular file')
            patterns = [line.strip() for line in stream if line.strip() and not line.lstrip().startswith('#')]
    for path in patch_destinations(data, project):
        if os.path.lexists(path) and not any(fnmatch.fnmatchcase(os.path.realpath(path),
                os.path.join(os.path.realpath(project), pattern)) for pattern in patterns):
            reason = ('AXIARCH.md Anti-Full-Overwrite: apply_patch add/move destination already exists; '
                      'use a focused Update File diff. / 新規作成・移動先が既存です。差分編集を使ってください。 '
                      'Intentional replacement requires recorded approval and the Codex allowlist. / '
                      '意図した置換は承認を記録しCodexの許可リストへ指定してください。')
            print(json.dumps({'hookSpecificOutput': {'hookEventName': 'PreToolUse',
                              'permissionDecision': 'deny', 'permissionDecisionReason': reason}}))
            print(reason, file=sys.stderr)
            return 2
    return 0


def payload(text):
    data = strict_json(text) if text.strip() else {}
    if not isinstance(data, dict):
        raise ValueError('hook input must be a JSON object')
    return data


def session_id(data):
    explicit = os.environ.get('AXIARCH_SESSION_ID') or os.environ.get('CODEX_THREAD_ID')
    if explicit:
        return identifier(explicit)
    ids = [identifier(data[key]) for key in ('session_id', 'sessionId') if key in data]
    if len(set(ids)) > 1:
        raise ValueError('conflicting session_id/sessionId')
    return ids[0] if ids else ''


def use_short(args):
    """Cache affects verbosity only. Invalid input falls back to full output."""
    try:
        if not re.fullmatch(r'[0-9]{1,10}', args.ttl) or int(args.ttl) > 2147483647:
            raise ValueError('TTL must be decimal seconds from 0 to 2147483647')
        ttl = int(args.ttl)
        if not ttl:
            return False
        key = hashlib.sha1(f'{args.project}:{args.session or "legacy"}'.encode()).hexdigest()[:12]
        directory = Path(os.environ.get('TMPDIR') or '/tmp')
        path = directory / f'axiarch-reminder-{key}.timestamp'
        current = int(time.time())
        previous = None
        try:
            fd = os.open(path, os.O_RDONLY | os.O_NOFOLLOW | os.O_NONBLOCK)
        except FileNotFoundError:
            pass
        else:
            with os.fdopen(fd, 'rb') as stream:
                info = os.fstat(stream.fileno())
                if not stat.S_ISREG(info.st_mode) or info.st_uid != os.getuid() or info.st_nlink != 1:
                    raise ValueError('cache must be a private regular file')
                raw = stream.read(33).strip()
                if re.fullmatch(rb'[0-9]{1,12}', raw):
                    previous = int(raw)
            if not args.force_full and previous is not None and 0 <= current - previous < ttl:
                return True
        fd, temporary = tempfile.mkstemp(prefix='.axiarch-reminder-', dir=directory)
        try:
            with os.fdopen(fd, 'w') as stream:
                stream.write(str(current) + '\n')
                stream.flush(); os.fsync(stream.fileno())
            os.replace(temporary, path)
        finally:
            if os.path.exists(temporary):
                os.unlink(temporary)
        return False
    except (OSError, ValueError) as error:
        print(f'Axiarch reminder cache: {error}; use full reminder.', file=sys.stderr)
        return False


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('mode', choices=('normalize', 'session', 'prompt', 'emit', 'cache', 'protect-patch', 'project'))
    parser.add_argument('--event', choices=('SessionStart', 'UserPromptSubmit'))
    parser.add_argument('--project', default='')
    parser.add_argument('--session', default='')
    parser.add_argument('--ttl', default='1800')
    parser.add_argument('--force-full', action='store_true')
    args = parser.parse_args()
    if args.mode == 'cache':
        print('true' if use_short(args) else 'false')
        return
    text = sys.stdin.read()
    if args.mode == 'emit':
        if not args.event:
            raise ValueError('event required for context output')
        print(json.dumps({'hookSpecificOutput': {'hookEventName': args.event, 'additionalContext': text}}))
        return
    data = payload(text)
    if args.mode == 'project':
        # Bash command substitution discards trailing newlines; preserve the
        # exact path through a final sentinel removed by each shell caller.
        print(active_project(data, args.project) + '.')
        return
    if args.mode == 'protect-patch':
        sys.exit(protect_patch(data, args.project))
    if args.mode == 'normalize':
        # Validate raw input before Bash can discard NUL bytes. ASCII JSON also
        # transports escaped control characters without changing their meaning.
        print(json.dumps(data))
    elif args.mode == 'session':
        print(session_id(data))
    else:
        prompt = data.get('prompt', '')
        if not isinstance(prompt, str) or '\x00' in prompt:
            raise ValueError('prompt must be a string without NUL')
        print(prompt)


if __name__ == '__main__':
    try:
        main()
    except (ValueError, OSError, TypeError) as error:
        print(f'Axiarch hook input: {error}', file=sys.stderr)
        sys.exit(2)
