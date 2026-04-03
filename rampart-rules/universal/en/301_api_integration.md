# 35. API Integration & Microservices

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-03-24

> [!IMPORTANT]
> **Supreme Directive**
> "APIs are the most valuable assets of an organization; design them as salable products."
> In API design, strictly follow this priority order: **Security > Reliability > Compatibility > Performance > DX**.
> This document serves as the supreme standard for all design decisions related to API integration and microservices.
> **35 Parts, 70 Sections.**

---

## Table of Contents

- Part I: Supreme Directive & API Philosophy
- Part II: API Design Principles (API-First / Contract-First)
- Part III: Protocol Selection Strategy (REST/GraphQL/gRPC/AsyncAPI)
- Part IV: RESTful API Design Standards
- Part V: URL & Resource Design
- Part VI: Versioning Strategy
- Part VII: Request & Response Design
- Part VIII: RFC 7807+ Semantic Errors
- Part IX: GraphQL Design Standards
- Part X: GraphQL Federation
- Part XI: GraphQL Security & Performance
- Part XII: gRPC Design Standards
- Part XIII: gRPC Advanced Patterns
- Part XIV: Protocol Buffers Management
- Part XV: Event-Driven Architecture
- Part XVI: AsyncAPI & Messaging Design
- Part XVII: Webhook Design & Operations
- Part XVIII: API Gateway Architecture
- Part XIX: Service Mesh Design
- Part XX: BFF (Backend for Frontend) Pattern
- Part XXI: Resilience Patterns
- Part XXII: Idempotency Design
- Part XXIII: Rate Limiting & Throttling
- Part XXIV: API SLO & Reliability Contracts
- Part XXV: Graceful Degradation & Fault Isolation
- Part XXVI: API Security Foundation
- Part XXVII: Authentication & Authorization Architecture
- Part XXVIII: API Key & Token Management
- Part XXIX: Input Validation & Sanitization
- Part XXX: CORS Governance
- Part XXXI: DTO Design & Data Mapping
- Part XXXII: Data Serialization
- Part XXXIII: Server Action Design
- Part XXXIV: Caching Strategy
- Part XXXV: Payload Optimization
- Part XXXVI: Scalability Design
- Part XXXVII: API Observability
- Part XXXVIII: API Audit Logging
- Part XXXIX: API Health Check & Status
- Part XL: API Public Documentation Standards
- Part XLI: Developer Experience (DX)
- Part XLII: API Contract Testing
- Part XLIII: API Product Mindset
- Part XLIV: API Gateway Usage Metering
- Part XLV: API FinOps
- Part XLVI: Microservices Design Principles
- Part XLVII: Inter-Service Communication Patterns
- Part XLVIII: Distributed Data Management
- Part XLIX: Advanced Write Protocols
- Part L: AI-Integrated API Design
- Part LI: API Lifecycle Management
- Part LII: Microservices Operations
- Part LIII: Regulatory Compliance
- Part LIV: Maturity Model (5 Levels)
- Part LV: Anti-Pattern Collection (25 Items)
- Part LVI: Agentic API Design (MCP/A2A/ACP)
- Part LVII: HTTP/3 & QUIC Migration
- Part LVIII: WebTransport Design
- Part LIX: API Supply Chain Security
- Part LX: Kubernetes Gateway API
- Part LXI: AI-Driven API Testing
- Part LXII: API Governance Deep Dive
- Part LXIII: GraphQL 2025+ Extensions
- Part LXIV: gRPC 2025+ Extensions
- Part LXV: API Evolution Strategy
- Part LXVI: Multi-Cloud API Management
- Part LXVII: Edge-Native API
- Part LXVIII: API Marketplace & Ecosystem
- Part LXIX: Green API / Sustainability
- Part LXX: Future Outlook
- Appendix A: Quick Reference Index
- Appendix B: Cross-References

---

## Part I: Supreme Directive & API Philosophy

### 1.1. Supreme Principles of API Implementation

- **Rule 35.1**: All APIs must be designed as "Salable Assets." Even internal-only APIs must not be developed carelessly, as that creates seeds of technical debt
- **Rule 35.2**: Breaking changes to an API are equivalent to a "product recall." Design with compatibility as the top priority
- **Rule 35.3**: API design must define contracts (specifications) before code (Contract-First)

### 1.2. Priority Hierarchy

| Priority | Domain | Description |
|:---|:---|:---|
| **P0** | Security | AuthN/AuthZ, input validation, PII protection, Zero Trust |
| **P1** | Reliability | Idempotency, circuit breaker, graceful degradation |
| **P2** | Compatibility | Versioning, deprecation, backward compatibility |
| **P3** | Performance | Latency, throughput, cache optimization |
| **P4** | DX | Documentation, SDK, error message clarity |

### 1.3. Omnichannel First Principle

- **Rule 35.4**: Treating the web frontend as a "privileged client" is prohibited. Treat iOS/Android apps equally, and make all operations available via API for external consumption
- Tiered Gateway: Separate "Tier 1 (Public/Read-Only)" and "Tier 2 (Enterprise/Auth/Paid)" from the start to prepare for future API monetization (Stripe Metering)

---

## Part II: API Design Principles

### 2.1. API-First Design

- **Rule 35.5**: Always define the API specification (contract) before starting implementation
- Enable parallel development of frontend and backend
- Auto-generate mocks/stubs from specifications and run integration tests in advance

### 2.2. Contract-First Development

- **OpenAPI 3.1**: REST APIs must be defined with OpenAPI 3.1 specification as the source of truth, auto-generating code, type definitions, and client SDKs
- **Schema-Driven (GraphQL)**: GraphQL uses schema definitions as the source of truth, ensuring type safety between frontend and backend
- **Protobuf (gRPC)**: gRPC uses `.proto` files as the source of truth, automating multi-language code generation

### 2.3. Mandatory Code Generation

- **Rule 35.6**: Hand-written type definitions are prohibited. Always auto-generate client code and server type definitions from OpenAPI/GraphQL/Protobuf schemas

```typescript
// ✅ Correct: Auto-generated from OpenAPI specification
import type { paths } from '@/generated/api-types';
type StoreResponse = paths['/api/v1/stores/{id}']['get']['responses']['200']['content']['application/json'];

// ❌ Prohibited: Hand-written type definition
interface StoreResponse {
  id: string;
  name: string;
  // ... manual maintenance will break down
}
```

### 2.4. API Governance

- **API Review Board**: Only allow implementation after design review for new APIs and Breaking Changes
- **API Style Guide**: Unify API design guidelines across the organization for consistency
- **Linting**: Integrate OpenAPI spec linting (Spectral, etc.) into CI to auto-detect design rule violations

---

## Part III: Protocol Selection Strategy

### 3.1. Protocol Selection Matrix

| Protocol | Use Case | Advantages | Constraints |
|:---|:---|:---|:---|
| **REST** | Public APIs, CRUD, 3rd-party integrations | Versatility, caching, rich tooling | Over-fetching, verbose multi-resource retrieval |
| **GraphQL** | Complex data fetching, BFF, mobile optimization | Flexible queries, type-safe, eliminates under-fetching | Learning curve, complex caching, N+1 problem |
| **gRPC** | Internal microservice communication, real-time | High performance, type-safe, streaming | No browser support (requires gRPC-Web), debugging difficulty |
| **AsyncAPI** | Event-driven, asynchronous messaging | Loose coupling, scalability | Design complexity, event ordering challenges |
| **WebSocket** | Real-time bidirectional communication, chat, notifications | Low latency, persistent connection | Connection management, scaling complexity |
| **SSE** | Server-to-client real-time delivery, streaming | Simple, HTTP compatible | Unidirectional only |

### 3.2. Protocol Selection Principles

- **Rule 35.7**: REST is the standard for externally published APIs (maximum versatility and tool ecosystem)
- **Rule 35.8**: gRPC is recommended for internal communication between microservices (performance and type safety)
- **Rule 35.9**: GraphQL is recommended for frontend-facing BFF (eliminates over-fetching and saves bandwidth)
- **Rule 35.10**: Define contracts for event-driven patterns using AsyncAPI specification

### 3.3. Multi-Protocol Gateway

- Deploy the API Gateway as a "protocol orchestrator" to transparently perform protocol conversion such as external REST to internal gRPC

---

## Part IV: RESTful API Design Standards

### 4.1. Resource-Oriented Design

- **Rule 35.11**: Use resource nouns (plural) in URLs, not action verbs

```
✅ GET    /api/v1/stores
✅ POST   /api/v1/stores
✅ GET    /api/v1/stores/{storeId}
✅ PATCH  /api/v1/stores/{storeId}
✅ DELETE /api/v1/stores/{storeId}

❌ GET    /api/v1/getStores
❌ POST   /api/v1/createStore
❌ POST   /api/v1/deleteStore/{id}
```

### 4.2. HTTP Method Semantics

| Method | Purpose | Idempotent | Safe |
|:---|:---|:---|:---|
| **GET** | Retrieve resource | ✅ Yes | ✅ Yes |
| **POST** | Create resource, non-idempotent operations | ❌ No | ❌ No |
| **PUT** | Full resource replacement | ✅ Yes | ❌ No |
| **PATCH** | Partial resource update | ❌ No | ❌ No |
| **DELETE** | Delete resource | ✅ Yes | ❌ No |

### 4.3. HTTP Status Code Standards

| Code | Usage | Notes |
|:---|:---|:---|
| **200** | Success (with data) | Success for GET/PATCH/PUT |
| **201** | Resource created | POST success. Return new resource URL via `Location` header |
| **204** | Success (no data) | DELETE success |
| **400** | Bad request | Validation error |
| **401** | Authentication error | Token not provided or invalid |
| **403** | Authorization error | Insufficient permissions |
| **404** | Resource not found | |
| **409** | Conflict | Optimistic lock failure, duplicate creation |
| **422** | Unprocessable entity | Business logic validation |
| **429** | Rate limit exceeded | `Retry-After` header required |
| **500** | Internal server error | Do not leak details externally |
| **503** | Service unavailable | During maintenance |

- **Rule 35.12**: All non-`2xx` responses must return RFC 7807 compliant error bodies

---

## Part V: URL & Resource Design

### 5.1. URL Naming Conventions

- **kebab-case**: URL path segments use `kebab-case` (e.g., `/store-categories`)
- **Plural**: Collection resources use plural form (e.g., `/stores`, `/users`)
- **Max Depth**: Nesting limited to 2 levels (e.g., `/stores/{id}/reviews` is OK, `/stores/{id}/reviews/{rid}/comments` is not → use `/comments?reviewId={rid}`)

### 5.2. Filtering, Sorting & Pagination

- **Filtering**: Use query parameters (e.g., `?status=active&region=tokyo`)
- **Sorting**: `?sort=created_at:desc,name:asc`
- **Pagination**:

