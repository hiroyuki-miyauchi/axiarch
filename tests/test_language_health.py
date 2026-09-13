"""Language configuration diagnostics, without agents, credentials or network."""
import re
import shutil
import sys
import unittest

import test_runtime as runtime
import test_setup as setup


class LanguageHealthTests(unittest.TestCase):
    run_cmd = runtime.RuntimeTests.run_cmd
    tree_bytes = runtime.RuntimeTests.tree_bytes
    install_source = setup.SetupTests.install_source
    state = runtime.RuntimeTests.state
    boot = runtime.RuntimeTests.boot

    def setUp(self):
        runtime.RuntimeTests.setUp(self)
        self.install_source(); self.target = self.source
        self.canonical = self.target / 'AXIARCH.md'
        self.original = self.canonical.read_text()

    def configure(self, setting, prefix=''):
        self.canonical.write_text(prefix + re.sub(r'^Project Native Language:.*$', setting,
                                                 self.original, flags=re.M))

    def health(self, *args, expected=0, extra=None):
        return self.run_cmd(['bash', self.target / 'axiarch-scripts/check-axiarch-health.sh',
                             self.target, *args], env=dict(self.env, **(extra or {})), expected=expected)

    def language(self, expected=0):
        return self.run_cmd([sys.executable, runtime.SCRIPTS / 'axiarch_state.py',
                             '--project', self.target, '--mode', 'language'], expected=expected)

    def test_examples_do_not_override_actual_configuration(self):
        for prefix in ('```text\nProject Native Language: English\n```\n',
                       '<!--\nProject Native Language: English\n-->\n',
                       'The Project Native Language: English is an example.\n',
                       '> Project Native Language: English\n'):
            with self.subTest(prefix=prefix):
                self.configure('Project Native Language: Japanese', prefix)
                before = self.tree_bytes()
                self.assertEqual(self.language().stdout.strip(), 'ja')
                result = self.health()
                self.assertIn('Project Native Language: ja', result.stdout)
                self.assertEqual(self.tree_bytes(), before)

    def test_invalid_or_ambiguous_configuration_fails_health_even_with_generation_override(self):
        for setting in ('Project Native Language: Klingon', 'Project Native Language:',
                        'Project Native Language: English\nProject Native Language: Japanese'):
            with self.subTest(setting=setting):
                self.configure(setting)
                before = self.tree_bytes()
                self.language(expected=2)
                result = self.health('--quiet', expected=1, extra={'AXIARCH_PROCESS_DOC_LANG': 'en'})
                self.assertIn('LANGUAGE UNASSESSED', result.stdout + result.stderr)
                self.assertEqual(self.tree_bytes(), before)

    def test_supported_forms_have_the_same_result_as_generation(self):
        for setting, lang in (('English', 'en'), ('[Japanese]', 'ja'),
                              ('[Japanese | English] (Default: English)', 'en')):
            with self.subTest(setting=setting):
                self.configure('Project Native Language: ' + setting)
                self.assertEqual(self.language().stdout.strip(), lang)
                self.assertIn('Project Native Language: ' + lang, self.health().stdout)

    def test_literal_comment_in_code_does_not_hide_later_configuration(self):
        for prefix in ('```html\n<!-- Example opening token\n```\n',
                       '~~~html\n<!-- Literal comment\n~~~\n',
                       '<!--\n```\nProject Native Language: Japanese\n-->\n'):
            with self.subTest(prefix=prefix):
                self.configure('Project Native Language: English', prefix)
                before = self.tree_bytes()
                self.assertEqual(self.language().stdout.strip(), 'en')
                self.assertIn('Project Native Language: en', self.health().stdout)
                self.assertEqual(self.tree_bytes(), before)
                # The same parser supplies original line positions to setup.
                self.run_cmd([sys.executable, runtime.SCRIPTS / 'axiarch_setup.py',
                              'configure-language', '--target', self.target, '--lang', 'ja'])
                self.assertTrue(self.canonical.read_text().startswith(prefix))
                self.assertEqual(self.language().stdout.strip(), 'ja')

    def test_canonical_setting_precedes_legacy_adapter(self):
        (self.target / 'AGENTS.md').write_text('Project Native Language: English\n')
        self.configure('Project Native Language: Japanese')
        self.assertIn('Project Native Language: ja', self.health().stdout)
        self.configure('')
        self.assertEqual(self.language().stdout.strip(), 'en')
        self.assertIn('Project Native Language: en', self.health().stdout)

    def test_missing_setting_uses_the_existing_folder_fallback_without_bootstrap(self):
        self.configure('')
        self.assertIn('Project Native Language: ja', self.health().stdout)
        shutil.rmtree(self.target / 'axiarch-rules/ja')
        shutil.rmtree(self.target / 'axiarch-harness/ja')
        before = self.tree_bytes()
        self.assertEqual(self.language().stdout.strip(), 'en')
        self.assertIn('Project Native Language: en', self.health().stdout)
        self.assertEqual(self.tree_bytes(), before)
        self.assertFalse((self.target / '.axiarch/tasks').exists())

    def test_old_and_parallel_records_are_not_language_compliance_evidence(self):
        self.configure('Project Native Language: English')
        self.boot(); self.boot('s2', 't2')
        (self.target / 'task.md').write_text('# 旧記録の例\n\n引用を残す。\n')
        (self.target / '.axiarch/sessions/s2/task.md').write_text('# 別タスク\n\n記録を保持。\n')
        before = self.tree_bytes()
        result = self.health('--session', 's1')
        self.assertIn('Document language and meaning are not assessed', result.stdout)
        self.assertNotIn('process docs contain', result.stdout)
        self.assertNotIn('appear consistent', result.stdout)
        self.assertEqual(self.tree_bytes(), before)

    def test_configuration_symlink_is_not_read_as_valid(self):
        outside = self.root / 'private.txt'; outside.write_text('fixture-private-detail\n')
        self.canonical.unlink(); self.canonical.symlink_to(outside)
        result = self.health('--quiet', expected=1)
        self.assertIn('LANGUAGE UNASSESSED', result.stdout + result.stderr)
        self.assertNotIn('fixture-private-detail', result.stdout + result.stderr)
        self.assertEqual(outside.read_text(), 'fixture-private-detail\n')


if __name__ == '__main__':
    unittest.main()
