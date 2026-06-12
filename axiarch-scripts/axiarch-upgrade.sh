#!/usr/bin/env bash
# =============================================================================
# Axiarch Safe Upgrade Wizard
# https://github.com/hiroyuki-miyauchi/axiarch
#
# Local-first upgrade helper for adopter projects. It updates Axiarch Core files
# while preserving project-owned Blueprint state by default.
#
# Key modes:
#   --dry-run       Show the planned changes only.
#   --safe-only     Apply only clearly Axiarch-owned safe groups.
#   --interactive   Ask group/file choices with bilingual labels.
#   --apply         Actually write changes. Without --apply, execution is dry-run
#                   unless interactive mode receives final confirmation.
# =============================================================================

set -euo pipefail

REPO_URL="https://github.com/hiroyuki-miyauchi/axiarch"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_AXIARCH_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

PROJECT_DIR="$(pwd)"
SOURCE_DIR=""
BASE_SOURCE_DIR=""
TO_VERSION=""
TO_REF=""
FROM_VERSION=""
FROM_REF=""
SOURCE_AXIARCH_VERSION=""
TARGET_LANG="both"
TARGET_AGENT="universal"
WITH_PROMPTS=false
DRY_RUN=true
APPLY=false
SAFE_ONLY=false
INTERACTIVE=false
YES=false

TMP_DIR=""
ITEM_GROUPS=()
ITEM_PATHS=()
ITEM_OWNERS=()
ITEM_POLICIES=()
ITEM_AGENTS=()
GROUP_ACTIONS=""
ACTION_LOG=""
MANIFEST_GROUPS=""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

print_header() {
  printf '\n%b\n' "${BOLD}${CYAN}Axiarch Safe Upgrade Wizard${RESET}"
  printf '%b\n\n' "${CYAN}Coreは更新し、Project Stateは既定で保持します。 / Updates Core while preserving Project State by default.${RESET}"
}

print_info() { printf '%b\n' "${CYAN}→${RESET} $1"; }
print_ok() { printf '%b\n' "${GREEN}OK${RESET} $1"; }
print_warn() { printf '%b\n' "${YELLOW}WARN${RESET} $1"; }
print_err() { printf '%b\n' "${RED}ERROR${RESET} $1" >&2; }

usage() {
  cat <<'USAGE'
Usage:
  bash axiarch-scripts/axiarch-upgrade.sh [options]

Options:
  --target DIR        Adopter project directory. Default: current directory.
  --source DIR        Local Axiarch source directory to upgrade from.
  --to VERSION        Target Axiarch version label, e.g. v1.13.1 or main.
  --ref REF           GitHub archive ref, e.g. tags/v1.14.0 or heads/main.
  --from VERSION      Optional base version for replace-if checks and 3-way merge.
  --from-ref REF      Optional base archive ref for replace-if checks and 3-way merge.
  --base-source DIR   Optional local base Axiarch source for replace-if checks and 3-way merge.
  --lang ja|en|both   Target language folders. Default: both.
  --agent NAME        universal|codex|claude|antigravity|cursor|copilot|windsurf|all
  --with-prompts      Include optional axiarch-prompts/.
  --dry-run           Show plan only. Default.
  --safe-only         Select only low-risk Axiarch-owned groups.
  --interactive       Ask group/file choices with bilingual labels.
  --apply             Write selected changes.
  --yes               Skip final confirmation for non-interactive apply.
  --help              Show this help.

Examples:
  bash axiarch-scripts/axiarch-upgrade.sh --to v1.14.0 --dry-run
  bash axiarch-scripts/axiarch-upgrade.sh --to v1.14.0 --agent codex --safe-only --apply
  bash axiarch-scripts/axiarch-upgrade.sh --source /path/to/axiarch --interactive
USAGE
}

cleanup() {
  if [[ -n "${TMP_DIR}" && -d "${TMP_DIR}" ]]; then
    rm -rf "${TMP_DIR}"
  fi
}
trap cleanup EXIT

require_arg() {
  local name="$1"
  local value="${2:-}"
  if [[ -z "${value}" ]]; then
    print_err "${name} requires a value."
    exit 1
  fi
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --target)
        require_arg "$1" "${2:-}"
        PROJECT_DIR="$2"
        shift 2
        ;;
      --source)
        require_arg "$1" "${2:-}"
        SOURCE_DIR="$2"
        shift 2
        ;;
      --base-source)
        require_arg "$1" "${2:-}"
        BASE_SOURCE_DIR="$2"
        shift 2
        ;;
      --to)
        require_arg "$1" "${2:-}"
        TO_VERSION="$2"
        shift 2
        ;;
      --ref)
        require_arg "$1" "${2:-}"
        TO_REF="$2"
        shift 2
        ;;
      --from)
        require_arg "$1" "${2:-}"
        FROM_VERSION="$2"
        shift 2
        ;;
      --from-ref)
        require_arg "$1" "${2:-}"
        FROM_REF="$2"
        shift 2
        ;;
      --lang)
        require_arg "$1" "${2:-}"
        TARGET_LANG="$2"
        shift 2
        ;;
      --agent)
        require_arg "$1" "${2:-}"
        TARGET_AGENT="$2"
        shift 2
        ;;
      --with-prompts)
        WITH_PROMPTS=true
        shift
        ;;
      --dry-run)
        DRY_RUN=true
        APPLY=false
        shift
        ;;
      --safe-only)
        SAFE_ONLY=true
        shift
        ;;
      --interactive)
        INTERACTIVE=true
        shift
        ;;
      --apply)
        APPLY=true
        DRY_RUN=false
        shift
        ;;
      --yes|-y)
        YES=true
        shift
        ;;
      --help|-h)
        usage
        exit 0
        ;;
      *)
        print_err "Unknown option: $1"
        usage
        exit 1
        ;;
    esac
  done

  case "${TARGET_LANG}" in
    ja|en|both) ;;
    *)
      print_err "--lang must be ja, en, or both."
      exit 1
      ;;
  esac
  case "${TARGET_AGENT}" in
    universal|codex|claude|antigravity|cursor|copilot|windsurf|all) ;;
    *)
      print_err "--agent must be universal, codex, claude, antigravity, cursor, copilot, windsurf, or all."
      exit 1
      ;;
  esac
}

