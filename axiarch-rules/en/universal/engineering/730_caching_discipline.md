# 730. Caching Discipline

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-06-12

> [!IMPORTANT]
> **Level 1 Priority: Absolute Compliance**
> A cache is "the distributed system that is easiest to introduce and least likely to be verified." A single line of `cache.set()` implicitly adds a consistency model, a failure mode, and a capacity characteristic to the system.
> The MUST requirements in this file exist to reduce risk and raise the quality floor; they take priority over implementation convenience and development velocity.

> [!CAUTION]
> **Primary Directive**
> "A cache without a staleness contract is not a performance optimization — it is an undeclared degradation of consistency."
> This file is the language- and stack-agnostic universal discipline applied to **every cache layer**: in-process, distributed, HTTP/CDN, DB buffers, and application-layer caches.
> What this file canonicalizes is the **"universal discipline of staleness contracts, TTL design, invalidation, and total-loss tolerance"**; web-framework-specific cache mechanisms (ISR / SWR libraries / CDN configuration) are delegated to `engineering/300`, CMS caching to `engineering/310`, SRE tier operations to `operations/400` Part XXIII, and stack-specific implementations to `engineering/200` etc. (see the responsibility boundary table in §1.2).

---

## Table of Contents

- §1. Primary Directive & Scope
  - §1.1. Applicability
  - §1.2. Responsibility Boundary Table (Adjacent Files)
  - §1.3. Core Principles & RFC 2119 Terms
- §2. Staleness Contract (Core of This File)
  - §2.1. Explicit Permitted Staleness per Data Class
  - §2.2. Prohibition of Implicit Consistency Degradation
  - §2.3. Cache Consistency SLO
- §3. TTL Design
  - §3.1. Dual TTL (soft TTL / hard TTL)
  - §3.2. Explicit Design-Time Choice of fail-open / fail-closed
  - §3.3. TTL Jitter (Preventing Synchronized-Expiry Stampedes)
  - §3.4. Negative Caching (Separate TTL for Non-Existence)
- §4. Stampede Prevention
  - §4.1. Request Coalescing (single-flight)
  - §4.2. Probabilistic Early Recomputation
  - §4.3. Locked Rebuild
- §5. Invalidation Strategy
  - §5.1. Multi-Layer Invalidation Order (origin → distributed → edge)
  - §5.2. Event-Driven vs TTL — Selection Criteria
  - §5.3. Cache Key Design (Schema Version Mandatory)
  - §5.4. Versioned Keys vs Purge
- §6. stale-while-revalidate / stale-if-error (RFC 5861)
- §7. Total-Loss Tolerance (Cold Start)
- §8. Observability
- §9. Security / Privacy
- §10. Testing Obligations
- §11. Implementation Snippets (Reference Implementations)
- §12. Anti-Pattern Catalog
- §13. Maturity Model L1–L5
- Appendix A: Reverse-Lookup Index
- Cross-Reference

---

## §1. Primary Directive & Scope

### §1.1. Applicability

-   **Rule 730.1.1 (Applicability)**: This file applies to **every mechanism that holds a value derived from the source of truth (origin) in a place closer or faster than the origin** (MUST). Concretely this includes, but is not limited to:
    -   In-process caches (memoization, LRU maps, in-app object caches)
    -   Distributed caches (external cache stores such as Redis / Memcached)
    -   HTTP / CDN caches (browser, reverse proxy, edge)
    -   DB-side caches (materialized views, query result caches, design decisions that depend on buffer behavior)
    -   Application-layer caches (framework data caches, session-bound derived values)
-   **Litmus test**: "Could this value differ from what I would get by reading the origin right now?" — if YES, it is a cache and falls within the scope of this file, regardless of its name (memoization, snapshot, prefetch).

### §1.2. Responsibility Boundary Table (Adjacent Files)

-   **Rule 730.1.2 (Responsibility boundary)**: This file canonicalizes only "the language- and layer-agnostic universal caching discipline"; the following are delegated to their respective canonical files (MUST):

