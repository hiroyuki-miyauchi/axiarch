"""Exercise link checks on the AI-facing Markdown-formatted text entrypoints."""
from pathlib import Path
import tempfile
import unittest

from check_documentation import inspect


class DocumentationEntrypointTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix='axiarch-doc-entrypoints-')
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        (self.root / 'README.md').write_text('# Guide\n', encoding='utf-8')

    def test_missing_targets_in_both_ai_entrypoints_are_reported(self):
        for name in ('llms.txt', 'llms-full.txt'):
            with self.subTest(name=name):
                path = self.root / name
                path.write_text('[手順 / Guide](missing.md)\n', encoding='utf-8')
                self.assertTrue(any(f'{name}:1: missing path' in issue
                                    for issue in inspect(self.root)))
                path.unlink()

    def test_stale_readme_fragments_fail_and_current_fragments_pass(self):
        for name in ('llms.txt', 'llms-full.txt'):
            with self.subTest(name=name):
                path = self.root / name
                path.write_text('[Guide](README.md#retired-title)\n', encoding='utf-8')
                self.assertTrue(any('missing anchor' in issue for issue in inspect(self.root)))
                path.write_text('[Guide](README.md#guide)\n', encoding='utf-8')
                self.assertEqual(inspect(self.root), [])
                path.unlink()

    def test_concrete_rule_paths_are_checked_in_ai_entrypoints(self):
        for name in ('llms.txt', 'llms-full.txt'):
            with self.subTest(name=name):
                path = self.root / name
                path.write_text('Load `axiarch-harness/en/MISSING.md`.\n', encoding='utf-8')
                self.assertTrue(any('missing inline path' in issue for issue in inspect(self.root)))
                path.unlink()

    def test_code_and_comment_examples_remain_exempt(self):
        examples = ('```md\n[Example](missing.md)\n```\n'
                    '<!-- [Example](missing.md) -->\n'
                    '`[Example](missing.md)`\n')
        for name in ('llms.txt', 'llms-full.txt'):
            (self.root / name).write_text(examples, encoding='utf-8')
        self.assertEqual(inspect(self.root), [])

    def test_ai_entrypoints_can_link_to_each_other_by_heading(self):
        (self.root / 'llms.txt').write_text('[詳細](llms-full.txt#詳細)\n', encoding='utf-8')
        (self.root / 'llms-full.txt').write_text('# 詳細\n', encoding='utf-8')
        self.assertEqual(inspect(self.root), [])
        (self.root / 'llms-full.txt').write_text('# 新しい見出し\n', encoding='utf-8')
        self.assertTrue(any('missing anchor' in issue for issue in inspect(self.root)))

    def test_unrelated_text_files_are_not_treated_as_published_guidance(self):
        (self.root / 'private-log.txt').write_text('[Example](missing.md)\n', encoding='utf-8')
        self.assertEqual(inspect(self.root), [])
