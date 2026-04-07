# 32. Backend Engineering (Firebase & GCP)

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-03-24

> [!IMPORTANT]
> **Supreme Directive**
> "Firebase is an 'Auxiliary Engine'; data sovereignty belongs to Supabase (PostgreSQL)."
> In all Firebase/GCP implementations, strictly follow this priority order: **Security (App Check + Security Rules) > Reliability (Idempotency + Retry) > Cost Efficiency (FinOps) > Performance > Developer Productivity**.
> This document is the supreme standard for all design decisions related to Firebase & GCP.
> **55 Parts · Rule 32.1–32.200+ · Appendix A–D.**

> [!WARNING]
> **Deprecated / Auxiliary Mode Only**
> The **Single Source of Truth (SSOT)** for this project is **Supabase (PostgreSQL)**.
> Storing user data or domain data in Firestore is prohibited in principle.
> Firebase usage is limited to **peripheral services** such as **FCM (Push Notification)**, **Google Analytics**, **Crashlytics**, **App Check**, and **Remote Config**.

---

## Table of Contents

**I. Foundation & Philosophy**
- §0. Supreme Directives
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

**XVIII. Firebase Studio**
- §41. Firebase Studio

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

**XXIV. Anti-Patterns & Future Outlook**
- §54. 35 Anti-Patterns
- §55. Future Outlook

**Appendix**
- Appendix A: Quick Reference Index
- Appendix B: Cross-References
- Appendix C: FinOps Checklist
- Appendix D: Security Checklist

---

## §0. Supreme Directives

### Supreme Directive 0.1: Auxiliary Engine Principle
-   **Law**: Firebase is an "Auxiliary Engine"; **data sovereignty belongs to Supabase (PostgreSQL)**. New data storage in Firestore is prohibited in principle.
-   **Mandate**:
    1.  **Data Sovereignty**: All user and domain data must be stored in Supabase. Firestore is permitted only for legacy maintenance.
    2.  **Peripheral Services Only**: Firebase usage is limited to FCM, Analytics, Crashlytics, App Check, Remote Config, Performance Monitoring, etc.
    3.  **No New Firestore Collections**: Creating new collections is prohibited. Only maintenance of existing collections is permitted.

### Supreme Directive 0.2: Defense in Depth
-   **Law**: Security must not depend on a single layer. Multi-layered defense with App Check + Security Rules + IAM + VPC is mandatory.
-   **Mandate**:
    1.  **App Check Mandatory**: Enable App Check on all Firebase services and custom backends.
    2.  **Least Privilege**: All service accounts and IAM roles must follow the principle of least privilege. `roles/owner` in production is prohibited.
    3.  **Zero Trust Network**: Minimize trust boundaries using VPC Service Controls and Private Google Access.

### Supreme Directive 0.3: Idempotency First
-   **Law**: All Cloud Run Functions and Cloud Run Services must be designed to be idempotent.
-   **Mandate**:
    1.  **Event ID Deduplication**: Event-triggered functions must implement deduplication using `eventId`.
    2.  **Transactional Writes**: Use transactions or batch writes for Firestore writes.
    3.  **Retry Safety**: Guarantee that retries do not cause duplicate side effects.

### Supreme Directive 0.4: FinOps Guardian
-   **Law**: Cloud costs are managed with the same rigor as technical debt. Budget overruns are treated as incidents.
-   **Mandate**:
    1.  **Budget Alerts**: Set budget alerts at 50%/80%/100%/120% for all projects.
    2.  **Automated Response**: Automatically stop non-critical resources when exceeding 100% via Cloud Run Functions.
    3.  **Cost Tagging**: Apply `environment`/`service`/`owner` labels to all GCP resources.

### Supreme Directive 0.5: Cloud Run Unified
-   **Law**: Since 2025, Cloud Functions (2nd Gen) has been renamed to **Cloud Run Functions**. All serverless compute is managed uniformly as the Cloud Run family.
-   **Mandate**:
    1.  **Naming**: Use "Cloud Run Functions" in documentation, code, and IaC.
    2.  **Unified Management**: Monitor and manage Cloud Run Functions, Services, and Jobs uniformly.
    3.  **Migration Path**: Migrate 1st Gen Functions to Cloud Run Functions promptly.

---

## §1. Firebase Project Strategy & GCP Integration

### Rule 32.1: Project Separation Strategy
-   **Mandate**: Separate Firebase/GCP projects per environment.
-   **Structure**:
    ```
    myapp-dev      → Development (free testing)
    myapp-staging  → Staging (production-equivalent config)
    myapp-prod     → Production (strict IAM controls)
    ```

### Rule 32.2: GCP Project Configuration
-   **Mandate**: Firebase projects are always built on top of GCP projects.
-   **Configuration**:
    -   **Organization**: Set up folder structure under GCP Organization and apply policies hierarchically.
    -   **Billing Account**: Set budgets per environment, separating production and development billing.
    -   **API Enablement**: Explicitly enable required APIs (`firebase.googleapis.com`, `run.googleapis.com`, `artifactregistry.googleapis.com`, etc.).

### Rule 32.3: Region Selection
-   **Mandate**: Maintain region consistency across services. Deploy Cloud Run Functions, Cloud Run, and Firestore in the same region.
-   **Recommended**: `us-central1` (Iowa) or `europe-west1` (Belgium) as default for global-facing services.
-   **Caution**: Firestore region cannot be changed after creation. Configure initial setup carefully.
-   **GPU Availability**: Cloud Run GPU (NVIDIA L4 GA / RTX PRO 6000 Blackwell Preview) is available only in specific regions (`us-central1`, `europe-west1`, `europe-west4`, `asia-southeast1`, `asia-south1`, etc.). Consider this when selecting regions for AI inference workloads.

