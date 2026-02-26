# 60. Security & Privacy (CISO & Legal View)

## 4. Security Architecture
*   **Supply Chain Security**:
    *   **Dependency Watch**: Regularly run `npm audit` and apply patches within 24 hours for High/Critical vulnerabilities or implement workarounds. Periodically remove unused dependencies to minimize Attack Surface.
*   **Authentication & Authorization**:
    *   **Credential Hygiene**: Physically prohibit writing API Keys, secrets, DB connection strings in source code (No Hardcoding). Always use `process.env`, share secrets via encrypted channels like 1Password (Slack paste forbidden).
    *   **MFA**: **Mandatory MFA** for all admin accounts. No exceptions.
    *   **Admin Privilege Verification Standard**: MUST use **`public.profiles` table `role` column** (e.g., `role = 'admin'`) as SSOT for admin privilege verification. Frontend flags or legacy `admin_users` table dependencies are security hole breeding grounds.
    *   **Official Content Protection**: Creation/update/delete of official content like `news` or `column` is strictly limited to **"Admin" or "Editor"** privilege users. Simple login check (`auth.uid()`) is insufficient.
    *   **IDaaS**: Don't build your own auth infrastructure. Use verified solutions (Firebase Auth, Auth0, Cognito).
    *   **Omnichannel Auth**: The system must fully support **Bearer Token (JWT)** access from native apps, not just Web cookies. Skipping verification in Server Actions because "web session exists" is prohibited.
    *   **The Guardian Protocol (Centralized Auth)**: Prohibit scattered privilege check logic (DRY violation, leak risk). MUST use centralized guard classes/functions like `src/lib/auth/admin-guard.ts` (AdminGuard) for verification; writing custom `supabase.from('user_roles')...` is strictly prohibited as "Anti-Pattern".
*   **API Key Security**:
    *   **Hashing Mandate**: API Keys (`sk_live_...`) MUST **NEVER be stored in plain text**. Mandate "same treatment as passwords": hash with SHA-256 etc. before storage and hash input values for verification.
    *   **Dual Auth Protocol**: Middleware should accept both `X-API-KEY` (System) and `Authorization: Bearer` (User), implementing "OR condition" to pass if either is valid, seamlessly allowing access from native apps (VIP Lane). Recommend design automatically granting equivalent privileges to logged-in users (Bearer Token) without API Key.
*   **OWASP Top 10**:
    *   **Injection**: Use ORMs or parameterized queries to prevent SQL/NoSQL injection.
    *   **Strict Validation**: Assume all client input is "tainted"; strictly validate types and values using **Zod** schema validation. Reject invalid data before reaching DB.
    *   **Access Control**: Strictly check RLS/Security Rules for every endpoint to verify if requesting user has permission for that resource.

## 5. License & ToS Compliance
*   **License Contamination Prevention**:
    *   **No GPL**: Copyleft licenses (GPL, AGPL) are **banned**.
    *   **Permissive Only**: Use MIT, Apache 2.0, BSD, ISC.
    *   **CI Check**: Automate license scanning in CI/CD.
*   **Platform ToS**:
    *   **Google/Apple**: Never violate platform ToS (Scraping, Review manipulation). Account bans mean business death.

# 60. Security & Privacy (CISO & Legal View)

> [!IMPORTANT]
> **Level 1 Priority: Absolute Compliance**
> Security and Legal Compliance are the **Highest Priority** at Google Antigravity.
> They override UX, Speed, and Profitability without exception.

> [!CRITICAL]
> **Supreme Directive**
> Protection of personal information and security ALWAYS takes precedence over functional requirements, deadlines, and costs.
> Code that violates this document MUST NOT be deployed to the production environment for any reason.

### 8.1.1. The Tiered Security Protocol
*   **Law**: Apply security strength in stages according to operation risk (irreversibility/impact). Excessive auth is proof of "Incompetent System"; insufficient auth breeds security holes.
*   **Tier Definition**:
    *   **Tier 1 (Mild)**: General single deletion (Media, Comment), Archive, Status Change -> `Turnstile + Keyword Confirmation (Input "DELETE")` only. No OTP (UX priority).
    *   **Tier 2 (Strict)**: Bulk Delete, Folder Delete, Critical Settings, **Vital Data Single Delete (User, Plan, Payment)** -> `Turnstile + Keyword Confirmation + High Security Auth (OTP/MFA) Mandatory`.
*   **Action**: When implementing new features, MUST check existing similar features and implement 100% identical behavior. "Similar but different" is an integrity bug.

### 8.1.2. The Security-UX Balance Protocol
*   **Law**: Excessive security demands (unnecessary Turnstile/OTP prompts) reduce operator productivity and ultimately decrease service adoption. Security is NOT an excuse to sacrifice UX.
*   **Action**:
    1.  **Critical Actions Only**: Require Turnstile/OTP authentication ONLY at the final stage of "irreversible or high-risk operations" such as DB writes (Save/Publish/Delete) or critical setting changes.
    2.  **No UI Friction**: Inserting authentication into "exploratory/intermediate operations" such as opening modals, switching tabs, or selecting files (before upload) is **strictly prohibited**.
    3.  **Context Awareness**: Forcing re-authentication for minor operations within an already-authenticated session is considered "lack of trust" and a system design flaw.
*   **Rationale**: Systems that repeatedly demand excessive authentication from users ultimately induce Security Fatigue, causing users to dismiss truly important authentication — producing the opposite of the intended effect.
