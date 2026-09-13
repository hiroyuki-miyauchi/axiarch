"""Private runtime artifacts and terminal display boundaries, using synthetic data."""
import json
import fcntl
import os
import shutil
import stat
import unittest
from unittest.mock import patch

import test_runtime as runtime
import test_setup as setup
import test_state_failures as state_failures

ROOT, SCRIPTS = runtime.ROOT, runtime.SCRIPTS


class PrivacyTests(unittest.TestCase):
    setUp = runtime.RuntimeTests.setUp
    run_cmd = runtime.RuntimeTests.run_cmd
    state = runtime.RuntimeTests.state
    boot = runtime.RuntimeTests.boot
    tree_bytes = runtime.RuntimeTests.tree_bytes
    upgrade_fixture = runtime.RuntimeTests.upgrade_fixture
    upgrade = runtime.RuntimeTests.upgrade
    install_source = setup.SetupTests.install_source
    module = state_failures.StateFailureTests.module

    def git_init(self):
        self.run_cmd(['git', 'init', '-q', self.target])

    def ignored(self, *paths):
        output = self.run_cmd(['git', 'check-ignore', '--no-index', '--stdin'], text='\n'.join(paths) + '\n')
        self.assertEqual(set(output.stdout.splitlines()), set(paths))

    def test_session_adds_private_exclusions_preserves_existing_policy(self):
        self.git_init()
        (self.target / '.gitignore').write_text('/custom-private/\n')
        meta = self.target / '.axiarch'; meta.mkdir()
        policy = meta / '.gitignore'; policy.write_text('# project policy\n/extra/\n')
        self.boot()
        self.ignored('.axiarch/sessions/s1/task.md', '.axiarch/tasks/t1/state.json',
                     '.axiarch/upgrades/future/backup/user.md', '.axiarch/conflicts/user.md',
                     '.axiarch/install-health.log', '.axiarch/privacy.lock')
        self.assertTrue(policy.read_text().startswith('# project policy\n/extra/\n'))
        self.assertEqual((self.target / '.gitignore').read_text(), '/custom-private/\n')
        before = policy.read_bytes()
        self.boot(mode='resume')
        self.assertEqual(policy.read_bytes(), before)

    def test_unsafe_policy_files_are_rejected_without_touching_the_destination(self):
        meta = self.target / '.axiarch'; meta.mkdir()
        path = meta / '.gitignore'
        external = self.root / 'unrelated'; external.write_text('preserve\n')
        for kind in ('symlink', 'fifo', 'hardlink'):
            with self.subTest(kind=kind):
                if kind == 'symlink':
                    path.symlink_to(external)
                elif kind == 'fifo':
                    os.mkfifo(path)
                else:
                    os.link(external, path)
                try:
                    self.state('--mode', 'new', '--session', 's1', '--task', 't1', expected=2)
                    self.assertEqual(external.read_text(), 'preserve\n')
                finally:
                    path.unlink()

    def test_install_log_is_private_and_ignored(self):
        self.install_source(health=0)
        health = self.source / 'axiarch-scripts/check-axiarch-health.sh'
        health.write_text('#!/bin/bash\necho "synthetic-private-detail"\nexit 0\n')
        self.git_init()
        output = self.run_cmd(['bash', self.source / 'init.sh', self.target], text='2\n2\n7\nn\nn\n')
        self.assertNotIn('synthetic-private-detail', output.stdout + output.stderr)
        log = self.target / '.axiarch/install-health.log'
        self.assertIn('synthetic-private-detail', log.read_text())
        self.assertEqual(stat.S_IMODE(log.stat().st_mode), 0o600)
        self.ignored('.axiarch/install-health.log', '.axiarch/install-result.json')

    def test_upgrade_run_is_private_and_ignored(self):
        self.upgrade_fixture()
        self.git_init()
        self.upgrade('--apply', '--yes')
        run = next((self.target / '.axiarch/upgrades').iterdir())
        self.assertEqual(stat.S_IMODE(run.stat().st_mode), 0o700)
        self.ignored(str((run / 'health.log').relative_to(self.target)), '.axiarch/upgrade-result.json')

    def test_control_characters_in_manifest_fail_before_target_mutation(self):
        self.upgrade_fixture()
        path = self.source / 'axiarch-manifest.json'; original = json.loads(path.read_text())
        for char in ('\x00', '\x1b', '\x07', '\x7f'):
            for field in ('version', 'label'):
                with self.subTest(char=repr(char), field=field):
                    data = dict(original)
                    if field == 'version':
                        data['axiarchVersion'] = '2.0' + char + '.0'
                    else:
                        data['groups'] = [{'id': 'universal_rules', 'labelJa': 'title' + char + 'suffix'}]
                    path.write_text(json.dumps(data))
                    before = self.tree_bytes()
                    self.upgrade('--apply', '--yes', expected=5)
                    self.assertEqual(self.tree_bytes(), before)

    def test_manifest_backslashes_are_printed_literally(self):
        self.upgrade_fixture()
        path = self.source / 'axiarch-manifest.json'; data = json.loads(path.read_text())
        label = r'safe\e[31m\nFORGED'
        data['files'][0]['group'] = 'custom_group'
        data['groups'] = [{'id': 'custom_group', 'label': label, 'labelJa': label}]
        path.write_text(json.dumps(data))
        output = self.upgrade('--dry-run', '--interactive', text='').stdout
        self.assertIn(label, output)
        self.assertNotIn('\x1b[31m\nFORGED', output)

    def test_tracked_private_artifact_is_detected_without_untracking_it(self):
        self.git_init(); self.boot()
        self.run_cmd(['git', 'add', '-f', '.axiarch/tasks/t1/state.json'])
        before = self.run_cmd(['git', 'ls-files', '-z']).stdout
        result = self.state('--mode', 'privacy-check', expected=2)
        self.assertIn('tracked private artifacts', result.stderr)
        self.assertEqual(self.run_cmd(['git', 'ls-files', '-z']).stdout, before)

    def test_privacy_lock_conflict_preserves_policy_and_allows_retry(self):
        meta = self.target / '.axiarch'; meta.mkdir()
        policy = meta / '.gitignore'; policy.write_text('# custom\n')
        lock = meta / 'privacy.lock'
        with lock.open('w') as handle:
            fcntl.flock(handle, fcntl.LOCK_EX | fcntl.LOCK_NB)
            self.state('--mode', 'new', '--session', 's1', '--task', 't1', expected=2)
            self.assertEqual(policy.read_text(), '# custom\n')
        self.boot()
        self.assertTrue(policy.read_text().startswith('# custom\n'))

    def test_policy_replace_failure_leaves_original_policy_and_no_partial_temp(self):
        meta = self.target / '.axiarch'; meta.mkdir()
        policy = meta / '.gitignore'; policy.write_text('# custom\n')
        module = self.module()
        with patch.object(module.os, 'replace', side_effect=OSError('synthetic write error')):
            with self.assertRaises(OSError):
                module.protect_artifacts(self.target)
        self.assertEqual(policy.read_text(), '# custom\n')
        self.assertFalse(list(meta.glob('.privacy-*')))
        self.boot()

    def test_ignore_override_and_broken_repository_are_not_reported_as_protected(self):
        self.git_init(); self.boot()
        policy = self.target / '.axiarch/.gitignore'; old = policy.read_bytes()
        policy.write_bytes(old + b'!/tasks/\n!/tasks/**\n')
        result = self.state('--mode', 'privacy-check', expected=2)
        self.assertIn('unignored private artifacts', result.stderr)
        policy.write_bytes(old)
        (self.target / '.git/HEAD').unlink()
        result = self.state('--mode', 'privacy-check', expected=2)
        self.assertIn('repository state unassessed', result.stderr)

    def test_install_privacy_failure_overrides_zero_health_exit(self):
        self.install_source(health=0); self.git_init()
        script = self.source / 'axiarch-scripts/check-axiarch-health.sh'
        script.write_text('#!/bin/bash\ngit -C "$1" add -f -- .axiarch/install-result.json\nexit 0\n')
        self.run_cmd(['bash', self.source / 'init.sh', self.target], text='2\n2\n7\nn\nn\n', expected=4)
        report = json.loads((self.target / '.axiarch/install-result.json').read_text())
        self.assertEqual(report['application'], 'complete')
        self.assertEqual(report['health']['status'], 'failed')
        self.assertEqual(report['health']['exit_code'], 2)
        self.assertEqual(report['health']['script_exit_code'], 0)
        self.assertIn('tracked private artifacts', report['health']['privacy_error'])
        self.assertIsNone(report['confirmed_version'])

    def test_upgrade_privacy_failure_overrides_zero_health_exit(self):
        self.upgrade_fixture(); self.git_init()
        script = self.source / 'axiarch-scripts/check-axiarch-health.sh'
        script.write_text('#!/bin/bash\ngit -C "$1" add -f -- .axiarch/upgrade-result.json\nexit 0\n')
        self.upgrade('--apply', '--yes', expected=4)
        report = json.loads((self.target / '.axiarch/upgrade-result.json').read_text())
        self.assertEqual(report['application'], 'complete')
        self.assertEqual(report['health']['status'], 'failed')
        self.assertIn('tracked private artifacts', next((self.target / '.axiarch/upgrades').glob('*/health.log')).read_text())

    def test_control_characters_in_cli_rejected_without_mutation(self):
        self.upgrade_fixture(); before = self.tree_bytes()
        self.upgrade('--ref', 'heads/main\x1b[31m', expected=2)
        self.assertEqual(self.tree_bytes(), before)

    def test_deleted_worktree_records_remain_detectable_in_the_index(self):
        self.git_init(); self.boot()
        self.run_cmd(['git', 'add', '-f', '.axiarch/tasks/t1/state.json'])
        shutil.rmtree(self.target / '.axiarch')
        result = self.state('--mode', 'privacy-check', expected=2)
        self.assertIn('tracked private artifacts', result.stderr)

    def test_no_git_worktree_does_not_claim_index_was_checked(self):
        self.boot()
        result = self.state('--mode', 'privacy-check')
        self.assertIn('index tracking is unassessed', result.stdout)

    def test_git_is_required_for_repository_checks_but_not_standalone_records(self):
        self.boot(); module = self.module()
        with patch.object(module.shutil, 'which', return_value=None):
            self.assertIn('index tracking is unassessed', module.privacy_check(self.target))
        self.git_init()
        with patch.object(module.shutil, 'which', return_value=None):
            with self.assertRaisesRegex(ValueError, 'repository state unassessed'):
                module.privacy_check(self.target)

    def test_compatibility_conflict_copy_preserves_unrelated_hardlink_content(self):
        self.upgrade_fixture()
        manifest = {'axiarchVersion': '2.0.0', 'groups': [{'id': 'core_protocol', 'defaultAction': 'review-each'}],
                    'files': [{'path': 'merge.md', 'group': 'core_protocol', 'owner': 'mixed', 'policy': 'review'}]}
        (self.source / 'axiarch-manifest.json').write_text(json.dumps(manifest))
        for directory, value in ((self.source, 'upstream'), (self.base, 'base'), (self.target, 'local')):
            (directory / 'merge.md').write_text(value + '\n')
        scripts = self.target / 'axiarch-scripts'; scripts.mkdir()
        (scripts / 'check-axiarch-health.sh').write_text('exit 0\n')
        conflict = self.target / '.axiarch/conflicts/merge.md'; conflict.parent.mkdir(parents=True)
        original = self.root / 'unrelated'; original.write_text('synthetic-private-data\n')
        os.link(original, conflict)
        self.upgrade('--interactive', text='1\ny\n3\n', expected=3)
        self.assertEqual(original.read_text(), 'synthetic-private-data\n')
        self.assertIn('<<<<<<<', conflict.read_text())
        self.assertEqual(stat.S_IMODE(conflict.stat().st_mode), 0o600)


if __name__ == '__main__':
    unittest.main()
