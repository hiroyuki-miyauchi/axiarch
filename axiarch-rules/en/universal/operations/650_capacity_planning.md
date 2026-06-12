# 650. Capacity Planning & Scale Cliffs

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-06-12

> [!IMPORTANT]
> **Level 1 Priority: Absolute Compliance**
> Capacity-driven outages do not happen "suddenly one day." They happen because **the limit was foreseeable months in advance, yet nobody had recorded it in a ledger**.
> The MUST requirements in this file exist to reduce risk and raise the quality floor; they take priority over implementation convenience and development velocity.

> [!CAUTION]
> **Primary Directive**
> "Systems do not scale linearly. There is always a 'cliff' somewhere, and cliffs must not be discovered upon arrival — they must be **enumerated, measured, and recorded in a ledger in advance**."
> What this file canonicalizes is **"proactive capacity planning, empirical calibration via load testing, and the scale cliff ledger."** Reactive saturation monitoring, SLOs, and alerting infrastructure are delegated to `operations/400` Part XXVII (§65–§66), and cost optimization to `operations/600` (see the responsibility boundary table in §1.2).

---

## Table of Contents

- §1. Primary Directive & Scope
  - §1.1. Applicability
  - §1.2. Responsibility Boundary Table (Adjacent Files — Proactive Planning vs Reactive Detection)
  - §1.3. Core Principles & RFC 2119 Terms
- §2. Scale Cliff Ledger (Core of This File)
  - §2.1. Definition of Scale Cliffs & Enumeration Obligation
  - §2.2. Standard Fields of the Cliff Ledger
  - §2.3. Current/Limit Ratio Monitoring & Lead-Time Alerts
  - §2.4. Cloud Service Quota Governance
  - §2.5. Keeping the Ledger Fresh
- §3. Empirical Capacity Calibration
  - §3.1. Prohibition of Folklore Numbers
  - §3.2. Breaking Point Test (Identifying the First Resource to Saturate)
  - §3.3. Periodic Recalibration
- §4. Headroom Policy
  - §4.1. Explicit Numeric Headroom
  - §4.2. N+1 / N+2 Redundancy
- §5. Load Testing Discipline
  - §5.1. Production-Equivalent Configuration & Data Distribution
  - §5.2. Four Scenarios (average / peak / spike / soak)
  - §5.3. Pre-Release Regression Load Testing
  - §5.4. Pre-Testing Before Known Events
- §6. Autoscaling Governance
  - §6.1. Mandatory Upper Bounds
  - §6.2. Defined Behavior at the Upper Bound
  - §6.3. Scaling Speed vs the Cliff (Warm-Up Time)
- §7. Demand Forecasting
- §8. Graceful Degradation Design
- §9. Testing Obligations (Connecting to quality/000)
- §10. Implementation Snippets (Reference Implementations)
- §11. Anti-Pattern Catalog
- §12. Maturity Model L1–L5
- Appendix A: Reverse-Lookup Index
- Cross-Reference

---

## §1. Primary Directive & Scope

### §1.1. Applicability

-   **Rule 650.1.1 (Scope of Application)**: This file applies to **all proactive capacity-planning activity for every system that handles production traffic or production data** (MUST). This includes, but is not limited to:
    -   Enumerating, recording, and monitoring scale cliffs (limits beyond which scaling is non-linear)
    -   Empirical capacity calibration via load testing and identification of breaking points
    -   Establishing headroom and redundancy policies
    -   Governing autoscaling upper bounds, behavior, and speed
    -   Demand forecasting (organic / non-organic) and lead-time management for capacity procurement
-   **Litmus test**: Any system for which you cannot immediately answer — **based on measurement** — "how many multiples of current load can this system withstand, and what breaks first?" is non-compliant with this file.

### §1.2. Responsibility Boundary Table (Adjacent Files — Proactive Planning vs Reactive Detection)

-   **Rule 650.1.2 (Responsibility Boundary)**: This file is canonical only for "**proactive** capacity planning, load testing, and the cliff ledger"; the following are delegated to their canonical files (MUST):

