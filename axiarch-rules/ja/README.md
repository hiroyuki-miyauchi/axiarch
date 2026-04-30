# Axiarch Development Rules (マスターインデックス)

> [!IMPORTANT]
> **Axiarchの3層ガバナンス・アーキテクチャ**
> 本フォルダ（`axiarch-rules/`）は、Axiarch（アクシアーク）フレームワークの統治ルールを格納する。
> この「普遍憲法（Layer 1）」「固有ルール（Layer 2）」「任意プロンプト（Layer 3）」による明確な責務分離こそが、ハルシネーションや品質ドリフトを抑制し、長期間にわたる自律駆動の品質ベースラインを維持するAxiarchの心臓部である。
> Axiarchの最低実行条件は Layer 1 と Layer 2 の遵守であり、それ以外の拡張領域である Layer 3 (Prompts) などは完全に任意（オプショナル）である。
>
> **責務分離（AIエージェント指示）**:
>
> *   **Layer 1: Universal Rules (`universal/`)**:
>     *   **Status**: **Immutable (不変)** / 不変の普遍憲法。プロジェクトの普遍的原則と制約水準のベースラインを定義する領域。作業では読み取り専用。
>     *   **Action**: 明示的に「憲法改正」を指示されない限り、AIはこれらのファイルを編集してはならない。
> *   **Layer 2: Blueprint Rules (`blueprint/`)**:
>     *   **Status**: **Mutable (可変)** / プロジェクト固有仕様。
>     *   **Action**: AIはプロジェクトのコンテキストと教訓を蓄積するために、これらのファイルを作成・編集すべきである。

> **言語基準**:
> 全てのルールは**日本語と英語**で提供される（Bilingual Documentation）。

## 📂 ルールモジュール

### 📚 Layer 1: Universal Rules (不変の普遍憲法)

#### Core & Mindset
*   **000. Core Philosophy & Mindset** ([🇯🇵](./universal/core/000_core_mindset.md) / [🇺🇸](../en/universal/core/000_core_mindset.md))

#### Business & Growth
*   **100. Product & Business Strategy** ([🇯🇵](./universal/product/000_product_strategy.md) / [🇺🇸](../en/universal/product/000_product_strategy.md))
*   **101. Revenue & Monetization** ([🇯🇵](./universal/product/300_revenue_monetization.md) / [🇺🇸](../en/universal/product/300_revenue_monetization.md))
*   **102. Growth & Marketing** ([🇯🇵](./universal/product/500_growth_marketing.md) / [🇺🇸](../en/universal/product/500_growth_marketing.md))
*   **103. App Store Compliance & ASO** ([🇯🇵](./universal/product/700_appstore_compliance.md) / [🇺🇸](../en/universal/product/700_appstore_compliance.md))
*   **110. Market Validation & PMF** ([🇯🇵](./universal/product/100_market_validation.md) / [🇺🇸](../en/universal/product/100_market_validation.md))
*   **120. Go-to-Market Strategy** ([🇯🇵](./universal/product/200_go_to_market.md) / [🇺🇸](../en/universal/product/200_go_to_market.md))
*   **130. Pricing Strategy** ([🇯🇵](./universal/product/400_pricing_strategy.md) / [🇺🇸](../en/universal/product/400_pricing_strategy.md))
*   **140. Brand Strategy** ([🇯🇵](./universal/product/600_brand_strategy.md) / [🇺🇸](../en/universal/product/600_brand_strategy.md))
*   **150. Fundraising & IR** ([🇯🇵](./universal/product/900_fundraising_ir.md) / [🇺🇸](../en/universal/product/900_fundraising_ir.md))

#### Design & UX
*   **200. Design & UX Strategy** ([🇯🇵](./universal/design/000_design_ux.md) / [🇺🇸](../en/universal/design/000_design_ux.md))

