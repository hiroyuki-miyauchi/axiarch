# 32. Backend Engineering (Firebase & GCP)

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-07-23

> [!IMPORTANT]
> **Primary Directive**
> "Adopt Firebase/GCP by capability and make responsibility boundaries for data, access, cost, and recovery explicit."
> In all Firebase/GCP implementations, strictly follow this priority order: **Security & Privacy > Data Integrity & Reliability > Cost Efficiency (FinOps) > Performance > Developer Productivity**. App Check, Security Rules, IAM, idempotency, and retry are controls selected according to the adopted surface and threat.
> This document is the provider profile for systems that adopt Firebase/GCP.
> **57 sections (§0–§56) · Rules 32.1–32.175 · Appendices A–E.**

> [!NOTE]
> **Universal Applicability Contract**
> This file neither mandates Firebase/GCP for every project nor subordinates it to Supabase or another data platform. Adoption follows `engineering/520_cloud_application_platforms.md`; apply only rules corresponding to capabilities in use. Service names, generations, runtimes, limits, pricing, regions, CLI commands, and defaults are volatile information and must be revalidated against current official documentation and effective settings. Fixed topology, thresholds, and naming belong in Blueprint.

---

## Table of Contents

**I. Foundation & Philosophy**
- §0. Primary Directives
- §1. Firebase Project Strategy & GCP Integration

**II. Compute**
- §2. Cloud Run Functions (formerly Cloud Functions 2nd Gen)
- §3. Cloud Run Services & Jobs

**III. Event-Driven**
- §4. Event-Driven Design (Eventarc / Pub/Sub / Cloud Tasks)

**IV. Authentication & Authorization**
- §5. Firebase Authentication Strategy
- §6. App Check & App Authentication

**V. Database**
- §7. Firestore Design & Security Rules
- §8. Firebase Data Connect (Cloud SQL) — GA

**VI. Storage & Hosting**
- §9. Cloud Storage for Firebase
- §10. Firebase Hosting & App Hosting (GA)

**VII. Client Services**
- §11. FCM (Push Notification) Strategy
- §12. Remote Config & Feature Flags
- §13. Crashlytics & Stability Monitoring
- §14. Performance Monitoring
- §15. Google Analytics for Firebase

**VIII. AI & ML**
- §16. Firebase AI Logic & Genkit
- §17. Vertex AI Integration
- §18. AI Agent Security & Governance

**IX. Data Analytics & Extensions**
- §19. Firebase Extensions Strategy
- §20. BigQuery Integration & Data Analytics Platform

**X. Security Defense-in-Depth**
- §21. Security Defense-in-Depth (Zero Trust)
- §22. IAM & Service Account Management
- §23. Secret Manager & Sensitive Data Management
- §24. VPC & Network Security

**XI. FinOps**
- §25. FinOps & Cost Optimization
- §26. Budget Alerts & Automated Response

**XII. Observability**
- §27. Observability (Cloud Logging / Monitoring / Trace)
- §28. Error Handling & Retry Strategy

**XIII. IaC & CI/CD**
- §29. Terraform / IaC Management
- §30. Firebase CLI & Local Development
- §31. Emulator Suite & Testing Strategy
- §32. CI/CD Pipeline Integration
- §33. Environment Management (Dev / Staging / Prod)

**XIV. DR & Scalability**
- §34. Multi-Region & DR Strategy

**XV. API & Caching**
- §35. API Design & Endpoint Management
- §36. Rate Limiting & API Protection
- §37. Caching Strategy

**XVI. Batch & Pipeline**
- §38. Batch Processing & Data Pipeline

**XVII. Google Ecosystem**
- §39. Google Maps Platform Optimization
- §40. Google Ecosystem Integration Strategy

**XVIII. Development Environment Portability**
- §41. Firebase Studio Sunset & Development Environment Portability

**XIX. Compliance & Governance**
- §42. Compliance & Data Sovereignty
- §43. Supply Chain Security

**XX. Operations & Maturity**
- §44. Operational Maturity Model
- §45. Migration & Deprecation Strategy
- §46. Troubleshooting & Debugging

**XXI. Language-Specific: Node.js (TypeScript)**
- §47. Node.js/TypeScript Specific Design
- §48. Node.js Performance & Testing
- §49. Node.js Deployment & Package Management

**XXII. Language-Specific: Go**
- §50. Go Specific Design
- §51. Go Performance & Testing

**XXIII. Language-Specific: Python**
- §52. Python Specific Design
- §53. Python Performance & Testing

**XXIV. Anti-Patterns & Technology Lifecycle**
- §54. 35 Anti-Patterns
- §55. Technology Lifecycle Radar

**XXV. Language, SDK & Runtime Support**
- §56. Language, SDK & Runtime Support Surfaces

**Appendix**
- Appendix A: Quick Reference Index
- Appendix B: Cross-References
- Appendix C: FinOps Checklist
- Appendix D: Security Checklist
- Appendix E: Official Reference Snapshot

---

## §0. Primary Directives

### Primary Directive 0.1: Authoritative Data Boundary
-   **Law**: Define one authoritative store per data domain and evaluate Firestore, Data Connect, Cloud SQL, Supabase, or other candidates by consistency, queries, offline behavior, latency, operations, regulation, and exit requirements.
-   **Mandate**:
    1.  **Explicit Ownership**: State the owner, system of record, synchronization direction, conflict resolution, retention, deletion, and export for each dataset.
    2.  **Firestore Validity**: Firestore is a valid option when document, realtime, or offline needs fit and Security Rules, IAM, indexes, cost, backup, and portability are designed.
    3.  **No Accidental Dual Authority**: Dual writes across stores are prohibited without an outbox, idempotency, reconciliation, and defined failure behavior.

### Primary Directive 0.2: Defense in Depth
-   **Law**: Security must not depend on a single layer. Select mutually reinforcing controls applicable to the surface and threat model from client attestation, authentication, Security Rules, IAM, network controls, abuse controls, and audit, and state the boundary each control does not protect.
-   **Mandate**:
    1.  **App Check Where Eligible**: Roll out App Check according to risk on supported client surfaces and backends. App Check does not replace Firebase Authentication, Security Rules, IAM, or rate limiting.
    2.  **Least Privilege**: Minimize every workload identity and IAM binding, and do not grant broad basic roles to normal production runtime identities. Separate, time-bound, approve, and audit human emergency access.
    3.  **Zero Trust Network**: Apply VPC Service Controls, Private Google Access, or another network control after evaluating service support, data-exfiltration risk, latency, cost, and operational complexity.

### Primary Directive 0.3: Idempotency First
-   **Law**: Design event handlers, jobs, mutation endpoints, and external side effects that can be retried, redelivered, or repeated after timeout to be idempotent or duplicate-safe. Do not force one implementation pattern onto read-only requests; define guarantees at each side-effect boundary.
-   **Mandate**:
    1.  **Stable Idempotency Identity**: For a retried or redelivered side effect, define a stable idempotency key from an event ID, resource version, business operation ID, or equivalent. Do not fix every trigger to `eventId`.
    2.  **Atomicity at the Boundary**: Use transactions, conditional writes, or batches for claims, state transitions, or multi-document invariants within one database. Do not mechanically wrap every single-document write in a transaction; handle failures outside a database transaction with provider idempotency keys, outboxes, leases or fencing, and reconciliation.
    3.  **Retry Safety**: Guarantee that retries do not cause duplicate side effects.

### Primary Directive 0.4: FinOps Guardian
-   **Law**: Cloud costs are managed with the same rigor as technical debt. Budget overruns are treated as incidents.
-   **Mandate**:
    1.  **Budget Controls**: Define notification thresholds, forecasts, quotas, rate limits, spend anomaly detection, and owners in Blueprint according to workload criticality and billing model. A budget alert is not a hard spending cap.
    2.  **Safe Automated Response**: Automate restrictions only for targets that preserve safety, data integrity, legal duties, and SLOs; provide graceful degradation and a manual recovery procedure.
    3.  **Cost Attribution**: Attribute cost to environment, service, owner, and cost center with supported labels or tags, project or folder boundaries, billing exports, and service metadata. Do not assume every resource supports the same label keys; use a mapping inventory for unsupported resources.

### Primary Directive 0.5: Compute Lifecycle
-   **Law**: Inventory functions, services, jobs, and runtime generations, then select and migrate according to official support, EOL, compatibility, and workload fit.
-   **Mandate**:
    1.  **Naming**: Use "Cloud Run Functions" in documentation, code, and IaC.
    2.  **Unified Management**: Monitor and manage Cloud Run Functions, Services, and Jobs uniformly.
    3.  **Migration Path**: For legacy generations, maintain a migration plan, compatibility tests, and rollback based on official deadlines and risk; avoid unvalidated bulk migration.

---

## §1. Firebase Project Strategy & GCP Integration

### Rule 32.1: Project Separation Strategy
-   **Mandate**: Isolate identity, data, secrets, quotas, billing, deployment rights, and blast radius across development, verification, and production. Separate Firebase/GCP projects are a strong reference pattern; a shared project requires proof of equivalent boundaries and an approved exception.
-   **Structure**:
    ```
    myapp-dev      → Development (free testing)
    myapp-staging  → Staging (production-equivalent config)
    myapp-prod     → Production (strict IAM controls)
    ```

### Rule 32.2: GCP Project Configuration
-   **Mandate**: Place every Firebase project, as a GCP project, inside a continuity-safe ownership, resource-hierarchy, billing, policy, and identity boundary. For enterprise use, align Organization, Folder, Project, and group-based IAM boundaries to teams, environments, jurisdictions, compliance, and shared services. Do not force unnecessary folders or dedicated teams on individual or small-scale use; when selecting project-level controls, still record ownership transfer, leaver handling, billing, break-glass, and a future path into an Organization.
-   **Configuration**:
    -   **Hierarchy**: Verify Organization, Folder, and Project policy inheritance and exception scope; do not silently treat one giant project or a personally owned project as a team boundary.
    -   **Identity**: Where supported, grant continuing human access to managed groups and job functions rather than individual bindings, separating workload identities, CI, and break-glass access.
    -   **Billing Account**: Attribute costs to environments, services, teams, and cost centers, separating production and non-production budgets and abuse controls according to risk.
    -   **API Enablement**: Explicitly enable required APIs (`firebase.googleapis.com`, `run.googleapis.com`, `artifactregistry.googleapis.com`, etc.).

### Rule 32.3: Region Selection
-   **Mandate**: Select regions by user distribution, data residency, inter-service latency, availability, carbon, price, recovery, and location compatibility; record the decision in an ADR.
-   **Caution**: For data services with post-creation move constraints, design migration, replication, backup, and exit before initial creation.
-   **Dynamic Availability**: GPU, runtime, multi-region, and service availability change; revalidate the official region matrix at deployment.

### Rule 32.4: Billing Plan Fitness
-   **Mandate**: Verify the billing plan, free tier, billing units, quotas, and suspension behavior required by adopted capabilities. Do not infer a universal Firebase plan requirement from capabilities such as App Hosting that require a usage-based plan.
-   **Action**: Before enabling usage-based billing, configure budget alerts, quotas, abuse controls, a cost owner, emergency degradation, and billing export. Alerts alone are not a hard cap.

---

## §2. Cloud Run Functions (formerly Cloud Functions 2nd Gen)

### Rule 32.5: Cloud Run Functions Standardization
-   **Mandate**: New functions use a currently recommended generation that satisfies runtime, trigger, latency, duration, network, observability, and cost needs. New adoption of a legacy generation requires a time-bound exception.
-   **Advantage**:
    -   High performance via Cloud Run infrastructure (up to 32GB RAM, 8 vCPU)
    -   Concurrency support (default 80, max 1000)
    -   125+ event sources via Eventarc
    -   Traffic splitting and revision rollback
    -   HTTP functions can run up to 1 hour
-   **Supported Runtimes**: At deployment, verify the official runtime list and EOL, then pin a version according to `engineering/320_programming_language_governance.md`, team capability, and library compatibility.

### Rule 32.6: Cold Start Mitigation
-   **Mandate**: For a latency-sensitive function, measure cold-start rate, p95 and p99, traffic shape, dependency initialization, and idle cost, then select controls that meet the SLO and cost budget.
-   **Strategies**:
    1.  **Min Instances**: Configure minimum instances only in an environment where measured SLOs require them and an owner accepts idle billing. Do not apply them universally to test or low-traffic workloads.
    2.  **Concurrency**: Load-test a value that fits handler and SDK request safety, CPU, memory, and downstream capacity.
    3.  **Instance Reuse**: Safely reuse immutable clients, connection pools, or models, testing credential refresh, stale state, and connection limits.
    4.  **Initialization**: Profile the critical path and compare lazy loading, artifact reduction, and connection reuse.
    5.  **No Synthetic Warmup Default**: Do not use scheduler pings as the normal cold-start control. Compare them with minimum instances, architecture change, and SLO relaxation, and treat adoption as a time-bound exception.

### Rule 32.7: Runtime Configuration
-   **Mandate**: Decide memory, CPU, timeout, concurrency, minimum and maximum instances, and region from workload measurements, downstream limits, SLOs, cost, and provider defaults. When retaining a default, record the reason and resolved value as evidence.
-   **Configuration**:
    ```typescript
    export const processOrder = onRequest({
      region: "asia-northeast1",
      memory: "512MiB",
      timeoutSeconds: 120,
      minInstances: 0,
      maxInstances: 100,
      concurrency: 80,
      cpu: 1,
    }, handler);
    ```
-   **Guidelines**: The following are non-normative observation starting points before load testing, not release defaults.
    | Use Case | Memory | Timeout | Min Instances | Concurrency |
    |---|---|---|---|---|
    | API Endpoint | 256-512MiB | 60s | 1 | 80 |
    | Image Processing | 1-2GiB | 300s | 0 | 10 |
    | Batch Processing | 2-4GiB | 540s | 0 | 1 |
    | Webhook Receiver | 256MiB | 30s | 0 | 80 |
    | AI Inference (CPU) | 4-8GiB | 300s | 0 | 4 |
    | Genkit AI Flow | 1-2GiB | 120s | 0-1 | 20 |