| Method | Recommendation | Use Case |
|:---|:---|:---|
| **Cursor-Based** | ✅ Recommended | Large datasets, real-time updates |
| **Offset-Based** | ⚠ Limited | Small fixed datasets, admin panels |
| **Keyset-Based** | ✅ Recommended | High performance requirements |

- **Rule 35.13**: Cursor-Based Pagination is the standard. Offset-Based is limited to admin panels due to performance degradation with large datasets

```json
{
  "data": [...],
  "pagination": {
    "next_cursor": "eyJpZCI6MTAwfQ==",
    "has_more": true,
    "total_count": 1523
  }
}
```

### 5.3. Field Selection (Sparse Fieldsets)

- Enable limiting returned fields with `?fields=id,name,address` parameter
- Effective for bandwidth savings and mobile app performance optimization

---

## Part VI: Versioning Strategy

### 6.1. URL-Based Versioning (Recommended)

- **Rule 35.14**: Use `/api/v{major}/` format as standard (e.g., `/api/v1/stores`)
- Higher discoverability than header-based or query-based, easier documentation and testing

### 6.2. Breaking Change Definition

| Change Type | Breaking | Example |
|:---|:---|:---|
| Response field **removal** | ✅ Yes | Removing `address` field |
| Response field **type change** | ✅ Yes | `price: string` → `price: number` |
| Required parameter **addition** | ✅ Yes | Making new parameter `region` required |
| Response field **addition** | ❌ No | Adding new field `rating_count` |
| Optional parameter **addition** | ❌ No | Adding `?sort=newest` |
| Endpoint **addition** | ❌ No | New `/api/v1/reviews` |
| HTTP status code **change** | ✅ Yes | Changing 200 → 201 |
| Error response structure **change** | ✅ Yes | Changing error JSON schema |

### 6.3. Deprecation Protocol

1. **Parallel Operation**: Old version runs for a **minimum of 6 months** after new version release
2. **Sunset Header**: Attach `Sunset: <date>` header to deprecated API responses (RFC 8594 compliant)
3. **Deprecation Header**: Attach `Deprecation: true` header (RFC 8594 compliant)
4. **Notification Obligation**: Email API key holders 3 months, 1 month, and 1 week before
5. **Documentation**: Post deprecation notice and migration guide in specification docs
6. **Usage Monitoring**: Monitor old version usage and do not retire until usage reaches zero

### 6.4. Additive Change Strategy

- **Rule 35.15**: Evolve through additive changes whenever possible to avoid version increments
- Adding new fields, endpoints, and optional parameters are not Breaking Changes
- Clients implement the "Tolerant Reader" pattern that ignores unknown fields

---

## Part VII: Request & Response Design

### 7.1. DTO Obligation (Data Transport Obligation)

- **Rule 35.16**: Returning database Row objects (Raw Row) directly is a "serious offense." Always route through `UserDTO` etc. and output only intentionally mapped fields
- **Admin Data Leak Defense**: Prohibit `SELECT *` even in admin-facing APIs and define dedicated `AdminDTO`. Physically prevent automatic leakage when future confidential columns like `internal_memo` or cost data are added
- **DTO Assertion Testing**: API test cases must include `assert(field is undefined)` tests confirming that excluded fields (PII, etc.) are not present

### 7.2. Response Envelope

```json
{
  "data": { ... },
  "meta": {
    "request_id": "req_abc123",
    "timestamp": "2026-03-22T09:00:00Z",
    "tier": "enterprise",
    "usage": "metered",
    "revalidation_ttl": 300
  },
  "pagination": { ... }
}
```

- **Rule 35.17**: Include `meta` field in all success responses with `request_id` and `timestamp` as required
- **AI Context Meta**: Include `tier`, `usage`, `revalidation` as meta information to support AI agent inference accuracy and FinOps optimization

### 7.3. PII Masking

- Structurally prevent leakage of password hashes, internal flags (`is_admin`), and personal information
- Implement automatic exclusion of PII fields at the response serialization stage

---

## Part VIII: RFC 7807+ Semantic Errors

### 8.1. RFC 7807 Problem Details

- **Rule 35.18**: Error responses must comply with RFC 7807 (Problem Details for HTTP APIs)

```json
{
  "type": "https://api.example.com/errors/validation-failed",
  "title": "Validation Failed",
  "status": 422,
  "detail": "The 'email' field must be a valid email address.",
  "instance": "/api/v1/users",
  "errors": [
    {
      "field": "email",
      "code": "INVALID_FORMAT",
      "message": "Must be a valid email address"
    }
  ],
  "trace_id": "trace_abc123"
}
```

### 8.2. Backend Error Propagation Ban

- **Rule 35.19**: Displaying raw server-side technical error messages (`"Row not found"`, `"upstream connect error"`) directly in UI is prohibited
- Client-side translates to localized, user-comprehensible messages based on error type

### 8.3. Gateway Instrumentation Protocol

- **Rule 35.20**: Directly embedding error objects into string templates in Gateway/Service layer `catch` blocks is prohibited

```typescript
// ❌ Prohibited: Outputs [object Object], obscuring root cause
catch (error) {
  logger.error(`Gateway error: ${error}`);
}

// ✅ Correct: Structured logging with explicit decomposition
catch (error) {
  logger.error('Gateway operation failed', {
    message: error?.message,
    code: error?.code,
    details: error?.details,
    hint: error?.hint,
  });
}
```

### 8.4. HTTP Status Mapping

- Appropriately map database error codes to HTTP status codes

| DB Error Code | Meaning | HTTP Status |
|:---|:---|:---|
| `23505` | Unique Violation | `409 Conflict` |
| `23503` | Foreign Key Violation | `422 Unprocessable Entity` |
| `42501` | Insufficient Privileges | `403 Forbidden` |
| `PGRST301` | Row-Level Security Violation | `403 Forbidden` |

---

## Part IX: GraphQL Design Standards

### 9.1. Schema Design Principles

- **Rule 35.21**: GraphQL schemas must faithfully reflect the domain model and be designed around "what the client needs"
- Name all operations (anonymous queries are prohibited)
- Use variables for dynamic input (literal value embedding in queries is prohibited)

### 9.2. Naming Conventions

| Element | Convention | Example |
|:---|:---|:---|
| Type | PascalCase | `Store`, `UserProfile` |
| Field | camelCase | `storeName`, `createdAt` |
| Query | camelCase | `store`, `stores`, `storeById` |
| Mutation | camelCase (verb+noun) | `createStore`, `updateUser` |
| Enum | SCREAMING_SNAKE_CASE | `STORE_STATUS_ACTIVE` |
| Input | PascalCase + `Input` suffix | `CreateStoreInput` |

### 9.3. Pagination (Relay Specification)

- **Rule 35.22**: GraphQL pagination must comply with the Relay Cursor Connections specification

```graphql
type Query {
  stores(first: Int, after: String, last: Int, before: String): StoreConnection!
}

type StoreConnection {
  edges: [StoreEdge!]!
  pageInfo: PageInfo!
  totalCount: Int!
}

type StoreEdge {
  node: Store!
  cursor: String!
}
```

---

## Part X: GraphQL Federation

### 10.1. GraphQL Federation Architecture

- **Supergraph**: A single GraphQL endpoint integrating multiple Subgraphs
- **Subgraph**: Independent GraphQL schemas managed by each microservice
- **Router**: Gateway that routes queries to appropriate Subgraphs (Apollo Router, etc.)

### 10.2. Subgraph Design Principles

- **Rule 35.23**: Each Subgraph must align with domain boundaries (Bounded Context)
- Circular dependencies between Subgraphs are prohibited
- Use `@key` directive to explicitly declare entity ownership
- Use `@shareable` to declare field sharing

### 10.3. Composition Verification

- **CI/CD Pipeline**: Automatically execute Supergraph Composition verification on Subgraph changes
- **Breaking Change Detection**: Automatically check in CI whether schema changes break existing queries

---

## Part XI: GraphQL Security & Performance

### 11.1. Security Measures

| Measure | Description | Standard |
|:---|:---|:---|
| **Query Depth Limiting** | Limit nesting depth | Max depth: 10 |
| **Query Complexity** | Limit query computation cost | Max cost: 1000 |
| **Persisted Queries** | Allow only pre-registered queries | Required in production |
| **Introspection Disable** | Prevent schema exposure in production | Required in production |
| **Rate Limiting** | Per-query rate limiting | Endpoint + query complexity |

### 11.2. N+1 Problem Resolution

- **DataLoader Pattern**: Eliminate N+1 queries through batching and caching

```typescript
// ✅ Batching with DataLoader
const storeLoader = new DataLoader<string, Store>(async (ids) => {
  const stores = await db.stores.findMany({ where: { id: { in: ids } } });
  return ids.map(id => stores.find(s => s.id === id)!);
});
```

### 11.3. Performance Optimization

- **Automatic Persisted Queries (APQ)**: Send only query hashes to minimize payload
- **@defer / @stream**: Incrementally stream large responses
- **Caching**: Separate global data and user-specific data to maximize cache efficiency

---

## Part XII: gRPC Design Standards

### 12.1. Service Definition

- **Rule 35.24**: gRPC services must be designed domain-oriented, aligning with business boundaries

```protobuf
syntax = "proto3";

package store.v1;

service StoreService {
  rpc GetStore(GetStoreRequest) returns (Store);
  rpc ListStores(ListStoresRequest) returns (ListStoresResponse);
  rpc CreateStore(CreateStoreRequest) returns (Store);
  rpc UpdateStore(UpdateStoreRequest) returns (Store);
  rpc DeleteStore(DeleteStoreRequest) returns (google.protobuf.Empty);
  rpc WatchStoreUpdates(WatchStoreUpdatesRequest) returns (stream StoreUpdate);
}
```

### 12.2. Streaming Patterns

| Pattern | Description | Use Case |
|:---|:---|:---|
| **Unary** | Single request → single response | Standard CRUD |
| **Server Streaming** | Single request → multiple responses | Real-time updates, large data |
| **Client Streaming** | Multiple requests → single response | File upload |
| **Bidirectional Streaming** | Multiple requests ↔ multiple responses | Chat, collaboration |

### 12.3. Error Handling

- Use gRPC status codes appropriately and return rich error information via `google.rpc.Status`
- Classify `UNAVAILABLE` as retryable and `INVALID_ARGUMENT` as non-retryable

---

## Part XIII: gRPC Advanced Patterns

### 13.1. Channel Management

- **Rule 35.25**: gRPC Channel reuse is mandatory. Channel creation involves multiple network round-trips as a costly operation, so per-request creation is prohibited

### 13.2. Interceptors (Middleware)

- Implement cross-cutting concerns such as authentication, logging, metrics collection, and retries as Interceptors
- Each Interceptor has a single responsibility, composed as a chain

### 13.3. Deadline Propagation

