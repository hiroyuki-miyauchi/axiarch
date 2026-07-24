# LOADING_PROTOCOL.md — Rule Loading Protocol

> **This file defines the detailed rule loading procedure. Referenced from `AXIARCH.md`.**

> Universal Rules is a baseline governance rule library across technology and operational domains. The AI selectively loads only what each task requires, following LOADING_PROTOCOL. Rules for technologies your project does not currently use are optional reference assets that help raise the quality floor when those technologies become relevant.

---

## 🚨 BOOT SEQUENCE PROTOCOL 🚨

At the start of a conversation (new chat or after context reset), **you MUST follow these 3 principles and NOT begin any work until rules have been actually loaded.**

1. **Stop & Wait**: Do NOT immediately start modifications or audits. Read and understand the rules first, then act.

2. **No Hallucination**: Before the user provides clear code or file structure, it is **strictly prohibited** to speculatively generate and output "loaded rules list," "project structure," "tech stack overview," or any similar fabricated content.

3. **Exact Match Only**: Do NOT add extraneous text or independent interpretation. Use ONLY content actually read via tools as the basis for your actions.

---

## 🛡️ HOOK REINFORCEMENT MECHANISM 🛡️

**Projects adopting Claude Code or Codex hook configurations ship with four hooks in `.claude/settings.json` or `.codex/hooks.json`**:

| Hook | Fires when | Role | Externalised script |
|:--|:--|:--|:--|
| `SessionStart` | Conversation begins | Auto-bootstraps `task.md` / `implementation_plan.md` / `walkthrough.md` as current-task files and injects an `AXIARCH.md` reminder. Existing content is archived to `.axiarch/process-doc-history/` by `axiarch-task-state.sh` | `axiarch-scripts/axiarch-init-task-md.sh` + `axiarch-scripts/axiarch-task-state.sh` |
| `UserPromptSubmit` | Every user prompt submission | Injects a system reminder (factual + dynamic violation detection) that keeps `AXIARCH.md` / BOOT SEQUENCE in scope | `axiarch-scripts/axiarch-boot-reminder.sh` |
| `PreToolUse` (matcher: `Write`) | Just before a `Write` tool call | Blocks full-overwrite of existing files in supported environments (§6 ANTI-FULL-OVERWRITE). Whitelist via `.claude/axiarch-overwrite-allow.txt` or `.codex/axiarch-overwrite-allow.txt` | `axiarch-scripts/axiarch-protect-antifull.sh` |
| `PostToolUse` (matcher: `Edit` / `MultiEdit` / `Write`) | After file-editing tools | Measures git diff changed lines and files, then warns or blocks above thresholds | `axiarch-scripts/axiarch-diff-guard.sh` |

**Removing or disabling any of these four hooks is a constitution-amending destructive change** requiring explicit owner approval. The `PreToolUse` hook in particular adds a physical-block layer in addition to reminders (references: arXiv:2503.18666 AgentSpec and arXiv:2502.15851 Control Illusion). It reduces the risk of §6 violations that reminder-only enforcement may miss.

When the hooks are not present, the AI MUST self-enforce the BOOT SEQUENCE 3 principles autonomously.

> Antigravity / Cursor / Copilot / Windsurf have native loading or pointer mechanisms (e.g., Antigravity auto-loads `.agents/rules/`), so the Claude Code / Codex hook set is not a standard requirement for them. Google Antigravity, OpenAI Codex, and Claude Code are all validated through real operational use (dogfooding); Antigravity was validated first, and Codex and Claude Code are used continuously in real operation, including building this repository itself, with no operation guarantee for every environment. Cursor / Copilot / Windsurf are extended pointer-only candidates and are not operation-guaranteed.

### 🧭 Native Task & Plan State Sync (v1.11.0+)

`task.md` / `implementation_plan.md` / `walkthrough.md` are current-task Markdown evidence. They do not automatically update Codex or Claude Code native task/plan panels. Axiarch treats these as two separate layers.

