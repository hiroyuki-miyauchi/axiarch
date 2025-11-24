# 31. Mobile Engineering (Flutter)

## 1. Architecture & State Management
*   **Riverpod & Hooks**:
    *   **Standardization**: Adopt **Riverpod (Code Generation)** for state management and **Flutter Hooks** for UI logic as standards.
    *   **Immutability**: Use `Freezed` for all State to ensure immutability and prevent unexpected side effects.
*   **Layered Architecture**:
    *   **Presentation**: UI and ViewModel (Notifier). No logic, purely for rendering.
    *   **Domain**: Business logic and entities. Eliminate dependencies on Flutter.
    *   **Data**: API communication, DB operations, DTOs. Abstracted with Repository Pattern.

## 2. Performance Optimization ("60fps or Die")
*   **Rendering**:
    *   **Suppress Rebuilds**: Use `Consumer` and `select` appropriately to rebuild only necessary parts.
    *   **Const**: Use `const` constructors thoroughly to prevent widget regeneration.
*   **Startup Time**:
    *   Aim for an app startup time of **within 2 seconds**. Execute initialization asynchronously in parallel and do not wait on the splash screen.
*   **Image Handling**:
    *   Use `cached_network_image` to cache images and reduce data usage.
    *   Resize huge images on the server side before fetching.

## 3. Platform Fidelity
*   **Native Feel**:
    *   Fully support "Swipe Back" on iOS and "Back Button" behavior on Android.
    *   Follow each OS standard for scroll physics (Bouncing vs Clamping).
*   **Adaptive UI**:
    *   Use different UI components for Dialogs, Bottom Sheets, Switches, etc., for each OS to eliminate awkwardness.

## 4. Quality Assurance
*   **Golden Tests**:
    *   Mandate snapshot tests using **Golden Toolkit** as UI regression tests.
    *   Automatically detect layout corruption on different device sizes (iPhone SE, Pro Max, Pixel).
*   **Maestro**:
    *   Use **Maestro** for E2E tests to automate actual user operation flows.

## 5. Deployment & Distribution
*   **CI/CD**:
    *   Integrate GitHub Actions with Codemagic/Bitrise to automatically distribute to TestFlight/Google Play Internal Testing triggered by merge to main branch.
    *   Always enable Obfuscation and Optimization (Tree Shaking) for release builds. Use `flutter build ipa --obfuscate --split-debug-info=/<path>`.
