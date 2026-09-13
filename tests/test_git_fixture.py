"""Fixture commits must finish their writers before temporary-directory cleanup."""
from contextlib import redirect_stderr
import errno
import io
import json
import unittest
from unittest.mock import patch

import test_diff_guard
import test_git_health
import test_runtime as runtime


class GitFixtureTests(unittest.TestCase):
    setUp = runtime.RuntimeTests.setUp
    run_cmd = runtime.RuntimeTests.run_cmd

    def test_commit_waits_for_automatic_maintenance(self):
        for fixture in (test_git_health.GitHealthTests, test_diff_guard.DiffGuardTests):
            with self.subTest(fixture=fixture.__name__):
                target = self.root / fixture.__name__
                target.mkdir()
                git = lambda *args, **kwargs: fixture.git(self, '-C', str(target), *args, **kwargs)
                git('init', '-q')
                # Force real maintenance even in a tiny repository, on old and new Git.
                git('config', 'maintenance.loose-objects.enabled', 'true')
                git('config', 'maintenance.loose-objects.auto', '1')
                git('config', 'maintenance.gc.enabled', 'false')
                (target / 'probe.txt').write_text('fixture data\n')
                git('add', 'probe.txt')
                trace = self.root / (fixture.__name__ + '.jsonl')
                env = dict(self.env, GIT_TRACE2_EVENT=str(trace))
                git('-c', 'user.name=Fixture', '-c', 'user.email=fixture@example.invalid',
                    '-c', 'commit.gpgsign=false', 'commit', '-qm', 'fixture', env=env)
                events = [json.loads(line) for line in trace.read_text().splitlines()]
                maintenance = [e for e in events if e['event'] == 'child_start'
                               and e.get('argv', [])[1:3] == ['maintenance', 'run']]
                self.assertEqual(len(maintenance), 1)
                self.assertIn('--no-detach', maintenance[0]['argv'])
                self.assertTrue(any(e['event'] == 'region_enter' and e.get('label') == 'loose-objects'
                                    for e in events), 'maintenance must run, not be disabled')
                child = next(e for e in events if e['event'] == 'start'
                             and e.get('argv', [])[1:3] == ['maintenance', 'run'])
                child_exit = next(i for i, e in enumerate(events)
                                  if e['event'] == 'exit' and e['sid'] == child['sid'])
                parent_exit = next(i for i, e in enumerate(events)
                                   if e['event'] == 'exit' and e['sid'] == maintenance[0]['sid'])
                self.assertLess(child_exit, parent_exit, 'the commit must join its maintenance writer')
                self.assertFalse(any(e['event'] == 'error' for e in events))
                self.assertTrue(all(e['code'] == 0 for e in events if e['event'] == 'exit'))
                self.assertFalse((target / '.git/objects/maintenance.lock').exists())

    def test_cleanup_failure_is_reported_without_reading_contents_or_links(self):
        (self.target / 'private.txt').write_text('fixture-secret-must-not-be-logged')
        (self.target / 'external').symlink_to(runtime.ROOT, target_is_directory=True)
        error = OSError(errno.ENOTEMPTY, 'fixture still has a writer')
        output = io.StringIO()
        with patch.object(self.tmp, 'cleanup', side_effect=error), redirect_stderr(output):
            with self.assertRaises(OSError) as caught:
                runtime.cleanup_fixture(self.tmp)
        self.assertIs(caught.exception, error)
        record = json.loads(output.getvalue().removeprefix('FIXTURE_CLEANUP_ERROR '))
        self.assertEqual(record['errno'], errno.ENOTEMPTY)
        self.assertEqual(set(record['remaining_paths']),
                         {'adopter', 'adopter/external', 'adopter/private.txt'})
        self.assertNotIn('fixture-secret', output.getvalue())


if __name__ == '__main__':
    unittest.main()
