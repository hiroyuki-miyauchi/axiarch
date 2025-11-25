# 34. Content Management System - Headless CMS

## 1. Headless Architecture
*   **Content as Data**:
    *   **Principle**: Manage content as "Pure Data" separated from "Presentation".
    *   **API First**: Retrieve content entirely via API, enabling delivery to all devices (Omnichannel) including Web, Mobile Apps, Smartwatches.
*   **Selection Criteria**:
    *   **Recommendation**: SaaS Headless CMS like Contentful, MicroCMS, Sanity are the first choice.
    *   **WordPress**: If using WordPress, strictly use in **Headless Mode (WPGraphQL)** and completely separate from Frontend (Next.js). Theme development with PHP is prohibited.

## 2. Performance & Delivery
*   **SSG / ISR**:
    *   Generate content as static HTML at build time (SSG) or request time (ISR) and deliver from CDN. Minimize direct access to CMS server to limit and realize blazing fast display speed.
*   **Image Optimization**:
    *   Optimize and cache images delivered from CMS on the frontend side using `next/image` etc. Avoid using CMS image URLs directly in `img` tags.

## 3. Operations & Security
*   **Preview Feature**:
    *   Implement Next.js **Preview Mode** so editors can check content before publishing, displaying draft content securely.
*   **Security**:
    *   Protect CMS admin panel with IP restriction or SSO and completely separate from the public frontend. This minimizes CMS-specific vulnerability risks.
