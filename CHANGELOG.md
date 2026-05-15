# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased] — v1.9.0 Initial Implementation

### 🧠 Memory Persistence & Glob-Scoped Rules / Memory Persistence と Glob-Scoped Rules 初期実装

v1.9.0前の価値最大化コミット（`0489174`）と分離し、Tier 2候補のうち運用検証しやすい初期実装を追加。現時点では未リリースの作業ブランチ上の変更として扱い、Hook補強の4層化、Memoryテンプレート、Cursor globs導線、shellcheck CI、配布後構文検証、Check 15を導入。

Separated from the pre-v1.9 value-maximization commit (`0489174`) and added the initial Tier-2 implementation that can be validated in real workflows. This is currently treated as unreleased branch work and introduces four-layer hook reinforcement, memory template, Cursor globs entrypoint, shellcheck CI, post-copy syntax validation, and Check 15.

### Added

- **`axiarch-scripts/axiarch-diff-guard.sh`** — `PostToolUse` hook用の差分ガードを追加。`Edit` / `MultiEdit` / `Write` 後にgit diffの変更行数と変更ファイル数を測定し、閾値超過時に `warn` / `block` / `off` を選択可能 / Added a PostToolUse diff guard that measures changed lines/files after Edit, MultiEdit, and Write; supports warn, block, and off modes
- **`.claude/settings.json` / `.codex/hooks.json`** — `PostToolUse` hookを追加し、`axiarch-diff-guard.sh` を Edit / MultiEdit / Write に配線 / Added PostToolUse hook wiring for `axiarch-diff-guard.sh`
- **`.claude/memory/MEMORY.md`** — Claude Code向けの任意Memory Persistenceテンプレートを追加。上位ルールを置換せず、実際に発生した再発防止事項だけを短く記録する設計 / Added an optional Claude Code memory template that does not replace higher-priority rules and stores only short notes from actual recurring issues
- **`.cursor/rules/axiarch.mdc`** — `globs: "**/*"` を明示し、path-scoped rules の将来仕様として `paths:` frontmatter導線を追加 / Declared `globs: "**/*"` and documented future `paths:` frontmatter for path-scoped rules
- **`.github/workflows/lint.yml`** — ShellCheck jobを追加し、`init.sh` と `axiarch-scripts/*.sh` をCIで静的解析 / Added ShellCheck CI for `init.sh` and `axiarch-scripts/*.sh`

### Changed

- **`axiarch-scripts/check-axiarch-health.sh`** — 14段階診断から15段階診断へ拡張。Check 15でv1.9.0 diff guard配線を検査し、Axiarch本体リポジトリでのみREADME系反映も検査 / Extended health diagnostics from 14 to 15 stages; Check 15 verifies v1.9.0 diff guard wiring and checks README integration only in the Axiarch source repository
- **`init.sh`** — `AXIARCH_VERSION` を未リリース作業用の `1.9.0-dev` へ更新し、配布後 `bash -n` 検証とClaude memoryテンプレートの非破壊コピーを追加 / Set `AXIARCH_VERSION` to unreleased work version `1.9.0-dev`, added post-copy `bash -n` validation and non-destructive Claude memory template copy
- **`README.md` / `axiarch-scripts/README.md` / `llms.txt` / `llms-full.txt` / `ROADMAP.md`** — 4 hooks、15-stage診断、Memory Persistence、Glob-Scoped Rules、diff guardの説明へ更新 / Updated docs for four hooks, 15-stage diagnostics, Memory Persistence, Glob-Scoped Rules, and diff guard

### Compatibility

- **後方互換性を維持** — hooks、scripts、memory、prompts、agent pointerは引き続き任意または条件付き。必須構成は `AGENTS.md` と `axiarch-rules/` のまま / Backward compatibility maintained. Hooks, scripts, memory, prompts, and agent pointers remain optional or conditional; the required minimal setup is still `AGENTS.md` plus `axiarch-rules/`
- **動作保証なしの範囲を維持** — Google Antigravity以外の実務検証は継続中。Codex / Claude Codeは主対象、Cursor / Copilot / Windsurfは拡張ポインター候補 / Practical validation remains ongoing outside Google Antigravity; Codex and Claude Code are primary targets, while Cursor, Copilot, and Windsurf remain extended pointer candidates

---

## [1.8.2] — 2026-05-12

### ⚙️ Native Codex Environment Integration / Codex 環境ネイティブ対応

AxiarchのHook補強機構（Hook Reinforcement Mechanism）全体を拡張し、Claude Code (`.claude/settings.json`) と同等に Codex (`.codex/hooks.json`) を第一級サポートとしてネイティブ統合。

Expanded the entire Axiarch Hook Reinforcement Mechanism to natively integrate Codex (`.codex/hooks.json`) as a first-class citizen alongside Claude Code (`.claude/settings.json`).

### Added

- **`init.sh` — Codex setup support** — `SETUP_CODEX` フラグを追加し、`.codex/hooks.json` の自動初期化・検証・クリーンアップ機構を実装 / Added `SETUP_CODEX` flag to implement automatic initialization, validation, and cleanup for `.codex/hooks.json`
- **`.gitignore` — Codex global ignore patterns** — `.codex/worktrees/`, `.codex/projects/`, `.codex/hooks.local.json` をグローバル無視リストに追加 / Added Codex-specific directories to the global ignore list

### Changed

- **`check-axiarch-health.sh` — Dynamic Hook Validation** — ハードコードされていた `.claude/settings.json` の参照を削除し、`.claude/settings.json` と `.codex/hooks.json` の両方を動的に検知してフックの検証を行えるように改修 / Refactored to dynamically detect and validate either `.claude/settings.json` or `.codex/hooks.json`
- **`check-git-config-clean.sh` — Stale Branch Detection** — ゾンビブランチの検出ロジック（正規表現）を拡張し、`claude` だけでなく `codex` のステイルブランチも正しくクリーンアップできるように変更 / Expanded stale branch detection regex to clean up both `claude` and `codex` stale branches
- **`axiarch-protect-antifull.sh` — Whitelist Support** — §6 全文上書き禁止ルールのホワイトリストとして、`.claude/axiarch-overwrite-allow.txt` と `.codex/axiarch-overwrite-allow.txt` の両方をサポート / Supported both `.claude` and `.codex` overwrite allow-lists for §6 Anti-Full-Overwrite rules
- **`axiarch-rules/*/LOADING_PROTOCOL.md`** — 採用先プロジェクトに配置される標準フック定義ファイルとして `.codex/hooks.json` を追記 / Documented `.codex/hooks.json` as a standard hook configuration in the governance protocol

### Compatibility

- ✅ **後方互換性を維持** — 既存の Claude Code 環境に対する意図的な挙動変更なし / Backward compatibility maintained; no intended changes to existing Claude Code behavior

---

## [1.8.1] — 2026-05-11

### 🩹 Check 4 Codex 互換性 + Check 13 quiet mode バグ修正 + docs 訂正 / Check 4 Codex Compatibility + Check 13 Quiet-Mode Fix + Docs Corrections

41–42 ラウンド調査で発見した診断バグ 2 件 + ドキュメント記述訂正 3 件を patch release として bundling。いずれも `axiarch-scripts/check-axiarch-health.sh` の診断精度またはドキュメント整合性に影響する。

Two diagnostic bug fixes + three documentation corrections discovered in the 41st–42nd-round audits, bundled as a patch release. Both affect the diagnostic accuracy of `axiarch-scripts/check-axiarch-health.sh`.

### Fixed

- **Check 4 — Codex ランタイム検出の追加** — OpenAI Codex 環境（`CODEX_THREAD_ID` / `CODEX_CI` 環境変数、または `__CFBundleIdentifier == com.openai.codex`）では Claude Code セッションログ（`.claude/projects/*.jsonl`）が存在しないため、Check 4 が常に `[FAIL] Hook never fired` を返していた false-negative bug を修正。Codex 検出時は `[PASS] Codex runtime detected — Claude Code hook firing history is not applicable` を返す / Added Codex runtime detection to Check 4: in Codex environments the Claude Code session log (`.claude/projects/*.jsonl`) does not exist, causing a false `[FAIL] Hook never fired`. Now returns `[PASS] Codex runtime detected — not applicable` when Codex env vars are detected

- **Check 13 — `--quiet` モード時の verbose 出力バグ修正** — `--quiet` / `-q` フラグを指定した場合でも、Check 13 の `printf '%b' "${SUBLIMATED_FOUND}"` と `print_info` 2行がターミナルに出力されていた bug を修正（`if ! "${QUIET_MODE}"; then ... fi` で正しく抑制）。CI / pre-commit 連携での不要出力を解消 / Fixed Check 13 verbose output in `--quiet` mode: `printf` and two `print_info` lines were executing unconditionally; now wrapped in `if ! "${QUIET_MODE}"; then` to correctly suppress output in silent mode

### Documentation Corrections (42nd-round audit)

- **`axiarch-scripts/README.md` JA概要 「外部検証可能な 8 領域」 → 「10 領域以上」** — v1.5.1 当時の 10-stage 計上時の列挙数がそのまま残存。v1.8.0 で 14-stage に展開されたため「10 領域以上」に訂正。v1.8.0 Check D Task Boundary Detection 追加の言及も併せ追記 / Fixed stale "8 領域" (8 verifiable areas) count from v1.5.1 era; updated to "10 領域以上" and added v1.8.0 Check D mention

- **`CHANGELOG.md` v1.6.0 Out of Scope — `v1.7.0 (Tier 2)` 行の `(Check 14)` → `(Check 15)` + バージョン訁正** — Check 14 は v1.8.0 で実装済みのため次の未実装候補は Check 15。併せて履歴記録内の「v1.7.0 (Tier 2)」 → 「v1.9.0 (Tier 2)」、「v1.8.0 (Tier 3)」 → 「v1.10.0 (Tier 3)」に訂正（いずれも既リリース済み version を指它していた） / Fixed stale version labels in v1.6.0 Out of Scope: `(Check 14)` → `(Check 15)` (Check 14 shipped in v1.8.0); `v1.7.0` → `v1.9.0`; `v1.8.0 (Tier 3)` → `v1.10.0 (Tier 3)`

### Compatibility

- ✅ **後方互換性を維持** — pure bug fix のみ、機能変更ゼロ。Codex 以外の環境（Antigravity / Claude Code / Cursor / Copilot / Windsurf）では意図的な挙動変化なし / Backward compatibility maintained; pure bug fixes only, no functional changes. No intended impact on non-Codex environments
- ✅ **依存追加なし** — bash 環境変数参照のみ追加 / No new dependencies

### Diagnostic Outcome

- **Codex 環境 mock test**: `CODEX_THREAD_ID=test bash axiarch-scripts/check-axiarch-health.sh` → Check 4 が `[PASS] Codex runtime detected` を返すことを確認 ✅
- **`--quiet` モード修正**: sublimated files 存在プロジェクトで `bash axiarch-scripts/check-axiarch-health.sh --quiet` 実行 → Check 13 の verbose 出力が完全抑制されることを確認 ✅
- **axiarch repo against itself**: 全 14 段階 PASS（Check 4 は Codex 環境なしのため `.claude/projects/` 参照モードで PASS 維持）✅

---

## [1.8.0] — 2026-05-10

### 🚨 BREAKING: `scripts/` → `axiarch-scripts/` rename + v1.7.0 features bundled

採用先プロジェクトとの**名前空間衝突回避**のため、配布ディレクトリを rename（pure rename、機能変更ゼロ）。同時に v1.7.0 で予定していた Check D Task Boundary Detection / Claude Code 検証ログ拡充等の全 features を統合 release。

**Pure rename to avoid namespace collision** with adopter-project `scripts/` (critical risk: adopter `scripts/README.md` would be overwritten). All v1.7.0 features bundled.

### BREAKING

- **配布ディレクトリ**: `scripts/` → `axiarch-scripts/` rename（機能変更ゼロ）
- **Hook command paths**: `.claude/settings.json` の `command` を新 path に更新
- **採用先 migration 手順**:
  1. `git pull` で v1.8.0 取得
  2. `bash init.sh` 再実行 → `axiarch-scripts/` 配布 + `.claude/settings.json` 自動再配布（採用先カスタマイズがある場合は事前バックアップ推奨）
  3. 採用先で旧 `scripts/` 配下の axiarch ファイル（`axiarch-boot-reminder.sh` / `axiarch-protect-antifull.sh` / `axiarch-init-task-md.sh` / `check-axiarch-health.sh` / `check-git-config-clean.sh` / `README.md`）を手動削除推奨
