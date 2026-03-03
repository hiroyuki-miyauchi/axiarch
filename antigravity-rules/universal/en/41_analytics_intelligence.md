# 41. Analytics Intelligence & Observability

## 1. Behavioral Analytics - "Amplitude First"
*   **Event Taxonomy**:
    *   **Action-Based**: Record **User Intent** like "Clicked Purchase" or "Completed Tutorial", not just "Page Viewed".
    *   **Naming Convention (Snake Case)**:
        *   **Law**: Unify all event names in **Snake Case** (`action_completed`). Spaces or Camel Case are prohibited. This is to maintain consistency with DB column names.
    *   **Properties**: Always attach context (e.g., `source: "banner_A"`, `item_count: 3`) to events to increase analysis resolution.
*   **Cohort Analysis**:
    *   **Retention**: Compare next-week Retention Rate between "Users who used Feature A" and "Users who didn't" to identify the product's **Magic Number** (e.g., "Retain if they follow 7 people").

## 2. Experimentation & A/B Testing
*   **Culture of Experimentation**:
    *   **Rule**: Always wrap new major features with **Feature Flags** (LaunchDarkly / Firebase Remote Config) and release gradually.
    *   **Hypothesis Verification**: "Just releasing" is prohibited. Always define "Hypothesis", "Success Metric", and "Guardrail Metric" (e.g., Churn rate doesn't increase) before starting tests.
*   **Statistical Significance**:
    *   Use 95%+ Confidence Interval for result judgment to eliminate accidental variance.
*   **The Experimentation Protocol**:
    *   **Context**: Decisions based on "data" rather than "intuition" determine product growth. All important UI/UX changes must be validated through experiments.
    *   **4-Phase Process**:

        | Phase | Content | Deliverable |
        |:------|:--------|:------------|
        | **1. Hypothesis** | Form hypothesis in the format: "If we change X, then Y will improve by Z%" | Experiment plan |
        | **2. Experiment** | Distribute traffic to A/B groups using Feature Flags | Implementation PR |
        | **3. Measurement** | Collect data for at least **2 weeks** or **1,000+ sessions per group** | Event data |
        | **4. Decision** | Adopt only when statistical significance (**p < 0.05**) is confirmed | Decision report |

    *   **Experiment Priority**:
        *   **Mandatory**: Registration flow, search UI, key conversion funnels
        *   **Recommended**: Landing pages, CTA copy, email subject lines
        *   **Unnecessary**: Security features, legal compliance UI
    *   **Prohibition**:
        *   Decision-making without statistical significance (avoiding HiPPO problem)
        *   Experiments that disadvantage users (dark patterns)

## 3. Analytics & Intelligence
*   **North Star Metric (NSM)**:
    *   **Definition**: Define "The One Metric" that most accurately represents the product's long-term value (e.g., "Total Listening Time" for Spotify, "Nights Booked" for Airbnb).
    *   **Company-wide Sharing**: Everyone from engineers to CS works to improve this NSM.
*   **Funnel Analysis**:
    *   Visualize drop-off points from signup to billing and usage of key features to identify bottlenecks.
*   **The AARRR KPI Framework**:
    *   **Context**: Define a hierarchical KPI framework based on AARRR (Pirate Metrics) to quantitatively track growth. With NSM at the apex, measure KPIs at each tier.
    *   **AARRR Hierarchy**:

        | Tier | KPI Example | Measurement |
        |:-----|:------------|:------------|
        | **Acquisition** | Monthly new registrations | Analytics `sign_up` event |
        | **Activation** | First action completion rate | Analytics `first_action` event |
        | **Retention** | 7-day / 30-day retention rate | Cohort analysis |
        | **Revenue** | ARPU (Average Revenue Per User) | Payments + ad revenue |
        | **Referral** | Referral-driven registration rate | Referral Code tracking |

    *   **GA4 Event Design Standard**:
        *   Standardize event names in `snake_case` (e.g., `store_detail_view`, `review_submit`).
        *   Attach `user_type` (e.g., `guest` / `member` / `admin`) as a custom dimension.
        *   E-commerce events must comply with the analytics platform's recommended schema.
    *   **Mandate**: Define target values for each tier in the project-specific Blueprint. This framework provides the KPI structure "template".

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

## 7. Analytics Dashboard Integrity Protocol

### 7.1. The Dashboard Data Integrity Standard
*   **Law**: Analytics dashboard quality metrics MUST be measured based on actual DB schema columns, preventing schema-reality divergence.
*   **Action**:
    1.  **Schema-Based Metrics**: Quality metric `IS NOT NULL` checks etc. MUST be based on actually existing columns. Column existence verification via DB type definition files is mandatory.
    2.  **DTO-UI Type Alignment**: When adding fields to DTOs, the UI-side destructuring MUST also be updated. `NaN` / `undefined` / `null` being displayed in the UI shall be treated as a bug.
    3.  **Distinct Denominator**: Apply `distinct` processing to funnel calculation denominators to prevent duplicate counting. A `total > 0` guard for division-by-zero protection is mandatory.
    4.  **Tooltip Mandate**: Attach tooltips to all metric items, composed of two elements: "What is being measured" + "Why it matters." Write in language understandable by operators without specialized knowledge.

