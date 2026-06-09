# 64. Authentication & Passkeys Deep Dive

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-06-09

> [!IMPORTANT]
> **Level 1 Priority: Absolute Compliance**
> The authentication credential layer is the highest-blast-radius foundation: "get it wrong once and every user is endangered simultaneously."
> The MUST requirements in this file exist to reduce risk and raise the quality floor; they take priority over user convenience, development velocity, and cost.

> [!CAUTION]
> **Primary Directive**
> This file is the **deep-dive / detailed expansion** of `security/000_security_privacy.md` §4 (Authentication & Authorization), §5 (Passkeys), and §6 (Session Management).
> 000 holds summary-level policy; this file (64) provides credential-layer detail at an implementable granularity. It expands rather than duplicates.
> Session management, Step-Up authentication, and federation are delegated to adjacent files (410/420 and 000 §6); this file focuses on **the credentials themselves** (passkeys, MFA, passwords, recovery, lifecycle).

---

## Table of Contents

- §1. Primary Directive & Scope
- §2. Credential Priority (Phishing-Resistance First)
- §3. Passkey / WebAuthn / FIDO2 Architecture
  - §3.1. Terminology & Components
  - §3.2. Synced Passkey vs Device-Bound Passkey
  - §3.3. RP ID & Origin Verification
  - §3.4. Attestation Selection Criteria (none / direct / enterprise)
  - §3.5. User Verification (UV) Policy
  - §3.6. Discoverable Credential (Resident Key)
  - §3.7. Conditional UI / Conditional Mediation (Autofill)
  - §3.8. Cross-Device Authentication (CDA / hybrid transport)
  - §3.9. Related Origin Requests
  - §3.10. Signal API
  - §3.11. WebAuthn Level 3 Latest Developments
- §4. WebAuthn Implementation: Server Verification
  - §4.1. Registration (Attestation) Verification
  - §4.2. Authentication (Assertion) Verification
  - §4.3. Client Implementation (navigator.credentials)
- §5. MFA / 2FA Strategy
  - §5.1. MFA Method Strength Hierarchy
  - §5.2. TOTP (RFC 6238)
  - §5.3. Push Notification + Number Matching
  - §5.4. Hardware Security Keys
  - §5.5. SMS / Voice OTP: Deprecation & Limited Acceptance
  - §5.6. Backup Codes
- §6. Password Policy (NIST SP 800-63B / 800-63-4)
- §7. Passwordless Strategy & Migration Roadmap
- §8. Credential Lifecycle
- §9. Account Recovery Design (Weakest-Link Defense)
- §10. Cross-Cutting Perspectives (Observability / FinOps / Performance / Zero Trust / a11y / Privacy)
- §11. Responsibility Boundaries (IDaaS Premise; RP/IdP Division)
- §12. Anti-Patterns
- §13. Maturity Model L1–L5
- Appendix A: Quick Reference Index

---

## §1. Primary Directive & Scope

### 1.1. Scope of Responsibility

-   **This file (64) covers**: implementation detail of the authentication "credential" layer — passkeys/WebAuthn, MFA factors, passwords, and the lifecycle and recovery of credentials.
-   **Out of scope (delegated)**:

| Topic | Delegated to |
|:------|:-------------|
| Session/token management, full Step-Up auth design | `security/000_security_privacy.md` §6, `security/420_step_up_auth_and_sensitive_operations.md` |
| OAuth/OIDC/SAML federation, social login | `security/000_security_privacy.md` §4.4/§4.10, `security/410_federated_identity_and_oauth.md` |
| Authorization (RBAC/ABAC), PAM, ITDR | `security/000_security_privacy.md` §3, §4.5 |
| Bot mitigation & rate-limiting overview | `security/000_security_privacy.md` §10.6, §23 |

### 1.2. Core Principles

-   **Rule 64.1.1 (Phishing-Resistance First)**: When selecting a new authentication factor, make a phishing-resistant method (passkey/FIDO2/platform authenticator) the **first choice**. Non-phishing-resistant factors (OTP shared secrets, SMS) are positioned as supplementary or fallback only.
-   **Rule 64.1.2 (No In-House Auth Core)**: Building the authentication core from scratch (password hashing, sessions, WebAuthn server verification, OTP verification) is **prohibited**. Use a vetted IDaaS or maintained libraries (e.g., `@simplewebauthn`, `otplib`) (see §11).
-   **Rule 64.1.3 (Defense in Depth)**: Design so that the breach of any single factor still leaves others functioning. Even after adopting passkeys, ensure passwords and recovery paths do not remain as weak points; design all paths to equal strength (see §9).
-   **Rule 64.1.4 (No Overstatement)**: Do not claim "perfect" or "absolutely secure." This file aims to **raise the cost of attack and systematically reduce risk**; read each requirement as raising the quality floor. That said, requirements marked MUST are mandatory.

### 1.3. CIAM vs Workforce IAM Design Divergence

-   **Law**: Design decisions diverge depending on whether the audience is **consumers (CIAM: Customer Identity & Access Management)** or **employees/internal (Workforce IAM)**. Do not reuse one policy for both (MUST). Identify the use case first and apply this file's requirements per that class.