### Rule 32.4: Blaze Plan Mandatory
-   **Mandate**: As of February 3, 2026, Blaze plan (pay-as-you-go) is required for all Firebase projects. Spark plan no longer supports key features like Cloud Storage.
-   **Action**: Migrate all projects to Blaze plan and always set budget alerts (see §26).

---

## §2. Cloud Run Functions (formerly Cloud Functions 2nd Gen)

### Rule 32.5: Cloud Run Functions Standardization
-   **Mandate**: All new serverless functions must use **Cloud Run Functions**. Creating new 1st Gen functions is prohibited.
-   **Advantage**:
    -   High performance via Cloud Run infrastructure (up to 32GB RAM, 8 vCPU)
    -   Concurrency support (default 80, max 1000)
    -   125+ event sources via Eventarc
    -   Traffic splitting and revision rollback
    -   HTTP functions can run up to 1 hour
-   **Supported Runtimes (as of March 2026)**: Node.js 22/24, Go 1.23/1.24/1.26, Python 3.12/3.13/3.14, Java 21/25, Ruby 3.3/4.0, PHP 8.4/8.5, .NET 8/10.

### Rule 32.6: Cold Start Mitigation
-   **Mandate**: Implement cold start mitigation for latency-sensitive functions.
-   **Strategies**:
    1.  **Min Instances**: Set `minInstances: 1` or higher for critical functions (login, payment).
    2.  **Concurrency**: Process multiple requests per instance using concurrency.
    3.  **Global Variable Reuse**: Initialize DB connections and HTTP clients at global scope for reuse across invocations.
    4.  **Lightweight Initialization**: Use lazy loading for heavy initialization.
    5.  **Cloud Scheduler Warmup**: Send periodic pings to low-frequency functions.

```typescript
// ✅ Good: Reuse DB connection via global variable
import { initializeApp } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";

const app = initializeApp();
const db = getFirestore(app);

export const myFunction = onRequest(
  { minInstances: 1, concurrency: 80, memory: "512MiB" },
  async (req, res) => {
    const doc = await db.collection("config").doc("main").get();
    res.json(doc.data());
  }
);
```

### Rule 32.7: Runtime Configuration
-   **Mandate**: Explicitly set resource limits and timeouts for all functions. Do not rely on defaults.
-   **Configuration**:
    ```typescript
    export const processOrder = onRequest({
      region: "asia-northeast1",
      memory: "512MiB",
      timeoutSeconds: 120,
      minInstances: 1,
      maxInstances: 100,
      concurrency: 80,
      cpu: 1,
    }, handler);
    ```
-   **Guidelines**:
    | Use Case | Memory | Timeout | Min Instances | Concurrency |
    |---|---|---|---|---|
    | API Endpoint | 256-512MiB | 60s | 1 | 80 |
    | Image Processing | 1-2GiB | 300s | 0 | 10 |
    | Batch Processing | 2-4GiB | 540s | 0 | 1 |
    | Webhook Receiver | 256MiB | 30s | 0 | 80 |
    | AI Inference (CPU) | 4-8GiB | 300s | 0 | 4 |
    | Genkit AI Flow | 1-2GiB | 120s | 0-1 | 20 |

### Rule 32.8: Function Organization
-   **Mandate**: Split functions by feature module and leverage Codebases.
-   **Structure**:
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
-   **Deployment**: Split into groups of 10 or fewer when deploying many functions.

### Rule 32.9: Idempotency Implementation
-   **Mandate**: All event-triggered functions must be designed idempotently.
-   **Pattern**:
    ```typescript
    export const onOrderCreated = onDocumentCreated(
      "orders/{orderId}",
      async (event) => {
        const eventId = event.id;
        
        // Deduplication: Skip already-processed events
        const processedRef = db.collection("processedEvents").doc(eventId);
        const processed = await processedRef.get();
        if (processed.exists) {
          console.log(`Event ${eventId} already processed. Skipping.`);
          return;
        }
        
        await processOrder(event.data);
        await processedRef.set({ processedAt: FieldValue.serverTimestamp() });
      }
    );
    ```

### Rule 32.10: 1st Gen → Cloud Run Functions Migration
-   **Mandate**: Migrate 1st Gen Functions to Cloud Run Functions promptly.
-   **Migration Tool**: Use the GCP-provided upgrade tool (Preview).
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
    1.  **Stateless**: Do not share state between instances. Store state in Firestore/Cloud SQL/Redis.
    2.  **Fast Startup**: Minimize container startup time (target: under 2s, GPU: under 5s).
    3.  **Health Check**: Implement `/health` endpoint and enable Startup/Liveness probes.
    4.  **Graceful Shutdown**: Handle SIGTERM appropriately (complete cleanup within 10s).

