# 34. Engineering: CMS Strategy (Headless WordPress)

## 1. Modern WordPress Architecture
*   **Headless is King**:
    *   Traditional monolithic WordPress (frontend rendering via PHP) is prohibited in principle.
    *   Adopt **Headless Architecture**, using WordPress solely as a "Content Management API."
    *   Build the frontend with modern frameworks like **Next.js** to achieve overwhelming performance and security.

## 2. Bedrock & Roots Stack
*   **Bedrock**:
    *   Must use **Bedrock** (Roots.io) for WordPress installation.
    *   Manage environment variables via `.env` instead of `wp-config.php` and enforce a Git-friendly directory structure.
*   **Composer**:
    *   Manage all plugins and core via **Composer**. Direct installation from the admin panel is prohibited (file changes in production are banned).

## 3. API & Data Fetching
*   **WPGraphQL**:
    *   Use **WPGraphQL** as the standard instead of REST API. Fetch only necessary data to prevent over-fetching.
*   **Advanced Custom Fields (ACF)**:
    *   Use ACF for structured data and expose it to the GraphQL schema.

## 4. Security & Performance
*   **Static Generation (SSG/ISR)**:
    *   Requests to WordPress should only occur during build (SSG) or revalidation (ISR). Deliver static HTML to users to nullify WordPress-specific security risks (SQL injection, etc.).
