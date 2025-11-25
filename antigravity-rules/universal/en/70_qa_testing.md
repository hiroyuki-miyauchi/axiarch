# 70. QA & Testing Strategy

## 1. Shift Left Testing
*   **Early Detection**:
    *   Start QA process from requirement definition and design stages, not the final stage of development.
    *   **Static Analysis**: Integrate ESLint, SwiftLint, Detekt etc. into CI to automatically detect issues before code review.
*   **Testing Pyramid**:
    *   **Unit Tests (70%)**: Base on fast and stable unit tests. Coverage goal is 80%+, but value "coverage of critical logic" over numbers.
    *   **Integration Tests (20%)**: Verify coordination between API, DB, and components.
    *   **E2E Tests (10%)**: Target only user critical paths (registration, payment, key features) to suppress maintenance costs.

## 2. Flaky Test Management
*   **Immediate Action**:
    *   Unstable tests (Flaky Tests) are the biggest enemy of developer trust. Fix immediately upon discovery, or Disable (Skip) until fixed.
    *   **No Retry**: "Auto-retry" that hides test failures is prohibited in principle; solve the root cause.

## 3. Real Device & Compatibility
*   **Mandatory Real Device Testing**:
    *   Simulators are not perfect. Always verify operation on physical devices (iOS/Android) before release.
    *   **TestFlight / Internal App Sharing**: All development team members must dogfood on real devices to detect UX awkwardness.
*   **Fragmentation**:
    *   **Android**: Verify operation on major manufacturers (Samsung, Pixel, Xiaomi) and different OS versions using BrowserStack or AWS Device Farm.
    *   **Network**: Test behavior in unstable network environments like Offline, 3G (Slow), Recovery from Airplane Mode.

## 4. Release Criteria
*   **Blockers**:
    *   Release with P0 (Critical) and P1 (Major) bugs remaining is **strictly prohibited**.
    *   **0 Warnings**: Release with Warnings remaining in console or build logs is also prohibited.
*   **Phased Rollout**:
    *   Do not release to all users at once; expand range gradually 1% -> 5% -> 20% -> 100% to minimize impact of unexpected defects.

## 5. Ultimate User Perspective
*   **The Grandmother Test**:
    *   **Standard**: Always ask yourself "Can my grandmother who is not tech-savvy use this without explanation?".
    *   **Intuitiveness**: UI requiring a manual is considered a "Bug".
*   **Bug Bash**:
    *   Before major releases, hold a "Bug Bash" with everyone including designers and PMs, not just engineers, to wash out edge cases from diverse perspectives.
