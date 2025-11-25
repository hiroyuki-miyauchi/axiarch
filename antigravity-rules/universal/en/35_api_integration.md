# 35. API Integration & Microservices

## 1. API Design Principles
*   **API-First Design**:
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
*   **Least Privilege**:
    *   Grant only minimum necessary scopes (permissions) to API keys and tokens.

## 5. Documentation
*   **Live Documentation**:
    *   API documentation must be auto-generated from code and always be up-to-date (Live) (Swagger UI, GraphiQL). Manual documentation updates are prohibited.
