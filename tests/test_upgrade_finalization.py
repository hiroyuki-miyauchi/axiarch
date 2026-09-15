"""Reconcile applied files after diagnostics without blessing local changes."""
import hashlib
import json
import unittest

import test_runtime as runtime


class UpgradeFinalizationTests(unittest.TestCase):
    setUp = runtime.RuntimeTests.setUp
    run_cmd = runtime.RuntimeTests.run_cmd
    upgrade_fixture = runtime.RuntimeTests.upgrade_fixture
    upgrade = runtime.RuntimeTests.upgrade

    def prepare(self, changed=True):
        self.upgrade_fixture()
        self.upgrade('--apply', '--yes')
        self.rule = self.target / 'core/rule.md'
        self.original = self.rule.read_bytes()
        self.original_hash = hashlib.sha256(self.original).hexdigest()
        manifest = self.source / 'axiarch-manifest.json'
        data = json.loads(manifest.read_text()); data['axiarchVersion'] = '3.0.0'
        manifest.write_text(json.dumps(data))
        if changed:
            (self.source / 'core/rule.md').write_text('next upstream\n')
        self.health = self.source / 'axiarch-scripts/check-axiarch-health.sh'

    def assert_result(self, application, code):
        meta = self.target / '.axiarch'
        result = json.loads((meta / 'upgrade-result.json').read_text())
        version = json.loads((meta / 'version.json').read_text())
        self.assertEqual(result['application'], application)
        self.assertEqual(result['health'], {'status': 'passed', 'exit_code': 0})
        self.assertEqual(result['exit_code'], code)
        self.assertEqual(result['confirmed_version'], '2.0.0')
        self.assertEqual(version['version'], '2.0.0')
        self.assertEqual(version['applicationStatus'], application)
        self.assertIn(self.original_hash + '  core/rule.md', (meta / 'files.sha256').read_text())
        return result

    def test_post_copy_change_is_not_registered_as_an_upstream_base(self):
        self.prepare()
        (self.source / 'core/companion.md').write_text('other upstream file\n')
        self.health.write_text('#!/bin/bash\nprintf "local customization\\n" > "$1/core/rule.md"\nexit 0\n')
        self.upgrade('--apply', '--yes', expected=3)
        result = self.assert_result('partial', 3)
        self.assertIn('UPDATE core/rule.md', result['actions'])
        self.assertIn('REVIEW changed-before-finalization core/rule.md', result['pending'])
        local = self.rule.read_bytes()
        hashes = (self.target / '.axiarch/files.sha256').read_text()
        self.assertNotIn(hashlib.sha256(local).hexdigest() + '  core/rule.md', hashes)
        self.assertIn('  core/companion.md', hashes)
        self.health.write_text('#!/bin/bash\nexit 0\n')
        (self.source / 'core/rule.md').write_text('later upstream\n')
        self.upgrade('--apply', '--yes', expected=3)
        self.assertEqual(self.rule.read_bytes(), local)
        # Restore a reviewed known base only in this isolated synthetic adopter.
        self.rule.write_bytes(self.original)
        self.upgrade('--apply', '--yes')
        self.assertEqual(self.rule.read_text(), 'later upstream\n')

    def test_unchanged_directory_is_rechecked_after_diagnostics(self):
        self.prepare(changed=False)
        self.health.write_text('#!/bin/bash\nprintf "changed during health\\n" > "$1/core/rule.md"\nexit 0\n')
        self.upgrade('--apply', '--yes', expected=3)
        result = self.assert_result('partial', 3)
        self.assertIn('UNCHANGED core', result['actions'])
        self.assertIn('REVIEW changed-before-finalization core/rule.md', result['pending'])
        self.assertEqual(self.rule.read_text(), 'changed during health\n')

    def test_missing_post_copy_file_records_failure_and_supports_retry(self):
        self.prepare()
        self.health.write_text('#!/bin/bash\nrm -f "$1/core/rule.md"\nexit 0\n')
        result = self.upgrade('--apply', '--yes', expected=5)
        self.assertNotIn('Traceback', result.stderr)
        self.assertIn('APPLY-FAIL verification-unavailable core/rule.md', self.assert_result('failed', 5)['failed'])
        self.assertFalse(self.rule.exists())
        self.health.write_text('#!/bin/bash\nexit 0\n')
        self.upgrade('--apply', '--yes')
        self.assertEqual(self.rule.read_text(), 'next upstream\n')

    def test_post_copy_symlink_is_not_followed_or_registered(self):
        self.prepare()
        victim = self.target / 'custom.txt'; before = victim.read_bytes()
        self.health.write_text('#!/bin/bash\nrm -f "$1/core/rule.md"\nln -s "$1/custom.txt" "$1/core/rule.md"\nexit 0\n')
        self.upgrade('--apply', '--yes', expected=5)
        self.assert_result('failed', 5)
        self.assertEqual(victim.read_bytes(), before)
        self.assertTrue(self.rule.is_symlink())
