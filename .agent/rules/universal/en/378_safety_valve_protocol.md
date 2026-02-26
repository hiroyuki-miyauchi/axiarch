# 37. Backend Engineering (Supabase & PostgreSQL)

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

# 37. Backend Engineering (Supabase & PostgreSQL)

### Rule 2.16: The Brittle Table Reference Prohibition
*   **Law**: Concatenating table names as dynamic strings within SQL functions (`CREATE FUNCTION`) or RPCs (`EXECUTE 'SELECT * FROM ' || table_name`) is **prohibited**.
*   **Action**:
    1.  **Static References Only**: All table references within SQL functions MUST be written as static SQL statements. Dependencies MUST be resolved at compile time (or migration application time).
    2.  **No Dynamic EXECUTE**: Patterns like `EXECUTE format('SELECT * FROM %I', variable)` are prohibited because they cannot detect typos or references to non-existent tables until runtime.
    3.  **Schema Change Safety**: Static table references ensure that dependent functions error at migration time when tables are renamed or deleted, enabling early problem detection.
*   **Rationale**: Dynamic table references are a breeding ground for SQL injection and make it impossible to trace impact scope during schema changes. Mandating static references ensures compile-time safety and maintainability.

