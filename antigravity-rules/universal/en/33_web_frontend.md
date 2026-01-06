# 33. Web Frontend Engineering - Next.js

## 1. Modern Web Architecture
*   **Next.js & React Server Components (RSC)**:
    *   **Default**: Use **App Router** in principle and render with Server Components (RSC) as much as possible. This dramatically reduces the amount of JavaScript sent to the client.
    *   **Data Fetching**: Fetch data on the server side to avoid waterfall issues.
*   **Edge Computing**:
    *   **Middleware**: Execute auth checks and geolocation redirects in **Edge Middleware** to minimize latency.
*   **Directory Ontology**:
    *   **src/app**: Routing definitions only. No logic.
    *   **src/lib/actions**: Server Actions (The Gateway for data).
    *   **src/components**: UI parts. Separate `ui` (Generic) and `features` (Specific).
*   **Site Settings Architecture**:
    *   **Runtime Injection**: Settings like theme colors must be fetched from DB at runtime (RootLayout) and injected as CSS variables, not at build time. This allows design changes without rebuilds.
*   **Global Expansion Protocol**:
    *   **Sub-Directory Strategy**: Use unique URLs per language (`/en/stores/tokyo`). Language switching via query parameters or Cookies is prohibited for SEO reasons.
    *   **Universal Time**: Store in UTC in DB and convert to local time based on user's browser locale at display time. Hardcoding Server-side (JST/PST) time is prohibited.

## 2. UI Components & Styling
*   **shadcn/ui + Tailwind CSS**:
    *   **Standard Stack**: Adopt **shadcn/ui** as the standard UI component library for balancing customizability and accessibility.
    *   **Design System**: Use Tailwind Config's `extend` to define project-specific colors, fonts, and shadows as tokens. Hardcoding HEX values (e.g., `#F00`) is prohibited.
*   **CSS Architecture**:
    *   **Utility First**: Use Tailwind Utility classes in principle.
    *   **Component Extraction**: Encapsulate common patterns (Buttons, Cards) as React components and avoid `@apply` as much as possible (Recommended by Tailwind team).
    *   **CSS Modules**: Allow CSS Modules (or `styled-jsx`) only for complex animations or styles difficult to express with Tailwind.
*   **Performance Budget (SLA)**:
    *   **Core Web Vitals**: **LCP < 2.5s**, **INP < 200ms**, **CLS < 0.1**. These are "Deployment Requirements", not just goals.
    *   **Bundle Size**: Keep Initial JS size under **150KB (Gzipped)**. Use `next/dynamic` if exceeded.

### 2.1. Headless UI Architecture (Web Only Prohibition)
*   **Rule**: UI components must focus only on "Displaying Data" and "Firing Events". Business logic is prohibited (Dumb UI).
*   **Prohibition**: Fetching within components or state management dependent on specific page DOM structure (Web Only Design) is strictly prohibited as it hinders future Native porting.

### 2.2. Interactive Components Standard
*   **Rich Selection Protocol**:
    *   Conventional Radio/Checkbox are prohibited in principle. Adopt **"Rich Card-type UI that is intuitively clickable"** as standard.
*   **Responsive Combobox Protocol**:
    *   **Desktop**: Use `Popover` (modal=true). Add `z-[9999]` if overlapping content.
    *   **Mobile**: Use **Drawer (Vaul)** instead of Popover to enhance touch usability.
    *   **Interaction**: Force `pointer-events-auto` on `CommandItem` and bind `onClick`/`onPointerUp` to prevent tap failure.
*   **Class Sorting**: Introduce `prettier-plugin-tailwindcss` to automatically and forcibly unify the order of class names.

## 3. Forms & Validation
*   **Library Selection**:
    *   **React Hook Form**: Base on uncontrolled components to minimize re-renders.
    *   **Zod**: Practice Schema-Driven Development. Separate validation logic from UI and define it as Zod schemas.
*   **Validation**:
    *   **Client-Side**: Provide real-time feedback for required fields, character counts, and email formats before server submission.
    *   **Media Interaction (Crop UI)**: Server-side auto-cropping (Center Crop) is prohibited for uploads. Must provide a UI (e.g., `react-easy-crop`) allowing users to decide the crop area themselves.
    *   **Filename Sanitization**: To prevent issues, convert **Multibyte** filenames (e.g., Japanese) to Romaji/ASCII on the client side before upload.
    *   **Type Safety**: Infer TypeScript types from Zod (`z.infer`) to eradicate type mismatches between form data and API requests.

### 3.3. Auto-Save & Data Persistence Protocol
*   **Mandatory Scope**: **Auto-Save** functionality is mandatory for articles, settings, and long-text forms in the Admin Panel (Data Loss Zero Tolerance).
*   **Implementation Standard**:
    *   **Hook Strategy**: Use a standardized `useAutoSave` hook to save to Local Storage after a delay (e.g., 2000ms) from input cessation.
    *   **Passive Restoration**: Do not automatically restore drafts on page load. Instead, display a **"Draft Found" notification (Banner)** and let the user choose.
    *   **Hygiene**: Upon successful submission, strictly clear the Local Storage (`clearDraft`) to prevent old data persistence.

## 4. PWA & Cross-Platform
*   **PWA (Progressive Web App)**:
    *   **Installable**: Configure `manifest.json` properly to enable adding to Home Screen.
    *   **Offline Support**: Design using Service Worker so key features (viewed content, etc.) work even offline.
*   **Deep Linking**:
    *   **Smart App Banners**: Implement banners that open the native app if installed, or guide to the store if not, when viewed on mobile browsers.

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
*   **SEO & GEO Strategy (Search & Generative)**:
    *   **Structured Data (JSON-LD)**: Emphasize Machine-Readability. Mandatory implementation of structured data like `LocalBusiness` (Store), `Article` (Post), `BreadcrumbList`. Increase citation rate from AI (Perplexity/SGE).
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
