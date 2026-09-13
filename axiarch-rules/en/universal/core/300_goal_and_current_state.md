# 300. Goal & Current-State Protocol

> [!CAUTION]
> **This file is a Universal Rule (immutable). Do not edit without an explicit "amend the constitution" instruction.**
> Revised: 2026-09-10

> [!IMPORTANT]
> **Mandatory Within Applicable Scope**
> **Check available context at start or resume**. Do not assume handover implicitly; reconcile available records against the actual state.
> The MUST requirements in this file aim to reduce the risk of wrong deliverables and duplicated work, and take precedence over speed of starting.

> [!CAUTION]
> **Primary Directive**
> "**Goal drift can undermine the value of the result; current-state drift can cause duplication and rework.** The smarter the agent, the farther it flies; the farther it flies, the more the initial error is amplified at the point of impact."
> This file is canonical for **"the discipline of fixing the goal (where to) and the current state (where we are) and confirming they are not drifted, before delegating work."** Which rules to load is delegated to `axiarch-rules/{lang}/LOADING_PROTOCOL.md`, evidence formats to `AXIARCH.md` §7, and approval gates to `AXIARCH.md` §6.2 (see the §1.2 responsibility boundary table).

---

## Table of Contents

- §1. Primary Policy and Scope of Responsibility
  - §1.1. Applicability
  - §1.2. Responsibility Boundary Table (Adjacent Rules)
  - §1.3. Core Principles and RFC 2119 Terms
- §2. The Boot Triad (the core of this file)
  - §2.1. Explicit Context at Start and Resume
  - §2.2. Do Not Start Until All Three Are Present
  - §2.3. Triad Principle — Goal and Current State Alone Are Not Enough
- §3. Making the Goal Explicit
  - §3.1. Duty of Verifiable Completion Criteria
  - §3.2. Prohibition on Standalone Vague Terms
  - §3.3. Stating Non-Goals
  - §3.4. Freezing Completion Criteria and Changing Them Explicitly
  - §3.5. The Goal Restatement Gate
- §4. Holding the Current State
  - §4.1. Machine-Readable Retention of Four States
  - §4.2. Conversation History Is Not the Source of Truth
  - §4.3. Properties the Current-State Container Must Satisfy
  - §4.4. Duty of Freshness Verification
  - §4.5. Recording Discarded and Rejected Options
  - §4.6. What Must Never Be Written into the Current State
- §5. The Autonomy-Distance Scaling Law
- §6. Two Classes of Drift and Their Detection
  - §6.1. Goal Drift — Risk to Result Value
  - §6.2. Current-State Drift — the Duplication and Rework Class
  - §6.3. Duplication Check Before Starting
  - §6.4. Duty to Report Drift and Stop Early
- §7. Shared Current State (Concurrent Work)
- §8. Verification Duties
- §9. Seventeen Anti-Patterns
- §10. Maturity Model

---

## §1. Primary Policy and Scope of Responsibility

### §1.1. Applicability

-   **Rule 300.1.1 (Applicability)**: This file applies to **every situation in which work is delegated from a human to an agent, or from one agent to another** (MUST). It is a universal discipline independent of language, stack, product, and tooling. This includes, but is not limited to:
    -   Requests for implementation, investigation, or fixes in an interactive session
    -   Tasks submitted to an autonomously executing agent
    -   Machine execution via schedulers and queues (goal and current state are carried by the job definition and the run ledger)
    -   Work performed concurrently by multiple agents or multiple people
-   **Litmus test**: any situation for which the answer to "can the receiver reconstruct **where to go** and **where we are** from this instruction alone?" is No falls under this file.

### §1.2. Responsibility Boundary Table (Adjacent Rules)

-   **Rule 300.1.2 (Responsibility boundary)**: This file is canonical only for "fixing, holding, and verifying the goal and the current state"; the following are delegated to their respective canonical sources (MUST):

