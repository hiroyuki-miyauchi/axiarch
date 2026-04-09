<div align="center">

# 🏰 Axiarch

## 憲法駆動型 AIエージェントガバナンスフレームワーク

## Constitution-Driven AI Agent Governance Framework

[![Release](https://img.shields.io/github/v/release/hiroyuki-miyauchi/axiarch?label=Version&color=brightgreen)](https://github.com/hiroyuki-miyauchi/axiarch/releases)
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Rules](https://img.shields.io/badge/Universal_Rules-38_files-green.svg)](#-universal-rules-38-files--jaen)
[![Languages](https://img.shields.io/badge/Languages-🇯🇵_🇺🇸_Bilingual-orange.svg)](#-同梱内容--whats-included)
[![Agents](https://img.shields.io/badge/Verified-Google_Antigravity-green.svg)](#-aiエージェント互換性--ai-agent-compatibility) [![Expected](https://img.shields.io/badge/Expected-Cursor_|_Claude_|_Copilot-yellow.svg)](#-aiエージェント互換性--ai-agent-compatibility)

[日本語](#-axiarchアクシアークとは) ・ [English](#-what-is-axiarch-ax-ee-ark)

</div>

---

## 🇯🇵 Axiarch（アクシアーク）とは

**Axiarch（アクシアーク）** は、**憲法駆動型の AIエージェントガバナンスフレームワーク（Constitution-Driven AI Agent Governance Framework）**です。
「普遍憲法（Universal・不変）」と「固有ルール（Blueprint・可変）」の明確な責務分離、さらにそれを実行駆動する「プロンプト（Prompts・任意層）」という **3層統合ガバナンス・アーキテクチャ** こそが Axiarch の中核です。AI支援開発におけるハルシネーションや品質ドリフト（退行）のリスクをこの構造によって軽減し、操縦者のスキルレベルに依存せず、プロジェクト全体の最低品質（Quality Floor）を力強く底上げします。

[Google Antigravity](https://labs.google/antigravity) 上で設計・実戦検証済み。ルール本体は純粋な Markdown であり、`AGENTS.md` は主要なコーディングエージェントが参照・対応するオープンフォーマットのため、**他の AI エージェント（Cursor、Claude Code、GitHub Copilot 等）とも互換性がある見込み**です — ただし動作は未検証です。

### 設計思想

- **プロンプト集ではありません。** **操縦者が変わっても最低品質の床（Quality Floor）を力強く担保する**、多層防御のガバナンス設計です。
- **操縦者に依存しない品質ベースラインの死守。** シニアエンジニアが使っても初心者が使っても、憲法が同一のエンジニアリング基準を強制します。
- **3層ガバナンス分離。** 「絶対不変のエンジニアリング基準（Universal）」と「プロジェクトで成長する動的仕様（Blueprint）」の責務を物理層で分離し、AIの「コンテキスト忘却」や「ルール形骸化」のリスクを構造的に抑え込みます。

### なぜ必要か

| ガバナンスなし | Axiarchあり |
|:-------------|:--------------------------|
| AIが「それっぽいが壊れている」コードを生成 | Zero Bug, Zero Warning ポリシーを憲法で強制 |
| 品質が操縦者のスキルに完全依存 | Universal Rulesが最低品質の床を設定 |
| 仕様なしの vibe coding | Blueprint First：コードより先に仕様を定義 |
| セッション間で知見が消失 | 教訓ログが知見をルールに結晶化 |
| AIがプロジェクト構造を幻覚で生成 | Boot Sequence Protocol：まずルールを読め |

### アーキテクチャ

```text
┌─────────────────────────────────────────────────────────────┐
│ 第1層: Universal (普遍憲法 / Immutable)                       │
│ ├─ AGENTS.md (最高法規 / 行動プロトコル)                        │
│ └─ Universal Rules (38ファイル: 不変の普遍的基準)               │
├─────────────────────────────────────────────────────────────┤
│ 第2層: Blueprint (固有仕様 / Mutable)                         │
│ └─ プロジェクト概要、機能仕様、教訓ログ等の可変ルール              │
├─────────────────────────────────────────────────────────────┤
│ 第3層: Prompts (実行エンジン / Optional)                      │
│ └─ 監査・品質担保タスク用の任意プロンプト・フレームワーク         │
├─────────────────────────────────────────────────────────────┤
│ 実行ドキュメント — タスク単位                           ← 生成   │
│ task.md, implementation_plan.md, walkthrough.md             │
├─────────────────────────────────────────────────────────────┤
│ フィードバックループ — 結晶化                           ← 継続的 │
│ 教訓 → ルール(第2層) → より良い教訓                           │
└─────────────────────────────────────────────────────────────┘
```

---

## 🇺🇸 What is Axiarch (AX-ee-ark)?

**Axiarch** is a **Constitution-Driven AI Agent Governance Framework**.
It is designed to strictly govern and mitigate quality drift, hallucinations, and uncontrolled AI behavior in production development through a **Three-Layer Governance Architecture**: Layer 1 **Universal** (Immutable Constitution), Layer 2 **Blueprint** (Mutable Project State), and Layer 3 **Prompts** (Optional Execution Triggers).

Designed and battle-tested on [Google Antigravity](https://labs.google/antigravity). Since all rules are pure Markdown and `AGENTS.md` is an open format referenced by major coding agents, **it is expected to be compatible with other AI agents** (Cursor, Claude Code, GitHub Copilot, etc.) — though this has not been verified.

### Core Design Philosophy

- **Not a prompt collection.** It is a **multi-layered governance architecture** that safeguards minimum quality standards **regardless of who operates the AI agent.**
- **Operator-independent quality baseline.** Whether a senior engineer or a beginner uses the AI, the constitution enforces the same engineering standards.
- **Three-layer separation.** By physically decoupling "Immutable Universal standards" from "Mutable Blueprint states", Axiarch structurally mitigates 'context amnesia' and rule atrophy.

### The Problem

| Without Governance | With Axiarch |
|:-------------------|:--------------------------|
| AI generates code that "looks right" but breaks silently | Constitution enforces Zero Bug, Zero Warning policy |
| Quality depends entirely on the operator's skill | Universal Rules set a minimum quality floor |
| No structure for specs → vibe coding | Blueprint First: specs before code, always |
| Lessons learned are lost between sessions | Lessons Log crystallizes knowledge into rules |
| AI hallucinates project structure and rules | Boot Sequence Protocol: read rules first, then act |

### Architecture

```text
┌─────────────────────────────────────────────────────────────┐
│ Layer 1: Universal (Immutable Constitution)                 │
│ ├─ AGENTS.md (Supreme Law / Behavior Protocols)             │
│ └─ Universal Rules (38 files / Immutable Universal Standards) │
├─────────────────────────────────────────────────────────────┤
│ Layer 2: Blueprint (Mutable Project State)                  │
│ └─ Project Overview, Feature Specs, Lessons Log             │
├─────────────────────────────────────────────────────────────┤
│ Layer 3: Prompts (Optional Execution Framework)             │
│ └─ Task-specific prompts for auditing and QA execution      │
├─────────────────────────────────────────────────────────────┤
│ Execution Documents — Per-Task                       ← Gen. │
│ task.md, implementation_plan.md, walkthrough.md             │
├─────────────────────────────────────────────────────────────┤
│ Feedback Loop — Crystallization                      ← Cont.│
│ Lessons → Rules(Layer 2) → Better Lessons                   │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔌 AIエージェント互換性 / AI Agent Compatibility

| 状態 / Status | Agent | Native Config | AGENTS.md |
|:--------------|:------|:-------------|:----------|
| ✅ **Verified** — 実務で実証済み | **Google Antigravity** | `.agents/rules/` | ✅ Reads |
| ⚠️ **Untested** — 未検証（動作する見込み） | **Cursor** | `.cursor/rules/*.mdc` | ✅ Reads |
| ⚠️ **Untested** — 未検証（動作する見込み） | **GitHub Copilot** | `.github/copilot-instructions.md` | ✅ Reads |
| ⚠️ **Untested** — 未検証（動作する見込み） | **Claude Code** | `CLAUDE.md` | ⚠️ Via symlink |
| ⚠️ **Untested** — 未検証（動作する見込み） | **Windsurf** | `.windsurfrules` | ✅ Reads |
| ⚠️ **Untested** — 未検証（動作する見込み） | **Aider / Zed / Other** | Various | ✅ Reads |

> [!NOTE]
> **JA**: 各AIエージェントには**固有の設定ディレクトリ**があります（例: Cursorは `.cursor/rules/`、Copilotは `.github/copilot-instructions.md`）。`AGENTS.md` は**主要エージェントが読める共通憲法**であり、各ツールのネイティブ設定（例：`.cursor/rules/`、`.github/copilot-instructions.md`）と**併用**されます。ツール固有のセットアップの代替ではありません。
>
> **EN**: Each AI agent has its **own native configuration directory** (e.g., `.cursor/rules/` for Cursor, `.github/copilot-instructions.md` for Copilot). `AGENTS.md` is a **shared constitution readable by major agents**, designed to complement each tool's native config (e.g., `.cursor/rules/`, `.github/copilot-instructions.md`). It is NOT a replacement for tool-specific setup.

> [!IMPORTANT]
> **JA**: 本ガバナンス・アーキテクチャは **[Google Antigravity](https://labs.google/antigravity)** 上で設計・実戦検証されたものです。ルール本体は純粋なMarkdownであり、AIモデルの概念的な仕組みはツール間で共通であるため他のエージェントでも動作する見込みですが、**他ツールでの動作は検証していません。ご利用は自己責任でお願いします。Antigravity以外の環境での動作保証はいたしません。**
>
> **EN**: This governance architecture was designed and validated through hundreds of real production sessions on **Google Antigravity**. Since all rules are pure Markdown and the underlying AI model concepts are fundamentally the same across tools, they are expected to work on other agents — but **this has not been verified. Use at your own risk. No guarantees are provided for non-Antigravity environments.**

> [!TIP]
> **JA**: フォルダ名 `axiarch-rules/` は出自を反映していますが、ルールファイル自体は純粋なMarkdownであり、ツール固有の依存はありません。
>
> **EN**: The folder name `axiarch-rules/` reflects its origin, but the rule files themselves are pure Markdown with zero tool-specific dependencies.

---

## 📦 同梱内容 / What's Included

### 🏛️ 最高法規 / Supreme Law

| File | JA | EN |
|:-----|:---|:---|
| `AGENTS.md` | AI行動憲法（Google Antigravityで設計、他エージェントでも動作見込み） | AI Behavior Constitution (designed on Google Antigravity, compatible with other agents) |

### 📚 Universal Rules (38 files × JA/EN)

> Universal Rules はプロジェクトで使う可能性のある全技術領域のベストプラクティスライブラリです。AIは LOADING_PROTOCOL に従い、タスクに必要なファイルのみを選択的にロードします。使わない技術のルールが存在しても問題ありません。それ自体が、将来の採用時や未知の技術に直面したときの品質担保の源泉です。
>
> Universal Rules is a comprehensive best-practice library across all major technology domains. The AI selectively loads only what each task requires, following LOADING_PROTOCOL. Rules for technologies your project doesn't currently use cause no harm — they are there when you need them.

| Category | Files | JA | EN |
|:---------|:------|:---|:---|
| **000** Core & Mindset | 1 | 開発哲学、Supreme Directive | Development philosophy, Supreme Directive |
| **100** Product & Business | 9 | プロダクト戦略、市場検証、GTM、収益、価格、グロース、ブランド、ASO、IR | Product strategy, market validation, GTM, revenue, pricing, growth, brand, ASO, IR |
| **200** Design & UX | 1 | デザインシステム、A11y | Design system, accessibility |
| **300** Engineering | 9 | コード品質(80§)、API、Supabase、Web、CMS、Flutter、Native、Firebase、AWS | Code quality (80§), API, Supabase, Web, CMS, Flutter, Native, Firebase, AWS |
| **400** AI & Data | 2 | AIエンジニアリング、データ分析 | AI Engineering, Data Analytics |
| **500** Operations | 7 | 内部ツール、営業・BizDev、HR、CX、SRE、インシデント、パートナーシップ | Internal tools, sales/BizDev, HR, CX, SRE, incident response, partnerships |
| **600** Security & Legal | 4 | セキュリティ、データガバナンス、OSSコンプライアンス、知的財産 | Security, data governance, OSS compliance, IP |
| **700** QA & FinOps | 2 | テスト戦略、クラウドFinOps | Test strategy, Cloud FinOps |
| **800** Global & Governance | 3 | i18n、ガバナンス、言語プロトコル | i18n, governance, language protocol |

### 📐 Blueprint (プロジェクト固有テンプレート / Project-Specific Templates)

| File | JA | EN |
|:-----|:---|:---|
| `000_project_overview.md` | プロジェクト概要テンプレート | Project overview template |
| `core/010_project_lessons_log.md` | 教訓ログ | Lessons log |
| `998_feature_spec_template.md` | **機能仕様テンプレート（Blueprint Firstの核）** — 受け入れ条件(Given/When/Then)を機能単位で必須化 | **Feature spec template (Blueprint First core)** — Acceptance Criteria (Given/When/Then) required per feature |
| `999_project_specific_template.md` | プロジェクト固有ルールテンプレート | Project-specific rule template |

### 🔧 基盤 / Infrastructure

| File | JA | EN |
|:-----|:---|:---|
| `LOADING_PROTOCOL.md` | 5ステップのルールロード手順 | 5-step rule loading protocol |
| `CRYSTALLIZATION_PROTOCOL.md` | 教訓の自動結晶化プロトコル | Lesson auto-crystallization protocol |
| `INDEX.md` | 全ルールの詳細索引 | Detailed index of all rules |
| `compliance_matrix.md` | 要件対照表 | Compliance matrix |

### 🎯 プロンプト集 / Prompt Library

> プロンプトは用途別フォルダ（`develop/`, `audit/`, `govern/`, `operate/`）に整理されています。
> Prompts are organized into role-based folders (`develop/`, `audit/`, `govern/`, `operate/`).

**🚀 develop/ — 開発・実行 / Development & Execution**

| File | JA | EN |
|:-----|:---|:---|
| `develop/feature_development.md` | 新機能実装・既存改修・バグ修正・憲法監査を網羅的に実行するプロンプト | Comprehensive prompt for new feature implementation, improvement, bug fixing, and compliance auditing |
| `develop/refactoring_audit.md` | 既存コードの動作を保ったまま構造・型安全・DRY原則を極限まで改善する非破壊的リファクタリング監査プロンプト | Non-destructive refactoring audit — elevate structure, type safety, and DRY principles without changing existing behavior |
| `develop/push_execute.md` | 品質ゲート・DB整合性確認・ブランチ戦略遵守を経たGit Push実行プロンプト | Quality gate, DB integrity check, branch strategy compliance, and Atomic Push execution |
| `develop/ci_fix.md` | CI/CD失敗時のエラー再現・根本原因分析・修正・ルール還元を一貫実行するプロンプト | CI/CD failure error reproduction, root cause analysis, fix, and rule feedback |

**🔍 audit/ — 品質・整合性監査 / Quality & Integrity Auditing**

| File | JA | EN |
|:-----|:---|:---|
| `audit/fullstack_qa_audit.md` | セキュリティ・プライバシー最大化を筆頭にシリコンバレー基準6柱・優先度付き報告（Critical/High/Medium）・ROI提案・Domain Distributionによる知見還元を含む統合監査プロンプト | Full-Stack QA & Strategic audit — 6-Pillar Silicon Valley Standard with priority reporting, ROI proposals, Domain Distribution knowledge feedback |
| `audit/api_architecture_audit.md` | API設計・DTO義務・ゼロトラスト・オムニチャネル対応を軸とした全方位構造監査プロンプト | Omni-directional structural audit — API design, DTO obligations, Zero Trust, and omnichannel readiness |
| `audit/data_integrity_audit.md` | JSON逃がし・Hybrid Sync・Split Brain・ハリボテ実装を検知するデータ整合性監査プロンプト | Data integrity audit — JSON dump detection, Hybrid Sync / Split Brain elimination, and facade detection |
| `audit/system_integrity_audit.md` | 型安全性・API/DB同期・ハリボテ検知・データマネタイズ戦略を軸としたシステム全体整合性監査プロンプト | System integrity audit — type safety, API/DB sync, facade detection, and data monetization readiness |
| `audit/deep_optimization_audit.md` | メディア/LCP/SSR最適化漏れの根本原因特定・解消を軸としたシステム全体の深層最適化監査プロンプト | Deep optimization audit — media/LCP/SSR gap root cause detection, elimination, and full-system integrity |

**⚖️ govern/ — コンプライアンス・ガバナンス / Compliance & Governance**

| File | JA | EN |
|:-----|:---|:---|
| `govern/compliance_inspector_audit.md` | Universal/Blueprint法への完全準拠を強制する8つの重大憲法違反フレームワークに基づく深層コンプライアンス監査プロンプト | Deep constitutional compliance audit — 8 Major Constitutional Violations framework |
| `govern/constitution_compliance_audit.md` | 7つの重大憲法違反（アーキテクチャ・収益化統合・型安全・最適化・ハリボテ・根本原因）を軸とした深層憲法遵守スキャンプロンプト | Constitutional compliance scan — 7 Major Violations framework |
| `govern/governance_auditor.md` | 8つの柱（Security/Business/Legal/AI/Architecture/保守性/UX/Performance）で行う全方位ガバナンス監査プロンプト | Holistic governance audit — 8-Pillar framework with structured report format |
| `govern/blueprint_governance_audit.md` | 開発知見をBlueprintルールに結晶化する網羅的監査プロンプト | Comprehensive audit prompt to crystallize development insights into Blueprint rules |
| `govern/localization_audit.md` | Lazy English排除・UI日本語化率100%・LTV・AI/GEO・法務の全方位ローカリゼーション監査プロンプト | Localization audit — eliminating Lazy non-English UI text, achieving 100% English UI |

**🛡️ operate/ — インシデント・参入 / Incident Response & Onboarding**

| File | JA | EN |
|:-----|:---|:---|
| `operate/onboarding_audit.md` | 新セッション/メンバー参加時にコードベースを深く理解しアーキテクチャ・地雷・最初のアクションを把握する参入監査プロンプト | Codebase onboarding audit — deeply understand architecture, landmines, and first actions |
| `operate/incident_response.md` | 本番障害のトリアージ・5 Whys根本原因分析・緊急修正・ポストモーテム・再発防止ルール還元まで一貫実行するSRE専用プロンプト | SRE-focused prompt — triage, 5 Whys RCA, emergency fix, post-mortem, and recurrence-prevention rule crystallization |


> [!TIP]
> **JA**: `axiarch-prompts/` はルールとは独立した**再利用可能なプロンプトテンプレート集**です。AIエージェントに特定の高品質タスクを実行させる際に使用します。
>
> **EN**: `axiarch-prompts/` is a **reusable prompt template library** independent of rules. Use them to instruct AI agents to execute specific high-quality tasks.

---

## ⚡ クイックスタート / Quick Start

### 必須ファイル一覧 / Required Files

> [!TIP]
> **JA**: プロジェクトにコピーするのは **2つだけ**です。リポジトリ内のその他のファイル（`CHANGELOG.md`, `CONTRIBUTING.md` 等）は**このリポジトリ自体の管理用**であり、あなたのプロジェクトには不要です。
>
> **EN**: You only need to copy **2 items** to your project. Other files in this repository (`CHANGELOG.md`, `CONTRIBUTING.md`, etc.) are for **managing this repository itself** and are NOT needed in your project.

| ファイル / File | 必須？ / Required? | 説明 / Description |
|:---------------|:-------------------|:-------------------|
| `AGENTS.md` | ✅ **必須** / **Required** | AI行動憲法。全エージェント共通 / AI constitution. Universal for all agents |
| `axiarch-rules/` | ✅ **必須** / **Required** | ルール本体（Universal + Blueprint） / Rule definitions |
| `.agents/rules/prompt_pointer.md` | 🔶 **Antigravity のみ** / **Antigravity only** | Antigravity固有のポインター / Antigravity-specific pointer |
| `.cursor/rules/axiarch.mdc` | 🔶 **Cursor のみ** / **Cursor only** | Cursor固有のポインター。`init.sh` で自動コピー / Cursor-specific pointer. Auto-copied by `init.sh` |
| `.github/copilot-instructions.md` | 🔶 **Copilot のみ** / **Copilot only** | Copilot固有のポインター。`init.sh` で自動コピー / Copilot-specific pointer. Auto-copied by `init.sh` |
| `.windsurfrules` | 🔶 **Windsurf のみ** / **Windsurf only** | Windsurf固有のポインター。`init.sh` で自動コピー / Windsurf-specific pointer. Auto-copied by `init.sh` |
| `CLAUDE.md` | 🔶 **Claude Code のみ** / **Claude Code only** | `AGENTS.md` へのシムリンク。`init.sh` で自動作成 / Symlink to `AGENTS.md`. Auto-created by `init.sh` |
| `axiarch-prompts/` | 🔷 **任意** / **Optional** | プロンプトテンプレート集 / Prompt template library |
| `init.sh` | 🔷 **任意（推奨）** / **Optional (Recommended)** | 対話式セットアップスクリプト。言語/エージェント選択、ファイルコピー、次のステップを自動化 / Interactive setup script. Automates language/agent selection, file copy, and next-step guidance |
| `CHANGELOG.md` | ❌ 不要 / Not needed | リポジトリ管理用 / For this repo only |
| `CONTRIBUTING.md` | ❌ 不要 / Not needed | リポジトリ管理用 / For this repo only |
| `SECURITY.md` | ❌ 不要 / Not needed | リポジトリ管理用 / For this repo only |
| `CODE_OF_CONDUCT.md` | ❌ 不要 / Not needed | リポジトリ管理用 / For this repo only |
| `LICENSE` / `NOTICE` | ❌ 不要 / Not needed | リポジトリ管理用 / For this repo only |
| `.github/` | ❌ 不要 / Not needed | Issue/PRテンプレート。リポジトリ管理用 / Issue/PR templates. For this repo only |
| `.gitignore` | ❌ 不要 / Not needed | リポジトリ管理用 / For this repo only |

### エージェント別セットアップ / Agent-Specific Setup

| 手順 / Step | Antigravity | Cursor | Claude Code | Copilot | Windsurf |
|:-----------|:------------|:-------|:------------|:--------|:---------|
| 1. `AGENTS.md` + `axiarch-rules/` をコピー（`axiarch-prompts/` は任意） | ✅ | ✅ | ✅ | ✅ | ✅ |
| 2. `.agents/rules/prompt_pointer.md` を配置 | ✅ **必須** | ❌ 不要 | ❌ 不要 | ❌ 不要 | ❌ 不要 |
| 3. `CLAUDE.md` シムリンク作成 | ❌ 不要 | ❌ 不要 | ✅ `ln -s AGENTS.md CLAUDE.md` | ❌ 不要 | ❌ 不要 |
| 4. 追加設定 | — | 任意: `.cursor/rules/*.mdc` | — | 任意: `.github/copilot-instructions.md` | 任意: `.windsurfrules` |

### 1. プロジェクトにコピー / Copy to your project

> [!TIP]
> **JA**: `init.sh` を使うと対話式で言語・エージェントを選択してファイルを自動コピーできます。手動セットアップの代わりに使用可能です。
>
> **EN**: Use `init.sh` for an interactive setup that automatically selects language/agent and copies files. It can be used instead of manual setup.

```bash
# 推奨: init.sh で自動セットアップ / Recommended: Auto-setup with init.sh
curl -sSL https://raw.githubusercontent.com/hiroyuki-miyauchi/axiarch/main/init.sh | bash

# または手動でコピー / Or copy manually:
# 必須の2つだけコピー / Copy only the 2 required items
cp AGENTS.md /path/to/your/project/
cp -r axiarch-rules /path/to/your/project/

# 任意：プロンプト集もコピー / Optional: copy prompt library
cp -r axiarch-prompts /path/to/your/project/
```

### 2. エージェント固有の設定 / Agent-specific config

```bash
# === Google Antigravity ===
# .agents/rules/ はAntigravity固有。自動読み込み対象なのでポインターを配置。
# .agents/rules/ is Antigravity-specific. Place a pointer for auto-loading.
mkdir -p /path/to/your/project/.agents/rules
cp .agents/rules/prompt_pointer.md /path/to/your/project/.agents/rules/

# === Claude Code ===
# Claude CodeはCLAUDE.mdをネイティブに読むのでシムリンクを作成。
# Claude Code reads CLAUDE.md natively — create a symlink.
cd /path/to/your/project && ln -s AGENTS.md CLAUDE.md

# === Cursor ===
# ネイティブ設定ファイルが同梱されています。init.sh で自動コピーされます。
# A native config file is included. It is auto-copied by init.sh.
# 手動セットアップの場合 / For manual setup:
mkdir -p /path/to/your/project/.cursor/rules
cp .cursor/rules/axiarch.mdc /path/to/your/project/.cursor/rules/

# === GitHub Copilot ===
# ネイティブ設定ファイルが同梱されています。init.sh で自動コピーされます。
# A native config file is included. It is auto-copied by init.sh.
# 手動セットアップの場合 / For manual setup:
mkdir -p /path/to/your/project/.github
cp .github/copilot-instructions.md /path/to/your/project/.github/

# === Windsurf ===
# ネイティブ設定ファイルが同梱されています。init.sh で自動コピーされます。
# A native config file is included. It is auto-copied by init.sh.
# 手動セットアップの場合 / For manual setup:
cp .windsurfrules /path/to/your/project/
```

> [!CAUTION]
> **JA**: `.agents/rules/` は **Antigravity固有**のディレクトリです。Cursor、Claude Code、GitHub Copilotでは不要です。各ツールには固有の設定ディレクトリがあります（上表参照）。Antigravityの場合もポインターのみ配置し、ルール本体は `axiarch-rules/` に一元管理。
>
> **EN**: `.agents/rules/` is **Antigravity-specific**. It is NOT needed for Cursor, Claude Code, or GitHub Copilot. Each tool has its own native configuration directory (see table above). For Antigravity, only place the pointer here — rule definitions live in `axiarch-rules/`.

### 3. 初期化 / Initialize

```bash
# AGENTS.md を編集 → Project Native Language を Japanese または English に設定
# Edit AGENTS.md → Set Project Native Language to Japanese or English

# 使用しない言語ディレクトリを削除 / Delete unused language directory:
rm -rf axiarch-rules/universal/en axiarch-rules/blueprint/en  # For Japanese projects
# OR
rm -rf axiarch-rules/universal/ja axiarch-rules/blueprint/ja  # For English projects

# axiarch-prompts/ をコピーした場合 / If you copied axiarch-prompts/:
rm -rf axiarch-prompts/en  # For Japanese projects
# OR
rm -rf axiarch-prompts/ja  # For English projects
```

### 4. 設定と開発 / Configure & Develop

| Step | JA | EN |
|:-----|:---|:---|
| 1 | `blueprint/*/000_project_overview.md` をプロジェクトに合わせて編集 | Edit `blueprint/*/000_project_overview.md` for your project |
| 2 | 新機能は `998_feature_spec_template.md` を対応するドメインフォルダにコピー | For new features, copy `998_feature_spec_template.md` to the corresponding domain folder |
| 3 | **コードを書く前に受け入れ条件を書く**（Blueprint First） | **Write Acceptance Criteria before writing code** (Blueprint First) |
| 4 | 開発開始 — AIエージェントは憲法に従う | Start development — AI agents will follow the constitution |

### 導入後のディレクトリ構成 / Post-Setup Directory Structure

```text
your-project/
 ├── AGENTS.md                    ← 必須：最高法規 / Required: Supreme Law
 ├── CLAUDE.md                    ← Claude Code のみ（AGENTS.md へのシムリンク）
 ├── .agents/                     ← Antigravity のみ / Antigravity only
 │    └── rules/
 │         └── prompt_pointer.md  ← ポインター / Pointer
 ├── axiarch-rules/               ← 必須：ルール本体 / Required: Rule Definitions
 │    ├── INDEX.md
 │    ├── LOADING_PROTOCOL.md
 │    ├── CRYSTALLIZATION_PROTOCOL.md
 │    ├── universal/              ← 不変 / Immutable
 │    │    └── ja/ (or en/)
 │    └── blueprint/              ← プロジェクト固有 / Project-Specific
 │         └── ja/ (or en/)
 ├── axiarch-prompts/             ← 任意：プロンプト集 / Optional: Prompt Library
 │    ├── ja/                     ← 日本語版 / Japanese
 │    │    ├── develop/           ← 開発・実行 / Development & Execution
 │    │    ├── audit/             ← 品質監査 / Quality Auditing
 │    │    ├── govern/            ← ガバナンス / Governance
 │    │    └── operate/           ← インシデント・参入 / Incidents & Onboarding
 │    └── en/                     ← 英語版 / English
 │         ├── develop/
 │         ├── audit/
 │         ├── govern/
 │         └── operate/
 └── src/                         ← プロジェクトコード / Your Code
```

---

## 🏗️ 背景 / Background

### 🇯🇵 なぜAxiarchを作ったか

Axiarch（アクシアーク）は、AIとの協働における品質課題への危機感から生まれました。

AIエージェントが登場する以前から、生成AI（ChatGPT等）を新規事業の構想や実務の中で活用していました。コードを書かせてみることもありましたが、本格的な開発に使ったわけではありません。それでも、AIと向き合う中でひとつだけ確信していたことがありました — **ハルシネーション、コンテキストの喪失、品質のブレ。明確なルールなしにAIを使い続ければ、いつか必ず破綻する。**

2025年、[Google Antigravity](https://labs.google/antigravity)のようなAIエージェントが登場したとき、直感しました：**「ガバナンス構造なしにこれを使い始めたら取り返しがつかない」**と。逆に言えば、**最初から「憲法」を整備すれば、品質を劇的に底上げできる**はずだと。

そこで、開発を始める**前に**強固なガバナンスの構築に着手しました。そしてそのアーキテクチャを携えて実際のプロダクション開発に投入し、数百セッションの実績を経てブラッシュアップしていきました。

**その過程で、ルールなしでは解決不可能なパターンが明確になりました：**

- **コンテキスト健忘症。** セッション間でアーキテクチャの決定を忘れる。命名規約がドリフトする。セキュリティパターンが退行する。修正済みのバグが再導入される。
- **操縦者依存の品質。** 正確な指示を出せば優れた成果物が出る。曖昧な指示では、バリデーションを省略し、型安全を無視し、安易なショートカットに逃げる。
- **Vibe Coding の引力。** 明示的な制約がなければ、すべてのセッションが "vibe coding" に引き寄せられる — 正しく見えるが、確立されたパターンを暗黙に違反するコード。
- **知見の蒸発。** 苦労して得た教訓が失われ、同じ問題を何度も再発見させられる。

業界全体も同じ問題に直面していました。AIが生成したコードがセキュリティ脆弱性の主要な原因となりつつあるとの報告、"AI slop"現象 — 低品質・重複コードの氾濫、コンテキストウィンドウの劣化による一貫性の喪失。個別ステップの成功率95%でも、マルチステップのワークフローでは60%以上の失敗率に膨れ上がります。

**気づき：** 問題はAIモデルではなく、*ガバナンスの不在*でした。セッション、操縦者、コンテキストリセットを超えて生き残る、永続的で強制力のあるガバナンス構造 — 「憲法」 — が存在しなかったのです。

Axiarchがその答えです。作者自身、フロントエンドエンジニアとしての経験はあるものの、バックエンドやインフラは未経験からのスタートでした。だからこそ、**特定の言語やフレームワークに依存せず、エンジニア経験の深さに関わらず、AIと協働するすべての開発者 — 非エンジニアや個人開発者を含む — が最低限の品質底上げを実現できる**フレームワークを目指しました。

世界中の開発者がAIエージェントの恩恵を最大限に受けられるように。特にAI活用においてまだ発展途上にある日本からの発信として、自国のAI活用促進にも貢献できればと考えています。そして何より、この取り組み自体が自身の知見を深めるプロセスでもあります。

成果：2,500以上のエンジニアリング基準を網羅する38のUniversalルールファイル、ハルシネーションリスクを軽減する5ステップのBoot Sequence Protocol、教訓を自動的にルールに変換するCrystallization Protocol。すべて、たった一つの `AGENTS.md` 憲法を通じて強制されます。

### 🇺🇸 Why Axiarch Was Built

Axiarch was born from a conviction that AI without governance will inevitably fail.

Before AI agents existed, working with generative AI (ChatGPT, etc.) for business planning and day-to-day work revealed a persistent truth — **hallucinations, context loss, and inconsistent quality are inevitable without explicit rules.** AI is powerful, but using it without governance guarantees eventual failure.

When AI agents like [Google Antigravity](https://labs.google/antigravity) emerged in 2025, the intuition was immediate: **"Starting without a governance structure would be irreversible."** Conversely, **establishing a "constitution" from day one could dramatically raise the quality floor.**

So the governance architecture was built **before** development began. Then it was deployed into real production development and refined through hundreds of real production sessions building Inucomi.

**Through that process, patterns that were impossible to solve without governance became clear:**

- **Context amnesia.** The AI forgot architectural decisions between sessions. Naming conventions drifted. Security patterns regressed. Fixed bugs were re-introduced.
- **Operator-dependent quality.** When instructions were precise, output was excellent. When vague, the AI took shortcuts — skipping validation, ignoring type safety, reaching for easy escapes.
- **Vibe coding gravity.** Without explicit constraints, every session tended toward "vibe coding" — code that looked correct but silently violated established patterns.
- **Knowledge evaporation.** Hard-won lessons were lost and had to be re-discovered repeatedly.

The industry was facing the same problem at scale. AI-generated code becoming a common vector for security vulnerabilities. The "AI slop" phenomenon — proliferation of low-quality, duplicated code — accelerating technical debt. Context window degradation causing models to lose coherence. Individual step reliability of 95% compounding to 60%+ failure rates across multi-step workflows.

**The realization:** The problem wasn't the AI model. It was the absence of *governance*. There was no "constitution" — no persistent, enforceable set of rules that survived across sessions, operators, and context resets.

Axiarch was the answer. The author's own background — front-end engineering experience, but no prior back-end or infrastructure expertise — shaped the core design principle: **language-agnostic, framework-agnostic, and accessible regardless of engineering experience. A Constitution-Driven AI Agent Governance Framework that enables any developer working with AI — including non-engineers and solo developers — to raise their minimum quality floor.**

The goal extends beyond personal use: to contribute to the global adoption of AI-assisted development, and to help accelerate AI utilization worldwide. The result: 38 Universal Rule files covering 2,500+ engineering standards, a 5-step Boot Sequence Protocol that reduces startup hallucination risk, a Crystallization Protocol that automatically converts lessons into rules. All enforced through a single `AGENTS.md` constitution that any AI agent can read.

---

## 💡 設計思想 / Philosophy

**Axiarch** は、「普遍憲法（Universal）」と「固有仕様（Blueprint）」の明確な責務分離による**2大コア層**と、確実な実行を担保する**有志の第3層（Prompts）**からなる**「3層統合ガバナンス・アーキテクチャ（Three-Layer Governance Architecture）」**の上に構築されています。

**Axiarch** is built on a **"Three-Layer Governance Architecture"**, strictly separating responsibilities into two core layers—the **Immutable Constitution (Universal)** and the **Mutable Project State (Blueprint)**—plus a third **Optional Execution Layer (Prompts)**.

### 🏛️ The Three-Layer Architecture (3層ガバナンス構造)

#### Layer 1: Universal (不変層 / Immutable Constitution)
- **役割**: 時代やプロジェクトが変わっても揺るがない「ソフトウェア開発およびプロダクト運用の絶対的基準と制約」を定義する岩盤層（`AGENTS.md` + `universal/`）。
- **特性**: **Read-Only（強制保護）**。AIエージェントによる独断の変更を固く禁じた「不変の領域」です。AI特有の独自解釈（Vibe Coding）やセキュリティ脆弱化のリスクを構造的に軽減します。

#### Layer 2: Blueprint (可変層 / Mutable Project State)
- **役割**: プロジェクトの事業目的、固有の機能仕様、そして開発中に得られた「実践の教訓」を蓄積・結晶化する層（`blueprint/`）。
- **特性**: **Read-Write（動的成長）**。AIエージェント自身が継続的に仕様や教訓を書き込み、自律ロードを通じて文脈を復元するための「生きた記憶領域」です。「昨日までの前提を忘れる（Context Amnesia）」リスクを大幅に軽減し、継続的な品質の底上げ（Quality Floorの向上）をもたらします。

#### Layer 3: Prompts (完全任意層 / Purely Optional Execution Engine)
- **役割**: Layer 1と2のルールを、特定タスク（セキュリティ監査、設計最適化、インシデント対応など）へ強制的に呼び出し適用させるエンジン（`axiarch-prompts/`）。
- **特性**: **Optional（完全任意）**。Axiarchの核はLayer 1と2の遵守であり、Layer 3を導入しなくてもフレームワーク自体は機能します。必要に応じて特定の高品質タスクを実行するためのオプショナルなプラグインとして機能します。

---

### 原則 / Principles

| 原則 / Principle | JA | EN |
|:-----------------|:---|:---|
| **Blueprint First** | 大規模変更は実装前に仕様更新を義務化 | Specs before code — major changes require spec updates before implementation |
| **Multi-step refinement** | INDEX → ルールロード → Blueprint → タスク → 計画 → 実装 → Walkthrough → 教訓 | INDEX → Rule Load → Blueprint → Task → Plan → Implement → Walkthrough → Lessons |
| **Strong guardrails** | 16の禁止事項 + 5つのプロトコル + 3層Git Hooks | 16 prohibitions + 5 protocols + 3-layer Git Hooks |
| **Continuous learning** | タスク完了後に教訓をルールに結晶化 | Lessons crystallized into rules after every task |
| **Quality floor** | 操縦者のスキルに関わらず最低品質基準を強制 | Minimum standards enforced regardless of operator skill |

> **JA**: Axiarch（アクシアーク）の核心的価値は、単なるプロンプトの集合体ではなく、この「**普遍（Layer 1）と可変（Layer 2）の明確な責務分離**」と「**プロンプト（Layer 3）による実行駆動**」という3層構造による状態管理アーキテクチャにあります。「Blueprint First（実装前の仕様定義の義務化）」と「憲法」を連動させることで、AIのハルシネーションや品質ドリフトを防ぐための堅牢なガバナンス基盤となり、開発から運用までの全体品質の底上げをもたらします。
> 
> **EN**: Axiarch's core value lies not in being a mere prompt collection, but in its state-management architecture built upon "the **Clear Separation of Immutable (Layer 1) and Mutable (Layer 2)**" and "the **Execution-driven Prompts (Layer 3)**". By integrating "Blueprint First" with the Constitution, it serves as a robust governance foundation that structurally mitigates AI hallucinations and quality drift, thereby raising the overall quality floor from development to operations.


---

## 🤝 コントリビュート / Contributing

**JA**: コントリビュートを歓迎します。プルリクエストの前に、まずIssueで変更提案を議論してください。

**EN**: Contributions are welcome. Please open an issue to discuss proposed changes before submitting a pull request.

> [!IMPORTANT]
> **JA**: Universal Rules (`universal/`) は**憲法**です。変更には明示的な「憲法改正」の承認が必要です。Blueprintテンプレートや基盤ファイルは通常のコントリビュートを受け付けます。
>
> **EN**: Universal Rules (`universal/`) are the **Constitution**. Modifications require explicit "Amend Constitution" approval. Blueprint templates and infrastructure files accept standard contributions.

---

## 📄 ライセンス / License

**JA**: このプロジェクトは **Apache License 2.0** の下でライセンスされています。詳細は [LICENSE](LICENSE) ファイルを参照してください。

**EN**: This project is licensed under the **Apache License 2.0** — see the [LICENSE](LICENSE) file for details.

---

## 著者 / Author

**Hiroyuki Miyauchi** — [LinkedIn](https://www.linkedin.com/in/hiroyuki-miyauchi/) / [chronoviq.com](https://chronoviq.com/)

**JA**: バグ報告や機能リクエストは [GitHub Issues](https://github.com/hiroyuki-miyauchi/axiarch/issues) をご利用ください。

**EN**: For bug reports and feature requests, use [GitHub Issues](https://github.com/hiroyuki-miyauchi/axiarch/issues).
