# Project Lessons Log

This file is an **index plus a temporary accumulation point for unsorted** critical lessons, anti-patterns, and newly established operational rules obtained through project development. It is NOT a place to accumulate all lessons forever. Once 3 or more lessons of the same domain accumulate, they are crystallized into a proper rule file in the corresponding Blueprint folder, and only a reference link remains here.
Based on `axiarch-rules/{lang}/CRYSTALLIZATION_PROTOCOL.md` loaded from `AXIARCH.md`, the AI autonomously manages this file.

> The canonical procedure for classification, deduplication, searching existing rules, count/age promotion and index updates is `axiarch-rules/{lang}/CRYSTALLIZATION_PROTOCOL.md`. Read and update an appropriate existing rule when available. This log temporarily holds unsorted lessons; placement alone does not load content. Updates depend on agent adherence; diagnostics inspect recorded structure and thresholds.

---

## 📑 Table of Contents

1. [Separated Domain Files](#separated-domain-files)
2. [Unsorted Lessons](#unsorted-lessons)
3. [Appendix A: Reverse Index & Cross-Reference](#appendix-a-reverse-index--cross-reference)
4. [Appendix B: Domain File Template](#appendix-b-domain-file-template)

---

## Separated Domain Files

> [!NOTE]
> The agent updates this table when promoting lessons. No script automatically creates or updates these rule files.

| # | Domain | File | Count |
|:--|:-------|:-----|:------|
| 1 | Operations | [operations/010_release_upgrade_operations.md](../operations/010_release_upgrade_operations.md) | 13 |
| 2 | Governance | [core/020_governance_rules.md](./020_governance_rules.md) | 4 |

<!-- AUTO-CRYSTALLIZATION: When creating a domain file, add a row to the table above -->
<!-- Example: | 1 | DB & Auth | `engineering/010_database_auth.md` | 3 | -->

---

## Unsorted Lessons

> [!TIP]
> **Lesson Entry Format**
> When adding a new lesson, use the format below.
> **Always include `Domain:` and `Target Folder:` tags.** This is the classification key for auto-separation.
>
> ### [YYYY-MM-DD] Lesson Title
> **Domain:** DB & Auth / Security / Architecture / Quality / Design / Operations / Governance / Performance / Other
> **Target Folder:** blueprint/{existing-target-folder}/
> **Context:** The situation or background where the problem occurred
> **Problem:** The specific issue or failure
> **Solution/Rule:** The solution, or the rule established to reduce recurrence risk
> **Reference:** Related files or commits (if any)

---

> [!NOTE]
> Governance lessons reached the threshold and were elevated to [core/020_governance_rules.md](./020_governance_rules.md).
> Keep this section empty as the temporary accumulation point for new unsorted lessons.

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

> [!NOTE]
> The numbers in the "Related Universal Rules" column (e.g., `engineering/200_...`) are the numbers of the referenced Universal rules. The numbering of the Blueprint file created when crystallizing a lesson is decided by context per `axiarch-rules/{lang}/CRYSTALLIZATION_PROTOCOL.md` and is NOT bound to these numbers (use any available 000–999 within the folder).

### Cross-Reference (Related Universal Rules)

| Category | Related Universal Rule |
|:---------|:---------------------|
| Crystallization Process | `axiarch-rules/{lang}/CRYSTALLIZATION_PROTOCOL.md` |
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
> "Crystallized Rule File Template" section of `axiarch-rules/{lang}/CRYSTALLIZATION_PROTOCOL.md`.
>
> The inline template previously listed here has been retired to reduce structural drift risk.
> **Always treat `axiarch-rules/{lang}/CRYSTALLIZATION_PROTOCOL.md` as the Single Source of Truth for templates.**
