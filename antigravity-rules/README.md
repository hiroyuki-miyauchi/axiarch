# Google Antigravity Development Rules (Master Index)

> [!IMPORTANT]
> **Constitution of Antigravity**
> 本フォルダ（`antigravity-rules/`）に含まれる全てのルールは、Google Antigravityプロジェクトにおける絶対的な憲法であり、**個別プロジェクト開発時に編集してはならない**。
> All rules contained in this folder (`antigravity-rules/`) are the absolute constitution of the Google Antigravity project and **MUST NOT be edited during specific project development**.
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

> **Language Standard / 言語基準**:
> 全てのルールは**日本語と英語**で提供される（Bilingual Documentation）。
> All rules are provided in **Japanese and English** to ensure global scalability and perfect communication.

## 📂 Rule Modules

### 📚 Universal Rules (Bilingual)

#### 000: Core & Mindset
*   **000. Core Philosophy & Mindset** ([🇯🇵](./universal/ja/000_core_mindset.md) / [🇺🇸](./universal/en/000_core_mindset.md))

#### 100–109: Business & Growth
*   **100. Product & Business Strategy** ([🇯🇵](./universal/ja/100_product_strategy.md) / [🇺🇸](./universal/en/100_product_strategy.md))
*   **101. Revenue & Monetization** ([🇯🇵](./universal/ja/101_revenue_monetization.md) / [🇺🇸](./universal/en/101_revenue_monetization.md))
*   **102. Growth & Marketing** ([🇯🇵](./universal/ja/102_growth_marketing.md) / [🇺🇸](./universal/en/102_growth_marketing.md))
*   **103. App Store Compliance & ASO** ([🇯🇵](./universal/ja/103_appstore_compliance.md) / [🇺🇸](./universal/en/103_appstore_compliance.md))

#### 200: Design & UX
*   **200. Design & UX Strategy** ([🇯🇵](./universal/ja/200_design_ux.md) / [🇺🇸](./universal/en/200_design_ux.md))

#### 300–399: Engineering Core (20-unit intervals)
*   **300. Engineering Standards** ([🇯🇵](./universal/ja/300_engineering_standards.md) / [🇺🇸](./universal/en/300_engineering_standards.md))
*   **301. API Integration** ([🇯🇵](./universal/ja/301_api_integration.md) / [🇺🇸](./universal/en/301_api_integration.md))
*   **320. Supabase & PostgreSQL** ([🇯🇵](./universal/ja/320_supabase_architecture.md) / [🇺🇸](./universal/en/320_supabase_architecture.md))
*   **340. Web Frontend (Next.js)** ([🇯🇵](./universal/ja/340_web_frontend.md) / [🇺🇸](./universal/en/340_web_frontend.md))
*   **341. Headless CMS** ([🇯🇵](./universal/ja/341_headless_cms.md) / [🇺🇸](./universal/en/341_headless_cms.md))
*   **342. Mobile (Flutter)** ([🇯🇵](./universal/ja/342_mobile_flutter.md) / [🇺🇸](./universal/en/342_mobile_flutter.md))
*   **343. Native Platforms (Kotlin/Swift)** ([🇯🇵](./universal/ja/343_native_platforms.md) / [🇺🇸](./universal/en/343_native_platforms.md))
*   **360. Firebase & GCP** ([🇯🇵](./universal/ja/360_firebase_gcp.md) / [🇺🇸](./universal/en/360_firebase_gcp.md))
*   **361. AWS Cloud** ([🇯🇵](./universal/ja/361_aws_cloud.md) / [🇺🇸](./universal/en/361_aws_cloud.md))

#### 400–409: AI & Data
*   **400. AI Engineering** ([🇯🇵](./universal/ja/400_ai_engineering.md) / [🇺🇸](./universal/en/400_ai_engineering.md))
*   **401. Data & Analytics** ([🇯🇵](./universal/ja/401_data_analytics.md) / [🇺🇸](./universal/en/401_data_analytics.md))

#### 500–509: Operations & Reliability
*   **500. Internal Tools** ([🇯🇵](./universal/ja/500_internal_tools.md) / [🇺🇸](./universal/en/500_internal_tools.md))
*   **501. Customer Experience** ([🇯🇵](./universal/ja/501_customer_experience.md) / [🇺🇸](./universal/en/501_customer_experience.md))
*   **502. Site Reliability** ([🇯🇵](./universal/ja/502_site_reliability.md) / [🇺🇸](./universal/en/502_site_reliability.md))
*   **503. Incident Response** ([🇯🇵](./universal/ja/503_incident_response.md) / [🇺🇸](./universal/en/503_incident_response.md))

#### 600–609: Security & Legal
*   **600. Security & Privacy** ([🇯🇵](./universal/ja/600_security_privacy.md) / [🇺🇸](./universal/en/600_security_privacy.md))
*   **601. Data Governance** ([🇯🇵](./universal/ja/601_data_governance.md) / [🇺🇸](./universal/en/601_data_governance.md))
*   **602. OSS Compliance** ([🇯🇵](./universal/ja/602_oss_compliance.md) / [🇺🇸](./universal/en/602_oss_compliance.md))
*   **603. IP & Due Diligence** ([🇯🇵](./universal/ja/603_ip_due_diligence.md) / [🇺🇸](./universal/en/603_ip_due_diligence.md))

#### 700–729: Testing, QA & FinOps
*   **700. QA & Testing** ([🇯🇵](./universal/ja/700_qa_testing.md) / [🇺🇸](./universal/en/700_qa_testing.md))
*   **720. Cloud FinOps** ([🇯🇵](./universal/ja/720_cloud_finops.md) / [🇺🇸](./universal/en/720_cloud_finops.md))

