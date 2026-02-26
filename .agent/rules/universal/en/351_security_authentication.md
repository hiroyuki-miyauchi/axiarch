# 35. API Integration & Microservices
## 8. API Economy & Monetization
### 8.1. The API Product Mindset (Highest Engineering Standard)
*   **Law**: Treat all API outputs as "Salable Assets" and enforce protection via Tiering and DTOs. Internal shortcuts will exponentially increase as future debt.
*   **Rule**: Breaking Changes in API are "Product Defects (Recall Class)" and directly lead to loss of trust in the engineering team.
*   **Tiered Access**: Control via DTOs to enable code-level branching between "Free Plans (Restricted)" and "Paid Plans (Unrestricted)".
*   **Metadata Strategy (Stripe/FinOps)**:
    *   **Law**: Plan properties (Enterprise, enabled features, etc.) must be stored in the **Metadata** of the payment platform (Stripe), and code must behave dynamically by referencing it.
    *   **Outcome**: Secure flexibility for marketers and executives to change sales strategies immediately without engineering help (no deployment).
    *   **Tier 2 Readiness (Monetization First)**: When publishing Paid APIs (`/api/v1/*`), checking API Key Authentication (`X-API-KEY`) AND Stripe subscription status is mandatory. Publishing mere Public APIs (no gateway) without implementing this "Monetization Barrier" is not accepted as a "defeat" in business design.
    *   **Native App Exemption**: Access from our own Native App is treated as "Tier 2 (Enterprise) equivalent" as a special case and excluded from billing (Bundled).
*   **Data Monetization Privacy**:
    *   **Anonymization Interface**: APIs provided to external partners must return only statistical data processed via **k-anonymity** or **Differential Privacy**. Selling raw data is permanently prohibited.
*   **The Data-Driven Marketing Protocol (Plan Abstraction Mandate)**:
    *   **Law**: Hardcoding specific Plan IDs in code is prohibited.
    *   **Action**: Manage plan attributes (Enterprise, feature flags) in **Metadata** of payment platforms (Stripe) or DB plan definition tables.
    *   **Success**: This secures flexibility for marketers/executives to change sales strategies immediately without engineering help (no deployment).

### 6.2. The Strict Action Return Type Protocol
*   **Law**: Server Actions (or server-side functions) must have **strict type definitions** for all return values. Using `as any` casting on the UI side to convert return value types is permanently prohibited.
*   **Action**:
    1.  **Typed Response Contract**: All Server Actions must use a common return type (e.g., `ActionResponse<T> = { success: true, data: T } | { success: false, error: string, code?: string }`). Using `void` or `any` as return types is prohibited.
    2.  **No Client-Side Cast**: Using `result as any` or `result as MyType` on the UI (calling side) to force-fit return value types is prohibited. If types don't match, fix the Server Action's type definitions.
    3.  **Error Typing**: Express error cases through types. Rather than returning `unknown` from `catch` blocks, enumerate all expected error patterns as Union types.
    4.  **Serialization Boundary**: Server Action return values pass through React's serialization boundary. Do not include non-serializable values such as `Date`, `Map`, `Set`, or class instances.
*   **Rationale**: Concealing type mismatches on the UI side with `as any` causes UIsilently breaking with unexpected data when Server Action specs change. Strictly maintaining the type contract between Server Actions and UI is the cornerstone of full-stack type safety.

### 6.3. The Graceful Failure Contract
*   **Law**: Propagating errors from Server Actions (`'use server'` functions) to the client via `throw` is **prohibited in principle**. All errors must be returned as structured responses in the format `{ success: false, error: string, code?: string }`.
*   **Action**:
    1.  **No Throw Propagation**: When a Server Action `throw`s an error, React's Error Boundary fires, potentially destroying the entire page or a large UI segment. Express all business logic errors (validation failures, permission denials, data inconsistencies, etc.) through return values.
    2.  **Try-Catch Envelope**: The root function of every Server Action must wrap its entire body in `try-catch`, converting internal exceptions to `{ success: false, error: e.message }`. Ensure that even unexpected exceptions return appropriate user feedback.
    3.  **Typed Error Codes**: Include machine-readable `code` values in error responses (e.g., `VALIDATION_ERROR`, `PERMISSION_DENIED`, `NOT_FOUND`) to enable UI-side branching logic (toast display, redirect, retry, etc.) based on error type.
    4.  **Logging Before Return**: Always output server-side logs (`Logger.error`) before returning errors as return values. Error handling via return values risks losing observability if logging is neglected.
*   **Rationale**: `throw` in Server Actions interacts complexly with React's streaming rendering, causing unpredictable side effects such as unintended Error Boundary firing, form state resets, and re-rendering cascades. Structured return value error handling guarantees both UI stability and debugging ease.
