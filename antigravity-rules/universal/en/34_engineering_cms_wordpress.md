# 34. CMS & Content Management (Headless WordPress)

## 1. Headless Architecture
*   **Decoupling**:
    *   **Rule**: Use WordPress solely for "Content Management (Input)" and never for the Frontend (Display).
    *   **API Usage**: Fetch content via **WPGraphQL** or **REST API** and render it with a modern frontend like Next.js.
*   **Security**:
    *   Protect the admin panel (/wp-admin) with IP restrictions or Basic Auth, completely isolating it from the public frontend. This minimizes vulnerability risks specific to WordPress.

## 2. Performance & Static Generation
*   **SSG/ISR**:
    *   Generate article content as static HTML at build time (SSG) or request time (ISR) and serve from CDN. Minimize direct access to the WordPress server.
*   **Image Optimization**:
    *   Optimize and cache images uploaded to WordPress using `next/image` etc. on the frontend side.

## 3. Operations & Maintenance
*   **Plugin Management**:
    *   Keep plugins to a minimum. Prioritize performance and security over feature additions.
    *   **Auto-Update**: Configure security patches to be applied automatically.
*   **Composer**:
    *   Manage all plugins and core with **Composer**. Direct installation from the admin panel is prohibited (file changes in production are prohibited).
