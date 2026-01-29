# 60. Security & Privacy (CISO & Legal View)

> [!IMPORTANT]
> **Level 1 Priority: Absolute Compliance**
> Security and Legal Compliance are the **Highest Priority** at Google Antigravity.
> They override UX, Speed, and Profitability without exception.

> [!CRITICAL]
> **Supreme Directive**
> Protection of personal information and security ALWAYS takes precedence over functional requirements, deadlines, and costs.
> Code that violates this document MUST NOT be deployed to the production environment for any reason.

## 1. The Golden Rule
*   **Legal & Security > User Experience**:
    *   **Rule**: "If it's legally risky, do not provide it, even if users want it."
    *   **Example**: Reject "Login-free history view" if it carries privacy risks. Reject "Offline payment" if it carries security risks.
*   **Zero Trust Architecture**:
    *   Abandon the assumption that "Internal networks are safe". Verify every access and request.
    *   **Rule 10.1.1: The Untrusted Default**: Start by **"Distrusting" all access entities**, including internal IPs, admin accounts, and AI agents. Enforce **Authentication**, **Authorization**, and **Encryption** for ALL requests.

## 2. Legal Compliance
*   **Global Regulations**:
    *   **GDPR / CCPA / APPI**: Observe these privacy regulations as the minimum baseline.
    *   **Data Sovereignty**: Data belongs to users. Systematically guarantee Export/Delete rights.
