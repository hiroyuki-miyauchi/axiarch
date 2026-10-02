# 67. Authorization & Access Control Deep Dive

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-06-09

> [!IMPORTANT]
> **Level 1 Priority: Absolute Compliance**
> The authorization layer is the final line of defense that decides "who can access what." Even after authentication (authN) is breached, correctly functioning authorization (authZ) can stop data exfiltration and privilege escalation.
> The MUST requirements in this file exist to reduce risk and raise the quality floor; they take priority over user convenience, development velocity, and cost.

> [!CAUTION]
> **Primary Directive**
> This file is the **deep-dive / detailed expansion** of `security/000_security_privacy.md` §4.5 (RBAC/ABAC design) and §4.6 (RBAC Defense Protocol).
> 000 holds summary-level policy; this file (67) provides authorization-layer detail at an implementable granularity (RBAC/ABAC/ReBAC model selection, Policy as Code, externalized authorization, API authorization). It expands rather than duplicates.
> Authentication (credentials) is delegated to the adjacent file (400), federation/OAuth to (410), Step-Up auth to (420), and delegated authorization (OAuth scope delegation, token-exchange detail) to (440). This file focuses on **the authorization decision and enforcement (authZ)**.

---

## Table of Contents

- §1. Primary Directive & Scope
- §2. authN vs authZ Division of Responsibility
  - §2.1. Who You Are (authN) vs What You May Do (authZ)
  - §2.2. PDP / PEP / PIP / PAP Architecture
  - §2.3. Deny-by-Default Principle
  - §2.4. Least Privilege & Separation of Duties (SoD)
- §3. Authorization Model Selection & Progressive Escalation
  - §3.1. RBAC (Role-Based)
  - §3.2. ABAC (Attribute-Based)
  - §3.3. ReBAC (Relationship-Based)
  - §3.4. PBAC (Policy-Based)
  - §3.5. Selection Criteria & Progressive Escalation Path
- §4. ReBAC / Google Zanzibar Pattern
  - §4.1. Relation Tuples
  - §4.2. Transitive & Hierarchical Access
  - §4.3. OpenFGA (CNCF Incubating)
  - §4.4. SpiceDB (Tunable Consistency / Freshness)
- §5. Policy as Code
  - §5.1. AWS Cedar + Amazon Verified Permissions
  - §5.2. OPA / Rego (K8s / Infrastructure)
  - §5.3. Cedar vs OPA: When to Use Which
- §6. Externalizing Authorization
  - §6.1. No Scattered In-App `if` Checks
  - §6.2. Centralized Policy Store & Centralized Guards
  - §6.3. Decision Log (Auditability)
  - §6.4. Consistency / Freshness Requirements
- §7. OAuth Integration & API Authorization
  - §7.1. Scope Design
  - §7.2. RAR (RFC 9396 authorization_details)
  - §7.3. PAR (RFC 9126)
  - §7.4. API Authorization: Preventing BOLA / BFLA
- §8. Multi-Tenant Authorization
  - §8.1. Tenant Isolation & Privilege Boundaries
  - §8.2. Row-Level Security (RLS) Integration
- §9. Cross-Cutting Perspectives (Observability / FinOps / Performance / Scalability / Zero Trust / Privacy)
- §10. Implementation Snippets
- §11. Anti-Patterns
- §12. Maturity Model L1–L5
- Appendix A: Quick Reference Index

---

## §1. Primary Directive & Scope

### 1.1. Scope of Responsibility

-   **This file (67) covers**: implementation detail of the authorization (authZ) layer — selection of authorization models (RBAC/ABAC/ReBAC/PBAC), Policy as Code, externalizing authorization decisions, API authorization, and multi-tenant authorization.
-   **Out of scope (delegated)**:

| Topic | Delegated to |
|:------|:-------------|
| Authorization summary policy (SSOT, Guardian Protocol origin) | `security/000_security_privacy.md` §4.5, §4.6 |
| Authentication (credentials, passkeys, MFA, passwords) | `security/400_authentication_and_passkeys.md` |
| Federation, OAuth/OIDC token-acquisition flows | `security/410_federated_identity_and_oauth.md` |
| Step-Up authentication, re-authentication for sensitive operations | `security/420_step_up_auth_and_sensitive_operations.md` |
| Delegated authorization (token exchange, on-behalf-of, delegated-scope detail) | `security/440_workload_and_agent_identity.md` |
| RLS implementation specifics (PostgreSQL policy syntax) | `engineering/200_supabase_architecture.md` |

### 1.2. Core Principles

-   **Rule 67.1.1 (authN/authZ Separation)**: Authentication (who you are) and authorization (what you may do) MUST be designed and implemented as **separate layers**. Authentication success MUST NOT substitute for authorization. Being logged in does not mean "you may operate on resource X."
-   **Rule 67.1.2 (Deny-by-Default)**: An authorization decision MUST grant access **only when explicitly permitted**, and deny otherwise. On undefined/unknown/error conditions, fall to the deny side (fail-closed).
-   **Rule 67.1.3 (Externalize Authorization)**: Authorization decision logic MUST NOT be scattered throughout application code. Consolidate it into a centralized policy definition (Policy as Code) or a centralized guard (PDP) (see §6).
-   **Rule 67.1.4 (Least Privilege)**: Grant each principal (user/service) only the minimum privileges required for its job. Avoid handing out broad privileges by default and narrowing later.
-   **Rule 67.1.5 (No Overstatement)**: Do not claim "perfect" or "absolutely secure." This file aims to **raise the cost of attack and systematically reduce risk**; read each requirement as raising the quality floor. That said, requirements marked MUST are mandatory.

---

## §2. authN vs authZ Division of Responsibility

### 2.1. Who You Are (authN) vs What You May Do (authZ)

| Aspect | Authentication (authN) | Authorization (authZ) |
|:-------|:------------------------|:----------------------|
| **Question** | Who are you? | What may you do? |
| **Output** | Verified identity (subject / principal) | A grant/deny decision |
| **Input** | Credentials (passkey, password, MFA) | subject, action, resource, context |
| **Owning file** | `400` (credentials) / `410` (federation) | **This file (67)** |

