# 33. Web Frontend Engineering - Next.js

## 1. Modern Web Architecture
*   **Next.js & React Server Components (RSC)**:
    *   **Default**: Use **App Router** in principle and render with Server Components (RSC) as much as possible. This dramatically reduces the amount of JavaScript sent to the client.
    *   **Data Fetching**: Fetch data on the server side to avoid waterfall issues.
*   **Edge Computing**:
    *   **Middleware**: Execute auth checks and geolocation redirects in **Edge Middleware** to minimize latency.

## 2. UI Components & Styling
*   **shadcn/ui + Tailwind CSS**:
    *   **Standard Stack**: Adopt **shadcn/ui** as the standard UI component library for balancing customizability and accessibility.
    *   **Design System**: Use Tailwind Config's `extend` to define project-specific colors, fonts, and shadows as tokens. Hardcoding HEX values (e.g., `#F00`) is prohibited.
*   **CSS Architecture**:
    *   **Utility First**: Use Tailwind Utility classes in principle.
    *   **Component Extraction**: Encapsulate common patterns (Buttons, Cards) as React components and avoid `@apply` as much as possible (Recommended by Tailwind team).
    *   **CSS Modules**: Allow CSS Modules (or `styled-jsx`) only for complex animations or styles difficult to express with Tailwind.
*   **Class Sorting**: Introduce `prettier-plugin-tailwindcss` to automatically and forcibly unify the order of class names.

## 3. Forms & Validation
*   **Library Selection**:
    *   **React Hook Form**: Base on uncontrolled components to minimize re-renders.
    *   **Zod**: Practice Schema-Driven Development. Separate validation logic from UI and define it as Zod schemas.
*   **Validation**:
    *   **Client-Side**: Provide real-time feedback for required fields, character counts, email format, etc., before submitting to the server.
    *   **Type Safety**: Infer TypeScript types from Zod (`z.infer`) to eradicate type mismatches between form data and API requests.

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
    *   **CLS Prevention**: Always specify `width` and `height` (or `fill`) for images to prevent layout shift.
*   **Font Optimization**:
    *   Self-host Google Fonts using `next/font` to eliminate layout shift (CLS) and external requests.
*   **Metadata Management**:
    *   Dynamically generate and fully optimize `title`, `description`, `og:image` for SEO on each page.

## 7. Component Design & A11y
*   **Accessibility - "Shift Left"**:
    *   **Automated Testing**: Run `axe-core` in CI to automatically detect and block low contrast or missing labels.
    *   **Screen Reader**: Mandate real device testing with Screen Readers (VoiceOver/TalkBack) for main flows.
    *   **WAI-ARIA**: "No ARIA is better than Bad ARIA". Use native HTML elements as much as possible and apply ARIA attributes only when necessary.
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
    *   **Compatibility**: Output CSV with **BOM-prefixed UTF-8** to prevent garbled text in Excel. Always embed Japanese fonts (e.g., Noto Sans JP) in PDFs.

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
