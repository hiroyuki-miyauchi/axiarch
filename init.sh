#!/usr/bin/env bash
# =============================================================================
# Axiarch — Quick Setup Script
# Constitution-Driven AI Agent Governance Framework
# https://github.com/hiroyuki-miyauchi/axiarch
# =============================================================================

set -euo pipefail
export PYTHONDONTWRITEBYTECODE=1

AXIARCH_VERSION="1.17.0"
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
  if $IS_REMOTE; then
    printf '%b%s%b\n' "${CYAN}" "   Requested source: ${AXIARCH_REF} (source version not yet checked)" "${RESET}"
  else
    printf '%b%s%b\n' "${CYAN}" "   Local source: ${SOURCE_DIR} (source version not yet checked)" "${RESET}"
  fi
  echo -e "${CYAN}   Constitution-Driven AI Agent Governance Framework${RESET}"
  echo -e "${CYAN}   ${REPO_URL}${RESET}"
  echo ""
}

print_step()    { printf '%b%s%b%s\n' "${BOLD}${BLUE}" "[Step $1]" "${RESET} " "$2"; }
print_success() { printf '%b%s%b\n' "${GREEN}✅ " "$1" "${RESET}"; }
print_warn()    { printf '%b%s%b\n' "${YELLOW}⚠️  " "$1" "${RESET}"; }
print_error()   { printf '%b%s%b\n' "${RED}❌ " "$1" "${RESET}"; }
print_info()    { printf '%b%s\n' "   ${CYAN}→${RESET} " "$1"; }

# --- Use an adjacent checkout when present; a standalone launcher downloads it. ---
# Run as a file so standard input remains available for interactive choices.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || echo "REMOTE")"
IS_REMOTE=false
if [[ "$SCRIPT_DIR" == "REMOTE" ]] || [[ ! -f "$SCRIPT_DIR/AXIARCH.md" ]]; then
  IS_REMOTE=true
else
  SOURCE_DIR="$SCRIPT_DIR"
fi

# --- Default to the current directory when no target argument is supplied. ---
TARGET_DIR="${1:-$(pwd)}"
TMP_DIR=""
STAGE_DIR=""
cleanup() {
  [[ -z "$TMP_DIR" ]] || rm -rf "$TMP_DIR"
  [[ -z "$STAGE_DIR" ]] || rm -rf "$STAGE_DIR"
  return 0
}
trap cleanup EXIT