-   **Rule 67.2.1**: An authorization decision **takes the authenticated identity as a precondition input**, but MUST NOT be decided by authentication success alone. Use signals passed from the authentication layer (factor strength, phishing resistance, device type) as authorization context (see 400 §10.4).

### 2.2. PDP / PEP / PIP / PAP Architecture

> The standard XACML-derived separation of authorization components. Apply regardless of implementation stack.

| Component | Role |
|:----------|:-----|
| **PDP (Policy Decision Point)** | **Decides** allow/deny based on policy. The core of the authorization engine |
| **PEP (Policy Enforcement Point)** | Queries the PDP on the request path and **enforces** the decision (API gateway, middleware, guard function) |
| **PIP (Policy Information Point)** | **Supplies** the attributes needed for a decision (user attributes, resource attributes, environment) |
| **PAP (Policy Administration Point)** | **Manages and edits** policies |

-   **Rule 67.2.2 (PEP Coverage)**: Place a PEP on **every access path** to a protected resource (MUST). If some paths (admin APIs, batch jobs, internal service-to-service calls) lack a PEP, they become bypass routes.
-   **Rule 67.2.3 (PDP Single Responsibility)**: Separate decision (PDP) from enforcement (PEP); do not embed decision logic into the PEP. Keep the PDP swappable (embedded / sidecar / remote service).

### 2.3. Deny-by-Default Principle

-   **Rule 67.2.4**: The default value of policy evaluation MUST be **deny**. Every request that does not match a permit rule is denied. Cedar, OPA, and OpenFGA all use deny-by-default as their base behavior.
-   **Rule 67.2.5 (Explicit forbid Wins)**: When permit and forbid conflict, **forbid wins** (deny-overrides). Cedar guarantees these semantics at the language level.
-   **Anti-Pattern**: "Deny what is on the list, allow everything else" (allow-by-default / blocklist). A gap instantly becomes excess privilege.
-   **Rule 67.2.9 (Define Boundaries as Sets, Pinned by a Two-Way Ratchet)**: A security boundary (writable columns, readable columns, masked keys, allowed origins, allowed selectors, etc.) MUST be **defined as a set (allowed set + default polarity), not as an enumeration of named elements**. Naming elements always misses "the ones added later." Pin the set with a test (ratchet) that **goes red in both directions** — when an element is added and when one is removed (MUST). Keep the canonical classification in machine-readable form — functions, constants, tests — not in comments or documents (MUST; a comment cannot be checked). When drawing a boundary, inventory sibling paths at the same time (if you close UPDATE, also INSERT; if you fix one table, every table of the same shape) (MUST). Failure pattern: five incidents — operations, key names, columns, wildcards, DNS — all leaked in the same shape, "the enumeration did not follow the change in the set."

### 2.4. Least Privilege & Separation of Duties (SoD)

-   **Rule 67.2.6 (Least Privilege)**: Constrain roles and policies to the minimum necessary actions. Limit wildcard (`*`) privileges to high-risk uses only, and record justification and expiry when granting them.
-   **Rule 67.2.7 (Separation of Duties / SoD)**: Design so that no single principal can **complete operations requiring mutual checks alone** (e.g., separate requester from approver, separate payment creator from approver). Express SoD constraints declaratively in policy.
-   **Rule 67.2.8 (Make Privilege Escalation Temporary)**: Avoid standing high-privilege grants; escalate only when needed (Just-In-Time) and auto-expire afterward. Combine privileged operations with Step-Up authentication (420).

---

## §3. Authorization Model Selection & Progressive Escalation

### 3.1. RBAC (Role-Based Access Control)

-   **Overview**: Assign **roles** to principals and bind **permissions** to roles. The `user → role → permission` indirection simplifies privilege management.
-   **Fit**: Organizations with few roles where privileges can be expressed **by category** rather than per-resource-instance. Easiest to understand and audit.
-   **Limit**: Instance-level / relationship-based controls such as "edit only documents I created" or "view only within the same tenant" cause **role explosion**.

### 3.2. ABAC (Attribute-Based Access Control)

-   **Overview**: Evaluate **attributes** of subject, resource, action, and environment (e.g., `subject.department == resource.owner_department && env.time in business_hours`).
-   **Fit**: Fine-grained, context-dependent control (time, location, device, data sensitivity). Expresses conditions that RBAC cannot capture as attribute expressions.
-   **Limit**: Hard to reverse-index ("who can access this resource"). Policies tend to grow complex, raising audit and testing burden.

### 3.3. ReBAC (Relationship-Based Access Control)

-   **Overview**: Represent the **relationships (relations)** between subjects and resources as a graph and decide based on relationship existence/transitivity (e.g., `user is editor of doc`, `doc is in folder that user is viewer of`). Google Zanzibar is the representative design (§4).
-   **Fit**: Document sharing, org hierarchies, nested resources, group membership. Naturally expresses **transitive/hierarchical access** such as "an editor of a folder can also edit files within it."
-   **Limit**: Requires managing consistency/freshness of relationship data (tuples). Needs a dedicated authorization data store (OpenFGA / SpiceDB).

### 3.4. PBAC (Policy-Based Access Control)

-   **Overview**: A comprehensive approach that externalizes authorization rules in a **declarative policy language** (Cedar / Rego, etc.) and manages them as Policy as Code. RBAC, ABAC, and ReBAC elements can be combined within policy.
-   **Fit**: Organizations mixing multiple models that require formal verification, testing, and version control. Connects directly to Policy as Code in §5.

### 3.5. Selection Criteria & Progressive Escalation Path

-   **Rule 67.3.1 (Start from the Minimal Sufficient Model)**: Start from the **simplest model** that meets requirements (MUST). Do not adopt an overly complex model up front. RBAC if RBAC suffices; ABAC when context conditions are needed; ReBAC when the relationship graph is essential.

| Decision Criterion | Recommended Model |
|:-------------------|:------------------|
| Privileges expressible as "category × role" with few instance-level exceptions | **RBAC** |
| Decisions need context/attributes (time, location, data sensitivity, affiliation) | **ABAC** (add attributes to RBAC) |
| "Sharing," "hierarchy," "membership," "transitive access" are central | **ReBAC** (Zanzibar family) |
| Mixing multiple models, prioritizing formal verification & auditability | **PBAC** (unify via Cedar / Rego) |

