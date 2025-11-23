# 60. Security & Privacy (CISO & Legal View)

## 1. Privacy by Design (GDPR/CCPA Standard)
*   **Data Minimization**:
    *   "Collecting just in case" is prohibited. Collect only data truly necessary for the business.
    *   Anonymize or pseudonymize PII (Personally Identifiable Information) as much as possible.
*   **User Sovereignty**:
    *   Implement features for users to "View," "Export," and "Completely Delete" their data from the MVP stage.
    *   "Unsubscribing" must be as easy as "Subscribing" (Prohibition of Dark Patterns).

## 2. Security Architecture (Zero Trust)
*   **Authentication & Authorization**:
    *   Do not build your own auth infrastructure. Use verified solutions like Firebase Auth or Auth0.
    *   Enforce MFA (Multi-Factor Authentication) for accounts with administrative privileges.
*   **Supply Chain Security**:
    *   Verify the reliability of libraries used and regularly scan for vulnerabilities with `npm audit`, etc.
    *   Do not use suspicious packages or unmaintained libraries.

## 3. Offensive Security (Red Team Mindset)
*   **Self-Penetration Testing**:
    *   Developers must adopt an "Attacker's" perspective and perform thought experiments trying SQL Injection or XSS (Cross-Site Scripting) on their own code.
    *   Start Firestore Security Rules not from "Anyone can read/write" but from "No one can do anything," granting only necessary permissions (Allowlist approach).

## 4. Incident Response
*   **Assume Breach**:
    *   Design assuming "We will be breached." Implement network segmentation and privilege separation to minimize damage in case of a breach.
    *   Save logs in tamper-proof locations and set up alerts for anomaly detection.