- **後方互換 path 提供なし** — clean cut（symlink 互換実装は v2.0.0 Strategic で再検討候補、§Out of Scope 参照）

### Why BREAKING?

採用先プロジェクトは独自の `scripts/` ディレクトリを持つことが多く、特に **`scripts/README.md` 衝突**が致命的。OSS のベストプラクティス（`vendor/` / `node_modules/` 等の名前空間 prefix）に従い `axiarch-scripts/` で完全分離。

### Added (v1.7.0 features bundled)

- **Check D — Task Boundary Detection** (axiarch-scripts/axiarch-boot-reminder.sh): UserPromptSubmit hook の stdin から現プロンプト JSON を読み、whole-word match で domain keyword を抽出。**AGENTS §8.4 必須トリオ全 3 ファイル**（task.md / implementation_plan.md / walkthrough.md）を full-text grep して比較。新 keyword 検出時に `🚨 [VIOLATION-D]` flag + TTL bypass。AI の confirmation bias loophole リスクを機械的に検出しやすくする
- **Check 14** (axiarch-scripts/check-axiarch-health.sh): Check D wiring 確認（13-stage → 14-stage）
- **環境変数**: `AXIARCH_TASK_BOUNDARY_DETECT` / `AXIARCH_TASK_DOMAIN_KEYWORDS`
- **Claude Code 検証ログ拡充** — v1.4.0+ ネイティブ hook 統合 + axiarch 自身の開発で hook 補強モデルの検証材料を蓄積。現在の公開ステータスでは Google Antigravity のみを実務検証済みとし、Claude Code は主対象として扱う

### Changed (v1.7.0 features bundled)

- **`axiarch-rules/{ja,en}/LOADING_PROTOCOL.md` Step 4** — Cross-Session Re-load Criteria に Check D 補足、「v1.8.0 改善」セクションで confirmation bias loophole リスクの軽減メカニズムを明文化
- **`axiarch-rules/{ja,en}/INDEX.md` directory tree** — `scripts/` → `axiarch-scripts/`
- **README.md / axiarch-scripts/README.md** — 14-stage / Check D / 新 env vars / 検証ステータス表 / 必須ファイル表 / hook補強セクションを全更新
- **ROADMAP.md** — v1.7.0 forecast を v1.8.0 として delivered 化、Tier 2 forecast を v1.9.0、Tier 3 を v1.10.0 に整理
- **init.sh** — `AXIARCH_VERSION` 1.7.0 → 1.8.0、配布ロジック `scripts/` → `axiarch-scripts/`
- **llms-full.txt / llms.txt** — Version 1.8.0、エージェント互換性表と検証ステータスを更新

### Compatibility

- 🚨 **BREAKING (major bump)**: 採用先で `bash scripts/check-axiarch-health.sh` 等を実行する CI / pre-commit hook / ドキュメント参照は `bash axiarch-scripts/check-axiarch-health.sh` に更新が必要
- ✅ **機能的後方互換**: 機能・env vars・hook 動作は v1.7.0 と同等（pure rename）
- ✅ **Universal Rules 不変**: `axiarch-rules/{ja,en}/universal/` 内の `scripts/` 言及は agent-agnostic 汎用例文として残す
- 📌 **アップグレード手順**: `git pull && bash init.sh` で `axiarch-scripts/` が自動配布

### Diagnostic Outcome

- **Mock test verification**: Check D の 3 process docs scan + whole-word match で全動作確認 ✅
- **rename 後の `bash axiarch-scripts/check-axiarch-health.sh`**: 全 14 段階 PASS ✅
- **採用先衝突回避**: 採用先独自の `scripts/` には影響なし（全 axiarch ファイル名は axiarch- prefix もしくは check-axiarch- / check-git-config- で衝突しない）

### References

- 採用先実運用フィードバック「同 session 内 task 切替で AI が rule 再 load を省略する」（v1.7.0 由来 Check D）
- 採用先設計レビュー「scripts/ → axiarch-scripts/ で名前空間衝突回避」（v1.8.0 BREAKING の動機）
- AGENTS.md §8.4 (Documentation Requirements) と Check D の整合
- Anthropic Claude Code Hooks: <https://code.claude.com/docs/en/hooks>

### Out of Scope（v1.9.0 / v1.10.0 / v2.0.0 に deferred — see ROADMAP）

- **v1.9.0 (Tier 2)**: PostToolUse + git diff verification / Cursor `globs:` adoption / Memory Persistence enhancement / Aider-style prompt-cache / shellcheck CI / Universal Rules footer cleanup / HealthCheck Workflow / Post-release README integration auto-verification (Check 15)
- **v1.10.0 (Tier 3)**: axiarch-doctor CI lint / IFEval-style auto-regression / Deliberative-Alignment forced Protocol Recall / AI Agent Compatibility Matrix
- **v2.0.0 (Strategic)**: AgentSpec-style DSL adoption / Multi-Agent Verification / Axiarch CLI / `decision: "block"` generalisation / `scripts/` ↔ `axiarch-scripts/` symlink 互換実装の再検討

---

## [1.7.0] — 2026-05-08 (内部開発のみ、独立 release はせず v1.8.0 に統合)

> **NOTE**: v1.7.0 was prepared but NOT released as a separate version; all v1.7.0 features were bundled into v1.8.0 along with the BREAKING `scripts/` → `axiarch-scripts/` rename. The original v1.7.0 development history is preserved in the git log (commits 770150b / f60ced8 / c6aee62 / eddeb01 / 69c44b8 / 8d94938).

### 🎯 Check D — Task Boundary Detection（タスク境界候補の検出）/ Reduces the "AI judges same-session, no re-load needed" risk

採用先実運用フィードバックで判明した重要な構造的欠陥を緩和する hot-fix release：v1.6.0 で導入した「Cross-Session Re-load Criteria」の **「同一 session 内タスク継続（タスクタイプ不変）→ 追加 load 不要」** 条項が、**「タスクタイプ不変」の判定を AI 自己判断に任せている**ため、confirmation bias で AI が「session 継続中だから rule 再 load 不要」と判断してサボる loophole を生んでいた。

This release mitigates a critical structural flaw discovered via adopter feedback: v1.6.0's Cross-Session Re-load Criteria included a **"same session, task continues (no type change) → no additional load required"** clause whose key — "task type unchanged" — was left to the AI's self-judgment. Confirmation bias led the AI to skip re-loading by judging "session is continuing." v1.7.0 reduces this risk by **mechanically detecting task-boundary candidates at the hook layer**.

### Added

- **`axiarch-scripts/axiarch-boot-reminder.sh` Check D — Task Boundary Detection**（v1.7.0+）— UserPromptSubmit hook の stdin から現プロンプト JSON を読み、domain keyword（security / architecture / ui_design / api / performance / push / commit / migration 等）を **whole-word match** (`grep -oiwE`) で抽出。**AGENTS §8.4 必須トリオ全 3 ファイル**（`task.md` / `implementation_plan.md` / `walkthrough.md`）を full-text grep し、既存 domain keyword を抽出（プラン側 / walkthrough 側に書かれた domain context も漏れなく捕捉）。現プロンプトに**新しい keyword が出現**したら `🚨 [VIOLATION-D]` flag + **TTL bypass**（短縮版抑制 + full reminder 再発火）。AI の「タスクタイプ不変」自己判断を機械的にバックアップする / Reads current-prompt JSON from UserPromptSubmit hook stdin; extracts domain keywords via whole-word match; full-text greps the AGENTS §8.4 mandatory trio (task.md / implementation_plan.md / walkthrough.md) — not just task.md — for previously-known keywords; on new-keyword detection, emits `🚨 [VIOLATION-D]` and bypasses TTL
- **`axiarch-scripts/check-axiarch-health.sh` Check 14 — Task Boundary Detection wiring 確認** — `axiarch-boot-reminder.sh` に Check D logic（VIOLATION-D + AXIARCH_TASK_BOUNDARY_DETECT env var）が含まれることを確認 / Verifies the reminder script contains the Check D logic
- **環境変数**: `AXIARCH_TASK_BOUNDARY_DETECT`（default `1`、`0` で disable）/ `AXIARCH_TASK_DOMAIN_KEYWORDS`（domain keyword 集合のオーバーライド）

### Changed

- **`axiarch-rules/{ja,en}/LOADING_PROTOCOL.md` Step 4** — Cross-Session Re-load Criteria の「同一 session 内タスク継続」行に Check D 補足追加。「v1.8.0 改善 — Check D Task Boundary Detection」セクションで confirmation bias loophole リスクの軽減メカニズムを明文化（注: v1.7.0 で追加し v1.8.0 で release labelling に整合化）/ Step 4 updated: "task continues" row now references Check D as the mechanical backstop; new "v1.8.0 improvement" section documents the risk-reduction mechanism (originally added in v1.7.0, label aligned in v1.8.0)
- **`axiarch-scripts/check-axiarch-health.sh` ヘッダー** — 13-stage → 14-stage に拡張、Summary 出力に "Task Boundary" を追加
- **`init.sh`** — `AXIARCH_VERSION` 1.6.0 → 1.7.0
- **`llms-full.txt`** — Version 1.6.0 → 1.7.0
- **Claude Code 検証ログ拡充** — v1.4.0+ の `UserPromptSubmit` hook 導入 + v1.5.5+ `PreToolUse` 物理遮断 + v1.6.0+ Reminder TTL + v1.7.0+ Check D Task Boundary Detection をネイティブ統合し、本リポジトリで axiarch 開発自体における検証材料を蓄積。現在の公開ステータスでは Google Antigravity のみを実務検証済みとし、Claude Code は主対象として扱う / Claude Code validation evidence was expanded through first-class hook integration and axiarch's own development cycles. Current public status treats Google Antigravity as the only production-validated agent and Claude Code as a primary target.

### Compatibility

- ✅ **後方互換性を維持** — Check D は `AXIARCH_TASK_BOUNDARY_DETECT=0` で disable 可（v1.6.0 挙動再現）。stdin が空（hook 経由でない直接実行等）の場合 Check D は自動 skip
- ✅ **依存追加なし** — pure bash + grep + sed、`jq` は optional fallback あり
- ✅ **Domain keyword 集合は extensible** — `AXIARCH_TASK_DOMAIN_KEYWORDS` で採用先カスタマイズ可能
- 📌 **アップグレード手順** — `git pull && bash init.sh` 再実行で `axiarch-boot-reminder.sh` が更新される

### Diagnostic Outcome

- **Mock test verification**:
  - stdin 不在 → `[AXIARCH REMINDER]` short / `[AXIARCH BOOT]` full 動作維持 ✅
  - `{"prompt":"please review the security RLS policy and migration in supabase"}` → **VIOLATION-D 検出**（domains: migration, rls, security） ✅
  - `{"prompt":"hello how are you today"}` → VIOLATION-D 検出なし（casual prompt = no domain keyword） ✅
- **axiarch repo against itself**: 全 14 段階 PASS（Check 14 含む）

### References

- 採用先実運用フィードバック「同一 session 内でも実際タスクは異なるのに AI が rule 再 load を省略する」（v1.6.0 release 後の adopter report）
- v1.6.0 commit body の `LOADING_PROTOCOL.md §4 Cross-Session Re-load Criteria` の confirmation bias loophole
- Claude Code Hooks UserPromptSubmit input format: <https://code.claude.com/docs/en/hooks>

### Out of Scope（v1.9.0 / v1.10.0 / v2.0.0 に deferred — see ROADMAP）

- **v1.9.0 (Tier 2)**: PostToolUse + git diff verification / Cursor `globs:` adoption / Memory Persistence enhancement / Aider-style prompt-cache optimisation / shellcheck CI integration / `init.sh` post-distribution syntax validation / Universal Rules footer cleanup / HealthCheck Workflow / Post-release README integration auto-verification (Check 15)
- **v1.10.0 (Tier 3)**: axiarch-doctor CI lint mechanism / IFEval-style auto-regression suite / Deliberative-Alignment forced Protocol Recall / AI Agent Compatibility Matrix
- **v2.0.0 (Strategic)**: AgentSpec-style DSL adoption / Multi-Agent Verification / Axiarch CLI / `decision: "block"` generalisation

---

## [1.6.0] — 2026-05-08

### 🪶 Reminder TTL + Time-Axis Crystallization + Pre-commit Installer + Session Re-load Criteria + APPEND Guide / リマインダー TTL + 時間軸結晶化 + pre-commit installer + session 跨ぎ基準 + APPEND ガイド

