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
*   **The Incident Response Timeline**:
    *   **Law**: Time targets for "Detection → Initial Response → Resolution" MUST be clearly defined per severity level to prevent response delays.
    *   **Timeline Matrix**:

        | Level | Detection → Initial Response | Initial Response → Resolution | Communication | Examples |
        |:------|:----------|:----------|:---------------|:---|
        | **SEV-1** | **Within 15 min** | **Within 1 hour** | Status Page + Company-wide notification | Full outage, Data loss |
        | **SEV-2** | **Within 30 min** | **Within 4 hours** | Status Page + Team notification | Major feature outage, Auth failure |
        | **SEV-3** | **Within 2 hours** | **Within 24 hours** | Chat notification channel | UI breaks, Speed degradation |

    *   **On-Call Escalation**: If the Primary on-call does not respond within the initial response deadline, automatically escalate to the Secondary.
    *   **6-Step Incident Flow**:
        1.  **Detection**: Monitoring alert or user report
        2.  **Classification**: Severity level determination
        3.  **Declaration**: Declare in incident notification channel (e.g., "SEV-1: Payment Function Outage in Progress")
        4.  **Response**: Rollback / Hotfix / Temporary block
        5.  **Resolution**: Status page update, recovery notification
        6.  **Review**: Conduct Post-Mortem within 48 hours

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
*   **The Status Page Component Health Matrix**:
    *   **Law**: The status page MUST display the operational status of each service component individually in real-time. Maintain a state where users can immediately identify \"which component is affected\" rather than just \"there is a general outage.\"
    *   **Component Categories (Minimum Categories)**:

        | Category | Monitoring Target (Example) | Health Check Method (Example) |
        |:--------|:-------------|:---------------------|
        | **Web Application** | Frontend / Edge | HTTP 200 response confirmation |
        | **API** | Backend API | Response time ≦ threshold |
        | **Database** | Primary DB | Connection pool usage |
        | **Authentication** | Auth infrastructure | Login success rate |
        | **Media Delivery** | CDN / Storage | CDN hit rate |
        | **External Integrations** | Payment / AI / Email etc. | Response success rate |

    *   **Status Levels**: Display status in the following 4 levels so users can intuitively understand the impact severity.
        *   `Operational` — Normal operation
        *   `Degraded Performance` — Performance degradation
        *   `Partial Outage` — Partial failure
        *   `Major Outage` — Full outage
*   **The Incident Notification Template**:
    *   **Law**: Incident notifications to users MUST be issued based on pre-prepared templates, not hastily written free-form text. Prevent information omission and inappropriate expressions to maintain trust.
    *   **Initial Report Template**:

        ```
        [Incident Report] Notice regarding {Component Name}

        Thank you for using {Service Name}.
        We are currently experiencing {Symptom} with {Component Name}.

        ■ Occurrence Time: {YYYY-MM-DD HH:MM UTC}
        ■ Impact Scope: {Affected Features}
        ■ Current Status: Investigating / Recovery in Progress

        We sincerely apologize for the inconvenience.
        We will update this page as soon as recovery is confirmed.
        ```

    *   **Required Fields**: Incident notifications (initial report, updates, recovery report) MUST include at least the following fields.
        *   **Occurrence Time**: Exact date and time when the incident was first detected
        *   **Impact Scope**: Identification of affected features and user segments
        *   **Current Status**: Progress of "Investigating / Cause Identified / Recovery in Progress / Recovered"
        *   **Next Update ETA**: Scheduled time for the next update (to prevent silence)

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

