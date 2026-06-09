# 68. Workload & Agent Identity

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-06-09

> [!IMPORTANT]
> **Primary Directive**
> "Non-human identities outnumber humans many times over and are compromised faster and harder than humans — give them no standing credentials; default to short-lived, scoped, revocable."
> Authentication and delegation for service accounts, API keys, CI/CD credentials, workloads, and AI agents must
> conform to the current stable best practices in this file.
> Authentication and authorization follow the priority order in `000_security_privacy.md` §1 (Legal & Security > UX > Revenue > DX).

> [!NOTE]
> This file is the **deep-dive** of `000_security_privacy.md` §3.2 (Non-Human Identity Management) and §18 (Agentic AI / MCP), and is the **canonical source for authentication and delegation of non-human identities (NHI) and AI agents**.
> The canonical source for **human-facing** OAuth/OIDC and token exchange is [`410_federated_identity_and_oauth.md`](./410_federated_identity_and_oauth.md) (M2M and delegation belong here).
> The canonical source for AI agent **permission design, autonomy levels, and delegation maturity** is [`core/000_core_mindset.md`](../core/000_core_mindset.md) §9 (this file is the technical deep-dive of authentication/delegation).

> [!NOTE]
> **Note on standard maturity**: SPIFFE/SPIRE, OAuth 2.0 Client Credentials (RFC 6749), Token Exchange (RFC 8693), and Resource Indicators (RFC 8707) are **stable standards**.
> By contrast, **OAuth 2.1 is an IETF draft** (draft-ietf-oauth-v2-1, not an RFC), and the **operational patterns for MCP (Model Context Protocol) authorization, Cross-App Access (XAA), and AI agent On-Behalf-Of delegation are emerging / draft standards from 2025–2026.** Implement the emerging parts behind abstraction boundaries, assuming the specs will change.

---

## Table of Contents

