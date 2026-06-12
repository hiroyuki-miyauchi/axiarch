# 010. Release and Upgrade Operations Rules

> [!NOTE]
> This file is an Axiarch-shared Blueprint Rule crystallized in the Axiarch source repository.
> In adopter projects, review it separately from Project State only when explicitly listed in the manifest.
> It was auto-crystallized from `core/010_project_lessons_log.md`.
> Created: 2026-05-17

> [!IMPORTANT]
> **Domain**: Operations
> **Location**: `blueprint/operations/010_release_upgrade_operations.md`
> **Related Universal Rules**: `universal/operations/400_site_reliability.md`, `universal/engineering/600_git_workflow.md`
> **12 sections.**

---

## Table of Contents

| Section | Content |
|:--|:--|
| §1 | CHANGELOG reference definition parity |
| §2 | Safe Upgrade dry-runs must not write artifacts |
| §3 | Safe Upgrade interactive input separation |
| §4 | Explicit review for local-only files |
| §5 | Upgrade metadata version normalization |
| §6 | Fallback and optional prompt evidence parity |
| §7 | Runtime protection for replace-if-local-unchanged |
| §8 | Review path for file/directory type conflicts |
| §9 | Default skip and explicit selection for source-only files |
| §10 | Default N for non-interactive EOF confirmations |
| §11 | Git tracking checks for source release-critical files |
| §12 | Deduplication of interactive choices |

---

## §1 CHANGELOG Reference Definition Parity

### Context

The v1.9.0 release finalization changed the top `CHANGELOG.md` section from `[Unreleased]` to `[1.9.0]`.

### Problem

The `[Unreleased]` heading was removed, but the trailing `[Unreleased]: ...` reference definition remained, causing Markdown Lint MD053 to fail in CI.

### Rule

Keep `CHANGELOG.md` link reference definitions synchronized with actual headings. When finalizing a release and removing the `[Unreleased]` heading, also remove the `[Unreleased]: ...` definition.

### Enforcement

`axiarch-scripts/check-axiarch-health.sh` Check 15 verifies parity between the Unreleased heading and reference definition.

### Reference

`CHANGELOG.md`, `axiarch-scripts/check-axiarch-health.sh`, GitHub Actions run `25918646516`

---

## §2 Safe Upgrade Dry-Runs Must Not Write Artifacts

### Context

The v1.10.0 Safe Upgrade Wizard audit reviewed dry-run behavior for 3-way merge conflicts and upgrade metadata version recording.

### Problem

An interactive dry-run path could still write conflict files under `.axiarch/conflicts/` when a 3-way merge conflicted. Also, upgrades run with `--source` could record `local-source` in upgrade metadata instead of the source manifest version.

### Rule

Dry-runs must be limited to planning and diff inspection; they must not write conflict artifacts. Conflict files should be written only during `--apply`. When upgrading from a local source, record `axiarch-manifest.json` `axiarchVersion` in metadata so version state remains explicit.

### Enforcement

`axiarch-scripts/axiarch-upgrade.sh` reports conflicts only during dry-run and writes `.axiarch/conflicts/` only during `--apply`. With `--source`, it records the source manifest `axiarchVersion` in `.axiarch/version.json`.

### Reference

`axiarch-scripts/axiarch-upgrade.sh`, `axiarch-manifest.json`, `axiarch-scripts/README.md`

---

## §3 Safe Upgrade Interactive Input Separation

### Context

The v1.10.0 Safe Upgrade Wizard audit tested `--interactive` group choices and per-file choices through piped input.

### Problem

`collect_interactive_choices` used stdin to iterate the internal group list, so `choose_group_action` could consume internal list input instead of user input, breaking interactive choices.

### Rule

Functions that read operator choices must keep stdin separate from internal list iteration. Internal lists should use a separate file descriptor or array so user stdin remains available.

### Enforcement

`axiarch-scripts/axiarch-upgrade.sh` iterates groups through FD 3, allowing `choose_group_action` and `review_file_action` to read user stdin correctly.

### Reference

`axiarch-scripts/axiarch-upgrade.sh`, `walkthrough.md`

---

## §4 Explicit Review for Local-Only Files

### Context

Directory-based Safe Upgrade can leave target-side files that no longer exist in the source because they were deleted, moved, or created as local adopter extensions.

### Problem

