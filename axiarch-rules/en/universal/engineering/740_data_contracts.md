# 740. Data Contracts & Schema Evolution

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-06-12

> [!IMPORTANT]
> **Level 1 Priority: Absolute Compliance**
> Data that flows across organizational and service boundaries has a blast radius outside the producer's field of view. A "small change" to a schema silently breaks another team's pipeline, another organization's report, or a batch job weeks later.
> The MUST requirements in this file exist to reduce risk and raise the quality floor; they take priority over implementation convenience and development velocity.

> [!CAUTION]
> **Primary Directive**
> "Data supplied across a boundary is an API. Supply without a contract is nothing but a verbal promise that nobody knows when it will break."
> This file is the language- and stack-agnostic cross-cutting discipline that canonicalizes the **producer / consumer contract for data crossing organizational / service boundaries (events, tables, topics, files)**.
> Request/response-style synchronous API interfaces are canonicalized by `engineering/100` (contract-first, versioning, Sunset) and are out of scope for this file (see the responsibility boundary table in §1.2).

---

## Table of Contents

- §1. Primary Directive & Scope
  - §1.1. Applicability
  - §1.2. Responsibility Boundary Table (Adjacent Files)
  - §1.3. Core Principles & RFC 2119 Terms
- §2. Contract Components (Core of This File)
  - §2.1. Mandatory Components
  - §2.2. Contracts as Code, Managed in Git
  - §2.3. Reference Standard — ODCS (Emerging Standard)
  - §2.4. Prohibition of Ownerless Contracts
- §3. Compatibility Modes
  - §3.1. Explicit Compatibility Mode Selection
  - §3.2. Default Is BACKWARD
  - §3.3. When to Apply Transitive Modes
  - §3.4. Schema Registry (Single Point of Reference) Required
  - §3.5. Blocking Production with Unregistered Schemas
- §4. Breaking Changes: Definition & Procedure
  - §4.1. Enumeration of Breaking Changes
  - §4.2. Three-Stage Migration Procedure (Parallel Delivery → Migration Confirmation → Old-Version Retirement)
  - §4.3. Deprecation Discipline (Sunset-Aligned)
  - §4.4. Consumer Ledger
- §5. Consumer-Side Discipline
  - §5.1. Tolerant Reader
  - §5.2. Contract Tests
  - §5.3. Behavior on Schema Validation Failure (DLQ)
  - §5.4. Prohibition of Off-Contract Dependencies
- §6. SLA & Data Quality
- §7. PII & Classification Tags
- §8. Testing Obligations
- §9. Implementation Snippets (Reference Implementations)
- §10. Anti-Pattern Catalog
- §11. Maturity Model L1–L5
- Appendix A: Reverse-Lookup Index
- Cross-Reference

---

## §1. Primary Directive & Scope

### §1.1. Applicability

-   **Rule 740.1.1 (Applicability)**: This file applies to **every data asset supplied across organizational, team, or service boundaries** (MUST). This includes, but is not limited to:
    -   Event streams (message queue / event bus topics)
    -   Shared tables / views (DB tables and DWH tables read by other teams)
    -   Export / ingest files (recurring hand-offs of CSV, JSON Lines, Parquet, etc.)
    -   Supply into analytics platforms (datasets flowing into DWH / Lakehouse / reporting infrastructure)
-   **Litmus test**: "If the shape, meaning, or freshness of this data changes, does someone outside my team break?" — If yes, this file applies. Intermediate data confined within a team is out of scope (MAY), but the contract obligation arises the moment it crosses a boundary.

### §1.2. Responsibility Boundary Table (Adjacent Files)

-   **Rule 740.1.2 (Responsibility Boundary)**: This file canonicalizes only "the producer / consumer contract and schema-evolution discipline for boundary-crossing data" and delegates the following to their respective canonical files (MUST):

