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

教訓を1ファイル（`governance/010_project_lessons_log.md`）に無制限に蓄積すると、ファイルが膨大化しコンテキストウィンドウを圧迫する。
このプロトコルにより、教訓はドメインに対応した Blueprint フォルダへ自動分離・整理され、操縦者のスキルに依存せずに最適な構造が構築される。

**設計哲学: Co-location（共存）原則**
教訓はそれに関連するルールファイルと**同じフォルダ**に配置する。
AIがあるドメインフォルダ（例: `engineering/`）をロードするとき、そこにはルールだけでなく過去の教訓も存在するーコンテキスト効率が大幅に向上する。

### 🇺🇸 Problem and Solution

Accumulating all lessons in a single file causes unbounded growth and context window pressure.
This protocol ensures lessons are automatically separated into the appropriate Blueprint domain folder.

**Design Philosophy: Co-location Principle**
Lessons are placed in the **same folder** as the rule files they relate to.
When AI loads any domain folder (e.g., `engineering/` for DB/Architecture tasks, `quality/` for Security tasks), it finds both rules AND historical lessons there — maximizing context efficiency.

---

## 5-Step Auto-Crystallization / 5ステップ自動結晶化

```
┌──────────────────────────────────────────────────────┐
│  Step 1: CLASSIFY (分類)                              │
│  教訓のドメインを判定し、対応 Blueprint フォルダを特定  │
│  DB・認証 → engineering/                              │
│  セキュリティ・QA → quality/                          │
│  デザイン → design/ ... (Step 1 対応表を参照)          │
├──────────────────────────────────────────────────────┤
│  Step 2: SEARCH (既存ファイル検索)                     │
│  Step 1 で特定した Blueprint フォルダ内に              │
│  同ドメインの lessons ファイルが存在するか？            │
│  ├── YES → そのファイルに追記（完了）                  │
│  └── NO  → Step 3 へ                                 │
├──────────────────────────────────────────────────────┤
│  Step 3: ACCUMULATE (一時蓄積)                        │
│  governance/010_project_lessons_log.md に追記          │
│  ※ 必ず Domain / Target Folder タグを付ける           │
├──────────────────────────────────────────────────────┤
│  Step 4: THRESHOLD CHECK (閾値チェック)               │
│  governance/010 内の同一ドメイン教訓が 3件以上 になったか？ │
│  ├── YES → 対応フォルダに NNN_lessons_{domain}.md 作成 │
│  │         governance/010 には参照リンクのみ残す        │
│  └── NO  → governance/010 に留置                     │
├──────────────────────────────────────────────────────┤
│  Step 5: UPDATE INDEX (インデックス更新)               │
│  governance/010 の「分離済みドメインファイル一覧」更新   │
└──────────────────────────────────────────────────────┘
```

---

### Step 1: CLASSIFY (分類)

| 🇯🇵 | 🇺🇸 |
|:----|:----|
| 教訓のドメインを判定し、対応 Blueprint フォルダを特定する | Determine the lesson's domain and identify the corresponding Blueprint folder |

**ドメイン → Blueprint フォルダ 対応表 / Domain to Blueprint Folder Mapping:**

| ドメイン / Domain | Blueprint フォルダ | 昇華後のファイル名例 |
|:----------------|:--------------|:----------------|
| DB・認証 / DB & Auth | `engineering/` | `engineering/{NNN}_database_auth.md` |
| アーキテクチャ / Architecture | `engineering/` | `engineering/{NNN}_architecture_rules.md` |
| API設計 / API Design | `engineering/` | `engineering/{NNN}_api_design.md` |
| パフォーマンス / Performance | `engineering/` | `engineering/{NNN}_performance_policy.md` |
| セキュリティ / Security | `quality/` | `quality/{NNN}_security_policy.md` |
| 品質・QA / Quality & QA | `quality/` | `quality/{NNN}_qa_rules.md` |
| FinOps | `product/` | `product/{NNN}_finops_policy.md` |
| デザイン / Design | `design/` | `design/{NNN}_design_rules.md` |
| AI・コンテンツ / AI & Content | `ai/` | `ai/{NNN}_ai_content_rules.md` |
| ビジネス・グロース / Business & Growth | `product/` | `product/{NNN}_business_policy.md` |
| 運用・インシデント / Operations | `product/` | `product/{NNN}_operations_rules.md` （SRE等技術面は engineering/ に分類可） |
| ガバナンス・ルール / Governance | `governance/` | `governance/{NNN}_governance_rules.md` （010はインデックス固定のため020以降） |
| 機能仕様 / Feature Spec | `specs/` | `specs/{NNN}_{feature_name}.md` |

