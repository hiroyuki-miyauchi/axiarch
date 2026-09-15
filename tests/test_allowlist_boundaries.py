"""Exercise per-agent overwrite exceptions using only isolated local fixtures."""
import json
import os
import unittest
from unittest.mock import patch

import test_runtime as runtime
import test_agent_compatibility as agents
from axiarch_hook import read_allowlist


class AllowlistBoundaryTests(unittest.TestCase):
    setUp = runtime.RuntimeTests.setUp
    run_cmd = runtime.RuntimeTests.run_cmd
    tree_bytes = runtime.RuntimeTests.tree_bytes
    guard_fixture = agents.AgentCompatibilityTests.guard_fixture
    configured_hook = agents.AgentCompatibilityTests.configured_hook

    def guard(self, agent, name, expected):
        value = {'file_path': name} if agent == 'claude' else {
            'command': '*** Begin Patch\n*** Add File: ' + name + '\n+replacement\n*** End Patch'}
        return self.configured_hook(agent, 'PreToolUse', dict(cwd=str(self.target),
            tool_name='Write' if agent == 'claude' else 'apply_patch', tool_input=value), expected=expected)

    def unsafe_allowlists(self, agent):
        for kind in ('symlink', 'parent-link', 'hardlink', 'broken-link', 'fifo', 'directory', 'invalid-utf8', 'nul'):
            with self.subTest(agent=agent, kind=kind):
                self.target = self.root / (agent + '-' + kind); self.target.mkdir()
                self.guard_fixture()
                existing = self.target / 'existing.txt'; existing.write_text('keep original\n')
                folder = self.target / ('.claude' if agent == 'claude' else '.codex')
                allow = folder / 'axiarch-overwrite-allow.txt'
                outside = self.root / ('outside-' + agent + '-' + kind)
                outside.write_text('existing.txt\n')
                if kind == 'symlink': allow.symlink_to(outside)
                elif kind == 'parent-link':
                    moved = self.root / ('config-' + agent)
                    folder.rename(moved); folder.symlink_to(moved, target_is_directory=True)
                    allow.write_text('existing.txt\n')
                elif kind == 'hardlink': os.link(outside, allow)
                elif kind == 'broken-link': allow.symlink_to(self.root / 'absent')
                elif kind == 'fifo': os.mkfifo(allow)
                elif kind == 'directory': allow.mkdir()
                elif kind == 'invalid-utf8': allow.write_bytes(b'existing.txt\n\xff\n')
                else: allow.write_bytes(b'existing.txt\n\x00\n')
                # A damaged Claude list must never fall through to Codex permission.
                if agent == 'claude':
                    (self.target / '.codex/axiarch-overwrite-allow.txt').write_text('existing.txt\n')
                before = self.tree_bytes()
                self.guard(agent, 'existing.txt', 2)
                self.guard(agent, 'new.txt', 0)  # Creation needs no overwrite exception.
                if agent == 'codex':
                    self.configured_hook(agent, 'PreToolUse', dict(cwd=str(self.target),
                        tool_name='apply_patch', tool_input={'command':
                            '*** Begin Patch\n*** Update File: existing.txt\n@@\n-keep original\n+edited\n*** End Patch'}))
                self.assertEqual(self.tree_bytes(), before)
                self.assertEqual(existing.read_text(), 'keep original\n')
                self.assertEqual(outside.read_text(), 'existing.txt\n')

    def test_claude_unsafe_allowlists_do_not_grant_overwrite(self):
        self.unsafe_allowlists('claude')

    def test_codex_unsafe_allowlists_do_not_grant_overwrite(self):
        self.unsafe_allowlists('codex')

    def test_legacy_codex_fallback_cannot_hide_damaged_claude_list(self):
        self.guard_fixture()
        (self.target / '.claude/settings.json').unlink()
        (self.target / '.codex/axiarch-overwrite-allow.txt').write_text('existing.txt\n')
        (self.target / 'existing.txt').write_text('keep\n')
        command = ['bash', self.target / 'axiarch-scripts/axiarch-protect-antifull.sh']
        payload = json.dumps(dict(cwd=str(self.target), tool_name='Write',
                                  tool_input={'file_path': 'existing.txt'}))
        env = dict(self.env, CLAUDE_PROJECT_DIR=str(self.target))
        self.run_cmd(command, text=payload, env=env)  # Preserve the legacy fallback.
        allow = self.target / '.claude/axiarch-overwrite-allow.txt'
        for kind in ('broken-link', 'fifo', 'directory'):
            with self.subTest(kind=kind):
                if kind == 'broken-link': allow.symlink_to(self.root / 'missing')
                elif kind == 'fifo': os.mkfifo(allow)
                else: allow.mkdir()
                before = self.tree_bytes()
                self.run_cmd(command, text=payload, env=env, expected=2)
                self.assertEqual(self.tree_bytes(), before)
                if kind == 'directory': allow.rmdir()
                else: allow.unlink()

    def test_other_owner_cannot_grant_exception(self):
        self.guard_fixture()
        for agent in ('claude', 'codex'):
            with self.subTest(agent=agent):
                allow = self.target / f'.{agent}/axiarch-overwrite-allow.txt'
                allow.write_text('existing.txt\n')
                self.assertEqual(read_allowlist(self.target, agent), ['existing.txt'])
                # Exercise the owner mismatch without requiring privileged chown.
                with patch('axiarch_hook.os.getuid', return_value=os.getuid() + 1):
                    with self.assertRaisesRegex(ValueError, 'exception not granted'):
                        read_allowlist(self.target, agent)
                self.assertEqual(allow.read_text(), 'existing.txt\n')

    def test_regular_allowlists_keep_unicode_crlf_absolute_and_glob_patterns(self):
        self.guard_fixture()
        generated = self.target / 'generated'; generated.mkdir()
        target = generated / '日本語 1.txt'; target.write_text('keep\n')
        for agent in ('claude', 'codex'):
            allow = self.target / ('.claude' if agent == 'claude' else '.codex') / 'axiarch-overwrite-allow.txt'
            for pattern in ('generated/*.txt', 'generated/日本語 ?.txt', str(target)):
                with self.subTest(agent=agent, pattern=pattern):
                    allow.write_bytes((' # Comment\r\n\r\n ' + pattern + ' \r\n').encode('utf-8'))
                    before = self.tree_bytes()
                    self.guard(agent, 'generated/日本語 1.txt', 0)
                    self.assertEqual(self.tree_bytes(), before)
            if agent == 'claude':
                # Retain Bash character classes in the legacy Write matcher.
                allow.write_text('generated/日本語 [[:digit:]].txt\n')
                self.guard(agent, 'generated/日本語 1.txt', 0)
        self.assertEqual(target.read_text(), 'keep\n')

    def test_inherited_codex_hint_cannot_replace_installed_claude_permission(self):
        for lang, name in [('Japanese', '日本語.txt'), ('English', 'existing.txt')]:
            with self.subTest(lang=lang):
                self.target = self.root / lang; self.target.mkdir()
                self.guard_fixture()
                (self.target / 'AXIARCH.md').write_text('Project Native Language: ' + lang + '\n')
                (self.target / name).write_text('keep\n')
                (self.target / '.codex/axiarch-overwrite-allow.txt').write_text(name + '\n')
                before = self.tree_bytes()
                for filename, expected in [(name, 2), ('new.txt', 0)]:
                    self.configured_hook('claude', 'PreToolUse', dict(cwd=str(self.target),
                        tool_name='Write', tool_input={'file_path': filename}), expected=expected,
                        extra={'AXIARCH_HOOK_AGENT': 'codex'})
                self.assertEqual(self.tree_bytes(), before)

    def test_each_native_agent_keeps_its_own_approved_paths_with_opposite_hint(self):
        self.guard_fixture()
        for agent in ('claude', 'codex'):
            (self.target / (agent + '.txt')).write_text('keep\n')
            (self.target / f'.{agent}/axiarch-overwrite-allow.txt').write_text(agent + '.txt\n')
        before = self.tree_bytes()
        for agent, other in [('claude', 'codex'), ('codex', 'claude')]:
            for filename, expected in [(agent + '.txt', 0), (other + '.txt', 2)]:
                with self.subTest(agent=agent, filename=filename):
                    value = {'file_path': filename} if agent == 'claude' else {'command':
                        '*** Begin Patch\n*** Add File: ' + filename + '\n+replacement\n*** End Patch'}
                    self.configured_hook(agent, 'PreToolUse', dict(cwd=str(self.target),
                        tool_name='Write' if agent == 'claude' else 'apply_patch', tool_input=value),
                        expected=expected, extra={'AXIARCH_HOOK_AGENT': other})
        self.assertEqual(self.tree_bytes(), before)

    def test_inherited_hint_cannot_hide_invalid_claude_allowlist_without_settings(self):
        for kind in ('broken-link', 'fifo', 'directory', 'invalid-utf8', 'nul'):
            with self.subTest(kind=kind):
                self.target = self.root / kind; self.target.mkdir(); self.guard_fixture()
                (self.target / '.claude/settings.json').unlink()
                (self.target / 'existing.txt').write_text('keep\n')
                (self.target / '.codex/axiarch-overwrite-allow.txt').write_text('existing.txt\n')
                allow = self.target / '.claude/axiarch-overwrite-allow.txt'
                if kind == 'broken-link': allow.symlink_to(self.root / 'missing')
                elif kind == 'fifo': os.mkfifo(allow)
                elif kind == 'directory': allow.mkdir()
                else: allow.write_bytes(b'PRIVATE_LIST_MARKER\n' + (b'\xff' if kind == 'invalid-utf8' else b'\x00'))
                before = self.tree_bytes()
                result = self.run_cmd(['bash', self.target / 'axiarch-scripts/axiarch-protect-antifull.sh'],
                    text=json.dumps(dict(cwd=str(self.target), tool_name='Write',
                                         tool_input={'file_path': 'existing.txt'})), expected=2,
                    env=dict(self.env, CLAUDE_PROJECT_DIR=str(self.target), AXIARCH_HOOK_AGENT='codex'))
                self.assertNotIn('PRIVATE_LIST_MARKER', result.stdout + result.stderr)
                self.assertEqual(self.tree_bytes(), before)

    def test_standalone_write_keeps_legacy_fallback_but_respects_explicit_claude(self):
        self.guard_fixture()
        (self.target / '.claude/settings.json').unlink()
        (self.target / '.codex/axiarch-overwrite-allow.txt').write_text('existing.txt\n')
        (self.target / 'existing.txt').write_text('keep\n')
        before = self.tree_bytes()
        for hint, expected in [('', 0), ('codex', 0), ('claude', 2)]:
            with self.subTest(hint=hint):
                self.run_cmd(['bash', self.target / 'axiarch-scripts/axiarch-protect-antifull.sh'],
                    text=json.dumps(dict(cwd=str(self.target), tool_name='Write',
                                         tool_input={'file_path': 'existing.txt'})), expected=expected,
                    env=dict(self.env, CLAUDE_PROJECT_DIR=str(self.target), AXIARCH_HOOK_AGENT=hint))
        self.assertEqual(self.tree_bytes(), before)

        # Native Claude Write remains Claude even with only a global hook or
        # after local settings disappear. Unknown event data is not permission.
        for event in ('PreToolUse', 'PostToolUse', None, {}, 'PRIVATE_EVENT_MARKER'):
            with self.subTest(event=event):
                result = self.run_cmd(['bash', self.target / 'axiarch-scripts/axiarch-protect-antifull.sh'],
                    text=json.dumps(dict(cwd=str(self.target), hook_event_name=event, tool_name='Write',
                                         tool_input={'file_path': 'existing.txt'})), expected=2,
                    env=dict(self.env, CLAUDE_PROJECT_DIR=str(self.target), AXIARCH_HOOK_AGENT='codex'))
                self.assertNotIn('PRIVATE_EVENT_MARKER', result.stdout + result.stderr)
        self.assertEqual(self.tree_bytes(), before)
        (self.target / '.claude/axiarch-overwrite-allow.txt').write_text('existing.txt\n')
        before = self.tree_bytes()
        self.run_cmd(['bash', self.target / 'axiarch-scripts/axiarch-protect-antifull.sh'],
            text=json.dumps(dict(cwd=str(self.target), hook_event_name='PreToolUse', tool_name='Write',
                                 tool_input={'file_path': 'existing.txt'})),
            env=dict(self.env, CLAUDE_PROJECT_DIR=str(self.target), AXIARCH_HOOK_AGENT='codex'))
        self.assertEqual(self.tree_bytes(), before)


if __name__ == '__main__':
    unittest.main()
