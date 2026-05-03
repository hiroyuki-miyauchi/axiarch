# LOADING_PROTOCOL.md — Rule Loading Protocol

> **This file defines the detailed rule loading procedure. Referenced from AGENTS.md §8.**

> Universal Rules is a comprehensive best-practice library across all major technology domains. The AI selectively loads only what each task requires, following LOADING_PROTOCOL. Rules for technologies your project doesn't currently use cause no harm — they are there when you need them.

---

## 🚨 BOOT SEQUENCE PROTOCOL 🚨

At the start of a conversation (new chat or after context reset), **you MUST follow these 3 principles and NOT begin any work until rules have been actually loaded.**

1. **Stop & Wait**: Do NOT immediately start modifications or audits. Read and understand the rules first, then act.

2. **No Hallucination**: Before the user provides clear code or file structure, it is **strictly prohibited** to speculatively generate and output "loaded rules list," "project structure," "tech stack overview," or any similar fabricated content.

3. **Exact Match Only**: Do NOT add extraneous text or independent interpretation. Use ONLY content actually read via tools as the basis for your actions.

---

## 🛡️ ENFORCEMENT MECHANISM 🛡️

**Projects adopting Claude Code ship with a `UserPromptSubmit` hook in `.claude/settings.json`**. The hook fires **on every user prompt submission**, injecting a system reminder that compels the AI to implicitly execute the AGENTS.md protocol (including this file's BOOT SEQUENCE).

Removing or disabling this hook is a **constitution-amending destructive change** requiring explicit owner approval.

When the hook is not present, the AI MUST self-enforce the BOOT SEQUENCE 3 principles autonomously.

> Other agents (Antigravity / Codex / Cursor / Copilot / Windsurf) have native loading mechanisms (e.g., Antigravity auto-loads `.agents/rules/`) and do not require this hook.

---

## Step 1: Task Classification

Read the user's instruction and classify it into the following task types. Select all that apply.

| Task Type | Criteria |
|:----------------------|:-------------|
| `security` | Security, authentication, authorization, RLS, encryption, vulnerability, audit |
| `architecture` | Design, architecture, DB design, migration, infrastructure |
| `performance` | Performance, optimization, SRE, monitoring, caching |
| `ui_design` | UI, UX, design system, layout, accessibility |
| `api` | API design, endpoints, schema, validation |
| `i18n` | Internationalization, localization, translation |
| `finops` | Cost optimization, billing, FinOps |
| `testing` | Testing, QA, E2E, unit tests |
| `other` | General tasks not matching the above |

---

## Step 2: INDEX-Based File Identification

Read `axiarch-rules/{lang}/INDEX.md` to understand the overall rule structure.

### Class-Based Scan & Load

| Class | Target | Nature |
|:------------|:-------------|:-----------|
| **Class S (Universal)** | `axiarch-rules/{lang}/universal/` | Universal rules transcending projects. Read-Only. |
| **Class A (Blueprint)** | `axiarch-rules/{lang}/blueprint/` | Project-specific specs, design, and lessons. Mutable. Basic folder structure (freely extensible/changeable based on project domains): **`core/`** (overview, lessons index & templates), `security/`, `engineering/`, `design/`, `quality/`, `operations/`, `product/`, `ai/`. Load by 4 categories: ① **Project Overview** (`core/000_project_overview.md`), ② **Lessons** (`core/010_project_lessons_log.md` index + domain rule files co-located as `{NNN}_{topic}.md`), ③ **Domain Rules**, ④ **Templates** |

From the INDEX.md categories that correspond to the task types identified in Step 1, list the files to load.

> ⚠️ **Important**: Reading INDEX.md is ONLY for "creating the load candidate list". The actual **file** content retrieval (loading) MUST be done in Step 3. Reading only INDEX.md and saying "understood" does NOT constitute load completion.

### Task-Type to Folder Mapping

| Task Type | Universal Folder | Blueprint Folder |
|:----------------------|:----------------|:----------------|
| `security` | `security/` | `security/` |
| `architecture` | `engineering/` | `engineering/` |
| `performance` | `engineering/` + `operations/` | `engineering/` + `operations/` |
| `ui_design` | `design/` | `design/` |
| `api` | `engineering/` | `engineering/` |
| `i18n` | `product/` | `product/` |
| `finops` | `operations/` | `operations/` |
| `testing` | `quality/` | `quality/` |
| `other` | — (autonomous decision based on task content) | `core/` (MUST load Project Overview + Lessons) |

---

## Step 3: File Loading

**Directly open each file identified in Step 2**, and autonomously select task-relevant sections from the file's table of contents or Appendix (reverse lookup index).

### 🚨 Anti-Laziness & Anti-Hallucination Mandate 🚨

- Considering a file "read" based solely on INDEX.md summaries is **strictly prohibited**.
- "Directly open the file" means actually retrieving the file's content using tools like `view_file`.
- **🚨 Absolute Output Ban (Anti-Hallucination)**: Outputting conversational text like "I am loading...", "Understood", or "Load complete" **before** the tool formally returns the file contents is **hallucination and strictly prohibited under any circumstances**. The AI MUST internalize the tool's execution result FIRST, and ONLY THEN generate thoughts or responses.
- The above applies to **all rule file references**, regardless of whether loading is autonomous or user-directed.

### Large File Handling

For large rule files exceeding 1,000 lines, first reference the Appendix or table of contents, then autonomously select and load only the task-relevant sections using line number ranges.

Examples:
- Authentication task → identify "OAuth" "JWT" "MFA" sections from TOC/index → load only those sections
- Cost optimization task → identify "FinOps" "Pricing" sections from index → load only 2–3 sections

### Cross-References

If a loaded file references related rules and they are relevant to the current task, load those as well.

---

## Step 4: Post-Load Verification (MANDATORY)

**After completing rule loading, record the following self-verification checklist in task.md. If any item is applicable but not loaded, STOP work and load the missing files.**

```markdown
## Load Self-Verification

- Task: [Describe in one line]
- Task Type: [security / architecture / performance / ui_design / api / i18n / finops / testing / other]
- Loaded Files:
  - [ ] [File path] — Loaded sections: [§XX, §YY]
  - [ ] [File path] — Loaded sections: [§XX]
- Relevant but not loaded: [File name and reason if any]
```

> **Load Completion Definition**: ALL of the following must be satisfied.
> 1. `blueprint/core/000_project_overview.md` was opened with `view_file` (REQUIRED for `other` type or **first load**; recommended for other task types). **"First load" means the first rule loading after conversation start (new chat or context reset).**
> 2. The domain rule file(s) corresponding to the task type from Step 1 were opened with `view_file`.
> 3. The list of loaded files is recorded in task.md.
>
> If any of ①②③ is missing, STOP and load the missing files.
> Note: If `000_project_overview.md` is still in its initial template state (`[Project Name]` unfilled), loading is considered complete, but prompt the user to configure it.

---

## Step 5: Begin Work

**Do NOT begin any code modifications or analysis until Steps 1–4 are complete.**

---

## ✅ Correct Loading Behavior Examples

### Example 1: Security Hardening Task

⬇️ User instruction: "Review the RLS policies"

1. **Task Classification**: `security` + `architecture`
2. **Read INDEX.md** → Identify Security & Privacy + Architecture categories
3. **Directly open security rule file** → Identify §12 (RLS) and §24 (DB Security) from TOC → Load
4. **Directly open architecture rule file** → Load RLS-related sections
5. **Record load self-verification in task.md**
6. **Begin work**

### Example 2: UI Improvement Task

⬇️ User instruction: "Fix the dashboard layout"

1. **Task Classification**: `ui_design`
2. **Read INDEX.md** → Identify Design & UX category
3. **Directly open design rule file** → Load layout/responsive sections from TOC
4. **Read Blueprint** → Load project design system definitions
5. **Record load self-verification in task.md**
6. **Begin work**

### ❌ Incorrect Behavior Examples

```
1. Read INDEX.md → "There are security files"
2. Read lessons log
3. "Understood. I'll check the RLS policies."
   ← ⚠️ Security rule file was NOT opened!
4. Begin modifications using only own knowledge
   ← ❌ Laziness confirmed. Steps 3–4 completely skipped.
```
