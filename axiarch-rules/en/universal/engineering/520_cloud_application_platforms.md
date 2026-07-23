# 520. Cloud and Application Platform Governance

> [!CAUTION]
> This file is a Universal Rule (immutable). Do not edit it without an explicit instruction to amend the constitution.
> Last updated: 2026-07-23

> [!IMPORTANT]
> Primary directive: a platform buys delivery velocity; it does not transfer accountability for responsibility, data, availability, cost, or exit. Compare Vercel, Supabase, Firebase, Cloudflare, hyperscalers, container PaaS, and self-hosted platforms through the same outcome contract. A vendor dashboard is never the only Universal implementation.
> 22 sections, Rules 520.1–520.89.

---

## Table of Contents

| Section | Topic |
|:--|:--|
| §1 | Scope and Universal applicability contract |
| §2 | Platform portfolio and adoption decision |
| §3 | Shared responsibility and control planes |
| §4 | Organization, account, and team governance |
| §5 | Environment isolation and promotion |
| §6 | Artifact, deployment, and rollback |
| §7 | Identity, secrets, and configuration |
| §8 | Data, state, migrations, and backups |
| §9 | Runtime, network, edge, and cache |
| §10 | Security, privacy, and supply chain |
| §11 | Observability, SLOs, and incidents |
| §12 | FinOps, quotas, and capacity |
| §13 | Portability, exit, and DR |
| §14 | Major platform profiles |
| §15 | Team use and Platform Engineering |
| §16 | CI gates, exceptions, and maturity |
| §17 | SDK and client-interface lifecycle |
| §18 | Managed async and event delivery contract |
| §19 | Local and emulator to managed-environment conformance |
| §20 | Provider-managed integration and extension lifecycle |
| §21 | Multi-service application composition and aggregate release |
| §22 | BaaS capability and identity-portability governance |
| Appendix A | Reverse index, cross-references, and primary sources |

---

## §1. Scope and Universal Applicability Contract

- Rule 520.1: This file governs the selection and cross-cutting control of managed hosting, frontend platforms, BaaS, serverless, edge runtimes, container PaaS, hyperscalers, Kubernetes, and self-hosted application platforms.
- Rule 520.2: Domain-specific authorities govern databases, identity, mobile, web, SRE, FinOps, and security. This file connects their responsibility boundaries, promotion, evidence, and exit requirements across platforms.
- Rule 520.3: Vendor names, plan names, role names, dashboards, CLIs, fixed limits, prices, regions, and preview features are reference implementations or point-in-time facts. Reverify official documentation, contracts, and effective account settings at adoption and material change boundaries.
- Rule 520.4: Universal requirements are safety, reproducibility, traceability, ownership, recoverability, cost boundaries, and data portability. Provider, team size, environment count, approval stages, SLOs, and budget thresholds are risk-based Blueprint parameters.

### 1.1 Interpretation Layers

| Layer | Normative status | Examples |
|:--|:--|:--|
| invariant outcome | required | least privilege, reviewable change, restore, rollback, cost attribution |
| capability contract | required when used | outcomes for previews, WAF, branches, queues, or stateful primitives |
| provider profile | conditional | mappings to current Vercel, Supabase, Firebase, or Cloudflare capabilities |
| Blueprint parameter | project-specific | plan, region, quota, budget, owner, SLO, retention |

## §2. Platform Portfolio and Adoption Decision

- Rule 520.5: Inventory platforms by capability: web hosting, application compute, data and auth, edge and network, async and events, and observability. Both single-provider and multi-provider systems are valid.
- Rule 520.6: An adoption ADR records workload, data classification, latency, regional availability, runtime compatibility, operational burden, team capability, support, compliance, unit economics, and exit cost.
- Rule 520.7: Do not select a production platform solely for a free tier, initial speed, popularity, or framework auto-detection. Compare steady-state and abuse or spike cost, quota behavior, and the impact of enforced suspension.
- Rule 520.8: Duplicating a capability across providers requires an availability, regulatory, migration, or acquisition purpose plus a complexity budget, owner, and exit condition for the dual operation.

### 2.1 Capability Evaluation

| Axis | Required question | Evidence examples |
|:--|:--|:--|
| workload fit | Does it fit request, batch, stream, state, GPU, and background work? | benchmark, limit inventory, ADR |
| control | Are IAM, network, encryption, audit, and policy available at the required granularity? | responsibility matrix, policy export |
| delivery | Can preview, promotion, canary, rollback, and migrations be separated? | pipeline, deployment record |
| operation | Are SLIs, logs, traces, status, support, and incident export available? | reproducible queries, runbook |
| economics | Can the team explain unit cost, quota, egress, build, logs, seats, and add-ons? | cost model, budget action |
| exit | Can code, data, identity, domains, secrets, and telemetry move? | exit rehearsal, export test |

## §3. Shared Responsibility and Control Planes

- Rule 520.9: Separate provider-managed infrastructure, runtime, and control plane from customer-managed code, data, identity, configuration, and business continuity in a responsibility matrix. Managed never means unaccountable.
- Rule 520.10: Treat the control, data, build, and observability planes as distinct trust boundaries and define identity, network path, logging, and break-glass access for each.
- Rule 520.11: Dashboard-mutable settings still require a configuration source, owner, review, and drift detection. If an official API or IaC cannot represent a setting, record before and after state, actor, rationale, and expiry.
- Rule 520.12: Register provider status, quota, support, billing, certificate, DNS, and identity-provider dependencies with failure and degraded-mode behavior.

## §4. Organization, Account, and Team Governance

- Rule 520.13: Production resources belong to a durable organization, team, folder, subscription, account, or equivalent ownership boundary rather than a personal account.
- Rule 520.14: Separate roles by job function and environment. Do not trust provider role names alone; verify effective permissions, including whether a read-only role can view secret metadata or values.
- Rule 520.15: Production deploys, secret access, billing changes, domain transfer, log export, project deletion, and backup restore are sensitive operations requiring risk-based step-up, independent approval, notification, and immutable audit.
- Rule 520.16: Manage joiners, movers, leavers, SSO, SCIM or equivalent provisioning, service identities, external contributors, and support access in one lifecycle that detects orphan accounts and shared credentials.

