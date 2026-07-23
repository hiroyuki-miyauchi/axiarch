# 37. Backend Data Strategy: Supabase (PostgreSQL)

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-07-23

> [!IMPORTANT]
> **Primary Directive**
> "Data is the lifeblood of the enterprise. No compromise is permitted in its flow and protection."
> In Supabase/PostgreSQL implementation, strictly observe the priority order: **Security (RLS) > Data Integrity > Performance > Developer Productivity > Cost Efficiency**.
> This document is the provider profile for backend and data strategy in systems that adopt Supabase/PostgreSQL.
> **60 sections, 200+ rules.**

> [!NOTE]
> **Universal Applicability Contract**
> This file does not mandate Supabase/PostgreSQL for every project. Adoption follows the capability, risk, cost, and portability evaluation in `engineering/520_cloud_application_platforms.md`; apply only rules relevant to adopted capabilities. Product names, limits, CLI commands, defaults, paths, framework helpers, and fixed thresholds are reference examples and must be revalidated against current official documentation and effective settings. Fixed topology, region, budget, and naming decisions belong in Blueprint. If a concrete recipe in this profile conflicts with least privilege, data integrity, migration immutability, or the cross-provider principles in 520, those principles take precedence and the recipe is not enforced verbatim.

---

## Table of Contents

- §0. Data Sovereignty Law & Primary Directives
- §1. Supabase Hybrid Stack Principle
- §2. Database Design Standards
- §3. Integrity & Logic Strategy
- §4. Performance & Scalability
- §5. Auth & Security
- §6. Storage & Delivery
- §7. Operations & Migration
- §8. Maintenance & Hardening
- §9. Domain Data Modeling
- §10. Universal Portability
- §11. Backend Governance
- §12. Migrations & Privileged Operations
- §13. Edge Functions Architecture
- §14. Realtime Engine
- §15. Cron, Queue & Webhook Strategy
- §16. Observability & FinOps
- §17. pgvector & AI Search
- §18. Advanced Auth & API Key Management
- §19. Testing Strategy
- §20. Branching & Environment Management
- §21. PostgREST / REST API Optimization
- §22. CLI & Local Development
- §23. Connection Pooling (Supavisor)
- §24. Backup & DR Strategy
- §25. Rate Limiting & API Protection
- §26. Vault & Secret Management
- §27. Foreign Data Wrappers (FDW)
- §28. Data API Hardening
- §29. Multi-tenancy Strategy
- §30. pg_graphql / GraphQL
- §31. DB Functions & Triggers
- §32. Log Drain & External Observability
- §33. Auth Hooks & Custom Claims
- §34. Self-hosted & Email Configuration
- §35. SSR / Framework Integration
- §36. Database Extensions Management
- §37. Client SDK / supabase-js
- §38. Schema Design Patterns
- §39. Social Auth / OAuth / SSO
- §40. Data Migration & Seeding
- §41. Multigres & Horizontal Scaling
- §42. PostgreSQL 18 New Features (AIO, UUIDv7, Skip Scan)
- §43. Column-Level Security
- §44. Passkeys & Biometric Auth
- §45. MCP Server & AI Development Integration
- §46. Security Advisor & Auto-Remediation
- §47. Per-Table API Control & Data API Disable
- §48. VPC & Private Link
- §49. Read Replicas & Load Balancing
- §50. Project-scoped Roles & Team Management
- §51. Provider-neutral CI/CD
- §52. Advisory Locks & Concurrency Control
- §53. Webhook Signature & Event-Driven Integration
- §54. Advanced Database Partitioning
- §55. Full-Text Search & pg_trgm
- §56. AI Assistant & Generated SQL Governance
- §57. Type-Safe End-to-End
- §58. Global CDN & Edge Caching
- §59. Compliance & Data Sovereignty
- §60. Operational Maturity Model
- Appendix A: Quick Reference Index
- Appendix B: Cross-References

---

## 0. Data Sovereignty Law & Primary Directives

### Primary Directive 0.1: The Zero Tolerance Linter Protocol
-   **Law**: Database Linter findings (Supabase Security Advisor, etc.) must not be ignored without review; triage them as security, integrity, or performance risks.
-   **Mandate**:
    1.  **Risk-Based Gate**: Block release while an applicable Critical/High finding or an unexplained finding remains unresolved.
    2.  **Documented Disposition**: A false positive, non-applicable finding, or time-bound acceptance requires rationale, impact, owner, approver, and expiry. Never suppress findings in bulk without individual review.

### Primary Directive 0.2: The Trinity DTO Mandate
-   **Purpose**: Trinity obligation that supports data structure robustness and scalability.
    -   **Security**: Reduce raw data leakage risk through white-list output.
    -   **Stability**: Protect frontend from DB changes (Mapper Shield).
    -   **AI Economy**: Save AI tokens (Data Minimization).
    -   **Universality**: A baseline engineering standard regardless of language.

### Primary Directive 0.3: Omnichannel Data Principle (API First)
-   **Principle**: Data structures must be designed assuming consumption not only by a single Web app but also by native apps, external systems, and AI agents.
-   **Mandate**:
    -   **Universal Types**: Do NOT store data types dependent on specific UI frameworks (React Node, etc.) in DB.
    -   **Neutral JSON**: Manage JSON data as "pure data" without display logic.

### Primary Directive 0.4: The Client DTO Barrier
-   **Law**: Passing database row data (Raw Entity) directly as Props to client-side components (`use client`, etc.) is **prohibited**.
-   **Mandate**:
    -   **Server-Side Transformation**: Always transform data into purpose-specific lightweight DTOs on the server side, sending only the minimum required fields to the client.
    -   **PII Exclusion**: Reduce the risk that PII such as `admin_notes`, `phone_number`, `email` and internal management fields (`deleted_at`, `internal_memo`) reach the browser.
    -   **Payload Minimization**: Sending unnecessary fields causes the dual problem of wasted network bandwidth and increased future data leakage risk.
-   **Rationale**: As the concrete boundary for the DTO obligation defined by SD 0.2 (Trinity DTO Mandate), this establishes data handoff to client components as a physical interception point. Direct transmission of Raw Entities is the greatest risk source for unintended PII leakage.

### Core Laws
-   **Explicit Authority (Single Source of Truth)**: Define one authoritative store and owner for each data domain. PostgreSQL, an external CMS, object storage, and configuration repositories may coexist when domain boundaries, synchronization direction, conflict resolution, and failure behavior are documented. Accidental dual authority is prohibited.
-   **Migration Only**: DB schema changes must go through repository-managed, provider-native migrations. `supabase/migrations` is a conventional example. Emergency manual operations require prior approval or a break-glass procedure, audit evidence, and immediate codification and reconciliation.
-   **Migration Immutability Law (Sanctuary)**:
    -   **Law**: A migration applied to a shared environment, or depended on by another contributor, is immutable; corrections require a new migration.
    -   **Private Draft**: An unapplied draft held only by its author may be amended before review while preserving an understandable history.

---

## 1. Hybrid Stack Responsibility
-   **Capability-Based Stack**:
    -   **Edge/CDN**: Place DDoS protection, WAF, cache, routing, and lightweight low-latency processing according to runtime limits and data boundaries. Cloudflare is one option.
    -   **Frontend/Application Platform**: Place UI rendering, APIs, and background work according to latency, duration, state, observability, and cost. Vercel is one option.
    -   **Data Platform**: Place database, auth, storage, realtime, and asynchronous work according to authoritative data and recovery requirements. Supabase is one option.
    -   **Boundary Contract**: When composing platforms, explicitly define data ownership, identity principal, network path, retries, consistency, degraded behavior, and cost attribution.

## 2. Database Design (PostgreSQL)

### Rule 2.0: The Realism Mandate (Anti-Haribote Protocol)
-   **Prohibition**: Do not present a value in UI or API as persisted, integrity-checked domain data when it has no persistence, integrity, queryability, or authoritative data source.
-   **Requirement**: For important attributes such as finance, authorization, or state transitions, select a representation such as relational columns, versioned JSON schemas, or another authoritative store that fits query, constraint, concurrency, retention, and migration needs, and record its type, constraints, and owner in the data contract.
-   **Delivery Contract**: Deliver UI, API, storage, and migrations in a backward-compatible order and test coexistence with old clients. Do not universally require one atomic release.

### Rule 2.0.1: The Settings Representation Architecture
-   **Law**: Select a settings representation from access patterns, constraints, update units, search, history, and schema evolution. Prefer relational columns or tables for independently queried, joined, constrained, or authorized attributes; JSONB is valid for a variable structure read and written as one bounded aggregate.
-   **JSONB Contract**: Define an owner, versioned schema, runtime validation, size limit, defaults, unknown-field policy, migration or backfill, and indexing policy. Prohibit untyped catch-all blobs, unbounded growth, and mixing secrets into general configuration.
-   **Promotion Trigger**: Promote an attribute to a column or related table when it requires frequent filtering or joins, strong database constraints, field-level authorization, an independent lifecycle, or relief from hot-update contention.
-   **Migration**: Version-control a breaking relational-schema or JSON-contract change and verify old and new reader compatibility, backfill, and rollback or forward-fix.

### Rule 2.1: Integrity & Ownership
-   **RLS Strict Default**: Treat Row Level Security as the default boundary for exposed schemas and untrusted client access. Never give bypass credentials such as `service_role` to clients; allow them only to narrowly scoped server-side workloads with audit and rotation. Do not force maintenance, migrations, and system jobs through RLS indiscriminately; document the authorization boundary of each privileged path.
-   **Hierarchical Resource Ownership**:
    -   **Context**: Complex ownership structures like family sharing or team projects that cannot be expressed with single owner (`user_id`).
    -   **Law**: When multiple principals access a resource, select an authoritative authorization model such as membership tables, relationship graphs, tenant claims, or a policy service according to update rate, consistency, revocation, and query cost, and enforce it through RLS or a server boundary.
    -   **Action**:
        1.  **Authority**: Identify the source of truth and updater for owner, member, role, tenant, and delegation.
        2.  **Revocation**: Define the maximum propagation delay through caches, JWTs, and replicas.
        3.  **Inheritance**: Where parent-child inheritance is used, negative-test cycles, cross-boundary access, confused deputies, and deletion behavior.
-   **PII Encryption**: Select provider encryption, application or field-level encryption, tokenization, or another control from data classification and threat modeling, and design key ownership, rotation, searchability, and backup or restore. Vault and pgcrypto are candidates, not universal defaults.

### Rule 2.2: Schema & Type Standards
-   **Schema Separation**: Separate exposed API, internal data, extension objects, and audit or administration trust boundaries with schemas and grants. Do not fix schema names to `public`, `extensions`, and `admin`; verify existing extension locations and provider support before migration.
-   **Managed Schema Boundary**: Do not directly modify provider-managed schemas such as `storage`, `auth`, or `graphql` outside an official extension point or verified migration. Test upgrade compatibility and privileges even when references are required.
-   **Constraints**:
    -   **Identity**: Select key type from global uniqueness, sortability, offline generation, replication, privacy, and storage cost. When a sequence fits, prefer `IDENTITY` to `SERIAL`.
    -   **Money**: Use a smallest-unit integer or `numeric` or `decimal` with explicit precision and rounding for exact monetary and accounting calculations. Do not prohibit floats for measurements where approximation is part of the domain.
    -   **Boolean**: Decide whether `NULL` represents an unknown or unevaluated domain state. For binary values, use `NOT NULL` and an intentional default; for three-state values, record semantics, queries, and migration in the data contract.

### Rule 2.3: Type Safety Protocol (The Bridge)
-   **Generated Contract**: Where official generation is available for the selected SDK or language, reproducibly generate types or client contracts from a schema revision and verify the source digest and drift in CI. TypeScript `database.types.ts` is one example.
-   **Boundary Validation**: Do not depend on compile-time types alone; validate untrusted input, database results, events, and external APIs with a language-native or approved runtime validator.
-   **Adapter Law**: An adapter from generated to domain types makes nullability, decimals, timestamps, unknown enum values, JSON, and 64-bit integers explicit. Do not universally prohibit or require mapped types, intersections, classes, or code generation; prove safety with type and runtime tests.

### Rule 2.4: The New Table Checklist (Creation Protocol)
-   **Law**: A new table satisfies applicable items and records why an item is non-applicable:
    - [ ] **Exposure & Grants**: Is exposure explicit, with least table and column privileges per role?
    - [ ] **RLS & Policy**: For an exposed schema or untrusted client path, is RLS enabled and are only required operations for roles such as `anon` and `authenticated` positive- and negative-tested? Do not create redundant policies for RLS-bypass roles.
    - [ ] **Integrity & Index**: Are PK, FK, unique, check, and nullability constraints and indexes required by real query, join, and delete costs verified? Do not assume every FK requires an index mechanically.
    - [ ] **Contract**: Are generated types, schema clients, or API contracts for adopted languages updated and checked for drift?
    - [ ] **Lifecycle & Audit**: Are retention, deletion, backup, replication, PII, and audit requirements classified, with audit mechanisms applied only where required?

### Rule 2.17: The Schema-Reality Reconciliation Checklist
-   **Law**: When creating or modifying data access code (Query/Mutation/DTO), all referenced columns MUST be verified to exist in the actual DB schema with matching types and constraints before implementation.
-   **Action**:
    1.  **Column Existence**: Before writing `.select('column_name')` or `.not('column', 'is', null)`, verify **column existence** in the `Row` type of the auto-generated type definition file (`database.types.ts`, etc.). "Probably exists" is prohibited.
    2.  **FK Name Verification**: Foreign key names (`user_id`, `owner_id`, etc.) differ per table. Do not assume default names; verify the actual FK name for each table in the type definitions.
    3.  **RPC vs Column Distinction**: RPC functions (e.g., `get_point_balance`) are NOT columns. They cannot be retrieved directly via `.select()`. Implement them correctly as aggregations from source tables or RPC calls.
    4.  **Array Empty Check**: "Existence checks" on array-type columns (`text[]`, `jsonb[]`, etc.) are insufficient with `.not('column', 'is', null)` alone. Add `.neq('column', '{}')` to also exclude empty arrays `{}`.
    5.  **Nullable Parity**: DB `nullable` columns MUST be defined as `optional (?)` or `| null` in TypeScript type definitions. Divergence from auto-generated types is the gateway to "future runtime errors."
-   **Checklist (New Backend Implementation)**:
    | Check Item | Verification Method |
    |---|---|
    | All referenced columns exist in type definition file | Visual check of Row type |
    | RPC functions not treated as columns | Cross-reference with Functions section |
    | FK names match actual table definitions | Check Relationships section |
    | Array column empty checks are correct | Addition of `.neq('column', '{}')` |
    | nullable/optional matches DB definition | Cross-reference with auto-generated types |
-   **Rationale**: Schema-Reality Gaps are the primary cause of "silent bugs" that only manifest in production. By treating the type definition file as the "authoritative source" and eliminating guesswork-based implementation, these bugs are significantly reduced.

### Rule 2.18: The Automated Data Retention Protocol
-   **Law**: Data that accumulates over time MUST have **category-based retention periods** defined, with mechanisms (Cron Job / Scheduled Task) to **automatically purge or anonymize** data after expiration.
-   **Action**:
    1.  **Retention Category Definition**: Classify every dataset by purpose, legal basis, data subject, sensitivity, and recovery need. Legal, privacy, security, and business owners approve retention and deletion conditions. Periods in the table illustrate structure and are not Universal defaults.
        | Category | Example | Example condition to define in Blueprint |
        |---|---|---|
        | Active Data | Users, Content | Indefinite (until account deletion) |
        | Transaction Logs | Payment records | Legal retention period (e.g., 7 years) |
        | Access Logs | Request logs, Traces | 90 days |
        | Session Data | Sessions, Tokens | 30 days |
        | Temporary Data | OTP codes, Upload temp files | 24 hours |
        | Analytics Data | Analytics events | 2 years (aggregate to summary after) |
    2.  **Automated Purge**: Implement batch jobs using `pg_cron` or cloud schedulers to automatically delete/archive data that exceeds retention periods.
    3.  **Account Deletion Lifecycle**: For account closure, legal hold, fraud prevention, contract termination, and DSAR, define de-publication, access revocation, grace periods, and physical deletion/anonymization with deadlines and exceptions.
    4.  **Purge Logging**: Record purge execution details (target tables, deletion count, execution timestamp) in audit logs.
-   **Rationale**: Retaining data indefinitely leads to increased storage costs, expanded privacy risks, and violations of data minimization principles under GDPR/Global Privacy Laws. Automated retention management achieves a triple win of cost, compliance, and performance.

## 3. Integrity & Logic Strategy

### Primary Directive 3.0: The RLS Implementation Iron Rules
-   **Law 1: Atomic Action Definition**
    -   Comma-separated definitions like `FOR INSERT, UPDATE` are prohibited. Unless `FOR ALL`, define **individual policies for each action**.
-   **Law 2: INSERT Syntax Discipline**
    -   `INSERT` policies MUST use **`WITH CHECK`** (not `USING`).
-   **Law 3: Zero Guessing Protocol**
    -   Before creating SQL, MUST read the schema definition file and **point-and-call verify column names**. Implementation by guessing is strictly prohibited.
-   **Law 4: Performance Safety (Scalar Subquery Mandate)**
    -   **Law**: For stable helpers such as `auth.uid()`, use `(select auth.uid())` when official guidance and the execution plan show an InitPlan benefit. Do not wrap every other-table reference in a scalar subquery; preserve correlation, cardinality, indexes, and policy semantics.
    -   **Evidence**: Compare `EXPLAIN`, policy tests, latency, and CPU under representative data and roles, and prove that optimization does not change authorization results.

### Rule 3.0.1: The RLS Helper Functions Registry (RLS Utility)
-   **Helper Isolation**: Re-reading the protected table from its RLS policy can cause infinite recursion (`42P17`). Resolve complex authorization first with `SECURITY INVOKER`, a security-barrier view, claims, or a simpler policy; isolate only the smallest boundary that truly needs owner privileges in a `SECURITY DEFINER` function.
-   **The Qualified Schema Mandate (RPC Security)**:
    -   **Law**: Treat `SECURITY DEFINER` as a privilege boundary and require a safe `search_path`, fully qualified schemas, least `EXECUTE` grants, input validation, and negative tests. When selecting `SET search_path = ''`, fully qualify references including built-ins and test compatibility with adopted extensions.
    -   **Registry Standards**:
        -   Inventory helper name, arguments, return, owner, volatility, security mode, and consuming policies.
        -   `is_admin()` and `is_owner(resource_id)` are examples; do not fix a schema, role, or function name in Universal.
        -   **Requirement**: Helper functions default to `SECURITY INVOKER`. When `SECURITY DEFINER` is selected, review why elevation is required, information that can be returned, callable roles, and RLS bypass scope; require `SET search_path = ''`, fully qualified references, revocation of `EXECUTE` from `PUBLIC`, explicit grants to allowed roles, and negative authorization tests.

### Rule 3.0.2: The Privileged Access RLS Protocol
-   **Context**: Even where operators must correct data, adding a permanent admin bypass to every policy expands compromise and insider-risk blast radius across all data.
-   **Law**: Separate privileged access from normal user paths and minimize resource, action, reason, duration, and environment. Add an admin exception only to policies with a demonstrated business requirement, with default deny, step-up authentication, audit, approval or break-glass, and expiry.
-   **Illustrative Pattern**:
    ```sql
    -- Add only when approved operator updates are required for this resource
    ON public.posts
    FOR UPDATE
    TO authenticated
    USING (
      (user_id = (select auth.uid()) AND ...)  -- General User Condition
      OR
      (select private.can_operate_post((select auth.uid()), id))
    );
    ```
    If the helper uses `SECURITY DEFINER`, apply Rule 3.0.1 and validate tenant, resource, action, and expiry rather than only a role name.

### Rule 3.0.3: The RLS Recipes (Implementation Standards)
-   **Non-Normative Examples**: The following SQL illustrates policy syntax; it does not mandate `profiles`, role names, one hour, or a parent-child schema. Derive actor, tenant, resource, operation, time, revocation, and indexes from the data contract before implementation.
-   **Admin Only Write (Strict Lock)**:
    ```sql
    FOR INSERT WITH CHECK (
      EXISTS (
        SELECT 1 FROM public.profiles
        WHERE id = (select auth.uid()) AND role IN ('admin', 'super_admin')
      )
    );
    ```
-   **User Restricted (Owners - Time Limited)**:
    ```sql
    FOR UPDATE USING (
      user_id = (select auth.uid())      -- Owner Only
      AND created_at > (now() - interval '1 hour') -- Within 1 hour only
    );
    ```

### Rule 3.1: RLS Separation of Duties
-   **Separation Protocol**:
    1.  **Select Policy**: Read permissions managed via `FOR SELECT` only.
    2.  **Write Policy**: Make `USING`/`WITH CHECK` semantics and read-back requirements explicit for `INSERT`, `UPDATE`, and `DELETE`. Use `FOR ALL` only when one condition truly fits every command and negative tests prove it.
-   **Privileged Strictness**: Avoid permanent broad "admin can do anything" policies; scope resource, operation, tenant, and time.

### Rule 3.2: Permissive Policy Consolidation
-   **Semantics First**: Given that multiple `PERMISSIVE` policies combine with `OR` and `RESTRICTIVE` policies add constraints, compare roles, commands, ownership, auditability, and plans. Remove logically duplicate policies, but do not universally merge policies intentionally separated for distinct roles or responsibilities.
-   **Evidence**: Compare effective access with positive, negative, and cross-tenant tests before and after the change; confirm performance gains with representative plans.

### Rule 3.3: Data Integrity Patterns
-   **Lifecycle Choice**: Select hard delete, soft delete, tombstones, anonymization, or legal hold per data category, recovery, audit, privacy deletion, and uniqueness semantics. `deleted_at` plus a partial unique index is a candidate, not a mandate for all primary data.
-   **The Right to be Forgotten (Soft Delete Exception)**:
    -   **Context**: While logical deletion is standard, "Account Deletion Requests" and GDPR/Apple requirements mandate physical deletion or complete anonymization (PII wipe).
    -   **Action**: In withdrawal processing, do not just set `deleted_at`; physically delete or irreversibly mask (`deleted_user_xyz`) PII.
-   **Representation Update**: Where multiple representations exist, define the authoritative representation, derived forms, generation version, atomic update/rebuild, and drift detection.
-   **Structured Migration**: Change JSON through versioned schemas and parsers/migrations; avoid structure-blind string replacement.

### Rule 3.3.1: The CMS Triple Write Protocol (Search Consistency)
-   **Context**: CMS and search may need different authoring, rendering, sorting, and search representations.
-   **Law**: Define one authority and create additional representations as derived data only for measured query or locale needs. Do not force three columns, phonetic keys, or n-grams on every domain.
-   **Synchronization**: Select generated columns, triggers, pipelines, or application transactions according to atomicity, rebuild, versioning, and failure recovery; detect drift.

### Rule 3.3.2: The Multiple Permissive Policies Conflict (Policy Hygiene)
-   **Law**: Because `PERMISSIVE` policies for one command combine with `OR`, review combined effective access rather than each policy alone. Do not classify multiplicity itself as a vulnerability.
-   **Action**: Inventory policies and dependent consumers, then fix only duplicate, shadowed, or over-broad access in the same migration. Never drop first and break legitimate access without proving safety.
-   **Verification**: Use a machine-readable catalog inventory, per-role positive/negative tests, representative plans, and rollback evidence. Do not set a fixed target policy count.

