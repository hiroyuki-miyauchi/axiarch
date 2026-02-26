# 37. Backend Engineering (Supabase & PostgreSQL)

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
