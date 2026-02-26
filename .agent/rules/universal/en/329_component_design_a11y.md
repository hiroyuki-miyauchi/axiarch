# 33. Web Frontend Engineering - Next.js

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