archive_ref_for_version() {
  local version="$1"
  if [[ -z "${version}" ]]; then
    printf '%s' "heads/main"
  elif [[ "${version}" == *"-dev"* ]]; then
    printf '%s' "heads/main"
  else
    version="${version#v}"
    printf 'tags/v%s' "${version}"
  fi
}

download_archive() {
  local ref="$1"
  local destination="$2"
  local url="${REPO_URL}/archive/refs/${ref}.tar.gz"

  mkdir -p "${destination}"
  if command -v curl >/dev/null 2>&1; then
    curl -sSL "${url}" | tar -xz -C "${destination}" --strip-components=1
  elif command -v wget >/dev/null 2>&1; then
    wget -qO- "${url}" | tar -xz -C "${destination}" --strip-components=1
  else
    print_err "curl or wget is required to download Axiarch source."
    exit 1
  fi
}

resolve_sources() {
  PROJECT_DIR="$(cd "${PROJECT_DIR}" && pwd)"

  if [[ -n "${SOURCE_DIR}" ]]; then
    SOURCE_DIR="$(cd "${SOURCE_DIR}" && pwd)"
  elif [[ -n "${TO_VERSION}" || -n "${TO_REF}" ]]; then
    TO_REF="${TO_REF:-$(archive_ref_for_version "${TO_VERSION}")}"
    TMP_DIR="$(mktemp -d)"
    SOURCE_DIR="${TMP_DIR}/target"
    print_info "Downloading Axiarch source: ${TO_REF}"
    download_archive "${TO_REF}" "${SOURCE_DIR}"
  else
    SOURCE_DIR="${LOCAL_AXIARCH_ROOT}"
  fi

  if [[ ! -f "${SOURCE_DIR}/axiarch-manifest.json" ]]; then
    print_err "Axiarch source is missing axiarch-manifest.json: ${SOURCE_DIR}"
    exit 1
  fi
  if command -v jq >/dev/null 2>&1; then
    SOURCE_AXIARCH_VERSION="$(jq -r '.axiarchVersion // empty' "${SOURCE_DIR}/axiarch-manifest.json" 2>/dev/null || true)"
  else
    SOURCE_AXIARCH_VERSION="$(sed -n 's/.*"axiarchVersion":[[:space:]]*"\([^"]*\)".*/\1/p' "${SOURCE_DIR}/axiarch-manifest.json" | head -n 1)"
  fi

  if [[ -n "${BASE_SOURCE_DIR}" ]]; then
    BASE_SOURCE_DIR="$(cd "${BASE_SOURCE_DIR}" && pwd)"
  elif [[ -n "${FROM_VERSION}" || -n "${FROM_REF}" ]]; then
    FROM_REF="${FROM_REF:-$(archive_ref_for_version "${FROM_VERSION}")}"
    if [[ -z "${TMP_DIR}" ]]; then
      TMP_DIR="$(mktemp -d)"
    fi
    BASE_SOURCE_DIR="${TMP_DIR}/base"
    print_info "Downloading base Axiarch source: ${FROM_REF}"
    download_archive "${FROM_REF}" "${BASE_SOURCE_DIR}"
  fi
}

selected_langs() {
  case "${TARGET_LANG}" in
    ja) printf '%s\n' "ja" ;;
    en) printf '%s\n' "en" ;;
    both) printf '%s\n%s\n' "ja" "en" ;;
  esac
}

agent_matches() {
  local allowed="$1"
  case "${allowed}" in
    all|universal|"") return 0 ;;
  esac
  if [[ "${TARGET_AGENT}" == "all" ]]; then
    return 0
  fi
  case ",${allowed}," in
    *",${TARGET_AGENT},"*) return 0 ;;
  esac
  return 1
}

add_item() {
  local group="$1"
  local path="$2"
  local owner="$3"
  local policy="$4"
  local agents="${5:-all}"

  if [[ "${path}" == "axiarch-prompts" && "${WITH_PROMPTS}" != "true" && "${INTERACTIVE}" != "true" ]]; then
    return 0
  fi
  if ! agent_matches "${agents}"; then
    return 0
  fi

  ITEM_GROUPS+=("${group}")
  ITEM_PATHS+=("${path}")
  ITEM_OWNERS+=("${owner}")
  ITEM_POLICIES+=("${policy}")
  ITEM_AGENTS+=("${agents}")
}

add_localized_item() {
  local group="$1"
  local template="$2"
  local owner="$3"
  local policy="$4"
  local agents="${5:-all}"
  local lang

  while IFS= read -r lang; do
    add_item "${group}" "${template/\{lang\}/${lang}}" "${owner}" "${policy}" "${agents}"
  done <<EOF
$(selected_langs)
EOF
}

