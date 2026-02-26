# 33. Web Frontend Engineering - Next.js

### 14.17. The useFieldArray Initialization Guard
*   **Law**: Including `useFieldArray`'s `fields` in `useEffect` dependency arrays and performing field operations (`append`, `prepend`, `move`, `remove`, etc.) within that `useEffect` is **prohibited**.
*   **Action**:
    1.  **No Fields in Deps**: The pattern `useEffect(() => { prepend(defaultItem) }, [fields])` is prohibited. Field operations update the `fields` array, which re-triggers the `useEffect`, causing a `Maximum update depth exceeded` infinite loop.
    2.  **Ref-Based Guard**: Control field initialization (adding default items, correcting order, etc.) with a one-time flag using `useRef`. Execute operations only when `isInitialized.current` is `false`, and set it to `true` upon completion.
    3.  **Mount-Only Effect**: Use an empty dependency array `[]` for the initialization logic's `useEffect` so it executes only once on mount.
    4.  **Cascading Awareness**: Be aware that this infinite loop monopolizes the browser's main thread, completely blocking save buttons and other asynchronous processes (authentication flows, etc.).
*   **Rationale**: `useFieldArray` is a powerful hook for managing array data in forms, but interfering with its lifecycle via `useEffect` collides with React's rendering cycle. Particularly, "structure correction" (inserting required items at the beginning, etc.) must guarantee one-time execution during initialization.

### 14.18. The Stacking Context Sovereignty
*   **Law**: **Structurally prevent conflicts** between `z-index` of sticky headers, modals, overlays, and `z-index` within normal page content. As a rule, do not assign explicit `z-index` to normal content.
*   **Action**:
    1.  **Layer Hierarchy**: Define a project-wide `z-index` hierarchy (e.g., content = auto/0, sticky header = 10, dropdown = 20, modal = 30, toast = 40).
    2.  **No Casual Z-Index**: Prohibit in principle setting `z-index` on elements within normal content (cards, icons, badges, etc.). `z-index` combined with `position: relative` can inadvertently create stacking contexts, causing elements to "punch through" sticky headers.
    3.  **Context Isolation**: When a stacking context is needed within the content area, set `isolation: isolate` on the parent element to prevent child `z-index` from polluting the global hierarchy.
    4.  **Scroll Awareness**: When elements with `position: absolute` and `z-index` exist within scrollable content, test that they do not display above the sticky header when scrolling.
*   **Rationale**: `z-index` conflicts cause visually prominent bugs where "certain elements punch through the header when scrolling," but identifying the root cause is difficult. Especially in component-based development, each component independently setting `z-index` easily destroys the global hierarchy.

### 14.19. The Subscription Timer Sanitization Protocol
*   **Law**: When using `setTimeout` / `setInterval` **inside external event listeners** such as `form.watch()` subscription callbacks or `WebSocket` message handlers, timer IDs must be managed via `useRef`, and the previous timer must always be cleared at the beginning of the callback.
*   **Action**:
    1.  **Ref-Based Timer Management**: Hold the timer ID with `const timerRef = useRef<NodeJS.Timeout | null>(null)` and execute `if (timerRef.current) clearTimeout(timerRef.current)` within the callback before setting a new timer.
    2.  **No Closure Timer**: Managing timers with local variables (`let timer`) is prohibited. Subscription callbacks are invoked multiple times across closures, so local variables lose the reference to the previous timer, making cleanup impossible.
    3.  **Cleanup on Unmount**: Execute `clearTimeout(timerRef.current)` simultaneously with subscription unsubscription in the `useEffect` cleanup function to ensure timers are reliably destroyed on component unmount.
    4.  **Debounce Awareness**: For debounce processing like auto-save, this pattern is the only safe implementation. The `useCallback` + `setTimeout` combination causes timer leaks when the dependency array changes.
*   **Rationale**: Timers within subscriptions (`form.watch(callback)`, etc.) are outside React's normal lifecycle management, so `useEffect` cleanup alone cannot prevent leaks. Explicit timer management via `useRef` is the only pattern that structurally avoids both race conditions and memory leaks.

