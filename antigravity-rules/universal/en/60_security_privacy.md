# 60. Security & Privacy (CISO & Legal View)

## 1. The Golden Rule
*   **Security > Convenience**:
    *   When security and convenience conflict, **prioritize security 100% of the time**.
    *   **Example**: Even if there is a request to "view personal info offline", if local encryption is insufficient, do not implement that feature.

## 2. Privacy by Design (GDPR/APPI/CCPA)
*   **Data Minimization**:
    *   "Collecting just in case" is prohibited. Collect only data truly necessary for business.
    *   Anonymize or pseudonymize PII (Personally Identifiable Information) as much as possible.
*   **User Rights**:
    *   **Right to be Forgotten**: Automate the process to physically delete or anonymize all related personal data (including backups) when a user chooses to "Delete Account".
    *   **Data Portability**: Provide a feature for users to download their data in a machine-readable format (JSON/CSV).
*   **Legal Compliance**:
    *   Comply with **GDPR (EU)**, **CCPA (California)**, and **APPI (Japan)** regulations.
    *   **Cookie Consent**: Obtain explicit consent (Opt-in) for non-essential cookies (marketing, analytics).

## 3. Security Architecture (Zero Trust)
*   **Authentication & Authorization**:
    *   Do not build your own auth infrastructure. Use verified solutions like Firebase Auth or Auth0.
    *   **MFA (Multi-Factor Authentication)**: Enforce MFA for accounts with administrative privileges.
    *   **Biometrics**: Actively use FaceID/TouchID in mobile apps for "convenience", but implement it in conjunction with backend auth token (Refresh Token) protection.
*   **OWASP Top 10 Countermeasures**:
    *   **Injection**: Use only ORMs or parameterized queries to prevent SQL/NoSQL injection.
    *   **Access Control**: Strictly check if the requesting user has permission to access the resource at all API endpoints (Firestore Security Rules / RLS).

## 4. Infrastructure Security
*   **Network Security**:
    *   **VPC**: Isolate backend services within a private VPC. Do not expose databases directly to the internet.
    *   **Cloud Armor**: Use WAF to protect against DDoS and common Web attacks.
*   **App Check**: Enforce Firebase App Check to guarantee requests come from genuine apps.

## 5. License & ToS Compliance
*   **License Contamination Prevention**:
    *   **No GPL**: Libraries with copyleft licenses (GPL, AGPL) are prohibited in principle due to legal risks. Use only permissive licenses like MIT, Apache 2.0, BSD.
    *   **Dependency Check**: Run license scans in the CI pipeline to prevent contamination by violating libraries.
*   **Platform ToS**:
    *   **Google/Apple**: Absolutely do not engage in acts that violate platform Terms of Service (ToS), such as scraping or using private APIs, even if technically possible. The risk of account BAN is a business continuity risk.

## 6. Offensive Security
*   **Self-Penetration Test**:
    *   Developers must adopt an "Attacker's" perspective and conduct thought experiments trying SQL injection or XSS on their own code.
    *   Start Firestore Security Rules from "No one can do anything" and grant only necessary permissions (Allowlist approach), never start from "Anyone can read/write".