add_item_once() {
  local group="$1"
  local path="$2"
  local owner="$3"
  local policy="$4"
  local i

  i=0
  while [[ ${i} -lt ${#ITEM_PATHS[@]} ]]; do
    if [[ "${ITEM_PATHS[$i]}" == "${path}" ]]; then
      return 0
    fi
    i=$((i + 1))
  done
  add_item "${group}" "${path}" "${owner}" "${policy}" "all"
}

add_item_once_full() {
  local group="$1"
  local path="$2"
  local owner="$3"
  local policy="$4"
  local agents="${5:-all}"
  local i

  i=0
  while [[ ${i} -lt ${#ITEM_PATHS[@]} ]]; do
    if [[ "${ITEM_PATHS[$i]}" == "${path}" ]]; then
      return 0
    fi
    i=$((i + 1))
  done
  add_item "${group}" "${path}" "${owner}" "${policy}" "${agents}"
}

path_is_excluded() {
  local path="$1"
  local excludes="${2:-}"
  local pattern

  [[ -z "${excludes}" ]] && return 1

  while IFS= read -r pattern; do
    [[ -z "${pattern}" ]] && continue
    if [[ "${path}" == ${pattern} ]]; then
      return 0
    fi
  done < <(printf '%s\n' "${excludes}" | tr '|' '\n')

  return 1
}

expand_manifest_glob() {
  local group="$1"
  local pattern="$2"
  local owner="$3"
  local policy="$4"
  local agents="${5:-all}"
  local excludes="${6:-}"
  local root
  local match
  local list_file

  for root in "${PROJECT_DIR}" "${SOURCE_DIR}"; do
    [[ -d "${root}" ]] || continue
    list_file="$(mktemp)"
    (cd "${root}" && compgen -G "${pattern}" || true) > "${list_file}"
    sort -u "${list_file}" -o "${list_file}"
    while IFS= read -r match; do
      [[ -z "${match}" ]] && continue
      if path_is_excluded "${match}" "${excludes}"; then
        continue
      fi
      add_item_once_full "${group}" "${match}" "${owner}" "${policy}" "${agents}"
    done < "${list_file}"
    rm -f "${list_file}"
  done
}

add_manifest_path() {
  local group="$1"
  local path="$2"
  local owner="$3"
  local policy="$4"
  local agents="${5:-all}"
  local excludes="${6:-}"

  if path_is_excluded "${path}" "${excludes}"; then
    return 0
  fi

  case "${path}" in
    *'*'*|*'['*|*'?'*)
      expand_manifest_glob "${group}" "${path}" "${owner}" "${policy}" "${agents}" "${excludes}"
      ;;
    *)
      add_item_once_full "${group}" "${path}" "${owner}" "${policy}" "${agents}"
      ;;
  esac
}

add_manifest_entry() {
  local group="$1"
  local path="$2"
  local owner="$3"
  local policy="$4"
  local agents="${5:-all}"
  local excludes="${6:-}"
  local lang
  local localized_excludes

  if [[ "${path}" == *"{lang}"* ]]; then
    while IFS= read -r lang; do
      localized_excludes="${excludes//\{lang\}/${lang}}"
      add_manifest_path "${group}" "${path/\{lang\}/${lang}}" "${owner}" "${policy}" "${agents}" "${localized_excludes}"
    done <<EOF
$(selected_langs)
EOF
  else
    add_manifest_path "${group}" "${path}" "${owner}" "${policy}" "${agents}" "${excludes}"
  fi
}

load_manifest_group_metadata() {
  local manifest="$1"
  MANIFEST_GROUPS="$(jq -r '.groups[]? | [.id, (.label // ""), (.labelJa // ""), (.defaultAction // ""), (.risk // "")] | @tsv' "${manifest}")"
}

register_manifest_items() {
  local manifest="${SOURCE_DIR}/axiarch-manifest.json"
  local group
  local path
  local owner
  local policy
  local agents
  local excludes

  if command -v jq >/dev/null 2>&1 && jq -e '.files | type == "array"' "${manifest}" >/dev/null 2>&1; then
    load_manifest_group_metadata "${manifest}"
    while IFS=$'\t' read -r group path owner policy agents excludes; do
      [[ -z "${group}" || -z "${path}" ]] && continue
      owner="${owner:-mixed}"
      policy="${policy:-review}"
      agents="${agents:-all}"
      excludes="${excludes:-}"
      add_manifest_entry "${group}" "${path}" "${owner}" "${policy}" "${agents}" "${excludes}"
    done < <(jq -r '.files[] | [.group, .path, (.owner // "mixed"), (.policy // "review"), ((.agents // ["all"]) | join(",")), ((.exclude // []) | join("|"))] | @tsv' "${manifest}")
  else
    print_warn "jq unavailable or manifest unreadable; falling back to embedded manifest defaults."
    register_manifest_defaults
  fi
}

register_manifest_defaults() {
  add_item "core_protocol" "AXIARCH.md" "mixed" "review" "all"
  add_item "pointer_files" "AGENTS.md" "mixed" "review" "codex,agents-md,universal"
  add_item "core_protocol" "axiarch-manifest.json" "axiarch" "replace" "all"
  add_item "execution_harness" "axiarch-harness/README.md" "axiarch" "replace" "all"
  add_localized_item "execution_harness" "axiarch-harness/{lang}" "axiarch" "replace"
  add_localized_item "core_protocol" "axiarch-rules/{lang}/LOADING_PROTOCOL.md" "axiarch" "replace"
  add_localized_item "core_protocol" "axiarch-rules/{lang}/CRYSTALLIZATION_PROTOCOL.md" "axiarch" "replace"
  add_localized_item "core_protocol" "axiarch-rules/{lang}/INDEX.md" "axiarch" "replace"
  add_localized_item "core_protocol" "axiarch-rules/{lang}/README.md" "axiarch" "replace"
  add_localized_item "core_protocol" "axiarch-rules/{lang}/compliance_matrix.md" "axiarch" "replace"

  add_localized_item "universal_rules" "axiarch-rules/{lang}/universal" "axiarch" "replace"
  add_item "scripts" "axiarch-scripts" "axiarch" "replace" "all"

  add_item "agent_hooks" ".codex/hooks.json" "mixed" "review" "codex"
  add_item "pointer_files" "CLAUDE.md" "mixed" "review" "claude"
  add_item "agent_hooks" ".claude/settings.json" "mixed" "review" "claude"
  add_item "agent_hooks" ".claude/memory/MEMORY.md" "project" "optional" "claude"
  add_item "pointer_files" ".agents/rules/prompt_pointer.md" "axiarch" "review" "antigravity"
  add_item "pointer_files" ".cursor/rules/axiarch.mdc" "axiarch" "review" "cursor"
  add_item "pointer_files" ".github/copilot-instructions.md" "mixed" "review" "copilot"
  add_item "pointer_files" ".windsurfrules" "mixed" "review" "windsurf"

  add_localized_item "blueprint_templates" "axiarch-rules/{lang}/blueprint/core/998_feature_spec_template.md" "axiarch" "replace-if-local-unchanged"
  add_localized_item "blueprint_templates" "axiarch-rules/{lang}/blueprint/core/999_project_specific_template.md" "axiarch" "replace-if-local-unchanged"
  add_localized_item "blueprint_templates" "axiarch-rules/{lang}/blueprint/core/020_governance_rules.md" "axiarch" "replace-if-local-unchanged"
  add_localized_item "blueprint_index" "axiarch-rules/{lang}/blueprint/INDEX.md" "mixed" "review"
  add_localized_item "blueprint_project_state" "axiarch-rules/{lang}/blueprint/core/000_project_overview.md" "project" "preserve"
  add_localized_item "blueprint_project_state" "axiarch-rules/{lang}/blueprint/core/010_project_lessons_log.md" "project" "preserve"

  local lang
  local dir
  local readme_path
  while IFS= read -r lang; do
    for dir in core ai design engineering operations product quality security; do
      readme_path="axiarch-rules/${lang}/blueprint/${dir}/README.md"
      add_item "blueprint_templates" "${readme_path}" "axiarch" "replace-if-local-unchanged" "all"
    done
    add_item "blueprint_templates" "axiarch-rules/${lang}/blueprint/operations/010_release_upgrade_operations.md" "axiarch" "replace-if-local-unchanged" "all"
  done <<EOF
$(selected_langs)
EOF

  discover_project_blueprint_files

  add_item "prompts" "axiarch-prompts" "axiarch" "optional" "all"

  add_item "source_docs" "README.md" "axiarch-source" "skip" "all"
  add_item "source_docs" "init.sh" "axiarch-source" "skip" "all"
  add_item "source_docs" "ROADMAP.md" "axiarch-source" "skip" "all"
  add_item "source_docs" "CHANGELOG.md" "axiarch-source" "skip" "all"
  add_item "source_docs" "CONTRIBUTING.md" "axiarch-source" "skip" "all"
  add_item "source_docs" "SECURITY.md" "axiarch-source" "skip" "all"
  add_item "source_docs" "CODE_OF_CONDUCT.md" "axiarch-source" "skip" "all"
  add_item "source_docs" "LICENSE" "axiarch-source" "skip" "all"
  add_item "source_docs" "NOTICE" "axiarch-source" "skip" "all"
  add_item "source_docs" "MARKET_STRATEGY.md" "axiarch-source" "skip" "all"
  add_item "source_docs" "llms.txt" "axiarch-source" "skip" "all"
  add_item "source_docs" "llms-full.txt" "axiarch-source" "skip" "all"
  add_item "source_docs" "social-preview.png" "axiarch-source" "skip" "all"
  add_item "source_docs" ".gitignore" "axiarch-source" "skip" "all"
  add_item "source_docs" ".markdownlint-cli2.jsonc" "axiarch-source" "skip" "all"
  add_item "source_docs" ".github/workflows/release.yml" "axiarch-source" "skip" "all"
  add_item "source_docs" ".github/workflows/lint.yml" "axiarch-source" "skip" "all"
  add_item "source_docs" ".github/CODEOWNERS" "axiarch-source" "skip" "all"
  add_item "source_docs" ".github/PULL_REQUEST_TEMPLATE.md" "axiarch-source" "skip" "all"
  add_item "source_docs" ".github/ISSUE_TEMPLATE" "axiarch-source" "skip" "all"
  add_item "source_docs" ".github/dependabot.yml" "axiarch-source" "skip" "all"
}

discover_project_blueprint_files() {
  local lang
  local domain
  local root
  local file
  local rel
  local list_file

  while IFS= read -r lang; do
    for domain in core ai design engineering operations product quality security; do
      for root in "${PROJECT_DIR}" "${SOURCE_DIR}"; do
        [[ -d "${root}/axiarch-rules/${lang}/blueprint/${domain}" ]] || continue
        list_file="$(mktemp)"
        find "${root}/axiarch-rules/${lang}/blueprint/${domain}" -maxdepth 1 -type f -name '[0-9][0-9][0-9]_*.md' > "${list_file}"
        while IFS= read -r file; do
          rel="${file#${root}/}"
          add_item_once "blueprint_project_state" "${rel}" "project" "preserve"
        done < "${list_file}"
        rm -f "${list_file}"
      done
    done
  done <<EOF
$(selected_langs)
EOF
}

default_group_ids() {
  printf '%s\n' \
    "core_protocol" \
    "execution_harness" \
    "universal_rules" \
    "scripts" \
    "agent_hooks" \
    "blueprint_templates" \
    "blueprint_index" \
    "blueprint_project_state" \
    "prompts" \
    "pointer_files" \
    "source_docs"
}

emit_group_once() {
  local group="$1"
  local seen="$2"

  [[ -z "${group}" ]] && return 1
  case "
${seen}
" in
    *"
${group}
"*) return 1 ;;
  esac
  printf '%s\n' "${group}"
}

iter_groups() {
  local seen=""
  local id
  local label
  local label_ja
  local default_action
  local risk
  local i
  local group

  if [[ -n "${MANIFEST_GROUPS}" ]]; then
    while IFS=$'\t' read -r id label label_ja default_action risk; do
      if emit_group_once "${id}" "${seen}"; then
        seen="${seen}${id}
"
      fi
    done <<EOF
${MANIFEST_GROUPS}
EOF
  else
    while IFS= read -r id; do
      if emit_group_once "${id}" "${seen}"; then
        seen="${seen}${id}
"
      fi
    done <<EOF
$(default_group_ids)
EOF
  fi

  i=0
  while [[ ${i} -lt ${#ITEM_GROUPS[@]} ]]; do
    group="${ITEM_GROUPS[$i]}"
    if emit_group_once "${group}" "${seen}"; then
      seen="${seen}${group}
"
    fi
    i=$((i + 1))
  done
}

manifest_group_label() {
  local group="$1"
  local id
  local label
  local label_ja
  local default_action
  local risk

  while IFS=$'\t' read -r id label label_ja default_action risk; do
    if [[ "${id}" == "${group}" && -n "${label}" ]]; then
      if [[ -n "${label_ja}" ]]; then
        printf '%s（%s）' "${label}" "${label_ja}"
      else
        printf '%s' "${label}"
      fi
      return 0
    fi
  done <<EOF
${MANIFEST_GROUPS}
EOF
  return 1
}

manifest_group_default_action() {
  local group="$1"
  local id
  local label
  local label_ja
  local default_action
  local risk

  while IFS=$'\t' read -r id label label_ja default_action risk; do
    if [[ "${id}" == "${group}" && -n "${default_action}" ]]; then
      printf '%s' "${default_action}"
      return 0
    fi
  done <<EOF
${MANIFEST_GROUPS}
EOF
  return 1
}

manifest_group_risk() {
  local group="$1"
  local id
  local label
  local label_ja
  local default_action
  local risk

  while IFS=$'\t' read -r id label label_ja default_action risk; do
    if [[ "${id}" == "${group}" && -n "${risk}" ]]; then
      printf '%s' "${risk}"
      return 0
    fi
  done <<EOF
${MANIFEST_GROUPS}
EOF
  return 1
}

group_label() {
  manifest_group_label "$1" && return 0
  case "$1" in
    core_protocol) printf '%s' "Core Protocol（中核プロトコル）" ;;
    execution_harness) printf '%s' "Execution Harness / Harness Engineering（実行ハーネス / ハーネスエンジニアリング）" ;;
    universal_rules) printf '%s' "Universal Rules（普遍憲法）" ;;
    scripts) printf '%s' "Scripts（診断・フックスクリプト）" ;;
    agent_hooks) printf '%s' "Agent Hooks & Native Config（エージェントフック・ネイティブ設定）" ;;
    blueprint_templates) printf '%s' "Blueprint Templates & Shared Rules（Blueprintテンプレート・共有ルール）" ;;
    blueprint_index) printf '%s' "Blueprint Index（Blueprint索引）" ;;
    blueprint_project_state) printf '%s' "Blueprint Project State（プロジェクト固有Blueprint）" ;;
    prompts) printf '%s' "Prompts（任意プロンプト集）" ;;
    pointer_files) printf '%s' "Pointer Files（エージェント別ポインター）" ;;
    source_docs) printf '%s' "Axiarch Source Repository Files（Axiarch本体リポジトリ専用ファイル）" ;;
    *) printf '%s' "$1" ;;
  esac
}

