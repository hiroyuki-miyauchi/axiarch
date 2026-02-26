# 33. Web Frontend Engineering - Next.js
## 9. Fixed Page Strategy (Static & Headless)
*   **The "Fixed Page" Engine**:
    *   **Dynamic & Static**: Do not hardcode "Fixed Pages" like Terms or LPs. Manage them via Headless CMS (`fixed_pages`) and Dynamic Routing (`/[slug]`).
    *   **ISR Strategy**: Set ISR to `revalidate: 3600` (1 hour) or more to minimize DB load for low-frequency update pages.
    *   **PII Protection**: Install guardrails to display real-time warnings if Personally Identifiable Information (PII) like phone numbers is detected during editor input.
    *   **API-First Delivery**: To ensure future App delivery (avoiding WebView), always implement paired API endpoints that return JSON data, not just Web views.

## 10. Dynamic Content Management

### 10.1. The Dynamic Sections Protocol
*   **Law**: The composition of top pages and landing pages (section order, visibility, data sources) MUST NOT be hardcoded; retrieve them **dynamically from DB/CMS**.
*   **Action**:
    1.  **Section Registry**: Define available section types (hero, ranking, new arrivals, featured, etc.) as master data.
    2.  **Page Composition**: Enable configuration of "which sections to display in what order" per page via management table or JSONB.
    3.  **No Deploy for Layout**: Maintain a design where page layout changes do not require code deployment.
    4.  **LCP Performance**: First-view sections (hero sections, etc.) MUST be Server-Side Rendered (SSR), and images must have the `priority` attribute set for preloading to optimize LCP (Largest Contentful Paint).

### 10.2. The Preview Gate Protocol
*   **Law**: Previewing draft or unpublished content MUST be restricted to **authenticated administrators only**.
*   **Action**:
    1.  **Draft Isolation**: In preview mode, include `status = 'draft'` in queries while maintaining invisibility to regular users.
    2.  **Auth Gate**: Require authentication tokens or session verification for preview URLs; return 403/404 to unauthenticated users.
    3.  **No Draft Leak**: Ensure preview content is not indexed by search engines by setting `noindex` meta tags or `X-Robots-Tag` headers.
    4.  **Multi-Factor Preview**: When password protection is configured for the preview feature, implement multi-factor authentication requiring **password input (Knowledge Factor)** in addition to URL token verification. This serves as a barrier against URL leakage.
    5.  **Cookie Fallback**: If the session cookie is invalid even when the token is correct, always redirect to the password input screen to re-authenticate.

### 10.3. The Dual Mode Fetching Protocol (Public/Preview Data Isolation)
*   **Law**: When handling preview functionality and public pages in the same codebase, **physically prevent the risk of unpublished data being exposed on public pages**.
*   **Action**:
    1.  **Explicit Method Separation**: Explicitly separate data fetching functions into public (public conditions only) and preview (with token verification), or strictly branch within a single function using a flag.
    2.  **Default Deny**: The default value of the preview flag MUST be `false` (Public Mode), escalating permissions only when explicitly authorized. Designs where unpublished data is exposed when unspecified are prohibited.

## 11. Publishing Reliability

### 11.1. The Page Scheduling Protocol
*   **Law**: Implement content publish/unpublish scheduling by date/time as a standard feature.
*   **Action**:
    1.  **Scheduling Fields**: Include `published_at` (publish date) and `unpublished_at` (unpublish date) in content tables.
    2.  **Query Filter**: Filter public queries with `published_at <= NOW() AND (unpublished_at IS NULL OR unpublished_at > NOW())`.
    3.  **Cache Invalidation**: Design a mechanism to automatically invalidate related page caches when schedule times are reached.
    4.  **Double Defense**: In addition to DB query-based publish restrictions (`WHERE published_at <= NOW()`), always perform time checks in the application logic layer as well, denying access to content before its scheduled time. This physically prevents the risk of DB filtering being bypassed in CDN cache or ISR contexts.

### 11.2. The Soft 404 Awareness Protocol
*   **Law**: Prevent "Soft 404s" where deleted or unpublished content URLs return 200 status with empty pages.
*   **Action**:
    1.  **Proper HTTP Status**: Return **410 Gone** for deleted resources and **404 Not Found** for non-existent resources.
    2.  **Redirect Strategy**: Apply **301 Redirect** for moved content to preserve SEO equity (link juice).
    3.  **No Empty Pages**: Returning a 200 status with "This page does not exist" is prohibited as it will be indexed by search engines and damage SEO.
    4.  **Content-Based Verification**: Some frameworks may not correctly return a 404 HTTP status code when `notFound()` is called. In testing and monitoring, do not rely solely on status codes; verify using **the presence or absence of page content** (error message text, etc.) as the positive verification criterion.
