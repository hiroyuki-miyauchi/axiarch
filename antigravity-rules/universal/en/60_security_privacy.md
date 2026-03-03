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
*   **Privacy Impact Assessment (PIA)**:
    *   **Law**: Before implementing features that handle PII, you MUST create a Privacy Impact Assessment document specifying data types, storage locations, access permissions, and retention periods, and pass review.
    *   **Action**:
        1.  **PIA Document**: When adding features that collect/process new PII, document the data types, storage locations, access permissions, and retention periods.
        2.  **Purpose Limitation**: Explicitly state collection purposes in Terms of Service and prohibit secondary use both technically and operationally. Obtain re-consent when purposes change.
        3.  **Transparency**: Provide a UI that explains to users in plain language "what data, why, for how long" it is retained.
        4.  **Data Flow Mapping**: Diagram PII flows within the system (input → storage → reference → external integration → deletion) and document protection measures at each point.
        5.  **PR Review Gate**: Include "PIA Completed" as a review checklist item for PRs introducing new features.
    *   **Rationale**: Privacy protection must be "built in by design" not "addressed after the fact" — this is the international standard (ISO 31700, GDPR Art.25).
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
*   **The Granular Sharing Protocol (Sharing Scope Control)**:
    *   **Law**: When implementing data sharing features between users, recommend a design that allows specifying **"sharing scope (Public / Limited Members Only / Owner Only)"** at the **record level or field level**, beyond simple view/edit permissions.
    *   **Default Private**: Fields with high confidentiality such as payment information, personal notes, and detailed health records MUST default to **"Owner Only (Private)"**, preventing them from being included in shared data without explicit user action.
    *   **Visibility Matrix**: Sharing settings MUST be enforced via RLS (Row Level Security) or application logic layer, not relying solely on frontend display controls.
*   **Encryption at Rest & In Transit**:
    *   **PII Encryption**: Encrypt sensitive personal info in DB (account info, identity document IDs, detailed addresses) at application level using Supabase Vault or pgcrypto (`pgp_sym_encrypt`).
    *   **TLS 1.3**: Force HTTPS (TLS 1.2+, recommend 1.3) for all communications.

## 4. Security Architecture
*   **Supply Chain Security**:
    *   **Dependency Watch**: Regularly run `npm audit` and apply patches within 24 hours for High/Critical vulnerabilities or implement workarounds. Periodically remove unused dependencies to minimize Attack Surface.
    *   **The Dependency Vulnerability Patrol Protocol**:
        *   **CI Integration**: Automatically run `npm audit --audit-level=high` in CI on PR creation against the `main` branch.
        *   **Merge Block**: **Block PR merge** when `high` or above vulnerabilities are detected.
        *   **Response SLA**:
            | Vulnerability Level | Response Deadline | Action |
            |:-------------------|:-----------------|:--------|
            | **Critical / High** | **Within 72 hours** | Apply immediate patch or implement impact mitigation |
            | **Medium** | **Within 2 weeks** | Address in next sprint |
            | **Low** | **Next major release** | Address in batch update |
        *   **Auto-Update**: Introduce Renovate or Dependabot to auto-generate dependency update PRs.
        *   **Prohibitions**: Wildcard (`*`) version specifications in `package.json` and production deployments with High+ vulnerabilities outstanding are prohibited.
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
*   **Email Domain Authentication Protocol**:
    *   **Mandate**: To guarantee email deliverability and prevent spoofing, all 3 of the following DNS authentications **must** be configured.

        | Authentication | Target | Purpose |
        |:--------------|:-------|:--------|
        | **SPF** | TXT Record | Sender server legitimacy verification |
        | **DKIM** | TXT Record | Email content tampering detection |
        | **DMARC** | TXT Record | Policy definition for SPF/DKIM failures |

    *   **DMARC Policy**: Recommended staged strengthening: `p=none` (monitor) → `p=quarantine` (quarantine) → `p=reject` (reject).
    *   **Monitoring**: Periodically review DMARC Aggregate Reports to detect spoofing attempts.
    *   **Prohibition**: Sending system emails from free email addresses (`@gmail.com`, etc.) is prohibited.
*   **Email Domain Separation Protocol**:
    *   **Law**: Transactional emails (password reset, payment confirmation, etc.) and marketing emails (newsletters, etc.) **must use different sender addresses**.
    *   **Rationale**: This is a mandatory measure to prevent marketing email unsubscribes or spam classification from affecting transactional email deliverability.
    *   **Reply-To**: Even when sending from `noreply@`, set a support address in the `Reply-To` header so that user replies reach the support team.
