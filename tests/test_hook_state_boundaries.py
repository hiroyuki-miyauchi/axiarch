"""Startup identity, reminder cache and non-regular state boundary regressions."""
import hashlib
import json
import os
import shutil
import signal
import shlex
import subprocess
import sys
import unittest

import test_runtime as runtime


class HookStateTests(unittest.TestCase):
    run_cmd = runtime.RuntimeTests.run_cmd
    state = runtime.RuntimeTests.state
    state_file = runtime.RuntimeTests.state_file
    session_docs = runtime.RuntimeTests.session_docs
    boot = runtime.RuntimeTests.boot
    tree_bytes = runtime.RuntimeTests.tree_bytes

    def setUp(self):
        runtime.RuntimeTests.setUp(self)
        shutil.copytree(runtime.SCRIPTS, self.target / 'axiarch-scripts')
        self.cache = self.root / 'cache'; self.cache.mkdir()

    def hook(self, name, payload='', extra=None, no_jq=False):
        env = dict(self.env, CLAUDE_PROJECT_DIR=str(self.target), TMPDIR=str(self.cache), AXIARCH_REMINDER_TTL_SECONDS='0')
        env.update(extra or {})
        if no_jq:
            binaries = self.root / 'bin'; binaries.mkdir(exist_ok=True)
            for tool in ('bash', 'cat', 'dirname', 'grep', 'head', 'sed', 'tr', 'sort', 'shasum', 'awk', 'date', 'python3'):
                path = binaries / tool
                if not path.exists(): path.symlink_to(sys.executable if tool == 'python3' else shutil.which(tool))
            env['PATH'] = str(binaries)
        process = subprocess.Popen(['bash', str(self.target / 'axiarch-scripts' / name)], cwd=self.target,
                                   env=env, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                                   text=True, start_new_session=True)
        try:
            # End-to-end hang watchdog, not a four-second startup SLA: normal
            # bootstrap spans several interpreters, filesystem syncs and Git
            # checks. The direct FIFO rejection test retains its 3s deadline.
            output, error = process.communicate(payload, timeout=15)
        except subprocess.TimeoutExpired:
            os.killpg(process.pid, signal.SIGKILL); process.communicate()
            self.fail('hook exceeded the end-to-end test deadline')
        self.assertEqual(process.returncode, 0, error)
        return json.loads(output)['hookSpecificOutput']['additionalContext'], error

    def test_invalid_startup_identity_preserves_records(self):
        for payload in ('{', '[]', '{"session_id":"s1","session_id":"s2"}',
                        '{"session_id":"s1","sessionId":"s2"}', '{"session_id":true}',
                        '{"session_id":"s1\\n"}'):
            with self.subTest(payload=payload):
                before = self.tree_bytes()
                context, _ = self.hook('axiarch-init-task-md.sh', payload)
                self.assertIn('[TASK STATE WARNING]', context)
                self.assertEqual(self.tree_bytes(), before)

    def test_raw_nul_json_is_not_silently_repaired(self):
        payload = '{"session_id":"s1","extra":"raw\x00nul"}'
        before = self.tree_bytes()
        context, _ = self.hook('axiarch-init-task-md.sh', payload)
        self.assertIn('[TASK STATE WARNING]', context)
        self.assertEqual(self.tree_bytes(), before)
        context, _ = self.hook('axiarch-boot-reminder.sh', payload)
        self.assertIn('[HOOK INPUT WARNING]', context)
        self.assertIn('docs=unresolved', context)

    def test_empty_startup_and_valid_alias_resume_remain_supported(self):
        context, _ = self.hook('axiarch-init-task-md.sh', '')
        self.assertIn('[AXIARCH TASK STATE]', context)
        self.hook('axiarch-init-task-md.sh', '{"sessionId":"s1"}')
        doc = self.session_docs() / 'task.md'; doc.write_text('keep in progress')
        self.hook('axiarch-init-task-md.sh', '{"session_id":"s1","sessionId":"s1"}')
        self.assertEqual(doc.read_text(), 'keep in progress')

    def test_python_stderr_is_not_used_as_session_identity(self):
        binaries = self.root / 'diagnostic-bin'; binaries.mkdir()
        wrapper = binaries / 'python3'
        wrapper.write_text('#!/bin/bash\nprintf "nonfatal runtime diagnostic\\n" >&2\nexec '
                           + shlex.quote(sys.executable) + ' "$@"\n')
        wrapper.chmod(0o755)
        extra = {'PATH': str(binaries) + os.pathsep + self.env.get('PATH', '/usr/bin:/bin')}
        context, _ = self.hook('axiarch-init-task-md.sh', '{"session_id":"s1"}', extra=extra)
        self.assertIn('[AXIARCH TASK STATE]', context)
        context, _ = self.hook('axiarch-boot-reminder.sh', '{"session_id":"s1"}', extra=extra)
        self.assertIn('docs=' + str(self.session_docs()), context)

    def test_missing_helper_returns_warning_without_creating_records(self):
        (self.target / 'axiarch-scripts/axiarch_hook.py').unlink(); before = self.tree_bytes()
        for hook in ('axiarch-init-task-md.sh', 'axiarch-boot-reminder.sh'):
            context, _ = self.hook(hook, '{"session_id":"s1"}')
            self.assertIn('WARNING', context)
            self.assertEqual(self.tree_bytes(), before)

    def test_reminder_ambiguous_identity_never_borrows_session(self):
        self.boot()
        context, _ = self.hook('axiarch-boot-reminder.sh', '{"session_id":"s1","session_id":"other"}')
        self.assertIn('[HOOK INPUT WARNING]', context)
        self.assertIn('docs=unresolved', context)

    def test_reminder_decodes_long_escaped_prompt_without_jq(self):
        payload = json.dumps({'prompt': 'security ' + 'long text ' * 90}).replace('security', '\\u0073ecurity')
        context, _ = self.hook('axiarch-boot-reminder.sh', payload, no_jq=True)
        self.assertIn('New prompt keywords (security)', context)

    def test_reminder_invalid_and_decimal_ttl_keep_valid_output(self):
        for value in ('invalid', '1+1', '999999999999999999999999999999999999999'):
            with self.subTest(ttl=value):
                context, error = self.hook('axiarch-boot-reminder.sh', extra={'AXIARCH_REMINDER_TTL_SECONDS': value})
                self.assertIn('[AXIARCH BOOT]', context)
                self.assertIn('cache', error.lower())
        self.hook('axiarch-boot-reminder.sh', extra={'AXIARCH_REMINDER_TTL_SECONDS': '08'})
        context, _ = self.hook('axiarch-boot-reminder.sh', extra={'AXIARCH_REMINDER_TTL_SECONDS': '08'})
        self.assertIn('[AXIARCH REMINDER]', context)

    def test_reminder_cache_preserves_symlink_hardlink_and_fifo(self):
        digest = hashlib.sha1(f'{self.target}:legacy'.encode()).hexdigest()[:12]
        cache = self.cache / f'axiarch-reminder-{digest}.timestamp'
        outside = self.root / 'keep.txt'; outside.write_text('keep')
        for kind in ('symlink', 'hardlink', 'fifo'):
            with self.subTest(kind=kind):
                if kind == 'symlink': cache.symlink_to(outside)
                elif kind == 'hardlink': os.link(outside, cache)
                else: os.mkfifo(cache)
                try:
                    before = cache.lstat()
                    context, _ = self.hook('axiarch-boot-reminder.sh', extra={'AXIARCH_REMINDER_TTL_SECONDS': '1800'})
                    self.assertIn('[AXIARCH BOOT]', context)
                    self.assertEqual(outside.read_text(), 'keep')
                    self.assertEqual(cache.lstat().st_ino, before.st_ino)
                finally:
                    cache.unlink()

    def test_hook_context_json_handles_control_characters_in_project_path(self):
        renamed = self.root / 'project\x01'; self.target.rename(renamed); self.target = renamed
        context, _ = self.hook('axiarch-init-task-md.sh', '{"session_id":"s1"}')
        self.assertIn(str(self.target), context)
        context, _ = self.hook('axiarch-boot-reminder.sh', '{"session_id":"s1"}')
        self.assertIn(str(self.target), context)

    def test_duplicate_shared_json_is_rejected_without_rewrite(self):
        self.boot()
        path = self.state_file(); text = path.read_text()
        for replacement in ('"phase": "active", "phase": "draft"', '"phase": "draft", "extra": NaN'):
            with self.subTest(replacement=replacement):
                path.write_text(text.replace('"phase": "draft"', replacement))
                before = self.tree_bytes()
                self.state('--mode', 'check', '--task', 't1', expected=2)
                self.assertEqual(self.tree_bytes(), before)

    def test_fifo_shared_state_fails_promptly(self):
        self.boot(); path = self.state_file(); path.unlink(); os.mkfifo(path)
        result = subprocess.run([sys.executable, runtime.SCRIPTS / 'axiarch_state.py', '--project', self.target,
                                 '--mode', 'check', '--task', 't1'], capture_output=True, text=True, timeout=3)
        self.assertEqual(result.returncode, 2, result.stderr)
        self.assertIn('regular file', result.stderr)

    def test_missing_session_document_does_not_report_successful_resume(self):
        self.boot(); (self.session_docs() / 'implementation_plan.md').unlink(); before = self.tree_bytes()
        self.state('--mode', 'resume', '--session', 's1', expected=2)
        self.assertEqual(self.tree_bytes(), before)


if __name__ == '__main__':
    unittest.main()
