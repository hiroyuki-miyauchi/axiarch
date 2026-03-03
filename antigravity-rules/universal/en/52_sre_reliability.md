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
*   **The Deployment Rollback Protocol**:
    *   **Context**: When \"how to roll back\" is undefined during production incidents, outages are prolonged and user trust is damaged.
    *   **Pre-Deployment Gate**:
        1.  `tsc --noEmit` (type check) ✅
        2.  `npm run build` (build check) ✅
        3.  Explicit approval from responsible person
    *   **Rollback Criteria**: Execute **immediate rollback** if any of the following thresholds are met.
        | Metric | Threshold | Decision |
        |:-------|:----------|:---------|
        | Error Rate (5xx) | > 5% (5 min window) | Immediate Rollback |
        | P95 Response Time | > 2000ms (10 min window) | Immediate Rollback |
        | Core Web Vitals CLS | > 0.25 | Emergency Investigation + Rollback Consideration |
        | Monitoring Tool P0 Error | 1 or more | Immediate Rollback |
    *   **Destructive Migration Constraint**: Deployments including destructive migrations such as `ALTER TABLE DROP COLUMN` are non-rollbackable and **MUST receive explicit approval from the responsible person** before release.
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
    *   **Status Page (Incident Transparency)**: Set up an external status page and provide transparent information to users during incidents. Concealing incidents means "death of trust".
*   **Error Budget**:
    *   **Policy**: If Error Budget is depleted, **freeze new feature releases**. Dedicate 100% of engineering resources to reliability improvement. This is an agreement with management.
*   **The SLI/SLO Template**:
    *   **Law**: SLI/SLO MUST be defined at project start and reviewed monthly. The template below provides the **structural framework**; specific target values should be adjusted in the project-specific Blueprint.
    *   **Template**:

        | Service Category | SLI (Indicator) | SLO (Target Example) | Measurement Method (Example) |
        |:--------------|:----------|:------------|:-------------|
        | **Overall Uptime** | Successful Requests / Total Requests | ≧ 99.9% (≦ 43 min downtime/month) | UptimeRobot / Analytics |
        | **Primary API** | P95 Response Time | ≦ 200ms | Canonical Log Line aggregation |
        | **Detail Page API** | P95 Response Time | ≦ 300ms | Canonical Log Line aggregation |
        | **Static Asset Delivery** | P95 TTFB | ≦ 100ms | CDN Analytics |
        | **AI Response** | P95 Response Time | ≦ 3000ms | AI FinOps Dashboard |
        | **Error Rate** | 5xx Response Ratio | ≦ 0.1% | Error Tracking Tool + Server Logs |

    *   **Error Budget Policy**: When SLO is not met, pause new feature development and concentrate resources on reliability improvement (see §4 Error Budget).
    *   **Review Cadence**: Review SLI/SLO achievement status monthly and revise thresholds as needed.

## 5. Incident Management
*   **Blameless Post-mortem**:
    *   **Purpose**: Pursue "Why the system failed", not "Who was wrong".
    *   **Documentation**: After major incidents (SEV-1/SEV-2), always create a Post-mortem report and agree on Action Items to prevent recurrence.
    *   Prepare Playbooks for specific scenarios ("When DB vanishes", "When API is down") in advance.
    *   **The 15-Minute Rule**: Start initial response within 15 mins for critical incidents. Target 4-hour recovery.
    *   **Post-Mortem Deadline**: Within **24 hours** after incident resolution, document Root Cause Analysis (RCA) and preventive measures and share with stakeholders.
    *   **Degraded Mode (Interim Measures)**: If recovery exceeds the MTTR target (4 hours), do not wait for full recovery—decide to switch to **Degraded Mode (feature-limited mode)**. Maintain only core functions and localize the impact.
*   **On-Call**:
    *   **Rotation**: Rotate on-call duty using PagerDuty etc. to avoid concentrating burden on specific individuals.
    *   **Escalation**: Set auto-escalation rules if the primary responder does not react.
