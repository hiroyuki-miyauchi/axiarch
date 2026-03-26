# 000. Blueprint Index

> [!NOTE]
> **Map to the Brain**:
> This directory is the project's "brain" (specifications and insights).
> `universal/` rules are the **"Constitution"** — immutable principles shared across all projects.
> `blueprint/` rules are the **"Laws"** — concretizing the constitution and customized to project-specific needs.
> Sparse Numbering ensures future extensibility.

---

## 📑 Table of Contents

1. [Category 000: Governance & Logs](#-category-000-governance--logs-000009)
2. [Category 100: Quality & Safety](#-category-100-quality--safety-100199)
3. [Category 200: Design & UX](#-category-200-design--ux-200299)
4. [Category 300: Engineering Core](#-category-300-engineering-core-300399)
5. [Category 400: AI & Content](#-category-400-ai--content-400499)
6. [Category 500: Business & Growth](#-category-500-business--growth-500599)
7. [Category 600–800: Feature Specifications](#-category-600800-feature-specifications-600899)
8. [Category 900: Templates & Appendix](#-category-900-templates--appendix-900999)
9. [Operational Guide](#operational-guide)
10. [Appendix A: Reverse Lookup Index & Cross-References](#appendix-a-reverse-lookup-index--cross-references)

---

## 📂 Category 000: Governance & Logs (000–009)

Manages the project's constitution, lessons, and history.

- [000. Project Overview & Constitution](000_project_overview.md) - Project vision, tech stack, immutable principles.
- [001. Project Lessons Log](010_project_lessons_log.md) - Accumulated "lessons learned" and "anti-patterns" from development.

## 📂 Category 100: Quality & Safety (100–199)

Defense line supporting "trust" and "quality".

> Examples: Security, legal compliance, localization quality, FinOps, Observability, etc.

## 📂 Category 200: Design & UX (200–299)

Defines user "experience" and "brand".

> Examples: Design system, accessibility (A11y), etc.

## 📂 Category 300: Engineering Core (300–399)

Defines the "skeleton" and "blood flow" of the system.

> Examples: System architecture/Gateway patterns, data modeling, development workflow, etc.

## 📂 Category 400: AI & Content (400–499)

Strategy for generating next-generation "value".

> Examples: AI safety/ethics, CMS strategy, SEO/GEO optimization, etc.

## 📂 Category 500: Business & Growth (500–599)

Pursues "sustainability (revenue)".

> Examples: Monetization strategy, growth marketing, etc.

## 📂 Category 600–800: Feature Specifications (600–899)

Defines the core logic of specific "features".

> Examples: Core feature specifications, domain-specific design specs, etc.

## 📂 Category 900: Templates & Appendix (900–999)

- [999. Project Specific Template](999_project_specific_template.md) - Template for adding new rule files.

---

## Operational Guide

### Initial Setup
1. Set `Project Native Language` in `GEMINI.md`
2. **Delete the unused language folder (`ja/` or `en/`)**
3. Rewrite `000_project_overview.md` to match your project

### Adding New Specifications
1. Copy `999_project_specific_template.md`
2. Rename the file following the category numbering above (e.g., `600_feature_payment.md`)
3. Fill in each template section with project-specific content
4. **Add an entry to the appropriate category in this file (INDEX.md)**

### Recording Lessons
- At work completion or important decisions, append to `010_project_lessons_log.md` in the prescribed format
- Mandatory reflection based on the "Continuous Improvement" process in `GEMINI.md`

---

## Appendix A: Reverse Lookup Index & Cross-References

### Reverse Lookup Index (Keyword → File)

| Keyword | Corresponding File |
|---|---|
| Project overview, vision, tech stack | `000_project_overview.md` |
| Lessons, anti-patterns, retrospectives | `010_project_lessons_log.md` |
| New specification template | `999_project_specific_template.md` |
| Security, compliance | Add to Category 100 |
| Design system, A11y | Add to Category 200 |
| System architecture, API design | Add to Category 300 |
| AI strategy, CMS | Add to Category 400 |
| Monetization, growth | Add to Category 500 |
| Feature specifications (domain-specific) | Add to Category 600–800 |

### Cross-References (Blueprint → Universal Mapping)

| Blueprint Category | Related Universal Rules |
|---|---|
| 000 Governance | `000_core_mindset`, `801_governance` |
| 100 Quality & Safety | `600_security_privacy`, `601_data_governance`, `602_oss_compliance`, `700_qa_testing` |
| 200 Design & UX | `200_design_ux` |
| 300 Engineering | `300_engineering_standards`, `301_api_integration`, `320_supabase_architecture`, `340_web_frontend`, `360_firebase_gcp`, `361_aws_cloud` |
| 400 AI & Content | `400_ai_engineering`, `401_data_analytics`, `341_headless_cms` |
| 500 Business | `100_product_strategy`, `101_revenue_monetization`, `102_growth_marketing` |
| 600–800 Feature Specs | Refer to relevant Universal rules per domain |
| 900 Templates | — |

---

**Last Updated**: 2026-03-24
**Structure**: Sparse Numbering (3-digit) system.
**Total Files**: 4 (including INDEX)
