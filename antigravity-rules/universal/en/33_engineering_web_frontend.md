# 33. Web Frontend Engineering (Next.js)

## 1. Modern Web Architecture
*   **Next.js & React Server Components (RSC)**:
    *   **Default**: Use **App Router** as a rule and render with Server Components (RSC) whenever possible. This drastically reduces the JavaScript sent to the client.
    *   **Data Fetching**: Fetch data on the server side to avoid waterfall issues.
*   **Edge Computing**:
    *   **Middleware**: Execute auth checks and geolocation redirects in **Edge Middleware** to minimize latency.

## 2. Performance & SEO ("Core Web Vitals")
*   **Image Optimization**:
    *   Always use `next/image` to automatically serve optimal size and format (AVIF/WebP) for the device.
    *   **CLS**: Always specify `width` and `height` (or `fill`) to prevent layout shifts.
*   **Font Optimization**:
    *   Use `next/font` to self-host Google Fonts and eliminate layout shifts (CLS) and external requests.
*   **Metadata Management**:
    *   Dynamically generate and fully optimize `title`, `description`, and `og:image` for each page for SEO.

## 3. Component Design
*   **Atomic Design**:
    *   Design components for reusability but avoid over-abstraction. Prioritize "Colocation" (ease of change) over "Premature Optimization".
*   **Accessibility (A11y)**:
    *   **Radix UI / Headless UI**: For complex interactive components (Dialogs, Dropdowns), use accessible headless UI libraries and apply styles with Tailwind CSS.

## 4. Deployment & Infrastructure
*   **Vercel**:
    *   **Vercel** is the first choice for deployment.
    *   **Preview**: Automatically generate preview environments for every PR to facilitate design reviews and testing.
*   **ISR (Incremental Static Regeneration)**:
    *   Use ISR for static content (Blogs, Help Pages) to achieve both fast build times and fresh content.
