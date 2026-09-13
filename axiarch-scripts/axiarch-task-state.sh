#!/usr/bin/env bash
# =============================================================================
# Axiarch Task State Lifecycle Helper
# https://github.com/hiroyuki-miyauchi/axiarch
#
# Stores Markdown per session and structured current state per task.
# Existing root evidence and legacy .axiarch/process-doc-history/ are preserved.
# Public lifecycle and validation are implemented by axiarch_state.py.
#
# Native task/plan UI note:
#   This script manages durable Markdown evidence only. It cannot write into
#   proprietary agent UI state. Agents must also call their native task/plan
#   tools when available:
#     - Codex: update_plan
#     - Claude Code: TaskCreate / TaskUpdate / TaskList / TaskGet
#       (TodoWrite only for older runtimes where Task tools are unavailable)
# =============================================================================

set -euo pipefail

PROJECT_DIR=""
MODE="session-start"
PRINT_SUMMARY=true
STATE_ARGS=()

usage() {
  cat <<'USAGE'
Usage:
  bash axiarch-scripts/axiarch-task-state.sh [--project DIR] [--mode session-start|ensure|status] [--quiet]

Modes:
  session-start: create isolated session evidence or resume its existing binding.
  new/resume:    explicitly create a task or resume --task ID (with --session ID).
  ensure:        ensure isolated evidence; never rotate shared root documents.
  status:        list shared task records without modifying them.
  privacy-check: inspect managed-artifact Git exclusions/tracking without changes.
  publish:       --input JSON --expected-revision N --session ID (compare and swap).
  check:         --task ID --phase structure|readiness|completion.
  path:          resolve --session ID to its Markdown directory.
  snapshot:      --input project-relative-file returns path and SHA-256.
  Options: --task ID --session ID --owner NAME --import-legacy
  Details: axiarch-harness/{ja,en}/TASK_STATE_PROTOCOL.md

Environment:
  AXIARCH_PROCESS_DOC_MODE=current|append
    current|append: accepted for compatibility; both preserve root documents.

  AXIARCH_PROCESS_DOC_ARCHIVE / AXIARCH_PROCESS_DOC_HISTORY_DIR
    Legacy settings retained as accepted inputs; automatic root rotation is retired.

  AXIARCH_PROCESS_DOC_LANG=auto|ja|en
    auto (default): detect Project Native Language from AXIARCH.md, then AGENTS.md fallback.
    ja/en: force Japanese or English current-task templates.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project)
      if [[ $# -lt 2 || -z "${2:-}" || "${2:-}" == --* ]]; then
        printf 'Missing value for --project\n' >&2
        usage >&2
        exit 2
      fi
      PROJECT_DIR="${2:-}"
      shift 2
      ;;
    --mode)
      if [[ $# -lt 2 || -z "${2:-}" || "${2:-}" == --* ]]; then
        printf 'Missing value for --mode\n' >&2
        usage >&2
        exit 2
      fi
      MODE="${2:-}"
      shift 2
      ;;
    --quiet)
      PRINT_SUMMARY=false
      shift
      ;;
    --task|--session|--owner|--phase|--input|--expected-revision)
      [[ $# -ge 2 ]] || { printf 'Missing value for %s\n' "$1" >&2; exit 2; }
      STATE_ARGS+=("$1" "$2")
      shift 2
      ;;
    --import-legacy)
      STATE_ARGS+=("$1")
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown argument: %s\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ -n "${PROJECT_DIR}" && ! -d "${PROJECT_DIR}" ]]; then
  printf 'Project directory does not exist: %s\n' "${PROJECT_DIR}" >&2
  exit 2
fi
if [[ -z "${PROJECT_DIR}" ]]; then
  PROJECT_DIR="${CLAUDE_PROJECT_DIR:-}"
fi
if [[ -z "${PROJECT_DIR}" || ! -d "${PROJECT_DIR}" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  PROJECT_DIR="$(dirname "${SCRIPT_DIR}")"
fi

PROCESS_DOC_MODE="${AXIARCH_PROCESS_DOC_MODE:-current}"
ARCHIVE_ENABLED="${AXIARCH_PROCESS_DOC_ARCHIVE:-1}"
PROCESS_DOC_LANG="${AXIARCH_PROCESS_DOC_LANG:-auto}"

case "${MODE}" in
  session-start|new|resume|ensure|status|publish|check|path|snapshot|render|privacy-check) ;;
  *)
    printf 'Unsupported mode: %s\n' "${MODE}" >&2
    exit 2
    ;;
esac

