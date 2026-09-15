"""UTF-8 transport and Unicode scalar boundaries, without agents or credentials."""
import json
import subprocess
import sys
import unittest

import test_runtime as runtime
import test_setup as setup


class UnicodeInputTests(unittest.TestCase):
    setUp = runtime.RuntimeTests.setUp
    tree_bytes = runtime.RuntimeTests.tree_bytes
    install_source = setup.SetupTests.install_source
    boot = runtime.RuntimeTests.boot
    state = runtime.RuntimeTests.state
    run_cmd = runtime.RuntimeTests.run_cmd

    def invoke(self, command, data, expected, extra=None):
        result = subprocess.run([str(p) for p in command], input=data, capture_output=True,
                                cwd=self.target, env=dict(self.env, **(extra or {})), timeout=30)
        self.assertEqual(result.returncode, expected, result.stderr.decode('utf-8', 'replace'))
        return result

    def normalize(self, data, expected=0, extra=None):
        return self.invoke([sys.executable, runtime.SCRIPTS / 'axiarch_hook.py', 'normalize'],
                           data, expected, extra)

    def test_invalid_transport_and_unpaired_values_are_rejected_without_echo(self):
        for tail in (b'"private-probe-\xff"', b'"private-probe-\\ud800"',
                     b'["private-probe-\\udfff"]', b'{"private-probe-\\ud800":1}'):
            with self.subTest(tail=tail):
                before = self.tree_bytes()
                result = self.normalize(b'{"session_id":"s1","extra":' + tail + b'}', 2)
                self.assertEqual(result.stdout, b'')
                self.assertNotIn(b'private-probe', result.stderr)
                self.assertNotIn(b'Traceback', result.stderr)
                self.assertEqual(self.tree_bytes(), before)

    def test_stdio_preferences_do_not_repair_or_redecode_utf8(self):
        value = {'prompt': '日本語 English 🐶 e\u0301', 'nested': [{'鍵': '値'}]}
        for encoding in ('utf-8:replace', 'latin-1', 'ascii'):
            with self.subTest(encoding=encoding):
                extra = {'PYTHONIOENCODING': encoding}
                result = self.normalize(json.dumps(value, ensure_ascii=False).encode('utf-8'), extra=extra)
                self.assertEqual(json.loads(result.stdout), value)
                self.normalize(b'{"prompt":"bad\xff"}', 2, extra)
                escaped = self.normalize(json.dumps(value).encode('ascii'), extra=extra)
                self.assertEqual(json.loads(escaped.stdout), value)

    def fixture(self):
        self.install_source()
        self.target = self.source

    def test_localized_files_do_not_depend_on_process_locale(self):
        self.fixture()
        extra = {'LC_ALL': 'C', 'PYTHONUTF8': '0', 'PYTHONCOERCECLOCALE': '0',
                 'PYTHONIOENCODING': 'utf-8'}
        canonical = self.target / 'AXIARCH.md'; original = canonical.read_text(encoding='utf-8')
        for language, lang in (('Japanese', 'ja'), ('English', 'en')):
            with self.subTest(language=language):
                canonical.write_text(original.replace(
                    'Project Native Language: [Japanese | English] (Default: Japanese)',
                    'Project Native Language: ' + language), encoding='utf-8')
                result = self.invoke([sys.executable, runtime.SCRIPTS / 'axiarch_state.py',
                                      '--project', self.target, '--mode', 'language'], b'', 0, extra)
                self.assertEqual(result.stdout.strip(), lang.encode('ascii'))
                self.invoke([sys.executable, runtime.SCRIPTS / 'axiarch_setup.py', 'prompts',
                             '--target', self.target, '--lang', lang], b'', 0, extra)
                for source in (self.target / ('axiarch-prompts/' + lang)).glob('*/*.md'):
                    title = next(line[2:].strip() for line in source.read_text(encoding='utf-8').splitlines()
                                 if line.startswith('# '))
                    name = 'axiarch-' + source.stem.replace('_', '-').lower() + '.md'
                    generated = (self.target / '.claude/commands' / name).read_text(encoding='utf-8')
                    description = next(line[len('description: '):] for line in generated.splitlines()
                                       if line.startswith('description: '))
                    self.assertEqual(json.loads(description), title)

    def handler(self, agent, event):
        path = '.codex/hooks.json' if agent == 'codex' else '.claude/settings.json'
        config = json.loads((self.target / path).read_text())
        return config['hooks'][event][0]['hooks'][0]['command']

    def native(self, agent, event, data, expected):
        return self.invoke(['bash', '-c', self.handler(agent, event)], data, expected,
                           {'CLAUDE_PROJECT_DIR': str(self.target), 'TMPDIR': str(self.root),
                            'AXIARCH_REMINDER_TTL_SECONDS': '0'})

    def test_invalid_startup_and_reminder_never_create_records_in_either_language(self):
        self.fixture()
        canonical = self.target / 'AXIARCH.md'; original = canonical.read_text()
        for language in ('Japanese', 'English'):
            canonical.write_text(original.replace(
                'Project Native Language: [Japanese | English] (Default: Japanese)',
                'Project Native Language: ' + language))
            for agent in ('codex', 'claude'):
                for event, warning in (('SessionStart', b'TASK STATE WARNING'),
                                       ('UserPromptSubmit', b'HOOK INPUT WARNING')):
                    for value in (b'bad\xff', b'bad\\ud800'):
                        with self.subTest(language=language, agent=agent, event=event, value=value):
                            before = self.tree_bytes()
                            data = b'{"session_id":"unicode-probe","extra":"' + value + b'"}'
                            result = self.native(agent, event, data, 0)
                            self.assertIn(warning, result.stdout)
                            self.assertNotIn(b'Traceback', result.stdout + result.stderr)
                            self.assertEqual(self.tree_bytes(), before)

    def test_invalid_unicode_does_not_authorize_creation_in_either_agent(self):
        self.fixture()
        for agent, tool, tool_input in (
                ('claude', 'Write', {'file_path': 'new.txt', 'content': 'safe'}),
                ('codex', 'apply_patch', {'command': '*** Begin Patch\n*** Add File: new.txt\n+safe\n*** End Patch'})):
            with self.subTest(agent=agent):
                before = self.tree_bytes()
                data = {'hook_event_name': 'PreToolUse', 'tool_name': tool, 'tool_input': tool_input,
                        'extra': '\ud800'}
                self.native(agent, 'PreToolUse', json.dumps(data).encode('ascii'), 2)
                del data['extra']
                self.native(agent, 'PreToolUse', json.dumps(data).encode('ascii'), 0)
                self.assertEqual(self.tree_bytes(), before)

    def test_common_state_reader_preserves_invalid_records_for_recovery(self):
        self.boot()
        path = self.target / '.axiarch/tasks/t1/state.json'
        data = json.loads(path.read_text())
        for extra in ({'private-probe-\ud800': 1}, ['private-probe-\udfff']):
            with self.subTest(extra=extra):
                data['extension'] = extra
                path.write_text(json.dumps(data))
                before = self.tree_bytes()
                result = self.state('--mode', 'path', '--session', 's1', expected=2)
                self.assertNotIn('private-probe', result.stdout + result.stderr)
                self.assertEqual(self.tree_bytes(), before)
        data['extension'] = {'日本語': '🐶 e\u0301'}
        path.write_text(json.dumps(data))
        self.state('--mode', 'path', '--session', 's1')

    def test_scope_cli_uses_the_same_utf8_input_boundary(self):
        command = [sys.executable, runtime.SCRIPTS / 'axiarch_scope.py', '--project', self.target]
        for data in (b'{"prompt":"private-probe-\xff"}', b'{"prompt":"private-probe-\\ud800"}'):
            result = self.invoke(command, data, 2)
            self.assertNotIn(b'private-probe', result.stdout + result.stderr)
        result = self.invoke(command, '{"prompt":"セキュリティ"}'.encode('utf-8'), 0,
                             {'PYTHONIOENCODING': 'utf-8:replace'})
        self.assertIn(b'LOAD REVIEW', result.stdout)