-   **Rule 67.3.2 (Progressive Escalation)**: Escalate models (RBAC → ABAC → ReBAC) **progressively through a centralized policy layer** (§6). If decisions are scattered across the app, escalation requires rewriting every code path, sharply raising migration risk.
-   **Rule 67.3.3 (Allow Mixing)**: Avoid dogmatism about a single model. It is fine to **combine** coarse-grained RBAC (roles) with fine-grained ReBAC (resource sharing). What matters is that decisions are consolidated into the centralized layer.

---

## §4. ReBAC / Google Zanzibar Pattern

> **Reference**: Google Zanzibar paper (2019), OpenFGA (CNCF Incubating), SpiceDB (authzed)

### 4.1. Relation Tuples

-   **Relation Tuple**: The smallest unit of ReBAC. In the form `⟨object⟩#⟨relation⟩@⟨subject⟩`, it expresses "object is in `relation` to subject" (e.g., `document:roadmap#editor@user:anne`).
-   **Rule 67.4.1**: Manage the authorization model (type/relation definitions) and the data (tuples) separately. Version-control the type definitions and update tuples only via the write API. Avoid having the app write the authorization DB's tables directly.

### 4.2. Transitive & Hierarchical Access

-   **Overview**: ReBAC expresses **composition/inheritance** of relations. As in "a user holding `folder:x#viewer` can also view `document:y` where `document:y#parent@folder:x`," relations are evaluated transitively.
-   **Rule 67.4.2 (Bound the Transitive Evaluation)**: Transitive/hierarchical evaluation increases latency and cost as depth/breadth grow. Set a maximum evaluation depth and timeout to avoid unbounded graph traversal (see §9 Performance).

### 4.3. OpenFGA (CNCF Incubating)

-   **Overview**: An open-source authorization system based on Zanzibar. A **CNCF Incubating** project. Define types and relations in a DSL (authorization model) and decide via the `check` / `list-objects` / `list-users` APIs.
-   **Rule 67.4.3**: When adopting OpenFGA, **version-control the authorization model (`.fga` / JSON) as code** and run model tests (expected `check` results) in CI. Roll out model changes progressively.

### 4.4. SpiceDB (Tunable Consistency / Freshness)

-   **Overview**: An authorization system based on Zanzibar (authzed). Its **ZedToken**, the equivalent of Zanzibar's **Zookie** (consistency token), lets you **tune decision freshness (consistency) per call**.
-   **Consistency levels**: `minimize_latency` (fastest, tolerates slightly stale data) / `at_least_as_fresh` (guarantees freshness at or after the given ZedToken) / `fully_consistent` (guarantees latest, highest cost).
-   **Rule 67.4.4 (Prevent the New Enemy Problem)**: To avoid the "New Enemy Problem" where a grant passes against a stale cache right after revocation, **strengthen freshness for sensitive operations** (`at_least_as_fresh` or higher). For general reads, allow `minimize_latency` and prioritize latency (see §6.4, §9).

---

## §5. Policy as Code

> **Law**: Externalize, version-control, and test authorization policy **as code** (PBAC). The goal is a state where policy can be changed and audited independently of app deploys.

### 5.1. AWS Cedar + Amazon Verified Permissions

-   **Cedar**: An open-source authorization policy language developed by AWS. It guarantees **deny-by-default** and **deny-overrides** (forbid wins) in its semantics and is designed for **formal verification**. It can express RBAC and ABAC in the same language.
-   **Amazon Verified Permissions (AVP)**: A managed PDP service that runs Cedar. It provides a policy store and an evaluation API (`isAuthorized`).
-   **Rule 67.5.1**: When adopting Cedar, write `permit` / `forbid` explicitly, expressed via the principal-action-resource triple and conditions (`when` / `unless`). Use **forbid as an exceptional override of permits** (deny-overrides).
-   Formal-verification tooling (Cedar policy analysis) can statically detect policy contradictions, unreachable rules, and over-permission.

### 5.2. OPA / Rego (K8s / Infrastructure)

-   **OPA (Open Policy Agent)**: A **CNCF Graduated** general-purpose policy engine. Write policy in the **Rego** language and return decisions over JSON input. Widely used at the **infrastructure/platform layer** — Kubernetes (Admission Control / Gatekeeper), Terraform, API gateways, inter-microservice authorization.
-   **Rule 67.5.2**: When adopting OPA, **unit-test** Rego policies (`opa test`) and fix the input contract (schema). Manage distribution, signing, and versioning of policy bundles.

### 5.3. Cedar vs OPA: When to Use Which

| Axis | Cedar (+ AVP) | OPA / Rego |
|:-----|:--------------|:-----------|
| **Primary use** | Application authorization (user → resource) | Infrastructure/platform authorization (K8s, IaC, gateways) |
| **Model affinity** | Concisely expresses RBAC / ABAC | General-purpose (any JSON decision); high expressive freedom |
| **Formal verification** | Yes (at the language-design level) | Limited (test-centric) |
| **deny semantics** | Guarantees deny-overrides | Author-defined (no default; must be explicit) |
| **Managed** | Amazon Verified Permissions | Mostly self-hosted (various managed derivatives exist) |

-   **Rule 67.5.3 (When to Use Which)**: Make **Cedar/AVP or ReBAC (OpenFGA/SpiceDB) the first choice for in-app user↔resource authorization**, and **OPA/Rego for infrastructure authorization** (K8s/IaC/gateways). The two are not mutually exclusive; combine them per layer as appropriate.

---

## §6. Externalizing Authorization

### 6.1. No Scattered In-App `if` Checks

-   **Rule 67.6.1 (No Scattering)**: Authorization decisions MUST NOT be **scattered as inline branches** like `if (user.role === 'admin')` inside business logic (detailing 000 §4.5 Guardian Protocol). Delegate decisions to a centralized guard or an external PDP.
-   Scattering causes (a) gaps (forgetting a check on one path), (b) inconsistency (the same decision differing per path), and (c) difficulty escalating the model (refactoring every code path).

### 6.2. Centralized Policy Store & Centralized Guards

