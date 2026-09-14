"""Bilingual scope hints through native hook configurations, with isolated data."""
import json
import os
import unittest

import test_runtime as runtime
import test_agent_compatibility as agents


class ScopeReviewTests(unittest.TestCase):
    setUp = runtime.RuntimeTests.setUp
    run_cmd = runtime.RuntimeTests.run_cmd
    tree_bytes = runtime.RuntimeTests.tree_bytes
    state = runtime.RuntimeTests.state
    boot = runtime.RuntimeTests.boot
    guard_fixture = agents.AgentCompatibilityTests.guard_fixture
    configured_hook = agents.AgentCompatibilityTests.configured_hook
    install_source = agents.AgentCompatibilityTests.install_source
    git = runtime.RuntimeTests.git

    def fixture(self, name, recorded='Existing UI layout', lang='Japanese'):
        self.target = self.root / name; self.target.mkdir()
        self.guard_fixture()
        (self.target / 'AXIARCH.md').write_text('Project Native Language: ' + lang + '\n')
        self.boot()
        self.docs = self.target / '.axiarch/sessions/s1'
        (self.docs / 'task.md').write_text('| AXIARCH.md | inspected fixture |\n')
        (self.docs / 'implementation_plan.md').write_text(recorded)
        (self.docs / 'walkthrough.md').write_text('Current fixture evidence\n')

    def reminder(self, agent, prompt='Continue', extra=None):
        result = self.configured_hook(agent, 'UserPromptSubmit', dict(cwd=str(self.target),
            session_id='s1', prompt=prompt), extra=dict(AXIARCH_REMINDER_TTL_SECONDS='1800', **(extra or {})))
        context = json.loads(result.stdout)['hookSpecificOutput']['additionalContext']
        return context, result.stderr

    def test_new_japanese_scope_forces_full_reminder_in_both_project_languages(self):
        for agent in ('claude', 'codex'):
            for lang in ('Japanese', 'English'):
                with self.subTest(agent=agent, lang=lang):
                    self.fixture(agent + lang, lang=lang)
                    before = self.tree_bytes()
                    self.reminder(agent)
                    self.assertIn('[AXIARCH REMINDER]', self.reminder(agent)[0])
                    context, _ = self.reminder(agent, '認証と暗号化を見直してください')
                    self.assertIn('New prompt keywords (auth encryption)', context)
                    self.assertIn('[AXIARCH BOOT]', context)
                    self.assertEqual(self.tree_bytes(), before)

    def test_same_scope_across_languages_and_fullwidth_does_not_force_reload(self):
        cases = [('authentication encryption API billing', '認証と暗号化、ＡＰＩと課金を見直す'),
                 ('認証と暗号化、APIと課金の検証', 'Authentication, encryption, API and BILLING'),
                 ('authn a11y ui_design', '認証とアクセシビリティ、画面設計を見直す')]
        for agent in ('claude', 'codex'):
            for index, (recorded, prompt) in enumerate(cases):
                with self.subTest(agent=agent, index=index):
                    self.fixture(agent + str(index), recorded=recorded)
                    before = self.tree_bytes()
                    self.reminder(agent)
                    context, _ = self.reminder(agent, prompt)
                    self.assertNotIn('New prompt keywords', context)
                    self.assertIn('[AXIARCH REMINDER]', context)
                    self.assertEqual(self.tree_bytes(), before)

    def test_invalid_custom_regex_is_unassessed_without_echoing_prompt(self):
        self.fixture('invalid-pattern')
        before = self.tree_bytes()
        for agent in ('claude', 'codex'):
            for _ in range(2):
                context, error = self.reminder(agent, 'SECRET_SCOPE_MARKER',
                    extra={'AXIARCH_TASK_DOMAIN_KEYWORDS': '['})
                self.assertIn('[SCOPE REVIEW UNASSESSED]', context)
                self.assertIn('[AXIARCH BOOT]', context)
                self.assertNotIn('SECRET_SCOPE_MARKER', context + error)
        self.assertEqual(self.tree_bytes(), before)

    def test_custom_ere_override_keeps_matching_without_echoing_values(self):
        self.fixture('custom-pattern', recorded='client-123')
        extra = {'AXIARCH_TASK_DOMAIN_KEYWORDS': 'client-[[:digit:]]+'}
        for agent in ('claude', 'codex'):
            self.reminder(agent)
            context, error = self.reminder(agent, 'client-456', extra=extra)
            self.assertIn('New prompt keywords', context)
            self.assertNotIn('client-456', context + error)
            self.assertNotIn('client-123', context + error)
            context, _ = self.reminder(agent, 'security 認証', extra=extra)
            self.assertIn('[AXIARCH REMINDER]', context)  # Explicit override replaces defaults.
            context, _ = self.reminder(agent, 'client-123', extra=extra)
            self.assertIn('[AXIARCH REMINDER]', context)

    def test_unreadable_context_is_unassessed_and_originals_are_preserved(self):
        for agent in ('claude', 'codex'):
            for kind in ('symlink', 'fifo', 'directory', 'invalid-utf8', 'missing'):
                with self.subTest(agent=agent, kind=kind):
                    self.fixture(agent + kind)
                    plan = self.docs / 'implementation_plan.md'; plan.unlink()
                    outside = self.root / ('outside-' + agent + kind)
                    outside.write_text('PRIVATE_CONTEXT_MARKER')
                    if kind == 'symlink': plan.symlink_to(outside)
                    elif kind == 'fifo': os.mkfifo(plan)
                    elif kind == 'directory': plan.mkdir()
                    elif kind == 'invalid-utf8': plan.write_bytes(b'PRIVATE_CONTEXT_MARKER\xff')
                    before = self.tree_bytes()
                    context, error = self.reminder(agent)
                    self.assertIn('[SCOPE REVIEW UNASSESSED]', context)
                    self.assertIn('[AXIARCH BOOT]', context)
                    self.assertNotIn('PRIVATE_CONTEXT_MARKER', context + error)
                    self.assertEqual(self.tree_bytes(), before)
                    self.assertEqual(outside.read_text(), 'PRIVATE_CONTEXT_MARKER')

    def test_disabled_detection_and_ordinary_words_do_not_demand_reload(self):
        self.fixture('ordinary')
        for agent in ('claude', 'codex'):
            self.reminder(agent)
            context, _ = self.reminder(agent, 'capital security_token restored costly')
            self.assertNotIn('New prompt keywords', context)
            self.assertIn('[AXIARCH REMINDER]', context)
            context, _ = self.reminder(agent, '認証 security', extra={
                'AXIARCH_TASK_BOUNDARY_DETECT': '0', 'AXIARCH_TASK_DOMAIN_KEYWORDS': '['})
            self.assertNotIn('[SCOPE REVIEW UNASSESSED]', context)
            self.assertIn('[AXIARCH REMINDER]', context)

    def test_missing_helper_is_reported_by_hook_and_health(self):
        self.fixture('missing-helper')
        (self.target / 'axiarch-scripts/axiarch_scope.py').unlink()
        before = self.tree_bytes()
        for agent in ('claude', 'codex'):
            context, _ = self.reminder(agent, 'security')
            self.assertIn('[SCOPE REVIEW UNASSESSED]', context)
            self.assertEqual(self.tree_bytes(), before)
        self.install_source()
        self.target = self.source
        self.run_cmd(['bash', self.target / 'axiarch-scripts/check-axiarch-health.sh', '--quiet'])
        (self.target / 'axiarch-scripts/axiarch_scope.py').unlink()
        before = self.tree_bytes()
        result = self.run_cmd(['bash', self.target / 'axiarch-scripts/check-axiarch-health.sh', '--quiet'], expected=1)
        self.assertIn('Missing runtime helper: axiarch_scope.py', result.stdout + result.stderr)
        self.assertEqual(self.tree_bytes(), before)


if __name__ == '__main__':
    unittest.main()
