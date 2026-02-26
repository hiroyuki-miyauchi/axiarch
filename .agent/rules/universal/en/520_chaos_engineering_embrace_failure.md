# 52. SRE & Reliability Engineering

## 1. Chaos Engineering - "Embrace Failure"
*   **Principle**: Stand on the premise that "Systems will fail" and intentionally inject failures to test resilience.
*   **Chaos Monkey**:
    *   **Staging**: Regularly execute "Chaos" in staging (randomly delay API, kill Pods) to verify system self-healing.
    *   **Production**: Once maturity increases, conduct Game Days (Evacuation Drills) in production.

## 2. Deployment Strategy
*   **Supreme Directive: The Automated Deployment Mandate (CD First Protocol)**:
    *   **Law**: Database changes and application deployments to production MUST **NEVER be done via developer's manual commands (e.g., `supabase db push` from local terminal)**.
    *   **Prohibition**: "Manual Deploy" is "engineering suicide" that invites operation mistakes and causes history inconsistencies.
    *   **Action**: Deployments MUST be automatically executed as a result of **"Verified Code (Pull Request)"** passing through **"Trusted Pipeline (GitHub Actions)"**.
*   **Blue/Green Deployment**:
    *   Run new and old environments in parallel and switch traffic instantly to achieve Zero Downtime Release.
*   **Canary Release**:
    *   Release new features only to a subset of users (e.g., employees only, 1%) and expand to all users after confirming no issues.
*   **Rollback**:
    *   Maintain a state where you can immediately revert to the previous version (Rollback) with one button upon deployment failure.
*   **The Gatekeeper Protocols (Zero Tolerance Mandate)**:
    *   **Linter Zero Tolerance**: CI does not tolerate `Warning`. Mandate `eslint --max-warnings=0`.
    *   **Husky Guard (Universal Defense)**: Regardless of server-side protection, mandate defense via `husky` `pre-push` hook across all repositories. Make "accidentally pushed" physically impossible.
*   **The Husky Guard (Universal Defense Mandate)**:
    *   **Law**: All projects MUST install **Husky** and configure `pre-push` hook to prohibit direct push to `main` (and `master`) branches as **Universal Mandate**. "Being careful" is meaningless psychological operation; only physical defense lines in code are trusted.
    *   **Action**: Set up guardrails at project initialization. Double defense lines are the supreme duty, not relying on server-side protection (Branch Protection) alone.
*   **The Branch Hygiene Mandate (Clean Up After Yourself)**:
    *   **Law**: Leaving working branches invites accidents from environment differences. "Delete after merge" is engineer's breathing.
    *   **Action**: Before Final Notify, always check `git branch --merged` and automatically delete merged local working branches.
*   **The Preview Environment Evacuation Protocol (Abandon, Don't Repair)**:
    *   **Trigger**: When a fatal migration history inconsistency occurs in a Preview environment (branch DB, etc.).
    *   **Law**: Do NOT waste time repairing the integrity of disposable environments. Immediately abandon the environment and create a new branch (e.g., `fix/fresh-start-xxx`) to migrate.
    *   **Rationale**: Preview environments are designed as "disposable." Repair cost always exceeds recreation cost.

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
*   **The Request ID Protocol (Zero Search Time)**:
    *   **Law**: API responses and error responses MUST always include tracking `requestId` (`x-request-id`).
    *   **Source**: Adopt reliable ID such as `x-nonce` header generated in middleware or UUID.
    *   **Usage**: On error, user or AI agent presents this ID so developers can immediately identify cause from logs (Zero Search Time).
    *   **Mandate**: Recommend including this ID in both response header and error JSON body.
*   **The Client Observability Mandate (Frontend Monitoring)**:
    *   **Law**: Mandate introduction of **Sentry** or equivalent monitoring tool to observe script errors (Uncaught Exception) and hydration errors on frontend (Browser).
    *   **Scope**: Enable only in production (`NODE_ENV=production`) and don't pollute dev environment console.
    *   **Outcome**: Visualize silent errors occurring without user reports and connect to quality improvement.
*   **The Health Check Protocol (Liveness Probe)**:
    *   **Law**: All applications MUST maintain `/api/health` or `/healthz` endpoint and accept liveness monitoring from load balancers and monitoring tools.
    *   **Response**: Recommend returning status code `200 OK` with basic health info like DB connection state, cache connection state.
*   **The Correlation ID Tracing Protocol (Distributed Tracing)**:
    *   **Law**: Attach correlation ID (`correlation_id`) to complex distributed transactions (payment, AI generation, multi-step processes like email sending) to enable end-to-end log tracing (OpenTelemetry philosophy).
    *   **Scope**: Propagate ID generated at request origin to all related service calls (Edge Function, external API).
    *   **Outcome**: Maintain state to immediately identify "which request, at which service, at which step failed" on incident.
*   **API Performance Threshold (The Response Time Standard)**:
    *   **Target**: API responses should target **under 100ms**.
    *   **Warning**: Requests exceeding 1000ms should be automatically logged at `warn` level. If sustained latency is observed, review cache strategy or query optimization.

## 7. Data Durability
*   **RPO / RTO**:
    *   **RPO (Recovery Point)**: **24 hours**. Backup daily making worst case restoring to previous day possible.
    *   **RTO (Recovery Time)**: **2 hours**. Establish restore procedures from backup targeting service restart within 2 hours.
*   **The Fire Drill Protocol (Recovery Drill Obligation)**:
    *   **Mandate**: Mandate quarterly "recovery drill" that actually restores from backup and confirms normal operation. Untested backup is considered "non-existent".
*   **The Off-Site Backup Mandate**:
    *   **Risk**: Total data loss from cloud provider failure itself or account freeze.
    *   **Mandate**: In addition to main DB auto-backup, mandate periodic logical backup transfer to external storage (S3/R2 etc.) operating as "Noah's Ark".
