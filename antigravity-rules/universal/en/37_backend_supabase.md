# 37. Backend Engineering (Supabase & PostgreSQL)

## 0. Data Sovereignty Law & Supreme Directives

### Supreme Directive 0.1: The Zero Tolerance Linter Protocol
*   **Law**: Database Linter (Supabase Security Advisor, etc.) warnings are NOT "suggestions" but **"vulnerability reports"**.
*   **Mandate**:
    1.  **Zero Warnings**: Schemas deployed to production MUST **always have 0** Linter warnings. Any warnings block release.
    2.  **Universal Fix**: Warnings like "Search Path Mutable" or "Permissive Policy" MUST be **mechanically and immediately fixed**. No project-specific exceptions.

### Supreme Directive 0.2: The Trinity DTO Mandate
*   **Purpose**: Obligation of trinity to guarantee data structure robustness and scalability.
    *   **Security**: Physically prevent raw data leakage (White-list Output).
    *   **Stability**: Protect frontend from DB changes (Mapper Shield).
    *   **AI Economy**: Save AI tokens (Data Minimization).
    *   **Universality**: An engineering **iron rule** regardless of language.

### Supreme Directive 0.3: Omnichannel Data Principle (API First)
*   **Principle**: Data structures must be designed assuming consumption not only by a single Web app but also by native apps, external systems, and AI agents.
*   **Mandate**:
    *   **Universal Types**: Do NOT store data types dependent on specific UI frameworks (React Node, etc.) in DB.
    *   **Neutral JSON**: Manage JSON data as "pure data" without display logic.

### Core Laws
*   **SSOT (Single Source of Truth)**: Settings, user data, and content all have **PostgreSQL (`public` schema)** as the Single Source of Truth. "Dual management" in JSON files or external CMS is strictly prohibited.
    *   **Prohibition**: "Holding temporarily in JSON" is data rebellion.
*   **Migration Only**: DB schema changes must ALWAYS go through coded `supabase/migrations`. Manual changes via admin console (Supabase Dashboard SQL Editor, etc.) are considered "history destruction".
*   **Migration Immutability Law (Sanctuary)**:
    *   **Law**: `supabase/migrations/*.sql` becomes a "sanctuary" the moment it's committed, **permanently prohibiting rename, edit, or delete**.
    *   **Felony**: Post-remote-DB-apply fixes MUST be done via "new file". Past tampering is **instant death-level felony (Instant Felony)**.

---

## 1. Hybrid Stack Responsibility
*   **The Hybrid Stack**:
    *   **Edge (Cloudflare)**: **Shield & Optimize**. Handles DDoS protection, WAF, image resizing, and static asset caching. Contains no logic.
    *   **Frontend (Vercel)**: **Router & Renderer**. Handles stateless UI rendering and API routing. High CPU load tasks (image processing, AI waiting) are prohibited.
    *   **Backend (Supabase)**: **Source of Truth**. Handles DB, Auth, Storage (Origin), and Async Jobs (Edge Functions).

## 2. Database Design (PostgreSQL)

### Rule 2.0: The Realism Mandate (Anti-Haribote Protocol)
*   **Prohibition**: Implementing UI that treats columns not in DB or ambiguously defined data in `jsonb` as if it were normalized data is prohibited.
*   **Requirement**: Attributes involved in important business logic (finance, permissions, state transitions) MUST be defined as normalized columns (`numeric`, `text`, `boolean`) with physical storage secured before UI implementation.
*   **Anti-Pattern**: "Build UI first, save later" is not permitted. UI and data must be released simultaneously as indivisible atoms (Atom).

### Rule 2.0.1: The Settings Column Architecture (No JSON Blob)
*   **Law**: Site settings and system settings MUST NOT be stuffed into a single JSON/JSONB column (`config: jsonb`); manage with **normalized columns**.
*   **Reason**:
    1. **Query Performance**: Enables fast WHERE clauses and aggregation via SQL.
    2. **Type Safety**: TypeScript/zod type inference becomes accurate, preventing "undefined key" errors.
    3. **Integrity**: Foreign key constraints and CHECK constraints become applicable.
*   **Migration**: DB migration is mandatory when adding new settings items.

### Rule 2.1: Integrity & Ownership
*   **RLS Absolute**: Row Level Security (RLS) is absolute. `service_role` key usage is prohibited in principle; all queries must pass through RLS.
*   **Hierarchical Resource Ownership**:
    *   **Context**: Complex ownership structures like family sharing or team projects that cannot be expressed with single owner (`user_id`).
    *   **Law**: When multiple users access resources, define permissions (`role: 'viewer'|'admin'`) via intermediate tables (e.g., `resource_members`) and control access via RLS policies referencing this relationship table.
    *   **Action**:
        1.  **Owner ID**: Retain primary owner as `owner_id`.
        2.  **Role-Based**: Manage permissions via intermediate tables.
        3.  **Inheritance**: Child resources inherit parent resource access via `EXISTS` clause, guaranteeing double security.
*   **PII Encryption**: Recommend encrypting highly confidential personal info (accounts, document numbers, etc.) using Vault or pgcrypto.

### Rule 2.2: Schema & Type Standards
*   **Schema Separation**: Strictly separate `public` (App Data), `extensions` (PostGIS, etc.), `admin` (Audit Logs/Admin Views). Installing `extensions` into `public` is prohibited.
*   **System Schema Immunity**: DDL operations like `ALTER TABLE` on tables in system schemas (`storage`, `auth`, `graphql`) are prohibited in principle (causes permission error `42501`).
*   **Constraints**:
    *   **Identity**: Use `GENERATED BY DEFAULT AS IDENTITY` (Standard SQL) instead of `SERIAL` for auto-increment.
    *   **Money**: Use `numeric`/`decimal` or `integer` (smallest unit) for monetary calculations. `float` is strictly prohibited.
    *   **Boolean**: `boolean` columns must be `NOT NULL DEFAULT false` to prevent 3-valued logic (`null` contamination).

### Rule 2.3: Type Safety Protocol (The Bridge)
*   **Automated Types**: Use `supabase gen types` generated `database.types.ts`.
*   **The Mapped Type Bridge Mandate**:
    *   **Law**: When defining extended types (`DatabaseExtended`), intersection types (`&`) are prohibited (inference conflict risk).
    *   **Action**: MUST use **Mapped Type** to iterate over `keyof Database` and physically override, ensuring 100% type safety.