*   **Webhook Security Protocol**:
    *   **Context**: Webhooks from external services are susceptible to forgery and replay attacks. Verification is mandatory for all receiving endpoints.
    *   **Mandate**:
        *   **Signature Verification (Mandatory)**:
            *   Verify the `signature` header of all Webhook requests using **HMAC-SHA256** or equivalent.
            *   Immediately return `401 Unauthorized` for requests with mismatched signatures and record in alert logs.
            *   Manage signature secrets via environment variables (see Credential Hygiene).
        *   **Replay Attack Prevention**:
            *   Validate the `timestamp` in the Webhook payload and **reject requests older than 5 minutes**.
            *   Cache processed event IDs for a defined period to prevent duplicate execution.
        *   **Idempotency Guarantee**:
            *   Even if the same `event_id` Webhook arrives multiple times, side effects MUST occur only once.
            *   Use the Webhook-unique ID as an idempotency key and perform duplicate checks in DB before processing.
        *   **Error Handling**:
            *   Return `500` on processing failure and rely on the sender's retry mechanism.
            *   Build a mechanism to trigger alert notifications on consecutive failures (e.g., 3 or more).
    *   **Cross-Reference**: §4 (Credential Hygiene), §8.2 (Audit Log Obligation)

## 7. Offensive Security
*   **Self-Penetration Test**:
    *   Think like an attacker. Try XSS/SQLi on your own code.
    *   Start Security Rules from "Deny All".
*   **Penetration Test Schedule**:

    | Type | Frequency | Scope |
    |:-----|:----------|:------|
    | **Automated Vulnerability Scan** | Monthly | All public endpoints |
    | **Manual Penetration Test** | Annually | Auth, Payments, Admin panel |
    | **Ad-hoc Test** | As needed | After major feature changes |

*   **OWASP Top 10 Check Mandate**:
    *   Cover all Top 10 items including Injection (SQL/NoSQL), Broken Authentication, XSS, CSRF, SSRF, etc.
    *   Record pass/fail per item and commence remediation for failures within **48 hours**.
    *   Scope: All public API endpoints, admin panel (auth bypass, privilege escalation), RLS policies, file upload functions.
    *   Classify results as Critical/High/Medium/Low and record in the lessons log.
*   **The Security Training Protocol**:
    *   **Law**: Technical measures alone cannot guarantee security. Continuous improvement of developer knowledge and security awareness is essential.
    *   **Training Program**:
        | Type | Frequency | Target | Content |
        |:-----|:----------|:-------|:--------|
        | **Onboarding Training** | On hire | All developers | OWASP Top 10, Access Control basics, PII handling |
        | **Regular Training** | Annually | All developers | Latest threat trends, Incident case reviews |
        | **Incident Response Drill** | Semi-annually | Lead+ | Simulated drill based on Incident Response Plan |
    *   **Required Knowledge Checklist**:
        *   SQL Injection prevention (Parameter binding, Access control)
        *   XSS prevention (Template engine auto-escaping + CSP)
        *   CSRF prevention (SameSite Cookie + Origin verification)
        *   Authentication vs Authorization separation (Zero Trust principle)
        *   PII handling rules (Log masking, Encryption)
        *   Environment variable management (Secret handling)
    *   **Record Obligation**: Maintain training attendance records and suspend code review approval privileges for non-attendees.


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

### 8.1.2. The Security-UX Balance Protocol
*   **Law**: Excessive security demands (unnecessary Turnstile/OTP prompts) reduce operator productivity and ultimately decrease service adoption. Security is NOT an excuse to sacrifice UX.
*   **Action**:
    1.  **Critical Actions Only**: Require Turnstile/OTP authentication ONLY at the final stage of "irreversible or high-risk operations" such as DB writes (Save/Publish/Delete) or critical setting changes.
    2.  **No UI Friction**: Inserting authentication into "exploratory/intermediate operations" such as opening modals, switching tabs, or selecting files (before upload) is **strictly prohibited**.
    3.  **Context Awareness**: Forcing re-authentication for minor operations within an already-authenticated session is considered "lack of trust" and a system design flaw.
