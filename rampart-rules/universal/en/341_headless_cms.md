# 34. Content Management System (CMS — Headless)

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-03-24

> [!IMPORTANT]
> **Supreme Directive**
> "Content is data, not display. Structured content independent of delivery channels is the essence of digital assets."
> In CMS implementation, strictly follow the priority order: **Content Structure > Delivery Flexibility > Operational Efficiency > Performance > DX**.
> This document is the supreme standard for all CMS-related design decisions.
> **31 Parts, 80 Sections.**

---

## Table of Contents

- Part I: Supreme Directive & CMS Philosophy
- Part II: Headless Architecture Principles
- Part III: CMS Selection Strategy & Composable DXP
- Part IV: Content Modeling Fundamentals
- Part V: Structured Content Design
- Part VI: Content Types & Field Design
- Part VII: Content Relationships & Reference Design
- Part VIII: Content Delivery API Design
- Part IX: GraphQL API Governance
- Part X: Content Management API & Webhooks
- Part XI: Media Storage Strategy
- Part XII: Image Optimization & Delivery Pipeline
- Part XIII: UGC Media Management & Video Strategy
- Part XIV: DAM (Digital Asset Management) Integration
- Part XV: Rendering Strategy (SSG/ISR/SSR)
- Part XVI: CDN & Edge Delivery
- Part XVII: Cache Tiering Strategy
- Part XVIII: Rich Text Editor Governance
- Part XIX: Triple Write Protocol & Data Integrity
- Part XX: Editor Extensions & NodeView Design
- Part XXI: Publishing Workflow
- Part XXII: Approval Gates & Status Transitions
- Part XXIII: Scheduling & Scheduled Publishing
- Part XXIV: Revision Management & Audit Trail
- Part XXV: Preview Strategy
- Part XXVI: Dual Mode Fetching
- Part XXVII: Soft 404 & HTTP Status Codes
- Part XXVIII: Hybrid Layout Design (Content vs Layout)
- Part XXIX: Dynamic Page Builder & Component Registry
- Part XXX: SEO Automation & Metadata Management
- Part XXXI: Structured Data & Schema.org
- Part XXXII: AI-Ready Content Protocol
- Part XXXIII: AI-Powered Content Operations
- Part XXXIV: AI-Generated Content Governance
- Part XXXV: Agentic CMS & AI Autonomous Content Management
- Part XXXVI: CMS Security Architecture (OWASP 2025)
- Part XXXVII: Content Supply Chain Security
- Part XXXVIII: Content Moderation & Trust & Safety
- Part XXXIX: Content Accessibility (WCAG 2.2/EAA)
- Part XL: Multilingual Content Management & Translation Workflow
- Part XLI: Content Personalization
- Part XLII: Content Governance & Lifecycle Management
- Part XLIII: Content Versioning & Content as Code
- Part XLIV: CMS Migration Strategy & Vendor Switching
- Part XLV: Content Federation & Multi-Source
- Part XLVI: Real-Time Collaboration
- Part XLVII: Content Experimentation & A/B Testing
- Part XLVIII: Server-Driven UI & Remote Config
- Part XLIX: Editor Experience (EX)
- Part L: CMS Testing Strategy
- Part LI: Content Pipeline Automation
- Part LII: Multi-Tenant CMS
- Part LIII: CMS Disaster Recovery & Backup
- Part LIV: CMS Regulatory Compliance (DORA/EU AI Act/DSA)
- Part LV: GEO (Generative Engine Optimization)
- Part LVI: CMS Green IT & Sustainability
- Part LVII: CMS Observability & FinOps
- Part LVIII: Maturity Model (5 Levels)
- Part LIX: Anti-Pattern Collection (35 Items)
- Part LX: Future Outlook & CMS Implementation Checklist
- Part LXI: C2PA Content Provenance & Content Credentials
- Part LXII: AI-Native Visual Editor & No-Code Content Modeling
- Part LXIII: Content Ops & Content Operations Team
- Part LXIV: Headless Commerce Integration
- Part LXV: Edge-Native CMS & Edge Delivery Architecture
- Part LXVI: Content Intelligence & Content Analytics
- Part LXVII: Content Graph & Knowledge Graph
- Part LXVIII: Event-Driven Content Architecture
- Part LXIX: Content Localization Deep Dive (MTPE / MQM)
- Part LXX: Content Design System & Token Management
- Part LXXI: CMS Performance Budget & Core Web Vitals
- Part LXXII: Structured Content Migration & ETL
- Part LXXIII: CMS SDK & Developer Experience (DX)
- Part LXXIV: Headless CMS for Mobile (App Content)
- Part LXXV: Webhook Orchestration & Saga Pattern Deep Dive
- Part LXXVI: Content Compliance Automation (PII/GDPR/DSA)
- Part LXXVII: CMS API Rate Limiting & Quota Management
- Part LXXVIII: CDN Deep Dive (Stale-While-Revalidate / ESI)
- Part LXXIX: CMS Monorepo & Multi-Site Architecture
- Part LXXX: CMS Developer Portal & API Documentation
- Appendix A: Quick Reference Index
- Appendix B: Cross-References

---

## Part I: Supreme Directive & CMS Philosophy

### 1.1. CMS Implementation Supreme Principles

- **Rule 34.1**: Content MUST be managed as "pure data" separated from "display". Mixing display logic into the content layer is prohibited
- **Rule 34.2**: All content MUST be accessible via APIs (API-First Mandate)
- **Rule 34.3**: CMS failures MUST NOT halt the entire frontend (Graceful Degradation mandatory)

### 1.2. CMS Implementation Priority Hierarchy

| Priority | Domain | Description |
|:---|:---|:---|
| **P0** | Content Structure | Semantic modeling, reusability, machine-readability |
| **P1** | Delivery Flexibility | Omnichannel, API-First, AI-Ready |
| **P2** | Operational Efficiency | Approval workflows, preview, scheduling |
| **P3** | Performance | CDN, caching, Core Web Vitals |
| **P4** | DX | Development speed, SDK, type safety |

### 1.3. Content First ≠ CMS First

- **Rule 34.4**: CMS is a "content management tool", NOT an "application framework". Embedding business logic in the CMS is prohibited
- Treat the CMS as one of many data sources; application logic belongs to the frontend/backend

---

## Part II: Headless Architecture Principles

### 2.1. Content as Data

- **Rule 34.5**: All content retrieval MUST be API-based, enabling delivery to any channel including web, mobile apps, IoT devices, and AI agents
- **Physical separation** of frontend and backend is mandatory
- Implementations dependent on CMS template engines or server-side rendering features are prohibited

### 2.2. Architecture Patterns

| Pattern | Description | Recommended Use Case |
|:---|:---|:---|
| **Pure Headless** | API-only CMS + independent frontend | New projects, SPA/SSR |
| **Decoupled** | CMS admin UI + API delivery | Existing CMS migration |
| **Hybrid Headless** | Partial CMS rendering + API delivery | Transitional period only |

- **Rule 34.6**: **Pure Headless** is the standard for new projects. Hybrid Headless is only permitted during migration periods and MUST be consolidated to Pure Headless upon completion

### 2.3. Frontend and CMS Responsibility Boundaries

```
┌─────────────────────────────────────────────┐
│  Headless CMS (Content Backend)             │
│  ├── Content Modeling                       │
│  ├── Content Editing & Management           │
│  ├── Media Asset Management                 │
│  ├── API Endpoint Provision                 │
│  └── Webhook Notifications                  │
├─────────────────────────────────────────────┤
│  Application Layer (Frontend/Backend)       │
│  ├── Rendering (SSG/ISR/SSR)                │
│  ├── Routing                                │
│  ├── Business Logic                         │
│  ├── Authentication & Authorization         │
│  ├── Cache Control                          │
│  └── Performance Optimization               │
└─────────────────────────────────────────────┘
```

---

## Part III: CMS Selection Strategy & Composable DXP

### 3.1. CMS Selection Criteria

| Criteria | Evaluation Items | Weight |
|:---|:---|:---|
| **API Quality** | REST/GraphQL support, rate limits, SDK type safety | Highest |
| **Content Modeling** | Custom types, relations, validation | Highest |
| **Developer Experience** | SDK, CLI, Webhooks, Preview API | High |
| **Scalability** | CDN integration, global delivery, SLA | High |
| **Cost** | Editor seats, API call volume, storage | Medium |
| **Vendor Lock-in** | Data export, migration ease | High |
| **AI Integration** | AI assistance features, MCP integration, RAG source quality | High |

### 3.2. CMS Classification & Recommendations

| Category | Examples | Recommended Use Case |
|:---|:---|:---|
| **SaaS Headless CMS** | Contentful, Sanity, Hygraph | Global delivery, enterprise |
| **Japan-Specific SaaS** | MicroCMS, Newt | Japanese market, small-medium scale |
| **OSS Headless CMS** | Strapi, Payload CMS, Directus | Self-hosted, customization-focused |
| **Git-Based CMS** | Decap CMS, Tina CMS | Developer blogs, documentation |

- **Rule 34.7**: When using WordPress, **Headless Mode (WPGraphQL)** is mandatory with full separation from the frontend (Next.js, etc.). PHP theme development is prohibited

### 3.3. Composable DXP Architecture

- **Rule 34.8**: Recommend **Composable DXP** combining best-of-breed services rather than monolithic CMS

```
Composable DXP Stack:
├── Content:      Headless CMS (Contentful / Sanity / MicroCMS)
├── Commerce:     Headless Commerce (Shopify Storefront API)
├── Search:       Search Service (Algolia / Meilisearch)
├── Media:        DAM (Cloudinary / imgix)
├── Personalization: CDP + Personalization Engine
├── Analytics:    Analytics Platform (GA4 / Amplitude)
├── AI:           AI Platform (Gemini / OpenAI / Claude)
└── Frontend:     Meta Framework (Next.js / Nuxt / Astro)
```

### 3.4. Vendor Lock-in Avoidance

- **Rule 34.9**: Access CMS through an abstraction layer rather than directly depending on CMS-specific SDKs or data formats
- **Data Portability**: JSON/CSV content export capability is a mandatory CMS selection criterion
- **Content Abstraction Layer**: Introduce an adapter pattern between CMS and frontend to minimize frontend changes during CMS migration

### 3.5. MACH Alliance Certification Criteria

- **Rule 34.85**: Include MACH Alliance (Microservices, API-first, Cloud-native, Headless) certification as evaluation criteria when selecting enterprise CMS

| MACH Principle | Evaluation Point |
|:---|:---|
| **Microservices** | Can functional modules be independently deployed and scaled? |
| **API-first** | Are all features exposed via API? |
| **Cloud-native** | Is it SaaS / multi-tenant / auto-scaling? |
| **Headless** | Are frontend and backend physically separated? |

- **Orchestration Layer**: Design an orchestration layer (API Gateway / BFF) that integrates Composable DXP services, minimizing coupling between services
- **API Composition**: Implement API Composition patterns to aggregate responses from multiple microservices into single requests, preventing excessive API calls from the frontend

---

## Part IV: Content Modeling Fundamentals

### 4.1. Content Modeling First Principle

- **Rule 34.10**: Design the content model before writing code (Design First, Implement Second)
- Design content models based on **meaning**, not **display**
- Co-design in collaborative workshops with developers, editors, and UX designers

### 4.2. Five Principles of Content Modeling

| # | Principle | Description |
|:---|:---|:---|
| 1 | **Semantic Design** | Define fields by "meaning", not "appearance" |
| 2 | **Reusability** | Enable content reuse across multiple channels |
| 3 | **Atomicity** | Decompose content into the smallest reusable units |
| 4 | **Relationships** | Explicitly define inter-content references through relations |
| 5 | **Extensibility** | Design for minimal impact from future requirement changes |

### 4.3. Anti-Pattern: Display-Driven Modeling

```
// ❌ Prohibited: Display-dependent modeling
{
  "heroTitle": "...",        // "Title for hero section"
  "sidebarText": "...",      // "Text for sidebar"
  "mobileDescription": "..." // "Description for mobile"
}

// ✅ Correct: Semantic modeling
{
  "title": "...",            // "Title"
  "summary": "...",          // "Summary"
  "body": "...",             // "Body"
  "category": "ref:...",     // "Category reference"
}
```

---

## Part V: Structured Content Design

### 5.1. Structured Content Mandate

- **Rule 34.11**: All content MUST be defined as **structured data**. Direct storage of unstructured HTML blobs is prohibited
- Structured content enables AI processing, search, filtering, localization, and personalization

### 5.2. Field Type Strategy

