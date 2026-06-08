# Axiarch Scripts — Diagnostic & Health Check Tools

> Axiarch 採用プロジェクト向けの診断・ヘルスチェックスクリプト集。`init.sh` 経由で全採用プロジェクトに自動配布される。
>
> Diagnostic and health-check scripts for Axiarch-adopting projects. Distributed automatically by `init.sh`.
>
> `axiarch-scripts/` は最小構成の必須ファイルではありません。`init.sh` は診断・hook補強・安全アップグレードをすぐ使える推奨ツールとして同梱コピーしますが、`AXIARCH.md`、`AGENTS.md` adapter、`axiarch-rules/`、`axiarch-harness/` の最小運用では任意です。
>
> `axiarch-scripts/` is not required for the minimal Axiarch setup. `init.sh` copies it as recommended tooling for diagnostics, hook reinforcement, and safe upgrades, but it remains optional when a project only needs the minimal `AXIARCH.md`, `AGENTS.md` adapter, `axiarch-rules/`, and `axiarch-harness/` setup.
>
> v1.12.0以降の本体リポジトリ診断では、ハーネスエンジニアリングの説明が正本、公開入口、rules索引、harness README、AI向け要約に残っているかも確認します。
>
> In v1.12.0 and later, source-repository diagnostics also check that Harness Engineering remains explicit across the canonical protocol, public entrypoints, rules indexes, harness README, and AI-facing summaries.

---

## 📋 配布スクリプト一覧 / Available Scripts

