# 100. Crisis Management & SRE (Site Reliability Engineering)

## 1. Incident Response Protocol (War Room)
*   **Severity Levels (SEV)**:
    *   **SEV-0 (Critical)**: All users affected, data loss. Immediate response (24/365).
    *   **SEV-1 (Major)**: Major features (Payment, Login) unavailable. Call out even outside business hours.
    *   **SEV-2 (Minor)**: Partial malfunction. Handle next business day.
*   **War Room**:
    *   If SEV-1 or higher occurs, immediately establish a "War Room" (dedicated chat/call) and do not disband until resolved.
    *   **Roles**:
        *   **Commander**: Overall command, decision making (Owner or AI).
        *   **Ops**: Actual fix implementation (AI).
        *   **Comms**: Status reporting to users (AI).

## 2. Blameless Post-Mortem
*   **Philosophy**:
    *   Ask "Why did the system allow the error?" not "Who made the mistake?"
    *   Create a detailed Post-Mortem report within 24 hours after incident resolution.
*   **Action Items**:
    *   Must implement preventive measures and add them to the task list.

## 3. Disaster Recovery (DR)
*   **Backup Strategy**:
    *   Enable automatic backups for Firestore/Cloud SQL and conduct regular restore drills.
*   **Playbooks**:
    *   Prepare specific response procedures (Playbooks) in advance for scenarios like "DB wipeout" or "API down."