| Area | Canonical source | Boundary with this file |
|:--|:--|:--|
| Which rules to load, and in what order | `axiarch-rules/{lang}/LOADING_PROTOCOL.md` | This file defines only what is needed *after* the norms |
| Evidence document formats, native task sync | `AXIARCH.md` §7 | This file defines the **content** to record; §7 the **container and format** |
| Task classification, role passes, audit verdict | `AXIARCH.md` §8 / `axiarch-harness/` | This file covers only the preconditions for starting |
| Approval gates and stop points for irreversible acts | `AXIARCH.md` §6.2 | This file governs "agreement on interpretation"; §6.2 "permission to execute" |
| Ban on unverified completion reports, fact-based reporting | `axiarch-rules/en/universal/core/000_core_mindset.md` | This file governs the freshness of the state such reports rest on |
| Writing the spec first (Blueprint First) | `AXIARCH.md` §6.7 | This file covers goals of any size, not only major changes |
| Means of verifying completion criteria (test layers) | `axiarch-rules/en/universal/quality/000_qa_testing.md` | This file governs only how "what counts as done" is written |
| Failure accounting and run summaries for machine jobs | `axiarch-rules/en/universal/engineering/700_batch_backfill_operations.md` | 700 counts after the run; this file governs the premises before it |
| Branch and pull-request discipline | `axiarch-rules/en/universal/engineering/600_git_workflow.md` | This file covers only the duty to consult them as shared state |
| Business objectives, KPIs, OKRs | `axiarch-rules/en/universal/product/000_product_strategy.md` | Business goals belong to product; this file covers task-level goals |

### §1.3. Core Principles and RFC 2119 Terms

-   **Rule 300.1.3 (Terminology)**: MUST / MUST NOT / SHOULD / MAY in this file follow RFC 2119.
-   **Goal**: the state in which the work can be judged complete, expressed as a set of verifiable completion criteria.
-   **Current state**: the present state of the work object — what is done, what is in progress, what is untouched, and what was discarded.
-   **Norms**: how the work must be done — safety, quality, legal, and design constraints. The Universal rule set itself.
-   **Autonomy distance**: the gap between goal and current state, estimated jointly from step count, elapsed time, irreversibility and blast radius, not a literal product or performance prediction.

---

## §2. The Boot Triad (the core of this file)

### §2.1. Explicit Context at Start and Resume

-   **Rule 300.2.1 (Handover verification)**: Check the context and records available at start or resume (MUST). Do not assume prior agreements or human knowledge are implicitly shared. Inherited context may be reused after checking its basis and freshness; read accessible files yourself. This does not assert zero memory at every start or require re-reading the whole library.
-   **Law**: Capability alone cannot verify an unavailable agreement. Do not invent missing context; follow the continuation and re-reading conditions in LOADING_PROTOCOL.
-   **Rule 300.2.2 (No implicit shared knowledge)**: Never omit an explicit goal or current state on the grounds of "I said it before" or "it is common knowledge on this team" (MUST NOT).

### §2.2. Do Not Start Until All Three Are Present

-   **Rule 300.2.3 (Boot triad)**: An agent **must not begin implementation, modification, or any irreversible action** until all three of the following are present (MUST NOT):
    1.  **Norms** — the rules to comply with (loaded per `axiarch-rules/{lang}/LOADING_PROTOCOL.md`)
    2.  **Goal** — verifiable completion criteria (§3)
    3.  **Current state** — the present state of the target (§4)
-   **Rule 300.2.4 (Behavior when something is missing)**: When any of the three is missing, the agent **must not fill the gap by guessing and proceed** (MUST NOT). The required order of action is:
    1.  Whatever can be established independently (from code, logs, CI, data stores, history) must be **investigated and established by the agent itself**
    2.  Of what remains unresolved, anything for which **no interpretation changes the deliverable** may proceed with the assumption stated explicitly
    3.  Only what changes the deliverable depending on interpretation is **escalated to the requester**
-   **Law**: asking is cheap, but asking constantly burdens the requester. **Asking about what could have been looked up is negligence; guessing about what should have been asked is an incident.**

