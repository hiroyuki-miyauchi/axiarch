#!/usr/bin/env bash
# =============================================================================
# Axiarch Health Diagnostic Tool
# https://github.com/hiroyuki-miyauchi/axiarch
#
# Usage:
#   bash axiarch-scripts/check-axiarch-health.sh [PROJECT_DIR] [--quiet|-q]
#
# --quiet : suppress all output except errors (for pre-commit hook usage)
#
# Diagnoses Axiarch enforcement health across 15 verifiable stages spanning
# the Hook layer, LOADING_PROTOCOL, CRYSTALLIZATION_PROTOCOL, AGENTS.md
# protocols (§1, §2, §4, §6, §8, §9 — verifiable subset), the v1.5.5
# physical-block / bootstrap hooks, the v1.6.0 sublimated-file guide, and the
# v1.8.0 task-boundary detection:
#
#   Check 1-4  Hook layer when installed (settings detection, JSON syntax, hook structure, firing log)
#   Check 5    LOADING_PROTOCOL Step 4 — task.md adherence
#   Check 6    CRYSTALLIZATION_PROTOCOL §5 — count threshold (3+) + time-axis (>180d, v1.6.0+)
#   Check 7    AGENTS §8 Process & Documentation — task docs presence
#   Check 8    AGENTS §1 Deployment Ban — push hygiene
#   Check 9    AGENTS §4 SSOT Sync — main parity
#   Check 10   AGENTS §2 Language First — Project Native Language consistency
#   Check 11   AGENTS §6 ANTI-FULL-OVERWRITE — PreToolUse hook physical block (v1.5.5+)
#   Check 12   Bootstrap — SessionStart hook wiring (task.md auto-init, v1.5.5+)
#   Check 13   Sublimated files index — APPEND candidates (v1.6.0+)
#   Check 14   Task boundary detection — Check D wiring in axiarch-boot-reminder.sh (v1.8.0+)
#   Check 15   v1.9+ / v1.11+ integration — PostToolUse diff guard + task-state lifecycle + release/docs/prompt parity + source release-file tracking
#
# Out of Scope (semantic judgment required, manual review):
#   §0 AI Self-Completion / §3 DB Integrity / §5 Existing Functionality Protection
#   §7 Role & Behavior
#
# Designed to detect the "AI adherence gap" early and force tool-based remediation
# instead of leaving users to manually debug.
# =============================================================================

set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

# v1.6.0+: --quiet flag suppresses verbose output (for pre-commit hook usage).
# Errors / warnings still go to stderr; exit code conveys overall result.
QUIET_MODE=false
ARGS=()
for arg in "$@"; do
  case "$arg" in
    --quiet|-q) QUIET_MODE=true ;;
    *) ARGS+=("$arg") ;;
  esac
done
set -- "${ARGS[@]+"${ARGS[@]}"}"

if "${QUIET_MODE}"; then
  print_pass()    { :; }
  print_fail()    { echo -e "${RED}❌ $1${RESET}" >&2; }
  print_warn()    { :; }
  print_info()    { :; }
  print_section() { :; }
else
  print_pass()    { echo -e "${GREEN}✅ $1${RESET}"; }
  print_fail()    { echo -e "${RED}❌ $1${RESET}"; }
  print_warn()    { echo -e "${YELLOW}⚠️  $1${RESET}"; }
  print_info()    { echo -e "   ${CYAN}→${RESET} $1"; }
  print_section() { echo ""; echo -e "${BOLD}${BLUE}== $1 ==${RESET}"; }
fi

PROJECT_DIR="${1:-$(pwd)}"
EXIT_CODE=0
HOOK_FILE_OK=true
HOOK_JSON_OK=true

if ! "${QUIET_MODE}"; then
  echo ""
  echo -e "${BOLD}${CYAN}🛡️  Axiarch Health Diagnostic — $(date +%Y-%m-%d\ %H:%M:%S)${RESET}"
  echo "   Project: ${PROJECT_DIR}"
fi

# =============================================================================
# =============================================================================
# Check 1: Hook configuration detection
# =============================================================================
print_section "Check 1: Hook config (.claude/settings.json or .codex/hooks.json)"

HOOK_FILE_PATH=""
if [[ -f "${PROJECT_DIR}/.claude/settings.json" ]]; then
  HOOK_FILE_PATH="${PROJECT_DIR}/.claude/settings.json"
elif [[ -f "${PROJECT_DIR}/.codex/hooks.json" ]]; then
  HOOK_FILE_PATH="${PROJECT_DIR}/.codex/hooks.json"
fi

if [[ -n "${HOOK_FILE_PATH}" ]]; then
  print_pass "File exists: ${HOOK_FILE_PATH}"
else
  print_warn "No Claude/Codex hook configuration found — optional hook layer is not enabled"
  print_info "Hook wiring is strict only for projects that installed .claude/settings.json or .codex/hooks.json"
  print_info "(Continuing with remaining checks for full-protocol coverage)"
  HOOK_FILE_OK=false
fi

# =============================================================================
# Check 2: JSON syntax
# =============================================================================
print_section "Check 2: JSON syntax"
if ! "${HOOK_FILE_OK}"; then
  print_warn "Skipped — settings.json not present (see Check 1)"
  HOOK_JSON_OK=false
elif command -v jq &>/dev/null; then
  if jq . "${HOOK_FILE_PATH}" >/dev/null 2>&1; then
    print_pass "Valid JSON"
  else
    print_fail "JSON parse error"
    print_info "Run: jq . ${HOOK_FILE_PATH}"
    HOOK_JSON_OK=false
    EXIT_CODE=1
  fi
else
  print_warn "jq not installed — skipping JSON syntax check"
  print_info "Install jq for full diagnostics: brew install jq / apt install jq"
fi

# =============================================================================
# Check 3: UserPromptSubmit hook structure & Axiarch marker
# =============================================================================
print_section "Check 3: UserPromptSubmit hook structure"
if ! "${HOOK_FILE_OK}" || ! "${HOOK_JSON_OK}"; then
  print_warn "Skipped — settings.json missing or invalid (see Check 1/2)"
elif command -v jq &>/dev/null; then
  HOOK_COUNT=$(jq '[.hooks.UserPromptSubmit[]?.hooks[]?] | length' \
    "${HOOK_FILE_PATH}" 2>/dev/null || echo "0")
  if [[ "${HOOK_COUNT}" -gt 0 ]]; then
    print_pass "UserPromptSubmit hook defined (${HOOK_COUNT} entries)"
    HOOK_CMD=$(jq -r '[.hooks.UserPromptSubmit[]?.hooks[]?.command // empty][0]' \
      "${HOOK_FILE_PATH}" 2>/dev/null)
    # AXIARCH BOOT marker can live in two places:
    #   (1) directly in the inline command (v1.4.0–v1.5.2)
    #   (2) in axiarch-scripts/axiarch-boot-reminder.sh referenced by the command (v1.5.3+)
    if [[ "${HOOK_CMD}" == *"AXIARCH BOOT"* ]]; then
      print_pass "Axiarch BOOT marker present (inline)"
    elif [[ "${HOOK_CMD}" == *"axiarch-boot-reminder.sh"* ]]; then
      # v1.5.3+ externalized form: check the referenced script
      REMINDER_SCRIPT="${PROJECT_DIR}/axiarch-scripts/axiarch-boot-reminder.sh"
      if [[ -f "${REMINDER_SCRIPT}" ]] && grep -q "AXIARCH BOOT" "${REMINDER_SCRIPT}" 2>/dev/null; then
        print_pass "Axiarch BOOT marker present (via axiarch-scripts/axiarch-boot-reminder.sh)"
      else
        print_warn "Hook references axiarch-boot-reminder.sh but the script is missing or lacks the marker"
        print_info "Re-run init.sh or copy axiarch-scripts/axiarch-boot-reminder.sh from axiarch repo"
        EXIT_CODE=1
      fi
    else
      print_warn "Hook command does not contain '[AXIARCH BOOT]' marker (inline or via reminder script)"
      print_info "Replace with the official axiarch settings.json (delegates to axiarch-scripts/axiarch-boot-reminder.sh)"
      EXIT_CODE=1
    fi
  else
    print_fail "No UserPromptSubmit hook entries found"
    EXIT_CODE=1
  fi
else
  print_warn "Skipped (jq not installed)"
fi

# =============================================================================
# Check 4: Session log firing history (technical firing)
# =============================================================================
print_section "Check 4: Recent session firing history"
PROJECT_KEY=$(echo "${PROJECT_DIR}" | sed 's|/|-|g')
SESSION_DIR="${HOME}/.claude/projects/${PROJECT_KEY}"

if ! "${HOOK_FILE_OK}"; then
  print_warn "Skipped — optional hook layer is not installed (see Check 1)"
elif [[ -n "${CODEX_THREAD_ID:-}" || -n "${CODEX_CI:-}" || "${__CFBundleIdentifier:-}" == "com.openai.codex" ]]; then
  print_pass "Codex runtime detected — Claude Code hook firing history is not applicable"
elif [[ "${HOOK_FILE_PATH}" == */.codex/hooks.json ]]; then
  print_warn "Codex hook config detected — Claude Code session log firing history is not applicable"
  print_info "Codex hook validation is limited to structural checks in this diagnostic"
elif [[ -d "${SESSION_DIR}" ]]; then
  LATEST_JSONL=$(find "${SESSION_DIR}" -maxdepth 2 -name "*.jsonl" -type f 2>/dev/null \
    | xargs ls -t 2>/dev/null | head -1)
  if [[ -n "${LATEST_JSONL}" ]]; then
    print_info "Latest session: $(basename "${LATEST_JSONL}")"
    # v1.5.2+: hook output uses hookSpecificOutput.additionalContext format,
    # so transcripts log "UserPromptSubmit hook additional context" instead of
    # the legacy "UserPromptSubmit hook success". Match both for compatibility.
    FIRE_COUNT=$(grep -cE "UserPromptSubmit hook (success|additional context)" "${LATEST_JSONL}" 2>/dev/null || true)
    FIRE_COUNT="${FIRE_COUNT:-0}"
    USER_TURN_COUNT=$(grep -c '"type":"user"' "${LATEST_JSONL}" 2>/dev/null || true)
    USER_TURN_COUNT="${USER_TURN_COUNT:-0}"
    if [[ "${FIRE_COUNT}" -gt 0 ]]; then
      print_pass "Hook fired ${FIRE_COUNT} times in latest session"
      print_info "(user-turn count is approximate; nested messages may inflate it)"
    else
      print_fail "Hook never fired in latest session"
      print_info "→ Restart Claude Code; the hook activates on session start"
      EXIT_CODE=1
    fi
  else
    print_warn "No JSONL session logs in ${SESSION_DIR}"
    print_info "→ Start a Claude Code session and send at least one prompt"
  fi
else
  print_warn "Session directory not found: ${SESSION_DIR}"
  print_info "→ Claude Code may not have run in this project yet"
fi