| Topic | Canonical (delegated to) | Relationship to this file |
|:--------|:-------------|:-----------------|
| Web-frontend-specific caching (ISR / `'use cache'` / revalidateTag / CDN headers / SWR libraries) | `engineering/300_web_frontend.md` Part XVII (§85–§86), §208 | This file holds the universal discipline; web-stack-specific mechanisms and targets are delegated |
| CMS content cache tiering & on-demand revalidation | `engineering/310_headless_cms.md` Part XVII | Content tier design and preview separation are delegated |
| Supabase / DB-layer cache operations (Cache Versioning, schema cache reload, Storage CDN) | `engineering/200_supabase_architecture.md` around §7.4–§7.5 | Stack-specific procedures are delegated |
| SRE cache tier table (STATIC / WARM / HOT / REALTIME) and its operation | `operations/400_site_reliability.md` Part XXIII §57 | Concrete tier values and operational judgment are delegated. This file defines the staleness contract (§2) that tier selection presupposes |
| Capacity planning & scale-cliff ledger (planning ahead) | `operations/650_capacity_planning.md` | Connection point for cache total-loss capacity requirements (§7). Post-hoc saturation monitoring is `operations/400` Part XXVII §65 |
| Cache poisoning, Service Worker cache attack surface, no-store for sensitive data | `security/000_security_privacy.md` §22.6, §7 | Threat models and countermeasures are delegated. This file defines only the design boundary (§9) |
| Schema evolution (Expand-Contract) and deployment compatibility | `engineering/000_engineering_standards.md` Part XVII | Canonical background for schema-versioned keys (§5.3) |
| General metrics & structured logging infrastructure | `ai/100_data_analytics.md` Part XI–XV | This file defines "what to measure" (§8); the collection infrastructure is delegated |

### §1.3. Core Principles & RFC 2119 Terms

-   **Rule 730.1.3 (RFC 2119)**: **MUST / MUST NOT / SHOULD / MAY** in this file follow RFC 2119 definitions. MUST denotes a mandatory risk-reduction requirement; deviation requires an explicit ADR record.
-   **Rule 730.1.4 (No exaggeration)**: This file does not promise "consistency and hit rate at the same time." Caching is inherently a **trade-off between freshness and load**; the goal is to make the degradation **explicit, bounded, and observable**. Phrases such as "always fresh" or "strongly consistent despite caching" are prohibited even in design documents (MUST NOT).
-   **Rule 730.1.5 (Caches hold derived data)**: A cache MUST hold only **derived data that is reconstructible from the origin**. State that exists only in the cache and not in the origin MUST NOT be created — turning the cache into the SSOT is the foremost anti-pattern in §12. See `engineering/000` for the location of the data source of truth.
-   **Rule 730.1.6 (Recognize bimodality)**: A system with a cache exhibits **bimodal behavior**: light on hits, heavy on misses. Design, capacity, and testing MUST always be based on the **miss side and total-loss side**. Prior art: AWS Builders' Library, "Caching challenges and strategies."

---

## §2. Staleness Contract

> This section is the core of this file. The first artifact of cache design is not code — it is **a written agreement on "which data may be how stale."**

### §2.1. Explicit Permitted Staleness per Data Class

-   **Rule 730.2.1 (Staleness contract mandatory)**: When introducing a cache, the **permitted staleness (the maximum age of a value that may be served) MUST be documented per data class**. At minimum, the contract is recorded in a design document (ADR / README / rule file) as a table with the following columns:

| Column | Meaning |
|:---|:-----|
| Data class | The logical data class being cached (e.g., master data / search results / balances) |
| Permitted staleness | The maximum age of a value that may be served (the rationale for the soft TTL ceiling) |
| Invalidation trigger | TTL only, or combined with event-driven invalidation (§5.2) |
| Behavior on downstream failure | Continue serving stale (fail-open) or error out (fail-closed) (§3.2) |
| Reason caching is prohibited (if applicable) | Rationale when caching itself is prohibited, e.g., authorization results or PII (§9) |

-   **Rule 730.2.2 (No unjustified defaults)**: Differences between data classes MUST NOT be flattened by an **unjustified default TTL** such as "60 seconds for now" (MUST NOT). A design where balances and static master data share the same TTL is evidence that no contract exists. For prior art on concrete tier values, see `operations/400` §57.

### §2.2. Prohibition of Implicit Consistency Degradation

-   **Rule 730.2.3 (No undeclared caches)**: A cache introduction without a staleness contract (a cache whose staleness questions cannot be answered in review) MUST NOT be merged. A diff that introduces a cache MUST state "what becomes stale, by at most how much, and who accepted it" (MUST).
-   **Litmus test**: A cache for which "what is the oldest value this cache could possibly return?" cannot be answered immediately has no contract.

