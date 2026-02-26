# 52. SRE & Reliability Engineering

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
