# Axiarch Development Rules (Master Index)

> [!IMPORTANT]
> **Axiarchの憲法 / Constitution of Axiarch**
> 本フォルダ（`axiarch-rules/`）に含まれる全てのルールは、Axiarch（アクシアーク）フレームワークにおける絶対的な憲法であり、**個別プロジェクト開発時に編集してはならない**。
> All rules contained in this folder (`axiarch-rules/`) are the absolute constitution of the Axiarch framework and **MUST NOT be edited during specific project development**.
>
> **Separation of Concerns (AI Agent Instructions)**:
>
> ### 🇯🇵 日本語指示 (Japanese Instructions)
> *   **Universal Rules (`universal/`)**:
>     *   **Status**: **Immutable (不変)** / プロジェクト作業では読み取り専用。
>     *   **Action**: 明示的に「憲法改正」を指示されない限り、AIはこれらのファイルを編集してはならない。
> *   **Blueprint Rules (`blueprint/`)**:
>     *   **Status**: **Mutable (可変)** / プロジェクト固有。
>     *   **Action**: AIはプロジェクトのコンテキストを定義するために、これらのファイルを作成・編集すべきである。
>
> ### 🇺🇸 English Instructions
> *   **Universal Rules (`universal/`)**:
>     *   **Status**: **Immutable (不変)** / Read-Only for Project Tasks.
>     *   **Action**: AI MUST NOT edit these files unless explicitly instructed to "Amend Constitution".
> *   **Blueprint Rules (`blueprint/`)**:
>     *   **Status**: **Mutable (可変)** / Project Specific.
>     *   **Action**: AI SHOULD create and edit these files to define project context.

> **言語基準 / Language Standard**:
> 全てのルールは**日本語と英語**で提供される（Bilingual Documentation）。
> All rules are provided in **Japanese and English** to ensure global scalability and perfect communication.

## 📂 Rule Modules

### 📚 Universal Rules (Bilingual)

#### 000: Core & Mindset
*   **000. Core Philosophy & Mindset** ([🇯🇵](./universal/ja/core/000_core_mindset.md) / [🇺🇸](./universal/en/core/000_core_mindset.md))

#### 100–199: Business & Growth
*   **100. Product & Business Strategy** ([🇯🇵](./universal/ja/product/000_product_strategy.md) / [🇺🇸](./universal/en/product/000_product_strategy.md))
*   **101. Revenue & Monetization** ([🇯🇵](./universal/ja/product/300_revenue_monetization.md) / [🇺🇸](./universal/en/product/300_revenue_monetization.md))
*   **102. Growth & Marketing** ([🇯🇵](./universal/ja/product/500_growth_marketing.md) / [🇺🇸](./universal/en/product/500_growth_marketing.md))
*   **103. App Store Compliance & ASO** ([🇯🇵](./universal/ja/product/700_appstore_compliance.md) / [🇺🇸](./universal/en/product/700_appstore_compliance.md))
*   **110. Market Validation & PMF** ([🇯🇵](./universal/ja/product/100_market_validation.md) / [🇺🇸](./universal/en/product/100_market_validation.md))
*   **120. Go-to-Market Strategy** ([🇯🇵](./universal/ja/product/200_go_to_market.md) / [🇺🇸](./universal/en/product/200_go_to_market.md))
*   **130. Pricing Strategy** ([🇯🇵](./universal/ja/product/400_pricing_strategy.md) / [🇺🇸](./universal/en/product/400_pricing_strategy.md))
*   **140. Brand Strategy** ([🇯🇵](./universal/ja/product/600_brand_strategy.md) / [🇺🇸](./universal/en/product/600_brand_strategy.md))
*   **150. Fundraising & IR** ([🇯🇵](./universal/ja/product/900_fundraising_ir.md) / [🇺🇸](./universal/en/product/900_fundraising_ir.md))

#### 200: Design & UX
*   **200. Design & UX Strategy** ([🇯🇵](./universal/ja/design/000_design_ux.md) / [🇺🇸](./universal/en/design/000_design_ux.md))

