# 33. Web Frontend Engineering (Next.js)

## 1. Modern Web Architecture
*   **Next.js & React Server Components (RSC)**:
    *   **Default**: Use **App Router** by default and render with Server Components (RSC) as much as possible. This drastically reduces the amount of JavaScript sent to the client.
    *   **Data Fetching**: Perform data fetching on the server side to avoid waterfall issues.
*   **Edge Computing**:
    *   **Middleware**: Execute authentication checks and geolocation redirects in **Edge Middleware** to minimize latency.

## 2. CSS Architecture & Styling
*   **Tailwind CSS (Utility-First)**:
    *   **Strategy**: Standardize on Tailwind CSS. Prevent class name conflicts and minimize bundle size.
    *   **BEM Philosophy**: Even when using Tailwind, maintain the BEM (Block Element Modifier) philosophy (separation of concerns) for component structure.
*   **CSS Performance**:
    *   **Avoid Reflow/Repaint**: Use only `transform` and `opacity` for animations. Animating `left`, `top`, `width` is prohibited.
    *   **CSS Containment**: Use the `contain` property for complex layouts to reduce browser rendering costs.
*   **Mobile First**:
    *   **Default Styles**: Write styles without media queries as "for mobile".
    *   **Extension**: Use `sm:`, `md:`, `lg:` prefixes to override styles as the screen size increases (Min-width Media Queries).

## 3. Performance & SEO ("Core Web Vitals")
*   **Image Optimization**:
    *   Always use the `next/image` component to automatically serve optimal image sizes and formats (AVIF/WebP) according to device size.
    *   **CLS Prevention**: Always specify `width` and `height` (or `fill`) for images to prevent layout shifts.
*   **Font Optimization**:
    *   Self-host Google Fonts using `next/font` to eliminate layout shifts (CLS) and external requests.
*   **Metadata Management**:
    *   Dynamically generate and fully optimize `title`, `description`, and `og:image` for SEO on each page.

## 4. Component Design
*   **Atomic Design**:
    *   Design components considering reusability, but avoid excessive abstraction. Prioritize "Ease of Change (Colocation)" over "Premature Optimization".
*   **Accessibility (A11y)**:
    *   **Radix UI / Headless UI**: For complex interactive components (Dialogs, Dropdowns), use accessible headless UI libraries and apply styles only with Tailwind CSS.

## 5. Deployment & Infrastructure
*   **Vercel**:
    *   **Vercel** is the first choice for deployment.
    *   **Preview Environment**: Automatically generate preview environments for every Pull Request to facilitate design reviews and testing.
*   **ISR (Incremental Static Regeneration)**:
    *   Use ISR for static content (blog posts, help pages) to balance fast build times with always-fresh content.
*   **Edge Functions**:
    *   Execute low-latency processes (AI streaming, Auth middleware) on the Edge Runtime.
