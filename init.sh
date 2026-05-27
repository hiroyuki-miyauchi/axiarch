#!/usr/bin/env bash
# =============================================================================
# Axiarch — Quick Setup Script
# Constitution-Driven AI Agent Governance Framework
# https://github.com/hiroyuki-miyauchi/axiarch
# =============================================================================

set -euo pipefail

AXIARCH_VERSION="1.11.0"
REPO_URL="https://github.com/hiroyuki-miyauchi/axiarch"
if [[ "$AXIARCH_VERSION" == *"-dev"* ]]; then
  DEFAULT_AXIARCH_REF="heads/main"
else
  DEFAULT_AXIARCH_REF="tags/v${AXIARCH_VERSION}"
fi
AXIARCH_REF="${AXIARCH_REF:-$DEFAULT_AXIARCH_REF}"
INSTALL_LABEL="$AXIARCH_VERSION"
if [[ "$AXIARCH_REF" =~ ^tags/v(.+)$ ]]; then
  INSTALL_LABEL="${BASH_REMATCH[1]}"
fi
RAW_REF="$AXIARCH_REF"
if [[ "$RAW_REF" =~ ^tags/(.+)$ ]]; then
  RAW_REF="${BASH_REMATCH[1]}"
elif [[ "$RAW_REF" =~ ^heads/(.+)$ ]]; then
  RAW_REF="${BASH_REMATCH[1]}"
fi
RAW_BASE_URL="https://raw.githubusercontent.com/hiroyuki-miyauchi/axiarch/${RAW_REF}"
TARBALL_URL="${REPO_URL}/archive/refs/${AXIARCH_REF}.tar.gz"

# --- Color helpers ---
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

print_header() {
  echo ""
  echo -e "${BOLD}${CYAN}🏰 Axiarch installer v${AXIARCH_VERSION} — Quick Setup${RESET}"
  echo -e "${CYAN}   Installing: Axiarch ${INSTALL_LABEL} from ${AXIARCH_REF}${RESET}"
  echo -e "${CYAN}   Constitution-Driven AI Agent Governance Framework${RESET}"
  echo -e "${CYAN}   ${REPO_URL}${RESET}"
  echo ""
}

print_step()    { echo -e "${BOLD}${BLUE}[Step $1]${RESET} $2"; }
print_success() { echo -e "${GREEN}✅ $1${RESET}"; }
print_warn()    { echo -e "${YELLOW}⚠️  $1${RESET}"; }
print_error()   { echo -e "${RED}❌ $1${RESET}"; }
print_info()    { echo -e "   ${CYAN}→${RESET} $1"; }

# --- Detect if running via curl (remote) or locally ---
# When piped via curl, the script dir is /tmp; local usage sets SOURCE_DIR.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || echo "REMOTE")"
IS_REMOTE=false
if [[ "$SCRIPT_DIR" == "REMOTE" ]] || [[ ! -f "$SCRIPT_DIR/AGENTS.md" ]]; then
  IS_REMOTE=true
else
  SOURCE_DIR="$SCRIPT_DIR"
fi

# --- Require a target directory argument when running remotely ---
TARGET_DIR="${1:-$(pwd)}"

