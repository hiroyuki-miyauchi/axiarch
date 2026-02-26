# 30. Engineering Excellence (General)

### 13.1. The Trinity DTO Mandate (Constitutional Pillar)
*   **Law**: Any implementation violating these 3 points is unconstitutional and subject to immediate deletion:
    1.  **Security (PII Defense)**: Output of Raw Rows is prohibited. Must pass through **DTO (White-list)** to physically block sensitive info.
    2.  **Stability (Frontend Shield)**: Do not link DB Schema directly to UI. Build a Mapper function barrier to absorb changes within server.
    3.  **AI Economy (Token Optimization)**: Do not feed waste to AI. Use **AI-Optimized DTO** to save tokens and improve inference accuracy.
*   **Detailed Action**:
    *   **Strict Segregation**: DTOs containing sensitive fields (Admin memos, PII) must be physically separated at type level (e.g., `AdminDTO`, `PublicDTO`).
    *   **No Raw Return**: Server Actions/API must not return raw `Database['public']['Tables']` types. Always return explicitly defined DTOs.
    *   **No Blind Spread**: Spread syntax like `...user` is **strictly prohibited** in DTO conversion layers as it leaks future sensitive columns. Explicitly list fields.
    *   **The UI-DTO Binding Protocol**: Shared UI components (Cards, Widgets) must depend on **Abstract DTO Interfaces**, not concrete DB types, enabling Omnichannel reuse.

### 13.2. The Client DB Access Prohibition (Architecture Law)
*   **Law**: Calling `supabase.from()` directly from Client Components is prohibited to prevent RLS leaks and raw data exposure.
*   **Action**:
    *   **Gateway First**: Data fetch/update must go through `Server Actions` or `Route Handler` (API).
    *   **Secure Write Action Protocol**: Public write actions (Auth, Inquiry) must accept `turnstileToken` and verify on server. Reject invalid requests before DB access.

### 13.4. The VIP Lane Strategy (Native Bypass Protocol)
*   **Context**: Native Apps cannot safely hold API Keys.
*   **Law (Dual Auth)**:
    1.  **Common Endpoint**: Share endpoints for Public and First Party.
    2.  **Dual Auth**: Middleware checks OR condition of "API Key" and "Bearer Token".
    3.  **Mechanism**: If `Authorization: Bearer` exists (User Session), grant privileged Tier unconditionally (Trust Base).

### 13.6. The Pragmatic Casting Protocol (Type Survival)
*   **Law**: `as any` is prohibited, but intentional **Bridge Casting** for non-existent schema (Phantom Tables) is allowed temporarily.
*   **Action**: Use `src/types/database-extensions.ts` to define local extensions.

### 13.10. The Tenant-Aware Naming Protocol
*   **Law**: Distinguish resource names for SaaS.
*   **Action**: Use `site_` or `account_` prefix for tenant resources. Use `system_` only for immutable platform settings.
