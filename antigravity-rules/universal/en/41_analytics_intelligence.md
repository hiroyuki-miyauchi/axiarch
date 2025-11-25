# 41. Analytics Intelligence & Observability

## 1. Behavioral Analytics - "Amplitude First"
*   **Event Taxonomy**:
    *   **Action-Based**: Record **User Intent** like "Clicked Purchase" or "Completed Tutorial", not just "Page Viewed".
    *   **Properties**: Always attach context (e.g., `source: "banner_A"`, `item_count: 3`) to events to increase analysis resolution.
*   **Cohort Analysis**:
    *   **Retention**: Compare next-week Retention Rate between "Users who used Feature A" and "Users who didn't" to identify the product's **Magic Number** (e.g., "Retain if they follow 7 people").

## 2. Experimentation & A/B Testing
*   **Culture of Experimentation**:
    *   **Rule**: Always wrap new major features with **Feature Flags** (LaunchDarkly / Firebase Remote Config) and release gradually.
    *   **Hypothesis Verification**: "Just releasing" is prohibited. Always define "Hypothesis", "Success Metric", and "Guardrail Metric" (e.g., Churn rate doesn't increase) before starting tests.
*   **Statistical Significance**:
    *   Use 95%+ Confidence Interval for result judgment to eliminate accidental variance.

## 3. Analytics & Intelligence
*   **North Star Metric (NSM)**:
    *   **Definition**: Define "The One Metric" that most accurately represents the product's long-term value (e.g., "Total Listening Time" for Spotify, "Nights Booked" for Airbnb).
    *   **Company-wide Sharing**: Everyone from engineers to CS works to improve this NSM.
*   **Funnel Analysis**:
    *   Visualize drop-off points from signup to billing and usage of key features to identify bottlenecks.

## 4. Automated Issue Extraction
*   **Crash Reporting**:
    *   **Crashlytics / Sentry**: Introduce to all environments.
    *   **Auto-Ticket**: Build a workflow where critical crashes affecting >1% of users are automatically ticketed to issue management tools (Jira/GitHub Issues) with "Highest Priority".
*   **UX Friction Detection**:
    *   **Rage Taps**: Detect users repeatedly tapping the same spot and record as UI defect (unresponsive button, confusing UI).
    *   **Dead Clicks**: Track clicks on non-interactive elements to identify misunderstood UI patterns.

## 5. Observability - The "Why"
*   **Distributed Tracing**:
    *   **OpenTelemetry**: Enable end-to-end tracing from frontend to backend and database. Instantly identify "Where it got slow".
*   **Performance Monitoring**:
    *   **Real-time**: Monitor TTI (Time to Interactive) and API latency in real-time and alert Slack etc. if thresholds are exceeded.
    *   **Core Web Vitals**: Continuously measure LCP, FID, CLS scores to prevent negative impact on SEO and UX.

## 6. Privacy-First Analytics
*   **No PII**:
    *   **Strictly Prohibited**: Sending PII (Personally Identifiable Information) like email, name, phone, device ID (IDFA/GAID) to analytics platforms is **strictly prohibited**.
    *   **Hashing**: If user identification is needed, use salted hash IDs.
*   **Consent Management**:
    *   **GDPR / APPI**: Strictly respect user's Cookie Consent Status (Do Not Track). If no consent, do not load analytics scripts.
