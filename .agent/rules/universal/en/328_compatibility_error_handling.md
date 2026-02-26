# 33. Web Frontend Engineering - Next.js

### 14.8. The Validation Error Transparency Mandate
*   **Law**: Form submit handlers (`handleSubmit`, etc.) MUST include **not only success callbacks, but also validation failure callbacks (`onInvalid`)**. The majority of "button does nothing when pressed" cases are caused by silent validation failures.
*   **Action**:
    1.  **Always Provide onInvalid**: Log error contents (`console.error` / `Logger.warn`) on validation failure, and display toast notifications to the user when possible.
    2.  **Flexible JSONB Schemas**: Validation schemas for dynamically extended JSONB fields (`features`, `settings`, etc.) should not be overly strict and must stay in sync with the actual UI structure at all times.
    3.  **Debug Visibility**: In development environments, inline display of validation error details (field names, error messages) on screen is recommended.
*   **Rationale**: Form library `handleSubmit` silently skips the `onSubmit` handler when validation errors exist. Without `onInvalid` configured, error details are not communicated to either developers or users, leading to the misconception that "the button is broken."
*   **Anti-Pattern**: `form.handleSubmit(onSubmit)` — Since `onInvalid` is omitted, validation failures are silently ignored.

# 33. Web Frontend Engineering - Next.js

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

# 33. Web Frontend Engineering - Next.js

## 12. Prohibited Anti-Patterns
