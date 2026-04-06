#!/usr/bin/env bash
# =============================================================================
# Axiarch — Quick Setup Script
# Constitution-Driven AI Agent Governance Framework
# https://github.com/hiroyuki-miyauchi/axiarch
# =============================================================================

set -euo pipefail

AXIARCH_VERSION="1.0.0"
REPO_URL="https://github.com/hiroyuki-miyauchi/axiarch"
TARBALL_URL="https://github.com/hiroyuki-miyauchi/axiarch/archive/refs/heads/main.tar.gz"

# --- Color helpers ---
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

print_header() {
  echo ""
  echo -e "${BOLD}${CYAN}🏰 Axiarch v${AXIARCH_VERSION} — Quick Setup${RESET}"
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
# STEP 2: AI Agent selection
# =============================================================================
select_agent() {
  echo ""
  echo -e "${BOLD}AIエージェント / AI Agent:${RESET}"
  echo "  1) Google Antigravity — Verified ✅"
  echo "  2) Cursor — Expected to work ⚠️"
  echo "  3) Claude Code — Expected to work ⚠️"
  echo "  4) GitHub Copilot — Expected to work ⚠️"
  echo "  5) Windsurf — Expected to work ⚠️"
  echo "  6) Other / Universal (AGENTS.md only)"
  echo ""
  read -rp "選択してください / Enter choice [1]: " agent_choice
  agent_choice="${agent_choice:-1}"

  SETUP_ANTIGRAVITY=false
  SETUP_CURSOR=false
  SETUP_CLAUDE=false
  SETUP_COPILOT=false
  SETUP_WINDSURF=false
  AGENT_LABEL="Universal"

  case "$agent_choice" in
    1) SETUP_ANTIGRAVITY=true; AGENT_LABEL="Google Antigravity" ;;
    2) SETUP_CURSOR=true; AGENT_LABEL="Cursor" ;;
    3) SETUP_CLAUDE=true; AGENT_LABEL="Claude Code" ;;
    4) SETUP_COPILOT=true; AGENT_LABEL="GitHub Copilot" ;;
    5) SETUP_WINDSURF=true; AGENT_LABEL="Windsurf" ;;
    6) AGENT_LABEL="Other / Universal" ;;
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
  echo "  axiarch-prompts/ — reusable audit prompt templates (JA/EN)"
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
# STEP 4: Download or locate source files
# =============================================================================
prepare_source() {
  if $IS_REMOTE; then
    print_step "4" "Downloading Axiarch ${AXIARCH_VERSION}..."
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

  # === Required: axiarch-rules/ (language-filtered) ===
  local UNUSED_LANG
  if [[ "$LANG_CODE" == "ja" ]]; then UNUSED_LANG="en"; else UNUSED_LANG="ja"; fi

  cp -r "$SOURCE_DIR/axiarch-rules" "$TARGET_DIR/axiarch-rules"

  # Remove unused language directories
  local REMOVE_DIRS=(
    "$TARGET_DIR/axiarch-rules/universal/${UNUSED_LANG}"
    "$TARGET_DIR/axiarch-rules/blueprint/${UNUSED_LANG}"
  )
  for d in "${REMOVE_DIRS[@]}"; do
    [[ -d "$d" ]] && rm -rf "$d" && print_info "Removed unused: ${d#"$TARGET_DIR/"}"
  done
  print_info "Copied: axiarch-rules/ (${LANG_LABEL} only)"

  # === Optional: axiarch-prompts/ ===
  if $COPY_PROMPTS; then
    cp -r "$SOURCE_DIR/axiarch-prompts" "$TARGET_DIR/axiarch-prompts"
    local UNUSED_PROMPT_DIR="$TARGET_DIR/axiarch-prompts/${UNUSED_LANG}"
    [[ -d "$UNUSED_PROMPT_DIR" ]] && rm -rf "$UNUSED_PROMPT_DIR" && \
      print_info "Removed unused: axiarch-prompts/${UNUSED_LANG}"
    print_info "Copied: axiarch-prompts/${LANG_CODE}/"
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
    if [[ ! -e "$TARGET_DIR/CLAUDE.md" ]]; then
      ln -s AGENTS.md "$TARGET_DIR/CLAUDE.md"
      print_info "Created symlink: CLAUDE.md → AGENTS.md (Claude Code)"
    else
      print_warn "CLAUDE.md already exists — skipping symlink."
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
  fi
  if ! $SETUP_COPILOT; then
    rm -f "$TARGET_DIR/.github/copilot-instructions.md" 2>/dev/null && \
      print_info "Removed: .github/copilot-instructions.md (not needed for ${AGENT_LABEL})"
  fi
  if ! $SETUP_WINDSURF; then
    rm -f "$TARGET_DIR/.windsurfrules" 2>/dev/null && \
      print_info "Removed: .windsurfrules (not needed for ${AGENT_LABEL})"
  fi
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
  elif [[ "$AGENT_LABEL" == "Cursor" ]]; then
    echo -e "  ${CYAN}${step}.${RESET} ✅ ${BOLD}.cursor/rules/axiarch.mdc${RESET} — auto-configured"
    step=$((step + 1))
  elif [[ "$AGENT_LABEL" == "Claude Code" ]]; then
    echo -e "  ${CYAN}${step}.${RESET} ✅ ${BOLD}CLAUDE.md${RESET} → AGENTS.md symlink — auto-configured"
    step=$((step + 1))
  elif [[ "$AGENT_LABEL" == "GitHub Copilot" ]]; then
    echo -e "  ${CYAN}${step}.${RESET} ✅ ${BOLD}.github/copilot-instructions.md${RESET} — auto-configured"
    step=$((step + 1))
  elif [[ "$AGENT_LABEL" == "Windsurf" ]]; then
    echo -e "  ${CYAN}${step}.${RESET} ✅ ${BOLD}.windsurfrules${RESET} — auto-configured"
    step=$((step + 1))
  fi

  echo -e "  ${CYAN}${step}.${RESET} Edit ${BOLD}axiarch-rules/blueprint/${LANG_CODE}/governance/000_project_overview.md${RESET}"
  echo -e "       → Fill in your project's tech stack, architecture, and goals"
  step=$((step + 1))
  echo ""
  echo -e "  ${CYAN}${step}.${RESET} Start developing — your AI agent will now follow the Constitution."
  echo ""
  echo -e "  ${CYAN}Docs:${RESET}  ${REPO_URL}"
  echo -e "  ${CYAN}Issues:${RESET} ${REPO_URL}/issues"
  echo ""
}

# =============================================================================
# Main
# =============================================================================
main() {
  print_header
  check_prerequisites
  select_language
  select_agent
  select_prompts
  prepare_source
  copy_files
  print_next_steps
}

main "$@"
