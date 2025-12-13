# 34. Content Management System - Headless CMS

## 1. Headless Architecture
*   **Content as Data**:
    *   **Principle**: Manage content as "Pure Data" separated from "Presentation".
    *   **API First**: Retrieve content entirely via API, enabling delivery to all devices (Omnichannel) including Web, Mobile Apps, Smartwatches.
*   **Selection Criteria**:
    *   **Recommendation**: SaaS Headless CMS like Contentful, MicroCMS, Sanity are the first choice.
    *   **WordPress**: If using WordPress, strictly use in **Headless Mode (WPGraphQL)** and completely separate from Frontend (Next.js). Theme development with PHP is prohibited.

## 2. Media Asset Management
*   **Centralized Media Strategy**:
    *   **Centralization**: Placing static files in `public/` is prohibited. All app assets (content, logos, icons) must be managed in the Unified Media Library (Cloud Storage / S3) to ensure control from the Admin Panel.
    *   **Semantic Structure**: Force meaningful folder structures like `category/YYYY/MM/Slug/`. Use human-readable alphanumeric names, not random IDs.
    *   **Filename Uniqueness**: Prohibit duplicate filenames within the same folder to prevent overwriting.
*   **Stability & Fallback**:
    *   **No-Image Rule**: Hardcoding placeholders in code is prohibited. Always reference a "Common No-Image" file on Storage to allow fallback for missing/broken links.
*   **Separation of Concerns**:
    *   **Admin vs User**: Physically **separate** "System Assets (Managed by Admin)" and "UGC (User Generated Content)" at the Bucket or Root Folder level to prevent UGC from polluting the system area.

## 3. Performance & Delivery
*   **SSG / ISR**:
    *   Generate content as static HTML at build time (SSG) or request time (ISR) and deliver via CDN. Minimize direct access to CMS servers for lightning-fast speed.
*   **Image Optimization**:
    *   Optimize and cache images delivered from CMS using `next/image` on the frontend. Avoid using CMS image URLs directly in `img` tags.

## 4. Operations & Security
*   **Preview Mode**:
    *   Implement Next.js **Preview Mode** to allow editors to securely verify draft content before publication.
*   **Security**:
    *   Protect CMS Admin Panels with IP restrictions or SSO, completely confirming separation from the public frontend. This minimizes CMS-specific vulnerability risks.