| Topic | Canonical File (Delegation Target) | Relationship to This File |
|:--------|:-------------|:-----------------|
| Operational saturation thresholds (CPU/memory/disk Warning/Critical), SLOs, and alert delivery infrastructure | `operations/400_site_reliability.md` Part XXVII §65–§66, Part X | 400 is canonical for **reactive detection** (monitoring and notifying on saturation). This file defines **what** to register as cliffs for monitoring (§2); notification design and delivery are delegated |
| Load-testing tooling and the prohibition of load testing in production | `operations/400_site_reliability.md` Part XVIII §46 | 400 is canonical for test-environment constraints and tools. This file defines how to discipline load testing **as a capacity-calibration instrument** (§3, §5) |
| Cost optimization, budget alerts, and pay-as-you-go governance | `operations/600_cloud_finops.md` | Autoscaling upper bounds (§6.1) and demand forecasting (§7) connect to 600 on the cost side. 600 is canonical for cost |
| Response after a capacity-driven failure becomes an incident | `operations/500_incident_response.md` | Delegated once a cliff hit becomes an incident |
| Downstream protection for batch/backfill and job-driven capacity consumption | `engineering/700_batch_backfill_operations.md` §3.3, §5.2–§5.3 | The discipline for jobs that step over cliffs lives in 700. This file defines and monitors the cliffs |
| User-experience design of graceful degradation | `design/000_design_ux.md` | §8 defines the **priority design** of degradation; UX expression is delegated |
| Test layer definitions (unit / integration / E2E) | `quality/000_qa_testing.md` §5–§6 | Only capacity-specific testing obligations are defined in §9 of this file |

-   **One-sentence boundary summary**: `operations/400` is canonical for "the mechanism that **notices** saturation"; this file is canonical for "the mechanism that **plans before** saturation."

### §1.3. Core Principles & RFC 2119 Terms

-   **Rule 650.1.3 (RFC 2119)**: **MUST / MUST NOT / SHOULD / MAY** in this file follow the RFC 2119 definitions. MUST requirements exist for risk reduction; deviations require an explicit record via ADR.
-   **Rule 650.1.4 (No Exaggeration)**: This file does not promise "zero capacity-driven outages." Its purpose is to **systematically convert unknown cliffs into known ones and structurally secure lead time before they are reached**. Phrases such as "scales infinitely" or "capacity is not a concern" are prohibited even in design documents (MUST NOT).
-   **Rule 650.1.5 (No Capacity Claims Without Measurement)**: Capacity estimates that are not grounded in measurement (load tests / calibration against production metrics) must not be used as the basis for procurement, scaling decisions, or go/no-go decisions on events (MUST NOT). Prior norm: the Google SRE Book explicitly warns against relying on "folklore numbers" in capacity planning.

---

## §2. Scale Cliff Ledger

> This section is the core of this file. A "scale cliff" is a limit value up to which performance remains roughly linear and **beyond which the system degrades or stops non-linearly the moment it is reached**. A cliff only becomes manageable once it is in the ledger.

### §2.1. Definition of Scale Cliffs & Enumeration Obligation

-   **Rule 650.2.1 (Cliff Enumeration Obligation)**: Every system must maintain a **Scale Cliff Ledger** that enumerates "limits beyond which scaling is non-linear" (MUST). At minimum, the following categories must be considered:

| Category | Example Cliffs | Typical Consequence on Arrival |
|:--------|:------|:-----------------|
| **DB max connections** | PostgreSQL `max_connections`, managed-DB plan limits | New connections rejected → application-wide errors |
| **Connection pools** | Application-side pool size, pooler (PgBouncer, etc.) limits | Latency spikes from connection waits → cascading timeouts |
| **Hot partitions / hot keys** | Access concentration on a specific partition or key | A single shard saturates even with overall capacity to spare |
| **External API rate limits** | Per-second / per-day limits of payments, notifications, LLMs, etc. | Repeated 429s → feature outage or DLQ backlog |
| **Cloud service quotas** | Instance counts, IP counts, concurrency, storage API limits | Scaling out itself fails (§2.4) |
| **File descriptors** | Process / OS FD limits (including sockets) | accept failures; sudden death under connection leaks |
| **Single-region capacity** | Physical limits of instances/bandwidth procurable in one region | No capacity at the failover target during a region outage |

-   **Rule 650.2.2 (No Implicit Cliffs)**: "Default values nobody remembers setting" are also cliffs. DB connection counts, FD limits, and cloud quotas **must not be operated in production without their default values having been checked** (MUST NOT). When a default is adopted as-is, record that value in the ledger as a "deliberate adoption" (MUST).

### §2.2. Standard Fields of the Cliff Ledger

-   **Rule 650.2.3 (Standard Fields)**: Every entry in the cliff ledger must contain the following fields (MUST):