| Field Type | Use Case | Design Guideline |
|:---|:---|:---|
| **Text (Short)** | Title, label | Define max character count, plain text |
| **Rich Text** | Body, description | Restrict allowed elements, Triple Write |
| **Number** | Price, sort order | Distinguish integer/decimal, min/max values |
| **Boolean** | Flag | Always define default value |
| **Date/DateTime** | Publish date, event date | Store in UTC, display with timezone |
| **Reference** | Reference to other content | Restrict referenced types |
| **Media** | Image, video | Via media library |
| **JSON** | Structured metadata | JSON Schema validation |
| **Enum** | Status, category | Predefined values only |
| **Slug** | URL-safe string | Unique constraint, auto-generation |

### 5.3. Content Schema Definition Mandate

- **Rule 34.12**: All content types MUST have schema definitions (field name, type, required/optional, validation rules, default values)

```typescript
// Content schema definition example
const ArticleSchema = {
  title:       { type: 'text', required: true, maxLength: 100 },
  slug:        { type: 'slug', required: true, unique: true, source: 'title' },
  summary:     { type: 'text', required: true, maxLength: 300 },
  body:        { type: 'richtext', required: true },
  body_html:   { type: 'text', generated: true },  // Triple Write
  body_text:   { type: 'text', generated: true },  // Triple Write
  category:    { type: 'reference', to: 'Category', required: true },
  tags:        { type: 'reference[]', to: 'Tag' },
  author:      { type: 'reference', to: 'Author', required: true },
  thumbnail:   { type: 'media', required: true },
  status:      { type: 'enum', values: ['draft','pending','published','archived'], default: 'draft' },
  published_at: { type: 'datetime' },
  meta_title:  { type: 'text', maxLength: 60 },
  meta_description: { type: 'text', maxLength: 160 },
  is_ai_generated: { type: 'boolean', default: false },
};
```

---

## Part VI: Content Types & Field Design

### 6.1. Content Type Classification

| Classification | Description | Examples |
|:---|:---|:---|
| **Document Type** | Independent content unit | Article, product, event |
| **Component Type** | Reusable parts | CTA block, FAQ item, quote |
| **Settings Type** | Global settings | Site settings, navigation |
| **Taxonomy Type** | Classification system | Category, tag, region |

### 6.2. Naming Conventions

- **Rule 34.13**: Content type names use **PascalCase**, field names use **camelCase** or **snake_case** (consistent within project)
- Match API response field names to prevent mapping discrepancies
- Ambiguous names like `data`, `info`, `content` are prohibited

### 6.3. Field Design Principles

- **Minimum Field Principle**: "Just in case" field additions are prohibited. Apply YAGNI
- **Required Field Limitation**: Only fields truly necessary for publication should be marked as required. Excessive required fields degrade editor experience
- **Default Value Mandate**: Define default values for all optional fields to minimize null states

---

## Part VII: Content Relationships & Reference Design

### 7.1. Reference Patterns

| Pattern | Description | Use Case |
|:---|:---|:---|
| **1:1 Reference** | Single reference | Article → Author |
| **1:N Reference** | Multiple references | Article → Tags[] |
| **Embedded** | Inline embedding | CTA block within article |
| **Bidirectional** | Two-way reference | Article ↔ Related articles |

### 7.2. Reference Integrity

- **Rule 34.14**: Implement **dangling reference** prevention mechanisms when referenced content is deleted
  - **Option A**: Block deletion of referenced content (constraint violation notification)
  - **Option B**: Nullify reference field + admin notification
  - Frontend handles broken references with Graceful Degradation (hide or fallback)

### 7.3. Circular Reference Prevention

- **Rule 34.15**: Auto-detect and warn against deep nesting beyond N levels (A → B → C → A) in content references
- Limit reference resolution depth to maximum 3 levels during API retrieval to physically prevent infinite loops

---

## Part VIII: Content Delivery API Design

### 8.1. API Design Principles

- **Rule 34.16**: Content Delivery API MUST be **read-only**, require no authentication (Public API), and provide fast responses
- **Response Format**: JSON API is standard. XML responses are deprecated

### 8.2. Endpoint Design

```
Content Delivery API:
GET /api/content/{type}           → Content list (pagination mandatory)
GET /api/content/{type}/{slug}    → Individual content
GET /api/content/{type}/{slug}/revisions → Revision list
```

### 8.3. Query Parameter Standards

| Parameter | Purpose | Example |
|:---|:---|:---|
| `fields` | Field selection | `?fields=title,slug,thumbnail` |
| `filter` | Conditional filter | `?filter[status]=published` |
| `sort` | Sort | `?sort=-published_at` |
| `limit` / `offset` | Pagination | `?limit=20&offset=0` |
| `include` | Reference expansion | `?include=author,category` |
| `locale` | Language specification | `?locale=ja` |

### 8.4. Pagination Mandate

- **Rule 34.17**: List APIs MUST always implement pagination. Creating endpoints that return all records is prohibited
- **Cursor-Based** recommended (performance advantage with large datasets)
- Include `total`, `hasNextPage`, `nextCursor` in response

### 8.5. Response Design

```typescript
// Standard response structure
interface ContentListResponse<T> {
  data: T[];
  meta: {
    total: number;
    limit: number;
    offset: number;
    hasNextPage: boolean;
    nextCursor?: string;
  };
}
```

---

## Part IX: GraphQL API Governance

### 9.1. GraphQL Adoption Criteria

- **Rule 34.18**: GraphQL is recommended for projects with complex content relationships. REST API is sufficient for simple content retrieval
- **Schema-First**: Define the GraphQL schema first; implementation follows the schema

### 9.2. GraphQL Security Mandate

| Measure | Description | Threshold |
|:---|:---|:---|
| **Query Depth Limit** | Nesting depth limit | Maximum 5 levels |
| **Query Complexity Limit** | Query complexity cap | Point-based (e.g., 1000 point cap) |
| **Rate Limiting** | Request frequency control | 100 req/min/client |
| **Introspection Control** | Schema exposure in production | **Disabled** in production |
| **Persisted Queries** | Allow only pre-registered queries | Recommended for production |

### 9.3. N+1 Problem Prevention

- **Rule 34.19**: Mandate use of DataLoader (batch loading) to prevent N+1 query problems in GraphQL resolvers
- Leverage framework standard features from Apollo Server / graphql-yoga, etc.

### 9.4. GraphQL Federation

- **Rule 34.20**: When integrating multiple CMSes or data sources, adopt GraphQL Federation (Apollo Federation / GraphQL Mesh) to provide a unified schema from a single endpoint
- Guarantee independent sub-graph deployment and type-safe composition

---

## Part X: Content Management API & Webhooks

### 10.1. Management API Design

- **Rule 34.21**: Content Management API MUST require **authentication** (Bearer Token / API Key) and is used for content operations from admin UI and CI/CD pipelines
- **RBAC**: API operation permissions are also controlled based on user roles

### 10.2. Webhook Design

- **Rule 34.22**: Implement standard webhook notifications for content create, update, publish, and delete events

| Event | Use Case | Recommended Action |
|:---|:---|:---|
| `content.published` | Publish notification | ISR revalidation, search index update |
| `content.updated` | Update notification | Cache invalidation |
| `content.deleted` | Delete notification | Cache deletion, redirect setup |
| `media.uploaded` | Media upload | Image optimization pipeline trigger |

### 10.3. Webhook Reliability

- **Rule 34.23**: **HMAC signature verification** is mandatory for webhook requests to prevent tampering
- **Retry Policy**: Retry with exponential backoff on failure (maximum 5 retries)
- **Idempotency Key**: Guarantee idempotency via event ID to prevent duplicate processing of the same event

### 10.4. CloudEvents Specification Compliance

- **Rule 34.86**: CMS webhook events SHOULD adopt payload structures compliant with the **CloudEvents specification (v1.0.2+)**

```json
{
  "specversion": "1.0",
  "type": "cms.content.published",
  "source": "/cms/articles",
  "id": "evt_abc123",
  "time": "2026-03-22T12:00:00Z",
  "datacontenttype": "application/json",
  "data": { "slug": "spring-campaign", "locale": "en" }
}
```

- **Interoperability**: CloudEvents compliance enables protocol-compatible integration with other microservices (search, analytics, notification)
- **Dead Letter Queue**: Store failed events in DLQ to guarantee subsequent reprocessing

---

## Part XI: Media Storage Strategy

### 11.1. Unified Media Library

- **Rule 34.24**: All media assets (content images, logos, icons) MUST be managed in a **unified media library** (Cloud Storage / S3 / Cloudinary), not in the `public/` folder
- Enable control of all assets from the admin UI

### 11.2. Semantic Folder Structure

- **Rule 34.25**: Mandate meaningful hierarchical folder structures such as `category/YYYY/MM/slug/`

```
media/
├── articles/2026/03/spring-campaign/
│   ├── hero.webp
│   └── thumbnail.webp
├── products/electronics/laptop-x1/
│   └── main.webp
└── system/
    ├── logo.svg
    └── no-image.webp
```

- Random ID-only (UUID, etc.) folder names are prohibited
- File name duplication within the same folder is prohibited to prevent overwriting

### 11.3. Admin Assets vs User Assets Separation

- **Rule 34.26**: "System assets (admin-managed)" and "UGC (user-uploaded)" MUST be **physically separated at the bucket or root folder level**

| Classification | Path | Management Method |
|:---|:---|:---|
| **Official Assets** | `admin/media/` | Via media library modal only |
| **User Assets** | `users/{uid}/` | Direct upload from user settings |

### 11.4. The Original Preservation Protocol

- **Law**: Images uploaded by administrators are "master data". Server-side compression or destructive transformation is strictly prohibited
- **Action**: All optimization (WebP/AVIF conversion, resizing) is executed at **delivery time (CDN Edge)**, preserving original files without degradation

### 11.5. No-Image Policy

- Fallback for missing images references a "common No-Image image" in storage. Hardcoding fallbacks in code is prohibited

---

## Part XII: Image Optimization & Delivery Pipeline

### 12.1. The CDN Delivery Gateway Mandate

- **Law**: Directly writing storage **origin URLs** in `<img>` tag `src` attributes is prohibited
- **Action**: Image delivery MUST go through a **CDN or reverse proxy**, applying edge-level caching, automatic format conversion (WebP/AVIF), and responsive resizing

### 12.2. The Storage URL Hardcoding Ban

- **Law**: Hardcoding image or file URLs in code is prohibited
- **Action**: Resolve domains and paths via utility functions like `getStorageUrl(path)`