### Rule 2.4: The New Table Checklist (Creation Protocol)
*   **Law**: The following items MUST ALL be satisfied as completion criteria for new table creation:
    - [ ] **RLS Enable**: Executed `alter table ... enable row level security;`?
    - [ ] **Policy**: At least `TO service_role` policy exists? (Avoid default deny)
    - [ ] **Index**: Added index to foreign keys (`*_id`)?
    - [ ] **Type**: Regenerated `database.types.ts` and updated type definitions?
    - [ ] **Audit**: Set trigger to `audit_logs`? (For important tables)

## 3. Integrity & Logic Strategy

### Supreme Directive 3.0: The RLS Implementation Iron Rules
*   **Law 1: Atomic Action Definition**
    *   Comma-separated definitions like `FOR INSERT, UPDATE` are prohibited. Unless `FOR ALL`, define **individual policies for each action**.
*   **Law 2: INSERT Syntax Discipline**
    *   `INSERT` policies MUST use **`WITH CHECK`** (not `USING`).
*   **Law 3: Zero Guessing Protocol**
    *   Before creating SQL, MUST read the schema definition file and **point-and-call verify column names**. Implementation by guessing is strictly prohibited.
*   **Law 4: Performance Safety (Scalar Subquery Mandate)**
    *   **Law**: Function calls like `auth.uid()` or table references within policies MUST be wrapped in a scalar subquery **`(select auth.uid())`** to force Plan Dynamic InitPlan (fixed evaluation).
    *   **Reason**: Without wrapping, Postgres re-evaluates the function for every row (N+1), becoming a "hidden bomb" causing CPU spikes and query delays as data grows.

### Rule 3.0.1: The RLS Helper Functions Registry (RLS Utility)
*   **Security Definer Isolation**: Referencing the table itself within an RLS policy causes infinite recursion (`42P17`). Complex checks like admin validation MUST be isolated in `SECURITY DEFINER` functions.
*   **The Qualified Schema Mandate (RPC Security)**:
    *   **Law**: When `SET search_path = ''` is applied in `SECURITY DEFINER`, all table references without `public` schema qualification will fail.
    *   **Action**: Inside functions, referencing `public.profiles`, `public.reviews` is mandatory without single character compromise. Negligence here is "destruction of availability".
    *   **Registry Standards**:
        *   `public.is_admin()`: Admin check.
        *   `public.is_owner(resource_id)`: Owner check.
        *   **Requirement**: Helper functions MUST have **`SECURITY DEFINER`** attribute and physically cut off search path with **`SET search_path = ''`**. This obligates schema qualification (e.g., `public.table_name`) for all internal references, physically eliminating injection attacks via Search Path pollution.

### Rule 3.0.2: The Admin RLS Mandate (The "Locked Out" Lesson)
*   **Context**: Writing policies only for "General Users" (e.g., `user_id = auth.uid()`) locks out admins from operating the table, causing dead ends in data correction.
*   **Law**: All RLS policies MUST include an **"Admins are always allowed"** exception clause.
*   **Pattern**:
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
*   **Admin Only Write (Strict Lock)**:
    ```sql
    FOR INSERT WITH CHECK (
      EXISTS (
        SELECT 1 FROM public.profiles
        WHERE id = (select auth.uid()) AND role IN ('admin', 'super_admin')
      )
    );
    ```
*   **User Restricted (Owners - Time Limited)**:
    ```sql
    FOR UPDATE USING (
      user_id = (select auth.uid())      -- Owner Only
      AND created_at > (now() - interval '1 hour') -- Within 1 hour only
    );
    ```

### Rule 3.1: RLS Separation of Duties
*   **Separation Protocol**:
    1.  **Select Policy**: Read permissions managed via `FOR SELECT` only.
    2.  **Write Policy**: Write permissions managed via `FOR INSERT/UPDATE/DELETE` only. **NEVER include `SELECT`**.
*   **Admin Strictness**: `FOR ALL` ("Admin can do anything") is generally prohibited.

### Rule 3.2: Permissive Policy Consolidation
*   **Consolidation**: Consolidate "Admin rights" and "General view rights" into a single policy using `OR` conditions where possible to reduce total policy count.
*   **Efficiency**: Duplicate policies (e.g., "Public View" and "Everyone View") must be deleted immediately.

### Rule 3.3: Data Integrity Patterns
*   **Soft Delete**: Primary data uses `deleted_at` logical deletion. Apply `WHERE deleted_at IS NULL` to unique constraints.
*   **The Right to be Forgotten (Soft Delete Exception)**:
    *   **Context**: While logical deletion is standard, "Account Deletion Requests" and GDPR/Apple requirements mandate physical deletion or complete anonymization (PII wipe).
    *   **Action**: In withdrawal processing, do not just set `deleted_at`; physically delete or irreversibly mask (`deleted_user_xyz`) PII.
*   **Atomic Update**: Rich text saved simultaneously to `_json`, `content`, `search_text`.
*   **No SQL Replace**: String replacement within JSON via SQL is prohibited.

### Rule 3.3.1: The CMS Triple Write Protocol (Search Consistency)
*   **Context**: CMS content (Store Name, Article Title) requires different formats for Display, Sort, and Search.
*   **Law**: Critical text data MUST NOT be in one column, but atomically saved (Triple Write) into 3 distinct roles:
    1.  **`name_display`**: For Display (includes emojis, decorations).
    2.  **`name_kana`**: For Sort and Phonics (Normalized to half-width keys etc.).
    3.  **`name_search`**: For Full-Text Search (N-gram tokenized or search metadata).
*   **Automated Sync**: Synchronize these upon submission from frontend or via DB trigger to physically prevent inconsistencies ("changed name but can't search").

### Rule 3.3.2: The Multiple Permissive Policies Conflict (Policy Hygiene)
*   **Law**: Postgres joins multiple `PERMISSIVE` policies for the same action with `OR`. This creates unintended access holes.
*   **Action**: When adding a new policy, MUST `DROP` existing policies or organize into "One Consolidated Policy". Adding policies ad-hoc is disqualification for a security engineer.
*   **Verification**: Mandatorily check with `select * from pg_policies` to confirm the intended number of policies.

