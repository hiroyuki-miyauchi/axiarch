# 80. QA & Testing Strategy (Quality Assurance View)

## 1. The Testing Pyramid (Silicon Valley Standard)
Testing is about "Balance," not just "Quantity." Maintain the following pyramid structure.
# 80. QA & Testing Strategy

## 1. Testing Pyramid
*   **Unit Tests (70%)**:
    *   Test individual functions and classes. Aim for high coverage of business logic.
*   **Integration Tests (20%)**:
    *   Test interactions between modules (API + DB, Widget + Provider).
*   **E2E Tests (10%)**:
    *   Test critical user flows (Login -> Purchase) on real devices/emulators. Use Maestro.

## 2. CI/CD Pipeline
*   **Automated Checks**:
    *   Run Lint, Unit Tests, and Build on every Pull Request.
    *   **Rule**: PRs cannot be merged if any check fails.

## 3. Self-Check List (Before Review)
*   **Mandatory**:
    *   [ ] Does it work on iOS and Android?
    *   [ ] Are there any console errors?
    *   [ ] Is the design pixel-perfect?
    *   [ ] Are edge cases (empty state, error state) handled?

## 4. Test Perspectives
*   **Monkey Testing**:
    *   Randomly tap buttons to find crashes.
*   **Network Conditions**:
    *   Test behavior under offline or slow network conditions.
*   **Dogfooding**:
    *   Developers must use the app daily and become the first users.
