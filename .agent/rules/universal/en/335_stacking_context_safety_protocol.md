# 33. Web Frontend Engineering - Next.js

### 14.26. The Stacking Context Safety Protocol
*   **Law**: Applying explicit `z-index` to elements within normal content that should be layered below **fixed-position UI elements** (sticky headers, modals, drawers, etc.) is **prohibited in principle**. Structurally prevent "punch-through" layout breakage caused by z-index conflicts.
*   **Action**:
    1.  **Default Layer Maintenance**: Elements within normal content areas (cards, badges, check icons, etc.) should remain with unspecified z-index (default: auto/0 equivalent). Applying `z-10` or higher within content areas causes conflicts with sticky headers (also `z-10`, etc.) at the same layer, causing "punch-through" during scrolling.
    2.  **Layering Hierarchy Definition**: Establish a z-index hierarchy definition within the project (e.g., content layer = 0-9, sticky headers = 10-19, drawers = 20-29, modals = 30-39, toasts = 40-49). All components must set z-index according to this hierarchy.
    3.  **Periodic Audit**: Periodically scan the codebase for elements with `z-index` applied within scrollable content areas. `z-index` combined with `position: absolute` or `position: relative` is the most common cause of "punch-through."
    4.  **Isolation Strategy**: When controlling element stacking order within content, apply `isolation: isolate` to the parent element, creating a new stacking context that limits the z-index blast radius to within that parent element.
*   **Rationale**: z-index is evaluated relatively within the same stacking context. Carelessly setting high values on content elements causes conflicts with UI elements like sticky headers and modals at the same layer. The resulting display order becomes unpredictable based on DOM tree position, especially causing layout breakage during scrolling such as "check icons overlapping the header."

### 14.27. The CSS Class Merge Utility Protocol
*   **Law**: When conditionally applying classes in utility-first CSS frameworks (Tailwind CSS, etc.), **manual concatenation via template literals or string concatenation is prohibited**. The use of dedicated merge utilities such as `cn()` / `clsx` + `tailwind-merge` is mandatory.
*   **Action**:
    1.  **Utility Function Mandate**: Define a `cn()` function (combination of `clsx` + `tailwind-merge`) as a shared project utility and use it across all components. Template literals like `className={`px-4 ${isActive ? 'bg-blue-500' : ''}`}` cannot detect class conflicts.
    2.  **Conflict Resolution**: `tailwind-merge` automatically resolves multiple utility classes targeting the same CSS property (e.g., `px-4` and `px-8`) using last-wins rules. Manual concatenation lacks this resolution, applying unpredictable styles.
    3.  **Empty String Prevention**: Use `cn()` or `clsx` to automatically filter out empty strings `''` and `undefined` that would otherwise contaminate the class list when conditions are `false`.
    4.  **Component Props Pattern**: When components accept `className` from external sources, merge internal and external classes using the `cn(baseClasses, className)` pattern.
*   **Rationale**: Manual concatenation of CSS utility classes cannot detect class duplication or conflicts, making style priority unpredictable. In Tailwind CSS specifically, when multiple utilities target the same CSS property, the result depends on stylesheet appearance order rather than CSS specificity, causing silent bugs where visually correct code applies different styles in production.

### 14.28. The Explicit Initial State Typing Mandate
*   **Law**: When passing empty arrays `[]`, `null`, or values where inference is difficult as initial values to React's `useState`, **generic type parameters must be explicitly specified**. Implicit initialization relying on type inference is prohibited.
*   **Action**:
    1.  **Empty Array Typing**: `useState([])` is prohibited. Use `useState<Item[]>([])` to explicitly specify the element type. When the type parameter is omitted, TypeScript infers `never[]`, causing type errors on subsequent `setState(items)` calls.
    2.  **Nullable State Typing**: `useState(null)` is prohibited. Use `useState<User | null>(null)` to explicitly specify the non-null type. When omitted, the `null` literal type is inferred, making non-null value assignments type errors.
    3.  **Complex Object Typing**: When using object initial values (`useState({})`), specify concrete types like `useState<FormState>({})`. Inference from empty objects does not include necessary properties in the type.
    4.  **Primitive Exception**: Primitive values like `useState(0)`, `useState('')`, `useState(false)` have accurate inference, so explicit type parameters are optional.
*   **Rationale**: TypeScript's type inference derives types from initial values, but `[]` infers as `never[]` and `null` as the `null` literal type. This causes type mismatches to surface when data is actually assigned, pushing developers into a vicious cycle of escape-casting with `as` or ignoring type errors. Explicit typing at initialization fundamentally prevents this problem.

### 14.29. The Compiler Readiness Protocol
*   **Law**: In preparation for future migration to next-generation compiler optimization tools such as React Compiler, **excessive manual use of `useMemo` / `useCallback` should be avoided**, and compiler-compatible coding patterns are recommended.
*   **Action**:
    1.  **Avoid Premature Memoization**: Avoid preemptively applying `useMemo` / `useCallback` before performance issues are confirmed through measurement. Compilers have the ability to perform these optimizations automatically, and manual memoization may interfere with compiler optimizations.
    2.  **Pure Function Preference**: Implement components as **pure functions** whenever possible. Consolidate side effects into `useEffect` and keep rendering logic side-effect-free so that compiler static analysis functions accurately.
    3.  **Stable Reference Pattern**: Instead of regenerating objects and arrays during rendering, define them as module-scope constants or maintain stable references with `useRef`.
    4.  **Migration Path**: Existing `useMemo` / `useCallback` need not be immediately removed. In new code, avoid excessive manual memoization and apply only where necessity is confirmed through performance profiling.
*   **Rationale**: React Compiler achieves automatic memoization of function components, but in code with manually applied `useMemo` / `useCallback`, compiler optimizations and manual optimizations may be double-applied, potentially degrading performance instead. Adopting compiler-compatible coding styles now minimizes future migration costs.

### 14.30. The Server Cookie Write Authority Protocol
*   **Law**: Cookie and response header writes (Set/Delete) are limited to **Server Actions** or **Route Handlers (API Routes)**. Writing cookies during Server Component (`page.tsx`, `layout.tsx`) rendering is **prohibited**.
*   **Action**:
    1.  **Read Only in RSC**: Server Components should in principle only perform Cookie **reads (`cookies().get()`)**. Cookie writes during rendering are unstable per framework specifications and cause unpredictable side effects in streaming SSR environments.
    2.  **Write Authority**: Cookie writes (Set/Delete) must be performed within Server Actions (`'use server'`) or Route Handlers (`route.ts`). These have clear request-response cycles where cookie operations execute safely.
    3.  **Session Management**: Authentication session updates (token refresh, etc.) should be handled in Middleware or Server Actions, separated from the rendering pipeline.
    4.  **Testing**: Server Actions involving cookie operations should verify expected behavior after cookie state changes (redirects, session state reflection, etc.) through automated tests.
*   **Rationale**: Server Component (RSC) rendering may occur in a streaming fashion, and attempting to set cookies after response headers have already been sent results in them being ignored or causing errors. Explicitly limiting write authority to Server Actions / Route Handlers structurally eliminates this unstable behavior.

