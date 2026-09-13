"""Behavioral regressions run against temporary adopters, without network or secrets."""
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import time
import unittest

ROOT = Path(__file__).resolve().parents[1]
SCRIPTS = ROOT / "axiarch-scripts"


def cleanup_fixture(temporary):
    try:
        temporary.cleanup()
    except OSError as error:
        # Preserve the failure and report bounded metadata, never file contents
        # or files reached through symlinks outside this synthetic fixture.
        entries = []
        for directory, folders, files in os.walk(temporary.name, followlinks=False):
            for name in sorted(folders + files):
                entries.append(os.path.relpath(os.path.join(directory, name), temporary.name))
                if len(entries) == 100:
                    break
            if len(entries) == 100:
                break
        print('FIXTURE_CLEANUP_ERROR ' + json.dumps(
            {'errno': error.errno, 'remaining_paths': entries, 'limit': 100}), file=sys.stderr)
        raise


class RuntimeTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(prefix="axiarch-test-")
        self.addCleanup(cleanup_fixture, self.tmp)
        self.root = Path(self.tmp.name).resolve()
        self.target = self.root / "adopter"
        self.target.mkdir()
        self.env = {k: v for k, v in os.environ.items()
                    if not k.startswith(("AXIARCH_", "CLAUDE_", "CODEX_", "GITHUB_", "GH_", "GIT_"))}
        self.env.update(PYTHONDONTWRITEBYTECODE="1", GIT_CONFIG_GLOBAL="/dev/null", GIT_CONFIG_NOSYSTEM="1")

    def run_cmd(self, command, text="", expected=0, cwd=None, env=None):
        result = subprocess.run([str(s) for s in command], input=text, capture_output=True,
                                text=True, cwd=cwd or self.target, env=env or self.env, timeout=90)
        if expected is not None:
            self.assertEqual(result.returncode, expected, result.stdout + result.stderr)
        return result

    def git(self, *args, **kwargs):
        # A commit can return while automatic maintenance still writes .git.
        # Keep maintenance enabled but join it before inspecting or deleting
        # fixtures. The gc fallback also covers older Git versions.
        return self.run_cmd(['git', '-c', 'maintenance.autoDetach=false',
                             '-c', 'gc.autoDetach=false', *args], **kwargs)

    def state(self, *args, **kwargs):
        return self.run_cmd(["bash", SCRIPTS / "axiarch-task-state.sh", "--project", self.target, *args], **kwargs)

    def boot(self, session="s1", task="t1", mode="session-start"):
        return self.state("--mode", mode, "--session", session, "--task", task, "--owner", "tester")

    def state_file(self, task="t1"):
        return self.target / f".axiarch/tasks/{task}/state.json"

    def session_docs(self, session="s1"):
        return self.target / f".axiarch/sessions/{session}"

    def ref(self, path):
        return {"path": path, "sha256": hashlib.sha256((self.target / path).read_bytes()).hexdigest()}

    def candidate(self, done=False):
        record = json.loads(self.state_file().read_text())
        record.update(goal="Preserve adopter data", owner="tester", phase="active")
        (self.target / "subject.txt").write_text("subject\n")
        (self.target / "verification.txt").write_text("verified output\n")
        record["criteria"] = [{"id": "G1", "owner": "tester", "description": "Original data remains",
                               "verification": "compare bytes", "state": "done" if done else "in_progress",
                               "verified": done, "checked_at": datetime.now(timezone.utc).isoformat() if done else None,
                               "target": self.ref("subject.txt") if done else None,
                               "evidence": [self.ref("verification.txt")] if done else []}]
        return record

    def publish(self, record, expected=0, revision=None, session="s1"):
        path = self.root / (session + "-candidate.json")
        path.write_text(json.dumps(record))
        return self.state("--mode", "publish", "--session", session, "--input", path,
                          "--expected-revision", str(record["revision"] if revision is None else revision), expected=expected)

    def finish_docs(self):
        for name in ("task.md", "implementation_plan.md", "walkthrough.md"):
            (self.session_docs() / name).write_text("# Reviewed evidence\n\nChecked the required scope and result.\n")

    def test_session_resume_and_independent_task_preserve_records(self):
        (self.target / "task.md").write_text("legacy active work\n")
        self.boot()
        doc = self.session_docs() / "task.md"
        doc.write_text("ongoing work\n")
        self.boot(mode="resume")
        self.assertEqual(doc.read_text(), "ongoing work\n")
        self.boot("s2", "t2")
        self.assertEqual(doc.read_text(), "ongoing work\n")
        self.assertEqual((self.target / "task.md").read_text(), "legacy active work\n")
        self.state("--mode", "new", "--session", "s3", "--task", "t1", expected=2)
        self.boot("s4", "t1", mode="resume")
        self.assertTrue(self.state_file().exists())
        self.state("--mode", "resume", "--task", "absent", expected=2)
        self.state("--mode", "session-start", "--session", "s1", "--task", "t2", expected=2)

    def test_session_listing_uses_goal_without_renaming_or_writing(self):
        self.boot()
        self.publish(self.candidate())
        self.boot("s2", "t1", mode="resume")
        before = self.tree_bytes()
        rows = [json.loads(row) for row in self.state("--mode", "sessions").stdout.splitlines()]
        self.assertEqual([row["session_id"] for row in rows], ["s1", "s2"])
        self.assertTrue(all(row["goal"] == "Preserve adopter data" for row in rows))
        self.assertEqual(rows[0]["docs"], ".axiarch/sessions/s1")
        status = json.loads(self.state("--mode", "status").stdout)
        self.assertEqual(status["goal"], "Preserve adopter data")
        self.assertEqual(before, self.tree_bytes())

    def test_session_listing_rejects_invalid_binding_and_external_link(self):
        self.boot()
        binding = self.session_docs() / "binding.json"
        valid = binding.read_bytes()
        binding.write_text('{"session_id":"s1","task_id":"../outside"}')
        self.state("--mode", "sessions", expected=2)
        binding.unlink()
        outside = self.root / "outside.json"; outside.write_bytes(valid)
        binding.symlink_to(outside)
        self.state("--mode", "sessions", expected=2)
        self.assertEqual(outside.read_bytes(), valid)

    def test_concurrent_sessions_and_compare_and_swap(self):
        def start(i):
            for attempt in range(20):
                result = self.state("--mode", "session-start", "--session", f"s{i}", "--task", "t1", expected=None)
                if result.returncode == 0:
                    return result
                self.assertIn("busy", result.stderr)
            self.fail("lock did not become available")
        with ThreadPoolExecutor(max_workers=4) as pool:
            list(pool.map(start, range(1, 5)))
        self.assertEqual(len(list((self.target / ".axiarch/sessions").iterdir())), 4)
        stale = self.candidate()
        self.publish(stale)
        self.publish(stale, expected=2, session="s2")
        self.assertEqual(json.loads(self.state_file().read_text())["revision"], 1)
        self.assertTrue((self.state_file().parent / "history/0.json").exists())

    def test_draft_readiness_and_completion_are_distinct(self):
        self.boot()
        self.state("--mode", "check", "--task", "t1")
        self.state("--mode", "check", "--task", "t1", "--phase", "readiness", expected=2)
        self.state("--mode", "check", "--session", "s1", "--phase", "completion", expected=2)
        self.publish(self.candidate())
        self.state("--mode", "check", "--task", "t1", "--phase", "readiness")
        self.state("--mode", "check", "--session", "s1", "--phase", "completion", expected=2)

    def test_complete_requires_filled_docs_and_current_evidence(self):
        self.boot()
        record = self.candidate(done=True)
        record["phase"] = "complete"
        self.publish(record, expected=2)
        self.finish_docs()
        self.publish(record)
        self.state("--mode", "check", "--session", "s1", "--phase", "completion")
        (self.target / "subject.txt").write_text("changed after verification")
        self.state("--mode", "check", "--task", "t1", "--phase", "completion", expected=2)

    def test_invalid_completion_claims(self):
        self.boot()
        mutations = [lambda c: c.update(evidence=[]), lambda c: c.update(verified=False),
                     lambda c: c.update(checked_at=None), lambda c: c.update(checked_at="2000-01-01T00:00:00Z"),
                     lambda c: c.update(owner=""), lambda c: c.update(description="_(fill in)_"),
                     lambda c: c.update(state="unknown"), lambda c: c.update(target={"path": "../outside", "sha256": "a" * 64})]
        for mutate in mutations:
            with self.subTest(mutation=mutate):
                record = self.candidate(done=True)
                mutate(record["criteria"][0])
                self.publish(record, expected=2)
        record = self.candidate()
        record["criteria"][0]["evidence"] = [self.ref("verification.txt")]
        self.publish(record, expected=2)

    def test_historical_structure_is_not_a_current_completion_claim(self):
        self.boot()
        record = self.candidate(done=True)
        record["phase"] = "complete"
        self.finish_docs()
        self.publish(record)
        historical = json.loads(self.state_file().read_text())
        historical["criteria"][0]["checked_at"] = "2000-01-01T00:00:00Z"
        self.state_file().write_text(json.dumps(historical))
        (self.target / "subject.txt").write_text("later work changed the subject")
        self.state("--mode", "check", "--task", "t1", "--phase", "structure")
        self.boot(mode="resume")
        self.state("--mode", "check", "--session", "s1", "--phase", "completion", expected=2)
        self.publish(historical, expected=2)

    def test_mismatched_or_symlinked_records_cannot_resume(self):
        self.boot()
        original = self.state_file().read_bytes()
        state = json.loads(original)
        state["task_id"] = "another-task"
        self.state_file().write_text(json.dumps(state))
        self.state("--mode", "resume", "--task", "t1", "--session", "s2", expected=2)
        self.assertFalse(self.session_docs("s2").exists())
        self.state("--mode", "status", expected=2)
        self.state_file().unlink()
        outside = self.root / "foreign-state.json"
        outside.write_bytes(original)
        self.state_file().symlink_to(outside)
        self.state("--mode", "resume", "--task", "t1", "--session", "s1", expected=2)
        self.state("--mode", "status", expected=2)
        self.assertEqual(outside.read_bytes(), original)

    def test_unverified_target_and_foreign_completion_docs_are_rejected(self):
        self.boot()
        record = self.candidate()
        record["criteria"][0]["target"] = self.ref("subject.txt")
        self.publish(record, expected=2)
        self.boot("s2", "t2")
        record = self.candidate(done=True)
        self.finish_docs()
        self.publish(record)
        record = json.loads(self.state_file().read_text())
        record["updated_by"] = "s2"
        self.state_file().write_text(json.dumps(record))
        for name in ("task.md", "implementation_plan.md", "walkthrough.md"):
            (self.session_docs("s2") / name).write_text("Reviewed a different task")
        result = self.state("--mode", "check", "--task", "t1", "--phase", "completion", expected=2)
        self.assertIn("not bound", result.stderr)

    def test_malformed_json_shapes_fail_without_publishing_or_tracebacks(self):
        self.boot()
        self.publish(self.candidate())
        before = self.state_file().read_bytes()
        for value in ([], None, {"criteria": ["malformed"]}):
            with self.subTest(value=value):
                path = self.root / "malformed.json"
                path.write_text(json.dumps(value))
                result = self.state("--mode", "publish", "--session", "s1", "--input", path,
                                    "--expected-revision", "1", expected=2)
                self.assertNotIn("Traceback", result.stderr)
                self.assertEqual(self.state_file().read_bytes(), before)
        record = self.candidate(done=True)
        record["criteria"].append(dict(record["criteria"][0]))
        self.publish(record, expected=2)

    def test_legacy_import_is_copy_and_ids_cannot_escape(self):
        (self.target / "task.md").write_text("legacy evidence")
        self.state("--mode", "new", "--task", "t1", "--session", "s1", "--import-legacy")
        self.assertIn("legacy evidence", (self.session_docs() / "task.md").read_text())
        self.assertEqual((self.target / "task.md").read_text(), "legacy evidence")
        self.state("--mode", "new", "--task", "../escape", expected=2)
        self.state("--mode", "render", expected=2)

    def test_session_hook_and_reminder_resolve_same_session(self):
        shutil.copytree(SCRIPTS, self.target / "axiarch-scripts", ignore=shutil.ignore_patterns("__pycache__"))
        self.env["CLAUDE_PROJECT_DIR"] = str(self.target)
        output = self.run_cmd(["bash", self.target / "axiarch-scripts/axiarch-init-task-md.sh"],
                              text=json.dumps({"session_id": "hook-session"})).stdout
        self.assertIn("hook-session", json.loads(output)["hookSpecificOutput"]["additionalContext"])
        doc = self.session_docs("hook-session") / "task.md"
        doc.write_text("# Evidence\n\n| AXIARCH.md | loaded | task |\n")
        out = self.run_cmd(["bash", self.target / "axiarch-scripts/axiarch-boot-reminder.sh"],
                           text=json.dumps({"session_id": "hook-session", "prompt": "continue"})).stdout
        context = json.loads(out)["hookSpecificOutput"]["additionalContext"]
        self.assertIn(str(doc.parent), context)
        self.assertNotIn("VIOLATION-A", context)

    def test_write_hook_blocks_existing_allows_new(self):
        self.env["CLAUDE_PROJECT_DIR"] = str(self.target)
        (self.target / "existing.md").write_text("keep")
        for name, tool, rc in [("existing.md", "Write", 2), ("new.md", "Write", 0), ("existing.md", "Edit", 0)]:
            self.run_cmd(["bash", SCRIPTS / "axiarch-protect-antifull.sh"],
                         text=json.dumps({"tool_name": tool, "tool_input": {"file_path": name}}), expected=rc)
        self.assertEqual((self.target / "existing.md").read_text(), "keep")

    def upgrade_fixture(self, health=0):
        self.source = self.root / "source"
        self.base = self.root / "base"
        self.source.mkdir()
        (self.source / "AXIARCH.md").write_text("Project Native Language: Japanese\n")
        (self.source / "axiarch-scripts").mkdir()
        (self.source / "axiarch-scripts/check-axiarch-health.sh").write_text(f"#!/bin/bash\nexit {health}\n")
        (self.source / "core").mkdir()
        (self.source / "core/rule.md").write_text("upstream\n")
        (self.source / "local.md").write_text("example only\n")
        manifest = {"axiarchVersion": "2.0.0", "files": [
            {"path": "core", "group": "universal_rules", "owner": "axiarch", "policy": "replace"},
            {"path": "axiarch-scripts", "group": "scripts", "owner": "axiarch", "policy": "replace"},
            {"path": "local.md", "group": "blueprint_project_state", "owner": "project", "policy": "preserve"}]}
        (self.source / "axiarch-manifest.json").write_text(json.dumps(manifest))
        shutil.copytree(self.source, self.base)
        (self.target / "local.md").write_text("project specification and lessons\n")
        (self.target / "custom.txt").write_text("custom data\n")

    def upgrade(self, *args, **kwargs):
        return self.run_cmd(["bash", SCRIPTS / "axiarch-upgrade.sh", "--source", self.source,
                             "--base-source", self.base, "--target", self.target, *args], **kwargs)

    def tree_bytes(self):
        return {str(p.relative_to(self.target)): p.read_bytes() for p in self.target.rglob("*") if p.is_file()}

    def test_dry_run_and_confirmation_eof_do_not_mutate(self):
        self.upgrade_fixture()
        original = self.tree_bytes()
        self.upgrade("--dry-run")
        self.assertEqual(self.tree_bytes(), original)
        self.upgrade("--apply")
        self.assertEqual(self.tree_bytes(), original)
        self.upgrade("--interactive", "--apply")
        self.assertEqual(self.tree_bytes(), original)

    def test_upgrade_preserves_project_state_and_reports_complete(self):
        self.upgrade_fixture()
        self.upgrade("--apply", "--yes")
        self.assertEqual((self.target / "local.md").read_text(), "project specification and lessons\n")
        self.assertEqual((self.target / "custom.txt").read_text(), "custom data\n")
        result = json.loads((self.target / ".axiarch/upgrade-result.json").read_text())
        self.assertEqual(result["application"], "complete")
        self.assertEqual(result["confirmed_version"], "2.0.0")
        self.assertEqual(result["mode"], "apply")
        self.assertEqual(result["selection"], {"languages": "both", "agent": "universal", "with_prompts": False})
        version = json.loads((self.target / ".axiarch/version.json").read_text())
        self.assertEqual(version["confirmedScope"], result["selection"])
        self.upgrade("--apply", "--yes")

    def test_upgrade_health_failure_is_nonzero_and_version_not_advanced(self):
        self.upgrade_fixture(health=7)
        (self.target / ".axiarch").mkdir()
        (self.target / ".axiarch/version.json").write_text('{"version":"1.0.0"}')
        self.upgrade("--apply", "--yes", expected=4)
        result = json.loads((self.target / ".axiarch/upgrade-result.json").read_text())
        self.assertEqual(result["health"], {"status": "failed", "exit_code": 7})
        self.assertEqual(result["application"], "complete")
        self.assertEqual(json.loads((self.target / ".axiarch/version.json").read_text())["version"], "1.0.0")

    def test_modified_file_and_nested_type_conflict_are_retained(self):
        self.upgrade_fixture()
        (self.target / "core").mkdir()
        (self.target / "core/rule.md").write_text("local change\n")
        (self.source / "core/nested").mkdir()
        (self.source / "core/nested/a.md").write_text("new")
        (self.target / "core/nested").write_text("local file\n")
        self.upgrade("--apply", "--yes", expected=3)
        self.assertEqual((self.target / "core/rule.md").read_text(), "local change\n")
        self.assertEqual((self.target / "core/nested").read_text(), "local file\n")
        result = json.loads((self.target / ".axiarch/upgrade-result.json").read_text())
        self.assertTrue(result["conflicts"])
        self.assertTrue(result["pending"])
        self.assertIsNone(result["confirmed_version"])

    def test_merge_conflict_preserves_local_and_records_conflict(self):
        self.upgrade_fixture()
        manifest = {"axiarchVersion": "2.0.0", "groups": [{"id": "core_protocol", "defaultAction": "review-each"}],
                    "files": [{"path": "merge.md", "group": "core_protocol", "owner": "mixed", "policy": "review"}]}
        (self.source / "axiarch-manifest.json").write_text(json.dumps(manifest))
        for directory, value in [(self.source, "upstream"), (self.base, "base"), (self.target, "local")]:
            (directory / "merge.md").write_text(value + "\n")
        (self.target / "axiarch-scripts").mkdir()
        (self.target / "axiarch-scripts/check-axiarch-health.sh").write_text("exit 0\n")
        self.upgrade("--interactive", text="1\ny\n3\n", expected=3)
        self.assertEqual((self.target / "merge.md").read_text(), "local\n")
        self.assertIn("<<<<<<<", (self.target / ".axiarch/conflicts/merge.md").read_text())
        saved = list((self.target / ".axiarch/upgrades").glob("*/conflicts/merge.md"))
        self.assertEqual(len(saved), 1)
        conflict_bytes = saved[0].read_bytes()
        outside = self.root / "outside-merge.md"
        outside.write_text("outside content\n")
        (self.target / "merge.md").unlink()
        (self.target / "merge.md").symlink_to(outside)
        self.upgrade("--interactive", text="1\ny\n3\n", expected=5)
        self.assertEqual(outside.read_text(), "outside content\n")
        self.assertTrue((self.target / "merge.md").is_symlink())
        self.assertEqual(saved[0].read_bytes(), conflict_bytes)

    def test_fresh_install_language_and_blueprint_preservation(self):
        for language, choice in [("Japanese", "1"), ("English", "2")]:
            with self.subTest(language=language):
                destination = self.root / language
                self.run_cmd(["bash", ROOT / "init.sh", destination], text=f"{choice}\n1\n1\nn\nn\n")
                self.assertIn(f"Project Native Language: {language}", (destination / "AXIARCH.md").read_text())
                self.assertTrue((destination / "axiarch-scripts/axiarch_state.py").exists())
                self.assertTrue((destination / "axiarch-scripts/axiarch_hook.py").exists())
                self.assertTrue((destination / "axiarch-scripts/axiarch_diff.py").exists())
                self.run_cmd(["bash", destination / "axiarch-scripts/axiarch-task-state.sh", "--project", destination,
                              "--mode", "new", "--task", "install", "--session", "install"])
                title = (destination / ".axiarch/sessions/install/task.md").read_text().splitlines()[0]
                self.assertEqual(title, "# タスク" if language == "Japanese" else "# Task")
                self.run_cmd(["bash", destination / "axiarch-scripts/check-axiarch-health.sh", destination, "--quiet"])
                unfinished = self.run_cmd(["bash", destination / "axiarch-scripts/check-axiarch-health.sh", destination,
                                           "--phase", "completion", "--session", "install"], expected=1)
                self.assertNotIn("No blocking automated check failures", unfinished.stdout)
                # Existing installer EOF must not replace adopter specifications.
                overview = destination / "axiarch-rules/ja/blueprint/core/000_project_overview.md"
                overview.write_text("adopter owned")
                lessons = destination / "axiarch-rules/ja/blueprint/core/010_project_lessons_log.md"
                lessons.write_text("adopter lessons")
                custom = destination / "axiarch-rules/ja/blueprint/core/123_custom.md"
                custom.write_text("adopter custom rules")
                extra = destination / "axiarch-rules/en/blueprint/research/599_custom.md"
                extra.parent.mkdir(parents=True)
                extra.write_text("approved additional category")
                preserved = {p: p.read_bytes() for p in (overview, lessons, custom, extra,
                             destination / ".axiarch/sessions/install/task.md",
                             destination / ".axiarch/tasks/install/state.json")}
                upgraded = self.run_cmd(["bash", SCRIPTS / "axiarch-upgrade.sh", "--source", ROOT,
                                        "--base-source", ROOT, "--target", destination, "--apply", "--yes"], expected=None)
                self.assertIn(upgraded.returncode, (0, 3), upgraded.stdout + upgraded.stderr)
                for path, original in preserved.items():
                    self.assertEqual(path.read_bytes(), original)
                outcome = json.loads((destination / ".axiarch/upgrade-result.json").read_text())
                self.assertEqual(outcome["health"]["status"], "passed")
                self.run_cmd(["bash", ROOT / "init.sh", destination], expected=None)
                self.assertEqual(overview.read_text(), "adopter owned")

    def test_fallback_upgrade_discovers_additional_blueprint_categories(self):
        self.upgrade_fixture()
        # A legacy manifest without a files array selects embedded defaults.
        (self.source / "axiarch-manifest.json").write_text('{"axiarchVersion":"2.0.0"}')
        folder = self.target / "axiarch-rules/en/blueprint/research"
        folder.mkdir(parents=True)
        for prefix in ("000", "100", "599", "999"):
            (folder / f"{prefix}_research.md").write_text("adopter observation\n")
        guide = self.source / "axiarch-rules/en/blueprint/research/README.md"
        guide.parent.mkdir(parents=True)
        guide.write_text("A newly distributed category guide\n")
        original = {p: p.read_bytes() for p in folder.iterdir()}
        result = self.upgrade("--safe-only", "--apply", "--yes", expected=None)
        self.assertEqual(result.returncode, 5, result.stdout + result.stderr)
        for p, contents in original.items():
            self.assertEqual(p.read_bytes(), contents)
        self.assertEqual((folder / "README.md").read_bytes(), guide.read_bytes())
        action_log = next((self.target / ".axiarch/upgrades").glob("*/actions.log")).read_text()
        for p in original:
            self.assertIn(str(p.relative_to(self.target)), action_log)

    def test_release_uses_same_revision_quality_workflow(self):
        release = (ROOT / ".github/workflows/release.yml").read_text()
        lint = (ROOT / ".github/workflows/lint.yml").read_text()
        self.assertIn("uses: ./.github/workflows/lint.yml", release)
        self.assertIn("needs: quality", release)
        self.assertIn("needs.quality.result == 'success'", release)
        self.assertIn("workflow_call:", lint)
        self.assertIn("unittest discover -s tests", lint)
        self.assertNotIn("continue-on-error:", lint)
        self.assertIn('test "$(git rev-parse HEAD)" = "$GITHUB_SHA"', release)
        self.assertIn("git verify-tag", release)

    def test_lock_is_released_after_writer_termination(self):
        self.boot()
        lock_path = self.target / ".axiarch/task-state.lock"
        process = subprocess.Popen([sys.executable, "-c",
                                    "import fcntl,sys,time; f=open(sys.argv[1],'a'); "
                                    "fcntl.flock(f,fcntl.LOCK_EX); print('ready',flush=True); time.sleep(60)", str(lock_path)],
                                   stdout=subprocess.PIPE, text=True, env=self.env)
        try:
            self.assertEqual(process.stdout.readline().strip(), "ready")
            result = self.state("--mode", "resume", "--task", "t1", "--session", "s1", expected=2)
            self.assertIn("busy", result.stderr)
        finally:
            process.terminate()
            process.wait(timeout=5)
            process.stdout.close()
        self.boot(mode="resume")
        self.state("--project", self.root / "missing", "--mode", "new", expected=2)

    def test_modified_evidence_and_frozen_goal_are_rejected(self):
        self.boot()
        record = self.candidate(done=True)
        self.publish(record)
        (self.target / "verification.txt").write_text("changed evidence")
        self.state("--mode", "check", "--task", "t1", "--phase", "readiness", expected=2)
        record = self.candidate()
        record["goal"] = "Different goal"
        self.publish(record, expected=2)
        record["scope_change"] = {"reason": "Updated requested scope", "approval_ref": "owner message in local plan"}
        self.publish(record)
        record = json.loads(self.state_file().read_text())
        record.update(phase="draft", goal="", criteria=[])
        self.publish(record, expected=2)

    def test_unknown_base_file_symlink_and_top_level_type_conflict(self):
        self.upgrade_fixture()
        shutil.rmtree(self.base / "core")
        (self.target / "core").mkdir()
        (self.target / "core/rule.md").write_text("unknown local base")
        outside = self.root / "outside"
        outside.write_text("untouched")
        (self.source / "core/link.md").write_text("upstream")
        (self.target / "core/link.md").symlink_to(outside)
        self.upgrade("--apply", "--yes", expected=5)
        self.assertEqual(outside.read_text(), "untouched")
        self.assertEqual((self.target / "core/rule.md").read_text(), "unknown local base")
        # Unsafe nested links are now rejected before preview, confirmation or writes.
        self.assertFalse((self.target / ".axiarch/upgrade-result.json").exists())

    def test_upgrade_rerun_after_health_fix_and_backup(self):
        self.upgrade_fixture(health=9)
        self.upgrade("--apply", "--yes", expected=4)
        (self.source / "axiarch-scripts/check-axiarch-health.sh").write_text("exit 0\n")
        self.upgrade("--apply", "--yes")
        results = list((self.target / ".axiarch/upgrades").glob("*/result.json"))
        self.assertEqual(len(results), 2)
        backups = list((self.target / ".axiarch/upgrades").glob("*/backup/axiarch-scripts/check-axiarch-health.sh"))
        self.assertEqual(len(backups), 1)
        self.assertIn("exit 9", backups[0].read_text())

    def test_unavailable_diagnosis_cannot_pass(self):
        self.upgrade_fixture()
        (self.source / "axiarch-scripts/check-axiarch-health.sh").unlink()
        self.upgrade("--apply", "--yes", expected=4)
        result = json.loads((self.target / ".axiarch/upgrade-result.json").read_text())
        self.assertEqual(result["health"]["status"], "unavailable")

    def test_missing_required_source_is_not_reported_as_unchanged(self):
        self.upgrade_fixture()
        shutil.rmtree(self.source / "core")
        self.upgrade("--apply", "--yes", expected=5)
        result = json.loads((self.target / ".axiarch/upgrade-result.json").read_text())
        self.assertIn("WARN source missing core", result["failed"])
        self.assertIsNone(result["confirmed_version"])

    def test_manifest_traversal_is_rejected_before_preview_or_application(self):
        self.upgrade_fixture()
        outside = self.root / "outside.md"
        outside.write_text("outside private content must never appear in a diff")
        manifest = {"axiarchVersion": "2.0.0", "files": [
            {"path": "../outside.md", "group": "core_protocol", "owner": "mixed", "policy": "review"}]}
        (self.source / "axiarch-manifest.json").write_text(json.dumps(manifest))
        before = self.tree_bytes()
        result = self.upgrade("--interactive", text="4\nn\n", expected=5)
        self.assertNotIn(outside.read_text(), result.stdout + result.stderr)
        self.assertEqual(self.tree_bytes(), before)
        self.upgrade("--apply", "--yes", expected=5)
        self.assertEqual(self.tree_bytes(), before)

    def test_empty_selection_does_not_promote_version(self):
        self.upgrade_fixture()
        path = self.source / "axiarch-manifest.json"
        manifest = json.loads(path.read_text())
        manifest["files"] = []
        path.write_text(json.dumps(manifest))
        before = self.tree_bytes()
        result = self.upgrade("--apply", "--yes")
        self.assertIn("No paths selected", result.stdout)
        self.assertEqual(self.tree_bytes(), before)

    def test_upgrade_metadata_symlinks_do_not_write_outside_target(self):
        self.upgrade_fixture()
        outside = self.root / "outside"
        outside.mkdir()
        (self.target / ".axiarch").mkdir()
        (self.target / ".axiarch/upgrades").symlink_to(outside, target_is_directory=True)
        self.upgrade("--apply", "--yes", expected=5)
        self.assertEqual(list(outside.iterdir()), [])
        self.assertFalse((self.target / "core").exists())
        (self.target / ".axiarch/upgrades").unlink()
        version = self.target / ".axiarch/version.json"
        version.write_text("[]")
        before = self.tree_bytes()
        failed = self.upgrade("--apply", "--yes", expected=5)
        self.assertNotIn("Traceback", failed.stderr)
        self.assertEqual(self.tree_bytes(), before)

    def test_upgrade_runs_with_its_starting_helpers_during_self_update(self):
        self.upgrade_fixture()
        installed = self.target / "axiarch-scripts"
        shutil.copytree(SCRIPTS, installed, ignore=shutil.ignore_patterns("__pycache__"))
        for name in ("axiarch_upgrade.py", "axiarch_state.py"):
            shutil.copy2(SCRIPTS / name, self.base / "axiarch-scripts" / name)
            (self.source / "axiarch-scripts" / name).write_text("raise RuntimeError('new helper API')\n")
        shutil.copy2(self.source / "axiarch-scripts/check-axiarch-health.sh", installed / "check-axiarch-health.sh")
        result = self.run_cmd(["bash", installed / "axiarch-upgrade.sh", "--source", self.source,
                               "--base-source", self.base, "--target", self.target, "--apply", "--yes"])
        self.assertNotIn("RuntimeError", result.stderr)
        self.assertIn("new helper API", (installed / "axiarch_upgrade.py").read_text())
        self.assertEqual(json.loads((self.target / ".axiarch/upgrade-result.json").read_text())["health"]["status"], "passed")

    def test_concurrent_upgrade_is_rejected_and_lock_recovers(self):
        self.upgrade_fixture()
        health = self.source / "axiarch-scripts/check-axiarch-health.sh"
        health.write_text('touch "$1/health-started"\nfor i in {1..400}; do\n'
                          '  [[ -f "$1/health-release" ]] && exit 0\n  sleep 0.025\ndone\nexit 8\n')
        command = ["bash", str(SCRIPTS / "axiarch-upgrade.sh"), "--source", str(self.source),
                   "--base-source", str(self.base), "--target", str(self.target), "--apply", "--yes"]
        process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, env=self.env)
        try:
            deadline = time.monotonic() + 15
            while not (self.target / "health-started").exists() and process.poll() is None and time.monotonic() < deadline:
                time.sleep(0.02)
            self.assertTrue((self.target / "health-started").exists())
            before = self.tree_bytes()
            alternate_temp = self.root / "another-session-temp"
            alternate_temp.mkdir()
            blocked = self.upgrade("--apply", "--yes", expected=6,
                                   env=dict(self.env, TMPDIR=str(alternate_temp)))
            self.assertIn("busy", blocked.stderr)
            self.assertEqual(self.tree_bytes(), before)
        finally:
            (self.target / "health-release").touch()
            stdout, stderr = process.communicate(timeout=15)
        self.assertEqual(process.returncode, 0, stdout + stderr)
        self.upgrade("--apply", "--yes")

    def test_interrupted_upgrade_records_failure_and_can_retry(self):
        self.upgrade_fixture()
        health = self.source / "axiarch-scripts/check-axiarch-health.sh"
        health.write_text('kill -TERM "$PPID"\n')
        self.upgrade("--apply", "--yes", expected=143)
        result = json.loads((self.target / ".axiarch/upgrade-result.json").read_text())
        self.assertEqual(result["application"], "failed")
        self.assertIsNone(result["confirmed_version"])
        health.write_text("exit 0\n")
        self.upgrade("--apply", "--yes")

    def test_guarded_template_retry_uses_applied_hash_and_preserves_later_edits(self):
        self.upgrade_fixture()
        manifest_path = self.source / "axiarch-manifest.json"
        manifest = json.loads(manifest_path.read_text())
        manifest["files"].append({"path": "template.md", "group": "blueprint_templates", "owner": "axiarch",
                                  "policy": "replace-if-local-unchanged"})
        manifest_path.write_text(json.dumps(manifest))
        (self.source / "template.md").write_text("first upstream template")
        (self.base / "template.md").write_text("older release")
        self.upgrade("--safe-only", "--apply", "--yes")
        (self.source / "template.md").write_text("second upstream template")
        self.upgrade("--safe-only", "--apply", "--yes")
        self.assertEqual((self.target / "template.md").read_text(), "second upstream template")
        (self.target / "template.md").write_text("adopter customization")
        (self.source / "template.md").write_text("third upstream template")
        self.upgrade("--safe-only", "--apply", "--yes", expected=3)
        self.assertEqual((self.target / "template.md").read_text(), "adopter customization")

    def test_unchanged_files_become_known_bases_for_later_upgrade(self):
        self.upgrade_fixture()
        shutil.copytree(self.source / "core", self.target / "core")
        shutil.rmtree(self.base / "core")
        self.upgrade("--apply", "--yes")
        hashes = (self.target / ".axiarch/files.sha256").read_text()
        self.assertIn("  core/rule.md", hashes)
        (self.source / "core/rule.md").write_text("new upstream content\n")
        self.upgrade("--apply", "--yes")
        self.assertEqual((self.target / "core/rule.md").read_text(), "new upstream content\n")

    def test_runtime_contract_is_distributed_in_both_languages(self):
        manifest = json.loads((ROOT / "axiarch-manifest.json").read_text())
        by_path = {item["path"]: item for item in manifest["files"]}
        self.assertEqual(by_path["axiarch-scripts"]["owner"], "axiarch")
        self.assertEqual(by_path["tests"]["policy"], "skip")
        for lang in ("ja", "en"):
            protocol = ROOT / f"axiarch-harness/{lang}/TASK_STATE_PROTOCOL.md"
            self.assertTrue(protocol.is_file())
            loader = (ROOT / f"axiarch-rules/{lang}/LOADING_PROTOCOL.md").read_text()
            self.assertIn("300_goal_and_current_state.md", loader)
            self.assertIn("TASK_STATE_PROTOCOL.md", loader)
            core = (ROOT / f"axiarch-rules/{lang}/universal/core/300_goal_and_current_state.md").read_text()
            self.assertIn("**D1**", core)
            self.assertIn("**M1:", core)
        self.assertIn("TASK_STATE_PROTOCOL.md", (ROOT / "AXIARCH.md").read_text())


if __name__ == "__main__":
    unittest.main()
