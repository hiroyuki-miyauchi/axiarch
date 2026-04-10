# Axiarch Development Rules (Master Index)

> [!IMPORTANT]
> **Axiarchの3層ガバナンス・アーキテクチャ / The Three-Layer Governance Architecture**
> 本フォルダ（`axiarch-rules/`）は、Axiarch（アクシアーク）フレームワークの統治ルールを格納する。
> この「普遍憲法（Layer 1）」「固有ルール（Layer 2）」「任意プロンプト（Layer 3）」による明確な責務分離こそが、ハルシネーションや品質ドリフトを抑制し、長期間にわたる自律駆動の品質ベースラインを維持するAxiarchの心臓部である。
> Axiarchの最低実行条件は Layer 1 と Layer 2 の遵守であり、それ以外の拡張領域である Layer 3 (Prompts) などは完全に任意（オプショナル）である。
> 
> **Separation of Concerns (AI Agent Instructions)**:
>
> ## 🇯🇵 日本語指示 (Japanese Instructions)
> *   **Layer 1: Universal Rules (`universal/`)**:
>     *   **Status**: **Immutable (不変)** / 不変の普遍憲法。プロジェクトの普遍的原則と制約水準のベースラインを定義する領域。作業では読み取り専用。
>     *   **Action**: 明示的に「憲法改正」を指示されない限り、AIはこれらのファイルを編集してはならない。
> *   **Layer 2: Blueprint Rules (`blueprint/`)**:
>     *   **Status**: **Mutable (可変)** / プロジェクト固有仕様。
>     *   **Action**: AIはプロジェクトのコンテキストと教訓を蓄積するために、これらのファイルを作成・編集すべきである。
>
> ## 🇺🇸 English Instructions
> *   **Layer 1: Universal Rules (`universal/`)**:
>     *   **Status**: **Immutable** / Immutable Constitution. Defines the baseline of universal principles and constraint levels. Read-Only for Project Tasks.
>     *   **Action**: AI MUST NOT edit these files unless explicitly instructed to "Amend Constitution".
> *   **Layer 2: Blueprint Rules (`blueprint/`)**:
>     *   **Status**: **Mutable** / Evolving Project State.
>     *   **Action**: AI SHOULD create and edit these files to accumulate project context and lessons.

> **言語基準 / Language Standard**:
> 全てのルールは**日本語と英語**で提供される（Bilingual Documentation）。
> All rules are provided in **Japanese and English** to ensure global scalability and perfect communication.

## 📂 Rule Modules

### 📚 Layer 1: Universal Rules (Immutable Constitution)

#### Core & Mindset
*   **000. Core Philosophy & Mindset** ([🇯🇵](./universal/ja/core/000_core_mindset.md) / [🇺🇸](./universal/en/core/000_core_mindset.md))

#### Business & Growth
*   **100. Product & Business Strategy** ([🇯🇵](./universal/ja/product/000_product_strategy.md) / [🇺🇸](./universal/en/product/000_product_strategy.md))
*   **101. Revenue & Monetization** ([🇯🇵](./universal/ja/product/300_revenue_monetization.md) / [🇺🇸](./universal/en/product/300_revenue_monetization.md))
*   **102. Growth & Marketing** ([🇯🇵](./universal/ja/product/500_growth_marketing.md) / [🇺🇸](./universal/en/product/500_growth_marketing.md))
*   **103. App Store Compliance & ASO** ([🇯🇵](./universal/ja/product/700_appstore_compliance.md) / [🇺🇸](./universal/en/product/700_appstore_compliance.md))
*   **110. Market Validation & PMF** ([🇯🇵](./universal/ja/product/100_market_validation.md) / [🇺🇸](./universal/en/product/100_market_validation.md))
*   **120. Go-to-Market Strategy** ([🇯🇵](./universal/ja/product/200_go_to_market.md) / [🇺🇸](./universal/en/product/200_go_to_market.md))
*   **130. Pricing Strategy** ([🇯🇵](./universal/ja/product/400_pricing_strategy.md) / [🇺🇸](./universal/en/product/400_pricing_strategy.md))
*   **140. Brand Strategy** ([🇯🇵](./universal/ja/product/600_brand_strategy.md) / [🇺🇸](./universal/en/product/600_brand_strategy.md))
*   **150. Fundraising & IR** ([🇯🇵](./universal/ja/product/900_fundraising_ir.md) / [🇺🇸](./universal/en/product/900_fundraising_ir.md))

#### Design & UX
*   **200. Design & UX Strategy** ([🇯🇵](./universal/ja/design/000_design_ux.md) / [🇺🇸](./universal/en/design/000_design_ux.md))

