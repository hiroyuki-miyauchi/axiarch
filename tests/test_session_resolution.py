"""Existing corrupt sessions are distinct from optional, uncreated H0 records."""
import json
import os
import unittest

import test_runtime as runtime
import test_agent_compatibility as agents
import test_scope_review as scope


class SessionResolutionTests(unittest.TestCase):
    setUp = runtime.RuntimeTests.setUp
    run_cmd = runtime.RuntimeTests.run_cmd
    tree_bytes = runtime.RuntimeTests.tree_bytes
    state = runtime.RuntimeTests.state
    boot = runtime.RuntimeTests.boot
    state_file = runtime.RuntimeTests.state_file
    session_docs = runtime.RuntimeTests.session_docs
    candidate = runtime.RuntimeTests.candidate
    ref = runtime.RuntimeTests.ref
    guard_fixture = agents.AgentCompatibilityTests.guard_fixture
    configured_hook = agents.AgentCompatibilityTests.configured_hook
    fixture = scope.ScopeReviewTests.fixture
    reminder = scope.ScopeReviewTests.reminder

    def damage(self, kind):
        binding = self.docs / 'binding.json'
        state = self.state_file()
        if kind == 'binding-array': binding.write_text('[]')
        elif kind == 'missing-binding': binding.unlink()
        elif kind == 'broken-binding':
            binding.unlink(); binding.symlink_to(self.root / 'missing')
        elif kind == 'missing-state': state.unlink()
        elif kind == 'state-array': state.write_text('[]')
        elif kind == 'invalid-state': state.write_text('{"PRIVATE_STATE_MARKER":')
        elif kind == 'state-fifo': state.unlink(); os.mkfifo(state)
        elif kind == 'state-link':
            outside = self.root / 'outside-state.json'; outside.write_text(state.read_text())
            state.unlink(); state.symlink_to(outside)
        else:
            value = json.loads(state.read_text()); value['task_id'] = 'other-task'
            state.write_text(json.dumps(value))

    def test_path_rejects_missing_invalid_or_mismatched_bound_task(self):
        for kind in ('binding-array', 'missing-state', 'state-array', 'invalid-state',
                     'state-fifo', 'state-link', 'wrong-task'):
            with self.subTest(kind=kind):
                self.fixture(kind); self.damage(kind); before = self.tree_bytes()
                result = self.state('--mode', 'path', '--session', 's1', expected=2)
                self.assertNotIn('Traceback', result.stderr)
                self.assertEqual(self.tree_bytes(), before)

    def test_existing_resolution_failure_forces_full_bilingual_reminder(self):
        for agent in ('claude', 'codex'):
            for lang in ('Japanese', 'English'):
                for kind in ('binding-array', 'missing-binding', 'broken-binding',
                             'missing-state', 'invalid-state', 'wrong-task'):
                    with self.subTest(agent=agent, lang=lang, kind=kind):
                        self.fixture(agent + lang + kind, lang=lang)
                        extra = {'AXIARCH_TASK_BOUNDARY_DETECT': '0'}
                        self.reminder(agent, extra=extra)
                        self.assertIn('[AXIARCH REMINDER]', self.reminder(agent, extra=extra)[0])
                        self.damage(kind); before = self.tree_bytes()
                        context, error = self.reminder(agent, extra=extra)
                        self.assertIn('[TASK STATE WARNING]', context)
                        self.assertIn('[AXIARCH BOOT]', context)
                        self.assertIn('docs=unresolved', context)
                        self.assertIn('既存セッション', context)
                        self.assertNotIn('PRIVATE_STATE_MARKER', context + error)
                        self.assertEqual(self.tree_bytes(), before)

    def test_uncreated_session_remains_optional_in_both_agents_and_languages(self):
        for agent in ('claude', 'codex'):
            for lang in ('Japanese', 'English'):
                with self.subTest(agent=agent, lang=lang):
                    self.target = self.root / (agent + lang); self.target.mkdir()
                    self.guard_fixture()
                    (self.target / 'AXIARCH.md').write_text('Project Native Language: ' + lang + '\n')
                    before = self.tree_bytes()
                    self.reminder(agent)
                    context, _ = self.reminder(agent)
                    self.assertIn('[AXIARCH REMINDER]', context)
                    self.assertNotIn('[TASK STATE WARNING]', context)
                    self.assertEqual(self.tree_bytes(), before)

    def test_repaired_binding_restores_context_without_resetting_other_session(self):
        for agent in ('claude', 'codex'):
            self.fixture(agent)
            self.boot(session='other', task='other-task')
            binding = self.docs / 'binding.json'; original = binding.read_bytes()
            before = self.tree_bytes()
            self.reminder(agent)
            self.damage('binding-array')
            self.assertIn('[TASK STATE WARNING]', self.reminder(agent)[0])
            binding.write_bytes(original)
            context, _ = self.reminder(agent)
            self.assertNotIn('[TASK STATE WARNING]', context)
            self.assertIn('[AXIARCH REMINDER]', context)
            self.assertIn('docs=' + str(self.docs), context)
            self.assertEqual(self.tree_bytes(), before)

    def test_historical_state_path_is_structure_only_and_read_only(self):
        self.fixture('historical')
        record = self.candidate(done=True); record['phase'] = 'complete'; record['max_age_seconds'] = 1
        record['criteria'][0]['checked_at'] = '2000-01-01T00:00:00+00:00'
        self.state_file().write_text(json.dumps(record))
        (self.target / 'subject.txt').write_text('changed since the historical task\n')
        (self.target / 'verification.txt').unlink()
        before = self.tree_bytes()
        self.assertEqual(self.state('--mode', 'path', '--session', 's1').stdout.strip(), str(self.docs))
        self.state('--mode', 'check', '--phase', 'completion', '--task', 't1', '--session', 's1', expected=2)
        for agent in ('claude', 'codex'):
            context, _ = self.reminder(agent)
            self.assertNotIn('[TASK STATE WARNING]', context)
            self.assertIn('docs=' + str(self.docs), context)
        self.assertEqual(self.tree_bytes(), before)


if __name__ == '__main__':
    unittest.main()
