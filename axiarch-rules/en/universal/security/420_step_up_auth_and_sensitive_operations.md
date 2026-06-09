# 66. Step-Up Authentication & Sensitive Operations

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-06-09

> [!IMPORTANT]
> **Level 1 Priority: Absolute Compliance**
> Protection of sensitive operations (payment, privilege change, PII change, deletion, export, admin operations) takes precedence over convenience, development speed, and revenue.
> **This file is the deep-dive companion to `000_security_privacy.md §6.2 (Step-Up Authentication), §6 (Session Management), §4.2 (MFA), §3.3 (ITDR)`.**
> If a conflict with the parent file arises, adopt the stricter side.

> [!CAUTION]
> **Primary Directive**
> "Authentication is not a one-time check of *who* you are — it is the continuous verification that, *at each critical moment*, the right principal is acting at the right level of assurance."
> The mere existence of a session does not authorize a sensitive operation. For every sensitive operation, verify on the server side an assurance level and authentication freshness commensurate with the operation's severity.
> **Priority**: Security (asset/data protection) > Compliance > UX (minimize friction) > DX (ease of implementation).

---

## Table of Contents

- [I. Foundational Principles & Assurance Model (§1-§3)](#i-foundational-principles--assurance-model-1-3)
- [II. Step-Up / Re-authentication (§4-§7)](#ii-step-up--re-authentication-4-7)
- [III. Risk-Based / Adaptive Authentication (§8-§11)](#iii-risk-based--adaptive-authentication-8-11)
- [IV. OTP & One-Time Links (§12-§15)](#iv-otp--one-time-links-12-15)
- [V. Transaction Authentication & Signing (§16-§17)](#v-transaction-authentication--signing-16-17)
- [VI. Sensitive-Operation Gate Implementation Discipline (§18-§21)](#vi-sensitive-operation-gate-implementation-discipline-18-21)
- [VII. Session Management (§22-§27)](#vii-session-management-22-27)
- [VIII. Account Takeover (ATO) & MFA Fatigue (§28-§30)](#viii-account-takeover-ato--mfa-fatigue-28-30)
- [IX. Cross-Cutting Concerns (Observability, FinOps, UX, Scale, Privacy, a11y) (§31-§37)](#ix-cross-cutting-concerns-observability-finops-ux-scale-privacy-a11y-31-37)
- [X. Responsibility Boundaries (§38)](#x-responsibility-boundaries-38)
- [XI. Anti-Patterns (§39)](#xi-anti-patterns-39)
- [XII. Maturity Model (§40)](#xii-maturity-model-40)
- [Appendix A: Quick Reference Index](#appendix-a-quick-reference-index)
- [Cross-References](#cross-references)

---

# I. Foundational Principles & Assurance Model (§1-§3)

---

## §1. Foundational Principles

### Rule 66.001: Session Existence ≠ Operation Authorization
- **Law**: A valid session indicates only "logged-in" state; it **does not authorize a sensitive operation**. For every sensitive operation, verify on the server side the authenticator assurance level (AAL) and authentication freshness commensurate with the operation's severity.
- **Action**:
  1. Do not make the authorization decision for sensitive operations depend solely on possession of a token issued at login.
  2. Re-evaluate at operation time the metadata describing "when / at what strength / with which factor" the user authenticated (the `acr`/`amr`/`auth_time` claims described in §2).
- **Cross-Reference**: §4 (Step-Up), §18 (Server-Side Enforcement)

### Rule 66.002: The Freshness Principle
- **Law**: Sensitive operations require *recent* authentication. Stale authentication (a login from hours or days ago) would allow a sensitive operation even if the session had been stolen. Define a **maximum allowed authentication age (max_age)** per operation.
- **Recommended max_age baselines**:

| Operation Tier | Examples | Recommended max_age |
|:---|:---|:---|
| **Tier 1: View** | Reading data | Within session lifetime (no re-auth) |
| **Tier 2: Modify** | Profile update | ≤ 24 hours |
| **Tier 3: Sensitive change** | Email/phone/password change, MFA settings change | ≤ 5 min (recent re-auth required) |
| **Tier 4: Money & privilege** | Payment, role change, API key issuance | ≤ 5 min + phishing-resistant factor |
| **Tier 5: Destructive** | Account deletion, full data purge, bulk export | ≤ 5 min + double confirmation + notification |

- **Note**: This table operationalizes the Tiered Security Protocol of the parent file `000_security_privacy.md §6.2` from a freshness perspective. Values may be tuned to risk appetite, but a design where Tier 3+ "never requires re-auth" is prohibited.

### Rule 66.003: Prefer Phishing Resistance
- **Law**: For Tier 4+ sensitive operations, **prioritize** re-authentication with phishing-resistant factors (**Passkey/FIDO2/WebAuthn, hardware keys**). Using SMS OTP as the sole factor for Tier 4+ is **prohibited** (due to SIM-swap and SS7 weaknesses; see §14).
- **Cross-Reference**: `000_security_privacy.md §4.2`, `400_authentication_and_passkeys.md` (Passkey details)

---

## §2. Expressing Assurance via OIDC (acr / amr / auth_time / max_age)

### Rule 66.010: Express Authentication Context via Standard Claims
- **Law**: Express and verify authentication strength, factors, and time via **OIDC standard claims** rather than a custom implementation.
- **Key claims**:

| Claim | Meaning | Use |
|:---|:---|:---|
| `acr` (Authentication Context Class Reference) | Assurance level of authentication (e.g., `urn:mace:incommon:iap:silver`, `phr`=phishing-resistant; custom values allowed) | Determine the minimum assurance level required for an operation |
| `amr` (Authentication Methods References) | Methods used (`pwd`, `otp`, `mfa`, `hwk`, `swk`, `fido`, `face`, `fpt`, etc.) | Verify factor type (e.g., whether phishing-resistant) |
| `auth_time` | Time the user actually authenticated (UNIX time) | Freshness determination |
| `max_age` | Maximum elapsed authentication seconds the client requests in the authorization request | Trigger forced re-auth on stale authentication |

- **Action**:
  1. **Requesting side**: Before a sensitive operation, send a re-authorization request with `max_age` and the required `acr_values`.
  2. **Verifying side**: Verify server-side that the ID token's `auth_time` is newer than `now - max_age`, and that `acr`/`amr` satisfy the required assurance level.
  3. `max_age=0` means "always re-authenticate." For Tier 5, also use `prompt=login` (or equivalent) to force a re-prompt.

```typescript
// ✅ Re-auth request (client → authorization server): specify max_age and acr before a sensitive operation
function buildStepUpAuthUrl(returnTo: string): string {
  const params = new URLSearchParams({
    client_id: process.env.OIDC_CLIENT_ID!,
    redirect_uri: process.env.OIDC_REDIRECT_URI!,
    response_type: 'code',
    scope: 'openid',
    // Force re-auth unless authentication occurred within the last 300 seconds
    max_age: '300',
    // Request a phishing-resistant level (align with the IdP's definition)
    acr_values: 'phr',
    // Optionally also force an explicit re-prompt for sensitive operations
    prompt: 'login',
    // CSRF protection
    state: generateState(returnTo),
    nonce: crypto.randomUUID(),
  });
  return `${process.env.OIDC_AUTH_ENDPOINT}?${params}`;
}
```

```typescript
// ✅ Server-side verification: re-evaluate freshness and assurance level at operation time
import type { JWTPayload } from 'jose';

const PHISHING_RESISTANT_AMR = new Set(['hwk', 'fido', 'pkc']); // tune to implementation/IdP

function assertStepUpSatisfied(
  claims: JWTPayload & { auth_time?: number; acr?: string; amr?: string[] },
  opts: { maxAgeSec: number; requirePhishingResistant: boolean },
): void {
  const now = Math.floor(Date.now() / 1000);
  if (typeof claims.auth_time !== 'number') {
    throw new StepUpRequiredError('auth_time missing');
  }
  // Freshness verification
  if (now - claims.auth_time > opts.maxAgeSec) {
    throw new StepUpRequiredError('reauthentication required (stale auth_time)');
  }
  // Phishing-resistant factor verification
  if (opts.requirePhishingResistant) {
    const amr = claims.amr ?? [];
    if (!amr.some((m) => PHISHING_RESISTANT_AMR.has(m))) {
      throw new StepUpRequiredError('phishing-resistant factor required');
    }
  }
}
```

- **Anti-Pattern**: Not reading `acr`/`amr`/`auth_time` from the ID token and judging freshness only by an app-local "last login time" flag (it diverges from the IdP's authentic authentication event and risks tampering/staleness).
- **Cross-Reference**: `410_federated_identity_and_oauth.md` (OIDC/OAuth details)

---

## §3. AAL (Authenticator Assurance Level) Mapping

### Rule 66.020: NIST SP 800-63B AAL to Operation Tier Mapping
- **Law**: Define the AAL required for an operation's severity and disallow operations for sessions that do not meet it.

| AAL | Requirement | Operation Tier |
|:---|:---|:---|
| **AAL1** | Single factor (e.g., password). Low assurance | Tier 1-2 |
| **AAL2** | Two factors (memorized + possession/biometric). Minimum line for most sensitive operations | Tier 3-4 |
| **AAL3** | Hardware cryptographic authenticator + verifier-impersonation resistance (phishing resistance mandatory) | Tier 4-5 (high-value payment, admin destructive ops) |

- **Action**: For AAL2+, manage reauthentication validity per NIST (AAL2: re-auth at most every 12 hours or after 30 min inactivity; AAL3: at most every 12 hours or 15 min inactivity). Set sensitive-operation `max_age` shorter than this.
- **Cross-Reference**: §2 (max_age), `000_security_privacy.md §4.9` (password policy)

---

# II. Step-Up / Re-authentication (§4-§7)

---

## §4. When to Require Step-Up

### Rule 66.030: Definition of Sensitive Operations (Trigger List)
- **Law**: Classify the following as **sensitive operations** and enforce step-up (re-authentication) on the server side regardless of session validity.

| Category | Examples | Minimum Tier |
|:---|:---|:---|
| **Payment & money movement** | Charge, transfer, withdrawal, refund, add/change payment method | Tier 4 |
| **Privilege & role change** | Admin elevation, grant/revoke role, (privileged) member invite | Tier 4 |
| **Authentication factor change** | Password change, add/remove MFA, register/remove Passkey, change recovery methods | Tier 3 |
| **Contact change** | Email change, phone-number change | Tier 3 |
| **PII change** | Change of legal name, address, identity verification (KYC) info | Tier 3 |
| **Deletion & destruction** | Account deletion, workspace deletion, full data purge | Tier 5 |
| **Export** | Bulk data export, portability request, backup download | Tier 4 |
| **Admin operations** | View/delete audit logs, key operations, production config changes | Tier 4-5 |
| **API/secrets** | Issue/revoke API keys, create OAuth client, rotate webhook signing key | Tier 4 |
| **Device/session** | Add trusted device, undo global session revocation | Tier 3 |

- **Note**: "Contact change" and "authentication factor change" are the classic post-takeover operations (locking the victim out) in ATO, so protect them especially strictly (see §28).

### Rule 66.031: Chain-of-Change Defense
- **Law**: Immediately after an email change, provide "notification to the old email + a rollback grace period." For contact/password changes, concurrently trigger **global session revocation** (§24) and **operation notification** (§21), breaking the chain by which an attacker achieves full takeover via a single change.

---

## §5. Re-authentication Implementation Methods

### Rule 66.040: Three Re-authentication Methods
- **Law**: Choose re-authentication from the following based on the operation tier and available factors. Automatic fallback in the degrading direction (strong→weak) is allowed only insofar as it does not lower the tier.

| Method | Overview | Suitability |
|:---|:---|:---|
| **WebAuthn re-auth** | Run `navigator.credentials.get()` with a registered Passkey/authenticator, requiring biometric/PIN via `userVerification: 'required'` | Top choice for Tier 4-5. Phishing-resistant |
| **TOTP/OTP re-entry** | Re-enter a registered TOTP or one-time code | Tier 3-4. Fallback where WebAuthn is unavailable |
| **Password re-entry** | Re-confirm the current password | Minimum line for Tier 3. Insufficient alone for Tier 4 |

```typescript
// ✅ WebAuthn re-auth (client): set userVerification to required; challenge is server-issued
async function reauthenticateWithWebAuthn(): Promise<PublicKeyCredential> {
  const options = await fetchServerChallenge(); // server issues challenge/allowCredentials
  const assertion = await navigator.credentials.get({
    publicKey: {
      challenge: base64urlToBuffer(options.challenge),
      allowCredentials: options.allowCredentials,
      userVerification: 'required', // require biometric/PIN (possession + verification)
      timeout: 60_000,
    },
  });
  return assertion as PublicKeyCredential;
}
```

### Rule 66.041: Single-Use Binding of Re-authentication Challenges
- **Law**: Bind the re-authentication challenge (WebAuthn challenge / OTP) to **one specific operation**. Scope the "stepped-up" state obtained on challenge success to the target object, operation type, and a short validity window (e.g., 5 min). Do not set a generic "stepped-up flag" and apply it across the whole session (this prevents a hole where one re-auth passes unrelated sensitive operations).

---

## §6. Step-Up Tokens / Grants

### Rule 66.050: Designing Short-Lived Step-Up Grants
- **Law**: On successful re-authentication, issue an operation-scoped short-lived grant (e.g., a signed JWT or a temporary flag within the server-side session).
- **Required claims/attributes**:
  - `sub` (principal), `op` (allowed operation type), `target` (target resource ID), `iat`/`exp` (≤ 5 min), `jti` (single-use, replay prevention), `acr`/`amr` (achieved assurance level).
- **Action**: The sensitive-operation handler verifies this grant and registers `jti` in a consumed list to reject reuse.

```typescript
// ✅ Server-side guard for a sensitive-operation handler (pseudo-code)
async function requireStepUp(req: Request, op: SensitiveOp, targetId: string): Promise<void> {
  const grant = await verifyStepUpGrant(req); // verify signature, exp, acr/amr
  if (grant.op !== op || grant.target !== targetId) {
    throw new StepUpRequiredError('grant scope mismatch');
  }
  if (await isJtiConsumed(grant.jti)) {
    throw new StepUpRequiredError('grant already used'); // replay prevention
  }
  await consumeJti(grant.jti, grant.exp);
}
```

---

## §7. Trusted Devices ("Remember this device")

### Rule 66.060: Handle Trusted Devices Carefully
- **Law**: A "trust this device" feature reduces friction but is abused on stolen or shared devices. Allow it only when the following hold.
  - Limit the scope of trust to **Tier 3 or lower**. Tier 4-5 (money, destruction, privilege) **require step-up every time** even on trusted devices.
  - Set an expiry for trust (e.g., 30 days). After expiry, require step-up again.
  - The trust token is a dedicated cookie with HttpOnly, Secure, and SameSite attributes, bound to a device signal (§9).
  - Provide a UI where users can review and individually revoke "trusted devices" (§27).

---

# III. Risk-Based / Adaptive Authentication (§8-§11)

---

## §8. Risk Signals & Scoring

### Rule 66.070: Collecting Risk Signals
- **Law**: Collect risk signals on every login and sensitive-operation event and compute a risk score.
- **Key signals**:

| Category | Example signals |
|:---|:---|
| **Device** | New device, device-fingerprint change, jailbreak/root, emulator |
| **Network** | New IP, IP reputation (Tor/VPN/data center), ASN change |
| **Geo** | New country/region, Impossible Travel (geo-velocity), high-risk region |
| **Time/behavior** | Unusual hours, deviation in behavioral biometrics (typing/interaction rhythm) |
| **Account** | Recent auth failures, recent password/contact change, breached-credential match |
| **Operation** | High value, unusual transfer recipient, consecutive sensitive operations in a short window |

### Rule 66.071: Graduated Defense (Risk Score Thresholds)
- **Law**: Strengthen defenses in stages according to risk-score thresholds. Pass low risk transparently (zero friction); block high risk.

| Risk band | Action |
|:---|:---|
| **Low** | Transparent (no added friction) |
| **Medium** | Step-up via OTP / TOTP |
| **High** | Phishing-resistant factor (Passkey/hardware key) required |
| **Very high** | Block + out-of-band notification + manual review/ITDR integration |

- **Cross-Reference**: `000_security_privacy.md §3.3` (ITDR), `000_security_privacy.md §6.4` (Impossible Travel)

---

## §9. Device Fingerprinting / Bot-Detection Integration

### Rule 66.080: Handling Device Signals
- **Law**: Integrate device fingerprinting and bot detection (see `000_security_privacy.md §23`) as inputs to the risk score. However, a fingerprint **must not be the sole authentication factor** (it is spoofable and raises privacy concerns); treat it strictly as an auxiliary signal for risk evaluation.
- **Action**: Generate and store fingerprints in accordance with privacy principles (§36), honoring consent, minimization, and retention limits.

---

## §10. Continuous Access Evaluation (CAEP)

### Rule 66.090: Real-Time Re-evaluation During a Session
- **Law**: Following Zero Trust "continuous verification" (`000_security_privacy.md §2.1.4`), detect changes in risk state even after a session is issued and revise privileges immediately.
- **Action**:
  1. **CAEP / Shared Signals Framework (SSF)**: Push-share security events (session revocation, credential change, device-posture degradation) between IdP and resources to trigger immediate re-auth/revocation.
  2. Prefer event-driven (Push) over polling; do not wait until token expiry.
  3. On detecting a high-risk event, immediately apply a step-up requirement or revocation to the session.
- **Cross-Reference**: §22-§24 (Session Management), `000_security_privacy.md §3.3`

---

## §11. Operational Discipline for Adaptive Authentication

### Rule 66.100: Managing Misclassifications (FP/FN)
- **Law**: Continuously monitor false positives (excessive friction for legitimate users) and false negatives of the risk engine, and tune thresholds.
- **Action**: Measure step-up firing rate, success rate, false-positive rate, and abandonment rate (§31). Regularly review the balance point that errs on the side of safety without degrading UX (§35).

---

# IV. OTP & One-Time Links (§12-§15)

---

## §12. TOTP (RFC 6238)

### Rule 66.110: TOTP Implementation Discipline
- **Law**: Implement TOTP per RFC 6238.
- **Requirements**:
  - **Algorithm/digits/period**: HMAC-SHA-1 (common, for compatibility; consider SHA-256 for new builds) / 6 digits / 30 seconds.
  - **Clock-skew tolerance**: up to ±1 step (±30 seconds). An excessive window eases brute force and is prohibited.
  - **Secret generation**: sufficient entropy from a cryptographic RNG (≥ 160 bits).
  - **Secret storage**: encrypt at rest (KMS). Plaintext storage prohibited.
  - **Verification**: constant-time comparison (§13), rate limiting and attempt limiting (§13).
  - **Reuse prevention**: reject reuse of a recently accepted OTP (same time step) (replay prevention).
  - **Enrollment verification**: have the user verify one valid TOTP during the enrollment flow before activation.

```typescript
// ✅ TOTP verification: constant-time comparison + reject reuse of recent step
import { timingSafeEqual } from 'node:crypto';

function verifyTotp(secret: Buffer, code: string, opts: { window?: number } = {}): boolean {
  if (!/^\d{6}$/.test(code)) return false; // format check (keep enumeration responses uniform)
  const window = opts.window ?? 1;
  const step = Math.floor(Date.now() / 1000 / 30);
  for (let i = -window; i <= window; i++) {
    const expected = generateTotp(secret, step + i);
    const a = Buffer.from(expected);
    const b = Buffer.from(code);
    if (a.length === b.length && timingSafeEqual(a, b)) return true; // constant-time comparison
  }
  return false;
}
```

---

## §13. Common OTP Implementation Discipline

### Rule 66.120: Rate Limiting, Attempt Limiting, Enumeration Prevention
- **Law**: OTP verification endpoints are targets for brute force and enumeration. Require the following.
  - **Attempt limiting**: lock verification attempts against a single challenge at a cap (e.g., 5) and require reissuance.
  - **Rate limiting**: multi-layer rate limiting per IP, user, and challenge. Apply rate limiting to the OTP issuance (send) side too (cost/spam prevention, §32).
  - **Constant-time comparison**: compare codes with `timingSafeEqual` or equivalent to prevent timing attacks.
  - **Enumeration prevention**: do not distinguish "wrong code" / "user does not exist" / "OTP not issued"; return a unified error. Keep response time uniform as well.
  - **Expiry**: email/SMS OTPs are short-lived (e.g., 5-10 min). Invalid after expiry.
  - **Single use**: invalidate immediately after successful verification (replay prevention).

### Rule 66.121: Backup Codes
- **Law**: Backup codes used to recover from MFA/OTP loss must be stored hashed (following the password-hashing discipline of `000_security_privacy.md §4.9`), single-use, displayed only once at generation, and old codes must be revoked en masse on regeneration.

---

## §14. Email Magic Links / One-Time Links

### Rule 66.130: One-Time Link Discipline
- **Law**: Magic links (passwordless login) and confirmation links must satisfy the following.
  - **Expiry**: short-lived (e.g., 10-15 min).
  - **Single use**: invalidate once used.
  - **Same-device/context binding**: check consistency between the link-issuing device and the opening device (recommended). At minimum, combine a confirmation code after opening so that link interception (email eavesdropping) alone cannot succeed.
  - **Token format**: an unguessable cryptographic random token. Do not include PII in the URL.
  - **Prefetch protection**: design so a GET alone has no side effects and the link is consumed only by an explicit confirmation action (POST), so that email-client/security-scanner link prefetch does not consume it.
  - **Rate limiting & enumeration prevention**: same as §13.

### Rule 66.131: Limits of Magic Links
- **Law**: Magic links depend entirely on the security of the email account. If the email is taken over, they are fully bypassed. They must not be the sole factor for sensitive operations (Tier 4-5) and must be combined with a phishing-resistant factor (§3).

---

## §15. Limits and Restricted Use of SMS / Voice OTP

### Rule 66.140: Positioning of SMS/Voice OTP
- **Law**: SMS/voice OTP is high-risk due to **SIM swap, SS7 protocol weaknesses, and phishing**. Strictly observe the following.
  - **Prohibited as the sole factor for Tier 4-5** (consistent with `000_security_privacy.md §4.2`).
  - If used, keep it as an auxiliary factor and plan migration to phishing-resistant factors (Passkey).
  - An MFA design that relies on SMS OTP **only** is **deprecated**. Make Passkey/TOTP the first choice.
  - State "do not share this code with anyone" in the message text to improve social-engineering resistance.
- **Anti-Pattern**: Confirming high-value payments with SMS OTP alone (§39).

---

# V. Transaction Authentication & Signing (§16-§17)

---

## §16. Transaction Authentication (WYSIWYS)

### Rule 66.150: What You See Is What You Sign
- **Law**: For high-value/high-risk transactions (transfers, payments, critical setting changes), present the **content actually being approved** (amount, recipient, target) in the authentication challenge and obtain a confirmation bound to that content (WYSIWYS: What You See Is What You Sign). Use a transaction-specific challenge rather than a generic "Are you sure?".
- **Action**:
  1. Include key points such as amount and recipient in the challenge (OTP message/push/WebAuthn display text).
  2. Verify on the server side that the transaction content the user confirmed and the content executed **match exactly** (detect mid-flow tampering).
  3. For WebAuthn, bind the transaction hash to the challenge tied to `clientDataJSON` to make the signed object explicit.
- **Cross-Reference**: §18 (Server-Side Enforcement), §21 (Idempotency)

---

## §17. Generalizing PSD2 SCA / Dynamic Linking

### Rule 66.160: The Dynamic Linking Principle
- **Law**: Apply the concepts of the EU PSD2 Strong Customer Authentication (SCA) and Dynamic Linking to **high-risk transactions in general**, not only payments.
- **Requirements (generalized)**:
  - The authentication code is **dynamically linked to the amount and payee** (or target operation).
  - If the amount or payee changes, the authentication code is invalidated.
  - Protect the confidentiality, authenticity, and integrity of the authentication information.
- **Note**: When handling regulated payments, follow the payment discipline in `product/300_revenue_monetization.md` and the SCA/3DS requirements of each payment provider (e.g., Stripe) (§38 Responsibility Boundaries).

---

# VI. Sensitive-Operation Gate Implementation Discipline (§18-§21)

---

## §18. Server-Side Enforcement (No Client-Side Decisions)

### Rule 66.170: Authorization Decisions Only on the Server
- **Law**: Decide step-up necessity and success/failure for sensitive operations **only on the server side**. Client-side decisions (UI button control, front-end conditionals) are merely UX hints and **must not be trusted as a security boundary**.
- **Anti-Pattern**: Judging "is the user stepped up" in the front end and not re-verifying on the API side (the leading anti-pattern in §39).
- **Cross-Reference**: `000_security_privacy.md §10.1` (BOLA/BFLA), §4.5 (centralized guard)

---

## §19. Double Confirmation

### Rule 66.180: Explicit Confirmation for Destructive Operations
- **Law**: Tier 5 (deletion, purge) requires, in addition to step-up, an **explicit intent confirmation** (high-friction confirmation such as typing the target's name) to prevent accidental operations. Bind the confirmation to the same transaction as the step-up grant (§6).

---

## §20. Audit Logging (Immutable)

### Rule 66.190: Immutable Audit Logs for Sensitive Operations
- **Law**: Record all sensitive operations to an **immutable (append-only, tamper-evident)** audit log.
- **Recorded items**: principal (user/NHI), operation type, target resource, execution time, result (success/failure), achieved step-up `acr`/`amr`, risk score, source IP/device, correlation ID.
- **PII discipline**: do not include excessive PII in logs (per `000_security_privacy.md §7.4` masking).
- **Cross-Reference**: `operations/000_internal_tools.md` (auditing admin operations), `000_security_privacy.md §4.6`

---

## §21. Notification & Idempotency

### Rule 66.200: Operation Notification
- **Law**: Notify the user out-of-band (email/push) of the execution of a sensitive operation. In particular, **notify immediately** for authentication-factor change, contact change, new device, and high-value payment, and provide an immediate-revocation path ("if this wasn't you" → global session revocation §24).

### Rule 66.201: Idempotency
- **Law**: Money and destructive operations require an **Idempotency Key** to prevent duplicate execution from network retries or double submission. Safely de-duplicate repeated requests with the same key on the server.
- **Cross-Reference**: `engineering/100_api_integration.md` (API design)

---

# VII. Session Management (§22-§27)

---

## §22. Token Expiry & Refresh Rotation

### Rule 66.210: Short-Lived Access Tokens + Refresh Rotation
- **Law**: Keep access tokens short-lived and **rotate** refresh tokens (following the baselines in `000_security_privacy.md §6.1`).

| Token type | Recommended expiry | For admin consoles |
|:---|:---|:---|
| **Access Token** | ≤ 1 hour | ≤ 15 min |
| **Refresh Token** | 7-30 days (rotation required) | ≤ 7 days |
| **Step-Up Grant** | ≤ 5 min (single use) | ≤ 5 min |
| **Session Cookie** | Browser session | Browser session |

- **Refresh Token Rotation**: issue a new token on each refresh and invalidate the old one. On **reuse detection** (use of an already-invalidated refresh token), immediately revoke the entire token family and notify the user (a sign of theft).

---

## §23. Idle / Absolute Timeout

### Rule 66.220: Timeout Baselines
- **Law**: Set both an **idle timeout** (inactivity) and an **absolute timeout** (maximum lifetime from issuance) on sessions. "Indefinite sessions" are **prohibited**.

| Class | Idle timeout | Absolute timeout |
|:---|:---|:---|
| **General users** | 30 min to a few hours (use-dependent) | ≤ 30 days |
| **Admin/privileged** | ≤ 15 min | ≤ 12 hours |
| **Financial/highly sensitive** | ≤ 5-15 min | ≤ 8 hours |

- **Note**: Align with the AAL2/AAL3 reauthentication requirements (§3).

---

## §24. Session Invalidation & Global Revocation

### Rule 66.230: Event-Driven Revocation
- **Law**: On the following events, **immediately invalidate** related sessions on the server side (client-side token deletion alone is insufficient; per `000_security_privacy.md §6.5`).
  - Password change/reset → **global session revocation** (the originating session may optionally be kept).
  - MFA/Passkey change, contact change → global revocation strongly recommended.
  - Account suspension/deletion → immediate global revocation.
  - Breach detection (ATO/ITDR) → global revocation + re-auth requirement.
- **Implementation**: match at verification time via a Token Revocation List (or short-lived tokens + a revocation flag in a server-side session store). Push to distributed resources via CAEP (§10).
- **Panic Button (Kill Switch)**: keep a global session-revocation procedure perpetually up to date (`000_security_privacy.md §6.7`).

---

## §25. Session Fixation Defense

### Rule 66.240: Regenerate Session ID at Authentication Boundaries
- **Law**: **Regenerate the session ID (and fixed identifiers)** on successful login, on privilege elevation, and on successful step-up. Reusing an identifier issued before authentication after authentication (Session Fixation) is prohibited.

---

## §26. Cookie Attributes

### Rule 66.250: Required Attributes for Session Cookies
- **Law**: Set the following mandatory attributes on session/authentication cookies.
  - `HttpOnly`: not readable from JS (mitigates token theft via XSS).
  - `Secure`: sent only over HTTPS.
  - `SameSite=Lax` (recommended) or `Strict`: CSRF mitigation (per `000_security_privacy.md §10.8`).
  - `__Host-` prefix: path `/`, Secure, no domain specified to prevent overwrite from subdomains (where possible).
  - Appropriate `Path` and `Max-Age`/`Expires` (aligned with the timeouts in §23).

---

## §27. Device / Session Management UI

### Rule 66.260: User-Visible Session Management
- **Law**: Provide a UI where users can review their **active session list** (device, location, last-active time) and **trusted device list** and revoke them individually or all at once.
- **Concurrent session policy**: set a concurrent-login cap and revoke the oldest on exceedance. Admins are stricter (1-2 concurrent, `000_security_privacy.md §6.3`).

---

# VIII. Account Takeover (ATO) & MFA Fatigue (§28-§30)

---

## §28. ATO Detection & Response

### Rule 66.270: ATO Signals & Automated Response
- **Law**: Detect signs of account takeover and defend automatically.
- **Signals**: login from anomalous geo/device, contact/password/MFA change immediately after login, breached-credential match, Impossible Travel, high-value operations in a short window.
- **Automated response**: on high risk, force step-up → revoke sessions → out-of-band notify → freeze temporarily if needed + ITDR integration (`000_security_privacy.md §3.3`).
- **Post-takeover operation defense**: impose additional step-up and a cooldown (wait before applying the change, rollback grace; equivalent to §4.31) on contact/factor changes immediately after login.

---

## §29. MFA Fatigue / Push Bombing Defense

### Rule 66.280: Preventing Push-Approval Abuse
- **Law**: Defend structurally against MFA Fatigue (push bombing) attacks that send a flood of push-approval requests in a short window (deep dive on `000_security_privacy.md §4.2`).
- **Action**:
  - **Number Matching**: adopt a scheme that requires entering a number shown on screen, rather than a simple "approve/deny."
  - **Context display**: show the originating app, location, and IP in the push.
  - **Rate limiting**: suppress consecutive push requests in a short window; pause pushes on threshold exceedance + notify the user.
  - **Deny signal**: treat a user "deny" as a risk signal and block/investigate that attempt.

---

## §30. Credential-Stuffing Integration

### Rule 66.290: Integration with Breached-Credential Detection
- **Law**: Reflect the result of breached-password checks (Have I Been Pwned, etc.; `000_security_privacy.md §4.9`) into the risk score, and on a match require a forced password change + step-up.
- **Cross-Reference**: `000_security_privacy.md §6.6` (brute-force prevention)

---

# IX. Cross-Cutting Concerns (Observability, FinOps, UX, Scale, Privacy, a11y) (§31-§37)

---

## §31. Observability

### Rule 66.300: Step-Up / Authentication Metrics
- **Law**: Measure and alert on the following to surface both attacks and UX degradation.
  - Step-up **firing rate** (per operation type), **success/failure rate**, average duration.
  - OTP verification failure rate, lockout counts, MFA Fatigue detections.
  - Risk-score distribution, distribution of graduated-defense activations, ATO detection/false-positive rate.
  - Anomalies: spikes in step-up failures, concentration from specific IP/device, geographic bias.
- **Cross-Reference**: `000_security_privacy.md §26` (security observability)

---

## §32. FinOps

### Rule 66.310: Optimizing Authentication Costs
- **Law**: OTP delivery (SMS/voice/email) and the risk engine (IDaaS MAU/evaluation charges) are cost drivers. Optimize cost without compromising safety.
- **Action**:
  - Given SMS OTP's cost, deliverability, and security inferiority, steer toward Passkey/TOTP (zero delivery cost).
  - Have the risk engine pass low-risk bands transparently, keeping evaluation/challenge counts to the necessary minimum.
  - OTP send rate limiting (§13) serves both cost and spam prevention.
- **Cross-Reference**: `operations/600_cloud_finops.md`

---

## §33. Performance / Latency

### Rule 66.320: Performance of the Step-Up Path
- **Law**: Risk evaluation and step-up verification sit on the hot path. Define a latency budget and design fail-safe behavior for outages of the external risk engine/IdP (fail-safe = deny the operation; document the trade-off with availability explicitly).

---

## §34. Scalability

### Rule 66.330: Distributed Consistency of Revocation/Grants
- **Law**: Session revocation, step-up grants, and `jti` consumption must be verifiable consistently in a distributed environment. Reconcile consistency and scale with short-lived tokens + a centralized revocation store (or CAEP Push).

---

## §35. UX (Balancing Friction and Safety)

### Rule 66.340: Friction Only When Needed
- **Law**: Limit step-up to **sensitive operations / high-risk moments** and impose no friction on low-risk operations (adaptive). Excessive friction induces dangerous avoidance behavior (e.g., disabling MFA).
- **Action**: After re-authentication, continue the operation without interruption (preserve context). On failure, clearly guide the next action to take (mind the balance with enumeration prevention).

---

## §36. Privacy

### Rule 66.350: Privacy Protection for Risk Signals
- **Law**: Risk signals such as device fingerprints, location, and behavioral biometrics may contain PII/sensitive information. Observe purpose limitation, minimization, retention limits, and consent (as applicable per jurisdiction) for collection (`000_security_privacy.md §7`).
- **Cross-Reference**: `100_data_governance.md`

---

## §37. Accessibility (a11y)

### Rule 66.360: a11y for Re-authentication / OTP
- **Law**: Make step-up/OTP flows WCAG-compliant and provide multiple methods that do not depend on a specific ability.
- **Action**:
  - Screen-reader support for OTP/re-auth screens; adequate time limits (if expiry is too short, provide an alternative to extend time).
  - Always provide alternative factors (PIN, security key) for users who cannot use biometrics (Face/fingerprint).
  - `autocomplete="one-time-code"` and appropriate labeling for OTP input fields.
  - Consider presenting number matching (§29) in a way that does not rely on vision alone.

---

# X. Responsibility Boundaries (§38)

---

## §38. Responsibility Boundary with IDaaS / Payment Providers

### Rule 66.370: What to Delegate and What to Protect Yourself
- **Law**: Clearly delineate the responsibilities for step-up, risk evaluation, and session management between your service and IDaaS / payment providers.

| Domain | Delegate to IDaaS / external provider | Guarantee in your own logic |
|:---|:---|:---|
| **Auth/MFA/Passkey** | Authentication flow, factor management, issuing `acr`/`amr` | **Verification** of `acr`/`amr`/`auth_time` and application to operations |
| **Risk engine** | Signal collection and scoring (when used) | Threshold design, activating graduated defense, business-specific signals |
| **Session** | Token issuance/rotation (when used) | Sensitive-operation gates, revocation triggers, audit logging |
| **Payment SCA/3DS** | The payment provider (e.g., Stripe) performs SCA/3DS | WYSIWYS verification of transaction content, Idempotency, notification |

- **Rule**: Even when delegating externally, **the final authorization decision and server-side enforcement (§18) remain your responsibility**. Do not take the provider's risk verdict at face value; always layer your own business-specific sensitive-operation gate on top.
- **Cross-Reference**: `engineering/500_firebase_gcp.md` (Firebase Auth/Identity Platform), `product/300_revenue_monetization.md` (payments)

---

# XI. Anti-Patterns (§39)

---

## §39. Anti-Patterns

### Rule 66.380: List of Prohibited / Deprecated Patterns
- **Law**: The following lead to serious vulnerabilities and are therefore **prohibited or deprecated**.

| # | Anti-pattern | Problem | Correct approach |
|:--|:---|:---|:---|
| 1 | Guarding sensitive operations only client-side | Bypassed by calling the API directly | Always re-verify on the server (§18) |
| 2 | Confirming high-value payments with SMS OTP only | Bypassed via SIM swap/SS7 | Phishing-resistant factor + WYSIWYS (§3, §16) |
| 3 | Indefinite sessions (no timeout) | Stolen sessions persist | Idle/absolute timeout (§23) |
| 4 | Other sessions persist after password change | Attacker stays after takeover | Global session revocation (§24) |
| 5 | OTP with no attempt/rate limit | Brute force and enumeration possible | Attempt limit + rate limit + constant-time compare (§13) |
| 6 | No MFA Fatigue defense (simple approve push) | Mis-approval via push bombing | Number Matching + suppression (§29) |
| 7 | Applying a stepped-up flag to the whole session | One re-auth passes unrelated operations | Single-use grant bound to operation/target (§41, §6) |
| 8 | Judging freshness via a custom flag without `auth_time`/`acr` | Tampering/staleness | Verify OIDC standard claims (§2) |
| 9 | Making magic links the sole Tier 4-5 factor | Full bypass via email takeover | Combine a phishing-resistant factor (§14.131) |
| 10 | Not regenerating the session ID after auth | Session Fixation | Regenerate at the auth boundary (§25) |
| 11 | Cookies without HttpOnly/Secure/SameSite | Token theft via XSS/CSRF | Required attributes + `__Host-` (§26) |
| 12 | Long-lived refresh tokens without rotation | Long-term abuse if stolen | Rotation + reuse-detection revocation (§22) |
| 13 | Comparing OTPs with string `===` | Timing attack | `timingSafeEqual` (§12, §13) |
| 14 | Enumerable errors ("wrong code" vs "not issued") | Account/state enumeration | Unified error + uniform response time (§13) |
| 15 | No notification for sensitive operations | Cannot notice abuse | Out-of-band immediate notify + revocation path (§21) |
| 16 | No Idempotency on money operations | Double charge/double transfer | Require Idempotency Key (§21) |
| 17 | No WYSIWYS (generic "OK?" confirmation) | Cannot notice content swapping | Present and bind transaction content (§16) |
| 18 | Making a fingerprint the sole authentication factor | Bypass via spoofing + privacy violation | Limit to an auxiliary signal (§9) |
| 19 | Instant apply with no notice on contact change | Locks out the victim after takeover | Notify the old contact + grace/rollback (§4.31, §28) |
| 20 | Uniform strong step-up on all operations | Excessive friction → users disable MFA | Adaptive per risk/tier (§35) |
| 21 | Backup codes stored in plaintext, reusable | Permanent bypass on leak | Hashed storage, single-use, revoke on regenerate (§13.121) |
| 22 | Letting admin operations pass on a trusted device | Privileged ops via device theft | Tier 4-5 require step-up every time (§7) |

---

# XII. Maturity Model (§40)

---

## §40. Maturity Model (L1-L5)

### Rule 66.390: Maturity of Step-Up & Sensitive-Operation Protection
- **Law**: Assess your organization's current position and progress toward L5 in stages.

| Level | State | Representative characteristics |
|:---|:---|:---|
| **L1: Initial** | Ad hoc | Sensitive operations only partially protected. Reliance on client-side decisions. SMS OTP-centric. Indefinite sessions remain in places |
| **L2: Managed** | Basics in place | Sensitive operations classified and stepped-up server-side. TOTP/OTP rate limiting and constant-time comparison. Basic timeouts |
| **L3: Defined** | Standardized | Unified freshness/assurance management via OIDC `acr`/`amr`/`max_age`. Refresh rotation + global session revocation. WYSIWYS. Audit logging in place |
| **L4: Quantified** | Metrics-driven | Risk-based graduated defense. Firing/failure/false-positive rates as metrics. MFA Fatigue defense (Number Matching). Passkey migration underway |
| **L5: Optimizing** | Continuously optimizing | Continuous verification via CAEP/SSF. Phishing resistance by default. Adaptive friction minimization. Automated ATO response + full ITDR integration. Continuous automatic threshold tuning |

---

## Appendix A: Quick Reference Index

> An index to quickly locate relevant sections from a task or keyword.

| Keyword | Related sections |
|---|---|
| Step-up / re-authentication | §1, §4, §5, §6 |
| Sensitive / critical operations | §4, §18, §19 |
| Freshness / max_age | §1.2, §2 |
| acr / amr / auth_time | §2 |
| AAL / assurance level | §3 |
| WebAuthn re-auth / Passkey | §3, §5 |
| Risk-based / adaptive auth | §8, §9, §11, §35 |
| Risk score / graduated defense | §8 |
| Device fingerprinting / bot detection | §9 |
| CAEP / continuous verification / SSF | §10, §24, §34 |
| TOTP / RFC 6238 | §12 |
| OTP discipline / rate limit / constant-time / enumeration | §13 |
| Backup codes | §13.121 |
| Magic links / one-time links | §14 |
| SMS OTP / voice OTP / SIM swap | §15 |
| Transaction authentication / WYSIWYS | §16 |
| PSD2 SCA / Dynamic Linking | §17 |
| Server-side enforcement / no client decisions | §18 |
| Double confirmation / destructive ops | §19 |
| Audit logging / immutable logs | §20 |
| Operation notification / Idempotency | §21 |
| Token expiry / refresh rotation | §22 |
| Idle / absolute timeout | §23 |
| Session invalidation / global revocation / Kill Switch | §24 |
| Session fixation / regenerate | §25 |
| Cookie attributes / HttpOnly / Secure / SameSite | §26 |
| Session management UI / trusted devices | §7, §27 |
| ATO / account takeover | §28 |
| MFA Fatigue / push bombing / Number Matching | §29 |
| Credential stuffing / breached passwords | §30 |
| Observability / metrics | §31 |
| FinOps / OTP cost / risk-engine charges | §32 |
| Performance / latency / fail-safe | §33 |
| Scalability / revocation consistency | §34 |
| UX / friction | §35 |
| Privacy | §36 |
| Accessibility / a11y | §37 |
| Responsibility boundary / IDaaS / payment provider | §38 |
| Anti-patterns | §39 |
| Maturity model | §40 |

---

## Cross-References

| Reference | Related topics |
|---|---|
| [000_security_privacy.md](../security/000_security_privacy.md) | Step-up summary (§6.2), session management (§6), MFA (§4.2), ITDR/risk scoring (§2.4, §3.3), brute-force prevention (§6.6), bot management (§23), observability (§26), privacy (§7) |
| [400_authentication_and_passkeys.md](../security/400_authentication_and_passkeys.md) | Passkey/FIDO2/WebAuthn registration & authentication, passwordless strategy, authentication-factor lifecycle |
| [410_federated_identity_and_oauth.md](../security/410_federated_identity_and_oauth.md) | OIDC/OAuth 2.1, `acr`/`amr`/`max_age`, PKCE, DPoP, PAR/RAR, federation/SSO |
| [100_data_governance.md](../security/100_data_governance.md) | Privacy protection of risk signals, data-protection regulation (related to §36) |
| [000_internal_tools.md](../operations/000_internal_tools.md) | Protection, auditing, and privileged access for admin operations (related to §20, §38) |
| [500_incident_response.md](../operations/500_incident_response.md) | Incident response on ATO/breach and global session revocation integration (related to §24, §28) |
| [500_firebase_gcp.md](../engineering/500_firebase_gcp.md) | Session/MFA/re-auth implementation on Firebase Auth / Identity Platform (related to §38) |
| [100_api_integration.md](../engineering/100_api_integration.md) | API design, Idempotency, rate limiting (related to §13, §21) |
| [300_revenue_monetization.md](../product/300_revenue_monetization.md) | Payment SCA/3DS, payment-provider responsibility boundary, transaction protection (related to §16, §17, §38) |
