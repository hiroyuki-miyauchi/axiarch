# Project Lessons Log

This file aggregates critical lessons, anti-patterns, and newly established operational rules obtained through project development.
Based on the "Continuous Improvement — Auto-Crystallization Protocol" in `AGENTS.md`, the AI autonomously manages this file.

> [!IMPORTANT]
> **Auto-Crystallization Protocol**
>
> This file functions as a **lesson index and temporary accumulation point**.
> When lessons of the **same domain reach 3 or more**, the AI autonomously:
>
> 1. Creates a proper project rule file in the **corresponding Blueprint domain folder**
>    e.g., DB & Auth lessons → `engineering/{NNN}_database_auth.md`
>    e.g., Security lessons → `security/{NNN}_security_policy.md`
> 2. Moves the relevant lessons to the new file
> 3. Adds a reference link to this index
>
> **Design Philosophy**: Lessons are Co-located with rules in the same folder. Consolidating everything here is NOT the intent.
> **The operator (user) needs to do nothing.** The AI automatically builds a domain-organized structure.
> See `axiarch-rules/CRYSTALLIZATION_PROTOCOL.md` for details.

---

## 📑 Table of Contents

1. [Separated Domain Files](#separated-domain-files)
2. [Unsorted Lessons](#unsorted-lessons)
3. [Appendix A: Reverse Index & Cross-Reference](#appendix-a-reverse-index--cross-reference)
4. [Appendix B: Domain File Template](#appendix-b-domain-file-template)

---

## Separated Domain Files

> [!NOTE]
> When 3+ lessons of the same domain accumulate, the AI automatically creates a domain-specific file.
> The link list below is updated automatically.

| # | Domain | File | Count |
|:--|:-------|:-----|:------|
| — | *(No separated domain files yet)* | — | — |

<!-- AUTO-CRYSTALLIZATION: When creating a domain file, add a row to the table above -->
<!-- Example: | 1 | DB & Auth | [engineering/010_database_auth.md](../engineering/200_supabase_architecture.md) | 3 | -->

---

## Unsorted Lessons

> [!TIP]
> **Lesson Entry Format**
> When adding a new lesson, use the format below.
> **Always include a `Domain:` tag.** This is the classification key for auto-separation.
>
> ### [YYYY-MM-DD] Lesson Title
> **Domain:** DB & Auth / Security / Architecture / Quality / Design / Operations / Governance / Performance / Other
> **Context:** The situation or background where the problem occurred
> **Problem:** The specific issue or failure
> **Solution/Rule:** The solution, or the rule established to prevent recurrence
> **Reference:** Related files or commits (if any)

---

### [Initial] Project Initialization Lesson
**Domain:** Governance
**Context:** New project or rule system refresh.
**Rule:** Comply with `AGENTS.md` and `axiarch-rules` protocols as the absolute source of truth.

---

## Appendix A: Reverse Index & Cross-Reference

### Recommended Domain Categories

| Domain | Typical Lessons | Related Universal Rules |
|:-------|:---------------|:-----------------------|
| DB & Auth | Schema design, migrations, RLS, auth flows | `engineering/200_supabase_architecture`, `security/000_security_privacy` |
| Security | Vulnerabilities, incidents, privacy | `security/000_security_privacy` |
| Architecture | Design decisions, ADRs, layer design | `engineering/000_engineering_standards` |
| Quality | Test strategy, bug regression, code review | `quality/000_qa_testing` |
| Design | UI/UX decisions, design system, A11y | `design/000_design_ux` |
| Operations | CI/CD, deployment, SRE, incident response | `operations/400_site_reliability` |
| Governance | Rule operations, protocol improvements | `core/100_governance` |
| Performance | Speed optimization, memory, cost | `engineering/000_engineering_standards`, `operations/600_cloud_finops` |
| FinOps | Cloud costs, resource efficiency | `operations/600_cloud_finops` |

### Cross-Reference (Related Universal Rules)

| Category | Related Universal Rule |
|:---------|:---------------------|
| Crystallization Process | `AGENTS.md` §9 Continuous Improvement — Auto-Crystallization Protocol |
| Core Principle Violations | `core/000_core_mindset` |
| Security Lessons | `security/000_security_privacy` |
| Performance Lessons | `engineering/000_engineering_standards`, `quality/000_qa_testing` |
| Design Decision Lessons | Refer to the Universal rule of the target domain |

---

## Appendix B: Domain File Template

> [!IMPORTANT]
> **Template Reference**
>
> When creating a new domain lessons file, **MUST** follow the official template in the
> "Crystallized Rule File Template" section of `axiarch-rules/CRYSTALLIZATION_PROTOCOL.md`.
>
> The inline template previously listed here has been retired to eliminate structural drift risk.
> **Always treat `CRYSTALLIZATION_PROTOCOL.md` as the Single Source of Truth for templates.**
