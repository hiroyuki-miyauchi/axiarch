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
    *   **The UGC Capacity Optimization Protocol**:
        *   **Law**: Mandate **client-side pre-processing before upload** for user-uploaded images to optimize server storage and CDN bandwidth costs.
        *   **Action**:
            1.  **Resize Mandate**: Resize images to **1920px or less on the longest edge** on the client-side before upload. Uploading original-size images is prohibited as a waste of storage costs.
            2.  **EXIF Strip**: **Strip EXIF data containing location information (GPS) before upload** for privacy protection. Physically eliminate the risk of users inadvertently exposing their home or workplace location.
            3.  **Format Guidance**: Explicitly specify uploadable formats (JPEG, PNG, WebP, etc.) and maximum file size limits, and enforce via validation.
        *   **Rationale**: Server-side resizing consumes bandwidth and CPU costs. Client-side pre-processing is the optimal solution for simultaneously reducing server load and protecting privacy.
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
*   **The CDN Delivery Gateway Mandate**:
    *   **Law**: Directly specifying **origin URLs** (raw storage service URLs) in the `src` attribute of `<img>` tags is prohibited.
    *   **Action**: Image delivery MUST be routed through a **CDN (Content Delivery Network) or reverse proxy**, applying edge caching, automatic format conversion (WebP/AVIF), and responsive resizing.
    *   **Rationale**: Direct origin URL references cause CDN cache bypass (performance degradation), excessive requests to origin servers (cost increase), and require full codebase modification during future storage provider migration (technical debt). CDN gateway centralization achieves the trinity of performance, cost efficiency, and flexibility.
*   **The Storage URL Hardcoding Ban**:
    *   **Law**: Hardcoding image or file URLs as `https://...` directly in code is prohibited.
    *   **Action**: Always resolve domains and paths via utility functions such as `getStorageUrl(path)`. This ensures flexibility for future bucket name changes or CDN provider migrations.
    *   **Rationale**: Hardcoded URLs create technical debt requiring codebase-wide grep and modification during infrastructure changes.

### 3.1. The Content Cache Tiering Protocol
*   **Law**: Tier cache TTL (Time To Live) based on content update frequency to optimize the balance between performance and freshness. Applying uniform cache settings to all content is prohibited.
*   **Action**:
    1.  **Tier Classification**: Classify content into the following 3 tiers based on update frequency and apply appropriate caching strategies to each.
        | Tier | Example | Cache Strategy |
        |:-----|:--------|:--------------|
        | **Hot (High-frequency updates)** | Rankings, inventory, pricing | ISR `revalidate: 60`–300 or SSR |
        | **Warm (Medium-frequency updates)** | Article lists, featured pages | ISR `revalidate: 3600` |
        | **Cold (Low-frequency updates)** | Terms of service, company info | SSG + On-demand Revalidation |
    2.  **Cache Invalidation**: Trigger on-demand revalidation for corresponding pages upon content updates to prevent stale cache persistence.
    3.  **Cache Key Design**: Include role information in cache keys to prevent cache mixing between user roles (admin preview vs public access).
*   **Rationale**: Uniform cache settings cause "updated but not reflected" issues and unnecessary server load. Tiering based on content nature is the key to achieving both performance and UX.

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

### 5.1. The Schema Permission Lock Protocol
*   **Law**: When adopting JSON-based layout definitions or content structures in CMS, **explicitly separate at the schema level** the "structure defined and locked by operations (System Schema)" from the "areas editable by users or editors (User Data)."
*   **Action**:
    1.  **Lock/Unlock Separation**: Apply `editable: true/false` or equivalent metadata to each field in the JSON schema, and physically control editability on the UI side.
    2.  **Admin Override Only**: Restrict modifications to locked fields to admin-level permissions (Admin or above), displaying them as read-only to general editors.
    3.  **Validation Gate**: If changes to locked fields are detected at save time, reject them on the backend. Relying solely on frontend control is prohibited.
*   **Rationale**: When layout structure and content data coexist in the same JSON without permission differentiation, there is a risk of site-wide layout collapse due to editor mistakes. Schema-level permission separation is the only means to achieve both "content freedom" and "structural stability."

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
*   **The SEO Preview Mandate**:
    *   **Context**: Without meta information preview (title/description/OGP image) during CMS content entry, SEO quality degradation and inappropriate social share previews occur after publication.
    *   **Law**: Install a permanent **SEO Preview Panel** on the content editing screen and mandate pre-publication quality checks.
        *   **Search Result Preview**: Display title + description in a search-result-style UI
        *   **Social Share Preview**: Display OGP image + title + description in a social card-style UI
    *   **Validation Rules**:
        | Item | Criteria | On Violation |
        |:-----|:---------|:-------------|
        | **meta title** | 15-60 characters (adjust per language) | Yellow warning display |
        | **meta description** | 50-160 characters (adjust per language) | Yellow warning display |
        | **OGP image** | 1200×630px recommended, file size ≦ 300KB | Resize suggestion |
        | **H1 heading** | One per page, consistency with meta title recommended | Red warning display |
    *   **Auto-Suggestion**: When title/description is empty, automatically generate and suggest candidates from the body text.

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
*   **The Content Moderation Protocol**:
    *   **Context**: UGC (reviews, comments, etc.) is fundamental to trust, but leaving inappropriate content unaddressed leads to brand damage and legal risks.
    *   **Law**: For services accepting UGC, establish the following prohibited content classifications and multi-layered moderation framework.
    *   **Prohibited Content Categories**:
        | Category | Examples | Response |
        |:---------|:---------|:---------|
        | **Defamation** | Personal attacks, libel, discriminatory expressions | Immediate unpublish + author warning |
        | **Misinformation** | Factually incorrect reviews (including astroturfing) | Unpublish + investigation |
        | **Personal Information** | Exposure of phone numbers, addresses, email addresses | Automatic masking |
        | **Harmful Content** | Violence, obscenity, drug-related content | Immediate deletion |
        | **Spam** | Promotional posts, link spam | Auto-filter to hidden |
        | **Copyright Infringement** | Unauthorized image reproduction, plagiarized text | Process via legal response flow |
    *   **Moderation Layers**:
        1.  **Automatic Filter (Layer 1)**: Immediate judgment via prohibited word dictionary + regex patterns
        2.  **AI Judgment (Layer 2)**: Flag as "requires review" via sentiment analysis and toxicity detection
        3.  **Human Review (Layer 3)**: Administrators review flagged content within 24 hours
    *   **Transparency**: Notify authors of the reason for content removal and provide an opportunity for appeal.
