# 80. QA & Testing Strategy (Quality Assurance View)

## 1. The Testing Pyramid (Silicon Valley Standard)
Testing is about "Balance," not just "Quantity." Maintain the following pyramid structure.

*   **Unit Tests (70%)**:
    *   Target logic, utilities, and Firestore Security Rules.
    *   Fast execution serves as the foundation for the development feedback loop.
*   **Widget/Component Tests (20%)**:
    *   UI tests for individual Flutter Widgets or screens.
    *   **Golden Tests (Visual Regression)**: Introduce pixel-perfect snapshot testing (Golden File Testing) to prevent design regressions.
*   **Integration/E2E Tests (10%)**:
    *   Simulate key user flows (Login -> Payment -> Completion).
    *   Use Firebase Test Lab to guarantee operation on real devices. Focus only on critical paths as they are fragile and costly to maintain.

## 2. CI/CD Pipeline (GitHub Actions)
*   **Automated Checks**:
    *   Lint, Unit Test, and Build must run automatically upon PR creation. Merging is prohibited unless checks pass (Branch Protection).
*   **Continuous Delivery**:
    *   Merging into the `main` branch triggers immediate deployment to the Staging environment (Firebase App Distribution).

## 3. Manual Testing Strategy
*   **Exploratory Testing**:
    *   Allocate time for humans (Owner or AI) to explore the app to discover "oddities" or "usability issues" that automated tests cannot catch.
*   **Dogfooding**:
    *   Developers must use the app daily and become the first users.