| Aspect | CIAM (consumer) | Workforce IAM (employees/org) |
|:-------|:----------------|:------------------------------|
| **Recovery** | Self-service assumed (automated, low-friction). Weakest-link defense (§9) especially critical | Admin-driven recovery (help desk, identity proofing) possible. Stricter identity proofing (IAL) |
| **MFA strictness** | Phased rollout, friction minimization (avoid drop-off). Gradual migration to phishing-resistant (§7) | Enforceable without exception. Admin/privileged require Device-Bound (§5.1) |
| **Provisioning** | Self sign-up + registration-time fraud defense (§8.1b) | Centralized via SSO/JIT/SCIM (→`410` §10) |
| **Audit retention** | Privacy law (data minimization, retention limits) takes priority (`100_data_governance.md`) | May require long-term retention for internal controls/compliance |
| **Scale/anonymity** | Large-scale, anonymous traffic, bot intrusion assumed | Known, finite user set |

-   Registration-time fraud / bot defense (§8.1b) is especially important for CIAM.

---

## §2. Credential Priority (Phishing-Resistance First)

### 2.1. Factor Strength Hierarchy

-   **Law**: Adopt authentication factors in the following priority order. Higher ranks have greater phishing resistance and replay resistance.

| Rank | Factor | Phishing-Resistant | Recommended Use |
|:----|:-------|:-------------------|:----------------|
| **S** | Device-Bound Passkey / Hardware Key (FIDO2) | Yes (origin-bound) | Admin, high-risk operations, privileged accounts |
| **A** | Synced Passkey (WebAuthn) | Yes (origin-bound) | Primary factor for general users |
| **B** | Push Notification + Number Matching | Partial | Second factor where passkeys are unavailable |
| **C** | TOTP (RFC 6238) | No (shared secret) | Second factor where passkeys are unavailable |
| **D** | SMS / Voice OTP | No (SIM swap / SS7) | Last-resort fallback only (conditions in §5.5) |

-   **Rule 64.2.1**: SMS OTP MUST NOT be used as the **sole second factor** for high-risk operations (payment, role change, account deletion). Use a phishing-resistant factor, or at minimum combine with TOTP.
-   **Rule 64.2.2**: Do not display or record "password + SMS" as "strong authentication." Neither factor is phishing-resistant; both can be captured simultaneously via real-time phishing.

### 2.2. Definition of Phishing Resistance

-   **Phishing-Resistant** means the **credential is cryptographically bound to the requesting origin** so that presenting it to a spoofed site fails. WebAuthn/FIDO2 satisfies this; OTP and passwords do not.
-   **Cross-Reference**: `security/000_security_privacy.md` §4.2 (MFA), §3.3 (ITDR)

---

## §3. Passkey / WebAuthn / FIDO2 Architecture

> **Reference Standards**: W3C WebAuthn **Level 2 (REC = Recommendation)**, WebAuthn **Level 3 (Candidate Recommendation; not a REC)**, FIDO2, CTAP2.1, FIDO Alliance Passkey Guidelines

### 3.1. Terminology & Components

| Term | Description |
|:-----|:------------|
| **RP (Relying Party)** | The service requesting authentication (your app). The RP ID is its identifier (typically a registrable domain) |
| **Authenticator** | The entity that holds and signs with credentials. Platform authenticators (Touch ID/Windows Hello) and roaming authenticators (YubiKey, etc.) |
| **Passkey** | The user-facing name for a FIDO2/WebAuthn discoverable credential. The private key stays within the authenticator |
| **CTAP2** | Protocol between the client (browser/OS) and roaming authenticators |
| **Attestation** | Mechanism by which an authenticator proves its provenance/model to the RP |
| **Assertion** | The signed response an authenticator produces during authentication |

-   **Rule 64.3.1**: Private keys and biometric templates **stay within the authenticator and are never sent to the server**. The RP stores only metadata such as public key, credential ID, and signature counter (MUST). Sending or storing biometric data on the server is prohibited (see §10.6).

### 3.2. Synced Passkey vs Device-Bound Passkey

| Type | Characteristics | When to Use |
|:-----|:----------------|:------------|
| **Synced Passkey** | Cloud-synced by a provider (iCloud Keychain / Google Password Manager / 1Password, etc.). High resilience to device loss | Primary factor for general users; cases prioritizing convenience and recoverability |
| **Device-Bound Passkey** | Bound to a single device/hardware key; not synced (`backupEligible=false`) | Admin/privileged/high-assurance use; when compliance requires single-device guarantees |

-   **Rule 64.3.2**: Record the response's **`backupEligible (BE)` / `backupState (BS)` flags** to distinguish synced from device-bound passkeys. Admin/privileged accounts MUST use Device-Bound (hardware key) passkeys (consistent with §3 admin requirements and 000 §5.5).
-   **Rule 64.3.3**: Synced passkeys make the sync provider's account takeover an attack surface. For high-assurance use, choose device-bound credentials that do not depend on the sync provider's strength.
-   For general users, default to synced passkeys, prioritizing convenience and recoverability (restore after device loss).
-   **Rule 64.3.3b (Synced vs Device-Bound selection policy)**: Make the synced-vs-device-bound choice a **policy keyed to account class and operation tier**, not ad hoc (MUST). At minimum, document: (a) general users = synced by default, (b) admin/privileged/high-assurance = Device-Bound required (§3.2 Rule 64.3.2), (c) Device-Bound when compliance requires a single-device guarantee. **Enforce policy conformance server-side** using the received BE/BS flags, and reject registrations below requirements (e.g., an admin registering synced-only).

### 3.3. RP ID & Origin Verification