- **Rule 35.26**: Set deadlines (timeouts) for all gRPC calls. Calls without deadlines are prohibited due to runaway risk
- Propagate deadlines through service chains and complete processing within remaining time

### 13.4. Health Checking

- Implement gRPC Health Checking Protocol (`grpc.health.v1.Health`) in all services
- Integrate with Kubernetes Readiness/Liveness Probes

---

## Part XIV: Protocol Buffers Management

### 14.1. Schema Registry

- **Rule 35.27**: `.proto` files are centrally managed in a dedicated repository (Schema Registry)
- **Buf CLI**: Unify lint, breaking change detection, and code generation with `buf` CLI

### 14.2. Breaking Change Detection

- Integrate `buf breaking` command into CI pipelines to automatically detect and block breaking changes (field removal, type changes, field number reuse, etc.)

### 14.3. Field Number Management

- Once used, field numbers must be `reserved` and reuse is prohibited
- Add deleted field numbers and names to `reserved`

```protobuf
message Store {
  reserved 3, 7;
  reserved "old_field_name";
  
  string id = 1;
  string name = 2;
  // field 3 was 'legacy_code', removed in v2
}
```

---

## Part XV: Event-Driven Architecture

### 15.1. Event-Driven Patterns

| Pattern | Description | Use Case |
|:---|:---|:---|
| **Event Notification** | Lightweight event (ID + type only) | Loosely coupled notification |
| **Event-Carried State Transfer** | Event includes full data | Cache sync, read optimization |
| **Event Sourcing** | Events as the sole source of truth | Audit logs, Undo/Redo |
| **CQRS** | Command-Query Responsibility Segregation | High scalability requirements |

### 15.2. Event Design Standards

- **Rule 35.28**: Events are immutable; modifying past events is prohibited
- Use past tense for event names (e.g., `StoreCreated`, `OrderCompleted`)

```json
{
  "event_id": "evt_abc123",
  "event_type": "store.created",
  "event_version": "1.0",
  "timestamp": "2026-03-22T09:00:00Z",
  "source": "store-service",
  "correlation_id": "corr_xyz789",
  "data": {
    "store_id": "store_001",
    "name": "Example Store"
  },
  "metadata": {
    "actor_id": "user_456",
    "trace_id": "trace_def456"
  }
}
```

### 15.3. Saga Pattern

- Use the Saga pattern to ensure consistency across distributed transactions

| Method | Description | Recommendation |
|:---|:---|:---|
| **Choreography** | Each service publishes and subscribes to events | For simple flows |
| **Orchestration** | Central orchestrator controls the flow | For complex flows (recommended) |

- Define compensating transactions for each step
- Persist Saga state to guarantee recovery on failure

### 15.4. Outbox Pattern

- **Rule 35.29**: Mandate the Outbox pattern to guarantee atomicity of database updates and event publishing
- Write events to the `outbox` table within a DB transaction, and a separate process publishes events via polling or CDC (Change Data Capture)

---

## Part XVI: AsyncAPI & Messaging Design

### 16.1. AsyncAPI Specification

- **Rule 35.30**: Define contracts for asynchronous messaging using AsyncAPI 3.0 specification
- Centrally manage channels, message schemas, servers, and security requirements
- Auto-generate documentation, code, and validators from AsyncAPI

### 16.2. Message Broker Selection Criteria

| Broker | Use Case | Characteristics |
|:---|:---|:---|
| **Apache Kafka** | Large-scale event streams, log aggregation | High throughput, persistence, ordering |
| **RabbitMQ** | Task queues, work dispatch | Flexible routing, ACK control |
| **Amazon SQS/SNS** | Serverless integration, fan-out | Managed, scalable |
| **pgmq** | PostgreSQL-integrated queue | Transaction-integrated, simple |
| **Redis Streams** | Low latency, lightweight events | In-memory, Consumer Groups |

### 16.3. Message Design Principles

- **Schema Versioning**: Message schemas evolve while maintaining backward compatibility
- **Dead Letter Queue (DLQ)**: Always implement isolation and reprocessing mechanisms for failed messages
- **At-Least-Once + Idempotency**: Assume At-Least-Once delivery, guarantee idempotency on the consumer side
- **Poison Message Prevention**: Set retry limits and DLQ forwarding to prevent invalid messages from causing infinite retries

---

## Part XVII: Webhook Design & Operations

### 17.1. Webhook Signature Verification

- **Rule 35.31**: Processing webhooks from external services (Stripe, Meta, GitHub, etc.) without signature verification (`X-Hub-Signature`, etc.) is prohibited
- Verify request authenticity using the platform-provided `Signing Secret`

### 17.2. Replay Attack Prevention

- Validate `timestamp` in webhook payload and reject requests **older than 5 minutes**
- Cache processed event IDs for a period to prevent duplicate execution

### 17.3. Idempotency Guarantee

- Design so that the same `event_id` webhook arriving multiple times produces side effects only once
- Use webhook unique ID as idempotency key and perform duplicate check in DB before processing

### 17.4. Webhook Error Handling

- Return `5xx` on processing failure, delegating to the sender's retry mechanism
- Returning `2xx` causes the sender to consider it "successful" and not retry, losing incomplete processing
- Immediately return `401 Unauthorized` for signature-mismatched requests and record in alert logs

### 17.5. Webhook Delivery Design (Provider Side)

- **Exponential Backoff Retry**: Max 5 attempts, 5s→30s→2min→10min→30min
- **Event Registration**: Allow users to select event types to receive
- **Webhook Management API**: Provide APIs for registration, update, deletion, and test delivery
- **Delivery Logs**: Log delivery results (success/failure, status code, response time) and visualize in dashboard

---

## Part XVIII: API Gateway Architecture

### 18.1. API Gateway Responsibilities

| Responsibility | Description |
|:---|:---|
| **Routing** | Forward requests to appropriate backend services |
| **AuthN/AuthZ** | JWT/API key validation, OAuth 2.1 token verification |
| **Rate Limiting** | Traffic control, DDoS prevention |
| **Protocol Conversion** | Protocol bridging such as REST↔gRPC |
| **Request/Response Transformation** | Header addition, payload transformation |
| **Caching** | Response caching |
| **Observability** | Access logs, metrics, tracing |
| **Usage Metering** | Metering log |

### 18.2. Gateway Deployment Patterns

- **Edge Gateway**: Entry point for external traffic (North-South)
- **Internal Gateway**: Routing between microservices (East-West) (Service Mesh recommended)
- **Domain Gateway**: Routing per domain boundary

### 18.3. Intelligent Gateway

- AI/ML-driven smart traffic management
- Real-time rate limit adjustment through anomaly detection
- Predictive capacity management through traffic pattern analysis

---

## Part XIX: Service Mesh Design

### 19.1. Service Mesh vs API Gateway

| Aspect | API Gateway | Service Mesh |
|:---|:---|:---|
| **Traffic Direction** | North-South (external→internal) | East-West (inter-service) |
| **Deployment** | Edge | Sidecar proxy |
| **Key Functions** | Auth aggregation, rate limiting, protocol conversion | Automatic mTLS, retries, circuit breaker |
| **Observability** | API-level metrics | Inter-service communication metrics |

- **Rule 35.32**: API Gateway and Service Mesh are **complementary**, not competing technologies

### 19.2. Automatic mTLS

- Mandate automatic mTLS encryption for inter-service communication via Service Mesh
- Automate certificate rotation, eliminating manual management

### 19.3. Traffic Management

- **Traffic Shifting**: Gradual traffic migration during canary deployments
- **Fault Injection**: Failure simulation in test environments
- **Retry Policy**: Retry configuration at the service mesh level

---

## Part XX: BFF (Backend for Frontend) Pattern

### 20.1. BFF Design Principles

- **Rule 35.33**: Design optimized BFF layers for each frontend platform

| BFF Type | Target | Optimization Strategy |
|:---|:---|:---|
| **Web BFF** | Web apps | SSR/ISR support, SEO metadata |
| **Mobile BFF** | iOS/Android apps | Bandwidth minimization, batch APIs |
| **Admin BFF** | Admin panels | High-density data, bulk operations |

### 20.2. GraphQL BFF

- Adopt GraphQL for frontend-facing BFF to eliminate over-fetching
- Each BFF aggregates multiple backend microservices, providing a single endpoint for the frontend

### 20.3. BFF Anti-Patterns

- ❌ Placing business logic in BFF (BFF is for data aggregation and transformation only)
- ❌ BFF directly accessing DB (must go through API layer)
- ❌ Sharing a single BFF across all platforms (ignoring platform-specific needs)

---

## Part XXI: Resilience Patterns

### 21.1. Circuit Breaker

- **Rule 35.34**: Circuit breakers are mandatory for all external service calls

| State | Behavior |
|:---|:---|
| **Closed** | Normal operation. Monitoring failure count |
| **Open** | Immediately returns error. Blocks requests to backend |
| **Half-Open** | Tries small number of requests. Closed on success, Open on failure |

- **Adaptive Circuit Breaker**: Dynamically adjust failure rate thresholds based on traffic patterns and latency

### 21.2. Retry Strategy

- **Rule 35.35**: Apply "exponential backoff + jitter" for transient errors to avoid Thundering Herd problems

```typescript
// Exponential backoff + Jitter
const delay = Math.min(
  baseDelay * Math.pow(2, attempt) + Math.random() * jitterMs,
  maxDelay
);
```

- Clearly define retryable conditions (5xx, UNAVAILABLE, timeout, etc.)
- Set maximum retry count (recommended: 3)

### 21.3. Bulkhead Pattern

- Isolate resource pools (threads, connections) per service to prevent failure propagation
- One service's failure must not exhaust other services' resources

### 21.4. Timeout Design

- **Rule 35.36**: Set timeouts for all external calls. Calls without timeouts are prohibited
- Set connection timeout (recommended: 3s) and request timeout (recommended: 10s) separately
- In service chains, set upstream timeouts considering downstream timeouts

### 21.5. Fallback Pattern

- Pre-define alternative behavior for primary service failures
- Return cached data, default values, degraded functionality, etc.

---

## Part XXII: Idempotency Design

### 22.1. Idempotency-Key

- **Rule 35.37**: Mandate `Idempotency-Key` header implementation for all requests with side effects (POST/PUT/PATCH) such as payments, creation, and updates
- Even when retries occur due to network errors, requests with the same key are processed "only once" server-side, reliably preventing double charges

### 22.2. Idempotency Implementation Pattern

```typescript
// Server-side idempotency check
async function processWithIdempotency(key: string, handler: () => Promise<Result>) {
  const existing = await db.idempotencyKeys.findUnique({ where: { key } });
  if (existing) return existing.response; // Return cached response

  const result = await handler();
  await db.idempotencyKeys.create({
    data: { key, response: result, expires_at: addHours(24) }
  });
  return result;
}
```

### 22.3. Idempotency Key Management