### Rule 32.8: Function Organization
-   **Mandate**: Split functions into modules or codebases along ownership, dependency, deployment and rollback, blast radius, and build-time boundaries. Codebases are a candidate where independent lifecycle creates value.
-   **Illustrative Structure**:
    ```
    functions/
    ├── src/
    │   ├── api/          # HTTP API functions
    │   ├── triggers/     # Firestore triggers
    │   ├── scheduled/    # Scheduled functions
    │   ├── pubsub/       # Pub/Sub triggers
    │   ├── tasks/        # Cloud Tasks handlers
    │   ├── genkit/       # Genkit AI flows
    │   └── shared/       # Common utilities
    ├── package.json
    └── tsconfig.json
    ```
-   **Deployment**: Do not split by a fixed function count. Measure provider quotas, deployment duration, failure isolation, and the change graph, then define retryable deployment groups.

### Rule 32.9: Idempotency Implementation
-   **Mandate**: Design an event handler subject to redelivery or retry as idempotent or duplicate-safe, defining guarantees and recovery per side effect.
-   **Protocol**:
    1.  **Atomic Claim**: Never use a read-then-write processed check. Atomically claim the idempotency key with a transaction or create-if-absent operation and store status, lease owner, expiry, attempt, and result reference.
    2.  **External Side Effect**: Reuse the receiving provider's idempotency key for payments, email, or webhooks, or use a transactional outbox or inbox and reconciliation. Writing a database marker only after an external call leaves a crash window.
    3.  **Lease Recovery**: Define timeout and fencing for safely reclaiming a stuck `processing` claim and make a completed result reusable.
    4.  **Failure Test**: Fault-inject concurrent delivery, crash immediately after claim, timeout after external success, marker-write failure, and reordering.

### Rule 32.10: 1st Gen → Cloud Run Functions Migration
-   **Mandate**: Legacy functions have a time-bound migration plan based on official support deadlines, security, runtimes, trigger compatibility, and cost, with gradual movement to a validated target generation.
-   **Migration Tool**: Treat a current supported GCP migration tool as a candidate and review generated diffs, triggers, IAM, and rollback.
-   **Breaking Changes**: Note trigger syntax changes due to Eventarc integration.

### Rule 32.11: onCallGenkit Trigger
-   **Mandate**: Use `onCallGenkit` trigger when deploying Genkit AI flows as Callable Functions.
-   **Benefit**: Automatic Firebase App Check integration, Firebase Auth verification, type-safe request/response.
    ```typescript
    import { onCallGenkit } from "firebase-functions/https";
    import { genkit } from "genkit";
    
    const ai = genkit({ plugins: [googleAI()] });
    
    const summarizeFlow = ai.defineFlow("summarize", async (input: string) => {
      const { text } = await ai.generate({ prompt: `Summarize: ${input}` });
      return text;
    });
    
    export const summarize = onCallGenkit(
      { enforceAppCheck: true },
      summarizeFlow
    );
    ```

---

## §3. Cloud Run Services & Jobs

### Rule 32.12: Cloud Run Functions vs Cloud Run Services Decision Matrix
-   **Mandate**: Choose appropriately based on processing requirements.
-   **Decision Matrix**:
    | Requirement | Cloud Run Functions | Cloud Run Services |
    |---|---|---|
    | Firebase Event Triggers | ✅ Optimal | ❌ Not suited |
    | Lightweight Webhooks | ✅ Optimal | ○ Possible |
    | Complex API (Multi-route) | △ Limited | ✅ Optimal |
    | Docker/Custom Runtime | ❌ Not possible | ✅ Optimal |
    | Batch Processing (Long) | △ Max 1h | ✅ Max 24h |
    | WebSocket/gRPC/SSE | ❌ Not possible | ✅ Optimal |
    | GPU (AI Inference) | ❌ Not possible | ✅ L4 GPU GA |
    | Genkit AI Flows | ✅ onCallGenkit | ✅ HTTP Server |

### Rule 32.13: Cloud Run Services Design
-   **Mandate**: Cloud Run Services must be stateless and containerized.
-   **Best Practices**:
    1.  **Language & Artifact Contract**: Cloud Run Services may use any language whose image satisfies the container contract. Distinguish source-deployed managed runtimes and buildpacks from custom containers, binding the base image, Linux ABI and architecture, listening address and `PORT`, dependencies, SBOM, patch responsibility, and runtime EOL to the artifact. Do not mistake the managed runtime list for Cloud Run Functions as the language ceiling for Cloud Run Services.
    2.  **Stateless**: Do not treat local memory or the ephemeral filesystem as durable state shared across instances. Store authoritative state in an external service selected for consistency, latency, and cost; Firestore, Cloud SQL, and Redis are candidates.
    3.  **Startup Budget**: Define and measure a Blueprint startup budget from CPU/GPU, image size, dependencies, traffic, minimum instances, and SLO.
    4.  **Health Check**: Implement a startup/liveness probe or equivalent signal appropriate to current Cloud Run health mechanisms and application semantics. Do not require one fixed path.
    5.  **Graceful Shutdown**: Handle SIGTERM, request draining, checkpoints, and connection closure within the current termination contract, measuring the cleanup budget.

### Rule 32.14: Cloud Run GPU Support (GA)
-   **Mandate**: When an AI/ML workload needs GPUs, compare model fit, latency, throughput, startup, region, quota, drivers, security, cost, and fallback, and evaluate Cloud Run GPU as a candidate. Do not mandate it when CPU, managed AI, batch, or another platform fits better.
-   **Features**:
    -   Per-second billing, scale-to-zero support
    -   Approximately 5-second startup (pre-installed drivers)
    -   Cloud Run SLA applies
-   **Use Cases**: LLM inference, image generation, video transcoding, batch AI processing
-   **Configuration**:
    ```yaml
    # Cloud Run Service with GPU
    metadata:
      annotations:
        run.googleapis.com/gpu-type: nvidia-l4
    spec:
      containers:
        - resources:
            limits:
              nvidia.com/gpu: "1"
              memory: "16Gi"
              cpu: "4"
    ```
-   **Availability**: Revalidate GPU types, regions, quotas, and limits against current official documentation and project settings at deployment.

### Rule 32.15: Cloud Run Jobs
-   **Mandate**: Use Cloud Run Jobs for run-to-completion batch processing.
-   **Use Cases**: Data export, report generation, bulk email, data migration, batch AI inference.
-   **Configuration**:
    ```yaml
    taskCount: 10        # Parallel tasks
    maxRetries: 3        # Retry count
    timeout: 3600s       # Timeout (max 24h)
    ```

---

## §4. Event-Driven Design (Eventarc / Pub/Sub / Cloud Tasks)

### Rule 32.16: Asynchronous Processing Principle
-   **Mandate**: Offload heavy processing to asynchronous execution to minimize user wait time.
-   **Anti-Pattern**: Synchronously executing external API calls, email sending, or image processing within Cloud Run Functions.

### Rule 32.17: Pub/Sub Design Patterns
-   **Mandate**: Use Pub/Sub for loosely coupled inter-service communication.
-   **Best Practices**:
    1.  **Push vs Pull**: Push delivery for serverless, Pull delivery for always-on services.
    2.  **Exactly-Once Delivery**: Available with Pull subscriptions. Use Ordering Keys when message order matters.
    3.  **Filtering**: Reduce unnecessary message processing with subscription-level filtering.
    4.  **Batch Publishing**: Enable batching on the publisher side.
    5.  **Flow Control**: Configure on both publisher and subscriber sides.
    6.  **Dead Letter Topic**: Always configure a destination for messages exceeding retry limits.
    7.  **Message Size**: Max 10MB. Use Cloud Storage reference passing for larger payloads.

### Rule 32.18: Cloud Tasks
-   **Mandate**: Use Cloud Tasks for asynchronous tasks requiring rate control.
-   **Best Practices**:
    1.  **Concurrency Control**: Control concurrent execution to downstream services.
    2.  **Exponential Backoff**: Always configure exponential backoff with jitter.
    3.  **IAM Security**: Apply IAM policies for task creation and consumption.
    4.  **Scheduled Execution**: Configure tasks for execution at specific future times.
    5.  **Deduplication**: Include unique IDs in task names for idempotency.

### Rule 32.19: Eventarc
-   **Mandate**: Use Eventarc for event-driven processing from GCP services.
-   **Supported Sources**: Cloud Audit Logs, Cloud Storage, Firestore, Firebase Authentication, BigQuery, Cloud SQL, and 125+ event sources.
-   **Advanced Channel**: Use Eventarc Advanced channels for publishing custom events.

### Rule 32.20: Cloud Scheduler
-   **Mandate**: Use Cloud Scheduler for periodic tasks.
-   **Integration Pattern**:
    ```
    Cloud Scheduler → Pub/Sub Topic → Cloud Run Functions/Services
    Cloud Scheduler → Cloud Tasks Queue → Cloud Run
    Cloud Scheduler → HTTP Endpoint → Cloud Run Functions (warmup)
    ```

### Rule 32.21: Cloud Workflows
-   **Mandate**: Use Cloud Workflows to orchestrate multiple GCP services with sequence control.
-   **Use Cases**: Approval flows, multi-step data processing, Saga Pattern implementation.
-   **Benefit**: State management, error handling, and retries can be defined declaratively.

---

## §5. Firebase Authentication Strategy

### Rule 32.22: Authentication Provider Policy
-   **Mandate**: When Firebase Authentication is adopted, define authority boundaries between identity profiles and domain data, UID mapping, account deletion, export, and migration to another identity platform. Select the domain data store under Primary Directive 0.1.
-   **Selection Matrix**: The following are candidate examples, not a Universal priority. Select from user population, platform policy, account recovery, MFA, enterprise federation, privacy, cost, and migration.
    | Provider | Representative use | Applicability |
    |---|---|---|
    | Google Sign-In | Consumer or workspace identity | Fits target users and platform |
    | Apple Sign-In | Apple platform | Required by App Store policy and adopted login mix |
    | Email/Password | Password-based identity | Recovery, breach defense, and MFA are operable |
    | Phone (SMS) | Phone verification or fallback | SIM-swap, cost, and regional delivery are accepted |
    | Anonymous | Guest access | Lifecycle, abuse, linking, and cleanup are designed |
    | SAML/OIDC | Enterprise federation | Tenant discovery, claim mapping, and offboarding are designed |
-   **Default Deny**: Firestore requires authentication and authorization by default. Intentional public content must prove scope, rate limiting, abuse controls, and absence of PII through Security Rules and tests.

### Rule 32.23: Passkeys / FIDO2 Support
-   **Mandate**: Recommend Passkeys (FIDO2) adoption for passwordless authentication.
-   **Implementation**: Use Firebase Authentication with Identity Platform (GCIP) `Passkey` provider.
-   **Benefit**: Phishing resistance, elimination of password list attacks, improved user UX.

### Rule 32.24: Custom Claims
-   **Mandate**: Limit Custom Claims to coarse, stable authorization attributes whose token size and refresh delay are acceptable. Do not use them as the source of truth for frequently changing permissions, subscription state, or resource membership; combine them with a database or policy service as appropriate.
-   **Rules**:
    1.  Set only via Admin SDK (setting from client is prohibited).
    2.  Payload limited to 1000 bytes.
    3.  Changes are not reflected until token refresh, so design permission removal, emergency revocation, and acceptable stale-claim duration from risk. Do not set one Universal grace period.
    ```typescript
    // Admin SDK: Set custom claims
    await admin.auth().setCustomUserClaims(uid, {
      role: "admin",
      plan: "premium",
    });
    ```

### Rule 32.25: Token Management and Session Design
-   **Mandate**: Design ID and refresh token TTL, renewal, revocation, and reauthentication from current official contracts and risk; test client clocks, revocation delay, and offline behavior.
-   **Security**:
    1.  Use a surface-appropriate mechanism such as secure, HTTP-only, SameSite cookies on web, OS secure storage on native, or SDK-managed sessions. Do not place high-privilege tokens in general storage readable by arbitrary scripts.
    2.  Revoke refresh tokens on account compromise and apply `checkRevoked`, Security Rules, or an equivalent revocation check at high-risk backends. Existing ID tokens are short-lived but stateless; do not assume a revocation call makes every resource reject them immediately.
    3.  Require Multi-Factor Authentication (MFA) for admin and high-privilege users.

### Rule 32.26: Authentication Event Monitoring
-   **Mandate**: Stream authentication events (login, failure, account creation) to Cloud Logging for unauthorized access detection.
-   **Detectable Events**: Abnormal login frequency, geographic anomalies, brute force patterns.

---

## §6. App Check & App Authentication

### Rule 32.27: App Check Applicability
-   **Mandate**: Evaluate and adopt App Check for supported application surfaces and backends according to the threat model and client compatibility. Observe legitimate traffic attestation and failure impact before enforcement.
-   **Attestation Providers**:
    | Platform | Provider | Recommended |
    |---|---|---|
    | Android | Play Integrity API | ✅ |
    | iOS | App Attest (Device Check) | ✅ |
    | Web | reCAPTCHA Enterprise | ✅ |
-   **Enforcement Mode**: Move to staged enforcement after legitimate-traffic success, unsupported clients, false rejection, and rollback meet Blueprint criteria.

