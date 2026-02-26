# 60. Security & Privacy (CISO & Legal View)

### 9.1. The Semantic Error Consistency Protocol (RFC 7807+)
*   **Law**: API Error responses MUST be returned in **RFC 7807 (Problem Details for HTTP APIs)** or compliant standardized JSON format.
*   **Mandate**:
    *   `type`: URI identifying error type.
    *   `title`: Abstract error description readable by humans.
    *   `status`: HTTP status code.
    *   `detail`: Specific problem description (excluding secrets).
    *   `instance`: URI of occurrence.
*   **Action**: Client (UI) must construct error info from backend with "Hospitality" to display this `title` or `detail` directly in dialogs.

### 9.2. The Function Search Path Lockdown
*   **Law**: Not fixing the `search_path` in PostgreSQL `SECURITY DEFINER` functions is a vulnerability equivalent to "leaving the house with the door unlocked."
*   **Threat Model**: An attacker can place identically-named tables/functions in `temp` or other schemas to hijack the execution context of privileged functions via "Search Path Injection" attacks.
*   **Action**:
    1.  **Empty Search Path**: `SECURITY DEFINER` functions MUST have `SET search_path = ''` (empty string). `SET search_path = public` is a compromise that retains alias attack risks.
    2.  **Fully Qualified References**: All table/function references within functions MUST use **schema-qualified names** such as `public.users`, `public.is_admin()`.
    3.  **System Schema Exclusion**: DDL operations on objects within system schemas (`storage`, `auth`, `graphql`, `extensions`, etc.) are prohibited in principle. These are Supabase-managed domains.
    4.  **CI Validation**: When adding new functions, introducing CI scripts to verify correct `search_path` configuration is recommended.
*   **Outcome**: Physically eliminate Search Path attacks and reduce Privilege Escalation risk to zero.

### 9.3. The Strict CSP Nonce Protocol
*   **Law**: Adding `'unsafe-inline'` or `'unsafe-eval'` in Content Security Policy (CSP) to bypass script blocks is an "Abandonment of Defense" and is prohibited.
*   **Action**:
    1.  **Nonce Propagation**: All inline scripts and external widgets (Turnstile, reCAPTCHA, GTM, etc.) MUST have a **Nonce** generated from Middleware propagated to prove legitimacy to the browser.
    2.  **Strict Dynamic**: Use `'strict-dynamic'` for sub-resources dynamically loaded by trusted scripts, minimizing reliance on explicit domain whitelists.
    3.  **Report-Only First**: When introducing new CSP rules, observe impact with `Content-Security-Policy-Report-Only` before applying to production.
    4.  **No Compromise**: Proposing "just add `unsafe-inline` and it works" to bypass security feature blocking is a developer's defeat. Solve with legitimate technical improvements.
*   **Outcome**: Structurally eliminate XSS attack risk and maintain maximum-strength CSP.

### 9.4. The Cryptographic Consistency Mandate
*   **Law**: When handling sensitive information like API keys and tokens, the **generation/storage phase and authentication/verification phase MUST use the same cryptographic algorithm**.
*   **Action**:
    1.  **Algorithm Unity**: If storing SHA-256 hashed values at generation, compare with the same SHA-256 hash at verification. Algorithm mismatch is a direct cause of "authentication permanently fails" bugs.
    2.  **Schema Match**: Guarantee at the type level that column names storing hashed values (`key_hash`, etc.) exactly match column names referenced in application code.
    3.  **Rotation Ready**: Recommend including an algorithm identifier prefix (`sha256:xxxx`) during storage to prepare for future algorithm changes.
*   **Anti-Pattern**: Storing plaintext at generation and comparing hashes at authentication (or vice versa) is a fatal bug producing "permanent mismatch."

### 9.5. The Client-Side Branch Guard Protocol
*   **Law**: Use Git `pre-push` hooks to make direct pushes to protected branches (`main`, `master`, etc.) **physically impossible**. Even when server-side branch protection (GitHub Branch Protection, etc.) is available, double the defense lines (Deep Defense).
*   **Action**:
    1.  **Mandatory Hook**: Introduce a Git Hooks management tool such as `husky` during project initialization and configure a `pre-push` hook.
    2.  **Push Block Logic**: Inspect the current branch name within the hook and force abort with `exit 1` if it matches a protected branch name.
    3.  **No Human Trust**: "Being careful" as an operational rule is meaningless. Trust only mechanisms that make pushing physically impossible (Code, not Policy).
*   **Rationale**: Unintended direct pushes to protected branches cause unauthorized deployments, history pollution, and breach of team trust. Especially in environments where server-side protection is limited (e.g., GitHub Free Plan), client-side guards are the only defense line.

### 9.6. The Unconditional Baseline Auth Mandate
*   **Law**: Action layer handlers that invoke privileged clients (Service Role, etc.) MUST execute **baseline authentication and authorization checks without exception across all code paths**, regardless of data status or importance.
*   **Action**:
    1.  **No Conditional Bypass**: Bypasses like "skip auth check because it's a draft" or "relax guards because it's an internal API" are prohibited. Switching authentication strength (whether MFA/OTP is required, etc.) is permissible, but making identity verification ("who is executing") conditional is not.
    2.  **Defense in Depth**: Privileged clients bypass DB-level access controls, so application layer check omissions directly lead to critical vulnerabilities. Enforce minimum authorization checks (`ensureAuth()` / `ensureRole()`, etc.) across all code paths.
    3.  **Branch Audit**: When adding or modifying action functions with status or condition-based branching (`if (status === 'draft') ... else ...`), review that authentication guards are consistently invoked across all branch paths.
*   **Rationale**: The assumption that "it's safe because it's private" is invalid in environments where attackers can directly manipulate API calls. Missing authentication checks in actions using privileged clients is a direct cause of Privilege Escalation.

### 9.8. The Strict CSP Nonce Protocol
*   **Law**: In Content Security Policy (CSP), the use of `unsafe-inline` or `unsafe-eval` is defined as "abandoning security defenses." All inline scripts must use a **cryptographically secure Nonce generated in Middleware**, maintaining CSP strictness.
*   **Action**:
    1.  **Nonce Generation**: Generate a unique Nonce per request in Middleware using `crypto.randomUUID()` or similar, and set it in the `Content-Security-Policy` header as `'nonce-{value}'`.
    2.  **Nonce Propagation**: Propagate the generated Nonce to Server Components via custom headers (e.g., `x-nonce`) and apply it to all inline scripts (`<script nonce={nonce}>`).
    3.  **No Fallback to Unsafe**: Do not compromise to `unsafe-inline` when integrating third-party scripts (widgets, analytics tools, etc.). Instead, load them as external files and enumerate domains in `script-src`, or use hash-based allow lists.
    4.  **CSP Report**: Configure `report-uri` / `report-to` directives to collect and monitor CSP violations server-side.
*   **Rationale**: `unsafe-inline` completely nullifies CSP's defense against XSS (Cross-Site Scripting) attacks. Nonce-based CSP permits only legitimate inline scripts and physically blocks execution of scripts injected by attackers.
