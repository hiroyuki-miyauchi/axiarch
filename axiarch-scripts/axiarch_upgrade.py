#!/usr/bin/env python3
"""File-level safe copying and machine-readable upgrade outcome records."""
import argparse
from datetime import datetime, timezone
import fnmatch
import glob
import hashlib
import json
import os
from pathlib import Path
import shutil
import stat
import subprocess
import sys
import tempfile
import unicodedata

sys.dont_write_bytecode = True
from axiarch_state import atomic, digest, identifier, inside, read_json, protect_artifacts, has_control_characters, fcntl


def distribution_path(relative):
    """Payload ownership never includes a repository root or internal stores.

    Git/private state is managed by its lifecycle, not by an upstream manifest.
    Compare reserved components case-insensitively for portable distributions.
    """
    parts = Path(relative).parts
    if (not parts or Path(relative).is_absolute() or '..' in parts
            or any(part.casefold() in {'.git', '.axiarch'} for part in parts)):
        raise ValueError('reserved distribution path: ' + str(relative))
    return relative


class DistributionNames:
    """Reject ambiguous portable payload names without renaming adopter files.

    Case-sensitive hosts also reject case/canonical-Unicode aliases, since the
    same payload can later be installed on a case-insensitive filesystem.
    Include parents so differently spelled directories cannot split ownership.
    """
    def __init__(self):
        self.names = {}

    @staticmethod
    def key(relative):
        return unicodedata.normalize('NFD', relative.casefold())

    def add(self, relative):
        parts = Path(relative).parts
        for length in range(1, len(parts) + 1):
            name = '/'.join(parts[:length])
            key = self.key(name)
            if key in self.names and self.names[key] != name:
                raise ValueError('ambiguous distribution names: case or Unicode alias')
            self.names[key] = name


def manifest_rows(args):
    """Parse once with the already-required Python runtime; never silently downgrade."""
    data = read_json(Path(args.source) / 'axiarch-manifest.json')
    version = data.get('axiarchVersion', '')
    if not isinstance(version, str) or not version or has_control_characters(version):
        raise ValueError('invalid manifest version')
    entries, groups = data.get('files'), data.get('groups', [])
    # Only an absent files key is a legacy manifest. A malformed key is an error.
    if 'files' in data and not isinstance(entries, list):
        raise ValueError('manifest files must be an array')
    if not isinstance(groups, list):
        raise ValueError('manifest groups must be an array')

    def field(value, label, empty=False):
        if (not isinstance(value, str) or (not value and not empty)
                or has_control_characters(value) or '|' in value):
            raise ValueError('invalid manifest ' + label)
        return value

    rows, seen = [], {}
    for entry in entries or []:
        if not isinstance(entry, dict):
            raise ValueError('manifest file entry must be an object')
        group, path = field(entry.get('group'), 'group'), field(entry.get('path'), 'path')
        if Path(path).is_absolute() or '..' in Path(path).parts or '\\' in path:
            raise ValueError('unsafe manifest path: ' + path)
        path = Path(path).as_posix()
        distribution_path(path)
        owner, policy = entry.get('owner', 'mixed'), entry.get('policy', 'review')
        if owner not in ('axiarch', 'project', 'mixed', 'axiarch-source') or policy not in (
                'replace', 'replace-if-local-unchanged', 'review', 'preserve', 'optional', 'skip'):
            raise ValueError('unsupported manifest owner/policy')
        agents, excludes = entry.get('agents', ['all']), entry.get('exclude', [])
        if not isinstance(agents, list) or not isinstance(excludes, list):
            raise ValueError('manifest agents/exclude must be arrays')
        row = '\t'.join([group, path, owner, policy,
                         ','.join(field(v, 'agent') for v in agents) or 'all',
                         '|'.join(field(v, 'exclude') for v in excludes)])
        if path in seen and seen[path] != row:
            raise ValueError('conflicting manifest definitions: ' + path)
        seen[path] = row
        rows.append(row)
    group_rows = []
    for group in groups:
        if not isinstance(group, dict):
            raise ValueError('manifest group must be an object')
        group_rows.append('\t'.join(field(group.get(k, ''), k, empty=k != 'id')
                                    for k in ('id', 'label', 'labelJa', 'defaultAction', 'risk')))
    if args.format == 'check':
        return 0
    if args.format == 'version':
        print(version)
    elif args.format == 'groups':
        print('\n'.join(group_rows))
    elif entries is None:
        print('LEGACY')
    else:
        print('\n'.join(rows))
    return 0


