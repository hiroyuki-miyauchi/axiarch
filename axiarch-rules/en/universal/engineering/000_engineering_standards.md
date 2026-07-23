# 30. Engineering Excellence (General)

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited without explicit "Amend Constitution" instruction.**
> Revision date: 2026-07-23 (Rev.9)

> [!IMPORTANT]
> **Primary Directive**
> "Code is a liability, not an asset — every line must justify its existence."
> All engineering decisions must prioritize correctness, security, and maintainability over speed.
> Strictly follow the priority: **Security > Correctness > Maintainability > Performance > Development Speed**.
> This document is the primary standard for all design decisions regarding engineering quality and standards.
> Language scope: TypeScript, JavaScript, and web-specific tool names and examples in this standard apply only to their ecosystems. `320_programming_language_governance.md` is the source of truth for cross-language selection, naming, toolchains, quality gates, ownership, and retirement; do not impose tool names unchanged on another ecosystem.
> Universal application contract: Product names, VCS features, job titles, headcount, ratios, deadlines, cadences, and thresholds are reference implementations or Blueprint parameters unless they are official platform constraints, law or contract, or a safety floor needed to prevent irrecoverable harm. The Project Blueprint selects concrete values and equivalent mechanisms from risk, scale, regulation, and user impact without omitting verifiable outcomes, owners, or exception evidence.
> **22-part, 141-section architecture.**

---

## Table of Contents

| Part | Topic | Sections | Count |
|------|-------|----------|:--:|
| I | Code Quality & Clean Code | §1.0 – §1.9 | 10 |
| II | Infrastructure & Performance | §2.0 – §2.5 | 6 |
| III | Security by Design (DevSecOps) | §3.0 – §3.9 | 10 |
| IV | Technical Debt & Cleanup | §4.0 – §4.4 | 5 |
| V | AI-First Engineering | §5.0 – §5.4 | 5 |
| VI | Green Coding & Sustainability | §6.0 – §6.3 | 4 |
| VII | Bug Risk Reduction Policy | §7.0 – §7.3 | 4 |
| VIII | Continuous Learning & Verification | §8.0 – §8.2 | 3 |
| IX | Compatibility & Testing | §9.0 – §9.5 | 6 |
| X | CI/Deploy & Auxiliary Standards (Note: pure git moved to `600_git_workflow.md`) | §10.1, §10.2, §10.4 – §10.6 | 5 |
| XI | Documentation Ops | §11.0 – §11.2 | 3 |
| XII | Engineering Quality Protocols | §12.1 – §12.12 | 12 |
| XIII | Advanced Architectural Mandates | §13.1 – §13.15 | 15 |
| XIV | Platform Engineering | §14.1 – §14.6 | 6 |
| XV | Resilience Engineering | §15.1 – §15.5 | 5 |
| XVI | Developer Experience Governance | §16.1 – §16.4 | 4 |
| XVII | Zero-Downtime Schema Evolution | §17.1 – §17.5 | 5 |
| XVIII | Accessibility Engineering | §18.1 – §18.7 | 7 |
| XIX | Advanced Engineering Practices | §19.1 – §19.6 | 6 |
| XX | AI Agent & Orchestration Safety | §20.1 – §20.5 | 5 |
| XXI | Privacy Engineering | §21.1 – §21.7 | 7 |
| XXII | Advanced Runtime Security Hardening | §22.1 – §22.8 | 8 |
| | | **Total** | **141** |

---

## Part I: Code Quality & Clean Code

### 1.0. Naming & Structural Foundations
*   **The Consolidated Naming Convention**:
    *   **Files & Directories**: Follow the official style guide, formatter, framework generator, and established repository convention. TypeScript and JavaScript web projects default to `kebab-case`; do not impose it on Python modules, Dart packages, Java, Kotlin, or C# type files, Terraform resources, or other language-native structures. Names distinguished only by letter case are prohibited across languages for operating-system compatibility.
    *   **Symbols**: Component, class, function, package, and other symbol names follow language-native conventions. See `320_programming_language_governance.md` for the cross-language source of truth.
    *   **The Barrel File Ban**: In TypeScript and JavaScript, unrestricted re-exporting through `index.ts` is prohibited. An official language package or module entry point may be used after validating cycles, public API boundaries, Tree Shaking, or link-time impact.
*   **UI/Logic Consistency**:
    *   **Principle**: "Similar but different" is a lack of professionalism and a bug. All features (delete, edit, list) must have unified UI and logic.
    *   **Tiered Security**: Security is tiered based on risk. Tier 1 (standard operations): confirmation only. Tier 2 (bulk operations, critical single operations like user deletion): high-security authentication (OTP/Passkey/2FA) required.
*   **The Hierarchical Data Principle (1:N Core)**:
    *   **Law**: When designing complex domains, always define a root parent table and attach related data in a $1:N$ hierarchical structure. Cramming into a single God Table is a defeat that leads to migration and RLS design failures.
*   **The Tiered Service Mandate (Subscription Gating)**:
    *   **Law**: Service level restrictions (Free/Paid) must be enforced on the **server-side (Server Guards)**. Relying solely on frontend display control is prohibited.
*   **The Interoperable Ecosystem Mandate**:
    *   **Law**: Treat important domain data as "standardized assets" that are usable beyond your system. Design data to be portable by adhering to industry-standard schemas and international standards.

### 1.1. Omnichannel & Headless First Protocol
*   **Web is just ONE Client**: The web application is only one of many clients. Design for native apps, external media, IoT, and AI agents.
*   **API Mandate**: All features and data must be provided via reusable APIs (Headless Architecture).
*   **Prohibition**: Enclosing business logic within React components or designing data dependent on HTML structure is strictly prohibited.

### 1.2. Realism First Protocol (Anti-Haribote)
*   **Definition**: A feature with UI but without complete data persistence and re-hydration is classified as "Deception" and is not considered complete.
*   **Mandate**: Completion requires verifying the full **UI → Action → DB → Action → UI** round-trip.
*   **Physical Verification**: You must physically verify that values are written to the DB.

### 1.3. Structure First Protocol
*   **Law**: Important business data must be stored in structured formats (master data with M:N relationships, tags) rather than free-text.
*   **Future-Proof Data Strategy**: Design data models to retain metadata that may contribute to future FinOps and LTV maximization.
*   **Autonomous Structure Strategy (Edge AI)**: Consider OCR/Vision AI for automatic conversion of unstructured physical assets into structured data.
*   **Human-in-the-Loop Mandate**: AI-extracted data must always be treated as a "Draft" requiring user confirmation. Direct AI-to-DB writes are prohibited.
*   **PII Scrubbing**: Automatically discard or mask personally identifiable information in AI-processed data.

### 1.4. Blueprint Compliance
*   **Entry Point**: All development work starts by reviewing the corresponding rule file.
*   **Update First**: Update Blueprints before (or simultaneously with) writing code. Documentation-code drift is the greatest technical debt.
*   **The System Transparency Protocol (Stack Card)**: Maintain current version information of your tech stack in `PROMPT.md` or `tech_stack.md`.

### 1.5. Zero Warnings Mandate
*   **Rule**: Warnings are treated as errors. CI must fail on any warning.
*   **Strict Error Handling**: Empty `catch` blocks are prohibited. All errors must be logged and properly handled.
*   **Zero Tolerance for Band-Aid Solutions**: Hiding root causes with `// @ts-ignore`, `any` casts, warning suppression, `legacy-peer-deps`, or an ecosystem equivalent is prohibited. A temporary exception uses the language-appropriate suppression at the narrowest scope and records its reason, owner, Issue, and expiry.
*   **The Incident Response Protocol (SRE)**: Define incident response communication channels and conduct drills every six months.
*   **The Anti-Blindness Protocol**: Saving AI-generated code abbreviations (`// ...`) directly to files is prohibited.

### 1.6. Refactoring & Cleanup
*   **Boy Scout Rule**: "Leave it cleaner than you found it." Always make small improvements when touching a file.
*   **No "Later"**: "We'll refactor later" is a lie. Do it now or never.
*   **Cyclomatic Complexity**: Use early returns to keep nesting shallow. High complexity breeds bugs.
*   **Dead Code**: Commented-out code, unused imports, debug `console.log` must be completely removed before commit.
*   **TODO Management**: Always include ticket numbers or deadlines with `// TODO:` comments.

### 1.7. Root Cause First Protocol
*   **Prohibition**: Applying "band-aid fixes" without identifying the root cause is prohibited.
*   **Process**: 1. **Reproduce** the error locally. 2. **Diagnose** using logs, stack traces, dependency trees. 3. **Fix Root** cause, not symptoms.

### 1.8. Config Change Impact Analysis
*   **Context**: Changes to project-wide configuration files can cascade unexpected effects.
*   **Mandate**: 1. **Impact Scan** affected consumers, generated artifacts, runtimes, and release paths through repository search, a build graph, dependency analysis, or an equivalent mechanism. 2. **Risk-Based Approval** based on security boundaries, compatibility, shared toolchains, production blast radius, and rollback difficulty rather than file count alone. Require owner review, independent approval, or staged delivery as risk warrants. 3. **Cohesive Change** keeps affected configuration, generated output, migration, verification, and rollback traceable as one change unit and prevents an intermediate state from reaching users or release paths.

### 1.9. Version-Aware Contract and Codebase Consistency
*   **Law**: Existing code is evidence of adopted patterns, while official version-specific documentation, security advisories, and support policies are authoritative for contracts and EOL decisions. Never prefer either unconditionally. Reconcile the lockfile, runtime or compiler pin, and installed-package types, signatures, generated output, and tests. Working code does not justify deprecated, undocumented, vulnerable, or accidental behavior.
*   **Action**: 1. Before using an API, inspect repository usage, the installed version's types and signatures, and official version-specific material. 2. Classify a conflict as version mismatch, generated drift, deprecated API, or undocumented behavior, then fix it or record an ADR with an owner and expiry. 3. Verify compatibility, migration, and rollback for a new pattern and update only the necessary existing implementation and documentation in the same change.
*   **The Silent Async Bug Pattern**: Every Promise, Future, Task, or equivalent asynchronous result is observed through `await`, return to the caller, aggregation, or a managed background task under §7.1. Prohibit fire-and-forget and unhandled failure, using language-appropriate static analysis.

---

## Part II: Infrastructure & Performance

### 2.0. Infrastructure Standards (The Golden Quad)
*   **Hosting Outcome**: Select managed, self-managed, or hybrid hosting that satisfies DDoS protection, availability, scalability, data residency, portability, operating capability, cost, and exit needs, recording an owner, SLO, backup, recovery, and migration runbook. Vercel is an example, not the only conforming mechanism.
*   **Data Platform Outcome**: Evaluate BaaS, managed databases, and self-managed databases by encryption, separation of privilege, backup and restore, PITR, HA, auditability, capacity, connection limits, and data portability. A product name such as Supabase is not evidence by itself.
*   **Edge Protection**: According to threat model, traffic, latency, and origin exposure, deploy a WAF, CDN, rate limits, DDoS protection, or equivalent origin controls, testing bypass paths and fail-open or fail-closed behavior. Cloudflare is an example.
*   **Email Deliverability**: When the system sends email, use a managed provider or operable self-hosted design that assures authentication, bounce and complaint handling, suppression, unsubscribe, rates, monitoring, and data handling. Resend is an example.
*   **The Email Deliverability Protocol**: For an organizational sending domain, configure SPF, DKIM, DMARC alignment, and staged enforcement appropriate to the provider and receiver requirements, testing forwarding, subdomains, and third-party senders. Bulk or marketing email follows applicable law and mailbox-provider requirements for RFC 8058 one-click unsubscribe and a user-facing opt-out route.
*   **Database Connection Pool Protocol**:
    *   **Bounded Connections**: Require bounded connection management compatible with the runtime, driver, database, process or instance count, autoscaling, and transaction semantics. Prefer a pooler or proxy for serverless and high fan-out workloads, but do not universally prohibit a direct pool in a long-lived process.
    *   **Capacity Model**: Reserve database headroom for administration, migration, and recovery, then allocate the remainder across workloads and maximum instance count. Do not use one fixed formula as a Universal value; tune from measured queueing, saturation, latency, timeout, and failover behavior.
    *   **Lifecycle**: Define acquisition, query, transaction, idle, and lifetime timeouts, backpressure, retries, cancellation, shutdown, and credential rotation. Thirty seconds is a reference value to validate against load tests and provider constraints.
    *   **Mode Compatibility**: Test transaction or session pooling, prepared statements, temporary tables, advisory locks, session state, and read replicas, recording pooler-specific constraints in the runbook.

### 2.1. Read-Optimized Architecture
*   **Measured Read Optimization**: Measure query plans, traffic, latency SLOs, update frequency, tolerated staleness, and cost for rankings, aggregations, and filters, then choose the smallest adequate index, cache, precomputation, materialized view, search engine, or equivalent. A precomputed path includes invalidation, rebuild, backfill, and consistency verification.
*   **CQRS Decision**: Adopt CQRS or a read model when independent scaling, a distinct model, audit needs, or latency gains outweigh the complexity. Do not force separation on a system whose requirements fit one model.
*   **Content Model Boundary**: Derive sources of truth for layout, ordering, content, and metadata from update ownership, schema evolution, localization, querying, and audit needs. A JSON and relational hybrid is one implementation, not a fixed Universal schema.

### 2.2. Performance Budgets
*   **Lighthouse Scores**: Maintain **90+ scores** across Performance, Accessibility, Best Practices, and SEO.
*   **Core Web Vitals**: LCP (≤2.5s), **INP (≤200ms)**, CLS (≤0.1).

### 2.3. Asset Optimization
*   **Images**: Enforce next-gen formats (AVIF/WebP). Use optimized components like `next/image`.
*   **Lazy Loading**: All assets below the fold must be lazy-loaded.
*   **The Fixed Page Protocol**: Creating physical `page.tsx` files for "static but updatable" pages (terms of service, etc.) is prohibited. Use dynamic routes fetching content from DB.

### 2.4. API-Free First Protocol
*   **Law**: Before adopting paid external APIs, you must evaluate free alternatives. Hasty adoption of paid APIs is a FinOps defeat.
*   **Free Alternatives Checklist**: 1. Extract from existing data. 2. Use browser standard APIs. 3. Leverage open data. 4. Fetch once → store in DB pattern.
*   **Documentation**: When adopting paid APIs, document why free alternatives are insufficient.

### 2.5. Centralized Storage Shield
*   **Law**: Centralize image originals in BaaS storage, serve via CDN optimization for cost-performance balance.
*   **Cache Maximization**: Target CDN cache hit rate of **80%+**.

---

## Part III: Security by Design (DevSecOps)

### 3.0. Zero Trust Foundation
> For detailed implementation, refer to **`security/000_security_privacy.md`**.

*   **Law**: Treat every request as untrusted — even from inside the network — and implement the following **5 Principles** from NIST SP 800-207 across all systems.
*   **Zero Trust 5 Principles (Mandatory)**:
    1.  **Never Trust, Always Verify**: Re-verify authentication and authorization periodically throughout a session. Passing initial authentication does not guarantee subsequent access.
    2.  **Least Privilege**: Limit access rights to the "minimum scope needed right now" for users, services, and AI agents alike. Default is Full Deny.
    3.  **Assume Breach**: Design the system on the premise that it is "already compromised." Breach detection, lateral movement prevention, and blast radius minimization are top design priorities.
    4.  **Explicit Verification**: Validate all inputs (user input, API responses, LLM output) at both client and server layers. Explicitly define trust scopes; eliminate implicit trust.
    5.  **Continuous Monitoring**: Collect and analyze all access logs; set alerts to auto-detect anomalous access patterns (unusual hours, geolocation, volume).
*   **Zero Trust in Code (Mandatory Implementation Checklist)**:
    | Layer | Implementation Mandate |
    |:--------|:--------|
    | **API Edge** | JWT validation (§3.7) + Rate Limiting + CORS restrictions on all endpoints |
    | **Service Layer** | Authorization checks (RBAC/ABAC) on all mutation operations |
    | **DB Layer** | Row Level Security (RLS) for physical data access control |
    | **AI Layer** | PII/sensitive info filtering before sending to LLMs (§3.8) |
    | **Monitoring** | Immediate alerts on auth failures and privilege escalation attempts |

### 3.1. Secrets Management
*   Never commit API keys or secrets to code. Use `.env` files and secret managers.
*   **The Single Source of Config**: Direct `process.env.NEXT_PUBLIC_...` references throughout code are prohibited. Centralize in `src/lib/config` with validation.

### 3.2. Environment Template Sync
*   **Law**: Maintain `.env.example` at project root with all required environment variable **keys only**.
*   **Sync Mandate**: When adding new environment variables, update `.env.example` **in the same PR**.
*   **Git Safety**: `.env.local` / `.env.production` files with actual values must be in `.gitignore`.

### 3.3. Environment Variable Drift Prevention
*   **Law**: Environment variable drift is the #1 cause of "works locally but breaks in CI/production."
*   **Action**: 1. **Startup Validation** with abort on missing variables. 2. **CI Parity Check** verifying all `.env.example` keys exist in CI. 3. **Type-Safe Config** with Zod/io-ts validation.

### 3.4. PII & Data Scrubbing
*   **The Privacy Scrubbing Protocol (EXIF Wipe)**: Mandatory EXIF removal from user-uploaded images on the client side.
*   **The Console Log Ban**: `console.log` in production builds is an information leak vector. Set `eslint-plugin-no-console` to `error`.

### 3.5. Software Supply Chain Security
*   **Law**: Treat dependency packages as "potential attack vectors," not "trusted code." Supply chain attacks are a top-tier threat in 2026.
*   **Action**:
    1.  **SLSA v1.2 Tracks**: Use SLSA Build L2 or higher for production builds and Source L2 or higher for source management, with verifiable signed Build Provenance and Source Provenance. High-assurance areas target Build L3 and Source L4, including two-party review, and verify the corresponding numeric level plus the `SLSA_SOURCE_TWO_PARTY_REVIEWED` property in the Source VSA.
    2.  **Dependency Resolution Pinning**: Verify the adopted ecosystem's lockfile or equivalent resolved graph, checksums, sources, and artifact digests. Use frozen or locked installation in CI where supported and prohibit unverified implicit re-resolution.
    3.  **Dependency Review**: Automatically inspect new and updated package diffs for vulnerabilities, licenses, source, and provenance through an organization-approved dependency-diff or SCA gate available in the repository host or CI. GitHub Dependency Review Action is one implementation example, not a Universal host requirement.
    4.  **Sigstore Verification**: Where available, verify ecosystem provenance, signatures, Sigstore, or an equivalent and retain traceability to source, builder, and artifact digest.
    5.  **SBOM Generation**: Auto-generate SBOM in CI/CD pipelines for each deployment.
*   **Rationale**: As demonstrated by 2025-2026 incidents, attacks on trusted OSS packages are increasing. Only automated verification mechanisms protect the supply chain.

### 3.6. Secret Rotation Protocol
*   **Law**: Prefer an issuable and revocable identity such as OIDC workload identity, managed identity, dynamic credentials, or short-lived tokens over a long-lived secret. When a static API key, database password, signing key, or equivalent remains necessary, record its expiry and rotation triggers in the Blueprint from provider limits, cryptoperiod, exposure, privilege, usage locations, rotation cost, legal or contractual needs, and incident events. Do not impose one number of days on every credential.
*   **Rotation Contract**:
    | Credential Type | Required Outcome | Representative Mechanisms |
    |:---------------|:-----------------|:--------------------------|
    | Signing key | `kid`, algorithm, overlap, verification-key distribution, revocation, rollback | Asymmetric key, JWKS, HSM or KMS |
    | Database credential | Least privilege, workload separation, connection switchover, active-session handling | Workload identity, dynamic secret, dual credentials |
    | External API key | Owner, scope, usage inventory, vendor constraints, switchover and revocation evidence | Short-lived token, dual-key rotation, expiring static key |
    | Service account or OAuth client | Non-human identity inventory, audience, privilege, offboarding | Federation, managed identity, certificate or secret rotation |
