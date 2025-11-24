# 36. Engineering: Native Platforms (Kotlin & Swift)

## 1. Philosophy: "Native Excellence in a Cross-Platform World"
Even in a Flutter-first environment, a deep understanding of native platforms is essential for high-performance integration, background processing, and access to the latest OS features. We do not compromise on native quality.

## 2. Android (Kotlin) Standards

### 2.1. Modern Architecture
*   **Jetpack Libraries**: Leverage Android Jetpack libraries for robust and maintainable code.
*   **Coroutines & Flow**: Use Kotlin Coroutines for asynchronous processing. Avoid `AsyncTask` or raw Threads.
    *   **Rule**: Always use `Dispatchers.IO` for disk/network operations to avoid blocking the main thread.
*   **Dependency Injection**: Use **Hilt** (recommended) or Koin for native module DI.

### 2.2. Code Style & Quality
*   **Kotlin Style Guide**: Strictly adhere to the [Android Kotlin Style Guide](https://developer.android.com/kotlin/style-guide).
*   **Null Safety**: Leverage Kotlin's Null Safety features. Avoid the `!!` operator; use `?.` or `?:`.
*   **Linter**: Use **ktlint** to enforce style.

### 2.3. Performance
*   **R8/ProGuard**: Properly configure settings for code shrinking and obfuscation.
*   **Memory Leaks**: Use **LeakCanary** in debug builds to detect memory leaks, especially those related to Context handling.

## 3. iOS (Swift) Standards

### 3.1. Modern Architecture
*   **SwiftUI & UIKit**: While Flutter handles UI, use **SwiftUI** wherever possible when native UI (widgets, etc.) is required.
*   **Concurrency**: Use **Swift Concurrency (async/await)** for asynchronous tasks. Avoid "Callback Hell".
*   **ARC Management**: Be mindful of Retain Cycles. Appropriately use `[weak self]` or `[unowned self]` within closures.

### 3.2. Code Style & Quality
*   **SwiftLint**: Mandate **SwiftLint** to enforce community standards.
*   **Protocol Oriented Programming**: Prioritize Protocols and Value Types (Structs) over Class inheritance.

### 3.3. Performance
*   **Instruments**: Use Xcode Instruments (Time Profiler, Allocations) to profile native code performance.
*   **Background Tasks**: Use `BGTaskScheduler` for modern background execution management.

## 4. Advanced Native Features
*   **Biometrics**: Actively utilize FaceID / TouchID / Fingerprint to eliminate the hassle of password entry.
*   **Haptics**: Provide appropriate Haptic Feedback for success, failure, and important interactions to improve usability.

## 5. Offline First & Data Efficiency
*   **Offline First**:
    *   **Local DB**: Use Room (Android) / Realm / SwiftData (iOS) as the "Single Source of Truth" and design the app to work even without network connection.
    *   **Background Sync**: Use WorkManager (Android) / BackgroundTasks (iOS) to automatically sync data when the network returns.
    *   **Security Exception**:
        *   **Priority**: "Security > Offline Convenience".
        *   **Confidential Info**: Storing PII (Personally Identifiable Information) or payment info locally without encryption (Android Keystore / iOS Keychain) is prohibited. If there is a risk of data leakage, offline support for that feature is disabled.
*   **Data Efficiency**:
    *   **Cache**: Actively cache images and API responses to reduce unnecessary traffic.
    *   **Wi-Fi Only**: Restrict downloading large data (high-res assets, updates) to Wi-Fi connections by default. Thoroughly prioritize the user.

## 6. Flutter Integration (Platform Channels)
### 6.1. Type Safety (Pigeon)
*   **Mandatory Pigeon**: Use **[Pigeon](https://pub.dev/packages/pigeon)** for all Platform Channels.
    *   **Why**: To prevent runtime crashes due to type mismatches and reduce boilerplate code.
    *   **No Raw MethodChannel**: Avoid manual `MethodChannel` calls for complex data structures.

### 6.2. Threading
*   **Main Thread Safety**: Native handlers are called on the main thread. Immediately offload heavy processing to background threads (Coroutines/Dispatch Queues).
    *   **Android**: `CoroutineScope(Dispatchers.IO).launch { ... }`
    *   **iOS**: `Task.detached { ... }`

### 6.3. Error Handling
*   **Standardized Errors**: Map native exceptions to standard Flutter error codes. Do not return generic "Error" strings.

## 7. Release & Testing
*   **Beta Testing**:
    *   Utilize **TestFlight (iOS)** / **Google Play Console (Internal Testing)** to conduct beta testing on real devices before production release.
*   **Guideline Compliance**:
    *   Thoroughly read **Apple App Store Review Guidelines** and **Google Play Developer Policy** to eliminate rejection risks (e.g., inappropriate permission requests, billing policy violations) in advance.
