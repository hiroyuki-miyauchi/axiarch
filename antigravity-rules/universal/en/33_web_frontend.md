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

## 2. UI Components & Styling
*   **shadcn/ui + Tailwind CSS**:
    *   **Standard Stack**: Adopt **shadcn/ui** as the standard UI component library for balancing customizability and accessibility.
    *   **Design System**: Use Tailwind Config's `extend` to define project-specific colors, fonts, and shadows as tokens. Hardcoding HEX values (e.g., `#F00`) is prohibited.
*   **CSS Architecture**:
    *   **Utility First**: Use Tailwind Utility classes in principle.
    *   **Component Extraction**: Encapsulate common patterns (Buttons, Cards) as React components and avoid `@apply` as much as possible (Recommended by Tailwind team).
    *   **CSS Modules**: Allow CSS Modules (or `styled-jsx`) only for complex animations or styles difficult to express with Tailwind.
    *   **The CSS Specificity Protocol (!important Ban)**:
        *   **Prohibition**: Forcing style overwrites with `!important` triggers CSS specificity wars—"black magic" and engineer's shame. Using `!important` for functional show/hide or layout adjustments is **completely prohibited**.
        *   **React Way**: When styles don't work, resolve root causes (DOM structure, class conflicts) or control via React state management.
    *   **The Gold Standard UI Mandate (Universal Placement)**:
        *   **Law**: Ad-hoc CSS adjustments per page (temporary `margin`/`padding` tweaks) are prohibited.
        *   **Mandate**: All UI components must be defined as "standardized variants" including placement context. Elites don't create "only this place on this page" exceptions.
    *   **The Anchor Tag Nesting Prohibition Protocol (Invalid Nesting)**:
        *   **Law**: Nesting `<a>` or `<Link>` inside another `<a>` or `<Link>` is prohibited (HTML spec violation). Physically causes Next.js Hydration Errors.
        *   **Action**: For full-card links, use `div` as parent with `position: relative` and `::before` pseudo-element (`inset-0`), or functionally separate links.
    *   **The CSS Containment Protocol (Whitespace Glitch)**:
        *   **Context**: Nested containers with `overflow-y-auto` or dynamic height elements like accordions cause "infinite whitespace" or "layout collapse" from scrollbar recalculation.
        *   **Action**: Apply `contain: layout` (Tailwind: `contain-layout` plugin recommended or `style={{ contain: 'layout' }}`) to scroll containers to isolate layout calculation scope.
    *   **Baseline Alignment**: When horizontally aligning labeled inputs and buttons in filter UIs etc., always use `items-end` to align bottom (Baseline). `items-center` causes misalignment.
    *   **The Natural Scrolling Protocol**:
        *   **Context**: "Nested scroll" structures with `h-dvh` + `overflow-y-auto` conflict with browser scroll calculations and cause infinite whitespace glitches.
        *   **Action**: Unless special reasons exist, don't create custom scroll areas; always use `min-h-dvh` and delegate to browser's native **Window Scroll**. Sidebars follow with `sticky`.
*   **Performance Budget (SLA)**:
    *   **Core Web Vitals**: **LCP < 2.5s**, **INP < 200ms**, **CLS < 0.1**. These are "Deployment Requirements", not just goals.
    *   **Bundle Size**: Keep Initial JS size under **150KB (Gzipped)**. Use `next/dynamic` if exceeded.
    *   **The Dynamic Import Mandate (Payload Optimization)**:
        *   **Law**: Libraries exceeding **30KB** Gzip compressed (Charts, Editors, Maps, 3D, PDF Viewer, etc.) are prohibited from main bundle inclusion.
        *   **Action**: MUST use `next/dynamic` or `React.lazy` for component-level Code Splitting, designing not to load until user accesses that feature.
        *   **UX**: Show skeleton (`loading` prop) during load to prevent CLS (Layout Shift).
*   **The Canonical Identity Protocol (SEO Duplicate Protection)**:
    *   **Context**: For pages exposed to search engines (Public Pages).
    *   **Law**: MUST define `alternates: { canonical: url }` in Next.js `generateMetadata` to prevent rating dispersion from parameter differences. Not needed for authenticated admin pages.
