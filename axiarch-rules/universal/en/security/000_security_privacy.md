# 60. Security & Privacy

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited without an explicit "Amend Constitution" instruction.**
> Revision date: 2026-03-28

> [!IMPORTANT]
> **Level 1 Priority: Absolute Compliance**
> Security and legal compliance are the **highest priority**.
> They take precedence over user convenience, development speed, and profitability.
> **30 Parts / 90+ Sections architecture.**

> [!CAUTION]
> **Supreme Directive**
> Privacy and security always take priority over feature requirements, deadlines, and costs.
> Code violating this document MUST NOT be deployed to production under any circumstances.
>
> **The Zero Tolerance Protocol**:
> When a risk is identified, regardless of its size or probability, respond **without exception, immediately, and thoroughly**.

---

## Table of Contents

- §1. Supreme Directive & Golden Rule
- §2. Zero Trust Architecture
- §3. Identity-First Security & ITDR
- §4. Authentication & Authorization Architecture
- §5. Passkey & Passwordless Strategy
- §6. Session Management & Account Protection
- §7. Privacy by Design
- §8. Data Classification & DSPM
- §9. Consent Management & Data Subject Rights
- §10. API Security
- §11. Supply Chain Security
- §12. Infrastructure Security
- §13. SASE & Network Security
- §14. Container & Cloud-Native Security
- §15. File Upload Security
- §16. Cryptographic Policy & PQC
- §17. AI/LLM Security
- §18. Agentic AI & MCP/A2A Security
- §19. Secure SDLC (Shift-Left Security)
- §20. GraphQL Security
- §21. Secrets Management
- §22. Client-Side Security
- §23. Bot Management & DDoS Defense
- §24. Security Quality Standards
- §25. Advanced Security Operations (SecOps)
- §26. Security Observability
- §27. Vendor Security Management
- §28. Regulatory Compliance Deep Dive
- §29. Security Governance
- §30. Maturity Model & Anti-Patterns
- Language-Specific Security
- Appendix A: Quick Reference Index

---

## §1. Supreme Directive & Golden Rule

### 1.1. Priority Hierarchy

-   **Legal & Security > User Experience > Revenue > DX**:
    -   **Iron Rule**: "Even if the user wants it, do not provide it if there is a legal risk."
    -   **Example**: Even if users want to "view history without logging in," reject it if there is a privacy risk. Even if users want to "pay offline," reject it if there is a security risk.

### 1.2. Assume Breach

-   Design with the assumption that a breach is not "if" but "when."
-   Always prioritize designs that minimize the Blast Radius upon breach.
-   **Harvest Now, Decrypt Later**: Mandate designs that account for the risk of currently encrypted data being decrypted by future quantum computers (see §16.4 PQC).

### 1.3. Defense in Depth

-   Do not rely on a single defense measure. Apply authentication, authorization, encryption, monitoring, and network isolation in layers.
-   Mandate designs where remaining layers function even if one is breached.
-   **Minimum Security Layer Configuration**:

| Layer | Required Measures |
|:------|:-----------------|
| **Network** | WAF + CDN + DDoS mitigation + VPC isolation |
| **Identity** | IDaaS + MFA/Passkey + RBAC/ABAC |
| **Application** | Input validation + CSP + CORS + CSRF defense |
| **Data** | Encryption (at-rest/in-transit) + RLS + masking |
| **Endpoint** | Device posture + SRI + Trusted Types |
| **Monitoring** | SIEM + audit logs + anomaly detection |

### 1.4. Security Champion Culture

-   Security is not solely the responsibility of a specialized team—it is a **fundamental responsibility of all engineers**.
-   "Security can wait" or "we'll handle it after release" is considered a **design defect**.

---

## §2. Zero Trust Architecture

> **Reference**: NIST SP 800-207, CISA Zero Trust Maturity Model v2.0, NIST CSF 2.0

### 2.1. Core Principles

-   **Rule 2.1.1: The Untrusted Default**: Enforce **Authentication**, **Authorization**, and **Encryption** on **all access subjects**, including internal networks, admin accounts, and AI agents, under the premise of "trust nothing."
-   **Rule 2.1.2: Least Privilege**: Grant only the **minimum permissions** necessary for the purpose. Recommend JIT (Just-In-Time) access.
-   **Rule 2.1.3: Microsegmentation**: Segment networks finely to physically prevent lateral movement upon breach.
-   **Rule 2.1.4: Continuous Verification**: **Force re-authentication** when risk score changes (anomalous IP, geographic shift, device change) are detected, even during active sessions.
-   **Rule 2.1.5: Deny by Default**: Deny all access not explicitly permitted.

### 2.2. CISA Zero Trust Maturity Model v2.0 Compliance

-   **Law**: Use the CISA ZTMM v2.0 five pillars + three cross-cutting capabilities as the reference framework.

| Pillar | Required Measures |
|:-------|:-----------------|
| **1. Identity** | IDaaS required. MFA/Passkey enforced. Phishing-resistant MFA recommended. NHI management (§3) |
| **2. Device** | Prioritize access from managed devices. Device posture verification. EDR/XDR integration recommended |
| **3. Network** | VPC, private subnets required. Public DB prohibited. SASE integration recommended (§13) |
| **4. Application** | Input validation and authorization checks at all endpoints. WAF required. API Gateway (§10) |
| **5. Data** | Encryption at rest and in transit required. Protection based on data classification (§8). DSPM recommended |

| Cross-Cutting Capability | Requirements |
|:------------------------|:------------|
| **Visibility & Analytics** | Integrated log collection and real-time monitoring across all layers. SIEM integration required |
| **Automation & Orchestration** | SOAR integration. Automated security incident response workflows |
| **Governance** | NIST CSF 2.0 Govern function compliance. Risk appetite definition. RACI clarification |

-   **Maturity Stages**: Evaluate the organization's current position across Traditional → Initial → Advanced → Optimal and incrementally improve maturity.

### 2.3. NIST CSF 2.0 Govern Function Integration

-   **Law**: Comply with the newly established "Govern" function in NIST CSF 2.0 and integrate security risk management into enterprise risk management (ERM).
-   **Action**:
    1.  **Risk Appetite Definition**: Document acceptable risk levels and reflect in §29 governance framework.
    2.  **Roles and Responsibilities**: Clearly define security decision-makers, executors, and responsible parties.
    3.  **Supply Chain Risk**: Apply Zero Trust principles to vendors and sub-processors (§27).
    4.  **Shadow AI Management**: Develop policies to detect and govern unauthorized AI tool usage.
-   **Cross-Reference**: §29 (Security Governance)

### 2.4. Identity-First Zero Trust

-   **Law**: The starting point of Zero Trust is **identity**. Design with identity as the new perimeter, not network boundaries.
-   **Action**:
    1.  Start all access requests with identity verification. Zero trust based on network location.
    2.  Manage human IDs, NHIs, and AI agent IDs uniformly (§3).
    3.  Recommend risk-based dynamic authorization (context-aware access).
-   **Cross-Reference**: §3 (Identity-First Security & ITDR)

---

## §3. Identity-First Security & ITDR

> **Reference**: CISA ZTMM Identity Pillar, NIST SP 800-63-4, ISO/IEC 24760

### 3.1. Unified Identity Management Framework

-   **Law**: Manage human IDs, non-human IDs (NHI), and AI agent IDs within a **unified identity fabric**.
-   **Action**:
    1.  **ID Inventory**: Inventory all IDs (user accounts, service accounts, API keys, CI/CD pipelines, AI agents) with clear ownership.
    2.  **ID Lifecycle Management**: Automate provisioning → usage → modification → deactivation → deletion.
    3.  **IAM Platform Integration**: Use IDaaS (Firebase Auth, Auth0, Cognito, etc.) as the sole identity provider. Building custom auth infrastructure is prohibited.
    4.  **Orphaned ID Detection**: Periodically detect departed/unused IDs and automatically deactivate.

### 3.2. Non-Human Identity Management (NHI)

-   **Law**: NHIs outnumber human IDs by **45x+** (industry survey) and are a primary breach vector. Manage NHIs with the same rigor as human IDs.
-   **NHI Classification**:

| NHI Type | Examples | Risk Level |
|:---------|:---------|:-----------|
| **Service Accounts** | GCP Service Account, AWS IAM Role | High |
| **API Keys** | External SaaS integration keys | High |
| **CI/CD Credentials** | GitHub Actions secrets, deploy keys | Critical |
| **AI Agents** | MCP Client, A2A Agent | Critical |
| **Bot/Automation** | Cron jobs, Webhook handlers | Medium |
| **Certificates/Tokens** | mTLS certificates, OAuth client credentials | High |

-   **Action**:
    1.  **Owner Assignment**: Assign a human owner to every NHI. NHIs without owners are immediate deactivation candidates.
    2.  **Least Privilege**: Limit scopes granted to NHIs to the minimum necessary. Periodically audit NHIs with broad permissions (`admin`, `*`).
    3.  **Short-Lived Credentials**: Prefer **dynamic, short-lived secrets** over static keys (§21.3).
    4.  **Rotation Enforcement**: Apply **shorter rotation cycles** for NHI secrets than for human ones (§21.5).
    5.  **Usage Pattern Monitoring**: Baseline normal NHI usage patterns and detect anomalies immediately.
-   **Anti-Pattern**: Sharing service accounts and reusing the same credentials across multiple services.
-   **Cross-Reference**: §21 (Secrets Management), §18 (Agentic AI)

### 3.3. Identity Threat Detection & Response (ITDR)

-   **Law**: Detect and auto-respond to identity-related attacks (Credential Stuffing, Account Takeover, Privilege Escalation, Lateral Movement) in real-time.
-   **Detection Patterns**:

| Threat Pattern | Detection Method | Auto-Response |
|:-------------|:----------------|:-------------|
| **Credential Stuffing** | Multiple account auth failures from same IP | Temp IP block + CAPTCHA enforcement |
| **Account Takeover (ATO)** | Anomalous geographic login, device change | Session invalidation + re-auth required |
| **Privilege Escalation** | Unusual role change patterns | Change blocked + admin alert |
| **Lateral Movement** | Sequential access to multiple services | Session isolation + investigation start |
| **Golden/Silver Ticket** | Kerberos anomalies | All sessions invalidated |
| **MFA Fatigue Attack** | Many MFA push requests in short time | MFA push paused + notification |

-   **Action**:
    1.  **Behavioral Baseline**: Build normal behavior profiles per user/NHI. Reflect deviations in risk score.
    2.  **Real-Time Risk Scoring**: Calculate risk score per login attempt. Escalate defenses on threshold breach (CAPTCHA → MFA → Block).
    3.  **SIEM/XDR Integration**: Send ITDR detection events to SIEM/XDR for correlation analysis.
    4.  **Auto-Remediation**: Build automated response workflows (SOAR integration) for high-risk events.
-   **Cross-Reference**: §6 (Session Management), §26 (Security Observability)

### 3.4. Privileged Access Management (PAM)

