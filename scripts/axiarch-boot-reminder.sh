#!/usr/bin/env bash
# =============================================================================
# Axiarch Boot Reminder Hook (UserPromptSubmit / additionalContext emitter)
# https://github.com/hiroyuki-miyauchi/axiarch
#
# Outputs a JSON payload conforming to Claude Code's hookSpecificOutput.additionalContext
# spec (https://code.claude.com/docs/en/hooks). The reminder is injected directly
# into Claude's context instead of being splashed in transcript / Plan-mode UI.
#
# Beyond the static AXIARCH BOOT message, this script performs two lightweight
# project-state checks and APPENDS violation flags to the reminder when found,
# enabling the AI to self-correct on the next turn (warning, not hard-block).
#
#   Check A  task.md missing load history   → flag appended
#   Check B  core/010_project_lessons_log.md domain ≥3 unsorted → flag appended
#
# No external dependencies (no `jq` required); JSON is built via pure bash.
# POSIX printf only.
# =============================================================================

set -uo pipefail

# Resolve project directory: prefer Claude Code's CLAUDE_PROJECT_DIR if exported,
# otherwise fall back to two levels up from this script (axiarch/scripts/<this>).
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-}"
if [[ -z "${PROJECT_DIR}" || ! -d "${PROJECT_DIR}" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  PROJECT_DIR="$(dirname "${SCRIPT_DIR}")"
fi

# -----------------------------------------------------------------------------
# Static base reminder (bilingual; identical to the inline reminder previously
# distributed via .claude/settings.json before externalization)
# -----------------------------------------------------------------------------
read -r -d '' CORE_REMINDER <<'EOF' || true
[AXIARCH BOOT] This project enforces axiarch governance. Before responding, the AI applies AGENTS.md (supreme law — Project Configuration + 9 protocols) and LOADING_PROTOCOL.md BOOT SEQUENCE. Output language follows the Project Native Language declared in AGENTS.md and is applied to every heading, summary, label, list, and table. Loaded rule files (AGENTS.md, INDEX.md, LOADING_PROTOCOL.md, etc.) are recorded in task.md per AGENTS.md §8 (Process & Documentation, item 4 — Documentation Requirements); a missing record is treated as a protocol violation. On task completion, the AI runs CRYSTALLIZATION_PROTOCOL Step 5 THRESHOLD CHECK and, when any domain in core/010_project_lessons_log.md holds 3+ unsorted lessons, promotes them into a dedicated Blueprint file before declaring the task done — appending to core/010 alone is not completion. / 本プロジェクトは axiarch ガバナンスを採用しています。応答前に AGENTS.md（最高法規・Project Configuration + 9 プロトコル）と LOADING_PROTOCOL.md の BOOT SEQUENCE を適用します。応答言語は AGENTS.md で宣言された Project Native Language に従い、見出し・要約・ラベル・箇条書き・表すべてに適用されます。ロードしたルールファイル (AGENTS.md / INDEX.md / LOADING_PROTOCOL.md 等) は AGENTS.md §8 (Process & Documentation 第 4 項 — ドキュメント生成要件) に基づき task.md に記録されます。記録欠落はプロトコル違反として扱われます。タスク完了時は CRYSTALLIZATION_PROTOCOL Step 5 THRESHOLD CHECK を実行し、core/010_project_lessons_log.md のドメインに 3 件以上の未整理教訓がある場合は Blueprint 専用ファイルへ昇華してから完了を宣言します。core/010 への追記だけでは完了とみなされません。
EOF

VIOLATIONS=""

# -----------------------------------------------------------------------------
# Check A: task.md missing load history
# -----------------------------------------------------------------------------
if [[ -f "${PROJECT_DIR}/task.md" ]]; then
  if ! grep -qE "AGENTS\.md|INDEX\.md|LOADING_PROTOCOL\.md" "${PROJECT_DIR}/task.md" 2>/dev/null; then
    VIOLATIONS="${VIOLATIONS} 🚨 [VIOLATION-A] task.md にロード履歴 (AGENTS.md/INDEX.md/LOADING_PROTOCOL.md) が未記録。即座に記録せよ。/ task.md missing load history — record immediately."
  fi
fi
# Note: task.md absence is allowed (created on first task per AGENTS §8.4).

# -----------------------------------------------------------------------------
# Check B: Crystallization threshold breach (3+ unsorted per domain)
# -----------------------------------------------------------------------------
LESSONS_LOG=""
for lang in ja en; do
  candidate="${PROJECT_DIR}/axiarch-rules/${lang}/blueprint/core/010_project_lessons_log.md"
  if [[ -f "${candidate}" ]]; then
    LESSONS_LOG="${candidate}"
    break
  fi
done

if [[ -n "${LESSONS_LOG}" ]]; then
  DOMAIN_LIST=$(grep -E "^\*\*Domain:\*\*|^Domain:" "${LESSONS_LOG}" 2>/dev/null \
    | sed -E 's|^\*\*Domain:\*\*[[:space:]]*||; s|^Domain:[[:space:]]*||' \
    | awk -F'/' '{print $1}' | awk '{$1=$1; print}' | sort)
  if [[ -n "${DOMAIN_LIST}" ]]; then
    while IFS= read -r domain; do
      [[ -z "${domain}" ]] && continue
      count=$(echo "${DOMAIN_LIST}" | grep -cFx "${domain}" 2>/dev/null || true)
      count="${count:-0}"
      if [[ "${count}" -ge 3 ]]; then
        VIOLATIONS="${VIOLATIONS} 🚨 [VIOLATION-B] core/010 で domain '${domain}' が ${count} 件溜まっている。CRYSTALLIZATION §5 で Blueprint へ昇華せよ。/ Domain '${domain}' has ${count}+ unsorted lessons; execute CRYSTAL §5 to promote."
        break  # report first offender only to keep payload small
      fi
    done < <(echo "${DOMAIN_LIST}" | sort -u)
  fi
fi

# -----------------------------------------------------------------------------
# Compose final reminder
# -----------------------------------------------------------------------------
if [[ -n "${VIOLATIONS}" ]]; then
  FULL_REMINDER="${CORE_REMINDER}${VIOLATIONS}"
else
  FULL_REMINDER="${CORE_REMINDER}"
fi

# -----------------------------------------------------------------------------
# JSON-encode the reminder (pure bash, no jq dependency)
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

ESCAPED=$(escape_json "${FULL_REMINDER}")
printf '%s' '{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"'"${ESCAPED}"'"}}'
