# 530. Microsoft Azure Cloud Governance

> [!CAUTION]
> This file is a Universal Rule (immutable). Do not edit it without an explicit instruction to amend the constitution.
> Last updated: 2026-07-23

> [!IMPORTANT]
> Primary directive: Azure is a collection of capabilities for implementing responsibility boundaries, not a product that performs enterprise governance on the customer's behalf. Do not confuse Microsoft Entra, management groups, subscriptions, resource groups, Azure Policy, or managed services with application, team, data, failure, or cost boundaries. Do not impose one fixed topology on every project. Require the same verifiable outcomes for safety, reproducibility, traceability, recoverability, cost accountability, and exit.
> 21 sections, Rules 530.1–530.85.

---

## Table of Contents

| Section | Topic |
|:--|:--|
| §1 | Scope and Universal Applicability Contract |
| §2 | Tenants, management groups, and landing zones |
| §3 | Microsoft Entra, RBAC, and privileged access |
| §4 | Azure Policy, resource governance, and inventory |
| §5 | IaC, control-plane change, and drift |
| §6 | Compute, runtimes, and workload placement |
| §7 | Languages, SDKs, and runtime lifecycle |
| §8 | Releases, revisions, slots, and rollback |
| §9 | Network, edge, DNS, and egress |
| §10 | Secrets, keys, certificates, and configuration |
| §11 | Data, state, migrations, and backups |
| §12 | Messaging, events, and workflows |
| §13 | Observability, audit, and incidents |
| §14 | Security, privacy, and compliance |
| §15 | Reliability, availability, and DR |
| §16 | FinOps, quotas, and capacity |
| §17 | Platform Engineering, teams, and enterprise operation |
| §18 | Supply chain, CI, and managed conformance |
| §19 | Portability, exit, and decommissioning |
| §20 | Evidence, maturity, and anti-patterns |
| §21 | Azure Functions language, worker, and hosting support surfaces |
| Appendix A | Reverse index, cross-references, and primary sources |

---

## §1. Scope and Universal Applicability Contract

- Rule 530.1: This file is the provider profile for adopting or operating applications, data, identity, networks, integrations, containers, serverless systems, AI, and platform foundations on Azure. It does not require Azure adoption.
- Rule 530.2: Universal outcomes are least privilege, reviewable change, environment and failure boundaries, data recovery, release traceability, unit cost, support lifecycle, and an exit plan. Services, SKUs, regions, topologies, tools, role names, and fixed thresholds are Blueprint parameters or point-in-time reference implementations.
- Rule 530.3: Evaluate the Azure Well-Architected Framework pillars of Reliability, Security, Cost Optimization, Operational Excellence, and Performance Efficiency as interacting trade-offs. Passing one pillar never proves production readiness.
- Rule 530.4: Reverify Azure features, preview or GA status, quotas, runtimes, SDKs, API versions, regional availability, pricing, and support contracts against official sources and effective tenant or subscription settings at adoption and material-change boundaries. Product names in this file are not future capability guarantees.

## §2. Tenants, Management Groups, and Landing Zones

- Rule 530.5: Declare the hierarchy of Microsoft Entra tenant, billing scope, management group, subscription, resource group, and resource. Record ownership, policy inheritance, permission, cost, deletion, and transfer boundaries at each level.
- Rule 530.6: When separating application and platform landing zones, connect shared network, identity, security, management, and other capabilities to workload-team responsibilities through a service contract. Small systems may combine duties but not omit boundaries or evidence.
- Rule 530.7: Subscription vending or an equivalent provisioning path may offer multiple safe product lines by workload class. Do not force every application into one large subscription, one network, or one approval flow.
- Rule 530.8: Design management-group and subscription placement from policy, data residency, blast radius, billing, delegation, quota, and lifecycle rather than mirroring the organization chart. Test policy reevaluation and access changes before a move.

## §3. Microsoft Entra, RBAC, and Privileged Access