#### Engineering Core
*   **300. Engineering Standards** ([🇯🇵](./universal/ja/engineering/000_engineering_standards.md) / [🇺🇸](./universal/en/engineering/000_engineering_standards.md))
*   **301. API Integration** ([🇯🇵](./universal/ja/engineering/100_api_integration.md) / [🇺🇸](./universal/en/engineering/100_api_integration.md))
*   **320. Supabase & PostgreSQL** ([🇯🇵](./universal/ja/engineering/200_supabase_architecture.md) / [🇺🇸](./universal/en/engineering/200_supabase_architecture.md))
*   **340. Web Frontend (Next.js)** ([🇯🇵](./universal/ja/engineering/300_web_frontend.md) / [🇺🇸](./universal/en/engineering/300_web_frontend.md))
*   **341. Headless CMS** ([🇯🇵](./universal/ja/engineering/310_headless_cms.md) / [🇺🇸](./universal/en/engineering/310_headless_cms.md))
*   **342. Mobile (Flutter)** ([🇯🇵](./universal/ja/engineering/400_mobile_flutter.md) / [🇺🇸](./universal/en/engineering/400_mobile_flutter.md))
*   **343. Native Platforms (Kotlin/Swift)** ([🇯🇵](./universal/ja/engineering/410_native_platforms.md) / [🇺🇸](./universal/en/engineering/410_native_platforms.md))
*   **360. Firebase & GCP** ([🇯🇵](./universal/ja/engineering/500_firebase_gcp.md) / [🇺🇸](./universal/en/engineering/500_firebase_gcp.md))
*   **361. AWS Cloud** ([🇯🇵](./universal/ja/engineering/510_aws_cloud.md) / [🇺🇸](./universal/en/engineering/510_aws_cloud.md))

#### AI & Data
*   **400. AI Engineering** ([🇯🇵](./universal/ja/ai/000_ai_engineering.md) / [🇺🇸](./universal/en/ai/000_ai_engineering.md))
*   **401. Data & Analytics** ([🇯🇵](./universal/ja/ai/100_data_analytics.md) / [🇺🇸](./universal/en/ai/100_data_analytics.md))

#### Operations & Reliability
*   **500. Internal Tools** ([🇯🇵](./universal/ja/operations/000_internal_tools.md) / [🇺🇸](./universal/en/operations/000_internal_tools.md))
*   **501. Customer Experience** ([🇯🇵](./universal/ja/operations/300_customer_experience.md) / [🇺🇸](./universal/en/operations/300_customer_experience.md))
*   **502. Site Reliability** ([🇯🇵](./universal/ja/operations/400_site_reliability.md) / [🇺🇸](./universal/en/operations/400_site_reliability.md))
*   **503. Incident Response** ([🇯🇵](./universal/ja/operations/500_incident_response.md) / [🇺🇸](./universal/en/operations/500_incident_response.md))
*   **510. Sales & Business Development** ([🇯🇵](./universal/ja/operations/100_sales_bizdev.md) / [🇺🇸](./universal/en/operations/100_sales_bizdev.md))
*   **520. HR & Organization** ([🇯🇵](./universal/ja/operations/200_hr_organization.md) / [🇺🇸](./universal/en/operations/200_hr_organization.md))
*   **530. Partnership & Ecosystem** ([🇯🇵](./universal/ja/operations/700_partnership_ecosystem.md) / [🇺🇸](./universal/en/operations/700_partnership_ecosystem.md))

#### Security & Legal
*   **600. Security & Privacy** ([🇯🇵](./universal/ja/security/000_security_privacy.md) / [🇺🇸](./universal/en/security/000_security_privacy.md))
*   **601. Data Governance** ([🇯🇵](./universal/ja/security/100_data_governance.md) / [🇺🇸](./universal/en/security/100_data_governance.md))
*   **602. OSS Compliance** ([🇯🇵](./universal/ja/security/200_oss_compliance.md) / [🇺🇸](./universal/en/security/200_oss_compliance.md))
*   **603. IP & Due Diligence** ([🇯🇵](./universal/ja/security/300_ip_due_diligence.md) / [🇺🇸](./universal/en/security/300_ip_due_diligence.md))

#### Testing, QA & FinOps
*   **700. QA & Testing** ([🇯🇵](./universal/ja/quality/000_qa_testing.md) / [🇺🇸](./universal/en/quality/000_qa_testing.md))
*   **720. Cloud FinOps** ([🇯🇵](./universal/ja/operations/600_cloud_finops.md) / [🇺🇸](./universal/en/operations/600_cloud_finops.md))

