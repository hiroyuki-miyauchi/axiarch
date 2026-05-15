#!/usr/bin/env bash
# =============================================================================
# Axiarch Diff Guard (PostToolUse hook)
# https://github.com/hiroyuki-miyauchi/axiarch
#
# Measures the current git diff after file-editing tools run. When the working
# tree becomes larger than the configured threshold, the hook can warn the agent
# or block the next step so the change can be reviewed before it grows further.
#
# Hook contract (PostToolUse):
#   - stdin: JSON with tool_name/tool_input when provided by the agent runtime
#   - stdout: optional JSON output with additionalContext or decision block
#   - exit code 2 with decision:block is used for block mode
#
# Environment:
#   AXIARCH_DIFF_GUARD_MODE=warn|block|off   default: warn
#   AXIARCH_DIFF_GUARD_MAX_LINES=400         added + deleted lines
#   AXIARCH_DIFF_GUARD_MAX_FILES=20          changed + untracked files
#   AXIARCH_DIFF_GUARD_INCLUDE_UNTRACKED=1   include untracked file counts
#   AXIARCH_DIFF_GUARD_ALLOW=1               bypass once for intentional bulk work
# =============================================================================

set -uo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-}"
if [[ -z "${PROJECT_DIR}" || ! -d "${PROJECT_DIR}" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  PROJECT_DIR="$(dirname "${SCRIPT_DIR}")"
fi

MODE="${AXIARCH_DIFF_GUARD_MODE:-warn}"
MAX_LINES="${AXIARCH_DIFF_GUARD_MAX_LINES:-400}"
MAX_FILES="${AXIARCH_DIFF_GUARD_MAX_FILES:-20}"
INCLUDE_UNTRACKED="${AXIARCH_DIFF_GUARD_INCLUDE_UNTRACKED:-1}"

case "${MODE}" in
  warn|block|off) ;;
  *) MODE="warn" ;;
esac

if [[ "${MODE}" == "off" || "${AXIARCH_DIFF_GUARD_ALLOW:-}" == "1" ]]; then
  exit 0
fi

if ! [[ "${MAX_LINES}" =~ ^[0-9]+$ ]]; then
  MAX_LINES=400
fi
if ! [[ "${MAX_FILES}" =~ ^[0-9]+$ ]]; then
  MAX_FILES=20
fi

if ! git -C "${PROJECT_DIR}" rev-parse --git-dir >/dev/null 2>&1; then
  exit 0
fi

# Consume stdin so hook runtimes can pipe JSON safely. The current guard does
# not need tool-specific fields because it validates the repository diff state.
HOOK_INPUT="$(cat)"
: "${HOOK_INPUT:=}"

ADDED_LINES=0
DELETED_LINES=0
TRACKED_FILES=0

while IFS=$'\t' read -r added deleted path; do
  [[ -z "${path}" ]] && continue
  TRACKED_FILES=$((TRACKED_FILES + 1))
  if [[ "${added}" =~ ^[0-9]+$ ]]; then
    ADDED_LINES=$((ADDED_LINES + added))
  fi
  if [[ "${deleted}" =~ ^[0-9]+$ ]]; then
    DELETED_LINES=$((DELETED_LINES + deleted))
  fi
done < <(git -C "${PROJECT_DIR}" diff --numstat HEAD -- 2>/dev/null || true)

UNTRACKED_FILES=0
UNTRACKED_LINES=0
if [[ "${INCLUDE_UNTRACKED}" != "0" ]]; then
  while IFS= read -r -d '' rel_path; do
    [[ -z "${rel_path}" ]] && continue
    full_path="${PROJECT_DIR}/${rel_path}"
    [[ -f "${full_path}" ]] || continue
    UNTRACKED_FILES=$((UNTRACKED_FILES + 1))
    line_count=$(wc -l < "${full_path}" 2>/dev/null | awk '{print $1}' || echo "0")
    if [[ "${line_count}" =~ ^[0-9]+$ ]]; then
      UNTRACKED_LINES=$((UNTRACKED_LINES + line_count))
    fi
  done < <(git -C "${PROJECT_DIR}" ls-files --others --exclude-standard -z 2>/dev/null || true)
fi

TOTAL_LINES=$((ADDED_LINES + DELETED_LINES + UNTRACKED_LINES))
TOTAL_FILES=$((TRACKED_FILES + UNTRACKED_FILES))

if [[ "${TOTAL_LINES}" -le "${MAX_LINES}" && "${TOTAL_FILES}" -le "${MAX_FILES}" ]]; then
  exit 0
fi

REASON_JA="Axiarch diff guard: 現在の差分が大きくなっています。変更行数=${TOTAL_LINES}/${MAX_LINES}、変更ファイル数=${TOTAL_FILES}/${MAX_FILES}。作業を続ける前に、差分の意図、対象範囲、検証方針を task.md / implementation_plan.md / walkthrough.md に反映し、必要なら分割してください。"
REASON_EN="Axiarch diff guard: current git diff is large. Changed lines=${TOTAL_LINES}/${MAX_LINES}, files=${TOTAL_FILES}/${MAX_FILES}. Before continuing, record intent, scope, and verification plan in task.md / implementation_plan.md / walkthrough.md, and split the change when appropriate."
REASON_FULL="${REASON_JA} / ${REASON_EN}"

escape_json_value() {
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

ESCAPED_REASON=$(escape_json_value "${REASON_FULL}")

if [[ "${MODE}" == "block" ]]; then
  printf '%s' '{"decision":"block","reason":"'"${ESCAPED_REASON}"'"}'
  printf '\n[axiarch:diff-guard] BLOCKED — %s\n' "${REASON_FULL}" >&2
  exit 2
fi

printf '%s' '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"'"${ESCAPED_REASON}"'"}}'
printf '\n[axiarch:diff-guard] WARN — %s\n' "${REASON_FULL}" >&2
exit 0
