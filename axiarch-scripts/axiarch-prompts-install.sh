#!/usr/bin/env bash
# =============================================================================
# Axiarch Prompts Installer — agent-native slash command generator
# https://github.com/hiroyuki-miyauchi/axiarch
#
# Converts the optional `axiarch-prompts/{lang}/{category}/*.md` templates into
# agent-native slash commands so adopters can invoke them with `/` instead of
# copy-pasting. The generated command is a thin pointer: it instructs the agent
# to read and execute the canonical prompt file, so the prompt stays the single
# source of truth and is always read at its latest version.
#
# Agent support (verified against each agent's documented mechanism):
#   - Claude Code : `.claude/commands/axiarch-<name>.md` → `/axiarch-<name>`
#                   (official, project-level, git-distributable)
#   - OpenAI Codex: project-level custom prompts are NOT supported (custom
#                   prompts are global-only under $CODEX_HOME/prompts and are
#                   deprecated). Codex users invoke prompts via AGENTS.md
#                   guidance or copy-paste. This installer does not generate
#                   broken project-level Codex commands.
#   - Antigravity : workflow project-file conventions are not authoritatively
#                   documented. Use copy-paste / Customizations panel.
#
# Design principles:
#   - Idempotent: regenerates only files carrying the axiarch marker; never
#     touches an adopter's own `.claude/commands/` files.
#   - Single source of truth: commands point to the canonical prompt file.
#   - Bilingual aware: generates from the Project Native Language folder.
#   - Pure bash, no jq dependency.
#
# Usage:
#   bash axiarch-scripts/axiarch-prompts-install.sh [options]
#     --target DIR   Adopter project root (default: current directory)
#     --source DIR   Axiarch source root (default: parent of this script)
#     --lang LANG    ja|en|auto (default: auto = detect from AXIARCH.md)
#     --clean        Remove axiarch-generated commands and exit
#     --dry-run      Print what would happen without writing
#     -h, --help     Show help
# =============================================================================

set -euo pipefail

MARKER="<!-- AXIARCH_GENERATED_COMMAND: do not edit; regenerate via axiarch-scripts/axiarch-prompts-install.sh -->"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

print_info()    { printf '%b\n' "   ${CYAN}→${RESET} $*"; }
print_success() { printf '%b\n' "${GREEN}✅ $*${RESET}"; }
print_warn()    { printf '%b\n' "${YELLOW}⚠️  $*${RESET}"; }
print_err()     { printf '%b\n' "${RED}❌ $*${RESET}" >&2; }

# -----------------------------------------------------------------------------
# Resolve defaults
# -----------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$(dirname "${SCRIPT_DIR}")"
TARGET_DIR="$(pwd)"
LANG_MODE="auto"
CLEAN_ONLY=false
DRY_RUN=false

usage() {
  cat <<'EOF'
Axiarch Prompts Installer — generate agent-native slash commands from axiarch-prompts/

Usage: bash axiarch-scripts/axiarch-prompts-install.sh [options]
  --target DIR   Adopter project root (default: current directory)
  --source DIR   Axiarch source root (default: parent of this script)
  --lang LANG    ja|en|auto (default: auto = detect from AXIARCH.md)
  --clean        Remove axiarch-generated commands and exit
  --dry-run      Print planned actions without writing
  -h, --help     Show this help

Generates: .claude/commands/axiarch-<name>.md  →  /axiarch-<name>  (Claude Code)
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target) TARGET_DIR="$2"; shift 2 ;;
    --source) SOURCE_DIR="$2"; shift 2 ;;
    --lang)   LANG_MODE="$2"; shift 2 ;;
    --clean)  CLEAN_ONLY=true; shift ;;
    --dry-run) DRY_RUN=true; shift ;;
    -h|--help) usage; exit 0 ;;
    *) print_err "Unknown option: $1"; usage; exit 1 ;;
  esac
done

