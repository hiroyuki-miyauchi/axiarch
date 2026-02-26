# 60. Security & Privacy (CISO & Legal View)

### 9.7. The Role Enumeration Symmetry Mandate
*   **Law**: Multiple guard functions verifying the same domain (e.g., admin privileges) — for page access, APIs, Server Actions, etc. — MUST obtain their allowed role lists from a **shared constant array**.
*   **Action**:
    1.  **Shared Constants**: Define allowed role lists as a single constant such as `ALLOWED_ADMIN_ROLES`, and have all guard functions reference this constant. Individually enumerating roles as literal strings within each function is prohibited.
    2.  **Full-Count Verification**: When adding, modifying, or deleting roles, mandate a full inspection of all guard functions referencing that role across the entire project.
    3.  **Failure Transparency**: Guard failures due to role mismatches should display clear error messages to users, and in development environments, use `Logger.warn` for immediate inconsistency detection.
*   **Rationale**: Inconsistencies such as including `master_admin` in the page access guard but not in the Server Action guard cause extremely opaque deadlocks where users "can access the admin panel but writes always fail." Structural sharing of role enumeration physically prevents this class of inconsistency.
*   **Anti-Pattern**: `requireAdmin` and `ensureAdminAction` each maintaining independent string literals `['admin', 'super_admin']`, with only one being updated when a new role is added.

### 9.9. The Anti-Permissive RLS Mandate
*   **Law**: In Row Level Security (RLS) policy design, **creating excessively permissive policies is prohibited**. Clarify intent and strictly adhere to the principle of least privilege.
*   **Action**:
    1.  **No `FOR ALL` Policy**: `FOR ALL` permits all operations (`SELECT`, `INSERT`, `UPDATE`, `DELETE`) at once, making permission granularity coarse and intent difficult to understand. Create individual policies per operation.
    2.  **No `WITH CHECK (true)`**: `WITH CHECK (true)` means "anyone can write unconditionally." Always set conditions for write operations (e.g., `auth.uid() = user_id`).
    3.  **Limited `USING (true)` Usage**: `USING (true)` is only acceptable for `SELECT` policies on public data. `USING (true)` for `UPDATE` or `DELETE` is prohibited in principle.
    4.  **Policy Naming Convention**: Name policies in the format `tablename_action_role_policy` (e.g., `posts_select_authenticated_policy`), making policy intent immediately understandable from the name.
*   **Rationale**: RLS is the "last bastion" of data access. Excessively permissive policies increase the risk of data leakage and tampering through application-layer bugs or direct API access. The principle of least privilege physically blocks unexpected access.

### 9.10. The Cryptographic Randomness Mandate
*   **Law**: Using `Math.random()` for security purposes (password generation, token generation, Nonce generation, session IDs, etc.) is a **Mortal Sin**. `Math.random()` is not cryptographically secure (PRNG) and produces predictable output, allowing attacker prediction.
*   **Action**:
    1.  **Client-Side**: MUST use `window.crypto.getRandomValues()`.
    2.  **Server-Side (Node.js)**: MUST use `crypto.randomBytes()` or `crypto.randomUUID()`.
    3.  **Framework Integration**: Prefer framework-provided cryptographically secure random generation functions (e.g., `crypto.randomUUID()`) when available.
*   **Rationale**: Only CSPRNG (Cryptographically Secure Pseudo-Random Number Generator) guarantees unpredictability of tokens and secrets. `Math.random()` generation is vulnerable to brute-force attacks.

### 9.11. The Cookie Scope Protocol
*   **Law**: When storing temporary authentication state or permission info in Cookies, scope MUST be minimized and isolated per resource.
*   **Action**:
    1.  **Specific Naming**: Use resource-specific, unique namespaced Cookie names like `{purpose}_{resource_id}`. Overuse of generic names (`auth_token`, `session`, etc.) increases Cookie Tossing risk.
    2.  **Attribute Armor**: MUST apply security attributes:
        *   `HttpOnly`: Block JavaScript access to prevent XSS-based Cookie theft.
        *   `Secure`: Send Cookies only over HTTPS in production.
        *   `SameSite=Lax` (or `Strict`): Prevent CSRF attacks.
    3.  **Minimal Lifetime**: Set temporary auth Cookie expiration to the shortest period appropriate for its purpose.
*   **Rationale**: Overly broad Cookie scope increases risk of authentication state contamination across resources and unauthorized session hijacking by attackers.

### 9.12. The Server-Side Storage Guard Protocol
*   **Law**: Direct client-side file uploads to storage services (S3, Cloud Storage, Supabase Storage, etc.) from public site forms is prohibited.
*   **Action**:
    1.  **Server Delegation**: Clients MUST send files to **Server Action / API Route**, and uploads should be executed server-side using privileged client credentials.
    2.  **Path Control**: Storage paths (Slug/UUID, etc.) MUST be generated and validated server-side only; client-specified paths are not permitted (Path Traversal prevention).
    3.  **Validation**: Re-validate file MIME type, size, and extension server-side. MUST NOT rely solely on client-side validation.
*   **Rationale**: Direct client-side uploads bypass server-side audit logs, validation, and path normalization, creating a "governance hole" that allows malicious file injection and storage path tampering.