*   **The Performance First Protocol (LCP & Lazy Loading Mandate)**:
    *   **Law 1 (First View Optimization)**: Critical elements in viewport (hero images, etc.) MUST have `priority` (Next.js) and `fetchPriority="high"`.
    *   **Law 2 (Lazy Load Everything Else)**: ALL images, videos, heavy components outside first view MUST use `loading="lazy"` or `next/dynamic` lazy loading without exception to save initial resources.
    *   **Law 3 (Layout Shift Zero)**: Mandate fixed aspect ratio or skeleton area reservation to make loading layout shift (CLS) "0".
    *   **Law 4 (Incremental Loading Mandate)**: Initial loading of large lists (reviews, products, photo galleries, etc.) is limited to **10-12 items per page** max to reduce server load and client packet consumption.
    *   **Action**: 13th item onward MUST be provided via "Load More" button or scroll-triggered "Infinite Scroll". "Fetch entire list" is a "bomb" that paralyzes the system as data grows—immediately Rejected as UX defect.

### 2.1. The Component-DTO Interface Protocol (Interface First)
*   **Law**: UI components (especially shared Widgets) MUST NOT use raw database types (`Row`) in Props definition. This tightly couples backend schema with UI and kills reusability.
*   **Action**: MUST depend on **DTO Interfaces** like `StoreDTO` or `ArticleDTO`, hiding implementation details (array indices, etc.) inside components.
    *   **The Async-UI Boundary Protocol (Client/Server Separation)**:
        *   **Law**: UI components (especially Client Components) MUST NOT directly import Async Server Components that perform data fetching. This causes build errors, mysterious runtime crashes, and serialization errors.
        *   **Action**: Components with data logic like `JsonLd` or `Analytics` MUST be rendered at the top level of `layout.tsx` or `page.tsx` (Server Context) and physically separated from UI using `children` pattern.

### 2.2. The Clean Import & Export Protocol
*   **The Barrel Export Prohibition (Performance Guard)**:
    *   **Law**: Bulk re-export via directory-level `index.ts` (Barrel file) is prohibited.
    *   **Reason**: Significantly slows down build speed in dev environment (Next.js Dev) and triggers unintended transpile load (loading all components). Imports MUST be made directly from physical files/paths.
*   **The Dead Code Execution Protocol**:
    *   **Law**: Do not place heavy imports, external module function executions, or DOM side effects (useEffect, etc.) "after" conditional branches or early returns.
    *   **Action**: Logic completely unnecessary depending on conditions should be separated by Next.js `dynamic()` or `Suspense` boundaries, or definitions placed outside (Top-Level) so they are "physically" not executed in the codebase.

*   **The Semicolon Guard (ASI Safety)**:
    *   **Law**: When the next line starts with a parenthesis (`(` or `[`) after a side-effect execution line, you MUST explicitly add a semicolon `;`. Physically prevent "stealth bugs" caused by ASI (Automatic Semicolon Insertion) failure.
    *   **Action**: Enable ESLint's `no-unexpected-multiline` rule and auto-detect in CI.

*   **The Component Colocation Protocol (Maintaining Proper Granularity)**:
    *   **Law**: "Sub-components," "type definitions," and "constants" used only by a specific component should be written in the **same file (Co-location)** as a principle. Excessive file splitting increases cognitive load.
    *   **Split Threshold**: Splitting sub-components into separate files is permitted only when the file exceeds **300 lines**. When splitting, create a directory and group related files together.

### 2.3. Headless UI Architecture (Web Only Prohibition)
*   **Rule**: UI components must focus only on "Displaying Data" and "Firing Events". Business logic is prohibited (Dumb UI).
*   **Prohibition**: Fetching within components or state management dependent on specific page DOM structure (Web Only Design) is strictly prohibited as it hinders future Native porting.

