#!/usr/bin/env python3
"""Read-only lesson and hook declaration checks; not proof of runtime adherence."""
import argparse
from collections import Counter
from datetime import date
import json
import os
from pathlib import Path
import re
import shlex
import sys

sys.dont_write_bytecode = True
from axiarch_state import inside, read_json, markdown_prose_lines


HOOK_CONTRACTS = {
    'UserPromptSubmit': ('axiarch-boot-reminder.sh', ('prompt',)),
    'SessionStart': ('axiarch-init-task-md.sh', ('startup', 'resume', 'clear', 'compact', 'fork')),
    'PreToolUse': ('axiarch-protect-antifull.sh', ('Write',)),
    'PostToolUse': ('axiarch-diff-guard.sh', ('Edit', 'MultiEdit', 'Write')),
}


def declared_matches(matcher, event, targets):
    """Recognize a portable subset; never evaluate user-provided regex or shell."""
    if not isinstance(matcher, str):
        return set()
    if event == 'UserPromptSubmit' or matcher in ('', '*', '.*', '^.*$'):
        return set(targets)
    if matcher.startswith('^') and matcher.endswith('$'):
        matcher = matcher[1:-1]
    if matcher.startswith('(') and matcher.endswith(')'):
        matcher = matcher[1:-1]
        if matcher.startswith('?:'):
            matcher = matcher[2:]
    if not re.fullmatch(r'[A-Za-z0-9_]+(?:\|[A-Za-z0-9_]+)*', matcher):
        return set()
    return set(matcher.split('|')) & set(targets)


def declared_script(handler, root, script):
    """Accept direct script/bash invocations only, without executing commands."""
    if not isinstance(handler, dict) or handler.get('type') != 'command':
        return False
    if handler.get('async', False) is not False or handler.get('if') not in (None, ''):
        return False
    command = handler.get('command')
    if not isinstance(command, str) or any(ord(c) < 32 or ord(c) == 127 for c in command):
        return False
    if 'args' in handler:
        args = handler['args']
        if not isinstance(args, list) or any(not isinstance(arg, str) for arg in args):
            return False
        words = [command, *args]
    else:
        # shlex removes quote provenance; do not mistake a single-quoted literal
        # variable for the expandable project path used by the bundled adapter.
        if "'" in command and '$' in command:
            return False
        try:
            words = shlex.split(command)
        except ValueError:
            return False
    via_bash = bool(words and words[0] in ('bash', '/bin/bash', '/usr/bin/bash'))
    if via_bash:
        words = words[1:]
        if words[:1] == ['--']:
            words = words[1:]
    if len(words) != 1:
        return False
    relative = 'axiarch-scripts/' + script
    accepted = {relative, './' + relative, str(root / relative)}
    for variable in ('CLAUDE_PROJECT_DIR', 'CODEX_PROJECT_DIR'):
        for prefix in ('$' + variable, '${' + variable + '}', '${' + variable + ':-.}'):
            accepted.add(prefix + '/' + relative)
    if words[0] not in accepted:
        return False
    path = inside(root, relative)
    return path.is_file() and os.access(path, os.R_OK if via_bash else os.R_OK | os.X_OK)