# =============================================================================
# STEP 0: Prerequisites check
# =============================================================================
check_prerequisites() {
  local missing=()
  command -v cp    &>/dev/null || missing+=("cp")
  command -v rm    &>/dev/null || missing+=("rm")
  command -v mkdir &>/dev/null || missing+=("mkdir")
  if $IS_REMOTE; then
    command -v curl &>/dev/null || command -v wget &>/dev/null || missing+=("curl or wget")
    command -v tar  &>/dev/null || missing+=("tar")
  fi
  if [[ ${#missing[@]} -gt 0 ]]; then
    print_error "Missing required tools: ${missing[*]}"
    exit 1
  fi
}

# =============================================================================
# STEP 0.5: Existing installation guard
# =============================================================================
check_existing_install() {
  local existing_markers=()
  local reinstall_choice

  [[ -e "$TARGET_DIR/axiarch-rules" ]] && existing_markers+=("axiarch-rules/")
  [[ -e "$TARGET_DIR/axiarch-manifest.json" ]] && existing_markers+=("axiarch-manifest.json")
  [[ -e "$TARGET_DIR/.axiarch/version.json" ]] && existing_markers+=(".axiarch/version.json")

  [[ ${#existing_markers[@]} -eq 0 ]] && return 0

  print_warn "Existing Axiarch files detected in ${TARGET_DIR}: ${existing_markers[*]}"
  print_info "For existing projects, use Safe Upgrade Wizard instead of full install."
  print_info "If the helper already exists in the project, preview with:"
  print_info "  bash axiarch-scripts/axiarch-upgrade.sh --to v${AXIARCH_VERSION} --dry-run"
  print_info "If the helper is not installed yet, bootstrap it temporarily with:"
  print_info "  curl -sSL ${RAW_BASE_URL}/axiarch-scripts/axiarch-upgrade.sh -o /tmp/axiarch-upgrade.sh"
  print_info "  bash /tmp/axiarch-upgrade.sh --target \"${TARGET_DIR}\" --to v${AXIARCH_VERSION} --dry-run"
  print_info "The installer is for fresh setup and may overwrite shared Axiarch Core files."
  echo ""
  read -rp "Continue full installer anyway? / それでも通常インストールを続行しますか？ [y/N]: " reinstall_choice || reinstall_choice=""
  reinstall_choice="${reinstall_choice:-N}"
  case "$reinstall_choice" in
    y|Y|yes|YES)
      print_warn "Continuing full installer by explicit operator choice."
      ;;
    *)
      print_info "Stopped before file copy. Use Safe Upgrade Wizard from the project root."
      exit 0
      ;;
  esac
}

# =============================================================================
# STEP 1: Language selection
# =============================================================================
select_language() {
  echo -e "${BOLD}言語 / Language:${RESET}"
  echo "  1) 日本語 (Japanese) — デフォルト / Default"
  echo "  2) English"
  echo ""
  read -rp "選択してください / Enter choice [1]: " lang_choice
  lang_choice="${lang_choice:-1}"
  case "$lang_choice" in
    1) LANG_CODE="ja"; LANG_LABEL="Japanese (日本語)" ;;
    2) LANG_CODE="en"; LANG_LABEL="English" ;;
    *) print_warn "無効な選択。日本語を使用します。"; LANG_CODE="ja"; LANG_LABEL="Japanese (日本語)" ;;
  esac
  print_success "Language: ${LANG_LABEL}"
}

# =============================================================================
# STEP 1.5: Optional language directory cleanup
# =============================================================================
select_language_dirs() {
  echo ""
  echo -e "${BOLD}言語ディレクトリ / Language directories:${RESET}"
  echo "  1) 両方保持 / Keep both ja and en — デフォルト / Default"
  echo "  2) 選択した言語だけ残す / Keep selected language only"
  echo ""
  read -rp "選択してください / Enter choice [1]: " lang_dir_choice
  lang_dir_choice="${lang_dir_choice:-1}"
  KEEP_BOTH_LANGS=true
  case "$lang_dir_choice" in
    1) KEEP_BOTH_LANGS=true; print_success "Keeping both language directories." ;;
    2) KEEP_BOTH_LANGS=false; print_success "Single-language cleanup will be applied." ;;
    *) print_warn "無効な選択。両言語を保持します。"; KEEP_BOTH_LANGS=true ;;
  esac
}