*   **Escalation Channel Matrix (Severity-Based Notification Channels)**:
    *   Select notification channels based on incident severity to avoid overlooking Critical incidents and alert fatigue from Low ones.

        | Severity | Notification Channel | Response Deadline | Examples |
        |:---------|:--------------------|:-----------------|:---------|
        | **P0 (Critical)** | Phone/SMS + Instant notification channel | **15 min** | Service-wide outage, Data loss, Security breach |
        | **P1 (High)** | Instant notification channel + PagerDuty | **1 hour** | Major feature outage, Payment error rate >1% |
        | **P2 (Medium)** | Warning notification channel | **4 hours** | Non-critical feature issues, Performance degradation |
        | **P3 (Low)** | Email + Issue Tracker | **Next business day** | Minor UI bugs, Increasing log warnings |

    *   **Auto-Routing**: Auto-route alerts by severity via monitoring tool rules. Do not rely on manual judgment.

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
    *   **Recording Obligation**: Record drill results (elapsed time, issues encountered, improvements) and audit RTO compliance. Drills without records are considered "not conducted".
*   **The Off-Site Backup Mandate**:
    *   **Risk**: Total data loss from cloud provider failure itself or account freeze.
    *   **Mandate**: In addition to main DB auto-backup, mandate periodic logical backup transfer to external storage (S3/R2 etc.) operating as "Noah's Ark".

## 8. Maintenance & Resilience
*   **Maintenance Mode**:
    *   **Switch**: Manage maintenance state via DB settings (`site_settings`) and check in both Middleware and Server Actions. Physically block writes from backdoors.
*   **Circuit Breaker**:
    *   Set timeouts on external API calls and return default values on failure (Fail Safe).
*   **Job Queue**:
    *   Decouple heavy processing like email sending and image analysis from API response cycle, and execute asynchronously with **Supabase Edge Functions + pgmq**.

### 8.1. The IPv6 Deployment Protocol (Connection Hygiene)
*   **Context**: Mandate appropriate configuration to prevent connection errors from IPv6 name resolution issues between CI environments like GitHub Actions and Supabase.
*   **Action**:
    *   **Official Link**: Use `supabase link` to establish proper routes like Connection Pooler. OS hacks via `gai.conf` are vulnerabilities.
    *   **Auth Token**: For CI environment auth, MUST use **Personal Access Token (PAT)** instead of project API key (`SUPABASE_ACCESS_TOKEN`). Name token `GitHub Actions CI` to limit leak impact scope.

### 8.2. The Lockfile Integrity Protocol (Lockfile Sanctuary)
*   **Law**: `package-lock.json` (or `pnpm-lock.yaml`, `yarn.lock`) is the "sanctuary" guaranteeing dependency integrity. "Context Deadline Exceeded" or "Missing from lock file" errors in CI are 90% caused by lockfile inconsistency.
*   **Action**: When encountering dependency errors in CI, don't waste time investigating—immediately **delete lockfile and `node_modules`, rerun `npm install` to regenerate lockfile and push**. This is the shortest and only correct answer.

### 8.3. The Environment Verification Protocol (Connection Check)
*   **Law**: When database connection error occurs, MUST check `.env.local`'s `NEXT_PUBLIC_SUPABASE_URL` before proposing solutions to identify **"where it's trying to connect (Target)"**.
*   **Anti-Pattern**: Prohibit judging only by error message (symptom) and instructing user with "Docker is down" speculation. Actually trying to connect to remote is the majority case.

