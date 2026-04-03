# Crystallization Protocol (教訓の結晶化プロトコル)

> [!IMPORTANT]
> **🇯🇵**: このプロトコルは `AGENTS.md` §8「Continuous Improvement」の詳細手順書です。
> AIが教訓を記録する際に自律的に実行する必要があります。
>
> **🇺🇸**: This protocol is the detailed procedure for `AGENTS.md` §8 "Continuous Improvement".
> The AI MUST execute this autonomously when recording lessons.

---

## 📑 Table of Contents / 目次

1. [Overview / 概要](#overview--概要)
2. [5-Step Auto-Crystallization / 5ステップ自動結晶化](#5-step-auto-crystallization--5ステップ自動結晶化)
3. [Domain File Template / ドメインファイルテンプレート](#domain-file-template--ドメインファイルテンプレート)
4. [Structural Requirements / 構造要件](#structural-requirements--構造要件)
5. [Examples / 具体例](#examples--具体例)

---

## Overview / 概要

### 🇯🇵 問題と解決策

教訓を1ファイル（`010_project_lessons_log.md`）に無制限に蓄積すると、ファイルが膨大化しコンテキストウィンドウを圧迫する。
このプロトコルにより、教訓はドメイン別に自動分離・整理され、操縦者のスキルに依存せずに最適な構造が構築される。

### 🇺🇸 Problem and Solution

Accumulating all lessons in a single file (`010_project_lessons_log.md`) causes unbounded growth and context window pressure.
This protocol ensures lessons are automatically separated and organized by domain, building an optimal structure regardless of operator skill.

---

## 5-Step Auto-Crystallization / 5ステップ自動結晶化

```
┌──────────────────────────────────────────────────────┐
│  Step 1: CLASSIFY (分類)                              │
│  教訓のドメインを判定する                               │
│  (DB・認証 / セキュリティ / アーキテクチャ / 品質 / etc.) │
├──────────────────────────────────────────────────────┤
│  Step 2: SEARCH (既存ファイル検索)                      │
│  blueprint/ 内に該当ドメインの                          │
│  0X0_lessons_{domain}.md が存在するか？                 │
│  ├── YES → Step 2a: そのファイルに追記                  │
│  └── NO  → Step 3 へ                                  │
├──────────────────────────────────────────────────────┤
│  Step 3: ACCUMULATE (未分類の蓄積)                      │
│  010_project_lessons_log.md に一旦追記する              │
│  ※ 必ず Domain: タグを付けること                        │
├──────────────────────────────────────────────────────┤
│  Step 4: THRESHOLD CHECK (閾値チェック)                 │
│  010 内の同一ドメインの教訓が 3件以上 溜まったか？       │
│  ├── YES → 新規ドメインファイルを作成し教訓を移動       │
│  │         010 にはドメインファイルへの参照リンクを残す   │
│  └── NO  → 010 に留置                                 │
├──────────────────────────────────────────────────────┤
│  Step 5: UPDATE INDEX (インデックス更新)                │
│  010 の「分離済みドメインファイル一覧」表を更新           │
└──────────────────────────────────────────────────────┘
```

### Step 1: CLASSIFY (分類)

| 🇯🇵 | 🇺🇸 |
|:----|:----|
| 教訓のドメインを判定する | Determine the lesson's domain |

**推奨ドメインカテゴリ / Recommended Domain Categories:**

| Domain / ドメイン | File Suffix | Related Universal Rules |
|:-----------------|:-----------|:-----------------------|
| DB・認証 / DB & Auth | `database_auth` | `320_supabase`, `600_security` |
| セキュリティ / Security | `security` | `600_security_privacy` |
| アーキテクチャ / Architecture | `architecture_strategy` | `300_engineering_standards` |
| 品質 / Quality | `quality_audit` | `700_qa_testing` |
| デザイン / Design | `design` | `200_design_ux` |
| 運用 / Operations | `operations` | `502_site_reliability` |
| ガバナンス / Governance | `governance_rules` | `801_governance` |
| パフォーマンス / Performance | `performance` | `300_engineering`, `720_finops` |
| FinOps | `finops` | `720_cloud_finops` |

### Step 2: SEARCH (既存ファイル検索)

| 🇯🇵 | 🇺🇸 |
|:----|:----|
| `blueprint/` 内に該当ドメインの `0X0_lessons_{domain}.md` が既に存在する場合、そのファイルに追記する | If a `0X0_lessons_{domain}.md` file already exists in `blueprint/`, append to that file |

### Step 3: ACCUMULATE (未分類の蓄積)

| 🇯🇵 | 🇺🇸 |
|:----|:----|
| 該当ドメインのファイルが存在しない場合、`010_project_lessons_log.md` に一旦追記する | If no domain file exists, temporarily append to `010_project_lessons_log.md` |

**必須フォーマット / Required Format:**

```markdown
### [YYYY-MM-DD] Lesson Title / 教訓のタイトル
**Domain:** {domain}
**Context:** 問題が発生した状況 / The situation where the problem occurred
**Problem:** 具体的な問題点 / The specific issue
**Solution/Rule:** 解決策または制定したルール / The solution or rule established
**Reference:** 関連ファイルやコミット / Related files or commits
```

### Step 4: THRESHOLD CHECK (閾値チェック)

| 🇯🇵 | 🇺🇸 |
|:----|:----|
| `010` 内の同一ドメインの教訓が **3件以上** に達した場合、AIは自律的に新規ドメインファイルを作成し、該当教訓を移動する | When lessons of the **same domain reach 3 or more** in `010`, the AI MUST create a new domain file and move the lessons |

**採番ルール / Numbering Rules:**
- `020`, `030`, `040`, `050`... と10刻みで採番 / Number in increments of 10
- 既存の最大番号 + 10 で次の番号を決定 / Next number = max existing + 10
- `010` はインデックスとして固定 / `010` remains fixed as the index

### Step 5: UPDATE INDEX (インデックス更新)

| 🇯🇵 | 🇺🇸 |
|:----|:----|
| `010` の「分離済みドメインファイル一覧」表を更新する | Update the "Separated Domain Files" table in `010` |

---

## Domain File Template / ドメインファイルテンプレート

> [!IMPORTANT]
> **🇯🇵**: AIが新規ドメインファイルを作成する際、**以下のテンプレートに厳格に従うこと**。
> `universal/` のルールファイルと同等の構造的一貫性を維持し、AIが探索・参照しやすい構造にする。
>
> **🇺🇸**: When the AI creates a new domain file, it **MUST strictly follow this template**.
> Maintain structural consistency equivalent to `universal/` rule files for AI navigability.

```markdown
# Lessons: {Domain Name} ({日本語ドメイン名})

> **Domain**: {domain}
> **Created**: {YYYY-MM-DD} (Auto-Crystallized from 010_project_lessons_log.md)
> **Related Universal Rules**: `{rule_file_1}`, `{rule_file_2}`

---

## 📑 Table of Contents / 目次

1. [Lessons / 教訓](#lessons--教訓)
2. [Cross-Reference / 相互参照](#cross-reference--相互参照)

---

## Lessons / 教訓

### [YYYY-MM-DD] Lesson Title / 教訓タイトル
**Domain:** {domain}
**Context:** ...
**Problem:** ...
**Solution/Rule:** ...
**Reference:** ...

---

## Cross-Reference / 相互参照

| Related File / 関連ファイル | Relationship / 関係 |
|:--------------------------|:-------------------|
| `{universal_rule}.md` | Governing rule / 統治ルール |
| `010_project_lessons_log.md` | Index (crystallization source) / インデックス（結晶化元） |
```

---

## Structural Requirements / 構造要件

> [!CAUTION]
> **🇯🇵**: ドメインファイル作成時、以下の構造要件を**必ず**満たすこと。
> **🇺🇸**: When creating domain files, the following structural requirements **MUST** be met.

### 1. Header Metadata / ヘッダーメタデータ

| 必須項目 / Required | 説明 / Description |
|:-------------------|:-------------------|
| `Domain` | ドメイン名（Step 1のカテゴリに一致） |
| `Created` | 作成日 + 「Auto-Crystallized from 010」の記載 |
| `Related Universal Rules` | 関連するUniversalルールファイル名 |

### 2. Cross-Reference Table / 相互参照テーブル

| 🇯🇵 | 🇺🇸 |
|:----|:----|
| ファイル末尾に必ず相互参照テーブルを配置すること | A cross-reference table MUST be placed at the end of every file |
| `010` へのリンクを必ず含めること | MUST include a link back to `010` |
| 関連する Universal ルールへのリンクを含めること | MUST include links to related Universal rules |

### 3. Consistency with Universal Rules / Universalルールとの構造的一貫性

| 🇯🇵 | 🇺🇸 |
|:----|:----|
| `## 📑 Table of Contents` を必ず含めること | MUST include `## 📑 Table of Contents` |
| セクション見出しは `##` レベルで統一すること | Section headings MUST use `##` level |
| 各教訓は `###` レベルで記述すること | Each lesson MUST use `###` level |

---

## Examples / 具体例

### Auto-Separation Example / 自動分離の具体例

**Before (010に3件のDB教訓が蓄積):**

```
010_project_lessons_log.md:
  - [2026-01-15] Domain: DB・認証 — RLSポリシーの設計ミス
  - [2026-02-03] Domain: DB・認証 — マイグレーション順序の依存関係
  - [2026-02-20] Domain: DB・認証 — auth.uid()のパフォーマンス問題
  - [2026-01-20] Domain: セキュリティ — APIキーの漏洩リスク  ← 1件のみ、留置
```

**After (AIが自動実行):**

```
blueprint/ja/
  ├── 010_project_lessons_log.md   ← インデックス + セキュリティ教訓(1件)が残留
  └── 020_lessons_database_auth.md ← DB教訓3件が移動（自動作成）

010 の表が更新:
  | 020 | DB・認証 | 020_lessons_database_auth.md | 3 |
```
