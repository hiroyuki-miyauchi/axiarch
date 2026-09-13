"""Input decoding, language authority and failed-resume boundary regressions."""
import json
import shutil
import sys
import unittest

import test_runtime as runtime
import test_setup as setup

SCRIPTS = runtime.SCRIPTS


class InputTests(unittest.TestCase):
    setUp = runtime.RuntimeTests.setUp
    run_cmd = runtime.RuntimeTests.run_cmd
    tree_bytes = runtime.RuntimeTests.tree_bytes
    state = runtime.RuntimeTests.state
    boot = runtime.RuntimeTests.boot
    state_file = runtime.RuntimeTests.state_file
    session_docs = runtime.RuntimeTests.session_docs
    prompt_fixture = setup.SetupTests.prompt_fixture
    prompts = setup.SetupTests.prompts

    def hook(self, payload, expected, no_jq=True, project=None):
        env = dict(self.env, CLAUDE_PROJECT_DIR=str(project or self.target))
        if no_jq:
            binaries = self.root / 'without-jq'; binaries.mkdir(exist_ok=True)
            for name in ('bash', 'cat', 'dirname', 'grep', 'head', 'sed', 'tr', 'python3'):
                path = binaries / name
                if not path.exists(): path.symlink_to(sys.executable if name == 'python3' else shutil.which(name))
            env['PATH'] = str(binaries)
        return self.run_cmd(['bash', SCRIPTS / 'axiarch-protect-antifull.sh'], text=payload, env=env, expected=expected)

    def test_hook_decodes_escaped_existing_paths_without_jq(self):
        for name in ('quoted"file.txt', '日本語.txt', 'back\\slash.txt', 'line\nbreak.txt', 'trailing\n'):
            with self.subTest(name=name):
                path = self.target / name; path.write_text('keep me')
                self.hook(json.dumps(dict(tool_name='Write', tool_input=dict(file_path=str(path)))), 2)
                self.assertEqual(path.read_text(), 'keep me')
        self.hook(json.dumps(dict(tool_name='Write', tool_input=dict(file_path='new"file.txt'))), 0)

    def test_hook_malformed_and_ambiguous_input_is_not_permission(self):
        for payload in ('{', 'null', '{}', '{"tool_name":"Write"}',
                        '{"tool_name":"Write","tool_input":{"file_path":null}}',
                        '{"tool_name":"Write","tool_input":{"file_path":[]}}',
                        '{"tool_name":"Write","tool_input":{"file_path":"new"},"extra":"raw\x00nul"}',
                        '{"tool_name":"Write","tool_input":{"file_path":"new"},"extra":NaN}',
                        '{"tool_name":"Write","tool_input":{"file_path":"new"},"extra":Infinity}',
                        '{"tool_name":"Write","tool_input":{"file_path":"new"},"extra":-Infinity}',
                        '{"tool_name":"Edit","tool_name":"Write","tool_input":{"file_path":"new"}}'):
            with self.subTest(payload=payload): self.hook(payload, 2)
        self.hook('{"tool_name":"Edit","tool_input":{}}', 0)

    def test_hook_relative_allow_pattern_matches_project_path(self):
        (self.target / 'generated').mkdir(); (self.target / 'generated/result.txt').write_text('before')
        config = self.target / '.claude'; config.mkdir()
        (config / 'axiarch-overwrite-allow.txt').write_text('generated/*.txt\n')
        self.hook(json.dumps(dict(tool_name='Write', tool_input=dict(file_path='generated/result.txt'))), 0)
        alias = self.root / 'project-alias'; alias.symlink_to(self.target, target_is_directory=True)
        self.hook(json.dumps(dict(tool_name='Write', tool_input=dict(file_path='generated/result.txt'))), 0, project=alias)
        (self.target / 'outside.txt').write_text('protected')
        self.hook(json.dumps(dict(tool_name='Write', tool_input=dict(file_path='outside.txt'))), 2)
        self.hook(json.dumps(dict(tool_name='Write', tool_input=dict(file_path='generated/../outside.txt'))), 2)

    def test_hook_uses_filesystem_semantics_for_symlink_and_parent_paths(self):
        outside = self.root / 'outside'; (outside / 'child').mkdir(parents=True)
        (outside / 'protected.txt').write_text('keep')
        (self.target / 'link').symlink_to(outside / 'child', target_is_directory=True)
        self.hook(json.dumps(dict(tool_name='Write', tool_input=dict(file_path='link/../protected.txt'))), 2)
        (self.target / 'broken').symlink_to(outside / 'missing')
        self.hook(json.dumps(dict(tool_name='Write', tool_input=dict(file_path='broken'))), 2)
        (self.target / 'generated').mkdir()
        (self.target / 'generated/alias.txt').symlink_to(outside / 'protected.txt')
        (self.target / '.claude').mkdir()
        (self.target / '.claude/axiarch-overwrite-allow.txt').write_text('generated/*.txt\n')
        self.hook(json.dumps(dict(tool_name='Write', tool_input=dict(file_path='generated/alias.txt'))), 2)

    def test_hook_block_response_is_json_for_control_characters(self):
        path = self.target / 'control\x01\x0b\x1f.txt'; path.write_text('keep')
        result = self.hook(json.dumps(dict(tool_name='Write', tool_input=dict(file_path=str(path)))), 2)
        message = json.loads(result.stdout)
        self.assertEqual(message['decision'], 'block')
        self.assertIn(str(path), message['reason'])

    def test_language_ignores_fenced_and_commented_examples(self):
        self.prompt_fixture()
        for tree in ('axiarch-rules', 'axiarch-prompts'):
            shutil.copytree(self.target / tree / 'en', self.target / tree / 'ja')
        (self.target / 'AXIARCH.md').write_text(
            '# Configuration\n```text\nProject Native Language: English\n```\n'
            '<!-- Project Native Language: English -->\nProject Native Language: Japanese\n')
        self.boot(); self.prompts()
        self.assertIn('axiarch-prompts/ja/', (self.commands / 'axiarch-demo.md').read_text())
        self.assertIn('タスク', (self.session_docs() / 'task.md').read_text())

    def test_language_ambiguity_stops_new_state_but_not_status(self):
        (self.target / 'AXIARCH.md').write_text('Project Native Language: English\nProject Native Language: Japanese\n')
        before = self.tree_bytes()
        self.state('--mode', 'new', '--task', 't1', '--session', 's1', expected=2)
        self.assertEqual(self.tree_bytes(), before)
        self.state('--mode', 'status')

    def test_staged_language_configuration_preserves_examples_and_line_endings(self):
        path = self.target / 'AXIARCH.md'
        content = ('```text\r\nProject Native Language: English\r\n```\r\n'
                   '<!--\r\nProject Native Language: English\r\n-->\r\n'
                   'Project Native Language: Japanese\r\n')
        path.write_bytes(content.encode())
        self.run_cmd([sys.executable, SCRIPTS / 'axiarch_setup.py', 'configure-language',
                      '--target', self.target, '--lang', 'en'])
        self.assertEqual(path.read_bytes(), content.replace('Language: Japanese', 'Language: English').encode())
        path.write_text('Project Native Language: Japanese\nProject Native Language: English\n')
        before = path.read_bytes()
        self.run_cmd([sys.executable, SCRIPTS / 'axiarch_setup.py', 'configure-language',
                      '--target', self.target, '--lang', 'en'], expected=3)
        self.assertEqual(path.read_bytes(), before)

    def test_existing_incomplete_session_does_not_create_orphan_task(self):
        session = self.session_docs(); session.mkdir(parents=True)
        (session / 'task.md').write_text('interrupted work to preserve')
        self.state('--mode', 'new', '--task', 't1', '--session', 's1', expected=2)
        self.assertFalse(self.state_file().exists())
        self.assertEqual((session / 'task.md').read_text(), 'interrupted work to preserve')

    def test_bound_session_with_missing_state_is_not_a_new_task(self):
        self.boot(); self.state_file().unlink(); before = self.tree_bytes()
        self.state('--mode', 'session-start', '--session', 's1', expected=2)
        self.assertEqual(self.tree_bytes(), before)


if __name__ == '__main__':
    unittest.main()
