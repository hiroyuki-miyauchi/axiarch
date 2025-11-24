# 60. Security & Privacy (CISO & Legal View)

## 1. Privacy by Design (GDPR/CCPA Standard)
*   **Data Minimization**:
    *   Collect only the data you absolutely need. Do not collect "just in case".
*   **Consent**:
    *   Obtain explicit consent for tracking and cookies (GDPR/CCPA/APPI).

## 2. Application Security (OWASP Top 10)
*   **Injection**:
    *   Use ORM/Prepared Statements to prevent SQL/NoSQL Injection.
*   **Authentication**:
    *   Enforce **MFA (Multi-Factor Authentication)** for all admin accounts.
    *   Use established IDaaS (Firebase Auth/Auth0) instead of building auth from scratch.

## 3. Infrastructure Security
*   **Least Privilege**:
    *   Grant only minimum necessary permissions to IAM roles and Service Accounts.
*   **WAF/DDoS**:
    *   Use Cloud Armor or Cloudflare to protect against attacks.

## 4. Incident Response
*   **Playbook**:
    *   Prepare a response manual for data breaches.
    *   **Drills**: Conduct security drills regularly.

## 3. Offensive Security (Red Team Mindset)
*   **Self-Penetration Testing**:
    *   Developers must adopt an "Attacker's" perspective and perform thought experiments trying SQL Injection or XSS (Cross-Site Scripting) on their own code.
    *   Start Firestore Security Rules not from "Anyone can read/write" but from "No one can do anything," granting only necessary permissions (Allowlist approach).

## 4. Incident Response
*   **Assume Breach**:
    *   Design assuming "We will be breached." Implement network segmentation and privilege separation to minimize damage in case of a breach.
    *   Save logs in tamper-proof locations and set up alerts for anomaly detection.