### Rule 32.14: Cloud Run GPU Support (GA)
-   **Mandate**: Use Cloud Run GPU (NVIDIA L4 Tensor Core GA / RTX PRO 6000 Blackwell Preview) for AI inference and ML processing.
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
-   **Available Regions**: `us-central1`, `europe-west1`, `europe-west4`, `asia-southeast1`, `asia-south1`.

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
-   **Mandate**: Use Firebase Authentication as the "authentication layer" and store user data in Supabase.
-   **Recommended Providers**:
    | Provider | Use Case | Priority |
    |---|---|---|
    | Google Sign-In | General user authentication | Highest |
    | Apple Sign-In | iOS apps (App Store requirement) | Required (iOS) |
    | Email/Password | Fallback authentication | Standard |
    | Phone (SMS) | MFA / Phone verification | Optional |
    | Anonymous | Guest access | Limited |
    | SAML/OIDC | Enterprise SSO | As needed |
-   **Prohibited**: Accessing Firestore without authentication is prohibited.

### Rule 32.23: Passkeys / FIDO2 Support
-   **Mandate**: Recommend Passkeys (FIDO2) adoption for passwordless authentication.
-   **Implementation**: Use Firebase Authentication with Identity Platform (GCIP) `Passkey` provider.
-   **Benefit**: Phishing resistance, elimination of password list attacks, improved user UX.

### Rule 32.24: Custom Claims
-   **Mandate**: Use Custom Claims for Role-Based Access Control (RBAC).
-   **Rules**:
    1.  Set only via Admin SDK (setting from client is prohibited).
    2.  Payload limited to 1000 bytes.
    3.  Changes are not reflected until token refresh. Design with 1-hour grace period.
    ```typescript
    // Admin SDK: Set custom claims
    await admin.auth().setCustomUserClaims(uid, {
      role: "admin",
      plan: "premium",
    });
    ```

### Rule 32.25: Token Management and Session Design
-   **Mandate**: ID Token TTL defaults to 1 hour. Use Refresh Tokens for long sessions.
-   **Security**:
    1.  Store Refresh Tokens in HTTP-only Cookies. Storage in LocalStorage/SessionStorage is prohibited.
    2.  Implement Token Revocation for immediate invalidation on account compromise.
    3.  Require Multi-Factor Authentication (MFA) for admin and high-privilege users.

### Rule 32.26: Authentication Event Monitoring
-   **Mandate**: Stream authentication events (login, failure, account creation) to Cloud Logging for unauthorized access detection.
-   **Detectable Events**: Abnormal login frequency, geographic anomalies, brute force patterns.

---

## §6. App Check & App Authentication

### Rule 32.27: App Check Mandatory
-   **Mandate**: Enable App Check on all Firebase services (Firestore, Cloud Storage, Cloud Run Functions) and custom backends.
-   **Attestation Providers**:
    | Platform | Provider | Recommended |
    |---|---|---|
    | Android | Play Integrity API | ✅ |
    | iOS | App Attest (Device Check) | ✅ |
    | Web | reCAPTCHA Enterprise | ✅ |
-   **Enforcement Mode**: Enable enforcement mode after confirming sufficient App Check adoption rate (90%+).

### Rule 32.28: App Check for Custom Backends
-   **Mandate**: Verify App Check Tokens on custom backends such as Cloud Run Services.
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
-   **Mandate**: New data storage in Firestore is prohibited in principle (per Supreme Directive 0.1).
-   **Permitted Use Cases**:
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
    1.  **Authentication Required**: Use `request.auth != null` as the base for all rules.
    2.  **Schema Validation**: Validate type, value, and size of `request.resource.data`.
    3.  **Custom Claims Validation**: Control admin operations with `request.auth.token.role == 'admin'`.
    4.  **Functions**: Use Security Rules Functions for reusable rule logic.
    5.  **Testing Required**: Test all rules with `@firebase/rules-unit-testing` (see §31).
    6.  **Version Control**: Security Rules files must be under Git management.

### Rule 32.33: Firestore Query Optimization
-   **Mandate**: Always consider performance and cost when writing Firestore queries.
-   **Rules**:
    1.  **`.limit()` Required**: Set `limit()` on all queries. Unlimited queries are prohibited.
    2.  **Cursor-based Pagination**: Use `startAfter()`/`endBefore()`.
    3.  **Composite Indexes**: Explicitly define indexes for composite queries.
    4.  **Document Size**: Keep documents small (target: under 10KB).
    5.  **Subcollections**: Use subcollections for large nested data.
    6.  **Caching**: Enable Firestore SDK caching (`enablePersistentCacheIndexAutoCreation`).
    7.  **Hotspot Avoidance**: Do not use sequential values for document IDs.

---

## §8. Firebase Data Connect (Cloud SQL) — GA

### Rule 32.34: Data Connect Overview
-   **Mandate**: Firebase Data Connect (GA April 2025) is a BaaS service built on Cloud SQL PostgreSQL. Consider for use when SQL-based backend is needed.
-   **Features**:
    -   GraphQL-based schema definition and query language
    -   Relational data model Firebase integration
    -   AI-assisted onboarding and schema generation
    -   Client access via Firebase SDK (Web, iOS, Android, Flutter)
-   **Caution**: Project SSOT is Supabase. Consider Data Connect only when specific Firebase integration features not provided by Supabase are required.

### Rule 32.35: Data Connect vs. Supabase Decision Criteria
-   **Decision Matrix**:
    | Requirement | Supabase | Data Connect |
    |---|---|---|
    | SSOT (Data Sovereignty) | ✅ Highest priority | △ Firebase integration only |
    | RLS / Row Level Security | ✅ Optimal | △ Firebase Security Rules |
    | Real-time Subscriptions | ✅ Realtime | △ Limited |
    | Firebase SDK Integration | △ Custom needed | ✅ Native |
    | Edge Runtime | ✅ Edge Functions | ❌ Not possible |
    | GraphQL API | △ pg_graphql | ✅ Native |

