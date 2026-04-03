# LOADING_PROTOCOL.md — ルールロード手順書 / Rule Loading Protocol

> **このファイルはルールロードの詳細手順を定義する。AGENTS.md §7 から参照される。**
> **This file defines the detailed rule loading procedure. Referenced from AGENTS.md §7.**

---

## 🚨 初動プロトコル（BOOT SEQUENCE PROTOCOL）🚨

会話の開始時（新規チャット、またはコンテキストリセット後）は、**必ず以下の3原則に従い、ルールの実際のロードが完了するまで作業を開始してはならない。**

> At the start of a conversation (new chat or after context reset), **you MUST follow these 3 principles and NOT begin any work until rules have been actually loaded.**

1. **Stop & Wait**: いきなり修正や監査を始めないこと。ルールを先に読み込み、理解してから行動する。
   - Do NOT immediately start modifications or audits. Read and understand the rules first, then act.

2. **No Hallucination（幻覚の禁止）**: ユーザーから明確なコードやファイル構成が提示される**前に**、推測で勝手に「ロード済みルール一覧」「プロジェクト構成」「技術スタック概要」などを生成して出力することを**固く禁ずる**。実際にファイルを読み込む前のいかなる「事前知識の提示」もハルシネーション（幻覚）と見なす。
   - Before the user provides clear code or file structure, it is **strictly prohibited** to speculatively generate and output "loaded rules list," "project structure," "tech stack overview," or any similar fabricated content.

3. **Exact Match Only**: 余計なテキストや独自の解釈は一切追加せず、実際にツールで読み込んだ内容「のみ」を根拠として用いること。
   - Do NOT add extraneous text or independent interpretation. Use ONLY content actually read via tools as the basis for your actions.

---

## Step 1: タスク分類 / Task Classification

ユーザーの指示を読み、以下のタスクタイプに分類せよ。複数該当する場合は全て選択する。

> Read the user's instruction and classify it into the following task types. Select all that apply.

| タスクタイプ / Task Type | 判定基準 (JA) | Criteria (EN) |
|:----------------------|:------------|:-------------|
| `security` | セキュリティ、認証、認可、RLS、暗号化、脆弱性、監査 | Security, authentication, authorization, RLS, encryption, vulnerability, audit |
| `architecture` | 設計、アーキテクチャ、DB設計、マイグレーション、インフラ | Design, architecture, DB design, migration, infrastructure |
| `performance` | パフォーマンス、最適化、SRE、モニタリング、キャッシュ | Performance, optimization, SRE, monitoring, caching |
| `ui_design` | UI、UX、デザインシステム、レイアウト、アクセシビリティ | UI, UX, design system, layout, accessibility |
| `api` | API設計、エンドポイント、スキーマ、バリデーション | API design, endpoints, schema, validation |
| `i18n` | 国際化、ローカライゼーション、翻訳 | Internationalization, localization, translation |
| `finops` | コスト最適化、課金、FinOps | Cost optimization, billing, FinOps |
| `testing` | テスト、品質保証、E2E、ユニットテスト | Testing, QA, E2E, unit tests |
| `other` | 上記に該当しない一般的なタスク | General tasks not matching the above |

---

## Step 2: INDEX起点のファイル特定 / INDEX-Based File Identification

`rampart-rules/INDEX.md` を読み、ルール全体の構成を把握する。

> Read `rampart-rules/INDEX.md` to understand the overall rule structure.

### 階級別スキャンとロード / Class-Based Scan & Load

| 階級 / Class | 対象 / Target | 性質 (JA) | Nature (EN) |
|:------------|:-------------|:---------|:-----------|
| **Class S（Universal）** | `rampart-rules/universal/{lang}/` | プロジェクトを超えた普遍的ルール。Read-Only。 | Universal rules transcending projects. Read-Only. |
| **Class A（Blueprint）** | `rampart-rules/blueprint/{lang}/` | プロジェクト固有の仕様・設計・教訓。更新可能。教訓ログは優先度が高い。 | Project-specific specs, design, and lessons. Mutable. Lessons Log has high priority. |

Step 1で特定したタスクタイプに対応するINDEX.mdのカテゴリから、ロードすべきファイルを列挙せよ。

> From the INDEX.md categories that correspond to the task types identified in Step 1, list the files to load.

### タスクタイプ → INDEX.mdカテゴリ 対応表 / Task-Type to Category Mapping

| タスクタイプ / Task Type | INDEX.mdカテゴリ / INDEX.md Category |
|:----------------------|:-----------------------------------|
| `security` | Security & Privacy |
| `architecture` | Engineering Standards / Architecture |
| `performance` | Engineering Standards / SRE & Reliability |
| `ui_design` | Design & UX |
| `api` | Engineering Standards / API |
| `i18n` | Internationalization |
| `finops` | Cloud & FinOps |
| `testing` | Engineering Standards / Testing |
| `other` | Blueprint内のプロジェクト概要とBlueprint INDEXから自律選択 / Autonomously select from project overview and Blueprint INDEX |

---

## Step 3: ファイル読み込み / File Loading

**Step 2で特定した各ファイルを直接開き**、ファイル冒頭の目次またはファイル末尾のAppendix（逆引き索引）からタスクに関連するセクションを自律選択してロードすること。

> **Directly open each file identified in Step 2**, and autonomously select task-relevant sections from the file's table of contents or Appendix (reverse lookup index).

### 🚨【厳守命令】手抜き（サボり）禁止 / Anti-Laziness Mandate 🚨