| Topic | Canonical File (Delegated To) | Relationship to This File |
|:--------|:-------------|:-----------------|
| Contract-first, versioning, and Sunset for synchronous APIs | `engineering/100_api_integration.md` Part VI | Request/response synchronous interfaces are canonicalized by 100. This file covers data assets (asynchronous / accumulated) only |
| Analytics event naming conventions and event registry | `ai/100_data_analytics.md` §2.3 | Registration and CI blocking of analytics events is implemented per ai/100. Contract components and evolution discipline are canonicalized here |
| Applying Data Contracts to pipeline observability | `ai/100_data_analytics.md` Part LIV | ai/100 Part LIV applies contracts in the analytics-pipeline context. The cross-cutting canonical source for the contract itself is this file |
| Contract testing tools and execution layer (Pact, etc.) | `quality/000_qa_testing.md` §7 | Consumer contract-test obligations are defined in §5.2; tool selection and Broker operations are delegated |
| Counting, DLQ, and failure-accounting for validation-failed data | `engineering/700_batch_backfill_operations.md` §2 | Failure counting and quarantine discipline is canonicalized by 700. This file only defines that contract violations ride on that discipline |
| Freshness / completeness cross-checking (reconciliation) | `engineering/710_data_reconciliation.md` | Numeric SLA definitions live in §6 of this file; measurement and cross-checking methods are delegated |
| DDL safety standards for DB schema changes (Expand-Contract) | `engineering/000_engineering_standards.md` Part XVII | The DB-internal DDL/DML layer is delegated. This file governs the evolution of logical schemas crossing boundaries |
| General data classification and PII governance | `security/100_data_governance.md` | The classification taxonomy and governance are canonicalized by security/100; only mandatory classification tags in contracts are defined in §7 |
| SLO and alert design | `operations/400_site_reliability.md` | SLA-violation notification and alerting infrastructure is delegated |

### §1.3. Core Principles & RFC 2119 Terms

-   **Rule 740.1.3 (RFC 2119)**: **MUST / MUST NOT / SHOULD / MAY** in this file follow the RFC 2119 definitions. MUST denotes a mandatory requirement for risk reduction; deviation requires an explicit ADR record.
-   **Rule 740.1.4 (No Exaggeration)**: This file does not promise that "schemas never break." The goal is to **make breakage predictable and systematically lower the cost and risk of migration**. Phrases like "full backward-compatibility guarantee" or "zero breaking changes" are prohibited even in design documents (MUST NOT).
-   **Rule 740.1.5 (No Supply Without a Contract)**: A data asset that lacks a contract satisfying the components in §2 must not be newly supplied across organizational / service boundaries (MUST NOT). Existing contract-less supplies are contractualized in a planned manner based on the maturity assessment in §11 (SHOULD).

---

## §2. Contract Components

> This section is the core of this file. A contract is not a "schema file" — it is a bundle of **schema + responsibility + quality guarantees + usage context**.

### §2.1. Mandatory Components

-   **Rule 740.2.1 (Mandatory Components)**: Every data contract must contain at minimum the following components (MUST):

| Component | Content |
|:--------|:-----|
| **Schema** | Field names, types, requiredness, enum value ranges, and **semantics** (units, time zone, ID scheme, meaning of null) |
| **Owner (Producer)** | Responsible team name + reachable contact point (§2.4). An individual's name alone is not acceptable |
| **SLA** | **Numeric** targets for freshness and completeness (§6) |
| **Quality Rules** | Verifiable rules such as uniqueness, null rate, value ranges, referential integrity |
| **Purpose & Classification** | Intended use of the data, per-field data classification tags (PII / confidential / public, §7) |
| **Compatibility Mode** | Explicit selection of BACKWARD / FORWARD / FULL (+ transitive) (§3.1) |
| **Version** | The version of the contract itself and its change history |

-   **Litmus test**: "Can a team consuming this data for the first time implement a safe consumer without asking the producer a single question?" — If not, the contract is incomplete.

### §2.2. Contracts as Code, Managed in Git

-   **Rule 740.2.2 (Contracts as Code)**: Contracts are written in a machine-readable format (YAML / JSON / IDL), **managed in Git, changed via review, and verified in CI** (MUST). Managing contracts via wiki, spreadsheet, or verbal agreement is prohibited (MUST NOT).
-   **Rule 740.2.3 (CI Verification Content)**: The contract repository's CI automatically runs, at minimum: (1) validity verification of the contract format itself, (2) compatibility checks (§3), and (3) confirmation that the mandatory components (§2.1) are satisfied (MUST).
-   **Prior art**: GoCardless data contracts — contracts as Git-managed declarative definitions, with CI verification driving the generation of schemas and infrastructure resources from the contract. A flagship example of the contract becoming "executed code" rather than "documentation."