# =============================================================================
# STEP 0: Prerequisites check
# =============================================================================
check_prerequisites() {
  local missing=()
  command -v awk   &>/dev/null || missing+=("awk")
  command -v chmod &>/dev/null || missing+=("chmod")
  command -v cp    &>/dev/null || missing+=("cp")
  command -v date  &>/dev/null || missing+=("date")
  command -v grep  &>/dev/null || missing+=("grep")
  command -v rm    &>/dev/null || missing+=("rm")
  command -v mkdir &>/dev/null || missing+=("mkdir")
  command -v mv    &>/dev/null || missing+=("mv")
  command -v python3 &>/dev/null || missing+=("python3")
  command -v mktemp &>/dev/null || missing+=("mktemp")
  if $IS_REMOTE; then
    command -v curl &>/dev/null || missing+=("curl (HTTPS-only source download)")
    command -v mktemp &>/dev/null || missing+=("mktemp")
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

  [[ -e "$TARGET_DIR/axiarch-rules" || -L "$TARGET_DIR/axiarch-rules" ]] && existing_markers+=("axiarch-rules/")
  [[ -e "$TARGET_DIR/axiarch-manifest.json" || -L "$TARGET_DIR/axiarch-manifest.json" ]] && existing_markers+=("axiarch-manifest.json")
  [[ -e "$TARGET_DIR/.axiarch/version.json" || -L "$TARGET_DIR/.axiarch/version.json" ]] && existing_markers+=(".axiarch/version.json")

  [[ ${#existing_markers[@]} -eq 0 ]] && return 0

  print_warn "Existing Axiarch files detected in ${TARGET_DIR}: ${existing_markers[*]}"
  print_info "For existing projects, use Safe Upgrade Wizard instead of full install."
  print_info "If the helper already exists in the project, preview with:"
  print_info "  bash axiarch-scripts/axiarch-upgrade.sh --to v${AXIARCH_VERSION} --dry-run"
  print_info "If the helper is not installed yet, download to a private temporary directory:"
  print_info '  axiarch_bootstrap_dir="$(mktemp -d)" &&'
  print_info "  curl --fail --silent --show-error --location --proto '=https' --proto-redir '=https' --connect-timeout 15 --max-time 120 $(printf '%q' "${RAW_BASE_URL}/axiarch-scripts/axiarch-upgrade.sh") -o \"\$axiarch_bootstrap_dir/download.part\" &&"
  print_info '  mv "$axiarch_bootstrap_dir/download.part" "$axiarch_bootstrap_dir/axiarch-upgrade.sh"'
  print_info "Review the downloaded helper and its source before executing the preview:"
  print_info "  test -n \"\$axiarch_bootstrap_dir\" && bash \"\$axiarch_bootstrap_dir/axiarch-upgrade.sh\" --target $(printf '%q' "$TARGET_DIR") --to v${AXIARCH_VERSION} --dry-run"
  print_error "Existing installation preserved. Use Safe Upgrade Wizard; full reinstall is not supported."
  exit 3
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
    1) LANG_CODE="ja"; LANG_LABEL="Japanese (日本語)"; PROJECT_NATIVE_LANGUAGE="Japanese" ;;
    2) LANG_CODE="en"; LANG_LABEL="English"; PROJECT_NATIVE_LANGUAGE="English" ;;
    *) print_warn "無効な選択。日本語を使用します。"; LANG_CODE="ja"; LANG_LABEL="Japanese (日本語)"; PROJECT_NATIVE_LANGUAGE="Japanese" ;;
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
  echo "  1) OpenAI Codex — Unverified primary candidate (no operation guarantee; AGENTS.md adapter → AXIARCH.md + .codex/hooks.json)"
  echo "  2) Claude Code — Unverified primary candidate (no operation guarantee; CLAUDE.md adapter → AXIARCH.md + .claude/settings.json)"
  echo "  3) Google Antigravity — Production-validated primary ✅ (.agents/rules/prompt_pointer.md adapter → AXIARCH.md)"
  echo "  4) Cursor — Extended pointer only ⚠️ (unverified, no guarantee; .cursor/rules/axiarch.mdc adapter → AXIARCH.md)"
  echo "  5) GitHub Copilot — Extended pointer only ⚠️ (unverified, no guarantee; .github/copilot-instructions.md adapter → AXIARCH.md)"
  echo "  6) Windsurf — Extended pointer only ⚠️ (unverified, no guarantee; .windsurfrules adapter → AXIARCH.md)"
  echo "  7) Other / Universal (AXIARCH.md + AGENTS.md adapter)"
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
  AGENT_ID="universal"

  case "$agent_choice" in
    1) SETUP_CODEX=true; AGENT_LABEL="OpenAI Codex"; AGENT_ID="codex" ;;
    2) SETUP_CLAUDE=true; AGENT_LABEL="Claude Code"; AGENT_ID="claude" ;;
    3) SETUP_ANTIGRAVITY=true; AGENT_LABEL="Google Antigravity"; AGENT_ID="antigravity" ;;
    4) SETUP_CURSOR=true; AGENT_LABEL="Cursor"; AGENT_ID="cursor" ;;
    5) SETUP_COPILOT=true; AGENT_LABEL="GitHub Copilot"; AGENT_ID="copilot" ;;
    6) SETUP_WINDSURF=true; AGENT_LABEL="Windsurf"; AGENT_ID="windsurf" ;;
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
  GEN_PROMPT_COMMANDS=false
  if [[ "$prompt_choice" =~ ^[Yy]$ ]]; then
    COPY_PROMPTS=true
    print_success "Prompt library will be copied."
    # Offer Claude Code slash-command generation only when Claude Code is the agent.
    # This optional file adapter targets Claude; file generation is not a runtime validation.
    if $SETUP_CLAUDE; then
      echo ""
      echo "  Claude Code 向けに /axiarch-* slash command を生成できます（コピペ不要で呼び出し可能）。"
      echo "  Generate /axiarch-* slash commands for Claude Code (invoke prompts with / instead of copy-paste)."
      read -rp "  生成しますか？ / Generate slash commands? [y/N]: " cmd_choice
      cmd_choice="${cmd_choice:-N}"
      if [[ "$cmd_choice" =~ ^[Yy]$ ]]; then
        GEN_PROMPT_COMMANDS=true
        print_success "Claude Code slash commands will be generated."
      else
        print_info "Skipping slash command generation (copy-paste運用)."
      fi
    fi
  else
    print_info "Skipping prompt library."
  fi
}