### 5.1. The Vendor Incident Coordination Protocol
*   **Law**: Response flows MUST be defined in advance for cases where external vendor (cloud provider, SaaS, payment service, etc.) outages propagate to your own service. "It's the vendor's problem, we can only wait" is an abdication of business continuity.
*   **Mandate**:
    *   **Vendor Outage Response Flow**:
        1.  **Detection**: Vendor status page monitoring + anomaly detection through internal monitoring
        2.  **Impact Assessment**: Immediately evaluate which features and user segments of your service are affected
        3.  **User Notification**: Post impact scope and status on your own status page (silence prohibited even while awaiting vendor recovery)
        4.  **Alternative Execution**: Execute fallback measures (switch to alternative services, degraded mode, etc.)
        5.  **Recovery Verification**: After vendor recovery, verify normal operation of your own service
    *   **Vendor BCP Verification Obligation**: For critical vendors (High risk tier: see `60_security_privacy.md` §10.1), verify the following **once per year**:
        *   Business Continuity Plan (BCP) documentation status
        *   RPO/RTO settings and alignment with SLA
        *   Incident history and recovery track record for the past year
        *   Redundancy and backup infrastructure
    *   **Alternative Vendor Pre-Preparation**: For vendors that constitute a Single Point of Failure (SPOF), complete selection and minimum connectivity verification of alternative services in advance. "Searching for alternatives after an outage occurs" is too late.
*   **Cross-Reference**: §7 (Incident Runbooks), `60_security_privacy.md` §10 (Vendor Security Management)

## 6. Post-Mortem & Learning
*   **The Blameless Post-Mortem Protocol**:
    *   **Law (No Witch Hunts)**: When incidents occur, pursuing individual blame is **strictly prohibited**. Ask "why did the system allow him to make a mistake" not "why did he make a mistake". This is the "Blameless" principle.
    *   **Action (5 Whys)**: Repeat "Why?" 5 times to reach the true root cause. "Human error" is not a cause, but only a starting point for investigation.
    *   **Output (Systemic Fix)**: Post-mortem completion criteria is submission of a PR containing **"new automated test"** or **"new Lint rule"** that physically prevents recurrence. "Be more careful" or "update manual" are not accepted as countermeasures.
*   **The Post-Mortem Template**:
    *   **Law**: Post-Mortem reports MUST include all of the following required sections.
    *   **Required Sections**:

        | Section | Content |
        |:---------|:-----|
        | **Summary** | What happened (1-2 sentences) |
        | **Timeline** | Chronology of occurrence → detection → initial response → resolution |
        | **Impact Scope** | Number of affected users, duration of impact, whether data loss occurred |
        | **Root Cause** | Technical cause (code change, configuration error, external dependency, etc.) |
        | **Improvement Actions** | Preventive measures (specific tasks, assignees, deadlines) |
        | **Lessons Learned** | Content to be appended to the project lessons log |

    *   **Blameless Culture**: Post-Mortems MUST **focus on improving systems and processes, not blaming individuals**.

## 7. Incident Runbooks
*   **The Incident Runbook Framework**:
    *   **Law**: Concrete procedure documents (runbooks) MUST be created in advance for major failure scenarios (database failures, CDN failures, payment system failures, etc.). Incident response without runbooks is "firefighting in the dark" and significantly prolongs recovery time.
    *   **Runbook Template**: Each runbook MUST follow the structure below.

        | Step | Content |
        |:--------|:-----|
        | **1. Confirm** | Confirm the fact of failure occurrence (status page / monitoring tools) |
        | **2. Diagnose** | Isolate the cause (check metrics / logs) |
        | **3. Mitigate** | Reduce impact scope (configuration changes / resource scaling) |
        | **4. Fallback** | Switch to fallback measures (redundancy / alternative services) |
        | **5. Notify** | Notify via status page / notify users |
        | **6. Recover** | Restore to normal state / Create Post-Mortem |

    *   **Coverage (Minimum Scenarios)**: Define project-specific runbooks in the Blueprint for the following scenarios.
        *   **Database Failure**: Connection pool exhaustion, replica lag, restore from backup
        *   **CDN/Media Delivery Failure**: Cache purge, switch to direct delivery
        *   **Payment System Failure**: Maintenance banner display, reconciliation of unprocessed transactions
        *   **Authentication Infrastructure Failure**: Session management fallback
    *   **Cross-Reference**: §1 (Incident Response), §4 (Disaster Recovery), §6 (Post-Mortem)