- TTL: Retain for 24+ hours, auto-delete after expiration
- Storage: Redis (fast) or DB (persistent)
- Key format: `{client_id}:{operation}:{unique_id}`

---

## Part XXIII: Rate Limiting & Throttling

### 23.1. Rate Limiting Algorithms

| Algorithm | Characteristics | Recommended Case |
|:---|:---|:---|
| **Token Bucket** | Burst-tolerant, stable throughput | General APIs (recommended) |
| **Sliding Window** | Precise time window, uniform distribution | When strict limiting is needed |
| **Fixed Window** | Simple implementation | When low precision suffices |
| **Leaky Bucket** | Constant rate processing | When uniform processing is needed |

### 23.2. Distributed Rate Limiting

- **Rule 35.38**: Implement accurate rate limiting across distributed environments using Token Bucket algorithm with Redis as the backing store

### 23.3. Rate Limit Headers

- **Rule 35.39**: Notify rate limit information via response headers

```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 42
X-RateLimit-Reset: 1711101600
Retry-After: 30
```

### 23.4. Tier-Based Rate Limits

| Tier | Rate Limit | Burst |
|:---|:---|:---|
| **Free** | 100 req/min | 10 req/sec |
| **Pro** | 1,000 req/min | 50 req/sec |
| **Enterprise** | 10,000 req/min | 500 req/sec |
| **Native App (VIP)** | Enterprise equivalent | Enterprise equivalent |

---

## Part XXIV: API SLO & Reliability Contracts

### 24.1. API SLI/SLO Definition

| SLI | Measurement | SLO Target |
|:---|:---|:---|
| **Availability** | Successful requests / total requests | ≥ 99.9% |
| **Latency (p50)** | Median request processing time | ≤ 100ms |
| **Latency (p99)** | 99th percentile request processing time | ≤ 500ms |
| **Error Rate** | 5xx responses / total responses | ≤ 0.1% |
| **Throughput** | Requests processed per second | ≥ 1,000 rps |

### 24.2. External Dependency SLO

- **Rule 35.40**: Factor external service (Stripe, OpenAI, etc.) SLOs into your own SLO. Define "End-to-End SLO" including external dependencies
- External service downtime consumes your own Error Budget

### 24.3. Error Budget Policy

- When Error Budget is exhausted, freeze new feature development and focus on reliability improvement
- Set alert thresholds based on Error Budget consumption rate

---

## Part XXV: Graceful Degradation & Fault Isolation

### 25.1. Graceful Degradation

- **Rule 35.41**: APIs must continue partial functionality even when external dependencies fail
- Link with Feature Flags to disable only features dependent on the failed service
- Pre-define fallback strategies such as cached data responses, default value returns

### 25.2. Fault Isolation Levels

| Level | Target | Method |
|:---|:---|:---|
| **Process Isolation** | CPU/Memory | Bulkhead, resource pool isolation |
| **Service Isolation** | Inter-service dependencies | Circuit breaker, timeouts |
| **Data Isolation** | Data access | Database-per-Service, Read Replicas |
| **Infrastructure Isolation** | Infrastructure failures | Multi-AZ, Cell-Based Architecture |

---

## Part XXVI: API Security Foundation

### 26.1. Zero Trust API Security

- **Rule 35.42**: Design all API requests under the premise of "never trust." Verify authentication and authorization per request, not per network boundary
- Mutually authenticate inter-microservice communication with mTLS

### 26.2. OWASP API Security Top 10 2023/2025 Compliance

**API Security Top 10 2023 (API-Specific):**

| # | Risk | Countermeasure |
|:---|:---|:---|
| **API1** | Broken Object Level Authorization (BOLA) | Object-level authorization check on resource access |
| **API2** | Broken Authentication | OAuth 2.1, MFA, rate limiting |
| **API3** | Broken Object Property Level Authorization | DTO obligation, field-level authorization |
| **API4** | Unrestricted Resource Consumption | Rate limiting, payload size limits |
| **API5** | Broken Function Level Authorization | RBAC/ABAC, least privilege |
| **API6** | Unrestricted Access to Sensitive Business Flows | Business flow-level rate limiting |
| **API7** | Server Side Request Forgery (SSRF) | URL whitelist, internal network blocking |
| **API8** | Security Misconfiguration | Automated config validation, minimal exposure |
| **API9** | Improper Inventory Management | API catalog, version management |
| **API10** | Unsafe Consumption of APIs | Third-party API response validation |

**OWASP Top 10:2025 (Web General, API-Relevant Enhancements):**

| # | Risk | API-Focused Countermeasure |
|:---|:---|:---|
| **A01** | Broken Access Control (SSRF integrated) | Thorough BOLA/BFLA, implement SSRF defense at API layer |
| **A02** | Security Misconfiguration | API Gateway config auto-validation, default-deny |
| **A03** | Software Supply Chain Failures (New) | SBOM management for API dependencies (→ Part LIX) |
| **A05** | Injection | Mandatory schema validation for API inputs |
| **A10** | Mishandling of Exceptional Conditions (New) | Standardize API exception handling, enforce RFC 7807 |

### 26.3. AI Agent API Security

- **Rule 35.79**: Apply distinct rate limiting, scope restrictions, and audit policies for API calls from AI agents, different from regular users
- Implement guardrails to prevent AI agent "privilege escalation" and "excessive tool execution"
- Mandate compliance with OWASP Top 10 for LLM Applications 2025 (Prompt Injection, Sensitive Data Exposure, Supply Chain)

### 26.4. HTTPS Mandate

- **Rule 35.80**: Mandate HTTPS/TLS 1.3 in all environments (including development). HTTP communication is completely prohibited

---

## Part XXVII: Authentication & Authorization Architecture

### 27.1. OAuth 2.1

- **Rule 35.44**: Authentication flows must comply with OAuth 2.1
- **PKCE Mandatory**: Mandate PKCE for all authorization code flows (both public and confidential clients)
- **Deprecated Flow Elimination**: Completely prohibit Implicit Grant and Resource Owner Password Credentials Grant
- **Sender-Constrained Tokens**: Recommend token binding via DPoP or mTLS

### 27.2. DPoP (Demonstrating Proof of Possession)

- Bind access tokens to client's private key, preventing misuse when tokens are stolen
- Particularly effective for mobile apps and public clients

### 27.3. Passkeys / FIDO2

- Recommend implementation of passwordless authentication
- Phishing-resistant, improves UX through device biometrics (fingerprint, facial recognition)
- Integration with WebAuthn API

### 27.4. Bearer Token Verification

- **Rule 35.45**: Bearer Token verification must use server-side verification such as `supabase.auth.getUser()`, not just signature checking. Verify ban status and session expiration in real-time

### 27.5. Native Bypass Protocol (VIP Lane Strategy)

- **Rule 35.46**: Requiring API Key (`x-api-key`) from own apps is prohibited. Implement OR condition in Middleware for API Key authentication (Enterprise) and Bearer Token authentication (Native/VIP), granting Enterprise-equivalent privileges to authenticated own-app users

---

## Part XXVIII: API Key & Token Management

### 28.1. API Key Storage

- **Rule 35.47**: Storing API Keys (`sk_live_...`) in plaintext in DB is strictly prohibited. Store hashed with `SHA-256` and verify by hashing input values during authentication

### 28.2. Token Lifecycle

| Token Type | TTL | Rotation |
|:---|:---|:---|
| **Access Token** | 15 minutes | Automatic (using Refresh Token) |
| **Refresh Token** | 7 days | Rotation method (new issuance on use) |
| **API Key** | No expiration | Manual rotation every 90 days |

### 28.3. Scope Minimization

- **Rule 35.48**: Grant only minimum required scopes to API keys and tokens
- Granularize scopes into read-only, write-only, admin, etc.

---

## Part XXIX: Input Validation & Sanitization

### 29.1. Schema Validation

- **Rule 35.49**: Perform request body schema validation on all API endpoints (Zod, Joi, etc.)
- Reject unknown fields (`strictMode`)

### 29.2. Content-Type Enforcement

- Make `Content-Type` header validation mandatory, reject unexpected Content-Types
- Do not accept incorrect Content-Types like `text/plain` on JSON endpoints

### 29.3. Payload Size Limits

- Set request body size limits (recommended: 1MB, file uploads designed separately)
- Prevent DoS attacks via oversized JSON payloads

### 29.4. SSRF Prevention

- When using user-provided URLs for internal requests, mandate whitelist verification and internal IP blacklist checks
- Block requests to private IPs: `169.254.169.254` (cloud metadata), `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`

---

## Part XXX: CORS Governance

### 30.1. CORS Governance Protocol

- **Rule 35.50**: Block all requests from origins not explicitly permitted

### 30.2. Environment-Specific CORS Policies

| Environment | Allowed Origins | Configuration Method |
|:---|:---|:---|
| **Production** | Own domains only | Framework configuration file |
| **Preview/Staging** | Preview domain patterns | Dynamic via environment variables |
| **Development** | `http://localhost:*` | `.env.local` |
| **API Resale (Future)** | Contracted domain whitelist | DB managed + linked to API key |

### 30.3. CORS Security Rules

- `Access-Control-Allow-Credentials: true` is limited to auth-required endpoints only, combined with `Allow-Origin: *` is **strictly prohibited**
- Set `Access-Control-Max-Age: 86400` to reduce unnecessary OPTIONS requests
- Using `Access-Control-Allow-Origin: *` in production is strictly prohibited (see `600_security_privacy.md`)

---

## Part XXXI: DTO Design & Data Mapping

### 31.1. DTO Obligation (Data Transport Obligation)

- **Rule 35.51**: Returning database Raw objects directly as API responses is a "serious offense"
- Define layer-specific DTOs and perform intentional field mapping at each layer

### 31.2. DTO Hierarchy

| DTO | Purpose | Included Fields |
|:---|:---|:---|
| **PublicDTO** | Public-facing API | Only publicly shareable basic info |
| **AuthenticatedDTO** | For logged-in users | Adds user-specific info |
| **AdminDTO** | For admin API | Adds operational info (excluding internal memos) |
| **InternalDTO** | Internal service communication | All fields (never exposed externally) |

### 31.3. DTO Assertion Tests

```typescript
// ✅ Tests verifying absence of excluded fields
it('should not expose password_hash in response', async () => {
  const response = await api.get('/api/v1/users/1');
  expect(response.data).not.toHaveProperty('password_hash');
  expect(response.data).not.toHaveProperty('is_admin');
  expect(response.data).not.toHaveProperty('internal_memo');
});
```

---

## Part XXXII: Data Serialization

### 32.1. JSON Design Standards

- Unify field names with `camelCase` (REST) or `snake_case` (DB integration)
- Return datetime in ISO 8601 format (`2026-03-22T09:00:00Z`)
- Return monetary amounts as integer values in smallest units (e.g., $1.00 → `100` cents)
- Distinction between `null` and undefined: `null` means "value does not exist", field omission means "no information"