-   **Rule 67.6.2 (Centralize)**: Consolidate authorization decisions into a **centralized policy store (PDP)**, and have each path call the PDP from a thin PEP (guard function / middleware) (MUST).
-   **Rule 67.6.3 (Role SSOT)**: Define a single source of truth for roles/permissions in one place. Frontend flags or legacy tables MUST NOT be the basis for authorization (consistent with 000 §4.5). Frontend privilege display is a UX convenience; the server-side PEP's decision is always the final authority.
-   **Guard-Exempt Zone Discipline (Placement of Privilege-Acquiring Screens)**: Never place a screen whose purpose is to **acquire** a privilege (invitation acceptance, first-run onboarding, permission request, contract consent) under the centralized guard (layout etc.) that requires that privilege (MUST NOT). A screen that must pass in a zero-privilege state placed under the requiring guard dies structurally through circular dependency. Separate it with a mechanism that does not change the URL (route group etc.), preferring that over per-page opt-in guards. Once a guard-exempt zone exists, enumerate every page and add a structural gate that enforces "under the guard, or in an exact-match allowlist of guard-exempt pages," paired with a lower-bound assert that prevents a false pass on a zero-result scan (MUST). Pin the guard-exempt zone's single authentication boundary with a contract test, and run the source scan with comments excluded (a raw read gives a false pass on the guard name inside a comment).
-   **Config Reader Consistency (Deciders That Read the Same Setting Must Agree)**: When you add or change a setting such as "verified by operations" or "trusted IP," enumerate the components that read it (intake control, abuse score, alerting, ledger) and confirm that no decider that does not read it reaches the opposite conclusion on the same input (MUST). Even when each one's tests are green, without a check that asks "do the two decisions agree" the contradiction passes straight through (failure pattern: trusted IPs were "not held," yet the alert fired every night and a human closed it by hand). Treat an alert that fires daily and is closed by hand as a sign of a design contradiction, not operations, and fix it by aligning the deciders rather than tuning thresholds (SHOULD). Widening an exception list reduces per-event alerts, so make changes to the exception list themselves an audit-log (before/after) and alert target, and detect an exception added through an account takeover at that moment (SHOULD).
-   **Self-Lockout Pre-Check (Validate Before Saving a Setting That Can Lock You Out)**: For settings that apply access restrictions, roles, or permissions to the saver as well, verify before saving that "the saver still passes after it applies," using **the same function as the decision side** (MUST). A separate implementation creates a second SSOT, where one side gets fixed and the other is "assumed protected." Match the fail-open conditions to the decision side too; do not reject recoverable modes (passable via step-up), only an irreversible lockout. In tests, do not mock the decision system — swap only the input retrieval. Failure pattern: only "who may save" was protected, and "what may be saved" went unchecked.
-   **Allowlist Resolution-Chain Parity (Same Set as the Caller's SSOT Chain)**: Before adding an allowlist check, read how the caller resolves that value (DB → environment-variable fallback etc.) and build the allowed set from every path of that same chain (MUST). Verify data-state-dependent checks by measuring the real DB's current values (type checks, lint, and unit tests pass straight through). The regression test covers three points: "fallback survives + invalid value rejected + fail-safe." When a migration turns a default-false security flag ON, confirm that the seed does not rebuild the same table with DELETE+INSERT and silently roll it back to false. Failure pattern: with the DB-side value NULL in every row, the allowlist was pinned to the DB source and every legitimate purchase was rejected.

### 6.3. Decision Log (Auditability)

-   **Rule 67.6.4 (Decision Logging)**: Every authorization decision MUST be recordable as a **structured decision log**. At minimum, retain "subject, action, resource, decision result, applied policy, context, timestamp." Mask PII (consistent with 000 §7.4).
-   Decision logs serve (a) blast-radius identification during incidents, (b) discovery of excess privilege, and (c) compliance audit. Feed deny records to ITDR (000 §3.3) as an attack-detection signal.

### 6.4. Consistency / Freshness Requirements

-   **Rule 67.6.5 (Propagate Privilege Changes)**: Propagate revocations and role changes to the PDP/cache **promptly**. Make the trade-off with cache TTL explicit, and strengthen freshness for sensitive operations (§4.4, §9).
-   **Rule 67.6.6 (fail-closed)**: If the query to the PDP/policy store fails or times out, **fall to the deny side** (fail-closed) (MUST). MUST NOT fall back to allow for the sake of availability (only when a high-availability-critical, limited path explicitly permits brief use of the most recent cached decision by policy).
-   **Rule 67.6.7 (Proof Obligation and No-Silence Rule When Choosing fail-open)**: A defensive gate made fail-open for availability (suspicious-IP blocking, breached-password lookup, new-device notification, etc.) means "pass through on error" — the defense can be **silently disabled** and nobody notices. If you choose it: (a) prove the behavior against the real endpoint / real query, not a mock (a state where a syntax error always falls to ALLOW cannot be detected by a unit mock); (b) make external calls explicit about UA etc. to prevent a future silent cut-off by the provider; (c) for decisions that depend on "the preceding history," fetch it synchronously before writing the current record and pin that order with a test; (d) exclude the gate's own writes from the aggregate to cut self-amplification (the window keeps sliding after the attack stops) (MUST).
    -   An implementation that swallows an error and returns empty collapses missing privileges, missing functions, and argument mismatches into "0 results." If you swallow it, make the fact that you swallowed it observable in metrics/logs (MUST).
    -   Never leave the old signature of a defensive function (lockout, rate limit, verification) as a deprecated stub that returns "always allow" (MUST NOT). If the caller is fail-open the outcome is the same and only the records grow, so make a deprecated stub fail explicitly and route it to an alert path. In APIs that resolve overloads by argument name (PostgREST RPC etc.), a call that drops an argument does not error but resolves to the old version, so on deprecation DROP the old signature or make it fail (MUST). When changing a contract (signature, return value), decide first where the guarantee the existing tests protected will go (MUST). Accept shared-IP false blocks via conservative thresholds, a break-glass setting, and layering (per-account lock / rate limit).
    -   When the same decision (suspension, lock, revocation, rate limit) is scattered across multiple guards, check for its presence in descending order of privilege (MUST). Defenses are written where the pain is, so they start from the weak side and the most privileged guard is the last to be missing. When the IdP's ban does not revoke already-issued access tokens, evaluate the ban state in the guard on every call (no extra cost when the value is already in the auth response).

---

## §7. OAuth Integration & API Authorization

> **Reference Standards**: RFC 9396 (RAR), RFC 9126 (PAR), OWASP API Security Top 10. OAuth token-acquisition flow detail is delegated to 410, delegation detail to 440.

### 7.1. Scope Design

-   **Rule 67.7.1 (Coarse Scope + Fine-Grained authZ)**: Keep OAuth scopes at **coarse-grained access divisions** (e.g., `documents.read` / `documents.write`), and perform **instance-level fine-grained decisions on the resource server's authZ** (the models in this file) (MUST). Do not try to express "may access this specific resource" with scope alone.
-   Request scopes with least privilege and avoid over-scoped consent prompts. Manage the mapping between scopes and internal permissions centrally.

### 7.2. RAR (RFC 9396 authorization_details)

-   **Overview**: **Rich Authorization Requests (RAR)** express **fine-grained authorization requests** that coarse scopes cannot, via `authorization_details` (a JSON structure). For example, structure the type, target, and limit as in "permission to transfer 100 USD from account A."
-   **Rule 67.7.2**: For authorizations where scope granularity is insufficient — financial transactions, permissions limited to a specific resource — express them with RAR (`authorization_details`). The resource server verifies `authorization_details` and permits only the specific requested operation.

### 7.3. PAR (RFC 9126)

-   **Overview**: **Pushed Authorization Requests (PAR)** send the authorization request parameters to the authorization server **over the back channel in advance** and pass only a `request_uri` reference over the front channel. This mitigates request tampering, parameter leakage, and URL length limits. Combined with RAR, it safely transmits `authorization_details`.
-   **Rule 67.7.3**: For high-assurance APIs and financial-grade (FAPI-family) authorization, adopt PAR to ensure the integrity of the authorization request. For detailed flow implementation, see 410 / 440.

### 7.4. API Authorization: Preventing BOLA / BFLA

> OWASP API Security Top 10's API1 (BOLA) and API5 (BFLA) are the most frequent vulnerabilities, both stemming from authorization flaws.

-   **BOLA (Broken Object Level Authorization)**: The flaw of returning an object by ID alone (e.g., `/orders/123`) without verifying **the requester's access right to that object**. The superset concept of IDOR.
-   **Rule 67.7.4 (Enforce Object-Level Authorization)**: At every object-reference endpoint, verify **whether the requesting subject may access that object**, per object (MUST). Do not rely on IDs being unguessable/sequential. Apply the equivalent of ReBAC's `check(user, view, object)` to all retrieval paths.
-   **BFLA (Broken Function Level Authorization)**: A missing per-function/endpoint privilege check (e.g., a regular user can hit the admin-only `DELETE /admin/users/123`).
-   **Rule 67.7.5 (Enforce Function-Level Authorization)**: For admin/privileged-function endpoints, do not merely hide them in the UI — **enforce function-level authorization at the server-side PEP** (MUST). Do not rely on "safe if you don't know the URL" (security by obscurity).
-   **Rule 67.7.6 (Prevent Mass Assignment)**: Authorization-relevant attributes (`role` / `is_admin` / `tenant_id`) MUST NOT be overridable by client input. Explicitly allowlist the permitted input fields.
-   **Rule 67.7.7 (Server-Decided Values Are Protected by Role)**: Values the server should decide — tier, status, role, owner ID, rating aggregates — **are protected not by the correctness of how they are computed but by narrowing which principal (role) can write that column** (MUST). In a setup where clients write to the DB directly (PostgREST / GraphQL etc.), as long as the app writes with the same role, the DB cannot distinguish a legitimate write from a direct API call. A "guard that only looks at state transitions" lets through an update that leaves the state alone and swaps the contents (URL, parent ID, aggregate). Do not pick protected columns by name regex; pin the writable columns as a per-table set (MUST). Check privileges per column (`has_any_column_privilege` or equivalent), not per table (`has_table_privilege`), since the latter misreports a state where only column GRANTs remain as "no privilege" (SHOULD). Failure pattern: the top tier could be self-issued without payment.
-   **Rule 67.7.8 (Rejection Branches on Optional-Auth Paths)**: Authentication resolution for operations that can also run anonymously (posting, commenting, uploading) MUST return a type that distinguishes "genuinely no session," "suspended account," "invalid credentials," and "auth infrastructure failure," and MUST NOT collapse the latter three into anonymous. Handle the rejection before ever touching `user`, and never proceed to Storage, privileged DB, or external verification with an unresolved auth check (fail-closed). First-party APIs MUST distinguish 401 (unauthenticated), 403 (suspended/rejected), 404 (target missing), and 503 (auth/DB failure), and MUST NOT steer a 503 to re-login. Do not return external (IdP) error bodies in responses or notifications. Because the IdP's HTTP status alone may not distinguish "invalid token" from "suspended," prefer the SDK's fixed error codes for classification and pin the classification with an integration test that goes through the real IdP (SHOULD). Failure pattern: the auth helper's null meant both "anonymous" and "rejected," so a suspended user could post as anonymous and an infrastructure failure sent users to the login screen.
-   **Rule 67.7.9 (Compare Membership Structurally)**: Treat `startsWith` or raw string equality in code that decides "belongs to / owned by / same as" as suspect (MUST). Compare URLs by the origin triple (scheme+host+port), IPs as byte sequences (restore IPv4-mapped IPv6, strip ports, normalize leading zeros), and keys/paths as structures. When a LIKE/glob prefix can contain metacharacters (`%` `_`) from external input or naming conventions, reject rather than escape and pass (SHOULD). Check what sits on the failure side of the decision (especially when a misclassification such as "internal = no guard" directly disables the defense). Treat normalization failure asymmetrically: on the permit-decision side, unparseable → avoid a false block; on the configuration-entry side, fail-closed (a misconfiguration must not allow everything). Include "a different domain with a suffix appended," "a prefix containing metacharacters," "IPv4-mapped IPv6," and "with port" in mutation tests (MUST). Failure pattern: `own-host.example.com` was classified as "internal" and skipped the guard, and an administrator IP in IPv4-mapped notation failed to match the allowlist and was locked out.
-   **Cross-Reference**: `engineering/100_api_integration.md` (API design & contracts)

---

## §8. Multi-Tenant Authorization

### 8.1. Tenant Isolation & Privilege Boundaries

-   **Rule 67.8.1 (Mandatory Tenant Boundary)**: In multi-tenant systems, include `tenant_id` as an **inseparable precondition of every authorization decision** (MUST). Verify both "may access the resource" and "belongs to the same tenant." Deny cross-tenant access by default.
-   **Rule 67.8.2 (Trust Source of tenant_id)**: `tenant_id` MUST be **derived server-side from the authenticated context**. Do not trust a client-supplied `tenant_id` as-is (the classic cross-tenant attack).
-   **Rule 67.8.3 (Hierarchy of Privilege Boundaries)**: Clarify the hierarchy "system admin → tenant admin → in-tenant roles," and guarantee a boundary so that a tenant admin cannot escalate to the whole system or other tenants.

### 8.2. Row-Level Security (RLS) Integration

-   **Rule 67.8.4 (RLS as Defense in Depth)**: In addition to the app-layer PEP, use the database's **row-level security (RLS) as a last line of defense** (SHOULD). Even if the app-layer authorization has a gap, the DB enforces the tenant/owner boundary.
-   **Rule 67.8.5 (Align RLS with the PDP)**: To keep RLS policies and app-layer PDP decisions from **contradicting** each other, derive the tenant/owner decision criteria from a common SSOT. It is fine to split roles — RLS for coarse-grained boundaries (tenant, owner), PDP for fine-grained ones (sharing, relationships).
-   **Rule 67.8.6 (Derived Tables Inherit Visibility)**: When visibility (draft, hidden, scheduled publication, deleted) lives on the parent entity, the read policy of every child, translation, junction, aggregate, or derived table MUST **carry the parent's visibility check itself**. The parent table returning 0 rows to anonymous is not grounds for the derived table's safety. The exposure never appears in the app's screens (screens fetch the parent first), so test by hitting every table reachable by the anonymous role directly, across the board (MUST). Implementation detail: `engineering/200_supabase_architecture.md` Rule 2.15.
-   **Rule 67.8.7 (SSOT Effectiveness and Namespace Separation)**: Once an allowed set is pinned by "a definition table + a test that checks the table," add a separate test verifying that the table actually governs the implementation (the real arguments the implementation passes downstream match the table) (MUST). A table→table test stays green even when the implementation ignores the table. When the same concept has two ledgers (DB column blocking vs. a DTO exclusion list, the logger's sensitive keys vs. the error tracker's scrub patterns, etc.), add a reconciliation test that reads one side's expected set and asserts the other side's behavior, and confirm a negative control that goes red before the fix (MUST). Apply the fix downstream (RPC side), not only at the caller. Conversely, values that compare different things (the DB-layer role column vs. the app-layer admin-role table, etc.) MUST be separate constants even when spelled identically, and intentionally shared spellings are shared by reference. Matching two namespaces with one constant lets one side's values flow into the other's allowed set and produces a "configured, yet nothing happens" state.
-   **Cross-Reference**: `engineering/200_supabase_architecture.md` (PostgreSQL RLS policy implementation detail)

---

## §9. Cross-Cutting Perspectives

### 9.1. Observability

-   **Rule 67.9.1**: Turn authorization decisions into metrics (allow/deny rate, decision latency p50/p99, per-policy hit count, deny-reason distribution). Detect anomalies — deny spikes, large numbers of denies from a particular subject — and feed them to ITDR (000 §3.3). Together with the decision log (§6.3), continuously inventory excess and unused privileges.

### 9.2. FinOps

-   **Rule 67.9.2**: Managed authorization engines (AVP, authzed Cloud, etc.) are often **billed per decision request / per stored tuple**. N+1-style sequential checks (one `check` per row in a list view) amplify cost and latency. Use `list-objects` / batch checks and appropriate caching to contain cost (the trade-off with freshness is §4.4).

### 9.3. Performance & Scalability

-   **Rule 67.9.3 (Authorization Latency)**: Authorization decisions sit on the hot path and add to every request. Set a decision-latency target (e.g., single-digit to low-double-digit ms at p99) and contain latency via (a) caching decision results, (b) batch decisions for list operations (`list-objects`), and (c) embedded/sidecar PDP placement.
-   **Rule 67.9.4 (Cache vs Freshness Trade-off)**: Caching improves performance but reduces freshness. Switch by operation risk: **prioritize freshness for sensitive/destructive operations (short-lived cache or bypass) and latency for general reads** (§4.4, §6.4).
-   **Rule 67.9.5 (Scalability)**: Authorization data (tuples/attributes) and decisions grow in proportion to service growth. Dedicated authorization stores (OpenFGA/SpiceDB) are designed for horizontal scale. Continuing to piggyback authorization decisions on the app DB becomes a bottleneck.

### 9.4. Zero Trust Integration

-   **Rule 67.9.6**: Zero Trust eliminates "inside the network = trusted" and **authorizes every access per request**. Incorporate authentication signals (factor strength, device posture, risk score) into the authorization context, and narrow grants / require Step-Up (420) according to risk (see 000 §2).

### 9.5. Privacy (Purpose Limitation)

-   **Rule 67.9.7 (Purpose Limitation)**: Authorization can include not only "whether the privilege exists" but also **the purpose of access** as a decision factor. Consider purpose-based access — varying allow/scope for the same data by purpose (support handling vs analytics) — for regulated data (100_data_governance). Record the purpose in the decision log to make off-purpose use auditable.

---

## §10. Implementation Snippets

> The following are **minimal representative examples** of each approach. In a real stack, use a maintained engine/library and conform to this file's MUST requirements (deny-by-default, centralization, decision log).

### 10.1. OpenFGA Authorization Model Example

```dsl
# ✅ OpenFGA authorization model (ReBAC over document / folder)
model
  schema 1.1

type user

type folder
  relations
    define viewer: [user]

type document
  relations
    define parent: [folder]
    define editor: [user]
    # a viewer of the folder can also view the document (transitive access)
    define viewer: [user] or editor or viewer from parent
```

```
# Relation tuple example: anne is an editor of roadmap
document:roadmap#editor@user:anne
# check(user:anne, viewer, document:roadmap) => allowed (derived from editor)
```

### 10.2. AWS Cedar Policy Example

```cedar
// ✅ Cedar: deny-by-default. If no permit matches, deny.
permit (
  principal,
  action == Action::"viewDocument",
  resource
)
when {
  // same tenant and owner (least privilege)
  principal.tenant == resource.tenant &&
  resource.owner == principal
};

// forbid overrides permit (deny-overrides) — a suspended user is always denied
forbid (principal, action, resource)
when { principal.status == "suspended" };
```

### 10.3. OPA / Rego Example

```rego
# ✅ OPA/Rego: deny by default, allow only on explicit allow
package authz

default allow := false

allow if {
    input.subject.role == "editor"
    input.resource.tenant == input.subject.tenant   # tenant boundary
    input.action == "write"
}
```

### 10.4. Centralized Guard Function (PEP → PDP)

```typescript
// ✅ A PEP that delegates the decision to a centralized PDP and records it to the decision log
import { pdp } from '@/lib/authz/pdp';        // centralized policy decision (thin wrapper over Cedar/OpenFGA, etc.)
import { auditAuthz } from '@/lib/authz/audit';

export async function authorize(
  subject: Subject, action: string, resource: Resource, ctx: Context,
): Promise<void> {
  // derive tenant_id from the authenticated context (do not trust client input)
  const decision = await pdp.check({ subject, action, resource, tenant: ctx.tenant });
  auditAuthz({ subject: subject.id, action, resource: resource.id, decision, ctx }); // decision log
  if (!decision.allowed) throw new ForbiddenError(); // deny-by-default / fail-closed
}
```

-   **Consume the Decision**: A guard is not effective merely because it was "called." Either the decision function itself throws, as above, or it returns a discriminated union (`{ proceed: true } | { proceed: false, reason }`) so the caller cannot type-check without inspecting `proceed` (MUST). The shape "return only on error" that falls through to the main operation on success (e.g., a successful OTP issuance flowing into INSERT/UPDATE) is prohibited. An existence check (`if (!otp)`) is not verification; call the verification function and branch on its result. An unimplemented stub mutation returns an explicit error, not a `{ success: true }` no-op (MUST; it fabricates a false success and a false audit row). In audits, mechanically enumerate the call sites of decision functions and detect those that do not branch on the return value. A claim that "every mutation is guarded" uses as its denominator a mechanical enumeration of exported mutation functions (naming prefix etc.), not a manual walk of UI entry points, and when a function of the same name exists in several files, checks every import site to identify the real caller (MUST; failure pattern: the guard was added to the orphan with zero callers while the live path stayed unprotected through two rounds of fixes).

---

## §11. Anti-Patterns

| # | Anti-Pattern | Correct Approach |
|:--|:-------------|:-----------------|
| 1 | Treating authentication success as a substitute for authorization (logged in = may operate) | Separate authN and authZ; authorize every access (§1.1, §2.1) |
| 2 | Scattering `if (user.role === 'admin')` across all code | Consolidate into a centralized guard / external PDP (§6.1) |
| 3 | allow-by-default (blocklist approach) | Enforce deny-by-default (§2.3) |
| 4 | Basing authorization on frontend flags / legacy tables | Make the server-side SSOT the single source of truth (§6.2) |
| 5 | Returning by object ID alone (BOLA / IDOR) | Verify ownership/sharing per object (§7.4) |
| 6 | Merely hiding admin endpoints in the UI | Enforce function-level authorization server-side (§7.4) |
| 7 | Trusting a client-supplied `tenant_id` | Derive it from the authenticated context (§8.1) |
| 8 | Expressing fine-grained resource authorization with scope alone | Coarse scope + resource-side authZ (§7.1) |
| 9 | Allowing access on a stale cache after revocation (New Enemy Problem) | Strengthen freshness for sensitive operations (§4.4, §6.4) |
| 10 | Falling back to allow on PDP failure | fail-closed (fall to deny) (§6.6) |
| 11 | Not logging authorization decisions | Record a structured decision log (§6.3) |
| 12 | Forcing instance-level control into RBAC (role explosion) | Progressively escalate to ReBAC/ABAC (§3) |
| 13 | Adopting an overly complex model from the start | Start from the minimal sufficient model (§3.5) |
| 14 | Granting wildcard (`*`) privileges permanently | Least privilege + temporary escalation (JIT) (§2.6, §2.8) |
| 15 | Letting a requester approve their own request | Enforce separation of duties (SoD) declaratively (§2.7) |
| 16 | Authorization attributes (role/tenant) overridable via mass assignment | Allowlist input fields (§7.6) |
| 17 | App layer only, no defense in depth | Use RLS as a last line of defense (§8.4) |
| 18 | RLS and app PDP decisions contradicting each other | Derive decision criteria from a common SSOT (§8.5) |
| 19 | Sequential per-row checks in a list view (N+1) | `list-objects`/batch check + caching (§9.2, §9.3) |
| 20 | Not code-managing the authorization model; editing prod directly | Policy as Code + CI tests (§5, §4.3) |
| 21 | Defining a boundary by naming elements, missing the ones added later | Define as a set + default polarity, pinned by a two-way ratchet (§2.3 67.2.9) |
| 22 | Collapsing suspension, invalid credentials, or infrastructure failure into "anonymous" on optional-auth paths | Distinguish rejection kinds by type, fail-closed, never steer 503 to re-login (§7.4 67.7.8) |
| 23 | Deciders that read the same setting (trusted IP etc.) reaching opposite conclusions | Enumerate the setting's readers and pin decision agreement with tests; audit and alert on exception-list changes (§6.2) |
| 24 | Claiming "every mutation is guarded" from a manual walk of UI entry points | Use a mechanical enumeration of exported functions + caller verification for same-named functions as the denominator (§10.4) |
| 25 | Deciding IP/URL/domain membership with `startsWith` / raw string equality | Compare structurally (origin triple, normalized bytes) and include suffixed look-alike domains in mutation tests (§7.4 67.7.9) |
| 26 | Testing only the allowed-set definition table, never whether the implementation references it | Check the real arguments passed downstream and reconcile ledgers by behavior (§8.2 67.8.7) |
| 27 | Not validating a self-lockout-capable setting (IP restriction, role) before saving | Verify the saver still passes with the same function as the decision side; block only irreversible lockouts (§6.2) |
| 28 | Suspension/revocation checks present only in weak guards, absent from the most privileged one | Check in descending order of privilege; if the IdP ban does not revoke issued tokens, evaluate in the guard each time (§6.4 67.6.7) |
| 29 | Building an allowlist check from a different set than the caller's SSOT resolution chain (DB ∪ env fallback) | Build the allowed set from every path of the same chain and measure data-state-dependent checks against the real DB (§6.2) |

---

## §12. Maturity Model L1–L5

| Level | State | Characteristics |
|:------|:------|:----------------|
| **L1: Initial** | Authorization scattered in code; allow-by-default tendency | Role checks inconsistent per path. High BOLA/BFLA risk. No decision log |
| **L2: Managed** | RBAC introduced; role SSOT consolidated in one place | Role checks on admin APIs. Deny-by-default awareness. Basic audit log |
| **L3: Defined** | Decisions consolidated into a centralized guard/PDP; object-level authorization | BOLA/BFLA prevented on all paths. Tenant boundary enforced. Decision log in place |
| **L4: Policy-Driven** | Policy as Code (Cedar/OPA) or ReBAC (OpenFGA/SpiceDB) adopted | Policies CI-tested/formally verified. Freshness controlled by operation risk. Least privilege & SoD enforced declaratively |
| **L5: Adaptive Zero Trust** | Authorization integrated with authentication signals/risk score | Every access evaluated per request. Purpose limitation & continuous verification. Excess privilege continuously inventoried via authorization metrics |

-   **Rule 67.12.1**: Assess your current position and aim for **at least L3** as the target. Services handling multi-tenant/privileged/regulated data should target L4 or higher.

---

## Appendix A: Quick Reference Index

> A reverse index the AI uses when partially loading this file.

| Keyword | Section |
|:--------|:--------|
| authN vs authZ / separating authentication & authorization / division of responsibility | §2.1 |
| PDP / PEP / PIP / PAP / XACML | §2.2 |
| deny-by-default / deny-overrides / fail-closed | §2.3, §6.6 |
| least privilege / separation of duties / SoD / JIT escalation | §2.4 |
| RBAC / role explosion | §3.1 |
| ABAC / attribute-based / context-dependent | §3.2 |
| ReBAC / relationship-based / graph | §3.3, §4 |
| PBAC / policy-based | §3.4 |
| model selection / progressive escalation / mixing | §3.5 |
| Relation Tuple / Zanzibar | §4.1 |
| transitive / hierarchical access | §4.2 |
| OpenFGA / CNCF Incubating / .fga | §4.3 |
| SpiceDB / ZedToken / tunable consistency / freshness / New Enemy Problem | §4.4 |
| Policy as Code | §5 |
| Cedar / Amazon Verified Permissions / formal verification | §5.1 |
| OPA / Rego / Kubernetes / Gatekeeper | §5.2 |
| Cedar vs OPA when to use which | §5.3 |
| externalizing authorization / no scattered if / Guardian Protocol | §6.1, §6.2 |
| role SSOT | §6.2 |
| decision log / decision logging / auditability | §6.3 |
| consistency / freshness / privilege propagation | §6.4, §4.4 |
| OAuth scope design / coarse-grained | §7.1 |
| RAR / RFC 9396 / authorization_details | §7.2 |
| PAR / RFC 9126 | §7.3 |
| BOLA / IDOR / object-level authorization | §7.4 |
| BFLA / function-level authorization | §7.4 |
| mass assignment / preventing role override | §7.4 |
| multi-tenant / tenant isolation / tenant_id | §8.1, §8.2 |
| row-level security / RLS / defense in depth | §8.2 |
| observability / authorization metrics | §9.1 |
| FinOps / authorization engine billing / caching | §9.2 |
| authorization latency / performance / list-objects | §9.3 |
| cache vs freshness trade-off | §9.4 |
| scalability | §9.5 |
| Zero Trust authorization | §9.4 |
| privacy / purpose limitation / purpose-based | §9.5 |
| implementation snippets / OpenFGA / Cedar / Rego / centralized guard | §10 |
| anti-patterns | §11 |
| maturity model / L1-L5 | §12 |

---

**Cross-Reference (Related Rules):**
-   `security/000_security_privacy.md` — §4.5 RBAC/ABAC design, §4.6 RBAC Defense Protocol (upper-level policy / summary for this file)
-   `security/400_authentication_and_passkeys.md` — Authentication (credentials, passkeys, MFA). Establishing the identity that authorization presupposes
-   `security/410_federated_identity_and_oauth.md` — OAuth 2.1 / OIDC / SAML federation, token-acquisition flows
-   `security/420_step_up_auth_and_sensitive_operations.md` — Step-Up authentication, re-authentication for privileged operations (interfaces with authorization's high-risk paths)
-   `security/440_workload_and_agent_identity.md` — Delegated authorization, token exchange, on-behalf-of, delegated-scope detail
-   `engineering/100_api_integration.md` — API design & contracts (implementation context for BOLA/BFLA prevention)
-   `engineering/200_supabase_architecture.md` — PostgreSQL row-level security (RLS) implementation detail

### Cross-References

| Section | Related Rules |
|---------|---------------|
| §2–§3 (Division of responsibility & model selection) | `security/000_security_privacy` (§4.5, §4.6) |
| §4–§5 (ReBAC & Policy as Code) | `security/000_security_privacy` (§4.5), `engineering/100_api_integration` |
| §7 (OAuth integration & API authorization) | `security/410_federated_identity_and_oauth`, `security/440_workload_and_agent_identity` |
| §8 (Multi-tenant & RLS) | `engineering/200_supabase_architecture` |
| §9 (Cross-cutting perspectives) | `security/420_step_up_auth_and_sensitive_operations`, `security/100_data_governance` |