# =============================================================================
# Check 5: AI adherence — task.md load history
# =============================================================================
print_section "Check 5: AI adherence (task.md load history)"
if [[ -f "${PROJECT_DIR}/task.md" ]]; then
  RULE_REFS=$(grep -cE "AGENTS\.md|INDEX\.md|LOADING_PROTOCOL\.md" \
    "${PROJECT_DIR}/task.md" 2>/dev/null || true)
  RULE_REFS="${RULE_REFS:-0}"
  if [[ "${RULE_REFS}" -gt 0 ]]; then
    print_pass "task.md contains ${RULE_REFS} rule file references — AI adhered"
  else
    print_warn "task.md exists but no rule references"
    print_info "→ Hook fires but AI is not adhering. Re-instruct: 'Log loaded rules in task.md'"
    EXIT_CODE=1
  fi
else
  print_warn "task.md not found"
  print_info "→ Created on first task per AGENTS.md §8.4. Send a prompt to trigger creation."
fi

# =============================================================================
# Check 6: Crystallization Protocol compliance (lessons_log threshold)
# =============================================================================
print_section "Check 6: Crystallization Protocol — lessons_log threshold"

LESSONS_LOG=""
for lang in ja en; do
  candidate="${PROJECT_DIR}/axiarch-rules/${lang}/blueprint/core/010_project_lessons_log.md"
  if [[ -f "${candidate}" ]]; then
    LESSONS_LOG="${candidate}"
    break
  fi
done

