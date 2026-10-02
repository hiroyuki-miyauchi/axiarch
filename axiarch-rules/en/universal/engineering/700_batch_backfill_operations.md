# 700. Batch, Backfill & Failure Accounting

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-06-12

> [!IMPORTANT]
> **Level 1 Priority: Absolute Compliance**
> Batch jobs and backfills are the quietest high-risk work: they can apply irreversible changes to large volumes of data during hours when no human is watching.
> The MUST requirements in this file exist to reduce risk and raise the quality floor; they take priority over implementation convenience and development velocity.

> [!CAUTION]
> **Primary Directive**
> "A job that reports partial failure as 'success' is more harmful than having no monitoring at all."
> This file is the language- and stack-agnostic universal discipline applied to **every job** invoked by machines (schedulers / queues / manual batches / backfills / migrations).
> What this file canonicalizes is the **"per-job / per-run failure accounting contract"**; general logging/metrics infrastructure is delegated to `ai/100`, SLOs and alerting to `operations/400`, and stack-specific implementation to `engineering/500` / `510` (see the responsibility boundary table in §1.2).

---

## Table of Contents

- §1. Primary Directive & Scope
  - §1.1. Applicability
  - §1.2. Responsibility Boundary Table (Adjacent Files)
  - §1.3. Core Principles & RFC 2119 Terms
- §2. Job Summary & Failure Accounting Contract (Core of This File)
  - §2.1. Standard Field Contract
  - §2.2. Three-Valued Outcome — Never Report Partial Failure as Success
  - §2.3. Mandatory Counting of skipped / dedup
  - §2.4. Per-Item Failure Capture & Original Payload Preservation (DLQ)
  - §2.5. One Canonical Summary Line per Run
  - §2.6. Metrics Emission Conventions (OTel-Aligned)
  - §2.7. Failure Taxonomy (retryable × origin axis)
  - §2.8. Silent Failure Prohibition
  - §2.9. Language-Agnostic Contract Interface
- §3. Backfill & Machine-Invoked Job Discipline
  - §3.1. Idempotent Design (Assuming At-Least-Once)
  - §3.2. Checkpoint / Watermark Persistence & Resume
  - §3.3. Chunking & Throttling (Backpressure)
  - §3.4. Mandatory Dry-Run Protocol
  - §3.5. Four-Phase Migration (dual-write → read → write → old removal)
  - §3.6. Shadow Read / Scientist Pattern
  - §3.7. Independent Verification (counts + checksum + sampling)
  - §3.8. Ordering Guarantees & Dependency Processing Order
  - §3.9. Kill Switch / Pause Prepared in Advance
  - §3.10. Retry Discipline (single layer, backoff + jitter)
  - §3.11. Scheduler Catchup Governance
  - §3.12. Target Extraction Separated from Production
- §4. Testing Obligations (Connecting to quality/000)
- §5. Multi-Perspective Review (Observability / FinOps / Performance / Privacy / Zero Trust)
- §6. Implementation Snippets (Reference Implementations)
- §7. Anti-Pattern Catalog
- §8. Maturity Model L1–L5
- Appendix A: Reverse-Lookup Index
- Cross-Reference

---

## §1. Primary Directive & Scope

### §1.1. Applicability

-   **Rule 700.1.1 (Scope of Application)**: This file applies to **all processing executed by machine invocation without interactive human operation** (MUST). This includes, but is not limited to:
    -   Scheduler-triggered jobs (cron / cloud schedulers, etc.)
    -   Queue / event-driven workers (message queue and event bus consumers)
    -   Manually launched batches (operational scripts, one-off tasks)
    -   Backfills (retroactive writes / recomputation over existing data)
    -   Data migrations (data transfer and transformation accompanying schema migrations)
-   **Litmus test**: Any process for which you cannot immediately answer "who notices, and when, if this fails?" falls under this file. Synchronous request/response APIs are out of scope (see `engineering/100`), but when an API internally performs batch-like multi-item processing, the accounting contract of §2 applies (SHOULD).

### §1.2. Responsibility Boundary Table (Adjacent Files)

-   **Rule 700.1.2 (Responsibility Boundary)**: This file is canonical only for "per-job / per-run failure accounting contracts and operational discipline"; the following are delegated to their canonical files (MUST):

| Topic | Canonical File (Delegation Target) | Relationship to This File |
|:--------|:-------------|:-----------------|
| General structured logging, metrics, and tracing infrastructure | `ai/100_data_analytics.md` Part XI–XV | This file defines **what** a job must account for; **how** it is collected and shipped is delegated |
| SLOs, alerting, and Canonical Log Lines infrastructure | `operations/400_site_reliability.md` §13, §22–§26 | Summary line format is §2.5 of this file; alert design is delegated |
| Incident response and rollback procedures | `operations/500_incident_response.md` | What happens after a job failure becomes an incident is delegated |
| GCP-specific batch architecture (Cloud Run Jobs / Pub/Sub, etc.) | `engineering/500_firebase_gcp.md` §38 | This file is generic discipline; architecture patterns are delegated |
| AWS-specific batch architecture (Lambda / SQS / Step Functions, etc.) | `engineering/510_aws_cloud.md` | Same as above |
| Test layer definitions (unit / integration / E2E) | `quality/000_qa_testing.md` §5–§6 | Only job-specific testing obligations are defined in §4 of this file |
| Schema evolution (Expand-Contract) and backfill SQL safety standards | `engineering/000_engineering_standards.md` Part XVII | DDL/DML safety standards are delegated; job-level operational discipline lives here |
| PII protection and Privacy by Design | `security/000_security_privacy.md` §7 | Only masking requirements for preserved failure samples are mentioned in §5.4 |

### §1.3. Core Principles & RFC 2119 Terms

-   **Rule 700.1.3 (RFC 2119)**: **MUST / MUST NOT / SHOULD / MAY** in this file follow the RFC 2119 definitions. MUST requirements exist for risk reduction; deviations require an explicit record via ADR.
-   **Rule 700.1.4 (No Exaggeration)**: This file does not promise "zero failures." Its purpose is to **structurally eliminate the invisibility of failure and systematically lower the cost of detection, resumption, and repair**. Phrases such as "perfect migration" or "absolutely safe backfill" are prohibited even in design documents (MUST NOT).
-   **Rule 700.1.5 (No Execution Without Observation)**: A job that does not implement the accounting contract of §2 must not be executed against production data (MUST NOT). The only exception is read-only, idempotent investigative queries (MAY).

---

## §2. Job Summary & Failure Accounting Contract

> This section is the core of this file. The contract defined here is not an API of a specific language but a **logical contract that can be implemented isomorphically in any language and on any execution platform**.

### §2.1. Standard Field Contract

-   **Rule 700.2.1 (Standard Fields)**: Every job must produce, at the end of its run, a **job run summary** containing the following fields (MUST):

