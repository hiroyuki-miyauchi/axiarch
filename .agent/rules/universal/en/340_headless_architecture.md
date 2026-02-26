# 34. Content Management System - Headless CMS

## 1. Headless Architecture
*   **Content as Data**:
    *   **Principle**: Manage content as "Pure Data" separated from "Presentation".
    *   **API First**: Retrieve content entirely via API, enabling delivery to all devices (Omnichannel) including Web, Mobile Apps, Smartwatches.
    *   **The AI-Ready Content Protocol (RAG Optimization)**:
        *   **Law**: Design content structure to be easily understood and cited by AI Agents (RAG/Search), not just humans.
        *   **Action**: Avoid "Walls of Text". Mandate **Semantic Markup (H2/H3, Lists)** and metadata (Summary, Keywords, Reliability Score) retention.
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
    *   **The Original Preservation Protocol**:
        *   **Law**: Admin-uploaded images are "Master Data". NEVER compress or destructively convert on the server-side.
        *   **Action**: Optimization (WebP, Resize) must happen at Delivery (CDN Edge). Keep the original pristine.
    *   **User Assets**: Isolate UGC (Profiles, Posts) in `users/{uid}/` and allow direct upload from User Settings.
    *   **The Video Ban Protocol (Cost & Risk Control)**:
        *   **Law**: Direct video upload to server is prohibited due to bandwidth costs and content monitoring risks.
        *   **Action**: Mandate uploading videos to external platforms (YouTube/Vimeo) and store only "Embed Code (iframe/ID)".
*   **Editor Integration Protocol (Admin Side)**:
    *   **Direct Upload Ban**: Direct drag-and-drop or paste uploads into Admin Editors (Tiptap, etc.) are **prohibited**.
    *   **Centralized Flow**: Image insertion must always go through the "Media Library" modal to enforce reuse of existing assets. This prevents storage waste from duplicate uploads.

## 3. Performance & Delivery
*   **SSG / ISR**:
    *   Generate content as static HTML at build time (SSG) or request time (ISR) and deliver via CDN. Minimize direct access to CMS servers for lightning-fast speed.
*   **Image Optimization**:
    *   Optimize and cache images delivered from CMS using `next/image` on the frontend. Avoid using CMS image URLs directly in `img` tags.
*   **The Storage URL Hardcoding Ban**:
    *   **Law**: Hardcoding image or file URLs as `https://...` directly in code is prohibited.
    *   **Action**: Always resolve domains and paths via utility functions such as `getStorageUrl(path)`. This ensures flexibility for future bucket name changes or CDN provider migrations.
    *   **Rationale**: Hardcoded URLs create technical debt requiring codebase-wide grep and modification during infrastructure changes.

## 4. Operations & Security
*   **Preview Mode**:
    *   Implement Next.js **Preview Mode** to allow editors to securely verify draft content before publication.
*   **Security**:
    *   Protect CMS Admin Panels with IP restrictions or SSO, completely confirming separation from the public frontend. This minimizes CMS-specific vulnerability risks.
    *   **The Media Library Sanctuary (Code Sanctuary)**:
        *   **Context**: Media management logic (`admin/media`) is delicate, involving complex uploads, resizing, and RLS.
        *   **Law**: Automated refactoring/deletion of `components/admin/media/*` and `api/media.ts` by AI is prohibited. Explicit user approval is mandatory for any changes.

## 5. Layout & Widget Architecture (Hybrid Strategy)
*   **The Hybrid Design Protocol (Content vs Layout)**:
    *   **Context**: The best practice for CMS is a hybrid design that separates "Content Entity (Relational)" from "Placement Info (JSON)".
    *   **Rule**: Manage articles/products in normalized tables, while managing Top Page section order or Widget placement purely as **JSON Arrays** (e.g., `['hero', 'ranking', 'new']`).
*   **Dynamic Page Builder**:
    *   **No Hardcoding Strategy**: Do not hardcode Top Pages or LPs. Adopt a CMS-style architecture allowing admins to freely add and reorder sections like "Feature Banners", "Rankings", and "New Arrivals".
    *   **Component Isolation**: Define each section as an independent component and isolate errors with `ErrorBoundary` to prevent total page crashes.
    *   **LCP Optimization**: Always render critical elements like Hero Banners via SSR and preload with `priority={true}` to prioritize display speed.
    *   **Sidebar Widgets**: Define sidebar widgets as **React Components**, not DB records, and map them dynamically based on configuration JSON (`sidebar_order`).
*   **The Component Mapping Protocol (CMS-UI Bridge)**:
    *   **Law**: Physically define a **`ComponentRegistry`** connecting CMS Types to Frontend Components 1:1. Eliminate hardcoded `switch` branches.
    *   **Action**: Maintain a "Plugin Architecture" where `Object.entries()` or dynamic imports automatically render the corresponding UI the moment CMS response arrives.

