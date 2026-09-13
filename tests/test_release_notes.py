"""Exercise the release-note gate/renderer without network or real publication."""
import json
import os
from pathlib import Path
import subprocess
import tempfile
import textwrap
import unittest

import release_notes as notes

ROOT = Path(__file__).resolve().parents[1]


class ReleaseNotesTests(unittest.TestCase):
    def fixture(self):
        body = '## [1.17.0] — 2026-09-13\n\n'
        for heading in notes.REQUIRED:
            body += f'### {heading}\n\n対象の変更を確認する。 Review the actual source changes.\n\n'
        return body + (
            '## [1.16.0] — 2026-07-24\n\nPrevious release sentinel.\n\n'
            f'[1.17.0]: {notes.REPO}/compare/v1.16.0...v1.17.0\n'
            f'[1.16.0]: {notes.REPO}/releases/tag/v1.16.0\n')

    def test_current_changelog_and_exact_extraction(self):
        text = (ROOT / 'CHANGELOG.md').read_text()
        entries, refs = notes.check(text)
        version = next(e['version'] for e in entries if e['version'] != 'Unreleased')
        result = notes.extract(text, version)
        self.assertEqual(notes.parse(result)[0][0]['version'], version)
        self.assertEqual(len(notes.parse(result)[0]), 1)
        self.assertIn(f'[{version}]: {refs[version]}', result)

    def test_adjacent_release_and_unreleased_do_not_leak(self):
        text = ('## [Unreleased]\nFuture change sentinel.\n\n' + self.fixture() +
                f'[Unreleased]: {notes.REPO}/compare/v1.17.0...HEAD\n')
        result = notes.extract(text, '1.17.0')
        self.assertNotIn('Previous release sentinel', result)
        self.assertNotIn('Future change sentinel', result)
        self.assertNotIn('[Unreleased]:', result)

    def test_duplicate_versions_and_definitions_rejected(self):
        for suffix in ('\n## [1.17.0] — 2026-09-13\n', '\n[1.17.0]: https://example.invalid\n'):
            with self.subTest(suffix=suffix), self.assertRaisesRegex(ValueError, 'Duplicate'):
                notes.check(self.fixture() + suffix)

    def test_missing_or_untranslated_sections_rejected(self):
        for heading in notes.REQUIRED:
            for replacement in ('', 'Only English content exists.', '日本語の内容しかない。', '<!-- 対象を確認。 Review source changes. -->'):
                with self.subTest(heading=heading, replacement=replacement):
                    text = self.fixture().replace(f'### {heading}\n\n対象の変更を確認する。 Review the actual source changes.', f'### {heading}\n\n{replacement}')
                    with self.assertRaisesRegex(ValueError, 'Missing bilingual'):
                        notes.check(text)

    def test_placeholders_cannot_be_released(self):
        for placeholder in ('TODO', '- TBD', '未記入'):
            with self.subTest(placeholder=placeholder), self.assertRaisesRegex(ValueError, 'placeholder'):
                notes.check(self.fixture().replace('### 追加 / Added', placeholder + '\n\n### 追加 / Added'))

    def test_comment_and_fenced_headings_do_not_change_selection(self):
        for example in ('<!--\n## [Unreleased]\n-->\n', '```markdown\n## [Unreleased]\n```\n'):
            with self.subTest(example=example):
                self.assertEqual(notes.check(example + self.fixture())[0][0]['version'], '1.17.0')

    def test_bad_date_order_heading_and_comparison_rejected(self):
        for old, new in [('2026-09-13', '2026-02-30'), ('## [1.17.0]', '## [01.17.0]'),
                         ('## [1.16.0]', '## [2.0.0]'),
                         ('compare/v1.16.0...v1.17.0', 'compare/v1.15.0...v1.17.0')]:
            with self.subTest(new=new), self.assertRaises(ValueError):
                notes.check(self.fixture().replace(old, new))

    def test_unknown_unreleased_and_internal_versions_cannot_be_extracted(self):
        for version in ('Unreleased', '1.7.0', '9.9.9'):
            with self.subTest(version=version), self.assertRaises(ValueError):
                notes.extract(self.fixture(), version)

    def test_release_page_has_pinned_links_and_used_reference_definitions(self):
        text = self.fixture().replace('### 追加 / Added',
                                     '[手順](axiarch-scripts/README.md#usage) [変更][details]\n\n### 追加 / Added')
        text += f'[details]: {notes.REPO}/compare/v1.16.0...v1.17.0\n[unused]: https://example.invalid\n'
        rendered = notes.extract(text, '1.17.0')
        self.assertIn(f']({notes.REPO}/blob/v1.17.0/axiarch-scripts/README.md#usage)', rendered)
        self.assertIn('[details]:', rendered)
        self.assertNotIn('[unused]:', rendered)

    def test_actual_workflow_extraction_and_failure_without_output_clobber(self):
        workflow = (ROOT / '.github/workflows/release.yml').read_text()
        step = workflow.split('      - name: Extract changelog for this version\n', 1)[1]
        script = textwrap.dedent(step.split('        run: |\n', 1)[1].split('\n      - name:', 1)[0])
        with tempfile.TemporaryDirectory(prefix='axiarch-release-notes-') as directory:
            env = dict(os.environ, RUNNER_TEMP=directory, VERSION='1.17.0', PYTHONDONTWRITEBYTECODE='1')
            passed = subprocess.run(['bash', '-c', script], cwd=ROOT, env=env, capture_output=True, text=True, timeout=15)
            self.assertEqual(passed.returncode, 0, passed.stdout + passed.stderr)
            output = Path(directory) / 'axiarch-release-notes.md'
            before = output.read_bytes()
            failed = subprocess.run(['bash', '-c', script], cwd=ROOT, env=dict(env, VERSION='9.9.9'), capture_output=True, text=True, timeout=15)
            self.assertNotEqual(failed.returncode, 0)
            self.assertEqual(output.read_bytes(), before)

    def test_examples_are_preserved_in_rendered_body(self):
        example = '```markdown\n[example]: https://example.invalid\n[手順](example.md)\n```'
        text = self.fixture().replace('### 追加 / Added', example + '\n\n### 追加 / Added')
        self.assertIn(example, notes.extract(text, '1.17.0'))

    def test_cli_does_not_overwrite_its_changelog(self):
        import sys
        with tempfile.TemporaryDirectory(prefix='axiarch-release-source-') as directory:
            source = Path(directory) / 'CHANGELOG.md'
            source.write_text(self.fixture())
            result = subprocess.run([sys.executable, str(ROOT / 'tests/release_notes.py'),
                                     '--changelog', str(source), '--version', '1.17.0',
                                     '--output', str(source)], capture_output=True, text=True, timeout=15)
            self.assertNotEqual(result.returncode, 0)
            self.assertEqual(source.read_text(), self.fixture())

    def test_publication_checks_actual_body_but_preserves_existing_release_edits(self):
        workflow = (ROOT / '.github/workflows/release.yml').read_text()
        step = workflow.split('      - name: Verify release convergence\n', 1)[1]
        script = textwrap.dedent(step.split('        run: |\n', 1)[1])
        start = script.index('if [ "$RELEASE_ALREADY_EXISTS" = "false" ]; then')
        check = script[start:script.index('\nfi', start) + len('\nfi')]
        with tempfile.TemporaryDirectory(prefix='axiarch-release-convergence-') as directory:
            root = Path(directory)
            (root / 'axiarch-release-notes.md').write_text('Reviewed body\n')
            for actual, code in [('Reviewed body\r\n', 0), ('Wrong body', 1), (None, 1)]:
                with self.subTest(actual=actual):
                    (root / 'axiarch-release-final.json').write_text(json.dumps({'body': actual}))
                    result = subprocess.run(['bash', '-eu', '-c', check], capture_output=True, text=True,
                                            env=dict(os.environ, RUNNER_TEMP=directory, RELEASE_ALREADY_EXISTS='false'), timeout=15)
                    self.assertEqual(result.returncode, code, result.stdout + result.stderr)
            (root / 'axiarch-release-notes.md').unlink()
            existing = subprocess.run(['bash', '-eu', '-c', check], capture_output=True, text=True,
                                      env=dict(os.environ, RUNNER_TEMP=directory, RELEASE_ALREADY_EXISTS='true'), timeout=15)
            self.assertEqual(existing.returncode, 0)

    def test_source_only_release_files_are_not_default_adopter_payload(self):
        manifest = json.loads((ROOT / 'axiarch-manifest.json').read_text())
        for path in ('RELEASING.md', 'RELEASE_AUDIT.md', 'tests'):
            entry = next(e for e in manifest['files'] if e['path'] == path)
            self.assertEqual((entry['group'], entry['owner'], entry['policy']),
                             ('source_docs', 'axiarch-source', 'skip'))


if __name__ == '__main__':
    unittest.main()
