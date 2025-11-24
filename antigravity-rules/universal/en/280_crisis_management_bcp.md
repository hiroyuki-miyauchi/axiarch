# 280. Crisis Management & BCP

## 1. Data Breach Protocol
*   **Stop the Bleeding**:
    *   If a data breach or unauthorized access is suspected, take immediate action to "stop the bleeding." Prioritize revoking API keys, shutting down servers, and blocking access.
    *   **Assess**: After stopping the bleeding, calmly identify the scope of impact (leaked data, number of affected users).
    *   **Notify**: Notify users and regulatory authorities in accordance with legal requirements (e.g., GDPR 72-hour rule). Have notification templates prepared in advance.

## 2. Disaster Recovery
*   **RPO / RTO**:
    *   **RPO (Recovery Point Objective)**: How much data loss is acceptable (e.g., up to 1 hour ago).
    *   **RTO (Recovery Time Objective)**: How quickly must the service be restored (e.g., within 4 hours).
    *   Define these to design backup frequency and recovery procedures.
*   **Cloud Redundancy**:
    *   Use AWS S3 Cross-Region Replication or Multi-AZ database deployments to ensure service continuity (or early recovery) even if a specific region goes down.

## 3. Business Continuity Plan (BCP)
*   **Eliminate Key Person Risk**:
    *   Eliminate code that "only a specific engineer can touch." Maintain documentation and code standards so that anyone can perform recovery operations.
    *   **Emergency Contact**: Secure emergency communication channels other than Slack (phone, alternative chat tools).