*   **Rationale**: Systems that repeatedly demand excessive authentication from users ultimately induce Security Fatigue, causing users to dismiss truly important authentication — producing the opposite of the intended effect.

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
    *   **The Action Instrumentation Mandate**:
        *   **Law**: ALL Server Actions / API handlers that mutate database state (`create`, `update`, `delete`, etc.) MUST have audit log recording instrumented **near the top of the function**, without exception.
        *   **Zero Blind Spots**: Operations without an audit trail are considered "non-existent". Implementations that cannot respond to legal requests or incident investigations are deemed unacceptable.
        *   **Cross-Reference**: `61_legal_data_privacy.md` §2 (Legal Snapshot Protocol)

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

### 8.7.1. The Select Specification Mandate
*   **Law**: Using `SELECT *` or ORM's `.select('*')` for database data retrieval is **universally prohibited**. All queries MUST explicitly select only the columns required for their specific purpose.
*   **Action**:
    1.  **Purpose-Specific Select**: Define required column sets per use case (public, admin, internal processing, etc.) and ensure queries explicitly select columns according to these definitions.
    2.  **DTO Alignment**: Selected columns MUST align with the corresponding DTO (Data Transfer Object) fields. Do not include "fetched but unused columns" in responses.
    3.  **Future-Proofing**: Using `SELECT *` risks unintentionally including sensitive columns (cost, internal notes, PII, etc.) added to tables in the future. Explicit selection structurally prevents this "unknown column leakage."
*   **Rationale**: Explicit column selection delivers triple benefits: ① Structural prevention of PII leakage, ② Performance improvement by reducing unnecessary data transfer and parsing overhead, ③ Improved code readability and intent clarity.

### 8.8. The PII Logging Defense (Masking Protocol)
*   **Action**: Implement logic in Logger class to automatically replace fields containing keywords like `password`, `token` with `***MASKED***` to prevent leaks from developer error.

### 8.8.1. The PII Sensitivity Classification Standard
*   **Law**: Fields containing PII MUST be classified by sensitivity level, and masking levels for log output, external integrations, and analytical use MUST be standardized. Protection without classification breeds "gaps."
*   **Classification Template**:
    *   Apply the following 3-tier classification as a baseline to project-specific data.

        | Classification | Definition | Masking Level | Examples |
        |:--------------|:-----------|:-------------|:---------|
        | **Sensitive PII** | Information whose leakage could cause serious human rights violations, discrimination, or financial harm | `[REDACTED]` (fully concealed) | Diagnosis, Medication details, Bank account info, National ID numbers, Criminal records |
        | **Personal Info** | Information that can directly identify an individual | Partial masking (e.g., `Smi***`, `090-****-1234`) | Name, Phone number, Email address, Physical address |
        | **Quasi-Personal Info** | Information that cannot identify an individual alone but can when combined with other data | No masking required (but access logs must be recorded) | Organization name, Facility name, City/district-level region |

*   **Action**:
    1.  **PIA Integration**: When adding new tables or columns, assign each field to one of the above 3 classifications during the PIA (§3 Privacy Impact Assessment).
    2.  **Logger Integration**: Design the masking logic of the PII Logging Defense (§8.8) to automatically determine masking levels based on this classification table.
    3.  **Documentation**: Create and maintain a domain-specific PII classification table in each project's Blueprint (design document).
*   **Rationale**: Uniformly applying `[REDACTED]` to all PII makes operational debugging and support response difficult. Tiered masking based on sensitivity achieves a balance between privacy protection and operational efficiency.

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
*   **Prohibited Examples**:
    - `NODE_TLS_REJECT_UNAUTHORIZED=0` (Disabling SSL verification)
    - `Access-Control-Allow-Origin: *` (Permitting all origins in production)
    - Commenting out or skipping Auth Middleware verification logic

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
*   **Incident Response 5-Step Protocol (Initial Response Timeline)**:
    *   **Context**: Data protection regulations (GDPR 72 hours, Japan APPI preliminary report within 3-5 days + final report within 30 days, etc.) mandate rapid initial response. Use the following timeline as the standard flow.

    | Step | Timeframe | Action | Responsible |
    |:-----|:----------|:-------|:------------|
    | **1. Detection & Isolation** | 0-1 hour | Identify impact scope, block access paths (revoke API keys, block IPs), preserve logs | Technical Lead |
    | **2. Impact Assessment** | 1-6 hours | Identify types and volume of leaked data, assess secondary damage risk | Technical Lead |
    | **3. Preliminary Report** | Within 3-5 days | Submit preliminary report to supervisory authority, send initial notification to affected users | Business Lead |
    | **4. Root Cause Analysis** | Up to 14 days | Conduct RCA (Root Cause Analysis), apply remediation patches | Technical Lead |
    | **5. Final Report & Prevention** | Up to 30 days | Submit final report to supervisory authority, append lessons to design docs, implement preventive measures | Business Lead |

    *   **Escalation Criteria**:
        *   PII (name, email, address, etc.) leaks externally, even **a single record**
        *   Authentication/authorization bypass is confirmed
        *   Unauthorized database access traces are detected
    *   **Communication Ban**: During an active incident, disclosure on social media or public channels is **prohibited** until the root cause is confirmed. Official announcements MUST be unified after legal review.


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