### Rule 3.4: RLS Lifecycle Management Protocol
-   **Create-Verify-Retire**:
    1.  **Before Change**: Inventory policies, roles, grants, bypass identities, and consumers; turn expected effective access into test cases.
    2.  **Apply Safely**: Confirm transactional DDL and lock behavior, then select an expand/contract order that avoids both over-permission windows and legitimate-access outages.
    3.  **After Change**: Check provider advisors, catalog diff, role tests, application flows, and query plans; retire old policies only with evidence that dependencies are gone.
-   **Naming Convention**: Define a versioned Blueprint convention that identifies uniqueness, table, command, and intent. Universal neither bans natural-language names nor fixes one format.
-   **Rollback**: Manage changes and rollback through immutable migrations and resolve policy names from the catalog to avoid changing unintended targets.
-   **Change Checklist**: Record policy identifiers and definitions read from the catalog, expected effective access, dependent consumers, migration order, rollback, and advisor findings as machine-readable evidence. Gate on identifier accuracy and verification outcomes, not input method or policy count.
-   **Strictification Guardrail**: A lenient `PERMISSIVE` policy can prevent a stricter addition from narrowing effective access. Evaluate transactions, locks, availability, and rollback, then replace/drop old policies and create new ones in an order that avoids an over-permission window.

### Rule 3.5: Public Read Protocol (Anti-Vault Paradox)
-   **Principle**: "Security" does not mean dysfunction.
-   **Law**:
    1.  **Public Read**: Publish only explicitly public-classified data after evaluating field minimization, scraping/abuse, cache, rate, and future schema evolution. `USING (true)` is a candidate only with an intentional all-row public contract and negative tests.
    2.  **Strict Write**: Writes (`INSERT/UPDATE/DELETE`) remain strictly locked.
    3.  **Separation**: Test read and write actors, rows, columns, and rates as separate contracts.

---

## 4. Performance & Scalability

### Rule 4.1: Indexing Hygiene Protocol
-   **FK Indexing**: Decide FK indexes from joins, parent updates/deletes, cardinality, write amplification, table size, and query plans. Do not create one for every FK mechanically; design composite or partial indexes from actual queries.
-   **Naming Convention**: Use a project convention that traces uniqueness, table, column/expression, and predicate. `idx_<table>_<column>` is an example.
-   **Lifecycle**: Evaluate usage statistics, plans, write cost, constraint support, seasonal traffic, and standby/replica behavior over a representative window; create, reindex, or delete with online-impact and rollback plans.

### Rule 4.2: Locale-Specific Search Optimization
-   Evaluate locale, tokenization, typo tolerance, ranking, highlighting, update latency, and extension support; select PostgreSQL native FTS, `pg_trgm`, PGroonga, or external search. Do not fix CJK support to one extension.

### Rule 4.3: Scalability Strategy
-   **Bounded Query**: Bound fields, rows, time, scans, and cost for public, untrusted, and collection queries. `select('*')` can be valid for an explicit small contract; select pagination from consistency and consumer UX.
-   **Filter Placement**: Push authoritative filters to the data source where possible. Contract-test that application-side presentation filters do not break page completeness or counts.
-   **Scale Controls**: Select partitions, replicas, archives, caches, and materialization from table/index size, growth, vacuum, locks, plans, RPO/RTO, lag, and cost, not row count alone.
-   **Connection Pooling**:
    -   **Law**: Select direct, transaction-pool, or session-pool connections from runtime concurrency, connection lifetime, prepared statements, transaction/session semantics, and database capacity.
    -   **Action**:
        1.  **Elastic Runtime**: Capacity-test peak instances times per-instance pools and consider a pooler, Data API, or HTTP driver to prevent connection storms.
        2.  **Mode Compatibility**: Test transaction mode against session features, prepared statements, advisory locks, and temporary objects.
        3.  **Headroom**: Reserve capacity-model headroom for applications, migrations, observability, operators, and replication; do not use a fixed 70 percent Universal limit.

### Rule 4.4: The Optimistic Mutation Protocol
-   **Law**: Optimistic UI is a candidate for reversible, low-risk mutations with clear conflict semantics. Do not use a fixed 0.5-second threshold; select skeleton, progress, pessimistic, or optimistic feedback from user research, latency SLOs, failure rates, and accessibility.
-   **Action**:
    1.  **State Model**: Represent pending, confirmed, failed, conflicted, and offline states, preventing duplicate submission.
    2.  **Recovery**: Design rollback, reconciliation, retry, and user-visible errors by domain risk without mandating a specific UI such as toast.
    3.  **High-Risk Action**: Prefer server confirmation, step-up, undo, or compensation for money, deletion, and permission changes.

---

## 5. Auth & Security
-   **Identity Boundary**: Even when Supabase Auth is adopted, define authority and exit for authentication, authorization, profiles, tenant membership, and session revocation.
-   **Notification Architecture**:
    -   **Aggregation**: Aggregate duplicate actions (e.g., multiple likes) to prevent bombing.
    -   **Async Delivery**: Send emails via async job (`pgmq`).
    -   **The Smart Notification Control Protocol (Email Bomb Prevention)**:
        -   **Law**: Delay email notifications via job queue (mins to tens of mins).
        -   **Logic**: Check "if already read in app" before sending; skip if read.
        -   **Outcome**: Prevent "spamming for seen content" and user churn.

### Rule 5.1: The RLS-by-Default Enforcement Protocol (2025 New Standard)
-   **Law**: With the 2025 Supabase update, **RLS is enabled by default** for new tables. Operations MUST be structured around defining policies immediately after table creation.
-   **Action**:
    1.  **Immediate Policy**: Never leave tables without policies after creation. RLS enabled + no policies = **all access denied**. Set at minimum a `TO authenticated` policy even during development.
    2.  **Event Triggers**: Leverage Supabase's **Event Triggers** feature to set up triggers that automatically enable RLS on new table creation. This physically prevents human configuration oversights.
    3.  **Dashboard Alerts**: When **Security Alerts** in the dashboard show "tables without RLS" warnings, address them immediately. This falls under §0.1 (Zero Tolerance Linter Protocol).
    4.  **Exposed Tables**: Tables with RLS enabled but `USING (true)` policies are effectively fully public. Periodically review the **Exposed Tables** labels in the dashboard to audit for unintended exposure.

### Rule 5.2: The Session & Token Management Protocol
-   **Law**: Supabase Auth session and token management MUST be designed with appropriate consideration for security and UX balance.
-   **Action**:
    1.  **Lifecycle**: Use the platform SDK's current refresh contract and test sign-in, refresh, expiry, revocation, sign-out, multi-tab/device, offline, and clock skew.
    2.  **TTL**: Derive access/refresh token lifetime from threat, revocation latency, request volume, and offline UX; revalidate provider defaults and current limits. Do not put fixed 15- or 5-minute values in Universal.
    3.  **Server Validation**: Validate signature, issuer, audience, expiry, and required revocation/freshness at a trusted boundary. Select `getUser()`, verified claims, introspection, or an equivalent from the current SDK contract.
    4.  **Storage**: Evaluate XSS, CSRF, process isolation, keychain/keystore, and rotation separately for browser, SSR, native, and server; use official helpers as candidates and set safe storage/cookie attributes.

---

## 6. Storage & Delivery
-   **Delivery Boundary**: Select provider CDN, Cloudflare or another edge, or direct storage by authorization, cache keys, signed URLs, transformation, egress, purge, and residency.
-   **Bucket Separation**:
    -   **Public**: Store photos, avatars. Maximize CDN cache.
    -   **Private**: Invoices, personal docs. **Signed URL** and strict RLS mandatory.
    -   **Content Classes**: Separate buckets/prefixes/policies by publicity, tenant, retention, malware, and billing; do not fix advertising as a Universal category.
-   **User Upload Hygiene**: Inspect metadata, GPS/EXIF, malware, content type, dimensions, and size with server-trusted validation. Client-side processing alone is not a security boundary.
-   **The Signed Upload URL Mandate (Direct-to-Storage Pattern)**:
    -   **Law**: For large or untrusted uploads, consider direct-to-storage and compare it with an application proxy by authorization, inspection, transformation, egress, timeout, and streaming. Do not prohibit one path universally.
    -   **Flow**:
        1. **Server Action**: Verify auth/permissions, issue **Signed Upload URL**, return to client.
        2. **Client Direct Upload**: Client uploads directly to Storage.
    -   **Outcome**: Reduce app server load and avoid transfer costs/timeouts.

### Rule 6.1: The S3 Compatible Protocol
-   **Law**: Evaluate Supabase Storage's S3-compatible protocol when existing tools, multipart uploads, backups, or portability benefit. Verify identity, RLS, feature, and cost differences from the standard Storage API.
-   **Action**:
    1.  **S3 Client Access**: Access Supabase Storage using AWS SDK (`@aws-sdk/client-s3`) or other S3-compatible clients. Specify the Supabase Storage S3 URL as the `endpoint`.
    2.  **RLS with JWT**: When authenticating via the S3 protocol using a user's JWT token, Storage Schema RLS policies are **automatically applied**. User-scoped access control is possible.
    3.  **Standard S3 Keys**: Standard S3 access keys **bypass RLS** and provide full access to all files. Use server-side only; client exposure is strictly prohibited.
    4.  **Use Case**: Use for multipart uploads (large files), migration from existing S3 tools (aws cli, rclone, etc.), backup scripts, and other cases where the standard Supabase API is insufficient.

### Rule 6.2: The Storage Image Transformations & CDN Protocol
-   **Law**: For image workloads, design responsive variants, modern formats, quality, metadata, cache, authorization, and origin cost; compare Supabase transformations/CDN, build-time processing, and other image services.
-   **Action**:
    1.  **On-the-Fly Resize**: Use `supabase.storage.from('bucket').getPublicUrl('image.png', { transform: { width: 300, height: 200 } })` for server-side resizing. Deliver optimally-sized images for each device to save bandwidth.
    2.  **Format Conversion**: Negotiate WebP, AVIF, JPEG, or another format from content and client support; do not assume a fixed savings percentage.
    3.  **CDN Cache**: Files in Public buckets are automatically cached on the global CDN. Set `Cache-Control` headers appropriately to maximize cache hit rates. Private buckets have lower cache hit rates due to per-user permission checks.
    4.  **File Size Limits**: Set bucket/request limits from use case, plan, memory, inspection, and egress, checking current provider limits at implementation.
    5.  **MIME Type Validation**: Restrict allowed file types with `allowedMimeTypes`. Having `.exe` or `.js` files uploaded to an image bucket is a security incident.

---

## 7. Operations & Migration

### Rule 7.1: The Migration Protocol (Ghost Table Defense)
-   **Migration-first Execution**: Create an immutable migration first with `supabase migration new <name>` or an approved equivalent, then review it, run local reset, validate in preview or staging, and apply it in order from an approved pipeline or CLI. Changing remote state first and reconstructing history later is prohibited.
-   **Migration Timestamp Hygiene**:
    -   **Action**: Use the approved migration tool or ledger inspection to verify the latest version and dependency order, detecting collisions, duplicates, future timestamps, and clock skew. No single shell command is authoritative.
-   **Atomic Migration**: `DROP` and `CREATE` policies in same file.
-   **Ghost Table Defense**:
    -   **Law**: `ALTER` or `CREATE POLICY` on non-existent tables causes errors.
    -   **Action (Schema Preconditions)**: Verify the source schema, dependencies, expected types, and constraints while creating the migration, and fail closed when they do not match. Limit `IF EXISTS` or `DO $$` conditional execution to deliberate compatibility migrations that accept multiple known schema versions; never hide unexpected drift.
    -   **Column-Level Verification (Schema-Reality Reconciliation)**: Before creating migrations and designing DTOs, verify not just table existence but also **column existence, types, and constraints via `information_schema.columns`**. Defining an assumed `example_field` in a DTO when it does not exist is a primary cause of Schema-Reality drift and is prohibited.
-   **Schema Source Reconciliation**: Treat the migration ledger and version-controlled schema as canonical, and use the remote catalog for drift detection and pre-apply verification. Stop on mismatch and resolve it through an approved reconciliation migration.

### Rule 7.2: Connectivity & CI/CD Protocol
-   **Runner Connectivity**: Do not depend on a named CI provider or fixed network assumptions. Verify effective DNS, IPv4 or IPv6, direct or pooler endpoint, transaction mode, TLS, and egress policy. For migrations, dumps, and long transactions that need session semantics, select an approved connection path compatible with current official documentation and effective settings.

### Rule 7.3: Data Seeding & Caching Determinism
-   **Seed Determinism**: Make seeds/fixtures reproducible through business keys, stable generator seeds, or explicit references; define rerun insert/update/delete semantics and production eligibility. Do not require every ID/value to be fixed.
-   **Cache Coherence**: Select cache keys, tags, event invalidation, TTL, version stamps, or bypass for schema/data changes; do not fix one framework helper or suffix.
-   **Verification**: After seeding, verify expected entities, constraints, relationships, and authorization through queries/application contracts; CLI status alone is not evidence of data existence.

### Rule 7.4: Migration Idempotency Protocol
-   **Mandate**: Apply schema migrations exactly once in order using a ledger and checksums, and never edit applied files. Make only retryable seeds/backfills idempotent; do not hide unexpected drift with `IF NOT EXISTS`.
-   **Implementation**: Verify expected source/target schemas, transaction boundaries, forward-fix after partial failure, clean rebuild, and supported upgrade paths.

### Rule 7.5: Cache Reload Protocol
-   **Mandate**: Inventory schema consumers and verify refresh/compatibility for generated contracts, ORM metadata, PostgREST schema cache, prepared statements, connection pools, and running revisions. Regenerate, reload, or rolling-restart only affected consumers; never require a universal production restart.

### Rule 7.6: Controlled Remote Change Policy (History Protection)
-   **Law**: Do not use Dashboard SQL Editor or another remote console as the normal schema or data change path. The standard path is a version-controlled, reviewed, tested, approved, and audited migration or operation.
-   **Break-glass**:
    1. Allow the smallest remote change only during a production incident when the standard path cannot meet RTO, recording target, operator, approver, reason, query, timestamp, backup or rollback, and impact.
    2. Within the same incident window, reconcile the migration ledger, schema, runbook, and evidence, then complete drift checks and post-incident review.
    3. Even ad-hoc reads use a read-only role and safe query budget that satisfy PII, load, locking, and audit requirements.

### Rule 7.7: The Expand-Contract Migration Protocol (Zero Downtime Schema Changes)
-   **Law**: For destructive changes with live consumers and deploy skew, use expand-contract or an equivalent backward-compatible migration staged to the availability target, lock budget, data volume, and rollback.
-   **Action**:
    1.  **Expand**: Add the new schema/index/compatibility layer while old consumers work; preflight locks, rewrites, and replication impact.
    2.  **Migrate**: Run bounded checkpointed backfill and reconciliation. Prohibit best-effort dual writes; use them only when transactions, triggers, outbox, CDC, or an equivalent proves ordering, idempotency, and partial-failure recovery.
    3.  **Contract**: Retire old structures only after telemetry, consumer inventory, query logs, generated contracts, and rollback windows meet exit criteria. Do not use a fixed one-week wait or one `grep` as evidence.
-   **Exception**: An isolated or small system may use direct migration with approved downtime when backup, restore testing, and availability targets allow it.

### Rule 7.8: The Data-Aware Defense Protocol
-   **Law**: Preflight actual distributions, duplicates, NULLs, invalid values, volume, locks, and concurrent writes; test both clean rebuild and production-like upgrade. Do not force one conflict treatment on all DML.
-   **Action**:
    1.  **Precondition Query**: Measure counts, samples, and constraint candidates read-only and stop beyond approved thresholds.
    2.  **Intentional Conflict Semantics**: Choose fail, ignore, merge, or upsert for each insert/update from the business contract; do not hide errors behind `ON CONFLICT`.
    3.  **Constraint Rollout**: Select duplicate remediation, quarantine, `NOT VALID`/validate, or online indexes by data loss, locks, and rollback; do not universally embed cleanup in one file.

### Rule 7.9: The Migration Static Analysis Guard
-   **Law**: Automatically analyze migration risk in CI and classify changes for blocking, manual review, or timed execution. A local hook is fast-feedback; the enforceable remote gate is authoritative.
-   **Action**:
    1.  **Detection**: Detect destructive DDL, table rewrites, unbounded DML, long locks, non-concurrent indexes, volatile defaults, permission widening, and missing rollback/preconditions with an AST or reviewable heuristics.
    2.  **False Positive Safety**: Do not reject `UPDATE`, `INSERT`, or constraints from syntax alone; evaluate expected rows, WHERE, conflict semantics, preflight, and maintenance windows.
    3.  **Exception**: A bypass requires reason, approver, owner, expiry, execution window, and post-check; an implicit `--no-verify` never bypasses the remote gate.

---

## 8. Maintenance & Hardening

### Rule 8.1: Security Hardening (The Fortress)
-   **Public Schema Guard**: Minimize schema `CREATE`/`USAGE`/object privileges from a role matrix and test provider-managed defaults plus migration roles. `REVOKE CREATE ON SCHEMA public FROM PUBLIC` is a candidate.
-   **View Security**: Make invoker/definer semantics, underlying RLS, column exposure, and owner explicit per view.
-   **Search Path Defense**: Give `SECURITY DEFINER` a safe `search_path`, fully qualified references, least grants, owner, and negative tests. An empty path is a candidate whose built-in and extension resolution must be tested.

### Rule 8.2: The Audit Log Mandate / WORM
-   Record privileged data/schema changes with actor, reason, before/after reference, result, and trace in tamper-evident audit. Select a DB table, external immutable sink, ledger, or equivalent from threat and retention; neither a fixed table name nor RLS alone proves WORM.

### Rule 8.3: The Comprehensive RLS Audit
-   **Cascading Verification**: Test actual actors, anonymous, authenticated, cross-tenant, and privileged paths from the capability matrix.
-   **Risk-Based Audit**: Audit on change and at a cadence based on data sensitivity, team, and incidents. Monthly is a candidate:
    - [ ] Policy exists for all actions?
    - [ ] Required privileged access works at minimum scope without widening normal-user access?
    - [ ] General users restricted to own data?
    - [ ] Plan warnings for row-invariant helpers triaged with identical authorization results before and after optimization?

### Rule 8.4: RLS Post-Change Verification Protocol
-   **Verification Scope**:
    1.  **Security Advisor**: Resolve or time-bound every finding by risk; a zero count alone does not prove safety.
    2.  **Functional Test**: Verify capability-matrix actors, operations, tenants, and row/column scopes.
    3.  **Performance**: Inspect plans safely and assess data volume plus latency/cost rather than treating a sequential scan itself as failure.
-   **Emergency Recovery**: Use a tested rollback or narrow break-glass policy; never recover availability by opening an affected table with `USING (true)`.

---

## 9. Domain Data Modeling

### Rule 9.1: Universal Settings & Tenant-Aware Naming
-   **Representation**: Select normalized columns, typed JSON, related tables, or a configuration service from queries, constraints, partial updates, schema evolution, tenant overrides, and audit. Do not universally prohibit typed JSONB.
-   **Tenant-Aware Boundary**:
    -   **Law**: Where multi-tenancy is required, contract tenant identity, scope, inheritance, overrides, uniqueness, RLS, billing, and deletion. Do not tenant-enable every schema for a speculative future.
    -   **Naming**: `site_`, `account_`, and `system_` are examples; define a Blueprint convention that identifies resource type, scope, and owner.

### Rule 9.2: Static Page Ban (CMS Sovereignty)
-   Select legal/policy content management that satisfies owner, review, version, effective date, locale, approval, retention, rollback, and availability. Versioned static content, CMS, and document systems are candidates; do not mandate runtime CMS dependency.

### Rule 9.3: Structural Integrity Protocols
-   **Classification**: Select tags, enums, relations, or taxonomies from cardinality, governance, localization, and queries.
-   **Temporal Rules**: Only domains needing business hours or similar schedules contract time zones, holidays, exceptions, recurrence, and source authority.
-   **Scoring**: Where reputation/ranking exists, assess sample bias, gaming, uncertainty, and explainability; select simple mean, Bayesian, Wilson, or another method from data.
-   **Geospatial**: Add coordinates/geometry, precision, source, consent, and retention only to entities that require location functionality.

### Rule 9.5: The Geolocation Data Strategy
-   **Law**: Select geocoding sources by accuracy, license, privacy, freshness, coverage, latency, cost, rate, and exit. Compare manual entry, trusted sources, provider APIs, and batch datasets; do not always prioritize free methods over quality or terms.
-   **Action**:
    1.  **Source Provenance**: Record coordinate, precision, source, acquisition time, license, confidence, and manual override; verify URL scraping against provider terms and format stability.
    2.  **Caching**: Cache/persist only where address normalization, retention, provider terms, freshness, and correction are defined.
    3.  **Distance & Display**: Select geography/PostGIS, Haversine, provider search, or another method by required accuracy; decide units and rounding by locale/UX.
    4.  **Spatial Index**: Select GiST, SP-GiST, or another index appropriate to geometry and query operators by plan. Do not universally recommend GIN on latitude/longitude.

### Rule 9.4: The Time-Gated Content Schema Standard
-   **Law**: A scheduled-publication domain contracts its state machine, effective interval, time zone, embargo, unpublish, preview, clock, and authorization. Do not fix column names or NULL meaning in Universal.
-   **Action**:
    1.  **Illustrative Schema**: `status` and `published_at` are candidates; explicitly define whether NULL means immediate, unscheduled, or unset.
    2.  **Authorization Predicate**: Public queries evaluate state and effective time together, with preview/operator paths separated. This is an example:
        ```sql
        WHERE status = 'public'
          AND (published_at IS NULL OR published_at <= NOW())
        ```
    3.  **Indexing & Test**: Design indexes from actual predicates, sort, tenant, and partial conditions; test boundary times, time zones, drafts, scheduled, and expired content.

---

## 10. Universal Portability
-   **Ecosystem Portability**: Data is a "Digital Asset". Adopt industry standard schemas and metadata for ecosystem compatibility.

---

## 11. Backend Governance

### Rule 11.1: The Data Residency Protocol (Rule 26.1)
-   **Law**: PII and legal docs must physically reside in specified regions (e.g., Japan) per GDPR/Global Privacy Laws.
-   **Action**: Design Multi-region Read/Local Write architectures considering future Data Localization requirements.

### Rule 11.2: The Audit Bypass Anti-Pattern (Server Action Mandate)
-   **Law**: Every write path must pass risk-appropriate authentication, authorization, validation, abuse controls, and audit. Server Actions, APIs, and database policies/triggers are implementation options; no single framework is universally mandated.
-   **Action**:
    1.  **Trusted Boundary**: Concentrate privileged, PII, financial, authorization-changing, or multi-entity writes in a server-side command boundary or transactional database function, with actor and decision audit.
    2.  **Direct Client Writes**: Low-risk operations expressible safely through RLS and schema validation may use direct client writes after negative tests, rate limits, idempotency, and required audit are proven.