group_default_action() {
  manifest_group_default_action "$1" && return 0
  case "$1" in
    universal_rules|execution_harness|scripts) printf '%s' "update-all" ;;
    blueprint_project_state) printf '%s' "preserve" ;;
    prompts|source_docs) printf '%s' "skip" ;;
    *) printf '%s' "review-each" ;;
  esac
}

group_risk() {
  manifest_group_risk "$1" && return 0
  case "$1" in
    universal_rules|execution_harness|scripts|prompts) printf '%s' "low" ;;
    blueprint_project_state|source_docs) printf '%s' "high" ;;
    *) printf '%s' "medium" ;;
  esac
}

set_group_action() {
  local group="$1"
  local action="$2"
  GROUP_ACTIONS="${GROUP_ACTIONS}${group}=${action}
"
}

get_group_action() {
  local group="$1"
  local line
  local found=""
  while IFS= read -r line; do
    case "${line}" in
      "${group}="*) found="${line#*=}" ;;
    esac
  done <<EOF
${GROUP_ACTIONS}
EOF
  if [[ -n "${found}" ]]; then
    printf '%s' "${found}"
    return 0
  fi
  group_default_action "${group}"
}

path_status() {
  local rel="$1"
  local src="${SOURCE_DIR}/${rel}"
  local dst="${PROJECT_DIR}/${rel}"

  if [[ ! -e "${src}" && ! -e "${dst}" ]]; then
    printf '%s' "missing"
  elif [[ ! -e "${src}" && -e "${dst}" ]]; then
    printf '%s' "local-only"
  elif [[ -e "${src}" && ! -e "${dst}" ]]; then
    printf '%s' "add"
  elif [[ -d "${src}" || -d "${dst}" ]]; then
    if [[ -d "${src}" && -d "${dst}" ]] && diff -qr "${src}" "${dst}" >/dev/null 2>&1; then
      printf '%s' "unchanged"
    else
      printf '%s' "update"
    fi
  elif cmp -s "${src}" "${dst}"; then
    printf '%s' "unchanged"
  else
    printf '%s' "update"
  fi
}

