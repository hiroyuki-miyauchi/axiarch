"""Run the maintainer diagnostic on isolated malformed and multilingual sources."""
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


class DocumentationReadingTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='axiarch-doc-reading-')
        self.addCleanup(self.temp.cleanup)
        self.outside = Path(self.temp.name) / 'outside'
        self.outside.mkdir()
        self.root = Path(self.temp.name) / 'project'
        self.root.mkdir()

    def run_check(self, **overrides):
        code = ('import sys;from pathlib import Path;'
                f'sys.path.insert(0,{str(ROOT / "tests")!r});'
                'import check_documentation as checker;'
                'root=Path(sys.argv[1]);'
                # Use the CLI boundary once present; the old behavior is exercised too.
                'run=getattr(checker,"main",None);'
                'issues=checker.inspect(root) if run is None else None;'
                'print("\\n".join(issues)) if run is None else None;'
                'sys.exit(bool(issues) if run is None else run(root))')
        return subprocess.run([sys.executable, '-c', code, str(self.root)],
                              env=dict(os.environ, **overrides), capture_output=True,
                              encoding='utf-8', timeout=3)

    def assert_diagnostic(self, result):
        self.assertEqual(result.returncode, 1, result.stdout + result.stderr)
        self.assertNotIn('Traceback', result.stdout + result.stderr)
        self.assertNotIn('PRIVATE_SENTINEL', result.stdout + result.stderr)

    def test_unicode_sources_work_with_ascii_os_defaults(self):
        (self.root / 'README.md').write_text('# 日本語\n', encoding='utf-8')
        (self.root / 'llms.txt').write_text('[手順](README.md#日本語)\n', encoding='utf-8')
        result = self.run_check(PYTHONUTF8='0', PYTHONCOERCECLOCALE='0', LC_ALL='C', LANG='C')
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_invalid_utf8_has_a_bounded_diagnostic(self):
        for relative in ('README.md', 'llms.txt', 'llms-full.txt',
                         'axiarch-prompts/ja/example.md', 'axiarch-scripts/axiarch-init-task-md.sh'):
            with self.subTest(relative=relative):
                path = self.root / relative
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_bytes(b'PRIVATE_SENTINEL\xff')
                self.assert_diagnostic(self.run_check())
                path.unlink()

    def test_symlinked_documents_do_not_disclose_outside_contents(self):
        outside = self.outside / 'source.md'
        outside.write_text('Use `axiarch-harness/en/PRIVATE_SENTINEL.md`.\n', encoding='utf-8')
        before = outside.read_bytes()
        for name in ('README.md', 'llms.txt', 'llms-full.txt'):
            with self.subTest(name=name):
                path = self.root / name
                path.symlink_to(outside)
                self.assert_diagnostic(self.run_check())
                self.assertEqual(outside.read_bytes(), before)
                path.unlink()

    def test_symlinked_source_directories_are_not_traversed_or_ignored(self):
        (self.outside / 'source.md').write_text('Use `axiarch-harness/en/PRIVATE_SENTINEL.md`.\n', encoding='utf-8')
        for relative in ('axiarch-rules', 'axiarch-harness/ja/linked'):
            with self.subTest(relative=relative):
                path = self.root / relative
                path.parent.mkdir(parents=True, exist_ok=True)
                path.symlink_to(self.outside, target_is_directory=True)
                self.assert_diagnostic(self.run_check())
                path.unlink()

    def test_hardlinked_documents_are_not_read_as_owned_source(self):
        outside = self.outside / 'source.md'
        outside.write_text('Use `axiarch-harness/en/PRIVATE_SENTINEL.md`.\n', encoding='utf-8')
        os.link(outside, self.root / 'README.md')
        before = outside.read_bytes()
        self.assert_diagnostic(self.run_check())
        self.assertEqual(outside.read_bytes(), before)

    @unittest.skipUnless(hasattr(os, 'mkfifo'), 'POSIX named pipes required')
    def test_fifos_are_rejected_without_waiting_for_a_writer(self):
        for relative in ('README.md', 'llms.txt', 'axiarch-scripts/axiarch-init-task-md.sh'):
            with self.subTest(relative=relative):
                path = self.root / relative
                path.parent.mkdir(parents=True, exist_ok=True)
                os.mkfifo(path)
                self.assert_diagnostic(self.run_check())
                path.unlink()

    def test_linked_notices_do_not_become_distribution_inputs(self):
        (self.root / 'init.sh').write_text('# Source marker\n', encoding='utf-8')
        (self.root / 'axiarch-rules').mkdir()
        outside = self.outside / 'notice'
        outside.write_text('PRIVATE_SENTINEL\n', encoding='utf-8')
        for name in ('LICENSE', 'NOTICE'):
            (self.root / name).symlink_to(outside)
            (self.root / 'axiarch-rules' / name).symlink_to(outside)
        self.assert_diagnostic(self.run_check())

    def test_diagnostic_output_preserves_unicode_under_inherited_ascii_stdio(self):
        (self.root / '日本語.md').write_text('[手順](missing.md)\n', encoding='utf-8')
        result = self.run_check(PYTHONIOENCODING='ascii:replace')
        self.assert_diagnostic(result)
        self.assertIn('日本語.md', result.stdout)

    def test_unicode_filename_links_handle_filesystem_codec_limits(self):
        (self.root / '日本語.md').write_text('# 詳細\n', encoding='utf-8')
        (self.root / 'README.md').write_text('[手順](日本語.md#詳細)\n', encoding='utf-8')
        environment = dict(PYTHONCOERCECLOCALE='0', LC_ALL='C', LANG='C')
        result = self.run_check(PYTHONUTF8='0', **environment)
        # macOS keeps UTF-8 filenames under C; Linux may use ASCII when UTF-8
        # mode is explicitly disabled. Neither path may end in a traceback.
        self.assertIn(result.returncode, (0, 2), result.stdout + result.stderr)
        self.assertNotIn('Traceback', result.stderr)
        if result.returncode == 2:
            self.assertIn('PYTHONUTF8=1', result.stderr)
        repaired = self.run_check(PYTHONUTF8='1', **environment)
        self.assertEqual(repaired.returncode, 0, repaired.stdout + repaired.stderr)