COMMANDS_DIR="${TARGET_DIR}/.claude/commands"

# -----------------------------------------------------------------------------
# Clean: remove only axiarch-marked generated commands
# -----------------------------------------------------------------------------
remove_generated() {
  local removed=0
  if [[ -d "${COMMANDS_DIR}" ]]; then
    while IFS= read -r f; do
      if grep -qF "AXIARCH_GENERATED_COMMAND" "$f" 2>/dev/null; then
        if [[ "${DRY_RUN}" == "true" ]]; then
          print_info "[dry-run] would remove ${f#${TARGET_DIR}/}"
        else
          rm -f "$f"
        fi
        removed=$((removed + 1))
      fi
    done < <(find "${COMMANDS_DIR}" -maxdepth 1 -name 'axiarch-*.md' 2>/dev/null)
  fi
  printf '%s' "${removed}"
}

if [[ "${CLEAN_ONLY}" == "true" ]]; then
  count="$(remove_generated)"
  print_success "Removed ${count} axiarch-generated command(s) from .claude/commands/"
  exit 0
fi

# -----------------------------------------------------------------------------
# Detect Project Native Language
# -----------------------------------------------------------------------------
detect_lang() {
  if [[ "${LANG_MODE}" == "ja" || "${LANG_MODE}" == "en" ]]; then
    printf '%s' "${LANG_MODE}"
    return 0
  fi
  # auto: read AXIARCH.md (canonical) or AGENTS.md adapter in target, then source
  local protocol=""
  for cand in "${TARGET_DIR}/AXIARCH.md" "${TARGET_DIR}/AGENTS.md" "${SOURCE_DIR}/AXIARCH.md"; do
    if [[ -f "${cand}" ]]; then protocol="${cand}"; break; fi
  done
  if [[ -n "${protocol}" ]]; then
    local line
    line="$(grep -iE "Project Native Language" "${protocol}" 2>/dev/null | head -1 || true)"
    if printf '%s' "${line}" | grep -qiE "English" && ! printf '%s' "${line}" | grep -qiE "Japanese \| English|Japanese|日本語"; then
      printf '%s' "en"; return 0
    fi
    # If the resolved (non-template) value is English-only
    if printf '%s' "${line}" | grep -qiE ":\s*\[?English\]?" && ! printf '%s' "${line}" | grep -qiE "Japanese"; then
      printf '%s' "en"; return 0
    fi
  fi
  # default
  printf '%s' "ja"
}

LANG_CODE="$(detect_lang)"
PROMPTS_ROOT="${SOURCE_DIR}/axiarch-prompts/${LANG_CODE}"

# Fall back to the language actually present in the target if source lang missing
if [[ ! -d "${PROMPTS_ROOT}" ]]; then
  if [[ -d "${TARGET_DIR}/axiarch-prompts/${LANG_CODE}" ]]; then
    PROMPTS_ROOT="${TARGET_DIR}/axiarch-prompts/${LANG_CODE}"
  fi
fi

if [[ ! -d "${PROMPTS_ROOT}" ]]; then
  print_err "Prompt library not found for lang='${LANG_CODE}'. Looked in: ${SOURCE_DIR}/axiarch-prompts/${LANG_CODE} and ${TARGET_DIR}/axiarch-prompts/${LANG_CODE}"
  print_info "Install the prompt library first (init.sh prompt step) or pass --source."
  exit 1
fi

# -----------------------------------------------------------------------------
# Helpers
# -----------------------------------------------------------------------------
# Extract a description from the prompt's first H1 line (strip leading '# ').
prompt_description() {
  local file="$1"
  local title
  title="$(grep -m1 -E '^# ' "${file}" 2>/dev/null | sed 's/^# *//' || true)"
  [[ -z "${title}" ]] && title="Axiarch prompt"
  printf '%s' "${title}"
}