def expand_selected(args):
    """Expand excluded directory selections without silently copying their children."""
    patterns = args.exclude.split('|') if args.exclude else []

    def excluded(rel):
        parts = Path(rel).parts
        return any(fnmatch.fnmatchcase('/'.join(parts[:i]), pattern)
                   for i in range(1, len(parts) + 1) for pattern in patterns)

    found = set()
    if not inside(Path(args.source).resolve(strict=True), args.path).exists():
        print(args.path)
        return 0
    for directory in (args.source, args.target):
        root = Path(directory).resolve(strict=True)
        path = inside(root, args.path)
        if not path.exists():
            continue
        for item in sorted(path.rglob('*')) if path.is_dir() else [path]:
            rel = item.relative_to(root).as_posix()
            if not excluded(rel):
                item = inside(root, rel)
                if not item.is_dir():
                    found.add(rel)
    print('\n'.join(sorted(found)))
    return 0


def expand_glob(args):
    """Validate whole filenames before serializing matches to shell lines.

    A newline-delimited shell glob listing loses the original filename boundary
    before check-paths can reject control characters. Keep matches as strings
    until every name is checked. Root metacharacters are always literal.
    """
    root = Path(args.source).resolve(strict=True)
    inside(root, args.path)
    matches = sorted({Path(name).relative_to(root).as_posix()
                      for name in glob.iglob(glob.escape(str(root)) + '/' + args.path)})
    for name in matches:
        if has_control_characters(name):
            raise ValueError('control characters are not supported in glob matches')
    # Exclusions and path/type checks still run on the final selection.
    if matches:
        print('\n'.join(matches))
    return 0


def upgrade_lock_path(root):
    key = hashlib.sha256(str(root.resolve()).encode()).hexdigest()
    # A per-session TMPDIR must not split locks for the same local adopter.
    return Path("/tmp").resolve() / f"axiarch-upgrade-{os.getuid()}-{key}.lock"