### Rule 32.28: App Check for Custom Backends
-   **Mandate**: Verify App Check tokens on a custom backend called from Firebase clients where supported SDKs, client compatibility, and the threat model fit. Do not force it onto server-to-server calls, unsupported clients, or third-party webhooks; select controls such as IAM, OAuth, mTLS, signatures, and rate limiting for those surfaces.
    ```typescript
    import { getAppCheck } from "firebase-admin/app-check";
    
    async function verifyAppCheck(req: Request): Promise<boolean> {
      const appCheckToken = req.headers["x-firebase-appcheck"];
      if (!appCheckToken) return false;
      
      try {
        await getAppCheck().verifyToken(appCheckToken as string);
        return true;
      } catch {
        return false;
      }
    }
    ```

### Rule 32.29: Replay Protection
-   **Mandate**: Enable App Check Token Replay Protection for high-security operations (payments, personal info changes).
-   **Caution**: Replay Protection requires a new token each time, increasing latency. Not needed for general API calls.

---

## §7. Firestore Design & Security Rules

### Rule 32.30: Firestore Usage Restriction
-   **Mandate**: Use Firestore for data domains that pass Primary Directive 0.1 capability evaluation and have Security Rules, IAM, indexes, quotas, cost, backup, export, and retention designed.
-   **Representative Use Cases**:
    1.  Data requiring real-time listeners (presence, chat, etc.).
    2.  Maintenance of existing Firestore collections.
    3.  Firebase-related configuration data (Remote Config metadata, etc.).

### Rule 32.31: Security Rules Mandatory Pattern
-   **Mandate**: Configure Security Rules on all Firestore databases. Apply Default Deny pattern.
-   **Default Deny**:
    ```
    rules_version = '2';
    service cloud.firestore {
      match /databases/{database}/documents {
        // Default: deny all access
        match /{document=**} {
          allow read, write: if false;
        }
        
        // Only define explicitly permitted paths
        match /users/{userId} {
          allow read: if request.auth != null && request.auth.uid == userId;
          allow write: if request.auth != null && request.auth.uid == userId
            && request.resource.data.keys().hasAll(['name', 'email'])
            && request.resource.data.name is string
            && request.resource.data.name.size() <= 100;
        }
      }
    }
    ```

### Rule 32.32: Security Rules Best Practices
-   **Rules**:
    1.  **Default Deny and Explicit Authorization**: Start from default deny and validate subject, resource, action, tenant, fields, time, and other relevant attributes for every allowed path. For intentional public reads, prove narrow scope, absence of PII, abuse and cost controls, and tests rather than mechanically adding `request.auth != null` to every path.
    2.  **Schema Validation**: Validate type, value, and size of `request.resource.data`.
    3.  **Custom Claims Validation**: Control admin operations with `request.auth.token.role == 'admin'`.
    4.  **Functions**: Use Security Rules Functions for reusable rule logic.
    5.  **Testing Required**: Test all rules with `@firebase/rules-unit-testing` (see §31).
    6.  **Version Control**: Security Rules files must be under Git management.

### Rule 32.33: Firestore Query Optimization
-   **Mandate**: Always consider performance and cost when writing Firestore queries.
-   **Rules**:
    1.  **Bounded Reads**: User-controlled, collection-wide, or repeatedly executed reads require a limit, cursor, termination condition, and quota. Do not force unnecessary pagination on unique-key or demonstrably bounded reads; prove the maximum result count in the data contract.
    2.  **Cursor-based Pagination**: Use `startAfter()`/`endBefore()`.
    3.  **Composite Indexes**: Explicitly define indexes for composite queries.
    4.  **Document Budget**: Define the document-size budget in Blueprint from access patterns, update contention, index fanout, network, and offline requirements; do not use a fixed 10KB Universal target.
    5.  **Collection Shape**: Select subcollections, references, or denormalization from query, transaction, deletion, Security Rules, and cost trade-offs rather than mandating one nesting pattern.
    6.  **Caching**: Enable offline persistence and cache indexes only after evaluating device trust, shared-device privacy, freshness, storage, and query profiles.
    7.  **Hotspot Avoidance**: On high-write paths, load-test hotspots from sequential keys, single documents, or narrow key ranges and adopt distributed IDs or sharding where needed.

---

## §8. Firebase Data Connect (Cloud SQL) — GA

### Rule 32.34: Data Connect Overview
-   **Mandate**: Firebase Data Connect (GA April 2025) is a BaaS service built on Cloud SQL PostgreSQL. Consider for use when SQL-based backend is needed.
-   **Features**:
    -   GraphQL-based schema definition and query language
    -   Relational data model Firebase integration
    -   AI-assisted onboarding and schema generation
    -   Client access via Firebase SDK (Web, iOS, Android, Flutter)
-   **Caution**: Compare Data Connect, Firestore, Cloud SQL, Supabase, and other candidates with the same matrix for data model, authorization boundary, SDK integration, operations, lock-in, and cost; do not decide solely because one vendor already exists.

### Rule 32.35: Relational Backend Capability Decision
-   **Decision Contract**: Compare Data Connect, Supabase, Cloud SQL, and other relational backends with the same evidence, without making one vendor the default winner.

    | Decision Axis | Required Evidence |
    |---|---|
    | Data ownership | authoritative store, replication, export, retention, deletion |
    | Authorization | client or server boundary, row or field controls, testability, admin path |
    | Contract | schema, generated SDK, transactions, migrations, backward compatibility |
    | Runtime integration | supported client or server runtimes, offline or realtime, network path |
    | Operations | backup or restore, observability, SLO, incident response, team permissions |
    | Economics and exit | usage-based cost, egress, lock-in, migration proof, sunset plan |

---

## §9. Cloud Storage for Firebase

### Rule 32.36: Storage Design Principles
-   **Mandate**: When Cloud Storage for Firebase is selected, design object ownership, public or private boundaries, retention, malware controls, metadata, egress, restoration, and exit. Select file storage through the capability evaluation in §0.1 and `engineering/520_cloud_application_platforms.md`; do not force this service on every project.
-   **Architecture**:
    1.  **Bucket Separation**: Separate buckets by purpose (e.g., `user-uploads`, `public-assets`, `backups`).
    2.  **Security Rules**: Control file access with Storage Security Rules (auth required, file size limits, MIME type validation).
    3.  **Lifecycle Rules**: Configure automatic deletion and storage class transitions for unnecessary files.

### Rule 32.37: Storage Security Rules
-   **Mandate**: Configure Security Rules on all buckets.
    ```
    rules_version = '2';
    service firebase.storage {
      match /b/{bucket}/o {
        match /{allPaths=**} {
          allow read, write: if false; // Default Deny
        }
        
        match /users/{userId}/{allPaths=**} {
          allow read: if request.auth != null && request.auth.uid == userId;
          allow write: if request.auth != null && request.auth.uid == userId
            && request.resource.size < 10 * 1024 * 1024  // 10MB limit
            && request.resource.contentType.matches('image/.*');
        }
      }
    }
    ```

### Rule 32.38: Image Optimization Pipeline
-   **Mandate**: Build an automatic optimization pipeline for user-uploaded images.
-   **Architecture**:
    ```
    Upload → Cloud Storage → Eventarc Trigger → Cloud Run Functions (Resize/Compress) → Optimized Storage
    ```
-   **Alternative**: Use Firebase Extensions "Resize Images" for automatic thumbnail/medium/large generation.

### Rule 32.39: Resumable Upload
-   **Mandate**: Adopt resumable or multipart upload when file size, network instability, mobile background behavior, provider thresholds, and retransmission cost make failure material. Define any fixed size threshold in Blueprint.

---

## §10. Firebase Hosting & App Hosting (GA)

### Rule 32.40: Firebase Hosting (Static Sites)
-   **Mandate**: Use Firebase Hosting for static sites, SPAs, and JAMStack.
-   **Features**:
    -   Global CDN (Firebase CDN)
    -   Automatic SSL certificates
    -   One-click rollback
    -   Preview Channels (per-PR preview environments)
-   **Configuration**:
    ```json
    {
      "hosting": {
        "public": "dist",
        "ignore": ["firebase.json", "**/.*", "**/node_modules/**"],
        "rewrites": [
          { "source": "**", "destination": "/index.html" }
        ],
        "headers": [
          {
            "source": "**/*.@(js|css)",
            "headers": [
              { "key": "Cache-Control", "value": "public, max-age=31536000, immutable" }
            ]
          }
        ]
      }
    }
    ```

### Rule 32.41: App Hosting (GA — SSR Applications)
-   **Mandate**: Evaluate App Hosting as an SSR/SSG candidate when Firebase integration, automated build and rollout, framework support, region, observability, cost, and rollback fit the requirements. Never mandate it for every Next.js or Angular project.
-   **Features**:
    -   Automatic rollout via GitHub integration
    -   SSR content delivery on Cloud Run
    -   Static content caching via Cloud CDN
    -   Instant rollback
    -   Multi-region support (Asia/Europe expansion)
    -   Wildcard domain support
    -   VPC network connectivity
    -   Automatic Firebase SDK initialization simplification
    -   Build debug UI
-   **Supported Frameworks**: Verify the current official framework and version matrix at deployment.
-   **Cost**: Confirm billing boundaries for the required billing plan, build, runtime, and bandwidth; design guardrails knowing budget alerts are not hard caps.

### Rule 32.42: Hosting vs App Hosting Selection Criteria
-   **Decision Matrix**:
    | Requirement | Firebase Hosting | App Hosting |
    |---|---|---|
    | SPA (React/Vue/Svelte) | ✅ Optimal | ❌ Not needed |
    | Next.js SSR | ❌ Not possible | ✅ Optimal |
    | Angular SSR/SSG | △ SSG only | ✅ Optimal |
    | Static Site | ✅ Optimal | ❌ Not needed |
    | Custom Server | ❌ Not possible | ✅ Cloud Run |
    | Preview Channels | ✅ Supported | ✅ Supported |

---

## §11. FCM (Push Notification) Strategy

### Rule 32.43: FCM HTTP v1 API Mandatory
-   **Mandate**: FCM Legacy API is deprecated. All push notifications must use **FCM HTTP v1 API**.
-   **Advantages**: Rich content, platform-specific customization, Analytics integration, OAuth 2.0 authentication.
-   **Implementation**:
    ```typescript
    import { getMessaging } from "firebase-admin/messaging";
    
    const message = {
      notification: { title: "New Notification", body: "You have a message" },
      android: { notification: { channelId: "default" } },
      apns: { payload: { aps: { badge: 1, sound: "default" } } },
      webpush: { notification: { icon: "/icon.png" } },
      token: deviceToken,
    };
    
    await getMessaging().send(message);
    ```

### Rule 32.44: FCM Token Management
-   **Mandate**: Implement proper lifecycle management for FCM tokens.
-   **Rules**:
    1.  **Token Refresh**: Retrieve tokens on app launch and store the latest token on the server.
    2.  **Invalid Token Cleanup**: Detect send errors (`messaging/registration-token-not-registered`) and delete invalid tokens from DB.
    3.  **Periodic Cleanup**: Derive a Blueprint retention period from provider staleness guidance, send results, app usage cycles, and privacy/retention requirements; progressively invalidate and delete stale tokens.
    4.  **Topic Messaging**: Use Topic Messaging for large-scale broadcasts.
    5.  **Multi-device**: Use Condition Messaging to deliver to all user devices.

### Rule 32.45: FCM Delivery Optimization
-   **Mandate**: Continuously improve notification CTR and delivery quality.
-   **Strategies**:
    1.  **Segmented Delivery**: Target delivery with Firebase Audiences + Analytics.
    2.  **A/B Testing**: A/B test notification copy with Remote Config.
    3.  **Frequency Control**: Control per-user notification frequency to prevent fatigue.
    4.  **Silent Notifications**: Use silent notifications (`data` messages) for data sync.

---

## §12. Remote Config & Feature Flags

### Rule 32.46: Remote Config Strategy
-   **Mandate**: Use Firebase Remote Config to change dynamic settings without app deployment.
-   **Use Cases**:
    1.  **Feature Flags**: Gradual rollout of new features.
    2.  **Kill Switch**: Instant disabling of problematic features.
    3.  **A/B Testing**: Experiments with Google Analytics integration.
    4.  **Personalization**: Setting changes based on user attributes.
    5.  **Environment Config**: Environment-dependent settings like API URLs.
    6.  **AI Feature Control**: Model switching/disabling of AI features.

### Rule 32.47: Remote Config Best Practices
-   **Rules**:
    1.  **Default Values**: Always set hard-coded defaults in-app. Fallback for network failures.
    2.  **Fetch Frequency**: Respect minimum fetch interval (default 12 hours, shorter for development).
    3.  **Real-time Config**: Use Real-time Remote Config listeners when real-time updates are needed.
    4.  **Conditional Settings**: Branch by user attributes, version, platform.
    5.  **Server-side Config**: Use Remote Config server-side API in Cloud Run Functions.

---

## §13. Crashlytics & Stability Monitoring

### Rule 32.48: Crashlytics Applicability
-   **Mandate**: A mobile application that adopts Crashlytics links release artifacts, symbols, versions, environments, and privacy-safe context, and avoids accidental duplicate telemetry with another crash platform.
-   **Configuration**:
    1.  **dSYM Upload**: Auto-upload dSYMs at build time for iOS.
    2.  **Proguard Mapping**: Upload Proguard/R8 mapping files for Android.
    3.  **Non-Fatal Errors**: Record non-critical errors with `recordError()`.
    4.  **Custom Keys**: Set custom keys useful for debugging (user ID, screen name, etc.).
    5.  **Breadcrumbs**: Record breadcrumbs of user actions.

### Rule 32.49: Crash-Free Rate Target
-   **Mandate**: Define crash-free users or sessions, severity, and affected cohorts as a service SLO in Blueprint, with release stop, rollback, and incident criteria for a breach. Do not mandate one fixed rate for every application.
-   **Monitoring**: Configure Crashlytics Alerts to instantly detect new crash clusters.

---

## §14. Performance Monitoring

