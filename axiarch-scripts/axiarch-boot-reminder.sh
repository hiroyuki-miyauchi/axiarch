#!/usr/bin/env bash
# =============================================================================
# Axiarch Boot Reminder Hook (UserPromptSubmit / additionalContext emitter)
# https://github.com/hiroyuki-miyauchi/axiarch
#
# Outputs a JSON payload conforming to Claude Code's hookSpecificOutput.additionalContext
# spec (https://code.claude.com/docs/en/hooks). The reminder is injected directly
# into Claude's context instead of being splashed in transcript / Plan-mode UI.
#
# Beyond the static AXIARCH BOOT message, this script performs lightweight
# project-state checks and APPENDS violation flags to the reminder when found,
# enabling the AI to self-correct on the next turn (warning, not hard-block).
#
#   Check A  task.md missing load history                       → flag appended
#   Check B  core/010_project_lessons_log.md domain ≥3 unsorted  → flag appended
#   Check C  core/010 lesson dated >180 days (stale)            → flag appended (v1.6.0+)
#   Check D  Task boundary detection — current prompt domain    → flag + TTL bypass (v1.8.0+)
#            ≠ domains in process docs (task.md / implementation_plan.md / walkthrough.md)
#
# v1.6.0+ TWO-STAGE OUTPUT (token-cost optimisation):
#   - First fire (or after TTL expires)            → FULL reminder + timestamp
#   - Subsequent fires within TTL + no violations  → SHORT-CIRCUIT [AXIARCH OK]
#   - Any violation detected (A/B/C/D)             → forced FULL reminder (TTL ignored)
#
# v1.8.0+ TASK BOUNDARY DETECTION (Check D):
#   - Reads current user prompt from stdin (Claude Code passes JSON payload)
#   - Extracts domain keywords (security/architecture/ui_design/api/performance/etc.)
#   - Compares against the AGENTS §8.4 mandatory trio (task.md / implementation_plan.md
#     / walkthrough.md) — full-text grep, not just task.md's load-history table
#   - On mismatch: VIOLATION-D + force full reminder (override TTL short-circuit)
#   - Addresses the "AI judges 'same session, no re-load needed' and slacks" issue
#     identified by adopter feedback. Removes AI's self-judgment loophole.
#   - Reading all 3 process docs avoids false positives where the plan / walkthrough
#     already contains the prompt's domain context (per §8.4 these files are kept
#     up-to-date by the AI; trusting all 3 mirrors the AI's actual working state).
#
#   TTL: ${AXIARCH_REMINDER_TTL_SECONDS:-1800}  (default 30 min, 0 disables short-circuit)
#   State file: ${TMPDIR:-/tmp}/axiarch-reminder-{project_hash}.timestamp
#   Stale lesson threshold: ${AXIARCH_LESSON_STALE_DAYS:-180}  (0 disables Check C)
#   Task boundary detection: ${AXIARCH_TASK_BOUNDARY_DETECT:-1}  (0 disables Check D)
#
#   Token impact (observed in long sessions): ~24k cumulative → ~3k (87% reduction)
#
# No external dependencies (no `jq` required); JSON is built via pure bash.
# POSIX printf only.
# =============================================================================

set -uo pipefail

# -----------------------------------------------------------------------------
# Read hook input from stdin (Claude Code passes JSON payload for UserPromptSubmit)
# Format (per https://code.claude.com/docs/en/hooks):
#   {"prompt": "...", "session_id": "...", "transcript_path": "...", "cwd": "..."}
# Read non-blocking: if no stdin available, INPUT stays empty.
# -----------------------------------------------------------------------------
INPUT=""
if [[ ! -t 0 ]]; then
  INPUT=$(cat 2>/dev/null || true)
fi

