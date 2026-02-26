# 30. Engineering Excellence (General)

### 13.48. The Explicit Mapping Mandate
*   **Law**: When constructing write payloads for database operations in Service layers or Server Actions, using spread syntax (`...input`) for bulk expansion is **prohibited**. All fields must be explicitly mapped.
*   **Action**:
    1.  **No Spread Payload**: Spread-based payload construction like `supabase.from('table').update({ ...formData })` is prohibited. Unexpected fields in the input object (UI state management fields, etc.) will be sent to the DB, causing errors or data contamination.
    2.  **Field-by-Field Construction**: Construct payloads by specifying each field individually, e.g., `{ name: input.name, email: input.email, status: input.status }`. This makes the scope of transmitted data explicit and review easier.
    3.  **JSONB Structural Mapping**: Nested JSON/JSONB structure fields must also be explicitly constructed rather than relying on top-level spread. Array data (image lists, etc.) in particular requires mapping that accurately maintains the original data's order and content.
    4.  **DTO-Payload Alignment Check**: When fields are added to DTOs, simultaneously add them to the Service layer mapping. Missing mappings are the most common cause of "saved but not reflected" silent bugs.
*   **Rationale**: While spread syntax is concise, it abandons control over "what gets sent." In large admin forms especially, the risk of UI state management fields, computed fields, and undefined fields contaminating the payload is high. Only explicit mapping guarantees data integrity.

### 13.49. The Mutation Count Verification Protocol
*   **Law**: When verifying the results of database write operations (INSERT/UPDATE/DELETE), you must check not only the presence of `error` but also the **number of affected rows (`count`)**. The combination of `error: null` and `count: 0` is a "Phantom Success" and must be treated as an effective failure.
*   **Action**:
    1.  **Count Validation**: For single-record operations with ID specification (`.eq('id', id)`), verify that `count` is `1` (or the expected number). If `count` is `0` or `null`, throw an exception indicating permission denial (RLS rejection) or record absence.
    2.  **Bulk Operation Awareness**: For bulk update/delete operations, verify that `count` matches the number of input data items. Partial success (only 7 out of 10 updated) indicates data inconsistency.
    3.  **Sub-Step Integrity**: When updating multiple tables sequentially within a single Service function, verify both `error` and `count` at every sub-step. Skipping a failed intermediate step results in a "Partial Phantom Success" where only some data is updated.
    4.  **Diagnostic Logging**: Always include `count` in mutation result logs (e.g., `Logger.info('Update result:', { count })`). In post-incident analysis, affected row count is the most critical clue.
*   **Rationale**: In databases using Row Level Security (RLS), queries with insufficient permissions may be silently rejected as "no error, 0 rows affected." The traditional pattern of checking only `error` cannot detect this "failure that looks like success," manifesting to users as the most opaque bug: "saved but not reflected."

### 13.50. The Authentication Guard Enumeration Consistency
*   **Law**: In Role-Based Access Control (RBAC), maintaining separate lists of allowed roles across multiple guard functions is **prohibited**. All guard functions must reference a shared constant array (e.g., `ALLOWED_ADMIN_ROLES`) to establish a Single Source of Truth (SSOT) for role definitions.
*   **Action**:
    1.  **Shared Role Constants**: Define allowed roles (`admin`, `super_admin`, `master_admin`, etc.) as a single constant array, and have all guard functions (page access control, Server Action authorization, RLS policies, etc.) reference this constant.
    2.  **Simultaneous Update Mandate**: When adding new roles, structure the system so all guard functions are automatically updated. Sharing a constant array means only one update location is needed.
    3.  **Dead Zone Detection**: To prevent opaque deadlocks where "you can access the screen but operations (save, etc.) fail silently," periodically audit that page-level guards and action-level guards reference the same role set.
    4.  **Failure Transparency**: When guard functions return authorization errors, catch them on the frontend and detect role inconsistencies immediately via `Logger.warn` in development environments.
*   **Rationale**: When the number of roles increases and not all guard functions are simultaneously updated, an extremely opaque deadlock occurs: "can log into the admin panel, but specific operations are silently rejected." These bugs produce no error messages, wasting enormous time on root cause identification.