---

## §9. Cloud Storage for Firebase

### Rule 32.36: Storage Design Principles
-   **Mandate**: Use Cloud Storage for Firebase for file storage.
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
-   **Mandate**: Use Resumable Upload for large files (10MB+) to guarantee recovery from network interruptions.

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
-   **Mandate**: Use Firebase App Hosting (GA April 2025) for Next.js/Angular SSR applications.
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
-   **Supported Frameworks**: Next.js (App Router recommended), Angular (v17+).
-   **Cost**: Charges apply when exceeding Blaze Plan free tier (from August 2025).

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
    3.  **Periodic Cleanup**: Set up batch job to auto-delete tokens not updated for 90+ days.
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

### Rule 32.48: Crashlytics Mandatory
-   **Mandate**: Integrate Firebase Crashlytics into all mobile apps.
-   **Configuration**:
    1.  **dSYM Upload**: Auto-upload dSYMs at build time for iOS.
    2.  **Proguard Mapping**: Upload Proguard/R8 mapping files for Android.
    3.  **Non-Fatal Errors**: Record non-critical errors with `recordError()`.
    4.  **Custom Keys**: Set custom keys useful for debugging (user ID, screen name, etc.).
    5.  **Breadcrumbs**: Record breadcrumbs of user actions.

### Rule 32.49: Crash-Free Rate Target
-   **Mandate**: Maintain Crash-Free Users rate at **99.5%+**. Emergency response if below 99%.
-   **Monitoring**: Configure Crashlytics Alerts to instantly detect new crash clusters.

---

## §14. Performance Monitoring

### Rule 32.50: Performance Monitoring Configuration
-   **Mandate**: Track key performance metrics with Firebase Performance Monitoring.
-   **Tracked Metrics**:
    1.  **App Start Time**: Maintain cold start under 2 seconds.
    2.  **HTTP Response Time**: API response time (p95 < 1s).
    3.  **Screen Rendering**: Screen render time (p95 < 500ms).
    4.  **Network Payload Size**: Detect oversized response sizes.
-   **Custom Traces**: Set custom traces for business-critical operations (login, payment, search).

---

## §15. Google Analytics for Firebase

### Rule 32.51: Analytics Integration
-   **Mandate**: Measure all user behavior with Google Analytics for Firebase.
-   **Configuration**:
    1.  **Automatic Events**: Auto-collect `first_open`, `session_start`, `screen_view`, etc.
    2.  **Custom Events**: Explicitly record business metrics (purchases, registrations, feature usage).
    3.  **User Properties**: Set user attributes (plan, region, segment, etc.).
    4.  **Conversion Events**: Define conversion events and track goal completion rates.
    5.  **BigQuery Export**: Export raw data to BigQuery for detailed analysis.
    6.  **DebugView**: Use DebugView for real-time event verification during development.
-   **Privacy**: Implement GDPR-compliant Consent Mode (see §42).

---

## §16. Firebase AI Logic & Genkit

### Rule 32.52: Firebase AI Logic Overview
-   **Mandate**: Use Firebase AI Logic (formerly Vertex AI in Firebase) to securely integrate generative AI models into apps.
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
-   **Mandate**: Use Genkit (open source) for building AI workflows.
-   **Language Support (as of March 2026)**:
    | Language | Version | Status | Maturity |
    |---|---|---|---|
    | Node.js (TypeScript) | 1.x | GA | ✅ Production-ready |
    | Go | 1.0 (Sept 2025 GA) | GA | ✅ Production-ready |
    | Python | Alpha | Preview | △ Experimental |
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
-   **Mandate**: Use Genkit Tool Calling to allow LLMs external data access and action execution.
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
    2.  **30% Rule**: Alert when AI costs exceed 30% of total.
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
-   **Mandate**: Use Firebase Extensions for standard integrations.
-   **Recommended Extensions**:
    | Extension | Use Case |
    |---|---|
    | Stream Firestore to BigQuery | Analytics platform for Firestore data |
    | Resize Images | Auto-resize uploaded images |
    | Translate Text | Automatic text translation |
    | Trigger Email | Email sending automation |
    | Delete User Data | User deletion data cleanup |

### Rule 32.67: Custom Extensions
-   **Mandate**: Develop and package project-specific repetitive processes as custom Extensions.

---

## §20. BigQuery Integration & Data Analytics Platform

### Rule 32.68: BigQuery as SSOT (Analytics)
-   **Mandate**: Consolidate all analytics data in BigQuery.
-   **Data Sources**:
    -   Firebase Analytics → BigQuery Export
    -   Firestore → BigQuery Extension
    -   Cloud Logging → BigQuery Sink
    -   Billing Data → BigQuery Export

### Rule 32.69: ELT Pattern
-   **Mandate**: Load data in raw format to BigQuery, then transform/test within BigQuery using dbt, etc.
    ```
    Source → Raw Layer (BigQuery) → Staging Layer (dbt) → Mart Layer (dbt) → Dashboard
    ```