### Rule 11.3: The RLS Best Practices Protocol (Policy Hygiene)
-   **Law 1: No Redundant Bypass Policy**: A request connected with a `service_role` credential bypasses RLS, so never mistake a `TO service_role` policy for an authorization control. Select the least-privileged method for admin/system access from user-scoped RLS, constrained RPC, dedicated roles, or a service boundary.
-   **Law 2: Explicit Policy Semantics**: Multiple `PERMISSIVE` policies combine with `OR`, while `RESTRICTIVE` policies add constraints. Do not mechanically consolidate to one policy; test role, command, intent, and combined outcomes, removing only redundancy or over-granting.
-   **Law 3: Explicit Public Write**: `WITH CHECK (true)` permits all rows for the targeted role. Do not use it unless an intentional public-ingestion path proves rate, validation, abuse, quota, PII, and audit controls. Ownership or admin roles are not the only valid model.

### Rule 11.4: The Poison Row Prevention Protocol (Type Collapse Prevention)
-   **Context**: Manual extension of generated database contracts can corrupt read, create, update, nullability, and runtime-validation semantics.
-   **Law**: Keep generator output reproducible as authority and separate domain types through adapters. Do not universally ban syntax such as `never`, intersections, or inheritance; prove safety with type tests for valid read/insert/update operations plus runtime contract tests.
-   **Action**:
    1.  **Generated Sovereignty**: Never hand-edit generated files; track schema revision and generator version.
    2.  **Operation Parity**: Test row, insert, update, and function results separately and avoid accidentally making write types uninhabitable.
    3.  **Language Neutrality**: In languages other than TypeScript, provide equivalent compiler/schema tests and representative SDK operations.

### Rule 11.5: The Idempotent Migration Protocol
-   **Context**: Test migrations against both clean rebuild and upgrade paths with existing data.
-   **Law**: Apply schema migrations once in order, verify the migration ledger, and keep them immutable after shared application. Universal re-runnability of all DDL is not required.
-   **Action**:
    -   **Fail Loudly**: Do not hide unexpected drift behind `IF NOT EXISTS` or `DROP IF EXISTS`; assert explicit preconditions and postconditions.
    -   **Retry-Safe Data Work**: Make only retryable backfills, seeds, and online batches idempotent through business keys, checkpoints, or `ON CONFLICT` semantics.
    -   **Recovery**: Define transaction support, partial-failure behavior, resume/forward-fix, backup/restore, and rollback per migration.

### Rule 11.6: The Admin/System Write Identity Protocol
-   **Law**: Select the least-privilege identity for each administrator operation and system job. Human administrators normally retain a verified user identity and pass RLS/RBAC; do not make an RLS-bypass credential such as `service_role` the default for all administration.
-   **Reason**: A broad bypass credential turns one implementation flaw into access across all data and weakens actor attribution. Session propagation failures signal a broken identity boundary, not justification for universal bypass.
-   **Action**:
    1.  **Human Admin**: Preserve MFA, short-lived sessions, role/tenant scope, RLS, and step-up authorization.
    2.  **System Job**: Prefer workload identity, a dedicated database role, or a constrained RPC scoped to the job. If bypass credentials are unavoidable, require server-side secrets, network restrictions, rotation, audit, and a narrow code path.
    3.  **Authorization Test**: Prove read and write scopes separately through positive, negative, and cross-tenant tests plus actor-aware audit.

### Rule 11.7: The Silent RLS Failure Detection Protocol
-   **Law**: Mutation responses vary by SDK, request options, policy, and target-row existence. Validate success against the business contract; do not infer an RLS denial from a zero-row or empty response alone.
-   **Action**:
    1.  **Contract Check**: For exactly-one updates, verify an affected row or returned identifier; distinguish valid zero-row contracts such as zero-or-one deletes.
    2.  **Diagnostic**: On zero results, distinguish not-found, concurrent change, filter mismatch, and authorization denial through a non-disclosing error contract.
    3.  **Safe Logging**: Log operation, resource class, request/trace ID, and result classification without unnecessary PII or raw credentials.
-   **Diagnostic**: "Save succeeded but data reverts on reload" → **Suspect Silent RLS Failure**.

### Rule 11.8: The RPC Scope Limitation Protocol
-   **Law**: Place logic in RPCs, application services, or queues/workflows according to atomicity, data locality, latency, portability, failure recovery, security boundaries, and operational capability. Do not prohibit database logic based on complexity alone; avoid hiding external I/O in database transactions and avoid untestable monolithic RPCs.
-   **Action**:
    1.  **Database Candidate**: Set-based work, authorization near constraints, and multi-table updates in one transaction are RPC candidates with explicit input/output, privilege, timeout, lock, and tests.
    2.  **Service Candidate**: External I/O, long-running workflows, human approval, and retry orchestration belong in a language-neutral application/workflow boundary, with an outbox or equivalent preserving consistency with the database commit.
    3.  **Operability**: Give the selected boundary a type or schema contract, traces, load tests, versioning, owner, and rollback.
-   **Rationale**: Place responsibilities by evidence about consistency and failure boundaries, not by a specific framework or language.

### Rule 11.9: The Ghost Migration Ban
-   **Law**: DB operations not captured in migration files (manual column additions/changes/deletions, schema changes via Dashboard, etc.) are defined as **"Ghost Migrations" and are strictly prohibited**.
-   **Action**:
    1.  **Migration File Mandate**: All schema changes MUST go through an approved migration tool and be stored as immutable, version-controlled migration artifacts.
    2.  **No Dashboard Edits**: Direct schema changes through database consoles are prohibited during normal operations. For emergency break-glass use, record actor, approval, query, and result, then immediately reconcile the migration ledger and version-controlled artifacts.
    3.  **Schema Consistency Protocol**: When the local environment's schema diverges (becomes contaminated) from migration files, do NOT hesitate to rebuild the DB (`supabase db reset`, etc.). Always treat migration files as the Source of Truth, with the local DB as subordinate.
    4.  **Verification**: After applying migrations, verify that the diff between local and remote schemas is zero. If differences exist, suspect the presence of Ghost Migrations.
-   **Rationale**: Changes not recorded in migration files cause non-reproducibility across teams, CI/CD failures, and inconsistencies with the production environment. The principle that "all changes are recorded" is the foundation of schema reliability.

## 12. Migrations & Privileged Operations

### Rule 12.1: The Admin Write Service Role Protocol
-   **Law**: Admin panels and background jobs follow the Rule 11.6 identity matrix, selecting the narrowest user-scoped, job-scoped, or privileged identity. A Service Role Key is an exceptional break-glass/system boundary, not a universal administrator default.
-   **Action**:
    1.  **Human Path**: Preserve user identity, MFA, RBAC/RLS, and tenant scope.
    2.  **Machine Path**: Use workload identity or a dedicated role scoped to required tables and operations.
    3.  **Bypass Guard**: Never expose bypass secrets to clients; manage usage sites, owner, rotation, audit, and incident revocation.
    4.  **Audit Trail**: Record actor, reason, scope, and result in tamper-resistant audit evidence.

### Rule 12.2: The Idempotent Migration Protocol
-   **Law**: Verify exactly-once schema migration application through a ledger and checksums, then keep files immutable after shared application. Make only retryable data operations explicitly idempotent.
-   **Action**:
    1.  **Pre/Postconditions**: Assert the expected source and target schemas; fail closed on an unexpected state.
    2.  **Atomicity**: Identify transactional DDL boundaries; design checkpoints and resume/forward-fix for non-transactional operations.
    3.  **Data Operations**: Make backfills and seeds retry-safe through business keys, upsert policy, batch checkpoints, and reconciliation.
    4.  **Clean and Upgrade Tests**: Test both complete history on an empty database and upgrades from supported prior states.

### Rule 12.3: The Permissive Policy Semantics Protocol
-   **Law**: Remove logically redundant `PERMISSIVE` policies for the same role/command, but do not make policy count itself a security target. Treat `service_role` credential bypass and policies for normal roles as separate boundaries.
-   **Action**:
    1.  **Combined Access**: Inventory all policies and grants by table, role, and command; test the combined `PERMISSIVE` OR and `RESTRICTIVE` AND outcome.
    2.  **Consolidation Decision**: Consolidate when there is duplication, over-granting, or measured overhead. Separation that clarifies distinct owners, roles, or lifecycles is valid.
    3.  **Bypass Inventory**: Govern bypass credential/role paths outside policy through least privilege, secrets, network, audit, and rotation.

### Rule 12.3.1: The RLS Auth Function InitPlan Optimization
-   **Law**: InitPlan row-invariant auth/session helpers with a scalar subquery when official guidance, volatility, and the query plan support it. Do not mechanically apply this to correlated expressions, row-dependent helpers, or set-returning functions.
-   **Action**:
    1.  **Candidate**: `user_id = (select auth.uid())` is a candidate for a row-invariant helper.
    2.  **Semantics**: Preserve correlation, cardinality, NULL behavior, and index use in `EXISTS`, joins, and tenant lookups.
    3.  **Evidence**: Compare authorization tests and `EXPLAIN (ANALYZE, BUFFERS)` or a safe equivalent under representative roles and data.
-   **Illustration**:
    ```sql
    -- Before measurement
    USING (user_id = auth.uid())
    -- Candidate after semantic and plan verification
    USING (user_id = (select auth.uid()))
    ```

### Rule 12.4: The Type Extension Safety Protocol
-   **Law**: Keep generated schema/SDK contracts reproducible and unmodified, and version domain extensions in separate adapters. Select a method appropriate to each language's type system and detect drift through runtime schema and operation tests.
-   **Action**:
    1.  **Uninhabitable Type Check**: Compile-test that constructs such as `never` do not make valid operations impossible.
    2.  **Composition Choice**: Select aliases, interfaces, intersections, mapped types, classes, or code generation from toolchain fit and readability.
    3.  **Contract Coverage**: Test representative read, insert, update, RPC, nullable, JSON, decimal, and timestamp cases.

### Rule 12.5: The Migration System Schema Exclusion Protocol
-   **Law**: When creating scripts that batch-modify function security settings (`search_path`, `SECURITY DEFINER/INVOKER`, etc.) in database migrations, **functions in system schemas managed by the hosting service must be included in the exclusion list**.
-   **Action**:
    1.  **Exclusion List**: Explicitly exclude functions from system schemas such as `auth`, `storage`, `realtime`, `supabase_functions`, `graphql`, `graphql_public`, `pgsodium`, `vault`, and `extensions` from batch changes.
    2.  **Schema Filter**: Use `n.nspname NOT IN ('auth', 'storage', ...)` in the `WHERE` clause of migration scripts to physically prevent interference with system schema functions.
    3.  **Dry Run**: Before applying batch-change migrations, preview the list of targeted functions (execute `SELECT` only) and verify that no system functions are included.
-   **Rationale**: Modifying the `search_path` or security settings of managed service system functions (authentication, storage management, etc.) can destroy the service's foundational capabilities. This is a fatal failure that immediately leads to complete service outage.

### Rule 12.6: The RLS InitPlan Optimization Protocol
-   **Law**: Rule 12.3.1 is authoritative. InitPlan an RLS helper only when row invariance, planner behavior, official guidance, and measurement align; do not apply it universally to every session function.
-   **Action**:
    1.  Triage a linter warning as a finding and inspect query semantics plus plans.
    2.  Verify identical positive, negative, and cross-tenant results before and after optimization.
    3.  Do not promise a fixed row threshold or orders-of-magnitude gain in Universal; decide from latency, CPU, and buffers on actual data.

### Rule 12.7: The Client Identity Audit Protocol
-   **Law**: Before optimizing RLS policies (consolidation or deletion), **comprehensively audit which IDENTITY** (`service_role` / User JWT / Anonymous) is used by **all access paths** (Server Actions, API Routes, SSR, admin panels, etc.) that access the target data.
-   **Action**:
    1.  **Access Path Inventory**: List all code paths (Service layer, Gateway layer, Server Actions, etc.) that access the target table and identify the client initialization function (`createClient`, `createAdminClient`, etc.) used by each.
    2.  **No Blind Optimization**: Do not delete user JWT policies because "service_role is sufficient." If Server Actions use user JWT, deleting those policies silently blocks legitimate access.
    3.  **Identity Matrix**: For complex tables, create a "table × operation × identity" matrix and verify that all access patterns are covered by at least one RLS policy.
    4.  **Post-Change Verification**: After modifying or deleting policies, actually operate all affected UI flows (admin panel edit/save, user-facing browse, etc.) to verify functionality.
-   **Rationale**: Careless deletion through RLS policy "optimization" invites not security holes but "invisibility of legitimate access." Especially when admin panels use Server Actions (user JWT context), deleting JWT policies thinking service_role is sufficient silently rejects administrators' CRUD operations.

### Rule 2.8: The Idempotent Migration Protocol
-   **Law**: Migration safety comes from ordered exactly-once application, immutability of applied files, explicit preconditions, and retry-safe data steps—not universal re-execution of all DDL.
-   **Action**:
    1.  **DDL Drift Detection**: Limit `IF NOT EXISTS` to expected states and separately assert object-definition equality.
    2.  **DML Retry Safety**: Give seeds/backfills intentional conflict semantics, checkpoints, and reconciliation.
    3.  **Object Replacement Safety**: Validate dependencies, permissions, availability, and transaction boundaries before replace or drop-create operations on functions, triggers, and policies.
    4.  **History Integrity**: Make the migration ledger, checksums, clean rebuild, and upgrade tests CI evidence.

### Rule 2.9: The Read-Write Privilege Symmetry
-   **Law**: Each read/write path holds the least privilege required for its actor, resource, and operation while preserving fields and rows required by the product contract. Do not elevate reads to the same broad privilege merely because writes use a bypass identity.
-   **Action**:
    1.  **Capability Matrix**: For each screen, job, and API, map read fields, write fields, row scope, and actor identity; test for both missing and excessive privilege.
    2.  **DTO Synchronization**: Test intended differences between edit DTO and mutation schema as a versioned contract. Never expose secret/internal fields on reads merely to match write authority.
    3.  **Scoped Admin Gateway**: Express administration through resource- and operation-scoped gateways or RPCs, avoiding whole-table RLS bypass or broad policy opening.
    4.  **Post-Update Verification**: For important mutations, read back version, identifier, or expected fields through the authorized view and trace consistency without logging PII.
-   **Rationale**: Missing read-back capability can look like an opaque save failure, but universal privilege symmetry is not the remedy. Prove consistency through a least-privilege capability contract and explicit verification.

### Rule 2.10: The RLS Policy Composition Protocol
-   **Law**: Optimize policy composition for effective authorization, ownership, readability, auditability, and performance together. One policy is not a Universal objective.
-   **Action**:
    1.  **Consolidation by Evidence**: Treat duplicate conditions for the same role/command/intent as candidates; never broaden distinct roles or owners into `USING (true)`.
    2.  **Service Role Redundancy Elimination**: Since `service_role` completely bypasses RLS, explicit policies targeting `service_role` are redundant. Delete policies that target only `service_role`.
    3.  **RESTRICTIVE Policy Awareness**: `RESTRICTIVE` policies are evaluated as **AND conditions** against all `PERMISSIVE` policies, so only `PERMISSIVE` policies are consolidation targets. Consolidating `RESTRICTIVE` policies may cause side effects.
    4.  **New Table Checklist**: Record intent and test owner by actor/role/command/combined outcome, and document why multiple policies are separated.

### Rule 2.11: The Orphan File Defense Protocol
-   **Law**: Define a lifecycle contract between database records and objects to prevent unowned objects, unintended retention, and premature deletion.
-   **Action**:
    1.  **Deletion Workflow**: Select synchronous deletion, queue, outbox, or storage lifecycle rules from consistency, latency, retry, restore, and legal hold.
    2.  **Reconciliation**: Compare references and object inventory at a risk-based cadence, deleting only after quarantine, grace period, and dry run. Weekly is not fixed.
    3.  **Restore Semantics**: When using soft delete/archive, align object retention with record restore windows.

### Rule 2.12: The Safety Valve Protocol
-   **Law**: Add a free-text field only to entities with an explicit business or operational need. Do not mandate precautionary notes on every table; design PII, access, retention, search, moderation, and export.
-   **Action**:
    1.  **Typed Promotion**: Promote recurring decisions, filters, or authorization inputs to versioned typed fields.
    2.  **Bounds**: Validate length, format, rendering, malicious content, and sensitive data.
    3.  **Nullability**: Derive required/optional semantics from domain invariants.

### Rule 2.13: The Time-Series Partitioning & Retention Protocol
-   **Law**: Observe time-series growth, query predicates, vacuum, indexes, backup, retention, and delete cost; partition only when benefits exceed operational complexity.
-   **Action**:
    1.  **Partition Key & Interval**: Select range/hash/list, keys, and intervals from actual queries and distribution; do not fix `created_at`, monthly, `pg_partman`, or 10M.
    2.  **Lifecycle**: Test create-ahead, default partitions, retention, detach/archive, indexes, FKs, replication, and restore.
    3.  **Decision Evidence**: Compare non-partitioned baseline and prototype by plans, latency, maintenance duration, and cost.

### Rule 2.14: The Cold Data Offloading Protocol
-   **Law**: Select active, archive, object, or warehouse storage from data temperature, retention, retrieval SLO, legal hold, deletion, format longevity, and cost. One year is not a fixed boundary.
-   **Action**:
    1.  **Contract**: Define archive owner, schema/format version, encryption, access, index/catalog, retrieval, restore tests, and deletion propagation.
    2.  **Cutover**: Validate consumer contracts, backfill checkpoints, checksums, late-arriving data, and rollback.
    3.  **Compliance**: Derive retention from jurisdiction, record class, legal advice, and policy; do not treat example years as Universal legal judgment.

### Rule 2.15: The RLS Inheritance Protocol (Chain of Trust)
-   **Law**: Make authorization sources explicit from domain ownership, membership, delegation, and resource relations. Compare parent inheritance, direct owners, capability tables, claims, and policy services; do not universally trace every child to the top parent.
-   **Action**:
    1.  **Consistency**: If a denormalized owner/tenant key is used, prevent drift with an FK, trigger, generated value, or write boundary.
    2.  **Performance**: Compare `EXISTS`, joins, helpers, and claims with positive/negative/cross-tenant tests and plans.
    3.  **Privilege**: Express cross-table checks with invoker semantics first; use `SECURITY DEFINER` only at the smallest boundary that truly needs elevation.

### Rule 2.16: The Brittle Table Reference Prohibition
-   **Law**: Limit dynamic SQL to metadata-driven operations not expressible statically and require identifier quoting, allowlists, parameter binding, least privilege, tests, and audit.
-   **Action**:
    1.  **Static Default**: Use static SQL for known objects so migrations detect dependencies.
    2.  **Safe Dynamic Identifier**: Value parameters do not protect identifiers; use a server-controlled allowlist and correct identifier quoting such as `format('%I', identifier)`.
    3.  **Impact Inventory**: Register dynamic dependencies for testing before renames or drops.

### Rule 2.17.1: The Data Quality Management Framework
-   **Law**: Manage applicable dimensions such as accuracy, completeness, consistency, freshness, uniqueness, and conformity with owners according to material data-product consumers and risk. Do not treat every datum as a revenue asset; privacy minimization and deletion take precedence.
-   **DQ Framework**:

    | Quality Dimension | Definition | Measurement Method | Target |
    |:------------------|:-----------|:-------------------|:-------|
    | **Accuracy** | Does data reflect reality? | Source reconciliation/sampling | Blueprint target |
    | **Completeness** | Are contract-required fields populated? | NULL/missing rate | Blueprint target |
    | **Consistency** | Are entities/sources non-contradictory? | Constraint/cross-source checks | Blueprint target |
    | **Freshness** | Is data updated within consumer SLO? | Event/load age | Blueprint target |
    | **Uniqueness** | Are business keys non-duplicated? | Duplicate query | Blueprint target |
    | **Conformity** | Does data match schema/format contracts? | Validation | Blueprint target |

-   **Action**:
    1.  **Automated DQ Checks**: Measure at a cadence based on freshness and impact, exposing results to consumers and owners.
    2.  **Asset Registry**: Record owner, consumers, classification, quality SLO, lineage, and retention for material datasets.
    3.  **Quarantine & Repair**: Do not blindly delete invalid data; contract rejection, quarantine, repair, backfill, and consumer notification.
    4.  **Response**: A threshold violation has severity, owner, error budget, due date, and waiver. Do not apply a fixed 30 days to every domain.

---

## 13. Edge Functions Design Strategy

### Rule 13.1: The Edge Functions Architecture Protocol
-   **Law**: Check current runtime limits for duration, memory, CPU, region, network, concurrency, background work, dependencies, observability, and cost; place only fitting HTTP, webhook, orchestration, or equivalent workloads.
-   **Action**:
    1.  **Cohesion**: Group responsibilities that share ownership, deployment, rollback, dependencies, and blast radius; do not force exactly one task per function.
    2.  **State**: Do not use local mutable state as durable authority; place it in a database, queue, object store, or equivalent. Instance caches never carry correctness.
    3.  **Runtime Limit**: Revalidate current plan/region/runtime limits and cancellation at deployment; move exceeding workloads to jobs, queues, workers, or database operations.
    4.  **Startup & Supply Chain**: Measure dependency graph, artifact size, remote imports, lock/integrity, and cold start; make immutable resolved dependencies build evidence.
    5.  **Nested Call Budget**: Inventory direct recursion, function chaining, circular calls, and fan-out as one request chain. A hosted runtime may apply a shared limit across that chain, so revalidate the effective quota and 429 behavior at deployment and avoid unbounded recursion. Move long-running or high-fan-out work to queues, durable workflows, bounded orchestrators, or equivalents, and design timeouts, retries and backoff, idempotency, cost ceilings, and cycle detection.

### Rule 13.2: The Edge Functions Security Mandate
-   **Law**: Layer caller identity, authorization, input, abuse, network/egress, secrets, data access, and audit according to the endpoint threat model.
-   **Action**:
    1.  **Caller Verification**: Select user JWT, webhook signature, mTLS/workload identity, public anonymous, or another model from the endpoint contract. For JWT, verify claims and authorization at a trusted boundary.
    2.  **CORS Configuration**: For browser access, design origins, methods, headers, credentials, preflight, and caching. `*` can be valid for intentional public resources without credentials; do not decide solely by environment name.
        ```typescript
        // ✅ CORS Configuration Template
        const corsHeaders = {
          'Access-Control-Allow-Origin': Deno.env.get('ALLOWED_ORIGIN') ?? '',
          'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
          'Access-Control-Allow-Methods': 'POST, OPTIONS',
        };
        // Respond to OPTIONS preflight
        if (req.method === 'OPTIONS') {
          return new Response('ok', { headers: corsHeaders });
        }
        ```
    3.  **Secret Management**: Retrieve secrets through runtime bindings from an approved store; never expose them in source, logs, or responses. `supabase secrets set` is a candidate command for managed projects.
    4.  **JWT Verification Setting**: An endpoint that disables provider JWT verification must prove alternate authentication such as webhook signatures, or an intentional public contract, plus rate/abuse controls, negative tests, and ownership. A flag or environment name alone does not determine safety.

### Rule 13.3: The Edge Functions Error Handling & Observability
-   **Law**: Edge Functions errors MUST be recorded in a structured format, and appropriate HTTP status codes MUST be returned to callers.
-   **Action**:
    1.  **Structured Error Response**: On error, return an HTTP status code + JSON error body.
        ```typescript
        return new Response(
          JSON.stringify({ error: 'Invalid input', details: '...' }),
          { status: 400, headers: { 'Content-Type': 'application/json', ...corsHeaders } }
        );
        ```
    2.  **Logging**: Confirm provider routing and record machine-queryable events, trace/request IDs, severity, and result. Never log PII, tokens, or raw payloads, and avoid double-encoded JSON.
    3.  **Retry Safety**: Make only retryable mutations and external side effects idempotent or duplicate-safe; never confuse a request ID with a stable idempotency key.

