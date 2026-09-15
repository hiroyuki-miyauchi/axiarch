"""Exercise malformed links and diagnostic display without external services."""
import contextlib
import io
from pathlib import Path
import tempfile
import unittest

from check_documentation import inspect, main


class LinkDiagnosticTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='axiarch-link-diagnostic-')
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.guide = self.root / 'README.md'

    def check_cli(self):
        output, errors = io.StringIO(), io.StringIO()
        with contextlib.redirect_stdout(output), contextlib.redirect_stderr(errors):
            code = main(self.root)
        return code, output.getvalue() + errors.getvalue()

    def test_malformed_urls_are_reported_without_aborting_other_links(self):
        for target in ('http://[broken', 'https://host\uff0fname'):
            with self.subTest(target=target):
                self.guide.write_text(f'[bad]({target})\n[next](missing.md)\n', encoding='utf-8')
                code, output = self.check_cli()
                self.assertEqual(code, 1)
                self.assertIn('README.md:1: invalid link', output)
                self.assertIn('README.md:2: missing path', output)
                self.assertNotIn(target, output)

    def test_invalid_percent_encoded_utf8_is_not_replaced_before_matching(self):
        (self.root / '\ufffd.md').write_text('# \ufffd\n', encoding='utf-8')
        for target in ('%FF.md', '\ufffd.md#%FF', '%C0%AF.md'):
            with self.subTest(target=target):
                self.guide.write_text(f'[bad]({target})\n', encoding='utf-8')
                code, output = self.check_cli()
                self.assertEqual(code, 1)
                self.assertIn('invalid link', output)

    def test_link_control_characters_are_rejected_before_path_operations(self):
        for target in ('bad%00name.md', 'bad%0Aname.md', 'bad%1Bname.md',
                       'bad%E2%80%A8name.md', 'bad\x1bname.md'):
            with self.subTest(target=target):
                self.guide.write_text(f'[bad]({target})\n', encoding='utf-8')
                code, output = self.check_cli()
                self.assertEqual(code, 1)
                self.assertIn('invalid link', output)
                self.assertNotIn('\x1b', output)

    def test_cyclic_link_target_does_not_abort_inspection(self):
        (self.root / 'cycle.link').symlink_to('cycle.link')
        self.guide.write_text('[loop](cycle.link)\n[next](missing.md)\n', encoding='utf-8')
        code, output = self.check_cli()
        self.assertEqual(code, 1)
        self.assertIn('README.md:1: unreadable link target', output)
        self.assertIn('README.md:2: missing path', output)

    def test_diagnostics_escape_control_characters_in_source_names(self):
        path = self.root / '日本語\x1b[31m\n::notice::forged.md'
        path.write_text('[bad](missing.md)\n', encoding='utf-8')
        issues = inspect(self.root)
        self.assertEqual(len(issues), 1)
        self.assertNotIn('\x1b', issues[0])
        self.assertNotIn('\n', issues[0])
        code, output = self.check_cli()
        self.assertEqual(code, 1)
        self.assertEqual(len(output.splitlines()), 1)
        self.assertIn('日本語', output)
        self.assertNotIn('\x1b', output)

    def test_unicode_encoded_paths_fragments_queries_and_external_urls_still_work(self):
        (self.root / '日本語.md').write_text('# 詳細\n', encoding='utf-8')
        self.guide.write_text(
            '[plain](日本語.md#詳細)\n'
            '[encoded](%E6%97%A5%E6%9C%AC%E8%AA%9E.md?view=1#%E8%A9%B3%E7%B4%B0)\n'
            '[external](https://example.invalid/guide)\n'
            '`[example](http://[broken)`\n'
            '<!-- [example](http://[broken) -->\n', encoding='utf-8')
        code, output = self.check_cli()
        self.assertEqual(code, 0, output)

    def test_diagnostics_do_not_emit_github_command_markers(self):
        for name in ('::error::forged.md', '  ::warning::forged.md', 'prefix##[error]forged.md'):
            with self.subTest(name=name):
                path = self.root / name
                path.write_text('[bad](missing.md)\n', encoding='utf-8')
                code, output = self.check_cli()
                self.assertEqual(code, 1)
                self.assertNotIn('::', output)
                self.assertNotIn('##[', output)
                path.unlink()
