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

# 40. Operations & Workflow

## 1. Agile & Scrum
*   **Sprint Cycle**:
    *   **1 Week Sprint**: Adopt a 1-week sprint to iterate at high speed.
    *   **Review**: Hold a "Demo Day" every Friday to show working software.
*   **Ticket Management**:
    *   **No Ticket, No Work**: Every task must have a ticket (GitHub Issues/Linear).
    *   **Definition of Done (DoD)**: Clear criteria for completion (Code reviewed, Tested, Deployed).

## 2. Docs as Code
*   **Markdown**:
    *   Manage all documentation in Markdown within the Git repository.
    *   **Review**: Documentation updates must be reviewed in PRs just like code.
*   **Mermaid**:
    *   Use Mermaid.js for diagrams (Flowcharts, Sequence diagrams) to keep them version-controllable.

## 3. Communication
*   **Async First**:
    *   Prioritize asynchronous communication (Slack/GitHub) over synchronous meetings.
    *   **Meeting Rules**: No meeting without an agenda. If the goal is achieved, end the meeting early. logic.

## 3. Phase 3: Verification & Cleanup
*   **User Perspective Testing**:
    *   Strictly verify operation not as a developer but as a "First-time General Consumer" (UI/UX Check).
*   **Cleanup**:
    *   Thoroughly delete debug logs, temporary files, and commented-out code.
*   **Documentation**:
    *   Document changes, API specifications, and operation procedures to accumulate knowledge.
