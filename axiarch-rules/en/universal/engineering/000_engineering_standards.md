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
> Language scope: TypeScript, JavaScript, and web-specific tool names and examples in this standard apply only to their ecosystems. `axiarch-rules/{lang}/universal/engineering/320_programming_language_governance.md` is the source of truth for cross-language selection, naming, toolchains, quality gates, ownership, and retirement; do not impose tool names unchanged on another ecosystem.
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
| X | CI/Deploy & Auxiliary Standards (Note: pure git moved to `axiarch-rules/{lang}/universal/engineering/600_git_workflow.md`) | §10.1, §10.2, §10.4 – §10.6 | 5 |
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
    *   **Case-Only Distinction Ban (Supplement)**: The prohibition above exists because a case-insensitive filesystem (macOS/Windows defaults) and a case-sensitive CI (Linux) disagree: renames go undetected, duplicate files appear, and imports fail on only one side. Perform a case-only rename as a two-step `git mv` through a temporary name, and fix one naming convention per repository.
    *   **Symbols**: Component, class, function, package, and other symbol names follow language-native conventions. See `axiarch-rules/{lang}/universal/engineering/320_programming_language_governance.md` for the cross-language source of truth.
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
*   **Security Wrapper Name Collision Ban**: Once a safe wrapper (e.g. `safeJsonParse`) is introduced, a non-safe function with the same or a confusingly similar name MUST NOT remain in the codebase. Developers assume they are "using the safe one" while the unsafe one keeps being called. Delete the unsafe version and consolidate through a re-export of the safe one.
*   **Principle over Enumeration**: Deciding "is this item in scope" (filtering, classification, extracting translation targets, etc.) MUST use a principle derived from the item's nature (e.g. a string containing no source-locale characters is not prose) as the primary test, not an enumeration of key or type names (allowlist/denylist). Keep the enumeration only as a second net for exceptions the principle cannot catch (SHOULD).
    *   **Rationale**: Enumeration alone silently misses the moment the domain grows (a new key, a new type). In practice, translation targets selected by an enumerated key list silently skipped technical-value keys added later.
    *   **Verification**: Add one new value absent from the enumeration and fix in a test that the principle-based check alone handles it correctly.

### 1.1. Omnichannel & Headless First Protocol
*   **Web is just ONE Client**: The web application is only one of many clients. Design for native apps, external media, IoT, and AI agents.
*   **API Mandate**: All features and data must be provided via reusable APIs (Headless Architecture).
*   **Prohibition**: Enclosing business logic within React components or designing data dependent on HTML structure is strictly prohibited.

### 1.2. Realism First Protocol (Anti-Haribote)
*   **Definition**: A feature with UI but without complete data persistence and re-hydration is classified as "Deception" and is not considered complete.
*   **Mandate**: Completion requires verifying the full **UI → Action → DB → Action → UI** round-trip.
*   **Physical Verification**: You must physically verify that values are written to the DB.
*   **Link-Target Reality**: Audits MUST include a mechanical check that every internal path or API constant the UI uses via `href`, `fetch`, or action references has an existing implementation file. Registering a constant is not evidence of implementation. When the UI asserts that a feature exists (button, link, help text), it MUST NOT be shown while the implementation is absent. Anti-Haribote covers not only "not persisted" but also "no link target" and "no route". Detect stub exports that only return a fixed error yet are called from the UI with the same check (SHOULD).
*   **Post-Action-Only State Smell**: State that "appears right after the action and vanishes on reload" is a sign the saved value is not wired into the load → display path. Action → display and load → display are separate paths; "Saved" MUST NOT be shown while the latter is missing. A component that keeps an action result in state MUST accept an initial value of the same shape from the server (`initialX`), and any column written to the DB MUST be added to the read select spec and the DTO in the same change. A "write-only" column is never read.
*   **Real-Data Round-Trip**: A transformation with a round trip (display → edit → save → redisplay) MUST be exercised with real data, not synthetic data, to confirm invariance. Synthetic data never produces real-world shapes such as "an item containing a newline". Fix in a test the count at which a rejected approach broke on real data.
*   **Verify Where It Is Read**: Verify a fix where it is read (display, API response, derived table, aggregate, cache), not where it was written (table, setting) (MUST). Trace the path that builds the display first; in features with derived tables, aggregates, or snapshots, fix the derivatives when fixing the source. Never report "fixed" without confirming the final output (MUST NOT); if confirmation is impossible, say so explicitly. Before changing a setting to observe behavior, check the retrieval path for caches or dev-time bypasses, and follow `engineering/730_caching_discipline.md` for invalidation order.

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
*   **Prop Inventory on Consolidation**: When folding a dedicated implementation into a shared one, confirm one by one what each dedicated prop or option was for before dropping it (MUST). Performance considerations (eager loading of the first items, etc.) are invisible and vanish silently. A prop that is received but never used MUST NOT remain. A "declared and passed" prop slips through type checking, lint, and unused-code detection alike, so fix in a check that declaration and use exist as a pair (SHOULD). What disappeared was a feature, not code.
*   **TODO Management**: Always include ticket numbers or deadlines with `// TODO:` comments.
*   **Behavior-Preserving Consolidation**: A change that consolidates duplicate definitions into an SSOT MUST preserve behavior completely. Do it in two steps: "rewrite the unused SSOT-side definition to match exactly the inline value actually in effect at the call sites → switch the call sites to reference the SSOT"; do tightening or improvement (stricter regexes, etc.) in a separate change together with tests that pin that behavior (MUST). Mixing consolidation and behavior change in one change means that when a regression appears on an untested path you cannot tell whether "the consolidation" or "the tightening" caused it. For handling differences between copies, see §13.9 Copies Are Deleted, Not Monitored.
*   **Share Only What Must Be Equal (Summary)**: Flows with similar entry points share only the "method" (schema-based validation, handling of authentication, rate limiting, and bot protection); do not mix schema bodies, storage destinations, display paths, or cache invalidation targets (MUST). See Share Only What Must Be Equal in `core/000_core_mindset.md` §1.3 for details.

### 1.7. Root Cause First Protocol
*   **Prohibition**: Applying "band-aid fixes" without identifying the root cause is prohibited.
*   **Process**: 1. **Reproduce** the error locally. 2. **Diagnose** using logs, stack traces, dependency trees. 3. **Fix Root** cause, not symptoms.
*   **Transient Claim Discipline**: Classifying a failure as "transient" requires stating the mechanism (MUST); if you cannot, it is "unexplained". Success carries less information than failure: a pass does not prove the absence of a cause. A retry is a hypothesis test, not a fix; before retrying, declare the refutation condition ("if this passes, X is not the cause") and read the diagnostics already provided (build report, OOM notice, stderr) before the outward pass/fail (MUST). When "the fix did not help", observe whether that layer is really the one answering (a temporary log at its entry) before strengthening the same layer (MUST), and when several causes are plausible, launch a control run, a probe with the suspected cause removed, and a local reproduction in parallel (SHOULD). Lowering a threshold is "weakening", not "blocking".
*   **Two-Strike Spec Check**: When two consecutive fixes for the same symptom have failed, consult the primary source of the specification or implementation (WHATWG/W3C spec, library source) before a third attempt (MUST). Element-specific semantics (replaced-element size attributes and `object-fit`, the per-layer meaning of a setting) are not guessable.
*   **Guard Bypass Prohibition (Summary)**: Before adding a flag that disables a guard (configuration, hook, CI gate, lint), read that setting's comment and introduction history to identify which accident it prevents, and when the environment does not meet a requirement, choose to meet it rather than relax it (MUST). Verification performed while bypassed is invalid against the accident that guard prevents. See Guard Bypass Prohibition in `core/000_core_mindset.md` §1.4 for details.

### 1.8. Config Change Impact Analysis
*   **Context**: Changes to project-wide configuration files can cascade unexpected effects.
*   **Mandate**: 1. **Impact Scan** affected consumers, generated artifacts, runtimes, and release paths through repository search, a build graph, dependency analysis, or an equivalent mechanism. 2. **Risk-Based Approval** based on security boundaries, compatibility, shared toolchains, production blast radius, and rollback difficulty rather than file count alone. Require owner review, independent approval, or staged delivery as risk warrants. 3. **Cohesive Change** keeps affected configuration, generated output, migration, verification, and rollback traceable as one change unit and prevents an intermediate state from reaching users or release paths.
*   **Determination-Time Check**: When creating a configuration switch (environment variable, flag, etc.), measure for each surface when the value is determined (request time / build time / startup) and record it as a table in the runbook (MUST). If even one surface is fixed at build time, the procedure MUST say "change + rebuild", not "change the variable". "Redeploy" cannot be distinguished from reuse of the existing build and produces a state that looks disabled but is not. See the dynamic-configuration section of `operations/400_site_reliability.md`.
*   **Enumeration Extension as Cohesive Change**: A change that adds a value to an enumerating mechanism (`entity_type` and the like) MUST align the app constant, the DB CHECK constraint, the read-policy branch, the settings registry, the save-time sync hook, the public-surface application, and the admin UI in one change unit. When one side advances alone, the system degrades with HTTP 200, no exception, and no log. A missing branch in a row-level read policy is the most silent form: the write succeeds under a privileged role and only the read returns 0 rows. Place a test that checks, by complement (values present in the canonical CHECK but absent from a layer), that every layer covers every type, so a new value turns red automatically (MUST).
*   **Shared Component Replacement Scan**: When replacing a shared component with many call sites (link, form, formatter, URL normalizer, etc.), count by repository scan the set of input shapes callers pass (absolute / relative / query-only / fragment / external, etc.) and fix every shape in a table-driven input test (MUST). A table holding only the shapes imagined at design time tests none of the unexpected ones. In practice, a test table holding only absolute paths missed a rewrite of relative `?page=2`, and pagination and sorting stayed broken for weeks. Extract the decision into a pure function and also fix the rendered output of the component (SHOULD).
*   **Additional Scan Examples**: Domain/origin change → check CORS, CSP, cookie attributes, OGP, sitemap, robots, OAuth redirect URIs, webhook registrations, and the mail sending domain together. Environment variable removal → update all code references, each runtime platform, and the registry at the same time. Normalization changes such as `trailingSlash` → beyond in-app links, align the proxy's auth-exclusion condition, the public paths in robots / llms.txt / OpenAPI, and scheduler (cron) paths to the same canonical URL and confirm reachability over real HTTP (see `engineering/300_web_frontend.md` §108).
*   **Direction-Aware Invariant Checks**: When the "safe direction" of an invariant flips with another setting (parallelism, presence of workers, execution mode, etc.), the check MUST derive that setting from the real files and real values, and fail if it cannot read them. Held as a constant, it drifts silently unless whoever changes the setting remembers the check exists, and an implicit dependency on a framework default drifts when that default changes. Put guards in both directions, too high and too low (MUST). With only one direction, the same accident happens in reverse when the premise flips (in practice, a build memory limit failed twice, in opposite directions). Make the rationale comments for values part of the check too, and fail when their premise becomes false (SHOULD). A false explanation actively misleads the next owner's judgment, and the check keeps returning green while holding a false premise. Record judgment values that machines cannot guard (headroom factors, etc.) honestly as limitations (SHOULD).