# =============================================================================
# STEP 2: AI Agent selection
# =============================================================================
select_agent() {
  echo ""
  echo -e "${BOLD}AIエージェント / AI Agent:${RESET}"
  echo "  1) OpenAI Codex — Production-validated primary ✅ (AGENTS.md + .codex/hooks.json)"
  echo "  2) Claude Code — Production-validated primary ✅ (CLAUDE.md + .claude/settings.json)"
  echo "  3) Google Antigravity — Production-validated primary ✅"
  echo "  4) Cursor — Extended pointer only ⚠️ (unverified, no guarantee)"
  echo "  5) GitHub Copilot — Extended pointer only ⚠️ (unverified, no guarantee)"
  echo "  6) Windsurf — Extended pointer only ⚠️ (unverified, no guarantee)"
  echo "  7) Other / Universal (AGENTS.md only)"
  echo ""
  read -rp "選択してください / Enter choice [1]: " agent_choice
  agent_choice="${agent_choice:-1}"

  SETUP_ANTIGRAVITY=false
  SETUP_CURSOR=false
  SETUP_CLAUDE=false
  SETUP_CODEX=false
  SETUP_COPILOT=false
  SETUP_WINDSURF=false
  AGENT_LABEL="Universal"

  case "$agent_choice" in
    1) SETUP_CODEX=true; AGENT_LABEL="OpenAI Codex" ;;
    2) SETUP_CLAUDE=true; AGENT_LABEL="Claude Code" ;;
    3) SETUP_ANTIGRAVITY=true; AGENT_LABEL="Google Antigravity" ;;
    4) SETUP_CURSOR=true; AGENT_LABEL="Cursor" ;;
    5) SETUP_COPILOT=true; AGENT_LABEL="GitHub Copilot" ;;
    6) SETUP_WINDSURF=true; AGENT_LABEL="Windsurf" ;;
    7) AGENT_LABEL="Other / Universal" ;;
    *) print_warn "無効な選択。Universal設定を使用します。" ;;
  esac
  print_success "Agent: ${AGENT_LABEL}"
}

# =============================================================================
# STEP 3: Optional prompt library
# =============================================================================
select_prompts() {
  echo ""
  echo -e "${BOLD}プロンプトライブラリ / Prompt Library (任意 / Optional):${RESET}"
  echo "  axiarch-prompts/ — reusable audit / QA / upgrade execution prompt templates (JA/EN)"
  echo ""
  read -rp "コピーしますか？ / Copy prompt library? [y/N]: " prompt_choice
  prompt_choice="${prompt_choice:-N}"
  COPY_PROMPTS=false
  if [[ "$prompt_choice" =~ ^[Yy]$ ]]; then
    COPY_PROMPTS=true
    print_success "Prompt library will be copied."
  else
    print_info "Skipping prompt library."
  fi
}

# =============================================================================
# STEP 3.5 (v1.6.0+): Optional pre-commit hook installation
# Installs `bash axiarch-scripts/check-axiarch-health.sh --quiet` into .git/hooks/pre-commit
# so axiarch protocol violations (4 hooks wired, threshold breaches, etc.) are
# caught before commits land.
# =============================================================================
select_precommit() {
  echo ""
  echo -e "${BOLD}Pre-commit hook 自動 install / Pre-commit hook auto-install (任意 / Optional):${RESET}"
  echo "  Installs: bash axiarch-scripts/check-axiarch-health.sh --quiet → .git/hooks/pre-commit"
  echo "  Effect: blocks commits when axiarch protocol violations are detected"
  echo "  Existing pre-commit / lefthook / pre-commit-framework setups are detected & preserved"
  echo ""
  read -rp "Install? / インストールしますか？ [y/N]: " pc_choice
  pc_choice="${pc_choice:-N}"
  INSTALL_PRECOMMIT=false
  if [[ "$pc_choice" =~ ^[Yy]$ ]]; then
    INSTALL_PRECOMMIT=true
    print_success "Pre-commit hook will be installed (after file copy)."
  else
    print_info "Skipping pre-commit hook installation."
  fi
}

