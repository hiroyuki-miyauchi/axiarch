# Axiarch Scripts — Diagnostic & Health Check Tools

> Axiarch 採用プロジェクト向けの診断・ヘルスチェックスクリプト集。`init.sh` 経由で全採用プロジェクトに自動配布される。
>
> Diagnostic and health-check scripts for Axiarch-adopting projects. Distributed automatically by `init.sh`.

---

## 📋 配布スクリプト一覧 / Available Scripts

| スクリプト / Script | 目的 / Purpose | 主な使用場面 / When to use |
|:--|:--|:--|
| [`check-axiarch-health.sh`](#check-axiarch-healthsh) | **Axiarch 全プロトコル遵守の健全性診断**（10 段階） / Full-protocol compliance health diagnostic (10-stage) | 「フックが動いていない気がする」「結晶化されていない」と感じた時 / When you suspect protocol violations |
| [`check-git-config-clean.sh`](#check-git-config-cleansh) | `.git/config` 健全性チェック（`worktreeConfig` 残留検出・修復） / `.git/config` integrity check | Antigravity Go-based language server がクラッシュ（`ECONNREFUSED 127.0.0.1:50347`）する時 |

---

## `check-axiarch-health.sh`

### 概要 / Overview

**Axiarch 公式健全性診断ツール**。Hook + LOADING_PROTOCOL + CRYSTALLIZATION_PROTOCOL + AGENTS.md 全 9 プロトコルのうち**外部検証可能な 7 領域**を一発診断する。「どこサボってるか」が一発でわかる設計。

The official Axiarch health diagnostic. One-shot 10-stage check covering hook firing, AI adherence, crystallization threshold, and the verifiable subset of AGENTS.md protocols.

### 使い方 / Usage

```bash
# カレントディレクトリを診断 / Diagnose current directory
bash scripts/check-axiarch-health.sh

# 特定パスを診断 / Diagnose a specific path
bash scripts/check-axiarch-health.sh /path/to/project
```

### 診断項目 / Check Items

| # | カテゴリ / Category | 検証対象 / Target |
|:--|:--|:--|
| 1 | Hook | `.claude/settings.json` 存在 / File presence |
| 2 | Hook | JSON 構文 / Syntax validation |
| 3 | Hook | UserPromptSubmit hook 構造 + AXIARCH BOOT marker / Hook structure + marker |
| 4 | Hook | セッションログ発火履歴 / Firing history (session JSONL grep) |
| 5 | LOADING_PROTOCOL | `task.md` ロード履歴 / Load history adherence |
| 6 | CRYSTALLIZATION_PROTOCOL | `core/010_project_lessons_log.md` の閾値超過ドメイン検出 / 3+ unsorted lessons per domain |
| 7 | AGENTS §8 | `task.md` / `implementation_plan.md` / `walkthrough.md` 存在 / Process documentation presence |
| 8 | AGENTS §1 | force-push / 直 main commit 検出 / Deployment ban hygiene |
| 9 | AGENTS §4 | main 同期状態 / SSOT sync (behind/ahead) |
| 10 | AGENTS §2 | Project Native Language 整合性 / Language-first consistency |

### Out of Scope（外部検証困難・人間レビュー必須） / Manual Review Required

`§0 AI Self-Completion` / `§3 Database Integrity` / `§5 Existing Functionality Protection` / `§6 Anti-Full-Overwrite` / `§7 Role & Behavior` は意味的判断が必要なため自動化対象外。

### Exit Code

- `0` — 全自動チェック通過 / All automated checks passed
- `1` — 1 件以上の violation / At least one violation detected

---

## `check-git-config-clean.sh`

### 概要 / Overview

`.git/config` 内の `[extensions] worktreeConfig = true` 残留を検出・修復する。Antigravity の Go ベース language server クラッシュ（`ECONNREFUSED 127.0.0.1:50347`）の恒久対策。`engineering/600_git_workflow.md` Worktree Hygiene Protocol と連動。

Detects and repairs residual `[extensions] worktreeConfig = true` in `.git/config` to prevent Antigravity Go-based language server crashes. Linked with `engineering/600_git_workflow.md` Worktree Hygiene Protocol.

### 使い方 / Usage

```bash
# 検出のみ（dry-run、デフォルト）/ Detection only (default)
bash scripts/check-git-config-clean.sh

# 自動修復 / Auto-fix
bash scripts/check-git-config-clean.sh --fix

# サイレント実行（CI 用）/ Silent mode (for CI)
bash scripts/check-git-config-clean.sh --quiet

# 全 worktree 含めて完全クリーンアップ / Full cleanup including all worktrees
bash scripts/check-git-config-clean.sh --full-clean
```

### 推奨ワークフロー / Recommended Workflow

- 開発開始時に `--quiet` 実行（pre-commit hook 等に組み込み可能）
- 問題検出時は `--fix` で自動修復
- 並行 AI Agent 運用時は週次で `--full-clean` 実行

---

## 自動配布 / Auto Distribution via `init.sh`

`init.sh` は `cp -R "$SOURCE_DIR/scripts/." "$TARGET_DIR/scripts/"` で全スクリプトを再帰コピーし、`chmod +x` で実行権限を付与する。新規スクリプトを `axiarch/scripts/` に追加すれば、次回 `init.sh` 実行時に採用先へ自動配布される。

`init.sh` recursively copies all scripts via `cp -R` and applies execute permission. New scripts added under `axiarch/scripts/` are auto-distributed on the next `init.sh` run.

---

## 関連ドキュメント / Related Documentation

- [`README.md`](../README.md) — `Enforcement Mechanism` トラブルシュート章
- [`axiarch-rules/{ja,en}/LOADING_PROTOCOL.md`](../axiarch-rules/) — フック診断手順
- [`axiarch-rules/{ja,en}/CRYSTALLIZATION_PROTOCOL.md`](../axiarch-rules/) — 結晶化遵守の §5 強化
- [`axiarch-rules/{ja,en}/universal/engineering/600_git_workflow.md`](../axiarch-rules/) — Worktree Hygiene Protocol
- [Claude Code Hooks (公式 / official)](https://code.claude.com/docs/en/hooks)