### Rule 3.4: RLS Lifecycle Management Protocol
*   **Create-Verify-Drop Trinity**:
    1.  **Before Create**: Check current status with `SELECT policyname FROM pg_policies WHERE tablename = '...'`.
    2.  **After Apply**: Physically confirm `multiple_permissive_policies` is 0 in Dashboard Security Advisor.
    3.  **Cleanup**: If duplicate policies found, keep standard naming and atomic delete others via **`DROP POLICY IF EXISTS "..." ON ...;`**.
*   **Naming Convention**: Ban natural language naming. Mandate **`tablename_action_policy`** format (e.g., `posts_select_policy`).
*   **Atomic Migration**: New policy creation and old policy deletion MUST be executed in **Same Migration File** atomically.
*   **Incident Prevention Checklist**:
    - [ ] Checked existing policy list?
    - [ ] Followed naming convention?
    - [ ] Included legacy policy `DROP` in same migration?
    - [ ] **The Copy-Paste Mandate**: Did you copy-paste the policy name? Typing is rejected. Exact match required.
*   **Strictification Drop Mandate**:
    *   **Warning**: RLS policies are evaluated using an **additive (OR) model**. If existing Permissive policies (e.g., `USING (true)` "anyone OK" rules) remain, adding strict policies is **effectively meaningless** as the existing lenient policy takes precedence.
    *   **Action**: In security hardening migrations, you MUST execute `DROP POLICY IF EXISTS "legacy_policy_name" ON ...;` **before** creating new strict policies to physically seal existing holes.
    *   **Template**:
        ```sql
        -- Step 1: DROP existing lenient policy (MANDATORY)
        DROP POLICY IF EXISTS "legacy_permissive_policy" ON public.target_table;
        -- Step 2: Create new strict policy
        CREATE POLICY "target_table_select_policy" ON public.target_table
        FOR SELECT USING (strict_condition);
        ```

### Rule 3.5: Public Read Protocol (Anti-Vault Paradox)
*   **Principle**: "Security" does not mean dysfunction.
*   **Law**:
    1.  **Public Read**: Data with no reason to be private (Public Articles, Store Info) should be aggressively opened via `FOR SELECT USING (true)`.
    2.  **Strict Write**: Writes (`INSERT/UPDATE/DELETE`) remain strictly locked.
    3.  **Separation**: Do not confuse Read and Write permissions; do not block Read just to protect Write.

---

## 4. Performance & Scalability

### Rule 4.1: Indexing Hygiene Protocol
*   **FK Indexing**: **Always** index Foreign Keys (FK). FK without index is "Performance Debt".
*   **Naming Convention**: `idx_<table_name>_<column_name>`.
*   **Unused Purge**: Regularly check `unused_index` warnings. Delete dead indexes to improve write performance, but wait for data growth before judging.

### Rule 4.2: Japanese Search Optimization
*   Use `pg_search` (tsvector) or `pgroonga` for Japanese full-text search.

### Rule 4.3: Scalability Strategy
*   **Infinite Scalability**: `select('*')` and unlimited queries banned. Pagination mandatory.
*   **Partitioning**: Introduce `pg_partman` when table records exceed **10 Million (10M)**.
*   **Read Replica**: Offload analysis queries to Replica.
*   **Archival**: Evacuate cold data to Object Storage.

---

## 5. Auth & Security
*   **Gotrue Delegation**: Delegate auth completely to Supabase Auth.
*   **Notification Architecture**:
    *   **Aggregation**: Aggregate duplicate actions (e.g., multiple likes) to prevent bombing.
    *   **Async Delivery**: Send emails via async job (`pgmq`).
    *   **The Smart Notification Control Protocol (Email Bomb Prevention)**:
        *   **Law**: Delay email notifications via job queue (mins to tens of mins).
        *   **Logic**: Check "if already read in app" before sending; skip if read.
        *   **Outcome**: Prevent "spamming for seen content" and user churn.

---

## 6. Storage & Delivery
*   **Cloudflare Proxy Shield**: Image delivery must go through Cloudflare.
*   **Bucket Separation**:
    *   **Public**: Store photos, avatars. Maximize CDN cache.
    *   **Private**: Invoices, personal docs. **Signed URL** and strict RLS mandatory.
    *   **Ads**: Separate banner ads (`bucket-ads`).
*   **User Upload Hygiene**: Resize on client, **Delete EXIF GPS** before upload.
*   **The Signed Upload URL Mandate (Direct-to-Storage Pattern)**:
    *   **Law**: Prohibit uploading large files (images, videos) through application servers (Vercel/Cloud Functions).
    *   **Flow**:
        1. **Server Action**: Verify auth/permissions, issue **Signed Upload URL**, return to client.
        2. **Client Direct Upload**: Client uploads directly to Storage.
    *   **Outcome**: Reduce app server load and avoid transfer costs/timeouts.

---

## 7. Operations & Migration

### Rule 7.1: The Migration Protocol (Ghost Table Defense)
*   **Remote Execution**: Use Dashboard SQL Editor for schema changes, save log to `supabase/migrations` (Git).
*   **Migration Timestamp Hygiene**:
    *   **Action**: Always check `ls supabase/migrations` for **latest timestamp** to ensure order integrity.
*   **Atomic Migration**: `DROP` and `CREATE` policies in same file.
*   **Ghost Table Defense**:
    *   **Law**: `ALTER` or `CREATE POLICY` on non-existent tables causes errors.
    *   **Action (Table Existence Verification)**: Use `DO $$ ... IF EXISTS ...` block when referencing external/uncertain schemas. No assumptions.
*   **Remote Schema Warning**: Always check current DB state (Dashboard/`pg_tables`) before writing SQL.

### Rule 7.2: IPv6 & CI/CD Protocol
*   **GitHub Actions**: Use `supabase link` (Connection Pooler) or `SUPABASE_DB_URL` (Direct) appropriately to prevent IPv6 errors.

### Rule 7.3: Data Seeding & Caching Determinism
*   **Seed Determinism**: Initial data (`seed.sql`) must use **Fixed IDs/Values**.
*   **Cache Versioning**: When caching master data (`unstable_cache`), always suffix cache keys (e.g., `master_data_v2`) to prevent Cache Rot during schema changes.
*   **Verification**: Verify actual data count after seeding. CLI "Up to date" is not proof.