# =============================================================================
# STEP 3.5 (v1.6.0+): Optional pre-commit hook installation
# Installs `bash axiarch-scripts/check-axiarch-health.sh --quiet` into .git/hooks/pre-commit
# to check the automated health subset when Git invokes this hook.
# =============================================================================
select_precommit() {
  echo ""
  echo -e "${BOLD}Pre-commit hook 自動 install / Pre-commit hook auto-install (任意 / Optional):${RESET}"
  echo "  Candidate: bash axiarch-scripts/check-axiarch-health.sh --quiet → .git/hooks/pre-commit"
  echo "  When installed and invoked, a failed automated health check stops that commit."
  echo "  This does not prove rule understanding or the safety of all changes."
  echo "  Existing pre-commit / lefthook / pre-commit-framework setups are detected & preserved"
  echo ""
  read -rp "Install? / インストールしますか？ [y/N]: " pc_choice
  pc_choice="${pc_choice:-N}"
  INSTALL_PRECOMMIT=false
  if [[ "$pc_choice" =~ ^[Yy]$ ]]; then
    INSTALL_PRECOMMIT=true
    print_info "Pre-commit installation requested; existing hook/tooling checks determine the result."
  else
    print_info "Skipping pre-commit hook installation."
  fi
}

# AXIARCH_DOWNLOAD_BEGIN
# Standalone bootstraps carry the same small download boundary; regression tests
# compare this block so init and upgrade cannot silently diverge.
download_source_archive() {
  python3 - "$1" "$2" "${AXIARCH_DOWNLOAD_TIMEOUT_SECONDS:-120}" <<'AXIARCH_DOWNLOAD_PY'
import gzip
import re
import shutil
import subprocess
import sys
import tarfile
import tempfile
import time
import unicodedata
from pathlib import Path

try:
    url, destination, value = sys.argv[1:]
    if not re.fullmatch(r'[0-9]{1,3}', value) or not 1 <= int(value) <= 600:
        raise ValueError('AXIARCH_DOWNLOAD_TIMEOUT_SECONDS must be 1-600')
    seconds = int(value)
    if not shutil.which('curl'):
        raise ValueError('curl is required for HTTPS-only source downloads; use a reviewed local source otherwise')
    destination = Path(destination)
    destination.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='.axiarch-download-', dir=destination.parent) as temporary:
        compressed = Path(temporary) / 'source.tar.gz'
        with compressed.open('wb') as output:
            subprocess.run(['curl', '--fail', '--silent', '--show-error', '--location',
                            '--proto', '=https', '--proto-redir', '=https', '--max-redirs', '5',
                            '--connect-timeout', str(min(seconds, 15)), '--max-time', str(seconds),
                            '--max-filesize', str(64 * 1024 * 1024), url],
                           stdout=output, check=True, timeout=seconds)
        if compressed.stat().st_size > 64 * 1024 * 1024:
            raise ValueError('compressed source archive exceeds 64 MiB')
        deadline = time.monotonic() + seconds
        archive_path = Path(temporary) / 'source.tar'
        # Fully decompress before inspection, including the gzip checksum/trailer.
        # This bounds large metadata as well as file bodies before tar parsing.
        total = 0
        with gzip.open(compressed, 'rb') as source, archive_path.open('wb') as output:
            while True:
                if time.monotonic() >= deadline:
                    raise ValueError('source extraction timed out')
                chunk = source.read(1024 * 1024)
                if not chunk:
                    break
                total += len(chunk)
                if total > 512 * 1024 * 1024:
                    raise ValueError('expanded source archive exceeds 512 MiB')
                output.write(chunk)
        seen, roots, count = set(), set(), 0
        with tarfile.open(archive_path, 'r:') as archive:
            for member in archive:
                count += 1
                if count > 10000 or time.monotonic() >= deadline:
                    raise ValueError('source archive entry/time limit exceeded')
                name = member.name
                if (name.startswith('/') or '\\' in name
                        or any(ord(c) < 32 or ord(c) == 127 for c in name)):
                    raise ValueError('unsafe source archive path')
                parts = name.rstrip('/').split('/')
                if any(part in ('', '.', '..') for part in parts):
                    raise ValueError('unsafe source archive path')
                roots.add(parts[0])
                if len(roots) != 1 or not (member.isdir() or member.isfile()):
                    raise ValueError('source archive must have one root and only regular files/directories')
                key = unicodedata.normalize('NFC', '/'.join(parts)).casefold()
                if key in seen:
                    raise ValueError('duplicate or case/Unicode-colliding source archive path')
                seen.add(key)
                if member.size < 0 or member.size > 64 * 1024 * 1024:
                    raise ValueError('source archive member exceeds 64 MiB')
        if not count:
            raise ValueError('empty source archive')
        destination.mkdir(mode=0o700)
        subprocess.run(['tar', '-xf', str(archive_path), '-C', str(destination), '--strip-components=1'],
                       check=True, timeout=max(0, deadline - time.monotonic()))
