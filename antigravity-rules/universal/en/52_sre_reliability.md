# 52. SRE & Reliability Engineering

## 1. Chaos Engineering - "Embrace Failure"
*   **Principle**: Stand on the premise that "Systems will fail" and intentionally inject failures to test resilience.
*   **Chaos Monkey**:
    *   **Staging**: Regularly execute "Chaos" in staging (randomly delay API, kill Pods) to verify system self-healing.
    *   **Production**: Once maturity increases, conduct Game Days (Evacuation Drills) in production.

## 2. Deployment Strategy
*   **Blue/Green Deployment**:
    *   Run new and old environments in parallel and switch traffic instantly to achieve Zero Downtime Release.
*   **Canary Release**:
    *   Release new features only to a subset of users (e.g., employees only, 1%) and expand to all users after confirming no issues.
*   **Rollback**:
    *   Maintain a state where you can immediately revert to the previous version (Rollback) with one button upon deployment failure.

## 3. Compatibility Matrix - "Zero Tolerance"
*   **Browsers**:
    *   **Tier 1 (Full Support)**: Chrome (Latest 2), Safari (Latest 2), Edge (Latest 2), Firefox (Latest 2). Layout breaks or dysfunction here are **Release Blockers**.
    *   **Tier 2 (Guaranteed Operation)**: iOS Safari (Latest 2), Android Chrome (Latest 2).
*   **OS Versions**:
    *   **iOS**: Latest Major Version and previous one (e.g., iOS 17 & 16).
    *   **Android**: Major versions released within last 4 years (e.g., Android 14, 13, 12, 11).
*   **Real Device Testing**:
    *   Verify operation on actual devices (especially low-spec Android) using BrowserStack etc., not just simulators.

## 4. SLI / SLO (Service Level Objectives)
*   **Definitions**:
    *   **SLI (Indicator)**: Metrics to measure (e.g., HTTP success rate, latency).
    *   **SLO (Objective)**: Target level (e.g., 99.9% availability).
    *   **The 99.9% Promise**: Target 99.9% monthly uptime. Planned maintenance requires 72-hour advance notice.
*   **Error Budget**:
    *   **Policy**: If Error Budget is depleted, **freeze new feature releases**. Dedicate 100% of engineering resources to reliability improvement. This is an agreement with management.

## 5. Incident Management
*   **Blameless Post-mortem**:
    *   **Purpose**: Pursue "Why the system failed", not "Who was wrong".
    *   **Documentation**: After major incidents (SEV-1/SEV-2), always create a Post-mortem report and agree on Action Items to prevent recurrence.
    *   Prepare Playbooks for specific scenarios ("When DB vanishes", "When API is down") in advance.
    *   **The 15-Minute Rule**: Start initial response within 15 mins for critical incidents. Target 4-hour recovery.
*   **On-Call**:
    *   **Rotation**: Rotate on-call duty using PagerDuty etc. to avoid concentrating burden on specific individuals.
    *   **Escalation**: Set auto-escalation rules if the primary responder does not react.

## 6. Observability
*   **Three Pillars**:
    *   **Metrics**: Numerical data (CPU, RPS). Used for trend grasping.
    *   **Logs**: Detailed event records. Used for debugging.
    *   **Traces**: Request path tracking. Used for bottleneck identification.
    *   Introduce tools (Datadog, Cloud Monitoring) that can monitor these integrally.

## 7. Data Durability
*   **RPO / RTO**:
    *   **RPO (Recovery Point)**: **24 hours**. Backup daily.
    *   **RTO (Recovery Time)**: **2 hours**. Maintain procedures to restart within 2 hours.