> **`{NNN}` の決定方法**: 昇華時に対象フォルダ内の既存ファイルをAIが実際に確認し、次の空き番号（10刷み）を自律判断する。番号は固定ではない。
> `000_` はルールファイル用に予約（昇華ファイルには使わない）。ファイル名に **`lessons_` は不要**。内容を表すトピック名のみ使う。


---

### Step 2: SEARCH (既存ファイル検索)

| 🇯🇵 | 🇺🇸 |
|:----|:----|
| Step 1 で特定した **Blueprint フォルダ内** に同ドメインのルールファイル（`{NNN}_{topic}.md`）が既に存在する場合、そのファイルに追記する | If a rule file for the same domain already exists in the **Blueprint folder identified in Step 1**, append to that file |

**検索例 / Search Examples:**
- DB関連教訓 → `blueprint/{lang}/engineering/` 内を検索
- セキュリティ教訓 → `blueprint/{lang}/quality/` 内を検索
- デザイン教訓 → `blueprint/{lang}/design/` 内を検索
- ガバナンス教訓 → `blueprint/{lang}/governance/` 内を検索（`010_project_lessons_log.md` は対象外）

---

### Step 3: ACCUMULATE (一時蓄積)

| 🇯🇵 | 🇺🇸 |
|:----|:----|
| 該当ドメインの教訓ファイルが存在しない場合、`governance/010_project_lessons_log.md` に一旦追記する（蓄積が閾値に達するまでの一時置き場） | If no domain lessons file exists, temporarily append to `governance/010_project_lessons_log.md` until the threshold is reached |

**必須フォーマット / Required Format:**

```markdown
### [YYYY-MM-DD] Lesson Title / 教訓のタイトル
**Domain:** {domain}
**Target Folder:** blueprint/{lang}/{folder}/  ← 行き先フォルダを明記
**Context:** 問題が発生した状況 / The situation where the problem occurred
**Problem:** 具体的な問題点 / The specific issue
**Solution/Rule:** 解決策または制定したルール / The solution or rule established
**Reference:** 関連ファイルやコミット / Related files or commits
```

---

### Step 4: THRESHOLD CHECK (閾値チェック)

| 🇯🇵 | 🇺🇸 |
|:----|:----|
| `governance/010_project_lessons_log.md`（中央インデックス）内の同一ドメインの教訓が **3件以上** に達した場合、AIは自律的に Step 1 の対応表に従い **対応 Blueprint フォルダ**内に正式ルールファイルを作成し、教訓を昇華・移動する | When same-domain lessons reach **3 or more** in `governance/010_project_lessons_log.md` (central index), AI MUST create a proper rule file in the **corresponding Blueprint folder** per the Step 1 mapping table, and elevate the lessons there |

**採番ルール / Numbering Rules:**
- **昇華時に対象フォルダ内の既存ファイルを実際に確認**し、次の空き番号（10刻み）を使用する（番号はフォルダの状態によって変わるため固定ではない）
- `000_` はルールファイル用に予約（昇華ファイルには使わない）
- `governance/010_project_lessons_log.md`（中央インデックス）は固定。`governance/` 内の昇華ルールファイルは `020_` 以降を使用
- ファイル名に **`lessons_` は不要**。内容を表すトピック名のみ使う（例: `database_auth`, `security_policy`, `api_design`）