### Rule 32.50: Performance Monitoring Configuration
-   **Mandate**: When Firebase Performance Monitoring is adopted, measure key user-journey performance and correlate it with platform-wide SLIs.
-   **Tracked Metrics**:
    1.  **App Start Time**: Measure cold and warm starts by device, OS, and network cohort.
    2.  **HTTP Response Time**: Measure API p50, p95, p99, and error rate.
    3.  **Screen Rendering**: Measure slow or frozen frames and key-screen render time.
    4.  **Network Payload Size**: Detect oversized response sizes.
-   **Custom Traces**: Set custom traces for business-critical operations (login, payment, search).

---

## §15. Google Analytics for Firebase

### Rule 32.51: Analytics Integration
-   **Mandate**: Measure only the minimum events needed for explicit product/business outcomes, with data classification, lawful basis/consent, retention, deletion, access, sampling, and cost. Google Analytics for Firebase is a candidate; prohibit collection of every action or attribute.
-   **Configuration**:
    1.  **Event Contract**: Register event name, purpose, owner, property schema, PII prohibition, retention, and downstream consumers.
    2.  **Automatic Events**: Inventory provider-collected fields and defaults, disabling unnecessary collection or preventing transmission before consent.
    3.  **User Properties**: Avoid casual use of sensitive attributes, precise location, or persistent identifiers; assess cohort re-identification risk.
    4.  **Validation**: In debug/staging, verify schema, duplicates, consent state, deletion, and export cost.
-   **Privacy**: Design consent, opt-out, deletion, and data-processing terms for applicable law, region, age, and platform policy; Consent Mode alone is not proof of legal compliance.

---

## §16. Firebase AI Logic & Genkit

### Rule 32.52: Firebase AI Logic Overview
-   **Mandate**: When a client connects to generative AI, evaluate Firebase AI Logic as a candidate against models, regions, data use, App Check, authorization, rates, safety, evaluation, cost, and the responsibility difference from a server proxy.
-   **Features**:
    -   Direct access to Gemini Developer API (free tier available) and Vertex AI API
    -   AI endpoint protection via App Check integration
    -   Gemini 3.1 Lite / 3.1 (Preview) support
    -   Hybrid inference (on-device model + cloud model auto-fallback)
    -   Image generation (Imagen model integration)
    -   Unity / Android XR support
-   **Architecture**:
    ```
    Client App → Firebase AI Logic SDK → App Check → Gemini API / Vertex AI API
    ```

### Rule 32.53: Genkit Framework
-   **Mandate**: Genkit is a candidate AI workflow framework. Adopt it only after comparing model portability, evaluation, observability, tool security, runtimes, team support, and exit under the AI authority.
-   **Language Support**: Revalidate supported Node.js, Go, Python, or other versions, status, feature parity, and EOL against current official documentation at adoption and upgrade.
-   **Core Features**:
    -   Unified model API (Gemini, OpenAI, Anthropic, Ollama, multi-provider)
    -   Type-safe AI flow definitions
    -   Tool Calling / Function Calling
    -   RAG (Retrieval-Augmented Generation)
    -   Multimodal support (text, image, audio, video)
    -   Genkit Developer UI for debugging, testing, and observability
    -   `onCallGenkit` trigger for Callable Functions integration (see §2)

### Rule 32.54: Genkit Flow Design
-   **Mandate**: Ensure reproducibility, testability, and observability for AI flows.
-   **Pattern**:
    ```typescript
    import { genkit, z } from "genkit";
    import { googleAI, gemini20Flash } from "@genkit-ai/googleai";
    
    const ai = genkit({ plugins: [googleAI()] });
    
    const summarizeFlow = ai.defineFlow(
      {
        name: "summarize",
        inputSchema: z.object({ text: z.string(), maxLength: z.number().optional() }),
        outputSchema: z.object({ summary: z.string(), confidence: z.number() }),
      },
      async (input) => {
        const { output } = await ai.generate({
          model: gemini20Flash,
          prompt: `Summarize the following text in ${input.maxLength ?? 200} characters:\n${input.text}`,
          output: { schema: z.object({ summary: z.string(), confidence: z.number() }) },
        });
        return output!;
      }
    );
    ```

### Rule 32.55: Genkit Tool Calling
-   **Mandate**: When Genkit is adopted and an LLM may access external data or execute actions, use Genkit Tool Calling or an equivalent typed tool contract without granting arbitrary code execution or unbounded permissions.
-   **Security**: Minimize tool execution permissions. Require input validation for tool calls based on user input.
    ```typescript
    const getWeatherTool = ai.defineTool(
      {
        name: "getWeather",
        description: "Get current weather for a city",
        inputSchema: z.object({ city: z.string() }),
        outputSchema: z.object({ temp: z.number(), condition: z.string() }),
      },
      async (input) => {
        const data = await fetchWeatherAPI(input.city);
        return { temp: data.temperature, condition: data.condition };
      }
    );
    ```

### Rule 32.56: AI Guardrails
-   **Mandate**: Always configure guardrails for AI features.
-   **Requirements**:
    1.  **Input Validation**: Sanitize user input, prevent prompt injection.
    2.  **Output Filtering**: Prevent harmful content, PII, sensitive info output (Safety Settings).
    3.  **Token Limits**: Set max tokens per request (cost runaway prevention).
    4.  **Rate Limiting**: Limit per-user AI API call frequency.
    5.  **Kill Switch**: Enable instant disabling of AI features via Remote Config (see §12).
    6.  **Human-in-the-Loop**: Require human review before executing high-risk AI outputs.

---

## §17. Vertex AI Integration

### Rule 32.57: Firebase × Vertex AI Integration
-   **Mandate**: Leverage Vertex AI for advanced AI capabilities.
-   **Services**:
    | Service | Use Case |
    |---|---|
    | Vertex AI Gemini API | Text and multimodal generation |
    | Vertex AI Agent Engine (GA) | AI agent deployment and management |
    | Vertex AI Imagen | Image generation and editing |
    | Vertex AI Search | Enterprise search |
    | Model Garden | Model catalog |

### Rule 32.58: Vertex AI Agent Engine (GA)
-   **Mandate**: Use Vertex AI Agent Engine for production AI agent deployment.
-   **GA Features (Dec 2025–Feb 2026)**:
    -   **Sessions GA**: Persistent conversation context
    -   **Memory Bank GA**: Memory and recall of past interactions
    -   **Code Execution GA**: Agent code execution (Feb 2026 GA)
    -   **Agent Development Kit (ADK)**: Agent development framework
    -   **Playground**: Test and evaluation environment
    -   **Observability**: Agent behavior monitoring
-   **Enterprise Security**: Private VPC deployment, CMEK (Customer-Managed Encryption Keys) support.

### Rule 32.59: Cloud Run GPU × AI Inference
-   **Mandate**: Leverage Cloud Run GPU (see §3) for low-latency AI inference.
-   **Architecture**:
    ```
    Client → Cloud Run Service (NVIDIA L4 GPU) → LLM/Image Model
    Client → Firebase AI Logic → Vertex AI API → Managed Inference
    ```
-   **Selection**: Choose between managed API (low ops burden) and self-hosted (customizability) based on latency requirements and cost efficiency.

---

## §18. AI Agent Security & Governance

### Rule 32.60: MCP (Model Context Protocol) Integration
-   **Mandate**: Genkit supports both MCP Client (consuming tools from external MCP servers) and MCP Server (exposing its own tools/flows externally). Configure security guardrails.
-   **MCP Client Mode**: Retrieve tools from external MCP servers for use in Genkit flows.
-   **MCP Server Mode**: Expose Genkit-defined flows and tools via MCP protocol, accessible from IDEs/AI agents.
-   **Security Requirements**:
    1.  **Authentication/Authorization**: Apply IAM and App Check for MCP server access.
    2.  **Data Access Restriction**: Explicitly restrict collections/fields accessible by agents.
    3.  **Audit Logging**: Log all agent operations.
    4.  **Rate Limiting**: Per-agent request limits.

### Rule 32.61: A2A (Agent-to-Agent) Protocol
-   **Mandate**: Use Google's A2A (Agent-to-Agent) open standard for AI agent collaboration across different frameworks (Genkit, LangGraph, etc.).
-   **Architecture**: HTTP + JSON-RPC 2.0 + Server-Sent Events (SSE) based.
-   **Use Cases**: Multi-agent workflows, cross-framework task delegation.

### Rule 32.62: AI Agent Autonomy Levels
-   **Mandate**: Classify AI agent autonomy into 5 levels and grant permissions incrementally.
    | Level | Name | Permission Scope |
    |---|---|---|
    | L1 | Assistant | Information presentation only |
    | L2 | Copilot | Suggestion + execution after approval |
    | L3 | Semi-Autonomous | Auto-execution of defined tasks |
    | L4 | Autonomous | Broad autonomous execution |
    | L5 | Full Autonomous | Fully autonomous (under human oversight) |

### Rule 32.63: AI FinOps
-   **Mandate**: Track and manage AI-related costs independently.
-   **Strategies**:
    1.  **Token Consumption Tracking**: Dashboard token usage via Genkit Monitoring.
    2.  **Budget Threshold**: Feature and FinOps owners define the AI budget, unit economics, growth rate, and anomaly threshold in Blueprint.
    3.  **Model Optimization**: Consider gradual migration to lower-cost models (Flash series).
    4.  **Labeling**: Apply `ai-feature` labels to AI-related resources for cost isolation.
    5.  **Context Caching**: Reduce token costs with Vertex AI Context Caching.

### Rule 32.64: EU AI Act Compliance
-   **Mandate**: Consider EU AI Act risk classification when implementing AI features.
-   **Requirements**:
    1.  **Risk Classification**: Classify AI features as low/limited/high risk.
    2.  **Transparency**: Clearly indicate AI-generated content.
    3.  **Auditability**: Record the basis for AI decision-making.

### Rule 32.65: App Testing Agent
-   **Mandate**: Leverage the App Testing Agent (Gemini-based, Preview) within Firebase App Distribution for test case generation, management, and execution.
-   **Use Cases**: Automated test case generation, regression testing, UI test automation.

---

## §19. Firebase Extensions Strategy

### Rule 32.66: Extensions Usage Policy
-   **Mandate**: For standard integrations, compare Firebase Extensions, managed integrations, and custom implementations by permissions, data flow, release cadence, support, cost, observability, and exit; supply-chain review third-party code and configuration.
-   **Candidate Examples**:
    | Extension | Use Case |
    |---|---|
    | Stream Firestore to BigQuery | Analytics platform for Firestore data |
    | Resize Images | Auto-resize uploaded images |
    | Translate Text | Automatic text translation |
    | Trigger Email | Email sending automation |
    | Delete User Data | User deletion data cleanup |

### Rule 32.67: Custom Extensions
-   **Applicability**: Package only work that is reused across environments/projects and can sustain an independent version, configuration contract, tests, owner, and upgrade/deprecation policy. Do not force one-off project logic into an extension.

---

## §20. BigQuery Integration & Data Analytics Platform

### Rule 32.68: Analytics Data Authority Boundary
-   **Mandate**: Define authoritative sources, warehouse/lakehouse, freshness, lineage, retention, deletion, access, and cost for analytics, billing, and operational telemetry. BigQuery is a strong candidate for GCP/Firebase workloads, but do not force universal consolidation or unnecessary duplication of sensitive data.
-   **Candidate Sources**:
    -   Firebase Analytics → BigQuery Export
    -   Firestore → BigQuery Extension
    -   Cloud Logging → BigQuery Sink
    -   Billing Data → BigQuery Export

### Rule 32.69: ELT Pattern
-   **Mandate**: Select ETL, ELT, or stream processing from latency, volume, privacy, source load, replay, and cost. If a raw zone exists, design immutability, encryption, access, retention, schema evolution, and deletion propagation; do not fix BigQuery or dbt as Universal implementation.
    ```
    Source → Raw Layer (BigQuery) → Staging Layer (dbt) → Mart Layer (dbt) → Dashboard
    ```

### Rule 32.70: Data Quality
-   **Mandate**: Embed automated quality tests in data pipelines.
-   **Tests**:
    1.  **Freshness**: Data freshness checks.
    2.  **Volume**: Detect record-volume anomalies with dynamic thresholds that account for weekday effects, seasonality, source baselines, and expected growth.
    3.  **Schema**: Automatic schema change detection.
    4.  **Null Check**: Null rate monitoring for required fields.

---

## §21. Security Defense-in-Depth (Zero Trust)

### Rule 32.71: Defense in Depth
-   **Mandate**: Implement security at all layers.
    ```
    Layer 1: App Check (App Authentication)
    Layer 2: Firebase Authentication (User Authentication)
    Layer 3: Security Rules / IAM (Access Control)
    Layer 4: VPC / Network Security (Network Control)
    Layer 5: Data Encryption
    Layer 6: Audit Logging
    Layer 7: Supply Chain Security
    ```

### Rule 32.72: Admin SDK Security
-   **Mandate**: Admin SDK bypasses Security Rules. Use only in trusted server environments.
-   **Requirements**:
    1.  **Least Privilege IAM**: Grant only minimum required roles.
    2.  **Credential Lifecycle**: Prefer keyless and short-lived identity. If a long-lived credential is unavoidable, automate rotation and immediate revocation from risk, provider capability, regulation, and incident-response needs.
    3.  **Environment Variable Management**: Manage key files with Secret Manager. Never commit to source code.

### Rule 32.73: OWASP Top 10 2025 Countermeasures
-   **Mandate**: Implement defenses against OWASP Top 10 2025 threats.
-   **Key Measures**:
    1.  **Injection Prevention**: Parameterized queries, input sanitization.
    2.  **XSS Prevention**: Content Security Policy (CSP) headers.
    3.  **CSRF Prevention**: SameSite Cookie settings, CSRF tokens.
    4.  **Broken Access Control**: Strict Security Rules and IAM application.
    5.  **SSRF Prevention**: Restrict external requests from Cloud Run Functions/Services.

---

## §22. IAM & Service Account Management