-   **Law**: Privileged accounts (admins, DBAs, infra managers) are the **highest-value attack targets**. Manage privileged access rigorously.
-   **Action**:
    1.  **JIT (Just-In-Time) Access**: Grant privileges temporarily when needed, automatically revoke after task completion.
    2.  **JEA (Just Enough Administration)**: Limit privilege scope to the minimum necessary. Prohibit permanent full-admin access.
    3.  **Privileged Session Recording**: Record all operations in privileged sessions for post-audit.
    4.  **Break Glass Procedure**: Pre-define emergency privileged access procedures. Audit and report immediately after use.
    5.  **Standing Privilege Zero Goal**: Set a long-term goal to approach zero standing privileged accounts.

### 3.5. ID Federation & SSO

-   **Law**: Unify identity management across multiple services to prevent password proliferation.
-   **Action**:
    1.  **SSO Required**: Use SSO (SAML 2.0 / OIDC) for unified authentication of internal tools and admin consoles. Individual authentication is deprecated.
    2.  **SCIM**: Automate user provisioning/deprovisioning.
    3.  **Conditional Access**: Dynamic access control based on device posture, network location, and risk score.

---

## §4. Authentication & Authorization Architecture

### 4.1. Credential Hygiene

-   **Physically prohibit** writing API keys, secrets, and DB connection strings in source code. Always use `process.env`.
-   Use encrypted channels like 1Password for sharing sensitive information. **Slack pasting prohibited**.
-   **CI Gate**: Integrate `git-secrets` / `gitleaks` into pre-commit hooks to physically prevent secret commits.

```typescript
// ❌ PROHIBITED: Hardcoded secrets
const supabase = createClient(
  'https://xxx.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'
);

// ✅ CORRECT: Via environment variables
const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
);
```

### 4.2. MFA (Multi-Factor Authentication)

-   **MFA enforced** on admin accounts. No exceptions.
-   **Passkey/FIDO2/WebAuthn recommended**: Adopt phishing-resistant auth methods as the **top priority** (detailed in §5).
-   **SMS OTP deprecated**: Due to SIM swap attacks and SS7 protocol vulnerabilities, SMS OTP is **insufficient as the sole second factor for high-risk operations**. Prefer TOTP/Passkey/hardware keys.
-   **MFA Fatigue countermeasures**: Detect and auto-block rapid bulk push notifications + user notification. Number Matching recommended.

### 4.3. IDaaS Required

-   Building custom auth infrastructure is prohibited. Use verified solutions such as Firebase Auth, Auth0, Cognito.
-   **Rationale**: Auth is an extremely high-risk foundation where "one mistake puts all users at risk." Custom implementations invite inadequate password hashing, timing attacks, session management flaws, etc.

### 4.4. Social Login Security Protocol

-   **Authorization Code Flow + PKCE required**: Implicit Flow prohibited.
-   **CSRF Prevention**: `state` parameter required.
-   **Server-Side Token Exchange**: `client_secret` used server-side only.
-   **Scope Minimization**: Limit to `openid`, `email`, `profile`, etc.
-   **Explicit Account Link**: Prohibit automatic linking to existing accounts with the same email. Display confirmation UI.
-   **Session Verification**: Verify all `iss`, `aud`, `exp` fields.

### 4.5. RBAC / ABAC Design

-   **Admin Privilege Verification (SSOT)**: The `role` column in `public.profiles` table is the sole source of truth. Dependence on frontend flags or legacy tables is a **security hole**.
-   **The Guardian Protocol (Centralized Auth)**: Prohibit scattered auth check logic. Use centralized guard functions (e.g., `admin-guard.ts`).

```typescript
// ❌ ANTI-PATTERN: Individual role checks in each file
const { data } = await supabase.from('profiles').select('role').eq('id', userId);
if (data?.role !== 'admin') throw new Error('Unauthorized');

// ✅ CORRECT: Centralized guard function
import { requireAdmin } from '@/lib/auth/admin-guard';
const user = await requireAdmin(); // Internally performs auth + authz + audit log
```

-   **Role Enumeration Symmetry**: Multiple guard functions validating the same domain must retrieve role lists from a **common constant array**.
-   **Unconditional Baseline Auth**: Handlers in action layers using privileged clients must **execute auth/authz checks on all code paths** regardless of data status.
-   **ABAC recommended**: When simple RBAC is insufficient (multi-tenant, fine-grained access control), adopt Attribute-Based Access Control (ABAC).

### 4.6. RBAC Defense Protocol

-   All Admin API/Actions must enforce RBAC check at the beginning.
-   Financial, permission, and delete operations require Turnstile/OTP additional auth beyond RBAC.
-   Record all Admin operations in audit logs. Include before/after diffs for destructive operations.

### 4.7. Omnichannel Auth

-   Support both web cookies and **Bearer Token (JWT)**. Skipping verification in Server Actions is prohibited.

### 4.8. API Key Security

-   **Hashing Mandate**: API Keys must **never be stored in plaintext**. Hash with SHA-256 or equivalent.
-   **Dual Auth Protocol**: Implement as OR condition of `X-API-KEY` and `Authorization: Bearer`.
-   **Prefix Design**: Add prefixes (e.g., `sk_live_`, `pk_test_`) to API Keys for type/environment identification.

### 4.9. Password Policy

-   **Law**: Password policies must comply with NIST SP 800-63B / 800-63-4.
-   **Requirements**:
    -   **Minimum length**: 8+ characters (admins: 12+).
    -   **No complexity rules enforced**: Per NIST SP 800-63B, **do not recommend** mandatory uppercase/symbol requirements.
    -   **Breached password check**: Check against **Have I Been Pwned API** on new set/change.
    -   **No forced periodic changes**: Per NIST recommendation, **do not force** regular password changes (except on confirmed breach).
    -   **Password strength meter**: Provide real-time strength feedback (e.g., zxcvbn library).
    -   **Password hashing**: Use **Argon2id** (recommended) or **bcrypt** (cost ≥ 12). SHA-256/MD5 storage is absolutely prohibited.
-   **Cross-Reference**: §16.2 (Recommended Algorithms), §4.2 (MFA)

---

## §5. Passkey & Passwordless Strategy

> **Reference**: FIDO Alliance, W3C WebAuthn Level 3, NIST SP 800-63B Supplement

### 5.1. Strategic Direction

-   **Law**: Position Passkey (FIDO2/WebAuthn) as the strategic direction for passwordless authentication and develop a phased migration plan.
-   **Background**: As of 2025, 15+ billion online accounts support Passkeys. 87% of enterprises are advancing Passkey adoption (FIDO Alliance survey).

### 5.2. Passkey Classification

| Type | Characteristics | Use Case |
|:-----|:---------------|:---------|
| **Synced Passkey** | Cloud-synced (iCloud Keychain/Google, etc.). Cross-device capable | General users. Convenience-focused |
| **Device-Bound Passkey** | Fixed to specific device/hardware key. No sync | Admins, high-risk operations. Security-focused |

### 5.3. Phased Rollout Roadmap

| Phase | Action | Target |
|:------|:-------|:-------|
| **Phase 1** | Offer Passkey registration as optional | Awareness building |
| **Phase 2** | Password + Passkey coexistence. Passkey-recommended UI | 30%+ adoption |
| **Phase 3** | Passkey-first. Password as fallback | 70%+ adoption |
| **Phase 4** | Full passwordless migration (Passkey-only) | Long-term goal |

### 5.4. Account Recovery

-   **Law**: Provide multiple recovery methods for Passkey loss.
-   **Action**:
    1.  **Backup Passkeys**: Recommend users register multiple Passkeys (device + cloud sync).
    2.  **Recovery Codes**: Provide one-time recovery codes (offline storage recommended).
    3.  **Staged Recovery**: Multi-step process of email/SMS + identity verification + waiting period.
    4.  **Maintain Phishing Resistance**: Design password reset fallbacks that do not compromise phishing resistance.

### 5.5. Admin Account Passkey Requirements

-   **Device-Bound Passkey required**: Hardware keys like YubiKey are **mandatory** for admin accounts.
-   Admin authentication with Synced Passkey only is **not permitted**.

### 5.6. UX Design Principles

-   **Plain language**: Use user-friendly expressions like "Sign in with Face ID/fingerprint." Avoid technical terms (WebAuthn, FIDO2) in UI.
-   **Cross-Platform**: Guarantee Passkey compatibility across all major platforms (iOS/Android/Windows/macOS/Linux + major browsers).
-   **Conditional UI**: Recommend Passkey autofill via WebAuthn Conditional Mediation (`mediation: 'conditional'`).
-   **Cross-Reference**: §4.2 (MFA), §29 (Security Governance)

---

## §6. Session Management & Account Protection

### 6.1. Token Expiration Design

| Token Type | Recommended TTL | Admin Console |
|:-----------|:---------------|:-------------|
| **Access Token** | ≤ 1 hour | ≤ 15 min |
| **Refresh Token** | 7–30 days | ≤ 7 days |
| **Session Cookie** | Browser session | Browser session |
| **Signed URL** | ≤ 5 min | ≤ 5 min |

### 6.2. Step-Up Authentication

-   Require **re-authentication (Step-Up Auth)** for high-risk operations (password change, payment, email change), even with a valid session.
-   **Tiered Security Protocol**:

| Tier | Operation Examples | Required Auth |
|:-----|:------------------|:-------------|
| **Tier 1: View** | Data reference | Standard auth |
| **Tier 2: Modify** | Profile update | Standard auth + RBAC |
| **Tier 3: Financial/Permission** | Payment, role change | RBAC + Turnstile + OTP |
| **Tier 4: Destructive** | Account deletion, full data purge | RBAC + OTP + admin approval |

### 6.3. Concurrent Session Policy

-   Set upper limits on simultaneous login devices. Invalidate oldest session on excess.
-   Apply stricter limits for admin accounts (1–2 concurrent sessions).
-   Recommend providing "Sign out of all devices" functionality.

### 6.4. Suspicious Session Detection

-   Detect and notify users of simultaneous access from different IPs/geographically distant regions to the same account.
-   **Impossible Travel Detection**: Auto-detect physically impossible travel speed (e.g., New York → London in 5 minutes).
-   **Cross-Reference**: §3.3 (ITDR)

### 6.5. Server-Side Invalidation

-   Immediately invalidate server-side on logout. Client-side token deletion alone is insufficient.
-   Immediately invalidate all sessions on account suspension/deletion.
-   **Token Revocation List**: Maintain a list of invalidated tokens and check during validation.

### 6.6. Account Lockout & Brute Force Prevention

-   **Law**: Apply progressive lockout against repeated authentication failures to structurally prevent brute force attacks.

| Failure Count | Action |
|:-------------|:-------|
| 3 | Require CAPTCHA (Turnstile) |
| 5 | **15-minute lock** + email notification |
| 10 | **1-hour lock** + admin alert |
| 20 | **Account frozen** + manual admin unlock required |

-   **IP-Based Limiting**: Detect/block repeated failures from the same IP to different accounts (Credential Stuffing).
-   **Constant-Time Comparison**: Keep response time constant on auth failure to prevent **timing attacks**.
-   **Error Messages**: Return unified messages like "Email or password is incorrect" that don't reveal which is wrong.

### 6.7. The Secret Rotation Lifecycle

-   Rotate IAM credentials and JWT signing keys every **90 days**.
-   **Panic Button (Kill Switch)**: Maintain up-to-date procedures for bulk session invalidation upon leakage.

### 6.8. The Physical Master Key (Bus Factor Defense)

-   Record critically important recovery information on **physical media (paper)** and store in a fire-resistant safe.
-   **Scope**: `service_role` key, Cloudflare Recovery Code, domain lock code, 1Password master key.

