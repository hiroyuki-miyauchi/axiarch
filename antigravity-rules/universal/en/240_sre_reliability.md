# 240. SRE & Reliability

## 1. SLI / SLO (Service Level Objectives)
*   **Definitions**:
    *   **SLI (Indicator)**: Metrics to measure (e.g., HTTP request success rate, latency).
    *   **SLO (Objective)**: Target level (e.g., 99.9% availability).
*   **Error Budget**:
    *   As long as there is remaining error budget (SLO surplus), actively release new features. Conversely, if the budget is depleted, stop feature development and allocate resources to reliability improvement.

## 2. Incident Management
*   **Blameless Post-mortem**:
    *   **Purpose**: Pursue "Why the system failed" instead of "Who was at fault".
    *   **Documentation**: After a major incident (SEV-1/SEV-2), always create a Post-Mortem (incident report) and agree on Action Items to prevent recurrence.
*   **On-Call**:
    *   **Rotation**: Rotate on-call duties using PagerDuty etc. so that the burden does not concentrate on specific individuals.
    *   **Escalation**: Set automatic escalation rules for when the primary responder does not react.

## 3. Observability
*   **Three Pillars**:
    *   **Metrics**: Numerical data (CPU usage, RPS). Used for trend grasping.
    *   **Logs**: Detailed records of events. Used for debugging.
    *   **Traces**: Request path tracking. Used for bottleneck identification.
    *   Introduce tools (Datadog, Cloud Monitoring) that can monitor these integrally.