### Rule 32.74: Principle of Least Privilege
-   **Mandate**: All IAM roles must follow the principle of least privilege.
-   **Prohibited**: Do not grant broad basic roles such as `roles/owner` or `roles/editor` to normal production workload identities, CI identities, or permanent human access.
-   **Recommended**: Combine predefined roles at the smallest scope and create a version-controlled custom role only when needed. Review IAM Recommender output as evidence rather than applying it mechanically. Emergency owner access is separate, time-bound, strongly authenticated, approved, alerted, and audited.

### Rule 32.75: Service Account Management
-   **Mandate**: Separate workloads into service accounts when trust boundary, privilege, environment, lifecycle, or blast radius differs. Do not create an account per function unconditionally; avoid both identity sprawl and shared high privilege.
-   **Best Practices**:
    1.  **Boundary-aligned Accounts**: Separate production and non-production, runtime and deployment, and different data classes or privileges. Low-risk workloads with the same privileges, owner, and lifecycle may share an account with documented rationale.
    2.  **Keyless Authentication**: Use Workload Identity Federation to minimize service account key issuance.
    3.  **Periodic Audit**: Audit unused service accounts and keys using identity inventory, usage telemetry, risk, and compliance cadence, then disable and delete them safely.

### Rule 32.76: Workload Identity Federation
-   **Mandate**: Prefer short-lived federation such as Workload Identity Federation when connecting a supported external identity provider or CI system to GCP, restricting subject, repository or project, branch or environment, audience, and attribute conditions. If an unsupported path makes a long-lived key unavoidable, require a time-bound exception, least privilege, protected secret store, rotation, usage alerts, and revocation procedure.

---

## §23. Secret Manager & Sensitive Data Management

### Rule 32.77: Approved Secret Store Protocol
-   **Mandate**: Manage production and shared-environment secrets in an approved provider-native or organizational secret store with encryption, access control, versioning, audit, rotation, and revocation. Secret Manager is the default candidate for GCP workloads.
-   **Prohibited**: Do not store or emit secrets in source, container images, client bundles, version-controlled `.env` files, plaintext CI settings, or logs. If local-only `.env` files are used, apply ignore rules, separate samples, minimum scope, short-lived values, and leak scanning.

### Rule 32.78: Secret Management
-   **Best Practices**:
    1.  **Versioning**: Version-manage secrets for rollback capability.
    2.  **Auto-Rotation**: Define and automate rotation/revocation cadence in Blueprint from secret type, compromise impact, provider capability, and regulation. Revoke immediately after suspected compromise rather than waiting for cadence.
    3.  **Access Control**: Grant `roles/secretmanager.secretAccessor` only to required service accounts.
    4.  **CMEK**: Use Customer-Managed Encryption Keys (CMEK) when compliance requires.
    5.  **Audit**: Monitor Secret Manager access logs.

### Rule 32.79: Usage in Cloud Run Functions/Run
-   **Example**:
    ```typescript
    export const myFunction = onRequest(
      { secrets: ["API_KEY", "DB_PASSWORD"] },
      async (req, res) => {
        const apiKey = process.env.API_KEY;
        // Secrets are automatically injected as environment variables
      }
    );
    ```

---

## §24. VPC & Network Security

### Rule 32.80: VPC Service Controls
-   **Mandate**: Where supported services need a data-exfiltration, regulatory, or identity boundary, evaluate VPC Service Controls and introduce them gradually after validating dry run, the supported-service matrix, ingress and egress policy, break-glass, and observability.

### Rule 32.81: Private Google Access
-   **Mandate**: When resources without public IPs must reach Google APIs, evaluate Private Google Access or another approved private path and verify DNS, routes, egress, service support, and failure modes.

### Rule 32.82: Direct VPC Egress
-   **Mandate**: For Cloud Run Functions or Services that need private resources, compare Direct VPC egress, connectors, and alternate architectures by latency, throughput, IP behavior, cost, and availability.
-   **Configuration**: Select private-range-only or all-traffic behavior from the threat model, inspection, NAT, and external API reachability; never require routing all traffic unconditionally.

### Rule 32.83: Cloud Armor WAF
-   **Mandate**: Where the threat, traffic, and architecture of an internet-facing HTTP surface fit, evaluate a supported load-balancing path with Cloud Armor or another WAF and DDoS control. Verify bypass prevention if a direct endpoint remains.
-   **Architecture**: Cloud Run → Serverless NEG → Application Load Balancer → Cloud Armor Security Policy.
-   **Policy**:
    1.  **OWASP Top 10 WAF Rules**: Apply preconfigured rules for SQL Injection, XSS, etc.
    2.  **Adaptive Protection**: Automatic DDoS attack mitigation.
    3.  **Rate Limiting**: Limit malicious traffic patterns.
    4.  **Geo Restriction**: Geographic restrictions as needed.
    5.  **Bot Management**: Bot traffic detection and control.
-   **Testing**: Always evaluate new policies in "preview" mode before enforcement.

### Rule 32.84: Private Service Connect
-   **Applicability**: Where threat model, data exfiltration, compliance, or latency requires private connectivity, select Private Service Connect, private IP, VPC connectors, or a provider-supported equivalent by service support, DNS, egress, failover, and cost, and verify public bypass prevention.

---

## §25. FinOps & Cost Optimization

### Rule 32.85: Cost Allocation Principles
-   **Mandate**: Combine billing export, project/folder hierarchy, supported labels/tags, and service metadata so material cost is traceable to environment, service, owner, cost center, and feature. Maintain a mapping inventory and alternate allocation for resources that do not support labels.
-   **Candidate Dimensions**:
    | Label Key | Values (examples) | Purpose |
    |---|---|---|
    | `environment` | prod / staging / dev | Per-environment cost analysis |
    | `service` | api / worker / web | Per-service cost analysis |
    | `owner` | team-backend / team-frontend | Per-team cost allocation |
    | `cost-center` | engineering / marketing | Per-department cost allocation |
    | `ai-feature` | chatbot / recommendation | Per-AI-feature cost isolation |

### Rule 32.86: Firebase Cost Optimization
-   **Optimization Matrix**:

    | Service | Optimization Method |
    |---|---|
    | Firestore | Query optimization, client caching, pagination, Hotspot avoidance |
    | Cloud Run Functions | Cold start optimization, proper memory/timeout, `maxInstances` setting |
    | Cloud Storage | CDN usage, image compression, lifecycle rules, storage class optimization |
    | Authentication | Session management optimization, MAU monitoring |
    | FCM | Periodic cleanup of invalid tokens |
    | AI (Genkit/Vertex) | Flash model selection, Context Caching, token optimization |
    | App Hosting | Blaze free tier monitoring, Cloud Run instance optimization |

### Rule 32.87: GCP Cost Optimization
-   **Strategies**:
    1.  **Rightsizing**: Adjust CPU/RAM to actual usage. Apply Recommender API suggestions.
    2.  **Auto-scaling**: Leverage serverless and managed services.
    3.  **CUD/SUD**: Committed Use Discounts for predictable workloads.
    4.  **Non-critical Resource Shutdown**: Auto-stop dev/staging environments at night/weekends.

### Rule 32.88: Billing Export to BigQuery
-   **Mandate**: Export GCP billing data to BigQuery for detailed cost analysis.

---

## §26. Budget Alerts & Automated Response

### Rule 32.89: Budget Alert Configuration
-   **Mandate**: For environments that can incur charges, configure multi-stage actual and forecast alerts with an owner, recipients, and response runbook. Define thresholds in Blueprint and state that alerts are not hard caps.
    | Stage | Actual Cost | Forecasted Cost | Action |
    |---|---|---|---|
    | Early Warning | Blueprint value | Forecast threshold | Notify cost owner and investigate |
    | Caution | Blueprint value | Forecast threshold | Escalate to owning team |
    | Critical | Near approved limit | Near approved limit | Consider safe degradation and change freeze |
    | Exceeded | Above approved limit | — | Incident procedure and business decision |

### Rule 32.90: Automated Response (Budget Automation)
-   **Architecture**:
    ```
    Budget Alert → Cloud Pub/Sub → Cloud Run Functions → Action Execution
    ```
-   **Actions**:
    1.  **Slack/Email Notification**: Immediate notification to relevant teams.
    2.  **Resource Restriction**: Gradually restrict pre-classified non-critical features; do not abruptly stop workloads processing data.
    3.  **Emergency Stop**: Destructive actions such as billing disable are a last resort requiring break-glass approval, dependency assessment, and a recovery procedure.
-   **Caution**: A budget notification is not a shutoff device. Design safe automation separately to prevent production outage or data loss.

### Rule 32.91: Monthly Review
-   **Mandate**: At a cadence based on spend volatility, budget, and criticality, review actuals, forecasts, unit economics, anomalies, commitments, and unused resources; record owners and due dates. Monthly is a candidate for stable workloads, not a fixed Universal period.

---

## §27. Observability (Cloud Logging / Monitoring / Trace)

### Rule 32.92: Structured Logging
-   **Mandate**: Adopt machine-queryable structured logging. Where the runtime/agent produces the JSON envelope, do not double-encode it in the application. Standardize event schema, severity, service, environment, trace/correlation, and error class as appropriate to use.
    ```typescript
    import { log, warn, error } from "firebase-functions/logger";
    
    log("Order processed", {
      orderId: "abc123",
      userId: "user456",
      amount: 1500,
      currency: "JPY",
      processingTimeMs: 234,
    });
    ```
-   **Reference Fields**: `timestamp`, `severity`, `message`, `service`, `environment`, and `traceId`/`correlationId`. Confirm provider-populated fields and signal use; never fabricate a nonexistent trace.
-   **Prohibited**: Logging sensitive information (passwords, credit card numbers, PII) is strictly forbidden.

### Rule 32.93: Cloud Monitoring
-   **Mandate**: Select signals tied to user journeys, SLOs, saturation, backlog, errors, and cost anomalies; assign owner, severity, notification route, runbook, and escalation. Do not place fixed thresholds or destinations in Universal; derive them in Blueprint from traffic baselines, error budgets, capacity tests, and budgets.
-   **Reference Signals**: Request errors/latency, event age/backlog, instance saturation, quota pressure, AI unit cost, and budget consumption are candidates; do not mandate metrics for unused services.

### Rule 32.94: Cloud Trace & OpenTelemetry
-   **Mandate**: Use Cloud Trace to track request flows across distributed systems.
-   **Integration**: Use OpenTelemetry SDK for automatic trace propagation across services. Genkit Monitoring integrates on OpenTelemetry basis.
-   **Genkit Observability**: Visualize AI flow execution traces, costs, and latency in Genkit Developer UI.

### Rule 32.95: Error Reporting
-   **Mandate**: Auto-aggregate exceptions and errors with Cloud Error Reporting; send alerts on new error cluster detection.

### Rule 32.96: Cloud Profiler
-   **Mandate**: Continuously profile CPU/memory usage in production with Cloud Profiler to identify performance bottlenecks.

---

## §28. Error Handling & Retry Strategy

### Rule 32.97: Unified Error Handling
-   **Mandate**: Apply a unified error handling pattern.
    ```typescript
    interface ErrorResponse {
      error: {
        code: string;        // "INVALID_ARGUMENT" | "NOT_FOUND" | "INTERNAL"
        message: string;     // User-facing message
        details?: unknown;   // Debug info (omit in production)
      };
    }
    ```

### Rule 32.98: Retry Strategy
-   **Mandate**: Retry only transient failures whose operation is idempotent or protected by an idempotency key, within a deadline and retry budget. Consider provider retry guidance, `Retry-After`, jittered backoff, and amplification across the call hierarchy; place counts and durations in Blueprint.
-   **No Retry**: Never blindly retry validation, authentication/authorization, permanent quota/configuration errors, non-idempotent side effects, or expired deadlines. Before enabling provider retry for event-driven functions, prove Rule 32.15 idempotency and poison-message handling.

### Rule 32.99: Dead Letter Queue (DLQ)
-   **Mandate**: Forward messages exceeding retry limits to a Dead Letter Queue.

### Rule 32.100: Circuit Breaker
-   **Applicability**: For synchronous dependencies that can cause resource exhaustion, retry storms, or latency cascades, evaluate a combination of circuit breaking, concurrency limits, load shedding, and fallback. When custom breaker state is unsafe in short-lived functions or conflicts with provider-managed clients, document deadline, bounded retry, queue isolation, or equivalent controls and rationale.

---

## §29. Terraform / IaC Management

### Rule 32.101: IaC Mandatory
-   **Mandate**: Version reproducible Firebase/GCP settings through Terraform, Google Cloud Config Connector, provider-native configuration, or an approved equivalent, with review, plan, and drift detection. Manual operations required by API gaps need approval, audit evidence, a reproduction procedure, and periodic drift checks.
-   **Scope**: GCP project settings, Firebase settings, Cloud Run Functions/Services settings, Security Rules, App Check, Budget Alerts, Monitoring Alert Policies.

### Rule 32.102: Project Structure
-   **Directory Layout**:
    ```
    terraform/
    ├── modules/
    │   ├── firebase/       # Firebase-specific resources
    │   ├── networking/     # VPC/Network
    │   ├── iam/            # IAM roles/service accounts
    │   └── monitoring/     # Alerts/dashboards
    ├── environments/
    │   ├── dev/
    │   ├── staging/
    │   └── prod/
    └── backend.tf          # State management config
    ```

### Rule 32.103: State Management
-   **Mandate**: Manage Terraform State in an approved remote backend with encryption, access control, locking or equivalent concurrency control, version/recovery, and audit. GCS is a candidate for GCP workloads; verify the backend's current locking semantics. Prohibit manual state editing except through a break-glass procedure.

### Rule 32.104: Version Management
-   **Configuration**:
    ```hcl
    terraform {
      required_version = ">= 1.6.0"
      required_providers {
        google = {
          source  = "hashicorp/google"
          version = "~> 5.0"
        }
        google-beta = {
          source  = "hashicorp/google-beta"
          version = "~> 5.0"
        }
      }
    }
    ```