### 6.9. Digital Legacy Protocol

-   **Law**: Document data handling policy for long-term user inactivity in the Terms of Service.
-   "1 year no login" → notification → "3 years no login" → account deactivation + PII anonymization (per §9.3).

---

## §7. Privacy by Design

> **Reference**: ISO 31700, GDPR Art.25, Global Privacy Laws, CCPA/CPRA

### 7.1. Seven Principles

-   **Law**: Embed Ann Cavoukian's 7 Privacy by Design principles from the design phase.

| # | Principle | Implementation Obligation |
|:--|:---------|:------------------------|
| 1 | Proactive not Reactive | Identify privacy risks proactively in design reviews |
| 2 | Privacy as Default | Opt-in data collection. Minimize collection scope by default |
| 3 | Embedded into Design | Conduct PIA (Privacy Impact Assessment) during design phase |
| 4 | Positive-Sum | Design for the coexistence of privacy and functionality |
| 5 | End-to-End Lifecycle | Protect across all stages: collection → storage → use → disposal |
| 6 | Transparency | Clearly state usage purposes, retention periods, third-party sharing in privacy policies |
| 7 | User-Centric | Provide UI for users to manage and delete their own data |

### 7.2. Data Minimization

-   **Law**: Structurally prohibit collection of unnecessary or excessive data.
-   **Action**:
    1.  Define "collection purpose," "legal basis," "retention period" for each data item (Data Catalog obligation).
    2.  `SELECT *` prohibited. Explicitly retrieve only needed columns.
    3.  Use DTO patterns to avoid exposing internal structures externally.
    4.  Auto-delete data after retention period expiration (TTL design).

### 7.3. PII Sensitivity Classification

| Sensitivity | Data Examples | Protection Requirements |
|:-----------|:-------------|:-----------------------|
| **Critical** | Password hashes, credit card numbers | Strong encryption + access logs + 2+ person approval |
| **High** | Name, email, phone, date of birth | Encryption + RLS + view logs |
| **Medium** | Address, nickname | RLS + least privilege access |
| **Low** | Settings, UI preferences | Standard access controls |

### 7.4. PII Masking

-   **Law**: **Never include** PII in log output, error reports, or support screens.
-   **Action**:
    1.  Embed PII filters in logging frameworks to auto-mask `email`, `phone`, `name`, etc.
    2.  Prohibit raw object log output like `console.log(user)`.
    3.  Configure PII filters in error tracking tools (Sentry, etc.).

```typescript
// ❌ PROHIBITED: Log output containing PII
console.log('User login:', { email: user.email, name: user.name });

// ✅ CORRECT: PII masked
console.log('User login:', { userId: user.id, role: user.role });
```

### 7.5. Encryption Requirements

| State | Minimum Requirement |
|:------|:-------------------|
| **At Rest** | AES-256 (DB/Storage/Backup all) |
| **In Transit** | TLS 1.2+ (TLS 1.3 recommended) |
| **In Use** | Memory encryption recommended (Confidential Computing) |

-   **Cross-Reference**: §16 (Cryptographic Policy & PQC)

### 7.6. Data Residency

-   **Law**: Be aware of data storage locations (Country/Region) and comply with jurisdictional requirements.
-   **Action**:
    1.  Identify applicable data protection laws (GDPR, CCPA, Global Privacy Laws, etc.) for service regions.
    2.  Place DB regions in the same or legally permissible regions as service delivery.
    3.  Apply legal frameworks (SCC/IDTA, etc.) for cross-border data transfers.

---

## §8. Data Classification & DSPM

### 8.1. Data Classification Framework

-   **Law**: Systematically classify all data assets and auto-apply protection levels based on classification.

| Classification | Description | Protection Requirements | Examples |
|:-------------|:-----------|:-----------------------|:---------|
| **Restricted** | Legal sanctions/major damage on leak | Encryption+RLS+audit logs+DLP | PII, PHI, payment data |
| **Confidential** | Business confidential | Encryption+RLS+access logs | Internal docs, customer lists |
| **Internal** | Internal-facing information | RBAC+access control | Internal wiki, design docs |
| **Public** | Public information | Tamper prevention only | Public pages, press releases |

### 8.2. DSPM (Data Security Posture Management)

-   **Law**: Continuously discover, assess, and improve data security posture across cloud environments.
-   **Action**:
    1.  **Shadow Data Discovery**: Auto-discover unmanaged data in managed services, logs, and backups.
    2.  **Data Flow Tracking**: Visualize where sensitive data flows and who accesses it.
    3.  **Excessive Access Detection**: Detect gaps between actual access patterns and granted permissions; recommend permission reduction.
    4.  **Compliance Posture Assessment**: Score current compliance status against GDPR/CCPA/Global Privacy Laws requirements.
-   **Cross-Reference**: §7.3 (PII Sensitivity Classification), §29 (Security Governance)

### 8.3. Data Lineage & Catalog

-   **Law**: Make it traceable "where data comes from, where it flows, and who touches it" for sensitive data.
-   **Action**:
    1.  Manage table/column-level metadata (classification level, owner, retention period) with data catalog tools.
    2.  Auto-propagate classification labels during ETL/ELT pipeline data movement.
    3.  **Data Loss Prevention (DLP)**: Detect and block unauthorized copying, downloading, or external transmission of Restricted-classified data.

---

## §9. Consent Management & Data Subject Rights

### 9.1. Legal Compliance Matrix

| Law | Region | Consent Requirements | Deletion Right | Notification Period |
|:----|:-------|:--------------------|:-------------|:-------------------|
| **GDPR** | EU/EEA | Explicit opt-in | Yes (Right to be Forgotten) | Within 72 hours |
| **Global Privacy Laws** | Japan | Purpose publication/notification | Yes (Disclosure/Correction/Cessation) | Promptly |
| **CCPA/CPRA** | California | Opt-out right | Yes (Deletion right) | Within 45 days |
| **LGPD** | Brazil | Explicit consent | Yes | Reasonable period |
| **PIPA** | South Korea | Explicit consent | Yes | Without delay |

### 9.2. Consent Management Platform (CMP)

-   **Law**: Obtain user consent before initiating cookies/tracking technologies. "Default consent" is prohibited.
-   **Action**:
    1.  Implement CMP (e.g., OneTrust, Cookiebot, Osano) to automate consent acquisition, recording, and changes.
    2.  Clearly categorize consent (essential/functional/analytics/marketing).
    3.  Ensure basic service functionality is available even when consent is refused (no consent coercion).
    4.  Retain consent records as legal evidence for **at least 5 years**.

### 9.3. Right to be Forgotten

-   **Law**: Build mechanisms to structurally and completely respond to user deletion requests.
-   **Action**:
    1.  **Physical Deletion**: PII-containing records must be **physically deleted**, not logically deleted.
    2.  **Cascade Consideration**: Remove PII from related tables, storage, backups, and CDN caches.
    3.  **PII in Backups**: When individual record deletion from backups is technically infeasible, use Cryptographic Erasure (destroy encryption keys).
    4.  **Response Deadline**: GDPR=30 days, CCPA=45 days. Implement timer-based auto-reminders.
    5.  **Deletion Proof**: Record deletion completion (target data scope, deletion timestamp, executor) in audit logs.
-   **Cross-Reference**: `601_data_governance.md`

### 9.4. Data Portability

-   **Law**: Provide functionality for users to export their data in structured, machine-readable format (JSON/CSV).
-   **Action**: Apply rate limiting and authentication (Step-Up Auth) to export functionality. Async processing for bulk exports.

---

## §10. API Security

> **Reference**: OWASP API Security Top 10 2023, OWASP Top 10 2025

### 10.1. BOLA / BFLA Defense (OWASP API #1 / #5)

-   **BOLA (Broken Object Level Authorization) — API #1**:
    -   **Law**: Mandate object-level authorization checks at all API endpoints.
    -   **Action**: Verify that the requester has access rights to the resource at all endpoints receiving external IDs like `GET /api/users/{id}`.
    -   **Supabase**: Enforce `auth.uid() = user_id` constraints via RLS policies (§24.3).

-   **BFLA (Broken Function Level Authorization) — API #5**:
    -   **Law**: Clearly separate admin and general user API endpoints with role-based access control.
    -   **Anti-Pattern**: Distinguishing admin/general only by URL path (`/admin/users` vs `/users`) without backend authorization checks.

### 10.2. Mass Assignment Defense (API #3)

-   **Law**: Prohibit directly binding client input to models.
-   **Action**: Explicitly define accepted fields via whitelist using DTO patterns.
-   **Anti-Pattern**: Bulk assignment like `Object.assign(model, req.body)`.

### 10.3. Input Validation

-   **Validation at the Edge**: Treat all input as "untrusted data" and validate server-side. Client-side validation alone is insufficient.
-   **Zod / Valibot / ArkType required**: Mandate schema-based validation. Accepting input with `any` type is prohibited.

```typescript
// ✅ CORRECT: Strict input validation with Zod
import { z } from 'zod';

const UpdateProfileSchema = z.object({
  nickname: z.string().min(1).max(50).trim(),
  bio: z.string().max(500).optional(),
  // role: z.enum(['admin', 'user']),  ← ❌ Cannot change role via user input
});

export async function updateProfile(input: unknown) {
  const validated = UpdateProfileSchema.parse(input);
  // Use only validated data for DB update
}
```

### 10.4. SQL Injection Defense

-   **Parameterized Query Only**: String concatenation for SQL construction is **absolutely prohibited**. Use ORM or parameterized queries only.
-   **Safe ORM Usage**: Even with ORMs like Prisma or Drizzle, enforce parameterization when using raw SQL features like `$queryRaw`.

### 10.5. SSRF Defense

-   **Law**: When fetching external resources server-side, structurally prohibit access to internal networks (`127.0.0.1`, `10.x`, `172.16.x`, `169.254.169.254`).
-   **Action**: URL whitelist + DNS rebinding countermeasures + firewall blocking metadata service access.

### 10.6. Rate Limiting / Throttling

-   **Law**: Apply rate limiting to all API endpoints.
-   **Recommended Limits**:

| Endpoint Type | Limit (Example) |
|:-------------|:---------------|
| Auth (login/registration) | 5/min/IP |
| General API | 60/min/user |
| Search/heavy processing | 10/min/user |
| Admin API | 30/min/user |
| Webhook reception | 100/min/source |

-   **Rate Limit Headers**: Include `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset`, `Retry-After` in responses.
-   **Cross-Reference**: §23 (Bot Management)

### 10.7. CORS Design

-   `Access-Control-Allow-Origin: *` is **absolutely prohibited in production**.
-   **Explicit Domain Specification**: Whitelist approach allowing only trusted origins.
-   Leverage the restriction that `*` cannot be used with `Access-Control-Allow-Credentials: true`.

### 10.8. CSRF Defense

-   **SameSite Cookie**: Set `SameSite=Lax` (recommended) or `SameSite=Strict` on all cookies.
-   **Double Submit Cookie**: Enable framework CSRF token mechanisms.
-   **Custom Header Check**: Add custom headers like `X-Requested-With` to AJAX requests.

### 10.9. Error Handling

-   **Absolutely prohibit** returning error responses containing stack traces, internal paths, or DB structures in production.
-   Return generic messages to users (`500: Internal Server Error`); record details in server-side logs only.

