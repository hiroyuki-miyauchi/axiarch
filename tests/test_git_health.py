"""Git diagnostic failures and target selection, using local synthetic worktrees."""
import os
import shlex
import shutil
import unittest

import test_runtime as runtime
import test_setup as setup


class GitHealthTests(unittest.TestCase):
    run_cmd = runtime.RuntimeTests.run_cmd
    install_source = setup.SetupTests.install_source
    state = runtime.RuntimeTests.state
    boot = runtime.RuntimeTests.boot

    def setUp(self):
        runtime.RuntimeTests.setUp(self)
        self.install_source(); self.target = self.source
        self.git('init', '-q'); self.git('symbolic-ref', 'HEAD', 'refs/heads/audit-fixture')
        self.boot()
        self.git('add', '.')
        self.git('-c', 'user.name=Fixture', '-c', 'user.email=fixture@example.invalid',
                 '-c', 'commit.gpgsign=false', 'commit', '-qm', 'fixture')
        self.git('update-ref', 'refs/remotes/origin/main', 'HEAD')

    def git(self, *args):
        return self.run_cmd(['git', *args])

    def health(self, expected=0, extra=None):
        return self.run_cmd(['bash', self.target / 'axiarch-scripts/check-axiarch-health.sh', self.target],
                            env=dict(self.env, **(extra or {})), expected=expected)

    def test_git_query_failures_are_not_zero_counts(self):
        self.health()
        binary = self.root / 'bin'; binary.mkdir(); wrapper = binary / 'git'
        real_git = shutil.which('git')
        for operation in ('rev-list', 'reflog', 'branch'):
            with self.subTest(operation=operation):
                wrapper.write_text('#!/bin/sh\nfor arg in "$@"; do\n'
                                   '  if [ "$arg" = ' + operation + ' ]; then echo fixture-private-detail >&2; exit 7; fi\n'
                                   'done\nexec ' + shlex.quote(real_git) + ' "$@"\n')
                wrapper.chmod(0o755)
                result = self.health(expected=1, extra={'PATH': str(binary) + os.pathsep + self.env['PATH']})
                self.assertIn('UNASSESSED', result.stdout + result.stderr)
                self.assertNotIn('fixture-private-detail', result.stdout + result.stderr)
                if operation == 'rev-list':
                    self.assertNotIn('Up-to-date', result.stdout)
                if operation == 'reflog':
                    self.assertNotIn('No force-push entries', result.stdout)

    def test_inherited_git_target_does_not_replace_selected_project(self):
        other = self.root / 'other'; other.mkdir()
        self.git('-C', str(other), 'init', '-q')
        self.git('-C', str(other), 'symbolic-ref', 'HEAD', 'refs/heads/unrelated-fixture')
        result = self.health(extra={'GIT_DIR': str(other / '.git'), 'GIT_WORK_TREE': str(other)})
        self.assertIn('audit-fixture', result.stdout)
        self.assertNotIn('unrelated-fixture', result.stdout)

    def test_detached_head_is_not_reported_as_a_feature_branch(self):
        self.git('checkout', '--detach', '-q')
        result = self.health()
        self.assertIn('Detached HEAD', result.stdout)
        self.assertNotIn('On feature branch:', result.stdout)

    def test_missing_local_remote_reference_is_explicit_and_not_fetched(self):
        self.git('update-ref', '-d', 'refs/remotes/origin/main')
        result = self.health()
        self.assertIn('origin/main', result.stdout)
        self.assertNotIn('Up-to-date', result.stdout)

    def test_unborn_branch_with_remote_reference_is_not_a_failure(self):
        self.git('checkout', '--orphan', 'new-fixture', '-q')
        result = self.health()
        self.assertIn('Unborn branch', result.stdout)
        self.assertNotIn('behind=0', result.stdout)

    def test_unsupported_git_is_a_diagnostic_failure_for_a_worktree(self):
        real_git = shutil.which('git'); binary = self.root / 'bin'; binary.mkdir()
        wrapper = binary / 'git'
        wrapper.write_text('#!/bin/sh\nfor arg in "$@"; do\n'
                           '  if [ "$arg" = --no-lazy-fetch ]; then exit 129; fi\n'
                           'done\nexec ' + shlex.quote(real_git) + ' "$@"\n')
        wrapper.chmod(0o755)
        result = self.health(expected=1, extra={'PATH': str(binary) + os.pathsep + self.env['PATH']})
        self.assertIn('GIT UNASSESSED', result.stdout + result.stderr)


if __name__ == '__main__':
    unittest.main()
