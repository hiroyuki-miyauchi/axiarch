# 00. Blueprint Index

> [!NOTE]
> **Map to the Brain**:
> This directory is the project's "Brain (specifications and knowledge)."
> The `universal/` rules are the **"Constitution"** — immutable principles common to all projects.
> The `blueprint/` rules are the **"Law"** — a place to concretize the Constitution and customize it for project-specific circumstances.
> Sparse Numbering (Gap-10) ensures future extensibility.

---

## 📂 Category 0: Governance & Logs (00-09)

Manages the project's constitution, lessons, and history.

- [00. Project Overview & Constitution](00_project_overview.md) - Project vision, tech stack, immutable principles.
- [01. Project Lessons Log](01_project_lessons_log.md) - Accumulated "lessons" and "anti-patterns" from development.

## 📂 Category 1: Quality & Safety (10-19)

The defense line supporting "trust" and "quality."

> Examples: Security, legal compliance, localization quality, FinOps, Observability, etc.

## 📂 Category 2: Design & UX (20-29)

Defines the user "experience" and "brand."

> Examples: Design system, Accessibility (A11y), etc.

## 📂 Category 3: Engineering Core (30-39)

Defines the system's "skeleton" and "blood flow."

> Examples: System architecture, Gateway patterns, data modeling, development workflow, etc.

## 📂 Category 4: AI & Content (40-49)

Strategies for generating next-generation "value."

> Examples: AI safety & ethics, CMS strategy, SEO/GEO optimization, etc.

## 📂 Category 5: Business & Growth (50-59)

Pursues "sustainability (revenue)."

> Examples: Monetization strategy, growth marketing, etc.

## 📂 Category 6-8: Feature Specifications (60-89)

Defines the core logic of specific "features."

> Examples: Core feature specs, domain-specific design specifications, etc.

## 📂 Category 9: Templates & Appendix (90-99)

- [99. Project Specific Template](99_project_specific_template.md) - Template for adding new rule files.

---

## Operational Guide

### Initial Setup
1. Set the `Project Native Language` in `GEMINI.md`
2. **Delete the unused language folder (`ja/` or `en/`)**
3. Rewrite `00_project_overview.md` with your project's content

### Adding New Specification Documents
1. Copy `99_project_specific_template.md`
2. Rename the file following the category numbering above (e.g., `60_feature_payment.md`)
3. Fill in each template section with project-specific content
4. **Add an entry to the corresponding category in this INDEX.md**

### Recording Lessons
- Upon task completion or important decisions, append to `01_project_lessons_log.md` using the prescribed format
- Mandatory review based on the "Continuous Improvement" process in `GEMINI.md`

---

**Last Updated**: [YYYY-MM-DD]
**Structure**: Sparse Numbering (Gap-10) system.
**Total Files**: 4 (including INDEX)
