#!/usr/bin/env bash
# ----------------------------------------------------------------------------
# .git/config 健全性チェック・自動修復スクリプト
# .git/config Health Check & Auto-Repair Script
# ----------------------------------------------------------------------------
#
# Purpose / 用途:
#   AI agent (Claude Code, Cursor, etc.) や開発者が `git worktree add` を実行した後、
#   `.git/config` に残留する `[extensions] worktreeConfig = true` および
#   `[branch "claude/..."]` 等のステイルエントリを検出し、必要に応じて自動除去する。
#
#   Detect and optionally remove `[extensions] worktreeConfig = true` and stale
#   `[branch "claude/..."]` entries left in `.git/config` after worktree operations.
#
# Why / 理由:
#   残留エントリは Antigravity 等の Go ベース language server をクラッシュさせ、
#   該当プロジェクトのチャット機能を完全停止させる。
#
#   Residual entries crash Go-based language servers (e.g., Antigravity), causing
#   complete chat function failure for the affected project.
#
# Reference / 詳細:
#   axiarch-rules/{ja,en}/universal/engineering/600_git_workflow.md §4
#
# Usage / 使用方法:
#   ./axiarch-scripts/check-git-config-clean.sh             # Detection only (exit 1 if dirty)
#   ./axiarch-scripts/check-git-config-clean.sh --fix       # Detection + auto-repair
#   ./axiarch-scripts/check-git-config-clean.sh --quiet     # CI silent mode (no output if clean)
#   ./axiarch-scripts/check-git-config-clean.sh --full-clean # --fix + delete stale claude/* branches
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

# 1. extensions.worktreeConfig 残留チェック / Check for residual extensions.worktreeConfig
if git config --get extensions.worktreeConfig >/dev/null 2>&1; then
  log "❌ DIRTY: [extensions] worktreeConfig = true が残留しています / residual entry detected"
  DIRTY=true
  if $FIX_MODE; then
    git config --unset extensions.worktreeConfig
    log "  ✅ FIXED: extensions.worktreeConfig を除去しました / removed"
  fi
fi

# 2. ステイル claude/* ブランチ config エントリ検出 / Detect stale claude/* branch config
# 現在チェックアウト中のブランチは除外 / Exclude currently checked-out branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "HEAD")
STALE_BRANCHES=$(git config --list 2>/dev/null \
  | grep -oE "branch\.claude/[^.]+" \
  | sort -u \
  | awk -v cur="branch.${CURRENT_BRANCH}" '$0 != cur' || true)
if [[ -n "$STALE_BRANCHES" ]]; then
  COUNT=$(echo "$STALE_BRANCHES" | wc -l | tr -d ' ')
  log "❌ DIRTY: $COUNT 件のステイル claude/* ブランチ config / stale entries detected"
  if ! $QUIET_MODE; then
    echo "$STALE_BRANCHES" | sed 's/^/    - /'
  fi
  DIRTY=true
  if $FIX_MODE; then
    while IFS= read -r entry; do
      branch_name="${entry#branch.}"
      git config --unset "branch.${branch_name}.vscode-merge-base" 2>/dev/null || true
      git config --unset "branch.${branch_name}.remote" 2>/dev/null || true
      git config --unset "branch.${branch_name}.merge" 2>/dev/null || true
      log "  ✅ FIXED: branch.${branch_name}.* config を除去 / config entries removed"

      if $FULL_CLEAN; then
        if git branch -D "$branch_name" 2>/dev/null; then
          log "  ✅ FIXED: ブランチ $branch_name を削除 / branch deleted"
        fi
      fi
    done <<< "$STALE_BRANCHES"
  fi
fi

# 3. 結果出力 / Result output
if ! $DIRTY; then
  log "✅ .git/config はクリーン状態です / .git/config is clean"
  exit 0
fi

if $FIX_MODE; then
  log ""
  log "✅ 全ての残留エントリを修復しました / All residual entries repaired"
  log "   Antigravity を再起動して動作確認してください / Restart Antigravity to verify"
  exit 0
else
  log ""
  log "🔧 修復するには / To repair: $0 --fix"
  log "   完全クリーン (ブランチ削除含む) / Full clean (incl. branch removal): $0 --full-clean"
  exit 1
fi