### 14.20. The Resilient RSC Data Access Protocol
*   **Law**: In React Server Components (RSC) or streaming SSR, when data fetch results may be `null` / `undefined`, **null guards must be implemented before property access**. Unguarded null access crashes the RSC stream.
*   **Action**:
    1.  **Early Return Guard**: Perform data fetching at the beginning of Server Components, and if the result is `null`, immediately return `notFound()` or an appropriate fallback UI. Passing `null` as props to child components is prohibited.
    2.  **Non-Null Assertion Ban**: Using `data!.property` (Non-null Assertion) on data fetch results is prohibited. While it appears safe at the type system level, runtime null penetrates the type system and crashes the stream.
    3.  **Error Boundary Integration**: RSC errors may not be caught by regular React Error Boundaries. Properly place `error.tsx` / `not-found.tsx` to guarantee user experience during streaming errors.
    4.  **Opaque Error Awareness**: RSC stream crashes appear in the browser console not as `TypeError` but as opaque network errors (`Failed to fetch`, etc.), making root cause identification difficult. Use server logs as the primary information source.
*   **Rationale**: In traditional client-side rendering, `null` access crashes only the affected component, but in RSC, the entire stream is interrupted, resulting in a white screen or network error for the entire page. Understanding this difference in blast radius and practicing defensive coding is essential.

### 14.21. The Dynamic Library Decoupling Protocol
*   **Law**: Heavy libraries exceeding 50KB (rich text editors, chart libraries, map SDKs, syntax highlighters, etc.) are prohibited from being included in the initial bundle. They must always be lazy-loaded via **dynamic imports** (`next/dynamic`, `React.lazy`, `import()`, etc.).
*   **Action**:
    1.  **Bundle Analysis**: Regularly monitor each chunk's size using `next build` output or tools like `@next/bundle-analyzer`. Client-side chunks exceeding 50KB are optimization candidates.
    2.  **Dynamic Import with SSR Control**: For client-only libraries that don't need SSR, use `dynamic(() => import('...'), { ssr: false })` to avoid server-side bundling and evaluation.
    3.  **Loading Skeleton**: Dynamic import fallbacks should display **Skeleton UI** that mimics the content shape, not full-size spinners, to minimize perceived wait time.
    4.  **Preload Hint**: For libraries that will definitely be needed upon user interaction, use `prefetch` / `preload` hints to begin background loading before the user acts.
*   **Rationale**: Initial bundle size bloat directly degrades TTI (Time to Interactive) and lowers Core Web Vitals scores. Lazy loading of heavy libraries is an essential design pattern that protects both initial display performance and user experience.

### 14.22. The Form DefaultValues Completeness Mandate
*   **Law**: All fields used within a form MUST be **explicitly set in `useForm`'s `defaultValues`**. When managing form state with individual `useState` hooks, all properties of the corresponding DTO must be guaranteed to exist in all three locations: "State initialization," "UI input," and "Submit payload."
*   **Action**:
    1.  **Exhaustive DefaultValues**: Ensure every field specified via `Controller` or `register` `name` exists in `defaultValues`. Fields not included in `defaultValues` will have `undefined` as their initial value, causing the UI to render as blank even when data is returned from the DB (Ghost Mapping).
    2.  **Tab/Sub-Component Synchronization**: When forms are split into tabs or sub-components, scan all `name` specifications within child components and synchronize them with the root `defaultValues`. While `useFormContext` delegates data read/write, initialization responsibility remains with the root component.
    3.  **DTO-Form Naming Alignment**: DTO property names, Zod validation schema key names, and form `name` attributes must be **100% identical**. Renaming across layers (e.g., `dog_description` → `description_dog`) causes data mapping inconsistencies and is prohibited.
    4.  **Schema Addition Protocol**: When adding fields to DTOs or Zod schemas, always simultaneously add them to `defaultValues`. This synchronization gap is the most difficult-to-discover bug causing "saved but not reflected" issues.
    5.  **Vertical Synchronization Audit**: When suspecting field omissions, vertically verify across **DB Schema → DTO → Gateway → Validation → Form** layers. If a "Phantom Field" exists only in UI but not in the DB, remove it from the UI.
*   **Rationale**: Missing `defaultValues` causes two directions of critical bugs: "data is correctly saved in DB but not displayed in UI" and "existing data overwritten with empty values on save (Ghost Write)." In large multi-tab forms especially, field synchronization gaps when adding tabs are frequent, making a structural checking process indispensable.
