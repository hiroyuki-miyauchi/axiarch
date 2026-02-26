# 60. Security & Privacy (CISO & Legal View)

> [!IMPORTANT]
> **Level 1 Priority: Absolute Compliance**
> Security and Legal Compliance are the **Highest Priority** at Google Antigravity.
> They override UX, Speed, and Profitability without exception.

> [!CRITICAL]
> **Supreme Directive**
> Protection of personal information and security ALWAYS takes precedence over functional requirements, deadlines, and costs.
> Code that violates this document MUST NOT be deployed to the production environment for any reason.

### 8.1. The Double Security Protocol (Rule 0.0: Turnstile + OTP Mandate)
*   **Law**: All critical security operations (Login, Register, PW Change, Email Change, Delete Account, etc.) MUST implement **Double Defense**: "Managed Turnstile" and "OTP".
*   **Outcome**:
    1.  **Layer 1 (Pre-Auth & Physical Blocking)**:
        *   Mandate **Managed Turnstile** (`appearance: 'always'`) to visualize "Authenticating".
        *   **Physical Lock**: The submit button MUST be **physically disabled** until verification (`onSuccess`) callback fires. Making users wait for "invisible processing" is a UX defect and security risk.
    2.  **Layer 2 (Auth)**: Do NOT allow final data mutation (UPDATE/DELETE) until identity verification via **OTP** (Email/Authenticator) is complete.
    3.  **Fail-Safe Mechanism**: Build a flow that immediately disables the button and resets state upon error or token expiration (`onExpire`), prompting retry.
    4.  **No Exception**: Security robustness is top priority; no UX-prioritized exceptions allowed.
    5.  **Scope Limitation**: Apply this protocol ONLY to critical "Vital Operations", not daily operations (Drafts, View Toggle).
    6.  **Security Incentive Program**: Recommend designing system benefits (relaxed rewrite limits, advanced features) for users enabling high-security auth (MFA). "Security is a benefit, not a burden".

### 8.2. The Audit Log Obligation (No Invisible Hands)
    *   **The Audit Log Obligation**: DB writes bypassing audit logs are security Blind Spots. Critical operations (Create/Update/Privilege Change) MUST be recorded with `actor_id`, `action`, `resource`, `details`.
    *   **The Privileged Data Access Audit (High-Sensitivity Mandate)**:
        *   **Context**: Third parties (Staff, Experts) viewing user's confidential/sensitive records (Health, Assets, ID) is "Custody of Trust" carrying maximum responsibility.
        *   **Law**: When third parties perform **Read (SELECT)** on high-sensitivity resources, physically force input of **"Reason for Access"** and record history.
        *   **Retention**: This access log MUST be **Permanently Retained** as powerful deterrent against unauthorized access and proof of accountability.
    *   **The Immutable Log Mandate (WORM)**:
        *   **Law**: `audit_logs` table must be **Append-Only**; physically prohibit `UPDATE` and `DELETE` via RLS policies.
        *   **Archiving**: Old logs must be deleted ONLY via automatic partition management (pg_partman) or TTL; manual human operation is banned.
    *   **The Immutable Record Protocol (Edit Window + Correction Log)**:
        *   **Law**: Important factual records (health records, contract history, asset registers, inspection results, etc.) MUST be treated as "facts" that should not be easily altered once confirmed.
        *   **Edit Window**: User edits and deletions MUST be restricted to **within a defined time period** (recommended: 24 hours) after record creation. Direct modifications after the deadline are prohibited.
        *   **Correction Log**: When corrections are needed after the deadline, create a separate record as a **"Correction Log"** while preserving the original record, recording the correction reason and corrector. This physically prevents tampering with the original.
        *   **Rationale**: In domains such as medical, legal, and financial, tamper prevention and traceability may be legal requirements. The Edit Window is a balanced design that ensures convenience while guaranteeing irreversibility after confirmation.

### 8.3. The Information Disclosure Protocol (Error Masking - Rule 8.3)
*   **Law**: Physically prohibit displaying internal info (Table names, Column names, Stack traces, Raw API responses) to end users in error messages (especially Production).
*   **Action**:
    1. Catch errors server-side and log details (`error_logs`).
    2. Return only abstract messages like "An error occurred (Error ID: xxxxx)" to frontend, cutting off hints (Information Disclosure) to attackers.

### 8.4. The Zero Trust DTO Flow (Rule 8.4)
*   **Law**: Returning raw DB records (`Row`) in API/Server Action responses is **Forbidden at Highest Level**.
*   **Action**:
    1. All data output MUST go through **DTO (Data Transfer Object)** interfaces.
    2. **Strict Segregation**: Physically separate Public DTO (`PublicUserDTO`) and Admin DTO (`AdminUserDTO`). Admin DTO usage outside `/admin` context is banned.
    3. Enforce Allowlist approach (explicitly select needed fields only) to structurally defend against "Unintended Leakage" of future sensitive columns.