if [[ -n "${LESSONS_LOG}" ]]; then
  print_info "Lessons log: ${LESSONS_LOG}"
  # Extract Domain tags from the "未分類" / "Unsorted" section onwards.
  # Pattern: "**Domain:** XXX" or "Domain: XXX"
  DOMAIN_LIST=$(grep -E "^\*\*Domain:\*\*|^Domain:" "${LESSONS_LOG}" 2>/dev/null \
    | sed -E 's|^\*\*Domain:\*\*[[:space:]]*||; s|^Domain:[[:space:]]*||' \
    | awk -F'/' '{print $1}' | awk '{$1=$1; print}' | sort)
  if [[ -z "${DOMAIN_LIST}" ]]; then
    print_pass "No unsorted lessons (or no Domain tags) detected — protocol clean"
  else
    OFFENDERS=""
    while IFS= read -r line; do
      # Trim leading/trailing whitespace
      domain=$(echo "${line}" | awk '{$1=$1; print}')
      [[ -z "${domain}" ]] && continue
      count=$(echo "${DOMAIN_LIST}" | grep -cFx "${domain}" || true)
      count="${count:-0}"
      if [[ "${count}" -ge 3 ]]; then
        OFFENDERS+="${domain} (${count} lessons)\n"
      fi
    done < <(echo "${DOMAIN_LIST}" | sort -u)

    if [[ -n "${OFFENDERS}" ]]; then
      print_fail "Crystallization threshold breached — ${LESSONS_LOG}"
      echo "   Domains with 3+ unsorted lessons:"
      printf '%b' "${OFFENDERS}" | awk 'NF {print "     - " $0}'
      print_info "→ Per CRYSTALLIZATION_PROTOCOL §5 trigger (a), the AI MUST create a"
      print_info "   dedicated domain file in the corresponding Blueprint folder and"
      print_info "   migrate these lessons. Re-instruct the AI: 'Execute CRYSTALLIZATION"
      print_info "   PROTOCOL Step 5 — promote 3+ accumulated domains to dedicated files'."
      EXIT_CODE=1
    else
      DOMAIN_COUNT=$(echo "${DOMAIN_LIST}" | sort -u | wc -l | awk '{print $1}')
      print_pass "Below count threshold (${DOMAIN_COUNT} domains, all <3 lessons)"
    fi
  fi

  # ---------------------------------------------------------------------------
  # Check 6 (v1.6.0+): Time-axis trigger — stale lesson detection
  # CRYSTALLIZATION_PROTOCOL §5 trigger (b): any lesson dated > N days ago
  # ---------------------------------------------------------------------------
  STALE_DAYS_LIMIT="${AXIARCH_LESSON_STALE_DAYS:-180}"
  if [[ "${STALE_DAYS_LIMIT}" -gt 0 ]]; then
    NOW_EPOCH_C6=$(date +%s 2>/dev/null || echo "0")
    if [[ "${NOW_EPOCH_C6}" -gt 0 ]]; then
      THRESHOLD_C6=$(( NOW_EPOCH_C6 - STALE_DAYS_LIMIT * 86400 ))
      STALE_FOUND=""
      while IFS= read -r dated_line; do
        [[ -z "${dated_line}" ]] && continue
        l_date=$(printf '%s' "${dated_line}" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' | head -1)
        [[ -z "${l_date}" ]] && continue
        l_epoch=$(date -d "${l_date}" +%s 2>/dev/null \
          || date -j -f "%Y-%m-%d" "${l_date}" +%s 2>/dev/null \
          || echo "")
        [[ -z "${l_epoch}" ]] && continue
        if [[ "${l_epoch}" -lt "${THRESHOLD_C6}" ]]; then
          age=$(( (NOW_EPOCH_C6 - l_epoch) / 86400 ))
          STALE_FOUND+="${l_date} (${age} days old)\n"
        fi
      done < <(grep -E '^### \[[0-9]{4}-[0-9]{2}-[0-9]{2}\]' "${LESSONS_LOG}" 2>/dev/null)
      if [[ -n "${STALE_FOUND}" ]]; then
        print_fail "Crystallization time-axis trigger breached — stale lesson(s) detected:"
        printf '%b' "${STALE_FOUND}" | awk 'NF {print "     - " $0}'
        print_info "→ Per CRYSTALLIZATION_PROTOCOL §5 trigger (b), the AI MUST review"
        print_info "   stale lessons (>${STALE_DAYS_LIMIT} days) and either promote them to a Blueprint"
        print_info "   file or update them with current understanding."
        EXIT_CODE=1
      else
        print_pass "Below time-axis threshold (no lesson older than ${STALE_DAYS_LIMIT} days)"
      fi
    fi
  fi
else
  print_warn "010_project_lessons_log.md not found in expected paths"
  print_info "→ Skip if axiarch-rules/{ja|en}/blueprint/ is not deployed yet"
fi

# =============================================================================
# Check 7: AGENTS.md §8 Process & Documentation (task docs)
# =============================================================================
print_section "Check 7: §8 Process & Documentation (task docs)"

DOCS_OK=0
DOCS_MISSING=()
for f in task.md implementation_plan.md walkthrough.md; do
  if [[ -f "${PROJECT_DIR}/${f}" ]]; then
    SIZE=$(wc -c < "${PROJECT_DIR}/${f}" 2>/dev/null | awk '{print $1}')
    if [[ "${SIZE:-0}" -gt 0 ]]; then
      DOCS_OK=$((DOCS_OK + 1))
    else
      DOCS_MISSING+=("${f} (empty)")
    fi
  else
    DOCS_MISSING+=("${f} (not found)")
  fi
done

if [[ "${DOCS_OK}" -eq 3 ]]; then
  print_pass "All three documents present and non-empty (task / implementation_plan / walkthrough)"
elif [[ "${DOCS_OK}" -gt 0 ]]; then
  print_warn "Partial: ${DOCS_OK}/3 documents present"
  for missing in "${DOCS_MISSING[@]}"; do
    print_info "Missing/empty: ${missing}"
  done
  print_info "→ Per AGENTS.md §8.4, all three are 'always create' — generate before any task"
  EXIT_CODE=1
else
  print_warn "None of task.md / implementation_plan.md / walkthrough.md exist"
  print_info "→ AGENTS.md §8.4 mandates 'always create' — these are gitignored per-session docs"
fi

# =============================================================================
# Check 8: AGENTS.md §1 Deployment Ban (force-push / direct main commits)
# =============================================================================
print_section "Check 8: §1 Deployment Ban (recent push hygiene)"

if [[ -d "${PROJECT_DIR}/.git" ]] || git -C "${PROJECT_DIR}" rev-parse --git-dir >/dev/null 2>&1; then
  # Look for recent reflog entries indicating force-push
  FORCE_PUSH_COUNT=$(git -C "${PROJECT_DIR}" reflog --all 2>/dev/null \
    | grep -cE "forced-update|force-with-lease" || true)
  FORCE_PUSH_COUNT="${FORCE_PUSH_COUNT:-0}"
  # Recent direct main commits (last 5)
  CURRENT_BRANCH=$(git -C "${PROJECT_DIR}" branch --show-current 2>/dev/null || echo "")
  if [[ "${CURRENT_BRANCH}" == "main" || "${CURRENT_BRANCH}" == "master" ]]; then
    print_warn "On ${CURRENT_BRANCH} branch directly"
    print_info "→ §1 Deployment Ban: avoid working on main/master, use feature branches"
  else
    print_pass "On feature branch: ${CURRENT_BRANCH}"
  fi
  if [[ "${FORCE_PUSH_COUNT}" -gt 0 ]]; then
    print_warn "Detected ${FORCE_PUSH_COUNT} force-push entries in reflog"
    print_info "→ Force-pushes should be rare and explicitly user-approved per memory policy"
  else
    print_pass "No force-push entries in recent reflog"
  fi
else
  print_warn "Not a git repository — skipping deployment ban checks"
fi

# =============================================================================
# Check 9: AGENTS.md §4 SSOT Sync (main parity)
# =============================================================================
print_section "Check 9: §4 SSOT Sync (main parity)"

if git -C "${PROJECT_DIR}" rev-parse --git-dir >/dev/null 2>&1; then
  CURRENT_BRANCH=$(git -C "${PROJECT_DIR}" branch --show-current 2>/dev/null || echo "")
  if [[ -n "${CURRENT_BRANCH}" ]]; then
    if git -C "${PROJECT_DIR}" rev-parse origin/main >/dev/null 2>&1; then
      BEHIND=$(git -C "${PROJECT_DIR}" rev-list --count "${CURRENT_BRANCH}..origin/main" 2>/dev/null || echo "0")
      AHEAD=$(git -C "${PROJECT_DIR}" rev-list --count "origin/main..${CURRENT_BRANCH}" 2>/dev/null || echo "0")
      if [[ "${BEHIND:-0}" -eq 0 ]]; then
        print_pass "Up-to-date with origin/main (ahead: ${AHEAD:-0})"
      elif [[ "${BEHIND:-0}" -lt 5 ]]; then
        print_warn "Behind origin/main by ${BEHIND} commits"
        print_info "→ Run \`git pull origin main\` to sync (per §4 SSOT Sync)"
      else
        print_fail "Significantly behind origin/main by ${BEHIND} commits"
        print_info "→ §4 mandates main sync — pull before continuing work"
        EXIT_CODE=1
      fi
    else
      print_warn "origin/main reference not found — run \`git fetch origin\` first"
    fi
  fi
else
  print_warn "Not a git repository — skipping SSOT sync check"
fi

# =============================================================================
# Check 10: AGENTS.md §2 Language First (Project Native Language consistency)
# =============================================================================
print_section "Check 10: §2 Language First (Project Native Language)"

NATIVE_LANG=""
if [[ -f "${PROJECT_DIR}/AGENTS.md" ]]; then
  NATIVE_LANG_LINE=$(grep -iE "Project Native Language" "${PROJECT_DIR}/AGENTS.md" 2>/dev/null | head -1 || true)
  NATIVE_LANG_LOWER=$(printf '%s\n' "${NATIVE_LANG_LINE}" | tr '[:upper:]' '[:lower:]')
  NATIVE_LANG_CONFIG="${NATIVE_LANG_LOWER%%default:*}"
  NATIVE_LANG_DEFAULT=""
  if [[ "${NATIVE_LANG_LOWER}" == *"default:"* ]]; then
    NATIVE_LANG_DEFAULT="${NATIVE_LANG_LOWER#*default:}"
  fi
  if [[ "${NATIVE_LANG_CONFIG}" == *"english"* && "${NATIVE_LANG_CONFIG}" != *"japanese"* ]]; then
    NATIVE_LANG="english"
  elif [[ "${NATIVE_LANG_CONFIG}" == *"japanese"* && "${NATIVE_LANG_CONFIG}" != *"english"* ]]; then
    NATIVE_LANG="japanese"
  elif [[ "${NATIVE_LANG_DEFAULT}" == *"english"* && "${NATIVE_LANG_DEFAULT}" != *"japanese"* ]]; then
    NATIVE_LANG="english"
  elif [[ "${NATIVE_LANG_DEFAULT}" == *"japanese"* && "${NATIVE_LANG_DEFAULT}" != *"english"* ]]; then
    NATIVE_LANG="japanese"
  fi
fi

if [[ -z "${NATIVE_LANG}" ]]; then
  print_warn "Could not detect Project Native Language in AGENTS.md"
  print_info "→ Verify AGENTS.md Project Configuration section"
else
  print_info "Project Native Language: ${NATIVE_LANG}"
  language_docs_found=0
  process_docs=(task.md implementation_plan.md walkthrough.md)
  if [[ "${NATIVE_LANG}" == "japanese" ]]; then
    # Heuristic: count headings starting with ASCII alpha (may include acronyms like TODO/KPI).
    ASCII_HEADINGS=0
    for process_doc in "${process_docs[@]}"; do
      process_doc_path="${PROJECT_DIR}/${process_doc}"
      if [[ -f "${process_doc_path}" ]]; then
        language_docs_found=1
        doc_ascii_headings=$(grep -cE "^#+\s+[A-Za-z]" "${process_doc_path}" 2>/dev/null || true)
        ASCII_HEADINGS=$((ASCII_HEADINGS + ${doc_ascii_headings:-0}))
      fi
    done
    if [[ "${language_docs_found}" -eq 0 ]]; then
      print_pass "Language consistency check skipped (no process docs)"
    elif [[ "${ASCII_HEADINGS}" -gt 5 ]]; then
      print_info "process docs contain ${ASCII_HEADINGS} ASCII-leading headings"
      print_info "(may be acronyms like TODO/KPI — manual review recommended)"
    else
      print_pass "process doc headings appear consistent with Japanese Project Native Language"
    fi
  elif [[ "${NATIVE_LANG}" == "english" ]]; then
    CJK_TEXT_COUNT=0
    for process_doc in "${process_docs[@]}"; do
      process_doc_path="${PROJECT_DIR}/${process_doc}"
      if [[ -f "${process_doc_path}" ]]; then
        language_docs_found=1
        doc_cjk_count=$(grep -cE "[ぁ-んァ-ン一-龥]" "${process_doc_path}" 2>/dev/null || true)
        CJK_TEXT_COUNT=$((CJK_TEXT_COUNT + ${doc_cjk_count:-0}))
      fi
    done
    if [[ "${language_docs_found}" -eq 0 ]]; then
      print_pass "Language consistency check skipped (no process docs)"
    elif [[ "${CJK_TEXT_COUNT}" -gt 0 ]]; then
      print_warn "process docs contain ${CJK_TEXT_COUNT} CJK text lines in an English project"
      print_info "→ Verify task.md / implementation_plan.md / walkthrough.md are generated and maintained in Project Native Language"
      EXIT_CODE=1
    else
      print_pass "process docs appear consistent with English Project Native Language"
    fi
  fi
fi

# =============================================================================
# Check 11: Physical Block — PreToolUse hook wiring (v1.5.5+)
# =============================================================================
print_section "Check 11: PreToolUse hook (§6 ANTI-FULL-OVERWRITE physical block)"
if ! "${HOOK_FILE_OK}" || ! "${HOOK_JSON_OK}"; then
  print_warn "Skipped — settings.json missing or invalid (see Check 1/2)"
elif command -v jq &>/dev/null; then
  PRE_HOOK_CMD=$(jq -r '[.hooks.PreToolUse[]?.hooks[]?.command // empty][0] // empty' \
    "${HOOK_FILE_PATH}" 2>/dev/null)
  if [[ -z "${PRE_HOOK_CMD}" ]]; then
    print_warn "PreToolUse hook not configured — §6 violations cannot be physically blocked"
    print_info "Add a PreToolUse hook calling axiarch-scripts/axiarch-protect-antifull.sh (Write matcher)"
    print_info "(reminder-only enforcement is insufficient per Control Illusion arXiv:2502.15851)"
  elif [[ "${PRE_HOOK_CMD}" == *"axiarch-protect-antifull.sh"* ]]; then
    PROTECT_SCRIPT="${PROJECT_DIR}/axiarch-scripts/axiarch-protect-antifull.sh"
    if [[ -f "${PROTECT_SCRIPT}" ]] && [[ -x "${PROTECT_SCRIPT}" ]]; then
      print_pass "PreToolUse hook wired to axiarch-scripts/axiarch-protect-antifull.sh"
    else
      print_warn "PreToolUse hook references the script but it is missing or not executable"
      print_info "Re-run init.sh to redistribute and chmod +x"
      EXIT_CODE=1
    fi
  else
    print_info "PreToolUse hook present but does not reference the official axiarch script"
    print_info "(custom hook detected — manual review recommended)"
  fi
else
  print_warn "Skipped (jq not installed)"
fi

# =============================================================================
# Check 12: Bootstrap — SessionStart hook wiring (v1.5.5+ / v1.11.0+ task-state lifecycle)
# =============================================================================
print_section "Check 12: SessionStart hook (task.md auto-bootstrap)"
if ! "${HOOK_FILE_OK}" || ! "${HOOK_JSON_OK}"; then
  print_warn "Skipped — settings.json missing or invalid (see Check 1/2)"
elif command -v jq &>/dev/null; then
  SS_HOOK_CMD=$(jq -r '[.hooks.SessionStart[]?.hooks[]?.command // empty][0] // empty' \
    "${HOOK_FILE_PATH}" 2>/dev/null)
  if [[ -z "${SS_HOOK_CMD}" ]]; then
    print_warn "SessionStart hook not configured — task.md will not be auto-initialised"
    print_info "Add a SessionStart hook calling axiarch-scripts/axiarch-init-task-md.sh"
  elif [[ "${SS_HOOK_CMD}" == *"axiarch-init-task-md.sh"* ]]; then
    INIT_SCRIPT="${PROJECT_DIR}/axiarch-scripts/axiarch-init-task-md.sh"
    if [[ -f "${INIT_SCRIPT}" ]] && [[ -x "${INIT_SCRIPT}" ]]; then
      print_pass "SessionStart hook wired to axiarch-scripts/axiarch-init-task-md.sh"
      TASK_STATE_SCRIPT="${PROJECT_DIR}/axiarch-scripts/axiarch-task-state.sh"
      if [[ -f "${TASK_STATE_SCRIPT}" && -x "${TASK_STATE_SCRIPT}" ]] \
        && grep -q "axiarch-task-state.sh" "${INIT_SCRIPT}" 2>/dev/null \
        && grep -q "update_plan" "${INIT_SCRIPT}" 2>/dev/null \
        && grep -q "TaskCreate" "${INIT_SCRIPT}" 2>/dev/null \
        && grep -q "AXIARCH_PROCESS_DOC_LANG" "${TASK_STATE_SCRIPT}" 2>/dev/null \
        && grep -q "write_task_md_ja" "${TASK_STATE_SCRIPT}" 2>/dev/null \
        && grep -q "write_task_md_en" "${TASK_STATE_SCRIPT}" 2>/dev/null \
        && grep -q "write_implementation_plan_md_ja" "${TASK_STATE_SCRIPT}" 2>/dev/null \
        && grep -q "write_implementation_plan_md_en" "${TASK_STATE_SCRIPT}" 2>/dev/null \
        && grep -q "write_walkthrough_md_ja" "${TASK_STATE_SCRIPT}" 2>/dev/null \
        && grep -q "write_walkthrough_md_en" "${TASK_STATE_SCRIPT}" 2>/dev/null; then
        print_pass "SessionStart task-state lifecycle wired (task.md / implementation_plan.md / walkthrough.md current-task refresh with Project Native Language templates)"
      else
        print_warn "SessionStart task-state lifecycle may be incomplete"
        print_info "Expected axiarch-init-task-md.sh to call axiarch-task-state.sh, mention Codex update_plan plus Claude Code TaskCreate, and provide Project Native Language template selection"
        EXIT_CODE=1
      fi
    else
      print_warn "SessionStart hook references the script but it is missing or not executable"
      print_info "Re-run init.sh to redistribute and chmod +x"
      EXIT_CODE=1
    fi
  else
    print_info "SessionStart hook present but does not reference the official axiarch script"
    print_info "(custom hook detected — manual review recommended)"
  fi
else
  print_warn "Skipped (jq not installed)"
fi

# =============================================================================
# Check 13: Existing sublimated files — APPEND candidates (v1.6.0+)
# Surfaces existing crystallized lessons files so the AI can APPEND to them
# instead of accumulating new lessons in core/010 (which often leaves them
# below the 3+ count threshold and untouched indefinitely).
# =============================================================================
print_section "Check 13: Existing sublimated files (APPEND candidates)"
SUBLIMATED_FOUND=""
for lang in ja en; do
  blueprint_dir="${PROJECT_DIR}/axiarch-rules/${lang}/blueprint"
  [[ -d "${blueprint_dir}" ]] || continue
  # Find domain-folder files (NNN_topic.md) excluding core/000/010/998/999
  while IFS= read -r f; do
    base=$(basename "${f}")
    domain=$(basename "$(dirname "${f}")")
    # Skip core templates / index
    [[ "${domain}" == "core" ]] && [[ "${base}" =~ ^(000|010|998|999) ]] && continue
    # Skip README files
    [[ "${base}" == "README.md" ]] && continue
    # Match pattern: NNN_topic.md
    if [[ "${base}" =~ ^[0-9]{3}_ ]]; then
      SUBLIMATED_FOUND+="${domain}/${base}\n"
    fi
  done < <(find "${blueprint_dir}" -mindepth 2 -maxdepth 2 -name "*.md" -type f 2>/dev/null | sort)
  [[ -n "${SUBLIMATED_FOUND}" ]] && break  # one language is enough
done

if [[ -z "${SUBLIMATED_FOUND}" ]]; then
  print_info "No sublimated files yet — new lessons will accumulate in core/010 until count/time triggers fire"
else
  print_pass "Sublimated files exist — prefer APPEND over new core/010 entry when domain matches:"
  if ! "${QUIET_MODE}"; then
    printf '%b' "${SUBLIMATED_FOUND}" | awk 'NF {print "     - blueprint/" $0}'
    print_info "(per CRYSTALLIZATION_PROTOCOL §3 SEARCH: AI should APPEND to existing"
    print_info " domain files first, only adding to core/010 if no match found)"
  fi
fi

# =============================================================================
# Check 14: Task Boundary Detection — Check D wiring (v1.8.0+)
# Verifies that axiarch-scripts/axiarch-boot-reminder.sh contains the Check D logic
# (VIOLATION-D + TTL bypass on domain-keyword shift). This closes the AI's
# "same session, no re-load needed" self-judgment loophole identified by
# adopter feedback.
# =============================================================================
print_section "Check 14: Task boundary detection (Check D wiring)"
REMINDER_SCRIPT_PATH="${PROJECT_DIR}/axiarch-scripts/axiarch-boot-reminder.sh"
if [[ ! -f "${REMINDER_SCRIPT_PATH}" ]]; then
  print_warn "axiarch-scripts/axiarch-boot-reminder.sh not found — Check D unavailable"
  print_info "Re-run init.sh to redistribute the v1.8.0+ reminder script"
elif grep -q "VIOLATION-D" "${REMINDER_SCRIPT_PATH}" 2>/dev/null \
   && grep -q "AXIARCH_TASK_BOUNDARY_DETECT" "${REMINDER_SCRIPT_PATH}" 2>/dev/null; then
  print_pass "Check D wired in axiarch-boot-reminder.sh (VIOLATION-D + AXIARCH_TASK_BOUNDARY_DETECT env var)"
  if [[ "${AXIARCH_TASK_BOUNDARY_DETECT:-1}" == "0" ]]; then
    print_info "Note: AXIARCH_TASK_BOUNDARY_DETECT=0 disables Check D at runtime"
  fi
else
  print_warn "axiarch-scripts/axiarch-boot-reminder.sh missing Check D logic (VIOLATION-D / task boundary detection)"
  print_info "This is a v1.8.0+ feature. Re-run init.sh to update."
  print_info "Without Check D, AI may slack on rule re-load when it judges 'session continues' — see LOADING_PROTOCOL §4 v1.8.0 note"
fi

# =============================================================================
# Check 15: v1.9+ / v1.11+ Integration — PostToolUse Diff Guard + task-state lifecycle + source repository integration
# Verifies that supported hook configs call axiarch-diff-guard.sh after Edit,
# MultiEdit, and Write. This complements the PreToolUse Write-only block by
# making large diff growth easier to detect after diff-based edits. In the
# Axiarch source repository only, it also checks the common "new release
# feature, README not updated" integration gap. Adopter project README files
# are intentionally not treated as Axiarch release documentation.
# =============================================================================
print_section "Check 15: v1.9+ integration (diff guard + docs)"
DIFF_GUARD_SCRIPT="${PROJECT_DIR}/axiarch-scripts/axiarch-diff-guard.sh"
if [[ ! -f "${DIFF_GUARD_SCRIPT}" ]]; then
  if "${HOOK_FILE_OK}"; then
    print_warn "axiarch-scripts/axiarch-diff-guard.sh not found — PostToolUse diff guard unavailable"
    print_info "Re-run init.sh to redistribute the diff guard hook script"
    EXIT_CODE=1
  else
    print_warn "Skipped diff guard script check — optional hook layer is not installed"
  fi
elif [[ ! -x "${DIFF_GUARD_SCRIPT}" ]]; then
  print_warn "axiarch-scripts/axiarch-diff-guard.sh exists but is not executable"
  print_info "Run: chmod +x axiarch-scripts/axiarch-diff-guard.sh"
  if "${HOOK_FILE_OK}"; then
    EXIT_CODE=1
  fi
elif command -v jq &>/dev/null; then
  DIFF_GUARD_CONFIGS=0
  DIFF_GUARD_WIRED=0
  for candidate in "${PROJECT_DIR}/.claude/settings.json" "${PROJECT_DIR}/.codex/hooks.json"; do
    [[ -f "${candidate}" ]] || continue
    DIFF_GUARD_CONFIGS=$((DIFF_GUARD_CONFIGS + 1))
    if jq . "${candidate}" >/dev/null 2>&1; then
      guard_count=$(jq '[.hooks.PostToolUse[]?.hooks[]?.command // empty | select(contains("axiarch-diff-guard.sh"))] | length' \
        "${candidate}" 2>/dev/null || echo "0")
      edit_count=$(jq '[.hooks.PostToolUse[]? | select((.matcher // "") == "Edit")] | length' \
        "${candidate}" 2>/dev/null || echo "0")
      multi_count=$(jq '[.hooks.PostToolUse[]? | select((.matcher // "") == "MultiEdit")] | length' \
        "${candidate}" 2>/dev/null || echo "0")
      write_count=$(jq '[.hooks.PostToolUse[]? | select((.matcher // "") == "Write")] | length' \
        "${candidate}" 2>/dev/null || echo "0")
      if [[ "${guard_count}" -gt 0 && "${edit_count}" -gt 0 && "${multi_count}" -gt 0 && "${write_count}" -gt 0 ]]; then
        DIFF_GUARD_WIRED=$((DIFF_GUARD_WIRED + 1))
        print_pass "PostToolUse diff guard wired in ${candidate}"
      else
        print_warn "PostToolUse diff guard incomplete in ${candidate}"
        print_info "Expected Edit / MultiEdit / Write matchers calling axiarch-diff-guard.sh"
        EXIT_CODE=1
      fi
    else
      print_warn "Skipped invalid JSON: ${candidate}"
      EXIT_CODE=1
    fi
  done
  if [[ "${DIFF_GUARD_CONFIGS}" -eq 0 ]]; then
    print_warn "No hook config found for PostToolUse diff guard — optional hook layer is not installed"
  elif [[ "${DIFF_GUARD_WIRED}" -gt 0 ]]; then
    print_info "Runtime mode: AXIARCH_DIFF_GUARD_MODE=${AXIARCH_DIFF_GUARD_MODE:-warn}, max lines=${AXIARCH_DIFF_GUARD_MAX_LINES:-400}, max files=${AXIARCH_DIFF_GUARD_MAX_FILES:-20}"
  fi
else
  print_warn "jq not installed — cannot inspect PostToolUse wiring"
  print_info "Script exists and is executable; install jq for full Check 15 diagnostics"
fi

IS_AXIARCH_SOURCE_REPO=0
if [[ -f "${PROJECT_DIR}/MARKET_STRATEGY.md" \
   && -f "${PROJECT_DIR}/ROADMAP.md" \
   && -f "${PROJECT_DIR}/CHANGELOG.md" \
   && -f "${PROJECT_DIR}/llms-full.txt" ]]; then
  IS_AXIARCH_SOURCE_REPO=1
fi

if [[ "${IS_AXIARCH_SOURCE_REPO}" -eq 1 ]]; then
  DOCS_MISSING=0
  if [[ -f "${PROJECT_DIR}/README.md" ]]; then
    if grep -q "axiarch-diff-guard.sh" "${PROJECT_DIR}/README.md" 2>/dev/null \
      && grep -q ".claude/memory/MEMORY.md" "${PROJECT_DIR}/README.md" 2>/dev/null \
      && grep -q "15 段階" "${PROJECT_DIR}/README.md" 2>/dev/null \
      && grep -q "axiarch-task-state.sh" "${PROJECT_DIR}/README.md" 2>/dev/null \
      && grep -q "update_plan" "${PROJECT_DIR}/README.md" 2>/dev/null \
      && grep -q "TaskCreate" "${PROJECT_DIR}/README.md" 2>/dev/null; then
      print_pass "Axiarch source README.md includes v1.9 diff guard, memory, and 15-stage diagnostic references"
    else
      print_warn "Axiarch source README.md may be missing source integration references"
      print_info "Expected README to mention axiarch-task-state.sh, Codex update_plan, and Claude Code TaskCreate for v1.11.0"
      DOCS_MISSING=1
    fi
    if grep -q "Hook・診断・安全アップグレード利用時のみ必要" "${PROJECT_DIR}/README.md" 2>/dev/null \
      && grep -q "Required only for hooks, diagnostics, or safe upgrades" "${PROJECT_DIR}/README.md" 2>/dev/null \
      && grep -q "Optional for minimal operation otherwise" "${PROJECT_DIR}/README.md" 2>/dev/null; then
      print_pass "Axiarch source README.md keeps axiarch-scripts required/optional boundary explicit"
    else
      print_warn "Axiarch source README.md may blur the axiarch-scripts required/optional boundary"
      print_info "Expected axiarch-scripts/ to be conditional, not part of the two required minimal files"
      DOCS_MISSING=1
    fi
    if grep -q "Axiarch本体リポジトリ専用ファイルは既定skip" "${PROJECT_DIR}/README.md" 2>/dev/null \
      && grep -q "Axiarch source-repository-only files stay skipped by default" "${PROJECT_DIR}/README.md" 2>/dev/null \
      && grep -q "source-only既定skipとinteractive明示override" "${PROJECT_DIR}/README.md" 2>/dev/null \
      && grep -q "source-only default skip with explicit interactive override" "${PROJECT_DIR}/README.md" 2>/dev/null \
      && grep -q "対話選択肢重複排除" "${PROJECT_DIR}/README.md" 2>/dev/null \
      && grep -q "deduplicated interactive choices" "${PROJECT_DIR}/README.md" 2>/dev/null; then
      print_pass "Axiarch source README.md keeps source-only default-skip, explicit-interactive, and deduplicated-choice boundaries explicit"
    else
      print_warn "Axiarch source README.md may omit the source-only default-skip, explicit-interactive, or deduplicated-choice boundary"
      print_info "Expected Safe Upgrade docs and health summary to say source-only files stay skipped by default unless explicitly selected in interactive mode, and interactive choices are deduplicated"
      DOCS_MISSING=1
    fi
    if grep -q "Codex / Claude Code / Google Antigravity はいずれも実運用で稼働確認済み" "${PROJECT_DIR}/README.md" 2>/dev/null \
      && grep -q "Codex, Claude Code, and Google Antigravity are production-validated primary targets" "${PROJECT_DIR}/README.md" 2>/dev/null \
      && grep -q "全環境での動作保証ではありません" "${PROJECT_DIR}/README.md" 2>/dev/null \
      && grep -q "not an operation guarantee for every environment" "${PROJECT_DIR}/README.md" 2>/dev/null; then
      print_pass "Axiarch source README.md keeps production-validated primary status explicit for Codex, Claude Code, and Google Antigravity"
    else
      print_warn "Axiarch source README.md may have stale agent validation status wording"
      print_info "Expected README to mark Codex, Claude Code, and Google Antigravity as production-validated primary targets while preserving the no-operation-guarantee boundary"
      DOCS_MISSING=1
    fi
  else
    print_warn "Axiarch source README.md not found — cannot verify Axiarch source release integration"
    DOCS_MISSING=1
  fi

  if [[ -f "${PROJECT_DIR}/MARKET_STRATEGY.md" && -f "${PROJECT_DIR}/ROADMAP.md" ]]; then
    if grep -q "OpenAI Codex、Claude Code、Google Antigravity はいずれも実運用で稼働確認済み" "${PROJECT_DIR}/MARKET_STRATEGY.md" 2>/dev/null \
      && grep -q "全環境での動作保証とは表現しない" "${PROJECT_DIR}/MARKET_STRATEGY.md" 2>/dev/null \
      && grep -q "実運用稼働確認済み主対象" "${PROJECT_DIR}/ROADMAP.md" 2>/dev/null \
      && grep -q "Production-validated primary targets" "${PROJECT_DIR}/ROADMAP.md" 2>/dev/null \
      && grep -q "v1.8.0時点の公開ステータス" "${PROJECT_DIR}/ROADMAP.md" 2>/dev/null \
      && grep -q "At the v1.8.0 release point" "${PROJECT_DIR}/ROADMAP.md" 2>/dev/null; then
      print_pass "Axiarch source market strategy and roadmap keep production-validated primary status aligned while preserving historical release context"
    else
      print_warn "Axiarch source market strategy or roadmap may have stale agent validation status wording"
      print_info "Expected MARKET_STRATEGY and ROADMAP to mark Codex, Claude Code, and Google Antigravity as production-validated primary targets while preserving historical v1.8.0 status context"
      DOCS_MISSING=1
    fi
  else
    print_warn "Axiarch source MARKET_STRATEGY.md or ROADMAP.md not found — cannot verify agent validation status parity"
    DOCS_MISSING=1
  fi

  if [[ -f "${PROJECT_DIR}/llms.txt" && -f "${PROJECT_DIR}/llms-full.txt" ]]; then
    if grep -q "source-repository-only files skipped by default unless explicitly selected" "${PROJECT_DIR}/llms.txt" 2>/dev/null \
      && grep -q "source-repository-only files skipped by default unless explicitly selected" "${PROJECT_DIR}/llms-full.txt" 2>/dev/null \
      && grep -q "source-only default skip" "${PROJECT_DIR}/llms-full.txt" 2>/dev/null \
      && grep -q "source release-file Git tracking" "${PROJECT_DIR}/llms.txt" 2>/dev/null \
      && grep -q "source release-file Git tracking" "${PROJECT_DIR}/llms-full.txt" 2>/dev/null \
      && grep -q "deduplicated action choices" "${PROJECT_DIR}/llms.txt" 2>/dev/null \
      && grep -q "deduplicated action choices" "${PROJECT_DIR}/llms-full.txt" 2>/dev/null \
      && grep -q "/tmp/axiarch-upgrade.sh" "${PROJECT_DIR}/llms.txt" 2>/dev/null \
      && grep -q "/tmp/axiarch-upgrade.sh" "${PROJECT_DIR}/llms-full.txt" 2>/dev/null \
      && grep -q "axiarch-task-state.sh" "${PROJECT_DIR}/llms.txt" 2>/dev/null \
      && grep -q "axiarch-task-state.sh" "${PROJECT_DIR}/llms-full.txt" 2>/dev/null \
      && grep -q "update_plan" "${PROJECT_DIR}/llms.txt" 2>/dev/null \
      && grep -q "TaskCreate" "${PROJECT_DIR}/llms-full.txt" 2>/dev/null; then
      print_pass "Axiarch source llms files keep source-only upgrade boundary, deduplicated choices, and release-file tracking explicit"
    else
      print_warn "Axiarch source llms files may omit the source-only upgrade boundary, deduplicated choices, or release-file tracking"
      print_info "Expected llms.txt and llms-full.txt to mention source-repository-only default skip, explicit interactive selection, deduplicated action choices, temporary helper bootstrap for older adopters, source release-file Git tracking, axiarch-task-state.sh, update_plan, and TaskCreate"
      DOCS_MISSING=1
    fi
    if grep -q "Production-validated primary targets: OpenAI Codex, Claude Code, and Google Antigravity" "${PROJECT_DIR}/llms.txt" 2>/dev/null \
      && grep -q "OpenAI Codex, Claude Code, and Google Antigravity are production-validated primary targets" "${PROJECT_DIR}/llms-full.txt" 2>/dev/null \
      && grep -q "not an operation guarantee for every environment" "${PROJECT_DIR}/llms.txt" 2>/dev/null \
      && grep -q "not an operation guarantee for every environment" "${PROJECT_DIR}/llms-full.txt" 2>/dev/null \
      && grep -q "Production-validated primary" "${PROJECT_DIR}/llms-full.txt" 2>/dev/null \
      && grep -q "OpenAI Codex | ✅ Production-validated primary" "${PROJECT_DIR}/llms.txt" 2>/dev/null \
      && grep -q "Claude Code | ✅ Production-validated primary" "${PROJECT_DIR}/llms.txt" 2>/dev/null; then
      print_pass "Axiarch source llms files keep agent validation status aligned"
    else
      print_warn "Axiarch source llms files may have stale agent validation status wording"
      print_info "Expected llms files to mark Codex, Claude Code, and Google Antigravity as production-validated primary targets while preserving the no-operation-guarantee boundary"
      DOCS_MISSING=1
    fi
  else
    print_warn "Axiarch source llms files not found — cannot verify source-only upgrade boundary"
    DOCS_MISSING=1
  fi

  if [[ -f "${PROJECT_DIR}/axiarch-scripts/README.md" ]]; then
    if grep -q "axiarch-diff-guard.sh" "${PROJECT_DIR}/axiarch-scripts/README.md" 2>/dev/null \
      && grep -q "15-stage" "${PROJECT_DIR}/axiarch-scripts/README.md" 2>/dev/null \
      && grep -q "対話選択肢重複排除" "${PROJECT_DIR}/axiarch-scripts/README.md" 2>/dev/null \
      && grep -q "deduplicated interactive choices" "${PROJECT_DIR}/axiarch-scripts/README.md" 2>/dev/null \
      && grep -q "axiarch-task-state.sh" "${PROJECT_DIR}/axiarch-scripts/README.md" 2>/dev/null \
      && grep -q "AXIARCH_PROCESS_DOC_MODE" "${PROJECT_DIR}/axiarch-scripts/README.md" 2>/dev/null \
      && grep -q "AXIARCH_PROCESS_DOC_LANG" "${PROJECT_DIR}/axiarch-scripts/README.md" 2>/dev/null; then
      print_pass "Axiarch source axiarch-scripts/README.md includes v1.9 diff guard, 15-stage diagnostics, and deduplicated-choice references"
    else
      print_warn "Axiarch source axiarch-scripts/README.md may be missing source integration references"
      print_info "Expected scripts README to mention axiarch-task-state.sh, AXIARCH_PROCESS_DOC_MODE, and AXIARCH_PROCESS_DOC_LANG for v1.11.0"
      DOCS_MISSING=1
    fi
    if grep -q "最小構成の必須ファイルではありません" "${PROJECT_DIR}/axiarch-scripts/README.md" 2>/dev/null \
      && grep -q "not required for the minimal Axiarch setup" "${PROJECT_DIR}/axiarch-scripts/README.md" 2>/dev/null \
      && grep -q "recommended tooling for diagnostics, hook reinforcement, and safe upgrades" "${PROJECT_DIR}/axiarch-scripts/README.md" 2>/dev/null \
      && grep -q "/tmp/axiarch-upgrade.sh" "${PROJECT_DIR}/axiarch-scripts/README.md" 2>/dev/null \
      && grep -q -- "--yes" "${PROJECT_DIR}/axiarch-scripts/README.md" 2>/dev/null; then
      print_pass "Axiarch source axiarch-scripts/README.md keeps minimal/optional script boundary explicit"
    else
      print_warn "Axiarch source axiarch-scripts/README.md may blur the minimal/optional script boundary"
      print_info "Expected script README to say scripts are optional for minimal AGENTS.md plus axiarch-rules/ operation, show temporary helper bootstrap for older adopters, and document --yes for reviewed non-interactive apply"
      DOCS_MISSING=1
    fi
  else
    print_warn "Axiarch source axiarch-scripts/README.md not found — cannot verify script README integration"
    DOCS_MISSING=1
  fi

  loading_protocol_boundary_missing=0
  if [[ -f "${PROJECT_DIR}/axiarch-rules/ja/LOADING_PROTOCOL.md" ]] \
    && grep -q "source-only既定skipとinteractive明示override" "${PROJECT_DIR}/axiarch-rules/ja/LOADING_PROTOCOL.md" 2>/dev/null \
    && grep -q "対話選択肢重複排除" "${PROJECT_DIR}/axiarch-rules/ja/LOADING_PROTOCOL.md" 2>/dev/null \
    && grep -q "README/llms/scripts README" "${PROJECT_DIR}/axiarch-rules/ja/LOADING_PROTOCOL.md" 2>/dev/null \
    && grep -q "ネイティブタスク" "${PROJECT_DIR}/axiarch-rules/ja/LOADING_PROTOCOL.md" 2>/dev/null \
    && grep -q "AXIARCH_PROCESS_DOC_LANG" "${PROJECT_DIR}/axiarch-rules/ja/LOADING_PROTOCOL.md" 2>/dev/null \
    && grep -q "update_plan" "${PROJECT_DIR}/axiarch-rules/ja/LOADING_PROTOCOL.md" 2>/dev/null \
    && grep -q "TaskCreate" "${PROJECT_DIR}/axiarch-rules/ja/LOADING_PROTOCOL.md" 2>/dev/null \
    && [[ -f "${PROJECT_DIR}/axiarch-rules/en/LOADING_PROTOCOL.md" ]] \
    && grep -q "source-only default skip with explicit interactive override" "${PROJECT_DIR}/axiarch-rules/en/LOADING_PROTOCOL.md" 2>/dev/null \
    && grep -q "deduplicated interactive choices" "${PROJECT_DIR}/axiarch-rules/en/LOADING_PROTOCOL.md" 2>/dev/null \
    && grep -q "README, llms, and scripts README" "${PROJECT_DIR}/axiarch-rules/en/LOADING_PROTOCOL.md" 2>/dev/null \
    && grep -q "Native Task" "${PROJECT_DIR}/axiarch-rules/en/LOADING_PROTOCOL.md" 2>/dev/null \
    && grep -q "AXIARCH_PROCESS_DOC_LANG" "${PROJECT_DIR}/axiarch-rules/en/LOADING_PROTOCOL.md" 2>/dev/null \
    && grep -q "update_plan" "${PROJECT_DIR}/axiarch-rules/en/LOADING_PROTOCOL.md" 2>/dev/null \
    && grep -q "TaskCreate" "${PROJECT_DIR}/axiarch-rules/en/LOADING_PROTOCOL.md" 2>/dev/null; then
    print_pass "Axiarch source LOADING_PROTOCOL files keep Safe Upgrade health scope aligned"
  else
    print_warn "Axiarch source LOADING_PROTOCOL files may have stale Safe Upgrade health scope"
    print_info "Expected ja/en LOADING_PROTOCOL to mention source-only explicit override, deduplicated interactive choices, README/llms/scripts README boundary checks, native task-state sync, Project Native Language template selection, update_plan, and TaskCreate"
    loading_protocol_boundary_missing=1
  fi
  if [[ "${loading_protocol_boundary_missing}" -ne 0 ]]; then
    DOCS_MISSING=1
  fi

  if [[ -f "${PROJECT_DIR}/axiarch-rules/ja/LOADING_PROTOCOL.md" ]] \
    && grep -q "Codex / Claude Code / Google Antigravity はいずれも実運用で稼働確認済み" "${PROJECT_DIR}/axiarch-rules/ja/LOADING_PROTOCOL.md" 2>/dev/null \
    && grep -q "全環境での動作保証ではない" "${PROJECT_DIR}/axiarch-rules/ja/LOADING_PROTOCOL.md" 2>/dev/null \
    && [[ -f "${PROJECT_DIR}/axiarch-rules/en/LOADING_PROTOCOL.md" ]] \
    && grep -q "Codex, Claude Code, and Google Antigravity are production-validated primary targets" "${PROJECT_DIR}/axiarch-rules/en/LOADING_PROTOCOL.md" 2>/dev/null \
    && grep -q "not an operation guarantee for every environment" "${PROJECT_DIR}/axiarch-rules/en/LOADING_PROTOCOL.md" 2>/dev/null; then
    print_pass "Axiarch source LOADING_PROTOCOL files keep agent validation status aligned"
  else
    print_warn "Axiarch source LOADING_PROTOCOL files may have stale agent validation status wording"
    print_info "Expected ja/en LOADING_PROTOCOL to mark Codex, Claude Code, and Google Antigravity as production-validated primary targets while preserving the no-operation-guarantee boundary"
    DOCS_MISSING=1
  fi

  if [[ -f "${PROJECT_DIR}/axiarch-rules/ja/README.md" ]] \
    && grep -q "3つとも実運用で稼働確認済み" "${PROJECT_DIR}/axiarch-rules/ja/README.md" 2>/dev/null \
    && grep -q "全環境での動作保証ではありません" "${PROJECT_DIR}/axiarch-rules/ja/README.md" 2>/dev/null \
    && [[ -f "${PROJECT_DIR}/axiarch-rules/en/README.md" ]] \
    && grep -q "All three are production-validated primary targets" "${PROJECT_DIR}/axiarch-rules/en/README.md" 2>/dev/null \
    && grep -q "not an operation guarantee for every environment" "${PROJECT_DIR}/axiarch-rules/en/README.md" 2>/dev/null; then
    print_pass "Axiarch source rules README files keep agent validation status aligned"
  else
    print_warn "Axiarch source rules README files may have stale agent validation status wording"
    print_info "Expected ja/en rules README files to mark Codex, Claude Code, and Google Antigravity as production-validated primary targets while preserving the no-operation-guarantee boundary"
    DOCS_MISSING=1
  fi

  if [[ -f "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" ]]; then
    if grep -q "load_manifest_group_metadata" "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
      && grep -q '^[[:space:]]*register_manifest_items$' "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
      && grep -q "iter_groups" "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
      && grep -q "path_is_excluded" "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
      && grep -q '(.exclude // \[\])' "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
      && grep -q '.github/workflows/lint.yml' "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
      && grep -q "action=%s" "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
      && grep -q "option_actions" "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
      && grep -q "for action in update-all review-each show-diff skip" "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
      && grep -q "resolve_upgrade_version_label" "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
      && grep -q "normalize_axiarch_version_label" "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
      && grep -q "for domain in core ai design engineering operations product quality security" "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
      && grep -q "for rel in AGENTS.md axiarch-manifest.json axiarch-scripts axiarch-rules axiarch-prompts" "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
      && grep -q "copy_replace_if_local_unchanged" "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
      && grep -q "replace-if checks and 3-way merge" "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
      && grep -q 'policy}" == "replace-if-local-unchanged"' "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
      && grep -q "no-base-diff" "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
      && grep -q "base-missing" "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
      && grep -q "base-mismatch" "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
      && grep -q "Use --from, --from-ref, or --base-source" "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
      && grep -q "copy_path_has_type_conflict" "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
      && grep -q "TYPE-CONFLICT" "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
      && grep -q "SOURCE-ONLY explicit" "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
      && grep -q 'INTERACTIVE}" == "true"' "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
      && grep -q 'read -r answer || answer=""' "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
      && grep -q 'read -r choice || choice=""' "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null; then
      print_pass "Axiarch source upgrade wizard reads axiarch-manifest.json, honors manifest excludes, preserves source-only CI boundaries by default while allowing explicit interactive override, displays deduplicated effective group actions, normalizes upgrade metadata versions, discovers core Blueprint project state in fallback mode, hashes optional prompts when applied, enforces replace-if-local-unchanged review fallback with reason labels and base option guidance, records file/directory type conflicts for review, and handles EOF on interactive confirmations safely"
    else
      print_warn "Axiarch source upgrade wizard may not be fully wired to axiarch-manifest.json"
      print_info "Expected manifest file parsing, manifest-driven group iteration, manifest exclude handling, source-only CI fallback classification with explicit interactive override, deduplicated effective action display, metadata version normalization, core Blueprint fallback discovery, optional prompt hashing, replace-if-local-unchanged enforcement with reason labels and base option guidance, type-conflict review logging, and EOF-safe interactive confirmation defaults"
      DOCS_MISSING=1
    fi
  else
    print_warn "Axiarch source axiarch-upgrade.sh not found — cannot verify manifest-based upgrade wiring"
    DOCS_MISSING=1
  fi

  if [[ -f "${PROJECT_DIR}/init.sh" ]]; then
    if grep -q "axiarch-upgrade.sh --safe-only --dry-run" "${PROJECT_DIR}/init.sh" 2>/dev/null \
      && grep -q "manifest-based upgrade preview" "${PROJECT_DIR}/init.sh" 2>/dev/null \
      && grep -q "axiarch-task-state.sh" "${PROJECT_DIR}/init.sh" 2>/dev/null; then
      print_pass "Axiarch source init.sh presents Safe Upgrade as a dry-run preview, not automatic mutation"
    else
      print_warn "Axiarch source init.sh may blur Safe Upgrade dry-run preview semantics or omit task-state script distribution"
      print_info "Expected next steps to recommend axiarch-upgrade.sh --safe-only --dry-run, describe it as an upgrade preview, and distribute/validate axiarch-task-state.sh"
      DOCS_MISSING=1
    fi
    if grep -q "check_existing_install" "${PROJECT_DIR}/init.sh" 2>/dev/null \
      && grep -q "Existing Axiarch files detected" "${PROJECT_DIR}/init.sh" 2>/dev/null \
      && grep -q "Stopped before file copy" "${PROJECT_DIR}/init.sh" 2>/dev/null \
      && grep -q "raw.githubusercontent.com" "${PROJECT_DIR}/init.sh" 2>/dev/null \
      && grep -q "/tmp/axiarch-upgrade.sh" "${PROJECT_DIR}/init.sh" 2>/dev/null \
      && grep -q 'read -rp "Continue full installer anyway?' "${PROJECT_DIR}/init.sh" 2>/dev/null \
      && grep -q 'cp -R "$SOURCE_DIR/axiarch-rules/."' "${PROJECT_DIR}/init.sh" 2>/dev/null \
      && grep -q 'cp -R "$SOURCE_DIR/axiarch-prompts/."' "${PROJECT_DIR}/init.sh" 2>/dev/null; then
      print_pass "Axiarch source init.sh guards existing installations, handles missing upgrade helpers, and avoids nested rules/prompts directory copies"
    else
      print_warn "Axiarch source init.sh may not protect existing installations from full installer misuse"
      print_info "Expected existing-install detection, Safe Upgrade guidance, missing-helper bootstrap guidance, EOF-safe prompt handling, pre-copy stop, and contents-copy semantics for rules/prompts"
      DOCS_MISSING=1
    fi
    if grep -q "OpenAI Codex — Production-validated primary" "${PROJECT_DIR}/init.sh" 2>/dev/null \
      && grep -q "Claude Code — Production-validated primary" "${PROJECT_DIR}/init.sh" 2>/dev/null \
      && grep -q "Google Antigravity — Production-validated primary" "${PROJECT_DIR}/init.sh" 2>/dev/null; then
      print_pass "Axiarch source init.sh presents current agent validation status in installer choices"
    else
      print_warn "Axiarch source init.sh may present stale agent validation status in installer choices"
      print_info "Expected init.sh choices to mark Codex, Claude Code, and Google Antigravity as production-validated primary"
      DOCS_MISSING=1
    fi
  else
    print_warn "Axiarch source init.sh not found — cannot verify Safe Upgrade next-step guidance"
    DOCS_MISSING=1
  fi

  if [[ -f "${PROJECT_DIR}/axiarch-manifest.json" ]] && command -v jq >/dev/null 2>&1; then
    if jq -e '
      .files[]
      | select(.path == "axiarch-rules/{lang}/blueprint/*/[0-9][0-9][0-9]_*.md")
      | (.exclude // []) as $exclude
      | (
          ($exclude | index("axiarch-rules/{lang}/blueprint/core/000_project_overview.md")) and
          ($exclude | index("axiarch-rules/{lang}/blueprint/core/010_project_lessons_log.md")) and
          ($exclude | index("axiarch-rules/{lang}/blueprint/core/998_feature_spec_template.md")) and
          ($exclude | index("axiarch-rules/{lang}/blueprint/core/999_project_specific_template.md")) and
          ($exclude | index("axiarch-rules/{lang}/blueprint/operations/010_release_upgrade_operations.md"))
        )
    ' "${PROJECT_DIR}/axiarch-manifest.json" >/dev/null 2>&1; then
      print_pass "Axiarch source manifest excludes explicitly managed Blueprint files from the broad Project State glob"
    else
      print_warn "Axiarch source manifest broad Project State glob may overlap explicit Blueprint entries"
      print_info "Expected exclude entries for project overview, lessons log, core templates, and shared release-upgrade operations Blueprint"
      DOCS_MISSING=1
    fi

    if jq -e '
      any(.files[]; .path == ".github/workflows/lint.yml" and .group == "source_docs" and .owner == "axiarch-source" and .policy == "skip")
    ' "${PROJECT_DIR}/axiarch-manifest.json" >/dev/null 2>&1; then
      print_pass "Axiarch source manifest classifies lint.yml as source-only skip"
    else
      print_warn "Axiarch source manifest may omit source-only lint workflow classification"
      print_info "Expected .github/workflows/lint.yml to be source_docs / axiarch-source / skip"
      DOCS_MISSING=1
    fi

    source_docs_missing=0
    expected_source_docs=(
      "README.md"
      "init.sh"
      "ROADMAP.md"
      "CHANGELOG.md"
      "CONTRIBUTING.md"
      "SECURITY.md"
      "CODE_OF_CONDUCT.md"
      "LICENSE"
      "NOTICE"
      "MARKET_STRATEGY.md"
      "llms.txt"
      "llms-full.txt"
      "social-preview.png"
      ".gitignore"
      ".markdownlint-cli2.jsonc"
      ".github/workflows/release.yml"
      ".github/workflows/lint.yml"
      ".github/CODEOWNERS"
      ".github/PULL_REQUEST_TEMPLATE.md"
      ".github/ISSUE_TEMPLATE"
      ".github/dependabot.yml"
    )
    for expected_source_doc in "${expected_source_docs[@]}"; do
      if ! jq -e --arg rel "${expected_source_doc}" '
        any(.files[]; .path == $rel and .group == "source_docs" and .owner == "axiarch-source" and .policy == "skip")
      ' "${PROJECT_DIR}/axiarch-manifest.json" >/dev/null 2>&1; then
        print_warn "Axiarch source manifest may omit source-only repository file: ${expected_source_doc}"
        source_docs_missing=1
      fi
      if [[ -f "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" ]] \
        && ! grep -Fq "add_item \"source_docs\" \"${expected_source_doc}\"" "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null; then
        print_warn "Axiarch source upgrade fallback may omit source-only repository file: ${expected_source_doc}"
        source_docs_missing=1
      fi
    done
    if [[ "${source_docs_missing}" -eq 0 ]]; then
      print_pass "Axiarch source manifest and fallback classify installer and repository-management files as source-only skip"
    else
      print_info "Expected installer, README-listed repo-only docs, repository metadata, and source GitHub templates to stay source_docs / skip"
      DOCS_MISSING=1
    fi

    manifest_expanded_paths="$(mktemp)"
    manifest_duplicate_paths="$(mktemp)"
    manifest_match_list="$(mktemp)"
    : > "${manifest_expanded_paths}"
    while IFS=$'\t' read -r manifest_path manifest_excludes; do
      [[ -z "${manifest_path}" ]] && continue
      manifest_langs="_"
      if [[ "${manifest_path}" == *"{lang}"* ]]; then
        manifest_langs=$'ja\nen'
      fi
      while IFS= read -r manifest_lang; do
        if [[ "${manifest_lang}" == "_" ]]; then
          expanded_path="${manifest_path}"
          expanded_excludes="${manifest_excludes:-}"
        else
          expanded_path="${manifest_path//\{lang\}/${manifest_lang}}"
          expanded_excludes="${manifest_excludes//\{lang\}/${manifest_lang}}"
        fi

        : > "${manifest_match_list}"
        case "${expanded_path}" in
          *'*'*|*'['*|*'?'*)
            (cd "${PROJECT_DIR}" && compgen -G "${expanded_path}" || true) > "${manifest_match_list}"
            ;;
          *)
            printf '%s\n' "${expanded_path}" > "${manifest_match_list}"
            ;;
        esac

        while IFS= read -r manifest_candidate; do
          [[ -z "${manifest_candidate}" ]] && continue
          manifest_excluded=0
          if [[ -n "${expanded_excludes:-}" ]]; then
            while IFS= read -r manifest_exclude; do
              [[ -z "${manifest_exclude}" ]] && continue
              if [[ "${manifest_candidate}" == ${manifest_exclude} ]]; then
                manifest_excluded=1
                break
              fi
            done < <(printf '%s\n' "${expanded_excludes}" | tr '|' '\n')
          fi
          [[ "${manifest_excluded}" -eq 1 ]] && continue
          printf '%s\n' "${manifest_candidate}" >> "${manifest_expanded_paths}"
        done < "${manifest_match_list}"
      done <<EOF