```typescript
// ✅ Correct implementation
const imageUrl = getStorageUrl(`articles/2026/03/hero.webp`);

// ❌ Prohibited: Hardcoding
const imageUrl = `https://storage.example.com/articles/2026/03/hero.webp`;
```

### 12.3. Frontend Image Optimization

- **Rule 34.27**: Images delivered from CMS MUST be optimized and cached on the frontend side using `next/image` or equivalent. Avoid using CMS image URLs directly in `<img>` tags
- `srcset` / `sizes` for responsive images is standard
- Set `priority={true}` for LCP-critical images to enable preloading

---

## Part XIII: UGC Media Management & Video Strategy

### 13.1. The UGC Capacity Optimization Protocol

- **Law**: **Client-side preprocessing** is mandatory for user-uploaded images

| # | Processing | Threshold |
|:---|:---|:---|
| 1 | **Resize** | Maximum 1920px on longest edge |
| 2 | **EXIF Removal** | Remove ALL EXIF data including GPS (privacy protection) |
| 3 | **Format Validation** | Allow JPEG/PNG/WebP only, explicit file size limit |

### 13.2. The Video Ban Protocol

- **Law**: Direct upload of video files to the server is prohibited (bandwidth cost + content moderation risk)
- **Action**: Assume upload to external platforms (YouTube / Vimeo, etc.) and store only **embed codes (iframe/ID)** in the system

### 13.3. Editor Integration Protocol

- **Rule 34.28**: Direct upload via drag & drop or paste into the admin editor is **prohibited**
- Image insertion MUST go through the "Media Library" modal to enforce reuse of existing assets

---

## Part XIV: DAM (Digital Asset Management) Integration

### 14.1. DAM Integration Strategy

- **Rule 34.29**: In enterprise environments, recommend integrating external DAM (Cloudinary / Bynder / Brandfolder) in addition to CMS built-in media library

| Aspect | CMS Built-in Media Library | External DAM |
|:---|:---|:---|
| **Use Case** | Project-specific assets | Company-wide brand assets |
| **Features** | Basic management & search | AI auto-tagging, permission management, usage tracking |
| **Scale** | Small-medium | Large-scale, multi-brand |

### 14.2. DAM Integration Patterns

- **API Integration**: Call DAM API from CMS media selection UI to import assets
- **CDN Unification**: Deliver DAM and CMS media through the same CDN (Cloudinary / imgix) with unified transformation parameters
- **Metadata Sync**: Synchronize DAM tags and permission info to CMS media fields to prevent license violations

### 14.3. Asset Lifecycle Management

- **Rule 34.30**: Conduct quarterly audits of unused assets to optimize storage costs
- **Usage Tracking**: Enable tracing of where each asset is referenced (which content uses it)
- **License Management**: Manage external material license expiration dates as metadata with automated expiry alerts

---

## Part XV: Rendering Strategy (SSG/ISR/SSR)

### 15.1. Rendering Pattern Selection

| Pattern | Description | Recommended Use Case |
|:---|:---|:---|
| **SSG** | HTML generated at build time | Terms of service, about page (low update frequency) |
| **ISR** | Background regeneration on request | Article lists, featured pages |
| **SSR** | Server-side generation per request | Rankings, personalized content |
| **CSR** | Client-side rendering | Interactive widgets only |

- **Rule 34.31**: Implementing SEO-important CMS content with CSR only is prohibited. Use SSG, ISR, or SSR

### 15.2. ISR Design Principles

- **On-demand Revalidation**: Trigger instant revalidation of affected pages on content update via CMS Webhook
- **Tag-based Revalidation**: Implement batch revalidation by content type using `revalidateTag()`

---

## Part XVI: CDN & Edge Delivery

### 16.1. Edge Delivery Strategy

- **Rule 34.32**: CMS content delivery MUST leverage CDN to minimize direct access to origin servers
- Utilize multi-region CDN PoPs (Points of Presence) for global delivery

### 16.2. Edge Functions Utilization

- Process preview authentication, A/B test routing, geolocation decisions, etc. in Edge Functions (Vercel Edge / Cloudflare Workers) to reduce requests to origin

---

## Part XVII: Cache Tiering Strategy

### 17.1. The Content Cache Tiering Protocol

- **Law**: Cache TTL MUST be tiered based on content update frequency. Applying uniform cache settings to all content is prohibited

| Tier | Content Example | Cache Strategy |
|:---|:---|:---|
| **Hot (High Frequency)** | Rankings, inventory, prices | ISR `revalidate: 60`-300 or SSR |
| **Warm (Medium Frequency)** | Article lists, featured pages | ISR `revalidate: 3600` |
| **Cold (Low Frequency)** | Terms of service, about page | SSG + On-demand Revalidation |

### 17.2. Cache Invalidation

- **Rule 34.33**: Trigger On-demand Revalidation on content update to prevent stale cache retention
- **Cache Key Design**: Include role information in cache keys to prevent mixing admin preview and public view caches

---

## Part XVIII: Rich Text Editor Governance

### 18.1. Strict Schema

- **Rule 34.34**: Editor (Tiptap, etc.) MUST allow only permitted elements (H2/H3, etc.) to prevent design breakage by operators
- Allowed node list: `heading(2-3)`, `paragraph`, `bold`, `italic`, `link`, `image`, `blockquote`, `bulletList`, `orderedList`, `codeBlock`, `table`
- Layout-breaking elements like `<font>`, `<style>`, `<div>` are prohibited

### 18.2. Paste Sanitization

- **Rule 34.35**: Sanitize with DOMPurify or equivalent on paste and display to remove malicious scripts and broken styles

### 18.3. PII Real-Time Warning

- When phone numbers or email addresses are detected during editor input, display an immediate Toast "warning" to prompt reconsideration rather than blocking save

### 18.4. Code Injection Prevention

- When using HTML direct input nodes, always route through a code editor (PrismJS, etc.) to prevent layout breakage from syntax errors

### 18.5. The CMS Transparency Protocol

- **Law**: Rich text editors MUST implement a "source view" feature with bidirectional binding

### 18.6. The Micro-Content Protocol

- **Law**: Using rich text editors for small text fields (supplementary descriptions, etc.) is prohibited
- **Action**: Keep data structure simple with `Textarea` + `Markdown` parser (`react-markdown`, etc.)

---

## Part XIX: Triple Write Protocol & Data Integrity

### 19.1. The Triple Write Protocol

- **Law**: Rich text data MUST be stored in the following 3 formats via **Atomic Update**

| # | Format | Use Case |
|:---|:---|:---|
| 1 | **JSON (Editor Source)** | Structured data for re-editability and future extension |
| 2 | **HTML (View Source)** | Frontend display (zero parse overhead) |
| 3 | **TEXT (Search Source)** | Plain text for search index and AI RAG |

- The authoritative data format is **JSON (`JSONContent`)**, not HTML strings

### 19.2. The Content Auto-Save Protocol

- **Law**: Auto-save editor content across multiple layers

| Layer | Storage | Interval |
|:---|:---|:---|
| **Local Auto-Save** | `localStorage` | Every 30 seconds |
| **Server Draft Sync** | Server DB | Every 60 seconds |

- **Conflict Detection**: Detect simultaneous editing of the same content in multiple tabs and notify. Silent overwriting is prohibited

---

## Part XX: Editor Extensions & NodeView Design

### 20.1. The NodeView Portal Prohibition

- **Law**: In ProseMirror-based editors (Tiptap, etc.), using React Portal (`createPortal`) from within custom NodeViews to render UI to external DOM (`document.body`, etc.) is **prohibited**
- **Action**: Render inline within NodeView's `contentDOM` or delegate control to the editor's command system

### 20.2. The stopEvent Configuration Mandate

- **Law**: When placing interactive elements (`<input>`, `<select>`, `<button>`, etc.) within custom NodeViews, `stopEvent` function configuration is mandatory
- **Action**: Control target events (`mousedown`, `keydown`, `input`, `dragstart`) to prevent propagation to the editor. Selectively block only interactive element events, not indiscriminate blocking of all events

---

## Part XXI: Publishing Workflow

### 21.1. Publishing Workflow

- **Rule 34.36**: Content MUST follow the status transition flow

```
draft → pending → published → archived
  ↑       │                       │
  └───────┘ (rejection)           │
  ↑                               │
  └───────────────────────────────┘ (re-edit)
```

### 21.2. Secure Preview

- Preview of pre-publication content is only permitted via signed URLs (`verify(token)`)

### 21.3. Scheduled Publishing

- Content becomes public only when both conditions are met: `status = 'published'` AND `published_at <= NOW()`
- Implement cache purge (ISR/Revalidate) mechanism linked to scheduling

---

## Part XXII: Approval Gates & Status Transitions

### 22.1. The Content Approval Gate Protocol

- **Law**: Strictly control "who" can execute status transitions under "what conditions"

| Transition | Permission | Condition |
|:---|:---|:---|
| `draft → pending` | Writer (creator) | Body is not empty |
| `pending → published` | **Editor or above** | Review completion flag is `true` |
| `published → archived` | Admin | Archive reason input mandatory |
| `archived → draft` | Admin | Re-edit start audit log |
| `pending → draft` | Writer or Admin | Rejection reason comment mandatory |

- **Self-Publish Ban**: Prohibit creators from directly transitioning their own content to `published` status
- **Audit Trail**: Record all status transitions in audit logs (`who`, `when`, `from_status`, `to_status`, `reason`)

---

## Part XXIII: Scheduling & Scheduled Publishing

### 23.1. The Page Scheduling Protocol

- **Law**: Implement scheduling functionality to execute content publish/unpublish at specified dates/times as standard

| Field | Purpose |
|:---|:---|
| `published_at` | Publish date/time |
| `unpublished_at` | Unpublish date/time (for time-limited content) |

- **Query Filter**: `published_at <= NOW() AND (unpublished_at IS NULL OR unpublished_at > NOW())`
- **Dual Defense**: Check time at both DB query and application logic layers to prevent bypass risks from CDN cache/ISR
- **Cache Invalidation**: Auto-invalidate related page caches when scheduled time is reached

---

## Part XXIV: Revision Management & Audit Trail

### 24.1. The Content Revision Protocol

- **Rule 34.37**: Save diffs to the `revisions` table on every content save
- **Retention**: Revisions are retained **indefinitely** in principle
- **Diff View**: Implement diff display between the last N revisions (recommended: 10+) in the admin UI
- **Rollback**: Implement one-click restoration to past revisions as standard

### 24.2. Legal Document Versioning

- Legal documents (terms of service, privacy policy, etc.) MUST maintain the ability to restore and display any past version at any point in time (Legal Time Machine)

---

## Part XXV: Preview Strategy

### 25.1. The Preview Gate Protocol

- **Law**: Restrict preview access for draft/unpublished content to **authenticated administrators only**

| # | Measure | Description |
|:---|:---|:---|
| 1 | **Draft Isolation** | In preview mode, maintain invisibility from general users including `status = 'draft'` |
| 2 | **Auth Gate** | Require authentication token or session verification for preview URLs |
| 3 | **No Draft Leak** | Prevent search indexing with `noindex` meta tag or `X-Robots-Tag` |
| 4 | **Multi-Factor Preview** | Multi-factor authentication with URL token + password input |
| 5 | **Cookie Fallback** | Redirect to password input screen when session is invalid |

---

## Part XXVI: Dual Mode Fetching

### 26.1. The Dual Mode Fetching Protocol

- **Law**: When handling preview functionality and public pages in the same codebase, physically prevent unpublished data leaking to public pages
- **Explicit Method Separation**: Explicitly separate data fetching functions for public and preview
- **Default Deny**: Preview flag defaults to `false` (Public Mode). Only escalate permissions with explicit authorization

---

## Part XXVII: Soft 404 & HTTP Status Codes

### 27.1. The Soft 404 Awareness Protocol

- **Law**: Prevent "Soft 404" where deleted/unpublished content URLs return status code 200 with empty pages

| Scenario | HTTP Status |
|:---|:---|
| Deleted resource | **410 Gone** |
| Non-existent resource | **404 Not Found** |
| Moved content | **301 Redirect** |

- **No Empty Pages**: Returning "This page does not exist" with status code 200 is prohibited (gets indexed by search engines, negatively impacts SEO)
- **Content-Based Verification**: Use page content existence as verification criteria in addition to status codes in testing and monitoring

---

## Part XXVIII: Hybrid Layout Design (Content vs Layout)

### 28.1. The Hybrid Design Protocol

- **Rule 34.38**: CMS best practice is a hybrid design that separates "content entities (Relational)" from "placement information (JSON)"
- Manage articles and products in normalized tables; manage only top page section order and widget placement in **JSON arrays**

### 28.2. The Schema Permission Lock Protocol

- **Law**: In JSON-based layout definitions, **clearly separate at the schema level** the "structure defined and locked by operators (System Schema)" from "editable areas (User Data)"
- **Lock/Unlock Separation**: Attach `editable: true/false` metadata to fields and physically control editability in the UI
- **Validation Gate**: Backend MUST reject changes to locked fields. Protection through frontend controls alone is prohibited

---

## Part XXIX: Dynamic Page Builder & Component Registry

### 29.1. Dynamic Page Builder

- **Rule 34.39**: Top pages and landing pages MUST NOT be hardcoded; enable free addition and reordering of sections from the admin UI
- **Component Isolation**: Isolate each section as an independent component within `ErrorBoundary`
- **LCP Optimization**: Render hero banners, etc. with SSR and preload with `priority={true}`
- **No Deploy for Layout**: Maintain a design where layout changes do not require code deployment

### 29.2. The Component Mapping Protocol

- **Law**: Physically define a **ComponentRegistry** providing 1:1 mapping between CMS types and frontend components

```typescript
// ✅ Plugin architecture
const ComponentRegistry: Record<string, React.ComponentType<SectionProps>> = {
  hero:     HeroSection,
  ranking:  RankingSection,
  featured: FeaturedSection,
  newItems: NewItemsSection,
};

