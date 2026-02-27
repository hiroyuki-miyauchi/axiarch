# Antigravity Rules — Pointer / 目次

> [!CAUTION]
> 🇯🇵 **このファイルは「目次（ポインター）」であり、ルール本体ではない。**
> ルールの本体は `antigravity-rules/` に存在する。ルールの更新・追加は**必ず `antigravity-rules/` 内で行うこと**。
> **`.agent/rules/` に新しいルールファイルを作成してはならない。**

> [!CAUTION]
> 🇺🇸 **This file is a POINTER (table of contents), NOT the rules themselves.**
> All rule definitions live in `antigravity-rules/`. When updating or adding rules, **always edit files inside `antigravity-rules/`**.
> **DO NOT create new rule files in `.agent/rules/`.**

---

## 🇯🇵 日本語セクション

### 🔴 作業開始前の必須読み込み手順

**すべてのタスクを開始する前に、以下の順序でファイルを読み込み、内容を遵守せよ。**

#### Step 1: 最上位憲法 & 全体地図の把握（必ず最初に読む）
- **`GEMINI.md`**（プロジェクトルート）
  - Antigravity System Protocol の最高法規。全ルールに優先する。
- **`antigravity-rules/INDEX.md`** — 全ルールの詳細索引
  - 全ルールファイルの概要を把握し、以降のStepで**どのファイルを読むべきか判断する地図**として使用する。

#### Step 2: 必須ルール（どんなタスクでも毎回必ず読む）

> [!IMPORTANT]
> 以下の **9ファイル** はタスクの種類に関わらず**毎回必ず読み込むこと。**
> これらは全タスクに横断的に適用される最重要ルールである。

**Universal Rules（不変・憲法）:**
- **`antigravity-rules/universal/{lang}/00_core_mindset.md`** — 全ルールの基盤・最上位行動原則
- **`antigravity-rules/universal/{lang}/10_product_business.md`** — ビジネスコンテキスト・収益化判断基盤
- **`antigravity-rules/universal/{lang}/12_growth_marketing.md`** — SEO/GEO/OGP（構造化データ＋メタタグの一体システム）
- **`antigravity-rules/universal/{lang}/20_design_ux.md`** — モバイルファースト・アクセシビリティ・UX横断基準
- **`antigravity-rules/universal/{lang}/30_engineering_general.md`** — コーディング規約・品質基準・CI/CD
- **`antigravity-rules/universal/{lang}/35_api_integration.md`** — API設計（フロントエンド設計と不可分）・エラーハンドリング
- **`antigravity-rules/universal/{lang}/60_security_privacy.md`** — セキュリティ・プライバシー（横断的関心事）
- **`antigravity-rules/universal/{lang}/61_legal_data_privacy.md`** — 個人情報保護・GDPR/APPI（セキュリティと対の横断的義務）
- **`antigravity-rules/universal/{lang}/70_qa_testing.md`** — テスト戦略・回帰防止方針

**Blueprint Rules（可変・プロジェクト固有）:**
- **`antigravity-rules/blueprint/{lang}/01_project_lessons_log.md`** — プロジェクト教訓ログ（最優先適用）

> ※ `{lang}` は `GEMINI.md` の `Project Native Language` に従い `ja/` または `en/` に置換する。

#### Step 3: 自律的ロード（AIが自律判断で読み込む）

> [!IMPORTANT]
> Step 2 で読んだファイル以外にも、**現在のタスクとプロジェクトの技術スタックに基づき、AIが自律的に追加ファイルを選択・読み込むこと。**
> 「読む必要がない」と判断した場合でも、その判断を `task.md` に記録する義務がある。

##### 3-A: プロジェクト技術スタックの自律把握

1. **Blueprint `00_project_overview.md`** を読む（技術スタック・ビジョン・プロジェクト構成を把握）
2. **Blueprint `{lang}/INDEX.md`** を読む（プロジェクト固有ルールの全体像を把握）
3. `00_project_overview.md` の技術スタック情報に基づき、**対応するUniversalファイルを自律的に選択・読み込む**
   - 例：Next.js記載あり → `33_web_frontend.md` を読む
   - 例：Supabase記載あり → `37_backend_supabase.md` を読む
   - 例：Flutter記載あり → `31_mobile_flutter.md` を読む
   - 例：Firebase記載あり → `32_backend_firebase.md` を読む
