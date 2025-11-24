# 230. Growth & Experimentation

## 1. A/B Testing Infrastructure
*   **Feature Flag**:
    *   **Decouple Deploy & Release**: Always wrap new features with Feature Flags (LaunchDarkly, Firebase Remote Config) to separate code deployment from user release.
    *   **Server-Side Control**: In principle, control flags on the server side to enable on/off of features without waiting for app review.
*   **Culture of Experimentation**:
    *   **Hypothesis Driven**: Develop all new features after defining a "Hypothesis" and "Success Metric". "Building just because" is prohibited.

## 2. Analytics Architecture
*   **Event Dictionary**:
    *   **Single Source of Truth**: Create a document (Event Dictionary) managing all event definitions (event names, properties, trigger conditions) and agree on it between PM and engineers before implementation.
    *   **Naming Convention**: Strictly adhere to the `Object + Action` format (e.g., `Button_Clicked`, `Screen_Viewed`) to prevent notation inconsistencies.
*   **Double Sending Prevention**:
    *   Thoroughly implement debounce processing and ID management on the client side to prevent duplicate transmission of the same event.

## 3. Onboarding Optimization
*   **Magic Number**:
    *   Find the number of actions required for user retention (e.g., "Add 3 friends within 7 days") and design the UI to encourage those actions.
*   **Friction Elimination**:
    *   Minimize input fields in the signup flow. Consider deferring email verification etc. (Lazy Registration).
