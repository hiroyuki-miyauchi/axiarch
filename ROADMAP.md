# Axiarch Roadmap

> **現在の安定版 / Current Stable**: v1.0.0  
> **ステータス / Status**: Actively Maintained ✅

---

## 🇯🇵 ロードマップ

このロードマップはAxiarchの開発方向性を共有するための公開文書です。  
優先度・スコープは実際の使用フィードバックと企業採用ニーズに基づいて調整されます。

---

### ✅ v1.0.0 — 初回公開リリース（2026-04-10）

- **AGENTS.md** — AI行動憲法（8プロトコル）
- **Universal Rules** — 30ファイル × 2言語（JA/EN）、2,500以上のエンジニアリング基準
- **Blueprint Templates** — プロジェクト固有テンプレート（フォルダ分け構造、Universal と対称化）
- **LOADING_PROTOCOL.md / CRYSTALLIZATION_PROTOCOL.md** — ルール管理プロトコル
- **Prompt Library** — 16本 × 2言語（JA/EN）の再利用可能プロンプトテンプレート
  - 役割別4フォルダ構成（`develop/`, `audit/`, `govern/`, `operate/`）
- **`init.sh`** — インタラクティブセットアップスクリプト（Antigravity検証済み、Cursor/Claude Code/Copilot/Windsurf対応見込み）
- **`.github/CODEOWNERS`** — ガバナンス責任範囲の明確化
- **`.github/workflows/lint.yml`** — Markdown + JA/EN対称性CI自動検証
- **`llms.txt`** — AI検索エンジン最適化（GEO）
- **`question.yml`** — Q&A用 Issue テンプレート
- **Cursor / Claude Code / Copilot / Windsurf 向けセットアップガイド** — README内エージェント別手順 + `init.sh` 自動化
- **AGENTS.md 起動プロトコル** — エージェント非依存の汎用 Boot Sequence Protocol
- **GitHub Discussions** の有効化 — Q&A・ユースケース共有
- **`llms-full.txt`** — AI検索エンジン向け完全仕様書（詳細版）

---

### 🔮 v1.2.0 — エコシステム & 自動化（検討中）

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

- **AGENTS.md** — AI Behavior Constitution (8 protocols)
- **Universal Rules** — 30 files × 2 languages (JA/EN), 2,500+ engineering standards
- **Blueprint Templates** — Project-specific templates (subdirectory structure, symmetric with Universal)
- **LOADING_PROTOCOL.md / CRYSTALLIZATION_PROTOCOL.md** — Rule management protocols
- **Prompt Library** — 16 templates × 2 languages (JA/EN), reusable prompt library
  - Role-based 4-folder structure (`develop/`, `audit/`, `govern/`, `operate/`)
- **`init.sh`** — Interactive setup script (Antigravity verified, Cursor/Claude Code/Copilot/Windsurf expected)
- **`.github/CODEOWNERS`** — Clear governance responsibility boundaries
- **`.github/workflows/lint.yml`** — Automated Markdown + JA/EN symmetry CI
- **`llms.txt`** — AI search engine optimization (GEO)
- **`question.yml`** — Q&A issue template
- **Setup guides for Cursor / Claude Code / Copilot / Windsurf** — Agent-specific setup in README + `init.sh` automation
- **AGENTS.md boot protocol** — Agent-agnostic generic Boot Sequence Protocol
- Enable **GitHub Discussions** — Q&A and use case sharing
- **`llms-full.txt`** — Full spec document for AI search engines (detailed version)

---

### 🔮 v1.2.0 — Ecosystem & Automation (Under Consideration)

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