### 10.10. API Shadow/Zombie Detection

-   **Law**: Periodically detect and retire undocumented APIs (Shadow API) and deprecated-but-still-running APIs (Zombie API).
-   **Action**: Detect unregistered endpoints via API gateway traffic analysis. Cross-reference with API inventory.

### 10.11. API Gateway

-   **Law**: Route all API traffic through API Gateway for centralized authentication, authorization, rate limiting, and logging.
-   **Cross-Reference**: §13 (SASE), §26 (Security Observability)

---

## §11. Supply Chain Security

> **Reference**: NIST SSDF (SP 800-218), SLSA v1.0, OWASP Top 10 2025 A03

### 11.1. SBOM (Software Bill of Materials)

-   **Law**: Auto-generate and manage SBOMs (CycloneDX/SPDX) for all projects.
-   **Action**: Integrate SBOM generation step into CI/CD pipelines, generating signed SBOMs per build.
-   **Compliance**: Proactively address EU CRA 2027 mandate.

### 11.2. Dependency Scanning

-   **Law**: Continuously scan vulnerabilities in all dependencies (direct and transitive).
-   **Action**:
    1.  Force `npm audit` / `yarn audit` in CI/CD. Critical/High are **merge blockers**.
    2.  Auto-update PRs via Dependabot / Renovate / Snyk.
    3.  **Lockfile Integrity Verification**: Detect tampering in `package-lock.json` / `yarn.lock`.
    4.  **Phantom Dependency Detection**: Detect implicit dependencies on undeclared packages.

### 11.3. SLSA (Supply-chain Levels for Software Artifacts)

-   **Target**: Minimum SLSA Level 2. Level 3 recommended.

| SLSA Level | Requirements | Implementation |
|:----------|:------------|:--------------|
| **Level 1** | Build process documentation | Build script version control |
| **Level 2** | Build reproducibility + Provenance generation | Automated CI/CD builds + signed Provenance |
| **Level 3** | Hardened build environment | Ephemeral runners + build isolation |

### 11.4. License Compliance

-   **Prohibited Licenses**: AGPL, SSPL, proprietary restrictive licenses.
-   **Caution Licenses**: GPL (copyleft concerns), CC-BY-NC (no commercial use).
-   **Permitted Licenses**: MIT, Apache 2.0, BSD, ISC, MPL 2.0.
-   **Action**: Introduce license checker in CI to block prohibited license dependency additions.
-   **Cross-Reference**: `602_oss_compliance.md`

### 11.5. Typosquatting & Dependency Confusion

-   **Law**: Defend against typosquatting (fake package) attacks on dependencies.
-   **Action**:
    1.  Manually review package name accuracy.
    2.  Configure private registry scoping to prevent Dependency Confusion.
    3.  Use only trusted registries via `npm config set registry`.

---

## §12. Infrastructure Security

### 12.1. Security Headers

-   **Law**: Attach security headers to all HTTP responses.

| Header | Required Value | Purpose |
|:-------|:-------------|:--------|
| `Content-Security-Policy` | Nonce method (§12.2) | XSS defense |
| `Strict-Transport-Security` | `max-age=63072000; includeSubDomains; preload` | HTTPS enforcement |
| `X-Content-Type-Options` | `nosniff` | MIME sniffing prevention |
| `X-Frame-Options` | `DENY` or `SAMEORIGIN` | Clickjacking prevention |
| `Referrer-Policy` | `strict-origin-when-cross-origin` | Referrer info leakage prevention |
| `Permissions-Policy` | Explicitly disable unused API features | Restrict unnecessary browser APIs |
| `Cross-Origin-Embedder-Policy` | `require-corp` | Cross-origin isolation |
| `Cross-Origin-Opener-Policy` | `same-origin` | Window reference isolation |
| `Cross-Origin-Resource-Policy` | `same-origin` | Resource isolation |

### 12.2. CSP Nonce Protocol

-   **Law**: Use **Nonce method** for CSP to ensure safe inline script execution. `'unsafe-inline'`, `'unsafe-eval'` usage is **completely prohibited**.

```typescript
// ✅ CORRECT: Next.js CSP Nonce implementation
import { headers } from 'next/headers';
import { randomBytes } from 'crypto';

export async function generateCspNonce(): Promise<string> {
  const nonce = randomBytes(16).toString('base64');
  return nonce;
}

// middleware.ts
export function middleware(request: NextRequest) {
  const nonce = randomBytes(16).toString('base64');
  const csp = `
    default-src 'self';
    script-src 'self' 'nonce-${nonce}';
    style-src 'self' 'nonce-${nonce}';
    img-src 'self' blob: data:;
    connect-src 'self' https://*.supabase.co;
    frame-ancestors 'none';
    base-uri 'self';
    form-action 'self';
  `.replace(/\n/g, '');

  const response = NextResponse.next();
  response.headers.set('Content-Security-Policy', csp);
  response.headers.set('x-nonce', nonce);
  return response;
}
```

### 12.3. RLS (Row Level Security) Mandate

-   **Anti-Permissive RLS Mandate**: RLS policies on Supabase tables are **Deny by Default**.
-   **Verification Obligation**: Document RLS policy design intent in PR comments when creating new tables.
-   **`auth.uid()` Wrapping**: Wrap with `(select auth.uid())` to prevent row-level re-evaluation (performance optimization).

```sql
-- ✅ CORRECT: RLS + auth.uid() wrapping
CREATE POLICY "Users can view own data"
  ON public.profiles
  FOR SELECT
  USING (id = (select auth.uid()));

-- ✅ CORRECT: Admin policy
CREATE POLICY "Admins can view all"
  ON public.profiles
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE id = (select auth.uid()) AND role = 'admin'
    )
  );
```

-   **Cross-Reference**: `320_supabase_architecture.md`

### 12.4. Cookie Security

| Attribute | Required Value | Reason |
|:---------|:-------------|:-------|
| `HttpOnly` | `true` | Prevent JS-based cookie access |
| `Secure` | `true` | HTTPS-only transmission |
| `SameSite` | `Lax` or `Strict` | CSRF defense |
| `__Host-` prefix | Recommended | Cookie fixation attack defense |

### 12.5. SRI (Subresource Integrity)

-   `integrity` attribute is **mandatory** for external scripts/stylesheets from CDNs.
-   **Action**: Auto-generate and verify SRI hashes in CI/CD.

```html
<!-- ✅ CORRECT: External script with SRI -->
<script
  src="https://cdn.example.com/library.js"
  integrity="sha384-xxxxx..."
  crossorigin="anonymous"
></script>
```

### 12.6. DNS Security

-   **DNSSEC**: Enable DNSSEC for DNS spoofing prevention.
-   **CAA Record**: Set CAA DNS records to limit certificate authorities.
-   **SPF + DKIM + DMARC**: Complete email sending domain authentication to prevent phishing/spoofing.

### 12.7. Email Security

-   **SPF**: Limit authorized sending servers. Strict fail with `-all`.
-   **DKIM**: Email signing for tamper detection. 2048-bit keys or higher.
-   **DMARC**: Target `p=reject`. Phase from `p=none` → `p=quarantine` → `p=reject`.
-   **BIMI**: Brand logo display for enhanced phishing defense (after DMARC reach).

### 12.8. Webhook Security

-   Signature verification required for incoming webhooks (HMAC-SHA256, etc.).
-   Timestamp verification to prevent replay attacks.
-   Apply rate limiting to webhook endpoints.

---

## §13. SASE & Network Security

> **Reference**: Gartner SASE Framework, NIST SP 800-207 (Zero Trust)

### 13.1. SASE (Secure Access Service Edge)

-   **Law**: Recommend adopting **SASE** architecture integrating network security and WAN for remote work and cloud-native environments.
-   **Components**:

| Component | Function | Recommended Tools |
|:----------|:---------|:-----------------|
| **ZTNA** | Zero Trust Network Access (VPN replacement) | Cloudflare Access, Zscaler |
| **SWG** | Secure Web Gateway | Cloudflare Gateway |
| **CASB** | Cloud Access Security Broker | Netskope, Microsoft MCAS |
| **FWaaS** | Firewall-as-a-Service | Cloudflare Magic Firewall |
| **SD-WAN** | Software-Defined WAN | Cloudflare Magic WAN |

### 13.2. ZTNA (VPN Replacement)

-   **Law**: Recommend migrating from legacy VPN to ZTNA. VPNs grant full network access, creating a large Blast Radius upon breach.
-   **Action**:
    1.  Per-application access control (Microsegmentation).
    2.  Device posture checks (OS update status, EDR active, etc.).
    3.  Context-aware access (time of day, geographic location, risk score).

### 13.3. WAF (Web Application Firewall)

-   **Law**: Place WAF in front of all public web applications/APIs.
-   **Action**:
    1.  Apply OWASP Core Rule Set (CRS) based rulesets.
    2.  Custom rules for business-specific attack patterns.
    3.  Validate new rules in **monitor mode (Log Only)** before switching to block mode.
    4.  Set WAF bypass alerts to detect direct connections bypassing WAF.

### 13.4. DDoS Defense

-   **Law**: Route all domains through CDN/DDoS mitigation services and conceal origin server IPs.
-   **Action**: CDN-based DDoS mitigation + origin protection + bandwidth scaling + application-layer rate limiting.
-   **Cross-Reference**: §23 (Bot Management & DDoS Defense)

### 13.5. Network Isolation

-   **VPC Design**: Separate public subnets (ALB/CDN) from private subnets (DB/internal services).
-   **Direct DB Exposure Prohibited**: Assigning public IPs to databases is **absolutely prohibited**.
-   **Bastion Host / Session Manager**: Access internal resources via Bastion Host or SSM Session Manager.

---

## §14. Container & Cloud-Native Security

### 14.1. Image Security

-   **Minimal Base Images**: Use Distroless / Alpine minimal images.
-   **CI Scanning**: Integrate image scanning (Trivy / Clair) into CI/CD. Critical/High block deployment.
-   **Image Signing**: Sign build artifacts with Cosign (Sigstore). Reject unsigned images via Admission Webhook.
-   **Latest Tag Prohibited**: Prohibit `latest` tag in production. Specify concrete versions/SHAs.

### 14.2. Pod Security Standards

-   **Non-Root**: `runAsNonRoot: true`.
-   **Read-Only Filesystem**: `readOnlyRootFilesystem: true`.
-   **Capability Drop**: `drop: ["ALL"]`, add only minimum necessary.
-   **No Privileged**: `privileged: false`.

### 14.3. Network Policy

-   **Default Deny**: Deny all traffic by default, whitelist only necessary communication.
-   Restrict pod-to-pod communication to minimum necessary (Microsegmentation).

### 14.4. Runtime Security

-   **Law**: Build-time scanning alone is insufficient. Detect and block runtime anomalous behavior.
-   **Action**:
    1.  **Runtime Monitoring**: Detect anomalous syscalls in real-time with Falco or equivalent.
    2.  **Image Immutability**: Prohibit patching running containers. Deploy new images (Immutable Infrastructure).
    3.  **Egress Policy**: Control container outbound traffic with Network Policy. Structurally prevent data exfiltration.

### 14.5. Admission Controller