### Rule 13.4: The Edge Functions Local Development Protocol
-   **Law**: Use reproducible tests in local, isolated-project, or preview environments, and do not make direct production debugging the normal path. Cover emulation gaps with deployed integration tests.
-   **Action**:
    1.  **Local Serve**: `supabase functions serve` is a managed-CLI candidate; record current runtime, environment, network, and auth differences.
    2.  **Shared Code**: Select shared packages, workspaces, or provider-recommended directories by ownership and versioning; do not depend on one fixed path.
    3.  **Dependencies**: Use a supported manifest/lock/integrity mechanism to resolve direct and transitive versions reproducibly.

---

## 14. Realtime Design Strategy

### Rule 14.1: The Realtime Channel Architecture
-   **Law**: Supabase Realtime's three features (**Postgres Changes**, **Broadcast**, **Presence**) MUST be used appropriately, and channel design MUST consider scalability and security.
-   **Action**:
    1.  **Postgres Changes**: Use for real-time subscription to table INSERT/UPDATE/DELETE events. RLS policies are automatically applied, so users receive only rows they have read permission for.
        -   **Publication Setup**: Add monitored tables to the `supabase_realtime` publication (`ALTER PUBLICATION supabase_realtime ADD TABLE public.messages;`).
        -   **Filtering**: Specify filters like `.on('postgres_changes', { event: 'INSERT', schema: 'public', table: 'messages', filter: 'room_id=eq.xxx' })` to eliminate unnecessary event reception.
    2.  **Broadcast**: Use for low-latency client-to-client communication without server involvement (cursor position sharing, typing indicators, etc.). Not stored in DB; only connected clients receive messages.
    3.  **Presence**: Use for tracking online status ("who is in this room"). Synchronizes each client's state (display name, avatar, etc.).
-   **Anti-pattern**: Using Broadcast for chat message delivery. Messages must be persisted in DB and delivered via Postgres Changes. Broadcast is for ephemeral (temporary) data only.

### Rule 14.2: The Realtime Security & Performance Protocol
-   **Law**: Contract authentication, authorization, tenant boundaries, bandwidth, fan-out, connection count, ordering, reconnection, loss tolerance, and cost for Realtime channels.
-   **Action**:
    1.  **RLS Enforcement**: Postgres Changes automatically pass through RLS policies, so security is ensured if RLS is correctly configured. Note that tables with `USING (true)` broadcast all data to all users.
    2.  **Channel Granularity**: Design channel names with fine granularity (e.g., `room:${roomId}`). Funneling all events into one "global channel" causes all clients to receive all events, wasting bandwidth.
    3.  **Connection Budget**: Verify contracted-plan and effective quotas from current documentation/settings, then capacity-test peak users, tabs/devices, reconnection storms, and headroom. Use the SDK-appropriate unsubscribe/cleanup when the consumer lifecycle ends.
    4.  **Event Rate Control**: Select throttling, debouncing, sampling, or aggregation from UX latency, loss tolerance, message size, and provider quotas; do not put a fixed interval in Universal.
    5.  **Lifecycle Cleanup**: Release subscriptions at component, view, process, socket, or background-transition ownership boundaries, not only React unmount, and test duplicate listeners after reconnection.
        ```typescript
        useEffect(() => {
          const channel = supabase.channel('room:123')
            .on('postgres_changes', { event: 'INSERT', schema: 'public', table: 'messages' }, handler)
            .subscribe();
          return () => { supabase.removeChannel(channel); };
        }, []);
        ```

### Rule 14.3: The Realtime Data Flow Decision Matrix
-   **Law**: The delivery method for real-time data MUST be selected based on data persistence, target audience, and latency requirements.

    | Use Case | Recommended Method | Reason |
    |:---------|:-------------------|:-------|
    | Chat messages | Postgres Changes | Persistence required. Auto-filtered by RLS |
    | Typing indicators | Broadcast | Ephemeral. No DB storage needed |
    | Online status | Presence | Specialized for connection state sync |
    | Notification badge updates | Postgres Changes | Subscribe to notification table changes |
    | Collaborative editing (cursors) | Broadcast | Low latency, ephemeral |
    | Dashboard metrics updates | Postgres Changes | Subscribe to aggregation table changes |
    | Continuous replication to analytics | managed CDC or Pipelines (§15.4) | Manage initial copy, redelivery, and recovery separately from end-user Realtime |

---

## 15. Cron & Queues Design Strategy

### Rule 15.1: The pg_cron Scheduling Protocol
-   **Law**: Select a database scheduler, platform scheduler, workflow engine, or another mechanism for recurring tasks by transaction proximity, runtime, retry, secrets, observability, blast radius, and portability. `pg_cron` is a candidate, not a universal mandate.
-   **Action**:
    1.  **Cron Expression**: Define using standard cron expressions (`minute hour day month weekday`). Note that expressions are UTC-based; clearly comment timezone conversions.
        ```sql
        -- Daily 3:00 AM JST = 18:00 UTC data purge
        SELECT cron.schedule(
          'purge-expired-sessions',
          '0 18 * * *', -- UTC 18:00 = JST 03:00
          $$DELETE FROM public.sessions WHERE expires_at < NOW() - INTERVAL '30 days'$$
        );
        ```
    2.  **Idempotent Jobs**: Design SQL within cron jobs to be idempotent. Anticipate overlapping execution (next run starts before current completes) and consider using lock mechanisms (`pg_advisory_lock`).
    3.  **Monitoring**: Monitor start/finish, duration, attempt, checkpoint, affected count, and result; define alert and review cadence from SLO and risk.
    4.  **Resource Guard**: Use bounded batches and backpressure derived from measured locks, WAL, replication lag, latency, memory, and timeout. Do not put a fixed batch size in Universal.

### Rule 15.2: The Message Queue Protocol (pgmq / Supabase Queues)
-   **Law**: Where latency, failure isolation, durability, ordering, throughput, or delivery semantics require an asynchronous boundary, compare Supabase Queues, another broker, or a workflow engine by capability. Do not queue every short synchronous operation or operation requiring strong transactional consistency.
-   **Action**:
    1.  **Queue-First Architecture**: Do NOT call external APIs or send emails within user request processing. Enqueue messages and let workers (Edge Function/pg_cron) process them asynchronously.
    2.  **Retry Strategy**: Retry transient failures only, with jittered backoff and a retry budget; classify permanent errors into quarantine/DLQ. Derive attempts, caps, and redrive conditions from dependency SLO and the business deadline.
    3.  **Lease and Redelivery**: Set visibility/lease from processing distribution, heartbeats, shutdown, and network partitions; assume at-least-once redelivery and design idempotency keys plus atomic side effects.
    4.  **Message Size**: Include only **minimal data** (ID and operation type) in queue messages. Rather than cramming bulk data into messages, keep data in DB and include only pointers (IDs) in messages.
-   **Anti-pattern**: Directly executing `await sendEmail(...)` within a Server Action and making users wait for email sending to complete. Enqueue and return a response immediately.

### Rule 15.3: The Database Webhook Protocol
-   **Law**: For change notification, select database webhooks, an outbox, CDC, a queue, or bounded polling by delivery guarantees, ordering, replay, transaction consistency, consumer count, and cost.
-   **Action**:
    1.  **Event-Driven**: Webhooks automatically issue HTTP requests on table trigger events. Use for real-time integration with external services (Slack notifications, Analytics, CRM integration, etc.).
    2.  **Idempotency**: Design webhook receivers to be idempotent. Network failures may cause the same event to be delivered multiple times due to retries.
    3.  **Sender Authentication**: Verify sender, integrity, and timestamp/nonce with an approved shared-secret signature, asymmetric signature, mTLS, workload identity, or equivalent, and reject replay. Do not fix one header name in Universal.

### Rule 15.4: The Managed CDC / Pipelines Protocol
-   **Law**: Managed CDC or Pipelines is a boundary that continuously replicates changes from a transactional database into analytics, search, warehouses, or similar destinations. It does not replace a transactional outbox, end-user Realtime, or backups.
-   **Action**:
    1.  **Capability and Maturity**: Verify current availability, support tier, destinations, delivery semantics, limits, and pricing at adoption and update time. Alpha or preview capability follows §60 maturity and exception governance; availability alone does not promote it to Standard.
    2.  **Delivery Correctness**: Contract the initial-snapshot and WAL boundary, at-least-once redelivery, duplicates, ordering scope, deletes and truncates, checkpoints, slots, lag, backpressure, and recovery. Make consumers idempotent and automate source-to-destination reconciliation.
    3.  **Schema and Data Governance**: Define table, column, and row allowlists plus PII, residency, encryption, access, and retention. Automatic schema propagation does not replace compatibility review; use expand-contract for breaking changes. Where the service copies data without transformation, make source- or destination-side masking and transformation plus failure behavior explicit.
    4.  **Operations**: Own replication lag, failures, slot growth, source overhead, destination quotas, pause, resume, rebuild, runbooks, RPO/RTO, export, and exit. A monitoring screen alone is not evidence of recoverability.
    5.  **FinOps**: Budget initial copy, active duration, change volume, egress, destination storage and queries, and logs as cost drivers, with alerts, stop conditions, and recovery procedures for anomalous growth.

---

## 16. Observability & FinOps Strategy

### Rule 16.1: The Database Performance Monitoring Protocol
-   **Law**: Database performance MUST be maintained through **proactive monitoring and preventive optimization**. The reactive approach of "responding only when it feels slow" is prohibited.
-   **Action**:
    1.  **Workload Evidence**: Use effective telemetry such as `pg_stat_statements` to observe total time, tail latency, frequency, rows, I/O, and locks. Review top-contributing queries at a cadence and query budget derived from SLO, cost, and change risk; do not make fixed counts or 100ms a Universal threshold.
        ```sql
        -- Top 10 Slowest Queries
        SELECT query, calls, mean_exec_time, total_exec_time
        FROM pg_stat_statements
        ORDER BY mean_exec_time DESC
        LIMIT 10;
        ```
    2.  **Index Advisor**: Leverage the Supabase Dashboard **Index Advisor** and regularly review recommended index suggestions. Do not blindly apply suggested indexes; consider impacts on write performance before deciding.
    3.  **Connection Monitoring**: Alert on active/idle/waiting connections, pool saturation, queue time, and reserved headroom according to the capacity model and SLO.
    4.  **Table Maintenance**: Observe dead tuples, vacuum lag, wraparound, table/index bloat, and write rate. Respect provider-managed autovacuum while tuning or maintaining only with measured evidence and a runbook.

### Rule 16.2: The Supabase Monitoring Checklist
-   **Law**: Use dashboards, APIs, metric exports, and log/trace drains to monitor golden signals, quota headroom, growth, and security anomalies across database, disk, API, Auth, Functions, Realtime, and Storage. Define thresholds, windows, cadence, owner, and escalation in Blueprint from SLO, forecasts, contracted plans, and incident history.

### Rule 16.3: The Supabase FinOps Protocol (Cost Optimization)
-   **Law**: The Supabase billing model MUST be accurately understood, and cost optimization MUST be incorporated as part of architecture design.
-   **Action**:
    1.  **Billing Awareness**: Understand the following billing dimensions and monitor usage on each axis:

        | Billing Dimension | Free Tier Limit | Pro Limit | Cost Reduction Strategy |
        |:-----------------|:----------------|:----------|:-----------------------|
        | **Database** | 500MB | 8GB incl. | Index optimization, Cold Data Offloading (§2.14) |
        | **Storage** | 1GB | 100GB incl. | Image compression, CDN caching, orphan file deletion (§2.11) |
        | **Bandwidth** | 5GB | 250GB incl. | CDN utilization, minimize `select()`, pagination |
        | **Edge Functions** | 500K invocations | 2M incl. | Batch processing, reduce unnecessary invocations |
        | **Realtime** | 200 connections | 500 connections | Channel design optimization, unused connection cleanup |
        | **Auth MAU** | 50K | 100K incl. | Bot prevention, fraudulent account deletion |

    2.  **Query Optimization for Cost**: Select required fields and bounded results on public, large, or high-frequency paths. Do not universally prohibit `select('*')` for an explicit small contract; test schema expansion and transfer cost.
    3.  **Storage Tiering**: Cache images and static assets via CDN (Cloudflare, etc.) to minimize direct access to Supabase Storage. This is the most effective bandwidth cost reduction strategy.
    4.  **Non-Production Economics**: Select plans and lifecycles for dev/test/preview from required isolation, availability, data class, quotas, resume time, and contract terms. Do not send synthetic keep-alives solely to avoid billing behavior.
    5.  **Compute Add-on Rightsizing**: Select appropriate Compute Add-on sizes based on actual CPU/memory usage. Excessive Compute is a direct cost waste.

### Rule 16.4: The Log Management Protocol
-   **Law**: Logs generated by Supabase (API, Auth, Database, Edge Functions) MUST be centrally managed and maintained in a state immediately usable for incident investigation.
-   **Action**:
    1.  **Log Drain**: In production, use Supabase's **Log Drain** feature to forward logs to external log management services (Datadog, Logflare, BigQuery, etc.). Native logs in the Supabase Dashboard have limited retention periods.
    2.  **Structured Logging**: Within Edge Functions, emit identifier-free structured logs such as `console.log(JSON.stringify({ event, correlationId, outcome, duration }))` to support search and filtering. Security audits that must identify a person belong in a protected, purpose-limited audit sink with least privilege, tamper resistance, retention, and deletion controls, separate from general application logs.
    3.  **Sensitive Data Control**: Never log credentials, tokens, or passwords. Limit PII to approved exceptions with purpose, legal basis, minimization, masking, retention, and access controls. Apply least privilege and audit to log access.

---

## 17. AI & Vector Search Strategy

### Rule 17.1: The pgvector Architecture Protocol
-   **Law**: Select pgvector, a managed vector service, a search engine, or another option by scale, filtering/authorization, latency, recall, freshness, operations, cost, and exit. pgvector is a candidate where data locality provides value.
-   **Action**:
    1.  **Extension Enable**: Enable pgvector with `CREATE EXTENSION IF NOT EXISTS vector WITH SCHEMA extensions;`. Installing into the `public` schema violates §2.2 (Schema Separation).
    2.  **Vector Contract**: Contract provider/model, model revision, dimension, distance metric, normalization, and source version as metadata; verify the current model dimension during implementation.
        ```sql
        ALTER TABLE public.documents
        ADD COLUMN embedding vector(1536);
        ```
    3.  **Distance Metric**: Select cosine, inner product, L2, or another metric from the model training contract and offline/online evaluation; do not set one Universal default.
    4.  **RLS Integration**: Always apply RLS to tables containing embedding columns. Designs where vector search results bypass RLS (direct search via `service_role` → unvalidated return to client) are prohibited.

### Rule 17.2: The Vector Index Strategy
-   **Law**: Vector indexes MUST be selected based on data size and search accuracy requirements.
-   **Action**:
    1.  **HNSW Candidate**: Select when measured recall, latency, build time, memory, and write rate fit.
        ```sql
        CREATE INDEX idx_documents_embedding ON public.documents
        USING hnsw (embedding vector_cosine_ops)
        WITH (m = 16, ef_construction = 64);
        ```
    2.  **IVFFlat Candidate**: Select where training data, memory, and update patterns fit; tune lists/probes through benchmarks.
    3.  **Index Lifecycle**: With a representative corpus and filter selectivity, measure recall against exact search, p95/p99, memory, and build/rebuild cost to decide creation, tuning, and reindex timing.

### Rule 17.3: The RAG Pipeline Protocol
-   **Law**: When building RAG (Retrieval-Augmented Generation) pipelines, the entire process of embedding generation, storage, search, and retrieval MUST be managed with a consistent design.
-   **Action**:
    1.  **Embedding Generation**: Execute embedding generation in Edge Functions or server-side. Direct API calls from clients (exposing OpenAI API keys) are strictly prohibited.
    2.  **Chunk Strategy**: Evaluate chunking from content structure, model context, retrieval unit, citations, overlap, and language; do not put a fixed token width in Universal.
    3.  **Metadata Co-Storage**: Store **original text, source URL, and chunk position** as metadata in the same table alongside embeddings. Storing only embeddings with separate original data management makes it impossible to reconstruct source text from search results.
    4.  **Authorized Retrieval**: Select RLS, a security-invoker RPC, a service boundary, pre-filtering/post-filtering, or another design that proves authorization for both candidates and returned results. Do not default to `SECURITY DEFINER`.
        ```sql
        CREATE OR REPLACE FUNCTION public.match_documents(
          query_embedding vector(1536),
          match_threshold float DEFAULT 0.78,
          match_count int DEFAULT 10
        )
        RETURNS TABLE (id uuid, content text, similarity float)
        LANGUAGE plpgsql
        SECURITY DEFINER
        SET search_path = ''
        AS $$
        BEGIN
          RETURN QUERY
          SELECT d.id, d.content, 1 - (d.embedding <=> query_embedding) AS similarity
          FROM public.documents d
          WHERE 1 - (d.embedding <=> query_embedding) > match_threshold
          ORDER BY d.embedding <=> query_embedding
          LIMIT match_count;
        END;
        $$;
        ```
    5.  **Embedding Freshness**: Record source hash, model revision, generation status, retries, backfill, and a staleness SLO; regenerate on semantic changes rather than every metadata-only update.

---

## 18. Advanced Auth Design Strategy

### Rule 18.1: The API Key Security Protocol
-   **Law**: Inventory **Publishable Keys**, **Secret Keys**, legacy `anon` and `service_role` keys, user JWTs, and JWT signing keys as separate credential classes, managing client exposure, RLS, rotation, revocation, consumers, and migration.
-   **Action**:
    1.  **Publishable Key**: It may be distributed to browsers, mobile, and desktop clients, but it is not authorization. Require RLS, least-privilege grants, abuse controls, and data classification for exposed schemas.
    2.  **Secret Key**: Use only in trusted runtimes such as servers, workers, and Edge Functions; never expose it in client bundles, logs, previews, or user-controlled headers. Assume an RLS-bypass-equivalent blast radius and design per-workload keys, minimal use, rotation, and audit.
    3.  **Legacy Migration**: Track the current official deprecation deadline for legacy `anon` and `service_role` keys, migrate one consumer at a time to publishable and secret keys, verify usage telemetry, and then disable legacy keys.
    4.  **Key Rotation**: On suspected exposure, do not depend on automatic revocation by a detection service. Immediately revoke or rotate, update consumers, investigate log and data access, and retain incident evidence.
    5.  **JWT Verification**: Do not conflate API keys with JWT signing keys. An external service validates the current JWKS or asymmetric-signing contract, issuer, audience, expiry, and key rotation; it never reuses a shared high-privilege API key for token verification.
    6.  **Data API Exposure**: Disable the Data API or limit exposed schemas when the architecture does not use it. When it is used, never assume a new table is automatically exposed; manage exposure, grants, and RLS in migrations and tests.

### Rule 18.2: The PKCE & MFA Implementation Protocol
-   **Law**: In authentication flows, **PKCE (Proof Key for Code Exchange)** MUST be the standard, and **MFA (Multi-Factor Authentication)** MUST be implemented for applications requiring high security.
-   **Action**:
    1.  **PKCE Default**: Supabase Auth natively supports the PKCE flow. `supabase.auth.signInWithOAuth()` uses PKCE by default. When manually managing `code_verifier` / `code_challenge` in custom implementations, strictly follow RFC 7636.
    2.  **MFA Enrollment**: Register MFA with `supabase.auth.mfa.enroll({ factorType: 'totp' })`. Display QR code to user and recommend TOTP apps (Google Authenticator, etc.) for authentication.
    3.  **MFA Verification**: After login, check `currentLevel` via `supabase.auth.mfa.getAuthenticatorAssuranceLevel()` to distinguish between `aal1` (password only) and `aal2` (MFA completed).
    4.  **AAL-Based RLS**: Add `auth.jwt()->>'aal' = 'aal2'` as a condition to RLS policies for high-security tables (payments, personal information, etc.) to allow access only to MFA-completed users.
        ```sql
        CREATE POLICY "require_mfa_for_payments" ON public.payments
        FOR ALL USING (
          (select auth.uid()) = user_id
          AND (select auth.jwt()->>'aal') = 'aal2'
        );
        ```
    5.  **Phone MFA**: SMS authentication carries SIM swap attack risks. Prefer TOTP whenever possible and position SMS MFA as a fallback alternative.

### Rule 18.3: The Anonymous Auth & Session Management Protocol
-   **Law**: When using Supabase Anonymous Auth, the lifecycle of anonymous user data management and account elevation (linking) MUST be designed.
-   **Action**:
    1.  **Anonymous Auth Use Case**: Use for guest carts, onboarding experiences, demo features, etc., where temporary DB writes are needed without authentication.
    2.  **Account Linking**: When anonymous users later sign up via email/social, use `supabase.auth.linkIdentity()` to link new credentials to the existing anonymous session, guaranteeing data continuity.
    3.  **RLS for Anonymous**: In RLS policies for anonymous users, use `auth.jwt()->>'is_anonymous'` to distinguish between anonymous and authenticated users and restrict write scope.
    4.  **Cleanup**: Derive retention for anonymous identities that are not elevated from purpose, fraud, legal hold, user expectations, and provider billing, then delete/anonymize with an approved scheduler. Do not fix 30 days or `pg_cron` in Universal.
    5.  **Session Refresh**: Monitor session state changes via `supabase.auth.onAuthStateChange()` and handle token refresh appropriately. Neglecting token expiration causes sudden user logouts.

---

## 19. Testing Strategy

### Rule 19.1: The RLS Policy Testing Protocol
-   **Law**: Verify RLS policies through automated tests and never rely on manual inspection alone. Version test artifacts in the same change set as the migration, without universally requiring test SQL inside a production migration file.
-   **Action**:
    1.  **pgTAP Integration**: Use the `pgTAP` extension to write unit tests for RLS policies.
        ```sql
        -- pgTAP RLS Test Example
        BEGIN;
        SELECT plan(2);

        -- Authenticate as User A
        SET LOCAL role = 'authenticated';
        SET LOCAL request.jwt.claims = '{"sub": "user-a-uuid", "role": "authenticated"}';

        -- Can read own data
        SELECT results_eq(
          $$SELECT count(*) FROM public.posts WHERE user_id = 'user-a-uuid'$$,
          ARRAY[1::bigint],
          'User A can read own posts'
        );

        -- Cannot read others data
        SELECT results_eq(
          $$SELECT count(*) FROM public.posts WHERE user_id = 'user-b-uuid'$$,
          ARRAY[0::bigint],
          'User A cannot read User B posts'
        );

        SELECT * FROM finish();
        ROLLBACK;
        ```
    2.  **Role Impersonation**: Use `SET LOCAL role = 'anon'` / `'authenticated'` / `'service_role'` within tests to verify access for each role.
    3.  **Negative Testing**: Always include verification that policies "correctly deny access that should be denied" (negative testing). Verifying only that "permitted operations succeed" is insufficient.
    4.  **CI Integration**: Integrate pgTAP tests into CI/CD pipelines (GitHub Actions, etc.) for automatic execution after migration application.

