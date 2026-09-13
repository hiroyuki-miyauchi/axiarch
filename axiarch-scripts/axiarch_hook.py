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
    parser.add_argument('mode', choices=('normalize', 'session', 'prompt', 'emit', 'cache'))
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
