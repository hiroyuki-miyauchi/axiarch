# 35. Engineering: API Integration Strategy

## 1. API-First Design
*   **Design Before Code**:
    *   Must define API specifications before starting implementation.
    *   **OpenAPI (Swagger)**: For REST APIs, write OpenAPI 3.x specs first, then auto-generate code (type definitions, clients) from them.
    *   **Schema-Driven**: For GraphQL, treat the Schema definition as the source of truth to ensure type safety across frontend and backend.

## 2. Protocols & Standards
*   **REST**: Suitable for resource-oriented CRUD operations. Strictly adhere to statelessness.
*   **GraphQL**: Adopt for complex data structures or when the frontend requires flexible data fetching.
*   **gRPC**: Adopt for inter-microservice communication or real-time communication requiring low latency (Protocol Buffers).

## 3. Best Practices
*   **Idempotency**:
    *   Must implement `Idempotency-Key` headers for payments and critical updates to prevent double execution due to network errors.
*   **Versioning**:
    *   When making breaking changes, must implement versioning via URL (`/v1/`, `/v2/`) or headers.
*   **Rate Limiting**:
    *   Set rate limits on all public APIs to prevent DDoS attacks and overload.

## 4. Documentation
*   **Live Documentation**:
    *   API documentation must be auto-generated from code and always be "Live" (Swagger UI, GraphiQL). Manually updated documentation is prohibited.