### §2.3. Triad Principle — Goal and Current State Alone Are Not Enough

-   **Rule 300.2.5 (Norms are co-equal)**: Never hand an agent only a goal and a current state while omitting the norms (MUST NOT).
-   **Law**: a capable agent given only a goal and a current state will **reach the right destination by a dangerous route**. Direct production database edits, destruction of working behavior, bypassed authorization, and exposure of sensitive data can all occur in a state where "the goal was achieved."
-   **Rule 300.2.6 (Precedence)**: Where norms and the goal conflict, **the norms prevail** (MUST). Norms must not be broken to achieve a goal. The conflict must be surfaced to the requester, not hidden.

---

## §3. Making the Goal Explicit

### §3.1. Duty of Verifiable Completion Criteria

-   **Rule 300.3.1 (Completion criteria)**: A goal must be written as **completion criteria a third party can judge objectively** (MUST). Express "what must exist for this to be finished" in observable terms.
-   **Rule 300.3.2 (State the means of verification)**: Each completion criterion should state **how it will be checked** (SHOULD). A criterion whose check cannot be written down is usually still ambiguous.
-   **Rule 300.3.3 (Granularity)**: Decompose completion criteria until each can be judged met or unmet as a binary (SHOULD). "Mostly working" is not a completion criterion.

### §3.2. Prohibition on Standalone Vague Terms

-   **Rule 300.3.4 (Vague terms)**: The following must never be used **on their own** as completion criteria (MUST NOT); when used, they must be accompanied by an observable standard:
    -   improve / optimize / speed up / make it lighter
    -   clean up / tidy / make it nice / handle it appropriately
    -   make it secure / make it usable / modernize it
-   **Law**: these express a direction but **not a destination**. A receiver given only a direction cannot judge where to stop, and will either overshoot or undershoot.

### §3.3. Stating Non-Goals

-   **Rule 300.3.5 (Non-goals)**: For adjacent areas that are easily misread as in scope, state **what will not be done** (SHOULD).
-   **Law**: scope creep comes not from missing instructions but from **missing boundaries**. "Fixing it while I am here" injects changes the requester never asked for, raising review load and regression risk at the same time.

### §3.4. Freezing Completion Criteria and Changing Them Explicitly

-   **Rule 300.3.6 (Freeze)**: After work has begun, the agent must not loosen or widen the completion criteria on its own judgment (MUST NOT).
-   **Rule 300.3.7 (Explicit change)**: When it becomes clear during the work that the goal must change, present the change and its rationale **before proceeding further**, and obtain agreement (MUST).
-   **Rule 300.3.8 (Declaring partial achievement)**: When only part of the completion criteria could be met, **report met and unmet criteria separately** (MUST). The whole must not be rounded up to "complete."

### §3.5. The Goal Restatement Gate

-   **Rule 300.3.9 (Restatement)**: For work whose autonomy distance (§5) exceeds the threshold, **restate the interpretation of the goal in your own words once before starting** (MUST). The restatement must include the completion criteria, the non-goals, and the assumptions made.
-   **Law**: early checking can reduce rework. Restatement does not itself require re-approval: continue within explicit authorized scope and ask only about unresolved intent or approval boundaries.
-   **Rule 300.3.10 (When restatement may be skipped)**: Restatement may be skipped for work of short distance whose result is easily discarded (MAY). The criterion for skipping is distance, not the requester's level of expertise.

---

## §4. Holding the Current State

### §4.1. Machine-Readable Retention of Four States

-   **Rule 300.4.1 (Four states)**: The current state must distinguish at least the following four states (MUST):
    -   **Done** — completion criteria met and verified
    -   **In progress** — started and unfinished (including who owns it)
    -   **Not started** — planned but untouched
    -   **Discarded** — considered and deliberately not taken (§4.5)
