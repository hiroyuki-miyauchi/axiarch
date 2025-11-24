# 31. Mobile Engineering (Flutter)

## 1. Architecture & State Management
*   **Riverpod & Hooks**:
    *   **Standard**: Adopt **Riverpod (Code Generation)** for state management and **Flutter Hooks** for UI logic as the standard.
    *   **Immutability**: All state must be immutable using `Freezed` to prevent unexpected side effects.
*   **Layered Architecture**:
    *   **Presentation**: UI and ViewModel (Notifier). No logic, just rendering.
    *   **Domain**: Business logic and entities. No dependency on Flutter.
    *   **Data**: API communication, DB operations, DTOs. Abstracted via Repository pattern.

## 2. Performance Optimization ("60fps or Die")
*   **Rendering**:
    *   **Rebuild Suppression**: Use `Consumer` and `select` appropriately to rebuild only necessary parts.
    *   **Const**: Use `const` constructors thoroughly to prevent widget regeneration.
*   **Startup Time**:
    *   Aim for app startup time within **2 seconds**. Initialize asynchronously in parallel and do not wait on the splash screen.
*   **Image Handling**:
    *   Use `cached_network_image` to cache images and reduce data usage.
    *   Resize huge images on the server side before fetching.

## 3. Platform Fidelity
*   **Native Feel**:
    *   Fully support "Swipe Back" on iOS and "Back Button" on Android.
    *   Scroll physics (Bouncing vs Clamping) must follow OS standards.
*   **Adaptive UI**:
    *   Use different UI components (Dialogs, Bottom Sheets, Switches) for each OS to eliminate awkwardness.

## 4. Quality Assurance
*   **Golden Tests**:
    *   Mandate snapshot testing using **Golden Toolkit** as UI regression testing.
    *   Automatically detect layout breaks on different device sizes (iPhone SE, Pro Max, Pixel).
*   **Maestro**:
    *   Use **Maestro** for E2E testing to automate real user operation flows.

## 5. Deployment & Distribution
*   **CI/CD**:
    *   Integrate GitHub Actions with Codemagic/Bitrise to automatically distribute to TestFlight/Google Play Internal Testing on merge to main.
    *   **Obfuscation**: Always enable Obfuscation and Tree Shaking for release builds.
*   **Integration Tests**: Test critical flows (Login, Payment) on real devices/emulators.
*   **Golden Tests**: Use Golden Tests to prevent UI regressions (pixel-perfect check).

## 6. Robust Connectivity
*   **Offline-First**:
    *   The app must not crash when the network is disconnected; display viewable data.
    *   Use the Repository Pattern to appropriately manage synchronization between local cache and remote data.