except subprocess.TimeoutExpired:
    print('Source preparation failed: download/extraction timed out; no installation applied.', file=sys.stderr)
    sys.exit(1)
except (OSError, ValueError, EOFError, tarfile.TarError, subprocess.CalledProcessError) as error:
    print('Source preparation failed: ' + str(error), file=sys.stderr)
    sys.exit(1)
AXIARCH_DOWNLOAD_PY
}
# AXIARCH_DOWNLOAD_END

# =============================================================================
# STEP 4: Download or locate source files
# =============================================================================
prepare_source() {
  if $IS_REMOTE; then
    print_step "4" "Downloading Axiarch ${INSTALL_LABEL} from ${AXIARCH_REF}..."
    TMP_DIR="$(mktemp -d)"

    SOURCE_DIR="$TMP_DIR/source"
    download_source_archive "$TARBALL_URL" "$SOURCE_DIR"
    print_success "Downloaded to temporary directory."
  else
    print_step "4" "Using local Axiarch source: ${SOURCE_DIR}"
  fi
}

set_project_native_language() {
  local protocol_file="$1"
  local language="$2"
  local selected
  [[ "$language" == "English" ]] && selected=en || selected=ja
  python3 "$SOURCE_DIR/axiarch-scripts/axiarch_setup.py" configure-language \
    --target "$(dirname "$protocol_file")" --lang "$selected"
}