| Field | Meaning |
|:----------|:-----|
| `id` / `name` | Unique identifier and human-readable name of the cliff |
| `category` | Category classification per §2.1 |
| `limit_value` | Limit value (number + unit) |
| `limit_source` | Provenance of the limit (config file / cloud console / measurement; if "estimated," say so explicitly) |
| `current_value_metric` | Metric from which the current value is obtained (monitoring target of §2.3) |
| `ratio_warning` / `ratio_critical` | Warning / critical thresholds on the ratio (e.g., 0.7 / 0.85) |
| `lead_time_days` | Lead time to secure before arrival (e.g., 30 days; derived from the time the mitigation takes) |
| `mitigation` | Pre-arrival mitigation (limit-increase request / sharding / pool expansion, etc.) and its duration |
| `behavior_at_limit` | What happens upon arrival (measured, or with citation) |
| `owner` / `last_verified` | Owner and last verification date (§2.5) |

-   **Rule 650.2.4 (limit_source Discipline)**: Entries whose `limit_source` remains "estimated" are treated as unverified and queued for empirical calibration per §3 (MUST). Estimated values must not be treated as if verified (MUST NOT).

### §2.3. Current/Limit Ratio Monitoring & Lead-Time Alerts

-   **Rule 650.2.5 (Ratio Monitoring)**: For every ledger entry, continuously emit the **current value / limit value ratio** as a metric (MUST). Monitoring absolute values alone gives no reading of "distance to the cliff."
-   **Rule 650.2.6 (Lead-Time Alerts)**: In addition to ratio-threshold alerts, **estimate the limit-arrival date from the current growth rate and alert when it falls within `lead_time_days` (e.g., 30 days)** (MUST). Learning three days in advance about a cliff whose mitigation takes two weeks is too late. Alert delivery and notification design are delegated to `operations/400` Part X.
-   **Rule 650.2.7 (Explicit Forecast Assumptions)**: Arrival-date forecasting uses linear extrapolation as the minimum (MAY: seasonality-aware models), and **the assumptions of the forecast (extrapolation window, growth-rate computation window) are displayed on the dashboard** (SHOULD). Forecasts are cross-checked against demand-forecast events of §7 (campaigns, etc.) and corrected (SHOULD).

### §2.4. Cloud Service Quota Governance

-   **Rule 650.2.8 (Quota Ledgering)**: Register in the ledger **every cloud service quota (service limit) that the architecture depends on** (MUST). Prior norm: AWS Well-Architected Reliability Pillar REL01, "Manage service quotas and constraints," places quota awareness, monitoring, and headroom as the first question of reliability design.
-   **Rule 650.2.9 (Automated Quota Monitoring)**: Current quota consumption and limits are obtained and monitored **automatically**, not by manual checks (SHOULD). Prior examples: AWS Service Quotas API + utilization alarms, GCP quota metrics.
-   **Rule 650.2.10 (Lead Time for Increase Requests)**: Assume quota increases **can take days from request to application**, and bake the request duration into `lead_time_days` (MUST). Quotas in failover-target regions are also **kept at production-equivalent levels in steady state** (MUST) — a design that starts with a quota request when DR is invoked fails this rule.

### §2.5. Keeping the Ledger Fresh

-   **Rule 650.2.11 (Periodic Verification)**: Re-verify every ledger entry periodically (quarterly as an upper-bound guideline) and update `last_verified` (MUST). Limits move **without announcement** through plan changes, infrastructure refreshes, and library upgrades.
-   **Rule 650.2.12 (Ledger Updates on Change)**: Design reviews for architecture changes (DB migrations, new external API adoption, region additions, etc.) **include adding/updating cliff-ledger entries as a completion criterion** (MUST).

---

## §3. Empirical Capacity Calibration

### §3.1. Prohibition of Folklore Numbers

-   **Rule 650.3.1 (Folklore Numbers Prohibited)**: A capacity conversion factor such as "X instances handle Y QPS" **must not be reused as folklore, as analogy from another system, or as oral tradition** (MUST NOT). Prior norm: the Google SRE Book points out that capacity factors silently rot as code, data, and traffic patterns change, and requires periodic recalibration via load testing.
-   **Rule 650.3.2 (Factor Provenance)**: Capacity conversion factors (QPS per instance, memory per connection, etc.) are recorded **with measurement date, measurement configuration, and measurement scenario** (MUST). A factor without provenance is treated on par with the "estimated" status of §2.4.

### §3.2. Breaking Point Test (Identifying the First Resource to Saturate)

