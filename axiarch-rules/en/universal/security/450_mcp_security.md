# 69. MCP Security (Model Context Protocol Security)

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-06-09

> [!IMPORTANT]
> **Primary Directive**
> "MCP gives the LLM hands and feet into the outside world. Treat tool descriptions, tool results, and resources as **untrusted input**, **do not pass tokens through**, and gate destructive operations behind **human approval**."
> Both the **consumer side (host / client / agent)** and the **builder side (server builder)** of MCP (Model Context Protocol) must conform to the current stable best practices in this file.
> Authentication and authorization follow the priority order in `000_security_privacy.md` §1 (Legal & Security > UX > Revenue > DX).

> [!NOTE]
> This file is the **implementation deep-dive** of `000_security_privacy.md` §18.3 (MCP Security overview) and §18.6 (Tool Poisoning), and is the **canonical source for MCP-specific security implementation**.
> General LLM threats (prompt injection, output handling, excessive agency) are canonical in [`000_security_privacy.md`](./000_security_privacy.md) §17.
> The **authentication/delegation technical detail** of MCP authorization (OAuth 2.1-based, OBO, Resource Indicators) is canonical in [`440_workload_and_agent_identity.md`](./440_workload_and_agent_identity.md) §10/§11 (this file deep-dives the guards on the MCP server implementation side).
> AI agent **permission design, autonomy levels, and human approval gates** are canonical in [`core/000_core_mindset.md`](../core/000_core_mindset.md) §9.

> [!NOTE]
> **Note on standard maturity**: RFC 8707 (Resource Indicators), RFC 9728 (Protected Resource Metadata), RFC 8414 (AS Metadata), RFC 7591 (Dynamic Client Registration), RFC 9449 (DPoP), and RFC 6749 (OAuth 2.0) are **stable standards**.
> By contrast, the **MCP authorization spec is an emerging area revised multiple times in 2025** (2025-03-26 → 2025-06-18 → 2025-11-25), based on the **OAuth 2.1 IETF draft** (draft-ietf-oauth-v2-1). The reference revision at the time of writing is **MCP spec 2025-11-25**. MCP authorization takes the stance of "implement with stable OAuth 2.0 flows (Authorization Code + PKCE) while following the OAuth 2.1 (draft) direction," and **places the authorization logic behind abstraction boundaries so it can track spec changes**.

---

## Table of Contents

