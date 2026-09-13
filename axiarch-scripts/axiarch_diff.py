#!/usr/bin/env python3
"""Read-only Git diff measurement for the optional PostToolUse hook."""
import json
import os
from pathlib import Path
import re
import stat
import subprocess
import sys

sys.dont_write_bytecode = True


def git(root, *args, allowed=(0,), data=None, config=()):
    # Measure the explicitly selected checkout, not a caller's alternate Git
    # directory/index/config. Keep overrides process-local and suppress optional
    # writes, prompts and lazy object downloads during this observation.
    env = {k: v for k, v in os.environ.items() if not k.startswith('GIT_')}
    env.update(GIT_CONFIG_GLOBAL=os.devnull, GIT_CONFIG_NOSYSTEM='1', GIT_OPTIONAL_LOCKS='0',
               GIT_TERMINAL_PROMPT='0', GIT_NO_LAZY_FETCH='1')
    options = [arg for setting in config for arg in ('-c', setting)]
    # An unsupported --no-lazy-fetch is an explicit unassessed result, rather
    # than silently ignoring an environment flag and invoking a remote helper.
    result = subprocess.run(['git', '--no-pager', '--no-lazy-fetch', '-c', 'core.fsmonitor=false',
                             '-C', str(root), *options, *args],
                            input=data, stdout=subprocess.PIPE, stderr=subprocess.PIPE, timeout=10,
                            env=env)
    if result.returncode not in allowed:
        raise ValueError('Git measurement failed (' + args[0] + ')')
    return result


def filter_overrides(root):
    # --no-ext-diff/--no-textconv do not suppress worktree clean/process
    # conversion. Enumerate effective keys (including local includes and
    # worktree config), never command values, then disable each driver only for
    # this subprocess. A failed inventory must not fall through to git diff.
    raw = git(root, 'config', '--null', '--name-only', '--get-regexp',
              r'^filter\..*\.(clean|smudge|process|required)$', allowed=(0, 1)).stdout
    if raw and not raw.endswith(b'\0'):
        raise ValueError('Incomplete Git filter inventory')
    drivers = set()
    for key in raw.split(b'\0'):
        if not key:
            continue
        name = os.fsdecode(key)
        if not re.fullmatch(r'filter\..+\.(clean|smudge|process|required)', name) or any(
                ord(c) < 32 or ord(c) == 127 or c == '=' for c in name):
            raise ValueError('Unsupported Git filter configuration key')
        drivers.add(name.rsplit('.', 1)[0])
    return [driver + suffix for driver in sorted(drivers)
            for suffix in ('.clean=', '.smudge=', '.process=', '.required=false')]


def threshold(name, default):
    value = os.environ.get(name, str(default))
    if not re.fullmatch(r'[0-9]{1,10}', value) or int(value) > 2147483647:
        raise ValueError(name + ' must be decimal 0..2147483647 (1..10 digits)')
    return int(value)


def untracked_lines(root, relative):
    """Never follow a listed symlink, including a replaced parent directory."""
    parts = relative.split('/')
    if any(part in ('', '.', '..') for part in parts):
        raise ValueError('Invalid untracked path')
    directory = os.open(root, os.O_RDONLY | os.O_DIRECTORY | os.O_NOFOLLOW)
    try:
        for part in parts[:-1]:
            child = os.open(part, os.O_RDONLY | os.O_DIRECTORY | os.O_NOFOLLOW, dir_fd=directory)
            os.close(directory)
            directory = child
        before = os.stat(parts[-1], dir_fd=directory, follow_symlinks=False)
        if stat.S_ISLNK(before.st_mode):
            return 0  # The link is one changed file, never its target's content.
        if not stat.S_ISREG(before.st_mode):
            raise ValueError('Unsupported untracked file type')
        fd = os.open(parts[-1], os.O_RDONLY | os.O_NOFOLLOW | os.O_NONBLOCK, dir_fd=directory)
        with os.fdopen(fd, 'rb') as stream:
            opened = os.fstat(stream.fileno())
            if not stat.S_ISREG(opened.st_mode) or (before.st_dev, before.st_ino) != (opened.st_dev, opened.st_ino):
                raise ValueError('Untracked file changed during measurement')
            lines = size = 0
            binary = False
            last = b''
            while True:
                chunk = stream.read(65536)
                if not chunk:
                    break
                size += len(chunk)
                lines += chunk.count(b'\n')
                binary = binary or b'\x00' in chunk
                last = chunk[-1:]
            after = os.fstat(stream.fileno())
            if (opened.st_size, opened.st_mtime_ns, opened.st_ctime_ns) != (after.st_size, after.st_mtime_ns, after.st_ctime_ns):
                raise ValueError('Untracked file changed during measurement')
            return 0 if binary else lines + int(size > 0 and last != b'\n')
    finally:
        os.close(directory)