### §2.3. Cache Consistency SLO

-   **Rule 730.2.4 (Cache SLO)**: Major caches SHOULD have a **target hit rate** and a **staleness ceiling (a target upper bound on the age of served entries)** set as SLOs. Hit rate as the sole KPI degenerates into "improvement by just lengthening TTLs" — it MUST always be managed as a pair with staleness (MUST).
-   **Rule 730.2.5 (Handling SLO violations)**: Violations of invalidation-latency or staleness SLOs SHOULD be treated as **data-correctness incidents**, not performance issues. Detection mechanisms are in §8.

---

## §3. TTL Design

### §3.1. Dual TTL (soft TTL / hard TTL)

-   **Rule 730.3.1 (Dual TTL)**: Caches where availability matters SHOULD adopt a **dual TTL: a soft TTL (freshness deadline) and a hard TTL (serving deadline)**:
    -   **After the soft TTL**: the entry becomes "stale" and a refetch from the origin is attempted. **If the refetch fails, serving the stale value MAY continue** (when fail-open is chosen, §3.2)
    -   **After the hard TTL**: the entry can no longer be served. Stale serving is **cut off** here
-   **Intent**: Dual TTL prevents "a transient downstream failure makes even already-cached data unservable," while **structurally guaranteeing an upper bound** on stale serving. It is the same concept as `stale-while-revalidate` / `stale-if-error` in RFC 5861 (§6) and applies not only to the HTTP layer but also to application-layer and distributed caches.
-   **Structure example**: see §11.2.

### §3.2. Explicit Design-Time Choice of fail-open / fail-closed

-   **Rule 730.3.2 (Pre-decided failure behavior)**: "When the origin is down, do we serve stale or return an error?" MUST be **explicitly chosen and documented at cache design time**. It MUST NOT be improvised on the day of the outage (MUST NOT):
    -   **fail-open (continue serving stale)**: availability first. Suited to content, catalogs, recommendations — data where serving an old value is less harmful than malfunctioning
    -   **fail-closed (stop with an error)**: correctness and safety first. Mandatory for authorization decisions, balances, inventory reservations — data where an old value causes real harm
-   **Rule 730.3.3 (Safe default)**: Caches involved in authorization, billing, or security decisions MUST default to **fail-closed**. Choosing fail-open requires an ADR with the rationale.

### §3.3. TTL Jitter (Preventing Synchronized-Expiry Stampedes)

-   **Rule 730.3.4 (TTL jitter mandatory)**: When caching a large number of entries of the same kind, the TTL MUST include **random jitter of roughly ±10–20%**. **Synchronized expiry** anchored to a deployment, a bulk warm-up, or the top of the hour produces a synchronized load spike (stampede) against the origin.
-   **Prior art**: The AWS Builders' Library lists jitterless synchronized expiry as a leading failure cause for external caches.

### §3.4. Negative Caching (Separate TTL for Non-Existence)

-   **Rule 730.3.5 (Negative caching)**: Results of "does not exist" and "was an error" SHOULD also be cached, **with a TTL separate from (and usually shorter than) the one for normal values**. Repeated access to non-existent keys passes straight through the cache and hits the origin directly.
-   **Rule 730.3.6 (Negative TTL ceiling)**: The negative-cache TTL directly determines "the maximum delay before newly created data becomes visible." It MUST NOT exceed the permitted delay of creation flows (the §2.1 contract). Combining it with explicit invalidation on creation events (§5.2) is recommended (SHOULD).

---

## §4. Stampede Prevention

### §4.1. Request Coalescing (single-flight)

-   **Rule 730.4.1 (Coalescing mandatory)**: When cache misses for the same key occur concurrently, the fetch to the origin MUST be **coalesced into one (single-flight)**; the remaining requests wait for that result or receive stale. An implementation where N concurrent misses = N origin calls is a §12 anti-pattern.
-   **Applicable layers**: in-process, share the in-flight Promise/Future; in distributed environments, use a lock (§4.3) or a dedicated coalescing layer. Pseudocode in §11.1.

### §4.2. Probabilistic Early Recomputation