### 32.2. Content Negotiation

- Switch response format based on `Accept` header (JSON, XML, Protocol Buffers, etc.)
- Default is `application/json`

---

## Part XXXIII: Server Action Design

### 33.1. Graceful Return Protocol

- **Rule 35.52**: Propagating errors via `throw` in Server Actions (`'use server'` functions) to clients is prohibited in principle. Return all errors as structured responses

```typescript
// ✅ Correct: Structured response
type ActionResponse<T> =
  | { success: true; data: T }
  | { success: false; error: string; code?: string };

async function createStore(input: CreateStoreInput): Promise<ActionResponse<Store>> {
  try {
    const store = await db.stores.create({ data: input });
    return { success: true, data: store };
  } catch (error) {
    logger.error('Failed to create store', { error });
    return { success: false, error: 'Store creation failed', code: 'CREATION_FAILED' };
  }
}
```

### 33.2. Strict Action Return Type Protocol

- **Rule 35.53**: Mandate strict type definitions for Server Action return values. Permanently prohibit `as any` casts on the UI side
- Prohibit `void` or `any` as return value types
- Do not include `Date`, `Map`, `Set`, class instances as they must cross serialization boundaries

### 33.3. Typed Error Codes

- Include machine-readable `code` in error responses

| Code | Description | UI Action |
|:---|:---|:---|
| `VALIDATION_ERROR` | Input validation failure | Display form errors |
| `PERMISSION_DENIED` | Insufficient permissions | Permission error message |
| `NOT_FOUND` | Resource not found | Navigate to 404 page |
| `CONFLICT` | Data conflict | Prompt reload |
| `RATE_LIMITED` | Rate limit exceeded | Retry guidance |

### 33.4. Logging Obligation

- **Rule 35.54**: Always log on the server side before returning an error as a return value. Error handling via return values loses observability if logging is neglected

---

## Part XXXIV: Caching Strategy

### 34.1. HTTP Caching

- **Rule 35.55**: Set appropriate cache headers on all API responses

| Header | Purpose | Example |
|:---|:---|:---|
| **Cache-Control** | Cache behavior control | `max-age=300, stale-while-revalidate=60` |
| **ETag** | Content hash for conditional requests | `"v1-abc123"` |
| **Last-Modified** | Last update timestamp | `Sun, 22 Mar 2026 09:00:00 GMT` |
| **Vary** | Cache key differentiation | `Accept, Authorization` |

### 34.2. Stale-While-Revalidate

- Immediately return expired cache while revalidating in the background
- Optimize the balance between user experience (latency) and data freshness

### 34.3. Cache Hierarchy

| Layer | Target | TTL |
|:---|:---|:---|
| **CDN** | Static assets, public APIs | 1 hour to 1 day |
| **API Gateway** | Response cache | 5 minutes to 1 hour |
| **Application** | DB results, computed results | 1 minute to 30 minutes |
| **Client** | Local cache | SWR strategy |

### 34.4. Semantic Caching

- Implement vector similarity-based caching for semantically similar requests such as AI responses
- Effective for cost reduction and latency improvement

---

## Part XXXV: Payload Optimization

### 35.1. Compression

- **Rule 35.56**: Compress responses with `Content-Encoding: gzip` or `br` (Brotli)
- Do not compress responses under 1KB as compression overhead exceeds savings

### 35.2. Pagination

- Use Cursor-Based Pagination as defined in Part V as the standard
- Set default and maximum page sizes (recommended: default=20, max=100)

### 35.3. Field Selection

- Enable clients to specify only needed fields (`?fields=id,name,address`)
- Effective for bandwidth reduction and mobile performance improvement

### 35.4. Batch API

- Enable multiple resource retrievals in a single request
- Bundle multiple operations via `POST /api/v1/batch` endpoint
- Reduce per-request overhead (connection establishment, auth verification, etc.)

---

## Part XXXVI: Scalability Design

### 36.1. Stateless Gateway Protocol

- **Rule 35.57**: Design API Gateways and backend services as stateless. Prohibit sticky sessions and enable horizontal scaling
- Hold session state in external stores (Redis, etc.)

### 36.2. Cell-Based Architecture

- Divide infrastructure into independent cells to limit failure blast radius
- Each cell can be independently scaled and deployed

### 36.3. Horizontal Scaling Guidelines

- Stateless services scale by adding Pods/instances
- Stateful services (DB, etc.) scale via Read Replicas and sharding
- Auto-Scaling: Set scaling rules based on CPU usage, request rate, and queue depth

---

## Part XXXVII: API Observability

### 37.1. OpenTelemetry Instrumentation

- **Rule 35.58**: Mandate OpenTelemetry (OTel) instrumentation for all API services. Avoid vendor lock-in and build a unified observability foundation

### 37.2. Distributed Tracing

- Assign a unique `trace_id` to all requests, enabling flow tracking across the entire service chain
- Propagate `W3C Trace Context` headers (`traceparent`)

### 37.3. API Metrics (Golden Signals)

| Metric | Description | Alert Threshold |
|:---|:---|:---|
| **Latency** | Request processing time | p99 > 500ms |
| **Traffic** | Request rate | Abnormal fluctuations |
| **Errors** | Error rate | > 1% |
| **Saturation** | Resource utilization | > 80% |

### 37.4. Custom Metrics

- Collect business metrics (API calls per customer, per-endpoint usage, etc.) for FinOps and API Product analysis

---

## Part XXXVIII: API Audit Logging

### 38.1. Outbound Audit Mandate

- **Rule 35.59**: Record all external API calls (Stripe, OpenAI, Maps API, etc.) as structured logs

```typescript
logger.info('External API call', {
  direction: 'outbound',
  service: 'stripe',
  method: 'POST',
  endpoint: '/v1/payment_intents',
  status: 200,
  duration_ms: 342,
  request_id: 'req_abc123',
  trace_id: 'trace_def456',
});
```

### 38.2. AI Inference Logging

- Record AI API call model name, token consumption, cost, and response time
- Used as input for FinOps optimization and model selection decisions

### 38.3. Sensitive Data Masking

- Automatically mask PII (email addresses, phone numbers, etc.) in logs
- Never output full API keys or tokens in logs (first 4 characters + mask)

---

## Part XXXIX: API Health Check & Status

### 39.1. Health Check Endpoints

| Endpoint | Purpose | Verification |
|:---|:---|:---|
| **GET /health** | Liveness Check | Process survival confirmation |
| **GET /ready** | Readiness Check | Dependency service (DB, Redis, etc.) connection check |
| **GET /status** | Detailed Status | Version, build info, dependency service states |

### 39.2. Health Check Design

- `/health` requires no authentication and always responds quickly (<100ms)
- `/ready` includes dependency service health checks, returns `200` only when all dependencies are healthy
- Integrate with Kubernetes Liveness/Readiness Probes

---

## Part XL: API Public Documentation Standards

### 40.1. Live Documentation

- **Rule 35.60**: API documentation must be auto-generated from code and maintained in an always-current state. Standalone hand-written documentation is prohibited
- Generate Swagger UI/Redoc automatically from OpenAPI specs for REST
- Enable interactive exploration via GraphiQL/Apollo Studio for GraphQL

### 40.2. Required Documentation Elements

| Element | Description |
|:---|:---|
| **Endpoint List** | URLs, methods, parameters |
| **Request/Response Examples** | Samples close to real data |
| **Error Response Examples** | Samples for each status code |
| **Authentication Methods** | Bearer Token, API Key acquisition and usage |
| **Rate Limit Information** | Per-tier limits |
| **Sandbox Environment** | Test endpoints |
| **Multi-Language Code Examples** | cURL, JavaScript, Python, Go, etc. |
| **Changelog** | Version-specific change history |

### 40.3. Bilingual Support

- API documentation is primarily created in English, with Japanese version provided as needed

---

## Part XLI: Developer Experience (DX)

### 41.1. Developer Portal

- Provide a portal site for API consumers
- Enable self-service registration, API key issuance, usage monitoring, and billing management

### 41.2. SDK Auto-Generation

- **Rule 35.61**: Auto-generate client SDKs for TypeScript, Python, Go, Swift, Kotlin from OpenAPI specifications
- Use `openapi-generator-cli` or `openapi-typescript`

### 41.3. Onboarding Optimization

- Set DX goal as "succeed in first API call within 5 minutes"
- Enrich Quick Start guides, Sandbox environments, and sample code

### 41.4. Changelog Management

- Record change history for all versions in Changelog
- Clearly classify Breaking Changes, new feature additions, and bug fixes

---

## Part XLII: API Contract Testing

### 42.1. Consumer-Driven Contract Testing (CDC)

- **Rule 35.62**: Automatically verify in CI pipeline that API changes do not break consumers
- Use CDC frameworks like Pact to automatically test Provider-Consumer contracts

### 42.2. Schema-Driven Testing

- Automatically execute response conformance tests against OpenAPI specifications
- Fail CI when responses diverge from specifications

### 42.3. Breaking Change CI Gate

- **Rule 35.63**: Install OpenAPI diff comparison (`oasdiff`, etc.) as a CI Gate to auto-block PRs containing Breaking Changes
- Breaking Changes can only be merged after review and approval

---

## Part XLIII: API Product Mindset

### 43.1. API as Asset

- **Rule 35.64**: Manage APIs as "salable products," not just technical endpoints
- Track user count, usage frequency, revenue, and satisfaction as KPIs

### 43.2. Tiered Access

| Tier | Target | Usage Scope |
|:---|:---|:---|
| **Free** | Evaluation/development | Strict rate limits, feature restrictions |
| **Pro** | Small-scale production | Relaxed rate limits |
| **Enterprise** | Large-scale services | Custom rate limits, with SLA |
| **Native App (VIP)** | Own apps | Enterprise equivalent (no charge) |

### 43.3. Data Monetization Privacy

- **Rule 35.65**: Implement anonymization interfaces for data provided via API, balancing privacy and data monetization

---

## Part XLIV: API Gateway Usage Metering

### 44.1. Metering Log

- **Rule 35.66**: Asynchronously record usage logs for all requests at the API Gateway layer
- Logs include API Key, endpoint, timestamp, response size, and latency

### 44.2. Asynchronous Recording

- Do not add usage recording latency to the main request processing path
- Process asynchronously via background processes or message queues

### 44.3. Aggregation & Visualization

- Execute daily/monthly usage aggregation for billing and FinOps analysis
- Visualize usage trends via dashboards

---

## Part XLV: API FinOps

### 45.1. Cost Attribution

- **Rule 35.67**: Attribute API call costs per service, team, and customer
- Leverage OpenTelemetry metadata (`tier`, `customer_id`) for cost attribution

### 45.2. External API Budget Management

- Set per-service monthly budget caps for external APIs (OpenAI, Stripe, Maps, etc.)
- Alert at 80% budget consumption, auto-throttle at 100%

