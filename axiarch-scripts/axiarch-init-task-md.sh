#!/usr/bin/env bash
# =============================================================================
# Axiarch SessionStart Hook — Process Document Bootstrap
# https://github.com/hiroyuki-miyauchi/axiarch
#
# At the start of each Claude Code / Codex session, this hook ensures the
# AGENTS.md §8 process documents exist and, by default, refreshes them as
# current-task working files:
#   - task.md
#   - implementation_plan.md
#   - walkthrough.md
#
# Previous non-template copies are archived under .axiarch/process-doc-history/
# before refresh. This keeps current state visible without letting old tasks
# accumulate indefinitely in the same files.
#
# Hook contract (SessionStart):
#   - stdout JSON `{"hookSpecificOutput":{"hookEventName":"SessionStart",
#                  "additionalContext":"..."}}` injects context to the AI
#   - exit code 0 always (this hook never blocks)
#
# Behavior:
#   1. Delegate current/append mode handling to axiarch-task-state.sh when present
#   2. Fallback: create task.md scaffold when the helper is missing
#   3. Emit a reminder pointing to Markdown evidence and native task/plan tools
#
# No external dependencies (no jq required).
# =============================================================================

set -uo pipefail

# -----------------------------------------------------------------------------
# Resolve project directory
# -----------------------------------------------------------------------------
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-}"
if [[ -z "${PROJECT_DIR}" || ! -d "${PROJECT_DIR}" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  PROJECT_DIR="$(dirname "${SCRIPT_DIR}")"
fi

TASK_MD="${PROJECT_DIR}/task.md"
TASK_STATE_SCRIPT="${PROJECT_DIR}/axiarch-scripts/axiarch-task-state.sh"

# -----------------------------------------------------------------------------
# Compose context message
# -----------------------------------------------------------------------------
read -r -d '' BASE_MESSAGE <<'EOF' || true
[AXIARCH SESSION START] This project enforces axiarch's BOOT SEQUENCE protocol on session start. Per AGENTS.md §8 (Process & Documentation, item 4 — Documentation Requirements), the AI must record loaded rule files (AGENTS.md, INDEX.md, LOADING_PROTOCOL.md, etc.) in task.md before beginning work. task.md / implementation_plan.md / walkthrough.md are current-task Markdown evidence, not the native task/plan UI state. In Codex, also call update_plan and keep exactly one in_progress step while work is active. In Claude Code, also use TaskCreate / TaskUpdate / TaskList / TaskGet when available; fall back to TodoWrite only in older runtimes without Task tools. / 本プロジェクトはセッション開始時に axiarch BOOT SEQUENCE を強制します。AGENTS.md §8 (Process & Documentation 第 4 項 — ドキュメント生成要件) に基づき、ロードしたルールファイル (AGENTS.md / INDEX.md / LOADING_PROTOCOL.md 等) を task.md に記録してから作業を開始してください。task.md / implementation_plan.md / walkthrough.md は現在タスク用のMarkdown証跡であり、ネイティブなタスク・プランUI状態ではありません。Codexでは update_plan も併用し、作業中は in_progress を1件だけ維持してください。Claude Codeでは利用可能な場合 TaskCreate / TaskUpdate / TaskList / TaskGet を併用し、Task tools がない古いランタイムでのみ TodoWrite にフォールバックしてください。
EOF

# -----------------------------------------------------------------------------
# Bootstrap / refresh process documents
# -----------------------------------------------------------------------------
SCAFFOLD_NOTE=""
if [[ -x "${TASK_STATE_SCRIPT}" ]]; then
  TASK_STATE_OUTPUT=$(bash "${TASK_STATE_SCRIPT}" --project "${PROJECT_DIR}" --mode session-start 2>/dev/null || true)
  if [[ -n "${TASK_STATE_OUTPUT}" ]]; then
    SCAFFOLD_NOTE=" ${TASK_STATE_OUTPUT}"
  fi
elif [[ ! -f "${TASK_MD}" ]]; then
  cat > "${TASK_MD}" <<'TASKMD'
# Task

## ロード済み憲法ファイル / Loaded Constitution Files

> **このテーブルは AGENTS.md §8 (Process & Documentation) 第 4 項に基づく必須記録です。**
> **This table is mandatory per AGENTS.md §8 (Process & Documentation), item 4 (Documentation Requirements).**
>
> セッション開始時、または新たにルールファイルを参照したとき、ここにファイル名とロード理由を追記してください。
> Append filename + load reason whenever a session starts or a rule file is consulted.

| ファイル / File | ロード理由 / Reason |
|:--|:--|
| _(自律ロード後にここに追記 / append after autonomous load)_ | _(理由 / reason)_ |

## サブタスク / Subtasks

- [ ] _(タスクをここに記載 / list the work here)_

## メモ / Notes

_(自由記入 / freeform notes)_
TASKMD
  SCAFFOLD_NOTE=" [SCAFFOLD CREATED] task.md was missing and has been initialised with the load-history table. Populate it now. / task.md が存在しなかったため自動生成しました。即座にロード履歴を埋めてください。"
else
  SCAFFOLD_NOTE=" [TASK STATE WARNING] axiarch-task-state.sh is missing or not executable, so only legacy task.md bootstrap is available. / axiarch-task-state.sh が無い、または実行不可のため、従来の task.md bootstrap のみ有効です。"
fi

FULL_MESSAGE="${BASE_MESSAGE}${SCAFFOLD_NOTE}"

# -----------------------------------------------------------------------------
# JSON-encode and emit hookSpecificOutput.additionalContext
# -----------------------------------------------------------------------------
escape_json() {
  local s="$1"
  s="${s//\\/\\\\}"
  s="${s//\"/\\\"}"
  s="${s//$'\b'/\\b}"
  s="${s//$'\f'/\\f}"
  s="${s//$'\n'/\\n}"
  s="${s//$'\r'/\\r}"
  s="${s//$'\t'/\\t}"
  printf '%s' "$s"
}

ESCAPED=$(escape_json "${FULL_MESSAGE}")
printf '%s' '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"'"${ESCAPED}"'"}}'