### Rule 19.2: The Edge Functions Testing Protocol
-   **Law**: Edge Functions MUST be verified through two layers: **local testing** and **integration testing**.
-   **Action**:
    1.  **Unit Test**: Use Deno's standard test runner (`deno test`) to unit test business logic within Edge Functions. Replace external dependencies (DB, external APIs) with mocks.
    2.  **Integration Test**: Send actual HTTP requests to locally-served Edge Functions via `supabase functions serve`. Test both requests with authentication headers and without.
    3.  **Error Scenarios**: Verify responses for not only success cases but also authentication failures, input validation errors, and external API failures.
    4.  **Supabase CLI Test**: Execute automated tests using `supabase functions test` command (when available).

### Rule 19.3: The Database Function Testing Protocol
-   **Law**: Custom RPC functions (PL/pgSQL) MUST cover boundary value testing, permission testing, and error handling testing for input parameters.
-   **Action**:
    1.  **Boundary Value Testing**: Test function behavior against boundary values such as NULL inputs, empty strings, extremely large numbers, and invalid UUIDs.
    2.  **Permission Testing**: Verify that `SECURITY DEFINER` functions do not cause unintended privilege escalation. Confirm that calling from the `anon` role does not return data that should be inaccessible.
    3.  **Transaction Safety**: Confirm that when errors occur within functions, partial data changes do not persist and proper rollback occurs.
    4.  **Seed Data**: Build test fixtures deterministically through an approved seed file, factory, snapshot, or equivalent without depending on production data or a fixed path.

---

## 20. Multi-Environment & Branching Strategy

### Rule 20.1: The Environment Isolation Protocol
-   **Law**: Separate the production trust boundary from non-production. Choose the physical project count for dev, test, preview, and staging from data class, blast radius, parallelism, cost, and provider capability; never share production credentials or data.
-   **Action**:
    1.  **Isolation Pattern**: Select independent projects, branch/preview instances, ephemeral local stacks, or equivalent for the required isolation; production retains an independent access, secret, and approval boundary.
    2.  **Environment Variable Isolation**: Each environment's `SUPABASE_URL` and `SUPABASE_ANON_KEY` MUST be strictly managed via environment variables. Hardcoding is prohibited.
    3.  **Production Data Isolation**: When copying production data to development/staging environments, PII MUST be **anonymized/masked**. Unprocessed copies of production data create Global Privacy Laws/GDPR violation risks.
    4.  **Migration Flow**: Migration application order is unidirectional: `Dev → Staging → Production`. Unmanaged production changes are prohibited by §7.6 (Controlled Remote Change Policy).
    5.  **Seed Data Separation**: Manage seed data (`seed.sql`) separately per environment to prevent development test data from contaminating production.

### Rule 20.2: The Supabase Branching Protocol
-   **Law**: Where the current plan and maturity fit, use Supabase Branching, preview projects, local ephemeral stacks, or equivalent to isolate schema-change verification. Adoption of a preview feature is not itself a Universal requirement.
-   **Action**:
    1.  **Branch = Isolated Instance**: Each branch functions as an independent Supabase instance (with its own API credentials, Auth, Storage). Test schema changes without impacting production.
    2.  **Dashboard / CLI Creation**: Branches can be created from the Supabase Dashboard, CLI (`supabase branches create`), or Management API. Git integration is not required (Branching 2.0).
    3.  **Migration Preview**: Apply migrations to branches and verify schema integrity, RLS policy behavior, and performance impact before production application.
    4.  **Branch Lifecycle**: Promptly delete branches after testing is complete. Abandoned branches consume compute resources and cause cost increases.
    5.  **No Data Persistence**: Branches are temporary verification environments. Data within branches is not migrated to production on merge. Use only test data and do not store important data in branches.

---

## 21. PostgREST API Design Strategy

### Rule 21.1: The Select Optimization Protocol
-   **Law**: Bound fields and results for public, large, or high-frequency PostgREST queries. An explicit small contract may use `select('*')`, but must test schema expansion, PII exposure, and egress.
-   **Action**:
    1.  **Explicit Select**: Explicitly specify needed columns like `.select('id, name, created_at')`. `select('*')` increases transferred data volume and directly impacts Bandwidth billing (see §16.3).
    2.  **Computed Columns**: Leverage PostgreSQL Generated Columns and Views to return computed results directly via the API. Eliminate client-side recalculation.
    3.  **Type Contract**: Refresh generated types when the database schema or generator version changes. When `select()` changes, verify query-result inference, DTOs, consumer contracts, and contract tests; do not confuse a select-list-only change with a reason to regenerate database-schema types.

### Rule 21.2: The Filtering & Embedding Protocol
-   **Law**: Filter unbounded data at its source, then choose Embedding, multiple queries, RPC, or service aggregation by cardinality, payload, cacheability, latency, and authorization boundaries. Neither one-request delivery nor Embedding is a goal by itself.
-   **Action**:
    1.  **Filter Operators**: Use PostgREST filters such as `.eq()`, `.in()`, `.gte()`, `.lte()`, `.like()`, `.ilike()` to filter data server-side. Designs that retrieve all records and filter client-side are prohibited.
    2.  **Embedding Candidate**: Foreign-key Embedding is a strong candidate when bounded related data shares an authorization and cache boundary. Compare multiple queries or a dedicated endpoint when independent caching, different change rates, large fan-out, or separate authorization boundaries exist.
        ```typescript
        // ✅ Retrieve posts and author info in 1 request
        const { data } = await supabase
          .from('posts')
          .select('id, title, author:profiles(name, avatar_url)')
          .eq('status', 'published');
        ```
    3.  **Inner Join**: Default is Left Join. When related records must exist, use the `!inner` modifier to specify Inner Join and prevent NULL contamination.
        ```typescript
        .select('id, title, author:profiles!inner(name)')
        ```
    4.  **Nesting Budget**: Set acceptable depth from measured execution plans, row fan-out, serialized payload, memory, timeout, and egress budgets rather than a fixed level count. Split over-budget nested contracts into views, RPC, separate fetches, or pre-aggregation.

### Rule 21.3: The Pagination & Aggregate Protocol
-   **Law**: Collections that can grow or whose upper bound cannot be proven require bounded pagination, streaming, export jobs, or an equivalent control. Do not force pagination on small reference data with an enforced upper bound.
-   **Action**:
    1.  **Range Pagination**: Implement offset-based pagination with `.range(from, to)`. Total count is available via the `Content-Range` response header.
    2.  **Count Option**: When total count is needed, use `{ count: 'exact' }` option. However, for large tables, `count: 'estimated'` is recommended (`exact` triggers a full table scan).
    3.  **Cursor Pagination**: Consider Keyset Pagination with a unique tie-breaker when growth, deep pages, concurrent mutation, or stable ordering requires it. Do not use a fixed row-count threshold; compare it with offset pagination through execution plans and consistency tests.
    4.  **Page Budget**: Set page size in Blueprint from effective provider limits, payload, client memory, latency SLO, egress, and rate limits, then enforce it with a server-side maximum and tests. Do not embed a fixed count in Universal.

---

## 22. CLI & Local Development Strategy

### Rule 22.1: The CLI-First Workflow Protocol
-   **Law**: Center the Supabase CLI in the development workflow and minimize dependency on Dashboard GUI operations.
-   **Action**:
    1.  **Local Development**: Build local development environments with `supabase init` → `supabase start`. The local environment runs identical PostgreSQL, Auth, Storage, and Edge Functions as production.
    2.  **Migration Workflow**: Create new migration files with `supabase migration new <name>` and write SQL. Unmanaged remote-console changes are prohibited by §7.6 (Controlled Remote Change Policy).
    3.  **Linking**: Configure remote project linking with `supabase link --project-ref <ref>`.
    4.  **Type Generation**: Generate type definitions from local DB with `supabase gen types typescript --local > src/types/database.types.ts`. Remote DB generation is available via the `--project-id` option.
    5.  **Deploy**: Deploy Edge Functions with `supabase functions deploy <name>`. The `--no-verify-jwt` option is permitted only during development per §13.2.

### Rule 22.2: The Database Inspection & Diff Protocol
-   **Law**: Use Supabase CLI's **inspect & diff** commands for schema state verification and diff detection, reducing manual inspection effort.
-   **Action**:
    1.  **`supabase db diff`**: Detect differences between local DB and migration history. Effective for detecting changes made manually via the Dashboard.
    2.  **`supabase inspect db`**: Inspect database health including table sizes, index usage, and unused index detection. Execute periodically in combination with §16.1 (Database Performance Monitoring Protocol).
    3.  **`supabase db lint`**: Execute schema lint checks to automate §0.1 (Zero Tolerance Linter Protocol). Recommended to integrate into CI/CD pipelines for automatic checks before migration application.
    4.  **`supabase db reset`**: Fully reset local DB and reapply all migrations. Execute periodically to ensure a clean test environment state.
    5.  **Version Pinning**: Match the local PostgreSQL version with production in `supabase/config.toml`. Version mismatches cause migration compatibility issues.

---

## 23. Connection Pooling / Supavisor Strategy

### Rule 23.1: The Supavisor Architecture Protocol
-   **Law**: Select the Data API, a pooler, or a direct connection from runtime concurrency, connection lifetime, network reachability, session semantics, and provider capability. Supavisor is a strong candidate for elastic/short-lived workloads, not a universal requirement for every path.
-   **Action**:
    1.  **Endpoint Contract**: Obtain endpoint, port, TLS, IPv4/IPv6, pooling mode, credentials, and prepared-statement compatibility from current project settings and documentation; do not fix ports in Universal.
    2.  **Serverless Optimization**: In serverless environments (Vercel Functions, Edge Functions, etc.), DB connections are created and destroyed per request. Supavisor manages **hot connections** in a pool, significantly reducing connection overhead (TCP handshake, TLS negotiation, PostgreSQL startup).
    3.  **IPv6 Mediation**: Supavisor provides IPv4 → IPv6 mediation. Use Pooler connections from IPv4 environments like GitHub Actions to avoid IPv6 connection errors.
    4.  **Replica Routing Verification**: When adopting read replicas, verify the routing behavior provided by the current plan, connection endpoint, client, and pooling mode against official documentation and measurement. Do not assume automatic distribution; test primary/replica paths, read-after-write consistency, and failover behavior.

### Rule 23.2: The Pool Size Design Protocol
-   **Law**: Connection pool size MUST be **designed using calculations** based on PostgreSQL's max connections and application characteristics. Leaving default values is prohibited.
-   **Action**:
    1.  **Pool Size Calculation**: Calculate the pool budget from peak instances, per-instance concurrency, transaction duration, database/pooler capacity, and migration/operator/replication headroom; load-test queue time and saturation.
    2.  **Max Connections Awareness**: Read effective `max_connections`, pooler limits, reserved connections, and contracted plan from runtime evidence; do not embed fixed values by plan name.
    3.  **Connection Monitoring**: Periodically monitor connection trends on the **Database > Connections** page in the Dashboard. Teams/Enterprise plans provide breakdowns by connection type (Postgres, PostgREST, Auth, Storage, etc.).
    4.  **Connection Leak Prevention**: Forgetting `supabase.removeAllChannels()` or explicit DB connection closure on the application side causes connection leaks. Always release connections on request completion in serverless functions.

### Rule 23.3: The Connection Mode Decision Protocol
-   **Law**: **Transaction Mode** and **Session Mode** MUST be correctly selected based on application characteristics.
-   **Action**:
    1.  **Transaction Mode Candidate**: A candidate for short-lived/elastic workloads that do not need session state. Test current driver and prepared-statement compatibility.
    2.  **Session Mode**: Use only when features depending on session state are needed, such as Prepared Statements or `LISTEN/NOTIFY`. Connections are occupied until session end.
    3.  **Transaction Mode Restrictions**: The following features are **unavailable** in Transaction Mode:
        -   Session variables via `SET` commands
        -   `PREPARE` / `DEALLOCATE` (Prepared Statements) — partially mitigated by Supavisor 1.0+ Named Prepared Statement support
        -   `LISTEN` / `NOTIFY`
        -   Advisory Locks
    4.  **Direct Connection (Port 5432)**: Use direct connections for operations unsuitable for the pooler, such as migration execution, `pg_dump`, and long-running queries.

---

## 24. Backup & Disaster Recovery Strategy

### Rule 24.1: The Backup Strategy Protocol
-   **Law**: Protect production data and every resource needed for recovery with a verifiable backup strategy aligned to defined RPO, RTO, retention, failure domains, and data classification. Identify dependence on one control plane, account, or region in risk assessment and design required redundancy.
-   **Action**:
    1.  **Effective Capability Inventory**: Verify the contracted plan and current official documentation, then inventory backup frequency, retention, PITR, download or export, restore method, encryption, region, and permissions from effective settings and evidence. Do not encode fixed plan names or retention periods in this rule.
    2.  **Resource-complete Scope**: Do not assume database backups include Storage objects, Auth configuration, Edge Functions, secrets, networks, custom domains, or external identities and queues. Define protection, reconstruction, and consistency order for each resource.
    3.  **Independent Copy When Required**: When the threat model includes provider-account deletion, control-plane or regional failure, operator error, or ransomware, export logical or physical copies through an approved scheduler to an encrypted separate failure domain, considering immutability and deletion protection.
    4.  **Privacy and Key Separation**: Apply encryption, access logging, retention, legal hold, deletion, and key separation to backups containing PII according to data classification.
    5.  **Continuous Evidence**: Monitor backup jobs, freshness, size anomalies, and restore eligibility, and alert the owner on failure. A success indicator alone is not proof of recoverability.

### Rule 24.2: The Disaster Recovery Planning Protocol
-   **Law**: Disaster recovery (DR) procedures MUST be **documented and tested**. Production operation without existing or tested recovery procedures is prohibited.
-   **Action**:
    1.  **RTO/RPO Definition**: Define RTO and RPO per service and data domain in Blueprint from business impact, data-loss tolerance, dependency chain, and regulation, then validate feasibility with measured provider capabilities.
    2.  **Recovery Runbook**: Create and share a recovery procedures document with the team including:
        -   Restoration through an approved control plane, API, or CLI
        -   `pg_restore` backup restoration procedures
        -   PITR point-in-time restoration procedures
        -   Recovery checklist for all services including Auth/Storage/Edge Functions
    3.  **DR Test**: Perform real restoration into an isolated environment at a cadence based on release risk, change events, compliance, and RTO or RPO; verify data integrity, identity, Storage objects, the application, observability, and DNS or routing. Do not describe an untested backup as recoverable.
    4.  **Recovery Priority**: Define recovery order, parallelism, and consistency checkpoints from the data-domain dependency graph in Blueprint. Do not force fixed tiers or fixed durations on every project.
    5.  **Incident Communication**: Include communication procedures for incidents (user notification, stakeholder contact, status page updates) in the recovery runbook.

---

## 25. Rate Limiting & API Protection Strategy

### Rule 25.1: The Auth Rate Limiting Protocol
-   **Law**: Supabase Auth's built-in rate limits MUST be understood and incorporated into application design. Designs that ignore rate limits cause legitimate user blocking and service denial.
-   **Action**:
    1.  **Effective Limits**: Read current defaults, project overrides, and provider quotas from the Dashboard, Management API, and official documentation; design capacity and abuse budgets for email, SMS, signup, token, and other dimensions.
    2.  **Management API Customization**: Customize rate limit values through the Dashboard or Management API. Default values are startup-oriented and require adjustment as traffic grows.
    3.  **Client-Side Throttling**: Implement throttling on authentication requests client-side as well. Prevent unnecessary rate limit exceedance from button spam or retry loops.
    4.  **Error Handling**: Properly handle HTTP 429 responses on rate limit exceedance. Display "Please wait" messages to users and control retry timing based on the `Retry-After` header.

### Rule 25.2: The Custom API Rate Limiting Protocol
-   **Law**: Internet-facing or cost-amplifying Data APIs/Functions require appropriate rate, concurrency, and quota controls selected from provider controls, gateways, distributed stores, databases, or equivalent.
-   **Action**:
    1.  **Control Selection**: Select token buckets, sliding windows, concurrency limits, quotas, or another control by exactness, distribution, latency, failure modes, and cost. Upstash and similar services are non-normative examples.
        ```typescript
        // Rate Limiting example in Edge Function
        import { Ratelimit } from "@upstash/ratelimit";
        import { Redis } from "@upstash/redis";

        const ratelimit = new Ratelimit({
          redis: Redis.fromEnv(),
          limiter: Ratelimit.slidingWindow(10, "60 s"), // 10 requests per 60 seconds
        });

        const { success } = await ratelimit.limit(identifier);
        if (!success) return new Response("Rate limited", { status: 429 });
        ```
    2.  **Identity and Fairness**: Combine IP, account, tenant, device, credential, and resource according to privacy, NAT, evasion, and enterprise fairness.
    3.  **Resource Budget**: Set limits from per-endpoint CPU, database rows, egress, downstream quotas, and business tier; do not put fixed requests-per-minute values in Universal.
    4.  **Abuse Detection**: Implement logic to detect anomalous patterns (mass sign-ups in short periods, consecutive login failures from same IP, etc.) and trigger temporary IP blocks or CAPTCHA challenges.

---

## 26. Vault & Secret Management Strategy

### Rule 26.1: The Vault Encrypted Storage Protocol
-   **Law**: Protect secrets with an approved secret manager, workload identity, platform secret, or Vault appropriate to the purpose and execution boundary, providing encryption, least privilege, rotation, and audit. Storage in source code, client bundles, logs, or plaintext database fields is prohibited.
-   **Action**:
    1.  **Vault Extension**: Supabase Vault stores secrets with **Authenticated Encryption**. Manage secrets via the Dashboard "Vault" section or SQL.
        ```sql
        -- Store a secret
        SELECT vault.create_secret('my-api-key-value', 'stripe_api_key', 'Stripe production API key');

        -- Retrieve secret (via decrypted view)
        SELECT * FROM vault.decrypted_secrets WHERE name = 'stripe_api_key';
        ```
    2.  **Statement Logging Disable**: Use `SET LOCAL log_statement = 'none';` when inserting secrets to prevent plain text from being recorded in logs. Neglecting this leaves secrets persisted in log files.
    3.  **Access Restriction**: Restrict access to the `vault.decrypted_secrets` view to minimum required roles (`service_role` or dedicated admin role). Direct access from `anon` or `authenticated` roles is prohibited.
    4.  **Lifecycle Compatibility**: Verify extension/provider deprecations and migration paths from current official documentation; never assume an internal implementation migrates transparently.
    5.  **Boundary Selection**: Vault is a candidate for secrets needed only inside database execution; Functions, CI, and external workloads use the runtime's approved secret binding or workload identity.

### Rule 26.2: The Secret Rotation & Lifecycle Protocol
-   **Law**: Secrets MUST be **rotated periodically** and immediately invalidated on leak. Operating without documented rotation procedures is prohibited.
-   **Action**:
    1.  **Rotation Schedule**: Prefer keyless or short-lived credentials. For long-lived secrets, derive Blueprint rotation/revocation cadence from secret type, compromise impact, provider capability, regulation, and consumer rollout time. Revoke immediately on suspected compromise.
    2.  **Automated Rotation**: Automate secret rotation where possible. Execute in order: Update secret in Vault → Verify dependent Functions/Triggers → Invalidate old secret.
    3.  **Leak Response**: Since 2025, Supabase provides **automatic detection and invalidation of API keys pushed to public GitHub repositories**. Do not rely solely on this; always implement `.env` file gitignore configuration and CI/CD secret scanning (GitHub Secret Scanning, GitLeaks, etc.).
    4.  **Environment Separation**: Completely separate dev/staging/production secrets. Sharing the same API keys across multiple environments is prohibited.
    5.  **Audit Trail**: Make secret creation, update, and deletion history trackable. Recommend recording events to an audit_logs table during Vault operations.

---

## 27. Foreign Data Wrappers (FDW) Strategy

### Rule 27.1: The FDW Architecture Protocol
-   **Law**: For external data-source integration, compare FDW/Supabase Wrappers, APIs, event ingestion, ETL/ELT, and replication by consistency, latency, credential isolation, query pushdown, rate limits, failure propagation, cost, and portability. Wrappers are a candidate, not a universal requirement.
-   **Action**:
    1.  **SQL-Native Access**: FDWs enable operating on external APIs and databases using standard SQL just like native PostgreSQL tables. Reduce individual API call logic on the application side and ensure data access uniformity.
    2.  **Supported Wrappers**: The following major FDWs are available:
        -   **Stripe**: Read/write payment data
        -   **Firebase**: Read Auth Users / Firestore Documents
        -   **S3**: Read CSV / JSON Lines / Parquet files
        -   **ClickHouse / BigQuery**: Access analytics data
        -   **PostgreSQL**: Connect to other PostgreSQL instances
    3.  **Wasm FDW**: Supabase supports **WebAssembly FDWs**, enabling safe sandboxed execution and custom FDW development. Wasm FDW is recommended for new FDW development.
    4.  **No ETL Required**: FDWs access data while keeping it in its original source, eliminating the need for ETL pipeline construction. However, understand the latency vs. data freshness tradeoff.

### Rule 27.2: The FDW Security & Performance Protocol
-   **Law**: Protect FDW credentials at an approved secret boundary and minimize API exposure and grants for foreign objects. Adopt caching/materialization only when measurements of latency, freshness, consistency, and cost justify it.
-   **Action**:
    1.  **Credential Integration**: Never embed credentials in SQL source, migrations, SERVER options, or logs; use an approved secret reference supported by the extension or an isolated execution boundary.
        ```sql
        -- Store secret in Vault
        SELECT vault.create_secret('sk_live_xxx', 'stripe_api_key');
        -- Reference Vault when creating FDW
        CREATE SERVER stripe_server
          FOREIGN DATA WRAPPER stripe_wrapper
          OPTIONS (api_key_id (SELECT id FROM vault.decrypted_secrets WHERE name = 'stripe_api_key'));
        ```
    2.  **Private Schema Placement**: Do **NOT** place foreign tables in the `public` schema or public API schemas. Place them in dedicated private schemas (e.g., `fdw_stripe`, `fdw_firebase`) to block direct Data API access.
    3.  **Materialization Choice**: Select a query cache, materialized view, replication, ETL, or another mechanism appropriate to freshness SLO, failure recovery, and source quotas.
    4.  **Controlled Exposure**: Expose only necessary fields and rows through a security-invoker view/function, constrained service, materialized projection, or equivalent. Do not default to `SECURITY DEFINER`.
    5.  **Error Handling**: External API failures (rate limits, network errors) propagate to PostgreSQL query timeouts. Set `statement_timeout` on FDW queries to prevent failure propagation.

---

## 28. Data API Hardening Strategy

### Rule 28.1: The Schema Exposure Control Protocol
-   **Law**: Schemas exposed by the PostgREST Data API MUST be **restricted to the minimum**, preventing unnecessary table and function exposure.
-   **Action**:
    1.  **Custom API Schema**: Instead of directly exposing the default `public` schema to the API, create a dedicated API schema (e.g., `api`) and place only views and functions that should be public in this schema.
        ```sql
        CREATE SCHEMA api;
        -- Create only public-facing views in the api schema
        CREATE VIEW api.public_posts AS
          SELECT id, title, content, created_at
          FROM public.posts
          WHERE status = 'published';
        ```
    2.  **Exposed Schemas Configuration**: Configure exposed schemas via "API Settings > Exposed schemas" in the Dashboard. Even when including `public`, strictly control access per table using RLS and GRANT.
    3.  **Internal Tables Concealment**: Do **NOT** expose migration management tables, audit logs, internal configuration tables, etc. to the API. Place these in non-public schemas like `internal`.
    4.  **Function Exposure**: All functions in the `public` schema become callable via RPC. Move internal-only functions to non-public schemas, or revoke EXECUTE privileges from `anon`/`authenticated` roles via `GRANT`.

