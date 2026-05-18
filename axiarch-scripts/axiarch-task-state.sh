#!/usr/bin/env bash
# =============================================================================
# Axiarch Task State Lifecycle Helper
# https://github.com/hiroyuki-miyauchi/axiarch
#
# Keeps the AGENTS.md §8 process documents as "current task" working files
# instead of ever-growing append-only logs.
#
# Responsibilities:
#   - Create or refresh task.md / implementation_plan.md / walkthrough.md
#   - Archive changed previous copies before refresh
#   - Preserve legacy append behaviour when AXIARCH_PROCESS_DOC_MODE=append
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

usage() {
  cat <<'USAGE'
Usage:
  bash axiarch-scripts/axiarch-task-state.sh [--project DIR] [--mode session-start|ensure|status] [--quiet]

Modes:
  session-start: archive changed previous docs, then refresh current docs unless
                 AXIARCH_PROCESS_DOC_MODE=append is set.
  ensure:        preserve existing docs and create only missing docs.
  status:        report whether process docs exist.

Environment:
  AXIARCH_PROCESS_DOC_MODE=current|append
    current (default): archive changed previous docs, then refresh current docs.
    append: keep existing docs, only create missing docs.

  AXIARCH_PROCESS_DOC_ARCHIVE=1|0
    1 (default): copy changed previous docs to .axiarch/process-doc-history/.
    0: refresh without archiving. Use only when history is intentionally unnecessary.

  AXIARCH_PROCESS_DOC_HISTORY_DIR=.axiarch/process-doc-history
    Relative or absolute archive root.

  AXIARCH_PROCESS_DOC_LANG=auto|ja|en
    auto (default): detect Project Native Language from AGENTS.md.
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

if [[ -z "${PROJECT_DIR}" ]]; then
  PROJECT_DIR="${CLAUDE_PROJECT_DIR:-}"
fi
if [[ -z "${PROJECT_DIR}" || ! -d "${PROJECT_DIR}" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  PROJECT_DIR="$(dirname "${SCRIPT_DIR}")"
fi

PROCESS_DOC_MODE="${AXIARCH_PROCESS_DOC_MODE:-current}"
ARCHIVE_ENABLED="${AXIARCH_PROCESS_DOC_ARCHIVE:-1}"
HISTORY_ROOT="${AXIARCH_PROCESS_DOC_HISTORY_DIR:-.axiarch/process-doc-history}"
PROCESS_DOC_LANG="${AXIARCH_PROCESS_DOC_LANG:-auto}"
STATE_DIR="${PROJECT_DIR}/.axiarch/process-doc-state"
STATE_FILE="${STATE_DIR}/last-current.sha256"

case "${MODE}" in
  session-start|ensure|status) ;;
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

  local agents_file lang_line
  agents_file="${PROJECT_DIR}/AGENTS.md"
  if [[ -f "${agents_file}" ]]; then
    lang_line="$(grep -iE "Project Native Language" "${agents_file}" 2>/dev/null | head -1 || true)"
    if [[ -n "${lang_line}" ]]; then
      local line_lower config_part default_part
      line_lower="$(printf '%s\n' "${lang_line}" | tr '[:upper:]' '[:lower:]')"
      config_part="${line_lower%%default:*}"
      default_part=""
      if [[ "${line_lower}" == *"default:"* ]]; then
        default_part="${line_lower#*default:}"
      fi

      if [[ "${config_part}" == *"english"* && "${config_part}" != *"japanese"* ]]; then
        printf 'en'
        return 0
      fi
      if [[ "${config_part}" == *"japanese"* && "${config_part}" != *"english"* ]]; then
        printf 'ja'
        return 0
      fi
      if [[ "${default_part}" == *"english"* && "${default_part}" != *"japanese"* ]]; then
        printf 'en'
        return 0
      fi
      if [[ "${default_part}" == *"japanese"* && "${default_part}" != *"english"* ]]; then
        printf 'ja'
        return 0
      fi
    fi
  fi

  if [[ -d "${PROJECT_DIR}/axiarch-rules/en" && ! -d "${PROJECT_DIR}/axiarch-rules/ja" ]]; then
    printf 'en'
  else
    printf 'ja'
  fi
}

if ! PROCESS_DOC_LANG_RESOLVED="$(detect_project_native_language)"; then
  exit 2
fi

docs=(task.md implementation_plan.md walkthrough.md)

doc_path() {
  printf '%s/%s' "${PROJECT_DIR}" "$1"
}

has_any_doc_content() {
  local doc
  for doc in "${docs[@]}"; do
    local path
    path="$(doc_path "${doc}")"
    if [[ -s "${path}" ]]; then
      return 0
    fi
  done
  return 1
}

hash_current_docs() {
  local doc path
  local hash_command=()
  if command -v shasum >/dev/null 2>&1; then
    hash_command=(shasum -a 256)
  elif command -v sha256sum >/dev/null 2>&1; then
    hash_command=(sha256sum)
  else
    printf 'Neither shasum nor sha256sum is available; cannot hash process docs.\n' >&2
    return 1
  fi
  {
    for doc in "${docs[@]}"; do
      path="$(doc_path "${doc}")"
      printf '%s\n' "--- ${doc} ---"
      if [[ -f "${path}" ]]; then
        cat "${path}"
      fi
      printf '\n'
    done
  } | "${hash_command[@]}" | awk '{print $1}'
}

resolve_history_root() {
  if [[ "${HISTORY_ROOT}" = /* ]]; then
    printf '%s' "${HISTORY_ROOT}"
  else
    printf '%s/%s' "${PROJECT_DIR}" "${HISTORY_ROOT}"
  fi
}

archive_docs_if_changed() {
  [[ "${ARCHIVE_ENABLED}" == "1" ]] || return 0
  has_any_doc_content || return 0

  local current_hash previous_hash
  current_hash="$(hash_current_docs)"
  previous_hash=""
  if [[ -f "${STATE_FILE}" ]]; then
    previous_hash="$(head -1 "${STATE_FILE}" 2>/dev/null | tr -d '[:space:]')"
  fi
  if [[ -n "${previous_hash}" && "${current_hash}" == "${previous_hash}" ]]; then
    return 0
  fi

  local archive_root archive_dir timestamp doc path
  archive_root="$(resolve_history_root)"
  timestamp="$(date -u +%Y%m%dT%H%M%SZ)"
  archive_dir="${archive_root}/${timestamp}-$$"
  mkdir -p "${archive_dir}"

  for doc in "${docs[@]}"; do
    path="$(doc_path "${doc}")"
    if [[ -f "${path}" ]]; then
      cp -p "${path}" "${archive_dir}/${doc}"
    fi
  done

  printf '%s' "${archive_dir}"
}

write_task_md_ja() {
  cat > "$(doc_path task.md)" <<'TASKMD'
# タスク

<!-- AXIARCH_PROCESS_DOC: current-task-only -->

このファイルは現在タスクの作業状態だけを記録する。過去タスクの内容は `.axiarch/process-doc-history/` に退避される。

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

## ネイティブタスク状態

Markdown証跡だけでは、CodexやClaude Codeのネイティブなタスク・プラン表示欄は更新されない。対応ランタイムでは、ここへの記録と並行して以下を実行する。

| ランタイム | 必須アクション |
|:--|:--|
| Codex | `update_plan` で短い計画を作成し、進捗ごとに `pending` / `in_progress` / `completed` を更新する |
| Claude Code | `TaskCreate` / `TaskUpdate` / `TaskList` / `TaskGet` を使用する。古いSDK等でTask toolsがない場合のみ `TodoWrite` にフォールバックする |
| その他 | ネイティブ機能がない場合は本Markdown証跡をSSOTとして扱う |

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

This file records only the current task state. Previous task content is archived under `.axiarch/process-doc-history/`.

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

## Native Task State

Markdown evidence alone does not update Codex or Claude Code native task/plan panels. In supported runtimes, update native state in parallel.

| Runtime | Required Action |
|:--|:--|
| Codex | Create a short plan with `update_plan`, then update each step as `pending`, `in_progress`, or `completed` |
| Claude Code | Use `TaskCreate` / `TaskUpdate` / `TaskList` / `TaskGet`; fall back to `TodoWrite` only in older runtimes where Task tools are unavailable |
| Other | Treat this Markdown evidence as the SSOT when no native task-state feature exists |

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

refresh_current_docs() {
  local archive_dir
  archive_dir="$(archive_docs_if_changed)"
  write_task_md
  write_implementation_plan_md
  write_walkthrough_md
  mkdir -p "${STATE_DIR}"
  hash_current_docs > "${STATE_FILE}"
  printf '%s' "${archive_dir}"
}

if [[ "${MODE}" == "status" ]]; then
  if has_any_doc_content; then
    "${PRINT_SUMMARY}" && printf '[AXIARCH TASK STATE] process docs exist. mode=%s\n' "${PROCESS_DOC_MODE}"
  else
    "${PRINT_SUMMARY}" && printf '[AXIARCH TASK STATE] process docs are missing or empty. mode=%s\n' "${PROCESS_DOC_MODE}"
  fi
  exit 0
fi

summary=""
if [[ "${MODE}" == "ensure" ]]; then
  ensure_missing_docs_only
  summary="[AXIARCH TASK STATE] ensure mode: created only missing process docs. Existing task.md / implementation_plan.md / walkthrough.md were preserved."
elif [[ "${PROCESS_DOC_MODE}" == "append" ]]; then
  ensure_missing_docs_only
  summary="[AXIARCH TASK STATE] append mode: ensured missing process docs only. Existing task.md / implementation_plan.md / walkthrough.md were preserved."
else
  archived_to="$(refresh_current_docs)"
  if [[ -n "${archived_to}" ]]; then
    summary="[AXIARCH TASK STATE] current mode: archived previous process docs to ${archived_to}, then refreshed task.md / implementation_plan.md / walkthrough.md for the current task."
  else
    summary="[AXIARCH TASK STATE] current mode: refreshed task.md / implementation_plan.md / walkthrough.md for the current task. No changed previous docs needed archiving."
  fi
fi

"${PRINT_SUMMARY}" && printf '%s\n' "${summary}"
exit 0