def measure(project, include_untracked):
    root_output = git(project, 'rev-parse', '--show-toplevel').stdout
    root = Path(os.fsdecode(root_output[:-1] if root_output.endswith(b'\n') else root_output)).resolve()
    try:
        Path(project).resolve().relative_to(root)
    except ValueError as exc:
        raise ValueError('Selected project is outside the resolved Git worktree') from exc
    filters = filter_overrides(root)
    head = git(root, 'rev-parse', '--verify', '-q', 'HEAD^{commit}', allowed=(0, 1, 128))
    if head.returncode == 0:
        baseline = head.stdout.strip().decode('ascii')
    else:
        # Only a symbolic HEAD whose branch does not exist is an unborn branch.
        reference = os.fsdecode(git(root, 'symbolic-ref', '-q', 'HEAD').stdout.rstrip(b'\n'))
        missing = git(root, 'show-ref', '--verify', '--quiet', reference, allowed=(0, 1))
        if missing.returncode != 1:
            raise ValueError('HEAD cannot be inspected')
        baseline = git(root, 'hash-object', '-t', 'tree', '--stdin', data=b'').stdout.strip().decode('ascii')
    raw = git(root, 'diff', '--numstat', '-z', '--no-ext-diff', '--no-textconv', '--no-renames',
              '--ignore-submodules=none', baseline, '--', config=filters).stdout
    lines = files = 0
    if raw and not raw.endswith(b'\0'):
        raise ValueError('Incomplete Git diff statistics')
    for entry in raw.split(b'\0'):
        if not entry:
            continue
        fields = entry.split(b'\t', 2)
        if len(fields) != 3 or not fields[2]:
            raise ValueError('Invalid Git diff statistics')
        for count in fields[:2]:
            if count != b'-' and not re.fullmatch(rb'[0-9]+', count):
                raise ValueError('Invalid Git line count')
            lines += 0 if count == b'-' else int(count)
        files += 1
    if include_untracked:
        raw = git(root, 'ls-files', '--others', '--exclude-standard', '-z').stdout
        if raw and not raw.endswith(b'\0'):
            raise ValueError('Incomplete untracked file list')
        for name in raw.split(b'\0'):
            if name:
                files += 1
                lines += untracked_lines(root, os.fsdecode(name))
    return lines, files


def emit(mode, reason):
    if mode == 'block':
        print(json.dumps({'decision': 'block', 'reason': reason}, ensure_ascii=True))
        code = 2
    else:
        print(json.dumps({'hookSpecificOutput': {'hookEventName': 'PostToolUse', 'additionalContext': reason}}, ensure_ascii=True))
        code = 0
    print('[axiarch:diff-guard] ' + reason, file=sys.stderr)
    return code


def main():
    mode = os.environ.get('AXIARCH_DIFF_GUARD_MODE', 'warn')
    if mode == 'off' or os.environ.get('AXIARCH_DIFF_GUARD_ALLOW') == '1':
        return 0
    try:
        if os.environ.get('AXIARCH_DIFF_INPUT_ERROR'):
            raise ValueError('hook input or active project unresolved; no alternate checkout inspected')
        if mode not in ('warn', 'block'):
            mode = 'warn'
            raise ValueError('AXIARCH_DIFF_GUARD_MODE must be warn, block or off')
        if os.name != 'posix':
            raise ValueError('AXIARCH_PLATFORM_UNSUPPORTED: use Linux Python inside WSL 2. '
                             'WindowsではWSL 2内のLinux Pythonを使用してください。')
        max_lines = threshold('AXIARCH_DIFF_GUARD_MAX_LINES', 400)
        max_files = threshold('AXIARCH_DIFF_GUARD_MAX_FILES', 20)
        include = os.environ.get('AXIARCH_DIFF_GUARD_INCLUDE_UNTRACKED', '1')
        if include not in ('0', '1'):
            raise ValueError('AXIARCH_DIFF_GUARD_INCLUDE_UNTRACKED must be 0 or 1')
        project = os.environ.get('CLAUDE_PROJECT_DIR') or str(Path(__file__).resolve().parent.parent)
        lines, files = measure(project, include == '1')
        if lines <= max_lines and files <= max_files:
            return 0
        reason = (f'Axiarch diff guard: Changed lines={lines}/{max_lines}, files={files}/{max_files}. '
                  '現在の差分が大きくなっています。解決済みのセッション記録先で意図・範囲・検証方針を確認し、必要なら分割してください。'
                  '記録先は axiarch-scripts/axiarch-task-state.sh --mode path --session ID で確認します。'
                  'Review intent, scope and verification in the resolved session records; split changes when appropriate. '
                  'This is a post-edit observation; it does not undo the edit or establish rule loading.')
    except (OSError, ValueError, subprocess.TimeoutExpired) as exc:
        reason = ('[DIFF GUARD UNASSESSED] 差分量を確認できません。小差分・正常とは判定していません。'
                  'Diff size is unassessed, not a successful small-diff result: ' + str(exc))
    return emit(mode, reason)


if __name__ == '__main__':
    sys.exit(main())