count_group_items() {
  local group="$1"
  local count=0
  local i=0
  while [[ ${i} -lt ${#ITEM_GROUPS[@]} ]]; do
    if [[ "${ITEM_GROUPS[$i]}" == "${group}" ]]; then
      count=$((count + 1))
    fi
    i=$((i + 1))
  done
  printf '%s' "${count}"
}

group_has_changes() {
  local group="$1"
  local i=0
  local status
  while [[ ${i} -lt ${#ITEM_GROUPS[@]} ]]; do
    if [[ "${ITEM_GROUPS[$i]}" == "${group}" ]]; then
      status="$(path_status "${ITEM_PATHS[$i]}")"
      if [[ "${status}" != "unchanged" && "${status}" != "missing" ]]; then
        return 0
      fi
    fi
    i=$((i + 1))
  done
  return 1
}

print_plan_summary() {
  local group
  local count
  local selected_action
  printf '%b\n' "${BOLD}Upgrade Plan（アップグレード計画）${RESET}"
  printf '  target project: %s\n' "${PROJECT_DIR}"
  printf '  source: %s\n' "${SOURCE_DIR}"
  printf '  lang: %s\n' "${TARGET_LANG}"
  printf '  agent: %s\n' "${TARGET_AGENT}"
  printf '\n'

  while IFS= read -r group; do
    count="$(count_group_items "${group}")"
    [[ "${count}" == "0" ]] && continue
    selected_action="$(get_group_action "${group}")"
    if group_has_changes "${group}"; then
      printf '  %s: %s files, risk=%s, action=%s\n' "$(group_label "${group}")" "${count}" "$(group_risk "${group}")" "${selected_action}"
    else
      printf '  %s: %s files, no changes\n' "$(group_label "${group}")" "${count}"
    fi
  done <<EOF
$(iter_groups)
EOF
  printf '\n'
}

choose_group_action() {
  local group="$1"
  local default_action
  local choice
  local option_count
  local option_actions=()
  local action
  default_action="$(group_default_action "${group}")"

  printf '\n%b\n' "${BOLD}$(group_label "${group}")${RESET}"
  printf 'risk=%s, default=%s\n' "$(group_risk "${group}")" "${default_action}"

  if [[ "${group}" == "blueprint_project_state" ]]; then
    printf '1) preserve（保持・上書きしない）\n'
    printf '2) show-diff（差分だけ表示）\n'
    printf '選択 [1]: '
    read -r choice || choice=""
    choice="${choice:-1}"
    case "${choice}" in
      2) set_group_action "${group}" "show-diff" ;;
      *) set_group_action "${group}" "preserve" ;;
    esac
    return 0
  fi

  option_count=1
  option_actions[1]="${default_action}"
  printf '1) %s\n' "$(action_label "${default_action}")"
  for action in update-all review-each show-diff skip; do
    [[ "${action}" == "${default_action}" ]] && continue
    option_count=$((option_count + 1))
    option_actions[${option_count}]="${action}"
    printf '%s) %s\n' "${option_count}" "$(action_label "${action}")"
  done
  printf '選択 [1]: '
  read -r choice || choice=""
  choice="${choice:-1}"

  if [[ "${choice}" =~ ^[0-9]+$ && -n "${option_actions[$choice]:-}" ]]; then
    set_group_action "${group}" "${option_actions[$choice]}"
  else
    set_group_action "${group}" "${default_action}"
  fi
}

action_label() {
  case "$1" in
    update-all) printf '%s' "update-all（すべて更新）" ;;
    safe-only) printf '%s' "safe-only（安全なものだけ更新）" ;;
    review-each) printf '%s' "review-each（ファイルごとに確認）" ;;
    preserve) printf '%s' "preserve（保持・上書きしない）" ;;
    show-diff) printf '%s' "show-diff（差分だけ表示）" ;;
    skip) printf '%s' "skip（今回はスキップ）" ;;
    use-axiarch) printf '%s' "use-axiarch（Axiarch最新版で置換）" ;;
    keep-local) printf '%s' "keep-local（ローカル版を維持）" ;;
    merge) printf '%s' "merge（3-way mergeを試す）" ;;
    *) printf '%s' "$1" ;;
  esac
}