case "${PROCESS_DOC_MODE}" in
  current|append) ;;
  *)
    printf 'Unsupported AXIARCH_PROCESS_DOC_MODE: %s\n' "${PROCESS_DOC_MODE}" >&2
    exit 2
    ;;
esac

case "${ARCHIVE_ENABLED}" in
  1|0) ;;
  *)
    printf 'Unsupported AXIARCH_PROCESS_DOC_ARCHIVE: %s\n' "${ARCHIVE_ENABLED}" >&2
    exit 2
    ;;
esac

normalize_process_doc_lang() {
  case "$1" in
    auto|"") printf 'auto' ;;
    ja|japanese|Japanese|JAPANESE) printf 'ja' ;;
    en|english|English|ENGLISH) printf 'en' ;;
    *)
      printf 'Unsupported AXIARCH_PROCESS_DOC_LANG: %s\n' "$1" >&2
      return 2
      ;;
  esac
}

detect_project_native_language() {
  local requested
  if ! requested="$(normalize_process_doc_lang "${PROCESS_DOC_LANG}")"; then
    return 2
  fi
  if [[ "${requested}" != "auto" ]]; then
    printf '%s' "${requested}"
    return 0
  fi

  python3 "$(dirname "${BASH_SOURCE[0]}")/axiarch_state.py" --project "$PROJECT_DIR" --mode language
}

command -v python3 >/dev/null 2>&1 || { printf 'Python 3 required; existing evidence preserved.\n' >&2; exit 2; }
PROCESS_DOC_LANG_RESOLVED=ja
# Read-only status/check operations do not need to generate language-specific docs.
case "$MODE" in
  session-start|new|resume|ensure|render)
    if ! PROCESS_DOC_LANG_RESOLVED="$(detect_project_native_language)"; then exit 2; fi
    ;;
esac

# Existing template functions below are only a renderer into a fresh staging dir.
# All public operations use the locked, atomic, session-scoped store.
if [[ "${MODE}" != "render" ]]; then
  command -v python3 >/dev/null 2>&1 || { printf 'Python 3 required; existing evidence preserved.\n' >&2; exit 2; }
  if [[ "${PRINT_SUMMARY}" != "true" ]]; then STATE_ARGS+=(--quiet); fi
  exec python3 "$(dirname "${BASH_SOURCE[0]}")/axiarch_state.py" \
    --project "${PROJECT_DIR}" --lang "${PROCESS_DOC_LANG_RESOLVED}" --mode "${MODE}" "${STATE_ARGS[@]+"${STATE_ARGS[@]}"}"
fi

docs=(task.md implementation_plan.md walkthrough.md)

# Internal rendering must never overwrite even a partially prepared directory.
for doc in "${docs[@]}"; do
  if [[ -e "${PROJECT_DIR}/${doc}" || -L "${PROJECT_DIR}/${doc}" ]]; then
    printf 'Template destination already exists: %s\n' "${doc}" >&2
    exit 2
  fi
done

doc_path() {
  printf '%s/%s' "${PROJECT_DIR}" "$1"
}

