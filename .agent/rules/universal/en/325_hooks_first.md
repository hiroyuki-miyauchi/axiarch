# 33. Web Frontend Engineering - Next.js

### 2.7. The React Hooks Order Guarantee Protocol (Hooks First)
*   **Law**: Hooks (useState, usePathname, etc.) call order must be invariant between renders.
*   **Prohibition**: Placing early returns (`if (!data) return null`) or conditionals BEFORE Hooks calls (at top) when they should be AFTER Hooks is prohibited. Also, placing conditional returns (Early Return) AFTER Hooks calls is prohibited—this causes subsequent Hooks call count to vary between renders, triggering "Rendered more hooks..." errors.
*   **Suspense Mandate (useSearchParams)**:
    *   Components using `useSearchParams()` MUST be wrapped in `<Suspense>` boundary to prevent build-time static analysis errors.
    *   **The Error Boundary Protocol (No White Screen)**:
        *   **Law**: "White Screen of Death" from React runtime errors is not permitted.
        *   **Action**: Use `react-error-boundary` to set error boundaries at root (`layout.tsx`) and major feature sections, always displaying "Error UI with retry button".
*   **Correct Structure (The Hooks First Protocol)**:
    *   **Law**: Placing conditional returns (Early Return) AFTER Hooks calls is **guilty** as it causes Hooks count variation on next render, destroying React consistency—completely prohibited. This is a **"Technical Felony"** making debugging extremely difficult.
    *   **Mandatory Order (Google Antigravity Standard)**:
        1.  **ALL HOOKS FIRST**: Aggregate ALL Hooks (useState, usePathname, etc.) at component top.
        2.  **DERIVED STATE**: Place variable calculations and state judgments after Hooks.
        3.  **CONDITIONAL RETURNS**: Place Early Returns (error handling, loading) AFTER derived state.

### 2.7.1. The Static Component Persistence Protocol (Module Scope Mandate)
*   **Law**: Defining components inside another component's render function is prohibited. Each re-render creates a new component type, causing React to discard the DOM tree — resulting in **input focus loss**, **state resets**, and catastrophic performance degradation.
*   **Action**: Sub-components and wrapper components MUST be defined at **Module Scope (file top-level)**. When values need to be passed, use explicit Props.
*   **Anti-Pattern**: `const MyComponent = () => { const SubComponent = () => <div />; return <SubComponent />; }` — This is a **Technical Felony**.

### 2.7.2. The Route Conflict Ban (Zero Duplicate Route)
*   **Law**: When refactoring pages (directory moves), the **source directory MUST be physically deleted**. Stale `page.tsx` files cause the framework (Next.js, etc.) to detect route conflicts, resulting in **build errors**.
*   **Action**: After file moves, verify no stale files remain using `find` or `git status`.