-   Auto-reject security policy violations via ValidatingAdmissionWebhook / Kyverno / OPA Gatekeeper.
-   Validate new policies in `dry-run` mode before production enforcement.

### 14.6. Supply Chain (Container-Specific)

-   Record hashes at each stage of multi-stage Dockerfiles for build reproducibility.
-   Automate base image CVE monitoring. Rebuild within **72 hours** of Critical CVE detection.

---

## §15. File Upload Security

### 15.1. Server-Side Validation

-   **Law**: Never rely solely on client-side validation. Always re-validate server-side.
-   **Action**:
    1.  **MIME Type Verification**: Inspect both **magic bytes (file header)** and `Content-Type` header.
    2.  **Extension Verification**: Restrict via whitelist (e.g., `.jpg`, `.png`, `.pdf`).
    3.  **Size Limits**: Set max size per type (e.g., images 10MB, documents 50MB).
    4.  **Filename Sanitization**: Never use user filenames directly. Rename with UUID. Strip `../`.

### 15.2. Metadata Removal

-   **Law**: Strip EXIF metadata (GPS, camera info, etc.) from uploaded images before storage.

### 15.3. Executable File Blocking

-   Executable files (`.exe`, `.sh`, `.bat`, `.ps1`, `.js`, etc.) are **blocked by default**.
-   Detect and reject double extensions like `.jpg.exe`, `.pdf.js`.

### 15.4. Signed URL Pattern

-   Recommend **Signed URL** pattern for direct storage upload of large files.
-   **Action**: Max 5-minute expiry, `Content-Type` conditions, `Content-Length` conditions, server-side re-validation after upload.

### 15.5. Storage Bucket Security

-   **Bucket Separation**: Separate public and private assets into **different buckets**.
-   **RLS Required**: Require RLS policies on all Supabase Storage buckets.
-   **CORS Restriction**: Allow only app domain. `*` prohibited.

### 15.6. Content-Disposition Security

-   Set `Content-Disposition: attachment` for user-uploaded file downloads.
-   Allow `inline` only for images (`image/*`). Force `attachment` for HTML/SVG/PDF.

### 15.7. Image Processing Security

-   Use Sharp (libvips-based) over ImageMagick for safety.
-   **Pixel Bomb Prevention**: Set pixel count limits (e.g., 100MP) against Decompression Bombs.

---

## §16. Cryptographic Policy & Post-Quantum Cryptography

> **Reference**: NIST FIPS 203/204/205, NIST SP 800-131A Rev.2

### 16.1. Prohibited Algorithms

| Prohibited Algorithm | Reason | Alternative |
|:--------------------|:-------|:-----------|
| **MD5** | No collision resistance | SHA-256+ |
| **SHA-1** | Collision attacks demonstrated | SHA-256+ |
| **DES / 3DES** | Insufficient key length | AES-256 |
| **RC4** | Statistical bias | AES-256-GCM |
| **RSA-1024** | Insufficient key length | RSA-2048+, Ed25519 recommended |
| **Blowfish (except bcrypt)** | 64-bit block size vulnerability | AES-256 |

### 16.2. Recommended Algorithms

| Purpose | Recommended Algorithm |
|:--------|:---------------------|
| **Symmetric Encryption** | AES-256-GCM |
| **Hashing** | SHA-256, SHA-384, SHA-512 |
| **Password Hashing** | Argon2id, bcrypt (cost ≥ 12), scrypt |
| **Digital Signatures** | Ed25519, ECDSA P-256 |
| **Key Exchange** | X25519, ECDH P-256 |
| **TLS** | TLS 1.3 recommended, TLS 1.2 minimum |

### 16.3. Key Management Lifecycle

| Phase | Requirements |
|:------|:-----------|
| **Generation** | Generate with CSPRNG. `Math.random()` prohibited |
| **Storage** | Store in HSM / KMS / Vault. Plaintext storage prohibited |
| **Distribution** | Distribute via encrypted channels (TLS 1.2+). Slack pasting prohibited |
| **Usage** | Non-purpose usage prohibited |
| **Rotation** | Every 90 days. Immediate rotation on leakage |
| **Destruction** | Secure destruction (zero-fill or cryptographic erasure) |

### 16.4. Post-Quantum Cryptography (PQC)

-   **Law**: Following NIST PQC standardization (FIPS 203: ML-KEM, FIPS 204: ML-DSA, FIPS 205: SLH-DSA), plan migration to hybrid cryptographic modes.
-   **FIPS Standard Reference**:

| FIPS | Algorithm | Purpose | Status |
|:-----|:---------|:--------|:-------|
| **FIPS 203** | ML-KEM (formerly CRYSTALS-Kyber) | Key encapsulation | Published Aug 2024 |
| **FIPS 204** | ML-DSA (formerly CRYSTALS-Dilithium) | Digital signatures | Published Aug 2024 |
| **FIPS 205** | SLH-DSA (formerly SPHINCS+) | Digital signatures (hash-based) | Published Aug 2024 |
| **FIPS 206** | FN-DSA (formerly FALCON) | Digital signatures | Expected 2025 |
| **HQC** | Code-based KEM | Key encapsulation (diversification) | Expected 2027 |

-   **Migration Timeline**:

| Milestone | Deadline | Action |
|:----------|:---------|:-------|
| **Crypto Inventory** | Immediate | Inventory all in-use cryptographic algorithms |
| **Crypto-Agility Design** | End of 2026 | Introduce architecture enabling easy algorithm replacement |
| **Hybrid Mode** | 2027 | Evaluate/deploy classical+PQC hybrid TLS key exchange (X25519Kyber768, etc.) |
| **RSA/ECC Deprecation** | 2030 | Phase out existing crypto per NIST recommendations |
| **Full PQC Migration** | 2035 | Complete elimination of quantum-vulnerable algorithms |

-   **Harvest Now, Decrypt Later (HNDL)**: Risk of currently captured encrypted data being decrypted by future quantum computers. Consider PQC hybrid encryption **immediately** for long-term confidential data.

---

## §17. AI/LLM Security

> **Reference**: OWASP Top 10 for LLM Applications 2025, NIST AI RMF, EU AI Act

### 17.1. Prompt Injection Defense (LLM01:2025)

-   **Law**: When inserting user input into LLM prompts, **structurally defend against prompt injection attacks**.
-   **Action**:
    1.  **System/User Prompt Separation**: Clearly separate system prompts from user input.
    2.  **Input Sanitization**: Filter control characters and prompt manipulation patterns.
    3.  **Output Validation**: Validate LLM output with structured formats (JSON Schema, etc.). Reject unexpected output.
    4.  **Guardrail Implementation**: Deploy guardrails (topic restriction, harmful content detection) on both input and output.

### 17.2. Sensitive Information Disclosure Defense (LLM02:2025)

-   **Law**: Defend against LLM leaking sensitive information from training data or configuration.
-   **Action**: Detect/mask PII/secret patterns in output filters. Apply RBAC to data access in RAG.

### 17.3. Supply Chain Vulnerabilities (LLM03:2025)

-   **Law**: Manage supply chain risks for LLM models, plugins, and training data.
-   **Action**: Verify model provenance, licensing, and integrity. Security assessment of third-party plugins.

### 17.4. Data/Model Poisoning (LLM04:2025)

-   **Law**: Prevent contamination of training and fine-tuning data.
-   **Action**: Input and provenance validation of training data. Access control on fine-tuning pipelines.

### 17.5. Excessive Agency Control (LLM06:2025)

-   **Law**: Minimize permissions/tools granted to LLMs. Enforce Human-in-the-Loop for critical operations.
-   **Action**: Scope limitation on tool calls, approval flows for destructive operations, operation log auditing.

### 17.6. System Prompt Leakage Defense (LLM07:2025)

-   **Law**: Never include sensitive information (API keys, internal URLs, business logic) in system prompts.
-   **Action**: Externalize sensitive information to environment variables. Resilience testing against prompt extraction attacks.

### 17.7. Vector/Embedding Security (LLM08:2025)

-   **Law**: Protect integrity of vector DB/embeddings in RAG architectures.
-   **Action**: Access control on embedding sources, write permission restrictions on vector DBs, injection detection.

### 17.8. Unbounded Consumption Defense (LLM10:2025)

-   **Law**: Prevent cost explosion/DoS from excessive LLM requests.
-   **Action**: Token usage rate limiting, per-user daily caps, cost alert configuration.
-   **Cross-Reference**: `400_ai_engineering.md` (Token cost management)

### 17.9. Model Access Control

-   **Law**: Protect LLM model access with authentication/authorization to prevent unauthorized use.
-   **Action**:
    1.  **API Authentication**: Protect LLM endpoint access with API key + request signing.
    2.  **Usage Monitoring**: Real-time monitoring of token usage per user/API key. Auto-detect anomalous usage patterns.

---

## §18. Agentic AI & MCP/A2A Security

> **Reference**: OWASP LLM Top 10 (LLM06), MAESTRO Framework, EU AI Act

### 18.1. Agentic AI Security Principles

-   **Law**: Apply additional security guardrails to AI agents (systems where LLMs autonomously act using tools).
-   **Rationale**: Agentic AI gives LLMs "hands and feet," dramatically increasing the risk of Prompt Injection leading to real damage (data deletion, unauthorized transactions, etc.).

### 18.2. Agent Permission Management

| Principle | Implementation |
|:---------|:-------------|
| **Least Privilege** | Grant agents only minimum tools/APIs needed for task completion. Deny dangerous permissions (filesystem write, direct DB operations) by default |
| **Approval Flow** | Require user approval (Human-in-the-Loop) for destructive operations (deletion, financial operations, external API calls) |
| **Chain Depth Limit** | Set upper limits on agent-to-agent call chain depth in multi-agent architectures |
| **Sandbox Execution** | Execute agent code in isolated sandbox environments |
| **Output Audit** | Record all agent actions (tool calls, API calls, generated content) in audit logs |

### 18.3. MCP (Model Context Protocol) Security

-   **Law**: Apply the following security controls to AI agent integration with external tools/data via MCP.
-   **Action**:
    1.  **MCP Server Approval**: Mandate formal security evaluation/approval process for new MCP server adoption.
    2.  **Approved Server Inventory**: Maintain and publish a whitelist of approved MCP servers.
    3.  **Prompt Injection via MCP**: Recognize the risk of MCP server prompt repositories becoming attack vectors; enforce input validation.
    4.  **User Context Propagation**: Since MCP's host-to-server user context propagation is optional, mandate explicit auth implementation to prevent privilege escalation.
    5.  **Comprehensive Logging**: Log all prompts, tool calls, and data accesses.

### 18.4. A2A (Agent-to-Agent) Security

-   **Law**: Apply the following security controls to inter-agent communication and collaboration.
-   **Threat Model**:

| Threat | Description | Countermeasure |
|:-------|:-----------|:-------------|
| **Agent Card Spoofing** | Fake agent identity | Agent ID verification + signing |
| **Task Replay Attack** | Re-execution of past tasks | Timestamp + nonce verification |
| **Cross-Agent Prompt Injection** | Injection via inter-agent data | Input validation at each agent |
| **Privilege Escalation** | Permission expansion between agents | Authorization checks at each stage |
| **Infinite Delegation Loop** | Endless delegation loop | Chain depth limit + timeout |