- Rule 530.9: Separate human, workload, device, and external identities. Inventory Azure RBAC, Microsoft Entra roles, resource data-plane roles, and application authorization as distinct permission planes. Never infer effective permission from names such as `Owner` or `Contributor` alone.
- Rule 530.10: Prefer managed identities or workload identity federation with short-lived tokens for Azure workloads when supported. When client secrets, certificates, or access keys remain, track necessity, scope, rotation, revocation, and every use site.
- Rule 530.11: Apply risk-based PIM or equivalent just-in-time, time-bound access, approval, step-up, notification, and audit to privileged human access. Permanent Global Administrator or Owner access is not a normal operating path.
- Rule 530.12: Break-glass identities require a threat model that includes normal SSO failure, protected storage, activation conditions, monitoring, post-use review, and recovery verification. Do not reuse them for daily activity or automation.

## §4. Azure Policy, Resource Governance, and Inventory

- Rule 530.13: Treat Azure Policy as a governance plane that evaluates resource state and actions, and Azure RBAC as an authorization plane that constrains principal actions. Neither replaces the other.
- Rule 530.14: Version policy definitions, initiatives, assignments, exemptions, effects, managed identities, and remediation. Test scope inheritance, deny impact, existing-resource behavior, and exemption rationale before change.
- Rule 530.15: Stage transitions from audit to deny, modify, deployIfNotExists, or equivalent effects through observation, impact analysis, remediation, owner communication, and rollback or safe mitigation. Do not apply an untested organization-wide deny directly.
- Rule 530.16: Use Azure Resource Graph or an equivalent mechanism to provide searchable inventory for resources, public exposure, identities, role assignments, policy compliance, diagnostic settings, regions, SKUs, tags, owners, cost, and lifecycle.

## §5. IaC, Control-Plane Change, and Drift

- Rule 530.17: Apply Bicep or ARM, Terraform, Pulumi, or equivalent IaC to reconstructable resources, roles, policies, networks, diagnostic settings, alerts, and budgets. Prioritize review, plan, state, provenance, drift, and recovery outcomes over a named tool.
- Rule 530.18: Obtain what-if, plan, or equivalent change prediction before deployment, but do not treat it as proof of unknown values, provider side effects, runtime behavior, data mutations, or linked deployments. Supplement high-risk change with isolated tests or staged application.
- Rule 530.19: When deployment stacks or equivalent features manage resource lifecycle, deny, detach, or delete behavior, declare ownership, adoption of existing resources, deletion semantics, known limitations, and break-glass. Forced deletion is not a routine drift-remediation technique.
- Rule 530.20: Emergency portal or CLI changes record actor, rationale, before and after state, ticket, expiry, and reconciliation, then return to IaC or another approved source. Unrecorded control-plane mutation must not become permanent state.

## §6. Compute, Runtimes, and Workload Placement

- Rule 530.21: Select App Service, Functions, Container Apps, AKS, VMs, Batch, Static Web Apps, or equivalent capabilities by request, event, batch, long-running, state, network, startup, scale, portability, and operator burden. Neither serverless-first nor Kubernetes-first is a maturity measure.
- Rule 530.22: Record managed-compute responsibility boundaries for OS and runtime patches, base images, autoscaling, capacity, network, certificates, backups, observability, and deployment units. A provider-managed scope does not guarantee application recovery.
- Rule 530.23: An event-driven compute contract covers timeout, concurrency, cold start, retry, poison input, idempotency, connection reuse, scale limits, and downstream backpressure.
- Rule 530.24: AKS adoption defines cluster and workload responsibilities, mode, upgrades, node pools, tenant isolation, pod security, resource requests and limits, disruption, images, workload identity, backup, and DR. Creating a cluster does not complete the platform.

## §7. Languages, SDKs, and Runtime Lifecycle