write_task_md_ja() {
  cat > "$(doc_path task.md)" <<'TASKMD'
# タスク

<!-- AXIARCH_PROCESS_DOC: current-task-only -->

このファイルはセッション固有の証跡。共有現在値はタスクの `state.json` を正本とする。

## 現在のタスク

- タスク: _(ここに1行で記載)_
- タスクタイプ: _(security / architecture / performance / ui_design / api / i18n / finops / testing / other)_
- 開始日時: _(自律記録)_

## ロード済み憲法ファイル

| ファイル | ロードしたセクション | 理由 |
|:--|:--|:--|
| _(自律ロード後に追記)_ | _(§ / heading)_ | _(理由)_ |

## ロード自己検証

- [ ] `blueprint/core/000_project_overview.md` を直接開いた
- [ ] タスクタイプに対応するUniversal/Blueprintを直接開いた
- [ ] 実際に読んだファイルだけを上の表に記録した
- [ ] 関連しうるがロードしないファイルと理由を明記した

## ゴール（完了条件）

`axiarch-rules/{lang}/universal/core/300_goal_and_current_state.md` と `axiarch-harness/{lang}/TASK_STATE_PROTOCOL.md` を参照。ID・担当・状態・確認対象・時刻・証拠は `state.json` と対応させる。

| # | 完了条件 | 検証方法 | 判定 |
|:--|:--|:--|:--|
| 1 | _(観測可能な形で記述。「改善する」等の曖昧語のみは不可)_ | _(どう確かめるか)_ | _(未達成 / 達成)_ |

- 非ゴール: _(やらないことを明記)_
- 置いた仮定: _(確認せずに前提としたこと)_

## 現在値

| 状態 | 内容 |
|:--|:--|
| 完了 | _(完了条件を満たし検証済みのもの)_ |
| 進行中 | _(着手済み・未完了。担当を含む)_ |
| 未着手 | _(予定だが未着手のもの)_ |
| 破棄 | _(検討したが採らないと決めたものと理由)_ |

- 最終突合: _(いつ・何と突合したか。未突合なら「未突合」と明記)_

## ネイティブタスク状態

Markdown証跡だけでは、CodexやClaude Codeのネイティブなタスク・プラン表示欄は更新されない。対応ランタイムでは、ここへの記録と並行して以下を実行する。

| ランタイム | 必須アクション |
|:--|:--|
| Codex | `update_plan` で短い計画を作成し、進捗ごとに `pending` / `in_progress` / `completed` を更新する |
| Claude Code | `TaskCreate` / `TaskUpdate` / `TaskList` / `TaskGet` を使用する。古いSDK等でTask toolsがない場合のみ `TodoWrite` にフォールバックする |
| その他 | ネイティブ機能がなければ理由を記録。現在値の正本はタスクの `state.json`、説明とロード履歴は本Markdownに保持する |

## サブタスク

- [ ] _(現在タスクのサブタスクを記載)_

## メモ

_(自由記入)_
TASKMD
}

write_task_md_en() {
  cat > "$(doc_path task.md)" <<'TASKMD'
# Task

<!-- AXIARCH_PROCESS_DOC: current-task-only -->

This is session-specific evidence. The task state.json is the shared current-state authority.

## Current Task

- Task: _(describe in one line)_
- Task Type: _(security / architecture / performance / ui_design / api / i18n / finops / testing / other)_
- Started At: _(record autonomously)_

## Loaded Constitution Files

| File | Loaded Sections | Reason |
|:--|:--|:--|
| _(append after autonomous load)_ | _(section or heading)_ | _(reason)_ |

## Load Self-Verification

- [ ] Directly opened `blueprint/core/000_project_overview.md`
- [ ] Directly opened task-relevant Universal/Blueprint files
- [ ] Recorded only files actually opened
- [ ] Recorded relevant-but-not-loaded files and reasons

## Goal (Completion Criteria)

See `axiarch-rules/{lang}/universal/core/300_goal_and_current_state.md` and `axiarch-harness/{lang}/TASK_STATE_PROTOCOL.md`. Match IDs, owners, state, target, check time and evidence to `state.json`.

| # | Completion criterion | How it is verified | Status |
|:--|:--|:--|:--|
| 1 | _(state it observably; vague terms such as "improve" alone are not allowed)_ | _(how it will be checked)_ | _(unmet / met)_ |

- Non-goals: _(state explicitly what will not be done)_
- Assumptions made: _(what was assumed without confirmation)_

## Current State

| State | Contents |
|:--|:--|
| Done | _(criteria met and verified)_ |
| In progress | _(started and unfinished, including owner)_ |
| Not started | _(planned but untouched)_ |
| Discarded | _(considered and deliberately not taken, with reason)_ |

- Last reconciled: _(when, and against what; write "not reconciled" if it was not)_

## Native Task State

Markdown evidence alone does not update Codex or Claude Code native task/plan panels. In supported runtimes, update native state in parallel.

| Runtime | Required Action |
|:--|:--|
| Codex | Create a short plan with `update_plan`, then update each step as `pending`, `in_progress`, or `completed` |
| Claude Code | Use `TaskCreate` / `TaskUpdate` / `TaskList` / `TaskGet`; fall back to `TodoWrite` only in older runtimes where Task tools are unavailable |
| Other | Record unavailable native tools. Task `state.json` remains authoritative for current state; keep explanations and load history in this Markdown |

## Subtasks

- [ ] _(list current-task subtasks)_

## Notes

_(freeform notes)_
TASKMD
}

write_task_md() {
  if [[ "${PROCESS_DOC_LANG_RESOLVED}" == "en" ]]; then
    write_task_md_en
  else
    write_task_md_ja
  fi
}