### Rule 7.4: Migration Idempotency Protocol
*   **Mandate**: Migrations must produce same result upon re-execution.
*   **Implementation**: Use `CREATE TABLE IF NOT EXISTS`, `DROP ... IF EXISTS`, etc.

### Rule 7.5: Cache Reload Protocol
*   **Mandate**: After major schema changes (column add/delete, type change):
    1.  Regenerate `database.types.ts`.
    2.  Restart Dev Server.
    3.  Restart Production Service / Refresh Connection Pool.

### Rule 7.6: The Zero SQL Editor Policy (History Protection)
*   **Law**: **Direct INSERT/UPDATE/DELETE** or **DDL** via Supabase Dashboard SQL Editor is **Strictly Prohibited** (No History).
*   **Action**:
    1.  Create local migration `supabase migration new fix`, deploy via Git.
    2.  Restrict SQL Editor to Read-only usage (Query Debugging).

---

## 8. Maintenance & Hardening

### Rule 8.1: Security Hardening (The Fortress)
*   **Public Schema Guard**: `REVOKE CREATE ON SCHEMA public FROM PUBLIC;`.
*   **View Security**: `security_invoker = true`.
*   **Search Path Defense**: `SECURITY DEFINER` functions MUST use `SET search_path = ''` and schema-qualified references (`public.users`).

### Rule 8.2: The Audit Log Mandate / WORM
*   Record DB changes in `audit_logs`. Table must be **Append-Only** (RLS protected).

### Rule 8.3: The Comprehensive RLS Audit
*   **Cascading Verification**: Verify RLS changes with **Anonymous User**.
*   **Monthly Audit Mandate**: Checklist:
    - [ ] Policy exists for all actions?
    - [ ] Admin access guaranteed?
    - [ ] General users restricted to own data?
    - [ ] Scalar subquery wrapping applied?

### Rule 8.4: RLS Post-Change Verification Protocol
*   **Verification Scope**:
    1.  **Security Advisor**: Zero warnings.
    2.  **Functional Test**: Admin/User/Anon.
    3.  **Performance**: No unintended sequential scans.
*   **Emergency Recovery**: Immediate `FOR SELECT USING (true)` for affected tables if incident occurs.

---

## 9. Domain Data Modeling

### Rule 9.1: Universal Settings & Tenant-Aware Naming
*   **Strict Column Enforced**: App settings in normalized columns. No `jsonb` config.
*   **Tenant-Aware Naming (SaaS Readiness)**:
    *   **Law**: Distinguish internal resource names for Multi-tenant/Whitelabel.
    *   **Action**: Use `site_` or `account_` for tenant-specifics. Use `system_` only for immutable platform settings.

### Rule 9.2: Static Page Ban (CMS Sovereignty)
*   ToS/Privacy Policy managed in **Headless CMS**. No hardcoded static files.

### Rule 9.3: Structural Integrity Protocols
*   **Structured Tagging**: `tags` table for centralized management.
*   **Business Hours**: Structured JSONB, prioritizing `holidays` logic.
*   **Reputation System**: **Bayesian Average** for reliable scoring.
*   **Geo-Centric**: Physical locations MUST have `latitude`/`longitude` and support location-based search.

---

## 10. Universal Portability
*   **Ecosystem Portability**: Data is a "Digital Asset". Adopt industry standard schemas and metadata for ecosystem compatibility.

---

## 11. Backend Governance

### Rule 11.1: The Data Residency Protocol (Rule 26.1)
*   **Law**: PII and legal docs must physically reside in specified regions (e.g., Japan) per GDPR/APPI.
*   **Action**: Design Multi-region Read/Local Write architectures considering future Data Localization requirements.

### Rule 11.2: The Audit Bypass Anti-Pattern (Server Action Mandate)
*   **Law**: Direct writes from client side bypass server Audit Logs and validation, creating a "Governance Hole".
*   **Action**:
    1.  **Surgical Write**: Consolidate writes into **Server Actions** that call `recordAuditLog`.
    2.  **Exception**: If client INSERT is unavoidable, implement `AFTER INSERT` DB Trigger to enforce logging.

### Rule 11.3: The RLS Best Practices Protocol (Policy Hygiene)
*   **Law 1: No Redundant Admin Policy**: `service_role` key completely bypasses RLS. Therefore, policies with `TO service_role` are **meaningless and redundant**. Control admin access at the application layer (`is_admin()` helper).
*   **Law 2: One Policy Per Action**: If multiple `PERMISSIVE` policies exist for the same table and same action (e.g., `SELECT`), PostgreSQL combines them with `OR`. This creates unintended access grants. Enforce **1 table, 1 action = 1 policy** as a rule.
*   **Law 3: No WITH CHECK (true)**: `WITH CHECK (true)` means "anyone can write." Applying this to production tables is strictly prohibited. Always include ownership checks via `auth.uid()` or admin role checks.

### Rule 11.4: The Poison Row Prevention Protocol (Type Collapse Prevention)
*   **Context**: When extending auto-generated types (`database.types.ts`) using intersection types (`&`), setting `Insert` / `Update` to `never` breaks type inference (Type Collapse), causing legitimate INSERT/UPDATE operations to be rejected by type errors.
*   **Law**: Overwriting the `Insert` / `Update` subtypes of auto-generated types with `never` in extended type definitions is prohibited.
*   **Action**:
    1.  **Type Alias**: Use **`type` aliases** instead of `interface` for extended types (compatibility with Mapped Types).
    2.  **Intersection Safety**: When extending via intersection types, only target `Row` and let `Insert` / `Update` inherit the original types as-is.
    3.  **Validation**: After defining an extended type, verify that `supabase.from('table').insert({...})` compiles successfully.

