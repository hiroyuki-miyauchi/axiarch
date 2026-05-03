# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.4.0] — 2026-05-04

### 🆕 Claude Code Enforcement Mechanism — UserPromptSubmit Hook / Claude Code 強制執行機構

Claude Code 採用プロジェクトに `UserPromptSubmit` フックを標準同梱し、AI のプロトコル遵守を物理的に強制する。`AGENTS.md` / `LOADING_PROTOCOL.md` が「指示書」止まりだった問題を解消し、軽い会話でもサボりを許さない設計へ転換。

Adds a standard `UserPromptSubmit` hook to Claude Code projects, physically enforcing AI protocol adherence. Closes the gap where `AGENTS.md` / `LOADING_PROTOCOL.md` were "instructions" without enforcement, so even casual prompts cannot bypass the protocol.

### Added

- **`.claude/settings.json`**（新規）— `UserPromptSubmit` フック定義。バイリンガル system reminder（en + ja）を**毎ユーザープロンプト送信時**に注入し、AI に AGENTS.md プロトコル＋LOADING_PROTOCOL の BOOT SEQUENCE 実行を強制 / NEW: `UserPromptSubmit` hook with bilingual system reminder injected on every prompt, compelling AI to execute AGENTS.md + LOADING_PROTOCOL BOOT SEQUENCE
- **`axiarch-rules/{ja,en}/LOADING_PROTOCOL.md`** — 「🛡️ 強制執行機構（ENFORCEMENT MECHANISM）」セクションを BOOT SEQUENCE 直後に追加。フック削除を「憲法改正」レベルと明記 / Added "🛡️ Enforcement Mechanism" section right after BOOT SEQUENCE; declares hook removal as a constitution-amending change
- **`README.md`** — Quick Start に「Claude Code 強制執行機構 / Enforcement Mechanism (v1.4.0+)」サブセクション、必須ファイル表に `.claude/settings.json` 行追加 / New "Enforcement Mechanism" subsection in Quick Start; new row in Required Files table

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

- ✅ **後方互換性100%** — 既存 v1.3.x 採用プロジェクトは `.claude/settings.json` 不在でも従来通り動作（フックなし、AI 自律遵守モード）/ Fully backwards compatible: existing v1.3.x adopters work without the hook (autonomous-enforcement mode)
- ✅ **Claude Code 限定機能** — Antigravity / Codex / Cursor / Copilot / Windsurf には影響なし（各自が固有のロード機構を持つため）/ Claude Code-only feature; no impact on other agents (each has its own native loading mechanism)
- ⚠️ **`@AGENTS.md` import 削除の影響** — Claude Code はフック経由で AGENTS.md を Read するため挙動は強化される（`view_file` 履歴付与・`task.md` 記録発火）。挙動の劣化なし / Removing `@AGENTS.md` strengthens behavior: hook drives explicit Read, populating `view_file` history and triggering `task.md` recording. No regression
- ⚠️ **トークンコスト** — 毎プロンプトに ~80 トークンの system reminder 追加。プロンプトキャッシュとは独立だが影響無視可能 / Adds ~80 tokens per prompt as a system reminder; independent of prompt cache but negligible impact
- 📌 **アップグレード手順** — `git pull` → `init.sh` 再実行 OR 手動で `.claude/settings.json` を配置 / Upgrade: `git pull` then re-run `init.sh`, or manually place `.claude/settings.json`

### References

- 議論の出典: inucomi（子プロジェクト）でユーザーと検討 / Discussion origin: inucomi child-project session

---

## [1.3.2] — 2026-05-03

### 🆕 Universal Engineering 600 新設 + Git Workflow Refactor + Worktree Hygiene Protocol / Universal Engineering 600 + Git Workflow Refactor + Worktree Hygiene Protocol

axiarch を採用する全プロジェクトに Git Workflow と `.git/config` 健全性管理を恒常的に提供する Universal ルールを追加。`scripts/check-git-config-clean.sh` を OSS 採用者全員へ配布。`engineering/000` Part X の pure-git workflow を新ファイル `engineering/600_git_workflow.md` に集約（YAGNI 原則に基づく構造正規化）。

Adds a Universal rule providing Git Workflow and `.git/config` integrity management to all axiarch-adopting projects. Distributes `scripts/check-git-config-clean.sh` to OSS adopters. Consolidates pure-git workflow from `engineering/000` Part X into the new `engineering/600_git_workflow.md` file (YAGNI-based structural normalization).

### Added

- **`axiarch-rules/{ja,en}/universal/engineering/600_git_workflow.md`**（新規 Universal Rule）— **5パート・18ルール**: Trunk-Based Development (§1) / Commit & PR Standards (§2) / Branch Hygiene Mandate (§3) / **Worktree Hygiene Protocol (§4)** — `[extensions] worktreeConfig = true` 残留問題（Antigravity の Go ベース language server クラッシュ・`ECONNREFUSED 127.0.0.1:50347`）の検出・修復・予防 / Repository Hygiene & Config Integrity (§5)。クロスリファレンス（security/operations/quality 等）・逆引き索引付き / **NEW Universal Rule** with 5 parts, 18 rules covering daily Git workflow including the **Worktree Hygiene Protocol** that documents the `worktreeConfig` residue problem (Antigravity Go-based language server crash) detection/repair/prevention
- **`scripts/check-git-config-clean.sh`** — `.git/config` の自動検出・修復スクリプト（`--fix` / `--quiet` / `--full-clean` モード対応、現在ブランチ自動除外）/ Auto-detection & repair script for `.git/config` with `--fix`, `--quiet`, `--full-clean` modes (auto-excludes current branch)
- **`init.sh`** に `scripts/` ディレクトリ配布ロジック追加 — axiarch 採用と同時に `check-git-config-clean.sh` が自動配布される / Added `scripts/` distribution logic so adopters automatically receive `check-git-config-clean.sh`

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

- ✅ **後方互換性100%** — 既存採用プロジェクトは pull するだけで新ルールと script を取得 / Fully backwards compatible — existing adopters just `git pull`
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

- **`CLAUDE.md`** — `@AGENTS.md` import 構文を追加。Claude Code 起動時に AGENTS.md（最高法規・9プロトコル）全文が system prompt へ自動 inline され、BOOT SEQUENCE PROTOCOL の物理的強制を実現。AI の自律的な Read tool 実行に依存せず初動からプロトコル遵守を保証 / Added `@AGENTS.md` import syntax. AGENTS.md (Supreme Law / 9 protocols) is now auto-inlined into the system prompt at Claude Code session start, providing physical enforcement of BOOT SEQUENCE PROTOCOL without depending on the AI to autonomously read it. Reference: <https://code.claude.com/docs/en/memory.md#import-additional-files>

### Compatibility

- 後方互換性100%。Claude Code 専用機能のため、他エージェント（Cursor / Copilot / Windsurf / Antigravity / Codex）には影響なし / Fully backwards compatible. Claude Code-specific feature — no effect on other agents
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
- **`.github/CODEOWNERS`** — 最高法規・Universal Rules・Blueprint・プロンプト集の責任範囲を区分したコードオーナー定義 / Code owner definitions with responsibility boundaries
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

[1.3.0]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.2.0...v1.3.0
[1.2.0]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/hiroyuki-miyauchi/axiarch/releases/tag/v1.0.0