-   **Rule 64.3.4 (RP ID Configuration)**: Set the RP ID to a **registrable suffix domain** (e.g., `example.com`). To share passkeys across subdomains, set the parent domain as RP ID and verify each origin is a subordinate of the RP ID (MUST).
-   **Anti-Pattern**: Setting the RP ID to a full origin (`https://www.example.com`) or a port-suffixed string / reusing a non-production RP ID for convenience. RP ID mismatches render registered passkeys unusable.
-   **Rule 64.3.5 (Origin Verification)**: During server verification, verify that `clientDataJSON.origin` is in the **allowlist of exact-match origins** (MUST). Also verify that `type` is `webauthn.create`/`webauthn.get` and that `challenge` matches the server-issued value.

### 3.4. Attestation Selection Criteria (none / direct / enterprise)

| Attestation | Content | Recommended Adoption Criteria |
|:-----------|:--------|:------------------------------|
| **none** | Does not disclose the authenticator model | **Default**. General consumer services. Privacy-respecting, low verification cost |
| **direct** | Obtains the authenticator model certificate | When you need to confirm the authenticator type/certification level (FIDO certified). Identify models via AAGUID |
| **enterprise** | Individually identifiable attestation (serial, etc.) | Managed-device only. High-assurance use that reconciles against a device inventory. Significant privacy impact |

-   **Rule 64.3.6**: Default to `attestation: 'none'` for consumer-facing services. Unnecessary `direct`/`enterprise` requests harm user privacy, so adopt them only with clear justification (model restriction, certification requirements, etc.).
-   When adopting `direct`/`enterprise`, validate authenticator authenticity and vulnerability status against the FIDO Metadata Service (MDS).

### 3.5. User Verification (UV) Policy

-   **UV** indicates whether local user verification (biometric/PIN) was performed on the authenticator. Specify `required` / `preferred` / `discouraged` for `userVerification`.
-   **Rule 64.3.7**: A passkey used as a primary (passwordless / first) factor MUST use `userVerification: 'required'`. Use as a second factor (where proof of possession alone suffices) may use `preferred`.
-   During server verification, always validate the **UV flag** in authenticatorData according to policy.

### 3.6. Discoverable Credential (Resident Key)

-   **Discoverable Credential (formerly Resident Key)**: Stores the user identifier on the authenticator side, enabling login without entering a username. Request via `residentKey: 'required'` (or `'preferred'`) + `requireResidentKey`.
-   **Rule 64.3.8**: When offering usernameless login and Conditional UI, request a discoverable credential at registration (MUST). Without it, the autofill UX cannot function.
-   Roaming authenticators have limited storage; in Device-Bound hardware-key deployments, manage the number of credentials carefully.

### 3.7. Conditional UI / Conditional Mediation (Autofill)

-   **Conditional Mediation** presents existing passkeys as browser autofill candidates on focus. Add `autocomplete="username webauthn"` to the username field and call `navigator.credentials.get({ mediation: 'conditional', ... })`.
-   **Rule 64.3.9**: Recommend Conditional UI on passkey login screens. Use `PublicKeyCredential.isConditionalMediationAvailable()` to detect support and fall back to an explicit passkey button when unsupported.

```html
<!-- ✅ Conditional UI: present passkeys as autofill candidates -->
<input type="text" name="username" autocomplete="username webauthn" />
```

### 3.8. Cross-Device Authentication (CDA / hybrid transport)

-   **CDA (hybrid transport)**: A mechanism that uses a smartphone authenticator to authenticate on another device (PC). Composed of a QR code plus a BLE proximity check. To prevent phishing relay, physical BLE proximity is required.
-   **Rule 64.3.10**: Do not disable CDA. Because the BLE proximity check is a defense layer against remote relay attacks, you MUST NOT build a custom implementation that uses QR scanning alone and skips proximity verification. Defer to the standard browser/OS flow.
-   CDA is useful as a fallback for first-time cross-device login. It is especially valuable in cross-ecosystem cases (iOS↔Windows, etc.) where synced passkeys are unavailable.

### 3.9. Related Origin Requests

-   **Related Origin Requests**: When the same service runs across multiple eTLD+1 domains (e.g., `example.com` and `example.co.jp`), publish `/.well-known/webauthn` to allow passkey use from related origins (WebAuthn L3).
-   **Rule 64.3.11**: To share passkeys across multi-domain deployments, use Related Origin Requests. Do not work around this by carelessly setting the RP ID to a broad domain. Manage the `origins` list in `/.well-known/webauthn` strictly.

### 3.10. Signal API

-   **Signal API** (WebAuthn L3): An API for the RP to notify authenticators/password managers of credential state changes. `signalUnknownCredential` (suggest deleting a credential not present on the server), `signalAllAcceptedCredentials` (sync the list of valid credentials), `signalCurrentUserDetails` (update username/display name).
-   **Rule 64.3.12**: On credential revocation or username change, call the Signal API to suppress **ghost passkeys** on the password manager side (entries that remain in the UI although already deleted server-side). Perform best-effort on supporting browsers only.

### 3.11. WebAuthn Level 3 Latest Developments

-   **Adoption Policy**: Implement on the **WebAuthn Level 2 (REC, Recommendation, stable) foundation**, and add Level 3 features (Related Origin Requests, Signal API, `getClientCapabilities()`, etc.) as **progressive enhancements** behind feature detection.
-   **Accurate spec status**: WebAuthn Level 3 is a **Candidate Recommendation (CR; not yet a REC/Recommendation)** and may still change. Do not error on lack of L3 support; design so that authentication always completes with the **L2 core features, which are a REC** (MUST).

### 3.12. Passkey Provider Trust Model