### 9.2. The Function Search Path Lockdown
*   **Law**: Not fixing the `search_path` in PostgreSQL `SECURITY DEFINER` functions is a vulnerability equivalent to "leaving the house with the door unlocked."
*   **Threat Model**: An attacker can place identically-named tables/functions in `temp` or other schemas to hijack the execution context of privileged functions via "Search Path Injection" attacks.
*   **Action**:
    1.  **Empty Search Path**: `SECURITY DEFINER` functions MUST have `SET search_path = ''` (empty string). `SET search_path = public` is a compromise that retains alias attack risks.
    2.  **Fully Qualified References**: All table/function references within functions MUST use **schema-qualified names** such as `public.users`, `public.is_admin()`.
    3.  **System Schema Exclusion**: DDL operations on objects within system schemas (`storage`, `auth`, `graphql`, `extensions`, etc.) are prohibited in principle. These are Supabase-managed domains.
    4.  **CI Validation**: When adding new functions, introducing CI scripts to verify correct `search_path` configuration is recommended.
*   **Outcome**: Physically eliminate Search Path attacks and reduce Privilege Escalation risk to zero.

### 9.3. The Strict CSP Nonce Protocol
*   **Law**: Adding `'unsafe-inline'` or `'unsafe-eval'` in Content Security Policy (CSP) to bypass script blocks is an "Abandonment of Defense" and is prohibited.
*   **Action**:
    1.  **Nonce Propagation**: All inline scripts and external widgets (Turnstile, reCAPTCHA, GTM, etc.) MUST have a **Nonce** generated from Middleware propagated to prove legitimacy to the browser.
    2.  **Strict Dynamic**: Use `'strict-dynamic'` for sub-resources dynamically loaded by trusted scripts, minimizing reliance on explicit domain whitelists.
    3.  **Report-Only First**: When introducing new CSP rules, observe impact with `Content-Security-Policy-Report-Only` before applying to production.
    4.  **No Compromise**: Proposing "just add `unsafe-inline` and it works" to bypass security feature blocking is a developer's defeat. Solve with legitimate technical improvements.
*   **Outcome**: Structurally eliminate XSS attack risk and maintain maximum-strength CSP.
*   **CSP Directive Change Governance**:
    1.  **Centralized Management**: CSP directives MUST be **centrally managed** in the `headers()` function of `next.config.ts` (or Middleware). Scattering across multiple files breeds configuration omissions and contradictions.
    2.  **PR Justification**: Changes to CSP directives (adding domains, relaxing directives, etc.) MUST **explicitly state the reason from a security perspective** in the PR and pass security review.
    3.  **Report-Only Staging**: New CSP directives and changes to existing directives MUST be **pre-validated** using `Content-Security-Policy-Report-Only` before production application. Promote to the production header only after confirming normal operation.
*   **CSP Worker Protocol (Web Worker Permission)**:
    *   **Law**: Image processing libraries (HEIC conversion, Canvas compression, etc.) and WebAssembly modules may internally create `Web Workers` using `blob:` URLs. Under strict CSP settings, these are blocked, causing processing to **silently hang** (errors may not even occur).
    *   **Action**: When introducing libraries that may use Web Workers, explicitly add `worker-src 'self' blob:;` to the CSP configuration.
    *   **Rationale**: If the `worker-src` directive is not set, the `script-src` fallback applies, but if `blob:` is not permitted, Worker creation silently fails, resulting in bugs that are extremely difficult to diagnose.