### 45.3. Cost Optimization

- Identify and consolidate low-usage endpoints
- Reduce external API calls through enhanced caching
- Reduce transfer costs through response payload optimization

---

## Part XLVI: Microservices Design Principles

### 46.1. Bounded Context

- **Rule 35.68**: Microservice boundaries must align with DDD (Domain-Driven Design) Bounded Contexts
- Directly sharing databases between services is a "serious offense" (Database-per-Service principle)

### 46.2. Decomposition Strategy

| Strategy | Description | Application |
|:---|:---|:---|
| **By Business Capability** | Split by business function | When clear business domains exist |
| **By Subdomain** | Split by DDD subdomain | For complex domain models |
| **Strangler Fig** | Gradual migration from legacy | Migrating from monolith |

### 46.3. Service Size Guidelines

- Standard: "Size that one team can own and operate" (Two-Pizza Team rule)
- If services are too large, review Bounded Contexts; if too small, consider consolidation

### 46.4. Inter-Service API Design

- Recommend gRPC for internal APIs (performance and type safety)
- Recommend REST for public APIs (versatility and tool ecosystem)
- Apply Contract Testing (Part XLII) to internal APIs as well

---

## Part XLVII: Inter-Service Communication Patterns

### 47.1. Synchronous vs Asynchronous

| Pattern | Characteristics | Use Case |
|:---|:---|:---|
| **Synchronous (Request-Response)** | Immediate response, strong consistency | Queries, real-time requirements |
| **Asynchronous (Event-Driven)** | Loose coupling, high resilience | Commands, background processing |

- **Rule 35.69**: Default to asynchronous communication. Limit synchronous communication to queries requiring real-time responses

### 47.2. Choreography vs Orchestration

| Method | Characteristics | Recommended Case |
|:---|:---|:---|
| **Choreography** | Each service independently publishes/subscribes events | Simple flows (2-3 steps) |
| **Orchestration** | Central orchestrator controls flow | Complex flows (4+ steps) |

### 47.3. Data Mesh Integration

- Each microservice exposes APIs as "data products"
- Data ownership belongs to domain teams; central data team focuses on platform provision

---

## Part XLVIII: Distributed Data Management

### 48.1. Saga Pattern Details

- Detailed implementation guide for the Saga pattern outlined in Part XV
- Pre-define compensating transactions for each step
- Persist Saga state to guarantee recovery on failure

### 48.2. Outbox Pattern Details

- **Rule 35.70**: Guarantee atomicity of local DB transactions and event publishing
- Write events to `outbox` table, forward to event broker via CDC tools like Debezium

```sql
-- Outbox Table
CREATE TABLE outbox (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  aggregate_type VARCHAR(255) NOT NULL,
  aggregate_id VARCHAR(255) NOT NULL,
  event_type VARCHAR(255) NOT NULL,
  payload JSONB NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now(),
  published_at TIMESTAMPTZ
);
```

### 48.3. Change Data Capture (CDC)

- Convert DB changes to real-time event streams using CDC tools like Debezium
- Combined with Outbox Pattern to realize event-driven architecture

### 48.4. Eventual Consistency

- **Rule 35.71**: Assume eventual consistency for data consistency between microservices, guaranteeing consistency via compensating transactions
- When strong consistency is required, complete processing within the same service

---

## Part XLIX: Advanced Write Protocols

### 49.1. Secure Write Action Protocol

- **Rule 35.72**: Mandate OTP + Turnstile Token (bot verification) dual authentication for the following critical operations:
  - Password change
  - Email address change
  - Account deletion
  - Payment information change
  - Admin privilege changes

### 49.2. Hybrid Sync Prohibition

- **Rule 35.73**: Prohibit dual management between DB and third-party services (e.g., Stripe Customer)
- Designate one as the Source of Truth, reference the other via API

### 49.3. Optimistic Locking

- Use `version` column or `updated_at` to detect and prevent concurrent update conflicts
- Return `409 Conflict` on conflict, prompting client to re-fetch and re-submit

---

## Part L: AI-Integrated API Design

### 50.1. MCP / A2A Support

- **Rule 35.74**: Attach metadata (`x-ai-description`, `x-ai-examples`) to OpenAPI specs so AI agents can discover and invoke APIs
- Provide MCP (Model Context Protocol) compatible tool definitions
- Consider API design for A2A (Agent-to-Agent) communication

### 50.2. LLM Function Calling Support

- Auto-generate LLM Function Calling schemas from OpenAPI specifications
- Attach clear `description` to each parameter to improve AI inference accuracy

### 50.3. Metadata Strategy

- Include following metadata in API responses to provide judgment material for AI agents

| Metadata | Description |
|:---|:---|
| `tier` | Access layer (Free/Pro/Enterprise) |
| `usage` | Usage metering method (metered/unlimited) |
| `revalidation_ttl` | Data freshness (seconds) |
| `confidence` | Data confidence level (for AI-generated data) |

### 50.4. AI Gateway

- Design an AI Gateway to aggregate calls to AI APIs (OpenAI, Anthropic, Google AI, etc.)
- Centrally manage rate limiting, cost management, fallback (model switching), and audit logs

---

## Part LI: API Lifecycle Management

### 51.1. Lifecycle Phases

| Phase | Description | Deliverable |
|:---|:---|:---|
| **Design** | API spec design and review | OpenAPI specification |
| **Develop** | Implementation and unit testing | Code, tests |
| **Test** | Integration testing, contract testing | Test results |
| **Deploy** | Staging → production deployment | Deployment |
| **Monitor** | Observability, SLO monitoring | Dashboards |
| **Deprecate** | Deprecation, migration guidance | Sunset notice |
| **Retire** | Endpoint retirement | Retirement notice |

### 51.2. API Catalog

- **Rule 35.75**: Register all APIs in a catalog, centrally managing endpoints, owning teams, status, and versions
- Mandate periodic detection and registration of Shadow APIs (unregistered APIs)

---

## Part LII: Microservices Operations

### 52.1. Deployment Strategies

| Strategy | Description | Risk |
|:---|:---|:---|
| **Blue-Green** | Switch between old and new environments | Low risk, high cost |
| **Canary** | Gradually migrate traffic | Low risk, incremental |
| **Rolling** | Sequentially update instances | Medium risk |
| **Feature Flag** | Code-level feature toggle | Lowest risk |

### 52.2. Progressive Delivery

- **Rule 35.76**: Mandate Progressive Delivery for new API version rollout: Canary → gradual expansion → full cutover
- Monitor SLIs at each stage, auto-rollback on threshold violations

### 52.3. Independent Service Deployment

- **Rule 35.77**: Each microservice must be independently deployable without dependency on other services
- Eliminate deployment order dependencies

---

## Part LIII: Regulatory Compliance

### 53.1. EU Data Act

- Comply with EU Data Act requirements (data portability, fair data sharing) for API-based data access

### 53.2. PCI DSS

- Mandate PCI DSS compliance for payment-related APIs
- Prohibit direct handling of card numbers; use tokenization (Stripe Tokens, etc.)

### 53.3. Cross-Border Data Transfer