-   **Background**: A synced passkey's private key is replicated/synced under the control of the sync provider (password manager). Therefore the **provider's trustworthiness is a premise of authentication strength**. Providers differ in key protection, E2E encryption, recovery means, and audit.
-   **Rule 64.3.13 (Assessing provider trust)**: Classify passkey providers by trust level and set the required bar per use.
    -   **High trust (allowed by default)**: OS platform providers (Apple iCloud Keychain / Google Password Manager / Microsoft). Synced-key protection and E2E are built in, with ecosystem integration assumed.
    -   **Requires assessment (case-by-case)**: third-party password managers (e.g., 1Password). Allow after assessing their key E2E encryption, recovery, and organizational-management specifics.
    -   For high-assurance use, prefer Device-Bound (§3.2) that does not depend on the sync provider's strength.
-   Where AAGUID can identify the authenticator/provider type, define an allowed-provider policy per use (avoid excessive lock-in; balance against user choice).

### 3.13. Credential Portability (CXP / CXF — Future Support)

-   **Background**: In 2025, the FIDO Alliance published the **Credential Exchange Protocol (CXP) / Credential Exchange Format (CXF)**, advancing standardization for **securely exporting/importing** passkeys across providers — moving away from prior provider lock-in (non-migratable).
-   **Rule 64.3.14 (Recognize as future support)**: As CXP/CXF are still maturing in spec/implementation, they are **not a new mandatory requirement now**, but: (a) avoid designs that hinder users migrating providers, (b) ensure portability of credential metadata (consistent with §11.2), (c) recognize the trust-assessment policy for migrated (imported) passkeys as a future design extension point. Revisit as the standard matures.

---

## §4. WebAuthn Implementation: Server Verification

> Use a maintained server library such as `@simplewebauthn/server` (Node). The examples below illustrate the items that **must be verified** on the server.

### 4.1. Registration (Attestation) Verification

-   **Mandatory checks (MUST)**: (1) challenge match (server-issued, single-use); (2) exact origin match; (3) RP ID hash match; (4) UV flag (per policy); (5) credential ID uniqueness; (6) store public key, signature counter, AAGUID, and BE/BS flags.

```typescript
// ✅ Registration verification (@simplewebauthn/server)
import { verifyRegistrationResponse } from '@simplewebauthn/server';

const verification = await verifyRegistrationResponse({
  response,                                  // attestation response from the client
  expectedChallenge: storedChallenge,        // server-issued single-use challenge
  expectedOrigin: ['https://example.com'],   // exact-match allowed origins
  expectedRPID: 'example.com',               // registrable domain
  requireUserVerification: true,             // required for a primary factor
});

if (!verification.verified) throw new Error('Registration verification failed');

const { credential, credentialDeviceType, credentialBackedUp, aaguid } =
  verification.registrationInfo;
// Store credential.id / credential.publicKey / credential.counter
// Use credentialBackedUp (BS) and credentialDeviceType to distinguish synced/device-bound and store it
```

### 4.2. Authentication (Assertion) Verification

-   **Mandatory checks (MUST)**: (1) challenge match; (2) exact origin match; (3) RP ID hash match; (4) UV flag; (5) signature verification (with the stored public key); (6) **monotonic increase of the signature counter** (clone detection; authenticators returning 0 are treated as exceptions).

```typescript
// ✅ Authentication verification
import { verifyAuthenticationResponse } from '@simplewebauthn/server';

const verification = await verifyAuthenticationResponse({
  response,
  expectedChallenge: storedChallenge,
  expectedOrigin: ['https://example.com'],
  expectedRPID: 'example.com',
  credential: {                              // registered credential fetched from DB
    id: stored.id,
    publicKey: stored.publicKey,
    counter: stored.counter,
  },
  requireUserVerification: true,
});

if (!verification.verified) throw new Error('Authentication failed');
// Update counter from verification.authenticationInfo.newCounter
// If newCounter <= stored.counter, treat as a suspected clone and investigate
```

### 4.3. Client Implementation (navigator.credentials)

```typescript
// ✅ Registration (client)
const cred = await navigator.credentials.create({
  publicKey: {
    challenge,                               // server-issued random value
    rp: { id: 'example.com', name: 'Example' },
    user: { id: userIdBytes, name: email, displayName },
    pubKeyCredParams: [{ alg: -7, type: 'public-key' },  // ES256
                       { alg: -257, type: 'public-key' }], // RS256
    authenticatorSelection: {
      residentKey: 'required',               // discoverable credential
      userVerification: 'required',
    },
    attestation: 'none',
  },
});

// ✅ Authentication (Conditional UI / autofill)
const assertion = await navigator.credentials.get({
  mediation: 'conditional',                  // present as autofill candidates
  publicKey: { challenge, rpId: 'example.com', userVerification: 'required' },
});
```

---

## §5. MFA / 2FA Strategy

### 5.1. MFA Method Strength Hierarchy

-   Follow the hierarchy in §2.1. **Prioritize phishing-resistant MFA (passkeys/hardware keys)**; treat TOTP and push as transitional second factors, and SMS as a last resort.
-   **Rule 64.5.1**: Enforce MFA for admin/privileged accounts **without exception** (MUST; consistent with 000 §4.2). Require Device-Bound passkeys/hardware keys wherever possible.

### 5.2. TOTP (RFC 6238)