### 13.51. The Sub-Step Mutation Integrity Protocol
*   **Law**: When executing multiple asynchronous write operations (INSERT/UPDATE/DELETE) sequentially within a single service method, **the `error` object must be verified at every sub-step**, and if an error occurs, the process must be immediately stopped with an exception thrown.
*   **Action**:
    1.  **No Silent Continue**: Proceeding to subsequent processing without checking the `error` return value, as in `await supabase.from('table').delete()`, is prohibited. Receive results as `const { error } = await ...` for every write operation and perform error checking.
    2.  **Step-by-Step Logging**: Output logs at the start and completion of each sub-step (e.g., `Logger.info('[Step 2/5] Updating tags...')`), enabling immediate identification of which step failed during incidents.
    3.  **Aggregate Error Reporting**: Wrap the entire service method in `try-catch` to prevent intermediate step failures from contaminating the final result (`return { success: true }`), returning an explicit failure response if any step throws an exception.
    4.  **Transaction Awareness**: Recognize that simple external API calls (PostgREST, etc.) are not treated as atomic transactions by default, and incorporate compensating transactions (rollback equivalents) and idempotency guarantees into the design for mid-process failures.
*   **Rationale**: Ignoring intermediate step failures in multi-table updates causes "Partial Phantom Success" where the main table is updated but related tables remain stale. Despite showing "save successful" to users, only some data is reflected, significantly delaying problem discovery.

### 13.52. The Error Object Transparency Mandate
*   **Law**: In error handling, directly concatenating error objects as strings (resulting in `[object Object]` output) is **prohibited**. Error properties such as `message`, `code`, and `details` must be **explicitly destructured** and recorded in logs.
*   **Action**:
    1.  **Structured Error Logging**: Output error object properties as individual fields, e.g., `Logger.error('Operation failed', { error: err.message, code: err.code, details: err.details })`. `Logger.error('Failed: ' + error)` produces `[object Object]`, making root cause identification impossible.
    2.  **Catch Block Standard**: In all `catch` blocks, determine whether the caught error is an `Error` instance, `PostgrestError`, etc., and extract properties appropriately for each type.
    3.  **Error Serialization**: In error responses returned to clients, appropriately transform the internal error structure and return in `{ success: false, error: 'Human-readable message', code: 'ERROR_CODE' }` format.
    4.  **Development vs. Production**: In development environments, include all error properties in logs. In production, mask sensitive information (stack traces, internal paths, etc.) and output only operationally necessary information (`code`, `message`).
*   **Rationale**: `[object Object]` is the most worthless piece of information in incident response. Database errors (Supabase `PostgrestError`, etc.) in particular carry rich diagnostic information such as `message`, `code`, `details`, and `hint`, but direct object concatenation loses all of these, making root cause analysis effectively impossible.

### 13.53. The Post-Mutation Verification Fetch Protocol
*   **Law**: Immediately after high-importance write operations (image reordering, status changes, permission changes, etc.), **execute an immediate `select` (re-fetch) with the same ID** and verify via logs that data has actually been persisted to the database.
*   **Action**:
    1.  **Verification Fetch Pattern**: Immediately after a mutation (`update`, `insert`, `delete`), retrieve the same record via `select` and output the post-update values to logs (e.g., `Logger.info('[Verify] Post-update:', { id, updatedAt: result?.updated_at })`). This enables 100% reliable differentiation between whether the problem is "DB write failure (RLS/Trigger)" or "application-side read/display failure (Cache/UI)."
    2.  **Diagnostic Isolation**: If the verification fetch returns updated values but the UI doesn't reflect them, the problem is definitively in the cache (Data Cache / Router Cache) or form re-initialization. Conversely, if the fetch returns old values, the problem is definitively in the DB layer (RLS rejection, trigger overwrite, etc.).
    3.  **Conditional Application**: Not every mutation needs this. Apply intensively in: (a) privileged operations involving RLS, (b) sequential multi-table updates, (c) areas where users report "saved but not reflected," (d) updates to complex JSONB data structures.
    4.  **Production Consideration**: In production environments, lower the verification fetch log level to `debug` or make it disableable via feature flags. However, maintain the ability to immediately enable it during debugging.
*   **Rationale**: "Saved but not reflected" is one of the most diagnostically difficult bugs in web applications. The only way to distinguish whether the cause is DB write failure (RLS, triggers, insufficient permissions), cache inconsistency, or form re-initialization issues is to verify the physical value in the DB immediately after the mutation. The verification fetch is the only reliable method for this immediate differentiation.