実運用フィードバック（採用先プロジェクト「ガバナンス機能評価レポート」）の 5 項目改善を minor release として bundling。**「設計 vs 現実」の乖離（context budget / token cost / 既存 sublimated file 認識率 / stale lesson 放置）**を構造的に解消する。

Bundles five improvements driven by adopter-project feedback ("governance functional evaluation report"). Structurally resolves the design-vs-reality gap (context budget, token cost, sublimated-file recognition, stale-lesson neglect).

### Added

- **`axiarch-scripts/axiarch-boot-reminder.sh` Two-Stage Output (TTL)**（v1.6.0+）— First fire (or after TTL expires) returns the **full reminder** + writes timestamp; subsequent fires within TTL with no violations return a short-circuit `[AXIARCH REMINDER]` reminder. State file: `${TMPDIR}/axiarch-reminder-{project_hash}.timestamp`. TTL configurable via `AXIARCH_REMINDER_TTL_SECONDS` (default 1800 = 30 min; `0` disables). Token impact: ~24k cumulative → ~3k (87% reduction in long sessions) / TTL 二段階出力により長時間 session で token 約 87% 削減
- **`axiarch-scripts/axiarch-boot-reminder.sh` Check C — Stale Lesson Detection** — Any `core/010` lesson dated `>180 days` (configurable via `AXIARCH_LESSON_STALE_DAYS`) appends a `🚨 [VIOLATION-C]` flag, ensuring single-domain lessons do not get neglected indefinitely / 180 日以上経過の lesson 検出
- **`axiarch-scripts/check-axiarch-health.sh` Check 6 拡張 — CRYSTAL §5 Time-Axis Trigger** — Existing count threshold (3+ per domain, trigger (a)) now joined by **time-axis trigger (b)** detecting `[YYYY-MM-DD]` dated lessons older than threshold days. Surfaces stale-lesson backlog
- **`axiarch-scripts/check-axiarch-health.sh` Check 13 — Sublimated Files Index** — Lists existing `blueprint/{domain}/{NNN}_{topic}.md` files so the AI can prefer **APPEND to existing files** over new `core/010` entries (per CRYSTAL §3 SEARCH). Addresses inucomi-style "12 consecutive N/A" feedback where lessons fit existing file scope but get added to `core/010`
- **`axiarch-scripts/check-axiarch-health.sh --quiet` flag** — Silent mode for pre-commit / CI usage; suppresses verbose output, only error to stderr + exit code conveys result
- **`init.sh` Pre-commit Hook Installer (opt-in)** — New STEP 3.5 prompts `Install pre-commit hook? [y/N]`. When enabled: (a) detects existing lefthook / pre-commit-framework / husky and warns instead of overwriting, (b) appends axiarch block to existing `.git/hooks/pre-commit` or creates new file, (c) marker-based idempotency. Bypass per-commit via `AXIARCH_PRECOMMIT_SKIP=1`

### Changed

- **`axiarch-rules/{ja,en}/CRYSTALLIZATION_PROTOCOL.md` Step 5** — Replaced single "3+ count" trigger with **dual-trigger table** (count + time-axis), explicitly documenting why time-axis trigger matters for projects with comprehensive sublimated files
- **`axiarch-rules/{ja,en}/LOADING_PROTOCOL.md` Step 4** — Added **"Cross-Session Re-load Criteria"** section explicitly resolving the "full load = no laziness" vs "context budget reality" trade-off. Defines re-load scope per situation (new session / task type changed / continuing / long pause). Documents `task.md` load history as Single Source of Truth
- **`init.sh`** — `AXIARCH_VERSION` 1.5.5 → 1.6.0; new `select_precommit` + `install_precommit_hook` functions wired into `main()`
- **`llms-full.txt`** — Version 1.5.5 → 1.6.0

### Compatibility

- ✅ **後方互換性を維持** — TTL は `AXIARCH_REMINDER_TTL_SECONDS=0` で完全 disable 可（v1.5.5 挙動再現）。Check C は `AXIARCH_LESSON_STALE_DAYS=0` で disable 可。pre-commit installer は完全 opt-in
- ✅ **依存追加なし** — pure bash 実装、`shasum` は macOS / Linux 標準。`date -d` (GNU) と `date -j -f` (BSD) の dual-fallback
- ✅ **lefthook / pre-commit-framework / husky 既存環境を破壊しない** — 検出して warn のみ
- ✅ **既存 `.git/hooks/pre-commit` を上書きしない** — append + marker による idempotency
- 📌 **アップグレード手順** — `git pull && bash init.sh` 再実行（pre-commit installer は opt-in 質問あり）

### Diagnostic Outcome

- **Mock test verification**:
  - TTL 二段階：first fire = full / TTL 内 = short-circuit `[AXIARCH REMINDER]` / TTL 強制無効化 = full ✅
  - Check 6 time-axis: 180 日以下 lesson のみ → "Below time-axis threshold" PASS ✅
  - Check 13: axiarch 本体は sublimated file 不在 → "No sublimated files yet" 案内 ✅
  - `--quiet` mode: PASS 時完全 silent + exit 0 / 違反時 stderr only ✅
- **axiarch repo against itself**: 全 13 段階 PASS（Check 13 含む）

### References

- 採用先 「ガバナンス機能評価レポート」（実運用フィードバック）
- AGENTS.md §0 HIGHEST-PRIORITY RULE / §6 ANTI-FULL-OVERWRITE / §8 Process & Documentation / §9 Continuous Improvement
- v1.5.5 PreToolUse hook が本 release の implementation 中に**実機発火し作者の Write 操作を物理遮断した実証あり**（Edit による段階実装に切り替え）
- Anthropic Claude Code Hooks: <https://code.claude.com/docs/en/hooks>

### Out of Scope（次バージョン以降に deferred — see ROADMAP）

- **v1.9.0 (Tier 2)**: PostToolUse + git diff verification / Cursor `globs:` adoption / Memory Persistence enhancement / Aider-style prompt-cache optimisation / shellcheck CI / `init.sh` post-distribution syntax validation / Universal Rules footer cleanup / HealthCheck Workflow / Post-release README integration auto-verification (Check 15)
- **v1.10.0 (Tier 3)**: `axiarch-doctor` CI lint mechanism / IFEval-style auto-regression suite / Deliberative-Alignment forced Protocol Recall / AI Agent Compatibility Matrix
- **v2.0.0 (Strategic)**: AgentSpec-style DSL adoption / Multi-Agent Verification / Axiarch CLI / `decision: "block"` generalisation

---

## [1.5.5] — 2026-05-07

### 🚦 Physical Block + Tone Refactor + SessionStart Bootstrap / 物理遮断 + トーン リファクタ + セッション開始ブートストラップ

26 ラウンド徹底市場調査（4 並列 Agent: AI compliance frameworks / competitor tools / Claude Code official features / academic 2024-2026）の統合分析を踏まえ、**「Reminder → Physical Block」のパラダイムシフト**を実装。学術的に裏付けされた 3 改善を v1.5.5 patch として bundling：(1) `PreToolUse` hook で §6 ANTI-FULL-OVERWRITE を物理遮断、(2) `SessionStart` hook で task.md 自動ブートストラップ、(3) reminder 文を CAPS / 強調記号から事実陳述へリファクタ（9 protocols 反復構造は維持）。

Based on a 4-agent parallel market study (AI compliance frameworks / competitor tools / Claude Code official / academic 2024-2026), v1.5.5 implements the **"reminder → physical block" paradigm shift**. Three academically-backed improvements are bundled: (1) `PreToolUse` hook physically blocks §6 ANTI-FULL-OVERWRITE violations, (2) `SessionStart` hook auto-bootstraps task.md, (3) reminder text refactored from CAPS / emphasis markers to factual statements (repetition structure across 9 protocols preserved).

### Added

- **`axiarch-scripts/axiarch-protect-antifull.sh`**（新規）— PreToolUse hook の外出しスクリプト。`Write` tool 呼び出しを傍受し、対象が既存ファイルの場合 `decision: "block"` JSON + exit 2 で物理遮断。`.claude/axiarch-overwrite-allow.txt` で whitelist サポート / NEW: PreToolUse hook script that intercepts `Write` calls; blocks (decision:"block" JSON + exit 2) when the target file already exists. Whitelist via `.claude/axiarch-overwrite-allow.txt`
- **`axiarch-scripts/axiarch-init-task-md.sh`**（新規）— SessionStart hook の外出しスクリプト。会話開始時に task.md の存在を確認、無ければ load-history scaffold で自動生成。常に reminder を `additionalContext` で注入 / NEW: SessionStart hook script that checks for task.md, scaffolds it if missing (with load-history table stub), and always injects a reminder via `additionalContext`
- **`axiarch-scripts/check-axiarch-health.sh` Check 11 / Check 12 追加** — 12 段階診断に拡張。Check 11 = PreToolUse hook の配線確認、Check 12 = SessionStart hook の配線確認 / Diagnostic extended to 12 stages: Check 11 = PreToolUse wiring, Check 12 = SessionStart wiring

### Changed

- **`.claude/settings.json`** — 3 hook 配線（SessionStart / UserPromptSubmit / PreToolUse(Write matcher)）。SessionStart と PreToolUse が新規追加 / Three-hook wiring: SessionStart, UserPromptSubmit, PreToolUse with `Write` matcher
- **`axiarch-scripts/axiarch-boot-reminder.sh` reminder 文の事実陳述化リファクタ** — CAPS / `🚨【厳守命令】` / `No skipping` 等の強圧表現を排除し、`This project enforces axiarch governance` のような事実陳述に統一。Anthropic 公式ガイドおよび Robert Glaser 「Prompts as Programs in GPT-5」に基づく科学的最適化。9 protocols 反復構造は arXiv:2512.14982 の根拠で維持 / Reminder tone refactored from CAPS/imperative to factual statement per Anthropic guidance and Robert Glaser's "Prompts as Programs in GPT-5". Repetition structure preserved per arXiv:2512.14982 (Prompt Repetition Improves Non-Reasoning LLMs)
- **`init.sh`** — `AXIARCH_VERSION` 1.5.4 → 1.5.5
- **`llms-full.txt`** — Version 1.5.4 → 1.5.5

### Compatibility

- ✅ **後方互換性を維持** — 既存 hook (`UserPromptSubmit`) は維持、新 hook 追加のみ。fallback 採用先で新 hook が動かなくても既存挙動は変わらない
- ✅ **依存追加なし** — pure bash 実装、`jq` は optional（grep + sed フォールバック完備）
- ✅ **`.claude/axiarch-overwrite-allow.txt` で whitelist 拡張** — 自動生成 build artefact 等で正当な full-overwrite が必要な場合の escape hatch
- ⚠️ **採用先で `init.sh` 再実行が必要** — `chmod +x` で新 hook scripts に実行権限が付与される
- 📌 **アップグレード手順** — `git pull && bash init.sh` 再実行 OR 手動で `.claude/settings.json` + `axiarch-scripts/axiarch-{protect-antifull,init-task-md}.sh` をコピー + `chmod +x`

### Diagnostic Outcome

- **Mock test verification**:
  - 既存ファイルへの `Write` → JSON `{"decision":"block",...}` + stderr message + exit 2 で物理遮断 ✅
  - 新規ファイルへの `Write` → allow (exit 0) ✅
  - `Edit` tool → allow (exit 0)、Write 以外は無干渉 ✅
  - SessionStart hook → 正常 JSON 出力で additionalContext 注入 ✅