collect_interactive_choices() {
  local group
  while IFS= read -r group <&3; do
    [[ "$(count_group_items "${group}")" == "0" ]] && continue
    group_has_changes "${group}" || continue
    choose_group_action "${group}"
  done 3< <(iter_groups)
}

append_log() {
  ACTION_LOG="${ACTION_LOG}$1
"
}

report_local_only_files() {
  local rel="$1"
  local src="${SOURCE_DIR}/${rel}"
  local dst="${PROJECT_DIR}/${rel}"
  local file
  local subpath
  local source_peer
  local found=false

  [[ -d "${src}" && -d "${dst}" ]] || return 0

  while IFS= read -r -d '' file; do
    subpath="${file#${dst}/}"
    source_peer="${src}/${subpath}"
    if [[ ! -e "${source_peer}" ]]; then
      if [[ "${found}" != "true" ]]; then
        print_warn "local-only files remain under ${rel}; review before treating the upgrade as fully clean"
        append_log "STALE-LOCAL ${rel}"
        found=true
      fi
      print_info "local-only: ${rel}/${subpath}"
      append_log "STALE-LOCAL ${rel}/${subpath}"
    fi
  done < <(find "${dst}" -type f -print0)
}

copy_path_has_type_conflict() {
  local rel="$1"
  local src="${SOURCE_DIR}/${rel}"
  local dst="${PROJECT_DIR}/${rel}"

  if [[ -d "${src}" && -e "${dst}" && ! -d "${dst}" ]]; then
    print_warn "type conflict: ${rel} is a directory in source but not in target; review manually"
    append_log "TYPE-CONFLICT source-directory target-non-directory ${rel}"
    return 0
  fi

  if [[ ! -d "${src}" && -d "${dst}" ]]; then
    print_warn "type conflict: ${rel} is a file in source but a directory in target; review manually"
    append_log "TYPE-CONFLICT source-file target-directory ${rel}"
    return 0
  fi

  return 1
}

copy_path() {
  local rel="$1"
  local src="${SOURCE_DIR}/${rel}"
  local dst="${PROJECT_DIR}/${rel}"

  if [[ ! -e "${src}" ]]; then
    print_warn "source missing: ${rel}"
    append_log "WARN source missing ${rel}"
    return 0
  fi

  if copy_path_has_type_conflict "${rel}"; then
    return 0
  fi

  report_local_only_files "${rel}"

  if [[ "${APPLY}" != "true" ]]; then
    print_info "DRY-RUN update: ${rel}"
    append_log "DRY-RUN update ${rel}"
    return 0
  fi

  if [[ -d "${src}" ]]; then
    mkdir -p "${dst}"
    cp -R "${src}/." "${dst}/"
  else
    mkdir -p "$(dirname "${dst}")"
    cp "${src}" "${dst}"
  fi
  print_ok "updated: ${rel}"
  append_log "UPDATE ${rel}"
}

copy_replace_if_local_unchanged() {
  local rel="$1"
  local src="${SOURCE_DIR}/${rel}"
  local dst="${PROJECT_DIR}/${rel}"
  local base="${BASE_SOURCE_DIR}/${rel}"
  local status
  local reason="no-base-diff"

  status="$(path_status "${rel}")"
  if [[ -e "${src}" ]] && copy_path_has_type_conflict "${rel}"; then
    return 0
  fi

  if [[ "${status}" == "add" ]]; then
    copy_path "${rel}"
    return 0
  fi

  if [[ -n "${BASE_SOURCE_DIR}" && ! -e "${base}" ]]; then
    reason="base-missing"
  fi

  if [[ -n "${BASE_SOURCE_DIR}" && -e "${base}" && -e "${dst}" ]]; then
    reason="base-mismatch"
    if [[ -d "${base}" || -d "${dst}" ]]; then
      if [[ -d "${base}" && -d "${dst}" ]] && diff -qr "${base}" "${dst}" >/dev/null 2>&1; then
        copy_path "${rel}"
        return 0
      fi
    elif cmp -s "${base}" "${dst}"; then
      copy_path "${rel}"
      return 0
    fi
  fi

  printf 'REVIEW  %s  replace-if-local-unchanged:%s（ローカル変更の可能性あり）\n' "${rel}" "${reason}"
  append_log "REVIEW replace-if-local-unchanged ${reason} ${rel}"
}