install_precommit_hook() {
  $INSTALL_PRECOMMIT || return 0

  local git_dir="${TARGET_DIR}/.git"
  if [[ ! -d "${git_dir}" ]]; then
    print_warn "Pre-commit install skipped: ${TARGET_DIR} is not a git repository."
    return 0
  fi

  # Detect lefthook / pre-commit-framework / husky and warn (do not break their setup)
  if [[ -f "${TARGET_DIR}/lefthook.yml" ]] || [[ -f "${TARGET_DIR}/.lefthook.yml" ]]; then
    print_warn "lefthook detected — please add axiarch check to lefthook.yml manually:"
    print_info "  pre-commit:"
    print_info "    commands:"
    print_info "      axiarch:"
    print_info "        run: bash axiarch-scripts/check-axiarch-health.sh --quiet"
    return 0
  fi
  if [[ -f "${TARGET_DIR}/.pre-commit-config.yaml" ]]; then
    print_warn ".pre-commit-config.yaml detected — please add axiarch check as a local hook manually."
    return 0
  fi
  if [[ -d "${TARGET_DIR}/.husky" ]]; then
    print_warn ".husky/ detected — please add 'bash axiarch-scripts/check-axiarch-health.sh --quiet' to .husky/pre-commit manually."
    return 0
  fi

  local hook_path="${git_dir}/hooks/pre-commit"
  local marker="# === axiarch pre-commit hook (auto-installed by init.sh) ==="
  local axiarch_block
  axiarch_block=$(cat <<'PRECOMMIT'

# === axiarch pre-commit hook (auto-installed by init.sh) ===
# Blocks commits when axiarch protocol violations are detected.
# Set AXIARCH_PRECOMMIT_SKIP=1 to bypass for one commit.
if [[ -z "${AXIARCH_PRECOMMIT_SKIP:-}" ]] && [[ -x "axiarch-scripts/check-axiarch-health.sh" ]]; then
  bash axiarch-scripts/check-axiarch-health.sh --quiet || {
    echo ""
    echo "❌ axiarch pre-commit hook blocked the commit."
    echo "   Run: bash axiarch-scripts/check-axiarch-health.sh   (full output)"
    echo "   Bypass once: AXIARCH_PRECOMMIT_SKIP=1 git commit ..."
    exit 1
  }
fi
# === axiarch pre-commit hook end ===
PRECOMMIT
)

  if [[ -f "${hook_path}" ]]; then
    if grep -qF "${marker}" "${hook_path}" 2>/dev/null; then
      print_info "Pre-commit hook already contains axiarch block — skipping."
      return 0
    fi
    # Append to existing pre-commit hook (do not overwrite user logic)
    printf '%s\n' "${axiarch_block}" >> "${hook_path}"
    chmod +x "${hook_path}"
    print_success "Appended axiarch block to existing ${hook_path}"
  else
    # Create new pre-commit hook
    cat > "${hook_path}" <<'NEWHOOK'
#!/usr/bin/env bash
set -uo pipefail
NEWHOOK
    printf '%s\n' "${axiarch_block}" >> "${hook_path}"
    chmod +x "${hook_path}"
    print_success "Created ${hook_path} with axiarch block"
  fi
}

# =============================================================================
# STEP 4: Download or locate source files
# =============================================================================
prepare_source() {
  if $IS_REMOTE; then
    print_step "4" "Downloading Axiarch ${INSTALL_LABEL} from ${AXIARCH_REF}..."
    TMP_DIR="$(mktemp -d)"
    trap 'rm -rf "$TMP_DIR"' EXIT

    if command -v curl &>/dev/null; then
      curl -sSL "$TARBALL_URL" | tar -xz -C "$TMP_DIR" --strip-components=1
    else
      wget -qO- "$TARBALL_URL" | tar -xz -C "$TMP_DIR" --strip-components=1
    fi
    SOURCE_DIR="$TMP_DIR"
    print_success "Downloaded to temporary directory."
  else
    print_step "4" "Using local Axiarch source: ${SOURCE_DIR}"
  fi
}