#### 300–399: Engineering Core
*   **300. Engineering Standards** ([🇯🇵](./universal/ja/engineering/000_engineering_standards.md) / [🇺🇸](./universal/en/engineering/000_engineering_standards.md))
*   **301. API Integration** ([🇯🇵](./universal/ja/engineering/100_api_integration.md) / [🇺🇸](./universal/en/engineering/100_api_integration.md))
*   **320. Supabase & PostgreSQL** ([🇯🇵](./universal/ja/engineering/200_supabase_architecture.md) / [🇺🇸](./universal/en/engineering/200_supabase_architecture.md))
*   **340. Web Frontend (Next.js)** ([🇯🇵](./universal/ja/engineering/300_web_frontend.md) / [🇺🇸](./universal/en/engineering/300_web_frontend.md))
*   **341. Headless CMS** ([🇯🇵](./universal/ja/engineering/310_headless_cms.md) / [🇺🇸](./universal/en/engineering/310_headless_cms.md))
*   **342. Mobile (Flutter)** ([🇯🇵](./universal/ja/engineering/400_mobile_flutter.md) / [🇺🇸](./universal/en/engineering/400_mobile_flutter.md))
*   **343. Native Platforms (Kotlin/Swift)** ([🇯🇵](./universal/ja/engineering/410_native_platforms.md) / [🇺🇸](./universal/en/engineering/410_native_platforms.md))
*   **360. Firebase & GCP** ([🇯🇵](./universal/ja/engineering/500_firebase_gcp.md) / [🇺🇸](./universal/en/engineering/500_firebase_gcp.md))
*   **361. AWS Cloud** ([🇯🇵](./universal/ja/engineering/510_aws_cloud.md) / [🇺🇸](./universal/en/engineering/510_aws_cloud.md))

#### 400–409: AI & Data
*   **400. AI Engineering** ([🇯🇵](./universal/ja/ai/000_ai_engineering.md) / [🇺🇸](./universal/en/ai/000_ai_engineering.md))
*   **401. Data & Analytics** ([🇯🇵](./universal/ja/ai/100_data_analytics.md) / [🇺🇸](./universal/en/ai/100_data_analytics.md))

#### 500–599: Operations & Reliability
*   **500. Internal Tools** ([🇯🇵](./universal/ja/operations/000_internal_tools.md) / [🇺🇸](./universal/en/operations/000_internal_tools.md))
*   **501. Customer Experience** ([🇯🇵](./universal/ja/operations/300_customer_experience.md) / [🇺🇸](./universal/en/operations/300_customer_experience.md))
*   **502. Site Reliability** ([🇯🇵](./universal/ja/operations/400_site_reliability.md) / [🇺🇸](./universal/en/operations/400_site_reliability.md))
*   **503. Incident Response** ([🇯🇵](./universal/ja/operations/500_incident_response.md) / [🇺🇸](./universal/en/operations/500_incident_response.md))
*   **510. Sales & Business Development** ([🇯🇵](./universal/ja/operations/100_sales_bizdev.md) / [🇺🇸](./universal/en/operations/100_sales_bizdev.md))
*   **520. HR & Organization** ([🇯🇵](./universal/ja/operations/200_hr_organization.md) / [🇺🇸](./universal/en/operations/200_hr_organization.md))
*   **530. Partnership & Ecosystem** ([🇯🇵](./universal/ja/operations/700_partnership_ecosystem.md) / [🇺🇸](./universal/en/operations/700_partnership_ecosystem.md))

#### 600–609: Security & Legal
*   **600. Security & Privacy** ([🇯🇵](./universal/ja/security/000_security_privacy.md) / [🇺🇸](./universal/en/security/000_security_privacy.md))
*   **601. Data Governance** ([🇯🇵](./universal/ja/security/100_data_governance.md) / [🇺🇸](./universal/en/security/100_data_governance.md))
*   **602. OSS Compliance** ([🇯🇵](./universal/ja/security/200_oss_compliance.md) / [🇺🇸](./universal/en/security/200_oss_compliance.md))
*   **603. IP & Due Diligence** ([🇯🇵](./universal/ja/security/300_ip_due_diligence.md) / [🇺🇸](./universal/en/security/300_ip_due_diligence.md))

#### 700–729: Testing, QA & FinOps
*   **700. QA & Testing** ([🇯🇵](./universal/ja/quality/000_qa_testing.md) / [🇺🇸](./universal/en/quality/000_qa_testing.md))
*   **720. Cloud FinOps** ([🇯🇵](./universal/ja/operations/600_cloud_finops.md) / [🇺🇸](./universal/en/operations/600_cloud_finops.md))