### 8.4. The Unified Observability Protocol
*   **Law**: When logs, traces, and audit logs are fragmented, enormous time is wasted identifying root causes of failures.
*   **Action**:
    1.  **Trace ID Everywhere**: Attach a trace ID (`x-request-id` / `correlation_id`) to every request and consistently include it in logs, errors, and audit logs.
    2.  **Structured Logging**: Output logs in **JSON format (structured logging)** instead of human-readable plaintext. This dramatically improves search and filtering in log aggregation tools (Datadog, Loki, etc.).
    3.  **PII Masking**: Including PII (email, phone numbers, tokens, etc.) in structured logs is prohibited. Implement automatic masking (`***MASKED***`) at the Logger level.
    4.  **Bi-Directional Trace**: Record trace IDs in audit logs (`audit_logs`) as well, enabling bi-directional tracing: "this operation was executed as part of this request."
    5.  **Log Level Standard**: Operate log levels strictly according to the following criteria.
        *   `error`: Exception occurred, unrecoverable state — always output in production.
        *   `warn`: Deprecated usage, performance concerns — always output in production.
        *   `info`: Important business events (registration complete, payment success, etc.) — always output in production.
        *   `debug`: Detailed development information — **disabled** in production.
    6.  **Canonical Log Lines**: At request completion, output a **single aggregated log line** containing method, path, status code, duration, DB query count, and cache hit status. This enables grasping the full request picture in one line, accelerating analysis and debugging.
*   **Outcome**: Maintain the ability to identify within 60 seconds: "Which user, which request, which service, and why did this error occur?"

### 8.5. The Code-Not-Policy Mandate
*   **Law**: Human "promises" and "operational rules" are inevitably broken. To guarantee rule effectiveness, enforcement MUST be through **code-based physical constraints (CI, Git Hooks, automated check scripts)**.
*   **Action**:
    1.  **Automate Enforcement**: For any "must not" rule, implement automated checks in CI pipelines (with `Exit 1` on violation). Writing it in a Wiki alone is insufficient.
    2.  **Git Hooks**: Even in local development environments, enforce minimum checks (linting, type checking, push-to-protected-branch prevention) through `pre-commit` / `pre-push` hooks.
    3.  **Physical Impossibility**: The ideal is "designs where violation is physically impossible." For example, validate environment variables at application startup and refuse to start if they are missing.
*   **Rationale**: Document-based operational rules assume "someone will read them," and that assumption is always betrayed. Only code-based enforcement is a trustworthy defense line.

