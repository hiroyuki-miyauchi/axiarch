# LOADING_PROTOCOL.md — Rule Loading Protocol

> **This file defines the detailed rule loading procedure. Referenced from `AXIARCH.md`.**

> Universal Rules is a baseline governance rule library across technology and operational domains. The AI selectively loads only what each task requires, following LOADING_PROTOCOL. Rules for technologies your project does not currently use are optional reference assets that help raise the quality floor when those technologies become relevant.

---

## 🚨 BOOT SEQUENCE PROTOCOL 🚨

At conversation start or context reset, follow these principles before changes. Read-only exploration needed to select applicable rules is permitted; use the H0/H1 exceptions below for small tasks.

1. **Stop & Wait**: Before applying changes or issuing an audit verdict, read the relevant rules. File discovery and initial observations may precede the verdict.

2. No fabricated loading: inspect available files and structure yourself; do not wait for the user to repeat accessible information. Do not report a file as loaded before the read tool completes and the returned range has been examined. Truncated output and search matches are not full-file reading.

3. Separate evidence from judgment: base factual claims on actual files, tool results and explicit user statements. Explain analysis and inference separately; never report invented files, structure or execution results as verified.

---

## 🛡️ HOOK REINFORCEMENT MECHANISM 🛡️

**Projects adopting Claude Code or Codex hook configurations ship with four hooks in `.claude/settings.json` or `.codex/hooks.json`**:

| Hook | Fires when | Role | Externalised script |
|:--|:--|:--|:--|
| `SessionStart` | Conversation begins | Auto-bootstraps `task.md` / `implementation_plan.md` / `walkthrough.md` as current-task files and injects an `AXIARCH.md` reminder. `axiarch-task-state.sh` resolves isolated documents by session ID and preserves existing root documents | `axiarch-scripts/axiarch-init-task-md.sh` + `axiarch-scripts/axiarch-task-state.sh` |
| `UserPromptSubmit` | Every user prompt submission | Injects a system reminder (static reminder + heuristic review hints) that keeps `AXIARCH.md` / BOOT SEQUENCE in scope | `axiarch-scripts/axiarch-boot-reminder.sh` |
| `PreToolUse` (matcher: `Write`) | Just before a `Write` tool call | Blocks full-overwrite of existing files in supported environments (§6 ANTI-FULL-OVERWRITE). Whitelist via `.claude/axiarch-overwrite-allow.txt` or `.codex/axiarch-overwrite-allow.txt` | `axiarch-scripts/axiarch-protect-antifull.sh` |
| `PostToolUse` (matcher: `Edit` / `MultiEdit` / `Write`) | After file-editing tools | Measures git diff changed lines and files, then warns or blocks above thresholds | `axiarch-scripts/axiarch-diff-guard.sh` |

**Removing or disabling any of these four hooks is a constitution-amending destructive change** requiring explicit owner approval. The `PreToolUse` hook in particular adds a physical-block layer in addition to reminders (references: arXiv:2503.18666 AgentSpec and arXiv:2502.15851 Control Illusion). It reduces the risk of §6 violations that reminder-only enforcement may miss.

When the hooks are not present, the AI MUST self-enforce the BOOT SEQUENCE 3 principles autonomously.

The diff hook uses `axiarch-scripts/axiarch_diff.py`, includes unborn branches and reports failed measurement as `DIFF GUARD UNASSESSED`. Warn is a notice; block requests a pause from the caller. Neither undoes edits nor guarantees that every subsequent operation is blocked. Health checks configuration and record structure, not actual hook firing or AI understanding.

> Only Google Antigravity has been validated in practical use, within the observed environments and tasks. OpenAI Codex, Claude Code and other agents are unverified; supplied adapters are compatibility candidates with no operation guarantee.

### 🧭 Native Task & Plan State Sync (v1.11.0+)

`task.md` / `implementation_plan.md` / `walkthrough.md` are current-task Markdown evidence. They do not automatically update Codex or Claude Code native task/plan panels. Axiarch treats these as two separate layers.

| Layer | Responsibility |
|:--|:--|
| Markdown evidence | Persist load history, plan, and walkthrough. `axiarch-task-state.sh` creates session-specific templates in the `Project Native Language` and preserves them on same-session resume |
| Native state | Agent UI task/plan state. Codex uses `update_plan`; Claude Code uses `TaskCreate` / `TaskUpdate` / `TaskList` / `TaskGet` and updates progress during the task |

Operational principles:

