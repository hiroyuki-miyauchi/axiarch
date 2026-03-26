# 31. Mobile Engineering - Flutter

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-03-24

> [!IMPORTANT]
> **Supreme Directive**
> "Flutter is One Codebase — but never One Compromise. Platform fidelity is non-negotiable."
> All Flutter implementations must deliver native-quality UX on every platform.
> Strictly follow: **UX Fidelity > Performance > Code Reuse > Development Speed**.
> **7 Sections.**

---

## Table of Contents

1. [§1. Architecture & State Management](#1-architecture--state-management)
2. [§2. Performance Optimization](#2-performance-optimization---60fps-or-die)
3. [§3. Platform Fidelity & Integration](#3-platform-fidelity--integration)
4. [§4. User Guidance & Onboarding](#4-user-guidance--onboarding)
5. [§5. Quality Assurance](#5-quality-assurance)
6. [§6. Deployment & Distribution](#6-deployment--distribution)
7. [§7. Security & API Integration](#7-security--api-integration)
8. [Appendix A: Quick Reference Index](#appendix-a-quick-reference-index)

---

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

## 5. Quality Assurance
*   **Golden Tests**:
    *   Mandate snapshot testing using **Golden Toolkit** as UI regression testing.
    *   Automatically detect layout breakage on different device sizes (iPhone SE, Pro Max, Pixel).
*   **Maestro**:
    *   Use **Maestro** for E2E testing to automate actual user operation flows.

## 6. Deployment & Distribution
*   **CI/CD**:
    *   Link GitHub Actions with Codemagic/Bitrise to automatically distribute to TestFlight/Google Play Internal Testing triggered by merge to main branch.
    *   For release builds, always enable Obfuscation and Optimization (Tree Shaking). Use `flutter build ipa --obfuscate --split-debug-info=/<path>`.

## 7. Security & API Integration
*   **The Native Bypass Protocol (VIP Lane Strategy)**:
    *   **Law**: To support Backend Tier 2 (VIP Lane) strategy, mandate that logged-in user requests **MUST NOT send API Keys (`x-api-key`) but ONLY `Authorization: Bearer <token>`**.
    *   **Reason**: To physically eliminate the risk of embedding API Keys (Secrets) within the app binary. Ideally, refrain from holding even Public Keys inside the app.

---

## Appendix A: Quick Reference Index

### Reverse Lookup Index (Keyword → Section)

| Keyword | Section |
|---|---|
| Riverpod, Hooks, Freezed, Layered | §1 Architecture |
| 60fps, rebuild, startup, cache | §2 Performance |
| Swipe back, deep linking, adaptive UI | §3 Platform Fidelity |
| Coach marks, onboarding | §4 User Guidance |
| Golden Test, Maestro, E2E | §5 Quality Assurance |
| CI/CD, Codemagic, TestFlight | §6 Deployment |
| API Key, Bearer Token, VIP Lane | §7 Security |

### Cross-References (Section → Related Rules)

| Section | Related Universal Rules |
|---|---|
| §1 Architecture | `300_engineering_standards`, `343_native_platforms` |
| §2 Performance | `200_design_ux`, `300_engineering_standards` |
| §3 Platform Fidelity | `343_native_platforms`, `200_design_ux` |
| §4 Onboarding | `200_design_ux` |
| §5 QA | `700_qa_testing` |
| §6 Deployment | `502_site_reliability`, `300_engineering_standards` |
| §7 Security | `600_security_privacy`, `301_api_integration` |
