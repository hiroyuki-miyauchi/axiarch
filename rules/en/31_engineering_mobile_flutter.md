# 31. Mobile & Native App Standards (Flutter Edition)

## 1. Architecture & State Management
*   **Clean Architecture**:
    *   Clearly separate UI (Presentation), Logic (Domain), and Data (Infrastructure).
    *   Adopt a "Feature-First" directory structure to enhance independence per feature.
*   **State Management**:
    *   Implement predictable and Immutable state management.
    *   **Recommended**: Riverpod (with code generation) or BLoC.
    *   Avoid abuse of `setState` and minimize rebuild scope.

## 2. Performance Obsession
*   **60fps / 120fps**:
    *   Jank (stuttering) is synonymous with a bug. Always maintain smooth rendering.
    *   Use `const` constructors thoroughly.
    *   Offload heavy processing (JSON parsing, image processing, etc.) to Isolates (separate threads), not the main thread.

## 3. Platform Fidelity & UI
*   **Native Feel**:
    *   Respect the "feel" of both iOS and Android while unifying the brand world view.
    *   Appropriately use Material 3 and Cupertino widgets, or build highly customized common components.

## 4. Robust Connectivity
*   **Offline-First**:
    *   The app must not crash when the network is disconnected; display viewable data.
    *   Use the Repository Pattern to appropriately manage synchronization between local cache and remote data.
