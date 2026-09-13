"""追加監査の回帰: 実記録、候補表示、拡張フォルダ、参照の異常系。"""
from datetime import date, timedelta
import importlib.util
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile
import textwrap
import unittest

from check_documentation import inspect as inspect_docs, inspect_prompt, anchors

ROOT = Path(__file__).resolve().parents[1]
SCRIPTS = ROOT / "axiarch-scripts"
spec = importlib.util.spec_from_file_location("axiarch_inspect", SCRIPTS / "axiarch_inspect.py")
inspector = importlib.util.module_from_spec(spec)
# Match normal script execution while loading its colocated shared helpers.
sys.path.insert(0, str(SCRIPTS))
try:
    spec.loader.exec_module(inspector)
finally:
    sys.path.remove(str(SCRIPTS))


class ConsistencyTests(unittest.TestCase):
    def test_layer_relative_references_cannot_silently_cross_layers(self):
        for lang in ('ja', 'en'):
            for layer in ('universal', 'blueprint'):
                base = self.root / 'axiarch-rules' / lang / layer / 'core'; base.mkdir(parents=True)
                (base / '100_rule.md').write_text('Use `core/010_log.md`.\n')
            (self.root / f'axiarch-rules/{lang}/blueprint/core/010_log.md').write_text('# Log\n')
        issues = inspect_docs(self.root)
        self.assertEqual(len([issue for issue in issues if 'missing layer-relative path' in issue]), 2)
        for lang in ('ja', 'en'):
            rule = self.root / f'axiarch-rules/{lang}/universal/core/100_rule.md'
            rule.write_text(f'Use `axiarch-rules/{lang}/blueprint/core/010_log.md`.\n'
                            'Example (e.g., `engineering/050_example.md`).\n')
        self.assertEqual(inspect_docs(self.root), [])

    def test_concrete_inline_paths_are_checked_without_rewriting_history_or_examples(self):
        missing = 'axiarch-harness/en/CONTRACT.md'
        guide = self.root / 'README.md'
        guide.write_text(f'Use `{missing}`.\n')
        self.assertTrue(any('missing inline path' in issue for issue in inspect_docs(self.root)))
        guide.write_text(f'```md\nUse `{missing}`.\n```\nUse `axiarch-harness/{{lang}}/EXAMPLE.md`.\n')
        history = self.root / 'CHANGELOG.md'
        history.write_text(f'# Changelog\n## [Unreleased]\nCurrent notes\n## [1.0.0]\nUsed `{missing}`.\n')
        self.assertEqual(inspect_docs(self.root), [])
        history.write_text(history.read_text().replace('Current notes', f'Use `{missing}`.'))
        self.assertTrue(any('missing inline path' in issue for issue in inspect_docs(self.root)))

    def release_fixture(self):
        paths = ['init.sh', 'axiarch-manifest.json', 'ROADMAP.md', 'llms-full.txt', 'llms.txt',
                 'README.md', 'CHANGELOG.md', 'axiarch-scripts/axiarch-upgrade.sh', 'axiarch-scripts/README.md']
        paths += [f'axiarch-prompts/{lang}/develop/safe_upgrade_execute.md' for lang in ('ja', 'en')]
        paths += [f'axiarch-rules/{lang}/blueprint/INDEX.md' for lang in ('ja', 'en')]
        for name in paths:
            destination = self.root / name
            destination.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(ROOT / name, destination)
        manifest = json.loads((self.root / 'axiarch-manifest.json').read_text())
        stable = re.search(r'^## \[([0-9]+\.[0-9]+\.[0-9]+)\]',
                           (self.root / 'CHANGELOG.md').read_text(), re.M)[1]
        return manifest, stable

    @unittest.skipUnless(shutil.which('jq'), 'release metadata gate requires jq')
    def test_release_metadata_gate_accepts_current_docs_and_rejects_wrong_source_tag(self):
        workflow = (ROOT / '.github/workflows/release.yml').read_text()
        step = workflow.split('      - name: Validate release metadata parity\n', 1)[1]
        script = textwrap.dedent(step.split('        run: |\n', 1)[1].split('\n      - name:', 1)[0])
        manifest, version = self.release_fixture()
        # Exercise stable-publication checks with a stable fixture even while
        # the source repository is an Unreleased development snapshot.
        build = manifest['axiarchVersion']
        manifest['axiarchVersion'] = version
        (self.root / 'axiarch-manifest.json').write_text(json.dumps(manifest))
        init = self.root / 'init.sh'
        init.write_text(init.read_text().replace(f'AXIARCH_VERSION="{build}"', f'AXIARCH_VERSION="{version}"'))
        guide = self.root / 'llms-full.txt'
        guide.write_text(guide.read_text().replace(f'Current Release: {build}', f'Current Release: {version}'))
        env = dict(self.env, RELEASE_VERSION=version, GITHUB_REPOSITORY='hiroyuki-miyauchi/axiarch')
        result = subprocess.run(['bash', '-c', script], cwd=self.root, env=env,
                                capture_output=True, text=True, timeout=15)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        # Both the launcher URL and the requested source tag must remain pinned.
        for name in ('README.md', 'llms.txt', 'llms-full.txt'):
            guide = self.root / name; original = guide.read_text()
            for old in (f'axiarch/v{version}/init.sh', f'AXIARCH_REF=tags/v{version}'):
                with self.subTest(guide=name, field=old):
                    guide.write_text(original.replace(old, old.replace(version, '0.0.0')))
                    rejected = subprocess.run(['bash', '-c', script], cwd=self.root, env=env,
                                              capture_output=True, text=True, timeout=15)
                    self.assertNotEqual(rejected.returncode, 0)
                    self.assertIn('Pinned installer version mismatch', rejected.stdout)
                    guide.write_text(original)
        guide = self.root / 'axiarch-prompts/en/develop/safe_upgrade_execute.md'
        guide.write_text(guide.read_text().replace(f'/tags/v{version}.tar.gz', '/tags/v0.0.0.tar.gz'))
        result = subprocess.run(['bash', '-c', script], cwd=self.root, env=env,
                                capture_output=True, text=True, timeout=15)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('Tag-pinned source mismatch', result.stdout)

    def test_development_health_preserves_stable_pins_and_rejects_drift(self):
        manifest, stable = self.release_fixture()
        original_build = manifest['axiarchVersion']
        build = original_build if original_build.endswith('-dev') else stable + '-dev'
        manifest['axiarchVersion'] = build
        (self.root / 'axiarch-manifest.json').write_text(json.dumps(manifest))
        init = self.root / 'init.sh'
        init.write_text(init.read_text().replace(f'AXIARCH_VERSION="{original_build}"', f'AXIARCH_VERSION="{build}"'))
        guide = self.root / 'llms-full.txt'
        guide.write_text(guide.read_text().replace(f'Current Release: {original_build}', f'Current Release: {build}'))
        changelog = self.root / 'CHANGELOG.md'
        if '## [Unreleased]' not in changelog.read_text():
            changelog.write_text('## [Unreleased]\n\n' + changelog.read_text())
        # Run the actual health metadata block, without unrelated hook/Git checks.
        health = (SCRIPTS / 'check-axiarch-health.sh').read_text()
        block = health.split('  release_version_mismatch=0\n', 1)[1].split('    blueprint_index_mismatch=0\n', 1)[0]
        script = ('set -euo pipefail\nprint_warn() { echo "$*"; }; print_info() { :; }; print_pass() { :; };\n'
                  'release_version_mismatch=0\n' + block + 'fi\ntest "$release_version_mismatch" -eq 0\n')
        def run():
            return subprocess.run(['bash', '-c', script], cwd=self.root,
                                  env=dict(self.env, PROJECT_DIR=str(self.root)),
                                  capture_output=True, text=True, timeout=15)
        result = run()
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        mutations = [('README.md', f'AXIARCH_REF=tags/v{stable}', 'AXIARCH_REF=tags/v0.0.0'),
                     ('ROADMAP.md', f'Current Stable**: v{stable}', 'Current Stable**: v0.0.0'),
                     ('llms-full.txt', f'Latest Stable: {stable}', f'Latest Stable: {build}'),
                     ('llms-full.txt', f'Current Release: {build}', f'Current Release: {stable}'),
                     ('axiarch-manifest.json', build, '0.0.0-dev'),
                     ('CHANGELOG.md', '## [Unreleased]', '## Development')]
        for name, old, replacement in mutations:
            with self.subTest(path=name, field=old):
                path = self.root / name; original = path.read_text()
                self.assertIn(old, original)
                path.write_text(original.replace(old, replacement))
                self.assertNotEqual(run().returncode, 0)
                path.write_text(original)

    def test_unreleased_workflow_skips_tagging(self):
        workflow = (ROOT / '.github/workflows/release.yml').read_text()
        step = workflow.split('      - name: Extract latest version from CHANGELOG.md\n', 1)[1]
        script = textwrap.dedent(step.split('        run: |\n', 1)[1].split('\n      - name:', 1)[0])
        (self.root / 'CHANGELOG.md').write_text('## [Unreleased]\n\n## [1.0.0]\n')
        output = self.root / 'github-output'
        result = subprocess.run(['bash', '-c', script], cwd=self.root,
                                env=dict(self.env, GITHUB_OUTPUT=str(output)),
                                capture_output=True, text=True, timeout=15)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(output.read_text(), 'skip=true\n')

    def test_prompt_instructions_inside_fences_are_checked(self):
        prompt = (ROOT / 'axiarch-prompts/en/develop/feature_development.md').read_text()
        self.assertEqual(inspect_prompt(prompt), [])
        for old in ('Ack Only', 'Stop & Wait', 'Override Power', '/tmp/axiarch-upgrade.sh'):
            with self.subTest(instruction=old):
                broken = prompt.replace('# Phase 0:', old + '\n# Phase 0:', 1)
                self.assertIn('obsolete prompt instruction: ' + old, inspect_prompt(broken))
        broken = prompt.replace('Read `AXIARCH.md`', 'All files under `axiarch-rules/` must be read.\nRead `AXIARCH.md`', 1)
        self.assertIn('unconditional whole-rule loading in prompt', inspect_prompt(broken))
        self.assertTrue(inspect_prompt(prompt.replace('axiarch-rules/{lang}/LOADING_PROTOCOL.md', 'INDEX.md')))

    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(prefix="axiarch-consistency-")
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        self.env = {k: v for k, v in os.environ.items()
                    if not k.startswith(("AXIARCH_", "CLAUDE_", "CODEX_", "GITHUB_", "GH_", "GIT_"))}
        self.env.update(CLAUDE_PROJECT_DIR=str(self.root), AXIARCH_REMINDER_TTL_SECONDS="0")

    def log(self, text, lang="en"):
        path = self.root / f"axiarch-rules/{lang}/blueprint/core/010_project_lessons_log.md"
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text)
        return path

    def entry(self, stamp="2026-09-11", domain="DB/Auth", folder="core"):
        return f"### [{stamp}] Observed issue\n**Domain:** {domain}\n**Target Folder:** blueprint/{folder}/\n"

    def run_script(self, name, data="", rc=0):
        result = subprocess.run(["bash", SCRIPTS / name], input=data, capture_output=True,
                                text=True, cwd=self.root, env=self.env, timeout=30)
        self.assertEqual(result.returncode, rc, result.stdout + result.stderr)
        return result.stdout

    def test_quoted_and_fenced_templates_are_not_real_lessons(self):
        text = "## Unsorted Lessons\n> ### [YYYY-MM-DD] Title\n> **Domain:** Example\n```md\n" + self.entry() + "```\n"
        path = self.log(text)
        report = inspector.lessons(path, date(2026, 9, 11), 180)
        self.assertEqual(report["entries"], [])
        self.assertEqual(report["issues"], [])

    def test_unfilled_real_entries_cannot_look_clean(self):
        for text in ("### [YYYY-MM-DD] Title\n", "### [2026-09-11] Title\nDomain: X\n",
                     "### [2026-09-11] Title\nTarget Folder: blueprint/core/\n"):
            with self.subTest(text=text):
                report = inspector.lessons(self.log("## Unsorted Lessons\n" + text), date(2026, 9, 11), 180)
                self.assertTrue(report["issues"])

    def test_nested_short_or_opposite_fences_do_not_expose_example_lessons(self):
        for inner in ("```", "~~~", "````not-a-closing-fence"):
            with self.subTest(inner=inner):
                path = self.log("## Unsorted Lessons\n````md\n" + inner + "\n" + self.entry() * 3 + "````\n")
                self.assertEqual(inspector.lessons(path, date(2026, 9, 11), 180)["entries"], [])
        path = self.log("## Unsorted Lessons\n<!--\n" + self.entry() * 3 + "-->\n")
        self.assertEqual(inspector.lessons(path, date(2026, 9, 11), 180)["entries"], [])

    def test_missing_symlinked_or_cross_language_lesson_state_needs_review(self):
        path = self.log("## Unsorted Lessons\n" + self.entry())
        path.unlink()
        self.assertTrue(inspector.inspect_lessons(self.root, 180)[0]["issues"])
        outside = self.root / "external.md"
        outside.write_text("## Unsorted Lessons\n")
        path.symlink_to(outside)
        self.assertTrue(inspector.inspect_lessons(self.root, 180)[0]["issues"])
        path.unlink()
        path.write_text("## Unsorted Lessons\n" + self.entry().replace("blueprint/core/", "axiarch-rules/ja/blueprint/core/"))
        self.log("## 未分類の教訓\n", "ja")
        report = inspector.inspect_lessons(self.root, 180, date(2026, 9, 11))[1]
        self.assertIn("this log's language", " ".join(report["issues"]))

    def test_english_entries_are_checked_when_japanese_is_empty(self):
        self.log("## 未分類の教訓\n", "ja")
        self.log("## Unsorted Lessons\n" + self.entry() * 3, "en")
        reports = inspector.inspect_lessons(self.root, 180, date(2026, 9, 11))
        self.assertEqual(len(reports), 2)
        self.assertFalse(reports[0]["issues"])
        self.assertIn("DB/Auth: 3", " ".join(reports[1]["issues"]))

    def test_age_boundary_and_invalid_dates(self):
        today = date(2026, 9, 11)
        for days, expected in ((179, False), (180, True), (181, True), (-1, True)):
            with self.subTest(days=days):
                path = self.log("## Unsorted Lessons\n" + self.entry(str(today - timedelta(days=days))))
                report = inspector.lessons(path, today, 180)
                self.assertEqual(bool(report["issues"]), expected)
        path = self.log("## Unsorted Lessons\n" + self.entry("bad-date"))
        self.assertIn("invalid lesson date", " ".join(inspector.lessons(path, today, 180)["issues"]))

    def test_legacy_combined_tags_and_unknown_format_are_honest(self):
        path = self.log("### [2026-09-11] Observed\nDomain: DB/Auth | Target Folder: blueprint/core/\n")
        report = inspector.lessons(path, date(2026, 9, 11), 180)
        self.assertEqual(report["entries"][0]["domain"], "DB/Auth")
        self.assertTrue(report["notes"])
        self.assertFalse(report["issues"])

    def test_dynamic_folder_numbers_and_missing_target(self):
        folder = self.root / "axiarch-rules/en/blueprint/research"
        folder.mkdir(parents=True)
        for prefix in ("000", "100", "599", "999"):
            (folder / f"{prefix}_study.md").write_text("observed finding")
        self.assertEqual(len(list(inspector.blueprint_files(self.root))), 4)
        self.log("## Unsorted Lessons\n" + self.entry(folder="missing"))
        report = inspector.inspect_lessons(self.root, 0, date(2026, 9, 11))[0]
        self.assertIn("does not exist", " ".join(report["issues"]))

    def test_hook_reports_review_hint_not_a_loaded_or_violation_verdict(self):
        shutil.copytree(SCRIPTS, self.root / "axiarch-scripts")
        self.log("## Unsorted Lessons\n")
        result = self.run_script("axiarch-boot-reminder.sh", json.dumps({"prompt": "review security", "session_id": "s1"}))
        message = json.loads(result)["hookSpecificOutput"]["additionalContext"]
        self.assertIn("[LOAD REVIEW]", message)
        self.assertIn("not proof", message)
        self.assertNotIn("[VIOLATION-", message)
        self.assertNotIn("[LOADED]", message)
        self.assertFalse((self.root / "task.md").exists())

    def test_missing_helper_does_not_claim_or_create_shared_scaffold(self):
        result = self.run_script("axiarch-init-task-md.sh", json.dumps({"session_id": "s1"}))
        message = json.loads(result)["hookSpecificOutput"]["additionalContext"]
        self.assertIn("unavailable", message)
        self.assertNotIn("SCAFFOLD CREATED", message)
        self.assertFalse((self.root / "task.md").exists())

    def test_local_link_checker_rejects_missing_file_anchor_and_language(self):
        (self.root / "README.md").write_text("# Test\n[ok](#test)\n[bad](missing.md)\n[bad](#absent)\n")
        folder = self.root / "axiarch-rules/ja"
        folder.mkdir(parents=True)
        (folder / "only.md").write_text("# Single language\n")
        errors = inspect_docs(self.root)
        self.assertEqual(len(errors), 3)
        self.assertEqual(anchors("# Repeat\n# Repeat\n"), {"repeat", "repeat-1"})

    def test_document_titles_images_reference_targets_and_japanese_levels(self):
        (self.root / "README.md").write_text('# Test\n[bad](missing.md "title")\n![image](missing.png)\n'
                                             '[ref]: <absent file.md> "title"\n')
        folder = self.root / "axiarch-harness/ja"
        folder.mkdir(parents=True)
        (folder / "TASK_STATE_PROTOCOL.md").write_text("ハーネスL0の記録\n")
        errors = inspect_docs(self.root)
        self.assertEqual(len(errors), 5)
        self.assertTrue(any("obsolete harness" in e for e in errors))

    def test_unresolved_session_does_not_borrow_shared_load_history(self):
        shutil.copytree(SCRIPTS, self.root / "axiarch-scripts")
        (self.root / "task.md").write_text("| AXIARCH.md | security |\n")
        self.log("## Unsorted Lessons\n")
        result = self.run_script("axiarch-boot-reminder.sh", json.dumps({"prompt": "security", "session_id": "unknown"}))
        context = json.loads(result)["hookSpecificOutput"]["additionalContext"]
        self.assertIn("docs=unresolved", context)
        self.assertIn("[LOAD REVIEW]", context)

    def test_source_local_links_and_language_paths(self):
        self.assertEqual(inspect_docs(ROOT), [])

    def test_duplicate_prefix_and_obsolete_validation_claim_are_detected(self):
        (self.root / "README.md").write_text("Agents are all validated through real operational use")
        for lang in ("ja", "en"):
            folder = self.root / f"axiarch-rules/{lang}/blueprint/research"
            folder.mkdir(parents=True)
            (folder / "599_first.md").write_text("# First")
            (folder / "599_second.md").write_text("# Second")
        errors = inspect_docs(self.root)
        self.assertEqual(len(errors), 3)
        self.assertTrue(any("obsolete" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