-   **Rule 730.4.2 (Early recomputation)**: For hot keys (keys hit by a burst of traffic at the instant of expiry), a scheme that **probabilistically starts recomputation before the TTL expires (probabilistic early expiration)** is recommended (SHOULD). The closer to the deadline, the higher the probability of a preemptive refetch — eliminating the miss burst at the expiry instant itself.
-   **Prior art**: Vattani et al., "Optimal Probabilistic Cache Stampede Prevention" (XFetch). `operations/400` §57 also lists the same scheme as thundering-herd prevention.

### §4.3. Locked Rebuild

-   **Rule 730.4.3 (Rebuild lock)**: For keys with expensive recomputation in a distributed cache, **only the one worker that acquires the rebuild right hits the origin; the others serve stale or wait briefly** (SHOULD). The lock MUST always carry an expiry, preventing a key from becoming permanently unrebuildable when the rebuilder dies (MUST).

---

## §5. Invalidation Strategy

### §5.1. Multi-Layer Invalidation Order (origin → distributed → edge)

-   **Rule 730.5.1 (Invalidation order)**: In a system with multiple cache layers, invalidation MUST proceed **from the layer closest to the origin outward (toward the edge)**: ① commit the data at the origin → ② invalidate the app / distributed cache → ③ purge the CDN / edge.
-   **Rationale**: In the reverse order (purging the edge first), a request arriving right after the purge **reads the still-stale value from the inner cache and re-caches the old value at the edge**. This is the classic cause of "we invalidated, but the old value remains."
-   **Rule 730.5.2 (Idempotent, retryable invalidation)**: Invalidation operations MUST be idempotent and retryable on failure. Invalidation failures MUST NOT be swallowed — a failed invalidation is accounted for as a staleness-contract violation (§8.3).

### §5.2. Event-Driven vs TTL — Selection Criteria

-   **Rule 730.5.3 (Two-layer safety net)**: Invalidation SHOULD follow the two-tier baseline of "**event-driven (detect updates and invalidate immediately) as the primary means, TTL as the safety net**." Event-driven only (TTL ∞) lets missed invalidations persist forever; TTL only lets staleness degrade up to the full TTL:
    -   Data with short permitted staleness (§2.1 contract): event-driven mandatory + a short TTL safety net
    -   Data with long permitted staleness: TTL alone MAY suffice
-   **Prior art**: the `content.updated` webhook → cache invalidation in `engineering/310` and `revalidateTag` in `engineering/300` are stack-specific implementations of this scheme.

### §5.3. Cache Key Design (Schema Version Mandatory)

-   **Rule 730.5.4 (Key completeness)**: A cache key MUST include **every input dimension that determines the content of the value**. If inputs that change the output — locale, tenant, role, feature flags, etc. — are missing from the key, values from different contexts cross-contaminate (for preventing preview/public mixing, see `engineering/310` §17.2).
-   **Rule 730.5.5 (Schema version mandatory)**: The cache key (or its namespace prefix) MUST include **the schema version of the cached value**. During a deployment rollout, old and new code coexist; with unversioned keys, new code reads values written by old code, causing deserialization failures and silent inconsistencies. The general theory of schema coexistence is canonical in `engineering/000` Part XVII (Expand-Contract). Design example in §11.3.
-   **Prior art**: Cache Versioning in `engineering/200` (preventing Cache Rot via the `master_data_v2` suffix) is a stack-specific implementation of this rule.

### §5.4. Versioned Keys vs Purge

-   **Rule 730.5.6 (Choosing the mechanism)**: There are two families of invalidation mechanisms; choose with their characteristics understood (SHOULD):
    -   **Versioned keys (key switch)**: write to the new version's key and let the old key expire naturally. Switches atomically without waiting for purge propagation. Suited to bulk invalidation (after deployments / migrations). The cost is storage for the old entries
    -   **Purge (explicit deletion)**: suited to immediate invalidation of individual entries. In multi-layer / distributed environments, **propagation delay and partial failure** are inherent, so the ordering of §5.1 and the latency measurement of §8.3 are mandatory
-   **Rule 730.5.7 (Forced invalidation after migrations)**: After completing a data migration or bulk backfill (`engineering/700`), the affected caches MUST be **explicitly invalidated** via key switch or purge. "The TTL will clear it eventually" MUST NOT be used as a migration procedure (MUST NOT).

---

## §6. stale-while-revalidate / stale-if-error (RFC 5861)

