# 710. Data Reconciliation & Invariants

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-06-12

> [!IMPORTANT]
> **Level 1 Priority: Absolute Compliance**
> Inconsistencies in "quantities governed by conservation laws" — money, inventory, points — are the quietest and most expensive data defects: they surface not at the moment they occur, but **weeks later in invoices, financial close, and user complaints**.
> The MUST requirements in this file exist to reduce risk and raise the quality floor; they take priority over implementation convenience and development velocity.

> [!CAUTION]
> **Primary Directive**
> "Unverified consistency is indistinguishable from consistency that does not exist."
> This file is the language- and stack-agnostic universal discipline applied to **every system** that handles conserved quantities (money, inventory, points, credits, usage-based billing, record counts).
> What this file canonicalizes is the **"discipline of continuous consistency verification (reconciliation) and invariants"**; one-time migration/backfill comparison and job failure accounting are delegated to `engineering/700`, data quality metrics infrastructure to `ai/100`, and billing/monetization business logic to `product/300` (see the responsibility boundary table in §1.2).

---

## Table of Contents

- §1. Primary Directive & Scope
  - §1.1. Applicability — Quantities Governed by Conservation Laws
  - §1.2. Responsibility Boundary Table (Adjacent Files)
  - §1.3. Core Principles & RFC 2119 Terms
- §2. Explicit Invariants
  - §2.1. Obligation to Define Invariants
  - §2.2. Maintaining the Invariant Catalog
  - §2.3. Representative Invariant Patterns
- §3. Continuous Reconciliation Jobs
  - §3.1. Prohibition of One-Time Verification — Make It a Scheduled Job
  - §3.2. Designing Cadence, Scope, and Tolerances
  - §3.3. Multi-System Reconciliation
  - §3.4. Timing Differences & Cutoff Boundaries
  - §3.5. Discrepancy Remediation Discipline
- §4. The Three Reconciliation Metrics (Stripe Ledger Style)
  - §4.1. Clearing — Expected Zero Balance in Intermediate Accounts
  - §4.2. Timeliness — Verified-Within-Deadline Ratio
  - §4.3. Completeness — Statistical Detection of Full Upstream Arrival
  - §4.4. Explainability % as an SLO
- §5. Append-Only & Reversal Entries
- §6. Double-Counting Prevention
- §7. Drift Detection
- §8. Testing Obligations (Connecting to quality/000)
- §9. Multi-Perspective Review (Observability / FinOps / Privacy)
- §10. Implementation Snippets (Reference Implementations)
- §11. Anti-Pattern Catalog
- §12. Maturity Model L1–L5
- Appendix A: Reverse-Lookup Index
- Cross-Reference

---

## §1. Primary Directive & Scope

### §1.1. Applicability — Quantities Governed by Conservation Laws

-   **Rule 710.1.1 (Applicability)**: This file applies to **every system that stores, aggregates, or transfers a conserved quantity** (MUST). This includes, but is not limited to:
    -   Money (balances, revenue, fees, refunds, payouts)
    -   Inventory (inbound, outbound, reservations, stocktaking)
    -   Points / credits (issuance, consumption, expiry, balances)
    -   Free tiers / quotas (grants, consumption, remaining amounts, resets)
    -   Usage-based billing (metering events, aggregates, invoice line items)
    -   Record counts (the correspondence between upstream records, events, and output rows)
-   **Litmus test**: any quantity for which the answer to "should an increase somewhere imply a decrease somewhere else (or an explainable origin for the increase)?" is Yes falls under this file. Cache-like data that can be freely created and destroyed (re-derivable derived values themselves) is out of scope, but **the correspondence between derived values and their source of truth** is a reconciliation target under §3.3.

### §1.2. Responsibility Boundary Table (Adjacent Files)

-   **Rule 710.1.2 (Responsibility boundary)**: This file is canonical only for "the discipline of continuous consistency verification and invariants"; the following are delegated to their respective canonical files (MUST):

| Topic | Canonical file (delegated to) | Relationship to this file |
|:--------|:-------------|:-----------------|
| One-time comparison during migrations/backfills (counts + checksum + sampling) | `engineering/700_batch_backfill_operations.md` §3.7 | 700 canonicalizes "verifying the migration **event**"; this file canonicalizes "continuous verification in **steady-state operation**" |
| Job failure accounting contract (JobRunSummary / 3-valued outcome / DLQ) | `engineering/700` §2 | Reconciliation jobs themselves follow the accounting contract of 700 §2; this file defines the **content** of reconciliation |
| Measurement infrastructure for the 6 data quality dimensions (accuracy, completeness, consistency, timeliness, validity, uniqueness) | `ai/100_data_analytics.md` | ai/100 owns quality metric collection and measurement infrastructure; this file applies invariant verification to conserved quantities |
| Billing/charging/monetization business logic (what to bill and how much) | `product/300_revenue_monetization.md` | The "business definition of the billed amount" is delegated; "the reconciliation discipline checking it matches the definition" is this file |
| SSOT principles and schema evolution (Expand-Contract) | `engineering/000_engineering_standards.md` | Defining where the source of truth lives is delegated; **verifying that source and replicas match** is this file |
| SLOs, alerting, and error budget operation | `operations/400_site_reliability.md` | The SLO indicator definitions of §4.4 live in this file; SLO operation and notification design are delegated |
| Audit logs and data governance (who corrected what, when) | `security/100_data_governance.md` | The audit log requirements for manual adjustments in §5.3 are stated here; log infrastructure and controls are delegated |
| Test layer definitions (unit / integration / E2E) and property-based testing infrastructure | `quality/000_qa_testing.md` | Only testing obligations specific to consistency/reconciliation are defined in §8 of this file |
| Response after an unexplained discrepancy becomes an incident | `operations/500_incident_response.md` | The incident declaration criterion (§4.5) lives in this file; response procedures are delegated |

### §1.3. Core Principles & RFC 2119 Terms

-   **Rule 710.1.3 (RFC 2119)**: **MUST / MUST NOT / SHOULD / MAY** in this file follow the RFC 2119 definitions. MUST denotes a mandatory risk-reduction requirement; deviation requires explicit documentation via an ADR.
-   **Rule 710.1.4 (No overclaiming)**: This file does not promise "zero inconsistencies". The goal is to **structure discrepancy detection, raise explainability, and systematically shorten the dwell time of unexplained discrepancies**. Phrases such as "guaranteed full consistency" or "a design where discrepancies can never occur" are prohibited even in design documents (MUST NOT).
-   **Rule 710.1.5 (No trust without verification)**: A conserved quantity that lacks invariants (§2) and continuous reconciliation (§3) **must not be used directly for decisions** such as billing, financial close, or inventory reservation (MUST NOT). The only exception is a transition period during a planned climb from maturity L1 (§12), recorded in an ADR (MAY).