# Map a prompt filename to a slash-command name: underscores -> hyphens.
command_name() {
  local base="$1"            # e.g. feature_development
  printf 'axiarch-%s' "$(printf '%s' "${base}" | tr '_' '-')"
}

# -----------------------------------------------------------------------------
# Generate
# -----------------------------------------------------------------------------
print_info "Source prompts : ${PROMPTS_ROOT}"
print_info "Target commands: ${COMMANDS_DIR}"
print_info "Project Native Language: ${LANG_CODE}"

# Remove previously generated commands first (idempotent regen)
removed="$(remove_generated)"
[[ "${removed}" -gt 0 ]] && print_info "Cleared ${removed} previously generated command(s)"

if [[ "${DRY_RUN}" != "true" ]]; then
  mkdir -p "${COMMANDS_DIR}"
fi

generated=0
while IFS= read -r prompt_file; do
  rel="${prompt_file#${SOURCE_DIR}/}"
  # If prompts came from target (fallback), recompute rel from target
  [[ "${rel}" == "${prompt_file}" ]] && rel="${prompt_file#${TARGET_DIR}/}"

  category="$(basename "$(dirname "${prompt_file}")")"   # develop / audit / govern / operate
  base="$(basename "${prompt_file}" .md)"                # feature_development
  cmd="$(command_name "${base}")"                        # axiarch-feature-development
  desc="$(prompt_description "${prompt_file}")"
  out="${COMMANDS_DIR}/${cmd}.md"

  if [[ "${DRY_RUN}" == "true" ]]; then
    print_info "[dry-run] /${cmd}  ←  ${rel}"
    generated=$((generated + 1))
    continue
  fi

  {
    printf '%s\n' "---"
    printf 'description: %s (%s)\n' "${desc}" "${category}"
    printf 'argument-hint: %s\n' "[タスク内容・対象・方針 / task, target, policy]"
    printf '%s\n' "---"
    printf '%s\n\n' "${MARKER}"
    printf '%s\n\n' "あなたは Axiarch のタスク実行プロンプト「${desc}」を実行します。"
    printf '%s\n' "1. まず正本プロンプト \`${rel}\` を Read tool で読み込む（このコマンドは常に最新の正本を参照する thin pointer です）。"
    printf '%s\n' "2. そのファイルの Boot Sequence / Phase 0 の手順に**厳密に**従う。ロード前の推測・仮説出力はしない。"
    printf '%s\n\n' "3. AXIARCH.md（正本）と LOADING_PROTOCOL の BOOT SEQUENCE を併せて適用する。"
    printf '%s\n\n' "Execute the Axiarch task prompt above. First Read the canonical prompt file \`${rel}\` (this command is a thin pointer that always references the latest canonical prompt), then follow its Boot Sequence / Phase 0 exactly, applying AXIARCH.md and LOADING_PROTOCOL."
    printf '%s\n' "ユーザーからの追加入力 / User-provided input:"
    printf '%s\n' '$ARGUMENTS'
  } > "${out}"

  generated=$((generated + 1))
done < <(find "${PROMPTS_ROOT}" -mindepth 2 -maxdepth 2 -name '*.md' 2>/dev/null | sort)

if [[ "${DRY_RUN}" == "true" ]]; then
  print_success "[dry-run] Would generate ${generated} Claude Code slash command(s) under .claude/commands/"
else
  print_success "Generated ${generated} Claude Code slash command(s) → /axiarch-* in .claude/commands/"
  print_info "Invoke in Claude Code with e.g. /axiarch-feature-development"
fi

# -----------------------------------------------------------------------------
# Honest per-agent note
# -----------------------------------------------------------------------------
printf '\n'
print_info "Agent support:"
print_info "  Claude Code : /axiarch-<name> (generated above)"
print_info "  OpenAI Codex: project-level custom commands unsupported (global-only/deprecated) — use copy-paste or AGENTS.md guidance"
print_info "  Antigravity : project workflow file convention undocumented — use copy-paste / Customizations panel"