### Rule 32.105: CI/CD Integration
-   **Mandate**: Automate Terraform operations via CI/CD pipeline.
-   **Workflow**: Auto-execute `terraform plan` on PR → Review/Approval → `terraform apply` after merge.
-   **Validation**: Include `terraform fmt -recursive` and `terraform validate` in CI checks.

---

## §30. Firebase CLI & Local Development

### Rule 32.106: Firebase CLI Usage
-   **Essential Commands**:
    | Command | Purpose |
    |---|---|
    | `firebase init` | Project initialization |
    | `firebase deploy` | Resource deployment |
    | `firebase emulators:start` | Local emulator startup |
    | `firebase use` | Project switching |
    | `firebase functions:log` | Function log viewing |
    | `genkit init:ai-tools` | AI coding assistant integration init |

### Rule 32.107: Project Aliases
-   **Configuration**:
    ```json
    {
      "projects": {
        "default": "myapp-dev",
        "staging": "myapp-staging",
        "prod": "myapp-prod"
      }
    }
    ```

---

## §31. Emulator Suite & Testing Strategy

### Rule 32.108: Emulator and Isolated Test Protocol
-   **Mandate**: Use Firebase Emulator Suite for fast local and CI validation when it reproduces the target service with sufficient fidelity. Supplement unsupported capabilities, IAM, quotas, networks, billing, and provider integrations in an isolated non-production project; never treat emulator-only results as production equivalence.
-   **Supported Emulators**:
    | Emulator | Port | Purpose |
    |---|---|---|
    | Authentication | 9099 | Auth flow testing |
    | Firestore | 8080 | Database operation testing |
    | Cloud Functions | 5001 | Local function execution |
    | Cloud Storage | 9199 | File upload testing |
    | Hosting | 5000 | Local hosting preview |
    | Pub/Sub | 8085 | Messaging testing |
    | Eventarc | 9299 | Event trigger testing |
    | Data Connect | 9399 | Data Connect testing |

### Rule 32.109: Security Rules Testing
-   **Mandate**: Automate Security Rules testing with `@firebase/rules-unit-testing` package.

### Rule 32.110: Testing Strategy
-   **Layers**:
    1.  **Unit Test**: Business logic unit tests (independent of Firebase).
    2.  **Integration Test**: Integration tests using Emulator Suite or an isolated project according to fidelity.
    3.  **E2E Test**: End-to-end tests in staging with differences from production recorded.

---

## §32. CI/CD Pipeline Integration

### Rule 32.111: Provider-neutral CI/CD Contract
-   **Mandate**: Independently of the CI provider, compose lint, unit tests, Security Rules tests, emulator or isolated integration, IaC plan, artifact provenance, preview, approval, deploy, and post-deploy verification according to risk. The following is only a reference when GitHub Actions is selected, not a Universal requirement.
-   **Example**:
    ```yaml
    name: Firebase CI/CD
    on:
      push:
        branches: [main]
      pull_request:
        branches: [main]
    
    jobs:
      test:
        runs-on: ubuntu-latest
        steps:
          - uses: actions/checkout@v4
          - uses: actions/setup-node@v4
          - run: npm ci
          - run: npm run lint
          - run: npm run test
      
      deploy:
        needs: test
        if: github.ref == 'refs/heads/main'
        runs-on: ubuntu-latest
        permissions:
          id-token: write
        steps:
          - uses: actions/checkout@v4
          - uses: google-github-actions/auth@v2
            with:
              workload_identity_provider: ${{ vars.WIF_PROVIDER }}
              service_account: ${{ vars.SA_EMAIL }}
          - run: npm ci && npm run build
          - run: npx firebase-tools deploy --only functions
    ```

### Rule 32.112: Workload Identity Federation
-   **Mandate**: When the CI provider exposes an external identity through OIDC or equivalent, use Workload Identity Federation and validate provider, repository, branch, and environment claims. Exceptions follow Rule 32.76.

### Rule 32.113: Deployment Strategy
-   **Flow**:
    1.  **PR**: Auto-test + Lint + Security Rules tests + `firebase hosting:channel:deploy` (preview).
    2.  **Merge to main**: Auto-deploy (Staging environment).
    3.  **Production**: Deploy after manual approval (compliant with `git push` prohibition protocol).

---

## §33. Environment Management (Dev / Staging / Prod)

### Rule 32.114: Environment Separation
-   **Mandate**: Isolate production and non-production identity, data, secrets, billing, quota, deploy authority, and observability according to risk. Decide single-project, multi-project, or folder/organization separation in Blueprint from blast radius, compliance, team topology, and cost.
-   **Access**: Do not fix access by job title or "all developers"; design least privilege, separation of duties, time-bound elevation, break-glass, and audit evidence. Environment and project names are examples, not Universal contracts.

### Rule 32.115: Environment Parity
-   **Mandate**: Staging must reproduce production's material identity, policy, runtime, network, data-contract, deploy, and rollback paths. Document test coverage and residual risk for differences caused by cost or privacy, such as reduced scale or synthetic data.

### Rule 32.116: Environment Variable Management
-   **Non-Secret Configuration**: Manage parameterized or version-controlled environment configuration with schema, defaults, owner, validation, and rollout.
-   **Secrets**: Store secrets in Secret Manager or an approved equivalent and bind them explicitly only to functions/services that need them. Never expose values in plans, logs, client bundles, or version control.
-   **Legacy Migration**: `functions.config()` is deprecated and is scheduled to block new deployments after March 2027; prohibit new use, inventory existing use, and migrate to parameterized configuration and Secret Manager.
-   **Boundary**: IaC variables carry non-secret inputs and secret references. Remote Config controls client behavior and feature rollout; it is not a store for secrets, authentication, or server authorization.

---

## §34. Multi-Region & DR Strategy

### Rule 32.117: Region Selection Criteria
-   **Primary/Secondary**: Decide in Blueprint using §1 criteria and RTO/RPO. Avoid placing both in one failure domain and verify data residency and service compatibility.
-   **Dynamic Availability**: Revalidate GPU, runtime, and multi-region configurations against the current official region matrix.

### Rule 32.118: Region Consistency
-   **Mandate**: Decide related-service regions from latency, data residency, availability, failure domains, and cross-region transfer cost together. Co-location is a latency option; when it conflicts with DR, design an explicit multi-region boundary.

### Rule 32.119: Disaster Recovery
-   **Strategies**:
    1.  **Location Capability**: Check the current official location matrix, residency, consistency, and cost, then select single, dual, or multi-region architecture required by RTO/RPO.
    2.  **Storage and Compute**: Design data copies, compute deployment, and traffic failover against the same failure scenarios; avoid protecting only one layer.
    3.  **Backup**: Derive backup frequency and retention from RPO, law, deletion requirements, and cost; restore-test with credentials and failure domains independent of production.
    4.  **RTO/RPO Evidence**: Record per-service RTO/RPO, restore/failover procedure, test cadence, last result, and owner.

---

## §35. API Design & Endpoint Management

### Rule 32.120: API Design Principles
-   **Principles**:
    1.  **Contract First**: Specify consumers, error model, idempotency, compatibility, rate/size limits, and deprecation. Choose REST, GraphQL, RPC, or event contracts from the interaction model.
    2.  **Versioning**: Select path, header, schema evolution, or another mechanism from consumer compatibility; breaking changes require a migration window and usage evidence.
    3.  **Bounded Retrieval**: Control response size and scan cost using cursors, keysets, page tokens, streaming, or another method appropriate to consistency and scale.

### Rule 32.121: Authentication & Authorization
-   **Mandate**: Design caller identity, token verification, resource authorization, abuse protection, and privileged bypass per endpoint. Firebase Auth, App Check, and custom claims are candidates on eligible surfaces; do not force one three-layer pattern onto server-to-server calls, public webhooks, or anonymous flows.

### Rule 32.122: OpenAPI Specification
-   **Mandate**: Document HTTP APIs with OpenAPI or an equivalent machine-readable contract, GraphQL with schemas, RPC with IDLs, and events with versioned schemas; verify implementation and consumer compatibility in CI.

---

## §36. Rate Limiting & API Protection

### Rule 32.123: Rate Limiting Implementation
-   **Strategies**:
    1.  **Cloud Armor**: WAF rules + rate limiting for Cloud Run via Load Balancer.
    2.  **Application Level**: Redis-based sliding window counter.
    3.  **API Gateway**: GCP API Gateway or Apigee.

### Rule 32.124: Abuse Detection
-   **Mandate**: Implement mechanisms to detect high-volume short-duration requests, anomalous access patterns, and geographic anomalies.

---

## §37. Caching Strategy

### Rule 32.125: Cache Hierarchy
-   **Layers**:
    1.  **CDN (Firebase Hosting)**: Edge caching for static assets.
    2.  **Cloud CDN**: Caching in front of Cloud Run/Load Balancer.
    3.  **Memorystore (Redis)**: Application-level caching.
    4.  **Client-Side**: Browser cache, Service Worker cache.

### Rule 32.126: Cache Invalidation
-   **Strategies**: TTL-based, versioning (Cache Busting), event-driven invalidation.

---

## §38. Batch Processing & Data Pipeline

### Rule 32.127: Batch Processing Architecture
-   **Pattern**:
    ```
    Cloud Scheduler → Pub/Sub → Cloud Run Job (parallel tasks)
    Cloud Scheduler → Cloud Tasks → Cloud Run Job (rate-controlled)
    ```

### Rule 32.128: Data Pipeline
-   **Pattern**:
    ```
    Event Source → Pub/Sub → Cloud Run Functions (lightweight transform) → BigQuery
    Event Source → Pub/Sub → Cloud Run Services (heavy processing) → Cloud Storage → BigQuery
    Cloud Scheduler → Cloud Run Jobs (batch ETL) → BigQuery
    ```

---

## §39. Google Maps Platform Optimization

### Rule 32.129: Cost Optimization
-   **Strategies**:
    1.  **Static Maps**: Use Static Maps API for non-interactive views.
    2.  **Session Token**: Use session tokens for Places Autocomplete.
    3.  **Caching**: Cache Geocoding results.
    4.  **Vector Maps**: Optimize rendering with Maps JavaScript API Vector Maps.

### Rule 32.130: Usage Limits
-   **Mandate**: Set daily/monthly request limits for Maps APIs.

---

## §40. Google Ecosystem Integration Strategy

### Rule 32.131: Ecosystem Fit Principle
-   **Mandate**: Compare required capability, security, privacy, operability, support, cost, portability, and current team skill, then record the decision under 520.
-   **Provider Boundary**: Google-native integration is a strong candidate but has no automatic priority. Do not decide from first-party versus third-party status alone; evaluate total value including lock-in and exit cost.

### Rule 32.132: Inter-Service Integration Patterns
-   **Matrix**:

    | Integration | Implementation |
    |---|---|
    | Firebase → BigQuery | Firebase Extensions / BigQuery Link |
    | Firebase → Vertex AI | Firebase AI Logic / Genkit |
    | GCP → Firebase | Admin SDK / REST API |
    | Firebase → Google Ads | Google Analytics Audiences |
    | Firebase → Google Play | Play Integrity API (App Check) |

---

## §41. Firebase Studio Sunset & Development Environment Portability

### Rule 32.133: Firebase Studio Sunset
-   **Mandate**: Do not adopt Firebase Studio as a new standard environment. New workspace creation was disabled on June 22, 2026 and the service is scheduled to sunset on March 22, 2027; inventory existing workspaces, owners, repositories, secrets, and preview/deploy dependencies, then migrate them to an approved development environment before the deadline.
-   **Continuity**: The sunset does not immediately stop core Firebase products or deployed apps, but source, configuration, artifacts, and runbooks must live in version control and CI outside Studio. Verify build, test, deploy, and rollback without the provider UI.

### Rule 32.134: Development Environment Selection & Migration
-   **Selection**: Compare local/cloud IDEs, AI coding environments, and remote workspaces by source portability, identity, secret isolation, network boundary, audit, reproducible CI, cost, and vendor exit. Do not fix a particular IDE or team size in Universal.
-   **Generated Changes**: Treat AI-generated code and auto-provisioning as untrusted changes; require review, tests, Security Rules/IAM diff, and supply-chain scans, and never deploy them directly to production.
-   **Migration Evidence**: Record owners and test results for source export, secret rotation, environment recreation, CI build, preview, production release, rollback, and workspace deletion/retention.

---

## §42. Compliance & Data Sovereignty

### Rule 32.135: GDPR/CCPA Compliance
-   **Requirements**:
    1.  **Consent Management**: Obtain explicit user consent before data collection.
    2.  **Data Portability**: Provide user data export functionality.
    3.  **Right to Deletion**: Implement complete user data deletion process.
    4.  **DPA**: Execute Data Processing Agreement with Google.

### Rule 32.136: Privacy Act Compliance
-   **Requirements**:
    1.  **Purpose Specification**: Clearly state data usage purposes in privacy policy.
    2.  **Security Measures**: Implement technical security measures (encryption, access control).
    3.  **Third-Party Sharing Restriction**: Prohibit third-party sharing without consent.

### Rule 32.137: Data Locality
-   **Mandate**: Control data geographic location through GCP region selection when data sovereignty requirements exist. Restrict regions via Organization Policy.

---

## §43. Supply Chain Security

### Rule 32.138: Container Security
-   **Mandate**: For container artifacts reaching production, validate dependency/OS vulnerabilities, provenance, signatures/attestations, base images, secrets, and licenses according to risk, with owned and expiring exceptions.
-   **Tools**: Artifact Registry scanning, Binary Authorization, SLSA-compatible provenance, and policy engines are candidates.
-   **Admission**: Apply signature/attestation verification or an equivalent admission control according to supply-chain threat, platform support, and criticality; test break-glass and rollback.

