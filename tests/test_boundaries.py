"""Ownership, selection and optional-input boundary regressions."""
import json
import os
import shutil
import unittest

import test_runtime as runtime
import test_setup as setup

ROOT, SCRIPTS = runtime.ROOT, runtime.SCRIPTS


class BoundaryTests(unittest.TestCase):
    setUp = runtime.RuntimeTests.setUp
    run_cmd = runtime.RuntimeTests.run_cmd
    tree_bytes = runtime.RuntimeTests.tree_bytes
    upgrade_fixture = runtime.RuntimeTests.upgrade_fixture
    upgrade = runtime.RuntimeTests.upgrade
    prompt_fixture = setup.SetupTests.prompt_fixture
    prompts = setup.SetupTests.prompts

    def manifest(self, entries):
        (self.source / 'axiarch-manifest.json').write_text(json.dumps(dict(axiarchVersion='2.0.0', files=entries)))

    def test_parent_selection_cannot_bypass_child_preservation(self):
        self.upgrade_fixture()
        (self.target / 'core').mkdir()
        (self.target / 'core/rule.md').write_bytes((self.base / 'core/rule.md').read_bytes())
        (self.source / 'core/rule.md').write_text('new upstream\n')
        self.manifest([dict(path='core', group='universal_rules', owner='axiarch', policy='replace'),
                       dict(path='core/rule.md', group='local', owner='project', policy='preserve')])
        before = self.tree_bytes()
        self.upgrade('--apply', '--yes', expected=5)
        self.assertEqual(self.tree_bytes(), before)

    def test_conflicting_duplicate_paths_stop_before_mutation(self):
        self.upgrade_fixture()
        for alias in ('core/rule.md', 'core/./rule.md'):
            with self.subTest(alias=alias):
                self.manifest([dict(path='core/rule.md', group='universal_rules', owner='axiarch', policy='replace'),
                               dict(path=alias, group='local', owner='project', policy='preserve')])
                before = self.tree_bytes()
                self.upgrade('--apply', '--yes', expected=5)
                self.assertEqual(self.tree_bytes(), before)

    def test_directory_exclusions_apply_to_descendants(self):
        self.upgrade_fixture()
        (self.source / 'core/private').mkdir()
        (self.source / 'core/private/secret.md').write_text('source example')
        (self.target / 'core/private').mkdir(parents=True)
        (self.target / 'core/private/secret.md').write_text('adopter owned')
        # Without exclusion this file would be accepted as an explicit known base.
        (self.base / 'core/private').mkdir()
        (self.base / 'core/private/secret.md').write_text('adopter owned')
        self.manifest([dict(path='core', group='universal_rules', owner='axiarch', policy='replace', exclude=['core/private']),
                       dict(path='axiarch-scripts', group='scripts', owner='axiarch', policy='replace')])
        self.upgrade('--apply', '--yes')
        self.assertEqual((self.target / 'core/private/secret.md').read_text(), 'adopter owned')
        self.assertEqual((self.target / 'core/rule.md').read_text(), 'upstream\n')

    def test_glob_and_literal_conflicting_ownership_stop_before_mutation(self):
        self.upgrade_fixture()
        self.manifest([dict(path='core/*.md', group='universal_rules', owner='axiarch', policy='replace'),
                       dict(path='core/rule.md', group='local', owner='project', policy='preserve')])
        before = self.tree_bytes()
        self.upgrade('--apply', '--yes', expected=5)
        self.assertEqual(self.tree_bytes(), before)

    def test_parent_exclusion_also_applies_to_literal_file_entries(self):
        self.upgrade_fixture()
        (self.target / 'core').mkdir()
        (self.target / 'core/rule.md').write_bytes((self.base / 'core/rule.md').read_bytes())
        self.manifest([dict(path='core/rule.md', group='universal_rules', owner='axiarch', policy='replace', exclude=['core']),
                       dict(path='axiarch-scripts', group='scripts', owner='axiarch', policy='replace')])
        before = (self.target / 'core/rule.md').read_bytes()
        self.upgrade('--apply', '--yes')
        self.assertEqual((self.target / 'core/rule.md').read_bytes(), before)

    def test_special_file_is_rejected_before_preview_reads(self):
        self.upgrade_fixture()
        os.mkfifo(self.source / 'core/pipe')
        before = self.tree_bytes()
        self.upgrade('--dry-run', expected=5)
        self.assertEqual(self.tree_bytes(), before)

    def test_uppercase_command_prefix_is_a_collision(self):
        self.prompt_fixture()
        (self.commands / 'AXIARCH-demo.md').write_text('adopter command\n')
        before = self.tree_bytes(); self.prompts(expected=3)
        self.assertEqual(self.tree_bytes(), before)

    def test_ambiguous_auto_language_keeps_existing_commands(self):
        self.prompt_fixture(); self.prompts()
        for tree in ('axiarch-rules', 'axiarch-prompts'):
            shutil.copytree(self.target / tree / 'en', self.target / tree / 'ja')
        for setting in ('Project Native Language: English\nProject Native Language: Japanese\n',
                        'Project Native Language: Esperanto\n'):
            with self.subTest(setting=setting):
                (self.target / 'AXIARCH.md').write_text(setting)
                before = self.tree_bytes(); self.prompts(expected=3)
                self.assertEqual(self.tree_bytes(), before)


if __name__ == '__main__':
    unittest.main()