- **axiarch repo against itself**: 全 12 段階 PASS（Check 11/12 含む）
- **学術裏付けスコア**:
  - PreToolUse block: arXiv:2503.18666 (AgentSpec, ICSE'26) で 90%+ 阻止実証
  - SessionStart bootstrap: arXiv:2502.15851 (Control Illusion) の instruction-hierarchy 失敗を構造的回避
  - Tone refactor: Anthropic 公式 + Robert Glaser、9 protocols 反復は arXiv:2512.14982 で保持

### References

- 4-agent market research transcript（本リリース commit body 参照）
- arXiv:2503.18666 — AgentSpec: Customizable Runtime Enforcement for AI Agents (ICSE'26)
- arXiv:2502.15851 — Control Illusion: failed instruction hierarchies in LLMs
- arXiv:2512.14982 — Prompt Repetition Improves Non-Reasoning LLMs
- arXiv:2412.16339 — Deliberative Alignment (OpenAI)
- arXiv:2412.14093 — Alignment Faking (Anthropic)
- arXiv:2310.01798 — Huang et al.: LLMs Cannot Self-Correct Reasoning Yet
- Anthropic Claude Code Hooks: <https://code.claude.com/docs/en/hooks>

---

## [1.5.4] — 2026-05-06

### 🩹 健全性診断スクリプトの v1.5.3 互換性 patch / Health-Diagnostic Compatibility Patch for v1.5.3

v1.5.3 で `.claude/settings.json` の hook command を inline `printf JSON` から `bash "${CLAUDE_PROJECT_DIR:-.}/axiarch-scripts/axiarch-boot-reminder.sh"` に**外出し化**したことで、`axiarch-scripts/check-axiarch-health.sh` の Check 3 (`AXIARCH BOOT` marker grep) と Check 4 (`UserPromptSubmit hook success` grep) が**誤検出**を起こす状態になっていた。本 patch は両 check を v1.5.2/v1.5.3 双方の format に対応させる pure 互換性修正。

After v1.5.3 externalized the hook command, `axiarch-scripts/check-axiarch-health.sh` Check 3 (inline marker grep) and Check 4 (legacy `success` log grep) produced **false negatives** on freshly-installed v1.5.3 projects. This patch makes both checks compatible with both v1.5.2 (inline) and v1.5.3+ (externalized) formats.

### Fixed

- **Check 3 — `AXIARCH BOOT` marker detection** — Hook command が `axiarch-boot-reminder.sh` を呼ぶ場合、スクリプト本体に `AXIARCH BOOT` が含まれることを確認するフォールバック分岐を追加。inline 形式 (v1.4.0–v1.5.2) と externalized 形式 (v1.5.3+) の両方をパスできるようになった / Added fallback branch that inspects the externalized script for the `AXIARCH BOOT` literal when the hook command delegates to `axiarch-scripts/axiarch-boot-reminder.sh`
- **Check 4 — Session firing history grep pattern** — v1.5.2+ の transcript JSONL では hook 出力ラベルが `UserPromptSubmit hook success` から `UserPromptSubmit hook additional context` に変わっていたため、grep を `grep -cE "UserPromptSubmit hook (success|additional context)"` に拡張 / Expanded grep to match both legacy and current transcript labels (`success` ⇄ `additional context`)
- **`axiarch-scripts/axiarch-boot-reminder.sh` のコメントから version literal 除去** — `# Static base reminder (..., identical content to v1.5.1/v1.5.2)` は汎用ファイルへのバージョン記述ポリシー違反だったため version-free に書き換え / Removed `v1.5.1/v1.5.2` literal from the externalized reminder script's header comment to comply with the version-string-policy
- **`axiarch-scripts/check-axiarch-health.sh` の `print_info` ランタイム出力から version literal 除去** — Check 3 fail-path の helper メッセージから `(v1.5.3+ uses ...)` を削除（採用先のランタイム出力は version-free を厳守） / Removed `(v1.5.3+ ...)` literal from a runtime-visible `print_info` line in the diagnostic
- **`README.md` 必須ファイル表に `axiarch-boot-reminder.sh` 言及追加** — v1.5.3 で新規追加されたが必須ファイル表で言及漏れだった件を訂正 / Added the missing reference to `axiarch-boot-reminder.sh` in the required-files table
- **`axiarch-scripts/check-axiarch-health.sh` Check 3 の else 分岐に `EXIT_CODE=1` 追加（false-negative 修正）** — v1.5.1 で導入された Check 3 の else 分岐（hook command が `AXIARCH BOOT` literal も `axiarch-boot-reminder.sh` 文字列も含まない hook 完全破損状態）で `print_warn` だけ出力して `EXIT_CODE=1` を設定していなかった bug。CI 連携で false negative（hook 壊れているのに exit 0）になる致命的問題。18 ラウンド調査で発見・修正 / Critical false-negative fix: Check 3's else branch (hook command lacks both `AXIARCH BOOT` and `axiarch-boot-reminder.sh` literals — i.e. completely broken hook) was emitting `print_warn` without setting `EXIT_CODE=1`, causing CI integrations to falsely report success on a broken hook. Discovered in the 18th-round audit

### Changed

- **`init.sh`** — `AXIARCH_VERSION` 1.5.3 → 1.5.4
- **`llms-full.txt`** — Version 1.5.3 → 1.5.4
- **`axiarch-rules/{ja,en}/blueprint/core/010_project_lessons_log.md`** — Initial entry のみ保持（axiarch 本体は OSS template のため、axiarch 開発側で得た lesson は本ファイルに残さず CHANGELOG / ROADMAP / commit body に記録する方針）。v1.5.4 中間 commit で誤って開発側 lesson を結晶化した記述があったが本 release で訂正 / Kept the Initial entry only — axiarch is an OSS template, so lessons learned by axiarch maintainers are recorded in CHANGELOG / ROADMAP / commit bodies, not in this template file. An interim mistake (crystallizing a maintainer-side lesson here) was reverted in this release

### Compatibility

- ✅ **後方互換性を維持** — v1.4.0〜v1.5.2 の inline format も依然 PASS。配布済みスクリプトは `git pull && bash init.sh` で再配布可能
- ✅ **依存追加なし** — pure bash 修正のみ
- 📌 **アップグレード手順** — 採用先で `bash axiarch-scripts/check-axiarch-health.sh` を再実行し、Check 3/4 が PASS することを確認

### Diagnostic Outcome

- **v1.5.3 リグレッションの確認**: 本 axiarch リポジトリで Check 3 が「Hook command does not contain AXIARCH BOOT」、Check 4 が「Hook never fired」を誤検出。`bash axiarch-scripts/check-axiarch-health.sh` を実行し両 PASS 化を実証
- **設計反省**: hook command を externalize する変更時、診断スクリプトの grep 対象も同時更新する責務を見落としていた。今後は format 変更を伴う patch と diagnostic update をセットでリリースする運用に切り替え

### References

- v1.5.3 で外出し化した script: `axiarch-scripts/axiarch-boot-reminder.sh`
- v1.5.2 で format 変更された hook 出力ラベル: `additionalContext` (cf. <https://code.claude.com/docs/en/hooks#hookspecificoutput>)

---

## [1.5.3] — 2026-05-06

### 🛡️ 動的違反検出 reminder + v1.5.2 記述の honesty 修正 / Dynamic Violation-Detection Reminder + v1.5.2 Honesty Correction

v1.5.2 リリース後、作者から **「v1.5.2 で UI 汚染が十分に低減していない」「ルール厳守も強くなっていない」** との指摘。実態確認の結果、(1) 公式 docs の「more discretely」は format 改善程度で、system-reminder ラップ自体は残ることが判明、(2) v1.5.2 は**形式変更のみ**で AI 遵守強化はなされていなかった。

本 patch は (A) v1.5.2 の honest 化（ROADMAP 修正）と (B) **動的違反検出 reminder** で、AI が毎ターン**現在の違反状況**を自覚できる仕組みを実装。物理 block ではなく「警告強化」の方向で副作用最小化。

After v1.5.2, the author pointed out that (1) UI pollution had not been sufficiently reduced and (2) AI adherence was not strengthened. Investigation confirmed both: official docs' "more discretely" only means format improvement (the `<system-reminder>` wrap remains), and v1.5.2 changed format only, not adherence. This patch corrects v1.5.2 narrative honestly and adds a **dynamic violation-detection reminder** that surfaces current violations every turn.

### Added

- **`axiarch-scripts/axiarch-boot-reminder.sh`**（新規）— UserPromptSubmit hook の外出しスクリプト。毎ターン以下を動的検出し、違反時は reminder に 🚨 フラグを追記:
  - **Check A**: `task.md` にロード履歴（AGENTS.md / INDEX.md / LOADING_PROTOCOL.md 参照）が未記録
  - **Check B**: `axiarch-rules/{ja,en}/blueprint/core/010_project_lessons_log.md` で 3 件以上溜まったドメイン（CRYSTALLIZATION §5 違反）
  - JSON 出力は pure bash で `jq` 依存なし
  / NEW: Externalized hook script that dynamically appends 🚨 violation flags when (A) `task.md` lacks load history or (B) crystallization threshold is breached. Pure bash JSON output (no `jq`)

### Changed

- **`.claude/settings.json`** — `command` を inline `printf JSON` から `bash "${CLAUDE_PROJECT_DIR:-.}/axiarch-scripts/axiarch-boot-reminder.sh"` に簡素化。settings.json 自体がスリムに / Hook command externalized; settings.json itself becomes much slimmer
- **`ROADMAP.md` v1.5.2 記述を honest 化** — 「Plan mode 表示汚染を解消」「`<system-reminder>` でラップされない」が誤りだったため修正。実態は「format クリーン化（system-reminder ラップ自体は残る）」 / Honesty fix: removed overstated claims, clarified that `<system-reminder>` wrap remains
- **`init.sh`** — `AXIARCH_VERSION` 1.5.2 → 1.5.3
- **`llms-full.txt`** — Version 1.5.2 → 1.5.3

### Compatibility

- ✅ **後方互換性を維持** — フックメッセージのコア内容は v1.5.1 から変わらず（VIOLATION フラグは違反時のみ追記）
- ✅ **依存追加なし** — pure bash で JSON 構築、`jq` 不要
- ✅ **物理 block 不採用** — `decision: "block"` で prompt 遮断する選択肢もあったが、副作用が大きいため警告強化に留めた
- ⚠️ **採用先で `axiarch-boot-reminder.sh` の実行権限が必要** — `init.sh` の `chmod +x` ロジックで自動付与される
- 📌 **アップグレード手順** — `git pull && bash init.sh` 再実行、または手動で `.claude/settings.json` と `axiarch-scripts/axiarch-boot-reminder.sh` をコピー

### Diagnostic Outcome

- **v1.5.2 の効果評価**: format クリーン化のみ（success ラベル → additional context ラベル変更）。**Plan mode UI への表示自体は残る**（system-reminder ラップ仕様による）
- **v1.5.3 の遵守強化**: AI が毎ターン違反状況を自覚 → 静的 reminder 単独より遵守率向上が期待できる（物理強制ではないが「観測可能性」の段階的進化）
- **v1.6.0 候補**: `decision: "block"` による prompt-level 物理強制（ただし副作用大）

### References

- 公式 docs: [Claude Code Hooks](https://code.claude.com/docs/en/hooks) — `hookSpecificOutput.additionalContext` 仕様
- 関連: v1.5.2 の「discretely」誤解釈を訂正

---

## [1.5.2] — 2026-05-06

### 🪶 Hook Output 形式変更 — discrete injection で Plan mode 汚染解消 / Hook Output Format Switched to Discrete Injection

v1.5.1 リリース後、作者から **「プラン表示形式が汚くなる」「ロードしたルールがプラン・タスクに表示されない」** との指摘。3 並列調査の結果、**`echo` 出力（transcript 全表示）方式に起因する UI 汚染** と判明。公式 docs (code.claude.com/docs/en/hooks) 推奨の **`hookSpecificOutput.additionalContext` JSON 形式** に切り替え、reminder を context に discrete に注入することで解消。

After v1.5.1, the author reported "Plan display becomes ugly" and "loaded-rules disclosure mandate is being ignored in plans/tasks". A 3-parallel investigation pinpointed the root cause as **UI pollution from the `echo` (transcript-full-display) output format**. Switched to the official docs-recommended **`hookSpecificOutput.additionalContext` JSON format** for discrete context injection.

### Changed

- **`.claude/settings.json`** — フック `command` を `echo '...'` から `printf '%s' '{...hookSpecificOutput.additionalContext...}'` 形式に変更。公式仕様で「Wrapped in system reminders. The `additionalContext` field is added more **discretely**」と明記された推奨形式に準拠 / Switched the hook `command` from `echo` to `printf '%s' '{...hookSpecificOutput.additionalContext...}'` JSON form, the official-docs-recommended discrete-injection format
- **`init.sh`** — `AXIARCH_VERSION` 1.5.1 → 1.5.2 / Bumped version
- **`llms-full.txt`** — Version 1.5.1 → 1.5.2

### Compatibility

- ✅ **後方互換性を維持** — フックメッセージ内容は v1.5.1 と同等（形式のみ変更）。AI 遵守要求（task.md 記録義務 + CRYSTAL §5 遵守）は維持 / Backward compatibility maintained; reminder content is equivalent to v1.5.1, only the wire format changes
- ✅ **依存追加なし** — `printf` は POSIX 標準。`jq` 不要（v1.5.1 で追加した optional jq バリデーションも維持） / No new dependencies; `printf` is POSIX-standard, no `jq` required
- ✅ **Plan mode 汚染解消** — `additionalContext` は `<system-reminder>` ラップではなく context 直接注入。Plan files / transcript / UI の毎ターン reminder 表示が消える / Plan files / transcript / UI no longer show the bulky reminder text each turn
- ⚠️ **AI への visibility 維持** — context 直接注入のため、AI は同等に reminder を認識（公式 docs で確認済み）/ AI still sees the reminder via context injection
- 📌 **アップグレード手順** — `git pull` + `init.sh` 再実行 OR 手動で `.claude/settings.json` を上書き / Upgrade: `git pull && bash init.sh`, or manually overwrite `.claude/settings.json`

### References

- 公式 docs: [Claude Code Hooks](https://code.claude.com/docs/en/hooks) — `hookSpecificOutput.additionalContext` 仕様
- 関連 commit: v1.5.1（reminder 内容の本格強化）

---

## [1.5.1] — 2026-05-06

### 🛡️ Hook 効果最大化 + 結晶化プロトコル遵守強化 / Hook Efficacy Maximization + Crystallization Adherence Strengthening

v1.5.0 リリース後、作者から「フックが毎回動いていない気がする」「結晶化プロトコルも守られていない（3件以上溜まっても `core/010` に蓄積し続ける）」という 2 つの懸念。共通の真因は **AI 遵守ギャップ** — フックは技術的に発火し、プロトコルもテキストとして存在しているのに、AI が `task.md` 記録を怠り、「`core/010` に追記したから完了」と誤認して Step 5 (THRESHOLD CHECK) をスキップする。

本 patch は **「ドキュメント丸投げではなくツールで遵守を強制する」** 設計に転換：診断スクリプト `axiarch-scripts/check-axiarch-health.sh` を新規配布し、フック発火 / `task.md` 記録 / 結晶化閾値の 3 軸を一発検証可能に。フックメッセージ・CRYSTALLIZATION_PROTOCOL §5 自体も「追記 = 完了は誤認」を明示する形で強化。

After v1.5.0, the author raised two concerns: "the hook seems not to fire every time" and "the Crystallization Protocol is not enforced — lessons keep accumulating in `core/010` past the 3-lesson threshold". The common root cause is the **AI adherence gap** — the hook fires technically and the protocols exist as text, but the AI skips `task.md` logging and mistakes "appended to `core/010`" for completion, never executing Step 5 (THRESHOLD CHECK).

This patch shifts from "documentation hand-off" to **"tool-enforced adherence"**: a new diagnostic script `axiarch-scripts/check-axiarch-health.sh` provides one-shot verification across hook firing, `task.md` adherence, and crystallization threshold. The hook reminder and `CRYSTALLIZATION_PROTOCOL §5` itself are also strengthened to explicitly state "just appending is NOT completion".

### Added

- **`axiarch-scripts/check-axiarch-health.sh`**（新規）— **Axiarch 公式健全性診断ツール（全プロトコル監視）**。`bash axiarch-scripts/check-axiarch-health.sh` で **10 段階の遵守チェック** を一発実行：（1-4）Hook 関連（`.claude/settings.json` 存在・JSON 構文・hook 構造・発火履歴）/ （5）LOADING_PROTOCOL Step 4 遵守（`task.md` ロード履歴）/ （6）CRYSTALLIZATION_PROTOCOL §5 遵守（3件以上のドメイン検出）/ **（7）AGENTS.md §8 Process & Documentation（task.md / implementation_plan.md / walkthrough.md 存在）** / **（8）§1 Deployment Ban（force-push / 直 main commit 検出）** / **（9）§4 SSOT Sync（main 同期状態）** / **（10）§2 Language First（Project Native Language 整合性）**。検証困難な §0/§3/§5/§6/§7 は Out of Scope として明示。`init.sh` で自動配布 / NEW: Official Axiarch health diagnostic with **10-stage protocol-wide compliance check**. Covers hook firing, AI adherence, crystallization threshold, AGENTS §1/§2/§4/§8/§9 + LOADING_PROTOCOL. Surfaces "where the AI is slacking" at a glance. Out-of-scope protocols (§0/§3/§5/§6/§7) explicitly marked for manual review. Auto-distributed by `init.sh`
- **`axiarch-scripts/README.md`**（新規）— scripts/ ディレクトリの索引兼ガイド。各診断ツール（`check-axiarch-health.sh` / `check-git-config-clean.sh`）の目的・使い方・診断項目・推奨ワークフローをバイリンガルで記載。採用者が `axiarch-scripts/` 配下の存在意義を一発で把握できるようにする / NEW: `axiarch-scripts/` index & guide. Bilingual documentation of each diagnostic tool's purpose, usage, check items, and recommended workflow

### Changed

- **`.claude/settings.json`** — `UserPromptSubmit` フックの reminder 文言を強化:
  - **`task.md` 記録義務（AGENTS.md §8.4 準拠）** を追加 / `Record all loaded rule files in task.md per AGENTS.md §8.4`
  - **CRYSTALLIZATION_PROTOCOL Step 5 THRESHOLD CHECK の遵守義務** を追加。「追記 = 完了は誤認」を明示し、3件以上のドメインがあれば Blueprint 専用ファイルへの昇華まで完了させてからタスク完了を宣言する義務を AI に課す / Added mandatory `CRYSTALLIZATION_PROTOCOL §5 THRESHOLD CHECK` execution on task completion; "just appending to `core/010` is NOT completion"
- **`axiarch-rules/{ja,en}/CRYSTALLIZATION_PROTOCOL.md` §5** — 強い CAUTION ブロックを追加。「Step 4 (ACCUMULATE) は完了ではない」「タスク完了前に必ず Step 5 を実行せよ」「違反は `axiarch-scripts/check-axiarch-health.sh` Check 6 で検出可能」を明記 / Added a strong CAUTION block to §5 stating that Step 4 alone is not completion and that Step 5 MUST run before task completion; violations are externally detectable
- **`README.md`** — 「Hook Reinforcement Mechanism」サブセクション直下に **トラブルシュート章**（縮小版・約 10 行）を新設。`bash axiarch-scripts/check-axiarch-health.sh` への誘導、誤情報訂正（`permissions.allow Bash(echo *)` 不要）、公式 docs リンク / Added concise "Troubleshooting" subsection directing users to `axiarch-scripts/check-axiarch-health.sh`
- **`axiarch-rules/{ja,en}/LOADING_PROTOCOL.md`** — 「Hook補強機構」セクションに **診断ツール参照（v1.5.1+）** を追記（`axiarch-scripts/check-axiarch-health.sh` 案内、1 段落）/ Added one-paragraph reference to the diagnostic script
- **`init.sh`** — `AXIARCH_VERSION` 1.5.0 → 1.5.1。`.claude/settings.json` 配布直後に **`jq` による JSON 構文検証**（`jq` 不在時はスキップ、依存追加なし）。`axiarch-scripts/` 既存配布で `check-axiarch-health.sh` も自動配布対象 / Bumped version; added optional `jq` JSON validation post-copy; existing `axiarch-scripts/` distribution covers the new diagnostic
- **`llms-full.txt`** — Version 1.5.0 → 1.5.1

### Compatibility

- ✅ **後方互換性を維持** — 既存採用者は `git pull` + `init.sh` 再実行、または `.claude/settings.json` 手動上書きでアップグレード可能。フック message の文字数は約 600 → 約 1,534 文字（実測トークン換算: ~150 → ~380、**+153%**）に増えるが、プロンプトキャッシュ独立のため影響軽微（毎ターン system reminder として注入）/ Backward compatibility maintained; reminder grows from ~600 to ~1,534 chars (~150 → ~380 tokens, **+153%**), independent of prompt cache so impact remains negligible (injected as system reminder per turn)
- ✅ **Universal Rules 改訂なし** — `core_mindset.md` / `600_git_workflow.md` / `700_appstore_compliance.md` 等の憲法部分は変更なし / No constitutional changes
- ⚠️ **`task.md` の活用前提** — 既存 axiarch 採用者は `task.md` が `.gitignore` 対象（per-session 作業ドキュメント）であることが多い。AI 遵守確認時は手動で開いてロード履歴を確認する運用 / `task.md` is typically gitignored as per-session document; manually inspect for load logs

### Diagnostic Outcome (3 並列調査の結論 / 3-parallel investigation conclusions)

調査で**反証された**説：

- ❌ **JSON 構造誤り説** — 公式 hooks.md の必須ネスト構造に準拠（`{hooks: {UserPromptSubmit: [{hooks: [...]}]}}`）
- ❌ **Bash permission 不足説** — hook の `command` 型は harness が `child_process` で直接 spawn する経路で、`permissions.allow Bash(...)` の審査対象外。本セッション transcript で `hook success` 観測済みの事実が直接否定

採用された真因：

- ✅ **AI 遵守ギャップ** — フックは発火しているが、AI が reminder の指示（AGENTS.md / LOADING_PROTOCOL 暗黙実行・`task.md` 記録）をサボるケースで「動いていない感」が生じる
- ✅ **結晶化プロトコル違反パターン** — 子プロジェクト inucomi の Wave 1-15 実例：「`core/010` への追記 = 結晶化完了」と誤認し、3件以上のドメイン（セキュリティ 27件・パフォーマンス 6件・型安全 5件・a11y 4件・リファクタリング 4件・Server Action 3件 = 6 ドメイン違反）を Blueprint へ昇華せず放置。Step 5 (THRESHOLD CHECK) を一度も実行していなかった

### References

- 公式 docs: [Claude Code Hooks](https://code.claude.com/docs/en/hooks) / [Claude Code Permissions](https://code.claude.com/docs/en/permissions)

---

## [1.5.0] — 2026-05-06

### 🆕 Universal Rules 大規模拡充 + Hook 言語遵守強化 / Major Universal Rules Expansion + Hook Language Enforcement

axiarch v1.4.0 リリース後の累積改修を統合する minor bump。Universal Rules 6 ファイル（`core_mindset.md` / `510_aws_cloud.md` / `600_git_workflow.md` / `700_appstore_compliance.md` / `900_fundraising_ir.md` / `800_internationalization.md`）を 2026 Staff Engineer 基準で大規模拡充。`.claude/settings.json` の `UserPromptSubmit` フックには **Project Native Language 厳守** 指令を追加し、AI が日本語プロジェクトで英語見出し・要約を出すリスクを下げる。

Aggregates the cumulative refactors after the v1.4.0 release. Major expansion of 6 Universal Rule files (`core_mindset.md` / `510_aws_cloud.md` / `600_git_workflow.md` / `700_appstore_compliance.md` / `900_fundraising_ir.md` / `800_internationalization.md`) to 2026 Staff Engineer standards. Enhanced the `UserPromptSubmit` hook in `.claude/settings.json` with an explicit **Project Native Language adherence** directive that reduces the risk of English headings/summaries in Japanese-native projects.

### Added — Universal Rules 拡充（Constitution Amendment）

- **`axiarch-rules/{ja,en}/universal/core/000_core_mindset.md` Rev.14** — §1.14 Post-Quantum Readiness / §1.15 Regulatory Agility / §1.16 Developer Wellbeing & Sustainable Velocity / §1.17 Technology Governance（main の Rev.9 由来）+ §1.18 SBOM & Supply Chain Security / §1.19 AI-Native Test Strategy / §1.20 Evaluation-Driven Development / §1.21 Feature Flag & Progressive Delivery / §1.22 Platform Reliability Engineering / §1.23 Developer Experience as Product / §1.24 Responsible AI Disclosure / §1.25 Data Architecture Sovereignty / §1.26 API Design Governance / §1.27 Green Software Engineering / §1.28 Incident Response & Business Continuity / §1.29 AI Regulatory Compliance Governance / §1.30 Ethical Engineering & Societal Impact / §1.31 Type Safety as Foundation / §1.32 Compositional Architecture / §1.33 Inversion Thinking & Pre-Mortem / §1.34 YAGNI Discipline & Rule of Three / §1.35 Strong Opinions, Weakly Held / Disagree & Commit / §9.8 Model Governance / §9.9 Agentic Workflow Design Patterns / §9.10 AI Cost Governance / §9.11 Computer Use Agent Safety を追加 — 総 46 セクション / Total 46 sections
- **`axiarch-rules/{ja,en}/universal/engineering/510_aws_cloud.md`** — Primary Directive 0.9 Resilience & Chaos Engineering / 0.10 Observability-First / 0.11 Shared Responsibility & Compliance-by-Design / 0.12 Operational Excellence Culture を追加（Directive 0.1〜0.12 構成）/ Added 4 new directives
- **`axiarch-rules/{ja,en}/universal/engineering/600_git_workflow.md`** — 18 ルール / 5 Part → **45 ルール / 10 Part** に大規模拡充。§2.6 Merge Strategy / §2.7 Force-Push Protocol / §2.8 Commit Body & Trailers (AI Co-Authored-By) / §2.9 Fixup・Autosquash / §2.10 Conventional Commit Validation / Part 6 Branch Protection & Code Review (4 rules incl. §6.4 AI-Assisted PR Review) / Part 7 Tags, Releases & History (7 rules incl. §7.6 git maintenance) / Part 8 Repository Configuration & Assets (4 rules incl. §8.3 .git-blame-ignore-revs) / Part 9 Modern Tooling & Automation (5 rules incl. §9.4 Shallow Clone & Sparse Checkout) / Part 10 Anti-Pattern Catalog / Expanded from 18 rules / 5 Parts to 45 rules / 10 Parts
- **`axiarch-rules/{ja,en}/universal/product/700_appstore_compliance.md`** — 5 Part / 101 行 → **20 Part / 約 1,099 行**。Apple Privacy Stack（ATT・Privacy Manifests `PrivacyInfo.xcprivacy`・Required Reason API・Privacy Nutrition Labels）/ StoreKit 2 / Sign in with Apple / Account Deletion 5.1.1(v) / TestFlight・Phased Release・Expedited / Google Play AAB 必須化 / Play Integrity API / 子供向けアプリ（COPPA・GDPR-K）/ DMA Compliance / Generative AI App Compliance / Specialized Verticals（Health/Finance/Crypto/Games） / Expanded from 5 Parts / 101 lines to 20 Parts / ~1,099 lines
- **`axiarch-rules/{ja,en}/universal/product/900_fundraising_ir.md`** — 7 Part / 340 行 → **15 Part / 約 1,110 行**。Cap Table & ESOP 設計 / SAFE / Convertible Note / Bridge / KISS / Term Sheet 数学（Liquidation Preference・Anti-Dilution Full Ratchet vs Weighted Average）/ FEFTA・CFIUS・EU FDI Screening / MNPI / Tax Considerations（QSBS）/ IPO Preparation / M&A Exit / Founder Wellbeing / Investor Tech Stack / Anti-Pattern Catalog / Expanded from 7 Parts / 340 lines to 15 Parts / ~1,110 lines
- **`axiarch-rules/{ja,en}/universal/product/800_internationalization.md` v6.0 → v6.1** — 25 Part / 114 セクション → **29 Part / 133 セクション**。Part XXVI 2026 規制フロンティア（EU AI Act Article 50/13/11/52・India DPDP Schedule 1 22 言語・Saudi/UAE PDPL Arabic 義務・China PIPL/HK PDPO/Taiwan PDPA・LATAM/Africa: LGPD/LFPDPPP/POPIA/NDPA）/ Part XXVII 新興UXパラダイム（AR/XR・WebXR・Generative UI 多言語・CRDT Yjs/Automerge・Shadow DOM/Web Components 境界・Foldable/Wearable/CarPlay）/ Part XXVIII 翻訳品質フロンティア（MQM ASTM F2575 deep dive・Constrained Decoding・xCOMET-22/CometKiwi・Domain Adaptation・Translation Safety Classifiers）/ Part XXIX 危機対応・レジリエンス（多言語インシデント・緊急通信・TMSフェイルオーバー・多言語VDP）/ Expanded from 25 Parts / 114 sections to 29 Parts / 133 sections

### Changed

- **`.claude/settings.json`** — `UserPromptSubmit` フックの system reminder メッセージに `Output language MUST follow Project Native Language in AGENTS.md (headings, summaries, labels, lists, tables — all)` / `応答言語は AGENTS.md の Project Native Language に厳守（見出し・要約・ラベル・箇条書き・表すべて）` を追加。AI が日本語プロジェクトで英語見出し・要約・ラベルを出すサボりを物理的に防止 / Hook reminder now explicitly enforces `Project Native Language` adherence for all output structures, physically blocking the language-mixing failure mode
- **`axiarch-rules/{ja,en}/INDEX.md`** — 拡充された Universal Rules（000_core_mindset / 510_aws_cloud / 600_git_workflow / 700_appstore_compliance / 800_internationalization / 900_fundraising_ir）の説明欄を全件更新 / All affected INDEX entries updated
- **`init.sh`** — `AXIARCH_VERSION` 1.4.0 → 1.5.0 / Bumped version
- **`README.md`** — Version バッジは GitHub Releases 連動で自動更新 / Version badge auto-updates via GitHub Releases
- **`ROADMAP.md`** — 安定版 v1.4.0 → v1.5.0、JA/EN リリース履歴追記、旧「v1.5.0 検討中」セクションを v1.6.0 に繰り下げ / Stable bumped, history added, prior "v1.5.0 (under consideration)" section deferred to v1.6.0
- **`llms-full.txt`** — Version 1.4.0 → 1.5.0

### Compatibility

- ✅ **後方互換性を維持** — Universal Rules の拡充は既存ルール非破壊・純粋追補。既存採用者は `git pull` のみで取得可能 / Backward compatibility maintained: all expansions are additive; existing adopters obtain new rules via `git pull`
- ✅ **既存ファイルレイアウト変更なし** — `init.sh` / 配布物の構造は v1.4.0 と同一 / No layout changes; distribution structure identical to v1.4.0
- ⚠️ **トークンコスト** — Universal Rules 大規模拡充により、関連タスク（Git workflow / appstore / fundraising / i18n）でのロード時のトークン量が増加。`task.md` 記録義務 + LOADING_PROTOCOL の Step 2 自律選択により、必要セクションのみのオンデマンドロードを推奨 / Token cost rises during related-task loading; mitigate via on-demand section selection per LOADING_PROTOCOL Step 2
- ⚠️ **フックメッセージサイズ** — system reminder に約 60 トークン追加（前バージョン比 +75%）。プロンプトキャッシュとは独立だが影響軽微 / Hook reminder grows by ~60 tokens (+75% over prior); negligible impact independent of prompt cache
- 📌 **アップグレード手順** — `git pull` → `init.sh` 再実行（フックメッセージ更新を取得するため必須）/ Upgrade: `git pull` then re-run `init.sh` (mandatory to pick up the new hook reminder)

### References

- PR #25 — `feat: Universal core_mindset Rev.9 + AWS Cloud Directives 0.9-0.12`
- PR #26 — `feat: core_mindset Rev.14 (46 sections) + 600_git_workflow expansion (10 parts / 45 rules)`
- PR #27 — `feat: deep expansion of 700_appstore_compliance + 900_fundraising_ir + 800 v6.1 + hook language enforcement`

---

## [1.4.0] — 2026-05-04

### 🆕 Claude Code Hook Reinforcement Mechanism — UserPromptSubmit Hook / Claude Code Hook補強機構

Claude Code 採用プロジェクトに `UserPromptSubmit` フックを標準同梱し、AI のプロトコル遵守を物理的に強制する。`AGENTS.md` / `LOADING_PROTOCOL.md` が「指示書」止まりだった問題を解消し、軽い会話でもサボりを許さない設計へ転換。

Adds a standard `UserPromptSubmit` hook to Claude Code projects, physically enforcing AI protocol adherence. Closes the gap where `AGENTS.md` / `LOADING_PROTOCOL.md` were "instructions" without enforcement, so even casual prompts cannot bypass the protocol.

### Added

- **`.claude/settings.json`**（新規）— `UserPromptSubmit` フック定義。バイリンガル system reminder（en + ja）を**毎ユーザープロンプト送信時**に注入し、AI に AGENTS.md プロトコル＋LOADING_PROTOCOL の BOOT SEQUENCE 実行を強制 / NEW: `UserPromptSubmit` hook with bilingual system reminder injected on every prompt, compelling AI to execute AGENTS.md + LOADING_PROTOCOL BOOT SEQUENCE
- **`axiarch-rules/{ja,en}/LOADING_PROTOCOL.md`** — 「🛡️ Hook補強機構（ENFORCEMENT MECHANISM）」セクションを BOOT SEQUENCE 直後に追加。フック削除を「憲法改正」レベルと明記 / Added "🛡️ Hook Reinforcement Mechanism" section right after BOOT SEQUENCE; declares hook removal as a constitution-amending change
- **`README.md`** — Quick Start に「Claude Code Hook補強機構 / Hook Reinforcement Mechanism (v1.4.0+)」サブセクション、必須ファイル表に `.claude/settings.json` 行追加 / New "Hook Reinforcement Mechanism" subsection in Quick Start; new row in Required Files table

### Changed — Universal Constitution（憲法改正）

- **`axiarch-rules/{ja,en}/universal/engineering/600_git_workflow.md`** §5.1 — `.gitignore` 例示を `.claude/` 全無視 → `.claude/worktrees/` / `.claude/projects/` / `.claude/settings.local.json` の3項目に細分化（**汎用的な Claude Code best practice として記述、Axiarch 固有要素は含めず**）。Universal Rule の修正は AGENTS.md §5「既存機能保護プロトコル」例外条項に基づきユーザー明示承認の上で実施 / Refined `.gitignore` example in §5.1 from blanket `.claude/` ignore to granular `worktrees/` / `projects/` / `settings.local.json` (described as **generic Claude Code best practice; intentionally omits Axiarch-specific framework details**). Constitutional amendment performed under the §5 exception clause with explicit user approval
- **`axiarch-rules/{ja,en}/universal/engineering/600_git_workflow.md`** メタデータ — `Last Updated: 2026-05-03 (v1.3.2)` → `2026-05-04 (v1.4.0)` / Metadata bump

### Changed

- **`CLAUDE.md`** — 行 3 の `@AGENTS.md` import を削除。フック経由の Read ロード（`view_file` 履歴付与・`task.md` 記録発火）に統一し、Anti-Laziness Rule との整合を確保 / Removed `@AGENTS.md` import on line 3; unified loading via the hook-driven Read flow (preserves `view_file` history and triggers `task.md` recording), aligning with the Anti-Laziness Rule
- **`.gitignore`** — `.claude/` 全無視を `.claude/worktrees/` / `.claude/projects/` / `.claude/settings.local.json` の3項目に分解。`.claude/settings.json`（チーム共有設定）をコミット可能に / Refined: now ignores only worktrees/projects/local settings, allowing `.claude/settings.json` (team-shared config) to be committed
- **`init.sh`** — `AXIARCH_VERSION` 1.3.2 → 1.4.0 / `SETUP_CLAUDE` 分岐で `.claude/settings.json` を配布。**非 Claude Code エージェント選択時の cleanup は `.claude/settings.json`（Axiarch 配布物）のみ削除し、ユーザーの `worktrees/` / `projects/` / `settings.local.json` 等のセッションデータは温存**（`.claude/` フォルダは中身が空のときのみ rmdir）/ Bumped version; `SETUP_CLAUDE` now distributes `.claude/settings.json`; non-Claude-Code cleanup removes only the Axiarch-distributed `.claude/settings.json` and preserves user session data (`worktrees/` / `projects/` / `settings.local.json`); `.claude/` directory is rmdir'd only if empty
- **`README.md`** — Agent-Specific Setup 表 Step 3 を「`CLAUDE.md` + `.claude/settings.json` 配置」に更新、Step 2 コード例に `.claude/settings.json` コピー手順追加 / Updated Agent-Specific Setup table Step 3 and Step 2 manual-copy code block
- **`ROADMAP.md`** — 安定版 v1.3.2 → v1.4.0、JA/EN リリース履歴追記 / Stable version updated, history entries added
- **`llms-full.txt`** — Version 1.3.2 → 1.4.0

### Compatibility

- ✅ **後方互換性を維持** — 既存 v1.3.x 採用プロジェクトは `.claude/settings.json` 不在でも従来通り動作（フックなし、AI 自律遵守モード）/ Backward compatibility maintained: existing v1.3.x adopters work without the hook (autonomous-enforcement mode)
- ✅ **Claude Code 限定機能** — Antigravity / Codex / Cursor / Copilot / Windsurf には影響なし（各自が固有のロード機構を持つため）/ Claude Code-only feature; no impact on other agents (each has its own native loading mechanism)
- ⚠️ **`@AGENTS.md` import 削除の影響** — Claude Code はフック経由で AGENTS.md を Read するため挙動は強化される（`view_file` 履歴付与・`task.md` 記録発火）。挙動の劣化なし / Removing `@AGENTS.md` strengthens behavior: hook drives explicit Read, populating `view_file` history and triggering `task.md` recording. No regression
- ⚠️ **トークンコスト** — 毎プロンプトに ~80 トークンの system reminder 追加。プロンプトキャッシュとは独立だが影響無視可能 / Adds ~80 tokens per prompt as a system reminder; independent of prompt cache but negligible impact
- 📌 **アップグレード手順** — `git pull` → `init.sh` 再実行 OR 手動で `.claude/settings.json` を配置 / Upgrade: `git pull` then re-run `init.sh`, or manually place `.claude/settings.json`

### References

- 議論の出典: inucomi（子プロジェクト）でユーザーと検討 / Discussion origin: inucomi child-project session

---

## [1.3.2] — 2026-05-03

### 🆕 Universal Engineering 600 新設 + Git Workflow Refactor + Worktree Hygiene Protocol / Universal Engineering 600 + Git Workflow Refactor + Worktree Hygiene Protocol

axiarch を採用する全プロジェクトに Git Workflow と `.git/config` 健全性管理を恒常的に提供する Universal ルールを追加。`axiarch-scripts/check-git-config-clean.sh` を OSS 採用者全員へ配布。`engineering/000` Part X の pure-git workflow を新ファイル `engineering/600_git_workflow.md` に集約（YAGNI 原則に基づく構造正規化）。

Adds a Universal rule providing Git Workflow and `.git/config` integrity management to all axiarch-adopting projects. Distributes `axiarch-scripts/check-git-config-clean.sh` to OSS adopters. Consolidates pure-git workflow from `engineering/000` Part X into the new `engineering/600_git_workflow.md` file (YAGNI-based structural normalization).

### Added

- **`axiarch-rules/{ja,en}/universal/engineering/600_git_workflow.md`**（新規 Universal Rule）— **5パート・18ルール**: Trunk-Based Development (§1) / Commit & PR Standards (§2) / Branch Hygiene Mandate (§3) / **Worktree Hygiene Protocol (§4)** — `[extensions] worktreeConfig = true` 残留問題（Antigravity の Go ベース language server クラッシュ・`ECONNREFUSED 127.0.0.1:50347`）の検出・修復・予防 / Repository Hygiene & Config Integrity (§5)。クロスリファレンス（security/operations/quality 等）・逆引き索引付き / **NEW Universal Rule** with 5 parts, 18 rules covering daily Git workflow including the **Worktree Hygiene Protocol** that documents the `worktreeConfig` residue problem (Antigravity Go-based language server crash) detection/repair/prevention
- **`axiarch-scripts/check-git-config-clean.sh`** — `.git/config` の自動検出・修復スクリプト（`--fix` / `--quiet` / `--full-clean` モード対応、現在ブランチ自動除外）/ Auto-detection & repair script for `.git/config` with `--fix`, `--quiet`, `--full-clean` modes (auto-excludes current branch)
- **`init.sh`** に `axiarch-scripts/` ディレクトリ配布ロジック追加 — axiarch 採用と同時に `check-git-config-clean.sh` が自動配布される / Added `axiarch-scripts/` distribution logic so adopters automatically receive `check-git-config-clean.sh`

### Changed — Universal Engineering Restructure

- **`engineering/000_engineering_standards.md`** Part X 構造変更:
    - **§10.0 Trunk Based Development → 600 §1 へ移動** / Moved to 600 §1
    - **§10.1 Commit & PR Standards → 部分移動**: Conventional Commits / Atomic Commits / PR Template / 100行ルール / Husky / lint-staged / Branch Hygiene を 600 §2 へ移動。**残置**: CI Timeout / Red Button Checklist / Omnichannel Check / Deployment Safety Protocol / Security secrets / Lockfile Regen / Connection Verification（§10.1 を **CI/Deployment Safety Standards** に改題） / Partial migration: pure-git items moved to 600 §2; CI/deploy items remain (renamed to "CI/Deployment Safety Standards")
    - **§10.3 The Branch Hygiene Mandate → 600 §3 へ移動** / Moved to 600 §3
    - **§10.2 IPv6 / §10.4 Migration Immutability / §10.5 Version Alignment / §10.6 Zod Nullable** は暫定的に Part X に残置（v1.4.x 以降に `engineering/200_supabase_architecture.md` または `engineering/300_web_frontend.md` への再配置を検討）/ §10.2 IPv6 / §10.4 Migration / §10.5 Version Alignment / §10.6 Zod Nullable transitionally retained in Part X (relocation candidates for v1.4.x+)
    - **Part X タイトル変更**: 「Git とバージョン管理」→「**CI/Deploy & 補助規約**」 / Part X title changed from "Git & Version Control" to "**CI/Deploy & Auxiliary Standards**"
    - 上部 overview テーブル更新: `§10.0–§10.6 / 7 ルール` → `§10.1, §10.2, §10.4–§10.6 / 5 ルール`、合計 147 → 145 / Top overview table updated

### Changed — Documentation & Index

- **`axiarch-rules/{ja,en}/INDEX.md`** — engineering 一覧に 600 を追加 / Added 600 entry to engineering listing
- **`README.md`** — Universal Rules バッジ `38_files` → `39_files` / Engineering ファイル数 9 → 10 / Universal Rules count badge `38_files` → `39_files`, Engineering file count 9 → 10
- **`llms-full.txt`** — engineering count 9 → 10 / Version: 1.3.1 → 1.3.2
- **`ROADMAP.md`** — 安定版 v1.3.1 → v1.3.2、JA/EN 両セクションにリリース履歴追加 / Stable version updated, history entries added
- **`init.sh`** — AXIARCH_VERSION 1.3.0 → 1.3.2

### Compatibility

- ✅ **後方互換性を維持** — 既存採用プロジェクトは pull するだけで新ルールと script を取得 / Backward compatibility maintained — existing adopters just `git pull`
- ✅ **誰にとっても無害** — Claude Code 単体 / Antigravity 単体 / 並行使用、3シナリオ全てで Pareto-improvement / Pareto-improvement across all three scenarios (Claude Code only / Antigravity only / parallel use)
- ⚠️ **構造的注記**: `engineering/000` Part X の §10.0 / §10.3 は削除されました。外部ドキュメントから §10.0 / §10.3 への直接参照がある場合、`600_git_workflow.md` §1 / §3 へ更新してください / §10.0 / §10.3 in `engineering/000` Part X have been removed. Update any external references to point to `600_git_workflow.md` §1 / §3
- 📌 **将来の課題**: Part X §10.4 / §10.5 / §10.6 は本来ドメイン固有のため `engineering/200_supabase_architecture.md` または `engineering/300_web_frontend.md` への移動候補（v1.4.x で再配置検討）/ §10.4 / §10.5 / §10.6 are domain-specific and candidates for relocation in v1.4.x

### References

- Antigravity recurrence first detected: 2026-04-29 (inucomi project) / Resolved: 2026-05-03 with cross-project lesson crystallization to axiarch Universal
- Related lesson source: `inucomi` project commit `c649896e` (Blueprint level)

---

## [1.3.1] — 2026-05-03

### ✨ Claude Code `@import` 統合 / Claude Code `@import` Integration

### Added

- **`CLAUDE.md`** — `@AGENTS.md` import 構文を追加。Claude Code 起動時に AGENTS.md（最上位プロトコル・9プロトコル）全文が system prompt へ自動 inline され、BOOT SEQUENCE PROTOCOL の初動遵守を補強。AI の自律的な Read tool 実行だけに依存しない形で初動プロトコルを参照しやすくする / Added `@AGENTS.md` import syntax. AGENTS.md (Top-Level Protocol / 9 protocols) is now auto-inlined into the system prompt at Claude Code session start, reinforcing BOOT SEQUENCE PROTOCOL without relying only on the AI to autonomously read it. Reference: <https://code.claude.com/docs/en/memory.md#import-additional-files>

### Compatibility

- 後方互換性を維持。Claude Code 専用機能のため、他エージェント（Cursor / Copilot / Windsurf / Antigravity / Codex）には影響なし / Backward compatibility maintained. Claude Code-specific feature — no effect on other agents
- トークン消費: 新規セッション開始時のみ +約 8K tokens（メッセージ毎の追加消費なし） / +~8K tokens at session start only (zero per-message overhead)

---

## [1.3.0] — 2026-04-30

### 🏗️ バイリンガル構造リアーキテクチャ / Bilingual Directory Re-Architecture

ディレクトリ構造を「言語ファースト」に全面移行。全ポインター・プロンプト・設定ファイルのクロスリファレンスを同期更新。156ファイル変更。

Directory structure fully migrated to "Language-First" layout. All pointer, prompt, and config file cross-references synchronized. 156 files changed.

### Changed — Directory Structure (Breaking)

- **`axiarch-rules/` ディレクトリ構造の全面再編** — 旧 `axiarch-rules/universal/{ja,en}/` → 新 `axiarch-rules/{ja,en}/universal/`、旧 `axiarch-rules/blueprint/{ja,en}/` → 新 `axiarch-rules/{ja,en}/blueprint/` へ移行。言語選択時のディレクトリ削除が `rm -rf axiarch-rules/en` の1コマンドで完了するシンプルな構造に / Restructured from `axiarch-rules/universal/{lang}/` to `axiarch-rules/{lang}/universal/`. Language cleanup now requires a single `rm -rf` command
- **`axiarch-rules/*.md` → `axiarch-rules/{ja,en}/*.md`** — `INDEX.md`, `LOADING_PROTOCOL.md`, `CRYSTALLIZATION_PROTOCOL.md`, `README.md`, `compliance_matrix.md` を各言語フォルダ直下に移動。言語ごとの完全自己完結を実現 / Moved infrastructure files into each language folder for full self-containment

### Added

- **`CLAUDE.md`** — Claude Code固有のポインターファイル（独立Markdown）を新規追加。旧シムリンク方式から独立ポインターファイルに変更 / Added Claude Code-specific pointer file (independent Markdown). Replaced former symlink approach with standalone pointer file
- **OpenAI Codex サポート / OpenAI Codex Support** — OpenAI Codex が `AGENTS.md` をネイティブに読み込む特性に基づき、互換性リストに公式追加。追加のポインターファイル不要で自動動作する旨をドキュメント（`README.md`, `ROADMAP.md`, `llms.txt`, `llms-full.txt`）および `init.sh` に反映 / Officially added OpenAI Codex to the compatibility list as it natively supports `AGENTS.md`. Updated documentation and `init.sh` to reflect that it requires no additional pointer files

### Changed — Cross-Reference Updates (46 files)

- **`AGENTS.md`** — 全パス参照を新構造（`{lang}/universal/`, `{lang}/blueprint/`）に更新 / All path references updated to new structure
- **`README.md`** — Claude Code記述を「シムリンク」→「ポインターファイル」に修正、ディレクトリ構造図を新構造に更新 / Claude Code description corrected from "symlink" to "pointer file", directory structure diagram updated
- **ポインターファイル 5種** — `.agents/rules/prompt_pointer.md`, `.cursor/rules/axiarch.mdc`, `CLAUDE.md`, `.windsurfrules`, `.github/copilot-instructions.md` を新構造に同期 / All 5 pointer files synchronized to new structure
- **`axiarch-prompts/` 全16本 × 2言語** — プロンプト内のパス参照を新構造に更新 / All prompt path references updated
- **`init.sh`** — 新ディレクトリ構造に対応するようセットアップスクリプトを更新 / Setup script updated for new directory structure
- **`.github/CODEOWNERS`** — パス定義を新構造に更新 / Path definitions updated
- **`.github/workflows/lint.yml`** — 対称性チェックのパスを新構造に更新 / Symmetry check paths updated
- **`.github/PULL_REQUEST_TEMPLATE.md`** — バイリンガル要件の記述を新構造に更新 / Bilingual requirement description updated
- **`.github/ISSUE_TEMPLATE/bug_report.yml`** — パス参照を新構造に更新 / Path references updated
- **`CONTRIBUTING.md`** — パス表記を新構造に更新 / Path notation updated
- **`llms.txt`** — Claude Code記述を「symlink」→「reads CLAUDE.md pointer file」に修正 / Claude Code description corrected
- **`llms-full.txt`** — バージョン表記を1.3.0に更新、Claude Code記述を「symlink」→「pointer file」に修正 / Version updated to 1.3.0, Claude Code description corrected

---

## [1.2.0] — 2026-04-29

### 🏛️ Universal Rules v2.0 大規模ブラッシュアップ / Blueprint 構造正規化

60ファイル変更、59,670行追加の大規模アップデート。全19 Universal Rules を2026 Staff Engineer ガバナンス基準に準拠する網羅的フレームワークへ拡張。Blueprint を YAGNI 原則に基づき正規化。

60 files changed, 59,670 insertions. All 19 Universal Rules expanded to comprehensive frameworks aligned with 2026 Staff Engineer governance standards. Blueprint normalized based on YAGNI principle.

### Changed — Universal Rules (19 files × 2 languages = 38 files)

- **`product/400_pricing_strategy.md`** — 17パート・180+ルールの包括的フレームワークへ拡張。AI-Native Monetization（Agentic ROI・Edge AI・Consumption-Based Commitment）、Quantum-Safe Pricing、Vertical AI Compliance、Green AI Pricing、Sovereign AI Pricing を統合 / Expanded to 17-part, 180+ rule framework with AI-Native Monetization, Quantum-Safe Pricing, and global regulatory alignment
- **`product/500_growth_marketing.md`** — 23パート・120+セクションの v3.0 へ拡張。AI-Native Growth、Community-Led Growth、Paid Acquisition Governance、Growth FinOps、Zero-Party Data Strategy、ASO、EU AI Act 透明性プロトコルを統合 / Expanded to 23-part v3.0 with AI-Native Growth, CLG, and Privacy-First protocols
- **`product/600_brand_strategy.md`** — 22パート・120+セクションの v2.0 へ拡張。Brand Flywheel、Golden Dataset Protocol、AI Brand Drift Detection、Multi-Agent Orchestration、BrandSOC、Sonic & Sensory Branding、Spatial Computing、Web3、Brand CI/CD を統合 / Expanded to 22-part v2.0 with AI-Native Brand Governance
- **`product/300_revenue_monetization.md`** — 2026基準への網羅的ブラッシュアップ / Comprehensive brushup to 2026 standards
- **`product/000_product_strategy.md`** — 2026基準への網羅的ブラッシュアップ / Comprehensive brushup to 2026 standards
- **`product/100_market_validation.md`** — 2026基準への網羅的ブラッシュアップ / Comprehensive brushup to 2026 standards
- **`product/200_go_to_market.md`** — 2026基準への網羅的ブラッシュアップ / Comprehensive brushup to 2026 standards
- **`security/000_security_privacy.md`** — 2026基準への網羅的ブラッシュアップ / Comprehensive brushup to 2026 standards
- **`security/200_oss_compliance.md`** — 2026基準への網羅的ブラッシュアップ / Comprehensive brushup to 2026 standards
- **`security/300_ip_due_diligence.md`** — 2026基準への網羅的ブラッシュアップ / Comprehensive brushup to 2026 standards
- **`quality/000_qa_testing.md`** — 2026基準への網羅的ブラッシュアップ / Comprehensive brushup to 2026 standards
- **`ai/000_ai_engineering.md`** — 2026基準への網羅的ブラッシュアップ / Comprehensive brushup to 2026 standards
- **`design/000_design_ux.md`** — 2026基準への網羅的ブラッシュアップ / Comprehensive brushup to 2026 standards
- **`engineering/000_engineering_standards.md`** — 2026基準への網羅的ブラッシュアップ / Comprehensive brushup to 2026 standards
- **`engineering/300_web_frontend.md`** — 2026基準への網羅的ブラッシュアップ / Comprehensive brushup to 2026 standards
- **`operations/100_sales_bizdev.md`** — 2026基準への網羅的ブラッシュアップ / Comprehensive brushup to 2026 standards
- **`operations/200_hr_organization.md`** — 2026基準への網羅的ブラッシュアップ / Comprehensive brushup to 2026 standards
- **`operations/600_cloud_finops.md`** — 2026基準への網羅的ブラッシュアップ / Comprehensive brushup to 2026 standards
- **`operations/700_partnership_ecosystem.md`** — 2026基準への網羅的ブラッシュアップ / Comprehensive brushup to 2026 standards

### Changed — Blueprint Structure Normalization

- **Blueprint README.md (14 files)** — JA/EN 各7ドメインフォルダの README.md に YAGNI 原則・結晶化プロトコルの説明を追加。「初期状態では空であることが正しい設計」を明示 / Added YAGNI principle and crystallization protocol explanation to all 14 domain folder READMEs
- **`axiarch-rules/INDEX.md`** — Universal Rules 概要を v2.0 に同期 / Synced Universal Rules summaries to v2.0
- **`axiarch-rules/blueprint/{ja,en}/INDEX.md`** — Blueprint INDEX を構造正規化に同期 / Synced Blueprint INDEX to structural normalization

### Changed — Documentation & Metadata

- **`ROADMAP.md`** — v1.1.0/v1.2.0 リリース履歴追加、安定版表示を v1.2.0 に更新、将来版を v1.3.0 に繰り上げ / Added v1.1.0/v1.2.0 release history, updated stable version, bumped future version to v1.3.0
- **`llms-full.txt`** — バージョン表記を 1.2.0 に更新 / Updated version to 1.2.0
- **`SECURITY.md`** — セキュリティポリシー更新 / Security policy update

### Added

- **`.github/dependabot.yml`** — GitHub Actions の依存関係自動更新設定 / Dependabot configuration for GitHub Actions dependency updates

---

## [1.1.0] — 2026-04-12

### ✨ Design & UX Strategy v3.0 / AGENTS.md Protocol 6 追加

### Added

- **AGENTS.md §6: Anti-Full-Overwrite Protocol** — 既存ファイルの全文上書き（`write_to_file(Overwrite: true)` 相当）を原則禁止する新プロトコル。差分編集（`replace_file_content` / `multi_replace_file_content`）を義務化 / New protocol prohibiting full-file overwrite of existing files by default. Mandates diff-based editing.
- **`.github/workflows/release.yml`** — PRマージ時にCHANGELOG.mdからバージョンを自動検出し、タグ作成→GitHub Release生成まで一気通貫で自動実行するCI/CDワークフロー / Auto-detect version from CHANGELOG.md on PR merge, create tag & GitHub Release automatically

### Changed

- **`universal/{ja,en}/design/000_design_ux.md`** — 25パート完成版 v3.0 にリファクタリング / Refactored to 25-part complete edition v3.0
  - 新規5パート追加: §21 Calm UI, §22 Voice UI, §23 Design System as a Product, §24 WCAG 3.0前方互換性, §25 Design FinOps
  - 技術固有ルール（React/Hydration）を `engineering/` へ委譲
  - EU Digital Fairness Act (DFA) 追加、アンチパターン 30→35選に拡張
  - JA/EN完全構造同期（§25, ###96, 1046行）
- **AGENTS.md** — §5.1→§6昇格、全セクション番号リナンバー（§6→§7, §7→§8, §8→§9） / Section renumbering: Anti-Full-Overwrite promoted to §6, subsequent sections renumbered
- **`axiarch-rules/INDEX.md`** — Design UX概要文を25パート完成版に同期 / Design UX summary synced to 25-part edition
- **`axiarch-rules/LOADING_PROTOCOL.md`** — §7→§8 参照更新 / Reference updated §7→§8
- **`axiarch-rules/CRYSTALLIZATION_PROTOCOL.md`** — §8→§9 参照更新 / Reference updated §8→§9
- **`blueprint/{ja,en}/core/010_project_lessons_log.md`** — §8→§9 参照更新 / Reference updated §8→§9
- **`ROADMAP.md`** — 8プロトコル→9プロトコル / 8 protocols → 9 protocols
- **`llms-full.txt`** — Protocol 6追加、Protocol 7-9リナンバー、Design概要更新 / Protocol 6 added, 7-9 renumbered, Design summary updated

---

## [1.0.0] — 2026-04-10

### 🎉 Initial Public Release

**Axiarch（アクシアーク）** — 憲法駆動型 AIエージェントガバナンスフレームワーク初回公開リリース。

**Axiarch (AX-ee-ark)** — Constitution-Driven AI Agent Governance Framework, initial public release.

### Added

- **AGENTS.md** — AI行動憲法（9プロトコル定義） / AI Behavior Constitution (9 protocols)
- **Universal Rules** — 38ファイル × 2言語（JA/EN）、2,500以上の憲法基準 / 38 files × 2 languages, 2,500+ constitution standards
  - 000: Core & Mindset
  - 100–150: Product & Business Strategy
  - 200: Design & UX
  - 300–361: Engineering (Standards, API, Supabase, Web, CMS, Flutter, Native, Firebase, AWS)
  - 400–401: AI & Data
  - 500–530: Operations & Reliability
  - 600–603: Security & Legal
  - 700–720: QA & FinOps
  - 800–802: Global & Governance
- **Blueprint Templates** — プロジェクト固有テンプレート / Project-specific templates
  - `core/000_project_overview.md` — プロジェクト概要 / Project overview
  - `core/010_project_lessons_log.md` — 教訓ログ / Lessons log
  - `core/998_feature_spec_template.md` — 機能仕様テンプレート / feature spec template
  - `core/999_project_specific_template.md` — プロジェクト固有ルール / Project-specific rules
- **LOADING_PROTOCOL.md** — 5ステップのルールロード手順 / 5-step rule loading protocol
- **CRYSTALLIZATION_PROTOCOL.md** — 教訓の自動結晶化プロトコル / Lesson auto-crystallization protocol
- **INDEX.md** — 全ルールの詳細索引 / Detailed index of all rules
- **compliance_matrix.md** — 要件対照表 / Compliance matrix
- **`init.sh`** — インタラクティブなセットアップスクリプト。言語・エージェント選択→ファイルコピー→次のステップ案内まで自動化 / Interactive setup script automating language/agent selection, file copy, and next-step guidance
- **`.github/CODEOWNERS`** — 最上位プロトコル・Universal Rules・Blueprint・プロンプト集の責任範囲を区分したコードオーナー定義 / Code owner definitions with responsibility boundaries
- **`.github/workflows/lint.yml`** — Markdownリント + JA/EN対称性をすべてのPR/pushで自動検証するGitHub Actions CI / GitHub Actions CI: Markdown lint + JA/EN symmetry validation
- **`llms.txt`** — AI検索エンジン向けに構造化されたプロジェクトサマリー（GEO対応） / Structured project summary for AI search engine optimization (GEO)
- **`llms-full.txt`** — AI検索エンジン向け完全仕様書（詳細版） / Full specification document for AI search engines (detailed version)
- **GitHub Discussions** — Q&A・ユースケース共有のコミュニティ基盤 / Community foundation for Q&A and use case sharing
- **`question.yml`** — Q&A用 Issue テンプレート / Q&A issue template
- **Prompt Library (`axiarch-prompts/`)** — 16本 × 2言語（JA/EN）の再利用可能プロンプトテンプレート / 16 templates × 2 languages (JA/EN), reusable prompt library
  - `develop/` — 開発・実行系 4本 / Development & execution (4 prompts): `feature_development`, `refactoring_audit`, `push_execute`, `ci_fix`
  - `audit/` — 品質・整合性監査系 5本 / Quality & integrity auditing (5 prompts): `fullstack_qa_audit`, `api_architecture_audit`, `data_integrity_audit`, `system_integrity_audit`, `deep_optimization_audit`
  - `govern/` — コンプライアンス・ガバナンス系 5本 / Compliance & governance (5 prompts): `compliance_inspector_audit`, `constitution_compliance_audit`, `governance_auditor`, `blueprint_governance_audit`, `localization_audit`
  - `operate/` — インシデント・参入系 2本 / Incident response & onboarding (2 prompts): `onboarding_audit`, `incident_response`
- **`axiarch-prompts/README.md`** — ユースケース別フローチャート・重複解消マトリクス・複合利用ガイドを含む包括的なプロンプト選択ガイド / Comprehensive prompt selection guide with use-case flowchart and compound usage guide

### Background

実際のプロダクション開発でのAI支援開発（Google Antigravity）を通じた数百セッションの実践知見から構築。

Built from hundreds of AI-assisted development sessions on Google Antigravity during real production development.

[Unreleased]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.8.2...HEAD
[1.8.2]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.8.1...v1.8.2
[1.8.1]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.8.0...v1.8.1
[1.8.0]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.6.0...v1.8.0
[1.7.0]: https://github.com/hiroyuki-miyauchi/axiarch/blob/main/CHANGELOG.md#170--2026-05-08-内部開発のみ独立-release-はせず-v180-に統合
[1.6.0]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.5.5...v1.6.0
[1.5.5]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.5.4...v1.5.5
[1.5.4]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.5.3...v1.5.4
[1.5.3]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.5.2...v1.5.3
[1.5.2]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.5.1...v1.5.2
[1.5.1]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.5.0...v1.5.1
[1.5.0]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.4.0...v1.5.0
[1.4.0]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.3.2...v1.4.0
[1.3.2]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.3.1...v1.3.2
[1.3.1]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.3.0...v1.3.1
[1.3.0]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.2.0...v1.3.0
[1.2.0]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/hiroyuki-miyauchi/axiarch/releases/tag/v1.0.0
