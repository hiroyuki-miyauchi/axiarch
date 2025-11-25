# 31. Mobile Engineering - Flutter

## 1. Architecture & State Management
*   **Riverpod & Hooks**:
    *   **Standardization**: Adopt **Riverpod (Code Generation)** for state management and **Flutter Hooks** for UI logic as standard.
    *   **Immutability**: All State must be immutable using `Freezed` to prevent unexpected side effects.
*   **Layered Architecture**:
    *   **Presentation**: UI and ViewModel (Notifier). No logic, purely rendering.
    *   **Domain**: Business logic and entities. Eliminate dependency on Flutter.
    *   **Data**: API communication, DB operations, DTOs. Abstracted with Repository pattern.

## 2. Performance Optimization - "60fps or Die"
*   **Rendering**:
    *   **Rebuild Suppression**: Use `Consumer` and `select` appropriately to rebuild only necessary parts.
    *   **Const**: Use `const` constructors thoroughly to prevent widget regeneration.
*   **Startup Time**:
    *   Aim for app startup time within **2 seconds**. Run initialization asynchronously in parallel and do not wait on the splash screen.
*   **Image Handling**:
    *   Use `cached_network_image` to cache images and reduce data usage.
    *   Resize huge images on the server side before retrieval.

## 3. Platform Fidelity & Integration
*   **Native Feel**:
    *   Fully support "Swipe Back" on iOS and "Back Button" behavior on Android.
    *   Scroll physics (Bouncing vs Clamping) follow each OS standard.
*   **Adaptive UI**:
    *   Use different UI components for Dialogs, Bottom Sheets, Switches, etc., for each OS to eliminate awkwardness.
*   **Deep Linking**:
    *   **Universal Links / App Links**: Mandate implementation of deep links on both iOS/Android to seamlessly connect Web and App.
    *   **Experience**: When a user taps a Web URL, if the app is installed, immediately open the corresponding page in the app.

## 4. User Guidance & Onboarding
*   **Coach Marks Implementation**:
    *   **Library**: Use `tutorial_coach_mark` package (or equivalent high-quality library) to minimize implementation effort. Avoid custom complex overlay implementation.
    *   **OverlayPortal**: If custom overlays are needed, use Flutter 3.10+ `OverlayPortal` to maintain performance and avoid widget tree constraints.
    *   **State Management**: Manage "Show only once" state in both local storage (SharedPreferences/Isar) and remote DB so users are not bothered even after re-installation.

## 4. Quality Assurance
*   **Golden Tests**:
    *   Mandate snapshot testing using **Golden Toolkit** as UI regression testing.
    *   Automatically detect layout breakage on different device sizes (iPhone SE, Pro Max, Pixel).
*   **Maestro**:
    *   Use **Maestro** for E2E testing to automate actual user operation flows.

## 5. Deployment & Distribution
*   **CI/CD**:
    *   Link GitHub Actions with Codemagic/Bitrise to automatically distribute to TestFlight/Google Play Internal Testing triggered by merge to main branch.
    *   For release builds, always enable Obfuscation and Optimization (Tree Shaking). Use `flutter build ipa --obfuscate --split-debug-info=/<path>`.