show_diff() {
  local rel="$1"
  local src="${SOURCE_DIR}/${rel}"
  local dst="${PROJECT_DIR}/${rel}"

  printf '\n%b\n' "${BOLD}Diff: ${rel}${RESET}"
  if [[ ! -e "${src}" ]]; then
    print_warn "source missing: ${rel}"
  elif [[ ! -e "${dst}" ]]; then
    print_info "target missing; would add ${rel}"
  else
    diff -ruN "${dst}" "${src}" || true
  fi
}

try_merge_path() {
  local rel="$1"
  local src="${SOURCE_DIR}/${rel}"
  local dst="${PROJECT_DIR}/${rel}"
  local base="${BASE_SOURCE_DIR}/${rel}"
  local tmp
  local rc

  if [[ -z "${BASE_SOURCE_DIR}" || ! -f "${base}" ]]; then
    print_warn "merge unavailable for ${rel}: base source is missing. Use --from, --from-ref, or --base-source."
    append_log "MERGE-SKIP no-base ${rel}"
    return 0
  fi
  if [[ -d "${src}" || -d "${dst}" || ! -f "${src}" || ! -f "${dst}" ]]; then
    print_warn "merge unavailable for ${rel}: only regular files are supported."
    append_log "MERGE-SKIP unsupported ${rel}"
    return 0
  fi

  tmp="$(mktemp)"
  set +e
  git merge-file -p "${dst}" "${base}" "${src}" > "${tmp}"
  rc=$?
  set -e

  if [[ ${rc} -eq 0 ]]; then
    if [[ "${APPLY}" == "true" ]]; then
      cp "${tmp}" "${dst}"
      print_ok "merged: ${rel}"
      append_log "MERGE ${rel}"
    else
      print_info "DRY-RUN clean merge: ${rel}"
      append_log "DRY-RUN merge ${rel}"
    fi
  elif [[ ${rc} -eq 1 ]]; then
    if [[ "${APPLY}" == "true" ]]; then
      mkdir -p "${PROJECT_DIR}/.axiarch/conflicts/$(dirname "${rel}")"
      cp "${tmp}" "${PROJECT_DIR}/.axiarch/conflicts/${rel}"
      print_warn "merge conflict: ${rel} -> .axiarch/conflicts/${rel}"
      append_log "CONFLICT ${rel}"
    else
      print_warn "DRY-RUN merge conflict: ${rel} (no conflict file written)"
      append_log "DRY-RUN conflict ${rel}"
    fi
  else
    print_warn "merge failed: ${rel}"
    append_log "MERGE-FAIL ${rel}"
  fi
  rm -f "${tmp}"
}

review_file_action() {
  local rel="$1"
  local choice

  while true; do
    printf '\n%s\n' "${rel}"
    printf '1) keep-local（ローカル版を維持）\n'
    printf '2) use-axiarch（Axiarch最新版で置換）\n'
    printf '3) merge（3-way mergeを試す）\n'
    printf '4) show-diff（差分を表示）\n'
    printf '5) skip（今回は触らない）\n'
    printf '選択 [1]: '
    read -r choice || choice=""
    choice="${choice:-1}"
    case "${choice}" in
      1) append_log "KEEP ${rel}"; return 0 ;;
      2) copy_path "${rel}"; return 0 ;;
      3) try_merge_path "${rel}"; return 0 ;;
      4) show_diff "${rel}" ;;
      5) append_log "SKIP ${rel}"; return 0 ;;
      *) append_log "KEEP ${rel}"; return 0 ;;
    esac
  done
}

execute_item() {
  local index="$1"
  local group="${ITEM_GROUPS[$index]}"
  local rel="${ITEM_PATHS[$index]}"
  local owner="${ITEM_OWNERS[$index]}"
  local policy="${ITEM_POLICIES[$index]}"
  local status
  local action

  status="$(path_status "${rel}")"
  action="$(get_group_action "${group}")"

  if [[ "${status}" == "unchanged" || "${status}" == "missing" ]]; then
    append_log "UNCHANGED ${rel}"
    return 0
  fi

  if [[ "${policy}" == "preserve" || "${action}" == "preserve" ]]; then
    printf 'SKIP    %s  preserve（保持）\n' "${rel}"
    append_log "PRESERVE ${rel}"
    return 0
  fi
  if [[ "${policy}" == "skip" ]]; then
    if [[ "${INTERACTIVE}" == "true" && ( "${action}" == "show-diff" || "${action}" == "review-each" || "${action}" == "update-all" ) ]]; then
      append_log "SOURCE-ONLY explicit-${action} ${rel}"
    else
      printf 'SKIP    %s  source-only（本体向け）\n' "${rel}"
      append_log "SKIP source-only ${rel}"
      return 0
    fi
  fi

  case "${action}" in
    skip)
      printf 'SKIP    %s\n' "${rel}"
      append_log "SKIP ${rel}"
      ;;
    show-diff)
      show_diff "${rel}"
      append_log "DIFF ${rel}"
      ;;
    safe-only)
      if [[ "${owner}" == "axiarch" && "${policy}" == "replace" ]]; then
        copy_path "${rel}"
      elif [[ "${owner}" == "axiarch" && "${policy}" == "replace-if-local-unchanged" ]]; then
        copy_replace_if_local_unchanged "${rel}"
      elif [[ "${owner}" == "axiarch" && "${policy}" == "optional" && "${rel}" == "axiarch-prompts" && "${WITH_PROMPTS}" == "true" ]]; then
        copy_path "${rel}"
      else
        printf 'REVIEW  %s  safe-only excluded（安全更新対象外）\n' "${rel}"
        append_log "REVIEW safe-only-excluded ${rel}"
      fi
      ;;
    update-all)
      if [[ "${policy}" == "optional" && "${WITH_PROMPTS}" != "true" && "${INTERACTIVE}" != "true" ]]; then
        printf 'SKIP    %s  optional（任意）\n' "${rel}"
        append_log "SKIP optional ${rel}"
      elif [[ "${policy}" == "replace-if-local-unchanged" ]]; then
        copy_replace_if_local_unchanged "${rel}"
      else
        copy_path "${rel}"
      fi
      ;;
    review-each)
      if [[ "${INTERACTIVE}" == "true" ]]; then
        review_file_action "${rel}"
      else
        printf 'REVIEW  %s  owner=%s policy=%s\n' "${rel}" "${owner}" "${policy}"
        append_log "REVIEW ${rel}"
      fi
      ;;
    *)
      printf 'REVIEW  %s  action=%s\n' "${rel}" "${action}"
      append_log "REVIEW ${rel}"
      ;;
  esac
}

