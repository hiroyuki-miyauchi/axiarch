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

#### 00-09: Core & Mindset
*   **00. Core Philosophy & Mindset** ([🇯🇵](./universal/ja/00_core_mindset.md) / [🇺🇸](./universal/en/00_core_mindset.md))

#### 10-19: Business & Growth
*   **10. Product & Business Strategy** ([🇯🇵](./universal/ja/10_product_business.md) / [🇺🇸](./universal/en/10_product_business.md))
*   **11. Business & Finance** ([🇯🇵](./universal/ja/11_business_finance.md) / [🇺🇸](./universal/en/11_business_finance.md))
*   **12. Growth & Marketing** ([🇯🇵](./universal/ja/12_growth_marketing.md) / [🇺🇸](./universal/en/12_growth_marketing.md))
*   **13. Store Compliance & ASO** ([🇯🇵](./universal/ja/13_store_compliance.md) / [🇺🇸](./universal/en/13_store_compliance.md))

#### 20-29: Design & UX
*   **20. Design & UX Strategy** ([🇯🇵](./universal/ja/20_design_ux.md) / [🇺🇸](./universal/en/20_design_ux.md))

#### 30-39: Engineering Core
*   **30. Engineering General** ([🇯🇵](./universal/ja/30_engineering_general.md) / [🇺🇸](./universal/en/30_engineering_general.md))
*   **31. Mobile (Flutter)** ([🇯🇵](./universal/ja/31_mobile_flutter.md) / [🇺🇸](./universal/en/31_mobile_flutter.md))
*   **32. Backend (Firebase)** ([🇯🇵](./universal/ja/32_backend_firebase.md) / [🇺🇸](./universal/en/32_backend_firebase.md))
*   **33. Web Frontend (Next.js)** ([🇯🇵](./universal/ja/33_web_frontend.md) / [🇺🇸](./universal/en/33_web_frontend.md))
*   **34. CMS Strategy (Headless)** ([🇯🇵](./universal/ja/34_cms_headless.md) / [🇺🇸](./universal/en/34_cms_headless.md))
*   **35. API Integration** ([🇯🇵](./universal/ja/35_api_integration.md) / [🇺🇸](./universal/en/35_api_integration.md))
*   **36. Native Platforms** ([🇯🇵](./universal/ja/36_native_platforms.md) / [🇺🇸](./universal/en/36_native_platforms.md))
*   **37. Backend - Supabase & PostgreSQL** ([🇯🇵](./universal/ja/37_backend_supabase.md) / [🇺🇸](./universal/en/37_backend_supabase.md))

#### 40-49: AI & Data
*   **40. AI Implementation** ([🇯🇵](./universal/ja/40_ai_implementation.md) / [🇺🇸](./universal/en/40_ai_implementation.md))
*   **41. Analytics & Intelligence** ([🇯🇵](./universal/ja/41_analytics_intelligence.md) / [🇺🇸](./universal/en/41_analytics_intelligence.md))

#### 50-59: Operations & Reliability
*   **50. Admin & Internal Tools** ([🇯🇵](./universal/ja/50_admin_tools.md) / [🇺🇸](./universal/en/50_admin_tools.md))
*   **51. User Support & Success** ([🇯🇵](./universal/ja/51_user_support.md) / [🇺🇸](./universal/en/51_user_support.md))
*   **52. SRE & Reliability** ([🇯🇵](./universal/ja/52_sre_reliability.md) / [🇺🇸](./universal/en/52_sre_reliability.md))
*   **53. Crisis Management** ([🇯🇵](./universal/ja/53_crisis_management.md) / [🇺🇸](./universal/en/53_crisis_management.md))

#### 60-69: Security & Legal
*   **60. Security & Privacy** ([🇯🇵](./universal/ja/60_security_privacy.md) / [🇺🇸](./universal/en/60_security_privacy.md))
*   **61. Legal & Data Governance** ([🇯🇵](./universal/ja/61_legal_data_privacy.md) / [🇺🇸](./universal/en/61_legal_data_privacy.md))
*   **62. License & Dependency** ([🇯🇵](./universal/ja/62_license_dependency.md) / [🇺🇸](./universal/en/62_license_dependency.md))
*   **63. IP Strategy & Due Diligence** ([🇯🇵](./universal/ja/63_ip_due_diligence.md) / [🇺🇸](./universal/en/63_ip_due_diligence.md))

#### 70-79: QA & Global
*   **70. QA & Testing** ([🇯🇵](./universal/ja/70_qa_testing.md) / [🇺🇸](./universal/en/70_qa_testing.md))
*   **71. Global Expansion** ([🇯🇵](./universal/ja/71_global_expansion.md) / [🇺🇸](./universal/en/71_global_expansion.md))
*   **72. Constitution Authority** ([🇯🇵](./universal/ja/72_constitution_authority.md) / [🇺🇸](./universal/en/72_constitution_authority.md))
*   **74. Language Protocol** ([🇯🇵](./universal/ja/74_language_protocol.md) / [🇺🇸](./universal/en/74_language_protocol.md))


### 📐 Blueprint Rules (Project Specific)
*   **00. Project Overview & Architecture** ([🇯🇵](./blueprint/ja/00_project_overview.md) / [🇺🇸](./blueprint/en/00_project_overview.md))
*   **01. Project Lessons Log** ([🇯🇵](./blueprint/ja/01_project_lessons_log.md) / [🇺🇸](./blueprint/en/01_project_lessons_log.md))
*   **99. Project Specific Template** ([🇯🇵](./blueprint/ja/99_project_specific_template.md) / [🇺🇸](./blueprint/en/99_project_specific_template.md))

---

## 🚀 Antigravity Setup & Initialization (導入と初期化)

### 🇯🇵 日本語ガイド (Usage in Japanese)

1.  **コピー (Copy)**: `antigravity-rules/` フォルダと `GEMINI.md` (Cursor派は `.cursorrules` も) をプロジェクトのルートにコピーします。
    *   `cp -r antigravity-rules GEMINI.md .cursorrules /path/to/your/project/`

2.  **初期化 (Initialize)**:
    *   **`GEMINI.md` の編集**: `Project Native Language` を `Japanese` に設定します。
    *   **クリーンアップ (Cleanup)**: 使用しない英語のルールのディレクトリを削除します。
        *   `rm -rf antigravity-rules/universal/en antigravity-rules/blueprint/en`
3.  **設定 (Configure)**: `antigravity-rules/blueprint/ja/01_project_lessons_log.md`（およびその他の青写真）を編集し、プロジェクト固有の要件を定義します。

4.  **開発開始 (Start)**: AI開発チームは、これらのルールを厳格に遵守して開発を行います。

### 🇺🇸 English Guide (Usage in English)

1.  **Copy**: Copy the `antigravity-rules/` folder and `GEMINI.md` (and `.cursorrules` for Cursor users) to your project root.
    *   `cp -r antigravity-rules GEMINI.md .cursorrules /path/to/your/project/`

2.  **Initialize**:
    *   **Edit `GEMINI.md`**: Set `Project Native Language` to `English`.
    *   **Cleanup**: Delete the unused Japanese language directory.
        *   `rm -rf antigravity-rules/universal/ja antigravity-rules/blueprint/ja`
3.  **Configure**: Edit `antigravity-rules/blueprint/en/01_project_lessons_log.md` (and other blueprints) to define your project's specifics.

4.  **Develop**: The AI Development Team will strictly adhere to these rules.