# =============================================================================
# STEP 5: Copy files
# =============================================================================
copy_files() {
  print_step "5" "Copying files to: ${TARGET_DIR}"

  # Ensure target exists
  mkdir -p "$TARGET_DIR"

  # === Required: AGENTS.md ===
  cp "$SOURCE_DIR/AGENTS.md" "$TARGET_DIR/AGENTS.md"
  print_info "Copied: AGENTS.md"

  # === Recommended: upgrade ownership manifest ===
  if [[ -f "$SOURCE_DIR/axiarch-manifest.json" ]]; then
    cp "$SOURCE_DIR/axiarch-manifest.json" "$TARGET_DIR/axiarch-manifest.json"
    print_info "Copied: axiarch-manifest.json"
  fi

  # === Required: axiarch-rules/ ===
  local UNUSED_LANG
  if [[ "$LANG_CODE" == "ja" ]]; then UNUSED_LANG="en"; else UNUSED_LANG="ja"; fi

  mkdir -p "$TARGET_DIR/axiarch-rules"
  cp -R "$SOURCE_DIR/axiarch-rules/." "$TARGET_DIR/axiarch-rules/"

  if ! $KEEP_BOTH_LANGS; then
    # Optional single-language cleanup (new structure: axiarch-rules/{lang}/)
    local UNUSED_LANG_DIR="$TARGET_DIR/axiarch-rules/${UNUSED_LANG}"
    if [[ -d "$UNUSED_LANG_DIR" ]]; then
      rm -rf "$UNUSED_LANG_DIR"
      print_info "Removed unused: axiarch-rules/${UNUSED_LANG}/"
    fi
    print_info "Copied: axiarch-rules/ (${LANG_LABEL} only)"
  else
    print_info "Copied: axiarch-rules/ (ja + en; ${LANG_LABEL} selected as Project Native Language)"
  fi

  # === Optional: axiarch-prompts/ ===
  if $COPY_PROMPTS; then
    mkdir -p "$TARGET_DIR/axiarch-prompts"
    cp -R "$SOURCE_DIR/axiarch-prompts/." "$TARGET_DIR/axiarch-prompts/"
    if ! $KEEP_BOTH_LANGS; then
      local UNUSED_PROMPT_DIR="$TARGET_DIR/axiarch-prompts/${UNUSED_LANG}"
      [[ -d "$UNUSED_PROMPT_DIR" ]] && rm -rf "$UNUSED_PROMPT_DIR" && \
        print_info "Removed unused: axiarch-prompts/${UNUSED_LANG}"
      print_info "Copied: axiarch-prompts/${LANG_CODE}/"
    else
      print_info "Copied: axiarch-prompts/ (ja + en)"
    fi
  fi

  # === Utility scripts (recommended; required when hook configs are installed) ===
  if [[ -d "$SOURCE_DIR/axiarch-scripts" ]]; then
    mkdir -p "$TARGET_DIR/axiarch-scripts"
    cp -R "$SOURCE_DIR/axiarch-scripts/." "$TARGET_DIR/axiarch-scripts/"
    chmod +x "$TARGET_DIR/axiarch-scripts/"*.sh 2>/dev/null || true
    print_info "Copied: axiarch-scripts/ (hooks: axiarch-boot-reminder.sh, axiarch-protect-antifull.sh, axiarch-init-task-md.sh, axiarch-task-state.sh, axiarch-diff-guard.sh; upgrade: axiarch-upgrade.sh; diagnostics: check-axiarch-health.sh, check-git-config-clean.sh)"
  fi

  # === Agent-specific setup: install selected agent's native config ===
  if $SETUP_ANTIGRAVITY; then
    mkdir -p "$TARGET_DIR/.agents/rules"
    cp "$SOURCE_DIR/.agents/rules/prompt_pointer.md" \
       "$TARGET_DIR/.agents/rules/prompt_pointer.md" 2>/dev/null || \
      print_warn ".agents/rules/prompt_pointer.md not found — skipping."
    print_info "Copied: .agents/rules/prompt_pointer.md (Antigravity)"
  fi

  if $SETUP_CURSOR; then
    mkdir -p "$TARGET_DIR/.cursor/rules"
    cp "$SOURCE_DIR/.cursor/rules/axiarch.mdc" \
       "$TARGET_DIR/.cursor/rules/axiarch.mdc" 2>/dev/null || \
      print_warn ".cursor/rules/axiarch.mdc not found — skipping."
    print_info "Copied: .cursor/rules/axiarch.mdc (Cursor)"
  fi

  if $SETUP_CLAUDE; then
    cp "$SOURCE_DIR/CLAUDE.md" \
       "$TARGET_DIR/CLAUDE.md" 2>/dev/null || \
      print_warn "CLAUDE.md not found — skipping."
    print_info "Copied: CLAUDE.md (Claude Code)"

    # === Claude Code: hook reinforcement ===
    if [[ -f "$SOURCE_DIR/.claude/settings.json" ]]; then
      mkdir -p "$TARGET_DIR/.claude"
      cp "$SOURCE_DIR/.claude/settings.json" \
         "$TARGET_DIR/.claude/settings.json"
      print_info "Copied: .claude/settings.json (hook reinforcement)"

      # === Validate JSON syntax (best-effort, jq optional) ===
      if command -v jq &>/dev/null; then
        if jq . "$TARGET_DIR/.claude/settings.json" >/dev/null 2>&1; then
          print_info "Validated: .claude/settings.json (valid JSON)"
        else
          print_warn ".claude/settings.json — JSON parse failed; please verify before launching Claude Code"
        fi
      fi
    fi

    # === Claude Code: optional memory persistence template ===
    if [[ -f "$SOURCE_DIR/.claude/memory/MEMORY.md" ]]; then
      mkdir -p "$TARGET_DIR/.claude/memory"
      if [[ -f "$TARGET_DIR/.claude/memory/MEMORY.md" ]]; then
        print_info "Preserved: .claude/memory/MEMORY.md (existing memory)"
      else
        cp "$SOURCE_DIR/.claude/memory/MEMORY.md" \
           "$TARGET_DIR/.claude/memory/MEMORY.md"
        print_info "Copied: .claude/memory/MEMORY.md (optional memory template)"
      fi
    fi
  fi

  if $SETUP_CODEX; then
    # === Codex: hook reinforcement ===
    if [[ -f "$SOURCE_DIR/.codex/hooks.json" ]]; then
      mkdir -p "$TARGET_DIR/.codex"
      cp "$SOURCE_DIR/.codex/hooks.json" \
         "$TARGET_DIR/.codex/hooks.json"
      print_info "Copied: .codex/hooks.json (hook reinforcement)"

      # === Validate JSON syntax (best-effort, jq optional) ===
      if command -v jq &>/dev/null; then
        if jq . "$TARGET_DIR/.codex/hooks.json" >/dev/null 2>&1; then
          print_info "Validated: .codex/hooks.json (valid JSON)"
        else
          print_warn ".codex/hooks.json — JSON parse failed; please verify before launching Codex"
        fi
      fi
    fi
  fi

  if $SETUP_COPILOT; then
    mkdir -p "$TARGET_DIR/.github"
    cp "$SOURCE_DIR/.github/copilot-instructions.md" \
       "$TARGET_DIR/.github/copilot-instructions.md" 2>/dev/null || \
      print_warn ".github/copilot-instructions.md not found — skipping."
    print_info "Copied: .github/copilot-instructions.md (GitHub Copilot)"
  fi

  if $SETUP_WINDSURF; then
    cp "$SOURCE_DIR/.windsurfrules" \
       "$TARGET_DIR/.windsurfrules" 2>/dev/null || \
      print_warn ".windsurfrules not found — skipping."
    print_info "Copied: .windsurfrules (Windsurf)"
  fi

  # === Cleanup: remove other agents' native configs not needed ===
  if ! $SETUP_ANTIGRAVITY; then
    rm -rf "$TARGET_DIR/.agents" 2>/dev/null && \
      print_info "Removed: .agents/ (not needed for ${AGENT_LABEL})"
  fi
  if ! $SETUP_CURSOR; then
    rm -rf "$TARGET_DIR/.cursor" 2>/dev/null && \
      print_info "Removed: .cursor/ (not needed for ${AGENT_LABEL})"
  fi
  if ! $SETUP_CLAUDE; then
    rm -f "$TARGET_DIR/CLAUDE.md" 2>/dev/null && \
      print_info "Removed: CLAUDE.md (not needed for ${AGENT_LABEL})"
    # Only remove the Axiarch-distributed hook config; preserve user session data (worktrees/, projects/, settings.local.json)
    rm -f "$TARGET_DIR/.claude/settings.json" 2>/dev/null && \
      print_info "Removed: .claude/settings.json (not needed for ${AGENT_LABEL})"
    # Remove .claude/ directory only if now empty (preserves user data)
    if [[ -d "$TARGET_DIR/.claude" ]] && [ -z "$(ls -A "$TARGET_DIR/.claude" 2>/dev/null)" ]; then
      rmdir "$TARGET_DIR/.claude" 2>/dev/null && \
        print_info "Removed: empty .claude/ directory"
    fi
  fi
  if ! $SETUP_CODEX; then
    # Only remove the Axiarch-distributed hook config; preserve user session data
    rm -f "$TARGET_DIR/.codex/hooks.json" 2>/dev/null && \
      print_info "Removed: .codex/hooks.json (not needed for ${AGENT_LABEL})"
    # Remove .codex/ directory only if now empty (preserves user data)
    if [[ -d "$TARGET_DIR/.codex" ]] && [ -z "$(ls -A "$TARGET_DIR/.codex" 2>/dev/null)" ]; then
      rmdir "$TARGET_DIR/.codex" 2>/dev/null && \
        print_info "Removed: empty .codex/ directory"
    fi
  fi
  if ! $SETUP_COPILOT; then
    rm -f "$TARGET_DIR/.github/copilot-instructions.md" 2>/dev/null && \
      print_info "Removed: .github/copilot-instructions.md (not needed for ${AGENT_LABEL})"
    # Clean up empty .github/ directory if nothing else remains
    if [[ -d "$TARGET_DIR/.github" ]] && [ -z "$(ls -A "$TARGET_DIR/.github" 2>/dev/null)" ]; then
      rmdir "$TARGET_DIR/.github" 2>/dev/null && \
        print_info "Removed: empty .github/ directory"
    fi
  fi
  if ! $SETUP_WINDSURF; then
    rm -f "$TARGET_DIR/.windsurfrules" 2>/dev/null && \
      print_info "Removed: .windsurfrules (not needed for ${AGENT_LABEL})"
  fi
}

