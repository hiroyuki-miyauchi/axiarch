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

### 2.8. The Hydration Stability Protocol (Zero Mismatch)
*   **Law 1 (Dynamic Content)**: Directly embedding dynamic values like `new Date()` or `Math.random()` in JSX is prohibited. These cause SSR/CSR value mismatch, triggering Hydration Errors.
*   **Law 2 (Identifier Match)**: `id` and `htmlFor` MUST have unique and immutable values, or use React's `useId` to physically guarantee matching.
*   **Law 3 (Extension Defense)**: Add `suppressHydrationWarning` to `<html>` and `<body>` to prevent mismatches from browser extension (Grammarly, Password Managers, etc.) attribute injection. **However, using this attribute to hide developer's own logic bugs is strictly prohibited.**
*   **Law 4 (Date Formatting)**: Date display must be formatted client-side (in `useEffect`) or passed as server-side determined string (UTC, etc.).

## 3. Forms & Validation
*   **Library Selection**:
    *   **React Hook Form**: Base on uncontrolled components to minimize re-renders.
    *   **Zod**: Practice Schema-Driven Development. Separate validation logic from UI and define it as Zod schemas.
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
        *   **Law**: When user inputs full-width numbers (１２３) or full-width spaces, do NOT reject with validation error, but **auto-convert to half-width (Normalize) on `onChange` or `onBlur`** and accept it.
        *   **Implementation**: Use `String.normalize('NFKC')` to adopt "Omotenashi" design that doesn't stress users.

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

## 5. Compatibility & Error Handling
*   **Browser Compatibility**:
    *   **Target**: Support latest 2 versions of Chrome, Safari, Firefox, Edge, and latest 2 versions of iOS Safari, Android Chrome.
    *   **Polyfill**: Use `core-js` etc. to polyfill only necessary features.
*   **Error Handling**:
    *   **Error Boundaries**: Use React's `ErrorBoundary` to prevent component-level crashes from taking down the entire app.
    *   **Graceful Degradation**: Design so minimal content is displayed even if JavaScript is disabled or errors occur.
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
        *   **IndexNow**: Notify search engines immediately via **IndexNow API** upon content updates.
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