-   **Rule 64.5.2 (TOTP Implementation)**: Implement TOTP per RFC 6238. Use a **30-second time step**, **6+ digits**, and HMAC-SHA1 (compatibility) or SHA-256. To tolerate clock drift, allow a window of **±1 step** at verification (overly wide windows are prohibited).
-   **Rule 64.5.3 (Replay Prevention)**: A once-used OTP code MUST NOT be reusable within the same time step (record the last successful step and reject any step at or below it).
-   Encrypt the shared secret (seed) at rest, and provision via the `otpauth://` URI for QR. Never leave the secret in logs or URL queries.

```typescript
// ✅ TOTP verification (otplib) — with replay prevention
import { authenticator } from 'otplib';
authenticator.options = { window: 1, step: 30, digits: 6 };

function verifyTotp(token: string, secret: string, lastUsedStep: number) {
  const isValid = authenticator.verify({ token, secret });
  if (!isValid) return { ok: false };
  const currentStep = Math.floor(Date.now() / 1000 / 30);
  if (currentStep <= lastUsedStep) return { ok: false }; // reject replay
  return { ok: true, usedStep: currentStep };
}
```

### 5.3. Push Notification + Number Matching

-   **Rule 64.5.4**: Push-approval MFA MUST require **Number Matching**. Simple approve/deny-only push is vulnerable to MFA Fatigue (push bombing).
-   Display **context information** (requesting app, geolocation, IP) in the push. If a burst of push requests is detected within a short window, auto-suspend and notify the user (interoperates with 000 §3.3 ITDR).

### 5.4. Hardware Security Keys

-   **Rule 64.5.5**: For high-assurance use (admin, finance, sensitive data), adopt FIDO2 hardware keys (YubiKey, etc.). Where possible, **register two or more keys** to secure self-recovery if one is lost (backup key).
-   Hardware keys are Device-Bound and phishing-resistant rank S (§2.1). Enable CTAP2.1 UV via PIN/biometric.

### 5.5. SMS / Voice OTP: Deprecation & Limited Acceptance

-   **Law**: SMS/voice OTP can be intercepted via **SIM-swap attacks, SS7 protocol weaknesses, and device interception**, so treat them as the **weakest, non-phishing-resistant factor** (a restricted authenticator even in NIST SP 800-63B).
-   **Rule 64.5.6 (Limited Acceptance Conditions)**: SMS OTP is acceptable only if it meets **all** of the following; otherwise it must not be used (MUST NOT by default):
    1.  It is a **last-resort fallback** for users who cannot use any other phishing-resistant factor.
    2.  It is **not the sole second factor** for high-risk operations (payment, privilege change, deletion).
    3.  It is combined with SIM-swap detection (carrier integration / recent-SIM-change flag) and anomaly detection.
    4.  Users are continuously prompted to migrate to a stronger method (passkey/TOTP).
-   **Anti-Pattern**: Newly implementing SMS OTP as the default second factor / explaining SMS as "safe because it's two-factor."

### 5.6. Backup Codes

-   **Rule 64.5.7**: Backup codes are **single-use**. Store them hashed (same as passwords — Argon2id/bcrypt; plaintext storage prohibited). Display all at generation, and expire each code after use.
-   Recommended: 8–10 codes, each 10+ characters. Prompt regeneration when few remain. Backup codes are not phishing-resistant, so keep them as one recovery option, not the only one.

---

## §6. Password Policy (NIST SP 800-63B / 800-63-4)

> **Reference Standards**: NIST SP 800-63B / SP 800-63-4 (latest)

-   **Law**: Where passwords are used, comply with NIST SP 800-63B / 800-63-4. The requirements are "length-focused, complexity requirements abolished, breach check, periodic change abolished."

| Item | Requirement |
|:-----|:------------|
| **Minimum length** | 8+ characters (admin: 12+). **Allow a maximum of at least 64 characters** |
| **Character-class enforcement** | **None** (complexity rules such as required uppercase/symbols are abolished) |
| **Allowed characters** | Allow all Unicode, spaces, emoji. Do not block paste |
| **Breached-password check** | Check against known-breached passwords (Have I Been Pwned k-Anonymity API, etc.) at set/change time and reject on hit (MUST) |
| **Forced periodic change** | **None**. Require change only when there is evidence of compromise |
| **Hints / security questions** | **Prohibited** (no password hints, no knowledge-based security questions) |
| **Strength feedback** | Provide a real-time strength meter (zxcvbn, etc.) |
| **Hashing** | **Argon2id (recommended)** or bcrypt(cost≥12)/scrypt. Storing with SHA-256/MD5 alone is **absolutely prohibited** |

-   **Rule 64.6.1**: Perform password comparison with **constant-time comparison**, and do not let response time or messages reveal whether a username exists (consistent with 000 §6.6).
-   **Cross-Reference**: `security/000_security_privacy.md` §4.9 (Password Policy), §16 (Encryption)

---

## §7. Passwordless Strategy & Migration Roadmap

-   **Law**: Position passkeys as the strategic direction for passwordless, and migrate in stages (expansion of 000 §5.1/§5.3).

| Phase | Action | Exit Criteria |
|:-----|:-------|:--------------|
| **Phase 1: Coexist** | Offer passkey registration opt-in. Password + optional passkey | Registration flow established; measurement started |
| **Phase 2: Recommend** | Actively prompt passkey registration after login. Provide Conditional UI | Passkey adoption 30%+ |
| **Phase 3: Prioritize** | Make passkey the default auth method; password as fallback | Adoption 70%+; password-login ratio continuously declining |
| **Phase 4: Passwordless** | New users: passkey only. Existing users: option to retire passwords | Sufficient migration of password-dependent users |