# =============================================================================
# STEP 5: Copy files
# =============================================================================
copy_files() {
  print_step "5" "Copying files to: ${TARGET_DIR}"

  # Target is an isolated staging directory; the real adopter is checked later.
  mkdir -p "$TARGET_DIR"

  # Source paths were preflighted; any copy failure stops before adopter writes.
  cp "$SOURCE_DIR/AXIARCH.md" "$TARGET_DIR/AXIARCH.md"
  print_info "Copied: AXIARCH.md"
  cp "$SOURCE_DIR/AGENTS.md" "$TARGET_DIR/AGENTS.md"
  print_info "Copied: AGENTS.md"
  if set_project_native_language "$TARGET_DIR/AXIARCH.md" "$PROJECT_NATIVE_LANGUAGE"; then
    print_info "Configured: AXIARCH.md Project Native Language = ${PROJECT_NATIVE_LANGUAGE}"
  else
    print_error "Cannot configure an unambiguous Project Native Language; no installation applied."
    return 3
  fi

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
    # Optional single-language cleanup (rules; harness cleanup follows below)
    local UNUSED_LANG_DIR="$TARGET_DIR/axiarch-rules/${UNUSED_LANG}"
    if [[ -d "$UNUSED_LANG_DIR" ]]; then
      rm -rf "$UNUSED_LANG_DIR"
      print_info "Removed unused: axiarch-rules/${UNUSED_LANG}/"
    fi
    print_info "Copied: axiarch-rules/ (${LANG_LABEL} only)"
  else
    print_info "Copied: axiarch-rules/ (ja + en; ${LANG_LABEL} selected as Project Native Language)"
  fi

  # === Required for current releases: axiarch-harness/ ===
  if [[ -d "$SOURCE_DIR/axiarch-harness" ]]; then
    mkdir -p "$TARGET_DIR/axiarch-harness"
    cp -R "$SOURCE_DIR/axiarch-harness/." "$TARGET_DIR/axiarch-harness/"
    if ! $KEEP_BOTH_LANGS; then
      local UNUSED_HARNESS_DIR="$TARGET_DIR/axiarch-harness/${UNUSED_LANG}"
      if [[ -d "$UNUSED_HARNESS_DIR" ]]; then
        rm -rf "$UNUSED_HARNESS_DIR"
        print_info "Removed unused: axiarch-harness/${UNUSED_LANG}/"
      fi
      print_info "Copied: axiarch-harness/ (${LANG_LABEL} only)"
    else
      print_info "Copied: axiarch-harness/ (ja + en)"
    fi
  else
    print_error "Required axiarch-harness/ disappeared during preparation; no installation applied."
    return 3
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
    python3 -c 'import shutil,sys; shutil.copytree(sys.argv[1],sys.argv[2],ignore=shutil.ignore_patterns("__pycache__","*.pyc"))' "$SOURCE_DIR/axiarch-scripts" "$TARGET_DIR/axiarch-scripts"
    chmod +x "$TARGET_DIR/axiarch-scripts/"*.sh 2>/dev/null || true
    print_info "Copied: axiarch-scripts/ (hooks: axiarch-boot-reminder.sh, axiarch-protect-antifull.sh, axiarch-init-task-md.sh, axiarch-task-state.sh, axiarch-diff-guard.sh; upgrade: axiarch-upgrade.sh; prompts-install: axiarch-prompts-install.sh; diagnostics: check-axiarch-health.sh, check-git-config-clean.sh)"
  fi

  # === Optional: generate Claude Code slash commands (/axiarch-*) ===
  if ${GEN_PROMPT_COMMANDS:-false} && [[ -x "$TARGET_DIR/axiarch-scripts/axiarch-prompts-install.sh" ]]; then
    ( cd "$TARGET_DIR" && bash axiarch-scripts/axiarch-prompts-install.sh --lang "${LANG_CODE}" ) \
      && print_info "Generated: .claude/commands/axiarch-* (Claude Code slash commands)" \
      || { print_error "Slash command staging failed; no installation applied."; return 3; }
  fi

  # === Agent-specific setup: install selected agent's native config ===
  if $SETUP_ANTIGRAVITY; then
    mkdir -p "$TARGET_DIR/.agents/rules"
    cp "$SOURCE_DIR/.agents/rules/prompt_pointer.md" \
       "$TARGET_DIR/.agents/rules/prompt_pointer.md"
    print_info "Copied: .agents/rules/prompt_pointer.md (Antigravity)"
  fi

  if $SETUP_CURSOR; then
    mkdir -p "$TARGET_DIR/.cursor/rules"
    cp "$SOURCE_DIR/.cursor/rules/axiarch.mdc" \
       "$TARGET_DIR/.cursor/rules/axiarch.mdc"
    print_info "Copied: .cursor/rules/axiarch.mdc (Cursor)"
  fi

  if $SETUP_CLAUDE; then
    cp "$SOURCE_DIR/CLAUDE.md" \
       "$TARGET_DIR/CLAUDE.md"
    print_info "Copied: CLAUDE.md (Claude Code)"

    # === Claude Code: hook reinforcement ===
    if [[ -f "$SOURCE_DIR/.claude/settings.json" ]]; then
      mkdir -p "$TARGET_DIR/.claude"
      cp "$SOURCE_DIR/.claude/settings.json" \
         "$TARGET_DIR/.claude/settings.json"
      print_info "Copied: .claude/settings.json (hook reinforcement)"

      # JSON syntax was validated during source preflight.
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

      # JSON syntax was validated during source preflight.
    fi
  fi

  if $SETUP_COPILOT; then
    mkdir -p "$TARGET_DIR/.github"
    cp "$SOURCE_DIR/.github/copilot-instructions.md" \
       "$TARGET_DIR/.github/copilot-instructions.md"
    print_info "Copied: .github/copilot-instructions.md (GitHub Copilot)"
  fi

  if $SETUP_WINDSURF; then
    cp "$SOURCE_DIR/.windsurfrules" \
       "$TARGET_DIR/.windsurfrules"
    print_info "Copied: .windsurfrules (Windsurf)"
  fi

  # Preserve unselected native configs. They may contain adopter-owned rules,
  # sessions, or non-Axiarch settings, and AXIARCH.md treats adapters as
  # coexistable pointers rather than mutually exclusive choices.
  if ! $SETUP_ANTIGRAVITY && [[ -d "$TARGET_DIR/.agents" ]]; then
    print_info "Preserved: .agents/ (unselected native config)"
  fi
  if ! $SETUP_CURSOR && [[ -d "$TARGET_DIR/.cursor" ]]; then
    print_info "Preserved: .cursor/ (unselected native config)"
  fi
  if ! $SETUP_CLAUDE; then
    [[ -f "$TARGET_DIR/CLAUDE.md" ]] && print_info "Preserved: CLAUDE.md (unselected native config)"
    [[ -d "$TARGET_DIR/.claude" ]] && print_info "Preserved: .claude/ (unselected native config)"
  fi
  if ! $SETUP_CODEX && [[ -d "$TARGET_DIR/.codex" ]]; then
    print_info "Preserved: .codex/ (unselected native config)"
  fi
  if ! $SETUP_COPILOT && [[ -f "$TARGET_DIR/.github/copilot-instructions.md" ]]; then
    print_info "Preserved: .github/copilot-instructions.md (unselected native config)"
  fi
  if ! $SETUP_WINDSURF && [[ -f "$TARGET_DIR/.windsurfrules" ]]; then
    print_info "Preserved: .windsurfrules (unselected native config)"
  fi
}

