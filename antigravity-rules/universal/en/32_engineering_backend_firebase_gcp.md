# 32. Backend Engineering (Firebase & GCP)

## 1. Serverless Architecture
*   **Cloud Functions (2nd Gen)**:
    *   **Standardization**: Use **Cloud Functions (2nd Gen)** in principle to enhance concurrency and cold start countermeasures.
    *   **Single Responsibility**: One function executes only one task. Monolithic Functions are prohibited.
*   **Event-Driven**:
    *   **Async Processing**: To minimize user wait time, execute heavy tasks (email sending, image processing, aggregation) asynchronously using **Cloud Pub/Sub** or **Eventarc**.

## 2. Database Design (Firestore)
*   **NoSQL Modeling**:
    *   **Read Optimization**: Design prioritizing Read performance over Write. Denormalize necessary data beforehand.
    *   **Subcollections**: Place user-related data (e.g., order history) as subcollections rather than top-level to streamline queries and security management.
*   **Security Rules**:
    *   **Test-Driven**: Always write unit tests for Firestore Security Rules to prevent unintended access privilege leaks.
    *   **Least Privilege**: Default to `allow read, write: if false;` and explicitly allow only necessary paths.

## 3. Analytics & Export
*   **BigQuery Integration**:
    *   **Raw Data**: Sync Firestore data in real-time using **BigQuery Extension** and perform complex analysis on the BigQuery side. Running aggregation queries on the app side is prohibited (for cost and performance).
*   **Export Processing**:
    *   **Batch Processing**: Execute CSV or PDF export via **Stream processing** or **Cloud Run Jobs**, considering Cloud Functions memory limits.
    *   **Signed URL**: Do not download generated files directly; issue a **Signed URL** with an expiration date.

## 4. Scalability & Reliability
*   **Idempotency**:
    *   **Rule**: Design all background processes to be "Idempotent", meaning the result does not change no matter how many times they are executed.
    *   **Implementation**: Record processed IDs to prevent duplicate execution.
*   **Dead Letter Queue**:
    *   Do not discard failed messages; send them to a Dead Letter Queue (DLQ) for later investigation and reprocessing.

## 5. Monitoring & Logging
*   **Structured Logging**:
    *   Output logs in JSON format, not just text, to enable querying in Cloud Logging (e.g., searchable by `jsonPayload.userId`).
*   **Alerting**:
    *   Notify Slack immediately if the error rate exceeds **1%** or if function execution time exceeds the threshold.
*   **IaC (Infrastructure as Code)**:
    *   Manage Firebase settings and GCP resources with code using Terraform or Firebase CLI. Eliminate operation errors due to manual operation (ClickOps).