| Field | Type | Meaning |
|:----------|:---|:-----|
| `jobName` / `runId` | string | Job identifier and unique ID of the run |
| `total` | int | Total number of items extracted as targets |
| `processed` | int | Number of items for which processing was attempted |
| `succeeded` | int | Number of items that succeeded |
| `failed` | int | Number of items that failed |
| `skipped` | int | Number of items intentionally skipped (reason code required, §2.3) |
| `retried` | int | Number of items that incurred retries (counted independently of final outcome) |
| `failuresByReason` | map<string, int> | Counts per failure classification (§2.7 taxonomy) |
| `failureSamples` | array | References to representative failure samples (item ID + error digest; bounded; PII per §5.4) |
| `startedAt` / `endedAt` | timestamp | Run start and end times (UTC) |
| `durationMs` | int | Run duration |
| `outcome` | enum | Three values: `success` / `partial_failure` / `failure` (§2.2) |

-   **Rule 700.2.2 (Accounting Invariants)**: The summary must satisfy the following invariants and self-verify them at completion (MUST):
    -   `processed == succeeded + failed`
    -   `total >= processed + skipped` (the difference is explicitly reported as "unreached")
    -   `failed == sum(failuresByReason.values)`
-   **Prior art**: Spring Batch `StepExecution` with its `readCount` / `writeCount` / `skipCount` / `rollbackCount` is the most battle-tested predecessor of this contract. Do not invent anew; port the isomorphic contract to your own stack.

### §2.2. Three-Valued Outcome — Never Report Partial Failure as Success

-   **Rule 700.2.3 (Three-Valued Outcome)**: The final result of a job must be **distinguished by three values**: `success` (all items succeeded) / `partial_failure` (some items failed) / `failure` (all items failed or the run could not continue) (MUST).
-   **Rule 700.2.4 (No Disguising Partial Failure)**: A run with even one failed item must not be reported as exit code 0, HTTP 2xx, or job status "success" (MUST NOT). This is the heaviest prohibition in this file. Hiding partial failure is the classic cause of data loss being discovered **weeks later, somewhere else**.
-   **Implementation guidance**: When the execution platform cannot express three values (only success/failure), collapse `partial_failure` to the **failure side** (SHOULD). "Almost success, so success" is not permitted.
-   **Prior contracts**: Robocopy's exit code bitmask, rsync's exit 23/24 (partial transfer), and AWS Lambda's `ReportBatchItemFailures` are all prior contracts sharing the same idea: "partial failure is a distinct value from success."
-   **Exit code convention (CLI / container jobs)**: `0` = success, `1` = failure, a dedicated code (e.g. `3`) = partial_failure is recommended (SHOULD). See §6.3 for a bash example.
-   **Rule 700.2.4a (Outcome Proof — calling the processor ≠ the outcome exists)**: Machine-invoked jobs, internal APIs, and critical mutations must, before returning success, **read back and confirm an observable outcome (the persisted row exists, the expected state transition happened)** (MUST). That the processing function resolved, or that no exception was thrown, is not evidence of success. Zero outcome (called, but nothing remained) is counted as `failed` and surfaced in the response with a safe reason code (MUST). HTTP 2xx + an empty outcome must not be reported as "success" (MUST NOT). Failure pattern: an auth-header mismatch makes an internal API return 200 while writing nothing, and only "processed" reports pile up. Mocked unit tests cannot structurally detect a broken wiring of env / secret pairs / key formats, so measure outcome proof at least once in a production-equivalent environment (SHOULD).
-   **Rule 700.2.4b (A zero-row-match UPDATE is not a success)**: In bulk updates and imports, zero affected rows is not an error but **not a success either**. Because most DB clients do not throw on a zero-row match, count it as `failed` (reason: not_found) (MUST). Do per-row existence checks not as N+1 but as a chunked bulk lookup over the ID set (SHOULD); if the existence check itself fails, **abort before writing** and state explicitly that "nothing was changed" (MUST) — continuing with an incomplete existence set misattributes per-row failures and makes the report a lie. Do not casually replace per-row writes with a bulk upsert for inputs full of optional columns (MUST NOT): key sets differ per row, the UPDATE semantics of "do not touch columns not passed" break, and partial rows lacking NOT NULL columns fail constraints. When adding a mutation path that touches public data, share the canonical cache-invalidation function and **pin by a source contract test that every path calls it** (MUST) — this structurally prevents the sibling gap where a defect fixed on the first path recurs on a later one.

### §2.3. Mandatory Counting of skipped / dedup

-   **Rule 700.2.5 (Skip Accounting)**: Intentional skips (filter conditions, already-processed checks, dedup) must also be **counted, with a reason code attached** (MUST). Items silently discarded are harder to discover than "failures."
-   **Rule 700.2.6 (Dedup Visibility)**: Jobs / items not executed due to idempotency or deduplication should also be recorded as observable events (SHOULD). Prior art: GitLab's idempotent jobs explicitly account for deduplicated executions.
-   **Litmus test**: "Can the difference between `total` and `succeeded` be fully explained from the summary alone?" — if not, silent discards exist.

### §2.4. Per-Item Failure Capture & Original Payload Preservation (DLQ)

-   **Rule 700.2.7 (Per-Item Capture)**: Failures must be captured **per item**; the failure of a single item must not abort the entire batch unaccounted (MUST). Wrapping the whole batch in a single try/catch is an anti-pattern in §7.
-   **Rule 700.2.8 (Original Payload Preservation)**: A failed item must be moved to a dead-letter destination (DLQ / failure table / failure file) together with **the original payload required for reprocessing (or a reference to the original data) + failure reason + failure-time metadata** (MUST). Prior art: Pub/Sub's dead-letter topic attaches the source subscription and delivery count as attributes upon forwarding.
-   **Rule 700.2.9 (DLQ Is a Monitored Target)**: The DLQ's backlog count and dwell time must be turned into metrics and alerted on threshold breach (MUST). A DLQ that only receives and is never watched is a "second graveyard" (alert design delegated to `operations/400`).

### §2.5. One Canonical Summary Line per Run

-   **Rule 700.2.10 (Canonical Summary Line)**: For each job run, output **exactly one structured, machine-readable summary log line** containing all fields of §2.1 (MUST). Any number of progress log lines may be emitted (MAY), but this single line is the canonical source for aggregation, search, and alerting.
-   **Prior art**: This is the job-side analogue of Stripe's canonical log lines (one aggregated line per request). For the request-side canonical log line infrastructure, see `operations/400` §13.
-   **JSON example**: see §6.2.

### §2.6. Metrics Emission Conventions (OTel-Aligned)