| スクリプト / Script | 目的 / Purpose | 主な使用場面 / When to use |
|:--|:--|:--|
| [`check-axiarch-health.sh`](#check-axiarch-healthsh) | **Axiarch 全プロトコル遵守の健全性診断**（16 段階、`--quiet` 対応、v1.11.0で現在タスク文書ローテーション、ネイティブタスク状態同期、v1.10.0+由来のリリース整合、Blueprint INDEX版数、safe upgrade実行promptのREADME/llms/rules索引、source-only既定skipとinteractive明示override、対話選択肢重複排除、本体リポジトリ専用ファイル分類、README/llms/scripts READMEの必須/任意境界、ハーネスエンジニアリング入口保持、ja/en番号見出しparity、Claude Memory正本境界、AXIARCH.md・axiarch-harness・中核ファイルのGit追跡状態、AXIARCH.md mixed/review所有境界、fallback core Blueprint検出、任意prompt証跡、`replace-if-local-unchanged` 実行時保護、型不一致review検査を追加） / Full-protocol compliance health diagnostic (16-stage, `--quiet` support; v1.11.0 adds current-task document rotation, native state sync, v1.10.0+ release parity, Blueprint INDEX version metadata, safe-upgrade execution prompt indexing across README, llms, and rules indexes, source-only default skip with explicit interactive override, deduplicated interactive choices, source-repository-only file classification, required/optional boundary checks for README, llms, and scripts README, Harness Engineering entrypoint retention, ja/en numbered-heading parity, Claude Memory canonical boundary, source release-file Git tracking for AXIARCH.md, axiarch-harness, and core files, AXIARCH.md mixed/review ownership boundary, fallback core Blueprint discovery, optional prompt evidence checks, `replace-if-local-unchanged` runtime protection, and type-conflict review checks) | 「フックが動いていない気がする」「結晶化されていない」「タスク切替で再 load 漏れ」と感じた時 / When you suspect protocol violations or task-boundary misses |
| [`axiarch-boot-reminder.sh`](#axiarch-boot-remindersh) | **UserPromptSubmit hook の外出しスクリプト**（v1.6.0+ TTL 二段階出力 + v1.8.0+ Check D Task Boundary Detection）。毎ターン違反検出 (A/B/C/D) + TTL 内 + 違反なしなら短縮版 / Externalized hook script (v1.6.0+ two-stage TTL + v1.8.0+ Check D task-boundary); dynamic violations A/B/C/D, short-circuits within TTL when no violation | `init.sh` 経由で `.claude/settings.json` や `.codex/hooks.json` に自動配線される / Auto-wired by `init.sh` |
| [`axiarch-protect-antifull.sh`](#axiarch-protect-antifullsh) | **PreToolUse hook の外出しスクリプト**。`Write` tool の既存ファイル上書きを物理遮断（§6 ANTI-FULL-OVERWRITE）/ Externalized PreToolUse hook; physically blocks `Write` tool calls targeting existing files | `init.sh` 経由で `.claude/settings.json` や `.codex/hooks.json` に自動配線される / Auto-wired by `init.sh` |
| [`axiarch-diff-guard.sh`](#axiarch-diff-guardsh) | **PostToolUse hook の外出しスクリプト**。Edit / MultiEdit / Write 後のgit diff規模を測定し、閾値超過時に warn / block / Externalized PostToolUse hook; measures git diff size after Edit / MultiEdit / Write and warns or blocks above thresholds | `init.sh` 経由で `.claude/settings.json` や `.codex/hooks.json` に自動配線される / Auto-wired by `init.sh` |
| [`axiarch-init-task-md.sh`](#axiarch-init-task-mdsh) | **SessionStart hook の外出しスクリプト**。会話開始時に3つの現在タスク文書を自動ブートストラップ / Externalized SessionStart hook; auto-bootstraps the three current-task docs on session start | `init.sh` 経由で `.claude/settings.json` や `.codex/hooks.json` に自動配線される / Auto-wired by `init.sh` |
| [`axiarch-task-state.sh`](#axiarch-task-statesh) | **現在タスク文書ライフサイクル補助**。`task.md` / `implementation_plan.md` / `walkthrough.md` をarchive-before-refreshで更新 / Current-task document lifecycle helper; archive-before-refresh for `task.md` / `implementation_plan.md` / `walkthrough.md` | `axiarch-init-task-md.sh` から呼び出し / Called by `axiarch-init-task-md.sh` |
| [`axiarch-upgrade.sh`](#axiarch-upgradesh) | **Safe Upgrade Wizard**。`axiarch-manifest.json` に基づき、Axiarch本体・プロジェクト固有Blueprint・任意ファイルをグループ単位で更新判断 / Manifest-based safe upgrade wizard; groups Axiarch-owned files, project Blueprint state, and optional files | 既存プロジェクトへ必要分だけアップグレードしたい時 / When upgrading only the needed parts of an existing adopter project |
| [`axiarch-prompts-install.sh`](#axiarch-prompts-installsh) | **プロンプト → Claude Code slash command 生成**（v1.13.0+）。`axiarch-prompts/` から `.claude/commands/axiarch-<name>.md`（`/axiarch-<name>`）を冪等生成。コマンドは正本プロンプトを Read+実行する thin pointer / Generates Claude Code slash commands (`/axiarch-<name>`) from `axiarch-prompts/`; thin pointers (idempotent, bilingual, `--clean`/`--dry-run`) | プロンプトを `/` から呼びたい時（Claude Code）。`init.sh` で opt-in 生成、または手動実行 / To invoke prompts via `/` in Claude Code |
| [`check-git-config-clean.sh`](#check-git-config-cleansh) | `.git/config` 健全性チェック（`worktreeConfig` 残留検出・修復） / `.git/config` integrity check | Antigravity Go-based language server がクラッシュ（`ECONNREFUSED 127.0.0.1:50347`）する時 |

---

## `axiarch-upgrade.sh`

### 概要 / Overview

既存のAxiarch採用プロジェクトを、プロジェクト固有のBlueprint状態を壊さずに更新するためのローカルファーストなアップグレード補助ツール。
`axiarch-manifest.json` の所有境界に従い、Universal、プロトコル、scripts、agent hook、Blueprintテンプレート・共有ルール、Blueprint索引、プロジェクト固有Blueprint、prompts、pointer files、Axiarch本体リポジトリ専用ファイルをグループ化して扱う。
本体リポジトリ専用ファイルは既定ではskipし、`--interactive` で明示選択された場合だけ差分確認や適用候補に進める。
対象ファイル、除外条件、グループの既定方針は `axiarch-manifest.json` から読み込まれる。`jq` がない環境では、同梱スクリプト内の既定リストへフォールバックする。

Local-first upgrade helper for existing Axiarch adopter projects. It follows `axiarch-manifest.json` ownership boundaries and groups Universal rules, protocols, scripts, agent hooks, Blueprint templates and shared rules, Blueprint index, project-owned Blueprint state, prompts, pointer files, and Axiarch source-repository-only files.
Source-repository-only files stay skipped by default and move into diff review or application only when explicitly selected with `--interactive`.
The file list, excludes, and group defaults are read from `axiarch-manifest.json`. If `jq` is unavailable, the helper falls back to the embedded default list.

### 使い方 / Usage

```bash
# 変更計画だけ確認 / Preview only
bash axiarch-scripts/axiarch-upgrade.sh --to v1.13.0 --dry-run

# 古い採用先で helper が未導入の場合 / Bootstrap the helper temporarily when it is not installed yet
curl -sSL https://raw.githubusercontent.com/hiroyuki-miyauchi/axiarch/v1.13.0/axiarch-scripts/axiarch-upgrade.sh -o /tmp/axiarch-upgrade.sh
bash /tmp/axiarch-upgrade.sh --target "$(pwd)" --to v1.13.0 --dry-run

# Axiarch所有の安全更新だけ反映 / Apply only low-risk Axiarch-owned updates
bash axiarch-scripts/axiarch-upgrade.sh --to v1.13.0 --safe-only --apply

# Codex向けに必要なものだけ対象化 / Scope to Codex-oriented files
bash axiarch-scripts/axiarch-upgrade.sh --to v1.13.0 --agent codex --dry-run

# グループごとに対話選択 / Choose group actions interactively
bash axiarch-scripts/axiarch-upgrade.sh --to v1.13.0 --interactive
```

### 主な選択肢 / Main Choices

| 選択肢 / Choice | 用途 / Purpose |
|:--|:--|
| `preserve（保持・上書きしない）` | `blueprint/core/000_project_overview.md` や `blueprint/core/010_project_lessons_log.md` など、採用先プロジェクト固有状態を維持 |
| `show-diff（差分だけ表示）` | 変更せずに差分だけ確認 |
| `update-all（すべて更新）` | 対象グループをAxiarch最新版で置換 |
| `review-each（ファイルごとに確認）` | ファイル単位で `keep-local（ローカル版を維持）` / `use-axiarch（Axiarch最新版で置換）` / `merge（3-way mergeを試す）` などを選択 |
| `skip（今回はスキップ）` | 今回は対象外にする |

### 対象範囲 / Scope

- `--lang ja|en|both` で言語フォルダを絞り込み
- `--agent codex|claude|antigravity|cursor|copilot|windsurf|all` でエージェント別ポインターやhookを絞り込み
- `--with-prompts` を付けた場合のみ `axiarch-prompts/` を更新対象に含める
- `--from` / `--from-ref` / `--base-source` は `replace-if-local-unchanged` のbase判定と3-way mergeの両方に使う
- `--yes` は `--apply` の最終確認を省略する。CI等の非対話実行で、直前のdry-run結果を確認し、人間がapply実行を明示承認済みの場合だけ使う / `--yes` skips final confirmation for `--apply`; use only for non-interactive automation after reviewing the dry-run output and after the human owner has explicitly approved apply
- `--apply` または `--interactive` の確認入力で標準入力がEOFになった場合は、既定Nとしてdry-runへ戻す / If confirmation input reaches EOF during `--apply` or `--interactive`, it defaults to N and returns to dry-run behavior
- 不正な `--agent` 値は静かに無視せずエラーにする
- `--apply` しない限り dry-run。dry-run中の3-way merge競合は報告のみで、`.axiarch/conflicts/` には書き込まない
- ディレクトリ更新時、source側に存在しないlocal-onlyファイルは自動削除せず、`STALE-LOCAL` として表示する。`--apply` 時はupgrade reportにも記録し、dry-run時は成果物を書かない
- sourceとtargetでファイル/ディレクトリの型が異なる場合は自動削除・置換せず、`TYPE-CONFLICT` としてreview対象にする。`--apply` 時はupgrade reportにも記録する
- Source Repository Filesは既定でskipする。`--interactive` でユーザーが明示的に `show-diff` / `review-each` / `update-all` を選んだ場合だけ、差分表示や明示適用に進む
- `replace-if-local-unchanged` policyは、target欠落時または `--from` / `--from-ref` / `--base-source` のbaseとtargetが一致する場合のみ自動更新する。baseなし差分、base欠落、base不一致はreason付きでreviewへ倒す
- 番号付きBlueprintは原則Project Stateとして保持する。ただし、manifestに明示されたAxiarch共有Blueprintルールは、README/INDEXのリンク切れを避けるため `Blueprint Templates & Shared Rules（Blueprintテンプレート・共有ルール）` としてレビュー対象に含める。Project Stateの広域globにはmanifestの `exclude` を適用し、明示管理済みのテンプレートや共有Blueprintを二重分類しない
- 反映時は `.axiarch/version.json`、`.axiarch/upgrade-report.md`、`.axiarch/files.sha256` を記録。`--source` 指定時も source manifest の `axiarchVersion` をversion metadataへ反映し、`--to vX.Y.Z` や `--ref tags/vX.Y.Z` 由来のタグ接頭辞 `v` はmetadata上では正規化する。`--with-prompts` で任意promptを含めた場合は `axiarch-prompts/` もhash証跡に含める
- `--apply` 後、`check-axiarch-health.sh` が存在すれば `--quiet` で健全性診断を実行

---

## `check-axiarch-health.sh`

### 概要 / Overview

**Axiarch 公式健全性診断ツール**。Hook（導入済みの場合）+ LOADING_PROTOCOL + CRYSTALLIZATION_PROTOCOL + AXIARCH.mdプロトコルのうち**外部検証可能な 10 領域以上**を一発診断する（v1.5.5 で Anti-Full-Overwrite が物理遮断対象に追加、v1.6.0 で sublimated files index 追加、v1.8.0 で Check D Task Boundary Detection 追加、v1.9.0 で PostToolUse diff guard を追加、v1.10.0でAxiarch本体のリリース版メタデータ整合とSafe Upgrade Wizard検査を追加、v1.11.0で現在タスク文書ローテーション、ネイティブタスク状態同期検査、Claude Memory正本境界検査を追加）。Claude Code / Codex の hook 設定が存在しない場合は「任意 hook 層が未導入」として扱い、hook 未導入だけを理由に失敗させない。「どこに不整合があるか」を見つけやすくする設計。

The official Axiarch health diagnostic. One-shot 16-stage check covering hook firing when the hook layer is installed, AI adherence, crystallization threshold (count + time-axis), the verifiable subset of AXIARCH.md protocols, the v1.5.5 physical-block / bootstrap hooks, the v1.6.0 sublimated-files index, the v1.8.0 task-boundary detection wiring, the v1.9.0 PostToolUse diff guard, v1.10.0 release metadata parity and Safe Upgrade Wizard checks, and v1.11.0 current-task document rotation, native task-state sync, ja/en numbered-heading parity, and Claude Memory canonical-boundary checks. If Claude Code / Codex hook settings are absent, the diagnostic treats the hook layer as optional and not installed rather than failing only on hook absence. `--quiet` flag for pre-commit usage.

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
| 1 | Hook | `.claude/settings.json` または `.codex/hooks.json` の検出（未導入時は任意 hook 層として warn のみ） / Detects hook config; absence is warn-only when hooks are not installed |
| 2 | Hook | JSON 構文 / Syntax validation |
| 3 | Hook | UserPromptSubmit hook 構造 + AXIARCH BOOT marker / Hook structure + marker |
| 4 | Hook | hook層導入時のセッションログ発火履歴（Codex hookのみの場合は構造検査中心） / Firing history when the hook layer is installed; Codex-only hooks use structural validation because Claude JSONL logs do not apply |
| 5 | LOADING_PROTOCOL | `task.md` ロード履歴 / Load history adherence |
| 6 | CRYSTALLIZATION_PROTOCOL | `core/010_project_lessons_log.md` の閾値超過ドメイン検出 / 3+ unsorted lessons per domain |
| 7 | AXIARCH Evidence | `task.md` / `implementation_plan.md` / `walkthrough.md` 存在 / Process documentation presence |
| 8 | AXIARCH Release Safety | force-push / 直 main commit 検出 / Deployment ban hygiene |
| 9 | AXIARCH SSOT | main 同期状態 / SSOT sync (behind/ahead) |
| 10 | AXIARCH Language | Project Native Language 整合性 / Language-first consistency |
| 11 | AXIARCH Anti-Full-Overwrite | PreToolUse hook 配線確認（物理遮断） / PreToolUse hook wiring (physical block) — **v1.5.5+** |
| 12 | Bootstrap | SessionStart hook 配線確認 / SessionStart hook wiring — **v1.5.5+** |
| 13 | Sublimated Index | 既存の `blueprint/{domain}/{NNN}_*.md` を一覧表示し APPEND を促進 / Lists existing sublimated files to promote APPEND — **v1.6.0+** |
| 14 | Task Boundary | Check D wiring 確認（`axiarch-boot-reminder.sh` に VIOLATION-D + AXIARCH_TASK_BOUNDARY_DETECT 含有を確認） / Verifies Check D wiring in `axiarch-boot-reminder.sh` — **v1.8.0+** |
| 15 | v1.9+ / v1.11+ Integration | hook層導入時のPostToolUse diff guard 配線確認（`axiarch-diff-guard.sh` + Edit / MultiEdit / Write matcher）+ 現在タスク文書ローテーション（`axiarch-task-state.sh`）+ Codex `update_plan` / Claude Code Task tools のネイティブ状態同期説明 + Axiarch本体リポジトリでのみsource repository docs / indexes反映確認 + ハーネスエンジニアリング入口保持確認 + ja/en番号見出しparity確認 + Claude Memory正本境界確認 + AXIARCH.md・axiarch-harness・中核ファイルのGit追跡確認 + AXIARCH.md mixed/review所有境界確認 + CHANGELOGのUnreleased参照整合 + リリース版メタデータ整合 + Safe Upgrade Wizard検査 / Verifies PostToolUse diff guard wiring, current-task document rotation (`axiarch-task-state.sh`), native state-sync wording for Codex `update_plan` and Claude Code Task tools, source repository docs/index integration, Harness Engineering entrypoint retention, ja/en numbered-heading parity, Claude Memory canonical boundary, Git tracking for AXIARCH.md, axiarch-harness, and core files, AXIARCH.md mixed/review ownership boundary, CHANGELOG reference parity, release metadata parity, and Safe Upgrade Wizard checks — **v1.9.0+ / v1.11.0** |

### 環境変数 / Environment Variables（v1.6.0+, extended in v1.8.0+）

| 変数 / Variable | デフォルト / Default | 説明 / Description |
|:--|:--:|:--|
| `AXIARCH_REMINDER_TTL_SECONDS` | `1800` (30 分) | `axiarch-boot-reminder.sh` の short-circuit TTL。`0` で disable / Two-stage reminder TTL; `0` disables short-circuit |
| `AXIARCH_LESSON_STALE_DAYS` | `180` | Check 6 (b) / Check C の time-axis trigger 閾値（日数）。`0` で disable / Time-axis trigger threshold; `0` disables Check C |
| `AXIARCH_PRECOMMIT_SKIP` | unset | `1` をセットすると pre-commit hook を 1 回だけ bypass / Set to `1` to bypass the pre-commit hook for one commit |
| **`AXIARCH_TASK_BOUNDARY_DETECT`** | **`1`** | **v1.8.0+: `0` で Check D Task Boundary Detection を完全 disable（v1.6.0 動作再現）/ Set to `0` to fully disable Check D task-boundary detection (reproduces v1.6.0 behaviour)** |
| **`AXIARCH_TASK_DOMAIN_KEYWORDS`** | (組込 default 集合) | **v1.8.0+: Check D の domain keyword 集合をオーバーライド（pipe-separated regex, 採用先カスタマイズ用）/ Override Check D's domain keyword set (pipe-separated regex; for adopter customisation)** |
| `AXIARCH_DIFF_GUARD_MODE` | `warn` | v1.9.0: diff guard の動作。`warn` / `block` / `off` / Diff guard mode |
| `AXIARCH_DIFF_GUARD_MAX_LINES` | `400` | v1.9.0: 追加+削除行数の閾値 / Added plus deleted line threshold |
| `AXIARCH_DIFF_GUARD_MAX_FILES` | `20` | v1.9.0: 変更ファイル数の閾値 / Changed file threshold |
| `AXIARCH_DIFF_GUARD_INCLUDE_UNTRACKED` | `1` | v1.9.0: untracked files を閾値計算に含める / Include untracked files in threshold calculation |
| `AXIARCH_DIFF_GUARD_ALLOW` | unset | v1.9.0: `1` で一時的にdiff guardをbypass / Set to `1` to bypass diff guard for one run |

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

- **Check A**: `task.md` にロード履歴（`AXIARCH.md` / `axiarch-rules/{lang}/INDEX.md` / `axiarch-rules/{lang}/LOADING_PROTOCOL.md`）が未記録
- **Check B**: `axiarch-rules/{lang}/blueprint/core/010_project_lessons_log.md` で 3 件以上溜まったドメイン（CRYSTALLIZATION §5 違反）

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

`.claude/settings.json` または `.codex/hooks.json` の `PreToolUse` hook（`Write` matcher）から呼ばれる外出しスクリプト。`Write` tool 呼び出しを傍受し、対象ファイルが既存の場合は `decision:"block"` JSON + exit code 2 で**物理遮断**する。AXIARCH.md Anti-Full-Overwrite違反のうち、既存ファイルへの `Write` 全文上書きパターンを構造的に抑止する。

Externalized PreToolUse hook script invoked from `.claude/settings.json` or `.codex/hooks.json`. Intercepts `Write` tool calls and physically blocks (decision:"block" JSON + exit 2) when the target file exists. This structurally reduces the known AXIARCH.md Anti-Full-Overwrite risk pattern of using `Write` to overwrite existing files.

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

`.claude/settings.json` または `.codex/hooks.json` の `SessionStart` hook から呼ばれる外出しスクリプト。会話開始時に `axiarch-task-state.sh` へ委譲し、project root の `task.md` / `implementation_plan.md` / `walkthrough.md` を現在タスク用に用意する。既存内容に変更がある場合は `.axiarch/process-doc-history/` へ退避してから更新する。常に AXIARCH.md とネイティブタスク状態同期の reminder を `additionalContext` で AI に注入する。

Externalized SessionStart hook script invoked from `.claude/settings.json` or `.codex/hooks.json`. On session start, delegates to `axiarch-task-state.sh` and prepares `task.md` / `implementation_plan.md` / `walkthrough.md` as current-task documents. When existing content has changed, it is archived under `.axiarch/process-doc-history/` before refresh. Always injects an AXIARCH.md and native task-state sync reminder via `additionalContext`.

### 使い方 / Usage

直接実行する用途は通常なし（hook 経由で自動呼出）。デバッグ時のみ：

```bash
bash axiarch-scripts/axiarch-init-task-md.sh | jq .
# → hookSpecificOutput.additionalContext に reminder + (必要なら scaffold note)
```

---

## `axiarch-task-state.sh`

### 概要 / Overview

`task.md` / `implementation_plan.md` / `walkthrough.md` のライフサイクルを管理する補助スクリプト。既定では3ファイルを現在タスク専用の作業文書として扱い、変更済みの既存内容を `.axiarch/process-doc-history/` へ退避してから、`AXIARCH.md` の `Project Native Language` に合わせたテンプレートを再生成する。旧導入先では `AGENTS.md` をフォールバックとして参照する。従来の追記運用が必要な採用先では `AXIARCH_PROCESS_DOC_MODE=append` を明示する。

Helper script that manages the lifecycle of `task.md` / `implementation_plan.md` / `walkthrough.md`. By default, it treats the three files as current-task working documents, archives changed existing content under `.axiarch/process-doc-history/`, then regenerates templates in the `Project Native Language` declared in `AXIARCH.md`, with `AGENTS.md` as a legacy fallback. Adopter projects that need legacy append behavior can explicitly set `AXIARCH_PROCESS_DOC_MODE=append`.

### 使い方 / Usage

```bash
# SessionStart相当のrefresh / Refresh as SessionStart would
bash axiarch-scripts/axiarch-task-state.sh --mode session-start

# 既存内容を保持し、不足ファイルだけ作成 / Preserve existing content and create only missing files
AXIARCH_PROCESS_DOC_MODE=append bash axiarch-scripts/axiarch-task-state.sh --mode ensure

# 状態確認 / Check status
bash axiarch-scripts/axiarch-task-state.sh --mode status
```

### 環境変数 / Environment Variables

| 変数 / Variable | デフォルト / Default | 説明 / Description |
|:--|:--:|:--|
| `AXIARCH_PROCESS_DOC_MODE` | `current` | `current` でarchive-before-refresh、`append` で既存内容を保持 / `current` archives before refresh; `append` preserves existing content |
| `AXIARCH_PROCESS_DOC_ARCHIVE` | `1` | `0` でarchiveを無効化 / Set to `0` to disable archiving |
| `AXIARCH_PROCESS_DOC_HISTORY_DIR` | `.axiarch/process-doc-history` | 過去文書の退避先 / Archive destination |
| `AXIARCH_PROCESS_DOC_LANG` | `auto` | `auto` で `AXIARCH.md` の `Project Native Language` を判定し、旧導入先では `AGENTS.md` にフォールバック。`ja` / `en` でテンプレート言語を明示 / `auto` detects `Project Native Language` from `AXIARCH.md`, falling back to `AGENTS.md` for legacy adopters; `ja` / `en` force the template language |

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

`init.sh` は `cp -R "$SOURCE_DIR/axiarch-scripts/." "$TARGET_DIR/axiarch-scripts/"` で全スクリプトを再帰コピーし、`chmod +x` で実行権限を付与する。新規スクリプトを `axiarch-scripts/` に追加すれば、次回 `init.sh` 実行時に採用先へ自動配布される。

`init.sh` recursively copies all scripts from `axiarch-scripts/` via `cp -R` and applies execute permission. New scripts added under `axiarch-scripts/` are auto-distributed on the next `init.sh` run.

---

## 関連ドキュメント / Related Documentation

- [`README.md`](../README.md) — `Hook Reinforcement Mechanism` トラブルシュート章
- [`axiarch-rules/{ja,en}/LOADING_PROTOCOL.md`](../axiarch-rules/) — フック診断手順
- [`axiarch-rules/{ja,en}/CRYSTALLIZATION_PROTOCOL.md`](../axiarch-rules/) — 結晶化遵守の §5 強化
- [`axiarch-rules/{ja,en}/universal/engineering/600_git_workflow.md`](../axiarch-rules/) — Worktree Hygiene Protocol
- [Claude Code Hooks (公式 / official)](https://code.claude.com/docs/en/hooks)