- INDEX.mdの要約や概要だけで「読んだ」と見なすことは**禁止**する。
- 「ファイルを直接開く」とは、`view_file`ツール等でファイルの内容を実際に取得することを意味する。
- 上記は自律ロード・ユーザー指示によるロードを問わず、**全てのルールファイル参照時に適用**される。

> - Considering a file "read" based solely on INDEX.md summaries is **prohibited**.
> - "Directly open the file" means actually retrieving the file's content using tools like `view_file`.
> - The above applies to **all rule file references**, regardless of whether loading is autonomous or user-directed.

### 大規模ファイル対応 / Large File Handling

1,000行以上の大規模ルールファイルは、ファイル末尾のAppendix（逆引き索引）またはファイル冒頭の目次を先に参照し、タスクに関連するセクションのみを行番号指定で自律選択してロードすること。

> For large rule files exceeding 1,000 lines, first reference the Appendix or table of contents, then autonomously select and load only the task-relevant sections using line number ranges.

例 / Examples：
- 認証関連タスク → 対象ファイルの目次/索引から「OAuth」「JWT」「MFA」のセクションを特定 → 該当セクションのみロード
  - Authentication task → identify "OAuth" "JWT" "MFA" sections from TOC/index → load only those sections
- コスト最適化タスク → 索引から「FinOps」「料金」のセクションを特定 → 2〜3セクションのみロード
  - Cost optimization task → identify "FinOps" "Pricing" sections from index → load only 2–3 sections

### クロスリファレンス / Cross-References

読み込んだファイル内に関連ルールへのリンクがあり、現在のタスクに関連する場合は、そのリンク先も追加で読むこと。

> If a loaded file references related rules and they are relevant to the current task, load those as well.

---

## Step 4: 自己検証（省略不可）/ Post-Load Verification (MANDATORY)

**ルールロード完了後、以下の自己検証チェックリストをtask.mdに記録せよ。1つでも「該当するのにロードしていない」項目があれば、作業を中断して追加ロードせよ。**

> **After completing rule loading, record the following self-verification checklist in task.md. If any item is applicable but not loaded, STOP work and load the missing files.**

```markdown
## ロード自己検証 / Load Self-Verification

- タスク / Task: [1行で記述 / Describe in one line]
- タスクタイプ / Task Type: [security / architecture / performance / ui_design / api / i18n / finops / testing / other]
- ロードしたファイル / Loaded Files:
  - [ ] [ファイルパス / File path] — ロードしたセクション / Loaded sections: [§XX, §YY]
  - [ ] [ファイルパス / File path] — ロードしたセクション / Loaded sections: [§XX]
- ロードしなかったが関連しうるファイル / Relevant but not loaded: [ある場合はファイル名と理由 / File name and reason if any]
```

---

## Step 5: 作業開始 / Begin Work

**上記Step 1–4が完了するまで、コードの修正や分析を開始してはならない。**

> **Do NOT begin any code modifications or analysis until Steps 1–4 are complete.**

---

## ✅ 正しいロード行動の例 / Correct Loading Behavior Examples

### 例1 / Example 1: セキュリティ強化タスク / Security Hardening Task

⬇️ ユーザー指示 / User instruction: 「RLSポリシーを見直して」 / "Review the RLS policies"

1. **タスク分類 / Task Classification**: `security` + `architecture`
2. **INDEX.md読み込み / Read INDEX.md** → Security & Privacy カテゴリ + Architecture カテゴリを特定 / Identify Security & Privacy + Architecture categories
3. **セキュリティルールファイルを直接開く / Directly open security rule file** → 目次から §12 (RLS) と §24 (DBセキュリティ) を特定 → ロード / Identify §12 (RLS) and §24 (DB Security) from TOC → Load
4. **アーキテクチャルールファイルを直接開く / Directly open architecture rule file** → RLS関連セクションをロード / Load RLS-related sections
5. **task.md にロード自己検証を記録 / Record load self-verification in task.md**
6. **作業開始 / Begin work**

### 例2 / Example 2: UI改善タスク / UI Improvement Task

⬇️ ユーザー指示 / User instruction: 「ダッシュボードのレイアウトを修正して」 / "Fix the dashboard layout"

1. **タスク分類 / Task Classification**: `ui_design`
2. **INDEX.md読み込み / Read INDEX.md** → Design & UX カテゴリを特定 / Identify Design & UX category
3. **デザインルールファイルを直接開く / Directly open design rule file** → 目次からレイアウト/レスポンシブ関連セクションをロード / Load layout/responsive sections from TOC
4. **Blueprint読み込み / Read Blueprint** → プロジェクトのデザインシステム定義をロード / Load project design system definitions
5. **task.md にロード自己検証を記録 / Record load self-verification in task.md**
6. **作業開始 / Begin work**

### ❌ 間違った行動の例 / Incorrect Behavior Examples

```
1. INDEX.md を読む / Read INDEX.md → 「セキュリティ系ファイルがあるな」 / "There are security files"
2. 教訓ログを読む / Read lessons log
3. 「把握しました。RLSポリシーを確認します」 / "Understood. I'll check the RLS policies."
   ← ⚠️ セキュリティルールファイルを開いていない！ / Security rule file was NOT opened!
4. 自分の知識だけで修正を開始 / Begin modifications using only own knowledge
   ← ❌ サボり確定。Step 3–4を完全にスキップしている。 / Laziness confirmed. Steps 3–4 completely skipped.
```
