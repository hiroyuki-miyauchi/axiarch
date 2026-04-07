# 37. Backend Data Strategy: Supabase (PostgreSQL)

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-03-24

> [!IMPORTANT]
> **Supreme Directive**
> "Data is the lifeblood of the enterprise. No compromise is permitted in its flow and protection."
> In Supabase/PostgreSQL implementation, strictly observe the priority order: **Security (RLS) > Data Integrity > Performance > Developer Productivity > Cost Efficiency**.
> This document is the supreme standard for all backend data strategy design decisions.
> **60 sections, 200+ rules.**

---

## Table of Contents

- §0. Data Sovereignty Law & Supreme Directives
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
- §51. GitHub Actions CI/CD
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

## 0. Data Sovereignty Law & Supreme Directives

### Supreme Directive 0.1: The Zero Tolerance Linter Protocol
-   **Law**: Database Linter (Supabase Security Advisor, etc.) warnings are NOT "suggestions" but **"vulnerability reports"**.
-   **Mandate**:
    1.  **Zero Warnings**: Schemas deployed to production MUST **always have 0** Linter warnings. Any warnings block release.
    2.  **Universal Fix**: Warnings like "Search Path Mutable" or "Permissive Policy" MUST be **mechanically and immediately fixed**. No project-specific exceptions.

### Supreme Directive 0.2: The Trinity DTO Mandate
-   **Purpose**: Obligation of trinity to guarantee data structure robustness and scalability.
    -   **Security**: Physically prevent raw data leakage (White-list Output).
    -   **Stability**: Protect frontend from DB changes (Mapper Shield).
    -   **AI Economy**: Save AI tokens (Data Minimization).
    -   **Universality**: An engineering **iron rule** regardless of language.

### Supreme Directive 0.3: Omnichannel Data Principle (API First)
-   **Principle**: Data structures must be designed assuming consumption not only by a single Web app but also by native apps, external systems, and AI agents.
-   **Mandate**:
    -   **Universal Types**: Do NOT store data types dependent on specific UI frameworks (React Node, etc.) in DB.
    -   **Neutral JSON**: Manage JSON data as "pure data" without display logic.

### Supreme Directive 0.4: The Client DTO Barrier
-   **Law**: Passing database row data (Raw Entity) directly as Props to client-side components (`use client`, etc.) is **prohibited**.
-   **Mandate**:
    -   **Server-Side Transformation**: Always transform data into purpose-specific lightweight DTOs on the server side, sending only the minimum required fields to the client.
    -   **PII Exclusion**: Physically prevent PII such as `admin_notes`, `phone_number`, `email` and internal management fields (`deleted_at`, `internal_memo`) from reaching the browser.
    -   **Payload Minimization**: Sending unnecessary fields causes the dual problem of wasted network bandwidth and increased future data leakage risk.
-   **Rationale**: As the concrete boundary for the DTO obligation defined by SD 0.2 (Trinity DTO Mandate), this establishes data handoff to client components as a physical interception point. Direct transmission of Raw Entities is the greatest risk source for unintended PII leakage.

### Core Laws
-   **SSOT (Single Source of Truth)**: Settings, user data, and content all have **PostgreSQL (`public` schema)** as the Single Source of Truth. "Dual management" in JSON files or external CMS is strictly prohibited.
    -   **Prohibition**: "Holding temporarily in JSON" is data rebellion.
-   **Migration Only**: DB schema changes must ALWAYS go through coded `supabase/migrations`. Manual changes via admin console (Supabase Dashboard SQL Editor, etc.) are considered "history destruction".
-   **Migration Immutability Law (Sanctuary)**:
    -   **Law**: `supabase/migrations/*.sql` becomes a "sanctuary" the moment it's committed, **permanently prohibiting rename, edit, or delete**.
    -   **Felony**: Post-remote-DB-apply fixes MUST be done via "new file". Past tampering is **instant death-level felony (Instant Felony)**.

---

## 1. Hybrid Stack Responsibility
-   **The Hybrid Stack**:
    -   **Edge (Cloudflare)**: **Shield & Optimize**. Handles DDoS protection, WAF, image resizing, and static asset caching. Contains no logic.
    -   **Frontend (Vercel)**: **Router & Renderer**. Handles stateless UI rendering and API routing. High CPU load tasks (image processing, AI waiting) are prohibited.
    -   **Backend (Supabase)**: **Source of Truth**. Handles DB, Auth, Storage (Origin), and Async Jobs (Edge Functions).

## 2. Database Design (PostgreSQL)

### Rule 2.0: The Realism Mandate (Anti-Haribote Protocol)
-   **Prohibition**: Implementing UI that treats columns not in DB or ambiguously defined data in `jsonb` as if it were normalized data is prohibited.
-   **Requirement**: Attributes involved in important business logic (finance, permissions, state transitions) MUST be defined as normalized columns (`numeric`, `text`, `boolean`) with physical storage secured before UI implementation.
-   **Anti-Pattern**: "Build UI first, save later" is not permitted. UI and data must be released simultaneously as indivisible atoms (Atom).

### Rule 2.0.1: The Settings Column Architecture (No JSON Blob)
-   **Law**: Site settings and system settings MUST NOT be stuffed into a single JSON/JSONB column (`config: jsonb`); manage with **normalized columns**.
-   **Reason**:
    1. **Query Performance**: Enables fast WHERE clauses and aggregation via SQL.
    2. **Type Safety**: TypeScript/zod type inference becomes accurate, preventing "undefined key" errors.
    3. **Integrity**: Foreign key constraints and CHECK constraints become applicable.
-   **Migration**: DB migration is mandatory when adding new settings items.
-   **Exception (Dynamic Label Isolation Protocol)**: JSONB columns are exceptionally permitted ONLY for the following cases. The responsibility of each JSONB column must be strictly limited, and mixing in data that should be normalized is prohibited.
    1.  **Dynamic Labels/Translations**: UI display labels for multi-language support, custom evaluation criteria names, etc.—dynamic text whose item count is indeterminate at schema design time.
    2.  **Non-Searchable Variable-Length Arrays**: Lists where only display order matters and that are never targets of SQL WHERE clauses or JOINs.
    3.  **Prohibition**: Properties used for calculations, searches, or conditional logic (e.g., `max_count`, `threshold`) MUST NOT be included in JSONB. These must always be promoted to normalized columns.

### Rule 2.1: Integrity & Ownership
-   **RLS Absolute**: Row Level Security (RLS) is absolute. `service_role` key usage is prohibited in principle; all queries must pass through RLS.
-   **Hierarchical Resource Ownership**:
    -   **Context**: Complex ownership structures like family sharing or team projects that cannot be expressed with single owner (`user_id`).
    -   **Law**: When multiple users access resources, define permissions (`role: 'viewer'|'admin'`) via intermediate tables (e.g., `resource_members`) and control access via RLS policies referencing this relationship table.
    -   **Action**:
        1.  **Owner ID**: Retain primary owner as `owner_id`.
        2.  **Role-Based**: Manage permissions via intermediate tables.
        3.  **Inheritance**: Child resources inherit parent resource access via `EXISTS` clause, guaranteeing double security.
-   **PII Encryption**: Recommend encrypting highly confidential personal info (accounts, document numbers, etc.) using Vault or pgcrypto.

### Rule 2.2: Schema & Type Standards
-   **Schema Separation**: Strictly separate `public` (App Data), `extensions` (PostGIS, etc.), `admin` (Audit Logs/Admin Views). Installing `extensions` into `public` is prohibited.
-   **System Schema Immunity**: DDL operations like `ALTER TABLE` on tables in system schemas (`storage`, `auth`, `graphql`) are prohibited in principle (causes permission error `42501`).
-   **Constraints**:
    -   **Identity**: Use `GENERATED BY DEFAULT AS IDENTITY` (Standard SQL) instead of `SERIAL` for auto-increment.
    -   **Money**: Use `numeric`/`decimal` or `integer` (smallest unit) for monetary calculations. `float` is strictly prohibited.
    -   **Boolean**: `boolean` columns must be `NOT NULL DEFAULT false` to prevent 3-valued logic (`null` contamination).

### Rule 2.3: Type Safety Protocol (The Bridge)
-   **Automated Types**: Use `supabase gen types` generated `database.types.ts`.
-   **The Mapped Type Bridge Mandate**:
    -   **Law**: When defining extended types (`DatabaseExtended`), intersection types (`&`) are prohibited (inference conflict risk).
    -   **Action**: MUST use **Mapped Type** to iterate over `keyof Database` and physically override, ensuring 100% type safety.

### Rule 2.4: The New Table Checklist (Creation Protocol)
-   **Law**: The following items MUST ALL be satisfied as completion criteria for new table creation:
    - [ ] **RLS Enable**: Executed `alter table ... enable row level security;`?
    - [ ] **Policy**: At least `TO service_role` policy exists? (Avoid default deny)
    - [ ] **Index**: Added index to foreign keys (`*_id`)?
    - [ ] **Type**: Regenerated `database.types.ts` and updated type definitions?
    - [ ] **Audit**: Set trigger to `audit_logs`? (For important tables)

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
-   **Rationale**: Schema-Reality Gaps are the primary cause of "silent bugs" that only manifest in production. By treating the type definition file as the "absolute truth" and eliminating guesswork-based implementation, these bugs are reduced to zero.

### Rule 2.18: The Automated Data Retention Protocol
-   **Law**: Data that accumulates over time MUST have **category-based retention periods** defined, with mechanisms (Cron Job / Scheduled Task) to **automatically purge or anonymize** data after expiration.
-   **Action**:
    1.  **Retention Category Definition**: Classify all data tables into the following categories and explicitly define retention periods.
        | Category | Example | Recommended Retention |
        |---|---|---|
        | Active Data | Users, Content | Indefinite (until account deletion) |
        | Transaction Logs | Payment records | Legal retention period (e.g., 7 years) |
        | Access Logs | Request logs, Traces | 90 days |
        | Session Data | Sessions, Tokens | 30 days |
        | Temporary Data | OTP codes, Upload temp files | 24 hours |
        | Analytics Data | Analytics events | 2 years (aggregate to summary after) |
    2.  **Automated Purge**: Implement batch jobs using `pg_cron` or cloud schedulers to automatically delete/archive data that exceeds retention periods.
    3.  **Account Deletion Lifecycle**: Implement staged data processing for user account deletion:
        -   Immediate: De-publicize profile information
        -   After 30 days: Logical deletion (`deleted_at` set)
        -   After legal retention period: Physical deletion or complete PII anonymization
    4.  **Purge Logging**: Record purge execution details (target tables, deletion count, execution timestamp) in audit logs.
-   **Rationale**: Retaining data indefinitely leads to increased storage costs, expanded privacy risks, and violations of data minimization principles under GDPR/APPI. Automated retention management achieves a triple win of cost, compliance, and performance.

## 3. Integrity & Logic Strategy

### Supreme Directive 3.0: The RLS Implementation Iron Rules
-   **Law 1: Atomic Action Definition**
    -   Comma-separated definitions like `FOR INSERT, UPDATE` are prohibited. Unless `FOR ALL`, define **individual policies for each action**.
-   **Law 2: INSERT Syntax Discipline**
    -   `INSERT` policies MUST use **`WITH CHECK`** (not `USING`).
-   **Law 3: Zero Guessing Protocol**
    -   Before creating SQL, MUST read the schema definition file and **point-and-call verify column names**. Implementation by guessing is strictly prohibited.
-   **Law 4: Performance Safety (Scalar Subquery Mandate)**
    -   **Law**: Function calls like `auth.uid()` or table references within policies MUST be wrapped in a scalar subquery **`(select auth.uid())`** to force Plan Dynamic InitPlan (fixed evaluation).
    -   **Reason**: Without wrapping, Postgres re-evaluates the function for every row (N+1), becoming a "hidden bomb" causing CPU spikes and query delays as data grows.

### Rule 3.0.1: The RLS Helper Functions Registry (RLS Utility)
-   **Security Definer Isolation**: Referencing the table itself within an RLS policy causes infinite recursion (`42P17`). Complex checks like admin validation MUST be isolated in `SECURITY DEFINER` functions.
-   **The Qualified Schema Mandate (RPC Security)**:
    -   **Law**: When `SET search_path = ''` is applied in `SECURITY DEFINER`, all table references without `public` schema qualification will fail.
    -   **Action**: Inside functions, referencing `public.profiles`, `public.reviews` is mandatory without single character compromise. Negligence here is "destruction of availability".
    -   **Registry Standards**:
        -   `public.is_admin()`: Admin check.
        -   `public.is_owner(resource_id)`: Owner check.
        -   **Requirement**: Helper functions MUST have **`SECURITY DEFINER`** attribute and physically cut off search path with **`SET search_path = ''`**. This obligates schema qualification (e.g., `public.table_name`) for all internal references, physically eliminating injection attacks via Search Path pollution.

### Rule 3.0.2: The Admin RLS Mandate (The "Locked Out" Lesson)
-   **Context**: Writing policies only for "General Users" (e.g., `user_id = auth.uid()`) locks out admins from operating the table, causing dead ends in data correction.
-   **Law**: All RLS policies MUST include an **"Admins are always allowed"** exception clause.
-   **Pattern**:
    ```sql
    -- MUST include "OR is_admin()" (DRY Principle)
    ON public.posts
    FOR UPDATE
    USING (
      (user_id = auth.uid() AND ...)  -- General User Condition
      OR
      (SELECT is_admin()) -- Admin Bypass
    );
    ```

### Rule 3.0.3: The RLS Recipes (Implementation Standards)
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
    2.  **Write Policy**: Write permissions managed via `FOR INSERT/UPDATE/DELETE` only. **NEVER include `SELECT`**.
-   **Admin Strictness**: `FOR ALL` ("Admin can do anything") is generally prohibited.

### Rule 3.2: Permissive Policy Consolidation
-   **Consolidation**: Consolidate "Admin rights" and "General view rights" into a single policy using `OR` conditions where possible to reduce total policy count.
-   **Efficiency**: Duplicate policies (e.g., "Public View" and "Everyone View") must be deleted immediately.

### Rule 3.3: Data Integrity Patterns
-   **Soft Delete**: Primary data uses `deleted_at` logical deletion. Apply `WHERE deleted_at IS NULL` to unique constraints.
-   **The Right to be Forgotten (Soft Delete Exception)**:
    -   **Context**: While logical deletion is standard, "Account Deletion Requests" and GDPR/Apple requirements mandate physical deletion or complete anonymization (PII wipe).
    -   **Action**: In withdrawal processing, do not just set `deleted_at`; physically delete or irreversibly mask (`deleted_user_xyz`) PII.
-   **Atomic Update**: Rich text saved simultaneously to `_json`, `content`, `search_text`.
-   **No SQL Replace**: String replacement within JSON via SQL is prohibited.

### Rule 3.3.1: The CMS Triple Write Protocol (Search Consistency)
-   **Context**: CMS content (Store Name, Article Title) requires different formats for Display, Sort, and Search.
-   **Law**: Critical text data MUST NOT be in one column, but atomically saved (Triple Write) into 3 distinct roles:
    1.  **`name_display`**: For Display (includes emojis, decorations).
    2.  **`name_kana`**: For Sort and Phonics (Normalized to half-width keys etc.).
    3.  **`name_search`**: For Full-Text Search (N-gram tokenized or search metadata).
-   **Automated Sync**: Synchronize these upon submission from frontend or via DB trigger to physically prevent inconsistencies ("changed name but can't search").

### Rule 3.3.2: The Multiple Permissive Policies Conflict (Policy Hygiene)
-   **Law**: Postgres joins multiple `PERMISSIVE` policies for the same action with `OR`. This creates unintended access holes.
-   **Action**: When adding a new policy, MUST `DROP` existing policies or organize into "One Consolidated Policy". Adding policies ad-hoc is disqualification for a security engineer.
-   **Verification**: Mandatorily check with `select * from pg_policies` to confirm the intended number of policies.