${manifest_langs}
EOF
    done < <(jq -r '.files[] | [.path, ((.exclude // []) | join("|"))] | @tsv' "${PROJECT_DIR}/axiarch-manifest.json")

    sort "${manifest_expanded_paths}" | uniq -d > "${manifest_duplicate_paths}"
    manifest_expanded_count=$(wc -l < "${manifest_expanded_paths}" | tr -d '[:space:]')
    manifest_duplicate_count=$(wc -l < "${manifest_duplicate_paths}" | tr -d '[:space:]')
    if [[ "${manifest_duplicate_count}" -eq 0 ]]; then
      print_pass "Axiarch source manifest expansion has no duplicate paths after excludes (${manifest_expanded_count} paths)"
    else
      print_warn "Axiarch source manifest expansion has duplicate paths after excludes"
      while IFS= read -r duplicate_path; do
        [[ -z "${duplicate_path}" ]] && continue
        print_info "duplicate: ${duplicate_path}"
      done < "${manifest_duplicate_paths}"
      DOCS_MISSING=1
    fi
    rm -f "${manifest_expanded_paths}" "${manifest_duplicate_paths}" "${manifest_match_list}"
  fi

  if command -v git >/dev/null 2>&1 \
    && git -C "${PROJECT_DIR}" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    release_tracking_missing=0
    release_tracking_paths=(
      "axiarch-manifest.json"
      "axiarch-scripts/axiarch-upgrade.sh"
      "axiarch-scripts/axiarch-task-state.sh"
      "axiarch-prompts/ja/develop/safe_upgrade_execute.md"
      "axiarch-prompts/en/develop/safe_upgrade_execute.md"
      "axiarch-rules/ja/blueprint/operations/010_release_upgrade_operations.md"
      "axiarch-rules/en/blueprint/operations/010_release_upgrade_operations.md"
    )
    for release_tracking_path in "${release_tracking_paths[@]}"; do
      if [[ ! -e "${PROJECT_DIR}/${release_tracking_path}" ]]; then
        print_warn "Axiarch source release-critical file is missing on disk: ${release_tracking_path}"
        release_tracking_missing=1
      elif ! git -C "${PROJECT_DIR}" ls-files --error-unmatch -- "${release_tracking_path}" >/dev/null 2>&1; then
        print_warn "Axiarch source release-critical file is not tracked by git: ${release_tracking_path}"
        release_tracking_missing=1
      fi
    done
    if [[ "${release_tracking_missing}" -eq 0 ]]; then
      print_pass "Axiarch source release-critical files for the current release are tracked by git"
    else
      print_info "Expected current core release files to be tracked in the Git index before commit/release, not left only as untracked working-tree files"
      DOCS_MISSING=1
    fi
  else
    print_info "Git worktree not detected — skipping Axiarch source release-file tracking check"
  fi

  safe_prompt_missing=0
  for lang in ja en; do
    if [[ ! -f "${PROJECT_DIR}/axiarch-prompts/${lang}/develop/safe_upgrade_execute.md" ]]; then
      print_warn "Axiarch source safe_upgrade_execute.md missing for ${lang}"
      safe_prompt_missing=1
    elif ! grep -q -- "--yes" "${PROJECT_DIR}/axiarch-prompts/${lang}/develop/safe_upgrade_execute.md" 2>/dev/null; then
      print_warn "Axiarch source safe_upgrade_execute.md may be missing non-interactive --yes option guidance for ${lang}"
      safe_prompt_missing=1
    fi
    if [[ -f "${PROJECT_DIR}/axiarch-prompts/${lang}/develop/safe_upgrade_execute.md" ]]; then
      if [[ "${lang}" == "ja" ]]; then
        if ! grep -q "対話選択肢重複排除" "${PROJECT_DIR}/axiarch-prompts/${lang}/develop/safe_upgrade_execute.md" 2>/dev/null; then
          print_warn "Axiarch source safe_upgrade_execute.md may be missing deduplicated interactive choice guidance for ${lang}"
          safe_prompt_missing=1
        fi
      elif ! grep -q "Deduplicated action choices" "${PROJECT_DIR}/axiarch-prompts/${lang}/develop/safe_upgrade_execute.md" 2>/dev/null; then
        print_warn "Axiarch source safe_upgrade_execute.md may be missing deduplicated interactive choice guidance for ${lang}"
        safe_prompt_missing=1
      fi
    fi
    if [[ -f "${PROJECT_DIR}/axiarch-rules/${lang}/INDEX.md" ]] \
      && grep -q "safe_upgrade_execute.md" "${PROJECT_DIR}/axiarch-rules/${lang}/INDEX.md" 2>/dev/null \
      && grep -q "../../axiarch-prompts/${lang}/develop/" "${PROJECT_DIR}/axiarch-rules/${lang}/INDEX.md" 2>/dev/null; then
      :
    else
      print_warn "Axiarch source axiarch-rules/${lang}/INDEX.md may be missing safe upgrade prompt indexing"
      print_info "Expected ../../axiarch-prompts/${lang}/develop/ with safe_upgrade_execute.md"
      safe_prompt_missing=1
    fi
  done
  if [[ -f "${PROJECT_DIR}/axiarch-prompts/README.md" ]] \
    && grep -q "safe_upgrade_execute.md" "${PROJECT_DIR}/axiarch-prompts/README.md" 2>/dev/null \
    && grep -q "axiarch-prompts/ja/develop/safe_upgrade_execute.md" "${PROJECT_DIR}/axiarch-prompts/README.md" 2>/dev/null \
    && grep -q "axiarch-prompts/en/develop/safe_upgrade_execute.md" "${PROJECT_DIR}/axiarch-prompts/README.md" 2>/dev/null \
    && grep -q "source-only既定skip・明示選択・対話選択肢重複排除" "${PROJECT_DIR}/axiarch-prompts/README.md" 2>/dev/null \
    && grep -q "source-only default skip with explicit selection, deduplicated interactive choices" "${PROJECT_DIR}/axiarch-prompts/README.md" 2>/dev/null \
    && [[ -f "${PROJECT_DIR}/README.md" ]] \
    && grep -q "develop/safe_upgrade_execute.md" "${PROJECT_DIR}/README.md" 2>/dev/null \
    && grep -q "source-only既定skip・明示選択・対話選択肢重複排除" "${PROJECT_DIR}/README.md" 2>/dev/null \
    && grep -q "source-only default skip with explicit selection and deduplicated interactive choices" "${PROJECT_DIR}/README.md" 2>/dev/null \
    && grep -q -- "--with-prompts" "${PROJECT_DIR}/README.md" 2>/dev/null \
    && [[ -f "${PROJECT_DIR}/llms-full.txt" ]] \
    && grep -q "safe_upgrade_execute.md" "${PROJECT_DIR}/llms-full.txt" 2>/dev/null \
    && grep -q "deduplicated action choices" "${PROJECT_DIR}/llms-full.txt" 2>/dev/null; then
    print_pass "Axiarch source safe upgrade execution prompt is present in prompt/source indexes with source-only and deduplicated-choice summaries"
  else
    print_warn "Axiarch source safe upgrade execution prompt may be missing from prompt/source indexes"
    print_info "Expected ja/en prompt files with --yes guidance plus full-path references in axiarch-prompts/README.md, references in README.md and llms-full.txt, README --with-prompts guidance, source-only boundary summaries, and deduplicated interactive choice summaries in prompt indexes"
    safe_prompt_missing=1
  fi
  if [[ "${safe_prompt_missing}" -eq 0 ]]; then
    print_pass "Axiarch source rules INDEX files reference safe upgrade execution prompt"
  else
    DOCS_MISSING=1
  fi

  if [[ -f "${PROJECT_DIR}/CHANGELOG.md" ]]; then
    has_unreleased_heading=0
    has_unreleased_reference=0
    grep -q '^## \[Unreleased\]' "${PROJECT_DIR}/CHANGELOG.md" 2>/dev/null && has_unreleased_heading=1
    grep -q '^\[Unreleased\]:' "${PROJECT_DIR}/CHANGELOG.md" 2>/dev/null && has_unreleased_reference=1
    if [[ "${has_unreleased_heading}" -eq "${has_unreleased_reference}" ]]; then
      print_pass "Axiarch source CHANGELOG.md keeps Unreleased heading/reference parity"
    else
      print_warn "Axiarch source CHANGELOG.md has mismatched Unreleased heading/reference"
      print_info "Avoid stale [Unreleased]: definitions when the top release is finalized"
      DOCS_MISSING=1
    fi
    if grep -q "対話選択肢重複排除" "${PROJECT_DIR}/CHANGELOG.md" 2>/dev/null \
      && grep -q "deduplicated interactive choices" "${PROJECT_DIR}/CHANGELOG.md" 2>/dev/null \
      && grep -q "deduplicated interactive action options" "${PROJECT_DIR}/CHANGELOG.md" 2>/dev/null; then
      print_pass "Axiarch source CHANGELOG.md records deduplicated interactive choices for the current release"
    else
      print_warn "Axiarch source CHANGELOG.md may omit deduplicated interactive choice release notes"
      print_info "Expected release notes to retain deduplicated interactive choices in Operations Blueprint, health checks, and Safe Upgrade Wizard behavior"
      DOCS_MISSING=1
    fi
  else
    print_warn "Axiarch source CHANGELOG.md not found — cannot verify release reference parity"
    DOCS_MISSING=1
  fi

  release_version_mismatch=0
  init_version=""
  manifest_version=""
  changelog_version=""

  if [[ -f "${PROJECT_DIR}/init.sh" ]]; then
    init_version=$(sed -n 's/^AXIARCH_VERSION="\([^"]*\)".*/\1/p' "${PROJECT_DIR}/init.sh" | head -n 1)
  else
    print_warn "Axiarch source init.sh not found — cannot verify release version parity"
    release_version_mismatch=1
  fi

  if [[ -f "${PROJECT_DIR}/axiarch-manifest.json" ]]; then
    if command -v jq &>/dev/null; then
      manifest_version=$(jq -r '.axiarchVersion // empty' "${PROJECT_DIR}/axiarch-manifest.json" 2>/dev/null || echo "")
    else
      manifest_version=$(sed -n 's/.*"axiarchVersion":[[:space:]]*"\([^"]*\)".*/\1/p' "${PROJECT_DIR}/axiarch-manifest.json" | head -n 1)
    fi
  else
    print_warn "Axiarch source axiarch-manifest.json not found — cannot verify release version parity"
    release_version_mismatch=1
  fi

  if [[ -f "${PROJECT_DIR}/CHANGELOG.md" ]]; then
    changelog_version=$(sed -n 's/^## \[\([0-9][^]]*\)\].*/\1/p' "${PROJECT_DIR}/CHANGELOG.md" | head -n 1)
  fi

  if [[ -z "${init_version}" || -z "${manifest_version}" || -z "${changelog_version}" ]]; then
    print_warn "Axiarch source release metadata is incomplete"
    print_info "Expected init.sh AXIARCH_VERSION, axiarch-manifest.json axiarchVersion, and top CHANGELOG release heading"
    release_version_mismatch=1
  elif [[ "${init_version}" == "${manifest_version}" && "${init_version}" == "${changelog_version}" ]]; then
    print_pass "Axiarch source release version parity: ${init_version}"
  else
    print_warn "Axiarch source release version mismatch"
    print_info "init.sh=${init_version:-missing}, manifest=${manifest_version:-missing}, changelog=${changelog_version:-missing}"
    release_version_mismatch=1
  fi

  if [[ -n "${init_version}" ]]; then
    docs_release_mismatch=0
    for doc in README.md llms.txt llms-full.txt; do
      if [[ -f "${PROJECT_DIR}/${doc}" ]]; then
        if ! grep -q "v${init_version}" "${PROJECT_DIR}/${doc}" 2>/dev/null; then
          print_warn "Axiarch source ${doc} does not mention current release v${init_version}"
          docs_release_mismatch=1
        fi
      else
        print_warn "Axiarch source ${doc} not found — cannot verify current release mention"
        docs_release_mismatch=1
      fi
    done

    if [[ -f "${PROJECT_DIR}/CHANGELOG.md" ]] \
      && ! grep -q "^\[${init_version}\]:" "${PROJECT_DIR}/CHANGELOG.md" 2>/dev/null; then
      print_warn "Axiarch source CHANGELOG.md lacks compare reference for ${init_version}"
      docs_release_mismatch=1
    fi

    if [[ "${docs_release_mismatch}" -eq 0 ]]; then
      print_pass "Axiarch source repository docs mention the current release v${init_version}"
    else
      release_version_mismatch=1
    fi

    blueprint_index_mismatch=0
    for lang in ja en; do
      blueprint_index="${PROJECT_DIR}/axiarch-rules/${lang}/blueprint/INDEX.md"
      if [[ ! -f "${blueprint_index}" ]]; then
        print_warn "Axiarch source axiarch-rules/${lang}/blueprint/INDEX.md not found — cannot verify Blueprint index release metadata"
        blueprint_index_mismatch=1
        continue
      fi
      if ! grep -q "operations/010_release_upgrade_operations.md" "${blueprint_index}" 2>/dev/null; then
        print_warn "Axiarch source axiarch-rules/${lang}/blueprint/INDEX.md lacks release-upgrade operations Blueprint entry"
        blueprint_index_mismatch=1
      fi
      if ! grep -q "Version.*v${init_version}" "${blueprint_index}" 2>/dev/null; then
        print_warn "Axiarch source axiarch-rules/${lang}/blueprint/INDEX.md release metadata does not mention v${init_version}"
        blueprint_index_mismatch=1
      fi
      if [[ "${lang}" == "ja" ]]; then
        if ! grep -q "対話選択肢重複排除" "${blueprint_index}" 2>/dev/null; then
          print_warn "Axiarch source axiarch-rules/${lang}/blueprint/INDEX.md may omit deduplicated interactive choices in the release-upgrade operations entry"
          blueprint_index_mismatch=1
        fi
      else
        if ! grep -q "deduplicated interactive choices" "${blueprint_index}" 2>/dev/null; then
          print_warn "Axiarch source axiarch-rules/${lang}/blueprint/INDEX.md may omit deduplicated interactive choices in the release-upgrade operations entry"
          blueprint_index_mismatch=1
        fi
      fi
    done
    if [[ "${blueprint_index_mismatch}" -eq 0 ]]; then
      print_pass "Axiarch source Blueprint INDEX files include release-upgrade operations entry, current release metadata, and deduplicated-choice wording"
    else
      release_version_mismatch=1
    fi

    operations_readme_mismatch=0
    ja_operations_readme="${PROJECT_DIR}/axiarch-rules/ja/blueprint/operations/README.md"
    en_operations_readme="${PROJECT_DIR}/axiarch-rules/en/blueprint/operations/README.md"
    if [[ -f "${ja_operations_readme}" ]] \
      && grep -q "010_release_upgrade_operations.md" "${ja_operations_readme}" 2>/dev/null \
      && grep -q "source-only既定skip" "${ja_operations_readme}" 2>/dev/null \
      && grep -q "明示選択" "${ja_operations_readme}" 2>/dev/null \
      && grep -q "本体リポジトリ専用ファイル分類" "${ja_operations_readme}" 2>/dev/null \
      && grep -q "対話選択肢重複排除" "${ja_operations_readme}" 2>/dev/null \
      && [[ -f "${en_operations_readme}" ]] \
      && grep -q "010_release_upgrade_operations.md" "${en_operations_readme}" 2>/dev/null \
      && grep -q "source-only default skip" "${en_operations_readme}" 2>/dev/null \
      && grep -q "explicit selection" "${en_operations_readme}" 2>/dev/null \
      && grep -q "source-repository-only file classification" "${en_operations_readme}" 2>/dev/null \
      && grep -q "deduplicated interactive choices" "${en_operations_readme}" 2>/dev/null; then
      print_pass "Axiarch source Blueprint operations README files include release-upgrade source-only, source repository classification, and deduplicated interactive choice boundaries"
    else
      print_warn "Axiarch source Blueprint operations README files may have stale release-upgrade summaries"
      print_info "Expected ja/en operations README files to mention source-only default skip, explicit selection, source-repository-only classification, and deduplicated interactive choices"
      operations_readme_mismatch=1
    fi
    if [[ "${operations_readme_mismatch}" -ne 0 ]]; then
      release_version_mismatch=1
    fi
  fi

  if [[ "${DOCS_MISSING}" -ne 0 || "${release_version_mismatch}" -ne 0 ]]; then
    EXIT_CODE=1
  fi