# =============================================================================
# STEP 6: Post-setup instructions
# =============================================================================
print_next_steps() {
  echo ""
  echo -e "${BOLD}${GREEN}🎉 Axiarch setup complete!${RESET}"
  echo ""
  echo -e "${BOLD}Next Steps:${RESET}"
  echo ""
  if [[ -f "$TARGET_DIR/AXIARCH.md" ]]; then
    echo -e "  ${CYAN}1.${RESET} ${BOLD}AXIARCH.md${RESET} Project Native Language is set to ${BOLD}${PROJECT_NATIVE_LANGUAGE}${RESET}"
  fi

  local step=2
  if [[ "$AGENT_LABEL" == "Google Antigravity" ]]; then
    echo -e "  ${CYAN}${step}.${RESET} ✅ ${BOLD}.agents/rules/prompt_pointer.md → AXIARCH.md${RESET} — auto-configured"
    step=$((step + 1))
  elif [[ "$AGENT_LABEL" == "OpenAI Codex" ]]; then
    if [[ -f "$TARGET_DIR/AXIARCH.md" ]]; then
      echo -e "  ${CYAN}${step}.${RESET} ✅ ${BOLD}AGENTS.md → AXIARCH.md${RESET} + ${BOLD}.codex/hooks.json${RESET} — auto-configured"
    fi
    step=$((step + 1))
  elif [[ "$AGENT_LABEL" == "Cursor" ]]; then
    echo -e "  ${CYAN}${step}.${RESET} ✅ ${BOLD}.cursor/rules/axiarch.mdc → AXIARCH.md${RESET} — auto-configured"
    step=$((step + 1))
  elif [[ "$AGENT_LABEL" == "Claude Code" ]]; then
    if [[ -f "$TARGET_DIR/AXIARCH.md" ]]; then
      echo -e "  ${CYAN}${step}.${RESET} ✅ ${BOLD}CLAUDE.md → AXIARCH.md${RESET} + ${BOLD}.claude/settings.json${RESET} — auto-configured"
    fi
    step=$((step + 1))
  elif [[ "$AGENT_LABEL" == "GitHub Copilot" ]]; then
    echo -e "  ${CYAN}${step}.${RESET} ✅ ${BOLD}.github/copilot-instructions.md → AXIARCH.md${RESET} — auto-configured"
    step=$((step + 1))
  elif [[ "$AGENT_LABEL" == "Windsurf" ]]; then
    echo -e "  ${CYAN}${step}.${RESET} ✅ ${BOLD}.windsurfrules → AXIARCH.md${RESET} — auto-configured"
    step=$((step + 1))
  fi

  echo -e "  ${CYAN}${step}.${RESET} Edit ${BOLD}axiarch-rules/${LANG_CODE}/blueprint/core/000_project_overview.md${RESET}"
  echo -e "       → Fill in your project's tech stack, architecture, and goals"
  step=$((step + 1))
  echo ""
  if [[ "$SETUP_CODEX" == "true" || "$SETUP_CLAUDE" == "true" ]]; then
    echo -e "  ${CYAN}${step}.${RESET} ${BOLD}Verify hook wiring (recommended for Codex / Claude Code):${RESET}"
    echo -e "       → ${BOLD}bash axiarch-scripts/check-axiarch-health.sh${RESET}"
    echo -e "         (16-stage diagnostic: 4-hook wiring, record consistency, crystallization, hook configuration, diff guard, more)"
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
  echo "  Diagnostics check files and wiring, not AI understanding or agent runtime behavior."
  echo -e "  ${CYAN}${step}.${RESET} Start developing — the Constitution is now available to your AI agent."
  echo ""
  echo -e "  ${CYAN}Docs:${RESET}  ${REPO_URL}"
  echo -e "  ${CYAN}Scripts:${RESET} See ${BOLD}axiarch-scripts/README.md${RESET} for diagnostic tools"
  echo -e "  ${CYAN}Issues:${RESET} ${REPO_URL}/issues"
  echo ""
}