### 8.6. The Enterprise Audit Traceability Mandate
*   **Law**: Destructive operations (deletion, updates, permission changes, authentication events, etc.) MUST be instrumented with audit logs recording **"who, when, what, and how it was changed."**
*   **Action**:
    1.  **All Destructive Operations**: Record audit logs for data creation/update/deletion, authentication state changes (login/logout/OTP verification, etc.), and permission changes.
    2.  **Before/After**: Record states before and after changes to enable diff tracking.
    3.  **Correlation**: Include trace IDs in audit logs to enable tracking operations within the context of the entire request.
    4.  **Human-Readable Labels**: Display audit log operation names as labels understandable by non-engineer administrators (in the operator's native language).
*   **Rationale**: A state where "we don't know who changed it" makes both "proof of innocence" and "detection of fraud" impossible in multi-administrator environments. This is a critical security deficiency.

### 8.7. The Fail-Fast Configuration Mandate
*   **Law**: At application startup, **validate the existence and format** of all critical environment variables (API keys, DB credentials, encryption keys, etc.), and immediately terminate the process (Crash) if any are missing or malformed.
*   **Action**:
    1.  **No Silent Fallbacks**: Silent fallbacks using default values (`|| ''`, `?? 'default'`) are prohibited for critical configuration items. Fallback to empty strings breeds inexplicable permission errors and silent write failures at runtime.
    2.  **Startup Validation**: Execute guard functions like `validateConfig()` at application startup and immediately crash (`process.exit(1)`) on missing required items.
    3.  **Hard Reset Protocol**: When suspicious behavior related to environment variables (permission errors, silent failures, etc.) occurs, don't just check `.env` entries — **physically terminate the development server process and restart from a clean state**. Most frameworks do not hot-reload `.env` changes.
    4.  **Diagnostic Logging**: When debugging, log "key length" and "presence (boolean)" as separate variables rather than the sensitive values themselves, avoiding the impact of automatic masking.
*   **Rationale**: Missing environment variables run the application in a state that "appears normal but lacks permissions." When privileged client keys are missing in particular, all writes are silently rejected causing "Phantom Success," wasting enormous time on root cause identification.

### 8.8. The Decomposition-Based Triage Protocol
*   **Law**: When defects occur after large-scale changes (multi-file refactoring, security hardening, etc.), use **staged rollback by functional group** to identify the minimum reproducible unit, rather than performing a mass rollback.
*   **Action**:
    1.  **Isolation by Decomposition**: For defects after modifying multiple files, first roll back "the most suspicious UI component," then progressively roll back "server-side changes" by functional group to narrow down the source.
    2.  **The "Stash & Verify" Tactic**: If partial rollback doesn't resolve the issue, use `git stash` to return the working directory to a completely clean state (last commit) and determine whether the defect is "a regression from this change" or "a latent bug that existed previously."
    3.  **Atomic Verification**: After each staged rollback, always restart the development server, clear build caches, then verify behavior. Prevent false judgments caused by cache residue.
    4.  **Server Log Sovereignty**: To determine whether UI defects originate from server-side or client-side, use server logs (HTTP status, error stacks) as the primary information source. If all requests return `200 OK`, the cause can be isolated to the client side.
*   **Rationale**: Mass application of large-scale changes causes "Blast Radius explosion," making it extremely difficult to identify which file's which change caused the defect. Especially when frontend lifecycle changes (React Hooks, useEffect, etc.) intersect with backend changes, root cause isolation is virtually impossible without staged decomposition.

### 8.9. The Post-Change Cache Reset Protocol
*   **Law**: When modifying application core query logic (filter conditions, data retrieval specifications), visibility guards (RLS policy-related), or environment variables, **forced termination of the development server and clean restart** before verification is mandatory.
*   **Action**:
    1.  **Kill and Restart**: Before testing changes, reliably terminate the development server process (using `lsof -ti:<port> | xargs kill -9`, etc.) and restart from a clean state. Simply "saving and reloading" may cause framework caches to continue returning stale results.
    2.  **Cache Purge**: It is recommended to physically delete framework-specific cache directories (`.next/cache`, `node_modules/.cache`, etc.) before restarting.
    3.  **Env Reload**: Environment variable (`.env` file) changes are not hot-reloaded by most frameworks. A full process restart is always required after changes.
    4.  **False Negative Prevention**: Cache residue creates false negatives where "changes are not reflected," causing correct changes to be erroneously judged as "having no effect."
*   **Rationale**: Modern web frameworks (Next.js, etc.) have multiple cache layers (Data Cache, Router Cache, Build Cache) and may serve stale results even during development. RLS policy changes and Service layer query modifications in particular cannot be verified without cache reset, wasting unnecessary debugging time.

### 8.10. The Schema-Code Synchronization Sovereignty
*   **Law**: Even when application code achieves "Zero Defects (type check, build, and lint all pass)," the system cannot function correctly if **database schema (migrations) are not applied** to the production/staging environment. "Zero Defects" is only established when both code and schema are synchronized.
*   **Action**:
    1.  **Migration Status Check**: Before deployment and during debugging, verify that no unapplied migrations exist using `migration list` or `migration status` commands.
    2.  **Schema Drift Detection**: Verify that columns and tables referenced by type definitions (auto-generated types like `database.types.ts`) physically exist in the actual database. The existence of a type does not guarantee physical existence.
    3.  **Deploy Pipeline Integration**: In CI/CD pipelines, incorporate migration application as a **prerequisite** for code deployment. Deploying code without applying migrations causes catastrophic failures where all queries fail.
    4.  **Error Pattern Recognition**: When `column "xxx" does not exist` or `relation "xxx" does not exist` errors occur, suspect **Schema Drift** first rather than code bugs.
*   **Rationale**: TypeScript's type safety guarantees "compile-time consistency" but not "runtime consistency with the database." A "Phantom Column" — a column that exists in auto-generated type definitions but not in the actual database — is one of the most diagnostically challenging bugs that passes type checking but crashes at runtime.

## 9. FinOps & Resource Governance

### 9.1. The Vendor Lockdown Avoidance Protocol
*   **Law**: Excessive dependency on a specific cloud vendor or SaaS provider is a critical risk that threatens business continuity in the event of account freeze, service termination, or pricing changes.
*   **Action**:
    1.  **Portable Schema**: Write DB schemas, RLS policies, and triggers in standard SQL (`.sql`), minimizing dependency on vendor-specific extensions. Maintain a state where immediate migration is possible to any environment where a standard RDBMS (PostgreSQL, MySQL, etc.) operates.
    2.  **No Proprietary Lock-in**: When using vendor-proprietary storage, KV stores, queues, etc., access them through standard-compatible interfaces (S3-compatible API, Redis-compatible protocol, etc.) to facilitate implementation replacement.
    3.  **Domain Sovereignty**: Do NOT delegate domain NS (nameserver) management authority to the hosting provider. **Retain it yourself with an independent DNS provider (Cloudflare, etc.)** to secure control during infrastructure transitions.

### 9.2. The Domain Auto-Renewal Mandate
*   **Risk**: Domain expiration (Drop Catch) due to payment method expiry means "instant death" for the business. Once acquired by a third party, reclaiming a domain is extremely difficult.
*   **Mandate**:
    1.  Always enable **Auto-Renewal** at the domain registrar and DNS provider.
    2.  Register **2 or more** credit cards with different expiry dates as payment methods, or maintain prepaid credits (Credits) at all times.
    3.  Configure reminder notifications to arrive 60 days, 30 days, and 7 days before the domain renewal deadline.

### 9.3. The Cloud Budget Alert Protocol
*   **Law**: Operating cloud resources without budget management is a one-way ticket to "Cloud Bankruptcy."
*   **Mandatory Budget Alerts**:
    *   **Budget Actions** MUST be configured during project initialization across all cloud providers.
    *   **Thresholds**:
        | Level | Consumption Rate | Action |
        |:------|:----------------|:-------|
        | **Warning** | 50% / 80% | Slack/Chat notification |
        | **Critical** | 100% | Email + Instant notification channel mention |
        | **Panic** | 150% | Consider automatic shutdown of dev environment resources |
*   **The Spend Cap Phase Strategy**:
    *   **Phase 1 (Development & Initial Launch)**: Spend Cap = **ON**. The biggest enemy in early stages is not traffic but "your own bugs (infinite loops, excessive requests)." Protect your wallet even at the cost of system downtime.
    *   **Phase 2 (Growth & Monetization)**: Spend Cap = **OFF**. Manually disable when user surge is confirmed. This is the "investment" phase where additional costs are worth paying.

### 9.4. The Zombie Resource Elimination Protocol
*   **Law**: Leaving unnecessary cloud resources running is a "silent killer" that accumulates costs unnoticed.
*   **Action**: Scan all cloud environments monthly and physically delete unnecessary resources.
*   **Target Checklist**:
    | Target | Criteria |
    |:-------|:---------|
    | **Unused IPs** | Static IPs incur costs just by existing. Delete IPs not bound to active resources |
    | **Remaining Preview Environments** | Delete Preview Deployments / Branch DBs tied to merged PRs |
    | **Orphaned Storage** | Delete orphaned files with no corresponding records (unlinked after upload timeout) |
    | **Stopped Instances** | Check for dev DB instances etc. that still incur charges while stopped |
    | **Old Backups** | Configure automatic deletion of backups exceeding retention policy |
*   **Automation**: Recommend introducing automated cleanup scripts (Cron Jobs, etc.) based on the above checklist.

### 9.5. The Cache-First FinOps Strategy
*   **Law**: Apply cache strategies to all queries to minimize database access costs.
*   **The Cache Hierarchy**:
    | Tier | TTL (Guideline) | Target Data | DB Load |
    |:-----|:---------------|:------------|:--------|
    | **STATIC** | 86400s (24 hours) | Master data (categories, settings, terms, etc.) | Zero |
    | **WARM** | 300s (5 minutes) | Search results, list views | Low |
    | **HOT** | 60s (1 minute) | Detail pages, reviews | Medium |
    | **REALTIME** | 0s (no cache) | Payments, authentication, inventory | Maximum |
*   **Financial Impact**: Proper cache strategy can replace 80%+ of DB accesses with cache hits. This directly translates to 80% DB load reduction and dramatically suppresses infrastructure costs at scale.
*   **Mandate**: When creating new queries, always select one of the above Tiers and route through the cache layer. Marking everything as REALTIME is prohibited.

### 9.6. The AI Cost Governance Protocol
*   **Context**: AI features (LLM calls, image analysis, etc.) are usage-based billing, with costs increasing proportionally to usage. Without proper governance, they threaten business sustainability.
*   **Model Selection Strategy (Right Tool for the Job)**:
    *   **Tier 1 (High Accuracy, High Cost)**: Use for complex reasoning, creative generation, and lengthy consultations. Manage usage with Quota (usage limits) or point consumption.
    *   **Tier 2 (Fast, Low Cost)**: Use for classification, summarization, simple QA, OCR, and other routine processing. Adopt this as the default.
*   **The 30% Profitability Rule**: AI feature cost (token cost) MUST NOT exceed **30% of the plan's monthly fee** under any plan configuration. If exceeded, adjust Quota or revise plan pricing.
*   **Circuit Breaker**: Implement a circuit breaker that automatically stops AI features when API costs spike abnormally (e.g., exceeding the hourly cap) to prevent Cloud Bankruptcy.
*   **Metered Billing (100% Measurement Obligation)**: Access to APIs that incur costs (AI analysis, external data search, SMS sending, etc.) MUST be **100% metered**, and billing evidence MUST be preserved.
    *   **Asynchronous Logging**: Record measurement data asynchronously to avoid delaying responses.
    *   **Zero Exception**: Do NOT return 500 errors to users because billing log recording failed. Prioritize UX maintenance over log gaps.
    *   **Grain**: Record timestamp, user ID, and consumed resource quantities (token count, invocation count) as the minimum unit.
*   **Cost Visualization**: Recommend visualizing daily/monthly estimated costs, consumption by feature, and high-frequency users (for bot detection) in the admin dashboard.

### 9.7. The Ghost Column Prevention Protocol
*   **Law**: Using column names in application code (queries) that exist in future implementation plans (design documents) but have **not actually been applied via DB migration** is prohibited. This results in a SELECT on a "non-existent column" and crashes the entire page.
*   **Action**:
    1.  **Schema Trust**: Columns used in queries MUST be limited to those that "currently, certainly exist."
    2.  **Fallback**: Data for unimplemented features should be supplemented with constants (Default Config) in the application layer rather than fetched from the DB.
*   **Cross-Reference**: §8.10 (Schema-Code Synchronization Sovereignty)

### 9.8. The Scale First Credit Strategy
*   **Law**: Accurately understand the capacity of cloud service basic tiers (Free Tier / Included Credits) and **avoid premature optimization investment** while operating within the basic tier.
*   **Action**:
    1.  **Capacity Mapping**: At project start, inventory the basic tier allocations of all cloud services in use (bandwidth, storage, request counts, compute hours, etc.) and visualize current utilization and headroom.
    2.  **Premature Optimization Ban**: While basic tier utilization is **below 70%**, introducing architectural complexity (multi-CDN configurations, custom cache infrastructure, etc.) solely for cost optimization is prohibited. Focus on product growth first.
    3.  **Threshold Trigger**: When basic tier utilization **exceeds 70%**, formulate a cost optimization plan and execute before reaching 80%.
*   **Rationale**: Infrastructure optimization at a stage where "there is still ample headroom" is a waste of development resources and delays product growth. The correct investment decision is to begin optimization only when basic tier exhaustion becomes visible.

### 9.9. The Heavy Media Bandwidth Watch
*   **Law**: Large media files such as video, audio, and high-resolution images are the primary risk factor for bandwidth costs. Neglecting media bandwidth monitoring and control leads to unpredictable cost spikes.
*   **Action**:
    1.  **Bandwidth Monitoring**: Measure monthly bandwidth consumption of large media (video, audio, high-resolution images) individually and visualize on dashboards.
    2.  **Video Offload Strategy**: Directly serving video from your own servers or storage is prohibited in principle. Offload video to dedicated CDNs or streaming platforms (e.g., YouTube embeds, Vimeo, dedicated video CDNs) to transfer bandwidth costs.
    3.  **UGC Upload Limits**: Set file size limits (e.g., images 10MB, video 100MB) and resolution limits for video and image uploads in user-generated content (UGC).
    4.  **Transcoding Pipeline**: Uploaded videos should be automatically transcoded server-side into Adaptive Bitrate Streaming (ABR) compatible formats, delivering appropriate resolution based on the client device.
    5.  **Image Optimization Enforcement**: Images must be automatically converted to modern formats (WebP/AVIF, etc.) and resized at upload time. Serving images at original size is prohibited.
*   **Rationale**: Bandwidth costs for large media are hundreds to thousands of times greater than text data. Particularly on UGC platforms, bandwidth costs can grow exponentially as user upload volume increases.
*   **Cross-Reference**: §9.5 (Cache-First FinOps Strategy)

## 10. Observability Enhancement

### 10.1. The Quantitative Alert Threshold Protocol
*   **Law**: Alerts MUST be triggered automatically based on **quantitative thresholds**, not vague feelings like "something seems slow." Intuition-based monitoring is a breeding ground for oversights.
*   **The Alert Matrix**:
    | Metric | Warning | Critical | Response Action |
    |:-------|:--------|:---------|:---------------|
    | **Error Rate** (5xx / total requests) | > 1% (5 min) | > 5% (5 min) | Immediate investigation, consider rollback |
    | **P95 Response Time** | > 500ms | > 2000ms | Query optimization, cache review |
    | **DB Connection Pool Usage** | > 70% | > 90% | Connection optimization, scale up |
    | **Memory Usage** | > 80% | > 95% | Memory leak investigation |
    | **Cloud API Monthly Usage** | 70% of monthly limit | 90% of monthly limit | FinOps emergency review (see §9.3) |
    | **AI API Daily Cost** | 80% of budget | 100% of budget | Rate limit enforcement (see §9.6) |
    | **Email Delivery Success Rate** | < 97% | < 95% | Delivery log analysis, SPF/DKIM configuration review |
    | **Email Bounce Rate** | > 3% | > 5% | Bounce list review, consider sending suspension |
*   **Notification Rules**:
    *   **Critical**: Dual notification via instant messaging channel (Slack/Teams, etc.) + Email.
    *   **Warning**: Chat notification only.
    *   **Quiet Hours**: Suppress P2 and below alerts during nighttime (0:00-7:00) to prevent alert fatigue. P0/P1 are notified 24/7.
*   **Cross-Reference**: §5 (Escalation Channel Matrix), §9.3 (Cloud Budget Alert)

### 10.2. The Performance Benchmark Protocol
*   **Law**: Performance degrades if not measured. Continuous benchmark measurement and threshold management is mandatory.
*   **Target Metrics**:
    | Metric | Target | Measurement Tool (Example) |
    |:-------|:-------|:--------------------------|
    | **Lighthouse Performance** | ≧ 90 | Lighthouse CI |
    | **LCP (Largest Contentful Paint)** | ≦ 2.5s | CrUX / Web Vitals |
    | **INP (Interaction to Next Paint)** | ≦ 200ms | CrUX / Web Vitals |
    | **CLS (Cumulative Layout Shift)** | ≦ 0.1 | CrUX / Web Vitals |
    | **TTFB (Time to First Byte)** | ≦ 800ms | Server Logs / Analytics |
    | **JS Bundle Size** | ≦ 150KB (gzip) | Bundle Analyzer |
*   **Measurement Cycle**:
    *   **CI/CD**: Run Lighthouse CI or equivalent on PR creation. Display Warning if targets are not met.
    *   **Weekly**: Automatically measure Core Web Vitals of key pages and display on dashboard.
    *   **Monthly**: Analyze real user data (CrUX Report, etc.) and trigger alerts if degradation trends are observed.
*   **Degradation Response**: If targets are missed for **2 consecutive weeks**, file a performance improvement ticket as **top priority**.

### 10.3. The Automated Backup Verification Protocol
*   **Context**: As a complement to §7 (Fire Drill Protocol), this defines automatic backup quality verification (restore feasibility confirmation) criteria. Build a system that not only "runs drills" but "automatically verifies quality."
*   **Frequency**: Execute monthly via automation. Conduct restore tests in a staging or isolated environment.
*   **Verification Matrix**:
    | Verification Item | Criteria | Automation |
    |:-----------------|:---------|:-----------|
    | **Restore Completion** | Restore completes without errors | ✅ Restore script |
    | **Table Count Match** | Same number of tables as production exists | ✅ SQL comparison script |
    | **Row Count Consistency** | Major table row counts within ±5% of production | ✅ COUNT comparison |
    | **Security Policy Existence** | Security policies (RLS, etc.) applied to all tables | ✅ Policy check |
    | **Application Startup** | Application starts normally after restore | ⚠️ Health check API |
*   **Alert**: If any of the above verifications fail, trigger a **P1 alert immediately**.
*   **Cross-Reference**: §7 (Fire Drill Protocol, Off-Site Backup Mandate)

### 10.4. The Observability Dashboard Mandate
*   **Law**: The following metrics MUST be visualized at the corresponding frequency in the admin dashboard or monitoring tool.
*   **Real-time Metrics (Continuously Updated)**:
    *   Active user count (last 5 minutes)
    *   Requests per second (RPS)
    *   Error rate (5xx ratio)
    *   P95 Response Time
*   **Daily Metrics**:
    *   Core Web Vitals (LCP / INP / CLS)
    *   DB connection pool usage peak
    *   Cache hit rate (CDN / application level)
    *   AI API usage and cost (see §9.6)
*   **Weekly Metrics**:
    *   Unresolved error count and trends in error tracking tools (Sentry, etc.)
    *   SLO achievement rate
    *   Dependency package vulnerability scan results
*   **Rationale**: "You can't manage what you don't measure." Maintain system health based on facts, not assumptions.

### 10.5. The Load Test Protocol
*   **Context**: Identify bottlenecks through pre-release load testing to prepare for sudden traffic surges in production (media coverage, campaigns, etc.).
*   **Target**:
    | Target | Concurrent Connection Goal (Example) | Response Time Goal |
    |:-------|:------------------------------------|:-------------------|
    | **Main Public Pages** | 500 concurrent | ≦ 1.0s (p95) |
    | **Search API** | 200 concurrent | ≦ 2.0s (p95) |
    | **Detail Pages** | 300 concurrent | ≦ 1.5s (p95) |
    | **AI/Realtime API** | 50 concurrent | ≦ 5.0s (p95) |
*   **Execution Timing**:
    *   **Pre-Release (Mandatory)**: When DB schema changes, cache strategy changes, or new API endpoints are added.
    *   **Periodic (Recommended)**: Conduct benchmarks on key endpoints quarterly.
*   **Bottleneck Response**: If p95 response time **exceeds 1.5x the target**, block the release. Address through root cause analysis → cache addition / query optimization / index addition.
*   **Prohibition**: Load testing in production environments is **prohibited**. Conduct in staging environments (or equivalent configurations).
*   **Tooling**: Recommend using load testing tools such as k6, Apache Bench, Gatling, etc.
*   **Rationale**: A release without load testing is a "gamble on performance." Failures during traffic surges directly lead to revenue loss and erosion of user trust. Pre-release bottleneck identification and threshold management maintain predictable reliability.
*   **Cross-Reference**: §10.2 (Performance Benchmark Protocol)
