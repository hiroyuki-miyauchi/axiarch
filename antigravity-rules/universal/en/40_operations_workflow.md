# 40. Operational Rules (Development Cycle)

### 1.1. Phase 1: Planning & Design (The "Blueprint")
*   **Goal**: Define *what* to build and *why*, with zero ambiguity.
*   **Steps**:
    1.  **Prompt Engineering**: The Owner issues a prompt defining the goal.
    2.  **Trend Scouting (Crucial)**: The AI/Team researches **latest UI/UX trends** (Mobbin/Awwwards) and **tech updates** (Google I/O, WWDC) relevant to the feature.
    3.  **Spec Definition**: Create/Update `implementation_plan.md`.
    4.  **Approval**: Owner reviews and approves the plan. **No code is written until approval.**
    *   Always create an "Implementation Plan (`implementation_plan.md`)" and obtain the Owner's agreement.
    *   *Check*: Does this change contribute to the North Star Metric? Are there security risks?

### 1.4. Phase 4: Cleanup & Optimization (The "Polish")
*   **Goal**: Ensure long-term maintainability and performance.
*   **Steps**:
    1.  **Code Cleanup**: Remove unused imports, comments, and dead code.
    2.  **Asset Optimization**: Compress new images (WebP/AVIF) and remove unused assets.
    3.  **Refactoring**: Address any "quick hacks" introduced during the Execution phase.
    4.  **Documentation**: Update `README.md` and API docs to reflect changes.

### 1.5. Phase 5: Sunset & Deprecation (The "End")
*   **Goal**: Remove dead weight to keep the codebase agile.
*   **Protocol**:
    1.  **Identify**: Use analytics to find features with < 1% usage.
    2.  **Deprecate**: Mark code as `@deprecated` and add "Sunset Headers" to APIs.
    3.  **Announce**: Notify users (if user-facing) or developers (if internal) with a clear timeline.
    4.  **Delete**: Remove the code entirely after the grace period. **Do not comment it out.** Git history is your backup.

## 2. Phase 2: Execution (The Build)
*   **Test-Driven & Atomic**:
    *   Write testable code and make changes in logical units (Atomic Commits).
*   **AI-Assisted Coding**:
    *   Maximize the use of AI tools to automate boilerplate writing and focus on essential logic.

## 3. Phase 3: Verification & Cleanup
*   **User Perspective Testing**:
    *   Strictly verify operation not as a developer but as a "First-time General Consumer" (UI/UX Check).
*   **Cleanup**:
    *   Thoroughly delete debug logs, temporary files, and commented-out code.
*   **Documentation**:
    *   Document changes, API specifications, and operation procedures to accumulate knowledge.