-   **Rule 300.4.2 (Machine-readable)**: The current state must be held in a form **the next agent to boot can read directly** (MUST). Progress buried mid-paragraph in prose invites missed reads.

### §4.2. Conversation History Is Not the Source of Truth

-   **Rule 300.4.3 (No conversation history)**: Conversation history and chat logs must not be the source of truth for the current state (MUST NOT).
-   **Law**: conversations are **truncated, summarized, and lost**. The longer the work, the older the messages that disappear first — so the earliest and most important agreements are, paradoxically, the first to go.
-   **Rule 300.4.4 (Externalize)**: When work may continue beyond a single session, the current state must be written out to a durable location outside the session (MUST).

### §4.3. Properties the Current-State Container Must Satisfy

-   **Rule 300.4.5 (Container requirements)**: The mechanism holding the current state must not depend on a specific product or service (MUST NOT). Whatever mechanism is adopted must satisfy the following properties (MUST):

| Property | Requirement |
|:--|:--|
| Singularity | The state of one piece of work is not scattered across places (if it is, one source is designated canonical) |
| Append-ness | Update history is not lost; past judgments are not erased by overwriting |
| Attribution | It is clear when, and by whom (human or agent), each record was made |
| Linkage | Each item is tied to the completion criterion it corresponds to |
| Readability | Both humans and agents can read it without an extra conversion step |

-   **Law**: the container may be an issue tracker, a file in the repository, or a purpose-built tool. **What matters is not the product name but whether the properties above hold.**

### §4.4. Duty of Freshness Verification

-   **Rule 300.4.6 (Snapshot nature)**: A recorded current state is **a snapshot as of the moment it was written**, not a fact as of the moment it is read (MUST recognize).
-   **Rule 300.4.7 (Duty to reconcile)**: Before judging or reporting on the basis of the current state, **reconcile it against reality** (MUST). Examples of what to reconcile against: working tree and branch state, test and CI results, actual file contents, values in the data store, live configuration.
-   **Rule 300.4.8 (Mark the unreconciled)**: Items that could not be reconciled must not be reported mixed in with reconciled facts (MUST NOT). State explicitly that they are unconfirmed.
-   **Law**: design the current-state record **on the assumption that it will go stale**. Going stale is not the failure. Treating a stale record as fact is the failure.

### §4.5. Recording Discarded and Rejected Options

-   **Rule 300.4.9 (Record discards)**: Options that were considered and not taken should be **recorded as discarded, together with the reason** (SHOULD).
-   **Law**: without a record of discards, later agents and colleagues **re-propose the same option and repeat the same debate**. A discard is not a record of failure; it is a map of territory already explored.

### §4.6. What Must Never Be Written into the Current State

-   **Rule 300.4.10 (No secrets)**: Credentials, access tokens, private keys, passwords, and connection strings must never be written into the current state (MUST NOT). Where a reference is needed, record **only the name of the store** that holds them.
-   **Rule 300.4.11 (No production data)**: Actual production personal data must never be pasted into failure examples, reproduction steps, or investigation notes (MUST NOT). Express them as identifiers, counts, categories, or masked values.
-   **Rule 300.4.12 (Assume the widest audience)**: Write shared current state on the assumption that **the widest set of people and agents able to read that location will read it** (MUST). Consolidation widens visibility, so **consolidation and access control must be designed together** (MUST).
-   **Rule 300.4.13 (Retention)**: Personal data held in the current state must have a defined retention period and be deleted or anonymized when it expires (MUST). Classification, retention, and deletion are canonical in `axiarch-rules/en/universal/security/100_data_governance.md`.
-   **Law**: consolidating current state raises productivity, but **gathering it in one place simultaneously widens the blast radius of a leak**. "Put everything here and it gets smarter" is, inverted, "if this leaks, everything leaks." The benefit of consolidation and the risk of concentration must always be evaluated as a pair.

---


