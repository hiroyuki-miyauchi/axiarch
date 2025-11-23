# 40. Operational Rules (Development Cycle)

## 1. Phase 1: Planning & Design
*   **Requirement Analysis**: Analyze the Owner's request from Business, Technology, and Design perspectives.
*   **Implementation Plan**:
    *   Always create an "Implementation Plan (`implementation_plan.md`)" and obtain the Owner's agreement.
    *   *Check*: Does this change contribute to the North Star Metric? Are there security risks?

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
