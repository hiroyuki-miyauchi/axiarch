# Axiarch Roadmap

> **現在の安定版 / Current Stable**: v1.4.0  
> **ステータス / Status**: Actively Maintained ✅

---

## 🇯🇵 ロードマップ

このロードマップはAxiarchの開発方向性を共有するための公開文書です。  
優先度・スコープは実際の使用フィードバックと企業採用ニーズに基づいて調整されます。

---

### ✅ v1.0.0 — 初回公開リリース（2026-04-10）

- **AGENTS.md** — AI行動憲法（9プロトコル）
- **Universal Rules** — 38ファイル × 2言語（JA/EN）、2,500以上の憲法基準
- **Blueprint Templates** — プロジェクト固有テンプレート（フォルダ分け構造、Universal と対称化）
- **LOADING_PROTOCOL.md / CRYSTALLIZATION_PROTOCOL.md** — ルール管理プロトコル
- **Prompt Library** — 16本 × 2言語（JA/EN）の再利用可能プロンプトテンプレート
  - 役割別4フォルダ構成（`develop/`, `audit/`, `govern/`, `operate/`）
- **`init.sh`** — インタラクティブセットアップスクリプト（Antigravity検証済み、Codex/Cursor/Claude Code/Copilot/Windsurf対応見込み）
- **`.github/CODEOWNERS`** — ガバナンス責任範囲の明確化
- **`.github/workflows/lint.yml`** — Markdown + JA/EN対称性CI自動検証
- **`llms.txt`** — AI検索エンジン最適化（GEO）
- **`question.yml`** — Q&A用 Issue テンプレート
- **Codex / Cursor / Claude Code / Copilot / Windsurf 向けセットアップガイド** — README内エージェント別手順 + `init.sh` 自動化
- **AGENTS.md 起動プロトコル** — エージェント非依存の汎用 Boot Sequence Protocol
- **GitHub Discussions** の有効化 — Q&A・ユースケース共有
- **`llms-full.txt`** — AI検索エンジン向け完全仕様書（詳細版）

---

### ✅ v1.1.0 — Design & UX Strategy v3.0 / Protocol 6（2026-04-12）

- **AGENTS.md §6: Anti-Full-Overwrite Protocol** — 差分編集義務化プロトコル追加
- **`universal/{ja,en}/design/000_design_ux.md`** — 25パート完成版 v3.0
- **`.github/workflows/release.yml`** — CHANGELOG自動バージョン検出 → タグ・Release自動生成

---

### ✅ v1.2.0 — Universal Rules 大規模ブラッシュアップ（2026-04-29）

- **Universal Rules** — 全16ファイル × 2言語を2026 Staff Engineer基準に拡張（57ファイル変更、+59,500行）
- **Blueprint 構造正規化** — YAGNI原則に基づき、ドメインフォルダ README に結晶化プロトコル説明を追加
- **`.github/dependabot.yml`** — GitHub Actions 依存関係自動更新

---

### ✅ v1.3.0 — バイリンガル構造リアーキテクチャ（2026-04-30）

- **ディレクトリ構造の全面再編** — `axiarch-rules/universal/{lang}/` → `axiarch-rules/{lang}/universal/` へ「言語ファースト」構造に移行（156ファイル変更）
- **`CLAUDE.md`** — Claude Code固有のポインターファイルを新規追加（旧シムリンク方式を廃止）
- **全クロスリファレンス同期** — ポインター5種、プロンプト32本、CI/CD、設定ファイル等の全パス参照を更新

---

### ✅ v1.3.1 — Claude Code `@import` 統合（2026-05-03）

- **`CLAUDE.md`** — `@AGENTS.md` import 構文追加により、Claude Code 起動時に AGENTS.md（最高法規・9プロトコル）全文が自動 inline 注入される機構を実装
- **物理的 BOOT SEQUENCE 強制** — AI の自律ロード行動に依存せず、プロトコル遵守を初動から保証
- **後方互換性 100%** — 他エージェント（Cursor / Copilot / Windsurf / Antigravity / Codex）には影響なし

---

### ✅ v1.3.2 — Universal Engineering 600 新設 + Git Workflow Refactor + Worktree Hygiene（2026-05-03）

- **`engineering/600_git_workflow.md` 新設** — 日常的な Git 運用（Trunk-Based / Commit & PR / Branch Hygiene / **Worktree Hygiene Protocol** / Repository Hygiene）をドメイン非依存の Universal Rule として集約（5パート・18ルール）
- **`.git/config` 汚染問題（Antigravity Go ベース language server クラッシュ）の恒久対策** — `[extensions] worktreeConfig = true` 残留検出・修復プロトコルを Universal に永続化
- **`scripts/check-git-config-clean.sh` 新規配布** — 自動検出・修復スクリプト（`--fix` / `--quiet` / `--full-clean` モード対応）。`init.sh` 経由で全採用プロジェクトに自動配布
- **構造正規化** — `engineering/000` Part X から pure-git workflow を 600 へ抽出（§10.0 / §10.3 / §10.1 部分移動）
- **後方互換性 100%** — 既存採用プロジェクトは `git pull` で新ルールと script を取得。3シナリオ（Claude Code 単体 / Antigravity 単体 / 並行使用）全てで Pareto-improvement

