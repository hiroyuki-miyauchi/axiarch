# 36. Native Platforms - Kotlin & Swift

## 1. Philosophy: "Native Excellence in a Cross-Platform World"
Even in a Flutter-first environment, deep understanding of native platforms is essential for high-performance integration, background processing, and access to latest OS features. We do not compromise on native quality.

## 2. Android (Kotlin) Standards
### 2.1. Modern Architecture
*   **Jetpack Libraries**: Utilize Android Jetpack libraries for robust and maintainable code.
*   **Coroutines & Flow**: Use Kotlin Coroutines for async processing. Avoid `AsyncTask` or raw Threads.
    *   **Rule**: Always use `Dispatchers.IO` for disk/network operations to not block the main thread.
*   **Dependency Injection**: Use **Hilt** (Recommended) or Koin for native module DI.

### 2.2. Code Style & Quality
*   **Kotlin Style Guide**: Strictly adhere to [Android Kotlin Style Guide](https://developer.android.com/kotlin/style-guide).
*   **Null Safety**: Utilize Kotlin's Null Safety. Avoid `!!` operator, use `?.` or `?:`.
*   **Linter**: Use **ktlint** to enforce style.

### 2.3. Performance
*   **R8/ProGuard**: Properly configure for code shrinking and obfuscation.
*   **Memory Leaks**: Use **LeakCanary** in debug builds to detect memory leaks, especially related to Context handling.

## 3. iOS (Swift) Standards
### 3.1. Modern Architecture
*   **SwiftUI & UIKit**: UI is handled by Flutter, but if native UI (widgets etc.) is needed, use **SwiftUI** where possible.
*   **Concurrency**: Use **Swift Concurrency (async/await)** for async tasks. Avoid "Callback Hell".
*   **ARC Management**: Watch out for Retain Cycles. Appropriately use `[weak self]` or `[unowned self]` in closures.

### 3.2. Code Style & Quality
*   **SwiftLint**: Mandate **SwiftLint** to enforce community standards.
*   **Protocol Oriented Programming**: Prioritize Protocols and Value Types (Structs) over Class inheritance.

### 3.3. Performance
*   **Instruments**: Profile native code performance using Xcode Instruments (Time Profiler, Allocations).
*   **Background Tasks**: Use `BGTaskScheduler` for modern background execution management.

## 4. Advanced Native Features
*   **Biometrics**:
    *   **FaceID / TouchID**: Always provide biometric authentication options for login and critical operations (payment etc.) to balance UX and security.
    *   **Fallback**: Always implement fallback like PIN code when biometrics are unavailable.
*   **Image Analysis & AI**:
    *   **ML Kit / Core ML**: Prioritize on-device image analysis (OCR, Object Detection) to reduce server load and privacy risks.
*   **Voice Recognition**:
    *   **Speech-to-Text**: Actively provide voice input options in search and input forms.
*   **UI Animation**:
    *   **Haptics**: Provide appropriate Haptic Feedback for success, failure, slider operations.
    *   **120Hz**: Optimize scroll and slider animations to be smooth on ProMotion displays (120Hz).

## 5. Offline First & Data Efficiency
*   **Offline First**:
    *   **Local DB**: Make Room (Android) / Realm / SwiftData (iOS) the "Single Source of Truth" and design app to work even without network connection.
    *   **Background Sync**: Use WorkManager (Android) / BackgroundTasks (iOS) to auto-sync data when network returns.
*   **Security Exception - Level 1 Priority**:
    *   **Priority**: "Security > Offline Convenience".
    *   **Confidential Info**: Storing PII (Personally Identifiable Information) or payment info locally without encryption (Android Keystore / iOS Keychain) is prohibited.
    *   **Risk Judgment**: If there is a risk of information leakage upon device loss, **disable** offline support for that feature. Choose safety over convenience.
*   **Data Efficiency**:
    *   **Caching**: Actively cache images and API responses to reduce wasteful traffic.
    *   **Wi-Fi Only**: Restrict download of large data (high-res assets, updates) to Wi-Fi connection by default.

## 6. Flutter Integration (Platform Channels)
### 6.1. Type Safety (Pigeon)
*   **Mandatory Pigeon**: Use **[Pigeon](https://pub.dev/packages/pigeon)** for all Platform Channels.
    *   **Why**: To prevent runtime crashes due to type mismatch and reduce boilerplate code.
    *   **No Raw MethodChannel**: Avoid manual `MethodChannel` calls for complex data structures.

### 6.2. Threading
*   **Main Thread Safety**: Native handlers are called on the main thread. Immediately offload heavy processing to background threads (Coroutines/Dispatch Queues).
    *   **Android**: `CoroutineScope(Dispatchers.IO).launch { ... }`
    *   **iOS**: `Task.detached { ... }`

### 6.3. Error Handling
*   **Standardized Errors**: Map native exceptions to standard Flutter error codes. Do not return generic "Error" strings.

## 7. Release & Testing
*   **Beta Testing**:
    *   Utilize **TestFlight (iOS)** / **Google Play Console (Internal Testing)** and always conduct beta testing on real devices before production release.
*   **Guideline Compliance**:
    *   Read **Apple App Store Review Guidelines** and **Google Play Developer Policy** thoroughly to eliminate rejection risks (e.g., inappropriate permission requests, billing violations) in advance.
    *   **Latest Info**: Always check latest guideline changes (e.g., Privacy Manifest mandate) at start of development.

## 8. Native Accessibility
*   **Screen Reader Support**:
    *   **Mandate**: Real device verification with iOS VoiceOver / Android TalkBack is mandatory before releasing new features.
    *   **Focus Order**: Confirm navigation order is logical (top-left to bottom-right).
*   **Inclusive Design**:
    *   **Dynamic Type**: Font size follows user settings (max 200%) without breaking layout.
    *   **Touch Targets**: All interactive elements ensure minimum **44x44dp (iOS) / 48x48dp (Android)**.

## 9. Web-Native Integration (Bridge & PWA)
*   **Mobile Bridge Protocol**:
    *   **JS Interface**: Standardize `window.AppBridge` to invoke native features (Haptics, Push Token) from WebView.
    *   **User Agent**: Identify app access via UA (`NativeApp/1.0`) and hide web headers/footers (Prevent double navigation).
*   **App Links & PWA**:
    *   **Deep Links**: Configure `/.well-known/apple-app-site-association` for direct app opening.
    *   **PWA**: Provide `manifest.json` to ensure standalone experience for mobile web users.

## 10. Security & API Protocols
*   **The Native Bypass Protocol (No Secrets in Binary)**:
    *   **Law**: Native apps (IPA/APK) can be decompiled. Bundling API Keys (`x-api-key`) is a security risk.
    *   **Action**: For authenticated requests, attach ONLY `Authorization: Bearer <token>` and do NOT use API Keys. The backend provides VIP Lane (Tier 2 Access) via this token.
