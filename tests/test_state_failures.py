"""State creation, lock and JSON failure injection in isolated adopters."""
import contextlib
import importlib.util
import io
import json
import os
from pathlib import Path
import select
import shutil
import signal
import subprocess
import sys
import unittest
from unittest.mock import patch

import test_runtime as runtime

STARTUP_TIMEOUT = 15  # Interpreter/bootstrap watchdog, not the lock deadline.


class StateFailureTests(unittest.TestCase):
    setUp = runtime.RuntimeTests.setUp
    run_cmd = runtime.RuntimeTests.run_cmd
    state = runtime.RuntimeTests.state
    state_file = runtime.RuntimeTests.state_file
    session_docs = runtime.RuntimeTests.session_docs
    boot = runtime.RuntimeTests.boot
    candidate = runtime.RuntimeTests.candidate
    ref = runtime.RuntimeTests.ref
    tree_bytes = runtime.RuntimeTests.tree_bytes

    def module(self):
        spec = importlib.util.spec_from_file_location('state_failure_fixture', runtime.SCRIPTS / 'axiarch_state.py')
        module = importlib.util.module_from_spec(spec); spec.loader.exec_module(module)
        return module

    def bounded_new(self, expected_error='task lock must be a regular file'):
        # Signal immediately before the real lock attempt, so interpreter and
        # CLI startup are not mistaken for blocking on a FIFO or another writer.
        probe = '''import sys
sys.path.insert(0, sys.argv[1])
import axiarch_state
original = axiarch_state.locked
def ready(root):
    print('LOCK_READY', flush=True)
    sys.stdin.read(1)
    return original(root)
axiarch_state.locked = ready
sys.argv = ['state', '--project', sys.argv[2], '--mode', 'new', '--task', 'new', '--session', 'new']
try:
    axiarch_state.main()
except (ValueError, OSError) as error:
    print(str(error), file=sys.stderr)
    sys.exit(2)
'''
        process = subprocess.Popen([sys.executable, '-c', probe, str(runtime.SCRIPTS), str(self.target)],
                                   env=self.env, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True,
                                   start_new_session=True)
        try:
            ready, _, _ = select.select([process.stdout], [], [], STARTUP_TIMEOUT)
            self.assertTrue(ready, 'state probe did not reach the lock boundary')
            self.assertEqual(process.stdout.readline().strip(), 'LOCK_READY')
            try:
                out, err = process.communicate('x', timeout=3)
            except subprocess.TimeoutExpired:
                self.fail('state lock did not reject the blocked or unsupported lock within three seconds')
        finally:
            if process.poll() is None:
                os.killpg(process.pid, signal.SIGKILL)
            process.communicate()
        self.assertEqual(process.returncode, 2, out + err)
        self.assertIn(expected_error, err)
        self.assertFalse((self.target / '.axiarch/tasks/new/state.json').exists())

    def test_fifo_and_hardlinked_lock_are_rejected_without_waiting(self):
        self.boot(); old = self.state_file().read_bytes()
        lock = self.target / '.axiarch/task-state.lock'
        lock.unlink(); os.mkfifo(lock); self.bounded_new(); lock.unlink()
        victim = self.root / 'unrelated'; victim.write_bytes(b'preserve')
        os.link(victim, lock); self.bounded_new()
        self.assertEqual(victim.read_bytes(), b'preserve')
        self.assertEqual(self.state_file().read_bytes(), old)

    def test_real_lock_contention_and_process_exit_release(self):
        self.boot(); old = self.state_file().read_bytes()
        code = ('import fcntl,sys; f=open(sys.argv[1],"a"); fcntl.flock(f,fcntl.LOCK_EX); '
                'print("locked",flush=True); sys.stdin.read()')
        process = subprocess.Popen([sys.executable, '-c', code, str(self.target / '.axiarch/task-state.lock')],
                                   stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        try:
            ready, _, _ = select.select([process.stdout], [], [], STARTUP_TIMEOUT)
            self.assertTrue(ready, 'competing writer did not start')
            self.assertEqual(process.stdout.readline().strip(), 'locked')
            self.bounded_new('task state is busy')
            self.assertEqual(self.state_file().read_bytes(), old)
        finally:
            process.communicate('', timeout=3)
        self.boot('new', 'new', 'new')

    def test_failed_legacy_import_does_not_leave_a_new_task(self):
        outside = self.root / 'outside.md'; outside.write_text('legacy evidence')
        legacy = self.target / 'task.md'; legacy.symlink_to(outside)
        self.state('--mode', 'new', '--task', 't1', '--session', 's1', '--import-legacy', expected=2)
        self.assertFalse(self.state_file().exists())
        self.assertFalse(self.session_docs().exists())
        self.assertEqual(outside.read_text(), 'legacy evidence')
        legacy.unlink(); self.boot(mode='new')

    def test_legacy_special_file_cannot_be_silently_skipped(self):
        os.mkfifo(self.target / 'task.md')
        self.state('--mode', 'new', '--task', 't1', '--session', 's1', '--import-legacy', expected=2)
        self.assertFalse(self.state_file().exists())
        self.assertFalse(self.session_docs().exists())

    def test_renderer_failure_rolls_back_and_same_ids_can_retry(self):
        scripts = self.root / 'scripts'; shutil.copytree(runtime.SCRIPTS, scripts)
        script = scripts / 'axiarch-task-state.sh'; original = script.read_text()
        needle = 'if [[ "${MODE}" != "render" ]]; then'
        self.assertIn(needle, original)
        script.write_text(original.replace(needle, 'if [[ "${MODE}" == "render" ]]; then exit 9; fi\n' + needle))
        self.run_cmd(['bash', script, '--project', self.target, '--mode', 'new', '--task', 't1', '--session', 's1'], expected=2)
        self.assertFalse(self.state_file().exists())
        self.assertFalse(self.session_docs().exists())
        script.write_text(original); self.boot(mode='new')

    def test_renderer_zero_exit_without_documents_is_not_success(self):
        scripts = self.root / 'scripts'; shutil.copytree(runtime.SCRIPTS, scripts)
        script = scripts / 'axiarch-task-state.sh'; original = script.read_text()
        needle = 'if [[ "${MODE}" != "render" ]]; then'
        script.write_text(original.replace(needle, 'if [[ "${MODE}" == "render" ]]; then exit 0; fi\n' + needle))
        self.run_cmd(['bash', script, '--project', self.target, '--mode', 'new', '--task', 't1', '--session', 's1'], expected=2)
        self.assertFalse(self.state_file().exists())
        self.assertFalse(self.session_docs().exists())

    def test_readonly_legacy_content_is_copied_without_changing_original_mode(self):
        legacy = self.target / 'task.md'; legacy.write_text('retained evidence'); legacy.chmod(0o444)
        self.state('--mode', 'new', '--task', 't1', '--session', 's1', '--import-legacy')
        self.assertEqual(legacy.read_text(), 'retained evidence')
        self.assertEqual(legacy.stat().st_mode & 0o777, 0o444)
        self.assertIn('retained evidence', (self.session_docs() / 'task.md').read_text())

    def test_failed_join_preserves_existing_task_and_session(self):
        self.boot(); old = self.state_file().read_bytes(); doc = self.session_docs() / 'task.md'
        doc.write_text('ongoing evidence'); (self.target / 'task.md').unlink()
        (self.target / 'task.md').symlink_to(self.root / 'missing')
        self.state('--mode', 'resume', '--task', 't1', '--session', 's2', '--import-legacy', expected=2)
        self.assertEqual(self.state_file().read_bytes(), old)
        self.assertEqual(doc.read_text(), 'ongoing evidence')
        self.assertFalse(self.session_docs('s2').exists())

    def test_incomplete_task_directory_is_neither_reinitialized_nor_hidden(self):
        history = self.target / '.axiarch/tasks/t1/history'; history.mkdir(parents=True)
        (history / '2.json').write_text('{"retained":"evidence"}')
        self.state('--mode', 'new', '--task', 't1', '--session', 's1', expected=2)
        self.state('--mode', 'status', expected=2)
        self.assertFalse(self.state_file().exists())
        self.assertEqual((history / '2.json').read_text(), '{"retained":"evidence"}')

    def test_optional_root_pointer_failure_keeps_usable_managed_records(self):
        module = self.module(); original = Path.open
        def fail_pointer(path, *args, **kwargs):
            if path == self.target / 'task.md' and args and args[0] == 'x':
                raise PermissionError('injected root pointer failure')
            return original(path, *args, **kwargs)
        output, error = io.StringIO(), io.StringIO()
        with patch.object(sys, 'argv', ['state', '--project', str(self.target), '--mode', 'new', '--task', 't1', '--session', 's1']), patch.object(Path, 'open', fail_pointer), contextlib.redirect_stdout(output), contextlib.redirect_stderr(error):
            module.main()
        self.assertIn('AXIARCH TASK STATE', output.getvalue())
        self.assertIn('pointer', error.getvalue())
        self.boot(mode='resume')

    def test_overflow_json_is_rejected_before_publish_or_hook_normalization(self):
        self.boot(); before = self.tree_bytes(); candidate = self.candidate()
        before_state = self.state_file().read_bytes()
        path = self.root / 'candidate.json'
        for value in ('1e999', '-1e999'):
            path.write_text(json.dumps(candidate)[:-1] + ',"extra":' + value + '}')
            self.state('--mode', 'publish', '--session', 's1', '--input', path, '--expected-revision', '0', expected=2)
            self.assertEqual(self.state_file().read_bytes(), before_state)
            result = self.run_cmd([sys.executable, runtime.SCRIPTS / 'axiarch_hook.py', 'normalize'], text='{"extra":' + value + '}', expected=2)
            self.assertEqual(result.stdout, '')
        self.assertEqual(set(before) - set(self.tree_bytes()), set())

    def test_atomic_writer_rejects_nonfinite_values_without_replacing_file(self):
        module = self.module(); path = self.root / 'state.json'; path.write_text('{"ok":true}')
        for value in (float('inf'), float('-inf'), float('nan')):
            with self.assertRaises(ValueError): module.atomic(path, {'extra': value})
            self.assertEqual(path.read_text(), '{"ok":true}')
        self.assertEqual(module.strict_json('{"number":1e3,"tiny":1e-99}'), {'number': 1000.0, 'tiny': 1e-99})

    def test_publication_failure_keeps_old_state_and_retry_reuses_history(self):
        self.boot(); candidate = self.candidate(); path = self.root / 'candidate.json'
        path.write_text(json.dumps(candidate)); before = self.state_file().read_bytes()
        module = self.module(); original = module.atomic
        def fail_current(target, value):
            if target == self.state_file(): raise OSError('injected current-state write failure')
            return original(target, value)
        argv = ['state', '--project', str(self.target), '--mode', 'publish', '--session', 's1',
                '--input', str(path), '--expected-revision', '0']
        with patch.object(sys, 'argv', argv), patch.object(module, 'atomic', fail_current):
            with self.assertRaises(OSError): module.main()
        self.assertEqual(self.state_file().read_bytes(), before)
        history = self.state_file().parent / 'history/0.json'
        self.assertEqual(json.loads(history.read_text()), json.loads(before))
        self.state('--mode', 'publish', '--session', 's1', '--input', path, '--expected-revision', '0')
        self.assertEqual(json.loads(self.state_file().read_text())['revision'], 1)
        self.assertEqual(json.loads(history.read_text()), json.loads(before))

    def test_killed_bootstrap_retains_draft_and_can_explicitly_resume(self):
        scripts = self.root / 'scripts'; shutil.copytree(runtime.SCRIPTS, scripts)
        script = scripts / 'axiarch-task-state.sh'; original = script.read_text()
        needle = 'if [[ "${MODE}" != "render" ]]; then'
        wait = 'if [[ "${MODE}" == "render" ]]; then printf "RENDER_WAIT\\n"; read -r pause; fi\n'
        script.write_text(original.replace(needle, wait + needle))
        process = subprocess.Popen(['bash', str(script), '--project', str(self.target), '--mode', 'new',
                                    '--task', 't1', '--session', 's1'], env=self.env, stdin=subprocess.PIPE,
                                   stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, start_new_session=True)
        try:
            ready, _, _ = select.select([process.stdout], [], [], STARTUP_TIMEOUT)
            self.assertTrue(ready, 'renderer did not start')
            self.assertEqual(process.stdout.readline().strip(), 'RENDER_WAIT')
        finally:
            os.killpg(process.pid, signal.SIGKILL); process.communicate(timeout=3)
        state = json.loads(self.state_file().read_text())
        self.assertEqual(state['phase'], 'draft')
        self.assertFalse(self.session_docs().exists())
        self.state('--mode', 'check', '--task', 't1', '--phase', 'completion', expected=2)
        self.boot(mode='resume')
        self.assertEqual(json.loads(self.state_file().read_text()), state)


if __name__ == '__main__':
    unittest.main()