Overlay copying with `cp -R` does not remove local-only files. Automatic deletion could break adopter-specific extensions, while silently leaving them can keep stale Axiarch files in future load paths.

### Rule

Do not automatically delete local-only files during directory updates. Instead, report them as `STALE-LOCAL`. In `--apply` mode, also record them in the upgrade report; in dry-run mode, do not write artifacts. Treat delete, keep, or migrate as an explicit review decision.

### Enforcement

`axiarch-scripts/axiarch-upgrade.sh` checks target-side files missing from the source before directory updates and prints them as `STALE-LOCAL`. It also records them in `ACTION_LOG`, but that log is persisted only when `--apply` writes `.axiarch/upgrade-report.md`.

### Reference

`axiarch-scripts/axiarch-upgrade.sh`, `axiarch-scripts/README.md`, `axiarch-prompts/en/develop/safe_upgrade_execute.md`

---

## §5 Upgrade Metadata Version Normalization

### Context

During the v1.10.0 Safe Upgrade Wizard audit, `--source . --to v1.10.0 --safe-only --apply` was executed against a temporary target and the generated `.axiarch/version.json` was inspected.

### Problem

`write_upgrade_metadata` preferred `TO_VERSION` over the source manifest version, so `version` was recorded as `v1.10.0`. Axiarch source release metadata uses `1.10.0` in `init.sh`, `axiarch-manifest.json`, and `CHANGELOG.md`, so upgrade metadata alone could keep a tag-style value and create version-detection ambiguity later.

### Rule

Safe Upgrade metadata must prefer the source manifest `axiarchVersion`. When only `--to vX.Y.Z` or `--ref tags/vX.Y.Z` is available, `.axiarch/version.json` must still record the normalized Axiarch internal version without the tag prefix `v`.

### Enforcement

`axiarch-scripts/axiarch-upgrade.sh` resolves metadata versions through `resolve_upgrade_version_label` and `normalize_axiarch_version_label`. `check-axiarch-health.sh` Check 15 verifies that the Safe Upgrade Wizard includes metadata version normalization wiring.

### Reference

`axiarch-scripts/axiarch-upgrade.sh`, `axiarch-scripts/check-axiarch-health.sh`, `axiarch-manifest.json`, `.axiarch/version.json`

---

## §6 Fallback and Optional Prompt Evidence Parity

### Context

During the v1.10.0 Safe Upgrade Wizard audit, the manifest fallback path used when `jq` cannot read the manifest and the `.axiarch/files.sha256` output produced by `--with-prompts --apply` were reviewed.

### Problem

The manifest's broad Project State glob covers additional numbered files under `blueprint/*/[0-9][0-9][0-9]_*.md`, including future files under `core/`. The fallback discovery path only scanned `ai/`, `design/`, `engineering/`, `operations/`, `product/`, `quality/`, and `security/`. If a future `core/{NNN}_*.md` file were added, environments without readable manifest support could miss it as Project State. Separately, when optional prompts were applied with `--with-prompts`, the hash evidence only covered `AGENTS.md`, the manifest, scripts, and rules.

### Rule

When the manifest cannot be read, fallback ownership boundaries should stay as close to the manifest as practical. Explicitly classified files such as `core/000`, `core/010`, templates, and Axiarch-shared Blueprint files like `core/020_governance_rules.md` keep their existing classifications, while additional `core/{NNN}_*.md` files that are not explicitly classified are treated as Project State. Optional prompts remain optional, but when they are applied, `.axiarch/files.sha256` must include their hashes.

### Enforcement

`axiarch-scripts/axiarch-upgrade.sh` fallback discovery scans `core` in addition to the other initial Blueprint folders. `write_upgrade_metadata` includes `axiarch-prompts/` in hash evidence when it exists. `check-axiarch-health.sh` Check 15 verifies fallback core Blueprint discovery and optional prompt evidence wiring.

### Reference

`axiarch-scripts/axiarch-upgrade.sh`, `axiarch-scripts/check-axiarch-health.sh`, `axiarch-prompts/{ja,en}/develop/safe_upgrade_execute.md`, `.axiarch/files.sha256`

---

## §7 Runtime Protection for replace-if-local-unchanged

### Context

During the v1.10.0 Safe Upgrade Wizard audit, the manifest's `replace-if-local-unchanged` policy was compared with the runtime action branches.

### Problem

