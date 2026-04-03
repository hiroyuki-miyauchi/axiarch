# Project Lessons Log

This file aggregates critical lessons, anti-patterns, and newly established operational rules obtained through project development.
Based on the "Continuous Improvement — Auto-Crystallization Protocol" in `AGENTS.md`, the AI autonomously manages this file.

> [!IMPORTANT]
> **Auto-Crystallization Protocol**
>
> This file functions as a **lesson index and temporary accumulation point**.
> When lessons of the **same domain reach 3 or more**, the AI autonomously:
>
> 1. Creates a new domain file (`0X0_lessons_{domain}.md`)
> 2. Moves the relevant lessons to the new file
> 3. Adds a reference link to this index
>
> **The operator (user) needs to do nothing.** The AI automatically builds a domain-organized structure.

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
<!-- Example: | 020 | DB & Auth | [020_lessons_database_auth.md](./020_lessons_database_auth.md) | 5 | -->

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
**Rule:** Comply with `AGENTS.md` and `rampart-rules` protocols as the absolute source of truth.

---

## Appendix A: Reverse Index & Cross-Reference

### Recommended Domain Categories

| Domain | Typical Lessons | Related Universal Rules |
|:-------|:---------------|:-----------------------|
| DB & Auth | Schema design, migrations, RLS, auth flows | `320_supabase`, `600_security` |
| Security | Vulnerabilities, incidents, privacy | `600_security_privacy` |
| Architecture | Design decisions, ADRs, layer design | `300_engineering_standards` |
| Quality | Test strategy, bug regression, code review | `700_qa_testing` |
| Design | UI/UX decisions, design system, A11y | `200_design_ux` |
| Operations | CI/CD, deployment, SRE, incident response | `502_site_reliability` |
| Governance | Rule operations, protocol improvements | `801_governance` |
| Performance | Speed optimization, memory, cost | `300_engineering`, `720_finops` |
| FinOps | Cloud costs, resource efficiency | `720_cloud_finops` |

### Cross-Reference (Related Universal Rules)

| Category | Related Universal Rule |
|:---------|:---------------------|
| Crystallization Process | `AGENTS.md` §8 Continuous Improvement — Auto-Crystallization Protocol |
| Core Principle Violations | `000_core_mindset` |
| Security Lessons | `600_security_privacy` |
| Performance Lessons | `300_engineering_standards`, `700_qa_testing` |
| Design Decision Lessons | Refer to the Universal rule of the target domain |

---

## Appendix B: Domain File Template

> [!IMPORTANT]
> **Structural Compliance Requirement**
>
> When the AI creates a new domain file (`0X0_lessons_{domain}.md`), it **MUST** use the template below.
> This ensures AI-navigable consistency across all domain files — matching the structural standards of `universal/` rules.

```markdown
# Lessons: {Domain Name} ({日本語ドメイン名})

> **Domain**: {domain}
> **Created**: {YYYY-MM-DD} (Auto-Crystallized from 010_project_lessons_log.md)
> **Related Universal Rules**: `{rule_file_1}`, `{rule_file_2}`

---

## 📑 Table of Contents

1. [Lessons](#lessons)
2. [Cross-Reference](#cross-reference)

---

## Lessons

### [YYYY-MM-DD] Lesson Title
**Domain:** {domain}
**Context:** ...
**Problem:** ...
**Solution/Rule:** ...
**Reference:** ...

---

## Cross-Reference

| Related File | Relationship |
|:-------------|:------------|
| `{universal_rule}.md` | Governing rule for this domain |
| `010_project_lessons_log.md` | Index (source of crystallization) |
```
