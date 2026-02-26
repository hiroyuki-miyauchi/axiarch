# 35. API Integration & Microservices

## 1. API Design Principles
*   **API-First Design**:
    *   **Omnichannel First**: Do not treat the Web Frontend as a "privileged client". Treat it equally with iOS/Android apps. All web operations must be available via API.
    *   **Tiered Gateway**: Implement "Tier 1 (Public/Read-Only)" and "Tier 2 (Enterprise/Auth/Paid)" separately from the start to prepare for future API monetization (Stripe Metering).
    *   **Design First**: Define API specifications before starting implementation.
    *   **OpenAPI (Swagger)**: For REST API, write OpenAPI 3.x specs first, then auto-generate code (type definitions, clients) from there.
    *   **Schema-Driven**: For GraphQL, the Schema definition is truth, ensuring type safety for frontend and backend.
    *   **Mandatory Code Gen**: Handwritten type definitions are prohibited. Always auto-generate client code and server type definitions from OpenAPI/GraphQL schema.
*   **Protocol Selection**:
    *   **REST**: Use for Public APIs or simple CRUD operations.
    *   **GraphQL**: Use for complex data fetching or as BFF (Backend for Frontend) for mobile apps (bandwidth saving).
    *   **gRPC**: Use fast and type-safe **gRPC (Protobuf)** for internal communication between microservices. Eliminate JSON overhead.
*   **Versioning**:
    *   Manage versions via URL or Header (e.g., `/v1/users`) to avoid Breaking Changes.
*   **Data Transport Standard**:
    *   **DTO Obligation**: Returning database Row Objects (Raw Row) directly is a "Felony". Always use `UserDTO` etc. to output only intentionally mapped fields.
    *   **Admin Data Leak Defense**: Even for admin screen APIs, prohibit `SELECT *` and always define dedicated **`AdminDTO`**. Physically prevent automatic leakage when confidential columns like `internal_memo` or cost info are added in future.
    *   **Verification (DTO Assertion)**: API test cases MUST include **`assert(field is undefined)`** tests to verify that "fields to be excluded (PII etc.) do not exist".
    *   **PII Masking**: Structurally prevent leakage of password hashes and internal flags (`is_admin`).

## 2. Reliability & Resilience
*   **Idempotency**:
    *   **Requirement**: Mandate implementation of `Idempotency-Key` header for all requests involving side effects (POST/PUT/PATCH) like payment, creation, update.
    *   **Behavior**: Even if retry occurs due to network error, requests with the same key are processed "only once" on the server side, reliably preventing duplicate execution (double billing, etc.).
*   **Error Handling**:
    *   **Jittered Retry**: Apply "Exponential Backoff + Jitter (random fluctuation)" for temporary errors instead of simple retries to avoid Thundering Herd problem.
    *   **Circuit Breaker**: If an external service is down, return error immediately to prevent the entire system from being dragged down.
*   **The Outbound Audit Mandate (External Visibility)**:
    *   **Law**: All "write" requests and "AI inference" requests to external services (Stripe, OpenAI, Supabase API, etc.) MUST be recorded in audit log table (`outbound_api_logs`).
    *   **Action**: Record request payload (hash PII), status code, and processing time to enable early detection of external service failures or rate limit warnings.

## 3. Semantic API & AI Readiness
*   **The RFC 7807+ Protocol (Semantic Error Consistency)**:
    *   **Uniform Error**: Error responses MUST conform to **RFC 7807 (Problem Details for HTTP APIs)** structure. Provide `type`, `title`, `status`, `detail`, `instance` instead of mere string messages, enabling clients (and AI agents) to accurately distinguish error context mechanically.
    *   **Consistency**: Unify Server Action return values also with this `ApiResponse` schema, eliminating boundaries between Web frontend and API Economy.
*   **The Backend Error Propagation Ban (Localization)**:
    *   **Law**: Physically prohibit displaying raw technical error messages returned from server (e.g., `"Row not found"`, `"upstream connect error"`) directly in toast notifications or UI.
    *   **Action**: Translate to localized messages on client side based on error type that users can understand and that present "next action to take".
    *   **Reason**: Raw errors are "technical negligence" that cause user anxiety and damage trust.
*   **The Metadata Mandate (AI & FinOps Strategy)**:
    *   **AI Context Meta**: Recommend including `meta` field in all success responses.
    *   **Details**: Include info like `tier` (public, enterprise), `usage` (metered, unlimited), `revalidation` (ttl) to support AI agent inference accuracy improvement and FinOps optimization.

### 3.2. The Transparent Gateway Instrumentation Protocol
*   **Law**: In Gateway / Service layer `catch` blocks, **directly embedding error objects in string templates for logging** is prohibited. Error `code`, `message`, `details` must be explicitly deconstructed and recorded.
*   **Action**:
    1.  **No Generic Messages**: `` `Gateway error: ${error}` `` outputs `[object Object]`, completely obscuring root causes such as RLS violations, insufficient permissions, and type mismatches.
    2.  **Property Deconstruction**: In `catch` blocks, output structured logs in the format `Logger.error('Gateway operation failed', { message: error?.message, code: error?.code, details: error?.details, hint: error?.hint })`.
    3.  **HTTP Status Mapping**: Appropriately map database error codes (e.g., `23505` = unique violation, `42501` = insufficient privileges) to HTTP status codes and return semantic error information to clients.
    4.  **Sensitive Data Guard**: When including request payloads in error logs, PII (personally identifiable information) and credentials must always be masked.
