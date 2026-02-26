# 33. Web Frontend Engineering - Next.js

### 2.6. The Design Consistency Protocol (No Native Inputs)
*   **Law**: Ban system native `<input type="date">` as "foreign objects" breaking design system (Shadcn UI) unity.
*   **Action**: MUST use `Popover + Calendar` or `Select` components with custom styles. Mandate `h-10` (40px) alignment for horizontal elements.
*   **Class Sorting**: `prettier-plugin-tailwindcss` usage is mandatory.
    *   **The App-Like Feel Protocol (Overscroll Control)**:
        *   **Context**: Mobile Web Apps (PWA) or native-like feel.
        *   **Action**: **Recommend** applying `overscroll-behavior-y: none` to disable browser "Pull to Refresh". Do not enforce on general websites requiring standard reload.
*   **The Hook Dependency Protocol**:
    *   **Law**: `useEffect` / `useCallback` dependency arrays MUST strictly follow ESLint (`react-hooks/exhaustive-deps`).
    *   **Prohibition**: Removing dependencies because of "Infinite Loops" (Lying) is strictly prohibited. It proves logic itself is wrong (updating state too much in Effect). Redesign.

# 33. Web Frontend Engineering - Next.js
