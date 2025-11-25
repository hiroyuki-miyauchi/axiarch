# 220. QA & Testing Strategy

## 1. Shift Left Testing
*   **Early Detection**:
    *   Start the QA process from the requirements definition and design phases, not the final stage of development.
    *   **Static Analysis**: Integrate static analysis tools like ESLint, SwiftLint, and Detekt into CI to automatically detect issues before code review.
*   **Testing Pyramid**:
    *   **Unit Tests (70%)**: Base on unit tests that are fast and stable. Aim for 80%+ coverage, but prioritize "coverage of critical logic" over numbers.
    *   **Integration Tests (20%)**: Verify coordination between APIs, DBs, and components.
    *   **E2E Tests (10%)**: Target only user critical paths (registration, payment, main features) to keep maintenance costs down.

## 2. Flaky Test Management
*   **Immediate Action**:
    *   Flaky tests are the biggest enemy of developer trust. Fix them immediately upon discovery, or disable (Skip) them until fixed.
    *   **No Retries**: In principle, prohibit "automatic retries" that hide test failures, and solve the root cause.

## 3. Real Device & Compatibility
*   **Mandatory Real Device Testing**:
    *   Simulators are not perfect. Always verify operation on physical devices (iOS/Android) before release.
    *   **TestFlight / Internal App Sharing**: The entire development team must dogfood on real devices to detect UX awkwardness.
*   **Fragmentation Measures**:
    *   **Android**: Verify operation on major manufacturers (Samsung, Pixel, Xiaomi) and different OS versions using BrowserStack or AWS Device Farm.
    *   **Network**: Test behavior in unstable network environments like offline, 3G (slow), and recovery from airplane mode.

## 4. Release Criteria
*   **Blockers**:
    *   Releasing with P0 (Critical) and P1 (Major) bugs remaining is **strictly prohibited**.
*   **Phased Rollout**:
    *   Do not release to all users at once; expand the release scope in stages (1% -> 5% -> 20% -> 100%) to minimize the impact of unexpected defects.

## 5. Ultimate User Perspective
*   **The Grandmother Test**:
    *   **Standard**: Always ask yourself, "Can my grandmother, who is not tech-savvy, use this without explanation?"
    *   **Intuitiveness**: UI that requires a manual is considered a "Bug".
*   **Bug Bash**:
    *   Before a major release, organize a "Bug Bash" with everyone, including designers and PMs, not just engineers, to identify edge cases from diverse perspectives.
