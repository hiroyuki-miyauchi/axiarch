# Axiarch Scripts — Diagnostic & Health Check Tools

> Axiarch 採用プロジェクト向けの診断・ヘルスチェックスクリプト集。`init.sh` 経由で全採用プロジェクトに自動配布される。
>
> Diagnostic and health-check scripts for Axiarch-adopting projects. Distributed automatically by `init.sh`.

---

## 📋 配布スクリプト一覧 / Available Scripts

| スクリプト / Script | 目的 / Purpose | 主な使用場面 / When to use |
|:--|:--|:--|
| [`check-axiarch-health.sh`](#check-axiarch-healthsh) | **Axiarch 全プロトコル遵守の健全性診断**（12 段階） / Full-protocol compliance health diagnostic (12-stage) | 「フックが動いていない気がする」「結晶化されていない」と感じた時 / When you suspect protocol violations |
| [`axiarch-boot-reminder.sh`](#axiarch-boot-remindersh) | **UserPromptSubmit hook の外出しスクリプト**。毎ターン違反検出して reminder に 🚨 フラグを追記 / Externalized hook script; appends violation flags to the reminder each turn | `init.sh` 経由で `.claude/settings.json` に自動配線される / Auto-wired by `init.sh` |
| [`axiarch-protect-antifull.sh`](#axiarch-protect-antifullsh) | **PreToolUse hook の外出しスクリプト**。`Write` tool の既存ファイル上書きを物理遮断（§6 ANTI-FULL-OVERWRITE）/ Externalized PreToolUse hook; physically blocks `Write` tool calls targeting existing files | `init.sh` 経由で `.claude/settings.json` に自動配線される / Auto-wired by `init.sh` |
| [`axiarch-init-task-md.sh`](#axiarch-init-task-mdsh) | **SessionStart hook の外出しスクリプト**。会話開始時に task.md を自動ブートストラップ / Externalized SessionStart hook; auto-bootstraps task.md on session start | `init.sh` 経由で `.claude/settings.json` に自動配線される / Auto-wired by `init.sh` |
| [`check-git-config-clean.sh`](#check-git-config-cleansh) | `.git/config` 健全性チェック（`worktreeConfig` 残留検出・修復） / `.git/config` integrity check | Antigravity Go-based language server がクラッシュ（`ECONNREFUSED 127.0.0.1:50347`）する時 |

---

## `check-axiarch-health.sh`

### 概要 / Overview

**Axiarch 公式健全性診断ツール**。Hook + LOADING_PROTOCOL + CRYSTALLIZATION_PROTOCOL + AGENTS.md 全 9 プロトコルのうち**外部検証可能な 8 領域**を一発診断する（v1.5.5 で §6 ANTI-FULL-OVERWRITE が物理遮断対象に追加）。「どこサボってるか」が一発でわかる設計。

The official Axiarch health diagnostic. One-shot 12-stage check covering hook firing, AI adherence, crystallization threshold, the verifiable subset of AGENTS.md protocols, and the v1.5.5 physical-block / bootstrap hooks.

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
| 11 | AGENTS §6 | PreToolUse hook 配線確認（物理遮断） / PreToolUse hook wiring (physical block) — **v1.5.5+** |
| 12 | Bootstrap | SessionStart hook 配線確認 / SessionStart hook wiring — **v1.5.5+** |

### Out of Scope（外部検証困難・人間レビュー必須） / Manual Review Required

`§0 AI Self-Completion` / `§3 Database Integrity` / `§5 Existing Functionality Protection` / `§7 Role & Behavior` は意味的判断が必要なため自動化対象外。
**v1.5.5 で `§6 Anti-Full-Overwrite` は PreToolUse hook の物理遮断（Check 11）で構造的に防止可能になった**。

### Exit Code

- `0` — 全自動チェック通過 / All automated checks passed
- `1` — 1 件以上の violation / At least one violation detected

---

## `axiarch-boot-reminder.sh`

### 概要 / Overview

`.claude/settings.json` の `UserPromptSubmit` hook から呼ばれる外出しスクリプト。毎ターン以下を動的検出し、違反時は reminder に **🚨 フラグ**を追記する：

- **Check A**: `task.md` にロード履歴（AGENTS.md / INDEX.md / LOADING_PROTOCOL.md）が未記録
- **Check B**: `core/010_project_lessons_log.md` で 3 件以上溜まったドメイン（CRYSTALLIZATION §5 違反）

JSON 出力は pure bash（`jq` 依存なし）。物理 block ではなく **警告強化** で副作用最小化。

### 使い方 / Usage

直接実行する用途は通常なし（hook 経由で自動呼出）。デバッグ時のみ：

```bash
bash scripts/axiarch-boot-reminder.sh | jq .
# → hookSpecificOutput.additionalContext に reminder + 違反フラグ
```

### 仕組み / Mechanism

1. `CLAUDE_PROJECT_DIR` または相対パスからプロジェクトルートを解決
2. 静的 base reminder（バイリンガル）を組み立て
3. Check A / B を実行
4. 違反検出時は base reminder に flag を追記
5. JSON 形式で `printf` 出力

---

## `axiarch-protect-antifull.sh`

### 概要 / Overview

`.claude/settings.json` の `PreToolUse` hook（`Write` matcher）から呼ばれる外出しスクリプト。`Write` tool 呼び出しを傍受し、対象ファイルが既存の場合は `decision:"block"` JSON + exit code 2 で**物理遮断**する。AGENTS.md §6 ANTI-FULL-OVERWRITE 違反を構造的に防止。

Externalized PreToolUse hook script invoked from `.claude/settings.json`. Intercepts `Write` tool calls and physically blocks (decision:"block" JSON + exit 2) when the target file exists. Structurally prevents AGENTS.md §6 ANTI-FULL-OVERWRITE violations.

### Whitelist サポート / Whitelist Support

`.claude/axiarch-overwrite-allow.txt` で 1 行 1 path/glob 形式で whitelist を定義可能（自動生成 build artefact 等の正当な full-overwrite 用 escape hatch）。コメント (`#`) と空行はスキップ。

`.claude/axiarch-overwrite-allow.txt` supports one-path-per-line glob whitelist (escape hatch for legitimate full-overwrite cases like autogenerated artefacts). Comments (`#`) and empty lines are skipped.

### 使い方 / Usage

直接実行する用途は通常なし（hook 経由で自動呼出）。デバッグ時のみ：

```bash
echo '{"tool_name":"Write","tool_input":{"file_path":"/existing/file.md"}}' \
  | bash scripts/axiarch-protect-antifull.sh
# → JSON `{"decision":"block",...}` + stderr message + exit 2
```

### 学術裏付け / Academic Backing

- arXiv:2503.18666 — AgentSpec: Customizable Runtime Enforcement for AI Agents (ICSE'26) で 90%+ 阻止実証
- arXiv:2502.15851 — Control Illusion: reminder-only enforcement の構造的限界

---

## `axiarch-init-task-md.sh`

### 概要 / Overview

`.claude/settings.json` の `SessionStart` hook から呼ばれる外出しスクリプト。会話開始時に project root の `task.md` 存在を確認し、**不在時は load-history table を含む scaffold で自動生成**する。常に AGENTS.md §8 (Documentation Requirements) の reminder を `additionalContext` で AI に注入。

Externalized SessionStart hook script invoked from `.claude/settings.json`. On session start, checks for `task.md` in the project root and **auto-bootstraps it with a load-history table scaffold when missing**. Always injects an AGENTS.md §8 (Documentation Requirements) reminder via `additionalContext`.

### 使い方 / Usage

直接実行する用途は通常なし（hook 経由で自動呼出）。デバッグ時のみ：

```bash
bash scripts/axiarch-init-task-md.sh | jq .
# → hookSpecificOutput.additionalContext に reminder + (必要なら scaffold note)
```

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
