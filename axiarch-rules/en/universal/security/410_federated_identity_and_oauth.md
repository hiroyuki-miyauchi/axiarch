# 65. Federated Identity & OAuth/OIDC

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-06-09

> [!IMPORTANT]
> **Primary Directive**
> "Delegating external identity is delegating trust — design as if tokens will be stolen."
> Implementations of federated identity, OAuth, OIDC, social login, and enterprise SSO must
> conform to the current stable best practices in this file.
> **New adoption of Deprecated patterns (Implicit Flow / ROPC / third-party-cookie dependence) is prohibited.**
> Authentication and authorization follow the priority order in `000_security_privacy.md` §1 (Legal & Security > UX > Revenue > DX).

> [!NOTE]
> This file is the **deep-dive** of `000_security_privacy.md` §3.5 (ID Federation & SSO), §4.4 (Social Login), and §4.10 (OAuth 2.1 & DPoP).
> Refer to 000 for the summary and to this file for implementation detail. Step-Up (re-authentication) is split into `420_step_up_auth_and_sensitive_operations.md`.

---

## Table of Contents

| § | Section |
|---|---|
| 1 | [Responsibility Boundaries & Architecture Basics](#1-responsibility-boundaries--architecture-basics) |
| 2 | [OAuth 2.1 Core Protocol](#2-oauth-21-core-protocol) |
| 3 | [PKCE / state / nonce](#3-pkce--state--nonce) |
| 4 | [OIDC (OpenID Connect)](#4-oidc-openid-connect) |
| 5 | [ID Token Validation](#5-id-token-validation) |
| 6 | [JWKS, Signing Keys, Rotation](#6-jwks-signing-keys-rotation) |
| 7 | [Social Login (Google / Apple / Microsoft / GitHub)](#7-social-login-google--apple--microsoft--github) |
| 8 | [Account Linking & Takeover Prevention](#8-account-linking--takeover-prevention) |
| 9 | [Enterprise SSO (SAML 2.0 / OIDC)](#9-enterprise-sso-saml-20--oidc) |
| 10 | [JIT Provisioning & SCIM](#10-jit-provisioning--scim) |
| 11 | [Token Management, Expiration, Revocation](#11-token-management-expiration-revocation) |
| 12 | [Refresh Token Rotation & Reuse Detection](#12-refresh-token-rotation--reuse-detection) |
| 13 | [Sender-Constrained Tokens (DPoP / mTLS)](#13-sender-constrained-tokens-dpop--mtls) |
| 14 | [Token Storage & BFF Pattern (SPA/Mobile)](#14-token-storage--bff-pattern-spamobile) |
| 15 | [Advanced Protocols (PAR / RAR / JAR / JARM / Token Exchange)](#15-advanced-protocols-par--rar--jar--jarm--token-exchange) |
| 16 | [FedCM (Third-Party Cookie Deprecation)](#16-fedcm-third-party-cookie-deprecation) |
| 17 | [Logout & Session Synchronization](#17-logout--session-synchronization) |
| 18 | [Verifiable Credentials / SD-JWT / OID4VCI (Future Trends)](#18-verifiable-credentials--sd-jwt--oid4vci-future-trends) |
| 19 | [Observability, FinOps, Performance, Zero Trust, Privacy](#19-observability-finops-performance-zero-trust-privacy) |
| 20 | [Implementation Snippets](#20-implementation-snippets) |
| 21 | [Anti-Patterns](#21-anti-patterns) |
| 22 | [Maturity Model L1–L5](#22-maturity-model-l1l5) |
| A | [Appendix A: Reverse Index](#appendix-a-reverse-index) |
| B | [Appendix B: Cross-References](#appendix-b-cross-references) |

---

## §1. Responsibility Boundaries & Architecture Basics

> **Reference**: OAuth 2.1 (draft-ietf-oauth-v2-1), OpenID Connect Core 1.0, RFC 6749, RFC 9700 (OAuth Security BCP)

### 1.1. Role Definitions & Responsibility Boundaries

-   **Rule 65.1.1**: Document the scope of responsibility for each role in a federated identity setup at design time. Do not implement with ambiguous boundaries.

| Role | Responsibility | Examples |
|:------|:---------------|:---------|
| **Resource Owner** | Authorizes access to a resource | End user |
| **Client (RP: Relying Party)** | Requests and uses tokens | Your web/mobile app |
| **Authorization Server (AS)** | Authentication, consent, token issuance | Google / Auth0 / Cognito / Keycloak |
| **Resource Server (RS)** | Validates access tokens and serves the API | Your API backend |
| **Identity Provider (IdP)** | Authenticates users and provides identity | Google / Apple / Entra ID / Okta |

-   **Rule 65.1.2**: When AS and RS are logically separated, the RS **must validate the audience (`aud`)** to confirm the token is meant for it (§5.2).
-   **Rule 65.1.3**: Apply Defense in Depth so that compromise of any one of IdP/AS/RS is contained (`000_security_privacy.md` §1.3).

### 1.2. Client Types

-   **Confidential Client**: A server-side app that can hold a `client_secret` securely.
-   **Public Client**: SPA/mobile/desktop that cannot keep a secret. **PKCE is mandatory** (§3).
-   **Rule 65.2.1**: Never bundle a `client_secret` into a Public Client (it is extractable from binaries/JS bundles and thus meaningless).
-   **Rule 65.2.2**: Treat SPAs as Public Clients, but where possible turn them into Confidential Clients via the **BFF pattern** (§14).

### 1.3. Application Policy

-   **Law**: Building your own OAuth/OIDC provider is prohibited. Use a vetted IDaaS / AS (`000_security_privacy.md` §4.3). The focus of this file is correct RP (client)-side implementation.
-   **Law**: New implementations default to **OAuth 2.1 + OIDC + PKCE**. The weak flows OAuth 2.0 permitted (§2.2) are not adopted.

---

## §2. OAuth 2.1 Core Protocol

> **Reference**: OAuth 2.1 (draft-ietf-oauth-v2-1), RFC 9700 (Security BCP), RFC 6749

### 2.1. Authorization Code Flow + PKCE (the only standard flow)

-   **Law**: Use only **Authorization Code Flow + PKCE** for user authorization via browser/mobile.
-   **Flow Overview**:
    1.  The client generates a `code_verifier` and computes `code_challenge = BASE64URL(SHA256(code_verifier))`.
    2.  Redirect to `/authorize` with `response_type=code`, `code_challenge`, `code_challenge_method=S256`, `state`, `scope`, `redirect_uri`.
    3.  After authentication/consent, the AS returns `code` to the `redirect_uri`.
    4.  The client sends `code` + `code_verifier` (+ `client_secret` if Confidential) to `/token` over the back channel.
    5.  The AS validates the `code_verifier` and issues tokens.

### 2.2. Prohibited / Deprecated Flows

| Flow | OAuth 2.0 | This File's Policy | Reason |
|:------|:---------|:-------------------|:-------|
| **Implicit Flow** (`response_type=token`) | Allowed | 🔴 **Prohibited** | Access token exposed in URL fragment; logs/history/referrer leakage |
| **Resource Owner Password Credentials (ROPC)** | Allowed | 🔴 **Prohibited** | Client handles user credentials directly; encourages phishing, no MFA |
| **Hybrid Flow** (`code token`, `code id_token token`) | Allowed | ⚠️ **Discouraged** | Not allowed when it exposes an access token on the front channel. `code id_token` is narrowly allowed with OIDC `response_mode=fragment` (§4.6) |
| **Authorization Code (without PKCE)** | Recommended | 🔴 **Prohibited** | Vulnerable to authorization code interception |
| **Device Authorization Grant** (RFC 8628) | Allowed | ✅ Allowed | Only for input-constrained devices (TV/CLI) |
| **Client Credentials Grant** | Allowed | ✅ Allowed | M2M (no user) communication only; never for user authentication |

### 2.3. Exact-Match Redirect URI

-   **Law**: Allow `redirect_uri` only by **exact match** against the value pre-registered at the AS. Prohibit wildcards, partial matches, and path-only matches.
-   **Action**:
    1.  Specify a full absolute URL (scheme + host + port + path) at AS registration.
    2.  Eliminate designs that forward tokens externally via **Open Redirect** like `https://app.example.com/callback?next=...`. Validate return-target parameters such as `next` against an allowlist.
    3.  Prefer **Universal Links / App Links** over custom schemes (`com.example.app:/callback`) on mobile (interception prevention).

### 2.4. Scope Minimization

-   **Law**: Limit requested `scope` to the minimum needed for the function (`000_security_privacy.md` §7.2 Data Minimization).
-   **Action**: Start from `openid`, `email`, `profile`, etc., and obtain additional permissions via **Incremental Authorization** (request them when actually needed).

---

## §3. PKCE / state / nonce

### 3.1. PKCE (Proof Key for Code Exchange — RFC 7636)

-   **Law**: PKCE is mandatory for all client types (including Confidential). Allow only **`S256`** for `code_challenge_method`; prohibit `plain`.
-   **Action**:
    1.  `code_verifier` is a high-entropy random string of 43–128 chars (`[A-Za-z0-9-._~]`).
    2.  Store `code_verifier` safely and temporarily on the client (for SPAs, in the BFF session rather than `sessionStorage`, §14).
    3.  The AS verifies the hash match of `code_verifier` at `/token`.

### 3.2. state (CSRF Prevention)

-   **Law**: Attach a cryptographically random `state` to the `/authorize` request and verify the match at the callback. Prevents CSRF (authorization code injection).
-   **Action**: Bind and store `state` in the session. Reject if the callback `state` does not match. If you embed app state such as a return URL, use a signed/encrypted value or an opaque value + server-side mapping.

### 3.3. nonce (ID Token Replay Prevention — OIDC)

-   **Law**: Attach a `nonce` to the OIDC authentication request and verify it matches the `nonce` claim of the ID Token (§5.1).
-   **Action**: `nonce` is a random value independent of `state`, bound to the session. Always cross-check it during ID Token validation.

> [!CAUTION]
> `state` (CSRF) and `nonce` (ID Token replay) **serve different roles**. Omitting either is not allowed. Validate both independently.

---

## §4. OIDC (OpenID Connect)

> **Reference**: OpenID Connect Core 1.0, OIDC Discovery 1.0, OpenID Connect for Identity Assurance

### 4.1. Discovery (`.well-known/openid-configuration`)

-   **Action**: Retrieve the AS configuration (`authorization_endpoint`, `token_endpoint`, `jwks_uri`, `issuer`, supported scopes/signing algorithms) from the Discovery endpoint and avoid hard-coding. Cache the response (§6.3) and verify that the `issuer` matches the request domain.

### 4.2. Scopes and Claims

-   **Standard scopes**: `openid` (required), `profile`, `email`, `address`, `phone`, `offline_access` (request a refresh token).
-   **Action**:
    1.  Decide whether claims come from the UserInfo endpoint or the ID Token, and avoid retrieving both.
    2.  Least privilege: do not request `address`/`phone` if only a display name is needed.
    3.  The OIDC `claims` parameter allows precise per-claim requests.

### 4.3. UserInfo Endpoint

-   **Action**: UserInfo is protected by the access token. Always verify that the response `sub` matches the ID Token `sub` (token substitution prevention).

### 4.4. prompt / max_age (Re-Auth & Consent Control)

-   `prompt=none`: silent authentication (check existing session). Returns `login_required`, etc., on failure.
-   `prompt=login`: forced re-authentication.
-   `prompt=consent`: re-display the consent screen.
-   `max_age`: maximum seconds elapsed since the last authentication; require re-auth when exceeded. See §420 for Step-Up use.

### 4.5. Handling the User Identifier

-   **Law**: Treat the unique user identifier as the **combination of `iss` + `sub`**. Do not use `email` as the primary key (email is mutable, reusable, and spoofable).
-   **Action**: Store `(provider_iss, provider_sub)` as a unique constraint in the DB. Trust `email` only as an auxiliary attribute and only when `email_verified=true` (§8.2).

### 4.6. Handling the Hybrid Flow

-   **Law**: New adoption of the Hybrid Flow is discouraged in principle. Prohibit any `response_type` that exposes an access token on the front channel.
-   **Narrow allowance**: `response_type=code id_token` (receiving only the ID Token on the front channel; tokens exchanged on the back channel) is narrowly allowed only with mandatory `c_hash` validation. New designs should prefer plain Authorization Code + PKCE.

---

## §5. ID Token Validation

> **Reference**: OIDC Core 1.0 §3.1.3.7, RFC 9700

### 5.1. Mandatory Validation Items

-   **Law**: Validate **all** of the following for an ID Token (JWT) before trusting it. Reject if even one item is missing or mismatched.

| Claim | Validation |
|:------|:-----------|
| **Signature** | Verify the signature with the public key fetched from `jwks_uri` (§6). Reject `alg=none` |
| **`iss`** | Exact match with the expected Issuer |
| **`aud`** | Must include the client's own `client_id`. With multiple audiences, also validate `azp` |
| **`exp`** | Within expiry (server time, allowed clock skew ≤ 60s) |
| **`iat`** | Issuance time is sane (not in the future) |
| **`nonce`** | Matches the value sent in the authentication request (§3.3) |
| **`at_hash`** | When sent with an access token, validate the consistency of `at_hash` (token substitution prevention) |
| **`azp`** | When `aud` is multiple or `azp` is present, must match the client's own `client_id` |

### 5.2. Access Token Audience Restriction

-   **Law**: The Resource Server validates that the access token's (when a JWT) `aud` (or the introduced `resource` indicator, RFC 8707) is meant for it. Prevents misuse of tokens issued for other services (Confused Deputy).

### 5.3. Algorithm Pinning

-   **Law**: The validator pins allowed signing algorithms via an allowlist (e.g., `RS256`, `ES256`). Do not dynamically select based on the token header's `alg`. Prevents `alg=none` and downgrade attacks to symmetric keys (`HS256`).

### 5.4. Delegating Signature Verification

-   **Action**: Use maintained validation libraries (`jose`, the AS's official SDK) rather than rolling your own JWT decode. Prohibit unverified use of `jwt.decode()` (§21).

---

## §6. JWKS, Signing Keys, Rotation

### 6.1. Key Retrieval via JWKS

-   **Action**: Select the signature verification key from the AS's `jwks_uri` (JWK Set) by `kid` (Key ID). Use the key matching the `kid` in the ID Token/JWT header.

### 6.2. Key Rotation Handling

-   **Law**: Implement on the assumption that the AS rotates signing keys without notice. On receiving an unknown `kid`, **re-fetch the JWKS** before validating (do not error immediately).
-   **Action**: Keep a JWKS cache and invalidate it to re-fetch on a `kid` miss. However, apply a **rate limit / minimum re-fetch interval** to avoid a DoS against the JWKS endpoint.

### 6.3. JWKS Cache (Performance)

-   **Action**: Cache JWKS for roughly 5–60 minutes while honoring HTTP `Cache-Control`. Fetching JWKS on every request is prohibited (latency, cost, availability risk). Libraries like `jose`'s `createRemoteJWKSet` build in this cache plus `kid` re-fetch.

---

## §7. Social Login (Google / Apple / Microsoft / GitHub)

> **Reference**: Each IdP's official docs, OIDC Core, FedCM (W3C)

### 7.1. Common Requirements

-   **Law**: Social login satisfies the Social Login Security Protocol in `000_security_privacy.md` §4.4 (Authorization Code + PKCE, `state`, server-side token exchange, scope minimization, explicit account linking, `iss`/`aud`/`exp` validation).
-   **Action**: **Re-validate** the ID Token / profile received from the IdP **server-side** before issuing a session. Do not trust the client's claims as-is.

### 7.2. Google (Google Identity Services)

-   **Action**:
    1.  Use **Sign in with Google** (the GIS library). Do not use the legacy Google Sign-In JavaScript (gapi.auth2), which is deprecated.
    2.  Validate the ID Token server-side: `iss` is `https://accounts.google.com` or `accounts.google.com`, `aud` is your OAuth client ID, `exp` valid. Validation via the official library (`google-auth-library`) is recommended (§20.5).
    3.  Use `sub` for the user identifier. Use `email` auxiliarily only after confirming `email_verified`.
    4.  **FedCM support**: With third-party cookie deprecation, GIS has migrated to a FedCM basis. Enable FedCM-supported mode (§16).

### 7.3. Apple (Sign in with Apple)

-   **Action**:
    1.  Validate the ID Token (`iss=https://appleid.apple.com`) against JWKS. The `client_secret` is generated dynamically as an **ES256-signed JWT** (with expiry).
    2.  **Private Email Relay**: When the user chooses to hide their email, a `@privaterelay.appleid.com` relay address is returned. Note that mail will not be delivered unless the sending domain is registered with Apple.
    3.  **Name returned only on first authorization**: `name` is included only in the first authorization response. Capture and persist it on first use; it cannot be retrieved in subsequent flows.
    4.  When an App Store app offers other social logins, Apple's guidelines may require also offering Sign in with Apple (confirm as needed).

### 7.4. Microsoft (Entra ID / Microsoft Account)

-   **Action**:
    1.  Use the Microsoft Identity Platform (v2.0 endpoint) + OIDC. The MSAL library is recommended.
    2.  **`tid` (tenant ID) validation**: In multi-tenant setups, control accepted tenants with an allowlist. When using the `common`/`organizations` endpoints, always validate `tid` to prevent impersonation of arbitrary tenants.
    3.  Use the combination of `oid` (+ `tid`) for the user identifier. `email`/`preferred_username` can change.

### 7.5. GitHub (OAuth / GitHub Apps)

-   **Action**:
    1.  GitHub is pure OAuth 2.0 (not OIDC). There is no ID Token, so retrieve user info via the `/user` API.
    2.  Because email may be unavailable depending on privacy settings, use the `user:email` scope + `/user/emails` and pick the address with `verified=true` and `primary=true`.
    3.  When fine-grained permissions are needed, use a **GitHub App** rather than an OAuth App, and use least-privilege installation tokens.
    4.  Validate the signature (`X-Hub-Signature-256`) on webhook receipt (`engineering/100_api_integration.md`).

---

## §8. Account Linking & Takeover Prevention

> **Reference**: OAuth Security BCP (RFC 9700), each IdP's account linking guidelines

### 8.1. Prohibit Automatic Linking

-   **Law**: **Do not automatically link** an external identity to an existing account solely because the email address matches (`000_security_privacy.md` §4.4 Explicit Account Link).
-   **Rationale**: If the IdP returns `email_verified=false`, or an attacker created an external account with an unverified email, automatic linking leads directly to **Account Takeover**.

### 8.2. Safe Linking Flow

-   **Action**:
    1.  **Linking within an existing session**: Allow linking only when an already-logged-in user performs a "Connect Google" action within an authenticated session.
    2.  **Prior verification mail**: For an external login matching an existing email, do not auto-link; require **proof of ownership of the existing account** (a one-time link in a confirmation email, or re-auth with existing credentials) before linking.
    3.  **Strict `email_verified`**: Do not use `email` as proof of identity unless the IdP returns `email_verified=true`.
    4.  **Unlinking**: Provide a UI to unlink, and allow unlinking the last login method only after a fallback (e.g., setting a password) is secured.

### 8.3. Cross-Provider Identity Resolution

-   **Action**: When one user has multiple IdPs (Google + Apple + email), design an identities table that associates multiple `(iss, sub)` with the internal user ID. Do not use `email` as the join key.

---

## §9. Enterprise SSO (SAML 2.0 / OIDC)

> **Reference**: SAML 2.0 (OASIS), OIDC Core, NIST SP 800-63

### 9.1. Choosing Between SAML 2.0 and OIDC

| Aspect | SAML 2.0 | OIDC |
|:-------|:---------|:-----|
| **Fit** | Legacy/enterprise IdPs (many corporate IdPs support it) | Modern/mobile/SPA/API |
| **Token** | XML Assertion | JWT (ID Token) |
| **Mobile affinity** | Low | High |
| **Recommendation** | When the customer IdP only supports SAML | The default for new / free choice |

-   **Law**: When you have a choice for a new implementation, make **OIDC the default**. Support SAML when required by customer/partner IdP constraints.

### 9.2. Mandatory SAML Validation

-   **Law**: A SP (Service Provider) receiving a SAML Assertion validates the following.
    1.  **XML signature validation**: Validate the Assertion/Response signature with the IdP certificate. To defend against **XML Signature Wrapping (XSW)**, use a maintained library that guarantees the signed element and the processed element are identical.
    2.  **`Audience` / `Recipient` / `Destination`** match this SP.
    3.  **`NotBefore` / `NotOnOrAfter`** (time window).
    4.  **`InResponseTo`** matches the request ID we sent (replay prevention).
    5.  **Assertion reuse prevention**: Record processed Assertion IDs for a period.

### 9.3. Risks of IdP-initiated SSO

-   **Law**: **IdP-initiated SSO** (an Assertion sent from the IdP without an SP request) carries high CSRF/login-injection risk, so use **SP-initiated** wherever possible.
-   **Action**: When IdP-initiated is required, combine replay prevention, short validity, and post-landing user confirmation as alternatives to the unavailable `InResponseTo` check.

### 9.4. SAML/OIDC Common

-   **Action**: Manage IdP metadata/certificates separately per tenant (customer company) to structurally prevent token mixing across tenants (`000_security_privacy.md` multi-tenant isolation). Monitor certificate rotation.

---

## §10. JIT Provisioning & SCIM

### 10.1. JIT (Just-In-Time) Provisioning

-   **Action**: When auto-creating a user record on first SSO login, **do not use the attributes (roles/groups) claimed by the IdP directly for privilege grants**. Create with least privilege and route privilege escalation through a separate approval flow.

### 10.2. SCIM (System for Cross-domain Identity Management 2.0)

-   **Law**: Auto-sync the user lifecycle (create, update, **deactivate**) of enterprise customers via SCIM 2.0. Manual deprovisioning breeds lingering ex-employee accounts (Orphaned IDs).
-   **Action**:
    1.  Protect the SCIM endpoint with a Bearer Token, scoped separately per tenant.
    2.  **Immediate deprovisioning**: On IdP-side deactivation, immediately revoke all sessions of the target user (§17, §11.4).
    3.  Record SCIM operations in the audit log (`000_security_privacy.md` §4.6).
-   **Cross-Reference**: `000_security_privacy.md` §3.5 (SCIM)

---

## §11. Token Management, Expiration, Revocation

### 11.1. Token Expiration (consistent with `000_security_privacy.md` §6.1)

| Token Type | Recommended Expiry | Admin/High-Risk |
|:-----------|:-------------------|:----------------|
| **Access Token** | ≤ 1 hour | ≤ 15 minutes |
| **Refresh Token** | 7–30 days (rotation required) | ≤ 7 days |
| **ID Token** | Short-lived (for post-auth validation; do not retain long-term) | — |
| **Authorization Code** | ≤ 60s, **single-use** | ≤ 60s |

### 11.2. Keep Access Tokens Short-Lived

-   **Law**: Keep access tokens short-lived; ensure revocation via refresh token rotation (§12) and revocation lists. Long-lived access tokens cause severe damage on leakage.

### 11.3. Introspection (RFC 7662)

-   **Action**: When using opaque access tokens, the RS confirms validity, scope, and `aud` at the Introspection endpoint. For JWTs, combine local validation (§5) with revocation checks.

### 11.4. Revocation (RFC 7009) and Revocation Propagation

-   **Law**: Revoke tokens on logout, account suspension, password change, and SCIM deactivation.
-   **Action**:
    1.  Revoke Refresh Tokens at the AS Revocation endpoint.
    2.  Minimize revocation propagation delay with short-lived access tokens + a revocation list (`jti`-based) or short cache TTL.
    3.  Consistent with `000_security_privacy.md` §6.5 (Server-Side Invalidation).

---

## §12. Refresh Token Rotation & Reuse Detection

> **Reference**: OAuth Security BCP (RFC 9700)

### 12.1. Rotation Required

-   **Law**: Refresh Token Rotation is mandatory for Public Clients (SPA/mobile/BFF). Issue a new Refresh Token on each refresh and invalidate the old one.

### 12.2. Reuse Detection

-   **Law**: If an already-used (rotated) Refresh Token is presented again, **immediately revoke the entire token family** and require re-authentication of the user. This is a signal of token theft.
-   **Action**: Assign a family ID to Refresh Tokens and track the rotation chain. On reuse detection, revoke the whole family and emit an event to ITDR (`000_security_privacy.md` §3.3).

### 12.3. Combine with Sender-Constraint

-   **Action**: For high-risk uses, make Refresh Tokens sender-constrained with DPoP/mTLS (§13) to cryptographically block reuse of stolen tokens.

---

## §13. Sender-Constrained Tokens (DPoP / mTLS)

> **Reference**: RFC 9449 (DPoP), RFC 8705 (mTLS / Certificate-Bound Access Tokens)

### 13.1. DPoP (Demonstrating Proof of Possession)

-   **Overview**: Cryptographically binds access/refresh tokens to the client's public key to prevent reuse of stolen Bearer tokens (consistent with `000_security_privacy.md` §4.10).
-   **Action**:
    1.  The client attaches a DPoP JWT signed with a key pair (`ES256`/`EdDSA` recommended) to the `DPoP` header per request.
    2.  The server validates `htm` (HTTP method), `htu` (HTTP URI), `iat`, `jti` (replay prevention), and confirms the match between the token's `cnf.jkt` (key thumbprint) and the DPoP key.
    3.  The server issues a `DPoP-Nonce` to block replay.
-   See §20.4 for the implementation snippet.

### 13.2. mTLS Certificate-Bound Access Tokens

-   **Overview**: Binds the access token to the client certificate's thumbprint (`cnf.x5t#S256`). Stronger than DPoP, certificate-based.
-   **Use**: Financial APIs (FAPI 2.0), M2M communication. Recommended where client certificates are available.

### 13.3. Selection Guidance

| Environment | Recommended Method |
|:------------|:-------------------|
| Browser SPA/mobile | DPoP (or BFF + Cookie, §14) |
| Server-to-server / financial API | mTLS (FAPI 2.0) |
| Legacy compatibility needed | Bearer (but short-lived + strict revocation) |

---

## §14. Token Storage & BFF Pattern (SPA/Mobile)

> **Reference**: OAuth 2.0 for Browser-Based Apps (BCP)

### 14.1. Avoid localStorage

-   **Law**: Never store access/refresh tokens in browser `localStorage` / `sessionStorage`. They are stealable from JS via XSS.

### 14.2. Recommend the BFF (Backend-for-Frontend) Pattern

-   **Law**: SPAs default to the **BFF pattern** as recommended. The server (BFF) holds the tokens, and the browser receives only a **session cookie** with `HttpOnly` + `Secure` + `SameSite`.
-   **Architecture**:
    1.  The BFF runs the OAuth flow (Authorization Code + PKCE) as a Confidential Client.
    2.  Tokens are stored in the BFF's server-side session store (encrypted).
    3.  Browser↔BFF uses a same-site cookie session; BFF↔API uses Bearer/DPoP.
    4.  CSRF defense (`SameSite=Lax`/`Strict` + CSRF token, `000_security_privacy.md` §10.8).

### 14.3. Pure SPA Without BFF

-   **Action**: When you must handle tokens in a pure SPA, (a) keep the access token in memory (JS variable) only and do not persist it, (b) refresh via an `HttpOnly` cookie + rotation + reuse detection, (c) minimize the XSS surface with strong CSP + Trusted Types (`engineering/300_web_frontend.md`).

### 14.4. Mobile

-   **Action**: Store tokens in OS secure storage (iOS Keychain / Android Keystore/EncryptedSharedPreferences). Use a certified OIDC library such as `AppAuth` and authorize via the system browser (ASWebAuthenticationSession / Custom Tabs). Authorization in a WebView is prohibited (credential theft / PKCE bypass risk).

---

## §15. Advanced Protocols (PAR / RAR / JAR / JARM / Token Exchange)

> **Reference**: RFC 9126 (PAR), RFC 9396 (RAR), RFC 9101 (JAR), JARM (FAPI), RFC 8693 (Token Exchange), RFC 8707 (Resource Indicators)

### 15.1. PAR (Pushed Authorization Requests — RFC 9126)

-   Pushes authorization request parameters over the back channel rather than the front channel and receives a `request_uri`. Prevents parameter tampering/leakage. Recommended for high-risk (financial/medical).

### 15.2. RAR (Rich Authorization Requests — RFC 9396)

-   Expresses fine-grained authorization (e.g., "transfers up to ¥10,000 from account X only") via `authorization_details`. Needed for Open Banking / FAPI 2.0 compliance.

### 15.3. JAR / JARM

-   **JAR (RFC 9101)**: Sends the authorization request as a signed/encrypted JWT (`request` object) to prevent tampering.
-   **JARM**: Returns the authorization response as a signed JWT to prevent response tampering/injection. Adopted in FAPI.

### 15.4. Token Exchange (RFC 8693)

-   Exchanges one token for another (different audience/permissions). Used for delegation/down-scoping between microservices. Narrow the audience/scope to avoid propagating excessive privilege.

### 15.5. Step-Up Goes to §420

-   Re-authentication for high-risk operations (Step-Up Authentication), the `acr`/`amr` claims, and transaction authorization are covered in **`420_step_up_auth_and_sensitive_operations.md`** (not handled in this file).

---

## §16. FedCM (Third-Party Cookie Deprecation)

> **Reference**: W3C Federated Credential Management (FedCM)

### 16.1. Background

-   **Law**: With browser third-party cookie deprecation/partitioning (Storage Partitioning), design on the assumption that federation relying on third-party cookies (implicit IdP session sharing, hidden iframes, silent auth) will break.

### 16.2. FedCM Support

-   **Action**:
    1.  Enable **FedCM-supported mode** in the IdP/library, such as Google Identity Services.
    2.  Replace `prompt=none` silent auth and iframe-based token refresh that rely on third-party cookies with FedCM or a redirect-based approach (BFF + Refresh Token).
    3.  When the IdP provides FedCM `accounts`/`client_metadata`/`id_assertion` endpoints, conform to the spec.
    4.  Provide a fallback (redirect flow) per browser compatibility.

### 16.3. Prohibition

-   **Law**: Prohibit new federation designs that permanently depend on third-party cookies.

---

## §17. Logout & Session Synchronization

> **Reference**: OIDC RP-Initiated Logout 1.0, OIDC Back-Channel Logout 1.0, OIDC Front-Channel Logout 1.0

### 17.1. RP-Initiated Logout

-   **Action**: On logout from the app (RP), in addition to destroying the local session, redirect to the AS `end_session_endpoint` with `id_token_hint` + `post_logout_redirect_uri` (pre-registered, exact match) to also terminate the IdP session.

### 17.2. Back-Channel Logout (Recommended)

-   **Law**: In SSO environments, implement **Back-Channel Logout**. The IdP notifies each RP of logout server-to-server (a Logout Token JWT), and the RP revokes the target session.
-   **Action**: Validate the Logout Token's `iss`/`aud`/`exp`/`events` and server-side revoke all sessions corresponding to the `sid` (session ID) or `sub` (§11.4). Prefer Back-Channel because Front-Channel Logout is unstable under third-party cookie constraints.

### 17.3. Session Sync and Global Logout

-   **Action**: Provide a "log out from all devices" feature (`000_security_privacy.md` §6.3). On SCIM deactivation / password change, revoke all sessions + Refresh Tokens.

---

## §18. Verifiable Credentials / SD-JWT / OID4VCI (Future Trends)

> **Reference**: W3C Verifiable Credentials 2.0, SD-JWT (IETF), OpenID for Verifiable Credential Issuance/Presentation (OID4VCI/OID4VP)

### 18.1. Direction

-   **Note**: Decentralized identity (DID), Verifiable Credentials, and digital wallets (e.g., the EU Digital Identity Wallet) are future trends complementing IdP-centric federation. As the standards are still solidifying, this is **not a new mandatory requirement** but should be recognized as a design extension point.

### 18.2. SD-JWT (Selective Disclosure JWT)

-   **Overview**: A JWT that allows selective disclosure of claims. Presents only the attributes the verifier needs, avoiding over-disclosure (privacy minimization). E.g., presenting only "over 18" rather than "date of birth" for age verification.

### 18.3. OID4VCI / OID4VP

-   **Overview**: Protocols extending OAuth/OIDC to issue (VCI) and present (VP) Verifiable Credentials. Use is expected to grow with wallet integration of government-issued IDs / credentials.
-   **Action**: When considering adoption, evaluate wallet security, key management, revocation (Status List), and privacy (correlation prevention).

---

## §19. Observability, FinOps, Performance, Zero Trust, Privacy

### 19.1. Observability

-   **Action**: Measure and log the following (observing PII masking, `000_security_privacy.md` §7.4).
    -   **OAuth error rate**: occurrence rate of `invalid_grant`, `invalid_client`, `access_denied`, redirect mismatch, etc.
    -   **Token issuance/refresh metrics**: issuance count, refresh success/failure, reuse-detection firings.
    -   **Validation failures**: signature verification failures, `iss`/`aud`/`nonce` mismatches, expiry.
    -   **Anomalies**: bursts of token requests from the same IP, Impossible Travel (ITDR integration).
-   Do not retain PII such as `sub`/`email` raw in logs; use a hash of the user ID / a correlation ID.

### 19.2. FinOps

-   **Action**:
    1.  **MAU billing**: Many IDaaS bill by MAU (Monthly Active Users). Monitor and suppress MAU inflation from anonymous/bot traffic.
    2.  **Token validation cost**: Introspection of opaque tokens is a round-trip cost to the AS. Reduce cost/latency with JWT local validation + JWKS caching (§6.3).
    3.  Monitor over-issuance of M2M tokens (Client Credentials) (some IDaaS bill by M2M token count).

### 19.3. Performance

-   **Action**: Suppress authorization-flow latency with JWKS caching (§6.3), local ID Token validation, and Discovery caching. Token validation is on the hot path; do not make key fetching synchronously blocking.

### 19.4. Scalability

-   **Action**: Keep sessions/revocation lists in a distributed store (e.g., Redis) for horizontal scale. Leverage stateless JWT validation while balancing consistency and scale with a hybrid of short TTL + revocation lists.

### 19.5. Zero Trust

-   **Action**: Federation is central to Identity-First Zero Trust (`000_security_privacy.md` §2.4). Token possession ≠ trust; authorize each time by `aud`/`scope`/sender-constraint/context (device, risk score).

### 19.6. Privacy & Consent

-   **Action**: Scope minimization (§2.4), explicit consent via `prompt=consent`, and avoiding over-disclosure with SD-JWT, etc. Consent UIs must not use dark patterns (`000_security_privacy.md` §9.5). Limit attributes retrieved from the IdP to in-purpose use and define a retention period.

---

## §20. Implementation Snippets

> [!NOTE]
> Snippets are minimal examples assuming current stable libraries. In production, add exception handling, timeouts, and audit logging.

### 20.1. PKCE Generation (code_verifier / code_challenge)

```typescript
// ✅ PKCE: generate code_verifier and S256 code_challenge
function base64url(buffer: ArrayBuffer): string {
  return btoa(String.fromCharCode(...new Uint8Array(buffer)))
    .replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');
}

export async function createPkcePair() {
  const verifierBytes = crypto.getRandomValues(new Uint8Array(32));
  const codeVerifier = base64url(verifierBytes.buffer); // 43 chars
  const digest = await crypto.subtle.digest('SHA-256', new TextEncoder().encode(codeVerifier));
  const codeChallenge = base64url(digest);
  return { codeVerifier, codeChallenge, method: 'S256' as const };
}
```

### 20.2. ID Token Validation (jose)

```typescript
// ✅ Validate an OIDC ID Token down to JWKS, iss, aud, nonce
import { createRemoteJWKSet, jwtVerify } from 'jose';

const JWKS = createRemoteJWKSet(new URL('https://issuer.example.com/.well-known/jwks.json')); // §6.3 built-in cache + kid re-fetch

export async function verifyIdToken(idToken: string, expectedNonce: string) {
  const { payload } = await jwtVerify(idToken, JWKS, {
    issuer: 'https://issuer.example.com',  // exact iss match
    audience: process.env.OIDC_CLIENT_ID!, // client_id in aud
    algorithms: ['RS256', 'ES256'],        // §5.3 alg allowlist
    clockTolerance: 60,                    // ≤ 60s
  });
  if (payload.nonce !== expectedNonce) throw new Error('nonce mismatch'); // §3.3
  // azp: when aud is multiple or azp is present, validate client_id match
  if (payload.azp && payload.azp !== process.env.OIDC_CLIENT_ID) throw new Error('azp mismatch');
  return payload; // use sub as identifier via (iss, sub)
}
```

### 20.3. BFF Pattern (skeleton of server-side callback handling)

```typescript
// ✅ BFF: server holds the tokens; browser gets only an HttpOnly session cookie
import { cookies } from 'next/headers';

export async function handleCallback(code: string, state: string) {
  const session = await getServerSession();           // state/PKCE bound beforehand
  if (state !== session.oauthState) throw new Error('state mismatch'); // §3.2

  const token = await exchangeCodeForToken({
    code,
    codeVerifier: session.codeVerifier,               // §3.1
    redirectUri: process.env.REDIRECT_URI!,           // §2.3 exact match
    clientId: process.env.OIDC_CLIENT_ID!,
    clientSecret: process.env.OIDC_CLIENT_SECRET!,    // Confidential (server only)
  });

  await storeTokensServerSide(session.id, token);     // §14.2 tokens kept on the server
  cookies().set('sid', session.id, { httpOnly: true, secure: true, sameSite: 'lax' });
}
```

### 20.4. DPoP Proof Generation (client-side)

```typescript
// ✅ DPoP Proof (RFC 9449). §13.1
import { generateKeyPair, exportJWK, SignJWT } from 'jose';

const { privateKey, publicKey } = await generateKeyPair('ES256'); // reuse the key pair

export async function createDPoPProof(method: string, url: string, nonce?: string): Promise<string> {
  const jwk = await exportJWK(publicKey);
  return new SignJWT({
    htm: method,                 // HTTP method
    htu: url,                    // URI without query/fragment
    jti: crypto.randomUUID(),    // replay prevention
    ...(nonce ? { nonce } : {}), // DPoP-Nonce
  })
    .setProtectedHeader({ alg: 'ES256', typ: 'dpop+jwt', jwk })
    .setIssuedAt()
    .sign(privateKey);
}
```

### 20.5. Google ID Token Validation (google-auth-library)

```typescript
// ✅ Server-side validation of the Sign in with Google ID Token. §7.2
import { OAuth2Client } from 'google-auth-library';

const client = new OAuth2Client();

export async function verifyGoogleIdToken(idToken: string) {
  const ticket = await client.verifyIdToken({
    idToken,
    audience: process.env.GOOGLE_CLIENT_ID!, // aud validation
  });
  const payload = ticket.getPayload()!;       // iss/exp/signature validated by the library
  if (!payload.email_verified) throw new Error('email not verified'); // §8.2
  return { sub: payload.sub, email: payload.email }; // identify by sub
}
```

---

## §21. Anti-Patterns

> [!CAUTION]
> All of the following are **prohibited or high-risk** in this file. On discovery, remediate immediately per the §000 Zero Tolerance Protocol.

| # | Anti-Pattern | Risk | Correct Approach |
|:--|:-------------|:-----|:-----------------|
| 1 | Using the Implicit Flow (`response_type=token`) | Token exposed/leaked in URL | Authorization Code + PKCE (§2.1) |
| 2 | Logging in with ROPC (password grant) | Direct credential handling, no MFA | Redirect-based authorization (§2.2) |
| 3 | Storing tokens in `localStorage`/`sessionStorage` | Stolen via XSS | BFF + HttpOnly cookie (§14) |
| 4 | Wildcard/partial-match redirect URI | Token interception / Open Redirect | Exact-match registration (§2.3) |
| 5 | `nonce` not validated | ID Token replay | nonce generation/validation (§3.3, §5.1) |
| 6 | `state` not validated | CSRF / code injection | state binding/validation (§3.2) |
| 7 | Skipping ID Token signature validation (`decode` only) | Accepting forged tokens | JWKS signature validation (§5, §6) |
| 8 | `aud`/`iss` not validated | Token substitution / Confused Deputy | Validate all claims (§5.1, §5.2) |
| 9 | Dynamically selecting `alg` from the token header | `alg=none`/HS downgrade attack | Pin alg via allowlist (§5.3) |
| 10 | Auto-linking external identity by same email | Account takeover | Explicit linking + prior verification (§8) |
| 11 | Using email for identity without checking `email_verified` | Impersonation | Strict verified handling (§8.2) |
| 12 | Using `email` as the user primary key | Breaks/takeover on email change/reuse | Identify by `(iss, sub)` (§4.5) |
| 13 | Refresh Token without expiry or rotation | Persistent access on theft | Rotation + reuse detection (§12) |
| 14 | No refresh reuse detection | Theft undetectable | Family-wide revocation (§12.2) |
| 15 | Fetching JWKS on every request | Latency, DoS, reduced availability | Cache + kid re-fetch (§6.3) |
| 16 | Erroring immediately on unknown `kid` | Full outage on key rotation | Re-fetch JWKS (§6.2) |
| 17 | Bundling `client_secret` in a Public Client | Secret extraction, meaningless | Use PKCE instead (§1.2) |
| 18 | Authorizing in a WebView on mobile | Credential theft / PKCE bypass | System browser + AppAuth (§14.4) |
| 19 | Unverified SAML XML signature / XSW-vulnerable processing | Assertion forgery | Signature validation + maintained library (§9.2) |
| 20 | Accepting IdP-initiated SSO unconditionally | Login injection / CSRF | Prefer SP-initiated (§9.3) |
| 21 | Silent auth depending on third-party cookies | Breaks on cookie deprecation | FedCM/redirect (§16) |
| 22 | Logout by client-side token deletion only | Server-side session lingers | Server revocation + Back-Channel (§17) |
| 23 | Requesting excessive scopes up front | Over-privilege, consent fatigue, privacy harm | Minimization + Incremental (§2.4) |
| 24 | Not matching UserInfo `sub` against the ID Token | Token substitution | Validate sub match (§4.3) |

---

## §22. Maturity Model L1–L5

| Level | State | Key Characteristics |
|:------|:------|:--------------------|
| **L1: Ad-hoc** | Improvised implementation | Implicit/ROPC remain, localStorage storage, some validation missing. High risk |
| **L2: Basic** | Basic compliance | Authorization Code + PKCE, `state`/`nonce` validation, ID Token signature + `iss`/`aud`/`exp` validation |
| **L3: Hardened** | Hardened | Refresh Rotation + reuse detection, JWKS caching + rotation handling, scope minimization, safe account linking, BFF for SPAs |
| **L4: Advanced** | Advanced | Sender-Constrained (DPoP/mTLS), PAR/RAR/JARM (high-risk), Back-Channel Logout, SCIM deprovisioning, FedCM support, observability metrics |
| **L5: Optimal** | Optimized | Zero Trust continuous/risk-based authorization, transaction authorization integration (§420), FAPI 2.0 compliance, headroom for next-gen VC/SD-JWT, automated revocation + ITDR linkage |

-   **Action**: Assess your project's current state and target **L3** at minimum. Financial/medical/enterprise SSO should target **L4 or above**.

---

## Appendix A: Reverse Index

> **Usage**: Search by keywords related to your task to locate the relevant section.

| Keyword | Section |
|:--------|:--------|
| OAuth 2.1, Authorization Code, Grant | §2 |
| Implicit Flow, ROPC, prohibited flows | §2.2, §21 |
| PKCE, code_verifier, code_challenge, S256 | §3.1, §20.1 |
| state, CSRF | §3.2, §21 |
| nonce, replay prevention | §3.3, §5.1 |
| redirect URI, exact match, Open Redirect | §2.3 |
| scope, minimization, Incremental Authorization | §2.4, §19.6 |
| OIDC, OpenID Connect, Discovery | §4 |
| ID Token validation, iss, aud, exp, at_hash, azp | §5, §20.2 |
| JWKS, kid, signing key, rotation, cache | §6 |
| alg, none, downgrade attack, HS256 | §5.3 |
| Google, Sign in with Google, GIS | §7.2, §20.5 |
| Apple, Sign in with Apple, private relay | §7.3 |
| Microsoft, Entra ID, tid, MSAL | §7.4 |
| GitHub, OAuth App, GitHub App | §7.5 |
| account linking, takeover, ATO, email_verified | §8 |
| user identifier, sub, iss, email primary key | §4.5, §8.3 |
| SAML 2.0, Assertion, XSW, IdP-initiated | §9 |
| SSO, SP, IdP, enterprise | §1, §9 |
| JIT provisioning, SCIM, deprovisioning | §10 |
| token expiration, Access Token, short-lived | §11.1 |
| Introspection, Revocation, revocation | §11.3, §11.4 |
| Refresh Token, rotation, reuse detection, family | §12 |
| DPoP, Sender-Constrained, cnf, jkt | §13.1, §20.4 |
| mTLS, Certificate-Bound, x5t#S256, FAPI | §13.2 |
| BFF, avoid localStorage, token storage | §14 |
| mobile, AppAuth, WebView prohibited, Keychain | §14.4 |
| PAR, RAR, authorization_details | §15.1, §15.2 |
| JAR, JARM, request object | §15.3 |
| Token Exchange, down-scoping | §15.4 |
| FedCM, third-party cookies | §16 |
| logout, RP-Initiated, Back-Channel Logout | §17 |
| session sync, global logout | §17.3 |
| Verifiable Credentials, SD-JWT, OID4VCI, wallet | §18 |
| observability, OAuth errors, token metrics | §19.1 |
| FinOps, MAU billing, token validation cost | §19.2 |
| performance, JWKS cache | §19.3, §6.3 |
| Zero Trust, Identity-First | §19.5 |
| privacy, consent, over-disclosure | §19.6 |
| responsibility boundaries, RP, AS, RS, IdP, client types | §1 |
| Hybrid Flow, c_hash, response_type | §4.6 |
| Step-Up, re-authentication, acr, amr | §15.5 (→420) |
| anti-patterns | §21 |
| maturity model, L1-L5, FAPI 2.0 | §22 |

---

## Appendix B: Cross-References

> **Cross-References (related rule files)**:
> - [`security/000_security_privacy.md`](./000_security_privacy.md) — §3.5 ID Federation & SSO, §4.4 Social Login, §4.10 OAuth 2.1 & DPoP, §6 Session Management, §9.5 Dark Patterns
> - [`security/400_authentication_and_passkeys.md`](./400_authentication_and_passkeys.md) — Passkey/FIDO2/WebAuthn, MFA, password policy, IDaaS
> - [`security/420_step_up_auth_and_sensitive_operations.md`](./420_step_up_auth_and_sensitive_operations.md) — Step-Up re-authentication, acr/amr, transaction authorization, high-risk operations
> - [`security/200_oss_compliance.md`](./200_oss_compliance.md) — Supply chain management of dependency libraries (jose, etc.)
> - [`engineering/100_api_integration.md`](../engineering/100_api_integration.md) — External API integration, webhook signature validation, token usage
> - [`engineering/300_web_frontend.md`](../engineering/300_web_frontend.md) — CSP/Trusted Types, cookies, frontend security
> - [`engineering/500_firebase_gcp.md`](../engineering/500_firebase_gcp.md) — Firebase Auth, Google Identity, GCP IAM

### Cross-References

| Section | Related Rules |
|---------|---------------|
| §1–§6 (OAuth/OIDC core & validation) | `security/000_security_privacy`, `engineering/100_api_integration` |
| §7–§8 (social login & linking) | `security/000_security_privacy`, `engineering/500_firebase_gcp` |
| §9–§10 (SSO & SCIM) | `security/000_security_privacy` |
| §11–§14 (token management & BFF) | `security/000_security_privacy`, `engineering/300_web_frontend` |
| §15–§18 (advanced, FedCM, future) | `security/420_step_up_auth_and_sensitive_operations` |
| §19–§22 (cross-cutting, implementation, maturity) | `security/400_authentication_and_passkeys`, `engineering/300_web_frontend` |

---
