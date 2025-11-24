# 230. Growth & Experimentation

## 1. A/B Testing Infrastructure
*   **Feature Flags**:
    *   **Decouple Deploy from Release**: Always wrap new features in Feature Flags (LaunchDarkly, Firebase Remote Config) to separate code deployment from user release.
    *   **Server-Side Control**: Control flags server-side to enable/disable features without waiting for app store review.
*   **Culture of Experimentation**:
    *   **Hypothesis-Driven**: Define a "Hypothesis" and "Success Metric" for every new feature before development. Building "just because" is prohibited.

## 2. Analytics Architecture
*   **Event Dictionary**:
    *   **Single Source of Truth**: Create a document (Event Dictionary) managing all event definitions (names, properties, triggers) and agree on it with PMs/Engineers before implementation.
    *   **Naming Convention**: Strictly adhere to the `Object + Action` format (e.g., `Button_Clicked`, `Screen_Viewed`) to prevent inconsistency.
*   **Idempotency**:
    *   Implement client-side debouncing and ID management to prevent duplicate event transmission.

## 3. Onboarding Optimization
*   **Magic Number**:
    *   Identify the number of actions required for user retention (e.g., "Add 3 friends within 7 days") and design the UI to encourage this behavior.
*   **Remove Friction**:
    *   Minimize input fields in the signup flow. Consider "Lazy Registration" (delaying email verification, etc.).