*   **Rationale**: The gateway layer is the "first line of defense" in application error diagnosis. When `[object Object]` is recorded here, it becomes impossible to isolate whether the cause is database, RLS, or authentication, exponentially increasing debugging time.

### 3.3. The Server Action Graceful Return Protocol
*   **Law**: When a Server Action (or server-side function called from the client) detects a business error, it must return a **common response type** (e.g., `{ success: false, error: '...', code: '...' }`) instead of `throw new Error()`.
*   **Action**:
    1.  **No Raw Throw**: `throw` in Server Actions causes client-side hooks (`useActionState` / `useTransition`, etc.) to process the error as an "unexpected exception," causing component cleanup or retry logic to run amok.
    2.  **Typed Response Contract**: Unify all Server Action return values with a common type like `ActionResponse<T> = { success: true, data: T } | { success: false, error: string, code?: string }`.
    3.  **Client Graceful Handling**: On the client side, branch with `if (!result.success)` and provide appropriate UI feedback such as toast notifications or form error displays. Error handling that relies on unhandled `throw` is prohibited.
    4.  **Observability**: In Server Action `catch` blocks, log the error, then convert it to a user-friendly message and include it in the response. Returning raw technical error messages to the client is prohibited.
*   **Rationale**: Error propagation via `throw` causes serialization issues and conflicts with React's lifecycle when crossing the client-server boundary (Next.js Server Actions, etc.). A common response type structurally avoids these problems and enables predictable error handling.

## 4. Performance & Scalability
*   **Rate Limiting**:
    *   **Distributed Rate Limiting**: Implement accurate rate limiting (e.g., 100 req/min) even in distributed environments using **Token Bucket** algorithm with Redis.
    *   **Header Notification**: Notify clients of limit status with `X-RateLimit-Remaining` and `Retry-After` headers.
*   **Caching Strategy**:
    *   **ETag / Last-Modified**: Attach appropriate cache headers to maximize client-side caching (304 Not Modified).
    *   **Stale-While-Revalidate**: Adopt SWR pattern at CDN level to realize fast response while maintaining content freshness.

## 5. Security & Authentication
*   **Authorization Header**:
    *   Send API tokens always in `Authorization: Bearer <token>` header, not URL parameters.
    *   **The Native Bypass Protocol (VIP Lane Strategy)**: Prohibit requiring API Key (`x-api-key`) for access from own apps. Implement **OR condition** of "API Key auth (Enterprise)" and "Bearer Token auth (Native/VIP)" in Middleware, unconditionally granting Enterprise-equivalent privileges to logged-in users from own app.
    *   **Session Verification**: For Bearer Token verification, MUST use `supabase.auth.getUser()` instead of mere signature verification. Mandate real-time confirmation of account Ban status and session expiration.
*   **Least Privilege**:
    *   Grant only minimum necessary scopes (permissions) to API keys and tokens.
    *   **API Key Security**: API Keys issued application-side (`sk_live_...`) MUST **NEVER be stored in DB as plaintext**. Always hash with **`SHA-256`** etc. for storage and compare hashed input during authentication.
*   **The Webhook Security Mandate (Signature Verification)**:
    *   **Law**: Prohibit starting processing without signature verification (`X-Hub-Signature` verification, etc.) when receiving Webhooks from external services (Stripe, Meta, GitHub, etc.).
    *   **Action**: MUST verify request authenticity using `Signing Secret` provided by platform to physically prevent unauthorized data updates via impersonation (e.g., changing to paid status when actually unpaid).
*   **The Stateless Gateway Protocol (Scale First)**:
    *   **Law**: Prohibit state retention dependent on sticky sessions or in-server memory at API Gateway and Middleware layers.
    *   **Action**: Consolidate all authentication/authorization to Bearer Token (JWT) or API Key, maintaining state ready for horizontal scaling at any time.

## 6. Advanced Write Protocols
*   **The Secure Write Action Protocol (Audit Result)**:
    *   **Law**: All actions involving payments, critical settings (finance/permissions), or core data changes are Subject to Tier 2 (Strict) Protection.
    *   **Mandate**: These Server Actions MUST accept `otp?: string` and `turnstileToken?: string` as arguments. Throw exception immediately if authentication fails at the start of processing.
    *   **Frontend**: The frontend MUST use `SecureActionModal` to mandate an explicit approval and re-authentication flow.
*   **The Hybrid Sync Prohibition (Data Integrity)**:
    *   **Context**: "Double Management" of holding the same data in both RDB columns and JSON (`config` etc.) is the main cause of future Split Brain inconsistencies.
    *   **Rule**: Double writing between old and new data structures is prohibited. When migrating, switch business logic and DB schema immediately and completely to the new structure, and physically delete the old structure (Rule 99.9).

## 7. Documentation
*   **Live Documentation**:
    *   API documentation must be auto-generated from code and always be up-to-date (Live) (Swagger UI, GraphiQL). Manual documentation updates are prohibited.

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