- Rule 530.25: Declare Azure language support separately for application runtime, Azure SDK, management SDK or CLI, data-plane SDK, build, debug, observability, and deployment surfaces. “Azure supports this language” is not one Boolean value.
- Rule 530.26: Classify primary SDKs for .NET, Java, TypeScript or JavaScript, Python, and Go, plus C++, Rust, mobile, or community packages, by official lifecycle, stable or beta state, feature parity, API coverage, maintenance, and security response. Beta is not the production default.
- Rule 530.27: Azure SDKs depend on runtimes, operating systems, service REST APIs, and third-party libraries. Track EOL, minimum versions, migration guides, and breaking changes across the full support chain rather than the SDK alone.
- Rule 530.28: When a language lacks an SDK or has delayed feature parity, define a fallback through versioned REST or protocol, generated clients, sidecars, or service boundaries, including auth, retry, pagination, error, and telemetry contracts. Do not standardize an unofficial package without evaluation.

## §8. Releases, Revisions, Slots, and Rollback

- Rule 530.29: Link source revision, resolved dependencies, builder, artifact or image digest, runtime, configuration, IaC deployment, data migration, Azure deployment ID, and traffic state in an aggregate release record.
- Rule 530.30: App Service slots, Container Apps revisions, Functions slots, AKS rollouts, and similar capabilities switch compute or traffic. They do not automatically roll back databases, queues, identity, DNS, caches, or external side effects. Verify state compatibility in a separate gate.
- Rule 530.31: Progressive delivery chooses an appropriate blast-radius unit from revision, slot, region, tenant, feature flag, or equivalent and defines SLI, sample, observation window, abort, rollback, or forward-fix parameters in the Blueprint.
- Rule 530.32: Test the ordering and differences among slot swaps, revision activation, image promotion, and configuration changes, including sticky settings, private endpoints, managed identities, warm-up, and health probes. Equal environment names do not prove parity.

## §9. Network, Edge, DNS, and Egress

- Rule 530.33: Map public ingress, private ingress, service-to-service traffic, hybrid connectivity, management access, egress, DNS, and certificates into data flows. Map VNet, subnet, NSG, Private Link, Firewall, Front Door, or equivalent capabilities to required threats and failure modes.
- Rule 530.34: Private Link and private endpoints reduce network exposure; they do not replace authentication, authorization, encryption, DNS integrity, or exfiltration controls. Verify any remaining public-access path.
- Rule 530.35: Layer L3 or L4 DDoS, L7 WAF, rate limiting, bot and abuse controls, origin shielding, end-to-end TLS, health probes, and failover for internet-facing applications. Choose Front Door, Application Gateway, or equivalents by global routing, protocol, latency, cost, and operator burden.
- Rule 530.36: Govern egress by destination, identity, DNS, proxy or firewall, SNAT or port capacity, private endpoints, data classification, and cost. Do not leave unrestricted outbound access as an unmanaged-service default.

## §10. Secrets, Keys, Certificates, and Configuration

- Rule 530.37: Use Key Vault or an equivalent approved secret store and classify secrets, keys, certificates, and configuration. Minimize control-plane management permission separately from data-plane read, sign, or decrypt permission.
- Rule 530.38: Design soft delete, purge protection, backup and restore, key rotation, certificate renewal, expiry alerts, and recovery access from data criticality and regulation. Deletion protection does not replace recovery testing.
- Rule 530.39: Applications use managed identity or equivalent to retrieve only necessary values at runtime. Never embed secrets in source, images, IaC output, deployment logs, or client bundles. Define secret-reference failure behavior and caching duration.
- Rule 530.40: Configuration has type, scope, owner, default, sensitivity, change history, rollout, and rollback. Dynamic changes through App Configuration, feature flags, environment settings, or equivalents also connect to release evidence and audit.

## §11. Data, State, Migrations, and Backups

- Rule 530.41: Select Azure SQL, Cosmos DB, Azure Database for PostgreSQL, Storage, or equivalents by data model, consistency, transactions, query shape, scale, residency, portability, operator burden, and unit cost. A provider portfolio is not a reason to force one database onto every workload.
- Rule 530.42: Include databases, objects, files, caches, search, identity, secrets, queues, configuration, schemas, and DNS in a resource-complete recovery inventory. Distinguish systems of record from derived state that can be rebuilt.
- Rule 530.43: Schema and data migration require expand, migrate, and contract phases or equivalent, version compatibility, backfill, validation, pause, resume, and rollback or forward recovery. Reversing an application slot or revision alone does not prove safety.
- Rule 530.44: Backups, PITR, geo-replication, and zone or regional redundancy address different failure modes. Define RPO and RTO, retention, immutability, keys, off-region or off-account needs, and restore order, then perform a real restore in an isolated environment.

