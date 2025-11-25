# 35. API Integration & Design

## 1. API Design Principles
*   **API-First Design**:
    *   **Design First**: Define API specifications before starting implementation.
    *   **OpenAPI (Swagger)**: For REST APIs, write the OpenAPI 3.x spec first, then auto-generate code (type definitions, clients). This ensures efficiency and consistency.
    *   **Schema-Driven**: For GraphQL, treat the Schema definition as the source of truth to ensure type safety for both frontend and backend.
    *   **Mandatory Code Gen**: Handwritten type definitions are prohibited. Always auto-generate client code and server type definitions from OpenAPI/GraphQL schemas.
*   **RESTful & GraphQL**:
    *   **REST**: Adhere to resource-oriented URL design (e.g., `GET /users/{id}/orders`) and use appropriate HTTP methods (GET, POST, PUT, DELETE). Strictly observe statelessness.
    *   **GraphQL**: Adopt GraphQL for complex data fetching or when clients need to specify exact data requirements, preventing over-fetching.
*   **Versioning**:
    *   Manage versions via URL or Header (e.g., `/v1/users`) to avoid Breaking Changes and minimize impact on existing clients.

## 2. Error Handling & Resilience
*   **Unified Format**:
    *   Always return error responses in a unified JSON format (e.g., `{ "code": "INVALID_INPUT", "message": "Input is invalid." }`). This simplifies client-side error handling.
    *   Correctly use HTTP status codes (200 OK, 400 Bad Request, 401 Unauthorized, 403 Forbidden, 404 Not Found, 500 Internal Server Error). Do not return everything as 200 OK.
*   **Retry & Circuit Breaker**:
    *   **Retry with Jitter**: For temporary errors, apply "Exponential Backoff + Jitter (random fluctuation)" instead of simple retries to prevent Thundering Herd.
    *   **Circuit Breaker**: If an external service is down, return an error immediately to prevent the entire system from going down with it.

## 3. Security & Authentication
*   **Authorization Header**:
    *   Always send API tokens in the `Authorization: Bearer <token>` header, not as URL parameters.
*   **Rate Limiting**:
    *   Implement rate limiting (Throttling) by IP address or user to prevent DDoS attacks and scraping.

## 4. Best Practices
*   **Idempotency**:
    *   Always implement the `Idempotency-Key` header for payments and critical updates to prevent double execution due to network errors.

## 5. Documentation
*   **Live Documentation**:
    *   API documentation must be auto-generated from code and always kept up-to-date (Live) (Swagger UI, GraphiQL). Manual documentation is prohibited.
