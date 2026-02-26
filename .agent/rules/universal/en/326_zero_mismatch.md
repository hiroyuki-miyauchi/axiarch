# 33. Web Frontend Engineering - Next.js

### 2.8. The Hydration Stability Protocol (Zero Mismatch)
*   **Law 1 (Dynamic Content)**: Directly embedding dynamic values like `new Date()` or `Math.random()` in JSX is prohibited. These cause SSR/CSR value mismatch, triggering Hydration Errors.
*   **Law 2 (Identifier Match)**: `id` and `htmlFor` MUST have unique and immutable values, or use React's `useId` to physically guarantee matching.
*   **Law 3 (Extension Defense)**: Add `suppressHydrationWarning` to `<html>` and `<body>` to prevent mismatches from browser extension (Grammarly, Password Managers, etc.) attribute injection. **However, using this attribute to hide developer's own logic bugs is strictly prohibited.**
*   **Law 4 (Date Formatting)**: Date display must be formatted client-side (in `useEffect`) or passed as server-side determined string (UTC, etc.).

# 33. Web Frontend Engineering - Next.js

## 3. Forms & Validation
*   **Library Selection**:
    *   **React Hook Form**: Base on uncontrolled components to minimize re-renders.
    *   **Zod**: Practice Schema-Driven Development. Separate validation logic from UI and define it as Zod schemas.
*   **The Atomic Tabbed Form Protocol (God Component Resolution)**:
    *   **Law**: Forms with **5 or more** related items, or files exceeding **500 lines**, MUST apply **Tabbed Architecture** and be split into child components. A single giant form component (God Component) destroys maintainability, testability, and performance.
    *   **Action**: Split child components should use `useFormContext` to access root form state. Initialization responsibility (`defaultValues`) remains with the root component.
*   **Validation**:
    *   **The External Link Protocol (Context Aware)**:
        *   **Law**: **Recommend** `target="_blank"` for external links to avoid interrupting user workflow.
        *   **Exception**: Do not enforce if "Moving" is correct context (OAuth, Payment). Judge based on UX.
    *   **Client-Side**: Provide real-time feedback for required fields, character counts, and email formats before server submission.
    *   **The Anti-Spam Shield (Bot Protection)**:
        *   **Law**: MUST implement `Cloudflare Turnstile` or `reCAPTCHA` for public forms (Contact, Signup). Spam DB pollution incurs massive cleanup costs.
    *   **Media Interaction (Crop UI)**: Auto-cropping (Center Crop) on server is prohibited. MUST implement UI (e.g., `react-easy-crop`) allowing user to determine trim area.
    *   **The iPhone Support Mandate (HEIC Conversion)**:
        *   **Context**: iPhone `.HEIC` cannot be displayed on Web.
        *   **Action**: Mandate **auto-conversion to JPEG/PNG** client-side (using `heic2any`) before upload. Enable `worker-src blob:` in CSP.
    *   **The Worker CSP Protocol**:
        *   **Action**: Explicitly allow `worker-src 'self' blob:;` in CSP (`middleware.ts`). `script-src` is insufficient for image processing workers.
    *   **Filename Sanitization**: Convert to Romaji (`wanakana`) client-side to prevent multibyte filename troubles.
    *   **Type Safety**: Infer TypeScript types from Zod (`z.infer`) to eradicate form/API mismatches.
    *   **The No-Any Protocol (Resolvers)**: `as any` for `react-hook-form` and `zodResolver` mismatch is strictly prohibited. If necessary, use **Safe Casting** (`as unknown as Resolver<Schema>`).
    *   **The Input Mode Mandate (Keyboard Optimization)**:
        *   **Law**: MUST set `inputMode` (`numeric`, `tel`, `email`) for numeric fields (Phone, Zip, Credit Card) to auto-display optimal keyboard on mobile.
        *   **Outcome**: Remove burden of manual keyboard switching.
    *   **The Input Normalization Protocol (NFKC)**:
        *   **Law**: When users enter full-width numbers (１２３) or full-width spaces, accept them by **auto-converting to half-width via `onChange` or `onBlur` (Normalize)** instead of rejecting with validation errors.
        *   **Implementation**: Use `String.normalize('NFKC')` to adopt "Omotenashi" design that doesn't stress users.
    *   **The IME Composition Guard (CJK Input Safety)**:
        *   **Law**: IME input for CJK languages (Japanese, Chinese, Korean) may fire `onChange` events before composition is finalized, causing search request storms or input value corruption.
        *   **Action**: For real-time search, autocomplete, and other immediate-response inputs, monitor `compositionstart` / `compositionend` events and suppress action firing during composition.