-   **Rule 650.3.3 (Breaking Point Identification)**: Load testing must include, beyond pass/fail against targets, a **breaking point test that ramps load to the limit and identifies "the first resource to saturate"** (MUST). Whether the first saturation is CPU, DB connections, an external API, or FDs dictates entirely different mitigations.
-   **Rule 650.3.4 (Feedback into the Cliff Ledger)**: Limits discovered by breaking point tests **must be registered in the cliff ledger of §2** (MUST). They must not end their life inside a test report.
-   **Rule 650.3.5 (Recording the Degradation Mode)**: Record the **shape of degradation** at the limit (latency spike / error-rate rise / sudden death / avalanche cascade) (SHOULD). The degradation mode feeds the graceful-degradation design of §8 and the alert design of `operations/400`.

### §3.3. Periodic Recalibration

-   **Rule 650.3.6 (Periodic Recalibration)**: Capacity conversion factors and breaking points are **re-measured periodically** (MUST). Frequency is set according to the system's rate of change, but recalibration is mandatory after major architecture changes, dependency upgrades, and traffic-pattern shifts.
-   **Rule 650.3.7 (Toward Automated Calibration)**: Recalibration is recommended to be automated as a **reproducible script/pipeline**, not a manual one-off event (SHOULD). Calibration that is not automated stops being performed.

---

## §4. Headroom Policy

### §4.1. Explicit Numeric Headroom

-   **Rule 650.4.1 (Headroom in Writing)**: Every system must **state in writing, as a number, the margin (headroom) maintained at peak** (MUST). Examples: "30–40% margin over forecast peak" or "N+1 / N+2" (§4.2). Headroom that is not written down does not exist.
-   **Rule 650.4.2 (Headroom Rationale)**: Headroom values are grounded in **forecast error, observed spike variability, and scaling duration (§6.3)** (SHOULD). An ungrounded uniform value can fail in either direction — excess (cost waste — `operations/600`) or shortfall (cliff impact).
-   **Rule 650.4.3 (Headroom Monitoring)**: Effective headroom (margin relative to forecast peak) is permanently visible on a dashboard, and a capacity-addition ticket is filed when it falls below policy (MUST). Example indicators in §10.3.

### §4.2. N+1 / N+2 Redundancy

-   **Rule 650.4.4 (The N+2 Criterion)**: Capacity for availability-critical services is designed so that **"peak load can still be served by remaining capacity even when a planned outage (maintenance/deploy) and an unplanned outage (failure) occur simultaneously"** (SHOULD). Prior norm: N+2 provisioning in the Google SRE Book — survive one unplanned unit loss during one planned unit outage.
-   **Rule 650.4.5 (Redundancy vs Headroom)**: N+1/N+2 is **tolerance to unit loss**; % headroom is **tolerance to demand overshoot**. They are not substitutes for one another (MUST: consider both explicitly).
-   **Rule 650.4.6 (Failover Target Capacity)**: In multi-region / multi-AZ topologies, **the failover target's capacity to absorb the residual traffic (including quotas, §2.4) is secured in steady state** (MUST). Failover is not "switching a route"; it is "absorbing capacity."

---

## §5. Load Testing Discipline

> Environment constraints for load testing (prohibition of load testing in production) and tooling are canonical in `operations/400` Part XVIII §46. This section defines the discipline that makes load testing **valid as an instrument of capacity planning**.

### §5.1. Production-Equivalent Configuration & Data Distribution

-   **Rule 650.5.1 (Production-Equivalent Configuration)**: Load tests used for capacity calibration are run on a **production-equivalent configuration (instance sizes, replica counts, network paths, settings)** (MUST). Results from a scaled-down environment must not be linearly extrapolated into capacity claims (MUST NOT) — cliffs are cliffs precisely because they do not extrapolate linearly.
-   **Rule 650.5.2 (Production-Equivalent Data Distribution)**: Test data matches production not only in volume but in **distribution (cardinality, hot-key skew, record-size distribution)** (MUST). Uniformly distributed synthetic data is in principle incapable of detecting the hot-partition cliff (§2.1). Reuse of production data containing PII follows the governance of `security/000` (MUST).

### §5.2. Four Scenarios (average / peak / spike / soak)

-   **Rule 650.5.3 (Four Scenarios)**: Capacity-calibration load testing distinguishes and runs at minimum the following four scenarios (MUST):
    1.  **Average**: baseline acquisition at normal-time-equivalent load
    2.  **Peak**: sustained load at forecast peak + headroom
    3.  **Spike**: rapid surge over a short window (verifies autoscaling tracking speed, §6.3)
    4.  **Soak**: long-duration sustained load (detects **time-axis cliffs** such as leaks, FD exhaustion, and creeping disk usage)
-   **Rule 650.5.4 (No Scenario Omission)**: Spike and soak are not "substitutable by average / peak" (MUST NOT: any omission is recorded via ADR). Spike is the only scenario that detects scaling-speed cliffs; soak is the only scenario that detects resource-leak cliffs.