---

## §2. Explicit Invariants

> This section is the core of this file. An invariant is "an equality or inequality that must hold whenever evaluated, as long as the system is correct"; reconciliation (§3) is the act of continuously evaluating these invariants.

### §2.1. Obligation to Define Invariants

-   **Rule 710.2.1 (Invariant definition obligation)**: Every conserved quantity (§1.1) **must have at least one explicitly documented invariant** (MUST). A conserved quantity without an invariant is "a quantity operated without any definition of correctness".
-   **Rule 710.2.2 (Executability)**: Invariants are defined not as prose but in a **mechanically evaluable form** (SQL, queries, code) (MUST). Unevaluable statements such as "should roughly match" do not count as invariants.
-   **Rule 710.2.3 (Two-path derivation)**: Wherever possible, define invariants as **agreement between values derived via two independent paths** (SHOULD). A check that reads the same column of the same table twice cannot, in principle, detect write bugs (the same principle as `engineering/700` Rule 700.3.13 on independent verification).
-   **Rule 710.2.4 (Two levels of granularity)**: Define invariants at **two levels: global aggregate (overall totals) and per-entity (per account, SKU, or tenant)** (SHOULD). Verifying only the global total structurally misses discrepancies that cancel out, such as +100 and −100.
-   **Rule 710.2.4a (Independent-information matching — self-agreement is not evidence)**: Never satisfy one side of an invariant by agreement with a value stored by the same derivation (MUST NOT) — all that confirms is agreement with your own copy. Decide which side is right from **independent information** (a registered address, the original, an external record), and never cite "N items agree" as evidence of health. For values derived from external input, place "if the input has not changed, use the stored value" ahead of re-derivation (MUST) — re-deriving on every save overwrites hand-corrected stored values every time. Failure pattern: coordinates re-derived from the address on every save revert the corrected coordinates to the wrong value each time.
-   **Litmus test**: if you cannot immediately answer "when this quantity is wrong, which query do I run to prove it is wrong?", the invariant is undefined.

### §2.2. Maintaining the Invariant Catalog

-   **Rule 710.2.5 (Catalog required)**: The project maintains an **invariant catalog** (a version-controlled document or definition file) (MUST). Each entry includes at minimum:

| Field | Content |
|:----------|:-----|
| `invariantId` | Stable unique ID (e.g. `INV-LEDGER-001`) |
| Quantity / tables | Which conserved quantity and which storage are verified |
| Definition (expression) | Mechanically evaluable equality/inequality (§2.1) |
| Check query / code reference | Where the actually executed check lives |
| Cadence | Evaluation frequency (§3.2) |
| Tolerance | Accepted known differences and their rationale (§3.2) |
| Owner | The person/team that responds first when a discrepancy occurs |

-   **Rule 710.2.6 (Design review linkage)**: Design reviews that introduce a new conserved quantity (a new billing unit, point type, or inventory category) treat **adding to the invariant catalog as a mandatory checklist item** (MUST). A PR that adds quantities without adding invariants is sent back.

### §2.3. Representative Invariant Patterns

-   **Rule 710.2.7 (Pattern application)**: Use the following representative patterns as starting points (SHOULD). Prefer porting battle-tested accounting principles over inventing new ones:

| Pattern | Invariant form | Application examples |
|:--------|:----------|:------|
| Double-entry (balanced ledger) | total credits == total debits (always zero-sum) | All movements of money, points, and credits |
| Count conservation | input count == output count + failed count + skipped count | Pipelines, ETL, event processing (the data version of `engineering/700` §2.2) |
| Stock-flow consistency | closing balance == opening balance + inflow − outflow | Inventory, balances, point expiry |
| Zero-sum transfer | decrease at the source == increase at the destination | Inter-account transfers, inter-warehouse moves, tenant reassignment |
| Source-replica agreement | aggregate at the SSOT == aggregate at replicas (cache / search index / analytics) | Continuous verification of `engineering/000` SSOT |
| External reconciliation | own records == external provider records (payments, banks, warehouses) | Payment provider settlement, bank statements, 3PL inventory |
| Duplicated-value agreement | display value == decision value (when the same concept is duplicated in another table / column) | Duplicated document versions, publication states, prices |
| Event-record correspondence | increment of target entities == count of audit rows / notification rows | Audit records of sign-up, login, withdrawal; derived-artifact generation |

-   **Duplicated-Value Write-Path Audit**: When you find "the same meaning stored in two places," count the write paths (MUST). If there is more than one writer, either make one side a derived value that can only hold what flows from the single writer (a convergence point in a DB trigger takes effect whether the write comes through the admin UI, a migration, or direct SQL), or pin agreement mechanically. If the dependent side is changed independently, do not silently overwrite — **stop with an exception** whose message says where to change it (MUST); but write down the invariant you are protecting first and apply the guard only to **the minimum columns and operations (UPDATE only)**, so legitimate seed, snapshot-restore, and fixture operations are not caught. Confirm **which axis** the existing consistency audit looks at (MUST): a time-only check (revision time vs. version-update time) never sees a value mismatch — failure pattern: both timestamps were bumped correctly, yet the display stayed stale for over ten days and the time-based audit never fired. Split the subject set per axis into "subjects with the necessary material," and never feed subjects without material into the time-based test, which makes a permanent warning (MUST). Check mapping tables (column → subject) from the column side by complement, not by naming entries (MUST) — a forgotten entry just makes the function return null and the UPDATE affect 0 rows, and nobody notices. Automate the side effects that accompany a version bump (re-consent prompt, notification, audit old→new) by binding them to the version save operation, and if the public DTO rides on a tagged cache, drop the cache after fixing the DB (SHOULD).
-   **Path Convergence**: Do not place the audit record or notification for an event reachable through multiple paths (OAuth / email sign-up / admin creation / batch, etc.) on one application-layer path; place it at a convergence point every path must pass (a persistence-layer trigger, a single domain service, shared middleware) (MUST). If a branch deliberately discards the record, always add an independent observation of the discard (the daily "event-record correspondence" reconciliation in the table above) (MUST). "The recording code exists and tests are green" is not evidence of recording; do not claim "we record it" until confirmed by real production counts (MUST NOT) — failure pattern: N sign-ups in 30 days, 0 audit rows.