### 9.4. The Cryptographic Consistency Mandate
*   **Law**: When handling sensitive information like API keys and tokens, the **generation/storage phase and authentication/verification phase MUST use the same cryptographic algorithm**.
*   **Action**:
    1.  **Algorithm Unity**: If storing SHA-256 hashed values at generation, compare with the same SHA-256 hash at verification. Algorithm mismatch is a direct cause of "authentication permanently fails" bugs.
    2.  **Schema Match**: Guarantee at the type level that column names storing hashed values (`key_hash`, etc.) exactly match column names referenced in application code.
    3.  **Rotation Ready**: Recommend including an algorithm identifier prefix (`sha256:xxxx`) during storage to prepare for future algorithm changes.
*   **Anti-Pattern**: Storing plaintext at generation and comparing hashes at authentication (or vice versa) is a fatal bug producing "permanent mismatch."

### 9.5. The Client-Side Branch Guard Protocol
*   **Law**: Use Git `pre-push` hooks to make direct pushes to protected branches (`main`, `master`, etc.) **physically impossible**. Even when server-side branch protection (GitHub Branch Protection, etc.) is available, double the defense lines (Deep Defense).
*   **Action**:
    1.  **Mandatory Hook**: Introduce a Git Hooks management tool such as `husky` during project initialization and configure a `pre-push` hook.
    2.  **Push Block Logic**: Inspect the current branch name within the hook and force abort with `exit 1` if it matches a protected branch name.
    3.  **No Human Trust**: "Being careful" as an operational rule is meaningless. Trust only mechanisms that make pushing physically impossible (Code, not Policy).
*   **Rationale**: Unintended direct pushes to protected branches cause unauthorized deployments, history pollution, and breach of team trust. Especially in environments where server-side protection is limited (e.g., GitHub Free Plan), client-side guards are the only defense line.

### 9.6. The Unconditional Baseline Auth Mandate
*   **Law**: Action layer handlers that invoke privileged clients (Service Role, etc.) MUST execute **baseline authentication and authorization checks without exception across all code paths**, regardless of data status or importance.
*   **Action**:
    1.  **No Conditional Bypass**: Bypasses like "skip auth check because it's a draft" or "relax guards because it's an internal API" are prohibited. Switching authentication strength (whether MFA/OTP is required, etc.) is permissible, but making identity verification ("who is executing") conditional is not.
    2.  **Defense in Depth**: Privileged clients bypass DB-level access controls, so application layer check omissions directly lead to critical vulnerabilities. Enforce minimum authorization checks (`ensureAuth()` / `ensureRole()`, etc.) across all code paths.
    3.  **Branch Audit**: When adding or modifying action functions with status or condition-based branching (`if (status === 'draft') ... else ...`), review that authentication guards are consistently invoked across all branch paths.
*   **Rationale**: The assumption that "it's safe because it's private" is invalid in environments where attackers can directly manipulate API calls. Missing authentication checks in actions using privileged clients is a direct cause of Privilege Escalation.

### 9.7. The Role Enumeration Symmetry Mandate
*   **Law**: Multiple guard functions verifying the same domain (e.g., admin privileges) — for page access, APIs, Server Actions, etc. — MUST obtain their allowed role lists from a **shared constant array**.
*   **Action**:
    1.  **Shared Constants**: Define allowed role lists as a single constant such as `ALLOWED_ADMIN_ROLES`, and have all guard functions reference this constant. Individually enumerating roles as literal strings within each function is prohibited.
    2.  **Full-Count Verification**: When adding, modifying, or deleting roles, mandate a full inspection of all guard functions referencing that role across the entire project.
    3.  **Failure Transparency**: Guard failures due to role mismatches should display clear error messages to users, and in development environments, use `Logger.warn` for immediate inconsistency detection.
*   **Rationale**: Inconsistencies such as including `master_admin` in the page access guard but not in the Server Action guard cause extremely opaque deadlocks where users "can access the admin panel but writes always fail." Structural sharing of role enumeration physically prevents this class of inconsistency.
*   **Anti-Pattern**: `requireAdmin` and `ensureAdminAction` each maintaining independent string literals `['admin', 'super_admin']`, with only one being updated when a new role is added.