### Rule 32.139: Dependency Management
-   **Mandate**: Continuously monitor third-party library vulnerabilities.
-   **Tools**: Dependabot / Renovate, npm audit, `snyk`.

### Rule 32.140: SBOM (Software Bill of Materials)
-   **Mandate**: Generate and store SBOMs for production-deployed container images.

---

## §44. Operational Maturity Model

### Rule 32.141: Maturity Levels
-   **Matrix**:

    | Level | Name | Requirements |
    |---|---|---|
    | L1 | Ad-hoc | Manual deployment, no logging, no testing |
    | L2 | Managed | CI/CD introduced, basic logging, manual testing |
    | L3 | Defined | IaC introduced, structured logging, automated testing, budget alerts |
    | L4 | Measured | Observability integration, SLI/SLO definition, cost optimization |
    | L5 | Optimized | Auto-scaling, self-healing, AI-driven analysis |

### Rule 32.142: Minimum Requirements
-   **Mandate**: Define the production maturity target in Blueprint from service criticality, data sensitivity, regulation, team size, SLOs, and blast radius. Do not decide release eligibility from a level label alone; evidence unmet controls, compensating controls, owners, and expiry.

---

## §45. Migration & Deprecation Strategy

### Rule 32.143: Firestore to Another Data Platform Migration
-   **Strategy**:
    1.  **Contract & Mapping**: Map source/target schema, identity, ordering, timestamps, TTL, indexes, authorization, consistency, and retention; approve loss and transformation policies.
    2.  **Backfill & Change Capture**: Combine bulk backfill with CDC, outbox, replay logs, or equivalents; provide restartable checkpoints, rate limits, and checksum/count/sample validation.
    3.  **Dual-Write Guardrail**: Prohibit application-level best-effort dual writes. If dual write is selected, prove atomicity or a durable outbox, ordering, idempotency, retry, reconciliation, and partial-failure recovery.
    4.  **Shadow Read & Cutover**: Shadow-read and compare with production-like traffic; after meeting error-budget and exit criteria, switch reads and then writes in stages. Predefine RTO, RPO, freeze, and rollback points.
    5.  **Reconciliation & Cleanup**: Resolve lag and discrepancies and verify consumers plus backup/restore before retiring old data, credentials, indexes, and code under legal, retention, and rollback-window requirements.

### Rule 32.144: Legacy API Deprecation
-   **Process**: Deprecation Notice → Migration Guide → Usage Monitoring → Sunset.

### Rule 32.145: 1st Gen Functions Migration
-   **Mandate**: Legacy functions follow Rule 32.10 inventory, official support deadlines, compatibility tests, staged migration, and rollback. Use provider tools only as validated aids.

---

## §46. Troubleshooting & Debugging

### Rule 32.146: Debug Tools
-   **Reference**:

    | Tool | Purpose |
    |---|---|
    | Firebase Console | Real-time monitoring, Analytics, Crashlytics |
    | GCP Console | Cloud Logging, Monitoring, Trace |
    | Firebase Emulator Suite | Local debugging |
    | `firebase functions:log` | Function log streaming |
    | Cloud Shell | Direct GCP resource operations |
    | Gemini in Firebase Console | AI-assisted debugging |

### Rule 32.147: Common Troubleshooting
-   **Reference**:

    | Issue | Cause | Solution |
    |---|---|---|
    | Cold Start Delay | Instance startup, initialization, artifact, connections | Trace and load-test, then compare initialization reduction, reuse, `minInstances`, and SLO changes |
    | CORS Error | Missing headers | Add `cors` middleware |
    | Permission Denied | IAM/Security Rules | Verify permissions, test in Emulator |
    | Quota Exceeded | API limit exceeded | Request quota increase, optimize |
    | Memory Limit | Insufficient memory | Increase memory setting, use streaming |
    | Timeout | Processing time exceeded | Make async, migrate to Cloud Run Jobs |
    | GPU Not Available | Region limitation | Move to GPU-enabled region |

### Rule 32.148: Incident Response
-   **Process**:
    1.  **Detection**: Detect through alerts within a Blueprint time based on SLO and severity.
    2.  **Triage**: Identify impact scope and determine severity.
    3.  **Mitigation**: Temporary measures (Feature Flag OFF, rollback, etc.).
    4.  **Resolution**: Fix root cause and validate.
    5.  **Post-mortem**: Retrospective and preventive measures.

---

## §47. Node.js/TypeScript Specific Design

### Rule 32.149: Runtime Selection
-   **Mandate**: Select a provider-supported Node.js release within its security support window after checking dependency compatibility and an EOL plan.
-   **Configuration**: Declare the exact major or allowed range through `engines` or another provider-supported mechanism and reconcile the resolved CI and production version.
    ```json
    { "engines": { "node": "22" } }
    ```

### Rule 32.150: Node.js Type Safety
-   **Mandate**: When Node.js is selected, TypeScript strict mode is the default candidate. A JavaScript choice must provide equivalent boundary safety through runtime validation, linting, type-checkable JSDoc, and tests. This section does not exclude officially supported Go, Python, Java, .NET, or other runtimes.
-   **Configuration**: For TypeScript set `strict: true` and combine it with runtime validation at boundaries. Language selection follows `engineering/320_programming_language_governance.md`.

### Rule 32.151: ESM vs CJS
-   **Mandate**: Recommend ESModules for new projects.
-   **Configuration**: Set `"type": "module"` in `package.json`, or use `.mts` extension.
-   **Caution**: Some Firebase SDKs may assume CJS. Verify compatibility in advance.

### Rule 32.152: Type-Safe Patterns
-   **Mandate**: Ensure runtime type safety with validation libraries like Zod.
    ```typescript
    import { z } from "zod";
    
    const OrderSchema = z.object({
      userId: z.string().min(1),
      items: z.array(z.object({
        productId: z.string(),
        quantity: z.number().int().positive(),
      })),
      total: z.number().positive(),
    });
    
    type Order = z.infer<typeof OrderSchema>;
    ```

### Rule 32.153: Genkit Node.js Integration
-   **Mandate**: For Node.js AI workflows, evaluate Genkit as a candidate against model portability, evaluation, observability, security, runtime support, and exit. If adopted, revalidate its current official status and integrations such as `onCallGenkit`.

---

## §48. Node.js Performance & Testing

### Rule 32.154: Bundle Optimization
-   **Mandate**: Minimize Cloud Run Functions deployment size.
-   **Strategies**:
    1.  Properly separate `devDependencies` and `dependencies`.
    2.  Periodically prune unnecessary dependencies.
    3.  Deploy with `--only=production` or `npm ci --omit=dev`.

### Rule 32.155: Testing Framework
-   **Mandate**: Choose a maintained test framework compatible with the repository and runtime, and execute unit, integration, emulator, contract, and failure-path tests. Vitest and Jest are reference implementations.
-   **Coverage**: Do not decide quality from line coverage alone; define Blueprint criteria from risk, branches, mutation, and critical journeys.

---

## §49. Node.js Deployment & Package Management

### Rule 32.156: Package Manager
-   **Mandate**: Select one maintained package manager that the team can support and the provider build supports, and pin its version. Do not exclude npm, pnpm, Yarn, or another manager by name alone.
-   **Lock File**: A deployable application versions the selected manager's lockfile or equivalent resolved-dependency digest and verifies frozen installation in CI.

### Rule 32.157: Monorepo Support
-   **Mandate**: Adopt workspaces or a monorepo only when multiple packages need atomic changes, shared policy, or a build graph. npm, pnpm, or Yarn workspaces, Bazel, Nx, and Turborepo are requirement-dependent reference implementations.

---

## §50. Go Specific Design

### Rule 32.158: Go Runtime
-   **Mandate**: Pin a provider-supported Go release within its security support window after verifying module, library, build-image compatibility, and an EOL plan.

### Rule 32.159: Genkit Go (GA)
-   **Mandate**: For Go AI workflows, evaluate Genkit as a candidate against current official status, model support, evaluation, observability, security, and exit, and record adoption in an ADR.
    ```go
    import "github.com/firebase/genkit/go/ai"
    
    myFlow := genkit.DefineFlow("myFlow", func(ctx context.Context, input string) (string, error) {
        resp, err := ai.Generate(ctx, ai.WithTextPrompt(input))
        if err != nil {
            return "", err
        }
        return resp.Text(), nil
    })
    ```
-   **Features**: Type-safe AI flows, unified model interface, Tool Calling, RAG, multimodal.

### Rule 32.160: Struct Design
-   **Mandate**: Use `firestore` tags for Go struct mapping to Firestore documents.
-   **Validation**: Implement validation with `go-playground/validator`.

---

## §51. Go Performance & Testing

### Rule 32.161: Testing
-   **Mandate**: Test with the standard `testing` package. Recommend Table-Driven Test pattern.
-   **Benchmark**: Use `testing.B` for benchmarking performance-critical code.

### Rule 32.162: Error Handling
-   **Mandate**: Follow Go standard error handling patterns (`errors.Is`/`errors.As`/`fmt.Errorf`+`%w`).

---

## §52. Python Specific Design

### Rule 32.163: Python Runtime
-   **Mandate**: Pin a provider-supported Python release within its security support window after verifying dependency, native-wheel, build-image compatibility, and an EOL plan.

### Rule 32.164: Genkit Python
-   **Mandate**: For Python AI workflows, evaluate Genkit as a candidate against current official status, model support, evaluation, observability, security, and exit, and record adoption in an ADR.
-   **Caution**: Treat a preview or pre-GA feature as a time-bound exception with support, breaking-change, fallback, and exit deadlines.

### Rule 32.165: Type Hints
-   **Mandate**: Type public APIs, domain models, I/O boundaries, and security/money-critical code, and run the selected static checker in CI. Scope, own, and time-bound exceptions for dynamic boundaries or untyped dependencies. `mypy`, Pyright, and equivalents are candidates; Universal does not fix one tool.
    ```python
    from firebase_functions import https_fn
    from pydantic import BaseModel
    
    class OrderRequest(BaseModel):
        user_id: str
        items: list[dict]
        total: float
    
    @https_fn.on_request()
    def process_order(req: https_fn.Request) -> https_fn.Response:
        order = OrderRequest.model_validate_json(req.data)
        # Business logic
        return https_fn.Response(json.dumps({"status": "ok"}))
    ```

---

## §53. Python Performance & Testing

### Rule 32.166: Testing
-   **Mandate**: Use the Python standard or an approved test runner for unit, boundary, integration, and emulator/isolated-project tests. Introduce async fixtures only where an actual concurrency boundary exists.
-   **Coverage**: Use coverage tooling as a signal for untested risk, not a fixed percentage as the sole release gate. Prioritize critical paths, authorization denials, retry/idempotency, and migration failures.

### Rule 32.167: Dependency Management
-   **Mandate**: Version a supported manifest and reproducible resolved-dependency/checksum evidence; verify index sources, transitive dependencies, native artifacts, licenses, vulnerabilities, and runtime compatibility in CI.
-   **Tools**: Compare `pyproject.toml`, lock/constraints files, `uv`, pip-tools, Poetry, PDM, and equivalents as candidates that fit the project's runtime and packaging contract; record the adopted tool and upgrade policy in Blueprint.

---

## §54. 35 Anti-Patterns

### Rule 32.168: Prohibited Pattern Collection

| # | Anti-Pattern | Correct Approach |
|---|---|---|
| 1 | Creating a Firestore collection without evaluation, Rules, indexes, or a cost owner | Complete Primary Directive 0.1 evaluation and the data contract first |
| 2 | Creating new 1st Gen Cloud Functions | Use Cloud Run Functions |
| 3 | Granting `roles/owner` to production SA | Custom roles with least privilege |
| 4 | Committing service account keys to Git | Secret Manager + WIF |
| 5 | Storing secrets in version-controlled `.env` files or client bundles | Use an approved secret store, ignore rules, and separate samples |
| 6 | Production on an eligible surface without evaluating App Check | Perform threat modeling, monitoring, and staged enforcement |
| 7 | Firestore without Security Rules | Default Deny + Authentication |
| 8 | User-controlled or collection-wide reads without a bound or termination condition | Guarantee bounded reads with limits, cursors, quotas, and a data contract |
| 9 | Ignoring idempotency in function design | Protect side effects with stable keys, atomic claims, outbox, and reconciliation |
| 10 | Synchronous heavy processing | Async via Pub/Sub/Cloud Tasks |
| 11 | Fixing cold-start mitigation without SLO/cost evidence | Measure latency, traffic, and idle cost; select `minInstances` or another control only where needed |
| 12 | Leaving default resources unverified or overprovisioning them | Derive memory/CPU/timeout/concurrency from load tests, quotas, and cost |
| 13 | Budget monitoring and owner missing | Configure Blueprint budget thresholds, notifications, and safe responses |
| 14 | Resource ownership/cost cannot be attributed | Use organizational labels/tags and policy for traceability |
| 15 | Manual infrastructure setup (ClickOps) | Manage with Terraform/IaC |
| 16 | Manual `firebase deploy` in production | Via CI/CD pipeline |
| 17 | Deploying Security Rules without tests | Automate allow and deny tests in Emulator Suite or an isolated project |
| 18 | Unstructured log output | JSON structured logging |
| 19 | Inconsistent error handling | Unified ErrorResponse format |
| 20 | External calls that ignore failure class and idempotency | Design deadlines, retry budgets, jitter, idempotency, and DLQ/reconciliation |
| 21 | Using FCM Legacy API | Migrate to HTTP v1 API |
| 22 | Improper Admin SDK usage | Least privilege IAM + Secret Manager |
| 23 | Network boundary, egress, or bypass for a private data path is undefined | Select a private path and egress control appropriate to supported services and threats |
| 24 | Logging sensitive information | Prohibit PII/password logging |
| 25 | AI output without guardrails | Input validation + output filter + Kill Switch |
| 26 | Untracked AI costs | AI FinOps labeling + Blueprint unit economics and thresholds |
| 27 | Unmanaged staging differences | Maintain material-control parity and documented differences |
| 28 | DR testing not performed | Validate restore/failover at a risk-based cadence derived from RTO/RPO |
| 29 | Container deployment without SBOM | Generate and store SBOM |
| 30 | Depending on sunset-bound Firebase Studio for source or deploy paths | Migrate to portable source, an approved development environment, and reproducible CI |
| 31 | Genkit flows without testing | Developer UI and unit tests |
| 32 | Production containers without evaluating provenance/signature/admission risk | Apply attestation verification or an equivalent control by criticality |
| 33 | MCP server published without auth | Access control via IAM + App Check |
| 34 | Treating a billing plan/free tier as a hard cap | Design usage billing, quotas, abuse controls, budgets, and degradation |
| 35 | Persisting tokens without a threat model | Select storage per platform after evaluating XSS, CSRF, device compromise, rotation, and revocation |

