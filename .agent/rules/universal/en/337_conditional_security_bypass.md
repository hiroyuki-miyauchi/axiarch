# 33. Web Frontend Engineering - Next.js


### 14.23. The Conditional Security Bypass Ban
*   **Law**: In action layers that invoke privileged clients (Service Role, etc.), **baseline authentication and authorization checks must never be omitted** regardless of data status (draft/published, etc.) or importance. While varying authentication intensity by status (presence/absence of OTP, etc.) is acceptable, identity verification of "who is executing" must be unified and enforced across all code paths.
*   **Action**:
    1.  **Unconditional Base Guard**: In all code paths performing privileged operations within Server Actions, execute baseline authentication checks such as `ensureAdminAction()` **outside of conditional branches** (as the first line). Patterns like `if (status === 'public') { ensureAuth() }` that conditionally apply guards are prohibited.
    2.  **Defense in Depth**: Additional verification based on status (OTP, Turnstile, etc.) must be implemented as **layers on top of** the baseline check. Additional verification must never substitute for the baseline.
    3.  **Branch Audit**: Regularly audit all branches of Server Actions with conditional logic (`if/else`, `switch`) to ensure authentication checks are not missing from any branch.
    4.  **Error Symmetry**: When authentication guards throw exceptions, **simultaneously establish** a mechanism on the client side to properly catch and display these errors in the UI. Hardening only the server side while leaving client-side error handling unprepared can cause infinite loops or freezes from authentication errors.
*   **Rationale**: Privileged clients (`service_role`) bypass RLS, making application-layer authentication checks the last line of defense for data protection. Omitting authentication for specific statuses creates a "privilege escalation vulnerability" where authenticated users can execute privileged operations without admin rights through that code path.

### 14.24. The Validation Visibility Mandate
*   **Law**: Form submission functions (`handleSubmit`, etc.) must have not only a handler for validation success but also **a handler for validation failure (`onInvalid`) that must always be set**, making error content visible through logs or UI.
*   **Action**:
    1.  **Always Set onInvalid**: Do not omit the second argument of `form.handleSubmit(onValid, onInvalid)`. When omitted, validation errors result in users perceiving only "nothing happens when I click the button," making root cause identification extremely difficult.
    2.  **Error Logging**: Within the `onInvalid` handler, output error objects to the console or structured logs so that which field's validation rule failed can be immediately identified in development environments.
    3.  **User Notification**: In production, inform users via toast notifications that "there are issues with input content," and provide UX such as scrolling to the field with errors.
    4.  **Schema-Form Sync Audit**: When validation errors occur frequently, check for inconsistencies between Zod schema constraints and the form's data structure (especially JSONB fields and nested objects). Overly strict schemas (e.g., `z.record(z.string(), z.boolean())`) frequently fail to match the actual form data structure.
*   **Rationale**: In large admin panel forms, "button not working" bugs caused by validation errors in invisible fields or recently added fields are frequent. Missing `onInvalid` handlers transform what should be a seconds-long validation error resolution into hours of debugging.

### 14.25. The Recursive Field Initialization Guard
*   **Law**: Including the `fields` object from `useFieldArray` in a `useEffect` dependency array and calling field manipulation methods (`prepend`, `append`, `move`, `remove`, etc.) within it is **prohibited**. Structural corrections to field arrays (e.g., prepending standard items) must be executed exactly once using a `useRef`-based one-time initialization guard.
*   **Action**:
    1.  **Fields Dependency Ban**: Do not include `fields` (the return value of `useFieldArray`) in `useEffect` dependency arrays. Since `fields` returns a new reference with every field operation, it triggers an infinite loop of operation → reference update → re-execution → operation (`Maximum update depth exceeded`).
    2.  **Ref-Based One-Time Guard**: When validation and correction of the field array's initial state is needed, create an initialization flag with `useRef(false)` and use the pattern `useEffect(() => { if (!isInitialized.current) { /* correction logic */ isInitialized.current = true; } }, [])` to execute exactly once.
    3.  **Empty Dependency Array**: Initialization `useEffect` should use an empty dependency array `[]` as a rule. If dynamic processing in response to `fields` changes is needed, use the `form.watch` subscription pattern instead of `useEffect`.
    4.  **Cascading Failure Awareness**: This infinite loop monopolizes the browser's main thread and completely blocks other async operations such as save buttons and authentication flows. Recognize that the blast radius is not limited to the component.
*   **Rationale**: `useFieldArray`'s `fields` generates a new array reference with every operation. Including it in a `useEffect` dependency array causes infinite recursion: field operation → re-render → `useEffect` re-execution → field operation. This is a known design characteristic of React Hook Form, and direct use of `fields` in dependency arrays is not recommended in official documentation.