The manifest defined this policy as "update automatically only when local ownership is not ambiguous; otherwise review," but the runtime had no dedicated branch for it. As a result, group-level actions such as `update-all` could treat templates or shared Blueprint rules with no base or a base mismatch as near-unconditional copies.

### Rule

`replace-if-local-unchanged` updates automatically only when the target is missing, or when a base from `--from`, `--from-ref`, or `--base-source` exists and matches the target. If the target differs and no base is available, if the matching path is missing from the base, or if the target differs from the base, fall back to review. During review, record the `no-base-diff`, `base-missing`, or `base-mismatch` reason label in the upgrade report.

### Enforcement

`axiarch-scripts/axiarch-upgrade.sh` performs this policy through `copy_replace_if_local_unchanged`. Both `safe-only` and `update-all` route this policy through the dedicated check instead of unconditional `copy_path`. `check-axiarch-health.sh` Check 15 verifies that this runtime branch and its reason labels exist.

### Reference

`axiarch-manifest.json`, `axiarch-scripts/axiarch-upgrade.sh`, `axiarch-scripts/check-axiarch-health.sh`

---

## §8 Review Path for File/Directory Type Conflicts

### Context

During the v1.10.0 Safe Upgrade Wizard audit, temporary targets were used to test source-directory-to-target-file and source-file-to-target-directory cases.

### Problem

When a source directory met a target file at the same path, an internal `mkdir -p` could fail after earlier files had already been processed, creating a partial-apply risk. When a source file met a target directory at the same path, copying could create an unintended nested file or confuse the intended structure.

### Rule

When the source and target differ between file and directory, do not delete or replace automatically. Report `TYPE-CONFLICT` for review, explain the target meaning, source structure, and migration steps, and wait for an explicit decision.

### Enforcement

`axiarch-scripts/axiarch-upgrade.sh` detects type conflicts with `copy_path_has_type_conflict` and stops before automatic copy in both normal `copy_path` handling and `replace-if-local-unchanged` handling. `check-axiarch-health.sh` Check 15 verifies that type-conflict review wiring exists.

### Reference

`axiarch-scripts/axiarch-upgrade.sh`, `axiarch-scripts/check-axiarch-health.sh`, `axiarch-prompts/en/develop/safe_upgrade_execute.md`

---

## §9 Default Skip and Explicit Selection for Source-Only Files

### Context

During the v1.10.0 Safe Upgrade Wizard audit, the `source_docs` group was compared against the interactive choice flow and runtime branch handling.

### Problem

`source_docs` contains files intended for the Axiarch source repository, so default skip is correct. However, the interactive UI allowed choices such as `show-diff` and `update-all`, while the runtime branch always let `policy=skip` win first. Even an explicit user choice could not reach diff display or application. That contradicted the Safe Upgrade operating model of choosing by group.

The Round30 audit also found that repository-management files described as not needed by adopter projects in the README, such as `CONTRIBUTING.md`, `SECURITY.md`, `CODE_OF_CONDUCT.md`, `LICENSE`, and `.github/ISSUE_TEMPLATE/`, plus the Axiarch source setup installer `init.sh`, were not all included in manifest and fallback `source_docs`. Skipping them by default was correct, but if Safe Upgrade does not classify them explicitly as source-only, adopter projects that previously copied the whole repository can miss unnecessary stale files.

### Rule

Source Repository Files are not copied into adopter projects by default. `--safe-only` and non-interactive runs keep skipping them. When `--interactive` is used and the user explicitly selects `show-diff`, `review-each`, or `update-all`, respect that selection and proceed to diff display or explicit application. Repository-management files, source-only docs, GitHub management templates described as not needed by adopter projects in the README, and the Axiarch source setup installer `init.sh` must be classified as `source_docs` / `skip` in both the manifest and fallback list.

### Enforcement

`axiarch-scripts/axiarch-upgrade.sh` normally skips `policy=skip` items, but when interactive mode selected an explicit non-skip action, it records `SOURCE-ONLY explicit-*` and proceeds to the chosen action. `check-axiarch-health.sh` Check 15 verifies that this explicit override wiring exists and that the installer and README-listed repo-only files are classified as source-only skip in both the manifest and fallback list.

### Reference

`axiarch-manifest.json`, `axiarch-scripts/axiarch-upgrade.sh`, `axiarch-scripts/check-axiarch-health.sh`, `axiarch-scripts/README.md`, `README.md`, `axiarch-prompts/en/develop/safe_upgrade_execute.md`

