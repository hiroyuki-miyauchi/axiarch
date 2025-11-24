# 39. Cross-Platform Strategy

## 1. Tech Selection Criteria
*   **Web (Next.js)**:
    *   **Application**: When SEO is mandatory, or immediate use without installation is desired (LP, Media, SaaS Dashboard).
    *   **Principle**: Web is the first choice if content viewing or PC work is the main focus.
*   **Flutter**:
    *   **Application**: Mobile apps requiring advanced UI/UX, offline capabilities, and push notifications.
    *   **Principle**: The standard technology for new app development requiring both iOS/Android support.
*   **Native (Swift/Kotlin)**:
    *   **Application**: When deep integration with latest OS features (ARKit, HealthKit, Home Screen Widgets) is essential.
    *   **Principle**: Implement only features impossible with Flutter (Widgets, etc.) in Native and link via Method Channel.

## 2. Integration
*   **Deep Linking**:
    *   **Mandatory**: Mandate implementation of **Universal Links (iOS)** and **App Links (Android)** to seamlessly connect Web and App.
    *   **Experience**: When a user taps a Web URL, if the app is installed, it immediately opens the corresponding page within the app.
*   **WebView Bridge**:
    *   **Security**: When displaying Web content within the app, establish a secure communication protocol (JavaScript Bridge) and prevent malicious script execution.

## 3. PWA (Progressive Web App)
*   **Installable Web**:
    *   Consider PWA as a lightweight alternative to realize "Add to Home Screen" and Push Notifications (Web Push) without incurring native app development costs.
    *   **Offline Support**: Design main features to work offline using Service Workers.