### §5.3. Pre-Release Regression Load Testing

-   **Rule 650.5.5 (Regression Load Testing)**: Changes that can affect performance or capacity (data-access-pattern changes, dependency additions, serialization-format changes, etc.) are verified for capacity-factor regression via **regression load tests** before release (MUST). The pass criterion is a pre-defined threshold (e.g., capacity-factor degradation within X%); exceeding it blocks the release (aligned with the criteria of `operations/400` §46).
-   **Rule 650.5.6 (Tracking Cumulative Degradation)**: Small degradations within threshold in isolation are **tracked cumulatively** (SHOULD). A system that gets 3% slower per release reaches the cliff within a year.

### §5.4. Pre-Testing Before Known Events

-   **Rule 650.5.7 (Pre-Event Testing)**: Before **known demand events** — flash sales, campaigns, media exposure, major launches — **a pre-test against the forecast peak must be performed** (MUST). Consult the cliff ledger (§2) and pre-inspect the cliffs the event could step over (external API rate limits, quotas).
-   **Rule 650.5.8 (Event Capacity Plan)**: For major events, produce a one-page **event capacity plan** covering forecast peak, secured capacity, at-risk cliffs and mitigations, day-of monitoring arrangements, and graceful-degradation activation criteria (§8) (SHOULD).

---

## §6. Autoscaling Governance

### §6.1. Mandatory Upper Bounds

-   **Rule 650.6.1 (Upper Bound Required)**: Autoscaling **must have an upper bound (maximum instances / maximum concurrency)** (MUST). Unbounded autoscaling is a device that converts DDoS attacks, bug-driven retry storms, and runaway jobs **directly into a bill** (cost governance is canonical in `operations/600`).
-   **Rule 650.6.2 (Grounding the Upper Bound)**: The upper bound is grounded in both "the cost ceiling" and "the downstream cliff (DB connections, etc. — the point at which downstream saturates first no matter how far you scale)" (MUST). If the DB-connection cliff sits in front, the effective bound is there, even if the application tier could scale indefinitely.

### §6.2. Defined Behavior at the Upper Bound

-   **Rule 650.6.3 (Behavior at the Bound)**: The behavior upon reaching the autoscaling upper bound must be **defined in advance** (MUST). The options are load shedding (rejecting low-priority requests), queueing, or graceful degradation (§8); "undefined (= indiscriminate timeouts)" is not acceptable. Implementation details of resilience patterns (load shedding / backpressure / circuit breaker) are delegated to `operations/400` Part XIX.
-   **Rule 650.6.4 (Observing Bound Arrival)**: Reaching the bound (and any rejection/degradation it triggers) is emitted as metrics and alerted on (MUST). If you cannot see "the bound protected us," you lose every opportunity to revisit the bound.

### §6.3. Scaling Speed vs the Cliff (Warm-Up Time)

-   **Rule 650.6.5 (Measuring Scaling Speed)**: **Measure and record** "the time from scaling decision to ready-to-serve" (provisioning + startup + warm-up: JIT, caches, connection establishment) (MUST). Autoscaling **might as well not exist for spikes faster than the warm-up time**.
-   **Rule 650.6.6 (Choosing a Spike Strategy)**: Systems whose warm-up time exceeds their spike rise time explicitly choose one of: scheduled (pre-emptive) scaling, standing headroom (§4), or warm pools (MUST). Also inspect whether overly aggressive scale-in is eroding spike tolerance (SHOULD).

---

## §7. Demand Forecasting

-   **Rule 650.7.1 (Two Streams of Demand)**: Demand forecasting **manages organic demand (natural growth, seasonality) and non-organic demand (campaigns, feature launches, media exposure) separately** (MUST). Prior norm: capacity planning in the Google SRE Book is built on this dichotomy. Organic demand can be forecast by extrapolation; non-organic demand can only be forecast by **collecting planning information**.
-   **Rule 650.7.2 (Periodic Updates)**: Demand forecasts are updated periodically (quarterly as an upper-bound guideline), and **the gap between the previous forecast and actuals is recorded** (MUST). A forecast whose error is never recorded never improves.
-   **Rule 650.7.3 (Advance Channel for Non-Organic Demand)**: Define a channel through which marketing and business campaign plans **reach the capacity-planning owner in advance** (MUST). Running a campaign without knowing the cliffs is the most critical anti-pattern of §11.
-   **Rule 650.7.4 (FinOps Connection)**: Demand forecasts are shared with the `operations/600` process as **input to cost forecasting**, not only capacity procurement (SHOULD). In an organization where capacity planning and cost planning use different numbers, one of them is always wrong.

