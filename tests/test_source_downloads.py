"""Exercise bootstrap downloads with a local fake curl; never contact a server."""
import io
import os
from pathlib import Path
import re
import shutil
import tarfile
import time
import unittest

import test_runtime as runtime
import test_setup as setup

ROOT, SCRIPTS = runtime.ROOT, runtime.SCRIPTS


class SourceDownloadTests(unittest.TestCase):
    setUp = runtime.RuntimeTests.setUp
    run_cmd = runtime.RuntimeTests.run_cmd
    tree_bytes = runtime.RuntimeTests.tree_bytes
    upgrade_fixture = runtime.RuntimeTests.upgrade_fixture
    install_source = setup.SetupTests.install_source

    def prepare_download(self, initial=False):
        if initial:
            self.install_source(health=0)
        else:
            self.upgrade_fixture()
        self.archive = self.root / 'source.tar.gz'
        with tarfile.open(self.archive, 'w:gz') as archive:
            archive.add(self.source, arcname='axiarch-source')
        self.bin = self.root / 'bin'; self.bin.mkdir()
        curl = self.bin / 'curl'
        curl.write_text('#!/usr/bin/env python3\n'
                        'import os,sys,time\n'
                        'mode=os.environ.get("AXIARCH_TEST_DOWNLOAD", "ok")\n'
                        'if mode=="hang": time.sleep(3)\n'
                        'failed=any(a=="--fail" or (a.startswith("-") and not a.startswith("--") and "f" in a) for a in sys.argv[1:])\n'
                        'output=sys.argv[sys.argv.index("-o")+1] if "-o" in sys.argv else None\n'
                        'if mode=="http-error" and failed:\n'
                        '    if output: open(output,"wb").write(b"# partial download")\n'
                        '    sys.exit(22)\n'
                        'body=open(os.environ["AXIARCH_TEST_ARCHIVE"],"rb").read()\n'
                        'if output: open(output,"wb").write(body)\n'
                        'else: sys.stdout.buffer.write(body)\n')
        curl.chmod(0o755)
        self.env.update(PATH=str(self.bin) + os.pathsep + self.env['PATH'], AXIARCH_TEST_ARCHIVE=str(self.archive))
        if initial:
            launcher = self.root / 'remote-launcher'; launcher.mkdir()
            self.launcher = launcher / 'init.sh'; shutil.copy2(ROOT / 'init.sh', self.launcher)
        else:
            self.launcher = SCRIPTS / 'axiarch-upgrade.sh'

    def download(self, initial=False, **kwargs):
        command = ['bash', self.launcher, self.target] if initial else [
            'bash', self.launcher, '--target', self.target, '--ref', 'heads/test-fixture', '--dry-run']
        return self.run_cmd(command, text='2\n2\n7\nn\nn\n' if initial else '', **kwargs)

    def test_remote_upgrade_preview_leaves_adopter_unchanged(self):
        self.prepare_download(); before = self.tree_bytes()
        self.download()
        self.assertEqual(self.tree_bytes(), before)

    def test_remote_install_uses_selected_language(self):
        self.prepare_download(initial=True)
        self.download(initial=True)
        self.assertIn('Project Native Language: English', (self.target / 'AXIARCH.md').read_text())
        self.assertFalse((self.target / 'axiarch-rules/ja').exists())

    def test_http_error_with_archive_body_is_not_a_successful_upgrade_source(self):
        self.prepare_download(); before = self.tree_bytes()
        self.env['AXIARCH_TEST_DOWNLOAD'] = 'http-error'
        self.download(expected=1)
        self.assertEqual(self.tree_bytes(), before)

    def test_http_error_does_not_install_or_announce_download_completion(self):
        self.prepare_download(initial=True); before = self.tree_bytes()
        self.env['AXIARCH_TEST_DOWNLOAD'] = 'http-error'
        result = self.download(initial=True, expected=1)
        self.assertNotIn('Downloaded to temporary directory.', result.stdout)
        self.assertEqual(self.tree_bytes(), before)

    def test_download_deadline_kills_waiting_transfer_without_applying(self):
        self.prepare_download(); before = self.tree_bytes()
        self.env.update(AXIARCH_TEST_DOWNLOAD='hang', AXIARCH_DOWNLOAD_TIMEOUT_SECONDS='1')
        started = time.monotonic()
        result = self.download(expected=1)
        self.assertLess(time.monotonic() - started, 2.5)
        self.assertIn('timed out', result.stdout + result.stderr)
        self.assertEqual(self.tree_bytes(), before)

    def test_extract_deadline_leaves_target_unchanged(self):
        self.prepare_download(); before = self.tree_bytes()
        tar = self.bin / 'tar'; tar.write_text('#!/usr/bin/env python3\nimport time\ntime.sleep(3)\n'); tar.chmod(0o755)
        self.env['AXIARCH_DOWNLOAD_TIMEOUT_SECONDS'] = '1'
        started = time.monotonic()
        self.download(expected=1)
        self.assertLess(time.monotonic() - started, 2.5)
        self.assertEqual(self.tree_bytes(), before)

    def test_broken_archive_never_reaches_application(self):
        self.prepare_download(); self.archive.write_bytes(b'not a gzip archive')
        before = self.tree_bytes(); self.download(expected=1)
        self.assertEqual(self.tree_bytes(), before)

    def test_traversal_archive_is_rejected_before_application(self):
        self.prepare_download(); before = self.tree_bytes()
        with tarfile.open(self.archive, 'w:gz') as archive:
            item = tarfile.TarInfo('axiarch-source/../../escape-fixture'); item.size = 4
            archive.addfile(item, io.BytesIO(b'test'))
        self.download(expected=1)
        self.assertEqual(self.tree_bytes(), before)

    def test_unsafe_paths_types_and_collisions_stop_before_native_extraction(self):
        self.prepare_download(); before = self.tree_bytes()
        # Any native extraction in a rejected case is a test failure.
        marker = self.root / 'extraction-ran'
        tar = self.bin / 'tar'
        tar.write_text('#!/usr/bin/env python3\nfrom pathlib import Path\n'
                       f'Path({str(marker)!r}).touch()\n')
        tar.chmod(0o755)
        cases = [('/absolute',), ('root/../escape',), ('root/./file',), ('root//file',),
                 ('root/file\\name',), ('root/file\x1b[31m',), ('root/file', 'root/file'),
                 ('root/File', 'root/file'), ('root/café', 'root/cafe\u0301'),
                 ('root/file', 'other/file')]
        for names in cases:
            with self.subTest(names=names):
                with tarfile.open(self.archive, 'w:gz') as archive:
                    for name in names:
                        archive.addfile(tarfile.TarInfo(name))
                self.download(expected=1)
                self.assertFalse(marker.exists())
                self.assertEqual(self.tree_bytes(), before)
        for kind in (tarfile.SYMTYPE, tarfile.LNKTYPE, tarfile.FIFOTYPE, tarfile.CHRTYPE):
            with self.subTest(kind=kind):
                with tarfile.open(self.archive, 'w:gz') as archive:
                    item = tarfile.TarInfo('root/file'); item.type = kind; item.linkname = '../outside'
                    archive.addfile(item)
                self.download(expected=1)
                self.assertFalse(marker.exists())
                self.assertEqual(self.tree_bytes(), before)

    def test_archive_entry_limit_rejects_without_applying(self):
        self.prepare_download(); before = self.tree_bytes()
        with tarfile.open(self.archive, 'w:gz') as archive:
            for index in range(10001):
                archive.addfile(tarfile.TarInfo(f'root/{index}'))
        result = self.download(expected=1)
        self.assertIn('entry/time limit', result.stderr)
        self.assertEqual(self.tree_bytes(), before)

    def test_gzip_checksum_failure_is_rejected_without_applying(self):
        self.prepare_download(); before = self.tree_bytes()
        content = bytearray(self.archive.read_bytes()); content[-8] ^= 1
        self.archive.write_bytes(content)
        self.download(expected=1)
        self.assertEqual(self.tree_bytes(), before)

    def test_invalid_timeout_is_rejected_before_transfer(self):
        self.prepare_download(); before = self.tree_bytes()
        for value in ('0', '-1', 'abc', '601'):
            with self.subTest(timeout=value):
                self.env['AXIARCH_DOWNLOAD_TIMEOUT_SECONDS'] = value
                self.download(expected=1)
                self.assertEqual(self.tree_bytes(), before)

    def test_bootstrap_download_contracts_are_identical(self):
        pattern = r'# AXIARCH_DOWNLOAD_BEGIN\n(.*?)# AXIARCH_DOWNLOAD_END'
        bodies = [re.search(pattern, p.read_text(), re.S) for p in (ROOT / 'init.sh', SCRIPTS / 'axiarch-upgrade.sh')]
        self.assertTrue(all(bodies))
        self.assertEqual(bodies[0][1], bodies[1][1])

    def test_documented_bootstraps_isolate_partial_downloads(self):
        self.prepare_download(); before = self.tree_bytes()
        self.env['TMPDIR'] = str(self.root)
        directories = set()
        for name in ('README.md', 'axiarch-scripts/README.md', 'llms.txt', 'llms-full.txt'):
            snippets = re.findall(r'^axiarch_bootstrap_dir=.*?^mv .*?$',
                                  (ROOT / name).read_text(), re.M | re.S)
            self.assertTrue(snippets, name)
            for snippet in snippets:
                for mode in ('ok', 'http-error'):
                    with self.subTest(document=name, mode=mode):
                        self.env['AXIARCH_TEST_DOWNLOAD'] = mode
                        command = snippet + '\nstatus=$?\nprintf "%s\\n" "$axiarch_bootstrap_dir"\nexit "$status"\n'
                        result = self.run_cmd(['bash', '-c', command], expected=0 if mode == 'ok' else 22)
                        directory = Path(result.stdout.strip())
                        self.assertNotIn(directory, directories)
                        directories.add(directory)
                        self.assertEqual(directory.parent.resolve(), self.root.resolve())
                        scripts = list(directory.glob('*.sh'))
                        if mode == 'ok':
                            self.assertEqual(len(scripts), 1)
                            self.assertEqual(scripts[0].read_bytes(), self.archive.read_bytes())
                        else:
                            self.assertEqual(scripts, [])
                            self.assertTrue((directory / 'download.part').exists())
                        self.assertEqual(self.tree_bytes(), before)


if __name__ == '__main__':
    unittest.main()