---

### ✅ v1.4.0 — Claude Code 強制執行機構（UserPromptSubmit Hook）（2026-05-04）

- **`.claude/settings.json` 新規同梱** — Claude Code 採用プロジェクトに `UserPromptSubmit` フックを標準配置。**毎ユーザープロンプト送信時**にバイリンガル system reminder を注入し、AI に AGENTS.md プロトコルと LOADING_PROTOCOL の BOOT SEQUENCE 実行を物理的に強制
- **`axiarch-rules/{ja,en}/LOADING_PROTOCOL.md` に「強制執行機構」セクション追加** — フック削除を「憲法改正」レベルの破壊的変更と明記
- **`CLAUDE.md` の `@AGENTS.md` import 削除** — フック経由の Read ロード（`view_file` 履歴付与・`task.md` 記録発火）に統一し、Anti-Laziness Rule との整合を確保
- **`.gitignore` 細分化** — `.claude/` 全無視を `worktrees/` / `projects/` / `settings.local.json` の3項目に分解。チーム共有設定 `.claude/settings.json` をコミット可能に
- **`init.sh` 拡張** — `SETUP_CLAUDE` 分岐で `.claude/settings.json` を配布、非 Claude Code 選択時のみ `.claude/` 削除（既存採用者の `worktrees/` 温存）
- **後方互換性 100%** — 既存 v1.3.x 採用プロジェクトはフック不在でも従来通り動作（自律遵守モード）

---

### 🔮 v1.5.0 — エコシステム & 自動化（検討中）

- **Axiarch CLI** — `npx axiarch-init` による自動セットアップ
- **HealthCheck Workflow** — リポジトリ状態自動診断（Blueprint未入力、Lessons log 蓄積超過等の検知）
- **AI Agent Compatibility Matrix** — 各AIエージェントの動作確認状況を定期更新
- **コミュニティ貢献プロンプト** — ユーザー投稿プロンプトの審査・統合フロー

---

### 💡 検討中 / Future Ideas

以下は将来的に検討しているアイデアです。優先度は未確定です。

- **マルチリポジトリ対応** — モノレポ構成での Axiarch 管理
- **Axiarch Web UI** — ルールの閲覧・検索・進捗管理のためのダッシュボード
- **GitHub App** — PR時にAxiarch準拠チェックを自動実行

---

### フィードバック・要望

ロードマップへの意見・優先度に関するフィードバックは Issue にてお寄せください:

