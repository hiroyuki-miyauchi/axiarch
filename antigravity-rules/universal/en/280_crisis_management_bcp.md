# 280. Crisis Management & BCP

## 1. Data Breach Protocol
*   **Stop the Bleeding**:
    *   If a data breach or unauthorized access is suspected, "Stop the Bleeding" without hesitation. Prioritize invalidating API keys, shutting down servers, and blocking access.
    *   **Assess**: After stopping the bleeding, calmly identify the scope of impact (leaked data, number of affected users).
    *   **Notify**: Notify users and regulatory authorities according to legal requirements (e.g., GDPR 72-hour rule). Prepare notification templates in advance.

## 2. Disaster Recovery
*   **RPO / RTO**:
    *   **RPO (Recovery Point Objective)**: Allowable data loss point (e.g., up to 1 hour ago).
    *   **RTO (Recovery Time Objective)**: Target recovery time. Within how many hours to recover after downtime (e.g., within 4 hours).
    *   Define these and design backup frequency and recovery procedures.
*   **Cloud Redundancy**:
    *   Use AWS S3 Cross-Region Replication or Multi-AZ database deployment to ensure service continuity (or early recovery) even if a specific region goes down.

## 3. Business Continuity Plan (BCP)
*   **Elimination of Key Person Risk**:
    *   Eliminate "code that only specific engineers can touch". Maintain a state where anyone can perform recovery work through documentation and code standardization.
    *   **Emergency Contact Network**: Secure emergency contact means other than Slack (phone, other chat tools).