-   **Action**:
    1.  Strict validation of input, tokens, and authorization.
    2.  Encrypt agent communications (mTLS recommended).
    3.  Apply RBAC to inter-agent data sharing.

### 18.5. MAESTRO Threat Modeling

-   **Law**: Recommend applying the MAESTRO framework (7-layer security architecture) for threat modeling of Agentic AI systems.
-   **Cross-Reference**: `400_ai_engineering.md`

---

## §19. Secure SDLC (Shift-Left Security)

> **Reference**: NIST SSDF (SP 800-218), OWASP SAMM, Microsoft SDL

### 19.1. Security Gate Mandate

| Phase | Security Gate | Blocking |
|:------|:------------|:---------|
| **Design** | Threat modeling / PIA | Yes |
| **Coding** | SAST + Secret Scan | Yes |
| **PR/Review** | Security checklist verification | Yes |
| **Build** | SBOM generation + dependency scanning | Yes |
| **Test** | DAST + penetration testing | Yes (Critical/High only) |
| **Deploy** | Config drift detection + image signing | Yes |
| **Operations** | SIEM + audit log monitoring | — |

### 19.2. Threat Modeling

-   **Law**: Conduct **STRIDE** or **DREAD**-based threat modeling during the design phase for important new features.
-   **Action**: Create DFDs, Trust Boundary analysis, threat prioritization (resolve High+ in design), document in Blueprint.

### 19.3. CI/CD Pipeline Security

-   **Law**: CI/CD pipelines are attack targets. Manage pipeline security as **part of supply chain security**.
-   **Action**:
    1.  **Least Privilege**: Grant secrets at job scope, not repository scope.
    2.  **Pinned Actions**: Pin GitHub Actions by **SHA** (tags prohibited).
    3.  **Ephemeral Runners**: Operate self-hosted runners as ephemeral (disposable).
    4.  **OIDC Token**: Use OIDC tokens instead of long-lived secrets.
    5.  **Branch Protection**: CI/CD triggers only via protected branch rules.

```yaml
# ✅ Secure GitHub Actions configuration
jobs:
  deploy:
    permissions:
      contents: read       # Least privilege
      id-token: write      # OIDC
    steps:
      - uses: actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11 # SHA pinned
      - uses: aws-actions/configure-aws-credentials@e3dd6a429d7300a6a4c196c26e071d42e0343502
        with:
          role-to-assume: ${{ secrets.AWS_ROLE_ARN }}  # OIDC auth
          aws-region: ap-northeast-1
```

### 19.4. Security Champion Program

-   **Law**: Appoint a **Security Champion** per development team.
-   **Responsibilities**: Security checks in PR reviews, risk assessment of new libraries, quarterly team security sessions, incident first response.

---

## §20. GraphQL Security

### 20.1. Introspection Control

-   **Law**: **Disable** GraphQL introspection in production. Prevent schema discovery reconnaissance.
-   **Action**: If introspection must be enabled, require **strong authentication/authorization** and log all introspection queries. Enable via environment variable in development only.

```typescript
// ✅ Disable introspection in production (Apollo Server example)
const server = new ApolloServer({
  typeDefs,
  resolvers,
  introspection: process.env.NODE_ENV !== 'production',
});
```

### 20.2. Query Depth Limiting

-   **Law**: Prevent server resource exhaustion from deeply nested queries.
-   **Action**: Limit max query depth to **5–7 levels**. Reject on excess.

### 20.3. Query Complexity Analysis

-   **Law**: Assign "cost" per field and set upper limits on query complexity scores.
-   **Action**:
    1.  Scalar fields: cost 1, lists/relations: cost 10×item count.
    2.  Set max complexity score (e.g., 1000). Return `429 Too Complex` on excess.
    3.  Allow higher limits for authenticated users (tiered).

### 20.4. Field-Level Authorization

-   **Law**: Implement **field-level authorization checks** at the GraphQL resolver level.

```typescript
// ✅ Field-level authorization
const resolvers = {
  User: {
    email: (parent, args, context) => {
      if (context.user.id !== parent.id && context.user.role !== 'admin') {
        throw new ForbiddenError('Access denied');
      }
      return parent.email;
    },
  },
};
```

### 20.5. Batch Request Control

-   **Law**: Prevent attacks batching multiple GraphQL operations in a single HTTP request.
-   **Action**: Limit batch operations to **5–10**. **Completely prohibit** batching on auth endpoints.

### 20.6. GraphQL-Aware Rate Limiting

-   **Law**: Apply rate limiting by **GraphQL operation unit**, not HTTP request count.
-   **Rationale**: GraphQL can bundle multiple heavy operations in one request, easily bypassing HTTP-layer rate limits.

### 20.7. Production Error Message Control

-   **Law**: Suppress detailed GraphQL error messages (stack traces, schema info) in production.
-   **Action**: Convert to generic messages via error formatter. Record details in server-side logs only.

---

## §21. Secrets Management

### 21.1. Core Principles

-   **Law**: Centrally manage all secrets (API keys, DB passwords, certificates, encryption keys) and automate their lifecycle.
-   **Action**:
    1.  **Hardcoding Absolutely Prohibited**: Physically prohibit embedding secrets in code, config files, `.env` files (under Git), or version control.
    2.  **Runtime Retrieval**: Retrieve secrets from secure external sources at runtime.
    3.  **Least Privilege**: Grant access to secrets only as minimally needed per user/service.

### 21.2. Centralized Management Tools

| Tool | Recommended Environment | Key Features |
|:-----|:-----------------------|:------------|
| **HashiCorp Vault** | Multi-cloud/Hybrid | Dynamic secrets, Encryption-as-a-Service |
| **AWS Secrets Manager** | AWS-centric | AWS integration, auto-rotation |
| **Google Secret Manager** | GCP-centric | GCP integration, IAM-based access |
| **Supabase Vault** | Supabase environment | In-DB encrypted secret storage |
| **Vercel Environment Variables** | Vercel deployments | Per-environment secret management |

### 21.3. Dynamic Secrets

-   **Law**: Prefer **short-lived dynamic secrets** over static keys/passwords where possible.
-   **Action**: Generate short-lived DB connection credentials via Vault. Auto-expire on session end.

### 21.4. Secret Zero Problem Resolution

-   **Law**: Mandate designs where the "first secret" (Secret Zero) to access the secret manager does not itself become a vulnerability.
-   **Solutions**:
    1.  **OIDC/Workload Identity**: Present cryptographically signed ID proof (cloud environments, CI/CD).
    2.  **Platform Auth**: Leverage platform-specific mechanisms (AWS IAM Role, GCP Service Account, etc.).
    3.  **AppRole**: Vault AppRole auth (RoleID + short-lived SecretID) combination.

### 21.5. Auto-Rotation

| Secret Type | Rotation Frequency |
|:-----------|:------------------|
| **API Keys** | Every 90 days |
| **DB Passwords** | Every 60 days |
| **Service Accounts** | Every 30 days |
| **Encryption Keys** | Every 90 days (§16.3) |
| **High-Risk Secrets** | More frequently as needed |

-   **Dual-Phase Rotation**: Generate new secret → distribute → validate with old secret still active → invalidate old secret after validation.

### 21.6. NHI (Non-Human Identity) Secret Management

-   **Law**: Strengthen management of "non-human IDs" that own/use secrets.
-   **Action**:
    1.  Inventory all NHI IDs with clear owner assignment.
    2.  Strictly apply least privilege to NHI IDs.
    3.  Apply **shorter rotation cycles** for NHI secrets.
    4.  Periodically detect and deactivate unused NHI IDs.
-   **Cross-Reference**: §3.2 (NHI Management)

### 21.7. CI/CD Pipeline Secret Management

-   **Law**: Secret management within CI/CD pipelines is critical. Pipeline compromise = entire infrastructure compromise.
-   **Action**:
    1.  Prohibit hardcoding in pipeline configs/scripts.
    2.  Inject secrets at job scope.
    3.  **OIDC auth** (§19.3) to authenticate with cloud providers, eliminating long-lived secrets.
    4.  **Secret Masking**: Auto-mask secrets in CI logs.

---

## §22. Client-Side Security

### 22.1. DOM XSS Defense

-   **Law**: Prevent DOM-based XSS that executes entirely within the browser.
-   **Action**:
    1.  **Trusted Types**: Restrict dangerous DOM sinks (`innerHTML`, `document.write`, etc.) at the type level with `Content-Security-Policy: require-trusted-types-for 'script'`.
    2.  **Sanitization**: Always apply sanitizers like `DOMPurify` when inserting user input into DOM.
    3.  **Framework Default Escaping**: Leverage React/Vue default escaping. Require **special PR review approval** for `dangerouslySetInnerHTML` / `v-html` usage.

```typescript
// ❌ PROHIBITED: innerHTML without Trusted Types
element.innerHTML = userInput;

// ✅ CORRECT: Sanitize with DOMPurify
import DOMPurify from 'dompurify';
element.innerHTML = DOMPurify.sanitize(userInput);

// ✅ BEST: Trusted Types Policy
if (window.trustedTypes) {
  const policy = trustedTypes.createPolicy('default', {
    createHTML: (input: string) => DOMPurify.sanitize(input),
  });
}
```

### 22.2. Third-Party Script Management

-   **Law**: Third-party scripts are a **primary supply chain attack vector**. Strictly control adoption and management.
-   **Action**:
    1.  **Inventory Management**: Document purpose, risk, owner, and CSP settings for all third-party scripts.
    2.  **Approval Process**: Require security review and approval for new third-party scripts.
    3.  **SRI (Subresource Integrity)**: Apply `integrity` attribute to all external scripts/CSS (§12.5).
    4.  **Version Pinning**: Pin CDN script versions. Prohibit `latest` URL usage.
    5.  **Periodic Auditing**: Periodically audit third-party script behavior and detect suspicious external communications.
-   **PCI DSS 4.0**: Requirement 6.4.3 mandates script inventory and SRI on payment pages.

### 22.3. Local Storage Security

-   **Law**: **Never store** secrets, tokens, or PII in `localStorage` / `sessionStorage`.
-   **Rationale**: On successful XSS, JavaScript can immediately steal all `localStorage` data.
-   **Alternative**: Manage auth tokens with `HttpOnly` + `Secure` + `SameSite` cookies or server-side sessions.

### 22.4. PostMessage Security

-   **Law**: Always verify `origin` when using `window.postMessage` / `MessageEvent`.
-   **Action**: Match `event.origin` against whitelist. Prohibit sending messages to `*`.

### 22.5. Frontend Dependency Security

-   **Law**: Frontend dependencies are also subject to supply chain risk. Evaluate security, not just bundle size.
-   **Action**:
    1.  Integrate `npm audit` into CI/CD (§11.2).
    2.  Periodically detect and remove unused dependencies (attack surface reduction).
    3.  Detect unexpected dependency inclusion via bundle analyzer.

---

## §23. Bot Management & DDoS Defense

### 23.1. Bot Detection & Classification

| Category | Examples | Response |
|:---------|:---------|:---------|
| **Good Bots** | Googlebot, Bingbot | Allow via robots.txt, gentle rate limiting |
| **Bad Bots** | Scrapers, Credential Stuffing | Block |
| **Sophisticated Bots** | Headless browsers, AI-driven bots | Detect via behavioral analysis |

### 23.2. Multi-Layer Bot Defense