def inspect_hooks(root, event=None):
    reports = []
    events = [event] if event else list(HOOK_CONTRACTS)
    for relative in ('.claude/settings.json', '.codex/hooks.json'):
        path = root / relative
        if not path.exists() and not path.is_symlink():
            continue
        data = read_json(inside(root, relative))
        for name in events:
            script, targets = HOOK_CONTRACTS[name]
            issues, covered = [], set()
            if data.get('disableAllHooks', False) is not False:
                issues.append('hooks disabled or disableAllHooks is not a boolean false')
            hooks = data.get('hooks')
            groups = hooks.get(name) if isinstance(hooks, dict) else None
            if not isinstance(groups, list) or not groups:
                issues.append('expected a nonempty hook-group array')
            else:
                for index, group in enumerate(groups):
                    if not isinstance(group, dict) or not isinstance(group.get('hooks'), list):
                        issues.append(f'group {index}: expected a hooks array')
                        continue
                    matcher = group.get('matcher', '')
                    if not isinstance(matcher, str) or any(not isinstance(h, dict) for h in group['hooks']):
                        issues.append(f'group {index}: malformed matcher/handler')
                        continue
                    if any(declared_script(h, root, script) for h in group['hooks']):
                        covered.update(declared_matches(matcher, name, targets))
            missing = set(targets) - covered
            if missing:
                issues.append('unconfirmed direct synchronous declaration for ' + ', '.join(sorted(missing)))
            reports.append(dict(path=relative, event=name, script='axiarch-scripts/' + script,
                                covered=sorted(covered), issues=issues))
    return reports


def lessons(path, today, stale_days):
    entries, notes, issues = [], [], []
    current = None
    recognized = False
    active = True  # Legacy logs without an Unsorted heading remain inspectable.
    text = path.read_text(encoding="utf-8")
    literal_titles = dict(markdown_prose_lines(text))
    for line_no, line in markdown_prose_lines(text, mask_code_spans=True):
        if line.lstrip().startswith(">"):
            continue
        if re.match(r"^##\s+", line):
            current = None
            active = bool(re.search(r"未分類|未整理|Unsorted|Unorganized", line, re.I))
            recognized = recognized or active
            continue
        if not active:
            continue
        heading = re.match(r"^###\s+\[([^\]]+)\]\s*(.*)", line)
        if heading:
            title = re.match(r"^###\s+\[([^\]]+)\]\s*(.*)", literal_titles[line_no])[2]
            current = dict(line=line_no, date=heading[1], title=title, domain="", target_folder="")
            entries.append(current)
            continue
        if current is not None:
            # Accept both canonical separate tags and legacy 'Domain: x | Target Folder: y'.
            plain = line.replace("**", "")
            for field, key in (("Domain", "domain"), ("Target Folder", "target_folder")):
                match = re.search(r"(?:^|\|)\s*" + field + r":\s*([^|]+)", plain)
                if match:
                    current[key] = match[1].strip()
    if not recognized:
        notes.append("Unsorted section not found; only recognizable legacy entries were inspected")
    counts = Counter()
    for entry in entries:
        label = f"line {entry['line']}"
        if not entry["domain"] or entry["domain"].startswith("{"):
            issues.append(f"{label}: missing Domain")
        else:
            counts[entry["domain"]] += 1
        if not re.fullmatch(r"(?:axiarch-rules/(?:ja|en|\{lang\})/)?blueprint/[a-z][a-z0-9_-]*/?", entry["target_folder"]):
            issues.append(f"{label}: missing Target Folder; classify before closing")
        if not entry["title"].strip() or entry["title"].startswith("{"):
            issues.append(f"{label}: missing lesson title")
        try:
            stamp = date.fromisoformat(entry["date"])
            age = (today - stamp).days
            if age < 0:
                issues.append(f"{label}: future lesson date")
            if stale_days and age >= stale_days:
                issues.append(f"{label}: stale lesson ({age} days); review promotion")
        except ValueError:
            issues.append(f"{label}: invalid lesson date")
    for domain, count in sorted(counts.items()):
        if count >= 3:
            issues.append(f"domain {domain}: {count} unsorted lessons; promotion required")
    return dict(entries=entries, issues=issues, notes=notes)


def no_symlinks(root, path):
    relative = path.relative_to(root)
    return not any((root / part).is_symlink() for part in (relative, *relative.parents))