-   **Rule 730.6.1 (Universal application of SWR)**: **stale-while-revalidate** (after the soft TTL, return stale immediately while asynchronously refetching in the background) was standardized as an HTTP `Cache-Control` extension (RFC 5861), but it is **a universal pattern applicable in the same form to every cache layer, not just HTTP**. Its adoption is recommended for reads where latency consistency matters (SHOULD). The stale-serving window MUST NOT exceed the permitted staleness of §2.1.
-   **Rule 730.6.2 (Universal application of SIE)**: **stale-if-error** (serve stale while the origin is erroring, preserving availability) likewise applies layer-independently. It is the standard form of implementing the fail-open of §3.2 with a time bound, and a **maximum serving duration (the hard-TTL equivalent) MUST always accompany it**.
-   **Rule 730.6.3 (Visibility of stale serving)**: The fact that stale was served via SWR / SIE MUST be made **observable** as response metadata (the `Warning`/`Age` equivalents for HTTP; a log/metrics flag for the application layer). The state of "we had quietly been serving stale all along" MUST NOT be made undetectable (§8.2).
-   **Web-stack-specific forms**: Next.js ISR / SWR libraries / the CDN `stale-while-revalidate` directive are implementations of this pattern — configuration values and operations are canonical in `engineering/300`.

---

## §7. Total-Loss Tolerance (Cold Start)

-   **Rule 730.7.1 (Include total loss in capacity planning)**: Capacity planning MUST include **whether the downstream (origin DB, external APIs) survives the load when the cache is empty (total loss, flush, restart, region failover)**. If it does not, the cache is not a "performance optimization" but a **single point of failure for availability** — that dependency MUST be acknowledged, and cold-start load limiting (concurrency caps, admission control, gradual traffic restoration) MUST be designed. The canonical for capacity planning and cliff-scenario testing (including cache total-loss cold start) is `operations/650` §9; saturation monitoring is canonical in `operations/400` Part XXVII §65.
-   **Rule 730.7.2 (Warm-up / preload)**: As a recovery means from total loss, prepare a **warm-up (pre-fill) procedure for hot keys** (SHOULD). To keep the warm-up itself from overwhelming the origin, throttling (backpressure of the same form as `engineering/700` §3.3) MUST be applied.
-   **Rule 730.7.3 (Total-loss drills)**: For major caches, periodically running a **recovery drill from an intentional flush** is recommended (SHOULD). In a system with bimodality (Rule 730.1.6), the miss-side behavior degrades unverified unless drilled.
-   **Prior art**: The AWS Builders' Library positions "can you tolerate the dependency on cache availability?" as the first design decision when introducing an external cache.

---

## §8. Observability

> General metrics and logging infrastructure are canonical in `ai/100` Part XI–XV. This section defines **only cache-specific measurement obligations**.

-   **Rule 730.8.1 (Measure hit rates)**: Major caches MUST emit **hit / miss rates as metrics per keyspace (data class)**. A hit rate that exists only as a global average hides the degradation of specific data classes.
-   **Rule 730.8.2 (Measure staleness)**: The **age of served entries (time since creation)** MUST be measured, and stale serving (§6) MUST be counted with a flag. In a system that does not measure staleness, compliance with the §2 contract cannot be verified.
-   **Rule 730.8.3 (Measure invalidation latency)**: Systems with event-driven invalidation SHOULD measure **the propagation delay from "origin updated" to "the new value is served at every layer."** Invalidation bugs (misses, reversed ordering, partial failures) are **structurally undetectable** without this measurement — "we thought we invalidated" is the invisible failure this file warns against most.
-   **Rule 730.8.4 (Measure origin protection)**: The justification for the cache (reduced load on the origin) SHOULD be verified by **measuring the origin request rate**. If origin load is higher than expected despite a high hit rate, suspect key fragmentation or missing negative caching (§3.4).

---

## §9. Security / Privacy

> Threat models and countermeasures are canonical in `security/000_security_privacy.md` (§22.6 cache poisoning & Service Worker, §7 Privacy by Design). This section defines only the design boundary.