#### 800–809: Global & Governance
*   **800. Internationalization** ([🇯🇵](./universal/ja/product/800_internationalization.md) / [🇺🇸](./universal/en/product/800_internationalization.md))
*   **801. Governance** ([🇯🇵](./universal/ja/core/100_governance.md) / [🇺🇸](./universal/en/core/100_governance.md))
*   **802. Language Protocol** ([🇯🇵](./universal/ja/core/200_language_protocol.md) / [🇺🇸](./universal/en/core/200_language_protocol.md))


### 📐 Blueprint Rules (Project Specific)

> `universal/` と対称のフォルダ分け構造を採用。詳細は [blueprint/ja/INDEX.md](./blueprint/ja/INDEX.md) / [blueprint/en/INDEX.md](./blueprint/en/INDEX.md) を参照。
> Adopts a subdirectory structure symmetric with `universal/`. See [blueprint/ja/INDEX.md](./blueprint/ja/INDEX.md) / [blueprint/en/INDEX.md](./blueprint/en/INDEX.md) for details.

*   **000. Project Overview** ([🇯🇵](./blueprint/ja/governance/000_project_overview.md) / [🇺🇸](./blueprint/en/governance/000_project_overview.md))
*   **010. Project Lessons Log** ([🇯🇵](./blueprint/ja/governance/010_project_lessons_log.md) / [🇺🇸](./blueprint/en/governance/010_project_lessons_log.md))
*   **000. Feature Specification Template** ([🇯🇵](./blueprint/ja/templates/000_feature_spec_template.md) / [🇺🇸](./blueprint/en/templates/000_feature_spec_template.md))
*   **100. Project Specific Template** ([🇯🇵](./blueprint/ja/templates/100_project_specific_template.md) / [🇺🇸](./blueprint/en/templates/100_project_specific_template.md))

### 📋 Reference Documents
*   **[INDEX.md](./INDEX.md)** — 全ルールの詳細索引 / Detailed index of all rules
*   **[LOADING_PROTOCOL.md](./LOADING_PROTOCOL.md)** — ルールロードプロトコル / 5-step rule loading protocol
*   **[CRYSTALLIZATION_PROTOCOL.md](./CRYSTALLIZATION_PROTOCOL.md)** — 教訓の結晶化プロトコル / Lesson auto-crystallization protocol
*   **[Compliance Matrix](./compliance_matrix.md)** — 要件対照表 / User request ↔ Rule file mapping

---

## 🚀 Axiarch Setup & Initialization (導入と初期化)