| § | Section |
|---|---|
| 1 | [Responsibility Boundaries & Scope](#1-responsibility-boundaries--scope) |
| 2 | [MCP Architecture & Trust Boundaries (Host/Client/Server)](#2-mcp-architecture--trust-boundaries-hostclientserver) |
| 3 | [Transports & Threats (stdio / Streamable HTTP)](#3-transports--threats-stdio--streamable-http) |
| 4 | [Builder Side 1: MCP Authorization (OAuth 2.1 Resource Server)](#4-builder-side-1-mcp-authorization-oauth-21-resource-server) |
| 5 | [Builder Side 2: Input Validation & Indirect Prompt Injection](#5-builder-side-2-input-validation--indirect-prompt-injection) |
| 6 | [Builder Side 3: Tool Definition Soundness (annotations / output schema)](#6-builder-side-3-tool-definition-soundness-annotations--output-schema) |
| 7 | [Builder Side 4: Transport Safety (Origin/DNS Rebinding/Sessions)](#7-builder-side-4-transport-safety-origindns-rebindingsessions) |
| 8 | [Builder Side 5: Execution Isolation, Least Privilege, Secrets, Audit](#8-builder-side-5-execution-isolation-least-privilege-secrets-audit) |
| 9 | [Builder Side 6: Supply Chain (Signing, rug pull, SBOM)](#9-builder-side-6-supply-chain-signing-rug-pull-sbom) |
| 10 | [Consumer Side 1: Server Vetting, Allowlist, Trust Boundaries](#10-consumer-side-1-server-vetting-allowlist-trust-boundaries) |
| 11 | [Consumer Side 2: Tool Definition Pinning & rug pull / tool poisoning Detection](#11-consumer-side-2-tool-definition-pinning--rug-pull--tool-poisoning-detection) |
| 12 | [Consumer Side 3: Human Approval (HITL) & sampling / elicitation](#12-consumer-side-3-human-approval-hitl--sampling--elicitation) |
| 13 | [Consumer Side 4: Untrusted-by-Default & Credential Discipline](#13-consumer-side-4-untrusted-by-default--credential-discipline) |
| 14 | [Observability & Anomaly Detection](#14-observability--anomaly-detection) |
| 15 | [FinOps, Performance, Zero Trust, Privacy](#15-finops-performance-zero-trust-privacy) |
| 16 | [Implementation Snippets](#16-implementation-snippets) |
| 17 | [Anti-Patterns (20)](#17-anti-patterns-20) |
| 18 | [Maturity Model L1–L5](#18-maturity-model-l1l5) |
| A | [Appendix A: Reverse Index](#appendix-a-reverse-index) |
| B | [Appendix B: Cross-References](#appendix-b-cross-references) |

---

## §1. Responsibility Boundaries & Scope

> **Reference standards**: MCP spec 2025-11-25 (Authorization / Security Best Practices / Transports), OAuth 2.1 (draft-ietf-oauth-v2-1), RFC 8707, RFC 9728

### 1.1. What This File Covers

-   **Rule 69.1.1**: This file covers **MCP (Model Context Protocol)-specific security implementation**. Concretely: the Host/Client/Server three-party architecture, transports (stdio / Streamable HTTP), MCP server-side authorization, input validation, tool definition soundness, transport safety, execution isolation, and supply chain, plus MCP client/host-side server vetting, tool pinning, and human approval.
-   **Rule 69.1.2**: It covers both the **builder side (server builder)** and the **consumer side (host/client/agent)**. Clarify the responsibility split between them (§2.3) and never mistake one-sided measures for safety.

### 1.2. Responsibility Boundaries (vs. neighboring files)

-   **Rule 69.1.3**: Observe the following responsibility boundaries and avoid duplicate definitions. Add cross-references, but do not duplicate the body of each canonical source here.

| File | Canonical scope |
|:-----|:----------------|
| `core/000_core_mindset.md` §9 | AI agent **permission design, autonomy (L0–L4), reversibility, human approval gates** (design philosophy) |
| `security/000_security_privacy.md` §17 | **General LLM threats** (prompt injection / output handling / excessive agency / unbounded consumption) |
| `security/000_security_privacy.md` §18.3/§18.6 | MCP/A2A and Tool Poisoning **overview and overall policy** |
| `security/440_workload_and_agent_identity.md` §10/§11 | MCP authorization **authentication/delegation technical detail** (OAuth 2.1-based, OBO, XAA, token lifecycle) |
| `security/410_*` | **Human-facing** OAuth 2.1 / OIDC technical detail |
| `security/430_*` | Authorization / access control models (RBAC/ABAC/ReBAC) canonical |
| **This file `450`** | **MCP-specific security implementation** (three-party arch, transport threats, server-side guards, tool pinning, HITL, supply chain) |

-   **Rule 69.1.4**: "**Whose authority delegates what**" (OBO, Resource Indicators, token TTL) is canonical in `440` §10. This file deep-dives "**how an MCP server implements and validates as a Resource Server**" and "**what a client/host must not trust and must get approved**."

### 1.3. Application Policy

-   **Law**: Implementing a bespoke MCP authorization scheme is prohibited. Use vetted standards (OAuth 2.0 Authorization Code + PKCE, RFC 8707/9728/8414) and vetted libraries/SDKs. Because the MCP authorization spec is emerging, implement it behind an abstraction boundary (§1.0 NOTE).
-   **Law**: The terms "MUST / MUST NOT / SHOULD / SHOULD NOT / MAY" are used per RFC 2119 / RFC 8174. Avoid exaggeration and "fully prevents" style absolutes. MCP is protected by **layers (defense in depth)**.

---

## §2. MCP Architecture & Trust Boundaries (Host/Client/Server)

> **Reference standards**: MCP spec 2025-11-25 (Architecture)

### 2.1. Three-Party Architecture

-   **Overview**: MCP consists of the following three parties, each with a different trust boundary.

| Role | Description | Main responsibilities |
|:-----|:------------|:---------------------|
| **Host** | The application containing the LLM (e.g., IDE, chat app, agent runtime) | Obtain user consent, apply policy, coordinate multiple clients, human approval UI |
| **Client** | A connector inside the Host that maintains a 1:1 connection to one Server | Server vetting, token acquisition, fetch and pin tool definitions |
| **Server** | An external process/service that provides tools, resources, and prompts | Resource Server authorization, input validation, execution isolation, tool definition soundness |

### 2.2. Trust Boundaries

-   **Law**: The **Host ↔ Server interface is a trust boundary**. A Server (and the tool descriptions, tool results, and resources it provides) is treated as **potentially adversarial** even if "approved" (§13.1).
-   **Law**: The Host bundles multiple Servers. **Block lateral movement (cross-server)** where one Server accesses another Server's data/authority. Default to 1 Client = 1 Server, and do not share context, tokens, or sessions across Servers.

### 2.3. Builder / Consumer Responsibility Split

-   **Rule 69.2.1**: Split the responsibilities of the "builder" and "consumer" as follows (MUST). **Do not mistake one-sided measures for safety.**

| Aspect | Builder (Server) responsibility | Consumer (Host/Client) responsibility |
|:-------|:--------------------------------|:--------------------------------------|
| Authorization | Validate audience as a Resource Server, reject token passthrough (§4) | Request minimal scope, attach resource indicator (§13) |
| Input | Strict validation of tool input (§5) | Do not trust tool results, defend re-injection (§13.1) |
| Tool definitions | Accurate annotations, remove hidden instructions (§6) | Pin definition hash, detect rug pull (§11) |
| Destructive operations | Declare destructiveHint, provide confirmation API (§6) | Human approval gate (HITL) (§12) |
| Transport | Origin validation, localhost binding, session discipline (§7) | Vet connection target, defend SSRF (§10) |
| Distribution | Signing, version pinning, SBOM (§9) | Allowlist, signature verification, sandbox (§10) |

---

## §3. Transports & Threats (stdio / Streamable HTTP)

> **Reference standards**: MCP spec 2025-11-25 (Transports)

### 3.1. Threats by Transport

-   **Overview**: MCP has primarily two transports, each with a different threat model.

| Transport | Use | Main threats | Default defenses |
|:----------|:----|:------------|:-----------------|
| **stdio** | Local process (same machine) | Malicious startup command, arbitrary code execution at local privilege, access from other processes | Human approval of startup command (§12), sandbox, least privilege (§8) |
| **Streamable HTTP** | Remote/network | DNS rebinding, CSRF, session hijacking, token passthrough, SSRF | Origin validation, localhost binding, non-deterministic session IDs, Bearer auth (§7) |

-   **Law (authorization and transport)**: The MCP authorization spec is **for HTTP-based transports**. The **stdio transport does NOT follow this authorization flow and instead retrieves credentials from the environment** (environment variables, OS privileges) (MCP spec). Do not force an OAuth flow onto stdio.

### 3.2. Dangers of Local MCP Servers

-   **Law**: A local (stdio) MCP server **runs on the user's machine with privileges equivalent to the MCP client**. An unvetted local server from an untrusted source becomes a path to arbitrary code execution, data exfiltration, and data loss.
-   **Action**: Restrict local servers to **stdio** where possible to limit access to the client only. If using HTTP, restrict via an authorization token requirement or IPC such as Unix domain sockets. At install time, the startup command follows the human approval in §12.

---

## §4. Builder Side 1: MCP Authorization (OAuth 2.1 Resource Server)

> **Reference standards**: MCP spec 2025-11-25 (Authorization), OAuth 2.1 (draft-13), RFC 8707, RFC 9728, RFC 8414, RFC 7591, RFC 9449 (DPoP)
>
> **Note**: MCP authorization is emerging. This section is based on MCP spec 2025-11-25. Delegation (OBO) and token TTL are canonical in `440` §10.

### 4.1. The MCP Server Is an OAuth 2.1 Resource Server

-   **Law**: The MCP server avoids bespoke authorization and is implemented as an **OAuth 2.1 Resource Server**. Authorization is done with **stable OAuth 2.0 flows (Authorization Code + PKCE / Client Credentials where appropriate)**, following the OAuth 2.1 (draft) direction (PKCE mandatory, Implicit/ROPC removed).
-   **Rule 69.4.1**: The MCP server MUST implement **OAuth 2.0 Protected Resource Metadata (RFC 9728)** and provide at least one `authorization_servers` entry. For unauthenticated requests it returns `401` with a `WWW-Authenticate` header containing `resource_metadata` (and `scope` where possible) (MUST/SHOULD).
-   **Rule 69.4.2**: The authorization server MUST provide metadata via **either RFC 8414 (AS Metadata) or OIDC Discovery** (MUST). Client registration is chosen as appropriate from Client ID Metadata Documents (draft) / pre-registration / Dynamic Client Registration (RFC 7591, backwards compatibility).

### 4.2. Audience Binding (Resource Indicators / RFC 8707)

-   **Law**: Tokens MUST be **bound to the target MCP server (audience)**. The client MUST include the **`resource` parameter (RFC 8707 Resource Indicators)** in authorization/token requests, specifying the canonical URI of the target MCP server.
-   **Rule 69.4.3**: The MCP server MUST validate that a received access token was **explicitly issued with itself as the intended audience** (MUST, via the `aud` claim per RFC 9068, etc.). Tokens whose audience is not itself, and expired/invalid tokens, are rejected with **HTTP 401**.
-   **Rule 69.4.4**: The token MUST be included and validated in the `Authorization: Bearer` header on **every request** (MUST). **Do not put tokens in the URL query string** (MUST NOT). **Do not use the session ID for authentication** (§7.3).

### 4.3. Prohibition of Token Passthrough

-   **Law (explicit prohibition in the MCP spec)**: The MCP server MUST NOT accept **tokens that were not issued for itself**. When calling an upstream API, the MCP server acts as a **separate OAuth client to the upstream** and uses a **separate token** issued by the upstream AS. It MUST NOT forward the token received from the MCP client to the upstream as-is (prohibition of token passthrough, MUST NOT).
-   **Rationale**: Token passthrough (a) **circumvents security controls** such as rate limiting, validation, and monitoring; (b) **spoofs the acting identity** in downstream logs and breaks the audit trail; and (c) induces the **Confused Deputy** problem.

### 4.4. Confused Deputy Prevention (proxy-style servers)

-   **Law**: An MCP server acting as a proxy to a third-party API (combination of static client ID + dynamic registration + consent cookie) becomes a target for **Confused Deputy**. It MUST obtain **explicit per-client consent before forwarding to third-party authorization** (MUST).
-   **Action**: Maintain a registry of approved `client_id` values per user and check it before forwarding. The MCP-level consent screen makes the client name, third-party scopes, and `redirect_uri` explicit, and applies CSRF protection (`state`) and clickjacking defense (`frame-ancestors`/`X-Frame-Options`). The `redirect_uri` is validated by **exact match** (no wildcards).

### 4.5. Scope Minimization and per-tool Authorization

-   **Law**: Design scopes with **progressive least privilege**. Do not enumerate all permissions in `scopes_supported`; start with low-risk (discovery/read-only) only, and escalate incrementally (step-up) via the `WWW-Authenticate` `scope` challenge when a privileged operation is first attempted.
-   **Rule 69.4.5**: Do not issue or request wildcard/omnibus scopes (`*` / `all` / `full-access`) (MUST NOT). Where possible, decompose into **per-tool authorization** (per-tool scope), binding more destructive tools to narrower scopes.
-   **Rule 69.4.6**: Tokens SHOULD be sender-constrained (**DPoP / RFC 9449** or mTLS) (SHOULD, MUST for high risk). This cryptographically blocks reuse of stolen tokens. The AS issues short-lived tokens and rotates refresh tokens (consistent with `440` §6).

---

## §5. Builder Side 2: Input Validation & Indirect Prompt Injection

> **Reference standards**: `000_security_privacy.md` §17.1 (Prompt Injection), §17.10 (Output Handling), OWASP LLM01/LLM05

### 5.1. Strict Validation of Tool Input

-   **Law**: The MCP server **strictly validates tool-call input with a schema (e.g., JSON Schema)**. Enforce type, range, enum, length, and format, and reject unknown fields (fail-closed).
-   **Rule 69.5.1**: Treat tool input as **untrusted external input** and apply injection defenses (SQL/command/path/SSRF/template) (MUST). LLM-generated parameters are subject to validation without exception (consistent with `000_security_privacy.md` §17.10).
-   **Action**: Restrict file paths, URLs, and commands via parameterization/allowlist, and prohibit shell/SQL execution by string concatenation. Also **sanitize** output (tool results) before returning, to prevent unintended execution of HTML/SQL/control characters.

### 5.2. Indirect Prompt Injection (via content)

-   **Law**: Treat **external content returned by tools (fetched files, web pages, DB records, resource bodies)** as if it contains malicious instructions for the LLM (**indirect prompt injection**). Design the server so it does not become a path that generates or amplifies attack strings.
-   **Rule 69.5.2**: When embedding third-party-derived strings into tool descriptions, resources, or prompt templates, assume injection: separate and label the provenance and, where possible, neutralize (neutralize imperative tokens, quote them) (SHOULD). General prompt-injection defense is canonical in `000_security_privacy.md` §17.1.
-   **Cross-Reference**: Final responsibility for defense is shared with the consumer side (§13.1). The server "does not become the launchpad of attacks"; the client "does not trust results" — both wheels.

---

## §6. Builder Side 3: Tool Definition Soundness (annotations / output schema)

> **Reference standards**: MCP spec 2025-11-25 (Tools / Tool Annotations), `000_security_privacy.md` §18.6

### 6.1. Correctly Applying Tool annotations

-   **Overview**: MCP tool annotations are hints for the host's UX decisions.

| Annotation | Meaning | Default |
|:-----------|:--------|:--------|
| `readOnlyHint` | Reads only without changing state | `false` |
| `destructiveHint` | May modify/destroy data | **`true`** (conservative) |
| `idempotentHint` | Safe to retry (idempotent) | `false` |
| `openWorldHint` | Interacts with the outside world | **`true`** (conservative) |

-   **Rule 69.6.1**: Tool annotations MUST be applied **accurately** (MUST). Set `readOnlyHint: true` on read-only tools and `destructiveHint: true` on destructive tools explicitly. **Omitting an annotation makes the host conservatively treat it as "destructive / open-world,"** so accurate application is needed to avoid excessive confirmation friction.
-   **Law (do not exaggerate)**: **Annotations are merely informational signals, not enforceable security guarantees** (MCP spec). The server does not rely on annotations and **enforces actual authority** via §4 authorization, §5 input validation, and §8 execution isolation. The client also does not over-trust annotations (§11.3).

### 6.2. structured content / output schema

-   **Action**: Define an **output schema (structured content)** for tool return values where possible, and return typed structures. Returning free-form text only tends to be a breeding ground for indirect injection (§5.2).
-   **Rule 69.6.2**: Destructive tools **declare their destructiveness in the description** and, where possible, provide a safety-valve API such as "dry-run / confirmation token" (SHOULD). This makes client-side HITL (§12) easier to operate.

### 6.3. Eliminating hidden instructions

-   **Law**: Do not embed **hidden instructions** for the LLM in tool names, tool descriptions, parameter descriptions, or resource bodies. Review the definition text so your own server does not become the launchpad of Tool Poisoning (`000_security_privacy.md` §18.6).
-   **Action**: Keep tool definitions machine-readable and version-controlled, and audit changes. Avoid designs that dynamically rewrite descriptions (a breeding ground for the rug pull below), and bump an explicit version on change (§9.2).

---

## §7. Builder Side 4: Transport Safety (Origin/DNS Rebinding/Sessions)

> **Reference standards**: MCP spec 2025-11-25 (Transports / Security Best Practices), CVE-2025-9611, CVE-2025-49596

### 7.1. Origin Validation and DNS Rebinding Defense

-   **Law**: A Streamable HTTP transport server MUST **validate the `Origin` header on all incoming connections** (MUST). If `Origin` is present and invalid, return **HTTP 403 Forbidden** (MUST). This is the core defense that blocks **DNS rebinding** (an attack where a malicious web page reaches a local/intranet MCP server via the browser).
-   **Rule 69.7.1**: A local development server MUST **bind only to `localhost` / `127.0.0.1` / `::1`** and avoid exposing all interfaces such as `0.0.0.0` (MUST). In production, configure an explicit `allowedOrigins` / Host allowlist.
-   **Rationale**: A local server without Origin validation can be compromised via CSRF/DNS rebinding (e.g., CVE-2025-9611 / CVE-2025-49596) using the user's browser as a stepping stone.

### 7.2. Do Not Use Session IDs for Authentication

-   **Law (MCP spec)**: An MCP server that implements authorization MUST **verify all inbound requests** (MUST). It MUST NOT **use sessions for authentication** (MUST NOT). Authentication is done via §4 token validation.
-   **Rule 69.7.2**: Session IDs MUST be **secure and non-deterministic** (cryptographically random UUIDs, etc.) (MUST). Prohibit guessable/sequential IDs. Bind session IDs to **user-specific information** (e.g., `<user_id>:<session_id>`, where `user_id` is derived from the token and not a client-provided value), and provide rotation/expiry (SHOULD).
-   **Rationale**: Prevents session hijacking (impersonation with a guessed ID, malicious event injection into a shared queue).

---

## §8. Builder Side 5: Execution Isolation, Least Privilege, Secrets, Audit

> **Reference standards**: MCP spec 2025-11-25 (Local Server), `core/000_core_mindset.md` §9, `000_security_privacy.md` §21/§25

### 8.1. Sandboxing Tool Execution and Least Privilege

-   **Law**: Isolate tool execution in a **sandbox** (container/seccomp/chroot/application sandbox, etc.) and run with **least privilege**. Restrict access to the file system, network, and subprocesses by default and explicitly open only what is needed.
-   **Rule 69.8.1**: The MCP server's authority to access external resources (DB, files, external APIs) MUST **default to read-only**, and write/destructive operations are only unlocked via an explicit allowlist (MUST, consistent with `core/000_core_mindset.md` §9).

### 8.2. Secret Management and Rate Limiting

-   **Law**: Do not **leak** in-server secrets (upstream API keys, DB credentials) into tool descriptions, logs, errors, or tool results. Manage them with a secrets manager / environment separation (canonical in `000_security_privacy.md` §21).
-   **Rule 69.8.2**: Apply **rate limits, timeouts, and resource caps** to tool calls to prevent unbounded consumption (runaway, cost explosion) (MUST, consistent with `000_security_privacy.md` §17.8).

### 8.3. Immutable Audit Logs

-   **Rule 69.8.3**: Record every tool call in a structured log including **`tool_name` / `input` (after PII masking) / `output_hash` / acting principal (`sub`/`act`) / `audience` / `timestamp`** (MUST). Retain logs tamper-evidently (append-only) (consistent with `000_security_privacy.md` §25 and the MCP Governance in `core/000_core_mindset.md` §9).

---

## §9. Builder Side 6: Supply Chain (Signing, rug pull, SBOM)

> **Reference standards**: MCP spec 2025-11-25, `security/200_oss_compliance.md` (SBOM/dependencies), CVE-2025-54136 (rug pull)

### 9.1. Signing Distributions and Verifiability

-   **Law**: **Digitally sign** MCP server distributions (binaries/packages/tool definitions) so consumers can **verify integrity**. Do not let unsigned, unvetted servers be installed by default.
-   **Rule 69.9.1**: Sign tool-definition files (JSON/YAML), verify against tampering at startup, and refuse to start on mismatch (SHOULD, consistent with `000_security_privacy.md` §18.6).

### 9.2. Care About rug pull (later turning malicious)

-   **Law (rug pull)**: Do not create a breeding ground for the rug pull — "**clean at approval time, turn the description/behavior malicious after approval**" (CVE-2025-54136). Do not **silently update** tool descriptions, commands, or capabilities. On change, design so you **bump an explicit version and can require re-consent from the consumer** (SHOULD).

### 9.3. Dependencies and SBOM

-   **Action**: Manage the MCP server's own dependencies with an SBOM and audit known vulnerabilities and licenses. The detail is canonical in [`security/200_oss_compliance.md`](./200_oss_compliance.md) (linked from this file).

---

## §10. Consumer Side 1: Server Vetting, Allowlist, Trust Boundaries

> **Reference standards**: MCP spec 2025-11-25, `000_security_privacy.md` §18.3, `core/000_core_mindset.md` §9

### 10.1. Server Vetting and Allowlist

-   **Law**: The host/client subjects the target MCP server to **formal security evaluation (vetting)** and connects only to an **approved allowlist** (consistent with `000_security_privacy.md` §18.3). Do not connect to arbitrary servers without vetting.
-   **Rule 69.10.1**: A client that offers **one-click installation** of a local (stdio) server MUST **present the full startup command (including arguments, without truncation)** and obtain explicit user approval before execution (MUST, §12). Warn about dangerous patterns such as `sudo`/`rm -rf`/network operations/home directory & SSH key access.

### 10.2. Client-Side SSRF Defense (metadata fetch)

-   **Law**: During OAuth metadata discovery, the client does not **blindly follow** URLs pointed to by a malicious MCP server (`resource_metadata` / `authorization_servers` / each endpoint). Apply SSRF defense.
-   **Rule 69.10.2**: In production, require **HTTPS** for metadata-fetch URLs and **block requests to private/reserved IP ranges** (`10/8`, `172.16/12`, `192.168/16`, `127/8`, `169.254/16` (cloud metadata), `fc00::/7`, `fe80::/10`) (SHOULD). Do not hand-roll IP validation; use proven libraries / an egress proxy (e.g., Smokescreen), and beware of DNS rebinding (TOCTOU).

### 10.3. Isolating Unvetted Servers

-   **Rule 69.10.3**: Run unvetted/low-trust servers in a **sandbox/isolated environment**, isolated from trusted servers, the host itself, and the context of other servers (SHOULD, consistent with the cross-server blocking in §2.2).

---

## §11. Consumer Side 2: Tool Definition Pinning & rug pull / tool poisoning Detection

> **Reference standards**: MCP spec 2025-11-25, `000_security_privacy.md` §18.6, CVE-2025-54136

### 11.1. Hash-Pinning Tool Definitions

-   **Law**: The client **pins by content hash** the tool definitions acquired at first approval (tool names, descriptions, parameter descriptions, annotations). Pin by **version + content hash**, not just server name.
-   **Rule 69.11.1**: At startup/reconnection, compare the hash of the acquired tool definitions against the pin, and on **detecting a mismatch, halt automatic execution and require re-consent** (MUST). This is the primary defense against **rug pull** (silent turning-malicious after approval).

### 11.2. tool poisoning (hidden instruction) Detection

-   **Law**: Assume **hidden instructions (tool poisoning)** are embedded in tool descriptions and parameter descriptions, and have a **human review** the definition text. AI review of definitions is insufficient (it is the same target being attacked), so combine with human review (consistent with `000_security_privacy.md` §18.6).
-   **Action**: Also prepare for tool shadowing (substitution of a same-named tool), and detect/warn on collisions of same-named/similar tools provided by multiple servers.

### 11.3. Do Not Over-Trust annotations

-   **Rule 69.11.2**: The client MUST NOT **trust server-declared annotations (`readOnlyHint`, etc.) as enforceable guarantees** (MUST NOT). Annotations are merely UX hints (§6.1); actual destructiveness is separately ensured by **server-side authorization and host-side HITL** (§12).

---

## §12. Consumer Side 3: Human Approval (HITL) & sampling / elicitation

> **Reference standards**: MCP spec 2025-11-25 (Sampling / Elicitation), `core/000_core_mindset.md` §9.2/§9.5/§9.11

### 12.1. Human Approval of Destructive/High-Privilege Tools

-   **Law**: Obtain **explicit human approval (Human-in-the-Loop) before execution** of destructive, high-privilege, or irreversible tool calls. Following reversibility-first (`core/000_core_mindset.md` §9.2), make the approval gate stronger the more irreversible the operation.
-   **Rule 69.12.1**: The host's approval UI MUST present the **tool name, arguments, target resource, and expected impact** without truncation (MUST). The canonical source for approval (autonomy L0–L4, approval requirements) is `core/000_core_mindset.md` §9.

### 12.2. UI Spoofing (line-of-death) Defense

-   **Law**: Render the approval UI within a trust boundary (host-native UI) so that tool results or server-derived strings **cannot spoof/overwrite the approval dialog (UI redress / crossing the line-of-death)**. Prevent clickjacking (iframe embedding) with `frame-ancestors`/`X-Frame-Options`.
-   **Rule 69.12.2**: Display text under approval **does not render server-derived imperative strings in directly executable form** (neutralize/quote them). Structurally eliminate "tricking the user into thinking they approved."

### 12.3. Approving sampling / elicitation

-   **Law (sampling)**: MCP **sampling** (a feature where the server requests LLM inference via the client) is a path for the server to **indirectly use the user's LLM**. The host gates sampling requests with **human approval** and surfaces the prompt content, model, and cost (SHOULD). Do not allow unlimited sampling.
-   **Law (elicitation)**: MCP **elicitation** (a feature where the server requests additional input from the user) can become a path to phish confidential information. The host makes the **provenance (which server) explicit** for elicitation requests and gates entry of confidential information with a warning/approval (SHOULD).
-   **Rule 69.12.3**: sampling / elicitation MUST be treated as **requests crossing a trust boundary** and included in the scope of approval, scoping, and auditing (MUST).

---

## §13. Consumer Side 4: Untrusted-by-Default & Credential Discipline

> **Reference standards**: `000_security_privacy.md` §17.1, `440` §10, MCP spec 2025-11-25

### 13.1. Do Not Trust Tool Descriptions, Tool Results, or Resources

-   **Law**: The client/host treats **tool descriptions, tool results, and resource bodies as "untrusted input."** Assuming the indirect prompt injection they may contain (§5.2), separate provenance, label, and neutralize imperatives when passing them to the LLM (general defense is canonical in `000_security_privacy.md` §17.1).
-   **Rule 69.13.1**: Do not **use a tool result directly as the argument of the next tool call or as the trigger of a high-privilege operation** (MUST). Route result-derived actions through HITL (§12) according to reversibility and privilege.

### 13.2. Credential Discipline (do not pass to the server)

-   **Law**: The client MUST NOT **send the MCP server any token other than one issued by that server's AS** (MUST NOT, MCP spec). Enforce minimal scope and attaching the **`resource` indicator** for the target server (§4.2).
-   **Rule 69.13.2**: When acting on behalf of a human, limit the data/tokens passed to the server to **purpose-bound and minimal**, and follow OBO delegation with dual identity (human + agent) (canonical in `440` §8/§10). Do not reuse the user's long-lived token or password for the server.

---

## §14. Observability & Anomaly Detection

### 14.1. Auditing and Anomaly Detection of Tool Calls

-   **Action**: For each MCP server/client, baseline the normal patterns of tool calls (frequency, target tools, argument distribution, time of day) and detect deviations (in concert with `000_security_privacy.md` §3.3 ITDR).
-   **Metrics to track**:
    -   Changes to tool-definition hashes (rug pull detection firing), changes to annotations.
    -   Token passthrough attempts, denials due to audience mismatch, connection attempts to unapproved servers.
    -   Number/cost of sampling / elicitation firings, approval/denial rate of destructive tools.
    -   Origin validation failures (signs of DNS rebinding), session ID anomalies (signs of hijacking).

### 14.2. Automated Response

-   **Action**: For high-risk events (tool-definition tampering detection, token passthrough, unapproved server connection), build an automated workflow (SOAR integration) that severs the connection to the server, revokes tokens, and notifies the owner.

---

## §15. FinOps, Performance, Zero Trust, Privacy

### 15.1. FinOps (tool-call / sampling cost)

-   **Action**: Tool calls and **sampling** (server-initiated LLM inference) incur token/API cost. Measure cost per server/tool and curb runaways with budget guards (`core/000_core_mindset.md` §9.10). Allowing unlimited sampling is also a FinOps risk.

### 15.2. Performance

-   **Action**: Token validation is a hot path. Curb latency with a JWKS cache (same policy as `410` §6.3 / `440` §14.2). Perform tool-definition hash comparison at connection time to avoid the synchronous cost per call.

### 15.3. Zero Trust

-   **Law**: Holding a token is not trust. Validate access to the MCP server on every request by audience/scope/sender-constraint/context (NIST SP 800-207, `440` §15.1). Also treat tool results and server-derived content as "untrusted" every time (§13.1).

### 15.4. Privacy

-   **Action**: Limit data passed to tools to **purpose-bound and minimal** (`000_security_privacy.md` §7.2 data minimization). Mask PII in tool input/results/audit logs and block unnecessary PII transmission to external servers.

---

## §16. Implementation Snippets

> [!NOTE]
> Snippets are minimal examples assuming current stable libraries; a specific stack is only a **representative example**. In production, add exception handling, timeouts, and audit logging. Because MCP authorization is emerging, place the authorization logic behind an abstraction boundary (§1.0 NOTE).

### 16.1. MCP Server: Audience Validation and Token Passthrough Rejection (Resource Server)

```typescript
// ✅ The MCP server accepts only tokens "issued for itself." Token passthrough prohibited. §4.2 / §4.3
import { createRemoteJWKSet, jwtVerify } from 'jose';

const AS_JWKS = createRemoteJWKSet(new URL('https://as.example.com/.well-known/jwks.json'));
const THIS_MCP_SERVER = 'https://mcp.example.com/mcp'; // own canonical URI (RFC 8707 audience)

export async function authorizeMcpRequest(authHeader: string | undefined) {
  if (!authHeader?.startsWith('Bearer ')) {
    // §4.1: return 401 + WWW-Authenticate(resource_metadata)
    throw new Http401('Bearer required', { resource_metadata: `${THIS_MCP_SERVER}/.well-known/oauth-protected-resource` });
  }
  const token = authHeader.slice('Bearer '.length);
  const { payload } = await jwtVerify(token, AS_JWKS, {
    audience: THIS_MCP_SERVER,          // §4.2: only tokens whose audience is us (RFC 8707/9068)
    algorithms: ['RS256', 'ES256'],     // alg allowlist
  });
  // §4.3: even when calling an upstream API, do NOT forward this token (acquire a separate one)
  return payload; // use sub/scope for subsequent authorization decisions
}
```

### 16.2. MCP Server: Origin Validation Middleware (DNS rebinding defense)

```typescript
// ✅ Origin validation + localhost binding for Streamable HTTP. §7.1
const ALLOWED_ORIGINS = new Set(['https://app.example.com']); // explicit allowlist in production

export function originGuard(req, res, next) {
  const origin = req.headers['origin'];
  // If Origin is present and not allowed, 403 (block DNS rebinding)
  if (origin !== undefined && !ALLOWED_ORIGINS.has(origin)) {
    return res.status(403).send('Forbidden: invalid Origin'); // §7.1 MUST
  }
  next();
}
// At startup: bind local dev to 127.0.0.1 (do not expose all via 0.0.0.0). §7.1
// server.listen({ host: '127.0.0.1', port: 3333 });
```

### 16.3. MCP Server: Tool Input Schema Validation (fail-closed)

```typescript
// ✅ Strictly validate tool input with a JSON-Schema equivalent. Reject unknown fields, defend injection. §5.1
import { z } from 'zod';

const ReadFileInput = z.object({
  path: z.string().min(1).max(1024),
}).strict(); // .strict() = reject unknown fields (fail-closed)

const ALLOWED_ROOT = '/srv/data/'; // restrict to allowed directory

export function handleReadFile(raw: unknown) {
  const { path } = ReadFileInput.parse(raw); // type/length violations throw
  const resolved = require('node:path').resolve(ALLOWED_ROOT, path);
  if (!resolved.startsWith(ALLOWED_ROOT)) {
    throw new Error('path traversal blocked'); // §5.1 path traversal defense
  }
  // Sanitize the result before returning too (§5.1). Do not mix in secrets (§8.2).
  return readSanitized(resolved);
}
```

### 16.4. MCP Client: rug pull Detection via Tool-Definition Hash Pin

```typescript
// ✅ Pin the tool definitions from first approval by hash. On mismatch, require re-consent. §11.1
import { createHash } from 'node:crypto';

function toolDefHash(tools: unknown): string {
  // Normalize tool names, descriptions, parameter descriptions, annotations and hash
  return createHash('sha256').update(JSON.stringify(tools)).digest('hex');
}

// pin saved at approval time (content hash + version)
const pinned = { version: '1.2.0', hash: 'abc123...' };

export function verifyToolDefinitions(serverVersion: string, currentTools: unknown) {
  const current = toolDefHash(currentTools);
  if (serverVersion !== pinned.version || current !== pinned.hash) {
    // possible rug pull / tool poisoning -> halt automatic execution and re-consent (§11.1)
    throw new Error('tool definitions changed since approval — re-consent required');
  }
  // Do not trust annotations as enforceable guarantees (§11.3). Destructiveness ensured separately via HITL (§12).
}
```

---

## §17. Anti-Patterns (20)

> [!CAUTION]
> All of the following are **prohibited or high-risk** in this file. On discovery, remediate immediately per the Zero Tolerance Protocol in `000_security_privacy.md`.

| # | Anti-pattern | Risk | Correct response |
|:--|:-------------|:-----|:-----------------|
| 1 | token passthrough (forward the received token to upstream as-is) | Confused Deputy, broken audit, control bypass | Acquire a separate token, forwarding prohibited (§4.3) |
| 2 | MCP server accepts tokens without audience validation | Misuse of tokens for other services | Accept only tokens whose audience is us (§4.2) |
| 3 | Streamable HTTP server without Origin validation | DNS rebinding, CSRF | Origin validation + 403 (§7.1) |
| 4 | Expose a local server on `0.0.0.0` | Local server compromise | localhost binding (§7.1) |
| 5 | Use session ID for authentication | Session hijacking | Do not authenticate via session, validate token every time (§7.2) |
| 6 | Guessable/sequential session ID | Impersonation by guessing the ID | Non-deterministic ID + user binding (§7.2) |
| 7 | Trust tool descriptions, results, resources | Indirect prompt injection | Treat as untrusted input (§5.2, §13.1) |
| 8 | No schema validation of tool input | Injection, path traversal | Strict schema + fail-closed (§5.1) |
| 9 | Trust annotations as enforceable guarantees | Unconfirmed execution of destructive tools | annotations are UX hints, ensure via HITL (§6.1, §11.3) |
| 10 | Missing/inaccurate annotations | Excessive friction or misclassification of dangerous tools | Apply accurate annotations (§6.1) |
| 11 | No human approval for destructive tools | Misfire of irreversible operations | HITL approval gate (§12.1) |
| 12 | Approval UI spoofable by server-derived strings | Crossing line-of-death, coerced approval | Host-native UI + neutralization (§12.2) |
| 13 | Allow unlimited sampling / elicitation | Indirect LLM abuse, phishing for secrets, cost explosion | Bring into scope of approval, scoping, audit (§12.3) |
| 14 | Connect to unapproved/unvetted MCP servers | Malicious server, Tool Poisoning | Allowlist + vetting (§10.1) |
| 15 | Do not hash-pin tool definitions | rug pull (turning-malicious after approval) undetectable | Pin by content hash + version (§11.1) |
| 16 | Execute one-click local server startup command without confirmation | Arbitrary code execution | Present full startup command + approval (§10.1) |
| 17 | Client follows metadata URLs without validation | SSRF (cloud metadata, etc.) | HTTPS required + block private IPs (§10.2) |
| 18 | Wildcard/omnibus scopes (`*`/`all`) | Excessive privilege, lateral movement | Progressive minimal scope, per-tool (§4.5) |
| 19 | Do not sandbox tool execution | Arbitrary code execution, data loss | Sandbox + least privilege (§8.1) |
| 20 | Install unsigned servers/tool definitions without verification | Supply chain poisoning, rug pull | Signature verification + version pinning (§9.1, §9.2) |

---

## §18. Maturity Model L1–L5

| Level | State | Main characteristics |
|:------|:------|:---------------------|
| **L1: Ad-hoc** | Ad-hoc | Connect to arbitrary servers without vetting, token passthrough, no Origin/input validation, blindly trust tool results, no approval for destructive tools. High risk |
| **L2: Basic** | Basic compliance | Approved-server allowlist, tool input schema validation, HITL for destructive tools, MCP server is a Resource Server that validates audience |
| **L3: Hardened** | Hardened | Thorough token-passthrough prohibition, Origin validation + localhost binding, no session-based auth, tool-definition hash pin (rug pull detection), accurate annotations, sandboxed tool execution |
| **L4: Advanced** | Advanced | Progressive minimal scope + per-tool authorization, sender-constrained tokens (DPoP/mTLS), Confused Deputy prevention (per-client consent), approval/audit of sampling/elicitation, client-side SSRF defense, distribution signature verification |
| **L5: Optimal** | Optimal | Zero Trust continuous verification, structural blocking of cross-server lateral movement, immutable audit logs + automated response to tool-call anomalies (ITDR/SOAR), whole-supply-chain SBOM + version pinning + automated rug pull detection, FinOps budget guards |

-   **Action**: Assess your project's current position and target at least **L3**. Target **L4 or above** if you publish an MCP server / let agents use MCP in production, or for finance/healthcare.

---

## Appendix A: Reverse Index

> **How to use**: Search by a keyword related to your task to locate the relevant section.

| Keyword | Section |
|:--------|:--------|
| MCP, Model Context Protocol, architecture, trust boundary | §2 |
| Host, Client, Server, three-party, responsibility split | §2.1, §2.3 |
| transport, stdio, Streamable HTTP, threats | §3 |
| local server, startup command, arbitrary code execution | §3.2, §10.1 |
| MCP authorization, Resource Server, OAuth 2.1, Protected Resource Metadata, RFC 9728 | §4.1 |
| audience, Resource Indicators, RFC 8707, canonical URI | §4.2 |
| token passthrough, forwarding prohibited | §4.3, §16.1 |
| Confused Deputy, per-client consent, proxy | §4.4 |
| scope minimization, per-tool, step-up, DPoP | §4.5, §4.6 |
| input validation, schema, injection | §5.1, §16.3 |
| indirect prompt injection, tool results | §5.2, §13.1 |
| tool annotations, readOnlyHint, destructiveHint, idempotentHint, openWorldHint | §6.1 |
| output schema, structured content, destructive tools | §6.2 |
| hidden instruction, tool definition soundness | §6.3 |
| Origin validation, DNS rebinding, localhost binding | §7.1, §16.2 |
| session ID, session hijacking, not for authentication | §7.2 |
| sandbox, least privilege, execution isolation | §8.1 |
| secrets, rate limiting, audit log | §8.2, §8.3 |
| supply chain, signing, rug pull, CVE-2025-54136, SBOM | §9 |
| server vetting, allowlist | §10.1 |
| SSRF, metadata fetch, private IP blocking | §10.2 |
| tool definition pinning, hash, rug pull detection | §11.1, §16.4 |
| tool poisoning, hidden instruction, tool shadowing | §11.2 |
| do not over-trust annotations | §11.3 |
| human approval, HITL, destructive operations | §12.1 |
| UI spoofing, line-of-death, clickjacking | §12.2 |
| sampling, elicitation, approval | §12.3 |
| untrusted input, credential discipline | §13 |
| observability, anomaly detection, ITDR | §14 |
| FinOps, sampling cost, performance | §15.1, §15.2 |
| Zero Trust, privacy, data minimization | §15.3, §15.4 |
| implementation snippets | §16 |
| anti-patterns | §17 |
| maturity model, L1-L5 | §18 |
| responsibility boundaries, 440 vs 450 vs 000 §17 | §1.2 |

---

## Appendix B: Cross-References

> **Cross-references (related rule files)**:
> - [`security/000_security_privacy.md`](./000_security_privacy.md) — §17 AI/LLM Security (prompt injection, output handling, excessive agency, unbounded consumption), §18.3 MCP Security overview, §18.6 Tool Poisoning, §21 Secrets, §25 Audit logs
> - [`security/440_workload_and_agent_identity.md`](./440_workload_and_agent_identity.md) — §10 MCP Authorization (OAuth 2.1-based), §11 XAA, §7 Agent Tier-0, §8 OBO delegation (canonical for authentication/delegation)
> - [`security/410_federated_identity_and_oauth.md`](./410_federated_identity_and_oauth.md) — OAuth 2.1 / OIDC, token management, PKCE (canonical)
> - [`security/430_authorization_and_access_control.md`](./430_authorization_and_access_control.md) — Authorization / access control models (RBAC/ABAC/ReBAC, canonical)
> - [`security/200_oss_compliance.md`](./200_oss_compliance.md) — SBOM, dependency vulnerabilities, licensing (canonical for supply chain)
> - [`core/000_core_mindset.md`](../core/000_core_mindset.md) — §9 Agentic AI era protocol (permission design, autonomy L0–L4, reversibility, human approval gates, MCP Governance)
> - [`engineering/100_api_integration.md`](../engineering/100_api_integration.md) — External API integration, Webhook signature verification

### Cross-References

| Section | Related rules |
|---------|---------------|
| §1–§3 (boundaries, arch, transport) | `security/000_security_privacy` §18.3, `core/000_core_mindset` §9 |
| §4 (MCP authorization, Resource Server) | `security/440` §10, `security/410`, `security/430` |
| §5 (input, indirect injection) | `security/000_security_privacy` §17.1/§17.10 |
| §6 (tool definition soundness) | `security/000_security_privacy` §18.6 |
| §7 (transport safety) | `security/000_security_privacy` §19 (perimeter defense) |
| §8 (execution isolation, audit) | `core/000_core_mindset` §9, `security/000_security_privacy` §21/§25 |
| §9 (supply chain) | `security/200_oss_compliance`, `security/000_security_privacy` §18.6 |
| §10–§13 (consumer: vetting, pinning, HITL, untrusted) | `core/000_core_mindset` §9.2/§9.5, `security/000_security_privacy` §17.1/§18.3, `security/440` §8/§10 |
| §14–§15 (observability, FinOps, Zero Trust, privacy) | `core/000_core_mindset` §9.10, `security/000_security_privacy` §3.3/§7, `security/440` §13/§15 |

---
