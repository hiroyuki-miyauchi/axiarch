#!/usr/bin/env bash
# =============================================================================
# Axiarch SessionStart Hook — task.md Bootstrap
# https://github.com/hiroyuki-miyauchi/axiarch
#
# At the start of each Claude Code session, this hook ensures task.md exists
# with a minimal scaffold reminding the AI of LOADING_PROTOCOL Step 4 and the
# §8.4 "Documentation Requirements" obligation. Empty / missing task.md is the
# single most frequent compliance failure observed across v1.5.x — this
# bootstrap removes the "no record at all" failure mode.
#
# Hook contract (SessionStart):
#   - stdout JSON `{"hookSpecificOutput":{"hookEventName":"SessionStart",
#                  "additionalContext":"..."}}` injects context to the AI
#   - exit code 0 always (this hook never blocks)
#
# Behavior:
#   1. If task.md exists → emit a short reminder (no file write)
#   2. If task.md missing → create scaffold (header + load-history table stub)
#      and emit a reminder pointing to it
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

# -----------------------------------------------------------------------------
# Compose context message
# -----------------------------------------------------------------------------
read -r -d '' BASE_MESSAGE <<'EOF' || true
[AXIARCH SESSION START] This project enforces axiarch's BOOT SEQUENCE protocol on session start. Per AGENTS.md §8 (Process & Documentation, item 4 — Documentation Requirements), the AI must record loaded rule files (AGENTS.md, INDEX.md, LOADING_PROTOCOL.md, etc.) in task.md before beginning work. Open task.md and confirm or update the load-history table as your first action. / 本プロジェクトはセッション開始時に axiarch BOOT SEQUENCE を強制します。AGENTS.md §8 (Process & Documentation, 第 4 項 — ドキュメント生成要件) に基づき、ロードしたルールファイル (AGENTS.md / INDEX.md / LOADING_PROTOCOL.md 等) を task.md に記録してから作業を開始してください。最初のアクションとして task.md を開き、ロード履歴テーブルを確認・更新してください。
EOF

# -----------------------------------------------------------------------------
# Bootstrap task.md if missing
# -----------------------------------------------------------------------------
SCAFFOLD_NOTE=""
if [[ ! -f "${TASK_MD}" ]]; then
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
