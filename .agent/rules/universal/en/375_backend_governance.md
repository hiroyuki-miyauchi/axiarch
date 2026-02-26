# 37. Backend Engineering (Supabase & PostgreSQL)

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
