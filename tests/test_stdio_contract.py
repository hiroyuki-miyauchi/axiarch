"""Public shell entrypoints must preserve UTF-8 across their child processes."""
import json
import subprocess
import unittest

import test_runtime as runtime
import test_setup as setup
import test_agent_compatibility as agents


class StdioContractTests(unittest.TestCase):
    setUp = runtime.RuntimeTests.setUp
    run_cmd = runtime.RuntimeTests.run_cmd
    tree_bytes = runtime.RuntimeTests.tree_bytes
    install_source = setup.SetupTests.install_source
    configured_hook = agents.AgentCompatibilityTests.configured_hook
    upgrade_fixture = runtime.RuntimeTests.upgrade_fixture
    upgrade = runtime.RuntimeTests.upgrade

    def environment(self, encoding='ascii:replace'):
        return dict(self.env, LC_ALL='C', PYTHONUTF8='0', PYTHONCOERCECLOCALE='0',
                    PYTHONIOENCODING=encoding)

    def unicode_target(self):
        target = self.root / '日本語 café 🐶'
        self.target.rename(target)
        self.target = target

    def fixture(self):
        self.install_source()
        self.target = self.source
        self.unicode_target()

    def test_native_start_resume_and_scope_keep_unicode_under_inherited_stdio(self):
        self.fixture()
        canonical = self.target / 'AXIARCH.md'
        original = canonical.read_text(encoding='utf-8')
        for encoding in ('ascii:replace', 'latin-1'):
            for language in ('Japanese', 'English'):
                canonical.write_text(original.replace(
                    'Project Native Language: [Japanese | English] (Default: Japanese)',
                    'Project Native Language: ' + language), encoding='utf-8')
                for agent in ('codex', 'claude'):
                    with self.subTest(encoding=encoding, language=language, agent=agent):
                        sid = agent + '-' + language + '-' + encoding.replace(':', '-')
                        payload = dict(session_id=sid, cwd=str(self.target), source='startup',
                                       hook_event_name='SessionStart')
                        env = self.environment(encoding)
                        result = self.configured_hook(agent, 'SessionStart', payload, extra=env)
                        context = json.loads(result.stdout)['hookSpecificOutput']['additionalContext']
                        self.assertNotIn('TASK STATE WARNING', context)
                        docs = self.target / '.axiarch/sessions' / sid
                        self.assertIn(str(docs), context)
                        self.assertIn('タスク' if language == 'Japanese' else 'Task',
                                      (docs / 'task.md').read_text(encoding='utf-8'))
                        (docs / 'task.md').write_text('保持 / Keep e\u0301 🐶\n', encoding='utf-8')
                        before = self.tree_bytes()
                        self.configured_hook(agent, 'SessionStart', dict(payload, source='resume'), extra=env)
                        result = self.configured_hook(agent, 'UserPromptSubmit', dict(
                            payload, hook_event_name='UserPromptSubmit', prompt='セキュリティ security'), extra=env)
                        context = json.loads(result.stdout)['hookSpecificOutput']['additionalContext']
                        self.assertIn(str(docs), context)
                        self.assertIn('[LOAD REVIEW]', context)
                        self.assertNotIn('UNASSESSED', context)
                        self.assertNotIn('WARNING', context)
                        self.assertEqual(self.tree_bytes(), before)

    def test_common_cli_returns_exact_paths_and_localized_goals(self):
        self.unicode_target()
        script = runtime.SCRIPTS / 'axiarch-task-state.sh'
        command = ['bash', script, '--project', self.target]
        env = self.environment()
        self.run_cmd(command + ['--mode', 'new', '--task', 'work', '--session', 'writer'], env=env)
        path = self.target / '.axiarch/tasks/work/state.json'
        state = json.loads(path.read_text(encoding='utf-8'))
        state['goal'] = '日本語 English café 🐶 e\u0301'
        candidate = self.target / 'candidate.json'
        candidate.write_text(json.dumps(state, ensure_ascii=False), encoding='utf-8')
        self.run_cmd(command + ['--mode', 'publish', '--session', 'writer', '--input', candidate,
                                '--expected-revision', '0'], env=env)
        before = self.tree_bytes()
        for encoding in ('ascii:replace', 'latin-1'):
            for mode in ('status', 'sessions'):
                result = self.run_cmd(command + ['--mode', mode], env=self.environment(encoding))
                self.assertEqual(json.loads(result.stdout)['goal'], state['goal'])
            result = self.run_cmd(command + ['--mode', 'path', '--session', 'writer'], env=self.environment(encoding))
            self.assertEqual(result.stdout.strip(), str(self.target / '.axiarch/sessions/writer'))
        self.assertEqual(self.tree_bytes(), before)

    def test_write_guards_preserve_names_and_reject_damaged_input(self):
        self.fixture()
        existing = self.target / '既存 café.txt'; existing.write_text('保持\n', encoding='utf-8')
        for agent in ('codex', 'claude'):
            for filename, expected in ((existing.name, 2), ('新規 🐶.txt', 0)):
                with self.subTest(agent=agent, filename=filename):
                    tool, value = ('Write', {'file_path': filename, 'content': '日本語'}) if agent == 'claude' else (
                        'apply_patch', {'command': '*** Begin Patch\n*** Add File: ' + filename + '\n+日本語\n*** End Patch'})
                    payload = dict(hook_event_name='PreToolUse', cwd=str(self.target), tool_name=tool, tool_input=value)
                    before = self.tree_bytes()
                    result = self.configured_hook(agent, 'PreToolUse', payload, expected, extra=self.environment())
                    self.assertNotIn('Traceback', result.stdout + result.stderr)
                    self.assertEqual(self.tree_bytes(), before)
            allow = self.target / ('.' + agent) / 'axiarch-overwrite-allow.txt'
            allow.write_text(existing.name + '\n', encoding='utf-8')
            tool, value = ('Write', {'file_path': existing.name, 'content': '日本語'}) if agent == 'claude' else (
                'apply_patch', {'command': '*** Begin Patch\n*** Add File: ' + existing.name + '\n+日本語\n*** End Patch'})
            before = self.tree_bytes()
            self.configured_hook(agent, 'PreToolUse', dict(hook_event_name='PreToolUse', cwd=str(self.target),
                                 tool_name=tool, tool_input=value), extra=self.environment('latin-1'))
            self.assertEqual(self.tree_bytes(), before)
            config_path = '.codex/hooks.json' if agent == 'codex' else '.claude/settings.json'
            config = json.loads((self.target / config_path).read_text(encoding='utf-8'))
            handler = config['hooks']['SessionStart'][0]['hooks'][0]['command']
            before = self.tree_bytes()
            result = subprocess.run(['bash', '-c', handler], input=b'{"session_id":"bad","prompt":"private-\xff"}',
                                    capture_output=True, cwd=self.target, timeout=30,
                                    env=dict(self.environment(), CLAUDE_PROJECT_DIR=str(self.target), TMPDIR=str(self.root)))
            self.assertEqual(result.returncode, 0)
            context = json.loads(result.stdout)['hookSpecificOutput']['additionalContext']
            self.assertIn('TASK STATE WARNING', context)
            self.assertNotIn('private-', context)
            self.assertEqual(self.tree_bytes(), before)

    def test_post_edit_diagnostic_keeps_both_languages(self):
        self.fixture()
        for agent, tool in (('codex', 'apply_patch'), ('claude', 'Write')):
            with self.subTest(agent=agent):
                before = self.tree_bytes()
                result = self.configured_hook(agent, 'PostToolUse', dict(
                    hook_event_name='PostToolUse', cwd=str(self.target), tool_name=tool, tool_input={}),
                    extra=dict(self.environment(), AXIARCH_DIFF_GUARD_MAX_LINES='invalid'))
                context = json.loads(result.stdout)['hookSpecificOutput']['additionalContext']
                self.assertIn('DIFF GUARD UNASSESSED', context)
                self.assertIn('AXIARCH_DIFF_GUARD_MAX_LINES', context)
                self.assertIn('差分量を確認できません', context)
                self.assertIn('差分量を確認できません', result.stderr)
                self.assertNotIn('Traceback', result.stdout + result.stderr)
                self.assertEqual(self.tree_bytes(), before)

    def test_installer_and_health_work_with_unicode_paths_in_c_locale(self):
        self.install_source()
        for lang, choice in (('ja', '1'), ('en', '2')):
            with self.subTest(lang=lang):
                self.target = self.root / ('導入 🐶-' + lang)
                self.run_cmd(['bash', self.source / 'init.sh', self.target], cwd=self.root,
                             text=choice + '\n2\n3\nn\nn\n', env=self.environment())
                report = json.loads((self.target / '.axiarch/version.json').read_text(encoding='utf-8'))
                self.assertEqual(report['healthStatus'], 'passed')
                self.assertEqual(report['confirmedScope']['languages'], lang)
                before = self.tree_bytes()
                self.run_cmd(['bash', self.target / 'axiarch-scripts/check-axiarch-health.sh', '--quiet'],
                             env=self.environment('latin-1'))
                self.assertEqual(self.tree_bytes(), before)

    def test_optional_commands_keep_unicode_titles_and_paths(self):
        self.fixture()
        script = self.target / 'axiarch-scripts/axiarch-prompts-install.sh'
        for lang in ('ja', 'en'):
            before = self.tree_bytes()
            self.run_cmd(['bash', script, '--target', self.target, '--lang', lang, '--dry-run'], env=self.environment())
            self.assertEqual(self.tree_bytes(), before)
            self.run_cmd(['bash', script, '--target', self.target, '--lang', lang], env=self.environment())
            for source in (self.target / ('axiarch-prompts/' + lang)).glob('*/*.md'):
                title = next(line[2:].strip() for line in source.read_text(encoding='utf-8').splitlines() if line.startswith('# '))
                generated = self.target / '.claude/commands' / ('axiarch-' + source.stem.replace('_', '-').lower() + '.md')
                description = next(line[len('description: '):] for line in generated.read_text(encoding='utf-8').splitlines()
                                   if line.startswith('description: '))
                self.assertEqual(json.loads(description), title)

    def test_upgrade_dry_run_apply_and_eof_preserve_unicode_paths(self):
        self.upgrade_fixture()
        self.unicode_target()
        source = self.root / '更新元 café'; self.source.rename(source); self.source = source
        before = self.tree_bytes()
        self.upgrade('--dry-run', env=self.environment())
        self.assertEqual(self.tree_bytes(), before)
        self.upgrade('--apply', text='', expected=None, env=self.environment())
        self.assertEqual(self.tree_bytes(), before)
        self.upgrade('--apply', '--yes', env=self.environment())
        self.assertEqual((self.target / 'core/rule.md').read_bytes(), (self.source / 'core/rule.md').read_bytes())
        self.assertEqual((self.target / 'local.md').read_bytes(), before['local.md'])
        self.assertEqual((self.target / 'custom.txt').read_bytes(), before['custom.txt'])
