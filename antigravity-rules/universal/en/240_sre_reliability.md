# 240. SRE & Reliability

## 1. SLI / SLO (Service Level Objectives)
*   **Definitions**:
    *   **SLI (Indicator)**: The metric to measure (e.g., HTTP request success rate, latency).
    *   **SLO (Objective)**: The target level (e.g., 99.9% availability).
*   **Error Budget**:
    *   As long as there is remaining Error Budget (SLO surplus), release new features aggressively. Conversely, if the budget is exhausted, halt feature development and dedicate resources to reliability improvements.

## 2. Incident Management
*   **Blameless Post-mortem**:
    *   **Goal**: Seek "Why the system failed," not "Who was at fault."
    *   **Documentation**: After a major incident (SEV-1/SEV-2), always create a Post-mortem report and agree on Action Items to prevent recurrence.
*   **On-Call**:
    *   **Rotation**: Use tools like PagerDuty to rotate on-call duties to avoid burdening specific individuals.
    *   **Escalation**: Set automatic escalation rules if the primary responder does not acknowledge.

## 3. Observability
*   **Three Pillars**:
    *   **Metrics**: Numerical data (CPU usage, RPS). Used for trend analysis.
    *   **Logs**: Detailed event records. Used for debugging.
    *   **Traces**: Request path tracking. Used for identifying bottlenecks.
    *   Implement tools (Datadog, Cloud Monitoring) that can monitor these integrally.
