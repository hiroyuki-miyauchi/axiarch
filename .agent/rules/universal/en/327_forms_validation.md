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

### 3.3. Auto-Save & Data Persistence Protocol
*   **Mandatory Scope**: **Auto-Save** functionality is mandatory for articles, settings, and long-text forms in the Admin Panel (Data Loss Zero Tolerance).
*   **Implementation Standard**:
    *   **Hook Strategy**: Use a standardized `useAutoSave` hook to save to Local Storage after a delay (e.g., 2000ms) from input cessation.
    *   **Passive Restoration**: Do not automatically restore drafts on page load. Instead, display a **"Draft Found" notification (Banner)** and let the user choose.
    *   **Hygiene**: Upon successful submission, strictly clear the Local Storage (`clearDraft`) to prevent old data persistence.
*   **The iOS Input Zoom Defense (Mobile UX Guard)**:
    *   **Problem**: On iOS Safari, if input field font size is **less than 16px**, it automatically zooms in on focus, significantly damaging UX.
    *   **Mandate**: `font-size` for `input`, `textarea`, `select` in mobile view MUST be set to **16px (`text-base`) or larger**.
    *   **Technique**: Adopt implementation switching `text-base` for mobile and `md:text-sm` for desktop as standard.

### 3.4. The Dynamic Form Engine Protocol
*   **Law**: Hardcoding inquiry forms or application forms as fixed React components (`ContactForm.tsx`) is prohibited as it requires deployment for business requirement changes.
*   **Action**:
    1.  **Schema-Driven Rendering**: Define form structure (field names, types, validation) in DB tables (e.g., `inquiry_forms`, `form_fields`) or JSON schema, and render UI dynamically.
    2.  **Field Type Registry**: Define input types like text, select, date, file upload as standard registry and allow reference from schema.
    3.  **Spam Protection**: Cloudflare Turnstile or equivalent Bot protection is mandatory for all public forms.

## 4. PWA & Cross-Platform
*   **PWA (Progressive Web App)**:
    *   **Installable**: Configure `manifest.json` properly to enable adding to Home Screen.
    *   **Offline Support**: Design using Service Worker so key features (viewed content, etc.) work even offline.
*   **Deep Linking**:
    *   **Smart App Banners**: Implement banners that open the native app if installed, or guide to the store if not, when viewed on mobile browsers.
*   **Server Actions Protocol**:
    *   **The 'use server' Mandate**:
        *   **Law**: Files defining Server Actions MUST describe `'use server'` at the very first line of the file. Declare basically per file units, not per function, to prevent Server/Client boundary leaks.
*   **Hard Session Refresh Protocol (Cookie Sync)**:
    *   **Context**: Even after updating session Cookies via Server Actions, SPA transitions alone may not immediately reflect changes in Middleware or Server Components.
    *   **Mandate**: On authentication state or critical permission changes (Login/Logout, etc.), use `window.location.reload()` for a hard refresh to ensure the server receives the latest Cookie state. A momentary white screen is acceptable since permission mismatch errors cause worse UX damage.

## 5. Compatibility & Error Handling
*   **Browser Compatibility**:
    *   **Target**: Support latest 2 versions of Chrome, Safari, Firefox, Edge, and latest 2 versions of iOS Safari, Android Chrome.
    *   **Polyfill**: Use `core-js` etc. to polyfill only necessary features.
*   **Error Handling**:
    *   **Error Boundaries**: Use React's `ErrorBoundary` to prevent component-level crashes from taking down the entire app.
    *   **Graceful Degradation**: Design so minimal content is displayed even if JavaScript is disabled or errors occur.
    *   **Offline Defense Protocol (Network Resilience)**:
        *   **Component-Level Recovery**: Before the global Error Boundary fires, display a skeleton or error message with a "Reload" button at the component level where data fetching failed.
        *   **Offline Guard**: Monitor `navigator.onLine` and disable form submission buttons during offline state to prevent data loss.
    *   **0 Warnings**: Console Warnings are a sign of technical debt. Resolve all during development; release is not allowed unless **Warning count is 0**.