---

## §3. Continuous Reconciliation Jobs

> Reconciliation is the implementation of "trust, but verify". The absence of reconciliation never shows up as an outage; it quietly progresses as an **unverified period**.

### §3.1. Prohibition of One-Time Verification — Make It a Scheduled Job

-   **Rule 710.3.1 (Continuous job obligation)**: Invariant verification must not end as a one-time check at release or migration time; it must operate as a **scheduled, continuously running job** (MUST). Consistency is not "a state confirmed once" but "a property that is continuously re-confirmed". One-time comparison at migration events is canonical in `engineering/700` §3.7; after migration completes, hand over to the continuous jobs of this file.
-   **Rule 710.3.2 (Accounting contract for reconciliation jobs)**: A reconciliation job is itself a machine-invoked job and follows the failure accounting contract of `engineering/700` §2 (JobRunSummary, 3-valued outcome, canonical summary line) (MUST). "Nobody noticed the reconciliation job had been failing" is a double blind spot.
-   **Litmus test**: for any given invariant, can the system immediately answer "when was this invariant last verified?"
-   **Rule 710.3.2a (Separate liveness from data quality)**: A reconciliation job's liveness signal (`ok` / success record) expresses only "it could run," and a data inconsistency of the "stays until a human fixes it" kind is never mixed into `ok=false` (MUST). Decide per kind, and reflect into `ok` only the "self-healing" kinds (counter drift) (MUST). Make the validity condition of a check the number of items it could judge (a coverage floor), and stop auto-close on both "check failed" and "coverage insufficient." Failure pattern: one data problem spawns three permanently open CRITICALs, and a real stop drowns among them. The canonical rule for liveness purity, the coverage floor, and dedicated alerts for irreversible loss is "Liveness Purity" in `operations/400_site_reliability.md`.
-   **Rule 710.3.2b (Separate detection, shard by date)**: Detect "missing / stale" generated or transformed results in a deterministic reconciliation job that involves no generation (no expensive processing such as AI calls) (MUST) — placing detection inside the generation job lets the generation budget constrain detection frequency. There is no need to see everything at once; cycle through a date-determined shard (e.g. `id hash mod N == day mod N`) so the whole set is covered in a few days (SHOULD). Unlike a cursor, it holds no persistent state and cannot break.

### §3.2. Designing Cadence, Scope, and Tolerances

-   **Rule 710.3.3 (Risk-linked cadence)**: Design the verification cadence according to the risk and rate of change of the quantity (MUST). Invariants involving money or billing are evaluated **at least daily** (SHOULD). Record the rationale for the cadence (why this frequency suffices) in the catalog (§2.2).
-   **Rule 710.3.4 (Two layers: incremental + full)**: Design the scope as two layers: **high-frequency incremental verification (recent window) + low-frequency full verification (full scan)** (SHOULD). Incremental-only verification cannot detect silent corruption of historical data (manual operations, side effects of bug fixes).
-   **Rule 710.3.5 (Explicit tolerances)**: When accepting known legitimate differences (rounding, time zones, FX valuation differences), **document the tolerance and its rationale in the invariant catalog** and approve it via an ADR (MUST). "Roughly equal" as a magic number inside code is prohibited (MUST NOT).
-   **Rule 710.3.5a (Completeness of the population fetch)**: Most data-access layers (REST APIs / SDKs / query builders) truncate the response at a default maximum row count (e.g. 1000 rows) **with neither error nor warning**. Never use a bare SELECT that "should return everything" to fetch the population for set decisions, reconciliation, or aggregation (MUST NOT). A query that assumes a full scan fetches with a stable order (PK) + range pagination loop and detects the end by "rows fetched < page size" (MUST) — without depending on a prior total count. Wherever truncation is possible, place a page-boundary regression test with more rows than the default limit (page one full + one row on page two, and the page-two element lands in the set) (MUST) — development-sized data can never detect this structurally. Failure pattern: the covered count stalls at the limit and the same subjects are reprocessed forever in a silent loop.
-   **Rule 710.3.5b (Evaluate after remediation)**: When the SLO evaluation job and the auto-remediation job look at the same subjects (failed rows, pending rows), pin the evaluation time **after** the remediation (MUST). In the reverse order, "one blip → critical notification → fixed by that night's remediation → auto-resolved by the next day's evaluation" mass-produces 24-hour criticals. Only what remains after remediation deserves critical. Write the reason for the run time in both the schedule definition and the platform configuration, and check their agreement mechanically (SHOULD).
-   **Rule 710.3.5c (One plan file defines the targets of sync and verification)**: Put the target definition of sync / replication / verification (target tables / resources, deletion order, conflict keys, optionality, filter kind, raw-compared columns, excluded derived columns) in a single SSOT plan file read by both the sync body and the verification (MUST). Never keep separate arrays on the sync side and the verification side (MUST NOT) — failure pattern: a sync target is added but never added to verification, and only the verification keeps looking at the old targets. Comment in the plan file what it is the SSOT of and who references it, and after a change search for leftover hand-written arrays and run the corresponding verify (SHOULD).

### §3.3. Multi-System Reconciliation

-   **Rule 710.3.6 (Cross-system reconciliation obligation)**: When a conserved quantity is replicated or propagated across multiple systems, **install a reconciliation point at every system boundary** (MUST). Typical reconciliation paths:
    -   DB (source of truth) ↔ cache / search index
    -   DB ↔ external API / payment provider (own records ↔ provider settlement reports)
    -   OLTP ↔ analytics platform (agreement of event counts and amount aggregates)
    -   Metering collection ↔ invoice line items (verification against the billing definition in `product/300`)