### 2.4. Interactive Components Standard
*   **Rich Selection Protocol**:
    *   Conventional Radio/Checkbox are prohibited in principle. Adopt **"Rich Card-type UI that is intuitively clickable"** as standard.
*   **Responsive Combobox Protocol**:
    *   **Desktop**: Use `Popover` (modal=true).
    *   **Mobile**: Use **Drawer (Vaul)**.
    *   **Mobile Click/Tap Fix**: Add `data-vaul-no-drag` attribute to scrollable areas in `vaul` (Drawer) to prevent unintended closing by swipe.
    *   **Breadcrumb Priority Lesson (Stack Layout)**: Placing breadcrumbs and action buttons horizontally on mobile headers pushes breadcrumbs off-screen. Recommend strict vertical **Stack (flex-col)** layout.
    *   **Interaction**: Force `pointer-events-auto` on `CommandItem` and bind `onClick`/`onPointerUp` to prevent tap failure.
    *   **Stable IDs**: `value` of `CommandItem` MUST be unique, coherent **ASCII string** (IDs). Using Japanese for `value` breaks selection logic. Use `keywords` for Japanese search.

### 2.5. The Z-Index Stratification Protocol (Menu Dominance)
*   **Law**: Prevent Z-Index "Magic Numbers" and guarantee UI stacking order.
*   **Definition**:
    *   **Overlay (10000)**: `Select`, `Popover`, `Tooltip`, `Calendar`. Must be topmost.
    *   **Modal (9999)**: `Dialog`, `Sheet`. Below Overlays.
    *   **Menu (1000)**: Drawer menus, Navigation.
    *   **Header (50)**: Fixed header.
    *   **Floaters (40)**: Floating buttons (Chat). NEVER place above menus.

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

### 2.7. The React Hooks Order Guarantee Protocol (Hooks First)
*   **Law**: Hooks (useState, usePathname, etc.) call order must be invariant between renders.
*   **Prohibition**: Placing early returns (`if (!data) return null`) or conditionals BEFORE Hooks calls (at top) when they should be AFTER Hooks is prohibited. Also, placing conditional returns (Early Return) AFTER Hooks calls is prohibited—this causes subsequent Hooks call count to vary between renders, triggering "Rendered more hooks..." errors.
*   **Suspense Mandate (useSearchParams)**:
    *   Components using `useSearchParams()` MUST be wrapped in `<Suspense>` boundary to prevent build-time static analysis errors.
    *   **The Error Boundary Protocol (No White Screen)**:
        *   **Law**: "White Screen of Death" from React runtime errors is not permitted.
        *   **Action**: Use `react-error-boundary` to set error boundaries at root (`layout.tsx`) and major feature sections, always displaying "Error UI with retry button".
*   **Correct Structure (The Hooks First Protocol)**:
    *   **Law**: Placing conditional returns (Early Return) AFTER Hooks calls is **guilty** as it causes Hooks count variation on next render, destroying React consistency—completely prohibited. This is a **"Technical Felony"** making debugging extremely difficult.
    *   **Mandatory Order (Google Antigravity Standard)**:
        1.  **ALL HOOKS FIRST**: Aggregate ALL Hooks (useState, usePathname, etc.) at component top.
        2.  **DERIVED STATE**: Place variable calculations and state judgments after Hooks.
        3.  **CONDITIONAL RETURNS**: Place Early Returns (error handling, loading) AFTER derived state.

### 2.7.1. The Static Component Persistence Protocol (Module Scope Mandate)
*   **Law**: Defining components inside another component's render function is prohibited. Each re-render creates a new component type, causing React to discard the DOM tree — resulting in **input focus loss**, **state resets**, and catastrophic performance degradation.
*   **Action**: Sub-components and wrapper components MUST be defined at **Module Scope (file top-level)**. When values need to be passed, use explicit Props.
*   **Anti-Pattern**: `const MyComponent = () => { const SubComponent = () => <div />; return <SubComponent />; }` — This is a **Technical Felony**.

