# 33. Web Frontend Engineering - Next.js

### 12.0. The Lazy Redirect Anti-Pattern (UX Failure)
*   **Law**: Forcing a redirect via `redirect()` after completion or error without user feedback (Toast/Notification) is "Irresponsible Neglect" in UX and is prohibited.
*   **Action**: User has the right to know "What happened". Use redirect only when "Resource location changed", and always combine with Toast or Flash Message for status notification.

### 12.1. The Client DB Access Prohibition (Proxy Action Mandate)
*   **Ref**: Refer to the 300-series (Engineering) Rule 13.2 for details on banning direct DB access from client side. Strict adherence required.
*   **Law**: Directly calling `supabase.from()` in Client Components invites RLS vulnerabilities and bloating of raw data without DTO (Mapper), thus prohibited.
*   **Action**: Queries MUST use "Proxy Pattern" via Server Action (`src/lib/actions`) and return only minimal normalized data (DTO) to the client.

### 12.2. The Anchor Tag Nesting Prohibition (HTML Violation)
*   **Law**: Nesting `<a>` tags (including `Link` component) inside another `<a>` tag is an HTML spec violation that causes browser DOM auto-separation and Next.js Hydration Mismatch.
*   **Prohibition**: "It works visually" is not an excuse. Browsers automatically push nested `<a>` outside, causing physical mismatch between Server and Client DOM.
*   **Action**: To make a whole card clickable:
    1.  **Overlay Pattern**: Make card `relative`, expand main link via `::before` pseudo-element to `absolute inset-0`, and bring sub-links to front with `relative z-10`.
    2.  **Separate Pattern**: Link only the title or image, physically avoiding nesting.

### 12.3. The Server-Side DOM Prohibition (No jsdom)
*   **Law**: Accessing browser-specific objects like `document` or `window` in Server Component (Node.js/Edge) environment is a **Highest Level Prohibition**. Introducing polyfills like `jsdom` implies defeat of server-side design.
*   **Action**: For HTML parsing/sanitizing on server side, use lightweight `xss` library or `cheerio`. Usage of "Browser Dependent Wrappers" like `isomorphic-dompurify` is also prohibited in principle due to unclear side effects.

### 12.5. The Recursive Rendering Ban (Depth Safety)
*   **Law**: "Self-recursive rendering" within component trees with unclear termination conditions (Base Case) is prohibited.
*   **Action**: If recursive structure like comment tree is needed, MUST define **`maxDepth`** as Prop, and switch to "Load More" button or flat display if exceeded.

### 12.6. The Double Scrollbar Prohibition (UX Integrity)
*   **Law**: Unplanned nesting of `h-screen` and `overflow-y-auto` causing double scrollbars on screen is a UX defeat.
*   **Action**: Scroll container should ideally be **only one** (usually `body` or main layout) on screen. If partial scroll is needed, MUST consider `dvh` (Dynamic Viewport Height) and verify behavior on Mobile Safari.

### 12.7. The Metadata Obligation (Page Title Protocol)
*   **Law**: Page title becoming "undefined" or site name only is a quality defect damaging user trust.
*   **Action**: In all `page.tsx`, MUST define `export const metadata: Metadata`. Include visual check of browser tab title in pre-build self-check.

# 33. Web Frontend Engineering - Next.js

### 14.12. The Form DefaultValues Completeness Mandate
*   **Law**: When using form libraries such as React Hook Form, `defaultValues` must explicitly set **all fields** the form uses. When adding or modifying fields, **simultaneous three-point updates of Schema (validation definition) + defaultValues (initial values) + Controller/Input (UI rendering)** are mandatory.
*   **Action**:
    1.  **Exhaustive DefaultValues**: Enumerate all field initial values in `useForm({ defaultValues: { ... } })`. Omitted fields become `undefined`, causing unexpected behavior in Controlled Components.
    2.  **Three-Point Sync**: When adding a field, update the following three locations simultaneously:
        *   **Schema**: Zod / Yup validation schema
        *   **DefaultValues**: The `defaultValues` object of `useForm`
        *   **UI**: Form input components via `Controller` / `register`
    3.  **Type-Safe DefaultValues**: The type of `defaultValues` must match the type auto-inferred from the Schema (e.g., `z.infer<typeof schema>`). Defining types manually to create divergence is prohibited.
*   **Rationale**: Incomplete `defaultValues` is the leading cause of silent bugs where "the form looks normal when opened, but specific fields don't save." Enforcing three-point synchronization structurally prevents this class of bugs.

*   **Ref**: Refer to `30_engineering_general.md` Rule 13.2 for details on banning direct DB access from client side. Strict adherence required.