-   **Rule 710.3.7 (External provider reconciliation)**: Reconciliation against **systems you do not control** — payment providers, banks, external warehouses — takes the counterparty's official reports (settlement files, statement APIs) as input and machine-matches them against your own records (MUST). "Eyeballing the provider's dashboard" does not count as reconciliation.
-   **Rule 710.3.7a (Skip ledger for unresolved identifiers)**: Treat an external system's identifiers (payments, CRM, ads, shipping) as a distinct type even when their representation (string / uuid) matches your own, and reject confusion at compile time with branded types / newtypes / value objects (SHOULD). Never send a record whose external identifier cannot be resolved; leave it in the ledger as a skip with a reason (MUST) — sending a wrong identifier is the irreversible accident of "charged to someone else," worse than "could not send." Failure pattern: an internal uuid kept being sent in the external customer-ID field, type checks passed, and usage billing never materialized at all. Regression tests assert on the negative side "this is not our own identifier," not just "the format is valid" (SHOULD).
-   **Rule 710.3.7b (Value-domain checks for paths outside the guards)**: For writes through paths the application-layer double guard (allow-set restriction in input components, schema defaults) cannot protect — direct API calls, migration scripts, manual SQL — pick up out-of-allow-set values (`''` / null / old values) as warn in a daily consistency check, and surface a failure of the check itself as critical (SHOULD).
-   **Litmus test**: enumerate the system boundaries the conserved quantity crosses; if even one boundary lacks a reconciliation point, that is where the next inconsistency originates.

### §3.4. Timing Differences & Cutoff Boundaries

-   **Rule 710.3.8 (Defined cutoff)**: Reconciliation is performed against an explicit **cutoff boundary** (MUST). A reconciliation that misclassifies in-flight records as "discrepancies" due to timing differences paralyzes alerting with false positives. Record how the boundary is taken (snapshot time, event time vs. booking time) in the catalog.
-   **Rule 710.3.9 (Explicit in-flight accounting)**: Records not yet finalized at the cutoff are counted independently as **`in_flight`** — neither discrepancy nor match (SHOULD). Only those whose in-flight dwell time exceeds a threshold are promoted to discrepancy candidates.

### §3.5. Discrepancy Remediation Discipline

-   **Rule 710.3.10 (Remediation is a job too)**: Remediating detected discrepancies is executed not as ad-hoc manual SQL but as a **remediation job equipped with dry-run, the accounting contract, and audit logging** (MUST). Execution discipline (dry-run, chunking, kill switch) follows `engineering/700` §3.
-   **Rule 710.3.11 (Re-reconcile after remediation)**: Remediation is judged complete only when **re-evaluating the same invariant comes back green** (MUST). "The remediation script exited successfully" must not be treated as completion.
-   **Rule 710.3.12 (Single remediation path)**: Remediation of money/billing data is consolidated onto the reversal-entry path of §5 (MUST). Overwriting finalized entries is not permitted even for remediation (MUST NOT).
-   **Rule 710.3.13 (Align detection and remediation cadence)**: Align the evaluation cadence of SLOs / consistency checks with the cadence of the job that remediates their violations (retry / repair) (MUST). With daily evaluation and weekly remediation, a critical persists up to a week after the cause is fixed and shipped, and the alert sits "waiting to close." Failure pattern: an SLO evaluated nightly with a weekly retry left missed items waiting to "close in 12 days." When adding detection, wire the remediation path (auto-repair job / manual runbook) in the same change (SHOULD).
-   **Rule 710.3.14 (Pair detection with remediation; never read a cutoff as zero)**: A mechanism that detects missing derived artifacts is paired with **automatic remediation in the same job** (handing the missed source rows to the generation queue) (MUST). With detection only and remediation left to a manual button, the only way a warning closes is "the next time the same shard runs with 0 items." Bound remediation by count and time, treat **a kind that was cut off as "remaining count unknown,"** and close the alert only for kinds fully processed whose rescan returns 0 (MUST). Never read a cutoff as 0 (MUST NOT).
-   **Rule 710.3.15 (Safety conditions for remediation that deletes)**: In an "entities − reference set = orphans" deletion job, never build the reference set with the same narrow filter as the deletion candidates (MUST NOT). Rows that transitioned state (kind change, owner change) keep referencing their old paths, so build the reference set from **all rows without filters** (only a deletion-conservative over-approximation is allowed) via full pagination (Rule 710.3.5a) (MUST). Give any sync that deletes a **mass-loss circuit breaker** (thresholds on both the absolute count and the ratio of deletions, e.g. 10 or more and over 20% of the total), and when exceeded, skip the deletion and hand it to a human (MUST) — a broken scan and a vanished source are indistinguishable as input, so default to suspecting "the scan broke." Regression tests explicitly pin "a row references its old path after a transition" (MUST). Failure pattern: correct logic faithfully acted on broken input and got one step short of permanent deletion.

---

## §4. The Three Reconciliation Metrics (Stripe Ledger Style)

> Stripe's Ledger platform observes reconciliation health via three metrics — Clearing / Timeliness / Completeness — and operates on the "explainability" of discrepancies as an operational indicator. This section ports that framing as a language- and stack-agnostic discipline.

### §4.1. Clearing — Expected Zero Balance in Intermediate Accounts

-   **Rule 710.4.1 (Clearing verification)**: Verify that **intermediate accounts (clearing accounts / suspense accounts / pending reservations) through which flows of funds, inventory, or credits pass converge to an expected zero balance (or an explicitly stated expected value) in steady state** (MUST). A balance lingering in an intermediate account is the best signal of "which stage of the flow is clogged".
-   **Implementation guidance**: make every stage of the flow explicit as an account (double-entry pattern, §2.3) and turn per-stage balances into metrics. Verifying that "only the final result matches" hides clogs at intermediate stages.
-   **Prior art**: Uber's settlement/accounting platform treats the order → payment → settlement flow as per-stage accounts and splits large-scale reconciliation by stage.

### §4.2. Timeliness — Verified-Within-Deadline Ratio

-   **Rule 710.4.2 (Timeliness SLO)**: Measure the proportion of records/events that are **verified within a fixed deadline from occurrence** (MUST). Example: "99.99% verified within 4 days of event occurrence". Design the deadline and ratio according to the risk of the quantity, and place them under `operations/400` operation as an SLO.
-   **Implementation guidance**: visualize the age distribution (aging) of unverified records, and escalate progressively as deadlines approach or are exceeded (SHOULD).
-   **Litmus test**: if you cannot answer numerically "in the worst case, how many days until we notice an inconsistency that occurred just now?", timeliness is not being measured.

### §4.3. Completeness — Statistical Detection of Full Upstream Arrival

-   **Rule 710.4.3 (Completeness detection)**: Detect **the very fact that all upstream records** (event sources, providers) **arrived** at the ledger/platform being verified (MUST). A design that only reconciles what arrived inherently misses "records that never arrived in the first place".
-   **Implementation guidance**: combine upstream/downstream count matching, sequence-number gap detection, and deviation detection against statistical arrival forecasts (expected ranges by weekday/time of day) (SHOULD).
-   **Rule 710.4.3a (Derived-artifact gap detection)**: A job that generates derived artifacts (notifications, indexes, caches, emails, aggregate rows) from source events (publication, orders, sign-ups, etc.) must not be monitored by its liveness and successful exit alone (MUST NOT). Run periodic gap detection that reconciles the count of "the source event exists, but no corresponding derived artifact exists within the deadline (e.g. 30 minutes after publication)" (MUST). Count "what should exist but does not" starting from the source-event ledger (SHOULD) — counting from the derived side cannot see what is missing.