### §2.3. Reference Standard — ODCS (Emerging Standard)

-   **Rule 740.2.4 (Reference Standard)**: It is recommended to use **ODCS (Open Data Contract Standard)** as the reference standard when designing contract formats (SHOULD). ODCS is an **emerging, in-progress standard** developed by the **Bitol** project under Linux Foundation AI & Data, with v3.1.0 released in December 2025. It originated from the Data Contract Template published by PayPal.
-   **Accurate positioning**: ODCS is an evolving standard, not an established universal one. Full adoption is not mandated (MAY). A homegrown format also complies with this file as long as it satisfies the components in §2.1. However, when designing a new contract format, aligning with ODCS vocabulary (schema / quality / slaProperties / team, etc.) lowers future tool-integration costs.
-   **Simplified example**: See §9.1.

### §2.4. Prohibition of Ownerless Contracts

-   **Rule 740.2.5 (Owner Required)**: The contract owner is defined at the **team level**, accompanied by a reachable contact point (team channel, mailing list, on-call) (MUST). Owner entries consisting only of an individual's name — unreachable after resignation or transfer — are prohibited (MUST NOT).
-   **Rule 740.2.6 (Prohibition of Ownerless Data)**: New dependencies on data assets with unknown owners must not be added (MUST NOT). When discovered, file a ticket to determine the owner (or plan retirement) (SHOULD).

---

## §3. Compatibility Modes

### §3.1. Explicit Compatibility Mode Selection

-   **Rule 740.3.1 (Explicit Selection)**: Every data asset **explicitly selects a compatibility mode from the following and records it in the contract** (MUST). "Unset (implicit behavior)" is prohibited (MUST NOT):

| Mode | Meaning | Side Updated First | Main Permitted Changes |
|:------|:-----|:-------------|:------------------|
| **BACKWARD** | Consumers using the new schema can read data written with the old schema | Consumers | Delete fields, add optional fields |
| **FORWARD** | Consumers using the old schema can read data written with the new schema | Producers | Add fields, delete optional fields |
| **FULL** | Both BACKWARD and FORWARD | Either | Add or delete optional fields only |
| **\*_TRANSITIVE** | Requires compatibility with **all past versions**, not just the immediately previous one | Same as above | Stricter than the above |

-   **Prior art**: Confluent Schema Registry compatibility modes. The table above is aligned with that registry's definitions; the same form of evaluation applies for Avro, Protobuf, and JSON Schema alike.

### §3.2. Default Is BACKWARD

-   **Rule 740.3.2 (Default BACKWARD)**: Unless there is an explicit reason otherwise, the default is **BACKWARD** (SHOULD). BACKWARD enables the operating model in which "if consumers are updated first, the producer's schema evolution does not break consumers," and it is also the default value of Confluent Schema Registry.
-   **Rule 740.3.3 (No Blind Selection of FULL)**: FULL / FULL_TRANSITIVE looks safest but permits the narrowest set of changes and carries the side effect of **effectively halting schema evolution**. It must not be selected blindly without evaluating the trade-off (MUST NOT). When selected, the rationale is recorded in the contract (MUST).

### §3.3. When to Apply Transitive Modes

-   **Rule 740.3.4 (Applying Transitive)**: Assets for which **reprocessing or replay** of historical data is anticipated (long-retention topics, event sourcing, backfill targets) select `*_TRANSITIVE` (SHOULD). Compatibility with only the immediately previous version breaks down when old data is read by new code.

### §3.4. Schema Registry (Single Point of Reference) Required

-   **Rule 740.3.5 (Single Point of Reference)**: Every boundary-crossing schema is registered in a **schema registry or an equivalent single point of reference** (MUST). An "equivalent single point of reference" means a place where all producers and all consumers can reference the same schema definition and compatibility checks can be machine-executed (besides dedicated registry products, a contract repository + CI can also satisfy this requirement).
-   **Litmus test**: "Which is the correct schema for this topic / table right now?" — Can you answer instantly from a single place, without reading code?

### §3.5. Blocking Production with Unregistered Schemas

