"""Reject private payloads and wrong distribution types before adopter writes."""
import json
import os
import shutil
import sys
import unittest

import test_runtime as runtime
import test_setup as setup


class DistributionBoundaryTests(unittest.TestCase):
    setUp = runtime.RuntimeTests.setUp
    run_cmd = runtime.RuntimeTests.run_cmd
    tree_bytes = runtime.RuntimeTests.tree_bytes
    upgrade_fixture = runtime.RuntimeTests.upgrade_fixture
    upgrade = runtime.RuntimeTests.upgrade
    install_source = setup.SetupTests.install_source

    def set_payload(self, path):
        manifest = {'axiarchVersion': '2.0.0', 'files': [
            {'path': path, 'group': 'universal_rules', 'owner': 'axiarch', 'policy': 'replace'}]}
        (self.source / 'axiarch-manifest.json').write_text(json.dumps(manifest))

    def test_manifest_cannot_select_root_git_or_private_state(self):
        self.upgrade_fixture()
        for rel in ('.', './', '.git/config', '.axiarch/sessions',
                    'nested/.git/config', 'nested/.AXIARCH/private.txt'):
            with self.subTest(path=rel):
                self.set_payload(rel)
                before = self.tree_bytes()
                for flags in (('--dry-run',), ('--apply', '--yes')):
                    result = self.upgrade(*flags, expected=None)
                    self.assertNotEqual(result.returncode, 0)
                    self.assertIn('reserved distribution path', result.stdout + result.stderr)
                    self.assertEqual(before, self.tree_bytes())

    def test_case_and_unicode_alias_selections_preserve_adopter_and_retry(self):
        self.upgrade_fixture()
        shutil.copytree(self.base / 'core', self.target / 'core')
        (self.source / 'core/rule.md').write_text('next upstream\n')
        for first, second in (('CORE/rule.md', 'core/rule.md'),
                              ('core/Caf\u00e9.md', 'core/Cafe\u0301.md'),
                              ('core', 'CORE/rule.md')):
            with self.subTest(paths=(first, second)):
                manifest = {'axiarchVersion': '2.0.0', 'files': [
                    {'path': first, 'group': 'universal_rules', 'owner': 'axiarch', 'policy': 'replace'},
                    {'path': second, 'group': 'blueprint_project_state', 'owner': 'project', 'policy': 'preserve'}]}
                (self.source / 'axiarch-manifest.json').write_text(json.dumps(manifest))
                before = self.tree_bytes()
                for flags in (('--dry-run',), ('--apply', '--yes')):
                    result = self.upgrade(*flags, expected=5)
                    self.assertIn('ambiguous distribution names', result.stderr)
                    self.assertEqual(before, self.tree_bytes())
        self.set_payload('core')
        (self.target / 'axiarch-scripts').mkdir()
        (self.target / 'axiarch-scripts/check-axiarch-health.sh').write_text('exit 0\n')
        self.upgrade('--apply', '--yes')
        self.assertEqual((self.target / 'core/rule.md').read_text(), 'next upstream\n')
        self.assertEqual((self.target / 'local.md').read_text(), 'project specification and lessons\n')

    def test_expanded_directory_names_cannot_alias_adopter_files(self):
        self.upgrade_fixture()
        self.set_payload('core')
        (self.target / 'core').mkdir()
        (self.target / 'core/Rule.md').write_bytes((self.base / 'core/rule.md').read_bytes())
        (self.source / 'core/rule.md').write_text('next upstream\n')
        before = self.tree_bytes()
        for flags in (('--dry-run',), ('--apply', '--yes')):
            result = self.upgrade(*flags, expected=5)
            self.assertIn('ambiguous distribution names', result.stderr)
            self.assertEqual(before, self.tree_bytes())

    def test_direct_copy_rejects_aliases_before_partial_write(self):
        self.upgrade_fixture()
        (self.source / 'core/a-first.md').write_text('must not be copied before rejection')
        (self.target / 'core').mkdir()
        (self.target / 'core/Rule.md').write_text('synthetic private data')
        before = self.tree_bytes()
        result = self.run_cmd([sys.executable, runtime.SCRIPTS / 'axiarch_upgrade.py', 'copy',
                               '--source', self.source, '--target', self.target,
                               '--path', 'core', '--apply'], expected=5)
        self.assertIn('ambiguous distribution names', result.stderr)
        self.assertNotIn('synthetic private data', result.stdout + result.stderr)
        self.assertEqual(before, self.tree_bytes())

    def test_direct_copy_preflights_all_trees_before_any_write(self):
        self.upgrade_fixture()
        (self.source / 'core/a-first.md').write_text('valid payload before invalid name')
        (self.target / 'core').mkdir()
        sentinel = self.root / 'synthetic-private.txt'
        sentinel.write_text('synthetic-secret-never-print')
        command = [sys.executable, runtime.SCRIPTS / 'axiarch_upgrade.py', 'copy',
                   '--source', self.source, '--target', self.target, '--base', self.base,
                   '--path', 'core']
        for directory in (self.source, self.target, self.base):
            for kind in ('control', 'symlink', 'fifo'):
                with self.subTest(directory=directory.name, kind=kind):
                    path = directory / 'core' / ('z-bad\nname.md' if kind == 'control' else 'z-invalid')
                    if kind == 'symlink':
                        path.symlink_to(sentinel)
                    elif kind == 'fifo':
                        os.mkfifo(path)
                    else:
                        path.write_bytes(sentinel.read_bytes())
                    before = self.tree_bytes()
                    try:
                        for flags in ([], ['--apply']):
                            result = self.run_cmd([*command, *flags], expected=5)
                            self.assertNotIn('synthetic-secret-never-print', result.stdout + result.stderr)
                            self.assertNotIn('UPDATE ', result.stdout)
                            self.assertEqual(before, self.tree_bytes())
                            self.assertTrue(path.exists())
                            if kind == 'symlink':
                                self.assertTrue(path.is_symlink())
                        self.assertEqual(sentinel.read_text(), 'synthetic-secret-never-print')
                    finally:
                        path.unlink()
        before = self.tree_bytes()
        self.run_cmd(command)
        self.assertEqual(before, self.tree_bytes())
        self.run_cmd([*command, '--apply'])
        self.assertEqual((self.target / 'core/a-first.md').read_bytes(),
                         (self.source / 'core/a-first.md').read_bytes())
        self.assertEqual((self.target / 'local.md').read_text(), 'project specification and lessons\n')

    def test_direct_copy_propagates_io_failure_and_supports_retry(self):
        self.upgrade_fixture()
        for name in ('a-first.md', 'b-fail.md', 'c-last.md'):
            (self.source / 'core' / name).write_text('upstream ' + name)
        probe = '''import sys
from pathlib import Path
sys.path.insert(0, sys.argv.pop(1))
import axiarch_upgrade as upgrade
original = upgrade.shutil.copy2
def failing_copy(source, target, *args, **kwargs):
    if Path(source).name == 'b-fail.md':
        raise OSError('injected write failure')
    return original(source, target, *args, **kwargs)
upgrade.shutil.copy2 = failing_copy
sys.exit(upgrade.main())
'''
        arguments = ['copy', '--source', self.source, '--target', self.target,
                     '--base', self.base, '--path', 'core', '--apply']
        result = self.run_cmd([sys.executable, '-c', probe, runtime.SCRIPTS, *arguments], expected=5)
        self.assertIn('APPLY-FAIL core/b-fail.md: injected write failure', result.stdout)
        self.assertFalse((self.target / 'core/b-fail.md').exists())
        self.assertFalse(list((self.target / 'core').glob('.upgrade-*')))
        for name in ('a-first.md', 'c-last.md'):
            self.assertEqual((self.target / 'core' / name).read_bytes(),
                             (self.source / 'core' / name).read_bytes())
        retry = self.run_cmd([sys.executable, runtime.SCRIPTS / 'axiarch_upgrade.py', *arguments])
        self.assertIn('UNCHANGED core/a-first.md', retry.stdout)
        self.assertIn('UPDATE core/b-fail.md', retry.stdout)
        self.assertEqual((self.target / 'core/b-fail.md').read_bytes(),
                         (self.source / 'core/b-fail.md').read_bytes())
        self.assertEqual((self.target / 'local.md').read_text(), 'project specification and lessons\n')

    def test_public_upgrade_records_copy_failure_without_confirming_version(self):
        self.upgrade_fixture()
        (self.source / 'core/a-first.md').write_text('successful earlier copy')
        (self.source / 'core/b-fail.md').write_text('retry this file')
        launcher = self.root / 'launcher'
        shutil.copytree(runtime.SCRIPTS, launcher)
        helper = launcher / 'axiarch_upgrade.py'
        injection = '''original_copy = shutil.copy2
def failing_copy(source, target, *args, **kwargs):
    if Path(source).name == 'b-fail.md':
        raise OSError('injected write failure')
    return original_copy(source, target, *args, **kwargs)
shutil.copy2 = failing_copy


'''
        original = helper.read_text()
        self.assertEqual(original.count('if __name__ == "__main__":'), 1)
        helper.write_text(original.replace('if __name__ == "__main__":',
                                           injection + 'if __name__ == "__main__":'))
        self.run_cmd(['bash', launcher / 'axiarch-upgrade.sh', '--source', self.source,
                      '--base-source', self.base, '--target', self.target,
                      '--apply', '--yes'], expected=5)
        meta = self.target / '.axiarch'
        result = json.loads((meta / 'upgrade-result.json').read_text())
        version = json.loads((meta / 'version.json').read_text())
        self.assertEqual(result['application'], 'failed')
        self.assertEqual(result['health']['status'], 'passed')
        self.assertIsNone(result['confirmed_version'])
        self.assertIsNone(version['version'])
        self.assertEqual(version['requestedVersion'], '2.0.0')
        self.assertIn('APPLY-FAIL core/b-fail.md: injected write failure',
                      (meta / 'upgrades' / result['run_id'] / 'actions.log').read_text())
        self.assertTrue((self.target / 'core/a-first.md').is_file())
        self.assertFalse((self.target / 'core/b-fail.md').exists())
        self.upgrade('--apply', '--yes')
        retry = json.loads((meta / 'upgrade-result.json').read_text())
        self.assertNotEqual(result['run_id'], retry['run_id'])
        self.assertEqual(retry['application'], 'complete')
        self.assertEqual(retry['confirmed_version'], '2.0.0')
        self.assertEqual(json.loads((meta / 'upgrades' / result['run_id'] / 'result.json').read_text()), result)
        self.assertEqual((self.target / 'core/b-fail.md').read_text(), 'retry this file')
        self.assertEqual((self.target / 'local.md').read_text(), 'project specification and lessons\n')

    def test_install_source_check_rejects_portable_alias_selections(self):
        self.upgrade_fixture()
        before = self.tree_bytes()
        result = self.run_cmd([sys.executable, runtime.SCRIPTS / 'axiarch_setup.py', 'check-source',
                               '--source', self.source, '--paths', 'core', 'CORE'], expected=3)
        self.assertIn('ambiguous distribution names', result.stderr)
        self.assertEqual(before, self.tree_bytes())

    def test_private_descendant_stops_upgrade_before_any_payload_write(self):
        self.upgrade_fixture()
        self.set_payload('core')
        for reserved in ('.git', '.axiarch', '.GIT'):
            with self.subTest(directory=reserved):
                folder = self.source / 'core' / reserved; folder.mkdir()
                (folder / 'synthetic-private.txt').write_text('synthetic-secret-never-print')
                before = self.tree_bytes()
                for flags in (('--dry-run',), ('--apply', '--yes')):
                    result = self.upgrade(*flags, expected=None)
                    self.assertNotEqual(result.returncode, 0)
                    self.assertNotIn('synthetic-secret-never-print', result.stdout + result.stderr)
                    self.assertEqual(before, self.tree_bytes())
                shutil.rmtree(folder)

    def test_private_glob_match_is_rejected_after_expansion(self):
        self.upgrade_fixture()
        private = self.source / '.axiarch'; private.mkdir()
        (private / 'record.json').write_text('{}')
        self.set_payload('.a?iarch/record.json')
        before = self.tree_bytes()
        result = self.upgrade('--apply', '--yes', expected=None)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('reserved distribution path', result.stdout + result.stderr)
        self.assertEqual(before, self.tree_bytes())

    def test_glob_control_names_cannot_inject_unselected_paths(self):
        self.upgrade_fixture()
        self.set_payload('core/*')
        (self.source / 'core/a.md').write_text('ordinary rule\n')
        (self.source / 'outside.md').write_text('upstream outside chosen folder\n')
        (self.base / 'outside.md').write_text('adopter original\n')
        (self.target / 'outside.md').write_text('adopter original\n')
        (self.target / 'core').mkdir()
        for root in (self.source, self.target):
            for control in ('\n', '\r', '\t', '\x1b', '\x7f', '\x85', '\u2028', '\u2029'):
                with self.subTest(root=root.name, control=repr(control)):
                    malformed = root / ('core/a.md' + control + 'outside.md')
                    malformed.write_text('synthetic-private-content-never-print')
                    before = self.tree_bytes()
                    for flags in (('--dry-run',), ('--apply', '--yes')):
                        result = self.upgrade(*flags, expected=5)
                        self.assertIn('control characters', result.stdout + result.stderr)
                        self.assertNotIn('synthetic-private-content-never-print', result.stdout + result.stderr)
                        self.assertEqual(before, self.tree_bytes())
                    malformed.unlink()
        # The repaired source can be retried. The unselected file stays intact.
        scripts = self.target / 'axiarch-scripts'; scripts.mkdir()
        (scripts / 'check-axiarch-health.sh').write_text('#!/bin/bash\nexit 0\n')
        self.upgrade('--apply', '--yes')
        self.assertEqual((self.target / 'outside.md').read_text(), 'adopter original\n')
        self.assertEqual((self.target / 'core/a.md').read_text(), 'ordinary rule\n')

    def test_glob_helper_emits_no_partial_selection_for_invalid_name(self):
        self.upgrade_fixture()
        (self.source / 'core/z\ninvalid.md').write_text('synthetic content')
        result = self.run_cmd([sys.executable, runtime.SCRIPTS / 'axiarch_upgrade.py', 'expand-glob',
                               '--source', self.source, '--path', 'core/*'], expected=5)
        self.assertEqual(result.stdout, '')
        self.assertNotIn('synthetic content', result.stderr)

    def test_unicode_separators_cannot_bypass_manifest_or_direct_copy(self):
        self.upgrade_fixture()
        for separator in ('\x85', '\u2028', '\u2029'):
            with self.subTest(separator=repr(separator)):
                relative = 'core/rule' + separator + 'UPDATE outside.md'
                (self.source / relative).write_text('synthetic content')
                self.set_payload(relative)
                before = self.tree_bytes()
                result = self.upgrade('--apply', '--yes', expected=5)
                self.assertIn('invalid manifest path', result.stderr)
                self.run_cmd([sys.executable, runtime.SCRIPTS / 'axiarch_upgrade.py', 'copy',
                              '--source', self.source, '--target', self.target,
                              '--path', relative, '--apply'], expected=5)
                self.assertEqual(before, self.tree_bytes())

    def test_legacy_blueprint_discovery_rejects_whole_control_names(self):
        self.upgrade_fixture()
        (self.source / 'axiarch-manifest.json').write_text('{"axiarchVersion":"2.0.0"}')
        for relative in ('axiarch-rules/en/blueprint/team/010_note\nother.md',
                         'axiarch-rules/en/blueprint/team\nsplit/README.md',
                         'axiarch-rules/en/blueprint/team/010_note\u2028other.md'):
            with self.subTest(path=repr(relative)):
                path = self.source / relative; path.parent.mkdir(parents=True)
                path.write_text('synthetic content')
                before = self.tree_bytes()
                for flags in (('--dry-run',), ('--apply', '--yes')):
                    result = self.upgrade(*flags, expected=5)
                    self.assertIn('control characters', (result.stdout + result.stderr).lower())
                    self.assertEqual(before, self.tree_bytes())
                shutil.rmtree(self.source / 'axiarch-rules')

    def test_glob_preserves_spaces_unicode_exclusions_and_literal_root(self):
        self.upgrade_fixture()
        moved = self.root / 'source [version]'; self.source.rename(moved); self.source = moved
        self.set_payload('core/*.md')
        (self.source / 'core/運用 rule.md').write_text('selected\n')
        (self.source / 'core/.hidden.md').write_text('hidden\n')
        (self.source / 'core/skip.md').write_text('excluded\n')
        manifest = json.loads((self.source / 'axiarch-manifest.json').read_text())
        manifest['files'][0]['exclude'] = ['core/skip.md']
        (self.source / 'axiarch-manifest.json').write_text(json.dumps(manifest))
        scripts = self.target / 'axiarch-scripts'; scripts.mkdir()
        (scripts / 'check-axiarch-health.sh').write_text('#!/bin/bash\nexit 0\n')
        self.upgrade('--apply', '--yes')
        self.assertEqual((self.target / 'core/運用 rule.md').read_text(), 'selected\n')
        self.assertFalse((self.target / 'core/.hidden.md').exists())
        self.assertFalse((self.target / 'core/skip.md').exists())

    def test_copy_helper_cannot_force_reserved_payload(self):
        self.upgrade_fixture()
        private = self.source / '.axiarch'; private.mkdir()
        (private / 'record.json').write_text('{}')
        before = self.tree_bytes()
        result = self.run_cmd([sys.executable, runtime.SCRIPTS / 'axiarch_upgrade.py', 'copy',
                               '--source', self.source, '--target', self.target,
                               '--path', '.axiarch', '--force', '--apply'], expected=None)
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(before, self.tree_bytes())

    def test_wrong_required_file_types_leave_adopter_unchanged(self):
        self.install_source(health=0)
        for rel in ('axiarch-rules/LICENSE', 'axiarch-rules/NOTICE', 'AGENTS.md'):
            with self.subTest(path=rel):
                path = self.source / rel; content = path.read_bytes(); path.unlink(); path.mkdir()
                before = self.tree_bytes()
                result = self.run_cmd(['bash', self.source / 'init.sh', self.target],
                                      text='2\n2\n7\nn\nn\n', expected=3)
                self.assertIn('required distribution file', result.stdout + result.stderr)
                self.assertEqual(before, self.tree_bytes())
                path.rmdir(); path.write_bytes(content)

    def test_wrong_required_directory_type_is_rejected(self):
        self.install_source(health=0)
        directory = self.source / 'axiarch-prompts'
        shutil.rmtree(directory); directory.write_text('not a directory')
        before = self.tree_bytes()
        self.run_cmd(['bash', self.source / 'init.sh', self.target],
                     text='2\n2\n7\ny\nn\n', expected=3)
        self.assertEqual(before, self.tree_bytes())

    def test_install_rejects_private_source_descendant(self):
        self.install_source(health=0)
        folder = self.source / 'axiarch-rules/en/.axiarch'; folder.mkdir()
        (folder / 'private.txt').write_text('synthetic-secret-never-print')
        before = self.tree_bytes()
        result = self.run_cmd(['bash', self.source / 'init.sh', self.target],
                              text='2\n2\n7\nn\nn\n', expected=3)
        self.assertNotIn('synthetic-secret-never-print', result.stdout + result.stderr)
        self.assertEqual(before, self.tree_bytes())

    def test_direct_staged_install_cannot_copy_internal_stores(self):
        stage = self.root / 'stage'; (stage / '.axiarch').mkdir(parents=True)
        (stage / '.axiarch/private.txt').write_text('synthetic private note')
        before = self.tree_bytes()
        self.run_cmd([sys.executable, runtime.SCRIPTS / 'axiarch_setup.py', 'install',
                      '--target', self.target, '--stage', stage, '--version', '2.0.0', '--lang', 'en'], expected=3)
        self.assertEqual(before, self.tree_bytes())

    def test_regular_adapter_directories_are_not_reserved(self):
        self.upgrade_fixture()
        files = ['.github/copilot-instructions.md', '.codex/hooks.json',
                 '.claude/settings.json', 'core/.gitignore', 'core/.axiarch-example.md']
        rows = []
        for rel in files:
            source = self.source / rel; source.parent.mkdir(parents=True, exist_ok=True)
            source.write_text('{}' if source.suffix == '.json' else 'fixture')
            rows.append(dict(path=rel, group='universal_rules', owner='axiarch', policy='replace'))
        rows.append(dict(path='axiarch-scripts', group='scripts', owner='axiarch', policy='replace'))
        (self.source / 'axiarch-manifest.json').write_text(json.dumps({'axiarchVersion':'2.0.0','files':rows}))
        self.upgrade('--apply', '--yes')
        for rel in files:
            self.assertEqual((self.target / rel).read_bytes(), (self.source / rel).read_bytes())
