# 30. Engineering Excellence (General)

### 13.36. The UI-Layer Data Access Prohibition
*   **Law**: **Direct access to databases or external APIs from UI components** (page components, layout components, client components) is prohibited. All data access must go through the Service or Gateway layer.
*   **Action**:
    1.  **Service Layer Mandate**: Data retrieval and modification must always go through dedicated Service / Gateway / Action functions. The UI layer handles only the return values (DTOs) of these functions.
    2.  **No DB Client in UI**: Directly importing and using DB clients (ORM, SDK, etc.) in UI files is prohibited.
    3.  **DTO Boundary**: The Service layer must not return DB record structures as-is, but transform them into **DTOs (Data Transfer Objects)** containing only the data the UI requires.
    4.  **Omnichannel Readiness**: This separation enables reuse of the same Service layer across multiple clients — Web, native apps, external APIs, etc.
*   **Rationale**: Direct coupling between UI and data layers destroys testability and makes omnichannel deployment impossible. Inserting a Service layer achieves business logic aggregation, ease of testing, and client-agnostic architecture.

### 13.37. The Graceful Failure Contract
*   **Law**: Server-side processes (Server Actions, API handlers, etc.) are **prohibited in principle from using `throw new Error()`** for business logic failures. Instead, they must return **structured error responses** (e.g., `{ success: false, error: '...' }`) to be properly handled by the client side.
*   **Action**:
    1.  **No Raw Throw**: When Server Actions `throw`, client-side UI frameworks (React's `useActionState`, etc.) may process the error as an "unexpected exception," causing component cleanup or retry logic to run amok, potentially triggering infinite loops. Business errors (insufficient permissions, validation failures, etc.) must always be returned as structured responses.
    2.  **Common Response Type**: Define a common response type for all server actions (e.g., `ActionResult<T> = { success: true, data: T } | { success: false, error: string }`) so that clients can handle errors uniformly.
    3.  **Client-Side Feedback**: On the client side, display `success: false` cases as toast notifications or inline error messages to provide appropriate feedback to the user.
    4.  **Exception**: The use of `throw` is permitted only for fatal errors where program continuation is impossible (DB connection loss, missing environment configuration, etc.).
*   **Rationale**: Server-side security hardening (adding guards, etc.) and client-side error handling must be developed as a "pair." Hardening only the server without preparing the client's "error reception point" risks escalating a normal "insufficient permissions error" into a system-wide "infinite loop crash."

### 13.38. The Mutation Count Validation
*   **Law**: After database write operations (UPDATE / DELETE), **the number of affected rows (`count`) must always be verified**. Even when `error: null` (no error), `count: 0` may indicate a "silent rejection."
*   **Action**:
    1.  **Count Check**: For single-record update/delete operations specifying an ID, always retrieve `count` from the response and verify it equals the expected number of rows (typically `1`).
    2.  **Explicit Failure**: If `count` is `0` or `null`, throw an explicit error (e.g., `throw new Error('Update failed: No rows affected.')`) to prevent the UI from displaying a false success state.
    3.  **Instrumentation**: During debugging, log the mutation result's `count` to visualize write effectiveness.
    4.  **RLS Awareness**: In databases using Row Level Security (RLS), always keep in mind that insufficient permissions are returned as "0 rows affected" rather than as an error.
*   **Rationale**: Many database APIs (especially HTTP wrappers like PostgREST) do not report write failures due to insufficient permissions as errors. Implementations that only verify `error: null` cause the most difficult-to-diagnose "Phantom Success" — appearing to succeed while data is not actually persisted.

### 13.39. The Post-Mutation Verification Fetch
*   **Law**: For particularly critical mutations (image reordering, status changes, permission changes, etc.), it is recommended to **re-fetch the same record (SELECT)** immediately after the write operation and confirm via logs or assertions that the intended values have been persisted in the database.
*   **Action**:
    1.  **Verification Fetch**: Execute a `select()` with the same ID immediately after `update()` and log the current values. This enables 100% reliable isolation of whether the problem is "a write failure to the DB" or "a read/cache issue in the application."
    2.  **Diagnostic Isolation**: When data reverting after reload is reported, first use this pattern to verify the physical server-side values and identify the problem layer (DB / Cache / UI).
    3.  **Production Guard**: In production environments, consider the performance impact and enable this verification via a flag (`DEBUG_MUTATIONS=true`) or control it through log levels.
*   **Rationale**: There are many cases where data is not reflected even though the write operation itself succeeded — cache inconsistencies (framework Data Cache / Router Cache, etc.), value overwrites by triggers, etc. The immediate verification fetch is the most reliable debugging technique for swiftly identifying silent persistence failures.

# 30. Engineering Excellence (General)

### 13.40. The Read-Write Privilege Symmetry
*   **Law**: When a privileged client (admin permissions, etc.) is used for data writes (Mutations), **the "read for editing" must also guarantee equivalent visibility**. Mismatch between write and read permissions causes a "single-lung state."
*   **Action**:
    1.  **Read-Write Parity**: In admin panels and similar contexts, if writes are performed with a privileged client (RLS bypass, etc.), data retrieval for edit forms must also be performed at an equivalent permission level. Permission mismatch causes an extremely opaque bug where "saving succeeds but data reverts after reload."
    2.  **Spec Synchronization**: Verify that the projection used for data retrieval (Select Spec / column specification) encompasses all columns that are write targets. If the retrieval spec is missing columns, items will be saved but not displayed.
    3.  **Gateway Awareness**: Data retrieval functions for administrative purposes should explicitly indicate their purpose in the function name (e.g., `getAdminItemById`) and use an appropriately privileged client.
*   **Rationale**: Using different permission levels for writes and reads may not be a security "hole," but it causes data "invisibility." Especially in environments using RLS, if SELECT policies are incomplete, data existing in the DB is filtered out during retrieval and not displayed in the UI — creating a diagnostically challenging bug.

### 13.41. The Sub-Step Mutation Integrity Protocol
*   **Law**: When performing **multiple asynchronous write operations** within a single service method or transaction (INSERT/UPDATE to multiple tables, sequential calls to external APIs, etc.), **each step's result must be individually verified**.
*   **Action**:
    1.  **Per-Step Error Check**: Verify `error` / `count` / `status` immediately after each write operation. Executing subsequent steps assuming the first step succeeded while swallowing intermediate errors is the direct cause of "Partial Phantom Success."
    2.  **Fail-Fast Cascade**: If an error is detected at any step, return the error immediately without executing subsequent steps. Leaving partially updated state is a breeding ground for data inconsistency.
    3.  **Composite Error Reporting**: Aggregate results from multiple steps and construct an error response that clearly communicates to the caller which step failed (e.g., `{ step: 'update_metadata', error: '...' }`).
    4.  **Diagnostic Logging**: Log the execution result of each step (number of affected rows, impacted columns, etc.) to accelerate root cause identification during incidents.
*   **Rationale**: In multi-step write processes, ignoring errors at intermediate steps causes inconsistencies such as "main data was updated but related data remains stale." This type of partial success is extremely difficult to discover because the user sees "save successful."
