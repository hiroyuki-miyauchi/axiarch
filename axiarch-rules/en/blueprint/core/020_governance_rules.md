# 020. Governance Rules

> [!NOTE]
> This file is a Blueprint Rule (project-specific rule).
> Auto-crystallized from `core/010_project_lessons_log.md`.
> Created: 2026-06-12

> [!IMPORTANT]
> **Domain**: Governance
> **Location**: `blueprint/core/020_governance_rules.md`
> **Related Universal Rules**: `universal/core/000_core_mindset.md`, `axiarch-rules/en/universal/core/100_governance.md`
> **4 recorded lessons.**

---

## 📒 Table of Contents

| Section | Content | Count |
|:---------|:-----|:--:|
| Lessons | Crystallized rules & lessons | 4 |
| Appendix A | Quick Reference & Cross-References | 1 |

---

## Lessons

### [Initial] Project Initialization Lesson
**Domain:** Governance
**Context:** New project or rule system refresh.
**Rule:** Treat `AXIARCH.md` as the canonical Axiarch entrypoint and load the detailed protocol bodies from `axiarch-rules` through `AXIARCH.md`. Treat `AGENTS.md` as an adapter for compatible environments.

---

### [2026-06-08] Silent degradation of a strict rule during canonicalization, and multi-surface restoration
**Domain:** Governance
**Context:** When #46 canonicalized AGENTS.md into AXIARCH.md, the old §2 "Language First" was downgraded to a weak single §6.10 row (listing owner-facing documents only), losing its binding on the agent response surface (headings, summaries, labels, lists, tables) and its violation clause (an adopter reported "native-language adherence weakened").
**Problem:** Large canonicalizations/merges can silently degrade a strong prior rule without anyone noticing. During restoration, fixing only the canonical file (AXIARCH.md) and the reminder leaves the old wording stranded in peripheral surfaces such as the AI-facing digests (llms.txt / llms-full.txt) and the ja/en mirrors in ROADMAP.
**Solution/Rule:** (1) Under the §6.10 non-degradation principle, preserve the stricter older interpretation unless a replacement boundary is explicitly introduced. (2) Restore across ALL surfaces — canonical + reminder + AI-facing digests + ja/en mirrors. (3) Guard the restored invariant with a dedicated health-check (e.g., Check 16) that greps for it, so future silent removal/degradation is caught with EXIT_CODE=1.
**Reference:** #46 / v1.13.1 / AXIARCH.md §7.10 / axiarch-scripts/check-axiarch-health.sh Check 16

---

### [2026-06-12] Avoid conflating read-only subagent / security-scan fanout with the Human Approval Gate
**Domain:** Governance
**Context:** Codex can incorrectly decide that a formal Codex Security Deep Security Scan requires separate explicit subagent permission, stopping even when the user has requested a deep scan or exhaustive review and the fanout is read-only.
**Problem:** The Human Approval Gate exists to stop high-risk actions such as stage, commit, push, deploy, DB apply, production mutation, increased billing, and sensitive-boundary changes. Treating subagent or scan-tool usage itself as approval-gated blocks read-only research, role passes, audits, and verification, which weakens the Execution Harness instead of making it safer.
**Solution/Rule:** Read-only role passes, audits, security scans, and bounded subagent delegation may run without waiting for additional "explicit subagent permission" when the user requested that investigation and the workflow does not involve file writes, remote mutation, production access, install/auth, cost increase, or sensitive-data retrieval. When a named workflow such as Codex Security Deep Security Scan is explicitly invoked, its required read-only worker fanout is included in that request. If delegation is unavailable in the runtime, do not claim that the formal Deep Security Scan ran; fall back to the ordinary scan or main-agent sequential role passes.
**Reference:** AXIARCH.md §7.2 / §10, `axiarch-harness/{ja,en}/SUBAGENT_DELEGATION_PROTOCOL.md`, `axiarch-harness/{ja,en}/HUMAN_APPROVAL_GATE.md`, Codex Security `deep-security-scan/SKILL.md`

---

### [2026-09-11] Separate records, candidates, validation and guarantees
Domain: Governance
Target Folder: blueprint/core/
Context: The Axiarch consistency audit found missed English lessons, reminders asserting unread rules, a health condition requiring all three agents to be called validated, and broken heading references.
Problem: Wording-only checks can preserve a false specification as a passing condition. File presence, candidate discovery, actual reading and result verification are different facts.
Solution/Rule: State what diagnostics inspected and can decide; reconcile claims with the current owner-provided status and execution evidence. Do not use templates, heuristics or adapter presence as completion or practical-validation evidence. Pair wording checks with isolated behavioral and negative tests, covering both languages and additional categories through the same workflow.
Reference: `tests/test_consistency.py`, `tests/test_runtime.py`, `axiarch-scripts/axiarch_inspect.py`, `AXIARCH.md` §1.1

Same-day follow-up: negative tests found structure checks requiring current freshness from historical completions, and retry logic favoring an older base over recorded applied hashes after interruption. Separate current-evidence reconciliation from historical shape checks; exercise retries, concurrent execution and self-updates with actual inputs. This supplements the existing lesson without inflating its count. References: `axiarch-scripts/axiarch_state.py`, `axiarch-scripts/axiarch_upgrade.py`, `tests/test_runtime.py`.

---

Same-day setup follow-up: behavioral tests reproduced optional generation overwriting custom commands and later arguments overriding an explicit dry-run. Labels such as optional, safe or verified do not establish behavior; test collisions, missing input, selection scope and failure records. Do not infer ownership of legacy generated files; review their content before migration. References: `tests/test_setup.py`, `axiarch-scripts/axiarch_setup.py`.

## Appendix A: Quick Reference & Cross-References

### Quick Reference (Keyword → Section)

| Keyword | Section | Related Rule |
|:---------|:------------|:---------|
| AXIARCH.md, AGENTS.md, canonical entrypoint | Lessons — Project Initialization Lesson | `axiarch-rules/en/universal/core/100_governance.md` |
| Language First, silent degradation, Check 16 | Lessons — Silent degradation of a strict rule during canonicalization | `axiarch-rules/en/universal/core/100_governance.md` |
| subagent, Deep Security Scan, Human Approval Gate, fanout | Lessons — Avoid conflating read-only subagent / security-scan fanout with the Human Approval Gate | `universal/core/000_core_mindset.md`, `axiarch-rules/en/universal/core/100_governance.md` |
| candidates, validation, guarantees, diagnostics, bilingual | Lessons — Separate records, candidates, validation and guarantees | `axiarch-rules/en/universal/core/100_governance.md` |

### Cross-References

| Related File | Relationship |
|:-----------|:-----|
| `universal/core/000_core_mindset.md` | Higher-level principles for agent autonomy, authority, and approval boundaries |
| `axiarch-rules/en/universal/core/100_governance.md` | Higher-level principles for Axiarch rule operations and amendment control |
| `core/010_project_lessons_log.md` | Index (crystallization origin) |
| `AXIARCH.md` | Canonical entrypoint for execution, delegation, and approval boundaries |
| `axiarch-harness/{ja,en}/` | Execution Harness operational protocols |