-   **Rule 740.3.6 (Blocking Unregistered Production)**: Data production with a schema that is unregistered in the registry (or has not passed compatibility checks) is **blocked in CI (pre-deploy) or at runtime (at serialization time)** (MUST). Allowing "we'll register it later" turns the registry into a decoration detached from reality.
-   **Implementation guidance**: Where the platform supports runtime blocking (registry-integrated serializers, etc.), prefer runtime; for paths where runtime validation is impractical (e.g., file hand-offs), substitute CI + receiver-side validation (§5.3) (SHOULD).

---

## §4. Breaking Changes: Definition & Procedure

### §4.1. Enumeration of Breaking Changes

-   **Rule 740.4.1 (Definition of Breaking Changes)**: The following changes are **treated as breaking changes** regardless of the compatibility-mode evaluation result (MUST):
    -   Deleting a field
    -   Changing a field's type (including widening — any change that may cause consumer validation to fail)
    -   Changing optional → required (mandatorization)
    -   Deleting or narrowing enum value ranges
    -   Renaming a field (equivalent to delete + add)
    -   **Semantics changes**: changes where type and name are unchanged but the unit (JPY → USD), time zone, ID scheme, or meaning of null changes. **Schema checkers cannot detect semantics changes**, so they are explicitly evaluated via human review (MUST)
    -   Changes to keys, partitioning, or uniqueness guarantees
-   **Rule 740.4.2 (Additive Changes)**: Adding optional fields and widening enum value ranges are non-breaking in principle, but enum widening presupposes consumer-side unknown-value handling (§5.1). For assets whose contracts do not document the consumer discipline, treat enum widening as a breaking change as well (SHOULD).

### §4.2. Three-Stage Migration Procedure (Parallel Delivery → Migration Confirmation → Old-Version Retirement)

-   **Rule 740.4.3 (Three-Stage Procedure)**: Breaking changes are executed in the following three stages; skipping or reordering stages is prohibited (MUST):
    1.  **Parallel delivery of the new version**: deliver the new schema **as a separate version (separate topic / separate table / version field) in parallel with the old version**. Record the migration deadline in the contract
    2.  **Consumer migration confirmation**: confirm via the consumer ledger (§4.4) and access logs that **all consumers have migrated to the new version**
    3.  **Old-version retirement**: only after confirming zero consumers, stop delivery of and delete the old version
-   **Rule 740.4.4 (No Deletion Until Zero Consumers Confirmed)**: The old version must not be deleted or stopped until it is confirmed that it has zero consumers (MUST NOT). "We sent an announcement, so we may delete" is not permitted. An announcement is a prerequisite of the procedure, not a substitute for it.

### §4.3. Deprecation Discipline (Sunset-Aligned)

-   **Rule 740.4.5 (Deadline-Bound Deprecation)**: Deprecation of the old version is announced **with an explicit retirement date** (MUST). Deadline-less deprecation ("please migrate someday") is prohibited (MUST NOT).
-   **Alignment**: The Deprecation / Sunset header discipline for synchronous APIs is canonicalized by `engineering/100` §6.3. For data assets, the same idea is expressed as contract fields (deprecation date + retirement date).

### §4.4. Consumer Ledger

-   **Rule 740.4.6 (Knowing Your Consumers)**: For each contracted data asset, maintain a **means of knowing who consumes it** (a consumer registration scheme or detection via access logs) (MUST). Breaking changes must not be applied to an asset whose consumers cannot be identified (MUST NOT).
-   **Litmus test**: "If we stopped this asset, how many systems would break?" — Can you answer with a number?

---

## §5. Consumer-Side Discipline

> Contracts are not the producer's obligation alone. Half of a breakage-resistant data ecosystem is determined by the discipline of how consumers read.

### §5.1. Tolerant Reader

-   **Rule 740.5.1 (Ignore Unknown Fields)**: Consumers are implemented as Tolerant Readers that **ignore unknown fields** and extract only the fields they need (MUST). Strict parsing that raises an error on the presence of an unknown field turns the producer's non-breaking evolution (field addition) into a breaking one.
-   **Rule 740.5.2 (Safe Handling of Unknown Enum Values)**: Code consuming enums implements an **explicit fallback for unknown values** (treat as `unknown`, or skip + count) (MUST). Crashing on an unknown enum value makes enum widening (§4.2) impossible.
-   **Prior art**: The Tolerant Reader pattern (Martin Fowler).