### §4.4. Explainability % as an SLO

-   **Rule 710.4.4 (Explainability SLO)**: Classify detected discrepancies into **`explained` (attributed to known causes) and `unexplained`**, and turn **explainability % (explained / total) into an SLO** (MUST). "Zero discrepancies" must not be an SLO or target (MUST NOT) — a zero-discrepancy target creates the worst incentives: hiding discrepancies and silently widening tolerances.
-   **Rule 710.4.5 (Only unexplained discrepancies are incidents)**: Only **unexplained discrepancies** (and abnormal growth trends in explained ones) are treated as incidents (MUST). Explained discrepancies are counted with classification codes and trend-monitored. Response procedures are canonical in `operations/500`.
-   **Rule 710.4.6 (Dwell deadline for unexplained)**: Give unexplained discrepancies an **investigation deadline (e.g. N business days from detection)**, and turn the count and amount of overdue unexplained discrepancies into metrics (MUST). "Discrepancies left unexplained" is the most important degradation indicator in this file.
-   **Litmus test**: is there an instrument that immediately answers "how old is the oldest unexplained discrepancy, and for what amount?" If not, Rule 710.4.6 is not implemented.

---

## §5. Append-Only & Reversal Entries

> Double-entry general ledgers have been operated for centuries via "append + reversal". The prohibition of overwriting is not a new constraint; it is the port of the most battle-tested accounting control into software.

-   **Rule 710.5.1 (Append-only obligation)**: Record tables for money, billing, and points are **append-only**; correcting finalized entries via UPDATE / DELETE is prohibited (MUST NOT). Overwritable monetary records make root-cause investigation of inconsistencies impossible.
-   **Rule 710.5.2 (Correction via reversal entries)**: Correct an erroneous finalized entry by **appending a reversal entry + the correct replacement entry** (MUST). Correction entries require a reference to the original entry and a correction reason code. This keeps the invariants (double-entry pattern, §2.3) holding even after corrections.
-   **Rule 710.5.2a (Application to non-monetary factual records)**: Apply the same discipline to finalized factual records (medical, inspection, witnessing, test results, etc.): prohibit direct UPDATE / DELETE after a short edit window (e.g. 24 hours from creation), and make corrections by appending a correction record that references the original (SHOULD). Records with evidentiary value fail the same way as money — an overwrite erases the history.
-   **Rule 710.5.3 (Two-step review for manual adjustments)**: Operational manual adjustments require **two-step review separating requester and approver (maker-checker) + audit log recording** (MUST). Audit log infrastructure and retention requirements are canonical in `security/100`. No manual adjustment path executable by a single person may remain (MUST NOT).
-   **Rule 710.5.4 (Adjustments are reconciliation targets)**: Manual adjustments are themselves flows of a conserved quantity and are included in the continuous reconciliation targets of §3 (MUST). "Only the adjustments table is exempt from reconciliation" becomes a loophole.
-   **Rule 710.5.5 (Correction reason taxonomy)**: Manage correction reason codes as a low-cardinality stable enum, and turn correction counts and amounts into metrics per reason (SHOULD). A surge in a specific reason is an early signal of an upstream bug or operational degradation.
-   **Litmus test**: can "why this balance has this value" be reconstructed from the entry history (the append sequence) alone? If not, an overwrite exists somewhere.

---

## §6. Double-Counting Prevention

-   **Rule 710.6.1 (Delegation to idempotency infrastructure)**: The design of idempotency keys, watermarks, and checkpoints for aggregation jobs is canonical in `engineering/700` §3.1–§3.2. This file adds a **verification obligation from the consistency standpoint**: even when aggregation jobs are re-run or started in duplicate, **continuously verify as an invariant** that aggregation results are not double-counted (MUST).
-   **Rule 710.6.2 (Counting duplicate detection)**: Duplicate input events (from at-least-once delivery and retries) are not merely eliminated but **counted and turned into metrics as detections** (SHOULD). A sudden change in the duplicate rate is an early signal of upstream failures or retry storms.
-   **Rule 710.6.3 (Structural uniqueness guarantee)**: Do not rely on application logic alone for double-counting prevention; guarantee it structurally via **storage-layer unique constraints (idempotency keys, event IDs)** (MUST). Constraint violation counts are observed the same way as Rule 710.6.2.
-   **Rule 710.6.4 (Re-derivability)**: Keep stored aggregates **re-derivable** from the source events, and include agreement between re-derived values and stored aggregates in the continuous reconciliation targets of §3 (SHOULD).
-   **Rule 710.6.5 (Convergence of the ledger and the balance cache)**: When several paths return a balance (a counter column, an aggregate view, a balance function), define **the ledger as the single truth and the counter as its cache**, and verify by continuous reconciliation that every read path converges on the same value (MUST). Reconciliation repair is an idempotent migration / job that restores under-counts **only for accounts backed by ledger entries**. Never zero out a balance that has no ledger backing (MUST NOT), and verify `counter ≡ SUM(ledger)` at the end of the repair. Shape of the detection SQL: `SELECT a.id FROM accounts a JOIN (SELECT account_id, SUM(amount) net FROM ledger GROUP BY 1) l ON ... WHERE a.balance IS DISTINCT FROM l.net`. Failure pattern: the counter and the ledger SUM diverged on one production account and surfaced through a user complaint.
-   **Rule 710.6.6 (One sign convention)**: Store ledger amounts signed (grant +, consume −) and compute the balance as a raw SUM. A function that re-signs by type (`CASE WHEN consumed THEN -amount`) double-negates when the inserting side already stores negatives, so align the sign convention across the insert RPC, balance function, views, and counter updates (MUST). Compute absolute aggregates as `SUM(ABS(x))`; `ABS(SUM(x))` is prohibited because mixed signs cancel out (MUST NOT).
-   **Rule 710.6.7 (Count by lineage)**: In a replacement sync where old and new versions coexist (`engineering/700` Rule 700.3.23a), count by lineage (one per version set of the same subject), not by rows (SHOULD) — a row-count comparison misreports deferred duplicates as discrepancies.
-   **Litmus test**: if you cannot answer Yes to "if I re-run this aggregation job right now, will the billed amount stay unchanged to the cent?", a double-counting risk exists.