4. **Blueprint INDEX の情報に基づき、タスクに関連するBlueprintファイルを自律的に選択・読み込む**
   - Blueprint側もUniversal同様に「全体像把握→自律選択」の流れで行う
   - `01_project_lessons_log.md` はStep 2で読み込み済みのため除外

##### 3-B: タスク分類による自律選択

**AIは現在のタスクの内容を分析し、以下のカテゴリに該当するファイルを自律的に選択して読み込む：**

| タスクカテゴリ | 対応Universal | 対応Blueprint |
|---|---|---|
| 決済・課金・コスト管理 | `11_business_finance` | 関連仕様書 |
| アプリストア申請 | `13_store_compliance` | — |
| CMS・コンテンツ管理 | `34_cms_headless` | 関連仕様書 |
| ネイティブ開発（Swift/Kotlin） | `36_native_platforms` | 関連仕様書 |
| AI機能・RAG・ガードレール | `40_ai_implementation` | 関連仕様書 |
| 分析・カスタムイベント | `41_analytics_intelligence` | 関連仕様書 |
| 管理画面・内部ツール | `50_admin_tools` | 関連仕様書 |
| ユーザーサポート・FAQ | `51_user_support` | 関連仕様書 |
| SRE・パフォーマンス・可用性 | `52_sre_reliability` | 関連仕様書 |
| インシデント対応・BCP | `53_crisis_management` | — |
| 依存関係追加・ライセンス | `62_license_dependency` | — |
| IP・デューデリジェンス | `63_ip_due_diligence` | — |
| 国際化・i18n | `71_global_expansion` | 関連仕様書 |
| ガバナンス・ルール改正 | `72_constitution_authority` | — |
| 言語プロトコル確認 | `74_language_protocol` | — |
| **全体監査・ディープスキャン** | **残りの全ファイル** | **全ファイル** |

##### 3-C: 記録義務

> [!IMPORTANT]
> **自律ロードの透明性を保証するため、以下を `task.md` に必ず記録すること。**

- **3-Aで読み込んだファイル名**（技術スタック由来）
- **3-Bで読み込んだファイル名**（タスク分類由来）
- 該当なしの場合は **「Step 3: 追加読み込みなし（理由: ○○）」** と明記
- クロスリファレンスで追加読み込みしたファイルも記録

> [!TIP]
> **クロスリファレンスに従うこと。** 読み込んだファイル内に「関連ルール」「参照」等のリンクがあれば、そのリンク先も追加で読み込むこと。これにより、見落としを防ぐ。

#### Step 4: ルートレベルの参照ファイル（必要時のみ）

> 以下のファイルは `antigravity-rules/` **直下**に配置されている。必要に応じて参照する。

- **`antigravity-rules/README.md`** — マスター目次（ナビゲーション用）
- **`antigravity-rules/compliance_matrix.md`** — 要件対照表（Universal/Blueprintの責務分離確認用）

### 🚫 禁止事項

1. **`.agent/rules/` に新しいルールファイルを作成禁止。** ルールは全て `antigravity-rules/` に配置する。
2. **Universal Rules を無断で編集禁止。** 「憲法改正」の明示的指示がある場合のみ許可。
3. **この `prompt_pointer.md` のポインター構造を変更禁止。**

---

## 🇺🇸 English Section

### 🔴 Mandatory Loading Order Before Any Task

**Before starting any task, load the following files in order and comply with their contents.**

#### Step 1: Supreme Constitution & Master Map (Always Read First)
- **`GEMINI.md`** (project root)
  - The supreme law of the Antigravity System Protocol. Takes precedence over all other rules.
- **`antigravity-rules/INDEX.md`** — Detailed index of all rules
  - Understand the overview of all rule files and use this as a **map to decide which files to read** in the following steps.

#### Step 2: Mandatory Rules (Always Read Regardless of Task)

> [!IMPORTANT]
> The following **9 files** MUST be read **every time, regardless of task type.**
> These are the most critical rules that apply across all tasks.

**Universal Rules (Immutable / Constitution):**
- **`antigravity-rules/universal/{lang}/00_core_mindset.md`** — Foundation of all rules, supreme behavioral principles
- **`antigravity-rules/universal/{lang}/10_product_business.md`** — Business context, monetization decision foundation
- **`antigravity-rules/universal/{lang}/12_growth_marketing.md`** — SEO/GEO/OGP (unified system of structured data + meta tags)
- **`antigravity-rules/universal/{lang}/20_design_ux.md`** — Mobile-first, accessibility, UX cross-cutting standards
- **`antigravity-rules/universal/{lang}/30_engineering_general.md`** — Coding standards, quality benchmarks, CI/CD
- **`antigravity-rules/universal/{lang}/35_api_integration.md`** — API design (inseparable from frontend design), error handling
- **`antigravity-rules/universal/{lang}/60_security_privacy.md`** — Security & Privacy (cross-cutting concern)
- **`antigravity-rules/universal/{lang}/61_legal_data_privacy.md`** — PII protection, GDPR/APPI (cross-cutting obligation paired with security)
- **`antigravity-rules/universal/{lang}/70_qa_testing.md`** — Testing strategy, regression prevention

