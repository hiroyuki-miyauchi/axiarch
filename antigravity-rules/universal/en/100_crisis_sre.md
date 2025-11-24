# 100. Crisis Management & SRE

## 1. Incident Response Protocol
*   **Roles**:
    *   **Commander**: Takes command and makes decisions. Does not touch code.
    *   **Communicator**: Handles external communication (Status Page, SNS).
    *   **Resolver**: Investigates and fixes the technical issue.
*   **First Response**:
    *   **Stop the Bleeding**: Prioritize stopping the damage (disable feature, rollback) over finding the root cause.
    *   **Transparency**: Inform users immediately that "We are investigating". Silence breeds distrust.

## 2. SRE (Site Reliability Engineering)
*   **SLO/SLI**:
    *   **SLI (Service Level Indicator)**: Metric to measure health (e.g., Error Rate, Latency).
    *   **SLO (Service Level Objective)**: Target level (e.g., 99.9% Availability).
    *   **Error Budget**: If SLO is breached, freeze new feature development and focus on reliability.
*   **Post-Mortem**:
    *   **Blameless**: Focus on "What happened" and "Why it happened", not "Who did it".
    *   **Documentation**: Create an incident report and share it.

## 3. Backup & Recovery
*   **RPO/RTO**:
    *   **RPO (Recovery Point Objective)**: How much data loss is acceptable (e.g., 1 hour).
    *   **RTO (Recovery Time Objective)**: How long to recover (e.g., 4 hours).
*   **Drills**:
    *   Conduct regular Disaster Recovery Drills to ensure backups actually work.