## §12. Messaging, Events, and Workflows

- Rule 530.45: Select Service Bus, Event Grid, Event Hubs, Storage Queue, Durable Functions, Logic Apps, or equivalents by command, event, or stream semantics, ordering, delivery, throughput, retention, replay, transactions, connector trust, and cost.
- Rule 530.46: For at-least-once or duplicate-capable delivery, define producer and consumer idempotency keys, deduplication scope and window, transaction boundaries, side effects, and replay safety. Provider duplicate detection alone never owns business integrity.
- Rule 530.47: Retry uses bounded exponential backoff and jitter, retryability classification, lock or visibility semantics, TTL, dead-letter or quarantine, poison-message inspection, and redrive approval. Prohibit unbounded retry amplification across layers.
- Rule 530.48: Sessions, partitions, and ordering keys guarantee order only within their documented scope. Contract-test order and consistency across partition changes, consumer scaling, failover, replay, and cross-entity transactions.

## §13. Observability, Audit, and Incidents

- Rule 530.49: Use Azure Monitor, Application Insights, OpenTelemetry, or equivalents to correlate SLIs across user journeys, applications, dependencies, platforms, control planes, and data planes. Do not make one telemetry backend a prerequisite for portability.
- Rule 530.50: Activity Log primarily records control-plane operations, while resource logs cover service data-plane or internal operations. Resource logs might not be collected by default, so verify required categories, diagnostic settings, destinations, retention, and access through IaC and inventory.
- Rule 530.51: Logs, metrics, traces, profiles, and security events have PII and secret scrubbing, tenant separation, cardinality, sampling, retention, query access, export, and cost budgets. Neither collect-everything nor drop-everything is a universal policy.
- Rule 530.52: Include Azure Service Health, Resource Health, provider status, quotas, billing, certificates, identity, and DNS in incident dependencies. Runbooks cover support escalation, degraded mode, customer communication, and evidence preservation.

## §14. Security, Privacy, and Compliance

- Rule 530.53: Microsoft Cloud Security Benchmark, Defender for Cloud, security recommendations, and equivalents inform control selection and gap detection. An enablement score is not proof of effective security; verify through the threat model and runtime evidence.
- Rule 530.54: Connect data classification, processing purpose, residency, replication, support access, log export, backup, key location, subprocessors, and deletion to the service graph. Region selection alone does not prove data sovereignty.
- Rule 530.55: Combine tenant, subscription, network, resource, application, and row or object isolation according to data sensitivity and multi-tenancy threats. Resource groups and subscriptions do not replace application authorization.
- Rule 530.56: Continuously monitor public exposure, role assignments, policy exemptions, key access, security alerts, support access, and cross-tenant trust. Security incident response coordinates credential revocation, identity containment, evidence preservation, and recovery.

## §15. Reliability, Availability, and DR

- Rule 530.57: Confirm Azure and customer shared responsibility for each service. Names such as availability zone, zone-redundant, region pair, and multi-region never guarantee application-level availability by themselves.
- Rule 530.58: Select single-region, zone redundancy, active or passive, active or active, rebuild, or equivalent patterns from workload RTO and RPO, dependencies, traffic, data consistency, capacity, DNS, identity, keys, and quota. Multi-region is not an unconditional maturity requirement.
- Rule 530.59: Apply timeout, retry, circuit breaker, bulkhead, load shedding, queueing, caching, and graceful degradation to dependency contracts. Test duplication between provider retries and application retries.
- Rule 530.60: Exercise failover, restore, regional evacuation, identity outage, control-plane outage, quota exhaustion, and dependency degradation at a risk-based cadence. Feed measured RTO and RPO, data loss, manual steps, and capacity gaps into improvements.