-   **Rule 700.2.11 (Metrics Emission)**: The summary's primary counts (processed / succeeded / failed / skipped) and duration must also be **emitted as metrics**, separately from logs (MUST). Logs alone cannot cheaply aggregate "per-job error rate trends."
-   **Rule 700.2.12 (OTel Semantic Conventions Compliance)**: Naming of metrics and attributes should align with OpenTelemetry semantic conventions (SHOULD):
    -   Failure-reason attributes are restricted to **low-cardinality values** equivalent to `error.type` (the §2.7 taxonomy codes). Item IDs and raw messages must not be placed in attributes (MUST NOT)
    -   Units are made explicit in metric names and unit annotations (`_total`; for `duration`, state ms/s explicitly)
-   **Delegation**: The general theory of cardinality management and naming conventions is canonical in `ai/100` §14.3–§14.4.

### §2.7. Failure Taxonomy (retryable × origin axis)

-   **Rule 700.2.13 (Failure Classification)**: All failures are classified along a **two-axis taxonomy** (MUST):

| | `user` (input / data origin) | `system` (own-system origin) | `dependency` (external dependency origin) |
|:--|:--|:--|:--|
| **`retryable`** | (essentially nonexistent — input does not change on retry) | Transient resource exhaustion, deadlocks | Timeouts, 5xx, rate limits |
| **`non_retryable`** | Validation violations, referential integrity violations | Bugs, misconfiguration, invariant violations | 4xx (auth, permission, malformed request) |

-   **Rule 700.2.14 (Classification Code Stability)**: Classification codes must be a stable, low-cardinality enum, shared as keys of `failuresByReason` and as metric attributes (MUST).
-   **Prior art**: gRPC status codes (`UNAVAILABLE` is retryable, `INVALID_ARGUMENT` is non-retryable) and Google AIP-193/194's error design and automatic-retry determination are prior organizations of this taxonomy.
-   **Connection**: This classification is the input to the retry discipline of §3.10 (retry only retryable). Retrying without classification is blind re-execution.
-   **Rule 700.2.14a (One interpretation of status words, and the condition for reporting "AI failed")**: Every component that reads the same status value (e.g. `stale`) — sync decision, coverage classification, outcome check, SLO evaluation — must share **one interpretation table** (MUST). If even one reads it as "unresolved," rows that the others correctly stopped get reported as failures. Read a column that separates "stopped by policy" from "unresolved" (a manual-protection flag etc.) together with the status. Never put the mark that "protects human work from automated processing" on **automatically generated output** (MUST NOT) — it becomes a freeze rather than a protection, and the moment the source changes, a row nobody will ever update is born. The condition for reporting "the AI processing failed" must include **evidence that the AI was actually called** (usage logs) (MUST). Failure pattern: rows never sent to the AI are counted as AI failures, and a nonexistent outage is reported for several nights. Judge completion by matching, for every required item derived from the latest source, "non-empty output, hash, status, saved time," and keep start, save, and completion distinct (MUST).

### §2.8. Silent Failure Prohibition

