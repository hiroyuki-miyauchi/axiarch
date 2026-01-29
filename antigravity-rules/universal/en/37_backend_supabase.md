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
