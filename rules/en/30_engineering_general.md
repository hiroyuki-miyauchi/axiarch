# 30. Engineering Excellence (General)

## 1. Code Quality
*   **Clean Code**:
    *   Code is an "Asset." Enforce Readability, Single Responsibility Principle (SRP), and DRY Principle.
    *   Variable and function names must be "Self-documenting code" that conveys intent without comments.
*   **Refactoring (Boy Scout Rule)**:
    *   Always leave the file cleaner than you found it. Do not accumulate technical debt.
    *   "I'll fix it later" never comes. Fix it now.

## 2. Security by Design (DevSecOps)
*   **Security First**:
    *   Security is not an afterthought. Build it in from the design phase.
    *   **Zero Trust**: Distrust all input values (Validation is mandatory). Strict Authentication & Authorization.
    *   Never hardcode sensitive information (API Keys, etc.) in the code.

## 3. Digital 5S (Cleanup & Optimization)
*   **Seiri (Sort) & Seiton (Set in Order)**:
    *   Unused files, images, functions, and commented-out code are "Trash." Delete them immediately upon discovery.
    *   Keep directory structures logical and predictable.
*   **Seiso (Shine) - Refactoring**:
    *   **Continuous Refactoring**: Clean existing code slightly with every feature addition (Boy Scout Rule). Do not set aside large refactoring periods; do it daily.
    *   **Performance Tuning**: Regularly profile and eliminate bottlenecks. Do not optimize by guessing (Premature Optimization is the root of all evil).

## 4. Observability
*   **Monitor Everything**:
    *   Visualize not just "that it works" but "how it works" (Logs, Metrics, Error Tracking).
    *   Detect errors before the user does.