// ❌ Prohibited: switch statement branching
switch (section.type) {
  case 'hero': return <HeroSection />;
  // ...
}
```

### 29.3. Fixed Page Strategy

- **Rule 34.40**: "Fixed pages" such as terms of service and landing pages MUST NOT be hardcoded but managed in Headless CMS (`fixed_pages`) and delivered via dynamic routing (`/[slug]`)
- **API-First Delivery**: Implement a companion API endpoint returning JSON data for future app delivery

---

## Part XXX: SEO Automation & Metadata Management

### 30.1. The SEO Preview Mandate

- **Law**: Install an **SEO preview panel** permanently on the content editing screen

| Item | Criteria | On Violation |
|:---|:---|:---|
| **meta title** | 15-60 characters | Yellow warning |
| **meta description** | 50-160 characters | Yellow warning |
| **OGP image** | 1200×630px recommended, ≦300KB | Resize suggestion |
| **H1 heading** | One per page | Red warning |

- **Auto-Suggestion**: Auto-generate candidates from body text when title/description is not entered

### 30.2. Automated SEO

- **Meta Automation**: Auto-complete with AI summary or default image when title or OGP is not set
- **Internal Linking**: Auto-recommend related content (tag/category match) to strengthen internal link structure

---

## Part XXXI: Structured Data & Schema.org

### 31.1. Structured Data Auto-Generation

- **Rule 34.41**: Auto-generate JSON-LD Schema.org markup from CMS content

| Content Type | Schema.org Type |
|:---|:---|
| Article | `Article` / `BlogPosting` |
| Product | `Product` |
| FAQ | `FAQPage` |
| Event | `Event` |
| Local Business | `LocalBusiness` |
| Review | `Review` / `AggregateRating` |

### 31.2. Breadcrumb

- **Rule 34.42**: Auto-generate `BreadcrumbList` markup based on CMS category hierarchy

---

## Part XXXII: AI-Ready Content Protocol

### 32.1. AI-Ready Content Design

- **Rule 34.43**: Design content for easy understanding and citation by AI agents (RAG/Search/LLM), not just humans

| Principle | Description |
|:---|:---|
| **Semantic Markup** | Use H2/H3, lists, definition lists (Wall of Text prohibited) |
| **Summary Metadata** | Summary field mandatory for each content |
| **Keyword Tags** | Attach machine-readable keywords/tags |
| **Trust Score** | Metadata indicating content trust level (verified/AI-generated/UGC, etc.) |

### 32.2. LLMs.txt Support

- **Rule 34.44**: Deploy `llms.txt` file for AI crawlers to provide site structure and content navigation
- Include direct links to key content with concise descriptions

### 32.3. Content as RAG Source

- The **plain text (TEXT format)** generated by the Triple Write Protocol (§XIX) serves as the RAG reference source
- Noisy data containing HTML tags is a waste of tokens and degrades answer accuracy
- **Cross-Reference**: `400_ai_engineering.md` §XIX (RAG Infrastructure Design)

### 32.4. MCP Server Integration

- **Rule 34.45**: Implement an **MCP (Model Context Protocol) Server** to expose CMS content to AI agents, providing an interface for AI to directly retrieve, search, and update content
- **Resource Exposure**: Define content type listing, individual content retrieval, and search as MCP resources
- **Tool Exposure**: Define content creation, updates, and status transitions as MCP tools with RBAC applied
- **Cross-Reference**: `400_ai_engineering.md` §XXVIII (MCP Design)

---

## Part XXXIII: AI-Powered Content Operations

### 33.1. AI Assistance Features

| Feature | Description | Implementation Priority |
|:---|:---|:---|
| **Auto-Tagging** | Auto-infer categories/tags from content | High |
| **Summary Generation** | Auto-generate meta description candidates from body | High |
| **Translation Assistance** | Auto-generate first draft translations, human review | Medium |
| **Similar Content Detection** | Auto-detect duplicate/similar content | Medium |
| **Quality Scoring** | Auto-evaluate readability and SEO quality | Medium |
| **Image Alt Generation** | Auto-suggest alt text via AI image analysis | Medium |

### 33.2. AI Copilot for Editors

- **Rule 34.46**: AI editing assistance MUST be designed as "suggestions" with final judgment made by humans
- Accept/Reject interactions are mandatory for AI-generated suggestions

---

## Part XXXIV: AI-Generated Content Governance

### 34.1. AI-Generated Content Labeling

- **Rule 34.47**: Content generated or assisted by AI MUST **always display** a label indicating its origin
- DB Flag: Track with `is_ai_generated: boolean` (default: `false`)
- **No Raw Publish**: Publishing AI-generated text directly as official content is prohibited. Only content that has undergone human editing and verification qualifies as official content
- **Cross-Reference**: `400_ai_engineering.md` §VIII (AI Content Labeling)

### 34.2. AI-Generated Content Quality Assurance

- **Rule 34.48**: Apply additional quality check layers to AI-generated content
  - **Fact Verification**: Cross-referencing with RAG sources or confirmed data is mandatory
  - **Hallucination Detection**: Flag unverifiable proper nouns and numbers, require human review
  - **Tone Consistency**: Conduct automated brand guideline alignment checks

---

## Part XXXV: Agentic CMS & AI Autonomous Content Management

### 35.1. Agentic CMS Autonomy Levels

- **Rule 34.49**: Define AI Agent CMS operation permissions in 5 levels, progressively expanding autonomy

| Level | Name | AI Role | Human Role | Example |
|:---|:---|:---|:---|:---|
| **L1** | Suggestion | Present improvement proposals | Execute all operations | Tag candidate suggestions |
| **L2** | Drafting | Auto-create drafts | Review & approve | AI translation first drafts |
| **L3** | Auto-Execute + Notify | Auto-execute after approval | Post-hoc monitoring | SEO meta auto-completion |
| **L4** | Supervised Autonomy | Autonomous execution + exception reporting | Exception handling | Content update notification auto-dispatch |
| **L5** | Full Autonomy | Autonomous judgment + execution | Policy setting only | Publish permission to AI itself is prohibited |

- **Rule 34.50**: At autonomy levels L3 and above, **direct publishing** of content by AI is prohibited. Human approval is always required for transitions to published status

### 35.2. AI Agent Workflow Integration

- **Content Refresh Agent**: Detect stale content, auto-generate update proposals and submit to review queue
- **SEO Optimization Agent**: Analyze content SEO scores and propose title/metadata optimizations
- **Translation Agent**: Detect newly published content and auto-generate first draft translations for target languages

### 35.3. A2A Protocol Integration

- **Rule 34.87**: When multiple AI Agents coordinate to execute content workflows, adopt the **A2A (Agent-to-Agent) Protocol** to standardize inter-agent communication
- **Agent Card**: Publish each CMS Agent's capabilities (tools, permissions, I/O schema) as an Agent Card to enable dynamic coordination
- **Task Delegation**: Use A2A task management capabilities when delegating tasks in chain format such as Content Refresh Agent → Translation Agent → SEO Agent
- **Cross-Reference**: `400_ai_engineering.md` §XXX (A2A Protocol Design)

### 35.4. Agent Safety Guardrails

- **Rule 34.51**: Record all AI Agent actions in audit logs
- **Rate Limit**: Limit AI Agent operation frequency to prevent runaway behavior
- **Kill Switch**: Implement a kill switch to immediately halt AI Agent functionality
- **Cross-Reference**: `400_ai_engineering.md` §XXVI-XXXV (Agentic AI & Guardrail Design)

---

## Part XXXVI: CMS Security Architecture (OWASP 2025)

### 36.1. CMS Admin UI Security

- **Rule 34.52**: CMS admin UI MUST be protected with IP restrictions, SSO, and MFA, fully separated from the public frontend

| Defense Layer | Measures |
|:---|:---|
| **Authentication** | SSO / OAuth 2.0 + PKCE + MFA mandatory |
| **Network** | IP restriction / VPN / Zero Trust |
| **API** | API key rotation (90 days) / HMAC signatures |
| **Input** | XSS prevention / SQL injection prevention / CSRF protection |
| **Data** | Encryption (TLS 1.3 + AES-256 at rest) |
| **Dependencies** | Supply chain security (SCA / SBOM) |

### 36.2. The Media Library Sanctuary

- **Law**: Media management logic (`admin/media`) is a security cornerstone. Arbitrary refactoring or deletion by AI is prohibited. Changes require explicit user approval

### 36.3. RBAC (Role-Based Access Control)

| Role | Permissions |
|:---|:---|
| **Viewer** | View published content only |
| **Writer** | Create/edit drafts, transition to pending |
| **Editor** | Review, publish, archive |
| **Admin** | All operations + user management + settings |

### 36.4. OWASP 2025 CMS Response

- **Rule 34.53**: Implement CMS-specific countermeasures for major OWASP Top 10 2025 risks

| OWASP 2025 Risk | CMS Countermeasure |
|:---|:---|
| **A01: Broken Access Control** | RBAC enforcement, Default Deny, API permission separation |
| **A02: Security Misconfiguration** | CMS setting hardening, Introspection disabling |
| **A03: Supply Chain Failures** | Regular SCA scans of CMS dependencies, SBOM management |
| **A05: Injection** | Input sanitization, ORM usage, parameter binding |
| **A07: Authentication Failures** | MFA mandatory, session management, API key management |

---

## Part XXXVII: Content Supply Chain Security

### 37.1. Content Provenance Tracking

- **Rule 34.54**: Attach provenance metadata (creator, creation method, reviewer, AI usage) to all content to build a content trust chain

| Metadata | Description |
|:---|:---|
| `created_by` | Creator ID |
| `creation_method` | `manual` / `ai_assisted` / `ai_generated` / `imported` |
| `reviewed_by` | Review approver ID |
| `source_url` | Source URL (for imports) |
| `content_hash` | Hash for content tamper detection |

### 37.2. C2PA Content Credentials Integration

- **Rule 34.88**: Adopt the **C2PA (Coalition for Content Provenance and Authenticity)** standard for media asset provenance, embedding tamper-evident Content Credentials

| C2PA Metadata | Description |
|:---|:---|
| **Creator** | Content creator's signing certificate |
| **Creation Tool** | Tools used (CMS name, AI model name) |
| **Edit History** | Change history chain (tamper-detectable) |
| **AI Involvement** | Whether AI was used for generation/assistance and details |
| **Timestamp** | Cryptographically signed creation date/time |

- **DAM Integration**: Verify C2PA manifests during asset import from DAM to CMS, warning on assets with unknown provenance
- **Deepfake Countermeasures**: Combine AI-generated image detection and auto-labeling with C2PA metadata

### 37.3. External Content Ingestion Security

- **Rule 34.55**: Mandate the following when ingesting content from external sources (RSS, API, scraping)
  - HTML sanitization (DOMPurify)
  - URL validation (whitelist)
  - Virus scanning of media files
  - Rate limiting

---

## Part XXXVIII: Content Moderation & Trust & Safety

### 38.1. The Content Moderation Protocol

- **Law**: Build a multi-layered moderation framework for services accepting UGC

| Category | Examples | Response |
|:---|:---|:---|
| **Harassment** | Personal attacks, defamation, discriminatory language | Immediate unpublish + poster warning |
| **Misinformation** | Including stealth marketing | Unpublish + investigation |
| **Personal Information** | Phone numbers, addresses, email addresses | Auto-masking |
| **Harmful Content** | Violence, obscenity, drugs | Immediate deletion |
| **Spam** | Advertising purposes, link spam | Auto-filter to hidden |
| **Copyright Infringement** | Unauthorized image reproduction, text plagiarism | Legal response flow |

### 38.2. Moderation Layers

1. **Auto-Filter (Layer 1)**: Instant judgment using NG word dictionary + regex patterns
2. **AI Judgment (Layer 2)**: Sentiment analysis and toxicity detection to flag as "needs review"
3. **Human Review (Layer 3)**: Admin reviews flagged content within 24 hours

- **Transparency**: Notify posters of unpublish reasons and provide opportunity for appeal

---

## Part XXXIX: Content Accessibility (WCAG 2.2/EAA)

### 39.1. CMS Output Accessibility Mandate

- **Rule 34.56**: Content delivered from CMS MUST comply with WCAG 2.2 Level AA

| Requirement | Specific Measures |
|:---|:---|
| **Image alt attributes** | Mandate alt attribute input during CMS entry (allowing empty string for decorative images) |
| **Heading hierarchy** | Strictly follow H1→H2→H3 order. Prohibit H1 skipping or H2→H4 jumping |
| **Link text** | Warn against non-descriptive link text like "click here" or "learn more" |
| **Color contrast** | Guarantee minimum contrast ratio of 4.5:1 between text and background |
| **Video captions** | Captions/transcripts mandatory for video content |

### 39.2. European Accessibility Act (EAA) Compliance

- **Rule 34.57**: Comply with the EAA (effective June 2025) by also ensuring the CMS admin UI itself meets WCAG 2.2 AA level accessibility
- CMS rich text editor MUST be fully operable via keyboard only

---

## Part XL: Multilingual Content Management & Translation Workflow

### 40.1. Multilingual Architecture

| Pattern | Description | Recommended Use Case |
|:---|:---|:---|
| **Locale per Field** | Hold per-locale values for each field | Field-level translation control |
| **Locale per Entry** | Duplicate entire content entry per locale | Completely different content |
| **Hybrid** | Translate some fields only, share the rest | Images/numbers shared, text translated |

### 40.2. Translation Workflow

- **Rule 34.58**: Manage translations through CMS internal workflow or TMS (Translation Management System) integration
- Use AI translation only as first drafts with mandatory human review
- **Translation Memory**: Build a system to accumulate and reuse past translation assets
- **Cross-Reference**: `800_internationalization.md` (Global Expansion), `802_language_protocol.md` (Language Protocol)

---

## Part XLI: Content Personalization

### 41.1. Personalization Strategy

- **Rule 34.59**: CMS content personalization MUST comply with privacy regulations (GDPR/APPI) and be based on explicit consent only

| Level | Method | Example |
|:---|:---|:---|
| **L1: Segment** | Segment display based on user attributes | Different hero for new/existing users |
| **L2: Behavioral** | Recommendations based on browsing history | "Recommended articles for you" |
| **L3: Real-Time** | Context-based (location, time) | Regional event display |

### 41.2. Edge Personalization

- Execute personalization decisions in Edge Functions (Vercel Edge Middleware, etc.) to serve different content without additional requests to origin
- Control personalized content caching via `Vary` header or cookie branching

---

## Part XLII: Content Governance & Lifecycle Management

### 42.1. Content Governance Framework

- **Rule 34.60**: Build a governance framework controlling the entire content lifecycle (planning → creation → review → publish → update → archive → deletion)

| Phase | Responsible | Checkpoint |
|:---|:---|:---|
| **Planning** | Content Strategist | Keyword research, competitive analysis |
| **Creation** | Writer | Brand guideline compliance check |
| **Review** | Editor | Quality, accuracy, legal check |
| **Publish** | Publisher | SEO, accessibility final check |
| **Update** | Owner | Freshness check (quarterly review) |
| **Archive** | Admin | 301 redirect setup, SEO impact assessment |

### 42.2. Content Freshness Management

- **Rule 34.61**: Set a `content_review_date` (next review date) field on all content, with auto-notification to owner on expiry
- **Stale Content Detection**: Auto-flag content not updated for 180+ days since publication as "needs review"

### 42.3. Content Ownership

- **Rule 34.62**: Set a `content_owner` field on all content to clarify responsibility for updates and deletion. Prevent orphaned content without owners

---

## Part XLIII: Content Versioning & Content as Code

### 43.1. Content as Code

- **Rule 34.63**: Manage content schema definitions (content types, field definitions, validation rules) as code with Git version control
- Apply schema changes through pull requests with review and approval
- Automate schema migration between environments (dev → staging → production)

### 43.2. Content Snapshots

- **Rule 34.64**: Take regular production content snapshots (daily) as restore points for failures
- Also use for content cloning to staging environments

---

## Part XLIV: CMS Migration Strategy & Vendor Switching

### 44.1. CMS Migration Plan

- **Rule 34.65**: Execute CMS migration in phased stages

| Phase | Content | Duration Estimate |
|:---|:---|:---|
| **1. Evaluation** | New CMS selection, PoC implementation, cost comparison | 2-4 weeks |
| **2. Design** | Content model migration design, API conversion design | 2-4 weeks |
| **3. Pilot** | Migration test with small content subset | 2 weeks |
| **4. Production Migration** | Full content migration execution | 2-4 weeks |
| **5. Verification** | SEO impact confirmation, redirect verification, monitoring | 2 weeks |

### 44.2. Data Portability

- **Rule 34.66**: CMS migration data preservation checklist
  - Complete migration of content body (structured data)
  - Media asset migration and reference updates
  - 301 redirect setup (old URL → new URL)
  - Metadata migration (SEO, OGP)
  - Revision history migration (when possible)
  - Internal link rewriting

### 44.3. Content Abstraction Layer

- **Rule 34.67**: Install a Content Abstraction Layer between frontend and CMS to minimize impact during CMS switching
- Convert CMS-specific response formats to a unified internal data model
- During CMS migration, only replace the Abstraction Layer adapter

---

## Part XLV: Content Federation & Multi-Source

### 45.1. Content Federation

- **Rule 34.68**: When integrating and delivering from multiple CMSes or data sources, adopt the Content Federation pattern
- **GraphQL Mesh**: Integrate multiple APIs into a single GraphQL endpoint
- **BFF (Backend for Frontend)**: Combine multiple sources in a frontend-specific API layer

### 45.2. Multi-Source Integration

| Source | Use Case | Integration Method |
|:---|:---|:---|
| **Primary CMS** | Main content | Direct API connection |
| **Secondary CMS** | Blog, news | GraphQL Mesh |
| **Commerce Platform** | Product data | API / Webhook sync |
| **DAM** | Brand assets | CDN integration |
| **UGC Platform** | Reviews, comments | API + moderation |

---

## Part XLVI: Real-Time Collaboration

### 46.1. Simultaneous Editing Design

- **Rule 34.69**: When supporting simultaneous editing in the CMS admin UI, adopt one of the following approaches

| Approach | Description | Recommended Use Case |
|:---|:---|:---|
| **Pessimistic Locking** | Block other users' edits during editing | Simple CMS |
| **Optimistic Locking** | Conflict detection via version numbers, merge | Medium-scale CMS |
| **CRDT** | Automatic conflict-free merge | Real-time focused |
| **OT (Operational Transform)** | Operation transformation and composition | Google Docs-type |

### 46.2. Presence Display

- **Rule 34.70**: Display other editors' presence (avatar, cursor position) in real-time on the same content editing screen
- Show "Another user is editing" warning when editing starts

---

## Part XLVII: Content Experimentation & A/B Testing

### 47.1. Content Experimentation Platform

- **Rule 34.71**: Enable A/B testing at the CMS content level

| Component | Description |
|:---|:---|
| **Variant Management** | Manage multiple variants of the same content in CMS |
| **Traffic Distribution** | Control variant distribution with Edge Functions |
| **Measurement** | Measure CTR, time-on-page, CVR per variant |
| **Statistical Judgment** | Auto-determine statistical significance and present winning variant |

### 47.2. Feature Flag Integration

- Link Feature Flags to CMS content to enable staged rollouts and Kill Switches

---

## Part XLVIII: Server-Driven UI & Remote Config

### 48.1. Server-Driven UI

- **Rule 34.72**: Adopt CMS-driven Server-Driven UI patterns to update UI without app build/deploy
- Deliver component definitions in JSON format from CMS for dynamic rendering by mobile apps and web
- **Version Compatibility**: Process unrecognized component types with Graceful Degradation

### 48.2. Remote Config

- Deliver Feature Flags, wording changes, display controls from CMS to enable operational changes without code deployment
- **Cache Strategy**: Set short TTL (60-300 seconds) for Remote Config caches to guarantee rapid change reflection

---

## Part XLIX: Editor Experience (EX)

### 49.1. Editor Experience Design Principles

- **Rule 34.73**: CMS admin UI UX MUST be designed primarily for "content editors", not "developers"

| Principle | Description |
|:---|:---|
| **Minimize Cognitive Load** | Show only necessary fields, progressive disclosure |
| **Immediate Feedback** | Inline display of validation errors |
| **Shortcuts** | Keyboard shortcuts for frequently used actions |
| **Onboarding** | Tutorial tour for first-time use |

### 49.2. Editor Satisfaction Metrics

- **Rule 34.74**: Quantitatively measure editor satisfaction and reflect in CMS improvements quarterly
- **Measurement Items**: Task completion time, error rate, NPS, SUS (System Usability Scale)

---

## Part L: CMS Testing Strategy

### 50.1. Test Hierarchy

- **Rule 34.75**: Execute tests for CMS content and schemas at the following hierarchy levels

| Test Layer | Target | Tool Examples |
|:---|:---|:---|
| **Schema Tests** | Content model definition validity | Zod / JSON Schema |
| **API Tests** | Endpoint response verification | Vitest / Playwright API |
| **Content Integrity** | Reference integrity, required field fulfillment | Custom scripts |
| **E2E Tests** | Admin UI workflow | Playwright / Cypress |
| **Visual Regression** | Visual changes in rendering results | Percy / Chromatic |

### 50.2. Content Smoke Tests

- **Rule 34.76**: Auto-execute content existence verification (Smoke Test) on key pages after deployment
- Include detection of empty pages (Soft 404)

---

## Part LI: Content Pipeline Automation

### 51.1. Webhook Chain Architecture

- **Rule 34.77**: Automate processes linked to content updates via Webhook Chain

```
Content Published
├── → ISR Revalidation
├── → Search Index Update (Algolia/Meilisearch)
├── → CDN Cache Purge
├── → RSS/Sitemap Regeneration
├── → Social Media Auto-Share
├── → Translation Queue Trigger
└── → Analytics Event Tracking
```

### 51.2. CI/CD Integration

- Integrate content schema change migration execution into CI/CD pipeline
- Automate pre-deployment content integrity checks with GitHub Actions

---

## Part LII: Multi-Tenant CMS

### 52.1. Multi-Tenant Design

- **Rule 34.78**: Select the following isolation levels for multi-tenant CMS

| Level | Isolation Method | Recommended Use Case |
|:---|:---|:---|
| **L1: Logical** | Same DB, filter by tenant ID | Small SaaS |
| **L2: Schema** | Same DB, per-tenant schema | Medium SaaS |
| **L3: Physical** | Independent DB per tenant | Enterprise |

### 52.2. Cross-Tenant Governance

- Mandate RLS (Row Level Security) to prevent content/media leakage between tenants
- Record admin cross-tenant access in audit logs

---

## Part LIII: CMS Disaster Recovery & Backup

### 53.1. Content BCP

- **Rule 34.79**: Develop a CMS disaster recovery plan targeting the following RTO/RPO

| Item | Target |
|:---|:---|
| **RPO (Recovery Point Objective)** | Within 1 hour |
| **RTO (Recovery Time Objective)** | Within 4 hours |
| **Backup Frequency** | Daily full backup + hourly incremental |

### 53.2. SaaS CMS Availability

- Verify SaaS CMS SLA and require 99.9% or above
- Design fallback strategy (continued delivery from cache) for SaaS CMS outages

---

## Part LIV: CMS Regulatory Compliance (DORA/EU AI Act/DSA)

### 54.1. Regulatory Mapping

- **Rule 34.80**: Understand and maintain compliance with major CMS-related regulations

| Regulation | CMS Requirements |
|:---|:---|
| **GDPR / APPI** | PII management, consent management, right to deletion, cross-border transfer |
| **EU AI Act** | AI-generated content labeling, transparency obligations |
| **DSA (Digital Services Act)** | UGC moderation obligations, transparency reports |
| **DORA** | ICT risk management, incident reporting (financial CMS) |
| **EAA** | CMS admin UI accessibility obligations |

### 54.2. Compliance Audit

- **Rule 34.81**: Audit CMS-related compliance status semi-annually and conduct gap analysis

---

## Part LV: GEO (Generative Engine Optimization)

### 55.1. GEO Strategy

- **Rule 34.82**: Implement GEO measures to maximize content citation from AI search engines (Gemini / SearchGPT / Perplexity, etc.)

| Measure | Description |
|:---|:---|
| **Structured Content** | Use Q&A format, definition lists, bullet points |
| **LLMs.txt** | Deploy AI-oriented sitemap |
| **Citation-Friendliness** | Clearly state statistics and specific facts |
| **Schema.org** | Comprehensive JSON-LD markup application |
| **Authoritativeness** | Clearly display author info, references, last update date |

### 55.2. AI Search Analytics

- Measure AI search-originated traffic and conduct comparative analysis with traditional SEO

---

## Part LVI: CMS Green IT & Sustainability

### 56.1. Sustainable Content Delivery

- **Rule 34.83**: Recommend designs conscious of content delivery carbon footprint
- **Image Optimization**: Eliminate unnecessary high-resolution images, adopt WebP/AVIF
- **Cache Maximization**: Target CDN cache hit rate of 90%+ to minimize origin requests
- **Unused Content Deletion**: Periodically delete archived content/media with no references to optimize storage

---

## Part LVII: CMS Observability & FinOps

### 57.1. CMS Metrics

| Metric | Description | Target |
|:---|:---|:---|
| **API Response Time** | Content Delivery API response time | p95 < 200ms |
| **Cache Hit Rate** | CDN cache hit rate | > 90% |
| **Content Freshness** | Delay from content update to reflection | < 60s |
| **Webhook Delivery Rate** | Webhook delivery success rate | > 99.5% |
| **Editor Satisfaction** | Editor CMS operation satisfaction | NPS > 30 |
| **Stale Content Ratio** | Ratio of content not updated for 180+ days | < 20% |

### 57.2. CMS FinOps

- **Rule 34.84**: Monitor CMS API call count, storage usage, and bandwidth monthly for continuous cost optimization
- **SaaS CMS**: Set usage rate alerts against plan limits (Warning at 80%, Critical at 90%)
- **Cost Reduction via Image Optimization**: Store only one original per image with CDN Edge transformation

---

## Part LVIII: Maturity Model (5 Levels)

### 58.1. CMS Maturity Model

| Level | Name | Characteristics |
|:---|:---|:---|
| **L1: Initial** | Static & Manual | HTML hardcoding, manual deployment |
| **L2: Managed** | CMS Adoption | Basic CMS operations, manual approval |
| **L3: Defined** | Structured | Content modeling, API-First, ISR, approval workflows |
| **L4: Optimized** | Automated | AI assistance, auto SEO, personalization, On-demand Revalidation |
| **L5: Autonomous** | Intelligent | Agentic CMS, AI autonomous content optimization, full Composable DXP integration, MCP Server integration |

---

## Part LIX: Anti-Pattern Collection (30 Items)

### 59.1. Anti-Pattern Collection

| # | Anti-Pattern | Correct Approach |
|:---|:---|:---|
| 1 | Writing raw HTML and rendering with `dangerouslySetInnerHTML` | Triple Write Protocol + sanitization |
| 2 | Same cache TTL for all content | Cache Tiering Protocol |
| 3 | Exposing CMS admin UI to public network | IP restriction + SSO + MFA |
| 4 | Using only rich text fields without models | Structured content modeling |
| 5 | Placing images directly in public folder | Unified media library |
| 6 | Writing origin URL directly in `<img src>` | CDN Delivery Gateway |
| 7 | Exposing CMS API key to client | Server-side Only |
| 8 | Publishing preview without authentication | Preview Gate Protocol |
| 9 | Admin completing publication alone | Approval gate + Self-Publish Ban |
| 10 | No revision management | Content Revision Protocol |
| 11 | Branching CMS types with switch statements | ComponentRegistry |
| 12 | Allowing all HTML elements in editor | Strict Schema |
| 13 | Soft 404 (empty page with 200) | 410 Gone / 404 Not Found |
| 14 | Storing unstructured HTML blobs | JSON format as SSOT |
| 15 | Using React Portal in NodeView | Inline rendering |
| 16 | Publishing AI-generated content without labels | AI generation label mandate |
| 17 | Rendering all content with CSR only | SSG/ISR/SSR |
| 18 | Processing UGC images server-side | Client-side preprocessing |
| 19 | Hardcoding translations in code | CMS multilingual fields / TMS |
| 20 | Implementing business logic in CMS | Separate to application layer |
| 21 | No content owner assigned | content_owner mandate |
| 22 | Direct dependency on CMS-specific SDK | Content Abstraction Layer |
| 23 | No content freshness management | Review date auto-notification |
| 24 | Granting publish permissions to AI Agent | Human approval required at L3+ |
| 25 | No webhook signature verification | HMAC signature mandatory |
| 26 | No content provenance metadata | Provenance tracking metadata mandate |
| 27 | No conflict resolution for simultaneous editing | Locking / CRDT |
| 28 | Manual content schema management | Content as Code + Git |
| 29 | Disconnected DAM and CMS operations | DAM-CMS integrated pipeline |
| 30 | No disaster recovery plan | BCP development + regular DR drills |
| 31 | Publishing AI-generated media without C2PA | C2PA Content Credentials embedding |
| 32 | Proprietary event format non-compliant with CloudEvents | CloudEvents v1.0 compliance |
| 33 | No content performance measurement | Content Intelligence dashboard |
| 34 | Adding editor features without scientific evidence | Editor NPS/SUS measurement-driven |
| 35 | Flat content structure without Content Graph | Knowledge Graph-based entity design |
| 36 | CMS content delivery ignoring CWV / INP | Performance Budget + INP optimization |
| 37 | Manual CMS migration without ETL pipeline | Structured Content ETL + delta sync |
| 38 | No type definitions in CMS SDK | TypeScript SDK auto-generation + type-safe API |
| 39 | No offline content strategy for mobile apps | Delta Sync + SQLite local cache |
| 40 | No API rate limiting design | Tiered Rate Limiting + Fair Queuing |

---

## Part LX: Future Outlook & CMS Implementation Checklist

### 60.1. CMS Future Outlook (2026-2030)

| Trend | Description |
|:---|:---|
| **Agentic Content Management** | AI Agents autonomously operate CMS, automating content planning → creation → optimization → archival |
| **Composable DXP Maturation** | Best-of-breed service integration evolves further, platformless CMS becomes mainstream |
| **Content Intelligence** | AI performs real-time content effectiveness analysis, prediction, and optimization |
| **Edge-Native CMS** | Leverage Edge KV/Durable Objects for origin-less content delivery |
| **Content Graph** | Manage content relationships via Knowledge Graph, improving AI recommendation accuracy |
| **Spatial Content** | 3D content management for AR/VR/Spatial Computing |
| **Voice-First Content** | Structured content design for voice assistants |
| **Decentralized Content** | Blockchain-based content authentication and copyright management |
| **C2PA Standardization** | Content provenance becomes industry standard, CMS native integration advances |

### 60.2. CMS Implementation Checklist

| # | Check Item | Reference |
|:---|:---|:---|
| 1 | API-First design completed | Part I-II |
| 2 | Content model schema definition | Part IV-VII |
| 3 | Triple Write Protocol implementation | Part XIX |
| 4 | CDN Delivery Gateway setup | Part XII, XVI |
| 5 | RBAC + MFA setup | Part XXXVI |
| 6 | Webhook + HMAC signature setup | Part X |
| 7 | Approval workflow setup | Part XXI-XXII |
| 8 | ISR/On-demand Revalidation setup | Part XV, XVII |
| 9 | SEO preview panel implementation | Part XXX |
| 10 | AI-generated content labeling | Part XXXIV |
| 11 | Accessibility compliance (WCAG 2.2 AA) | Part XXXIX |
| 12 | Content BCP development | Part LIII |
| 13 | LLMs.txt deployment | Part XXXII |
| 14 | Monitoring & alert setup | Part LVII |
| 15 | Compliance audit plan | Part LIV |

---

## Part LXI: C2PA Content Provenance & Content Credentials

### 61.1. C2PA Integration Architecture

- **Rule 34.89**: Embed **C2PA (Coalition for Content Provenance and Authenticity)** Content Credentials in CMS-delivered media to cryptographically prove content provenance, edit history, and AI involvement

| Component | Role |
|:---|:---|
| **CMS C2PA Signer** | Generate and sign C2PA manifests at content publication |
| **Verification API** | API for verifying and displaying Content Credentials on frontend |
| **Trust List** | Management of trusted signer lists (CA chain) |
| **Manifest Store** | Persistent storage of C2PA manifests (for tamper detection) |

### 61.2. Integration into CMS Publishing Flow

- Automatically generate C2PA manifests and embed them in images, videos, and PDFs at publication
- Mandate `c2pa.ai_generated: true` assertion for AI-generated/AI-assisted content
- **Verification UI**: Implement Content Credentials display component (cr-badge) on frontend

---

## Part LXII: AI-Native Visual Editor & No-Code Content Modeling

### 62.1. AI-Native Visual Editor

- **Rule 34.90**: Provide an **AI-Native Visual Editor** for non-technical editors, enabling WYSIWYG editing while maintaining structured data integrity
- **Structured Data Preservation**: Visual Editor operates directly on structured JSON, not rich text HTML
- **AI Assist**: AI directly assists with image selection, layout suggestions, and text proofreading within the editor
- **Live Preview**: Display edit content in real-time preview on the frontend environment

### 62.2. No-Code Content Modeling

- **Rule 34.91**: Provide **No-Code Content Modeling** tools that enable content model definition via GUI, allowing non-developers to safely add fields and configure validation
- **Schema Versioning**: Behind GUI operations, Content as Code (§XLIII) schema files are auto-generated and Git-managed
- **Guardrails**: Apply GUI-level warnings and approval flows for destructive changes (field deletion, type changes)

---

## Part LXIII: Content Ops & Content Operations Team

### 63.1. Content Ops Maturity Model

- **Rule 34.92**: Define Content Ops as an organizational capability and progressively mature it

| Level | Name | Characteristics |
|:---|:---|:---|
| **L1** | Ad-Hoc | Individual-dependent, no processes |
| **L2** | Reactive | Basic workflow established, manual operations |
| **L3** | Proactive | KPI measurement, content calendar, regular reviews |
| **L4** | Optimized | AI assistance, automated pipelines, personalization |
| **L5** | Autonomous | Agentic operations, Content Intelligence-driven |

### 63.2. Content Operations Team Structure

| Role | Responsibilities |
|:---|:---|
| **Content Strategist** | Content strategy development, KPI design, governance |
| **Content Designer** | Content Design System management, structural design |
| **Content Editor** | Content creation, editing, quality management |
| **Content Engineer** | CMS configuration, schema design, automation |
| **Content Analyst** | Performance analysis, A/B testing, improvement proposals |

---

## Part LXIV: Headless Commerce Integration

### 64.1. Commerce Content Bridge

- **Rule 34.93**: Integrate Headless CMS with Commerce Platforms (Shopify / commercetools / Saleor, etc.) to realize **content-driven commerce**

| Integration Pattern | Description | Recommended Use Case |
|:---|:---|:---|
| **Content-Led** | CMS-led PDP/PLP construction, product data via API | Media commerce |
| **Commerce-Led** | Commerce Platform-led, CMS for supplementary content | Large-scale EC |
| **Unified** | Unify both via BFF, deliver through single API | Most flexible |

### 64.2. PDP/PLP Content Design

- **Rule 34.94**: PDP (Product Detail Page) content MUST clearly separate CMS-managed **editorial content** from Commerce Platform **product data**
- **Inventory Linking**: Execute content switching based on inventory status (alternative display when out of stock) via Edge Functions
- **Price Display**: Retrieve price information directly from Commerce Platform API; do not cache in CMS (freshness guarantee)

---

## Part LXV: Edge-Native CMS & Edge Delivery Architecture

### 65.1. Edge-First CMS Design

- **Rule 34.95**: Design content delivery Edge-First, minimizing dependency on origin servers

| Edge Technology | Use Case |
|:---|:---|
| **Edge KV** | High-speed reads for content metadata, settings, Feature Flags |
| **Durable Objects** | Real-time editing sessions, presence management |
| **Edge Functions** | ISR/On-demand Revalidation, personalization decisions |
| **Edge Cache** | Image transformation, HTML fragment caching |

### 65.2. Origin-Less Delivery

- Write directly to Edge KV at content publication; reads do not go through origin
- **Fallback**: Fall back to origin API only on Edge KV miss, backfilling results to Edge KV
- **Global Consistency**: Accept eventual consistency, guaranteeing propagation delay from write to read within 5 seconds

---

## Part LXVI: Content Intelligence & Content Analytics

### 66.1. Content Intelligence Dashboard

- **Rule 34.96**: Quantitatively measure CMS content performance and implement data-driven content improvements

| Metric | Description | Data Source |
|:---|:---|:---|
| **Content ROI** | Content creation cost vs. business outcomes | CMS + Analytics |
| **Engagement Score** | Time on page, scroll depth, CTR | Web Analytics |
| **Content Decay** | Traffic decline rate (time series) | Search Console |
| **Conversion Attribution** | Content-attributed conversion contribution | Analytics + CRM |
| **SEO Visibility** | Search rankings, impressions, CTR | Search Console |

### 66.2. Predictive Content Optimization

- **Rule 34.97**: Leverage AI prediction models to proactively detect content performance decline and recommend refreshes
- **Content Decay Alert**: Detect decline trends from 90-day traffic trends and issue automatic alerts
- **Optimal Publishing Timing**: Estimate optimal publication day/time from historical engagement data

---

## Part LXVII: Content Graph & Knowledge Graph

### 67.1. Content Graph Design

- **Rule 34.98**: Explicitly model content relationships as a **Content Graph**, expressing semantic relationships beyond simple category/tag classification

| Relationship Type | Description | Example |
|:---|:---|:---|
| **is_about** | Content subject | Article → Topic |
| **references** | Citation/reference | Article → Article |
| **prerequisite** | Prerequisite knowledge | Guide → Tutorial |
| **supersedes** | Update/replacement | New Article → Old Article |
| **part_of** | Membership/component | Chapter → Series |

### 67.2. Knowledge Graph Integration

- Register content entities (people, organizations, products, concepts) in Knowledge Graph to make implicit content relationships machine-readable
- **Ontology Design**: Define domain-specific ontologies (schema.org extensions) to type-safely manage entity relationship types
- **AI Utilization**: Leverage Content Graph for recommendations, related content presentation, and knowledge base construction

---

## Part LXVIII: Event-Driven Content Architecture

### 68.1. Event Mesh Design

- **Rule 34.99**: For large-scale content systems, adopt **Event Mesh** architecture to loosely couple CMS, search, analytics, and notification services via asynchronous events

```
┌─────────┐    CloudEvents    ┌──────────────┐
│   CMS   │ ──────────────→  │  Event Mesh  │
└─────────┘                   │  (Pub/Sub)   │
                              └──────┬───────┘
                    ┌────────────┬───┴───┬────────────┐
                    ▼            ▼       ▼            ▼
              ┌──────────┐ ┌────────┐ ┌─────┐ ┌───────────┐
              │ Search   │ │ CDN    │ │ ISR │ │ Analytics │
              │ Index    │ │ Purge  │ │     │ │           │
              └──────────┘ └────────┘ └─────┘ └───────────┘