### Rule 32.70: Data Quality
-   **Mandate**: Embed automated quality tests in data pipelines.
-   **Tests**:
    1.  **Freshness**: Data freshness checks.
    2.  **Volume**: Anomaly detection for record counts (alert at ±30% vs previous day).
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
    2.  **Credential Rotation**: Rotate every 90 days.
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
-   **Prohibited**: Use of `roles/owner` and `roles/editor` in production is prohibited.
-   **Recommended**: Create custom IAM roles containing only required permissions. Apply IAM Recommender suggestions.

### Rule 32.75: Service Account Management
-   **Mandate**: Create dedicated service accounts per function and isolate permissions.
-   **Best Practices**:
    1.  **Dedicated Accounts**: Separate service accounts for Cloud Run Functions, Cloud Run, and CI/CD.
    2.  **Keyless Authentication**: Use Workload Identity Federation to minimize service account key issuance.
    3.  **Periodic Audit**: Audit and delete unused service accounts and keys every 90 days.

### Rule 32.76: Workload Identity Federation
-   **Mandate**: Use Workload Identity Federation for access from external ID providers (GitHub Actions, AWS, etc.) to GCP. Service account key issuance is prohibited in principle.

---

## §23. Secret Manager & Sensitive Data Management

### Rule 32.77: Secret Manager Mandatory
-   **Mandate**: Manage all sensitive information (API keys, DB passwords, etc.) with Secret Manager.
-   **Prohibited**: Hard-coding sensitive information in source code, `.env` files, or Firebase Config is **strictly forbidden**.

### Rule 32.78: Secret Management
-   **Best Practices**:
    1.  **Versioning**: Version-manage secrets for rollback capability.
    2.  **Auto-Rotation**: Rotate every 90 days. Recommend automatic rotation.
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
-   **Mandate**: Configure VPC Service Controls in high-security environments to define access boundaries for GCP services.

### Rule 32.81: Private Google Access
-   **Mandate**: Use Private Google Access for Cloud Run Functions/Services access to GCP services.

### Rule 32.82: Direct VPC Egress
-   **Mandate**: Use Cloud Run Functions Direct VPC Egress (GA) to securely access private resources within VPC.
-   **Configuration**: Set `--egress-settings=all` to route all outbound traffic through VPC.

### Rule 32.83: Cloud Armor WAF
-   **Mandate**: Place Cloud Armor in front of Cloud Run/Load Balancer.
-   **Architecture**: Cloud Run → Serverless NEG → Application Load Balancer → Cloud Armor Security Policy.
-   **Policy**:
    1.  **OWASP Top 10 WAF Rules**: Apply preconfigured rules for SQL Injection, XSS, etc.
    2.  **Adaptive Protection**: Automatic DDoS attack mitigation.
    3.  **Rate Limiting**: Limit malicious traffic patterns.
    4.  **Geo Restriction**: Geographic restrictions as needed.
    5.  **Bot Management**: Bot traffic detection and control.
-   **Testing**: Always evaluate new policies in "preview" mode before enforcement.

### Rule 32.84: Private Service Connect
-   **Mandate**: Use Private Service Connect for private connections to GCP managed services (Cloud SQL, Memorystore, etc.).

---

## §25. FinOps & Cost Optimization

### Rule 32.85: Cost Allocation Principles
-   **Mandate**: Apply labels to all GCP resources.
-   **Required Labels**:
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
-   **Mandate**: Configure multi-stage budget alerts for all projects.
    | Stage | Actual Cost | Forecasted Cost | Action |
    |---|---|---|---|
    | Warning | 50% | 75% | Team Slack notification |
    | Caution | 80% | 90% | Manager escalation |
    | Critical | 100% | 100% | Auto resource restriction |
    | Exceeded | 120% | — | Emergency response (all teams) |

### Rule 32.90: Automated Response (Budget Automation)
-   **Architecture**:
    ```
    Budget Alert → Cloud Pub/Sub → Cloud Run Functions → Action Execution
    ```
-   **Actions**:
    1.  **Slack/Email Notification**: Immediate notification to relevant teams.
    2.  **Resource Restriction**: Set `maxInstances` to 0 for non-critical Cloud Run Functions/Services.
    3.  **Billing Disable**: Disable project billing via Cloud Billing API as last resort.
-   **Caution**: Billing disable stops all services. Apply cautiously in production.

### Rule 32.91: Monthly Review
-   **Mandate**: Reconcile cost actuals against budget monthly; identify root causes of abnormal cost increases.

---

## §27. Observability (Cloud Logging / Monitoring / Trace)

### Rule 32.92: Structured Logging
-   **Mandate**: All Cloud Run Functions/Services logs must be in structured JSON format.
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
-   **Required Fields**: `timestamp`, `severity`, `message`, `traceId`.
-   **Prohibited**: Logging sensitive information (passwords, credit card numbers, PII) is strictly forbidden.

### Rule 32.93: Cloud Monitoring
-   **Mandate**: Set alert policies for key metrics.
    | Metric | Threshold | Action |
    |---|---|---|
    | Function Error Rate | > 5% | Immediate Slack notification |
    | Function Latency (p99) | > 5s | Start investigation |
    | Pub/Sub Unacked Messages | > 1000 | Scale up processing capacity |
    | Cloud Run CPU Utilization | > 80% | Check instance count |
    | AI Token Consumption | > Budget 80% | Execute cost optimization |

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
-   **Mandate**: Implement retry strategy for all external calls. Exponential backoff with jitter.
    | Parameter | Value |
    |---|---|
    | Initial Delay | 1 second |
    | Max Delay | 60 seconds |
    | Multiplier | 2x |
    | Max Retries | 5 |
    | Jitter | ±20% |

