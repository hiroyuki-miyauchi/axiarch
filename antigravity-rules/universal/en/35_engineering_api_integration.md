# 35. API Integration & Design

## 1. API Design Principles
*   **API-First Design**:
    *   **Design Before Code**: Define API specifications before implementation.
    *   **OpenAPI (Swagger)**: For REST APIs, write OpenAPI 3.x specs first and auto-generate code (types, clients) to ensure consistency.
    *   **Schema-Driven**: For GraphQL, treat the Schema definition as the source of truth.
*   **RESTful & GraphQL**:
    *   **REST**: Adhere to resource-oriented URL design (e.g., `GET /users/{id}/orders`) and proper HTTP methods. Statelessness is mandatory.
    *   **GraphQL**: Adopt GraphQL for complex data fetching to prevent over-fetching.
*   **Versioning**:
    *   Manage versions via URL (`/v1/`) or Header to avoid Breaking Changes.

## 2. Error Handling
*   **Unified Format**:
    *   Always return error responses in a unified JSON format (e.g., `{ "code": "INVALID_INPUT", "message": "..." }`).
    *   Use HTTP status codes correctly (200, 400, 401, 403, 404, 500). Do NOT return 200 for everything.
*   **Retry Strategy**:
    *   Implement **Exponential Backoff** on the client side to automatically retry transient network errors (503, Timeout).

## 3. Security & Authentication
*   **Authorization Header**:
    *   Always send API tokens via `Authorization: Bearer <token>` header, never in URL parameters.
*   **Rate Limiting**:
    *   Implement Rate Limiting (Throttling) by IP or User to prevent DDoS and scraping.

## 4. Best Practices
*   **Idempotency**:
    *   Implement `Idempotency-Key` header for payments and critical updates to prevent double execution on network errors.
*   **Live Documentation**:
    *   API docs must be auto-generated from code and always "Live" (Swagger UI). Manual docs are prohibited. Manually updated documentation is prohibited.
