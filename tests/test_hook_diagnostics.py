"""Exercise hook diagnostics without launching an agent or executing its commands."""
import copy
import json
import shutil
import sys
import unittest

import test_runtime as runtime
import test_setup as setup

ROOT = runtime.ROOT


class HookDiagnosticTests(unittest.TestCase):
    setUp = runtime.RuntimeTests.setUp
    run_cmd = runtime.RuntimeTests.run_cmd
    tree_bytes = runtime.RuntimeTests.tree_bytes
    install_source = setup.SetupTests.install_source

    def fixture(self):
        self.install_source()
        self.target = self.source
        self.config = self.target / '.codex/hooks.json'
        self.original = json.loads(self.config.read_text())

    def health(self, expected=None):
        return self.run_cmd(['bash', self.target / 'axiarch-scripts/check-axiarch-health.sh',
                             self.target, '--quiet'], expected=expected)

    def write_config(self, data):
        self.config.write_text(json.dumps(data))

    def test_missing_events_in_second_configuration_fail_without_changes(self):
        self.fixture()
        for event in ('UserPromptSubmit', 'PreToolUse', 'SessionStart'):
            with self.subTest(event=event):
                data = copy.deepcopy(self.original); del data['hooks'][event]; self.write_config(data)
                before = self.tree_bytes(); result = self.health()
                self.assertNotEqual(result.returncode, 0)
                self.assertIn(event, result.stdout + result.stderr)
                self.assertEqual(self.tree_bytes(), before)

    def test_wrong_pretool_matcher_is_not_write_protection(self):
        self.fixture()
        for name in ('.claude/settings.json', '.codex/hooks.json'):
            path = self.target / name; data = json.loads(path.read_text())
            data['hooks']['PreToolUse'][0]['matcher'] = 'Read'; path.write_text(json.dumps(data))
        self.assertNotEqual(self.health().returncode, 0)

    def test_posttool_command_must_belong_to_each_required_matcher(self):
        self.fixture(); data = copy.deepcopy(self.original)
        for entry in data['hooks']['PostToolUse'][1:]:
            entry['hooks'][0]['command'] = 'true'
        self.write_config(data)
        self.assertNotEqual(self.health().returncode, 0)

    def test_extra_hook_before_axiarch_hook_does_not_hide_the_declaration(self):
        self.fixture()
        for name in ('.claude/settings.json', '.codex/hooks.json'):
            path = self.target / name; data = json.loads(path.read_text())
            for event in ('UserPromptSubmit', 'SessionStart', 'PreToolUse'):
                data['hooks'][event].insert(0, {'matcher': 'Read' if event == 'PreToolUse' else '',
                                                'hooks': [{'type': 'command', 'command': 'true'}]})
            path.write_text(json.dumps(data))
        self.health(expected=0)

    def test_simple_alternative_matcher_can_cover_posttool_operations(self):
        self.fixture(); data = copy.deepcopy(self.original)
        entry = data['hooks']['PostToolUse'][0]; entry['matcher'] = 'Edit|MultiEdit|Write'
        data['hooks']['PostToolUse'] = [entry]; self.write_config(data)
        self.health(expected=0)

    def test_disabled_async_or_conditional_required_hook_is_not_confirmed(self):
        self.fixture()
        for alteration in ('disabled', 'async', 'conditional', 'type', 'args', 'quoted-variable'):
            with self.subTest(alteration=alteration):
                data = copy.deepcopy(self.original); hook = data['hooks']['PreToolUse'][0]['hooks'][0]
                if alteration == 'disabled': data['disableAllHooks'] = True
                elif alteration == 'async': hook['async'] = True
                elif alteration == 'conditional': hook['if'] = 'Write(only-this-file)'
                elif alteration == 'type': hook['type'] = 'prompt'
                elif alteration == 'quoted-variable': hook['command'] = hook['command'].replace('"', "'")
                else: hook['args'] = []  # Whole shell command is not an executable name.
                self.write_config(data)
                self.assertNotEqual(self.health().returncode, 0)

    def test_command_text_is_never_executed_or_accepted_as_a_script_name(self):
        self.fixture(); data = copy.deepcopy(self.original)
        marker = self.root / 'must-not-exist'
        data['hooks']['PreToolUse'][0]['hooks'][0]['command'] = f'touch {marker}; echo axiarch-protect-antifull.sh'
        self.write_config(data); before = self.tree_bytes()
        result = self.health()
        self.assertNotEqual(result.returncode, 0)
        self.assertFalse(marker.exists())
        self.assertEqual(self.tree_bytes(), before)

    def test_absent_optional_hook_layer_passes(self):
        self.fixture()
        (self.target / '.claude/settings.json').unlink(); self.config.unlink()
        self.health(expected=0)

    def test_malformed_required_event_shape_reports_failure(self):
        self.fixture()
        for value in ({}, [None], [{'hooks': {}}]):
            data = copy.deepcopy(self.original); data['hooks']['PreToolUse'] = value; self.write_config(data)
            self.assertNotEqual(self.health().returncode, 0)

    def test_hooks_are_checked_without_jq_and_without_writing_bytecode(self):
        self.fixture()
        binaries = self.root / 'bin'; binaries.mkdir()
        for tool in ('bash', 'python3', 'git', 'grep', 'awk', 'sed', 'find', 'sort', 'date',
                     'basename', 'dirname', 'head', 'tail', 'cat', 'wc', 'tr', 'cut'):
            path = sys.executable if tool == 'python3' else shutil.which(tool)
            if path: (binaries / tool).symlink_to(path)
        self.env['PATH'] = str(binaries); self.env.pop('PYTHONDONTWRITEBYTECODE', None)
        before = self.tree_bytes(); self.health(expected=0)
        self.assertEqual(self.tree_bytes(), before)
        data = copy.deepcopy(self.original); del data['hooks']['PreToolUse']; self.write_config(data)
        self.assertNotEqual(self.health().returncode, 0)

    def test_exec_form_and_unconditional_matchers_are_supported(self):
        self.fixture(); data = copy.deepcopy(self.original)
        for entries in data['hooks'].values():
            for entry in entries:
                entry['matcher'] = '*'
                handler = entry['hooks'][0]
                script = handler['command'].split('/axiarch-scripts/')[1].rstrip('"')
                handler.update(command='bash', args=[f'./axiarch-scripts/{script}'])
        self.write_config(data); self.health(expected=0)

    def test_session_start_must_cover_resume_and_required_script_must_exist(self):
        self.fixture(); data = copy.deepcopy(self.original)
        data['hooks']['SessionStart'][0]['matcher'] = 'startup'; self.write_config(data)
        self.assertNotEqual(self.health().returncode, 0)
        self.write_config(self.original)
        (self.target / 'axiarch-scripts/axiarch-protect-antifull.sh').unlink()
        self.assertNotEqual(self.health().returncode, 0)

    def test_initial_install_records_failed_hook_diagnosis(self):
        self.fixture(); data = copy.deepcopy(self.original); del data['hooks']['PreToolUse']
        self.write_config(data)
        adopter = self.root / 'diagnosis-adopter'
        self.run_cmd(['bash', self.source / 'init.sh', adopter], text='2\n2\n1\nn\nn\n', expected=4)
        result = json.loads((adopter / '.axiarch/install-result.json').read_text())
        self.assertNotEqual(result['health']['exit_code'], 0)
        self.assertIsNone(json.loads((adopter / '.axiarch/version.json').read_text())['version'])
        self.assertIn('PreToolUse', (adopter / '.axiarch/install-health.log').read_text())


if __name__ == '__main__':
    unittest.main()
