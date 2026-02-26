# 33. Web Frontend Engineering - Next.js

### 2.2. The Clean Import & Export Protocol
*   **The Barrel Export Prohibition (Performance Guard)**:
    *   **Law**: Bulk re-export via directory-level `index.ts` (Barrel file) is prohibited.
    *   **Reason**: Significantly slows down build speed in dev environment (Next.js Dev) and triggers unintended transpile load (loading all components). Imports MUST be made directly from physical files/paths.
*   **The Dead Code Execution Protocol**:
    *   **Law**: Do not place heavy imports, external module function executions, or DOM side effects (useEffect, etc.) "after" conditional branches or early returns.
    *   **Action**: Logic completely unnecessary depending on conditions should be separated by Next.js `dynamic()` or `Suspense` boundaries, or definitions placed outside (Top-Level) so they are "physically" not executed in the codebase.

*   **The Semicolon Guard (ASI Safety)**:
    *   **Law**: When the next line starts with a parenthesis (`(` or `[`) after a side-effect execution line, you MUST explicitly add a semicolon `;`. Physically prevent "stealth bugs" caused by ASI (Automatic Semicolon Insertion) failure.
    *   **Action**: Enable ESLint's `no-unexpected-multiline` rule and auto-detect in CI.

*   **The Component Colocation Protocol (Maintaining Proper Granularity)**:
    *   **Law**: "Sub-components," "type definitions," and "constants" used only by a specific component should be written in the **same file (Co-location)** as a principle. Excessive file splitting increases cognitive load.
    *   **Split Threshold**: Splitting sub-components into separate files is permitted only when the file exceeds **300 lines**. When splitting, create a directory and group related files together.

### 2.3. Headless UI Architecture (Web Only Prohibition)
*   **Rule**: UI components must focus only on "Displaying Data" and "Firing Events". Business logic is prohibited (Dumb UI).
*   **Prohibition**: Fetching within components or state management dependent on specific page DOM structure (Web Only Design) is strictly prohibited as it hinders future Native porting.
