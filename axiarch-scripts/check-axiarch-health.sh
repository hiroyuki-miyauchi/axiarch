#!/usr/bin/env bash
# shellcheck disable=SC2016
# =============================================================================
# Axiarch Health Diagnostic Tool
# https://github.com/hiroyuki-miyauchi/axiarch
#
# Usage:
#   bash axiarch-scripts/check-axiarch-health.sh [PROJECT_DIR] [--quiet|-q]
#
# --quiet : suppress all output except errors (for pre-commit hook usage)
#
# Diagnoses Axiarch enforcement health across 16 verifiable stages spanning
# the Hook layer, LOADING_PROTOCOL, CRYSTALLIZATION_PROTOCOL, AXIARCH.md
# protocols (Project Configuration, §6.2, §6.4, §6.6, §7, §9 — verifiable subset), the v1.5.5
# physical-block / bootstrap hooks, the v1.6.0 sublimated-file guide, and the
# v1.8.0 task-boundary detection:
#
#   Check 1-4  Hook layer when installed (settings detection, JSON syntax, hook structure, firing log)
#   Check 5    LOADING_PROTOCOL Step 4 — task.md adherence
#   Check 6    CRYSTALLIZATION_PROTOCOL §5 — count threshold (3+) + time-axis (>180d, v1.6.0+)
#   Check 7    AXIARCH process documentation — task docs presence
#   Check 8    AXIARCH §6.2 Human Approval and Deployment Ban — push hygiene
#   Check 9    AXIARCH §6.4 SSOT Sync and Branch Discipline — main parity
#   Check 10   AXIARCH §0 Project Configuration — Project Native Language configuration
#   Check 11   AXIARCH §6.6 Diff-Based Editing and Anti-Full-Overwrite — PreToolUse hook physical block (v1.5.5+)
#   Check 12   Bootstrap — SessionStart hook wiring (task.md auto-init, v1.5.5+)
#   Check 13   Sublimated files index — APPEND candidates (v1.6.0+)
#   Check 14   Task boundary detection — Check D wiring in axiarch-boot-reminder.sh (v1.8.0+)
#   Check 15   v1.9+ / v1.11+ integration — PostToolUse diff guard + task-state lifecycle + release/docs/prompt parity + ja/en heading-number parity + Claude Memory canonical boundary + source release-file tracking
#   Check 16   Reminder invariant clauses — Language First + Execution Harness + read-only delegation retained in axiarch-boot-reminder.sh (ja/en, v1.13.1+)
#
# Out of Scope (semantic judgment required, manual review):
#   AXIARCH §6.1 AI Self-Completion / §6.3 Database Integrity / §6.5 Existing Functionality Protection
#   AXIARCH §6.9 Role and Behavior
#
# Designed to detect the "AI adherence gap" early and force tool-based remediation
# instead of leaving users to manually debug.
# =============================================================================

set -euo pipefail

# Observation is tied to PROJECT_DIR, never an inherited alternate repository
# or index. These overrides affect only this process and its diagnostics.
while IFS= read -r git_env_name; do
  unset "${git_env_name}"
done < <(compgen -A variable GIT_ || true)
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1 GIT_OPTIONAL_LOCKS=0 GIT_NO_LAZY_FETCH=1 GIT_TERMINAL_PROMPT=0
health_git() {
  command git --no-pager --no-lazy-fetch -c core.fsmonitor=false "$@"
}

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

# v1.6.0+: --quiet flag suppresses verbose output (for pre-commit hook usage).
# Errors / warnings still go to stderr; exit code conveys overall result.
QUIET_MODE=false
ARGS=()
STATE_PHASE=structure
STATE_ARGS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --quiet|-q) QUIET_MODE=true; shift ;;
    --phase|--task|--session)
      [[ $# -ge 2 ]] || { echo "Missing value: $1" >&2; exit 2; }
      if [[ "$1" == "--phase" ]]; then STATE_PHASE="$2"; else STATE_ARGS+=("$1" "$2"); fi
      shift 2 ;;
    --*) echo "Unknown option: $1" >&2; exit 2 ;;
    *) ARGS+=("$1"); shift ;;
  esac
done
case "${STATE_PHASE}" in structure|readiness|completion) ;; *) echo 'Invalid health phase' >&2; exit 2 ;; esac
set -- "${ARGS[@]+"${ARGS[@]}"}"

if "${QUIET_MODE}"; then
  print_pass()    { :; }
  print_fail()    { printf '%b%s%b\n' "${RED}❌ " "$1" "${RESET}" >&2; }
  print_warn()    { :; }
  print_info()    { :; }
  print_section() { :; }
else
  print_pass()    { printf '%b%s%b\n' "${GREEN}✅ " "$1" "${RESET}"; }
  print_fail()    { printf '%b%s%b\n' "${RED}❌ " "$1" "${RESET}"; }
  print_warn()    { printf '%b%s%b\n' "${YELLOW}⚠️  " "$1" "${RESET}"; }
  print_info()    { printf '%b%s\n' "   ${CYAN}→${RESET} " "$1"; }
  print_section() { printf '\n%b%s%b\n' "${BOLD}${BLUE}" "== $1 ==" "${RESET}"; }
fi

PROJECT_DIR="${1:-$(pwd)}"
EXIT_CODE=0
HOOK_FILE_OK=true

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
CONFIG_PATHS=()
for config_path in .claude/settings.json .codex/hooks.json axiarch-manifest.json; do
  if [[ -e "${PROJECT_DIR}/${config_path}" || -L "${PROJECT_DIR}/${config_path}" ]]; then
    if [[ ! -f "${PROJECT_DIR}/${config_path}" || -L "${PROJECT_DIR}/${config_path}" ]]; then
      print_fail "Configuration must be a regular file: ${config_path}; remaining checks not run"
      exit 1
    fi
    CONFIG_PATHS+=("${config_path}")
  fi
done
if [[ ${#CONFIG_PATHS[@]} -gt 0 ]]; then
  if ! python3 "${PROJECT_DIR}/axiarch-scripts/axiarch_setup.py" check-source --source "${PROJECT_DIR}" --paths "${CONFIG_PATHS[@]}"; then
    print_fail "Configuration JSON is invalid or ambiguous; remaining checks not run"
    exit 1
  fi
  if [[ -f "${PROJECT_DIR}/axiarch-manifest.json" ]] && ! python3 "${PROJECT_DIR}/axiarch-scripts/axiarch_upgrade.py" manifest --source "${PROJECT_DIR}" --format check; then
    print_fail "Manifest validation failed; remaining checks not run"
    exit 1
  fi
  print_pass "Strict JSON checked for all installed hook configurations and the available manifest"
fi
# =============================================================================
# Check 3: UserPromptSubmit hook structure & Axiarch marker
# =============================================================================
print_section "Check 3: UserPromptSubmit hook structure"
check_hook_declarations() {
  local event="$1"
  local options=()
  $QUIET_MODE && options+=(--quiet)
  if ! python3 "${PROJECT_DIR}/axiarch-scripts/axiarch_inspect.py" --project "${PROJECT_DIR}" \
    --mode hooks --event "$event" "${options[@]+"${options[@]}"}"; then
    print_fail "$event: installed hook declarations are incomplete or unassessed; configuration preserved"
    EXIT_CODE=1
  fi
}
check_hook_declarations UserPromptSubmit

# =============================================================================
# Check 4: Session log firing history (technical firing)
# =============================================================================
print_section "Check 4: Recent session firing history"
PROJECT_KEY="${PROJECT_DIR//\//-}"
SESSION_DIR="${HOME}/.claude/projects/${PROJECT_KEY}"

if ! "${HOOK_FILE_OK}"; then
  print_warn "Skipped — optional hook layer is not installed (see Check 1)"
elif [[ -n "${CODEX_THREAD_ID:-}" || -n "${CODEX_CI:-}" || "${__CFBundleIdentifier:-}" == "com.openai.codex" ]]; then
  print_pass "Codex runtime detected — Claude Code hook firing history is not applicable"
elif [[ "${HOOK_FILE_PATH}" == */.codex/hooks.json ]]; then
  print_warn "Codex hook config detected — Claude Code session log firing history is not applicable"
  print_info "Codex hook validation is limited to structural checks in this diagnostic"
elif [[ -d "${SESSION_DIR}" ]]; then
  LATEST_JSONL=""
  while IFS= read -r -d '' session_candidate; do
    if [[ -z "${LATEST_JSONL}" || "${session_candidate}" -nt "${LATEST_JSONL}" ]]; then
      LATEST_JSONL="${session_candidate}"
    fi
  done < <(find "${SESSION_DIR}" -maxdepth 2 -name "*.jsonl" -type f -print0 2>/dev/null)
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
print_section "Check 5: Recorded rule references (not proof of AI adherence)"
if [[ -f "${PROJECT_DIR}/task.md" ]]; then
  RULE_REFS=$(grep -cE "AXIARCH\.md|AGENTS\.md|INDEX\.md|LOADING_PROTOCOL\.md" \
    "${PROJECT_DIR}/task.md" 2>/dev/null || true)
  RULE_REFS="${RULE_REFS:-0}"
  if [[ "${RULE_REFS}" -gt 0 ]]; then
    print_info "Legacy/root task.md contains ${RULE_REFS} rule references; actual loading is not proven"
  else
    print_warn "task.md exists but no rule references"
    print_info "→ Root pointers/drafts need not contain task evidence. Use the session docs and explicit readiness/completion phase."
  fi
else
  print_warn "task.md not found"
  print_info "→ Created on first task per AXIARCH.md process documentation. Send a prompt to trigger creation."
fi

# =============================================================================
# Check 6: Crystallization Protocol compliance (lessons_log threshold)
# =============================================================================
print_section "Check 6: Crystallization Protocol — lessons_log threshold"

LESSONS_LOG=""
for lang in ja en; do
  candidate="${PROJECT_DIR}/axiarch-rules/${lang}/blueprint/core/010_project_lessons_log.md"
  if [[ -f "${candidate}" && -z "${LESSONS_LOG}" ]]; then LESSONS_LOG="${candidate}"; fi
done
# Both installed languages are inspected by the same parser used by the reminder.
if ! python3 "${PROJECT_DIR}/axiarch-scripts/axiarch_inspect.py" --project "${PROJECT_DIR}" --mode lessons; then
  print_fail "Recorded lessons require review; see paths and issues above"
  EXIT_CODE=1
fi

# =============================================================================
# Check 7: AXIARCH.md Process Documentation (task docs)
# =============================================================================
print_section "Check 7: AXIARCH §7 Documentation and Native Task State (task docs)"

DOCS_OK=0
PROCESS_DOCS_MISSING=()
for f in task.md implementation_plan.md walkthrough.md; do
  if [[ -f "${PROJECT_DIR}/${f}" ]]; then
    SIZE=$(wc -c < "${PROJECT_DIR}/${f}" 2>/dev/null | awk '{print $1}')
    if [[ "${SIZE:-0}" -gt 0 ]]; then
      DOCS_OK=$((DOCS_OK + 1))
    else
      PROCESS_DOCS_MISSING+=("${f} (empty)")
    fi
  else
    PROCESS_DOCS_MISSING+=("${f} (not found)")
  fi
done

if [[ "${DOCS_OK}" -eq 3 ]]; then
  print_pass "All three documents present and non-empty (task / implementation_plan / walkthrough)"
elif [[ "${DOCS_OK}" -gt 0 ]]; then
  print_warn "Partial: ${DOCS_OK}/3 documents present"
  for missing in "${PROCESS_DOCS_MISSING[@]}"; do
    print_info "Missing/empty: ${missing}"
  done
  print_info "→ Partial legacy/root records are preserved. Check the chosen session before H2+ completion."
else
  print_warn "None of task.md / implementation_plan.md / walkthrough.md exist"
  print_info "→ AXIARCH.md requires current-task evidence — these are gitignored per-session docs"
fi

# =============================================================================
# Check 8: AXIARCH.md Deployment Ban (force-push / direct main commits)
# =============================================================================
print_section "Check 8: AXIARCH §6.2 Local Git context and reflog review hints"

GIT_CONTEXT=none
GIT_PROBE_DIR="$(cd "${PROJECT_DIR}" && pwd -P)"
if GIT_TOP=$(health_git -C "${PROJECT_DIR}" rev-parse --show-toplevel 2>/dev/null); then
  case "${GIT_PROBE_DIR}/" in
    "${GIT_TOP}/"*) GIT_CONTEXT=ready ;;
    *) GIT_CONTEXT=unassessed ;;
  esac
else
  while :; do
    if [[ -e "${GIT_PROBE_DIR}/.git" || -L "${GIT_PROBE_DIR}/.git" ]]; then
      GIT_CONTEXT=unassessed
      break
    fi
    [[ "${GIT_PROBE_DIR}" != / ]] || break
    GIT_PROBE_DIR="$(dirname "${GIT_PROBE_DIR}")"
  done
fi
CURRENT_BRANCH=""
GIT_BRANCH_OK=false
if [[ "${GIT_CONTEXT}" == ready ]]; then
  if CURRENT_BRANCH=$(health_git -C "${PROJECT_DIR}" branch --show-current 2>/dev/null); then
    GIT_BRANCH_OK=true
    if [[ "${CURRENT_BRANCH}" == main || "${CURRENT_BRANCH}" == master ]]; then
      print_warn "On ${CURRENT_BRANCH} branch directly — explicit approval boundaries still apply"
    elif [[ -z "${CURRENT_BRANCH}" ]]; then
      print_info "Detached HEAD / ブランチをcheckoutしていない状態"
    else
      print_pass "On feature branch: ${CURRENT_BRANCH}"
    fi
  else
    print_fail "GIT UNASSESSED: branch query failed / ブランチを確認できません"
    EXIT_CODE=1
  fi
  if REFLOG_TEXT=$(health_git -C "${PROJECT_DIR}" reflog --all --format=%gs 2>/dev/null); then
    FORCE_PUSH_COUNT=$(printf '%s\n' "${REFLOG_TEXT}" | awk '/forced-update|force-with-lease/ {n++} END {print n+0}')
    if [[ "${FORCE_PUSH_COUNT}" -gt 0 ]]; then
      print_warn "Local reflog has ${FORCE_PUSH_COUNT} matching messages; review locally / 関連する履歴文を確認してください"
    else
      print_info "No matching messages in available local reflog / 取得できたローカル履歴文には一致なし"
    fi
    print_info "Reflog text is not complete push history or approval evidence / push履歴全体や承認の証明ではありません"
  else
    print_fail "GIT UNASSESSED: reflog query failed / 履歴を確認できません"
    EXIT_CODE=1
  fi
elif [[ "${GIT_CONTEXT}" == unassessed ]]; then
  print_fail "GIT UNASSESSED: selected worktree could not be inspected / 指定作業ツリーを確認できません"
  print_info "Check Git availability, --no-lazy-fetch support and worktree configuration / Gitの対応状況・作業ツリー設定を確認"
  EXIT_CODE=1
else
  print_info "No Git worktree detected; Git history unassessed / Git履歴は検査対象外"
fi

# =============================================================================
# Check 9: AXIARCH.md SSOT Sync (main parity)
# =============================================================================
print_section "Check 9: AXIARCH §6.4 Local origin/main comparison (remote freshness unverified)"

if [[ "${GIT_CONTEXT}" == ready && "${GIT_BRANCH_OK}" == true ]]; then
  REF_STATUS=0
  health_git -C "${PROJECT_DIR}" show-ref --verify --quiet refs/remotes/origin/main 2>/dev/null || REF_STATUS=$?
  if [[ "${REF_STATUS}" -eq 1 ]]; then
    print_info "Local origin/main reference absent; no comparison or fetch / ローカル参照がなく比較・取得は未実施"
  elif [[ "${REF_STATUS}" -ne 0 ]]; then
    print_fail "GIT UNASSESSED: origin/main lookup failed / ローカル参照を確認できません"
    EXIT_CODE=1
  else
    HEAD_STATUS=0
    if [[ -n "${CURRENT_BRANCH}" ]]; then
      health_git -C "${PROJECT_DIR}" show-ref --verify --quiet "refs/heads/${CURRENT_BRANCH}" 2>/dev/null || HEAD_STATUS=$?
    fi
    if [[ "${HEAD_STATUS}" -eq 1 ]]; then
      print_info "Unborn branch; no committed baseline for comparison / 初回コミット前で比較元がありません"
    elif [[ "${HEAD_STATUS}" -ne 0 ]]; then
      print_fail "GIT UNASSESSED: HEAD lookup failed / 比較元を確認できません"
      EXIT_CODE=1
    elif COUNTS=$(health_git -C "${PROJECT_DIR}" rev-list --left-right --count HEAD...refs/remotes/origin/main 2>/dev/null) \
      && [[ "${COUNTS}" =~ ^([0-9]+)[[:space:]]+([0-9]+)$ ]]; then
      AHEAD="${BASH_REMATCH[1]}"
      BEHIND="${BASH_REMATCH[2]}"
      if [[ "${BEHIND}" -eq 0 ]]; then
        print_pass "Local origin/main comparison: behind=0, ahead=${AHEAD} / ローカル参照との比較"
      elif [[ "${BEHIND}" -lt 5 ]]; then
        print_warn "Behind local origin/main by ${BEHIND} commits / ローカル参照より後れています"
      else
        print_fail "Significantly behind local origin/main by ${BEHIND} commits"
        EXIT_CODE=1
      fi
      print_info "No remote freshness or approval verified; no fetch performed / リモート鮮度・承認は未確認、取得は未実施"
    else
      print_fail "GIT UNASSESSED: commit counts unavailable / コミット数を確認できません"
      EXIT_CODE=1
    fi
  fi
else
  print_info "Git comparison unassessed / Git比較は未確認"
fi

# =============================================================================
# Check 10: Project Native Language configuration (not document-language proof)
# =============================================================================
print_section "Check 10: AXIARCH §0 Project Native Language configuration"

# Use the same parser as startup and optional command generation. In particular,
# fenced/commented examples are not settings and ambiguous values are not success.
# This is a read-only configuration check, independent of task/session selection
# and AXIARCH_PROCESS_DOC_LANG (which only overrides generated document language).
if NATIVE_LANG=$(python3 "${PROJECT_DIR}/axiarch-scripts/axiarch_state.py" --project "${PROJECT_DIR}" --mode language); then
  case "${NATIVE_LANG}" in
    ja|en)
      print_info "Project Native Language: ${NATIVE_LANG} (configuration/folder fallback)"
      print_info "Document language and meaning are not assessed / 文書の言語・意味の適切さは未確認"
      print_info "Review the selected session and explicit user language; root/other-session records are not language evidence."
      ;;
    *)
      print_fail "LANGUAGE UNASSESSED: invalid resolver result / 言語設定の解決結果が不正"
      EXIT_CODE=1
      ;;
  esac
else
  print_fail "LANGUAGE UNASSESSED: fix AXIARCH.md / legacy AGENTS.md configuration; no files changed / 言語設定を確認してください"
  EXIT_CODE=1
fi

# =============================================================================
# Check 11: Physical Block — PreToolUse hook wiring (v1.5.5+)
# =============================================================================
print_section "Check 11: AXIARCH §6.6 Write hook declarations"
check_hook_declarations PreToolUse

