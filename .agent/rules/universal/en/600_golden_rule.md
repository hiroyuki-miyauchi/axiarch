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
