# 37. Backend Engineering (Supabase & PostgreSQL)
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