#### Engineering Core
*   **300. Engineering Standards** ([🇯🇵](./universal/engineering/000_engineering_standards.md) / [🇺🇸](../en/universal/engineering/000_engineering_standards.md))
*   **301. API Integration** ([🇯🇵](./universal/engineering/100_api_integration.md) / [🇺🇸](../en/universal/engineering/100_api_integration.md))
*   **320. Supabase & PostgreSQL** ([🇯🇵](./universal/engineering/200_supabase_architecture.md) / [🇺🇸](../en/universal/engineering/200_supabase_architecture.md))
*   **340. Web Frontend (Next.js)** ([🇯🇵](./universal/engineering/300_web_frontend.md) / [🇺🇸](../en/universal/engineering/300_web_frontend.md))
*   **341. Headless CMS** ([🇯🇵](./universal/engineering/310_headless_cms.md) / [🇺🇸](../en/universal/engineering/310_headless_cms.md))
*   **342. Mobile (Flutter)** ([🇯🇵](./universal/engineering/400_mobile_flutter.md) / [🇺🇸](../en/universal/engineering/400_mobile_flutter.md))
*   **343. Native Platforms (Kotlin/Swift)** ([🇯🇵](./universal/engineering/410_native_platforms.md) / [🇺🇸](../en/universal/engineering/410_native_platforms.md))
*   **360. Firebase & GCP** ([🇯🇵](./universal/engineering/500_firebase_gcp.md) / [🇺🇸](../en/universal/engineering/500_firebase_gcp.md))
*   **361. AWS Cloud** ([🇯🇵](./universal/engineering/510_aws_cloud.md) / [🇺🇸](../en/universal/engineering/510_aws_cloud.md))

#### AI & Data
*   **400. AI Engineering** ([🇯🇵](./universal/ai/000_ai_engineering.md) / [🇺🇸](../en/universal/ai/000_ai_engineering.md))
*   **401. Data & Analytics** ([🇯🇵](./universal/ai/100_data_analytics.md) / [🇺🇸](../en/universal/ai/100_data_analytics.md))

#### Operations & Reliability
*   **500. Internal Tools** ([🇯🇵](./universal/operations/000_internal_tools.md) / [🇺🇸](../en/universal/operations/000_internal_tools.md))
*   **501. Customer Experience** ([🇯🇵](./universal/operations/300_customer_experience.md) / [🇺🇸](../en/universal/operations/300_customer_experience.md))
*   **502. Site Reliability** ([🇯🇵](./universal/operations/400_site_reliability.md) / [🇺🇸](../en/universal/operations/400_site_reliability.md))
*   **503. Incident Response** ([🇯🇵](./universal/operations/500_incident_response.md) / [🇺🇸](../en/universal/operations/500_incident_response.md))
*   **510. Sales & Business Development** ([🇯🇵](./universal/operations/100_sales_bizdev.md) / [🇺🇸](../en/universal/operations/100_sales_bizdev.md))
*   **520. HR & Organization** ([🇯🇵](./universal/operations/200_hr_organization.md) / [🇺🇸](../en/universal/operations/200_hr_organization.md))
*   **530. Partnership & Ecosystem** ([🇯🇵](./universal/operations/700_partnership_ecosystem.md) / [🇺🇸](../en/universal/operations/700_partnership_ecosystem.md))

#### Security & Legal
*   **600. Security & Privacy** ([🇯🇵](./universal/security/000_security_privacy.md) / [🇺🇸](../en/universal/security/000_security_privacy.md))
*   **601. Data Governance** ([🇯🇵](./universal/security/100_data_governance.md) / [🇺🇸](../en/universal/security/100_data_governance.md))
*   **602. OSS Compliance** ([🇯🇵](./universal/security/200_oss_compliance.md) / [🇺🇸](../en/universal/security/200_oss_compliance.md))
*   **603. IP & Due Diligence** ([🇯🇵](./universal/security/300_ip_due_diligence.md) / [🇺🇸](../en/universal/security/300_ip_due_diligence.md))

#### Testing, QA & FinOps
*   **700. QA & Testing** ([🇯🇵](./universal/quality/000_qa_testing.md) / [🇺🇸](../en/universal/quality/000_qa_testing.md))
*   **720. Cloud FinOps** ([🇯🇵](./universal/operations/600_cloud_finops.md) / [🇺🇸](../en/universal/operations/600_cloud_finops.md))

