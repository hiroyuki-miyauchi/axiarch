# 36. Engineering: Native Platforms (Kotlin & Swift)

## 1. Philosophy: "Native Excellence in a Cross-Platform World"
Even in a Flutter-first environment, deep understanding of native platforms is required for high-performance integrations, background processing, and accessing latest OS features. We do not compromise on native quality.

## 2. Android (Kotlin) Standards

### 2.1. Modern Architecture
*   **Jetpack Libraries**: Utilize Android Jetpack libraries for robust, maintainable code.
*   **Coroutines & Flow**: Use Kotlin Coroutines for asynchronous programming. Avoid `AsyncTask` or raw threads.
    *   **Rule**: Always use `Dispatchers.IO` for disk/network operations to avoid blocking the Main Thread.
*   **Dependency Injection**: Use **Hilt** (recommended) or Koin for native module dependency injection.

### 2.2. Code Style & Quality
*   **Kotlin Style Guide**: Adhere strictly to the [Android Kotlin Style Guide](https://developer.android.com/kotlin/style-guide).
*   **Null Safety**: Leverage Kotlin's null safety features. Avoid `!!` operators; use `?.` or `?:`.
*   **Linter**: Use **ktlint** to enforce style.

### 2.3. Performance
*   **R8/ProGuard**: Ensure proper configuration for code shrinking and obfuscation.
*   **Memory Leaks**: Use **LeakCanary** in debug builds to detect memory leaks, especially with Context handling.

## 3. iOS (Swift) Standards
*   **SwiftUI & UIKit**: Use SwiftUI where possible for native widgets.
*   **Concurrency**: Use **Swift Concurrency (async/await)**. Avoid callback hell.

## 4. Advanced Native Features
*   **Biometrics**:
    *   **Mandatory**: Must implement **FaceID / TouchID** (iOS) and **BiometricPrompt** (Android) for payments and sensitive data access.
*   **Haptics**:
    *   **Feedback**: Use platform-standard haptic feedback (`UIImpactFeedbackGenerator`, etc.) for success, failure, and warning actions.

## 5. Common Platform Requirements
*   **Permissions**:
    *   **Just-in-Time**: Request permissions (Camera, Location) only when absolutely needed.
    *   **Explanation**: Always show a pre-dialog explaining "Why" before the system dialog.
*   **Accessibility**:
    *   **VoiceOver / TalkBack**: Ensure all UI elements have proper labels (Content Description) for screen readers.

## 4. Flutter Integration (Platform Channels)

### 4.1. Type Safety (Pigeon)
*   **Mandatory Pigeon**: Use **[Pigeon](https://pub.dev/packages/pigeon)** for all Platform Channels.
    *   **Why**: Prevents runtime crashes due to type mismatches and reduces boilerplate code.
    *   **No Raw MethodChannel**: Avoid manual `MethodChannel` calls for complex data structures.

### 4.2. Threading
*   **Main Thread Safety**: Native handlers are called on the Main Thread. Offload heavy work to background threads (Coroutines/Dispatch Queues) immediately.
    *   **Android**: `CoroutineScope(Dispatchers.IO).launch { ... }`
    *   **iOS**: `Task.detached { ... }`

### 4.3. Error Handling
*   **Standardized Errors**: Map native exceptions to standard Flutter error codes. Do not return generic "Error" strings.
