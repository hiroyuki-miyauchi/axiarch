# 000. Blueprint Index

> [!NOTE]
> **Map to the Brain**:
> This directory is your project's "brain" (specifications and lessons learned).
> `universal/` rules are the **"Constitution"** — immutable principles common to all projects.
> `blueprint/` rules are the **"Laws"** — concrete implementations that customize the Constitution for your project's specific needs.
> Sparse Numbering preserves room for future extension.
> **The initial structure maps to the same 8 folders as `universal/`**. However, Blueprint is the mutable project-specific layer; when a new domain cannot reasonably fit existing folders, a user-approved new folder may be added.

---

## 📑 Table of Contents

1. [Directory Structure](#-directory-structure)
2. [core/: Core Specs & Logs](#-core-core-specs--logs)
3. [security/: Security & Rights](#-security-security--rights)
4. [engineering/: Engineering Core](#-engineering-engineering-core)
5. [design/: Design & UX](#-design-design--ux)
6. [quality/: QA & Testing](#-quality-qa--testing)
7. [operations/: Operations & Incidents](#-operations-operations--incidents)
8. [product/: Business & Requirements](#-product-business--requirements)
9. [ai/: AI & Content](#-ai-ai--content)
10. [Operational Guide](#operational-guide)
11. [Appendix A: Reverse Lookup & Cross-References](#appendix-a-reverse-lookup--cross-references)

---

## 📁 Directory Structure

```
blueprint/
├── core/            ← Project overview, lessons log, templates
├── security/        ← Security policies, compliance
├── engineering/     ← System architecture, API design
├── design/          ← Design system, A11y
├── quality/         ← QA standards, testing
├── operations/      ← SRE, incidents
├── product/         ← Monetization, GTM
├── ai/              ← AI strategy
└── INDEX.md         ← This file
```

> **Initial Mapping with Universal**: 1:1 mapping with the 8 folders in `universal/` (`core/`, `security/`, `engineering/`, `design/`, `quality/`, `operations/`, `product/`, `ai/`).
> The "Constitution (Universal)" is concretized by "Project-Specific Rules (Blueprint)" at the initial folder-name level. This is the starting structure, and Blueprint may be extended with user approval.

---

## 📂 core/: Core Specs & Logs

Project overview, lessons index, and templates.

| File | Description |
|:-----|:------------|
| [core/000_project_overview.md](core/000_project_overview.md) | Project vision, tech stack, and immutable principles |
| [core/010_project_lessons_log.md](core/010_project_lessons_log.md) | Lessons index + unsorted lesson accumulation. Origin point for Crystallization. |
| [core/998_feature_spec_template.md](core/998_feature_spec_template.md) | **Feature spec template (Blueprint First core)**. Copy to the relevant domain folder to use. |
| [core/999_project_specific_template.md](core/999_project_specific_template.md) | Template for adding project-specific rule files. |

---

## 📂 security/: Security & Rights

Security policies, role management, legal compliance.

> Related Universal: `security/`

---

## 📂 engineering/: Engineering Core

The "skeleton" and "blood flow" of the system.

> Related Universal: `engineering/`

---

## 📂 design/: Design & UX

User "experience" and "brand" definitions.

> Related Universal: `design/`

---

## 📂 quality/: QA & Testing

The defensive line supporting "trust" and "quality".

> Related Universal: `quality/`

---

## 📂 operations/: Operations & Incidents

SRE, incident management, operational requirements.

> Related Universal: `operations/`

| File | Description |
|:--|:--|
| [operations/010_release_upgrade_operations.md](operations/010_release_upgrade_operations.md) | Release and upgrade operations rules covering CHANGELOG parity, dry-run side effects, interactive input, local-only file review, source-only default skip, explicit selection, source-repository-only file classification, EOF-safe confirmation defaults, Git tracking checks for source release-critical files, and deduplicated interactive choices |

---

## 📂 product/: Business & Requirements

Monetization strategy, growth requirements.

> Related Universal: `product/`

---

## 📂 ai/: AI & Content

Strategies for generating next-generation "value".

> Related Universal: `ai/`

---

## Operational Guide

### Initial Setup
1. Set `Project Native Language` in `AXIARCH.md`. Legacy adopters may use `AGENTS.md` as a fallback
2. Keep both Japanese and English directories by default. Review and remove `axiarch-rules/{unused-lang}/` and `axiarch-harness/{unused-lang}/`, plus `axiarch-prompts/{unused-lang}/` when prompts are installed, only when intentionally fixing the project to single-language operation. If both languages are kept, prioritize the folder matching `Project Native Language`
3. Rewrite `core/000_project_overview.md` with your project's content

### Adding Feature Specs (Blueprint First)
1. **Copy `core/998_feature_spec_template.md`**
2. Place it in the relevant domain folder (e.g., `product/020_feature_payment.md` *Note: Use any available number from 000 to 999; there are no domain-specific numbering bands.*)
3. **Write §3 Acceptance Criteria first** — do NOT write code while this section is empty
4. Fill in remaining sections (data model, API design, test strategy, etc.)
5. **Add an entry to the relevant folder section in this INDEX.md**

### Adding Project-Specific Rules
1. Copy `core/999_project_specific_template.md`
2. Place it in the corresponding folder with a number (e.g., `security/010_security_policy.md` *Note: Use any available number from 000 to 999; there are no domain-specific numbering bands.*)
3. Fill each template section with project-specific content
4. **Add an entry to the relevant folder section in this INDEX.md**

### Recording Lessons (Crystallization)
- Append to `core/010_project_lessons_log.md` at task completion or when key decisions are made
- When 3+ lessons of the same domain accumulate, the AI creates a proper rule file in the corresponding existing or user-approved domain folder
- See `axiarch-rules/{lang}/CRYSTALLIZATION_PROTOCOL.md` for detailed procedures

---

## Appendix A: Reverse Lookup & Cross-References

### Reverse Lookup (Keyword → File/Folder)

| Keyword | File/Folder |
|:--------|:-----------|
| Project overview, vision, tech stack | `core/000_project_overview.md` |
| Lessons, anti-patterns, retrospectives | `core/010_project_lessons_log.md` |
| Feature spec template | `core/998_feature_spec_template.md` |
| Project-specific rule template | `core/999_project_specific_template.md` |
| Security, compliance | `security/` |
| System architecture, API design | `engineering/` |
| Design system, A11y | `design/` |
| QA, testing strategy | `quality/` |
| SRE, operations, incidents | `operations/` |
| Monetization, growth | `product/` |
| AI strategy, CMS | `ai/` |

### Cross-References (Blueprint → Universal Initial Mapping)

| Blueprint | Universal |
|:----------|:----------|
| `core/` | `core/` |
| `security/` | `security/` |
| `engineering/` | `engineering/` |
| `design/` | `design/` |
| `quality/` | `quality/` |
| `operations/` | `operations/` |
| `product/` | `product/` |
| `ai/` | `ai/` |

---

**Last Updated**: 2026-06-08
**Version**: v1.12.1 — Harness Engineering wording, diagnostics, and Safe Upgrade label parity patch (v1.12.0: AXIARCH.md canonical entrypoint and Execution Harness / Harness Engineering support, v1.11.2: multi-agent detection fix for the Safe Upgrade execution prompt, v1.11.0: Release-upgrade Operations Blueprint registration, shared Blueprint / Project State boundary alignment, and current-task document rotation)
**Structure**: Domain-based initial subdirectories (8 initial domains, extensible with user approval)
