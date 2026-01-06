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

## 3. Privacy by Design
*   **Data Minimization**:
    *   **Principle**: Collecting data "just in case" is prohibited. Collect only essential data.
    *   **Retention**: Define retention policies. Delete or anonymize expired data automatically.
*   **Consent Management**:
    *   **Opt-in**: Marketing and tracking must be Opt-in by default. Dark patterns are **strictly prohibited**.
*   **The "Right to be Forgotten"**:
    *   **Physical Deletion**: User account deletion MUST basically involve **Physical Deletion (DELETE)** of related records containing PII. Logical deletion is allowed only for transaction data (purchase history, etc.).
*   **The API Output Hygiene**:
    *   **Law**: Public API responses MUST physically remove (DTO processing) PII (Email, detailed address), Internal Params (IDs, notes), and Security Fields (Hash, Salt).

## 4. Security Architecture
*   **Authentication & Authorization**:
    *   **MFA**: **Mandatory MFA** for all admin accounts. No exceptions.
    *   **IDaaS**: Use verified solutions (Firebase Auth, Auth0, Cognito).
    *   **Omnichannel Auth**: The system must fully support **Bearer Token (JWT)** access from native apps, not just Web cookies. Skipping verification in Server Actions because "web session exists" is prohibited.
*   **API Key Security**:
    *   **Hashing**: API Keys (`sk_live_...`) MUST **NEVER be stored in plain text**. Always hash them before storage and hash input values for verification.
*   **OWASP Top 10**:
    *   **Injection**: Use ORMs or parameterized queries to prevent SQL/NoSQL injection.
    *   **Access Control**: Strictly check RLS/Security Rules for every endpoint.

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
*   **Multi-Layered Defense**:
    *   **Edge (WAF)**: Use Cloud Armor/AWS WAF for GeoIP blocking and Bot detection to protect against DDoS and EDoS (resource exhaustion) attacks.
    *   **App Check**: Block unauthorized API access using Firebase App Check.

## 7. Offensive Security
*   **Self-Penetration Test**:
    *   Think like an attacker. Try XSS/SQLi on your own code.
    *   Start Security Rules from "Deny All".

## 8. Advanced Security Operations

### 8.1. The Double Security Protocol (Turnstile + OTP)
*   **Law**: All critical security operations (Login, Register, PW Change, Delete Account, etc.) MUST implement Double Defense: "Managed Turnstile" + "OTP".
*   **Action**:
    1.  **Layer 1 (Pre-Auth)**: Physically block bots with Turnstile (`appearance: 'always'`). The submit button must be **physically disabled** until verification (`onSuccess`) is complete.
    2.  **Layer 2 (Auth)**: Do NOT allow data mutation (UPDATE/DELETE) until identity verification via OTP is complete.
    3.  **Fail-Safe**: Build a flow that immediately disables the button and resets the state upon error.

### 8.2. The Audit Log Obligation (No Invisible Hands)
*   **Law**: DB writes bypassing audit logs are a security Blind Spot.
*   **Action**:
    *   **Prohibition**: Direct DB mutation from Client Side is strictly prohibited.
    *   **Mandate**: Must go through `Server Actions` that call `recordAuditLog` internaly.

### 8.3. The PII Logging Defense (Masking Protocol)
*   **Law**: Leaking PII (Email, Token, Password) to logs is a fatal security risk.
*   **Action**: Implement auto-masking logic in the Logger class to replace sensitive fields (password, token) with `***MASKED***`.