### Rule 32.99: Dead Letter Queue (DLQ)
-   **Mandate**: Forward messages exceeding retry limits to a Dead Letter Queue.

### Rule 32.100: Circuit Breaker
-   **Mandate**: Implement Circuit Breaker pattern to prevent external service failures from cascading through the entire system.

---

## §29. Terraform / IaC Management

### Rule 32.101: IaC Mandatory
-   **Mandate**: Manage all Firebase/GCP infrastructure settings with Terraform. Manual operations (ClickOps) are prohibited.
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
-   **Mandate**: Store Terraform State remotely in GCS bucket. Enable bucket versioning, implement State Locking, prohibit manual editing.

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

### Rule 32.108: Emulator Suite Mandatory
-   **Mandate**: Use Firebase Emulator Suite for local development and CI testing.
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
    2.  **Integration Test**: Integration tests using Emulator Suite.
    3.  **E2E Test**: End-to-end tests in staging environment.

---

## §32. CI/CD Pipeline Integration

### Rule 32.111: GitHub Actions Recommended
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
-   **Mandate**: Use Workload Identity Federation for GitHub Actions to GCP authentication. Service account key usage is prohibited.

### Rule 32.113: Deployment Strategy
-   **Flow**:
    1.  **PR**: Auto-test + Lint + Security Rules tests + `firebase hosting:channel:deploy` (preview).
    2.  **Merge to main**: Auto-deploy (Staging environment).
    3.  **Production**: Deploy after manual approval (compliant with `git push` prohibition protocol).

---

## §33. Environment Management (Dev / Staging / Prod)

### Rule 32.114: Environment Separation
-   **Matrix**:

    | Environment | GCP Project | Purpose | Access |
    |---|---|---|---|
    | Dev | `myapp-dev` | Development/experimentation | All developers |
    | Staging | `myapp-staging` | Acceptance testing | Developers + QA |
    | Prod | `myapp-prod` | Production operations | Restricted (strict IAM) |

### Rule 32.115: Environment Parity
-   **Mandate**: Maintain staging environment with production-equivalent configuration.

### Rule 32.116: Environment Variable Management
-   **Methods**:
    1.  **Firebase Config**: `firebase functions:config:set` (non-sensitive info).
    2.  **Secret Manager**: Sensitive information (see §23).
    3.  **Terraform Variables**: Infrastructure settings.
    4.  **Remote Config**: App dynamic settings (see §12).

---

## §34. Multi-Region & DR Strategy

### Rule 32.117: Region Selection Criteria
-   **Primary**: `us-central1` (Iowa) — Default for global-facing services.
-   **Secondary**: `us-central1` (Iowa) — For global services.
-   **GPU Support**: Cloud Run GPU (NVIDIA L4 GA) available in `us-central1`, `europe-west1`, `europe-west4`, `asia-southeast1`, `asia-south1`, etc.

### Rule 32.118: Region Consistency
-   **Mandate**: Deploy related services in the same region.

### Rule 32.119: Disaster Recovery
-   **Strategies**:
    1.  **Firestore**: Use multi-region locations (`nam5`/`eur3`, etc.).
    2.  **Cloud Storage**: Multi-region or dual-region buckets.
    3.  **Cloud Run**: Deploy to multiple regions with load balancing.
    4.  **Backup**: Configure daily Firestore auto-backups and test recovery.
    5.  **RTO/RPO Definition**: Define RTO/RPO per service.

---

## §35. API Design & Endpoint Management

### Rule 32.120: API Design Principles
-   **Principles**:
    1.  **Uniform Interface**: Resource-oriented URL design (`/api/v1/users/{id}`).
    2.  **Versioning**: Include API version in URL path.
    3.  **Pagination**: Implement cursor-based pagination.

### Rule 32.121: Authentication & Authorization
-   **Pattern**: Three-layer auth with App Check (§6) + Firebase Auth Token + Custom Claims (§5).

### Rule 32.122: OpenAPI Specification
-   **Mandate**: Document API endpoints with OpenAPI (Swagger) specification.

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

### Rule 32.131: Google First Principle
-   **Mandate**: Prioritize Google ecosystem in technology selection.
-   **Exception**: Third-party products are only permitted when demonstrable overwhelming advantage over Google services.

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

## §41. Firebase Studio

### Rule 32.133: Firebase Studio Usage
-   **Mandate**: Use Firebase Studio for prototyping and full-stack AI application development.
-   **Features**:
    -   Cloud-based AI-native development environment
    -   Prompt-to-app generation with Gemini 2.5
    -   Agent mode (autonomous task execution)
    -   Figma design integration
    -   App Hosting integrated deployment
    -   Backend auto-provisioning (auto-detect/configure Firestore, Firebase Authentication, etc.)
    -   MCP Server native support
-   **Use Cases**:
    1.  **Rapid Prototyping**: Instantly generate app scaffolding from AI prompts.
    2.  **Full-Stack Development**: End-to-end development of frontend + backend + Firebase integration.
    3.  **Team Collaboration**: Instantly shareable via cloud.

### Rule 32.134: Firebase Studio Constraints
-   **Caution**:
    1.  Direct production code deployment is not recommended (go through CI/CD pipeline).
    2.  Always review generated code and verify Security Rules/IAM settings.
    3.  For large-scale projects, recommend traditional IDE + CLI workflow.

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
-   **Mandate**: Perform security scans on Cloud Run container images.
-   **Tools**: Artifact Registry container vulnerability scanning, Binary Authorization.
-   **Binary Authorization**: Apply policy allowing only signed container images for production deployment.

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
-   **Mandate**: Production environments must achieve minimum L3. Production operations at L2 or below is prohibited.