### Rule 3.4: RLS Lifecycle Management Protocol
-   **Create-Verify-Drop Trinity**:
    1.  **Before Create**: Check current status with `SELECT policyname FROM pg_policies WHERE tablename = '...'`.
    2.  **After Apply**: Physically confirm `multiple_permissive_policies` is 0 in Dashboard Security Advisor.
    3.  **Cleanup**: If duplicate policies found, keep standard naming and atomic delete others via **`DROP POLICY IF EXISTS "..." ON ...;`**.
-   **Naming Convention**: Ban natural language naming. Mandate **`tablename_action_policy`** format (e.g., `posts_select_policy`).
-   **Atomic Migration**: New policy creation and old policy deletion MUST be executed in **Same Migration File** atomically.
-   **Incident Prevention Checklist**:
    - [ ] Checked existing policy list?
    - [ ] Followed naming convention?
    - [ ] Included legacy policy `DROP` in same migration?
    - [ ] **The Copy-Paste Mandate**: Did you copy-paste the policy name? Typing is rejected. Exact match required.
-   **Strictification Drop Mandate**:
    -   **Warning**: RLS policies are evaluated using an **additive (OR) model**. If existing Permissive policies (e.g., `USING (true)` "anyone OK" rules) remain, adding strict policies is **effectively meaningless** as the existing lenient policy takes precedence.
    -   **Action**: In security hardening migrations, you MUST execute `DROP POLICY IF EXISTS "legacy_policy_name" ON ...;` **before** creating new strict policies to physically seal existing holes.
    -   **Template**:
        ```sql
        -- Step 1: DROP existing lenient policy (MANDATORY)
        DROP POLICY IF EXISTS "legacy_permissive_policy" ON public.target_table;
        -- Step 2: Create new strict policy
        CREATE POLICY "target_table_select_policy" ON public.target_table
        FOR SELECT USING (strict_condition);
        ```

### Rule 3.5: Public Read Protocol (Anti-Vault Paradox)
-   **Principle**: "Security" does not mean dysfunction.
-   **Law**:
    1.  **Public Read**: Data with no reason to be private (Public Articles, Store Info) should be aggressively opened via `FOR SELECT USING (true)`.
    2.  **Strict Write**: Writes (`INSERT/UPDATE/DELETE`) remain strictly locked.
    3.  **Separation**: Do not confuse Read and Write permissions; do not block Read just to protect Write.

---

## 4. Performance & Scalability

### Rule 4.1: Indexing Hygiene Protocol
-   **FK Indexing**: **Always** index Foreign Keys (FK). FK without index is "Performance Debt".
-   **Naming Convention**: `idx_<table_name>_<column_name>`.
-   **Unused Purge**: Regularly check `unused_index` warnings. Delete dead indexes to improve write performance, but wait for data growth before judging.

### Rule 4.2: Japanese Search Optimization
-   Use `pg_search` (tsvector) or `pgroonga` for Japanese full-text search.

### Rule 4.3: Scalability Strategy
-   **Infinite Scalability**: `select('*')` and unlimited queries banned. Pagination mandatory.
-   **Post-Query Filter Prohibition**: Filtering paginated query results on the application side (JavaScript/TypeScript) is prohibited. All filter conditions MUST be included in SQL WHERE clauses. Applying JS-side filters causes inconsistent items-per-page counts and inaccurate total counts/page numbers in pagination.
-   **Partitioning**: Introduce `pg_partman` when table records exceed **10 Million (10M)**.
-   **Read Replica**: Offload analysis queries to Replica.
-   **Archival**: Evacuate cold data to Object Storage.
-   **Connection Pooling**:
    -   **Law**: Database connection count is constrained by PostgreSQL's maximum connections limit. Connection pooling tools (PgBouncer, etc.) MUST be utilized to optimize DB connection count.
    -   **Action**:
        1.  **Pooler Mandatory**: DB connections from serverless environments (Edge Functions, Vercel Serverless, etc.) MUST go through a connection pooler. Creating new connections on every function cold start causes connection count to explode.
        2.  **Transaction Mode**: Use `Transaction Mode` (release connection per request) for short-lived request processing. Limit `Session Mode` to cases where Prepared Statements are required.
        3.  **Max Connections Guard**: Application-side connection pool size MUST be set to **70% or less** of the DB's `max_connections` to ensure connection headroom for management tools and background jobs.
    -   **Rationale**: In serverless architectures, concurrent connection count spikes dramatically. Without a connection pooler, DB connection count reaches its limit, risking total service outage due to connection errors.

