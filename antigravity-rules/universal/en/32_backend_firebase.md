# 32. Backend Engineering - Firebase & GCP

## 1. Serverless Architecture
*   **Cloud Functions (2nd Gen)**:
    *   **Standardization**: Use **Cloud Functions (2nd Gen)** in principle to enhance Concurrency and Cold Start mitigation.
    *   **Cold Start Mitigation**:
        *   **Min Instances**: Always set `minInstances: 1` or more for latency-sensitive critical functions like login and payment to guarantee responsiveness.
*   **Event-Driven**:
    *   **Async Processing**: Use **Cloud Pub/Sub** or **Eventarc** to execute heavy processing (email sending, image processing, aggregation) asynchronously to minimize user wait time.

## 2. Database Design - Firestore
*   **NoSQL Modeling**:
    *   **Read Optimization**: Design prioritizing Read performance over Write. Denormalize necessary data beforehand.
    *   **Subcollections**: Place user-specific data (order history, etc.) as subcollections, not at the top level, to facilitate query efficiency and security management.
*   **Security Rules**:
    *   **Test Driven**: Always write unit tests for Firestore Security Rules to prevent unintended access permission leaks.
    *   **Least Privilege**: Default to `allow read, write: if false;` and explicitly allow only necessary paths.

## 3. FinOps & Cost Management
*   **Cost Allocation**:
    *   **Tagging**: Apply `Environment` (prod/dev), `Service` (api/worker), `Owner` tags to all GCP resources to clarify cost sources.
*   **Budget Alerts**:
    *   **Anomaly Detection**: In addition to alerts at 50%, 80%, 100% of budget, configure immediate Slack notifications for sudden cost spikes compared to the previous day. Prevent "Cloud Bankruptcy" due to infinite loops or attacks.

## 4. Analytics & Export
*   **BigQuery Integration**:
    *   **Raw Data**: Sync Firestore data to BigQuery in real-time using **BigQuery Extension** and perform complex analysis on the BigQuery side. Running aggregation queries on the app side is prohibited.
*   **Export Processing**:
    *   **Batch Processing**: Execute CSV/PDF export using **Stream Processing** or **Cloud Run Jobs**, considering Cloud Functions memory limits.

## 5. Monitoring & Logging
*   **Structured Logging**:
    *   Output logs in JSON format, not plain text, to make them queryable in Cloud Logging (e.g., searchable by `jsonPayload.userId`).
*   **IaC (Infrastructure as Code)**:
    *   Manage Firebase settings and GCP resources with code using Terraform or Firebase CLI. Eliminate operation errors due to manual operation (ClickOps).

## 6. Google Ecosystem Strategy
*   **Google First**:
    *   Prioritize **Google Ecosystem** (Firebase, GCP, Maps, AI) for technology selection. Adopt third-party products only when there is an overwhelming advantage.
*   **Google Maps Platform**:
    *   **Cost Optimization**: Use **Static Maps** for non-interactive views and Session Tokens for Places Autocomplete.
    *   **Performance**: Use Vector Maps SDK to optimize rendering.

## 7. Data Infrastructure - "Data Mesh"
*   **Single Source of Truth**:
    *   Aggregate all analysis data in **BigQuery**. Spreadsheet management is prohibited.
    *   **ELT**: Load data without processing, then transform/test using **dbt** within BigQuery.
*   **Data Quality**:
    *   Incorporate automated tests to detect data defects or outliers in the pipeline.
