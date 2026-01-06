# 61. Legal, Privacy & Data Governance

## 1. Data Sovereignty
*   **Residency**: Store user data in the region where the user resides (e.g., EU users in EU region) and comply with cross-border transfer regulations (GDPR etc.).
    *   **Portability Protocol**: Users have the right to bulk download all their data (posts, images, logs) in machine-readable format (JSON/CSV). Implementation must be via async jobs.
    *   **Right to Erasure**: Account deletion must involve **Hard Delete** of relevant PII, making it unrecoverable. Only data with legal retention obligations shall be isolated in Cold Storage.
*   **Consent Management**:
    *   **CMP**: Manage Cookie and tracking consent using trusted CMPs (Consent Management Platform) like OneTrust instead of custom implementation, to auto-follow legal changes in each country.
    *   **Strict Opt-In**: Blocking non-essential tracking without explicit consent is mandatory (No Nudging).

## 2. ToS & Privacy
*   **Dynamic Consent**:
    *   **Version Control**: Record "When and which version of ToS user agreed to" in DB as legal trail. Force display consent screen at next login upon revision.
    *   **Legal Archive**: Keep past agreements accessible via Permalinks to guarantee user's right to verify contract conditions.
*   **Layered Notice**:
    *   Always display a summary in Plain Language understandable by users before legal detailed clauses in Privacy Policy.

## 3. Local Compliance Examples
*   **Act on Specified Commercial Transactions**:
    *   When charging, always place the notation based on **local commercial transaction laws** (e.g., Japan's Tokusho-ho: Operator, Contact, Return Policy) in an easily accessible place in the app.
    *   **Final Confirm Screen**: Explicitly display contract period and cancellation conditions before payment. Eliminate dark patterns.
*   **Payment Services Laws**:
    *   **Deposit Avoidance**: Be cautious with issuing prepaid payment instruments (points, coins) as deposit obligations may arise (e.g., Japan's PSA). In principle, use Apple/Google IAP systems and avoid self-issued points.

## 4. IP & Licenses
*   **License Contamination Prevention**:
    *   **No GPL**: Mixing Copyleft license (GPL/AGPL) code is strictly prohibited due to risk of source code disclosure obligation.
    *   **Rights Clearance**: Confirm commercial use allows for all assets (images, fonts) used and centrally manage license trails.
    *   **Anti-Social Forces**: Include exclusion clauses in ToS and exercise immediate termination rights if found applicable during KYB.