### 2.7.2. The Route Conflict Ban (Zero Duplicate Route)
*   **Law**: When refactoring pages (directory moves), the **source directory MUST be physically deleted**. Stale `page.tsx` files cause the framework (Next.js, etc.) to detect route conflicts, resulting in **build errors**.
*   **Action**: After file moves, verify no stale files remain using `find` or `git status`.

### 2.8. The Hydration Stability Protocol (Zero Mismatch)
*   **Law 1 (Dynamic Content)**: Directly embedding dynamic values like `new Date()` or `Math.random()` in JSX is prohibited. These cause SSR/CSR value mismatch, triggering Hydration Errors.
*   **Law 2 (Identifier Match)**: `id` and `htmlFor` MUST have unique and immutable values, or use React's `useId` to physically guarantee matching.
*   **Law 3 (Extension Defense)**: Add `suppressHydrationWarning` to `<html>` and `<body>` to prevent mismatches from browser extension (Grammarly, Password Managers, etc.) attribute injection. **However, using this attribute to hide developer's own logic bugs is strictly prohibited.**
*   **Law 4 (Date Formatting)**: Date display must be formatted client-side (in `useEffect`) or passed as server-side determined string (UTC, etc.).

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

## 6. Performance & SEO - "Core Web Vitals"
*   **Script Optimization**:
    *   **External Scripts**: Load affiliate tags and analytics scripts using `next/script` with `strategy="lazyOnload"` or `afterInteractive`. Do NOT block the main thread.
    *   **SPA Support**: For scripts that require re-firing on page transition (Client-side Navigation) like link replacement, properly implement re-initialization using `useEffect` or `usePathname` hooks.
    *   **Memory Leak**: Ensure memory leak countermeasures, such as removing old event listeners during script re-initialization.
*   **Image Optimization**:
    *   Always use `next/image` component to auto-deliver optimal image size and format (AVIF/WebP) according to device size.
    *   **Loader Mandate**: Must apply `cloudflare-loader.ts` (or `loader` prop) to utilize **Cloudflare Transformations**. Using Vercel Default Optimizer (Bandwidth waste) is strictly prohibited.
    *   **CLS Prevention**: Always specify `width` and `height` (or `fill`) for images to prevent layout shift.
*   **Font Optimization**:
    *   Self-host Google Fonts using `next/font` to eliminate layout shift (CLS) and external requests.