## 6. Content Operations Protocol
*   **Publishing Workflow**:
    *   **Status Transition**: Strictly adhere to status transitions: `draft` -> `pending` (Review) -> `published` -> `archived` (Soft Delete).
    *   **Secure Preview**: Allow previewing pre-published content ONLY via Signed URLs (`verify(token)`).
    *   **Scheduled Publishing**: Treat content as public only if `status = 'published'` AND `published_at <= NOW()`. Combine with scheduled cache purges (ISR/Revalidate).
*   **The Content Approval Gate Protocol**:
    *   **Law**: Status transitions MUST be strictly controlled by "who" can perform them and "under what conditions". Unconditional transitions are a direct cause of content quality incidents.
    *   **Transition Rules**:
        | Transition | Authorized Role | Condition |
        |:---|:---|:---|
        | `draft → pending` | Writer (Author) | Body is not empty |
        | `pending → published` | **Admin (Editor or above)** | Review complete flag is `true` |
        | `published → archived` | Admin | Archive reason input required |
        | `archived → draft` | Admin | Audit log of re-edit initiation |
        | `pending → draft` | Writer or Admin | Rejection reason comment required |
    *   **Self-Publish Ban**: Authors directly setting their own content to `published` is **prohibited**. Must go through admin approval.
    *   **Audit Trail**: All status transitions must be recorded in an audit log table (`who`, `when`, `from_status`, `to_status`, `reason`).
*   **Automated SEO**:
    *   **Meta Automation**: Automatically complete missing Titles/OGP using AI summarization or default images to prevent publishing incomplete content.
    *   **Internal Linking**: Automatically recommend related content (matching tags/categories) to reinforce internal link structure.

## 7. Editor Governance (Rich Text Policy)
*   **Tiptap Governance**:
    *   **Strict Schema**: Restrict Editor (e.g., Tiptap) to allowed elements only (e.g., H2/H3).
    *   **The Triple Write Protocol (Data Integrity)**:
        *   **Law**: Mandate **Atomic Update** of Rich Text data in 3 formats to guarantee integrity for CMS and Backend:
            1.  **JSON (Editor Source)**: Structured data for future extensibility and re-editing.
            2.  **HTML (View Source)**: Display HTML to zero out parsing load on frontend.
            3.  **TEXT (Search Source)**: Plain text (tags removed) for search indexing.
        *   **Outcome**: Maximize "Editing Freedom", "Display Performance", and "Search Accuracy" simultaneously.
    *   **Paste Sanitization (DOMPurify)**: Mandatory sanitization during Paste and View (Read) to eliminate malicious scripts and broken styles.
    *   **PII Real-time Warning**: If PII (Phone/Email) is detected within the editor, immediately display an "Alert" via Toast/UI to urge reconsideration, rather than blocking the save.
    *   **Code Injection**: When using direct HTML entry nodes, strictly use a Code Editor (like PrismJS) to prevent layout breakage due to syntax errors.
    *   **The CMS Transparency Protocol (View Source Mandate)**:
        *   **Law**: WYSIWYG editors have limits for complex HTML debugging. Capabilities to view/edit raw HTML are indispensable for power users and debugging.
        *   **Action**: MUST implement "View Source" functionality in Rich Text Editor. Mandate **Two-way binding** support to rely instant reflection of edits.
*   **The Micro-Content Protocol**:
    *   **Context**: Small-scale text fields like "supplementary notes" or "access information remarks" that need line breaks and links but are not rich enough to warrant a full article editor.
    *   **Law**: Using rich text editors (Tiptap, etc.) for such fields is prohibited. It causes data structure bloat (`string` vs `JSON`) and performance degradation.
    *   **Action**: Adopt a standard `Textarea` + `Markdown` parser (`react-markdown`, etc.) configuration to keep data structures simple.

## 8. Audit & Revision History
*   **Historian Protocol**:
    *   **Revisioning**: Save diffs to a `revisions` table on every save to track "Who changed what and when".
    *   **Rollback**: Implement a standard feature to restore past revisions with one click in case of errors.
    *   **The Content Revision Protocol**:
        *   **Retention**: Revisions must be **retained indefinitely** as a principle. Define an archive policy separately only if storage costs become a concern.
        *   **Diff View**: Implement Diff View for the last N revisions (recommended: 10 or more) accessible from the admin panel, mandating visibility of changes.
        *   **Legal Document Versioning**: Legal documents such as Terms of Service and Privacy Policy must be managed with particular rigor, enabling restoration and display of any past version (Legal Time Machine).
