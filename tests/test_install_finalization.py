"""Initial installs reconcile actual payloads after diagnostic execution."""
import hashlib
import json
import unittest

import test_setup as setup


class InstallFinalizationTests(unittest.TestCase):
    setUp = setup.SetupTests.setUp
    run_cmd = setup.SetupTests.run_cmd
    install_source = setup.SetupTests.install_source

    def upgrade(self, *args, **kwargs):
        # Select only the affected payload in this isolated recovery fixture.
        manifest = {'axiarchVersion': '1.18.0', 'files': [
            {'path': path, 'group': 'scripts', 'owner': 'axiarch', 'policy': 'replace'}
            for path in ('AGENTS.md', 'axiarch-scripts')]}
        (self.source / 'axiarch-manifest.json').write_text(json.dumps(manifest))
        return self.run_cmd(['bash', setup.SCRIPTS / 'axiarch-upgrade.sh',
                             '--source', self.source, '--target', self.target, *args], **kwargs)

    def install(self, action, expected, health=0, existing=False):
        self.install_source(health=0)
        self.health = self.source / 'axiarch-scripts/check-axiarch-health.sh'
        self.health.write_text('#!/bin/bash\n' + action + f'\nexit {health}\n')
        if existing:
            (self.target / 'AGENTS.md').write_bytes((self.source / 'AGENTS.md').read_bytes())
        self.result = self.run_cmd(['bash', self.source / 'init.sh', self.target],
                                   text='2\n2\n7\nn\nn\n', expected=expected)

    def assert_unconfirmed(self, application, code, health=0):
        meta = self.target / '.axiarch'
        result = json.loads((meta / 'install-result.json').read_text())
        version = json.loads((meta / 'version.json').read_text())
        self.assertEqual(result['application'], application)
        self.assertEqual(result['exit_code'], code)
        self.assertEqual(result['health'], {'status': 'passed' if health == 0 else 'failed', 'exit_code': health})
        self.assertIsNone(result['confirmed_version'])
        self.assertIsNone(version['version'])
        self.assertEqual(version['applicationStatus'], application)
        self.assertNotIn('setup complete!', self.result.stdout)
        self.assertNotIn('  AGENTS.md\n', (meta / 'files.sha256').read_text())
        original = self.source / 'axiarch-harness/en/TASK_STATE_PROTOCOL.md'
        self.assertIn(hashlib.sha256(original.read_bytes()).hexdigest() +
                      '  axiarch-harness/en/TASK_STATE_PROTOCOL.md\n',
                      (meta / 'files.sha256').read_text())
        return result

    def test_changed_install_payload_remains_unconfirmed_and_survives_upgrade(self):
        self.install('printf "local instructions\\n" > "$1/AGENTS.md"', 3, existing=True)
        result = self.assert_unconfirmed('partial', 3)
        self.assertIn('REVIEW changed-before-finalization AGENTS.md', result['pending'])
        self.health.write_text('#!/bin/bash\nexit 0\n')
        # The updater must still recognize this as a local modification.
        self.upgrade('--apply', '--yes', '--lang', 'en', expected=3)
        self.assertEqual((self.target / 'AGENTS.md').read_text(), 'local instructions\n')

    def test_missing_install_payload_is_a_recorded_failure(self):
        self.install('rm -f "$1/AGENTS.md"', 5)
        result = self.assert_unconfirmed('failed', 5)
        self.assertIn('APPLY-FAIL verification-unavailable AGENTS.md', result['failed'])
        self.assertFalse((self.target / 'AGENTS.md').exists())
        self.assertNotIn('Traceback', self.result.stderr)
        self.health.write_text('#!/bin/bash\nexit 0\n')
        self.upgrade('--apply', '--yes', '--lang', 'en')
        self.assertEqual((self.target / 'AGENTS.md').read_bytes(), (self.source / 'AGENTS.md').read_bytes())

    def test_linked_install_payload_is_not_followed_or_removed(self):
        victim = self.target / 'custom.txt'; victim.write_text('project-owned\n')
        self.install('rm -f "$1/AGENTS.md"\nln -s "$1/custom.txt" "$1/AGENTS.md"', 5)
        result = self.assert_unconfirmed('failed', 5)
        self.assertIn('APPLY-FAIL verification-unavailable AGENTS.md', result['failed'])
        self.assertTrue((self.target / 'AGENTS.md').is_symlink())
        self.assertEqual(victim.read_text(), 'project-owned\n')

    def test_diagnostic_failure_and_payload_change_remain_separate_results(self):
        self.install('printf "local instructions\\n" > "$1/AGENTS.md"', 4, health=9)
        result = self.assert_unconfirmed('partial', 4, health=9)
        self.assertIn('REVIEW changed-before-finalization AGENTS.md', result['pending'])
        self.assertEqual(result['failed'], [])
