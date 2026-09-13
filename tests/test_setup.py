"""Isolated installation and optional command regressions; no agent service used."""
import json
import shutil
import subprocess
import sys
import unittest

import test_runtime as runtime

ROOT, SCRIPTS = runtime.ROOT, runtime.SCRIPTS


class SetupTests(unittest.TestCase):
    setUp = runtime.RuntimeTests.setUp
    run_cmd = runtime.RuntimeTests.run_cmd
    tree_bytes = runtime.RuntimeTests.tree_bytes
    upgrade_fixture = runtime.RuntimeTests.upgrade_fixture
    upgrade = runtime.RuntimeTests.upgrade

    def prompts(self, *args, **kwargs):
        return self.run_cmd(['bash', SCRIPTS / 'axiarch-prompts-install.sh',
                             '--target', self.target, *args], **kwargs)

    def prompt_fixture(self):
        self.prompt = self.target / 'axiarch-prompts/en/develop/demo.md'
        self.prompt.parent.mkdir(parents=True)
        self.prompt.write_text('# Task: "quoted" title\n\nRun applicable checks.\n')
        (self.target / 'AXIARCH.md').write_text('Project Native Language: English\n')
        protocol = self.target / 'axiarch-rules/en/LOADING_PROTOCOL.md'
        protocol.parent.mkdir(parents=True); protocol.write_text('# Applicable loading procedure\n')
        self.commands = self.target / '.claude/commands'
        self.commands.mkdir(parents=True)

    def test_initial_install_preserves_existing_selected_configuration(self):
        (self.target / 'AGENTS.md').write_text('Project-owned instructions\n')
        before = self.tree_bytes()
        result = self.run_cmd(['bash', ROOT / 'init.sh', self.target],
                              text='1\n1\n1\nn\nn\n', expected=None)
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(self.tree_bytes(), before)
        self.assertNotIn('setup complete!', result.stdout)

    def test_explicit_dry_run_cannot_be_overridden(self):
        self.upgrade_fixture()
        before = self.tree_bytes()
        for options in [('--dry-run', '--apply', '--yes'),
                        ('--apply', '--yes', '--dry-run'),
                        ('--dry-run', '--interactive')]:
            with self.subTest(options=options):
                result = self.upgrade(*options, text='\n' * 3 + 'y\n', expected=None)
                self.assertIn(result.returncode, (0, 2), result.stdout + result.stderr)
                self.assertEqual(self.tree_bytes(), before)

    def test_malformed_manifest_is_not_replaced_with_defaults(self):
        self.upgrade_fixture()
        (self.source / 'axiarch-manifest.json').write_text('{invalid json')
        before = self.tree_bytes()
        result = self.upgrade('--apply', '--yes', expected=None)
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(self.tree_bytes(), before)

    def test_prompt_generation_preserves_colliding_adopter_command(self):
        self.prompt_fixture()
        custom = self.commands / 'axiarch-demo.md'
        custom.write_text('My own command\n')
        before = self.tree_bytes()
        result = self.prompts('--source', self.target, expected=None)
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(self.tree_bytes(), before)

    def test_prompt_generation_requires_installed_canonical_prompt(self):
        before = self.tree_bytes()
        result = self.prompts('--source', ROOT, '--lang', 'en', expected=None)
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(self.tree_bytes(), before)

    def test_prompt_duplicate_command_names_fail_before_replacement(self):
        self.prompt_fixture()
        other = self.target / 'axiarch-prompts/en/audit/demo.md'
        other.parent.mkdir(); other.write_text('# Another prompt\n')
        before = self.tree_bytes()
        result = self.prompts('--source', self.target, expected=None)
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(self.tree_bytes(), before)

    def test_prompt_case_and_underscore_name_collisions_preserve_files(self):
        self.prompt_fixture()
        custom = self.commands / 'axiarch-DEMO.md'; custom.write_text('custom case variant\n')
        before = self.tree_bytes(); self.prompts(expected=3)
        self.assertEqual(self.tree_bytes(), before)
        custom.unlink()
        self.prompt.rename(self.prompt.with_name('Foo_Bar.md'))
        other = self.target / 'axiarch-prompts/en/audit/foo-bar.md'
        other.parent.mkdir(); other.write_text('# Other name\n')
        before = self.tree_bytes(); self.prompts(expected=3)
        self.assertEqual(self.tree_bytes(), before)

    def test_prompt_clean_requires_owned_unmodified_content(self):
        self.prompt_fixture()
        custom = self.commands / 'axiarch-custom.md'
        custom.write_text('Notes about AXIARCH_GENERATED_COMMAND are not ownership.\n')
        self.prompts('--clean')
        self.assertTrue(custom.exists())

    def test_prompt_symlinked_directory_never_mutates_outside_target(self):
        self.prompt_fixture()
        self.commands.rmdir()
        outside = self.root / 'outside'; outside.mkdir()
        self.commands.symlink_to(outside, target_is_directory=True)
        result = self.prompts('--source', self.target, expected=None)
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(list(outside.iterdir()), [])

    def install_source(self, health=None):
        self.source = self.root / 'installation-source'; self.source.mkdir()
        for rel in ('init.sh', 'AXIARCH.md', 'AGENTS.md', 'CLAUDE.md', 'axiarch-manifest.json',
                    'axiarch-rules', 'axiarch-harness', 'axiarch-scripts', 'axiarch-prompts',
                    '.codex/hooks.json', '.claude/settings.json', '.claude/memory/MEMORY.md',
                    '.agents/rules/prompt_pointer.md', '.cursor/rules/axiarch.mdc',
                    '.github/copilot-instructions.md', '.windsurfrules'):
            dest = self.source / rel; dest.parent.mkdir(parents=True, exist_ok=True)
            if (ROOT / rel).is_dir():
                shutil.copytree(ROOT / rel, dest, ignore=shutil.ignore_patterns('__pycache__'))
            else:
                shutil.copy2(ROOT / rel, dest)
        if health is not None:
            (self.source / 'axiarch-scripts/check-axiarch-health.sh').write_text(f'#!/bin/bash\nexit {health}\n')

    def test_all_agent_choices_and_single_language_are_installed(self):
        self.install_source(health=0)
        pointers = {1: '.codex/hooks.json', 2: '.claude/settings.json', 3: '.agents/rules/prompt_pointer.md',
                    4: '.cursor/rules/axiarch.mdc', 5: '.github/copilot-instructions.md', 6: '.windsurfrules', 7: 'AGENTS.md'}
        for choice, pointer in pointers.items():
            with self.subTest(agent=choice):
                dest = self.root / f'agent-{choice}'
                self.run_cmd(['bash', self.source / 'init.sh', dest], text=f'2\n2\n{choice}\nn\nn\n')
                self.assertTrue((dest / pointer).is_file())
                self.assertIn('Project Native Language: English', (dest / 'AXIARCH.md').read_text())
                self.assertFalse((dest / 'axiarch-rules/ja').exists())
                self.assertFalse((dest / 'axiarch-harness/ja').exists())
                self.assertTrue((dest / 'axiarch-harness/en/TASK_STATE_PROTOCOL.md').exists())
                meta = json.loads((dest / '.axiarch/version.json').read_text())
                self.assertEqual(meta['healthStatus'], 'passed')
                self.assertEqual(meta['confirmedScope']['languages'], 'en')
                self.assertIn(meta['confirmedScope']['agent'], ('codex', 'claude', 'antigravity', 'cursor', 'copilot', 'windsurf', 'universal'))

    def test_install_diagnostic_failure_does_not_confirm_version(self):
        self.install_source(health=9)
        result = self.run_cmd(['bash', self.source / 'init.sh', self.target],
                              text='1\n1\n7\nn\nn\n', expected=4)
        self.assertNotIn('setup complete!', result.stdout)
        meta = json.loads((self.target / '.axiarch/version.json').read_text())
        self.assertIsNone(meta['version'])
        self.assertEqual(meta['healthStatus'], 'failed')
        report = json.loads((self.target / '.axiarch/install-result.json').read_text())
        self.assertEqual(report['application'], 'complete')
        self.assertEqual(report['health']['exit_code'], 9)

    def test_install_missing_selected_adapter_and_symlink_leave_target_intact(self):
        self.install_source(health=0)
        adapter = self.source / '.codex/hooks.json'
        content = adapter.read_bytes(); adapter.unlink()
        before = self.tree_bytes()
        self.run_cmd(['bash', self.source / 'init.sh', self.target], text='1\n1\n1\nn\nn\n', expected=3)
        self.assertEqual(self.tree_bytes(), before)
        outside = self.root / 'outside-config'; outside.write_bytes(content)
        adapter.symlink_to(outside)
        self.run_cmd(['bash', self.source / 'init.sh', self.target], text='1\n1\n1\nn\nn\n', expected=3)
        self.assertEqual(self.tree_bytes(), before)

    def test_install_optional_precommit_keeps_custom_hook(self):
        self.install_source(health=0)
        self.run_cmd(['git', 'init', '-q', self.target])
        hook = self.target / '.git/hooks/pre-commit'; hook.write_text('#!/usr/bin/env python3\nprint("custom")\n')
        before = hook.read_bytes()
        result = self.run_cmd(['bash', self.source / 'init.sh', self.target], text='1\n1\n7\nn\ny\n')
        self.assertEqual(hook.read_bytes(), before)
        self.assertIn('manual', json.loads((self.target / '.axiarch/install-result.json').read_text())['optional_precommit'])
        self.assertNotIn('Pre-commit hook will be installed', result.stdout)
        self.assertIn('Pre-commit installation requested', result.stdout)

    def test_install_eof_at_every_choice_and_invalid_option_do_not_apply(self):
        before = self.tree_bytes()
        for answers in ('', '1\n', '1\n1\n', '1\n1\n2\n', '1\n1\n2\ny\n', '1\n1\n2\ny\ny\n'):
            with self.subTest(answers=answers):
                result = self.run_cmd(['bash', ROOT / 'init.sh', self.target], text=answers, expected=None)
                self.assertNotEqual(result.returncode, 0)
                self.assertEqual(self.tree_bytes(), before)
        self.run_cmd(['bash', ROOT / 'init.sh', '--dry-run'], text='1\n1\n1\nn\nn\n', expected=2)
        self.assertEqual(self.tree_bytes(), before)

    def test_install_claude_prompts_and_fresh_precommit(self):
        self.install_source(health=0)
        self.target = self.root / 'adopter with spaces'; self.target.mkdir()
        self.run_cmd(['git', 'init', '-q', self.target])
        self.run_cmd(['bash', self.source / 'init.sh', self.target], text='2\n2\n2\ny\ny\ny\n')
        self.assertFalse((self.target / 'axiarch-prompts/ja').exists())
        commands = list((self.target / '.claude/commands').glob('axiarch-*.md'))
        self.assertTrue(commands)
        for command in commands:
            self.assertIn('axiarch-prompts/en/', command.read_text())
        self.assertTrue((self.target / '.git/hooks/pre-commit').is_file())
        self.run_cmd(['bash', self.target / '.git/hooks/pre-commit'])
        before = self.tree_bytes()
        self.run_cmd(['bash', self.source / 'init.sh', self.target], text='y\n1\n2\n2\ny\ny\ny\n', expected=3)
        self.assertEqual(self.tree_bytes(), before)

    def test_install_ambiguous_language_setting_stops_before_copy(self):
        self.install_source(health=0)
        protocol = self.source / 'AXIARCH.md'
        protocol.write_text(protocol.read_text() + '\nProject Native Language: English\n')
        before = self.tree_bytes()
        result = self.run_cmd(['bash', self.source / 'init.sh', self.target], text='1\n1\n7\nn\nn\n', expected=3)
        self.assertNotIn('setup complete!', result.stdout)
        self.assertEqual(self.tree_bytes(), before)

    def test_install_missing_hook_helper_stops_before_copy(self):
        self.install_source(health=0)
        for name in ('axiarch_hook.py', 'axiarch_diff.py'):
            with self.subTest(helper=name):
                path = self.source / 'axiarch-scripts' / name
                content = path.read_bytes(); path.unlink()
                before = self.tree_bytes()
                self.run_cmd(['bash', self.source / 'init.sh', self.target], text='1\n1\n7\nn\nn\n', expected=3)
                self.assertEqual(self.tree_bytes(), before)
                path.write_bytes(content)

    def test_install_invalid_hook_json_and_internal_preview_do_not_apply(self):
        self.install_source(health=0)
        config = self.source / '.codex/hooks.json'; config.write_text('{invalid')
        before = self.tree_bytes()
        self.run_cmd(['bash', self.source / 'init.sh', self.target], text='1\n1\n1\nn\nn\n', expected=3)
        self.assertEqual(self.tree_bytes(), before)
        stage = self.root / 'small-stage'; stage.mkdir(); (stage / 'example.txt').write_text('new file')
        self.run_cmd([sys.executable, SCRIPTS / 'axiarch_setup.py', 'install', '--target', self.target,
                      '--stage', stage, '--version', '1.0.0', '--lang', 'ja', '--dry-run'])
        self.assertEqual(self.tree_bytes(), before)

    def test_generation_shares_upgrade_lock_and_recovers_after_release(self):
        self.prompt_fixture()
        holder = subprocess.Popen([sys.executable, str(SCRIPTS / 'axiarch_upgrade.py'), 'run-locked',
                                   '--target', str(self.target), '--', sys.executable, '-u', '-c',
                                   'import sys; print("ready", flush=True); sys.stdin.readline()'],
                                  stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                                  text=True, env=self.env)
        try:
            self.assertEqual(holder.stdout.readline().strip(), 'ready')
            before = self.tree_bytes(); self.prompts(expected=6)
            self.assertEqual(self.tree_bytes(), before)
            holder.communicate('\n', timeout=10)
            self.assertEqual(holder.returncode, 0)
            self.prompts()
        finally:
            if holder.poll() is None:
                holder.kill(); holder.communicate()

    def test_prompt_language_quoting_regeneration_edit_and_clean_preview(self):
        self.prompt_fixture()
        self.prompts('--source', ROOT)
        command = self.commands / 'axiarch-demo.md'
        text = command.read_text()
        description = next(line.split(': ', 1)[1] for line in text.splitlines() if line.startswith('description:'))
        self.assertEqual(json.loads(description), 'Task: "quoted" title')
        self.assertIn('axiarch-rules/en/LOADING_PROTOCOL.md', text)
        self.assertNotIn('あなた', text)
        before = self.tree_bytes()
        self.prompts('--clean', '--dry-run')
        self.prompts('--dry-run')
        self.prompts()
        self.assertEqual(self.tree_bytes(), before)
        command.write_text(text + 'User edit\n')
        edited = self.tree_bytes()
        self.prompts('--clean', expected=3)
        self.prompts(expected=3)
        self.assertEqual(self.tree_bytes(), edited)
        command.write_text(text)
        self.prompts('--clean')
        self.assertFalse(command.exists())

    def test_prompt_invalid_language_or_empty_library_preserves_commands(self):
        self.prompt_fixture(); self.prompts()
        before = self.tree_bytes()
        self.prompts('--lang', 'typo', expected=2)
        self.assertEqual(self.tree_bytes(), before)
        self.prompt.unlink(); before = self.tree_bytes()
        self.prompts(expected=3)
        self.assertEqual(self.tree_bytes(), before)

    def test_prompt_missing_protocol_and_legacy_command_require_review(self):
        self.prompt_fixture()
        protocol = self.target / 'axiarch-rules/en/LOADING_PROTOCOL.md'
        protocol.unlink(); before = self.tree_bytes()
        self.prompts(expected=3)
        self.assertEqual(self.tree_bytes(), before)
        protocol.write_text('# Protocol\n')
        old = self.commands / 'axiarch-demo.md'
        old.write_text('---\ndescription: legacy\n---\n<!-- AXIARCH_GENERATED_COMMAND: do not edit; regenerate via axiarch-scripts/axiarch-prompts-install.sh -->\nLegacy command\n')
        before = self.tree_bytes(); self.prompts(expected=3); self.prompts('--clean', expected=3)
        self.assertEqual(self.tree_bytes(), before)

    def test_upgrade_selected_prompt_language_and_no_jq_dependency(self):
        self.upgrade_fixture()
        for lang in ('ja', 'en'):
            path = self.source / f'axiarch-prompts/{lang}/develop/demo.md'
            path.parent.mkdir(parents=True); path.write_text('# ' + lang)
        manifest = self.source / 'axiarch-manifest.json'
        data = json.loads(manifest.read_text()); data['files'].append(dict(path='axiarch-prompts', group='prompts', owner='axiarch', policy='optional'))
        manifest.write_text(json.dumps(data))
        stub = self.root / 'bin'; stub.mkdir()
        marker = self.root / 'jq-called'
        fake = stub / 'jq'; fake.write_text('#!/bin/bash\ntouch "' + str(marker) + '"\nexit 99\n'); fake.chmod(0o755)
        env = dict(self.env, PATH=str(stub) + ':' + self.env['PATH'])
        self.upgrade('--apply', '--yes', '--safe-only', '--with-prompts', '--lang', 'en', env=env)
        self.assertTrue((self.target / 'axiarch-prompts/en/develop/demo.md').is_file())
        self.assertFalse((self.target / 'axiarch-prompts/ja').exists())
        self.assertFalse(marker.exists())


if __name__ == '__main__':
    unittest.main()