| § | Section |
|---|---|
| 1 | [Responsibility Boundaries & Scope](#1-responsibility-boundaries--scope) |
| 2 | [Non-Human Identity (NHI) Governance](#2-non-human-identity-nhi-governance) |
| 3 | [Workload Identity (SPIFFE/SPIRE & mTLS)](#3-workload-identity-spiffespire--mtls) |
| 4 | [Workload Identity Federation (WIF & OIDC)](#4-workload-identity-federation-wif--oidc) |
| 5 | [M2M Authentication (Client Credentials & API Keys)](#5-m2m-authentication-client-credentials--api-keys) |
| 6 | [Short-Lived Credentials, STS, Zero Standing Privilege](#6-short-lived-credentials-sts-zero-standing-privilege) |
| 7 | [AI Agent Identity Principles (Tier-0)](#7-ai-agent-identity-principles-tier-0) |
| 8 | [On-Behalf-Of Delegation (Token Exchange & Dual Identity)](#8-on-behalf-of-delegation-token-exchange--dual-identity) |
| 9 | [Delegation Chain Limits & Loop Prevention](#9-delegation-chain-limits--loop-prevention) |
| 10 | [MCP Authorization (OAuth 2.1-based, Emerging)](#10-mcp-authorization-oauth-21-based-emerging) |
| 11 | [Cross-App Access (XAA, IdP-Brokered, Emerging)](#11-cross-app-access-xaa-idp-brokered-emerging) |
| 12 | [Auditing & Delegation Chain Traceability](#12-auditing--delegation-chain-traceability) |
| 13 | [Observability & Anomaly Detection](#13-observability--anomaly-detection) |
| 14 | [FinOps, Performance, Scalability](#14-finops-performance-scalability) |
| 15 | [Zero Trust & Privacy](#15-zero-trust--privacy) |
| 16 | [Implementation Snippets](#16-implementation-snippets) |
| 17 | [Anti-Patterns (20)](#17-anti-patterns-20) |
| 18 | [Maturity Model L1–L5](#18-maturity-model-l1l5) |
| A | [Appendix A: Reverse Index](#appendix-a-reverse-index) |
| B | [Appendix B: Cross-References](#appendix-b-cross-references) |

---

## §1. Responsibility Boundaries & Scope

> **Reference**: NIST SP 800-207 (Zero Trust), SPIFFE/SPIRE, RFC 6749, RFC 8693, RFC 8707

### 1.1. What This File Covers

-   **Rule 68.1.1**: This file covers authentication and delegation for **non-human access principals** (Non-Human Identities = NHI): service accounts, API keys, CI/CD credentials, workloads (containers/functions/VMs), and AI agents.
-   **Rule 68.1.2**: Human user browser/mobile authentication (Authorization Code Flow, social login, SSO, passkeys) is out of scope here; `410` and `400` are canonical for that.

### 1.2. Responsibility Boundaries (Boundaries with Adjacent Files)

-   **Rule 68.1.3**: Honor the following responsibility boundaries to avoid duplicate definitions. Cross-reference, but do not replicate the body of each canonical source in this file.

| File | Canonical Scope |
|:-----|:----------------|
| `core/000_core_mindset.md` §9 | AI agent **permission design, autonomy (L0–L4), delegation maturity, reversibility, human-approval gates** (design philosophy) |
| `security/000_security_privacy.md` §3.2 / §18 | **Overview and overall policy** for NHI management and Agentic AI/MCP |
| `security/410_*` | Technical detail of **human-facing** OAuth 2.1 / OIDC and token exchange |
| **This file `440`** | **Technical detail of NHI, workload, and AI-agent authentication/delegation** (SPIFFE, WIF, Client Credentials, OBO, MCP authorization) |

-   **Rule 68.1.4**: **Cloud/runtime-specific implementation steps** for WIF, SPIRE, etc., are canonically owned by engineering rules such as `engineering/500_firebase_gcp.md`. This file defines policy and verification requirements.

### 1.3. Application Policy

-   **Law**: Building your own authentication/delegation protocol is prohibited. Use vetted standards (SPIFFE/SPIRE, OAuth 2.0 Client Credentials, RFC 8693 Token Exchange) and vetted libraries/SDKs.
-   **Law**: The terms "MUST / MUST NOT / SHOULD / SHOULD NOT / MAY" are used per RFC 2119 / RFC 8174.

---

## §2. Non-Human Identity (NHI) Governance

> **Reference**: `000_security_privacy.md` §3.2, NIST SP 800-207

### 2.1. Assume NHIs Outnumber Humans Many Times Over

-   **Law**: Design governance **assuming automation**, on the premise that NHIs exist at an **order-of-magnitude larger scale** than human IDs (many times over, per industry surveys). Manual inventory breaks down at that scale.
-   **Rule 68.2.1**: The NHI lifecycle (issue → use → rotate → revoke → delete) MUST be automated, minimizing human intervention.

### 2.2. NHI Classification & Owner Assignment

-   **Rule 68.2.2**: Classify all NHIs and **assign a human owner to every NHI**. NHIs with no known owner are treated as orphaned and become revocation candidates.

| NHI Type | Examples | Default Auth Method | Risk |
|:---------|:---------|:--------------------|:-----|
| **Service Account** | GCP SA / AWS IAM Role | WIF / STS short-lived token | High |
| **API Key** | External SaaS integration key | Prefix + hashed storage | High |
| **CI/CD Credential** | GitHub Actions / deploy key | **OIDC (no static secret)** | Critical |
| **Workload** | Container/function/VM | SPIFFE SVID / mTLS | High |
| **AI Agent** | LLM agent / MCP Client | OBO delegation + short-lived token | Critical |
| **Bot/Automation** | Cron / Webhook handler | Scoped short-lived token | Medium |

### 2.3. Inventory, Rotation, Bulk Revocation, Orphaned Detection

-   **Rule 68.2.3**: Maintain a **machine-readable** NHI inventory (derived from API/IaC), holding owner, scope, last-used time, and expiry as attributes (MUST).
-   **Rule 68.2.4**: Automatically detect NHIs unused for a period, or whose owner has left/changed roles, as **orphaned**, and route them into a deactivation flow (MUST).
-   **Rule 68.2.5**: Pre-establish a path to **bulk-revoke NHIs** by owner, issuer, or scope during a leak/incident (MUST). Align with `000_security_privacy.md` §6.7 Panic Button.
-   **Rule 68.2.6**: Periodically audit NHIs holding broad permissions (`*` / `admin` / unscoped) and shrink them to least privilege.

---

## §3. Workload Identity (SPIFFE/SPIRE & mTLS)

> **Reference**: SPIFFE/SPIRE (CNCF graduated project), RFC 8705 (mTLS)

### 3.1. SPIFFE ID and SVID

-   **Overview**: SPIFFE gives a workload a **platform-agnostic unique ID** (SPIFFE ID, e.g. `spiffe://example.org/ns/prod/sa/payments`). SPIRE is its reference implementation, which **attests** a workload (verifies its runtime environment) and then issues a **short-lived SVID** (X.509 certificate or JWT).
-   **Law**: Default workload-to-workload authentication to **short-lived SPIFFE SVID + mTLS**, not long-lived shared secrets.
-   **Action**:
    1.  Do not bake static certs/keys into workloads. Obtain SVIDs dynamically via SPIRE Agent attestation.
    2.  Keep SVIDs **short-lived** (minutes to hours) and auto-renew them.
    3.  Use X.509-SVID for mTLS and JWT-SVID for bearer-style verification over HTTP/gRPC.

### 3.2. mTLS and Service Mesh

-   **Action**: When using a service mesh (Istio/Linkerd, etc.), default to **service-to-service mTLS** with the mesh-issued workload certificates (typically SPIFFE-compatible), eliminating cleartext internal traffic.
-   **Rule 68.3.1**: The receiving side of an SVID/certificate MUST validate the **trust domain** and the **SPIFFE ID (or SAN)** against an allowlist. It must not accept connections from arbitrary workloads.

### 3.3. Secretless / Zero Standing Privilege

-   **Law**: Design workloads to be **secretless** (hold no static secrets) wherever possible. Derive authentication from runtime attestation (SPIFFE / cloud metadata / OIDC).
-   **Cross-Reference**: §6 (Short-Lived Credentials), `000_security_privacy.md` §21.3 (Dynamic Secrets)

---

## §4. Workload Identity Federation (WIF & OIDC)

> **Reference**: GCP Workload Identity Federation, AWS IAM Roles Anywhere / OIDC, Azure Workload Identity, GitHub Actions OIDC

### 4.1. Retire Static Keys

-   **Law**: Do not newly issue **long-lived static keys** (service-account key JSON, long-lived IAM-user access keys) for workload authentication to the cloud. Exchange for short-lived credentials via **Workload Identity Federation (WIF) / OIDC**.

### 4.2. Federation Methods by Provider

| Environment | Federation Method |
|:------------|:------------------|
| **GCP** | Workload Identity Federation (external OIDC/SAML → short-lived SA token) |
| **AWS** | IAM Roles Anywhere (X.509) / OIDC federation (`AssumeRoleWithWebIdentity`) |
| **Azure** | Workload Identity Federation (Federated Credentials) |
| **CI/CD** | **GitHub Actions OIDC** (`id-token: write`) → short-lived role assumption per cloud |

### 4.3. OIDC Federation Validation Requirements

-   **Rule 68.4.1**: The cloud-side trust policy MUST, in addition to the IdP `iss`, **bind `sub` / `aud` / claims such as repository, branch, and environment with the minimum scope** (MUST). Unverified `aud` or wildcard `sub` is prohibited.
-   **Rule 68.4.2**: For GitHub Actions OIDC, include the **repository and (as needed) branch/environment/tag** in the trust condition to structurally prevent role assumption from forks or arbitrary repositories.
-   **Cross-Reference**: `000_security_privacy.md` §19.3 (CI/CD OIDC), `engineering/500_firebase_gcp.md` (WIF implementation detail)

---

## §5. M2M Authentication (Client Credentials & API Keys)

> **Reference**: RFC 6749 (OAuth 2.0 Client Credentials), RFC 8707 (Resource Indicators), RFC 9449 (DPoP), RFC 8705 (mTLS)

### 5.1. OAuth 2.0 Client Credentials Grant

-   **Law**: Default user-absent M2M (machine-to-machine) communication to the **OAuth 2.0 Client Credentials Grant (RFC 6749)**. Do not repurpose user authentication flows (Authorization Code) for M2M.
-   **Rule 68.5.1**: Tokens obtained via Client Credentials MUST be **scoped to a minimal `audience` (target resource, RFC 8707 resource indicators) and `scope`**. A single general-purpose token must not be shared across all APIs.
-   **Rule 68.5.2**: Where possible, **sender-constrain M2M tokens with mTLS (RFC 8705) or DPoP (RFC 9449)** to cryptographically block reuse of stolen tokens (SHOULD; MUST for financial/high-risk).

### 5.2. API Key Discipline

-   **Law**: When adopting API keys, satisfy the following (aligned with `000_security_privacy.md` §4.8).
-   **Action**:
    1.  **Prefix**: Add a prefix that identifies type/environment (e.g. `sk_live_` / `pk_test_`).
    2.  **Hashed storage**: Do not store the key body in plaintext; store a SHA-256 (or similar) hash. Compare in constant time.
    3.  **Rotation**: Define expiry and a rotation cycle; prohibit non-expiring keys. Use an overlap window (both old and new valid) for zero-downtime rotation.
    4.  **Revocation log**: Record issuance, use, and revocation in the audit log, with a path to revoke immediately on leak.
-   **Rule 68.5.3**: API keys are a **lightweight** M2M mechanism; migrate to Client Credentials + short-lived tokens where possible (SHOULD). Long-lived API keys cause severe damage on leak.

---

## §6. Short-Lived Credentials, STS, Zero Standing Privilege

> **Reference**: NIST SP 800-207, `000_security_privacy.md` §21.3

### 6.1. TTL Management and Auto-Renewal

-   **Law**: Default NHI/workload/agent credentials to **short-lived**, with explicitly managed TTL (expiry). Implement a mechanism to auto-renew before expiry.

| Credential Type | Recommended TTL |
|:----------------|:----------------|
| Workload SVID (SPIFFE) | Minutes to 1 hour |
| STS / WIF short-lived token | ≤ 1 hour |
| M2M access token | ≤ 1 hour |
| AI agent delegation token | ≤ 15 min (shorter for high-risk) |

### 6.2. Retire Static Secrets and Zero Standing Privilege

-   **Law**: As a rule, prohibit newly introducing static/long-lived secrets; migrate to **dynamic/short-lived secrets** (STS / Vault dynamic secrets / WIF).
-   **Rule 68.6.1**: Minimize permanently valid permissions (**standing privilege**) and adopt a Just-in-Time model that **issues on demand and auto-revokes on task completion** (SHOULD; MUST for privileged NHIs).
-   **Cross-Reference**: `000_security_privacy.md` §21 (Secrets Management), §3.4 (PAM / JIT)

---

## §7. AI Agent Identity Principles (Tier-0)

> **Reference**: `core/000_core_mindset.md` §9, `000_security_privacy.md` §18, OAuth 2.1 (draft), RFC 8693
>
> **★Future-critical core**: From this section onward (§7–§11) is the core of AI agent authentication/delegation, including emerging / draft areas from 2025–2026.

### 7.1. The Agent Has a Distinct Identity from the Human

-   **Law**: Assign an AI agent **an identity distinct from the human operating it**. An agent must not repurpose the human's login session, password, or long-lived token as-is.
-   **Rationale**: Separating the agent's and human's identities lets you audit, scope-limit, and revoke the agent's actions independently.

### 7.2. Tier-0 Principles (Absolute Prohibitions for Agents)

-   **Law**: Apply the following **Tier-0 principles** to AI agent identities without exception.

| Tier-0 Principle | Meaning |
|:-----------------|:--------|
| **No standing credential** | Do not give agents permanently valid long-lived credentials. Limit delegation to short-lived and revocable |
| **No unscoped** | Do not grant agents unrestricted scope (all APIs, all resources). Always constrain `audience` / `scope` |
| **No shared secret** | Do not reuse the same credential across multiple agents/services. One agent = one identity |

-   **Rule 68.7.1**: Permissions handed to an agent MUST be **short-lived, scoped, and revocable**. This is the operational restatement of the Tier-0 principles.
-   **Cross-Reference**: Permission-design autonomy levels (L0–L4) and human-approval gates are canonically owned by `core/000_core_mindset.md` §9.1.

---

## §8. On-Behalf-Of Delegation (Token Exchange & Dual Identity)

> **Reference**: RFC 8693 (OAuth 2.0 Token Exchange — stable), OAuth 2.1 (draft), RFC 8707 (Resource Indicators)
>
> **Note**: RFC 8693 Token Exchange itself is a stable standard. **Applying it as an operational pattern for AI agent On-Behalf-Of (OBO) delegation** is emerging in 2025–2026; assume the spec will change.

### 8.1. OBO Delegation Principles

-   **Law**: When an agent acts "on behalf of" a human user, use **On-Behalf-Of (OBO) delegation** to retain the dual identity of "human + agent." The agent must not impersonate the human and erase the trail.
-   **Action**: Using RFC 8693 Token Exchange:
    1.  Present the human's token as the `subject_token`.
    2.  Present the agent's identity as the `actor_token` (or an equivalent `requested_actor` representation).
    3.  The AS issues a token containing both **the principal (`sub`) and the acting party (`act` chain)**. Record the chain of delegators in the `act` claim.
-   **Rule 68.8.1**: The issued token MUST retain, in an auditable form, both **whose authority (`sub`)** and **who executed (`act`)**. Impersonation (acting while erasing actor info) harms auditability, so use delegation (retaining `act`) as the rule.

### 8.2. Enforced Downscoping and Resource Indicators

-   **Law**: On OBO delegation, the token handed to the agent **must not broaden permissions** beyond the original human token. **Downscope (narrow)** as needed.
-   **Rule 68.8.2**: The Token Exchange request MUST include **narrowed `scope`** and **audience restriction via `resource` (RFC 8707 resource indicators)** (MUST). This structurally prevents privilege escalation via delegation (propagation of excess permission).

---

## §9. Delegation Chain Limits & Loop Prevention

> **Reference**: `000_security_privacy.md` §18.4 (A2A), `core/000_core_mindset.md` §9.6 (Multi-Agent Orchestration)

### 9.1. Depth Limits for Multi-Hop Delegation

-   **Law**: Cap the **depth of multi-hop delegation chains** like human → agent → sub-agent → resource. Unbounded delegation makes permissions untraceable and enables lateral movement.
-   **Rule 68.9.1**: Set a **delegation-depth counter** or a cap on `act` chain length in delegation tokens, and reject exchange requests that exceed the cap (MUST).
-   **Rule 68.9.2**: **Enforce downscoping at each delegation hop** (§8.2), maintaining the monotonic property that permissions shrink downstream. Downstream must not gain broader permissions than upstream.

### 9.2. Loop Prevention

-   **Rule 68.9.3**: Detect **re-appearance of the same identity (cycles)** in a delegation chain and reject loops (A→B→A) (MUST). Align with Agentic Loop Detection in `core/000_core_mindset.md` §9.6.
-   **Action**: Implement a dual guard of timeout and maximum delegation count to prevent infinite delegation (Infinite Delegation Loop, `000_security_privacy.md` §18.4).

---

## §10. MCP Authorization (OAuth 2.1-based, Emerging)

> **Reference**: Model Context Protocol Authorization (OAuth 2.1-based — **emerging/draft**), OAuth 2.1 (draft-ietf-oauth-v2-1), RFC 8707
>
> **Note**: The MCP authorization spec is an **emerging area** being standardized through 2025–2026. Place authorization logic behind an abstraction boundary so you can follow spec updates.

### 10.1. MCP Authorization Basics

-   **Law**: Authorization for access to MCP (Model Context Protocol) servers avoids bespoke schemes. **Implement with stable OAuth 2.0 flows (Authorization Code + PKCE / Client Credentials where appropriate)** and follow the OAuth 2.1 direction (mandatory PKCE, Implicit/ROPC removed); do not make conformance to the OAuth 2.1 draft itself an implementation prerequisite (it is still an IETF draft).
-   **Action**:
    1.  The MCP client (agent) treats the MCP server as a **Resource Server** and authorizes with a scoped, short-lived token obtained from the AS.
    2.  Use **resource indicators (RFC 8707)** to name the target MCP server as the `audience`, preventing token misuse (Confused Deputy).
    3.  Propagate user context per the §8 OBO delegation, retaining the "human + agent" dual identity (aligned with the privilege-escalation prevention in `000_security_privacy.md` §18.3).

### 10.2. MCP-Specific Guards

-   **Rule 68.10.1**: Restrict MCP servers to an approved allowlist (`000_security_privacy.md` §18.3) and combine signature verification with human review against tool-definition tampering (Tool Poisoning, §18.6).
-   **Rule 68.10.2**: MCP tokens MUST also follow the Tier-0 principles (§7.2): **short-lived, scoped, revocable**.

---

## §11. Cross-App Access (XAA, IdP-Brokered, Emerging)

> **Reference**: Cross-App Access (XAA, **emerging**), RFC 8693 (Token Exchange), Enterprise IdP Federation
>
> **Note**: XAA is an **emerging 2025–2026 pattern** in which an enterprise IdP brokers app-to-app / agent-to-agent access. As the standard is still solidifying, treat it as an extension point rather than a new mandatory requirement.

### 11.1. IdP-Brokering Principles

-   **Overview**: Cross-App Access (XAA) places the **enterprise IdP as a broker** when an agent or app accesses another app/resource, with the IdP handling policy enforcement, token exchange, and **auditing of all actions**. It avoids the "connector sprawl" of agents forming individual long-lived integrations with each app.
-   **Action**:
    1.  Avoid direct long-lived credential issuance between agent and resource; consolidate to IdP-brokered scoped short-lived tokens.
    2.  **Centrally audit all access and all delegation** on the IdP side, enabling revocation in one place.
    3.  Token exchange conforms to RFC 8693 (§8), preserving OBO dual identity and downscoping.
-   **Rule 68.11.1**: Even when adopting XAA, do not relax the requirements of the Tier-0 principles (§7.2), delegation chain limits (§9), or audit traceability (§12).

---

## §12. Auditing & Delegation Chain Traceability

> **Reference**: `000_security_privacy.md` §25 (Immutable Logs), RFC 8693 (`act` claim)

### 12.1. Full Traceability of the Delegation Chain

-   **Law**: Record the entire delegation chain "human → agent → (sub-agent →) resource" in a form a human can trace and verify after the fact.
-   **Rule 68.12.1**: Each access/operation log MUST include the **effective principal (`sub`), executing actor (`act` chain), target resource (`audience`), scope, and token issuance/revocation events** (MUST).
-   **Rule 68.12.2**: Retain NHI/agent audit logs as **tamper-evident (immutable, append-only)** (`000_security_privacy.md` §25), and mask PII per §7.4.

### 12.2. Correlation and Reconstruction

-   **Action**: Attach a correlation id to delegation tokens so a single delegation chain can be reconstructed across distributed services. Require that an incident can immediately reproduce "under whose authority, which agent did what."

---

## §13. Observability & Anomaly Detection

### 13.1. Behavioral Baselines for NHIs/Agents

-   **Action**: Baseline normal usage patterns per NHI/agent (call frequency, target APIs, time-of-day, destinations) and detect deviations (in concert with `000_security_privacy.md` §3.3 ITDR).
-   **Metrics to measure**:
    -   Token issue/renew/revoke rates; Token Exchange (OBO) firing counts.
    -   Delegation-depth distribution; depth-cap hits; loop-detection firings.
    -   Denials due to `audience`/`scope` mismatch; connections from unknown SPIFFE IDs/trust domains.
    -   Anomalous agent tool calls (sudden frequency spikes; out-of-normal resources).

### 13.2. Automated Response

-   **Action**: For high-risk events (reuse detection, delegation loops, unscoped requests), build an automated workflow (SOAR-integrated) that immediately revokes the token family for that NHI/agent and notifies the owner.

---

## §14. FinOps, Performance, Scalability

### 14.1. FinOps (Short-Lived Credential Issuance Cost)

-   **Action**: Short-lived credentials are safe but incur a **round-trip cost to STS / the AS on every issuance and renewal**. Balance issuance frequency against TTL and monitor for excessive re-issuance. Some IDaaS bill per M2M token count, so curb agents from over-minting tokens.

### 14.2. Performance

-   **Action**: Token validation is a hot path. Use local validation of JWT-SVID/JWT plus JWKS caching (same policy as `410` §6.3) to reduce latency. Do not make key fetches synchronously blocking.

### 14.3. Scalability

-   **Action**: Assuming NHIs are an order of magnitude larger in number, scale revocation lists and delegation state horizontally with a distributed store (e.g. Redis). Center on stateless validation (short-lived tokens), while reconciling consistency and scale via a hybrid of short TTL + revocation lists.

---

## §15. Zero Trust & Privacy

### 15.1. Continuous Verification (Zero Trust)

-   **Law**: Holding a token does not equal trust. Verify NHI/agent access each time against `audience`/`scope`/sender-constraint/context (workload attestation, risk score) (NIST SP 800-207, `000_security_privacy.md` §2.4 Identity-First Zero Trust).

### 15.2. Privacy

-   **Action**: When an agent accesses on behalf of a human, restrict the data passed through OBO delegation to **purpose-bound and minimal** (`000_security_privacy.md` §7.2 Data Minimization). Mask PII in delegation tokens and audit logs, and take care that a human cannot be directly identified from the correlation id.

---

## §16. Implementation Snippets

> [!NOTE]
> Snippets are minimal examples assuming current stable libraries. In production, add error handling, timeouts, and audit logging. Place emerging areas (MCP/XAA) behind abstraction boundaries, assuming spec churn.

### 16.1. Verifying a SPIFFE JWT-SVID (Receiver Side)

```typescript
// ✅ Verify a SPIFFE JWT-SVID against a trust domain + SPIFFE ID allowlist. §3.2
import { createRemoteJWKSet, jwtVerify } from 'jose';

const BUNDLE = createRemoteJWKSet(new URL('https://spire-server.example.org/keys')); // trust bundle

const ALLOWED_SPIFFE_IDS = new Set(['spiffe://example.org/ns/prod/sa/payments']);

export async function verifySvid(jwtSvid: string, expectedAudience: string) {
  const { payload } = await jwtVerify(jwtSvid, BUNDLE, {
    audience: expectedAudience,           // §3.1 audience validation
    algorithms: ['ES256', 'RS256'],       // alg allowlist
  });
  // sub = SPIFFE ID. Validate trust domain + allowlist
  if (!ALLOWED_SPIFFE_IDS.has(String(payload.sub))) {
    throw new Error('untrusted SPIFFE ID');
  }
  return payload;
}
```

### 16.2. Client Credentials + mTLS (Obtaining an M2M Token)

```typescript
// ✅ OAuth 2.0 Client Credentials with restricted audience/scope. §5.1
// mTLS is assumed to be bound via an HTTPS client certificate (agent options / fetch dispatcher).
export async function getM2MToken(): Promise<string> {
  const res = await fetch('https://as.example.com/oauth2/token', {
    method: 'POST',
    headers: { 'content-type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      grant_type: 'client_credentials',
      client_id: process.env.M2M_CLIENT_ID!,
      // With mTLS binding, no client_secret is needed (cert-based auth). DPoP may also be combined.
      scope: 'payments:read',                       // §5.1 minimal scope
      resource: 'https://api.example.com/payments', // §5.1 RFC 8707 audience restriction
    }),
    // dispatcher/agent: attach the mTLS client certificate (environment-dependent)
  });
  if (!res.ok) throw new Error('token request failed');
  return (await res.json()).access_token;
}
```

### 16.3. Token Exchange (On-Behalf-Of Delegation, Dual Identity)

```typescript
// ✅ RFC 8693 Token Exchange for "human + agent" OBO delegation. §8
// subject_token = the human's token, actor_token = the agent's identity.
export async function exchangeOnBehalfOf(humanToken: string, agentToken: string) {
  const res = await fetch('https://as.example.com/oauth2/token', {
    method: 'POST',
    headers: { 'content-type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      grant_type: 'urn:ietf:params:oauth:grant-type:token-exchange',
      subject_token: humanToken,
      subject_token_type: 'urn:ietf:params:oauth:token-type:access_token',
      actor_token: agentToken,                                          // §8.1 act chain
      actor_token_type: 'urn:ietf:params:oauth:token-type:access_token',
      scope: 'documents:read',                                          // §8.2 downscope (narrow only)
      resource: 'https://api.example.com/documents',                    // §8.2 RFC 8707 audience restriction
    }),
  });
  if (!res.ok) throw new Error('token exchange failed');
  // The issued token contains sub (human) + act (agent chain). §8.1 / §12.1
  return (await res.json()).access_token;
}
```

### 16.4. MCP Authorization Flow (Emerging, Behind an Abstraction Boundary)

```typescript
// ✅ Authorize an MCP server as a Resource Server, OAuth 2.1-based. §10 (emerging/draft)
// To absorb spec churn, isolate MCP authorization acquisition in a dedicated module.
export async function getMcpToken(mcpServerUrl: string, delegated: { human: string; agent: string }) {
  // Obtain a short-lived, scoped token via OBO delegation (§8), restricting the target MCP to the audience
  const token = await exchangeOnBehalfOf(delegated.human, delegated.agent);
  // The resource indicator prevents misuse toward MCP servers other than this one (§10.1)
  return { authorization: `Bearer ${token}`, audience: mcpServerUrl };
}
```

### 16.5. GitHub Actions OIDC → Cloud Short-Lived Role

```yaml
# ✅ Assume a short-lived cloud role via GitHub Actions OIDC with no static key. §4.2 / §4.3
permissions:
  id-token: write   # required to issue the OIDC token
  contents: read
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: aws-actions/configure-aws-credentials@<commit-sha>  # §000 §19.3 pin by SHA
        with:
          role-to-assume: arn:aws:iam::123456789012:role/deploy-role
          aws-region: ap-northeast-1
          # Bind sub/aud to repository/branch in the cloud-side trust policy (§4.1):
          #   "token.actions.githubusercontent.com:sub": "repo:org/repo:ref:refs/heads/main"
          #   "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
```

---

## §17. Anti-Patterns (20)

> [!CAUTION]
> Each of the following is **prohibited or a serious risk** in this file. On discovery, remediate immediately per the Zero Tolerance Protocol in `000_security_privacy.md`.

| # | Anti-Pattern | Risk | Correct Approach |
|:--|:-------------|:-----|:-----------------|
| 1 | Issuing long-lived static keys for service accounts (JSON/access keys) | Persistent access on leak | Short-lived tokens via WIF/OIDC (§4) |
| 2 | Sharing the same credential across services/agents | Wider blast radius, unknown owner | One principal = one identity (§2.2, §7.2) |
| 3 | Not assigning an owner to an NHI | Orphaned detection impossible, neglect | Human owner for every NHI (§2.2) |
| 4 | Granting `*`/`admin`/unscoped to NHIs/agents | Excess permission, lateral movement | Minimize audience/scope (§5.1, §7.2) |
| 5 | Repurposing Authorization Code flow for M2M | Misused flow, complexity | Client Credentials (§5.1) |
| 6 | Storing API keys in plaintext | Full key leak on DB compromise | Prefix + hashed storage (§5.2) |
| 7 | Non-expiring, non-rotating API keys | Persistent on leak | TTL + rotation + revocation log (§5.2) |
| 8 | M2M tokens left as bearer (no sender-constraint) | Stolen-token reuse | mTLS/DPoP binding (§5.1) |
| 9 | Granting agents standing (long-lived) credentials | Tier-0 violation, constant attack surface | Short-lived, revocable delegation (§7.2) |
| 10 | Agent repurposing the human's session/token | Cannot separate human from agent in audit | Distinct identity + OBO (§7.1, §8) |
| 11 | Impersonation that erases actor info | Loss of "who executed" | Delegation (retain `act`) (§8.1) |
| 12 | Broadening permissions (upscope) in OBO delegation | Privilege escalation | Enforce downscoping (§8.2) |
| 13 | No resource/audience on Token Exchange | Confused Deputy, misuse | Restrict audience via RFC 8707 (§8.2, §10) |
| 14 | No depth limit on multi-hop delegation | Untraceable, infinite delegation | Delegation-depth cap (§9.1) |
| 15 | Not detecting delegation loops (A→B→A) | Infinite loop, resource exhaustion | Loop detection + timeout (§9.2) |
| 16 | Hand-rolling a bespoke MCP authorization scheme | Standard deviation, vulnerabilities | OAuth 2.1-based (§10.1) |
| 17 | Connecting to unapproved/unverified MCP servers | Tool Poisoning, privilege escalation | Allowlist + signature verification (§10.2) |
| 18 | Not logging the delegation chain | Incident untraceable | Record sub+act+audience (§12.1) |
| 19 | Not validating SVID/cert trust domain & SPIFFE ID | Accepting spoofed workloads | Allowlist validation (§3.2) |
| 20 | Wildcard `sub` / unverified `aud` in WIF trust policy | Role assumption from arbitrary repos | Bind sub/aud via claims (§4.1) |

---

## §18. Maturity Model L1–L5

| Level | State | Key Characteristics |
|:------|:------|:--------------------|
| **L1: Ad-hoc** | Ad-hoc | Long-lived static keys, shared credentials, owner-unknown NHIs, plaintext API keys. High risk |
| **L2: Basic** | Basic compliance | NHI inventory and owner assignment, hashed+prefixed API keys, M2M via Client Credentials with audience/scope restriction |
| **L3: Hardened** | Hardened | Static keys retired via WIF/OIDC, short-lived credentials + auto-renew, SPIFFE/mTLS, automated orphaned detection, bulk-revocation path, agents have distinct identities |
| **L4: Advanced** | Advanced | Sender-constrained M2M (mTLS/DPoP), OBO delegation (human+agent dual identity), enforced downscoping, delegation-depth limits + loop prevention, delegation-chain auditing, MCP authorization (OAuth 2.1-based) |
| **L5: Optimal** | Optimal | Zero Standing Privilege (JIT issuance, auto-revoke), Zero Trust continuous verification, XAA with centralized IdP brokering and auditing of all actions, automated response to NHI/agent anomaly detection (ITDR/SOAR-integrated) |

-   **Action**: Assess your project's current position and target at least **L3**. Target **L4 or above** for production AI-agent operation and for financial/medical use.

---

## Appendix A: Reverse Index

> **How to use**: Search by a keyword related to your task and locate the relevant section.

| Keyword | Section |
|:--------|:--------|
| Non-Human Identity, NHI, governance, inventory, owner | §2 |
| orphaned, bulk revocation | §2.3 |
| rotation, API key, prefix, hashed storage | §5.2 |
| SPIFFE, SPIRE, SVID, attestation | §3.1 |
| mTLS, service mesh, trust domain | §3.2 |
| secretless, Zero Standing Privilege | §3.3, §6.2 |
| Workload Identity Federation, WIF | §4 |
| GCP WIF, AWS IAM Roles Anywhere, Azure | §4.2 |
| GitHub Actions OIDC, id-token, sub/aud binding | §4.2, §4.3, §16.5 |
| M2M, Client Credentials, RFC 6749 | §5.1 |
| audience, scope, resource indicators, RFC 8707 | §5.1, §8.2, §10.1 |
| DPoP, mTLS, sender-constrained | §5.1 |
| short-lived credentials, STS, TTL, auto-renew | §6 |
| AI agent, distinct identity, Tier-0 | §7 |
| no standing credential, no unscoped, no sharing | §7.2 |
| On-Behalf-Of, OBO, dual identity, actor_token | §8 |
| Token Exchange, RFC 8693, act claim | §8, §16.3 |
| downscope, no upscope | §8.2, §9.1 |
| delegation chain, depth limit, loop prevention | §9 |
| MCP, Model Context Protocol, authorization | §10 |
| Cross-App Access, XAA, IdP brokering | §11 |
| auditing, traceability, sub, act, correlation id | §12 |
| observability, anomaly detection, ITDR | §13 |
| FinOps, token issuance cost, M2M billing | §14.1 |
| performance, JWKS cache, scalability | §14.2, §14.3 |
| Zero Trust, continuous verification | §15.1 |
| privacy, data minimization, PII masking | §15.2, §12.2 |
| implementation snippets | §16 |
| anti-patterns | §17 |
| maturity model, L1-L5 | §18 |
| responsibility boundaries, 410 vs 440 vs core §9 | §1.2 |

---

## Appendix B: Cross-References

> **Cross-references (related rule files)**:
> - [`security/000_security_privacy.md`](./000_security_privacy.md) — §3.2 Non-Human Identity Management, §18 Agentic AI & MCP/A2A, §21 Secrets Management, §25 Audit Logs
> - [`core/000_core_mindset.md`](../core/000_core_mindset.md) — §9 Agentic AI Era Protocol (permission design, autonomy L0–L4, delegation maturity, human-approval gates)
> - [`security/400_authentication_and_passkeys.md`](./400_authentication_and_passkeys.md) — Human-facing auth credentials, passkeys, MFA, IDaaS
> - [`security/410_federated_identity_and_oauth.md`](./410_federated_identity_and_oauth.md) — Human-facing OAuth 2.1 / OIDC, token management, Token Exchange (§15.4)
> - [`security/420_step_up_auth_and_sensitive_operations.md`](./420_step_up_auth_and_sensitive_operations.md) — Step-Up re-authentication, sensitive operation protection
> - [`security/430_*`](./) — (related: adjacent authentication rule)
> - [`engineering/500_firebase_gcp.md`](../engineering/500_firebase_gcp.md) — Workload Identity Federation, GCP IAM, SA implementation detail (canonical)
> - [`engineering/100_api_integration.md`](../engineering/100_api_integration.md) — External API integration, Webhook signature verification, M2M token usage

### Cross-References

| Section | Related Rules |
|---------|---------------|
| §1–§2 (Responsibility boundaries, NHI governance) | `security/000_security_privacy` §3.2/§21, `core/000_core_mindset` §9 |
| §3–§4 (Workload, WIF) | `engineering/500_firebase_gcp`, `security/000_security_privacy` §19.3 |
| §5–§6 (M2M, short-lived credentials) | `security/410_federated_identity_and_oauth` §15.4, `engineering/100_api_integration` |
| §7–§9 (Agents, OBO, delegation chain) | `core/000_core_mindset` §9.1/§9.6, `security/000_security_privacy` §18 |
| §10–§11 (MCP, XAA) | `security/000_security_privacy` §18.3/§18.6 |
| §12–§15 (Auditing, observability, Zero Trust, privacy) | `security/000_security_privacy` §25/§26/§2.4/§7 |

---