---

## §8. Graceful Degradation Design

-   **Rule 650.8.1 (Degradation Designed in Advance)**: **Design in peacetime what to give up, and in what order**, upon cliff arrival or capacity overrun (MUST). The degradation order must not be improvised in the middle of an overload.
-   **Rule 650.8.2 (Priority-Based Shedding)**: Tier requests/features by criticality (e.g., checkout > browsing > recommendations > analytics events) and design for **progressive shedding starting from the lowest priority** under capacity pressure (MUST). Implementation patterns (load shedding / circuit breaker / maintenance mode) are delegated to `operations/400` Part XIX and Part XXI.
-   **Rule 650.8.3 (Minimizing User Impact)**: User-facing behavior during degradation (hiding features, simplified rendering, explicit notices) is designed per the UX principles of `design/000`, and degradation **must not be expressed as silent errors or infinite spinners** (MUST NOT).
-   **Rule 650.8.4 (Activation & Deactivation Criteria)**: Define numeric activation and deactivation conditions (with hysteresis) for each degradation stage, and automate activation where possible (SHOULD). For manual activation, the authorized roles and procedure are codified in a runbook (MUST).

---

## §9. Testing Obligations

> Test layer definitions and general test-environment policy are canonical in `quality/000_qa_testing.md`. This section defines **only cliff-scenario-specific testing obligations**.

-   **Rule 650.9.1 (Cliff Scenario Testing)**: For the major entries of the cliff ledger (§2), **test the behavior of actually reaching the cliff in a non-production environment** (MUST). At minimum, include the following scenarios:
    1.  **Connection exhaustion**: deliberately exhaust DB connections / connection pools and observe queueing, timeouts, and error propagation
    2.  **Quota / rate-limit arrival**: verify that retry discipline (`engineering/700` §3.10) and degradation (§8) behave as designed when external API or cloud quota limits are reached
    3.  **Cache total-loss cold start**: verify the origin (DB, etc.) withstands the avalanche load (cache stampede) of a restart from a fully lost cache (caching discipline is canonical in `engineering/730_caching_discipline.md`)
-   **Rule 650.9.2 (Testing the Degradation Design)**: The graceful degradation of §8 **does not count as designed unless it has been tested, including activation and deactivation** (MUST). A degradation mechanism that has never fired is unverified code that runs for the first time in production.
-   **Rule 650.9.3 (Testing Autoscaling Behavior)**: The at-bound behavior and scaling speed (including warm-up) of §6 are verified via spike-scenario load tests (§5.2) (MUST).
-   **Rule 650.9.4 (Feeding Results Back)**: The actual behavior observed in cliff-scenario tests (`behavior_at_limit`) is reflected back into the cliff ledger (MUST).

---

## §10. Implementation Snippets

> Everything below is a **reference implementation** (e.g., YAML / pseudo-configuration) and does not mandate any specific tool. Translate into the idioms of your own stack.

### §10.1. Cliff Ledger Schema Example (e.g., YAML)

```yaml
# scale-cliff-ledger.yaml — reference expression of the §2.2 standard fields
- id: db-max-connections
  name: "Production PostgreSQL max connections"
  category: db_connections
  limit_value: 500            # unit: connections
  limit_source: "managed-db plan spec (verified 2026-05-20)"   # say "estimated" explicitly if so (Rule 650.2.4)
  current_value_metric: "db.connections.active"
  ratio_warning: 0.70
  ratio_critical: 0.85
  lead_time_days: 30          # derived from mitigation duration (plan change + pooler retuning)
  mitigation: "Plan upgrade (1 business day) + pooler limit reallocation (same day)"
  behavior_at_limit: "New connections rejected (FATAL: too many connections) — measured in staging 2026-04"
  owner: platform-team
  last_verified: 2026-05-20

- id: payment-api-rate-limit
  name: "Payment provider API rate limit"
  category: external_api_rate_limit
  limit_value: 100            # unit: req/s
  limit_source: "Provider contract v3 §4.2"
  current_value_metric: "payment.api.requests.rate"
  ratio_warning: 0.50         # drawn early because raising it requires external negotiation
  ratio_critical: 0.70
  lead_time_days: 60          # raising the limit requires commercial negotiation
  mitigation: "Negotiate contractual limit increase / batch requests"
  behavior_at_limit: "HTTP 429 + Retry-After — retry discipline per engineering/700 §3.10"
  owner: payments-team
  last_verified: 2026-06-01
```

### §10.2. Quota Monitoring Pseudo-Configuration (§2.3, §2.4)