### Rule 28.2: The Network Schema & OpenAPI Lockdown Protocol
-   **Law**: External HTTP communication from PostgreSQL via `http`/`net` schemas, and abuse of OpenAPI metadata MUST be prevented.
-   **Action**:
    1.  **Network Schema Revocation**: **Revoke** `anon`/`authenticated` role access to the `http` extension (`http_get`, `http_post`, etc.) and `net` schema (`net.http_get`, etc.). If these are exposed by default, Server-Side Request Forgery (SSRF) via SQL injection becomes possible.
        ```sql
        -- http extension access control
        REVOKE ALL ON SCHEMA net FROM anon, authenticated;
        REVOKE ALL ON ALL FUNCTIONS IN SCHEMA net FROM anon, authenticated;
        ```
    2.  **OpenAPI Endpoint**: PostgREST automatically publishes the OpenAPI schema at the `/rest/v1/` endpoint. In production, **disable per-role** if OpenAPI exposure is unnecessary (`ALTER ROLE authenticator SET pgrst.openapi_mode = 'disabled'`).
    3.  **Schema Introspection Defense**: Prevent attackers from performing "reconnaissance" by inferring table structures, column names, and function signatures from the OpenAPI schema. If OpenAPI cannot be disabled, minimize attack surface by limiting objects placed in exposed schemas.
    4.  **GRANT Audit**: Periodically audit `anon`/`authenticated` role permissions with the following query:
        ```sql
        SELECT grantee, table_schema, table_name, privilege_type
        FROM information_schema.role_table_grants
        WHERE grantee IN ('anon', 'authenticated')
        ORDER BY table_schema, table_name;
        ```
    5.  **Principle of Least Privilege**: Apply the **principle of least privilege** to all schemas, tables, functions, and views. Do not blindly accept default `GRANT` settings; explicitly `REVOKE` unnecessary privileges.

---

## 29. Multi-tenancy Strategy

### Rule 29.1: The Tenant Isolation Design Protocol
-   **Law**: In multi-tenant systems, select an enforceable boundary such as shared-row RLS, schema isolation, database or project isolation, or a service boundary according to threat, regulation, blast radius, operations, and cost. Isolation based only on an optional application filter is prohibited.
-   **Action**:
    1.  **Isolation Discriminator**: In a shared-row model, align an immutable tenant or organization discriminator, foreign keys, indexes, and RLS. Choose its name and type from the domain and identity model; `tenant_id UUID` is not the only representation. The following is an example.
        ```sql
        CREATE TABLE public.projects (
          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          tenant_id UUID NOT NULL,
          name TEXT NOT NULL,
          created_at TIMESTAMPTZ DEFAULT now()
        );
        -- Create index on tenant_id (essential for RLS performance)
        CREATE INDEX idx_projects_tenant_id ON public.projects (tenant_id);
        ```
    2.  **Trusted Tenant Context**: RLS compares an authoritative tenant context such as a signed claim, membership relation, or session context that meets revocation-freshness and consistency requirements. JWT `app_metadata` is a candidate, but stale claims and membership changes must be designed. The following is a single-tenant-claim example.
        ```sql
        ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;
        CREATE POLICY "tenant_isolation" ON public.projects
          FOR ALL
          USING (tenant_id = (auth.jwt() -> 'app_metadata' ->> 'tenant_id')::UUID);
        ```
    3.  **Membership Lifecycle**: Manage tenant assignment, invitation, role change, transfer, departure, and deletion through an authoritative membership workflow, and test claim refresh, session revocation, audit, and race conditions.
    4.  **Shared vs Dedicated**: Compare shared-row, schema-per-tenant, database or project-per-tenant, and hybrid models by data sensitivity, noisy-neighbor risk, backup and restore unit, residency, customization, SLO, operating capacity, and unit economics rather than a fixed tenant-count threshold.

### Rule 29.2: The Tenant Isolation Audit Protocol
-   **Law**: Tenant isolation MUST be **periodically audited and tested** to verify no data leakage exists.
-   **Action**:
    1.  **Cross-Tenant Query Test**: Test suites MUST include test cases verifying that "Tenant A's users cannot access Tenant B's data."
    2.  **Isolation Coverage Check**: Use a machine-readable tenancy inventory as the source of truth and verify that each resource has its declared model, discriminator or schema or database mapping, policy, index, negative test, and owner. Do not determine coverage from a fixed `tenant_id` name search alone.
    3.  **RLS Enforcement Check**: Periodically audit that RLS is enabled on all `public` schema tables (see §3).
    4.  **Tenant-Aware RBAC**: Select a model such as membership tables, claims, RLS, or a policy service for intra- and cross-tenant authorization according to revocation and consistency needs. Separate cross-tenant operations from the normal user path and require resource and action scope, step-up, time-bound approval, and audit; do not make `service_role` the only administrator model.
    5.  **Performance Monitoring**: Monitor RLS performance as tenant count grows, select indexes and InitPlan-style optimizations from real queries, and verify them under the evidence requirements in §3.0.

---

## 30. pg_graphql (GraphQL API) Strategy

### Rule 30.1: The GraphQL API Design Protocol
-   **Law**: Leverage Supabase's built-in **pg_graphql** and use it alongside the PostgREST API when a GraphQL interface is required. Avoid building dedicated GraphQL backend servers.
-   **Action**:
    1.  **Auto-Generated Schema**: pg_graphql **auto-generates a GraphQL schema** from the PostgreSQL schema. Tables, views, and functions are automatically exposed as GraphQL types (§28 schema exposure rules apply).
    2.  **RLS Integration**: **RLS policies automatically apply** to queries via pg_graphql. The same security model as PostgREST API is maintained, requiring no additional access control implementation.
    3.  **Endpoint**: The GraphQL endpoint is exposed at `/graphql/v1`. Use from the Supabase JS client as follows:
        ```typescript
        const { data } = await supabase
          .from('graphql')
          .select('*')
          .single();
        // Or send GraphQL queries directly via fetch
        const response = await fetch(`${SUPABASE_URL}/graphql/v1`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'apikey': SUPABASE_ANON_KEY,
            'Authorization': `Bearer ${session.access_token}`,
          },
          body: JSON.stringify({ query: '{ postsCollection { edges { node { id title } } } }' }),
        });
        ```
    4.  **Naming Convention**: pg_graphql generates collection types with `{TableName}Collection` naming convention. Table names are auto-converted to PascalCase, so understand the mapping from PostgreSQL snake_case.

### Rule 30.2: The REST vs GraphQL Decision Protocol
-   **Law**: REST API (PostgREST) and GraphQL API (pg_graphql) MUST be **correctly selected based on use case**.
-   **Action**:
    1.  **Choose PostgREST (REST) when**:
        -   Single-table CRUD operations
        -   Simple filtering and pagination
        -   Supabase JS client's type-safe query builder can be leveraged
        -   Caching is important (direct HTTP cache header control is easier)
    2.  **Choose pg_graphql (GraphQL) when**:
        -   Fetching **nested data** from multiple tables in a single request
        -   Client needs to select **only required fields** (preventing over-fetching)
        -   Frontend uses GraphQL clients (Relay, Apollo, etc.)
    3.  **Query Depth Limiting**: Configure GraphQL query depth limits server-side. Excessively nested queries cause N+1 problems and overload the database.
    4.  **Mutation via RPC**: For complex mutations (simultaneous multi-table updates, etc.), **PostgreSQL functions + RPC calls** are recommended over GraphQL mutations. Superior in both transaction guarantees and performance.
    5.  **Both APIs Coexistence**: REST API and GraphQL API can **coexist** in the same project. An effective pattern: mobile apps leverage REST simplicity while dashboard UIs leverage GraphQL flexibility.

---

## 31. Database Functions & Triggers Strategy

### Rule 31.1: The Function Security Protocol
-   **Law**: Database functions MUST default to **SECURITY INVOKER**, with `SECURITY DEFINER` limited to minimal necessary use cases. Explicit `search_path` setting is mandatory when using `SECURITY DEFINER`.
-   **Action**:
    1.  **SECURITY INVOKER (Default & Recommended)**: Functions execute with the calling user's privileges. RLS policies are automatically applied, making this the safest option.
    2.  **SECURITY DEFINER (Only When Necessary)**: Functions execute with the creator's privileges, bypassing RLS. Use only in the following cases:
        -   When RLS policies reference other RLS-protected tables (recursion prevention)
        -   Auth Triggers (auto-creating profiles after INSERT to `auth.users`, etc.)
        -   Restricted exposure of FDW foreign table data to public API (see §27.2)
    3.  **Mandatory search_path Setting**: Always set `SET search_path = ''` in `SECURITY DEFINER` functions. This eliminates the risk of attackers manipulating `search_path` to spoof objects.
        ```sql
        CREATE OR REPLACE FUNCTION public.get_user_profile(user_id UUID)
        RETURNS JSONB
        LANGUAGE plpgsql
        SECURITY DEFINER
        SET search_path = ''  -- Mandatory: fix search_path
        AS $$
        BEGIN
          RETURN (SELECT row_to_json(p) FROM public.profiles p WHERE p.id = user_id);
        END;
        $$;
        ```
    4.  **EXECUTE Privilege Management**: All functions in the `public` schema are executable by `anon`/`authenticated` by default. Protect internal-only functions with `REVOKE EXECUTE`.
        ```sql
        REVOKE EXECUTE ON FUNCTION internal.admin_operation FROM anon, authenticated;
        ```
    5.  **Immutable / Stable / Volatile**: Correctly declare the function's side-effect level. `IMMUTABLE` (no side effects, same input = same output) → `STABLE` (read-only) → `VOLATILE` (writes). The PostgreSQL optimizer uses this declaration to optimize queries.

### Rule 31.2: The Trigger Design Protocol
-   **Law**: Database Triggers MUST **prioritize AFTER triggers**, and network communication or heavy processing within trigger functions is prohibited.
-   **Action**:
    1.  **BEFORE vs AFTER**:
        -   **BEFORE**: Use for data validation and normalization (e.g., auto-updating `updated_at`, input sanitization)
        -   **AFTER**: Use for executing side effects (e.g., audit log writes, notification dispatch, related table updates)
    2.  **Lightweight Trigger Functions**: Do **NOT** perform external API calls or HTTP communication within trigger functions. Instead, use `pg_net` for async notifications or insert events into a queue table for Edge Functions processing.
    3.  **FOR EACH ROW vs FOR EACH STATEMENT**: Use `FOR EACH ROW` for row-level processing and `FOR EACH STATEMENT` for post-batch processing.
    4.  **Idempotency**: Design trigger functions to be **idempotent**. They must return safe results even if the same event fires multiple times.
    5.  **Version Control**: Trigger creation and modifications MUST be managed in **migration files** (see §7). Manual creation from the Dashboard is prohibited.
    6.  **Debugging**: Output debug information within triggers using `RAISE NOTICE`. Logs are viewable in the Supabase Dashboard under "Logs > Postgres".

---

## 32. Log Drain & External Observability Strategy

### Rule 32.1: The Log Drain Configuration Protocol
-   **Law**: Send logs, metrics, and traces required for service SLOs, security detection, audit, and incident response to an observability path that supports required querying, correlation, retention, and export. Adopt an external path such as a Log Drain when provider retention is insufficient, centralized SOC or SIEM operation is required, or a contract requires retention.
-   **Action**:
    1.  **Capability Check**: At deployment, verify destination, plan availability, delivery guarantee, retry, ordering, latency, volume limit, and egress cost from current official documentation. Datadog and HTTP endpoints are candidates, not fixed requirements.
    2.  **Retention & Access**: Define retention in Blueprint from data class, investigation window, law, and cost, applying encryption, least privilege, tenant isolation, deletion, and legal hold.
    3.  **Structured Logging**: Use structured fields, severity, trace correlation, and source revision supported by the runtime or logging SDK. Do not mandate one `console.log(JSON.stringify(...))` form.
    4.  **Sensitive Data Filtering**: Allowlist or redact PII, credentials, tokens, and request bodies at the source and test samples and permissions before and after transfer. Do not universally require an Edge Function as a relay.
    5.  **Failure & Cost**: Define detection, buffering, drop policy, and cost ownership for drain failure, duplicates, backpressure, provider outage, and quota exhaustion.
    6.  **Control-Plane API Lifecycle**: When automating log queries, analytics, or audit export through a Management API or equivalent, inventory the endpoint and API version, response schema, pagination, authentication scope, rate and cost limits, deprecation deadline, and consumer owner, then migrate with contract fixtures and shadow comparison or equivalent evidence. As of 2026-07-23, complete the `logs.all` to `logs` migration before removal on 2026-09-23 and validate parity in result count, time range, filters, permissions, and failure alerts. Dashboard visibility is not proof of automation compatibility.

### Rule 32.2: The External Metrics & Alerting Protocol
-   **Law**: Inside or outside the provider, configure metrics and alerts that detect user-visible SLIs, capacity, database health, authentication abuse, and queue or function failure. Adopt external monitoring where cross-system correlation, retention, independence, or team operation creates value.
-   **Action**:
    1.  **Prometheus Metrics API**: Supabase exposes Prometheus-compatible metrics at the `/metrics` endpoint (Beta). CPU usage, I/O, WAL, connection count, and query statistics are scrapeable.
    2.  **OpenTelemetry**: Supabase supports **OpenTelemetry (OTel) integration**. Export logs, metrics, and traces to OTel-compatible tools (Datadog, Honeycomb, Grafana, etc.).
    3.  **Datadog Agent**: Detailed database monitoring via the Datadog Agent is available. Query metrics, samples, and EXPLAIN plan visualization are supported. **The agent must connect directly to the host, bypassing the Dedicated Pooler**.
    4.  **Alert Design**: Define thresholds in Blueprint from SLOs, baselines, capacity headroom, and provider quota. The following are candidate metrics and reference starting points, not Universal fixed values:
        -   **Connection count**: `active_connections / max_connections > 80%` → Warning
        -   **CPU usage**: `> 90%` sustained for 5+ minutes → Critical
        -   **Disk usage**: `> 80%` → Warning, `> 90%` → Critical
        -   **Auth failure rate**: Consecutive failures > 10/min → Brute-force detection alert
        -   **Edge Functions error rate**: `> 5%` → Warning
    5.  **Relationship with §16**: This section complements §16 (Internal Observability). §16 focuses on monitoring within the Supabase Dashboard; §32 focuses on integration with external tools.

---

## 33. Auth Hooks & Custom Claims Strategy

### Rule 33.1: The Custom Access Token Hook Protocol
-   **Law**: For token claims, select Auth Hooks, IdP mapping, server-side authorization lookups, or another method by freshness, token size, revocation, latency, and provider support. Auth Hooks are a candidate for issuance-time claim enrichment.
-   **Action**:
    1.  **Hook Architecture**: The Custom Access Token Hook is a PostgreSQL function executed **immediately before** token issuance. It receives user information and returns JSONB containing custom claims.
        ```sql
        CREATE OR REPLACE FUNCTION public.custom_access_token_hook(event JSONB)
        RETURNS JSONB
        LANGUAGE plpgsql
        SECURITY DEFINER
        SET search_path = ''
        AS $$
        DECLARE
          claims JSONB;
          user_role TEXT;
        BEGIN
          -- Get user role
          SELECT role INTO user_role FROM public.user_roles
            WHERE user_id = (event->>'user_id')::UUID;
          -- Add role to claims
          claims := event->'claims';
          claims := jsonb_set(claims, '{user_role}', to_jsonb(user_role));
          event := jsonb_set(event, '{claims}', claims);
          RETURN event;
        END;
        $$;
        ```
    2.  **Hook Activation**: Enable via Dashboard "Authentication > Hooks". For self-hosted environments, configure via environment variables:
        -   `GOTRUE_HOOK_CUSTOM_ACCESS_TOKEN_ENABLED=true`
        -   `GOTRUE_HOOK_CUSTOM_ACCESS_TOKEN_URI=pg-functions://<schema>/<function_name>`
    3.  **Reserved Claims**: Do **NOT overwrite** Supabase reserved claims (`iss`, `sub`, `aud`, `exp`, `iat`, `role`, `email`, etc.). Add custom claims within `app_metadata` or as custom keys.
    4.  **Performance**: The hook function executes on every token issuance. **Keep it lightweight** and avoid heavy queries or network communication.

### Rule 33.2: The Auth Trigger Protocol
-   **Law**: For processing linked to auth events, select database triggers, Auth Hooks, webhooks, queues/workflows, or equivalent by transaction coupling, failure isolation, retries, and managed-schema boundaries.
-   **Action**:
    1.  **Profile Auto-Creation**: Trigger pattern for auto-creating profile table entries on new user registration:
        ```sql
        CREATE OR REPLACE FUNCTION public.handle_new_user()
        RETURNS TRIGGER
        LANGUAGE plpgsql
        SECURITY DEFINER
        SET search_path = ''
        AS $$
        BEGIN
          INSERT INTO public.profiles (id, full_name, avatar_url)
          VALUES (NEW.id, NEW.raw_user_meta_data->>'full_name', NEW.raw_user_meta_data->>'avatar_url');
          RETURN NEW;
        END;
        $$;
        CREATE TRIGGER on_auth_user_created
          AFTER INSERT ON auth.users
          FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
        ```
    2.  **Privilege Boundary**: When adopting a managed-auth-schema trigger, verify current provider support and apply minimum owner/grants, a safe search path, and failure tests. `SECURITY DEFINER` is an exception whose need must be proven.
    3.  **Error Handling**: Errors within trigger functions cause the original auth operation to rollback. Handle errors appropriately with `BEGIN...EXCEPTION` blocks to prevent entire auth flow failures.
    4.  **Migration Management**: Auth Trigger creation and modifications MUST be managed in migration files (see §7, §31.2).

---

## 34. Self-hosted & Email Configuration Strategy

### Rule 34.1: The Self-hosted Deployment Protocol
-   **Law**: When self-hosting, select the current official distribution, Kubernetes/container platform, Compose, or another topology by supportability, HA, upgrades, backups, security, and observability, and explicitly own every responsibility previously carried by the managed service.
-   **Action**:
    1.  **Capacity Requirements**: Capacity-plan per-component CPU, memory, storage, IOPS, connections, replicas, and growth from load tests and RPO/RTO. Do not put fixed minimums in Universal.
    2.  **Critical Environment Variables**: The following environment variables MUST be changed from default values:
        -   `POSTGRES_PASSWORD`: Strong password
        -   `JWT_SECRET`: Minimum 32-character random string
        -   `ANON_KEY` / `SERVICE_ROLE_KEY`: Keys generated from JWT_SECRET
        -   `DASHBOARD_USERNAME` / `DASHBOARD_PASSWORD`: Supabase Studio authentication
    3.  **Transport Security**: Use an approved load balancer, gateway, reverse proxy, or equivalent to manage current TLS, certificate rotation, security headers, and the trusted proxy chain. Caddy and Nginx are examples.
    4.  **Data Persistence**: Configure data persistence with Docker volumes. The default setup where data is lost on `docker-compose down` is unacceptable for production.
    5.  **Update Strategy**: Regularly update Docker images for each Supabase component (GoTrue, PostgREST, Realtime, etc.). Version pinning (`:latest` tag prohibited) is recommended.
    6.  **Gateway Lifecycle**: Inventory the API gateway, image, configuration, routes, TLS termination, auth callbacks or SSO, header normalization, client IP, admin endpoints, plugins or custom policies, and operational tooling as one compatibility unit. Before a default-gateway change, compare the current official distribution and validate positive and negative route tests, canary, and rollback. Product names such as Kong or Envoy are time-dependent implementation examples; treat a legacy-gateway override as a migration mechanism with an owner and expiry.

### Rule 34.2: The Email & SMTP Configuration Protocol
-   **Law**: Production email uses a provider and branded templates appropriate to volume, deliverability, regional/privacy requirements, bounce/complaint handling, SLA, and cost. Do not mandate external SMTP when built-in delivery meets effective requirements.
-   **Action**:
    1.  **Effective Capability**: Verify current built-in/custom SMTP quotas, deliverability, and support conditions from official documentation and effective settings; migrate to an external provider when required.
    2.  **SMTP Configuration**: Configure via Dashboard "Authentication > SMTP Settings" or environment variables:
        -   `SMTP_HOST`, `SMTP_PORT`, `SMTP_USER`, `SMTP_PASS`
        -   `SMTP_SENDER_NAME`: Sender display name
        -   `SMTP_ADMIN_EMAIL`: From email address
    3.  **Email Templates**: Customize the following email templates:
        -   Signup confirmation email
        -   Password reset email
        -   Invitation email
        -   Email change confirmation email
    4.  **Go Template Syntax**: Templates use Go template syntax. Variables like `{{ .ConfirmationURL }}`, `{{ .Token }}`, `{{ .SiteURL }}` are available.
    5.  **Deliverability**: Configure SPF, DKIM, and DMARC records on the sending domain to maximize email deliverability. Misconfiguration causes emails to be classified as spam.

---

## 35. SSR & Framework Integration Strategy

### Rule 35.1: The @supabase/ssr Client Design Protocol
-   **Law**: In SSR/server-rendered frameworks, use a current official adapter or equivalent implementation that provides server-readable sessions, secure cookie attributes, refresh, request isolation, and CSRF/XSS boundaries. `@supabase/ssr` is a candidate for supported JavaScript frameworks, not a requirement for every language.
-   **Action**:
    1.  **Browser Client**: Use `createBrowserClient` for client components.
        ```typescript
        // lib/supabase/client.ts
        import { createBrowserClient } from '@supabase/ssr';
        export function createClient() {
          return createBrowserClient(
            process.env.NEXT_PUBLIC_SUPABASE_URL!,
            process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
          );
        }
        ```
    2.  **Server Client**: Use `createServerClient` for Server Components / Server Actions / Route Handlers. Cookie read/write is performed via `cookies()`.
        ```typescript
        // lib/supabase/server.ts
        import { createServerClient } from '@supabase/ssr';
        import { cookies } from 'next/headers';
        export async function createClient() {
          const cookieStore = await cookies();
          return createServerClient(
            process.env.NEXT_PUBLIC_SUPABASE_URL!,
            process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
            { cookies: {
                getAll: () => cookieStore.getAll(),
                setAll: (cookiesToSet) => {
                  cookiesToSet.forEach(({ name, value, options }) =>
                    cookieStore.set(name, value, options));
                },
              },
            }
          );
        }
        ```
    3.  **Storage Boundary**: When the server needs the session, use cookies designed with HttpOnly, Secure, SameSite, and related controls or a framework-supported server session. A client-only public token may use another storage mechanism if its threat model permits.
    4.  **@supabase/auth-helpers Deprecated**: The legacy package `@supabase/auth-helpers-nextjs` is deprecated. Migrate to `@supabase/ssr`.

