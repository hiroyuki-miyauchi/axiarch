# Crystallization Protocol

> [!IMPORTANT]
> This protocol is the detailed procedure for `AGENTS.md` §9 "Continuous Improvement".
> The AI MUST execute this autonomously when recording lessons.

---

## 📑 Table of Contents

1. [Overview](#overview)
2. [Auto-Crystallization Steps](#auto-crystallization-steps)
3. [Crystallized Rule File Template](#crystallized-rule-file-template)
4. [Structural Requirements](#structural-requirements)
5. [Examples](#examples)

---

## 🚨 HIGHEST-PRIORITY RULE: Practical Experience Only

> [!CAUTION]
> Crystallization is **strictly limited to problems, decisions, and discoveries encountered during actual task execution**.
> AI **MUST NOT** independently research and add "best practices" **without explicit user instruction**.
> The only exception is when the user explicitly instructs the AI to research and add content.

**Allowed (✅ — examples):**
- Bugs encountered during implementation and their solutions
- Design decisions with reasoning for the choice made
- Constraints discovered during integration with existing code
- Issues found during deployment or testing

**Prohibited (❌ — examples, without explicit user instruction):**
- "Recommendations" generated from AI's general knowledge
- Preventive rules for problems that haven't actually occurred
- Best practices the AI independently researched from external documentation
- "Should do" ideals not grounded in actual pain

**Litmus Test:**
> "Does this lesson describe **what actually happened** during this task?" → Yes = record. No = do NOT record.

---

## Overview

Accumulating all lessons in a single file causes unbounded growth and context window pressure.
This protocol defines the procedure for separating lessons into the appropriate Blueprint domain folder and keeping them easier to reference without relying too heavily on operator skill.

**Design Philosophy: Co-location Principle**
Lessons are placed in the **same folder** as the rule files they relate to.
When AI loads any domain folder (e.g., `engineering/` for DB/Architecture tasks, `security/` for Security tasks), it finds both rules AND historical lessons there — improving context efficiency.

---

## Auto-Crystallization Steps

```
┌────────────────────────────────────────────────────────────────┐
│  Step 1: CLASSIFY (Classification)                             │
│  Determine domain → identify target Blueprint folder           │
│  DB & Auth → engineering/ / Security → security/               │
│  QA & Testing → quality/ / Design → design/                    │
│  ... (See Step 1 mapping table)                                │
├────────────────────────────────────────────────────────────────┤
│  Step 2: DEDUP CHECK (Universal Dedup Check)                   │
│  Check if similar rule already exists in universal/            │
│  ├── Exists → Skip (dedup). Done.                              │
│  └── Not found → Proceed to Step 3                             │
├────────────────────────────────────────────────────────────────┤
│  Step 3: SEARCH (Search Existing Files)                        │
│  Does a domain file exist in the target Blueprint folder?      │
│  ├── YES → Append to it. Done.                                 │
│  └── NO  → Proceed to Step 4                                   │
├────────────────────────────────────────────────────────────────┤
│  Step 4: ACCUMULATE (Temporary Accumulation)                   │
│  Append to core/010_project_lessons_log.md                     │
│  Always include Domain / Target Folder tags                    │
├────────────────────────────────────────────────────────────────┤
│  Step 5: THRESHOLD CHECK (Threshold Check)                     │
│  Have 3+ same-domain lessons accumulated in core/010?          │
│  ├── YES → Create {NNN}_{topic}.md in target folder            │
│  │         Leave only reference link in core/010               │
│  └── NO  → Keep in core/010                                    │
├────────────────────────────────────────────────────────────────┤
│  Step 6: UPDATE INDEX (Update Index)                           │
│  Update "Separated Domain Files" table in core/010             │
└────────────────────────────────────────────────────────────────┘
```

---

### Step 1: CLASSIFY

Determine the lesson's domain and identify the corresponding Blueprint folder.

**Domain to Blueprint Folder Mapping:**

| Domain | Blueprint Folder | Example File Name |
|:----------------|:--------------|:----------------|
| DB & Auth | `engineering/` | `engineering/{NNN}_database_auth.md` |
| Architecture | `engineering/` | `engineering/{NNN}_architecture_rules.md` |
| API Design | `engineering/` | `engineering/{NNN}_api_design.md` |
| Performance | `engineering/` | `engineering/{NNN}_performance_policy.md` |
| Security | `security/` | `security/{NNN}_security_policy.md` |
| Quality & QA | `quality/` | `quality/{NNN}_qa_rules.md` |
| FinOps | `operations/` | `operations/{NNN}_finops_policy.md` |
| Design | `design/` | `design/{NNN}_design_rules.md` |
| AI & Content | `ai/` | `ai/{NNN}_ai_content_rules.md` |
| Business & Growth | `product/` | `product/{NNN}_business_policy.md` |
| Operations | `operations/` | `operations/{NNN}_operations_rules.md` |
| Core & Governance | `core/` | `core/{NNN}_governance_rules.md` (010 is fixed as index, use 020+) |

> **How to determine `{NNN}` (Contextual Numbering)**: The AI MUST check existing files in the target folder and assign a number close to related topics (default to increments of 10 to leave room, but use interstitial numbers like `011` or `015` if space is tight). Do not strictly force increments of 10.
> All files including crystallized files may use any available number from `000`–`999`. **Do not include `lessons_` in the file name**. Use only topic names describing the content.

> **Folder Extensibility**: The 8 folders above are pre-provisioned as the initial structure, but this is **NOT a closed list**. If lessons accumulate for a domain not covered by the mapping table above, the AI MAY **propose** a new folder to the user (autonomous creation is prohibited). However, classification into existing folders should always be prioritized first, and proposals must clearly distinguish actual folder names from examples.

---

### Step 2: DEDUP CHECK (Universal Dedup Check)

Before recording, check whether a **similar rule already exists** in `universal/` under the corresponding domain folder. Universal is the "Constitution" — content already covered there does NOT need to be duplicated in Blueprint.

**Decision Criteria:**
- Similar rule exists in Universal → **Do NOT record** (dedup). Done.
- Not in Universal, or project-specific context needed → **Proceed to Step 3**

---

### Step 3: SEARCH (Search Existing Files)

If a rule file for the same domain already exists in the **Blueprint folder identified in Step 1**, append to that file.

**Search Examples:**
- DB-related lesson → search within `blueprint/engineering/`
- Security lesson → search within `blueprint/security/`
- Design lesson → search within `blueprint/design/`
- Governance lesson → search within `blueprint/core/` (excluding `core/010_project_lessons_log.md`)

---

### Step 4: ACCUMULATE (Temporary Accumulation)

If no domain lessons file exists, temporarily append to `core/010_project_lessons_log.md` until the threshold is reached.

**Required Format:**

```markdown
### [YYYY-MM-DD] Lesson Title
**Domain:** {domain}
**Target Folder:** blueprint/{folder}/  ← specify destination folder
**Context:** The situation where the problem occurred
**Problem:** The specific issue
**Solution/Rule:** The solution or rule established
**Reference:** Related files or commits
```

---

### Step 5: THRESHOLD CHECK

Lessons in `core/010_project_lessons_log.md` (central index) MUST be promoted to a proper rule file in the **corresponding Blueprint folder** (per the Step 1 mapping table) when **either** of the two triggers below fires:

| Trigger | Condition | Detected by |
|:--|:--|:--|
| **(a) Count Trigger** | Same domain accumulates **3 or more** entries | `check-axiarch-health.sh` Check 6 / `axiarch-boot-reminder.sh` Check B |
| **(b) Time-Axis Trigger (v1.6.0+)** | Any single lesson dated **180+ days ago** in `[YYYY-MM-DD]` | `check-axiarch-health.sh` Check 6 / `axiarch-boot-reminder.sh` Check C |

**Why the Time-Axis Trigger?** Once existing sublimated files become comprehensive enough to absorb new lessons, the count trigger fires less often, and individual lessons can sit in `core/010` indefinitely. Threshold tunable via `AXIARCH_LESSON_STALE_DAYS` (default 180; `0` disables Check C).

> [!CAUTION]
> **🚨 "Just appended" is NOT completion — Step 5 MUST run before declaring task done**
>
> A common past failure: AI assumes "I appended to `core/010`, crystallization done" and never executes Step 5 — letting 3+ same-domain lessons accumulate without promotion. **Step 4 (ACCUMULATE) alone is NOT completion.** Before returning the final response of every task, AI MUST execute Step 5 (THRESHOLD CHECK), and if **either** (a) 3+ unsorted lessons in any domain **or** (b) any lesson dated 180+ days ago exists, **promote them to a dedicated Blueprint file BEFORE declaring task completion**.
>
> Violations are externally detectable via `bash axiarch-scripts/check-axiarch-health.sh` Check 6. Declaring task completion while either threshold is breached = **protocol violation**.

> [!CAUTION]
> **Autonomous New Domain Folder Creation Prohibited**: Blueprint initial folders (`ai/`, `core/`, `design/`, `engineering/`, `operations/`, `product/`, `quality/`, `security/`) are **pre-provisioned** with the same structure as Universal (each containing a `README.md`). AI is **prohibited** from **autonomously** creating new domain folders. Lessons MUST normally be placed in existing folders defined in the Step 1 mapping table, or in a new folder explicitly approved by the user. If a completely new domain arises that cannot be classified into existing folders, the AI MAY **propose** creating a new folder to the user (see Step 1 "Folder Extensibility").

**Numbering Rules:**
- **🚨 No Blank Zones**: Use `000`-`999` independently per domain (no domain-specific reserved bands).
- **Contextual Numbering**: Check existing files in the target folder and assign a number close to related topics (default to increments of 10, but use interstitial numbers like `011` or `015` if space is tight). Do not strictly force increments of 10.
- `core/010_project_lessons_log.md` (central index) is fixed. Crystallized files in `core/` start from `020_`.
- **Do not include `lessons_` in the file name**. Use only topic names describing the content (e.g., `database_auth`, `security_policy`, `api_design`).

**Creation Example:**
```
# When 3 DB lessons accumulate in core/010:
Create: axiarch-rules/{lang}/blueprint/engineering/010_database_auth.md  (Elevate lessons to proper rule)
Leave only a reference link in core/010:
  "→ Elevated to engineering/010_database_auth.md"
```

> **Note**: Blueprint numbering is **independent within each Blueprint folder** and unrelated to Universal folder numbering.

---

### Step 6: UPDATE INDEX

Update the "Separated Domain Files" table in `core/010_project_lessons_log.md`.

---

## Crystallized Rule File Template

> [!IMPORTANT]
> When the AI creates a new domain file, it **MUST strictly follow this template**.
> Maintain structural consistency equivalent to `universal/` rule files for AI navigability.

```markdown
# {NNN}. {Topic Name}

> [!NOTE]
> This file is a Blueprint Rule (project-specific rule).
> Auto-crystallized from `core/010_project_lessons_log.md`.
> Created: {YYYY-MM-DD}

> [!IMPORTANT]
> **Domain**: {domain}
> **Location**: `blueprint/{folder}/{NNN}_{topic}.md`
> **Related Universal Rules**: `universal/{domain}/{rule_file_1}.md`, `universal/{domain}/{rule_file_2}.md`
> **{N} sections.**

---

## 📒 Table of Contents

| Section | Content | Count |
|:---------|:-----|:--:|
| Lessons | Crystallized rules & lessons | {N} |
| Appendix A | Quick Reference & Cross-References | 1 |

---

## Lessons

### [YYYY-MM-DD] Lesson Title
**Domain:** {domain}
**Context:** ...
**Problem:** ...
**Solution/Rule:** ...
**Reference:** ...

---

## Appendix A: Quick Reference & Cross-References

### Quick Reference (Keyword → Section)

| Keyword | Section | Related Rule |
|:---------|:------------|:---------|
| {keyword_1} | Lessons — {lesson_title} | `{universal_folder}/{rule_file}.md` |

### Cross-References

| Related File | Relationship |
|:-----------|:-----|
| `{universal_folder}/{rule_file}.md` | Governing Rule (Universal) |
| `core/010_project_lessons_log.md` | Index (crystallization origin) |
```

---

## Structural Requirements

> [!CAUTION]
> When creating domain files, the following structural requirements **MUST** be met.

### 1. Header Metadata

| Required | Description |
|:-------------------|:-------------------|
| `Domain` | Domain name (matching Step 1 category) |
| `Location` | Actual file path (`blueprint/{folder}/{NNN}_{topic}.md`) |
| `Created` | Creation date + "Auto-Crystallized from core/010" note |
| `Related Universal Rules` | Related Universal rule file names (including folder path) |

### 2. Cross-Reference Table

- A cross-reference table MUST be placed at the end of every file
- MUST include a link back to `core/010`
- MUST include links to related Universal rules

### 3. Consistency with Universal Rules

- MUST include a `## Table of Contents` section (table or list format)
- Section headings MUST use `##` level
- Each lesson MUST use `###` level

### 4. Structural Isomorphism (Appendix A Obligation)

> [!IMPORTANT]
> When reflecting rules (whether crystallizing, creating new, or appending), verify that the created/modified file follows the **same structural pattern** as other Constitution files (Universal / Blueprint). Fill in any missing structural elements.

**Standard Structural Pattern of Universal Files (extracted from examples):**

| # | Required Element | Description | Universal Example |
|:--|:-----------|:-----|:--------------|
| 1 | **Title Line** `# {NNN}. {Name}` | H1 heading at file start. Number + Name | `# 74. Language Protocol`, `# 30. Engineering Standards`, `# 60. Security and Privacy` |
| 2 | **CAUTION/NOTE Block** | File positioning declaration (Universal=CAUTION, Blueprint=NOTE/TIP) | `> [!CAUTION] This file is a Universal Rule (immutable rule).` |
| 3 | **IMPORTANT Block** | Primary Directive + structure summary (`{N} parts, {M} sections.`) | `> [!IMPORTANT] Primary Directive...13 parts, 80 sections.` |
| 4 | **`## Table of Contents`** | Table format (Part/Section/Line count) or list format TOC | `## Table of Contents` + `| Part | Topic | Section | Count |` |
| 5 | **Body Sections** `## Part {N}:` or `## §{N}.` | `##` for major sections, `###` for subsections | `## Part I: Code Quality and Clean Code`, `## §1. Primary Directive & Priorities` |
| 6 | **`## Appendix A: Quick Reference`** | Keyword → Section → Related Rule reverse lookup table | `| Keyword | Section | Related Rule |` |

**Litmus Test**: "When placed alongside Universal files like `000_engineering_standards.md` or `200_language_protocol.md`, does this file look structurally consistent?" → If not, align it.

---

## Examples

### Auto-Separation Example

**Before (3 DB lessons accumulated in core/010):**

```
blueprint/core/010_project_lessons_log.md:
  ### [2026-01-15] RLS Policy Design Mistake
  Domain: DB & Auth | Target Folder: engineering/

  ### [2026-02-03] Migration Order Dependencies
  Domain: DB & Auth | Target Folder: engineering/

  ### [2026-02-20] auth.uid() Performance Issue
  Domain: DB & Auth | Target Folder: engineering/

  ### [2026-01-20] API Key Leak Risk
  Domain: Security | Target Folder: security/  ← Only 1, kept in place
```

**After (AI auto-executes):**

```
blueprint/
├── core/
│   └── 010_project_lessons_log.md
│       ← Index only remains. DB lesson entries replaced with reference links.
│         Security lesson still here (only 1 entry).
└── engineering/
    └── 300_database_auth.md  ← 3 DB lessons moved here (auto-created)

※ security/ folder has no lessons file yet (only 1 security lesson)

core/010 "Separated Domain Files" table updated:
  | DB & Auth | engineering/300_database_auth.md | 3 entries |
```

> **Why not put everything in `core/`**:
> By co-locating DB lessons in `engineering/` and security lessons in `security/`,
> the AI automatically picks up past lessons when loading `engineering/` for engineering tasks.
> If everything were in `core/`, lessons would only be accessible by loading `core/` every time,
> significantly reducing context efficiency.