def inspect_lessons(root, stale_days, today=None):
    reports = []
    for lang in ("ja", "en"):
        path = root / f"axiarch-rules/{lang}/blueprint/core/010_project_lessons_log.md"
        if path.exists() or path.is_symlink() or (root / f"axiarch-rules/{lang}/blueprint").exists():
            if not path.is_file() or not no_symlinks(root, path):
                reports.append(dict(path=str(path.relative_to(root)), language=lang, entries=[], notes=[],
                                    issues=["lesson log unavailable: expected a regular file without symlink ancestors"]))
                continue
            report = lessons(path, today or date.today(), stale_days)
            for entry in report["entries"]:
                target = entry["target_folder"].replace("{lang}", lang)
                if target.startswith("blueprint/"):
                    target = f"axiarch-rules/{lang}/{target}"
                if re.fullmatch(r"axiarch-rules/(?:ja|en)/blueprint/[a-z][a-z0-9_-]*/?", target):
                    if not (root / target).is_dir() or not no_symlinks(root, root / target):
                        report["issues"].append(f"line {entry['line']}: Target Folder does not exist or has symlink ancestors: {target}")
                    if not target.startswith(f"axiarch-rules/{lang}/"):
                        report["issues"].append(f"line {entry['line']}: Target Folder must use this log's language: {target}")
            reports.append(dict(path=str(path.relative_to(root)), language=lang, **report))
    return reports


def blueprint_files(root):
    """Discover real category folders, including adopter additions, without a closed list."""
    for lang in ("ja", "en"):
        base = root / f"axiarch-rules/{lang}/blueprint"
        if not no_symlinks(root, base):
            raise ValueError(f"Blueprint inventory has symlink ancestors: {base}")
        if not base.is_dir():
            continue
        for folder in sorted(base.iterdir()):
            if folder.is_symlink():
                raise ValueError(f"Blueprint category is a symlink: {folder}")
            if not folder.is_dir():
                continue
            for path in sorted(folder.glob("[0-9][0-9][0-9]_*.md")):
                if path.is_file() and not path.is_symlink():
                    yield path


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--project", default=".")
    parser.add_argument("--mode", choices=("lessons", "blueprint-files", "hooks"), default="lessons")
    parser.add_argument("--event", choices=tuple(HOOK_CONTRACTS))
    parser.add_argument("--quiet", action="store_true")
    parser.add_argument("--json", action="store_true")
    args = parser.parse_args()
    root = Path(args.project).resolve(strict=True)
    if args.mode == 'hooks':
        reports = inspect_hooks(root, args.event)
        if args.json:
            print(json.dumps(reports, ensure_ascii=False))
        else:
            for report in reports:
                for issue in report['issues']:
                    print(f"HOOK DECLARATION REVIEW {report['path']} {report['event']}: {issue}", file=sys.stderr)
                if not report['issues'] and not args.quiet:
                    print(f"{report['path']} {report['event']}: declaration matched (runtime not tested)")
            if not reports and not args.quiet:
                print('No installed hook configuration; optional hook layer not assessed.')
        return 1 if any(r['issues'] for r in reports) else 0
    if args.mode == "blueprint-files":
        for path in blueprint_files(root):
            print(path.relative_to(root).as_posix())
        return 0
    value = os.environ.get("AXIARCH_LESSON_STALE_DAYS", "180")
    if not re.fullmatch(r"\d+", value):
        raise ValueError("AXIARCH_LESSON_STALE_DAYS must be a nonnegative integer")
    reports = inspect_lessons(root, int(value))
    if args.json:
        print(json.dumps(reports, ensure_ascii=False))
    else:
        if not reports:
            print("No installed lesson logs found; lesson status was not assessed.")
        for report in reports:
            print(f"{report['path']}: inspected {len(report['entries'])} recorded entries")
            for message in report["notes"]:
                print(f"NOTE {report['path']}: {message}")
            for message in report["issues"]:
                print(f"REVIEW {report['path']}: {message}")
    return 1 if any(r["issues"] for r in reports) else 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (OSError, ValueError) as exc:
        print(f"Axiarch inspection unavailable: {exc}", file=sys.stderr)
        sys.exit(2)