set_default_actions() {
  local group
  while IFS= read -r group; do
    if [[ "${SAFE_ONLY}" == "true" ]]; then
      set_group_action "${group}" "safe-only"
    else
      set_group_action "${group}" "$(group_default_action "${group}")"
    fi
  done <<EOF
$(iter_groups)
EOF
}

confirm_apply_if_needed() {
  local answer
  if [[ "${APPLY}" == "true" ]]; then
    if [[ "${YES}" == "true" || "${INTERACTIVE}" == "true" ]]; then
      return 0
    fi
    printf 'Apply selected changes?（選択した変更を反映しますか？） [y/N]: '
    read -r answer || answer=""
    case "${answer}" in
      y|Y|yes|YES) return 0 ;;
      *) APPLY=false; DRY_RUN=true; return 0 ;;
    esac
  fi

  if [[ "${INTERACTIVE}" == "true" ]]; then
    printf 'Apply selected changes now?（選択した変更を今すぐ反映しますか？） [y/N]: '
    read -r answer || answer=""
    case "${answer}" in
      y|Y|yes|YES) APPLY=true; DRY_RUN=false ;;
      *) APPLY=false; DRY_RUN=true ;;
    esac
  fi
}

execute_plan() {
  local i=0
  while [[ ${i} -lt ${#ITEM_PATHS[@]} ]]; do
    execute_item "${i}"
    i=$((i + 1))
  done
}

sha256_file() {
  local path="$1"
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "${path}" | awk '{print $1}'
  else
    shasum -a 256 "${path}" | awk '{print $1}'
  fi
}

json_escape() {
  local value="$1"
  value="${value//\\/\\\\}"
  value="${value//\"/\\\"}"
  value="${value//$'\n'/\\n}"
  value="${value//$'\r'/\\r}"
  value="${value//$'\t'/\\t}"
  printf '%s' "${value}"
}

normalize_axiarch_version_label() {
  local value="${1:-}"
  value="${value#v}"
  printf '%s' "${value}"
}

resolve_upgrade_version_label() {
  local raw=""
  if [[ -n "${SOURCE_AXIARCH_VERSION}" ]]; then
    raw="${SOURCE_AXIARCH_VERSION}"
  elif [[ -n "${TO_VERSION}" ]]; then
    raw="${TO_VERSION}"
  elif [[ "${TO_REF}" =~ (^|/)v?([0-9]+\.[0-9]+\.[0-9]+([-+][A-Za-z0-9._-]+)?)$ ]]; then
    raw="${BASH_REMATCH[2]}"
  else
    raw="${TO_REF:-local-source}"
  fi
  normalize_axiarch_version_label "${raw}"
}

write_upgrade_metadata() {
  local meta_dir="${PROJECT_DIR}/.axiarch"
  local version_label
  local now
  local report_path
  local sha_path
  local rel
  local target
  local version_json
  local source_ref_json
  local agent_json
  local language_json

  [[ "${APPLY}" == "true" ]] || return 0

  mkdir -p "${meta_dir}"
  now="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  version_label="$(resolve_upgrade_version_label)"
  version_json="$(json_escape "${version_label}")"
  source_ref_json="$(json_escape "${TO_REF:-local}")"
  agent_json="$(json_escape "${TARGET_AGENT}")"
  language_json="$(json_escape "${TARGET_LANG}")"
  cat > "${meta_dir}/version.json" <<EOF
{
  "version": "${version_json}",
  "sourceRef": "${source_ref_json}",
  "upgradedAt": "${now}",
  "agent": "${agent_json}",
  "language": "${language_json}"
}
EOF

  report_path="${meta_dir}/upgrade-report.md"
  {
    printf '%s\n\n' '# Axiarch Upgrade Report'
    printf '%s\n' "- Version: \`${version_label}\`"
    printf '%s\n' "- Source: \`${SOURCE_DIR}\`"
    printf '%s\n' "- Agent: \`${TARGET_AGENT}\`"
    printf '%s\n' "- Language: \`${TARGET_LANG}\`"
    printf '%s\n\n' "- Upgraded at: \`${now}\`"
    printf '%s\n\n' '## Actions'
    printf '```text\n%s```\n' "${ACTION_LOG}"
  } > "${report_path}"

  sha_path="${meta_dir}/files.sha256"
  : > "${sha_path}"
  for rel in AXIARCH.md AGENTS.md axiarch-manifest.json axiarch-harness axiarch-scripts axiarch-rules axiarch-prompts; do
    target="${PROJECT_DIR}/${rel}"
    [[ -e "${target}" ]] || continue
    if [[ -d "${target}" ]]; then
      find "${target}" -type f -print0 | while IFS= read -r -d '' file; do
        printf '%s  %s\n' "$(sha256_file "${file}")" "${file#${PROJECT_DIR}/}" >> "${sha_path}"
      done
    else
      printf '%s  %s\n' "$(sha256_file "${target}")" "${rel}" >> "${sha_path}"
    fi
  done

  print_ok "wrote upgrade metadata: .axiarch/version.json"
}

main() {
  parse_args "$@"
  print_header
  resolve_sources
  register_manifest_items
  set_default_actions
  print_plan_summary
  if [[ "${INTERACTIVE}" == "true" ]]; then
    collect_interactive_choices
  fi
  confirm_apply_if_needed
  if [[ "${APPLY}" == "true" ]]; then
    print_info "Applying selected changes."
  else
    print_info "Dry-run mode. No files will be changed."
  fi
  execute_plan
  write_upgrade_metadata
  if [[ "${APPLY}" == "true" && -x "${PROJECT_DIR}/axiarch-scripts/check-axiarch-health.sh" ]]; then
    print_info "Running health check."
    bash "${PROJECT_DIR}/axiarch-scripts/check-axiarch-health.sh" --quiet || {
      print_warn "health check reported issues. Run full output: bash axiarch-scripts/check-axiarch-health.sh"
    }
  fi
}

main "$@"