### 9.8. The Strict CSP Nonce Protocol
*   **Law**: In Content Security Policy (CSP), the use of `unsafe-inline` or `unsafe-eval` is defined as "abandoning security defenses." All inline scripts must use a **cryptographically secure Nonce generated in Middleware**, maintaining CSP strictness.
*   **Action**:
    1.  **Nonce Generation**: Generate a unique Nonce per request in Middleware using `crypto.randomUUID()` or similar, and set it in the `Content-Security-Policy` header as `'nonce-{value}'`.
    2.  **Nonce Propagation**: Propagate the generated Nonce to Server Components via custom headers (e.g., `x-nonce`) and apply it to all inline scripts (`<script nonce={nonce}>`).
    3.  **No Fallback to Unsafe**: Do not compromise to `unsafe-inline` when integrating third-party scripts (widgets, analytics tools, etc.). Instead, load them as external files and enumerate domains in `script-src`, or use hash-based allow lists.
    4.  **CSP Report**: Configure `report-uri` / `report-to` directives to collect and monitor CSP violations server-side.
*   **Rationale**: `unsafe-inline` completely nullifies CSP's defense against XSS (Cross-Site Scripting) attacks. Nonce-based CSP permits only legitimate inline scripts and physically blocks execution of scripts injected by attackers.

### 9.8.1. The Permissions-Policy Header Mandate (Browser API Restriction)
*   **Law**: The `Permissions-Policy` (formerly `Feature-Policy`) header MUST be configured to **explicitly disable** browser APIs not used by the application (camera, microphone, geolocation, payment, etc.).
*   **Action**:
    1.  **Deny by Default**: Browser APIs not used by the project MUST be explicitly disabled with `()` (empty list = deny all). Example: `Permissions-Policy: camera=(), microphone=(), geolocation=(), payment=()`.
    2.  **Self Only**: APIs used by the project MUST be restricted to `(self)` to prevent unauthorized use from third-party iframes or scripts.
    3.  **Middleware Integration**: Add as response headers via Next.js `middleware.ts` or `next.config.ts` `headers` configuration.
    4.  **Audit**: When adding new third-party scripts (analytics tools, widgets, etc.), verify which browser APIs the script requests and allow only the minimum necessary.
    5.  **DevTools Verification**: When using new browser APIs, **physically verify** in the DevTools Console that no `Permissions policy violation` error occurs. Silent blocking by policy is extremely difficult to debug.
    6.  **PR Justification**: Changes to the `Permissions-Policy` header (adding/modifying API permissions) MUST **state the reason for change** in the PR and pass review.
*   **Rationale**: Without `Permissions-Policy`, third-party scripts or iframes embedded in the page become attack vectors that can access the user's camera or microphone without consent. Combined with CSP, this achieves multi-layered defense.

### 9.9. The Anti-Permissive RLS Mandate
*   **Law**: In Row Level Security (RLS) policy design, **creating excessively permissive policies is prohibited**. Clarify intent and strictly adhere to the principle of least privilege.
*   **Action**:
    1.  **No `FOR ALL` Policy**: `FOR ALL` permits all operations (`SELECT`, `INSERT`, `UPDATE`, `DELETE`) at once, making permission granularity coarse and intent difficult to understand. Create individual policies per operation.
    2.  **No `WITH CHECK (true)`**: `WITH CHECK (true)` means "anyone can write unconditionally." Always set conditions for write operations (e.g., `auth.uid() = user_id`).
    3.  **Limited `USING (true)` Usage**: `USING (true)` is only acceptable for `SELECT` policies on public data. `USING (true)` for `UPDATE` or `DELETE` is prohibited in principle.
    4.  **Policy Naming Convention**: Name policies in the format `tablename_action_role_policy` (e.g., `posts_select_authenticated_policy`), making policy intent immediately understandable from the name.
*   **Rationale**: RLS is the "last bastion" of data access. Excessively permissive policies increase the risk of data leakage and tampering through application-layer bugs or direct API access. The principle of least privilege physically blocks unexpected access.
*   **RLS Best Practices**:
    *   **Service Role Bypass Principle**: The `service_role` key **completely bypasses RLS**. Therefore, "admin policies" (`FOR ALL USING (auth.role() = 'service_role')`) are redundant and **their creation is prohibited**. Redundant policies cause "Multiple Permissive Policies" warnings and degrade performance as each policy is evaluated on every query.
    *   **Auth Function InitPlan Optimization**: When using `auth.uid()`, `auth.role()`, `current_setting()` within RLS policies, MUST **wrap with `(select ...)`** to prevent per-row re-evaluation. Without wrapping, functions are re-evaluated on each row scan of large tables, causing severe performance degradation.
        *   ❌ `USING (user_id = auth.uid())`
        *   ✅ `USING (user_id = (select auth.uid()))`
    *   **Single Purpose Policy Principle**: **Creating multiple PERMISSIVE policies for the same table, same role, and same action (SELECT/INSERT/UPDATE/DELETE) is prohibited**. Multiple policies are evaluated with OR conditions, and all policies are executed on every query, degrading performance. When multiple conditions exist, combine them using the `OR` operator within a single policy.

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

