# 999. Project Specific Rules Template

> [!TIP]
> This file is intended to be copied to the `rampart-rules/blueprint/` directory for use. Rename it following the category numbering bands (e.g., `100_security_policy.md`).
> The `universal/` rules are the "Constitution," while this `blueprint/` is the "Law," where you concretize (or exceptionally override) the Constitution for the project's specific circumstances.

---

## 📑 Table of Contents

1. [Project Overview](#1-project-overview)
2. [Tech Stack Decisions](#2-tech-stack-decisions)
3. [Design System Overrides](#3-design-system-overrides)
4. [Business KPIs](#4-business-kpis)
5. [Security & Legal Specifics](#5-security--legal-specifics)
6. [Appendix A: Reverse Lookup Index & Cross-References](#appendix-a-reverse-lookup-index--cross-references)

---

## 1. Project Overview
*   **Project Name**: [Project Name]
*   **Mission (Why)**:
    *   [Why does this project exist? What problem does it solve?]
*   **Target Audience (Who)**:
    *   [Who is the product for? Persona definition]
*   **Value Proposition**:
    *   [What is the primary benefit for the user?]

## 2. Tech Stack Decisions
*   **Frontend**: Next.js (App Router) / Flutter
*   **Backend**: Firebase / Supabase / AWS
*   **Database**: Firestore / PostgreSQL
*   **Reasoning**:
    *   [Why was this technology chosen? Consistency with Universal Rules?]

## 3. Design System Overrides
*   **Brand Colors**:
    *   Primary: `[Hex Code]`
    *   Secondary: `[Hex Code]`
*   **Typography**:
    *   Font Family: `[Font Name]`
*   **Exceptions**:
    *   [If there are special reasons to deviate from the Universal Rule design provisions, describe them here]

## 4. Business KPIs
*   **North Star Metric**:
    *   [The single metric to measure project success]
*   **Unit Economics Targets**:
    *   LTV Target: `[Amount]`
    *   CAC Target: `[Amount]`

## 5. Security & Legal Specifics
*   **Data Types**:
    *   [Personal info, payment info, health info, etc.]
*   **Applicable Regulations**:
    *   [GDPR, CCPA, APPI, etc.]

---

## Appendix A: Reverse Lookup Index & Cross-References

### Reverse Lookup Index (Keyword → Section)

| Keyword | Section |
|---|---|
| Vision, mission, persona | §1 Project Overview |
| Tech selection, framework | §2 Tech Stack Decisions |
| Brand colors, font, design exceptions | §3 Design System Overrides |
| KPI, LTV, CAC, unit economics | §4 Business KPIs |
| Personal data, regulations, GDPR, APPI | §5 Security & Legal |

### Cross-References (Section → Universal Rules)

| Section | Related Universal Rules |
|---|---|
| §1 Project Overview | `000_core_mindset`, `100_product_strategy` |
| §2 Tech Stack | `300_engineering_standards`, `320_supabase_architecture`, `340_web_frontend`, `342_mobile_flutter`, `360_firebase_gcp`, `361_aws_cloud` |
| §3 Design Overrides | `200_design_ux` |
| §4 Business KPIs | `100_product_strategy`, `101_revenue_monetization` |
| §5 Security & Legal | `600_security_privacy`, `601_data_governance`, `602_oss_compliance` |

### Blueprint Category Numbering Bands (File Naming Guide)

| Number Band | Category | Example Usage |
|---|---|---|
| 000–009 | Governance & Logs | Project overview, lessons log |
| 100–199 | Quality & Safety | Security policy, compliance |
| 200–299 | Design & UX | Design system, A11y |
| 300–399 | Engineering | System architecture, API design |
| 400–499 | AI & Content | AI strategy, CMS |
| 500–599 | Business & Growth | Monetization, marketing |
| 600–899 | Feature Specs | Domain-specific design |
| 900–999 | Templates & Appendix | Templates |