### Rule 11.5: The Idempotent Migration Protocol
*   **Context**: Migrations run in both "clean rooms" (CI's fresh DB) and "dirty rooms" (production DB with existing data). A design that guarantees success in both environments is required.
*   **Law**: Migration files MUST have **idempotency**—producing the same result no matter how many times they are executed.
*   **Action**:
    *   **Functions**: Use `CREATE OR REPLACE FUNCTION` instead of `CREATE FUNCTION`.
    *   **Policies**: Write `DROP POLICY IF EXISTS` before `CREATE POLICY`.
    *   **DML**: Attach `ON CONFLICT ... DO NOTHING` or `DO UPDATE` to `INSERT` to prevent conflicts with existing data.
    *   **Tables/Indexes**: Always include `IF NOT EXISTS`.
*   **Rationale**: To handle re-execution in CI/CD pipelines or re-application after rollbacks. Non-idempotent migrations are "bombs."

### Rule 11.6: The Admin/System Write Service Role Mandate
*   **Law**: Admin write operations (Create/Update/Delete) MUST use **`serviceRoleKey` (`createAdminClient()`)**, not `anon` key + Cookie session (`createClient()`).
*   **Reason**:
    1.  Session information may not be correctly passed when calling Supabase via Server Actions.
    2.  RLS rejecting `UPDATE` **returns no error but 0 affected rows (silent failure)**.
    3.  Admin operations frequently need to exceed RLS constraints for business reasons.
*   **Action**:
    1.  **Admin Write**: All write operations from the admin dashboard MUST use `createAdminClient()`.
    2.  **System Job**: Background jobs (Cron, Webhook, etc.) MUST also use `createAdminClient()` (no user session exists).
    3.  **Read is OK**: Admin read operations can use `createClient()`, but `createAdminClient()` is recommended for consistency.

### Rule 11.7: The Silent RLS Failure Detection Protocol
*   **Law**: When RLS policies reject an operation, PostgREST **returns no error but "0 affected rows"**. This is a "Silent Failure" and the most difficult-to-detect bug source.
*   **Action**:
    1.  **Count Check**: After UPDATE/DELETE operations, verify the return value's `count` is not `null` or `0`. `hasError: false` with `count: null` is an RLS violation signal.
    2.  **Explicit Error**: When `count === 0`, implement a wrapper function that returns an explicit error (e.g., `throw new Error('RLS policy may have blocked this operation')`).
    3.  **Logging**: In suspected silent failure cases, log `{ operation, table, userId, affectedRows }` to enable post-mortem investigation.
*   **Diagnostic**: "Save succeeded but data reverts on reload" → **Suspect Silent RLS Failure**.

### Rule 11.8: The RPC Scope Limitation Protocol
*   **Law**: Pushing complex business logic (chained conditionals, external API call simulation, multi-entity workflows) into DB-side RPCs (PL/pgSQL functions) is **prohibited**.
*   **Action**:
    1.  **Atomic Operations Only**: Restrict RPC usage to "atomic data operations." Permitted uses: bulk updates (`UPDATE ... WHERE id = ANY(...)`), system permission checks, aggregate queries, multi-table operations within a single transaction.
    2.  **Application Layer Logic**: Conditional branching, workflow control, external service integration, notification dispatch, and other business logic MUST be written in the application layer (Server Actions / TypeScript, etc.).
    3.  **Debuggability**: PL/pgSQL has low type safety and limited debugging tools. Keeping logic in the application layer enables breakpoints, log output, and easier test writing.
    4.  **DB Load Offloading**: Pushing heavy computation into the DB side pressures the DB connection pool and causes latency for other queries. Offload computation to the application layer.
*   **Rationale**: Concentrating business logic in RPCs creates a triple risk of debugging difficulty, lack of type safety, and increased DB load. Restrict RPCs to "operations the DB processes most efficiently" and maintain proper separation of concerns with the application layer.

### Rule 11.9: The Ghost Migration Ban
*   **Law**: DB operations not captured in migration files (manual column additions/changes/deletions, schema changes via Dashboard, etc.) are defined as **"Ghost Migrations" and are strictly prohibited**.
*   **Action**:
    1.  **Migration File Mandate**: All schema changes MUST go through migration tools (`supabase migration new`, etc.) and be saved as migration files in Git.
    2.  **No Dashboard Edits**: Direct schema changes via DB management consoles (Supabase Dashboard, pgAdmin, etc.) are prohibited as they make history tracking impossible. Even in emergencies, a migration file MUST be created after the fact and committed to Git.
    3.  **Schema Consistency Protocol**: When the local environment's schema diverges (becomes contaminated) from migration files, do NOT hesitate to rebuild the DB (`supabase db reset`, etc.). Always treat migration files as the Source of Truth, with the local DB as subordinate.
    4.  **Verification**: After applying migrations, verify that the diff between local and remote schemas is zero. If differences exist, suspect the presence of Ghost Migrations.
*   **Rationale**: Changes not recorded in migration files cause non-reproducibility across teams, CI/CD failures, and inconsistencies with the production environment. The principle that "all changes are recorded" is the only method that guarantees schema reliability.

## 12. Migrations & Privileged Operations

### Rule 12.1: The Admin Write Service Role Protocol
*   **Law**: DB write operations from admin panels or background jobs MUST use a **privileged client (Service Role Key)** that does not depend on user authentication sessions. Admin writes via regular clients (user session) risk being silently rejected by RLS policies.
*   **Action**:
    1.  **Admin Write**: All write operations (INSERT/UPDATE/DELETE) from admin panels MUST use a privileged client capable of bypassing RLS.
    2.  **System Job**: Background jobs (Cron, Webhook, batch processing, etc.) MUST also use a privileged client (no user session exists).
    3.  **Principle of Least Privilege**: Privileged client usage MUST be restricted to server-side code. Using Service Role Key in client-side code is **strictly prohibited**.
    4.  **Audit Trail**: Since privileged client operations bypass RLS, explicitly record audit logs at the application layer.
*   **Rationale**: Even in server-executed code (Server Actions, etc.), authentication information may not be properly passed depending on the framework's session management mechanism, causing RLS to unintentionally reject operations. Admin operations that complete with "no error, 0 affected rows" — a "Silent Failure" — are the most difficult bugs to discover.

### Rule 12.2: The Idempotent Migration Protocol
*   **Law**: Database migration files MUST guarantee **idempotency (producing the same result no matter how many times executed)**. Always anticipate that migrations may be partially executed across CI, preview, and production environments.
*   **Action**:
    1.  **CREATE OR REPLACE**: Use `CREATE OR REPLACE` for creating/updating Functions and Views. Prefer declarative definitions over `ALTER`.
    2.  **IF NOT EXISTS**: Use `CREATE TABLE IF NOT EXISTS` and `CREATE INDEX IF NOT EXISTS` for table and index creation.
    3.  **DROP IF EXISTS + CREATE**: For objects where `CREATE OR REPLACE` is unavailable (policies, triggers), use the `DROP ... IF EXISTS` → `CREATE` pattern.
    4.  **Defensive DML**: Use `INSERT ... ON CONFLICT DO NOTHING` (or `DO UPDATE`) for seed data insertion to prevent duplicate insert errors.
*   **Rationale**: CI environments always achieve idempotency since they apply migrations against an empty DB, but preview environments and manual recovery scenarios may have partially applied past migrations. Non-idempotent migrations cause deployment failures in these environments.

### Rule 12.3: The Anti-Permissive Policy Duplication Mandate
*   **Law**: In RLS (Row Level Security) policy design, **creating redundant Permissive policies for the same role and same action is prohibited**. In particular, `service_role` bypasses RLS entirely, making separate admin policies unnecessary.
*   **Action**:
    1.  **One Policy Per Role-Action**: Do not create multiple Permissive policies for the same role (`authenticated`, `anon`, etc.) and same action (`SELECT`, `INSERT`, etc.) on the same table. Combine multiple conditions with `OR` into a single policy.
    2.  **No service_role Policy**: Since `service_role` completely bypasses RLS, creating RLS policies for `service_role` is redundant and prohibited.
    3.  **Policy Audit**: When adding or modifying existing policies, list all policies for the same table and verify there are no logical duplications.
*   **Rationale**: PostgreSQL Permissive policies are combined with `OR`, creating a risk of unintentionally permitting a wider scope. The one-policy-per-role-action principle clarifies permission intent and prevents security holes.

### Rule 12.3.1: The RLS Auth Function InitPlan Optimization
*   **Law**: When using authentication functions such as `auth.uid()`, `auth.role()`, `current_setting()` within RLS policies, they MUST be **wrapped with `(select ...)`** to prevent re-evaluation on each row.
*   **Action**:
    1.  **Subquery Wrap**: Write `USING (user_id = (select auth.uid()))` instead of `USING (user_id = auth.uid())`.
    2.  **All Auth Functions**: Apply to all session-returning functions: `auth.uid()`, `auth.role()`, `auth.jwt()`, `current_setting()`, etc.
    3.  **Inside EXISTS Too**: Within `EXISTS (SELECT 1 FROM ... WHERE ... = auth.uid())`, wrap the inner `auth.uid()` as `(select auth.uid())` as well.
*   **Rationale**: Without wrapping, PostgreSQL re-evaluates these functions on every row scan (treated as Volatile). Wrapping with `(select ...)` enables the optimizer to evaluate the result as an **InitPlan (pre-computation)** only once, achieving dramatic performance improvements on large tables.
*   **Anti-Pattern**:
    ```sql
    -- ❌ Prohibited: auth.uid() re-evaluated per row
    USING (user_id = auth.uid())
    ```
*   **Correct Pattern**:
    ```sql
    -- ✅ Correct: Evaluated once via InitPlan
    USING (user_id = (select auth.uid()))
    ```

### Rule 12.4: The Type Extension Safety Protocol
*   **Law**: When extending auto-generated type definitions from database SDKs, ORMs, etc., with application-specific types, techniques that do not compromise type safety must be used.
*   **Action**:
    1.  **No `never` in Type Extensions**: Prohibit type extensions that overwrite auto-generated type properties with `never`. `never` means "unreachable," causing a "Poison Row" where properties exist at runtime but are inaccessible at the type level.
    2.  **Type Alias over Interface**: Prefer `type` aliases with intersection types (`&`) over `interface extends` for extending auto-generated types. Interface `extends` carries the risk of unintended contamination through Declaration Merging.
    3.  **Simple Intersection over Omit**: Excessive use of `Omit<GeneratedType, 'key1' | 'key2' | ...>` severely degrades type readability. Use simple intersection types whenever possible, and use `Omit` only when changing a property's type.
    4.  **Generated Type Sovereignty**: Manual editing of auto-generated type files is strictly prohibited. Extensions must always be done in separate files.
*   **Rationale**: Auto-generated types are valuable assets reflecting the "truth of the DB schema." Improper extensions distort this truth and cause divergence between type definitions and actual data.

### Rule 12.5: The Migration System Schema Exclusion Protocol
*   **Law**: When creating scripts that batch-modify function security settings (`search_path`, `SECURITY DEFINER/INVOKER`, etc.) in database migrations, **functions in system schemas managed by the hosting service must be included in the exclusion list**.
*   **Action**:
    1.  **Exclusion List**: Explicitly exclude functions from system schemas such as `auth`, `storage`, `realtime`, `supabase_functions`, `graphql`, `graphql_public`, `pgsodium`, `vault`, and `extensions` from batch changes.
    2.  **Schema Filter**: Use `n.nspname NOT IN ('auth', 'storage', ...)` in the `WHERE` clause of migration scripts to physically prevent interference with system schema functions.
    3.  **Dry Run**: Before applying batch-change migrations, preview the list of targeted functions (execute `SELECT` only) and verify that no system functions are included.
*   **Rationale**: Modifying the `search_path` or security settings of managed service system functions (authentication, storage management, etc.) can destroy the service's foundational capabilities. This is a fatal failure that immediately leads to complete service outage.

### Rule 12.6: The RLS InitPlan Optimization Protocol
*   **Law**: Session function calls such as `auth.uid()` and `auth.role()` within RLS (Row Level Security) policies **must be written as sub-queries using `(SELECT auth.uid())`** format.
*   **Action**:
    1.  **Sub-Select Wrapping**: When using `auth.uid()` in `USING` or `WITH CHECK` clauses of RLS policies, always use the `(SELECT auth.uid())` format. This allows PostgreSQL's query planner to evaluate the function once and cache the result as an InitPlan, preventing per-row re-evaluation.
    2.  **All Auth Functions**: Apply the same pattern not only to `auth.uid()` but to all session functions including `auth.role()`, `auth.jwt()`, etc.
    3.  **Linter Integration**: If Supabase's security linter or similar tools raise `auth_rls_initplan` warnings, fix them immediately.
    4.  **Performance Impact**: For large tables (tens of thousands of rows or more), applying this pattern can result in performance differences of orders of magnitude.
*   **Rationale**: When functions within RLS policies are re-evaluated per row, O(N) function calls occur with every table scan. Sub-query wrapping reduces this to O(1), dramatically improving query performance on large tables.

### Rule 12.7: The Client Identity Audit Protocol
*   **Law**: Before optimizing RLS policies (consolidation or deletion), **comprehensively audit which IDENTITY** (`service_role` / User JWT / Anonymous) is used by **all access paths** (Server Actions, API Routes, SSR, admin panels, etc.) that access the target data.
*   **Action**:
    1.  **Access Path Inventory**: List all code paths (Service layer, Gateway layer, Server Actions, etc.) that access the target table and identify the client initialization function (`createClient`, `createAdminClient`, etc.) used by each.
    2.  **No Blind Optimization**: Do not delete user JWT policies because "service_role is sufficient." If Server Actions use user JWT, deleting those policies silently blocks legitimate access.
    3.  **Identity Matrix**: For complex tables, create a "table × operation × identity" matrix and verify that all access patterns are covered by at least one RLS policy.
    4.  **Post-Change Verification**: After modifying or deleting policies, actually operate all affected UI flows (admin panel edit/save, user-facing browse, etc.) to verify functionality.
*   **Rationale**: Careless deletion through RLS policy "optimization" invites not security holes but "invisibility of legitimate access." Especially when admin panels use Server Actions (user JWT context), deleting JWT policies thinking service_role is sufficient silently rejects administrators' CRUD operations.

### Rule 2.8: The Idempotent Migration Protocol
*   **Law**: Migration files must be written in an **idempotent structure** that produces the same result regardless of how many times they are executed. When including DML (data manipulation), write defensive code that anticipates collisions with production data.
*   **Action**:
    1.  **DDL Idempotency**: Always use `IF NOT EXISTS` for `CREATE TABLE`, `IF EXISTS` for `DROP TABLE`, and `IF NOT EXISTS` for `ALTER TABLE ADD COLUMN` (PostgreSQL 9.6+).
    2.  **DML Idempotency**: Use `ON CONFLICT DO NOTHING` or `ON CONFLICT DO UPDATE` for `INSERT` to prevent errors on duplicate data.
    3.  **Function/Trigger Idempotency**: Use `CREATE OR REPLACE FUNCTION` for safe function recreation. Write triggers as `DROP TRIGGER IF EXISTS ... ; CREATE TRIGGER ...`.
    4.  **RLS Policy Idempotency**: Execute `DROP POLICY IF EXISTS "policy_name" ON table_name;` before creating policies to prevent collisions with existing policies.
*   **Rationale**: Non-idempotent migrations cause critical failures — "a migration that passed once breaks" — during staging/production environment differences, migration re-execution, and branch conflicts. Idempotency is the foundation of safe deployment and environment reproducibility.

### Rule 2.9: The Read-Write Privilege Symmetry
*   **Law**: In admin panels and similar interfaces, when writes (Mutations) are executed with privileged clients (`service_role`, etc.), **reads (Query for Edit Form) must also guarantee equivalent visibility**. Using different privilege-level clients for writes and reads causes the opaque bug of "save succeeds but data reverts on reload."
*   **Action**:
    1.  **Privilege Parity Check**: When using `createAdminClient()` (RLS bypass) for writes, verify that the corresponding "fetch for editing" is also executed with equivalent privileges. If reads use `anon` or restricted `authenticated` permissions, RLS filters out some data, feeding stale or empty data into the form.
    2.  **Select Spec Synchronization**: Verify that the Select Specification used in DTOs encompasses all columns that are save targets. Adding a column to only one side creates a "half-lung" state where "data is saved but not displayed in the edit screen."
    3.  **Admin Gateway Awareness**: In functions with explicit admin purposes (e.g., `getAdminStoreById`), use privileged clients as needed or fully open RLS policies for admin roles.
    4.  **Post-Update Verification**: For high-importance mutations (image reordering, status changes, etc.), consider applying the "Verification Fetch" pattern: immediately after update, execute a `select` with the same ID and verify current values via logs.
*   **Rationale**: Writes via privileged clients bypass RLS and correctly save data, but when non-privileged clients are used during edit screen reload, RLS `SELECT` policies exclude some columns or records. As a result, users feel "data wasn't saved" and repeat the same operation, creating a vicious cycle of expanding data inconsistencies.

### Rule 2.10: The RLS Policy Consolidation Mandate
*   **Law**: When multiple `PERMISSIVE` policies are defined for the same table and same operation (SELECT, INSERT, UPDATE, DELETE), they must be **consolidated into a single policy with OR conditions** wherever possible to reduce evaluation overhead.
*   **Action**:
    1.  **Consolidation by Operation**: Instead of defining separate `SELECT` policies for `anon` and `authenticated`, consolidate into a single policy like `USING (true)` or `USING (auth.role() IN ('anon', 'authenticated'))`. PostgreSQL evaluates all `PERMISSIVE` policies with OR conjunction, so splitting into individual policies unnecessarily increases evaluation count.
    2.  **Service Role Redundancy Elimination**: Since `service_role` completely bypasses RLS, explicit policies targeting `service_role` are redundant. Delete policies that target only `service_role`.
    3.  **RESTRICTIVE Policy Awareness**: `RESTRICTIVE` policies are evaluated as **AND conditions** against all `PERMISSIVE` policies, so only `PERMISSIVE` policies are consolidation targets. Consolidating `RESTRICTIVE` policies may cause side effects.
    4.  **New Table Checklist**: When designing RLS policies for new tables, use "minimum number of policies per operation" as a design principle. When creating more than one policy for the same operation, explicitly comment the reason why consolidation is not possible.
*   **Rationale**: Since PostgreSQL evaluates all `PERMISSIVE` policies for the same operation with OR conjunction, splitting functionally equivalent conditions into multiple policies doesn't change the result but increases evaluation overhead. For tables with large numbers of records especially, unnecessary policy splitting directly impacts query performance.

### Rule 2.11: The Orphan File Defense Protocol
*   **Law**: Leaving storage files behind when deleting database records (Orphan Files) is prohibited. Orphan files continuously increase storage costs and create risks of unintended data persistence.
*   **Action**:
    1.  **Cascade Deletion**: Within `DELETE` triggers or application mutation logic, incorporate processing to **asynchronously delete** related storage files when DB records are deleted. Synchronous deletion impacts response times, so asynchronous jobs (Queue/Worker) are recommended.
    2.  **Batch Cleanup**: Set up a sweeper that runs periodically (e.g., weekly) as a batch job to detect and delete storage files with no corresponding DB reference (orphan files).
    3.  **Soft Delete Awareness**: When using soft delete (`deleted_at`), defer file deletion until physical record deletion (or archive migration). Deleting files at soft-delete time causes file loss upon restoration.
*   **Rationale**: The practice of deleting only records while leaving files behind causes a "silent leak" in storage costs. Especially for services with high UGC (User Generated Content), tens of gigabytes of orphan files accumulate monthly, resulting in significant FinOps losses.

### Rule 2.12: The Safety Valve Protocol
*   **Law**: Major entity tables (users, content, products, stores, etc.) MUST have at least one **free-text column** (`notes`, `remarks`, `internal_memo`, etc.) that allows recording irregular information without requiring schema changes.
*   **Action**:
    1.  **Escape Hatch**: In real-world operations, exceptions frequently arise that strict schemas alone cannot express (e.g., "closed for winter", "call to confirm", "special handling required"). Free-text columns serve as an "Escape Hatch" to record such information without waiting for schema changes.
    2.  **Type**: `TEXT` type is recommended (or `TEXT` if Markdown support is needed). `VARCHAR(n)` character limits become operational obstacles, so avoid unless there is a specific reason.
    3.  **Nullable**: Free-text columns should allow `NULL`. Not all records require descriptions.
    4.  **No Business Logic**: Depending on free-text column values for business logic (conditional branching, filtering) is prohibited. Information required for logic must be promoted to normalized columns.
*   **Rationale**: Schema changes require migration, deployment, and testing cycles, and cannot be addressed immediately. By installing safety valve columns, information that "needs to be recorded right now" can be saved without loss, achieving both operational flexibility and development speed.

### Rule 2.13: The Time-Series Partitioning & Retention Protocol
*   **Law**: Tables that grow over time—such as log data (`audit_logs`, `access_logs`) and transaction histories (`point_transactions`, etc.)—MUST be designed with **Range Partitioning** keyed on `created_at`.
*   **Action**:
    1.  **Range Partitioning**: Use `pg_partman` or similar to automatically create monthly or quarterly partitions for time-series tables. Consider adoption when a single table's record count is projected to exceed 10 Million (10M).
    2.  **Retention Policy**: Old partitions (e.g., older than 2 years) must be automatically **Detached** and excluded from active query targets. After detachment, plan to move them to Cold Storage or export to Object Storage.
    3.  **No Premature Partitioning**: Introducing partitions during development phases with little data is over-engineering. Adopt a "Ready-to-Fire" strategy: complete the design before reaching the threshold (10M records) and apply when reached.
*   **Rationale**: Tables that grow without partitioning cause index size inflation, extended vacuum times, and increased backup times. Time-series partitioning brings operational overhead for old data near zero while enabling compliance with legal retention requirements.

### Rule 2.14: The Cold Data Offloading Protocol
*   **Law**: Data that "has not been accessed for 1+ years" or "has legal retention requirements but is rarely referenced" MUST be separated from the active DB and offloaded to **Archived Tables** or Object Storage (CSV/Parquet).
*   **Action**:
    1.  **Archived Tables**: Prepare an archive schema (e.g., `archives`) and move old data there (e.g., `archives.old_audit_logs`). Application normal queries must not reference this schema.
    2.  **Object Storage Export**: Export large amounts of old data in CSV or Parquet format to Object Storage (S3/R2/GCS, etc.). When analysis is needed, reference from a Data Warehouse (BigQuery, etc.).
    3.  **Transparent Migration**: Execute data offloading in a manner that has zero impact on application behavior. Verify that archived records are not included in API responses.
    4.  **Compliance**: Data with legal retention requirements (Tax Law: 7 years, Labor Law: 3 years, etc.) must NOT be physically deleted until the retention period has elapsed. Manage retention periods at the archive destination.
*   **Rationale**: Keeping old data in the active DB causes index size bloat, query performance degradation, and increased backup times. Separating storage by data "temperature" maximizes both active data performance and cost efficiency.

### Rule 2.15: The RLS Inheritance Protocol (Chain of Trust)
*   **Law**: Access permissions for child/grandchild tables (e.g., medical records, comments, attachments) must **NOT be defined independently**, but MUST always be determined by referencing the parent table's (e.g., pets, posts, projects) ownership or participation via `EXISTS` subqueries.
*   **Action**:
    1.  **Parent Ownership Check**: In child table RLS policies, instead of authenticating directly with `auth.uid() = user_id`, verify parent table ownership via `EXISTS (SELECT 1 FROM parent_table WHERE id = child_table.parent_id AND user_id = (select auth.uid()))`.
    2.  **Chain of Trust**: When table hierarchies extend to 3+ levels (grandparent → parent → child), always trace back to the top-level ownership for verification. Checking only intermediate tables creates security holes.
    3.  **SECURITY DEFINER for Cross-Table**: When permission checks need to reference other tables (`profiles`, etc.), wrap them in `SECURITY DEFINER` functions with a fixed `search_path` (`SET search_path = public, pg_temp`).
    4.  **No Redundant Columns**: The approach of "simplifying" permission checks by duplicating `user_id` in child tables is discouraged as it becomes a breeding ground for data inconsistency. Permissions must always be derived through Relations.
*   **Rationale**: Defining independent permission logic per child table causes update omissions when parent table permissions change, becoming a source of security holes. Inheriting parent table ownership as a Chain of Trust achieves both centralization of permission logic and elimination of inconsistencies.

### Rule 2.16: The Brittle Table Reference Prohibition
*   **Law**: Concatenating table names as dynamic strings within SQL functions (`CREATE FUNCTION`) or RPCs (`EXECUTE 'SELECT * FROM ' || table_name`) is **prohibited**.
*   **Action**:
    1.  **Static References Only**: All table references within SQL functions MUST be written as static SQL statements. Dependencies MUST be resolved at compile time (or migration application time).
    2.  **No Dynamic EXECUTE**: Patterns like `EXECUTE format('SELECT * FROM %I', variable)` are prohibited because they cannot detect typos or references to non-existent tables until runtime.
    3.  **Schema Change Safety**: Static table references ensure that dependent functions error at migration time when tables are renamed or deleted, enabling early problem detection.
*   **Rationale**: Dynamic table references are a breeding ground for SQL injection and make it impossible to trace impact scope during schema changes. Mandating static references ensures compile-time safety and maintainability.
