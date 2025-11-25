# 53. Crisis Management & BCP

## 1. Incident Response - "War Room"
*   **Severity Levels**:
    *   **SEV-1 (Critical)**: Service down, data loss, security breach. **Immediate response** (24/365) required. Summon all engineers.
    *   **SEV-2 (High)**: Major feature malfunction (payment impossible etc.). Fix required within the day.
    *   **SEV-3 (Medium)**: Minor bug, UX degradation. Handle in next sprint.
*   **War Room Setup**:
    *   **Criteria**: If SEV-1 or SEV-2 occurs, immediately set up a "War Room" (Slack channel `#incident-yyyy-mm-dd` + Google Meet).
*   **Roles**:
    *   **Commander**: The only person making overall decisions. Does not do technical work.
    *   **Ops Lead**: Directs and executes actual recovery work.
    *   **Comms Lead**: Reports status regularly (every 30 mins) to users and internal team.
    *   **Scribe**: Records all events and timestamps for later Post-mortem.

## 2. Communication Templates
*   **Principle**: "Silence breeds distrust". Keep communicating status even if not resolved.
*   **Status Page**:
    *   **Investigating**: "We have detected access issues and are investigating."
    *   **Identified**: "Cause identified (DB load). Recovery work in progress."
    *   **Monitoring**: "Fix applied, currently monitoring."
    *   **Resolved**: "Recovered. We apologize for the inconvenience."
*   **User Email**:
    *   In case of major incidents like data breach, use legally vetted templates and notify swiftly and transparently.

## 3. Data Breach Protocol
*   **Stop the Bleeding**:
    *   If data breach or unauthorized access is suspected, "Stop the Bleeding" without hesitation. Prioritize invalidating API keys, shutting down servers, blocking access.
    *   **Assess**: After stopping bleeding, calmly identify impact scope (leaked data, number of affected users).
    *   **Notify**: Notify users and regulatory authorities according to legal requirements (GDPR 72-hour rule etc.).

## 4. Disaster Recovery
*   **RPO / RTO**:
    *   **RPO (Recovery Point Objective)**: How much data loss is acceptable (e.g., up to 1 hour ago).
    *   **RTO (Recovery Time Objective)**: Within how many hours to recover after down (e.g., within 4 hours).
*   **Cloud Redundancy**:
    *   Use AWS S3 Cross-Region Replication or Multi-AZ DB deployment to continue service (or recover early) even if a specific region goes down.

## 5. Business Continuity Plan (BCP)
*   **Eliminating Key Person Risk**:
    *   Eliminate "Code only specific engineers can touch". Maintain a state where anyone can perform recovery work through documentation and code standardization.
    *   **Emergency Contact**: Secure emergency contact means other than Slack (Phone, other chat tools).