## §16. FinOps, Quotas, and Capacity

- Rule 530.61: Integrate billing scopes, subscriptions, resource groups, tags, meters, reservations or savings, marketplace charges, support, licenses, egress, and telemetry into cost allocation. Make costs explainable by product, team, environment, tenant, and unit of value.
- Rule 530.62: Azure Cost Management budgets, forecasts, and anomaly alerts are notification or automation triggers, not standalone hard caps. Design safe actions, ownership, escalation, rate limits, quotas, and degraded modes according to service criticality.
- Rule 530.63: Monitor subscription, region, resource-provider, SKU, and service quotas and capacity together with current usage, growth, deployment surges, failover, DR, and support lead time. An autoscale maximum does not prove available capacity.
- Rule 530.64: Connect compute, request, execution, database operation, storage, egress, build, log, seat, and other cost drivers to unit economics. Continuously detect idle, orphaned, and overprovisioned resources, retry storms, high-cardinality telemetry, and stale preview environments.

## §17. Platform Engineering, Teams, and Enterprise Operation

- Rule 530.65: Platform teams provide Golden Paths for landing zones, subscription vending, identity, networks, policy, observability, cost, and deployment as a product, with explicit workload-team responsibility, SLOs, support, exceptions, and feedback.
- Rule 530.66: Individuals and small teams may combine duties, but retain accountable capabilities for production ownership, security, billing, data recovery, release authority, and break-glass. Organization size alone never removes a control.
- Rule 530.67: Large organizations combine central guardrails with federated governance for policy, identity, network, cost, and inventory across tenants, management groups, and subscriptions. Do not make the central team a manual bottleneck for every delivery.
- Rule 530.68: Unify joiner, mover, leaver, guest, vendor, managed-service identity, support engineer, and automation-principal lifecycles. Detect orphaned role assignments, shared accounts, personally owned subscriptions, and expired exceptions.

## §18. Supply Chain, CI, and Managed Conformance

- Rule 530.69: Azure DevOps, GitHub Actions, and other CI systems are interchangeable implementations. The outcome contract is source protection, review, ephemeral identity, pinned dependencies, isolated builds, secret scanning, IaC policy, tests, SBOM, provenance, signing, and promotion evidence.
- Rule 530.70: Prefer short-lived credentials such as OIDC workload identity federation for CI-to-Azure authentication. Do not share long-lived client secrets or publish profiles across a repository or organization. Constrain subject, audience, environment, branch or tag, and role scope.
- Rule 530.71: Inventory containers, packages, function bundles, templates, extensions, agents, and marketplace integrations by source, publisher, version, digest, license, vulnerability, permissions, update mode, and EOL. Connect them to an SBOM and provenance matching the deployed subject.
- Rule 530.72: Local emulators, mocks, Azurite, containers, and test subscriptions provide fast feedback but do not fully reproduce managed identity, Policy, DNS, Private Link, quotas, scale, retry, regions, billing, or provider updates. Maintain a fidelity matrix and close gaps with managed conformance tests.

## §19. Portability, Exit, and Decommissioning

- Rule 530.73: An exit plan covers not only source but data, schemas, objects, identities, roles, policies, secrets, keys, certificates, DNS, domains, queues, events, telemetry, IaC state, support evidence, and billing records.
- Rule 530.74: Decide whether to abstract an Azure-specific API from migration probability, business value, performance, operator burden, and testability. Avoid both wrapper proliferation and unconscious lock-in; record irreversible points in an ADR.
- Rule 530.75: Verify exports and restores for format, completeness, ordering, metadata, ACLs, encryption, checksums, throughput, downtime, egress cost, and consumer compatibility. The presence of an export button does not prove exit readiness.
- Rule 530.76: Decommissioning completes only after traffic and producers stop, consumers are confirmed, data retention or deletion finishes, identities and roles are revoked, and DNS, certificates, integrations, backups, logs, resource locks, subscriptions or billing, and orphan scans are closed.

## §20. Evidence, Maturity, and Anti-Patterns

