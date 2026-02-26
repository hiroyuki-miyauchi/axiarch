# 60. Security & Privacy (CISO & Legal View)

### 8.13. The Infrastructure Reality Protocol (WebAuthn/MFA)
*   **Law**: Even if code is correct, if infrastructure settings (Supabase Dashboard MFA enabled) are off, feature fails.
*   **Action**: Impose "Pre-check Obligation" to verify console settings before implementing advanced auth features.
*   **Graceful Failure**: Mandate fallback to return appropriate feedback "Currently unavailable" instead of crashing if feature is unusable due to infra settings.

### 8.14. The Secret Rotation Lifecycle
*   **Lifecycle**: IAM credentials and JWT signing keys MUST be rotated every **90 days**.
*   **Panic Button**: Keep "Kill Switch" procedure up-to-date to invalidate all sessions instantly in case of leakage.

### 8.15. The Physical Master Key (Bus Factor Defense)
*   **Risk**: Admin PC loss, forgotten credentials, or permanent access loss due to accident.
*   **Law**: Mandate **Analogue Backup** of vital recovery info recorded on "Physical Media (Paper)" and stored in fireproof safe, not just digital.
*   **Scope**:
    1. Supabase `service_role` key (Emergency Access)
    2. Cloudflare Super Admin Recovery Code
    3. Domain Registrar Lock Code
    4. Master Key of Main Auth Manager (1Password etc.)
*   **Mandate**: Maintain state where "Recovery is possible with one piece of paper even if digital vanishes".

### 8.15.1. The RBAC Defense Protocol
*   **Law**: All Admin APIs/Actions MUST enforce RBAC checks at the very beginning of processing, with tiered additional authentication and mandatory audit log recording based on operation risk level.
*   **Action**:
    1.  **Entry Point Guard**: At the beginning of every Admin API/Action, invoke the centralized permission check function (see Guardian Protocol) to execute role-based access control.
    2.  **Tiered Additional Auth**: Operations involving finances, privileges, or deletion (Tier 2/3 equivalent) MUST require additional Turnstile/OTP authentication on top of the RBAC check.
    3.  **Mandatory Audit**: All Admin operations MUST be recorded in audit logs without exception. Destructive operations (DELETE, privilege changes, setting changes) in particular MUST retain before/after diffs.
*   **Rationale**: Standardizing the three layers of RBAC check + additional auth + audit logging as a common pattern for all Admin APIs structurally eliminates omissions from individual implementations.

### 8.16. The Digital Legacy Protocol (Inheritance)
*   **Problem**: Avoid risk of losing access to "Data of Life (Assets, Health)" in locked account upon contract holder's death/unconsciousness.
*   **Law**: Recommend designing "Emergency Contact (Emergency Access)" features.
*   **Inheritance**: Maintain architecture where designated heirs can inherit Read-Only access to minimum necessary info (Lifeline, Critical Health Info) in emergency based on agreed protocol, even before legal procedures complete.

### 8.17. The Incident Response & Drill Protocol
*   **Law**: Delayed initial response to security incidents (Leak, Hack) is a fatal blunder expanding secondary damage.
*   **Action**:
    1.  **Semi-Annual Drills**: Conduct **Response Drills** assuming pseudo-incidents (Leak, Attack) every 6 months to verify contact network and Kill Switch procedures.
    2.  **Post-Mortem Obligation**: After incident, mandatorily verbalize "Why it happened" and "How to prevent recurrence", updating the Blueprint.

# 60. Security & Privacy (CISO & Legal View)

> [!IMPORTANT]
> **Level 1 Priority: Absolute Compliance**
> Security and Legal Compliance are the **Highest Priority** at Google Antigravity.
> They override UX, Speed, and Profitability without exception.

> [!CRITICAL]
> **Supreme Directive**
> Protection of personal information and security ALWAYS takes precedence over functional requirements, deadlines, and costs.
> Code that violates this document MUST NOT be deployed to the production environment for any reason.

*   **Self-Penetration Test**:
*   Think like an attacker. Try XSS/SQLi on your own code.
*   Start Security Rules from "Deny All".
