# 40. Operations Workflow (SRE & DevOps)

## 1. Incident Response
*   **Severity Levels**:
    *   **SEV-1 (Critical)**: Service down, data loss, security breach. Requires **Immediate Response** (24/365). Summon all engineers.
    *   **SEV-2 (High)**: Major feature malfunction (e.g., payment failure). Requires fix within the same day.
    *   **SEV-3 (Medium)**: Minor bug, UX degradation. Handle in the next sprint.
*   **On-Call Rotation**:
    *   Introduce PagerDuty etc. to build a system where phone notifications are sent to the person in charge when SEV-1/2 alerts occur. Do not rely on specific individuals; handle by rotation.

## 2. Post-Mortem / Retrospective
*   **Blameless Culture**:
    *   After a failure, conduct a retrospective (Post-Mortem) focusing on "Why the system allowed the error" rather than blaming individual mistakes.
*   **Prevention Measures**:
    *   Decide and execute specific Action Items to "prevent by system (add auto-tests, change permissions, review architecture)" rather than the spiritualism of "being careful".

## 3. Deployment Strategy
*   **Blue/Green Deployment**:
    *   Run new and old environments in parallel and switch traffic instantly to achieve zero-downtime releases.
*   **Canary Release**:
    *   Release new features only to a subset of users (e.g., employees only, 1% of users) and expand to all users after confirming there are no issues.
*   **Rollback**:
    *   Always maintain a state where you can immediately return to the previous version (Rollback) with one button in case of deployment failure.

## 4. Documentation as Code
*   **Runbook**:
    *   Manage incident response procedures and regular maintenance procedures as executable scripts or Markdown (Runbook) within the repository, not on a Wiki, and keep them always up-to-date.