-   **Rule 700.2.15 (Empty Catch Prohibited)**: Code that catches an exception/error and does **nothing** (no log, no count, no rethrow) must not be written (MUST NOT). Prior norms: Google Java Style 6.2 (don't ignore exceptions), .NET CA1031 (no overly broad catches).
-   **Rule 700.2.16 (Explicit Intentional Ignoring)**: When intentionally ignoring an exception is legitimate (e.g. secondary errors during cleanup), a **comment explaining the reason is mandatory**, and where possible, count it as `skipped` (MUST).
-   **Rule 700.2.17 (Extended Definition of Swallowing)**: "Catch, log, but never count" is also a silent failure. Logs flow away; counts persist in the summary. **Logging without accounting is not considered capture** (MUST).
-   **Rule 700.2.17a (Execution record ≠ effect)**: A scheduled run's "success" record (`ok=true`) means "it ran," not "it had an effect." Verify the health of scheduled execution not by the presence of the record but by **the real data of its side effects** (no backlog rows, counters advancing) (MUST). Failure pattern: a write syntax accepted locally but rejected only by a production lower-layer component (DB proxy, API gateway) ends silently with 0 rows and no exception, and the job keeps recording success. A "readable but not writable" asymmetry silences only the writes.
-   **Rule 700.2.17b (An API that returns failure as a value is inspected at every call site)**: If you adopt a result-object API (`{ success: false }` / `null` return), **every call site inspecting the return value** becomes part of the contract (MUST). "No exception was thrown" and "the side effect completed" are not synonyms. Each call site branches explicitly on throw / false / partial, and converts false into one of: a failure count with a fixed reason, a PII-safe warning, job `ok=false`, or a rejection of the post-response monitoring promise (MUST). Emit the success log only after `success === true`. Funnel calls through one helper that counts successes and failures separately, and emit the failure count through a separate path in case the recording destination itself is broken (SHOULD). Pin "every call site inspects the return value" with a source contract test, and place real-path tests for provider false, missing destination, and recording failure as positive/negative pairs (MUST). Failure pattern: most call sites in the repository discard the return value, so a delivery failure is never counted.
-   **Rule 700.2.17c (A write inside an exception handler vanishes on rethrow)**: The pattern "write the failure to a log table, then rethrow" inside a transaction is rolled back together with the transaction on rethrow, and the record never survives (MUST NOT). "Record and rethrow" cannot both hold. To keep a failure record, swallow the exception there, exit normally, and express the failure through a return-value sentinel (MUST), or put the record in a separate transaction (autonomous / separate connection / external log). "Log then throw" and "audit then rollback" collide with transaction boundaries in any language, so confirm the survival condition of the write first (MUST). Always exercise the EXCEPTION path in a test (e.g. by temporarily renaming a dependent table) and measure that the record remains and the sentinel is returned (MUST) — otherwise the contradiction lies dormant until the first production exception.

### §2.9. Language-Agnostic Contract Interface

-   **Rule 700.2.18 (Language Agnosticism of the Contract)**: The contract of §2.1 is implemented isomorphically regardless of language. The following are **reference expressions** (e.g. TypeScript / Python) and do not mandate adopting a specific language:

```typescript
// Reference implementation (e.g. TypeScript) — representative expression of the language-agnostic contract
type JobOutcome = 'success' | 'partial_failure' | 'failure';

interface JobRunSummary {
  jobName: string;
  runId: string;
  total: number;
  processed: number;
  succeeded: number;
  failed: number;
  skipped: number;
  retried: number;
  failuresByReason: Record<string, number>; // keys are §2.7 taxonomy codes
  failureSamples: Array<{ itemId: string; reason: string; message: string }>;
  startedAt: string; // ISO 8601 UTC
  endedAt: string;
  durationMs: number;
  outcome: JobOutcome;
}
```

```python
# Reference implementation (e.g. Python) — type-hinted version of the same contract
from typing import Literal, TypedDict

class JobRunSummary(TypedDict):
    job_name: str
    run_id: str
    total: int
    processed: int
    succeeded: int
    failed: int
    skipped: int
    retried: int
    failures_by_reason: dict[str, int]
    failure_samples: list[dict]  # {item_id, reason, message} (bounded)
    started_at: str
    ended_at: str
    duration_ms: int
    outcome: Literal["success", "partial_failure", "failure"]
```

-   For a reference implementation of the aggregation helper (FailureCounter), see §6.1.

---

## §3. Backfill & Machine-Invoked Job Discipline

### §3.1. Idempotent Design (Assuming At-Least-Once)

-   **Rule 700.3.1 (At-Least-Once Assumption)**: Design under the assumption that queues, schedulers, and retry mechanisms **deliver and launch duplicates** (MUST). Designs that expect exactly-once from the platform are prohibited.
-   **Rule 700.3.2 (Idempotency Key + Unique Constraint)**: Processing that involves writes must structurally prevent duplicate application via an **idempotency key (natural or derived key) + a storage-side unique constraint** (MUST). An application-side "check existence → insert" alone breaks under contention.
-   **Rule 700.3.2a (Replacing defaults respects operator edits via an "unedited" test)**: A backfill that changes the default of operator-editable copy or settings keeps the set of old defaults as aliases and rewrites to the new default only rows whose current value equals an old default (MUST). Operator-edited values are never overwritten. Implement the replacement as an idempotent migration, and include newly introduced rows and count-default changes in the same migration (SHOULD). Failure pattern: a bulk "update the defaults" also resets copy that an operator had corrected by hand.
-   **Prior art**: Stripe's Idempotency-Key; AWS Builders' Library "Making retries safe with idempotent APIs."

### §3.2. Checkpoint / Watermark Persistence & Resume

-   **Rule 700.3.3 (Checkpoint Obligation)**: Jobs whose runtime may exceed minutes must **persist progress (last processed position / watermark)** and be able to **resume from where they left off** after failure or interruption (MUST). "Start over on failure" widens the failure window with every re-run.
-   **Rule 700.3.4 (Resume Verification)**: Resumption from a checkpoint must be verified by the test in §4.2 (MUST).
-   **Rule 700.3.4a (Guaranteed window advancement)**: When the ordering key of a bounded batch scan is a **movable value** such as "last activity time," dormant targets occupy the window and new targets are pushed outside it forever. Because the scan correctly processes N items and correctly returns 0 every time, the breakage is invisible in the counts. A batch scan must have **a mechanism that guarantees the window advances** (MUST): keep a processed-cursor column (a stamp) and make it the **first ordering key** (e.g. `cursor ASC NULLS FIRST, <original priority key> ASC`). The original priority survives as the second key for comparing unprocessed items among themselves. Priority and coverage are separate axes.
-   **Rule 700.3.4b (Stamp zero-outcome items / never stamp carried-over items)**: An item that was "looked at" is always stamped even when the outcome is zero (MUST) — otherwise it stays at the head and re-saturates the window. An item carried over because the budget ran out is never stamped (MUST NOT) — stamping it defers it to the next cycle and breaks the priority order. Confirm the cursor update does not break other semantics (e.g. the "last activity" test of a retention purge), measure whether a generic `updated_at` auto-update trigger exists, and pin that structure with a test (MUST).
-   **Rule 700.3.4c (Stalled-advancement alert)**: A state where scan targets exist yet the cursor advances by zero items is **itself an alert** (MUST). The essence of this failure is that nobody can notice it.
-   **Prior art**: Flink's checkpoint / savepoint; Temporal's heartbeat + progress persistence.
-   **Rule 700.3.4d (Complete = zero unresolved AND at least one outcome)**: In a design that persists partial progress (upsert first, process later), judge an entity complete by "zero unresolved states (pending / failed) **and** at least one outcome" (MUST). Reading "some outcome exists" as complete makes an entity that died midway skipped forever. For the same entity, "selection for reprocessing," "success / failure classification," "the monitor's healthy test," "scanning," and "remediation" **share one predicate (function)** (MUST) — the moment the criterion lives in two places, the "processed yet still uncovered next time" inconsistency appears. Targets not started because of budget or deadline remain "remaining count unknown" and must not be read as 0 (MUST NOT). Failure pattern: the aggregates say complete, yet end-user-perspective sampling finds permanently skipped entities — back a completion claim with real-item sampling (SHOULD).
-   **Rule 700.3.4e (Idempotent side effects are picked up from the "unprocessed set," not a time window)**: Do not select the targets of a scheduled job's side effects (notification creation, derived-row generation, etc.) by the time window "last successful run → now" (MUST NOT). When the main processing succeeds and only the side effect fails, the watermark still advances as "success" and the failed portion is never picked up again. Pick up idempotent side effects every time as "targets within the recent N that have no processed trace (unique key)," and let the unique constraint stop duplicates (MUST). Keep `failed` and `created=0` (no targets) distinct in the job details (MUST). Integration tests mock the side-effect module and pin "it was called and recorded" (MUST) — an unmocked integration test always takes the failure path and turns green with 0 items.

### §3.3. Chunking & Throttling (Backpressure)

-   **Rule 700.3.5 (Chunking)**: Writes over large data volumes must be split into chunks with a fixed upper bound, with waits inserted between chunks (MUST). Concrete SQL safety standards (batch size, sleep) are canonical in `engineering/000` Part XVII.
-   **Rule 700.3.6 (Health-Linked Backpressure)**: Rather than fixed values, chunk size, parallelism, and wait time should be designed to **auto-decelerate based on downstream (DB, external API) health indicators** (SHOULD). Prior art: GitLab's batched background migrations automatically pause and decelerate on DB health signals.
-   **Rule 700.3.6a (Guarantee the worst-case time of one invocation structurally)**: A batch running on a platform with an execution time limit (serverless, CI jobs, etc.) sets its per-run item count to a value for which "the sum of each item's **worst-case** duration (external-call ceiling + DB operations) < the execution limit" holds structurally (MUST). A "usually fits" heuristic is guaranteed to time out at the tail of input variance and mass-produce partial deaths. Do not treat a recent success (e.g. finishing at 90% of the limit) as a worst-case guarantee — success at the edge of the cliff is a precursor of failure. Pass the budget (limit − cleanup margin) to the processing as a deadline; after the deadline, start no new work, **persist the partial result, and count the unprocessed items as skipped** (MUST). Set the caller's (client / runner) timeout **longer** than the server-side limit so the server side takes effect first (MUST) — the reverse makes the client misdetect failure while processing continues, producing false failures and double execution. Split the operating loop's abort conditions into two layers (MUST): transient failures (timeout / non-JSON) sleep and retry up to K consecutive times (assuming idempotency); a real business failure (failed detected) aborts immediately and preserves the reason.
-   **Rule 700.3.6b (Verify fetch-all on three axes at once)**: A paginated fetch-all always includes a unique column (normally the PK) in the final ORDER (MUST) — a missing unique tiebreaker duplicates or drops rows at page boundaries. Do not return a fetch-all result inline; offload it to storage and return a signed URL, limiting raw inline responses to a fallback when storage fails (SHOULD) — a response size limit makes the export itself fail at scale. A "fetch everything" change such as removing `.limit()` verifies correctness, ordering stability, and response size at the same time (MUST).

### §3.4. Mandatory Dry-Run Protocol

-   **Rule 700.3.7 (Dry-Run Mandatory)**: Backfills and migrations that involve writes must **implement a dry-run mode (reporting target counts and intended changes without writing) and execute it before the real run** (MUST).
-   **Rule 700.3.7a (Launch conditions for dangerous local scripts)**: A local script that uses bypass-privileged credentials (service-role equivalent) requires an explicit env opt-in + refusal to run in CI / deployment environments + a leading "LOCAL-ONLY" docblock (MUST). A script that rewrites source requires `--apply` and defaults to dry-run (MUST). Delete business-logic exports with zero callers instead of keeping them "in case," and consult git history when reimplementing (SHOULD) — an orphan stays on the attack surface as long as it is exported, even with zero callers, and keeps costing security remediation in unrelated work.
-   **Rule 700.3.8 (Staged Expansion)**: The real run expands in stages (MUST): ① dry-run (all items, no writes) → ② limited run of roughly 1% → ③ full run on staging / non-production → ④ production canary (limited scope) → ⑤ production full run. Confirm the §2 summary and §3.7 verification at each stage before proceeding.
-   **Prior art**: The staged rollout principle of Google SRE Workbook Ch.13 (Data Processing Pipelines).

### §3.5. Four-Phase Migration (dual-write → read → write → old removal)

-   **Rule 700.3.9 (Four-Phase Migration)**: Data migration of a live system proceeds in the following four phases; skipping or reordering phases is prohibited (MUST):
    1.  **Dual-write**: Write to both old and new (old is authoritative; new follows)
    2.  **Read switch**: Switch reads to new (writes continue to both)
    3.  **Write switch**: Writes go to new only
    4.  **Old removal**: Remove old paths and data only after verification completes (§3.7)
-   **Rule 700.3.10 (Dual-Write Consistency)**: Assume old/new inconsistencies during the dual-write period **will occur**; maintain a mechanism to detect and repair them via audit logs or queue-based reconciliation (MUST).
-   **Prior art**: Stripe's four-phase online migrations; Notion's sharding migration (dual-write verified via audit logs + reconciliation).

### §3.6. Shadow Read / Scientist Pattern

-   **Rule 700.3.11 (Old/New Comparison)**: Before switching the read path, it is recommended to perform a **shadow read that reads from both old and new, compares results, and counts differences** (SHOULD). Differences are counted and sample-preserved just like the §2.1 summary.
-   **Prior art**: GitHub's Scientist pattern (run the candidate path alongside production traffic and record only result differences).

### §3.7. Independent Verification (counts + checksum + sampling)

-   **Rule 700.3.12 (Three-Layer Verification)**: Completion of a migration or backfill is judged by, at minimum, the following three verification layers (MUST):
    1.  **Count reconciliation**: target counts match between old and new (cheapest, coarsest)
    2.  **Aggregate reconciliation**: checksums / hashes / aggregate statistics (sum, min, max) match
    3.  **Sampling reconciliation**: **field-level** exact match of randomly sampled items
-   **Rule 700.3.13 (Independence of Verification)**: Verification must be performed by **code independent of the migration implementation (and, where possible, a different person)** (MUST). A bug in the migration code is, in principle, undetectable by verification using the same code.
-   **Rule 700.3.13a (No circular comparison)**: Do not treat the identity verification of a snapshot / seed / replica meant to match an authoritative source (e.g. production) as complete based on comparing generated snapshots with each other or on a count match alone (MUST NOT) — if the sync script itself excludes or transforms columns, the comparison is circular and hides divergence. Verify against all columns fetched independently from the authoritative source, with both a column-wise raw comparison and a stable hash (MUST); limit excluded columns to those with a legitimate reason (secrets, credentials) and name the excluded columns explicitly in the verification output (MUST). Make a single plan file shared by sync and verification the SSOT of the target definition (`engineering/710` Rule 710.3.5c).
-   **Prior art**: Notion's migration verification (independent reconciliation jobs); GCP Data Validation Tool (DVT — a reconciliation tool independent of the migration).

### §3.8. Ordering Guarantees & Dependency Processing Order

-   **Rule 700.3.14 (Dependency-Ordered Processing)**: Data with referential integrity (FK-equivalent) or causal relationships must be processed in **parent → child dependency order** (MUST). Parallelization is restricted to units independent on the dependency graph (e.g. per tenant, per aggregate root).
-   **Rule 700.3.15 (Explicit Order Dependence)**: When inter-item processing order is meaningful (event replay, etc.), state that premise explicitly in the job definition and either enforce parallelism of 1 or guarantee sequential processing per ordering key (MUST).

### §3.9. Kill Switch / Pause Prepared in Advance

-   **Rule 700.3.16 (Kill Switch Mandatory)**: Backfills and migrations that write to production data must have a safe stopping mechanism (kill switch / pause) prepared and verified **before execution starts** (MUST). "Figuring out how to stop while running" is prohibited.
-   **Rule 700.3.17 (Safety of Stopping)**: Stopping must occur at chunk boundaries and be **resumable**, consistent with checkpoints (§3.2) (MUST). A design whose only stopping mechanism is killing the process fails this requirement.
-   **Prior art**: LaunchDarkly's migration / kill-switch flag categories; Shopify maintenance_tasks (pause / resume / progress persistence as standard equipment).
-   **Rule 700.3.17a (A mass-retirement circuit breaker guards only specific transitions)**: A job that synchronizes a derived set with its source has an automatic circuit breaker that stops **the anomaly of many items transitioning to the retired side at once** (suspect a collapsed read of the source) (MUST). But limit the guard to the "source deleted / unpublished" transitions and always apply restoration, operator-decided quarantine, replacement by a new version, and out-of-window transitions (MUST). Failure pattern: stopping every transition means restorations never return, content judged unlawful keeps being served, and each wording change leaves old and new versions side by side so the guard fires every night. Default to suspecting "the scan broke" before "the source disappeared entirely."
-   **Rule 700.3.17b (Enforcement gates live in data and code)**: Never guard the enforcement condition of an irreversible process (physical deletion, billing, sending) with a migration comment, a PR title, or a runbook (MUST NOT); put the gate in data (an enforcement flag defaulting to false) and code, structured so that nothing is processed unless it is true (MUST). When a batch can have multiple enforcement-flag rows, evaluate "enforce only when all rows are true" (`bool_and`) and never skip a false row with `LIMIT 1`. The canonical rule, including the fail-safe direction, recording the enforcement state, and verification in both directions, is "Enforcement Gates Live in Data and Code" in `operations/400_site_reliability.md`.

### §3.10. Retry Discipline (single layer, backoff + jitter)

-   **Rule 700.3.18 (Single-Layer Retry)**: Retries must be consolidated into **a single layer of the architecture** (MUST). When app, queue, scheduler, and client each retry independently, attempt counts multiply under failure, producing a retry storm.
-   **Rule 700.3.19 (Backoff + Jitter + Cap)**: Retries require exponential backoff + jitter + **a cap on maximum attempts** (MUST). Prior art: AWS Architecture Blog "Exponential Backoff And Jitter."
-   **Rule 700.3.20 (Immediate Finalization of Non-Retryable)**: Failures classified as `non_retryable` under §2.7 (4xx-class, validation violations, etc.) must not be retried (MUST NOT). Count them as failed immediately and move them to the DLQ.

### §3.11. Scheduler Catchup Governance

-   **Rule 700.3.21 (Auto-Catchup Disabled by Default)**: The scheduler's "automatic catch-up execution of missed runs (catchup / backfill)" must be **disabled by default** (MUST). This prevents the accident of past runs flooding in upon recovery from extended downtime.
-   **Rule 700.3.22 (Explicit Backfill)**: When past periods must be executed, run them as a **manual backfill with an explicit target period and parallelism cap** (MUST). Prior art: Airflow's `catchup=False` default plus the explicit backfill command + `max_active_runs` limit.
-   **Rule 700.3.22a (Prove the scheduler wiring — "the route exists" is not enough)**: Schedulers (cron / cloud scheduler / event scheduler) usually do not follow 3xx. Draw the configured path from the same SSOT as the framework's canonical URL rules (trailing slash, lowercase, www, etc.), and require an exact match between the configuration and the monitoring ledger (MUST). Enumerate every scheduled path mechanically in CI and pin the URL-format invariants, but never make the string check the completion criterion (MUST NOT) — send the configured path itself to a production-equivalent server and place a positive/negative pair proving it reaches the route-specific response rather than a 3xx (MUST). After deploy, confirm not only the scheduler's delivery success but that each job's outcome record appears within the expected time (MUST). Failure pattern: code, configuration, and unit tests all exist, yet a canonical redirect keeps the route unreached and production has zero run records for ten days. Whenever a reverse proxy, rewrite, canonicalization, or auth middleware changes, rerun the same real-HTTP verification for every machine-invoked path (MUST).

### §3.12. Target Extraction Separated from Production

-   **Rule 700.3.23 (Extraction Separation)**: Extraction of backfill targets (large scans, heavy aggregations) should be performed against a **snapshot, replica, or analytics platform** separated from the production primary DB (SHOULD). Writes to production are limited to controlled chunked processing (§3.3) over an ID-listed target set.
-   **Prior art**: Snapshot-derived target extraction in Stripe's online migrations.
-   **Rule 700.3.23a (Replacement sync of a derived set)**: A sync that replaces old versions with "the set of new versions assembled this run" (translations, search indexes, FAQs, embeddings, etc.) counts as alive only **the new versions that were actually saved** (MUST) — counting versions that were merely assembled but failed to save or exceeded the budget drops the old versions and empties the shelf. Decide per kind independently (MUST), in this order: (1) hold off: if a reasonable number were alive before the sync yet this run's alive count is 0 or under half, skip retirement (apply restorations only) → (2) defer: defer only the old versions of lineages whose new version could not be saved, and retire immediately old versions whose lineage vanished (unpublished / deleted) → (3) normal sync (SHOULD). Decide hold-off before deferral — treating a regressed run as "just defer" drops everything the moment budget frees up. Record consecutive deferrals, warn above a threshold, and on a run that could not evaluate neither advance deferrals nor close existing notifications (MUST). Count by **lineage** (one per version set of the same subject), not by rows (SHOULD) — old and new versions coexist while deferred. When retiring an old version whose lineage has exactly one new version, carry over the usage record with its provenance, re-reading the new row just before writing and skipping the write if an administrator hold is set (SHOULD). For the double-counting perspective, see `engineering/710` §6.

---

## §4. Testing Obligations

> The general theory of test layers (unit / integration / E2E), test doubles, Testcontainers, etc. is canonical in `quality/000_qa_testing.md` §5–§6. This section defines **only job-specific testing obligations**.

-   **Rule 700.4.1 (Idempotency Test)**: A test that **runs the job twice on identical input and verifies the final state exactly matches a single run** is mandatory (MUST). Prior art: GitLab's shared example for idempotent workers (one test template applied to all idempotent jobs). Pseudocode in §6.4.
-   **Rule 700.4.2 (Checkpoint Resume Test)**: Intentionally interrupt mid-processing and verify the job **resumes from the checkpoint and completes without loss or duplication** (MUST). Try interruption points both at and away from chunk boundaries (SHOULD).
-   **Rule 700.4.3 (Partial Failure Test)**: Intentionally fail a subset of items and verify the following (MUST):
    -   Failed items are correctly counted in `failed` and `failuresByReason`
    -   The original payloads of failed items are moved to the DLQ (§2.4)
    -   Processing of successful items is not dragged down by failed items
    -   The outcome becomes `partial_failure` and is not reported as success (§2.2)
-   **Rule 700.4.4 (Retry Classification Test)**: Verify, per classification code, that `retryable` failures are retried with backoff and `non_retryable` failures are **finalized immediately without retry** (MUST).

---

## §5. Multi-Perspective Review

### §5.1. Observability

-   **Rule 700.5.1 (In-Flight Progress Visibility)**: In addition to the end-of-run summary (§2.5), long-running jobs should make **in-flight processing rate, error rate, progress (processed/total), and estimated time remaining** observable (SHOULD). A job that shows "nothing until it finishes" makes the stop decision (§3.9) impossible.
-   **Rule 700.5.1a (Detect the absence of execution)**: "It did not run" appears in no application log. At design time, decide which of the four silent-failure categories (① outcome proof ② fire-and-forget rescue ③ synthetic probes ④ periodic consistency checks / dead-man's switch / SLO evaluation) protects each batch or scheduled job, and always register it in the dead-man's switch's single ledger and the one-line run record at the end of each execution point (MUST). Judge completion by completeness acceptance through mechanical enumeration of every cron / every Function / every external dependency (MUST). Failure pattern: a cron removed from the configuration returned 404 every day and nobody noticed. The canonical rules are "Silent-Failure Coverage Inventory", "Dead-Man's Switch for Scheduled Jobs", and "Completeness Acceptance" in `operations/400_site_reliability.md`.

### §5.2. FinOps

-   **Rule 700.5.2 (Cost Pre-Estimation)**: Before execution, large backfills should roughly estimate **the cost of the job itself (compute, read/write billing) and the cost it induces downstream** (SHOULD). On usage-billed platforms, "reprocess everything" can become a billing scale cliff. Use the dry-run (§3.4) count report as input for the estimate. For general cost governance, see `operations/600_cloud_finops.md`.

### §5.3. Performance & Downstream Protection

-   **Rule 700.5.3 (Downstream Protection First)**: Prioritize **protecting downstream systems (production DBs, external APIs) over maximizing job throughput** (MUST). Backpressure (§3.3), rate-limit compliance, and off-peak execution are the baseline; if a job damages production SLOs, pause it immediately (§3.9).

### §5.4. Privacy

-   **Rule 700.5.4 (PII Governance of Failure Samples)**: When `failureSamples` or original payloads preserved in the DLQ contain PII, apply one of **masking, tokenization, or referencing (retaining IDs only)** (MUST). The DLQ is a "shadow data store" that tends to be monitored more loosely than production tables; state its retention period explicitly as well. Details are canonical in `security/000` §7 and `ai/100` §15.3.

### §5.5. Zero Trust (Least Privilege for Jobs)

-   **Rule 700.5.5 (Job-Dedicated Least Privilege)**: Jobs run with a **dedicated workload identity and least privilege** (MUST). A shared "admin-privileged generic batch user" must not be used (MUST NOT). Privileges for temporary jobs such as backfills should be revoked upon completion (SHOULD).

---

## §6. Implementation Snippets

> All of the following are **reference implementations** (e.g. TypeScript / bash), shown as representative examples of the language-agnostic contract (§2). Translate them into the idioms of your own stack.

### §6.1. FailureCounter Helper (e.g. TypeScript)

```typescript
// Reference implementation that safely assembles a summary satisfying the §2.1 contract
class FailureCounter {
  private succeeded = 0;
  private failed = 0;
  private skipped = 0;
  private retried = 0;
  private byReason = new Map<string, number>();
  private samples: Array<{ itemId: string; reason: string; message: string }> = [];
  private static readonly MAX_SAMPLES = 20;

  ok(): void { this.succeeded++; }
  skip(): void { this.skipped++; }
  retry(): void { this.retried++; }

  fail(itemId: string, reason: string, message: string): void {
    this.failed++;
    this.byReason.set(reason, (this.byReason.get(reason) ?? 0) + 1);
    if (this.samples.length < FailureCounter.MAX_SAMPLES) {
      this.samples.push({ itemId, reason, message }); // PII must already be masked per §5.4
    }
  }

  summarize(jobName: string, runId: string, total: number, startedAt: Date): JobRunSummary {
    const endedAt = new Date();
    const processed = this.succeeded + this.failed; // structurally guarantees the §2.2 invariant
    const outcome = this.failed === 0 ? 'success'
      : this.succeeded === 0 ? 'failure' : 'partial_failure';
    return {
      jobName, runId, total, processed,
      succeeded: this.succeeded, failed: this.failed,
      skipped: this.skipped, retried: this.retried,
      failuresByReason: Object.fromEntries(this.byReason),
      failureSamples: this.samples,
      startedAt: startedAt.toISOString(), endedAt: endedAt.toISOString(),
      durationMs: endedAt.getTime() - startedAt.getTime(),
      outcome,
    };
  }
}
```

### §6.2. JSON Example of the Canonical Summary Line (§2.5)

```json
{
  "timestamp": "2026-06-12T03:15:42.000Z",
  "level": "warn",
  "msg": "job_run_completed",
  "jobName": "backfill_order_totals",
  "runId": "run_01HXYZ",
  "total": 120000,
  "processed": 119500,
  "succeeded": 119480,
  "failed": 20,
  "skipped": 500,
  "retried": 35,
  "failuresByReason": { "dependency.retryable.timeout": 14, "user.non_retryable.validation": 6 },
  "failureSamples": [{ "itemId": "ord_8821", "reason": "user.non_retryable.validation", "message": "negative amount" }],
  "startedAt": "2026-06-12T02:50:00.000Z",
  "endedAt": "2026-06-12T03:15:42.000Z",
  "durationMs": 1542000,
  "outcome": "partial_failure"
}
```

### §6.3. Bash Example of Three-Valued Exit Codes (§2.2)

```bash
#!/usr/bin/env bash
# Reference implementation deciding a 3-valued exit code from the summary JSON after a job run
set -euo pipefail

outcome=$(jq -r '.outcome' job_summary.json)

case "$outcome" in
  success)          exit 0 ;;  # all items succeeded
  partial_failure)  exit 3 ;;  # partial failure — must not return 0 (Rule 700.2.4)
  failure)          exit 1 ;;  # all failed / could not continue
  *)                echo "unknown outcome: $outcome" >&2; exit 1 ;;
esac
```

### §6.4. Pseudocode for the Idempotency Test (§4.1)

```text
test "the job is idempotent (running twice leaves the result unchanged)":
  given: prepare initial state S0 and input dataset D
  when:  run the job against D                → state S1, summary A
  and:   run the same job against D again     → state S2, summary B
  then:  S2 == S1                       (state does not change)
  and:   B.failed == 0                  (the re-run does not error)
  and:   B.skipped + B.succeeded == B.processed + B.skipped
         (re-run items are counted as skipped (already processed) or idempotent overwrite successes)
```

---

## §7. Anti-Pattern Catalog

| # | Anti-Pattern | Violated Rules | Consequence |
|:--|:-------------|:----------|:-----|
| 1 | Wrapping the whole batch in a single try/catch, erasing per-item failures | 700.2.7 | One failure kills the run opaquely / failed items cannot be identified |
| 2 | Returning exit 0 / success status despite partial failure | 700.2.4 | Data loss surfaces weeks later, somewhere else |
| 3 | Silently discarding skipped / dedup items without counting | 700.2.5 | The very existence of "unprocessed items" goes unnoticed |
| 4 | Starting a production backfill without a kill switch / pause | 700.3.16 | Damage spreads because the run cannot be stopped after detection |
| 5 | Skipping the dry-run and writing everything at once | 700.3.7 | Order-of-magnitude target errors and wrong conditions discovered in production |
| 6 | Verification performed by the same person and code as the migration | 700.3.13 | Verification waves the migration code's own bugs through |
| 7 | Multi-layer retries (app + queue + scheduler) causing a retry storm | 700.3.18 | Attempt counts multiply under failure and crush downstream |
| 8 | Catch and swallow (empty catch, log-only, no counting) | 700.2.15–17 | Breeding ground for silent failures / summary diverges from reality |
| 9 | Putting item IDs or raw messages in `error.type`-equivalent attributes | 700.2.12 | Cardinality explosion in the metrics platform, soaring costs |
| 10 | Storing raw PII in failure samples / DLQ indefinitely | 700.5.4 | Shadow data store, compliance violations |
| 11 | Connecting to an at-least-once queue without idempotent design | 700.3.1–2 | Double processing / double billing on every duplicate delivery |
| 12 | Long-running jobs without checkpoints | 700.3.3 | Every failure restarts from scratch, widening the failure window |
| 13 | Writing to the production DB with unbounded parallelism, no throttling | 700.3.5–6 | The backfill damages production service SLOs |
| 14 | Infinitely retrying non_retryable (4xx-class) failures | 700.3.20 | Queues and logs polluted by attempts that can never succeed |
| 15 | Recovering from extended downtime with scheduler auto-catchup enabled | 700.3.21 | Past jobs flood in and saturate downstream |
| 16 | Running heavy target-extraction scans on the production primary DB | 700.3.23 | The extraction query itself becomes a production performance incident |
| 17 | Leaving dual-write old/new inconsistencies unreconciled | 700.3.10 | Inconsistent data is exposed to users at read switch |
| 18 | Deleting old data / old paths before verification completes | 700.3.9 | Irreversible; the rollback target disappears |
| 19 | Configuring a DLQ but never monitoring its backlog | 700.2.9 | Quarantined failures are never reprocessed — the "second graveyard" |
| 20 | Writing the summary only to logs, never to metrics | 700.2.11 | Error-rate trends and degradation cannot be aggregated |

---

## §8. Maturity Model L1–L5

| Level | State | Characteristics |
|:------|:-----|:-----|
| **L1: Blind** | Failures invisible | Jobs run but nothing is counted. Failures surface via user reports or luck. Empty catches exist |
| **L2: Logged** | Logs but no contract | Error logs exist, but without the accounting contract (§2.1) or three-valued outcome (§2.2); partial failures blend into success |
| **L3: Accounted** | Accounting contract implemented | All jobs implement JobRunSummary + canonical summary line + DLQ. Idempotency and partial-failure tests (§4) exist |
| **L4: Operated** | Operational discipline established | Dry-run / staged execution / kill switch / checkpoint resume are standard procedure. Metrics + alerts detect degradation |
| **L5: Verified** | Independent verification & continuous improvement | Migrations default to four phases + independent verification (§3.7). Shadow reads / reconciliation are automated, and failure-classification trends feed back into process improvement |

-   **Rule 700.8.1 (Minimum Bar)**: All jobs writing to production data require **L3 or above** (MUST). Migrations and large backfills are executed only after meeting **L4-equivalent operational procedures** (MUST).

---

## Appendix A: Reverse-Lookup Index (Keyword → Section)

| Keyword | Section |
|:----------|:----------|
| Applicability / machine-invoked / which jobs are in scope | §1.1 |
| Responsibility boundary / delegation targets / adjacent file borders | §1.2 |
| JobRunSummary / standard fields / accounting invariants | §2.1 |
| Three-valued outcome / partial_failure / exit codes | §2.2, §6.3 |
| skipped / dedup / no silent discard | §2.3 |
| DLQ / dead-letter / original payload preservation | §2.4 |
| Canonical summary line / one line per run | §2.5, §6.2 |
| Metrics / OTel / error.type / cardinality | §2.6 |
| Failure taxonomy / retryable / non_retryable / user / system / dependency | §2.7 |
| Silent failure / empty catch prohibition / swallowing | §2.8 |
| Contract interface (TypeScript / Python reference) | §2.9, §6.1 |
| Idempotency / idempotency key / unique constraint / at-least-once | §3.1 |
| Checkpoint / watermark / resume | §3.2 |
| Chunking / throttling / backpressure | §3.3 |
| Dry-run / 1% run / canary / staged expansion | §3.4 |
| Four-phase migration / dual-write / read switch / old removal | §3.5 |
| Shadow read / Scientist pattern / old-new comparison | §3.6 |
| Verification / count reconciliation / checksum / sampling / verification independence | §3.7 |
| Processing order / FK dependencies / ordering guarantees | §3.8 |
| Kill switch / pause / stopping mechanism | §3.9 |
| Retry / backoff / jitter / retry storm / single layer | §3.10 |
| Catchup / auto-catchup disabled / explicit backfill / parallelism cap | §3.11 |
| Target extraction / snapshot / replica separation | §3.12 |
| Idempotency test / resume test / partial failure test / retry classification test | §4 |
| Progress visibility / processing rate / time remaining | §5.1 |
| FinOps / job cost / scale cliff | §5.2 |
| Downstream protection / pause on SLO damage | §5.3 |
| PII masking / failure samples / DLQ retention | §5.4 |
| Least privilege / workload identity / Zero Trust | §5.5 |
| FailureCounter / reference implementation | §6.1 |
| Anti-patterns | §7 |
| Maturity model / L1–L5 / minimum bar | §8 |

---

**References (standards & prior art)**: RFC 2119 / OpenTelemetry Semantic Conventions / Spring Batch StepExecution / AWS Lambda ReportBatchItemFailures / rsync & Robocopy exit codes / Stripe canonical log lines, idempotency & online migrations / GitLab idempotent jobs & batched background migrations / Google SRE Workbook Ch.13 / GitHub Scientist / Notion sharding migrations / GCP Data Validation Tool / LaunchDarkly migration flags / Shopify maintenance_tasks / Airflow catchup / AWS Builders' Library / gRPC status codes / Google AIP-193, 194 / Google Java Style 6.2 / .NET CA1031

**Cross-Reference:**
-   `quality/000_qa_testing.md` — §5 Unit Testing, §6 Integration Testing (canonical for test layer definitions; §4 of this file holds only job-specific obligations)
-   `engineering/710_data_reconciliation.md` — canonical for **steady-state** consistency verification, invariants, and explainability SLOs (this file covers only migration-time comparison and per-job failure accounting)
-   `engineering/740_data_contracts.md` — producer/consumer contracts for cross-boundary data (schema-validation failures land in the counting + DLQ discipline of §2.4 of this file)
-   `ai/100_data_analytics.md` — Part XI–XV general observability, metrics, and structured logging infrastructure (§14.3 cardinality, §15.3 log PII)
-   `operations/400_site_reliability.md` — §13 Canonical Log Lines, §22–§26 SLO-based alerting (collection and notification side of the summary line)
-   `operations/500_incident_response.md` — response and rollback procedures when a job failure becomes an incident
-   `operations/600_cloud_finops.md` — job cost governance, usage-billing cliff countermeasures (general theory behind §5.2 of this file)
-   `engineering/000_engineering_standards.md` — Part XVII Expand-Contract and backfill SQL safety standards (canonical for the DDL/DML layer)
-   `engineering/100_api_integration.md` — webhook / event-driven retries and poison messages (synchronous API boundary)
-   `engineering/200_supabase_architecture.md` — migration immutability, DB-layer operational discipline
-   `engineering/500_firebase_gcp.md` — §38 Batch Processing & Data Pipeline (GCP-specific architecture)
-   `engineering/510_aws_cloud.md` — AWS-specific batch / queue architecture (SQS, Lambda, Step Functions)
-   `security/000_security_privacy.md` — §7 Privacy by Design (PII governance of failure samples and the DLQ)
-   `core/000_core_mindset.md` — prohibition of unverified completion reports, fact-based reporting fundamentals

---

**Last Updated**: 2026-06-12
**Authority**: Universal Constitution (axiarch core)
**Classification**: Engineering — Batch, Backfill & Failure Accounting