```text
# Pseudo-configuration — ledger-driven quota / cliff monitoring (vendor-agnostic)
for entry in scale_cliff_ledger:
    current = query_metric(entry.current_value_metric)     # automated retrieval (Rule 650.2.9)
    ratio   = current / entry.limit_value
    emit_metric("capacity.cliff.ratio", value=ratio, labels={cliff_id: entry.id})

    growth_per_day = linear_regression(metric_history(entry, window=28d))
    if growth_per_day > 0:
        days_to_limit = (entry.limit_value - current) / growth_per_day
        emit_metric("capacity.cliff.days_to_limit", value=days_to_limit, labels={cliff_id: entry.id})

alert ratio        >= entry.ratio_warning       -> ticket (business-hours response)
alert ratio        >= entry.ratio_critical      -> page (alert delivery per operations/400 Part X)
alert days_to_limit <= entry.lead_time_days     -> ticket (lead-time alarm — Rule 650.2.6)
```

### §10.3. Headroom Dashboard Indicators (§4)

```text
# Minimum indicator set for headroom visibility (Rule 650.4.3)
capacity.headroom.ratio        = (calibrated_capacity - forecast_peak) / calibrated_capacity
                                 # calibrated_capacity is the output of §3 calibration. Folklore numbers prohibited
capacity.cliff.ratio{cliff_id} = current / limit                    # per-cliff pressure (§10.2)
capacity.cliff.days_to_limit{cliff_id}                              # arrival forecast (assumptions annotated — Rule 650.2.7)
capacity.autoscale.at_max      = 1 if current_instances == upper_bound else 0  # bound-arrival observation (Rule 650.6.4)
capacity.scaleup.seconds       = measured time from scaling decision → in service (Rule 650.6.5)
capacity.forecast.error.ratio  = |actual_peak - forecast_peak| / forecast_peak   # forecast-accuracy feedback (Rule 650.7.2)
```

---

## §11. Anti-Pattern Catalog

| # | Anti-Pattern | Violated Rules | Consequence |
|:--|:-------------|:----------|:-----|
| 1 | Talking about capacity in folklore numbers ("we measured X instances = Y QPS once") | 650.3.1 | The factor rots; the capacity you thought you secured does not exist |
| 2 | Running production on default cloud quotas / DB connection limits | 650.2.2 | Growth collides with "a limit nobody remembers setting" → full outage |
| 3 | Autoscaling with no upper bound | 650.6.1 | DDoS and retry storms are converted into an uncapped bill |
| 4 | First load test performed after release (after problems appear) | 650.5.5 | Production users are the first detectors of capacity regression |
| 5 | Running campaigns / flash sales without a cliff ledger | 650.5.7, 650.7.3 | External API rate limits and quotas are stepped over on event day |
| 6 | Claiming production capacity by linearly extrapolating scaled-down test results | 650.5.1 | Cliffs do not extrapolate; the estimate hides the cliff's existence |
| 7 | Load testing with uniformly distributed synthetic data | 650.5.2 | Hot-partition / hot-key cliffs are undetectable |
| 8 | Omitting spike and soak scenarios | 650.5.4 | Scaling-speed cliffs and resource-leak cliffs remain undetected |
| 9 | Monitoring only absolute values, never the current/limit ratio | 650.2.5 | Nobody can see "how far to the cliff" |
| 10 | Ratio monitored but no lead-time (arrival forecast) alert | 650.2.6 | Awareness arrives later than mitigation duration; the fix cannot land in time |
| 11 | Failover region capacity and quotas never secured | 650.4.6, 650.2.10 | When DR fires, "the target has no capacity" is discovered |
| 12 | Declaring autoscaling as the spike answer without measuring warm-up time | 650.6.5–6 | Scaling cannot keep up with the spike rise; the cliff is reached |
| 13 | Undefined behavior at the bound (left to indiscriminate timeouts) | 650.6.3 | High-priority work dies at random; damage is maximized |
| 14 | Designing graceful degradation but never test-firing it | 650.9.2 | Under real overload, the degradation mechanism fails on first-run bugs |
| 15 | Breaking-point findings left in test reports, never fed into the ledger | 650.3.4 | The next team rediscovers the same cliff in production |

---

## §12. Maturity Model L1–L5

