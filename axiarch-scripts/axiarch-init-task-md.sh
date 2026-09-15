#!/usr/bin/env bash
# =============================================================================
# Axiarch SessionStart Hook — Process Document Bootstrap
# https://github.com/hiroyuki-miyauchi/axiarch
#
# On startup, resolve/create session-scoped evidence and preserve existing work.
# Shared task state is updated separately through revision-checked publication.
#
# Hook contract (SessionStart):
#   - stdout JSON `{"hookSpecificOutput":{"hookEventName":"SessionStart",
#                  "additionalContext":"..."}}` injects context to the AI
#   - exit code 0 always (this hook never blocks)
#
# Behavior:
#   1. Delegate current/append mode handling to axiarch-task-state.sh when present
#   2. Fallback: report unavailable helper without creating shared root documents
#   3. Emit a reminder pointing to Markdown evidence and native task/plan tools
#
# Python 3 is required by the task-state helper; jq is not required.
# =============================================================================

set -uo pipefail

# Keep child Python paths and stdio UTF-8, independent of inherited locale settings.
# This affects this script and its children only; raw malformed input stays invalid.
export PYTHONUTF8=1 PYTHONIOENCODING=utf-8

# -----------------------------------------------------------------------------
# Resolve project directory
# -----------------------------------------------------------------------------
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-}"
if [[ -z "${PROJECT_DIR}" || ! -d "${PROJECT_DIR}" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  PROJECT_DIR="$(dirname "${SCRIPT_DIR}")"
fi

TASK_STATE_SCRIPT="${PROJECT_DIR}/axiarch-scripts/axiarch-task-state.sh"
HOOK_HELPER="${PROJECT_DIR}/axiarch-scripts/axiarch_hook.py"
if ! command -v python3 >/dev/null 2>&1 || [[ ! -f "$HOOK_HELPER" || ! -f "${PROJECT_DIR}/axiarch-scripts/axiarch_state.py" ]]; then
  printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"[TASK STATE WARNING] Python 3 or Axiarch helpers unavailable; no records created. / Python 3または補助ファイルがないため記録は作成していません。"}}'
  exit 0
fi
INPUT=""
INPUT_WARNING=""
if [[ ! -t 0 ]] && ! INPUT=$(python3 "$HOOK_HELPER" normalize); then
  INPUT_WARNING="Invalid hook JSON; see stderr for the parsing error"
fi
if [[ -z "$INPUT_WARNING" ]]; then
  if ACTIVE_PROJECT=$(printf '%s' "$INPUT" | python3 "$HOOK_HELPER" project --project "$PROJECT_DIR"); then
    PROJECT_DIR="${ACTIVE_PROJECT%.}"
    TASK_STATE_SCRIPT="${PROJECT_DIR}/axiarch-scripts/axiarch-task-state.sh"
  else
    INPUT_WARNING="Hook working project unresolved; original checkout was not substituted"
  fi
fi
if ! SESSION_ID=$(printf '%s' "$INPUT" | python3 "$HOOK_HELPER" session); then
  INPUT_WARNING="Invalid hook identity; see stderr for the parsing error"
  SESSION_ID=""
fi
SESSION_ARGS=()
if [[ -n "${SESSION_ID}" ]]; then SESSION_ARGS=(--session "${SESSION_ID}"); fi