---

## §7. Drift Detection

-   **Rule 710.7.1 (Quantitative drift criteria)**: Monitor degradation that can progress even while the equalities hold — **distribution shifts (movement of means/quantiles), skew (concentration on specific keys), correlation loss (e.g. broken correlation between order count and payment count)** — with quantitative criteria (thresholds, tolerated ranges) (SHOULD).
-   **Rule 710.7.2 (Coordination with ai/100)**: Distribution monitoring and measurement techniques for the 6 data quality dimensions are canonical in `ai/100`; this file defines only **the application to conserved quantities** (prioritizing which drift of which quantity directly leads to billing/inventory incidents).
-   **Rule 710.7.3 (Recorded threshold reviews)**: Review drift thresholds and tolerated ranges periodically against business seasonality and growth, and record changes with rationale (SHOULD). Silent threshold loosening is prohibited, just like the tolerances of Rule 710.3.5 (MUST NOT).
-   **Litmus test**: is there monitoring that would notice "all invariants are green, yet billed amounts dropped 30% from last month"? Equality verification and drift detection are complementary; either alone is insufficient.

---

## §8. Testing Obligations

> Test layer definitions, test doubles, and other general theory are canonical in `quality/000_qa_testing.md`. This section defines **only testing obligations specific to consistency and reconciliation**.

-   **Rule 710.8.1 (Property tests for invariants)**: Verify via property-based tests that invariants **hold after applying any valid sequence of operations** (MUST). Example: generate random sequences of deposits, withdrawals, and corrections, and assert total credits == total debits after each step.
-   **Rule 710.8.2 (Testing the reconciliation job itself)**: Verify via tests that the reconciliation job **detects and classifies known differences deliberately injected into a dataset** (MUST). A reconciliation job that cannot detect discrepancies is an observation device that mass-produces "false reassurance" — more harmful than not existing.
-   **Rule 710.8.3 (Reversal round-trip tests)**: For reversal entries (§5.2), verify that **invariants and balances remain correct after the round trip of original → reversal → re-correction** (MUST).
-   **Rule 710.8.4 (Cutoff boundary tests)**: For cutoff boundaries (§3.4), verify that in-flight records are not misclassified as discrepancies, and that records finalized after the cutoff are picked up by the next reconciliation run (SHOULD).
-   **Rule 710.8.5 (Catalog coverage verification)**: Verify via CI or periodic checks that every entry in the invariant catalog (§2.2) has an actually scheduled continuous job (SHOULD). This structurally prevents "invariants in the catalog that nobody evaluates".
-   **Rule 710.8.6 (Confirm the source exists first)**: When creating or fixing a detection, aggregation, or monitoring system, count the **production** row count and freshness of the source table first (`count(*)` / `max(created_at)`) (MUST). If it is empty or stopped, send the design itself back — test seeds are copies of your own assumptions, and if the assumption is wrong, everything stays green while being useless. Never use a platform-internal table (internal logs of the auth or storage platform) as a detection source (MUST NOT): the vendor sends no notice when it stops writing. Make a first-party table your app writes the SSOT. "0 because nothing to detect occurred" and "0 because the source is dead" look identical, so include distinguishing observations (scanned count / total rows on the source side) in the detection result to make silence visible (MUST). Failure pattern: a detection that flawlessly scanned a table with zero rows for the entire production lifetime was nearly built.
-   **Rule 710.8.7 (Population condition and positive/negative pair tests)**: When writing a check, first write "which rows does this norm apply to" as the population condition, and place a negative ("out of scope does not fire") and a positive ("in scope fires") as a pair (MUST). A check without a population condition becomes a permanent critical the moment it collides with a UI default. The negation of a state machine ("not published") is not monolithic: separate "not yet published" from "deliberately unpublished," and keep the latter only as a visible data contradiction (MUST). Always count "not even HTTP" failures (the fetch itself failed, invalid URL, timeout) in a separate bucket (MUST); lumping them as 0 turns your own input bug into the counterpart's outage. A monitor that fires constantly is as broken as a silent one; when touching a detector, classify the actual output on real data (by host, by status, by kind) and never claim correctness from aggregates alone (MUST). Failure pattern: a link check with 67% false positives, deliberate unpublishing reported as overdue — both reduce to a missing population definition.
-   **Rule 710.8.8 (Floor on judged count — no vacuous passes)**: A check that skips rows with "`continue` unless the condition holds" loses its scan targets when the remediation succeeds (the entrance closes, the state changes) and keeps returning green without judging a single item (MUST NOT). Whenever you write a skip branch, ask "do the scan targets vanish after remediation?" A scanning check outputs "how many items were judged" and turns red as "scan targets vanished" when the count falls below a floor (MUST) — because "zero violations" is true even with zero targets, attach a test that pins the population itself. But make only "targets existed yet could not be judged" a failure, and distinguish zero targets (a new environment, tests) as "nothing there" rather than a failure (MUST) — unless the two meanings of 0 are separated, the warning never stops. When remediation changes the contract, change the check's contract at the same time (e.g. "noindex is set" → "the entrance is closed") (MUST).

---

## §9. Multi-Perspective Review

### §9.1. Observability

-   **Rule 710.9.1 (Discrepancy metrics)**: Emit discrepancy counts, discrepancy amounts (absolute), explainability % (§4.4), and unexplained dwell time (§4.6) **as metrics**, separately from reconciliation job logs (MUST). Classification codes are a low-cardinality stable enum (the same convention as `engineering/700` §2.6).
-   **Implementation guidance**: make dashboards (§10.3) drill-downable per invariant, with the shortest path to where a discrepancy arises (which invariant, which boundary) (SHOULD).

### §9.2. FinOps

-   **Rule 710.9.2 (Reconciliation cost governance)**: Estimate the scan/transfer cost of full reconciliation (§3.2) up front, and govern it through the cadence balance with incremental verification (SHOULD). Avoid full scans for reconciliation becoming the main driver of the analytics platform bill, by preferring incrementalization, sampling, and aggregate-value matching. General theory: see `operations/600`.

### §9.3. Privacy

-   **Rule 710.9.3 (PII governance in reconciliation logs)**: Apply **masking, tokenization, or referencing (keeping IDs only)** to PII (names, accounts, card references) contained in reconciliation results and discrepancy samples (MUST). Discrepancy investigation logs tend to be retained long-term — a "shadow data store" — so state their retention period explicitly. Details are canonical in `security/000` §7.

