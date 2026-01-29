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
*   **Risk**: Prompt injection causing "mass hate speech generation" or API loops causing "cloud bankruptcy".
*   **The Global Kill Switch Implementation (Zero Re-deploy)**:
    *   **Law**: Emergency stop switches MUST be implemented via **Edge Config** (Vercel) or **DB Flags** (`system_settings`) requiring no re-deploy. "Fix code and deploy" is too slow.
    *   **Action**: Check flags like `ai_enabled`, `billing_enabled` in Middleware, returning 503 immediately when OFF.
*   **Solution**: Implement an "Emergency Stop Switch (Global Kill Switch)" that can halt all AI features instantly without waiting for code re-deploy. Control via Edge Config or DB flags (`ai_enabled: false`).
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

## 6. Post-Mortem & Learning
*   **The Blameless Post-Mortem Protocol**:
    *   **Law (No Witch Hunts)**: When incidents occur, pursuing individual blame is **strictly prohibited**. Ask "why did the system allow him to make a mistake" not "why did he make a mistake". This is the "Blameless" principle.
    *   **Action (5 Whys)**: Repeat "Why?" 5 times to reach the true root cause. "Human error" is not a cause, but only a starting point for investigation.
    *   **Output (Systemic Fix)**: Post-mortem completion criteria is submission of a PR containing **"new automated test"** or **"new Lint rule"** that physically prevents recurrence. "Be more careful" or "update manual" are not accepted as countermeasures.