```

### 68.2. Event Design Principles

- **Single Writer**: Limit each event type's publisher to a single service
- **Event Sourcing**: Persist content change history as event logs, enabling state reconstruction at any point in time
- **Saga Pattern**: Guarantee consistency for cross-service workflows (publish → translate → notify → analyze) using the Saga pattern

---

## Part LXIX: Content Localization Deep Dive (MTPE / MQM)

### 69.1. MTPE (Machine Translation Post-Editing) Workflow

- **Rule 34.100**: Introduce **MTPE** workflows for AI translation quality management, optimizing the balance between translation quality and efficiency

| Tier | Quality Level | Use Case | MTPE Process |
|:---|:---|:---|:---|
| **Tier 1: Raw MT** | Low | Internal reference materials | Machine translation only |
| **Tier 2: Light PE** | Medium | Blog, SNS | Fluency and grammar check |
| **Tier 3: Full PE** | High | Marketing | Complete post-editing |
| **Tier 4: Human** | Highest | Legal documents, brand | Human translation + double check |

### 69.2. MQM (Multidimensional Quality Metrics)

- Quantitatively evaluate translation quality using the MQM framework
- **Evaluation Axes**: Accuracy, Fluency, Terminology, Style
- **Threshold Setting**: Require MQM score of 95+ for publication at Tier 2 and above
- **Cross-Reference**: `800_internationalization.md` (Global Expansion), `802_language_protocol.md` (Language Protocol)

---

## Part LXX: Content Design System & Token Management

### 70.1. Content Design System

- Build a **Content Design System** that unifies content style, tone, and structure to guarantee brand consistency

| Component | Description |
|:---|:---|
| **Voice & Tone Guide** | Brand voice definition, situational tone guidelines |
| **Content Patterns** | Collection of reusable content structure patterns |
| **Vocabulary** | Terminology unification dictionary, prohibited terms list |
| **Content Templates** | Entry templates per content type |
| **Visual Content Rules** | Image styles, thumbnail specs, color rules |

### 70.2. Content Token Management

- Similar to design tokens in UI Design Systems, define **content tokens** (maximum heading character count, recommended summary length, image aspect ratios, etc.) in JSON, referenced by both CMS Validation and frontend
- **Cross-Reference**: `200_design_ux.md` (Design System)

---

## Part LXXI: CMS Performance Budget & Core Web Vitals

### 71.1. CMS Content Performance Budget

- **Rule 34.101**: Set **performance budgets** for content pages delivered from CMS, enforced on both CMS and frontend sides

| Metric | Budget | Measurement Tool |
|:---|:---|:---|
| **LCP (Largest Contentful Paint)** | ≤ 2.5s | Lighthouse / CrUX |
| **INP (Interaction to Next Paint)** | ≤ 200ms | Web Vitals / CrUX |
| **CLS (Cumulative Layout Shift)** | ≤ 0.1 | Lighthouse / CrUX |
| **TTFB (Time to First Byte)** | ≤ 800ms | WebPageTest |
| **Total Page Weight** | ≤ 1.5MB | Lighthouse |
| **Image Weight per Page** | ≤ 500KB | Custom CI |

### 71.2. CMS-Induced INP Degradation Prevention

- **Rule 34.102**: Mandate the following measures to prevent CMS-derived content rendering from degrading INP (Interaction to Next Paint)

| Measure | Description |
|:---|:---|
| **Long Task Avoidance** | Limit CMS data parsing/transformation to under 50ms. If exceeded, split using `requestIdleCallback` or `scheduler.yield()` |
| **Hydration Optimization** | CMS content areas MUST use Partial Hydration / Island Architecture to hydrate only necessary sections |
| **Third-Party Isolation** | CMS-managed embedded scripts (ads, widgets) MUST be isolated from main thread via web worker or `<iframe sandbox>` |
| **Lazy Rendering** | Below-the-fold sections MUST use Intersection Observer for deferred rendering |

### 71.3. CMS Image CWV Optimization

- **Rule 34.103**: Mandate settings that minimize CWV score impact for images delivered from CMS media library
  - LCP candidate images: `priority` / `fetchpriority="high"` + responsive `srcset` + `sizes` attributes mandatory
  - Non-LCP images: `loading="lazy"` + `decoding="async"` mandatory
  - All images: Explicitly declare `width` / `height` attributes to secure aspect ratio for CLS prevention
  - **Format**: Auto-deliver WebP (default) / AVIF (supported browsers) via CDN Edge transformation
- **Cross-Reference**: `340_web_frontend.md` (Performance Budget)

---

## Part LXXII: Structured Content Migration & ETL

### 72.1. Content ETL Pipeline

- **Rule 34.104**: Design CMS content migration as an **ETL (Extract → Transform → Load) pipeline**, not relying solely on manual copy or bulk import

| Phase | Content | Tool Examples |
|:---|:---|:---|
| **Extract** | Extract content from source CMS via API or export | REST/GraphQL API, DB Dump |
| **Transform** | Schema mapping, field conversion, rich text normalization | Node.js Script, Apache Airflow |
| **Load** | Write to target CMS via Management API | CMS SDK, Bulk Import API |

### 72.2. Schema Mapping

- **Rule 34.105**: Define content model differences between source and target CMS in a **schema mapping table**, managing transformation rules as code

| Mapping Item | Description |
|:---|:---|
| **Field Name Conversion** | `body` → `content`, `hero_image` → `featured_media`, etc. |
| **Type Conversion** | Rich Text → JSON, Markdown → HTML, etc. |
| **Reference Resolution** | Build old ID → new ID mapping table |
| **Default Values** | Define default values for target CMS required fields |
| **Validation Rules** | Post-migration data validation (Schema Validation) |

### 72.3. Delta Sync

- **Rule 34.106**: For large-scale migrations, execute **Delta Sync** after initial full import to reflect content updates during the migration period
  - Retrieve diffs based on source CMS `updated_at` timestamps
  - During parallel operation, use **unidirectional sync (Source → Target)** as the principle, not bidirectional
  - **Migration Completion Criteria**: Determine migration completion by matching content count and hash between source and target

### 72.4. Migration Risk Management

- **Rule 34.107**: CMS migration is a high-risk operation; mandate the following safeguards
  - **Dry Run**: Conduct full rehearsal in staging environment before production migration
  - **Rollback Plan**: Document rollback procedures in advance for migration failures
  - **Content Freeze**: Freeze content editing on source CMS during production migration execution
  - **SEO Monitoring**: Monitor Search Console index coverage daily for 30 days post-migration

---

## Part LXXIII: CMS SDK & Developer Experience (DX)

### 73.1. TypeScript SDK Design

- **Rule 34.108**: Provide a **TypeScript SDK** for Headless CMS API to guarantee type-safe content access

| Design Principle | Description |
|:---|:---|
| **Type Auto-Generation** | Auto-generate TypeScript type definitions from CMS schema definitions (`codegen`) |
| **Null Safety** | Express optional fields as `T | undefined` in types |
| **Builder Pattern** | Query builders construct filters, sorts, and pagination type-safely via method chaining |
| **Tree-Shakable** | Provide as ESM so unused API functions are not included in bundles |
| **Error Typing** | Return API errors as typed error types (`CmsApiError`), enabling `instanceof` branching |

```typescript
// ✅ Type-safe CMS query example
const articles = await cms.getEntries<Article>({
  contentType: 'article',
  where: { status: 'published', category: 'tech' },
  orderBy: 'publishedAt',
  limit: 10,
  include: ['author', 'tags'],
});
// articles is inferred as Article[] type
```

### 73.2. Developer Portal & Sandbox

- **Rule 34.109**: Provide the following for developers using the CMS API

| Offering | Description |
|:---|:---|
| **Interactive API Playground** | Browser-based sandbox for API testing (GraphiQL / Swagger UI) |
| **Quick Start Guide** | Tutorial completing content retrieval within 5 minutes |
| **Sample Projects** | Starter templates for major frameworks (Next.js, Nuxt, Astro, etc.) |
| **Changelog** | API versioning and advance notice of breaking changes (Deprecation Notice 90 days prior) |
| **Status Page** | Public page showing API operational status and incident history |

### 73.3. CMS CLI Tools

- **Rule 34.110**: Enable CMS environment management and content operations via CLI
  - `cms pull` — Export production content models locally
  - `cms push` — Apply local schema changes to environment
  - `cms diff` — Display schema differences between environments
  - `cms seed` — Insert development sample data
  - `cms migrate` — Apply schema migrations
- **Cross-Reference**: `300_engineering_standards.md` (CLI Design Principles)

---

## Part LXXIV: Headless CMS for Mobile (App Content)

### 74.1. Mobile App Content Delivery

- **Rule 34.111**: Mandate designs meeting the following requirements for mobile app CMS content delivery, which differ from web

| Requirement | Description |
|:---|:---|
| **Offline First** | Enable browsing cached content during network disconnection |
| **Delta Sync** | Retrieve only changes since last sync to minimize bandwidth consumption |
| **Version Compatibility** | Maintain API versioning strategy supporting older app versions |
| **Push Notification Integration** | Auto-send push notifications triggered by content publication |
| **Deep Link Support** | Map CMS content to in-app screens 1:1 |

### 74.2. Mobile Local Cache Strategy

- **Rule 34.112**: Design CMS content caching in mobile apps at the following tiers

| Tier | Implementation | Use Case |
|:---|:---|:---|
| **Memory Cache** | In-Memory Map / LRU | Active screen content |
| **Disk Cache** | SQLite / Realm | Persistence for offline browsing |
| **Image Cache** | Coil (Android) / Kingfisher (iOS) | Local caching of media assets |

- **TTL Management**: Set cache TTL per content type — news is short (5 min), help articles are long (24 hours), etc.
- **Cache Invalidation**: Send silent push notifications to trigger cache invalidation for specific content

### 74.3. Mobile API Optimization

- **Rule 34.113**: Apply the following optimizations for mobile-oriented APIs
  - **Field Selection**: `fields` parameter returning only needed fields (Over-Fetching prevention)
  - **Response Compression**: Brotli / gzip compression mandatory
  - **Payload Size Limit**: Target 500KB or less per response
  - **Batch API**: Provide Batch API consolidating multiple content retrievals into one request

---

## Part LXXV: Webhook Orchestration & Saga Pattern Deep Dive

### 75.1. Webhook Orchestration Design

- **Rule 34.114**: Design multiple webhook actions linked to content publication as **orchestration**, explicitly defining dependencies, execution order, and error handling

```
Content Published Event
│
├─[1] Parallel:
│   ├── ISR Revalidation
│   ├── CDN Cache Purge
│   └── Analytics Event
│
├─[2] Sequential (after 1 completes):
│   ├── Search Index Update → [3] SEO Validation
│   └── RSS/Sitemap Regeneration
│
└─[4] Conditional:
    ├── (if multilingual) → Translation Queue
    └── (if featured) → Social Media Auto-Share