## §5. Environment Isolation and Promotion

- Rule 520.17: Isolate local, preview, test, staging, and production according to risk. Verify credential, data, domain, quota, billing, access, and blast-radius separation rather than mandating environment names or counts.
- Rule 520.18: Do not leave preview environments publicly unauthenticated. Do not indiscriminately copy production data, secrets, OAuth callbacks, webhooks, outbound email, search indexes, or analytics into previews.
- Rule 520.19: Bind configuration, schema, runtime, build, routing, firewall, and feature flags to the same revision and promotion record. Declare environment differences with typed configuration and policy.
- Rule 520.20: Promote the same validated artifact or version without rebuilding when the platform supports it. When rebuilding is unavoidable, verify source, dependencies, builder, and configuration differences with provenance.

## §6. Artifact, Deployment, and Rollback

- Rule 520.21: Link source revision, resolved dependencies, builder, runtime, configuration, artifact digest, deployment ID, actor, environment, and timestamp in release evidence. For managed runtimes, associate the observable provider runtime build, base image, buildpack or adapter, and update mode with the executing revision rather than recording only the declared runtime identifier.
- Rule 520.22: When upload or build can be separated from traffic activation, progressively promote only versions that passed smoke, security, contract, and migration-compatibility gates. Otherwise provide equivalent preview and immediate reversal.
- Rule 520.23: A code rollback does not revert databases, queues, object storage, KV, caches, Durable Objects, or external side effects. Runbooks cover state compatibility, forward fix, cache purge, replay, and compensation.
- Rule 520.24: Gradual deployment creates version skew. Keep APIs, events, sessions, cache keys, and state schemas N/N-1 compatible; use affinity or version overrides only as mechanisms for required consistency.

## §7. Identity, Secrets, and Configuration

- Rule 520.25: Use separate identities for people, CI, runtime, provider integrations, and support. Prefer OIDC or workload identity and short-lived credentials where supported.
- Rule 520.26: Inventory public client keys, publishable keys, secret keys, service roles, and admin credentials. Never decide browser safety from naming alone.
- Rule 520.27: Inject secrets at the smallest environment and service scope. Keep them out of source, preview comments, build logs, artifacts, client bundles, and telemetry; audit read, update, and revocation.
- Rule 520.28: Configuration schemas fail closed for unknown, missing, or environment-inconsistent values. Verify secret rotation, provider key migration, and certificate updates without downtime using dual-read or dual-key patterns where appropriate.

## §8. Data, State, Migrations, and Backups

- Rule 520.29: Declare systems of record for authoritative data, caches, derived views, file objects, identity records, analytics, and configuration. Do not create accidental dual authorities across providers.
- Rule 520.30: Apply schema and data changes through version-controlled migrations or approved runbooks, with expand-contract compatibility, privacy-safe seeds, synthetic preview data, and drift detection.
- Rule 520.31: Provider branches, preview databases, and emulators do not copy production data by default. Choose data-less environments, synthetic seeds, or masked subsets from privacy and test-realism requirements.
- Rule 520.32: A provider backup is not proof of DR. Restore-test resource coverage, retention, encryption, deletion behavior, account loss, regional failure, off-platform copies, recovery time, and integrity.

## §9. Runtime, Network, Edge, and Cache

- Rule 520.33: Record the declared language and runtime identifier, provider-managed patch or build, base OS or image, framework adapter or buildpack, compatibility date or flags, region, CPU, memory, duration, concurrency, connection, subrequest, bundle, payload, and other effective contracts in a machine-readable inventory, then monitor official changes and effective drift.
- Rule 520.34: Select edge, serverless, containers, VMs, or Kubernetes using state, library compatibility, connection model, background execution, cold start, debugging, cost, and data gravity—not latency alone.
- Rule 520.35: Prefer provider-internal bindings, private networks, and service discovery over public Internet paths when available, without skipping authentication and authorization. Govern outbound destinations, SSRF, egress, DNS, and TLS.
- Rule 520.36: Contract cache keys, tenant, auth, locale, version, privacy, purge, and stale behavior. Never assume deploy or rollback invalidates stateful caches; test cross-version behavior.

## §10. Security, Privacy, and Supply Chain

- Rule 520.37: WAF, DDoS mitigation, bot controls, App Check, and deployment protection are defense in depth. They do not replace application authorization, rate limiting, input validation, or abuse detection.
- Rule 520.38: Treat build integrations, marketplace apps, Git providers, deploy hooks, MCP, CLIs, and support tools as third-party principals. Review scope, installer, updates, retention, and revocation; §20 defines their complete lifecycle contract.
- Rule 520.39: Builds and deployments use pinned toolchains, locked dependencies, SCA, SBOM, secret scanning, and artifact provenance. Provider-generated artifacts remain traceable to source revision and final digest.
- Rule 520.40: Verify data residency, subprocessors, support access, telemetry retention, backup location, and AI data use from contracts and effective settings. A marketing region name is not proof of legal conformity.

## §11. Observability, SLOs, and Incidents

- Rule 520.41: Correlate requests, builds, deployments, control-plane changes, billing, and security events with IDs and timestamps, and keep logs, metrics, traces, and audit data exportable or queryable.
- Rule 520.42: Define user-journey and business-outcome SLIs in addition to platform metrics. Provider uptime does not substitute for an application SLO.
- Rule 520.43: Design sampling, retention, cardinality, PII scrubbing, and telemetry cost while preserving incident evidence. Console output volume is not observability maturity.
- Rule 520.44: Maintain and exercise runbooks for provider status, support escalation, traffic shift, feature degradation, credential revocation, evidence preservation, and customer communication.

## §12. FinOps, Quotas, and Capacity