*   **Local Regulations**:
    *   **Funds Settlement Laws**: Monitor deposit obligations for points/coins constantly (e.g., Japan's PSA).
    *   **Specified Commercial Transactions**: Clearly state all required legal info for paid services (e.g., Japan's Tokusho-ho).

### 2.1. The Legal Content Consistency Protocol (Terms/Privacy SSOT)
*   **Law**: Hardcoding legal documents (Terms of Service, Privacy Policy, etc.) in source code (`const TERMS = ...`) causes desynchronization, creating legal risk, and is thus prohibited.
*   **Action**:
    *   **SSOT (Single Source of Truth)**: Legal documents MUST treat **Headless CMS** or **Database** as the single source of truth.
    *   **DB Management**: All legal text should be managed as `text` columns in `site_settings` or dedicated tables, allowing non-engineers to immediately edit and publish via admin panel.
    *   **Versioning**: Maintain history using columns like `version`, `valid_from` for revision tracking, ensuring transparency for users to reference past terms.
    *   **No Code Deployment for Terms**: A design requiring app redeployment for legal wording fixes or typo corrections is considered a design defect.

## 3. Privacy by Design
*   **Data Minimization**:
    *   **Principle**: Collecting data "just in case" is prohibited. Reject inputs without legitimate business interest via Schema Validation (Zod, etc.).
    *   **Legal Hold**: Only data with legal retention obligations (payment history, etc.) should be isolated and stored in separate tables (Cold Storage) for specified periods.
    *   **Retention Policy**: Define data retention periods. Automatically delete or anonymize expired data.
    *   **Standard**: Time-limited data like campaigns should be physically deleted within **90 days** after end; general access logs within **1 year**.
*   **Consent Management**:
    *   **Opt-in**: Marketing and tracking must be Opt-in by default. Dark patterns are **strictly prohibited**.
    *   **Anonymized Usage Consent**: Mandate explicit consent during registration that "anonymized statistical data may be used for service improvement, research, or public interest".
*   **The Professional Advice Disclaimer**:
    *   **Law**: For services potentially containing professional advice (health, medical, legal, financial), physically display a disclaimer that "This service does not replace direct diagnosis or advice from professionals (veterinarians, doctors, lawyers, etc.)" in footers, critical operation screens, and Terms of Service.
*   **The "Right to be Forgotten"**:
    *   **Physical Deletion Mandate**: User account deletion (`deleteAccount`) MUST **physically delete (HARD DELETE)** records containing PII (email, name, address, phone, account info). Simply leaving personal info with a `deleted_at` flag (logical delete) is considered **GDPR violation** and serious privacy risk.
    *   **Anonymization Exception**: When retaining transaction data like purchase history, overwrite (Mask) PII columns with `NULL` or hash values to permanently sever link to individuals.
    *   **Backup Purge**: State in Terms of Service that deleted data in automatic DB backups (PITR) is completely eliminated after backup retention period (e.g., 7-30 days).
*   **The API Output Hygiene**:
    *   **Law**: Public API responses MUST physically remove (DTO processing) PII (Email, detailed address), Internal Params (IDs, notes), and Security Fields (Hash, Salt).
*   **The Sensitive Asset Mandate (Private Storage)**:
    *   **Law**: Confidential document images like certificates, appraisal reports, medical records MUST be stored in **private** buckets. `public` bucket usage is strictly prohibited.
    *   **Access**: File access must be provided only via server-generated **`Signed URL`** with short expiration (minutes to hours).
*   **Encryption at Rest & In Transit**:
    *   **PII Encryption**: Encrypt sensitive personal info in DB (account info, identity document IDs, detailed addresses) at application level using Supabase Vault or pgcrypto (`pgp_sym_encrypt`).
    *   **TLS 1.3**: Force HTTPS (TLS 1.2+, recommend 1.3) for all communications.

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

## 6. Infrastructure Security
*   **Network Isolation**:
    *   Place DBs and internal APIs in private VPCs.
*   **The Tokyo Mandate (Data Residency)**:
    *   **Law**: To meet enterprise compliance, production data storage (Region) MUST be fixed to **Tokyo (ap-northeast-1)** by standard.
    *   **Compliance**: Aggregate backup data (R2/S3) also to domestic regions unless legally exempt.
*   **The Database Fortress Protocol**:
    *   **Search Path Defenses**: MUST append `SET search_path = ''` (empty) to `SECURITY DEFINER` functions to physically cut dependency on search path. In functions, mandate **fully schema-qualified** references like `public.table_name`.
        *   **Reason (Trojan Horse)**: Without fixed `search_path`, Postgres creates vulnerability allowing attackers to swap tables. `SET search_path = public` is a compromise; empty is the only secure way.
    *   **Explicit RLS**: Policy `USING (true)` means unconditional open. MANDATE `TO service_role` or strict conditions. Discard "Secure by Default" illusions.
*   **Multi-Layered Defense**:
    *   **L1 (Edge/WAF)**: Use Cloud Armor / AWS WAF (Managed Rules) for GeoIP blocking and Bot detection to physically block malicious traffic and **EDoS (Resource Exhaustion)** attacks.
    *   **WAF Policy**: Always operate SQL Injection, XSS, Generic Attacks rulesets in **"Block" mode**.
    *   **App Check**: Block unauthorized API access using Firebase App Check.
    *   **Rate Limiting**:
        *   **Law**: For Public actions (Inquiry, Auth), MUST implement rate limits (e.g., 5/hour) via `checkRateLimit` to build Defense in Depth.
        *   **Fail Fast**: Return error immediately upon limit exceeded before DB connection or heavy processing to protect resources.
        *   **Implementation**: Use Vercel KV or Upstash Redis for high-speed edge blocking. Not burdening the DB is critical.
    *   **Middleware Matcher Safety**: Prohibit complex Regex in `middleware.ts` `config.matcher`. Opaque Regex breeds ReDoS and bypass risks. use readable Array format.

## 7. Offensive Security
*   **Self-Penetration Test**:
    *   Think like an attacker. Try XSS/SQLi on your own code.
    *   Start Security Rules from "Deny All".

## 8. Advanced Security Operations

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

### 8.1.1. The Tiered Security Protocol
*   **Law**: Apply security strength in stages according to operation risk (irreversibility/impact). Excessive auth is proof of "Incompetent System"; insufficient auth breeds security holes.
*   **Tier Definition**:
    *   **Tier 1 (Mild)**: General single deletion (Media, Comment), Archive, Status Change -> `Turnstile + Keyword Confirmation (Input "DELETE")` only. No OTP (UX priority).
    *   **Tier 2 (Strict)**: Bulk Delete, Folder Delete, Critical Settings, **Vital Data Single Delete (User, Plan, Payment)** -> `Turnstile + Keyword Confirmation + High Security Auth (OTP/MFA) Mandatory`.
*   **Action**: When implementing new features, MUST check existing similar features and implement 100% identical behavior. "Similar but different" is an integrity bug.

### 8.2. The Audit Log Obligation (No Invisible Hands)
    *   **The Audit Log Obligation**: DB writes bypassing audit logs are security Blind Spots. Critical operations (Create/Update/Privilege Change) MUST be recorded with `actor_id`, `action`, `resource`, `details`.
    *   **The Privileged Data Access Audit (High-Sensitivity Mandate)**:
        *   **Context**: Third parties (Staff, Experts) viewing user's confidential/sensitive records (Health, Assets, ID) is "Custody of Trust" carrying maximum responsibility.
        *   **Law**: When third parties perform **Read (SELECT)** on high-sensitivity resources, physically force input of **"Reason for Access"** and record history.
        *   **Retention**: This access log MUST be **Permanently Retained** as powerful deterrent against unauthorized access and proof of accountability.
    *   **The Immutable Log Mandate (WORM)**:
        *   **Law**: `audit_logs` table must be **Append-Only**; physically prohibit `UPDATE` and `DELETE` via RLS policies.
        *   **Archiving**: Old logs must be deleted ONLY via automatic partition management (pg_partman) or TTL; manual human operation is banned.

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
    *   **Official Link**: Use `supabase link` (Connection Pooler) or verify appropriate routing. (See Check `37_backend_supabase.md` Rule 7.2).

### 8.12. The No Security Bypass Penalty
*   **Law**: Temporarily disabling security features (SSL verification, CORS, Auth Middleware) for development efficiency or CI passing is strictly prohibited.
*   **Action**: Immediate Revert upon discovery; treated as Serious Constitution Violation.

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

### 8.16. The Digital Legacy Protocol (Inheritance)
*   **Problem**: Avoid risk of losing access to "Data of Life (Assets, Health)" in locked account upon contract holder's death/unconsciousness.
*   **Law**: Recommend designing "Emergency Contact (Emergency Access)" features.
*   **Inheritance**: Maintain architecture where designated heirs can inherit Read-Only access to minimum necessary info (Lifeline, Critical Health Info) in emergency based on agreed protocol, even before legal procedures complete.

### 8.17. The Incident Response & Drill Protocol
*   **Law**: Delayed initial response to security incidents (Leak, Hack) is a fatal blunder expanding secondary damage.
*   **Action**:
    1.  **Semi-Annual Drills**: Conduct **Response Drills** assuming pseudo-incidents (Leak, Attack) every 6 months to verify contact network and Kill Switch procedures.
    2.  **Post-Mortem Obligation**: After incident, mandatorily verbalize "Why it happened" and "How to prevent recurrence", updating the Blueprint.

## 9. The Victory Protocol (Standard of Excellence)
*   **The Iron Fortress Mandate**: We maintain a "Fortress", not just an app.
    1.  **Zero Warning Enforcement**: PRs with even 1 Security Advisor / Performance Advisor warning are automatically **Rejected**.
    2.  **No "True"**: `USING (true)` and `WITH CHECK (true)` in RLS policies are forbidden under any reason. MUST use `TO service_role` or strict conditions.
    3.  **No "No Policy"**: `RLS Enabled` with no policies (INFO warning) is absolutely unacceptable.
    4.  **Admin Lock**: Admin tables must be defended with `role = 'admin'`.
*   **Strategic Exception (Info Acceptance)**: Only "Info" level warnings like `unused_index` are Accepted if intentional design, but "Over-defense" (deleting necessary index to remove warning) is prohibited.

### 9.1. The Semantic Error Consistency Protocol (RFC 7807+)
*   **Law**: API Error responses MUST be returned in **RFC 7807 (Problem Details for HTTP APIs)** or compliant standardized JSON format.
*   **Mandate**:
    *   `type`: URI identifying error type.
    *   `title`: Abstract error description readable by humans.
    *   `status`: HTTP status code.
    *   `detail`: Specific problem description (excluding secrets).
    *   `instance`: URI of occurrence.
*   **Action**: Client (UI) must construct error info from backend with "Hospitality" to display this `title` or `detail` directly in dialogs.
