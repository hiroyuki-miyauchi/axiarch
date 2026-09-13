"""Run the post-use diff observer in isolated repositories, without user config."""
import json
import os
from pathlib import Path
import shutil
import shlex
import subprocess
import sys
import unittest
from unittest.mock import patch
import importlib.util

import test_runtime as runtime


class DiffGuardTests(unittest.TestCase):
    run_cmd = runtime.RuntimeTests.run_cmd
    git = runtime.RuntimeTests.git

    def setUp(self):
        runtime.RuntimeTests.setUp(self)
        self.env.update(GIT_CONFIG_COUNT='0', GIT_TERMINAL_PROMPT='0')
        self.git('init', '-q')

    def commit(self):
        self.git('-c', 'user.name=Fixture', '-c', 'user.email=fixture@example.invalid',
                 '-c', 'commit.gpgsign=false', 'commit', '--allow-empty', '-qm', 'fixture')

    def guard(self, expected=2, extra=None, script=None):
        env = dict(self.env, CLAUDE_PROJECT_DIR=str(self.target), AXIARCH_DIFF_GUARD_MODE='block',
                   AXIARCH_DIFF_GUARD_MAX_LINES='0', AXIARCH_DIFF_GUARD_MAX_FILES='0')
        env.update(extra or {})
        result = self.run_cmd(['bash', script or runtime.SCRIPTS / 'axiarch-diff-guard.sh'], env=env,
                              text='{}', expected=expected)
        if result.stdout:
            data = json.loads(result.stdout)
            self.assertTrue('reason' in data or 'hookSpecificOutput' in data)
        return result

    def test_unborn_staged_file_is_measured_without_writing_git_objects(self):
        (self.target / 'first.txt').write_text('one\ntwo\n')
        self.git('add', 'first.txt')
        before = {str(p.relative_to(self.target)): p.read_bytes() for p in (self.target / '.git').rglob('*') if p.is_file()}
        result = self.guard()
        self.assertIn('Changed lines=2/0', result.stdout)
        after = {str(p.relative_to(self.target)): p.read_bytes() for p in (self.target / '.git').rglob('*') if p.is_file()}
        self.assertEqual(after, before)

    def test_staged_unstaged_and_special_filenames(self):
        path = self.target / 'tab\tnewline\nname.txt'; path.write_text('before\n')
        self.git('add', '.'); self.commit()
        path.write_text('after\n'); self.git('add', '.')
        (self.target / 'untracked.txt').write_text('last line')
        result = self.guard()
        self.assertIn('Changed lines=3/0', result.stdout)
        self.assertIn('files=2/0', result.stdout)

    def test_decimal_threshold_and_invalid_values(self):
        self.commit(); (self.target / 'lines.txt').write_text('line\n' * 9)
        result = self.guard(extra={'AXIARCH_DIFF_GUARD_MAX_LINES': '08', 'AXIARCH_DIFF_GUARD_MAX_FILES': '20'})
        self.assertIn('Changed lines=9/8', result.stdout)
        for value in ('-1', 'many', '9223372036854775808'):
            with self.subTest(value=value):
                result = self.guard(extra={'AXIARCH_DIFF_GUARD_MAX_LINES': value})
                self.assertIn('UNASSESSED', result.stdout)

    def test_git_failure_is_unassessed_in_each_mode(self):
        self.commit(); (self.target / '.git/index').write_bytes(b'corrupt index')
        for mode, code in (('warn', 0), ('block', 2)):
            result = self.guard(expected=code, extra={'AXIARCH_DIFF_GUARD_MODE': mode})
            self.assertIn('UNASSESSED', result.stdout)

    def test_untracked_links_never_count_target_content(self):
        self.commit()
        outside = self.root / 'outside'; outside.write_text('secret fixture\n' * 40)
        (self.target / 'link').symlink_to(outside)
        (self.target / 'dangling').symlink_to(self.root / 'absent')
        result = self.guard()
        self.assertIn('Changed lines=0/0', result.stdout)
        self.assertIn('files=2/0', result.stdout)
        self.assertEqual(outside.read_text(), 'secret fixture\n' * 40)

    def test_untracked_binary_is_a_file_without_text_lines(self):
        self.commit(); (self.target / 'binary').write_bytes(b'\x00\n' * 100)
        result = self.guard()
        self.assertIn('Changed lines=0/0', result.stdout)
        self.assertIn('files=1/0', result.stdout)

    def test_diff_does_not_execute_configured_external_programs(self):
        path = self.target / 'text.txt'; path.write_text('one\n')
        (self.target / '.gitattributes').write_text('*.txt diff=fixture\n')
        self.git('add', '.'); self.commit(); path.write_text('two\n')
        marker = self.root / 'external-ran'; script = self.root / 'external'
        script.write_text('#!/bin/sh\ntouch "' + str(marker) + '"\n'); script.chmod(0o755)
        self.git('config', 'diff.external', str(script))
        self.git('config', 'diff.fixture.textconv', str(script))
        self.git('config', 'core.fsmonitor', str(script))
        self.guard()
        self.assertFalse(marker.exists(), 'measurement ran repository-configured code')

    def test_subdirectory_uses_whole_repository(self):
        self.commit(); (self.target / 'top.txt').write_text('top\n')
        child = self.target / 'child'; child.mkdir()
        result = self.guard(extra={'CLAUDE_PROJECT_DIR': str(child)})
        self.assertIn('Changed lines=1/0', result.stdout)

    def test_inherited_git_environment_cannot_redirect_measurement(self):
        path = self.target / 'text.txt'; path.write_text('one\n')
        self.git('add', '.'); self.commit(); path.write_text('two\n')
        other = self.root / 'other'; other.mkdir()
        self.git('-C', str(other), 'init', '-q')
        self.git('-C', str(other), '-c', 'user.name=Fixture', '-c', 'user.email=fixture@example.invalid',
                 '-c', 'commit.gpgsign=false', 'commit', '--allow-empty', '-qm', 'fixture')
        for extra in ({'GIT_DIR': str(other / '.git'), 'GIT_WORK_TREE': str(other)},
                      {'GIT_CONFIG_COUNT': '1', 'GIT_CONFIG_KEY_0': 'core.worktree',
                       'GIT_CONFIG_VALUE_0': str(other)},
                      {'GIT_INDEX_FILE': str(self.root / 'absent-index')}):
            with self.subTest(keys=sorted(extra)):
                result = self.guard(extra=extra)
                self.assertIn('Changed lines=2/0, files=1/0', result.stdout)
        self.assertFalse((self.root / 'absent-index').exists())

    def test_clean_and_process_filters_do_not_execute(self):
        path = self.target / 'text.txt'; path.write_text('one\n')
        (self.target / '.gitattributes').write_text('*.txt filter=fixture\n')
        self.git('add', '.'); self.commit(); path.write_text('two\n')
        marker = self.root / 'filter-ran'; script = self.root / 'filter-command'
        script.write_text('#!/bin/sh\ntouch ' + shlex.quote(str(marker)) + '\ncat\n')
        script.chmod(0o755)
        self.git('config', 'filter.fixture.clean', str(script))
        self.git('config', 'filter.fixture.required', 'true')
        config = (self.target / '.git/config').read_bytes()
        index = (self.target / '.git/index').read_bytes()
        result = self.guard()
        self.assertFalse(marker.exists(), 'read-only measurement executed a clean filter')
        self.assertIn('Changed lines=2/0, files=1/0', result.stdout)
        self.assertEqual((self.target / '.git/config').read_bytes(), config)
        self.assertEqual((self.target / '.git/index').read_bytes(), index)
        self.git('config', 'filter.fixture.process', str(script))
        result = self.guard()
        self.assertFalse(marker.exists(), 'read-only measurement executed a process filter')
        self.assertIn('Changed lines=2/0, files=1/0', result.stdout)

    def test_project_outside_configured_worktree_is_unassessed(self):
        self.commit()
        other = self.root / 'other'; other.mkdir()
        self.git('config', 'core.worktree', str(other))
        result = self.guard()
        self.assertIn('UNASSESSED', result.stdout)

    def test_linked_worktree_uses_its_own_index_and_configuration(self):
        path = self.target / 'text.txt'; path.write_text('one\n')
        self.git('add', '.'); self.commit()
        other = self.root / 'linked'
        self.git('worktree', 'add', '--detach', '-q', str(other))
        (other / 'text.txt').write_text('two\n')
        result = self.guard(extra={'CLAUDE_PROJECT_DIR': str(other)})
        self.assertIn('Changed lines=2/0, files=1/0', result.stdout)
        self.guard(expected=0)

    def test_filters_from_includes_and_worktree_config_are_disabled(self):
        path = self.target / 'text.txt'; path.write_text('one\n')
        (self.target / '.gitattributes').write_text('*.txt filter=fixture\n')
        self.git('add', '.'); self.commit(); path.write_text('two\n')
        marker = self.root / 'filter-ran'
        script = self.root / 'filter-command'
        script.write_text('#!/bin/sh\ntouch ' + shlex.quote(str(marker)) + '\ncat\n'); script.chmod(0o755)
        include = self.root / 'included.config'
        self.git('config', '--file', str(include), 'filter.fixture.clean', str(script))
        self.git('config', 'include.path', str(include))
        before = include.read_bytes()
        self.guard(); self.assertFalse(marker.exists()); self.assertEqual(include.read_bytes(), before)
        self.git('config', '--unset', 'include.path')
        self.git('config', 'extensions.worktreeConfig', 'true')
        self.git('config', '--worktree', 'filter.fixture.process', str(script))
        config = (self.target / '.git/config.worktree').read_bytes()
        self.guard(); self.assertFalse(marker.exists())
        self.assertEqual((self.target / '.git/config.worktree').read_bytes(), config)

    def test_global_configuration_does_not_change_observation(self):
        path = self.target / 'text.txt'; path.write_text('one\n')
        self.git('add', '.'); self.commit(); path.write_text('two\n')
        config = self.root / 'global.config'
        self.git('config', '--file', str(config), 'core.worktree', str(self.root / 'wrong'))
        before = config.read_bytes()
        result = self.guard(extra={'GIT_CONFIG_GLOBAL': str(config)})
        self.assertIn('Changed lines=2/0, files=1/0', result.stdout)
        self.assertEqual(config.read_bytes(), before)

    def test_missing_promisor_object_does_not_invoke_remote_helper(self):
        path = self.target / 'text.txt'; path.write_text('one\n')
        self.git('add', '.'); self.commit(); path.write_text('two\n')
        blob = self.git('rev-parse', 'HEAD:text.txt').stdout.strip()
        (self.target / '.git/objects' / blob[:2] / blob[2:]).unlink()
        marker = self.root / 'remote-ran'; script = self.root / 'remote-command'
        script.write_text('#!/bin/sh\ntouch ' + shlex.quote(str(marker)) + '\nexit 1\n'); script.chmod(0o755)
        # Local fake remote only; no service, credential or network is involved.
        self.git('config', 'remote.origin.url', 'ext::' + str(script))
        self.git('config', 'remote.origin.promisor', 'true')
        self.git('config', 'protocol.ext.allow', 'always')
        result = self.guard()
        self.assertIn('UNASSESSED', result.stdout)
        self.assertFalse(marker.exists())

    def test_filter_inventory_failure_does_not_fall_through_to_diff(self):
        self.commit()
        real_git = shutil.which('git'); binary = self.root / 'bin'; binary.mkdir()
        marker = self.root / 'diff-ran'; wrapper = binary / 'git'
        wrapper.write_text('#!/bin/sh\nfor arg in "$@"; do\n'
                           '  if [ "$arg" = config ]; then echo fixture-private-detail >&2; exit 7; fi\n'
                           '  if [ "$arg" = diff ]; then touch ' + shlex.quote(str(marker)) + '; fi\n'
                           'done\nexec ' + shlex.quote(real_git) + ' "$@"\n')
        wrapper.chmod(0o755)
        result = self.guard(extra={'PATH': str(binary) + os.pathsep + self.env['PATH']})
        self.assertIn('UNASSESSED', result.stdout)
        self.assertFalse(marker.exists())
        self.assertNotIn('fixture-private-detail', result.stdout + result.stderr)

    def test_git_without_no_lazy_fetch_is_explicitly_unassessed(self):
        self.commit()
        real_git = shutil.which('git'); binary = self.root / 'bin'; binary.mkdir()
        wrapper = binary / 'git'
        wrapper.write_text('#!/bin/sh\nfor arg in "$@"; do\n'
                           '  if [ "$arg" = --no-lazy-fetch ]; then exit 129; fi\n'
                           'done\nexec ' + shlex.quote(real_git) + ' "$@"\n')
        wrapper.chmod(0o755)
        for mode, code in (('warn', 0), ('block', 2)):
            result = self.guard(expected=code, extra={'PATH': str(binary) + os.pathsep + self.env['PATH'],
                                                     'AXIARCH_DIFF_GUARD_MODE': mode})
            self.assertIn('UNASSESSED', result.stdout)

    def test_opt_out_and_missing_dependency(self):
        self.guard(expected=0, extra={'AXIARCH_DIFF_GUARD_MODE': 'off'})
        self.guard(expected=0, extra={'AXIARCH_DIFF_GUARD_ALLOW': '1'})
        copied = self.root / 'scripts'; copied.mkdir()
        script = copied / 'axiarch-diff-guard.sh'; shutil.copy2(runtime.SCRIPTS / script.name, script)
        for mode, code in (('warn', 0), ('block', 2)):
            result = self.guard(expected=code, script=script, extra={'AXIARCH_DIFF_GUARD_MODE': mode})
            self.assertIn('UNASSESSED', result.stdout)

    def test_non_repository_is_explicitly_unassessed(self):
        outside = self.root / 'not-git'; outside.mkdir()
        result = self.guard(extra={'CLAUDE_PROJECT_DIR': str(outside)})
        self.assertIn('UNASSESSED', result.stdout)

    def test_unicode_unborn_branch_and_newline_project_path(self):
        renamed = self.root / '作業\n'; self.target.rename(renamed); self.target = renamed
        self.git('symbolic-ref', 'HEAD', 'refs/heads/作業')
        (self.target / 'first.txt').write_text('one\n'); self.git('add', '.')
        result = self.guard()
        self.assertIn('Changed lines=1/0', result.stdout)

    def test_reader_rejects_special_files_and_replaced_parent(self):
        spec = importlib.util.spec_from_file_location('axiarch_diff_fixture', runtime.SCRIPTS / 'axiarch_diff.py')
        module = importlib.util.module_from_spec(spec); spec.loader.exec_module(module)
        os.mkfifo(self.target / 'pipe')
        with self.assertRaises(ValueError): module.untracked_lines(self.target, 'pipe')
        outside = self.root / 'outside-dir'; outside.mkdir(); (outside / 'text').write_text('outside\n')
        (self.target / 'parent').symlink_to(outside, target_is_directory=True)
        with self.assertRaises(OSError): module.untracked_lines(self.target, 'parent/text')
        with patch.object(module.subprocess, 'run', side_effect=subprocess.TimeoutExpired('git', 10)):
            with self.assertRaises(subprocess.TimeoutExpired): module.git(self.target, 'diff')

    def test_fixture_discards_inherited_git_overrides(self):
        fixture = unittest.TestCase()
        try:
            with patch.dict(os.environ, {'GIT_DIR': '/unrelated', 'GIT_INDEX_FILE': '/unrelated-index',
                                         'GIT_CONFIG_COUNT': '1', 'GIT_CONFIG_KEY_0': 'diff.external'}):
                runtime.RuntimeTests.setUp(fixture)
            for name in ('GIT_DIR', 'GIT_INDEX_FILE', 'GIT_CONFIG_COUNT', 'GIT_CONFIG_KEY_0'):
                self.assertNotIn(name, fixture.env)
        finally:
            fixture.doCleanups()


if __name__ == '__main__':
    unittest.main()