- Comply with data residency requirements (GDPR, Japan's Act on Protection of Personal Information, etc.) for API data transfers
- Clearly state data storage/processing locations, implement appropriate safeguards for cross-border transfers

### 53.4. API Boundary

- **Rule 35.78**: Isolate APIs handling regulated data in dedicated API Boundaries with enhanced audit logging and access controls

---

## Part LIV: Maturity Model (5 Levels)

### 54.1. API Maturity Model

| Level | Name | Characteristics |
|:---|:---|:---|
| **L1** | Ad-hoc | No rules. Each team designs APIs independently |
| **L2** | Defined | API design guidelines exist. Partial automation |
| **L3** | Managed | OpenAPI mandatory. CI/CD integration. Contract Testing begins |
| **L4** | Optimized | API productization. FinOps integration. SLO-driven |
| **L5** | Strategic | API economy established. AI integration. Data monetization |

### 54.2. Phased Adoption Roadmap

- **Phase 1 (L1→L2)**: API Style Guide creation, OpenAPI adoption
- **Phase 2 (L2→L3)**: CI/CD integration, Contract Testing, auto-documentation generation
- **Phase 3 (L3→L4)**: API Catalog, FinOps integration, SLO/Error Budget operation
- **Phase 4 (L4→L5)**: API monetization, AI integration (MCP/A2A), Data Monetization

---

## Part LV: Anti-Pattern Collection (25 Items)

### 55.1. Design Anti-Patterns

| # | Anti-Pattern | Correct Approach |
|:---|:---|:---|
| 1 | **God API**: All functionality in one endpoint | Split by resource-oriented design |
| 2 | **Chatty API**: Requires many small requests | Aggregate with BFF/GraphQL |
| 3 | **Hand-written Types**: No auto-generation from OpenAPI/Protobuf | Mandate schema-based auto-generation |
| 4 | **Versioning Hell**: Excessive version proliferation | Evolve via additive changes |
| 5 | **RPC-style URLs**: `/getUsers`, `/createOrder` | Resource nouns + HTTP methods |

### 55.2. Security Anti-Patterns

| # | Anti-Pattern | Correct Approach |
|:---|:---|:---|
| 6 | **Plaintext API Key Storage** | SHA-256 hashing |
| 7 | **CORS `*` in Production** | Explicit origin whitelist |
| 8 | **Using Implicit Grant** | OAuth 2.1 + PKCE |
| 9 | **Skipping Input Validation** | Schema Validation on all endpoints |
| 10 | **Leaking Internal Error Messages** | RFC 7807 semantic errors |

### 55.3. Reliability Anti-Patterns

| # | Anti-Pattern | Correct Approach |
|:---|:---|:---|
| 11 | **No Timeouts** | Mandatory timeouts for all external calls |
| 12 | **No Retry on External Calls** | Exponential backoff + jitter |
| 13 | **No Circuit Breaker** | Circuit breaker on all external dependencies |
| 14 | **No Idempotency on Payment API** | Mandatory Idempotency-Key |
| 15 | **Thundering Herd** | Jittered retry + caching |

### 55.4. Operations Anti-Patterns

| # | Anti-Pattern | Correct Approach |
|:---|:---|:---|
| 16 | **DB-Sharing Microservices** | Database-per-Service |
| 17 | **Unlogged External API Calls** | Outbound Audit Mandate |
| 18 | **Hand-Written Documentation Only** | Auto-generation from OpenAPI |
| 19 | **No Health Check** | `/health` + `/ready` mandatory |
| 20 | **Raw Row Direct Return** | DTO obligation |

### 55.5. AI & Agentic Anti-Patterns

| # | Anti-Pattern | Correct Approach |
|:---|:---|:---|
| 21 | **Unlimited API access for AI agents** | Agent-specific scopes and rate limits |
| 22 | **AI integration without MCP Tool definitions** | Auto-generate MCP Tools from OpenAPI |
| 23 | **HTTP/2 only, no HTTP/3 support** | Phased adoption of QUIC/HTTP/3 |
| 24 | **No SBOM for API dependencies** | Mandate SBOM management for API Supply Chain |
| 25 | **All traffic through a single Gateway** | K8s Gateway API & Multi-Gateway strategy |

---

## Part LVI: Agentic API Design (MCP/A2A/ACP)

### 56.1. Agentic API Philosophy

- **Rule 35.81**: Design APIs for "AI agents" as first-class consumers alongside "human developers"
- Mandate "Machine-Readable APIs" that AI agents can autonomously discover, understand, and invoke
- Standardize Agent Cards (agent capability declarations) and Tool Descriptions

### 56.2. MCP (Model Context Protocol) Integration

- **Rule 35.82**: Build pipelines to auto-generate MCP Tool definitions from OpenAPI specifications

```typescript
// OpenAPI → MCP Tool conversion example
const mcpTool = {
  name: 'get_store',
  description: 'Retrieve store details by ID. Returns store name, address, and operating hours.',
  inputSchema: {
    type: 'object',
    properties: {
      store_id: { type: 'string', description: 'Unique store identifier (e.g., store_001)' }
    },
    required: ['store_id']
  }
};
```

- Attach clear `description` and `examples` to each parameter (directly improves AI inference accuracy)
- MCP Server security: scope-restricted auth tokens, mandatory audit logs for tool executions

### 56.3. A2A (Agent-to-Agent) Protocol

- **Rule 35.83**: Multi-agent systems must comply with the A2A protocol (managed by Linux Foundation)
- A2A operates over HTTP and uses OpenAPI authentication schemes
- Declare agent capabilities via Agent Card (`/.well-known/agent.json`)

| A2A Feature | Description |
|:---|:---|
| **Agent Discovery** | Discover agent capabilities via Agent Card |
| **Task Delegation** | Delegate tasks and receive results |
| **Status Streaming** | Task progress streaming via SSE/WebSocket |
| **Artifact Exchange** | File and data exchange between agents |

### 56.4. AI Gateway

- **Rule 35.84**: Route all AI API access through an AI Gateway for centralized cost management, rate limiting, fallback, and auditing
- Model Router: automatic model selection based on latency, cost, and accuracy
- Token consumption budget management: monthly budget caps per service, team, and customer

### 56.5. Agentic API Auditing and Governance

- Record audit logs for all AI agent API calls including `agent_id`, `session_id`, and `tool_name`
- Implement anomaly detection for "unintended bulk operations" and "privilege escalation"
- Kill Switch: implement mechanisms to immediately block API calls when AI agents go rogue

---

## Part LVII: HTTP/3 & QUIC Migration

### 57.1. HTTP/3 Mandate Roadmap

- **Rule 35.85**: Mandate HTTP/3 (QUIC) support for new API services. Migrate existing services incrementally
- As of March 2026, HTTP/3 global adoption is 35% (Cloudflare data). All major browsers natively support it

### 57.2. HTTP/3 Benefits

| Benefit | Description |
|:---|:---|
| **HOL Blocking Elimination** | Per-stream loss recovery. Eliminates TCP-inherent HOL Blocking |
| **0-RTT Connection** | Eliminate reconnection latency |
| **Built-in TLS 1.3** | Protocol-level encryption mandate |
| **Multipath (Experimental)** | Simultaneous use of multiple network paths |

### 57.3. gRPC over QUIC

- Migrate gRPC from HTTP/2 dependency to HTTP/3 for further performance improvement
- QUIC's UDP base improves connection persistence during mobile network transitions

### 57.4. Migration Strategy

- **Phase 1**: Enable HTTP/3 at CDN/Edge layer (negotiation via ALTSVC header)
- **Phase 2**: Enable HTTP/3 at API Gateway layer
- **Phase 3**: Migrate inter-service communication to HTTP/3
- Maintain backward compatibility with HTTP/2, negotiating protocols based on client capabilities

---

## Part LVIII: WebTransport Design

### 58.1. WebTransport Overview

- **Rule 35.86**: Consider WebTransport adoption for new real-time bidirectional communication (successor to WebSocket)
- Operates on HTTP/3 (QUIC), combining stream multiplexing and datagram transmission

### 58.2. WebTransport vs WebSocket

| Aspect | WebSocket | WebTransport |
|:---|:---|:---|
| **Protocol** | Frame protocol over TCP | Over QUIC/HTTP/3 |
| **HOL Blocking** | Yes (TCP-derived) | No (QUIC-derived) |
| **Multiplexing** | Single stream | Multiple streams + datagrams |
| **Encryption** | Optional (wss recommended) | TLS 1.3 mandatory |
| **Browser Support** | All browsers | Chrome/Edge/Firefox (Safari experimental) |

### 58.3. Use Cases

- Gaming and real-time collaboration (low-latency datagrams)
- Media streaming (out-of-order data delivery)
- IoT device communication (efficient management of massive connections)

---

## Part LIX: API Supply Chain Security

### 59.1. SBOM for API Dependencies

- **Rule 35.87**: Manage an inventory of external APIs your APIs depend on (Stripe, OpenAI, Maps, etc.) and include them in the SBOM (Software Bill of Materials)
- Document each external API's failure impact scope, SLO, and contract terms

### 59.2. Third-Party API Risk Management

| Risk | Countermeasure |
|:---|:---|
| **API Key Leakage** | Vault management, automated rotation |
| **Breaking Change** | Contract Testing, Changelog monitoring |
| **Service Outage** | Circuit breaker, fallback |
| **Pricing Change** | FinOps budget alerts |
| **Security Vulnerability** | Periodic security assessments |

### 59.3. External API Security Assessment

- **Rule 35.88**: Conduct security assessment checklists before integrating new external APIs
- Evaluate SOC2/ISO 27001 certifications, data processing locations, encryption policies, and incident notification procedures

### 59.4. API Dependency Firewall

- Do not trust responses from third-party APIs. Perform response schema validation similar to input validation
- Implement detection and isolation mechanisms for malformed responses

---

## Part LX: Kubernetes Gateway API

### 60.1. Ingress → Gateway API Migration

- **Rule 35.89**: Adopt k8s Gateway API as the standard for new Kubernetes clusters. Plan gradual migration from legacy Ingress API
- Gateway API, as Ingress's successor, provides more expressive routing and traffic management

### 60.2. Gateway API Resource Model

| Resource | Description |
|:---|:---|
| **GatewayClass** | Gateway implementation provider definition |
| **Gateway** | Listener (port/protocol) definition |
| **HTTPRoute** | HTTP routing rules |
| **GRPCRoute** | gRPC routing rules |
| **TLSRoute** | TLS passthrough routing |

### 60.3. Traffic Splitting

```yaml
# Canary release with Gateway API
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: store-api-canary
spec:
  parentRefs:
    - name: api-gateway
  rules:
    - backendRefs:
        - name: store-api-v1
          port: 8080
          weight: 90
        - name: store-api-v2
          port: 8080
          weight: 10
```

---

## Part LXI: AI-Driven API Testing

### 61.1. AI-Assisted Test Generation

- **Rule 35.90**: Build pipelines to auto-generate test cases from OpenAPI specifications using AI
- Auto-generate happy path, error path, edge case, and security tests
- AI infers and proposes properties for Property-Based Testing

### 61.2. Automated Fuzz Testing

- **Schemathesis**: Auto-generate and execute fuzz tests from OpenAPI/GraphQL specifications
- Discover edge cases and crashing inputs not documented in specifications

```bash
# Automated fuzzing with Schemathesis
schemathesis run https://api.example.com/openapi.json \
  --checks all \
  --hypothesis-max-examples 1000
```

### 61.3. AI-Driven Contract Drift Detection

- Auto-detect divergence (Contract Drift) between production traffic and OpenAPI specifications using AI
- Alert when undefined fields or status codes are returned that aren't in the specification

---

## Part LXII: API Governance Deep Dive

### 62.1. API Design Linting Automation

- **Rule 35.91**: Mandate OpenAPI spec linting in CI pipelines. Use Spectral/Optic as default tools

```yaml
# Spectral ruleset example
rules:
  operation-operationId: error
  operation-description: warn
  oas3-valid-media-example: error
  path-params: error
  no-eval-in-markdown: error
  typed-enum: warn
  # Custom rules
  api-version-in-path:
    severity: error
    given: "$.paths.*~"
    then:
      function: pattern
      functionOptions:
        match: "^/api/v[0-9]+/"
```

### 62.2. API Scoring

| Score Item | Weight | Evaluation Criteria |
|:---|:---|:---|
| **Spec Completeness** | 25% | description & examples on all endpoints |
| **Security** | 30% | Auth definitions, scopes, rate limits |
| **Consistency** | 20% | Naming conventions, response structure uniformity |
| **Documentation** | 15% | Changelog, error specs, samples |
| **Testing** | 10% | Contract Test, Breaking Change Gate |

### 62.3. API Review Board Operations

- **Rule 35.92**: Mandate API Review Board design review approval for Breaking Changes or new API publications
- Review criteria: security, naming conventions, versioning, SLO definition, documentation quality

---

## Part LXIII: GraphQL 2025+ Extensions

### 63.1. Nullability RFC

- **Rule 35.93**: Enforce strict Null/Non-Null design in GraphQL schemas
- Input types default to Non-Null; output types permit Nullable considering network failures
- Consider adopting the `@semanticNonNull` directive

### 63.2. @oneOf Input Validation

- Implement union validation (exclusive choice) for input types using GraphQL `@oneOf`
- Type-safe design for cases where only one of multiple input patterns is valid

### 63.3. Composite Schema

- Comply with the Composite Schema specification for integrating multiple GraphQL Subgraphs
- Track latest developments in Apollo Federation v2 / Composite Schema Spec

### 63.4. GraphQL over HTTP Specification

- **Rule 35.94**: GraphQL HTTP transport must comply with the "GraphQL over HTTP" specification
- Appropriate use of `GET` (Persisted Query) and `POST`
- Use `Accept: application/graphql-response+json` header

---

## Part LXIV: gRPC 2025+ Extensions

### 64.1. xDS API Integration

- Leverage Service Mesh (Envoy/Istio) xDS APIs to manage dynamic configuration (routing, load balancing, authentication) for gRPC services
- Achieve traffic management without application code changes through policy distribution from the control plane

### 64.2. gRPC-Web Improvements

- **Rule 35.95**: Use gRPC-Web for browser-based gRPC calls. Recommend Envoy proxy for protocol translation
- Validate and optimize gRPC-Web operation over HTTP/3

### 64.3. Connect Protocol

- Consider adopting Connect Protocol (HTTP/1.1-compatible gRPC) as a gRPC alternative
- Effective when prioritizing direct browser calls, debuggability, and cURL testability

### 64.4. gRPC Load Balancing

| Method | Description | Recommended Case |
|:---|:---|:---|
| **Proxy-based** | Distribution via L7 proxy (Envoy, etc.) | Generally recommended |
| **Client-side** | Client directly selects backend | Low latency requirements |
| **Look-aside** | External load balancer provides load information | Large-scale clusters |

---

## Part LXV: API Evolution Strategy

### 65.1. Stripe-Style Versioning

- **Rule 35.96**: Following Stripe's approach, include an `API-Version` header in each API request to provide version-specific responses per client
- Maintain conversion logic for all versions server-side, enabling gradual migration at the client's pace

### 65.2. API Changelog Automation

- Integrate OpenAPI diff detection (`oasdiff`) into CI to auto-generate Changelogs
- Auto-classify as Breaking/Non-Breaking/Deprecation

### 65.3. Consumer-Aware Deprecation

- **Rule 35.97**: Track deprecated API consumers by ASN/API key and provide individual migration guidance
- Strictly adhere to the principle of not retiring until consumer count reaches zero

---

## Part LXVI: Multi-Cloud API Management

### 66.1. Unified Control Plane

- **Rule 35.98**: In multi-cloud environments, deploy a unified API management control plane to enforce consistent policies (authentication, rate limiting, observability) across clouds
- Version-manage configurations via GitOps to prevent drift

### 66.2. Cross-Cloud API Consistency

| Item | Requirement |
|:---|:---|
| **Authentication** | Identical auth infrastructure across all clouds (OAuth 2.1) |
| **Rate Limiting** | Distributed rate limiting (global counters) |
| **Observability** | Cross-cloud tracing via OpenTelemetry |
| **Documentation** | Unified Developer Portal |

### 66.3. Data Residency Compliance

- Determine request origin region at the API Gateway layer and route to appropriate backends based on data residency requirements
- Physically guarantee that GDPR region (EU) data does not leave the EU

---

## Part LXVII: Edge-Native API

### 67.1. API Execution on Edge Computing

- **Rule 35.99**: Execute APIs with strict latency requirements on Edge Workers/Edge Functions
- Leverage Cloudflare Workers, Deno Deploy, Vercel Edge Functions, etc.

### 67.2. Edge API Design Principles

| Principle | Description |
|:---|:---|
| **Stateless** | No local state in Edge Workers |
| **Cache-First** | Data localization via Edge KV and R2 |
| **Fallback** | Origin fallback design for Edge downtime |
| **Size Constraints** | Bundle size minimization (V8 Isolate constraints) |

### 67.3. Edge API Gateway

- Implement JWT validation, rate limiting, and GeoIP routing at the Edge to eliminate unnecessary requests to Origin
- Mandate mTLS for Edge→Origin communication

---

## Part LXVIII: API Marketplace & Ecosystem

### 68.1. API Marketplace Construction

- **Rule 35.100**: When pursuing API monetization, design an API Marketplace centered on the Developer Portal
- Provide self-service flows for API search, trial, contracting, and billing

### 68.2. Partner Ecosystem

| Tier | Description | Requirements |
|:---|:---|:---|
| **Public** | Anyone can access | API Key + Free Tier |
| **Partner** | Vetted partners | Contract + Dedicated Support |
| **Enterprise** | Large-scale customers | Custom SLA + Dedicated Instance |

### 68.3. Stripe Metering Integration

- Implement Usage-Based Billing based on API call counts via Stripe Metering
- Design free quotas, overage charges, and volume discounts per tier

---

## Part LXIX: Green API / Sustainability

### 69.1. API Carbon Footprint

- **Rule 35.101**: Measure and visualize the carbon footprint of API calls
- Track SCI (Software Carbon Intensity) scores
- Consider adding `X-Carbon-Intensity: low/medium/high` response header

### 69.2. Efficient API Design

| Measure | Effect |
|:---|:---|
| **Payload Optimization** | Reduced transfer volume → lower network energy |
| **Cache Maximization** | Fewer unnecessary Origin requests → lower server power |
| **Batch API** | Fewer requests → fewer round trips |
| **Edge Execution** | Shorter data travel distance → lower network energy |
| **HTTP/3** | Reduced handshakes → lower connection establishment energy |

### 69.3. Green SLA

- Add carbon efficiency metrics to SLO targets (e.g., CO2 emissions per 10,000 API calls)
- Consider priority traffic routing to low-carbon regions

---

## Part LXX: Future Outlook

### 70.1. Technology Trend Roadmap

| Timeframe | Technology | Impact on APIs |
|:---|:---|:---|
| **2025-2026** | HTTP/3 adoption, MCP/A2A standardization | AI Agent-ready API design becomes mandatory |
| **2026-2027** | OpenAPI 4.0 (Moonwalk) | Expanded spec expressiveness, AI-driven spec generation |
| **2027-2028** | Quantum-Safe cryptography | Migration to TLS 1.3 + PQC (Post-Quantum Cryptography) |
| **2028+** | Autonomous API Management | Full automation of AI-driven API design, testing, and deployment |

### 70.2. WebAssembly (Wasm) API

- Portable computing environments through API logic execution on Wasm
- Multi-language support for serverless APIs leveraging WASI (WebAssembly System Interface)

### 70.3. Digital Twin API

- API access to digital twins of physical systems
- Standardization of bidirectional communication protocols with IoT devices

### 70.4. Autonomous API Lifecycle

- Fully automated pipeline of AI/ML-driven API design proposals → auto-testing → Progressive Delivery → SLO monitoring → auto-optimization
- Transition from "Human-in-the-Loop" to "Human-on-the-Loop"

---

## Appendix A: Quick Reference Index

| Keyword | Reference |
|:---|:---|
| A2A Protocol | Part LVI (§56.3) |
| AI Agent Security | Part XXVI (§26.3) |
| AI Gateway | Part LVI (§56.4) |
| AI Testing | Part LXI |
| API-First | Part II (§2.1) |
| API Marketplace | Part LXVIII |
| API Scoring | Part LXII (§62.2) |
| API Supply Chain | Part LIX |
| AsyncAPI | Part XVI (§16.1) |
| Authentication / OAuth 2.1 | Part XXVII (§27.1) |
| Batch API | Part XXXV (§35.4) |
| BFF | Part XX |
| Breaking Change | Part VI (§6.2), Part XLII (§42.3), Part LXV |
| Bulkhead | Part XXI (§21.3) |
| Cache / ETag | Part XXXIV |
| Carbon Footprint | Part LXIX |
| CDC (Change Data Capture) | Part XLVIII (§48.3) |
| Cell-Based Architecture | Part XXXVI (§36.2) |
| Circuit Breaker | Part XXI (§21.1) |
| Connect Protocol | Part LXIV (§64.3) |
| Contract Testing | Part XLII |
| CORS | Part XXX |
| CQRS | Part XV (§15.1) |
| DataLoader | Part XI (§11.2) |
| Deprecation | Part VI (§6.3), Part LXV (§65.3) |
| DPoP | Part XXVII (§27.2) |
| DTO | Part VII (§7.1), Part XXXI |
| Edge-Native API | Part LXVII |
| Error Budget | Part XXIV (§24.3) |
| Event-Driven | Part XV |
| FIDO2 / Passkeys | Part XXVII (§27.3) |
| FinOps | Part XLV |
| Fuzz Testing | Part LXI (§61.2) |
| Gateway | Part XVIII |
| Gateway API (K8s) | Part LX |
| Golden Signals | Part XXXVII (§37.3) |
| Graceful Degradation | Part XXV |
| GraphQL | Part IX–XI, Part LXIII |
| GraphQL over HTTP | Part LXIII (§63.4) |
| Green API | Part LXIX |
| gRPC | Part XII–XIV, Part LXIV |
| gRPC-Web | Part LXIV (§64.2) |
| Health Check | Part XXXIX |
| HTTP/3 / QUIC | Part LVII |
| Idempotency | Part XXII |
| LLM Function Calling | Part L (§50.2) |
| MCP (Model Context Protocol) | Part LVI (§56.2) |
| Metering | Part XLIV |
| Microservices | Part XLVI–XLVIII |
| mTLS | Part XIX (§19.2) |
| Multi-Cloud | Part LXVI |
| OpenAPI | Part II (§2.2), Part XL |
| OpenTelemetry | Part XXXVII (§37.1) |
| Outbox Pattern | Part XV (§15.4), Part XLVIII (§48.2) |
| OWASP API Top 10 | Part XXVI (§26.2) |
| OWASP Top 10:2025 | Part XXVI (§26.2) |
| Pagination | Part V (§5.2) |
| PCI DSS | Part LIII (§53.2) |
| PII Masking | Part VII (§7.3), Part XXXVIII (§38.3) |
| Progressive Delivery | Part LII (§52.2) |
| Protocol Buffers | Part XIV |
| Rate Limiting | Part XXIII |
| RFC 7807 | Part VIII |
| Saga Pattern | Part XV (§15.3), Part XLVIII (§48.1) |
| SBOM (API) | Part LIX (§59.1) |
| Schemathesis | Part LXI (§61.2) |
| Server Action | Part XXXIII |
| Service Mesh | Part XIX |
| SLI / SLO | Part XXIV |
| Spectral | Part LXII (§62.1) |
| SSRF | Part XXIX (§29.4) |
| Stale-While-Revalidate | Part XXXIV (§34.2) |
| Stateless Gateway | Part XXXVI (§36.1) |
| Stripe Versioning | Part LXV (§65.1) |
| Versioning | Part VI |
| Wasm API | Part LXX (§70.2) |
| Webhook | Part XVII |
| WebTransport | Part LVIII |
| xDS API | Part LXIV (§64.1) |
| Zero Trust | Part XXVI (§26.1) |

---

## Appendix B: Cross-References

| Referenced Rule File | Related Topic |
|:---|:---|
| `300_engineering_standards.md` | Coding standards, test strategy |
| `340_web_frontend.md` | Frontend API call patterns |
| `343_native_platforms.md` | Mobile app API integration |
| `320_supabase_architecture.md` | Supabase RPC / Edge Functions / RLS |
| `361_aws_cloud.md` | AWS API Gateway / Lambda / SQS |
| `400_ai_engineering.md` | AI API integration, LLM integration, MCP/A2A patterns |
| `401_data_analytics.md` | API usage analysis, FinOps, OTel integration |
| `500_internal_tools.md` | Admin APIs, internal tools, Agentic Admin |
| `502_site_reliability.md` | SLO/SLI, incident management, observability |
| `600_security_privacy.md` | AuthN/AuthZ, CORS, PII protection, Zero Trust, OWASP |
| `601_data_governance.md` | GDPR, cross-border data, regulatory compliance |
| `602_oss_compliance.md` | SBOM, Supply Chain Security, dependency management |
| `700_qa_testing.md` | Test strategy, Contract Testing, Fuzz Testing |



