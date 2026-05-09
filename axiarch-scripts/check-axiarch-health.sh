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
# Diagnoses Axiarch enforcement health across 14 verifiable stages spanning
# the Hook layer, LOADING_PROTOCOL, CRYSTALLIZATION_PROTOCOL, AGENTS.md
# protocols (§1, §2, §4, §6, §8, §9 — verifiable subset), the v1.5.5
# physical-block / bootstrap hooks, the v1.6.0 sublimated-file guide, and the
# v1.7.0 task-boundary detection:
#
#   Check 1-4  Hook layer (settings presence, JSON syntax, hook structure, firing log)
#   Check 5    LOADING_PROTOCOL Step 4 — task.md adherence
#   Check 6    CRYSTALLIZATION_PROTOCOL §5 — count threshold (3+) + time-axis (>180d, v1.6.0+)
#   Check 7    AGENTS §8 Process & Documentation — task docs presence
#   Check 8    AGENTS §1 Deployment Ban — push hygiene
#   Check 9    AGENTS §4 SSOT Sync — main parity
#   Check 10   AGENTS §2 Language First — Project Native Language consistency
#   Check 11   AGENTS §6 ANTI-FULL-OVERWRITE — PreToolUse hook physical block (v1.5.5+)
#   Check 12   Bootstrap — SessionStart hook wiring (task.md auto-init, v1.5.5+)
#   Check 13   Sublimated files index — APPEND candidates (v1.6.0+)
#   Check 14   Task boundary detection — Check D wiring in axiarch-boot-reminder.sh (v1.7.0+)
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
# Check 1: .claude/settings.json existence
# =============================================================================
print_section "Check 1: .claude/settings.json"
if [[ -f "${PROJECT_DIR}/.claude/settings.json" ]]; then
  print_pass "File exists"
else
  print_fail "Missing: ${PROJECT_DIR}/.claude/settings.json"
  print_info "Run \`bash init.sh\` again, or copy from axiarch repo:"
  print_info "  cp <axiarch>/.claude/settings.json ${PROJECT_DIR}/.claude/"
  print_info "(Continuing with remaining checks for full-protocol coverage)"
  HOOK_FILE_OK=false
  EXIT_CODE=1
fi

# =============================================================================
# Check 2: JSON syntax
# =============================================================================
print_section "Check 2: JSON syntax"
if ! "${HOOK_FILE_OK}"; then
  print_warn "Skipped — settings.json not present (see Check 1)"
  HOOK_JSON_OK=false
elif command -v jq &>/dev/null; then
  if jq . "${PROJECT_DIR}/.claude/settings.json" >/dev/null 2>&1; then
    print_pass "Valid JSON"
  else
    print_fail "JSON parse error"
    print_info "Run: jq . ${PROJECT_DIR}/.claude/settings.json"
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
    "${PROJECT_DIR}/.claude/settings.json" 2>/dev/null || echo "0")
  if [[ "${HOOK_COUNT}" -gt 0 ]]; then
    print_pass "UserPromptSubmit hook defined (${HOOK_COUNT} entries)"
    HOOK_CMD=$(jq -r '[.hooks.UserPromptSubmit[]?.hooks[]?.command // empty][0]' \
      "${PROJECT_DIR}/.claude/settings.json" 2>/dev/null)
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

if [[ -d "${SESSION_DIR}" ]]; then
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
  # Detect Project Native Language setting
  NATIVE_LANG=$(grep -iE "Project Native Language.*:.*(Japanese|English)" "${PROJECT_DIR}/AGENTS.md" 2>/dev/null \
    | head -1 | grep -oiE "Japanese|English" | head -1 | tr '[:upper:]' '[:lower:]')
fi

if [[ -z "${NATIVE_LANG}" ]]; then
  print_warn "Could not detect Project Native Language in AGENTS.md"
  print_info "→ Verify AGENTS.md Project Configuration section"
else
  print_info "Project Native Language: ${NATIVE_LANG}"
  if [[ -f "${PROJECT_DIR}/task.md" ]] && [[ "${NATIVE_LANG}" == "japanese" ]]; then
    # Heuristic: count headings starting with ASCII alpha (may include acronyms like TODO/KPI)
    ASCII_HEADINGS=$(grep -cE "^#+\s+[A-Za-z]" "${PROJECT_DIR}/task.md" 2>/dev/null || true)
    ASCII_HEADINGS="${ASCII_HEADINGS:-0}"
    if [[ "${ASCII_HEADINGS}" -gt 5 ]]; then
      print_info "task.md contains ${ASCII_HEADINGS} ASCII-leading headings"
      print_info "(may be acronyms like TODO/KPI — manual review recommended)"
    else
      print_pass "task.md headings appear consistent with Project Native Language"
    fi
  else
    print_pass "Language consistency check skipped (no task.md or English project)"
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
    "${PROJECT_DIR}/.claude/settings.json" 2>/dev/null)
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
# Check 12: Bootstrap — SessionStart hook wiring (v1.5.5+)
# =============================================================================
print_section "Check 12: SessionStart hook (task.md auto-bootstrap)"
if ! "${HOOK_FILE_OK}" || ! "${HOOK_JSON_OK}"; then
  print_warn "Skipped — settings.json missing or invalid (see Check 1/2)"