**Blueprint Rules (Mutable / Project-Specific):**
- **`antigravity-rules/blueprint/{lang}/01_project_lessons_log.md`** — Project lessons log (highest priority)

> Note: Replace `{lang}` with `ja/` or `en/` based on the `Project Native Language` setting in `GEMINI.md`.

#### Step 3: Autonomous Loading (AI Self-Determines What to Read)

> [!IMPORTANT]
> Beyond Step 2, the AI MUST **autonomously select and load additional files based on the current task and the project's technology stack.**
> Even when the AI decides no additional loading is needed, this decision MUST be recorded in `task.md`.

##### 3-A: Autonomous Project Tech Stack Detection

1. Read **Blueprint `00_project_overview.md`** (understand tech stack, vision, project structure)
2. Read **Blueprint `{lang}/INDEX.md`** (understand full picture of project-specific rules)
3. Based on tech stack information in `00_project_overview.md`, **autonomously select and load corresponding Universal files**
   - Example: Next.js listed → read `33_web_frontend.md`
   - Example: Supabase listed → read `37_backend_supabase.md`
   - Example: Flutter listed → read `31_mobile_flutter.md`
   - Example: Firebase listed → read `32_backend_firebase.md`
4. **Based on Blueprint INDEX information, autonomously select and load task-relevant Blueprint files**
   - Follow the same "understand full picture → autonomous selection" flow as Universal
   - Exclude `01_project_lessons_log.md` (already read in Step 2)

##### 3-B: Task Classification-Based Autonomous Selection

**The AI analyzes the current task content and autonomously selects files from the following categories:**

| Task Category | Corresponding Universal | Corresponding Blueprint |
|---|---|---|
| Payments, billing, cost management | `11_business_finance` | Related specs |
| App store submission | `13_store_compliance` | — |
| CMS, content management | `34_cms_headless` | Related specs |
| Native development (Swift/Kotlin) | `36_native_platforms` | Related specs |
| AI features, RAG, guardrails | `40_ai_implementation` | Related specs |
| Analytics, custom events | `41_analytics_intelligence` | Related specs |
| Admin dashboard, internal tools | `50_admin_tools` | Related specs |
| User support, FAQ | `51_user_support` | Related specs |
| SRE, performance, availability | `52_sre_reliability` | Related specs |
| Incident response, BCP | `53_crisis_management` | — |
| Dependency addition, licensing | `62_license_dependency` | — |
| IP, due diligence | `63_ip_due_diligence` | — |
| Internationalization, i18n | `71_global_expansion` | Related specs |
| Governance, rule amendments | `72_constitution_authority` | — |
| Language protocol verification | `74_language_protocol` | — |
| **Full audit / deep scan** | **All remaining files** | **All files** |

##### 3-C: Recording Obligation

> [!IMPORTANT]
> **To ensure transparency of autonomous loading, the following MUST be recorded in `task.md`.**

- **File names loaded in 3-A** (tech stack derived)
- **File names loaded in 3-B** (task classification derived)
- If none applicable, explicitly state **"Step 3: No additional loading (Reason: ○○)"**
- Also record any files loaded via cross-references

> [!TIP]
> **Follow cross-references.** If a loaded file contains links labeled "Related Rules", "See Also", etc., load those linked files as well. This prevents oversight.

#### Step 4: Root-Level Reference Files (As Needed)

> The following files are located **directly under** `antigravity-rules/`. Refer to them as needed.

- **`antigravity-rules/README.md`** — Master index (for navigation)
- **`antigravity-rules/compliance_matrix.md`** — Compliance matrix (for Universal/Blueprint responsibility verification)

### 🚫 Prohibited Actions

1. **DO NOT create new rule files in `.agent/rules/`.** All rules belong in `antigravity-rules/`.
2. **DO NOT edit Universal Rules without explicit "Amend Constitution" instruction.**
3. **DO NOT alter the pointer structure of this `prompt_pointer.md`.**
