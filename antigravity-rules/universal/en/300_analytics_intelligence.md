# 300. Analytics Intelligence & Observability

## 1. Automated Issue Extraction
*   **Crash Reporting**:
    *   **Crashlytics / Sentry**: Introduce in all environments.
    *   **Auto-Ticket**: Build a workflow where critical crashes affecting more than 1% of users are automatically ticketed in the issue tracking tool (Jira/GitHub Issues) with "Highest Priority".
*   **UX Friction Detection**:
    *   **Rage Taps**: Detect actions where users repeatedly tap the same spot and record them as UI defects (unresponsive buttons, confusing UI).
    *   **Dead Clicks**: Track clicks on non-interactive elements to identify user-misunderstood UI patterns.

## 2. Observability (The "Why")
*   **Distributed Tracing**:
    *   **OpenTelemetry**: Enable end-to-end tracing of requests from frontend to backend and database. Immediately identify "where it got slow".
*   **Performance Monitoring**:
    *   **Real-time Monitoring**: Monitor TTI (Time to Interactive) and API latency in real-time, and notify alerts to Slack etc. if thresholds are exceeded.
    *   **Core Web Vitals**: Continuously measure LCP, FID, CLS scores to prevent negative impacts on SEO and UX.

## 3. Privacy-First Analytics
*   **No PII**:
    *   **Strictly Prohibited**: Sending Personally Identifiable Information (PII) such as email addresses, names, phone numbers, device IDs (IDFA/GAID) to analytics platforms is **strictly prohibited**.
    *   **Hashing**: If user identification is necessary, use salted hash IDs.
*   **Consent Management**:
    *   **GDPR / APPI**: Strictly respect user Cookie consent status (Do Not Track). If there is no consent, do not load the analytics script itself.

## 4. Business Intelligence
*   **North Star Metric Tracking**:
    *   Measure user actions directly linked to the business's most important metric (North Star Metric) (e.g., number of paid feature uses, content creation count), not just PV or download counts.
*   **Funnel Analysis**:
    *   Visualize drop-off points from signup to billing and use of main features to identify bottlenecks.