*   **Zero-Downtime Rotation**: When the provider supports concurrent credentials, stage new-credential activation, consumer switchover, verification, and old-credential revocation. Otherwise design maintenance, queuing, rollback, and user communication according to risk.
*   **Rotation Audit**: Bind issuance, distribution, use, switchover, revocation, failures, and exceptions to a credential ID and owner, monitoring the next deadline or event trigger in a machine-readable inventory.
*   **Break-Glass Protocol**: On suspected exposure, use the fastest control that limits impact, such as revocation, scope reduction, consumer isolation, or reissuance, while preserving evidence and recovery. Incident records and external reports follow the triggers and deadlines of applicable law, contracts, and organizational incident SLAs.

### 3.7. OAuth / OIDC Token Handling Protocol
*   **Law**: Incorrect token implementation is the security hole with the longest detection delay. Strictly follow these principles.
*   **Token Storage Rules**:
    *   **Access Token**: Store only in memory (JavaScript variables). Storage in `localStorage` / `sessionStorage` is **absolutely prohibited** (XSS exposure risk).
    *   **Refresh Token**: Store only in `HttpOnly; Secure; SameSite=Strict` cookies. Physically block JavaScript access.
*   **Token Validation Mandate**:
    *   On the server side, validate **all** of: `iss` (issuer), `aud` (audience), and `exp` (expiry) of received JWTs. Missing any one validation is "authentication deficiency."
    *   Skipping JWT signature verification is **absolutely prohibited**.
    ```typescript
    // Minimum JWT validation requirements (jose / jsonwebtoken, etc.)
    const { payload } = await jwtVerify(token, publicKey, {
      issuer: process.env.JWT_ISSUER,    // iss mandatory validation
      audience: process.env.JWT_AUDIENCE, // aud mandatory validation
    });
    // exp is automatically validated (library standard behavior)
    ```
*   **PKCE Mandate**: For OAuth 2.0 authorization code flows, PKCE (Proof Key for Code Exchange) is mandatory for all clients (including SPAs). Implicit Flow is **formally removed in OAuth 2.1 (RFC 9700, finalized 2025)** — treating it as merely "deprecated" is insufficient. Any system still using Implicit Flow must be migrated immediately.

### 3.8. AI/LLM Security Foundation Protocol
> For detailed implementation, refer to **`ai/000_ai_engineering.md`**.

*   **Law**: Systems incorporating AI must implement a "minimum line of defense" against Prompt Injection and model abuse at the engineering layer. Treating AI security as the model's responsibility alone is a design failure.
*   **4 Principles of Prompt Injection Defense (Mandatory)**:
    1.  **Input Boundary Enforcement**: User input and system prompts must be physically separated with explicit role assignment (`system`/`user` message strict separation). Concatenating user input into system prompts via string interpolation is **absolutely prohibited**.
    2.  **Output Sanitization**: Passing LLM output directly to HTML rendering, SQL queries, or OS commands is **prohibited**. Always type-validate and escape output before use.
    3.  **Input Guardrail**: Before sending to production LLMs, implement a filtering layer that detects and masks PII, confidential information, and injection attempt patterns.
    4.  **Output Guardrail**: Before publishing LLM output, implement a filtering layer that detects harmful content, PII leakage, and confidential information contamination.
*   **Minimum LLM Security Configuration**:
    | Parameter | Recommended Value | Purpose |
    |:----------|:-----------------|:--------|
    | `max_tokens` | Set ceiling based on output use case | Prevent token exhaustion attacks |
    | `temperature` | 0.0–0.7 for production use cases | Ensure output predictability |
    | User Rate Limit | Appropriate RPM limit per user | AI FinOps / DDoS mitigation |
    | API Timeout | 30 seconds maximum | Eliminate hanging requests |
*   **Function Calling / Tool Use Security**:
    *   Tools (Functions) granted to AI must be scoped to the minimum necessary based on the Principle of Least Privilege.
    *   All DB operations and external API calls executed by AI must be limited to a **human-defined whitelist**. Dynamic code generation and execution are **prohibited**.
    *   Mutation operations (writes/deletes) by AI must always pass through a "Human-in-the-Loop" confirmation step.
*   **Indirect Prompt Injection Defense**:
    *   When feeding web pages, documents, or emails into LLMs, the trust level of that external input must always be set lower than the system prompt to defend against indirect injection (Indirect Prompt Injection) that attempts to hijack the system prompt.
    ```typescript
    // Safe message structure (OpenAI / Anthropic API universal principle)
    const messages = [
      { role: 'system', content: SYSTEM_PROMPT },          // System config (trust level: HIGH)
      { role: 'user',   content: sanitize(userInput) },    // User input   (trust level: LOW)
      // ❌ PROHIBITED: `${SYSTEM_PROMPT} ${userInput}` string concatenation
    ];
    ```

### 3.9. Insider Threat Prevention Protocol
*   **Background**: Security incidents caused intentionally or accidentally by **internal parties (employees, contractors, former employees)** — not only external attackers — account for approximately 20% of all incidents per DBIR 2025 data. The Zero Trust (§3.0) "Assume Breach" principle applies equally to insider threats.
*   **Mandatory Controls (4-Layer Defense)**:
    1.  **Least Privilege + JIT Access (Just-In-Time Access)**: Day-to-day work does not require persistent access to production databases. When production data access is required, grant temporary permissions via JIT (Just-In-Time) provisioning and expire them immediately upon task completion. Tool examples: HashiCorp Vault Dynamic Secrets / AWS IAM Identity Center.
    2.  **Privileged Access Workstation (PAW)**: All privileged-access operations must be performed from a dedicated "Privileged Access Workstation" or an isolated browser profile, physically separated from the daily-use endpoint.
    3.  **User Behavior Analytics (UBA)**: Deploy UBA (SIEM-integrated) to automatically detect access deviating from normal patterns (large data downloads outside business hours, access to directories outside normal work scope). Alerts must notify the SOC or responsible party in real time.
    4.  **Separation of Duties**: **Prohibit a single individual from holding all of** code commit rights, production deploy rights, and data read rights simultaneously. All critical operations must undergo two-person confirmation (Four-Eyes Principle).
*   **Offboarding Protocol (Departing employee response)**:
    | Timeline | Action |
    |:---------|:-------|
    | Day of departure | Batch-revoke all credentials (SSO, API Key, SSH Key, MFA). Scan commit history with `gitleaks` |
    | Within 24 hours | Review 72 hours of production system access logs and verify no abnormal data exfiltration |
    | Within 72 hours | Update CODEOWNERS, force-remove from team Slack, remove from GitHub organization |
    ```bash
    # Offboarding checklist (automation recommended)
    # 1. Remove user from GitHub org
    gh api orgs/{org}/members/{username} -X DELETE
    # 2. List active API keys (Vault case)
    vault list auth/token/accessors | xargs -I{} vault token lookup -accessor {}
    ```
*   **Rationale**: The financial impact of insider threats is on average 3.5x that of external attacks (Ponemon Institute 2025). Beyond technical controls, cultivating a "transparent monitoring culture (distinct from Blameless §19.4 — this is deterrence against intentional misconduct)" is essential.

---

## Part IV: Technical Debt & Cleanup

### 4.0. Debt Paydown Strategy
*   **Law**: Reserve continuous capacity for technical debt, dependency updates, and EOL migration, prioritized by security, reliability, and delivery risk. Twenty percent is a reference default for a stable product team; the actual ratio, cadence, and emergency triggers are Blueprint parameters.
*   **The TODO/FIXME Protocol (Work Item First)**: Bind every TODO or FIXME to a traceable work item, owner, and completion condition or expiry. An issue number is one implementation; an equivalent change-management system or register conforms. Reject unowned or indefinite TODOs at change acceptance.

### 4.1. Tech Radar & Dependency Governance
*   **Continuous Updates**: Reassess dependencies on change, support retirement, major vulnerabilities, compromise, license changes, and a risk-based Blueprint cadence. Quarterly updates are a reference default. Maintain a supported, verified, safe release line rather than treating the newest version as the objective.
*   **Dependency Watch**: Run ecosystem-standard or equivalent SCA, such as `npm audit`, `govulncheck`, `pip-audit`, `dotnet package list --vulnerable` on .NET 10 or later, or `dotnet list package --vulnerable` on .NET 9 or earlier, on dependency changes and a risk-based cadence. Priorities and deadlines consider KEV, EPSS, reachability, exposure, data sensitivity, compensating controls, and vendor deadlines in addition to CVSS. Immediately contain actively exploited or externally exposed critical vulnerabilities, and record the owner and deadline for remediation, mitigation, or risk acceptance in the Blueprint.
*   **The Dependency Override Protocol**: Options that disable dependency validation are prohibited. A necessary override uses the package manager's supported mechanism and records its reason, owner, expiry, and compatibility tests.
*   **License Governance**: Determine allow, review, and deny decisions from the distribution model, network service behavior, linking or derivative work, modifications, customer contracts, disclosure obligations, and intellectual-property policy. AGPL and similar licenses are not a universal blanket prohibition; block them automatically when organizational policy classifies them as deny or legal-review. `security/200_oss_compliance.md` is the source of truth.

### 4.2. Lockfile Integrity Protocol
*   **Law**: Deployable applications and executable roots version the reproducible resolution source supplied by the ecosystem, such as a lockfile, checksum set, resolved graph, version catalog, provider selection, or vendor tree, and prohibit unintended changes. `package-lock.json`, `pnpm-lock.yaml`, `uv.lock`, `go.sum`, `Cargo.lock`, `packages.lock.json`, `composer.lock`, `Gemfile.lock`, and `renv.lock` are examples with different semantics and are not all treated as lockfiles. Publishable libraries follow ecosystem consumer-compatibility conventions while pinning CI test and release resolution and retaining dependency evidence.
*   **CI Discipline**: In supporting ecosystems, use frozen or locked commands such as `npm ci`, `pnpm install --frozen-lockfile`, `uv sync --locked`, or `cargo build --locked`. Where no standard lockfile or locked mode exists, use an equivalent gate that verifies version, source, checksum, and artifact digest and rejects unapproved re-resolution.
*   **Recovery**: When local and CI behavior diverge, compare runtime, package manager, registry, platform, and lockfile digest first. Lockfile regeneration is a reviewed change with an explicit reason, full dependency diff, tests, and SCA, not a standard recovery shortcut.
*   **Prohibition**: In applications and executable roots where the lockfile is authoritative, pushing after dependency changes without committing the lockfile is prohibited.

### 4.3. Dead Export Detection
*   **Law**: Exported functions/types/constants with zero usage must be immediately removed.
*   **The Backup File Ban**: `.bak`, `.old`, `_copy` files must be deleted immediately. Git history is your backup.
*   **The Exhaustive Reference Scan (Grep First)**: Always `grep` the entire project before deleting/renaming files.

### 4.4. Ghost Feature Ban & Revival
*   **Ban**: Features without user pathways are debt. Delete per YAGNI principle.
*   **Revival**: Admin settings that produce no frontend effect are trust-destroying bugs. Always implement both sides simultaneously.

---

## Part V: AI-First Engineering

### 5.0. Prompt-Driven Development (PDD)
*   **Principle**: Code is written by AI; prompts are the true source code.
*   **AI-Friendly**: Use highly descriptive names (e.g., `daysSinceLastLogin` instead of `x`).

### 5.1. RAG Optimization & Schema Trust
*   **Modularization**: Keep files small (Atomic) to avoid overwhelming AI context windows.
*   **Explicit Imports**: All imports must be at the top-level. In-function imports are prohibited.
*   **Semantic Structure**: Organize directories by feature for AI discoverability.
*   **Schema Trust Protocol (No Ghost Columns)**: Using column names not yet applied via migration is prohibited.

### 5.2. AI Hygiene & Anti-Blindness
*   **The Anti-Blindness Protocol**: Saving AI-generated abbreviations (`// ...`) to files is prohibited. Always expand to complete code.
*   **Human Verification Loop**: AI-generated code is a "draft." Always verify before committing.

### 5.3. AI Code Review Governance
*   **Law**: AI-generated code (Copilot, Cursor, Cody, etc.) must be reviewed with **equal or greater rigor** than human-written code.
*   **Action**:
    1.  **Provenance Tagging**: Tag AI-generated code in commits/PRs with `[AI-Generated]`.
    2.  **Hallucination Guard**: Verify AI-generated API calls against official docs or `node_modules` type definitions.
    3.  **Security Audit**: Explicitly verify security patterns (input validation, SQL injection, XSS) in AI-generated code.
    4.  **License Compliance**: Verify AI-generated code doesn't infringe on existing OSS copyrights.
*   **Rationale**: AI Copilots increase code generation speed but also quality, security, and license risks.

### 5.4. LLM Context Optimization
*   **Law**: Codebase "AI-friendliness" directly impacts productivity. Maintain structures that enable efficient AI comprehension.
*   **Action**:
    1.  **File Size Budget**: Target **≤300 lines** per file for AI context window compatibility.
    2.  **Self-Documenting Types**: Use branded types instead of raw `string` to enable AI intent inference.
    3.  **Contextual Comments**: Document "why" not "what." AI can infer "what" from code but not "why."
    4.  **llms.txt / AXIARCH.md / thin adapters**: Place AI-facing project overview and constraints at the project root through `llms.txt` and the canonical `AXIARCH.md`. Keep `AGENTS.md` and tool-native files as thin pointers to `AXIARCH.md`, not duplicated rule bodies.

---

## Part VI: Green Coding & Sustainability