*   **Metadata Management**:
    *   **Dynamic Metadata**: Page titles must follow `[Page Name] | [Site Name]` format and fetch values dynamically from Site Settings (DB). Hardcoding is prohibited.
    *   **Image Fallback**: Implement logic to use default images in `public/assets` as fallback when OGP or content images do not exist in DB, preventing image breakage (404).
    *   **The Data Seeding & Caching Protocol (Cache Key Versioning)**:
        *   **Law**: Fixing cache keys like `unstable_cache` to immutable names (e.g., `master_data`) is prohibited.
        *   **Action**: When DB data drastically changes or specs change, append version suffix (e.g., `_v2`, `_20260123`) to cache key to physically secure new cache space. Residue of old cache causing "display inconsistency" is considered a bug.
    *   **The Public Cache Mandate (FinOps Protocol)**:
        *   **Law 1 (Unstable Cache Wrapping)**: Public Read actions (Top page, Store list, Navigation fetch, etc.) MUST be wrapped with `unstable_cache` (Next.js Data Cache) to keep DB load constant.
        *   **Law 2 (Tag Revalidation)**: Use `revalidateTag` on data update to realize On-Demand Revalidation. Prioritize `revalidateTag` (Resource unit) over `revalidatePath` (Page unit).
    *   **Structured Data (JSON-LD)**: Emphasize Machine-Readability. Mandatory implementation of structured data like `LocalBusiness` (Store), `Article` (Post), `BreadcrumbList`. Increase citation rate from AI (Perplexity/SGE).
        *   **The JSON-LD Precision Protocol (Sitelink Strategy)**:
            *   **Law**: For Top page, implement composite schema including not just `WebSite`, but `Organization` (Logo, Rep) and `SearchAction` (Site Search).
            *   **Goal**: Ensure Knowledge Panel display and Sitelink hierarchization in Google search results.
        *   **The Type-Safe Schema Protocol (Type Safety)**:
            *   **Law**: Building JSON-LD with string concatenation or raw objects is prohibited.
            *   **Action**: Use libraries like `schema-dts` to build as Type-Safe objects complying with Schema.org specs. Detect missing mandatory properties at build time.
    *   **The Code Input Standard (Rule 14.12)**:
        *   **Law**: Using raw `textarea` where HTML/CSS/JSON code editing is needed is strictly prohibited as it causes errors without syntax highlight and significantly damages quality.
        *   **Action**: MUST use editor components like `react-simple-code-editor` (+ `prismjs`) to provide professional quality.
    *   **Microcopy Identity**: Error messages and label wording should be written with "Omotenashi heart" explicitizing next action without blaming the user.
    *   **Technical SEO**:
        *   **SSR**: `<h1>`, metadata, and main content must be Server-Side Rendered.
        *   **Single H1**: One `<h1>` per page. H1 represents the "Subject" of the page, not the logo.
        *   **The Semantic HTML Landmark Protocol**:
            *   **Law**: AI crawlers parse HTML structure. Use landmark elements such as `<article>`, `<section>`, `<header>`, `<nav>`, `<aside>` appropriately — not just `<div>` — to clarify semantic boundaries of content.
            *   **Action**: Strictly maintain heading tag (`<h1>`–`<h6>`) hierarchy. Placing `<h2>` after `<h3>` for design reasons — **hierarchy violations are prohibited**.
        *   **IndexNow**: Notify search engines immediately via **IndexNow API** upon content updates.
    *   **Ghost Content Protocol (Time-Gated SEO)**:
        *   **Law**: Scheduled content (`published_at > NOW()`) MUST behave as "non-existent" to search engines.
        *   **404 Mock**: Return the same UI and status code as a normal 404 for general user access, preventing existence inference.
        *   **NoIndex**: Force-inject `<meta name="robots" content="noindex, nofollow" />` on unpublished pages.
*   **Marketing Engineering**:
    *   **Dynamic Assets**: Use `@vercel/og` to generate OGP images on demand and cache via Cloudflare CDN (`s-maxage=86400`).
    *   **Tracking Infrastructure**:
        *   **CAPI**: Send critical conversions (Purchase etc.) via **Server-Side Conversion API** in addition to Pixel (Cookie-less measure).
        *   **First-Party Data**: Save initial entry parameters (`utm_source` etc.) in Session and record upon user registration (First Touch attribution).
    *   **Privacy-First**: Comply with **Consent Mode v2** and implement mechanism to block tracking Cookies for non-consenting users.

## 7. Component Design & A11y
*   **Accessibility - "Shift Left"**:
    *   **Automated Testing**: Run `axe-core` in CI to automatically detect and block low contrast or missing labels.
    *   **Screen Reader**: Validating main flows with screen readers (VoiceOver/TalkBack) on actual devices is mandatory.
    *   **Icon Labels**: Icon-only buttons containing no text must have an `aria-label` attribute to explicitly state their function.
    *   **WAI-ARIA**: "No ARIA is better than Bad ARIA". Use native HTML elements as much as possible and keep ARIA attributes to a minimum.
    *   **Radix UI / Headless UI**: Use accessible headless UI libraries for complex components.
*   **Atomic Design**:
    *   Design components considering reusability, but avoid excessive abstraction.

## 8. Data Visualization & Export
*   **Charts**:
    *   **Library**: Recommend `Recharts` or `Chart.js`.
    *   **UX**: Implement interactive graphs supporting tooltips on hover, zoom, and pan, not static images.
*   **Export**:
    *   **Web Workers**: Execute PDF/CSV generation within Web Workers so as not to block the main thread.
    *   **Library Selection**:
        *   **PDF**: Recommend `@react-pdf/renderer` for client-side generation. For complex reports, generate on the server-side (Puppeteer/Playwright).
        *   **CSV**: Use `papaparse` or similar to guarantee RFC 4180 compliant format.
    *   **Compatibility**: Output CSV with **BOM-prefixed UTF-8** to prevent garbled text in Excel. Always embed **Localized fonts** (e.g., Noto Sans CJK) in PDFs.