#### Global & Governance
*   **800. Internationalization** ([🇯🇵](./universal/product/800_internationalization.md) / [🇺🇸](../en/universal/product/800_internationalization.md))
*   **801. Governance** ([🇯🇵](./universal/core/100_governance.md) / [🇺🇸](../en/universal/core/100_governance.md))
*   **802. Language Protocol** ([🇯🇵](./universal/core/200_language_protocol.md) / [🇺🇸](../en/universal/core/200_language_protocol.md))


### 📐 Layer 2: Blueprint Rules (プロジェクト固有仕様)

> `universal/` と対称のフォルダ分け構造を採用。詳細は [blueprint/INDEX.md](./blueprint/INDEX.md) / [blueprint/INDEX.md (EN)](../en/blueprint/INDEX.md) を参照。

*   **000. Project Overview** ([🇯🇵](./blueprint/core/000_project_overview.md) / [🇺🇸](../en/blueprint/core/000_project_overview.md))
*   **010. Project Lessons Log** ([🇯🇵](./blueprint/core/010_project_lessons_log.md) / [🇺🇸](../en/blueprint/core/010_project_lessons_log.md))
*   **998. Feature Specification Template** ([🇯🇵](./blueprint/core/998_feature_spec_template.md) / [🇺🇸](../en/blueprint/core/998_feature_spec_template.md))
*   **999. Project Specific Template** ([🇯🇵](./blueprint/core/999_project_specific_template.md) / [🇺🇸](../en/blueprint/core/999_project_specific_template.md))

### 📋 参照ドキュメント
*   **[INDEX.md](./INDEX.md)** — 全ルールの詳細索引
*   **[LOADING_PROTOCOL.md](./LOADING_PROTOCOL.md)** — ルールロードプロトコル
*   **[CRYSTALLIZATION_PROTOCOL.md](./CRYSTALLIZATION_PROTOCOL.md)** — 教訓の結晶化プロトコル
*   **[Compliance Matrix](./compliance_matrix.md)** — 要件対照表

---

## 🚀 Axiarch セットアップ & 初期化

> [!NOTE]
> 本フレームワークは [Google Antigravity](https://antigravity.google/) 上で設計・実戦検証されたものです。**他のAIエージェント**（Cursor, Claude Code, GitHub Copilot等）でも `AGENTS.md` をそのまま使用できる見込みですが、ルール本体はMarkdownであり理論上は稼働するものの、**Antigravity以外での動作保証は一切いたしません。自己責任でご利用ください。**

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
        rm -rf axiarch-rules/en
        # プロンプトライブラリがある場合: rm -rf axiarch-prompts/en
        ```

4.  **設定 (Configure)**: `axiarch-rules/ja/blueprint/core/000_project_overview.md` を編集してプロジェクト概要を定義し、`axiarch-rules/ja/blueprint/core/010_project_lessons_log.md` を教訓記録の起点として準備します。

5.  **開発開始 (Start)**: AI開発チームは、これらのルールを厳格に遵守して開発を行います。

---

### 📁 導入後のディレクトリ構成

```
your-project/
 ├── AGENTS.md                    ← 最高法規
 ├── .agents/
 │    └── rules/
 │         └── prompt_pointer.md  ← ポインター（目次）
 ├── axiarch-rules/           ← ルール本体
 │    └── ja/ (or en/)        ← 言語選択
 │         ├── INDEX.md
 │         ├── README.md
 │         ├── LOADING_PROTOCOL.md
 │         ├── CRYSTALLIZATION_PROTOCOL.md
 │         ├── universal/     ← Layer 1: 不変憲法
 │         │    ├── core/
 │         │    ├── product/
 │         │    ├── engineering/
 │         │    └── ...
 │         └── blueprint/     ← Layer 2: 固有ルール
 │              └── core/
 ├── axiarch-prompts/         ← Layer 3: 任意実行エンジン
 │    ├── ja/ (or en/)
 │    │    ├── develop/      ← 開発・実行
 │    │    ├── audit/        ← 品質監査
 │    │    ├── govern/       ← ガバナンス
 │    │    └── operate/      ← インシデント・参入
 │    └── (en or ja)/        ← 削除可：未使用言語
 └── src/                         ← プロジェクトコード
```
