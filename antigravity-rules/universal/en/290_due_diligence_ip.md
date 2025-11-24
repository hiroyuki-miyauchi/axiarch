# 290. IP Strategy & Due Diligence

## 1. IP Protection
*   **Code Ownership**:
    *   **CLA (Contributor License Agreement)**: When external contributors or side-job engineers participate, always sign a contract (CLA) clarifying that the copyright of the code belongs to the company.
    *   **Work for Hire**: Clearly state in the employment regulations that code created by employees is "work for hire."
*   **Trade Secrets**:
    *   **Secret Sauce**: Clearly separate algorithms and data logic that are the source of the company's competitive advantage from generic code, and strictly manage access rights (strategically decide whether to patent or keep as a trade secret).

## 2. Due Diligence Readiness
*   **Data Room**:
    *   Maintain a folder (Data Room) with the following documents always up-to-date to respond immediately to audits (Due Diligence) during M&A or fundraising.
        *   System Architecture Diagrams
        *   List of OSS libraries used and their licenses
        *   List of external service (SaaS) contracts and costs
        *   Security Audit Reports
*   **Avoid Vendor Lock-in**:
    *   Excessive reliance on specific vendors (AWS, Firebase, etc.) is a business risk. Use standard technologies as much as possible to ensure Portability.
    *   **SaaS Management**: List the "Purpose," "Monthly Cost," and "Contract Period" of all SaaS used, and periodically inventory unnecessary subscriptions.