- Rule 530.77: Risk-based production-readiness evidence includes a responsibility matrix, resource and identity inventory, architecture and data flows, IaC plans, Policy results, release records, restore tests, SLOs, cost models, quotas, runbooks, and an exit plan.
- Rule 530.78: Combine IaC syntax and static analysis, what-if or plan, policy, identity diff, public exposure, secret checks, artifact verification, SBOM and provenance, migration compatibility, and managed smoke tests according to change impact. This does not require every gate to run serially on every PR.
- Rule 530.79: Measure maturity by ownership, reproducibility, least privilege, managed conformance, measured recovery, cost explainability, exception expiry, and exit rehearsal, not by the count of Azure services or management groups.
- Rule 530.80: Anti-patterns include production in a personal subscription, permanent Owner access, shared service-principal secrets, portal-only change, confusing Policy with RBAC, relying on slot rollback for data, using Activity Log as complete data-plane audit, treating a budget alert as a hard cap, untested backups, unbounded autoscaling, using subscriptions as application authorization, and deleting without an orphan scan.

## §21. Azure Functions Language, Worker, and Hosting Support Surfaces

- Rule 530.81: Never reduce “Azure Functions supports language X” to one Boolean. Connect the language version, Functions host version, worker model, operating system, hosting plan, region, deployment unit, local toolchain, triggers and bindings, debugging and observability, runtime updates, and EOL in one support record. The existence of an Azure SDK, execution through a Custom Handler, or in-portal editing does not equal first-class managed language support.
- Rule 530.82: In the official support table as of 2026-07-23, C#, JavaScript or TypeScript, Python, Java, and PowerShell have managed language surfaces; Go is Preview and limited to the Flex Consumption plan; Rust and other languages use Custom Handlers. This is a point-in-time adoption snapshot. Do not promote Preview to GA or a production default, and revalidate versions, plans, operating systems, regions, feature parity, SLA or support, and migration guidance at implementation time.
- Rule 530.83: A Custom Handler is an escape hatch that provides an HTTP or documented protocol boundary to the Functions host; it does not guarantee provider management of the selected language runtime, packages, security patches, startup, signals, serialization, or binding bridge. The adopter owns the runtime artifact, bootstrap, dependencies, SBOM, provenance, health, telemetry, patches, rollback, and handler-protocol compatibility, and assigns a support tier distinct from a managed worker for the same language.
- Rule 530.84: Separate worker model and hosting plan from the language name. The .NET in-process or isolated worker, TypeScript transpiled onto Node.js, managed minor or patch updates, Linux or Windows differences, and plan-specific version freezes or retirement can change builds, triggers and bindings, startup, memory, network, deployment, and managed smoke behavior in addition to source compatibility. Retaining an old host or worker or disabling supported automatic updates requires an owner, expiry, security-gap record, migration tests, and rollback or forward-fix.
- Rule 530.85: Assign an accountable owner, support level, EOL, advisory route, native CI gate, managed conformance, on-call route, fallback, and decommission path to every production Functions language, worker, operating-system, and plan combination. A platform team may provide approved combinations as Golden Paths, but must not force one language or plan on every team; expose Preview or Custom Handler risk acceptance and upgrade evidence to the workload owner.

---

## Appendix A: Reverse Index

| Problem | Reference |
|:--|:--|
| enterprise landing zones and subscription vending | §2, §17 |
| Microsoft Entra, managed identity, PIM, and OIDC | §3, §10, §18 |
| Azure Policy, inventory, and portal drift | §4, §5 |
| App Service, Functions, Container Apps, and AKS | §6, §8 |
| .NET, Java, TypeScript, Python, Go, and SDKs | §7 |
| Azure Functions, Go Preview, Custom Handlers, worker models, and hosting plans | §21 |
| Private Link, Front Door, WAF, DDoS, and egress | §9 |
| Key Vault, secrets, and certificates | §10 |
| Azure SQL, Cosmos DB, PostgreSQL, Storage, and backups | §11 |
| Service Bus, Event Grid, Event Hubs, and Logic Apps | §12 |
| Azure Monitor, Activity Log, and diagnostic settings | §13 |
| data sovereignty and security posture | §14 |
| availability zones, multi-region, and DR | §15 |
| Cost Management, budgets, quotas, and unit cost | §16 |
| SBOM, provenance, and managed conformance | §18 |
| exit and decommissioning | §19 |

