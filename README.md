<div align="center">

# 🏰 Rampart

### 憲法駆動型 AIエージェントガバナンスフレームワーク

### Constitution-Driven AI Agent Governance Framework

[![Release](https://img.shields.io/github/v/release/hiroyuki-miyauchi/rampart?label=Version&color=brightgreen)](https://github.com/hiroyuki-miyauchi/rampart/releases)
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Rules](https://img.shields.io/badge/Universal_Rules-30_files-green.svg)](#-universal-rules-30-files--jaen)
[![Languages](https://img.shields.io/badge/Languages-🇯🇵_🇺🇸_Bilingual-orange.svg)](#)
[![Agents](https://img.shields.io/badge/Verified-Google_Antigravity-green.svg)](#-aiエージェント互換性--ai-agent-compatibility) [![Expected](https://img.shields.io/badge/Expected-Cursor_|_Claude_|_Copilot-yellow.svg)](#-aiエージェント互換性--ai-agent-compatibility)

[日本語](#-rampartランパートとは) ・ [English](#-what-is-rampart)

</div>

---

## 🇯🇵 Rampart（ランパート）とは

**Rampart（ランパート）**は、AI支援開発における品質ブレと暴走を**憲法型のルールアーキテクチャ**で統治する、**AIエージェントガバナンスフレームワーク**です。

[Google Antigravity](https://labs.google/antigravity)向けに設計されました。ルール本体は純粋なMarkdownであり、`AGENTS.md` は業界標準フォーマットのため、**他のAIエージェント（Cursor、Claude Code、GitHub Copilot等）とも互換性がある見込み**です — ただし動作は未検証です。

### 設計思想

- **プロンプト集ではありません。** **操縦者が変わっても最低品質の床を保証する**、多層防御のガバナンス設計です。
- **操縦者非依存の品質保証。** シニアエンジニアが使っても初心者が使っても、憲法が同一のエンジニアリング基準を強制します。
- **2層構造。** `AGENTS.md`（憲法）がAIの行動ルールを定義し、`rampart-rules/` ディレクトリが包括的なルールライブラリを格納します。憲法はAIの*振る舞い方*を統治し、ルールは*何の基準に従うか*を定義する補完関係です。

### なぜ必要か

| ガバナンスなし | Rampartあり |
|:-------------|:--------------------------|
| AIが「それっぽいが壊れている」コードを生成 | Zero Bug, Zero Warning ポリシーを憲法で強制 |
| 品質が操縦者のスキルに完全依存 | Universal Rulesが最低品質の床を設定 |
| 仕様なしの vibe coding | Blueprint First：コードより先に仕様を定義 |
| セッション間で知見が消失 | 教訓ログが知見をルールに結晶化 |
| AIがプロジェクト構造を幻覚で生成 | Boot Sequence Protocol：まずルールを読め |

### アーキテクチャ

```text
┌─────────────────────────────────────────────────────┐
│  AGENTS.md — 最高法規                                │  ← 不変
│  （AI行動憲法）                                       │
├─────────────────────────────────────────────────────┤
│  Universal Rules — 30ファイル × 2言語（JA/EN）         │  ← 不変
│  エンジニアリング、セキュリティ、AI、SRE、FinOps、i18n...   │
├─────────────────────────────────────────────────────┤
│  Blueprint — プロジェクト固有法                        │  ← 可変
│  プロジェクト概要、機能仕様、教訓ログ                     │
├─────────────────────────────────────────────────────┤
│  実行ドキュメント — タスク単位                          │  ← 自動生成
│  task.md, implementation_plan.md, walkthrough.md    │
├─────────────────────────────────────────────────────┤
│  フィードバックループ — 結晶化                          │  ← 継続的
│  教訓 → ルール → より良い教訓                           │
└─────────────────────────────────────────────────────┘
```

---

## 🇺🇸 What is Rampart?

**Rampart** is a **Constitution-Driven AI Agent Governance Framework** that prevents quality degradation and uncontrolled behavior in AI-assisted development.

Originally designed for [Google Antigravity](https://labs.google/antigravity). Since all rules are pure Markdown and `AGENTS.md` is the industry-standard format, **it is expected to be compatible with other AI agents** (Cursor, Claude Code, GitHub Copilot, etc.) — though this has not been verified.

### Core Design Philosophy

- **Not a prompt collection.** It is a **multi-layered governance architecture** that ensures minimum quality standards **regardless of who operates the AI agent.**
- **Operator-independent quality floor.** Whether a senior engineer or a beginner uses the AI, the constitution enforces the same engineering standards.
- **Two-layer system.** `AGENTS.md` (the constitution) defines behavioral rules, while the `rampart-rules/` directory contains the comprehensive rule library. Together they form a complementary system — the constitution governs *how* the AI behaves, and the rules define *what* standards it must follow.

### The Problem

| Without Governance | With Rampart |
|:-------------------|:--------------------------|
| AI generates code that "looks right" but breaks silently | Constitution enforces Zero Bug, Zero Warning policy |
| Quality depends entirely on the operator's skill | Universal Rules set a minimum quality floor |
| No structure for specs → vibe coding | Blueprint First: specs before code, always |
| Lessons learned are lost between sessions | Lessons Log crystallizes knowledge into rules |
| AI hallucinates project structure and rules | Boot Sequence Protocol: read rules first, then act |

### Architecture

```text
┌─────────────────────────────────────────────────────┐
│  AGENTS.md — Supreme Law                            │  ← Immutable
│  (AI Behavior Constitution)                         │
├─────────────────────────────────────────────────────┤
│  Universal Rules — 30 files × 2 languages (JA/EN)  │  ← Immutable
│  Engineering, Security, AI, SRE, FinOps, i18n...    │
├─────────────────────────────────────────────────────┤
│  Blueprint — Project-Specific Laws                  │  ← Mutable
│  Project Overview, Feature Specs, Lessons Log       │
├─────────────────────────────────────────────────────┤
│  Execution Documents — Per-Task                     │  ← Generated
│  task.md, implementation_plan.md, walkthrough.md    │
├─────────────────────────────────────────────────────┤
│  Feedback Loop — Crystallization                    │  ← Continuous
│  Lessons → Rules → Better Lessons                   │
└─────────────────────────────────────────────────────┘
```

---

## 🔌 AIエージェント互換性 / AI Agent Compatibility

| 状態 / Status | Agent | Native Config | AGENTS.md |
|:--------------|:------|:-------------|:----------|
| ✅ **Verified** — 実務で実証済み | **Google Antigravity** | `.agent/rules/` | ✅ Reads |
| ⚠️ **Untested** — 未検証（動作する見込み） | **Cursor** | `.cursor/rules/*.mdc` | ✅ Reads |
| ⚠️ **Untested** — 未検証（動作する見込み） | **GitHub Copilot** | `.github/copilot-instructions.md` | ✅ Reads |
| ⚠️ **Untested** — 未検証（動作する見込み） | **Claude Code** | `CLAUDE.md` | ⚠️ Via symlink |
| ⚠️ **Untested** — 未検証（動作する見込み） | **Aider / Zed / Windsurf** | Various | ✅ Reads |

> [!NOTE]
> **JA**: 各AIエージェントには**固有の設定ディレクトリ**があります（例: Cursorは `.cursor/rules/`、Copilotは `.github/copilot-instructions.md`）。`AGENTS.md` は**業界標準の補完ファイル**であり、多くのツールが固有設定に加えて読み込みます。ツール固有のセットアップの代替ではありません。
>
> **EN**: Each AI agent has its **own native configuration directory** (e.g., `.cursor/rules/` for Cursor, `.github/copilot-instructions.md` for Copilot). `AGENTS.md` is the **industry-standard complement** that most tools read in addition to their native config. It is NOT a replacement for tool-specific setup.

> [!IMPORTANT]
> **JA**: 本ガバナンス・アーキテクチャは **[Google Antigravity](https://labs.google/antigravity)** 上で設計・実戦検証されたものです。ルール本体は純粋なMarkdownであり、AIモデルの概念的な仕組みはツール間で共通であるため他のエージェントでも動作する見込みですが、**他ツールでの動作は検証していません。ご利用は自己責任でお願いします。Antigravity以外の環境での動作保証はいたしません。**
>
> **EN**: This governance architecture was designed and battle-tested on **Google Antigravity**. Since all rules are pure Markdown and the underlying AI model concepts are fundamentally the same across tools, they are expected to work on other agents — but **this has not been verified. Use at your own risk. No guarantees are provided for non-Antigravity environments.**

> [!TIP]
> **JA**: フォルダ名 `rampart-rules/` は出自を反映していますが、ルールファイル自体は純粋なMarkdownであり、ツール固有の依存はありません。
>
> **EN**: The folder name `rampart-rules/` reflects its origin, but the rule files themselves are pure Markdown with zero tool-specific dependencies.

---

## 📦 同梱内容 / What's Included

### 🏛️ 最高法規 / Supreme Law

| File | JA | EN |
|:-----|:---|:---|
| `AGENTS.md` | AI行動憲法（Google Antigravityで設計、他エージェントでも動作見込み） | AI Behavior Constitution (designed on Google Antigravity, compatible with other agents) |

### 📚 Universal Rules (30 files × JA/EN)

| Category | Files | JA | EN |
|:---------|:------|:---|:---|
| **000** Core & Mindset | 1 | 開発哲学、Supreme Directive | Development philosophy, Supreme Directive |
| **100** Product & Business | 4 | プロダクト戦略、収益、グロース、ASO | Product strategy, revenue, growth, ASO |
| **200** Design & UX | 1 | デザインシステム、A11y | Design system, accessibility |
| **300** Engineering | 9 | コード品質(80§)、API、Supabase、Web、CMS、Flutter、Native、Firebase、AWS | Code quality (80§), API, Supabase, Web, CMS, Flutter, Native, Firebase, AWS |
| **400** AI & Data | 2 | AIエンジニアリング、データ分析 | AI Engineering, Data Analytics |
| **500** Operations | 4 | 内部ツール、CX、SRE、インシデント対応 | Internal tools, CX, SRE, incident response |
| **600** Security & Legal | 4 | セキュリティ、データガバナンス、OSSコンプライアンス、知的財産 | Security, data governance, OSS compliance, IP |
| **700** QA & FinOps | 2 | テスト戦略、クラウドFinOps | Test strategy, Cloud FinOps |
| **800** Global & Governance | 3 | i18n、ガバナンス、言語プロトコル | i18n, governance, language protocol |

### 📐 Blueprint (プロジェクト固有テンプレート / Project-Specific Templates)

| File | JA | EN |
|:-----|:---|:---|
| `000_project_overview.md` | プロジェクト概要テンプレート | Project overview template |
| `010_project_lessons_log.md` | 教訓ログ | Lessons log |
| `998_feature_spec_template.md` | **機能仕様テンプレート（SDD核）** — 受け入れ条件(Given/When/Then)を機能単位で必須化 | **Feature spec template (SDD core)** — Acceptance Criteria (Given/When/Then) required per feature |
| `999_project_specific_template.md` | プロジェクト固有ルールテンプレート | Project-specific rule template |

### 🔧 基盤 / Infrastructure

| File | JA | EN |
|:-----|:---|:---|
| `LOADING_PROTOCOL.md` | 5ステップのルールロード手順 | 5-step rule loading protocol |
| `CRYSTALLIZATION_PROTOCOL.md` | 教訓の自動結晶化プロトコル | Lesson auto-crystallization protocol |
| `INDEX.md` | 全ルールの詳細索引 | Detailed index of all rules |
| `compliance_matrix.md` | 要件対照表 | Compliance matrix |

### 🎯 プロンプト集 / Prompt Library

| File | JA | EN |
|:-----|:---|:---|
| `rampart-prompts/ja/blueprint_governance_audit.md` | 開発知見をBlueprintルールに結晶化する網羅的監査プロンプト | — |
| `rampart-prompts/en/blueprint_governance_audit.md` | — | Comprehensive audit prompt to crystallize development insights into Blueprint rules |
| `rampart-prompts/ja/feature_development.md` | 新機能実装・既存改修・バグ修正・憲法監査を網羅的に実行するプロンプト | — |
| `rampart-prompts/en/feature_development.md` | — | Comprehensive prompt for new feature implementation, improvement, bug fixing, and compliance auditing |
| `rampart-prompts/ja/quality_assurance_audit.md` | コードベース全体の品質監査・バグ完全解消・全方位ブラッシュアッププロンプト | — |
| `rampart-prompts/en/quality_assurance_audit.md` | — | Full codebase quality audit, zero-defect remediation, and omni-directional enhancement prompt |
| `rampart-prompts/ja/push_execute.md` | 品質ゲート・DB整合性確認・ブランチ戦略遵守を経たGit Push実行プロンプト | — |
| `rampart-prompts/en/push_execute.md` | — | Quality gate, DB integrity check, branch strategy compliance, and Atomic Push execution |
| `rampart-prompts/ja/ci_fix.md` | CI/CD失敗時のエラー再現・根本原因分析・修正・ルール還元を一貫実行するプロンプト | — |
| `rampart-prompts/en/ci_fix.md` | — | CI/CD failure error reproduction, root cause analysis, fix, and rule feedback |

> [!TIP]
> **JA**: `rampart-prompts/` はルールとは独立した**再利用可能なプロンプトテンプレート集**です。AIエージェントに特定の高品質タスクを実行させる際に使用します。
>
> **EN**: `rampart-prompts/` is a **reusable prompt template library** independent of rules. Use them to instruct AI agents to execute specific high-quality tasks.

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
| `rampart-rules/` | ✅ **必須** / **Required** | ルール本体（Universal + Blueprint） / Rule definitions |
| `rampart-prompts/` | 🔷 **任意** / **Optional** | プロンプトテンプレート集 / Prompt template library |
| `.agent/rules/prompt_pointer.md` | 🔶 **Antigravity のみ** / **Antigravity only** | Antigravity固有のポインター / Antigravity-specific pointer |
| `CHANGELOG.md` | ❌ 不要 / Not needed | リポジトリ管理用 / For this repo only |
| `CONTRIBUTING.md` | ❌ 不要 / Not needed | リポジトリ管理用 / For this repo only |
| `SECURITY.md` | ❌ 不要 / Not needed | リポジトリ管理用 / For this repo only |
| `CODE_OF_CONDUCT.md` | ❌ 不要 / Not needed | リポジトリ管理用 / For this repo only |
| `LICENSE` / `NOTICE` | ❌ 不要 / Not needed | リポジトリ管理用 / For this repo only |
| `.github/` | ❌ 不要 / Not needed | Issue/PRテンプレート。リポジトリ管理用 / Issue/PR templates. For this repo only |
| `.gitignore` | ❌ 不要 / Not needed | リポジトリ管理用 / For this repo only |

### エージェント別セットアップ / Agent-Specific Setup

| 手順 / Step | Antigravity | Cursor | Claude Code | Copilot |
|:-----------|:------------|:-------|:------------|:--------|
| 1. `AGENTS.md` + `rampart-rules/` をコピー（`rampart-prompts/` は任意） | ✅ | ✅ | ✅ | ✅ |
| 2. `.agent/rules/prompt_pointer.md` を配置 | ✅ **必須** | ❌ 不要 | ❌ 不要 | ❌ 不要 |
| 3. `CLAUDE.md` シムリンク作成 | ❌ 不要 | ❌ 不要 | ✅ `ln -s AGENTS.md CLAUDE.md` | ❌ 不要 |
| 4. 追加設定 | — | 任意: `.cursor/rules/*.mdc` | — | 任意: `.github/copilot-instructions.md` |

### 1. プロジェクトにコピー / Copy to your project

```bash
# 必須の2つだけコピー / Copy only the 2 required items
cp AGENTS.md /path/to/your/project/
cp -r rampart-rules /path/to/your/project/

# 任意：プロンプト集もコピー / Optional: copy prompt library
cp -r rampart-prompts /path/to/your/project/
```

### 2. エージェント固有の設定 / Agent-specific config

```bash
# === Google Antigravity ===
# .agent/rules/ はAntigravity固有。自動読み込み対象なのでポインターを配置。
# .agent/rules/ is Antigravity-specific. Place a pointer for auto-loading.
mkdir -p /path/to/your/project/.agent/rules
cp .agent/rules/prompt_pointer.md /path/to/your/project/.agent/rules/

# === Claude Code ===
# Claude CodeはCLAUDE.mdをネイティブに読むのでシムリンクを作成。
# Claude Code reads CLAUDE.md natively — create a symlink.
cd /path/to/your/project && ln -s AGENTS.md CLAUDE.md

# === Cursor / GitHub Copilot ===
# AGENTS.md を置くだけで動作します。追加設定は不要。
# Just placing AGENTS.md is sufficient. No additional setup needed.
```

> [!CAUTION]
> **JA**: `.agent/rules/` は **Antigravity固有**のディレクトリです。Cursor、Claude Code、GitHub Copilotでは不要です。各ツールには固有の設定ディレクトリがあります（上表参照）。Antigravityの場合もポインターのみ配置し、ルール本体は `rampart-rules/` に一元管理。
>
> **EN**: `.agent/rules/` is **Antigravity-specific**. It is NOT needed for Cursor, Claude Code, or GitHub Copilot. Each tool has its own native configuration directory (see table above). For Antigravity, only place the pointer here — rule definitions live in `rampart-rules/`.

### 3. 初期化 / Initialize

```bash
# AGENTS.md を編集 → Project Native Language を Japanese または English に設定
# Edit AGENTS.md → Set Project Native Language to Japanese or English

# 使用しない言語ディレクトリを削除 / Delete unused language directory:
rm -rf rampart-rules/universal/en rampart-rules/blueprint/en  # For Japanese projects
# OR
rm -rf rampart-rules/universal/ja rampart-rules/blueprint/ja  # For English projects

# rampart-prompts/ をコピーした場合 / If you copied rampart-prompts/:
rm -rf rampart-prompts/en  # For Japanese projects
# OR
rm -rf rampart-prompts/ja  # For English projects
```

### 4. 設定と開発 / Configure & Develop

| Step | JA | EN |
|:-----|:---|:---|
| 1 | `blueprint/*/000_project_overview.md` をプロジェクトに合わせて編集 | Edit `blueprint/*/000_project_overview.md` for your project |
| 2 | 新機能は `998_feature_spec_template.md` を Category 600–800 にコピー | For new features, copy `998_feature_spec_template.md` to Category 600–800 |
| 3 | **コードを書く前に受け入れ条件を書く**（Blueprint First） | **Write Acceptance Criteria before writing code** (Blueprint First) |
| 4 | 開発開始 — AIエージェントは憲法に従う | Start development — AI agents will follow the constitution |

### 導入後のディレクトリ構成 / Post-Setup Directory Structure

```text
your-project/
 ├── AGENTS.md                    ← 必須：最高法規 / Required: Supreme Law
 ├── CLAUDE.md                    ← Claude Code のみ（AGENTS.md へのシムリンク）
 ├── .agent/                      ← Antigravity のみ / Antigravity only
 │    └── rules/
 │         └── prompt_pointer.md  ← ポインター / Pointer
 ├── rampart-rules/               ← 必須：ルール本体 / Required: Rule Definitions
 │    ├── INDEX.md
 │    ├── LOADING_PROTOCOL.md
 │    ├── CRYSTALLIZATION_PROTOCOL.md
 │    ├── universal/              ← 不変 / Immutable
 │    │    └── ja/ (or en/)
 │    └── blueprint/              ← プロジェクト固有 / Project-Specific
 │         └── ja/ (or en/)
 ├── rampart-prompts/             ← 任意：プロンプト集 / Optional: Prompt Library
 │    ├── ja/                     ← 日本語版 / Japanese
 │    └── en/                     ← 英語版 / English
 └── src/                         ← プロジェクトコード / Your Code
```

---

## 🏗️ 背景 / Background

### 🇯🇵 なぜRampartを作ったか

Rampart（ランパート）は、AIとの協働における品質課題への危機感から生まれました。

AIエージェントが登場する以前から、生成AI（ChatGPT等）を新規事業の構想や実務の中で活用していました。コードを書かせてみることもありましたが、本格的な開発に使ったわけではありません。それでも、AIと向き合う中でひとつだけ確信していたことがありました — **ハルシネーション、コンテキストの喪失、品質のブレ。明確なルールなしにAIを使い続ければ、いつか必ず破綻する。**

2025年、[Google Antigravity](https://labs.google/antigravity)のようなAIエージェントが登場したとき、直感しました：**「ガバナンス構造なしにこれを使い始めたら取り返しがつかない」**と。逆に言えば、**最初から「憲法」を整備すれば、品質を劇的に底上げできる**はずだと。

そこで、開発を始める**前に**強固なガバナンスの構築に着手しました。そしてそのアーキテクチャを携えて実際のプロダクション開発に投入し、数百セッションの実戦を経てブラッシュアップしていきました。

**その過程で、ルールなしでは解決不可能なパターンが明確になりました：**

- **コンテキスト健忘症。** セッション間でアーキテクチャの決定を忘れる。命名規約がドリフトする。セキュリティパターンが退行する。修正済みのバグが再導入される。
- **操縦者依存の品質。** 正確な指示を出せば優れた成果物が出る。曖昧な指示では、バリデーションを省略し、型安全を無視し、安易なショートカットに逃げる。
- **Vibe Coding の引力。** 明示的な制約がなければ、すべてのセッションが "vibe coding" に引き寄せられる — 正しく見えるが、確立されたパターンを暗黙に違反するコード。
- **知見の蒸発。** 苦労して得た教訓が失われ、同じ問題を何度も再発見させられる。

業界全体も同じ問題に直面していました。AIが生成したコードがセキュリティ脆弱性の主要な原因となりつつあるとの報告、"AI slop"現象 — 低品質・重複コードの氾濫、コンテキストウィンドウの劣化による一貫性の喪失。個別ステップの成功率95%でも、マルチステップのワークフローでは60%以上の失敗率に膨れ上がります。

**気づき：** 問題はAIモデルではなく、*ガバナンスの不在*でした。セッション、操縦者、コンテキストリセットを超えて生き残る、永続的で強制力のあるガバナンス構造 — 「憲法」 — が存在しなかったのです。

Rampartがその答えです。作者自身、フロントエンドエンジニアとしての経験はあるものの、バックエンドやインフラは未経験からのスタートでした。だからこそ、**特定の言語やフレームワークに依存せず、エンジニア経験の深さに関わらず、AIと協働するすべての開発者 — 非エンジニアや個人開発者を含む — が最低限の品質底上げを実現できる**フレームワークを目指しました。

世界中の開発者がAIエージェントの恩恵を最大限に受けられるように。特にAI活用においてまだ発展途上にある日本からの発信として、自国のAI活用促進にも貢献できればと考えています。そして何より、この取り組み自体が自身の知見を深めるプロセスでもあります。

成果：2,500以上のエンジニアリング基準を網羅する30のUniversalルールファイル、ハルシネーションを排除する5ステップのBoot Sequence Protocol、教訓を自動的にルールに変換するCrystallization Protocol。すべて、たった一つの `AGENTS.md` 憲法を通じて強制されます。

### 🇺🇸 Why Rampart Was Built

Rampart was born from a conviction that AI without governance will inevitably fail.

Before AI agents existed, working with generative AI (ChatGPT, etc.) for business planning and day-to-day work revealed a persistent truth — **hallucinations, context loss, and inconsistent quality are inevitable without explicit rules.** AI is powerful, but using it without governance guarantees eventual failure.

When AI agents like [Google Antigravity](https://labs.google/antigravity) emerged in 2025, the intuition was immediate: **"Starting without a governance structure would be irreversible."** Conversely, **establishing a "constitution" from day one could dramatically raise the quality floor.**

So the governance architecture was built **before** development began. Then it was deployed into real production development and refined through hundreds of battle-tested sessions.

**Through that process, patterns that were impossible to solve without governance became clear:**

- **Context amnesia.** The AI forgot architectural decisions between sessions. Naming conventions drifted. Security patterns regressed. Fixed bugs were re-introduced.
- **Operator-dependent quality.** When instructions were precise, output was excellent. When vague, the AI took shortcuts — skipping validation, ignoring type safety, reaching for easy escapes.
- **Vibe coding gravity.** Without explicit constraints, every session tended toward "vibe coding" — code that looked correct but silently violated established patterns.
- **Knowledge evaporation.** Hard-won lessons were lost and had to be re-discovered repeatedly.

The industry was facing the same problem at scale. AI-generated code becoming a common vector for security vulnerabilities. The "AI slop" phenomenon — proliferation of low-quality, duplicated code — accelerating technical debt. Context window degradation causing models to lose coherence. Individual step reliability of 95% compounding to 60%+ failure rates across multi-step workflows.

**The realization:** The problem wasn't the AI model. It was the absence of *governance*. There was no "constitution" — no persistent, enforceable set of rules that survived across sessions, operators, and context resets.

Rampart was the answer. The author's own background — front-end engineering experience, but no prior back-end or infrastructure expertise — shaped the core design principle: **language-agnostic, framework-agnostic, and accessible regardless of engineering experience. A Constitution-Driven AI Agent Governance Framework that enables any developer working with AI — including non-engineers and solo developers — to raise their minimum quality floor.**

The goal extends beyond personal use: to contribute to the global adoption of AI-assisted development, and to help accelerate AI utilization worldwide. The result: 30 Universal Rule files covering 2,500+ engineering standards, a 5-step Boot Sequence Protocol that eliminates hallucination, a Crystallization Protocol that automatically converts lessons into rules. All enforced through a single `AGENTS.md` constitution that any AI agent can read.

---

## 💡 設計思想 / Philosophy

**Rampart**は**仕様駆動開発（SDD）**の原則を基盤に、**エージェントガバナンス**を上乗せした設計です。

**Rampart** is built on **Spec-Driven Development (SDD)** principles, extended with **Agent Governance**.

| 原則 / Principle | JA | EN |
|:-----------------|:---|:---|
| **Blueprint First** | 大規模変更は実装前に仕様更新を義務化 | Specs before code — major changes require spec updates before implementation |
| **Multi-step refinement** | INDEX → ルールロード → Blueprint → タスク → 計画 → 実装 → Walkthrough → 教訓 | INDEX → Rule Load → Blueprint → Task → Plan → Implement → Walkthrough → Lessons |
| **Strong guardrails** | 16の禁止事項 + 5つのプロトコル + 3層Git Hooks | 16 prohibitions + 5 protocols + 3-layer Git Hooks |
| **Continuous learning** | タスク完了後に教訓をルールに結晶化 | Lessons crystallized into rules after every task |
| **Quality floor** | 操縦者のスキルに関わらず最低品質基準を強制 | Minimum standards enforced regardless of operator skill |

> **JA**: Rampart（ランパート）はSDDそのものではありません。**憲法駆動型仕様開発（Constitution-Driven Specification Development）**のガバナンス基盤です。SDDを核に、AI行動統治・品質統治・運用統治を上乗せしたものです。
> 
> **EN**: Rampart is not SDD itself. It is a **Constitution-Driven Specification Development** governance architecture — SDD at its core, with AI behavioral governance, quality governance, and operational governance layered on top.


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

**JA**: バグ報告や機能リクエストは [GitHub Issues](https://github.com/hiroyuki-miyauchi/rampart/issues) をご利用ください。

**EN**: For bug reports and feature requests, use [GitHub Issues](https://github.com/hiroyuki-miyauchi/rampart/issues).