*   **The Content Auto-Save Protocol**:
    *   **Context**: Extended editing sessions in rich text editors carry significant data loss risks from browser crashes, network disconnections, and accidental tab closures.
    *   **Law**: Implement multi-layered auto-saving for editor content to bring data loss risk as close to zero as possible.
    *   **Action**:
        1.  **Local Auto-Save**: Auto-save editor content to `localStorage` at **30-second intervals** (guideline) to provide recovery points in case of browser crashes.
        2.  **Server Draft Sync**: Auto-sync draft content to the server at **60-second intervals** (guideline) to prevent data loss in case of device failure.
        3.  **Conflict Detection**: Detect simultaneous editing of the same content in multiple tabs and notify users with messages such as "New changes were saved in another tab." Silent overwrites without notification are prohibited.
    *   **Rationale**: "Forgot to save and lost everything" is the biggest trust-destroying event in editor UX. Multi-layered auto-save is the most cost-effective investment in protecting user work.
*   **The NodeView Portal Prohibition**:
    *   **Context**: When implementing custom NodeViews (image galleries, embedded widgets, etc.) in ProseMirror-based rich text editors (Tiptap, etc.), there is a temptation to use React Portal (`createPortal`) from within the NodeView to render external UI (dropdowns, modals, etc.).
    *   **Law**: Using React Portal from within a NodeView to render UI outside the editor's DOM management (`document.body`, etc.) is **prohibited**.
    *   **Action**:
        1.  **Inline Rendering**: UI elements such as dropdowns and toolbars MUST be rendered **inline** within the NodeView's `contentDOM` or as adjacent DOM elements.
        2.  **Editor Command Pattern**: When external UI needs to be launched from a NodeView, delegate control to the editor itself through the editor's command system or plugin metadata, and render the UI at the editor level.
        3.  **Z-Index Isolation**: Set appropriate `z-index` for overlay UI within NodeViews within the editor's stacking context to control overlap with other NodeViews.
    *   **Rationale**: ProseMirror's NodeView strictly manages the editor's `contentDOM`, and external DOM operations via React Portal conflict with this management. Specifically: (1) Focus management disruption (Portal click → focus loss from editor → selection collapse), (2) Event propagation disruption (keyboard events within Portal do not reach the editor), (3) Node synchronization collapse (UI operations within Portal occur outside ProseMirror's transaction, causing state inconsistencies).
*   **The stopEvent Configuration Mandate**:
    *   **Context**: When placing interactive elements (`<input>`, `<select>`, `<button>`, sliders, etc.) inside custom NodeViews of ProseMirror-based rich text editors (Tiptap, etc.), by default, click, key input, drag, and other events on these elements are propagated to and consumed by the editor, rendering UI operations non-functional.
    *   **Law**: When placing interactive elements inside custom NodeViews, the `stopEvent` function in the NodeView definition MUST be configured to explicitly control event propagation to the editor.
    *   **Action**:
        1.  **Explicit stopEvent**: Implement the `stopEvent` function in the NodeView definition (`addNodeView`, etc.) to prevent events (`mousedown`, `keydown`, `input`, `dragstart`, etc.) from interactive elements within the NodeView from propagating to the editor.
        2.  **Selective Blocking**: Rather than indiscriminately blocking all events, selectively block only events originating from interactive elements within the NodeView. Events related to text editing (cursor movement, etc.) must still propagate to the editor.
        3.  **Testing**: Individually test each interactive element within the NodeView to confirm that "clicks respond," "text input works," and "drag operations function."
    *   **Rationale**: ProseMirror, by default, attempts to handle all events within the editor itself. In NodeViews without `stopEvent` configured, button clicks are interpreted as editor selection operations, and input field keystrokes are consumed as editor shortcuts. This is the most frequently occurring bug during NodeView implementation, and proper `stopEvent` configuration is the "minimum operational guarantee for custom NodeViews."

## 8. Audit & Revision History
*   **Historian Protocol**:
    *   **Revisioning**: Save diffs to a `revisions` table on every save to track "Who changed what and when".
    *   **Rollback**: Implement a standard feature to restore past revisions with one click in case of errors.
    *   **The Content Revision Protocol**:
        *   **Retention**: Revisions must be **retained indefinitely** as a principle. Define an archive policy separately only if storage costs become a concern.
        *   **Diff View**: Implement Diff View for the last N revisions (recommended: 10 or more) accessible from the admin panel, mandating visibility of changes.
        *   **Legal Document Versioning**: Legal documents such as Terms of Service and Privacy Policy must be managed with particular rigor, enabling restoration and display of any past version (Legal Time Machine).

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
