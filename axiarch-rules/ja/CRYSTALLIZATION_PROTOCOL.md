# Crystallization Protocol (教訓の結晶化プロトコル)

> [!IMPORTANT]
> このプロトコルは `AGENTS.md` §9「Continuous Improvement」の詳細手順書です。
> AIが教訓を記録する際に自律的に実行する必要があります。

---

## 📑 目次

1. [概要](#概要)
2. [自動結晶化ステップ](#自動結晶化ステップ)
3. [昇華ルールファイルテンプレート](#昇華ルールファイルテンプレート)
4. [構造要件](#構造要件)
5. [具体例](#具体例)

---

## 🚨 SUPREME RULE: 実務限定原則

> [!CAUTION]
> 結晶化の対象は **「実際のタスク実行中に遭遇した問題・判断・発見」のみ** に限定する。
> AIが **ユーザーの明示的な指示なしに** 独自にリサーチ・調査して「ベストプラクティス」を追加することは **厳禁** である。
> ユーザーが明示的に「調査して追加して」等の指示を出した場合のみ例外とする。

**記録してよいもの（✅）:**
- 実装中に遭遇したバグとその解決策
- 設計判断で迷った結果と選択理由
- 既存コードとの統合で発見した制約
- デプロイ・テスト中に判明した問題

**記録してはならないもの（❌ — ユーザーの明示的指示がない場合）:**
- AIが一般知識から生成した「推奨事項」
- 実際に問題が起きていない予防的ルール
- AI独断で外部ドキュメントを調査して追加したベストプラクティス
- 「こうすべき」という理想論（実際の痛みを伴っていないもの）

**判定基準:**
> 「この教訓は、今回のタスクで**実際に何が起きたか**を記述しているか？」→ Yes なら記録。No なら記録禁止。

---

## 概要

教訓を1ファイル（`core/010_project_lessons_log.md`）に無制限に蓄積すると、ファイルが膨大化しコンテキストウィンドウを圧迫する。
このプロトコルにより、教訓はドメインに対応した Blueprint フォルダへ自動分離・整理され、操縦者のスキルに依存せずに最適な構造が構築される。

**設計哲学: Co-location（共存）原則**
教訓はそれに関連するルールファイルと**同じフォルダ**に配置する。
AIがあるドメインフォルダ（例: `engineering/`）をロードするとき、そこにはルールだけでなく過去の教訓も存在するーコンテキスト効率が大幅に向上する。

---

## 自動結晶化ステップ

```
┌────────────────────────────────────────────────────────────────┐
│  Step 1: CLASSIFY (分類)                                       │
│  教訓のドメインを判定し、対応 Blueprint フォルダを特定          │
│  DB・認証 → engineering/ / セキュリティ → security/            │
│  QA・テスト → quality/ / デザイン → design/                    │
│  ... (Step 1 対応表を参照)                                     │
├────────────────────────────────────────────────────────────────┤
│  Step 2: DEDUP CHECK (Universal 重複チェック)                   │
│  同様のルールが universal/ に既に存在しないか確認              │
│  ├── 存在する → 記録不要。完了。                               │
│  └── 存在しない → Step 3 へ                                    │
├────────────────────────────────────────────────────────────────┤
│  Step 3: SEARCH (既存ファイル検索)                              │
│  Step 1 で特定した Blueprint フォルダ内に                      │
│  同ドメインの lessons ファイルが存在するか？                    │
│  ├── YES → そのファイルに追記。完了。                          │
│  └── NO  → Step 4 へ                                          │
├────────────────────────────────────────────────────────────────┤
│  Step 4: ACCUMULATE (一時蓄積)                                 │
│  core/010_project_lessons_log.md に追記                        │
│  ※ 必ず Domain / Target Folder タグを付ける                   │
├────────────────────────────────────────────────────────────────┤
│  Step 5: THRESHOLD CHECK (閾値チェック)                        │
│  core/010 内の同一ドメイン教訓が 3件以上 になったか？          │
│  ├── YES → 対応フォルダに {NNN}_{topic}.md 作成               │
│  │         core/010 には参照リンクのみ残す                     │
│  └── NO  → core/010 に留置                                    │
├────────────────────────────────────────────────────────────────┤
│  Step 6: UPDATE INDEX (インデックス更新)                       │
│  core/010 の「分離済みドメインファイル一覧」更新               │
└────────────────────────────────────────────────────────────────┘
```

---

### Step 1: CLASSIFY (分類)

教訓のドメインを判定し、対応 Blueprint フォルダを特定する。

**ドメイン → Blueprint フォルダ 対応表:**

| ドメイン | Blueprint フォルダ | 昇華後のファイル名例 |
|:----------------|:--------------|:----------------|
| DB・認証 | `engineering/` | `engineering/{NNN}_database_auth.md` |
| アーキテクチャ | `engineering/` | `engineering/{NNN}_architecture_rules.md` |
| API設計 | `engineering/` | `engineering/{NNN}_api_design.md` |
| パフォーマンス | `engineering/` | `engineering/{NNN}_performance_policy.md` |
| セキュリティ | `security/` | `security/{NNN}_security_policy.md` |
| 品質・QA | `quality/` | `quality/{NNN}_qa_rules.md` |
| FinOps | `operations/` | `operations/{NNN}_finops_policy.md` |
| デザイン | `design/` | `design/{NNN}_design_rules.md` |
| AI・コンテンツ | `ai/` | `ai/{NNN}_ai_content_rules.md` |
| ビジネス・グロース | `product/` | `product/{NNN}_business_policy.md` |
| 運用・インシデント | `operations/` | `operations/{NNN}_operations_rules.md` |
| コア・ガバナンス | `core/` | `core/{NNN}_governance_rules.md` （010はインデックス固定のため020以降） |

> **`{NNN}` の決定方法 (Contextual Numbering)**: 昇華時に対象フォルダ内の既存ファイルをAIが実際に確認し、内容が関連する既存ファイルの近接番号を自律判断して割り当てる（基本は拡張余地を残すため10刻みとするが、空きがない場合は `011` や `015` などの間の番号を使用する）。枯渇を防ぐため厳密な10刻みは強制しない。
> 昇華ファイル含むすべてのファイルで `000`〜`999` の任意の空き番号を使用可能です。ファイル名に **`lessons_` は不要**。内容を表すトピック名のみ使う。

> **フォルダの拡張性**: 上記8フォルダは初期構成として事前準備されているが、**閉じたリストではない**。上記の対応表にないドメインの教訓が蓄積された場合、AIは新しいフォルダの作成を**ユーザーに提案**してよい（独断での作成は禁止）。ただし、まず既存フォルダへの分類を優先すること。

---

### Step 2: DEDUP CHECK (Universal 重複チェック)

記録しようとしている教訓と同様のルールが `universal/` の対応ドメインフォルダに**既に存在しないか**確認する。Universalは「憲法」であり、そこに既にカバーされている内容をBlueprintに重複記載する必要はない。

**判定基準:**
- Universalに同趣旨のルールが存在 → **記録不要**（重複回避）。完了。
- Universalに存在しない、またはプロジェクト固有の文脈が必要 → **Step 3 へ進む**

---

### Step 3: SEARCH (既存ファイル検索)

Step 1 で特定した **Blueprint フォルダ内** に同ドメインのルールファイル（`{NNN}_{topic}.md`）が既に存在する場合、そのファイルに追記する。

**検索例:**
- DB関連教訓 → `blueprint/engineering/` 内を検索
- セキュリティ教訓 → `blueprint/security/` 内を検索
- デザイン教訓 → `blueprint/design/` 内を検索
- ガバナンス教訓 → `blueprint/core/` 内を検索（`core/010_project_lessons_log.md` は対象外）

---

### Step 4: ACCUMULATE (一時蓄積)

該当ドメインの教訓ファイルが存在しない場合、`core/010_project_lessons_log.md` に一旦追記する（蓄積が閾値に達するまでの一時置き場）。

**必須フォーマット:**

```markdown
### [YYYY-MM-DD] 教訓のタイトル
**Domain:** {domain}
**Target Folder:** blueprint/{folder}/  ← 行き先フォルダを明記
**Context:** 問題が発生した状況
**Problem:** 具体的な問題点
**Solution/Rule:** 解決策または制定したルール
**Reference:** 関連ファイルやコミット
```

---

### Step 5: THRESHOLD CHECK (閾値チェック)

`core/010_project_lessons_log.md`（中央インデックス）内の同一ドメインの教訓が **3件以上** に達した場合、AIは自律的に Step 1 の対応表に従い **対応 Blueprint フォルダ**内に正式ルールファイルを作成し、教訓を昇華・移動する。

> [!CAUTION]
> **🚨 「追記 = 完了」は誤認 — タスク完了前に必ず Step 5 を実行せよ**
>
> 過去の実装で「`core/010` に追記したから結晶化完了」と誤認し、3件以上溜まったドメインを Blueprint へ昇華せず放置するケースが頻発した。**Step 4 (ACCUMULATE) は完了ではない**。AIは応答を返す前、毎タスク完了の最後に Step 5 (THRESHOLD CHECK) を必ず実行し、**3件以上のドメインがあれば Blueprint 専用ファイルへの昇華まで完了させてから** タスク完了を宣言すること。
>
> 違反検出は `bash scripts/check-axiarch-health.sh` の Check 6 で外部から検証可能。3件超ドメインが存在する状態でタスク完了を宣言した場合は **プロトコル違反** とみなす。

> [!CAUTION]
> **新規ドメインフォルダの独断作成禁止**: Blueprint の各ドメインフォルダ（`ai/`, `design/`, `engineering/`, `operations/`, `product/`, `quality/`, `security/`）は、Universal と同型の構造で**事前に配置済み**（各フォルダに `README.md` が存在）。AIが**独断で**新しいドメインフォルダを作成することは**禁止**する。教訓の配置先は、Step 1 の対応表に定義された既存フォルダのみとする。ただし、既存フォルダに分類できない全く新しいドメインが発生した場合は、**ユーザーに新規フォルダの作成を提案**してよい（Step 1「フォルダの拡張性」参照）。

**採番ルール:**
- **🚨 空白地帯禁止**: 各ドメイン内で `000`〜`999` を独立して使用する（特定ドメイン専用の予約帯域は存在しない）。
- **文脈的採番**: 昇華時に対象フォルダの既存ファイルを実際に確認し、関連トピックの近接番号を割り当てる。基本は10刻みで拡張余地を残すが、空きがない場合は間の番号（例: `011`, `015`）を使用する。厳密な10刻み強制による999枯渇を回避せよ。
- `core/010_project_lessons_log.md`（中央インデックス）は固定。`core/` 内の昇華ルールファイルは `020_` 以降を使用。
- ファイル名に **`lessons_` は不要**。内容を表すトピック名のみ使う（例: `database_auth`, `security_policy`, `api_design`）。

**作成例:**
```
# 3件のDB教訓が core/010 に溜まった場合:
作成ファイル: blueprint/engineering/010_database_auth.md  (教訓を正式ルールに昇華)
core/010 には参照リンクのみ残す:
  "→ engineering/010_database_auth.md に昇華済み"
```

> **注記**: Blueprint の採番は **Blueprint フォルダ内で独立**しており、Universal フォルダの番号とは無関係です。

---

### Step 6: UPDATE INDEX (インデックス更新)

`core/010_project_lessons_log.md` の「分離済みドメインファイル一覧」表を更新する。

---

## 昇華ルールファイルテンプレート

> [!IMPORTANT]
> AIが新規ドメインファイルを作成する際、**以下のテンプレートに厳格に従うこと**。
> `universal/` のルールファイルと同等の構造的一貫性を維持し、AIが探索・参照しやすい構造にする。

```markdown
# {NNN}. {Topic Name}

> [!NOTE]
> このファイルは Blueprint Rule（プロジェクト固有ルール）です。
> `core/010_project_lessons_log.md` から自動結晶化されました。
> Created: {YYYY-MM-DD}

> [!IMPORTANT]
> **Domain**: {domain}
> **Location**: `blueprint/{folder}/{NNN}_{topic}.md`
> **Related Universal Rules**: `universal/{domain}/{rule_file_1}.md`, `universal/{domain}/{rule_file_2}.md`
> **{N} sections.**

---

## 📳 目次

| セクション | 内容 | セクション数 |
|:---------|:-----|:--:|
| 教訓 | 結晶化されたルール・教訓 | {N} |
| Appendix A | 逆引き索引 & クロスリファレンス | 1 |

---

## 教訓

### [YYYY-MM-DD] Lesson Title
**Domain:** {domain}
**Context:** ...
**Problem:** ...
**Solution/Rule:** ...
**Reference:** ...

---

## Appendix A: 逆引き索引 & クロスリファレンス

### 逆引き索引（Keyword → Section）

| Keyword | Section | Related Rule |
|:---------|:------------|:---------|
| {keyword_1} | 教訓 — {lesson_title} | `{universal_folder}/{rule_file}.md` |

### クロスリファレンス

| Related File | Relationship |
|:-----------|:-----|
| `{universal_folder}/{rule_file}.md` | Governing Rule (Universal) |
| `core/010_project_lessons_log.md` | Index (crystallization origin) |
```

---

## 構造要件

> [!CAUTION]
> ドメインファイル作成時、以下の構造要件を**必ず**満たすこと。

### 1. ヘッダーメタデータ

| 必須項目 | 説明 |
|:-------------------|:-------------------|
| `Domain` | ドメイン名（Step 1のカテゴリに一致） |
| `Location` | 実際のファイルパス（`blueprint/{folder}/{NNN}_{topic}.md`） |
| `Created` | 作成日 + 「Auto-Crystallized from core/010」の記載 |
| `Related Universal Rules` | 関連するUniversalルールファイル名（フォルダパス含む） |

### 2. 相互参照テーブル

- ファイル末尾に必ず相互参照テーブルを配置すること
- `core/010` へのリンクを必ず含めること
- 関連する Universal ルールへのリンクを含めること

### 3. Universalルールとの構造的一貫性

- `## 目次` セクション（テーブル形式 or リスト形式）を必ず含めること
- セクション見出しは `##` レベルで統一すること
- 各教訓は `###` レベルで記述すること

### 4. 構造的同型性（Appendix A 義務）

> [!IMPORTANT]
> ルール反映時（昇華・新規作成・追記問わず）、作成・変更するファイルが他の憲法ファイル（Universal / Blueprint）と**同じ構造パターン**を持つことを確認し、欠落があれば補完すること。

**Universal ファイルの標準構造パターン（実例から抽出）:**

| # | 必須構造要素 | 説明 | Universal 実例 |
|:--|:-----------|:-----|:--------------|
| 1 | **タイトル行** `# {NNN}. {名称}` | ファイル冒頭のH1見出し。番号 + 名称 | `# 74. 言語プロトコル`, `# 30. エンジニアリング基準`, `# 60. セキュリティとプライバシー` |
| 2 | **CAUTION/NOTE ブロック** | ファイルの位置づけ宣言（Universal=CAUTION, Blueprint=NOTE/TIP） | `> [!CAUTION] このファイルは Universal Rule（不変ルール）です。` |
| 3 | **IMPORTANT ブロック** | Supreme Directive + 構成サマリ（`{N}パート・{M}セクション構成。`） | `> [!IMPORTANT] Supreme Directive（最高指令）...13パート・80セクション構成。` |
| 4 | **`## 目次`** | テーブル形式（Part/セクション/行数）またはリスト形式の目次 | `## 目次` + `| Part | トピック | セクション | セクション数 |` |
| 5 | **本文セクション** `## Part {N}:` or `## §{N}.` | `##` で主要セクション、`###` でサブセクション | `## Part I: コード品質とクリーンコード`, `## §1. 最高指令・優先順位` |
| 6 | **`## Appendix A: 逆引き索引`** | キーワード→セクション→関連ルールの逆引きテーブル | `| キーワード | セクション | 関連ルール |` |

**判定基準**: 「このファイルを Universal の `000_engineering_standards.md` や `200_language_protocol.md` と並べたとき、構造的に違和感がないか？」→ 違和感があれば揃える。

---

## 具体例

### 自動分離の具体例

**Before (core/010 に3件のDB教訓が蓄積):**

```
blueprint/core/010_project_lessons_log.md:
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
blueprint/
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