> [!NOTE]
> **🇯🇵**: 本フレームワークは [Google Antigravity](https://labs.google/antigravity) 上で設計・実戦検証されたものです。**他のAIエージェント**（Cursor, Claude Code, GitHub Copilot等）でも `AGENTS.md` をそのまま使用できる見込みです。ルール本体は純粋なMarkdownであり動作すると考えられますが、**Antigravity以外での動作は検証していません。自己責任でご利用ください。**
>
> **🇺🇸**: This framework was designed and battle-tested on [Google Antigravity](https://labs.google/antigravity), but `AGENTS.md` is expected to work with **other AI agents** as well. The rules are pure Markdown and should be compatible, but **have NOT been tested outside Antigravity. Use at your own risk.**

### 🇯🇵 日本語ガイド (Usage in Japanese)

1.  **コピー (Copy)**: 以下のファイル/フォルダをプロジェクトのルートにコピーします。（`axiarch-prompts/` は任意です）
    ```bash
    cp -r axiarch-rules AGENTS.md /path/to/your/project/
    # 任意: cp -r axiarch-prompts /path/to/your/project/
    ```

2.  **AIエージェント用ポインター設定 (Agent Rules Pointer)**:
    AIエージェントツール（Gemini CLI等）が`.agents/rules/`を自動読み込みする場合、**ポインターファイル**を配置して`axiarch-rules/`を参照させます。
    ```bash
    # .agents/rules/ ディレクトリを作成
    mkdir -p /path/to/your/project/.agents/rules

    # prompt_pointer.md をポインターとして配置（本リポジトリの .agents/rules/ からコピー）
    # ※ ルール本体はaxiarch-rules/に一元管理。.agents/rules/にはポインターのみ配置。
    cp .agents/rules/prompt_pointer.md /path/to/your/project/.agents/rules/prompt_pointer.md
    ```

    > [!CAUTION]
    > **`.agents/rules/` にルール本体を新規作成してはならない。**
    > ルールの追加・編集は必ず `axiarch-rules/` 内で行うこと。
    > `.agents/rules/` はあくまで **ポインター（目次）** であり、ルール本体ではない。

3.  **初期化 (Initialize)**:
    *   **`AGENTS.md` の編集**: `Project Native Language` を `Japanese` に設定します。
    *   **クリーンアップ (Cleanup)**: 使用しない英語ルールのディレクトリを削除します。（プロンプトライブラリを含めた場合も同様です）
        ```bash
        rm -rf axiarch-rules/universal/en axiarch-rules/blueprint/en
        # プロンプトライブラリがある場合: rm -rf axiarch-prompts/en
        ```

4.  **設定 (Configure)**: `axiarch-rules/blueprint/ja/governance/000_project_overview.md` を編集してプロジェクト概要を定義し、`axiarch-rules/blueprint/ja/governance/010_project_lessons_log.md` を教訓記録の起点として準備します。

5.  **開発開始 (Start)**: AI開発チームは、これらのルールを厳格に遵守して開発を行います。

---

### 🇺🇸 English Guide (Usage in English)

1.  **Copy**: Copy the following files/folders to your project root. (`axiarch-prompts/` is optional)
    ```bash
    cp -r axiarch-rules AGENTS.md /path/to/your/project/
    # Optional: cp -r axiarch-prompts /path/to/your/project/
    ```

2.  **Agent Rules Pointer Setup**:
    If your AI agent tool (e.g., Gemini CLI) auto-loads `.agents/rules/`, place a **pointer file** to reference `axiarch-rules/`.
    ```bash
    # Create .agents/rules/ directory
    mkdir -p /path/to/your/project/.agents/rules

    # Place prompt_pointer.md as a pointer (copy from this repo's .agents/rules/)
    # NOTE: Rule definitions live in axiarch-rules/. Only pointers go in .agents/rules/.
    cp .agents/rules/prompt_pointer.md /path/to/your/project/.agents/rules/prompt_pointer.md
    ```

    > [!CAUTION]
    > **DO NOT create new rule files in `.agents/rules/`.**
    > All rule additions/edits MUST be made in `axiarch-rules/`.
    > `.agents/rules/` is strictly a **pointer (table of contents)**, NOT the rules themselves.

3.  **Initialize**:
    *   **Edit `AGENTS.md`**: Set `Project Native Language` to `English`.
    *   **Cleanup**: Delete the unused Japanese language directory. (Do the same if you included the prompt library)
        ```bash
        rm -rf axiarch-rules/universal/ja axiarch-rules/blueprint/ja
        # If you copied the prompt library: rm -rf axiarch-prompts/ja
        ```

4.  **Configure**: Edit `axiarch-rules/blueprint/en/governance/000_project_overview.md` to define your project overview, and prepare `axiarch-rules/blueprint/en/governance/010_project_lessons_log.md` as the starting point for lesson recording.

5.  **Develop**: The AI Development Team will strictly adhere to these rules.

---

### 📁 導入後のディレクトリ構成 (Post-Setup Directory Structure)

```
your-project/
 ├── AGENTS.md                    ← 最高法規 / Supreme Law
 ├── .agents/
 │    └── rules/
 │         └── prompt_pointer.md  ← ポインター（目次）/ Pointer (TOC)
 ├── axiarch-rules/           ← ルール本体 / Rule Definitions
 │    ├── INDEX.md
 │    ├── README.md
 │    ├── universal/              ← 不変ルール / Immutable
 │    │    ├── ja/ (or en/)
 │    │    └── ...
 │    └── blueprint/              ← プロジェクト固有 / Project-Specific
 │         ├── ja/ (or en/)
 │         └── ...
 ├── axiarch-prompts/         ← 任意：プロンプト集 / Optional: Prompt Library
 │    ├── ja/ (or en/)
 │    │    ├── develop/      ← 開発・実行 / Development & Execution
 │    │    ├── audit/        ← 品質監査 / Quality Auditing
 │    │    ├── govern/       ← ガバナンス / Governance
 │    │    └── operate/      ← インシデント・参入 / Incidents & Onboarding
 │    └── (en or ja)/        ← 削除可：未使用言語 / Delete unused language
 └── src/                         ← プロジェクトコード / Your Code
```