stage_and_install() {
  local actual_target="$TARGET_DIR"
  local helper="$SOURCE_DIR/axiarch-scripts/axiarch_setup.py"
  if [[ ! -f "$helper" ]]; then
    print_error "Selected source lacks setup helpers; use the installer shipped with that source. No files applied."
    return 2
  fi
  local required=(AXIARCH.md AGENTS.md axiarch-manifest.json)
  local required_dirs=(axiarch-rules axiarch-harness axiarch-scripts)
  required+=(axiarch-rules/LICENSE axiarch-rules/NOTICE)
  required+=(axiarch-scripts/check-axiarch-health.sh axiarch-scripts/axiarch_state.py
    axiarch-scripts/axiarch_upgrade.py axiarch-scripts/axiarch_inspect.py axiarch-scripts/axiarch_setup.py
    axiarch-scripts/axiarch_hook.py axiarch-scripts/axiarch_diff.py)
  local lang
  for lang in ja en; do
    if $KEEP_BOTH_LANGS || [[ "$lang" == "$LANG_CODE" ]]; then
      required+=("axiarch-rules/$lang/LOADING_PROTOCOL.md" "axiarch-harness/$lang/TASK_STATE_PROTOCOL.md")
      $COPY_PROMPTS && required_dirs+=("axiarch-prompts/$lang")
    fi
  done
  $SETUP_CODEX && required+=(.codex/hooks.json)
  $SETUP_CLAUDE && required+=(CLAUDE.md .claude/settings.json)
  if $SETUP_CLAUDE && [[ -e "$SOURCE_DIR/.claude/memory/MEMORY.md" || -L "$SOURCE_DIR/.claude/memory/MEMORY.md" ]]; then
    required+=(.claude/memory/MEMORY.md)
  fi
  $SETUP_ANTIGRAVITY && required+=(.agents/rules/prompt_pointer.md)
  $SETUP_CURSOR && required+=(.cursor/rules/axiarch.mdc)
  $SETUP_COPILOT && required+=(.github/copilot-instructions.md)
  $SETUP_WINDSURF && required+=(.windsurfrules)
  $COPY_PROMPTS && required_dirs+=(axiarch-prompts)
  python3 "$helper" check-source --source "$SOURCE_DIR" --files "${required[@]}" \
    --directories "${required_dirs[@]}" --paths "${required[@]}" "${required_dirs[@]}"
  # Use the actual source version. A local checkout is not proof of a remote tag.
  INSTALL_LABEL="$(python3 "$SOURCE_DIR/axiarch-scripts/axiarch_upgrade.py" manifest --source "$SOURCE_DIR" --format version)"
  STAGE_DIR="$(mktemp -d)"
  TARGET_DIR="$STAGE_DIR"
  print_info "Preparing files in isolated staging; no adopter files have been copied yet."
  copy_files
  TARGET_DIR="$actual_target"
  local languages="both" source_ref="$AXIARCH_REF"
  $KEEP_BOTH_LANGS || languages="$LANG_CODE"
  $IS_REMOTE || source_ref="local-source"
  local args=(--target "$TARGET_DIR" --stage "$STAGE_DIR" --version "$INSTALL_LABEL"
    --source-ref "$source_ref" --agent "$AGENT_ID" --lang "$LANG_CODE" --languages "$languages")
  $COPY_PROMPTS && args+=(--with-prompts)
  $INSTALL_PRECOMMIT && args+=(--precommit)
  local rc=0
  python3 "$helper" install "${args[@]}" || rc=$?
  if [[ "$rc" -ne 0 ]]; then
    print_error "Setup not confirmed (exit=$rc). Existing files were preserved; inspect any .axiarch/install-result.json and install-health.log."
    return "$rc"
  fi
}

# =============================================================================
# Main
# =============================================================================
main() {
  if [[ "$AXIARCH_REF" =~ [[:cntrl:]] || "$TARGET_DIR" =~ [[:cntrl:]] ]]; then
    print_error 'Control characters are not supported in the source reference or target path.'
    return 2
  fi
  if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    echo 'Usage: bash init.sh [target-directory] (fresh setup; existing projects use axiarch-scripts/axiarch-upgrade.sh)'
    return 0
  fi
  if [[ $# -gt 1 || "${1:-}" == -* ]]; then
    print_error 'Expected one target directory. For upgrade previews use axiarch-scripts/axiarch-upgrade.sh --dry-run.'
    return 2
  fi
  print_header
  check_prerequisites
  check_existing_install
  select_language
  select_language_dirs
  select_agent
  select_prompts
  select_precommit
  prepare_source
  stage_and_install
  print_next_steps
}

main "$@"