---

## §10 Default N for Non-Interactive EOF Confirmations

### Context

During the v1.10.0 Safe Upgrade Wizard audit, `--apply` and `--interactive` were executed with no stdin to verify confirmation prompt behavior.

### Problem

With `set -euo pipefail`, `read -r answer` or `read -r choice` exited on EOF before the wizard could treat the missing input as the default N. This was close to the desired safe-stop behavior, but it was not an explicit fallback to dry-run; CI or AI-agent execution could treat it as an unexpected failure.

### Rule

Safe Upgrade Wizard confirmation prompts must not fail only because stdin reaches EOF. Treat EOF as empty input and fall back to the default. For final `--apply` confirmation, default N must set `APPLY=false` and `DRY_RUN=true`. For the final `--interactive` confirmation, default N must also keep dry-run behavior. Non-interactive application must use explicit `--yes` only after the dry-run output has been reviewed and the human owner has explicitly approved apply.

### Enforcement

`axiarch-scripts/axiarch-upgrade.sh` handles confirmation input with `read -r answer || answer=""` and `read -r choice || choice=""`. `check-axiarch-health.sh` Check 15 verifies that the Safe Upgrade Wizard has EOF-safe confirmation defaults.

### Reference

`axiarch-scripts/axiarch-upgrade.sh`, `axiarch-scripts/check-axiarch-health.sh`, `axiarch-scripts/README.md`, `README.md`

---

## §11 Git Tracking Checks for Source Release-Critical Files

### Context

During the v1.10.0 Safe Upgrade Wizard audit, `git diff --name-only` and `git diff --stat` were confirmed not to show untracked files. This release adds `axiarch-manifest.json`, `axiarch-scripts/axiarch-upgrade.sh`, the ja/en safe-upgrade execution prompts, and the ja/en Operations Blueprint as new files.

### Problem

If new files remain untracked, tracked-diff review and release checks can miss release-critical files. In particular, missing the manifest or upgrade helper breaks the path for existing adopter projects to upgrade only the needed Axiarch parts.

### Rule

For the Axiarch source repository, release-critical files must be checked for Git tracking, not only for on-disk presence. New files required for release integrity, such as `axiarch-manifest.json`, the Safe Upgrade Wizard, safe-upgrade execution prompts, and the shared Operations Blueprint, must not pass final verification while still untracked. Do not run this check in adopter projects.

### Enforcement

`axiarch-scripts/check-axiarch-health.sh` Check 15 verifies, only inside the Axiarch source repository and a Git worktree, that the v1.10.0 release-critical files are visible to `git ls-files`. Missing or untracked files fail the health check.

### Reference

`axiarch-scripts/check-axiarch-health.sh`, `axiarch-manifest.json`, `axiarch-scripts/axiarch-upgrade.sh`, `axiarch-prompts/ja/develop/safe_upgrade_execute.md`, `axiarch-prompts/en/develop/safe_upgrade_execute.md`

---

## §12 Deduplication of Interactive Choices

### Context

During the v1.10.0 Safe Upgrade Wizard follow-up audit, the `source_docs` group was tested in `--interactive` mode while its default action was `skip`.

### Problem

`choose_group_action` displayed the default action as option 1 and also always displayed `skip` in the fixed candidate list. For groups whose default action was `skip`, the same effective action appeared under two different numbers. That made the operator choice look ambiguous and weakened the intended model: source-only files stay skipped by default, and non-default handling happens only through an explicit selection.

### Rule

Interactive group selection must not show the same effective action under multiple numbers. If option 1 is the default action, remove the same action from the fixed candidate list. Resolve numeric choices through an explicit option-to-action map or array so that changed ordering or candidate count cannot redirect user input to a different action.

### Enforcement

`axiarch-scripts/axiarch-upgrade.sh` builds `option_actions` dynamically inside `choose_group_action`, excludes fixed candidates that match the default action, and assigns numbers only after that filtering. `check-axiarch-health.sh` Check 15 verifies that the Safe Upgrade Wizard includes this dynamic interactive action map.

### Reference

`axiarch-scripts/axiarch-upgrade.sh`, `axiarch-scripts/check-axiarch-health.sh`, `task.md`, `walkthrough.md`
