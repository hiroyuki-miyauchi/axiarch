# Axiarch Development Rules (Master Index)

> [!IMPORTANT]
> **The Three-Layer Governance Architecture**
> This folder (`axiarch-rules/`) contains the governance rules of the Axiarch framework.
> The clear separation of concerns between "Immutable Constitution (Layer 1)", "Project-Specific Rules (Layer 2)", and "Optional Prompts (Layer 3)" is the heart of Axiarch — it helps reduce hallucination and quality-drift risk while supporting a quality baseline for long-term autonomous operation.
> The minimum execution requirement for Axiarch is compliance with Layer 1 and Layer 2; all other extensions such as Layer 3 (Prompts) are entirely optional.
>
> **Separation of Concerns (AI Agent Instructions)**:
>
> *   **Layer 1: Universal Rules (`universal/`)**:
>     *   **Status**: **Immutable** / Immutable Constitution. Defines the baseline of universal principles and constraint levels. Read-Only for Project Tasks.
>     *   **Action**: AI MUST NOT edit these files unless explicitly instructed to "Amend Constitution".
> *   **Layer 2: Blueprint Rules (`blueprint/`)**:
>     *   **Status**: **Mutable** / Evolving Project State.
>     *   **Action**: AI SHOULD create and edit these files to accumulate project context and lessons.

> **Language Standard**:
> All rules are provided in **Japanese and English** to ensure global scalability and clear communication.

## 📂 Rule Modules

### 📚 Layer 1: Universal Rules (Immutable Constitution)

#### Core & Mindset
*   **000. Core Philosophy & Mindset** ([🇯🇵](../ja/universal/core/000_core_mindset.md) / [🇺🇸](./universal/core/000_core_mindset.md))

#### Business & Growth
*   **100. Product & Business Strategy** ([🇯🇵](../ja/universal/product/000_product_strategy.md) / [🇺🇸](./universal/product/000_product_strategy.md))
*   **101. Revenue & Monetization** ([🇯🇵](../ja/universal/product/300_revenue_monetization.md) / [🇺🇸](./universal/product/300_revenue_monetization.md))
*   **102. Growth & Marketing** ([🇯🇵](../ja/universal/product/500_growth_marketing.md) / [🇺🇸](./universal/product/500_growth_marketing.md))
*   **103. App Store Compliance & ASO** ([🇯🇵](../ja/universal/product/700_appstore_compliance.md) / [🇺🇸](./universal/product/700_appstore_compliance.md))
*   **110. Market Validation & PMF** ([🇯🇵](../ja/universal/product/100_market_validation.md) / [🇺🇸](./universal/product/100_market_validation.md))
*   **120. Go-to-Market Strategy** ([🇯🇵](../ja/universal/product/200_go_to_market.md) / [🇺🇸](./universal/product/200_go_to_market.md))
*   **130. Pricing Strategy** ([🇯🇵](../ja/universal/product/400_pricing_strategy.md) / [🇺🇸](./universal/product/400_pricing_strategy.md))
*   **140. Brand Strategy** ([🇯🇵](../ja/universal/product/600_brand_strategy.md) / [🇺🇸](./universal/product/600_brand_strategy.md))
*   **150. Fundraising & IR** ([🇯🇵](../ja/universal/product/900_fundraising_ir.md) / [🇺🇸](./universal/product/900_fundraising_ir.md))

#### Design & UX
*   **200. Design & UX Strategy** ([🇯🇵](../ja/universal/design/000_design_ux.md) / [🇺🇸](./universal/design/000_design_ux.md))

#### Engineering Core
*   **300. Engineering Standards** ([🇯🇵](../ja/universal/engineering/000_engineering_standards.md) / [🇺🇸](./universal/engineering/000_engineering_standards.md))
*   **301. API Integration** ([🇯🇵](../ja/universal/engineering/100_api_integration.md) / [🇺🇸](./universal/engineering/100_api_integration.md))
*   **320. Supabase & PostgreSQL** ([🇯🇵](../ja/universal/engineering/200_supabase_architecture.md) / [🇺🇸](./universal/engineering/200_supabase_architecture.md))
*   **340. Web Frontend (Next.js)** ([🇯🇵](../ja/universal/engineering/300_web_frontend.md) / [🇺🇸](./universal/engineering/300_web_frontend.md))
*   **341. Headless CMS** ([🇯🇵](../ja/universal/engineering/310_headless_cms.md) / [🇺🇸](./universal/engineering/310_headless_cms.md))
*   **342. Mobile (Flutter)** ([🇯🇵](../ja/universal/engineering/400_mobile_flutter.md) / [🇺🇸](./universal/engineering/400_mobile_flutter.md))
*   **343. Native Platforms (Kotlin/Swift)** ([🇯🇵](../ja/universal/engineering/410_native_platforms.md) / [🇺🇸](./universal/engineering/410_native_platforms.md))
*   **360. Firebase & GCP** ([🇯🇵](../ja/universal/engineering/500_firebase_gcp.md) / [🇺🇸](./universal/engineering/500_firebase_gcp.md))
*   **361. AWS Cloud** ([🇯🇵](../ja/universal/engineering/510_aws_cloud.md) / [🇺🇸](./universal/engineering/510_aws_cloud.md))