### 9.13. The Admin CMS Injection Defense
*   **Law**: CMS features that allow embedding arbitrary HTML/scripts into site-wide `<head>` or templates from the admin panel (custom head, custom CSS, widget embeds, etc.) are powerful XSS vectors. If an admin account is compromised, the entire site can be contaminated.
*   **Action**:
    1.  **Super Admin Only**: Restrict editing and saving of such features to users with **top-level privileges (System Admin / Super Admin)** only, not regular administrators.
    2.  **Script Tag Warning**: When input contains `<script>` tags, `javascript:` URIs, or `on*` event handlers, display an explicit warning dialog in the UI before saving.
    3.  **Change Audit**: All changes MUST be recorded in audit logs with before/after diffs retained.
*   **Rationale**: Arbitrary code injection from admin panels can bypass CSP through admin privileges, requiring dual defense through privilege-level restrictions and injection detection.

### 9.14. The Social Login Security Protocol
*   **Law**: When implementing Social Login (OAuth 2.0 / OpenID Connect), authentication flow deficiencies become a breeding ground for account takeover attacks. The following design standards MUST be strictly observed.
*   **Action**:
    1.  **Authorization Code Flow + PKCE Mandatory**: **Authorization Code Flow with PKCE** is the only permitted flow. Use of Implicit Flow (where tokens are exposed in URL fragments) is prohibited.
    2.  **CSRF Prevention**: OAuth authorization requests MUST include a `state` parameter and verify it upon callback to prevent CSRF attacks.
    3.  **Server-Side Token Exchange**: Communication with the token endpoint (containing `client_secret`) MUST be executed **server-side only**. Exposure of `client_secret` on the client side is strictly prohibited.
    4.  **Scope Minimization**: Requested scopes MUST be limited to the minimum required for service delivery, such as `openid`, `email`, `profile`. Additional scope requests require prior review and approval.
    5.  **Explicit Account Link**: When an account with the same email address already exists, do NOT auto-link. Display an **explicit confirmation UI** to verify user intent before linking accounts. Automatic merging introduces account takeover risks.
    6.  **Session Verification**: When verifying tokens obtained from the ID Provider, validate not only the signature but also the `iss` (issuer), `aud` (audience), and `exp` (expiration) fields without exception.
*   **Rationale**: OAuth misconfiguration (Implicit Flow, lack of CSRF protection, excessive scope requests, etc.) becomes a vulnerability in the authentication infrastructure itself, endangering all user accounts.

### 9.15. The Concurrent Session Control Mandate
*   **Law**: Inadequate session management is a direct cause of account takeover and information leakage. Session lifecycle design MUST be based on the following principles.
*   **Action**:
    1.  **Token Expiration Design**: Design appropriate expiration periods for access tokens and refresh tokens. Access tokens should be short-lived (recommended: within 1 hour), refresh tokens medium-lived (recommended: 7–30 days), and high-privilege sessions (e.g., admin panels) should have shorter expiration periods.
    2.  **Step-Up Authentication**: For high-risk operations such as password changes, email changes, viewing/modifying payment information, and admin privilege operations, require **re-authentication (Step-Up Auth)** even when the current session is valid.
    3.  **Concurrent Session Policy**: Set an upper limit on the number of simultaneously logged-in devices per account. When exceeded, either invalidate the oldest session or implement a flow allowing the user to choose. Apply stricter limits to administrator accounts.
    4.  **Suspicious Session Detection**: Design a mechanism to detect simultaneous access from different IP addresses or geographically distant regions to the same account, and notify the user. Providing a "Log out from all devices" feature is recommended.
    5.  **Server-Side Invalidation**: On logout, invalidate the session server-side immediately. Client-side token deletion alone is insufficient — the server must guarantee session validity. On account suspension or deletion, invalidate all sessions immediately.
*   **Rationale**: Lax session management is equivalent to "leaving the key in the door." Properly designing token lifetime management, re-authentication triggers, and concurrent session controls minimizes the blast radius when a compromise occurs.

