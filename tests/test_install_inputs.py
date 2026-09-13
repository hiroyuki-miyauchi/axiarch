"""Initial setup and diagnostics must reject the same ambiguous configuration."""
import json
import shutil
import unittest

import test_runtime as runtime
import test_setup as setup

ROOT, SCRIPTS = runtime.ROOT, runtime.SCRIPTS


class InstallInputTests(unittest.TestCase):
    setUp = runtime.RuntimeTests.setUp
    run_cmd = runtime.RuntimeTests.run_cmd
    tree_bytes = runtime.RuntimeTests.tree_bytes
    install_source = setup.SetupTests.install_source

    def install(self, agent=7, **kwargs):
        return self.run_cmd(['bash', self.source / 'init.sh', self.target],
                            text=f'2\n2\n{agent}\nn\nn\n', **kwargs)

    def test_ambiguous_manifest_stops_before_installation(self):
        self.install_source(health=0)
        path = self.source / 'axiarch-manifest.json'; original = path.read_text()
        cases = [('{"axiarchVersion":"duplicate",' + original.lstrip()[1:]),
                 ('{"non_json_number":NaN,' + original.lstrip()[1:]),
                 ('{"overflow":1e999,' + original.lstrip()[1:])]
        data = json.loads(original)
        for value in ('2.0\x00.0', '2.0\x1b[31m.0', ''):
            cases.append(json.dumps(dict(data, axiarchVersion=value)))
        cases.append(json.dumps(dict(data, files='invalid')))
        before = self.tree_bytes()
        for index, value in enumerate(cases):
            with self.subTest(manifest=value[:55]):
                self.target = self.root / f'adopter-{index}'; self.target.mkdir()
                path.write_text(value)
                result = self.install(expected=None)
                self.assertNotEqual(result.returncode, 0)
                self.assertNotIn('setup complete!', result.stdout)
                self.assertEqual(self.tree_bytes(), before)

    def test_selected_hook_duplicate_keys_are_rejected_before_copy(self):
        self.install_source(health=0)
        path = self.source / '.codex/hooks.json'
        path.write_text('{"hooks":{},' + path.read_text().lstrip()[1:])
        before = self.tree_bytes()
        result = self.install(agent=1, expected=None)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('duplicate JSON key', result.stdout + result.stderr)
        self.assertEqual(self.tree_bytes(), before)

    def test_health_checks_second_hook_configuration_with_strict_json(self):
        self.install_source()
        path = self.source / '.codex/hooks.json'
        path.write_text('{"hooks":{},' + path.read_text().lstrip()[1:])
        result = self.run_cmd(['bash', self.source / 'axiarch-scripts/check-axiarch-health.sh', self.source, '--quiet'], expected=None)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('duplicate JSON key', result.stdout + result.stderr)

    def test_source_reference_controls_are_rejected_before_display(self):
        self.install_source(health=0)
        env = dict(self.env, AXIARCH_REF='tags/v1.0\x1b[31mFORGED')
        before = self.tree_bytes()
        result = self.install(expected=None, env=env)
        self.assertNotEqual(result.returncode, 0)
        self.assertNotIn('\x1b[31mFORGED', result.stdout + result.stderr)
        self.assertEqual(self.tree_bytes(), before)

    def test_source_reference_backslashes_remain_literal(self):
        launcher = self.root / 'standalone-init.sh'; shutil.copy2(ROOT / 'init.sh', launcher)
        reference = r'tags/vtest\e[31m\nFORGED'
        env = dict(self.env, AXIARCH_REF=reference)
        # EOF at the first choice prevents any real download.
        result = self.run_cmd(['bash', launcher, self.target], text='', env=env, expected=None)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn(reference, result.stdout)
        self.assertNotIn('\x1b[31m\nFORGED', result.stdout)

    def test_local_source_display_does_not_claim_a_remote_version(self):
        self.install_source(health=0)
        env = dict(self.env, AXIARCH_REF='tags/v999.0.0')
        result = self.install(env=env)
        self.assertIn(f'Local source: {self.source}', result.stdout)
        self.assertNotIn('999.0.0', result.stdout)
        self.assertIn('source version not yet checked', result.stdout)


if __name__ == '__main__':
    unittest.main()