```

### 75.2. Dead Letter Queue (DLQ) Operations

- **Rule 34.115**: Design a **Dead Letter Queue** for failed webhook deliveries, enabling manual/automatic retry

| Design Item | Specification |
|:---|:---|
| **Retry Strategy** | Exponential Backoff (1s → 2s → 4s → 8s → 16s), max 5 attempts |
| **DLQ Retention** | 7-day retention. Archive with admin notification after expiry |
| **Replay Function** | Enable manual replay of selected events from DLQ |
| **Alerts** | Immediate alert when DLQ backlog exceeds threshold (50 items) |
| **Idempotency** | All webhook handlers MUST be designed as idempotent |

### 75.3. Saga Pattern Deep Dive

- **Rule 34.116**: Guarantee consistency across multiple services linked to content publication using the **Saga Pattern**
  - **Orchestration Saga**: Coordinator sequentially executes each step; on failure, executes Compensating Transactions
  - **Example**: Publish → Start Translation → Translation Fails → Revert publish status to "Translation Pending"
  - **Timeout**: Set maximum execution time for each step; execute compensating transaction on timeout
- **Cross-Reference**: `300_engineering_standards.md` (Distributed Transaction Design), Part LXVIII (Event-Driven Architecture)

---

## Part LXXVI: Content Compliance Automation (PII/GDPR/DSA)

### 76.1. Content PII Auto-Detection

- **Rule 34.117**: Implement **automatic PII (Personally Identifiable Information) detection** for content submitted to CMS

| Detection Target | Method | Response |
|:---|:---|:---|
| **Phone Numbers** | Regex + NLP | Display warning at submission |
| **Email Addresses** | Regex | Auto-masking suggestion |
| **Physical Addresses** | NER (Named Entity Recognition) | Flag during review |
| **National ID / SSN** | Pattern matching | Immediate block + admin notification |
| **Facial Images** | AI face detection | Initiate consent verification flow |

### 76.2. GDPR Right to Erasure Compliance

- **Rule 34.118**: Comply with GDPR Article 17 (Right to be Forgotten) by implementing a workflow to **systematically delete** data related to a specific individual from CMS content
  - **Scan**: Cross-search all content by subject's name and email address
  - **Confirm**: Present list of content to be deleted to admin for approval
  - **Delete**: Remove target data from content body, metadata, media (including facial images), and revision history
  - **Audit Trail**: Maintain audit log of deletion completion (without retaining the deleted content itself)
- **Cross-Reference**: `601_data_governance.md` (GDPR Compliance)

### 76.3. DSA Transparency Report Automation

- **Rule 34.119**: Auto-collect data required for EU DSA (Digital Services Act) content moderation transparency reports
  - Moderation case count (by category, by response type)
  - Average response time (detection → unpublish)
  - Appeal count and restoration rate
  - AI auto-judgment accuracy (False Positive / False Negative rate)
- **Cross-Reference**: `601_data_governance.md` (DSA Compliance), Part XXXVIII (Content Moderation)

---

## Part LXXVII: CMS API Rate Limiting & Quota Management

### 77.1. Tiered Rate Limiting

- **Rule 34.120**: Design CMS API Rate Limiting at the following tiers

| Tier | Limit | Applied To |
|:---|:---|:---|
| **Global** | 10,000 req/min | Entire API |
| **Per Tenant** | 2,000 req/min | Multi-tenant environments |
| **Per API Key** | 500 req/min | Per application |
| **Per Endpoint** | 100 req/min | High-load endpoints (search, GraphQL) |
| **Per User** | 60 req/min | Admin UI operations |

### 77.2. Quota Management

- **Rule 34.121**: Manage API quotas for SaaS CMS usage with the following mechanisms
  - **Usage Dashboard**: Visualize real-time API usage (call count, bandwidth, storage)
  - **Alert Thresholds**: Warning at 80% utilization, Critical alert at 90%
  - **Burst Control**: Smooth burst traffic using Token Bucket Algorithm
  - **Fair Queuing**: Fairly distribute API bandwidth across multiple clients

### 77.3. Rate Limit Response Design

- **Rule 34.122**: Design HTTP responses for rate limit exceedance with the following specifications
  - Status code: `429 Too Many Requests`
  - `Retry-After` header: Return next available request time (seconds or HTTP-date)
  - `X-RateLimit-Limit` / `X-RateLimit-Remaining` / `X-RateLimit-Reset` headers to communicate current limit status
  - **Graceful Degradation**: Exempt CDN-cacheable GET requests from rate limiting

---

## Part LXXVIII: CDN Deep Dive (Stale-While-Revalidate / ESI)

### 78.1. Stale-While-Revalidate Strategy

- **Rule 34.123**: Apply the **Stale-While-Revalidate (SWR)** pattern for CDN delivery of CMS content, serving stale content during cache updates to maintain user experience

```
Cache-Control: public, max-age=60, stale-while-revalidate=3600, stale-if-error=86400
```

| Directive | Purpose |
|:---|:---|
| `max-age=60` | Consider cache fresh for 60 seconds |
| `stale-while-revalidate=3600` | Serve stale cache for 1 hour after max-age while updating in background |
| `stale-if-error=86400` | Continue serving stale cache for 24 hours during origin failures |

### 78.2. Edge Side Includes (ESI)

- **Rule 34.124**: Separate dynamic content fragments within pages (personalized headers, user menus, etc.) using ESI to maximize static content cache efficiency
  - **Template**: Use `<esi:include src="/api/user-header" />` for deferred page fragment retrieval
  - **TTL Separation**: Long TTL for static content (article body), short TTL or no-cache for dynamic fragments
  - **Fallback**: Define default display for ESI fetch failures using `<esi:try>` / `<esi:except>`

### 78.3. CDN Shielding & Cache Warming

- **Rule 34.125**: Design origin protection and cache efficiency for high-traffic scenarios
  - **CDN Shielding**: Place one PoP as a shield in front of origin; other PoPs access origin through the shield
  - **Cache Warming**: Issue prefetch requests to all PoPs immediately after content publication to prevent origin stampede from cache misses
  - **Request Coalescing**: Enable CDN setting that collapses concurrent requests to the same URL into a single origin request

---

## Part LXXIX: CMS Monorepo & Multi-Site Architecture

### 79.1. Multi-Site Design

- **Rule 34.126**: When managing multiple sites/brands with a single CMS instance, select from the following architecture patterns

| Pattern | Description | Recommended Use Case |
|:---|:---|:---|
| **Shared Model** | Share content model across all sites | Multi-region sites with unified branding |
| **Per-Site Model** | Define content model independently per site | Multi-brand across different industries |
| **Hybrid** | Shared models (header, footer, FAQ) + site-specific models | Most flexible |

### 79.2. Content Sharing & Separation

- **Rule 34.127**: Content sharing and separation rules for multi-site environments
  - **Shared Content**: Reference company overview, privacy policy, etc. as "Global Content" across all sites (Single Source of Truth)
  - **Site-Specific Content**: Separate each site's exclusive content with `site_id` field, filter via API queries
  - **Override**: Provide mechanism to override portions of global content for specific sites (similar to Locale per Site)

### 79.3. Monorepo Structure

- **Rule 34.128**: Recommended structure when managing multiple site frontends in a single Monorepo

```
monorepo/
├── packages/
│   ├── cms-client/          # CMS SDK (shared)
│   ├── shared-components/   # Shared UI components
│   └── content-types/       # CMS schema type definitions (codegen)
├── apps/
│   ├── site-a/              # Site A (Next.js)
│   ├── site-b/              # Site B (Next.js)
│   └── site-c/              # Site C (Astro)
└── turbo.json               # Build pipeline definition
```

- **Dependencies**: `cms-client` and `content-types` are shared across all sites; CMS SDK updates auto-propagate to all sites
- **Cross-Reference**: `300_engineering_standards.md` (Monorepo Management)

---

## Part LXXX: CMS Developer Portal & API Documentation

### 80.1. API Documentation Auto-Generation

- **Rule 34.129**: **Auto-generate** CMS API documentation from schema definitions to physically prevent implementation-documentation drift

| API Format | Documentation Format | Generation Tool Examples |
|:---|:---|:---|
| **REST** | OpenAPI 3.1 Specification | Swagger Codegen / Redocly |
| **GraphQL** | GraphQL Schema + Introspection | GraphiQL / Apollo Sandbox |
| **SDK Reference** | TypeDoc / Typedoc | TypeDoc (`tsdoc`) |

### 80.2. Interactive API Playground

- **Rule 34.130**: Provide a Playground for developers to test APIs in the browser
  - **Authentication**: Enable test API key issuance within the Playground (not production keys)
  - **Sample Data**: Prepare pre-seeded sample content in Sandbox mode
  - **Code Generation**: Auto-generate client code (cURL / JavaScript / Python, etc.) from Playground requests
  - **Version Switching**: Enable switching API versions to compare response differences

### 80.3. API Versioning Policy

- **Rule 34.131**: CMS API versioning MUST follow these policies

| Item | Policy |
|:---|:---|
| **Versioning Method** | URL path (`/v1/`, `/v2/`) or header (`X-API-Version`) |
| **Deprecation Notice** | 90 days prior notice for breaking changes |
| **Sunset Header** | Communicate planned deprecation date via `Sunset` header |
| **Support Period** | Minimum 12-month support for old versions |
| **Breaking Change Definition** | Field deletion, type changes, required field additions are breaking changes |

- **Cross-Reference**: `301_api_integration.md` (API Versioning)

---

## Appendix A: Quick Reference Index

| Task / Keyword | Reference |
|:---|:---|
| CMS Selection | Part III |
| MACH Certification | Part III (3.5) |
| Content Modeling | Part IV-VII |
| API Design (REST) | Part VIII |
| GraphQL / Federation | Part IX |
| Webhook / CloudEvents | Part X |
| Media Management | Part XI-XIII |
| DAM Integration | Part XIV |
| SSG/ISR/SSR | Part XV |
| CDN | Part XVI |
| Caching | Part XVII |
| Rich Text / Tiptap | Part XVIII-XX |
| Publishing Workflow | Part XXI-XXII |
| Scheduling | Part XXIII |
| Revision Management | Part XXIV |
| Preview | Part XXV-XXVI |
| HTTP Status / 404 | Part XXVII |
| Page Builder | Part XXVIII-XXIX |
| SEO / Schema.org | Part XXX-XXXI |
| AI Integration / RAG / MCP | Part XXXII-XXXV |
| A2A Protocol | Part XXXV (35.3) |
| Security / OWASP | Part XXXVI-XXXVII |
| C2PA / Content Credentials | Part XXXVII (37.2), LXI |
| Moderation / UGC | Part XXXVIII |
| Accessibility | Part XXXIX |
| Multilingual / Translation | Part XL |
| Personalization | Part XLI |
| Content Governance | Part XLII |
| Content as Code | Part XLIII |
| CMS Migration | Part XLIV |
| Content Federation | Part XLV |
| Real-Time Collaboration | Part XLVI |
| A/B Testing | Part XLVII |
| Server-Driven UI | Part XLVIII |
| Editor Experience | Part XLIX |
| Testing Strategy | Part L |
| Pipeline Automation | Part LI |
| Multi-Tenant | Part LII |
| Disaster Recovery | Part LIII |
| Regulatory Compliance | Part LIV |
| GEO | Part LV |
| Green IT | Part LVI |
| Observability / FinOps | Part LVII |
| Maturity Model | Part LVIII |
| Anti-Patterns | Part LIX |
| AI Visual Editor | Part LXII |
| Content Ops | Part LXIII |
| Headless Commerce | Part LXIV |
| Edge CMS | Part LXV |
| Content Intelligence | Part LXVI |
| Content Graph | Part LXVII |
| Event-Driven | Part LXVIII |
| MTPE / MQM / Localization | Part LXIX |
| Content Design System | Part LXX |
| Performance Budget / CWV / INP | Part LXXI |
| Content Migration / ETL | Part LXXII |
| CMS SDK / DX | Part LXXIII |
| Mobile App Content | Part LXXIV |
| Webhook Orchestration / Saga / DLQ | Part LXXV |
| PII Detection / GDPR / DSA Automation | Part LXXVI |
| API Rate Limiting / Quota | Part LXXVII |
| CDN SWR / ESI / Shielding | Part LXXVIII |
| Multi-Site / Monorepo | Part LXXIX |
| Developer Portal / API Doc | Part LXXX |

---

## Appendix B: Cross-References

| Related Rule File | Reference Reason |
|:---|:---|
| [000_core_mindset.md](../en/000_core_mindset.md) | Headless First principles, existing functionality protection |
| [200_design_ux.md](../en/200_design_ux.md) | Accessibility, design system, Content Design System |
| [300_engineering_standards.md](../en/300_engineering_standards.md) | CI/CD, coding conventions, Event-Driven design |
| [340_web_frontend.md](../en/340_web_frontend.md) | Next.js, performance budgets, Edge Functions |
| [301_api_integration.md](../en/301_api_integration.md) | API design, error handling, CloudEvents |
| [320_supabase_architecture.md](../en/320_supabase_architecture.md) | DB design, RLS, Storage |
| [400_ai_engineering.md](../en/400_ai_engineering.md) | RAG, AI-generated content, EU AI Act, MCP, Agentic AI, A2A |
| [600_security_privacy.md](../en/600_security_privacy.md) | Zero Trust, authentication/authorization, OWASP, C2PA |
| [601_data_governance.md](../en/601_data_governance.md) | GDPR, privacy, DSA |
| [602_oss_compliance.md](../en/602_oss_compliance.md) | Dependency management |
| [800_internationalization.md](../en/800_internationalization.md) | i18n, multilingual, global expansion, MTPE |
| [802_language_protocol.md](../en/802_language_protocol.md) | CMS language governance |