Use D1–D5 for distance (formerly distance L1–L5), M1–M5 for maturity (formerly maturity L1–L5), and H0–H4 for harness task classification (legacy L0–L4). There is no numeric conversion between them. High maturity never removes approval requirements. H0 needs only purpose and reference scope; H1 needs a short record; H2+ requires structured evidence. Restatement communicates interpretation; it does not require renewed approval for already authorized implementation. Storage and checks are defined in `axiarch-harness/en/TASK_STATE_PROTOCOL.md`.

## §5. The Autonomy-Distance Scaling Law

-   **Rule 300.5.1 (Scaling law)**: The longer the autonomy distance, the higher the required **precision of the goal, precision of the current state, and strength of pre-start confirmation** (MUST).
-   **Law**: a more capable agent can travel farther on a vague instruction. Therefore **rising capability does not lower the precision required of goal and current state — it raises it**. The farther the flight, the more an initial angular error expands at the point of impact.
-   **Rule 300.5.2 (Estimating distance)**: Estimate the autonomy distance before starting (MUST). Estimate along four axes: step count, elapsed time, irreversibility, and blast radius.

| Distance | Guide | Goal requirement | Current-state requirement | Pre-start confirmation |
|:--|:--|:--|:--|:--|
| **D1** | A single obvious change, easily discarded | Verbal level is sufficient | State of the target file only | Not required |
| **D2** | Multiple files; may affect existing behavior | Completion criteria written down | State of the related area | Not required (judgeable from the result) |
| **D3** | Involves design judgment; regression risk | Criteria plus non-goals | Four states recorded | **One restatement** |
| **D4** | Long autonomous run; wide reach | Criteria plus non-goals plus assumptions | Four states plus freshness reconciliation | **Restatement plus plan presentation** |
| **D5** | Irreversible, production-affecting, or sensitive | All of the above, documented | The above plus a shared-state check | **Restatement, plan, and approval gate** |

-   **Rule 300.5.3 (Re-evaluating distance)**: When facts discovered during the work raise the distance, **satisfy the requirements of the higher tier from that point on** (MUST). "We already started" is not a reason to continue.

---

## §6. Two Classes of Drift and Their Detection

### §6.1. Goal Drift — Risk to Result Value

-   **Rule 300.6.1 (Definition of goal drift)**: Goal drift is the state in which **the receiver worked correctly toward a different destination**. Even a high-quality deliverable may be unusable for the intended goal.
-   **Signs**: completion criteria not written in observable form; vague terms used on their own; no restatement performed; the request admits more than one reading.
-   **Detection**: use pre-start restatement (§3.5), criterion reconciliation and intermediate reviews for early detection. Detection after completion may involve more rework.

### §6.2. Current-State Drift — the Duplication and Rework Class

-   **Rule 300.6.2 (Definition of current-state drift)**: Current-state drift is the state in which the agent **rebuilds what already exists, re-solves what was already solved, or breaks an area someone else has in progress**.
-   **Signs**: multiple implementations serving the same purpose; a discarded option being re-proposed; additions made on the premise that existing configuration or features are absent; diffs that undo someone else's change.
-   **Detection**: detect via the pre-start duplication check (§6.3) and freshness reconciliation (§4.4).

### §6.3. Duplication Check Before Starting

-   **Rule 300.6.3 (Duplication check)**: Before building something new, confirm that **an equivalent does not already exist** (MUST). Examples of where to check: existing implementations, configuration, documentation, in-flight changes, and previously discarded options.
-   **Rule 300.6.4 (Prefer the existing)**: When an equivalent mechanism already exists, **extending it takes precedence over creating a new one** (SHOULD). If new creation is chosen, record the reason.

### §6.4. Duty to Report Drift and Stop Early

