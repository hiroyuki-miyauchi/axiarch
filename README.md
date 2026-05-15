<div align="center">

# 🏰 Axiarch

## 憲法駆動型 AIエージェントガバナンスフレームワーク

## Constitution-Driven AI Agent Governance Framework

[![Release](https://img.shields.io/github/v/release/hiroyuki-miyauchi/axiarch?label=Version&color=brightgreen)](https://github.com/hiroyuki-miyauchi/axiarch/releases)
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Rules](https://img.shields.io/badge/Universal_Rules-39_files-green.svg)](#-universal-rules-39-files--jaen)
[![Languages](https://img.shields.io/badge/Languages-🇯🇵_🇺🇸_Bilingual-orange.svg)](#-同梱内容--whats-included)
[![Verified](https://img.shields.io/badge/Verified-Google_Antigravity-green.svg)](#-aiエージェント互換性--ai-agent-compatibility) [![Primary Targets](https://img.shields.io/badge/Primary_Targets-Codex_|_Claude_Code-blue.svg)](#-aiエージェント互換性--ai-agent-compatibility) [![Extended](https://img.shields.io/badge/Extended-Pointer_Only_No_Guarantee-yellow.svg)](#-aiエージェント互換性--ai-agent-compatibility)

[日本語](#-axiarchアクシアークとは) ・ [English](#-what-is-axiarch-ax-ee-ark)

</div>

---

## 🇯🇵 Axiarch（アクシアーク）とは

**Axiarch（アクシアーク）** は、**憲法駆動型の AIエージェントガバナンスフレームワーク（Constitution-Driven AI Agent Governance Framework）**です。
「普遍憲法（Universal・不変）」と「固有ルール（Blueprint・可変）」の明確な責務分離、さらにそれを実行駆動する「プロンプト（Prompts・任意層）」という **3層統合ガバナンス・アーキテクチャ** が Axiarch の中核です。AI支援開発におけるハルシネーションや品質ドリフト（退行）のリスクをこの構造によって軽減し、操縦者のスキルレベルに依存しすぎない形で、プロジェクト全体の最低品質（Quality Floor）を底上げすることを狙います。

Axiarch は [Google Antigravity](https://antigravity.google/) で実務検証済みの運用知見を土台に、[OpenAI Codex](https://developers.openai.com/codex/guides/agents-md) と [Claude Code](https://www.anthropic.com/claude-code) を主対象に据えた AIエージェントガバナンス層です。Claude Code は v1.4.0+ の `UserPromptSubmit` hook / v1.5.5+ `PreToolUse` 物理遮断 / v1.6.0+ Reminder TTL / v1.8.0+ Check D Task Boundary Detection、Codex は v1.8.2+ の `.codex/hooks.json` ネイティブ統合を備えます。ただし、Google Antigravity 以外の実務検証は継続中であり、Cursor、GitHub Copilot、Windsurf は Markdown ルール接続の入口を用意した拡張互換候補として扱います。いずれもエージェント実装と利用環境に依存するため、動作保証ではありません。

### 設計思想

- **プロンプト集ではありません。** **操縦者が変わっても最低品質の床（Quality Floor）を保ちやすくする**、多層ガバナンス設計です。
- **操縦者に依存しすぎない品質ベースライン。** シニアエンジニアが使っても初心者が使っても、同一の憲法基準を参照できる状態を作ります。
- **3層ガバナンス分離。** 「不変の憲法基準（Universal）」と「プロジェクトで成長する動的仕様（Blueprint）」の責務を分離し、AIの「コンテキスト忘却」や「ルール形骸化」のリスクを構造的に下げます。

### なぜ必要か

| ガバナンスなし | Axiarchあり |
|:-------------|:--------------------------|
| AIが「それっぽいが壊れている」コードを生成 | Bug / Warning削減ポリシーを憲法で基準化 |
| 品質が操縦者のスキルに過度に依存 | Universal Rulesが最低品質の床を設定 |
| 仕様なしの vibe coding | Blueprint First：コードより先に仕様を定義 |
| セッション間で知見が消失 | 教訓ログが知見をルールに結晶化 |
| AIがプロジェクト構造を幻覚で生成 | Boot Sequence Protocol：実ファイルを読んでから判断する |

### アーキテクチャ

```text
┌─────────────────────────────────────────────────────────────┐
│ 第1層: Universal (普遍憲法 / Immutable)                       │
│ ├─ AGENTS.md (最上位プロトコル / 行動プロトコル)                        │
│ └─ Universal Rules (39ファイル: 不変の普遍的基準)               │
├─────────────────────────────────────────────────────────────┤
│ 第2層: Blueprint (固有仕様 / Mutable)                         │
│ └─ プロジェクト概要、機能仕様、教訓ログ等の可変ルール              　│
├─────────────────────────────────────────────────────────────┤
│ 第3層: Prompts (実行エンジン / Optional)                       │　
│ └─ 監査・品質担保タスク用の任意プロンプト・フレームワーク            │
├─────────────────────────────────────────────────────────────┤
│ 実行ドキュメント — タスク単位                           ← 生成   │
│ task.md, implementation_plan.md, walkthrough.md             │
├─────────────────────────────────────────────────────────────┤
│ フィードバックループ — 結晶化                           ← 継続的 │
│ 教訓 → ルール(第2層) → より良い教訓                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 🇺🇸 What is Axiarch (AX-ee-ark)?

**Axiarch** is a **Constitution-Driven AI Agent Governance Framework**.
It is designed to help govern AI-assisted work and reduce the risk of quality drift, hallucinations, and uncontrolled AI behavior through a **Three-Layer Governance Architecture**: Layer 1 **Universal** (Immutable Constitution), Layer 2 **Blueprint** (Mutable Project State), and Layer 3 **Prompts** (Optional Execution Triggers).

Axiarch now focuses its first-class support strategy on [Google Antigravity](https://antigravity.google/), [OpenAI Codex](https://developers.openai.com/codex/guides/agents-md), and [Claude Code](https://www.anthropic.com/claude-code). It is production-validated with Google Antigravity. Codex and Claude Code are primary targets with native integration paths, but their practical validation remains environment-dependent. Cursor, GitHub Copilot, and Windsurf are treated as extended pointer-only compatibility candidates through Markdown pointer files, not as production-validated primary platforms.

### Core Design Philosophy

- **Not a prompt collection.** It is a **multi-layered governance architecture** that makes minimum quality standards easier to maintain **regardless of who operates the AI agent.**
- **Less operator-dependent quality baseline.** Whether a senior engineer or a beginner uses the AI, the constitution keeps the same standards visible and actionable.
- **Three-layer separation.** By decoupling "Immutable Universal standards" from "Mutable Blueprint states", Axiarch reduces the risk of context amnesia and rule atrophy.

### The Problem

| Without Governance | With Axiarch |
|:-------------------|:--------------------------|
| AI generates code that "looks right" but breaks silently | Constitution defines a bug/warning reduction policy as a quality standard |
| Quality depends entirely on the operator's skill | Universal Rules set a minimum quality floor |
| No structure for specs → vibe coding | Blueprint First: specs before code, always |
| Lessons learned are lost between sessions | Lessons Log crystallizes knowledge into rules |
| AI hallucinates project structure and rules | Boot Sequence Protocol: read actual rule files before acting |

### Architecture

```text
┌───────────────────────────────────────────────────────────────┐
│ Layer 1: Universal (Immutable Constitution)                   │
│ ├─ AGENTS.md (Top-Level Protocol / Behavior Protocols)               │
│ └─ Universal Rules (39 files / Immutable Universal Standards) │
├───────────────────────────────────────────────────────────────┤
│ Layer 2: Blueprint (Mutable Project State)                    │
│ └─ Project Overview, Feature Specs, Lessons Log               │
├───────────────────────────────────────────────────────────────┤
│ Layer 3: Prompts (Optional Execution Framework)               │
│ └─ Task-specific prompts for auditing and QA execution        │
├───────────────────────────────────────────────────────────────┤
│ Execution Documents — Per-Task                       ← Gen.   │
│ task.md, implementation_plan.md, walkthrough.md               │
├───────────────────────────────────────────────────────────────┤
│ Feedback Loop — Crystallization                      ← Cont.  │
│ Lessons → Rules(Layer 2) → Better Lessons                     │
└───────────────────────────────────────────────────────────────┘
```

---

## 🔌 AIエージェント互換性 / AI Agent Compatibility

| 位置づけ / Role | Agent | Native Config | AGENTS.md |
|:----------------|:------|:--------------|:----------|
| ✅ **Primary Verified** — 実務で実証済み / Production-validated | **Google Antigravity** | `.agents/rules/` | ✅ Reads |
| ⚙️ **Primary Target** — 主対象（v1.8.2+ ネイティブ統合） / Primary target (v1.8.2+ native integration) | **OpenAI Codex** | `AGENTS.md` + `.codex/hooks.json` | ✅ Native |
| ⚙️ **Primary Target** — 主対象（v1.4.0+ ネイティブ hook 統合） / Primary target (v1.4.0+ native hook integration) | **Claude Code** | `CLAUDE.md` + `.claude/settings.json` (3 hooks) | ✅ Reads |
| ⚠️ **Extended Pointer Only** — 拡張ポインターのみ（未検証・動作保証なし） / Extended pointer only (unverified, no operation guarantee) | **Cursor** | `.cursor/rules/*.mdc` | ✅ Reads |
| ⚠️ **Extended Pointer Only** — 拡張ポインターのみ（未検証・動作保証なし） / Extended pointer only (unverified, no operation guarantee) | **GitHub Copilot** | `.github/copilot-instructions.md` | ✅ Reads |
| ⚠️ **Extended Pointer Only** — 拡張ポインターのみ（未検証・動作保証なし） / Extended pointer only (unverified, no operation guarantee) | **Windsurf** | `.windsurfrules` | ✅ Reads |
| ⚠️ **Unverified** — 未検証（動作保証なし） / Unverified (no operation guarantee) | **Aider / Zed / Other** | Various | ✅ Reads |

> [!NOTE]
> **JA**: 各AIエージェントには**固有の設定ディレクトリ**があります（例: Cursorは `.cursor/rules/`、Copilotは `.github/copilot-instructions.md`）。`AGENTS.md` は**主要エージェントが読める共通憲法**であり、各ツールのネイティブ設定（例：`.cursor/rules/`、`.github/copilot-instructions.md`）と**併用**されます。ツール固有のセットアップの代替ではありません。OpenAI Codexは `AGENTS.md` 自体をネイティブ設定として採用しているため、追加のポインターファイルは不要です。
>
> **EN**: Each AI agent has its **own native configuration directory** (e.g., `.cursor/rules/` for Cursor, `.github/copilot-instructions.md` for Copilot). `AGENTS.md` is a **shared constitution readable by major agents**, designed to complement each tool's native config (e.g., `.cursor/rules/`, `.github/copilot-instructions.md`). It is NOT a replacement for tool-specific setup. OpenAI Codex natively uses `AGENTS.md` as its configuration format, so no additional pointer file is needed.

> [!IMPORTANT]
> **JA**: 実務検証済みとして明示できる主対象は **[Google Antigravity](https://antigravity.google/)** です。**[OpenAI Codex](https://developers.openai.com/codex/guides/agents-md)** と **[Claude Code](https://www.anthropic.com/claude-code)** は主対象としてネイティブ統合を整備していますが、実務検証は継続中です。Cursor / GitHub Copilot / Windsurf は拡張互換候補としてポインター設定を用意していますが、検証済みまたは動作保証済みとは扱いません。
>
> **EN**: The only explicitly production-validated primary target is **Google Antigravity**. **OpenAI Codex** and **Claude Code** are primary targets with native integration paths, but practical validation is still ongoing. Cursor, GitHub Copilot, and Windsurf have pointer files as extended compatibility candidates, but they are not presented as verified or operation-guaranteed platforms.

> [!TIP]
> **JA**: フォルダ名 `axiarch-rules/` は出自を反映していますが、ルールファイル自体は純粋なMarkdownであり、ツール固有の実行時依存はありません。
>
> **EN**: The folder name `axiarch-rules/` reflects its origin, but the rule files themselves are pure Markdown with no tool-specific runtime dependency.

---

## 📦 同梱内容 / What's Included

### 🏛️ 最上位プロトコル / Top-Level Protocol

| File | JA | EN |
|:-----|:---|:---|
| `AGENTS.md` | AI行動憲法（Antigravityは実務検証済み、Codex / Claude Code は主対象、Cursor / Copilot / Windsurf は拡張ポインターのみ） | AI Behavior Constitution (Antigravity is production-validated; Codex / Claude Code are primary targets; Cursor / Copilot / Windsurf are extended pointer-only candidates) |

### 📚 Universal Rules (39 files × JA/EN)

> Universal Rules はプロジェクトで使う可能性のある技術・運用領域を横断する基準ルール集です。AIは LOADING_PROTOCOL に従い、タスクに必要なファイルのみを選択的にロードします。使わない技術のルールは任意の参照対象であり、将来採用時や未知の技術に直面したときの品質底上げを支える補助資産として扱います。
>
> Universal Rules is a baseline governance rule library across technology and operational domains. The AI selectively loads only what each task requires, following LOADING_PROTOCOL. Rules for technologies your project does not currently use are optional reference assets that help raise the quality floor when those technologies become relevant.

| Category | Files | JA | EN |
|:---------|:------|:---|:---|
| Core & Mindset | 1 | 開発哲学、主要方針 | Development philosophy, primary directive |
| Product & Business | 9 | プロダクト戦略、市場検証、GTM、収益、価格、グロース、ブランド、ASO、IR | Product strategy, market validation, GTM, revenue, pricing, growth, brand, ASO, IR |
| Design & UX | 1 | デザインシステム、A11y | Design system, accessibility |
| Engineering | 10 | コード品質(80§)、API、Supabase、Web、CMS、Flutter、Native、Firebase、AWS、**Git Workflow** | Code quality (80§), API, Supabase, Web, CMS, Flutter, Native, Firebase, AWS, **Git Workflow** |
| AI & Data | 2 | AIエンジニアリング、データ分析 | AI Engineering, Data Analytics |
| Operations | 7 | 内部ツール、営業・BizDev、HR、CX、SRE、インシデント、パートナーシップ | Internal tools, sales/BizDev, HR, CX, SRE, incident response, partnerships |
| Security & Legal | 4 | セキュリティ、データガバナンス、OSSコンプライアンス、知的財産 | Security, data governance, OSS compliance, IP |
| QA & FinOps | 2 | テスト戦略、クラウドFinOps | Test strategy, Cloud FinOps |
| Global & Governance | 3 | i18n、ガバナンス、言語プロトコル | i18n, governance, language protocol |

### 📐 Blueprint (プロジェクト固有テンプレート / Project-Specific Templates)

| File | JA | EN |
|:-----|:---|:---|
| `core/000_project_overview.md` | プロジェクト概要テンプレート | Project overview template |
| `core/010_project_lessons_log.md` | 教訓ログ | Lessons log |
| `core/998_feature_spec_template.md` | **機能仕様テンプレート（Blueprint Firstの核）** — 受け入れ条件(Given/When/Then)を機能単位で必須化 | **Feature spec template (Blueprint First core)** — Acceptance Criteria (Given/When/Then) required per feature |
| `core/999_project_specific_template.md` | プロジェクト固有ルールテンプレート | Project-specific rule template |

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
| `develop/refactoring_audit.md` | 既存コードの動作を保ったまま構造・型安全・DRY原則を高い水準まで改善する非破壊的リファクタリング監査プロンプト | Non-destructive refactoring audit — elevate structure, type safety, and DRY principles without changing existing behavior |
| `develop/push_execute.md` | 品質ゲート・DB整合性確認・ブランチ戦略遵守を経たGit Push実行プロンプト | Quality gate, DB integrity check, branch strategy compliance, and Atomic Push execution |
| `develop/ci_fix.md` | CI/CD失敗時のエラー再現・根本原因分析・修正・ルール還元を一貫実行するプロンプト | CI/CD failure error reproduction, root cause analysis, fix, and rule feedback |

**🔍 audit/ — 品質・整合性監査 / Quality & Integrity Auditing**

| File | JA | EN |
|:-----|:---|:---|
| `audit/fullstack_qa_audit.md` | セキュリティ・プライバシーの継続改善を筆頭に実務で検証可能な品質観点6柱・優先度付き報告（Critical/High/Medium）・ROI提案・Domain Distributionによる知見還元を含む統合監査プロンプト | Full-Stack QA & Strategic audit — 6-Pillar operational quality review with priority reporting, ROI proposals, Domain Distribution knowledge feedback |
| `audit/api_architecture_audit.md` | API設計・DTO義務・ゼロトラスト・オムニチャネル対応を軸とした全方位構造監査プロンプト | Omni-directional structural audit — API design, DTO obligations, Zero Trust, and omnichannel readiness |
| `audit/data_integrity_audit.md` | JSON逃がし・Hybrid Sync・Split Brain・ハリボテ実装を検知するデータ整合性監査プロンプト | Data integrity audit — JSON dump detection, Hybrid Sync / Split Brain elimination, and facade detection |
| `audit/system_integrity_audit.md` | 型安全性・API/DB同期・ハリボテ検知・データマネタイズ戦略を軸としたシステム全体整合性監査プロンプト | System integrity audit — type safety, API/DB sync, facade detection, and data monetization readiness |
| `audit/deep_optimization_audit.md` | メディア/LCP/SSR最適化漏れの根本原因特定・改善を軸としたシステム全体の深層最適化監査プロンプト | Deep optimization audit — media/LCP/SSR gap root cause detection, improvement, and full-system integrity |

**⚖️ govern/ — コンプライアンス・ガバナンス / Compliance & Governance**

| File | JA | EN |
|:-----|:---|:---|
| `govern/compliance_inspector_audit.md` | Universal/Blueprint法への準拠状況を点検する8つの重大憲法違反フレームワークに基づく深層コンプライアンス監査プロンプト | Deep constitutional compliance audit — 8 Major Constitutional Violations framework |
| `govern/constitution_compliance_audit.md` | 7つの重大憲法違反（アーキテクチャ・収益化統合・型安全・最適化・ハリボテ・根本原因）を軸とした深層憲法遵守スキャンプロンプト | Constitutional compliance scan — 7 Major Violations framework |
| `govern/governance_auditor.md` | 8つの柱（Security/Business/Legal/AI/Architecture/保守性/UX/Performance）で行う全方位ガバナンス監査プロンプト | Holistic governance audit — 8-Pillar framework with structured report format |
| `govern/blueprint_governance_audit.md` | 開発知見をBlueprintルールに結晶化する網羅的監査プロンプト | Comprehensive audit prompt to crystallize development insights into Blueprint rules |
| `govern/localization_audit.md` | プロジェクト母語UIの網羅確認・LTV・AI/GEO・法務の全方位ローカリゼーション監査プロンプト | Localization audit — reducing lazy non-native UI text and reviewing native-language UI coverage |

**🛡️ operate/ — インシデント・参入 / Incident Response & Onboarding**

| File | JA | EN |
|:-----|:---|:---|
| `operate/onboarding_audit.md` | 新セッション/メンバー参加時にコードベースを深く理解しアーキテクチャ・地雷・最初のアクションを把握する参入監査プロンプト | Codebase onboarding audit — deeply understand architecture, landmines, and first actions |
| `operate/incident_response.md` | 本番障害のトリアージ・5 Whys根本原因分析・緊急修正・ポストモーテム・再発リスク低減ルール還元まで一貫実行するSRE専用プロンプト | SRE-focused prompt — triage, 5 Whys RCA, emergency fix, post-mortem, and recurrence-risk-reduction rule crystallization |


> [!TIP]
> **JA**: `axiarch-prompts/` はルールとは独立した**再利用可能なプロンプトテンプレート集**です。AIエージェントに特定の高品質タスクを実行させる際に使用します。
>
> **EN**: `axiarch-prompts/` is a **reusable prompt template library** independent of rules. Use them to instruct AI agents to execute specific high-quality tasks.

---

## ⚡ クイックスタート / Quick Start

### 必須ファイル一覧 / Required Files

> [!TIP]
> **JA**: 最小構成でプロジェクトにコピーする必須項目は **2つだけ**です。Hook、ポインター、プロンプト、スクリプトは、使うエージェントや運用方針に応じた任意または条件付きファイルです。リポジトリ内のその他のファイル（`CHANGELOG.md`, `CONTRIBUTING.md` 等）は**このリポジトリ自体の管理用**であり、あなたのプロジェクトには不要です。
>
> **EN**: The minimal required setup only needs **2 items** copied to your project. Hooks, pointer files, prompts, and scripts are optional or conditional depending on the agent and workflow you choose. Other files in this repository (`CHANGELOG.md`, `CONTRIBUTING.md`, etc.) are for **managing this repository itself** and are NOT needed in your project.

| ファイル / File | 必須？ / Required? | 説明 / Description |
|:---------------|:-------------------|:-------------------|
| `AGENTS.md` | ✅ **必須** / **Required** | AI行動憲法。全エージェント共通 / AI constitution. Universal for all agents |
| `axiarch-rules/` | ✅ **必須** / **Required** | ルール本体（Universal + Blueprint） / Rule definitions |
| `.codex/hooks.json` | 🔶 **Codex hook利用時のみ** / **Codex hook use only** | Codex固有のhook設定。`init.sh` で自動コピー / Codex-specific hook config. Auto-copied by `init.sh` |
| `.agents/rules/prompt_pointer.md` | 🔶 **Antigravity のみ** / **Antigravity only** | Antigravity固有のポインター / Antigravity-specific pointer |
| `.cursor/rules/axiarch.mdc` | 🔶 **Cursor のみ** / **Cursor only** | Cursor固有のポインター。`init.sh` で自動コピー / Cursor-specific pointer. Auto-copied by `init.sh` |
| `.github/copilot-instructions.md` | 🔶 **Copilot のみ** / **Copilot only** | Copilot固有のポインター。`init.sh` で自動コピー / Copilot-specific pointer. Auto-copied by `init.sh` |
| `.windsurfrules` | 🔶 **Windsurf のみ** / **Windsurf only** | Windsurf固有のポインター。`init.sh` で自動コピー / Windsurf-specific pointer. Auto-copied by `init.sh` |
| `CLAUDE.md` | 🔶 **Claude Code のみ** / **Claude Code only** | Claude Code固有のポインター。`init.sh` で自動コピー / Claude Code-specific pointer. Auto-copied by `init.sh` |
| `.claude/settings.json` | 🔶 **Claude Code hook利用時のみ** / **Claude Code hook use only** | 3 hooks（SessionStart / UserPromptSubmit / PreToolUse(Write)）のhook設定。`init.sh` で自動コピー / Three-hook config (SessionStart / UserPromptSubmit / PreToolUse with Write matcher). Auto-copied by `init.sh` |
| `axiarch-scripts/` | 🔶 **Hook利用時のみ必要** / **Required only for hook use** | 診断・ヘルスチェックスクリプト集 + UserPromptSubmit / PreToolUse / SessionStart hook 外出しスクリプト群。Hookを有効にする場合は必要、診断だけに使う場合は任意です（`check-axiarch-health.sh` で全プロトコル遵守を **14 段階診断**（v1.8.0+、`--quiet` flag 対応）、`axiarch-boot-reminder.sh` で動的違反検出 (Check A/B/C) + **TTL 二段階出力**（v1.6.0+、token 約 87% 削減） + **Check D Task Boundary Detection**（v1.8.0+、task.md / implementation_plan.md / walkthrough.md の 3 ファイル scan で confirmation-bias loophole を検出しやすくする）、`axiarch-protect-antifull.sh` で §6 hook遮断、`axiarch-init-task-md.sh` で task.md 自動 bootstrap、`check-git-config-clean.sh` で `.git/config` 健全性チェック）。`init.sh` で自動コピー、**pre-commit hook installer 任意導入対応**（v1.6.0+）/ Diagnostic & hook scripts. Required when hooks are enabled; optional when used only for diagnostics (`check-axiarch-health.sh` 14-stage compliance with `--quiet`, `axiarch-boot-reminder.sh` dynamic violations (A/B/C) + two-stage TTL + Check D task-boundary detection across 3 process docs (v1.8.0+), `axiarch-protect-antifull.sh` §6 hook block, `axiarch-init-task-md.sh` task.md auto-bootstrap, `check-git-config-clean.sh` for `.git/config` integrity). Auto-copied by `init.sh` with optional pre-commit hook installer (v1.6.0+) |
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

| 手順 / Step | Codex ⚙️ | Claude Code ✅ | Antigravity ✅ | Cursor ⚠️ | Copilot ⚠️ | Windsurf ⚠️ |
|:-----------|:----------|:--------------|:------------|:----------|:-----------|:------------|
| 1. `AGENTS.md` + `axiarch-rules/` をコピー（`axiarch-prompts/` は任意） | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 2. `.codex/hooks.json` を配置 | ✅ hook利用時に `init.sh` 自動 / Auto via `init.sh` when using hooks | ❌ 不要 | ❌ 不要 | ❌ 不要 | ❌ 不要 | ❌ 不要 |
| 3. `CLAUDE.md` + `.claude/settings.json` (3 hooks: SessionStart/UserPromptSubmit/PreToolUse) 配置 | ❌ 不要 | ✅ hook利用時に `init.sh` 自動 / Auto via `init.sh` when using hooks | ❌ 不要 | ❌ 不要 | ❌ 不要 | ❌ 不要 |
| 4. `.agents/rules/prompt_pointer.md` を配置 | ❌ 不要 | ❌ 不要 | ✅ **必須** | ❌ 不要 | ❌ 不要 | ❌ 不要 |
| 5. 追加設定 | — (AGENTS.md + hooks native) | — (3 hooks 自動配線済み) | — | 任意・未検証: `.cursor/rules/*.mdc` | 任意・未検証: `.github/copilot-instructions.md` | 任意・未検証: `.windsurfrules` |

### 🛡️ Claude Code Hook補強機構 / Hook Reinforcement Mechanism (v1.8.0+ — 3 hooks + TTL + Task Boundary)

> **JA**: Claude Code 採用プロジェクトには `.claude/settings.json` が同梱され、**3 種類のフック**が AGENTS.md プロトコルの**「Reminder + Physical Block + Bootstrap」三層補強**を担います。AI が「軽い会話だから」と LOADING_PROTOCOL をスキップする問題、§6 ANTI-FULL-OVERWRITE 違反、`task.md` 記録忘却のリスクを、対応環境ではツール実行前に検出しやすくします。**v1.6.0+ では TTL 二段階出力（default 30 分）で token 約 87% 削減**（24k → 3k）。**v1.8.0+ では Check D Task Boundary Detection** を追加し、現プロンプトの domain keyword と AGENTS §8.4 必須トリオ（task.md / implementation_plan.md / walkthrough.md）を機械比較。AI が「同 session だから rule 再 load 不要」と判断するサボり（confirmation-bias loophole）を hook 層で検出しやすくします。
>
> **EN**: Claude Code projects ship with `.claude/settings.json` containing **three hooks** that reinforce the AGENTS.md protocol through **Reminder + Physical Block + Bootstrap**. In supported environments, this makes it easier to detect skipped LOADING_PROTOCOL steps on "casual" prompts, §6 ANTI-FULL-OVERWRITE violations, and missing task.md recording before tool execution. **v1.6.0+ two-stage TTL** (default 30 min) reduces token cost ~87% (24k → 3k). **v1.8.0+ Check D Task Boundary Detection** mechanically compares current-prompt domain keywords against the AGENTS §8.4 mandatory trio (task.md / implementation_plan.md / walkthrough.md), making the AI's "same session, no re-load needed" confirmation-bias loophole easier to detect at the hook layer.

| フック / Hook | 発火タイミング / Fires when | 役割 / Role | スクリプト / Script |
|:--|:--|:--|:--|
| `SessionStart` | 会話開始時 / Conversation start | task.md 自動 bootstrap + AGENTS.md §8 reminder 注入 / Auto-bootstrap task.md + inject §8 reminder | `axiarch-scripts/axiarch-init-task-md.sh` |
| `UserPromptSubmit` | 毎プロンプト送信時 / Every user prompt | system reminder（事実陳述 + 動的違反検出 A/B/C + **v1.6.0+ TTL 短縮版** + **v1.8.0+ Check D Task Boundary Detection**）注入 / Inject factual reminder + dynamic violations A/B/C + v1.6.0+ TTL short-circuit + **v1.8.0+ Check D task-boundary detection** | `axiarch-scripts/axiarch-boot-reminder.sh` |
| `PreToolUse` (matcher: `Write`) | `Write` tool 直前 / Before Write tool | 対応環境で既存ファイル全面書き換えを遮断（§6） / Blocks overwrite on existing files in supported environments (§6) | `axiarch-scripts/axiarch-protect-antifull.sh` |

| ファイル / File | 役割 / Role | コミット / Commit |
|:----------------|:------------|:------------------|
| `.claude/settings.json` | チーム共有の Axiarch hook設定 / Team-shared Axiarch hook settings | ✅ **Claude Code hook共有時は必要** / **Required when sharing Claude Code hooks** |
| `.claude/axiarch-overwrite-allow.txt` | §6 物理遮断の whitelist (任意) / Whitelist for §6 physical block (optional) | 🔷 任意 / Optional |
| `.claude/settings.local.json` | 個人の権限・許可設定 / Personal permissions | ❌ gitignored |
| `.claude/worktrees/`, `.claude/projects/` | Claude Code セッションデータ / Claude Code session data | ❌ gitignored |

> [!CAUTION]
> **JA**: この **3 フックの削除・無効化は「憲法改正」レベルの破壊的変更**であり、オーナーの明示的承認が必要です。特に v1.5.5 で追加された `PreToolUse` は **「Reminder だけでなく Physical Block も使う」設計**です（参考: arXiv:2503.18666 AgentSpec、arXiv:2502.15851 Control Illusion）。詳細は `axiarch-rules/{lang}/LOADING_PROTOCOL.md` の「Hook補強機構」セクションを参照。
>
> **EN**: **Removing or disabling any of these three hooks is a constitution-amending destructive change** requiring explicit owner approval. The `PreToolUse` hook in particular (added in v1.5.5) adds a physical-block layer in addition to reminders (references: arXiv:2503.18666 AgentSpec, arXiv:2502.15851 Control Illusion). See "Hook Reinforcement Mechanism" in `axiarch-rules/{lang}/LOADING_PROTOCOL.md`.

#### 🔍 トラブルシュート / Troubleshooting

> **JA**: 「フックが動いていない気がする」場合、`bash axiarch-scripts/check-axiarch-health.sh` を実行してください。**14 段階の axiarch 標準診断**（v1.8.0+）で、3 フックすべての配線確認（Check 3 = UserPromptSubmit / Check 11 = PreToolUse / Check 12 = SessionStart）+ Check 6（CRYSTAL §5 count + time-axis trigger）+ Check 13（既存 sublimated file APPEND ガイド）+ **Check 14（Task Boundary Detection wiring 確認、v1.8.0+）** + AI 遵守（task.md ロード履歴 / 結晶化閾値）を一発診断します。pre-commit / CI 用 `--quiet` flag 対応。`init.sh` 経由で自動配布。
>
> **EN**: When you suspect "the hook isn't firing", run `bash axiarch-scripts/check-axiarch-health.sh`. **14-stage axiarch diagnostic** (v1.8.0+) verifies all three hooks (Check 3 = UserPromptSubmit / Check 11 = PreToolUse / Check 12 = SessionStart) + Check 6 (CRYSTAL §5 count + time-axis trigger) + Check 13 (sublimated files APPEND guide) + **Check 14 (Task Boundary Detection wiring, v1.8.0+)** + AI adherence (task.md load logs / crystallization threshold). `--quiet` flag for pre-commit / CI usage. Distributed automatically via `init.sh`.

```bash
bash axiarch-scripts/check-axiarch-health.sh
# Or from another directory:
bash /path/to/project/axiarch-scripts/check-axiarch-health.sh /path/to/project
```

> [!NOTE]
> **JA**: 公式仕様: [Hooks](https://code.claude.com/docs/en/hooks) / [Permissions](https://code.claude.com/docs/en/permissions)。`permissions.allow` に `Bash(echo *)` を追加する必要は**ありません**（hook command は permission 経路外）。
>
> **EN**: Official spec: [Hooks](https://code.claude.com/docs/en/hooks) / [Permissions](https://code.claude.com/docs/en/permissions). Adding `Bash(echo *)` to `permissions.allow` is **NOT required** (hook commands are spawned outside the permission pipeline).

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

# 推奨：診断・ヘルスチェックスクリプト集 / Recommended: diagnostic & health-check scripts
cp -r axiarch-scripts /path/to/your/project/

# 任意：プロンプト集もコピー / Optional: copy prompt library
cp -r axiarch-prompts /path/to/your/project/
```

### 2. エージェント固有の設定 / Agent-specific config

```bash
# === OpenAI Codex ===
# CodexはAGENTS.mdをネイティブ設定として読み、.codex/hooks.jsonでhook補強を配線できます。
# Codex reads AGENTS.md natively and can wire hook reinforcement through .codex/hooks.json.
# hook補強を使う場合のみ / Only when using hook reinforcement:
mkdir -p /path/to/your/project/.codex
cp .codex/hooks.json /path/to/your/project/.codex/hooks.json

# === Claude Code ===
# Claude CodeはCLAUDE.mdをネイティブに読むのでポインターをコピー。
# Claude Code reads CLAUDE.md natively — copy the pointer file.
cp CLAUDE.md /path/to/your/project/CLAUDE.md
# hook補強を使う場合のみ / Only when using hook reinforcement:
mkdir -p /path/to/your/project/.claude
cp .claude/settings.json /path/to/your/project/.claude/settings.json

# === Google Antigravity ===
# .agents/rules/ はAntigravity固有。自動読み込み対象なのでポインターを配置。
# .agents/rules/ is Antigravity-specific. Place a pointer for auto-loading.
mkdir -p /path/to/your/project/.agents/rules
cp .agents/rules/prompt_pointer.md /path/to/your/project/.agents/rules/

# === Cursor ===
# 未検証の拡張ポインター候補です。必要な場合のみ配置します。
# Unverified extended pointer candidate. Place only when needed.
# 手動セットアップの場合 / For manual setup:
mkdir -p /path/to/your/project/.cursor/rules
cp .cursor/rules/axiarch.mdc /path/to/your/project/.cursor/rules/

# === GitHub Copilot ===
# 未検証の拡張ポインター候補です。必要な場合のみ配置します。
# Unverified extended pointer candidate. Place only when needed.
# 手動セットアップの場合 / For manual setup:
mkdir -p /path/to/your/project/.github
cp .github/copilot-instructions.md /path/to/your/project/.github/

# === Windsurf ===
# 未検証の拡張ポインター候補です。必要な場合のみ配置します。
# Unverified extended pointer candidate. Place only when needed.
# 手動セットアップの場合 / For manual setup:
cp .windsurfrules /path/to/your/project/
```

> [!CAUTION]
> **JA**: `.agents/rules/` は **Antigravity固有**のディレクトリです。Claude Code、Codex、Cursor、GitHub Copilotでは不要です（Claude Code は別途 `CLAUDE.md` + `.claude/settings.json` で 3 hooks 自動配線、Codex は `AGENTS.md` と `.codex/hooks.json` を使用）。各ツールには固有の設定ディレクトリがあります（上表参照）。Antigravityの場合もポインターのみ配置し、ルール本体は `axiarch-rules/` に一元管理。
>
> **EN**: `.agents/rules/` is **Antigravity-specific**. It is NOT needed for Claude Code, Codex, Cursor, or GitHub Copilot (Claude Code uses `CLAUDE.md` + `.claude/settings.json` with 3 auto-wired hooks; Codex uses `AGENTS.md` plus `.codex/hooks.json`). Each tool has its own native configuration directory (see table above). For Antigravity, only place the pointer here — rule definitions live in `axiarch-rules/`.

### 3. 初期化 / Initialize

```bash
# AGENTS.md を編集 → Project Native Language を Japanese または English に設定
# Edit AGENTS.md → Set Project Native Language to Japanese or English

# 任意: 単一言語運用に固定する場合のみ、使用しない言語ディレクトリを削除
# Optional: delete the unused language directory only when fixing the project to one language
rm -rf axiarch-rules/en  # For Japanese projects
# OR
rm -rf axiarch-rules/ja  # For English projects

# 任意: axiarch-prompts/ をコピーし、単一言語運用に固定する場合
# Optional: if you copied axiarch-prompts/ and want one-language operation
rm -rf axiarch-prompts/en  # For Japanese projects
# OR
rm -rf axiarch-prompts/ja  # For English projects
```

### 4. 設定と開発 / Configure & Develop

| Step | JA | EN |
|:-----|:---|:---|
| 1 | `{lang}/blueprint/core/000_project_overview.md` をプロジェクトに合わせて編集 | Edit `{lang}/blueprint/core/000_project_overview.md` for your project |
| 2 | 新機能は `core/998_feature_spec_template.md` を対応するドメインフォルダにコピー | For new features, copy `core/998_feature_spec_template.md` to the corresponding domain folder |
| 3 | **コードを書く前に受け入れ条件を書く**（Blueprint First） | **Write Acceptance Criteria before writing code** (Blueprint First) |
| 4 | 開発開始 — AIエージェントは憲法に従う | Start development — AI agents will follow the constitution |

### 導入後のディレクトリ構成 / Post-Setup Directory Structure

```text
your-project/
 ├── AGENTS.md                    ← 必須：最上位プロトコル / Required: Top-Level Protocol
 ├── .codex/                      ← Codex のみ / Codex only
 │    └── hooks.json              ← Codex hook補強設定 / Codex hook-reinforcement config
 ├── CLAUDE.md                    ← Claude Code のみ（ポインター） / Claude Code only (pointer)
 ├── .claude/                     ← Claude Code のみ / Claude Code only
 │    └── settings.json           ← 3 hooks 設定（SessionStart / UserPromptSubmit + v1.6.0 TTL / PreToolUse、共有利用時にコミット） / Three-hook config + v1.6.0 reminder TTL (commit when sharing)
 ├── .agents/                     ← Antigravity のみ / Antigravity only
 │    └── rules/
 │         └── prompt_pointer.md  ← ポインター / Pointer
 ├── axiarch-rules/               ← 必須：ルール本体 / Required: Rule Definitions
 │    └── ja/ (or en/)             ← 言語選択 / Language selected
 │         ├── INDEX.md
 │         ├── LOADING_PROTOCOL.md
 │         ├── CRYSTALLIZATION_PROTOCOL.md
 │         ├── universal/          ← 不変 / Immutable
 │         └── blueprint/          ← プロジェクト固有 / Project-Specific
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

AIエージェントが登場する以前から、生成AI（ChatGPT等）を新規事業の構想や実務の中で活用していました。コードを書かせてみることもありましたが、本格的な開発に使ったわけではありません。それでも、AIと向き合う中でひとつだけ確信していたことがありました — **ハルシネーション、コンテキストの喪失、品質のブレ。明確なルールなしにAIを使い続ければ、品質は静かに劣化し、立て直しが難しくなる。**

2025年、[Google Antigravity](https://antigravity.google/)のようなAIエージェントが登場したとき、直感しました：**「ガバナンス構造なしにこれを使い始めると、後から立て直す負荷が大きくなる」**と。逆に言えば、**最初から「憲法」を整備すれば、品質の底上げに寄与できる**はずだと。

そこで、開発を始める**前に**強固なガバナンスの構築に着手しました。そしてそのアーキテクチャを携えて実際のプロダクション開発に投入し、数百セッションの実績を経てブラッシュアップしていきました。

**その過程で、ルールなしでは起きやすいパターンが明確になりました：**

- **コンテキスト健忘症。** セッション間でアーキテクチャの決定を忘れる。命名規約がドリフトする。セキュリティパターンが退行する。修正済みのバグが再導入される。
- **操縦者依存の品質。** 正確な指示を出せば優れた成果物が出る。曖昧な指示では、バリデーションを省略し、型安全を無視し、安易なショートカットに逃げる。
- **Vibe Coding の引力。** 明示的な制約がなければ、すべてのセッションが "vibe coding" に引き寄せられる — 正しく見えるが、確立されたパターンを暗黙に違反するコード。
- **知見の蒸発。** 苦労して得た教訓が失われ、同じ問題を何度も再発見させられる。

業界全体も同じ問題に直面していました。AIが生成したコードがセキュリティ脆弱性の主要な原因となりつつあるとの報告、"AI slop"現象 — 低品質・重複コードの氾濫、コンテキストウィンドウの劣化による一貫性の喪失。たとえ個別ステップの成功率が高くとも、マルチステップのワークフローでは失敗率が大きく膨れ上がります。

**気づき：** 問題はAIモデルではなく、*ガバナンスの不在*でした。セッション、操縦者、コンテキストリセットを超えて生き残る、継続的に参照されるガバナンス構造 — 「憲法」 — が存在しなかったのです。

この問題に対する一つの実践的アプローチとして構築したのが Axiarch です。作者自身、フロントエンドエンジニアとしての経験はあるものの、バックエンドやインフラは未経験からのスタートでした。だからこそ、**特定の言語やフレームワークに依存せず、エンジニア経験の深さに関わらず、AIと協働するすべての開発者 — 非エンジニアや個人開発者を含む — が最低品質の底上げを狙える**フレームワークを目指しました。

世界中の開発者がAIエージェントの恩恵を最大限に受けられるように。特にAI活用においてまだ発展途上にある日本からの発信として、自国のAI活用促進にも貢献できればと考えています。そして何より、この取り組み自体が自身の知見を深めるプロセスでもあります。

成果：数千規模の憲法基準を扱う39のUniversalルールファイル、ハルシネーションリスクを軽減する5ステップのBoot Sequence Protocol、教訓をルール化しやすくするCrystallization Protocol。すべて、たった一つの `AGENTS.md` 憲法を通じて参照されます。

### 🇺🇸 Why Axiarch Was Built

Axiarch was born from a conviction that AI without governance will inevitably fail.

Before AI agents existed, working with generative AI (ChatGPT, etc.) for business planning and day-to-day work revealed a persistent risk — **hallucinations, context loss, and inconsistent quality become more likely without explicit rules.** AI is powerful, but using it without governance can let quality erode in ways that become increasingly hard to course-correct.

When AI agents like [Google Antigravity](https://antigravity.google/) emerged in 2025, the intuition was immediate: **"Starting without a governance structure would make later correction expensive."** Conversely, **establishing a "constitution" from day one could help raise the quality floor.**

So the governance architecture was built **before** development began. Then it was deployed into real production development and refined through hundreds of real production sessions.

**Through that process, patterns that were likely to recur without governance became clear:**

- **Context amnesia.** The AI forgot architectural decisions between sessions. Naming conventions drifted. Security patterns regressed. Fixed bugs were re-introduced.
- **Operator-dependent quality.** When instructions were precise, output was excellent. When vague, the AI took shortcuts — skipping validation, ignoring type safety, reaching for easy escapes.
- **Vibe coding gravity.** Without explicit constraints, every session tended toward "vibe coding" — code that looked correct but silently violated established patterns.
- **Knowledge evaporation.** Hard-won lessons were lost and had to be re-discovered repeatedly.

The industry was facing the same problem at scale. AI-generated code becoming a common vector for security vulnerabilities. The "AI slop" phenomenon — proliferation of low-quality, duplicated code — accelerating technical debt. Context window degradation causing models to lose coherence. High individual step reliability compounding into significant failure rates across multi-step workflows.

**The realization:** The problem wasn't the AI model. It was the absence of *governance*. There was no "constitution" — no persistent, enforceable set of rules that survived across sessions, operators, and context resets.

Axiarch was built as one practical approach to this challenge. The author's own background — front-end engineering experience, but no prior back-end or infrastructure expertise — shaped the core design principle: **language-agnostic, framework-agnostic, and accessible regardless of engineering experience. A Constitution-Driven AI Agent Governance Framework that helps any developer working with AI — including non-engineers and solo developers — raise their minimum quality floor.**

The goal extends beyond personal use: to contribute to the global adoption of AI-assisted development, and to help accelerate AI utilization worldwide. The result: 39 Universal Rule files covering thousands of constitution standards, a 5-step Boot Sequence Protocol that reduces startup hallucination risk, and a Crystallization Protocol that helps convert lessons into rules. All are routed through a single `AGENTS.md` constitution that any compatible AI agent can read.

---

## 💡 設計思想 / Philosophy

**Axiarch** は、「普遍憲法（Universal・不変）」と「固有ルール（Blueprint・可変）」の明確な責務分離による**2大コア層**と、必要なときだけ実行を駆動する**任意の第3層（Prompts）**からなる**「3層統合ガバナンス・アーキテクチャ（Three-Layer Governance Architecture）」**の上に構築されています。この3層構造が、ハルシネーションと品質ドリフトのリスクを下げ、最低品質を底上げするためのAxiarchの中核です。

**Axiarch** is built on a **"Three-Layer Governance Architecture"**, separating responsibilities into two core layers—the **Immutable Constitution (Universal)** and the **Mutable Project State (Blueprint)**—plus a third **Optional Execution Layer (Prompts)**. This three-layer structure is the core of Axiarch's approach to reducing hallucination and quality-drift risk while raising the minimum quality floor.

### 🏛️ The Three-Layer Architecture (3層ガバナンス構造)

#### Layer 1: Universal (不変層 / Immutable Constitution)
- **役割**: 時代やプロジェクトが変わっても共通して参照すべき「開発・品質・運用・プロダクト判断の基準と制約」を定義する土台層（`AGENTS.md` + `universal/`）。
- **特性**: **Read-Only（原則保護）**。AIエージェントによる独断の変更を固く禁じた「不変の領域」です。AI特有の独自解釈（Vibe Coding）やセキュリティ脆弱化のリスクを構造的に軽減します。

#### Layer 2: Blueprint (可変層 / Mutable Project State)
- **役割**: プロジェクトの事業目的、固有の機能仕様、そして開発中に得られた「実践の教訓」を蓄積・結晶化する層（`blueprint/`）。
- **特性**: **Read-Write（動的成長）**。AIエージェント自身が継続的に仕様や教訓を書き込み、自律ロードを通じて文脈を復元するための「生きた記憶領域」です。「昨日までの前提を忘れる（Context Amnesia）」リスクを軽減し、継続的な品質の底上げ（Quality Floorの向上）を狙います。

#### Layer 3: Prompts (任意実行層 / Optional Execution Engine)
- **役割**: Layer 1と2のルールを、特定タスク（セキュリティ監査、設計最適化、インシデント対応など）へ明示的に呼び出しやすくするエンジン（`axiarch-prompts/`）。
- **特性**: **Optional（任意）**。Axiarchの核はLayer 1と2の遵守であり、Layer 3を導入しなくてもフレームワーク自体は機能します。必要に応じて特定の高品質タスクを実行するためのオプショナルなプラグインとして機能します。

---

### 原則 / Principles

| 原則 / Principle | JA | EN |
|:-----------------|:---|:---|
| **Blueprint First** | 大規模変更は実装前に仕様更新を義務化 | Specs before code — major changes require spec updates before implementation |
| **Multi-step refinement** | INDEX → ルールロード → Blueprint → タスク → 計画 → 実装 → Walkthrough → 教訓 | INDEX → Rule Load → Blueprint → Task → Plan → Implement → Walkthrough → Lessons |
| **Strong guardrails** | 16の禁止事項 + 5つのプロトコル + 対応エージェントのhooks | 16 prohibitions + 5 protocols + supported-agent hooks |
| **Continuous learning** | タスク完了後に教訓をルールに結晶化 | Lessons crystallized into rules after every task |
| **Quality floor** | 操縦者のスキルに依存しすぎず最低品質基準を保ちやすくする | Minimum standards made easier to maintain with less dependence on operator skill |

> **JA**: Axiarch（アクシアーク）の核心的価値は、単なるプロンプトの集合体ではなく、この「**普遍（Layer 1）と可変（Layer 2）の明確な責務分離**」と「**プロンプト（Layer 3）による任意の実行駆動**」という3層構造による状態管理アーキテクチャにあります。「Blueprint First（実装前の仕様定義）」と「憲法」を連動させることで、AIのハルシネーションや品質ドリフトのリスクを軽減し、開発から運用までの全体品質の底上げを狙います。
> 
> **EN**: Axiarch's core value lies not in being a mere prompt collection, but in its state-management architecture built upon "the **Clear Separation of Immutable (Layer 1) and Mutable (Layer 2)**" and "the **Optional Execution-driven Prompts (Layer 3)**". By integrating "Blueprint First" with the Constitution, it helps reduce hallucination and quality-drift risk while raising the overall quality floor from development to operations.


---

## 🤝 コントリビュート / Contributing

**JA**: コントリビュートを歓迎します。プルリクエストの前に、まずIssueで変更提案を議論してください。

**EN**: Contributions are welcome. Please open an issue to discuss proposed changes before submitting a pull request.

> [!IMPORTANT]
> **JA**: Universal Rules (`{lang}/universal/`) は**憲法**です。変更には明示的な「憲法改正」の承認が必要です。Blueprintテンプレートや基盤ファイルは通常のコントリビュートを受け付けます。
>
> **EN**: Universal Rules (`{lang}/universal/`) are the **Constitution**. Modifications require explicit "Amend Constitution" approval. Blueprint templates and infrastructure files accept standard contributions.

---

## 📄 ライセンス / License

**JA**: このプロジェクトは **Apache License 2.0** の下でライセンスされています。詳細は [LICENSE](LICENSE) ファイルを参照してください。

**EN**: This project is licensed under the **Apache License 2.0** — see the [LICENSE](LICENSE) file for details.

---

## 著者 / Author

**Hiroyuki Miyauchi** — [LinkedIn](https://www.linkedin.com/in/hiroyuki-miyauchi/) / [chronoviq.com](https://chronoviq.com/)

**JA**: バグ報告や機能リクエストは [GitHub Issues](https://github.com/hiroyuki-miyauchi/axiarch/issues) をご利用ください。

**EN**: For bug reports and feature requests, use [GitHub Issues](https://github.com/hiroyuki-miyauchi/axiarch/issues).