1. In Codex, when available, call `update_plan` when multi-step work begins, and keep exactly one `in_progress` step while work is active.
2. In Claude Code, prefer Task tools when available: `TaskCreate` / `TaskUpdate` / `TaskList` / `TaskGet`. Use `TodoWrite` only as a fallback for older SDK or non-interactive runtimes without Task tools.
3. Do not claim that native UI state has been updated merely because Markdown files were written. Native UI update is complete only when the relevant native tool has been called.
4. Both `AXIARCH_PROCESS_DOC_MODE=current|append` preserve existing records; task/session IDs select new work and resume. Do not append unrelated tasks to the three session documents. Template language defaults to detection from `AXIARCH.md` `Project Native Language`, with `AGENTS.md` as a legacy fallback; set `AXIARCH_PROCESS_DOC_LANG=ja|en` only when an adopter needs an explicit override.

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
| **Class A (Blueprint)** | `axiarch-rules/{lang}/blueprint/` | Project-specific specs, design, and lessons. Mutable. **The basic folder structure is a set of "initial folders", not a closed set.** When a new domain cannot reasonably fit an existing folder, a new folder may be added with user approval (the AI may propose, but autonomous creation is prohibited). Given that, the initial folders are these 8: **`core/`** (overview, lessons index & templates), `security/`, `engineering/`, `design/`, `quality/`, `operations/`, `product/`, `ai/`. Load by 4 categories: ① **Project Overview** (`axiarch-rules/{lang}/blueprint/core/000_project_overview.md`), ② **Lessons** (`core/010_project_lessons_log.md` index + crystallized files co-located as `{NNN}_{topic}.md`; prioritize the initial folder mapping and include user-approved folders when applicable), ③ **Domain Rules**, ④ **Templates** |

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
| `other` | — (autonomous decision based on task content) | `core/` (H2+: overview and relevant lessons; H0/H1: only applicable context) |

---

Reference resolution: `domain/NNN_topic.md` in a Universal document is relative to that language’s Universal root; in a Blueprint document it is relative to that language’s Blueprint root. Cross-layer references use the full repository-relative path, such as `axiarch-rules/{lang}/blueprint/`. An index or table with an explicit base folder uses that base. Examples and templates do not imply file existence or required installation. Check existence before loading and record the resolved path as reading evidence.

## Step 3: File Loading

**Directly open each file identified in Step 2**, and autonomously select task-relevant sections from the file's table of contents or Appendix (reverse lookup index).

### Actual Reading and Evidence

- Considering a file "read" based solely on INDEX.md summaries is **strictly prohibited**.
- "Directly open the file" means actually retrieving the file's content using an available file-reading tool.
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

For H2+ work, record actual paths and read ranges in the session task.md. H0 needs no durable record; H1 needs only a short record. If an applicable rule is missing, read it before the dependent change or verdict.

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
> 1. Directly open `axiarch-rules/{lang}/blueprint/core/000_project_overview.md` for H2+ `other` tasks or the first applicable-rule load. For H0/H1, read it only when relevant to the decision. Previously read content available in context may be reused under the continuation criteria below.
> 2. The domain rule file(s) corresponding to the task type from Step 1 were opened with an available file-reading tool.
> 3. The list of loaded files and ranges is recorded in session task.md for H2+, or the proportionate H0/H1 record is satisfied.
>
> If any of ①②③ is missing, STOP and load the missing files.
> Reading an initial example/template counts only as reading that template. Inspect accessible project facts; do not treat example names, stacks or unresolved fields as confirmed project settings. Ask the owner only for decisions or information that cannot be determined from authorized sources.

### Cross-Session Re-load Criteria (v1.6.0+)

Load completeness concerns applicable sections, not every file in the library.

| Situation | Re-load Scope | Rationale |
|:--|:--|:--|
| **New session (new chat / post context reset)** | Apply Steps 1–4 within scope, including H0/H1 exceptions and continuation criteria below | Do not assume inheritance; reconcile available content with direct-read evidence |
| **Same session, task type changed** | Load additional applicable files. Unchanged content already read and still available need not be reloaded | Inspect the current INDEX and actual folders for added scope |
| **Same session, task continues (no type change)** | No additional load required. Continue using already-loaded context. **In v1.8.0+, Check D (Task Boundary Detection) backs up the AI's self-judgment** — `axiarch-boot-reminder.sh` mechanically compares current-prompt domain keywords against task.md load history and emits a full reminder + [LOAD REVIEW] when a new keyword is detected | YAGNI + context-budget protection + Check D reduces confirmation-bias risk |
| **Long session resumed after pause (e.g. compaction trigger)** | Compare load history with available content; reread uncertain sections. TTL controls reminder display only and does not invalidate previously read content by itself | Reminder display state is separate from actual available context |
| Previously read rules, Blueprint or index changed | Reread affected sections and relevant references even if the task type is unchanged | Compare the read snapshot with the current content |