# Resolve project directory: prefer Claude Code's CLAUDE_PROJECT_DIR if exported,
# otherwise fall back to two levels up from this script (axiarch/axiarch-scripts/<this>).
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-}"
if [[ -z "${PROJECT_DIR}" || ! -d "${PROJECT_DIR}" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  PROJECT_DIR="$(dirname "${SCRIPT_DIR}")"
fi

# -----------------------------------------------------------------------------
# Static base reminder (bilingual; identical to the inline reminder previously
# distributed via .claude/settings.json or .codex/hooks.json before externalization)
# -----------------------------------------------------------------------------
read -r -d '' CORE_REMINDER <<'EOF' || true
[AXIARCH BOOT] This project enforces axiarch governance. Before responding, the AI applies AGENTS.md (supreme law — Project Configuration + 9 protocols) and LOADING_PROTOCOL.md BOOT SEQUENCE. Output language follows the Project Native Language declared in AGENTS.md and is applied to every heading, summary, label, list, and table. Loaded rule files (AGENTS.md, INDEX.md, LOADING_PROTOCOL.md, etc.) are recorded in task.md per AGENTS.md §8 (Process & Documentation, item 4 — Documentation Requirements); a missing record is treated as a protocol violation. On task completion, the AI runs CRYSTALLIZATION_PROTOCOL Step 5 THRESHOLD CHECK and, when any domain in core/010_project_lessons_log.md holds 3+ unsorted lessons, promotes them into a dedicated Blueprint file before declaring the task done — appending to core/010 alone is not completion. / 本プロジェクトは axiarch ガバナンスを採用しています。応答前に AGENTS.md（最高法規・Project Configuration + 9 プロトコル）と LOADING_PROTOCOL.md の BOOT SEQUENCE を適用します。応答言語は AGENTS.md で宣言された Project Native Language に従い、見出し・要約・ラベル・箇条書き・表すべてに適用されます。ロードしたルールファイル (AGENTS.md / INDEX.md / LOADING_PROTOCOL.md 等) は AGENTS.md §8 (Process & Documentation 第 4 項 — ドキュメント生成要件) に基づき task.md に記録されます。記録欠落はプロトコル違反として扱われます。タスク完了時は CRYSTALLIZATION_PROTOCOL Step 5 THRESHOLD CHECK を実行し、core/010_project_lessons_log.md のドメインに 3 件以上の未整理教訓がある場合は Blueprint 専用ファイルへ昇華してから完了を宣言します。core/010 への追記だけでは完了とみなされません。
EOF

# v1.6.0+ short-circuit reminder (used after TTL window when no violations)
read -r -d '' SHORT_REMINDER <<'EOF' || true
[AXIARCH OK] axiarch governance is active and recently confirmed. Continue applying AGENTS.md / LOADING_PROTOCOL / Project Native Language. Full reminder reappears on TTL expiry, violation detection, or new session. / axiarch ガバナンス継続中（直近で確認済）。AGENTS.md / LOADING_PROTOCOL / Project Native Language の適用を継続。TTL 期限切れ・違反検出・新規 session 時に full reminder が再表示されます。
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
# Check C: Stale lesson detection (date >180 days, v1.6.0+)
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
  # Check B: domain count
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

  # Check C (v1.6.0+): stale lesson detection — any [YYYY-MM-DD] dated > N days ago.
  # Skips [Initial] entries (no date). Compatible with both GNU date and BSD date.
  STALE_LIMIT_DAYS="${AXIARCH_LESSON_STALE_DAYS:-180}"
  if [[ "${STALE_LIMIT_DAYS}" -gt 0 ]]; then
    NOW_EPOCH=$(date +%s 2>/dev/null || echo "0")
    if [[ "${NOW_EPOCH}" -gt 0 ]]; then
      STALE_THRESHOLD=$(( NOW_EPOCH - STALE_LIMIT_DAYS * 86400 ))
      while IFS= read -r dated_line; do
        [[ -z "${dated_line}" ]] && continue
        lesson_date=$(printf '%s' "${dated_line}" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' | head -1)
        [[ -z "${lesson_date}" ]] && continue
        # Try GNU date first, then BSD date
        lesson_epoch=$(date -d "${lesson_date}" +%s 2>/dev/null \
          || date -j -f "%Y-%m-%d" "${lesson_date}" +%s 2>/dev/null \
          || echo "")
        [[ -z "${lesson_epoch}" ]] && continue
        if [[ "${lesson_epoch}" -lt "${STALE_THRESHOLD}" ]]; then
          age_days=$(( (NOW_EPOCH - lesson_epoch) / 86400 ))
          VIOLATIONS="${VIOLATIONS} 🚨 [VIOLATION-C] core/010 に ${age_days} 日経過の lesson あり (${lesson_date})。CRYSTALLIZATION §5 time-axis trigger により Blueprint 昇華 review せよ。/ Stale lesson dated ${lesson_date} (${age_days} days old); review for promotion per CRYSTAL §5 time-axis trigger."
          break  # first offender only
        fi
      done < <(grep -E '^### \[[0-9]{4}-[0-9]{2}-[0-9]{2}\]' "${LESSONS_LOG}" 2>/dev/null)
    fi
  fi
fi

# -----------------------------------------------------------------------------
# Check D (v1.8.0+): Task boundary detection
# Detects mismatch between current prompt's domain keywords and task.md's recorded
# load history. Forces full reminder (TTL bypass) when a new task type is detected,
# closing the "AI judges 'same session, no re-load needed' and slacks" loophole.
#
# Domain keywords (extensible via AXIARCH_TASK_DOMAIN_KEYWORDS env var):
#   security / rls / auth / authn / authz / encryption / vulnerability
#   architecture / migration / schema / refactor / restructure
#   performance / optimization / cache / latency
#   ui_design / ux / accessibility / a11y / layout
#   api / endpoint / rest / graphql / contract
#   i18n / localization / translation
#   finops / cost / billing
#   testing / qa / e2e / unit
#   deploy / release / push / pr / commit / merge / tag
# -----------------------------------------------------------------------------
TASK_BOUNDARY_DETECTED=false
if [[ "${AXIARCH_TASK_BOUNDARY_DETECT:-1}" == "1" ]] && [[ -n "${INPUT}" ]]; then
  # Extract current prompt text from JSON payload (jq optional, grep+sed fallback)
  CURRENT_PROMPT=""
  if command -v jq &>/dev/null; then
    CURRENT_PROMPT=$(printf '%s' "${INPUT}" | jq -r '.prompt // empty' 2>/dev/null || true)
  fi
  if [[ -z "${CURRENT_PROMPT}" ]]; then
    # Fallback: extract first 500 chars of "prompt" field
    CURRENT_PROMPT=$(printf '%s' "${INPUT}" \
      | grep -oE '"prompt"[[:space:]]*:[[:space:]]*"([^"\\]|\\.){0,500}"' \
      | head -1 | sed -E 's/^"prompt"[[:space:]]*:[[:space:]]*"(.*)"$/\1/')
  fi

  if [[ -n "${CURRENT_PROMPT}" ]]; then
    # Default domain keyword set (lowercased, regex-friendly)
    DOMAIN_KEYWORDS_DEFAULT="security|rls|auth|authn|authz|encryption|vulnerability|architecture|migration|schema|refactor|restructure|performance|optimization|cache|latency|ui_design|ui|ux|accessibility|a11y|layout|api|endpoint|rest|graphql|contract|i18n|localization|translation|finops|cost|billing|testing|qa|e2e|unit|deploy|release|push|pr|commit|merge|tag"
    DOMAIN_KEYWORDS="${AXIARCH_TASK_DOMAIN_KEYWORDS:-${DOMAIN_KEYWORDS_DEFAULT}}"

    # Extract domains from current prompt (whole-word match, case-insensitive, dedupe, sort).
    # -w (word match) prevents "ui_design" from greedily consuming "ui" — both
    # are matched independently when present as whole words.
    CURRENT_DOMAINS=$(printf '%s' "${CURRENT_PROMPT}" \
      | grep -oiwE "(${DOMAIN_KEYWORDS})" \
      | tr '[:upper:]' '[:lower:]' \
      | sort -u | tr '\n' ',' | sed 's/,$//')

    # Extract previously-known domains from the AGENTS §8.4 mandatory trio:
    #   task.md, implementation_plan.md, walkthrough.md
    # Rationale: domain context often lives in implementation_plan.md (the plan
    # written during task analysis) and walkthrough.md (the diff narrative),
    # not just task.md's load-history table. Reading only task.md misses
    # plan-side domains and produces false-positive VIOLATION-D for tasks
    # whose plan is already consistent with the current prompt.
    # Scan strategy: full-text grep over all 3 files (each is small per-task
    # ephemeral doc), dedupe + sort.
    PREV_DOMAINS=""
    PREV_SOURCES=""
    for fname in task.md implementation_plan.md walkthrough.md; do
      fpath="${PROJECT_DIR}/${fname}"
      [[ -f "${fpath}" ]] || continue
      file_domains=$(grep -oiwE "(${DOMAIN_KEYWORDS})" "${fpath}" 2>/dev/null \
        | tr '[:upper:]' '[:lower:]' | sort -u)
      if [[ -n "${file_domains}" ]]; then
        PREV_DOMAINS+="${file_domains}"$'\n'
        PREV_SOURCES+="${fname} "
      fi
    done
    PREV_DOMAINS=$(printf '%s' "${PREV_DOMAINS}" | sort -u | tr '\n' ',' | sed 's/,$//')

    # Compare: domain shift detected if current ∋ keyword AND keyword ∉ previous
    if [[ -n "${CURRENT_DOMAINS}" ]]; then
      NEW_DOMAINS=""
      IFS=',' read -ra CUR_ARR <<< "${CURRENT_DOMAINS}"
      for kw in "${CUR_ARR[@]}"; do
        [[ -z "${kw}" ]] && continue
        if [[ -z "${PREV_DOMAINS}" ]] || ! printf '%s' ",${PREV_DOMAINS}," | grep -qF ",${kw},"; then
          NEW_DOMAINS+="${kw} "
        fi
      done
      NEW_DOMAINS=$(printf '%s' "${NEW_DOMAINS}" | sed 's/[[:space:]]*$//')
      if [[ -n "${NEW_DOMAINS}" ]]; then
        SCANNED_SOURCES=$(printf '%s' "${PREV_SOURCES}" | sed 's/[[:space:]]*$//')
        [[ -z "${SCANNED_SOURCES}" ]] && SCANNED_SOURCES="(none)"
        VIOLATIONS="${VIOLATIONS} 🚨 [VIOLATION-D] task boundary detected — current prompt domain (${CURRENT_DOMAINS}) introduces new keyword(s) (${NEW_DOMAINS}) not found in scanned process docs (${SCANNED_SOURCES}). Per LOADING_PROTOCOL §4 'task type changed' rule, the AI MUST load the corresponding domain rule files AND update task.md / implementation_plan.md BEFORE proceeding. / 現プロンプトに process docs (${SCANNED_SOURCES}) に無い新しい domain keyword (${NEW_DOMAINS}) が含まれる。LOADING_PROTOCOL §4「タスクタイプ変更あり」ルールに従い、対応 domain rule ファイルをロードし task.md / implementation_plan.md を更新してから作業せよ。"
        TASK_BOUNDARY_DETECTED=true
      fi
    fi
  fi
fi

# -----------------------------------------------------------------------------
# v1.6.0+ Two-stage output: TTL state management
# -----------------------------------------------------------------------------
TTL_SECONDS="${AXIARCH_REMINDER_TTL_SECONDS:-1800}"  # default 30 min, 0 disables short-circuit
PROJECT_HASH=$(printf '%s' "${PROJECT_DIR}" | shasum 2>/dev/null | awk '{print $1}' | head -c 12)
[[ -z "${PROJECT_HASH}" ]] && PROJECT_HASH="default"
STATE_DIR="${TMPDIR:-/tmp}"
STATE_FILE="${STATE_DIR}/axiarch-reminder-${PROJECT_HASH}.timestamp"

USE_SHORT=false
if [[ -z "${VIOLATIONS}" ]] && [[ "${TTL_SECONDS}" -gt 0 ]]; then
  if [[ -f "${STATE_FILE}" ]]; then
    LAST_FULL_EPOCH=$(cat "${STATE_FILE}" 2>/dev/null | head -1 | tr -d '[:space:]')
    if [[ -n "${LAST_FULL_EPOCH}" ]] && [[ "${LAST_FULL_EPOCH}" =~ ^[0-9]+$ ]]; then
      NOW_EPOCH_TTL=$(date +%s 2>/dev/null || echo "0")
      AGE=$(( NOW_EPOCH_TTL - LAST_FULL_EPOCH ))
      if [[ "${NOW_EPOCH_TTL}" -gt 0 ]] && [[ "${AGE}" -ge 0 ]] && [[ "${AGE}" -lt "${TTL_SECONDS}" ]]; then
        USE_SHORT=true
      fi
    fi
  fi
fi

# -----------------------------------------------------------------------------
# Compose final reminder
# -----------------------------------------------------------------------------
if "${USE_SHORT}"; then
  FULL_REMINDER="${SHORT_REMINDER}"
else
  if [[ -n "${VIOLATIONS}" ]]; then
    FULL_REMINDER="${CORE_REMINDER}${VIOLATIONS}"
  else
    FULL_REMINDER="${CORE_REMINDER}"
  fi
  # Update timestamp only on full-reminder fire (not short-circuit)
  if [[ "${TTL_SECONDS}" -gt 0 ]]; then
    date +%s > "${STATE_FILE}" 2>/dev/null || true
  fi
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