### 6.0. Energy Efficiency
*   **Algorithm Optimization**: Write code conscious of computational complexity (Big-O notation). This protects both battery life and the environment.
*   **Dark Mode**: Recommend true black (#000000) dark mode for OLED power savings.
*   **Idle-Aware Processing**: Design background jobs and batch processing to run during off-peak hours (low system load) to distribute power consumption peaks.

### 6.1. Data Transfer Optimization
*   **Compression**: Always optimize images and videos (AVIF/H.265) to prevent bandwidth waste.
*   **Cache Maximization**: Target CDN cache hit rate of **80%+** to minimize origin load and carbon footprint.
*   **Payload Diet**: GraphQL/REST APIs must return only the fields the client needs. Prohibit over-fetching. Measure and manage average payload size per endpoint.

### 6.2. Software Carbon Intensity (SCI) Measurement
*   **Law**: Calculate the SCI (Software Carbon Intensity) score defined by the Green Software Foundation (GSF) quarterly and record improvement trends. SCI = (E × I) + M
*   **Measurement Scope**: Track CO₂ consumption of CI/CD pipelines, `npm test` execution, and always-on production services.
*   **Carbon-Aware Scheduling**: Leverage cloud provider carbon intensity APIs to schedule batch jobs in regions/time windows with high renewable energy proportions.
    ```typescript
    // carbon-aware-sdk usage example
    import { CarbonAwareComputing } from '@carbon-aware/sdk';
    const bestWindow = await carbonAware.getBestExecutionWindow({
      location: ['japaneast', 'westus2'],
      duration: 30, // minutes
    });
    ```

### 6.3. Green Architecture Principles
*   **Serverless-First for Sporadic Workloads**: For sporadic workloads, prefer serverless (Cloud Functions/Lambda) over always-on servers. Zero CPU consumption at idle is the design principle.
*   **Right-Sizing Mandate**: Set production instance sizes only after verifying actual load metrics (CPU utilization persistently < 60%). Over-provisioning is a defeat for both FinOps and GreenOps.
*   **Data Gravity Awareness**: Complete data processing in the region where data resides. Minimize cross-region data transfer (Egress). Transfer costs are a direct indicator of CO₂ emissions.

---

## Part VII: Bug Risk Reduction Policy

### 7.0. Defect Triage First
*   **Law**: Classify known defects by severity, user impact, effects on data, money, or authorization, exploitability, workarounds, SLOs, and legal or contractual deadlines, recording an owner, containment, remediation target, and verification method. Define the boundary for pausing feature work in the Blueprint; do not treat critical safety, integrity, or availability defects and error-budget exhaustion the same as known low-impact defects.

### 7.1. Critical Defect Response
*   **Law**: Immediately triage data loss, exploitable security defects, major feature outages, and similar incidents, containing impact when necessary through rollback, feature disablement, credential revocation, traffic isolation, or an equivalent control. Derive the permanent-fix target from exposure, impact growth, recoverability, vendor, legal, and contractual deadlines, and required verification time, recording the owner and user communication in the incident record. Twenty-four hours is a high-urgency reference target for a critical externally exposed defect, not a Universal completion deadline for every defect.

### 7.2. Versioned Contract Reality
*   **Context**: Current official documentation, the installed version, generated types, and runtime behavior can disagree.
*   **Law**: For implementation, verify the lockfile, runtime or compiler pin, and the installed package's types, signatures, generated output, and tests as facts about the targeted version. Use version-specific official documentation, security advisories, and support policies as the source of truth for contracts and EOL decisions. Do not blindly prefer either side; resolve or time-bound discrepancies as version mismatch, deprecated API, generated drift, or undocumented behavior in an ADR.

### 7.3. Fix Twice Principle
*   **Law**: When fixing a defect, inspect recurrence paths with the same cause and add a risk-proportionate test, type or schema, lint or static analysis, monitoring, runbook, or design change that detects or prevents recurrence. If automation would create more risk than the fix, record the reason, residual risk, and recheck condition.

---

## Part VIII: Continuous Learning & Verification

### 8.0. Latest Info Protocol
*   **Before Development**: Always check official documentation and latest release notes before writing code.
*   **Deprecation Check**: Verify APIs are not deprecated before using them.

### 8.1. Trend Awareness
*   Continuously catch up with latest trends (AI Agents, Privacy Manifests, etc.) and evolve rules accordingly.

### 8.2. Crystallization Protocol
*   **Law**: After feature implementation, document "tacit knowledge," "new patterns," and "pitfalls" in Blueprints or rule files.
*   **Rationale**: Knowledge existing only in code is "volatile experience." Immediate documentation exponentially improves team productivity.

---

## Part IX: Compatibility & Testing

### 9.0. Real Device Testing
*   Mobile or device-dependent features must go beyond simulators and use a device matrix derived from user distribution, supported operating systems, hardware capabilities, and risk. Critical flows involving camera, location, biometrics, push, background execution, or performance include physical devices or an equivalent high-fidelity device farm in the release gate.

### 9.1. Browser Compatibility
*   Record browser support in the Blueprint from user distribution, contracts, regulation, security updates, and required features, then verify it with automated cross-browser tests and production telemetry. Current and previous releases of major browsers are a reference default, not a universal fixed two-version mandate.

### 9.2. Self-Check List
*   Before requesting change acceptance, the author self-verifies no unresolved warnings, no runtime errors, and no unnecessary or sensitive logs, and records the result in a Pull Request, Merge Request, change record, or equivalent evidence.

### 9.3. Testing Strategy Mix Protocol
*   **Context**: More tests do not automatically mean better tests, and one ratio does not fit every system. Select static, unit, integration, contract, E2E, and non-functional tests from `quality/000_qa_testing.md` and `320_programming_language_governance.md` according to change risk, architecture, failure cost, execution time, and historical defects.
*   **Reference Testing Trophy Profile for Web UI**:
    | Layer | Ratio | Description | Example Tools |
    |:------|:------|:------------|:--------------|
    | **Static** | Foundation | TypeScript and ESLint or equivalent for the web profile; remove type, lint, and schema errors before build | `tsc --noEmit`, `eslint` |
    | **Unit** | Reference 30% | Business logic, pure functions, and data transformations | `vitest`, `jest` |
    | **Integration** | Reference 50% | Behavior across APIs, databases, state, and components | `vitest` + `supertest` / Playwright API |
    | **E2E** | Reference 20% | Critical paths such as login, payment, and primary workflows | `Playwright`, `Cypress` |
*   **Prohibitions**:
    *   "Code copy tests" that mirror implementation 1:1 are prohibited. Tests must verify behavior.
    *   Treat unsafe casts, type or compiler bypasses, and unhandled asynchronous errors in test code under the same quality standard as production code.
*   **Coverage Decision Contract**:
    *   Do not judge quality from statement or branch coverage alone. Combine risk, critical invariants, mutation score, escaped defects, and flakiness.
    *   Line Coverage of 80% and Mutation Score of 70% for business logic are onboarding references. The Blueprint defines blocking scope, thresholds, exclusions, and staged improvement, and does not force the same number on low-risk generated code and high-risk payment logic.
*   **What is Mutation Score?** A high-level test quality indicator that injects intentional bugs (Mutants) into implementation code and verifies whether tests can detect them. It measures not just "tests exist" but "whether tests genuinely function."
    ```bash
    # Stryker Mutant (TypeScript) configuration example
    # stryker.config.mjs
    export default {
      mutate: ['src/lib/**/*.ts'],          // Mutation targets (business logic layer only)
      thresholds: { high: 80, low: 70, break: 60 }, // Mutation Score floor
      reporters: ['html', 'dashboard'],
    };
    ```

### 9.4. Property-Based Testing & Chaos Engineering
*   **Property-Based Testing (PBT)**:
    *   **Target**: Apply to areas with enormous input combinations — data validation, numeric calculations, sort algorithms, serialize/deserialize processing.
    *   **Tool**: Use `fast-check` (TypeScript) to exhaustively generate boundary values. The probability of finding bugs with random inputs is orders of magnitude higher than conventional Unit Tests.
    ```typescript
    // Property-Based Testing example with fast-check
    import * as fc from 'fast-check';
    test('price conversion is always safe for non-negative integers', () => {
      fc.assert(fc.property(
        fc.integer({ min: 0, max: 1_000_000 }),
        fc.integer({ min: 0, max: 99 }),
        (dollars, cents) => {
          const result = formatPrice(dollars, cents);
          return result.includes('$') && !result.includes('NaN');
        }
      ));
    });
    ```
*   **Chaos Engineering**:
    *   **Principle**: "Failures cannot be prevented. Verify that you can withstand them."
    *   **GameDay Mandate**: Once per quarter, conduct a planned exercise (GameDay) for the following scenarios to verify system resilience:
        | Scenario | What to Verify |
        |:---------|:---------------|
        | **DB connection loss (30s)** | Circuit Breaker and Fallback behavior |
        | **External API timeout (5s)** | Timeout + Retry + DLQ ingestion |
        | **10x traffic spike** | Autoscaling and rate limit behavior |
        | **Random Pod Kill (Kubernetes)** | Health checks, restarts, data integrity |
    *   **Chaos Test Automation (Tool Selection Criteria)**:
        | Tool | Suitable Environment | Key Features |
        |:-----|:---------------------|:-------------|
        | **Chaos Monkey** (Netflix OSS) | AWS/EC2-centric environments | Random instance termination |
        | **Litmus Chaos** | Kubernetes | Declarative definition of Pod/Node/Network failures |
        | **Gremlin** | Multi-cloud | SaaS-based, GUI management, safe-stop feature |
        | **Toxiproxy** | Local/CI | Programmable injection of network latency and disconnection |
        ```yaml
        # Litmus ChaosExperiment definition example (Pod deletion)
        apiVersion: litmuschaos.io/v1alpha1
        kind: ChaosEngine
        metadata:
          name: pod-delete-engine
        spec:
          engineState: 'active'
          chaosServiceAccount: litmus-admin
          experiments:
            - name: pod-delete
              spec:
                components:
                  env:
                    - name: TOTAL_CHAOS_DURATION
                      value: '30'    # 30 seconds
                    - name: CHAOS_INTERVAL
                      value: '10'   # Delete 1 Pod every 10 seconds
        ```
    *   **Blast Radius Constraint**: Always conduct Chaos experiments with minimized "Blast Radius" to prevent production data destruction. Start with staging environments.

### 9.5. Visual Regression Testing Protocol
*   **Context**: Unit Tests and Integration Tests cannot detect "visible breakage" (UI regressions). Visual Regression Testing is mandated as part of CI to automatically detect unintended UI changes.
*   **Tool Selection Criteria**:
    *   **Storybook-based (small–medium scale)**: Storybook + `@chromatic-com/storybook` for component-level image snapshot comparison.
    *   **Playwright-based (full page)**: Playwright `expect(page).toHaveScreenshot()` for full-page screenshot comparison. Must be applied to critical paths (login, checkout, dashboard).
    ```typescript
    // Playwright Visual Regression Test Example
    import { test, expect } from '@playwright/test';
    test('Dashboard visual regression test', async ({ page }) => {
      await page.goto('/dashboard');
      await page.waitForLoadState('networkidle');
      await expect(page).toHaveScreenshot('dashboard-baseline.png', {
        maxDiffPixelRatio: 0.01, // Allow up to 1% pixel difference
      });
    });
    ```
*   **Snapshot Operations Rules**:
    *   **Baseline Update Procedure**: For legitimate UI changes, always use `--update-snapshots` to intentionally update the baseline, attach a visual diff to the PR, and have a reviewer visually confirm the changes.
    *   **Prohibited**: Automatically generating snapshot diffs without declaration or distributing them within CI is prohibited.
    *   **Noise Prevention**: Animations and dynamic content must always be stopped before taking a screenshot (use `waitForLoadState('networkidle')`) to prevent flaky tests.

---

## Part X: CI/Deploy & Auxiliary Standards

> [!NOTE]
> **v1.3.2 Restructure**: Daily Git workflow rules (Trunk-Based Development, Conventional Commits, Branch Hygiene, Worktree Hygiene, etc.) have been consolidated into `engineering/600_git_workflow.md`. This Part now retains only auxiliary CI/Deploy/DB-related rules transitionally (§10.4–10.6 are candidates for relocation to `engineering/200_supabase_architecture.md` or `engineering/300_web_frontend.md` in future releases).

### 10.1. CI/Deployment Safety Standards
*   **The CI Timeout Protocol**: Give every CI job an explicit timeout derived from normal duration, resources, external dependencies, and retry behavior; prohibit unbounded execution. Ten minutes is a reference target for a fast-feedback job, not a universal cap for builds, device tests, or security scans.
*   **The Red Button Checklist**: Convert applicable Legal, Security, FinOps, Data, and reliability risks into machine-readable gates or traceable approval. Do not make a manual checklist the sole implementation for every release.
*   **Omnichannel Check**: When multiple clients are in the product contract, verify shared domain and API contracts separately from client-specific UX. Do not force omnichannel requirements on a system that does not promise non-Web clients.
*   **Deployment Safety Protocol**:
    *   **Primary Directive: The AI Git Ban**: Refer to `000_core_mindset.md` Rule 8.1 for the strict prohibition of AI Git operations.
    *   **The Automated Deployment Mandate (CD First)**: Default to a reproducible, auditable pipeline that records artifact digest, approval, staged delivery, and rollback. Do not ban break-glass deployment outright; require least privilege, two-party control or independent post-review, complete logging, expiring credentials, and restoration of automation.
    *   **The Architectural Preservation Protocol**: Protect core boundaries through ownership, protected paths, review policy, contract tests, or equivalent controls. An `@preservation_level CRITICAL` header is an optional implementation.
*   **Security**: Never commit secrets. Verify the repository and history in CI through a secret scanner or equivalent control; TruffleHog is an example.
*   **Lockfile Recovery Discipline**: When only CI fails, first compare the runtime, package manager, registry, platform, and lockfile digest. Treat regeneration as an intentional dependency change requiring a complete dependency diff review, tests, and SCA; it is not the default recovery step.
*   **The Connection Verification Protocol**: On database connection errors, inspect effective configuration, secret source, DNS, IPv4 or IPv6, routing, firewall, TLS, credentials, pool saturation, and provider status by layer. `.env.local` is only one local-development example.

### 10.2. The IPv6 Deployment Protocol
*   **Law**: Do not hide a mismatch among CI or runtime IPv4 or IPv6 support, DNS, routing, and provider endpoints by changing domain logic. Reproduce and diagnose the network layer.
*   **Action**: Select a provider-supported route such as a dual-stack endpoint, compatible network, or IPv4 pooler or proxy, and verify TLS, pooling semantics, failover, and exit conditions. Supabase Connection Pooler is one IPv4 fallback example.

### 10.4. The Migration Immutability Protocol (History Protection)
*   **Law**: Using column names planned for future implementation but not yet applied via migration is prohibited.
*   **Action**: Only use columns that "currently, with certainty, exist." Supplement unimplemented feature data with application-layer constants.

### 10.5. The Version Alignment Protocol (Zod/RHF)
*   **Law**: Version mismatches between `zod`, `react-hook-form`, and `@hookform/resolvers` cause "runtime validation failures."
*   **Action**: Update form-related libraries together. Using `as any` to suppress version mismatch type errors is prohibited.

### 10.6. The Zod Nullable DB Alignment Protocol
*   **Law**: Zod schemas for DB columns allowing `NULL` must use **`.nullable()`** instead of `.optional()`.
*   **Action**:
    1.  For `DEFAULT NULL` columns, apply `z.string().nullable()`.
    2.  When UI needs `undefined`, explicitly transform: `.nullable().transform(v => v ?? undefined)`.
    3.  When `NOT NULL` constraints change in migrations, update Zod schemas **simultaneously**.

---

## Part XI: Documentation Ops

### 11.0. Living Documentation
*   **Mermaid.js**: Manage architecture diagrams as code (Mermaid) to prevent staleness.
*   **ADR**: Record technical decisions in `docs/adr` as Markdown.
*   **The Live Docs Requirement**: API endpoints must be continuously visible via Swagger UI or ReDoc.

### 11.1. Docs as Code & Freshness
*   **Docs as Code**: Documentation is equal to code — manage in Git, include in PR reviews. Code changes without doc updates are merge-blocked.
*   **Freshness**: Automate link-rot checking and review major rules quarterly.

### 11.2. README Standard Protocol
*   **Law**: README.md must contain the following sections to enable Day 1 productivity for new members:
*   **Required Sections**:
    | Section | Content |
    |:--------|:--------|
    | **Overview** | Project purpose (1-2 sentences) |
    | **Tech Stack** | Major frameworks/libraries |
    | **Local Dev** | `npm install` → `npm run dev` steps |
    | **Environment** | All `.env.example` variables with descriptions |
    | **Directory** | Role of major directories |
    | **Deployment** | Production deployment flow |

---

## Part XII: Engineering Quality Protocols

### 12.1. The Zero-Warning Lint Protocol
*   **Law**: A true CI pass means zero warnings from the language-native formatter, linter, type checker, or compiler. `npm run lint` is only a TypeScript or JavaScript example. Follow `320_programming_language_governance.md` for required gates and remove unused symbols immediately.

### 12.2. The Clean Import Protocol
*   **Law**: Imports, uses, and includes follow the language's official placement rules and default to a form that supports static dependency tracing. Dynamic imports for lazy loading, plugins, or cycle avoidance require an explicit boundary, failure handling, and tests.

### 12.3. The Explicit Explanation Protocol (Zero Jargon)
*   **Law**: Add `Tooltip` to all technical terms and metrics in admin UIs, explaining "what it is and how it impacts the business" in layperson terms.

### 12.4. Localization First Protocol
*   **Action**: Localize all error and validation messages (including Zod custom errors) into the project's native language.

### 12.5. The Recursive Logic Ban (Infinite Recursion Shield)
*   **Law**: Prohibit deep recursion with unclear termination conditions. Always define a **Depth Limit** constant.
*   **Reason**: Prevents stack overflow and infinite DB reads that cause cloud bankruptcy.

### 12.6. The Atomic Commits Protocol
*   **Law**: Each commit must contain only "one logical change." No mixing formatting and feature additions.
*   **Revertability**: Maintain granularity where reverting a single commit fixes the issue.
*   **Prohibition**: WIP commits to production branches are prohibited.

### 12.7. The Conventional Commits Standard
*   **Law**: Commit messages must follow `type(scope): subject` format.
*   **Types**: `feat`, `fix`, `refactor`, `perf`, `docs`, `style`, `test`, `chore`, `security`
*   **Breaking Change**: Use `feat!:` or `BREAKING CHANGE:` in footer for breaking changes.

### 12.8. The Code Review Protocol
*   **Law**: Apply risk-based human review or equivalent independent change approval and mandatory automated gates to production changes. Prefer small, single-purpose, revertible changes. Four hundred changed lines is a reference heuristic for considering a split, not a universal limit. Count generated code, migrations, and vendored artifacts separately, and require design review, a reason the change cannot be split, and staged release for large changes.
*   **Review Checklist**:
    | Aspect | Check |
    |:-------|:------|
    | **Type Safety** | No `as any`, proper type definitions |
    | **Security** | No PII exposure, access control verified |
    | **Performance** | No N+1 queries, no unnecessary re-renders |
    | **FinOps** | No infinite DB read loops, proper caching |
    | **i18n** | UI text in operator's native language |
    | **Accessibility** | Keyboard navigable, proper `aria-label` |
    | **Resilience** | Timeout settings, retry logic, Circuit Breaker verified |
    | **Observability** | New endpoints include metrics instrumentation |
*   **AI-Assisted Review Governance**:
    *   Using AI Review tools such as GitHub Copilot Code Review and CodeRabbit is recommended, but comply with the following:
    *   **AI Review ≠ Human Review**: AI review findings are "reference information" and do not replace Human Review. Final approval must be made by a human.
    *   **False Negative Awareness**: AI cannot verify "the correctness of logic intent" or "alignment with business requirements." Humans must take responsibility for these aspects.
    *   **Security Override**: Security aspects (authentication, authorization, PII) must always be explicitly verified by a human, not delegated to AI Review.

### 12.9. Ownership & Change-Approval Protocol
*   **Law**: Assign accountable owners and continuity routes to critical directories, modules, schemas, infrastructure, and release paths, and connect the ownership registry to change controls. `.github/CODEOWNERS`, GitLab CODEOWNERS, repository rules, and external change management are example implementations. Enforce independent review of the final revision and dismissal of stale approvals on high-assurance paths; for low-risk or solo maintenance, allow compensating controls recorded in the Blueprint.

### 12.10. The Git Hooks Automation Protocol (Three-Layer Defense)
*   **Law**: Enforce quality through "physically impossible" mechanisms, not "be careful" policies.
*   **Three-Layer Defense**:
    | Layer | Hook | Content | Tools |
    |:------|:-----|:--------|:------|
    | **Pre-Commit** | `pre-commit` | Auto lint/format | `husky` + `lint-staged` |
    | **Commit-Msg** | `commit-msg` | Conventional Commits validation | `commitlint` |
    | **Pre-Push** | `pre-push` | Block direct push to protected branches | Branch name check script |
*   `--no-verify` hook bypassing is zero-tolerance prohibited.

### 12.11. The Branch Naming Convention
*   **Law**: Unify branch names in `type/summary` format.
*   **Types**: `feat/`, `fix/`, `refactor/`, `chore/`, `hotfix/`
*   **Merge Strategy**: Default to Squash Merge to keep commit history clean.
*   **Branch Cleanup**: Delete merged branches immediately.

### 12.12. The SSOT Sync Protocol
*   **Law**: After merging work branches, local `main` must be synchronized with the latest remote SSOT state.
*   **Action**:
    1.  `git checkout main` → `git pull origin main` → delete merged branches.
    2.  Verify local `main` is current before starting new tasks.
    3.  Creating branches from stale `main` is prohibited.

---

## Part XIII: Advanced Architectural Mandates

### 13.1. The Trinity DTO Mandate
*   **Law**: Any code violating the following 3 principles is unconstitutional and subject to immediate correction:
    1.  **Security (PII Defense)**: Raw Row output is prohibited. Always use **DTO (White-list)** to physically block sensitive information.
    2.  **Stability (Frontend Shield)**: Never directly couple DB schema to UI. Build a Mapper function "seawall" to absorb change impact server-side.
    3.  **AI Economy (Token Optimization)**: Never feed unnecessary data to AI. Use **AI-Optimized DTOs** to minimize tokens and maximize inference accuracy.
*   **DTO Design Rules**:
    *   **Strict Segregation**: Physically separate DTOs containing sensitive fields into `AdminDTO` / `PublicDTO` at the type level.
    *   **No Raw Return**: Server Actions/APIs must never return raw DB types. Always return DTO types.
    *   **No Blind Spread**: Spread syntax (`...user`) in DTO transformation layers is **completely prohibited** as it leaks future sensitive columns.
    *   **Strict Field Selectionification Pattern**: `SELECT *` or `.select('*')` is prohibited. Explicitly enumerate required columns.
*   **DTO Sync Obligation**: When Backend DTOs change, Frontend Props types must be updated **simultaneously**. One-sided updates directly cause `undefined` reference runtime errors.
*   **DTO Boundary Casting**: Convert DB results to DTOs using explicit mapping functions (`toDTO(dbResult): MyDTO`), not `as any`.
*   **DTO Segregation**: Prohibit bloated single type definition files. Split by feature domain (e.g., `types/store.ts`, `types/user.ts`).
*   **Mapper Input Robustness (Postel's Law)**: Be liberal in mapper inputs (tolerate ORM inference imperfections), strict in outputs (guarantee complete DTO types).
*   **Explicit Mapping Mandate**: Prohibit spread syntax (`...input`) for write payload construction in Service layer. Map all fields individually.

### 13.2. The Client-Server Boundary Protocol
*   **Client DB Access Prohibition**: Direct `supabase.from()` calls from client-side are prohibited. Route all data operations through `Server Actions` or `Route Handlers`.
*   **Secure Write Action Protocol (Turnstile Mandate)**: Public form write Server Actions must accept and verify `turnstileToken` server-side.
*   **Service Pattern Mandate**: Direct DB access function calls in `page.tsx` or `layout.tsx` are prohibited. Extract to `lib/api/gateways/` (Read) or `lib/actions/` (Write).
*   **Async Boundary Protocol**: Directly importing async Server Components into Client Components violates React specifications. Use `children` Prop or Composition patterns.

### 13.3. The Service Layer Architecture
*   **Service Layer Extraction Mandate**: Entry points (Route Handlers, Server Actions) must be "thin interfaces." Direct business logic in entry points is prohibited.
*   **Thin Controller Mandate**: Controller code is limited to: (a) request parsing/validation, (b) auth/authz checks, (c) Service layer calls, (d) response construction. Direct DB calls in controllers are prohibited.
*   **Service Aggregation Protocol**: Extract aggregation logic for single-page data from multiple Gateways/Actions into Service layer `get...Data()` functions.
*   **Omnichannel Delivery Mandate**: Direct business logic or data access in UI components is prohibited. Extract all logic to Service/Gateway layer for reusability across Web, mobile, and AI agents.
*   **Error Translation**: Service layer exceptions must be translated to HTTP status codes in the Controller layer. Service layer must not know HTTP.

### 13.4. The CQRS & Cache Strategy
*   **CQRS Separation Mandate**: Mixing Read and Write logic in a single function is prohibited. Clearly separate `QueryGateway` and `CommandGateway`.
*   **No Side Effects in Queries**: Query methods must only read and transform. No DB writes or external API calls.
*   **Hierarchical Cache Strategy**: Uniform caching regardless of data characteristics is prohibited. Classify into tiers:
    *   **STATIC**: CDN/ISR. **WARM**: TTL 5min–1hr + SWR. **HOT**: Short TTL + on-demand revalidation. **REALTIME**: No cache + WebSocket/SSE.
*   **Cache Invalidation Ceremony**: After core query logic changes, mandatory build cache deletion and full dev server restart.
*   **Cache Hit Rate**: Measure cache hit rates; endpoints below 90% are optimization targets.

### 13.5. The Mutation Integrity Protocol
*   **Law**: In write operations, `error: null` does NOT mean success. Always verify affected row count (`count`); throw explicit error on 0 rows.
*   **Count Validation**: For single-record operations by ID, verify affected rows match expected value. `error: null` + `count: 0` is "Phantom Success."
*   **Sub-Step Integrity**: When multiple write operations occur in a single Service function, verify `error` and `count` individually for every sub-step. Prevent "Partial Phantom Success."
*   **Fail-Fast Cascade**: If any step detects an error, abort subsequent steps immediately.
*   **Post-Mutation Verification Fetch**: After critical updates, re-fetch by same ID to verify data persistence via logs. This 100% distinguishes "DB write failure" from "cache issues."
*   **Step-by-Step Logging**: Log each sub-step result (e.g., `Logger.info('[Step 2/5] Updating tags...')`) for rapid root cause identification.
*   **RLS Awareness**: With Row Level Security databases, insufficient permissions return as "0 rows affected," not errors.

### 13.6. The Type Safety & Integrity Protocol
This section is an additional TypeScript-specific standard. `320_programming_language_governance.md` is the source of truth for cross-language type and boundary contracts.
*   **Zero `as any` Policy**: Using `as any` or `as never` to suppress type errors is "embedding bugs." Set ESLint `@typescript-eslint/no-explicit-any` to `error`.
*   **Root Cause Resolution**: Resolve type errors through "type definition fixes," "DTO redesign," or "generics application," not casts.
*   **Type Bridge Mandate**: For auto-generated type gaps, define extension types in `database-extensions.ts` using Mapped Types to prevent type collisions.
*   **Linter Suppression Prohibition**: `eslint-disable` / `@ts-ignore` usage is prohibited in principle. If unavoidable, always include reason comment and Issue number.
*   **Generic Type Inference Safety**: Prohibit `Record<string, any>`. Use `Record<string, unknown>` or constrained generics.
*   **Verification Gate**: Committing code that doesn't pass type checking (`tsc --noEmit`) and linting with **zero warnings** is prohibited.

### 13.7. The Error Handling Contract
*   **Structured Error Return**: Server Actions are **prohibited** from using `throw new Error()` for business logic failures. Return `{ success: false, error: '...' }` structured responses instead.
*   **Graceful Failure Contract**: Display errors via toast notifications or inline error messages for proper user feedback.
*   **Server-Client Symmetry**: When strengthening server-side guards, always simultaneously prepare frontend "error receivers."
*   **Structured Error Logging**: Prohibit direct embedding of error objects in string templates (outputting `[object Object]`). Explicitly destructure `message`, `code`, `details` for logging.
*   **Centralized Logging Protocol**: Prohibit `console.log` in production. Always use `src/lib/logger.ts`.
*   **Read-Write Privilege Symmetry**: When using privileged clients for writes, ensure equivalent visibility for "reads for editing."

### 13.8. The Dead Code & Workspace Cleanup
*   **Dead Code Prohibition**: Immediately delete all unused code (variables, imports, functions, type definitions). No commented-out code. Git history is your archive.
*   **YAGNI Strictification**: "Might use later" code is "noise." Pre-emptive implementation not in current user stories is technical debt.
*   **Clean Workspace Mandate**: Before commit, remove all temporary files, build caches, empty directories, and `console.log`.
*   **Unstable Timer Protocol**: Using `setTimeout` or `setInterval` for logic control is prohibited. Use event-driven architecture or job queues.

### 13.9. The API Product & Configuration
> Also refer to **§13.15 Idempotency Key Protocol**.
*   **API Product Mindset**: All data output is a "Product." Design APIs with **Tier 1 (Public/Free)** and **Tier 2 (Enterprise/Paid)** separation. Instrument all Enterprise APIs with `recordApiUsage`.
*   **API Latency Budget**: All Public/Enterprise API TTI must be **≤200ms**. Offload heavy processing to async queues, returning `202 Accepted`.
*   **VIP Lane Strategy**: Implement OR condition for "Bearer Token auth" and "API Key auth" for first-party native apps, granting privileged tier to authenticated users.
*   **Tenant-Aware Naming**: Use `site_` / `account_` prefixes for per-customer resources; `system_` only for cross-tenant immutable infrastructure settings.
*   **Legal Hardcoding Ban**: Hardcoding legal text in source code is prohibited. Enable non-engineers to edit via admin UI.
*   **Static Master Protocol**: Centralize app-wide constants in `constants/`. Prohibit in-component hardcoding. Define with `as const` and derive types via `typeof`.
*   **Projection-Schema Parity**: Data fetch projections must 100% match physical DB schema. Prohibit "phantom fields" defined in UI/DTO but absent from DB.

### 13.10. The Authentication & Access Control
*   **Audit Bypass Anti-Pattern**: Direct client-side DB writes bypass audit logs and violate governance. All data updates must go through Server Actions with `recordAuditLog`.
*   **Authentication Guard Enumeration Consistency**: In RBAC, managing allowed role lists separately across multiple guard functions is **prohibited**. All guards must reference a shared constant array (`ALLOWED_ADMIN_ROLES`).
*   **Dead Zone Detection**: Periodically audit that page-level guards and action-level guards reference the same role set to prevent "can enter page but operations fail" dead locks.

### 13.11. The Build & Deploy Verification
*   **Production Build Verification**: Dev server running does NOT prove code correctness. Before task completion, pass the **Triple Crown**:
    1.  Type checking (`tsc --noEmit`): Zero type errors
    2.  Linter (`eslint --max-warnings=0`): Zero warnings
    3.  Production build (`npm run build`): Build success
*   **CI/CD Environment Gap Protocol**: CI tests against "empty databases" and cannot detect existing data conflicts. Use `ON CONFLICT` for idempotent `INSERT` statements.
*   **Multi-Axis Deployment Audit**: Verify all 4 axes are green for feature changes:
    1.  **Security**: Destructive actions have audit log instrumentation
    2.  **Structured Data**: Structured data (JSON-LD, OpenGraph) is current
    3.  **UX**: Error messages are properly localized
    4.  **Type Safety**: No new `any` or opaque casts introduced

### 13.12. The Migration & Schema Safety
*   **Migration Static Analysis Guard**: Execute **static analysis** on migration files during Push/Merge in CI pipelines, physically rejecting dangerous SQL patterns.
*   **Forbidden Patterns**: `UPDATE` without `WHERE`, `INSERT` without `ON CONFLICT`, `UNIQUE` constraint without cleanup.
*   **Pre-push Hook**: Run local scripts before push to provide immediate feedback on dangerous SQL. `--no-verify` bypass is prohibited.
*   **CI Pipeline**: Maintain `migration:check` job as human error's final defense line.

### 13.13. The Feature Flag Lifecycle Protocol
*   **Context**: Feature Flags enable safe releases, but unmanaged flags increase code complexity and become technical debt.
*   **Lifecycle**:
    | Phase | Description |
    |:------|:------------|
    | **Create** | Document flag name, purpose, and expiration |
    | **Enable** | Validate in staging, then gradually roll out to production |
    | **Full Rollout** | Complete deployment to all users, start deletion countdown |
    | **Delete** | Remove all flag-related code, return to clean state |
*   **Maximum Lifespan**: **90 days**. Expired flags are recorded as technical debt and prioritized for deletion in the next sprint.
*   **Naming Convention**: Recommend `FF_<FEATURE_NAME>` format.
*   **Prohibition**: Feature Flag nesting is **prohibited** due to cognitive complexity explosion.
*   **Cleanup Obligation**: When deleting a flag, remove all related conditional branching code **in the same PR**.
*   **Quarterly Inventory**: At quarter-end, inventory all flags and apply:
    | State | Days | Action |
    |:------|:-----|:-------|
    | ON (fully deployed) | > 30 | Delete flag, keep new feature code only |
    | OFF (deprecated) | > 30 | Delete both flag and legacy code |
    | Experimenting | > 90 | Record as tech debt, resolve next sprint |

### 13.14. The WebAssembly & Edge Execution Protocol
> For resilience in edge execution, also refer to **§15.1 Circuit Breaker**.
*   **Context**: WebAssembly (Wasm) and edge execution are architectural options whose value depends on workload, host capability, latency, portability, isolation, observability, and operating cost. Adoption decisions must be grounded in measured criteria rather than trend or vendor availability.
*   **WASM 3.0 Capability Awareness**:
    *   **WebAssembly 3.0 was completed on September 17, 2025**. Its core specification includes capabilities such as garbage collection, 64-bit address spaces, exception handling, tail calls, and multiple memories. Verify actual target-engine support rather than assuming every Wasm 3.0 capability is available on every host.
    *   **Component Model and WASI are separate compatibility decisions**: pin the component, WIT, runtime, and host-capability matrix. WASI 0.3.0 was released on June 11, 2026 with native async constructs including `async func`, `stream<T>`, and `future<T>`; WASI 0.2 remains a stable compatibility target and WASI 0.1 is legacy but widely deployed.
*   **WASM Adoption Criteria**:
    *   **Candidate use cases**: measured CPU-intensive computation, browser portability of existing tools, capability-isolated plugins, and cross-language components. Validate end-to-end latency, binary size, interoperability, debugging, and operational ownership against a native or JavaScript baseline.
    *   **Poor-fit signal**: Wasm adds a compiler, runtime, interface, or incident boundary without a measured portability, isolation, performance, or reuse benefit. Record the adoption hypothesis and an exit condition instead of categorically banning a workload class.
*   **Edge Execution Boundary**:
    *   **Candidate logic**: request-local authorization, routing, header transformation, experimentation, and bounded compute may benefit from proximity when the platform capability and consistency model fit.
    *   **Host constraints**: Database writes, long-running work, network access, and state are permitted only when the selected host explicitly supports the required duration, consistency, transaction, retry, and recovery semantics. Do not infer safety from an edge product name.
    *   **Cold-start budget**: Derive the target from the user-facing latency SLO, request path, runtime, region, and cost. Fifty milliseconds is a reference profile, not a Universal threshold; scheduled warm-up is only one costed mitigation and may be unavailable or wasteful.
*   **WASM Security Constraints**:
    *   WASM modules must be designed with awareness of the Content Security Policy (CSP) `wasm-unsafe-eval` directive.
    *   Treat Wasm as untrusted code despite memory isolation. Verify source, signature or digest, SBOM, provenance, runtime, imports, capabilities, filesystem and network grants, resource limits, and escape response. SRI is a Web transport-integrity control, not publisher trust or a universal non-Web control. Unknown components may run only inside a deliberately isolated analysis or plugin boundary with explicit capabilities and no ambient authority.

### 13.15. The Idempotency Key Protocol
*   **Context**: Network failures and timeout-triggered retries cause "terrifying side effects" like double charges and duplicate orders. Idempotency design is a fundamental obligation in distributed systems.
*   **Mandate**:
    *   **Mutating APIs (POST/PUT/DELETE)**: Clients must include an `Idempotency-Key: <UUID v4>` header on all requests.
    *   **Server-side**: Based on the received key, implement a caching layer (Redis / KV store) to prevent double-processing of the same request.
    *   **TTL**: Standard idempotency cache expiry is **24 hours**.
    ```typescript
    // Server-side idempotency check implementation pattern
    async function processPayment(idempotencyKey: string, payload: PaymentPayload) {
      const cached = await redis.get(`idem:${idempotencyKey}`);
      if (cached) return JSON.parse(cached); // Cache hit: return previous result
      
      const result = await executePayment(payload);
      await redis.set(`idem:${idempotencyKey}`, JSON.stringify(result), 'EX', 86400);
      return result;
    }
    ```
*   **Saga Pattern for Long Transactions**: For long-running transactions spanning multiple services (payment → inventory → shipping), adopt the **Saga Pattern** (Choreography or Orchestration) instead of 2PC. Each step must define a **Compensating Transaction**.

---

## Part XIV: Platform Engineering

> [!NOTE]
> Platform Engineering is the discipline of designing the developer experience (DX) as a product. The infrastructure team evolves from "managing infrastructure" to "providing an Internal Developer Platform (IDP)." For detailed implementation, refer to `operations/400_site_reliability.md`.

### 14.1. Internal Developer Platform (IDP) Applicability
*   **Law**: Establish a scale-appropriate Platform Engineering function when repeated undifferentiated work, cognitive load, control inconsistency, or wait time is measured across multiple teams or repositories and the benefit of a shared capability exceeds its build and operating cost. Do not require a dedicated platform team or portal for every small or one-off project.
*   **Minimum Viable Platform**:
    *   Treat the platform as a thin product layer providing capabilities selected from user demand. Documentation and standard procedures, repository templates, shared CI, CLIs or APIs, service catalogs, managed-service integration, and portals are all candidates; do not build every element from the start.
    *   When manual tickets for provisioning, deployment, observability, secrets, or cost evidence become repeated bottlenecks, prioritize safe self-service and policy automation. Do not remove human review unconditionally from high-risk actions.
*   **Golden Path Contract**:
    *   For journeys with repeated demand, provide a Golden Path with safe defaults, an owner, support scope, upgrades, rollback, an escape hatch, and verification evidence. Templates, workflows, IaC modules, runbooks, and dashboards are interchangeable components.
    *   A Golden Path is an optional, composable paved road. Scale deviation review to risk and blast radius; do not force dedicated-team consultation for an equivalent low-risk mechanism. Measure adoption, lead time, failures, and satisfaction, and improve user-demand fit when off-road use becomes normal.
*   **Evidence**: As described by the [CNCF Platforms White Paper](https://tag-app-delivery.cncf.io/whitepapers/platforms/), select platform capabilities from user needs, start with the thinnest viable layer, avoid fixing the interface to a portal, and keep the platform optional and composable.

### 14.2. Infrastructure as Code (IaC) Mandate
*   **Law**: Manage production, shared, security, identity, or network boundaries and other control-plane configuration requiring recreation, audit, or recovery reproducibly through declarative configuration, IaC, provider-native configuration, versioned API inputs, or equivalent mechanisms where the provider supports machine management. Terraform, OpenTofu, Pulumi, CDK, CloudFormation, and Bicep are interchangeable examples.
*   **Manual Change Boundary**: For unsupported surfaces, bootstrap, investigation, or emergency containment, record the target, reason, approval, before and after evidence, expiry, rollback, and reconciliation into the declarative source. Routine ClickOps dependency and unrecorded drift are prohibited, but not every console operation has the same risk.
*   **IaC Quality Standards**:
    *   **Structure**: Create modules where multiple consumers, a stable contract, and independent tests provide value; do not over-abstract one-off resources merely for DRY.
    *   **State and Source Management**: Stateful tools must use an approved backend with encryption, access control, concurrency control, versioning or recovery, and audit. Do not force provider-managed state or stateless templates into the same backend. Committing credentials or sensitive state to Git is prohibited.
    *   **Plan-before-Apply**: Generate a machine-readable plan or diff at a PR, Merge Request, change request, or equivalent approval boundary and inspect policy, security, cost, destructive changes, and drift. Separate apply authority from plan authority and execute after risk-based approval or policy-approved automation.
    *   **Cost Estimation**: Estimate material billing changes with provider calculators, Infracost, billing models, load tests, or equivalent evidence and connect them to budgets, unit economics, commitments, egress, and rollback. Define approval thresholds and the accountable function in the Blueprint; a fixed `+20%` or named role is not a Universal requirement.
        ```hcl
        # Terraform reference policy input. Replace keys in the Blueprint.
        required_tags = ["environment", "team", "cost-center"]
        ```

### 14.3. Observability First Protocol
*   **Law**: Observability is not something added **after** code is written — it is a **part of the design**. The definition of done for new features must include "Instrumentation implementation" as a mandatory requirement.
*   **Three Pillars (Mandatory)**:
    *   **Logs**: All services must emit structured logs (JSON format). `console.log` in production is prohibited (see §13.7).
    *   **Metrics**: All API endpoints must export at minimum: `request_count`, `error_rate`, `latency_p99`.
    *   **Traces**: Enable distributed tracing (OpenTelemetry) on all services to correlate calls across microservices and async processes.
    *   **Profiles**: Enable **Continuous Profiling** in production to identify CPU and memory hotspots in real time. This is the 4th pillar of Observability. Recommended tools: Pyroscope / Parca / Google Cloud Profiler.
        ```typescript
        // Pyroscope integration example (Node.js)
        import Pyroscope from '@pyroscope/nodejs';
        Pyroscope.init({
          serverAddress: process.env.PYROSCOPE_SERVER_URL!,
          appName: 'api-server',
          tags: { environment: process.env.NODE_ENV!, version: process.env.APP_VERSION! },
        });
        Pyroscope.start();
        ```
*   **OpenTelemetry Standardization**: To avoid vendor lock-in, use the OpenTelemetry SDK standard for instrumentation. Avoid direct dependency on vendor-specific SDKs (Datadog SDK, New Relic SDK, etc.); route through the OTel layer.
    ```typescript
    // Standard OpenTelemetry instrumentation
    import { trace, metrics } from '@opentelemetry/api';
    const tracer = trace.getTracer('service-name', '1.0.0');
    const span = tracer.startSpan('operation.name');
    try {
      // ... business logic
    } finally {
      span.end();
    }
    ```
*   **GenAI Semantic Conventions (2026 Mandate)**: For LLM-integrated services, instrument telemetry using the **OTel GenAI Semantic Conventions** established by the OpenTelemetry GenAI SIG. This ensures consistent telemetry schema across LLM providers (OpenAI, Anthropic, Gemini, etc.) without vendor-specific instrumentation.
    *   **Mandatory AI Telemetry Attributes**: Capture `gen_ai.system`, `gen_ai.model.id`, `gen_ai.usage.input_tokens`, `gen_ai.usage.output_tokens`, and response latency per LLM call. This enables per-model cost attribution and quota management.
    *   **Agentic Chain Tracing**: For multi-step AI agent flows, ensure the full reasoning chain (tool calls, LLM invocations, intermediate outputs) is captured as child spans within a single trace to enable root-cause analysis of agent failures.
    *   **AI-Specific Metrics**: Export `gen_ai.client.token.usage`, `gen_ai.client.operation.duration`, and hallucination/error rates as standard metrics alongside infrastructure metrics.
*   **OTel Arrow Protocol**: For high-volume telemetry environments, adopt the **OTel Arrow** wire protocol (up to 80% bandwidth reduction vs. standard OTLP). Implement at the OTel Collector level to reduce observability infrastructure costs without application code changes.
*   **eBPF Auto-Instrumentation (Zero-Code Approach)**: For services where recompilation is impractical, evaluate **Beyla** (eBPF-based instrumentation) for zero-code observability at the kernel level. Beyla captures HTTP, gRPC, and database calls without modifying application code, making it suitable for legacy or third-party services.
*   **SLO as Code**: Define SLI/SLOs as code (OpenSLO / Sloth, etc.) and manage in Git. "Verbally defined SLOs" are documentation debt. Refer to `operations/400_site_reliability.md` for details.

*   **Error Budget Policy**:
    *   **Error Budget**: `Error Budget = (1 - SLO) × period`. Example: SLO 99.9% × 30 days = 43.2 minutes of Error Budget.
    *   **Consumption Rate Alerts**: When Error Budget consumption exceeds the following thresholds, automatically fire alerts:
        | Consumption Rate | Response Action |
        |:-----------------|:----------------|
        | 50% consumed (within first 10 days of month) | Notify development team, begin root cause investigation |
        | 75% consumed | Freeze new feature releases, prioritize reliability improvements |
        | 100% consumed (Burndown) | Stop all releases, mandatory Post-Mortem with SRE team |
    *   **Burn Rate Alert**: Set an alert rule using Prometheus/Grafana etc. to detect `burn_rate > 14.4x` within a 5-minute window (Fast Burn Detection).
*   **Alert Fatigue Prevention**:
    *   **Rule**: Alerts must be limited to "events that a human must actually respond to." "Alerts we know about but don't act on" are noise that causes fatigue. Alerts that remain "no action required" for 30+ days must be deleted or automatically suppressed.
    *   **4 Principles of Alert Design**:
        1.  **Actionable**: "What to do next" must be clear when an alert fires
        2.  **Meaningful**: Events affecting SLOs only (Symptom-based alerting)
        3.  **Priority**: 3 tiers — P1 (immediate), P2 (within 1 hour), P3 (next business day)
        4.  **Deduplicated**: One alert per root cause (Alert Grouping mandatory)
    *   **Tools**: Use PagerDuty / OpsGenie Routing Rules to automatically manage time-of-day, day-of-week, and on-call rotation. Configure so P3 alerts at 3 AM don't page on-call engineers.

### 14.4. Event-Driven Architecture Fundamentals
*   **Context**: Asynchronous Event-Driven Architecture (EDA) is essential for building loosely coupled systems and ensuring scalability. From 2026 onwards, it is the de facto standard for inter-service communication.
*   **When to Use EDA**:
    *   **Appropriate**: Async notifications between services (order completion email, point award), async recording of user actions (audit logs), integrations requiring loose coupling between services, workloads requiring back-pressure.
    *   **Inappropriate**: User requests requiring immediate response (use request-response pattern), simple synchronous operations.
*   **EDA Design Principles**:
    *   **Idempotency**: All event consumers must be idempotent — safe to process even if the same event is delivered multiple times. Implement dedup logic via `message_id`.
    *   **Event Schema Management**: Centrally manage event schemas in a Schema Registry. Define new schema versions for breaking changes. Breaking changes to schemas are **prohibited**.
    *   **Dead Letter Queue (DLQ)**: All message queues must have a DLQ configured to capture processing failures. Set DLQ alerts; abandonment is prohibited.
    *   **Event Versioning**: Events must always include `eventType`, `eventVersion`, `timestamp`, `correlationId`.
        ```json
        {
          "eventType": "order.completed",
          "eventVersion": "1.0",
          "timestamp": "2026-04-20T01:00:00Z",
          "correlationId": "req-abc123",
          "payload": { "..." }
        }
        ```

### 14.5. Multi-Tenancy Architecture Protocol
*   **Context**: In SaaS products, multi-tenancy — safely operating multiple customers (tenants) in a single system — must be woven into the design from day one. Retrofitting multi-tenancy is among the greatest technical debts possible.
*   **Tenant Isolation Model Selection**:
    | Model | Isolation Level | Cost | Best Fit |
    |:------|:---------------|:-----|:---------|
    | **Silo** | Full (DB + infra isolated) | High | Regulated industries, high-security requirements |
    | **Bridge** | Medium (DB isolated, infra shared) | Medium | Mid-size SaaS, data sovereignty requirements |
    | **Pool** | Low (DB + infra shared) | Low | Startups, cost-first |
*   **Mandatory Design Principles**:
    *   **Tenant Context Propagation**: In all request processing, extract tenant ID from the auth token and thread it through the service layer and DB layer. A missing `context.tenantId` is **the system's greatest vulnerability**.
    *   **Row Level Security (RLS)**: When using the Pool model, enable RLS at the DB layer to physically prevent cross-tenant data leaks (see `engineering/200_supabase_architecture.md` for details).
    *   **Cross-Tenant Leak Test**: Always include "cross-tenant leak verification" in your test strategy. Verify via E2E tests that tenant A's credentials cannot access tenant B's data.
    *   **Noisy Neighbor Protection**: Apply rate limits per tenant at the request/query level to prevent a high-load tenant from impacting others.

### 14.6. Contract Testing Protocol
*   **Context**: In microservices or split frontend/backend development, API contract (interface specification) mismatches are the leading cause of "integration errors discovered only in production." Consumer-Driven Contract Testing (CDCT) prevents this proactively.
*   **CDCT Mandate**:
    *   **Consumer Defines the Contract**: The calling side (Consumer) must define "the fields and types it needs" as a contract file. Use Pact / Spring Cloud Contract, etc.
    *   **Provider Must Verify**: The providing side (Provider) must run Provider tests against all consumer contracts in CI and **physically block deployments that violate contracts**.
    *   **Schema-First for Internal APIs**: Internal APIs (BFF / inter-microservice) must auto-generate types from OpenAPI 3.1 schemas, keeping implementation-schema drift at zero.
*   **Contract Versioning**: When making breaking changes to a contract, always adopt the "Expand-Contract Pattern" (first add the new field, then remove the old field only after all Consumers have migrated).

---

## Part XV: Resilience Engineering

> [!IMPORTANT]
> Resilience is not "preventing failures" — it is "withstanding failures and self-recovering." Every external dependency will eventually fail. Design with that premise.

### 15.1. Circuit Breaker Protocol
*   **Law**: All calls to external APIs and databases must implement the Circuit Breaker pattern. A "direct call" without fallback is a design defect that causes Cascading Failures.
*   **State Machine**:
    | State | Description | Transition Condition |
    |:------|:------------|:--------------------|
    | **CLOSED** | Normal operation. All requests pass through | Error rate exceeds threshold → OPEN |
    | **OPEN** | Tripped. All requests immediately fail; return Fallback | After timeout → HALF_OPEN |
    | **HALF_OPEN** | Tentatively pass 1 request | Success → CLOSED / Failure → OPEN |
*   **Configuration Standards**:
    *   **Error Rate Threshold**: **50%** within the last 60 seconds → OPEN
    *   **Slow Call Threshold**: Responses exceeding **2 seconds** count as "errors"
    *   **Open Duration**: Minimum **30 seconds** in OPEN state (default)
*   **Fallback Obligation**: When in OPEN state, always return a meaningful Fallback. Exposing raw errors to users is prohibited.
    ```typescript
    // Circuit Breaker implementation example (cockatiel / opossum libraries)
    import { wrap } from 'cockatiel';
    const circuitBreaker = wrap(
      timeout(callExternalApi, { milliseconds: 2000 }),
      CircuitBreakerPolicy.builder()
        .handle(HttpError).orResultType((r) => r.status >= 500)
        .build()
    );
    const result = await circuitBreaker.execute(ctx).catch(() => fallbackData);
    ```

### 15.2. Retry & Exponential Backoff Protocol
*   **Law**: Never immediately retry a failed request. Combine Exponential Backoff with Jitter to achieve natural distribution.
*   **Retry Policy**:
    *   **Max Retries**: **3** (default). Non-idempotent requests must not be retried.
    *   **Base Delay**: First retry waits **1 second**. Subsequent: `min(base * 2^attempt, maxDelay)`.
    *   **Max Delay**: **30 seconds** (upper cap)
    *   **Jitter**: `delay × random(0.5, 1.5)` to prevent Thundering Herd problem
    ```typescript
    // Exponential Backoff + Jitter implementation
    async function withRetry<T>(fn: () => Promise<T>, maxRetries = 3): Promise<T> {
      for (let attempt = 0; attempt <= maxRetries; attempt++) {
        try {
          return await fn();
        } catch (err) {
          if (attempt === maxRetries) throw err;
          const base = Math.min(1000 * 2 ** attempt, 30_000);
          const jittered = base * (0.5 + Math.random() * 1.0);
          await new Promise(r => setTimeout(r, jittered));
        }
      }
      throw new Error('Unreachable');
    }
    ```
*   **Idempotency First**: Only **idempotent requests** may be retried. Control non-idempotent operations (payment processing, etc.) with §13.15 Idempotency Keys.

### 15.3. Bulkhead Pattern
*   **Context**: Like the watertight compartments of a ship, isolate different system components so that a failure in one area does not bring down the entire system.
*   **Mandate**:
    *   **Connection Pool Isolation**: Assign **separate DB connection pools** for services with different criticality (user-facing API / admin dashboard / batch processing). Batch processing must not starve user-facing API connections.
    *   **Thread Pool Isolation**: Configure Semaphores for external API calls to limit concurrency. Default max concurrency: **10**.
    *   **Service Quota Separation**: Implement per-tenant Rate Limits in combination with §14.5 to prevent the Noisy Neighbor problem.

### 15.4. Health Check & Readiness Protocol
*   **Law**: All services must provide appropriate health check endpoints for Kubernetes / load balancers to make routing decisions.
*   **Endpoint Standards**:
    | Endpoint | Purpose | Status Codes |
    |:---------|:--------|:-------------|
    | `GET /health/live` | Liveness: Is the process alive? | 200 / 503 |
    | `GET /health/ready` | Readiness: Can it accept traffic? (includes DB connectivity) | 200 / 503 |
    | `GET /health/startup` | StartupProbe: Initialization complete? (for slow-start services) | 200 / 503 |
*   **Readiness Check Requirements**: `/ready` endpoint must verify all of:
    1.  DB connectivity (`SELECT 1` query execution)
    2.  Primary cache service (Redis, etc.) connectivity
    3.  Mandatory environment variable existence
*   **Response Time Budget**: Health checks must respond within **500ms**. Auto-timeout and return `503` if exceeded.
*   **No Business Logic**: Placing business logic in health check endpoints is prohibited. Status checks only — zero side effects.

### 15.5. Graceful Shutdown Protocol
*   **Law**: All services must implement Graceful Shutdown — completing in-flight requests before terminating upon receiving a process termination signal (SIGTERM).
*   **Shutdown Sequence**:
    1.  Receive `SIGTERM` → Stop accepting new requests (set Readiness to `503`)
    2.  Wait for in-flight requests to complete (max **30 seconds**)
    3.  Clean close DB connections and cache connections
    4.  Process exit
*   **K8s terminationGracePeriodSeconds**: In Kubernetes, set `terminationGracePeriodSeconds: 60` to ensure sufficient time for the shutdown sequence to complete.
*   **In-Flight Request Guard**: For requests in progress when the process exits, return a `Connection: close` header so clients can automatically retry.

---

## Part XVI: Developer Experience Governance

> [!NOTE]
> Excellent DX is a system capability supporting delivery speed, quality, cognitive load, recoverability, hiring and handoff, and security. Improve reproducible outcomes and measured friction without forcing the same tool or headcount on individuals, distributed teams, and regulated organizations.

### 16.1. Local Development Environment Standardization
*   **Law**: Keep the OS and architecture assumptions, runtimes, compilers, package managers, external services, environments, bootstrap, and verification commands needed for development, CI, and release in a machine-readable or executable contract, and continuously test reproducibility.
*   **Environment Profile**: Dev Containers, Nix, language version managers, package-manager wrappers, container composition, managed development environments, and native toolchain installers are interchangeable implementations. When multiple paths are supported, smoke-test convergence on the same support matrix, dependency resolution, and quality gates, and state the owner and support boundary of each path.
*   **First-Contribution SLO**: Measure time and failure rates from cloning and access acquisition through representative build, test, local startup, and first accepted change. Derive Blueprint targets from portfolio scale, hardware, network, and security controls. Thirty minutes to local startup is a reference profile for a lightweight project, not a Universal fixed value.
*   **Test Data Protocol**: Prepare required test data through a reproducible, documented path such as seeds, fixtures, factories, snapshots, synthetic generators, or isolated test tenants. Do not default to production PII, and verify reset, version compatibility, and secret separation. A one-command bootstrap is a useful Golden Path, not the only valid ecosystem implementation.

### 16.2. Cognitive Load Reduction Protocol
*   **Context**: The greatest obstacle to engineer productivity is not "code complexity" but "the cognitive cost of understanding the code."
*   **Complexity Budgets**: Select applicable signals from file or function size, parameter count, cyclomatic or cognitive complexity, dependency fan-out, nesting, and generated code, then set warning, blocking, or review thresholds in the Blueprint from the language, domain, artifact, baseline, and risk. Three hundred lines, fifty lines, four parameters, and complexity ten are reference heuristics for typical application code; do not apply them mechanically to generated code, declarative tables, parsers, or numerical kernels. Use an ecosystem-native analyzer or equivalent review evidence rather than mandating ESLint.
*   **Design Cohesion**: Do not place unbounded sets of change reasons, trust boundaries, ownership, or abstraction levels in one unit. Split when it improves cohesion, testability, failure isolation, or API clarity, not merely to satisfy a line count.
*   **Naming Contract**: Names communicate domain meaning, units, scope, lifecycle, and side effects where relevant. Do not categorically ban short local names or ecosystem conventions; require correction when ambiguity impairs review, operations, or security decisions.

### 16.3. Onboarding SLO & Knowledge Transfer Protocol
*   **Onboarding SLO (Service Level Objectives)**: The Blueprint derives milestones and targets from role, access, regulation, system scale, and employment model, then observes medians, upper percentiles, and failure causes. The following is a reference profile for a lightweight product team.
    | Milestone | Target Timeframe |
    |:----------|:----------------|
    | Local environment setup complete | By end of Day 1 |
    | First PR merged | By Day 3 |
    | Start of independent task | By end of Week 2 |
*   **Guided Support**: Provide a route through which a joiner can ask questions and reach a safe first change, such as a buddy, mentor, office hours, paired task, recorded walkthrough, or support channel. Derive headcount, frequency, and duration from team capacity and risk; do not universally mandate one person, a daily fifteen-minute meeting, or two weeks.
*   **Decision Record**: Record important decisions that affect future maintainers in a searchable, versioned source of truth such as repository documentation, an architecture catalog, or a ticket system. Include at least status, context, decision, alternatives or trade-offs, consequences, owner, and review trigger. `docs/adr/NNNN-{title}.md` is one implementation.
*   **Knowledge Continuity**: Give core capabilities an accountable owner and a continuity route for recovery, change, and handoff during leave, departure, incidents, or vendor termination. Multiple-person ownership is a strong control, but an individual or small team may compensate for key-person risk with runbooks, automation, credential recovery, external support, and an exit plan.

### 16.4. Engineering Metrics & DORA Protocol
*   **Context**: Use metrics to test improvement hypotheses, not to rank individuals, evaluate performance, or game targets. Combine delivery flow, instability, quality, and DX. DORA and SPACE are interchangeable evidence frameworks, and their definitions and current research must be revalidated at adoption against primary sources such as the [official DORA software delivery performance metrics](https://dora.dev/guides/dora-metrics/).
*   **DORA Delivery Metrics (Reference Profile)**:

> [!NOTE]
> The 2025 DORA report presented seven team profiles or archetypes to explain interactions among performance, stability, and well-being; they are not a Universal fixed-tier classifier for every organization. Use the current five metrics to baseline and improve one application or service at a time, avoiding simplistic aggregation across organizations and uniform targets.

    | Metric | Definition | Type |
    |:-------|:-----------|:-----|
    | **Deployment Frequency** | Frequency of production deployments | Throughput |
    | **Change Lead Time** | Time from code commit to production | Throughput |
    | **Failed Deployment Recovery Time** | Time from a failed deployment to recovery (formerly MTTR) | Throughput |
    | **Change Fail Rate** | Ratio of deployments requiring immediate intervention, rollback, or hotfix | Instability |
    | **Deployment Rework Rate** | Ratio of unplanned deployments made in response to production incidents | Instability |

*   **Benchmark Contract**: Obtain industry benchmarks from the current official Quick Check or an equivalent current dataset at adoption, and compare only with the same definitions, windows, and application context. Do not make fixed values such as multiple deployments per day, one hour, or five percent Universal targets for every service. Evaluate improvement from the current baseline and balance throughput with instability according to user demand, release risk, SLOs, and error budgets.

*   **Measurement Contract**:
    *   For each selected metric, record its definition, source, window, covered services or teams, missing-data behavior, owner, privacy treatment, and intended decision. Automate collection from CI/CD, incident, and deployment systems where practical. A small team or transition may use verifiable manual sampling when automation cost would exceed decision value.
    *   Do not mandate one dashboard product or VCS. Review trends and outliers at a cadence that can drive change and bind improvement actions to observed results. A weekly dashboard and quarterly retrospective are reference profiles.
*   **AI-Aware Measurement**:
    *   **AI-Assisted Change Outcomes**: After checking law, labor obligations, privacy, and measurement validity, compare quality, security, rework, review effort, and delivery outcomes for AI-assisted changes only when it informs a decision. Document the identification method, such as labels, provenance, or repository events, and its false positives and negatives. Derive difference thresholds from sample size and risk in the Blueprint; a fixed `+5pp` is not a Universal blocker.
    *   **Developer Experience**: Observe flow efficiency, cognitive load, toolchain friction, and psychological safety through an appropriate mix of anonymous surveys, interviews, and telemetry. DX Core 4 and commercial analytics are candidates, not individual-surveillance mechanisms or the only compliant implementation.
*   **SPACE Framework (Complementary Measurement)**:
    | Dimension | Sample Metrics |
    |:----------|:---------------|
    | **S**atisfaction | Developer NPS, team happiness score, DX Index |
    | **P**erformance | Bug rate, code review pass rate |
    | **A**ctivity | PR merge count (reference only, not a KPI) |
    | **C**ommunication | PR review response time, doc update rate |
    | **E**fficiency | Build time, test execution time, CI wait time |
*   **Anti-Pattern Prohibition**:
    *   Using individual commit counts or PR counts for performance evaluation is **prohibited** (misuse of Activity metrics).
    *   Inflating PR splits or unnecessary deployments to hit metric targets is a constitutional violation.
    *   Treating benchmark tiers as fixed targets is prohibited — improvement trend matters more than hitting a static tier label.


---

## Part XVII: Zero-Downtime Schema Evolution

> [!IMPORTANT]
> DB schema changes are the "highest-risk deployment." Zero-downtime schema evolution is mandatory — "maintenance windows" are unacceptable for production services from 2026 onwards.

### 17.1. Expand-Contract Pattern (Non-Destructive Migration)
*   **Law**: All non-backward-compatible schema changes (column rename, type change, column deletion) must be executed in phases using the **Expand-Contract Pattern** (also known as Parallel Change). Direct breaking changes are **absolutely prohibited**.
*   **3-Phase Process**:
    | Phase | Operation | Description |
    |:------|:----------|:------------|
    | **Phase 1: Expand** | Add new column with `DEFAULT NULL` | Existing code continues to work unchanged |
    | **Phase 2: Migrate** | Deploy app that writes to both old & new columns | Backfill batch copies existing data to new column |
    | **Phase 3: Contract** | Drop old column migration + remove old references from app | Execute only when all traffic references the new column |
*   **Backfill Safety Standards**:
    *   Execute backfills with "batch processing + rate limiting" to prevent bulk table locks on production DB.
    *   Recommended `BATCH_SIZE` is **≤1,000 rows** with `SLEEP 10ms` between batches.
    ```sql
    -- Safe backfill example (PostgreSQL)
    DO $$
    DECLARE batch_id bigint := 0;
    BEGIN
      LOOP
        UPDATE users SET new_column = old_column
        WHERE id > batch_id AND id <= batch_id + 1000 AND new_column IS NULL;
        batch_id := batch_id + 1000;
        EXIT WHEN NOT FOUND;
        PERFORM pg_sleep(0.01); -- 10ms sleep
      END LOOP;
    END $$;
    ```

### 17.2. Zero-Downtime Index Creation Protocol
*   **Law**: Adding indexes to tables requires `CREATE INDEX CONCURRENTLY`. Plain `CREATE INDEX` (non-CONCURRENT) acquires a long-duration table lock, causing production downtime.
*   **Implementation Standards**:
    *   PostgreSQL: `CREATE INDEX CONCURRENTLY idx_name ON table(column);`
    *   MySQL: `ALTER TABLE ... ADD INDEX` runs online by default. For large tables, use `pt-online-schema-change`.
    *   **Monitoring Obligation**: During index creation, monitor blocking state via `pg_stat_progress_create_index` (PostgreSQL).
*   **Index Removal**: Unused indexes degrade query performance. Quarterly, audit `pg_stat_user_indexes` for `idx_scan = 0` entries and add removal candidates to the backlog.

### 17.3. Schema Versioning & Drift Prevention
*   **Law**: Migrations are "Immutable History." Modifying or deleting an already-applied migration file is **absolutely prohibited**. Always create a new migration file for corrections.
*   **Schema Drift Detection**:
    *   Add a schema drift detection step as mandatory in the CI/CD pipeline (e.g., `supabase db diff`, `flyway diff`, `pg_dump | diff`).
    *   When a discrepancy between the production DB schema and migration history is detected, trigger a "Critical Drift Alert" and escalate immediately.
*   **Migration File Naming**: Standardize on `V{YYYYMMDDHHMMSS}__description_snake_case.sql` format to prevent timestamp collisions.

### 17.4. Safe Change Protocol for Large Tables
*   **Large Table Definition**: Tables with **≥1 million rows** or **≥1 GB in size** are classified as "large tables" and require the following additional protocols.
*   **Additional Procedures**:
    | Operation | Recommended Approach |
    |:----------|:--------------------|
    | Add column (NOT NULL) | `ADD COLUMN … DEFAULT 'value'` (instantaneous on Postgres 11+) |
    | Drop column | Must go through full 3-phase Expand-Contract |
    | Change column type | 3-phase: add new column → backfill → drop old column |
    | Rename table | Use View-based staged migration |
*   **Lock Monitoring**: Monitor lock state in real-time via `pg_locks` / `SHOW PROCESSLIST` (MySQL) before and after changes. If lock duration exceeds **5 seconds**, abort the plan and reconsider the approach.

### 17.5. Cross-Service Schema Change Coordination Protocol
*   **Context**: In microservice architectures or systems with separated frontend/backend, the coordinated deployment order of multiple services during DB schema changes is critical.
*   **Deployment Sequence Principle**:
    1.  **Phase 1 (Expand)**: Deploy DB migration first (add new column)
    2.  **Phase 2 (Migrate)**: Rolling deploy all services with both old/new column support
    3.  **Phase 3 (Contract)**: Execute old column drop migration only after all services have fully migrated
*   **Backward-Compatible API Maintenance Mandate**: API response changes due to schema changes must be managed via **Expand-Contract Pattern** (see §14.6), and Consumer services must never be forced to deploy simultaneously.

---

## Part XVIII: Accessibility Engineering

> [!IMPORTANT]
> Accessibility is not "a UX courtesy" — it is a **legal and ethical engineering obligation**. The EU Accessibility Act (EAA, effective June 2025), ADA, and Japan's Act for Eliminating Discrimination against Persons with Disabilities make accessibility violations a legal risk. Do not delegate it solely to design; **engineers must ensure compliance through implementation, CI, and testing**.

### 18.1. Accessibility Priority & Compliance Baseline
*   **Mandatory Baseline**: WCAG 2.2 Level AA is a mandatory condition in the "Definition of Done" for all new feature releases.
*   **Applicable Regulations**:
    | Regulation | Scope | Effective Date |
    |:----|:--------|:-------------|
    | EU Accessibility Act (EAA) | Products & services targeting the EU market | June 28, 2025 |
    | Americans with Disabilities Act (ADA) | US market (case law established for Web/Apps) | Immediate |
    | EN 301 549 | European public sector procurement | Immediate |
    | Act for Eliminating Discrimination against Persons with Disabilities (Japan) | Domestic services | Amended April 2024, now mandatory |
*   **Priority Order**: `Accessibility > Development Speed > Visual Polish`

### 18.2. CI/CD Accessibility Automation Protocol
*   **Law**: Relying solely on manual review for accessibility checks is prohibited. Automated checks must be embedded as mandatory gates in the CI pipeline.
*   **Automated Tool Chain (Three-Layer Defense)**:
    | Layer | Tool | Execution Timing | Purpose |
    |:--------|:------|:-------------|:----|
    | **Static Analysis** | `eslint-plugin-jsx-a11y` | Commit time (pre-commit) | Early detection of missing `alt` attributes, insufficient `label` |
    | **Component Tests** | `@testing-library/jest-dom` + `jest-axe` | Unit/Integration test runs | Auto-detection of axe-core rule violations |
    | **E2E Browser Audit** | `axe-playwright` / Playwright + `@axe-core/playwright` | CI on PR creation | Violation detection after real rendering |
*   **Violation Gate**: In CI, `violations.length > 0` from axe-core must **physically block the build**.
    ```typescript
    // Component a11y test example using jest-axe
    import { axe, toHaveNoViolations } from 'jest-axe';
    import { render } from '@testing-library/react';
    expect.extend(toHaveNoViolations);

    test('UserCard has no a11y violations', async () => {
      const { container } = render(<UserCard user={mockUser} />);
      const results = await axe(container);
      expect(results).toHaveNoViolations(); // CI blocked on any violation
    });
    ```
    ```typescript
    // E2E a11y check example using axe-playwright
    import { checkA11y } from 'axe-playwright';
    test('Login page a11y', async ({ page }) => {
      await page.goto('/login');
      await checkA11y(page, undefined, {
        detailedReport: true,
        detailedReportOptions: { html: true },
      });
    });
    ```

### 18.3. Semantic HTML Enforcement Protocol
*   **Law**: Non-semantic implementations like `div` click handlers or `span` buttons are "accessibility fraud." Auto-block via ESLint `jsx-a11y/interactive-supports-focus` rule.
*   **Semantic Implementation Checklist**:
    | Role | Correct Implementation | Prohibited Implementation |
    |:----|:---------|:--------|
    | Button | `<button type="button">` | `<div onClick>`, `<span onClick>` |
    | Link | `<a href="...">` | `<div onClick={() => router.push(...)}>` |
    | Form input | `<label htmlFor>` + `<input id>` | `placeholder` only with no `label` |
    | Dialog | `<dialog>` or `role="dialog"` + `aria-modal` | `div` modal controlled by visibility only |
    | Navigation | `<nav aria-label="...">` | `<div class="nav">` |
    | Page heading structure | `h1`→`h2`→`h3` hierarchy observed | Multiple `h1` tags for styling purposes |

### 18.4. Keyboard & Focus Management Protocol
*   **Law**: Every operation possible with a mouse must also be completable via keyboard alone. This is a legal requirement under WCAG 2.1.1 (Keyboard).
*   **Implementation**:
    *   **Focus Trap**: When a modal, drawer, or popover is open, trap focus inside that component and close it with `Esc`.
    *   **Focus Indicator**: Using `outline: none` / `outline: 0` in CSS is **prohibited**. Focus rings must be visually clear and comply with WCAG 2.4.13 (Focus Appearance) — minimum 3:1 contrast ratio.
    *   **Skip Link**: Place `<a href="#main-content" class="sr-only focus:not-sr-only">Skip to main content</a>` on all pages.
    *   **Tab Order**: Using positive `tabindex` values (`tabindex="1"`, `tabindex="2"`, etc.) is prohibited. Control focus order through the natural DOM order.

### 18.5. Color Contrast & Visual Design Enforcement
*   **Contrast Ratio Requirements (WCAG 2.2 AA)**:
    | Element | Minimum Contrast Ratio |
    |:----|:-----------------|
    | Normal text (< 18px / < 14px Bold) | **4.5 : 1** |
    | Large text (≥ 18px or ≥ 14px Bold) | **3 : 1** |
    | UI components & graphical elements | **3 : 1** |
*   **Automated Measurement**: Integrate Storybook + `@storybook/addon-a11y` into component development to auto-measure contrast ratios when design tokens are configured.
*   **Color Blindness Support**: Using color alone to convey information is prohibited (WCAG 1.4.1). Error states must be expressed using a combination of icon + text + color.

### 18.6. ARIA Implementation Standards for Interactive Components
*   **ARIA Law (Top Priority)**: When an appropriate native HTML element exists, prefer **native HTML** over ARIA. "Implemented without ARIA" is the best implementation (per ARIA in HTML spec).
*   **Mandatory ARIA Implementation Patterns**:
    | Component | Required ARIA Attributes |
    |:------------|:-----------|
    | Custom dropdown | `role="combobox"`, `aria-expanded`, `aria-controls`, `aria-activedescendant` |
    | Tabs | `role="tablist"`, `role="tab"`, `aria-selected`, `role="tabpanel"`, `aria-labelledby` |
    | Modal | `role="dialog"`, `aria-modal="true"`, `aria-labelledby` |
    | Accordion | `aria-expanded`, `aria-controls`, `aria-labelledby` |
    | Notification / Alert | `role="alert"` (immediate), `role="status"` (non-urgent) |
    | Loading | `aria-busy="true"`, `aria-live="polite"` |
    | Hidden content | `aria-hidden="true"` to hide from assistive technology |
*   **Dynamic Content**: After SPA route transitions, announce the new page title to screen readers (via `aria-live` region or `document.title` update).

### 18.7. a11y Testing & Audit Protocol
*   **Screen Reader Real-Device Testing (≥ twice per year)**:
    | Platform | Screen Reader | Browser |
    |:--------------|:---------------|:--------|
    | macOS / iOS | VoiceOver | Safari |
    | Windows | NVDA / JAWS | Chrome / Firefox |
    | Android | TalkBack | Chrome |
*   **Manual Audit Protocol**: Once per quarter, complete critical paths (login, checkout, primary CRUD) using **keyboard only** and verify all flows complete successfully.
*   **Score Target (Lighthouse a11y)**: Maintain Lighthouse Accessibility score of **≥95** (a higher bar than the 90 mandated in §2.2).
*   **Regression Prevention**: When fixing an accessibility issue, add a corresponding test in the format `test('a11y regression: [ComponentName]')` to prevent regressions.

---

## Appendix A: Quick Reference Index

| Keyword | Section | Related Rules |
|---------|---------|---------------|
| Naming / kebab-case | §1.0 | `engineering/300_web_frontend.md`, `engineering/400_mobile_flutter.md` |
| DTO / Type Mapping | §13.1, §13.6 | `engineering/300_web_frontend.md` |
| Performance / LCP / CWV | §2.2 | `engineering/300_web_frontend.md`, `operations/400_site_reliability.md` |
| Connection Pool | §2.0 | `engineering/200_supabase_architecture.md`, `operations/400_site_reliability.md` |
| DevSecOps / Security | §3.0 – §3.9 | `security/000_security_privacy.md`, `security/100_data_governance.md` |
| Zero Trust 5 Principles / NIST SP 800-207 | §3.0 | `security/000_security_privacy.md` |
| Supply Chain Security | §3.5 | `security/000_security_privacy.md` |
| Secret Rotation | §3.6 | `security/000_security_privacy.md` |
| OAuth / OIDC / PKCE | §3.7 | `security/000_security_privacy.md` |
| AI/LLM Security / Prompt Injection | §3.8 | `ai/000_ai_engineering.md`, `security/000_security_privacy.md` |
| **Insider Threat Prevention** | **§3.9** | `security/000_security_privacy.md` |
| Technical Debt | §4.0 – §4.4 | `operations/600_cloud_finops.md` |
| AI-First / Code Review | §5.0 – §5.4 | `ai/000_ai_engineering.md` |
| Green Coding / SCI | §6.0 – §6.3 | `operations/600_cloud_finops.md` |
| Bug Risk Reduction Policy | §7.0 – §7.3 | `quality/000_qa_testing.md`, `operations/500_incident_response.md` |
| Testing Trophy / Test Strategy | §9.3 | `quality/000_qa_testing.md` |
| Mutation Testing / Stryker | §9.3 | `quality/000_qa_testing.md` |
| Property-Based Testing / Chaos / Litmus | §9.4 | `quality/000_qa_testing.md`, `operations/500_incident_response.md` |
| **Visual Regression Testing** | **§9.5** | `quality/000_qa_testing.md`, `engineering/300_web_frontend.md` |
| Git Workflow (pure) | `engineering/600_git_workflow.md` (all parts) | — |
| CI/Deploy Auxiliary | §10.1, §10.2, §10.4 – §10.6 | `operations/400_site_reliability.md` |
| Documentation Ops | §11.0 – §11.2 | `operations/000_internal_tools.md` |
| Feature Flags | §13.13 | `operations/400_site_reliability.md`, `quality/000_qa_testing.md` |
| Mutation Integrity | §13.5 | `engineering/300_web_frontend.md` |
| CQRS / Cache | §13.4 | `operations/400_site_reliability.md` |
| Authentication / Access Control | §13.10 | `security/000_security_privacy.md` |
| Migration Safety | §13.12 | `operations/400_site_reliability.md` |
| Idempotency / Idempotency Key | §13.15 | `engineering/300_web_frontend.md`, `operations/400_site_reliability.md` |
| WebAssembly / Edge Execution | §13.14 | `engineering/300_web_frontend.md`, `operations/400_site_reliability.md` |
| Platform Engineering / IDP | §14.1, §14.2 | `operations/400_site_reliability.md`, `operations/600_cloud_finops.md` |
| Observability / OpenTelemetry | §14.3 | `operations/400_site_reliability.md`, `ai/100_data_analytics.md` |
| Continuous Profiling / Pyroscope | §14.3 | `operations/400_site_reliability.md`, `ai/100_data_analytics.md` |
| **Error Budget / Alert Fatigue** | **§14.3** | `operations/400_site_reliability.md`, `operations/500_incident_response.md` |
| Event-Driven / EDA | §14.4 | `operations/400_site_reliability.md`, `quality/000_qa_testing.md` |
| Multi-Tenancy | §14.5 | `security/000_security_privacy.md`, `engineering/200_supabase_architecture.md` |
| Contract Testing | §14.6 | `quality/000_qa_testing.md` |
| Circuit Breaker / Retry | §15.1, §15.2 | `operations/400_site_reliability.md`, `operations/500_incident_response.md` |
| Bulkhead / Health Check | §15.3, §15.4 | `operations/400_site_reliability.md` |
| Graceful Shutdown | §15.5 | `operations/400_site_reliability.md` |
| Local Env Standardization / Dev Container | §16.1 | `operations/000_internal_tools.md` |
| Cognitive Load / Complexity Budget | §16.2 | `engineering/300_web_frontend.md` |
| Onboarding / ADR / Knowledge Ownership | §16.3 | `operations/000_internal_tools.md` |
| DORA / SPACE Metrics / DevOps Measurement | §16.4 | `operations/400_site_reliability.md`, `ai/100_data_analytics.md` |
| Schema Evolution / Expand-Contract | §17.1 | `engineering/200_supabase_architecture.md`, `operations/400_site_reliability.md` |
| Zero-Downtime Index Creation | §17.2 | `engineering/200_supabase_architecture.md` |
| Schema Drift Prevention | §17.3 | `operations/400_site_reliability.md`, `quality/000_qa_testing.md` |
| Large Table Changes / Backfill | §17.4 | `engineering/200_supabase_architecture.md` |
| Cross-Service Schema Coordination | §17.5 | `operations/400_site_reliability.md`, `quality/000_qa_testing.md` |
| Accessibility / WCAG 2.2 AA | §18.1 | `design/000_design_ux.md`, `quality/000_qa_testing.md` |
| axe-core CI / a11y Gate | §18.2 | `quality/000_qa_testing.md`, `engineering/300_web_frontend.md` |
| Semantic HTML / ARIA | §18.3, §18.6 | `engineering/300_web_frontend.md`, `design/000_design_ux.md` |
| Keyboard Navigation / Focus Management | §18.4 | `design/000_design_ux.md`, `engineering/300_web_frontend.md` |
| Color Contrast / Color Blindness | §18.5 | `design/000_design_ux.md` |
| Screen Reader Testing | §18.7 | `quality/000_qa_testing.md` |
| **API Design-First / OpenAPI** | **§19.1** | `engineering/300_web_frontend.md`, `quality/000_qa_testing.md` |
| **Data Quality Engineering / dbt** | **§19.2** | `operations/400_site_reliability.md`, `ai/100_data_analytics.md` |
| **FinOps Unit Economics** | **§19.3** | `operations/600_cloud_finops.md` |
| **Blameless Culture / Post-Incident Review** | **§19.4** | `operations/500_incident_response.md` |
| **Secrets Governance / CVE SLA** | **§19.5** | `security/000_security_privacy.md` |
| **VEX / CSPM / SBOM** | **§19.5** | `security/000_security_privacy.md` |
| **Automated Release / semantic-release** | **§19.6** | `operations/400_site_reliability.md` |
| **AI Agent Security Model** | **§20.1** | `ai/000_ai_engineering.md`, `security/000_security_privacy.md` |
| **MCP Security Standards** | **§20.2** | `ai/000_ai_engineering.md` |
| **Multi-Agent Authorization Model** | **§20.3** | `ai/000_ai_engineering.md`, `security/000_security_privacy.md` |
| **Agent Hallucination Risk Management** | **§20.4** | `ai/000_ai_engineering.md`, `quality/000_qa_testing.md` |
| **AI Agent Cost Guard** | **§20.5** | `operations/600_cloud_finops.md`, `ai/000_ai_engineering.md` |

---

## Part XIX: Advanced Engineering Practices

> [!NOTE]
> This part consolidates "must-have practices at Silicon Valley standards" that could not be covered in the preceding Parts. Added in Rev.5, reflecting the latest 2026/2027 standards.

### 19.1. API Design-First Protocol
*   **Context**: The "Code-First" approach—writing implementation first and documenting later—is the single largest source of bugs related to mismatches between frontend and backend contracts. We mandate "Design-First": define the API specification (contract) before writing any implementation.
*   **Mandatory flow for REST APIs**:
    1.  **Spec-First**: Define the OpenAPI 3.1 spec (`openapi.yaml`) first, obtain PR approval, then begin implementation.
    2.  **Contract-from-Spec**: Use code generation tools (`openapi-typescript` / `orval`) to auto-generate type definitions from the spec. Hand-written types that duplicate the spec are prohibited.
    3.  **Spec-Sync Gate**: Add a CI job that validates implementation matches the spec, physically blocking drift (`redocly lint` / `spectral`).
    ```yaml
    # OpenAPI 3.1 spec-first definition example
    openapi: '3.1.0'
    info:
      title: User API
      version: '1.0.0'
    paths:
      /users/{id}:
        get:
          operationId: getUserById
          summary: Get user by ID
          parameters:
            - name: id
              in: path
              required: true
              schema: { type: string, format: uuid }
          responses:
            '200':
              content:
                application/json:
                  schema: { $ref: '#/components/schemas/UserPublicDTO' }
    ```
*   **AsyncAPI (Async events, EDA)**:
    *   When adopting an Event-Driven Architecture (§14.4), define event schemas and channels in an AsyncAPI 3.0 spec first.
    *   Manage event schema changes via a Schema Registry with automated compatibility validation.
*   **API Versioning Strategy**:
    | Versioning Strategy | Use Case | Example |
    |:------------|:---------|:---|
    | URL Path | Small-scale APIs / startups | `/api/v1/users` |
    | Header | Large-scale / multiple clients | `Accept: application/vnd.api.v2+json` |
    | GraphQL Major Version | All tenants (using deprecation directives) | `@deprecated(reason: "Please use v2")` |
    *   **Deprecation Rule**: Once published, maintain the previous API version for at least 1 year. Announce deprecation via headers (`Deprecation`, `Sunset`).

### 19.2. Data Quality Engineering Protocol
*   **Context**: What determines AI/LLM inference quality is not "model capability" but "data quality." The principle of "Garbage in, Garbage out" remains unchanged in 2026. Define data pipeline quality standards at the engineering layer.
*   **The 5 Dimensions of Data Quality**:
    | Dimension | Definition | Measurement Example |
    |:-----|:-----|:--------|
    | **Completeness** | Null rate of required fields | `null_rate < 1%` |
    | **Accuracy** | Within expected value ranges | `price BETWEEN 0 AND 1000000` |
    | **Consistency** | Unique constraint violations, etc. | Duplicate emails ≤ 0 |
    | **Timeliness** | Data latency | Last updated ≤ 24h ago |
    | **Validity** | Format rule violations | `email LIKE '%@%.%'` |
*   **Implementation Mandates**:
    *   **dbt Test**: If the data transformation pipeline uses dbt (data build tool), applying the four essential dbt tests—`not_null`, `unique`, `accepted_values`, `relationships`—to all models is mandatory.
    *   **Great Expectations / Soda Core**: For pipelines not using dbt, integrate Great Expectations or Soda Core "data quality suites" into CI to build quality gates.
    *   **Alert Criteria**: Any data quality violation must trigger an alert and notify the data engineering team. Data must not flow to downstream services without passing quality checks.
    ```yaml
    # dbt schema.yml test definition example
    models:
      - name: users
        columns:
          - name: id
            tests: [not_null, unique]
          - name: email
            tests: [not_null, unique]
          - name: created_at
            tests: [not_null]
    ```

### 19.3. FinOps Unit Economics Protocol
*   **Context**: Beyond simply cutting cloud costs, practice FinOps Unit Economics to maximize "business value per cost unit."
*   **Mandating Unit Cost Measurement**:
    *   **Definition**: Unit Cost = Infrastructure cost per specific business event (e.g., cost per active user, cost per AI inference request).
    *   **KPI Examples**:
        | KPI | Formula | Target |
        |:----|:-------|:-------|
        | Cost per Active User (CPAU) | Monthly infra cost ÷ MAU | Monitor week-over-week trend |
        | Cost per API Call | API cost layer ÷ API calls issued | < $0.001 |
        | AI Cost per Inference | LLM token cost ÷ inference count | Periodic review |
*   **Cost Attribution**:
    *   **Mandatory Tagging**: All cloud resources must be tagged with `team`, `service`, `environment`, `cost-center` to enable cost attribution (see §14.2).
    *   **Showback vs Chargeback**: Begin with "Showback" (sharing cost reports with each team), then transition to "Chargeback" (actual billing) as maturity increases.
    *   **FinOps Lifecycle**: Run Inform (visibility) → Optimize (optimization) → Operate (operations) 3-phase cycles quarterly.
*   **Anti-Patterns (Prohibited)**:
    *   Looking only at total cost aggregate while ignoring unit cost.
    *   Like over-provisioning (§6.3), worsening unit cost is a FinOps disease.

### 19.4. Blameless Culture & Post-Incident Review Protocol
*   **Context**: Organizations that engage in "blame-finding" after incidents prioritize concealment over prevention, spreading "invisible failures." Blameless culture is the core of Google SRE's "safety," and psychological safety is a prerequisite for innovation.
*   **Post-Incident Review (PIR) Mandate**:
    *   All Severity 1 and 2 incidents must have a PIR document created **within 72 hours of recovery**.
    *   **Required PIR Information**:
        | Section | Content |
        |:----------|:----|
        | **Incident Summary** | Start time, recovery time, Severity, MTTR |
        | **Chronology** | Timeline from first detection to recovery |
        | **Root Cause Analysis** | Root cause identification using 5 Whys or Fishbone diagram |
        | **Action Items** | Prevention measures, owner, and deadline clearly stated |
        | **What Went Well** | Processes and detection mechanisms that functioned correctly |
*   **Definition of Blameless**:
    *   Instead of blaming the individual who executed the action, focus on **identifying and fixing the design-level vulnerability in the system or process that allowed the incident to occur**.
    *   Moral condemnation of the form "you should have been more careful" is prohibited. Shift the lens to: "What about the environment made it possible for anyone to make this same mistake?"
*   **Action Item Tracking Mandate**: PIR action items must be managed in an issue tracker (GitHub Issues / Jira), incorporated into the next sprint, and followed up reliably. Abandoned action items are "unresolved risks."

### 19.5. Secrets Governance & CVE SLA Protocol
*   **Context**: Secrets committed to a repository are persistent due to git history—"just deleting it is safe" is an absolute falsehood. Automating secret detection and formalizing CVE response SLAs are essential requirements of the modern security layer.
*   **Secrets Detection CI Mandate**:
    *   **Real-time Detection**: Integrate `gitleaks` or `trufflehog` into `pre-commit` hooks to detect secrets before commit.
    *   **CI Scan**: A CI job that scans the entire repository history (git log) on every PR is mandatory.
    *   **SAST Integration**: Perform periodic repository history scans with GitHub Advanced Security, GitGuardian, or equivalent tools.
    ```bash
    # gitleaks pre-commit hook configuration example
    # .pre-commit-config.yaml
    repos:
      - repo: https://github.com/gitleaks/gitleaks
        rev: v8.18.0
        hooks:
          - id: gitleaks
    ```
*   **CVE SLA (Vulnerability Response Deadlines)**:
    | Score | Response Deadline | Minimum Action |
    |:-------|:---------|:-------|
    | **Critical (9.0+)** | **Within 24 hours of discovery** | Disable affected functionality if patching is impossible |
    | **High (7.0–8.9)** | **Within 72 hours of discovery** | Workaround implementation required |
    | **Medium (4.0–6.9)** | **Within the next sprint** | Add to backlog |
    | **Low (0.1–3.9)** | **Within the quarter** | Address during Tech Radar review |
*   **Automated Scanning**:
    *   `npm audit --audit-level=high` must run in CI (see §4.1).
    *   Enable automated pull requests for vulnerabilities via GitHub Dependabot / Renovate Bot, with auto-assign to the appropriate review slot.
    *   Container Image vulnerability scanning: Integrate `trivy` / `grype` into CI to detect base image vulnerabilities on every build.
*   **VEX (Vulnerability Exploitability eXchange) Protocol**:
    *   **Background**: Many vulnerabilities recorded in an SBOM are actually **not Exploitable** because "the code path is not executed" or "that feature is not used." VEX is the standard specification (CISA / CycloneDX VEX) for attaching justification to an SBOM stating "this vulnerability cannot be exploited against our product."
    *   **Implementation Mandate**: In CI pipelines, generate an SBOM via `trivy sbom --format cyclonedx` and combine it with a `vex.json` (exemption justification document) to improve the accuracy of CI vulnerability gates.
    *   **Required VEX Statement Fields**: `vulnerability_id` (CVE ID), `status` (NOT_AFFECTED / FIXED / UNDER_INVESTIGATION), `justification` (COMPONENT_NOT_PRESENT, etc.), `impact_statement` (description of impact scope)
*   **CSPM (Cloud Security Posture Management) Mandate**:
    *   **Law**: Cloud infrastructure misconfigurations (public S3 buckets, overly permissive IAM policies, unencrypted EBS volumes, etc.) are the leading cause of breaches. Mandate static analysis scanning of IaC configuration values.
    *   **Mandatory Scanner Comparison**:
        | Tool | Target Cloud | Characteristics |
        |:-----|:-------------|:----------------|
        | **Checkov** | AWS/GCP/Azure/K8s | OSS static analysis supporting Terraform/CDK |
        | **tfsec** | AWS/GCP/Azure | Terraform-specific, fast, CI-friendly |
        | **KICS** (Checkmarx) | Multi-cloud | All IaC types (Terraform/CloudFormation/ARM) |
        | **AWS Security Hub** | AWS | Continuous inspection of runtime configuration |
    *   **CI Integration**: Run `checkov -d ./infra --framework terraform --output sarif` on every PR, and block CI on any High or above misconfigurations.
        ```bash
        # GitHub Actions CSPM integration example
        - name: Run Checkov IaC Scan
          uses: bridgecrewio/checkov-action@master
          with:
            directory: infra/
            framework: terraform
            soft_fail: false   # High must always block
            output_format: sarif
        ```

### 19.6. Automated Release Protocol
*   **Context**: Manually writing release notes, missing version bumps, and CHANGELOG drift are all "wastes of attention." Combine with Conventional Commits (§12.7) to automate the release process itself.
*   **semantic-release Adoption Mandate**:
    *   **Automated Actions**: Parse commit messages → Determine semver version → Append CHANGELOG → Issue Git Tag → Publish to npm/GitHub Packages.
    *   **Commit Type and Version Protocol**:
        | Commit Type | semver Impact | Example |
        |:-----------|:---------|:---|
        | `fix:` | **PATCH** (0.0.x) | `fix: resolve crash on login` |
        | `feat:` | **MINOR** (0.x.0) | `feat: add store feature` |
        | `feat!:` / `BREAKING CHANGE:` | **MAJOR** (x.0.0) | `feat!: change API response format` |
    ```json
    // package.json: semantic-release configuration example
    {
      "release": {
        "branches": ["main"],
        "plugins": [
          "@semantic-release/commit-analyzer",
          "@semantic-release/release-notes-generator",
          "@semantic-release/changelog",
          "@semantic-release/github"
        ]
      }
    }
    ```
*   **Anti-Patterns to Avoid in Automated Releases**:
    *   **Manual bump prohibited**: Manually updating `version` in `package.json` is prohibited (contradicts automation).
    *   **Commit message bypass prohibited**: Commits like `chore: bump version` for manual version management are prohibited.
    *   **Direct push to release branch prohibited**: Direct commits to `main` are physically blocked by Husky Guard (§12.10).

---

## Part XX: AI Agent & Orchestration Safety

> [!CAUTION]
> This part covers the highest-risk emerging domain in 2026/2027. AI agents "autonomously write code, execute tools, and call external APIs," generating new attack surfaces that existing security models cannot address. **Compliance with this part is mandatory for all systems incorporating agents.**

### 20.1. AI Agent Security Model
*   **Law**: When deploying AI agents (LangGraph / AutoGen / CrewAI / OpenAI Agents SDK, etc.) to production environments, all of the following "4 Agent Security Axioms" must be implemented.
*   **4 Agent Security Axioms (Mandatory)**:
    1.  **Sandboxed Execution**: Any code or shell commands executed by an agent must run **only inside a sandbox with no internet access and restricted filesystem** (Docker gVisor / Firecracker MicroVM / E2B, etc.). Direct execution in the host environment is **absolutely prohibited**.
    2.  **Human-in-the-Loop Gate**: When an agent attempts to perform a "destructive operation (DELETE/WRITE/PUSH)," it must always wait for a "confirmation step" requiring human approval before proceeding. Bypassing this gate programmatically is prohibited (see §3.8).
    3.  **Blast Radius Minimization**: Tool permissions granted to an agent must be limited to "the minimum scope required for this task only." Granting access to all endpoints or write permissions on all tables constitutes "permission explosion" and is prohibited.
    4.  **Audit Trail Obligation**: All "tool calls, decisions, and outputs" performed by the agent must be recorded as structured logs and retained for a minimum of 90 days. Designs that do not allow retrospective tracing of "why a decision was made" are prohibited.
```typescript
// Minimum structure for agent execution logs
type AgentAuditLog = {
  session_id: string;
  agent_id: string;
  step_index: number;
  action_type: "tool_call" | "llm_inference" | "human_approval_request";
  tool_name?: string;
  tool_input?: Record<string, unknown>;
  tool_output?: unknown;
  approved_by?: string;
  timestamp: string;
  latency_ms: number;
};
```

### 20.2. MCP (Model Context Protocol) Security Standards
*   **Context**: MCP (proposed by Anthropic) rapidly proliferated in 2025-2026 as the standard protocol between AI agents and tools/data sources. MCP servers are "API servers that expose tools to AI" — **without proper authentication, they become backdoors to production systems**.
*   **MCP Server Design Mandates**:
    *   **Authentication Required**: Access to MCP servers requires OAuth 2.0 / API Key authentication; anonymous access is **prohibited**.
    *   **Tool Permission Scoping**: Tools exposed via MCP must be whitelisted, with **exposed scope explicitly declared in `capabilities`**. Operations outside the declaration must be rejected server-side.
    *   **Input Validation**: Parameters passed through MCP **must undergo type validation (Zod schema, etc.) on the server side**. Input from agents must be treated with the same trust level as user input.
    *   **Rate Limit**: MCP servers must apply per-agent-session Rate Limits to prevent resource exhaustion (cost explosion) from runaway agents.
    ```json
    {
      "protocol": "mcp",
      "capabilities": {
        "tools": [
          { "name": "read_file", "scope": "read" },
          { "name": "write_file", "scope": "write", "requires_approval": true }
        ],
        "excluded": ["delete_file", "execute_shell"]
      }
    }
    ```

### 20.3. Multi-Agent Authorization Model
*   **Context**: In "multi-agent systems" where multiple AI agents collaborate, inter-agent trust relationships and permission delegation become new attack surfaces. An authorization model to control chains like "Agent A instructs Agent B, and B overwrites the production DB" is indispensable.
*   **Inter-Agent Trust Model**:
    | Trust Level | Definition | Permission Scope |
    |:------------|:-----------|:-----------------|
    | **Orchestrator** | Root agent receiving direct instructions from users | Task decomposition and Sub-Agent instructions (no tool execution) |
    | **Sub-Agent** | Agent delegated by the Orchestrator | Tool execution within designated scope only |
    | **Tool Server** | API server called by agents | Operations on whitelist only |
*   **Implementation Mandates**:
    *   **Prohibition of Permission Inheritance**: Sub-Agents **cannot hold greater permissions than** the Orchestrator. Physically prevent permissions from expanding through delegation (preventing privilege escalation attacks).
    *   **Agent ID Propagation**: For all inter-agent calls, propagate `X-Agent-Session-Id` and `X-Agent-Caller-Id` headers to enable tracing of the caller in audit logs.
    *   **Confused Deputy Attack Defense**: Sub-Agents "trust" instructions from the Orchestrator, but must consider that the Orchestrator itself may have been injected. Sub-Agent-side Input Validation (rejecting unauthorized operations) must also be implemented.

### 20.4. Agent Hallucination Risk Management
*   **Context**: AI agents acting autonomously that "call non-existent APIs," "reference incorrect path names," or "make decisions based on inaccurate calculations" cause **side effects on production systems** (incorrect data writes, unintended charges, etc.).
*   **Mandatory Controls**:
    1.  **Structured Output Enforcement**: Agent tool selection and decisions must use Structured Output with JSON schema constraints (OpenAI Structured Outputs / Anthropic Tool Use), not Free-Text. Outputs outside the schema must be rejected server-side.
    2.  **Verification Step**: Before critical decisions ("delete this record," etc.), always insert a Reflection step that prompts the agent to re-examine "Is it truly OK to perform this operation? What is the justification?"
    3.  **Tool Call Dry Run**: Tool calls involving writes must first simulate the impact scope in "Dry Run mode" and output to logs before executing via Human Approval.
    4.  **Confidence Threshold**: If the agent decision confidence score falls below a threshold (e.g., `confidence < 0.8`), halt autonomous execution and escalate to the user. Automatic execution at low confidence is prohibited.
    ```typescript
    async function safeAgentAction(action: AgentAction): Promise<void> {
      const verification = await agent.reflect(
        `About to execute: ${action.type} on ${action.target}. Rationale: ${action.rationale}. Is this correct?`
      );
      if (verification.confidence < 0.8 || verification.hasRisk) {
        await requestHumanApproval(action, verification.concerns);
        return;
      }
      await executeWithAuditLog(action);
    }
    ```

### 20.5. AI Agent Cost Guard Protocol
*   **Context**: "Infinite loops, recursive self-invocation, and unnecessarily large contexts" by autonomous agents cause LLM token costs to grow exponentially, triggering "Cost Explosion" that exceeds monthly costs within days. From a FinOps (§19.3) perspective, cost control of agent execution is mandatory.
*   **4 Guardrails for Cost Explosion Prevention**:
    1.  **Max Steps Limit**: All agent reentrant loops must have `max_iterations` configured. Default ceiling: **50 steps**. When exceeded, return an error and escalate to a human.
    2.  **Token Budget Ceiling**: Set an upper limit on cumulative input + output tokens per agent session (e.g., **200,000 tokens/session**). Sessions that exceed this limit must be automatically terminated.
    3.  **Cost-per-Session Alert**: Fire a real-time alert when the estimated cost for a single agent session exceeds a threshold (e.g., **$1.00/session**).
    4.  **Orphan Agent Cleanup**: Agent sessions that have timed out (default: **10 minutes** of inactivity) must be automatically terminated. Orphaned agents generate both cost and integrity risks.
    ```typescript
    const agentRunner = new AgentRunner({
      maxIterations: 50,
      maxTokens: 200_000,
      timeoutMs: 10 * 60 * 1000,
      onCostAlert: async (estimatedCost) => {
        if (estimatedCost > 1.0) {
          await notifySlack(`Agent cost alert: $${estimatedCost.toFixed(2)}`);
          throw new AgentCostExceedError(estimatedCost);
        }
      },
    });
    ```
*   **Agent Cost Measurement Mandate**: For all agent executions, record `input_tokens`, `output_tokens`, `tool_calls_count`, and `estimated_cost_usd` in audit logs and aggregate in the FinOps dashboard (§19.3).

---


## Part XXI: Privacy Engineering

> [!CAUTION]
> Privacy is not only a compliance-department concern; it is an engineering design responsibility. Determine GDPR, EU AI Act, CCPA, and national data-protection applicability separately from jurisdiction, entity, processing purpose, data subjects, product scope, and effective date. Use Privacy by Design as a baseline and embed controls proportionate to applicable law and actual privacy risk from the design phase.

### 21.1. Privacy by Design (PbD Principles)

> [!IMPORTANT]
> Dr. Ann Cavoukian's "7 Foundational Principles of Privacy by Design" are mandated as a checklist for all system design. Privacy is not a post-hoc concern but a fundamental architectural design requirement.

*   **PbD 7 Principles (All items must be verified at the design phase)**:
    | Principle | Design Checklist |
    |:---------|:----------------|
    | **1. Proactive, not Reactive** | Identify privacy risks in advance and prevent their occurrence |
    | **2. Privacy as the Default** | Does the safest default (minimum collection) apply without any configuration? |
    | **3. Privacy Embedded in Design** | Is privacy protection part of the architecture, not a bolt-on feature? |
    | **4. Full Functionality (Positive-Sum)** | Security and privacy are not a trade-off — achieve both |
    | **5. End-to-End Security** | Is data protected throughout the entire lifecycle, from collection to deletion? |
    | **6. Visibility & Transparency** | Can users view, correct, and delete their own data? |
    | **7. Respect for User Privacy** | Is the design user-centered, enabling data sovereignty? |
*   **DPIA (Data Protection Impact Assessment) Mandate**:
    *   **Scope**: For any feature addition involving high-risk processing (large-scale personal data, biometrics, location data, children's services, profiling), a **DPIA** must be conducted.
    *   **Timing**: Before implementation begins (Blueprint creation phase). After-the-fact DPIAs are meaningless.
    *   **Required Content**: Data flow diagrams, risk identification, mitigation measures, residual risk assessment, DPO (Data Protection Officer) approval.

### 21.2. Data Minimization Protocol

*   **Law**: Collected data must be limited to "only what is absolutely necessary for this service right now." Collection for "potential future use" risks violating data protection laws.
*   **Implementation Checklist**:
    1.  **Purpose Limitation**: Explicitly state collection purposes and prohibit use beyond those purposes. Always document the collection purpose in table definition comments.
    2.  **Storage Limitation**: Set retention periods for all PII data. Data exceeding its retention period must be automatically anonymized or deleted.
    3.  **Field-Level Sensitivity Classification**: Assign a sensitivity level (`PUBLIC` / `INTERNAL` / `CONFIDENTIAL` / `RESTRICTED`) to every column in every table.
        ```sql
        -- Mandatory column comments with sensitivity level (PostgreSQL)
        COMMENT ON COLUMN users.email IS 'CONFIDENTIAL: PII. Subject to GDPR data subject rights. Retention: 3 years post-account closure';
        COMMENT ON COLUMN users.username IS 'INTERNAL: Display name. May become PUBLIC depending on user settings';
        ```
    4.  **PII Catalog Obligation**: Maintain a "PII Catalog" at `docs/pii-catalog.md` recording the location, type, retention period, and encryption status of all PII fields.

### 21.3. Consent Management Protocol

*   **Context**: From 2026 onwards, "implied consent," "pre-checked opt-ins," and "difficult-to-withdraw refusal flows" are treated as violations under GDPR and CCPA.
*   **4 Requirements for Valid Consent**:
    1.  **Freely Given**: Service terms and consent must not be bundled. Consent for required features and analytics collection must be separate.
    2.  **Specific**: Blanket consent like "agree to all" is invalid. Obtain individual consent for each purpose.
    3.  **Informed**: Explain what is being collected and who it is shared with in plain language (no legal jargon).
    4.  **Unambiguous**: Checkboxes must be unchecked by default. Treating scrolling or page visits as "consent" is prohibited.
*   **Consent Withdrawal Mandate**:
    *   Withdrawing consent must be as easy as giving it (GDPR Article 7(3)).
    *   Process deletion or opt-out of related data within 30 days of withdrawal.
*   **Consent Management Platform (CMP) Integration**:
    *   Use an IAB TCF 2.2-compliant CMP (OneTrust / Cookiebot / Usercentrics, etc.) for cookie consent.
    *   Block third-party scripts (Google Analytics, Meta Pixel, etc.) from executing until the CMP banner is displayed and consent is obtained.

### 21.4. Right to be Forgotten Implementation

*   **Law**: Under GDPR Article 17 (Right to Erasure), users' data deletion requests must be technically implementable. "We can't delete it for technical reasons" is not legally acceptable.
*   **Implementation Mandates**:
    1.  **Hard Delete vs Soft Delete**: "Soft Delete" (logical deletion) of records containing PII is insufficient because physical data remains. Implement **Anonymization** or **Physical Deletion**.
    2.  **Cascading Deletion Protocol**: Automate cascading deletion of PII in all child records when a parent record is deleted (`ON DELETE CASCADE` or Application-side Cascade).
    3.  **Deletion Audit Trail**: Maintain audit logs of "who, when, why a deletion request was made, and what data was deleted" (paradoxically, deletion logs are needed as proof of deletion).
    4.  **72-Hour SLA**: Target completion of deletion from primary systems within **72 hours** of receiving a request. Notify third-party data recipients of the deletion within 30 days.
    ```typescript
    // Anonymization pattern (fallback when physical deletion is not possible)
    async function anonymizeUser(userId: string): Promise<void> {
      await db.users.update(userId, {
        email:        `deleted-${userId}@anonymous.invalid`,
        display_name: `Deleted User`,
        phone:        null,
        avatar_url:   null,
        deleted_at:   new Date().toISOString(),
      });
      await anonymizeCascade(userId);
    }
    ```

### 21.5. Cross-Border Data Transfer Protocol

*   **Law**: Transferring EU personal data outside the European Economic Area (EEA) without appropriate safeguards (Standard Contractual Clauses / Binding Corporate Rules / Adequacy Decision) is prohibited.
*   **Implementation Mandates**:
    *   **Data Residency Recording**: Record the region where data is actually stored and processed for all PII data in the PII Catalog (§21.2).
    *   **Adequacy Country List**: Transferring EU PII to countries not granted adequacy decisions by the EU (excluding Japan, UK, Switzerland, etc.) without SCCs is prohibited.
    *   **SCC Automation**: When using SCCs, confirm that the latest version (2021 SCCs) is in place upon each vendor contract renewal.
    *   **Transfer Impact Assessment (TIA)**: Where local laws in a third country provide lower protection than EU standards (e.g., FISA 702 in the US), conduct a TIA and implement supplementary safeguards.

### 21.6. WebAuthn / Passkey Engineering Standard

*   **Context**: In 2026, passwords are an "obsolete security mechanism." As a phishing-resistant authentication method, FIDO2/WebAuthn-based Passkeys have achieved full platform support from Apple, Google, and Microsoft, becoming a practical standard.
*   **Passkey Adoption Mandate**:
    *   **New Systems**: Design new authentication systems with Passkey as the primary authentication method. Password authentication should only be available as a legacy fallback from `/settings/security`.
    *   **Existing Systems**: Add a Passkey registration option to existing password-based systems to facilitate migration.
*   **Implementation Standards**:
    ```typescript
    // WebAuthn Registration flow
    import { generateRegistrationOptions } from '@simplewebauthn/server';

    const options = await generateRegistrationOptions({
      rpName: 'Your App Name',
      rpID: process.env.WEBAUTHN_RP_ID!,
      userID: userId,
      userName: userEmail,
      attestationType: 'none',                // Privacy: do not transmit device info
      authenticatorSelection: {
        residentKey: 'required',              // Discoverable Credential required
        userVerification: 'required',         // Biometric/PIN required
      },
    });
    ```
    *   **Roaming vs Platform Authenticator**: Clearly distinguish between "Security Keys (Roaming: YubiKey, etc.)" and "This Device (Platform: Face ID/Windows Hello, etc.)" in the UI, and design to allow users to register multiple Authenticators.
    *   **Recovery Path Mandatory**: Always implement an account recovery flow for lost Passkeys (email verification + OTP, etc.). "Cannot log in without a Passkey" is an unacceptable design.
    *   **Conditional UI**: Set `autocomplete="username webauthn"` on login forms to enable the browser's Passkey auto-suggest UI.
    *   **Cross-Device Authentication**: Support QR-code-based hybrid flows (CTAP 2.2) so users can authenticate with a Passkey on a nearby device when the primary device is unavailable.

### 21.7. EU AI Act Compliance Protocol

*   **Context**: The EU AI Act (effective August 2024, phased application) classifies AI systems by risk level and imposes strict requirements on high-risk AI. From 2026, compliance is mandatory for AI systems targeting the EU market.
*   **Risk Classification (All AI systems must be classified)**:
    | Risk Level | Definition | Regulatory Requirement |
    |:----------|:----------|:----------------------|
    | **Prohibited (Unacceptable)** | Subliminal manipulation, social scoring, real-time biometrics in public spaces, etc. | **Prohibited** |
    | **High-Risk** | Hiring, credit scoring, medical diagnosis, critical infrastructure management, etc. | Strict transparency, human oversight, registration obligation |
    | **Limited Risk** | Chatbots, deepfake generation, etc. | Transparency disclosure (notify that it is AI) |
    | **Minimal Risk** | Spam filters, recommendation systems, etc. | Voluntary codes of conduct only |
*   **Mandatory Requirements for High-Risk AI**:
    1.  **Technical Documentation**: Document AI system design, training data, and test results, and maintain them in a state ready for submission to regulators.
    2.  **Human Oversight Mandate**: Insert a mandatory human approval step for all final decisions by high-risk AI. Fully automated decision-making is prohibited.
    3.  **Accuracy & Robustness Testing**: Mandate continuous performance testing and bias verification for socially vulnerable groups.
    4.  **EU AI Act Registration**: Providers of high-risk AI are obligated to register with the EU AI Act Database (from August 2026 onwards).
*   **Disclosure Obligation for Limited-Risk AI**:
    *   Chatbots and voice assistants must clearly inform users at the start of an interaction that they are talking to an AI.
    *   AI-generated content (text, images, audio) must include metadata or watermarks (C2PA standard recommended).

---

## Part XXII: Advanced Runtime Security Hardening

> [!CAUTION]
> Build-time security checks are merely the "starting point." The top threats in 2026 (zero-days, container escapes, supply chain poisoning) occur at runtime. This Part defines the obligation to build a runtime defense layer to protect "systems as they run."

### 22.1. SLSA Build L3 Supply Chain Hardening

*   **Law**: Extend the SLSA Build L2 baseline in §3.5 (Software Supply Chain Security) and target **SLSA Build L3** for high-assurance production artifacts. On the Source track, enforce organizational controls mechanically and target Source L4, including two-party review, for critical areas. Do not emit a nonexistent `SLSA_SOURCE_LEVEL_4` in a Source VSA's `verifiedLevels`; verify the corresponding numeric level plus `SLSA_SOURCE_TWO_PARTY_REVIEWED`.
*   **Additional Requirements for SLSA Build L3**:
    *   **Hardened Build Platform**: Use a build platform assessed against Build L3 requirements. Do not treat a product name such as GitHub Actions or Google Cloud Build as evidence by itself; verify builder identity, isolation, ephemerality, and the provenance issuance boundary.
    *   **Non-forgeable Provenance**: Build provenance must be **digitally signed** with `sigstore/cosign`, and signature verification must be required before deployment.
    *   **Isolated Build**: Run builds in isolated ephemeral environments. Apply hermetic or no-network builds as additional hardening separate from the SLSA level label, and require allowlists and evidence for unavoidable dependency retrieval.
    ```yaml
    # GitHub Actions: Example of signing artifacts with Cosign
    - name: Sign container image with Cosign
      uses: sigstore/cosign-installer@v3
    - run: |
        cosign sign --yes \
          --key env://COSIGN_PRIVATE_KEY \
          ${{ env.IMAGE_NAME }}@${{ steps.build.outputs.digest }}
      env:
        COSIGN_PRIVATE_KEY: ${{ secrets.COSIGN_PRIVATE_KEY }}
    - name: Verify image signature
      run: |
        cosign verify \
          --key env://COSIGN_PUBLIC_KEY \
          ${{ env.IMAGE_NAME }}
    ```

### 22.2. eBPF-based Runtime Security

*   **Context**: eBPF (extended Berkeley Packet Filter) is a strong implementation option for observing and controlling kernel-level events in runtime security. Do not treat it as the only standard for every workload or operating system. Select eBPF, OS-native telemetry, workload instrumentation, or an equivalent control from the threat model, kernel and platform support, required visibility, operational capability, and measured overhead.
*   **Recommended Tool Stack**:
    | Tool | Category | Key Function | Adoption Criteria |
    |:----|:--------|:------------|:----------------|
    | **Tetragon** (Cilium) | eBPF Runtime Security | Monitor process execution, network connections, and file operations; enforce policies | Kubernetes environments, OSS |
    | **Falco** (CNCF) | Cloud-Native Runtime Security | Detect suspicious container behavior (privilege escalation, shell spawning, etc.) | Multi-cloud, comprehensive ruleset |
    | **Cilium** | eBPF Network Policy | L7 visibility, mTLS enforcement, network policy | Service mesh alternative |
*   **Required Monitoring Rules (Falco)**:
    ```yaml
    - rule: Terminal shell in container
      desc: A shell was spawned inside a container
      condition: >
        spawned_process and container
        and shell_procs
        and not (container.image.repository = "trusted/debug-image")
      output: >
        Shell spawned in container
        (user=%user.name container=%container.name image=%container.image.repository
         cmd=%proc.cmdline)
      priority: WARNING
    ```
*   **Alert Integration**: Route runtime-security signals without undue delay into the adopted alert, on-call, and incident-management path. Derive severity and response SLO from asset criticality, exploitability, exposure, and impact. Slack and PagerDuty are reference implementations; do not promote every signal to a fixed P1.

### 22.3. Container Security Hardening Protocol

*   **Minimal Runtime Image Contract**: Pin a supported minimal production runtime image by digest and require non-root execution, a read-only filesystem, vulnerability scanning, an SBOM, and provenance. Remove shells, package managers, compilers, and debugging utilities when the runtime does not need them. Google Distroless and Chainguard Images are reference implementations. If operational or compatibility needs require additional utilities, record the need, added attack surface, patch path, and alternative debugging path in an ADR; do not make one vendor image the only conformance path.
    ```dockerfile
    # Reference using Node.js Active LTS and matching Debian generations.
    # In production, pin both FROM lines to registry-resolved sha256 digests.
    FROM node:24-trixie-slim AS builder
    WORKDIR /app
    COPY package*.json ./
    RUN npm ci
    COPY . .
    RUN npm run build && npm prune --omit=dev

    FROM gcr.io/distroless/nodejs24-debian13:nonroot AS runtime
    ENV NODE_ENV=production
    WORKDIR /app
    COPY --from=builder /app/dist ./dist
    COPY --from=builder /app/node_modules ./node_modules
    CMD ["dist/index.js"]
    ```
*   **Read-Only Root Filesystem**: Set `readOnlyRootFilesystem: true` in Kubernetes PodSpec to prevent filesystem manipulation after a container escape. Limit writable areas to the minimum necessary `emptyDir` or `tmpfs` mounts.
*   **Apply Pod Security Standards: Restricted Profile to all production Pods**:
    ```yaml
    spec:
      securityContext:
        runAsNonRoot: true
        runAsUser: 65534
        seccompProfile:
          type: RuntimeDefault
        fsGroup: 65534
      containers:
        - securityContext:
            allowPrivilegeEscalation: false
            readOnlyRootFilesystem: true
            capabilities:
              drop: ["ALL"]
    ```

### 22.4. mTLS and Service Mesh Mandate

*   **Context**: Communicating between microservices over plaintext (HTTP) is a Zero Trust violation of "trusting the internal network."
*   **mTLS Mandates**:
    *   **Inter-service Communication**: All microservice-to-microservice communication must be encrypted with mTLS. Using a service mesh (Istio / Linkerd / Cilium, etc.) to automatically apply mTLS via Sidecar/eBPF is recommended.
    *   **Certificate Management**: Service certificates must be automatically issued and renewed by cert-manager (Kubernetes), eliminating manual renewal. Default certificate lifetime: **90 days**.
    *   **SPIFFE/SPIRE**: Adopt SPIFFE (Secure Production Identity Framework for Everyone) for certificate identities, tying service identities to Kubernetes Service Accounts.
*   **TLS Configuration Standards**:
    | Setting | Requirement |
    |:-------|:-----------|
    | TLS Version | TLS 1.3 only. TLS 1.2 and below are prohibited |
    | Cipher Suites | Only `TLS_AES_128_GCM_SHA256`, `TLS_AES_256_GCM_SHA384`, `TLS_CHACHA20_POLY1305_SHA256` are permitted |
    | Certificate Lifetime | 90 days maximum (Leaf certificates) |
    | HSTS | `max-age=31536000; includeSubDomains; preload` |
    | HPKP | Deprecated (prohibited). Use CT (Certificate Transparency) log monitoring instead |

### 22.5. Secrets Detection & Rotation Automation

*   **Law**: Building on §3.6 and §19.5, automate issuance, distribution, verification, revocation, and audit where the issuer or provider supports a safe API and overlap. For vendor credentials that do not safely support full automation, use a managed workflow with an owner, expiring reminders, a two-party procedure, preflight checks, rollback, and execution evidence. Automation percentage alone is not proof of safety.
*   **Automated Rotation Implementation (Vault Dynamic Secrets)**:
    ```bash
    # HashiCorp Vault: PostgreSQL dynamic secrets (auto-generates short-lived credentials on every access)
    vault write database/roles/api-readonly \
        db_name=production-db \
        creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";" \
        default_ttl="1h" \
        max_ttl="24h"
    ```
*   **Scheduled Workflow Example (GitHub Actions)**:
    ```yaml
    on:
      schedule:
        - cron: '0 2 * * 0'  # Every Sunday at 2 AM
    jobs:
      rotate-secrets:
        runs-on: ubuntu-latest
        steps:
          - name: Rotate API Key
            run: |
              NEW_KEY=$(vault read -field=api_key secret/external/service)
              gh secret set EXTERNAL_API_KEY --body "$NEW_KEY"
    ```

### 22.6. Zero-Trust Network Access (ZTNA) Implementation

*   **Context**: Traditional VPNs (perimeter-based security) operate on the premise that "the internal network is trustworthy," which fundamentally contradicts Zero Trust principles. ZTNA (Zero-Trust Network Access) is the 2026 standard for remote access, replacing VPNs.
*   **ZTNA Implementation Requirements**:
    *   **Device Trust**: Require device certificates verifying the health of accessing devices (patch status, EDR deployment, disk encryption). Tool examples: Cloudflare Access / Tailscale / BeyondCorp Enterprise.
    *   **Continuous Authorization**: Even after initial authentication, continuously evaluate device status and user behavior during the session, and require re-authentication when the risk score exceeds a threshold.
    *   **Micro-Segmentation**: Ensure "service accounts with production DB access" cannot reach any other service at the network level. Implement L4/L7 Micro-Segmentation using Kubernetes Network Policy or Cilium.

### 22.7. Memory Safety & Secure Coding Standards

*   **Context**: The US CISA/NSA "Memory Safety Roadmap" (2023-2026) states that BufferOverflows and Use-After-Free from memory-unsafe languages like C/C++ account for up to 70% of system software vulnerabilities.
*   **Language Selection Guidelines**:
    *   **New System Components (Security-Critical Parts)**: Prioritize memory-safe languages such as Rust / Go / Swift / Kotlin.
    *   **WASM Modules (see §13.14)**: Implement CPU-intensive processing in Rust and compile to WASM to bridge JavaScript with memory-safe code.
    *   **When C/C++ Is Unavoidable**: Incorporate Address Sanitizer (ASAN) / Undefined Behavior Sanitizer (UBSan) / Memory Sanitizer (MSan) into all CI runs as mandatory.
*   **Node.js / TypeScript Specific Secure Coding**:
    *   **Prototype Pollution Prevention**: Use `Object.create(null)` or `Object.freeze()` to prevent prototype pollution attacks.
    *   **ReDoS (Regex DoS) Prevention**: Verify user-input-containing regular expressions in CI using `safe-regex` or `vuln-regex-detector`.
    *   **Path Traversal Prevention**: Always sanitize file paths containing user input using `path.resolve()` + base directory validation.
        ```typescript
        // Path Traversal prevention pattern
        import path from 'path';
        const BASE_DIR = path.resolve('/app/uploads');
        function safeReadFile(userInput: string): string {
          const resolved = path.resolve(BASE_DIR, userInput);
          if (!resolved.startsWith(BASE_DIR + path.sep)) {
            throw new Error('Path traversal detected');
          }
          return fs.readFileSync(resolved, 'utf-8');
        }
        ```

### 22.8. Security Champions Program

*   **Context**: Security is not solely the responsibility of the security team. Placing "Security Champions" in each development team and embedding security into the daily engineering process is the 2026 standard organizational model.
*   **Security Champion Responsibilities**:
    | Responsibility | Frequency | Content |
    |:-------------|:---------|:-------|
    | **Threat Modeling Participation** | Per new feature | Proactively identify risks using STRIDE/LINDDUN methodology |
    | **Security Reviews** | Per PR | Specialized security perspective review (§12.8) |
    | **Vulnerability Triage** | Weekly | Prioritize High/Critical and coordinate remediation |
    | **Team Education** | Monthly | Share latest threats and best practices |
*   **Mandatory Threat Modeling (STRIDE)**:
    *   **Scope**: New features involving authentication, authorization, payments, or personal data processing.
    *   **STRIDE Analysis**:
        | Category | Threat Type | Verification |
        |:--------|:-----------|:------------|
        | **S**poofing | Impersonation | Is JWT issuer verification complete? |
        | **T**ampering | Alteration | Are RLS and CSRF protections complete? |
        | **R**epudiation | Denial | Are audit logs tamper-proof? |
        | **I**nformation Disclosure | Data Leak | Is PII absent from all API responses? |
        | **D**enial of Service | Service Disruption | Are Rate Limits and Circuit Breakers functional? |
        | **E**levation of Privilege | Privilege Escalation | Is the RBAC role definition least-privilege? |
    *   Record threat modeling results in ADRs (§16.3) and track all identified risks in Issues.

---