#### Global & Governance
*   **800. Internationalization** ([🇯🇵](./universal/ja/product/800_internationalization.md) / [🇺🇸](./universal/en/product/800_internationalization.md))
*   **801. Governance** ([🇯🇵](./universal/ja/core/100_governance.md) / [🇺🇸](./universal/en/core/100_governance.md))
*   **802. Language Protocol** ([🇯🇵](./universal/ja/core/200_language_protocol.md) / [🇺🇸](./universal/en/core/200_language_protocol.md))


### 📐 Layer 2: Blueprint Rules (Mutable Project State)

> `universal/` と対称のフォルダ分け構造を採用。詳細は [blueprint/ja/INDEX.md](./blueprint/ja/INDEX.md) / [blueprint/en/INDEX.md](./blueprint/en/INDEX.md) を参照。
> Adopts a subdirectory structure symmetric with `universal/`. See [blueprint/ja/INDEX.md](./blueprint/ja/INDEX.md) / [blueprint/en/INDEX.md](./blueprint/en/INDEX.md) for details.

*   **000. Project Overview** ([🇯🇵](./blueprint/ja/core/000_project_overview.md) / [🇺🇸](./blueprint/en/core/000_project_overview.md))
*   **010. Project Lessons Log** ([🇯🇵](./blueprint/ja/core/010_project_lessons_log.md) / [🇺🇸](./blueprint/en/core/010_project_lessons_log.md))
*   **998. Feature Specification Template** ([🇯🇵](./blueprint/ja/core/998_feature_spec_template.md) / [🇺🇸](./blueprint/en/core/998_feature_spec_template.md))
*   **999. Project Specific Template** ([🇯🇵](./blueprint/ja/core/999_project_specific_template.md) / [🇺🇸](./blueprint/en/core/999_project_specific_template.md))

### 📋 Reference Documents
*   **[INDEX.md](./INDEX.md)** — 全ルールの詳細索引 / Detailed index of all rules
*   **[LOADING_PROTOCOL.md](./LOADING_PROTOCOL.md)** — ルールロードプロトコル / 5-step rule loading protocol
*   **[CRYSTALLIZATION_PROTOCOL.md](./CRYSTALLIZATION_PROTOCOL.md)** — 教訓の結晶化プロトコル / Lesson auto-crystallization protocol
*   **[Compliance Matrix](./compliance_matrix.md)** — 要件対照表 / User request ↔ Rule file mapping

---

## 🚀 Axiarch Setup & Initialization (導入と初期化)

> [!NOTE]
> **🇯🇵**: 本フレームワークは [Google Antigravity](https://antigravity.google/) 上で設計・実戦検証されたものです。**他のAIエージェント**（Cursor, Claude Code, GitHub Copilot等）でも `AGENTS.md` をそのまま使用できる見込みですが、ルール本体はMarkdownであり理論上は稼働するものの、**Antigravity以外での動作保証は一切いたしません。自己責任でご利用ください。**
>
> **🇺🇸**: This framework was designed and validated through hundreds of real production sessions on [Google Antigravity](https://antigravity.google/). Through `AGENTS.md`, it is expected to work with **other AI agents**; however, its operation outside Antigravity is **NOT guaranteed. Use at your own risk.**

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

4.  **設定 (Configure)**: `axiarch-rules/blueprint/ja/core/000_project_overview.md` を編集してプロジェクト概要を定義し、`axiarch-rules/blueprint/ja/core/010_project_lessons_log.md` を教訓記録の起点として準備します。

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

4.  **Configure**: Edit `axiarch-rules/blueprint/en/core/000_project_overview.md` to define your project overview, and prepare `axiarch-rules/blueprint/en/core/010_project_lessons_log.md` as the starting point for lesson recording.

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
 │    ├── universal/              ← Layer 1: 不変憲法 / Immutable
 │    │    ├── ja/ (or en/)
 │    │    └── ...
 │    └── blueprint/              ← Layer 2: 固有ルール / Mutable State
 │         ├── ja/ (or en/)
 │         └── ...
 ├── axiarch-prompts/         ← Layer 3: 任意実行エンジン / Optional Execution Engine
 │    ├── ja/ (or en/)
 │    │    ├── develop/      ← 開発・実行 / Development & Execution
 │    │    ├── audit/        ← 品質監査 / Quality Auditing
 │    │    ├── govern/       ← ガバナンス / Governance
 │    │    └── operate/      ← インシデント・参入 / Incidents & Onboarding
 │    └── (en or ja)/        ← 削除可：未使用言語 / Delete unused language
 └── src/                         ← プロジェクトコード / Your Code
```