### Cross-References

- Cross-platform selection, shared responsibility, and aggregate releases: `engineering/520_cloud_application_platforms.md`
- Programming languages, SDKs, and toolchains: `engineering/320_programming_language_governance.md`
- API and service boundaries: `engineering/100_api_integration.md`
- Git, CI, and release workflow: `engineering/600_git_workflow.md`
- Security and Privacy: `security/000_security_privacy.md`
- OSS, SBOM, and SLSA: `security/200_oss_compliance.md`
- QA, IaC, and migration testing: `quality/000_qa_testing.md`
- SRE, DR, and Production Readiness: `operations/400_site_reliability.md`
- Cloud FinOps: `operations/600_cloud_finops.md`

### Primary Sources

- [Microsoft Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/what-is-well-architected-framework)
- [Azure landing zones](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/) and [subscription vending product lines](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/subscription-vending-product-lines)
- [Microsoft Entra managed identities](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview), [workload identity federation](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation-create-trust), and [Privileged Identity Management](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-configure)
- [Azure Policy overview](https://learn.microsoft.com/en-us/azure/governance/policy/overview)
- [Bicep deployment what-if](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-what-if) and [deployment stacks](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deployment-stacks)
- [App Service deployment slots](https://learn.microsoft.com/en-us/azure/app-service/deploy-staging-slots), [Container Apps revisions](https://learn.microsoft.com/en-us/azure/container-apps/revisions), [traffic splitting](https://learn.microsoft.com/en-us/azure/container-apps/traffic-splitting), and [Functions runtime versions](https://learn.microsoft.com/en-us/azure/azure-functions/functions-versions)
- [Azure Functions supported languages](https://learn.microsoft.com/en-us/azure/azure-functions/supported-languages), [Azure Functions language stack support policy](https://learn.microsoft.com/en-us/azure/azure-functions/language-support-policy), and [Azure Functions custom handlers](https://learn.microsoft.com/en-us/azure/azure-functions/functions-custom-handlers): boundaries among managed languages, worker models, operating systems and hosting plans, Preview and GA stages, Custom Handlers, and support lifecycles
- [Azure Private Link](https://learn.microsoft.com/en-us/azure/private-link/private-link-overview), [Azure Front Door best practices](https://learn.microsoft.com/en-us/azure/frontdoor/best-practices), and [Azure DDoS Protection security](https://learn.microsoft.com/en-us/azure/ddos-protection/secure-ddos-protection)
- [Azure Key Vault RBAC](https://learn.microsoft.com/en-us/azure/key-vault/general/rbac-guide) and [secure Key Vault access](https://learn.microsoft.com/en-us/azure/key-vault/general/secure-key-vault)
- [Service Bus message loss and duplicates](https://learn.microsoft.com/en-us/azure/service-bus-messaging/service-bus-message-loss-and-duplicates), [duplicate detection](https://learn.microsoft.com/en-us/azure/service-bus-messaging/duplicate-detection), and [Event Grid delivery and retry](https://learn.microsoft.com/en-us/azure/event-grid/delivery-and-retry)
- [Azure Monitor Activity Log](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log) and [diagnostic settings](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings)
- [Microsoft Cost Management](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/overview-cost-management), [Azure quotas](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits), [Reliability in Azure](https://learn.microsoft.com/en-us/azure/reliability/), and [Azure Backup](https://learn.microsoft.com/en-us/azure/backup/backup-overview)
- [Azure SDK support policy](https://azure.github.io/azure-sdk/policies_support.html), [Azure SDK release policy](https://azure.github.io/azure-sdk/policies_releases.html), and [Azure SDK design guidelines](https://azure.github.io/azure-sdk/general_introduction.html)