---

## §45. Migration & Deprecation Strategy

### Rule 32.143: Firestore → Supabase Migration
-   **Strategy**:
    1.  **Data Mapping**: Conversion design from NoSQL schema to RDB schema.
    2.  **Phased Migration**: Migrate incrementally by service unit.
    3.  **Dual Write**: Write to both DBs during migration period.
    4.  **Read Switch**: Switch read target to Supabase.
    5.  **Write Switch**: Switch write target to Supabase.
    6.  **Cleanup**: Delete Firestore data and code.

### Rule 32.144: Legacy API Deprecation
-   **Process**: Deprecation Notice → Migration Guide → Usage Monitoring → Sunset.

### Rule 32.145: 1st Gen Functions Migration
-   **Mandate**: Promptly migrate 1st Gen Cloud Functions to Cloud Run Functions. Use the GCP-provided upgrade tool.

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
    | Cold Start Delay | Instance startup | Set `minInstances`, optimize code |
    | CORS Error | Missing headers | Add `cors` middleware |
    | Permission Denied | IAM/Security Rules | Verify permissions, test in Emulator |
    | Quota Exceeded | API limit exceeded | Request quota increase, optimize |
    | Memory Limit | Insufficient memory | Increase memory setting, use streaming |
    | Timeout | Processing time exceeded | Make async, migrate to Cloud Run Jobs |
    | GPU Not Available | Region limitation | Move to GPU-enabled region |

### Rule 32.148: Incident Response
-   **Process**:
    1.  **Detection**: Alert-based detection (<5 min).
    2.  **Triage**: Identify impact scope and determine severity.
    3.  **Mitigation**: Temporary measures (Feature Flag OFF, rollback, etc.).
    4.  **Resolution**: Fix root cause and validate.
    5.  **Post-mortem**: Retrospective and preventive measures.

---

## §47. Node.js/TypeScript Specific Design

### Rule 32.149: Runtime Selection
-   **Mandate**: Use Node.js 22+ LTS as the standard runtime (Node.js 24 also available).
-   **Configuration**: Specify version explicitly in `engines` field.
    ```json
    { "engines": { "node": "22" } }
    ```

### Rule 32.150: TypeScript Mandatory
-   **Mandate**: All Cloud Run Functions/Services code must be written in **TypeScript**. Direct JavaScript usage is prohibited.
-   **Configuration**: Set `strict: true` in `tsconfig.json`. Recommend `noUncheckedIndexedAccess: true`.

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
-   **Mandate**: Use Genkit Node.js SDK (GA) for AI workflows in Node.js environments. Callable Functions integration via `onCallGenkit` trigger is available (see §2 Rule 32.11).

---

## §48. Node.js Performance & Testing

### Rule 32.154: Bundle Optimization
-   **Mandate**: Minimize Cloud Run Functions deployment size.
-   **Strategies**:
    1.  Properly separate `devDependencies` and `dependencies`.
    2.  Periodically prune unnecessary dependencies.
    3.  Deploy with `--only=production` or `npm ci --omit=dev`.

### Rule 32.155: Testing Framework
-   **Mandate**: Test with Vitest (recommended) or Jest.
-   **Coverage**: Target 80%+ coverage for business logic.

---

## §49. Node.js Deployment & Package Management

### Rule 32.156: Package Manager
-   **Mandate**: Use npm (standard) or pnpm. yarn is not recommended.
-   **Lock File**: Always commit `package-lock.json` (npm) or `pnpm-lock.yaml`.

### Rule 32.157: Monorepo Support
-   **Mandate**: Use npm workspaces or pnpm workspaces for large-scale projects to share common utilities.

---

## §50. Go Specific Design

### Rule 32.158: Go Runtime
-   **Mandate**: Use Go 1.23+ (Go 1.24/1.26 also available). Available for both Cloud Run Functions and Cloud Run Services.

### Rule 32.159: Genkit Go (GA)
-   **Mandate**: Use Genkit Go SDK (1.0 GA, September 2025) for building AI workflows in Go.
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
-   **Mandate**: Use Python 3.12+ (Python 3.13/3.14 also available). Available for Cloud Run Functions and Cloud Run Services.

### Rule 32.164: Genkit Python
-   **Mandate**: Use Genkit Python SDK (Alpha) for building AI workflows in Python.
-   **Caution**: Alpha stage — carefully evaluate stability for production use. Monitor GA schedule.

### Rule 32.165: Type Hints
-   **Mandate**: Add Type Hints to all Python code and check with `mypy`.
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
-   **Mandate**: Test with pytest. Support async tests with `pytest-asyncio`.
-   **Coverage**: Measure coverage with `pytest-cov`.

### Rule 32.167: Dependency Management
-   **Mandate**: Manage dependencies with `requirements.txt` or `pyproject.toml`. Generate lock files with `pip-tools`. Adoption of `uv` is also recommended.

---

## §54. 35 Anti-Patterns

### Rule 32.168: Prohibited Pattern Collection

