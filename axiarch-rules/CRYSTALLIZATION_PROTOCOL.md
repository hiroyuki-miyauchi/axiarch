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
2. [Auto-Crystallization Steps / 自動結晶化ステップ](#auto-crystallization-steps--自動結晶化ステップ)
3. [Crystallized Rule File Template / 昇華ルールファイルテンプレート](#crystallized-rule-file-template--昇華ルールファイルテンプレート)
4. [Structural Requirements / 構造要件](#structural-requirements--構造要件)
5. [Examples / 具体例](#examples--具体例)

---

## 🚨 SUPREME RULE: 実務限定原則 / Practical Experience Only

> [!CAUTION]
> **🇯🇵**: 結晶化の対象は **「実際のタスク実行中に遭遇した問題・判断・発見」のみ** に限定する。
> AIが **ユーザーの明示的な指示なしに** 独自にリサーチ・調査して「ベストプラクティス」を追加することは **厳禁** である。
> ユーザーが明示的に「調査して追加して」等の指示を出した場合のみ例外とする。
>
> **🇺🇸**: Crystallization is **strictly limited to problems, decisions, and discoveries encountered during actual task execution**.
> AI **MUST NOT** independently research and add "best practices" **without explicit user instruction**.
> The only exception is when the user explicitly instructs the AI to research and add content.

**🇯🇵 記録してよいもの（✅ Allowed — 例）:**
- 実装中に遭遇したバグとその解決策
- 設計判断で迷った結果と選択理由
- 既存コードとの統合で発見した制約
- デプロイ・テスト中に判明した問題

**🇯🇵 記録してはならないもの（❌ Prohibited — ユーザーの明示的指示がない場合の例）:**
- AIが一般知識から生成した「推奨事項」
- 実際に問題が起きていない予防的ルール
- AI独断で外部ドキュメントを調査して追加したベストプラクティス
- 「こうすべき」という理想論（実際の痛みを伴っていないもの）

**🇺🇸 Allowed (✅ — examples):**
- Bugs encountered during implementation and their solutions
- Design decisions with reasoning for the choice made
- Constraints discovered during integration with existing code
- Issues found during deployment or testing

**🇺🇸 Prohibited (❌ — examples, without explicit user instruction):**
- "Recommendations" generated from AI's general knowledge
- Preventive rules for problems that haven't actually occurred
- Best practices the AI independently researched from external documentation
- "Should do" ideals not grounded in actual pain

**判定基準 / Litmus Test:**
> 🇯🇵「この教訓は、今回のタスクで**実際に何が起きたか**を記述しているか？」→ Yes なら記録。No なら記録禁止。
>
> 🇺🇸 "Does this lesson describe **what actually happened** during this task?" → Yes = record. No = do NOT record.

---

## Overview / 概要

### 🇯🇵 問題と解決策

教訓を1ファイル（`core/010_project_lessons_log.md`）に無制限に蓄積すると、ファイルが膨大化しコンテキストウィンドウを圧迫する。
このプロトコルにより、教訓はドメインに対応した Blueprint フォルダへ自動分離・整理され、操縦者のスキルに依存せずに最適な構造が構築される。

**設計哲学: Co-location（共存）原則**
教訓はそれに関連するルールファイルと**同じフォルダ**に配置する。
AIがあるドメインフォルダ（例: `engineering/`）をロードするとき、そこにはルールだけでなく過去の教訓も存在するーコンテキスト効率が大幅に向上する。

### 🇺🇸 Problem and Solution

Accumulating all lessons in a single file causes unbounded growth and context window pressure.
This protocol ensures lessons are automatically separated into the appropriate Blueprint domain folder.

**Design Philosophy: Co-location Principle**
Lessons are placed in the **same folder** as the rule files they relate to.
When AI loads any domain folder (e.g., `engineering/` for DB/Architecture tasks, `security/` for Security tasks), it finds both rules AND historical lessons there — maximizing context efficiency.

---

## Auto-Crystallization Steps / 自動結晶化ステップ

```
┌────────────────────────────────────────────────────────────────┐
│  Step 1: CLASSIFY (分類 / Classification)                      │
│  教訓のドメインを判定し、対応 Blueprint フォルダを特定          │
│  Determine domain → identify target Blueprint folder           │
│  DB・認証 → engineering/ / セキュリティ → security/            │
│  QA・テスト → quality/ / デザイン → design/                    │
│  ... (Step 1 対応表を参照 / See Step 1 mapping table)          │
├────────────────────────────────────────────────────────────────┤
│  Step 2: DEDUP CHECK (Universal 重複チェック / Dedup Check)     │
│  同様のルールが universal/ に既に存在しないか確認              │
│  Check if similar rule already exists in universal/            │
│  ├── 存在する / Exists → 記録不要 / Skip (dedup). Done.       │
│  └── 存在しない / Not found → Step 3 へ / Proceed to Step 3   │
├────────────────────────────────────────────────────────────────┤
│  Step 3: SEARCH (既存ファイル検索 / Search Existing Files)      │
│  Step 1 で特定した Blueprint フォルダ内に                      │
│  同ドメインの lessons ファイルが存在するか？                    │
│  Does a domain file exist in the target Blueprint folder?      │
│  ├── YES → そのファイルに追記 / Append to it. Done.            │
│  └── NO  → Step 4 へ / Proceed to Step 4                      │
├────────────────────────────────────────────────────────────────┤
│  Step 4: ACCUMULATE (一時蓄積 / Temporary Accumulation)        │
│  core/010_project_lessons_log.md に追記                        │
│  Append to core/010_project_lessons_log.md                     │
│  ※ 必ず Domain / Target Folder タグを付ける                   │
│     Always include Domain / Target Folder tags                 │
├────────────────────────────────────────────────────────────────┤
│  Step 5: THRESHOLD CHECK (閾値チェック / Threshold Check)      │
│  core/010 内の同一ドメイン教訓が 3件以上 になったか？          │
│  Have 3+ same-domain lessons accumulated in core/010?          │
│  ├── YES → 対応フォルダに {NNN}_{topic}.md 作成               │
│  │         Create {NNN}_{topic}.md in target folder            │
│  │         core/010 には参照リンクのみ残す                     │
│  │         Leave only reference link in core/010               │
│  └── NO  → core/010 に留置 / Keep in core/010                 │
├────────────────────────────────────────────────────────────────┤
│  Step 6: UPDATE INDEX (インデックス更新 / Update Index)        │
│  core/010 の「分離済みドメインファイル一覧」更新               │
│  Update "Separated Domain Files" table in core/010             │
└────────────────────────────────────────────────────────────────┘
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
| セキュリティ / Security | `security/` | `security/{NNN}_security_policy.md` |
| 品質・QA / Quality & QA | `quality/` | `quality/{NNN}_qa_rules.md` |
| FinOps | `operations/` | `operations/{NNN}_finops_policy.md` |
| デザイン / Design | `design/` | `design/{NNN}_design_rules.md` |
| AI・コンテンツ / AI & Content | `ai/` | `ai/{NNN}_ai_content_rules.md` |
| ビジネス・グロース / Business & Growth | `product/` | `product/{NNN}_business_policy.md` |
| 運用・インシデント / Operations | `operations/` | `operations/{NNN}_operations_rules.md` |
| コア・ガバナンス / Core & Gov | `core/` | `core/{NNN}_governance_rules.md` （010はインデックス固定のため020以降） |

> **`{NNN}` の決定方法 (Contextual Numbering)**: 昇華時に対象フォルダ内の既存ファイルをAIが実際に確認し、内容が関連する既存ファイルの近接番号を自律判断して割り当てる（基本は拡張余地を残すため10刻みとするが、空きがない場合は `011` や `015` などの間の番号を使用する）。枯渇を防ぐため厳密な10刻みは強制しない。 / **How to determine `{NNN}`**: The AI MUST check existing files in the target folder and assign a number close to related topics (default to increments of 10 to leave room, but use interstitial numbers like `011` or `015` if space is tight). Do not strictly force increments of 10.
> 昇華ファイル含むすべてのファイルで `000`〜`999` の任意の空き番号を使用可能です。ファイル名に **`lessons_` は不要**。内容を表すトピック名のみ使う。

> **フォルダの拡張性 / Folder Extensibility**: 上記8フォルダは初期構成として事前準備されているが、**閉じたリストではない**。上記の対応表にないドメインの教訓が蓄積された場合、AIは新しいフォルダの作成を**ユーザーに提案**してよい（独断での作成は禁止）。ただし、まず既存フォルダへの分類を優先すること。
> The 8 folders above are pre-provisioned as the initial structure, but this is **NOT a closed list**. If lessons accumulate for a domain not covered by the mapping table above, the AI MAY **propose** a new folder to the user (autonomous creation is prohibited). However, classification into existing folders should always be prioritized first.


---

### Step 2: DEDUP CHECK (Universal 重複チェック)

| 🇯🇵 | 🇺🇸 |
|:----|:----|
| 記録しようとしている教訓と同様のルールが `universal/{lang}/` の対応ドメインフォルダに**既に存在しないか**確認する。Universalは「憲法」であり、そこに既にカバーされている内容をBlueprintに重複記載する必要はない。 | Before recording, check whether a **similar rule already exists** in `universal/{lang}/` under the corresponding domain folder. Universal is the "Constitution" — content already covered there does NOT need to be duplicated in Blueprint. |

**判定基準 / Decision Criteria:**
- 🇯🇵 Universalに同趣旨のルールが存在 → **記録不要**（重複回避）。完了。
- 🇯🇵 Universalに存在しない、またはプロジェクト固有の文脈が必要 → **Step 3 へ進む**
- 🇺🇸 Similar rule exists in Universal → **Do NOT record** (dedup). Done.
- 🇺🇸 Not in Universal, or project-specific context needed → **Proceed to Step 3**

---

### Step 3: SEARCH (既存ファイル検索)

| 🇯🇵 | 🇺🇸 |
|:----|:----|
| Step 1 で特定した **Blueprint フォルダ内** に同ドメインのルールファイル（`{NNN}_{topic}.md`）が既に存在する場合、そのファイルに追記する | If a rule file for the same domain already exists in the **Blueprint folder identified in Step 1**, append to that file |

**検索例 / Search Examples:**
- DB関連教訓 → `blueprint/{lang}/engineering/` 内を検索
- セキュリティ教訓 → `blueprint/{lang}/security/` 内を検索
- デザイン教訓 → `blueprint/{lang}/design/` 内を検索
- ガバナンス教訓 → `blueprint/{lang}/core/` 内を検索（`core/010_project_lessons_log.md` は対象外）

---

### Step 4: ACCUMULATE (一時蓄積)

| 🇯🇵 | 🇺🇸 |
|:----|:----|
| 該当ドメインの教訓ファイルが存在しない場合、`core/010_project_lessons_log.md` に一旦追記する（蓄積が閾値に達するまでの一時置き場） | If no domain lessons file exists, temporarily append to `core/010_project_lessons_log.md` until the threshold is reached |

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

### Step 5: THRESHOLD CHECK (閾値チェック)

| 🇯🇵 | 🇺🇸 |
|:----|:----|
| `core/010_project_lessons_log.md`（中央インデックス）内の同一ドメインの教訓が **3件以上** に達した場合、AIは自律的に Step 1 の対応表に従い **対応 Blueprint フォルダ**内に正式ルールファイルを作成し、教訓を昇華・移動する | When same-domain lessons reach **3 or more** in `core/010_project_lessons_log.md` (central index), AI MUST create a proper rule file in the **corresponding Blueprint folder** per the Step 1 mapping table, and elevate the lessons there |

> [!CAUTION]
> **🇯🇵 新規ドメインフォルダの独断作成禁止**: Blueprint の各ドメインフォルダ（`ai/`, `design/`, `engineering/`, `operations/`, `product/`, `quality/`, `security/`）は、Universal と同型の構造で**事前に配置済み**（各フォルダに `README.md` が存在）。AIが**独断で**新しいドメインフォルダを作成することは**禁止**する。教訓の配置先は、Step 1 の対応表に定義された既存フォルダのみとする。ただし、既存フォルダに分類できない全く新しいドメインが発生した場合は、**ユーザーに新規フォルダの作成を提案**してよい（Step 1「フォルダの拡張性」参照）。
>
> **🇺🇸 Autonomous New Domain Folder Creation Prohibited**: Blueprint domain folders (`ai/`, `design/`, `engineering/`, `operations/`, `product/`, `quality/`, `security/`) are **pre-provisioned** with the same structure as Universal (each containing a `README.md`). AI is **prohibited** from **autonomously** creating new domain folders. Lessons MUST be placed ONLY in existing folders defined in the Step 1 mapping table. However, if a completely new domain arises that cannot be classified into existing folders, the AI MAY **propose** creating a new folder to the user (see Step 1 "Folder Extensibility").

**採番ルール / Numbering Rules:**
- **🚨 空白地帯禁止 (No Blank Zones)**: 各ドメイン内で `000`〜`999` を独立して使用する（特定ドメイン専用の予約帯域は存在しない）。 / Use `000`-`999` independently per domain (no domain-specific reserved bands).
- **文脈的採番 (Contextual Numbering)**: 昇華時に対象フォルダの既存ファイルを実際に確認し、関連トピックの近接番号を割り当てる。基本は10刻みで拡張余地を残すが、空きがない場合は間の番号（例: `011`, `015`）を使用する。厳密な10刻み強制による999枯渇を回避せよ。 / **Contextual Numbering**: Check existing files in the target folder and assign a number close to related topics (default to increments of 10, but use interstitial numbers like `011` or `015` if space is tight). Do not strictly force increments of 10.
- `core/010_project_lessons_log.md`（中央インデックス）は固定。`core/` 内の昇華ルールファイルは `020_` 以降を使用 / `core/010_project_lessons_log.md` is fixed. Crystallized files in `core/` start from `020_`.
- ファイル名に **`lessons_` は不要**。内容を表すトピック名のみ使う（例: `database_auth`, `security_policy`, `api_design`） / **Do not include `lessons_` in the file name**. Use only topic names describing the content.

**作成例 / Creation Example:**
```
# 3件のDB教訓が core/010 に溜まった場合 / When 3 DB lessons accumulate in core/010:
作成ファイル / Create: blueprint/ja/engineering/010_database_auth.md  (教訓を正式ルールに昇華 / Elevate lessons to proper rule)
core/010 には参照リンクのみ残す / Leave only a reference link in core/010:
  "→ engineering/010_database_auth.md に昇華済み / Elevated to engineering/010_database_auth.md"
```

> **注記 / Note**: Blueprint の採番は **Blueprint フォルダ内で独立**しており、Universal フォルダの番号とは無関係です。
> Blueprint numbering is **independent within each Blueprint folder** and unrelated to Universal folder numbering.

---

### Step 6: UPDATE INDEX (インデックス更新)

| 🇯🇵 | 🇺🇸 |
|:----|:----|
| `core/010_project_lessons_log.md` の「分離済みドメインファイル一覧」表を更新する | Update the "Separated Domain Files" table in `core/010_project_lessons_log.md` |

---

## Crystallized Rule File Template / 昇華ルールファイルテンプレート

> [!IMPORTANT]
> **🇯🇵**: AIが新規ドメインファイルを作成する際、**以下のテンプレートに厳格に従うこと**。
> `universal/` のルールファイルと同等の構造的一貫性を維持し、AIが探索・参照しやすい構造にする。
>
> **🇺🇸**: When the AI creates a new domain file, it **MUST strictly follow this template**.
> Maintain structural consistency equivalent to `universal/` rule files for AI navigability.

```markdown
# {NNN}. {Topic Name}

> [!NOTE]
> **🇯🇵**: このファイルは Blueprint Rule（プロジェクト固有ルール）です。
> `core/010_project_lessons_log.md` から自動結晶化されました。
> **🇺🇸**: This file is a Blueprint Rule (project-specific rule).
> Auto-crystallized from `core/010_project_lessons_log.md`.
> Created: {YYYY-MM-DD}

> [!IMPORTANT]
> **Domain**: {domain}
> **Location**: `blueprint/{lang}/{folder}/{NNN}_{topic}.md`
> **Related Universal Rules**: `universal/{lang}/{domain}/{rule_file_1}.md`, `universal/{lang}/{domain}/{rule_file_2}.md`
> **{N} sections.**

---

## 📳 目次 / Table of Contents

| セクション / Section | 内容 / Content | セクション数 / Count |
|:---------|:-----|:--:|
| 教訓 / Lessons | 結晶化されたルール・教訓 / Crystallized rules & lessons | {N} |
| Appendix A | 逆引き索引 & クロスリファレンス / Quick Reference & Cross-References | 1 |

---

## 教訓 / Lessons

### [YYYY-MM-DD] Lesson Title
**Domain:** {domain}
**Context:** ...
**Problem:** ...
**Solution/Rule:** ...
**Reference:** ...

---

## Appendix A: Quick Reference & Cross-References / 逆引き索引 & クロスリファレンス

### Quick Reference / 逆引き索引（Keyword → Section）

| Keyword | Section | Related Rule |
|:---------|:------------|:---------|
| {keyword_1} | Lessons — {lesson_title} | `{universal_folder}/{rule_file}.md` |

### Cross-References / クロスリファレンス

| Related File | Relationship |
|:-----------|:-----|
| `{universal_folder}/{rule_file}.md` | Governing Rule (Universal) |
| `core/010_project_lessons_log.md` | Index (crystallization origin) |
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
| `Created` | 作成日 + 「Auto-Crystallized from core/010」の記載 |
| `Related Universal Rules` | 関連するUniversalルールファイル名（フォルダパス含む） |

### 2. Cross-Reference Table / 相互参照テーブル

| 🇯🇵 | 🇺🇸 |
|:----|:----|
| ファイル末尾に必ず相互参照テーブルを配置すること | A cross-reference table MUST be placed at the end of every file |
| `core/010` へのリンクを必ず含めること | MUST include a link back to `core/010` |
| 関連する Universal ルールへのリンクを含めること | MUST include links to related Universal rules |

### 3. Consistency with Universal Rules / Universalルールとの構造的一貫性

| 🇯🇵 | 🇺🇸 |
|:----|:----|
| `## 目次` セクション（テーブル形式 or リスト形式）を必ず含めること | MUST include `## 目次` section (table or list format) |
| セクション見出しは `##` レベルで統一すること | Section headings MUST use `##` level |
| 各教訓は `###` レベルで記述すること | Each lesson MUST use `###` level |

### 4. Structural Isomorphism / 構造的同型性（Appendix A 義務）

> [!IMPORTANT]
> **🇯🇵**: ルール反映時（昇華・新規作成・追記問わず）、作成・変更するファイルが他の憲法ファイル（Universal / Blueprint）と**同じ構造パターン**を持つことを確認し、欠落があれば補完すること。
>
> **🇺🇸**: When reflecting rules (whether crystallizing, creating new, or appending), verify that the created/modified file follows the **same structural pattern** as other Constitution files (Universal / Blueprint). Fill in any missing structural elements.

**Universal ファイルの標準構造パターン（実例から抽出）:**

| # | 必須構造要素 | 説明 | Universal 実例 |
|:--|:-----------|:-----|:--------------|
| 1 | **タイトル行** `# {NNN}. {名称}` | ファイル冒頭のH1見出し。番号 + 名称 | `# 74. 言語プロトコル`, `# 30. エンジニアリング基準`, `# 60. セキュリティとプライバシー` |
| 2 | **CAUTION/NOTE ブロック** | ファイルの位置づけ宣言（Universal=CAUTION, Blueprint=NOTE/TIP） | `> [!CAUTION] このファイルは Universal Rule（不変ルール）です。` |
| 3 | **IMPORTANT ブロック** | Supreme Directive + 構成サマリ（`{N}パート・{M}セクション構成。`） | `> [!IMPORTANT] Supreme Directive（最高指令）...13パート・80セクション構成。` |
| 4 | **`## 目次`** | テーブル形式（Part/セクション/行数）またはリスト形式の目次 | `## 目次` + `| Part | トピック | セクション | セクション数 |` |
| 5 | **本文セクション** `## Part {N}:` or `## §{N}.` | `##` で主要セクション、`###` でサブセクション | `## Part I: コード品質とクリーンコード`, `## §1. 最高指令・優先順位` |
| 6 | **`## Appendix A: 逆引き索引`** | キーワード→セクション→関連ルールの逆引きテーブル | `| キーワード | セクション | 関連ルール |` |

**🇯🇵 判定基準**: 「このファイルを Universal の `000_engineering_standards.md` や `200_language_protocol.md` と並べたとき、構造的に違和感がないか？」→ 違和感があれば揃える。
**🇺🇸 Litmus Test**: "When placed alongside Universal files like `000_engineering_standards.md` or `200_language_protocol.md`, does this file look structurally consistent?" → If not, align it.

---

## Examples / 具体例

### Auto-Separation Example / 自動分離の具体例

**Before (core/010 に3件のDB教訓が蓄積):**

```
blueprint/ja/core/010_project_lessons_log.md:
  ### [2026-01-15] RLSポリシーの設計ミス
  Domain: DB・認証 | Target Folder: engineering/

  ### [2026-02-03] マイグレーション順序の依存関係
  Domain: DB・認証 | Target Folder: engineering/

  ### [2026-02-20] auth.uid()のパフォーマンス問題
  Domain: DB・認証 | Target Folder: engineering/

  ### [2026-01-20] APIキーの漏洩リスク
  Domain: セキュリティ | Target Folder: security/  ← 1件のみ、留置
```

**After (AIが自動実行):**

```
blueprint/ja/
├── core/
│   └── 010_project_lessons_log.md
│       ← インデックスのみ残留。DB教訓の行は参照リンクに置換済み。
│         セキュリティ教訓はまだ1件のためここに留置。
└── engineering/
    └── 300_database_auth.md  ← DB教訓3件が移動（新規自動作成）

※ security/ フォルダにはまだ教訓ファイルが生成されていない（セキュリティ教訓はまだ1件のため）

core/010 の「分離済みドメインファイル一覧」が更新：
  | DB・認証 | engineering/300_database_auth.md | 3件 |
```

> **なぜ `core/` に全部入れないのか**:
> DBの教訓は `engineering/` に、セキュリティの教訓は `security/` に Co-locate することで、
> AIがエンジニアリングタスクを実行する際に `engineering/` をロードすれば過去の教訓も自動的に参照できる。
> `core/` に全部集めると、毎回 `core/` をロードしないと教訓にアクセスできず、
> コンテキスト効率が著しく低下する。