# =============================================================================
# STEP 5.5: Post-copy script syntax validation
# =============================================================================
validate_distributed_scripts() {
  [[ -d "$TARGET_DIR/axiarch-scripts" ]] || return 0

  print_step "5.5" "Validating distributed shell scripts..."

  local scripts=(
    "axiarch-boot-reminder.sh"
    "axiarch-protect-antifull.sh"
    "axiarch-init-task-md.sh"
    "axiarch-task-state.sh"
    "axiarch-diff-guard.sh"
    "axiarch-upgrade.sh"
    "check-axiarch-health.sh"
    "check-git-config-clean.sh"
  )

  local script_path
  for script_name in "${scripts[@]}"; do
    script_path="$TARGET_DIR/axiarch-scripts/${script_name}"
    [[ -f "${script_path}" ]] || continue
    if bash -n "${script_path}" >/dev/null 2>&1; then
      print_info "Validated: axiarch-scripts/${script_name}"
    else
      print_warn "Syntax validation failed: axiarch-scripts/${script_name}"
    fi
  done
}

# =============================================================================
# STEP 5.6: Install metadata
# =============================================================================
write_install_metadata() {
  local meta_dir="${TARGET_DIR}/.axiarch"
  local installed_at

  mkdir -p "${meta_dir}"
  installed_at="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  cat > "${meta_dir}/version.json" <<EOF
{
  "version": "${INSTALL_LABEL}",
  "installerVersion": "${AXIARCH_VERSION}",
  "sourceRef": "${AXIARCH_REF}",
  "installedAt": "${installed_at}",
  "agent": "${AGENT_LABEL}",
  "language": "${LANG_CODE}"
}
EOF
  print_info "Wrote: .axiarch/version.json"
}