### Rule 4.4: The Optimistic Mutation Protocol
-   **Law**: For high-frequency actions (likes, status changes, reordering, etc.) where network latency causes 0.5+ seconds of lag between action and response, **Optimistic UI** MUST be implemented to update the UI immediately without waiting for server response.
-   **Action**:
    1.  **Instant Feedback**: Use local State or optimistic update hooks (e.g., React's `useOptimistic`) to update the UI immediately after user action. Waiting for server response before updating the UI gives users the impression that the app is "broken."
    2.  **Rollback on Error**: On server error, immediately rollback to the original state and notify the user via toast or snackbar.
    3.  **Scope**: Not all operations require this. Limit application to "repetitive and high-frequency operations" and do NOT use for irreversible operations such as payments or deletions.
-   **Rationale**: UI freezes exceeding 0.5 seconds give users the impression of a "broken" app and increase churn rates. Optimistic updates dramatically improve perceived speed and enhance overall app quality.

---

## 5. Auth & Security
-   **Gotrue Delegation**: Delegate auth completely to Supabase Auth.
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
    1.  **Token Refresh**: Always implement `supabase.auth.onAuthStateChange()` and auto-update sessions on `TOKEN_REFRESHED` events. Without this, users experience sudden logout UX failures.
    2.  **JWT Expiry**: Default JWT expiry is 3600 seconds (1 hour). If shortening, recommend 15 minutes or more. Less than 5 minutes causes excessive refresh frequency and performance degradation.
    3.  **Server-Side Validation**: For JWT verification in Server Components/Server Actions, use `supabase.auth.getUser()`. `supabase.auth.getSession()` only verifies JWT locally and does not guarantee sync with the Auth server. **Always use `getUser()` for operations requiring authentication.**
    4.  **Cookie-Based Auth**: For SSR frameworks like Next.js, implement cookie-based session management using the `@supabase/ssr` package. LocalStorage-based token management does not work in SSR environments.

---

## 6. Storage & Delivery
-   **Cloudflare Proxy Shield**: Image delivery must go through Cloudflare.
-   **Bucket Separation**:
    -   **Public**: Store photos, avatars. Maximize CDN cache.
    -   **Private**: Invoices, personal docs. **Signed URL** and strict RLS mandatory.
    -   **Ads**: Separate banner ads (`bucket-ads`).
-   **User Upload Hygiene**: Resize on client, **Delete EXIF GPS** before upload.
-   **The Signed Upload URL Mandate (Direct-to-Storage Pattern)**:
    -   **Law**: Prohibit uploading large files (images, videos) through application servers (Vercel/Cloud Functions).
    -   **Flow**:
        1. **Server Action**: Verify auth/permissions, issue **Signed Upload URL**, return to client.
        2. **Client Direct Upload**: Client uploads directly to Storage.
    -   **Outcome**: Reduce app server load and avoid transfer costs/timeouts.

### Rule 6.1: The S3 Compatible Protocol
-   **Law**: Leverage Supabase Storage's S3 compatible protocol (2024 GA) to ensure interoperability with S3-compatible tools and libraries.
-   **Action**:
    1.  **S3 Client Access**: Access Supabase Storage using AWS SDK (`@aws-sdk/client-s3`) or other S3-compatible clients. Specify the Supabase Storage S3 URL as the `endpoint`.
    2.  **RLS with JWT**: When authenticating via the S3 protocol using a user's JWT token, Storage Schema RLS policies are **automatically applied**. User-scoped access control is possible.
    3.  **Standard S3 Keys**: Standard S3 access keys **bypass RLS** and provide full access to all files. Use server-side only; client exposure is strictly prohibited.
    4.  **Use Case**: Use for multipart uploads (large files), migration from existing S3 tools (aws cli, rclone, etc.), backup scripts, and other cases where the standard Supabase API is insufficient.

### Rule 6.2: The Storage Image Transformations & CDN Protocol
-   **Law**: For image delivery, leverage Supabase Storage **Image Transformations** (server-side image conversion) and **CDN** to prevent unnecessary bandwidth consumption on the client side.
-   **Action**:
    1.  **On-the-Fly Resize**: Use `supabase.storage.from('bucket').getPublicUrl('image.png', { transform: { width: 300, height: 200 } })` for server-side resizing. Deliver optimally-sized images for each device to save bandwidth.
    2.  **Format Conversion**: Use `format: 'webp'` option for WebP conversion. Achieves 25-35% file size reduction compared to JPEG.
    3.  **CDN Cache**: Files in Public buckets are automatically cached on the global CDN. Set `Cache-Control` headers appropriately to maximize cache hit rates. Private buckets have lower cache hit rates due to per-user permission checks.
    4.  **File Size Limits**: Limit file sizes on upload (default max 50MB). Set limits using the bucket's `fileSizeLimit` option to prevent unauthorized large file uploads.
    5.  **MIME Type Validation**: Restrict allowed file types with `allowedMimeTypes`. Having `.exe` or `.js` files uploaded to an image bucket is a security incident.

---

## 7. Operations & Migration

### Rule 7.1: The Migration Protocol (Ghost Table Defense)
-   **Remote Execution**: Use Dashboard SQL Editor for schema changes, save log to `supabase/migrations` (Git).
-   **Migration Timestamp Hygiene**:
    -   **Action**: Always check `ls supabase/migrations` for **latest timestamp** to ensure order integrity.
-   **Atomic Migration**: `DROP` and `CREATE` policies in same file.
-   **Ghost Table Defense**:
    -   **Law**: `ALTER` or `CREATE POLICY` on non-existent tables causes errors.
    -   **Action (Table Existence Verification)**: Use `DO $$ ... IF EXISTS ...` block when referencing external/uncertain schemas. No assumptions.
    -   **Column-Level Verification (Schema-Reality Reconciliation)**: Before creating migrations and designing DTOs, verify not just table existence but also **column existence, types, and constraints via `information_schema.columns`**. Implementing based on assumed column names (e.g., defining `dog_description_json` in DTO when it doesn't exist in DB) is the primary cause of Schema-Reality drift and is prohibited.
-   **Remote Schema Warning**: Always check current DB state (Dashboard/`pg_tables`) before writing SQL.

### Rule 7.2: IPv6 & CI/CD Protocol
-   **GitHub Actions**: Use `supabase link` (Connection Pooler) or `SUPABASE_DB_URL` (Direct) appropriately to prevent IPv6 errors.

### Rule 7.3: Data Seeding & Caching Determinism
-   **Seed Determinism**: Initial data (`seed.sql`) must use **Fixed IDs/Values**.
-   **Cache Versioning**: When caching master data (`unstable_cache`), always suffix cache keys (e.g., `master_data_v2`) to prevent Cache Rot during schema changes.
-   **Verification**: Verify actual data count after seeding. CLI "Up to date" is not proof.

### Rule 7.4: Migration Idempotency Protocol
-   **Mandate**: Migrations must produce same result upon re-execution.
-   **Implementation**: Use `CREATE TABLE IF NOT EXISTS`, `DROP ... IF EXISTS`, etc.

### Rule 7.5: Cache Reload Protocol
-   **Mandate**: After major schema changes (column add/delete, type change):
    1.  Regenerate `database.types.ts`.
    2.  Restart Dev Server.
    3.  Restart Production Service / Refresh Connection Pool.

### Rule 7.6: The Zero SQL Editor Policy (History Protection)
-   **Law**: **Direct INSERT/UPDATE/DELETE** or **DDL** via Supabase Dashboard SQL Editor is **Strictly Prohibited** (No History).
-   **Action**:
    1.  Create local migration `supabase migration new fix`, deploy via Git.
    2.  Restrict SQL Editor to Read-only usage (Query Debugging).

### Rule 7.7: The Expand-Contract Migration Protocol (Zero Downtime Schema Changes)
-   **Law**: When performing destructive schema changes (column rename/type change/deletion, table reconstruction, etc.) on tables running in production, the **Expand-Contract pattern** MUST be used to execute changes in stages with zero downtime.
-   **Action**:
    1.  **Phase 1 — Expand**: Create new columns or tables as **additions only**. At this stage, existing columns/tables MUST NOT be modified or deleted; the application continues operating on the old structure.
    2.  **Phase 2 — Migrate**: Backfill (copy/transform) old data into new columns/tables. Perform bulk updates via batch processing and avoid single-transaction full-table `UPDATE`s. The application should implement "Dual Write" supporting both old and new structures to guarantee data consistency during the transition period.
    3.  **Phase 3 — Contract**: After confirming that all applications reference only the new structure, delete old columns/tables only after **a minimum of one week of stable operation**.
-   **Prohibition**:
    -   Executing `DROP COLUMN` or `ALTER COLUMN ... TYPE` during the Expand phase is prohibited.
    -   Before executing the Contract phase, physically verify via `grep` that no references to the old structure exist anywhere in the codebase.
-   **Rationale**: Even seemingly simple operations like `ALTER TABLE ... RENAME COLUMN` can cause failures when old code accesses the new schema due to deployment timing differences. The Expand-Contract pattern temporally separates schema and application changes, achieving safe zero-downtime migrations.

### Rule 7.8: The Data-Aware Defense Protocol
-   **Law**: Production DBs contain "dirty data" (duplicate records, type mismatches, incomplete data) that does not exist in development environments. Since CI environments (clean DBs) cannot detect this contamination, all DML (data manipulation) MUST be written defensively with the **assumption that "data already exists."**
-   **Action**:
    1.  **Assumed Conflict**: All `UPDATE` / `INSERT` statements must be written on the assumption that "target data already exists" and "duplicates are present." SQL written assuming a "clean DB" will explode in production.
    2.  **Defensive Logic**: Instead of simple SQL, use `DO $$ ... END $$` blocks or `ON CONFLICT` clauses to avoid exceptions at the code level.
    3.  **Cleanup Before Constraint**: Migrations that add unique constraints (`UNIQUE`) MUST include cleanup logic to delete or merge duplicate data **within the same migration file**. Adding only the constraint causes the migration to fail against production's duplicate data.
-   **Rationale**: Migrations that "succeed" in development and CI environments frequently fail against dirty production data. Defensive DML writing guarantees safe migrations across all environments.

### Rule 7.9: The Migration Static Analysis Guard
-   **Law**: A static analysis mechanism (Pre-push Hook + CI Check) MUST be implemented to **automatically detect dangerous SQL patterns in migration files and reject them before merge**. Operational rules that rely on "human attention" will inevitably be broken during emergencies or by new team members.
-   **Action**:
    1.  **Pre-push Hook (Local Iron Dome)**: Use Git pre-push hooks to statically analyze new/modified files in `supabase/migrations/` and physically reject pushes containing dangerous patterns.
    2.  **CI Check (Remote Concrete Wall)**: Run equivalent checks in CI pipelines (GitHub Actions, etc.) as a final defense line that blocks merges even when local hooks are bypassed.
    3.  **Detection Patterns (The Forbidden Patterns)**:
        -   `UPDATE` without `DO` block or `WHERE` with subquery → Reject as undefended update
        -   `INSERT` without `ON CONFLICT` → Reject as unique constraint violation risk
        -   `ADD CONSTRAINT ... UNIQUE` without prior cleanup → Reject as existing data inconsistency risk
    4.  **No Bypass**: Using hook bypass options (`--no-verify`, etc.) is prohibited as an act that destroys the project's schema reliability.
-   **Rationale**: Depending on human attention for migration safety is merely a question of "when" an incident will occur, not "if." By establishing physical defense walls through static analysis, dangerous SQL is structurally prevented from reaching production.

---

## 8. Maintenance & Hardening

### Rule 8.1: Security Hardening (The Fortress)
-   **Public Schema Guard**: `REVOKE CREATE ON SCHEMA public FROM PUBLIC;`.
-   **View Security**: `security_invoker = true`.
-   **Search Path Defense**: `SECURITY DEFINER` functions MUST use `SET search_path = ''` and schema-qualified references (`public.users`).

### Rule 8.2: The Audit Log Mandate / WORM
-   Record DB changes in `audit_logs`. Table must be **Append-Only** (RLS protected).

### Rule 8.3: The Comprehensive RLS Audit
-   **Cascading Verification**: Verify RLS changes with **Anonymous User**.
-   **Monthly Audit Mandate**: Checklist:
    - [ ] Policy exists for all actions?
    - [ ] Admin access guaranteed?
    - [ ] General users restricted to own data?
    - [ ] Scalar subquery wrapping applied?

### Rule 8.4: RLS Post-Change Verification Protocol
-   **Verification Scope**:
    1.  **Security Advisor**: Zero warnings.
    2.  **Functional Test**: Admin/User/Anon.
    3.  **Performance**: No unintended sequential scans.
-   **Emergency Recovery**: Immediate `FOR SELECT USING (true)` for affected tables if incident occurs.

---

## 9. Domain Data Modeling

### Rule 9.1: Universal Settings & Tenant-Aware Naming
-   **Strict Column Enforced**: App settings in normalized columns. No `jsonb` config.
-   **Tenant-Aware Naming (SaaS Readiness)**:
    -   **Law**: Distinguish internal resource names for Multi-tenant/Whitelabel.
    -   **Action**: Use `site_` or `account_` for tenant-specifics. Use `system_` only for immutable platform settings.

### Rule 9.2: Static Page Ban (CMS Sovereignty)
-   ToS/Privacy Policy managed in **Headless CMS**. No hardcoded static files.

### Rule 9.3: Structural Integrity Protocols
-   **Structured Tagging**: `tags` table for centralized management.
-   **Business Hours**: Structured JSONB, prioritizing `holidays` logic.
-   **Reputation System**: **Bayesian Average** for reliable scoring.
-   **Geo-Centric**: Physical locations MUST have `latitude`/`longitude` and support location-based search.

### Rule 9.5: The Geolocation Data Strategy
-   **Law**: When assigning coordinate information to entities with physical locations, dependency on external Geocoding APIs (pay-per-use) MUST be minimized, and **API-free methods MUST be prioritized**.
-   **Action**:
    1.  **API-Free First (Recommended Priority Order)**:
        -   **Pattern 1 (URL Parse)**: Extract coordinates embedded in map service URLs (e.g., Google Maps URL) using regular expressions. No API call required — completely free.
        -   **Pattern 2 (Manual Input)**: Copy coordinates from the map service and enter them directly in the admin panel.
        -   **Pattern 3 (Geocoding API / Fallback)**: Only when the above methods cannot obtain coordinates, use address-to-coordinate conversion APIs with caching. **Results MUST be saved to DB** to prevent re-conversion of the same address (one-time API call only).
    2.  **Distance Calculation**: Use the **Haversine formula** (accounting for Earth's curvature) for calculating distances between two points.
    3.  **Distance Display Format**:

        | Distance | Display Format | Example |
        |:---------|:---------------|:--------|
        | < 1km | Meters (100m increments) | `300m` |
        | 1-50km | Kilometers (0.1km increments) | `1.2km` |
        | > 50km | Kilometers (integer) | `52km` |

    4.  **Spatial Index**: In anticipation of distance-based search ("within N km from current location"), adoption of **GIN indexes** or **PostGIS extensions** for `latitude` / `longitude` is recommended.
-   **Rationale**: Geocoding APIs incur pay-per-use charges of several dollars per 1,000 calls. By designing with an "API-Free First" approach rather than API-First, operational costs are dramatically reduced while also minimizing the impact of external service outages.

### Rule 9.4: The Time-Gated Content Schema Standard
-   **Law**: Content tables with scheduled publishing capabilities MUST implement a **time-gated schema** using the combination of `published_at` and `status`.
-   **Action**:
    1.  **Schema Standard**: Define the following columns:
        -   `status` (text): Publication state such as `'public'`, `'private'`, `'draft'`, `'archived'`.
        -   `published_at` (timestamptz, nullable): Scheduled publication datetime. `NULL` means "publish immediately."
    2.  **Query Condition (AND Conjunction)**: Public content retrieval queries MUST **AND-conjoin** the following 2 conditions. Using only one causes either leakage of unpublished content or invalidation of scheduled publishing.
        ```sql
        WHERE status = 'public'
          AND (published_at IS NULL OR published_at <= NOW())
        ```
    3.  **Indexing**: `published_at` is frequently used in range queries; index creation is recommended.
-   **Rationale**: Filtering by `status = 'public'` alone leaks content before its scheduled publication date. Filtering by `published_at` alone publishes draft content. Only the AND conjunction of both achieves accurate publication control.

---

## 10. Universal Portability
-   **Ecosystem Portability**: Data is a "Digital Asset". Adopt industry standard schemas and metadata for ecosystem compatibility.

---

## 11. Backend Governance

### Rule 11.1: The Data Residency Protocol (Rule 26.1)
-   **Law**: PII and legal docs must physically reside in specified regions (e.g., Japan) per GDPR/APPI.
-   **Action**: Design Multi-region Read/Local Write architectures considering future Data Localization requirements.

### Rule 11.2: The Audit Bypass Anti-Pattern (Server Action Mandate)
-   **Law**: Direct writes from client side bypass server Audit Logs and validation, creating a "Governance Hole".
-   **Action**:
    1.  **Surgical Write**: Consolidate writes into **Server Actions** that call `recordAuditLog`.
    2.  **Exception**: If client INSERT is unavoidable, implement `AFTER INSERT` DB Trigger to enforce logging.

### Rule 11.3: The RLS Best Practices Protocol (Policy Hygiene)
-   **Law 1: No Redundant Admin Policy**: `service_role` key completely bypasses RLS. Therefore, policies with `TO service_role` are **meaningless and redundant**. Control admin access at the application layer (`is_admin()` helper).
-   **Law 2: One Policy Per Action**: If multiple `PERMISSIVE` policies exist for the same table and same action (e.g., `SELECT`), PostgreSQL combines them with `OR`. This creates unintended access grants. Enforce **1 table, 1 action = 1 policy** as a rule.
-   **Law 3: No WITH CHECK (true)**: `WITH CHECK (true)` means "anyone can write." Applying this to production tables is strictly prohibited. Always include ownership checks via `auth.uid()` or admin role checks.

### Rule 11.4: The Poison Row Prevention Protocol (Type Collapse Prevention)
-   **Context**: When extending auto-generated types (`database.types.ts`) using intersection types (`&`), setting `Insert` / `Update` to `never` breaks type inference (Type Collapse), causing legitimate INSERT/UPDATE operations to be rejected by type errors.
-   **Law**: Overwriting the `Insert` / `Update` subtypes of auto-generated types with `never` in extended type definitions is prohibited.
-   **Action**:
    1.  **Type Alias**: Use **`type` aliases** instead of `interface` for extended types (compatibility with Mapped Types).
    2.  **Intersection Safety**: When extending via intersection types, only target `Row` and let `Insert` / `Update` inherit the original types as-is.
    3.  **Validation**: After defining an extended type, verify that `supabase.from('table').insert({...})` compiles successfully.

### Rule 11.5: The Idempotent Migration Protocol
-   **Context**: Migrations run in both "clean rooms" (CI's fresh DB) and "dirty rooms" (production DB with existing data). A design that guarantees success in both environments is required.
-   **Law**: Migration files MUST have **idempotency**—producing the same result no matter how many times they are executed.
-   **Action**:
    -   **Functions**: Use `CREATE OR REPLACE FUNCTION` instead of `CREATE FUNCTION`.
    -   **Policies**: Write `DROP POLICY IF EXISTS` before `CREATE POLICY`.
    -   **DML**: Attach `ON CONFLICT ... DO NOTHING` or `DO UPDATE` to `INSERT` to prevent conflicts with existing data.
    -   **Tables/Indexes**: Always include `IF NOT EXISTS`.
-   **Rationale**: To handle re-execution in CI/CD pipelines or re-application after rollbacks. Non-idempotent migrations are "bombs."

### Rule 11.6: The Admin/System Write Service Role Mandate
-   **Law**: Admin write operations (Create/Update/Delete) MUST use **`serviceRoleKey` (`createAdminClient()`)**, not `anon` key + Cookie session (`createClient()`).
-   **Reason**:
    1.  Session information may not be correctly passed when calling Supabase via Server Actions.
    2.  RLS rejecting `UPDATE` **returns no error but 0 affected rows (silent failure)**.
    3.  Admin operations frequently need to exceed RLS constraints for business reasons.
-   **Action**:
    1.  **Admin Write**: All write operations from the admin dashboard MUST use `createAdminClient()`.
    2.  **System Job**: Background jobs (Cron, Webhook, etc.) MUST also use `createAdminClient()` (no user session exists).
    3.  **Read is OK**: Admin read operations can use `createClient()`, but `createAdminClient()` is recommended for consistency.

### Rule 11.7: The Silent RLS Failure Detection Protocol
-   **Law**: When RLS policies reject an operation, PostgREST **returns no error but "0 affected rows"**. This is a "Silent Failure" and the most difficult-to-detect bug source.
-   **Action**:
    1.  **Count Check**: After UPDATE/DELETE operations, verify the return value's `count` is not `null` or `0`. `hasError: false` with `count: null` is an RLS violation signal.
    2.  **Explicit Error**: When `count === 0`, implement a wrapper function that returns an explicit error (e.g., `throw new Error('RLS policy may have blocked this operation')`).
    3.  **Logging**: In suspected silent failure cases, log `{ operation, table, userId, affectedRows }` to enable post-mortem investigation.
-   **Diagnostic**: "Save succeeded but data reverts on reload" → **Suspect Silent RLS Failure**.

### Rule 11.8: The RPC Scope Limitation Protocol
-   **Law**: Pushing complex business logic (chained conditionals, external API call simulation, multi-entity workflows) into DB-side RPCs (PL/pgSQL functions) is **prohibited**.
-   **Action**:
    1.  **Atomic Operations Only**: Restrict RPC usage to "atomic data operations." Permitted uses: bulk updates (`UPDATE ... WHERE id = ANY(...)`), system permission checks, aggregate queries, multi-table operations within a single transaction.
    2.  **Application Layer Logic**: Conditional branching, workflow control, external service integration, notification dispatch, and other business logic MUST be written in the application layer (Server Actions / TypeScript, etc.).
    3.  **Debuggability**: PL/pgSQL has low type safety and limited debugging tools. Keeping logic in the application layer enables breakpoints, log output, and easier test writing.
    4.  **DB Load Offloading**: Pushing heavy computation into the DB side pressures the DB connection pool and causes latency for other queries. Offload computation to the application layer.
-   **Rationale**: Concentrating business logic in RPCs creates a triple risk of debugging difficulty, lack of type safety, and increased DB load. Restrict RPCs to "operations the DB processes most efficiently" and maintain proper separation of concerns with the application layer.

### Rule 11.9: The Ghost Migration Ban
-   **Law**: DB operations not captured in migration files (manual column additions/changes/deletions, schema changes via Dashboard, etc.) are defined as **"Ghost Migrations" and are strictly prohibited**.
-   **Action**:
    1.  **Migration File Mandate**: All schema changes MUST go through migration tools (`supabase migration new`, etc.) and be saved as migration files in Git.
    2.  **No Dashboard Edits**: Direct schema changes via DB management consoles (Supabase Dashboard, pgAdmin, etc.) are prohibited as they make history tracking impossible. Even in emergencies, a migration file MUST be created after the fact and committed to Git.
    3.  **Schema Consistency Protocol**: When the local environment's schema diverges (becomes contaminated) from migration files, do NOT hesitate to rebuild the DB (`supabase db reset`, etc.). Always treat migration files as the Source of Truth, with the local DB as subordinate.
    4.  **Verification**: After applying migrations, verify that the diff between local and remote schemas is zero. If differences exist, suspect the presence of Ghost Migrations.
-   **Rationale**: Changes not recorded in migration files cause non-reproducibility across teams, CI/CD failures, and inconsistencies with the production environment. The principle that "all changes are recorded" is the only method that guarantees schema reliability.

## 12. Migrations & Privileged Operations

### Rule 12.1: The Admin Write Service Role Protocol
-   **Law**: DB write operations from admin panels or background jobs MUST use a **privileged client (Service Role Key)** that does not depend on user authentication sessions. Admin writes via regular clients (user session) risk being silently rejected by RLS policies.
-   **Action**:
    1.  **Admin Write**: All write operations (INSERT/UPDATE/DELETE) from admin panels MUST use a privileged client capable of bypassing RLS.
    2.  **System Job**: Background jobs (Cron, Webhook, batch processing, etc.) MUST also use a privileged client (no user session exists).
    3.  **Principle of Least Privilege**: Privileged client usage MUST be restricted to server-side code. Using Service Role Key in client-side code is **strictly prohibited**.
    4.  **Audit Trail**: Since privileged client operations bypass RLS, explicitly record audit logs at the application layer.
-   **Rationale**: Even in server-executed code (Server Actions, etc.), authentication information may not be properly passed depending on the framework's session management mechanism, causing RLS to unintentionally reject operations. Admin operations that complete with "no error, 0 affected rows" — a "Silent Failure" — are the most difficult bugs to discover.

### Rule 12.2: The Idempotent Migration Protocol
-   **Law**: Database migration files MUST guarantee **idempotency (producing the same result no matter how many times executed)**. Always anticipate that migrations may be partially executed across CI, preview, and production environments.
-   **Action**:
    1.  **CREATE OR REPLACE**: Use `CREATE OR REPLACE` for creating/updating Functions and Views. Prefer declarative definitions over `ALTER`.
    2.  **IF NOT EXISTS**: Use `CREATE TABLE IF NOT EXISTS` and `CREATE INDEX IF NOT EXISTS` for table and index creation.
    3.  **DROP IF EXISTS + CREATE**: For objects where `CREATE OR REPLACE` is unavailable (policies, triggers), use the `DROP ... IF EXISTS` → `CREATE` pattern.
    4.  **Defensive DML**: Use `INSERT ... ON CONFLICT DO NOTHING` (or `DO UPDATE`) for seed data insertion to prevent duplicate insert errors.
-   **Rationale**: CI environments always achieve idempotency since they apply migrations against an empty DB, but preview environments and manual recovery scenarios may have partially applied past migrations. Non-idempotent migrations cause deployment failures in these environments.

### Rule 12.3: The Anti-Permissive Policy Duplication Mandate
-   **Law**: In RLS (Row Level Security) policy design, **creating redundant Permissive policies for the same role and same action is prohibited**. In particular, `service_role` bypasses RLS entirely, making separate admin policies unnecessary.
-   **Action**:
    1.  **One Policy Per Role-Action**: Do not create multiple Permissive policies for the same role (`authenticated`, `anon`, etc.) and same action (`SELECT`, `INSERT`, etc.) on the same table. Combine multiple conditions with `OR` into a single policy.
    2.  **No service_role Policy**: Since `service_role` completely bypasses RLS, creating RLS policies for `service_role` is redundant and prohibited.
    3.  **Policy Audit**: When adding or modifying existing policies, list all policies for the same table and verify there are no logical duplications.
-   **Rationale**: PostgreSQL Permissive policies are combined with `OR`, creating a risk of unintentionally permitting a wider scope. The one-policy-per-role-action principle clarifies permission intent and prevents security holes.

### Rule 12.3.1: The RLS Auth Function InitPlan Optimization
-   **Law**: When using authentication functions such as `auth.uid()`, `auth.role()`, `current_setting()` within RLS policies, they MUST be **wrapped with `(select ...)`** to prevent re-evaluation on each row.
-   **Action**:
    1.  **Subquery Wrap**: Write `USING (user_id = (select auth.uid()))` instead of `USING (user_id = auth.uid())`.
    2.  **All Auth Functions**: Apply to all session-returning functions: `auth.uid()`, `auth.role()`, `auth.jwt()`, `current_setting()`, etc.
    3.  **Inside EXISTS Too**: Within `EXISTS (SELECT 1 FROM ... WHERE ... = auth.uid())`, wrap the inner `auth.uid()` as `(select auth.uid())` as well.
-   **Rationale**: Without wrapping, PostgreSQL re-evaluates these functions on every row scan (treated as Volatile). Wrapping with `(select ...)` enables the optimizer to evaluate the result as an **InitPlan (pre-computation)** only once, achieving dramatic performance improvements on large tables.
-   **Anti-Pattern**:
    ```sql
    -- ❌ Prohibited: auth.uid() re-evaluated per row
    USING (user_id = auth.uid())
    ```
-   **Correct Pattern**:
    ```sql
    -- ✅ Correct: Evaluated once via InitPlan
    USING (user_id = (select auth.uid()))
    ```

### Rule 12.4: The Type Extension Safety Protocol
-   **Law**: When extending auto-generated type definitions from database SDKs, ORMs, etc., with application-specific types, techniques that do not compromise type safety must be used.
-   **Action**:
    1.  **No `never` in Type Extensions**: Prohibit type extensions that overwrite auto-generated type properties with `never`. `never` means "unreachable," causing a "Poison Row" where properties exist at runtime but are inaccessible at the type level.
    2.  **Type Alias over Interface**: Prefer `type` aliases with intersection types (`&`) over `interface extends` for extending auto-generated types. Interface `extends` carries the risk of unintended contamination through Declaration Merging.
    3.  **Simple Intersection over Omit**: Excessive use of `Omit<GeneratedType, 'key1' | 'key2' | ...>` severely degrades type readability. Use simple intersection types whenever possible, and use `Omit` only when changing a property's type.
    4.  **Generated Type Sovereignty**: Manual editing of auto-generated type files is strictly prohibited. Extensions must always be done in separate files.
-   **Rationale**: Auto-generated types are valuable assets reflecting the "truth of the DB schema." Improper extensions distort this truth and cause divergence between type definitions and actual data.

### Rule 12.5: The Migration System Schema Exclusion Protocol
-   **Law**: When creating scripts that batch-modify function security settings (`search_path`, `SECURITY DEFINER/INVOKER`, etc.) in database migrations, **functions in system schemas managed by the hosting service must be included in the exclusion list**.
-   **Action**:
    1.  **Exclusion List**: Explicitly exclude functions from system schemas such as `auth`, `storage`, `realtime`, `supabase_functions`, `graphql`, `graphql_public`, `pgsodium`, `vault`, and `extensions` from batch changes.
    2.  **Schema Filter**: Use `n.nspname NOT IN ('auth', 'storage', ...)` in the `WHERE` clause of migration scripts to physically prevent interference with system schema functions.
    3.  **Dry Run**: Before applying batch-change migrations, preview the list of targeted functions (execute `SELECT` only) and verify that no system functions are included.
-   **Rationale**: Modifying the `search_path` or security settings of managed service system functions (authentication, storage management, etc.) can destroy the service's foundational capabilities. This is a fatal failure that immediately leads to complete service outage.

### Rule 12.6: The RLS InitPlan Optimization Protocol
-   **Law**: Session function calls such as `auth.uid()` and `auth.role()` within RLS (Row Level Security) policies **must be written as sub-queries using `(SELECT auth.uid())`** format.
-   **Action**:
    1.  **Sub-Select Wrapping**: When using `auth.uid()` in `USING` or `WITH CHECK` clauses of RLS policies, always use the `(SELECT auth.uid())` format. This allows PostgreSQL's query planner to evaluate the function once and cache the result as an InitPlan, preventing per-row re-evaluation.
    2.  **All Auth Functions**: Apply the same pattern not only to `auth.uid()` but to all session functions including `auth.role()`, `auth.jwt()`, etc.
    3.  **Linter Integration**: If Supabase's security linter or similar tools raise `auth_rls_initplan` warnings, fix them immediately.
    4.  **Performance Impact**: For large tables (tens of thousands of rows or more), applying this pattern can result in performance differences of orders of magnitude.
-   **Rationale**: When functions within RLS policies are re-evaluated per row, O(N) function calls occur with every table scan. Sub-query wrapping reduces this to O(1), dramatically improving query performance on large tables.

### Rule 12.7: The Client Identity Audit Protocol
-   **Law**: Before optimizing RLS policies (consolidation or deletion), **comprehensively audit which IDENTITY** (`service_role` / User JWT / Anonymous) is used by **all access paths** (Server Actions, API Routes, SSR, admin panels, etc.) that access the target data.
-   **Action**:
    1.  **Access Path Inventory**: List all code paths (Service layer, Gateway layer, Server Actions, etc.) that access the target table and identify the client initialization function (`createClient`, `createAdminClient`, etc.) used by each.
    2.  **No Blind Optimization**: Do not delete user JWT policies because "service_role is sufficient." If Server Actions use user JWT, deleting those policies silently blocks legitimate access.
    3.  **Identity Matrix**: For complex tables, create a "table × operation × identity" matrix and verify that all access patterns are covered by at least one RLS policy.
    4.  **Post-Change Verification**: After modifying or deleting policies, actually operate all affected UI flows (admin panel edit/save, user-facing browse, etc.) to verify functionality.
-   **Rationale**: Careless deletion through RLS policy "optimization" invites not security holes but "invisibility of legitimate access." Especially when admin panels use Server Actions (user JWT context), deleting JWT policies thinking service_role is sufficient silently rejects administrators' CRUD operations.

### Rule 2.8: The Idempotent Migration Protocol
-   **Law**: Migration files must be written in an **idempotent structure** that produces the same result regardless of how many times they are executed. When including DML (data manipulation), write defensive code that anticipates collisions with production data.
-   **Action**:
    1.  **DDL Idempotency**: Always use `IF NOT EXISTS` for `CREATE TABLE`, `IF EXISTS` for `DROP TABLE`, and `IF NOT EXISTS` for `ALTER TABLE ADD COLUMN` (PostgreSQL 9.6+).
    2.  **DML Idempotency**: Use `ON CONFLICT DO NOTHING` or `ON CONFLICT DO UPDATE` for `INSERT` to prevent errors on duplicate data.
    3.  **Function/Trigger Idempotency**: Use `CREATE OR REPLACE FUNCTION` for safe function recreation. Write triggers as `DROP TRIGGER IF EXISTS ... ; CREATE TRIGGER ...`.
    4.  **RLS Policy Idempotency**: Execute `DROP POLICY IF EXISTS "policy_name" ON table_name;` before creating policies to prevent collisions with existing policies.
-   **Rationale**: Non-idempotent migrations cause critical failures — "a migration that passed once breaks" — during staging/production environment differences, migration re-execution, and branch conflicts. Idempotency is the foundation of safe deployment and environment reproducibility.

### Rule 2.9: The Read-Write Privilege Symmetry
-   **Law**: In admin panels and similar interfaces, when writes (Mutations) are executed with privileged clients (`service_role`, etc.), **reads (Query for Edit Form) must also guarantee equivalent visibility**. Using different privilege-level clients for writes and reads causes the opaque bug of "save succeeds but data reverts on reload."
-   **Action**:
    1.  **Privilege Parity Check**: When using `createAdminClient()` (RLS bypass) for writes, verify that the corresponding "fetch for editing" is also executed with equivalent privileges. If reads use `anon` or restricted `authenticated` permissions, RLS filters out some data, feeding stale or empty data into the form.
    2.  **Select Spec Synchronization**: Verify that the Select Specification used in DTOs encompasses all columns that are save targets. Adding a column to only one side creates a "half-lung" state where "data is saved but not displayed in the edit screen."
    3.  **Admin Gateway Awareness**: In functions with explicit admin purposes (e.g., `getAdminStoreById`), use privileged clients as needed or fully open RLS policies for admin roles.
    4.  **Post-Update Verification**: For high-importance mutations (image reordering, status changes, etc.), consider applying the "Verification Fetch" pattern: immediately after update, execute a `select` with the same ID and verify current values via logs.
-   **Rationale**: Writes via privileged clients bypass RLS and correctly save data, but when non-privileged clients are used during edit screen reload, RLS `SELECT` policies exclude some columns or records. As a result, users feel "data wasn't saved" and repeat the same operation, creating a vicious cycle of expanding data inconsistencies.

### Rule 2.10: The RLS Policy Consolidation Mandate
-   **Law**: When multiple `PERMISSIVE` policies are defined for the same table and same operation (SELECT, INSERT, UPDATE, DELETE), they must be **consolidated into a single policy with OR conditions** wherever possible to reduce evaluation overhead.
-   **Action**:
    1.  **Consolidation by Operation**: Instead of defining separate `SELECT` policies for `anon` and `authenticated`, consolidate into a single policy like `USING (true)` or `USING (auth.role() IN ('anon', 'authenticated'))`. PostgreSQL evaluates all `PERMISSIVE` policies with OR conjunction, so splitting into individual policies unnecessarily increases evaluation count.
    2.  **Service Role Redundancy Elimination**: Since `service_role` completely bypasses RLS, explicit policies targeting `service_role` are redundant. Delete policies that target only `service_role`.
    3.  **RESTRICTIVE Policy Awareness**: `RESTRICTIVE` policies are evaluated as **AND conditions** against all `PERMISSIVE` policies, so only `PERMISSIVE` policies are consolidation targets. Consolidating `RESTRICTIVE` policies may cause side effects.
    4.  **New Table Checklist**: When designing RLS policies for new tables, use "minimum number of policies per operation" as a design principle. When creating more than one policy for the same operation, explicitly comment the reason why consolidation is not possible.
-   **Rationale**: Since PostgreSQL evaluates all `PERMISSIVE` policies for the same operation with OR conjunction, splitting functionally equivalent conditions into multiple policies doesn't change the result but increases evaluation overhead. For tables with large numbers of records especially, unnecessary policy splitting directly impacts query performance.

### Rule 2.11: The Orphan File Defense Protocol
-   **Law**: Leaving storage files behind when deleting database records (Orphan Files) is prohibited. Orphan files continuously increase storage costs and create risks of unintended data persistence.
-   **Action**:
    1.  **Cascade Deletion**: Within `DELETE` triggers or application mutation logic, incorporate processing to **asynchronously delete** related storage files when DB records are deleted. Synchronous deletion impacts response times, so asynchronous jobs (Queue/Worker) are recommended.
    2.  **Batch Cleanup**: Set up a sweeper that runs periodically (e.g., weekly) as a batch job to detect and delete storage files with no corresponding DB reference (orphan files).
    3.  **Soft Delete Awareness**: When using soft delete (`deleted_at`), defer file deletion until physical record deletion (or archive migration). Deleting files at soft-delete time causes file loss upon restoration.
-   **Rationale**: The practice of deleting only records while leaving files behind causes a "silent leak" in storage costs. Especially for services with high UGC (User Generated Content), tens of gigabytes of orphan files accumulate monthly, resulting in significant FinOps losses.

### Rule 2.12: The Safety Valve Protocol
-   **Law**: Major entity tables (users, content, products, stores, etc.) MUST have at least one **free-text column** (`notes`, `remarks`, `internal_memo`, etc.) that allows recording irregular information without requiring schema changes.
-   **Action**:
    1.  **Escape Hatch**: In real-world operations, exceptions frequently arise that strict schemas alone cannot express (e.g., "closed for winter", "call to confirm", "special handling required"). Free-text columns serve as an "Escape Hatch" to record such information without waiting for schema changes.
    2.  **Type**: `TEXT` type is recommended (or `TEXT` if Markdown support is needed). `VARCHAR(n)` character limits become operational obstacles, so avoid unless there is a specific reason.
    3.  **Nullable**: Free-text columns should allow `NULL`. Not all records require descriptions.
    4.  **No Business Logic**: Depending on free-text column values for business logic (conditional branching, filtering) is prohibited. Information required for logic must be promoted to normalized columns.
-   **Rationale**: Schema changes require migration, deployment, and testing cycles, and cannot be addressed immediately. By installing safety valve columns, information that "needs to be recorded right now" can be saved without loss, achieving both operational flexibility and development speed.

### Rule 2.13: The Time-Series Partitioning & Retention Protocol
-   **Law**: Tables that grow over time—such as log data (`audit_logs`, `access_logs`) and transaction histories (`point_transactions`, etc.)—MUST be designed with **Range Partitioning** keyed on `created_at`.
-   **Action**:
    1.  **Range Partitioning**: Use `pg_partman` or similar to automatically create monthly or quarterly partitions for time-series tables. Consider adoption when a single table's record count is projected to exceed 10 Million (10M).
    2.  **Retention Policy**: Old partitions (e.g., older than 2 years) must be automatically **Detached** and excluded from active query targets. After detachment, plan to move them to Cold Storage or export to Object Storage.
    3.  **No Premature Partitioning**: Introducing partitions during development phases with little data is over-engineering. Adopt a "Ready-to-Fire" strategy: complete the design before reaching the threshold (10M records) and apply when reached.
-   **Rationale**: Tables that grow without partitioning cause index size inflation, extended vacuum times, and increased backup times. Time-series partitioning brings operational overhead for old data near zero while enabling compliance with legal retention requirements.

### Rule 2.14: The Cold Data Offloading Protocol
-   **Law**: Data that "has not been accessed for 1+ years" or "has legal retention requirements but is rarely referenced" MUST be separated from the active DB and offloaded to **Archived Tables** or Object Storage (CSV/Parquet).
-   **Action**:
    1.  **Archived Tables**: Prepare an archive schema (e.g., `archives`) and move old data there (e.g., `archives.old_audit_logs`). Application normal queries must not reference this schema.
    2.  **Object Storage Export**: Export large amounts of old data in CSV or Parquet format to Object Storage (S3/R2/GCS, etc.). When analysis is needed, reference from a Data Warehouse (BigQuery, etc.).
    3.  **Transparent Migration**: Execute data offloading in a manner that has zero impact on application behavior. Verify that archived records are not included in API responses.
    4.  **Compliance**: Data with legal retention requirements (Tax Law: 7 years, Labor Law: 3 years, etc.) must NOT be physically deleted until the retention period has elapsed. Manage retention periods at the archive destination.
-   **Rationale**: Keeping old data in the active DB causes index size bloat, query performance degradation, and increased backup times. Separating storage by data "temperature" maximizes both active data performance and cost efficiency.

### Rule 2.15: The RLS Inheritance Protocol (Chain of Trust)
-   **Law**: Access permissions for child/grandchild tables (e.g., medical records, comments, attachments) must **NOT be defined independently**, but MUST always be determined by referencing the parent table's (e.g., pets, posts, projects) ownership or participation via `EXISTS` subqueries.
-   **Action**:
    1.  **Parent Ownership Check**: In child table RLS policies, instead of authenticating directly with `auth.uid() = user_id`, verify parent table ownership via `EXISTS (SELECT 1 FROM parent_table WHERE id = child_table.parent_id AND user_id = (select auth.uid()))`.
    2.  **Chain of Trust**: When table hierarchies extend to 3+ levels (grandparent → parent → child), always trace back to the top-level ownership for verification. Checking only intermediate tables creates security holes.
    3.  **SECURITY DEFINER for Cross-Table**: When permission checks need to reference other tables (`profiles`, etc.), wrap them in `SECURITY DEFINER` functions with a fixed `search_path` (`SET search_path = public, pg_temp`).
    4.  **No Redundant Columns**: The approach of "simplifying" permission checks by duplicating `user_id` in child tables is discouraged as it becomes a breeding ground for data inconsistency. Permissions must always be derived through Relations.
-   **Rationale**: Defining independent permission logic per child table causes update omissions when parent table permissions change, becoming a source of security holes. Inheriting parent table ownership as a Chain of Trust achieves both centralization of permission logic and elimination of inconsistencies.

### Rule 2.16: The Brittle Table Reference Prohibition
-   **Law**: Concatenating table names as dynamic strings within SQL functions (`CREATE FUNCTION`) or RPCs (`EXECUTE 'SELECT * FROM ' || table_name`) is **prohibited**.
-   **Action**:
    1.  **Static References Only**: All table references within SQL functions MUST be written as static SQL statements. Dependencies MUST be resolved at compile time (or migration application time).
    2.  **No Dynamic EXECUTE**: Patterns like `EXECUTE format('SELECT * FROM %I', variable)` are prohibited because they cannot detect typos or references to non-existent tables until runtime.
    3.  **Schema Change Safety**: Static table references ensure that dependent functions error at migration time when tables are renamed or deleted, enabling early problem detection.
-   **Rationale**: Dynamic table references are a breeding ground for SQL injection and make it impossible to trace impact scope during schema changes. Mandating static references ensures compile-time safety and maintainability.

### Rule 2.17.1: The Data Quality Management Framework
-   **Law**: Accumulated data must be designed and managed not as a \"byproduct\" but as an independent **revenue asset**. There is an obligation to systematically measure and manage data quality across the following 6 dimensions and detect quality degradation early.
-   **DQ Framework**:

    | Quality Dimension | Definition | Measurement Method | Target |
    |:------------------|:-----------|:-------------------|:-------|
    | **Accuracy** | Does the data correctly reflect reality? | Sampling verification | ≥ 95% |
    | **Completeness** | Are required fields populated? | NULL rate measurement | ≥ 90% |
    | **Consistency** | Is data for the same entity free of contradictions? | Cross-table verification | ≥ 99% |
    | **Freshness** | Is the data up-to-date? | `updated_at` elapsed days | ≤ 30 days |
    | **Uniqueness** | Are there no duplicate data entries? | Duplicate detection query | Duplicate rate ≤ 1% |
    | **Conformity** | Do data types and formats comply with specifications? | Schema Validation | 100% |

-   **Action**:
    1.  **Automated DQ Checks**: Automatically measure the above 6 metrics via monthly batch jobs (`pg_cron` or cloud scheduler) and display them on the admin dashboard.
    2.  **Asset Registry**: Catalog major data assets, explicitly documenting each asset's \"owner,\" \"quality owner,\" and \"monetization potential.\"
    3.  **Cleansing Mandate**: Data must always be maintained in a cleansed state. Leaving dirty data (unvalidated inputs, duplicate records, type violations) is prohibited.
    4.  **Alert Threshold**: When any quality dimension falls below its target value, trigger an alert and complete corrective measures within 30 days.
-   **Rationale**: Without quantitative data quality management, data that \"looks clean but is actually full of inconsistencies\" accumulates, negatively impacting API sales, AI training, and analytics. The 6-dimension framework structurally prevents quality degradation.

---

## 13. Edge Functions Design Strategy

### Rule 13.1: The Edge Functions Architecture Protocol
-   **Law**: Supabase Edge Functions (based on Deno Deploy) MUST be designed following the principles of **short-lived, stateless, single responsibility**. Using them as a general-purpose backend server replacement is prohibited.
-   **Action**:
    1.  **Single Responsibility**: Each Edge Function handles exactly one task (webhook reception, external API call, PDF generation, etc.). Monolithic designs cramming multiple responsibilities into a single function are prohibited.
    2.  **Stateless Execution**: Sharing state between Edge Functions is prohibited. Persist state in the DB (PostgreSQL) or cache (Redis, etc.).
    3.  **Timeout Awareness**: Edge Functions have **execution time limits** (default 150s, max 400s on Pro plan). Long-running processes (bulk data processing, video encoding, etc.) are unsuitable for Edge Functions. Delegate batch processing to Database `pg_cron` + PL/pgSQL or external workers.
    4.  **Cold Start Minimization**: Minimize import statements and eliminate unnecessary dependency packages. Imports via Deno's `esm.sh` incur network I/O on initial load.

### Rule 13.2: The Edge Functions Security Mandate
-   **Law**: Edge Functions security MUST be ensured across three layers: function-level, network-level, and secret management.
-   **Action**:
    1.  **JWT Verification**: For externally-invoked Edge Functions, verify the JWT from the request's `Authorization` header and confirm the authenticated user via `supabase.auth.getUser()`. If allowing access with only the `anon` key, explicitly comment the reason.
    2.  **CORS Configuration**: When calling directly from browsers, write explicit CORS configuration. `Access-Control-Allow-Origin: '*'` is restricted to development environments; enumerate allowed domains in production.
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
    3.  **Secret Management**: Retrieve API keys and external service credentials via `Deno.env.get('SECRET_NAME')`. Hardcoding in source code is strictly prohibited. Register secrets via `supabase secrets set`.
    4.  **No `--no-verify-jwt` in Production**: `supabase functions deploy --no-verify-jwt` is for development/debugging only. Disabling JWT verification in production is a critical security hole that allows unauthenticated function execution.

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
    2.  **Logging**: `console.log` / `console.error` are automatically sent to Edge Function Logs in the Supabase Dashboard. Record results of important operations (external API calls, DB writes, etc.) as structured logs (JSON format).
    3.  **Retry Safety**: Edge Functions may be retried; ensure **idempotency**. Use request IDs or idempotency keys to prevent duplicate execution.

### Rule 13.4: The Edge Functions Local Development Protocol
-   **Law**: Edge Functions development MUST use `supabase functions serve` for local development. Debugging via direct deployment to production is prohibited.
-   **Action**:
    1.  **Local Serve**: Run locally with `supabase functions serve function-name --env-file .env.local` for testing.
    2.  **Shared Code**: Place utilities shared across multiple Edge Functions in the `supabase/functions/_shared/` directory. Directories with `_` prefix are excluded from deployment.
    3.  **Import Map**: Manage dependencies via `import_map.json` with pinned versions.

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
-   **Law**: Realtime channel design MUST be optimized from the perspectives of authentication, bandwidth control, and connection count management.
-   **Action**:
    1.  **RLS Enforcement**: Postgres Changes automatically pass through RLS policies, so security is ensured if RLS is correctly configured. Note that tables with `USING (true)` broadcast all data to all users.
    2.  **Channel Granularity**: Design channel names with fine granularity (e.g., `room:${roomId}`). Funneling all events into one "global channel" causes all clients to receive all events, wasting bandwidth.
    3.  **Connection Limits**: Plan-specific concurrent connection limits apply (Free: 200, Pro: 500, Team: 10,000). Explicitly clean up channels no longer needed with `supabase.removeChannel(channel)`.
    4.  **Throttling**: High-frequency events (mouse movement, etc.) MUST be **throttled** (100-200ms interval) on the client side before sending. Event transmission exceeding server processing capacity causes message drops.
    5.  **Unsubscribe on Unmount**: In React and similar component frameworks, always call `supabase.removeChannel()` on unmount. This is a breeding ground for memory leaks and unnecessary connections.
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

---

## 15. Cron & Queues Design Strategy

### Rule 15.1: The pg_cron Scheduling Protocol
-   **Law**: Use **`pg_cron`** for scheduled tasks (data purging, aggregation batches, health checks, etc.) and minimize dependency on external schedulers.
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
    3.  **Monitoring**: Cron job execution results are available in the `cron.job_run_details` view. Review execution history monthly to verify no failed jobs.
    4.  **Resource Guard**: Cron jobs processing large volumes of data MUST limit batch size (`LIMIT 10000`) to prevent DB load spikes.

### Rule 15.2: The Message Queue Protocol (pgmq / Supabase Queues)
-   **Law**: Asynchronous processing (email sending, external API calls, heavy computations, etc.) MUST use **Supabase Queues (pgmq)**. Executing these within synchronous request processing is prohibited.
-   **Action**:
    1.  **Queue-First Architecture**: Do NOT call external APIs or send emails within user request processing. Enqueue messages and let workers (Edge Function/pg_cron) process them asynchronously.
    2.  **Retry Strategy**: Implement Exponential Backoff (`1s → 2s → 4s → 8s → max 30s`) for message processing failures. After a fixed number of retry failures (5), move to Dead Letter Queue (DLQ) for manual handling.
    3.  **Visibility Timeout**: Set message visibility timeout (`vt`) to at least **2x the processing time**. If the timeout is too short, messages being processed are redelivered, causing duplicate processing.
    4.  **Message Size**: Include only **minimal data** (ID and operation type) in queue messages. Rather than cramming bulk data into messages, keep data in DB and include only pointers (IDs) in messages.
-   **Anti-pattern**: Directly executing `await sendEmail(...)` within a Server Action and making users wait for email sending to complete. Enqueue and return a response immediately.

### Rule 15.3: The Database Webhook Protocol
-   **Law**: When notifying external services of table change events (INSERT/UPDATE/DELETE), use **Database Webhooks** and eliminate polling-based designs.
-   **Action**:
    1.  **Event-Driven**: Webhooks automatically issue HTTP requests on table trigger events. Use for real-time integration with external services (Slack notifications, Analytics, CRM integration, etc.).
    2.  **Idempotency**: Design webhook receivers to be idempotent. Network failures may cause the same event to be delivered multiple times due to retries.
    3.  **Secret Header**: Include a secret header (`X-Webhook-Secret`) in webhook requests and verify it on the receiving side. Unverified webhooks are a security hole that accepts spoofed requests from third parties.

---

## 16. Observability & FinOps Strategy

### Rule 16.1: The Database Performance Monitoring Protocol
-   **Law**: Database performance MUST be maintained through **proactive monitoring and preventive optimization**. The reactive approach of "responding only when it feels slow" is prohibited.
-   **Action**:
    1.  **pg_stat_statements**: Enable the `pg_stat_statements` extension and review the **Top 20 by execution frequency + Top 20 by average execution time** queries monthly. Queries with `mean_exec_time` exceeding 100ms are optimization candidates.
        ```sql
        -- Top 10 Slowest Queries
        SELECT query, calls, mean_exec_time, total_exec_time
        FROM pg_stat_statements
        ORDER BY mean_exec_time DESC
        LIMIT 10;
        ```
    2.  **Index Advisor**: Leverage the Supabase Dashboard **Index Advisor** and regularly review recommended index suggestions. Do not blindly apply suggested indexes; consider impacts on write performance before deciding.
    3.  **Connection Monitoring**: Monitor current active connection count via `pg_stat_activity` and trigger alerts when exceeding **70%** of `max_connections`. Connection exhaustion directly leads to total service outage.
    4.  **Table Bloat**: Monitor `n_dead_tup` (dead tuple count) via `pg_stat_user_tables`. When dead tuples exceed **20%** of table size, manually execute `VACUUM ANALYZE`. Default Auto Vacuum settings may be insufficient.

### Rule 16.2: The Supabase Dashboard Monitoring Checklist
-   **Law**: Verify the following items **weekly** to detect anomalies early.
-   **Checklist**:
    - [ ] **Database Health**: Is CPU usage sustained above **70%**?
    - [ ] **Disk Usage**: Has storage usage reached **80%** of plan limits?
    - [ ] **API Requests**: Does the 5xx error rate exceed **0.1%**?
    - [ ] **Auth Users**: Any registration spikes (suspected bot registrations)?
    - [ ] **Edge Function Invocations**: Error rate and latency trends
    - [ ] **Realtime Connections**: Is concurrent connection count approaching plan limits?
    - [ ] **Storage**: Storage bandwidth consumption and growth rate

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

    2.  **Query Optimization for Cost**: Prohibit `select('*')` and specify only required columns. This reduces transferred data volume (Bandwidth billing).
    3.  **Storage Tiering**: Cache images and static assets via CDN (Cloudflare, etc.) to minimize direct access to Supabase Storage. This is the most effective bandwidth cost reduction strategy.
    4.  **Free Tier Guard**: Use Free Tier projects for development/staging environments to isolate production costs. Note that Free Tier projects auto-pause after 7 days of inactivity (set up periodic health check pings).
    5.  **Compute Add-on Rightsizing**: Select appropriate Compute Add-on sizes based on actual CPU/memory usage. Excessive Compute is a direct cost waste.

### Rule 16.4: The Log Management Protocol
-   **Law**: Logs generated by Supabase (API, Auth, Database, Edge Functions) MUST be centrally managed and maintained in a state immediately usable for incident investigation.
-   **Action**:
    1.  **Log Drain**: In production, use Supabase's **Log Drain** feature to forward logs to external log management services (Datadog, Logflare, BigQuery, etc.). Native logs in the Supabase Dashboard have limited retention periods.
    2.  **Structured Logging**: Within Edge Functions, output structured logs in the format `console.log(JSON.stringify({ event, userId, duration }))` to facilitate search and filtering.
    3.  **PII Exclusion**: Including PII (email addresses, passwords, tokens, etc.) in logs is strictly prohibited. Logs are accessible to all developers, and recording PII creates GDPR/APPI violation risks.

---

## 17. AI & Vector Search Strategy

### Rule 17.1: The pgvector Architecture Protocol
-   **Law**: When implementing vector search (semantic search, recommendations, RAG, etc.) with Supabase, the **`pgvector`** extension MUST be used with a systematically designed strategy for embedding storage, search, and indexing.
-   **Action**:
    1.  **Extension Enable**: Enable pgvector with `CREATE EXTENSION IF NOT EXISTS vector WITH SCHEMA extensions;`. Installing into the `public` schema violates §2.2 (Schema Separation).
    2.  **Column Definition**: Define embedding columns with `vector(dimension)` type specifying explicit dimensions. OpenAI `text-embedding-3-small` is 1536 dimensions, `text-embedding-3-large` is 3072 dimensions.
        ```sql
        ALTER TABLE public.documents
        ADD COLUMN embedding vector(1536);
        ```
    3.  **Cosine Similarity**: Use **cosine similarity** (`<=>` operator) as the standard for similarity search. Inner product (`<#>`) and L2 distance (`<->`) are limited to specialized use cases.
    4.  **RLS Integration**: Always apply RLS to tables containing embedding columns. Designs where vector search results bypass RLS (direct search via `service_role` → unvalidated return to client) are prohibited.

### Rule 17.2: The Vector Index Strategy
-   **Law**: Vector indexes MUST be selected based on data size and search accuracy requirements.
-   **Action**:
    1.  **HNSW (Recommended)**: Best balance of search accuracy and speed. Higher memory usage but suitable for most use cases.
        ```sql
        CREATE INDEX idx_documents_embedding ON public.documents
        USING hnsw (embedding vector_cosine_ops)
        WITH (m = 16, ef_construction = 64);
        ```
    2.  **IVFFlat**: Use when memory is constrained. Set `lists` parameter to approximately `sqrt(N)` of data row count.
    3.  **Index Creation Timing**: Create indexes **after data has accumulated** (several thousand rows+). Creating indexes on empty tables prevents the query planner from utilizing them effectively.
    4.  **Probes Setting**: For IVFFlat, adjust the search list count with `SET LOCAL ivfflat.probes = 10;` during search. This is a precision-speed tradeoff.

### Rule 17.3: The RAG Pipeline Protocol
-   **Law**: When building RAG (Retrieval-Augmented Generation) pipelines, the entire process of embedding generation, storage, search, and retrieval MUST be managed with a consistent design.
-   **Action**:
    1.  **Embedding Generation**: Execute embedding generation in Edge Functions or server-side. Direct API calls from clients (exposing OpenAI API keys) are strictly prohibited.
    2.  **Chunk Strategy**: Split long documents into chunks (approximately 500-1000 tokens) before generating embeddings. A single embedding for an entire document degrades search accuracy.
    3.  **Metadata Co-Storage**: Store **original text, source URL, and chunk position** as metadata in the same table alongside embeddings. Storing only embeddings with separate original data management makes it impossible to reconstruct source text from search results.
    4.  **RPC Search Function**: Execute vector search via RPC functions (`SECURITY DEFINER`) combined with RLS filters.
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
    5.  **Re-Embedding Strategy**: When source data is updated, corresponding embeddings MUST be **regenerated**. Inconsistency between stale embeddings and new text causes fatal degradation of search quality.

---

## 18. Advanced Auth Design Strategy

### Rule 18.1: The API Key Security Protocol (2025 New Model)
-   **Law**: Based on Supabase's new API key system (introduced 2025), the roles of **Publishable Key** and **Secret Key** MUST be correctly understood and security boundaries strictly managed.
-   **Action**:
    1.  **Publishable Key (formerly anon key)**: Low-privilege key safe for client-side exposure. Controlled by RLS only. Embed in browsers and mobile apps.
    2.  **Secret Key (formerly service_role key)**: High-privilege server-side only key. Completely bypasses RLS. **Embedding in client code is strictly prohibited**.
    3.  **Key Rotation**: If a Secret Key is leaked, rotate immediately from the Supabase Dashboard. Since 2025, Secret Keys detected in GitHub public repositories are **automatically revoked**.
    4.  **RSA Asymmetric Keys**: New projects created after May 2025 use RSA asymmetric keys by default. JWT verification uses the Public Key, enabling token verification in external services without sharing the Secret Key.
    5.  **Data API Disable**: For projects not requiring public API access (internal tools, etc.), disable the Data API entirely (2025 new feature). This is a fundamental reduction of attack surface.

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
    4.  **Cleanup**: Anonymous users that were not elevated MUST be automatically deleted via `pg_cron` batch after a set period (e.g., 30 days). Neglecting this causes infinite growth of the `auth.users` table, impacting Auth MAU billing.
    5.  **Session Refresh**: Monitor session state changes via `supabase.auth.onAuthStateChange()` and handle token refresh appropriately. Neglecting token expiration causes sudden user logouts.

---

## 19. Testing Strategy

### Rule 19.1: The RLS Policy Testing Protocol
-   **Law**: RLS policies MUST be verified through **automated testing**. Relying solely on manual verification is prohibited. When modifying policies, include test SQL in the same migration file as the changes.
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
    4.  **Seed Data**: Manage test seed data in `supabase/seed.sql` and build deterministic state before test execution.

---

## 20. Multi-Environment & Branching Strategy

### Rule 20.1: The Environment Isolation Protocol
-   **Law**: Development (Dev), Staging, and Production environments MUST be physically separated to prevent data contamination between environments.
-   **Action**:
    1.  **Separate Projects**: Each environment MUST be created as an **independent Supabase project**. Reusing a single project across environments (changing only env variables) is a breeding ground for data contamination and configuration errors.
    2.  **Environment Variable Isolation**: Each environment's `SUPABASE_URL` and `SUPABASE_ANON_KEY` MUST be strictly managed via environment variables. Hardcoding is prohibited.
    3.  **Production Data Isolation**: When copying production data to development/staging environments, PII MUST be **anonymized/masked**. Unprocessed copies of production data create APPI/GDPR violation risks.
    4.  **Migration Flow**: Migration application order is unidirectional: `Dev → Staging → Production`. Direct application to Production is prohibited per §7.6 (Zero SQL Editor Policy).
    5.  **Seed Data Separation**: Manage seed data (`seed.sql`) separately per environment to prevent development test data from contaminating production.

### Rule 20.2: The Supabase Branching Protocol
-   **Law**: Leverage Supabase Branching (2025 Public Alpha) to safely execute schema change previews and testing.
-   **Action**:
    1.  **Branch = Isolated Instance**: Each branch functions as an independent Supabase instance (with its own API credentials, Auth, Storage). Test schema changes without impacting production.
    2.  **Dashboard / CLI Creation**: Branches can be created from the Supabase Dashboard, CLI (`supabase branches create`), or Management API. Git integration is not required (Branching 2.0).
    3.  **Migration Preview**: Apply migrations to branches and verify schema integrity, RLS policy behavior, and performance impact before production application.
    4.  **Branch Lifecycle**: Promptly delete branches after testing is complete. Abandoned branches consume compute resources and cause cost increases.
    5.  **No Data Persistence**: Branches are temporary verification environments. Data within branches is not migrated to production on merge. Use only test data and do not store important data in branches.

---

## 21. PostgREST API Design Strategy

### Rule 21.1: The Select Optimization Protocol
-   **Law**: Data retrieval via PostgREST (Supabase Auto-generated REST API) MUST specify only **the minimum required columns**, and casual use of `select('*')` is prohibited.
-   **Action**:
    1.  **Explicit Select**: Explicitly specify needed columns like `.select('id, name, created_at')`. `select('*')` increases transferred data volume and directly impacts Bandwidth billing (see §16.3).
    2.  **Computed Columns**: Leverage PostgreSQL Generated Columns and Views to return computed results directly via the API. Eliminate client-side recalculation.
    3.  **Type Generation**: Column lists specified in `select()` are reflected in types generated by `supabase gen types`. To maintain type safety, always regenerate types when changing select statements.

### Rule 21.2: The Filtering & Embedding Protocol
-   **Law**: PostgREST filtering and **Embedding (table joins)** MUST be properly utilized to minimize client-side data processing.
-   **Action**:
    1.  **Filter Operators**: Use PostgREST filters such as `.eq()`, `.in()`, `.gte()`, `.lte()`, `.like()`, `.ilike()` to filter data server-side. Designs that retrieve all records and filter client-side are prohibited.
    2.  **Embedding (Foreign Table Joins)**: Retrieve related table data via foreign keys in **a single request**.
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
    4.  **Deep Nesting Limit**: Limit Embedding nesting depth to **3 levels or fewer**. Deep nesting exponentially increases query complexity and degrades response times.

### Rule 21.3: The Pagination & Aggregate Protocol
-   **Law**: List retrieval APIs MUST always implement **pagination**; retrieving all records is prohibited. Use PostgREST's aggregate function capabilities.
-   **Action**:
    1.  **Range Pagination**: Implement offset-based pagination with `.range(from, to)`. Total count is available via the `Content-Range` response header.
    2.  **Count Option**: When total count is needed, use `{ count: 'exact' }` option. However, for large tables, `count: 'estimated'` is recommended (`exact` triggers a full table scan).
    3.  **Cursor Pagination**: For tables with large datasets (1M+ rows), adopt Keyset Pagination using `created_at` or `id` as cursors. Offset-based pagination severely degrades on deep pages.
    4.  **Max Page Size**: Do not exceed **1000 records** per request (PostgREST default). If necessary, `max_rows` can be adjusted in `supabase_settings`, but reconsider the design of clients bulk-fetching large datasets.

---

## 22. CLI & Local Development Strategy

### Rule 22.1: The CLI-First Workflow Protocol
-   **Law**: Center the Supabase CLI in the development workflow and minimize dependency on Dashboard GUI operations.
-   **Action**:
    1.  **Local Development**: Build local development environments with `supabase init` → `supabase start`. The local environment runs identical PostgreSQL, Auth, Storage, and Edge Functions as production.
    2.  **Migration Workflow**: Create new migration files with `supabase migration new <name>` and write SQL. Manual changes via Dashboard are prohibited per §7.6 (Zero SQL Editor Policy).
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
-   **Law**: In Supabase production environments, database connections MUST go through **Supavisor** (Supabase's official connection pooler, PgBouncer successor). Direct connections are limited to specific use cases.
-   **Action**:
    1.  **Pooler Endpoint**: Application connections MUST use the **Pooler connection string** (port `6543`) available from the Dashboard. Direct connections (port `5432`) are limited to migration execution and cases requiring Prepared Statements.
    2.  **Serverless Optimization**: In serverless environments (Vercel Functions, Edge Functions, etc.), DB connections are created and destroyed per request. Supavisor manages **hot connections** in a pool, significantly reducing connection overhead (TCP handshake, TLS negotiation, PostgreSQL startup).
    3.  **IPv6 Mediation**: Supavisor provides IPv4 → IPv6 mediation. Use Pooler connections from IPv4 environments like GitHub Actions to avoid IPv6 connection errors.
    4.  **Query Load Balancing**: Supavisor **automatically distributes read queries** across read replicas when enabled. Route writes to primary and reads to replicas to distribute load.

### Rule 23.2: The Pool Size Design Protocol
-   **Law**: Connection pool size MUST be **designed using calculations** based on PostgreSQL's max connections and application characteristics. Leaving default values is prohibited.
-   **Action**:
    1.  **Pool Size Calculation**: Configure Supavisor pool size via "Database Settings > Connection Pooling" in the Dashboard. Calculation guidelines:
        -   PostgREST API-centric apps: Allocate **40%** of DB max connections to Supavisor
        -   Direct connection-centric apps: Allocate **80%** of DB max connections to Supavisor
    2.  **Max Connections Awareness**: PostgreSQL `max_connections` varies by plan (Free: 60, Pro: 200, Team: 400, etc.). Connection requests exceeding this limit result in "Too many connections" errors.
    3.  **Connection Monitoring**: Periodically monitor connection trends on the **Database > Connections** page in the Dashboard. Teams/Enterprise plans provide breakdowns by connection type (Postgres, PostgREST, Auth, Storage, etc.).
    4.  **Connection Leak Prevention**: Forgetting `supabase.removeAllChannels()` or explicit DB connection closure on the application side causes connection leaks. Always release connections on request completion in serverless functions.

### Rule 23.3: The Connection Mode Decision Protocol
-   **Law**: **Transaction Mode** and **Session Mode** MUST be correctly selected based on application characteristics.
-   **Action**:
    1.  **Transaction Mode (Recommended)**: Optimal for serverless environments and short-lived API connections. Connections are returned to the pool on transaction completion. **Use Transaction Mode by default.**
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
-   **Law**: Production data MUST be protected with a **multi-layered backup strategy**. Designs that rely solely on Supabase managed backups are prohibited.
-   **Action**:
    1.  **Daily Automated Backups**: Pro plan and above includes Supabase daily automated backups retained for 7 days. Periodically verify status via **Database > Backups** in the Dashboard.
    2.  **Point-in-Time Recovery (PITR)**: For finer RPO (Recovery Point Objective), **enable PITR**. This allows restoration to any point in time (available on Pro plan and above).
    3.  **External Backup Redundancy**: Implement periodic external exports in addition to Supabase backups:
        -   **`pg_dump`**: Generate compressed backups with `pg_dump --format=custom` and store in Object Storage (S3/R2/GCS, etc.)
        -   **Scheduled Execution**: Execute daily/weekly via Edge Functions or external schedulers (GitHub Actions, Cloud Scheduler, etc.)
        -   **Cross-Region Storage**: Store backup files in a **different region** from the production DB. Avoid the risk of losing both to the same regional failure.
    4.  **Backup Encryption**: If backups contain PII, **encrypt** before storage. Manage encryption keys separately from backups (Vault, AWS KMS, etc.).
    5.  **Free Plan Warning**: Backup downloads are not available on Free plans. Always configure self-managed backups using `pg_dump` or `supabase db dump`.

### Rule 24.2: The Disaster Recovery Planning Protocol
-   **Law**: Disaster recovery (DR) procedures MUST be **documented and tested**. Production operation without existing or tested recovery procedures is prohibited.
-   **Action**:
    1.  **RTO/RPO Definition**: Define RTO (Recovery Time Objective) and RPO (Recovery Point Objective) in advance:
        -   **RTO Guidelines**: Daily backup restoration = several hours to half a day, PITR = tens of minutes
        -   **RPO Guidelines**: Daily backups = up to 24 hours of data loss, PITR = minutes
    2.  **Recovery Runbook**: Create and share a recovery procedures document with the team including:
        -   Supabase Dashboard restoration procedures
        -   `pg_restore` backup restoration procedures
        -   PITR point-in-time restoration procedures
        -   Recovery checklist for all services including Auth/Storage/Edge Functions
    3.  **DR Test**: Conduct **recovery tests** in staging environments at least quarterly. Actually restore from backups and verify data integrity and application functionality. Untested backups are equivalent to "non-existent."
    4.  **Critical Table Identification**: Rank all tables by importance and specify recovery priority:
        -   **Tier 1 (Immediate Recovery)**: `auth.users`, payment data, core business data
        -   **Tier 2 (Within 6 hours)**: User content, configuration data
        -   **Tier 3 (Within 24 hours)**: Logs, analytics data, caches
    5.  **Incident Communication**: Include communication procedures for incidents (user notification, stakeholder contact, status page updates) in the recovery runbook.

---

## 25. Rate Limiting & API Protection Strategy

### Rule 25.1: The Auth Rate Limiting Protocol
-   **Law**: Supabase Auth's built-in rate limits MUST be understood and incorporated into application design. Designs that ignore rate limits cause legitimate user blocking and service denial.
-   **Action**:
    1.  **Built-in Limits Awareness**: Supabase Auth applies the following default rate limits:
        -   **Email Sending**: Up to 3 emails per hour to the same email address (confirmation, password reset, etc.)
        -   **SMS Sending**: Up to 30 messages per hour to the same phone number
        -   **Sign-up**: Per-IP rate limiting applied
    2.  **Management API Customization**: Customize rate limit values through the Dashboard or Management API. Default values are startup-oriented and require adjustment as traffic grows.
    3.  **Client-Side Throttling**: Implement throttling on authentication requests client-side as well. Prevent unnecessary rate limit exceedance from button spam or retry loops.
    4.  **Error Handling**: Properly handle HTTP 429 responses on rate limit exceedance. Display "Please wait" messages to users and control retry timing based on the `Retry-After` header.

### Rule 25.2: The Custom API Rate Limiting Protocol
-   **Law**: Custom Rate Limiting MUST be implemented for PostgREST API / Edge Functions to prevent abuse, DDoS, and cost explosions.
-   **Action**:
    1.  **Edge Functions Rate Limiting**: Use external stores like Upstash Redis to control request rates in Edge Functions. Sliding Window algorithm is recommended.
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
    2.  **Per-User Limiting**: Apply Rate Limiting based on `IP` for anonymous users and `user_id` for authenticated users. Recommend a tier system granting authenticated users higher rates than anonymous.
    3.  **Endpoint-Specific Limits**: Differentiate rates based on resource consumption rather than applying uniform rates across all endpoints:
        -   **Read operations**: 60 requests/min (lenient)
        -   **Write operations**: 20 requests/min (strict)
        -   **Auth operations**: 5 requests/min (strictest)
    4.  **Abuse Detection**: Implement logic to detect anomalous patterns (mass sign-ups in short periods, consecutive login failures from same IP, etc.) and trigger temporary IP blocks or CAPTCHA challenges.

---

## 26. Vault & Secret Management Strategy

### Rule 26.1: The Vault Encrypted Storage Protocol
-   **Law**: Sensitive information such as API keys, external service secrets, and encryption keys MUST be stored encrypted using Supabase **Vault** (PostgreSQL extension). Plain text DB storage and direct hardcoding in environment variables are prohibited.
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
    4.  **pgsodium Deprecation**: The `pgsodium` extension has entered a deprecation cycle. For new projects, do NOT use `pgsodium` directly; manage secrets **via Vault**. Vault's internal implementation will transparently migrate away from pgsodium with no API impact.
    5.  **Use Cases**: Encrypted secrets in Vault are accessible from PostgreSQL Functions, Triggers, and Database Webhooks. For Edge Functions, use environment variables (`Deno.env.get()`).

### Rule 26.2: The Secret Rotation & Lifecycle Protocol
-   **Law**: Secrets MUST be **rotated periodically** and immediately invalidated on leak. Operating without documented rotation procedures is prohibited.
-   **Action**:
    1.  **Rotation Schedule**: Use the following rotation intervals as guidelines:
        -   **Supabase API Keys**: Every 90 days (regenerate from Dashboard)
        -   **External Service API Keys**: Per service recommendation (max 90 days)
        -   **JWT Secret**: Annually (execute with planning due to large impact scope)
    2.  **Automated Rotation**: Automate secret rotation where possible. Execute in order: Update secret in Vault → Verify dependent Functions/Triggers → Invalidate old secret.
    3.  **Leak Response**: Since 2025, Supabase provides **automatic detection and invalidation of API keys pushed to public GitHub repositories**. Do not rely solely on this; always implement `.env` file gitignore configuration and CI/CD secret scanning (GitHub Secret Scanning, GitLeaks, etc.).
    4.  **Environment Separation**: Completely separate dev/staging/production secrets. Sharing the same API keys across multiple environments is prohibited.
    5.  **Audit Trail**: Make secret creation, update, and deletion history trackable. Recommend recording events to an audit_logs table during Vault operations.

---

## 27. Foreign Data Wrappers (FDW) Strategy

### Rule 27.1: The FDW Architecture Protocol
-   **Law**: Access to external data sources (Stripe, Firebase, S3, other PostgreSQL, etc.) MUST leverage Supabase **Wrappers** (Foreign Data Wrappers extension) for unified SQL interface access.
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
-   **Law**: FDW credentials MUST be encrypted and managed via **Vault**, and foreign tables MUST be placed in **private schemas**. Materialized View usage is mandatory for performance optimization.
-   **Action**:
    1.  **Vault Integration**: FDW credentials (API keys, DB connection strings, etc.) MUST be encrypted and stored using `vault.create_secret()` (see §26.1). Writing keys in plain text in FDW SERVER options is prohibited.
        ```sql
        -- Store secret in Vault
        SELECT vault.create_secret('sk_live_xxx', 'stripe_api_key');
        -- Reference Vault when creating FDW
        CREATE SERVER stripe_server
          FOREIGN DATA WRAPPER stripe_wrapper
          OPTIONS (api_key_id (SELECT id FROM vault.decrypted_secrets WHERE name = 'stripe_api_key'));
        ```
    2.  **Private Schema Placement**: Do **NOT** place foreign tables in the `public` schema or public API schemas. Place them in dedicated private schemas (e.g., `fdw_stripe`, `fdw_firebase`) to block direct Data API access.
    3.  **Materialized Views**: External API calls via FDW have high latency, so periodically cache frequently accessed data using **Materialized Views**. Configure refresh schedules with `pg_cron`.
    4.  **SECURITY DEFINER Functions**: When partially exposing foreign table data to the public API, create `SECURITY DEFINER` functions in the public/api schema as thin wrappers returning only necessary columns. Directly exposing foreign tables is prohibited.
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
-   **Law**: In multi-tenant applications, data isolation between tenants MUST be enforced with **RLS and a tenant_id column**. Isolation relying solely on application logic is prohibited.
-   **Action**:
    1.  **tenant_id Column**: Add a `tenant_id UUID NOT NULL` column to all tables requiring tenant isolation. This column is used as the filter condition for RLS policies.
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
    2.  **RLS Policy with tenant_id**: Store the tenant ID in the JWT `app_metadata` and validate it in RLS policies. Use `app_metadata` (modifiable only by admins) to prevent users from tampering with their tenant ID.
        ```sql
        ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;
        CREATE POLICY "tenant_isolation" ON public.projects
          FOR ALL
          USING (tenant_id = (auth.jwt() -> 'app_metadata' ->> 'tenant_id')::UUID);
        ```
    3.  **Tenant Assignment**: Automatically set tenant_id in `app_metadata` during user registration. Implement via Auth Hooks or server-side logic.
    4.  **Shared vs Dedicated**: Architecture selection guidelines:
        -   **Shared Database + RLS** (Recommended): Cost-efficient and simple to manage. Optimal for SaaS with 100 or fewer tenants
        -   **Schema-per-Tenant**: Stronger logical separation. Consider for regulatory requirements
        -   **Database-per-Tenant**: Complete isolation. Only for enterprise customers with strict requirements

### Rule 29.2: The Tenant Isolation Audit Protocol
-   **Law**: Tenant isolation MUST be **periodically audited and tested** to verify no data leakage exists.
-   **Action**:
    1.  **Cross-Tenant Query Test**: Test suites MUST include test cases verifying that "Tenant A's users cannot access Tenant B's data."
    2.  **Missing tenant_id Check**: Periodically detect tables without a `tenant_id` column using the following query:
        ```sql
        SELECT table_name FROM information_schema.tables t
        WHERE t.table_schema = 'public'
          AND t.table_type = 'BASE TABLE'
          AND NOT EXISTS (
            SELECT 1 FROM information_schema.columns c
            WHERE c.table_schema = t.table_schema
              AND c.table_name = t.table_name
              AND c.column_name = 'tenant_id'
          );
        ```
    3.  **RLS Enforcement Check**: Periodically audit that RLS is enabled on all `public` schema tables (see §3).
    4.  **Tenant-Aware RBAC**: Implement intra-tenant permission management (admin/member/viewer, etc.) by combining RLS policies with JWT custom claims. Cross-tenant admin privileges are restricted to `service_role`.
    5.  **Performance Monitoring**: Monitor RLS policy performance degradation as tenant count increases. Verify that `tenant_id` column indexes exist and RLS policies use the InitPlan pattern (see §3.0).

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
-   **Law**: Production environments MUST configure **Log Drains** to forward all Supabase service logs (Database, Auth, Storage, Realtime, Edge Functions, API Gateway) to external observability platforms.
-   **Action**:
    1.  **Supported Destinations**: The following Log Drain destinations are natively supported:
        -   **Datadog**: Configure API key and site region. Logs are gzip-compressed and tagged for transfer
        -   **Custom HTTP Endpoint**: Send to any HTTP endpoint. Filtering and restructuring via Edge Functions is possible
    2.  **Plan Requirement**: Log Drains are available on Team / Enterprise / Pro plans. Not available on the Free plan.
    3.  **Log Retention**: Supabase's default log retention period is limited (varies by plan). Transfer to external storage via Log Drain when long-term retention is required.
    4.  **Structured Logging**: Output logs within Edge Functions as structured JSON using `console.log(JSON.stringify({...}))`. This facilitates parsing and filtering in external tools.
    5.  **Sensitive Data Filtering**: Verify that logs forwarded to Log Drains do **NOT contain PII or secrets**. If necessary, filter logs via Edge Functions and mask sensitive data before forwarding.

### Rule 32.2: The External Metrics & Alerting Protocol
-   **Law**: Leverage Supabase's **Metrics API** (Prometheus-compatible) to build custom dashboards and alerts with external monitoring tools.
-   **Action**:
    1.  **Prometheus Metrics API**: Supabase exposes Prometheus-compatible metrics at the `/metrics` endpoint (Beta). CPU usage, I/O, WAL, connection count, and query statistics are scrapeable.
    2.  **OpenTelemetry**: Supabase supports **OpenTelemetry (OTel) integration**. Export logs, metrics, and traces to OTel-compatible tools (Datadog, Honeycomb, Grafana, etc.).
    3.  **Datadog Agent**: Detailed database monitoring via the Datadog Agent is available. Query metrics, samples, and EXPLAIN plan visualization are supported. **The agent must connect directly to the host, bypassing the Dedicated Pooler**.
    4.  **Alert Design**: Configure alerts for the following metrics:
        -   **Connection count**: `active_connections / max_connections > 80%` → Warning
        -   **CPU usage**: `> 90%` sustained for 5+ minutes → Critical
        -   **Disk usage**: `> 80%` → Warning, `> 90%` → Critical
        -   **Auth failure rate**: Consecutive failures > 10/min → Brute-force detection alert
        -   **Edge Functions error rate**: `> 5%` → Warning
    5.  **Relationship with §16**: This section complements §16 (Internal Observability). §16 focuses on monitoring within the Supabase Dashboard; §32 focuses on integration with external tools.

---

## 33. Auth Hooks & Custom Claims Strategy

### Rule 33.1: The Custom Access Token Hook Protocol
-   **Law**: When adding **custom claims** (roles, tenant IDs, permission levels, etc.) to JWTs, you MUST use Supabase **Auth Hooks (Custom Access Token Hook)**.
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
-   **Law**: Automated processing linked to authentication events (user registration, login, etc.) MUST be implemented via **Database Triggers on auth.users**.
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
    2.  **SECURITY DEFINER Required**: Trigger functions on the `auth.users` table MUST be created with `SECURITY DEFINER` (see §31.1). The `auth` schema is not accessible from normal `anon`/`authenticated` roles.
    3.  **Error Handling**: Errors within trigger functions cause the original auth operation to rollback. Handle errors appropriately with `BEGIN...EXCEPTION` blocks to prevent entire auth flow failures.
    4.  **Migration Management**: Auth Trigger creation and modifications MUST be managed in migration files (see §7, §31.2).

---

## 34. Self-hosted & Email Configuration Strategy

### Rule 34.1: The Self-hosted Deployment Protocol
-   **Law**: When self-hosting Supabase, you MUST use **Docker Compose** and assume full responsibility for security, backups, and updates.
-   **Action**:
    1.  **Minimum Requirements**: **8GB+ RAM / 4+ CPU cores** recommended for production. Development environments can run on 4GB RAM / 2 CPU cores.
    2.  **Critical Environment Variables**: The following environment variables MUST be changed from default values:
        -   `POSTGRES_PASSWORD`: Strong password
        -   `JWT_SECRET`: Minimum 32-character random string
        -   `ANON_KEY` / `SERVICE_ROLE_KEY`: Keys generated from JWT_SECRET
        -   `DASHBOARD_USERNAME` / `DASHBOARD_PASSWORD`: Supabase Studio authentication
    3.  **HTTPS Required**: Production environments MUST terminate HTTPS via **Caddy** or **Nginx** reverse proxy. Direct HTTP exposure is prohibited.
    4.  **Data Persistence**: Configure data persistence with Docker volumes. The default setup where data is lost on `docker-compose down` is unacceptable for production.
    5.  **Update Strategy**: Regularly update Docker images for each Supabase component (GoTrue, PostgREST, Realtime, etc.). Version pinning (`:latest` tag prohibited) is recommended.

### Rule 34.2: The Email & SMTP Configuration Protocol
-   **Law**: Production environments MUST configure a **custom SMTP provider** and customize email templates to match the project.
-   **Action**:
    1.  **Custom SMTP Required**: Supabase's built-in email service has sending limits (e.g., 3 per hour). Configure external SMTP (SendGrid, AWS SES, Resend, etc.) for production.
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
-   **Law**: When integrating Supabase with **SSR frameworks** such as Next.js App Router, SvelteKit, or Nuxt, you MUST use the `@supabase/ssr` package and implement **Cookie-based authentication**. Token management via `localStorage` is prohibited.
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
    3.  **localStorage Prohibition Rationale**: `localStorage` is vulnerable to XSS attacks and unavailable in SSR/RSC. The Cookie-based approach addresses SSR, security, and SEO comprehensively.
    4.  **@supabase/auth-helpers Deprecated**: The legacy package `@supabase/auth-helpers-nextjs` is deprecated. Migrate to `@supabase/ssr`.

### Rule 35.2: The Middleware Auth Guard Protocol
-   **Law**: In SSR frameworks, implement session refresh and route protection via **Middleware**. However, do NOT rely solely on Middleware; verify authentication at the data access layer as well.
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
-   **Law**: For `supabase-js` API calls, you MUST **always check the `error` object** and implement retry logic for transient network errors.
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
    4.  **Retry Logic**: Implement retries for transient network errors (e.g., 520) using `fetch-retry` or similar. To avoid exhausting the Data API connection pool, **max 3 retries with exponential backoff** is recommended.
    5.  **Timeouts**: Set a **5-second timeout** on API calls to prevent infinite request hangs.

### Rule 37.2: The Realtime Subscription Lifecycle Protocol
-   **Law**: Realtime subscriptions MUST be **cleaned up on component unmount**, with proper reconnection handling and throttling implemented.
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
    3.  **High-Frequency Update Throttling**: Throttle high-frequency events (cursor movements, typing indicators, etc.) at **100-200ms intervals** before broadcasting.
    4.  **Channel Status Monitoring**: Monitor channel status via `channel.on('system', ...)` and provide connection state feedback to users.
    5.  **RLS Application**: Apply access policies at both channel and table levels for Realtime data (see §3, §14).

---

## 38. Schema Design Patterns Strategy

### Rule 38.1: The Soft Delete & Data Lifecycle Protocol
-   **Law**: For data deletion, adopt the **Soft Delete pattern** and implement it using a combination of `deleted_at` columns and RLS policies.
-   **Action**:
    1.  **`deleted_at` Column**: Add `deleted_at TIMESTAMPTZ DEFAULT NULL` to tables. Use `UPDATE SET deleted_at = NOW()` instead of physical deletion (`DELETE`).
    2.  **Active Records View**: Create a View that returns only active records:
        ```sql
        CREATE VIEW public.active_profiles AS
          SELECT * FROM public.profiles WHERE deleted_at IS NULL;
        ```
    3.  **RLS Auto-Exclusion**: Add `deleted_at IS NULL` condition to RLS policies to hide deleted records by default:
        ```sql
        CREATE POLICY "Hide soft-deleted rows" ON profiles
          FOR SELECT USING (deleted_at IS NULL);
        ```
    4.  **Restore Functionality**: Records can be restored by setting `deleted_at` back to `NULL`. Design a restore UI as well.
    5.  **Physical Deletion Schedule**: Use `pg_cron` (see §15.1) to set up batch jobs that physically delete records where `deleted_at` exceeds a certain period (e.g., 90 days).

### Rule 38.2: The Audit Trail & JSONB Design Protocol
-   **Law**: Track data change history with **Audit Trails** and use **JSONB** appropriately for flexible metadata.
-   **Action**:
    1.  **supa_audit Extension**: Use Supabase's `supa_audit` extension for generic table auditing. It auto-records `INSERT`/`UPDATE`/`DELETE` events. However, **disable auditing for high-write tables (>3k ops/sec)** — it degrades write throughput.
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
    5.  **pg_jsonschema**: Implement JSONB data validation with the `pg_jsonschema` extension to guarantee data integrity.

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
-   **Law**: Enterprise **SAML 2.0 SSO** MUST be configured via CLI, and mobile apps MUST properly handle Auth redirects using **Deep Linking**.
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
-   **Law**: Migration from existing databases to Supabase MUST use **`pg_dump`/`pg_restore`**, and migration procedures MUST be documented and reproducible.
-   **Action**:
    1.  **Schema Export**: Export schema and data using `supabase db dump` or `pg_dump`:
        ```bash
        # Schema only
        pg_dump --schema-only --no-owner --no-privileges \
          -d "postgresql://user:pass@host:5432/db" > schema.sql
        # Data only
        pg_dump --data-only --no-owner \
          -d "postgresql://user:pass@host:5432/db" > data.sql
        ```
    2.  **Import**: Import into the Supabase project using `psql`:
        ```bash
        psql -d "postgresql://postgres:[password]@db.[ref].supabase.co:5432/postgres" \
          -f schema.sql
        psql -d "postgresql://postgres:[password]@db.[ref].supabase.co:5432/postgres" \
          -f data.sql
        ```
    3.  **Caveats**: Users/roles and RLS policy status are NOT migrated by `pg_dump`. Recreate manually after migration.
    4.  **Large Data Migration**: For data exceeding 100MB, use `pgloader`. It also supports migration from MySQL/MS SQL.
    5.  **CSV Import**: For small datasets (under 100MB), use the Dashboard CSV import feature. For programmatic imports, use the Supabase API `upsert`, but note that **bulk imports are subject to Rate Limiting**.

### Rule 40.2: The Seed Data Management Protocol
-   **Law**: Development seed data MUST be managed in **`supabase/seed.sql`**, with a clear separation between schema definitions and data population.
-   **Action**:
    1.  **seed.sql Placement**: Write initial data INSERT statements in `supabase/seed.sql`. It auto-executes after migrations during `supabase start` or `supabase db reset`.
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
-   **Law**: When data volume approaches petabyte scale or the vertical scaling limits of a single PostgreSQL instance, plan for adopting Supabase **Multigres** (Vitess-based horizontal sharding).
-   **Action**:
    1.  **Phased Scaling**: Multigres provides graduated scaling:
        -   **Phase 1**: Smart connection pooling (Supavisor integration)
        -   **Phase 2**: High availability (HA) and failover
        -   **Phase 3**: Full sharding (data distribution)
    2.  **Shard Key Design**: Design with **tenant ID** or **user ID** as the shard key. Random UUIDs as shard keys cause frequent cross-shard queries and performance degradation.
    3.  **Application Transparency**: Multigres operates transparently from the application layer. No changes to existing `supabase-js` code are required, but schema design must consider avoiding cross-shard JOINs.
    4.  **Co-located Data**: Data belonging to the same user/tenant must be placed on the same shard (Co-location). Parent-child tables must share the same shard key to enable local JOINs.
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
-   **Law**: Leverage PostgreSQL 18's **AIO** subsystem (`io_uring`-based) for I/O-intensive workload optimization.
-   **Action**:
    1.  **Performance Awareness**: PostgreSQL 18's AIO achieves **2-3x throughput improvement** for sequential scans and VACUUM operations.
    2.  **Linux Requirement**: `io_uring` requires Linux kernel 5.1+. Automatically enabled in Supabase managed environments.
    3.  **Monitoring**: Monitor AIO effectiveness via `pg_stat_io` view.

### Rule 42.2: The UUIDv7 Migration Protocol
-   **Law**: Adopt **UUIDv7** (time-ordered UUID) via PostgreSQL 18's native `uuidv7()` function for new table primary keys.
-   **Action**:
    1.  **UUIDv7 Default**: Use `uuidv7()` instead of `gen_random_uuid()` (UUIDv4):
        ```sql
        CREATE TABLE public.new_table (
          id UUID PRIMARY KEY DEFAULT uuidv7(),
          created_at TIMESTAMPTZ DEFAULT NOW()
        );
        ```
    2.  **B-tree Performance**: UUIDv7 is time-sorted, significantly reducing B-tree index fragmentation.
    3.  **Migration Strategy**: **No need** to migrate existing UUIDv4 tables. Adopt UUIDv7 for new tables incrementally.
    4.  **Backward Compatibility**: UUIDv7 is fully compatible with the standard UUID type.

### Rule 42.3: The B-tree Skip Scan Protocol
-   **Law**: Leverage PostgreSQL 18's **B-tree Skip Scan** for composite index queries not specifying the leading column.
-   **Action**:
    1.  **Skip Scan Awareness**: For composite index `(a, b)`, queries with `WHERE b = 'value'` will automatically use Skip Scan.
    2.  **Index Design Impact**: Skip Scan is most effective when the leading column has a small NDV (Number of Distinct Values).
    3.  **EXPLAIN Verification**: Verify with `EXPLAIN ANALYZE` for the `Skip` marker.

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
-   **Law**: Leverage the Supabase **MCP Server** to securely connect AI coding assistants to Supabase projects.
-   **Action**:
    1.  **Remote MCP Server (Recommended)**: Use the Remote MCP Server (since October 2025) for enhanced security.
    2.  **Permitted Operations**: Table design, data queries (read-only), migration assistance, Edge Functions scaffolding.
    3.  **Prohibited Operations**: Direct production data modification, unreviewed RLS policy application, Service Role key usage, backup/restore operations.
    4.  **Project-scoped Access**: Use Project-scoped Roles (§50) for MCP connections with minimum privileges.
    5.  **Audit Trail**: Log all MCP operations for AI-generated SQL traceability.

---

## 46. Security Advisor & Auto-Remediation Strategy

### Rule 46.1: The Security Advisor Compliance Protocol
-   **Law**: Treat Supabase **Security Advisor** warnings equivalent to §0.1 (Zero Tolerance Linter Protocol).
-   **Action**:
    1.  **Weekly Scan**: Execute Security Advisor scans **weekly**. Integrate into CI/CD pipelines.
    2.  **Alert Categories**: Critical (immediate), High (24h), Medium (1 week) response priorities.
    3.  **AI-Assisted Fix**: Use AI fix suggestions as reference only. **Applying without review is prohibited**.
    4.  **Baseline Maintenance**: Track warning count baselines and verify no increases.

---

## 47. Per-Table API Control & Data API Disable Strategy

### Rule 47.1: The Granular API Exposure Protocol
-   **Law**: Leverage **per-table API control** (2025) to control PostgREST Data API exposure per-table.
-   **Action**:
    1.  **Dashboard Toggle**: Toggle API exposure ON/OFF per table. Internal tables should be API-hidden.
    2.  **Default Deny**: Set **API-hidden as default** for new tables.
    3.  **Data API Disable**: For internal-tool-only projects, **completely disable the Data API** (2025 feature).
    4.  **API Layer Architecture**: Recommend the "API Gateway Pattern" with Edge Functions and Data API disabled.

---

## 48. VPC & Private Link Strategy

### Rule 48.1: The Network Isolation Protocol
-   **Law**: Production databases must implement **network-level isolation**, minimizing public internet access.
-   **Action**:
    1.  **AWS Private Link**: Configure **AWS PrivateLink** on Enterprise/Team plans for private VPC connections.
    2.  **IP Allow List**: Configure allowed IPs/CIDRs in Dashboard "Network Restrictions".
    3.  **SSL Enforcement**: **Require SSL/TLS encryption** for all database connections.
    4.  **Bastion Host Pattern**: Use Bastion Host SSH tunnels for developer DB access. Direct port exposure is prohibited.
    5.  **Zero Trust**: Combine with RLS (§3), CLS (§43), and Data API Hardening (§28) for defense in depth.

---

## 49. Read Replicas & Load Balancing Strategy

### Rule 49.1: The Read Replica Architecture Protocol
-   **Law**: For read-heavy applications, deploy **Read Replicas** to distribute load from the primary DB.
-   **Action**:
    1.  **Query Routing**: Route read-only queries (SELECT) to Read Replicas and write queries to primary. Supavisor (§23) manages this routing automatically.
    2.  **Replication Lag Awareness**: Asynchronous replication incurs millisecond-to-second lag. Implement **Read-Your-Writes** pattern for post-write reads by querying the primary directly.
    3.  **Geo-distributed Replicas**: Place Read Replicas in regions close to end-users for minimized read latency.
    4.  **Analytics Offloading**: Offload analytical queries to dedicated Read Replicas, achieving zero impact on OLTP.
    5.  **Monitoring**: Monitor replication lag via `pg_stat_replication`, alerting when lag exceeds thresholds (e.g., 5 seconds).

---

## 50. Project-scoped Roles & Team Management Strategy

### Rule 50.1: The Project-scoped RBAC Protocol
-   **Law**: Leverage Supabase's **Project-scoped Roles** (2025) to restrict team member and CI/CD tool access to **minimum required privileges** per-project.
-   **Action**:
    1.  **Role Granularity**: Owner (minimal), Admin (tech leads), Developer (all devs), Read-only (QA, managers).
    2.  **CI/CD Service Account**: Create **dedicated Service Accounts** for CI/CD pipelines with minimum privileges. Using personal account API keys in CI/CD is prohibited.
    3.  **Regular Audit**: Quarterly audit of project members and role assignments. Immediately revoke access for departing/transferring members.
    4.  **MCP Integration**: Assign Developer-level or below roles to AI coding tools (§45).

---

## 51. GitHub Actions Full Integration CI/CD Strategy

### Rule 51.1: The Supabase CI/CD Pipeline Protocol
-   **Law**: Fully automate migrations, testing, and Edge Functions deployment via **GitHub Actions**, eliminating manual deployments.
-   **Action**:
    1.  **Pipeline Architecture**: test → deploy-migrations → deploy-functions → type-gen pipeline.
    2.  **Branch Preview**: Auto-create preview environments per PR using Supabase Branching (§20.2).
    3.  **Rollback Strategy**: Define automatic rollback procedures for failed migrations.
    4.  **Secret Management**: Store Supabase API keys and Service Role keys in **GitHub Secrets**. Direct inclusion in workflow files is prohibited.
    5.  **Notification**: Notify deployment success/failure to Slack/Discord for team visibility.

---

## 52. PostgreSQL Advisory Locks & Concurrency Control Strategy

### Rule 52.1: The Advisory Lock Architecture Protocol
-   **Law**: Use PostgreSQL **Advisory Locks** for exclusive processing (batch job deduplication, concurrent edit prevention, etc.).
-   **Action**:
    1.  **Session vs Transaction Locks**: Session Lock (`pg_advisory_lock`) for long-running batches; Transaction Lock (`pg_advisory_xact_lock`) for short exclusive operations.
    2.  **Try Lock Pattern**: Use `pg_try_advisory_lock` for non-blocking acquisition; skip or retry on failure. Infinite waiting is prohibited.
    3.  **Lock Key Design**: Use table OID + record ID combination for unique `bigint` keys.
    4.  **Deadlock Prevention**: Always acquire multiple Advisory Locks in the same order.
    5.  **Release Obligation**: Explicitly release Session Locks with `pg_advisory_unlock`. Unreleased locks are resource leaks.

---

## 53. Webhook Signature & Event-Driven Integration Strategy

### Rule 53.1: The Webhook Security Protocol
-   **Law**: Require **Signature Verification** for all webhook integrations, physically blocking spoofed requests.
-   **Action**:
    1.  **HMAC Verification**: Verify request signatures with **HMAC-SHA256** in webhook receivers (Edge Functions, etc.).
    2.  **Timestamp Validation**: Verify request timestamps are within **5 minutes** to prevent replay attacks.
    3.  **Idempotency Key**: Use **idempotency keys** to prevent duplicate event processing. Record received keys in DB.
    4.  **Dead Letter Queue**: Store failed webhook events in a **Dead Letter Queue** (pgmq, etc.) for manual/batch reprocessing.
    5.  **Schema Versioning**: Include version numbers (`v1`, `v2`, etc.) in webhook payloads for backward compatibility.

---

## 54. Advanced Database Partitioning Strategy

### Rule 54.1: The Partitioning Decision Framework
-   **Law**: When table records are projected to exceed 10 million (10M) or retention management is needed, implement the partitioning strategy defined in §2.13.
-   **Action**:
    1.  **Partition Type Selection**: Range (time-series), List (tenant/region), Hash (uniform distribution).
    2.  **pg_partman Integration**: Use `pg_partman` for automatic partition creation and retention management.
    3.  **Partition Pruning**: Always include partition key in WHERE clauses to enable optimizer partition pruning.
    4.  **Index Strategy**: Create indexes per-partition. Define template indexes on parent tables for automatic application to new partitions.

---

## 55. Full-Text Search & pg_trgm Strategy

### Rule 55.1: The PostgreSQL Native Search Protocol
-   **Law**: Before adopting external search services (Algolia, Elasticsearch), first consider **PostgreSQL native full-text search** (tsvector/tsquery).
-   **Action**:
    1.  **tsvector Column**: Add generated `tsvector` columns with GIN indexes for searchable tables.
    2.  **Weight System**: Use `setweight` for field prioritization (title > body: A > B > C > D).
    3.  **Japanese Language Support**: Recommend `pgroonga` extension (§36) for Japanese full-text search.
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
-   **Law**: Build an **unbroken type safety chain** from DB schema to frontend UI.
-   **Action**:
    1.  **Layer 1 — DB Types**: `database.types.ts` from `supabase gen types typescript` as **Single Source of Truth**.
    2.  **Layer 2 — Zod Validation**: Runtime validation with Zod schemas at API boundaries (Server Actions, Edge Functions).
    3.  **Layer 3 — DTO Mapping**: Per §0.2 (Trinity DTO Mandate), define explicit DB→DTO→Props transformation chains.
    4.  **Layer 4 — Type Synchronization**: Integrate type generation into CI/CD pipelines (§51).
    5.  **Type Gap Detection**: Include `tsc --noEmit` as mandatory CI check.

---

## 58. Global CDN & Edge Caching Strategy

### Rule 58.1: The Edge Caching Architecture Protocol
-   **Law**: Maximize **Edge Caching** for public content delivery, reducing unnecessary requests to origin (Supabase).
-   **Action**:
    1.  **Cache-Control Headers**: Set appropriate headers per content type (static assets: 1 year immutable, public images: CDN 7d/Browser 1d, API: SWR 60s, authenticated: no-store).
    2.  **Stale-While-Revalidate**: Use SWR for public API endpoints to maintain UX during cache updates.
    3.  **Cache Invalidation**: Explicitly purge CDN cache or use version parameters (`?v=hash`) for cache busting.
    4.  **Cloudflare Integration**: Optimize CDN integration per §1 (Hybrid Stack) for maximum cache hit rates.

---

## 59. Compliance & Data Sovereignty Strategy

### Rule 59.1: The Regulatory Compliance Framework
-   **Law**: Identify applicable **data protection regulations** (GDPR, APPI, CCPA, SOC2) and implement technical compliance measures in the Supabase environment.
-   **Action**:
    1.  **Data Classification**: Classify all data by sensitivity: Top Secret (Vault encryption), Confidential (TLS + RLS/CLS), Internal (RLS admin-only), Public.
    2.  **Region Selection**: Choose Supabase project regions aligned with jurisdictional requirements (e.g., APPI → `ap-northeast-1`). Coordinate with §11.1.
    3.  **DSAR Automation**: Prepare RPC functions for automated user data export/deletion to respond to Data Subject Access Requests within 24 hours.
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
    1.  **Quarterly Assessment**: Conduct team maturity evaluations quarterly.
    2.  **L3 Target**: New projects should target **L3 (Defined)** initially. Production release below L3 is prohibited in principle.
    3.  **Gap Analysis**: Identify gaps between current and target levels, referencing relevant sections of this document.

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
| **CI/CD / GitHub Actions** | §51 |
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
-   **CI/CD Full Automation**: §7 (Migration basics) → §51 (GitHub Actions) → §19 (Testing) → §20 (Branching) → §57 (Type Safety E2E)
-   **Compliance**: §11.1 (Data Residency) → §59 (Compliance Framework) → §2.18 (Retention) → §43 (CLS) → §26 (Vault)
-   **Operational Maturity**: §60 (Maturity Model) → All Sections

### Cross-References (Other Rule Files)

| Section | Related Rules |
|---------|---------------|
| §3 (RLS / Security) | `600_security_privacy`, `601_data_governance` |
| §5 (Authentication) | `600_security_privacy` |
| §7 (Migrations / CI/CD) | `300_engineering_standards`, `700_qa_testing` |
| §17 (pgvector / AI Search) | `400_ai_engineering` |
| §19 (Testing) | `700_qa_testing` |
| §28 (Data API Hardening) | `301_api_integration` |
| §42 (PostgreSQL 18) | `300_engineering_standards` |
| §59 (Compliance / Data Sovereignty) | `601_data_governance`, `603_ip_due_diligence` |
