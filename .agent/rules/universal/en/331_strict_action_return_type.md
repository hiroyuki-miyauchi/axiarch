# 33. Web Frontend Engineering - Next.js

## 1. Modern Web Architecture
*   **Next.js & React Server Components (RSC)**:
    *   **Default**: Use **App Router** in principle and render with Server Components (RSC) as much as possible. This dramatically reduces the amount of JavaScript sent to the client.
    *   **Data Fetching**: Fetch data on the server side to avoid waterfall issues.
    *   **The Server-Only Import Protocol (Bundle Protection)**:
        *   **Law**: Server-only files (`lib/api/*`, `lib/actions/*`, etc.) MUST include `import 'server-only'`.
        *   **Outcome**: Errors at build time if accidentally imported from Client Components, physically preventing mixing of confidential logic or API Keys into client bundles.
*   **Edge Computing**:
    *   **Middleware**: Execute auth checks and geolocation redirects in **Edge Middleware** to minimize latency.
    *   **The Middleware Lightweight Protocol (Performance Guard)**:
        *   **Law**: Keep `middleware.ts` lightweight and exclude static assets (`/_next/static/*`, `/favicon.ico`, `/robots.txt`, etc.) from processing.
        *   **Action**: Use `matcher` config to limit processing to API Routes (`/api/*`) and page routes (`/(routes)/*`).
        *   **Prohibition**: Heavy DB calls or external API calls in Middleware are prohibited as they cause latency increase.
*   **Directory Ontology**:
    *   **src/app**: Routing definitions only. No logic.
    *   **src/lib/actions**: Server Actions (The Gateway for data).
    *   **src/components**: UI parts. Separate `ui` (Generic) and `features` (Specific).
    *   **The Static Page Prohibition (No Hardcoding)**:
        *   **Law**: Hardcoding content-focused pages (Terms of Service, Privacy Policy, etc.) as `src/app/(public)/terms/page.tsx` is prohibited. MUST deliver from Headless CMS and process via dynamic routing.
    *   **The Anti-Haribote UI Protocol (Realism Mandate)**:
        *   **Law**: UI implementations that treat "future columns" or "ambiguous data in JSON" not in DB schema as normalized data are prohibited. UI and data are indivisible atoms (Atom).
        *   **Action**: If data is needed, first add normalized columns per backend constitution, then implement UI. "Temporary JSON" is an invitation to technical debt.
*   **Site Settings Architecture**:
    *   **Runtime Injection**: Settings like theme colors must be fetched from DB at runtime (RootLayout) and injected as CSS variables, not at build time. This allows design changes without rebuilds.
    *   **The Env Validation Protocol (Fail Fast)**:
        *   **Law**: Directly using `process.env` is prohibited. Use `t3-env` or `zod` to validate environment variable types and existence at build time (or startup).
        *   **Outcome**: App must NOT start if required keys are missing (crash it).
*   **Global Expansion Protocol**:
    *   **Sub-Directory Strategy**: Use unique URLs per language (`/en/stores/tokyo`). Language switching via query parameters or Cookies is prohibited for SEO reasons.
    *   **Universal Time**: Store in UTC in DB and convert to local time based on user's browser locale at display time. Hardcoding Server-side (JST/PST) time is prohibited.
    *   **The Freshness Obligation (SDK Modernization)**:
        *   **Law**: External service SDKs (AI, Auth, Payment, etc.) evolve fast;outdated versions suddenly break (e.g., Gemini model deprecation).
        *   **Action**: Always use latest with `npm i package@latest` for new implementations, and consider "update first" as first solution when issues occur. "Use latest version" is a development policy obligation.

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