- Rule 520.45: Attribute requests, compute, duration, memory, storage, operations, egress, builds, logs, traces, seats, domains, support, and add-ons to service, environment, and owner.
- Rule 520.46: Budget alerts, spend caps, automatic pauses, and quotas are different controls. Verify uncovered usage, delay, fail-open or fail-closed behavior, and customer impact such as 503 responses; never depend on one control.
- Rule 520.47: Detect loops, retry storms, cache misses, log explosions, abuse, preview leaks, abandoned branches, and unbounded fan-out as cost incidents; set safe rate, concurrency, instance, queue, and retention bounds.
- Rule 520.48: Automatic scaling is not unlimited capacity. Validate quotas, connections, hot keys, regional capacity, support lead time, and cost ceilings through load tests and forecasts.

## §13. Portability, Exit, and DR

- Rule 520.49: Portability does not mean rejecting every vendor capability. Use managed differentiation deliberately while designing exit boundaries for data, domains, identity, protocols, artifacts, and telemetry.
- Rule 520.50: Exit plans include export format, volume, duration, egress cost, encryption keys, DNS, certificates, OAuth, webhooks, queues, scheduled jobs, validation, parallel run, and rollback.
- Rule 520.51: Classify provider, account, region, and control-plane failure for critical workloads and choose the business-required recovery through another provider, degraded static paths, queue buffering, or manual operation.
- Rule 520.52: Do not mandate annual provider migration exercises universally. Define triggers such as API deprecation, pricing change, support failure, acquisition, regulation, or capacity shortage and a risk-based export and restore rehearsal cadence.

## §14. Major Platform Profiles

- Rule 520.53: Treat Vercel as a full-stack web, preview, managed build and deployment, functions, and edge or CDN profile. Separate roles and environments, protect previews, promote validated deployments, and distinguish code rollback from external state changes. Do not confuse runtime OIDC with CLI or CI deployment authentication; use the provider-supported least-privilege credential for each path. Spend Management notification, webhook, and pause behavior is not an immediate hard cap for every charge.
- Rule 520.54: Treat Supabase as a PostgreSQL, Auth, Storage, Realtime, and Edge Functions profile. Verify exposed-schema grants separately from RLS; account for branch-specific credentials, data-less defaults, migrations and config, backup and PITR, and spend-cap exclusions.
- Rule 520.55: Treat Firebase and GCP as a mobile and web SDK, Auth, Security Rules, App Check, Firestore or Data Connect, Hosting or App Hosting, Cloud Run, and events profile. App Check does not replace user authentication or authorization; test client Security Rules and server IAM boundaries. Choose paid plans only when required capabilities need them, and never treat budget alerts as hard caps.
- Rule 520.56: Treat Cloudflare as a DNS, CDN, WAF, Zero Trust, Workers, KV, R2, D1, Durable Objects, and Queues edge platform profile. Worker versions do not version related state, so validate gradual version skew, binding and migration compatibility, rollback, and cache invalidation separately.

### 14.1 Complementary Profiles

| Profile | Representative examples | Additional responsibilities |
|:--|:--|:--|
| hyperscaler | AWS, Azure, Google Cloud | organization hierarchy, landing zone, IAM, network, region, quotas, IaC, shared responsibility |
| enterprise, regional, and sovereign cloud | Oracle Cloud Infrastructure, IBM Cloud, Alibaba Cloud, Tencent Cloud, OVHcloud, and similar providers | jurisdiction, data residency and sovereignty, organization and account hierarchy, IAM federation, managed-runtime or container contract, interconnect and egress, support, marketplace, exit |
| frontend and web platform | Vercel, Netlify, Cloudflare | build provenance, preview protection, cache, edge runtime, domain, promotion |
| BaaS and data platform | Supabase, Firebase, AWS Amplify, Appwrite, Convex, managed databases, and equivalents | per-capability schema, RLS or Rules or IAM, backups, identity and data portability, connections, egress |
| container PaaS | Cloud Run, Azure Container Apps, AWS App Runner, DigitalOcean App Platform, Render, Railway, Fly.io, Heroku | image, health, scale-to-zero, volume, network, jobs, region, rollback |
| orchestrated or self-hosted | Kubernetes, Nomad, VMs, internal platforms | control plane, patching, capacity, backup, on-call, supply chain, upgrades |

### 14.2 Interpreting Language and Runtime Surfaces

Do not say that a platform “supports language X” without distinguishing client SDKs, build inputs, first-class execution runtimes, community runtimes, containers, and Wasm compilation targets. For adoption, inventory provider support, maturity, EOL, deployment unit, effective limits, debugging and observability, artifact provenance, SBOM, and rollback for each surface separately.

| Platform profile | Surfaces to distinguish |
|:--|:--|
| Vercel | Separate current official Function runtimes, community runtimes, Edge runtime, Wasm, and polyglot service capabilities. Availability does not promote a beta or experimental capability to Standard |
| Supabase | Separate PostgreSQL and SQL, the Deno-compatible Edge Functions runtime, client SDK languages, and community clients |
| Firebase and GCP | Separate mobile and web client SDKs, Functions runtimes, Cloud Run container languages, and event sources |
| Cloudflare | Separate first-class Workers languages, bindings into JavaScript APIs, and Wasm compilation paths. Verify in CI that runtime types generated from compatibility date, flags, and bindings match the effective artifact |
| hyperscaler FaaS | For AWS Lambda, Azure Functions, and similar platforms, separate managed language runtimes, worker models, OS-only or custom handlers, and container images; verify support level, EOL, patch responsibility, and runtime update mode for each |
| frontend and edge platform | For Netlify and similar platforms, separate build inputs, standard functions, edge runtimes, and framework adapters. Do not assume identical APIs, packages, durations, regions, or rollback contracts merely because each surface uses TypeScript or JavaScript |
| container PaaS | For Cloud Run, Render, Railway, and similar platforms, separate native or auto-detected builds, buildpacks, source-to-image paths, and supplied containers. “Any language can run in a container” is not equivalent to first-class language support |