#### AI & Data
*   **400. AI Engineering** ([🇯🇵](../ja/universal/ai/000_ai_engineering.md) / [🇺🇸](./universal/ai/000_ai_engineering.md))
*   **401. Data & Analytics** ([🇯🇵](../ja/universal/ai/100_data_analytics.md) / [🇺🇸](./universal/ai/100_data_analytics.md))

#### Operations & Reliability
*   **500. Internal Tools** ([🇯🇵](../ja/universal/operations/000_internal_tools.md) / [🇺🇸](./universal/operations/000_internal_tools.md))
*   **501. Customer Experience** ([🇯🇵](../ja/universal/operations/300_customer_experience.md) / [🇺🇸](./universal/operations/300_customer_experience.md))
*   **502. Site Reliability** ([🇯🇵](../ja/universal/operations/400_site_reliability.md) / [🇺🇸](./universal/operations/400_site_reliability.md))
*   **503. Incident Response** ([🇯🇵](../ja/universal/operations/500_incident_response.md) / [🇺🇸](./universal/operations/500_incident_response.md))
*   **510. Sales & Business Development** ([🇯🇵](../ja/universal/operations/100_sales_bizdev.md) / [🇺🇸](./universal/operations/100_sales_bizdev.md))
*   **520. HR & Organization** ([🇯🇵](../ja/universal/operations/200_hr_organization.md) / [🇺🇸](./universal/operations/200_hr_organization.md))
*   **530. Partnership & Ecosystem** ([🇯🇵](../ja/universal/operations/700_partnership_ecosystem.md) / [🇺🇸](./universal/operations/700_partnership_ecosystem.md))

#### Security & Legal
*   **600. Security & Privacy** ([🇯🇵](../ja/universal/security/000_security_privacy.md) / [🇺🇸](./universal/security/000_security_privacy.md))
*   **601. Data Governance** ([🇯🇵](../ja/universal/security/100_data_governance.md) / [🇺🇸](./universal/security/100_data_governance.md))
*   **602. OSS Compliance** ([🇯🇵](../ja/universal/security/200_oss_compliance.md) / [🇺🇸](./universal/security/200_oss_compliance.md))
*   **603. IP & Due Diligence** ([🇯🇵](../ja/universal/security/300_ip_due_diligence.md) / [🇺🇸](./universal/security/300_ip_due_diligence.md))

#### Testing, QA & FinOps
*   **700. QA & Testing** ([🇯🇵](../ja/universal/quality/000_qa_testing.md) / [🇺🇸](./universal/quality/000_qa_testing.md))
*   **720. Cloud FinOps** ([🇯🇵](../ja/universal/operations/600_cloud_finops.md) / [🇺🇸](./universal/operations/600_cloud_finops.md))

#### Global & Governance
*   **800. Internationalization** ([🇯🇵](../ja/universal/product/800_internationalization.md) / [🇺🇸](./universal/product/800_internationalization.md))
*   **801. Governance** ([🇯🇵](../ja/universal/core/100_governance.md) / [🇺🇸](./universal/core/100_governance.md))
*   **802. Language Protocol** ([🇯🇵](../ja/universal/core/200_language_protocol.md) / [🇺🇸](./universal/core/200_language_protocol.md))


### 📐 Layer 2: Blueprint Rules (Mutable Project State)

> Adopts a subdirectory structure symmetric with `universal/`. See [blueprint/INDEX.md (JA)](../ja/blueprint/INDEX.md) / [blueprint/INDEX.md](./blueprint/INDEX.md) for details.

*   **000. Project Overview** ([🇯🇵](../ja/blueprint/core/000_project_overview.md) / [🇺🇸](./blueprint/core/000_project_overview.md))
*   **010. Project Lessons Log** ([🇯🇵](../ja/blueprint/core/010_project_lessons_log.md) / [🇺🇸](./blueprint/core/010_project_lessons_log.md))
*   **998. Feature Specification Template** ([🇯🇵](../ja/blueprint/core/998_feature_spec_template.md) / [🇺🇸](./blueprint/core/998_feature_spec_template.md))
*   **999. Project Specific Template** ([🇯🇵](../ja/blueprint/core/999_project_specific_template.md) / [🇺🇸](./blueprint/core/999_project_specific_template.md))

### 📋 Reference Documents
*   **[INDEX.md](./INDEX.md)** — Detailed index of all rules
*   **[LOADING_PROTOCOL.md](./LOADING_PROTOCOL.md)** — 5-step rule loading protocol
*   **[CRYSTALLIZATION_PROTOCOL.md](./CRYSTALLIZATION_PROTOCOL.md)** — Lesson auto-crystallization protocol
*   **[Compliance Matrix](./compliance_matrix.md)** — User request ↔ Rule file mapping

