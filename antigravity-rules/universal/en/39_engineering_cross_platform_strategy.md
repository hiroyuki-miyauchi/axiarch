# 39. Cross-Platform Strategy

## 1. Tech Selection Criteria
*   **Web (Next.js)**:
    *   **Use Case**: When SEO is critical, or for instant access without installation (LP, Media, SaaS Dashboard).
    *   **Rule**: Web is the default choice for content consumption or desktop-heavy workflows.
*   **Flutter**:
    *   **Use Case**: For mobile apps requiring high-fidelity UI, offline capability, and push notifications.
    *   **Rule**: The standard technology for new apps requiring both iOS and Android support.
*   **Native (Swift/Kotlin)**:
    *   **Use Case**: When deep integration with latest OS features (ARKit, HealthKit, Home Screen Widgets) is essential.
    *   **Rule**: Use Native only for features impossible in Flutter (e.g., Widgets), bridging via Method Channels.

## 2. Integration
*   **Deep Linking**:
    *   **Mandatory**: Must implement **Universal Links (iOS)** and **App Links (Android)** to seamlessly bridge Web and App.
    *   **Experience**: Tapping a web URL should instantly open the specific page in the app if installed.
*   **WebView Bridge**:
    *   **Security**: When displaying web content in-app, establish a secure communication protocol (JavaScript Bridge) to prevent unauthorized script execution.

## 3. PWA (Progressive Web App)
*   **Installable Web**:
    *   Consider PWA as a lightweight alternative to Native Apps for "Installable" experiences without development overhead.
    *   **Offline**: Design for offline capability using Service Workers.
