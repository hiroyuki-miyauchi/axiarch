# 34. CMS & Content Management (Headless WordPress)

## 1. Headless Architecture
*   **Decoupling**:
    *   **Rule**: Use WordPress ONLY for "Content Management (Input)". Never use it for Frontend (Display).
    *   **API**: Fetch content via **WPGraphQL** or **REST API** and render with Next.js.
*   **Security**:
    *   Protect the Admin Panel (/wp-admin) with IP restrictions or Basic Auth. Completely isolate it from the public frontend to minimize WP-specific vulnerabilities.

## 2. Performance & Static Generation
*   **SSG/ISR**:
    *   Generate articles as static HTML at build time (SSG) or request time (ISR) and serve from CDN. Minimize direct access to the WordPress server.
*   **Image Optimization**:
    *   Optimize and cache images uploaded to WordPress using `next/image` on the frontend side.

## 3. Operations & Maintenance
*   **Plugin Management**:
    *   Keep plugins to a minimum. Prioritize performance and security over features.
    *   **Auto Update**: Configure security patches to apply automatically.
*   **Bedrock & Composer**:
    *   Use **Bedrock** (Roots.io) for WordPress installation. Manage environment variables via `.env`.
    *   Manage all plugins and core via **Composer**. Direct installation from the admin panel is prohibited (file changes in production are banned).

## 4. API & Data Fetching
*   **WPGraphQL**:
    *   Use **WPGraphQL** as the standard instead of REST API. Fetch only necessary data to prevent over-fetching.
*   **Advanced Custom Fields (ACF)**:

## 4. Security & Performance
*   **Static Generation (SSG/ISR)**:
    *   Requests to WordPress should only occur during build (SSG) or revalidation (ISR). Deliver static HTML to users to nullify WordPress-specific security risks (SQL injection, etc.).