-   **Rule 64.7.1**: In each passwordless phase, **align recovery-path strength with the primary path**. Strengthening passkeys but leaving the reset path weak means overall strength is rate-limited by the reset path (see §9).

---

## §8. Credential Lifecycle

-   **Rule 64.8.1 (Enrollment)**: Treat credential enrollment itself as a protected operation. Add a new passkey/MFA factor on top of a valid existing session plus, where possible, Step-Up authentication, and **notify** the user upon completion (interoperates with 000 §6.2 / 420).
-   **Rule 64.8.1b (Registration-time bot / fraud defense)**: Especially in CIAM (§1.3) self sign-up, deter mass account creation, fake accounts, and registration-time fraud.
    1.  **Client signals MUST be verified server-side (MUST)**: Device/app integrity signals (Android **Play Integrity**, Apple **App Attest**, web **Cloudflare Turnstile** / reCAPTCHA, etc.) are trusted only after the token is **verified server-side against the issuer**. Never trust the pass/fail or attributes the client returns as-is (tamperable/replayable).
    2.  These are **auxiliary signals** and must not be a sole authentication factor (same as the fingerprint principle in 420 §9). Integrate them as input to a risk score (→`420` §8).
    3.  Apply rate limiting and enumeration prevention to the registration (send) endpoint (§9.6). If SMS is involved, also mind Toll Fraud (§10.2).
    4.  Do not hard-block on integrity-check failure; degrade to risk-based graduated friction (additional verification) to avoid false-positive drop-off of legitimate users.
-   **Rule 64.8.2 (Multiple Credential Management)**: Provide a management UI where users can register, name, list, and delete multiple passkeys/factors. Show "last used time, device type, synced/device-bound" for each credential.
-   **Rule 64.8.3 (Revocation)**: On credential deletion, invalidate server-side immediately and notify the authenticator side via the Signal API (§3.10). Record the revocation event in the audit log and notify the user.
-   **Rule 64.8.4 (Rotation)**: Provide a path to regenerate shared secrets (TOTP seed, backup codes) and signing keys upon suspected compromise. **Prevent lockout** caused by deleting the last factor (only allow deletion after confirming an alternative factor exists).
-   **Rule 64.8.5 (Guarantee At Least One Factor)**: Guarantee that an account always retains at least one valid authentication method, structurally preventing orphaning (lockout).

---

## §9. Account Recovery Design (Weakest-Link Defense)

> **Law**: Recovery is the **weakest link** of an authentication system. No matter how strong primary authentication is, attackers will target weak recovery. Design recovery paths to **equal strength** with the primary path (MUST).