As of 2026-07-23, the [official Vercel Functions Runtimes documentation](https://vercel.com/docs/functions/runtimes) classifies Node.js, Bun, Python, Rust, Go, Ruby, Wasm, and Edge as official runtimes, and Bash, Deno, and PHP as recommended community runtimes. Do not interpret this as one language-support table for all of Vercel. Verify release channel, APIs, filesystem, streaming, duration, regions, failover, isolation, observability, build artifacts, and support authority for each runtime separately. For a community runtime or Runtime API or Build Output API path, add publisher continuity, security advisories, artifact provenance, rollback, and an owner for failures outside provider support.

As of 2026-07-23, the [official current Vercel Services guide](https://vercel.com/kb/guide/vercel-services) declares multiple services through the top-level `services` property, keeps services internal by default, exposes them through explicit top-level routing or rewrites, and uses bindings for service-to-service communication. This is a time-bound implementation profile that maps Rules 520.80–520.83 to Vercel, not a Universal configuration format. Do not mechanically carry legacy `experimentalServices` examples into a current project. At adoption or migration, revalidate the official configuration schema, release channel, public routes, bindings, and custom-runtime support, and retain the effective configuration and managed smoke evidence.

As of 2026-07-23, the [official Cloudflare Workers Languages documentation](https://developers.cloudflare.com/workers/languages/) lists JavaScript, TypeScript, Python, and Rust as first-class language surfaces, while the language-specific [Python Workers documentation](https://developers.cloudflare.com/workers/languages/python/) still marks Python as open beta and requires a compatibility flag. Therefore, do not collapse a first-class integration surface and release maturity into one axis; prefer the language-specific documentation. Distinguish other languages including C, C++, Kotlin, and Go through WebAssembly paths, and verify effective support status, binding bridges, standard-library and package behavior, cold start, debugging, observability, security updates, and rollback for the workload.

Compilation to Wasm does not mean the platform provides first-class support for the source language's full standard library, threads, filesystem, sockets, debugging, performance, or security model. A support matrix includes capability, support authority, maturity, deployment unit, constraints, and verification evidence; marketing language counts are not a maturity metric.

A managed runtime may change without a source revision or application-artifact change. At adoption, inventory the update mode—automatic, deployment-coupled, manual pin, container rebuild, or an equivalent model—together with security-patch responsibility, staged rollout, region or architecture variation, the mechanism for observing effective runtime identity, and rollback behavior. Use a provider-recommended supported automatic-update mode as the normal secure default. Treat manual pinning or update suspension as temporary compatibility mitigation with an owner, expiry, patch gap, and revalidation condition. For supplied containers or base images, do not expect provider-managed runtime patching; the adopter owns rebuild, scan, and redeployment. A runtime, buildpack, adapter, or base-image change event triggers risk-based smoke, contract, performance, security, and observability verification even when source is unchanged.

## §15. Team Use and Platform Engineering

- Rule 520.57: Assign accountability for platform ownership, security, billing, operations, data, and developer enablement at every team size. One person or small team may combine duties but still needs a continuity route.
- Rule 520.58: A Golden Path makes project creation, identity, environments, secrets, domains, observability, budgets, deploy, rollback, and decommission reproducible while retaining an escape hatch and expiry for exceptions.
- Rule 520.59: Do not mandate a central platform team for every organization. Multi-team or high-assurance environments progressively establish self-service, policy as code, usage analytics, and support SLOs as Platform Engineering capabilities.
- Rule 520.60: Do not isolate provider-console knowledge in a few people. Keep runbooks, ownership, architecture decisions, cost models, incident records, and access recovery searchable and transferable.

## §16. CI Gates, Exceptions, and Maturity

- Rule 520.61: Platform-change CI applies relevant configuration-schema, IaC validation, policy, secret, dependency, SBOM, build, contract, migration, provider runtime or buildpack or base-image drift, preview smoke, security, cost-diff, and rollback-readiness gates.
- Rule 520.62: A pre-deployment Evidence Packet includes source, artifact, environment diff, data impact, observability, cost impact, owner, approval, rollback, and known limitations.
- Rule 520.63: A provider limitation becomes an exception with risk, scope, compensating control, owner, expiry, and exit trigger. A plan upgrade is not the only valid resolution.
- Rule 520.64: Measure maturity by L1 manual and person-dependent, L2 reproducible build, L3 policy and promotion, L4 integrated SLO, FinOps, and security, and L5 verified self-service, DR, and exit outcomes—not by provider count.

## §17. SDK and Client-Interface Lifecycle

- Rule 520.65: Do not certify platform language support merely because a package exists. For each language, platform, and service, distinguish official, community, generated-client, direct-protocol, and runtime-bundled SDK surfaces, and record support authority, maturity, API coverage, version compatibility, release and security updates, EOL, license, and authentication model in a machine-readable inventory.
- Rule 520.66: Do not assume feature parity across SDKs. Define required capabilities and positive and negative contract tests per language for Auth, data queries and transactions, Realtime or streaming, Storage, Functions or events, local emulation, schema or type generation, retries and pagination, and telemetry. Do not confuse public credentials and Rules or RLS boundaries in client SDKs with workload identity and IAM boundaries in server or admin SDKs.
- Rule 520.67: When generating a client from a schema or API, pin the schema digest, generator, template, runtime, and generated artifact, and prohibit manual edits. Validate version skew among the platform API, SDK, generated client, and consumer with compatibility tests, and manage deprecated APIs or SDK major-version migrations with an owner, expiry, and rollback.
- Rule 520.68: Production use of a community SDK or an unsupported language records maintainer continuity, security-advisory path, release lag, missing capabilities, and provider-support scope in a risk acceptance, and retains a viable fallback through a public protocol such as REST or gRPC, an internal adapter, or a service using another official SDK. A shared wrapper must not hide authentication, retry, error, or pagination differences and create a second unofficial platform API; keep it to the smallest stable boundary backed by contract tests.

## §18. Managed Async and Event Delivery Contract

- Rule 520.69: For every queue, topic, stream, event trigger, and scheduled or durable workflow, record at-most-once, at-least-once, exactly-once, or another delivery mode from producer through each consumer to final side effects, acknowledgment, lease or visibility timeout, ordering scope and partition key, retry, backoff and retention, batching and partial failure, payload and serialization, concurrency and backpressure, rates and quotas, and region or residency in a machine-readable contract. Never infer an end-to-end guarantee from provider labels such as “guaranteed,” “exactly once,” or “ordered”; verify scope, preconditions, and invalidation conditions against official specifications and tests.
- Rule 520.70: Unless proven end to end, assume duplicate delivery, redelivery, out-of-order arrival, and concurrent processing. Consumers derive idempotency keys from stable business identities and protect claims together with state transitions or side effects using an appropriate atomic boundary such as a transaction, inbox or outbox, conditional write, or deduplication store. Producer-side deduplication, broker-local exactly-once behavior, or unique message IDs do not prove that downstream payments, emails, external APIs, or multiple data stores execute exactly once.
- Rule 520.71: Restrict retries to classified transient failures, and bound attempts or event age, exponential backoff with jitter, timeouts, cancellation, concurrency, and cost ceilings. Move permanent failures, invalid schemas, expired work, and poison messages to a DLQ or equivalent quarantine; when a provider lacks a built-in DLQ, implement application-level quarantine that preserves the required payload and failure metadata. Treat inspection, discard, redrive, and replay as sensitive operations requiring authorization, PII protection, audit, dry-run or target preview, idempotency, rate and cost limits, a stop mechanism, and execution evidence.
- Rule 520.72: `engineering/740_data_contracts.md` is canonical for event-payload schema, ownership, compatibility, deprecation, and data classification. The platform delivery envelope defines a stable event ID, event type, schema version, producer, occurred and published times, correlation and causation, trace context, tenant or subject when applicable, and a minimized payload, then tests historical, duplicate, out-of-order, delayed, unknown-field or type, malformed, and partial-batch cases through contract and replay tests. Operations connect backlog depth and age, delivery attempts, acknowledgment or lease failures, retries, DLQ or quarantine, end-to-end latency, loss or deduplication anomalies, fan-out, and cost per event to owners and SLOs or alerts, with runbooks for draining, replay, rollback, and provider exit.

## §19. Local and Emulator to Managed-Environment Conformance

- Rule 520.73: For every material platform capability used in production, classify the required verification surfaces—test doubles, local processes or containers, provider emulators, local runtimes with remote bindings, managed previews, sandboxes or staging, production canaries, or equivalents—and record in a machine-readable fidelity matrix which execution runtime, APIs, identities, networks, regions, quotas, concurrency, timers, caches, events, control-plane behavior, and billing semantics each surface reproduces or does not reproduce. Local or emulator success is not proof of equivalence for managed IAM, service configuration, quotas, regional behavior, provider integrations, performance, or security. A capability with no managed-semantics dependency may mark managed testing not applicable with recorded rationale.
- Rule 520.74: Bind each fidelity profile to the source revision, CLI, emulator or local runtime, SDK or adapter, service API, configuration or compatibility settings, schema or generated bindings, target environment, and verification result. Provider, runtime, toolchain, SDK, binding support, quota, default, or security-policy change events trigger reevaluation of affected profiles and contract tests or equivalent evidence that local fixtures and mocks have not drifted from the current managed contract.
- Rule 520.75: Before production, verify material behavior that local surfaces cannot faithfully reproduce in the lowest-cost safe provider-managed isolated environment or an equivalent high-fidelity surface according to risk. Relevant checks include positive and negative authorization, effective configuration, runtime limits, networks and regions, callbacks and events, storage and data isolation, concurrency, retries, clocks and caches, observability, quotas, and cost. Remote resources and ephemeral managed environments do not use production data or credentials by default and have isolated identities, synthetic or appropriately protected data, least privilege, an owner, source revision, a TTL or explicit retention and cleanup trigger, cost attribution, and cleanup or destruction evidence. If required managed verification is unavailable, release evidence records the unverified differences, residual risk, compensating controls, staged rollout, kill switch, and reevaluation trigger.

## §20. Provider-Managed Integration and Extension Lifecycle

- Rule 520.76: Inventory every material provider-managed integration—marketplace app, extension, plugin, connector, binding, managed add-on, or equivalent—by publisher and support authority, maturity, approved source, effective version or release channel, license and terms, data flow and subprocessors, created or shared resources, APIs, scopes and effective permissions, installer and runtime identities, secrets and environment targets, webhooks and network paths, region and retention, billing unit and payer, accountable owner, dependents, and exit route. Classify separately the code package, control-plane principal, managed resource, configuration binding, and commercial subscription that exist; a package SBOM alone does not cover this lifecycle.
- Rule 520.77: Treat install, update, reconfiguration, plan change, permission expansion, publisher transfer, and environment attachment as privileged supply-chain and control-plane changes. Use an approved reviewable manifest, IaC, API or equivalent source where the provider supports it; otherwise preserve before and after state. Require least privilege, separate identities and environment or tenant isolation, an install actor, an effective permission diff, configuration and secret-target diff, price and terms impact, positive and negative authorization, and risk-based independent approval and staged validation. Do not automatically approve new scopes, resources, data destinations, terms, prices, or version channels, and detect console or provider-side drift from the approved state.
- Rule 520.78: Operate integrations with health, audit, dependency, quota, unit-cost, budget, retry or queue, provider-status, deprecation, and support signals tied to an owner and degraded-mode runbook. Detect disabled integrations, departed or deprovisioned installers, orphaned identities, credential and webhook expiry, permission or version drift, and upstream lifecycle events; rotate credentials and exercise a kill switch or safe bypass where risk requires it. Verify deployment and runtime behavior when an integration, secret, environment variable, binding, drain, or managed resource becomes unavailable or is removed.
- Rule 520.79: Decommission through an impact graph that distinguishes provider-owned resources from customer data, generated artifacts, shared databases or buckets, identities, secrets, environment variables, webhooks, drains, callbacks, DNS, branches, retained copies, and billing. Define export, retention, deletion and privacy obligations, stop new writes, preserve rollback or parallel-run capability when required, revoke access, uninstall, clean residual resources, run an orphan scan, confirm billing cessation and dependency health, and retain cleanup evidence. An uninstall or disconnected label is not proof that data, access, cost, or dependents were removed.

## §21. Multi-Service Application Composition and Aggregate Release

- Rule 520.80: When multiple deployable units compose one product or user journey, maintain a machine-readable service graph regardless of repository shape or provider project count. Record each unit's stable ID, accountable owner, language or runtime and support status, source and build root, artifact or deployment unit, public routes and internal endpoints, upstream and downstream contracts, identities, secret references and configuration metadata without secret values, authoritative data and state, region, SLOs, cost attribution, and decommission dependencies. Do not automatically interpret a monorepo as one deployment, a shared domain as one failure boundary, or multiple directories as microservices.
- Rule 520.81: Declare the application's release topology as independent, coordinated, aggregate, or an explicit combination, and bind the target source revision, each unit's artifact digest or deployment ID, runtime, effective configuration, routes, service discovery and bindings, schemas and migrations, and feature state into an aggregate release record or equivalently queryable evidence. A provider's aggregate-deploy label is not proof that builds, activation, traffic cutover, and state changes are atomic. Detect partial builds or deployments, missing dependencies, stale bindings, route overlaps, reserved paths, base-path conflicts, and drift in preview URLs or generated endpoints through preflight and managed-environment smoke tests.
- Rule 520.82: Evolve cross-unit changes through consumer-driven contracts, N and N-1 or another declared compatibility window, expand-contract, and safe ordering such as additive producer → compatible consumer → cleanup. Express ordering dependencies as pipeline gates rather than hiding them, and define the scope in which pause, rollback, roll forward, traffic shift, feature disablement, and data compensation work for each unit and for the application. Never assume that rolling back one unit, routing rule, or platform deployment also reverts other units, databases, queues, caches, or external side effects.
- Rule 520.83: CI derives native gates, cross-language contracts, route, binding and identity policy checks, integration tests, and end-to-end journeys from the change-impact graph. Revalidate every dependent for cross-cutting changes such as shared contracts, base images, toolchains, and platform configuration; path filters alone are not proof of safety. Operations correlates unit-level and application-level health, traces, SLOs, security signals, quotas, unit cost, and deployment status, and includes owner changes, access lifecycle, partial-outage runbooks, rollback and restore exercises, and service addition, consolidation, and retirement in the same team governance.

## §22. BaaS Capability and Identity-Portability Governance

- Rule 520.84: Do not use a BaaS or full-stack-platform product label as the smallest unit of adoption, support, release, or exit. Decompose it into Auth, database or data API, file or object storage, functions or compute, Realtime or streaming, queues or scheduling, search or vectors, AI, analytics, and hosting capabilities, then decide responsibility, support, data, identity, cost, SLO, and exit separately for managed-cloud, self-hosted, hybrid, or equivalent deployment modes. Product names such as AWS Amplify, Appwrite, and Convex are representative examples, not Universal mandates.
- Rule 520.85: Govern every production capability through a machine-readable capability manifest that binds at least provider and service, deployment mode, maturity and support authority, client, server, protocol, or other surfaces, environments, data classification, system of record, authorization boundary, region and residency, language, runtime, and SDK, configuration source, migration, backup and restore, cost drivers, SLO, accountable owner and continuity route, evidence references, exit evidence, and exception IDs. Do not silently omit an unused field; record why it is not applicable.

```yaml
platform_capabilities:
  schema_version: 1
  reviewed_at: "YYYY-MM-DD"
  entries:
    - id: "auth-primary"
      provider: "<provider>"
      service: "<service>"
      deployment_mode: "managed"
      maturity: "ga"
      surfaces: ["client-sdk", "server-sdk", "control-plane"]
      environments: ["production"]
      data_classification: ["identity"]
      system_of_record: true
      authorization_boundary: "<policy-source>"
      regions: ["<approved-region>"]
      language_runtime_sdk: ["<supported-surface>"]
      configuration_source: "<reviewable-source>"
      migration: "<versioned-contract>"
      backup_restore: "<verified-evidence>"
      cost_drivers: ["<billing-unit>"]
      slo: "<service-objective>"
      owners:
        accountable: "<owner>"
        continuity: "<alternate>"
      evidence_refs: ["<evidence>"]
      exit_evidence: "<export-or-recovery-proof>"
      exception_ids: []
```

- Rule 520.86: Inventory browser or mobile client SDKs, server or admin SDKs, direct protocols or data APIs, runtime bindings, CLIs, dashboards or control planes, webhooks or events, and emulators as separate trust surfaces. Verify positive and negative authorization, tenant isolation, rates and quotas, retries, and telemetry on each surface, and distinguish public project identifiers or publishable credentials from service or admin secrets by effective permission rather than name. Client-side Rules, RLS, App Check, or equivalents do not replace server-side IAM or business authorization.
- Rule 520.87: Even within one provider, capabilities have independent releases, maturity, regions, quotas, pricing, backups, failure modes, support, and EOL. Do not treat an aggregate BaaS status, plan, backup, SLA, or rollback label as evidence of atomic release, recovery, or DR for an individual capability or end-to-end user journey. Connect dependencies, shared identity, shared billing, state, and side effects in a capability graph.
- Rule 520.88: Identity portability covers user IDs, linked external providers, password-hash exportability, MFA or passkeys, sessions and tokens, consent, group, role, and tenant memberships, audit history, email or phone verification, and deletion state; a data export alone is insufficient. For non-portable elements, retain and exercise a migration path covering password resets, federation, dual run, ID mapping, user communication, reconciliation, rollback or forward fix, and privacy retention.
- Rule 520.89: Treat changes in capability GA, preview, deprecation, or EOL status, pricing or terms, SDK or runtime, region, limits, security model, incidents, M&A, or managed versus self-hosted responsibility as revalidation triggers, and detect expired reviews, missing owners, missing evidence, and unsupported critical surfaces at release gates. Small teams may combine roles, but must not omit accountable ownership, continuity, access recovery, billing, incident, or exit responsibilities.

## Appendix A: Reverse Index and Cross-References

### Reverse Index

| Keyword | Section |
|:--|:--|
| Vercel, Supabase, Firebase, Cloudflare | §14 |
| selection, portfolio, PaaS, BaaS | §1–§3 |
| RBAC, team, SSO, SCIM, sensitive operations | §4, §15 |
| preview, staging, production, promotion | §5–§6 |
| secrets, OIDC, environment variables | §7 |
| migrations, seeds, backups, PITR, state rollback | §8, §13 |
| edge, serverless, limits, cache | §9 |
| languages, runtimes, SDKs, Wasm, polyglot, buildpacks, managed runtime updates | §9, §14, §17 |
| WAF, App Check, supply chain, privacy | §10 |
| logs, traces, SLO, incidents | §11 |
| budget, spend cap, quota, cost incident | §12 |
| portability, vendor lock-in, exit, DR | §13 |
| Golden Path, Platform Engineering, enterprise teams | §15, §17 |
| CI, Evidence Packet, exceptions, maturity | §16 |
| official or community SDKs, feature parity, generated clients, protocol fallback | §17 |
| queues, events, delivery, idempotency, ordering, retries, DLQs, replay | §18 |
| local, emulators, mocks, fidelity matrices, remote bindings, managed conformance | §19 |
| marketplace apps, extensions, integrations, bindings, add-ons, install, update, uninstall, orphan scan | §20 |
| multi-service, service graph, release topology, aggregate release, route conflict, partial deployment | §21 |
| BaaS capability manifest, AWS Amplify, Appwrite, Convex, trust surfaces, identity portability, service EOL | §14, §22 |

### Cross-References

| Related authority | Responsibility |
|:--|:--|
| `engineering/100_api_integration.md` | Service boundaries, communication contracts, consistency, and release topology |
| `engineering/200_supabase_architecture.md` | Supabase and PostgreSQL profile |
| `engineering/300_web_frontend.md` | Web frameworks, rendering, browser quality |
| `engineering/320_programming_language_governance.md` | Runtime, languages, polyglot CI, supply chain |
| `engineering/500_firebase_gcp.md` | Firebase and GCP profile |
| `engineering/510_aws_cloud.md` | AWS profile |
| `engineering/530_azure_cloud.md` | Microsoft Azure profile |
| `engineering/700_batch_backfill_operations.md` | Machine-invoked jobs, failure accounting, and DLQ or quarantine |
| `engineering/740_data_contracts.md` | Event and data schemas, ownership, compatibility, and classification |
| `operations/400_site_reliability.md` | SLOs, release, DR, incidents |
| `operations/600_cloud_finops.md` | Cloud cost, unit economics, budgets |
| `security/000_security_privacy.md` | Identity, secrets, privacy, secure SDLC |
| `quality/000_qa_testing.md` | Platform, migration, and release testing |

### Primary Sources

- [Vercel Deployments](https://vercel.com/docs/deployments/overview), [Access Roles](https://vercel.com/docs/rbac/access-roles), [Spend Management](https://vercel.com/docs/spend-management), [OIDC Federation](https://vercel.com/docs/oidc), [Function Runtimes](https://vercel.com/docs/functions/runtimes), [Services](https://vercel.com/docs/services), [Vercel CLI](https://vercel.com/docs/cli), [Vercel Firewall](https://vercel.com/docs/vercel-firewall), [Logs](https://vercel.com/docs/logs), [DigitalOcean App Platform](https://docs.digitalocean.com/products/app-platform/)
- [Current Vercel Services guide](https://vercel.com/kb/guide/vercel-services), [Vercel Service Bindings](https://vercel.com/changelog/secure-internal-communication-between-services), [Vercel application structure](https://vercel.com/kb/guide/structure-your-application), [Cloudflare Service Bindings](https://developers.cloudflare.com/workers/runtime-apis/bindings/service-bindings/), [Kubernetes Services](https://kubernetes.io/docs/concepts/services-networking/service/), [Kubernetes Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/), [Cloud Run service revisions](https://cloud.google.com/run/docs/deploying), [Firebase App Hosting monorepos](https://firebase.google.com/docs/app-hosting/monorepos), [Firebase multisite hosting](https://firebase.google.com/docs/hosting/multisites): multiple units may be bundled into one deployment, deployed separately, or require explicit ordering, so repository, domain, provider project, and release atomicity do not coincide. Govern the service graph, compatibility order, partial failure, and aggregate evidence independently of provider.
- [Vercel integration permissions and access](https://vercel.com/docs/integrations/install-an-integration/manage-integrations-reference), [Vercel Marketplace API](https://vercel.com/docs/integrations/create-integration/marketplace-api/reference), [Firebase extension manifests](https://firebase.google.com/docs/extensions/manifest), [Manage installed Firebase extensions](https://firebase.google.com/docs/extensions/manage-installed-extensions), [Firebase extension access](https://firebase.google.com/docs/extensions/publishers/access), [Supabase Postgres extensions](https://supabase.com/docs/guides/database/extensions), [Supabase platform upgrades](https://supabase.com/docs/guides/platform/upgrading), [Supabase through the Vercel Marketplace](https://supabase.com/docs/guides/integrations/vercel-marketplace), [Cloudflare Workers integrations](https://developers.cloudflare.com/workers/configuration/integrations/), [Cloudflare bindings](https://developers.cloudflare.com/workers/runtime-apis/bindings/), [Cloudflare Workers versions and deployments](https://developers.cloudflare.com/workers/versions-and-deployments/): managed integrations can create identities, secrets, resources, bindings, billing, and residual artifacts whose install, change, degradation, and removal require an explicit lifecycle beyond package dependency management.
- [Vercel Environments](https://vercel.com/docs/deployments/environments), [Supabase Local Development](https://supabase.com/docs/guides/local-development/overview), [Firebase Local Emulator Suite](https://firebase.google.com/docs/emulator-suite), [Cloudflare Workers Local Development](https://developers.cloudflare.com/workers/local-development/), [Cloudflare binding support by development mode](https://developers.cloudflare.com/workers/local-development/bindings-per-env/), [AWS serverless testing guide](https://docs.aws.amazon.com/lambda/latest/dg/testing-guide.html): local, emulator, remote-binding, managed-preview, and cloud-test surfaces reproduce different behavior and constraints, so record fidelity and verify managed-only behavior according to risk.
- [Vercel Queues](https://vercel.com/docs/queues), [Supabase Queues](https://supabase.com/docs/guides/queues), [Firebase asynchronous function retries](https://firebase.google.com/docs/functions/retries), [Cloudflare Queues delivery guarantees](https://developers.cloudflare.com/queues/reference/delivery-guarantees/), [Cloudflare Queues batching and retries](https://developers.cloudflare.com/queues/configuration/batching-retries/): delivery scope, visibility or acknowledgment, retries, ordering, and DLQ or quarantine behavior differ by provider and require an end-to-end contract.
- [Supabase Branching](https://supabase.com/docs/guides/deployment/branching), [Access Control](https://supabase.com/docs/guides/platform/access-control), [Cost Control](https://supabase.com/docs/guides/platform/cost-control), [Backups](https://supabase.com/docs/guides/platform/backups), [Securing the Data API](https://supabase.com/docs/guides/api/securing-your-api), [Edge Functions](https://supabase.com/docs/guides/functions), [Client Libraries](https://supabase.com/docs/guides/api/rest/client-libs)
- [Firebase App Check](https://firebase.google.com/docs/app-check), [Firebase IAM](https://firebase.google.com/docs/projects/iam/permissions), [Security Rules Emulator](https://firebase.google.com/docs/firestore/security/test-rules-emulator), [App Hosting Costs](https://firebase.google.com/docs/app-hosting/costs), [Cloud Functions](https://firebase.google.com/docs/functions/get-started), [Client Libraries](https://firebase.google.com/docs/libraries)
- [Cloudflare Workers Languages](https://developers.cloudflare.com/workers/languages/), [Python Workers](https://developers.cloudflare.com/workers/languages/python/), [TypeScript Runtime Types](https://developers.cloudflare.com/workers/languages/typescript/), [Workers Versions and Deployments](https://developers.cloudflare.com/workers/versions-and-deployments/), [Gradual Deployments](https://developers.cloudflare.com/workers/versions-and-deployments/gradual-deployments/), [Rollbacks](https://developers.cloudflare.com/workers/versions-and-deployments/rollbacks/), [Limits](https://developers.cloudflare.com/workers/platform/limits/), [Observability](https://developers.cloudflare.com/workers/observability/)
- [AWS Lambda Runtimes](https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html), [Runtime Updates](https://docs.aws.amazon.com/lambda/latest/dg/runtimes-update.html), [Azure Functions Supported Languages](https://learn.microsoft.com/en-us/azure/azure-functions/supported-languages), [Language Version Updates](https://learn.microsoft.com/en-us/azure/azure-functions/update-language-versions): managed, custom, and container runtime support lifecycles
- [AWS Lambda with SQS](https://docs.aws.amazon.com/lambda/latest/dg/with-sqs.html), [Google Cloud Pub/Sub exactly-once delivery](https://cloud.google.com/pubsub/docs/exactly-once-delivery), [Azure Service Bus message loss and duplicates](https://learn.microsoft.com/en-us/azure/service-bus-messaging/service-bus-message-loss-and-duplicates): exactly-once, ordering, and deduplication are capabilities scoped by service, receive mode, region, acknowledgment, window, or equivalent conditions; they do not eliminate consumer and downstream-side-effect idempotency.
- [Google Cloud Client Libraries](https://cloud.google.com/apis/docs/client-libraries-explained), [AWS SDK Maintenance Policy](https://docs.aws.amazon.com/sdkref/latest/guide/maint-policy.html), [AWS SDK Version Lifecycle](https://docs.aws.amazon.com/sdkref/latest/guide/version-support-matrix.html): official clients, generated clients, direct protocols, SDK major versions, and dependency-runtime support lifecycles
- [Netlify Functions](https://docs.netlify.com/build/functions/get-started/), [Netlify Edge Functions](https://docs.netlify.com/edge-functions/overview/), [Cloud Run Container Contract](https://cloud.google.com/run/docs/container-contract): standard-function, edge, and container execution contracts
- [Render Supported Languages](https://render.com/docs/language-support), [Railway Languages and Frameworks](https://docs.railway.com/languages-frameworks): native or auto-detected builds versus container fallbacks
- [AWS Amplify documentation](https://docs.amplify.aws/javascript/start/), [Amplify Data](https://docs.amplify.aws/react/build-a-backend/data/set-up-data/), and [Amplify function secrets](https://docs.amplify.aws/react/build-a-backend/functions/environment-variables-and-secrets/): TypeScript-first full-stack definitions, per-capability resources and client surfaces, sandbox environments, and the distinction between environment variables retained in artifacts and secret storage
- [Appwrite documentation](https://appwrite.io/docs) and [Appwrite self-hosting](https://appwrite.io/docs/advanced/self-hosting): Auth, databases, storage, functions, messaging, and Realtime capabilities whose operational responsibility differs between managed and self-hosted deployment modes
- [Convex function types](https://docs.convex.dev/functions/overview): queries, mutations, actions, and HTTP actions have different transaction, reactivity, external-side-effect, and retry boundaries
- [MongoDB Atlas App Services release notes](https://www.mongodb.com/docs/atlas/app-services/release-notes/backend/) and [Atlas App Services Admin API](https://www.mongodb.com/docs/api/doc/atlas-app-services-admin-api-v3/): service-level lifecycle and EOL can diverge from a provider or database brand, so track each adopted capability and exit path independently
- [CNCF Annual Cloud Native Survey](https://www.cncf.io/reports/the-cncf-annual-cloud-native-survey/): market signal for containers, Kubernetes, and Platform Engineering. It is not a standalone mandate for adoption or design.
