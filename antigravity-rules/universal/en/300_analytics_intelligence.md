# 300. Analytics Intelligence & Observability

## 1. Automated Issue Extraction
*   **Crash Reporting**:
    *   **Crashlytics / Sentry**: Deploy to all environments.
    *   **Auto-Ticketing**: Establish a workflow where critical crashes affecting >1% of users automatically create a "Highest Priority" ticket in the issue tracker (Jira/GitHub Issues).
*   **UX Friction Detection**:
    *   **Rage Taps**: Detect when users repeatedly tap the same area and record it as a UI defect (unresponsive button, confusing UI).
    *   **Dead Clicks**: Track clicks on non-interactive elements to identify UI patterns that users misunderstand.

## 2. Observability (The "Why")
*   **Distributed Tracing**:
    *   **OpenTelemetry**: Enable end-to-end tracing of requests from Frontend to Backend to Database. Instantly identify "where it got slow".
*   **Performance Monitoring**:
    *   **Real-time Monitoring**: Monitor TTI (Time to Interactive) and API latency in real-time, and alert via Slack etc. if thresholds are exceeded.

## 3. Privacy-First Analytics
*   **No PII**:
    *   **Strict Prohibition**: Sending PII (Email, Name, Phone, Device ID like IDFA/GAID) to analytics platforms is **strictly prohibited**.
    *   **Hashing**: If user identification is necessary, use salted hash IDs.
*   **Consent Management**:
    *   **GDPR / APPI**: Strictly respect user Cookie Consent status (Do Not Track). If consent is not given, do not load analytics scripts at all.