-   **Rule 64.9.1 (No Security Questions)**: Knowledge-based security questions (mother's maiden name, birthplace, etc.) MUST NOT be used for recovery. They are defeated by public information, guessing, and social engineering.
-   **Rule 64.9.2 (Multi-Path & Staged)**: Combine multiple independent factors for recovery (e.g., registered email + existing device confirmation + identity verification). Avoid designs where a single path (email alone) fully restores access.
-   **Rule 64.9.3 (Delay & Notification)**: For high-risk recovery (restoring from loss of all factors), impose a **waiting period (cooldown)**, and **notify** all registered channels during it. Create a window for legitimate users to cancel a fraudulent recovery.
-   **Rule 64.9.4 (No MFA Bypass)**: A recovery flow MUST NOT become a backdoor that effectively disables MFA/passkeys. A design where a mere password reset removes MFA is prohibited. Require re-enrollment of necessary factors after recovery.
-   **Rule 64.9.5 (Preserve Phishing Resistance)**: Recommended recovery means are recovery codes (offline storage) plus backup passkeys/hardware keys (multiple registered). Keep SMS/email links supplementary, and combine with proximity/possession proof where possible.
-   **Rule 64.9.6 (Rate-Limit & Anti-Enumeration)**: Rate-limit the recovery-initiation endpoint and return a uniform message that does not leak whether an account exists.
-   **Cross-Reference**: `security/000_security_privacy.md` §5.4 (Account Recovery), §6.6 (Brute Force)

---

## §10. Cross-Cutting Perspectives

### 10.1. Observability

-   **Rule 64.10.1**: Record authentication events (success/failure/MFA challenge/factor enrollment/revocation/recovery) as **structured logs**. Mask PII and retain `userId`, factor type, result, risk score, and IP/UA (consistent with 000 §7.4).
-   **Metrics**: Continuously measure login success rate, MFA completion rate, passkey adoption rate, recovery incidence, and the distribution of auth failures. Feed anomalies (mass failures from one IP, Impossible Travel) into ITDR (000 §3.3).

### 10.2. FinOps

-   **Rule 64.10.2**: IDaaS is often billed per MAU, MFA, or SMS send. **SMS OTP is billed per message**, and attacker abuse of OTP sends (SMS Pumping / Toll Fraud) can spike costs. Replacing SMS with passkeys/TOTP improves both security and cost.
-   Apply rate-limiting, per-country filtering, and anomaly detection to SMS sends to prevent Toll Fraud.

### 10.3. Performance & Scalability

-   **Rule 64.10.3**: Authentication latency directly affects UX. WebAuthn signature verification and Argon2id verification carry server load, so tune Argon2id parameters (memory/iterations) to the balance point between security and latency targets, and validate via load testing.
-   Design challenge/session state for stateless verification (e.g., signed short-lived tokens) so horizontal scaling is not hindered.

### 10.4. Zero Trust Integration

-   **Rule 64.10.4**: Propagate the authentication result (factor type, phishing-resistance, UV, device type) downstream as a **signal for authorization and continuous verification**. Reflect it in the Zero Trust risk score — e.g., allow high-risk operations only when authenticated with a phishing-resistant factor (interoperates with 000 §2, §6.2).

### 10.5. Accessibility (a11y)

-   **Rule 64.10.5**: Make the passkey UX completable via keyboard and screen reader. Avoid technical terms (WebAuthn/FIDO2) and use plain phrasing such as "log in with fingerprint, face, or your device" (consistent with 000 §5.6). Always provide PIN/hardware key/alternative factors for users who cannot use biometrics; do not depend on a specific modality.

### 10.6. Privacy

-   **Rule 64.10.6**: Biometric data (fingerprint/face templates) **stays within the device and is never sent to or stored on the server** (MUST). The RP handles only public keys and metadata.
-   **Rule 64.10.7**: Because attestation can identify model/individual, keep it to the minimum necessary (default `none`) (§3.4). `enterprise` attestation has significant privacy impact; limit it to managed devices.

---

## §11. Responsibility Boundaries (IDaaS Premise; RP/IdP Division)

-   **Law**: Assume the authentication foundation uses an IDaaS (Firebase Authentication, Auth0, Amazon Cognito, Clerk, WorkOS, Supabase Auth, etc.), and **prohibit building an in-house auth foundation** (64.1.2 / 000 §4.3).

| Responsibility | RP (your app) side | IdP / IDaaS side |
|:---------------|:-------------------|:-----------------|
| Credential storage / hashing | — | Owns (password hashes, passkey public-key storage) |
| WebAuthn server verification | In-house only if IDaaS lacks it (use maintained lib) | Often provided by IDaaS |
| MFA factor enrollment / verification | Policy definition / request | Verification logic |
| Session/token issuance | Verification / revocation integration | Issuance / signing |
| Risk detection / ITDR | Consume signals / add defenses | Detection / scoring |
| Authorization (RBAC/ABAC) | **Owns** (business logic) | — |
| Recovery policy | **Design / policy definition** | Provide execution means |

-   **Rule 64.11.1**: Even when using an IDaaS, **origin/RP ID verification, UV policy, recovery design, SMS limitation, and audit logging** remain the RP's responsibility to explicitly configure and verify. Do not blindly accept IDaaS defaults; conform them to this file's MUST requirements.
-   **Rule 64.11.2**: To prepare for IDaaS vendor lock-in, evaluate the portability (export means) of user identifiers and credential metadata in advance.

---

## §12. Anti-Patterns

| # | Anti-Pattern | Correct Response |
|:--|:-------------|:-----------------|
| 1 | Making SMS OTP the sole second factor for high-risk operations | Combine a phishing-resistant factor or at least TOTP (§5.5) |
| 2 | Displaying "password + SMS" as "strong authentication" | Neither is phishing-resistant; align wording with reality (§2.1) |
| 3 | Setting RP ID to a full origin or port-suffixed string | Use a registrable domain as RP ID (§3.3) |
| 4 | Not verifying origin by exact match in server verification | Verify against an exact-match allowlist (§4) |
| 5 | Reusing / not expiring the challenge | Server-issued, single-use challenge (§4) |
| 6 | Not verifying the signature counter | Verify monotonic increase to detect clones (§4.2) |
| 7 | Requesting `direct`/`enterprise` attestation unnecessarily | Default `none`; escalate only with clear justification (§3.4) |
| 8 | Using `discouraged` UV for a primary-factor passkey | Primary factor uses `required` (§3.5) |
| 9 | Using security questions for recovery | Knowledge-based questions prohibited (§9.1) |
| 10 | Allowing MFA removal via password reset alone | Design so recovery is not an MFA bypass (§9.4) |
| 11 | Sending / storing biometric templates on the server | Keep biometrics on the device (§10.6) |
| 12 | Enforcing complexity rules / periodic change on passwords | NIST-compliant: length-focused; abolish complexity/periodic change (§6) |
| 13 | Not checking against breached passwords | Reject known breaches via HIBP, etc. (§6) |
| 14 | Storing passwords with SHA-256/MD5 | Argon2id/bcrypt(cost≥12) (§6) |
| 15 | Not using Number Matching for push approval | Require Number Matching (§5.3) |
| 16 | Overly wide TOTP verification window / allowing replay | ±1 step; reject used steps (§5.2) |
| 17 | Storing backup codes in plaintext, unexpiring, unlimited use | Hash-store, single-use, manage remaining count (§5.6) |
| 18 | Letting the last factor be deleted, locking the user out | Guarantee at least one factor and prevent deletion (§8.5) |
| 19 | Strong passkeys but a weak reset path that limits overall strength | Align recovery strength with the primary path (§7.1, §9) |
| 20 | Building WebAuthn server verification from scratch | Use a maintained library / IDaaS (§1.2, §11) |
| 21 | Building a custom QR flow for CDA that skips BLE proximity | Defer to the standard flow (§3.8) |
| 22 | Allowing admin authentication with synced passkeys only | Admins must use Device-Bound (§3.2) |
| 23 | Not policy-fying synced/device-bound and not enforcing server-side | Enforce policy conformance server-side via BE/BS (§3.2 64.3.3b) |
| 24 | Trusting Play Integrity/App Attest/Turnstile pass/fail on the client | Verify the token server-side against the issuer (§8.1b) |
| 25 | Making an integrity/bot signal a sole authentication factor | Limit to an auxiliary signal; integrate into a risk score (§8.1b) |
| 26 | Reusing the same design for CIAM and Workforce IAM | Diverge design by use class (§1.3) |

---

## §13. Maturity Model L1–L5

| Level | State | Characteristics |
|:-----|:------|:----------------|
| **L1: Initial** | Password only. No MFA, or SMS only | Enforces complexity/periodic change. Security questions for recovery. Most vulnerable |
| **L2: Managed** | IDaaS adopted. TOTP/app MFA offered optionally | NIST-compliant passwords (breach check). MFA enforced for admins |
| **L3: Defined** | Passkey registration offered. Number Matching push | MFA for all users. SMS demoted to last-resort fallback. Audit logging in place |
| **L4: Phishing-Resistant** | Passkeys as primary factor. Admins require Device-Bound | Recovery is phishing-resistant, multi-path, delayed-with-notification. ITDR integrated |
| **L5: Passwordless** | Reached passwordless (passkey only) | Credential sync via Signal API. Auth signals integrated into Zero Trust. SMS fully retired |

-   **Rule 64.13.1**: Assess your current state and target **L3 as a minimum**. Services handling high-risk/privileged operations should target L4 or above.

---

## Appendix A: Quick Reference Index

> Quick reference index for partial loading of this file by AI.

| Keyword | Section |
|:--------|:--------|
| Passkey / WebAuthn / FIDO2 / CTAP2 | §3 |
| Synced vs Device-Bound / backupEligible / BE/BS flags / selection policy | §3.2 |
| Passkey provider trust model / sync provider / AAGUID | §3.12 |
| CXP / CXF / credential portability / provider migration | §3.13 |
| CIAM / Workforce IAM / design divergence / recovery / audit retention | §1.3 |
| Registration-time fraud / bot defense / Play Integrity / App Attest / Turnstile | §8.1b |
| RP ID / origin verification / exact-match origin | §3.3, §4 |
| Attestation / none / direct / enterprise / AAGUID / MDS | §3.4 |
| User Verification / UV / userVerification | §3.5 |
| Discoverable Credential / Resident Key / Usernameless | §3.6 |
| Conditional UI / Conditional Mediation / autocomplete webauthn / autofill | §3.7 |
| Cross-Device Authentication / CDA / hybrid / QR / BLE proximity | §3.8 |
| Related Origin Requests / .well-known/webauthn / multi-domain | §3.9 |
| Signal API / ghost passkey / credential sync | §3.10 |
| WebAuthn Level 2 / Level 3 / getClientCapabilities | §3.11 |
| WebAuthn server verification / @simplewebauthn / signature counter | §4 |
| navigator.credentials.create / get | §4.3 |
| MFA / 2FA / strength hierarchy / phishing-resistant MFA | §2, §5 |
| TOTP / RFC 6238 / otplib / replay prevention | §5.2 |
| Push notification / Number Matching / MFA Fatigue | §5.3 |
| Hardware key / YubiKey / FIDO2 / backup key | §5.4 |
| SMS OTP / voice OTP / SIM swap / SS7 / limited acceptance | §5.5 |
| Backup codes / recovery codes | §5.6, §9.5 |
| Password policy / NIST SP 800-63B / 800-63-4 / HIBP / Argon2id | §6 |
| Passwordless / migration roadmap / Phase | §7 |
| Credential lifecycle / enrollment / revocation / rotation | §8 |
| Account recovery / weakest link / no security questions / no MFA bypass | §9 |
| Authentication event logs / metrics / anomaly detection | §10.1 |
| FinOps / IDaaS billing / SMS Pumping / Toll Fraud | §10.2 |
| Authentication latency / Argon2id parameters / scalability | §10.3 |
| Zero Trust auth signal / continuous verification | §10.4 |
| Accessibility / passkey a11y | §10.5 |
| Biometric data / on-device / no server transmission | §10.6 |
| IDaaS / responsibility boundary / RP / IdP / no in-house auth | §11 |
| Anti-patterns | §12 |
| Maturity model / L1-L5 | §13 |

---

**Cross-Reference (Related Rules):**
-   `security/000_security_privacy.md` — §4 Authentication & Authorization, §5 Passkeys, §6 Session Management (upper-level policy / summary for this file)
-   `security/410_federated_identity_and_oauth.md` — OAuth 2.1 / OIDC / SAML federation, social login
-   `security/420_step_up_auth_and_sensitive_operations.md` — Step-Up authentication, re-authentication for sensitive operations, tiered protection
-   `security/100_data_governance.md` — Consent management, biometric data regulation, children's data protection
-   `engineering/500_firebase_gcp.md` — Firebase Authentication implementation, Identity Platform
-   `engineering/300_web_frontend.md` — Frontend authentication UX, client-side security
-   `operations/000_internal_tools.md` — SSO for internal tools, admin authentication, privileged access

### Cross-References

| Section | Related Rules |
|---------|---------------|
| §2–§5 (Credential strength & MFA) | `security/000_security_privacy` (§4, §5) |
| §3–§4 (Passkey/WebAuthn implementation) | `engineering/500_firebase_gcp`, `engineering/300_web_frontend` |
| §6 (Password policy) | `security/000_security_privacy` (§4.9, §16) |
| §9 (Recovery) | `security/000_security_privacy` (§5.4, §6.6) |
| §10–§11 (Cross-cutting & responsibility) | `operations/000_internal_tools`, `security/100_data_governance` |
