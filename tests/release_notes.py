"""Maintainer-only changelog checks and deterministic release-body extraction.

Checks structure, not factual accuracy, translation quality or source inclusion.
No network, Git mutation or publication. Historical exceptions are explicit.
"""
import argparse
from datetime import date
from pathlib import Path
import re
import sys

sys.dont_write_bytecode = True
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'axiarch-scripts'))
from axiarch_state import markdown_prose_lines

REPO = 'https://github.com/hiroyuki-miyauchi/axiarch'
VERSION = r'(?:0|[1-9][0-9]*)\.(?:0|[1-9][0-9]*)\.(?:0|[1-9][0-9]*)'
HEADING = re.compile(r'^## \[(Unreleased|' + VERSION + r')\](?: — (\d{4}-\d{2}-\d{2})(.*))?\s*$')
INTERNAL = {'1.7.0'}  # Documented internal development; shipped in v1.8.0.
REQUIRED = ('概要 / Overview', '追加 / Added', '変更 / Changed', '修正 / Fixed',
            '互換性と更新 / Compatibility and upgrade',
            '検証と限界 / Verification and limits', '比較と関連情報 / References')


def version_key(value):
    return tuple(map(int, value.split('.')))


def parse(text):
    lines = text.splitlines(keepends=True)
    entries, refs, seen, ref_lines = [], {}, set(), set()
    for number, line in markdown_prose_lines(text):
        if line.startswith('## ['):
            match = HEADING.fullmatch(line.rstrip())
            if not match:
                raise ValueError(f'Invalid release heading at line {number}')
            version, stamp, suffix = match.groups()
            if version in seen:
                raise ValueError(f'Duplicate release: {version}')
            if version == 'Unreleased':
                if entries or stamp:
                    raise ValueError('Unreleased must be the first undated section')
            else:
                if not stamp:
                    raise ValueError(f'Missing release date: {version}')
                date.fromisoformat(stamp)
                if suffix and suffix.strip() and version not in INTERNAL:
                    raise ValueError(f'Unexpected heading suffix: {version}')
                previous = [e['version'] for e in entries if e['version'] != 'Unreleased']
                if previous and version_key(version) >= version_key(previous[-1]):
                    raise ValueError('Release sections must be in descending version order')
            seen.add(version)
            entries.append(dict(version=version, start=number - 1))
        ref = re.fullmatch(r'\[([^]]+)\]:\s+(\S+)\s*', line)
        if ref:
            if ref[1].casefold() in refs:
                raise ValueError(f'Duplicate link definition: {ref[1]}')
            refs[ref[1].casefold()] = ref[2]
            ref_lines.add(number - 1)
    if not entries:
        raise ValueError('No release sections')
    for i, entry in enumerate(entries):
        end = entries[i + 1]['start'] if i + 1 < len(entries) else len(lines)
        body = ''.join(line for n, line in enumerate(lines[entry['start']:end], entry['start'])
                       if n not in ref_lines).strip()
        # Link definitions belong to the document, not the last release.
        entry['body'] = body.removesuffix('---').rstrip()
    return entries, refs


def check(text):
    entries, refs = parse(text)
    published = [e for e in entries if e['version'] not in INTERNAL | {'Unreleased'}]
    if not published:
        raise ValueError('No released-version section')
    for i, entry in enumerate(published):
        version = entry['version']
        expected = (f'{REPO}/compare/v{published[i + 1]["version"]}...v{version}'
                    if i + 1 < len(published) else f'{REPO}/releases/tag/v{version}')
        if refs.get(version) != expected:
            raise ValueError(f'Incorrect or missing comparison link: {version}')
        if version_key(version) < (1, 17, 0):
            continue  # Preserve old formats; corrections are in RELEASE_AUDIT.md.
        parts = {}
        current = None
        for _, line in markdown_prose_lines(entry['body']):
            if line.startswith('### '):
                current = line[4:].strip()
                if current in parts:
                    raise ValueError(f'Duplicate section: {version}: {current}')
                parts[current] = []
            elif current:
                parts[current].append(line)
        for name in REQUIRED:
            prose = '\n'.join(parts.get(name, []))
            # Presence only: headings/links/comments are not meaningful content.
            prose = re.sub(r'https?://\S+|`[^`]*`|^\s*[-|:]\s*$', '', prose, flags=re.M)
            if not re.search(r'[ぁ-んァ-ヶ一-龠]', prose) or not re.search(r'[A-Za-z]{3,}\s+[A-Za-z]{3,}', prose):
                raise ValueError(f'Missing bilingual section content: {version}: {name}')
            if re.search(r'^\s*(?:-\s*)?(?:TODO|TBD|未記入|準備中)\s*[.:：]?\s*$', prose, re.M | re.I):
                raise ValueError(f'Unfilled release placeholder: {version}: {name}')
    if any(e['version'] == 'Unreleased' for e in entries):
        if refs.get('unreleased') != f'{REPO}/compare/v{published[0]["version"]}...HEAD':
            raise ValueError('Incorrect or missing Unreleased comparison')
    elif 'unreleased' in refs:
        raise ValueError('Unused Unreleased reference')
    return entries, refs


def extract(text, version):
    entries, refs = check(text)
    selected = [e for e in entries if e['version'] == version]
    if version in INTERNAL | {'Unreleased'} or not selected:
        raise ValueError(f'Not a published-version section: {version}')
    body = selected[0]['body']
    # Make repository-relative inline links work on the GitHub Release page.
    lines = body.splitlines(keepends=True)
    visible = list(markdown_prose_lines(body, mask_code_spans=True))
    for number, line in visible:
        matches = list(re.finditer(r'\]\(((?![a-zA-Z][a-zA-Z0-9+.-]*:|/|#)[^\s)]+)\)', line))
        for match in reversed(matches):
            start, end = match.span(1)
            original = lines[number - 1]
            lines[number - 1] = original[:start] + f'{REPO}/blob/v{version}/' + original[start:end] + original[end:]
    body = ''.join(lines)
    labels = {label.casefold() for _, line in visible for label in re.findall(r'\[([^]\n]+)\](?!\()', line)}
    definitions = [f'[{label}]: {url}' for label, url in refs.items() if label in labels]
    return body + '\n\n' + '\n'.join(definitions) + '\n'


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--changelog', type=Path, default=Path('CHANGELOG.md'))
    parser.add_argument('--version', help='Extract this release; omit to check the changelog')
    parser.add_argument('--output', type=Path)
    parser.add_argument('--latest', action='store_true', help='Print the first validated section label')
    args = parser.parse_args()
    try:
        text = args.changelog.read_text(encoding='utf-8')
        if args.latest:
            if args.version or args.output:
                raise ValueError('--latest cannot be combined with extraction')
            print(check(text)[0][0]['version'])
        elif args.version:
            body = extract(text, args.version)
            if args.output:
                if args.output.exists() and args.output.samefile(args.changelog):
                    raise ValueError('Output must not overwrite the source changelog')
                args.output.write_text(body, encoding='utf-8')
            else:
                print(body, end='')
        else:
            if args.output:
                raise ValueError('--output requires --version')
            check(text)
            print('リリース本文の構造と比較リンク: 成功（内容の正しさは別途レビュー）')
    except (OSError, ValueError) as error:
        print(f'リリース本文検査失敗: {error}', file=sys.stderr)
        return 1
    return 0


if __name__ == '__main__':
    sys.exit(main())
