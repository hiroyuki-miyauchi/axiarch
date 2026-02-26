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