elif command -v jq &>/dev/null; then
  SS_HOOK_CMD=$(jq -r '[.hooks.SessionStart[]?.hooks[]?.command // empty][0] // empty' \
    "${PROJECT_DIR}/.claude/settings.json" 2>/dev/null)
  if [[ -z "${SS_HOOK_CMD}" ]]; then
    print_warn "SessionStart hook not configured — task.md will not be auto-initialised"
    print_info "Add a SessionStart hook calling axiarch-scripts/axiarch-init-task-md.sh"
  elif [[ "${SS_HOOK_CMD}" == *"axiarch-init-task-md.sh"* ]]; then
    INIT_SCRIPT="${PROJECT_DIR}/axiarch-scripts/axiarch-init-task-md.sh"
    if [[ -f "${INIT_SCRIPT}" ]] && [[ -x "${INIT_SCRIPT}" ]]; then
      print_pass "SessionStart hook wired to axiarch-scripts/axiarch-init-task-md.sh"
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
  printf '%b' "${SUBLIMATED_FOUND}" | awk 'NF {print "     - blueprint/" $0}'
  print_info "(per CRYSTALLIZATION_PROTOCOL §3 SEARCH: AI should APPEND to existing"
  print_info " domain files first, only adding to core/010 if no match found)"
fi

# =============================================================================
# Check 14: Task Boundary Detection — Check D wiring (v1.7.0+)
# Verifies that axiarch-scripts/axiarch-boot-reminder.sh contains the Check D logic
# (VIOLATION-D + TTL bypass on domain-keyword shift). This closes the AI's
# "same session, no re-load needed" self-judgment loophole identified by
# adopter feedback.
# =============================================================================
print_section "Check 14: Task boundary detection (Check D wiring)"
REMINDER_SCRIPT_PATH="${PROJECT_DIR}/axiarch-scripts/axiarch-boot-reminder.sh"
if [[ ! -f "${REMINDER_SCRIPT_PATH}" ]]; then
  print_warn "axiarch-scripts/axiarch-boot-reminder.sh not found — Check D unavailable"
  print_info "Re-run init.sh to redistribute the v1.7.0+ reminder script"
elif grep -q "VIOLATION-D" "${REMINDER_SCRIPT_PATH}" 2>/dev/null \
   && grep -q "AXIARCH_TASK_BOUNDARY_DETECT" "${REMINDER_SCRIPT_PATH}" 2>/dev/null; then
  print_pass "Check D wired in axiarch-boot-reminder.sh (VIOLATION-D + AXIARCH_TASK_BOUNDARY_DETECT env var)"
  if [[ "${AXIARCH_TASK_BOUNDARY_DETECT:-1}" == "0" ]]; then
    print_info "Note: AXIARCH_TASK_BOUNDARY_DETECT=0 disables Check D at runtime"
  fi
else
  print_warn "axiarch-scripts/axiarch-boot-reminder.sh missing Check D logic (VIOLATION-D / task boundary detection)"
  print_info "This is a v1.7.0+ feature. Re-run init.sh to update."
  print_info "Without Check D, AI may slack on rule re-load when it judges 'session continues' — see LOADING_PROTOCOL §4 v1.7.0 note"
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
  print_pass "All automated checks passed across hook + crystallization + AGENTS protocols"
  print_info "Verifiable: §1, §2, §4, §6, §8, §9 + LOADING_PROTOCOL + Hooks (3) + Bootstrap + Task Boundary"
  print_info "Manual review needed: §0, §3, §5, §7 (see Out of Scope above)"
  print_info "(§6 became verifiable in v1.5.5 via PreToolUse — Check 11; v1.7.0 adds Check 14 task-boundary)"
else
  print_warn "Some checks failed/warned — see above for which protocol the AI is slacking on"
  print_info "Common misconception: \`permissions.allow Bash(echo *)\` is NOT required"
  print_info "(hook command is spawned outside the permission pipeline)"
fi
echo ""
print_info "Docs: https://code.claude.com/docs/en/hooks"
print_info "AGENTS.md (supreme law): root of project"
print_info "Crystallization Protocol: axiarch-rules/{lang}/CRYSTALLIZATION_PROTOCOL.md"
print_info "axiarch: https://github.com/hiroyuki-miyauchi/axiarch"
echo ""

exit "${EXIT_CODE}"
