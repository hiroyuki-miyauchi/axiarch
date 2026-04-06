# 100. Project Specific Rules Template

> [!TIP]
> Copy this file to the corresponding domain folder in `axiarch-rules/blueprint/{lang}/`. Rename the file according to the folder's internal sequence (e.g., `quality/000_security_policy.md`).
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

### Blueprint Folder & Numbering Guide

| Folder | Range | Category | Examples |
|:--------|:------|:--------|:------|
| `governance/` | 000–099 | Governance & Logs | Project overview, lessons log |
| `quality/` | 000–099 | Quality & Safety | Security policy, compliance |
| `design/` | 000–099 | Design & UX | Design system, A11y |
| `engineering/` | 000–099 | Engineering Core | System architecture, API design |
| `ai/` | 000–099 | AI & Content | AI strategy, CMS |
| `product/` | 000–099 | Business & Growth | Monetization, marketing |
| `specs/` | 000–099 | Feature Specs | Domain-specific design |
| `templates/` | 000–099 | Templates & Appendix | Template files |

> **Folder-local numbering (consistent with Universal convention)**: Within each folder, use `000_`, `100_`, `200_`... in 100-unit increments. Do NOT use global numbering across folders.