| Layer | Responsibility |
|:--|:--|
| Markdown evidence | Persist load history, plan, and walkthrough. On a new session, `axiarch-task-state.sh` archives previous content under `.axiarch/process-doc-history/` and refreshes current-task templates in the `Project Native Language` |
| Native state | Agent UI task/plan state. Codex uses `update_plan`; Claude Code uses `TaskCreate` / `TaskUpdate` / `TaskList` / `TaskGet` and updates progress during the task |

Operational principles:

1. In Codex, call `update_plan` when multi-step work begins, and keep exactly one `in_progress` step while work is active.
2. In Claude Code, prefer Task tools when available: `TaskCreate` / `TaskUpdate` / `TaskList` / `TaskGet`. Use `TodoWrite` only as a fallback for older SDK or non-interactive runtimes without Task tools.
3. Do not claim that native UI state has been updated merely because Markdown files were written. Native UI update is complete only when the relevant native tool has been called.
4. Unless `AXIARCH_PROCESS_DOC_MODE=append` is explicitly set, treat the three files as current-task documents and avoid indefinite appending of past task content. Template language defaults to detection from `AXIARCH.md` `Project Native Language`, with `AGENTS.md` as a legacy fallback; set `AXIARCH_PROCESS_DOC_LANG=ja|en` only when an adopter needs an explicit override.

### 🔍 Hook Diagnostic

When you suspect "the hook is not working", run **`bash axiarch-scripts/check-axiarch-health.sh`** for one-shot diagnosis. The 16-stage diagnostic includes wiring verification for all four hooks (Check 3 = UserPromptSubmit / Check 11 = PreToolUse / Check 12 = SessionStart / Check 15 = v1.9+ integration) and, in the Axiarch source repository, v1.10.0+ release metadata parity with exact ROADMAP Current Stable, canonical AI-facing headers, the CHANGELOG compare ref, immutable GitHub Actions SHAs, and completed ja/en release entries, Safe Upgrade Wizard manifest wiring, exclude handling, source-only default skip with explicit interactive override, deduplicated interactive choices, source-repository-only file classification, `replace-if-local-unchanged` runtime protection, type-conflict review logging, upgrade metadata version normalization, fallback core Blueprint discovery, optional prompt evidence hashing, Blueprint INDEX shared Operations registration and version metadata, safe-upgrade prompt indexing across README, llms, and rules indexes, the `axiarch-scripts/` required/optional boundary in README, llms, and scripts README, the Claude Memory canonical boundary, and Check 16 Language First / Execution Harness / read-only delegation boundaries. It is distributed automatically by `init.sh`. See the `README.md` "Hook Reinforcement Mechanism" section for details.

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
| **Class A (Blueprint)** | `axiarch-rules/{lang}/blueprint/` | Project-specific specs, design, and lessons. Mutable. **The basic folder structure is a set of "initial folders", not a closed set.** When a new domain cannot reasonably fit an existing folder, a new folder may be added with user approval (the AI may propose, but autonomous creation is prohibited). Given that, the initial folders are these 8: **`core/`** (overview, lessons index & templates), `security/`, `engineering/`, `design/`, `quality/`, `operations/`, `product/`, `ai/`. Load by 4 categories: ① **Project Overview** (`core/000_project_overview.md`), ② **Lessons** (`core/010_project_lessons_log.md` index + crystallized files co-located as `{NNN}_{topic}.md`; prioritize the initial folder mapping and include user-approved folders when applicable), ③ **Domain Rules**, ④ **Templates** |

From the INDEX.md categories that correspond to the task types identified in Step 1, list the files to load.

> ⚠️ **Important**: Reading INDEX.md is ONLY for "creating the load candidate list". The actual **file** content retrieval (loading) MUST be done in Step 3. Reading only INDEX.md and saying "understood" does NOT constitute load completion.

### Task-Type to Folder Mapping

| Task Type | Universal Folder | Blueprint Folder (initial mapping; new folders require user proposal and approval) |
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
- **🚨 No Premature Load-Completion Claims (Anti-Hallucination)**: Outputting conversational text such as "Understood", "Load complete", or "Loaded" **before** the tool formally returns the file contents and the AI has read them is **hallucination and strictly prohibited under any circumstances**. Any progress note must not claim that loading has completed, and must never be recorded as load evidence.
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

### Cross-Session Re-load Criteria (v1.6.0+)