| # | Anti-Pattern | Correct Approach |
|---|---|---|
| 1 | Creating new Firestore collections | Create tables in Supabase |
| 2 | Creating new 1st Gen Cloud Functions | Use Cloud Run Functions |
| 3 | Granting `roles/owner` to production SA | Custom roles with least privilege |
| 4 | Committing service account keys to Git | Secret Manager + WIF |
| 5 | Storing sensitive info in `.env` files | Manage with Secret Manager |
| 6 | Production without App Check | Apply App Check to all services |
| 7 | Firestore without Security Rules | Default Deny + Authentication |
| 8 | Firestore queries without `.limit()` | Always implement pagination |
| 9 | Ignoring idempotency in function design | Event ID deduplication |
| 10 | Synchronous heavy processing | Async via Pub/Sub/Cloud Tasks |
| 11 | No cold start mitigation | Set `minInstances` |
| 12 | Using default memory/timeout | Explicitly configure resources |
| 13 | No budget alerts configured | Configure 4-stage alerts |
| 14 | GCP resources without labels | Apply 5 required labels |
| 15 | Manual infrastructure setup (ClickOps) | Manage with Terraform/IaC |
| 16 | Manual `firebase deploy` in production | Via CI/CD pipeline |
| 17 | Deploying Security Rules without tests | Unit test with Emulator Suite |
| 18 | Unstructured log output | JSON structured logging |
| 19 | Inconsistent error handling | Unified ErrorResponse format |
| 20 | External calls without retry strategy | Exponential backoff + DLQ |
| 21 | Using FCM Legacy API | Migrate to HTTP v1 API |
| 22 | Improper Admin SDK usage | Least privilege IAM + Secret Manager |
| 23 | Direct DB access without VPC | Configure Direct VPC Egress |
| 24 | Logging sensitive information | Prohibit PII/password logging |
| 25 | AI output without guardrails | Input validation + output filter + Kill Switch |
| 26 | Untracked AI costs | AI FinOps labeling + 30% rule |
| 27 | Staging ≠ Prod configuration | Maintain environment parity |
| 28 | DR testing not performed | Quarterly DR testing |
| 29 | Container deployment without SBOM | Generate and store SBOM |
| 30 | Firebase Studio direct production deploy | Via CI/CD pipeline |
| 31 | Genkit flows without testing | Developer UI and unit tests |
| 32 | Production deploy without Binary Auth | Allow only signed images |
| 33 | MCP server published without auth | Access control via IAM + App Check |
| 34 | App Hosting free tier unmonitored | Blaze Plan + budget alert setup |
| 35 | Refresh Token in LocalStorage | HTTP-only Cookie + Token Revocation |

---

## §55. Future Outlook

### Rule 32.169: Technology Trend Monitoring
-   **Mandate**: Continuously monitor the following technology trends and prepare for adoption.
-   **Trends**:
    1.  **WebAssembly Functions**: Performance improvement via WASM-enabled Cloud Run Functions.
    2.  **Edge Computing**: Edge deployment via Cloud Run on GDC (Google Distributed Cloud).
    3.  **Quantum-Safe Cryptography**: Preparation for migration to quantum-resistant cryptography.
    4.  **AI-Native Infrastructure**: AI-driven automatic infrastructure optimization and self-healing.
    5.  **Confidential Computing**: Data processing in TEE (Trusted Execution Environment).
    6.  **Multi-Cloud AI**: Distributed AI inference combining Cloud Run GPU and Vertex AI Agent Engine.
    7.  **Genkit Python GA**: Python SDK GA enabling broader adoption by ML engineers.
    8.  **Cloud Run RTX PRO 6000**: High-performance AI inference with next-gen GPU (NVIDIA Blackwell).

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
| Use Firebase Studio | §41 |
| Comply with GDPR | §42 |
| Strengthen container security | §43 |
| Improve operations | §44 |
| Plan migration from Firestore | §45 |
| Node.js/TypeScript specific guide | §47, §48, §49 |
| Go specific guide | §50, §51 |
| Python specific guide | §52, §53 |

---

## Appendix B: Cross-References

| Related Rule File | Reference Purpose |
|---|---|
| `300_engineering_standards` | General software engineering principles |
| `340_web_frontend` | Frontend integration patterns |
| `301_api_integration` | API design & microservices design |
| `343_native_platforms` | Mobile app integration (iOS/Android) |
| `320_supabase_architecture` | SSOT (Supabase) coordination & migration |
| `361_aws_cloud` | Multi-cloud strategy & comparison |
| `400_ai_engineering` | AI/ML implementation guidelines |
| `401_data_analytics` | Analytics & Observability |
| `700_qa_testing` | General testing strategy |
| `600_security_privacy` | Security & Privacy |
| `720_cloud_finops` | FinOps & Cost management |

---

## Appendix C: FinOps Checklist

### Initial Setup
- [ ] Apply `environment`/`service`/`owner`/`cost-center`/`ai-feature` labels to all GCP resources
- [ ] Enable Billing Export to BigQuery
- [ ] Configure budget alerts (50%/80%/100%/120%)
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

### Initial Setup
- [ ] Enable App Check on all Firebase services
- [ ] Apply Default Deny pattern in Security Rules
- [ ] Remove `roles/owner`/`roles/editor` from production environment
- [ ] Configure Workload Identity Federation
- [ ] Migrate all sensitive information to Secret Manager
- [ ] Configure VPC Service Controls for production
- [ ] Apply Cloud Armor WAF policies
- [ ] Enable Binary Authorization

### Periodic Audit (Every 90 Days)
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