> **Operational Principles**:
> - **Treat the `task.md` load history as the Single Source of Truth for load candidates and evidence**. However, a filename in history does not by itself mean the current AI has the content available. If the current context cannot justify that the file is actually loaded, re-load it.
> - **Memory-inherited skipping across sessions is permitted only for the same continuing task when load evidence and current context clearly match; the AI MUST explicitly record what was skipped and why in task.md** (e.g., "Continued from prior session; AXIARCH.md / axiarch-rules/{lang}/INDEX.md re-verification skipped because loaded content remains available in current context per LOADING_PROTOCOL Step 4 session-continuation rule").
> - **When in doubt, re-read the uncertain applicable sections**. Hallucination risk reduction (AXIARCH.md / LOADING_PROTOCOL BOOT SEQUENCE) outweighs context-budget savings.

> **Problem this addresses (v1.6.0 background)**:
> The historical operational gap — "loading 30+ files every session = context blow-out, so we partially load in practice" — is now explicitly codified into "what may be skipped, and when." Combined with the reminder TTL (`axiarch-boot-reminder.sh`), this can reduce repeated context loading; savings depend on the task and are not guaranteed.

> **v1.8.0 improvement — Check D Task Boundary Detection**:
> Adopter feedback revealed a problem: "Even within the same session, actual tasks differ, yet the AI judges 'session is continuing, no re-load needed' and skips an applicable read" (confirmation bias). v1.8.0 adds Check D to `axiarch-boot-reminder.sh`:
>
> 1. Reads the current user prompt (JSON payload) from the UserPromptSubmit hook's stdin
> 2. Extracts domain keywords from the prompt via whole-word match (`grep -oiwE`) — security / architecture / ui_design / api / performance / push / commit / migration / etc.
> 3. **Full-text greps the AXIARCH current-task mandatory trio** — `task.md` / `implementation_plan.md` / `walkthrough.md` — for previously-known domain keywords. Captures domain context from the plan and walkthrough, not just task.md's load-history table
> 4. **On mismatch**: emits `[LOAD REVIEW]` flag + **TTL bypass** (suppresses short-circuit, re-emits the full reminder)
>
> The result: the system no longer depends only on the AI's "task type unchanged" self-judgment. Keyword differences are review candidates, not proof of missing reads. A keyword match does not prove that a rule was loaded either. Disable via `AXIARCH_TASK_BOUNDARY_DETECT=0`; override the keyword set via `AXIARCH_TASK_DOMAIN_KEYWORDS`.
>
> **Why scan all 3 files**: domain context is recorded not only in `task.md`'s load-history table but also in `implementation_plan.md` (the strategy section) and `walkthrough.md` (the diff narrative). Reading only `task.md` causes frequent false positives because the plan often already covers the prompt's domain. Treating all 3 files as task-context evidence mirrors the AI's actual working state.

---

Startup/reminder input and output use `axiarch-scripts/axiarch_hook.py`. Invalid or ambiguous session input does not create work records; it remains unresolved with a warning. The reminder TTL cache controls verbosity only and falls back to full output on invalid state. File presence, cache timestamps and emitted reminders do not prove actual reading or completion. See `axiarch-scripts/README.md` for details.

## Goal/current-state loading and checks

For H0/L0 read-only work, Step 4 does not require durable task.md records. H1/L1 needs only a short record.

Before changes, directly load `axiarch-rules/{lang}/universal/core/300_goal_and_current_state.md`. H0 (legacy L0) only needs purpose and reference scope; H1 needs a short record; H2+ follows `axiarch-harness/en/TASK_STATE_PROTOCOL.md`. Hook keyword differences are classification-review hints, not proven violations. Inspect accessible facts yourself.

`AXIARCH_PROCESS_DOC_MODE=current|append` are compatibility inputs preserving existing documents. Task and session IDs distinguish new work from resume. Separate default structural health, `--phase readiness`, and `--phase completion`; unfinished drafts are not completion.

## Step 5: Begin Work

Begin changes after the applicable reading and proportionate recording in Steps 1–4. Read-only discovery is allowed before that point. Optional prompts, native UI tools and durable H0 records are not prerequisites.

---

## ✅ Correct Loading Behavior Examples

### Example 1: Security Hardening Task

⬇️ User instruction: "Review the RLS policies"

1. **Task Classification**: `security` + `architecture`
2. **Read INDEX.md** → Identify Security & Privacy + Architecture categories
3. **Directly open security rule file** → Find the current RLS/auth sections in the actual TOC → Read those sections
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
   ← Applicable content has not been read; the load-completion claim is unsupported.
```