-   **Rule 730.9.1 (Authorization cache boundary)**: When caching authorization decisions (allow/deny), the key MUST **fully include principal × resource × action**, the TTL MUST be short, and the failure behavior MUST be fail-closed (Rule 730.3.3). Caching authorization under a key missing the principal dimension is a **direct cause of privilege escalation** and is prohibited (MUST NOT). The propagation delay of revocation MUST be stated in the §2.1 contract.
-   **Rule 730.9.2 (No PII / secrets in shared caches)**: PII, authentication tokens, and session-specific data MUST NOT be stored in **shared caches (CDNs, proxies, multi-user shared layers)**. For HTTP, `Cache-Control: no-store` (or `private`) MUST be explicit; the state of "no header = defer to intermediary defaults" is prohibited (MUST).
-   **Rule 730.9.3 (Cache poisoning boundary)**: Cache keys MUST be composed **only of normalized inputs**. A configuration where inputs not included in the key (unkeyed input — arbitrary headers etc.) influence the response content is the classic precondition for cache poisoning, where an attacker pins a crafted response into a shared cache. Details in `security/000` §22.6.
-   **Rule 730.9.4 (Cross-tenant key isolation)**: In multi-tenant systems, the cache key namespace MUST be **isolated per tenant**. The tenant ID is a mandatory key dimension (Rule 730.5.4), structurally eliminating designs where a cross-tenant key collision is itself a data leak.

---

## §10. Testing Obligations

> General test layer definitions and test doubles are canonical in `quality/000_qa_testing.md`. This section defines **only cache-specific testing obligations**.

-   **Rule 730.10.1 (Invalidation path test)**: A test that verifies the **invalidation path "origin updated → invalidated → reads return the new value," through every participating cache layer**, is mandatory (MUST). Tests of the read path alone wave through the leading cause of cache bugs (missed invalidation).
-   **Rule 730.10.2 (Stale-serving path test)**: Inject a downstream failure and verify that **stale serving after the soft TTL (when fail-open is chosen) and cut-off at the hard TTL** behave as designed (MUST). When fail-closed is chosen, verify that stale is not served.
-   **Rule 730.10.3 (Coalescing test)**: For N concurrent misses on the same key, verify that **the origin is called once (or at most the designed limit)** (MUST).
-   **Rule 730.10.4 (Negative-cache / key-version tests)**: Verify ① the path "non-existent → created → becomes visible within the negative TTL / via invalidation," and ② the path "after a schema version bump, entries of the old version are never read" (SHOULD).

---

## §11. Implementation Snippets

> Everything below is a **reference implementation** (e.g. TypeScript), shown as a representative expression of the language-agnostic discipline (§3–§5). Translate into the idioms of your own stack.

### §11.1. single-flight (§4.1)

```typescript
// Reference implementation coalescing concurrent misses for the same key into one origin fetch
const inFlight = new Map<string, Promise<Value>>();

async function getWithCoalescing(key: string, fetchOrigin: () => Promise<Value>): Promise<Value> {
  const cached = cache.get(key);
  if (cached && !isSoftExpired(cached)) return cached.value;

  const existing = inFlight.get(key);
  if (existing) {
    // Someone is already refetching: join and wait (stale may be returned immediately if present — §6 SWR)
    if (cached) return cached.value;
    return existing;
  }

  const flight = fetchOrigin()
    .then((value) => { cache.set(key, wrap(value)); return value; })
    .finally(() => inFlight.delete(key)); // always release, regardless of outcome
  inFlight.set(key, flight);

  if (cached) return cached.value; // stale-while-revalidate: return stale, refresh in background
  return flight;
}
```

### §11.2. Dual-TTL Entry Structure (§3.1)

```typescript
// Reference implementation of an entry with soft/hard TTLs and read classification
interface CacheEntry<V> {
  value: V;
  schemaVersion: number;   // §5.3: belongs in the key as the principle; may also be duplicated on the value
  createdAt: number;       // epoch ms — used for the §8.2 age measurement
  softExpiresAt: number;   // freshness deadline: afterwards the entry is stale (refetch attempted)
  hardExpiresAt: number;   // serving deadline: afterwards unservable (stale serving cut off)
}

type ReadResult<V> =
  | { kind: 'fresh'; value: V }
  | { kind: 'stale'; value: V }   // servable only under fail-open. Count served_stale (§6.3)
  | { kind: 'expired' };          // past the hard TTL — must not be served even under fail-open

function classify<V>(e: CacheEntry<V>, now: number): ReadResult<V> {
  if (now >= e.hardExpiresAt) return { kind: 'expired' };
  if (now >= e.softExpiresAt) return { kind: 'stale', value: e.value };
  return { kind: 'fresh', value: e.value };
}
```

