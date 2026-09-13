"""Real Windows preflight checks and portable POSIX regression coverage."""
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
SCRIPTS = ROOT / 'axiarch-scripts'


class PlatformBoundaryTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix='axiarch-platform-')
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        self.target = self.root / '日本語 project'
        self.target.mkdir()
        (self.target / 'keep.txt').write_text('keep\n', encoding='utf-8')
        self.env = dict(os.environ, PYTHONDONTWRITEBYTECODE='1', PYTHONUTF8='1')

    def snapshot(self):
        return {str(p.relative_to(self.target)): p.read_bytes() if p.is_file() else None
                for p in self.target.rglob('*')}

    def run_process(self, args, **kwargs):
        return subprocess.run([str(a) for a in args], cwd=self.target, env=self.env,
                              input='', text=True, encoding='utf-8', errors='replace',
                              capture_output=True, timeout=90, **kwargs)

    def test_helpers_reject_missing_posix_support_before_mutation(self):
        before = self.snapshot()
        for script in ('axiarch_state.py', 'axiarch_setup.py', 'axiarch_upgrade.py',
                       'axiarch_hook.py', 'axiarch_inspect.py'):
            with self.subTest(script=script):
                if os.name == 'nt':
                    command = [sys.executable, SCRIPTS / script]
                else:
                    # Only the Windows job is native-Windows evidence. This is
                    # a separate POSIX-host regression for a missing capability.
                    code = ('import sys,runpy; sys.modules["fcntl"]=None; '
                            'sys.path.insert(0,sys.argv[1]); runpy.run_path(sys.argv[2],run_name="__main__")')
                    command = [sys.executable, '-c', code, SCRIPTS, SCRIPTS / script]
                result = self.run_process(command)
                self.assertEqual(result.returncode, 2, result.stdout + result.stderr)
                self.assertIn('AXIARCH_PLATFORM_UNSUPPORTED', result.stderr)
                self.assertNotIn('Traceback', result.stderr)
                self.assertEqual(self.snapshot(), before)

    @unittest.skipUnless(os.name == 'posix', 'requires the POSIX runtime')
    def test_posix_runtime_can_create_and_resume_records(self):
        (self.target / 'AXIARCH.md').write_text('Project Native Language: English\n')
        command = ['bash', SCRIPTS / 'axiarch-task-state.sh', '--project', self.target,
                   '--mode', 'session-start', '--session', 'platform-check', '--task', 'platform-check']
        first = self.run_process(command)
        self.assertEqual(first.returncode, 0, first.stdout + first.stderr)
        before = self.snapshot()
        resumed = self.run_process(command)
        self.assertEqual(resumed.returncode, 0, resumed.stdout + resumed.stderr)
        self.assertEqual(self.snapshot(), before)
        state = json.loads((self.target / '.axiarch/tasks/platform-check/state.json').read_text())
        self.assertEqual(state['phase'], 'draft')

    @unittest.skipUnless(os.name == 'nt', 'executed by the real Windows CI job')
    def test_native_windows_launchers_fail_before_target_changes(self):
        git = Path(shutil.which('git') or '')
        bash = git.parent.parent / 'bin/bash.exe'
        self.assertTrue(bash.is_file(), 'Git for Windows Bash must be installed in this CI job')
        wrappers = self.root / 'command wrappers'; wrappers.mkdir()
        # Use the actual Windows interpreter, not a mock POSIX implementation.
        (wrappers / 'python3').write_text(
            '#!/usr/bin/env bash\nexec "' + Path(sys.executable).as_posix() + '" "$@"\n',
            encoding='utf-8', newline='\n')
        launcher = self.root / 'standalone-init.sh'
        shutil.copyfile(ROOT / 'init.sh', launcher)
        before = self.snapshot()
        for script, args in [(ROOT / 'init.sh', [self.target]), (launcher, [self.target]),
                             (SCRIPTS / 'axiarch-upgrade.sh', ['--source', ROOT, '--target', self.target,
                                                              '--apply', '--yes'])]:
            with self.subTest(script=str(script)):
                result = self.run_process([
                    bash, '--noprofile', '--norc', '-c',
                    'export PATH="$(cygpath -u "$1"):$PATH"; shift; exec bash "$@"',
                    'axiarch-platform-test', wrappers.as_posix(), script.as_posix(),
                    *[a.as_posix() if isinstance(a, Path) else a for a in args]])
                self.assertEqual(result.returncode, 2, result.stdout + result.stderr)
                self.assertIn('AXIARCH_PLATFORM_UNSUPPORTED', result.stderr)
                self.assertNotIn('Traceback', result.stderr)
                self.assertNotIn('setup complete!', result.stdout)
                self.assertEqual(self.snapshot(), before)

    def test_executable_source_keeps_lf_and_utf8_after_checkout(self):
        paths = [ROOT / 'init.sh', *SCRIPTS.glob('*.sh'), *SCRIPTS.glob('*.py')]
        for path in paths:
            with self.subTest(path=path.name):
                data = path.read_bytes()
                data.decode('utf-8')
                self.assertNotIn(b'\r\n', data)
                self.assertFalse(data.startswith(b'\xef\xbb\xbf'))

    def test_diff_guard_reports_unsupported_runtime_with_configured_severity(self):
        before = self.snapshot()
        for mode, expected in (('warn', 0), ('block', 2)):
            with self.subTest(mode=mode):
                self.env['AXIARCH_DIFF_GUARD_MODE'] = mode
                if os.name == 'nt':
                    command = [sys.executable, SCRIPTS / 'axiarch_diff.py']
                else:
                    code = ('import sys; sys.path.insert(0,sys.argv[1]); import axiarch_diff; '
                            'axiarch_diff.os.name="nt"; sys.exit(axiarch_diff.main())')
                    command = [sys.executable, '-c', code, SCRIPTS]
                result = self.run_process(command)
                self.assertEqual(result.returncode, expected, result.stdout + result.stderr)
                self.assertIn('DIFF GUARD UNASSESSED', result.stderr)
                self.assertIn('AXIARCH_PLATFORM_UNSUPPORTED', result.stderr)
                self.assertNotIn('Traceback', result.stderr)
                payload = json.loads(result.stdout)
                self.assertEqual(payload.get('decision') == 'block', mode == 'block')
                self.assertEqual(self.snapshot(), before)


if __name__ == '__main__':
    unittest.main()