## 9. User Guidance Implementation
*   **Onboarding Tours**:
    *   **Library**: Use lightweight and accessible libraries like `driver.js` to guarantee Focus Trap and keyboard operation.
    *   **React Portals**: Render guide elements at the top of the DOM tree using `createPortal` to avoid `z-index` wars (Stacking Context issues).

## 10. Deployment & Infrastructure
*   **Vercel**:
    *   **Vercel** is the first choice for deployment.
    *   **Preview Environment**: Automatically generate preview environments per Pull Request to facilitate design review and operation verification.
*   **ISR (Incremental Static Regeneration)**:
    *   Use ISR for static content (blog posts, help pages) to achieve both short build times and always-fresh content display.
## 11. AdTech Engineering (For Monetization)
*   **Ads Platform Strategy**:
    *   **Ads.txt & Sellers.json**: Dynamically serve authorized seller info to prevent domain spoofing (Ad Fraud) and ensure supply chain transparency.
    *   **Ad Labeling**: Automatically append "PR" or "Sponsored" labels to ad slots and sponsored content in a recognizable position. Stealth marketing without labels is blocked at the system level.
*   **Performance (Core Web Vitals)**:
    *   **Zero CLS (Layout Shift Guard)**: Reduce Layout Shift caused by ad banners to **0**. Always reserve display area using `min-height` or `aspect-ratio` in CSS (Ban on Late Loading Push).
*   **The Ad Category Exclusion Protocol (Prohibited Ad Categories)**:
    *   **Context**: Ads inappropriate for the service's brand image damage LTV and erode user trust.
    *   **Law**: **Prohibit at the system level** ad categories inappropriate for the service's brand, such as gambling, adult content, violence, and political advertising.
    *   **Action**:
        1.  **External Ads (Google AdSense, etc.)**: Apply category block settings in the ad platform's management console and periodically audit the configuration.
        2.  **Self-Served Ads**: Mandate category classification during ad submission and reject ads matching prohibited categories via validation.

## 12. Prohibited Anti-Patterns

### 12.0. The Lazy Redirect Anti-Pattern (UX Failure)
*   **Law**: Forcing a redirect via `redirect()` after completion or error without user feedback (Toast/Notification) is "Irresponsible Neglect" in UX and is prohibited.
*   **Action**: User has the right to know "What happened". Use redirect only when "Resource location changed", and always combine with Toast or Flash Message for status notification.

### 12.1. The Client DB Access Prohibition (Proxy Action Mandate)
*   **Ref**: Refer to `30_engineering_general.md` Rule 13.2 for details on banning direct DB access from client side. Strict adherence required.
*   **Law**: Directly calling `supabase.from()` in Client Components invites RLS vulnerabilities and bloating of raw data without DTO (Mapper), thus prohibited.
*   **Action**: Queries MUST use "Proxy Pattern" via Server Action (`src/lib/actions`) and return only minimal normalized data (DTO) to the client.

### 12.2. The Anchor Tag Nesting Prohibition (HTML Violation)
*   **Law**: Nesting `<a>` tags (including `Link` component) inside another `<a>` tag is an HTML spec violation that causes browser DOM auto-separation and Next.js Hydration Mismatch.
*   **Prohibition**: "It works visually" is not an excuse. Browsers automatically push nested `<a>` outside, causing physical mismatch between Server and Client DOM.
*   **Action**: To make a whole card clickable:
    1.  **Overlay Pattern**: Make card `relative`, expand main link via `::before` pseudo-element to `absolute inset-0`, and bring sub-links to front with `relative z-10`.
    2.  **Separate Pattern**: Link only the title or image, physically avoiding nesting.

