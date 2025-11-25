# 63. IP Strategy & Due Diligence

## 1. IP Protection
*   **IP Assignment**:
    *   **CLA (Contributor License Agreement)**: If external contributors or side-job engineers participate, always sign a contract (CLA) clarifying that copyright of code belongs to the company.
    *   **Work for Hire**: Clarify in employment regulations that code created by employees is Work for Hire, and have them sign "IP Assignment Agreement" upon joining.
*   **Patent Strategy**:
    *   **Defensive Publishing**: Instead of patenting everything, consider publishing as prior art in tech blogs etc. to prevent competitors from taking patents.
    *   **Trade Secrets**: Algorithms that are sources of competitive advantage (Secret Sauce) should not be patented (published) but concealed as Trade Secrets under strict access control.

## 2. Due Diligence & IP Strategy
*   **Data Room**:
    *   Maintain a folder (Data Room) keeping the following documents up-to-date to instantly respond to audits (Due Diligence) during M&A or fundraising.
        *   System Architecture Diagram
        *   List of OSS libraries used and licenses (SBOM)
        *   List of external service (SaaS) contracts and costs
        *   Security Audit Reports
*   **Vendor Lock-in Avoidance**:
    *   Excessive dependence on specific vendors (AWS, Firebase etc.) is a business risk. Use standard technologies as much as possible to ensure Portability.
