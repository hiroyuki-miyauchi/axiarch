# Axiarch Scripts — Diagnostic & Health Check Tools

> Axiarch 採用プロジェクト向けの診断・ヘルスチェックスクリプト集。`init.sh` 経由で全採用プロジェクトに自動配布される。
>
> Diagnostic and health-check scripts for Axiarch-adopting projects. Distributed automatically by `init.sh`.

---

## 📋 配布スクリプト一覧 / Available Scripts

| スクリプト / Script | 目的 / Purpose | 主な使用場面 / When to use |
|:--|:--|:--|
| [`check-axiarch-health.sh`](#check-axiarch-healthsh) | **Axiarch 全プロトコル遵守の健全性診断**（15 段階、`--quiet` 対応 v1.9.0-dev） / Full-protocol compliance health diagnostic (15-stage, `--quiet` support v1.9.0-dev) | 「フックが動いていない気がする」「結晶化されていない」「タスク切替で再 load 漏れ」と感じた時 / When you suspect protocol violations or task-boundary misses |
| [`axiarch-boot-reminder.sh`](#axiarch-boot-remindersh) | **UserPromptSubmit hook の外出しスクリプト**（v1.6.0+ TTL 二段階出力 + v1.8.0+ Check D Task Boundary Detection）。毎ターン違反検出 (A/B/C/D) + TTL 内 + 違反なしなら短縮版 / Externalized hook script (v1.6.0+ two-stage TTL + v1.8.0+ Check D task-boundary); dynamic violations A/B/C/D, short-circuits within TTL when no violation | `init.sh` 経由で `.claude/settings.json` や `.codex/hooks.json` に自動配線される / Auto-wired by `init.sh` |
| [`axiarch-protect-antifull.sh`](#axiarch-protect-antifullsh) | **PreToolUse hook の外出しスクリプト**。`Write` tool の既存ファイル上書きを物理遮断（§6 ANTI-FULL-OVERWRITE）/ Externalized PreToolUse hook; physically blocks `Write` tool calls targeting existing files | `init.sh` 経由で `.claude/settings.json` や `.codex/hooks.json` に自動配線される / Auto-wired by `init.sh` |
| [`axiarch-diff-guard.sh`](#axiarch-diff-guardsh) | **PostToolUse hook の外出しスクリプト**。Edit / MultiEdit / Write 後のgit diff規模を測定し、閾値超過時に warn / block / Externalized PostToolUse hook; measures git diff size after Edit / MultiEdit / Write and warns or blocks above thresholds | `init.sh` 経由で `.claude/settings.json` や `.codex/hooks.json` に自動配線される / Auto-wired by `init.sh` |
| [`axiarch-init-task-md.sh`](#axiarch-init-task-mdsh) | **SessionStart hook の外出しスクリプト**。会話開始時に task.md を自動ブートストラップ / Externalized SessionStart hook; auto-bootstraps task.md on session start | `init.sh` 経由で `.claude/settings.json` や `.codex/hooks.json` に自動配線される / Auto-wired by `init.sh` |
| [`check-git-config-clean.sh`](#check-git-config-cleansh) | `.git/config` 健全性チェック（`worktreeConfig` 残留検出・修復） / `.git/config` integrity check | Antigravity Go-based language server がクラッシュ（`ECONNREFUSED 127.0.0.1:50347`）する時 |

---

## `check-axiarch-health.sh`

### 概要 / Overview

**Axiarch 公式健全性診断ツール**。Hook + LOADING_PROTOCOL + CRYSTALLIZATION_PROTOCOL + AGENTS.md 全 9 プロトコルのうち**外部検証可能な 10 領域以上**を一発診断する（v1.5.5 で §6 ANTI-FULL-OVERWRITE が物理遮断対象に追加、v1.6.0 で sublimated files index 追加、v1.8.0 で Check D Task Boundary Detection 追加、v1.9.0-dev で PostToolUse diff guard 初期実装を追加）。「どこサボってるか」が一発でわかる設計。

The official Axiarch health diagnostic. One-shot 15-stage check covering hook firing, AI adherence, crystallization threshold (count + time-axis), the verifiable subset of AGENTS.md protocols, the v1.5.5 physical-block / bootstrap hooks, the v1.6.0 sublimated-files index, the v1.8.0 task-boundary detection wiring, and the v1.9.0-dev PostToolUse diff guard. `--quiet` flag for pre-commit usage.

### 使い方 / Usage

```bash
# カレントディレクトリを診断 / Diagnose current directory
bash axiarch-scripts/check-axiarch-health.sh

# 特定パスを診断 / Diagnose a specific path
bash axiarch-scripts/check-axiarch-health.sh /path/to/project
```

### 診断項目 / Check Items

| # | カテゴリ / Category | 検証対象 / Target |
|:--|:--|:--|
| 1 | Hook | `.claude/settings.json` または `.codex/hooks.json` 存在 / File presence |
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
| 13 | Sublimated Index | 既存の `blueprint/{domain}/{NNN}_*.md` を一覧表示し APPEND を促進 / Lists existing sublimated files to promote APPEND — **v1.6.0+** |
| 14 | Task Boundary | Check D wiring 確認（`axiarch-boot-reminder.sh` に VIOLATION-D + AXIARCH_TASK_BOUNDARY_DETECT 含有を確認） / Verifies Check D wiring in `axiarch-boot-reminder.sh` — **v1.8.0+** |
| 15 | v1.9 Integration | PostToolUse diff guard 配線確認（`axiarch-diff-guard.sh` + Edit / MultiEdit / Write matcher）+ Axiarch本体リポジトリでのみREADME系反映確認 / Verifies PostToolUse diff guard wiring, plus README integration only in the Axiarch source repository — **v1.9.0-dev** |

### 環境変数 / Environment Variables（v1.6.0+, extended in v1.8.0+）

| 変数 / Variable | デフォルト / Default | 説明 / Description |
|:--|:--:|:--|
| `AXIARCH_REMINDER_TTL_SECONDS` | `1800` (30 分) | `axiarch-boot-reminder.sh` の short-circuit TTL。`0` で disable / Two-stage reminder TTL; `0` disables short-circuit |
| `AXIARCH_LESSON_STALE_DAYS` | `180` | Check 6 (b) / Check C の time-axis trigger 閾値（日数）。`0` で disable / Time-axis trigger threshold; `0` disables Check C |
| `AXIARCH_PRECOMMIT_SKIP` | unset | `1` をセットすると pre-commit hook を 1 回だけ bypass / Set to `1` to bypass the pre-commit hook for one commit |
| **`AXIARCH_TASK_BOUNDARY_DETECT`** | **`1`** | **v1.8.0+: `0` で Check D Task Boundary Detection を完全 disable（v1.6.0 動作再現）/ Set to `0` to fully disable Check D task-boundary detection (reproduces v1.6.0 behaviour)** |
| **`AXIARCH_TASK_DOMAIN_KEYWORDS`** | (組込 default 集合) | **v1.8.0+: Check D の domain keyword 集合をオーバーライド（pipe-separated regex, 採用先カスタマイズ用）/ Override Check D's domain keyword set (pipe-separated regex; for adopter customisation)** |
| `AXIARCH_DIFF_GUARD_MODE` | `warn` | v1.9.0-dev: diff guard の動作。`warn` / `block` / `off` / Diff guard mode |
| `AXIARCH_DIFF_GUARD_MAX_LINES` | `400` | v1.9.0-dev: 追加+削除行数の閾値 / Added plus deleted line threshold |
| `AXIARCH_DIFF_GUARD_MAX_FILES` | `20` | v1.9.0-dev: 変更ファイル数の閾値 / Changed file threshold |
| `AXIARCH_DIFF_GUARD_INCLUDE_UNTRACKED` | `1` | v1.9.0-dev: untracked files を閾値計算に含める / Include untracked files in threshold calculation |
| `AXIARCH_DIFF_GUARD_ALLOW` | unset | v1.9.0-dev: `1` で一時的にdiff guardをbypass / Set to `1` to bypass diff guard for one run |

### Out of Scope（外部検証困難・人間レビュー必須） / Manual Review Required

`§0 AI Self-Completion` / `§3 Database Integrity` / `§5 Existing Functionality Protection` / `§7 Role & Behavior` は意味的判断が必要なため自動化対象外。
**v1.5.5 で `§6 Anti-Full-Overwrite` は PreToolUse hook の物理遮断（Check 11）により、既存ファイルへの `Write` 上書きリスクを構造的に下げられるようになった**。

### Exit Code

- `0` — ブロッキング失敗なし。警告が出た場合は人間レビュー対象 / No blocking automated failures. Review any warnings manually
- `1` — 1 件以上の violation / At least one violation detected

---

## `axiarch-boot-reminder.sh`

### 概要 / Overview

`.claude/settings.json` または `.codex/hooks.json` の `UserPromptSubmit` hook から呼ばれる外出しスクリプト。毎ターン以下を動的検出し、違反時は reminder に **🚨 フラグ**を追記する：

- **Check A**: `task.md` にロード履歴（AGENTS.md / INDEX.md / LOADING_PROTOCOL.md）が未記録
- **Check B**: `core/010_project_lessons_log.md` で 3 件以上溜まったドメイン（CRYSTALLIZATION §5 違反）

JSON 出力は pure bash（`jq` 依存なし）。物理 block ではなく **警告強化** で副作用最小化。

### 使い方 / Usage

直接実行する用途は通常なし（hook 経由で自動呼出）。デバッグ時のみ：

```bash
bash axiarch-scripts/axiarch-boot-reminder.sh | jq .
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

`.claude/settings.json` または `.codex/hooks.json` の `PreToolUse` hook（`Write` matcher）から呼ばれる外出しスクリプト。`Write` tool 呼び出しを傍受し、対象ファイルが既存の場合は `decision:"block"` JSON + exit code 2 で**物理遮断**する。AGENTS.md §6 ANTI-FULL-OVERWRITE 違反のうち、既存ファイルへの `Write` 全文上書きパターンを構造的に抑止する。

Externalized PreToolUse hook script invoked from `.claude/settings.json` or `.codex/hooks.json`. Intercepts `Write` tool calls and physically blocks (decision:"block" JSON + exit 2) when the target file exists. This structurally reduces the known AGENTS.md §6 ANTI-FULL-OVERWRITE risk pattern of using `Write` to overwrite existing files.

### Whitelist サポート / Whitelist Support

`.claude/axiarch-overwrite-allow.txt` または `.codex/axiarch-overwrite-allow.txt` で 1 行 1 path/glob 形式で whitelist を定義可能（自動生成 build artefact 等の正当な full-overwrite 用 escape hatch）。コメント (`#`) と空行はスキップ。

`.claude/axiarch-overwrite-allow.txt` or `.codex/axiarch-overwrite-allow.txt` supports one-path-per-line glob whitelist (escape hatch for legitimate full-overwrite cases like autogenerated artefacts). Comments (`#`) and empty lines are skipped.

### 使い方 / Usage

直接実行する用途は通常なし（hook 経由で自動呼出）。デバッグ時のみ：

```bash
echo '{"tool_name":"Write","tool_input":{"file_path":"/existing/file.md"}}' \
  | bash axiarch-scripts/axiarch-protect-antifull.sh
# → JSON `{"decision":"block",...}` + stderr message + exit 2
```

### 学術裏付け / Academic Backing

- arXiv:2503.18666 — AgentSpec: Customizable Runtime Enforcement for AI Agents (ICSE'26) で 90%+ 阻止実証
- arXiv:2502.15851 — Control Illusion: reminder-only enforcement の構造的限界

---

## `axiarch-diff-guard.sh`

### 概要 / Overview

`.claude/settings.json` または `.codex/hooks.json` の `PostToolUse` hook から呼ばれる外出しスクリプト。`Edit` / `MultiEdit` / `Write` 後に `git diff HEAD --numstat` と untracked files を測定し、変更行数または変更ファイル数が閾値を超えた場合に警告または block を返す。PreToolUse の Write遮断では拾いにくい「差分編集だが範囲が大きすぎる」ケースを検出しやすくする。

Externalized PostToolUse hook script invoked from `.claude/settings.json` or `.codex/hooks.json`. After `Edit`, `MultiEdit`, or `Write`, it measures `git diff HEAD --numstat` plus untracked files and warns or blocks when line/file thresholds are exceeded. This complements the Write-only PreToolUse guard by surfacing overly broad diff-based edits.

### 使い方 / Usage

通常はhook経由で自動実行される。単体確認では閾値を低くして実行する。

```bash
AXIARCH_DIFF_GUARD_MAX_LINES=1 \
AXIARCH_DIFF_GUARD_MAX_FILES=1 \
bash axiarch-scripts/axiarch-diff-guard.sh
```

### 環境変数 / Environment Variables

| 変数 / Variable | デフォルト / Default | 説明 / Description |
|:--|:--:|:--|
| `AXIARCH_DIFF_GUARD_MODE` | `warn` | `warn`、`block`、`off` を選択 / Select warn, block, or off |
| `AXIARCH_DIFF_GUARD_MAX_LINES` | `400` | 追加+削除行数の閾値 / Added plus deleted line threshold |
| `AXIARCH_DIFF_GUARD_MAX_FILES` | `20` | 変更ファイル数の閾値 / Changed file threshold |
| `AXIARCH_DIFF_GUARD_INCLUDE_UNTRACKED` | `1` | untracked files を含める / Include untracked files |
| `AXIARCH_DIFF_GUARD_ALLOW` | unset | `1` で一回だけbypass / Set to `1` to bypass once |

---

## `axiarch-init-task-md.sh`

### 概要 / Overview

`.claude/settings.json` または `.codex/hooks.json` の `SessionStart` hook から呼ばれる外出しスクリプト。会話開始時に project root の `task.md` 存在を確認し、**不在時は load-history table を含む scaffold で自動生成**する。常に AGENTS.md §8 (Documentation Requirements) の reminder を `additionalContext` で AI に注入。

Externalized SessionStart hook script invoked from `.claude/settings.json` or `.codex/hooks.json`. On session start, checks for `task.md` in the project root and **auto-bootstraps it with a load-history table scaffold when missing**. Always injects an AGENTS.md §8 (Documentation Requirements) reminder via `additionalContext`.

### 使い方 / Usage

直接実行する用途は通常なし（hook 経由で自動呼出）。デバッグ時のみ：

```bash
bash axiarch-scripts/axiarch-init-task-md.sh | jq .
# → hookSpecificOutput.additionalContext に reminder + (必要なら scaffold note)
```

---

## `check-git-config-clean.sh`

### 概要 / Overview

`.git/config` 内の `[extensions] worktreeConfig = true` 残留を検出・修復する。Antigravity の Go ベース language server クラッシュ（`ECONNREFUSED 127.0.0.1:50347`）の再発リスク低減策。`engineering/600_git_workflow.md` Worktree Hygiene Protocol と連動。

Detects and repairs residual `[extensions] worktreeConfig = true` in `.git/config` to reduce the risk of Antigravity Go-based language server crashes. Linked with `engineering/600_git_workflow.md` Worktree Hygiene Protocol.

### 使い方 / Usage

```bash
# 検出のみ（dry-run、デフォルト）/ Detection only (default)
bash axiarch-scripts/check-git-config-clean.sh

# 自動修復 / Auto-fix
bash axiarch-scripts/check-git-config-clean.sh --fix

# サイレント実行（CI 用）/ Silent mode (for CI)
bash axiarch-scripts/check-git-config-clean.sh --quiet

# 全 worktree 含めて完全クリーンアップ / Full cleanup including all worktrees
bash axiarch-scripts/check-git-config-clean.sh --full-clean
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

- [`README.md`](../README.md) — `Hook Reinforcement Mechanism` トラブルシュート章
- [`axiarch-rules/{ja,en}/LOADING_PROTOCOL.md`](../axiarch-rules/) — フック診断手順
- [`axiarch-rules/{ja,en}/CRYSTALLIZATION_PROTOCOL.md`](../axiarch-rules/) — 結晶化遵守の §5 強化
- [`axiarch-rules/{ja,en}/universal/engineering/600_git_workflow.md`](../axiarch-rules/) — Worktree Hygiene Protocol
- [Claude Code Hooks (公式 / official)](https://code.claude.com/docs/en/hooks)
