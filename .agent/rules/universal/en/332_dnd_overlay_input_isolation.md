# 33. Web Frontend Engineering - Next.js

### 14.11. The DnD Overlay Input Isolation Protocol
*   **Law**: Form input elements such as `<input>`, `<select>`, and `<textarea>` MUST NOT be rendered as-is within DragOverlay (the ghost element displayed during drag) of Drag & Drop (DnD) libraries.
*   **Action**:
    1.  **Render-Only Overlay**: Components within DragOverlay MUST be limited to **display-only** views (text display, icons, etc.).
    2.  **Name Collision Prevention**: When form input elements are cloned into the Overlay, `<input>` elements with identical `name` attributes become duplicated in the DOM, destroying form library data integrity.
    3.  **Conditional Rendering**: In the DragOverlay rendering path, use flags (`isOverlay` props, etc.) to suppress form element rendering.
*   **Rationale**: DnD DragOverlay adds a "visual copy" of the dragged item to the DOM. When this copy contains form elements, form libraries (React Hook Form, etc.) encounter two input fields with the same name in the DOM, causing duplicate value registration and validation malfunctions.

### 14.13. The Deep Type Recursion Break Protocol
*   **Law**: For type recursion errors caused by excessively deep TypeScript type generics (`Type instantiation is excessively deep`), escaping to `any` type is prohibited. Use techniques that limit recursion depth while maintaining type safety.
*   **Action**:
    1.  **Bounded Generic**: For overly deep generics, use "loose but safe types" such as `Record<string, unknown>` as intermediate boundaries, and perform type guards or explicit casts within the boundary.
    2.  **No `any` Escape**: Type bypass to `any` is a complete abandonment of type safety. Use `unknown` instead and safely narrow types through Type Guard functions.
    3.  **Library Type Wrapper**: When third-party library type definitions are too deep, define wrapper types to limit generic depth.
    4.  **Diagnostic**: When errors occur, use the TypeScript Compiler's `--generateTrace` option to identify which type definition is causing the recursion.
*   **Rationale**: Escaping to `any` only "silences the compiler" and completely destroys runtime type safety. The `unknown` + type guard pattern ensures safety at both compile time and runtime.

### 14.14. The Strict DTO Boundary Protocol
*   **Law**: When converting "loosely typed" data from external data sources (databases, external APIs, file systems, etc.) to "strictly typed" application-internal types, **the input boundary must pass through the `unknown` type** and be safely converted through type guards or validation functions.
*   **Action**:
    1.  **Unknown First**: JSON data retrieved from external sources should first be received as `unknown` type and converted to application types through validation (Zod `parse`, etc.).
    2.  **No Direct Cast**: Direct casting with `as TargetType` is prohibited. This assigns types without verifying that the data structure matches expectations, and is a direct cause of runtime errors.
    3.  **Mapper Function**: DB record → DTO conversion must be performed through dedicated mapper functions (e.g., `toStoreDto(row: DatabaseRow): StoreDto`), consolidating conversion logic in a single location.
    4.  **Nullable Safety**: Properly handle `null | undefined` from external data, and in application types either provide default values or explicitly define as optional (`?`).
*   **Rationale**: JSON columns in databases and external API responses always have the potential for divergence between type definitions and actual data structures. Passing through `unknown` achieves defensive code that does not rely on the assumption "the type should be correct."

### 14.15. The Watch Subscription Safety Protocol
*   **Law**: Including the return value of React Hook Form's `form.watch()` or the `form` object itself in `useEffect` dependency arrays is **prohibited**. These produce new references on every render, directly causing infinite loops.
*   **Action**:
    1.  **No Watch in Deps**: The pattern `const values = form.watch(); useEffect(() => { ... }, [values])` is prohibited. The `watch()` return value creates a new object reference on every render, triggering `useEffect` each time.
    2.  **Subscription Pattern**: To monitor form value changes, use the callback form within `useEffect`: `form.watch((value, { name }) => { ... })`, and call the returned unsubscribe function in the cleanup.
    3.  **Targeted Watch**: When monitoring specific fields only, use `form.watch('fieldName')` and include only individual primitive values in the dependency array.
    4.  **Form Object Stability**: Do not include the `form` object itself in `useEffect` dependency arrays either. If the instance is regenerated due to `useForm` option changes, the same infinite loop will occur.
*   **Rationale**: Including object references in `useEffect` dependency arrays causes React's shallow comparison (`Object.is`) to determine "changed" on every render, executing the Effect infinitely. This is an anti-pattern common to all "hooks that return objects," not limited to React Hook Form.

### 14.16. The handleSubmit Validation Visibility Mandate
*   **Law**: When using `form.handleSubmit(onSuccess)`, **the second argument `onInvalid` handler must always be specified** to make validation failure error details visible to developers and users.
*   **Action**:
    1.  **Mandatory onInvalid**: Always implement the validation error handler in the form `form.handleSubmit(onSuccess, onInvalid)`. When `onInvalid` is unspecified, validation errors result in a silent bug where "nothing happens."
    2.  **Error Logging**: Output `console.error('Validation Errors:', errors)` within the `onInvalid` handler to immediately identify which fields failed validation.
    3.  **User Feedback**: For large-scale forms like admin panels, display a toast notification saying "Validation errors exist" and implement scrolling to or highlighting the fields with errors.
    4.  **Schema Sync**: When `handleSubmit` "silently" doesn't work, suspect a structural mismatch between the Zod schema and form data, particularly checking schema definitions for JSONB fields or dynamically added fields.
*   **Rationale**: In large forms (multiple tabs, dozens of fields), validation errors from invisible or recently added fields frequently cause "button doesn't work" bugs. Not specifying `onInvalid` abandons the most fundamental debugging clue.

# 33. Web Frontend Engineering - Next.js
