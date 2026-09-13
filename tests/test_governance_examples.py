"""Execute distributed examples and notice delivery in isolated repositories."""
import json
import re
import shutil
import textwrap
import unittest

from check_documentation import inspect
import test_runtime as runtime
import test_setup as setup

ROOT, SCRIPTS = runtime.ROOT, runtime.SCRIPTS


class GovernanceExampleTests(unittest.TestCase):
    setUp = runtime.RuntimeTests.setUp
    run_cmd = runtime.RuntimeTests.run_cmd
    tree_bytes = runtime.RuntimeTests.tree_bytes
    upgrade_fixture = runtime.RuntimeTests.upgrade_fixture
    upgrade = runtime.RuntimeTests.upgrade
    install_source = setup.SetupTests.install_source

    def test_numbered_policy_example_accepts_all_three_digit_prefixes(self):
        for lang in ('ja', 'en'):
            source = (ROOT / f'axiarch-rules/{lang}/universal/core/100_governance.md').read_text()
            pattern = re.search(r'not regex.match\(`([^`]+)`', source)[1]
            for prefix in range(1000):
                self.assertIsNotNone(re.fullmatch(pattern, f'{prefix:03d}_topic.md'))
            for invalid in ('00_topic.md', '1000_topic.md', '100_Upper.md', 'README.md'):
                self.assertIsNone(re.fullmatch(pattern, invalid))

    def test_pre_receive_example_allows_fast_forward_and_rejects_rewinds(self):
        self.run_cmd(['git', 'init', '-q'])
        self.env.update(GIT_AUTHOR_NAME='Fixture', GIT_AUTHOR_EMAIL='fixture@example.invalid',
                        GIT_COMMITTER_NAME='Fixture', GIT_COMMITTER_EMAIL='fixture@example.invalid',
                        AXIARCH_PROTECTED_REF='refs/heads/reviewed-main')
        tree = self.run_cmd(['git', 'mktree']).stdout.strip()
        first = self.run_cmd(['git', '-c', 'commit.gpgsign=false', 'commit-tree', tree], text='first\n').stdout.strip()
        second = self.run_cmd(['git', '-c', 'commit.gpgsign=false', 'commit-tree', tree, '-p', first], text='second\n').stdout.strip()
        fork = self.run_cmd(['git', '-c', 'commit.gpgsign=false', 'commit-tree', tree, '-p', first], text='fork\n').stdout.strip()
        null = '0' * len(first)
        cases = [(first, second, 0), (second, second, 0), (second, first, 1),
                 (second, fork, 1), (second, null, 1), (null, first, 0),
                 ('1' * len(first), second, 1)]
        for lang in ('ja', 'en'):
            source = (ROOT / f'axiarch-rules/{lang}/universal/core/100_governance.md').read_text()
            part = source.split('### 14.5.', 1)[1]
            script = textwrap.dedent(re.search(r'    ```bash\n(.*?)    ```', part, re.S)[1])
            for old, new, result in cases:
                with self.subTest(lang=lang, old=old, new=new):
                    self.run_cmd(['bash', '-c', script], text=f'{old} {new} refs/heads/reviewed-main\n', expected=result)
            self.run_cmd(['bash', '-c', script], text=f'{second} {first} refs/heads/unprotected\n')

    def test_install_delivers_notices_and_preserves_adopter_root_notices(self):
        self.install_source(health=0)
        for name in ('LICENSE', 'NOTICE'):
            (self.target / name).write_text('Adopter-owned ' + name)
        self.run_cmd(['bash', self.source / 'init.sh', self.target], text='2\n2\n7\nn\nn\n')
        for name in ('LICENSE', 'NOTICE'):
            self.assertEqual((self.target / name).read_text(), 'Adopter-owned ' + name)
            self.assertEqual((self.target / 'axiarch-rules' / name).read_bytes(), (ROOT / name).read_bytes())
        self.assertFalse((self.target / 'axiarch-rules/ja').exists())

    def test_missing_source_notice_stops_before_adopter_changes(self):
        self.install_source(health=0)
        (self.source / 'axiarch-rules/NOTICE').unlink()
        before = self.tree_bytes()
        result = self.run_cmd(['bash', self.source / 'init.sh', self.target],
                              text='2\n2\n7\nn\nn\n', expected=None)
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(before, self.tree_bytes())

    def test_upgrade_manifest_and_legacy_defaults_deliver_notices_safely(self):
        self.upgrade_fixture()
        for folder in ('axiarch-rules', 'axiarch-harness'):
            shutil.copytree(ROOT / folder, self.source / folder)
        shutil.copyfile(ROOT / 'AGENTS.md', self.source / 'AGENTS.md')
        for name in ('LICENSE', 'NOTICE'):
            shutil.copyfile(ROOT / name, self.source / 'axiarch-rules' / name)
            (self.target / name).write_text('Adopter ' + name)
        source_manifest = json.loads((ROOT / 'axiarch-manifest.json').read_text())
        rows = [row for row in source_manifest['files'] if row['path'] in ('axiarch-rules/LICENSE', 'axiarch-rules/NOTICE')]
        self.assertEqual(len(rows), 2)
        for legacy in (False, True):
            with self.subTest(legacy=legacy):
                if legacy:
                    shutil.rmtree(self.target / 'axiarch-rules')
                manifest = {'axiarchVersion': '2.0.0'}
                if not legacy:
                    manifest['files'] = rows
                (self.source / 'axiarch-manifest.json').write_text(json.dumps(manifest))
                before = self.tree_bytes()
                self.upgrade('--dry-run', expected=None)
                self.assertEqual(before, self.tree_bytes())
                self.upgrade('--apply', text='', expected=None)
                self.assertEqual(before, self.tree_bytes())
                self.upgrade('--apply', '--yes', '--interactive', text='2\n' + '\n' * 12, expected=None)
                for name in ('LICENSE', 'NOTICE'):
                    self.assertEqual((self.target / 'axiarch-rules' / name).read_bytes(), (ROOT / name).read_bytes())
                    self.assertEqual((self.target / name).read_text(), 'Adopter ' + name)
                notice = self.target / 'axiarch-rules/NOTICE'
                notice.write_text('custom attribution retained')
                self.upgrade('--apply', '--yes', '--interactive', text='2\n' + '\n' * 12, expected=None)
                self.assertEqual(notice.read_text(), 'custom attribution retained')
                result = json.loads((self.target / '.axiarch/upgrade-result.json').read_text())
                self.assertEqual(result['application'], 'partial')

    def test_source_notice_drift_and_ambiguous_numbered_references_are_detected(self):
        (self.root / 'init.sh').write_text('# fixture\n')
        (self.root / 'axiarch-rules').mkdir()
        for name in ('LICENSE', 'NOTICE'):
            (self.root / name).write_text('source')
            (self.root / 'axiarch-rules' / name).write_text('source')
        guide = self.root / 'README.md'; guide.write_text('# Guide\n')
        self.assertEqual(inspect(self.root), [])
        (self.root / 'axiarch-rules/NOTICE').write_text('stale')
        self.assertTrue(any('notice differs' in issue for issue in inspect(self.root)))
        (self.root / 'axiarch-rules/NOTICE').write_text('source')
        guide.write_text('Read `100_governance.md`.\n')
        self.assertTrue(any('ambiguous numbered filename' in issue for issue in inspect(self.root)))
        guide.write_text('Read `axiarch-rules/{lang}/universal/core/100_governance.md`.\n')
        self.assertEqual(inspect(self.root), [])