-   **Rule 300.6.5 (Never continue silently)**: When the detected drift **changes the deliverable or invalidates work already done**, stop the work at that point and report it to the requester (MUST). Drift that does not change the deliverable should be recorded and reported together at completion (SHOULD). In either case, continuing on the assumption that "it is probably fine" after detecting drift is forbidden (MUST NOT).
-   **Rule 300.6.6 (Report early)**: Report as soon as it becomes clear that a completion criterion cannot be met (MUST). It must not be concealed until the end of the work. **The worse the news, the more its value depends on arriving early.**
-   **Rule 300.6.7 (No silent failure)**: Drift, failures, and skips must never be made to disappear by leaving them out of both the record and the report (MUST NOT). Counting discipline for machine execution is canonical in `axiarch-rules/en/universal/engineering/700_batch_backfill_operations.md`.
-   **Rule 300.6.8 (Detect staleness)**: Current-state items whose last reconciliation is older than a defined interval must be **treated as unconfirmed** (MUST). The threshold is set per project.
-   **Rule 300.6.9 (Recurrence prevention)**: For drift that actually occurred, identify the cause (a vague goal, a missing current state, or a skipped confirmation) and record it as a lesson per `axiarch-rules/{lang}/CRYSTALLIZATION_PROTOCOL.md` (MUST). **When the same cause produces drift twice, promote it into a project-specific rule** (SHOULD).
-   **Law**: detect drift, record causes and re-check conditions, and reduce recurrence risk; complete prevention is not guaranteed.

---

## §7. Shared Current State (Concurrent Work)

