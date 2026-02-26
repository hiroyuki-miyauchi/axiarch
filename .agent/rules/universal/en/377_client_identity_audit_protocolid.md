# 37. Backend Engineering (Supabase & PostgreSQL)

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