---

## §10. Implementation Snippets

> Everything below is a **reference implementation** (e.g. SQL / pseudocode / YAML), shown as representative examples of the language- and stack-agnostic discipline (§2–§4). Translate into the idioms of your own stack.

### §10.1. SQL Examples of Invariant Checks (§2.3 double-entry / stock-flow / count conservation)

```sql
-- INV-LEDGER-001: total credits == total debits (always zero-sum)
-- Any returned row is a violation. Pin the cutoff boundary (§3.4) via as_of.
SELECT
  account_id,
  SUM(CASE WHEN side = 'credit' THEN amount ELSE 0 END) AS credit_total,
  SUM(CASE WHEN side = 'debit'  THEN amount ELSE 0 END) AS debit_total
FROM ledger_entries
WHERE entry_time < :as_of            -- cutoff boundary: exclude in-flight
GROUP BY account_id                  -- §2.1 two-level granularity: evaluate per entity
HAVING SUM(CASE WHEN side = 'credit' THEN amount ELSE -amount END) <> 0;

-- INV-STOCK-001: closing == opening + inbound − outbound (stock-flow consistency)
SELECT s.sku_id, s.closing_qty, o.opening_qty, f.inbound_qty, f.outbound_qty
FROM stock_snapshots s
JOIN stock_snapshots o ON o.sku_id = s.sku_id AND o.as_of = :period_start
JOIN stock_flows    f ON f.sku_id = s.sku_id AND f.period   = :period
WHERE s.as_of = :period_end
  AND s.closing_qty <> o.opening_qty + f.inbound_qty - f.outbound_qty;

-- INV-PIPE-001: input count == output + failed + skipped (count conservation)
SELECT b.batch_id, b.input_count, p.output_count, p.failed_count, p.skipped_count
FROM ingest_batches b
JOIN pipeline_results p ON p.batch_id = b.batch_id
WHERE b.ingested_at < :as_of
  AND b.input_count <> p.output_count + p.failed_count + p.skipped_count;
```

### §10.2. Pseudocode for a Continuous Reconciliation Job (§3 / §4.4)

```text
job reconcile(invariant, as_of):                    # a job following the 700 §2 contract
  left  = evaluate(invariant.source_query,  as_of)  # path A (e.g. own ledger)
  right = evaluate(invariant.target_query,  as_of)  # path B (e.g. provider settlement)
  diffs = compare(left, right, key = invariant.join_key)

  for d in diffs:
    if within_tolerance(d, invariant.tolerance):    # §3.2 documented tolerances only
      count(d, as = "explained", reason = "tolerance")
    elif matches_known_cause(d):                    # known-cause classes (cutoff, FX, etc.)
      count(d, as = "explained", reason = cause_code(d))
    elif is_in_flight(d, as_of):                    # §3.4 in-flight counted independently
      count(d, as = "in_flight")
    else:
      count(d, as = "unexplained")                  # §4.5 only these are incident candidates
      persist_for_investigation(d, deadline = N_business_days)
      # remediation per §3.5: reversal-based remediation job + re-evaluate the invariant

  emit_metrics(explained, unexplained, in_flight, amounts)
  emit_summary_line()                               # 700 §2.5 canonical summary line
  alert if unexplained > 0 or overdue_investigations > 0
```

### §10.3. Indicator Definitions for the Explainability Dashboard (§4 / §9.1)

```yaml
# Reconciliation health dashboard — indicator definitions (reference)
metrics:
  - name: recon_discrepancy_total            # discrepancy count (per classification code)
    labels: [invariant_id, classification]   # explained / unexplained / in_flight
  - name: recon_discrepancy_amount_abs       # total absolute discrepancy amount
    labels: [invariant_id, classification, currency]
  - name: recon_explained_ratio              # explainability % (SLO target, §4.4)
    formula: explained / (explained + unexplained)
  - name: recon_timeliness_ratio             # verified-within-deadline ratio (SLO target, §4.2)
    formula: verified_within_deadline / total_records
  - name: recon_completeness_gap             # upstream arrival gap (§4.3)
    formula: upstream_count - arrived_count
  - name: recon_unexplained_overdue          # unexplained discrepancies past deadline (§4.6)
    labels: [invariant_id]
  - name: recon_clearing_balance             # intermediate account balance (expected zero, §4.1)
    labels: [clearing_account]
```

### §10.4. Example Invariant Catalog Entry (§2.2)

```yaml
# Invariant catalog — example entry (version-controlled)
- invariantId: INV-LEDGER-001
  quantity: user credit balance (conserved quantity: credits)
  pattern: double-entry (balanced ledger)          # §2.3
  definition: "SUM(credit) == SUM(debit) per account, as_of cutoff boundary"
  check_ref: recon/checks/ledger_zero_sum.sql      # §2.1 executable form
  granularity: [global, per_account]               # §2.1 two-level granularity
  schedule: { incremental: hourly, full_scan: weekly }   # §3.2 incremental + full
  tolerance: none (zero rounding by design; adding tolerance requires an ADR)   # §3.2
  cutoff: "entry_time < job start time - 5min"     # §3.4 cutoff boundary
  owner: billing-platform team
  investigation_deadline_business_days: 3          # §4.4 deadline for unexplained
```

---

## §11. Anti-Pattern Catalog

