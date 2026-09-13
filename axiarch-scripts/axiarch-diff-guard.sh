#!/usr/bin/env bash
# =============================================================================
# Axiarch Diff Guard (PostToolUse hook)
# https://github.com/hiroyuki-miyauchi/axiarch
#
# Measures the current git diff after file-editing tools run. When the working
# tree becomes larger than the configured threshold, the hook can warn the agent
# or request a pause through the runtime. It cannot undo an edit already applied.
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

MODE="${AXIARCH_DIFF_GUARD_MODE:-warn}"
if [[ "${MODE}" == "off" || "${AXIARCH_DIFF_GUARD_ALLOW:-}" == "1" ]]; then
  exit 0
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Only drain an actual pipe. Interactive checks must not wait for manual EOF.
if [[ ! -t 0 ]]; then
  cat >/dev/null
fi
if ! command -v python3 >/dev/null 2>&1 || [[ ! -f "${SCRIPT_DIR}/axiarch_diff.py" ]]; then
  REASON='[DIFF GUARD UNASSESSED] Python 3 / axiarch-scripts/axiarch_diff.py unavailable. 差分は未確認です。'
  if [[ "${MODE}" == "block" ]]; then
    printf '{"decision":"block","reason":"%s"}\n' "${REASON}"
    exit 2
  fi
  printf '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"%s"}}\n' "${REASON}"
  exit 0
fi
exec python3 "${SCRIPT_DIR}/axiarch_diff.py"
