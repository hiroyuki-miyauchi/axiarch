# 60. Security & Privacy - CISO & Legal View

> [!IMPORTANT]
> **Level 1 Priority: Absolute Compliance**
> Security and Legal Compliance are the **highest priorities** at Google Antigravity.
> They take precedence over user convenience, development speed, and profitability. There is no room for debate.

## 1. The Golden Rule
*   **Legal & Security > User Experience**:
    *   **Iron Rule**: "If it's legally risky, do not offer it, even if the user wants it."
    *   **Example**: Reject "View history without login" if there is privacy risk. Reject "Offline payment" if there is security risk.
*   **Zero Trust Architecture**:
    *   Discard the premise that "Internal network is safe". Verify all accesses and all requests.

## 2. Legal Compliance
*   **Global Regulations**:
    *   **GDPR (EU) / CCPA (California) / APPI (Japan)**: Adhere to these privacy regulations as the "Minimum Line".
    *   **Data Sovereignty**: User data belongs to the user. Guarantee rights to delete and export (Data Portability) at the system level.
*   **Japan Specifics**:
    *   **Payment Services Act**: When issuing prepaid payment instruments (points/coins), constantly monitor the deposit obligation threshold (10 million yen) and control not to exceed it or report to the Finance Bureau.
    *   **Specified Commercial Transactions**: When selling for a fee, clearly state all legally required information.

## 3. Privacy by Design
*   **Data Minimization**:
    *   **Principle**: Collecting data "just in case" is prohibited. Collect only data essential for business.
    *   **Retention**: Define Data Retention Policy and automatically delete or anonymize data past its expiration.
*   **Consent Management**:
    *   **Opt-in**: Marketing emails and tracking cookies must be OFF (Opt-in) by default. Dark Patterns deceiving users (hiding Opt-out) are **strictly prohibited**.

## 4. Security Architecture
*   **Authentication & Authorization**:
    *   **MFA**: **Force MFA** for accounts with admin privileges. No exceptions.
    *   **IDaaS**: Do not build auth infrastructure yourself. Use verified solutions like Firebase Auth, Auth0, Cognito.
*   **OWASP Top 10**:
    *   **Injection**: Use ORMs or parameterized queries only to prevent SQL/NoSQL injection.
    *   **Access Control**: Strictly check if the requester has permission to access the resource at all API endpoints (Firestore Security Rules / RLS).

## 5. License & ToS Compliance
*   **License Contamination Prevention**:
    *   **No GPL**: Libraries with Copyleft licenses (GPL, AGPL) are **prohibited** as they risk obligating source code disclosure of the entire product.
    *   **Permissive Only**: Use only permissive licenses like MIT, Apache 2.0, BSD, ISC.
    *   **CI Check**: Auto-run license scan in CI pipeline to block violation libraries.
*   **Platform ToS**:
    *   **Google/Apple**: Acts violating Platform ToS (scraping, private API use, review manipulation) are **never done** even if technically possible. Account BAN means death of the business.

## 6. Infrastructure Security
*   **Network Isolation**:
    *   Place databases and internal APIs in a Private Network (VPC) not directly accessible from the internet.
*   **DDoS Protection**:
    *   Use Cloud Armor or AWS WAF to protect apps from DDoS and Bot attacks.
*   **App Check**:
    *   Introduce Firebase App Check etc. to block API access from non-legitimate apps.

## 7. Offensive Security
*   **Self-Penetration Test**:
    *   Developers must have an "Attacker" perspective and perform thought experiments trying SQL injection or XSS on their own code.
    *   Start Firestore Security Rules from "No one can do anything" and grant only necessary permissions (Allowlist), not "Anyone can read/write".
