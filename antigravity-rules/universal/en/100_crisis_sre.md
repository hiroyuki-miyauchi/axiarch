# 100. Crisis Management & SRE

## 1. Incident Response Protocol
*   **Roles**:
    *   **Commander**: Takes command of the whole situation and makes decisions. Does not perform technical work.
    *   **Communicator**: Responsible for reporting status to users and stakeholders (Status Page updates, SNS posts).
    *   **Resolver**: Performs actual technical investigation and fixes.
*   **First Response**:
    *   **Stop the Bleeding**: Prioritize preventing the spread of damage (feature shutdown, rollback) over finding the root cause.
    *   **Transparency**: Immediately inform users that you are "Investigating". Silence breeds distrust.

## 2. SRE (Site Reliability Engineering)
*   **SLO/SLI**:
    *   **SLI (Service Level Indicator)**: An indicator to measure service health (e.g., error rate, latency).
    *   **SLO (Service Level Objective)**: The target level (e.g., 99.9% availability).
    *   **Error Budget**: If the SLO is exceeded, stop developing new features and concentrate resources on improving reliability.
*   **Post-Mortem**:
    *   **Blameless**: Discuss "What happened", "Why it happened", and "How to prevent recurrence" instead of "Who was at fault".
    *   **Documentation**: Create an incident report and share it company-wide.

## 3. Backup & Recovery
*   **RPO/RTO**:
    *   **RPO (Recovery Point Objective)**: To what point in time data can be restored (e.g., 1 hour ago).
    *   **RTO (Recovery Time Objective)**: Allowable time until recovery (e.g., within 4 hours).
*   **Drills**:
    *   Conduct regular Disaster Recovery Drills to confirm that data can actually be restored from backups.
*   **Playbooks**:
    *   Prepare specific response procedure manuals (Playbooks) in advance for scenarios like "DB data loss" or "API downtime".