def run_locked(args):
    """Hold a cooperating-writer lock even through shell self-update or interruption.

    The lock lives outside the adopter so dry-run/EOF leave its entire tree intact.
    Never unlink it: waiters must continue to share the same inode.
    """
    root = Path(args.target).resolve(strict=True)
    path = upgrade_lock_path(root)
    fd = os.open(path, os.O_RDWR | os.O_CREAT | os.O_NOFOLLOW, 0o600)
    try:
        info = os.fstat(fd)
        if not stat.S_ISREG(info.st_mode) or info.st_uid != os.getuid():
            raise ValueError("unsafe upgrade lock file")
        try:
            fcntl.flock(fd, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            print("Upgrade busy: another upgrade is using this target; retry after it finishes.", file=sys.stderr)
            return 6
        command = args.command[1:] if args.command[:1] == ["--"] else args.command
        if not command:
            raise ValueError("locked command required")
        env = dict(os.environ, AXIARCH_UPGRADE_LOCK_FD=str(fd), AXIARCH_UPGRADE_LOCK_ROOT=str(root))
        result = subprocess.run(command, env=env, pass_fds=(fd,), check=False)
        return result.returncode if result.returncode >= 0 else 128 - result.returncode
    finally:
        os.close(fd)


def check_lock(root):
    fd = int(os.environ.get("AXIARCH_UPGRADE_LOCK_FD", "-1"))
    if os.environ.get("AXIARCH_UPGRADE_LOCK_ROOT") != str(root.resolve()):
        raise ValueError("upgrade lock target mismatch")
    expected, actual = upgrade_lock_path(root).stat(), os.fstat(fd)
    if (expected.st_dev, expected.st_ino) != (actual.st_dev, actual.st_ino):
        raise ValueError("upgrade lock descriptor mismatch")


def metadata_paths(root, run_id):
    identifier(run_id)
    # Validate ancestors and types before any result/version write, including
    # existing symlinked metadata. Metadata must stay inside this adopter.
    paths = {}
    for relative in ("version.json", "files.sha256", "upgrade-result.json", f"upgrades/{run_id}/result.json"):
        path = inside(root, f".axiarch/{relative}")
        if path.exists() and not path.is_file():
            raise ValueError(f"metadata must be a regular file: {relative}")
        if any(p.exists() and not p.is_dir() for p in path.parents):
            raise ValueError(f"metadata parent must be a directory: {relative}")
        paths[relative] = path
    return paths


def selection(args):
    return {"languages": args.lang, "agent": args.agent, "with_prompts": args.with_prompts}


def check_distribution_paths(args, relatives):
    normalized = sorted(set(Path(p).as_posix() for p in relatives))
    names = DistributionNames()
    for rel in normalized:
        names.add(rel)
    for i, rel in enumerate(normalized):
        if any(other.startswith(rel + '/') for other in normalized[i + 1:]):
            raise ValueError('overlapping parent/child selections; exclude children from the parent first: ' + rel)
    for relative in relatives:
        distribution_path(relative)
        for directory in (args.target, args.source, args.base):
            if directory:
                base = Path(directory).resolve(strict=True)
                path = inside(base, relative)
                for child in [path] + (list(path.rglob('*')) if path.is_dir() else []):
                    rel = child.relative_to(base).as_posix()
                    names.add(rel)
                    distribution_path(rel)
                    inside(base, rel)
                    if child.exists() and not child.is_file() and not child.is_dir():
                        raise ValueError('unsupported file type: ' + rel)


def copy_files(args):
    # Use the public preflight for all three trees before copying any file.
    check_distribution_paths(args, [args.path])
    source, target = Path(args.source).resolve(), Path(args.target).resolve()
    src = inside(source, args.path)
    dst = inside(target, args.path)
    files = sorted(src.rglob("*")) if src.is_dir() else [src]
    installed = {}
    hashes = inside(target, ".axiarch/files.sha256")
    if hashes.is_file():
        for line in hashes.read_text(encoding='utf-8').splitlines():
            if "  " in line:
                value, name = line.split("  ", 1)
                installed[name] = value
    if src.is_dir() and dst.exists() and not dst.is_dir():
        print(f"TYPE-CONFLICT {args.path}")
        return 0
    failed = False
    for item in files:
        rel = item.relative_to(source).as_posix()
        try:
            item = inside(source, rel)
            dest = inside(target, rel)
            if item.is_dir():
                if dest.exists() and not dest.is_dir():
                    print(f"TYPE-CONFLICT {rel}")
                continue
            if not item.is_file():
                raise ValueError(f'unsupported file type: {rel}')
            # A blocked directory ancestor must not escape via mkdir/cp behavior.
            if any(p.exists() and not p.is_dir() for p in dest.parents):
                print(f"TYPE-CONFLICT {rel}")
                continue
            if dest.exists() and not dest.is_file():
                print(f"TYPE-CONFLICT {rel}")
                continue
            source_hash = digest(item)
            if dest.exists():
                local_hash = digest(dest)
                if source_hash == local_hash:
                    print(f"UNCHANGED {rel}")
                    continue
                base = inside(Path(args.base).resolve(), rel) if args.base else None
                expected = {installed.get(rel)}
                if base and base.is_file():
                    expected.add(digest(base))
                if not args.force and local_hash not in expected:
                    print(f"REVIEW local-modified-or-unknown {rel}")
                    continue
            if not args.apply:
                print(f"DRY-RUN update {rel}")
                continue
            dest.parent.mkdir(parents=True, exist_ok=True)
            if dest.exists():
                backup = inside(target, f".axiarch/upgrades/{args.run_id}/backup/{rel}")
                backup.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(dest, backup)
            fd, tmp = tempfile.mkstemp(prefix=".upgrade-", dir=dest.parent)
            os.close(fd)
            try:
                shutil.copy2(item, tmp)
                os.replace(tmp, dest)
            finally:
                if os.path.exists(tmp):
                    os.unlink(tmp)
            print(f"UPDATE {rel}")
        except (ValueError, OSError) as exc:
            print(f"APPLY-FAIL {rel}: {exc}")
            failed = True
    return 5 if failed else 0


def finalize(args):
    root = Path(args.target).resolve()
    metadata_paths(root, args.run_id)
    meta = inside(root, ".axiarch")
    lines = Path(args.log).read_text(encoding='utf-8').splitlines()
    # Applied files and byte-identical upstream files become known bases.
    # Never bless deferred local edits (including inside unchanged directories).
    hashes = {}
    hash_path = meta / "files.sha256"
    if hash_path.exists():
        for line in hash_path.read_text(encoding='utf-8').splitlines():
            if "  " in line:
                sha, name = line.split("  ", 1)
                hashes[name] = sha
    # Diagnostics run after copying and may change files. Reconcile against
    # source before confirming a version or trusting bytes for a later update.
    for line in tuple(lines):
        if not line.startswith(("UPDATE ", "UNCHANGED ")):
            continue
        rel = line.split(" ", 1)[1]
        try:
            source_root = Path(args.source).resolve()
            source = inside(source_root, rel)
            target = inside(root, rel)
            if source.is_dir():
                if line.startswith("UPDATE ") or not target.is_dir():
                    raise ValueError('unexpected directory at finalization')
                candidates = sorted(source.rglob("*"))
            else:
                candidates = [source]
        except (OSError, ValueError):
            lines.append(f"APPLY-FAIL verification-unavailable {rel}")
            continue
        for candidate in candidates:
            name = candidate.relative_to(source_root).as_posix()
            try:
                candidate = inside(source_root, name)
                if candidate.is_dir():
                    continue
                sha = digest(candidate)
                if digest(inside(root, name)) != sha:
                    lines.append(f"REVIEW changed-before-finalization {name}")
                    continue
                hashes[name] = sha
            except (OSError, ValueError):
                # Keep the last known base and report only the relative path.
                lines.append(f"APPLY-FAIL verification-unavailable {name}")
    pending = [s for s in lines if s.startswith(("REVIEW ", "KEEP ", "MERGE-SKIP ", "DIFF "))
               or (s.startswith("SKIP ") and not s.startswith(("SKIP source-only ", "SKIP optional ")))]
    conflicts = [s for s in lines if s.startswith(("TYPE-CONFLICT ", "CONFLICT "))]
    failed = [s for s in lines if s.startswith(("APPLY-FAIL ", "MERGE-FAIL ", "WARN source missing "))]
    application = "failed" if failed else "partial" if pending or conflicts else "complete"
    health = "passed" if args.health == 0 else "unavailable" if args.health == 127 else "failed"
    rc = 5 if failed else 4 if health != "passed" else 3 if application == "partial" else 0
    previous = {}
    if (meta / "version.json").is_file():
        previous = read_json(meta / "version.json")
    confirmed = args.version if rc == 0 else previous.get("version")
    result = {"schema_version": 1, "run_id": args.run_id, "requested_version": args.version,
              "mode": "apply", "selection": selection(args),
              "confirmed_version": confirmed, "source_ref": args.source_ref, "source_directory": args.source,
              "application": application, "health": {"status": health, "exit_code": args.health},
              "pending": pending, "conflicts": conflicts, "failed": failed, "actions": lines,
              "exit_code": rc, "finished_at": datetime.now(timezone.utc).isoformat()}
    fd, tmp = tempfile.mkstemp(prefix=".hashes-", dir=meta)
    with os.fdopen(fd, "w") as stream:
        for rel, sha in sorted(hashes.items()):
            stream.write(f"{sha}  {rel}\n")
    os.replace(tmp, hash_path)
    atomic(meta / "upgrades" / args.run_id / "result.json", result)
    atomic(meta / "upgrade-result.json", result)
    # `version` retains the last confirmed complete version. Requested is never installed.
    atomic(meta / "version.json", dict(previous, version=confirmed, requestedVersion=args.version,
                                       confirmedScope=selection(args) if rc == 0 else previous.get("confirmedScope"),
                                       requestedScope=selection(args),
                                       applicationStatus=application, healthStatus=health, lastRun=args.run_id))
    print(json.dumps(result, ensure_ascii=False))
    return rc


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("mode", choices=["copy", "check-merge", "begin", "finalize", "run-locked", "check-lock", "check-paths", "manifest", "expand-selected", "expand-glob"])
    parser.add_argument('--exclude', default='')
    parser.add_argument('--format', choices=['version', 'groups', 'files', 'check'], default='files')
    for name in ("source", "target", "path", "base", "run-id", "log", "version", "source-ref"):
        parser.add_argument("--" + name, default="")
    parser.add_argument("--apply", action="store_true")
    parser.add_argument("--force", action="store_true")
    parser.add_argument("--health", type=int, default=127)
    parser.add_argument("--lang", choices=["ja", "en", "both"], default="both")
    parser.add_argument("--agent", default="universal")
    parser.add_argument("--with-prompts", action="store_true")
    args, command = parser.parse_known_args()
    args.command = command
    if args.mode == "run-locked":
        return run_locked(args)
    if command:
        parser.error("unexpected arguments: " + " ".join(command))
    if args.mode == 'manifest':
        return manifest_rows(args)
    if args.mode == 'expand-selected':
        return expand_selected(args)
    if args.mode == 'expand-glob':
        return expand_glob(args)
    if args.mode == "check-lock":
        check_lock(Path(args.target).resolve(strict=True))
        return 0
    if args.mode == "check-paths":
        # The shell transports LF-delimited paths; preserve other separators
        # until inside() can reject them as part of the original filename.
        relatives = sys.stdin.read().split('\n')
        if relatives[-1] == '':
            relatives.pop()
        check_distribution_paths(args, relatives)
        return 0
    if args.mode == "check-merge":
        for directory in (args.source, args.target, args.base):
            digest(inside(Path(directory).resolve(), args.path))
        root = Path(args.target).resolve()
        for prefix in (".axiarch/conflicts", f".axiarch/upgrades/{args.run_id}/conflicts",
                       f".axiarch/upgrades/{args.run_id}/backup"):
            path = inside(root, f"{prefix}/{args.path}")
            if path.exists() and not path.is_file():
                raise ValueError("merge artifact path must be a regular file")
            if any(p.exists() and not p.is_dir() for p in path.parents):
                raise ValueError("merge artifact parent must be a directory")
        return 0
    if args.mode == "begin":
        root = Path(args.target).resolve()
        metadata_paths(root, args.run_id)
        meta = inside(root, ".axiarch")
        previous = read_json(meta / "version.json") if (meta / "version.json").exists() else {}
        protect_artifacts(root)
        run_dir = inside(root, f'.axiarch/upgrades/{args.run_id}')
        run_dir.parent.mkdir(mode=0o700, parents=True, exist_ok=True)
        run_dir.mkdir(mode=0o700)  # Never reuse another run's diagnostic/backup directory.
        result = {"schema_version": 1, "run_id": args.run_id, "requested_version": args.version,
                  "mode": "apply", "selection": selection(args),
                  "application": "in_progress", "health": {"status": "not_run", "exit_code": None},
                  "started_at": datetime.now(timezone.utc).isoformat()}
        atomic(meta / "upgrades" / args.run_id / "result.json", result)
        atomic(meta / "upgrade-result.json", result)
        atomic(meta / "version.json", dict(previous, version=previous.get("version"), requestedVersion=args.version,
                                           requestedScope=selection(args),
                                           applicationStatus="in_progress", healthStatus="not_run", lastRun=args.run_id))
        return 0
    if args.mode == "copy":
        return copy_files(args)
    return finalize(args)


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (OSError, ValueError) as exc:
        print(f"Upgrade failed: {exc}", file=sys.stderr)
        sys.exit(5)