**作成例 / Creation Example:**
```
# 3件のDB教訓が governance/010 に溜まった場合:
作成ファイル: blueprint/ja/engineering/300_database_auth.md  (教訓を正式ルールに昇華)
governance/010 には参照リンクのみ残す: "→ engineering/300_database_auth.md に昇華済み"
```

---

### Step 5: UPDATE INDEX (インデックス更新)

| 🇯🇵 | 🇺🇸 |
|:----|:----|
| `governance/010_project_lessons_log.md` の「分離済みドメインファイル一覧」表を更新する | Update the "Separated Domain Files" table in `governance/010_project_lessons_log.md` |

---

## Crystallized Rule File Template / 昇華ルールファイルテンプレート

> [!IMPORTANT]
> **🇯🇵**: AIが新規ドメインファイルを作成する際、**以下のテンプレートに厳格に従うこと**。
> `universal/` のルールファイルと同等の構造的一貫性を維持し、AIが探索・参照しやすい構造にする。
>
> **🇺🇸**: When the AI creates a new domain file, it **MUST strictly follow this template**.
> Maintain structural consistency equivalent to `universal/` rule files for AI navigability.

```markdown
# Lessons: {Domain Name} ({日本語ドメイン名})

> **Domain**: {domain}
> **Location**: blueprint/{lang}/{folder}/{NNN}_{topic}.md
> **Created**: {YYYY-MM-DD} (Auto-Crystallized from governance/010_project_lessons_log.md)
> **Related Universal Rules**: `{folder}/{rule_file_1}`, `{folder}/{rule_file_2}`

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
| `{universal_folder}/{rule_file}.md` | Governing rule / 統治ルール |
| `governance/010_project_lessons_log.md` | Index (crystallization source) / インデックス（結晶化元） |
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
| `Location` | 実際のファイルパス（`blueprint/{lang}/{folder}/{NNN}_{topic}.md`） |
| `Created` | 作成日 + 「Auto-Crystallized from governance/010」の記載 |
| `Related Universal Rules` | 関連するUniversalルールファイル名（フォルダパス含む） |

### 2. Cross-Reference Table / 相互参照テーブル

| 🇯🇵 | 🇺🇸 |
|:----|:----|
| ファイル末尾に必ず相互参照テーブルを配置すること | A cross-reference table MUST be placed at the end of every file |
| `governance/010` へのリンクを必ず含めること | MUST include a link back to `governance/010` |
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

**Before (governance/010 に3件のDB教訓が蓄積):**

```
blueprint/ja/governance/010_project_lessons_log.md:
  ### [2026-01-15] RLSポリシーの設計ミス
  Domain: DB・認証 | Target Folder: engineering/

  ### [2026-02-03] マイグレーション順序の依存関係
  Domain: DB・認証 | Target Folder: engineering/

  ### [2026-02-20] auth.uid()のパフォーマンス問題
  Domain: DB・認証 | Target Folder: engineering/

  ### [2026-01-20] APIキーの漏洩リスク
  Domain: セキュリティ | Target Folder: quality/  ← 1件のみ、留置
```

**After (AIが自動実行):**

```
blueprint/ja/
├── governance/
│   └── 010_project_lessons_log.md
│       ← インデックスのみ残留。DB教訓の行は参照リンクに置換済み。
│         セキュリティ教訓はまだ1件のためここに留置。
└── engineering/
    └── 300_database_auth.md  ← DB教訓3件が移動（新規自動作成）

※ quality/ フォルダにはまだ教訓ファイルが生成されていない（セキュリティ教訓はまだ1件のため）

governance/010 の「分離済みドメインファイル一覧」が更新：
  | DB・認証 | engineering/300_database_auth.md | 3件 |
```

> **なぜ `governance/` に全部入れないのか**:
> DBの教訓は `engineering/` に、セキュリティの教訓は `quality/` に Co-locate することで、
> AIがエンジニアリングタスクを実行する際に `engineering/` をロードすれば過去の教訓も自動的に参照できる。
> `governance/` に全部集めると、毎回 `governance/` をロードしないと教訓にアクセスできず、
> コンテキスト効率が著しく低下する。
