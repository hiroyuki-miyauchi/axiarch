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
    *   **PII Masking**: Structurally prevent leakage of password hashes and internal flags (`is_admin`).

## 2. Reliability & Resilience
*   **Idempotency**:
    *   **Requirement**: Mandate implementation of `Idempotency-Key` header for all requests involving side effects (POST/PUT/PATCH) like payment, creation, update.
    *   **Behavior**: Even if retry occurs due to network error, requests with the same key are processed "only once" on the server side, reliably preventing duplicate execution (double billing, etc.).
*   **Error Handling**:
    *   **Unified Format**: Always return error responses in a unified JSON format (`{ code, message, details }`).
    *   **Jittered Retry**: Apply "Exponential Backoff + Jitter (random fluctuation)" for temporary errors instead of simple retries to avoid Thundering Herd problem.
    *   **Circuit Breaker**: If an external service is down, return error immediately to prevent the entire system from being dragged down.

## 3. Performance & Scalability
*   **Rate Limiting**:
    *   **Distributed Rate Limiting**: Implement accurate rate limiting (e.g., 100 req/min) even in distributed environments using **Token Bucket** algorithm with Redis.
    *   **Header Notification**: Notify clients of limit status with `X-RateLimit-Remaining` and `Retry-After` headers.
*   **Caching Strategy**:
    *   **ETag / Last-Modified**: Attach appropriate cache headers to maximize client-side caching (304 Not Modified).
    *   **Stale-While-Revalidate**: Adopt SWR pattern at CDN level to realize fast response while maintaining content freshness.

## 4. Security & Authentication
*   **Authorization Header**:
    *   Send API tokens always in `Authorization: Bearer <token>` header, not URL parameters.
    *   **Native Session Bypass**: For First Party Apps, do not embed API Keys; verify User Session (Cookie/Bearer) to automatically grant privileges (Tier 2).
*   **Least Privilege**:
    *   Grant only minimum necessary scopes (permissions) to API keys and tokens.

## 5. Documentation
*   **Live Documentation**:
    *   API documentation must be auto-generated from code and always be up-to-date (Live) (Swagger UI, GraphiQL). Manual documentation updates are prohibited.
## 6. API Economy & Monetization
*   **Commercialization Protocol**:
    *   **Internal as Public**: Assume all APIs will eventually be "products sold to other companies". "Building a paid version later" is not allowed; consider Public and Enterprise versions from the start.
    *   **Usage Metering**: Maintain an architecture capable of measuring traffic and call counts at the API Gateway layer to prepare for Stripe Metered Billing.
    *   **Tiered Access**: Control via DTOs to enable code-level branching between "Free Plans (Restricted)" and "Paid Plans (Unrestricted)".
    *   **Native App Exemption**: Treat access from our own Native App as "Tier 2 (Enterprise) equivalent" and exclude it from billing (Bundled).
*   **Data Monetization Privacy**:
    *   **Anonymization Interface**: APIs provided to external partners must return only statistical data processed via **k-anonymity** or **Differential Privacy**. Selling raw data is permanently prohibited.
    *   **Opt-Out**: Provide an ON/OFF switch for "Data Utilization Cooperation" in user settings and exclude OFF users from aggregation.