-   **Rule 300.7.1 (Consolidation)**: When multiple agents or multiple people work concurrently, the current state must be **consolidated in a single referenceable location** (MUST). The internal state of an individual session is invisible to others and therefore does not constitute shared state.
-   **Rule 300.7.2 (Check others' work before starting)**: Before starting, confirm that **no one else has work in progress in the same area** (MUST). What to check includes in-progress tasks, unmerged changes, and proposals awaiting review.
-   **Rule 300.7.3 (Declare boundary-crossing changes in advance)**: When making changes beyond your own scope — to shared assets, common foundations, or another owner's area — **declare it before starting** (MUST).
-   **Law**: the most expensive accident in concurrent work is not the collision itself, but **both parties finishing without noticing the collision**. Some work may need reconciliation or discarding.
-   **Rule 300.7.4 (Current state at handover)**: When handing work to someone else, pass the four states (§4.1) and the assumptions made, stated explicitly (MUST). "Over to you" is not a handover.

---

## §8. Verification Duties

-   **Rule 300.8.1 (Check every completion criterion)**: Before reporting completion, **verify the completion criteria one by one** (MUST). They must not be judged "fine" in aggregate.
-   **Rule 300.8.2 (Record verification results)**: For each completion criterion, record what was checked and how (MUST).
-   **Rule 300.8.3 (Update the current state)**: Whether the work completed, paused, or was discarded, **update the current state on exit** (MUST). Work left without an update forces a full re-investigation next time.
-   **Rule 300.8.4 (Duties when pausing)**: When pausing, leave in the current state how far the work got and what should be done next (MUST).

---

## §9. Seventeen Anti-Patterns

| # | Anti-pattern | Why it is dangerous |
|:--|:--|:--|
| 1 | Using only vague terms as completion criteria | With no destination, the work overshoots or undershoots |
| 2 | Omitting context because "I said it before" | The receiver has not been shown to hold or access that context |
| 3 | Treating conversation history as the source of truth | Truncation loses the oldest — and most important — agreements first |
| 4 | Reporting a recorded state as fact without reconciling | A stale snapshot is presented as the present, misleading decisions |
| 5 | Handing over only the norms of the three | The agent carefully builds the wrong thing, destination unknown |
| 6 | Handing over goal and state but omitting the norms | The right destination is reached by a dangerous route |
| 7 | Loosening criteria mid-run on the agent's own judgment | Unmet work is reported as complete and detection is delayed |
| 8 | Starting a long autonomous run with no restatement | Drift is detected only after completion, once damage is fixed |
| 9 | Rounding partial achievement up to full completion | Remaining work is not handed on and fails downstream |
| 10 | Not recording discarded options | The same option is re-proposed and the same debate repeats |
| 11 | Omitting non-goals and mixing in "while I am here" changes | Review load and regression risk rise together |
| 12 | Starting without checking for concurrent work | Both parties finish and some work may need reconciliation or discarding |
| 13 | Not updating the current state when pausing | The next session is forced into a full re-investigation |
| 14 | Designing state that can live only in one product | The discipline collapses wherever that product is unavailable |
| 15 | Asking the requester what could have been looked up | Constant confirmation burdens the requester and hollows out the check |
| 16 | Pasting credentials or production personal data into state | Consolidation maximizes the blast radius of any leak |
| 17 | Detecting drift and continuing without reporting it | By the time it is reported, the rework is already maximal |

---

## §10. Maturity Model

| Stage | State | Criteria |
|:--|:--|:--|
| **M1: Verbal** | Work is handed over only by speech or chat | No durable record of the current state exists |
| **M2: Recorded** | Goal and current state survive as documents | But completion criteria are vague and freshness is never checked |
| **M3: Verifiable** | Criteria are verifiable and the four states are held | Pre-start duplication checks and restatement are in operation |
| **M4: Synchronized** | Shared state is consolidated, with concurrent conflicts detected and reconciled | Freshness reconciliation is habitual and discards are recorded |
| **M5: Scaled** | Requirements rise automatically with autonomy distance | Distance estimation and re-evaluation function as a mechanism |

---

## Appendix A: Reverse Index

| Keyword | Section | Execution reference |
|:--|:--|:--|
| Goals and restatement | §2–3 | `axiarch-rules/{lang}/LOADING_PROTOCOL.md` |
| State, evidence and freshness | §4, §8 | `axiarch-harness/{lang}/TASK_STATE_PROTOCOL.md` |
| Distance D, maturity M, harness H | §5, §10 | `axiarch-harness/{lang}/EXECUTION_HARNESS_PROTOCOL.md` |
| Concurrent sessions | §7 | `axiarch-harness/{lang}/TASK_STATE_PROTOCOL.md` |

**Cross-Reference:**

-   `axiarch-rules/{lang}/LOADING_PROTOCOL.md` — the loading order for norms (canonical for satisfying the first element of the triad)
-   `axiarch-rules/en/universal/core/000_core_mindset.md` — ban on unverified completion reports, fact-based reporting (the parent principle for §4.4 and §8)
-   `axiarch-rules/en/universal/core/100_governance.md` — constitutional authority and separation of layer responsibilities (the basis for this file's placement)
-   `axiarch-rules/en/universal/core/200_language_protocol.md` — the choice of language in which goal and current state are written
-   `axiarch-rules/{lang}/CRYSTALLIZATION_PROTOCOL.md` — turning drift into lessons and promoting them into project rules (canonical for §6.9)
-   `axiarch-rules/en/universal/security/000_security_privacy.md` — handling of secrets (the parent principle for §4.6)
-   `axiarch-rules/en/universal/security/100_data_governance.md` — classification, retention, and deletion of personal data (canonical for §4.6)
-   `axiarch-rules/en/universal/quality/000_qa_testing.md` — the means of verifying completion criteria (canonical for test layer definitions)
-   `axiarch-rules/en/universal/engineering/600_git_workflow.md` — branch and pull-request operation (the principal embodiment of shared state)
-   `axiarch-rules/en/universal/engineering/700_batch_backfill_operations.md` — run summaries and failure accounting for machine jobs (the current state after a run)
-   `axiarch-rules/en/universal/engineering/710_data_reconciliation.md` — the discipline of continuously verifying record against reality (the data-side counterpart of §4.4)
-   `axiarch-rules/en/universal/product/000_product_strategy.md` — business objectives and metric governance (canonical for business goals)
-   `axiarch-rules/en/universal/design/000_design_ux.md` — UI design that shows the user where they are and where they are going (the same principle on the human side)

---

**Last Updated**: 2026-09-10
**Authority**: Universal Constitution (axiarch core)
**Classification**: Core — Goal & Current-State Protocol
