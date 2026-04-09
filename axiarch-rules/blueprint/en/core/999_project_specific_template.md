# 999. Project Specific Rules Template

> [!TIP]
> Copy this file to the corresponding domain folder in `axiarch-rules/blueprint/{lang}/`. Rename the file according to the folder's internal sequence (e.g., `security/010_security_policy.md`).
> Rules in `universal/` are the "Constitution," while `blueprint/` is the "Laws" — the place to concretize (or exceptionally override) the Constitution for project-specific context.

---

## 📑 Table of Contents

1. [Project Overview](#1-project-overview)
2. [Tech Stack Decisions](#2-tech-stack-decisions)
3. [Design System Overrides](#3-design-system-overrides)
4. [Business KPIs](#4-business-kpis)
5. [Security & Legal Specifics](#5-security--legal-specifics)
6. [Appendix A: Quick Reference & Cross-References](#appendix-a-quick-reference--cross-references)

---

## 1. Project Overview
*   **Project Name**: [Project Name]
*   **Mission (Why)**:
    *   [Why does this project exist? What problem does it solve?]
*   **Target Users (Who)**:
    *   [Who is this product for? Persona definition]
*   **Core Value Proposition**:
    *   [What is the greatest benefit users gain?]

## 2. Tech Stack Decisions
*   **Frontend**: Next.js (App Router) / Flutter
*   **Backend**: Firebase / Supabase / AWS
*   **Database**: Firestore / PostgreSQL
*   **Reasoning**:
    *   [Why was this technology chosen? How does it align with Universal rules?]

## 3. Design System Overrides
*   **Brand Colors**:
    *   Primary: `[Hex Code]`
    *   Secondary: `[Hex Code]`
*   **Typography**:
    *   Font Family: `[Font Name]`
*   **Exceptions**:
    *   [Document any special reasons for deviating from Universal design rules here]

## 4. Business KPIs
*   **North Star Metric**:
    *   [The single metric that measures project success]
*   **Unit Economics Targets**:
    *   LTV Target: `[Amount]`
    *   CAC Target: `[Amount]`

## 5. Security & Legal Specifics
*   **Data Types Handled**:
    *   [Personal data, payment information, medical records, etc.]
*   **Applicable Regulations**:
    *   [GDPR, CCPA, HIPAA, PCI-DSS, etc.]

---

## Appendix A: Quick Reference & Cross-References

### Quick Reference (Keyword → Section)

| Keyword | Corresponding Section |
|---|---|
| Vision, mission, persona | §1 Project Overview |
| Tech selection, framework | §2 Tech Stack |
| Brand colors, fonts, design exceptions | §3 Design System Overrides |
| KPI, LTV, CAC, unit economics | §4 Business KPIs |
| Personal data, regulations, GDPR, CCPA | §5 Security & Legal |

### Cross-References (Section → Universal Rules)

| Section | Related Universal Rules |
|---|---|
| §1 Project Overview | `core/000_core_mindset`, `product/000_product_strategy` |
| §2 Tech Stack | `engineering/000_engineering_standards`, `engineering/200_supabase_architecture`, `engineering/400_mobile_flutter` |
| §3 Design Overrides | `design/000_design_ux` |
| §4 Business KPIs | `product/000_product_strategy`, `product/300_revenue_monetization` |
| §5 Security & Legal | `security/000_security_privacy`, `security/100_data_governance`, `security/200_oss_compliance` |

### Blueprint Folder & File Naming Guide

> [!IMPORTANT]
> **Reserved numbers**: `998` and `999` are reserved for templates (`998_feature_spec_template.md`, `999_project_specific_template.md`).
> All other numbers (`010`–`997`) are **freely available regardless of purpose**. Both project-specific rules and feature specs use the same sequential numbering within each folder.

| Folder | Available Numbers | Examples |
|:--------|:------------|:------|
| `core/` | 010–997 | Lessons log (`010_`), crystallized rules, project-specific settings |
| `security/` | 010–997 | Security policies, security feature specs |
| `engineering/` | 010–997 | System-specific rules, engineering feature specs |
| `design/` | 010–997 | Design system overrides, design feature specs |
| `quality/` | 010–997 | Test strategy overrides, QA feature specs |
| `operations/` | 010–997 | SRE, CI/CD overrides, operations feature specs |
| `product/` | 010–997 | Business rules, feature specs (most common placement) |
| `ai/` | 010–997 | AI strategy overrides, AI feature specs |

> **Numbering rule**: Within each folder, use `010_`, `020_`, `030_`... in **10-unit increments** (to reserve insertion gaps for future files). Do NOT use global numbering across folders.