### 12.3. The Server-Side DOM Prohibition (No jsdom)
*   **Law**: Accessing browser-specific objects like `document` or `window` in Server Component (Node.js/Edge) environment is a **Highest Level Prohibition**. Introducing polyfills like `jsdom` implies defeat of server-side design.
*   **Action**: For HTML parsing/sanitizing on server side, use lightweight `xss` library or `cheerio`. Usage of "Browser Dependent Wrappers" like `isomorphic-dompurify` is also prohibited in principle due to unclear side effects.

### 12.5. The Recursive Rendering Ban (Depth Safety)
*   **Law**: "Self-recursive rendering" within component trees with unclear termination conditions (Base Case) is prohibited.
*   **Action**: If recursive structure like comment tree is needed, MUST define **`maxDepth`** as Prop, and switch to "Load More" button or flat display if exceeded.

### 12.6. The Double Scrollbar Prohibition (UX Integrity)
*   **Law**: Unplanned nesting of `h-screen` and `overflow-y-auto` causing double scrollbars on screen is a UX defeat.
*   **Action**: Scroll container should ideally be **only one** (usually `body` or main layout) on screen. If partial scroll is needed, MUST consider `dvh` (Dynamic Viewport Height) and verify behavior on Mobile Safari.

### 12.7. The Metadata Obligation (Page Title Protocol)
*   **Law**: Page title becoming "undefined" or site name only is a quality defect damaging user trust.
*   **Action**: In all `page.tsx`, MUST define `export const metadata: Metadata`. Include visual check of browser tab title in pre-build self-check.

## 13.0. The Security & Performance Boundary
*   **The Next.js 15 Async API Protocol**:
    *   **Law**: From Next.js 15, `params`, `searchParams`, `headers`, `cookies`, `draftMode` are Awaitable (Promise).
    *   **Action**: When referencing these, MUST `await` or use React's `use()` hook. Neglecting async processing causes "Value Missing" or "Infinite Rendering" only in production.
*   **The Frictionless Security UI Protocol (Design Handshake)**:
    *   **Law**: Security features (Turnstile/OTP) MUST be implemented only in a way that does not hinder user's "Goal Achievement".
    *   **Action**:
        *   **Draft Save Exemption**: Do not require Turnstile or OTP for "Routine Operations" like draft saving (See `60_security_privacy.md` Rule 8.6).
        *   **Physical Lock UI**: During security check (Turnstile spinning), set submit button to `loading` instead of `disabled` to indicate progress.
*   **CSP Worker Integrity (blob: permission)**:
    *   **Context**: `heic2any` or high-performance image compression libraries generate internal `Web Worker` and use `blob:` URL. This will hang if blocked.
    *   **Action**: MUST explicitly include `worker-src 'self' blob:;` in Middleware CSP settings to guarantee availability of image processing processes.

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

### 14.8. The Validation Error Transparency Mandate
*   **Law**: Form submit handlers (`handleSubmit`, etc.) MUST include **not only success callbacks, but also validation failure callbacks (`onInvalid`)**. The majority of "button does nothing when pressed" cases are caused by silent validation failures.
*   **Action**:
    1.  **Always Provide onInvalid**: Log error contents (`console.error` / `Logger.warn`) on validation failure, and display toast notifications to the user when possible.
    2.  **Flexible JSONB Schemas**: Validation schemas for dynamically extended JSONB fields (`features`, `settings`, etc.) should not be overly strict and must stay in sync with the actual UI structure at all times.
    3.  **Debug Visibility**: In development environments, inline display of validation error details (field names, error messages) on screen is recommended.
*   **Rationale**: Form library `handleSubmit` silently skips the `onSubmit` handler when validation errors exist. Without `onInvalid` configured, error details are not communicated to either developers or users, leading to the misconception that "the button is broken."
*   **Anti-Pattern**: `form.handleSubmit(onSubmit)` — Since `onInvalid` is omitted, validation failures are silently ignored.