# =============================================================================
# Check 12: Bootstrap — SessionStart hook wiring (v1.5.5+ / v1.11.0+ task-state lifecycle)
# =============================================================================
print_section "Check 12: SessionStart hook (task.md auto-bootstrap)"
check_hook_declarations SessionStart
if "${HOOK_FILE_OK}"; then
  INIT_SCRIPT="${PROJECT_DIR}/axiarch-scripts/axiarch-init-task-md.sh"
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
fi

# =============================================================================
# Check 13: Existing sublimated files — APPEND candidates (v1.6.0+)
# Surfaces existing crystallized lessons files so the AI can APPEND to them
# instead of accumulating new lessons in core/010 (which often leaves them
# below the 3+ count threshold and untouched indefinitely).
# =============================================================================
print_section "Check 13: Existing sublimated files (APPEND candidates)"
# Inventory is a set of candidates, not proof of their content or suitability.
if BLUEPRINT_CANDIDATES=$(python3 "${PROJECT_DIR}/axiarch-scripts/axiarch_inspect.py" --project "${PROJECT_DIR}" --mode blueprint-files); then
  if [[ -n "${BLUEPRINT_CANDIDATES}" ]]; then
    print_info "Blueprint candidates in installed languages (read before selecting an append target):"
    if ! "${QUIET_MODE}"; then
      printf '%s\n' "${BLUEPRINT_CANDIDATES}"
    fi
  else
    print_info "No numbered Blueprint files found; inspect the project structure before recording lessons"
  fi
else
  print_fail "Blueprint inventory could not be inspected"
  EXIT_CODE=1
fi

# =============================================================================
# Check 14: Task Boundary Detection — Check D wiring (v1.8.0+)
# Verifies that axiarch-scripts/axiarch-boot-reminder.sh contains the Check D logic
# (LOAD REVIEW + TTL bypass on domain-keyword shift). This surfaces candidates for the AI's
# "same session, no re-load needed" self-judgment loophole identified by
# adopter feedback.
# =============================================================================
print_section "Check 14: Task boundary detection (Check D wiring)"
REMINDER_SCRIPT_PATH="${PROJECT_DIR}/axiarch-scripts/axiarch-boot-reminder.sh"
if [[ ! -f "${REMINDER_SCRIPT_PATH}" ]]; then
  print_warn "axiarch-scripts/axiarch-boot-reminder.sh not found — Check D unavailable"
  print_info "Use axiarch-scripts/axiarch-upgrade.sh to update the v1.8.0+ reminder script"
elif grep -q "LOAD REVIEW" "${REMINDER_SCRIPT_PATH}" 2>/dev/null \
   && grep -q "AXIARCH_TASK_BOUNDARY_DETECT" "${REMINDER_SCRIPT_PATH}" 2>/dev/null; then
  print_pass "Check D wired in axiarch-boot-reminder.sh (LOAD REVIEW + AXIARCH_TASK_BOUNDARY_DETECT env var)"
  if [[ "${AXIARCH_TASK_BOUNDARY_DETECT:-1}" == "0" ]]; then
    print_info "Note: AXIARCH_TASK_BOUNDARY_DETECT=0 disables Check D at runtime"
  fi
