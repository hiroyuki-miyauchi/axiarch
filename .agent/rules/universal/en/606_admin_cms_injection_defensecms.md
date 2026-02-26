# 60. Security & Privacy (CISO & Legal View)

### 9.13. The Admin CMS Injection Defense
*   **Law**: CMS features that allow embedding arbitrary HTML/scripts into site-wide `<head>` or templates from the admin panel (custom head, custom CSS, widget embeds, etc.) are powerful XSS vectors. If an admin account is compromised, the entire site can be contaminated.
*   **Action**:
    1.  **Super Admin Only**: Restrict editing and saving of such features to users with **top-level privileges (System Admin / Super Admin)** only, not regular administrators.
    2.  **Script Tag Warning**: When input contains `<script>` tags, `javascript:` URIs, or `on*` event handlers, display an explicit warning dialog in the UI before saving.
    3.  **Change Audit**: All changes MUST be recorded in audit logs with before/after diffs retained.
*   **Rationale**: Arbitrary code injection from admin panels can bypass CSP through admin privileges, requiring dual defense through privilege-level restrictions and injection detection.

# 61. Legal, Privacy & Data Governance

## 1. Data Sovereignty
*   **Residency**: Store user data in the region where the user resides (e.g., EU users in EU region) and comply with cross-border transfer regulations (GDPR etc.).
    *   **Portability Protocol**: Users have the right to bulk download all their data (posts, images, logs) in machine-readable format (JSON/CSV). Maintain capability to fulfill data access requests within **72 hours**. Implementation must be via async jobs.
    *   **Right to Erasure**: Account deletion must involve **Hard Delete** of relevant PII, making it unrecoverable. Only data with legal retention obligations shall be isolated in Cold Storage.
*   **Consent Management**:
    *   **CMP**: Manage Cookie and tracking consent using trusted CMPs (Consent Management Platform) like OneTrust instead of custom implementation, to auto-follow legal changes in each country.
    *   **Strict Opt-In**: Blocking non-essential tracking without explicit consent is mandatory (No Nudging). Place "Reject All" button with **equal visibility** as "Accept All" in consent banners.


*   **Network Isolation**:
*   Place DBs and internal APIs in private VPCs.
*   **The Tokyo Mandate (Data Residency)**:
*   **Law**: To meet enterprise compliance, production data storage (Region) MUST be fixed to **Tokyo (ap-northeast-1)** by standard.
*   **Compliance**: Aggregate backup data (R2/S3) also to domestic regions unless legally exempt.
*   **The Database Fortress Protocol**:
*   **Search Path Defenses**: MUST append `SET search_path = ''` (empty) to `SECURITY DEFINER` functions to physically cut dependency on search path. In functions, mandate **fully schema-qualified** references like `public.table_name`.
*   **Reason (Trojan Horse)**: Without fixed `search_path`, Postgres creates vulnerability allowing attackers to swap tables. `SET search_path = public` is a compromise; empty is the only secure way.
*   **Explicit RLS**: Policy `USING (true)` means unconditional open. MANDATE `TO service_role` or strict conditions. Discard "Secure by Default" illusions.
*   **Multi-Layered Defense**:
*   **L1 (Edge/WAF)**: Use Cloud Armor / AWS WAF (Managed Rules) for GeoIP blocking and Bot detection to physically block malicious traffic and **EDoS (Resource Exhaustion)** attacks.
*   **WAF Policy**: Always operate SQL Injection, XSS, Generic Attacks rulesets in **"Block" mode**.
*   **App Check**: Block unauthorized API access using Firebase App Check.
*   **Law**: For Public actions (Inquiry, Auth), MUST implement rate limits (e.g., 5/hour) via `checkRateLimit` to build Defense in Depth.
*   **Fail Fast**: Return error immediately upon limit exceeded before DB connection or heavy processing to protect resources.
*   **Implementation**: Use Vercel KV or Upstash Redis for high-speed edge blocking. Not burdening the DB is critical.
*   **Middleware Matcher Safety**: Prohibit complex Regex in `middleware.ts` `config.matcher`. Opaque Regex breeds ReDoS and bypass risks. use readable Array format.

*   **The Iron Fortress Mandate**: We maintain a "Fortress", not just an app.
1.  **Zero Warning Enforcement**: PRs with even 1 Security Advisor / Performance Advisor warning are automatically **Rejected**.
2.  **No "True"**: `USING (true)` and `WITH CHECK (true)` in RLS policies are forbidden under any reason. MUST use `TO service_role` or strict conditions.
3.  **No "No Policy"**: `RLS Enabled` with no policies (INFO warning) is absolutely unacceptable.
4.  **Admin Lock**: Admin tables must be defended with `role = 'admin'`.
*   **Strategic Exception (Info Acceptance)**: Only "Info" level warnings like `unused_index` are Accepted if intentional design, but "Over-defense" (deleting necessary index to remove warning) is prohibited.