### 1.9. Version-Aware Contract and Codebase Consistency
*   **Law**: Existing code is evidence of adopted patterns, while official version-specific documentation, security advisories, and support policies are authoritative for contracts and EOL decisions. Never prefer either unconditionally. Reconcile the lockfile, runtime or compiler pin, and installed-package types, signatures, generated output, and tests. Working code does not justify deprecated, undocumented, vulnerable, or accidental behavior.
*   **Action**: 1. Before using an API, inspect repository usage, the installed version's types and signatures, and official version-specific material. 2. Classify a conflict as version mismatch, generated drift, deprecated API, or undocumented behavior, then fix it or record an ADR with an owner and expiry. 3. Verify compatibility, migration, and rollback for a new pattern and update only the necessary existing implementation and documentation in the same change.
*   **The Silent Async Bug Pattern**: Every Promise, Future, Task, or equivalent asynchronous result is observed through `await`, return to the caller, aggregation, or a managed background task under §7.1. Prohibit fire-and-forget and unhandled failure, using language-appropriate static analysis.
*   **After-Response Hook Contract**: When launching a "not awaited" side effect on a platform that may freeze the function after the response is returned (serverless and the like), failure visibility (log + counter) and completion after the response (registration with the platform's after-response hook) are separate problems; make a composed helper that satisfies both the single entry point (MUST). A function passed to the hook MUST `return` the side-effect promise, and type it `() => unknown` so that `() => void` does not signal that discarding is correct. On a platform that awaits the hook's return value, `() => { void p }` is not tracked and the side effect disappears when the function freezes right after the response. Where the hook throws synchronously outside request scope (cron / background), wrap it with an immediate-execution fallback that never drags down the caller's return value or main path (MUST). Place a regression guard against the `void`-discard form and prove it turns red under mutation before trusting green.

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
*   **Credential Class in Names**: An environment variable name MUST state the credential's privilege class accurately (read-only / publishable / service / admin). A name that signals low privilege (`*_READ_KEY` and the like) MUST NOT hold a high-privilege key, and a fallback resolution from a low-privilege name to a high-privilege one (or the reverse) MUST NOT be implemented. At the boundary function that receives the credential, verify the expected privilege class at runtime (e.g. detect a privileged-key prefix or claim and reject it on a low-privilege path) so that misuse of a name is physically stopped (SHOULD). See `engineering/520_cloud_application_platforms.md` §7.
*   **Public Resolver Isolation**: Processing that needs only public values (CORS, CSP, redirects, OGP, etc.) reads only the public configuration resolver, and MUST NOT pull a resolver containing server secrets into the public runtime path. Processing that needs a secret reads it explicitly inside the target route/action (MUST). When a public page path imports the server resolver, the boundary of secret values such as privileged keys extends into ordinary public paths. Pin with a static check that public-path modules do not import the server resolver (SHOULD). Note that the app-side column selection (projection) is not a permission boundary (for permission design of public reads, see `engineering/200_supabase_architecture.md` Rule 3.5).

### 3.2. Environment Template Sync
*   **Law**: Maintain `.env.example` at project root with all required environment variable **keys only**.
*   **Sync Mandate**: When adding new environment variables, update `.env.example` **in the same PR**.
*   **Git Safety**: `.env.local` / `.env.production` files with actual values must be in `.gitignore`.
*   **Template Quality**: Annotate each variable in `.env.example` with a one-line purpose, where to obtain it (dashboard URL, etc.), and a format example of the value (SHOULD). A bare list of key names creates onboarding failures. Provide a setup command that generates the local configuration from the template and lists required variables that are still unset (SHOULD).

### 3.3. Environment Variable Drift Prevention
*   **Law**: Environment variable drift is the #1 cause of "works locally but breaks in CI/production."
*   **Action**: 1. **Startup Validation** with abort on missing variables. 2. **CI Parity Check** verifying all `.env.example` keys exist in CI. 3. **Type-Safe Config** with Zod/io-ts validation.
    4.  **Test Fallback Containment**: Known values for CI/tests (test site keys, dummy secrets, etc.) are filled in only at the configuration resolution layer, and MUST NOT be re-fallen-back to in UI components, actions, or API routes. When authentication, bot verification, or secret-class settings are missing in production, do not fall back to test values: the UI treats it as unable to submit and the server as a verification failure (fail-closed) (MUST). A fallback that is convenient locally, once it leaks into the component layer, becomes a back door that runs on test keys when production env is unset. State in test-value constants that they are "for CI use, not an operational fallback" (SHOULD), and confirm with grep that no test-value literal exists outside the configuration resolution layer.
*   **Runtime-of-Record Registry**: Store each secret only on the runtime platform that actually reads it; do not duplicate it onto platforms that never read it (MUST). The environment variable registry MUST record the target runtime platform in addition to purpose and source. A secret shared by several runtime platforms (app server and edge functions, CI and runtime, etc.) MUST be set to the identical value on every one of them; registering it on only one side is prohibited (MUST NOT). A one-sided gap becomes an outage of "only one path fails". When adding or changing a variable, check template / local / each environment / each runtime platform / registry / setup procedure in the same change (MUST).
*   **Pair Verification**: Wiring that only works once both the sending side and the verifying (or destination) side hold the correct value or permission (internal API secret, webhook signature, DMARC aggregate recipient, allowed IPs/origins) fails silently without an error on one-sided configuration or a key-format migration. A successful save on one side MUST NOT be counted as completion. Confirm the destination's requirements before configuring wiring that needs the destination's permission (MUST), prove the wiring itself periodically with a synthetic E2E probe (MUST), and do not call it done until a person has confirmed that the first item (first report, first webhook, first notification) arrived (MUST). A successful setting is not evidence of delivery.
*   **Generated Artifact Drift Gate**: Constants and schemas MUST NOT be shared across runtimes (Node.js and Deno, web and native, app and DB functions, etc.) through direct relative imports; they fall outside the bundler's resolution and only the production build fails. Share them by automatic generation from the SSOT (MUST): put an `@generated — DO NOT EDIT` header on the output, add a CI drift gate of "generate → `git diff --exit-code`", and include the SSOT source itself in the trigger paths. A manual "SYNC RULE" comment does not prevent human error.

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
*   **Purpose-Scoped Keys**: Separate an external service's API keys by purpose (send / receive / admin) (SHOULD). A leak of one leaves the other intact, and a partial failure from insufficient scope ("sending works but only receiving fails") becomes easy to isolate. Confirm key scopes against the official definition: a "send-only" key fails on read endpoints as a silent failure that is hard to diagnose.
*   **Zero-Downtime Rotation**: When the provider supports concurrent credentials, stage new-credential activation, consumer switchover, verification, and old-credential revocation. Otherwise design maintenance, queuing, rollback, and user communication according to risk.
*   **Rotation Audit**: Bind issuance, distribution, use, switchover, revocation, failures, and exceptions to a credential ID and owner, monitoring the next deadline or event trigger in a machine-readable inventory.
*   **Two-Sided Activation Proof**: The auth chain of a delegated secret distributed separately to the caller and the verifier (internal API secret, etc.) MUST be treated as "incomplete" until a real call returns a success response in the live environment on both sides. Visually confirming that the env is set is not evidence of completion. Equality comparison against a platform-injected key (service role key, etc.) MUST NOT be used for machine authentication; it breaks silently on key-format migration or rotation. Distribute a self-managed dedicated token to both sides and compare it in a timing-safe manner.
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
*   **Pin Rationale Mandate**: A toolchain or builder pin (`--webpack` and the like) and an exact dependency pin MUST have their reason recorded. A pin with an unknown reason becomes debt that cannot be removed when a security patch must be applied. When a plugin has a "builder-specific option", suspect first that it is the reason for the pin.

### 4.2. Lockfile Integrity Protocol
*   **Law**: Deployable applications and executable roots version the reproducible resolution source supplied by the ecosystem, such as a lockfile, checksum set, resolved graph, version catalog, provider selection, or vendor tree, and prohibit unintended changes. `package-lock.json`, `pnpm-lock.yaml`, `uv.lock`, `go.sum`, `Cargo.lock`, `packages.lock.json`, `composer.lock`, `Gemfile.lock`, and `renv.lock` are examples with different semantics and are not all treated as lockfiles. Publishable libraries follow ecosystem consumer-compatibility conventions while pinning CI test and release resolution and retaining dependency evidence.
*   **CI Discipline**: In supporting ecosystems, use frozen or locked commands such as `npm ci`, `pnpm install --frozen-lockfile`, `uv sync --locked`, or `cargo build --locked`. Where no standard lockfile or locked mode exists, use an equivalent gate that verifies version, source, checksum, and artifact digest and rejects unapproved re-resolution.
*   **Recovery**: When local and CI behavior diverge, compare runtime, package manager, registry, platform, and lockfile digest first. Lockfile regeneration is a reviewed change with an explicit reason, full dependency diff, tests, and SCA, not a standard recovery shortcut.
*   **Prohibition**: In applications and executable roots where the lockfile is authoritative, pushing after dependency changes without committing the lockfile is prohibited.
*   **Tool Version Parity**: The package manager version that generates, updates, or verifies the lockfile or resolution graph MUST match the version line used by CI and release. Even with the same lockfile format, version differences change how optional and platform-specific transitive dependencies are pruned, so a by-the-book operation still corrupts the lock. An install or dry-run that succeeds under the version that caused the damage is not evidence (a broken instrument cannot measure its own breakage); "verified locally" counts only when verified with the same version as CI (MUST). When the environment does not meet the required version, do not bypass the requirement; invoke the correct version temporarily (e.g. `npx -y <pm>@<CI version>`). Declare an `engines` equivalent with strict enforcement (e.g. `engine-strict=true` in `.npmrc`) so an install under an old version errors on the spot, and run the lock health check early as a preflight before dependency installation under the CI-side version (SHOULD).
*   **Lock Preflight Polarity (Supplement)**: Place the preflight above at a single point in CI with "run" as the default, and limit skipping to changes mechanically proven not to touch the lock (fail-closed) (MUST). A dry-run that installs no dependencies does not start lifecycle scripts (e.g., `--ignore-scripts`) (MUST), because in an environment without dependencies the script fails and the check itself misfires. See `security/200_oss_compliance.md` §14.1 for details.
*   **Single Package Manager**: Fix one package manager and lockfile SSOT per repository (or executable root); lock or workspace files of another manager (`pnpm-lock.yaml`, `yarn.lock`, etc.) MUST NOT be committed alongside. Build and deploy platforms detect the manager from lockfile presence, so a mix causes an unintended switch to a frozen install and Preview deployment failures. Detect mixing in CI or a pre-commit hook (SHOULD).
*   **Hand-Edit Verification**: After hand-editing or partially regenerating a lockfile, do not trust it until a frozen/locked install from a deleted `node_modules` exits 0 (MUST). Neither a successful normal install nor an all-green gate run afterwards says anything about lockfile health (an optional dependency missing for another platform never surfaces locally). Regenerate in a lock-only mode that does not consult the dependency tree (e.g. `npm install --package-lock-only --ignore-scripts`), treat a diff with "whole entries removed" as abnormal, and confirm that no package other than the intended one moved (SHOULD). Generate lockfile updates on the same runtime/OS as CI. "All green locally / every CI job dead" is a strong signal that the shared first step (dependency installation) failed, so suspect the lockfile before individual logs and isolate it by running a frozen install of main's lockfile locally (SHOULD).

### 4.3. Dead Export Detection
*   **Law**: Exported functions/types/constants with zero usage must be immediately removed.
*   **The Backup File Ban**: `.bak`, `.old`, `_copy` files must be deleted immediately. Git history is your backup.
*   **The Exhaustive Reference Scan (Grep First)**: Always `grep` the entire project before deleting/renaming files.
*   **Consumer-Count Liveness**: Whether a setting, environment variable, design token, or similar value is "alive" MUST be judged by the number of references on the consuming side, not on the saving or emitting side. A value that is stored and emitted changes nothing if nobody reads it. Count indirect references generated by the framework (utility classes, etc.) and confirm in the production artifact which variable is ultimately referenced (MUST). A description that claims an effect on a setting with zero consumers is not a specification but a trace of missing wiring: either wire it or correct the description to reality; leaving it is not an option (MUST).
*   **The Self-Referencing Route Scan**: A change that moves where a component or screen is mounted (its URL) is not complete with the page-side diff alone. Grep the component and its dependencies for the old URL and route constants and update every self-referencing path ("return after completion", "you can change this here") to the new location (MUST). Check: OAuth/external-flow redirect targets, cache revalidation paths, links, breadcrumbs, links inside notification emails, documentation.
*   **Refactor Scan Completeness**: In a refactor that rewrites import paths in bulk (barrel removal, etc.), include dynamic `import()`, inline type-position imports, and relative-path specifiers in the scan, not only static imports (MUST), and purge to the end the types and variables that cascade into disuse after the import source changes or disappears, using the linter's machine-readable output (MUST).
*   **Duplicate Export Ban & Caller Verify**: An exported function with the same name in multiple files MUST NOT be left in place. Fixes land on the side that is never called (the orphan) and go unnoticed through any number of audits (in practice, a misplaced fix slipped through several audits). Before deciding what to fix, verify the actual callers; do not decide to "fix both" from grep hits alone (MUST). Lint and type checking do not warn about orphan exports. Delete an orphan as soon as it is found, and record the caller verification result and where the real function lives in the commit message (MUST). Put the real fix and the orphan deletion in separate commits so a revert can roll back only the real fix (SHOULD). In audits, keep same-name export duplicates (e.g., multiple hits for `export.*function <name>`) at zero (SHOULD).

### 4.4. Ghost Feature Ban & Revival
*   **Ban**: Features without user pathways are debt. Delete per YAGNI principle.
*   **Revival**: Admin settings that produce no frontend effect are trust-destroying bugs. Always implement both sides simultaneously.
*   **Safety Setting Coupling (Ghost Config Supplement)**: A setting that the admin UI can save but the execution logic never reads creates "false reassurance of being configured" and is more dangerous than no setting at all. For safety-relevant settings in particular (limits, permission flags, rate limits), prove by test that the save path and the read path are coupled (MUST). Remove a setting with no reading implementation from the UI, or add it in the same change as the reading implementation (MUST). Never ship a settings UI carrying a "implement later" TODO to production.
*   **The Unwired Option Ban**: A change that adds an opt-in prop, option, or feature toggle MUST ship "definition + logic implementation + wiring at one or more call sites" as one change unit. Deferring the wiring makes the feature's very existence forgotten, and a prop with no connected caller stays "50% complete" while the opportunity cost continues. If the supply source (aggregate data, schema) does not exist, defer adding the prop itself (MUST) and close source design → migration → DTO → prop in one change unit. In audits, grep the call sites to verify that the added opt-in is actually wired (SHOULD).
*   **Storage Fix Triple Check**: A fix that opens permissions on an upload/write path does not complete the feature by itself. Verify in real code, in the same change, (1) the format of the stored value, (2) the path that converts it for display, and (3) the authorization guard on the write path that accepts it (preventing re-posting of another user's asset path; restricting to the caller's own prefix) (MUST). Display-side and acceptance-side defects that lay dormant while writes were denied surface the moment they are allowed. Enumerate mechanically (column-name grep, etc.) the sibling tables/paths with the same storage format and apply normalization and authorization symmetrically (MUST); once a contention-safe numbering is introduced, consolidate every legacy path that writes the same column (MUST). Leaving one behind produces orphaned assets and missed deletions through overwrites.

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
*   **Document-Schema Reality (Contrapositive)**: The reverse direction applies too. When a specification, rule document, PII matrix, or similar cites table, column, or RPC names, verify continuously by a mechanical check (e.g. `to_regclass` / information_schema lookup) that they exist in the real schema (MUST). Do not limit the check to "documents that already caused an incident"; extend it to every document containing schema names. When the implementation changed correctly ahead of the specification, revise the specification from measurement and record the method and date (SHOULD). See `core/100_governance.md` §11.2.

### 5.2. AI Hygiene & Anti-Blindness
*   **The Anti-Blindness Protocol**: Saving AI-generated abbreviations (`// ...`) to files is prohibited. Always expand to complete code.
*   **Human Verification Loop**: AI-generated code is a "draft." Always verify before committing.
*   **AI Context Exclusion List**: A repository that uses AI coding assistants (Copilot, Cursor, agents, etc.) MUST carry an exclusion list for context transmission (`.copilotignore` / `.cursorignore` and the like: `.env*`, private keys, seeds / production snapshots, migrations, confidential rules, key files). Check telemetry and training-use settings and disable unnecessary transmission (SHOULD). Inventory the exclusion list quarterly (the Blueprint sets the cadence) and confirm that newly added sensitive paths are excluded (SHOULD).

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
*   **Serialization Reality Check**: Arguments and configuration keys passed to an external SDK, API, or DB client MUST NOT treat passing the type check as evidence of correctness. Serialization, encoding, and pass-through of unknown keys change the meaning (e.g. an array is reformatted into a different literal form; a `value: unknown` argument passes the type check and is rejected downstream with 400 as an unknown key). Before a new argument shape or configuration key enters the main line, make one real call in a production-equivalent environment and observe both success and failure (MUST). In practice, a type-correct argument changed meaning on serialization and a scheduled job failed night after night looking like a stopped cron, and an unknown key rejected downstream wiped out a translation batch. Once a "type-passes-but-meaning-changes" shape has been hit, forbid its recurrence with a source-scan ratchet (SHOULD).
*   **Prerequisite Reality Check / Staged Enablement**: Enable a compiler, transpiler, or build plugin in three independent commits: (1) update of adjacent dependencies only, (2) opt-in mode applied to one or two low-risk samples to confirm runtime health, (3) making it the default and removing the temporary sample markers (SHOULD). Several semantic changes in one commit make bisecting impossible, and a green lint is a static-analysis pass, not runtime health. Do not remove existing manual optimizations in the same stage; retire them in a later stage after observing behavior (SHOULD). Before drafting a migration plan, inspect the installed tools' actual default behavior (active rules, plugin versions) from what is installed and measure whether "the prerequisites are already met" (MUST). Do not include phases a plan no longer needs on the basis of outdated literature.

### 7.3. Fix Twice Principle
*   **Law**: When fixing a defect, inspect recurrence paths with the same cause and add a risk-proportionate test, type or schema, lint or static analysis, monitoring, runbook, or design change that detects or prevents recurrence. If automation would create more risk than the fix, record the reason, residual risk, and recheck condition.
*   **Sibling Sweep**: When correcting a finding, mechanically enumerate (grep, etc.) every other occurrence of the same anti-pattern (shared helper not applied, misplaced side effect, write path of the same shape) and correct the applicable ones at the same time (MUST). The canonical rule is "Sibling Sweep" in `core/000_core_mindset.md`.
*   **Variant Enumeration**: After writing a fix, enumerate the variants of the path it protects (singular → plural, total loss → partial loss, this layer → the adjacent layer, another byte or another expression of the triggering condition) and apply the fix to each (MUST). Omissions cluster in variations along the same axis as the protected target; in practice two thirds of extracted bugs were "oversights in my own earlier fixes". For a fix that may apply at several layers, such as removing default-value injection, trace the value's propagation path to the end and prove by E2E that empty/null actually flows to the end (SHOULD).
*   **Cumulative Diff Review**: At the end of a long continuous effort (multi-round audit and correction), run one independent multi-perspective review (line by line / deletion behavior / cross-cutting trace / simplification / conventions) over the entire cumulative diff (MUST). Self-review within a round sees only that round's changes; interactions between rounds and variant omissions in your own fixes only surface in the whole. Core diffs (DB, authorization, metering, gates) get proportionate adversarial review even when they are your own fixes (see §12.8).
*   **Multi-Path Enumeration & Denominator Check**: An argument that falls back to an empty value when omitted (`x || fallback || []`) turns omission into a "silent zero" instead of an exception. If omission cannot throw, pin with a source contract test that "every path using this projection calls the resolver" and "omitted calls number zero", and confirm the test turns red under mutation (MUST). When several paths build the same DTO or value, enumerate all of them before fixing (MUST). Fixing only one lets the rest live on in the same shape (in practice, most fetch paths omitted the argument, and a core attribute display was missing entirely while every check stayed green). When confirming a fix's effect by "the count went down", measure the denominator via a separate path (direct DB count, etc.) (MUST). "The filter worked" and "there were zero targets to begin with" look identical in the result. For projection/mapper-centered sweeping, see Drift Sweep Scope in `quality/000_qa_testing.md`.

---

## Part VIII: Continuous Learning & Verification

### 8.0. Latest Info Protocol
*   **Before Development**: Always check official documentation and latest release notes before writing code.
*   **Deprecation Check**: Verify APIs are not deprecated before using them.
*   **Verified Check Baselines**: A check that branches on an external system's values (path format, headers, status, spec-mandated fields) is unverified even when it turns green on fixtures you wrote yourself. Do not adopt it until it has been run against real data and the direction of the decision confirmed (MUST). Write check baselines and registries (required properties, thresholds, spec values) only after confirming each entry against a primary source, and leave unconfirmed entries empty (MUST). Either confirm every entry or none; never rely on partial confirmation and "probably right". Record the confirmation date and the nature of the source in the registry. When the full set of external values cannot be known, lean toward a denylist rather than an allowlist and state the conditions it misses at the top of the module (SHOULD). The canonical rule is "External-Value Branches" in `quality/000_qa_testing.md`.

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
*   **Context**: More tests do not automatically mean better tests, and one ratio does not fit every system. Select static, unit, integration, contract, E2E, and non-functional tests from `quality/000_qa_testing.md` and `axiarch-rules/{lang}/universal/engineering/320_programming_language_governance.md` according to change risk, architecture, failure cost, execution time, and historical defects.
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
    *   **Verification Code Discipline**: Temporary code and queries written for verification are held to the same discipline (MUST). Always print errors and never read `null`/empty as "a fact". Do not guess column or field names; confirm they exist against the real thing (schema lookup) before narrowing. Never read an exit code through a pipe (`| tail` / `| head` / a notification wrapper returns the last command's status and hides where the chain stopped and what never ran). Look at it bare with `> log; echo $?` or separate execution from display. Before concluding "0 matches", confirm the target file or path exists with `ls`/`stat` (when an earlier stage of a compound command fails, a later "0" is meaningless). Do not place an early-exit command (`grep -q` / `head`) on the right side of a pipe in a condition (under `pipefail` the left side dies of SIGPIPE and a match evaluates false). "It looked green but there is a stack-trace fragment" always means suspect the stopping point.
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
*   **Timeout from Measured Distribution**: Derive the timeout budget from the measured distribution of normal runs (the last N runs), not from intuition (MUST). In practice, recent runs were stable at about 7 minutes, a 20-minute budget (2.8× headroom) was still hit, and the cancelled runs were waved through as "occasionally flaky" by re-running. Treat the "hangs" kind (external fetches) and the "slows down" kind (static checks) differently (SHOULD): widening the budget barely dulls failure detection for the latter, while the former should absorb delays with retries rather than a wider budget. Give heavy steps their own timeout so the run fails at a step name before eating the job budget and the location of the delay is obvious (SHOULD).
*   **The CI Trigger Alignment Protocol**: Align a CI check's trigger with the event on which the invariant it enforces can be broken (MUST). Watching for a violation originated by your own change (migration apply, generated-artifact update) with a weekly or similar schedule is the same as tolerating an exposure window of one period. A schedule is right only when the violation arises independently of your commit (new CVE, external manual change, data sync). However, a check that compares against production state produces constant false positives when run before apply: chain it after apply completes and condition it on the predecessor's success only (a completion event also fires on failure or cancellation) (MUST). A trigger resolved by a name string (referenced workflow name, etc.) silently stops firing on a typo or rename, so fix in a guard test that the referenced target exists and that the target check keeps its trigger, and confirm by mutation that the guard itself handles both notations (inline / block) (MUST). A check deliberately left on a schedule MUST have the reason recorded in the evidence trail. The canonical rule is "CI Trigger Alignment" in `engineering/600_git_workflow.md`.
*   **The Red Button Checklist**: Convert applicable Legal, Security, FinOps, Data, and reliability risks into machine-readable gates or traceable approval. Do not make a manual checklist the sole implementation for every release.
*   **Omnichannel Check**: When multiple clients are in the product contract, verify shared domain and API contracts separately from client-specific UX. Do not force omnichannel requirements on a system that does not promise non-Web clients.
*   **Deployment Safety Protocol**:
    *   **Primary Directive: The AI Git Ban**: Refer to `axiarch-rules/{lang}/universal/core/000_core_mindset.md` Rule 8.1 for the strict prohibition of AI Git operations.
    *   **The Automated Deployment Mandate (CD First)**: Default to a reproducible, auditable pipeline that records artifact digest, approval, staged delivery, and rollback. Do not ban break-glass deployment outright; require least privilege, two-party control or independent post-review, complete logging, expiring credentials, and restoration of automation.
    *   **The Architectural Preservation Protocol**: Protect core boundaries through ownership, protected paths, review policy, contract tests, or equivalent controls. An `@preservation_level CRITICAL` header is an optional implementation.
*   **Security**: Never commit secrets. Verify the repository and history in CI through a secret scanner or equivalent control; TruffleHog is an example.
*   **Lockfile Recovery Discipline**: When only CI fails, first compare the runtime, package manager, registry, platform, and lockfile digest. Treat regeneration as an intentional dependency change requiring a complete dependency diff review, tests, and SCA; it is not the default recovery step.
*   **CI-Fix Ancestry Check**: Before starting to repair a failed CI or scheduled job, reconcile the revision the failed run verified (its checkout SHA) with the ancestry of the presumed fix commit (e.g. `git merge-base --is-ancestor <fix> <headSha>`) (MUST). "The last failure" does not mean "still broken now". The first move of a repair task is establishing the full set of failure causes across all run logs plus that ancestry check (MUST); never recreate a fix that is already merged. In practice the fix had been merged 12 minutes after the failed run. If already fixed, verify by re-running, and only start code changes once the re-run fails (SHOULD).
*   **Generated Artifact Formatting Exclusion**: Every file whose SSOT is a generator (generated types, synced constants, etc.) MUST be excluded from formatters and auto-formatting. When CI compares strictly against the generator's raw output, committing a formatted version turns that CI permanently red; recover by re-running the generator, not the formatter. Run a bulk formatting command (`prettier --write .` and the like) only after excluding edit-protected assets (rule repositories, vendored files) (MUST). Before local type verification, delete stale generated directories that the build does not regenerate (dev-server-only type caches, etc.) (SHOULD); CI is fresh and detects nothing, so ghost errors appear only locally.
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
*   **DB-Enforced Value Set Protocol**: Make the value set that the DB enforces through CHECK constraints, literals inside policies, or enums the SSOT for app-side status constants, and keep constant values identical to DB values (MUST). Convert UI labels in the display layer; MUST NOT let UI vocabulary pull a value that does not exist in the DB into validation schemas or options.
    *   **Same-Change Rule**: A migration that changes a value set MUST include, in the same change, the updates to the corresponding constants, validation schemas, DTO unions, and UI options. Merging the migration alone is a source of latent bugs where "every INSERT of that value fails", which neither type checking nor mock tests detect (in practice, choosing one option made saving always fail, and this stayed latent for months). Leave no hand-written union duplicates; derive from a single constant.
    *   **Bidirectional Set Verify**: Enforce in pre-commit or CI a verify that mechanically detects the set difference between the code side and the SQL side (`IN (...)` in policy bodies, CHECK, enum), and output it in both directions, "only on the code side" and "only on the SQL side" (MUST). A sync script that depends on manual runs does not prevent drift. For full-layer coverage when adding a kind, see §1.8 Enumeration Extension as Cohesive Change.
    *   **Auxiliary Evidence**: The fact that an `ADD CONSTRAINT` without `NOT VALID` applied successfully can serve as evidence that "no existing row violates it" (MAY). Delete as dead code any decision or display code for values that cannot appear in existing rows (SHOULD).

---

## Part XI: Documentation Ops

### 11.0. Living Documentation
*   **Mermaid.js**: Manage architecture diagrams as code (Mermaid) to prevent staleness.
*   **ADR**: Record technical decisions in `docs/adr` as Markdown.
*   **The Live Docs Requirement**: API endpoints must be continuously visible via Swagger UI or ReDoc.

### 11.1. Docs as Code & Freshness
*   **Docs as Code**: Documentation is equal to code — manage in Git, include in PR reviews. Code changes without doc updates are merge-blocked.
*   **Freshness**: Automate link-rot checking and review major rules quarterly.
*   **Comment–Behavior Parity**: A comment that asserts behavior (rounds / retries / rejects / checks everything / fixed as a set) MUST NOT be written without a corresponding test or check. At the end of a fix, grep for the assertion words you wrote and reconcile each one with the presence of the implementing symbol. No type checker, linter, or existing test detects comment-implementation drift, and a wrong comment does more harm than a wrong implementation (the next reader believes it is "handled" and walks past). When a check's name or header comment says "all", "set", "ratchet", or "exact match", read the code to confirm that a predicate enumerating the targets actually exists (MUST); a name is a claim, not an implementation. A comment stating an assumption (count, frequency, order) is accompanied by a check that turns red when the assumption breaks (SHOULD).

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
*   **Law**: A true CI pass means zero warnings from the language-native formatter, linter, type checker, or compiler. `npm run lint` is only a TypeScript or JavaScript example. Follow `axiarch-rules/{lang}/universal/engineering/320_programming_language_governance.md` for required gates and remove unused symbols immediately.

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
*   **Fix-Diff Adversarial Review**: A fix diff touching security or data integrity MUST, once implemented, go through one round of independent review that treats that diff as the attack target (a different role / a different agent / read-only). Your own re-reading MUST NOT count as verification. Ask first whether the fix opens "a worse hole than the original defect". Converting to an RPC, changing the privilege model, or adding a gate easily creates, next to the closed hole, "client-trusted arguments", "excessive execution grants", or "dependence on a gate in another path"; a fix that tightens privileges confirms both "who can call it (GRANT)" and "who decides the arguments (trust boundary)" against the real DB privileges. A cross-cutting fix (partial-failure visibility, masking, escaping, etc.) enumerates every sibling target and measures coverage before declaring completion (MUST). "Do not fix 3 and call it 10."
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
*   **Check Self-Consistency**:
    *   When introducing a check that measures a state and forbids it ("N commits behind main is prohibited", etc.), first confirm whether the act of correcting that state is treated as an exception while in progress (MUST). A check that forbids the only means of satisfying it is a design failure, and a situation whose only exit is `--no-verify` is a design failure, not a check failure.
    *   An exception MUST NOT be an unconditional skip. Limit it by measurement to the corrective operation (e.g. pass only during a merge whose target is an ancestor of the agreed mainline). Wanting to use a bypass flag is the signal to fix the check (MUST); bypass counts are recorded nowhere, and the next person punches the same hole in the same wall.
    *   After fixing a check, confirm by execution not only that the state that should pass passes but also that the state that should still fail fails (mutation in both directions) (MUST). Merely turning it green is indistinguishable from breaking the check.
    *   A test MUST NOT reference a declaration that is "normally empty" (exception list, allowance list, migration flag, provisional allowlist) as if it had members, such as `LIST[0]`. The canonical rule is "Exception-List Hygiene" in `quality/000_qa_testing.md`.
*   **Format-Dependent Checks**: Write a check that depends on an external tool's or runtime's output format (log strings, transcripts, structured events) on the assumption that the format will change (MUST). Hold the decision as a set that tolerates several formats rather than "matches one of the known strings", and never delete old-format patterns (only widen, never narrow). When the check is red, first confirm by a means independent of the check (parsing the structured data directly, etc.) whether the target is really broken (MUST). A check that reports a working thing as broken creates the motive for a bypass flag and weakens governance as a whole. A plain-text grep over JSON logs counts itself the moment the pattern appears in the log; even when the decision only uses `> 0`, state in a comment that the number must not be read as a measurement (SHOULD).
*   **Hook Context Fidelity**: Verify a gate launched by a hook, CI, cron, or scheduler by reproducing the context it is actually launched in (the runner's invocation, shell options, environment variables) (MUST). A green obtained by running `bash <script>` by hand is not the green of a hook launched with `sh -e`. A hook script declares `set -eu` (or equivalent) itself at the top so it is fail-fast regardless of how it is invoked (MUST); relying on the `-e` the runner adds swallows earlier failures under a different `core.hooksPath` or direct execution and returns only the last command's exit. Read an extremely short failure output as "died early", not "nothing happened" (SHOULD), and locate the failing line by running each line individually with its exit code. A test that spawns an external process is isolated down to environment variables (MUST); inheriting `{...process.env}` wholesale rests on the false assumption that "changing cwd is isolation enough" — `GIT_DIR` and friends for git, and likewise `npm_config_*` / `NODE_OPTIONS` / DB connection variables. In a regression test, fix by before/after comparison that the caller's state (HEAD, etc.) did not move, and catch contamination bugs by side effect, not by return value. After creating a worktree, check the hook path setting (`core.hooksPath`) (SHOULD).

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
    4.  A belief from memory, notes, or conversation that something is "merged" or "deployed" does not guarantee that the current working tree is up to date. Before editing a file touched by a recently merged change, run `git fetch` → check behind status (`git status -sb`) → if clean, `git merge --ff-only origin/main`, and only then edit (MUST). When the file overlaps a recent change, inspect that change's actual diff (`git show <merge-sha>`) and build on that revision (SHOULD). An edit on a stale tree passes compile and build, so it cannot be detected afterwards, and it silently reverts merged changes.

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
*   **Mapper Fan-Out Sync**: When a field is added to a DTO interface, every related mapper (e.g. `toXDTO`, `toAdminXDetailDTO`, `toBaseXDTO`) MUST be updated in the same commit. If a DTO change does not propagate to every mapper, the UI suffers silent data loss (the value is always `undefined`). On a field addition, grep by the mapper naming convention (e.g. `to.*DTO`) and enumerate the omissions (MUST). As long as mapper inputs are lenient types (Partial / unknown), the type system cannot detect the omission; review and grep are the last line of defense.
*   **DTO Boundary Casting**: Convert DB results to DTOs using explicit mapping functions (`toDTO(dbResult): MyDTO`), not `as any`.
*   **Serialized Attribute Pruning**: Before embedding JSON into `data-*` attributes, JSON-LD, or a hydration payload, prune it to metadata related to the displayed IDs/URLs (MUST). Even metadata not referenced by the display enters the public data boundary the moment it is serialized into HTML. Treat human-readable metadata of deleted elements (captions, notes, permission names) as public information even when hidden. Test that the display component and the SSR/static renderer use the same normalization helper, and detect regressions with negative expectations that metadata of deleted elements does not remain in the serialized output (SHOULD).
*   **DTO Segregation**: Prohibit bloated single type definition files. Split by feature domain (e.g., `types/store.ts`, `types/user.ts`).
*   **Mapper Input Robustness (Postel's Law)**: Be liberal in mapper inputs (tolerate ORM inference imperfections), strict in outputs (guarantee complete DTO types).
*   **Mapper Input Robustness (Reinforcement)**: "Liberal" above does not mean `any` or `Record<string, unknown>`. Fix the input type of a copying function (DB row → DTO, DTO → external publication) to a concrete Row/DTO type or a named narrow type (`Pick<Row, …>` and the like: only select-derived columns required, non-fetched columns optional) (MUST). A loose input type permits not "a missed copy" but the fabrication of a non-existent column, and a field that always returns `null` hardens into an external contract; users cannot distinguish it from "no data", and nobody notices. Type errors that surface the moment the input is narrowed (SELECT of a non-existent column, a DTO field absent from the schema) are evidence of dead references, so delete them immediately (MUST), and keep long-lived `row: any` at zero in audits as a vault of hidden drift (SHOULD).
*   **JSON Reference Normalization**: Normalize references stored in JSON/JSONB columns (where `{url}` / `{path}` / bare strings may be mixed) into a single display shape (e.g., `string[]`) at the DTO boundary, and keep the internal shape unknown to UI components (MUST). JSON columns have weak static guarantees, and handling them on the UI side spreads the same defensive code across detail, list, admin preview, and so on. Make the normalization helper a defensive boundary that returns a fallback / `null` instead of throwing on non-string input, and pin representative shapes with DTO regression tests when adding shapes (SHOULD).
*   **Explicit Mapping Mandate**: Prohibit spread syntax (`...input`) for write payload construction in Service layer. Map all fields individually.
*   **DTO ≠ Write Contract (Supplement)**: A read/public DTO (including `Partial<DTO>`) MUST NOT be passed as-is to a DB insert/update. The meanings of nonexistent columns, relation arrays, aggregated fields, and PII-excluded fields get mixed into the write. At the write boundary, place a small mapper that builds the payload with the generated Insert/Update types, and exclude relation arrays (child entities) from the parent row's update and handle them separately as child-table commands (MUST). In review, grep for places that pass DTO types into write calls (e.g., using `Partial<.*DTO>` as a payload) and keep them at zero (SHOULD).
*   **Read-DTO / Edit-DTO Segregation**: A public display allowlist DTO MUST NOT be used as the input basis of an edit screen. Display "narrows" while editing "carries everything", so the requirements are opposite; sharing them silently drops every field the display does not use on each save. In practice a migrated body HTML became unrecoverable after a single save. The edit entry point restores internal fields from the original row and declares them in the save schema too (MUST). Keep "the save succeeds" and "the save loses no value" as two separate checks (MUST), and fix that a round trip (read → save unchanged → read) loses zero non-empty values. Inspect the round trip on four faces: (a) keys of array elements, (b) element counts, (c) non-array object columns, (d) whether the write payload overwrites a non-empty column with empty (SHOULD).
*   **Read-Then-Save Round-Trip Contract**: In a design where the edit form always sends every field, fields the read DTO does not supply (derived fields whose DTO name differs from the column name, fields passed through a cast as `undefined`) are sent with initial values (empty arrays, empty strings) and are erased every time an unrelated field is saved (type checking cannot detect this, hidden behind the cast). The update payload contract distinguishes `undefined = no change` from `empty = clear`, and the form MUST NOT send fields the DTO does not supply. Place a check that reconciles the list of form-submitted keys against the list of DTO-supplied keys (MUST), and fix the read side before enabling writes (SHOULD). The round-trip check facets follow Read-DTO / Edit-DTO Segregation above.

### 13.2. The Client-Server Boundary Protocol
*   **Client DB Access Prohibition**: Direct `supabase.from()` calls from client-side are prohibited. Route all data operations through `Server Actions` or `Route Handlers`.
*   **Secure Write Action Protocol (Turnstile Mandate)**: Public form write Server Actions must accept and verify `turnstileToken` server-side.
*   **Service Pattern Mandate**: Direct DB access function calls in `page.tsx` or `layout.tsx` are prohibited. Extract to `lib/api/gateways/` (Read) or `lib/actions/` (Write).
*   **Async Boundary Protocol**: Directly importing async Server Components into Client Components violates React specifications. Use `children` Prop or Composition patterns.
*   **Not-an-Endpoint Principle**: Under a mechanism that automatically turns an export into a public endpoint (server actions and the like), internal processing that uses a privileged client (cron, batch) MUST NOT be placed there. An ungated `'use server'` export permits unauthenticated reads and writes across row-level control. The answer is not to guard it but to move it into a non-public module (`server-only`, etc.) and "stop being an endpoint". Fix in a static check that every export using a privileged client directly has an auth gate alongside, and audit exceptions down to a reasoned registry, the population count, and leftover stale permissions (SHOULD). Clamp numeric external input to bounds.

### 13.3. The Service Layer Architecture
*   **Service Layer Extraction Mandate**: Entry points (Route Handlers, Server Actions) must be "thin interfaces." Direct business logic in entry points is prohibited.
*   **Thin Controller Mandate**: Controller code is limited to: (a) request parsing/validation, (b) auth/authz checks, (c) Service layer calls, (d) response construction. Direct DB calls in controllers are prohibited.
*   **Service Aggregation Protocol**: Extract aggregation logic for single-page data from multiple Gateways/Actions into Service layer `get...Data()` functions.
*   **Omnichannel Delivery Mandate**: Direct business logic or data access in UI components is prohibited. Extract all logic to Service/Gateway layer for reusability across Web, mobile, and AI agents.
*   **Error Translation**: Service layer exceptions must be translated to HTTP status codes in the Controller layer. Service layer must not know HTTP.
*   **Context Propagation Mandate**: A function that receives a DB client, connection, or transaction context as an argument passes that same context to its internal sub-queries and helper calls and MUST NOT create a different (especially a higher-privilege) client inside. Resolve it once, as in `const client = supabase ?? createAdminClient()`, and pass the same client thereafter. A deviation creates a hidden dependency on environment variables, untestable units, and a gap in the privilege-boundary audit. When clients of different privilege are genuinely needed, separate the responsibilities by parameter name, such as `readClient` / `adminClient`, and document which privilege boundary each is (MUST). Fix in a regression test, with the factory mocked to throw, that the high-privilege client factory is never called when the argument is supplied (SHOULD).

### 13.4. The CQRS & Cache Strategy
*   **CQRS Separation Mandate**: Mixing Read and Write logic in a single function is prohibited. Clearly separate `QueryGateway` and `CommandGateway`.
*   **No Side Effects in Queries**: Query methods must only read and transform. No DB writes or external API calls.
*   **Hierarchical Cache Strategy**: Uniform caching regardless of data characteristics is prohibited. Classify into tiers:
    *   **STATIC**: CDN/ISR. **WARM**: TTL 5min–1hr + SWR. **HOT**: Short TTL + on-demand revalidation. **REALTIME**: No cache + WebSocket/SSE.
*   **Cache Invalidation Ceremony**: After core query logic changes, mandatory build cache deletion and full dev server restart.
*   **Dev Cache Bypass (Supplement)**: The ceremony above is a last resort. Where "I fixed the DB but the screen is stale" keeps recurring in local development, an operational procedure such as deleting the build cache MUST NOT be the permanent answer: procedures are not followed, and with several layers the procedure itself is incomplete (recurred three times in practice). In the development environment, bypass the cache path of public data fetchers themselves with a conditional (MUST), and do not call a shorter TTL a bypass; a shorter TTL only shortens the time a one-generation-old value is served, and at the boundary a stale value always appears. With several cache layers (application cache / HTTP fetch data cache / CDN, etc.), place the bypass decision in one SSOT that every layer consults (MUST). Never change production TTL or tag definitions for the convenience of dev (MUST NOT), but keep an escape hatch (an environment variable, etc.) to reproduce production-equivalent cache behavior locally (SHOULD). The same word (`revalidate`, etc.) can carry different semantics per layer, so settle a setting's meaning by reading the library implementation before using it (MUST). When "the fix did not help", isolate with a temporary log at the function entry that "it runs yet returns a stale value, so the cause is not upstream" before strengthening the same layer further (SHOULD).
*   **Cache Hit Rate**: Measure cache hit rates; endpoints below 90% are optimization targets.

### 13.5. The Mutation Integrity Protocol
*   **Law**: In write operations, `error: null` does NOT mean success. Always verify affected row count (`count`); throw explicit error on 0 rows.
*   **Count Validation**: For single-record operations by ID, verify affected rows match expected value. `error: null` + `count: 0` is "Phantom Success."
*   **Sub-Step Integrity**: When multiple write operations occur in a single Service function, verify `error` and `count` individually for every sub-step. Prevent "Partial Phantom Success."
*   **Fail-Fast Cascade**: If any step detects an error, abort subsequent steps immediately.
*   **Post-Mutation Verification Fetch**: After critical updates, re-fetch by same ID to verify data persistence via logs. This 100% distinguishes "DB write failure" from "cache issues."
*   **Step-by-Step Logging**: Log each sub-step result (e.g., `Logger.info('[Step 2/5] Updating tags...')`) for rapid root cause identification.
*   **RLS Awareness**: With Row Level Security databases, insufficient permissions return as "0 rows affected," not errors.
*   **Derivation Timing Guard**: When designing a derivation, decision, or scan, state explicitly "when", "as whom", and "how many times" it is evaluated (MUST). Get it wrong and a correctly written process works in reverse. For a value derived from external input (URL, external API, etc.), put "if the input has not changed, use the stored value" before the extraction (MUST). Re-deriving on every save overwrites and breaks a correct, hand-corrected stored value each time and generates needless external access. Decide which value is right by independent information, not by agreement with the same deriver's output (self-agreement). See `engineering/710_data_reconciliation.md` for independent reconciliation and `engineering/200_supabase_architecture.md` for the default row limit of a full scan.
*   **Row-Count-Blind Procedures**: After calling an RPC or procedure that returns no affected-row count (`RETURNS void` and the like), re-read the target row and confirm it as your own operation before writing a success response or an audit row (MUST). The response is identical for a non-existent or already-released target, so it manufactures a false success and a false audit row. In practice the settings update verified affected rows while only the release path fell outside the discipline. Record what was changed (masked identifier, stage, count) in the audit details.

### 13.6. The Type Safety & Integrity Protocol
This section is an additional TypeScript-specific standard. `axiarch-rules/{lang}/universal/engineering/320_programming_language_governance.md` is the source of truth for cross-language type and boundary contracts.
*   **Zero `as any` Policy**: Using `as any` or `as never` to suppress type errors is "embedding bugs." Set ESLint `@typescript-eslint/no-explicit-any` to `error`.
*   **Root Cause Resolution**: Resolve type errors through "type definition fixes," "DTO redesign," or "generics application," not casts.
*   **Type Bridge Mandate**: For auto-generated type gaps, define extension types in `database-extensions.ts` using Mapped Types to prevent type collisions.
*   **Linter Suppression Prohibition**: `eslint-disable` / `@ts-ignore` usage is prohibited in principle. If unavoidable, always include reason comment and Issue number.
*   **Generic Type Inference Safety**: Prohibit `Record<string, any>`. Use `Record<string, unknown>` or constrained generics.
*   **Verification Gate**: Committing code that doesn't pass type checking (`tsc --noEmit`) and linting with **zero warnings** is prohibited.
*   **External Identifier Branding**: Treat an external system's identifier (payments, CRM, ads, shipping, etc.) as a distinct type even when its representation (string / uuid) matches your own identifier (MUST); a mix-up between two `string`s passes the type check untouched. Reject confusion at compile time with a branded type / newtype / value object (SHOULD), and never send a record that cannot be resolved to an external identifier; leave it in the ledger as a skip with a reason (MUST). Sending a wrong identifier is an irreversible accident of "billing someone else", worse than "could not send". In practice a uuid was confused with the external `cus_` format and metered billing failed to be raised at all. Regression tests assert on the negative side not only "is well-formed" but also "is not our own identifier" (SHOULD).
*   **Double-Cast Minimization**: Try the weakest coercion first. A double cast (`as unknown as T`) where a simple assertion (`as T`) passes is prohibited (MUST NOT). Limit double casts to the type-incompatible boundaries where the compiler rejects a simple assertion (ORM inference limits, JSON columns, RPC return values, recursive form types), classify remaining double casts in audits by "which boundary category justifies it" with counts, and resolve the unclassifiable ones by improving type definitions (SHOULD). "Just double-cast it" is a sign of switched-off thinking (it spread to over 60 files in practice).
*   **Cast Audit Protocol**: An audit of casts that break the type hierarchy (double casts, non-null assertions, `as any`) MUST grep all sources across every layer where they can arise (mapper inputs, action/route payloads, generics in the gateway/cache layer, return values of client factories, workarounds for deep type recursion in UI libraries) and classify hits by layer. An audit biased toward some layers produces leftovers right after declaring "eradication complete". Record each hit in one of three classes, "eradicable", "kept with a reason", or "removal attempted and reverted", and for reverted ones write in a code comment what was tried, the type error it failed with, and the upstream condition being waited on (MUST), so the next audit does not repeat the same attempt. "Eradication complete" may be declared only when the grep across all layers is zero or every hit is classified (MUST).

### 13.7. The Error Handling Contract
*   **Structured Error Return**: Server Actions are **prohibited** from using `throw new Error()` for business logic failures. Return `{ success: false, error: '...' }` structured responses instead.
*   **Graceful Failure Contract**: Display errors via toast notifications or inline error messages for proper user feedback.
*   **Server-Client Symmetry**: When strengthening server-side guards, always simultaneously prepare frontend "error receivers."
*   **Classification Change = Control-Flow Change**: When a typed error or error-classification function is introduced or extended, enumerate every reference to that classifier and explicitly decide the expected behavior of each branch when the new type arrives (MUST). As long as the classifier doubles as a branch condition, a classification change is a control-flow change and "I only added a message" does not hold; path changes appear in neither the diff nor the tests. Centralize the "should this anomaly propagate" decision in a single SSOT predicate instead of writing it per module (MUST).
*   **Degrade vs Propagate by Caller Role**: The semantics of a branch are decided by the caller's role (MUST). For an auxiliary feature (context enrichment, recommendations) degradation is correct; for a feature that returns facts (detection, classification, summarization) propagation is correct. Returning a value as a "judgment" when the backend could not even be reached is a false fact from the outside, and it runs the success-path metering and billing too.
*   **Input-First Persistence**: Placing a parallel wait such as `Promise.all` outside a try lets one throw skip every subsequent side effect (saving, recording). Never build a structure that waits on external calls in parallel before persisting the user's input (MUST NOT); on failure the input disappears with it. In practice a classification change meant as a wording fix ended in lost user input.
*   **Structured Error Logging**: Prohibit direct embedding of error objects in string templates (outputting `[object Object]`). Explicitly destructure `message`, `code`, `details` for logging.
*   **No Live Values in Log Messages**: Never template real values such as form input, AI response bodies, storage keys, or identifiers into a log message string (MUST NOT). Automatic masking works on structured fields, so a value mixed into the message bypasses the masking SSOT. Pass dynamic values as structured meta (MUST).
*   **Centralized Logging Protocol**: Prohibit `console.log` in production. Always use `src/lib/logger.ts`.
*   **Read-Write Privilege Symmetry**: When using privileged clients for writes, ensure equivalent visibility for "reads for editing."
*   **Composed Helper Pairing**: A shared helper that bundles several concerns (e.g., completion guarantee + error visibility) MUST be provided as a pair when its components have variants such as "PII-safe / unsafe" or "strict / relaxed". With only one, callers that need the other give up on the composition and escape to hand-written code, silently losing the other bundled concern (completion guarantee, etc.). When the same hand-written workaround pattern (a bare `.catch()`, etc.) appears in many places, suspect a gap in the SSOT's offering rather than caller discipline (SHOULD). In practice, dozens of hand-written sites reflected "there was no correct option to choose", not "everyone was careless". Before migrating callers wholesale onto an existing composed helper, read the strength of the capture and logging it uses internally (whether it sends PII) (MUST), and once a pair exists, demonstrate that a mutation swapping one for the other turns the tests red (SHOULD). See also §1.9 After-Response Hook Contract.
*   **Step-Tagged Failures under PII Scrubbing**: When loggers, proxies, and classifiers that drop bodies at the PII boundary are chained, each layer can be correct and still strip one clue each, making the root cause invisible (in practice five correct designs hid a root cause for over a day). A process that bundles several steps MUST record the step name on failure as PII-free meta; a logger that serializes only the Error name loses which step it was. A failure catch sends classified meta (step, status, kind) immediately to a long-retention monitoring platform, not only to volatile application logs (SHOULD). Confirm the root cause by the same-timestamp match of records on both sides of the boundary.

### 13.8. The Dead Code & Workspace Cleanup
*   **Dead Code Prohibition**: Immediately delete all unused code (variables, imports, functions, type definitions). No commented-out code. Git history is your archive.
*   **Orphan Business Logic & Local-Only Scripts**: Delete a business-logic export with zero callers instead of keeping it "in case"; consult Git history when re-implementing (SHOULD). As long as it is exported, someone can import it, so it stays on the attack surface and keeps costing security fixes in unrelated work. A local script that uses a bypass credential (service role, etc.) MUST require an explicit env opt-in, refuse to run in CI/deploy environments, and carry a "LOCAL-ONLY" docblock at the top; a script that rewrites source MUST default to dry-run and require `--apply`.
*   **YAGNI Strictification**: "Might use later" code is "noise." Pre-emptive implementation not in current user stories is technical debt.
*   **Clean Workspace Mandate**: Before commit, remove all temporary files, build caches, empty directories, and `console.log`.
*   **Unstable Timer Protocol**: Using `setTimeout` or `setInterval` for logic control is prohibited. Use event-driven architecture or job queues.

### 13.9. The API Product & Configuration
> Also refer to **§13.15 Idempotency Key Protocol**.
*   **API Product Mindset**: All data output is a "Product." Design APIs with **Tier 1 (Public/Free)** and **Tier 2 (Enterprise/Paid)** separation. Instrument all Enterprise APIs with `recordApiUsage`.
*   **Metering Non-Blocking Rule**: Usage recording for paid APIs MUST be 100% instrumented, but the recording path is asynchronous and never blocks the main response, and a recording failure MUST NOT fail the API itself. A lost log can be recovered by reconciliation; damaged UX cannot. This concerns the billing log and is a separate responsibility from quota enforcement (atomic counting) that stops at the limit; design them apart.
*   **API Latency Budget**: All Public/Enterprise API TTI must be **≤200ms**. Offload heavy processing to async queues, returning `202 Accepted`.
*   **Full-Fetch Triple Check (Summary)**: A change that switches to fetching or exporting all rows (removing `.limit()`, etc.) verifies correctness, ordering stability (a unique column in the final ORDER), and the response size limit at the same time, and returns large results via storage offload plus a signed URL (MUST). See `engineering/700_batch_backfill_operations.md` Rule 700.3.6b for details.
*   **VIP Lane Strategy**: Implement OR condition for "Bearer Token auth" and "API Key auth" for first-party native apps, granting privileged tier to authenticated users.
*   **VIP Lane Supplement (Authentication ≠ Entitlement)**: The OR condition above exists to make identity verification possible without an API Key. The API tier (paid / full-data entitlement) MUST be derived from the contract SSOT (subscription / plan definition), not from authentication state, and a privileged tier MUST NOT be granted merely for being logged in. Authentication (who) and entitlement (what may be used) are separate axes; opening the paid lane on login alone lets free users reach Enterprise data (a defect corrected in a real audit).
*   **Tenant-Aware Naming**: Use `site_` / `account_` prefixes for per-customer resources; `system_` only for cross-tenant immutable infrastructure settings.
*   **Legal Hardcoding Ban**: Hardcoding legal text in source code is prohibited. Enable non-engineers to edit via admin UI.
*   **Operator-Editable Values Ban on Hardcoding**: The above is not limited to legal text. Any value operators are expected to change (listed content, recommendations, ads, display parameters such as reserved heights) lives outside code (DB / settings UI) from the first implementation (MUST). Never hardcode it on the grounds that "we will build the admin screen later" (MUST NOT); it never gets built, and every change consumes engineering resources.
*   **Static Master Protocol**: Centralize app-wide constants in `constants/`. Prohibit in-component hardcoding. Define with `as const` and derive types via `typeof`.
*   **Cross-Layer Key Unification**: An identifying key shared by the admin-side stored value, the display-side branch (switch), and the fetch-side decision (enum / section key, etc.) is imported by every layer from a single constant or enum (MUST). When each layer defines the string independently, a mismatch raises no exception and fails silently as "nothing is displayed" (in practice the admin UI stored `new_reviews` while the display matched only `reviews`). Verify branch exhaustiveness at compile time (an exhaustive check via the `never` type, etc.) and list every place that must change when a key is added (type, branches, fetch decision, default label, admin options) in a comment on the definition file or a checklist (SHOULD).
*   **SSOT Header Mandate**: A constant, type, or function introduced or extended as an SSOT MUST carry, immediately before its definition: (1) what it is the SSOT of (area of responsibility), (2) who references it (who imports it), (3) the update rule (what to synchronize and verify on change). With several SSOTs in one file, write it per definition; generated files are exempt. Before creating a new SSOT, read the scope boundary of existing ones, and when the scope differs, place it as a separate export and type rather than stuffing it into the same export (MUST). Even with the same unit, a different order of magnitude of cost, regulatory impact, or tuning decision-maker means a separate SSOT.
*   **Copies Are Deleted, Not Monitored**: When you find a comment saying "must match" or "X is canonical, update both together", count the field sets and values of both sides right then (MUST). A place where the promise is written is probably already broken; "update together" is a contract that depends on human memory, and drift is always detected after the fact. Do not hand-write the same value into several files; share the actual value by import (MUST), and if a copy genuinely cannot be removed, place a test that compares the field sets by value (MUST). "It is a protected / CRITICAL file, so hands off" is no reason to duplicate; obtaining owner approval and exporting one pure function is safer (SHOULD). When a difference is found, unify on the current live behavior and do not mix in a behavior change (SHOULD).
*   **Non-Importable Output Reconciliation**: Inventory every place where an SSOT value flows into a medium that code cannot import (SQL migration, DB rows, YAML, generated files, settings whose framework demands a literal for static analysis), and for each place add a test that reads the output and checks that it contains or equals the SSOT value (MUST). A transcription is not left as a transcription. Identify the output by a suffix match or similar, never by a variable name such as a timestamp, and fail the check on 0 or 2+ matches (MUST); a hard-coded name slips through silently on rename. When a literal must remain for static-analysis reasons, mark the corresponding SSOT in an adjacent comment and put a verify step in CI that reconciles comment and literal value (SHOULD). For mirror constants generated for another runtime, include the generated output in the same commit and confirm "regenerate → `git status --short` is empty" (MUST).
*   **Threshold & Boundary Literals**: Thresholds shared by display, decisions, and alerts are made an SSOT before the consumers (dashboards, alert engines) are built (MUST); otherwise the UI and the alert judge by different criteria. Embed the unit in the threshold's name or a note (`*_MS`, "ratio 0-1") (SHOULD), and make numeric literals right after a comparison operator (`> 0.15`, `<= 500`) a grep target (SHOULD). Not only explicit-argument calls but also function default parameters, fallbacks when omitted, strict HTTP status comparisons, time-unit conversions (`60_000`), and peripheral boundaries such as sitemap/redirect exclusions and header decisions reference the same SSOT (MUST). "The core is an SSOT but the periphery drifts" is the typical audit miss.
*   **Cross-Layer Constraint Parity (Summary)**: When the same input is validated in several layers (client / server / public API), constraint values such as character limits and numeric ranges, and the error messages, reference a single constant, and the default when unifying is the strictest value (MUST). When layers evolve independently, the loosest layer becomes the effective constraint. See The Cross-Layer Constraint Parity in `engineering/300_web_frontend.md` for details.
*   **Display Metadata Colocation**: Keep display metadata for enums/value sets (labels, descriptions, badge styles, display order) in the same place as the value definitions, leaving only layout on the screen side (SHOULD). Even with DB values made constants, managing display metadata separately per screen makes the name and color of the same state drift between screens. Record the reason for any exception that remains (test expectations, fixed names from external specifications, context-dependent labels).
*   **Responsibility-Separated Identifiers (Summary)**: Identifiers that happen to share a value but carry different responsibilities (DB table names / storage bucket names / schema names) become separate constants and separate types, and boundary helper arguments take responsibility-specific types (MUST). See Responsibility-Separated Identifiers in `core/000_core_mindset.md` §1.31 for details.
*   **Projection-Schema Parity**: Data fetch projections must 100% match physical DB schema. Prohibit "phantom fields" defined in UI/DTO but absent from DB.
*   **Projection-Consumer Parity**: The reverse direction holds too. Before removing a column from a shared projection that feeds several screens (base SELECT / DTO spec), mechanically reconcile the columns referenced by every consumer (MUST). When the DTO is optional, absorbed by `?? null`, and displayed under `value && …`, a missing column vanishes everywhere silently with zero exceptions (in practice every tagline disappeared). Declare display-required columns in the spec, and put a non-null-rate monitor ("null in every row is abnormal") on optional display columns of the `value && <p>{value}</p>` kind (SHOULD). After a projection shape change, verify on the assumption that old-shape cache entries remain until TTL (see `engineering/730_caching_discipline.md`).
*   **Projection-Mapper Two-Key Lock**: A projection expressed as a string (a SELECT column list, a GraphQL selection, an API `fields` parameter) and the mapper that reads its result (the set of `row.x` references) are two independent layers that the type system does not bind together. Verify that their sets match with both human review and mechanical reconciliation (MUST). A mismatch shows up not as an exception but as a silent loss, "undefined → null → 'no data' in the UI", discovered only by user reports in production while lint, type checking, and unit tests are all green (in practice, it stayed latent for months and several tabs lost their display at once). When adding a column, put the three-point simultaneous update "projection + mapper + type definition (generated or extension type)" on the PR checklist (MUST). Do the mechanical reconciliation by enumerating the mapper's `row\.\w+` references and diffing them against the projection's column list, and leave the list of reconciled fields as a docstring on the projection side so reviewers can see differences (SHOULD). For how to sweep when drift is found and for the QA-side check, see Projection-Mapper Two-Key Lock / Drift Sweep Scope in `quality/000_qa_testing.md`.

### 13.10. The Authentication & Access Control
*   **Audit Bypass Anti-Pattern**: Direct client-side DB writes bypass audit logs and violate governance. All data updates must go through Server Actions with `recordAuditLog`.
*   **Authentication Guard Enumeration Consistency**: In RBAC, managing allowed role lists separately across multiple guard functions is **prohibited**. All guards must reference a shared constant array (`ALLOWED_ADMIN_ROLES`).
*   **Dead Zone Detection**: Periodically audit that page-level guards and action-level guards reference the same role set to prevent "can enter page but operations fail" dead locks.
*   **Guard Data-Spec Parity**: The data used for an authorization decision uses the same fetch specification (same column set, same relation joins) in the pre-filter layer (Edge Middleware, global session initialization, route guards) and in the final decision layer (Server Action / API authorization check) (MUST). When only one side uses a generic fetch without relations (`*` equivalent), a legitimate administrator whose privilege lives on the relation side is rejected upstream (a real incident). Define the authorization fetch spec once by name and have every guard reference it (SHOULD); centralizing the allowed-role constant alone is insufficient — the joins the decision needs must match too. Verification: test that the pre-filter layer and the final decision layer agree for both "a user holding the role directly" and "a user holding privilege through a related table" (MUST).

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
*   **Generated Artifact Integrity**: A correction to a generated artifact (seed, generated constants, generated SQL, generated types, generated documentation, etc.) MUST NOT be treated as complete by hand-editing the artifact file. Reflect it in the generator or the generation-plan SSOT, actually run a full regeneration and full application (db reset, etc.), and confirm the diff reproduces; only then is it a fix (MUST). A hand edit disappears silently at the next regeneration, and the artifact diff never shows "the generator is missing it", so partial verification of just the touched spot MUST NOT count as completion. Mark generated files (header comment, path convention, `.gitattributes linguist-generated`, etc.) so hand edits are detectable in review (SHOULD).
*   **Placeholder Discipline**: A verification gate fails by default while a required artifact is still a placeholder or stub (MUST). To tolerate it temporarily, require an explicit exception flag (e.g. `ALLOW_<X>_PLACEHOLDER=1`); silent tolerance without the flag is prohibited (MUST NOT). A change that materializes for the first time an artifact long operated as a placeholder MUST verify by actual runs its interplay with every verification and sync tool that consumes it; the first materialization is where latent gaps surface. AI or automation MUST NOT obtain a production high-privilege secret without authorization; when needed, presuppose the owner's explicit permission or explicit injection via a local env file.

### 13.12. The Migration & Schema Safety
*   **Migration Static Analysis Guard**: Execute **static analysis** on migration files during Push/Merge in CI pipelines, physically rejecting dangerous SQL patterns.
*   **Forbidden Patterns**: `UPDATE` without `WHERE`, `INSERT` without `ON CONFLICT`, `UNIQUE` constraint without cleanup.
*   **Pre-push Hook**: Run local scripts before push to provide immediate feedback on dangerous SQL. `--no-verify` bypass is prohibited.
*   **CI Pipeline**: Maintain `migration:check` job as human error's final defense line.
*   **Untracked Coverage & Checked-List Verification**: A migration / dangerous-SQL guard that runs in local self-verification MUST feed three paths, staged, untracked (`git ls-files --others --exclude-standard`), and the CI diff, deduplicated, into the same check function. A guard that does not see new files before staging returns "no problems" during in-progress self-verification. In the guard's success report, confirm that the files you added were actually listed as checked, and MUST NOT count a green with "zero files checked" as success. Do not settle for covering misses by eye; fix the guard itself to raise its detection power (MUST).
*   **Bypass Side-Effect Parity**: When the manual path for a production data change (console, SQL editor) is blocked by an operational constraint, switch to the established canonical path (migration, repair job) (MUST). Never leave a critical issue open for days waiting for manual access to resume (nine days in practice). When changing data by bypassing the application's save path, reproduce that path's side effects (version stamp, notification, audit log) in the same form and use an idempotency key (the same `source_id`, etc.) so a later application save does not duplicate them (MUST). In a design with two sources of truth for a body (raw HTML is canonical only while the structured data is NULL, etc.), measure which one is canonical before touching it (SHOULD).
*   **Data Provenance**: Data embedded in a migration, setting, or seed to be applied to production MUST NOT be generated from local or staging. A local seed carries columns that differ from production (masked values, connection info, default credentials), and the generated output works fine locally, so the environment gap goes undetected. When embedding is unavoidable, mechanically check the executed SQL or artifact for local-specific values, reading the values to check from the real seed (MUST). Before writing a data migration, ask whether the data really needs embedding, and prefer a lazy-generation path on the application side when one exists (SHOULD).

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
    *   **Event-Ready Audit Log**: Give audit logs / change histories, in addition to table name and row ID, the aggregate type, aggregate ID, event name (`{aggregate}.{past-tense verb}`, e.g., `order.completed`), event schema version, and before/after diff, at a granularity that can later be promoted to CDC / an event store (SHOULD). Keep the log append-only and use the event ID as a unique key to prevent duplicate processing (MUST). Adopting Event Sourcing itself is not required; decide with measurable indicators such as write volume, complexity of state transitions, and point-in-time reconstruction requirements (SHOULD). Trying to turn the log into events later and finding the granularity insufficient is the typical failure of the growth phase.

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
*   **Intra-App Sender/Receiver Key Reconciliation**: Not only at service boundaries but also within an app, between form → action → schema, mechanically reconcile the set of keys the receiver's type/schema requires against the set of keys the sender actually builds (MUST). If the sender never sends a key the receiving schema requires, that path fails 100% of the time, yet tests stay green because they build their own payloads. Decide "required" not by reading the validator's internals but by "whether it actually lets `undefined` through", and go red if the difference set is non-empty.
    *   **No Bulk Argument Cast**: Call arguments MUST NOT be bulk-cast with `as <receiver's argument type>`. Extra keys the sender sends are silently dropped, and nothing is saved while success is displayed (in practice, edit → save showed a success toast while nothing at all was reflected in the DB). Annotate arguments with the receiver's type (`const args: Params = {…}`) to expose mismatches to the compiler, and limit local casts to the single field that needs the type.
    *   **Defaults & Sibling Fields**: Give fields that may take a default a default value, and if you make one required, pin with a check that it actually exists on the sender side (SHOULD). After fixing a missed copy of one field, inspect in the same change the sibling fields that pass through the same form × the same cast structure (MUST). For the QA-side summary, see Sender/Receiver Key Reconciliation in `quality/000_qa_testing.md`.

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
*   **Observation Prerequisites**: Base a removal on unused-index advice (`idx_scan = 0` and the like) only on statistics gathered over a sufficient observation window (including seasonality and batch cycles) at production-equivalent data volume and traffic (MUST). Never remove on statistics from early development, small data, or an environment production traffic has not reached (MUST NOT); the advisor sees only "now" and invites dropping FK or search indexes. Reconcile each candidate with its creation reason (expected queries, FKs, future search requirements), keep it regardless of statistics while the reason holds, remove online, and prepare the re-creation procedure as the rollback (SHOULD).

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
*   **Order Dependence of Privilege Contraction**: Where DB and application deployments run in parallel, evaluate a privilege-narrowing change (REVOKE / tightening row-level control) as one that necessarily opens a window of "new privileges + old application code", and ask whether legitimate writes fail inside that window (MUST). If they would, prefer forcing the value to a server-side default (trigger / server default) over REVOKE (SHOULD): writes keep succeeding, only the attacker-supplied value is discarded, and nothing depends on deployment order. The forced value falls to the safe side (moderation required, minimum tier); never choose a default that falls toward over-grant (MUST). An operation with no legitimate user path has no ordering problem and may simply be revoked; REVOKE and override are chosen per path, not opposed. A fix protected only by an operational promise such as "deploy the app before merging" is itself a new hazard.
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
*   **Harm of Omitting `type`**: Give every `<button>` an explicit `type="button" | "submit" | "reset"` (MUST), with no exception outside forms: the moment it is later wrapped in a `<form>`, the default `submit` fires. Elements rendered through wrapper UI components (`<Button>`), such as rich-editor toolbars and accordions drawn inside a form, are included. The real harm is "every toolbar click submits the form and runs the save plus side-effect batches" while the UI looks normal. Default lint does not detect a missing `type`, so fix `type=` as required for `<button` / `<Button` under the directory in a contract test (SHOULD), with a scan that does not mistake `=>` inside an attribute for a closed tag. Detect by capturing submit events (identifying the submitter) and by checking whether `updated_at` moves without the save button being pressed.

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
*   **Published Schema Constraint Parity**: An externally published schema (JSON Schema / OpenAPI / tool definitions, etc.) MUST declare independently the same constraints as internal validation (both `pattern` and `maxLength`, etc.). The canonical rule is "Rule 740.8.5" in `engineering/740_data_contracts.md`.

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
*   **Rule Crystallization Link**: List recurrence-prevention measures along three axes, technical (types, tests, monitoring) / process (procedures, review) / human factors (expressed as a lack of documentation or automation), without leaning on a single axis (SHOULD). Extract generalizable rules from PIR lessons and append them to rule files, and leave in the lessons log a cross-reference between the incident identifier and the location of the rule appended (SHOULD). Actions limited to technical measures recur through the same procedural gap, and when lessons and rules cannot be traced to each other the rationale is lost at the next revision.

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
*   **Audit Output Interpretation**: A dependency audit tool's "fix available" flag (`npm audit`, `pip-audit`, etc.) and automatic fix proposals (`npm audit fix`, bot PRs) are constraint solutions that say nothing about production impact or destructiveness. Before acting, judge resolvability by both whether the proposal is a major bump and whether the proposed version moves forward or backward (a downgrade) (MUST); a major-downgrade proposal is a danger signal and MUST NOT be applied as is (in practice a proposal would have moved the framework back seven generations). Judge a dry run by the residual count at the end, not the "add" lines at the top. "Upgrading to latest fixes it" does not always hold: query the registry for the range declared by the latest version of every requester on the path and prove "upstream has not fixed it" before concluding "cannot fix" (MUST). Bump a direct dependency explicitly to the fixed version; fix a transitive one surgically with a minimal floor via `overrides` / `resolutions` (SHOULD), and before forcing, measure the target package's module shape (is the export callable or an object, etc.) with `require()` (MUST). Re-audit the remainder on production dependencies only (dev excluded), classify by reachability, and report it (MUST); after fixing, confirm both that the dependency tree holds the safe version on every chain and that the scanner reports zero (MUST). Write a security-motivated override as a declarative floor outside the vulnerable range so the file shows which advisory it guards against (SHOULD).
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