else
  print_warn "axiarch-scripts/axiarch-boot-reminder.sh missing Check D logic (LOAD REVIEW / task boundary detection)"
  print_info "This is a v1.8.0+ feature. Use axiarch-scripts/axiarch-upgrade.sh to update."
  print_info "Without Check D, no keyword-based loading hint is emitted when it judges 'session continues' — see LOADING_PROTOCOL §4 v1.8.0 note"
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
check_hook_declarations PostToolUse
if "${HOOK_FILE_OK}"; then
  print_info "Configured diff mode: AXIARCH_DIFF_GUARD_MODE=${AXIARCH_DIFF_GUARD_MODE:-warn}; declaration checks do not test invocation"
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
      && grep -q "16 段階" "${PROJECT_DIR}/README.md" 2>/dev/null \
      && grep -q "axiarch-task-state.sh" "${PROJECT_DIR}/README.md" 2>/dev/null \
      && grep -q "Claude Memory正本境界" "${PROJECT_DIR}/README.md" 2>/dev/null \
      && grep -q "Claude Memory canonical boundary" "${PROJECT_DIR}/README.md" 2>/dev/null \
      && grep -q "update_plan" "${PROJECT_DIR}/README.md" 2>/dev/null \
      && grep -q "TaskCreate" "${PROJECT_DIR}/README.md" 2>/dev/null; then
      print_pass "Axiarch source README.md includes v1.9 diff guard, Claude Memory canonical boundary, and 16-stage diagnostic references"
    else
      print_warn "Axiarch source README.md may be missing source integration references"
      print_info "Expected README to mention axiarch-task-state.sh, Claude Memory canonical boundary, Codex update_plan, and Claude Code TaskCreate for v1.11.0"
      DOCS_MISSING=1
    fi
    if grep -q "Hook・診断・安全アップグレード利用時のみ必要" "${PROJECT_DIR}/README.md" 2>/dev/null \
      && grep -q "Required only for hooks, diagnostics, or safe upgrades" "${PROJECT_DIR}/README.md" 2>/dev/null \
      && grep -q "Optional for minimal operation otherwise" "${PROJECT_DIR}/README.md" 2>/dev/null \
      && grep -q "axiarch-harness/" "${PROJECT_DIR}/README.md" 2>/dev/null; then
      print_pass "Axiarch source README.md keeps axiarch-scripts required/optional boundary explicit"
    else
      print_warn "Axiarch source README.md may blur the axiarch-scripts required/optional boundary"
      print_info "Expected axiarch-scripts/ to be conditional, not part of the required minimal AXIARCH.md + AGENTS.md adapter + axiarch-rules/ + axiarch-harness/ setup"
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
    if grep -Eq "未実証|unverified" "${PROJECT_DIR}/README.md"; then
      print_pass "Agent validation boundary: Antigravity practical use; others unverified"
    else
      print_warn "Missing current validation scope: README.md"
      DOCS_MISSING=1
    fi
  else
    print_warn "Axiarch source README.md not found — cannot verify Axiarch source release integration"
    DOCS_MISSING=1
  fi

  if [[ -f "${PROJECT_DIR}/MARKET_STRATEGY.md" && -f "${PROJECT_DIR}/ROADMAP.md" ]]; then
    if grep -Eq "未実証|unverified" "${PROJECT_DIR}/MARKET_STRATEGY.md" \
      && grep -Eq "未実証|unverified" "${PROJECT_DIR}/ROADMAP.md"; then
      print_pass "Agent validation boundary: Antigravity practical use; others unverified"
    else
      print_warn "Missing current validation scope: MARKET_STRATEGY.md, ROADMAP.md"
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
      && grep -q "Claude Memory canonical boundary" "${PROJECT_DIR}/llms.txt" 2>/dev/null \
      && grep -q "Claude Memory canonical boundary" "${PROJECT_DIR}/llms-full.txt" 2>/dev/null \
      && grep -q "source release-file Git tracking" "${PROJECT_DIR}/llms.txt" 2>/dev/null \
      && grep -q "source release-file Git tracking" "${PROJECT_DIR}/llms-full.txt" 2>/dev/null \
      && grep -q "deduplicated action choices" "${PROJECT_DIR}/llms.txt" 2>/dev/null \
      && grep -q "deduplicated action choices" "${PROJECT_DIR}/llms-full.txt" 2>/dev/null \
      && grep -q "axiarch_bootstrap_dir" "${PROJECT_DIR}/llms.txt" 2>/dev/null \
      && grep -q "axiarch_bootstrap_dir" "${PROJECT_DIR}/llms-full.txt" 2>/dev/null \
      && grep -q "axiarch-task-state.sh" "${PROJECT_DIR}/llms.txt" 2>/dev/null \
      && grep -q "axiarch-task-state.sh" "${PROJECT_DIR}/llms-full.txt" 2>/dev/null \
      && grep -q "update_plan" "${PROJECT_DIR}/llms.txt" 2>/dev/null \
      && grep -q "TaskCreate" "${PROJECT_DIR}/llms-full.txt" 2>/dev/null; then
      print_pass "Axiarch source llms files keep source-only upgrade boundary, Claude Memory canonical boundary, deduplicated choices, and release-file tracking explicit"
    else
      print_warn "Axiarch source llms files may omit the source-only upgrade boundary, Claude Memory canonical boundary, deduplicated choices, or release-file tracking"
      print_info "Expected llms.txt and llms-full.txt to mention source-repository-only default skip, explicit interactive selection, Claude Memory canonical boundary, deduplicated action choices, temporary helper bootstrap for older adopters, source release-file Git tracking, axiarch-task-state.sh, update_plan, and TaskCreate"
      DOCS_MISSING=1
    fi
    if grep -Eq "未実証|unverified" "${PROJECT_DIR}/llms.txt" \
      && grep -Eq "未実証|unverified" "${PROJECT_DIR}/llms-full.txt"; then
      print_pass "Agent validation boundary: Antigravity practical use; others unverified"
    else
      print_warn "Missing current validation scope: llms.txt, llms-full.txt"
      DOCS_MISSING=1
    fi
  else
    print_warn "Axiarch source llms files not found — cannot verify source-only upgrade boundary"
    DOCS_MISSING=1
  fi

  if [[ -f "${PROJECT_DIR}/axiarch-scripts/README.md" ]]; then
    if grep -q "axiarch-diff-guard.sh" "${PROJECT_DIR}/axiarch-scripts/README.md" 2>/dev/null \
      && grep -q "16-stage" "${PROJECT_DIR}/axiarch-scripts/README.md" 2>/dev/null \
      && grep -q "対話選択肢重複排除" "${PROJECT_DIR}/axiarch-scripts/README.md" 2>/dev/null \
      && grep -q "deduplicated interactive choices" "${PROJECT_DIR}/axiarch-scripts/README.md" 2>/dev/null \
      && grep -q "axiarch-task-state.sh" "${PROJECT_DIR}/axiarch-scripts/README.md" 2>/dev/null \
      && grep -q "Claude Memory正本境界" "${PROJECT_DIR}/axiarch-scripts/README.md" 2>/dev/null \
      && grep -q "Claude Memory canonical boundary" "${PROJECT_DIR}/axiarch-scripts/README.md" 2>/dev/null \
      && grep -q "AXIARCH_PROCESS_DOC_MODE" "${PROJECT_DIR}/axiarch-scripts/README.md" 2>/dev/null \
      && grep -q "AXIARCH_PROCESS_DOC_LANG" "${PROJECT_DIR}/axiarch-scripts/README.md" 2>/dev/null; then
      print_pass "Axiarch source axiarch-scripts/README.md includes v1.9 diff guard, 16-stage diagnostics, Claude Memory canonical boundary, and deduplicated-choice references"
    else
      print_warn "Axiarch source axiarch-scripts/README.md may be missing source integration references"
      print_info "Expected scripts README to mention axiarch-task-state.sh, Claude Memory canonical boundary, AXIARCH_PROCESS_DOC_MODE, and AXIARCH_PROCESS_DOC_LANG for v1.11.0"
      DOCS_MISSING=1
    fi
    if grep -q "最小構成の必須ファイルではありません" "${PROJECT_DIR}/axiarch-scripts/README.md" 2>/dev/null \
      && grep -q "not required for the minimal Axiarch setup" "${PROJECT_DIR}/axiarch-scripts/README.md" 2>/dev/null \
      && grep -q "axiarch-harness/" "${PROJECT_DIR}/axiarch-scripts/README.md" 2>/dev/null \
      && grep -q "recommended tooling for diagnostics, hook reinforcement, and safe upgrades" "${PROJECT_DIR}/axiarch-scripts/README.md" 2>/dev/null \
      && grep -q "axiarch_bootstrap_dir" "${PROJECT_DIR}/axiarch-scripts/README.md" 2>/dev/null \
      && grep -q -- "--yes" "${PROJECT_DIR}/axiarch-scripts/README.md" 2>/dev/null \
      && grep -q "人間がapply実行を明示承認済み" "${PROJECT_DIR}/axiarch-scripts/README.md" 2>/dev/null \
      && grep -q "human owner has explicitly approved apply" "${PROJECT_DIR}/axiarch-scripts/README.md" 2>/dev/null; then
      print_pass "Axiarch source axiarch-scripts/README.md keeps minimal/optional script boundary explicit"
    else
      print_warn "Axiarch source axiarch-scripts/README.md may blur the minimal/optional script boundary"
      print_info "Expected script README to say scripts are optional for minimal AXIARCH.md + AGENTS.md adapter + axiarch-rules/ + axiarch-harness/ setup, show temporary helper bootstrap for older adopters, and document --yes only for reviewed and human-approved non-interactive apply"
      DOCS_MISSING=1
    fi
  else
    print_warn "Axiarch source axiarch-scripts/README.md not found — cannot verify script README integration"
    DOCS_MISSING=1
  fi

  if [[ -f "${PROJECT_DIR}/axiarch-harness/README.md" ]]; then
    if grep -q "Axiarch実行ハーネス" "${PROJECT_DIR}/axiarch-harness/README.md" 2>/dev/null \
      && grep -q "Usage / 使い方" "${PROJECT_DIR}/axiarch-harness/README.md" 2>/dev/null \
      && grep -q "Protocol Map / プロトコル対応表" "${PROJECT_DIR}/axiarch-harness/README.md" 2>/dev/null \
      && grep -q "Harness Engineering" "${PROJECT_DIR}/axiarch-harness/README.md" 2>/dev/null \
      && grep -q "ハーネスエンジニアリング" "${PROJECT_DIR}/axiarch-harness/README.md" 2>/dev/null \
      && grep -q "メインエージェントが同じ役割パスを順番に実行する" "${PROJECT_DIR}/axiarch-harness/README.md" 2>/dev/null \
      && grep -q "main agent performs the same role passes sequentially" "${PROJECT_DIR}/axiarch-harness/README.md" 2>/dev/null; then
      print_pass "Axiarch source axiarch-harness/README.md keeps bilingual harness guidance explicit"
    else
      print_warn "Axiarch source axiarch-harness/README.md may not be bilingual enough for the canonical harness layer"
      print_info "Expected the harness README to explain Harness Engineering, purpose, usage, protocol map, and main-agent fallback in both Japanese and English"
      DOCS_MISSING=1
    fi
  else
    print_warn "Axiarch source axiarch-harness/README.md not found — cannot verify harness README bilingual guidance"
    DOCS_MISSING=1
  fi

  if [[ -f "${PROJECT_DIR}/axiarch-harness/ja/EXECUTION_HARNESS_PROTOCOL.md" \
     && -f "${PROJECT_DIR}/axiarch-harness/en/EXECUTION_HARNESS_PROTOCOL.md" ]]; then
    if grep -q "ハーネスエンジニアリング" "${PROJECT_DIR}/axiarch-harness/ja/EXECUTION_HARNESS_PROTOCOL.md" 2>/dev/null \
      && grep -q "3層モデル" "${PROJECT_DIR}/axiarch-harness/ja/EXECUTION_HARNESS_PROTOCOL.md" 2>/dev/null \
      && grep -q "Harness Engineering" "${PROJECT_DIR}/axiarch-harness/en/EXECUTION_HARNESS_PROTOCOL.md" 2>/dev/null \
      && grep -q "three-layer model" "${PROJECT_DIR}/axiarch-harness/en/EXECUTION_HARNESS_PROTOCOL.md" 2>/dev/null; then
      print_pass "Axiarch source execution harness protocols bind Harness Engineering to task execution in both Japanese and English"
    else
      print_warn "Axiarch source execution harness protocols may omit the Harness Engineering task-execution boundary"
      print_info "Expected ja/en EXECUTION_HARNESS_PROTOCOL.md to state that Harness Engineering applies the three-layer model to task execution rather than adding a fourth rule layer"
      DOCS_MISSING=1
    fi
  else
    print_warn "Axiarch source execution harness protocols missing — cannot verify Harness Engineering task-execution boundary"
    DOCS_MISSING=1
  fi

  if [[ -f "${PROJECT_DIR}/AXIARCH.md" \
     && -f "${PROJECT_DIR}/README.md" \
     && -f "${PROJECT_DIR}/CHANGELOG.md" \
     && -f "${PROJECT_DIR}/CONTRIBUTING.md" \
     && -f "${PROJECT_DIR}/ROADMAP.md" \
     && -f "${PROJECT_DIR}/llms.txt" \
     && -f "${PROJECT_DIR}/llms-full.txt" \
     && -f "${PROJECT_DIR}/axiarch-manifest.json" \
     && -f "${PROJECT_DIR}/axiarch-harness/README.md" \
     && -f "${PROJECT_DIR}/axiarch-harness/ja/EXECUTION_HARNESS_PROTOCOL.md" \
     && -f "${PROJECT_DIR}/axiarch-harness/en/EXECUTION_HARNESS_PROTOCOL.md" \
     && -f "${PROJECT_DIR}/axiarch-rules/ja/README.md" \
     && -f "${PROJECT_DIR}/axiarch-rules/en/README.md" \
     && -f "${PROJECT_DIR}/axiarch-rules/ja/INDEX.md" \
     && -f "${PROJECT_DIR}/axiarch-rules/en/INDEX.md" \
     && -f "${PROJECT_DIR}/axiarch-rules/ja/blueprint/INDEX.md" \
     && -f "${PROJECT_DIR}/axiarch-rules/en/blueprint/INDEX.md" \
     && -f "${PROJECT_DIR}/axiarch-prompts/README.md" \
     && -f "${PROJECT_DIR}/axiarch-scripts/README.md" ]]; then
    if grep -q "Harness Engineering" "${PROJECT_DIR}/AXIARCH.md" 2>/dev/null \
      && grep -q "ハーネスエンジニアリング" "${PROJECT_DIR}/AXIARCH.md" 2>/dev/null \
      && grep -q "Harness Engineering" "${PROJECT_DIR}/README.md" 2>/dev/null \
      && grep -q "ハーネスエンジニアリング" "${PROJECT_DIR}/README.md" 2>/dev/null \
      && grep -q "Harness Engineering" "${PROJECT_DIR}/CHANGELOG.md" 2>/dev/null \
      && grep -q "ハーネスエンジニアリング" "${PROJECT_DIR}/CHANGELOG.md" 2>/dev/null \
      && grep -q "Harness Engineering" "${PROJECT_DIR}/CONTRIBUTING.md" 2>/dev/null \
      && grep -q "ハーネスエンジニアリング" "${PROJECT_DIR}/CONTRIBUTING.md" 2>/dev/null \
      && grep -q "Harness Engineering" "${PROJECT_DIR}/ROADMAP.md" 2>/dev/null \
      && grep -q "ハーネスエンジニアリング" "${PROJECT_DIR}/ROADMAP.md" 2>/dev/null \
      && grep -q "Harness Engineering" "${PROJECT_DIR}/llms.txt" 2>/dev/null \
      && grep -q "Harness Engineering" "${PROJECT_DIR}/llms-full.txt" 2>/dev/null \
      && grep -q "Harness Engineering" "${PROJECT_DIR}/axiarch-manifest.json" 2>/dev/null \
      && grep -q "ハーネスエンジニアリング" "${PROJECT_DIR}/axiarch-manifest.json" 2>/dev/null \
      && grep -q "Harness Engineering" "${PROJECT_DIR}/axiarch-harness/README.md" 2>/dev/null \
      && grep -q "ハーネスエンジニアリング" "${PROJECT_DIR}/axiarch-harness/README.md" 2>/dev/null \
      && grep -q "ハーネスエンジニアリング" "${PROJECT_DIR}/axiarch-harness/ja/EXECUTION_HARNESS_PROTOCOL.md" 2>/dev/null \
      && grep -q "Harness Engineering" "${PROJECT_DIR}/axiarch-harness/en/EXECUTION_HARNESS_PROTOCOL.md" 2>/dev/null \
      && grep -q "ハーネスエンジニアリング" "${PROJECT_DIR}/axiarch-rules/ja/README.md" 2>/dev/null \
      && grep -q "Harness Engineering" "${PROJECT_DIR}/axiarch-rules/en/README.md" 2>/dev/null \
      && grep -q "ハーネスエンジニアリング" "${PROJECT_DIR}/axiarch-rules/ja/INDEX.md" 2>/dev/null \
      && grep -q "Harness Engineering" "${PROJECT_DIR}/axiarch-rules/en/INDEX.md" 2>/dev/null \
      && grep -q "ハーネスエンジニアリング" "${PROJECT_DIR}/axiarch-rules/ja/blueprint/INDEX.md" 2>/dev/null \
      && grep -q "Harness Engineering" "${PROJECT_DIR}/axiarch-rules/en/blueprint/INDEX.md" 2>/dev/null \
      && grep -q "ハーネスエンジニアリング" "${PROJECT_DIR}/axiarch-prompts/README.md" 2>/dev/null \
      && grep -q "Harness Engineering" "${PROJECT_DIR}/axiarch-prompts/README.md" 2>/dev/null \
      && grep -q "ハーネスエンジニアリング" "${PROJECT_DIR}/axiarch-scripts/README.md" 2>/dev/null \
      && grep -q "Harness Engineering" "${PROJECT_DIR}/axiarch-scripts/README.md" 2>/dev/null; then
      print_pass "Axiarch source docs keep Harness Engineering explicit across canonical, public, manifest, harness protocol, rules, prompt, script, and AI-facing entrypoints"
    else
      print_warn "Axiarch source docs may omit Harness Engineering concept wording across one or more entrypoints"
      print_info "Expected AXIARCH.md, README, CHANGELOG, CONTRIBUTING, ROADMAP, manifest, harness README/protocol files, llms files, rules README/INDEX files, prompt README, and scripts README to keep Harness Engineering explicit"
      DOCS_MISSING=1
    fi
  else
    print_warn "Axiarch source docs missing one or more files needed for Harness Engineering entrypoint parity check"
    DOCS_MISSING=1
  fi

  if [[ -f "${PROJECT_DIR}/.claude/memory/MEMORY.md" ]]; then
    if grep -q "正本境界 / Canonical Boundary" "${PROJECT_DIR}/.claude/memory/MEMORY.md" 2>/dev/null \
      && grep -q "プロトコル、ロード順、承認境界、実行手順はこのファイルに複製せず" "${PROJECT_DIR}/.claude/memory/MEMORY.md" 2>/dev/null \
      && grep -q "Do not duplicate protocols, loading order, approval boundaries, or execution steps here" "${PROJECT_DIR}/.claude/memory/MEMORY.md" 2>/dev/null \
      && ! grep -Eq "axiarch-rules/|axiarch-harness/|axiarch-prompts/|TaskCreate|Human Approval|Deployment Ban|SSOT Sync" "${PROJECT_DIR}/.claude/memory/MEMORY.md" 2>/dev/null; then
      print_pass "Axiarch source Claude Memory template keeps AXIARCH.md as canonical boundary without duplicating protocols"
    else
      print_warn "Axiarch source Claude Memory template may duplicate Axiarch protocol details"
      print_info "Expected .claude/memory/MEMORY.md to keep only short operational memory and point canonical governance back to AXIARCH.md"
      DOCS_MISSING=1
    fi
  else
    print_warn "Axiarch source .claude/memory/MEMORY.md not found — cannot verify Claude Memory canonical boundary"
    DOCS_MISSING=1
  fi

  loading_protocol_boundary_missing=0
  if [[ -f "${PROJECT_DIR}/axiarch-rules/ja/LOADING_PROTOCOL.md" ]] \
    && grep -q "source-only既定skipとinteractive明示override" "${PROJECT_DIR}/axiarch-rules/ja/LOADING_PROTOCOL.md" 2>/dev/null \
    && grep -q "対話選択肢重複排除" "${PROJECT_DIR}/axiarch-rules/ja/LOADING_PROTOCOL.md" 2>/dev/null \
    && grep -q "README/llms/scripts README" "${PROJECT_DIR}/axiarch-rules/ja/LOADING_PROTOCOL.md" 2>/dev/null \
    && grep -q "Claude Memory正本境界" "${PROJECT_DIR}/axiarch-rules/ja/LOADING_PROTOCOL.md" 2>/dev/null \
    && grep -q "ネイティブタスク" "${PROJECT_DIR}/axiarch-rules/ja/LOADING_PROTOCOL.md" 2>/dev/null \
    && grep -q "AXIARCH_PROCESS_DOC_LANG" "${PROJECT_DIR}/axiarch-rules/ja/LOADING_PROTOCOL.md" 2>/dev/null \
    && grep -q "update_plan" "${PROJECT_DIR}/axiarch-rules/ja/LOADING_PROTOCOL.md" 2>/dev/null \
    && grep -q "TaskCreate" "${PROJECT_DIR}/axiarch-rules/ja/LOADING_PROTOCOL.md" 2>/dev/null \
    && [[ -f "${PROJECT_DIR}/axiarch-rules/en/LOADING_PROTOCOL.md" ]] \
    && grep -q "source-only default skip with explicit interactive override" "${PROJECT_DIR}/axiarch-rules/en/LOADING_PROTOCOL.md" 2>/dev/null \
    && grep -q "deduplicated interactive choices" "${PROJECT_DIR}/axiarch-rules/en/LOADING_PROTOCOL.md" 2>/dev/null \
    && grep -q "README, llms, and scripts README" "${PROJECT_DIR}/axiarch-rules/en/LOADING_PROTOCOL.md" 2>/dev/null \
    && grep -q "Claude Memory canonical boundary" "${PROJECT_DIR}/axiarch-rules/en/LOADING_PROTOCOL.md" 2>/dev/null \
    && grep -q "Native Task" "${PROJECT_DIR}/axiarch-rules/en/LOADING_PROTOCOL.md" 2>/dev/null \
    && grep -q "AXIARCH_PROCESS_DOC_LANG" "${PROJECT_DIR}/axiarch-rules/en/LOADING_PROTOCOL.md" 2>/dev/null \
    && grep -q "update_plan" "${PROJECT_DIR}/axiarch-rules/en/LOADING_PROTOCOL.md" 2>/dev/null \
    && grep -q "TaskCreate" "${PROJECT_DIR}/axiarch-rules/en/LOADING_PROTOCOL.md" 2>/dev/null; then
    print_pass "Axiarch source LOADING_PROTOCOL files keep Safe Upgrade health scope aligned"
  else
    print_warn "Axiarch source LOADING_PROTOCOL files may have stale Safe Upgrade health scope"
    print_info "Expected ja/en LOADING_PROTOCOL to mention source-only explicit override, deduplicated interactive choices, README/llms/scripts README boundary checks, Claude Memory canonical boundary, native task-state sync, Project Native Language template selection, update_plan, and TaskCreate"
    loading_protocol_boundary_missing=1
  fi
  if [[ "${loading_protocol_boundary_missing}" -ne 0 ]]; then
    DOCS_MISSING=1
  fi

  index_health_scope_missing=0
  if [[ -f "${PROJECT_DIR}/axiarch-rules/ja/INDEX.md" ]] \
    && grep -q "Claude Memory正本境界検査" "${PROJECT_DIR}/axiarch-rules/ja/INDEX.md" 2>/dev/null \
    && [[ -f "${PROJECT_DIR}/axiarch-rules/en/INDEX.md" ]] \
    && grep -q "Claude Memory canonical-boundary checks" "${PROJECT_DIR}/axiarch-rules/en/INDEX.md" 2>/dev/null; then
    print_pass "Axiarch source INDEX files keep Claude Memory health scope aligned"
  else
    print_warn "Axiarch source INDEX files may have stale Claude Memory health scope"
    print_info "Expected ja/en INDEX files to mention the Claude Memory canonical-boundary health check in the check-axiarch-health.sh summary"
    index_health_scope_missing=1
  fi
  if [[ "${index_health_scope_missing}" -ne 0 ]]; then
    DOCS_MISSING=1
  fi

  if grep -Eq "未実証|unverified" "${PROJECT_DIR}/axiarch-rules/ja/LOADING_PROTOCOL.md" \
    && grep -Eq "未実証|unverified" "${PROJECT_DIR}/axiarch-rules/en/LOADING_PROTOCOL.md"; then
    print_pass "Agent validation boundary: Antigravity practical use; others unverified"
  else
    print_warn "Missing current validation scope: axiarch-rules/ja/LOADING_PROTOCOL.md, axiarch-rules/en/LOADING_PROTOCOL.md"
    DOCS_MISSING=1
  fi


  if grep -Eq "未実証|unverified" "${PROJECT_DIR}/axiarch-rules/ja/README.md" \
    && grep -Eq "未実証|unverified" "${PROJECT_DIR}/axiarch-rules/en/README.md"; then
    print_pass "Agent validation boundary: Antigravity practical use; others unverified"
  else
    print_warn "Missing current validation scope: axiarch-rules/ja/README.md, axiarch-rules/en/README.md"
    DOCS_MISSING=1
  fi

  if [[ -f "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" ]]; then
    if grep -q 'manifest --source .* --format groups' "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
      && grep -q '^[[:space:]]*register_manifest_items$' "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
      && grep -q "iter_groups" "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
      && grep -q "path_is_excluded" "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
      && grep -q "entry.get('exclude', \[\])" "${PROJECT_DIR}/axiarch-scripts/axiarch_upgrade.py" 2>/dev/null \
      && grep -q '.github/workflows/lint.yml' "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
      && grep -q "action=%s" "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
      && grep -q "option_actions" "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
      && grep -q "for action in update-all review-each show-diff skip" "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
      && grep -q "resolve_upgrade_version_label" "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
      && grep -q "normalize_axiarch_version_label" "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
      && grep -q "Execution Harness / Harness Engineering" "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
      && grep -q "実行ハーネス / ハーネスエンジニアリング" "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
      && grep -q "Discover actual folders" "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
      && grep -q "axiarch_upgrade.py" "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
      && grep -q "confirmed_version" "${PROJECT_DIR}/axiarch-scripts/axiarch_upgrade.py" 2>/dev/null \
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
      print_pass "Axiarch source upgrade wizard reads axiarch-manifest.json, honors manifest excludes, preserves source-only CI boundaries by default while allowing explicit interactive override, displays deduplicated effective group actions, normalizes upgrade metadata versions, keeps the fallback execution-harness group label aligned with Harness Engineering, discovers core Blueprint project state in fallback mode, hashes optional prompts when applied, enforces replace-if-local-unchanged review fallback with reason labels and base option guidance, records file/directory type conflicts for review, and handles EOF on interactive confirmations safely"
    else
      print_warn "Axiarch source upgrade wizard may not be fully wired to axiarch-manifest.json"
      print_info "Expected manifest file parsing, manifest-driven group iteration, manifest exclude handling, source-only CI fallback classification with explicit interactive override, deduplicated effective action display, metadata version normalization, Harness Engineering fallback group labeling, core Blueprint fallback discovery, optional prompt hashing, replace-if-local-unchanged enforcement with reason labels and base option guidance, type-conflict review logging, and EOF-safe interactive confirmation defaults"
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
    # shellcheck disable=SC2016 # The copied shell expressions are matched as literals.
    if grep -q "check_existing_install" "${PROJECT_DIR}/init.sh" 2>/dev/null \
      && grep -q "Existing Axiarch files detected" "${PROJECT_DIR}/init.sh" 2>/dev/null \
      && grep -q "Existing installation preserved" "${PROJECT_DIR}/init.sh" 2>/dev/null \
      && grep -q "raw.githubusercontent.com" "${PROJECT_DIR}/init.sh" 2>/dev/null \
      && grep -q "axiarch_bootstrap_dir" "${PROJECT_DIR}/init.sh" 2>/dev/null \
      && grep -q "stage_and_install" "${PROJECT_DIR}/init.sh" 2>/dev/null \
      && grep -q 'cp -R "$SOURCE_DIR/axiarch-rules/."' "${PROJECT_DIR}/init.sh" 2>/dev/null \
      && grep -q 'cp -R "$SOURCE_DIR/axiarch-prompts/."' "${PROJECT_DIR}/init.sh" 2>/dev/null; then
      print_pass "Axiarch source init.sh guards existing installations, handles missing upgrade helpers, and avoids nested rules/prompts directory copies"
    else
      print_warn "Axiarch source init.sh may not protect existing installations from full installer misuse"
      print_info "Expected existing-install detection, Safe Upgrade guidance, missing-helper bootstrap guidance, pre-copy collision detection, isolated staging, and contents-copy semantics for rules/prompts"
      DOCS_MISSING=1
    fi
    if grep -q "OpenAI Codex — Unverified primary candidate" "${PROJECT_DIR}/init.sh" 2>/dev/null \
      && grep -q "Claude Code — Unverified primary candidate" "${PROJECT_DIR}/init.sh" 2>/dev/null \
      && grep -q "Google Antigravity — Production-validated primary" "${PROJECT_DIR}/init.sh" 2>/dev/null; then
      print_pass "Axiarch source init.sh presents current agent validation status in installer choices"
    else
      print_warn "Axiarch source init.sh may present stale agent validation status in installer choices"
      print_info "Expected init.sh choices to mark Codex, Claude Code, and Google Antigravity with Antigravity practically validated and the other two unverified"
      DOCS_MISSING=1
    fi
    if grep -q "set_project_native_language" "${PROJECT_DIR}/init.sh" 2>/dev/null \
      && grep -q "command -v grep" "${PROJECT_DIR}/init.sh" 2>/dev/null \
      && grep -q "command -v mv" "${PROJECT_DIR}/init.sh" 2>/dev/null \
      && grep -q "Configured: AXIARCH.md Project Native Language" "${PROJECT_DIR}/init.sh" 2>/dev/null \
      && grep -q "Project Native Language is set to" "${PROJECT_DIR}/init.sh" 2>/dev/null \
      && grep -q "stage_and_install" "${PROJECT_DIR}/init.sh" 2>/dev/null; then
      print_pass "Axiarch source init.sh writes selected Project Native Language into AXIARCH.md with checked command prerequisites and staged validation"
    else
      print_warn "Axiarch source init.sh may not apply the selected Project Native Language to the copied canonical entrypoint"
      print_info "Expected init.sh to check command prerequisites used for language rewriting, configure AXIARCH.md Project Native Language after copy, require the canonical entry, and report the configured language in next steps"
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

    if jq -e '
      any(.files[]; .path == "AXIARCH.md" and .group == "core_protocol" and .owner == "mixed" and .policy == "review")
    ' "${PROJECT_DIR}/axiarch-manifest.json" >/dev/null 2>&1 \
      && [[ -f "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" ]] \
      && grep -q 'add_item "core_protocol" "AXIARCH.md" "mixed" "review" "all"' "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null; then
      print_pass "Axiarch source manifest and fallback protect AXIARCH.md as mixed/review"
    else
      print_warn "Axiarch source manifest or fallback may treat AXIARCH.md as safe-only replaceable"
      print_info "Expected AXIARCH.md to remain core_protocol / mixed / review because it contains adopter-owned Project Native Language"
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
              # shellcheck disable=SC2053 # Manifest excludes intentionally support glob patterns.
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

  language_governance_missing=0
  language_governance_rel="universal/engineering/320_programming_language_governance.md"
  react_native_rel="universal/engineering/420_react_native.md"
  cloud_platform_rel="universal/engineering/520_cloud_application_platforms.md"
  azure_profile_rel="universal/engineering/530_azure_cloud.md"
  for lang in ja en; do
    language_governance_file="${PROJECT_DIR}/axiarch-rules/${lang}/${language_governance_rel}"
    if [[ ! -f "${language_governance_file}" ]]; then
      print_warn "Axiarch source programming-language governance rule missing for ${lang}"
      language_governance_missing=1
      continue
    fi

    language_governance_sections=$(grep -Ec '^## §[0-9]+\.' "${language_governance_file}" 2>/dev/null || true)
    language_governance_rules=$(grep -Ec 'Rule 320\.[0-9]+:' "${language_governance_file}" 2>/dev/null || true)
    language_governance_rule_ids=$(grep -oE 'Rule 320\.[0-9]+' "${language_governance_file}" 2>/dev/null \
      | sed 's/.*\.//' | sort -n | uniq | paste -sd, -)
    language_governance_expected_rule_ids=$(awk 'BEGIN { for (i = 1; i <= 86; i++) printf "%s%d", (i > 1 ? "," : ""), i }')
    if ! grep -Eq '^# 320\.' "${language_governance_file}" 2>/dev/null \
      || ! grep -Eq 'Rules? 320\.1.*320\.86|Rule 320\.1.*320\.86' "${language_governance_file}" 2>/dev/null \
      || [[ "${language_governance_sections}" -ne 19 \
      || "${language_governance_rules}" -ne 86 \
      || "${language_governance_rule_ids}" != "${language_governance_expected_rule_ids}" ]]; then
      print_warn "Axiarch source programming-language governance structure drift for ${lang}: sections=${language_governance_sections}, rules=${language_governance_rules}"
      language_governance_missing=1
    fi

    if [[ "${lang}" == "ja" ]]; then
      if ! grep -Fq "source、binary／ABI" "${language_governance_file}" 2>/dev/null \
        || ! grep -Fq "consumer matrix" "${language_governance_file}" 2>/dev/null \
        || ! grep -Fq "同一の検証済みartifact" "${language_governance_file}" 2>/dev/null \
        || ! grep -Fq "generated SDK" "${language_governance_file}" 2>/dev/null \
        || ! grep -Fq "registry namespace" "${language_governance_file}" 2>/dev/null; then
        print_warn "Axiarch source public library, SDK, package compatibility, or distribution contract drift for ${lang}"
        language_governance_missing=1
      fi
    else
      if ! grep -Fq "source, binary or ABI" "${language_governance_file}" 2>/dev/null \
        || ! grep -Fq "consumer matrix" "${language_governance_file}" 2>/dev/null \
        || ! grep -Fq "same verified artifact" "${language_governance_file}" 2>/dev/null \
        || ! grep -Fq "generated SDK" "${language_governance_file}" 2>/dev/null \
        || ! grep -Fq "registry namespace" "${language_governance_file}" 2>/dev/null; then
        print_warn "Axiarch source public library, SDK, package compatibility, or distribution contract drift for ${lang}"
        language_governance_missing=1
      fi
    fi

    if [[ "${lang}" == "ja" ]]; then
      if ! grep -Fq "freshかつ隔離されたenvironment" "${language_governance_file}" 2>/dev/null \
        || ! grep -Fq "rich HTML／JavaScript" "${language_governance_file}" 2>/dev/null \
        || ! grep -Fq "orphaned schedule" "${language_governance_file}" 2>/dev/null \
        || ! grep -Fq "別の権限主体" "${language_governance_file}" 2>/dev/null; then
        print_warn "Axiarch source notebook or literate computational artifact contract drift for ${lang}"
        language_governance_missing=1
      fi
    else
      if ! grep -Fq "fresh isolated environment" "${language_governance_file}" 2>/dev/null \
        || ! grep -Fq "rich HTML or JavaScript" "${language_governance_file}" 2>/dev/null \
        || ! grep -Fq "orphaned schedules" "${language_governance_file}" 2>/dev/null \
        || ! grep -Fq "another authorized principal" "${language_governance_file}" 2>/dev/null; then
        print_warn "Axiarch source notebook or literate computational artifact contract drift for ${lang}"
        language_governance_missing=1
      fi
    fi

    if ! grep -q "HTML / CSS" "${language_governance_file}" 2>/dev/null \
      || ! grep -q "Node.js" "${language_governance_file}" 2>/dev/null \
      || ! grep -q "Dockerfile / Containerfile" "${language_governance_file}" 2>/dev/null \
      || ! grep -q "VBA" "${language_governance_file}" 2>/dev/null \
      || ! grep -Eq "Universal Applicability Contract|Universal適用契約" "${language_governance_file}" 2>/dev/null \
      || ! grep -Eq "continuity route|継続経路" "${language_governance_file}" 2>/dev/null \
      || ! grep -q "offboarding" "${language_governance_file}" 2>/dev/null \
      || ! grep -q "Blueprint parameter" "${language_governance_file}" 2>/dev/null \
      || ! grep -q "CODEOWNERS" "${language_governance_file}" 2>/dev/null \
      || ! grep -q "language_portfolio:" "${language_governance_file}" 2>/dev/null \
      || ! grep -q "schema_version:" "${language_governance_file}" 2>/dev/null \
      || ! grep -q "primary:" "${language_governance_file}" 2>/dev/null \
      || ! grep -q "secondary:" "${language_governance_file}" 2>/dev/null \
      || ! grep -q "required_gates:" "${language_governance_file}" 2>/dev/null \
      || ! grep -q "evidence_refs:" "${language_governance_file}" 2>/dev/null \
      || ! grep -q "exception_ids:" "${language_governance_file}" 2>/dev/null \
      || ! grep -q "dependency_resolution:" "${language_governance_file}" 2>/dev/null \
      || grep -q "lock_or_wrapper:" "${language_governance_file}" 2>/dev/null \
      || ! grep -q "uv export --locked --format cyclonedx1.5" "${PROJECT_DIR}/axiarch-rules/${lang}/universal/security/200_oss_compliance.md" 2>/dev/null \
      || ! grep -Fq "pubspec.lock" "${PROJECT_DIR}/axiarch-rules/${lang}/universal/security/200_oss_compliance.md" 2>/dev/null \
      || ! grep -Fq ".terraform.lock.hcl" "${PROJECT_DIR}/axiarch-rules/${lang}/universal/security/200_oss_compliance.md" 2>/dev/null \
      || ! grep -Eq "version catalog.*resolved transitive graph.*lock|version catalog.*resolved transitive graphをlockしない" "${PROJECT_DIR}/axiarch-rules/${lang}/universal/security/200_oss_compliance.md" 2>/dev/null \
      || ! grep -Eq "wrapper.*build tool.*not dependencies|wrapperはbuild toolをpinするが依存をpinしない" "${PROJECT_DIR}/axiarch-rules/${lang}/universal/security/200_oss_compliance.md" 2>/dev/null \
      || ! grep -Eq "publishable package's.*Package.resolved.*does not constrain consumer resolution|公開packageの.*Package.resolved.*consumer解決を拘束しない" "${PROJECT_DIR}/axiarch-rules/${lang}/universal/security/200_oss_compliance.md" 2>/dev/null \
      || ! grep -Fq "PyPI Trusted Publishing" "${PROJECT_DIR}/axiarch-rules/${lang}/universal/security/200_oss_compliance.md" 2>/dev/null \
      || ! grep -Fq "RubyGems Trusted Publishing" "${PROJECT_DIR}/axiarch-rules/${lang}/universal/security/200_oss_compliance.md" 2>/dev/null \
      || ! grep -Fq "nuget.org Trusted Publishing" "${PROJECT_DIR}/axiarch-rules/${lang}/universal/security/200_oss_compliance.md" 2>/dev/null \
      || ! grep -Fq "offboarding" "${PROJECT_DIR}/axiarch-rules/${lang}/universal/security/200_oss_compliance.md" 2>/dev/null \
      || ! grep -Fq "SLSA_SOURCE_TWO_PARTY_REVIEWED" "${PROJECT_DIR}/axiarch-rules/${lang}/universal/security/200_oss_compliance.md" 2>/dev/null \
      || ! grep -q "VBA / Office" "${PROJECT_DIR}/axiarch-rules/${lang}/universal/security/000_security_privacy.md" 2>/dev/null \
      || grep -q "SLSA v1.0" "${PROJECT_DIR}/axiarch-rules/${lang}/universal/security/000_security_privacy.md" 2>/dev/null; then
      print_warn "Axiarch source enterprise language profile or current dependency-tooling guidance drift for ${lang}"
      language_governance_missing=1
    fi

    oss_compliance_file="${PROJECT_DIR}/axiarch-rules/${lang}/universal/security/200_oss_compliance.md"
    if [[ "${lang}" == "ja" ]]; then
      if ! grep -Fq "AGPLやsource-availableを一律除外しない" "${oss_compliance_file}" 2>/dev/null \
        || ! grep -Fq '"defaultDecision": "review"' "${oss_compliance_file}" 2>/dev/null \
        || ! grep -Fq 'CDX_PREDICATE_TYPE="https://cyclonedx.org/bom"' "${oss_compliance_file}" 2>/dev/null \
        || ! grep -Fq "欧州委員会の移管status" "${oss_compliance_file}" 2>/dev/null \
        || ! grep -Fq "組織固有の総合70点だけをUniversal block条件にしない" "${oss_compliance_file}" 2>/dev/null \
        || grep -Fq "GPLは不可" "${oss_compliance_file}" 2>/dev/null \
        || grep -Fq "AGPL除外必須" "${oss_compliance_file}" 2>/dev/null \
        || grep -Fq "全リリースSBOMを **OCI Artifact形式**" "${oss_compliance_file}" 2>/dev/null \
        || grep -Fq "**14日超過**のSBOM" "${oss_compliance_file}" 2>/dev/null; then
        print_warn "Axiarch source license, SBOM, or NIS2 Universal applicability contract drift for ${lang}"
        language_governance_missing=1
      fi
    else
      if ! grep -Fq "Do not universally exclude AGPL or source-available terms" "${oss_compliance_file}" 2>/dev/null \
        || ! grep -Fq '"defaultDecision": "review"' "${oss_compliance_file}" 2>/dev/null \
        || ! grep -Fq 'CDX_PREDICATE_TYPE="https://cyclonedx.org/bom"' "${oss_compliance_file}" 2>/dev/null \
        || ! grep -Fq "European Commission transposition status" "${oss_compliance_file}" 2>/dev/null \
        || ! grep -Fq "Universal does not block from one organization-specific aggregate score of 70" "${oss_compliance_file}" 2>/dev/null \
        || grep -Fq "GPL not allowed" "${oss_compliance_file}" 2>/dev/null \
        || grep -Fq "AGPL exclusion mandatory" "${oss_compliance_file}" 2>/dev/null \
        || grep -Fq "Store all release SBOMs in **OCI Artifact format**" "${oss_compliance_file}" 2>/dev/null \
        || grep -Fq "older than **14 days**" "${oss_compliance_file}" 2>/dev/null; then
        print_warn "Axiarch source license, SBOM, or NIS2 Universal applicability contract drift for ${lang}"
        language_governance_missing=1
      fi
    fi

    git_governance_file="${PROJECT_DIR}/axiarch-rules/${lang}/universal/engineering/600_git_workflow.md"
    engineering_governance_file="${PROJECT_DIR}/axiarch-rules/${lang}/universal/engineering/000_engineering_standards.md"
    aws_governance_file="${PROJECT_DIR}/axiarch-rules/${lang}/universal/engineering/510_aws_cloud.md"
    security_governance_file="${PROJECT_DIR}/axiarch-rules/${lang}/universal/security/000_security_privacy.md"
    quality_governance_file="${PROJECT_DIR}/axiarch-rules/${lang}/universal/quality/000_qa_testing.md"
    sre_governance_file="${PROJECT_DIR}/axiarch-rules/${lang}/universal/operations/400_site_reliability.md"
    finops_governance_file="${PROJECT_DIR}/axiarch-rules/${lang}/universal/operations/600_cloud_finops.md"
    if [[ "${lang}" == "ja" ]]; then
      if ! grep -Fq "Protected Reference Control（保護ref統制）" "${git_governance_file}" 2>/dev/null \
        || ! grep -Fq "重大欠陥対応 (Critical Defect Response)" "${engineering_governance_file}" 2>/dev/null \
        || grep -Fq '発見から **24時間以内** に修正' "${engineering_governance_file}" 2>/dev/null \
        || ! grep -Fq "Version-Aware Contract and Codebase Consistency" "${engineering_governance_file}" 2>/dev/null \
        || grep -Fq '「既存コードベースの実装パターン」を正' "${engineering_governance_file}" 2>/dev/null \
        || grep -Fq "Codebase-as-Truth" "${PROJECT_DIR}/axiarch-rules/${lang}/INDEX.md" 2>/dev/null \
        || ! grep -Fq "Hosting Outcome" "${engineering_governance_file}" 2>/dev/null \
        || ! grep -Fq "Bounded Connections" "${engineering_governance_file}" 2>/dev/null \
        || grep -Fq 'BaaSを「唯一の正解」' "${engineering_governance_file}" 2>/dev/null \
        || grep -Fq 'timeout-minutes: 10` を設定してください' "${engineering_governance_file}" 2>/dev/null \
        || ! grep -Fq "OIDC workload identity" "${engineering_governance_file}" 2>/dev/null \
        || ! grep -Fq "Dependency Resolution Pinning" "${engineering_governance_file}" 2>/dev/null \
        || grep -Fq '自動化が唯一の正解' "${engineering_governance_file}" 2>/dev/null \
        || grep -Fq '同時適用時代' "${engineering_governance_file}" 2>/dev/null \
        || ! grep -Fq "100行は分割を促す参考signal" "${git_governance_file}" 2>/dev/null \
        || ! grep -Fq "Universal層は特定frameworkを必須化しない" "${git_governance_file}" 2>/dev/null \
        || ! grep -Fq '固定標準にしない' "${git_governance_file}" 2>/dev/null \
        || ! grep -Fq "固定7.0等の総合scoreだけでblock／allowせず" "${security_governance_file}" 2>/dev/null \
        || grep -Fq "deploy可能なapplicationと実行rootは各ecosystemのlockfileをcommit" "${language_governance_file}" 2>/dev/null \
        || ! grep -Fq "lockfileまたは同等のdependency-resolution digest" "${language_governance_file}" 2>/dev/null \
        || grep -Fq "**APIキー** | 90日ごと" "${security_governance_file}" 2>/dev/null \
        || grep -Fq "IAMクレデンシャルやJWT署名鍵は **90日ごと**" "${security_governance_file}" 2>/dev/null \
        || grep -Fq "LLMプロバイダーAPIキーを90日以内" "${security_governance_file}" 2>/dev/null \
        || ! grep -Fq "特定hostをUniversal要件にしません" "${engineering_governance_file}" 2>/dev/null \
        || ! grep -Fq "secretlessなworkload identity" "${security_governance_file}" 2>/dev/null \
        || ! grep -Fq "全clusterの必須技術にしない" "${security_governance_file}" 2>/dev/null \
        || ! grep -Fq "Web Platform Baseline" "${quality_governance_file}" 2>/dev/null \
        || ! grep -Fq "自動testだけで法的適合を断定せず" "${quality_governance_file}" 2>/dev/null \
        || grep -Fq "セキュリティアップデート5年保証" "${quality_governance_file}" 2>/dev/null \
        || ! grep -Fq "release可能なartifactごと" "${quality_governance_file}" 2>/dev/null \
        || ! grep -Fq "GitHub Actions Reusable Workflows／Composite Actionsは参考実装" "${quality_governance_file}" 2>/dev/null \
        || ! grep -Fq "workload-native benchmark" "${quality_governance_file}" 2>/dev/null \
        || grep -Fq '型チェック | `tsc --noEmit`' "${quality_governance_file}" 2>/dev/null \
        || grep -Fq "1% → 5% → 20% → 100%" "${quality_governance_file}" 2>/dev/null \
        || ! grep -Fq '`@ts-check`とJSDoc' "${language_governance_file}" 2>/dev/null \
        || grep -Fq 'legacy、設定、短いscript、型導入困難な領域に限定' "${language_governance_file}" 2>/dev/null \
        || ! grep -Fq "WebAssembly 3.0は2025年9月17日に完成" "${engineering_governance_file}" 2>/dev/null \
        || ! grep -Fq "WASI 0.3.0（2026年6月11日公開）" "${sre_governance_file}" 2>/dev/null \
        || grep -Fq "2026年2月予定" "${sre_governance_file}" 2>/dev/null \
        || ! grep -Fq "GitOpsは代表的な実装" "${sre_governance_file}" 2>/dev/null \
        || ! grep -Fq "Dependency Resolution Integrity" "${sre_governance_file}" 2>/dev/null \
        || ! grep -Fq "再現可能なdelivery path" "${sre_governance_file}" 2>/dev/null \
        || grep -Fq "いかなる場合も手動コマンド" "${sre_governance_file}" 2>/dev/null \
        || grep -Fq "AI原価はプラン月額の**30%を超えない**" "${sre_governance_file}" 2>/dev/null \
        || ! grep -Fq "Universal適用契約: 必須成果はcost visibility" "${finops_governance_file}" 2>/dev/null \
        || ! grep -Fq "RC branch／labelは一つの実装" "${sre_governance_file}" 2>/dev/null; then
        print_warn "Axiarch source cross-cutting language governance may regress to a fixed vendor, score, cadence, or team model for ${lang}"
        language_governance_missing=1
      fi
    else
      if ! grep -Fq "Protected Reference Control" "${git_governance_file}" 2>/dev/null \
        || ! grep -Fq "Critical Defect Response" "${engineering_governance_file}" 2>/dev/null \
        || grep -Fq 'fixed within **24 hours**' "${engineering_governance_file}" 2>/dev/null \
        || ! grep -Fq "Version-Aware Contract and Codebase Consistency" "${engineering_governance_file}" 2>/dev/null \
        || grep -Fq 'prioritize "existing codebase implementation patterns"' "${engineering_governance_file}" 2>/dev/null \
        || grep -Fq "Codebase-as-Truth" "${PROJECT_DIR}/axiarch-rules/${lang}/INDEX.md" 2>/dev/null \
        || ! grep -Fq "Hosting Outcome" "${engineering_governance_file}" 2>/dev/null \
        || ! grep -Fq "Bounded Connections" "${engineering_governance_file}" 2>/dev/null \
        || grep -Fq 'All CI jobs must have `timeout-minutes: 10`' "${engineering_governance_file}" 2>/dev/null \
        || ! grep -Fq "OIDC workload identity" "${engineering_governance_file}" 2>/dev/null \
        || ! grep -Fq "Dependency Resolution Pinning" "${engineering_governance_file}" 2>/dev/null \
        || grep -Fq 'automation is the only correct approach' "${engineering_governance_file}" 2>/dev/null \
        || grep -Fq 'laws apply simultaneously' "${engineering_governance_file}" 2>/dev/null \
        || ! grep -Fq "One hundred lines is a reference signal" "${git_governance_file}" 2>/dev/null \
        || ! grep -Fq "does not mandate one framework" "${git_governance_file}" 2>/dev/null \
        || ! grep -Fq 'fixed standard' "${git_governance_file}" 2>/dev/null \
        || ! grep -Fq "Do not block or allow solely on a fixed aggregate" "${security_governance_file}" 2>/dev/null \
        || grep -Fq "Deployable applications and executable roots commit each ecosystem's lockfile" "${language_governance_file}" 2>/dev/null \
        || ! grep -Fq "lockfile or equivalent dependency-resolution digest" "${language_governance_file}" 2>/dev/null \
        || grep -Fq "**API Keys** | Every 90 days" "${security_governance_file}" 2>/dev/null \
        || grep -Fq "Rotate IAM credentials and JWT signing keys every **90 days**" "${security_governance_file}" 2>/dev/null \
        || grep -Fq "Rotate LLM provider API keys within 90 days" "${security_governance_file}" 2>/dev/null \
        || ! grep -Fq "not a Universal host requirement" "${engineering_governance_file}" 2>/dev/null \
        || ! grep -Fq "secretless workload identity" "${security_governance_file}" 2>/dev/null \
        || ! grep -Fq "do not mandate it for every cluster" "${security_governance_file}" 2>/dev/null \
        || ! grep -Fq "Web Platform Baseline" "${quality_governance_file}" 2>/dev/null \
        || ! grep -Fq "Do not claim legal conformity from automated tests alone" "${quality_governance_file}" 2>/dev/null \
        || grep -Fq "24h vulnerability disclosure process" "${quality_governance_file}" 2>/dev/null \
        || ! grep -Fq "every releasable artifact" "${quality_governance_file}" 2>/dev/null \
        || ! grep -Fq "GitHub Actions Reusable Workflows and Composite Actions are reference implementations" "${quality_governance_file}" 2>/dev/null \
        || ! grep -Fq "Workload-native benchmark" "${quality_governance_file}" 2>/dev/null \
        || grep -Fq 'Type Check | `tsc --noEmit`' "${quality_governance_file}" 2>/dev/null \
        || grep -Fq "1% → 5% → 20% → 100%" "${quality_governance_file}" 2>/dev/null \
        || ! grep -Fq '`@ts-check` with JSDoc' "${language_governance_file}" 2>/dev/null \
        || grep -Fq 'Restricted to legacy code, configuration, short scripts' "${language_governance_file}" 2>/dev/null \
        || ! grep -Fq "WebAssembly 3.0 was completed on September 17, 2025" "${engineering_governance_file}" 2>/dev/null \
        || ! grep -Fq "WASI 0.3.0 (released June 11, 2026)" "${sre_governance_file}" 2>/dev/null \
        || grep -Fq "Feb 2026 expected" "${sre_governance_file}" 2>/dev/null \
        || ! grep -Fq "GitOps is a representative implementation" "${sre_governance_file}" 2>/dev/null \
        || ! grep -Fq "Dependency Resolution Integrity" "${sre_governance_file}" 2>/dev/null \
        || ! grep -Fq "reproducible delivery path" "${sre_governance_file}" 2>/dev/null \
        || grep -Fq "MUST NEVER be performed via manual commands" "${sre_governance_file}" 2>/dev/null \
        || grep -Fq "AI cost MUST NOT exceed **30%**" "${sre_governance_file}" 2>/dev/null \
        || ! grep -Fq "Universal application contract: Required outcomes are cost visibility" "${finops_governance_file}" 2>/dev/null \
        || ! grep -Fq "An RC branch or label is one implementation" "${sre_governance_file}" 2>/dev/null; then
        print_warn "Axiarch source cross-cutting language governance may regress to a fixed vendor, score, cadence, or team model for ${lang}"
        language_governance_missing=1
      fi
    fi

    major_language_tokens=(
      "TypeScript" "JavaScript" "HTML / CSS" "SQL" "Python" "Shell"
      "Java" "C#" "C++" "PowerShell" "PHP" "Go" "Rust" "Kotlin"
      "Lua" "Ruby" "Dart" "Swift" "Groovy" "Assembly" "Visual Basic"
      "VBA" "GDScript" "Scala" "Elixir" "MATLAB" "Delphi" "Lisp"
      "Zig" "MicroPython" "Erlang" "F#" "Ada" "Gleam" "Fortran"
      "OCaml" "Prolog" "COBOL" "Mojo" "Julia" "Haskell" "Clojure"
      "Objective-C" "HCL" "Bicep" "Rego" "Vyper" "Cairo" "Verilog"
      "ABAP" "Apex" "PL/I" "Power Fx" "SAS" "Stata"
      "Solidity" "Move" "SystemVerilog" "VHDL"
      "CUDA" "HIP" "SYCL" "Triton" "OpenCL" "WGSL" "GLSL" "HLSL"
      "Metal Shading Language" "Electron" "Tauri" ".NET MAUI" "Avalonia"
      "Qt" "Compose Desktop" "GraphQL" "Cypher" "Gremlin" "SPARQL"
      "PromQL" "LogQL" "KQL" "Flux" "DAX" "MDX" "Power Query M"
      "dbt" "Jinja" "OpenTofu" "Helm" "Kustomize" "Crossplane"
      "Ansible" "Puppet" "Chef" "Packer"
    )
    for major_language_token in "${major_language_tokens[@]}"; do
      if ! grep -Fq "${major_language_token}" "${language_governance_file}" 2>/dev/null; then
        print_warn "Axiarch source programming-language coverage missing for ${lang}: ${major_language_token}"
        language_governance_missing=1
      fi
    done

    compiled_artifact_tokens=(
      "SPIR-V" "DXIL" "metallib" "eBPF" "ELF" "BTF" "CO-RE"
    )
    for compiled_artifact_token in "${compiled_artifact_tokens[@]}"; do
      if ! grep -Fq "${compiled_artifact_token}" "${language_governance_file}" 2>/dev/null; then
        print_warn "Axiarch source compiled-artifact coverage missing for ${lang}: ${compiled_artifact_token}"
        language_governance_missing=1
      fi
    done

    if [[ "${lang}" == "ja" ]]; then
      if ! grep -Fq "CPUまたは信頼できるreference実装との差分test" "${language_governance_file}" 2>/dev/null \
        || ! grep -Fq "shader validatorまたはeBPF verifierのpassだけで" "${language_governance_file}" 2>/dev/null \
        || ! grep -Fq "driver JIT" "${language_governance_file}" 2>/dev/null; then
        print_warn "Axiarch source accelerator, shader, or eBPF outcome contract drift for ${lang}"
        language_governance_missing=1
      fi
    else
      if ! grep -Fq "differential tests against a CPU or trusted reference implementation" "${language_governance_file}" 2>/dev/null \
        || ! grep -Fq "Passing a shader validator or eBPF verifier alone" "${language_governance_file}" 2>/dev/null \
        || ! grep -Fq "driver JITs" "${language_governance_file}" 2>/dev/null; then
        print_warn "Axiarch source accelerator, shader, or eBPF outcome contract drift for ${lang}"
        language_governance_missing=1
      fi
    fi

    if ! grep -Fq "memory-safe roadmap" "${PROJECT_DIR}/axiarch-rules/en/${language_governance_rel}" 2>/dev/null \
      || ! grep -Fq "memory-safe roadmap" "${PROJECT_DIR}/axiarch-rules/ja/${language_governance_rel}" 2>/dev/null; then
      print_warn "Axiarch source memory-safe language migration roadmap guidance drift"
      language_governance_missing=1
    fi

    for language_governance_index in \
      "${PROJECT_DIR}/axiarch-rules/${lang}/INDEX.md" \
      "${PROJECT_DIR}/axiarch-rules/${lang}/README.md" \
      "${PROJECT_DIR}/axiarch-rules/${lang}/compliance_matrix.md"; do
      if [[ ! -f "${language_governance_index}" ]] \
        || ! grep -q "320_programming_language_governance.md" "${language_governance_index}" 2>/dev/null; then
        print_warn "Axiarch source programming-language governance is missing from ${language_governance_index#"${PROJECT_DIR}/"}"
        language_governance_missing=1
      fi
    done

    react_native_file="${PROJECT_DIR}/axiarch-rules/${lang}/${react_native_rel}"
    if [[ ! -f "${react_native_file}" ]]; then
      print_warn "Axiarch source React Native engineering rule missing for ${lang}"
      language_governance_missing=1
    else
      react_native_sections=$(grep -Ec '^## §[0-9]+\.' "${react_native_file}" 2>/dev/null || true)
      react_native_rules=$(grep -Ec 'Rule 420\.[0-9]+:' "${react_native_file}" 2>/dev/null || true)
      react_native_rule_ids=$(grep -oE 'Rule 420\.[0-9]+' "${react_native_file}" 2>/dev/null \
        | sed 's/.*\.//' | sort -n | uniq | paste -sd, -)
      react_native_expected_rule_ids=$(awk 'BEGIN { for (i = 1; i <= 52; i++) printf "%s%d", (i > 1 ? "," : ""), i }')
      if ! grep -Eq '^# 420\.' "${react_native_file}" 2>/dev/null \
        || ! grep -Eq 'Rules? 420\.1.*420\.52' "${react_native_file}" 2>/dev/null \
        || [[ "${react_native_sections}" -ne 17 \
        || "${react_native_rules}" -ne 52 \
        || "${react_native_rule_ids}" != "${react_native_expected_rule_ids}" ]]; then
        print_warn "Axiarch source React Native structure drift for ${lang}: sections=${react_native_sections}, rules=${react_native_rules}"
        language_governance_missing=1
      fi

      if ! grep -q "New Architecture" "${react_native_file}" 2>/dev/null \
        || ! grep -q "0.82" "${react_native_file}" 2>/dev/null \
        || ! grep -q "Hermes" "${react_native_file}" 2>/dev/null \
        || ! grep -q "Codegen" "${react_native_file}" 2>/dev/null \
        || ! grep -Eq "Universal Applicability Contract|Universal適用契約" "${react_native_file}" 2>/dev/null \
        || ! grep -q "AsyncStorage" "${react_native_file}" 2>/dev/null \
        || ! grep -q "OTA" "${react_native_file}" 2>/dev/null \
        || ! grep -q "runtime compatibility" "${react_native_file}" 2>/dev/null \
        || ! grep -q "rollback" "${react_native_file}" 2>/dev/null \
        || ! grep -q "CODEOWNERS" "${react_native_file}" 2>/dev/null \
        || ! grep -q "SBOM" "${react_native_file}" 2>/dev/null \
        || ! grep -q "provenance" "${react_native_file}" 2>/dev/null \
        || ! grep -q "secondary" "${react_native_file}" 2>/dev/null \
        || ! grep -Eq "version catalog単独では解決済み推移graphを固定しない|version catalog alone does not lock the resolved transitive graph" "${react_native_file}" 2>/dev/null \
        || ! grep -Eq "Mobile Platform function|Mobile Platform機能" "${react_native_file}" 2>/dev/null; then
        print_warn "Axiarch source React Native architecture, security, release, or enterprise controls drift for ${lang}"
        language_governance_missing=1
      fi
    fi

    for react_native_index in \
      "${PROJECT_DIR}/axiarch-rules/${lang}/INDEX.md" \
      "${PROJECT_DIR}/axiarch-rules/${lang}/README.md" \
      "${PROJECT_DIR}/axiarch-rules/${lang}/compliance_matrix.md"; do
      if [[ ! -f "${react_native_index}" ]] \
        || ! grep -q "420_react_native.md" "${react_native_index}" 2>/dev/null; then
        print_warn "Axiarch source React Native engineering is missing from ${react_native_index#"${PROJECT_DIR}/"}"
        language_governance_missing=1
      fi
    done

    cloud_platform_file="${PROJECT_DIR}/axiarch-rules/${lang}/${cloud_platform_rel}"
    if [[ ! -f "${cloud_platform_file}" ]]; then
      print_warn "Axiarch source cloud and application platform governance rule missing for ${lang}"
      language_governance_missing=1
    else
      cloud_platform_sections=$(grep -Ec '^## §[0-9]+\.' "${cloud_platform_file}" 2>/dev/null || true)
      cloud_platform_rules=$(grep -Ec '^- Rule 520\.[0-9]+:' "${cloud_platform_file}" 2>/dev/null || true)
      cloud_platform_rule_ids=$(grep -oE 'Rule 520\.[0-9]+' "${cloud_platform_file}" 2>/dev/null \
        | sed 's/.*\.//' | sort -n | uniq | paste -sd, -)
      cloud_platform_expected_rule_ids=$(awk 'BEGIN { for (i = 1; i <= 89; i++) printf "%s%d", (i > 1 ? "," : ""), i }')
      if ! grep -Eq '^# 520\.' "${cloud_platform_file}" 2>/dev/null \
        || ! grep -Eq 'Rules? 520\.1.*520\.89' "${cloud_platform_file}" 2>/dev/null \
        || [[ "${cloud_platform_sections}" -ne 22 \
        || "${cloud_platform_rules}" -ne 89 \
        || "${cloud_platform_rule_ids}" != "${cloud_platform_expected_rule_ids}" ]]; then
        print_warn "Axiarch source cloud and application platform structure drift for ${lang}: sections=${cloud_platform_sections}, rules=${cloud_platform_rules}"
        language_governance_missing=1
      fi

      cloud_platform_tokens=(
        "Vercel" "Supabase" "Firebase" "Cloudflare" "OIDC" "SBOM"
        "data-less" "App Check" "code rollback" "Platform Engineering"
        "feature parity" "version skew" "protocol fallback"
        "at-least-once" "idempotency" "poison message" "cost per event"
        "fidelity matrix" "managed conformance"
        "provider-managed integration" "effective permission diff" "orphan scan"
        "service graph" "release topology" "aggregate release record"
        "partial deployment" "sovereign cloud"
        "AWS Amplify" "Appwrite" "Convex" "platform_capabilities:"
        "identity portability" "trust surface"
      )
      for cloud_platform_token in "${cloud_platform_tokens[@]}"; do
        if ! grep -Fq "${cloud_platform_token}" "${cloud_platform_file}" 2>/dev/null; then
          print_warn "Axiarch source cloud and application platform coverage missing for ${lang}: ${cloud_platform_token}"
          language_governance_missing=1
        fi
      done

      if [[ "${lang}" == "ja" ]]; then
        if ! grep -Fq "Universal適用契約" "${cloud_platform_file}" 2>/dev/null \
          || ! grep -Fq "共有責任" "${cloud_platform_file}" 2>/dev/null \
          || ! grep -Fq "exit plan" "${cloud_platform_file}" 2>/dev/null \
          || ! grep -Fq "budget alertをhard capと誤認しない" "${cloud_platform_file}" 2>/dev/null; then
          print_warn "Axiarch source cloud platform Universal outcome contract drift for ${lang}"
          language_governance_missing=1
        fi
      else
        if ! grep -Fq "Universal Applicability Contract" "${cloud_platform_file}" 2>/dev/null \
          || ! grep -Fq "shared responsibility" "${cloud_platform_file}" 2>/dev/null \
          || ! grep -Fq "Exit plans" "${cloud_platform_file}" 2>/dev/null \
          || ! grep -Fq "never treat budget alerts as hard caps" "${cloud_platform_file}" 2>/dev/null; then
          print_warn "Axiarch source cloud platform Universal outcome contract drift for ${lang}"
          language_governance_missing=1
        fi
      fi
    fi

    api_integration_file="${PROJECT_DIR}/axiarch-rules/${lang}/universal/engineering/100_api_integration.md"
    if [[ "${lang}" == "ja" ]]; then
      if ! grep -Fq "independent、coordinated、aggregate" "${api_integration_file}" 2>/dev/null \
        || ! grep -Fq "microservice化自体を成熟度指標にしない" "${api_integration_file}" 2>/dev/null \
        || ! grep -Fq "Web操作を外部公開APIへ無条件に露出しない" "${api_integration_file}" 2>/dev/null \
        || ! grep -Fq "新規サービスへ一律に義務付けない" "${api_integration_file}" 2>/dev/null \
        || ! grep -Fq "新規clusterへ一律に義務付けない" "${api_integration_file}" 2>/dev/null \
        || ! grep -Fq "本契約と個別節が競合する場合は本契約を優先する" "${aws_governance_file}" 2>/dev/null \
        || ! grep -Fq "専任CoEは支出規模" "${finops_governance_file}" 2>/dev/null \
        || ! grep -Fq "局所scriptや配布されないprototype" "${security_governance_file}" 2>/dev/null \
        || grep -Fq "各マイクロサービスは他のサービスと独立してデプロイ可能でなければならない" "${api_integration_file}" 2>/dev/null \
        || grep -Fq "サービス間で直接DBを共有することを「重罪」とする" "${api_integration_file}" 2>/dev/null; then
        print_warn "Axiarch source API, cloud, team, or supply-chain Universal applicability contract drift for ${lang}"
        language_governance_missing=1
      fi
    else
      if ! grep -Fq "independent, coordinated, or aggregate" "${api_integration_file}" 2>/dev/null \
        || ! grep -Fq "microservice adoption itself is not a maturity metric" "${api_integration_file}" 2>/dev/null \
        || ! grep -Fq "do not expose web operations as public APIs by default" "${api_integration_file}" 2>/dev/null \
        || ! grep -Fq "Do not mandate it for every new service" "${api_integration_file}" 2>/dev/null \
        || ! grep -Fq "Do not mandate it for every new cluster" "${api_integration_file}" 2>/dev/null \
        || ! grep -Fq "This contract prevails over a conflicting service-specific section" "${aws_governance_file}" 2>/dev/null \
        || ! grep -Fq "establish a dedicated CoE only when spend" "${finops_governance_file}" 2>/dev/null \
        || ! grep -Fq "local script or undistributed prototype" "${security_governance_file}" 2>/dev/null \
        || grep -Fq "Each microservice must be independently deployable without dependency on other services" "${api_integration_file}" 2>/dev/null \
        || grep -Fq 'Directly sharing databases between services is a "serious offense"' "${api_integration_file}" 2>/dev/null; then
        print_warn "Axiarch source API, cloud, team, or supply-chain Universal applicability contract drift for ${lang}"
        language_governance_missing=1
      fi
    fi

    qa_release_file="${PROJECT_DIR}/axiarch-rules/${lang}/universal/quality/000_qa_testing.md"
    if [[ "${lang}" == "ja" ]]; then
      if ! grep -Fq "Micro Frontend release topologyと統合テスト" "${qa_release_file}" 2>/dev/null \
        || ! grep -Fq "aggregate deployment unit" "${qa_release_file}" 2>/dev/null \
        || grep -Fq "各マイクロフロントエンドは独立してデプロイ・テスト可能でなければならない" "${qa_release_file}" 2>/dev/null \
        || grep -Fq "外部SaaS API | Provider側制御不可のため不要" "${qa_release_file}" 2>/dev/null; then
        print_warn "Axiarch source QA and micro-frontend release-topology contract drift for ${lang}"
        language_governance_missing=1
      fi
    else
      if ! grep -Fq "Micro-Frontend Release Topology and Integration Testing" "${qa_release_file}" 2>/dev/null \
        || ! grep -Fq "Aggregate deployment unit" "${qa_release_file}" 2>/dev/null \
        || grep -Fq "Each micro-frontend must be independently deployable and testable" "${qa_release_file}" 2>/dev/null \
        || grep -Fq "External SaaS API | Not required (Provider uncontrolled)" "${qa_release_file}" 2>/dev/null; then
        print_warn "Axiarch source QA and micro-frontend release-topology contract drift for ${lang}"
        language_governance_missing=1
      fi
    fi

    for cloud_platform_index in \
      "${PROJECT_DIR}/axiarch-rules/${lang}/INDEX.md" \
      "${PROJECT_DIR}/axiarch-rules/${lang}/README.md" \
      "${PROJECT_DIR}/axiarch-rules/${lang}/compliance_matrix.md"; do
      if [[ ! -f "${cloud_platform_index}" ]] \
        || ! grep -q "520_cloud_application_platforms.md" "${cloud_platform_index}" 2>/dev/null; then
        print_warn "Axiarch source cloud and application platform governance is missing from ${cloud_platform_index#"${PROJECT_DIR}/"}"
        language_governance_missing=1
      fi
    done

    azure_profile_file="${PROJECT_DIR}/axiarch-rules/${lang}/${azure_profile_rel}"
    if [[ ! -f "${azure_profile_file}" ]]; then
      print_warn "Axiarch source Microsoft Azure provider profile missing for ${lang}"
      language_governance_missing=1
    else
      azure_profile_sections=$(grep -Ec '^## §[0-9]+\.' "${azure_profile_file}" 2>/dev/null || true)
      azure_profile_rules=$(grep -Ec '^- Rule 530\.[0-9]+:' "${azure_profile_file}" 2>/dev/null || true)
      azure_profile_rule_ids=$(grep -oE 'Rule 530\.[0-9]+' "${azure_profile_file}" 2>/dev/null \
        | sed 's/.*\.//' | sort -n | uniq | paste -sd, -)
      azure_profile_expected_rule_ids=$(awk 'BEGIN { for (i = 1; i <= 85; i++) printf "%s%d", (i > 1 ? "," : ""), i }')
      if ! grep -Eq '^# 530\.' "${azure_profile_file}" 2>/dev/null \
        || ! grep -Eq 'Rules? 530\.1.*530\.85' "${azure_profile_file}" 2>/dev/null \
        || [[ "${azure_profile_sections}" -ne 21 \
        || "${azure_profile_rules}" -ne 85 \
        || "${azure_profile_rule_ids}" != "${azure_profile_expected_rule_ids}" ]]; then
        print_warn "Axiarch source Microsoft Azure provider profile structure drift for ${lang}: sections=${azure_profile_sections}, rules=${azure_profile_rules}"
        language_governance_missing=1
      fi

      azure_profile_tokens=(
        "landing zone" "subscription vending" "Microsoft Entra" "managed identity"
        "PIM" "Azure Policy" "Bicep" "App Service" "Functions"
        "Container Apps" "AKS" "SDK" "Private Link" "Front Door"
        "Key Vault" "Service Bus" "Event Grid" "Activity Log"
        "diagnostic setting" "budget alert" "managed conformance"
        "exit plan" "SBOM" "provenance" "Custom Handler"
        "worker model" "hosting plan" "Go" "Preview"
      )
      for azure_profile_token in "${azure_profile_tokens[@]}"; do
        if ! grep -Fq "${azure_profile_token}" "${azure_profile_file}" 2>/dev/null; then
          print_warn "Axiarch source Microsoft Azure coverage missing for ${lang}: ${azure_profile_token}"
          language_governance_missing=1
        fi
      done

      if [[ "${lang}" == "ja" ]]; then
        if ! grep -Fq "Universal適用契約" "${azure_profile_file}" 2>/dev/null \
          || ! grep -Fq "budget alertをhard capと誤認" "${azure_profile_file}" 2>/dev/null \
          || ! grep -Fq "個人subscriptionでのproduction" "${azure_profile_file}" 2>/dev/null; then
          print_warn "Axiarch source Microsoft Azure Universal outcome contract drift for ${lang}"
          language_governance_missing=1
        fi
      else
        if ! grep -Fq "Universal Applicability Contract" "${azure_profile_file}" 2>/dev/null \
          || ! grep -Fq "budget alert as a hard cap" "${azure_profile_file}" 2>/dev/null \
          || ! grep -Fq "production in a personal subscription" "${azure_profile_file}" 2>/dev/null; then
          print_warn "Axiarch source Microsoft Azure Universal outcome contract drift for ${lang}"
          language_governance_missing=1
        fi
      fi
    fi

    for azure_profile_index in \
      "${PROJECT_DIR}/axiarch-rules/${lang}/INDEX.md" \
      "${PROJECT_DIR}/axiarch-rules/${lang}/README.md" \
      "${PROJECT_DIR}/axiarch-rules/${lang}/compliance_matrix.md"; do
      if [[ ! -f "${azure_profile_index}" ]] \
        || ! grep -q "530_azure_cloud.md" "${azure_profile_index}" 2>/dev/null; then
        print_warn "Axiarch source Microsoft Azure provider profile is missing from ${azure_profile_index#"${PROJECT_DIR}/"}"
        language_governance_missing=1
      fi
    done

    supabase_profile_file="${PROJECT_DIR}/axiarch-rules/${lang}/universal/engineering/200_supabase_architecture.md"
    firebase_profile_file="${PROJECT_DIR}/axiarch-rules/${lang}/universal/engineering/500_firebase_gcp.md"
    aws_profile_file="${PROJECT_DIR}/axiarch-rules/${lang}/universal/engineering/510_aws_cloud.md"
    firebase_profile_sections=$(grep -Ec '^## §[0-9]+\.' "${firebase_profile_file}" 2>/dev/null || true)
    firebase_profile_rules=$(grep -Ec '^### Rule 32\.[0-9]+:' "${firebase_profile_file}" 2>/dev/null || true)
    firebase_profile_rule_ids=$(grep -oE '^### Rule 32\.[0-9]+' "${firebase_profile_file}" 2>/dev/null \
      | sed 's/.*\.//' | sort -n | uniq | paste -sd, -)
    firebase_profile_expected_rule_ids=$(awk 'BEGIN { for (i = 1; i <= 175; i++) printf "%s%d", (i > 1 ? "," : ""), i }')
    if [[ "${firebase_profile_sections}" -ne 57 \
      || "${firebase_profile_rules}" -ne 175 \
      || "${firebase_profile_rule_ids}" != "${firebase_profile_expected_rule_ids}" ]]; then
      print_warn "Axiarch source Firebase/GCP provider profile structure drift for ${lang}: sections=${firebase_profile_sections}, rules=${firebase_profile_rules}"
      language_governance_missing=1
    fi

    if ! grep -Fq "Rule 37.3: Client Library Support Surface Protocol" "${supabase_profile_file}" 2>/dev/null \
      || ! grep -Fq "Rule 32.170: Support Claim Decomposition" "${firebase_profile_file}" 2>/dev/null \
      || ! grep -Fq "Rule 32.175: Polyglot Team Ownership" "${firebase_profile_file}" 2>/dev/null; then
      print_warn "Axiarch source Supabase or Firebase/GCP language support-surface governance drift for ${lang}"
      language_governance_missing=1
    fi

    if [[ "${lang}" == "ja" ]]; then
      if ! grep -Fq "Universal適用契約" "${supabase_profile_file}" 2>/dev/null \
        || ! grep -Fq "Universal適用契約" "${firebase_profile_file}" 2>/dev/null \
        || ! grep -Fq "Universal適用契約" "${aws_profile_file}" 2>/dev/null \
        || ! grep -Fq "Universal適用契約" "${azure_profile_file}" 2>/dev/null \
        || ! grep -Fq "Provider-neutral CI/CD戦略" "${supabase_profile_file}" 2>/dev/null \
        || ! grep -Fq "The Privileged Access RLS Protocol" "${supabase_profile_file}" 2>/dev/null \
        || ! grep -Fq "Relational Backend Capability Decision" "${firebase_profile_file}" 2>/dev/null \
        || ! grep -Fq "Provider-neutral CI/CD Contract" "${firebase_profile_file}" 2>/dev/null \
        || grep -Fq '既存データベースからSupabaseへの移行は**`pg_dump`/`pg_restore`**を使用' "${supabase_profile_file}" 2>/dev/null \
        || grep -Fq '管理画面からの全書き込み操作は `createAdminClient()`' "${supabase_profile_file}" 2>/dev/null \
        || grep -Fq "マイグレーションは何度実行しても同じ結果" "${supabase_profile_file}" 2>/dev/null \
        || grep -Fq "全てのRLSポリシー" "${supabase_profile_file}" 2>/dev/null \
        || grep -Fq "GitHub Actionsフル統合" "${supabase_profile_file}" 2>/dev/null \
        || grep -Fq "本番スキーマ変更はDashboard" "${supabase_profile_file}" 2>/dev/null \
        || grep -Fq "Firestoreへの新規データ保存は原則禁止" "${firebase_profile_file}" 2>/dev/null \
        || grep -Fq "全FirebaseプロジェクトにBlazeプラン" "${firebase_profile_file}" 2>/dev/null \
        || grep -Fq "全てのCloud Run Functions/Servicesコードは**TypeScript**" "${firebase_profile_file}" 2>/dev/null \
        || grep -Fq '全てのクエリに`limit()`' "${firebase_profile_file}" 2>/dev/null \
        || grep -Fq "目標: 10KB以内" "${firebase_profile_file}" 2>/dev/null \
        || grep -Fq "全アウトバウンドトラフィックをVPC経由" "${firebase_profile_file}" 2>/dev/null \
        || grep -Fq "技術選定はGoogleエコシステムを最優先" "${firebase_profile_file}" 2>/dev/null \
        || grep -Fq "本番環境は最低L3" "${firebase_profile_file}" 2>/dev/null \
        || grep -Fq "AI関連コストが全体の30%" "${firebase_profile_file}" 2>/dev/null \
        || grep -Fq "90日ごとにローテーション" "${firebase_profile_file}" 2>/dev/null; then
        print_warn "Axiarch source provider profile may regress to a project-specific mandate for ${lang}"
        language_governance_missing=1
      fi
    else
      if ! grep -Fq "Universal Applicability Contract" "${supabase_profile_file}" 2>/dev/null \
        || ! grep -Fq "Universal Applicability Contract" "${firebase_profile_file}" 2>/dev/null \
        || ! grep -Fq "Universal Applicability Contract" "${aws_profile_file}" 2>/dev/null \
        || ! grep -Fq "Universal Applicability Contract" "${azure_profile_file}" 2>/dev/null \
        || ! grep -Fq "Provider-neutral CI/CD Strategy" "${supabase_profile_file}" 2>/dev/null \
        || ! grep -Fq "The Privileged Access RLS Protocol" "${supabase_profile_file}" 2>/dev/null \
        || ! grep -Fq "Relational Backend Capability Decision" "${firebase_profile_file}" 2>/dev/null \
        || ! grep -Fq "Provider-neutral CI/CD Contract" "${firebase_profile_file}" 2>/dev/null \
        || grep -Fq 'Migration from existing databases to Supabase MUST use **`pg_dump`/`pg_restore`**' "${supabase_profile_file}" 2>/dev/null \
        || grep -Fq 'All write operations from the admin dashboard MUST use `createAdminClient()`' "${supabase_profile_file}" 2>/dev/null \
        || grep -Fq "Migrations must produce same result upon re-execution" "${supabase_profile_file}" 2>/dev/null \
        || grep -Fq "All RLS policies MUST include" "${supabase_profile_file}" 2>/dev/null \
        || grep -Fq "GitHub Actions Full Integration" "${supabase_profile_file}" 2>/dev/null \
        || grep -Fq "Use Dashboard SQL Editor for schema changes" "${supabase_profile_file}" 2>/dev/null \
        || grep -Fq "New data storage in Firestore is prohibited in principle" "${firebase_profile_file}" 2>/dev/null \
        || grep -Fq "required for all Firebase projects" "${firebase_profile_file}" 2>/dev/null \
        || grep -Fq "All Cloud Run Functions/Services code must be written in **TypeScript**" "${firebase_profile_file}" 2>/dev/null \
        || grep -Fq 'Set `limit()` on all queries' "${firebase_profile_file}" 2>/dev/null \
        || grep -Fq "target: under 10KB" "${firebase_profile_file}" 2>/dev/null \
        || grep -Fq "route all outbound traffic through VPC" "${firebase_profile_file}" 2>/dev/null \
        || grep -Fq "Prioritize Google ecosystem in technology selection" "${firebase_profile_file}" 2>/dev/null \
        || grep -Fq "Production environments must achieve minimum L3" "${firebase_profile_file}" 2>/dev/null \
        || grep -Fq "AI costs exceed 30% of total" "${firebase_profile_file}" 2>/dev/null \
        || grep -Fq "Rotate every 90 days" "${firebase_profile_file}" 2>/dev/null; then
        print_warn "Axiarch source provider profile may regress to a project-specific mandate for ${lang}"
        language_governance_missing=1
      fi
    fi
  done

  oss_ja_rule_count=$(grep -Ec '^- \*\*ルール\*\*:' "${PROJECT_DIR}/axiarch-rules/ja/universal/security/200_oss_compliance.md" 2>/dev/null || true)
  oss_en_rule_count=$(grep -Ec '^- \*\*Rule\*\*:' "${PROJECT_DIR}/axiarch-rules/en/universal/security/200_oss_compliance.md" 2>/dev/null || true)
  if [[ "${oss_ja_rule_count}" -ne "${oss_en_rule_count}" ]]; then
    print_warn "Axiarch source OSS compliance rule-count parity drift: ja=${oss_ja_rule_count}/en=${oss_en_rule_count}"
    language_governance_missing=1
  fi

  universal_ja_count=$(find "${PROJECT_DIR}/axiarch-rules/ja/universal" -type f -name '*.md' 2>/dev/null | wc -l | tr -d '[:space:]')
  universal_en_count=$(find "${PROJECT_DIR}/axiarch-rules/en/universal" -type f -name '*.md' 2>/dev/null | wc -l | tr -d '[:space:]')
  engineering_ja_count=$(find "${PROJECT_DIR}/axiarch-rules/ja/universal/engineering" -type f -name '*.md' 2>/dev/null | wc -l | tr -d '[:space:]')
  engineering_en_count=$(find "${PROJECT_DIR}/axiarch-rules/en/universal/engineering" -type f -name '*.md' 2>/dev/null | wc -l | tr -d '[:space:]')
  if [[ "${universal_ja_count}" -ne "${universal_en_count}" \
    || "${engineering_ja_count}" -ne "${engineering_en_count}" ]]; then
    print_warn "Axiarch source programming-language governance count parity drift: universal ja=${universal_ja_count}/en=${universal_en_count}, engineering ja=${engineering_ja_count}/en=${engineering_en_count}"
    language_governance_missing=1
  fi

  for language_governance_public_doc in README.md llms.txt llms-full.txt CHANGELOG.md; do
    if [[ ! -f "${PROJECT_DIR}/${language_governance_public_doc}" ]] \
      || ! grep -q "320_programming_language_governance.md" "${PROJECT_DIR}/${language_governance_public_doc}" 2>/dev/null \
      || ! grep -q "420_react_native.md" "${PROJECT_DIR}/${language_governance_public_doc}" 2>/dev/null \
      || ! grep -q "520_cloud_application_platforms.md" "${PROJECT_DIR}/${language_governance_public_doc}" 2>/dev/null \
      || ! grep -q "530_azure_cloud.md" "${PROJECT_DIR}/${language_governance_public_doc}" 2>/dev/null; then
      print_warn "Axiarch source programming-language, React Native, cloud platform, or Microsoft Azure governance is missing from ${language_governance_public_doc}"
      language_governance_missing=1
    fi
  done

  if [[ -f "${PROJECT_DIR}/README.md" ]] \
    && grep -q "Universal_Rules-${universal_ja_count}_files" "${PROJECT_DIR}/README.md" 2>/dev/null \
    && grep -q "Engineering | ${engineering_ja_count}" "${PROJECT_DIR}/README.md" 2>/dev/null \
    && grep -q "${universal_ja_count}のUniversalルールファイル" "${PROJECT_DIR}/README.md" 2>/dev/null \
    && grep -q "result: ${universal_ja_count} Universal Rule files" "${PROJECT_DIR}/README.md" 2>/dev/null \
    && [[ -f "${PROJECT_DIR}/llms.txt" ]] \
    && grep -q "${universal_ja_count} immutable rule files" "${PROJECT_DIR}/llms.txt" 2>/dev/null \
    && grep -q "All ${universal_ja_count} universal rules" "${PROJECT_DIR}/llms.txt" 2>/dev/null \
    && [[ -f "${PROJECT_DIR}/llms-full.txt" ]] \
    && grep -q "Universal Rules (${universal_ja_count} files" "${PROJECT_DIR}/llms-full.txt" 2>/dev/null \
    && grep -q "Technical Implementation (${engineering_ja_count} files)" "${PROJECT_DIR}/llms-full.txt" 2>/dev/null \
    && grep -q "All ${universal_ja_count} Universal Rules" "${PROJECT_DIR}/llms-full.txt" 2>/dev/null; then
    :
  else
    print_warn "Axiarch source Universal/Engineering public counts are stale"
    language_governance_missing=1
  fi

  if [[ "${language_governance_missing}" -eq 0 ]]; then
    print_pass "Axiarch source programming-language, React Native, cloud platform, and Microsoft Azure governance are integrated in ja/en rules, indexes, public docs, and counts (${universal_ja_count} universal; ${engineering_ja_count} engineering)"
  else
    print_info "Expected ja/en 320 programming-language, 420 React Native, 520 cloud/application-platform, and 530 Microsoft Azure rules with consecutive IDs and 19/17/22/21 sections; Universal applicability contracts; major-language, framework, desktop, native, query/semantic/observability/infrastructure DSL, public library/SDK/package source-binary-behavior compatibility, consumer matrices, immutable artifact promotion, generated SDKs, registry ownership, notebook/literate-artifact clean execution, rich-output trust boundaries, production jobs, team handoff, polyglot CI, Vercel/Supabase/Firebase/Cloudflare/Azure, Azure Functions managed/Preview/Custom Handler/worker/hosting support surfaces, BaaS capability manifests, identity portability, shared-responsibility, landing-zone, Entra, Policy, IaC, release/rollback, workload-identity, data, SDK lifecycle, async-event delivery, local/emulator fidelity, managed conformance, provider-managed integration lifecycle, multi-service service graphs, release topologies, aggregate evidence, partial deployments, security, FinOps, exit, and Platform Engineering controls; generic provider profiles; INDEX/README/compliance links; public digest links; and dynamic count parity"
    DOCS_MISSING=1
  fi

  git_worktree_safety_missing=0
  git_config_check_script="${PROJECT_DIR}/axiarch-scripts/check-git-config-clean.sh"
  git_workflow_ja="${PROJECT_DIR}/axiarch-rules/ja/universal/engineering/600_git_workflow.md"
  git_workflow_en="${PROJECT_DIR}/axiarch-rules/en/universal/engineering/600_git_workflow.md"
  if [[ ! -f "${git_config_check_script}" ]] \
    || ! grep -Fq 'git worktree prune --dry-run --verbose' "${git_config_check_script}" 2>/dev/null \
    || ! grep -Fq 'git show-ref --verify --quiet' "${git_config_check_script}" 2>/dev/null \
    || ! grep -Fq -- '--full-clean is deprecated' "${git_config_check_script}" 2>/dev/null \
    || grep -Fq 'git config --unset extensions.worktreeConfig' "${git_config_check_script}" 2>/dev/null \
    || grep -Fq 'git branch -D' "${git_config_check_script}" 2>/dev/null; then
    print_warn "Axiarch source Git worktree checker may remove supported configuration or branch references"
    git_worktree_safety_missing=1
  fi
  if [[ ! -f "${git_workflow_ja}" || ! -f "${git_workflow_en}" ]] \
    || ! grep -Fq 'Gitの正式機能' "${git_workflow_ja}" 2>/dev/null \
    || ! grep -Fq 'supported Git feature' "${git_workflow_en}" 2>/dev/null \
    || grep -Fq 'inucomi' "${git_workflow_ja}" 2>/dev/null \
    || grep -Fq 'inucomi' "${git_workflow_en}" 2>/dev/null; then
    print_warn "Axiarch source Git worktree guidance may drift from official Git semantics or Universal anonymity"
    git_worktree_safety_missing=1
  fi
  if [[ "${git_worktree_safety_missing}" -eq 0 ]]; then
    print_pass "Axiarch source Git worktree guidance preserves supported worktreeConfig, anonymizes failure patterns, and limits repair to prunable metadata and stale branch config"
  else
    print_info "Expected ja/en engineering/600 and check-git-config-clean.sh to preserve supported extensions.worktreeConfig, use Git dry-run/prune and local-ref checks, avoid project-specific incident names, and never force-delete branch refs"
    DOCS_MISSING=1
  fi

  heading_parity_missing=0
  heading_pair_roots=(
    "axiarch-rules"
    "axiarch-harness"
    "axiarch-prompts"
  )
  heading_ja_numbers="$(mktemp)"
  heading_en_numbers="$(mktemp)"
  for heading_root in "${heading_pair_roots[@]}"; do
    heading_ja_dir="${PROJECT_DIR}/${heading_root}/ja"
    heading_en_dir="${PROJECT_DIR}/${heading_root}/en"
    if [[ ! -d "${heading_ja_dir}" || ! -d "${heading_en_dir}" ]]; then
      print_warn "Axiarch source ja/en directory pair is incomplete: ${heading_root}"
      heading_parity_missing=1
      continue
    fi

    while IFS= read -r heading_ja_file; do
      heading_rel_path="${heading_ja_file#"${heading_ja_dir}/"}"
      if [[ ! -f "${heading_en_dir}/${heading_rel_path}" ]]; then
        print_warn "Axiarch source ja/en file-path drift: missing en counterpart for ${heading_root}/${heading_rel_path}"
        heading_parity_missing=1
      fi
    done < <(find "${heading_ja_dir}" -name "*.md" -type f 2>/dev/null | sort)

    while IFS= read -r heading_en_file; do
      heading_rel_path="${heading_en_file#"${heading_en_dir}/"}"
      if [[ ! -f "${heading_ja_dir}/${heading_rel_path}" ]]; then
        print_warn "Axiarch source ja/en file-path drift: missing ja counterpart for ${heading_root}/${heading_rel_path}"
        heading_parity_missing=1
      fi
    done < <(find "${heading_en_dir}" -name "*.md" -type f 2>/dev/null | sort)

    while IFS= read -r heading_ja_file; do
      heading_rel_path="${heading_ja_file#"${heading_ja_dir}/"}"
      heading_en_file="${heading_en_dir}/${heading_rel_path}"
      [[ -f "${heading_en_file}" ]] || continue

      sed -nE 's/^#{2,4}[[:space:]]+(§[[:space:]]*)?([0-9]+([-.][0-9A-Za-z]+)*)([.[:space:]]|$).*/\2/p' "${heading_ja_file}" | sort -u > "${heading_ja_numbers}"
      sed -nE 's/^#{2,4}[[:space:]]+(§[[:space:]]*)?([0-9]+([-.][0-9A-Za-z]+)*)([.[:space:]]|$).*/\2/p' "${heading_en_file}" | sort -u > "${heading_en_numbers}"

      heading_missing_en="$(comm -23 "${heading_ja_numbers}" "${heading_en_numbers}" | tr '\n' ' ')"
      heading_missing_ja="$(comm -13 "${heading_ja_numbers}" "${heading_en_numbers}" | tr '\n' ' ')"
      if [[ -n "${heading_missing_en}" || -n "${heading_missing_ja}" ]]; then
        print_warn "Axiarch source ja/en heading-number drift: ${heading_root}/${heading_rel_path}"
        [[ -n "${heading_missing_en}" ]] && print_info "Missing in en: ${heading_missing_en}"
        [[ -n "${heading_missing_ja}" ]] && print_info "Missing in ja: ${heading_missing_ja}"
        heading_parity_missing=1
      fi
    done < <(find "${heading_ja_dir}" -name "*.md" -type f 2>/dev/null | sort)
  done
  rm -f "${heading_ja_numbers}" "${heading_en_numbers}"
  if [[ "${heading_parity_missing}" -eq 0 ]]; then
    print_pass "Axiarch source ja/en relative file paths and numbered headings are aligned across rules, harness, and prompts"
  else
    print_info "Expected exact ja/en relative file-path and numbered-heading parity across rules, harness, and prompts; add translated counterparts or explicit numbering aliases instead of silently diverging"
    DOCS_MISSING=1
  fi

  workflow_pin_mismatch=0
  workflow_files=()
  while IFS= read -r workflow_file; do
    workflow_files+=("${workflow_file}")
  done < <(find "${PROJECT_DIR}/.github/workflows" -maxdepth 1 -type f \
    \( -name "*.yml" -o -name "*.yaml" \) 2>/dev/null | sort)
  if [[ "${#workflow_files[@]}" -eq 0 ]]; then
    print_warn "Axiarch source GitHub Actions workflows were not found — cannot verify immutable action references"
    workflow_pin_mismatch=1
  elif workflow_pin_report=$(awk '
    {
      ref = $0
      sub(/^[[:space:]]*/, "", ref)
      sub(/^-[[:space:]]*/, "", ref)
      gsub(/["\047]/, "", ref)
      if (ref !~ /^uses[[:space:]]*:/) {
        next
      }
      sub(/^uses[[:space:]]*:[[:space:]]*/, "", ref)
      sub(/[[:space:]]+#.*$/, "", ref)
      if (ref ~ /^\.\//) {
        next
      }
      if (ref ~ /^docker:\/\//) {
        digest = substr(ref, index(ref, "@sha256:") + 8)
        if (ref !~ /@sha256:[0-9a-f]+$/ || length(digest) != 64) {
          print FILENAME ":" FNR ": mutable container action reference: " ref
          invalid = 1
        }
        next
      }
      at = index(ref, "@")
      revision = substr(ref, at + 1)
      if (at == 0 || length(revision) != 40 || revision !~ /^[0-9a-f]+$/) {
        print FILENAME ":" FNR ": mutable action reference: " ref
        invalid = 1
      }
    }
    END { exit invalid ? 1 : 0 }
  ' "${workflow_files[@]}"); then
    print_pass "Axiarch source GitHub Actions references are pinned to immutable commit SHAs or container digests"
  else
    print_warn "Axiarch source GitHub Actions contain mutable external action references"
    while IFS= read -r workflow_pin_issue; do
      [[ -n "${workflow_pin_issue}" ]] && print_info "${workflow_pin_issue}"
    done <<< "${workflow_pin_report}"
    workflow_pin_mismatch=1
  fi
  if [[ "${workflow_pin_mismatch}" -ne 0 ]]; then
    print_info "Expected owner/repository@40-character-commit-SHA for external actions and docker://image@sha256:<64-hex> for container actions"
    DOCS_MISSING=1
  fi

  release_state_contract_mismatch=0
  release_workflow="${PROJECT_DIR}/.github/workflows/release.yml"
  release_cleanup_line=""
  release_action_line=""
  if [[ -f "${release_workflow}" ]]; then
    release_cleanup_line=$(grep -n -m1 'name: Remove ephemeral release signing material' "${release_workflow}" 2>/dev/null | cut -d: -f1)
    release_action_line=$(grep -n -m1 'uses: softprops/action-gh-release@' "${release_workflow}" 2>/dev/null | cut -d: -f1)
  fi
  if [[ ! -f "${release_workflow}" ]] \
    || ! grep -Fq 'echo "current_revision=true" >> "$GITHUB_OUTPUT"' "${release_workflow}" 2>/dev/null \
    || ! grep -Fq 'echo "current_revision=false" >> "$GITHUB_OUTPUT"' "${release_workflow}" 2>/dev/null \
    || ! grep -Fq 'TAG_AT_CURRENT_REVISION: ${{ steps.check_tag.outputs.current_revision }}' "${release_workflow}" 2>/dev/null \
    || ! grep -Fq 'AXIARCH_RELEASE_SSH_PRIVATE_KEY' "${release_workflow}" 2>/dev/null \
    || ! grep -Fq 'AXIARCH_RELEASE_SSH_ALLOWED_SIGNERS' "${release_workflow}" 2>/dev/null \
    || ! grep -Fq 'Release signing key is not registered' "${release_workflow}" 2>/dev/null \
    || ! grep -Fq 'git config gpg.format ssh' "${release_workflow}" 2>/dev/null \
    || ! grep -Fq 'git config gpg.ssh.allowedSignersFile' "${release_workflow}" 2>/dev/null \
    || ! grep -Fq 'git tag -s "$TAG"' "${release_workflow}" 2>/dev/null \
    || ! grep -Fq 'git verify-tag "$TAG"' "${release_workflow}" 2>/dev/null \
    || ! grep -Fq 'Remove ephemeral release signing material' "${release_workflow}" 2>/dev/null \
    || ! grep -Fq 'rm -rf -- "$SIGNING_ROOT"' "${release_workflow}" 2>/dev/null \
    || [[ -z "${release_cleanup_line}" || -z "${release_action_line}" ]] \
    || [[ "${release_cleanup_line}" -ge "${release_action_line}" ]] \
    || ! grep -Fq 'a tag-only partial release can be recovered only from the exact release revision' "${release_workflow}" 2>/dev/null \
    || ! grep -Fq 'Release state is already complete; this later main revision is a no-op.' "${release_workflow}" 2>/dev/null; then
    print_warn "Axiarch source release workflow may lack signed-tag enforcement, pre-third-party key cleanup, or safe release-state transitions"
    print_info "Expected secret-backed signed annotated tags, signing-material cleanup before third-party Actions, and a three-state contract: new release at current revision, exact-revision tag-only recovery, and complete-release no-op on later main revisions"
    release_state_contract_mismatch=1
  else
    print_pass "Axiarch source release workflow enforces secret-backed signed tags, removes key material before third-party Actions, and distinguishes exact-revision recovery from complete-release no-op on later main revisions"
  fi
  if [[ "${release_state_contract_mismatch}" -ne 0 ]]; then
    DOCS_MISSING=1
  fi

  pr_evidence_template="${PROJECT_DIR}/.github/PULL_REQUEST_TEMPLATE.md"
  pr_evidence_contract_mismatch=0
  pr_evidence_headings=(
    "## 変更種別 / Type of Change"
    "## 変更内容 / What"
    "## 変更理由・関連Issue / Why and Related Issue"
    "## 検証方法・結果 / How to Test and Results"
    "## リスク評価 / Risk Assessment"
    "## ロールバック計画 / Rollback Plan"
    "## マイグレーション・互換性 / Migration and Compatibility"
    "## リリース影響・版数管理 / Release Impact and Versioning"
    "## セキュリティ・プライバシー・FinOps / Security, Privacy, and FinOps"
    "## 承認境界・外部状態 / Approval Boundary and External State"
  )
  if [[ ! -f "${pr_evidence_template}" ]]; then
    pr_evidence_contract_mismatch=1
  else
    for pr_evidence_heading in "${pr_evidence_headings[@]}"; do
      if ! grep -Fxq "${pr_evidence_heading}" "${pr_evidence_template}" 2>/dev/null; then
        print_warn "Axiarch source PR evidence template is missing: ${pr_evidence_heading}"
        pr_evidence_contract_mismatch=1
      fi
    done
  fi
  if [[ "${pr_evidence_contract_mismatch}" -eq 0 ]]; then
    print_pass "Axiarch source PR template preserves test, risk, rollback, migration, release, security, privacy, FinOps, and approval evidence"
  else
    print_warn "Axiarch source PR template does not preserve the evidence required for team review"
    DOCS_MISSING=1
  fi

  security_policy="${PROJECT_DIR}/SECURITY.md"
  if [[ -f "${security_policy}" ]] \
    && grep -Fq "GitHub Private Vulnerability Reporting" "${security_policy}" 2>/dev/null \
    && grep -Fq "installer, upgrade" "${security_policy}" 2>/dev/null \
    && grep -Fq "installer、upgrade" "${security_policy}" 2>/dev/null \
    && ! grep -Fq "no executable code" "${security_policy}" 2>/dev/null \
    && ! grep -Fq "実行コードを含まないため" "${security_policy}" 2>/dev/null; then
    print_pass "Axiarch source SECURITY.md reflects executable distribution surfaces and private vulnerability reporting"
  else
    print_warn "Axiarch source SECURITY.md may understate script/workflow risk or direct sensitive reports to a public channel"
    print_info "Expected bilingual installer/workflow security scope and GitHub Private Vulnerability Reporting without no-executable-code claims"
    DOCS_MISSING=1
  fi

  if [[ "${GIT_CONTEXT}" == ready ]]; then
    release_tracking_missing=0
    release_tracking_paths=(
      "AXIARCH.md"
      "axiarch-manifest.json"
      "axiarch-harness/README.md"
      "axiarch-harness/ja/EXECUTION_HARNESS_PROTOCOL.md"
      "axiarch-harness/ja/AUDIT_GATE_PROTOCOL.md"
      "axiarch-harness/ja/ROLE_PASS_PROTOCOL.md"
      "axiarch-harness/ja/EVIDENCE_PACKET_PROTOCOL.md"
      "axiarch-harness/ja/HUMAN_APPROVAL_GATE.md"
      "axiarch-harness/ja/SUBAGENT_DELEGATION_PROTOCOL.md"
      "axiarch-harness/en/EXECUTION_HARNESS_PROTOCOL.md"
      "axiarch-harness/en/AUDIT_GATE_PROTOCOL.md"
      "axiarch-harness/en/ROLE_PASS_PROTOCOL.md"
      "axiarch-harness/en/EVIDENCE_PACKET_PROTOCOL.md"
      "axiarch-harness/en/HUMAN_APPROVAL_GATE.md"
      "axiarch-harness/en/SUBAGENT_DELEGATION_PROTOCOL.md"
      "axiarch-rules/ja/universal/engineering/320_programming_language_governance.md"
      "axiarch-rules/en/universal/engineering/320_programming_language_governance.md"
      "axiarch-rules/ja/universal/engineering/420_react_native.md"
      "axiarch-rules/en/universal/engineering/420_react_native.md"
      "axiarch-rules/ja/universal/engineering/520_cloud_application_platforms.md"
      "axiarch-rules/en/universal/engineering/520_cloud_application_platforms.md"
      "axiarch-rules/ja/universal/engineering/530_azure_cloud.md"
      "axiarch-rules/en/universal/engineering/530_azure_cloud.md"
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
      elif ! health_git -C "${PROJECT_DIR}" ls-files --error-unmatch -- "${release_tracking_path}" >/dev/null 2>&1; then
        print_warn "Axiarch source release-critical file is not tracked by git: ${release_tracking_path}"
        release_tracking_missing=1
      fi
    done
    if [[ "${release_tracking_missing}" -eq 0 ]]; then
      print_pass "Axiarch source release-critical files for the current release are tracked by git"
    else
      print_info "Expected current core release files, including AXIARCH.md and axiarch-harness files, to be tracked in the Git index before commit/release, not left only as untracked working-tree files"
      DOCS_MISSING=1
    fi
  else
    print_info "Git worktree not detected — skipping Axiarch source release-file tracking check"
  fi

  safe_prompt_missing=0
  safe_prompt_current_version=""
  if [[ -f "${PROJECT_DIR}/init.sh" ]]; then
    safe_prompt_current_version=$(awk -F'"' '/^AXIARCH_VERSION="/ { print $2; exit }' "${PROJECT_DIR}/init.sh")
  fi
  for lang in ja en; do
    if [[ ! -f "${PROJECT_DIR}/axiarch-prompts/${lang}/develop/safe_upgrade_execute.md" ]]; then
      print_warn "Axiarch source safe_upgrade_execute.md missing for ${lang}"
      safe_prompt_missing=1
    elif ! grep -q -- "--yes" "${PROJECT_DIR}/axiarch-prompts/${lang}/develop/safe_upgrade_execute.md" 2>/dev/null; then
      print_warn "Axiarch source safe_upgrade_execute.md may be missing non-interactive --yes option guidance for ${lang}"
      safe_prompt_missing=1
    elif [[ "${lang}" == "ja" ]] && ! grep -q "明示承認済み" "${PROJECT_DIR}/axiarch-prompts/${lang}/develop/safe_upgrade_execute.md" 2>/dev/null; then
      print_warn "Axiarch source safe_upgrade_execute.md may be missing explicit human approval guidance for ${lang}"
      safe_prompt_missing=1
    elif [[ "${lang}" == "en" ]] && ! grep -q "explicit human approval" "${PROJECT_DIR}/axiarch-prompts/${lang}/develop/safe_upgrade_execute.md" 2>/dev/null; then
      print_warn "Axiarch source safe_upgrade_execute.md may be missing explicit human approval guidance for ${lang}"
      safe_prompt_missing=1
    elif ! grep -q "axiarch-harness/{ja,en}" "${PROJECT_DIR}/axiarch-prompts/${lang}/develop/safe_upgrade_execute.md" 2>/dev/null; then
      print_warn "Axiarch source safe_upgrade_execute.md may be missing axiarch-harness language-existence cross-check for ${lang}"
      safe_prompt_missing=1
    elif [[ -n "${safe_prompt_current_version}" && "${safe_prompt_current_version}" != *"-dev" ]] \
      && ! grep -Fq "github.com/hiroyuki-miyauchi/axiarch/archive/refs/tags/v${safe_prompt_current_version}.tar.gz" "${PROJECT_DIR}/axiarch-prompts/${lang}/develop/safe_upgrade_execute.md" 2>/dev/null; then
      print_warn "Axiarch source safe_upgrade_execute.md pinned source example may not point to current release v${safe_prompt_current_version} for ${lang}"
      safe_prompt_missing=1
    elif ! grep -q ".agents/rules/prompt_pointer.md" "${PROJECT_DIR}/axiarch-prompts/${lang}/develop/safe_upgrade_execute.md" 2>/dev/null; then
      print_warn "Axiarch source safe_upgrade_execute.md may be missing Antigravity detection via .agents/rules/prompt_pointer.md for ${lang}"
      safe_prompt_missing=1
    elif ! grep -q ".codex/hooks.json" "${PROJECT_DIR}/axiarch-prompts/${lang}/develop/safe_upgrade_execute.md" 2>/dev/null; then
      print_warn "Axiarch source safe_upgrade_execute.md may still use directory-level Codex detection instead of .codex/hooks.json for ${lang}"
      safe_prompt_missing=1
    elif grep -q ".codex/.*→.*codex" "${PROJECT_DIR}/axiarch-prompts/${lang}/develop/safe_upgrade_execute.md" 2>/dev/null \
      && ! grep -q ".codex/hooks.json.*→.*codex" "${PROJECT_DIR}/axiarch-prompts/${lang}/develop/safe_upgrade_execute.md" 2>/dev/null; then
      print_warn "Axiarch source safe_upgrade_execute.md may not map .codex/hooks.json directly to codex in auto-detection for ${lang}"
      safe_prompt_missing=1
    elif grep -q ".antigravity/" "${PROJECT_DIR}/axiarch-prompts/${lang}/develop/safe_upgrade_execute.md" 2>/dev/null; then
      print_warn "Axiarch source safe_upgrade_execute.md still refers to nonstandard .antigravity/ detection for ${lang}"
      safe_prompt_missing=1
    elif ! grep -q -- "--agent all" "${PROJECT_DIR}/axiarch-prompts/${lang}/develop/safe_upgrade_execute.md" 2>/dev/null; then
      print_warn "Axiarch source safe_upgrade_execute.md may be missing multi-agent --agent all guidance for ${lang}"
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
  roadmap_version=""
  is_dev_release=0

  if [[ -f "${PROJECT_DIR}/init.sh" ]]; then
    init_version=$(awk -F'"' '/^AXIARCH_VERSION="/ { print $2; exit }' "${PROJECT_DIR}/init.sh")
  else
    print_warn "Axiarch source init.sh not found — cannot verify release version parity"
    release_version_mismatch=1
  fi

  if [[ -f "${PROJECT_DIR}/axiarch-manifest.json" ]]; then
    if command -v jq &>/dev/null; then
      manifest_version=$(jq -r '.axiarchVersion // empty' "${PROJECT_DIR}/axiarch-manifest.json" 2>/dev/null || echo "")
    else
      manifest_version=$(awk '
        /"axiarchVersion"[[:space:]]*:/ {
          line = $0
          sub(/^.*"axiarchVersion"[[:space:]]*:[[:space:]]*"/, "", line)
          sub(/".*$/, "", line)
          print line
          exit
        }
      ' "${PROJECT_DIR}/axiarch-manifest.json")
    fi
  else
    print_warn "Axiarch source axiarch-manifest.json not found — cannot verify release version parity"
    release_version_mismatch=1
  fi

  if [[ -f "${PROJECT_DIR}/CHANGELOG.md" ]]; then
    changelog_version=$(awk '
      /^## \[[0-9][^]]*\]/ {
        line = $0
        sub(/^## \[/, "", line)
        sub(/\].*$/, "", line)
        print line
        exit
      }
    ' "${PROJECT_DIR}/CHANGELOG.md")
  fi

  # Development builds keep installation examples pinned to the last stable
  # release declared in the changelog, not to an unpublished development tag.
  stable_version="${changelog_version}"
  if [[ "${init_version}" == *"-dev" ]]; then
    is_dev_release=1
    if [[ -f "${PROJECT_DIR}/CHANGELOG.md" ]] \
      && grep -q "^## \\[Unreleased\\]" "${PROJECT_DIR}/CHANGELOG.md" 2>/dev/null; then
      changelog_version="${init_version}"
    fi
  fi

  if [[ -z "${init_version}" || -z "${manifest_version}" || -z "${changelog_version}" ]]; then
    print_warn "Axiarch source release metadata is incomplete"
    print_info "Expected init.sh AXIARCH_VERSION, axiarch-manifest.json axiarchVersion, and top CHANGELOG release heading or Unreleased heading for -dev builds"
    release_version_mismatch=1
  elif [[ "${init_version}" == "${manifest_version}" && "${init_version}" == "${changelog_version}" ]]; then
    print_pass "Axiarch source release version parity: ${init_version}"
  else
    print_warn "Axiarch source release version mismatch"
    print_info "init.sh=${init_version:-missing}, manifest=${manifest_version:-missing}, changelog=${changelog_version:-missing}"
    release_version_mismatch=1
  fi

  if [[ ! "${stable_version}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    print_warn "Axiarch source CHANGELOG.md lacks a stable release version"
    release_version_mismatch=1
  fi

  if [[ -n "${stable_version}" ]]; then
    if [[ -f "${PROJECT_DIR}/ROADMAP.md" ]]; then
      roadmap_version=$(awk '
        /^> \*\*現在の安定版 \/ Current Stable\*\*: v[0-9]+\.[0-9]+\.[0-9]+/ {
          line = $0
          sub(/^.*Current Stable\*\*: v/, "", line)
          sub(/[^0-9.].*$/, "", line)
          print line
          exit
        }
      ' "${PROJECT_DIR}/ROADMAP.md")
      if [[ -z "${roadmap_version}" ]]; then
        print_warn "Axiarch source ROADMAP.md lacks a parseable current stable version"
        print_info "Expected: > **現在の安定版 / Current Stable**: vX.Y.Z"
        release_version_mismatch=1
      elif [[ "${roadmap_version}" == "${stable_version}" ]]; then
        print_pass "Axiarch source ROADMAP current stable version parity: ${roadmap_version}"
      else
        print_warn "Axiarch source ROADMAP current stable version mismatch"
        print_info "changelog-stable=${stable_version:-missing}, roadmap-current-stable=${roadmap_version:-missing}"
        release_version_mismatch=1
      fi
      if awk -v release="v${stable_version}" '
        /^## 🇯🇵 ロードマップ/ { section = "ja"; next }
        /^## 🇺🇸 Roadmap/ { section = "en"; next }
        section == "ja" && index($0, "### ✅ " release) == 1 { ja = 1 }
        section == "en" && index($0, "### ✅ " release) == 1 { en = 1 }
        END { exit !(ja && en) }
      ' "${PROJECT_DIR}/ROADMAP.md"; then
        print_pass "Axiarch source ROADMAP includes the current release in both Japanese and English sections"
      else
        print_warn "Axiarch source ROADMAP lacks the current release in one or both language sections"
        print_info "Expected ja/en completed release headings for v${stable_version}"
        release_version_mismatch=1
      fi
    else
      print_warn "Axiarch source ROADMAP.md not found — cannot verify current stable version parity"
      release_version_mismatch=1
    fi
  fi

  if [[ -n "${init_version}" ]]; then
    docs_release_mismatch=0
    if [[ ! -f "${PROJECT_DIR}/README.md" ]] \
      || ! grep -Fq "axiarch/v${stable_version}/init.sh" "${PROJECT_DIR}/README.md" 2>/dev/null \
      || ! grep -Fq "AXIARCH_REF=tags/v${stable_version} bash \"\$axiarch_bootstrap_dir/init.sh\"" "${PROJECT_DIR}/README.md" 2>/dev/null; then
      print_warn "Axiarch source README.md pinned installer example does not match stable v${stable_version}"
      docs_release_mismatch=1
    fi
    if [[ ! -f "${PROJECT_DIR}/llms.txt" ]] \
      || ! grep -Fq "axiarch/v${stable_version}/init.sh" "${PROJECT_DIR}/llms.txt" 2>/dev/null \
      || ! grep -Fq "AXIARCH_REF=tags/v${stable_version} bash \"\$axiarch_bootstrap_dir/init.sh\"" "${PROJECT_DIR}/llms.txt" 2>/dev/null; then
      print_warn "Axiarch source llms.txt pinned installer example does not match stable v${stable_version}"
      docs_release_mismatch=1
    fi
    if [[ ! -f "${PROJECT_DIR}/llms-full.txt" ]] \
      || ! grep -Fxq "> Current Release: ${init_version} | Latest Stable: ${stable_version} | License: Apache 2.0" "${PROJECT_DIR}/llms-full.txt" 2>/dev/null \
      || ! grep -Fq "axiarch/v${stable_version}/init.sh" "${PROJECT_DIR}/llms-full.txt" 2>/dev/null \
      || ! grep -Fq "AXIARCH_REF=tags/v${stable_version} bash \"\$axiarch_bootstrap_dir/init.sh\"" "${PROJECT_DIR}/llms-full.txt" 2>/dev/null; then
      print_warn "Axiarch source llms-full.txt header/pins mismatch: build v${init_version}, stable v${stable_version}"
      docs_release_mismatch=1
    fi

    if [[ "${is_dev_release}" -eq 0 && -f "${PROJECT_DIR}/CHANGELOG.md" ]]; then
      previous_release_version=$(awk -v current="${init_version}" '
        /^## \[[0-9]+\.[0-9]+\.[0-9]+\]/ {
          line = $0
          sub(/^## \[/, "", line)
          sub(/\].*$/, "", line)
          if (line == current) {
            found = 1
            next
          }
          if (found) {
            print line
            exit
          }
        }
      ' "${PROJECT_DIR}/CHANGELOG.md")
      expected_compare_reference="[${init_version}]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v${previous_release_version}...v${init_version}"
      if [[ -z "${previous_release_version}" ]] \
        || ! grep -Fxq "${expected_compare_reference}" "${PROJECT_DIR}/CHANGELOG.md" 2>/dev/null; then
        print_warn "Axiarch source CHANGELOG.md compare reference does not connect the previous release to ${init_version}"
        print_info "Expected: ${expected_compare_reference}"
        docs_release_mismatch=1
      fi
    fi

    if [[ "${is_dev_release}" -eq 0 && -f "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" ]]; then
      if ! grep -q -- "--to v${init_version}" "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null \
        || ! grep -q -- "tags/v${init_version}" "${PROJECT_DIR}/axiarch-scripts/axiarch-upgrade.sh" 2>/dev/null; then
        print_warn "Axiarch source axiarch-upgrade.sh usage examples may not mention current release v${init_version}"
        docs_release_mismatch=1
      fi
    fi

    if [[ "${docs_release_mismatch}" -eq 0 ]]; then
      print_pass "Axiarch source repository docs and upgrade helper examples mention the current release/build v${init_version}"
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
      if [[ "${is_dev_release}" -eq 0 ]] \
        && ! grep -q "Version.*v${init_version}" "${blueprint_index}" 2>/dev/null; then
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
      && grep -q "annotated tag完全性" "${ja_operations_readme}" 2>/dev/null \
      && grep -q "GitHub API失敗判別" "${ja_operations_readme}" 2>/dev/null \
      && grep -q "immutable SHA固定" "${ja_operations_readme}" 2>/dev/null \
      && grep -q "署名付きannotated tag完全性" "${ja_operations_readme}" 2>/dev/null \
      && grep -q "日英相対path対称性" "${ja_operations_readme}" 2>/dev/null \
      && [[ -f "${en_operations_readme}" ]] \
      && grep -q "010_release_upgrade_operations.md" "${en_operations_readme}" 2>/dev/null \
      && grep -q "source-only default skip" "${en_operations_readme}" 2>/dev/null \
      && grep -q "explicit selection" "${en_operations_readme}" 2>/dev/null \
      && grep -q "source-repository-only file classification" "${en_operations_readme}" 2>/dev/null \
      && grep -q "deduplicated interactive choices" "${en_operations_readme}" 2>/dev/null \
      && grep -q "annotated-tag integrity" "${en_operations_readme}" 2>/dev/null \
      && grep -q "GitHub API failure classification" "${en_operations_readme}" 2>/dev/null \
      && grep -q "immutable SHA pinning" "${en_operations_readme}" 2>/dev/null \
      && grep -q "signed annotated-tag integrity" "${en_operations_readme}" 2>/dev/null \
      && grep -q "exact bilingual relative-path symmetry" "${en_operations_readme}" 2>/dev/null; then
      print_pass "Axiarch source Blueprint operations README files include signed release-state integrity, bilingual path parity, and immutable workflow dependency boundaries"
    else
      print_warn "Axiarch source Blueprint operations README files may have stale release-upgrade summaries"
      print_info "Expected ja/en operations README files to mention source-only/default-selection boundaries, signed annotated-tag integrity, exact bilingual path parity, GitHub API failure classification, and immutable SHA pinning"
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
# Check 16 (v1.13.1+): Reminder invariant clauses — Language First + Execution Harness + Read-only Delegation
# The per-turn reminder is the runtime enforcement surface for invariants
# restored or reinforced in v1.13.1+:
#   (A) Language First — Project Native Language across every heading/label, with
#       English mixing marked a protocol violation
#   (B) Execution Harness — mandatory for non-trivial (L2+) work, with role passes,
#       audit verdict, evidence packet, and human approval gate
#   (C) Read-only delegation boundary — subagent/security-scan fanout does not
#       become approval-gated merely because it uses workers
# All three must persist in ja AND en. This guard detects silent removal/degradation
# across the #46-style Language First regression class and the read-only
# delegation false-block boundary.
# =============================================================================
print_section "Check 16: Reminder invariant clauses (Language First + Execution Harness + Read-only Delegation, ja/en)"

REMINDER_INVARIANT_PATH="${PROJECT_DIR}/axiarch-scripts/axiarch-boot-reminder.sh"
if [[ ! -f "${REMINDER_INVARIANT_PATH}" ]]; then
  print_warn "axiarch-scripts/axiarch-boot-reminder.sh not found — invariant clause check unavailable (see Check 3 for existence wiring)"
elif ! command -v grep &>/dev/null; then
  print_warn "grep not available — skipping reminder invariant clause verification"
else
  # (A) Language First — bilingual presence of scope + violation wording.
  # The violation anchors are clause-specific: "a protocol violation" / "プロトコル違反です"
  # match the language clause but NOT the unrelated task.md sentence
  # ("treated as protocol violations" / "プロトコル違反として扱われます"), avoiding a
  # false-negative where the language clause is dropped while that sentence remains.
  lang_scope_en=$(grep -c "every heading, summary, label, list, table" "${REMINDER_INVARIANT_PATH}" 2>/dev/null || true)
  lang_violation_en=$(grep -c "a protocol violation" "${REMINDER_INVARIANT_PATH}" 2>/dev/null || true)
  lang_scope_ja=$(grep -c "すべての見出し" "${REMINDER_INVARIANT_PATH}" 2>/dev/null || true)
  lang_violation_ja=$(grep -c "プロトコル違反です" "${REMINDER_INVARIANT_PATH}" 2>/dev/null || true)

  # (B) Execution Harness — bilingual presence of harness + gate wording
  harness_term=$(grep -c "Execution Harness" "${REMINDER_INVARIANT_PATH}" 2>/dev/null || true)
  harness_path=$(grep -c "axiarch-harness/" "${REMINDER_INVARIANT_PATH}" 2>/dev/null || true)
  harness_gate_en=$(grep -c "human approval gate" "${REMINDER_INVARIANT_PATH}" 2>/dev/null || true)
  harness_gate_ja=$(grep -c "人間承認ゲート" "${REMINDER_INVARIANT_PATH}" 2>/dev/null || true)

  # (C) Read-only delegation boundary — reduces the chance Codex stops with
  # "Deep Security Scan requires explicit subagent permission" after the user
  # already requested the named read-only workflow.
  delegation_boundary_en=$(grep -c "Read-only subagent delegation is not a human approval gate" "${REMINDER_INVARIANT_PATH}" 2>/dev/null || true)
  delegation_fanout_en=$(grep -c "explicit Deep Security Scan requests include required read-only fanout" "${REMINDER_INVARIANT_PATH}" 2>/dev/null || true)
  delegation_boundary_ja=$(grep -c "読み取り専用のサブエージェント委任は人間承認ゲートではありません" "${REMINDER_INVARIANT_PATH}" 2>/dev/null || true)
  delegation_fanout_ja=$(grep -c "明示された Deep Security Scan は必要な読み取り専用 fanout を含みます" "${REMINDER_INVARIANT_PATH}" 2>/dev/null || true)

  invariant_lang_ok=0
  invariant_harness_ok=0
  invariant_delegation_ok=0
  if [[ "${lang_scope_en:-0}" -gt 0 && "${lang_violation_en:-0}" -gt 0 \
     && "${lang_scope_ja:-0}" -gt 0 && "${lang_violation_ja:-0}" -gt 0 ]]; then
    invariant_lang_ok=1
  fi
  if [[ "${harness_term:-0}" -gt 0 && "${harness_path:-0}" -gt 0 \
     && "${harness_gate_en:-0}" -gt 0 && "${harness_gate_ja:-0}" -gt 0 ]]; then
    invariant_harness_ok=1
  fi
  if [[ "${delegation_boundary_en:-0}" -gt 0 && "${delegation_fanout_en:-0}" -gt 0 \
     && "${delegation_boundary_ja:-0}" -gt 0 && "${delegation_fanout_ja:-0}" -gt 0 ]]; then
    invariant_delegation_ok=1
  fi

  if [[ "${invariant_lang_ok}" -eq 1 ]]; then
    print_pass "Reminder retains Language First invariant (scope + violation wording, ja/en)"
  else
    print_warn "Reminder may have dropped/degraded the Language First invariant (ja/en scope + protocol-violation wording)"
    print_info "Expected 'every heading, summary, label, list, table' + 'a protocol violation' (en) and 'すべての見出し' + 'プロトコル違反です' (ja) in CORE_REMINDER and SHORT_REMINDER"
    print_info "Use axiarch-scripts/axiarch-upgrade.sh to update the current axiarch-scripts/axiarch-boot-reminder.sh, or restore the clause manually (v1.13.1+)"
    EXIT_CODE=1
  fi
  if [[ "${invariant_harness_ok}" -eq 1 ]]; then
    print_pass "Reminder retains Execution Harness invariant (harness reference + human approval gate, ja/en)"
  else
    print_warn "Reminder may have dropped/degraded the Execution Harness invariant (harness reference + human approval gate, ja/en)"
    print_info "Expected 'Execution Harness' + 'axiarch-harness/' + 'human approval gate' (en) and '人間承認ゲート' (ja) in CORE_REMINDER and SHORT_REMINDER"
    print_info "Use axiarch-scripts/axiarch-upgrade.sh to update the current axiarch-scripts/axiarch-boot-reminder.sh, or restore the clause manually (v1.13.1+)"
    EXIT_CODE=1
  fi
  if [[ "${invariant_delegation_ok}" -eq 1 ]]; then
    print_pass "Reminder retains read-only subagent/security-scan delegation boundary (ja/en)"
  else
    print_warn "Reminder may have dropped/degraded the read-only subagent/security-scan delegation boundary"
    print_info "Expected read-only subagent delegation and explicit Deep Security Scan fanout wording in both CORE_REMINDER and SHORT_REMINDER"
    print_info "Restore the clause so agents do not stop for separate subagent permission after a user-requested read-only scan"
    EXIT_CODE=1
  fi
fi

# Executable goal/state contract is part of the structural gate, not completion.
for helper in axiarch_state.py axiarch_upgrade.py axiarch_inspect.py axiarch_setup.py axiarch_hook.py axiarch_diff.py; do
  if [[ ! -f "${PROJECT_DIR}/axiarch-scripts/${helper}" ]]; then
    print_fail "Missing runtime helper: ${helper}"
    EXIT_CODE=1
  fi
done
for lang in ja en; do
  [[ -d "${PROJECT_DIR}/axiarch-rules/${lang}" ]] || continue
  if [[ ! -f "${PROJECT_DIR}/axiarch-harness/${lang}/TASK_STATE_PROTOCOL.md" ]] \
    || ! grep -q '300_goal_and_current_state.md' "${PROJECT_DIR}/axiarch-rules/${lang}/LOADING_PROTOCOL.md"; then
    print_fail "Goal/state contract missing for ${lang}"
    EXIT_CODE=1
  fi
done
if ! python3 "${PROJECT_DIR}/axiarch-scripts/axiarch_state.py" --project "${PROJECT_DIR}" --mode privacy-check --quiet; then
  print_fail "Private artifact Git exclusions/tracking failed / 作業記録のGit除外・追跡状態を確認してください"
  EXIT_CODE=1
fi
if [[ "${STATE_PHASE}" != "structure" ]]; then
  if ! bash "${PROJECT_DIR}/axiarch-scripts/axiarch-task-state.sh" --project "${PROJECT_DIR}" \
    --mode check --phase "${STATE_PHASE}" "${STATE_ARGS[@]+"${STATE_ARGS[@]}"}"; then
    print_fail "Task ${STATE_PHASE} validation failed / タスク証跡の整合検査に失敗"
    EXIT_CODE=1
  fi
fi

# =============================================================================
# Out-of-Scope Notice
# =============================================================================
print_section "Out of Scope (Manual Review Required)"
print_info "These protocols are not externally verifiable and require human review:"
print_info "  - AXIARCH §6.1 AI Self-Completion Mandate"
print_info "  - AXIARCH §6.3 Database Integrity (manual SQL detection)"
print_info "  - AXIARCH §6.5 Existing Functionality Protection"
print_info "  - AXIARCH §6.9 Role and Behavior"
print_info "(AXIARCH §6.6 Anti-Full-Overwrite gained physical block in v1.5.5 — see Check 11)"

# =============================================================================
# Summary
# =============================================================================
print_section "Summary"
if [[ "${EXIT_CODE}" -eq 0 ]]; then
  print_pass "No blocking automated check failures across hook + crystallization + AXIARCH protocols"
  print_info "If warnings appeared above, review them before treating the project state as fully clean"
  print_info "Checked: selected files, hook configuration, recorded references, and requested evidence phase. Not every operation or protocol clause is verified."
  print_info "Manual review needed: AXIARCH §6.1, §6.3, §6.5, §6.9 (see Out of Scope above)"
  print_info "PreToolUse checks the configured Write boundary only; actual hook invocation and agent compliance depend on the runtime."
else
  print_warn "Some checks failed/warned — see above for which protocol needs attention"
  print_info "Common misconception: \`permissions.allow Bash(echo *)\` is NOT required"
  print_info "(hook command is spawned outside the permission pipeline)"
fi
echo ""
print_info "Docs: https://code.claude.com/docs/en/hooks"
print_info "AXIARCH.md (canonical protocol): root of project"
print_info "Crystallization Protocol: axiarch-rules/{lang}/CRYSTALLIZATION_PROTOCOL.md"
print_info "axiarch: https://github.com/hiroyuki-miyauchi/axiarch"
echo ""

print_info "phase=${STATE_PHASE}: structure/record consistency only; not proof of semantic understanding or all-operation safety"
exit "${EXIT_CODE}"
