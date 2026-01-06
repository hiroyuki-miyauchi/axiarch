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
*   **Asset Classification Strategy**:
    *   **Official Assets**: Manage official content (Articles, Banners) in `admin/media/` and force selection ONLY via the "Media Library".
    *   **User Assets**: Isolate UGC (Profiles, Posts) in `users/{uid}/` and allow direct upload from User Settings.
*   **Editor Integration Protocol (Admin Side)**:
    *   **Direct Upload Ban**: Direct drag-and-drop or paste uploads into Admin Editors (Tiptap, etc.) are **prohibited**.
    *   **Centralized Flow**: Image insertion must always go through the "Media Library" modal to enforce reuse of existing assets. This prevents storage waste from duplicate uploads.

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
## 5. Layout & Widget Architecture (Hybrid Strategy)
*   **The Hybrid Design Protocol (Content vs Layout)**:
    *   **Context**: The best practice for CMS is a hybrid design that separates "Content Entity (Relational)" from "Placement Info (JSON)".
    *   **Rule**: Manage articles/products in normalized tables, while managing Top Page section order or Widget placement purely as **JSON Arrays** (e.g., `['hero', 'ranking', 'new']`).
*   **Dynamic Page Builder**:
    *   **No Hardcoding Strategy**: Do not hardcode Top Pages or LPs. Adopt a CMS-style architecture allowing admins to freely add and reorder sections like "Feature Banners", "Rankings", and "New Arrivals".
    *   **Component Isolation**: Define each section as an independent component and isolate errors with `ErrorBoundary` to prevent total page crashes.
    *   **LCP Optimization**: Always render critical elements like Hero Banners via SSR and preload with `priority={true}` to prioritize display speed.
    *   **Sidebar Widgets**: Define sidebar widgets as **React Components**, not DB records, and map them dynamically based on configuration JSON (`sidebar_order`).

## 6. Content Operations Protocol
*   **Publishing Workflow**:
    *   **Status Transition**: Strictly adhere to status transitions: `draft` -> `pending` (Review) -> `published` -> `archived` (Soft Delete).
    *   **Secure Preview**: Allow previewing pre-published content ONLY via Signed URLs (`verify(token)`).
    *   **Scheduled Publishing**: Treat content as public only if `status = 'published'` AND `published_at <= NOW()`. Combine with scheduled cache purges (ISR/Revalidate).
*   **Automated SEO**:
    *   **Meta Automation**: Automatically complete missing Titles/OGP using AI summarization or default images to prevent publishing incomplete content.
    *   **Internal Linking**: Automatically recommend related content (matching tags/categories) to reinforce internal link structure.

## 7. Editor Governance (Rich Text Policy)
*   **Tiptap Governance**:
    *   **Strict Schema**: Restrict Editor (e.g., Tiptap) to allowed elements only (e.g., H2/H3) to prevent design destruction. Always save as **JSON Format (`JSONContent`)** instead of HTML strings to ensure future extensibility.
    *   **Paste Sanitization (DOMPurify)**: Mandatory sanitization during Paste and View (Read) to eliminate malicious scripts and broken styles.
    *   **PII Real-time Warning**: If PII (Phone/Email) is detected within the editor, immediately display an "Alert" via Toast/UI to urge reconsideration, rather than blocking the save.
    *   **Code Injection**: When using direct HTML entry nodes, strictly use a Code Editor (like PrismJS) to prevent layout breakage due to syntax errors.

## 8. Audit & Revision History
*   **Historian Protocol**:
    *   **Revisioning**: Save diffs to a `revisions` table on every save to track "Who changed what and when".
    *   **Rollback**: Implement a standard feature to restore past revisions with one click in case of errors.

## 9. Fixed Page Strategy (Static & Headless)
*   **The "Fixed Page" Engine**:
    *   **Dynamic & Static**: Do not hardcode "Fixed Pages" like Terms or LPs. Manage them via Headless CMS (`fixed_pages`) and Dynamic Routing (`/[slug]`).
    *   **ISR Strategy**: Set ISR to `revalidate: 3600` (1 hour) or more to minimize DB load for low-frequency update pages.
    *   **PII Protection**: Install guardrails to display real-time warnings if Personally Identifiable Information (PII) like phone numbers is detected during editor input.
    *   **API-First Delivery**: To ensure future App delivery (avoiding WebView), always implement paired API endpoints that return JSON data, not just Web views.
