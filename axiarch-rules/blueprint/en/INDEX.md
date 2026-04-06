# 000. Blueprint Index

> [!NOTE]
> **Map to the Brain**:
> This directory is the project's "brain" (specifications and knowledge).
> Rules in `universal/` are the **"Constitution"** — universal, immutable principles shared across all projects.
> Rules in `blueprint/` are the **"Laws"** — they concretize the Constitution and customize it for project-specific context.
> Sparse Numbering ensures future extensibility.
> **Adopts a subdirectory structure symmetric with `universal/`.**

---

## 📑 Table of Contents

1. [Directory Structure](#-directory-structure)
2. [governance/: Governance & Logs (000–009)](#-governance-governance--logs-000009)
3. [quality/: Quality & Safety (100–199)](#-quality-quality--safety-100199)
4. [design/: Design & UX (200–299)](#-design-design--ux-200299)
5. [engineering/: Engineering Core (300–399)](#-engineering-engineering-core-300399)
6. [ai/: AI & Content (400–499)](#-ai-ai--content-400499)
7. [product/: Business & Growth (500–599)](#-product-business--growth-500599)
8. [specs/: Feature Specifications (600–899)](#-specs-feature-specifications-600899)
9. [templates/: Templates & Appendix (900–999)](#-templates-templates--appendix-900999)
10. [Operational Guide](#operational-guide)
11. [Appendix A: Quick Reference & Cross-References](#appendix-a-quick-reference--cross-references)

---

## 📁 Directory Structure

```
blueprint/en/
├── governance/      ← 000s: Project overview, lessons log, Crystallization-generated files
├── quality/         ← 100s: Security policy, compliance, QA standards
├── design/          ← 200s: Design system, accessibility, brand definitions
├── engineering/     ← 300s: System architecture, API design, data models
├── ai/              ← 400s: AI strategy, CMS strategy, SEO/GEO
├── product/         ← 500s: Monetization, growth marketing, GTM
├── specs/           ← 600–800s: Feature specifications (domain-specific design)
├── templates/       ← 900s: Template files
└── INDEX.md         ← This file (always in the root)
```

> **Symmetry with Universal**: Mirrors the `universal/en/` structure (`core/`, `product/`, `design/`, `engineering/`, `ai/`, `operations/`, `security/`, `quality/`).
> The "Laws (Blueprint) concretizing the Constitution (Universal)" relationship is now visually clear at the folder level.

---

## 📂 governance/: Governance & Logs (000–009)

Manages the project's overview, lessons index, and history. Lesson domain files are auto-generated to their **corresponding domain folders** (e.g., `engineering/`) per the **Co-location Principle**. Lessons are NOT consolidated into this folder.

| File | Description |
|:----|:-----------|
| [000_project_overview.md](governance/000_project_overview.md) | Project vision, tech stack, and immutable principles |
| [010_project_lessons_log.md](governance/010_project_lessons_log.md) | Lessons index + unsorted lesson accumulation. The origin point for Crystallization. |
| `020_{topic}.md` ← auto-elevated | AI creates a proper project rule file autonomously when 3+ governance-domain lessons accumulate. For other domains (DB, Security, etc.), lessons are elevated into the corresponding domain folder as proper rule files. |

---

## 📂 quality/: Quality & Safety (100–199)

The defensive line supporting "trust" and "quality."

> Examples: Security policy, legal compliance, localization quality, FinOps standards, Observability
>
> Corresponding Universal: `security/`, `quality/`

---

## 📂 design/: Design & UX (200–299)

Defines the user "experience" and "brand."

> Examples: Design system overrides, accessibility (A11y) policies
>
> Corresponding Universal: `design/`

---

## 📂 engineering/: Engineering Core (300–399)

Defines the "skeleton" and "circulatory system" of the product.

> Examples: System architecture, gateway patterns, data modeling, development workflow
>
> Corresponding Universal: `engineering/`

---

## 📂 ai/: AI & Content (400–499)

The strategy for generating next-generation "value."

> Examples: AI safety & ethics, CMS strategy, SEO/GEO optimization
>
> Corresponding Universal: `ai/`

---

## 📂 product/: Business & Growth (500–599)

Pursues "sustainability (revenue)."

> Examples: Monetization strategy, growth marketing
>
> Corresponding Universal: `product/`, `operations/`

---

## 📂 specs/: Feature Specifications (600–899)

Defines the core logic of concrete "features."

> Examples: Core feature specs, domain-specific design specifications
> Created by copying `templates/000_feature_spec_template.md`.

---

## 📂 templates/: Templates & Appendix (900–999)

| File | Description |
|:----|:-----------|
| [000_feature_spec_template.md](templates/000_feature_spec_template.md) | **Feature Spec Template (SDD core)**. Defines acceptance criteria, data model, API design, and test strategy per feature. Copy to `specs/` to use. |
| [100_project_specific_template.md](templates/100_project_specific_template.md) | Template for adding project-specific rule files. |

---

## Operational Guide

### Initial Setup
1. Set `Project Native Language` in `AGENTS.md`
2. **Delete the unused language folder (`ja/` or `en/`)**
3. Rewrite `governance/000_project_overview.md` with your project's content

### Adding Feature Specs (Blueprint First in Practice)
1. **Copy `templates/000_feature_spec_template.md`**
2. Rename the file in the `specs/` folder using a 600–800 number (e.g., `specs/600_feature_payment.md`)
3. **Write §3 Acceptance Criteria first** — never write code while this section is empty
4. Fill in remaining sections (data model, API design, test strategy, etc.)
5. **Add an entry to the `specs/` section in this INDEX.md**

### Adding Project-Specific Rules
1. Copy `templates/100_project_specific_template.md`
2. Place it in the corresponding folder with a number (e.g., `quality/100_security_policy.md`)
3. Fill in each template section with project-specific content
4. **Add an entry to the corresponding folder section in this INDEX.md**

### Recording Lessons (Crystallization)
- Append to `governance/010_project_lessons_log.md` at task completion or when key decisions are made
- When 3+ lessons of the same domain accumulate, the AI autonomously creates a proper project rule file (`{NNN}_{topic}.md`) in the appropriate domain folder and moves the lessons there (no `lessons_` in the filename; e.g., `engineering/300_database_auth.md`, `quality/100_security_policy.md`)
- See `axiarch-rules/CRYSTALLIZATION_PROTOCOL.md` for detailed procedure

---

## Appendix A: Quick Reference & Cross-References

### Quick Reference Index (Keyword → File/Folder)

| Keyword | Corresponding File/Folder |
|:--------|:------------------------|
| Project overview, vision, tech stack | `governance/000_project_overview.md` |
| Lessons, anti-patterns, retrospectives | `governance/010_project_lessons_log.md` |
| Security policy, compliance | `quality/` |
| Design system, accessibility | `design/` |
| System architecture, API design | `engineering/` |
| AI strategy, CMS | `ai/` |
| Monetization, growth | `product/` |
| Feature specifications (domain-specific) | `specs/` |
| Feature spec template, acceptance criteria | `templates/000_feature_spec_template.md` |
| Project-specific rule template | `templates/100_project_specific_template.md` |

### Cross-References (Blueprint Folder → Corresponding Universal)

| Blueprint Folder | Category | Corresponding Universal |
|:---------------|:--------|:----------------------|
| `governance/` | 000 Governance | `core/` (`000_core_mindset`, `100_governance`, `200_language_protocol`) |
| `quality/` | 100 Quality & Safety | `security/`, `quality/` |
| `design/` | 200 Design & UX | `design/` |
| `engineering/` | 300 Engineering | `engineering/` |
| `ai/` | 400 AI & Content | `ai/` |
| `product/` | 500 Business & Growth | `product/`, `operations/` |
| `specs/` | 600–800 Feature Specs | Refer to relevant Universal rules per domain |
| `templates/` | 900 Templates | — |

---

**Last Updated**: 2026-04-06
**Version**: v1.0.0 — Domain-based subdirectory structure (symmetric with Universal)
**Structure**: Domain-based subdirectories + Sparse Numbering (3-digit) system.
