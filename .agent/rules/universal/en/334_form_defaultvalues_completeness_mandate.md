# 33. Web Frontend Engineering - Next.js

### 14.1. The Form DefaultValues Completeness Mandate
*   **Law**: When using `useForm` with React Hook Form (or similar form libraries), `defaultValues` MUST **explicitly set all fields** used in the form.
*   **Reason**: If a field specified by `name` in `Controller` or `useController` does not exist in `defaultValues`, the UI renders empty even when DB data is returned correctly ("DB Success but UI Empty" problem).
*   **Action**:
    1.  **Exhaustive Default**: List all form fields in `defaultValues`. When adding new fields, **always add them to `defaultValues`** as well.
    2.  **Checklist**: When adding fields, verify all of: Schema definition + `defaultValues` + Controller/register + `setValue` call sites + `useFieldArray` usage.
    3.  **Zod Sync**: Systematically compare and verify that all fields defined in the Zod Schema are also included in `defaultValues`.
*   **Diagnostic**: "DB write success + DB read success" but UI is empty → **Suspect `defaultValues` omission**.

### 14.2. The Production Build Verification Protocol
*   **Law**: The development server (`npm run dev`) working does NOT mean the code is correct. **Until `npm run build` passes with Exit 0, that code "does not exist."**
*   **Action**:
    1.  **Local Build**: Always run `npm run build` locally before committing and confirm success.
    2.  **SSG Awareness**: Importing dynamic APIs like `cookies()` in Static Site Generation (SSG) pages works in development but causes "Dynamic server usage" errors in production builds. Isolate dynamic dependencies.
    3.  **Phantom File**: If build errors indicate "non-existent files," use `grep` to locate actual files hidden by re-exports or dynamic imports.
*   **Rationale**: Development servers conceal type errors and import errors through Hot Module Replacement. Only the build reveals the truth.

### 14.3. The Non-Blocking Edge Processing Protocol
*   **Law**: In Edge Middleware and API Routes, blocking DB writes unrelated to the main response (analytics logs, usage metering) with `await` causes response delays for users and is prohibited.
*   **Action**:
    1.  **waitUntil**: Side effects (logging, metering, notifications) MUST be backgrounded using `event.waitUntil()` or equivalent mechanisms.
    2.  **Fire-and-Forget**: Unless there is a justified reason, fire non-response-affecting operations asynchronously without `await`.
    3.  **Error Isolation**: Isolate background processing errors with try-catch to prevent them from affecting the main response.
*   **Outcome**: Minimize user-perceived response time (TTFB) while completing ancillary processing in the background.

### 14.4. The LCP & Lazy Loading Performance Protocol
*   **Law**: Apply first-view (Above the Fold) priority rendering for critical elements and lazy loading for everything else across all pages.
*   **Action**:
    1.  **LCP Priority**: Assign `priority` attribute and `fetchPriority="high"` to the most critical elements within the viewport (hero images, main thumbnails, etc.).
    2.  **CLS Prevention**: Mandate fixed `aspect-ratio` or skeleton placeholders for images and videos, targeting zero Cumulative Layout Shift (CLS).
    3.  **Lazy Everything Else**: All images, videos, and heavy components (maps, social embeds, etc.) outside the first view MUST use `loading="lazy"` or `next/dynamic` for deferred loading.
    4.  **Heavy Library Decoupling**: Libraries exceeding 50KB (rich editors, sliders, etc.) MUST be loaded via `dynamic import` to minimize initial bundle size.
    5.  **Incremental Loading**: Limit initial list loading to 10-12 items, with "Load More" or incremental scroll for additional retrieval.

### 14.5. The Strict Action Return Type Mandate
*   **Law**: All Server Actions (or API call functions) MUST define strict return types (`ActionResult` format, etc.). `Promise<any>` or untyped return values are prohibited.
*   **Action**:
    1.  **Unified Return Shape**: Unify return values into a consistent structure such as `{ success: boolean; data?: T; error?: string; errorDetails?: Record<string, string> }`.
    2.  **All Paths Covered**: Guarantee that all return paths within an Action return the same type structure. Inconsistencies such as missing the `success` property in some paths are a direct cause of `undefined` reference errors on the UI side.
    3.  **No UI-Side Casting**: Casting like `(result as any).error` on the UI side is prohibited. If types don't match, fix the Action's return type.
*   **Rationale**: Type mismatches between Server Actions and UI fundamentally destroy TypeScript's type safety. Strict return types are a "contract by type" between Backend and Frontend.

### 14.6. The Reactive Subscription Safety Protocol
*   **Law**: Directly including return values of reactive observers (`watch()`, `subscribe()`, `onSnapshot()`, etc.) in `useEffect` dependency arrays is prohibited. These APIs generate new object references on every call, causing infinite re-render loops when included in dependency arrays.
*   **Action**:
    1.  **Callback Subscription Pattern**: Instead of tracking observation results in `useEffect` dependency arrays, use **callback-based subscriptions**. Start subscriptions inside `useEffect` and call `unsubscribe()` in the cleanup function.
    2.  **Stable Dependencies Only**: Include only stable references (the form object itself, primitive values, etc.) in `useEffect` dependency arrays.
    3.  **Timer Sanitization (useRef Pattern)**: When using timers (`setTimeout` / `setInterval`) within subscription callbacks, always manage timer IDs with `useRef` and call `clearTimeout` at the beginning of the callback to achieve genuine debouncing. Uncleaned timers are a direct cause of massive async process stacking and memory leaks.
*   **Rationale**: Many reactive libraries internally generate new objects to notify value changes. Connecting these "unstable references" to React's dependency tracking mechanism structurally completes an infinite loop: "same value but different reference" → "re-execution" → "state update" → "re-render" → "new reference."
*   **Anti-Pattern**: `const values = form.watch(); useEffect(() => { save(values); }, [values])` — This generates a new reference on every render and causes an infinite loop.

### 14.7. The One-Shot Initialization Guard Protocol
*   **Law**: Correction and reordering logic for initial values of dynamic arrays (`useFieldArray`, dynamic lists, etc.) MUST be guaranteed to execute only once using a **`useRef`-based flag**. Code that modifies a reactive array while including that array in `useEffect`'s dependency array generates infinite loops.
*   **Action**:
    1.  **Ref-Based Init Flag**: Use `const isInitialized = useRef(false)` to track whether initialization is complete. Execute correction logic only when `isInitialized.current` is `false`, then set it to `true` upon completion.
    2.  **Empty Dependency Array**: The `useEffect` for array correction should have an empty dependency array `[]` or include only values that do not physically change (IDs, etc.). Including the `fields` array itself in dependencies is strictly prohibited.
    3.  **DTO-Form Completeness**: When forms are split across tabs or sub-components, guarantee that all field names used in child components exist in the root's `defaultValues`. Fields not present in `defaultValues` are initialized as `undefined`, causing data loss on save.
*   **Rationale**: Array operations like `prepend` / `move` / `append` update the array's reference, which triggers `useEffect` re-execution. When the re-executed `useEffect` performs further array operations, a `Maximum update depth exceeded` error crashes the browser.
*   **Anti-Pattern**: `useEffect(() => { if (fields[0]?.type !== 'header') prepend(headerItem); }, [fields])` — Watching `fields` while calling `prepend` guarantees an infinite loop.