### §11.3. Versioned, Jittered Key Design (§3.3, §5.3, §9.4)

```typescript
// Reference implementation of schema versioning + tenant isolation + TTL jitter
const SCHEMA_VERSION = 3; // increment whenever the shape of the cached value changes (§5.3)

function cacheKey(tenantId: string, dataClass: string, naturalKey: string): string {
  // tenant → namespace isolation (§9.4) / v3 → prevents old/new cross-contamination across deploys (§5.3)
  return `t:${tenantId}:v${SCHEMA_VERSION}:${dataClass}:${naturalKey}`;
}

function ttlWithJitter(baseMs: number, jitterRatio = 0.15): number {
  // ±15% jitter prevents synchronized-expiry stampedes (§3.3; pick within the 10–20% range)
  const delta = baseMs * jitterRatio;
  return Math.round(baseMs - delta + Math.random() * 2 * delta);
}
```

---

## §12. Anti-Pattern Catalog

| # | Anti-pattern | Violated rule | Consequence |
|:--|:-------------|:----------|:-----|
| 1 | Indefinite TTL (no TTL, effectively ∞) | 730.2.1, 730.5.3 | Missed invalidations persist forever; staleness degrades without bound |
| 2 | Jitterless synchronized expiry (anchored to deploys or the top of the hour) | 730.3.4 | Synchronized-expiry stampede sends a synchronized load spike to the origin |
| 3 | Caching authorization results under a key missing the principal dimension | 730.9.1 | Privilege escalation by reusing another user's allow decision |
| 4 | PII / tokens stored in shared caches / CDNs (missing no-store) | 730.9.2 | Sensitive data is served across users |
| 5 | Not measuring invalidation latency or staleness | 730.8.2–3 | Invalidation bugs become structurally undetectable |
| 6 | Creating data that exists only in the cache (cache as SSOT) | 730.1.5 | Flush, failure, or restart permanently destroys data |
| 7 | Cache misses without coalescing (N concurrent misses = N origin calls) | 730.4.1 | Thundering herd on every hot-key expiry |
| 8 | No negative cache; non-existent keys pass straight through | 730.3.5 | Repeated hits on non-existent keys strike the origin directly |
| 9 | Negative TTL exceeding the permitted delay of creation flows | 730.3.6 | Newly created data appears "non-existent" for a long time |
| 10 | Invalidating in reverse order, edge → origin | 730.5.1 | Old values are re-cached at the edge right after the purge |
| 11 | Crossing a deployment with unversioned keys | 730.5.5 | Old and new code contend on the same key — deserialization failures and inconsistencies |
| 12 | fail-open / fail-closed left undecided, improvised on the day of the outage | 730.3.2 | Consistency/availability judgment errors compound during incident response |
| 13 | Excluding cache total loss from capacity planning | 730.7.1 | The origin saturates on the cold start after a flush or restart |
| 14 | Sharing a key namespace across tenants | 730.9.4 | A key collision is itself a cross-tenant data leak |
| 15 | Hit rate as the sole KPI, ignoring staleness | 730.2.4 | "Improvement by just lengthening TTLs" silently degrades consistency |

---

## §13. Maturity Model L1–L5

| Level | State | Characteristics |
|:------|:-----|:-----|
| **L1: Ad-hoc** | Caches without contracts | `cache.set()` scattered around with no staleness contract. Indefinite TTLs and authorization-cache boundary violations may exist |
| **L2: TTL'd** | TTLs exist, discipline does not | All data on a uniform, unjustified TTL. No jitter, coalescing, or negative caching. Invalidation = "wait for the TTL" |
| **L3: Contracted** | Staleness contract implemented | A per-data-class contract table (§2.1) exists. Dual TTL + jitter + single-flight + schema-versioned keys are standard |
| **L4: Operated** | Operational discipline established | Hit rate, staleness, and invalidation latency emitted as metrics and wired to alerts. fail-open/closed documented for every cache. Total-loss capacity verified |
| **L5: Verified** | Continuous verification | Invalidation paths, stale serving, and coalescing verified in CI; flush drills run periodically. Trends in cache-caused incidents feed back into contract revisions |

