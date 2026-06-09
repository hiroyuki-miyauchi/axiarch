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

### 6.3. Decision Log (Auditability)

-   **Rule 67.6.4 (Decision Logging)**: Every authorization decision MUST be recordable as a **structured decision log**. At minimum, retain "subject, action, resource, decision result, applied policy, context, timestamp." Mask PII (consistent with 000 §7.4).
-   Decision logs serve (a) blast-radius identification during incidents, (b) discovery of excess privilege, and (c) compliance audit. Feed deny records to ITDR (000 §3.3) as an attack-detection signal.

### 6.4. Consistency / Freshness Requirements

-   **Rule 67.6.5 (Propagate Privilege Changes)**: Propagate revocations and role changes to the PDP/cache **promptly**. Make the trade-off with cache TTL explicit, and strengthen freshness for sensitive operations (§4.4, §9).
-   **Rule 67.6.6 (fail-closed)**: If the query to the PDP/policy store fails or times out, **fall to the deny side** (fail-closed) (MUST). MUST NOT fall back to allow for the sake of availability (only when a high-availability-critical, limited path explicitly permits brief use of the most recent cached decision by policy).

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