| Level | State | Characteristics |
|:------|:-----|:-----|
| **L1: Unaware** | Cliffs unknown | Capacity is "add more when it breaks." No ledger of limits. Quotas and connection counts at defaults |
| **L2: Reactive** | Saturation monitoring only | `operations/400` saturation monitoring exists, but no cliff enumeration, no limit provenance, no lead-time forecasting |
| **L3: Ledgered** | Cliffs are in a ledger | Cliff ledger (§2) maintained; current/limit ratios and lead time monitored. Capacity factors empirically calibrated (§3) |
| **L4: Disciplined** | Planning is disciplined | Headroom policy (§4) in writing; four-scenario load testing (§5) and regression load tests in steady operation. Pre-event testing is a mandatory procedure |
| **L5: Forecasted** | Operated by forecast | Demand forecasts (§7) and cliff-arrival forecasts updated regularly with error feedback. Cliff-scenario tests (§9) and degradation fire drills automated |

-   **Rule 650.12.1 (Minimum Bar)**: All systems receiving production traffic require **L3 or above** (MUST). Major demand events such as flash sales are run only after **L4-equivalent procedures** are in place (MUST).

---

## Appendix A: Reverse-Lookup Index (Keyword → Section)

| Keyword | Section |
|:----------|:----------|
| Applicability / what is in scope | §1.1 |
| Responsibility boundary / boundary with 400 / proactive vs reactive | §1.2 |
| Scale cliff definition / cliff category list | §2.1 |
| Default values / implicit cliffs | §2.2 (Rule 650.2.2) |
| Cliff ledger / standard fields / limit_source | §2.2, §10.1 |
| Current/limit ratio / arrival forecast / lead-time alert | §2.3, §10.2 |
| Cloud quotas / Service Quotas / increase requests | §2.4 |
| Ledger freshness / periodic verification / design-review linkage | §2.5 |
| Folklore numbers prohibited / capacity factor / X instances = Y QPS | §3.1 |
| Breaking point / first resource to saturate | §3.2 |
| Periodic recalibration / automated calibration | §3.3 |
| Headroom / 30–40% / margin in writing | §4.1 |
| N+1 / N+2 / redundancy / failover target capacity | §4.2 |
| Production-equivalent configuration / data distribution / hot keys | §5.1 |
| Load test scenarios / average / peak / spike / soak | §5.2 |
| Regression load test / release blocking / cumulative degradation | §5.3 |
| Flash sale / campaign / pre-event testing | §5.4 |
| Autoscaling upper bound / cost-explosion prevention | §6.1 |
| Behavior at the bound / load shedding | §6.2, §8 |
| Warm-up time / scaling speed / scheduled scaling | §6.3 |
| Demand forecasting / organic / non-organic / forecast error | §7 |
| Graceful degradation / priority shedding / activation criteria | §8 |
| Cliff scenario tests / connection exhaustion / quota arrival / cold start | §9 |
| Cliff ledger YAML / quota monitoring config / dashboard indicators | §10 |
| Anti-patterns | §11 |
| Maturity model / L1–L5 / minimum bar | §12 |

---

**References (standards & prior art)**: RFC 2119 / Google SRE Book Ch. 18 "Software Engineering in SRE" (capacity planning, the warning against folklore numbers, the demand dichotomy) / Google SRE Book "The Production Environment at Google" (N+2) / Google SRE Workbook "Managing Load" / USENIX SREcon capacity-management talks / AWS Well-Architected Framework Reliability Pillar REL01 (managing Service Quotas) / AWS Service Quotas & GCP quota metrics / publicly documented cache stampede (thundering herd) incident literature

**Cross-Reference:**
-   `operations/400_site_reliability.md` — Part XXVII §65–§66 saturation monitoring & autoscaling design (canonical for the reactive side), Part XVIII §46 load-test environment constraints & tooling, Part X alert delivery, Part XIX resilience patterns, Part XXI graceful-degradation implementation
-   `operations/600_cloud_finops.md` — cost side of autoscaling bounds; sharing demand forecasts with cost forecasting (FinOps canonical)
-   `operations/500_incident_response.md` — response and rollback once a cliff arrival becomes an incident
-   `engineering/700_batch_backfill_operations.md` — §3.3 backpressure, §5.2 job-cost scale cliffs, §5.3 downstream protection (the discipline of the side that steps on cliffs)
-   `engineering/730_caching_discipline.md` — caching discipline (implementation side of cache total-loss cold start and cache stampede scenarios)
-   `design/000_design_ux.md` — user-experience design under graceful degradation (the UX-expression side of §8)
-   `quality/000_qa_testing.md` — canonical for test layer definitions (this file's §9 covers capacity-specific obligations only)

---

**Last Updated**: 2026-06-12
**Authority**: Universal Constitution (axiarch core)
**Classification**: Operations — Capacity Planning & Scale Cliffs