-   **Rule 730.13.1 (Floor)**: Every cache receiving production traffic MUST be at **L3 or above**. Systems handling authorization, billing, or PII near a cache boundary MUST treat compliance with §9 as a precondition of L3.

---

## Appendix A: Reverse-Lookup Index (keyword → section)

| Keyword | Section |
|:----------|:----------|
| Applicability / what counts as a cache / litmus test | §1.1 |
| Responsibility boundary / delegation targets / adjacent-file boundaries | §1.2 |
| Derived data / SSOT prohibition / bimodality | §1.3 |
| Staleness contract / permitted staleness / contract table | §2.1 |
| No undeclared caches / review criteria | §2.2 |
| Cache SLO / managing hit rate and staleness as a pair | §2.3 |
| Dual TTL / soft TTL / hard TTL | §3.1, §11.2 |
| fail-open / fail-closed / failure behavior | §3.2 |
| TTL jitter / synchronized expiry / 10–20% | §3.3, §11.3 |
| Negative caching / non-existence / caching errors | §3.4 |
| Stampede / thundering herd / single-flight / coalescing | §4.1, §11.1 |
| Probabilistic early recomputation / XFetch | §4.2 |
| Rebuild lock / lock expiry | §4.3 |
| Invalidation order / origin → distributed → edge | §5.1 |
| Event-driven invalidation / TTL safety net | §5.2 |
| Cache key design / schema version / input dimensions | §5.3, §11.3 |
| Versioned keys vs purge / post-migration invalidation | §5.4 |
| stale-while-revalidate / stale-if-error / RFC 5861 | §6 |
| Total-loss tolerance / cold start / warm-up / flush drills | §7 |
| Hit rate / staleness measurement / invalidation latency / origin protection | §8 |
| Authorization caching / privilege escalation / revocation delay | §9 (730.9.1) |
| PII / no-store / shared-cache prohibition | §9 (730.9.2) |
| Cache poisoning / unkeyed input | §9 (730.9.3) |
| Tenant isolation / multi-tenant keys | §9 (730.9.4) |
| Invalidation path test / stale-serving test / coalescing test | §10 |
| Anti-patterns | §12 |
| Maturity model / L1–L5 / floor | §13 |

---

**References (standards & prior art)**: RFC 2119 / RFC 5861 (stale-while-revalidate, stale-if-error) / AWS Builders' Library "Caching challenges and strategies" / Vattani et al. "Optimal Probabilistic Cache Stampede Prevention" (XFetch) / RFC 9111 (HTTP Caching)

**Cross-Reference:**
-   `engineering/300_web_frontend.md` — Part XVII Data Fetching & Caching (§85 Public Cache Mandate, §86 Cache Versioning), §208 hit-rate target (web-stack-specific canonical for ISR / SWR / CDN)
-   `engineering/310_headless_cms.md` — Part XVII cache tiering strategy (content tiers, on-demand revalidation, preview/public key separation)
-   `engineering/200_supabase_architecture.md` — Cache Versioning (Cache Rot prevention), Rule 7.5 Cache Reload Protocol, Storage CDN caching (stack-specific canonical)
-   `operations/400_site_reliability.md` — Part XXIII §57 Cache Hierarchy (SRE canonical tier table), Part XXVII §65 saturation monitoring
-   `operations/650_capacity_planning.md` — capacity planning, scale-cliff ledger, §9 cache total-loss cold-start testing (connection point for §7 of this file)
-   `operations/600_cloud_finops.md` — general theory of usage-billing reduction through caching (FinOps perspective)
-   `engineering/000_engineering_standards.md` — Part XVII Expand-Contract (background for schema-versioned keys), principles for the location of the data source of truth (SSOT)
-   `engineering/700_batch_backfill_operations.md` — forced invalidation after backfills / migrations (§5.7), backpressure applied in the same form (§7.2)
-   `security/000_security_privacy.md` — §22.6 Service Worker / cache poisoning, §7 Privacy by Design (canonical for §9 of this file)
-   `quality/000_qa_testing.md` — canonical for test layer definitions (§10 of this file holds only cache-specific obligations)
-   `ai/100_data_analytics.md` — Part XI–XV general metrics and structured-logging infrastructure (collection side of §8 of this file)

---

**Last Updated**: 2026-06-12
**Authority**: Universal Constitution (axiarch core)
**Classification**: Engineering — Caching Discipline
