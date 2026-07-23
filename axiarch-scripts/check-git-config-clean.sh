#!/usr/bin/env bash
# ----------------------------------------------------------------------------
# .git/config 健全性チェック・自動修復スクリプト
# .git/config Health Check & Auto-Repair Script
# ----------------------------------------------------------------------------
#
# Purpose / 用途:
#   AI agentや開発者がworktreeを利用した後、Gitがprune可能と判定する管理情報と、
#   実在しないlocal branchに対応するステイル設定を検出し、必要に応じて安全に除去する。
#
#   Detect and optionally remove worktree administrative data that Git marks as
#   prunable and branch configuration whose local branch no longer exists.
#
# Why / 理由:
#   stale metadataやbranch configはtoolingの誤認、branch一覧の混乱、誤ったbase選択を起こし得る。
#   `extensions.worktreeConfig`自体はGitの正式機能であり、検出・削除対象にしない。
#
#   Stale metadata and branch config can confuse tooling, branch inventory, and base
#   selection. `extensions.worktreeConfig` is a supported Git feature and is not removed.
#
# Reference / 詳細:
#   axiarch-rules/{ja,en}/universal/engineering/600_git_workflow.md §4
#
# Usage / 使用方法:
#   ./axiarch-scripts/check-git-config-clean.sh             # Detection only (exit 1 if dirty)
#   ./axiarch-scripts/check-git-config-clean.sh --fix       # Detection + auto-repair
#   ./axiarch-scripts/check-git-config-clean.sh --quiet     # CI silent mode (no output if clean)
#   ./axiarch-scripts/check-git-config-clean.sh --full-clean # deprecated alias for --fix; never deletes branches
# ----------------------------------------------------------------------------

set -euo pipefail

# プロジェクトルートに移動 / Move to project root
cd "$(dirname "$0")/.."

FIX_MODE=false
QUIET_MODE=false
FULL_CLEAN=false

for arg in "$@"; do
  case "$arg" in
    --fix)
      FIX_MODE=true
      ;;
    --quiet)
      QUIET_MODE=true
      ;;
    --full-clean)
      FIX_MODE=true
      FULL_CLEAN=true
      ;;
    -h|--help)
      sed -n '2,32p' "$0"
      exit 0
      ;;
    *)
      echo "Unknown option: $arg" >&2
      exit 2
      ;;
  esac
done

DIRTY=false

log() {
  if ! $QUIET_MODE; then
    echo "$@"
  fi
}

# 1. repositoryとworktree状態をGit自身で検証 / Validate repository and worktree state through Git
if ! git rev-parse --git-dir >/dev/null 2>&1; then
  log "❌ ERROR: Git repositoryではありません / not a Git repository"
  exit 2
fi

if git config --local --bool --get extensions.worktreeConfig 2>/dev/null | grep -qx 'true'; then
  log "ℹ️  VALID: extensions.worktreeConfig is enabled; supported Git configuration is preserved"
fi

PRUNABLE_OUTPUT=$(git worktree prune --dry-run --verbose 2>&1 || true)
if [[ -n "$PRUNABLE_OUTPUT" ]]; then
  log "❌ DIRTY: prune可能なworktree管理情報があります / prunable worktree metadata detected"
  if ! $QUIET_MODE; then
    printf '%s\n' "$PRUNABLE_OUTPUT" | sed 's/^/    /'
  fi
  DIRTY=true
  if $FIX_MODE; then
    git worktree prune --verbose
    log "  ✅ FIXED: Git worktree pruneで管理情報を整理しました / pruned through Git"
  fi
fi

# 2. local branchが存在しないbranch configを検出 / Detect config for missing local branches
STALE_BRANCHES=$(git config --local --name-only --get-regexp '^branch\.' 2>/dev/null \
  | while IFS= read -r config_key; do
      branch_and_key=${config_key#branch.}
      branch_name=${branch_and_key%.*}
      if [[ -n "$branch_name" ]] && ! git show-ref --verify --quiet "refs/heads/${branch_name}"; then
        printf '%s\n' "$branch_name"
      fi
    done \
  | sort -u || true)
if [[ -n "$STALE_BRANCHES" ]]; then
  COUNT=$(echo "$STALE_BRANCHES" | wc -l | tr -d ' ')
  log "❌ DIRTY: $COUNT 件のステイルbranch config / stale branch config entries detected"
  if ! $QUIET_MODE; then
    while IFS= read -r stale_branch; do
      printf '    - %s\n' "$stale_branch"
    done <<< "$STALE_BRANCHES"
  fi
  DIRTY=true
  if $FIX_MODE; then
    while IFS= read -r branch_name; do
      git config --local --remove-section "branch.${branch_name}" 2>/dev/null || true
      log "  ✅ FIXED: branch.${branch_name} config を除去 / config section removed"
    done <<< "$STALE_BRANCHES"
  fi
fi

if $FULL_CLEAN; then
  log "ℹ️  --full-clean is deprecated and behaves as --fix; branch references are never deleted"
fi

# 3. 結果出力 / Result output
if ! $DIRTY; then
  log "✅ worktree管理情報とbranch configは整合しています / worktree metadata and branch config are consistent"
  exit 0
fi

if $FIX_MODE; then
  log ""
  log "✅ 検出したステイル管理情報をGitの正規操作で修復しました / repaired detected stale metadata through supported Git operations"
  exit 0
else
  log ""
  log "🔧 修復するには / To repair: $0 --fix"
  log "   --full-clean は互換aliasでありbranchを削除しません / deprecated compatibility alias; never deletes branches"
  exit 1
fi
