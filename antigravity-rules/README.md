# Google Antigravity Development Rules (Master Index)

> [!IMPORTANT]
> **Constitution of Antigravity**
> 本フォルダ（`antigravity-rules/`）に含まれる全てのルールは、Google Antigravityプロジェクトにおける絶対的な憲法であり、**個別プロジェクト開発時に編集してはならない**。
> All rules contained in this folder (`antigravity-rules/`) are the absolute constitution of the Google Antigravity project and **MUST NOT be edited during specific project development**.
>
> **Separation of Concerns**:
> *   **Universal**: `universal/` (Immutable / 不変 - Requires Double Confirmation to update)
> *   **Specific**: `blueprint/` (Mutable / 可変 - Create files here for each project)

> **Bilingual Requirement / バイリンガル要件**:
> 全てのルールは日本語と英語の両方で提供される。
> All rules are provided in both Japanese and English.

## 📂 Rule Modules

### 🇯🇵 Japanese Rules (日本語)
*   **[00. Core Philosophy & Mindset](./universal/ja/00_core_mindset.md)**
*   **[10. Product & Business Strategy](./universal/ja/10_product_business.md)**
*   **[20. Design & UX](./universal/ja/20_design_ux.md)**
*   **[30. Engineering (General)](./universal/ja/30_engineering_general.md)**
*   **[31. Mobile (Flutter)](./universal/ja/31_engineering_mobile_flutter.md)**
*   **[32. Backend (Firebase/GCP)](./universal/ja/32_engineering_backend_firebase_gcp.md)**
*   **[33. Web Frontend (Next.js)](./universal/ja/33_engineering_web_frontend.md)**
*   **[34. CMS Strategy (WordPress)](./universal/ja/34_engineering_cms_wordpress.md)**
*   **[35. API Integration Strategy](./universal/ja/35_engineering_api_integration.md)**
*   **[36. Native Platforms (Kotlin/Swift)](./universal/ja/36_engineering_native_platforms.md)**
*   **[37. Google Ecosystem & Critical Flows](./universal/ja/37_engineering_google_ecosystem.md)**
*   **[40. Operational Workflow](./universal/ja/40_operations_workflow.md)**
*   **[50. Git & Version Control](./universal/ja/50_git_version_control.md)**
*   **[60. Security & Privacy](./universal/ja/60_security_privacy.md)**
*   **[70. Growth & Marketing](./universal/ja/70_growth_marketing.md)**
*   **[71. GEO Strategy (AI Search)](./universal/ja/71_growth_geo_strategy.md)**
*   **[80. QA & Testing Strategy](./universal/ja/80_qa_testing.md)**
*   **[90. Advanced Operations (Legal/FinOps)](./universal/ja/90_advanced_ops_legal.md)**
*   **[100. Crisis Management & SRE](./universal/ja/100_crisis_sre.md)**
*   **[110. Data & DocOps Strategy](./universal/ja/110_data_docops.md)**

### 🇺🇸 English Rules (English)
*   **[00. Core Philosophy & Mindset](./universal/en/00_core_mindset.md)**
*   **[10. Product & Business Strategy](./universal/en/10_product_business.md)**
*   **[20. Design & UX](./universal/en/20_design_ux.md)**
*   **[30. Engineering (General)](./universal/en/30_engineering_general.md)**
*   **[31. Mobile (Flutter)](./universal/en/31_engineering_mobile_flutter.md)**
*   **[32. Backend (Firebase/GCP)](./universal/en/32_engineering_backend_firebase_gcp.md)**
*   **[33. Web Frontend (Next.js)](./universal/en/33_engineering_web_frontend.md)**
*   **[34. CMS Strategy (WordPress)](./universal/en/34_engineering_cms_wordpress.md)**
*   **[35. API Integration Strategy](./universal/en/35_engineering_api_integration.md)**
*   **[36. Native Platforms (Kotlin/Swift)](./universal/en/36_engineering_native_platforms.md)**
*   **[37. Google Ecosystem & Critical Flows](./universal/en/37_engineering_google_ecosystem.md)**
*   **[40. Operational Workflow](./universal/en/40_operations_workflow.md)**
*   **[50. Git & Version Control](./universal/en/50_git_version_control.md)**
*   **[60. Security & Privacy](./universal/en/60_security_privacy.md)**
*   **[70. Growth & Marketing](./universal/en/70_growth_marketing.md)**
*   **[71. GEO Strategy (AI Search)](./universal/en/71_growth_geo_strategy.md)**
*   **[80. QA & Testing Strategy](./universal/en/80_qa_testing.md)**
*   **[90. Advanced Operations (Legal/FinOps)](./universal/en/90_advanced_ops_legal.md)**
*   **[100. Crisis Management & SRE](./universal/en/100_crisis_sre.md)**
*   **[110. Data & DocOps Strategy](./universal/en/110_data_docops.md)**

---

## 🚀 How to Use
1.  **Project Setup**: プロジェクト開始時に `antigravity-rules/` フォルダをルートに配置。
2.  **Specific Rules**: `blueprint/` フォルダを作成し、その中に `00_overview.md` 等を作成して固有ルールを記述する。
3.  **Enforcement**: 開発チーム（AI）は、常にこれらのファイルを参照し、ルールに準拠しているか自己監査を行う。