### §5.2. Contract Tests

-   **Rule 740.5.3 (Declaring Depended-On Fields)**: Consumers **declare the fields, types, and value ranges they depend on as contract tests** (SHOULD). This lets the producer learn mechanically in CI "what change breaks whom."
-   **Delegation**: Contract-testing tools (Pact, etc.), Broker operations, and execution-layer definitions are canonicalized by `quality/000` §7. This clause only establishes that "consumers of data assets are also subject to contract testing."

### §5.3. Behavior on Schema Validation Failure (DLQ)

-   **Rule 740.5.4 (Count Violating Data + DLQ)**: Items that fail contract validation (schema or quality rules) on received data are **not silently dropped — they are counted and quarantined to a DLQ together with the original payload** (MUST). The counting, quarantine, and monitoring discipline is identical to `engineering/700` §2.4 (per-item failure capture and DLQ); contract violations are counted under the failure taxonomy as the `user.non_retryable` family (SHOULD).
-   **Rule 740.5.5 (Feeding Violations Back to the Producer)**: Detection of contract violations does not terminate on the consumer side; maintain a mechanism that **notifies and feeds back to the producer** (SHOULD). With consumer-side defense alone, violating data keeps being supplied.

### §5.4. Prohibition of Off-Contract Dependencies

-   **Rule 740.5.6 (Prohibition of Off-Contract Dependencies)**: Direct dependencies on fields not stated in the contract or on internal implementation tables (e.g., direct SELECT against another team's DB) are prohibited (MUST NOT). Off-contract dependencies are invisible to the producer and therefore receive none of the protections of the §4 procedure.
-   **Implementation guidance**: Producers separate internal tables from the published interface (the contracted external schema) and block direct access to internals via permissions (SHOULD).

---

## §6. SLA & Data Quality

-   **Rule 740.6.1 (Numeric SLA Required)**: The contract's SLA defines, at minimum, **freshness** (e.g., available within 15 minutes of event occurrence) and **completeness** (e.g., at least 99.9% of target records arrive) **numerically** (MUST). Non-numeric SLAs such as "best effort" or "as soon as possible" are prohibited (MUST NOT).
-   **Rule 740.6.2 (Measurement Obligation)**: An SLA functions as a contract only when measured. Freshness and completeness are **continuously measured as metrics**, and divergence from the contracted values is made visible (MUST). Methods for cross-checking old/new and upstream/downstream (reconciliation) are canonicalized by `engineering/710`; metrics infrastructure and quality scores in general by `ai/100`.
-   **Rule 740.6.3 (SLA-Violation Notification)**: SLA violations are **detected by the producer itself and notified to consumers** (MUST). A state where consumers notice "the data isn't arriving" first means the contract's responsibility placement is inverted. Alert design is delegated to `operations/400`.
-   **Rule 740.6.4 (Executing Quality Rules)**: The quality rules stated in the contract (uniqueness, null rate, value ranges) are implemented as **validations executed on the pipeline**, not as documents (MUST). A rule that is not executed is a rule that does not exist.

---

## §7. PII & Classification Tags

-   **Rule 740.7.1 (Classification Tags Required)**: Contracts mandatorily include **per-field data classification tags** (e.g., PII / confidential / internal / public) (MUST). A data asset containing untagged fields must not be supplied across boundaries (MUST NOT). The classification taxonomy is canonicalized by `security/100`.
-   **Rule 740.7.2 (Propagating Masking Obligations)**: Downstream consumers and re-suppliers **inherit the masking, access-control, and retention obligations based on the contract's classification tags** (MUST). Classification tags are "attached at the first point of supply and propagated downstream," so that governance follows the data no matter how many hops it is transferred.
-   **Rule 740.7.3 (Classification Changes Are Breaking Changes)**: Changing a field's classification (especially non-PII → PII) alters the consumers' handling obligations and is therefore **treated as a breaking change under the §4 procedure** (MUST).
-   **Rule 740.7.4 (No Retroactive Tagging)**: The practice of "start supplying first, attach classification tags later" is prohibited (MUST NOT). Data replicated during the untagged period becomes ungovernable.

---

## §8. Testing Obligations

> Test-layer definitions and contract-testing tools in general are canonicalized by `quality/000`. This section defines **only the testing obligations specific to data contracts**.

-   **Rule 740.8.1 (Compatibility CI Tests)**: Every PR that changes a schema or contract **automatically runs a compatibility check against the registry (§3.4)** and blocks violations of the selected compatibility mode (§3.1) (MUST). Compatibility evaluation must not rely on human review alone (MUST NOT).
-   **Rule 740.8.2 (Contract-Violation Detection Tests)**: Deliberately inject contract-violating data (type mismatch, missing required fields, out-of-range values) and verify the following (MUST):
    -   The violation is detected and correctly counted
    -   The violating item is quarantined to the DLQ (§5.3)
    -   Processing of valid items is not dragged down by violating items
-   **Rule 740.8.3 (Consumer Tolerant Reader Tests)**: Consumers maintain tests verifying correct behavior on **input containing unknown fields** and **input containing unknown enum values** (MUST).
-   **Rule 740.8.4 (Quality-Rule Execution Tests)**: Verify by test that the contract's quality rules (§6.4) are actually executed on the pipeline and that violations are detected (SHOULD).

---

## §9. Implementation Snippets

> Everything below is a **reference implementation** (e.g., YAML / TypeScript) and does not mandate any specific product or language. Translate into the idioms of your own stack.

### §9.1. Contract YAML Example (ODCS-Style, Simplified)

```yaml
# data-contract.yaml — simplified example aligned with ODCS (v3.1.0) vocabulary
# Note: ODCS is an emerging, in-progress standard; the requirement is satisfying the §2.1 components, not full conformance
apiVersion: v3.1.0
kind: DataContract
id: commerce-order-completed
name: commerce.order_completed
version: 2.3.0            # version of the contract itself
status: active
domain: commerce
team:
  - role: owner
    name: commerce-platform-team        # team-level (Rule 740.2.5)
    channel: "#commerce-platform"       # reachable contact point
description:
  purpose: Order-completed event. Used for accounting aggregation, inventory sync, and supply to analytics
compatibility: BACKWARD_TRANSITIVE      # §3.1 explicit selection (transitive because replay exists)
schema:
  - name: order_completed
    properties:
      - name: order_id
        logicalType: string
        required: true
        primaryKey: true
        classification: internal        # §7 classification tag (per field)
      - name: customer_email
        logicalType: string
        required: true
        classification: pii             # masking obligation propagates downstream
      - name: amount
        logicalType: integer
        required: true
        classification: internal
        description: "Amount. Unit is JPY (semantics stated in the contract)"
      - name: status
        logicalType: string
        required: true
        classification: public
        # enum may widen. Consumers must implement unknown-value fallback (Rule 740.5.2)
        allowedValues: [completed, refunded, partially_refunded]
quality:
  - rule: uniqueness
    property: order_id
  - rule: nullRate
    property: customer_email
    mustBeLessThan: 0.001
slaProperties:
  - property: freshness          # §6 numeric SLA
    value: 15
    unit: minutes
  - property: completeness
    value: 99.9
    unit: percent
deprecation: null                # on deprecation, date + sunsetDate become mandatory (§4.3)
```

### §9.2. Compatibility Check CI Pseudo-Configuration (§8.1)

```yaml
# .ci/contract-check.yaml — pseudo-configuration run on contract-repo / schema-change PRs
on: pull_request

jobs:
  contract-validation:
    steps:
      - name: Validate contract format          # Rule 740.2.3 (1)
        run: contract-cli validate ./contracts/**/*.yaml
      - name: Check mandatory components        # Rule 740.2.3 (3) — owner / SLA / classification tags
        run: contract-cli lint --require owner,sla,classification
      - name: Compatibility check               # Rule 740.8.1 — compare against current registry version
        run: |
          schema-registry-cli test-compatibility \
            --subject commerce.order_completed \
            --mode-from-contract \
            --schema ./contracts/commerce/order_completed.yaml
        # On violation of the selected mode (e.g., BACKWARD_TRANSITIVE), exit non-zero to block the PR
      - name: Require semantics review for breaking changes
        # Type checkers cannot detect semantics changes (Rule 740.4.1)
        # If description / unit / classification diffs exist, mandate human review
        run: contract-cli diff --require-human-review-on semantics,classification
```

### §9.3. Tolerant Reader Example (e.g., TypeScript)

```typescript
// §5.1 Tolerant Reader reference implementation — validate and extract only the needed fields
type OrderStatus = 'completed' | 'refunded' | 'partially_refunded';

interface OrderCompletedV2 {
  orderId: string;
  amountJpy: number;
  status: OrderStatus | 'unknown'; // unknown enum values are normalized to 'unknown' (Rule 740.5.2)
}

function readOrderCompleted(raw: unknown): OrderCompletedV2 {
  const r = raw as Record<string, unknown>;
  // Validate only the fields we depend on. Unknown fields are not inspected — they are ignored (Rule 740.5.1)
  if (typeof r.order_id !== 'string' || typeof r.amount !== 'number') {
    // Contract violation: do not drop silently — count and quarantine to DLQ (Rule 740.5.4 / 700 §2.4)
    throw new ContractViolationError('order_completed', r.order_id);
  }
  const known: ReadonlyArray<OrderStatus> = ['completed', 'refunded', 'partially_refunded'];
  const status = known.includes(r.status as OrderStatus)
    ? (r.status as OrderStatus)
    : 'unknown'; // survives enum widening. The count of 'unknown' is counted and made visible
  return { orderId: r.order_id, amountJpy: r.amount, status };
}
```

---

## §10. Anti-Pattern Catalog

| # | Anti-Pattern | Violated Rules | Consequence |
|:--|:-------------|:----------|:-----|
| 1 | Producing schemas without a registry / single point of reference | 740.3.5–6 | No "correct schema" exists; subtly different data flows from each producer |
| 2 | Blindly selecting FULL / FULL_TRANSITIVE, halting evolution | 740.3.3 | Nearly every change becomes a compatibility violation, and off-contract side channels proliferate to work around it |
| 3 | Forcing through breaking changes with "an announcement only" | 740.4.3–4 | Consumers who missed the notice break in production. Announcement is no substitute for the procedure |
| 4 | Deleting fields / old versions without knowing the consumer count | 740.4.6 | Unknown dependent systems cascade-fail the moment of deletion |
| 5 | Supplying data with untagged PII | 740.7.1–2 | Downstream replicates and forwards without knowing the masking obligation, becoming ungovernable |
| 6 | Managing contracts via wiki / spreadsheet / verbal agreement | 740.2.2 | Contract and reality diverge, and nobody can determine which is canonical |
| 7 | Data assets owned by an individual's name only — or nobody | 740.2.5–6 | Transfers and resignations create "data nobody can be asked about" |
| 8 | Writing the SLA as "best effort" | 740.6.1 | Freshness lag and data loss can never be judged a violation, so improvement never starts |
| 9 | Consumers directly SELECTing another team's internal tables | 740.5.6 | The producer's refactoring breaks unknown other teams |
| 10 | Consumers raising errors on the presence of unknown fields | 740.5.1 | The producer's non-breaking field addition mutates into a breaking change |
| 11 | Silently dropping contract-violating data (no counting) | 740.5.4 | Data loss progresses quietly and surfaces weeks later as aggregate discrepancies |
| 12 | Treating semantics changes (unit / TZ) as non-breaking because the type is unchanged | 740.4.1 | They sail through schema checks, and broken numbers keep flowing downstream |
| 13 | Deadline-less deprecation ("please migrate someday") | 740.4.5 | The old version persists forever and dual maintenance becomes permanent |
| 14 | Relying on human review alone for compatibility checks | 740.8.1 | One reviewer oversight breaks compatibility. Do not entrust mechanizable evaluation to humans |
| 15 | Retroactively attaching classification tags after supply has started | 740.7.4 | Data replicated during the untagged period stays outside governance forever |

---

## §11. Maturity Model L1–L5

| Level | State | Characteristics |
|:------|:-----|:-----|
| **L1: Implicit** | No contracts exist | Schemas exist only inside code. Other teams consume via direct DB reads and reverse engineering. Breakage is discovered after the fact |
| **L2: Documented** | Documents exist but nothing is enforced | A schema table lives on a wiki. It diverges from reality; no compatibility checks or SLA measurement |
| **L3: Contracted** | Contracts are codified | Contracts are Git-managed and satisfy the mandatory components (§2.1). Registry + CI compatibility checks are functioning |
| **L4: Enforced** | Contracts are enforced at runtime | Blocking of unregistered-schema production, DLQ for violating data, continuous SLA measurement + violation notification are functioning. Three-stage procedure is the default for breaking changes |
| **L5: Federated** | Self-sustaining as an organizational standard | Unified on a standard format (ODCS, etc.). Consumer ledger and impact analysis are automated; the blast radius of a contract change is self-serviceable |

-   **Rule 740.11.1 (Minimum Bar)**: Every data asset supplied across organizational / service boundaries requires **L3 or above** (MUST). Supplying assets containing PII requires satisfying **L4-equivalent enforcement mechanisms** first (MUST).

---

## Appendix A: Reverse-Lookup Index (Keyword → Section)

| Keyword | Section |
|:----------|:----------|
| Applicability / events / shared tables / export files | §1.1 |
| Responsibility boundary / boundary with engineering/100 / boundary with ai/100 | §1.2 |
| Contract components / owner / SLA / quality rules | §2.1 |
| Contracts as code / Git management / CI verification | §2.2 |
| ODCS / Bitol / reference standard / PayPal | §2.3 |
| Owner required / ownerless data | §2.4 |
| Compatibility modes / BACKWARD / FORWARD / FULL / transitive | §3.1–§3.3 |
| Schema registry / single point of reference | §3.4 |
| Unregistered schemas / production blocking | §3.5 |
| Definition of breaking changes / type change / mandatorization / enum narrowing / semantics change | §4.1 |
| Three-stage procedure / parallel delivery / migration confirmation / old-version retirement / zero consumers | §4.2 |
| Deprecation / Sunset / retirement deadline | §4.3 |
| Consumer ledger / who consumes | §4.4 |
| Tolerant Reader / unknown fields / unknown enum values | §5.1 |
| Contract tests / Pact / declaring depended-on fields | §5.2 |
| Validation failure / DLQ / counting violating data | §5.3 |
| Off-contract dependencies / no direct DB reads | §5.4 |
| Numeric SLA / freshness / completeness / measurement / reconciliation | §6 |
| PII / classification tags / propagation of masking obligations | §7 |
| Compatibility CI tests / violation detection tests / Tolerant Reader tests | §8 |
| Contract YAML example / CI pseudo-configuration / Tolerant Reader implementation | §9 |
| Anti-patterns | §10 |
| Maturity model / L1–L5 / minimum bar | §11 |

---

**References (standards & prior art)**: RFC 2119 / ODCS — Open Data Contract Standard v3.1.0 (December 2025, Linux Foundation AI & Data / Bitol, emerging standard) / PayPal Data Contract Template (origin of ODCS) / GoCardless data contracts (contracts as code + CI-driven) / Confluent Schema Registry compatibility modes / Tolerant Reader pattern (Martin Fowler) / Pact / RFC 8594 Sunset Header

**Cross-Reference:**
-   `engineering/100_api_integration.md` — Part VI versioning, §6.3 Deprecation / Sunset (canonical for contract-first synchronous APIs; this file covers the data-asset side)
-   `ai/100_data_analytics.md` — §2.3 analytics event registry, Part LIV applying Data Contracts to pipeline observability (the cross-cutting canonical for the contract is this file)
-   `engineering/700_batch_backfill_operations.md` — §2.4 per-item failure capture and DLQ (counting and quarantine of contract-violating data rides on this discipline)
-   `engineering/710_data_reconciliation.md` — canonical for measuring and cross-checking (reconciliation) freshness / completeness SLAs
-   `quality/000_qa_testing.md` — §7 contract testing (canonical for tools such as Pact and Broker operations)
-   `security/100_data_governance.md` — canonical for the data classification taxonomy and PII governance (§7 of this file covers only mandatory inclusion in contracts)
-   `engineering/000_engineering_standards.md` — Part XVII Expand-Contract, DDL/DML safety standards (the DB-internal schema-change layer)
-   `operations/400_site_reliability.md` — alerting and notification infrastructure for SLA violations
-   `core/000_core_mindset.md` — prohibition of unverified completion reports, fact-based reporting fundamentals

---

**Last Updated**: 2026-06-12
**Authority**: Universal Constitution (axiarch core)
**Classification**: Engineering — Data Contracts & Schema Evolution