---

## §55. Technology Lifecycle Radar

### Rule 32.169: Technology Trend Monitoring
-   **Mandate**: For capabilities in use or under consideration, continuously monitor changes in official release stage, deprecation or EOL, runtimes and SDKs, regions, quotas, pricing, security model, data use, and support contracts, and connect them to revalidation triggers in the capability manifest.
-   **Signals**:
    1.  **Execution Surface**: Support and responsibility boundaries for managed runtimes, buildpacks, containers, edge or distributed execution, GPU or accelerators, and confidential compute.
    2.  **Language & SDK**: Language versions, official or community SDKs, feature parity, experimental or preview or GA status, security support, and migration guides.
    3.  **Security & Identity**: Official controls and applicability conditions for workload identity, attestation, encryption, data perimeters, supply-chain verification, and quantum-safe migration.
    4.  **Data & AI**: Maturity, evaluation, safety, data governance, unit economics, and exit for databases, streams, vectors, AI frameworks, and agent protocols.
    5.  **Operations & Commercial**: Observability, backup or restore, SLA, support, quota, pricing or terms, sunset, and provider incidents.
-   **Promotion Gate**: Do not promote a new feature to a production standard merely because it exists or is popular. Compare workload fit, maturity, feature parity, security, performance, cost, operability, portability, rollback, and team ownership against existing options using the same evidence. Preview or experimental use requires limited scope, an exit path, and a revalidation date.

---

## §56. Language, SDK & Runtime Support Surfaces

### Rule 32.170: Support Claim Decomposition
-   **Mandate**: Do not reduce “Firebase or GCP supports language X” to one Boolean value. Inventory client SDKs, Admin SDKs, framework bindings, managed Functions runtimes, Cloud Run source buildpacks, arbitrary containers, REST or gRPC, and CLI or IaC as separate surfaces with support authority, maturity, feature parity, runtime, artifact, identity, deployment, observability, and EOL.

### Rule 32.171: Firebase Client SDK Surface
-   **Current Snapshot**: As of 2026-07-23, official documentation lists Android, Flutter, Apple platforms, JavaScript, Unity, and C++ as official client SDK surfaces. Code quality for Swift, Kotlin or Java, Dart, TypeScript or JavaScript, C#, and C++ inherits `engineering/320_programming_language_governance.md`, `engineering/400_mobile_flutter.md`, and `engineering/410_native_platforms.md`.
-   **Framework Boundary**: AngularFire, ReactFire, React Native Firebase, Vuefire, and other framework bindings do not necessarily share the official Firebase SDK support contract. For React Native, follow `engineering/420_react_native.md` and separately pin and test the JavaScript package, iOS and Android SDKs, native modules, Codegen or bridge, both-OS builds, and release compatibility.

### Rule 32.172: Firebase Admin SDK Surface
-   **Current Snapshot**: As of 2026-07-23, the official Admin SDK documentation presents Node.js, Java, Python, Go, and C# as server-side surfaces and labels Dart experimental. Do not infer support for every feature from the language name; verify the feature matrix, minimum runtime, deprecations, and release notes per capability.
-   **Privilege Boundary**: An Admin SDK is not an untrusted client library governed by client Security Rules. Enforce workload identity, least privilege, tenant or project boundaries, audit, and credential lifecycle at the server boundary, and never include it in a mobile or browser bundle.

### Rule 32.173: Cloud Run Execution Surface
-   **Current Snapshot**: As of 2026-07-23, Cloud Run source-deployment documentation lists Go, Node.js, Python, Kotlin or Groovy or Scala through the Java buildpack, .NET, Ruby, and PHP as source-build surfaces, while a Dockerfile or container image can run any language satisfying the container contract. Do not treat a Functions runtime, source buildpack, and arbitrary container as the same support contract.
-   **Build Contract**: Even for source deployment, connect the builder, base image, resolved dependencies, runtime patch mode, Artifact Registry image, SBOM, provenance, architecture, startup and health behavior, and rollback to release evidence. Automatic detection is not complete proof of reproducibility or security updating.

### Rule 32.174: Language-Native Quality Gates
-   **Mandate**: Java, Kotlin, Groovy, Scala, C# or F#, Ruby, PHP, and other languages receive the formatter, compiler or type, test, dependency, artifact, SBOM, and runtime-EOL gates from `engineering/320_programming_language_governance.md`, just as Node.js or TypeScript, Go, and Python do. Do not duplicate the same language rules in this provider profile; add only Firebase or GCP-specific identity, emulator fidelity, runtime, deployment, and quota controls.

### Rule 32.175: Polyglot Team Ownership
-   **Mandate**: Connect every production language, SDK, and runtime surface to an accountable owner, support level, upgrade or EOL path, security-advisory route, CI gate, on-call or incident path, fallback, and decommission route in a service catalog or equivalent inventory. A small team may combine roles, but must not silently collapse responsibility for experimental or community bindings, privileged Admin SDKs, native mobile code, and managed runtimes into one generic “Firebase owner.”
-   **CI Selection**: Select native gates and managed conformance tests for affected clients, admin surfaces, runtimes, mobile operating systems, and containers from the change graph. Do not run every language on every PR indiscriminately; revalidate all dependents when shared schemas, Auth or Rules, SDK majors, runtimes, or generated contracts change.

---

## Appendix A: Quick Reference Index

| What You Want to Do | Reference Section |
|---|---|
| Mitigate Cloud Run Functions cold start | §2 |
| Run AI inference on Cloud Run GPU | §3 |
| Execute batch processing | §3, §38 |
| Implement asynchronous messaging | §4 |
| Implement user authentication | §5 |
| Introduce Passkeys/FIDO2 | §5 |
| Prevent app abuse | §6 |
| Strengthen Firestore security | §7 |
| Use Data Connect | §8 |
| Store files securely | §9 |
| Deploy SPA | §10 |
| Deploy Next.js SSR | §10 |
| Send push notifications | §11 |
| Implement A/B testing & Feature Flags | §12 |
| Monitor crashes | §13 |
| Measure performance | §14 |
| Integrate generative AI into app | §16, §17 |
| Build AI agents | §17, §18 |
| Use MCP/A2A protocols | §18 |
| Analyze costs | §20, §25, §26 |
| Strengthen security | §21, §22, §23, §24 |
| Set up logging & monitoring | §27 |
| Unify error handling | §28 |
| Manage infrastructure as code | §29 |
| Set up local dev environment | §30, §31 |
| Build CI/CD | §32 |
| Separate environments | §33 |
| Plan DR | §34 |
| Design APIs | §35 |
| Implement rate limiting | §36 |
| Optimize caching | §37 |
| Use Google Maps | §39 |
| Migrate from Firebase Studio | §41 |
| Comply with GDPR | §42 |
| Strengthen container security | §43 |
| Improve operations | §44 |
| Plan migration from Firestore | §45 |
| Node.js/TypeScript specific guide | §47, §48, §49 |
| Go specific guide | §50, §51 |
| Python specific guide | §52, §53 |
| Place Java or Kotlin or Scala, C# or .NET, Ruby, or PHP on Cloud Run | §56 |
| Decide support for Swift, Kotlin, Dart, Unity, or C++ client SDKs | §56 |
| Evaluate framework bindings such as React Native Firebase | §56 and `engineering/420_react_native.md` |

---

## Appendix B: Cross-References

| Related Rule File | Reference Purpose |
|---|---|
| `engineering/000_engineering_standards` | General software engineering principles |
| `engineering/300_web_frontend` | Frontend integration patterns |
| `engineering/100_api_integration` | API design & microservices design |
| `engineering/410_native_platforms` | Mobile app integration (iOS/Android) |
| `engineering/420_react_native` | React Native JavaScript, native, and SDK boundaries |
| `engineering/320_programming_language_governance` | Language-native gates, support tiers, and polyglot team governance |
| `engineering/200_supabase_architecture` | Integration and migration when Supabase is adopted |
| `engineering/520_cloud_application_platforms` | Platform selection, shared responsibility, and exit strategy |
| `engineering/510_aws_cloud` | Multi-cloud strategy & comparison |
| `ai/000_ai_engineering` | AI/ML implementation guidelines |
| `ai/100_data_analytics` | Analytics & Observability |
| `quality/000_qa_testing` | General testing strategy |
| `security/000_security_privacy` | Security & Privacy |
| `operations/600_cloud_finops` | FinOps & Cost management |

---

## Appendix C: FinOps Checklist

> Apply only items for adopted services that the cost/risk model requires. BigQuery, Pub/Sub, Recommender, and Remote Config are GCP/Firebase profile examples, not the only Universal implementation.

### Initial Setup
- [ ] Apply `environment`/`service`/`owner`/`cost-center`/`ai-feature` labels to all GCP resources
- [ ] Enable Billing Export to BigQuery
- [ ] Configure approved multi-stage actual and forecast budget alerts from Blueprint
- [ ] Configure automated response on budget exceeded (Pub/Sub + Cloud Run Functions)
- [ ] Set up independent AI cost tracking

### Monthly Review
- [ ] Reconcile cost actuals vs budget
- [ ] Audit and delete unused resources
- [ ] Audit service accounts
- [ ] Consider Committed Use Discounts
- [ ] Review Recommender API recommendations
- [ ] AI token consumption optimization review

### Cloud Run Functions Optimization
- [ ] Right-size memory/CPU (based on Recommender API)
- [ ] Optimize `minInstances` (reduce unnecessary always-on)
- [ ] Configure `maxInstances` (runaway prevention)
- [ ] Delete unused functions

### Firebase Services Optimization
- [ ] Monitor Firestore read/write costs
- [ ] Configure Cloud Storage lifecycle rules
- [ ] Periodic FCM token cleanup
- [ ] Monitor Authentication MAU
- [ ] Monitor App Hosting Blaze free tier

---

## Appendix D: Security Checklist

> Apply only items relevant to supported services and the threat model, allowing equivalent controls appropriate to provider capability, jurisdiction, and data class.

### Initial Setup
- [ ] Evaluate App Check on eligible surfaces and move from monitoring to staged enforcement
- [ ] Apply Default Deny pattern in Security Rules
- [ ] Remove broad basic roles from normal production workloads, CI, and permanent human access; separate break-glass
- [ ] Configure short-lived federation and claim restrictions on supported external identity paths
- [ ] Move production and shared secrets to an approved secret store
- [ ] Evaluate and verify VPC Service Controls from data-exfiltration threats and service support
- [ ] Evaluate a fitting WAF and DDoS control plus bypass prevention for internet-facing surfaces
- [ ] Evaluate Binary Authorization or another admission control from container supply-chain threats

### Periodic Audit (Risk-Based Cadence)
- [ ] Inventory service accounts and keys
- [ ] Least privilege IAM review
- [ ] Secret Manager secret rotation
- [ ] Dependency vulnerability scan (`npm audit`, `snyk`)
- [ ] Container image vulnerability scan
- [ ] Security Rules review
- [ ] OWASP Top 10 countermeasure verification

### AI Security
- [ ] Configure AI input/output guardrails
- [ ] Verify MCP server access controls
- [ ] Configure AI feature Kill Switch (Remote Config)
- [ ] Classify AI agent autonomy levels
- [ ] Conduct EU AI Act risk classification

---

## Appendix E: Official Reference Snapshot

- [Cloud Run container runtime contract](https://cloud.google.com/run/docs/container-contract): execution contract for arbitrary-language containers, ports, filesystems, lifecycle, and architecture
- [Cloud Run Functions runtimes](https://cloud.google.com/run/docs/runtimes/function-runtimes): managed language runtimes and support or decommission deadlines
- [Firebase supported libraries](https://firebase.google.com/docs/libraries): support boundaries between official client and Admin SDKs and community framework bindings
- [Firebase Admin SDK setup](https://firebase.google.com/docs/admin/setup): Admin SDK feature matrix by language, runtime requirements, and experimental status
- [Cloud Run deploy from source](https://cloud.google.com/run/docs/deploying-source-code): source-buildpack languages, container path, and builder or artifact boundaries
- [Google Cloud resource hierarchy](https://cloud.google.com/resource-manager/docs/cloud-platform-resource-hierarchy): ownership and policy inheritance across Organizations, Folders, and Projects
- [Cloud Functions retry](https://firebase.google.com/docs/functions/retries): retry, at-least-once, and idempotency boundaries
- [Configure environment](https://firebase.google.com/docs/functions/config-env): parameterized configuration, secrets, and migration from deprecated `functions.config()`
- [Manage sessions](https://firebase.google.com/docs/auth/admin/manage-sessions): ID tokens, refresh tokens, and revocation
- [Firebase App Check](https://firebase.google.com/docs/app-check): separation of app/device attestation from authentication and authorization
- [Firebase Studio release notes](https://firebase.google.com/support/release-notes/firebase-studio): new-workspace shutdown on 2026-06-22 and sunset on 2027-03-22
