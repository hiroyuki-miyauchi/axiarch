# 290. IP Strategy & Due Diligence

## 1. IP Protection
*   **Code Rights Attribution**:
    *   **CLA (Contributor License Agreement)**: When external contributors or side-job engineers participate, always conclude an agreement (CLA) clarifying that the copyright of the code belongs to the company.
    *   **Work for Hire**: Clarify in employment regulations that code created by employees is work for hire.
*   **Trade Secrets**:
    *   **Secret Sauce**: Clearly separate algorithms and data logic that are sources of competitive advantage from generic code, and strictly manage access rights (strategically decide whether to patent or hide as trade secrets).

## 2. Due Diligence Readiness
*   **Data Room**:
    *   Maintain a folder (Data Room) where the following materials are always kept up-to-date to immediately respond to audits (Due Diligence) during M&A or fundraising.
        *   System Configuration Diagram (Architecture Diagram)
        *   List of OSS libraries used and licenses
        *   List of external service (SaaS) contracts and costs
        *   Security Audit Reports
*   **Vendor Lock-in Avoidance**:
    *   Over-reliance on specific vendors (AWS, Firebase, etc.) is a business risk. Use standard technologies as much as possible to ensure portability.
    *   **SaaS Management**: List "Purpose of Use", "Monthly Cost", and "Contract Period" for all SaaS used, and periodically inventory unnecessary subscriptions.