#### 800–809: Global & Governance
*   **800. Internationalization** ([🇯🇵](./universal/ja/800_internationalization.md) / [🇺🇸](./universal/en/800_internationalization.md))
*   **801. Governance** ([🇯🇵](./universal/ja/801_governance.md) / [🇺🇸](./universal/en/801_governance.md))
*   **802. Language Protocol** ([🇯🇵](./universal/ja/802_language_protocol.md) / [🇺🇸](./universal/en/802_language_protocol.md))


### 📐 Blueprint Rules (Project Specific)
*   **000. Project Overview & Architecture** ([🇯🇵](./blueprint/ja/000_project_overview.md) / [🇺🇸](./blueprint/en/000_project_overview.md))
*   **001. Project Lessons Log** ([🇯🇵](./blueprint/ja/010_project_lessons_log.md) / [🇺🇸](./blueprint/en/010_project_lessons_log.md))
*   **999. Project Specific Template** ([🇯🇵](./blueprint/ja/999_project_specific_template.md) / [🇺🇸](./blueprint/en/999_project_specific_template.md))

### 📋 Reference Documents
*   **[INDEX.md](./INDEX.md)** — 全ルールの詳細索引 / Detailed index of all rules
*   **[Compliance Matrix](./compliance_matrix.md)** — 要件対照表 / User request ↔ Rule file mapping

---

## 🚀 Antigravity Setup & Initialization (導入と初期化)

### 🇯🇵 日本語ガイド (Usage in Japanese)

1.  **コピー (Copy)**: 以下のファイル/フォルダをプロジェクトのルートにコピーします。
    ```bash
    cp -r antigravity-rules GEMINI.md /path/to/your/project/
    ```

2.  **AIエージェント用ポインター設定 (Agent Rules Pointer)**:
    AIエージェントツール（Gemini CLI等）が`.agent/rules/`を自動読み込みする場合、**ポインターファイル**を配置して`antigravity-rules/`を参照させます。
    ```bash
    # .agent/rules/ ディレクトリを作成
    mkdir -p /path/to/your/project/.agent/rules

    # prompt_pointer.md をポインターとして配置（本リポジトリの .agent/rules/ からコピー）
    # ※ ルール本体はantigravity-rules/に一元管理。.agent/rules/にはポインターのみ配置。
    cp .agent/rules/prompt_pointer.md /path/to/your/project/.agent/rules/prompt_pointer.md
    ```

    > [!CAUTION]
    > **`.agent/rules/` にルール本体を新規作成してはならない。**
    > ルールの追加・編集は必ず `antigravity-rules/` 内で行うこと。
    > `.agent/rules/` はあくまで **ポインター（目次）** であり、ルール本体ではない。

3.  **初期化 (Initialize)**:
    *   **`GEMINI.md` の編集**: `Project Native Language` を `Japanese` に設定します。
    *   **クリーンアップ (Cleanup)**: 使用しない英語ルールのディレクトリを削除します。
        ```bash
        rm -rf antigravity-rules/universal/en antigravity-rules/blueprint/en
        ```

4.  **設定 (Configure)**: `antigravity-rules/blueprint/ja/010_project_lessons_log.md`（およびその他の青写真）を編集し、プロジェクト固有の要件を定義します。

5.  **開発開始 (Start)**: AI開発チームは、これらのルールを厳格に遵守して開発を行います。

---

### 🇺🇸 English Guide (Usage in English)

1.  **Copy**: Copy the following files/folders to your project root.
    ```bash
    cp -r antigravity-rules GEMINI.md /path/to/your/project/
    ```

2.  **Agent Rules Pointer Setup**:
    If your AI agent tool (e.g., Gemini CLI) auto-loads `.agent/rules/`, place a **pointer file** to reference `antigravity-rules/`.
    ```bash
    # Create .agent/rules/ directory
    mkdir -p /path/to/your/project/.agent/rules

    # Place prompt_pointer.md as a pointer (copy from this repo's .agent/rules/)
    # NOTE: Rule definitions live in antigravity-rules/. Only pointers go in .agent/rules/.
    cp .agent/rules/prompt_pointer.md /path/to/your/project/.agent/rules/prompt_pointer.md
    ```

    > [!CAUTION]
    > **DO NOT create new rule files in `.agent/rules/`.**
    > All rule additions/edits MUST be made in `antigravity-rules/`.
    > `.agent/rules/` is strictly a **pointer (table of contents)**, NOT the rules themselves.

3.  **Initialize**:
    *   **Edit `GEMINI.md`**: Set `Project Native Language` to `English`.
    *   **Cleanup**: Delete the unused Japanese language directory.
        ```bash
        rm -rf antigravity-rules/universal/ja antigravity-rules/blueprint/ja
        ```

4.  **Configure**: Edit `antigravity-rules/blueprint/en/010_project_lessons_log.md` (and other blueprints) to define your project's specifics.

5.  **Develop**: The AI Development Team will strictly adhere to these rules.

---

### 📁 導入後のディレクトリ構成 (Post-Setup Directory Structure)

```
your-project/
 ├── GEMINI.md                    ← 最高法規 / Supreme Law
 ├── .agent/
 │    └── rules/
 │         └── prompt_pointer.md  ← ポインター（目次）/ Pointer (TOC)
 ├── antigravity-rules/           ← ルール本体 / Rule Definitions
 │    ├── INDEX.md
 │    ├── README.md
 │    ├── universal/              ← 不変ルール / Immutable
 │    │    ├── ja/ (or en/)
 │    │    └── ...
 │    └── blueprint/              ← プロジェクト固有 / Project-Specific
 │         ├── ja/ (or en/)
 │         └── ...
 └── src/                         ← プロジェクトコード / Your Code
```