-   **Action**:
    1.  **Managed Challenge (Turnstile)**: CAPTCHA alternative. Apply to form submissions, logins, API endpoints.
    2.  **Behavioral Analysis**: Analyze mouse movement, input patterns, scroll behavior. Flag requests deviating from human patterns.
    3.  **Device Fingerprinting**: Generate unique identifiers from browser/device characteristics. Detect anomalous behavior from identical fingerprints.
    4.  **Multi-Layer Rate Limiting**: Per-IP, per-user/API key, per-endpoint limits.
    5.  **Honeypot**: Hidden form fields that only bots fill in.

### 23.3. DDoS Defense Strategy

-   **Law**: Proactively build multi-layer defense against DDoS attacks.
-   **Action**:
    1.  **CDN Edge Protection**: Route all domains through CDN. Conceal origin servers. Enable DDoS mitigation.
    2.  **Origin Protection**: Keep origin server IPs private. Prevent direct access bypassing CDN.
    3.  **Bandwidth Scaling**: Eliminate single points of failure with load balancers and redundancy.
    4.  **Application Layer Defense**: Individual rate limits for resource-intensive processing (search, DB writes).
    5.  **Anomaly Detection**: Baseline normal traffic patterns and detect sharp deviations in real-time.
-   **DDoS Response Plan**: Define detection criteria → configure auto-mitigation rules → escalation procedures → notification templates.

### 23.4. API Abuse Pattern Detection

-   **Law**: Analyze **request patterns** rather than individual requests to detect abuse.
-   **Detection Patterns**: High-speed access to the same account from different IPs, dictionary attack patterns, out-of-order API calls, mass account creation in short time.

---

## §24. Security Quality Standards

### 24.1. Security Testing Strategy

| Test Type | Frequency | Scope |
|:---------|:---------|:------|
| **SAST** | Every CI | Full codebase |
| **DAST** | Weekly/Sprint | Public endpoints |
| **SCA (Dependencies)** | Every CI | All dependencies |
| **Penetration Testing** | Twice yearly | External intrusion testing |
| **Red Team Exercise** | Annually | Full scope |
| **Bug Bounty** | Always | Discovery by external researchers |

### 24.2. Security Education

-   **Law**: Mandate minimum security education for all engineers.
-   **Action**:
    1.  **Onboarding**: OWASP Top 10 overview, secure coding basics.
    2.  **Quarterly**: Latest threat trends, incident case reviews.
    3.  **Annual**: Hands-on CTF (Capture The Flag) exercises.
    4.  **Role-Based**: Frontend (XSS/CSRF), Backend (Injection/BOLA), Infrastructure (IAM/Network) specialized training.

### 24.3. Incident Response Plan

-   **Law**: Maintain and update a pre-defined response plan for security incidents.
-   **Incident Severity Classification**:

| Severity | Definition | Initial Response SLA |
|:---------|:----------|:--------------------|
| **P1 (Critical)** | Data breach, full service outage | Within 15 minutes |
| **P2 (High)** | Partial outage, signs of vulnerability exploitation | Within 1 hour |
| **P3 (Medium)** | Potential vulnerability discovered | Within 24 hours |
| **P4 (Low)** | Informational security event | Next business day |

-   **Cross-Reference**: `503_incident_response.md`

### 24.4. Security Metrics & KPIs

| Metric | Target | Measurement Frequency |
|:-------|:------|:---------------------|
| **MTTR (Vulnerability Remediation)** | Critical ≤ 24h, High ≤ 72h | Monthly |
| **Vulnerability Density** | < 1/KLOC (Critical+High) | Sprint |
| **Patch Coverage** | ≥ 95% (within 14 days) | Monthly |
| **MFA Adoption Rate** | 100% (admins) / ≥ 80% (overall) | Monthly |
| **Incident Detection Time** | ≤ 1 hour | Monthly |
| **Security Training Completion** | 100% | Quarterly |

---

## §25. Advanced Security Operations (SecOps)

### 25.1. Audit Log Design

-   **Law**: Comprehensively record security-related events and store in tamper-proof form.
-   **Required Log Fields**:

| Field | Description |
|:------|:-----------|
| `timestamp` | ISO 8601 format (with timezone) |
| `actor_id` | ID of the operation executor |
| `actor_type` | human / service / ai_agent |
| `action` | Action performed |
| `resource` | Target resource |
| `result` | success / failure / denied |
| `ip_address` | Source IP address |
| `user_agent` | User agent |
| `change_diff` | Before/after diff (for destructive operations) |

-   **Tamper Prevention**: Store audit logs in append-only storage. Make deletion/modification physically impossible.
-   **Retention Period**: Retain for at least 1 year (extend per regulatory requirements).

### 25.2. Business Logic Security

-   **Law**: Detect and defend against abuse of business logic, not just technical vulnerabilities.
-   **Detection Targets**:
    1.  Coupon/point fraud (multiple application, negative value manipulation).
    2.  Race condition double processing (double booking, double payment).
    3.  Price manipulation (client-side price rewriting).
    4.  Referral program self-referral fraud.
-   **Countermeasures**: Server-side state/amount validation, idempotency key implementation, operation atomicity guarantees.

### 25.3. Penetration Testing

-   **Law**: Conduct external penetration testing regularly (at least twice yearly).
-   **Scope**: OWASP Testing Guide v5 compliant. Coverage of OWASP Top 10 + API Security Top 10.
-   **Reporting**: Classify findings by risk level. Re-test Critical/High after remediation.

---

## §26. Security Observability

### 26.1. SIEM Integration

-   **Law**: Aggregate security-related logs and events into an integrated SIEM platform for correlation analysis.
-   **Action**:
    1.  Integrate application logs, infrastructure logs, auth logs, and WAF logs into SIEM.
    2.  Use correlation rules to detect threats from combinations of individually normal-appearing events.
    3.  Visualize real-time security posture via dashboards.

### 26.2. XDR (Extended Detection and Response)

-   **Law**: Recommend integrated threat detection and response spanning endpoints, network, cloud, and identity.
-   **Action**: Integration of EDR + NDR + Cloud Security. AI-based anomaly detection.

### 26.3. SOAR (Security Orchestration, Automation, and Response)

-   **Law**: Build automated response workflows (Playbooks) for recurring security incidents.
-   **Playbook Examples**:
    1.  **Phishing Response**: Email received → URL scan → malice determination → sender blocked → affected users notified.
    2.  **Account Compromise**: Anomaly detected → session invalidation → forced password reset → log preservation.
    3.  **Malware Detection**: EPP detection → isolation → IOC extraction → all-endpoint scan → report generation.

### 26.4. Security Dashboard

-   **Law**: Provide real-time security posture dashboards to executives and development teams.
-   **Display Items**: Vulnerability summary (Critical/High/Medium/Low), incident statistics, patch application status, MFA adoption rate, compliance score.
-   **Cross-Reference**: §24.4 (Security Metrics), §29 (Security Governance)

---

## §27. Vendor Security Management

### 27.1. Vendor Security Evaluation Criteria

| Evaluation Category | Check Items | Minimum Requirements |
|:-------------------|:-----------|:--------------------|
| **Certification** | ISO 27001 / SOC 2 Type II | At least one |
| **Data Encryption** | At rest & in transit | AES-256 + TLS 1.2+ |
| **Access Control** | RBAC, MFA | Admin MFA required |
| **Incident Response** | Plan and notification time | Initial report within 24 hours |
| **Data Location** | Data center location | Same region as service delivery |
| **Backup & DR** | Frequency and recovery | Daily backup + RTO within 24 hours |

### 27.2. Vendor SLA Template

| SLA Item | Recommended Standard | Violation Response |
|:---------|:--------------------|:-----------------|
| **Availability** | 99.9%+ (monthly) | Credit refund or penalty |
| **Incident Notification** | Within 24 hours of discovery | Contract violation record |
| **Data Recovery** | RPO 24h / RTO 4h | Escalation |
| **Patch Application** | Critical: 72h / High: 2 weeks | Improvement plan required |
| **Audit Cooperation** | Annual acceptance obligation | Contract review on refusal |

### 27.3. Sub-Processor Management

-   **Prior Notification**: **30 days** advance notice before new sub-processor engagement.
-   **Equivalent Terms**: Impose equivalent security/privacy conditions.
-   **Chain Limitation**: Sub-sub-processing is **prohibited in principle**. Requires individual approval.
-   **List Management**: Maintain and disclose complete sub-processor list.
-   **Cross-Reference**: GDPR Art.28(2), Global Privacy Laws sub-processor supervision obligation

---

## §28. Regulatory Compliance Deep Dive

> **Reference**: EU AI Act, NIS2, DORA, GDPR, Global Privacy Laws

### 28.1. EU AI Act Compliance

-   **Law**: Comply with EU AI Act risk classification and obligations when serving EU markets.

| Category | Risk Level | Obligations | Enforcement Date |
|:---------|:----------|:-----------|:----------------|
| **Prohibited AI** | Unacceptable | Use prohibited | Feb 2025 |
| **General-Purpose AI (GPAI)** | — | Transparency & copyright compliance | Aug 2025 |
| **High-Risk AI** | High | Risk management, data governance, technical documentation, logging, human oversight, accuracy/robustness/cybersecurity | Aug 2026 |
| **Limited Risk AI** | Limited | Transparency obligation (AI usage disclosure) | Aug 2026 |

-   **High-Risk AI Cybersecurity Requirements (Art.15)**:
    1.  Resilience against data poisoning, model poisoning, adversarial samples, model evasion.
    2.  Robustness against errors, faults, inconsistencies (technical redundancy, fail-safe).
    3.  Conformity assessment, CE marking, EU DB registration.

### 28.2. NIS2 Compliance

-   **Law**: Mandate risk-based cybersecurity management for services subject to NIS2 Directive (enforced Oct 2024).
-   **Requirements**: Incident response plans, supply chain security, encryption, access control, vulnerability management.
-   **Incident Reporting**: Initial report within 24 hours, detailed report within 72 hours for significant incidents.

### 28.3. DORA (Digital Operational Resilience Act)

-   **Law**: Comply with DORA ICT risk management requirements when providing AI/IT systems to the financial sector.
-   **Requirements**: ICT risk management framework, incident reporting, digital operational resilience testing, ICT third-party risk management.

### 28.4. Cross-Regulatory Compliance Matrix

| Requirement | GDPR | Global Privacy Laws | NIS2 | DORA | EU AI Act |
|:-----------|:----:|:----:|:----:|:----:|:---------:|
| Data Protection Impact Assessment | ✅ | — | — | — | ✅ (High-Risk) |
| Incident Reporting | 72h | Promptly | 24h initial | 4h initial | 72h (significant) |
| Supply Chain Management | ✅ | ✅ | ✅ | ✅ | ✅ |
| Encryption Obligation | Recommended | Recommended | ✅ | ✅ | ✅ |
| Audit & Evidence Preservation | ✅ | ✅ | ✅ | ✅ | ✅ |

---

## §29. Security Governance

> **Reference**: NIST CSF 2.0 (Govern Function), ISO 27001, COBIT

### 29.1. Governance Framework