---

## 🚀 Axiarch Setup & Initialization

> [!NOTE]
> This framework's primary targets are OpenAI Codex, Claude Code, and Google Antigravity. All three are production-validated primary targets through real operational usage. This validation describes the configurations and scope Axiarch has exercised; it is not an operation guarantee for every environment. Cursor, GitHub Copilot, and Windsurf are extended pointer candidates, not verified or operation-guaranteed platforms.

1.  **Copy**: The minimal required setup is `AXIARCH.md`, the `AGENTS.md` adapter, `axiarch-rules/`, and `axiarch-harness/`. Copy `axiarch-manifest.json` and `axiarch-scripts/` when you want safe-upgrade support. `axiarch-prompts/` is optional.
    ```bash
    cp AXIARCH.md AGENTS.md /path/to/your/project/
    cp -r axiarch-rules axiarch-harness /path/to/your/project/

    # Recommended when using safe upgrades
    cp axiarch-manifest.json /path/to/your/project/
    cp -r axiarch-scripts /path/to/your/project/

    # Optional: cp -r axiarch-prompts /path/to/your/project/
    ```
    For existing adopter projects, use `axiarch-scripts/axiarch-upgrade.sh` to update Axiarch-owned files such as Universal rules and scripts while preserving project-owned Blueprint state by default.

2.  **Agent Rules Pointer Setup**:
    If your AI agent tool (e.g., Antigravity) auto-loads `.agents/rules/`, place a **pointer file** to reference `AXIARCH.md`.
    ```bash
    # Create .agents/rules/ directory
    mkdir -p /path/to/your/project/.agents/rules

    # Place prompt_pointer.md as a pointer (copy from this repo's .agents/rules/)
    # NOTE: AXIARCH.md is the canonical entrypoint. Only pointers go in .agents/rules/.
    cp .agents/rules/prompt_pointer.md /path/to/your/project/.agents/rules/prompt_pointer.md
    ```

    > [!CAUTION]
    > **DO NOT create new rule files in `.agents/rules/`.**
    > Rule body additions/edits MUST be made in `axiarch-rules/`, loaded through `AXIARCH.md`.
    > `.agents/rules/` is strictly a **pointer to AXIARCH.md**, NOT the rules themselves.

3.  **Initialize**:
    *   **Project Native Language**: When using `init.sh`, the selected language is written into `AXIARCH.md` automatically. For manual copy, set `Project Native Language` in `AXIARCH.md` to `English`. Legacy adopters may use `AGENTS.md` as a fallback.
    *   **Cleanup**: Keep both Japanese and English directories by default. Review and remove unused language directories only when intentionally fixing the project to single-language operation. (Do the same if you included the prompt library)
        Examples to review for an English-only project: `axiarch-rules/ja` and `axiarch-harness/ja`, plus `axiarch-prompts/ja` if you copied the prompt library.

4.  **Configure**: Edit `axiarch-rules/en/blueprint/core/000_project_overview.md` to define your project overview, and prepare `axiarch-rules/en/blueprint/core/010_project_lessons_log.md` as the starting point for lesson recording.

5.  **Develop**: The AI Development Team will strictly adhere to these rules.

---

### 📁 Post-Setup Directory Structure

```
your-project/
 ├── AXIARCH.md                   ← Canonical entrypoint
 ├── AGENTS.md                    ← Adapter for AGENTS.md readers
 ├── .agents/
 │    └── rules/
 │         └── prompt_pointer.md  ← Pointer to AXIARCH.md
 ├── axiarch-rules/           ← Rule Definitions
 │    ├── en/                 ← English rules
 │    │    ├── INDEX.md
 │    │    ├── README.md
 │    │    ├── LOADING_PROTOCOL.md
 │    │    ├── CRYSTALLIZATION_PROTOCOL.md
 │    │    ├── universal/     ← Layer 1: Immutable
 │    │    │    ├── core/
 │    │    │    ├── product/
 │    │    │    ├── engineering/
 │    │    │    └── ...
 │    │    └── blueprint/     ← Layer 2: Mutable State
 │    │         └── core/
 │    └── ja/                 ← Japanese rules (kept by default)
 ├── axiarch-harness/         ← Execution, audit, evidence, and approval workflow
 │    ├── en/
 │    └── ja/                 ← Kept by default
 ├── axiarch-prompts/         ← Layer 3: Optional Execution Engine
 │    ├── ja/ (or en/)
 │    │    ├── develop/      ← Development & Execution
 │    │    ├── audit/        ← Quality Auditing
 │    │    ├── govern/       ← Governance
 │    │    └── operate/      ← Incidents & Onboarding
 │    └── en/ (or ja/)        ← Optional; kept by default
 └── src/                         ← Your Code
```