### Rule 35.2: The Middleware Auth Guard Protocol
-   **Law**: Middleware, server hooks, gateways, and equivalent layers are candidates for session refresh and early route gating. Always re-verify authorization at the resource access boundary and never make the routing layer the sole defense.
-   **Action**:
    1.  **Session Refresh Middleware**: Refresh expired sessions in Middleware. This ensures sessions are up-to-date before reaching Server Components.
        ```typescript
        // middleware.ts
        import { createServerClient } from '@supabase/ssr';
        import { NextResponse, type NextRequest } from 'next/server';
        export async function middleware(request: NextRequest) {
          let response = NextResponse.next({ request });
          const supabase = createServerClient(
            process.env.NEXT_PUBLIC_SUPABASE_URL!,
            process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
            { cookies: {
                getAll: () => request.cookies.getAll(),
                setAll: (cookiesToSet) => {
                  cookiesToSet.forEach(({ name, value, options }) => {
                    request.cookies.set(name, value);
                    response.cookies.set(name, value, options);
                  });
                },
              },
            }
          );
          const { data: { user } } = await supabase.auth.getUser();
          if (!user && request.nextUrl.pathname.startsWith('/dashboard')) {
            return NextResponse.redirect(new URL('/login', request.url));
          }
          return response;
        }
        ```
    2.  **Defense in Depth**: Middleware carries bypass vulnerability risks (e.g., CVE-2025-29927). **Always verify authentication via `getUser()` at the data access layer as well**. Position Middleware as an optimization layer, not the sole line of defense.
    3.  **Route Matcher**: Exclude static assets (`_next/static`, `favicon.ico`, etc.) from Middleware via `matcher` configuration to optimize performance.

---

## 36. Database Extensions Management Strategy

### Rule 36.1: The Extension Governance Protocol
-   **Law**: Database Extensions MUST be **enabled only as minimally needed**, and enable/disable operations MUST be managed in **migration files**.
-   **Action**:
    1.  **Principle of Least Privilege**: Do not enable unnecessary extensions. Each extension increases memory consumption on DB connections and the security attack surface.
    2.  **Migration Management**: Record extension enablement in migrations:
        ```sql
        -- Migration: Enable PostGIS
        CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA extensions;
        -- Migration: Enable pg_trgm (text similarity search)
        CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA extensions;
        ```
    3.  **Schema Isolation**: Extensions should be created in the `extensions` schema (Supabase default). This prevents function pollution in the `public` schema.
    4.  **Recommended Extensions**:
        -   **pg_stat_statements**: Query statistics (detailed in §36.2) — enabled by default
        -   **pgvector**: Vector similarity search (see §17)
        -   **postgis**: Geospatial data
        -   **pg_trgm**: Trigram-based text search and similarity calculation
        -   **pg_net**: Async HTTP communication
        -   **pgjwt**: JWT generation and verification
        -   **uuid-ossp / pgcrypto**: UUID generation and encryption

### Rule 36.2: The pg_stat_statements Performance Protocol
-   **Law**: Leverage **pg_stat_statements** to continuously monitor query performance and identify and optimize bottlenecks.
-   **Action**:
    1.  **Enabled by Default**: `pg_stat_statements` is enabled by default on Supabase projects.
    2.  **Slow Query Detection**: Identify the longest-running queries with the following:
        ```sql
        SELECT query, calls, total_exec_time, mean_exec_time, rows
        FROM pg_stat_statements
        ORDER BY mean_exec_time DESC
        LIMIT 20;
        ```
    3.  **High-Frequency Query Detection**: Frequently executed queries are also optimization targets:
        ```sql
        SELECT query, calls, total_exec_time, rows
        FROM pg_stat_statements
        ORDER BY calls DESC
        LIMIT 20;
        ```
    4.  **Statistics Reset**: Reset statistics after deployments or schema changes to obtain fresh performance data:
        ```sql
        SELECT pg_stat_statements_reset();
        ```
    5.  **Periodic Review**: Review slow query reports weekly or monthly to identify opportunities for index additions or query rewrites. Use in conjunction with §4 (Performance).

---

## 37. Client SDK Best Practices Strategy

### Rule 37.1: The Error Handling & Retry Protocol
-   **Law**: Explicitly handle the success/error contract of the selected SDK or protocol, and retry only idempotent transient failures. The `data`/`error` result in `supabase-js` is one example.
-   **Action**:
    1.  **Structured Error Handling**: `supabase-js` queries return `data` and `error`. Always check `error`:
        ```typescript
        const { data, error } = await supabase
          .from('profiles')
          .select('*')
          .eq('id', userId);
        if (error) {
          console.error('Query failed:', error.message, error.code);
          // Display appropriate error message to user
          throw new AppError('Failed to fetch profile');
        }
        ```
    2.  **Auth-Specific Errors**: For Auth operations, distinguish `AuthError` class subtypes (`AuthApiError`, `AuthRetryableFetchError`, etc.) to determine retryability.
    3.  **Edge Functions Errors**: Distinguish between `FunctionsHttpError` (function returned an error), `FunctionsRelayError` (network issue with Supabase), and `FunctionsFetchError` (function unreachable).
    4.  **Retry Logic**: Derive jittered backoff, maximum attempts, and circuit breaking from error classification, operation idempotency, dependency SLO, business deadline, and retry budget. Do not put a fixed three attempts in Universal.
    5.  **Timeouts**: Allocate the end-to-end latency budget across DNS, connect, request, stream, and downstream work, and propagate abort/cancellation. Do not apply a fixed five seconds to every API.

### Rule 37.2: The Realtime Subscription Lifecycle Protocol
-   **Law**: Clean up Realtime subscriptions when the owning component, view, process, socket, or background state ends, and contract reconnection, deduplication, ordering, and rate control.
-   **Action**:
    1.  **Subscription Cleanup**: In React, unsubscribe in the `useEffect` cleanup function:
        ```typescript
        useEffect(() => {
          const channel = supabase
            .channel('messages')
            .on('postgres_changes',
              { event: 'INSERT', schema: 'public', table: 'messages' },
              (payload) => setMessages(prev => [...prev, payload.new])
            )
            .subscribe();
          return () => { supabase.removeChannel(channel); };
        }, []);
        ```
    2.  **REPLICA IDENTITY**: To receive full column data for `UPDATE`/`DELETE` events in Realtime, set `REPLICA IDENTITY FULL` on target tables:
        ```sql
        ALTER TABLE public.messages REPLICA IDENTITY FULL;
        ```
    3.  **High-Frequency Update Control**: Derive throttling, debouncing, sampling, or aggregation intervals from UX latency, loss tolerance, quotas, and device performance.
    4.  **Channel Status Monitoring**: Monitor channel status via `channel.on('system', ...)` and provide connection state feedback to users.
    5.  **RLS Application**: Apply access policies at both channel and table levels for Realtime data (see §3, §14).

### Rule 37.3: Client Library Support Surface Protocol
-   **Law**: Do not reduce “Supabase supports this language” to one Boolean value. Inventory REST, Realtime, Auth, Storage, Functions invocation, and other capabilities separately from browser, server, mobile, or desktop targets, official versus community support authority, maturity, feature parity, release cadence, and security response.
-   **Current Snapshot**: As of 2026-07-23, the official Client Libraries page classifies JavaScript or TypeScript, Dart or Flutter, Swift, and Python as official libraries, and C#, Go, Kotlin, Ruby, GDScript, Elixir, and R as community libraries. This is not a future guarantee; revalidate the official list, repository activity, release notes, and supported capabilities at adoption and major-upgrade boundaries.
-   **Adoption Evidence**: For each adopted client, record session and credential storage, SSR or mobile lifecycle, type mapping, Realtime reconnection, uploads, error and retry semantics, offline behavior, supported platforms, EOL, and the test matrix. Do not assume identical feature parity even for official clients. For a community client, add an accountable owner, upstream-continuity assessment, and a fallback through direct protocol, generated client, or a service boundary.
-   **Language-Native Gates**: TypeScript or JavaScript, Swift, Kotlin, Dart, Python, and other code inherit native gates from `engineering/320_programming_language_governance.md` and the relevant language canon. A client library does not imply Edge Functions execution-runtime support; verify the Deno-compatible TypeScript or JavaScript runtime, PostgreSQL or SQL, and client SDK as separate surfaces.

---

## 38. Schema Design Patterns Strategy

### Rule 38.1: The Soft Delete & Data Lifecycle Protocol
-   **Law**: Select hard delete, soft delete, tombstone, anonymization, or legal hold per data category. Soft delete is a candidate for restore/audit needs, but does not satisfy privacy deletion by itself and is not universal for all data.
-   **Action**:
    1.  **Deletion Representation**: For a data category that selects soft delete, contract an explicit marker such as `deleted_at`, actor, reason, restore privilege, uniqueness, cascading behavior, and retention. Do not force a marker on data that selects hard deletion.
    2.  **Active Records Boundary**: When soft delete is selected, design one source of truth such as a query, view, or repository that returns only active data. The following is a view example:
        ```sql
        CREATE VIEW public.active_profiles AS
          SELECT * FROM public.profiles WHERE deleted_at IS NULL;
        ```
    3.  **Authorization Alignment**: Deny ordinary access to soft-deleted records in policy and separate restore, audit, and legal-hold privileges. The following is an RLS example:
        ```sql
        CREATE POLICY "Hide soft-deleted rows" ON profiles
          FOR SELECT USING (deleted_at IS NULL);
        ```
    4.  **Restore Contract**: If restore is offered, design its privilege, window, uniqueness conflicts, related data, and audit. Do not force a UI on a non-restorable category.
    5.  **Final Disposition**: Anonymize or physically delete through a scheduler, queue, lifecycle job, or equivalent according to retention, legal hold, privacy deletion, and backup expiry. Do not make a fixed duration or `pg_cron` a Universal requirement.

### Rule 38.2: The Audit Trail & JSONB Design Protocol
-   **Law**: Track data change history with **Audit Trails** and use **JSONB** appropriately for flexible metadata.
-   **Action**:
    1.  **Audit Mechanism Selection**: Choose `supa_audit`, custom triggers, application events, logical decoding, provider logs, or an equivalent by required actor and before-after data, tamper resistance, throughput, retention, and queryability. Do not disable audit at a fixed operations threshold; use load tests and compliance requirements to design sampling, asynchronous delivery, or a separate sink.
    2.  **Custom Audit Trail**: When `supa_audit` is insufficient, create a trigger-based custom audit table:
        ```sql
        CREATE TABLE public.audit_log (
          id BIGSERIAL PRIMARY KEY,
          table_name TEXT NOT NULL,
          record_id UUID NOT NULL,
          action TEXT NOT NULL CHECK (action IN ('INSERT','UPDATE','DELETE')),
          old_data JSONB,
          new_data JSONB,
          changed_by UUID REFERENCES auth.users(id),
          changed_at TIMESTAMPTZ DEFAULT NOW()
        );
        ```
    3.  **JSONB Usage Criteria**: Use JSONB for:
        -   Metadata with variable schema (webhook payloads, etc.)
        -   Fields where frequent schema changes are expected
        -   **NOT recommended**: Data that is frequently queried/filtered → use normalized columns
    4.  **JSONB Indexing**: Set up GIN indexes on JSONB columns:
        ```sql
        -- For containment queries (@>)
        CREATE INDEX idx_metadata ON products USING GIN (metadata jsonb_path_ops);
        -- For frequently accessed keys
        CREATE INDEX idx_metadata_status ON products ((metadata->>'status'));
        ```
    5.  **pg_jsonschema**: Implement JSONB data validation with the `pg_jsonschema` extension to strengthen data integrity.

---

## 39. Social Auth & OAuth Provider Strategy

### Rule 39.1: The OAuth Provider Configuration Protocol
-   **Law**: When implementing social logins such as Google/Apple/GitHub, you MUST follow **provider-specific best practices** and securely manage Callback URLs and client secrets.
-   **Action**:
    1.  **Callback URL Standard Format**: The Callback URL to set in each provider's OAuth app is `https://<project-ref>.supabase.co/auth/v1/callback`.
    2.  **Google OAuth**: Configure the "OAuth Consent Screen" in Google Cloud Console and issue separate Client IDs for Web, iOS, and Android. Invoke with `signInWithOAuth({ provider: 'google' })`.
    3.  **Apple Sign In**: Issue a Service ID and Key for "Sign In with Apple" in the Apple Developer Portal. **Apple Review Requirement**: If offering Apple Sign In, it must be placed prominently (HIG compliance).
    4.  **GitHub OAuth**: Create an "OAuth App" in GitHub Developer Settings and obtain the Client ID and Client Secret.
    5.  **Secret Management**: Store Client Secrets only in the Supabase Dashboard Provider settings. **Never hardcode in code**. Do not store in environment variables either (managed by Supabase).
    6.  **Scope Minimization**: Keep the scopes (permissions) requested from each provider to the absolute minimum. Excessive scopes erode user trust.

### Rule 39.2: The SAML SSO & Mobile Deep Linking Protocol
-   **Law**: Configure enterprise SSO reproducibly and audibly through the current provider control plane, API, CLI, IaC, or another approved path; mobile redirects prefer verified Universal Links/App Links or an equivalent secure callback.
-   **Action**:
    1.  **SAML SSO Setup**: SAML 2.0 is available on Team/Enterprise plans. Configure with CLI v1.46.4+:
        ```bash
        # Add SSO connection with IdP metadata URL
        supabase sso add --type saml \
          --metadata-url "https://idp.example.com/metadata" \
          --domains "example.com"
        ```
    2.  **SAML Enablement**: Enable SAML 2.0 on the Auth Providers page in the Dashboard (disabled by default).
    3.  **Domain Association**: Multiple email domains can be associated with an SSO provider. Configure auto-join and default roles.
    4.  **Mobile Deep Linking**: For mobile apps, set up Deep Links for email confirmation, password reset, and OAuth redirects:
        ```typescript
        // React Native / Expo
        const { data, error } = await supabase.auth.signInWithOAuth({
          provider: 'google',
          options: { redirectTo: 'com.myapp://auth/callback' }
        });
        ```
    5.  **Redirect URL Registration**: Register app schemes (`com.myapp://**`) in the Supabase Dashboard Auth settings as Redirect URLs. Wildcards are supported.
    6.  **Universal Links (Recommended)**: For iOS, use Universal Links (`.well-known/apple-app-site-association`); for Android, use App Links (`assetlinks.json`). These are more secure than Custom URL Schemes.

---

## 40. Data Migration & Seeding Strategy

### Rule 40.1: The Database Migration Protocol
-   **Law**: Select a migration method from source/target engines, data volume, tolerated downtime, change rate, consistency, encryption, and rollback requirements. Procedures MUST be documented and reproducible. `pg_dump`/`pg_restore` is a strong option for compatible PostgreSQL paths, not a universal requirement.
-   **Action**:
    1.  **Discovery and Plan**: Inventory extensions, types, constraints, triggers, functions, roles, grants, RLS, identities, large objects, sequences, and integrations. Define mapping, cutover, rollback, data validation, and owners.
    2.  **Compatible PostgreSQL Example**: For a PostgreSQL path whose compatibility is verified, consider `supabase db dump` or `pg_dump`/`pg_restore`:
        ```bash
        # Schema only
        pg_dump --schema-only --no-owner --no-privileges \
          -d "postgresql://user:pass@host:5432/db" > schema.sql
        # Data only
        pg_dump --data-only --no-owner \
          -d "postgresql://user:pass@host:5432/db" > data.sql
        ```
    3.  **Heterogeneous or Online Migration**: For heterogeneous engines, low downtime, continuous changes, or high volume, compare verified ETL, CDC, logical replication, bulk loaders, and staged dual runs. Tools and size thresholds belong to benchmarks and Blueprint.
    4.  **Security Reconciliation**: Dump coverage and restore behavior vary by option and version. Reconcile roles, grants, RLS, Auth identities, secrets, ownership, and extensions in a separate inventory while preserving default deny.
    5.  **Validation and Cutover**: Record checksums or samples, constraints, sequences, permissions, application contracts, performance, RPO/RTO, and rollback rehearsal in approval evidence, not only row counts.

### Rule 40.2: The Seed Data Management Protocol
-   **Law**: Keep initial/reference/test data separate in responsibility from schema migrations and make it reproducible through a version-controlled approved seed artifact, factory, snapshot, or equivalent. `supabase/seed.sql` is a CLI-default candidate.
-   **Action**:
    1.  **Seed Discovery**: Declare seed order, environment eligibility, and checksums through the current CLI `seed_paths` configuration or an equivalent manifest; do not make one path a Universal requirement.
    2.  **Schema Separation**: seed.sql should contain **data INSERTs only**. Table definitions and ALTER statements belong in migration files (see §7).
    3.  **Modularization**: For large seed datasets, split into multiple files and configure in `config.toml`:
        ```toml
        [db]
        seed_paths = ["./supabase/seeds/users.sql", "./supabase/seeds/products.sql"]
        ```
    4.  **Idempotency**: Write seed data with `INSERT ... ON CONFLICT DO NOTHING` for idempotency. Multiple executions should not cause errors.
    5.  **Environment-Specific Seeds**: Separate development dummy data from production initial master data, switching via environment variables or scripts. Production seeds are subject to auditing.

---

## 41. Multigres & Horizontal Scaling Strategy

### Rule 41.1: The Multigres Architecture Protocol
-   **Law**: When measured capacity approaches single-PostgreSQL limits, compare partitioning, read replicas, workload separation, distributed PostgreSQL/sharding, and other options. Adopt emerging options such as Multigres only after verifying current maturity, support, migration, consistency, and exit.
-   **Action**:
    1.  **Current Capability Evidence**: Verify delivery stage, preview or GA status, plan, region, support, and constraints for connection management, HA, failover, sharding, and related capabilities from current official documentation and experiments at adoption time; do not treat a roadmap as a guarantee.
    2.  **Shard Key Design**: Select a shard key from query and transaction locality, cardinality, growth, hotspots, residency, rebalancing, and cross-shard cost. Tenant ID and user ID are candidates; do not reject any type, including random UUID, by name alone.
    3.  **Application Compatibility**: Test driver, Data API, SDK, transaction, sequence, extension, migration, observability, and backup compatibility. Do not assume application transparency or zero changes to existing code.
    4.  **Co-location Contract**: Co-locate data that measured workloads require in the same transaction or frequent join. Do not unconditionally pin every parent-child relation or all tenant data to one shard.
-   **Rationale**: Multigres is designed as "Vitess for Postgres", applying the sharding technology that scaled YouTube to PostgreSQL. However, for most applications, partitioning (§2.13) and Read Replicas (§49) are sufficient.

### Rule 41.2: The OrioleDB Storage Engine Protocol
-   **Law**: Understand the characteristics of Supabase's next-generation storage engine **OrioleDB** and make informed adoption decisions based on workload requirements.
-   **Action**:
    1.  **Table AM Selection**: OrioleDB operates as a PostgreSQL Table Access Method (AM). Enable it per-table by specifying `USING orioledb` at table creation time.
    2.  **Write-Heavy Optimization**: OrioleDB uses an undo log approach, providing VACUUM-free performance for write-heavy workloads.
    3.  **Maturity Assessment**: OrioleDB is an evolving technology. Before production adoption, thoroughly test compatibility and prepare fallback plans.

---

## 42. PostgreSQL 18 New Features Strategy

### Rule 42.1: The Asynchronous I/O (AIO) Optimization Protocol
-   **Law**: When the effective database version, provider support, OS, and configuration allow it, treat PostgreSQL 18 AIO as a candidate and adopt it only after measuring benefit and regression on representative workloads.
-   **Action**:
    1.  **Capability Check**: Verify the current PostgreSQL version, Supabase plan and region, I/O method, OS kernel, parameters, and rollback from official documentation and effective settings. Do not assume it is automatically enabled in a managed environment.
    2.  **Benchmark**: Compare throughput, p95 and p99 latency, CPU, I/O wait, and cost for representative sequential scan, VACUUM, and concurrent OLTP workloads; do not use a published multiplier as a guarantee.
    3.  **Monitoring**: Observe benefit and saturation through available telemetry such as `pg_stat_io` and provider metrics, preserving upgrade and configuration evidence.

### Rule 42.2: The UUIDv7 Migration Protocol
-   **Law**: Select identifiers from ordering, hotspot, privacy, offline generation, interoperability, index locality, and runtime support. UUIDv7 is a strong PostgreSQL 18 candidate, not a universal requirement for every new table.
-   **Action**:
    1.  **UUIDv7 Candidate**: Evaluate `uuidv7()` when time-ordered locality and distributed generation fit the requirement and the effective version supports it. The following is an example:
        ```sql
        CREATE TABLE public.new_table (
          id UUID PRIMARY KEY DEFAULT uuidv7(),
          created_at TIMESTAMPTZ DEFAULT NOW()
        );
        ```
    2.  **Trade-off Measurement**: Compare insert locality, index size, page splits, write hotspots, identifier enumeration, and clock behavior with ULID, UUIDv4, sequences, compound keys, and other candidates.
    3.  **Migration Strategy**: Evaluate effects on foreign keys, external contracts, replication, and rollback, and migrate an existing identifier only when business value is proven. Coexistence and no change are valid outcomes.
    4.  **Compatibility Verification**: PostgreSQL UUID type compatibility does not prove application, serializer, SDK, downstream, or ordering-semantics compatibility; run contract tests.

### Rule 42.3: The B-tree Skip Scan Protocol
-   **Law**: Treat PostgreSQL 18 B-tree Skip Scan as one possible planner choice and make existing or additional index decisions from execution plans and measurement.
-   **Action**:
    1.  **Planner Choice**: Even for `WHERE b = ...` on `(a, b)`, statistics, NDV, cost, and cache state may lead to Skip Scan, another index, or Seq Scan; do not guarantee automatic adoption.
    2.  **Index Design Impact**: Decide index order and additional indexes from leading-column NDV, major predicates, sorting, write amplification, storage, and maintenance together.
    3.  **EXPLAIN Verification**: Compare representative data and parameters with `EXPLAIN (ANALYZE, BUFFERS)` or an equivalent, recording plan shape, row estimates, latency, and I/O.

---

## 43. Column-Level Security Strategy

### Rule 43.1: The Column-Level Privilege Protocol
-   **Law**: Implement **Column-Level Privileges** in addition to RLS for defense in depth on sensitive columns.
-   **Action**:
    1.  **GRANT/REVOKE per Column**: Control access to sensitive columns per-role:
        ```sql
        REVOKE SELECT ON public.employees FROM authenticated;
        GRANT SELECT (id, name, department, title) ON public.employees TO authenticated;
        GRANT SELECT (salary, ssn, internal_notes) ON public.employees TO admin_role;
        ```
    2.  **View-Based Alternative**: Separate views for public and admin use when CLP management is complex.
    3.  **Trigger-Based Protection**: Use `BEFORE UPDATE` triggers to detect and reject unauthorized column changes.
    4.  **RLS Complementarity**: CLS **complements** RLS. Combine RLS (which rows) + CLS (which columns) for complete protection.

---

## 44. Passkeys & Biometric Authentication Strategy

### Rule 44.1: The WebAuthn / Passkeys Integration Protocol
-   **Law**: When implementing passwordless authentication via **Passkeys (WebAuthn/FIDO2)**, follow Supabase Auth integration patterns for phishing-resistant flows.
-   **Action**:
    1.  **Integration Options**: Choose from 1Password Passkey Flex, Corbado/Descope, or Custom WebAuthn implementations.
    2.  **Credential Storage**: Store Passkey public keys in a dedicated table with FK to `auth.users`:
        ```sql
        CREATE TABLE public.passkey_credentials (
          id UUID PRIMARY KEY DEFAULT uuidv7(),
          user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
          credential_id TEXT NOT NULL UNIQUE,
          public_key BYTEA NOT NULL,
          counter BIGINT DEFAULT 0,
          device_type TEXT,
          created_at TIMESTAMPTZ DEFAULT NOW()
        );
        ALTER TABLE public.passkey_credentials ENABLE ROW LEVEL SECURITY;
        ```
    3.  **Fallback Auth**: Maintain traditional Email/Password authentication as a **fallback**.
    4.  **MFA Complementarity**: Combine with `aal2` level MFA (§18.2) for high-security requirements.

