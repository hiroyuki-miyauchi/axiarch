"""Native hook payloads and JA/EN adopter flows; no model, account or network."""
import json
import os
from pathlib import Path
import re
import shutil
import sys
import unittest

import test_runtime as runtime
import test_setup as setup

ROOT, SCRIPTS = runtime.ROOT, runtime.SCRIPTS
sys.path.insert(0, str(SCRIPTS))
from axiarch_hook import codex_command


class AgentCompatibilityTests(unittest.TestCase):
    setUp = runtime.RuntimeTests.setUp
    run_cmd = runtime.RuntimeTests.run_cmd
    tree_bytes = runtime.RuntimeTests.tree_bytes
    install_source = setup.SetupTests.install_source
    git = runtime.RuntimeTests.git

    def configured_hook(self, agent, event, payload, expected=0, extra=None, cwd=None):
        path = '.codex/hooks.json' if agent == 'codex' else '.claude/settings.json'
        config = json.loads((self.target / path).read_text())
        env = dict(self.env, TMPDIR=str(self.root), AXIARCH_REMINDER_TTL_SECONDS='0')
        if agent == 'claude':
            env['CLAUDE_PROJECT_DIR'] = str(self.target)
        env.update(extra or {})
        outputs = []
        for group in config['hooks'][event]:
            name = payload.get('tool_name', payload.get('source', ''))
            if group.get('matcher') and not re.search(group['matcher'], name):
                continue
            for hook in group['hooks']:
                outputs.append(self.run_cmd(['bash', '-c', hook['command']], text=json.dumps(payload),
                                            env=env, cwd=cwd, expected=expected))
        self.assertEqual(len(outputs), 1, 'one handler per native event, without alias duplication')
        return outputs[0]

    def guard_fixture(self):
        shutil.copytree(SCRIPTS, self.target / 'axiarch-scripts')
        (self.target / 'AXIARCH.md').write_text('Project Native Language: English\n')
        (self.target / 'nested').mkdir()
        for name in ('.codex/hooks.json', '.claude/settings.json'):
            dest = self.target / name; dest.parent.mkdir(exist_ok=True)
            shutil.copy2(ROOT / name, dest)

    def patch(self, body, expected=0, cwd=None):
        return self.configured_hook('codex', 'PreToolUse', {
            'hook_event_name': 'PreToolUse', 'cwd': str(cwd or self.target),
            'tool_name': 'apply_patch', 'tool_input': {'command': '*** Begin Patch\n' + body + '\n*** End Patch'}
        }, expected=expected, cwd=cwd)

    def test_three_agents_two_languages_and_directory_modes_use_real_health(self):
        self.install_source()  # Intentionally no health stub.
        for agent, choice in [('codex', 1), ('claude', 2), ('antigravity', 3)]:
            for lang, lang_choice in [('ja', 1), ('en', 2)]:
                for both, directory_choice in [(True, 1), (False, 2)]:
                    with self.subTest(agent=agent, language=lang, both=both):
                        self.target = self.root / f'{agent}-{lang}-{both}'
                        self.run_cmd(['bash', self.source / 'init.sh', self.target], cwd=self.root,
                                     text=f'{lang_choice}\n{directory_choice}\n{choice}\nn\nn\n')
                        metadata = json.loads((self.target / '.axiarch/version.json').read_text())
                        self.assertEqual(metadata['healthStatus'], 'passed')
                        self.assertTrue((self.target / f'axiarch-rules/{lang}/LOADING_PROTOCOL.md').is_file())
                        other = 'en' if lang == 'ja' else 'ja'
                        self.assertEqual((self.target / f'axiarch-rules/{other}').exists(), both)
                        cwd = self.target / '作業 folder'; cwd.mkdir()
                        if agent == 'antigravity':
                            pointer = (self.target / '.agents/rules/prompt_pointer.md').read_text()
                            self.assertIn('trigger: always_on', pointer)
                            self.assertIn('AXIARCH.md', pointer)
                            self.assertFalse((self.target / '.codex/hooks.json').exists())
                            self.assertFalse((self.target / '.claude/settings.json').exists())
                            command = ['bash', self.target / 'axiarch-scripts/axiarch-task-state.sh',
                                       '--project', self.target, '--mode', 'session-start', '--session', 'main-agent']
                            self.run_cmd(command, cwd=cwd)
                        else:
                            payload = dict(session_id='main-agent', source='startup', cwd=str(cwd),
                                           hook_event_name='SessionStart')
                            result = self.configured_hook(agent, 'SessionStart', payload, cwd=cwd)
                            context = json.loads(result.stdout)['hookSpecificOutput']['additionalContext']
                            self.assertIn('[AXIARCH TASK STATE]', context)
                            self.assertNotIn('[TASK STATE WARNING]', context)
                        docs = self.target / '.axiarch/sessions/main-agent'
                        self.assertIn('タスク' if lang == 'ja' else 'Task', (docs / 'task.md').read_text())
                        (docs / 'task.md').write_text('保存すべき作業 / Keep this work\n')
                        saved = {p.name: p.read_bytes() for p in docs.iterdir()}
                        if agent == 'antigravity':
                            self.run_cmd(command, cwd=cwd)
                        else:
                            payload['source'] = 'resume'
                            self.configured_hook(agent, 'SessionStart', payload, cwd=cwd)
                            reminder = self.configured_hook(agent, 'UserPromptSubmit',
                                dict(session_id='main-agent', cwd=str(cwd), prompt='確認 review',
                                     hook_event_name='UserPromptSubmit'), cwd=cwd)
                            context = json.loads(reminder.stdout)['hookSpecificOutput']['additionalContext']
                            self.assertIn(str(docs), context)
                        self.assertEqual({p.name: p.read_bytes() for p in docs.iterdir()}, saved)
                        self.run_cmd(['bash', self.target / 'axiarch-scripts/axiarch-task-state.sh',
                                      '--project', self.target, '--mode', 'check', '--session', 'main-agent',
                                      '--phase', 'completion'], expected=2)

    def test_codex_config_matches_fixed_launcher_and_one_patch_handler(self):
        config = json.loads((ROOT / '.codex/hooks.json').read_text())
        for event, script in [('SessionStart', 'axiarch-init-task-md.sh'),
                              ('UserPromptSubmit', 'axiarch-boot-reminder.sh'),
                              ('PreToolUse', 'axiarch-protect-antifull.sh'),
                              ('PostToolUse', 'axiarch-diff-guard.sh')]:
            self.assertEqual(config['hooks'][event][0]['hooks'][0]['command'], codex_command(script))
            self.assertEqual(len(config['hooks'][event]), 1)

    def test_native_sessions_do_not_borrow_inherited_codex_parent_records(self):
        self.guard_fixture()
        inherited = {'CODEX_THREAD_ID': 'parent'}
        self.configured_hook('codex', 'SessionStart', dict(session_id='parent'), extra=inherited)
        parent = self.target / '.axiarch/sessions/parent/task.md'
        parent.write_text('preserve the previous parent binding')
        for agent in ('codex', 'claude'):
            with self.subTest(agent=agent):
                payload = dict(session_id=agent + '-native', cwd=str(self.target / 'nested'))
                result = self.configured_hook(agent, 'SessionStart', payload, extra=inherited)
                docs = self.target / '.axiarch/sessions' / payload['session_id']
                self.assertTrue(docs.is_dir(), result.stdout)
                (docs / 'task.md').write_text('independent ' + agent)
                before = self.tree_bytes()
                self.configured_hook(agent, 'SessionStart', dict(payload, source='resume'), extra=inherited)
                result = self.configured_hook(agent, 'UserPromptSubmit', dict(payload, prompt='continue'),
                                              extra=inherited)
                context = json.loads(result.stdout)['hookSpecificOutput']['additionalContext']
                self.assertIn('docs=' + str(docs), context)
                self.assertEqual(self.tree_bytes(), before)
        self.assertEqual(parent.read_text(), 'preserve the previous parent binding')

    def test_three_agent_language_upgrades_preserve_local_state_and_report_pending(self):
        self.install_source()
        for agent, choice in [('codex', 1), ('claude', 2), ('antigravity', 3)]:
            for lang, lang_choice in [('ja', 1), ('en', 2)]:
                with self.subTest(agent=agent, language=lang):
                    self.target = self.root / f'upgrade-{agent}-{lang}'
                    self.target.mkdir()
                    attributes = self.target / '.gitattributes'
                    attributes.write_bytes(b'project-data/*.csv text eol=crlf\n')
                    self.run_cmd(['bash', self.source / 'init.sh', self.target], cwd=self.root,
                                 text=f'{lang_choice}\n2\n{choice}\nn\nn\n')
                    self.assertEqual(attributes.read_bytes(), b'project-data/*.csv text eol=crlf\n')
                    self.assertTrue((self.target / 'axiarch-scripts/WINDOWS.md').is_file())
                    spec = self.target / f'axiarch-rules/{lang}/blueprint/core/000_project_overview.md'
                    spec.write_text('# Adopted project / 利用先の仕様\n')
                    custom = self.target / 'project-only.txt'; custom.write_text('keep private local state\n')
                    command = ['bash', self.source / 'axiarch-scripts/axiarch-upgrade.sh', '--source', self.source,
                               '--target', self.target, '--lang', lang, '--agent', agent]
                    before = self.tree_bytes()
                    self.run_cmd([*command, '--dry-run'])
                    self.assertEqual(self.tree_bytes(), before)
                    self.run_cmd([*command, '--apply', '--yes'], expected=3)
                    self.assertEqual(spec.read_text(), '# Adopted project / 利用先の仕様\n')
                    self.assertEqual(custom.read_text(), 'keep private local state\n')
                    self.assertEqual(attributes.read_bytes(), b'project-data/*.csv text eol=crlf\n')
                    self.assertFalse((self.target / ('axiarch-rules/en' if lang == 'ja' else 'axiarch-rules/ja')).exists())
                    result = json.loads((self.target / '.axiarch/upgrade-result.json').read_text())
                    self.assertEqual(result['health']['status'], 'passed')
                    self.assertEqual(result['application'], 'partial')

    def test_codex_patch_preserves_existing_files_and_allows_diff_and_creation(self):
        self.guard_fixture()
        path = self.target / 'nested/日本語 file.txt'; path.write_text('keep\n')
        cwd = path.parent
        self.patch('*** Add File: 日本語 file.txt\n+replacement', expected=2, cwd=cwd)
        self.patch('*** Delete File: 日本語 file.txt\n*** Add File: 日本語 file.txt\n+replacement', expected=2, cwd=cwd)
        self.patch('*** Update File: source.txt\n*** Move to: 日本語 file.txt\n@@\n-a\n+b', expected=2, cwd=cwd)
        self.patch('*** Update File: 日本語 file.txt\n@@\n-keep\n+updated', cwd=cwd)
        self.patch('*** Add File: new file.txt\n+new', cwd=cwd)
        self.assertEqual(path.read_text(), 'keep\n')
        self.assertFalse((cwd / 'new file.txt').exists(), 'hook must never apply the patch')

    def test_patch_parser_does_not_confuse_hunk_content_or_trim_filenames(self):
        self.guard_fixture()
        (self.target / 'trailing ').write_text('keep')
        self.patch('*** Add File: trailing \n+new', expected=2)
        (self.target / 'existing').write_text('keep')
        self.patch('*** Add File: existing \n+replacement', expected=2)
        self.patch('*** Add File:  existing\n+replacement', expected=2)
        self.patch('*** Add File: new.txt\n+*** Add File: trailing \n+literal content')
        for body in ('malformed', '*** Move to: new.txt', '*** Add File: \n+bad',
                     '*** Add File: new.txt\nraw content'):
            self.patch(body, expected=2)

    def test_patch_allowlist_does_not_borrow_claude_permission_or_follow_links(self):
        self.guard_fixture()
        (self.target / 'existing.txt').write_text('keep')
        (self.target / '.claude/axiarch-overwrite-allow.txt').write_text('existing.txt\n')
        self.patch('*** Add File: existing.txt\n+new', expected=2)
        allow = self.target / '.codex/axiarch-overwrite-allow.txt'
        allow.write_text('existing.txt\n'); self.patch('*** Add File: existing.txt\n+new')
        allow.unlink(); allow.symlink_to(self.target / '.claude/axiarch-overwrite-allow.txt')
        self.patch('*** Add File: existing.txt\n+new', expected=2)

    def test_patch_line_boundaries_match_native_lf_and_crlf_only(self):
        self.guard_fixture()
        for separator in ('\v', '\f', '\r', '\x1c', '\x1d', '\x1e', '\x85', '\u2028', '\u2029'):
            with self.subTest(separator=repr(separator)):
                name = 'existing' + separator + '+suffix'
                path = self.target / name; path.write_text('keep\n')
                self.patch('*** Add File: ' + name + '\n+replacement', expected=2)
                self.assertEqual(path.read_text(), 'keep\n')
        self.patch('*** Add File: new.txt\r\n+new\r')

    def test_claude_relative_paths_follow_event_cwd(self):
        self.guard_fixture()
        cwd = self.target / 'nested'; (cwd / 'existing.txt').write_text('keep')
        self.configured_hook('claude', 'PreToolUse', dict(tool_name='Write', cwd=str(cwd),
            tool_input={'file_path': 'existing.txt'}), expected=2, cwd=cwd)
        self.configured_hook('claude', 'PreToolUse', dict(tool_name='Write', cwd=str(cwd),
            tool_input={'file_path': 'new.txt'}), cwd=cwd)
        (self.target / '.codex/axiarch-overwrite-allow.txt').write_text('nested/existing.txt\n')
        self.configured_hook('claude', 'PreToolUse', dict(tool_name='Write', cwd=str(cwd),
            tool_input={'file_path': 'existing.txt'}), expected=2, cwd=cwd)

    def test_claude_moved_worktree_uses_active_records_and_diff(self):
        self.guard_fixture()
        self.git('init', '-q')
        self.git('add', '.')
        self.git('-c', 'user.name=Fixture', '-c', 'user.email=fixture@example.invalid',
                 '-c', 'commit.gpgsign=false', 'commit', '-qm', 'fixture')
        worktree = self.root / 'worktree'
        self.git('worktree', 'add', '--detach', str(worktree), 'HEAD')
        (worktree / 'edited.txt').write_text('active worktree diff\n')
        payload = dict(session_id='active-tree', cwd=str(worktree), source='startup')
        self.configured_hook('claude', 'SessionStart', payload)
        self.assertTrue((worktree / '.axiarch/sessions/active-tree/task.md').exists())
        self.assertFalse((self.target / '.axiarch/sessions').exists())
        result = self.configured_hook('claude', 'UserPromptSubmit', dict(payload, prompt='review'))
        self.assertIn(str(worktree / '.axiarch/sessions/active-tree'), result.stdout)
        result = self.configured_hook('claude', 'PostToolUse', dict(payload, tool_name='Edit'), expected=2,
                                      extra={'AXIARCH_DIFF_GUARD_MODE': 'block', 'AXIARCH_DIFF_GUARD_MAX_FILES': '0'})
        self.assertIn('Changed lines=', result.stdout)
        self.assertNotIn('UNASSESSED', result.stdout)

    def test_unresolved_cwd_does_not_bootstrap_starting_checkout(self):
        self.guard_fixture()
        outside = self.root / 'without-axiarch'; outside.mkdir()
        before = self.tree_bytes()
        result = self.configured_hook('claude', 'SessionStart', dict(session_id='unresolved', cwd=str(outside)))
        self.assertIn('[TASK STATE WARNING]', result.stdout)
        self.assertEqual(self.tree_bytes(), before)
        result = self.configured_hook('claude', 'PostToolUse', dict(tool_name='Edit', cwd=str(outside)),
                                     extra={'AXIARCH_DIFF_GUARD_MODE': 'warn'})
        self.assertIn('UNASSESSED', result.stdout)

    def test_codex_parent_discovery_ignores_foreign_claude_environment(self):
        self.guard_fixture()
        foreign = self.root / 'foreign'; foreign.mkdir()
        before = list(foreign.iterdir())
        self.configured_hook('codex', 'SessionStart', dict(session_id='own', cwd=str(self.target / 'nested')),
                             cwd=self.target / 'nested', extra={'CLAUDE_PROJECT_DIR': str(foreign)})
        self.assertTrue((self.target / '.axiarch/sessions/own/task.md').exists())
        self.assertEqual(list(foreign.iterdir()), before)

    def test_codex_parent_discovery_preserves_newline_directory_name(self):
        self.guard_fixture()
        renamed = self.root / '日本語 folder\n'
        self.target.rename(renamed); self.target = renamed
        self.configured_hook('codex', 'SessionStart', dict(session_id='newline', cwd=str(renamed / 'nested')),
                             cwd=renamed / 'nested')
        self.assertTrue((renamed / '.axiarch/sessions/newline/task.md').exists())


if __name__ == '__main__':
    unittest.main()
