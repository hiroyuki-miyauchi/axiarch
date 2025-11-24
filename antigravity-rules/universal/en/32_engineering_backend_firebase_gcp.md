# 32. Backend Engineering (Firebase & GCP)

## 1. Serverless Architecture
*   **Cloud Functions (2nd Gen)**:
    *   **Standard**: Use **Cloud Functions (2nd Gen)** as the default to enhance concurrency and cold start mitigation.
    *   **Single Responsibility**: One function, one task. Monolithic functions are prohibited.
*   **Event-Driven**:
    *   **Async Processing**: Use **Cloud Pub/Sub** or **Eventarc** for heavy tasks (email, image processing, aggregation) to minimize user wait time.

## 2. Database Design (Firestore)
*   **NoSQL Modeling**:
    *   **Read Optimization**: Prioritize Read performance over Write. Do not be afraid of **Denormalization**.
    *   **Subcollections**: Store user-specific data (e.g., order history) in subcollections, not top-level, for query efficiency and security.
*   **Security Rules**:
    *   **Test Driven**: Always write unit tests for Firestore Security Rules to prevent unintended data leaks.
    *   **Least Privilege**: Default to `allow read, write: if false;` and explicitly allow only necessary paths.

## 3. Scalability & Reliability
*   **Idempotency**:
    *   **Rule**: Design all background processes to be **Idempotent** (result doesn't change even if executed multiple times).
    *   **Implementation**: Record processed IDs to prevent duplicate execution.
*   **Dead Letter Queue**:
    *   Do not discard failed messages; send them to a **Dead Letter Queue (DLQ)** for later investigation and reprocessing.

## 4. Monitoring & Logging
*   **Structured Logging**:
    *   Output logs in JSON format, not plain text, to make them queryable in Cloud Logging (e.g., search by `jsonPayload.userId`).
*   **Alerting**:
    *   Instantly notify Slack if error rate exceeds **1%** or function execution time exceeds the threshold.
