# 70. QA & Testing Strategy

## 1. Shift Left Testing
*   **Early Detection**:
    *   Start QA process from requirement definition and design stages, not the final stage of development.
    *   **Static Analysis**: Integrate ESLint, SwiftLint, Detekt etc. into CI to automatically detect issues before code review.
*   **Testing Pyramid**:
    *   **Unit Tests (70%)**: Base on fast and stable unit tests. Coverage goal is 80%+, but value "coverage of critical logic" over numbers. Unit tests for UI components are not recommended due to low ROI.
    *   **Integration Tests (20%)**: Verify coordination between API, DB, and components.
    *   **E2E Tests (10%)**: Target only user critical paths (registration, payment, key features) to suppress maintenance costs. Automate only critical flows.
    *   **Priority**: 1. Type Check(tsc) > 2. Lint > 3. Manual > 4. E2E > 5. Unit. Static Analysis (tsc) is the strongest test.
*   **Mock First Strategy**:
    *   **Offline Dev**: Implement `MOCK_MODE` to allow development without external APIs (Stripe, SendGrid). If no API key, mocks respond automatically to keep dev moving.

## 2. Flaky Test Management
*   **Immediate Action**:
    *   Unstable tests (Flaky Tests) are the biggest enemy of developer trust. Fix immediately upon discovery, or Disable (Skip) until fixed.
    *   **No Retry**: "Auto-retry" that hides test failures is prohibited in principle; solve the root cause.
*   **Seed Data Determinism (Fixed Seed)**:
    *   **Law**: To build reproducible test environments, mandate use of **Fixed IDs/Values** for test data (Seed), never random numbers. "Tests that change results every time" are not tests.
    *   **Snapshot**: Tests dependent on timestamps must also fix time using `FakeTimer` etc.

## 3. Real Device & Compatibility
*   **Mandatory Real Device Testing**:
    *   Simulators are not perfect. Always verify operation on physical devices (iOS/Android) before release.
    *   **TestFlight / Internal App Sharing**: All development team members must dogfood on real devices to detect UX awkwardness.
*   **Fragmentation**:
    *   **Android**: Verify operation on major manufacturers (Samsung, Pixel, Xiaomi) and different OS versions using BrowserStack or AWS Device Farm.
    *   **Network**: Test behavior in unstable network environments like Offline, 3G (Slow), Recovery from Airplane Mode.
*   **Manual Verification Protocol**:
    *   Upon feature completion, verification from following perspectives is mandatory.
    *   **Verification Checklist (Mandatory)**:
        *   **Happy Path**: Does the normal flow work?
        *   **Edge Cases**: Zero data, max characters, network error behavior.
        *   **Cross-Device**: Verify display breakage on PC (Chrome) vs Mobile (iOS Safari Real Device). Watch out for iOS `100vh` issues and Safe Area.
        *   **Role Access**: Is permission separation correctly functioning for Guest, General User, and Admin?
        *   **API Security**: Confirm that requests without `x-api-key` are rejected (Public), and requests with `Authorization: Bearer` (User) are allowed (Native Bypass).
        *   **Natural Scrolling**: No unintended "mystery whitespace" at screen bottom? No double scrollbars?

## 4. Fix Twice Principle
*   **Double Fix**:
    *   When fixing a bug, do not just "Fix Once". Make it a set to "Fix Twice" by creating a mechanism (Add Lint, Strict Type, Add Test) to prevent the same bug from happening again.
*   **The Regression Ban Protocol (Zero Recurrence Mandate)**:
    *   **Law**: Defining "Recurrence of a once-fixed bug" (Regression) as the **"Greatest Failure"** in engineering.
    *   **Action**: 
        1. **Visibility**: When fixing a recurring bug, MUST explicity write "Fact of Recurrence" and "WHY previous mechanism failed" in `task.md` or `walkthrough.md`.
        2. **Hardening**: Mandatory condition for task completion is not just code fix, but adding **Automated Test (Regression Test)** that physically catches that bug.

## 5. Release Criteria
*   **Blockers**:
    *   Release with P0 (Critical) and P1 (Major) bugs remaining is **strictly prohibited**.
    *   **0 Warnings**: Release with Warnings remaining in console or build logs is also prohibited.
*   **Phased Rollout**:
    *   Do not release to all users at once; expand range gradually 1% -> 5% -> 20% -> 100% to minimize impact of unexpected defects.

## 6. Ultimate User Perspective
*   **The Grandmother Test**:
    *   **Standard**: Always ask yourself "Can my grandmother who is not tech-savvy use this without explanation?".
    *   **Intuitiveness**: UI requiring a manual is considered a "Bug".
*   **Bug Bash**:
    *   Before major releases, hold a "Bug Bash" with everyone including designers and PMs, not just engineers, to wash out edge cases from diverse perspectives.