-   **Law**: Integrate security risk management into Enterprise Risk Management (ERM). Use NIST CSF 2.0 Govern function as the reference framework.
-   **Action**:
    1.  **Organizational Context**: Document business objectives, regulatory requirements, and risk environment; reflect in security strategy.
    2.  **Security Strategy**: Define risk appetite (acceptable risk levels) and reflect in security investment prioritization.
    3.  **Roles and Responsibilities**: Define RACI matrix for security decision-makers, executors, consultees, and informees.

### 29.2. Risk Appetite Definition

| Risk Level | Definition | Response Policy |
|:----------|:----------|:---------------|
| **Critical** | Fatal impact on business continuity | Immediate response. Risk acceptance not permitted |
| **High** | Major financial/legal/reputational damage | Implement mitigation within 72 hours |
| **Medium** | Limited impact | Planned response |
| **Low** | Minor impact | Continue monitoring. Acceptable |

### 29.3. Security Budget & Resources

-   **Guideline**: Recommend allocating **10-15%** of IT budget to security (NIST/industry standard).
-   **Priority Investment Areas**: IAM, threat detection & incident response, security automation, security education & training.

### 29.4. Executive Reporting

-   **Law**: Establish regular security status reporting to executives/board of directors.
-   **Report Content**: Security metrics dashboard (§24.4 KPI summary), key risks and status, incident summary, compliance status, security investment ROI.
-   **Frequency**: Quarterly + ad-hoc reporting for significant incidents.

### 29.5. Policy Management

-   **Law**: Regularly review and update security policies to prevent obsolescence.
-   **Action**:
    1.  **Annual Review**: Mandate annual review of all security policies.
    2.  **Trigger-Based Updates**: Immediate policy updates on significant incidents, regulatory changes, or tech stack changes.
    3.  **Version Control**: Maintain version history of policy documents.
    4.  **Communication Obligation**: Ensure communication and acknowledgment from all stakeholders on policy changes.

### 29.6. Compliance Auditing

-   **Law**: Conduct regular internal/external security audits to ensure compliance.
-   **Action**:
    1.  **Internal Audit**: Semi-annual security configuration and operations self-assessment.
    2.  **External Audit**: Recommend annual third-party security audit (SOC 2 Type II, etc.).
    3.  **Remediation**: Develop remediation plans within 30 days of audit findings, complete within 90 days.

---

## §30. Maturity Model & Anti-Patterns

### 30.1. Security Maturity Model (5 Levels)

| Level | Name | Characteristics |
|:------|:-----|:---------------|
| **Level 1: Initial** | Ad-hoc response | Security depends on individual knowledge. No policies |
| **Level 2: Developing** | Basic policy established | Basic policies exist. Partial implementation. No automation |
| **Level 3: Defined** | Standardized & org-wide | Unified policies across all teams. Security gates integrated into CI/CD |
| **Level 4: Managed** | Measured & optimized | KPI measurement. Risk-based decision-making. SIEM/SOAR operational |
| **Level 5: Optimized** | Continuous improvement & prediction | AI-based threat prediction. Permanent red team. Exceeds industry benchmarks |

### 30.2. Top 30 Security Anti-Patterns

| # | Anti-Pattern | Reference Section |
|:--|:------------|:-----------------|
| 1 | Hardcoded secrets | §4.1, §21.1 |
| 2 | `SELECT *` usage | §7.2 |
| 3 | Table exposure without RLS policies | §12.3 |
| 4 | `Access-Control-Allow-Origin: *` | §10.7 |
| 5 | No CSP header / `unsafe-inline` | §12.1, §12.2 |
| 6 | PII in log output | §7.4 |
| 7 | SQL string concatenation | §10.4 |
| 8 | Client-side only input validation | §10.3 |
| 9 | Token storage in `localStorage` | §22.3 |
| 10 | Admin panel without MFA | §4.2 |
| 11 | Stack trace in production errors | §10.9 |
| 12 | Image deploy with `latest` tag | §14.1 |
| 13 | GitHub Actions without SHA pinning | §19.3 |
| 14 | Image storage without EXIF removal | §15.2 |
| 15 | Password hashing with MD5/SHA-1 | §16.1 |
| 16 | SMS OTP as sole second factor | §4.2 |
| 17 | DB with public IP | §13.5 |
| 18 | Long-lived static API keys | §21.5 |
| 19 | Excessive agent permissions | §18.2 |
| 20 | Deployment without SBOM generation | §11.1 |
| 21 | Unverified webhook signatures | §12.8 |
| 22 | DMARC not configured | §12.7 |
| 23 | Missing audit logs | §25.1 |
| 24 | Neglected dependency vulnerabilities | §11.2 |
| 25 | Custom-built auth infrastructure | §4.3 |
| 26 | `Math.random()` for crypto key generation | §16.3 |
| 27 | Unapproved MCP server adoption | §18.3 |
| 28 | Shared NHI credentials | §3.2 |
| 29 | Cookie settings without consent | §9.2 |
| 30 | Design without threat modeling | §19.2 |

---

## Language-Specific Security

### TypeScript / JavaScript

-   `eval()`, `Function()`, `new Function()` usage is **completely prohibited**.
-   `dangerouslySetInnerHTML` / `v-html` requires **special PR review approval**.
-   Minimize `any` type usage. Use `unknown` + Zod for input validation.
-   Enforce secret retrieval via `process.env`. Direct values prohibited.
-   Enforce `===` strict equality (prohibit `==`).

### Python

-   Passing untrusted data to `pickle.loads()` is **absolutely prohibited** (arbitrary code execution risk).
-   `subprocess.call(shell=True)` prohibited. Use `subprocess.run()` + list arguments.
-   `os.system()` prohibited.
-   Use `yaml.safe_load()`. `yaml.load()` is **prohibited**.
-   Be cautious of direct user input expansion in `format()` / f-strings. Template injection countermeasures.

### Go

-   Use `html/template` (`text/template` lacks XSS protection).
-   Use `crypto/rand` (`math/rand` is unsuitable for cryptographic use).
-   Use `database/sql` placeholders for SQL queries (string concatenation prohibited).
-   Prevent goroutine resource leaks (`context.WithTimeout` / `context.WithCancel`).

### SQL

-   `SELECT *` prohibited. Explicitly specify only needed columns.
-   Dynamic SQL prohibited. Use parameterized queries only.
-   `GRANT ALL` prohibited. Grant only necessary permissions individually.
-   `SECURITY DEFINER` functions must include `SET search_path = public`.

---

## Appendix A: Quick Reference Index

| Keyword | Section |
|:--------|:--------|
| A2A | §18.4 |
| Access Control | §4.5, §10.1 |
| Account Lockout | §6.6 |
| Agentic AI | §18 |
| API Discovery / Shadow API | §10.10 |
| API Gateway | §10.11 |
| API Key | §4.8, §21 |
| Audit Log | §25.1 |
| Authentication | §4 |
| Authorization | §4.5, §10.1 |
| BOLA / BFLA | §10.1 |
| Bot Management | §23 |
| CAPTCHA / Turnstile | §6.6, §23.2 |
| Container | §14 |
| Cookie | §12.4 |
| CORS | §10.7 |
| CSP (Content Security Policy) | §12.2 |
| Cryptography | §16 |
| CSRF | §10.8 |
| Data Classification | §8.1 |
| Data Minimization | §7.2 |
| Data Residency | §7.6 |
| DDoS | §23.3 |
| DKIM / DMARC / SPF | §12.7 |
| DOM XSS | §22.1 |
| DORA | §28.3 |
| DSPM | §8.2 |
| DTO | §10.2 |
| Dynamic Secrets | §21.3 |
| Email | §12.7 |
| Encryption | §7.5, §16 |
| Error Handling | §10.9 |
| EU AI Act | §28.1 |
| EXIF | §15.2 |
| File Upload | §15 |
| GDPR / Global Privacy Laws / CCPA | §9.1 |
| Governance | §29 |
| GraphQL | §20 |
| HSTS | §12.1 |
| Incident Response | §24.3 |
| Identity-First | §2.4, §3 |
| Injection | §10.4 |
| ITDR | §3.3 |
| JWT | §6.1, §6.7 |
| Kubernetes / K8s | §14 |
| License | §11.4 |
| LLM / AI Security | §17 |
| Local Storage | §22.3 |
| Logging | §25.1, §7.4 |
| MAESTRO | §18.5 |
| MCP | §18.3 |
| MFA | §4.2 |
| NHI (Non-Human Identity) | §3.2, §21.6 |
| NIS2 | §28.2 |
| NIST CSF 2.0 | §2.3, §29 |
| Nonce | §12.2 |
| OAuth / Social Login | §4.4 |
| OWASP Top 10 | §10, §17 |
| PAM | §3.4 |
| Passkey / WebAuthn / FIDO2 | §5 |
| Password | §4.9, §16.2 |
| Penetration Test | §25.3 |
| Permissions-Policy | §12.1 |
| PII | §7.3, §7.4 |
| PostMessage | §22.4 |
| Post-Quantum / PQC | §16.4 |
| Privacy | §7 |
| Prompt Injection | §17.1 |
| Rate Limiting | §10.6, §23.2 |
| RBAC | §4.5 |
| Right to be Forgotten | §9.3 |
| Risk Appetite | §29.2 |
| RLS (Row Level Security) | §12.3 |
| SASE | §13.1 |
| SBOM | §11.1 |
| Secret Management | §21 |
| Secret Rotation | §6.7, §16.3, §21.5 |
| Secret Zero | §21.4 |
| Session | §6 |
| SIEM | §26.1 |
| SLSA | §11.3 |
| SOAR | §26.3 |
| SRI (Subresource Integrity) | §12.5, §22.2 |
| SSRF | §10.5 |
| Supply Chain | §11 |
| Third-Party Scripts | §22.2 |
| TLS | §7.5, §16.2 |
| Trusted Types | §22.1 |
| Vendor | §27 |
| WAF | §13.3 |
| Webhook | §12.8 |
| XDR | §26.2 |
| Zero Trust | §2 |
| ZTNA | §13.2 |
| Zod / Validation | §10.3 |

---

> **Cross-References (Related Rule Files)**:
> - `000_core_mindset.md` — Priority hierarchy, zero tolerance
> - `300_engineering_standards.md` — CI/CD, coding standards
> - `301_api_integration.md` — API design, CORS governance
> - `320_supabase_architecture.md` — RLS, Auth, Vault, Connection Pooling
> - `361_aws_cloud.md` — AWS WAF, IAM, KMS
> - `400_ai_engineering.md` — AI guardrails, token management
> - `502_site_reliability.md` — Availability, monitoring, alerts
> - `503_incident_response.md` — Incident response flow
> - `601_data_governance.md` — Legal compliance, data governance, cookie management
> - `602_oss_compliance.md` — License management details
> - `700_qa_testing.md` — Security testing policy

### Cross-References

| Section | Related Rules |
|:--------|:------------|
| §1–§2 (Zero Trust) | `300_engineering_standards`, `801_governance` |
| §3 (Identity-First) | `320_supabase_architecture`, `360_firebase_gcp` |
| §7–§9 (Privacy) | `601_data_governance` |
| §10 (API Security) | `301_api_integration` |
| §11 (Supply Chain) | `602_oss_compliance` |
| §12–§13 (Infrastructure/SASE) | `502_site_reliability`, `361_aws_cloud` |
| §17–§18 (AI/LLM) | `400_ai_engineering` |
| §28 (Regulatory Compliance) | `601_data_governance`, `800_internationalization` |

