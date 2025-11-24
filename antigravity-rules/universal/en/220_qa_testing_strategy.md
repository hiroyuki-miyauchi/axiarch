# 220. QA & Testing Strategy

## 1. Testing Pyramid
*   **Unit Tests (70%)**:
    *   **Scope**: Utility functions, domain logic, individual components.
    *   **Tools**: Jest, Vitest, JUnit, XCTest.
    *   **Criteria**: Prioritize coverage of critical logic while using coverage (C0/C1) as an indicator.
*   **Integration Tests (20%)**:
    *   **Scope**: API and DB interaction, inter-component interaction.
    *   **Tools**: Supertest, React Testing Library.
*   **E2E Tests (10%)**:
    *   **Scope**: Key user operation flows (Signup, Payment, Core Features).
    *   **Tools**: Playwright, Cypress, Maestro (Mobile).
    *   **Operation**: Since they are brittle, limit implementation to critical paths.

## 2. CI/CD Gates
*   **Auto-Blocking**:
    *   Use GitHub Actions or similar to block merges for PRs with Lint errors, type errors, or test failures.
*   **Preview Environments**:
    *   Automatically deploy a preview environment (Vercel Preview, Firebase Hosting Preview) for each PR to facilitate visual verification.

## 3. Manual QA
*   **Dogfooding**:
    *   The development team itself must use the app daily ("Dogfooding") to detect UX awkwardness and bugs early.
*   **Release Criteria**:
    *   Mandate passing all items on the "Release Checklist" (Core feature operation, billing test, log output check) before release.

## 4. Bug Management
*   **Zero Bug Policy**:
    *   Manage discovered bugs with priority (P0: Immediate fix to P3: Next release), and prohibit releases with P0/P1 bugs.
    *   **Reproduction Steps**: Bug reports must always include "Reproduction Steps," "Expected Result," and "Actual Result."

## 5. Compatibility & Real Device Testing
*   **Browser & OS Support**:
    *   **Web**: Latest 2 versions of Chrome, Safari (iOS/Mac), Firefox, Edge.
    *   **Mobile**: Latest 2 major versions of iOS and Android (e.g., iOS 17/18, Android 14/15).
*   **Mandatory Real Device Testing**:
    *   **TestFlight / Internal App Sharing**: Do not rely solely on simulators. Always distribute via TestFlight or Google Play Internal App Sharing and verify operation on real devices.
    *   **Cloud Testing**: Use BrowserStack or AWS Device Farm to test fragmentation on devices not on hand or older Android devices.
*   **Edge Cases**:
    *   **Network**: Verify behavior and error handling under Offline and 3G (slow network) conditions.