write_implementation_plan_md_ja() {
  cat > "$(doc_path implementation_plan.md)" <<'PLANMD'
# 実装計画

<!-- AXIARCH_PROCESS_DOC: current-task-only -->

このファイルは現在タスクの実装計画だけを記録する。過去計画は `.axiarch/process-doc-history/` を参照する。

## 目的

_(何を達成するか)_

## 方針

| 領域 | 方針 |
|:--|:--|
| スコープ | _(変更対象と対象外)_ |
| 既存保護 | _(既存機能への影響と保護方針)_ |
| ネイティブ計画 | Codexは `update_plan`、Claude Codeは `TaskCreate` / `TaskUpdate` で同じ進捗を表示する |
| 検証 | _(実行する検証)_ |

## 変更予定ファイル

| ファイル | 変更内容 |
|:--|:--|
| _(未定)_ | _(理由)_ |

## リスクと対策

| リスク | 対策 |
|:--|:--|
| _(未定)_ | _(対策)_ |

## 検証計画

- [ ] _(検証項目)_
PLANMD
}

write_implementation_plan_md_en() {
  cat > "$(doc_path implementation_plan.md)" <<'PLANMD'
# Implementation Plan

<!-- AXIARCH_PROCESS_DOC: current-task-only -->

This file records only the current task implementation plan. See `.axiarch/process-doc-history/` for previous plans.

## Objective

_(what this task will achieve)_

## Approach

| Area | Plan |
|:--|:--|
| Scope | _(in scope and out of scope)_ |
| Existing Safety | _(impact on existing functionality and protection approach)_ |
| Native Plan | Codex uses `update_plan`; Claude Code uses `TaskCreate` / `TaskUpdate` to show the same progress |
| Verification | _(checks to run)_ |

## Planned Files

| File | Change |
|:--|:--|
| _(TBD)_ | _(reason)_ |

## Risks and Mitigations

| Risk | Mitigation |
|:--|:--|
| _(TBD)_ | _(mitigation)_ |

## Verification Plan

- [ ] _(verification item)_
PLANMD
}

write_implementation_plan_md() {
  if [[ "${PROCESS_DOC_LANG_RESOLVED}" == "en" ]]; then
    write_implementation_plan_md_en
  else
    write_implementation_plan_md_ja
  fi
}

write_walkthrough_md_ja() {
  cat > "$(doc_path walkthrough.md)" <<'WALKMD'
# ウォークスルー

<!-- AXIARCH_PROCESS_DOC: current-task-only -->

このファイルは現在タスクの確認結果だけを記録する。過去ウォークスルーは `.axiarch/process-doc-history/` を参照する。

## 確認観点

| 観点 | 確認内容 |
|:--|:--|
| スコープ | _(変更が目的に閉じているか)_ |
| 整合性 | _(日英・README・INDEX・scriptの整合)_ |
| ネイティブ状態 | Codex `update_plan` または Claude Code Task tools の利用をMarkdown証跡と矛盾させない |
| 検証 | _(実行結果)_ |

## 変更内容

| ファイル | 変更内容 | 理由 |
|:--|:--|:--|
| _(未定)_ | _(変更内容)_ | _(理由)_ |

## 検証結果

| 検証 | 結果 |
|:--|:--|
| _(未実行)_ | _(結果)_ |

## 残リスク

_(必要に応じて記載)_
WALKMD
}

write_walkthrough_md_en() {
  cat > "$(doc_path walkthrough.md)" <<'WALKMD'
# Walkthrough

<!-- AXIARCH_PROCESS_DOC: current-task-only -->

This file records only the current task walkthrough. See `.axiarch/process-doc-history/` for previous walkthroughs.

## Review Points

| Point | Check |
|:--|:--|
| Scope | _(scope is bounded to the objective)_ |
| Consistency | _(language, README, INDEX, and script consistency)_ |
| Native State | Keep Codex `update_plan` or Claude Code Task tools consistent with Markdown evidence |
| Verification | _(results)_ |

## Changes

| File | Change | Reason |
|:--|:--|:--|
| _(TBD)_ | _(change)_ | _(reason)_ |

## Verification Results

| Check | Result |
|:--|:--|
| _(not run yet)_ | _(result)_ |

## Residual Risk

_(note if any)_
WALKMD
}

write_walkthrough_md() {
  if [[ "${PROCESS_DOC_LANG_RESOLVED}" == "en" ]]; then
    write_walkthrough_md_en
  else
    write_walkthrough_md_ja
  fi
}

ensure_missing_docs_only() {
  [[ -f "$(doc_path task.md)" ]] || write_task_md
  [[ -f "$(doc_path implementation_plan.md)" ]] || write_implementation_plan_md
  [[ -f "$(doc_path walkthrough.md)" ]] || write_walkthrough_md
}

ensure_missing_docs_only
exit 0
