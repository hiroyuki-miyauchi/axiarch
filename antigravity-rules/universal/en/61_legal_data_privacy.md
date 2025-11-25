# 61. Legal, Privacy & Data Governance

## 1. Data Sovereignty
*   **Residency**: Store user data in the region where the user resides (e.g., EU users in EU region) and comply with cross-border transfer regulations (GDPR etc.).
*   **Consent Management**:
    *   **CMP**: Manage Cookie and tracking consent using trusted CMPs (Consent Management Platform) like OneTrust instead of custom implementation, to auto-follow legal changes in each country.

## 2. ToS & Privacy
*   **Dynamic Consent**:
    *   **Version Control**: Record "When and which version of ToS user agreed to" in DB as legal trail. Force display consent screen at next login upon revision.
*   **Layered Notice**:
    *   Always display a summary in Plain Language understandable by users before legal detailed clauses in Privacy Policy.

## 3. Japan Specific Compliance
*   **Act on Specified Commercial Transactions**:
    *   When charging, always place the notation based on Japan's Act on Specified Commercial Transactions (Operator, Contact, Return Policy) in an easily accessible place in the app.
*   **Payment Services Act**:
    *   **Deposit Avoidance**: Be cautious with issuing prepaid payment instruments (points, coins) as deposit obligations may arise. In principle, use Apple/Google IAP systems and avoid self-issued points.

## 4. IP & Licenses
*   **License Contamination Prevention**:
    *   **No GPL**: Mixing Copyleft license (GPL/AGPL) code is strictly prohibited due to risk of source code disclosure obligation.
    *   **Rights Clearance**: Confirm commercial use allows for all assets (images, fonts) used and centrally manage license trails.