### 14.9. The SSR Stream Resilience Protocol
*   **Law**: When data fetching fails during Server-Side Rendering (SSR/RSC) streaming, the browser displays generic network errors (404, connection reset, etc.), completely concealing the root cause. Always provide defensive guards for data access within streaming components.
*   **Action**:
    1.  **Strict Null Guards**: After data fetching, always place guards like `if (!data) return notFound()` before accessing properties. Property access on `null` crashes the entire RSC stream.
    2.  **Server Terminal as Primary Source**: When debugging SSR streaming errors, use **server terminal output as the primary diagnostic source** instead of the browser console. Browser-side errors are intentionally sanitized and lack specificity.
    3.  **Gateway Instrumentation**: In data access layer (Gateway) `catch` blocks, explicitly extract and log `code` and `message` from error objects. Outputting `[object Object]` as-is is prohibited.
*   **Rationale**: SSR streaming crashes during HTML generation on the server, so unlike traditional SSR, only a generic "stream was interrupted" error reaches the browser. This makes identifying root causes (missing data, insufficient permissions, schema mismatches, etc.) extremely difficult.

### 14.10. The Non-Blocking Edge Middleware Protocol
*   **Law**: In Edge Middleware (or request pre-processing layers), **non-critical DB writes** such as analytics logging, usage metering, and access statistics updates MUST be made asynchronous using `event.waitUntil()`. Blocking with `await` causes response delay for all requests.
*   **Action**:
    1.  **Classification**: Classify DB operations within Middleware into "Critical (auth checks, etc.)" and "Non-Critical (log recording, etc.)."
    2.  **waitUntil for Non-Critical**: Execute Non-Critical operations in the background via `event.waitUntil(promise)` and return the response immediately.
    3.  **Error Isolation**: Provide independent error handling with `try-catch` within `waitUntil` to ensure failures don't affect the main response.
*   **Rationale**: Edge Middleware sits on the hot path of all requests, so delays here directly impact overall application performance. Asynchronization prevents log recording failures from blocking user page rendering.

### 14.11. The DnD Overlay Input Isolation Protocol
*   **Law**: Form input elements such as `<input>`, `<select>`, and `<textarea>` MUST NOT be rendered as-is within DragOverlay (the ghost element displayed during drag) of Drag & Drop (DnD) libraries.
*   **Action**:
    1.  **Render-Only Overlay**: Components within DragOverlay MUST be limited to **display-only** views (text display, icons, etc.).
    2.  **Name Collision Prevention**: When form input elements are cloned into the Overlay, `<input>` elements with identical `name` attributes become duplicated in the DOM, destroying form library data integrity.
    3.  **Conditional Rendering**: In the DragOverlay rendering path, use flags (`isOverlay` props, etc.) to suppress form element rendering.
*   **Rationale**: DnD DragOverlay adds a "visual copy" of the dragged item to the DOM. When this copy contains form elements, form libraries (React Hook Form, etc.) encounter two input fields with the same name in the DOM, causing duplicate value registration and validation malfunctions.

### 14.12. The Form DefaultValues Completeness Mandate
*   **Law**: When using form libraries such as React Hook Form, `defaultValues` must explicitly set **all fields** the form uses. When adding or modifying fields, **simultaneous three-point updates of Schema (validation definition) + defaultValues (initial values) + Controller/Input (UI rendering)** are mandatory.
*   **Action**:
    1.  **Exhaustive DefaultValues**: Enumerate all field initial values in `useForm({ defaultValues: { ... } })`. Omitted fields become `undefined`, causing unexpected behavior in Controlled Components.
    2.  **Three-Point Sync**: When adding a field, update the following three locations simultaneously:
        *   **Schema**: Zod / Yup validation schema
        *   **DefaultValues**: The `defaultValues` object of `useForm`
        *   **UI**: Form input components via `Controller` / `register`
    3.  **Type-Safe DefaultValues**: The type of `defaultValues` must match the type auto-inferred from the Schema (e.g., `z.infer<typeof schema>`). Defining types manually to create divergence is prohibited.
*   **Rationale**: Incomplete `defaultValues` is the leading cause of silent bugs where "the form looks normal when opened, but specific fields don't save." Enforcing three-point synchronization structurally prevents this class of bugs.

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