---

## 45. MCP Server & AI Development Integration Strategy

### Rule 45.1: The Supabase MCP Server Protocol
-   **Law**: If Supabase MCP is adopted, treat it as a least-privilege development-assistance boundary separated from ordinary production access. MCP is optional; Blueprint must show that its value outweighs expanded access, data exposure, prompt-injection, misoperation, and audit risks.
-   **Action**:
    1.  **Current Capability Check**: Revalidate remote/local availability, authentication, tool scope, read-only options, and project scope against current official documentation, then select the mode that fits the environment and threat model.
    2.  **Permitted Operations**: Table design, data queries (read-only), migration assistance, Edge Functions scaffolding.
    3.  **Prohibited Operations**: Direct production data modification, unreviewed RLS policy application, Service Role key usage, backup/restore operations.
    4.  **Project-scoped Access**: Use Project-scoped Roles (§50) for MCP connections with minimum privileges.
    5.  **Audit Trail**: Log all MCP operations for AI-generated SQL traceability.

---

## 46. Security Advisor & Auto-Remediation Strategy

### Rule 46.1: The Security Advisor Compliance Protocol
-   **Law**: Triage Supabase **Security Advisor** findings through the §0.1 risk-based gate. Do not release with an unresolved applicable Critical or High finding or an unexplained finding.
-   **Action**:
    1.  **Risk-Based Scan**: Run after schema, policy, extension, or privilege changes and on a risk-based Blueprint cadence; integrate with CI or release evidence where possible.
    2.  **Disposition**: Prioritize by severity, reachability, data sensitivity, exploitability, false positive, owner, expiry, and compensating control. Fixed response SLAs belong in Blueprint.
    3.  **AI-Assisted Fix**: Use AI fix suggestions as reference only. **Applying without review is prohibited**.
    4.  **Baseline Maintenance**: Track finding state, rationale, owner, and expiry in addition to counts; a lower count alone is not proof of safety.

---

## 47. Per-Table API Control & Data API Disable Strategy

### Rule 47.1: The Granular API Exposure Protocol
-   **Law**: Design Data API exposure deny-by-default through separate controls for exposed schemas, schema/table/function grants, RLS, column privileges, and API configuration. Defaults such as automatic exposure of new tables can change by version or project setting; verify effective behavior when objects are created.
-   **Action**:
    1.  **Exposure Inventory**: Inventory exposed schemas and API-reachable tables, views, and functions in machine-readable form; migration tests prove only intended objects are reachable.
    2.  **Default Deny**: Do not expose a new object until it has an explicit API contract, least-privilege grants, RLS or column privileges, and negative tests.
    3.  **Data API Disable**: Evaluate disabling the Data API when a workload does not need it, after assessing management, SDK, integration, and rollback effects.
    4.  **API Layer Architecture**: Compare direct Data API, Edge Functions, and a custom API gateway by authorization, validation, latency, cost, and portability.

---

## 48. VPC & Private Link Strategy

### Rule 48.1: The Network Isolation Protocol
-   **Law**: Combine private connectivity, network restrictions, TLS, and identity-aware access according to data sensitivity and threat model, minimizing public exposure.
-   **Action**:
    1.  **Private Connectivity**: When the plan, region, and network topology support it, evaluate PrivateLink or an equivalent. Authentication, encryption, DNS, egress, and provider control-plane risks remain on a private path.
    2.  **Network Restriction**: Apply IP or CIDR restrictions where stable source identity can be proven through static egress, VPN, or private connectivity. Do not place dynamic CI in broad allowlists; evaluate federated identity, ephemeral runners, or proxies.
    3.  **TLS Enforcement**: Verify the current TLS contract for the provider or self-hosted topology and require encrypted connections with certificate verification. A private network is not a reason for plaintext.
    4.  **Privileged Human Access**: Separate production database human access from normal paths and require MFA, time-bound identity, approval, session audit, least privilege, and revocation. Identity-aware proxies, provider access, bastions, and temporary tokens are candidates; a permanent SSH bastion is not universally required.
    5.  **Zero Trust**: Combine with RLS (§3), CLS (§43), and Data API Hardening (§28) for defense in depth.

---

## 49. Read Replicas & Load Balancing Strategy

### Rule 49.1: The Read Replica Architecture Protocol
-   **Law**: Evaluate read replicas as a candidate for measured read bottlenecks, latency, availability, analytics isolation, or regional requirements. Adopt them only when need and cost-effectiveness are demonstrated.
-   **Action**:
    1.  **Query Routing**: Do not assume provider or pooler auto-routing. Verify current plan and endpoint behavior. Route writes, strong read-after-write, and transactional reads to primary; send only stale-tolerant reads explicitly to replicas by default.
    2.  **Replication Lag Awareness**: Measure asynchronous replication lag and failure modes. Design read-your-writes, session stickiness, primary fallback, or staleness indicators from consistency requirements.
    3.  **Regional Placement**: Decide placement from latency, data residency, failure domains, cross-region transfer cost, and service availability together.
    4.  **Analytics Offloading**: Load-test the isolation benefit and do not assume a replica reduces OLTP impact to zero.
    5.  **Monitoring**: Monitor replication lag, replay failures, connection saturation, primary/replica errors, and fallbacks. Define alert thresholds in Blueprint from SLOs and the data-consistency budget.

---

## 50. Project-scoped Roles & Team Management Strategy

### Rule 50.1: The Project-scoped RBAC Protocol
-   **Law**: Verify current plan availability and effective role capabilities, then minimize privileges for humans, workloads, CI, and AI tools at organization, project, environment, and feature-group boundaries. Never treat a role name alone as proof of safety.
-   **Action**:
    1.  **Capability Inventory**: Reconcile names such as Owner, Administrator, Developer, and Read-Only with current access-control documentation, and record project-scoped-role plan availability and effective permissions, including secret access. Do not assume `Read-Only` means secretless or harmless.
    2.  **Human Access**: Grant only feature groups required by job function. Apply step-up, approval, time-bound elevation, and break-glass to production write, secrets, billing, and member management. Blanket roles for all developers are prohibited.
    3.  **Workload Identity**: Do not use personal credentials in CI/CD. Use dedicated identities restricted by environment and job, short-lived or revocable credentials, protected contexts, rotation, and audit.
    4.  **Lifecycle Review**: Update access immediately on joiner, mover, and leaver events, and review unused or over-privileged access at a cadence based on inventory, usage telemetry, risk, and compliance.
    5.  **AI/MCP Integration**: Default AI tools to read-only and explicit project scope, limiting feature groups, data classes, tool calls, and approval boundaries. Do not allow write, DDL, or production-data access without task-specific human approval and audit evidence.

---

## 51. Provider-neutral CI/CD Strategy

### Rule 51.1: The Supabase CI/CD Pipeline Protocol
-   **Law**: Independently of the selected CI/CD provider, integrate migrations, policy tests, function or configuration deployment, and promotion into a version-controlled reproducible pipeline. Production mutations pass protected environments, separation of duties, explicit approval, audit, and concurrency control.
-   **Action**:
    1.  **Pipeline Contract**: Define evidence-producing stages in this order: clean rebuild, migration lint and reset, RLS and permission and data-contract tests, artifact or type-generation drift check, preview or staging apply, production approval, and post-deploy verification.
    2.  **Environment Strategy**: Separate projects, credentials, and data by environment. Adopt branch or preview environments only where plan, cost, PII, test fidelity, and lifecycle fit; do not require one for every pull request.
    3.  **Schema Recovery**: Do not assume automatic reverse rollback is safe for destructive migrations. Define expand-contract, backward-compatible application behavior, backup or restore, forward-fix, and deployment halt by change class.
    4.  **Credential Management**: Use the CI provider's approved secret store or federated or short-lived identity, and never expose privileged keys to repositories, workflows, logs, or preview clients.
    5.  **Deployment Evidence**: Record source revision, migration checksums, artifact digest, approver, target project and environment, command or tool version, result, and rollback or forward-fix decision, then notify an approved owner channel.

---

## 52. PostgreSQL Advisory Locks & Concurrency Control Strategy

### Rule 52.1: The Advisory Lock Architecture Protocol
-   **Law**: For exclusion, leader election, or duplicate prevention, select a coordination mechanism such as transaction row locks, unique constraints, leases, queue guarantees, idempotency keys, or advisory locks that fits the failure model and ownership. Advisory locks are a candidate when an application-defined resource stays within one PostgreSQL boundary.
-   **Action**:
    1.  **Session vs Transaction Locks**: Treat transaction locks as the safer default candidate. Use session locks only after proving pool session affinity, disconnect, timeout, cleanup, and ownership transfer; a long batch alone is not sufficient reason.
    2.  **Acquisition Policy**: Match blocking or try-lock, timeout, retry, skip, and fencing tokens to business semantics, and prohibit unbounded waiting.
    3.  **Lock Key Design**: Define namespace, collision behavior, multi-tenant isolation, and stable 64-bit mapping, with a test that every caller maps one resource to the same key.
    4.  **Deadlock Prevention**: Always acquire multiple Advisory Locks in the same order.
    5.  **Release & Failure**: Test explicit unlock and `finally` behavior for session locks, connection loss, process crash, and pool reuse. Keep transaction duration short and do not casually hold a lock across external side effects.

---

## 53. Webhook Signature & Event-Driven Integration Strategy

### Rule 53.1: The Webhook Security Protocol
-   **Law**: Authenticate webhook origin and payload integrity through the provider contract, using signatures, mTLS, tokens, network controls, or an equivalent, and prevent replay and duplicate side effects. Raw-body signature verification is mandatory when the provider supports signed delivery.
-   **Action**:
    1.  **Provider Verification Contract**: Follow current provider requirements for algorithm, header, canonicalization, key rotation, multiple signatures, and raw body; implement timing-safe comparison and negative tests. HMAC-SHA256 is an example, not a fixed mandate.
    2.  **Replay Window**: Derive the freshness window from provider timestamp behavior, clock skew, delivery retries, and business latency, and combine it with event ID, nonce, signature version, or an equivalent. Do not make five minutes a Universal constant.
    3.  **Idempotency Key**: Record a provider event ID or normalized idempotency key through an atomic unique constraint or equivalent, and design processing state and retries without mistaking side effects for exactly-once delivery.
    4.  **Failure Recovery**: Select a durable inbox, queue, DLQ, replay tool, alert, and manual reconciliation according to delivery guarantees and business criticality, separating acceptance from heavy processing.
    5.  **Schema Evolution**: Validate provider event type and API version, and design unknown-field tolerance, required fields, adapters, contract fixtures, and deprecation migration. Do not assume the receiver can add an arbitrary version to provider payloads.

---

## 54. Advanced Database Partitioning Strategy

### Rule 54.1: The Partitioning Decision Framework
-   **Law**: Decide partitioning from measured query or maintenance bottlenecks, retention deletion, tenant or region isolation, vacuum, indexes, backup, and operational complexity, adopting it when a non-partitioned table cannot meet the SLO rather than at a fixed record count.
-   **Action**:
    1.  **Partition Type Selection**: Range (time-series), List (tenant/region), Hash (uniform distribution).
    2.  **Lifecycle Automation**: Select native automation, `pg_partman`, scheduled migrations, or an equivalent that fits provider support and recovery procedures.
    3.  **Partition Pruning**: Include a partition-key predicate when query semantics permit and verify pruning with `EXPLAIN`. For legitimate all-period queries, design an aggregate, replica, or analytics path.
    4.  **Index Strategy**: Test per-partition indexes, unique-constraint limitations, new-partition application, attach or detach, and restore against the adopted PostgreSQL and automation versions.

---

## 55. Full-Text Search & pg_trgm Strategy

### Rule 55.1: The PostgreSQL Native Search Protocol
-   **Law**: Before adopting external search services (Algolia, Elasticsearch), first consider **PostgreSQL native full-text search** (tsvector/tsquery).
-   **Action**:
    1.  **tsvector Column**: Add generated `tsvector` columns with GIN indexes for searchable tables.
    2.  **Weight System**: Use `setweight` for field prioritization (title > body: A > B > C > D).
    3.  **Locale-Specific Language Support**: Recommend locale-appropriate extensions such as `pgroonga` (§36) when CJK-language full-text search (Japanese, Chinese, Korean) is in scope.
    4.  **pg_trgm for Fuzzy Search**: Use `pg_trgm` (trigram) extension for improved `LIKE '%keyword%'` performance.
    5.  **Hybrid Approach**: Combine `tsvector` (structured) + `pg_trgm` (fuzzy) + `pgvector` (semantic/§17) for multi-layered search.

---

## 56. Supabase AI Assistant & Generated SQL Strategy

### Rule 56.1: The AI-Generated SQL Governance Protocol
-   **Law**: **Prohibit applying AI-generated SQL to production without review** (from Dashboard AI Assistant or MCP Server).
-   **Action**:
    1.  **Review Mandate**: Review AI-generated SQL for RLS impact, performance (EXPLAIN ANALYZE), security, and idempotency (§12.2).
    2.  **Prompt Injection Defense**: Never include user input directly in AI SQL generation prompts.
    3.  **Sandbox Execution**: Execute AI-generated SQL in local environments first before production.
    4.  **Audit**: Annotate AI-generated SQL with source comments (`-- AI-generated: [tool_name] [date]`).

---

## 57. Type-Safe End-to-End Strategy

### Rule 57.1: The Full-Stack Type Safety Protocol
-   **Law**: Build a verifiable data-contract chain from database schema through APIs, events, backend, and clients in adopted languages. Complement boundaries without compile-time types with runtime schemas, contract tests, or generated clients.
-   **Action**:
    1.  **Layer 1 — Schema Contract**: Treat migrations and database schema as authoritative and reproducibly generate client contracts with the selected language's official generator, schema introspection, OpenAPI, or an equivalent. TypeScript generation is one example.
    2.  **Layer 2 — Runtime Validation**: Validate untrusted APIs, events, and database JSON with an approved mechanism such as Zod, JSON Schema, or a language-native validator.
    3.  **Layer 3 — Domain Adapter**: Make required transformations among persistence, domain, transport, and view models explicit, testing nulls, decimals, time, unknown enum values, and PII. Do not universally require fixed layer names or mapped types.
    4.  **Layer 4 — Type Synchronization**: Integrate type generation into CI/CD pipelines (§51).
    5.  **Contract Gap Detection**: Add the adopted language's native compiler, type checker, or schema-compatibility gate to CI. Follow `engineering/320_programming_language_governance.md`.

---

## 58. Global CDN & Edge Caching Strategy

### Rule 58.1: The Edge Caching Architecture Protocol
-   **Law**: Decide public response caching from cacheability, data classification, freshness, invalidation, personalization, version skew, and cost. Optimize origin load and latency after correctness and safety rather than maximizing cache-hit rate.
-   **Action**:
    1.  **Cache-Control Headers**: Define values in Blueprint from content identity and freshness SLO. Immutable content-addressed assets, public images, public APIs, and user-specific or sensitive data require different policies; sample durations are non-normative.
    2.  **Stale-While-Revalidate**: Use stale serving only where stale data is explicitly safe and bounded.
    3.  **Cache Invalidation**: Explicitly purge CDN cache or use version parameters (`?v=hash`) for cache busting.
    4.  **Provider-neutral Integration**: Integration-test cache keys, authentication headers, cookies, purge, signed URLs, and version skew across the adopted CDN or application platform and Supabase Storage or APIs. Cloudflare is one candidate.

---

## 59. Compliance & Data Sovereignty Strategy

### Rule 59.1: The Regulatory Compliance Framework
-   **Law**: Distinguish and identify applicable data-protection law, industry regulation, contractual controls, and assurance frameworks, then implement the shared-responsibility technical and operational controls for Supabase. Do not treat attestations such as SOC 2 as statutes.
-   **Action**:
    1.  **Data Classification**: Classify all data and define encryption, retention, access, residency, deletion, and audit in Blueprint rather than relying on a fixed sensitivity recipe.
    2.  **Region Selection**: Validate PII location against applicable law, contracts, cross-border transfer, subprocessors, backup/replica locations, and current provider region capability with legal/privacy owners. A region name alone is not proof of compliance.
    3.  **DSAR Workflow**: Operationalize the applicable legal deadline, identity verification, exceptions, legal hold, third-party data, and export/deletion scope. RPC is one implementation option; Universal does not impose a fixed 24-hour SLA.
    4.  **SOC2 Alignment**: Implement SOC2 principles (encryption, access control, audit logs, incident response) at the application layer.
    5.  **Cookie Consent**: Coordinate with SSR framework (§35) cookie management; no tracking cookies without user consent.

---

## 60. Supabase Operational Maturity Model

### Rule 60.1: The Maturity Assessment Protocol
-   **Law**: Regularly self-assess Supabase operational maturity and progressively improve.
-   **Maturity Levels**:

    | Level | Name | Criteria |
    |:------|:-----|:---------|
    | **L1: Reactive** | Ad-hoc | Manual migrations, no RLS, no tests |
    | **L2: Managed** | Managed | Git-managed migrations, basic RLS, manual deploys |
    | **L3: Defined** | Defined | CI/CD automation, RLS tests, Security Advisor compliance |
    | **L4: Optimized** | Optimized | Branching, full type safety, FinOps, monitoring |
    | **L5: Resilient** | Resilient | Tested DR plans, automated security audits, Incident Response |

-   **Action**:
    1.  **Risk-based Assessment**: Perform evidence-based maturity assessment at major releases, incidents, architecture or plan changes, regulatory events, and the cadence defined in Blueprint.
    2.  **Target Profile**: Define production gates in Blueprint from controls required by data class, criticality, team size, regulation, and recovery requirements rather than one level name. Treat an unmet control as an exception with an owner, deadline, compensating control, and approval.
    3.  **Gap Analysis**: Prioritize gaps between current capabilities and the target profile by risk, tracing each to the relevant section of this document.

---

## Appendix A: Quick Reference Index

> **Purpose**: A reverse lookup index for quickly locating rules across 60 sections and 200+ rules.

| Supabase Service | Related Sections |
|:----------------|:----------------|
| **PostgreSQL / Database** | §2, §4, §9, §31, §36, §38, §40, §42, §54, §55 |
| **RLS (Row Level Security)** | §3, §5.1, §8.3, §11.3, §12.3, §12.6, §19.1, §29.1, §38.1, §43 |
| **Auth (GoTrue)** | §5, §5.2, §12.1, §18, §25.1, §33, §35, §39, §44 |
| **Storage** | §6, §6.1, §6.2, §2.11, §58 |
| **Edge Functions** | §13, §19.2, §25.2, §53 |
| **Realtime** | §14, §37.2 |
| **Managed CDC / Pipelines** | §15.4 |
| **Migrations** | §7, §11.5, §11.9, §12.2, §40, §51 |
| **Type Safety** | §2.3, §11.4, §12.4, §57 |
| **pgvector / AI** | §17, §55, §56 |
| **MFA / PKCE / Passkeys** | §18.2, §44 |
| **PostgREST / REST API** | §21, §28, §30.2, §47 |
| **Connection Pooling / Supavisor** | §23, §41, §49 |
| **Multigres / Horizontal Scaling** | §41 |
| **PostgreSQL 18 / UUIDv7 / AIO** | §42 |
| **Column-Level Security** | §43 |
| **MCP Server / AI Development** | §45, §56 |
| **Security Advisor** | §46 |
| **Per-Table API Control** | §47 |
| **VPC / Private Link / Network** | §48 |
| **Read Replicas / Load Balancing** | §49 |
| **Project-scoped Roles / Team** | §50 |
| **CI/CD / Delivery Provider** | §51 |
| **Advisory Locks / Concurrency** | §52 |
| **Webhook / Event-Driven** | §53 |
| **Database Partitioning** | §54 |
| **Full-Text Search / pg_trgm** | §55 |
| **AI SQL / Generated SQL** | §56 |
| **End-to-End Type Safety** | §57 |
| **CDN / Edge Caching** | §58 |
| **Compliance / Data Sovereignty** | §59 |
| **Operational Maturity** | §60 |

### Internal Cross-References

-   **Idempotent Migrations**: §7.4 (basics) → §11.5 / §12.2 (advanced) → §51 (CI/CD automation)
-   **RLS InitPlan Optimization**: §3.0 (Law 4: Scalar Subquery) → §12.3.1 / §12.6 (implementation) → §46 (Security Advisor)
-   **Performance Optimization**: §4 (basics) → §42 (PostgreSQL 18 AIO/UUIDv7) → §49 (Read Replicas) → §54 (Partitioning) → §55 (Full-Text Search) → §41 (Multigres)
-   **Security Defense in Depth**: §3 (RLS) → §43 (CLS) → §48 (VPC/Private Link) → §47 (API Control) → §46 (Security Advisor) → §28 (Data API Hardening)
-   **AI Integration**: §17 (pgvector/AI Search) → §45 (MCP Server) → §56 (AI SQL Governance)
-   **CI/CD Governance**: §7 (Migration basics) → §51 (Provider-neutral CI/CD) → §19 (Testing) → §20 (Branching) → §57 (Type Safety E2E)
-   **Compliance**: §11.1 (Data Residency) → §59 (Compliance Framework) → §2.18 (Retention) → §43 (CLS) → §26 (Vault)
-   **Operational Maturity**: §60 (Maturity Model) → All Sections

### Cross-References (Other Rule Files)

| Section | Related Rules |
|---------|---------------|
| §3 (RLS / Security) | `security/000_security_privacy`, `security/100_data_governance` |
| §5 (Authentication) | `security/000_security_privacy` |
| §7 (Migrations / CI/CD) | `engineering/000_engineering_standards`, `quality/000_qa_testing` |
| §17 (pgvector / AI Search) | `ai/000_ai_engineering` |
| §19 (Testing) | `quality/000_qa_testing` |
| §28 (Data API Hardening) | `engineering/100_api_integration` |
| §42 (PostgreSQL 18) | `engineering/000_engineering_standards` |
| §59 (Compliance / Data Sovereignty) | `security/100_data_governance`, `security/300_ip_due_diligence` |

---

## Appendix B: Official Reference Snapshot

- [Supabase Changelog](https://supabase.com/changelog.md): time-dependent platform, managed CDC or Pipelines, API-key, and Data API changes
- [Edge Functions recursive and nested call limits](https://supabase.com/changelog/43644-edge-functions-rate-limits-on-recursive-nested-edge-functions-calls): request-chain shared limits and revalidation boundaries for direct recursion, function chaining, circular calls, and fan-out
- [Management API `logs.all` endpoint migration](https://supabase.com/changelog/48235-migration-of-supabase-management-api-logs-all-analytics-endpoint-to-logs-endpoin): endpoint-removal deadline and migration verification for log automation
- [Row Level Security](https://supabase.com/docs/guides/database/postgres/row-level-security): official RLS, bypass, and performance boundaries
- [Migrating to publishable and secret API keys](https://supabase.com/docs/guides/getting-started/migrating-to-new-api-keys): credential classes and legacy-key migration
- [Securing the Data API](https://supabase.com/docs/guides/api/securing-your-api): separation of exposed schemas, grants, and RLS
- [Database Backups](https://supabase.com/docs/guides/platform/backups): effective plan capabilities, PITR, and restore decisions
- [Self-hosted Changelog](https://supabase.com/changelog?tags=self-hosted): point-in-time API-gateway, distribution, and breaking changes