# -----------------------------------------------------------------------------
# Compose context message
# -----------------------------------------------------------------------------
read -r -d '' BASE_MESSAGE <<'EOF' || true
[AXIARCH SESSION START] Follow AXIARCH.md's BOOT SEQUENCE on session start; this hook supplies a reminder and does not perform or verify the agent's reading. Per AXIARCH.md, H2+ work records actual read paths/ranges in session task.md; H0 requires no durable task record and H1 uses a short record. Templates and reminders do not prove loading. task.md / implementation_plan.md / walkthrough.md are current-task Markdown evidence, not the native task/plan UI state. In Codex, when available, also call update_plan and keep exactly one in_progress step while work is active. In Claude Code, also use TaskCreate / TaskUpdate / TaskList / TaskGet when available; fall back to TodoWrite only in older runtimes without Task tools. / セッション開始時はAXIARCH.mdのBOOT SEQUENCEに従ってください。このフックは手順を補足し、AI自身の読み込みを実行・証明するものではありません。AXIARCH.md に基づき、H2以上は実際に読んだパスと範囲をセッションのtask.mdへ記録します。H0は永続記録不要、H1は短い記録で足ります。テンプレートや補足の表示はロード完了の証明ではありません。task.md / implementation_plan.md / walkthrough.md は現在タスク用のMarkdown証跡であり、ネイティブなタスク・プランUI状態ではありません。Codexでは利用可能な場合 update_plan も併用し、作業中は in_progress を1件だけ維持してください。Claude Codeでは利用可能な場合 TaskCreate / TaskUpdate / TaskList / TaskGet を併用し、Task tools がない古いランタイムでのみ TodoWrite にフォールバックしてください。
EOF

# -----------------------------------------------------------------------------
# Bootstrap / refresh process documents
# -----------------------------------------------------------------------------
SCAFFOLD_NOTE=""
if [[ -n "$INPUT_WARNING" ]]; then
  SCAFFOLD_NOTE=" [TASK STATE WARNING] ${INPUT_WARNING}. No records created or replaced. / 入力が不正なため記録は作成・置換していません。"
elif [[ -f "${TASK_STATE_SCRIPT}" ]]; then
  if ! TASK_STATE_OUTPUT=$(bash "${TASK_STATE_SCRIPT}" --project "${PROJECT_DIR}" --mode session-start "${SESSION_ARGS[@]+"${SESSION_ARGS[@]}"}" 2>&1); then
    TASK_STATE_OUTPUT="[TASK STATE WARNING] ${TASK_STATE_OUTPUT}. Existing records preserved; retry bootstrap before implementation. / 既存記録は保持。実装前に起動処理を再実行してください。"
  fi
  if [[ -n "${TASK_STATE_OUTPUT}" ]]; then
    SCAFFOLD_NOTE=" ${TASK_STATE_OUTPUT}"
  fi
else
  SCAFFOLD_NOTE=" [TASK STATE WARNING] axiarch-task-state.sh is unavailable. No records were created or replaced. Restore the scripts or use equivalent isolated evidence per TASK_STATE_PROTOCOL. / 補助スクリプトが無いため記録は作成・置換していません。scriptsの復旧または契約に沿った独立記録を利用してください。"

fi

FULL_MESSAGE="${BASE_MESSAGE}${SCAFFOLD_NOTE} For implementation, directly load axiarch-rules/{lang}/universal/core/300_goal_and_current_state.md and follow axiarch-harness/{lang}/TASK_STATE_PROTOCOL.md. Use the session docs path when supplied by TASK STATE; otherwise no session path has been resolved. Root docs are legacy/shared references. H0 needs no task bootstrap gate; investigate accessible facts yourself. / 実装時はcore/300とTASK_STATE_PROTOCOLを直接ロードし、TASK STATEでパスが提示された場合はそのセッション固有記録を使用し、未提示なら記録先は未解決として扱います。ルート文書は旧記録・共有参照です。H0に記録作成ゲートを要求せず、確認可能な事実は自ら調べてください。"

# -----------------------------------------------------------------------------
# JSON-encode and emit hookSpecificOutput.additionalContext
# -----------------------------------------------------------------------------
if ! printf '%s' "$FULL_MESSAGE" | python3 "$HOOK_HELPER" emit --event SessionStart; then
  printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"[TASK STATE WARNING] Context encoding failed; inspect bootstrap status. / 補足の生成に失敗しました。起動処理の状態を確認してください。"}}'
fi