👉 [github.com/hiroyuki-miyauchi/axiarch/issues](https://github.com/hiroyuki-miyauchi/axiarch/issues)

---

## 🇺🇸 Roadmap

This roadmap is a public document sharing the direction of Axiarch's development.  
Priorities and scope will be adjusted based on actual usage feedback and enterprise adoption needs.

---

### ✅ v1.0.0 — Initial Public Release (2026-04-10)

- **AGENTS.md** — AI Behavior Constitution (9 protocols)
- **Universal Rules** — 38 files × 2 languages (JA/EN), 2,500+ engineering standards
- **Blueprint Templates** — Project-specific templates (subdirectory structure, symmetric with Universal)
- **LOADING_PROTOCOL.md / CRYSTALLIZATION_PROTOCOL.md** — Rule management protocols
- **Prompt Library** — 16 templates × 2 languages (JA/EN), reusable prompt library
  - Role-based 4-folder structure (`develop/`, `audit/`, `govern/`, `operate/`)
- **`init.sh`** — Interactive setup script (Antigravity verified, Codex/Cursor/Claude Code/Copilot/Windsurf expected)
- **`.github/CODEOWNERS`** — Clear governance responsibility boundaries
- **`.github/workflows/lint.yml`** — Automated Markdown + JA/EN symmetry CI
- **`llms.txt`** — AI search engine optimization (GEO)
- **`question.yml`** — Q&A issue template
- **Setup guides for Codex / Cursor / Claude Code / Copilot / Windsurf** — Agent-specific setup in README + `init.sh` automation
- **AGENTS.md boot protocol** — Agent-agnostic generic Boot Sequence Protocol
- Enable **GitHub Discussions** — Q&A and use case sharing
- **`llms-full.txt`** — Full spec document for AI search engines (detailed version)

---

### ✅ v1.1.0 — Design & UX Strategy v3.0 / Protocol 6 (2026-04-12)

- **AGENTS.md §6: Anti-Full-Overwrite Protocol** — Added diff-based editing mandate protocol
- **`universal/{ja,en}/design/000_design_ux.md`** — 25-part complete edition v3.0
- **`.github/workflows/release.yml`** — Auto-detect version from CHANGELOG → auto-create tag & Release

---

### ✅ v1.2.0 — Universal Rules Major Brushup (2026-04-29)

- **Universal Rules** — Expanded all 16 files × 2 languages to 2026 Staff Engineer standards (57 files changed, +59,500 lines)
- **Blueprint Structure Normalization** — Added crystallization protocol explanation to domain folder READMEs based on YAGNI principle
- **`.github/dependabot.yml`** — Dependabot for GitHub Actions dependencies

---

### ✅ v1.3.0 — Bilingual Directory Re-Architecture (2026-04-30)

- **Full directory restructure** — Migrated from `axiarch-rules/universal/{lang}/` to `axiarch-rules/{lang}/universal/` ("Language-First" layout, 156 files changed)
- **`CLAUDE.md`** — Added Claude Code-specific pointer file (replaced former symlink approach)
- **Full cross-reference sync** — Updated all path references across 5 pointers, 32 prompts, CI/CD, and config files

---

### ✅ v1.3.1 — Claude Code `@import` Integration (2026-05-03)

- **`CLAUDE.md`** — Added `@AGENTS.md` import syntax to auto-inline AGENTS.md (Supreme Law / 9 protocols) into the system prompt at Claude Code session start
- **Physical BOOT SEQUENCE Enforcement** — Protocol compliance guaranteed from the first turn, no longer depending on AI's autonomous file-loading behavior
- **100% Backwards Compatible** — No effect on other agents (Cursor / Copilot / Windsurf / Antigravity / Codex)

---

### ✅ v1.3.2 — Universal Engineering 600 + Git Workflow Refactor + Worktree Hygiene (2026-05-03)

- **NEW `engineering/600_git_workflow.md`** — Consolidates daily Git operations (Trunk-Based / Commit & PR / Branch Hygiene / **Worktree Hygiene Protocol** / Repository Hygiene) as a domain-agnostic Universal Rule (5 parts, 18 rules)
- **Permanent fix for `.git/config` pollution problem (Antigravity Go-based language server crash)** — Detection and repair protocol for `[extensions] worktreeConfig = true` residue persisted to Universal level
- **NEW `scripts/check-git-config-clean.sh` distribution** — Auto-detection and repair script (`--fix` / `--quiet` / `--full-clean` modes). Distributed automatically to all adopting projects via `init.sh`
- **Structural normalization** — Extracted pure-git workflow from `engineering/000` Part X into 600 (§10.0 / §10.3 / partial §10.1)
- **100% Backwards Compatible** — Existing adopters obtain new rules and script via `git pull`. Pareto-improvement across all three scenarios (Claude Code only / Antigravity only / parallel use)

---

### ✅ v1.4.0 — Claude Code Enforcement Mechanism (UserPromptSubmit Hook) (2026-05-04)

- **NEW `.claude/settings.json`** — Claude Code projects ship with a standard `UserPromptSubmit` hook that injects a bilingual system reminder **on every user prompt submission**, physically compelling the AI to execute the AGENTS.md protocol and LOADING_PROTOCOL BOOT SEQUENCE
- **NEW "Enforcement Mechanism" section in `axiarch-rules/{ja,en}/LOADING_PROTOCOL.md`** — Declares hook removal as a constitution-amending destructive change
- **Removed `@AGENTS.md` import from `CLAUDE.md`** — Unified loading via the hook-driven Read flow (preserves `view_file` history and triggers `task.md` recording), aligning with the Anti-Laziness Rule
- **Refined `.gitignore`** — Split `.claude/` blanket ignore into `worktrees/` / `projects/` / `settings.local.json`, allowing the team-shared `.claude/settings.json` to be committed
- **Extended `init.sh`** — `SETUP_CLAUDE` branch now distributes `.claude/settings.json`; `.claude/` cleanup runs only for non-Claude-Code agents (preserves existing adopters' `worktrees/`)
- **100% Backwards Compatible** — Existing v1.3.x adopters work without the hook (autonomous-enforcement mode)

---

### 🔮 v1.5.0 — Ecosystem & Automation (Under Consideration)

- **Axiarch CLI** — Automated setup via `npx axiarch-init`
- **HealthCheck Workflow** — Automated repository health diagnostics (detecting empty Blueprint, accumulated Lessons log overflow, etc.)
- **AI Agent Compatibility Matrix** — Regularly updated behavior verification matrix for each AI agent
- **Community Prompt Contributions** — User-submitted prompt review and integration flow

---

### 💡 Future Ideas (Under Discussion)

The following are ideas being considered for the future. Prioritization is not yet determined.

- **Multi-repository support** — Axiarch management in monorepo configurations
- **Axiarch Web UI** — Dashboard for rule browsing, search, and progress tracking
- **GitHub App** — Automatic Axiarch compliance check on every PR

---

### Feedback & Feature Requests

Share your feedback on the roadmap or feature priorities via Issues:

👉 [github.com/hiroyuki-miyauchi/axiarch/issues](https://github.com/hiroyuki-miyauchi/axiarch/issues)