### 8.5. The Security Verification Mandate (Rule 8.5)
*   **Law**: Confirming code is "correct" does not complete security.
*   **Action**: When making security-related changes (RLS, Auth Flow), MUST physically verify **"Unauthorized user gets error (Negative test)"** on actual DB and record result as evidence. Deployment based on desk theory alone is strictly prohibited.

### 8.6. The Privacy Guardrail Protocol (Admin Firewall)
*   **Law**: Admin operators accidentally publishing personal phone numbers or emails in official announcements/LPs is "The Ultimate Shame".
*   **Action**:
    1.  **Client-Side Scan**: Implement logic to regex-scan entire content when saving in Admin Panel.
    2.  **Explicit Consent**: If PII patterns (Phone, Email) detected, MUST warn via `confirm()` dialog and physically block save unless "Explicit Approval" is given.

### 8.7. The Admin DTO Defense (Strict Output Hygiene)
*   **Law**: Being in Admin Panel (`/admin`) does not justify sending all DB columns directly to frontend. This invites leakage of future confidential columns (Cost, Supplier Contacts, Internal Notes).
*   **Action**: Even in Admin APIs (`getAdminUsers`), MUST define dedicated **DTO (`AdminUserDTO`)** and explicitly select only needed fields. `SELECT *` is strictly prohibited.

### 8.8. The PII Logging Defense (Masking Protocol)
*   **Action**: Implement logic in Logger class to automatically replace fields containing keywords like `password`, `token` with `***MASKED***` to prevent leaks from developer error.

### 8.9. The Security-UX Balance Protocol (No Friction Mandate)
*   **Law**: Sacrificing UX with "Security" as excuse is **Complete Defeat** in system design. Excessive auth is proof of **"Incompetent System"**, causing user churn and damaging service value.
*   **Action**:
    1.  **Critical Actions Only**: Require Turnstile/OTP ONLY at final stage of "Irreversible or High-Risk Operations" (DB Write, Critical Settings, Payment).
    2.  **No UI Friction**: Demanding auth during "Exploration/Intermediate Operations" like opening modals, switching tabs, uploading files is **Strictly Prohibited**.
    3.  **Daily Operation Exemption**: **"Daily Operations without irreversible destruction/payment"** like Draft Save, AI Generation, UI switching MUST be exempt from Turnstile/OTP. System is obligated to judge Context/Criticality.
    4.  **Context Awareness**: Forcing re-auth for minor actions in already authenticated sessions is considered "Lack of Trust" in users.

### 8.10. The Strict Nonce Protocol (Highest Security Mandate)
*   **Law**: Easily adding `'unsafe-inline'` or `'unsafe-eval'` to bypass blocks on external scripts (Turnstile, GTM) is "Total Abandonment of Defense" and developer's defeat. Immediate Failure in Elite Audit.
*   **Action**:
    1.  **Nonce-First Protocol**: Propagate `nonce` generated in `Next.js` headers/middleware to all inline scripts and external widgets, physically proving to browser "This code belongs to the legitimate master".
    2.  **Strict CSP**: Always defend **Strict CSP** settings in `Content-Security-Policy` header.
    3.  **No Scapegoating**: "Library is old so temporarily allow" is prohibited. Solve the root cause (Library selection, Nonce implementation).

### 8.11. The IPv6 Deployment Protocol (Connection Hygiene)
*   **Law**: Mandate appropriate configuration to prevent connection errors due to IPv6 name resolution issues between CI environments (GitHub Actions) and Supabase.
*   **Action**:
    *   **Official Link**: Use `supabase link` (Connection Pooler) or verify appropriate routing. (See Check the 370-series (Backend & Supabase) Rule 7.2).

### 8.12. The No Security Bypass Penalty
*   **Law**: Temporarily disabling security features (SSL verification, CORS, Auth Middleware) for development efficiency or CI passing is strictly prohibited.
*   **Action**: Immediate Revert upon discovery; treated as Serious Constitution Violation.
*   **Prohibited Examples**:
    - `NODE_TLS_REJECT_UNAUTHORIZED=0` (Disabling SSL verification)
    - `Access-Control-Allow-Origin: *` (Permitting all origins in production)
    - Commenting out or skipping Auth Middleware verification logic

*   **Official Link**: Use `supabase link` (Connection Pooler) or verify appropriate routing. (See Check `37_backend_supabase.md` Rule 7.2).