else
  print_info "Adopter project detected — skipping Axiarch source repository docs/index integration checks"
fi

# =============================================================================
# Out-of-Scope Notice
# =============================================================================
print_section "Out of Scope (Manual Review Required)"
print_info "These protocols are not externally verifiable and require human review:"
print_info "  - §0 AI Self-Completion Mandate"
print_info "  - §3 Database Integrity (manual SQL detection)"
print_info "  - §5 Existing Functionality Protection"
print_info "  - §7 Role & Behavior"
print_info "(§6 Anti-Full-Overwrite gained physical block in v1.5.5 — see Check 11)"

# =============================================================================
# Summary
# =============================================================================
print_section "Summary"
if [[ "${EXIT_CODE}" -eq 0 ]]; then
  print_pass "No blocking automated check failures across hook + crystallization + AGENTS protocols"
  print_info "If warnings appeared above, review them before treating the project state as fully clean"
  print_info "Verifiable: §1, §2, §4, §6, §8, §9 + LOADING_PROTOCOL + Hooks (4) + Bootstrap + Task Boundary + Diff Guard + Docs Integration"
  print_info "Manual review needed: §0, §3, §5, §7 (see Out of Scope above)"
  print_info "(§6 became verifiable in v1.5.5 via PreToolUse — Check 11; v1.8.0 adds Check 14 task-boundary; v1.9.0 adds Check 15 diff guard)"
else
  print_warn "Some checks failed/warned — see above for which protocol needs attention"
  print_info "Common misconception: \`permissions.allow Bash(echo *)\` is NOT required"
  print_info "(hook command is spawned outside the permission pipeline)"
fi
echo ""
print_info "Docs: https://code.claude.com/docs/en/hooks"
print_info "AGENTS.md (top-level protocol): root of project"
print_info "Crystallization Protocol: axiarch-rules/{lang}/CRYSTALLIZATION_PROTOCOL.md"
print_info "axiarch: https://github.com/hiroyuki-miyauchi/axiarch"
echo ""

exit "${EXIT_CODE}"