# =============================================================================
# STEP 6: Post-setup instructions
# =============================================================================
print_next_steps() {
  local REMOVE_UNUSED_LANG="ja"
  if [[ "$LANG_CODE" == "ja" ]]; then REMOVE_UNUSED_LANG="en"; fi

  echo ""
  echo -e "${BOLD}${GREEN}🎉 Axiarch setup complete!${RESET}"
  echo ""
  echo -e "${BOLD}Next Steps:${RESET}"
  echo ""
  echo -e "  ${CYAN}1.${RESET} Open ${BOLD}AGENTS.md${RESET} and set ${BOLD}Project Native Language${RESET} to ${BOLD}${LANG_LABEL}${RESET}"

  local step=2
  if [[ "$AGENT_LABEL" == "Google Antigravity" ]]; then
    echo -e "  ${CYAN}${step}.${RESET} ✅ ${BOLD}.agents/rules/prompt_pointer.md${RESET} — auto-configured"
    step=$((step + 1))
  elif [[ "$AGENT_LABEL" == "OpenAI Codex" ]]; then
    echo -e "  ${CYAN}${step}.${RESET} ✅ ${BOLD}AGENTS.md${RESET} + ${BOLD}.codex/hooks.json${RESET} — auto-configured"
    step=$((step + 1))
  elif [[ "$AGENT_LABEL" == "Cursor" ]]; then
    echo -e "  ${CYAN}${step}.${RESET} ✅ ${BOLD}.cursor/rules/axiarch.mdc${RESET} — auto-configured"
    step=$((step + 1))
  elif [[ "$AGENT_LABEL" == "Claude Code" ]]; then
    echo -e "  ${CYAN}${step}.${RESET} ✅ ${BOLD}CLAUDE.md${RESET} + ${BOLD}.claude/settings.json${RESET} — auto-configured"
    step=$((step + 1))
  elif [[ "$AGENT_LABEL" == "GitHub Copilot" ]]; then
    echo -e "  ${CYAN}${step}.${RESET} ✅ ${BOLD}.github/copilot-instructions.md${RESET} — auto-configured"
    step=$((step + 1))
  elif [[ "$AGENT_LABEL" == "Windsurf" ]]; then
    echo -e "  ${CYAN}${step}.${RESET} ✅ ${BOLD}.windsurfrules${RESET} — auto-configured"
    step=$((step + 1))
  fi

  echo -e "  ${CYAN}${step}.${RESET} Edit ${BOLD}axiarch-rules/${LANG_CODE}/blueprint/core/000_project_overview.md${RESET}"
  echo -e "       → Fill in your project's tech stack, architecture, and goals"
  step=$((step + 1))
  echo ""
  if [[ "$SETUP_CODEX" == "true" || "$SETUP_CLAUDE" == "true" ]]; then
    echo -e "  ${CYAN}${step}.${RESET} ${BOLD}Verify hook wiring (recommended for Codex / Claude Code):${RESET}"
    echo -e "       → ${BOLD}bash axiarch-scripts/check-axiarch-health.sh${RESET}"
    echo -e "         (15-stage diagnostic: 4-hook wiring, AI adherence, crystallization, AGENTS §6 physical-block, diff guard, more)"
  else
    echo -e "  ${CYAN}${step}.${RESET} ${BOLD}Optional diagnostic:${RESET}"
    echo -e "       → ${BOLD}bash axiarch-scripts/check-axiarch-health.sh${RESET}"
    echo -e "         (hook checks become strict only when .codex/hooks.json or .claude/settings.json is installed)"
  fi
  step=$((step + 1))
  echo ""
  echo -e "  ${CYAN}${step}.${RESET} ${BOLD}Plan future upgrades safely (optional):${RESET}"
  echo -e "       → ${BOLD}bash axiarch-scripts/axiarch-upgrade.sh --safe-only --dry-run${RESET}"
  echo -e "         (manifest-based upgrade preview: safe groups selected, project Blueprint state preserved)"
  step=$((step + 1))
  echo ""
  echo -e "  ${CYAN}${step}.${RESET} Start developing — the Constitution is now available to your AI agent."
  echo ""
  echo -e "  ${CYAN}Docs:${RESET}  ${REPO_URL}"
  echo -e "  ${CYAN}Scripts:${RESET} See ${BOLD}axiarch-scripts/README.md${RESET} for diagnostic tools"
  echo -e "  ${CYAN}Issues:${RESET} ${REPO_URL}/issues"
  echo ""
}

# =============================================================================
# Main
# =============================================================================
main() {
  print_header
  check_prerequisites
  check_existing_install
  select_language
  select_language_dirs
  select_agent
  select_prompts
  select_precommit
  prepare_source
  copy_files
  validate_distributed_scripts
  write_install_metadata
  install_precommit_hook
  print_next_steps
}

main "$@"
