"""Actual settings, lessons and links must survive literal Markdown examples."""
from datetime import date
import re
import sys
import unittest

from test_consistency import inspector
from check_documentation import anchors, inspect as inspect_docs
from axiarch_state import language_settings
import test_runtime as runtime
import test_setup as setup


class MarkdownBoundaryTests(unittest.TestCase):
    setUp = runtime.RuntimeTests.setUp
    run_cmd = runtime.RuntimeTests.run_cmd
    tree_bytes = runtime.RuntimeTests.tree_bytes
    install_source = setup.SetupTests.install_source
    state = runtime.RuntimeTests.state
    boot = runtime.RuntimeTests.boot

    def configure(self, lang='en', expected=0):
        return self.run_cmd([sys.executable, runtime.SCRIPTS / 'axiarch_setup.py',
                             'configure-language', '--target', self.target, '--lang', lang], expected=expected)

    def test_literal_comment_markers_do_not_hide_language_settings(self):
        for prefix in ('Use `<!--` to explain comments.\n\n',
                       'Use ``a ` and <!--`` as a code example.\n\n',
                       'Escaped \\<!-- marker.\n\n',
                       '    <!-- Indented example\n\n',
                       '```inline code```\n\n'):
            with self.subTest(prefix=prefix):
                text = prefix + 'Project Native Language: English\n'
                self.assertEqual([item[1] for item in language_settings(text)], ['English'])

    def test_multiline_code_span_does_not_become_an_actual_setting(self):
        text = ('Example `first line\nProject Native Language: Japanese\nlast line`\n\n'
                'Project Native Language: English\n')
        self.assertEqual(language_settings(text), [(4, 'English')])

    def test_comment_removal_does_not_manufacture_a_setting_line(self):
        text = ('<!-- explanation -->Project Native Language: English\n'
                'Project Native Language: Japanese\n')
        # Canonical settings start at column zero in the original file.
        self.assertEqual(language_settings(text), [(1, 'Japanese')])

    def test_setting_update_preserves_notes_spacing_and_line_endings(self):
        path = self.target / 'AXIARCH.md'
        for ending in ('\n', '\r\n', '\r', ''):
            with self.subTest(ending=repr(ending)):
                text = 'Project Native Language:\tJapanese  <!-- keep 日本語 notes -->' + ending
                path.write_bytes(text.encode())
                self.configure()
                self.assertEqual(path.read_bytes(), text.replace('\tJapanese', '\tEnglish').encode())

    def test_setting_update_rejects_embedded_markup_without_discarding_it(self):
        path = self.target / 'AXIARCH.md'
        for value in ('Jap<!-- keep -->anese', '`Japanese`', 'Japanese `extra`', ''):
            with self.subTest(value=value):
                path.write_text('Project Native Language: ' + value + '\n')
                before = self.tree_bytes()
                self.configure(expected=3)
                self.assertEqual(self.tree_bytes(), before)

    def test_code_markup_in_actual_value_is_not_silently_accepted(self):
        self.assertEqual(language_settings('Project Native Language: English `extra`\n'),
                         [(0, 'English `extra`')])

    def test_lesson_title_can_contain_literal_code(self):
        path = self.target / 'lessons.md'
        path.write_text('## Unsorted Lessons\n### [2026-09-11] `actual_topic`\n'
                        'Domain: engineering\nTarget Folder: blueprint/engineering\n')
        report = inspector.lessons(path, date(2026, 9, 11), 180)
        self.assertEqual(report['entries'][0]['title'], '`actual_topic`')
        self.assertEqual(report['issues'], [])

    def test_multiline_code_span_does_not_become_a_lesson(self):
        path = self.target / 'lessons.md'
        path.write_text('## Unsorted Lessons\n### [2026-09-11] Actual lesson\n'
                        'Example `first line\nDomain: example\nlast line`\n')
        report = inspector.lessons(path, date(2026, 9, 11), 180)
        self.assertEqual(len(report['entries']), 1)
        self.assertEqual(report['entries'][0]['domain'], '')

    def test_source_line_numbers_do_not_treat_unicode_separators_as_newlines(self):
        path = self.target / 'AXIARCH.md'
        text = 'Notes\u2028more notes\nProject Native Language: Japanese\r\n'
        path.write_bytes(text.encode())
        self.assertEqual(language_settings(text), [(1, 'Japanese')])
        self.configure()
        self.assertEqual(path.read_bytes(), text.replace('Language: Japanese', 'Language: English').encode())

    def test_lesson_after_code_comment_example_is_still_inspected(self):
        path = self.target / 'lessons.md'
        for example in ('```html\n<!-- literal opening token\n```\n',
                        'Use `<!--` in examples.\n\n'):
            with self.subTest(example=example):
                text = ('## Unsorted Lessons\n' + example + '### [2026-09-11] Actual lesson\n'
                        '<!-- actual hidden note -->\n')
                path.write_text(text)
                report = inspector.lessons(path, date(2026, 9, 11), 180)
                self.assertEqual(len(report['entries']), 1)
                self.assertIn('missing Domain', ' '.join(report['issues']))

    def test_unclosed_comment_does_not_expose_fake_lesson_entries(self):
        path = self.target / 'lessons.md'
        path.write_text('## Unsorted Lessons\n<!-- example only\n### [2026-09-11] Not a record\n')
        self.assertEqual(inspector.lessons(path, date(2026, 9, 11), 180)['entries'], [])

    def test_links_and_headings_after_literal_comments_are_checked(self):
        path = self.target / 'README.md'
        for example in ('```html\n<!-- literal marker\n```\n', 'Use `<!--` as an example.\n\n'):
            with self.subTest(example=example):
                text = example + '# Actual heading\n[broken](missing.md)\n<!-- actual comment -->\n'
                path.write_text(text)
                self.assertEqual(anchors(text), {'actual-heading'})
                self.assertTrue(any('missing path: missing.md' in issue for issue in inspect_docs(self.target)))

    def test_inline_link_example_is_not_an_actual_reference(self):
        (self.target / 'README.md').write_text('Example `[label](missing.md)` syntax.\n')
        self.assertEqual(inspect_docs(self.target), [])

    def test_startup_health_and_staged_update_agree_after_inline_example(self):
        self.install_source(); self.target = self.source
        path = self.target / 'AXIARCH.md'
        prefix = 'Use `<!--` in an explanatory example.\n\n'
        path.write_text(prefix + re.sub(r'^Project Native Language:.*$',
                                       'Project Native Language: English', path.read_text(), flags=re.M))
        self.boot()
        self.assertTrue((self.target / '.axiarch/sessions/s1/task.md').read_text().startswith('# Task\n'))
        before = self.tree_bytes()
        health = self.run_cmd(['bash', self.target / 'axiarch-scripts/check-axiarch-health.sh', self.target])
        self.assertIn('Project Native Language: en', health.stdout)
        self.assertEqual(self.tree_bytes(), before)
        self.configure('ja')
        self.assertTrue(path.read_text().startswith(prefix))
        self.assertIn('Project Native Language: Japanese', path.read_text())


if __name__ == '__main__':
    unittest.main()