### 9.16. The Subresource Integrity Mandate (SRI)
*   **Law**: External scripts and stylesheets loaded from CDNs or third parties MUST have **Subresource Integrity (SRI)** `integrity` attributes applied wherever possible to detect tampering.
*   **Action**:
    1.  **Integrity Attribute**: Add `integrity="sha384-..."` and `crossorigin="anonymous"` attributes to `<script>` and `<link>` tags loading external libraries from CDNs to detect file tampering along the delivery path.
    2.  **Third-Party Script Inventory**: Maintain an inventory of all external scripts loaded on the site (Analytics, CAPTCHA, ad tags, payment SDKs, etc.), and document each script's **purpose, risk, and CSP configuration**. Adding unapproved scripts is prohibited.
    3.  **Review Obligation**: When adding new third-party scripts, conduct a security review to confirm the browser APIs and network access the script requires before granting approval.
*   **Rationale**: If external scripts are tampered with through CDN compromise or supply chain attacks, without SRI the tampered code executes directly in all users' browsers. SRI functions as the "last checkpoint," physically detecting and blocking tampering.

## 10. The Vendor Security Management Protocol

### 10.1. Vendor Security Assessment Standards
*   **Law**: When selecting and contracting external vendors (SaaS, IaaS, outsourcing partners, etc.), their compliance with your organization's security standards MUST be evaluated in advance.
*   **Mandate**:
    *   **Pre-Selection Checklist**: Evaluate the following items before contracting with new vendors.

        | Assessment Category | Check Item | Minimum Requirement |
        |:---------|:--------|:--------|
        | **Certifications** | ISO 27001 / SOC 2 Type II acquisition status | At least one |
        | **Data Encryption** | Encryption methods at rest and in transit | AES-256 + TLS 1.2 or higher |
        | **Access Control** | RBAC, MFA implementation status | MFA mandatory for admin accounts |
        | **Incident Response** | Incident response plan availability and notification timeline | Initial notification within 24 hours |
        | **Data Storage Location** | Data center locations | Same region as service user base |
        | **Backup & DR** | Backup frequency and recovery framework | Daily backup + RTO within 24 hours |

    *   **Risk Classification**: Classify vendors into the following risk tiers based on the sensitivity of data they handle, and apply management intensity accordingly.
        *   **High**: Vendors handling PII, payment data, authentication credentials → Annual audit + SLA mandatory
        *   **Medium**: Vendors handling business data, analytics data → Annual self-assessment + SLA recommended
        *   **Low**: Vendors handling only public information → Initial assessment only

### 10.2. Vendor SLA Template
*   **Law**: SLAs (Service Level Agreements) including the following items MUST be established with vendors involved in security-sensitive operations.
*   **Mandatory SLA Items**:

    | SLA Item | Recommended Standard | Response on Violation |
    |:--------|:--------|:-----------|
    | **Availability** | 99.9% or higher (monthly) | Credit refund or penalty clause |
    | **Incident Notification** | Initial report within 24 hours of discovery | Record as contract violation |
    | **Data Recovery** | RPO within 24 hours / RTO within 4 hours | Escalation + alternative solution review |
    | **Security Patch Application** | Critical: within 72 hours / High: within 2 weeks | Demand improvement plan submission |
    | **Audit Cooperation** | Obligation to accept audit once per year | Contract review if refused |

### 10.3. Sub-Processor Management
*   **Law**: When vendors further delegate data processing to third parties (sub-processors), prior notification to and approval from the data controller is required.
*   **Mandate**:
    *   **Prior Notification Obligation**: Vendors must notify the data controller at least **30 days before** commencing use of a new sub-processor.
    *   **Equivalent Conditions Requirement**: Sub-processors must be contractually bound to security and privacy conditions equivalent to the primary vendor.
    *   **Chain Restriction**: Further delegation from sub-processors (sub-sub-processing) is **prohibited in principle**. Individual approval is required when unavoidable.
    *   **List Management**: Include in the contract the obligation for vendors to maintain, update, and disclose to the data controller a complete list of all sub-processors (company name, location, processing scope).
*   **Rationale**: GDPR Art.28(2) requires prior approval for sub-processors, and APPI amendments have strengthened supervisory obligations over sub-contractors. Data protection cannot be achieved without visibility and management of the vendor chain.