Explicit resolution of the trade-off between "full load = no laziness" and "context budget reality."

| Situation | Re-load Scope | Rationale |
|:--|:--|:--|
| **New session (new chat / post context reset)** | Full BOOT SEQUENCE required (Steps 1-4) + verify `task.md` load history | Memory not inherited; AXIARCH.md / LOADING_PROTOCOL load-history obligation |
| **Same session, task type changed** | Load only additional domain files for the new task type. Already-loaded Universal Rules / Blueprint files do not need re-loading | `axiarch-rules/{lang}/INDEX.md` → task type → folder mapping is stable |
| **Same session, task continues (no type change)** | No additional load required. Continue using already-loaded context. **In v1.8.0+, Check D (Task Boundary Detection) backs up the AI's self-judgment** — `axiarch-boot-reminder.sh` mechanically compares current-prompt domain keywords against task.md load history and emits a full reminder + 🚨 [VIOLATION-D] when a new keyword is detected | YAGNI + context-budget protection + Check D reduces confirmation-bias risk |
| **Long session resumed after pause (e.g. compaction trigger)** | Compare `task.md` load history with the current conversation context; re-load any file that cannot be treated as actually loaded in the current context. However, when the `[AXIARCH BOOT]` reminder TTL expires (v1.6.0+ default 30 min), perform full re-verification | `axiarch-boot-reminder.sh` TTL state; mitigates serial-position effects in LLM memory |

> **Operational Principles**:
> - **Treat the `task.md` load history as the Single Source of Truth for load candidates and evidence**. However, a filename in history does not by itself mean the current AI has the content available. If the current context cannot justify that the file is actually loaded, re-load it.
> - **Memory-inherited skipping across sessions is permitted only for the same continuing task when load evidence and current context clearly match; the AI MUST explicitly record what was skipped and why in task.md** (e.g., "Continued from prior session; AXIARCH.md / axiarch-rules/{lang}/INDEX.md re-verification skipped because loaded content remains available in current context per LOADING_PROTOCOL Step 4 session-continuation rule").
> - **When in doubt, full re-load**. Hallucination risk reduction (AXIARCH.md / LOADING_PROTOCOL BOOT SEQUENCE) outweighs context-budget savings.

> **Problem this addresses (v1.6.0 background)**:
> The historical operational gap — "loading 30+ files every session = context blow-out, so we partially load in practice" — is now explicitly codified into "what may be skipped, and when." Combined with the reminder TTL (`axiarch-boot-reminder.sh`), this reduces token cost ~87% while making adherence easier to maintain.

> **v1.8.0 improvement — Check D Task Boundary Detection**:
> Adopter feedback revealed a problem: "Even within the same session, actual tasks differ, yet the AI judges 'session is continuing, no re-load needed' and slacks" (confirmation bias). v1.8.0 adds Check D to `axiarch-boot-reminder.sh`:
>
> 1. Reads the current user prompt (JSON payload) from the UserPromptSubmit hook's stdin
> 2. Extracts domain keywords from the prompt via whole-word match (`grep -oiwE`) — security / architecture / ui_design / api / performance / push / commit / migration / etc.
> 3. **Full-text greps the AXIARCH current-task mandatory trio** — `task.md` / `implementation_plan.md` / `walkthrough.md` — for previously-known domain keywords. Captures domain context from the plan and walkthrough, not just task.md's load-history table
> 4. **On mismatch**: emits `🚨 [VIOLATION-D]` flag + **TTL bypass** (suppresses short-circuit, re-emits the full reminder)
>
> The result: the system no longer depends only on the AI's "task type unchanged" self-judgment. Task-boundary candidates are detected at the hook layer and can require rule re-load. Disable via `AXIARCH_TASK_BOUNDARY_DETECT=0`; override the keyword set via `AXIARCH_TASK_DOMAIN_KEYWORDS`.
>
> **Why scan all 3 files**: domain context is recorded not only in `task.md`'s load-history table but also in `implementation_plan.md` (the strategy section) and `walkthrough.md` (the diff narrative). Reading only `task.md` causes frequent false positives because the plan often already covers the prompt's domain. Treating all 3 files as task-context evidence mirrors the AI's actual working state.

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