| # | Anti-pattern | Violated rules | Consequence |
|:--|:-------------|:----------|:-----|
| 1 | Reconciled once at migration time, then abandoned forever (no continuous job) | 710.3.1 | Inconsistencies introduced post-migration surface in close and billing |
| 2 | Silently fixing discrepancies via UPDATE (no reversal entry) | 710.5.1–2 | Root-cause investigation becomes impossible and the same discrepancy keeps recurring |
| 3 | Reconciliation run only in test/staging, never installed in production | 710.3.1 | Discrepancies caused by production-specific data and timing go undetected |
| 4 | Unexplained discrepancies left without classification or deadlines | 710.4.4–6 | Explainability degrades and real incidents drown in noise |
| 5 | Monetary tables that allow overwrites (UPDATE / DELETE) | 710.5.1 | Unauditable; correction history vanishes; invariants become unverifiable |
| 6 | Setting "zero discrepancies" as an SLO or performance target | 710.4.4 | Creates incentives to hide discrepancies and silently widen tolerances |
| 7 | Releasing a new billing unit or point type without invariants | 710.2.1, 710.2.6 | Monetary quantities multiply in production without any definition of correctness |
| 8 | "Self-reconciliation" that merely reads the same table twice | 710.2.3 | Verification inherently waves write bugs through |
| 9 | Tolerances set silently as magic numbers in code | 710.3.5 | Tolerances quietly widen and real discrepancies get absorbed into "accepted" |
| 10 | Reconciliation that alerts on in-flight records as discrepancies | 710.3.8–9 | False positives paralyze alerting and real discrepancies get ignored |
| 11 | Settling for eyeballing the provider dashboard as external matching | 710.3.7 | Zero coverage, no records — a "ritual" that vanishes when the person leaves |
| 12 | Not monitoring failures of the reconciliation job itself | 710.3.2 | "The weeks the reconciliation was down" become an unverified period |
| 13 | Trusting a reconciliation job that has no difference-injection tests | 710.8.2 | A reconciliation with zero detection capability keeps reporting "green" |
| 14 | Leaving manual adjustments executable under a single person's authority | 710.5.3 | A single point of failure for fraud and mistakes; inexplicable under audit |
| 15 | Relying on application logic alone to prevent aggregation double-counting | 710.6.3 | Re-runs and races double-count and contaminate downstream billing |

---

## §12. Maturity Model L1–L5

| Level | State | Characteristics |
|:------|:-----|:-----|
| **L1: Unverified** | Consistency is faith | No documented invariants. Inconsistencies surface via user complaints and financial close. Monetary tables are overwritable |
| **L2: Spot-Checked** | One-time checks only | Reconciliation happened at migration/release time, but no continuous job exists. Discrepancy handling depends on individuals |
| **L3: Reconciled** | Continuous reconciliation running | Invariant catalog + continuous reconciliation jobs + append-only / reversal entries implemented. Discrepancies are classified and counted |
| **L4: Measured** | Operated on the 3 metrics | Clearing / Timeliness / Completeness + explainability % SLO in operation. Unexplained discrepancies have investigation deadlines |
| **L5: Self-Correcting** | Verification feeds back into design | Root-cause analysis of discrepancies feeds back into invariants, tolerances, and upstream design. Difference-injection tests run continuously in CI |

-   **Rule 710.12.1 (Minimum bar)**: Production systems handling money or billing require **L3 or above** (MUST). Systems whose billed amounts reach external customers expand only after meeting **operation equivalent to L4** (SHOULD).

---

## Appendix A: Reverse-Lookup Index (keyword → section)

| Keyword | Section |
|:----------|:----------|
| Applicability / conservation laws / which quantities are covered | §1.1 |
| Responsibility boundary / division of labor with 700 / delegation targets | §1.2 |
| Invariant / definition obligation / executability / two-level granularity | §2.1 |
| Invariant catalog / owner / recorded tolerances | §2.2, §10.4 |
| Double-entry / stock-flow / count conservation / zero-sum transfer / SSOT agreement / external reconciliation | §2.3 |
| Continuous job / prohibition of one-time verification | §3.1 |
| Cadence / incremental + full / tolerances | §3.2 |
| Multi-system / cache reconciliation / payment providers / analytics platform | §3.3 |
| Cutoff boundary / in-flight / timing differences | §3.4 |
| Remediation / re-reconcile after remediation / single remediation path | §3.5 |
| Clearing / intermediate accounts / zero suspense balance | §4.1 |
| Timeliness / verified-within-deadline ratio / aging | §4.2 |
| Completeness / upstream arrival / gap detection | §4.3 |
| Explainability % / explained / unexplained / SLO | §4.4–§4.6 |
| Append-only / reversal / prohibition of overwrites | §5 |
| Manual adjustments / maker-checker / two-step review / audit logs / correction reason taxonomy | §5.3–§5.5 |
| Double-counting / idempotency keys / watermark / duplicate detection / re-derivability | §6 |
| Drift / distribution shift / skew / correlation loss | §7 |
| Property tests / difference-injection tests / round-trip tests / catalog coverage | §8 |
| Discrepancy metrics / cardinality | §9.1 |
| Reconciliation cost / FinOps / full-scan governance | §9.2 |
| PII / reconciliation logs / masking / retention period | §9.3 |
| SQL examples / reconciliation pseudocode / dashboard indicators / catalog example | §10 |
| Anti-patterns | §11 |
| Maturity model / L1–L5 / minimum bar | §12 |

---

**References (standards & prior art)**: RFC 2119 / Stripe Ledger (the three metrics — Clearing, Timeliness, Completeness — and explainability-based operation) / Uber's settlement & accounting pipelines (reconciliation of large-scale financial computation) / double-entry bookkeeping & accounting controls (append-only ledgers, reversal entries, maker-checker) / OpenTelemetry Semantic Conventions

**Cross-Reference:**
-   `engineering/700_batch_backfill_operations.md` — canonical for one-time migration comparison (§3.7), the job failure accounting contract (§2), and idempotency keys / watermarks (§3.1–3.2); this file is canonical for the steady-state side
-   `ai/100_data_analytics.md` — canonical for the 6 data quality dimensions, distribution monitoring, and metrics infrastructure (measurement techniques behind §7 drift in this file)
-   `product/300_revenue_monetization.md` — canonical for the business definitions of billing, charging, and monetization (this file is the reconciliation discipline against those definitions)
-   `engineering/000_engineering_standards.md` — canonical for SSOT principles and schema evolution (the premise of source-replica agreement in §2.3 of this file)
-   `operations/400_site_reliability.md` — canonical for SLO operation and alert design (the side that operationalizes the indicators of §4 in this file)
-   `operations/500_incident_response.md` — canonical for response procedures when an unexplained discrepancy becomes an incident
-   `operations/600_cloud_finops.md` — general theory of reconciliation cost governance (§9.2 of this file)
-   `security/100_data_governance.md` — canonical for audit logs and data governance (recording requirements for manual adjustments in §5.3 of this file)
-   `security/000_security_privacy.md` — §7 Privacy by Design (PII governance inside reconciliation logs)
-   `quality/000_qa_testing.md` — canonical for test layer definitions and property-based testing infrastructure (§8 of this file holds only consistency-specific obligations)
-   `core/000_core_mindset.md` — prohibition of unverified completion reports, fact-based reporting fundamentals

---

**Last Updated**: 2026-06-12
**Authority**: Universal Constitution (axiarch core)
**Classification**: Engineering — Data Reconciliation & Invariants
