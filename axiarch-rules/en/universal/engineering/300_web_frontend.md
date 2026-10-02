# 33. Web Frontend Engineering

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-03-24 | Target: Next.js 16+ / React 19.2+ / TypeScript 5.x

> [!IMPORTANT]
> **Primary Directive**
> "The frontend is the sole point of contact between the user and the product, and compromise is not allowed."
> Achieve the trinity of Performance, Accessibility, and Security to guarantee the highest standard of user experience.
> In all web frontend implementation, strictly adhere to the priority: **Security > Performance > Accessibility > UX > Maintainability > Development Speed**.
> This document is the primary standard for all frontend design decisions.
> **54 Parts · ~340 Sections.**

> [!NOTE]
> **Scope Icons**
> Each Part's scope is indicated at the beginning:
> - 🌐 **Universal** — Framework-agnostic. Applies to any web technology stack
> - ⚛️ **React / Next.js** — Rules specific to React 19.2+ / Next.js 16+
> - 🔀 **Hybrid** — Contains universal principles, but code snippets are React/Next.js-oriented

---

## Table of Contents

| Part | Topic | Scope | Sections |
|------|-------|-------|----------|
| I | Philosophy & Core Principles | 🌐 | §1–§3 |
| II | Technology Stack Standards | ⚛️ | §4–§5, §301 |
| III | Next.js App Router Architecture | ⚛️ | §6–§11, §302 |
| IV | Server Components & Client Components | ⚛️ | §12–§15 |
| V | Edge Computing & Middleware | ⚛️ | §16–§18 |
| VI | UI Component Design | 🔀 | §19–§24 |
| VII | CSS Architecture | 🌐 | §25–§31, §303–§304 |
| VIII | Component Design Principles | 🔀 | §32–§36 |
| IX | React Hooks Best Practices | ⚛️ | §37–§42 |
| X | React 19 New APIs & React Compiler | ⚛️ | §43–§48, §305–§306, §305b–§305d |
| XI | Hydration & SSR Stability | ⚛️ | §49–§53 |
| XII | Form Design (React Hook Form + Zod) | 🔀 | §54–§60 |
| XIII | Advanced Form Patterns | 🔀 | §61–§66 |
| XIV | Input UX Optimization | 🌐 | §67–§71 |
| XV | Validation & Frontend Security | 🌐 | §72–§78 |
| XVI | State Management | 🔀 | §79–§83 |
| XVII | Data Fetching & Caching | ⚛️ | §84–§90 |
| XVIII | Performance Optimization | 🌐 | §91–§98, §307–§308 |
| XIX | Image, Font & Script Optimization | 🔀 | §99–§105 |
| XX | SEO & Metadata | 🌐 | §106–§112 |
| XXI | Technical SEO & GEO | 🌐 | §113–§117 |
| XXII | Accessibility (A11y) | 🌐 | §118–§124 |
| XXIII | PWA & Cross-Platform | 🌐 | §125–§129 |
| XXIV | Internationalization (i18n) | 🌐 | §130–§133 |
| XXV | Error Handling & Resilience | 🔀 | §134–§139 |
| XXVI | Server Actions & API Safety | ⚛️ | §140–§146 |
| XXVII | Data Visualization & Export | 🔀 | §147–§150 |
| XXVIII | AdTech & Marketing Engineering | 🌐 | §151–§155, §155b |
| XXIX | Testing Strategy | 🔀 | §156–§163 |
| XXX | Deployment & Infrastructure | 🔀 | §164–§169 |
| XXXI | Modern Web Platform APIs | 🌐 | §170–§179, §309–§310 |
| XXXII | Frontend Observability & RUM | 🌐 | §180–§185 |
| XXXIII | AI Integration & LLM Streaming UI | 🔀 | §186–§191 |
| XXXIV | Micro-Frontend & Module Federation | 🌐 | §192–§196 |
| XXXV | Web Worker & Off-Main-Thread | 🌐 | §197–§200 |
| XXXVI | Frontend Security Deep Dive | 🌐 | §201–§206, §203b, §206b |
| XXXVII | Frontend FinOps | 🌐 | §207–§209 |
| XXXVIII | Design System Integration | 🌐 | §210–§214 |
| XXXIX | Prohibited Anti-Patterns (30 Items) | 🌐 | §215–§244 |
| XL | Monorepo & Multi-App Strategy | 🔀 | §245–§249 |
| XLI | Real-Time Communication | 🌐 | §250–§253 |
| XLII | Authentication UI & Session Management | 🔀 | §254–§258 |
| XLIII | Animation & Motion Design | 🌐 | §259–§264 |
| XLIV | Responsive & Multi-Device | 🌐 | §265–§270 |
| XLV | E-Commerce Frontend | 🔀 | §271–§276 |
| XLVI | Frontend DevOps | 🌐 | §277–§282 |
| XLVII | Third-Party Script Management | 🌐 | §283–§287 |
| XLVIII | Sustainability & Green Frontend | 🌐 | §288–§292 |
| XLIX | Maturity Model & Future Outlook | 🌐 | §293–§300 |
| L | Reverse Lookup Index & Cross-Reference | — | Appendix |
| LI | Next.js 16 Migration & New Features | ⚛️ | §311–§316 |
| LII | GraphQL Frontend Architecture | 🌐 | §317–§320 |
| LIII | Type-Safe API Client & tRPC | 🔀 | §321–§324 |
| LIV | Frontend Data Quality & Schema Contract | 🌐 | §325–§330 |

---

## Part I: Philosophy & Core Principles 🌐

### §1. Primary Directive — Web Frontend Excellence

- **Rule 33.1**: The frontend is the business frontline. Performance degradation, accessibility deficiency, and security flaws directly and immediately impact business
- **Priority**: Security > Performance > Accessibility > UX > Maintainability > Development Speed
- **Zero Compromise**: Core Web Vitals (LCP ≤ 2.5s / INP ≤ 200ms / CLS ≤ 0.1) are "deployment gates," not mere "goals"
- **Latest Stable**: Always assume the latest stable version of frameworks and libraries. New usage of deprecated APIs is prohibited
- **Type Safety**: TypeScript Strict mode is mandatory. Usage of the `any` type is prohibited in principle
- **Privacy by Design**: Minimize user data collection and prioritize server-side processing

### §2. Architecture Principles

- **Rule 33.2**: Server First — Data fetching and business logic execute server-side. Only minimal interactive functionality on the client
- **Rule 33.3**: Composition over Inheritance — Design components through composition, not inheritance
- **Progressive Enhancement**: Aim for core content to be viewable even with JavaScript disabled
- **Defensive Programming**: Distrust all external input (API, URL Params, User Input) and enforce validation at boundaries
- **Fail Fast**: Missing environment variables or type inconsistencies should crash at startup, physically preventing inexplicable behavior in production

### §3. Universal Principles vs Framework-Specific

- **Rule 33.4**: This rule encompasses both "Universal Web Frontend Principles (🌐)" and "Next.js / React-Specific Best Practices (⚛️)." The scope icon at the beginning of each Part clarifies the applicable scope
- **Framework Agnostic (🌐)**: CWV optimization, CSS design, A11y, SEO, Security, etc. are universal rules independent of any specific framework
- **Framework Specific (⚛️)**: RSC, App Router, React Hooks, Server Actions, etc. are rules specific to Next.js/React
- **Hybrid (🔀)**: Principles are universal, but code snippets and specific implementations target React/Next.js
- **Cross-Reference**: `engineering/000_engineering_standards.md`, `design/000_design_ux.md`

> [!TIP]
> **Application Guide for Non-React Projects**
> While this rule primarily targets React/Next.js, 🌐-scoped Parts can be applied as-is to **any web frontend technology stack** (Vue/Nuxt, Svelte/SvelteKit, Astro, Vanilla JS, etc.).
> List of 🌐 Parts that can be independently used for non-React projects:
> Part I (Philosophy) / VII (CSS) / XIV (Input UX) / XV (Security) / XVIII (Performance) / XX–XXI (SEO/GEO) / XXII (A11y) / XXIII (PWA) / XXIV (i18n) / XXVIII (AdTech) / XXXI (Web Platform API) / XXXII (Observability) / XXXIV (Micro-Frontend) / XXXV (Web Worker) / XXXVI (Security Deep Dive) / XXXVII (FinOps) / XXXVIII (Design System) / XXXIX (Anti-Patterns) / XLI (Real-Time Communication) / XLIII (Animation) / XLIV (Responsive) / XLVII (Third-Party Scripts) / XLVIII (Sustainability) / XLIX (Maturity Model)

---

## Part II: Technology Stack Standards ⚛️

### §4. Recommended Technology Stack

| Layer | Standard Technology | Notes |
|:------|:-------------------|:------|
| **Framework** | Next.js 16+ (App Router) | Pages Router for legacy maintenance only |
| **UI Library** | React 19.2+ | Server Components standard |
| **Language** | TypeScript 5.x (Strict) | JavaScript is prohibited |
| **Styling** | Tailwind CSS 4+ / shadcn/ui | Design Token management required |
| **Forms** | React Hook Form + Zod | Schema-Driven Development |
| **State Management** | Server State: RSC / Client: Zustand or Jotai | Redux is prohibited for new projects |
| **Testing** | Vitest + Playwright + Storybook | Testing Trophy compliant |
| **Linting** | ESLint (Flat Config) + Prettier / Biome | Zero Warnings required |
| **Build** | Turbopack (Next.js 16 default) + FS Caching | Webpack for legacy maintenance only |
| **Package Manager** | pnpm recommended | Lockfile commit required |

### §5. Version Management & Dependencies

- **Rule 33.5**: Use Caret Range (`"react": "^19.1.0"`) for `package.json` dependencies to automatically acquire patch/minor updates. However, **lockfile commits are mandatory**
    - **Compiler-Adjacent Exact Pin (exception to Rule 33.5)**: Compiler-adjacent dependencies (compiler / transpiler / bundler plugin / AST transform and code generators, plus `@types/*`-style packages that share a type contract with them) MUST be exact-pinned instead of caret-ranged. A minor update can change emitted code or the type contract, so SemVer caret cannot be trusted. A major-only range on `@types/*` (e.g. `^19`) accepts any minor and is the highest-risk form; it is prohibited (MUST NOT)
    - Non-adjacent general libraries MAY keep caret ranges. Exact-pinning every dependency is over-tightening that blocks automated update PRs, so scope the rule by the "adjacent" test. Update exact-pinned dependencies in a separate commit to keep bisectability (SHOULD). The `package.json` specifier is the SSOT; the lockfile is auxiliary
- **Renovate/Dependabot**: Enable automated dependency update PRs and merge after a 21-day stabilization period
- **The Freshness Obligation**: External service SDKs (AI, Auth, Payment, etc.) evolve rapidly. Always use the latest version for new implementations, and "update first" as the primary resolution strategy when issues arise
- **Cross-Reference**: `security/200_oss_compliance.md`
- **Next.js 16 Breaking Changes**: Upgrading to Next.js 16 requires Node.js 20.9+ and TypeScript 5+. AMP support has been removed. `middleware.ts` is replaced by `proxy.ts` (see Part LI for details)
- **Major Upgrade Rendering Compatibility**: On a framework major upgrade, first confirm the compatible versions of libraries that depend on rendering internals (Portal, synchronous flush, NodeView-style APIs): rich text editors, DnD, virtual scrolling, etc. (MUST). Types, build and tests all pass, so include real-browser verification as a completion condition of the upgrade
    - **Diagnostic heuristic**: When "data, delivery and schema are all correct, yet nothing shows on screen" line up, suspect a major-version incompatibility between the rendering library and the framework first (MUST). Before eliminating data layers one by one, check once whether the node "exists in the library's internal model but not in the DOM" and narrow to the final rendering stage. Use the distribution of symptoms (only nodes using a specific rendering mechanism are missing) as the fingerprint of the incompatibility (SHOULD). Failure pattern: six layers were cleared before the root cause was reached

### §301. Tailwind CSS 4 Deep Dive

- **Rule 33.294**: Understand and maximize Tailwind CSS 4's new architecture
- **CSS-First Configuration**: Migrate from `tailwind.config.ts` to CSS-native `@theme` directive. Complete all configuration within CSS
- **Oxide Engine**: Rust-powered engine delivers up to 10x faster build speeds. Combined with Turbopack for dramatically improved DX
- **`@layer` Integration**: Tailwind v4 natively leverages CSS `@layer`. Manages utilities, components, and base in three native layers
- **Lightning CSS**: Reduces PostCSS dependency, leveraging Lightning CSS for native CSS transpilation
- **Zero-Config Content Detection**: `@source` directive improves automatic content detection accuracy. Manual `content` array configuration is no longer needed

```css
/* ✅ Tailwind CSS 4 — CSS-First Configuration */
@import "tailwindcss";

@theme {
  --color-brand: #6366f1;
  --color-brand-light: #818cf8;
  --font-display: "Inter", sans-serif;
  --breakpoint-3xl: 1920px;
}
```

---

## Part III: Next.js App Router Architecture ⚛️

### §6. App Router & React Server Components

- **Rule 33.6**: Use the **App Router** as standard and maximize Server Components (RSC) rendering. Dramatically reduce the amount of JavaScript sent to the client
- **Data Fetching**: Fetch data server-side and avoid waterfalls
- **The Server-Only Import Protocol (Bundle Protection)**:
    - **Rule 33.7**: Files exclusive to the server (`lib/api/*`, `lib/actions/*`, etc.) must include `import 'server-only'`
    - **Effect**: Build errors when accidentally imported from Client Components, physically preventing sensitive logic and API key leakage into client bundles
- **The Transitive Env Boundary Protocol**: Modules referenced from Client Components MUST NOT import the private env SSOT module, directly or indirectly. Even when a `use client` file never reads `env` itself, it can reach it through shared modules such as logger / utils / image loader. Separate the public variables the client needs into a public-env-only SSOT, and make shared modules referenced from both server and client depend only on publicly safe runtime information (`NODE_ENV`, etc.), never on secrets (MUST)
    - **Verification**: Confirm by search that private env imports from client-boundary files are 0, and confirm with both lint and the production build that the boundary is intact (SHOULD)
- **Sink Boundary Pattern**: When a cross-cutting synchronous API (a logger, etc.) carries a server-only dependency, rewriting every caller or forcing a build failure via a `server-only` marker is not the solution. Extract only the environment-dependent implementation (the output target = sink) into a boundary module and swap it with `package.json` `imports` conditions (browser / default, etc.) (SHOULD). Both implementations keep the same interface, and shape drift is pinned by a test (MUST)
    - **Verification**: Prove it as a pair: "0 occurrences of the dependency in public chunks after a clean build" (negative side) and "it exists on the server side" (positive side) (MUST). Record conditions that were tried and did not work with an explicit "do not retry" so the next person's time is protected (SHOULD)
- **Server-Only Applicability & Detection (reinforcing Rule 33.7)**: Modules that reference secret env, hold an RLS-bypassing client, initialize backend SDKs or write to admin-only tables MUST declare the `server-only` boundary even when no client import path exists yet, as defense against future regressions. Detection: grep for "files containing secret-related symbols without a `server-only` declaration". In the test runtime, alias it to a no-op

### §7. Directory Ontology

- **`src/app`**: Routing definitions only. Logic prohibited
- **`src/lib/actions`**: Server Actions (data gateways)
- **`src/lib/gateway`**: Data access layer (DB/External APIs)
- **`src/components`**: UI parts. Separate into `ui` (generic) and `features` (feature-specific)
- **`src/hooks`**: Custom hooks
- **`src/types`**: Type definitions & DTOs
- **The Static Page Prohibition (No Hardcoding)**:
    - **Rule 33.8**: Hardcoding content-centric pages (Terms of Service, Privacy Policy, etc.) is prohibited. Deliver from a Headless CMS and handle via dynamic routing
- **The Anti-Haribote UI Protocol (Realism Mandate)**:
    - **Rule 33.9**: UI implementations that treat "future columns" or "ambiguous JSON" not in the DB schema as normalized data are prohibited

### §8. Environment Variable Validation

- **Rule 33.10**: Direct usage of `process.env` is prohibited. Use `t3-env` or `zod` to validate environment variable types and existence at startup. The app must not start if required keys are missing

```typescript
// ✅ Type-safe environment variables with t3-env
import { createEnv } from "@t3-oss/env-nextjs";
import { z } from "zod";

export const env = createEnv({
  server: {
    DATABASE_URL: z.string().url(),
    API_SECRET: z.string().min(32),
  },
  client: {
    NEXT_PUBLIC_SITE_URL: z.string().url(),
  },
  runtimeEnv: {
    DATABASE_URL: process.env.DATABASE_URL,
    API_SECRET: process.env.API_SECRET,
    NEXT_PUBLIC_SITE_URL: process.env.NEXT_PUBLIC_SITE_URL,
  },
});
```

- **Rule 33.10a: The Static Access Bridge**: Public environment variables that the bundler inlines at build time (`NEXT_PUBLIC_*`, `VITE_*`, etc.) MUST be read in the static reference form the bundler substitutes (`process.env.NAME` / `import.meta.env.NAME`). Reading the key dynamically through a constants object (`process.env[KEYS.NAME]`) cannot be substituted, becomes `undefined` in the production client bundle, and the startup validation collapses into a full-screen error (MUST NOT). It does not reproduce on the local dev server
    - Centralizing key names in constants is allowed, but keep a "static access bridge" that preserves static references at the value-read boundary, and update the key constants, schema, bridge and regression test together whenever a public env is added or removed (MUST). Verification: no `process.env[` remains in the public env module, and the production build does not fall into a startup error when run in a browser
- **Rule 33.10b: No Weak Secret Fallback**: Never write `?? ''` / `?? null` / `?? '<default>'` fallbacks for secret env (MUST NOT). The canonical rule is "Missing-Secret Behavior" in `security/000_security_privacy.md`.

### §9. Site Settings Architecture

- **Runtime Injection**: Retrieve settings like theme colors from the DB at runtime (RootLayout) and inject as CSS variables. Runtime configuration enables design changes without rebuilds

### §10. Next.js 15 Async API Protocol

- **Rule 33.11**: As of Next.js 15, `params`, `searchParams`, `headers`, `cookies`, `draftMode` are Awaitable (Promise)
- **Action**: Always use `await` or React's `use()` hook when referencing these

### §11. Partial Prerendering (PPR)

- **Rule 33.12**: Leverage Next.js 15's Partial Prerendering (PPR) to achieve the optimal combination of static shells and dynamic content
- **Static Shell**: Page layout, navigation, and static content are prerendered as an immediately-delivered static shell
- **Dynamic Streaming**: User-specific content (auth state, personalization, etc.) streams dynamically within `<Suspense>` boundaries
    - **Proviso (public body content)**: Do not place the H1, body, result lists or JSON-LD of public surfaces that must be visible to AI search under `<Suspense>` (see §114). Crawlers that do not execute JS see only the skeleton of a deferred boundary's children
- **Action**: Enable `experimental.ppr: true` in `next.config.ts` and declare `export const experimental_ppr = true` per page
- **Next.js 16 Cache Components**: The `'use cache'` directive reaches GA as the stable version of PPR. Cache boundaries can be declared even within dynamic components

### §302. The next/after API Protocol

- **Rule 33.295**: Leverage Next.js 15+'s `after()` API for non-blocking post-response processing
- **Use Cases**: Logging, analytics event dispatch, cache invalidation, and other side effects that don't affect the response
- **Advantage**: Unlike `waitUntil`, `after()` can be used within Server Actions, Route Handlers, Middleware, and `generateMetadata`
- **Side-Effect Boundary**: Route notification, email and external-integration side effects to post-response execution or a queue, while business logic such as DB writes and payments is awaited synchronously so failure is reported in the response. Never let a side-effect failure be mistaken by the user for failure of the operation itself (MUST)
- **After-Response Hook Contract**: "Making failure visible (log + count)" and "guaranteeing completion after the response (registering with the platform hook)" are separate problems; either alone is insufficient. Make one composed helper that satisfies both and use it as the single entry point (MUST). The canonical rule is "After-Response Hook Contract" in `engineering/000_engineering_standards.md`.
- **Error Isolation**: Errors within `after()` do not affect the main response. However, isolate with `try-catch` to ensure error logging

```typescript
// ✅ Non-blocking logging with next/after
import { after } from 'next/server';

export async function POST(request: Request) {
  const data = await processRequest(request);

  after(async () => {
    await analytics.track('api_call', { endpoint: '/api/data' });
    await auditLog.write({ action: 'data_processed', timestamp: Date.now() });
  });

  return Response.json(data); // Response returned immediately
}
```

---

## Part IV: Server Components & Client Components ⚛️

### §12. Server / Client Boundary Design

- **Rule 33.13**: Default to Server Component. Apply `'use client'` only to the **smallest unit requiring interactivity**
- **Leaf Component Strategy**: Place `'use client'` at the **leaf (end)** of the component tree. `'use client'` at page or layout level is prohibited
- **Props Serialization**: Props from Server → Client must be serializable values only. Passing functions or class instances is not possible
- **Plain JSON at the Boundary**: Any layer that passes editor- or library-generated null-prototype objects (from `Object.create(null)`), class instances or Map/Set across a framework boundary (Server Action, RPC, `postMessage`, Worker, etc.) MUST pass them through plain-JSON conversion (`JSON.parse(JSON.stringify(x))` or equivalent) immediately before the boundary. The serializer judges these "not plain" and silently replaces or drops them on the wire, and nothing — type check, schema validation (`unknown`) or unit test — surfaces it. `structuredClone` preserves the prototype, so it is not a substitute (MUST NOT)
    - Pin the plain-JSON wiring (that it runs at the exit of the data producer) with a unit test (MUST). Triage: an incident of the form "saving unedited succeeds / editing breaks everything" points at a serialization boundary; hook `fetch` and look at the wire bytes directly (SHOULD). Substitution markers such as `"$T"` confirm this mechanism

### §13. The Async-UI Boundary Protocol

- **Rule 33.14**: Directly importing Async Server Components that perform data fetching from UI components (especially Client Components) is prohibited
- **Action**: Components with data logic should render at the top level of `layout.tsx` or `page.tsx` (Server Context) and physically separate from UI using the `children` pattern

### §14. The Component-DTO Interface Protocol

- **Rule 33.15**: Using raw database types (`Row`) in UI component Props definitions is prohibited. Depend on **DTO Interfaces** and hide implementation details
- **Two-Key Lock (reinforcing Rule 33.15)**: Every path, including "admin-only" ones, goes through the DTO mapper without exception (MUST). Maintain a structure where a new column cannot leave unless both the SELECT column allowlist and the DTO output allowlist opt in, cutting the path by which a PII column added through schema drift leaks automatically. Public-boundary serializers build a new object by allowlist pick; the denylist style `{...rest}` + `delete` + `as DTO` is prohibited because any field you forget to enumerate is public by default (MUST NOT)
    - An object passed across the Server → Client boundary has every column that exists at runtime serialized into the RSC payload and shipped to the browser, even when the type is a public type and the client never uses it. Convert admin DTOs holding sensitive columns to a public projection before the boundary and pin with a test that `JSON.stringify(projection)` contains no sensitive value (MUST). Physically exclude PII columns from client-bound SELECT specs and keep a separate server-only spec. "Readable only by the owner under RLS" is not the same as "may be emitted into client HTML"

### §15. Production Build Verification Protocol

- **Rule 33.16**: **Code does not "exist" until `npm run build` passes with Exit 0**
- **SSG Awareness**: Importing dynamic APIs like `cookies()` in SSG pages causes production build errors. Separate dynamic dependencies
    - **Shared-layer propagation**: If the root layout or the i18n request config calls `headers()` / `cookies()` unconditionally, not a single static prerender comes back even after removing `force-dynamic` from every page. Before optimizing individual pages, check first for a factor that constrains the whole app uniformly, and do not confuse "N dynamic-rendering declarations" with "N dynamically rendered surfaces" (MUST). Measure with the build artifacts (`.html` count under `.next/server/app` and `prerender-manifest.json`), not by counting declarations in code
- **Tiered Database Client Protocol**: SSG/ISR-compatible DB clients must be **physically separated into different files** based on dynamic API dependency vs non-dependency
- **Build Green ≠ Behavior Correct**: A successful compile proves nothing about CSS, layout or responsive-branch changes. Complete them only after measuring in a browser the delivered CSS, the effective computed values and the width-condition match (MUST). Where the build pipeline generates type constraints as artifacts (export constraints on route / action files), that check does not exist until a build has run once, so pass the type check after a production build before declaring completion (MUST). A failure that reproduces only on the dev server is triaged in three steps: (a) confirm reachability by direct runtime call, (b) confirm reproduction on the production build, (c) if not reproduced, record it as dev-only. The canonical rule is "Build Green ≠ Behavior Correct" in `quality/000_qa_testing.md`.

---

## Part V: Edge Computing & Middleware ⚛️

### §16. Edge Middleware Design

- **Rule 33.17**: Execute authentication checks and geolocation redirects in **Edge Middleware** to minimize latency
- **Rule 33.18**: Keep `middleware.ts` lightweight and exclude static assets from processing scope. Heavy DB queries or external API calls within Middleware are prohibited
- **Rule 33.18a (Framework-Recognized Filename Mandate)**: Core files the framework recognizes by convention (middleware / proxy / error boundary / config) MUST be placed under the official name and export name for that version. Under a custom name (`guards.ts`, etc.) the framework does not recognize them and system-wide defenses such as CSP, CORS and rate limiting are never executed once — a "silent loss of defense". Build and tests pass, so everyone "assumes it works". Convention names change across versions (e.g. `middleware.ts` → `proxy.ts`, see §311), so on upgrade confirm the old name has not degraded into an "unrecognized custom name". Verify system-wide defenses not by "the file exists" but by response headers / 429s actually appearing in real delivery (SHOULD)
- **Rule 33.18b (ASCII-Only Header Values)**: HTTP header values set in middleware / on the server (including comment portions of long CSP strings) MUST contain only ASCII-safe characters. Non-ASCII (full-width characters, etc.) violates HTTP's byte-string constraint, crashes with a runtime 500 and is not detected at build time
- **Rule 33.18c (Trusted Header Strip)**: Headers that middleware passes downstream as "trusted" (principal ID, tier, auth source, etc.) MUST be unconditionally stripped of client-supplied values at the entry point on every path, and re-set with verified values only after successful authentication. On code paths where middleware does not set them (fall-through of some bearer / API-key routes) the client's spoofed value reaches downstream untouched and becomes privilege escalation. Confirm the header-propagation API contract (a set on the response header does not reach downstream `request.headers.get`) and pin the gap between intent and implementation with a test (MUST). A comment saying "middleware sets x-user-id" is not proof of fact. Downstream handlers treat the trusted header as layer 1 and keep a layer 2 that re-verifies against the DB (SHOULD). Detection: cross-check the header names middleware sets against the names downstream reads. The canonical rule is "Trusted Header Strip" in `security/000_security_privacy.md`.
- **Rule 33.18d (Rewrite-Before-Authorization Ordering)**: Before writing any branch on the request path (authorization, exclusion, rewrite), state which of rewrite, normalization and prefix removal takes effect first (MUST). In rewrite-style i18n, judging authorization on the pre-rewrite path makes `'/en/owner/x'.startsWith('/owner')` false and opens a hole only on the locale-prefixed side. Limit i18n / SEO rewrites to page requests; exclude API, framework internals, static assets and metadata regardless of prefix, and never generate an API path after the fact on a route that bypasses the authorization boundary (MUST). Judge path boundaries by exact boundary match `path === root || path.startsWith(root + '/')`; a bare `startsWith(root)` also captures sibling routes like `/owner-guide` and is prohibited (MUST NOT). Contract tests must include prefixed paths and similarly named sibling routes

### §17. The Non-Blocking Edge Processing Protocol

- **Rule 33.19**: Blocking DB writes unrelated to the main response with `await` in Edge Middleware and API Routes is prohibited
- **Signed Internal Context**: In a setup where an internal rewrite re-enters the middleware, observe on the real runtime how many times it runs and which headers reach the second pass (MUST). Treating the mere presence of a header added by the first pass as proof of an "internal request" lets external clients forge it. HMAC-sign the internal context with a server secret, restore it only when signature verification, path match and locale match all hold, and fail closed otherwise (MUST). Never reuse the display language for authentication, authorization or billing decisions (MUST NOT). Regression tests cover a valid signature, forgery, replay and direct access
- **waitUntil**: Background side effects using `event.waitUntil()`
- **Error Isolation**: Isolate background processing errors with try-catch

### §18. CSP Worker Integrity

- **Rule 33.20**: Libraries like `heic2any` internally create `Web Workers` and use `blob:` URLs. Explicitly include `worker-src 'self' blob:;` in Middleware CSP settings

---

## Part VI: UI Component Design 🔀

### §19. shadcn/ui + Design Tokens

- **Rule 33.21**: Adopt **shadcn/ui** as the standard UI component library, balancing customizability and accessibility
- **Design Token**: Define project-specific colors, fonts, and shadows as tokens in Tailwind Config's `extend`. Direct HEX value usage is prohibited
    - **Legitimate exceptions and detection procedure**: Hex literals MAY remain only where a third-party brand guide fixes the color (external service logo SVGs, etc.), for chart data-series colors, and in email HTML inline styles where CSS variables are not resolved; state the reason in a code comment. Audit as "search every hex pattern → exclude the known legitimate locations (token definitions, theme admin screen, sanitizer allowlist, etc.) → review everything that remains", with zero findings or annotated exceptions as the completion condition (MUST). A blanket "all prohibited" turns third-party logos and emails into violations and hollows out the audit
- **Class Sorting**: Usage of `prettier-plugin-tailwindcss` is mandatory

### §20. Interactive Components Standard

- **Rich Selection Protocol**: Conventional Radio/Checkbox is prohibited in principle. **"Intuitively clickable rich card-style UI"** is the standard
- **Responsive Combobox Protocol**: Desktop: `Popover` / Mobile: **Drawer (Vaul)**
- **Stable IDs**: `CommandItem` `value` must be a unique, consistent **ASCII string**. Using Non-ASCII scripts (CJK characters, etc.) in `value` breaks selection logic

### §21. The Design Consistency Protocol

- **Rule 33.22**: System-native `<input type="date">` is prohibited as it breaks design system consistency as a "foreign element"
- **The App-Like Feel Protocol (Overscroll Control)**: Apply `overscroll-behavior-y: none` for mobile web apps is recommended

### §22. The Performance First Protocol

- **Rule 33.23**: Core Web Vitals are deployment requirements, not mere goals
    - **LCP < 2.5s**, **INP < 200ms**, **CLS < 0.1**
- **Bundle Size SLA**: Initial JS must stay under **150KB (Gzipped)**
- **Rule 33.24**: Libraries exceeding **30KB** Gzip in the main bundle are prohibited. Code Split with `next/dynamic`

### §23. The Canonical Identity Protocol

- **Rule 33.25**: On public pages, always define `alternates: { canonical: url }` in `generateMetadata`

### §24. Media Interaction (Crop UI)

- **Rule 33.26**: Automatic server-side cropping is prohibited. Implement UI allowing users to determine trimming range
- **HEIC Conversion**: Automatically convert iPhone `.HEIC` to JPEG/PNG with `heic2any` before upload
- **Filename Sanitization**: Convert multi-byte filenames to romanized characters on the client side

---

## Part VII: CSS Architecture 🌐

### §25. Utility First CSS

- **Rule 33.27**: Use Tailwind Utility classes as the standard
- **Component Extraction**: Encapsulate common patterns as React components and avoid `@apply` as much as possible
- **CSS Modules**: Only permitted for complex animations or styles that are difficult to express with Tailwind
- **Shared ClassName Extraction**: When an identical long utility-class string appears in 3 or more places within one component family, extract it into a shared constants module (MUST). Name it "target + role + kind suffix" (e.g. `EMBED_CODE_TEXTAREA_CLASSNAME`), place it in a private module directly under the domain folder (leading underscore, etc.), and detect every 3+ duplicate by script during audits (SHOULD)
- **The Utility Class Definition Check**: When using a project-specific utility class or prefixed class, actually open its definition (MUST). A class name is a "statement of intent", not an "implementation", and the number of usages is no evidence that a definition exists (users merely copy existing examples, so usages growing without a definition is the natural outcome). Writing a class name without going through `@apply` / `@utility` raises no build or lint error, so design the check on that silence and pin that a declaration exists on the CSS side (SHOULD). Failure pattern: a class reused as "already handled" had no definition and the scrollbar stayed visible

### §26. The CSS Specificity Protocol

- **Rule 33.28**: Overriding styles with `!important` is **completely prohibited**. Resolve root causes or control through React state management
- **Presence Gate**: Judge `!important` by "does it exist" before asking "why". A single occurrence is `NEEDS_FIX` in principle and treated as a careless override (MUST). Styles that do not take effect are resolved through selector design, component responsibility, DOM hierarchy, tokens, variants, state attributes and conditional rendering; a fix that adds `!important` to get through is prohibited
    - **Exceptions and verification**: Exceptions only for cases that are unavoidable by design — external embeds, print, third-party iframes. Confine the scope to the target class, record the reason no alternative exists, the removal condition and the verification command in a comment or evidence, and require human review (MUST). Tasks touching UI/CSS include a cross-extension search (e.g. `rg -n "!important" src --glob "*.tsx" --glob "*.css"`) with zero findings as a completion condition (MUST). A bare "prohibited" gets overridden in exception debates

### §27. The CSS Class Merge Utility Protocol

- **Rule 33.29**: Manual concatenation with template literals or string concatenation is prohibited. Mandate dedicated merge utilities: `cn()` / `clsx` + `tailwind-merge`

### §28. The Z-Index Stratification Protocol

- **Rule 33.30**: Prevent Z-Index "magic numbers"

| Layer | Z-Index | Target |
|:------|:--------|:-------|
| **Overlay** | 10000 | `Select`, `Popover`, `Tooltip`, `Calendar` |
| **Modal** | 9999 | `Dialog`, `Sheet` |
| **Menu** | 1000 | Drawer menu, Navigation |
| **Header** | 50 | Fixed header |
| **Floaters** | 40 | Floating buttons |

### §29. The Stacking Context Safety Protocol

- **Rule 33.31**: Applying explicit `z-index` to regular content elements is prohibited in principle. Isolate scope with `isolation: isolate`
- **The Sticky Travel Protocol**: When `position: sticky` does not follow, measure the "parent height" and the "sum of child heights" (MUST). The difference is the travel distance; if the parent is only as tall as its content, the last child is already at the bottom and the travel range is zero. The grid / flex item is not necessarily the element you wrote (in one case the wrapper stretched and held the height while the inner `aside` was `height:auto`). Travel depends on body length, so check both short and long pages (SHOULD), and confirm with `elementFromPoint` at several points inside the frame that nothing covers it while following. Without `z-index` the stacking order stays DOM order and loses to a later `z-10`

### §30. The CSS Containment Protocol

- **Rule 33.32**: Apply `contain: layout` to scroll containers to isolate layout calculation scope
- **The Natural Scrolling Protocol**: Nested scroll structure using `h-dvh` + `overflow-y-auto` is prohibited. Delegate to browser-native Window Scroll with `min-h-dvh`

### §31. Container Queries

- **Rule 33.33**: Use **CSS Container Queries** (`@container`) for component-level responsive control. Media queries (`@media`) are viewport-dependent and unsuitable for autonomous responsive design of reusable components
- **Container Type**: Set `container-type: inline-size` on parent elements requiring responsive control
- **Container Units**: Leverage container query units (`cqw`, `cqi`, etc.) for components to flexibly adjust layout based on their container size

```css
/* ✅ Component-autonomous responsive with Container Query */
.card-container {
  container-type: inline-size;
}
@container (min-width: 400px) {
  .card { display: grid; grid-template-columns: 1fr 2fr; }
}
@container (max-width: 399px) {
  .card { display: flex; flex-direction: column; }
}
```

### §303. The CSS Layers (`@layer`) Protocol

- **Rule 33.296**: Leverage **CSS Cascade Layers** (`@layer`) to control style priority at the cascade level
- **Layer Order**: Layer declaration order determines cascade priority. Later declared layers take precedence
- **Third-Party Isolation**: Isolate third-party CSS in dedicated layers to prevent conflicts with project styles
- **Tailwind CSS 4 Integration**: Tailwind v4 internally uses `@layer base`, `@layer components`, `@layer utilities`. Understand integration with custom layers
- **Unlayered Styles**: Styles not belonging to any layer take precedence over all layers. Recommend placing all styles in layers to prevent unintended overrides
- **Container Element Pattern (when a layer is not an option)**: Unlayered third-party CSS unconditionally beats a utility in `@layer utilities` at equal specificity. To override with a utility, put the other side into a layer; when that is impossible (each component imports it directly, etc.), attach the utility to a bare container element that carries no rules such as `display` (MUST)
- **Computed-Value Verification (writing CSS ≠ it working)**: A change that adds CSS transitions, utility classes or layer assignments is not complete on "it is in the source" or "the class appears in the HTML" (MUST NOT). Completion means `getComputedStyle()` and `getBoundingClientRect()` on the real DOM, and for transitions a time-series sample of intermediate values (MUST). When a prerequisite feature (an enabling keyword like `interpolate-size`) is missing, CSS stops silently with no error or warning. Failure pattern: a change whose production DOM computed value stayed `pan-y` looked "fixed", and the same hole was fallen into again 4 days later. Never judge a fix with the same observation method (class presence) used before the fix. The canonical rule is "Computed-Style Verification" in `quality/000_qa_testing.md`.
- **Derived Custom Properties over Instance CSS**: Never fix a defect shared by several instances of the same component with CSS that names each instance (MUST NOT). A design that appends CSS every time an instance is added cannot detect omissions (e.g. 4 of 10 instances missed). Emit custom properties from the same values each instance passes to the component, and keep exactly one set of generic rules in global CSS (MUST). Guarantee coverage with a check that scans every file using the component and pins instance count against declaration count via the complement
- **Margin Collapse Across Fragments**: In a structure that splits the body into fragments laid out in sequence (body alternating with widgets), if the fragment container becomes a BFC through `overflow: hidden`, margins across fragments no longer collapse and add up instead. When only horizontal overflow must be clipped, use `overflow-x: clip`, which creates no BFC (SHOULD). Design heading `margin-top` to always exceed block `margin-bottom` so the gap above a heading is "the heading's own margin-top regardless of what precedes it", and keep the outer frame's margins identical before and after hydration (MUST)

```css
/* ✅ Priority control with CSS Layers */
@layer reset, third-party, base, components, utilities;

@layer reset {
  *, *::before, *::after { box-sizing: border-box; margin: 0; }
}
@layer third-party {
  /* Isolate third-party library styles here */
}
@layer components {
  .card { border-radius: var(--radius); padding: 1rem; }
}
```

### §304. The CSS `:has()` Selector Protocol

- **Rule 33.297**: Leverage CSS `:has()` selector (parent selector) for styling based on child element state without JavaScript
- **Form Validation Styling**: Style entire form groups' error state with `:has(:invalid)`
- **Interactive States**: Change container styles when focused with `:has(:focus-within)`
- **Layout Adaptation**: Auto-adjust card layout for image-containing cards with `:has(> img)`
- **Performance Note**: `:has()` can be a high-cost selector. Avoid complex nesting. Rely on browser optimizations while verifying through measurement

```css
/* ✅ Declarative styling with :has() */
.form-group:has(:invalid) {
  border-color: var(--color-destructive);
}
.card:has(> img) {
  grid-template-rows: 200px 1fr;
}
.sidebar:has(~ main:empty) {
  display: none;
}
```

---

## Part VIII: Component Design Principles 🔀

### §32. The Component Colocation Protocol

- **Rule 33.34**: "Sub-components," "type definitions," and "constants" used only in a specific component should be written in the **same file (Co-location)**. Splitting is only permitted when a file exceeds **300 lines**

### §33. The Barrel Export Prohibition

- **Rule 33.35**: Bulk re-export through `index.ts` (Barrel files) is prohibited. Direct imports from physical files are mandatory

### §34. The Dead Code Execution Protocol

- **Rule 33.36**: Do not place heavy imports "after" conditional branches or early returns

### §35. The Static Component Persistence Protocol

- **Rule 33.37**: Defining components inside another component's render function is prohibited. Sub-components must be defined at **Module Scope (file top level)**
- **Anti-Pattern**: `const MyComponent = () => { const Sub = () => <div />; return <Sub />; }` — **Technical Felony**

### §36. The Route Conflict Ban

- **Rule 33.38**: When refactoring pages, physically delete the source directory
- **The Self-Referencing Route Scan**: A change that relocates a screen (URL) is not finished by the page diff alone. Grep the component and its dependencies for the old URL and route constants, and update every self-referencing path of the "return here when done" / "you can change this here" kind — OAuth and similar redirect targets, cache-revalidation paths, links, breadcrumbs, links inside notification emails, documentation — to the new location (MUST). The canonical rule is "The Self-Referencing Route Scan" in `engineering/000_engineering_standards.md`.
- **Route Constant ↔ Reality Triangulation**: When adding or using a route constant, confirm at the same time that the corresponding real page / redirect exists and that authentication and ownership checks are in place (MUST). A constant can look like an SSOT while the path is broken because nothing stands behind it. Investigate 404s by cross-checking the three points "link call site, constant, real target" together

---

## Part IX: React Hooks Best Practices ⚛️

### §37. The React Hooks Order Guarantee Protocol

- **Rule 33.39**: Hooks call order must be invariant across renders
- **Mandatory Order (Axiarch Standard)**:
    1. **ALL HOOKS FIRST**: Aggregate all Hooks at the component top
    2. **DERIVED STATE**: Variable calculations & state derivations
    3. **CONDITIONAL RETURNS**: Early Return

### §38. The Hook Dependency Protocol

- **Rule 33.40**: `useEffect` / `useCallback` dependency arrays must strictly follow ESLint (`react-hooks/exhaustive-deps`). Removing dependencies "because of infinite loops" is strictly prohibited

### §39. The Reactive Subscription Safety Protocol

- **Rule 33.41**: Directly including return values of `watch()`, `subscribe()`, etc. in `useEffect` dependency arrays is prohibited. Use the Callback Subscription Pattern

### §40. The Subscription Timer Sanitization Protocol

- **Rule 33.42**: `setTimeout` / `setInterval` within subscription callbacks must manage timer IDs with `useRef`. Managing timers with local variables is prohibited
- **Timer Dependency Rate Rule**: The dependencies of an effect that owns a periodic timer (interval / debounce / timeout) MUST be only a boolean meaning "is it running"; never the progress itself. When writing a dependency, ask "can this change faster than the period?". A fast-changing dependency plus a cleanup-bearing effect is cleaned up and recreated before every tick, so it never ticks once. It reproduces most reliably on fast networks and machines, while on slow ones the tick happens to land in time and it looks correct
    - A design that "shows no number when it cannot estimate" means, conversely, that "nothing showing" is not a signal of failure: a fault that parks on a plausible waiting state is indistinguishable from the normal path. Separately confirm that the measured value is actually moving (SHOULD), and in tests deliberately inject "updates faster than the period" (SHOULD)

### §41. The Explicit Initial State Typing Mandate

- **Rule 33.43**: When passing `[]` or `null` to `useState`, explicit generic type parameters are mandatory
- `useState([])` prohibited → `useState<Item[]>([])`
- `useState(null)` prohibited → `useState<User | null>(null)`

### §42. The Compiler Readiness Protocol

- **Rule 33.44**: Promote React Compiler-compatible coding patterns. Avoid excessive manual use of `useMemo` / `useCallback` and implement components as pure functions
- **Structural Compliance Checklist**: Compiler / concurrent-rendering warnings are not lint noise but structural smells that will make the build fail on a future framework update; keep build-time compiler warnings at 0 (MUST)
    - Do not write to a ref during render (MUST NOT). Move ref updates into event handlers or effects
    - Consolidate hydration / client detection into one shared hook based on `useSyncExternalStore` and do not scatter `mounted` state everywhere (SHOULD)
    - Re-evaluate whether each props → state sync effect is needed; where kept, avoid synchronous updates during the first paint and distinguish them from user-driven updates (SHOULD)
    - Watch form-library values through the subscription hook (`useWatch()`), not a direct call (`watch()`) that recreates the subscription every render (SHOULD)
- **The Effect Order & Remount Protocol**: Effects run child component → parent component. A parent `useEffect` that resets to `null` the state a child's callback (`onReady` / `onInstance`, etc.) just set is prohibited (MUST) — the child's value gets overwritten by the parent. When a third-party widget (slider, editor, map, etc.) needs re-initialization on a configuration change, include every configuration attribute in `key` and remount the whole component (SHOULD, see §52). Including only some attributes means the change does not propagate. Guard references to destroyed instances with something like `instance && !instance.destroyed`

---

## Part X: React 19 New APIs & React Compiler ⚛️

### §43. React 19 Actions

- **Rule 33.45**: Leverage React 19's Actions concept to handle data mutations with async functions wrapped in `startTransition`
- **Automatic Pending State**: Actions automatically manage `isPending` state, reducing manual `isLoading` state management
- **Error Handling**: Errors within Actions are automatically caught by Error Boundary or `useActionState` error state

### §44. useOptimistic

- **Rule 33.46**: Use the `useOptimistic` hook to implement optimistic UI updates that instantly update UI before server response
- **Low-Risk Operations**: Limit to reversible operations like like buttons, comment additions, etc. Wait for server confirmation for high-risk operations like payments
- **Automatic Rollback**: UI automatically rolls back to original state on server operation failure
- **Pure Update Function**: The function calculating optimistic state must be a pure function
- **Optimistic Update Integrity**: When overwriting local state with an update API's return value, that value is not necessarily the same shape as the list DTO (JOIN- and aggregate-derived fields can be missing). Carry over existing values for fields that may be absent, or design the update API to return the same projection as the list; unconditional overwrite is prohibited (MUST NOT). After create / delete / move, re-fetch or recompute not only the direct target but the derived data that depends on it (counts, aggregates, parent entity summaries) (MUST). Updating only one side reaches the user as "I saved but the number did not change"

### §45. useFormStatus & useActionState

- **Rule 33.47**: Use `useFormStatus` for form submission state management, automatically controlling button `disabled` / `loading` states
- **Scoping**: `useFormStatus` is scoped to the parent `<form>` element. Cannot obtain the state of a different form in the same component
- **useActionState**: Use `useActionState` as the successor to `useFormState` to manage Action pending state, return values, and errors in an integrated manner

### §46. use() Hook

- **Rule 33.48**: Use the `use()` hook to directly consume Promises and Contexts within Suspense boundaries
- **Data Fetching**: When passing data from Server Components to Client Components, use the pattern of passing Promises as props and resolving with `use()`
- **Conditional Invocation**: `use()` is the only hook that permits invocation within conditional branches, unlike other Hooks

### §47. React Compiler v1.0

- **Rule 33.49**: Introduce React Compiler (v1.0 GA, October 2025 / stable integration in Next.js 16) and **completely remove** manual `useMemo` / `useCallback` / `React.memo`
- **Automatic Memoization**: The compiler performs automatic memoization of components and hooks. Manual optimization is generally unnecessary and **discouraged**
- **Compatibility Mode**: Use `eslint-plugin-react-compiler` for pre-validation of compiler compatibility during gradual adoption
- **Pure Component Requirement**: Components must be pure functions (same input produces same output) as a prerequisite for compiler optimization
- **Next.js 16 Integration**: Set `experimental.reactCompiler: true` in `next.config.ts` (enabled by default in Next.js 16)

### §48. Resource Preloading API

- **Rule 33.50**: Leverage React 19's `preload()`, `preinit()`, `prefetchDNS()`, `preconnect()` APIs to programmatically control resource preloading
- **Font Preloading**: Pre-initialize critical fonts with `preinit()`
- **Third-Party DNS**: Minimize DNS resolution time with `prefetchDNS()` for external services
- **Deployment Criteria**: For third-party origins every page always connects to, and for the origin serving the LCP element, declare both `dns-prefetch` and `preconnect` (with `crossorigin` for CORS resources) in the root layout `<head>` (SHOULD). The former is the fallback for unsupporting environments, the latter the full handshake. Browsers cap simultaneous preconnects (e.g. 6) and ignore the excess, so do not add them for lazily loaded ad / analytics origins (MUST NOT), and declare origins used only on some pages on those pages

### §48b. useEffectEvent Hook

- **Rule 33.304**: Leverage the `useEffectEvent` hook stabilized in React 19.2 to separate non-reactive logic from Effects
- **Problem**: Logic that needs the latest value but should not be in the `useEffect` dependency array (e.g., referencing latest state during logging)
- **Solution**: Define non-reactive functions with `useEffectEvent` and call them from within Effects. This fundamentally resolves dependency array bloat and stale closure issues
- **Prohibition**: Functions defined with `useEffectEvent` must NOT be passed to other components or hooks. Use only within Effects

```typescript
// ✅ Non-reactive logic separation with useEffectEvent
import { useEffect, useEffectEvent } from 'react';

function ChatRoom({ roomId, theme }: Props) {
  const onConnected = useEffectEvent((connectedRoomId: string) => {
    // theme references the latest value but is NOT needed in Effect dependencies
    showNotification(`Connected to ${connectedRoomId}`, theme);
  });

  useEffect(() => {
    const connection = createConnection(roomId);
    connection.on('connected', () => onConnected(roomId));
    connection.connect();
    return () => connection.disconnect();
  }, [roomId]); // theme is NOT needed in the dependency array
}
```

### §305. React Activity Component

- **Rule 33.298**: Leverage the `<Activity>` component promoted to GA in React 19.2 to preserve state of hidden components while removing them from the DOM
- **Mode**: `mode="visible"` for normal display, `mode="hidden"` to remove from DOM while preserving state
- **Use Cases**:
    - Preserving input form state during tab switches
    - Pre-rendering modals/drawers
    - Retaining background pages during route transitions
- **Priority**: Hidden components render at low priority, minimizing main thread impact
- **Status**: React 19.2 GA — Fully supported in Next.js 16. Adopt proactively

```tsx
// ✅ State-preserving tab UI with Activity
import { Activity } from 'react';

function TabPanel({ activeTab }: { activeTab: string }) {
  return (
    <>
      <Activity mode={activeTab === 'edit' ? 'visible' : 'hidden'}>
        <EditForm /> {/* Form state preserved when hidden */}
      </Activity>
      <Activity mode={activeTab === 'preview' ? 'visible' : 'hidden'}>
        <Preview />
      </Activity>
    </>
  );
}
```

### §306. React `<ViewTransition>` GA Integration

- **Rule 33.299**: Leverage React's `<ViewTransition>` component (GA version) for declarative route transition and UI state change animations
- **Declarative API**: Integrates with `startTransition` to automatically trigger View Transitions API within React's update cycle
- **Cross-Document**: Recommended to enable automatic View Transition application for Next.js App Router cross-page navigation
- **CSS Customization**: Fine-grained animation control via `::view-transition-group()`, `::view-transition-old()`, `::view-transition-new()` pseudo-elements
- **Fallback**: Falls back to normal DOM updates on browsers that don't support View Transitions API (progressive enhancement)

```tsx
// ✅ Route transition animation with ViewTransition
import { ViewTransition } from 'react';
import { useRouter } from 'next/navigation';

function NavigationLink({ href, children }: Props) {
  const router = useRouter();
  return (
    <ViewTransition>
      <a onClick={() => startTransition(() => router.push(href))}>
        {children}
      </a>
    </ViewTransition>
  );
}
```

### §305b. cacheSignal() API

- **Rule 33.325**: Leverage the `cacheSignal()` API introduced in React 19.2 for precise control over RSC (React Server Components) cache lifecycles
- **Purpose**: Provides an `AbortSignal` linked to the cache entry's lifetime generated by the `cache()` API. Automatically cancels in-progress async operations (fetch, DB connections, etc.) when the cache is invalidated
- **Use Case**: Prevention of resource leaks from long-running data fetches and external API calls
- **Integration**: Pass `cacheSignal()` to the `signal` option of `fetch` to coordinate cache lifetime with HTTP requests

```typescript
// ✅ Cache-linked cancellation with cacheSignal()
import { cache } from 'react';
import { cacheSignal } from 'react';

const getProduct = cache(async (id: string) => {
  const signal = cacheSignal();
  const res = await fetch(`https://api.example.com/products/${id}`, { signal });
  // When cache is invalidated, signal is aborted, automatically canceling unnecessary requests
  return res.json();
});
```

### §305c. React Performance Tracks (Chrome DevTools)

- **Rule 33.326**: Leverage **Performance Tracks** introduced in React 19.2 to visualize React's scheduler behavior and component rendering in Chrome DevTools' Performance panel
- **Feature**: Dedicated tracks with component names are displayed in DevTools, enabling visual understanding of rendering times, re-render causes, and Suspense boundary resolution timing
- **INP Debugging**: Track React's response path to user interactions to identify root causes of INP degradation
- **Status**: Enabled by default in Chrome 131+. Use alongside React DevTools Profiler for both Lab Data and Field Data analysis

### §305d. Batching Suspense Boundaries for SSR

- **Rule 33.327**: Understand the **SSR Suspense boundary batch processing** improvement in React 19.2 to enhance SSR streaming consistency
- **Behavior**: When multiple Suspense boundaries can resolve simultaneously, content is displayed in a consistent order between client and server. Animation and layout shift consistency is improved
- **Impact**: Suspense boundary placement design improves users' perceived load speed and CLS. Overly granular boundary splits reduce the batching effect, so setting boundaries at meaningful units is recommended

---

## Part XI: Hydration & SSR Stability ⚛️

### §49. The Hydration Stability Protocol
- **Rule 33.51**: Minimize the risk of output mismatches between SSR and client rendering (Hydration Mismatch)
- **Root Cause**: Using `Date.now()`, `Math.random()`, browser-specific globals (`window.innerWidth`, etc.) during SSR causes mismatches
- **Suppress**: `suppressHydrationWarning` is **only permitted for date/time display**. Usage for anything else is prohibited
- **Allowed vs Prohibited Suppression (supplement)**: The suppression attribute MAY be used only for "differences your own code cannot reconcile" — attribute injection into `<html>` / `<body>` / shared navigation by browser extensions, server/client clock differences, random values and unique IDs. Using it to hide your own bugs, data-fetch mismatches or state-management problems is prohibited (MUST NOT). State the external cause in a comment when adding it; navigation elements shared across all pages that are frequent extension targets may carry it preventively, while links inside page content do not need it (SHOULD)
- **Dimension Class Parity**: When a server-side static renderer and a client-side component draw the same element, the classes / styles that decide dimensions, aspect ratio and spacing MUST share the same token / class definitions; one side must not use an inline style or different breakpoint values. An asymmetry of a single SSR value (`style="aspect-ratio:3/4"`) against responsive CSR values (`aspect-[3/4] md:aspect-[3/2]`) changes dimensions at hydration and causes CLS. Generate both from one constant or check their equality with an automated test (SHOULD)
- **Hybrid Swap Layout Parity**: Where server-rendered HTML is swapped for an interactive renderer on the client, require that the wrappers of both phases share the same layout rules (class system, spacing, typography) (MUST). If the content is read-only, remove the swap; if interactivity is needed, keep the swap and unify the rules. "Abolish the swap entirely" is an over-correction that loses interactivity; consider fixing the misuse first (SHOULD)
- **Conditional Render Ban**: Never render the same component with different props depending on loading state (`isLoading ? <X /> : <X extra />`) (MUST NOT). Unify the render and pass not-yet-fetched data as defaults (empty arrays, etc.). When a skeleton is needed, share the wrapper (grid, etc.) and swap only the children, building it with the same DOM structure, dimensions and aspect ratio as the finished layout (SHOULD)
- **Dual-Renderer Content Bake**: When the same content is drawn by two systems — an SSR static renderer and a client dynamic renderer — never inject external metadata (alt / caption, etc.) into only one renderer function (MUST NOT). The canonical rule is "Dual-Renderer Content Bake" in `engineering/310_headless_cms.md`.
- **The Pre-Init Appearance Protocol**: A CSS design of "apply by default, restore with an active / initialized class" always has a "before restore" appearance between SSR and JS initialization (hundreds of ms). Apply effect CSS only under a class meaning initialized (`.initialized .slide`, etc.) and structure it so that active is attached at the same moment as initialization (MUST). Capture the initial appearance with JS disabled (MUST) — one screenshot tells. Decorations with no effect (scaling where neighbors are not visible, etc.) only produce black areas or seams, so measure the layout condition and remove unnecessary effects (SHOULD)

### §50. The SSR Stream Resilience Protocol
- **Rule 33.52**: Implement strict null guards for data access during SSR streaming. Property access without null checks is prohibited
- **Debug Protocol**: Debug SSR errors via **server terminal output**, not browser DevTools

### §51. The Server Cookie Write Authority Protocol
- **Rule 33.53**: Cookie writes are limited to **Server Actions** or **Route Handlers**. Cookie writes during SSR (`page.tsx` rendering) are not possible

### §52. The Component Config Re-mount Protocol
- **Rule 33.54**: When component internal state reset is needed on dynamic configuration changes (theme, locale, etc.), include the configuration value in the React `key` prop to force re-mount

### §53. The Hydration-Safe Dynamic Content
- **Rule 33.55**: Client-only content (`window.location`, browser-specific values, etc.) should use the `useEffect` + state pattern for deferred rendering, returning `null` or fallback during SSR

---

## Part XII: Form Design (React Hook Form + Zod) 🔀

### §54. Schema-Driven Development
- **Rule 33.56**: Form design starts with Zod schema. Guarantee **Three-Point Sync** (Type, Validation, UI synchronization)
- **Three-Point Sync**: Schema (Zod) + DefaultValues + UI must always be aligned

### §55. The Form DefaultValues Completeness Mandate
- **Rule 33.57**: Explicitly set initial values for all fields in `useForm({ defaultValues })`. Implicit `undefined` dependency on undefined fields is prohibited

### §56. The Validation Error Transparency Mandate
- **Rule 33.58**: In addition to `handleSubmit(onValid)`, always implement the `onInvalid` callback: `handleSubmit(onValid, onInvalid)`
- Log Zod validation error details with `console.error` to prevent silent submission failures

### §57. The Strict Action Return Type
- **Rule 33.59**: Server Action return values must use a strict Union Type like **`ActionResult<T>`**

```typescript
type ActionResult<T> =
  | { success: true; data: T }
  | { success: false; error: string; fieldErrors?: Record<string, string[]> };
```

### §58. Server Action Form Integration
- **Rule 33.60**: After form submission, invalidate related caches with `revalidatePath` / `revalidateTag` to ensure UI and server state synchronization

### §59. Reset Form Protocol
- **Rule 33.61**: Use `form.reset()` for post-submission reset. When updating `defaultValues`, explicitly overwrite with `reset(newValues)`

### §60. Multi-Step Form Protocol
- **Rule 33.62**: Define individual Zod schemas per step in multi-step forms and execute validation on step transitions. Perform integrated validation of all step data at final submission
- **Step Form Thresholds**: Choose the form format by field count (SHOULD; the thresholds are examples set by the Blueprint): for example 1–5 fields on a single page, 6–10 fields in 2 steps, 11+ fields in 3+ steps with a mandatory progress bar. With 3+ steps, show step names, and mark completed steps with a check that can be clicked to go back (MUST). Keep inter-step data in session storage or equivalent so input survives reload and back navigation (MUST)
- **The Cross-Layer Constraint Parity**: Validation schemas across layers for the same input (client / server / public API) MUST take constraint values such as length limits and numeric ranges from a single constant and generate their error messages from it too. Independent evolution per layer produces the "client OK → server reject" UX accident and the defense collapse where "the loosest layer becomes the effective constraint when the API is called directly". Default to the strictest value when unifying (SHOULD); where a required / optional difference is legitimate, state the reason in a schema comment. When tightening a constraint, confirm existing rows do not exceed the new limit and sync the UI `maxLength` (MUST). Detection: list files holding more than one schema definition for the same entity
- **Controlled Select Allow-Set Guard**: A controlled Select component for enum values can fire `onChange('')` through the library's internal native `<select>` sibling or a remount (key regeneration by an array field `update()`, etc.). `onValueChange` MUST write only values inside the allowed set to form state, and the display side also falls back to the default for anything outside the set. Put the decision in a pure function outside JSX and test it
    - On the schema side, treat only `''` as "unset" and coerce it to the default, while still rejecting every other invalid value (SHOULD) — so drafts or old state holding `''` do not become unsaveable. Pre-save validation errors name the field, and the display-name dictionary is cross-checked against every schema key by test. Writes through paths the app's double guard cannot protect (direct API calls, migration scripts, manual SQL) are caught by a daily consistency check that warns on out-of-set values (`''` / null / legacy), with failure of the check itself surfaced as critical (see `engineering/710_data_reconciliation.md`)
- **Contact Identity Validation**: Format checks for contact details (email, phone) MUST NOT rely on the browser's built-in `type="email"` (accepts `a@b`) / `type="tel"` (no validation); a server-side pure function (syntax, reserved domains, disposable addresses, length limit) is the source of truth and the client lazy-loads the same function to show the result early on blur (MUST). The canonical rule is "Contact Identity Validation" in `operations/300_customer_experience.md`.

---

## Part XIII: Advanced Form Patterns 🔀

### §61. The Atomic Tabbed Form Protocol
- **Rule 33.63**: Split large forms (15+ fields) into tabs to reduce cognitive load
- **Tab Validation**: Validate only current tab fields on tab switch

### §62. The Auto-Save & Data Persistence Protocol
- **Rule 33.64**: Implement auto-save for important forms (profile editing, post creation, etc.)
- **Debounce**: Execute auto-save after 500ms–1000ms debounce after change detection
- **Visual Feedback**: Always display save state ("Saving..." / "Saved ✓")
- **Conflict Resolution**: Detect simultaneous editing across tabs/devices using Optimistic Locking (`updatedAt` comparison)

### §63. The Dynamic Form Engine Protocol
- **Rule 33.65**: Dynamic form generation (admin panels, etc.) should render fields schema-driven
- **Rule 33.65a (Structure by Container, not Delimiter)**: An input format that represents structure with a delimiter (newline, comma, line-leading marker, etc.) MUST NOT be used unless you can assert "that character never appears in the content". Free text almost never allows that guarantee: once in-item newlines and item separators are both `\n`, touching one character in the field multiplies items, and the label "1 line = 1 item" keeps editors from noticing. Represent structure with containers (MUST): one box = one item makes the concept of a delimiter unnecessary. Adding escape rules moves away from the goal "non-experts can update it" — what a convention protects gets broken; protect by form where form can protect. Any transformation with a round trip (display → edit → save) MUST be round-tripped with real data to confirm invariance. Synthetic data never produces real-world shapes like "an item containing a newline"

### §64. The useFieldArray Initialization Guard
- **Rule 33.66**: Watching `useFieldArray` `fields` in useEffect and calling `append` / `replace` causes infinite loops
- **Pattern**: Guard with `fields.length === 0` condition + `useRef` flag for one-time execution

### §65. The One-Shot Initialization Guard Protocol
- **Rule 33.67**: Dynamic array (`useFieldArray`) initialization must execute strictly once using the `useRef` flag pattern

### §66. The DnD Overlay Input Isolation Protocol
- **Rule 33.68**: Placing form input fields inside Drag & Drop overlays is prohibited. `DragOverlay` rendering must be limited to read-only previews

---

## Part XIV: Input UX Optimization 🌐

### §67. The Input Mode Mandate
- **Rule 33.69**: Set appropriate `inputMode` attributes for mobile keyboard optimization
    - Numeric input → `inputMode="numeric"`
    - Phone number → `inputMode="tel"`
    - Email → `inputMode="email"`
    - URL → `inputMode="url"`

### §68. The Input Normalization Protocol (NFKC)
- **Rule 33.70**: Convert full-width alphanumeric user input to half-width (NFKC normalization) before server submission. CJK characters (e.g., Japanese Hiragana, Katakana, Kanji) are excluded from NFKC conversion

### §69. The IME Composition Guard
- **Rule 33.71**: Prevent form submission from firing on Enter key press before IME input is confirmed (during composition). Guard with `compositionstart` / `compositionend` events

### §70. The iOS Input Zoom Defense
- **Rule 33.72**: On iOS, focusing `<input>` with `font-size` below **16px** triggers auto-zoom. Guarantee minimum **16px** font size for mobile input fields

### §71. The External Link Protocol
- **Rule 33.73**: Always add `target="_blank"` and `rel="noopener noreferrer"` to external site links
- **No Exception for Hand-Written JSX & Scheme Allowlist**: Hand-written JSX `target="_blank"` that bypasses the sanitizer also carries `rel="noopener noreferrer"` without exception (MUST). `next/link` is outside eslint `jsx-no-target-blank`, so supplement with a custom scan. Every place that renders a URL into `href` passes a scheme allowlist (http / https / internal relative paths) (MUST) — HTML escaping does not prevent scheme XSS (`javascript:`), and URL validators such as `z.string().url()` accept `javascript:` / `data:text/html` as valid URLs, so they are not an allowlist. Close both the input boundary and the render boundary (invalid values already stored in the DB cannot be neutralized by an input-side fix). Details in `security/000_security_privacy.md` §22.1

---

## Part XV: Validation & Frontend Security 🌐

### §72. The Anti-Spam Shield
- **Rule 33.74**: Implement Cloudflare Turnstile or reCAPTCHA v3 for public forms (contact, signup, etc.). Combined use with Honeypot fields is recommended

### §73. The Frictionless Security UI Protocol
- **Rule 33.75**: Security measures must not impede user experience. Use Turnstile in invisible mode to maintain user flow
- **Rule 33.75b (No Bot Challenge on Admin-Only Mutations)**: Do not attach a public-form bot challenge (CAPTCHA / Turnstile) to state changes that only authenticated admins invoke (SHOULD NOT). Control them with the admin guard, rate limiting, audit logging and allowed-set validation. Once the widget sits where no token can be obtained (a hidden container), the save button stays permanently disabled and you get the quiet malfunction "sibling updates succeed while the status update alone has zero success records". Use "zero success records for exactly this operation in the production audit log" as a detection method for the malfunction
- **Rule 33.75c (Hidden-Ancestor Static Check)**: In addition to render checks, verify via AST that the component rendering the bot challenge has no ancestor with `display:none` / the `hidden` attribute / a bare `hidden` class (SHOULD; breakpoint-qualified `md:hidden` is allowed). Pin positive and negative test cases. The same applies to invisible reCAPTCHA

### §74. The Conditional Security Bypass Ban
- **Rule 33.76**: Code that skips authentication checks based on `isAdmin` or `isDev` flags is prohibited. Baseline auth/authorization checks execute on all paths without exception
- **Fail-Closed Secret Comparison**: Endpoints guarded by comparison against a secret stored in env / config (cron, webhooks, internal APIs) MUST use a condition that rejects when the secret is unset or empty (`if (!secret || token !== secret)`). The form `if (secret && token !== secret)` becomes unauthenticated public access in an environment where it is unset. Consolidate into a shared verification function and prohibit hand-written conditions per route (SHOULD). Rate-limit keys MUST always include the caller's identifier (IP, user ID, API key) — a fixed-string key lets one user consume the whole budget and drags every user down (see `security/000_security_privacy.md` §10.6)

### §75. The Deep Type Recursion Break Protocol
- **Rule 33.77**: When defining recursive types with Zod or TypeScript, set depth limits with `z.lazy()` or bounded generics. Prevent compilation hangs from infinite recursion

### §76. The Strict DTO Boundary Protocol
- **Rule 33.78**: Receive external data (API Response, URL Params, etc.) as `unknown` type, validate with Zod schema, then cast. `as` type assertions are prohibited

### §77. The URL State Management Protocol
- **Rule 33.79**: Manage UI state for filtering, sorting, pagination via URL SearchParams. `nuqs` library recommended
- **Benefit**: Bookmark sharing, browser history, SSR compatibility
- **List Search Contract**: Keep list filter, sort and pagination state in the URL and make it operable with a GET form and links that work without JS (MUST). Round URL parameters to the allowed set (MUST): out-of-scope types, unknown sorts and invalid page numbers fall back to defaults rather than erroring. Return filtered zero results with 200 (never 404), separate the copy for "zero with filters (not found)" from "zero without filters (coming soon)", and offer "clear filters" (MUST)
    - Pin canonical to the base URL without filters and mark filter links `rel="nofollow"` so permutations of conditions are not indexed as separate URLs (SHOULD). Call sorts that depend on external aggregates (popularity, etc.) only when selected, fall back to the default order (newest) on failure, and include the id as the final key for a total order (MUST). Pin with a contract test that pagination carries the conditions over (SHOULD)
- **Receiver-Owned Query Contract**: The URL query of a screen transition is a "contract of the receiving screen", not of the link source. Build it with the receiving screen's builder function and key constants, never by hand at each link source (SHOULD)

### §78. The Hard Session Refresh Protocol
- **Rule 33.80**: After critical auth state changes (login, logout, permission changes), force refresh with `window.location.reload()`. `router.refresh()` may not fully reset auth context

---

## Part XVI: State Management 🔀

### §79. State Management Philosophy
- **Rule 33.81**: Clarify the state management hierarchy:
    - **Server State**: Managed by RSC / Server Actions / React Query. Frontend only caches
    - **URL State**: Managed by SearchParams (ref §77)
    - **Form State**: Managed by React Hook Form
    - **Client UI State**: Managed by `useState` / Zustand / Jotai
    - **Derived State**: Calculated through derivation. Not held as State
- **Global State Prohibition**: Abuse of global State Stores is prohibited. Manage state at minimum scope

### §80. Zustand / Jotai
- **Rule 33.82**: Use **Zustand** (medium-large stores) or **Jotai** (atomic state) for client-side UI state management
- **Redux Prohibition**: Usage of Redux / Redux Toolkit in new projects is prohibited
- **Immer Integration**: Use `immer` middleware for Zustand nested object updates to write immutable updates concisely

### §81. The Derived State Anti-Pattern
- **Rule 33.83**: The "mirroring pattern" of syncing values calculable from other state with `useState` + `useEffect` is prohibited. Use in-render calculation or `useMemo`

### §82. Context API Usage Criteria
- **Rule 33.84**: React Context should only be used for **data that doesn't update frequently** (theme, auth state). Using Context for frequently updating data (input values, animation state) degrades performance
- **Provider Hell Prevention**: Consider migrating to a state management library when Providers nest 3+ levels

### §83. Persistent State Protocol
- **Rule 33.85**: Implement `localStorage` state persistence with Zustand's `persist` middleware and establish versioning and migration strategies

---

## Part XVII: Data Fetching & Caching ⚛️

### §84. Data Fetching Principles
- **Rule 33.86**: Execute data fetches in Server Components, adhering to:
    1. **Parallel**: Fetch independent data in parallel with `Promise.all`. Waterfalls prohibited
    2. **Suspense**: Manage loading states declaratively with `<Suspense>` boundaries
    3. **Prefetch**: Pre-read data with `<Link prefetch>` for predictable navigation

### §85. The Public Cache Mandate (FinOps Protocol)
- **Rule 33.87**: Cache public read actions (unauthenticated data fetches) with `unstable_cache` (or Next.js 15's `'use cache'` directive)
- **Cache Tags**: Manage cache keys with semantic tags like `['stores', storeId]` and precisely invalidate with `revalidateTag`
- **FinOps Impact**: Public pages without caching result in every access hitting the DB directly, exponentially increasing costs

### §86. The Data Seeding & Cache Versioning Protocol
- **Rule 33.88**: After DB data seeding or migration, update cache version keys to force cache invalidation

### §87. The Resilient RSC Data Access Protocol
- **Rule 33.89**: Null guards are mandatory for data access within RSC. Place `data?.property` or null checks before `data.property`

### §88. React Query Usage Criteria
- **Rule 33.90**: Use **TanStack Query (React Query)** for client-side server state management
- **Stale Time**: Set a global `staleTime` to suppress unnecessary refetches (recommended: 5 minutes)
- **Deduplication**: Concurrent requests with the same key are automatically deduplicated

### §89. DB Query Performance Target
- **Rule 33.91**: DB queries called from the frontend should target **≤ 50ms**. Queries exceeding 100ms require index addition or query optimization

### §90. SWR vs Polling
- **Rule 33.92**: For real-time data updates, select in this priority:
    1. Server-Sent Events (SSE)
    2. WebSocket
    3. Polling (last resort, interval ≥ 30 seconds)
- **Adoption Criterion**: Adopt WebSocket / Realtime subscriptions only when, comparing the data's update period with the "tolerable delay until noticed", the value of immediacy justifies the cost of a persistent connection (connection count, fan-out, reconnection storms, billing) (SHOULD). If updates happen on a batch / cron period (e.g. every few minutes), default to a server-rendered snapshot plus a freshness-conditioned refetch. Document the adoption condition up front (e.g. the moment personal events arrive that must be noticed within seconds) and switch when it is reached
- **Conditional Refresh Without Layout Shift**: When a server-rendered snapshot exists, do not refetch unconditionally on every open (MUST NOT). The canonical rule is "Refresh Indicator Without Layout Shift" in `design/000_design_ux.md`.

---

## Part XVIII: Performance Optimization 🌐

### §91. The CWV Deployment Gate
- **Rule 33.93**: Strictly enforce the following Core Web Vitals thresholds as deployment gates:

| Metric | Good | Needs Improvement | Poor |
|:-------|:-----|:-------------------|:-----|
| **LCP** | ≤ 2.5s | ≤ 4.0s | > 4.0s |
| **INP** | ≤ 200ms | ≤ 500ms | > 500ms |
| **CLS** | ≤ 0.1 | ≤ 0.25 | > 0.25 |

- **Enforcement**: Auto-measure with Lighthouse CI and prohibit merging with `Poor` status

### §92. The Bundle Size Budget
- **Rule 33.94**: Strictly adhere to bundle size budgets:
    - **JS (Gzipped)**: Initial ≤ 150KB, Route Chunk ≤ 50KB
    - **CSS (Gzipped)**: ≤ 30KB
    - **Measurement**: Regular audits with `@next/bundle-analyzer`
- **Rule 33.94a (Artifact-Based Toolchain Decision)**: A builder / bundler / compiler switch MUST NOT be decided on build time and memory alone. Measure on the artifacts the "total volume of delivered output" and "whether code that should be dropped (debug logs, dev-only branches) is actually dropped". When a plugin has builder-specific options, suspect first that this is the reason for the pin
    - Take comparison measurements on the same commit, at least 2 runs each (MUST) — a single run cannot be distinguished from noise. Put a positive control in set comparisons (route count, chunk count) (MUST): confirm "N items are extracted" before concluding zero difference. If extraction yields 0 on both sides, "0 vs 0 match" is a false pass. Measure the effect of lazy loading and similar by analyzing the manifest for "removed from the initial chunk set" (SHOULD). Record the reason for toolchain pins (`--webpack`, etc.) (MUST) — a pin with unknown reason becomes debt that cannot be removed when a security patch must be applied

### §93. The Dynamic Library Decoupling Protocol
- **Rule 33.95**: Libraries exceeding 30KB (Gzip) are prohibited from main bundle inclusion. Lazy load with `next/dynamic`
- **Lazy Boundary Placement**: The heavy content of UI that "becomes visible only on user action" (dialogs, drawers, editors) MUST be lazy-loaded. But if the lazy boundary sits at each call site, a single eager caller cancels the split, and in designs where the trigger is inside, the trigger disappears while loading. Place the boundary inside the component, render the trigger statically and do not mount the heavy child until the first open (SHOULD) — one fix benefits every caller. After the first open, keeping it mounted to make re-opening instant is allowed (MAY). Criterion: "always rendered" is out of scope; "first visible on user action" is always a candidate
- **Server-Side Heavy Import**: On the server as well, statically importing heavy parsing libraries (HTML parsers, image processing, compression) at function top level burdens the cold start of every request that never uses them. Use a dynamic `await import()` inside the function and keep a baseline from bundle analysis (SHOULD)

### §94. The LCP & Lazy Loading Performance Protocol
- **Rule 33.96**: Above-the-Fold content optimization:
    - Hero images: Apply `priority` attribute. Do not Lazy Load
    - Below-the-Fold images: `loading="lazy"` mandatory
    - `<Suspense>` + Server Component: Progressive display of heavy content via streaming
- **Hidden-but-Rendered Ban**: CSS hiding (`display:none`, etc.) skips none of server rendering, hydration, DOM creation or image element count. Avoid rendering the same list twice for different widths and hiding one copy; switch a single DOM with responsive CSS (`overflow-x: auto` + scroll snap on mobile, grid on desktop) (SHOULD). Allow separate trees only when meaning or data genuinely differs by width, and make the inactive side lazy or a server-side branch
- **Hidden Subtree Lazy Images**: When elements inside the initial viewport are hidden by temporary pre-initialization CSS, `loading="lazy"` images beneath them never get an intersection check and never start loading. Make the initially visible images non-lazy (eager) (MUST). It does not reproduce with a warm browser cache, so measure as a first visit. Judge image loading behavior together with the CSS around it, and test the rendered attribute, not the expression that computes `loading` (MUST)
- **Slides-in-View SSOT**: "How many items are visible at once" is a value both the layout CSS and the image loading attributes depend on; make it a constant SSOT and machine-check its equality with the CSS value by test (MUST). Changing one side alone is a silent failure
- **Preload vs Eager Separation**: When the visible count changes responsively, separate preload (the single LCP candidate) from eager (up to the maximum visible count) and load the second and later at low priority — "discovered early, prioritized low" (SHOULD). Preload links cannot carry media queries and are fixed at SSR time, so preloading every item wastes bandwidth on narrow screens. Make `priority` / preload on shared display components opt-in rather than unconditional so only genuinely above-the-fold uses enable it. The presence of preloads is auditable by the number of `<link as="image">` in the SSR HTML
- **Carousel Adjacency Exception**: Do not leave a carousel's adjacent slide images `lazy` by mechanically applying the Below-the-Fold rule. Control them with a pure function that makes only the previous and next slide plus the first one eager (MUST) — loading starts only at the moment of the swipe and a black area shows until it arrives, while making everything eager fetches all images up front and degrades LCP. Apply neighbor-revealing effects (dimming, scaling) only under the layout condition (media query) where neighbors are actually visible, never on a single-slide surface (MUST) — opacity and brightness composite with the black background and darken twice. Match the library's transition speed to the CSS transition duration, and verify by measuring mean luminance and dark-pixel ratio of in-transition frames before and after (SHOULD)
- **LCP Entry Evidence**: A proposal to change UI behavior on LCP grounds (stopping or delaying autoplay) MUST come with a measured LCP entry (PerformanceObserver `largest-contentful-paint`). LCP only updates its candidate on a paint "larger than the current candidate", so later slides drawn into a same-sized frame never update it; "the switch pushes LCP later" is a hypothesis, not a fact. An optimization that stops autoplay must not make users perceive "it is not moving"; stop only for `prefers-reduced-motion` users and keep the pause affordance (hover / touch) (MUST)
- **The Lazy Fetch Sentinel Protocol**: Place the lazy-fetch sentinel on an element that is always visible (MUST). Inside a closed `<details>` or under `display:none` it never intersects, giving the least visible failure: "empty exactly at the moment it opens". For a sentinel inside a scroll frame, pass that frame as `root` (MUST) — omitting it means the viewport, and scrolling to the bottom of the frame never fires. Do not rely on intersection alone: also accept hover / focus / open as triggers and reject double fetches with a fetched set. Pre-fetch in two stages (SHOULD): approach of the frame itself (root=viewport) and the bottom of the frame (root=frame)
    - Triage "it does not fire" by measuring `getBoundingClientRect()` / `scrollHeight` / `clientHeight` and by re-attaching an observer with the same conditions on the page and reading `isIntersecting` directly (SHOULD). Measure seamlessness by imitating human scroll speed (e.g. about 800px/s) and checking "is the continuation already there when the frame is reached". All three "non-intersecting placements" pass type checks, lint and build

### §95. The Performance Regression Response
- **Rule 33.97**: Performance degradation response protocol:

| Priority | Condition | Action |
|:---------|:----------|:-------|
| **P0** | LCP > 4s or INP > 500ms | Immediate revert. Prioritize over all tasks |
| **P1** | LCP > 2.5s or INP > 200ms | Fix by next release |
| **P2** | Bundle Size Budget exceeded | Optimize within 2 sprints |

### §96. The Semicolon Guard (ASI Safety)
- **Rule 33.98**: Use semicolons to prevent unexpected behavior from ASI (Automatic Semicolon Insertion)

### §97. The Baseline Alignment Protocol
- **Rule 33.99**: When labels and form elements don't align at baseline, fix with `items-end` / `items-baseline`

### §98. The Code Input Standard
- **Rule 33.100**: Use syntax-highlighted editor components (Monaco Editor / CodeMirror) for code input fields, not plain `<textarea>`

### §307. The Long Animation Frames (LoAF) API Protocol

- **Rule 33.300**: Leverage the **Long Animation Frames (LoAF) API** to identify root causes of INP degradation
- **vs Long Tasks**: Long Tasks API detects tasks over 50ms but root cause identification is difficult. LoAF provides detailed data including per-script attribution and rendering time
- **Threshold**: Monitor `duration > 100ms`. `blockingDuration` is the metric directly correlated with INP
- **Script Attribution**: Identify causal scripts, execution types (`user-callback`, `event-listener`, `script-block`), and source URLs from the `scripts` array
- **CI Integration**: Integrate with RUM data and set alerts on p75 LoAF Duration degradation

```typescript
// ✅ INP debugging with LoAF API
const observer = new PerformanceObserver((list) => {
  for (const entry of list.getEntries()) {
    if (entry.duration > 100) {
      console.warn('Long Animation Frame:', {
        duration: entry.duration,
        blockingDuration: entry.blockingDuration,
        scripts: entry.scripts.map(s => ({
          sourceURL: s.sourceURL,
          invokerType: s.invokerType,
          duration: s.duration,
        })),
      });
    }
  }
});
observer.observe({ type: 'long-animation-frame', buffered: true });
```

### §308. The Scheduler.yield() API Protocol

- **Rule 33.301**: Leverage **`scheduler.yield()`** to avoid prolonged main thread blocking
- **INP Improvement**: Split long tasks with `scheduler.yield()` to ensure the browser has opportunities to respond to user interactions
- **vs setTimeout(0)**: `scheduler.yield()` prioritizes continuation of the main task. `setTimeout(0)` is pushed to the end of the task queue, degrading UX
- **Polyfill**: Cover unsupported browsers with the `scheduler-polyfill` package
- **React Integration**: Recommend combining with React's `startTransition` to schedule low-priority updates

```typescript
// ✅ Main thread release with scheduler.yield()
async function processLargeDataset(items: Item[]) {
  for (let i = 0; i < items.length; i++) {
    processItem(items[i]);
    if (i % 100 === 0) {
      await scheduler.yield(); // Release main thread every 100 items
    }
  }
}
```

---

## Part XIX: Image, Font & Script Optimization 🔀

### §99. The Image Optimization Protocol
- **Rule 33.101**: Use `next/image` (or equivalent optimization component) for images, guaranteeing:
    - Automatic format conversion (WebP / AVIF)
    - Responsive sizes (`sizes` attribute)
    - CLS prevention (`width`/`height` required, or `fill` + wrapper sizing)
    - CDN delivery (Cloudflare Image Transformations, etc.)
- **object-fit Co-Review**: A change that switches an image's `object-fit` between `cover` and `contain` MUST also decide whether the background color on the same element and its parent needs changing. The canonical rule is "Object-Fit & Background Co-Review" in `design/000_design_ux.md`.

### §100. The Image Size Budget

| Usage | Max Size | Format |
|:------|:---------|:-------|
| Hero / Banner | 200KB | WebP / AVIF |
| Thumbnail | 50KB | WebP |
| Icon / Logo | 10KB | SVG / WebP |
| OGP Image | 100KB | PNG / WebP |

### §101. The Font Optimization Protocol
- **Rule 33.102**: Self-host fonts with `next/font`, implementing:
    - `font-display: swap` to prevent FOIT (Flash of Invisible Text)
    - Subsetting to minimize file size
    - Preloading critical fonts

### §102. The Script Optimization Protocol
- **Rule 33.103**: Lazy load external scripts (Analytics, Chat Widget, etc.) with `next/script`:
    - **strategy**: `afterInteractive` (default) or `lazyOnload` (non-critical)
    - Scripts impacting CWV require `lazyOnload`

### §103. The AVIF First Protocol
- **Rule 33.104**: Image format priority: **AVIF > WebP > PNG/JPEG**. Set `formats: ['image/avif', 'image/webp']` in `next/image`

### §104. The SVG Optimization Protocol
- **Rule 33.105**: Optimize SVG icons by removing unnecessary metadata with `svgo`. Use `currentColor` in inline SVGs for theme support

### §105. The Responsive Image Protocol
- **Rule 33.106**: Set `sizes` attributes precisely for responsive images to prevent unnecessary large image downloads. Blanket `sizes="100vw"` is prohibited

---

## Part XX: SEO & Metadata 🌐

### §106. The Dynamic Metadata Protocol
- **Rule 33.107**: Implement `generateMetadata` on all public pages to generate dynamic title/description
- **Title Template**: Set `title: { template: '%s | ServiceName', default: 'ServiceName' }` in `layout.tsx`
- **Fallback**: Always define fallback metadata for DB fetch failures
- **Single Metadata Helper**: Metadata generation for every public detail route MUST go through one helper that emits OG, Twitter card, robots and canonical together. A page returning only `{ title, description }` loses the SNS preview and canonical and misses future spec changes. Detect routes that bypass the helper by script: scan dynamic routes and list files that have `generateMetadata` but no reference to the helper (SHOULD)

### §107. The Structured Data Protocol (JSON-LD)
- **Rule 33.108**: Implement type-safe JSON-LD schemas. Use typed libraries like `schema-dml`; handwritten JSON is prohibited
- **Required Types**: Business-relevant schemas: `Organization`, `WebSite`, `BreadcrumbList`, `FAQPage`, `Product`, etc.
    - **Proviso (Rich Result Eligibility)**: Do not emit a type whose required properties cannot be satisfied honestly. For rich-result-eligible types (`Product`, `SoftwareApplication`, `SocialMediaPosting`, etc.) confirm the required properties before choosing the type (e.g. `Product` needs `image` and completable purchase, `SoftwareApplication` needs `aggregateRating` or `review`); if they cannot be filled, keep only the semantics with a non-eligible type (`Service` + `offers`, `WebPage`, etc.) (MUST). Confirm a type's eligibility in the search platform's primary documentation. Failure pattern: an unsatisfiable type kept being emitted, stuck at "0 valid, 25 invalid", and the project's own rule prescribed that implementation. When in doubt, measure peers' production HTML (SHOULD)
- **Rule 33.108a (Eligibility First / Measured-vs-Fixed Check)**: Whether an external platform's display feature applies is decided by the page kinds and types the platform targets, not by how rich your structured data is. Confirm the targeted types and restrictions in official documentation before starting (MUST) — adding implementation on a non-targeted surface yields nothing. But where there are several evaluation axes (search rich results and AI search / GEO), never remove structured data that one axis ignores but the other reads (MUST NOT). Before spending effort on a monitoring screen's "unsupported" display, confirm whether that display is a measured value or a fixed (hard-coded) one (MUST)
- **Type Ledger & Complement Violation**: Consolidate the classification of emittable types (rich-result-eligible / non-eligible / prohibited) and each type's required properties into one ledger (constant), and treat any emitted type absent from the ledger as a violation (MUST) — rejecting dangerous types by name misses the next type added. The canonical rule is "Type Ledger" and "Mechanical Source Collection" in `product/500_growth_marketing.md`.
    - Source inspection sees only "the types that are written". Delivered JSON-LD varies with DB content, locale and section composition, so fetch production URLs daily, judge types, required properties, duplicates and parse failures with the same pure function, and file failures as issues (MUST)
- **Enum Value Constants**: schema.org enum value URLs (`https://schema.org/{EnumName}`, case-sensitive) MUST NOT be written as string literals; consolidate them into an `as const` constant SSOT. Even with a typed library the enum URL is a string, so a typo passes and the crawler merely treats it as "an unknown value" with no feedback to developers. Add a new schema in the order "check the official spec → add the enum to the constants → 0 warnings in the rich result test → 0 errors in Search Console". Detection: grep URLs containing `schema.org` for non-canonical patterns
- **Hierarchical Entities & Multiple Scripts**: Hierarchical list pages (regions, categories, organizational hierarchy) declare the parent-child relation not only with `ItemList` but with the page's own entity type (e.g. `AdministrativeArea` + `containedInPlace`) (SHOULD). The canonical rule is "Hierarchy & Co-location" in `product/500_growth_marketing.md`.

### §108. The Canonical URL Protocol
- **Rule 33.109**: Define `alternates: { canonical: url }` on all public pages to prevent SEO penalties from duplicate content
- **Trailing Slash**: Unify trailing slash usage project-wide (`next.config.ts` `trailingSlash`)
    - **Normalization Consistency Across Declarations**: The paths of public APIs and AI-facing endpoints MUST reference the same canonical URL (trailing slash included) everywhere: robots, llms.txt, OpenAPI, the proxy's auth-exclusion condition and the route implementation. Where trailing-slash normalization is on and the exclusion condition checks only the slash-less form, the public API returns `401`. Handle both forms in exclusion conditions. Cross-check crawler-facing allowed paths (llms.txt, robots) against real public routes, the sitemap and route constants, and never advertise a path that does not exist (MUST). Confirm public endpoints with real HTTP — `200` and the expected `Content-Type` — not just a successful build (MUST)
- **URL Key Normalization**: Exact-match lookups keyed by URL path (redirects, canonical, cache keys) MUST pass RFC 3986 §6.2.2.1 normalization first, such as lower-casing percent-encoding hex digits. Browsers and the Wayback Machine send the same URL with upper-case encoding, which misses the exact match and returns 404. Fixing by adding a row for another spelling of the same URI is prohibited (the next spelling slips through again). Green on representative samples does not mean green on the whole — build the population, check every member and run it daily (SHOULD)
- **URL Stability (Cool URIs)**: Splitting or adding list surfaces never changes detail URLs that are already indexed and linked (MUST). Reflect the split in navigation (the middle breadcrumb) and in the sitemap and analytics page type. Same-shaped list surfaces share one body and branch on display settings (heading, hero, translation namespace); never duplicate the page file (MUST NOT). Register new list URLs in the sitemap, the HTML sitemap and the in-house analytics page type at the same time (MUST)
- **Canonical via Route SSOT**: Build canonical URLs from the route definition SSOT helper (`ROUTE_PATHS.X(slug)` or equivalent), not hard-coded template literals (MUST) — it prevents stragglers when the route format changes. The canonical rule is "Canonical Construction" in `product/500_growth_marketing.md`.

### §109. The Dynamic OGP Protocol
- **Rule 33.110**: Generate OGP images dynamically with `@vercel/og` or `ImageResponse` to improve SNS share CTR
- **Dimensions**: Use 1200×630px (Facebook/LinkedIn standard) as baseline
- **No Fabricated Metadata**: When implementing a type requirement to "state metadata explicitly" (image dimensions, MIME type, modification date, etc.), first confirm you actually hold the value (MUST). The canonical rule is "No Fabricated Metadata" in `product/500_growth_marketing.md`.
- **OG Image Dimensions & Robots Directives**: The shared metadata function attaches `width / height / type` to OG images by default (MUST) — SNS crawlers can then fix the aspect ratio without fetching the image, avoiding cropping and blur. For indexable pages, attach `max-snippet:-1, max-image-preview:large, max-video-preview:-1` to `robots` by default, and on `noIndex` emit only the equivalent of `index:false, follow:false, nocache:true` (SHOULD). Detection: grep the `openGraph:` / `robots:` generation sites for missing dimensions and max-* directives

### §110. The Robots & Sitemap Protocol
- **Rule 33.111**: Implement `app/robots.ts` and `app/sitemap.ts` to ensure crawler access control and page discoverability
- **Dynamic Sitemap**: Retrieve page lists from DB and generate dynamic sitemaps
- **Disallow vs noindex**: URLs where `noindex` must take effect (login, registration, internally linked authenticated pages, etc.) MUST NOT be `Disallow`ed in robots. The crawler cannot read the `noindex` and the URL grows into "blocked but indexed". URLs that need noindex must be crawlable. On a small site, crawl-budget savings are outweighed by the harm of the contradiction between Disallow and noindex (SHOULD). Before appending to a config file, read the reasons for prohibition written in that file's own comments (MUST) — an addition that contradicts your own file's rationale can be stopped by its author before any review
- **Freshness Signal Sync**: Emit JSON-LD `dateModified` through the fallback chain `updated_at || created_at`; writing `created_at` directly broadcasts "always stale" and is prohibited (MUST NOT). The canonical rule is "Fallback Chain & Four-Channel Sync" in `product/500_growth_marketing.md`.

### §111. The Ghost Content Protocol (Time-Gated SEO)
- **Rule 33.112**: Set `noindex` on pre-publication content to prevent premature indexing by crawlers
- **Rule 33.112a (AI-training suppression is a separate mechanism)**: Pre-launch suppression MUST handle "search indexing" and "AI training" by different means. `noindex` (`X-Robots-Tag` / `meta robots`) is a search-engine standard; the only official opt-out for AI crawlers is a robots.txt `Disallow`. "It is noindex, so it will not be trained on either" does not hold. A search index entry can be removed on request later, but what has entered training data is effectively irrevocable, so the damage is asymmetric
    - Treat user agents separately and never give both the same setting (MUST NOT): search engines (`*`) stay `Allow` plus `noindex`; AI crawlers get `Disallow: /`. `Disallow`ing `*` stops crawlers from reading `noindex`, so existing index entries never disappear (see §110). Tie the post-launch GEO policy (explicit Allow for AI crawlers) to the same switch so it restores automatically on release (SHOULD). General form: assuming a standard "applies to all crawlers" leaves a blind spot for new kinds of crawler that do not adopt it — confirm "who honors what" in each vendor's primary documentation (MUST)
- **Authenticated Personal Pages**: Authenticated pages showing personal data SHOULD emit explicit noindex / nofollow / nocache and inherit it at layout level — if an authenticated crawler (an internal BI tool, a link unfurler) crawls the URL, the framework's default metadata implies `index: true`. After fetching, verify `entity.owner_id !== user.id` at page level and hide both "does not exist" and "ownership mismatch" behind the same not-found (MUST). Do not make RLS a single point of failure

### §112. The Microcopy Identity Protocol
- **Rule 33.113**: Unify error messages, labels, and placeholders with the service's Tone & Voice. Avoid generic expressions like "An error occurred"

---

## Part XXI: Technical SEO & GEO 🌐

### §113. The Semantic HTML Landmark Protocol
- **Rule 33.114**: Use semantic HTML elements (`<header>`, `<nav>`, `<main>`, `<article>`, `<aside>`, `<footer>`) to make page structure explicit
- **Heading Hierarchy**: Maintain logical heading structure without skipping levels: `<h1>` → `<h2>` → `<h3>`
- **Single H1 Rule**: Only **one** `<h1>` per page
- **Heading Rebase for Embedded Rich Text**: Heading levels an editor lets authors pick freely cannot be protected by correction at save time, neither for existing data nor for future input. When embedding body text into the page outline (h1=title, h2=section, h3=subsection…), rebase at render time — shift every heading by the same amount so the body's shallowest heading lands on the designated level — preserving relative hierarchy and clamping to 1–6 (MUST). Never rewrite the value in the DB. Rebase once on the pre-render JSON so SSR and the client render the same JSON (MUST) — rewriting HTML on one side only reverts at hydrate, and crawlers see the post-render DOM. Fix only the meaning (the tag) and keep the original visual level (carry the number of levels lifted in a wrapper class and restore it with CSS) (SHOULD). Pin with a truth table for the pure function and a "0 skipped levels" test on the rendered output

### §114. The SSR First Protocol
- **Rule 33.115**: Include critical content in the initial HTML via Server Side Rendering. Content rendered only client-side is recognized by crawlers with delay
- **AI Crawlers Do Not Execute JavaScript**: AI search crawlers execute no JavaScript, read only the initial HTML and do not revisit. Moving a public surface's body or internal links into client-side lazy loading is, from the AI's point of view, the same as deleting them (MUST, as a premise). When removing links from a shared block (sidebar, etc.), first place them via SSR where the context fits (e.g. links to child pages on the parent page), then remove; the reverse order is prohibited (MUST) — whatever was read while they were missing cannot be recovered. Decide whether removal is allowed from canonical and sitemap (MUST): a facet whose canonical normalizes to another URL and which is absent from the sitemap was never an index target, and stacking it on every page wastes crawl budget. AI body extraction uses link density as a feature to discard navigation and ads, so put links where the context fits rather than piling them into shared blocks (SHOULD)
- **No Streaming Boundary Around Public Body**: The children of a streaming-SSR deferred boundary (React Suspense, etc.) are streamed to the end of the document as hidden placeholders and swapped in by JS, so crawlers that execute no JS see only the skeleton. On public surfaces that must be visible to AI search, never place the H1, body, result lists or JSON-LD as children of a deferred boundary (MUST). Prioritize content arrival over TTFB. Treat this as a policy for all public surfaces rather than a per-detail-page decision, and keep the guard (test, lint) over the set of public routes instead of naming pages (SHOULD) — the detail page was fixed while three list pages still had it, showing the danger of stopping at individual decisions

### §115. The IndexNow Protocol
- **Rule 33.116**: Notify search engines immediately when content updates via IndexNow API, reducing waiting time for crawling

### §116. The GEO (Generative Engine Optimization) Protocol
- **Rule 33.117**: Implement the following optimizations for AI search engines (ChatGPT, Gemini, Perplexity, etc.):
    - FAQ structured data + concise answer paragraphs
    - `llms.txt` / `llms-full.txt` placement
    - E-E-A-T (Experience, Expertise, Authoritativeness, Trustworthiness) enhancement
- **Cross-Reference**: `ai/000_ai_engineering.md`

### §117. The Speculative Rules API Protocol
- **Rule 33.118**: Leverage the **Speculation Rules API** (`<script type="speculationrules">`) for browser-native prerendering and prefetching
- **Prerender**: Apply prerendering to links with high navigation probability (CTAs, main navigation, etc.)
- **Prefetch**: Apply prefetch (resource pre-read only) to uncertain links
- **Eagerness**: `moderate` (on hover or pointerdown) recommended. `eager` (immediate all) requires attention to resource consumption

```html
<script type="speculationrules">
{
  "prerender": [
    { "where": { "href_matches": "/dashboard/*" }, "eagerness": "moderate" }
  ],
  "prefetch": [
    { "where": { "selector_matches": "a[data-prefetch]" }, "eagerness": "moderate" }
  ]
}
</script>
```

---

## Part XXII: Accessibility (A11y) 🌐

### §118. The Accessibility Shift Left Protocol
- **Rule 33.119**: Accessibility is built into the design and development phase from the start (Shift Left), not fixed after release
- **CI Integration**: Integrate `axe-core` / `jest-axe` into CI pipeline for automatic A11y violation detection at PR level
- **Target**: WCAG 2.2 Level AA compliance
- **EAA 2025**: European Accessibility Act (EAA) effective June 2025. EN 301 549 compliance is a legal obligation for EU-market products

### §119. The Alt Text Mandate
- **Rule 33.120**: Set specific alt text in the operator's native language for content images. Omitting the `alt` attribute itself is **permanently prohibited**

| Image Type | Criteria | Bad ❌ | Good ✅ |
|:-----------|:---------|:-------|:--------|
| **Store/Facility Photo** | Name + Feature | `alt="photo1"` | `alt="Interior of Café XYZ in Shibuya"` |
| **Product Image** | Product Name + Feature | `alt="image"` | `alt="Organic Product Name 100g"` |
| **Map** | Area + Purpose | `alt="map"` | `alt="Pet-friendly café map around Central Park, New York"` |
| **Icon** | Icon's Meaning | `alt="icon"` | `alt="Rating: 4 stars"` |
| **Decorative** | Empty String | `alt="decoration"` | `alt=""` |

### §120. Screen Reader & Icon Labels
- **Rule 33.121**: Verify main flows with screen readers (VoiceOver/TalkBack) on real devices
- **Icon Labels**: Add `aria-label` attributes to icon-only buttons without text to clarify their function
- **Label + Hidden Icon Pair**: When the child of a `<button>` / `<a>` is an icon only (no text node), `aria-label` is required as a verb phrase describing the action (MUST), and the icon gets `aria-hidden="true"` at the same time to prevent double announcement (MUST). Where `outline-none` has removed it, add a `focus-visible` ring (MUST). A dynamic badge on the icon is `aria-hidden` if decorative, or included in the parent's `aria-label` if meaningful
    - **Lint does not catch everything**: `jsx-a11y/control-has-associated-label` analyzes child text shallowly and lets `<button><Icon/></button>` through. In audits, run a source-scan heuristic that extracts buttons without `aria-label` / `title` and lists those whose inner text is empty after stripping tags and expressions, then review the candidates (false positives included) by eye (SHOULD). The same rule regressed in several places on record, so an active scan is required

### §121. WAI-ARIA Protocol
- **Rule 33.122**: "No ARIA is better than Bad ARIA." Use native HTML elements wherever possible and keep ARIA attributes minimal
- **Radix UI / Headless UI**: Use accessible headless UI libraries for complex components

### §122. The Focus Management Protocol
- **Rule 33.123**: Trap focus within modals/dialogs on open and return focus to the trigger element on close
- **Focus Visible**: Apply styles only with `:focus-visible` for keyboard focus and eliminate unnecessary focus rings on mouse clicks

### §123. The Color Contrast Protocol
- **Rule 33.124**: Text contrast ratios must meet WCAG 2.2 AA standards:
    - Normal text: **4.5:1** or above
    - Large text (18px+): **3:1** or above
    - UI components: **3:1** or above

### §124. The Reduced Motion Protocol
- **Rule 33.125**: Implement `prefers-reduced-motion: reduce` media query and disable animations for motion-sensitive users

---

## Part XXIII: PWA & Cross-Platform 🌐

### §125. PWA Standard
- **Rule 33.126**: Define PWA meta information in `manifest.json`, configuring icons, theme color, and display mode
- **Service Worker**: Offline cache strategy defaults to `Cache First` (static assets) + `Network First` (API)

### §126. Deep Linking
- **Rule 33.127**: Configure `universal links` (iOS) / `app links` (Android) for proper routing from web links to native apps

### §127. Server Actions (PWA Context)
- **Rule 33.128**: Server Actions in PWA environments must implement offline fallback handling

### §128. Web Push Notifications
- **Rule 33.129**: Request Web Push notification permission only after explicit user opt-in (CTA). Permission requests immediately after page load are prohibited
- **Invalid Destination Hygiene**: Push destination identifiers (device tokens, endpoints, etc.) MUST be deleted immediately when the delivery service returns an invalid response (`410 Gone` / `NotRegistered` or equivalent) — continuing to send to invalid destinations degrades sender reputation and leads to blocking. Refresh the identifier at startup, purge long-unused identifiers periodically, and monitor the invalid rate with an alert above a threshold (e.g. 10%) (SHOULD)

### §129. The Install Prompt Protocol
- **Rule 33.130**: Improve PWA install rates with custom install prompts. Capture `beforeinstallprompt` event and display at appropriate timing
- **Display Conditions**: Show the custom install prompt only when all conditions hold — interest (visit-count threshold, e.g. 3+), dwell (session-time threshold, e.g. 60s+) and dismissal history (not closed within the last N days, e.g. 30) (MUST) — an immediate prompt on the first visit breeds distrust. Explain the benefit in a non-modal banner before triggering the native prompt, and measure the ratio of prompts shown to installs completed (SHOULD). The Blueprint sets the thresholds

---

## Part XXIV: Internationalization (i18n) 🌐

### §130. Multi-Language Architecture
- **Rule 33.131**: Use `Sub-Directory` approach (`/ja/about`, `/en/about`) as standard for i18n. Domain separation is not recommended due to high cost and operational burden
- **next-intl / next-i18n-router**: Use i18n libraries with mature Next.js App Router integration

### §131. UTC Time Storage
- **Rule 33.132**: Always store date/time data in **UTC** in DB and convert to user timezone at display time
- **Formatter**: Execute timezone conversion with `Intl.DateTimeFormat` or `date-fns-tz`

### §132. Locale Management
- **Rule 33.133**: Locale detection priority: URL path > Cookie > Accept-Language header
- **Locale-Prefixed Path Matching**: In sub-directory i18n, every comparison of the current path against route constants (current-location detection in navigation, showing components only on specific pages, maintenance exclusions, breadcrumbs, etc.) MUST first pass through one shared function that strips the locale prefix. When the default locale has no prefix, a forgotten strip works correctly in the default locale and breaks features simultaneously only in non-default locales (5 places were broken at once). Review cannot catch it, so add an automated test that scans usages of the path-reading API and reports comparisons that skip normalization, with file names (SHOULD)
- **Locale Verification by Body Text**: Request-dependent locale resolution is structurally impossible in statically rendered segments, and when layout and page differ in dynamism you get "half-translated HTML". Verify locale-dependent display by the actual body wording, not `<html lang>` or metadata (MUST) — lang comes from the layout and is fixed first, making it the most misleading indicator — and always against a server running the target working tree (MUST). The permanent fix is to promote locale into the route structure and cache key

### §133. Translation Workflow
- **Rule 33.134**: Split i18n dictionary files (JSON/TS) by namespace and lazy load per page
- **Missing Key Handling**: When translation keys are missing, display fallback language text or the key itself. Rendering empty strings or undefined is prohibited
- **Operator-Entered Values Are Single-Locale**: Settings operators enter through the admin screen or CMS (labels, notes, etc.) are values for the default locale only unless they carry a locale dimension. The fallback order `operatorValue || dictionary` never uses the dictionary as long as a value exists, so the default language leaks into non-default locales. In non-default locales prefer the dictionary and adopt operator values only in the default locale, or add per-locale columns (MUST). Treat fixed wording returned by server code the same way, and prefer returning error codes over text (SHOULD, see `core/200_language_protocol.md`)

---

## Part XXV: Error Handling & Resilience 🔀

### §134. Error Boundary
- **Rule 33.135**: Place `error.tsx` (App Router error boundary) in all route segments to prevent unhandled exceptions from showing white screens to users
- **Recovery**: Include "Retry" buttons in error UI to enable user recovery actions
- **Client Exception Safety Boundary**: Never wire the `message` of an unknown exception caught on the client straight into a toast / alert / inline text. Place one sanitizing boundary that lets only user-facing wording through and maps any text containing internal vocabulary (token / secret / service_role / constraint / vendor names) to a per-operation fallback (MUST). When each component decides "probably safe", internal wording flows into the screen, screenshots and the error tracker's breadcrumbs. A `result.error` the server intentionally returned is treated as already sanitized at that boundary
- **Capture Coverage ≠ PII Scrub**: Error-tracker auto-instrumentation does not capture the "catch and return a structured response" pattern, so consolidate logger.error + capture into one helper and tag it with `source` (`api:*` / `cron:*` / `webhook:*` / `action:*` / `segment:*`) (SHOULD). The canonical rule is "Capture Coverage ≠ PII Scrub" in `operations/400_site_reliability.md`.

### §135. Global Error Handling
- **Rule 33.136**: Catch fatal errors including RootLayout with `global-error.tsx` and display custom error pages

### §136. Not Found Handling
- **Rule 33.137**: Customize `not-found.tsx` to provide useful navigation (home, search, etc.) on 404
- **The Streaming Soft-404 Protocol**: In streaming SSR, throwing `notFound()` inside a loading / Suspense boundary cannot change the status once the shell has been flushed with 200 (soft-404). Where a root-level `loading.tsx` creates the boundary, the throw is caught whether it comes from the page body or `generateMetadata`. Routes that need a true 404 MUST perform a light existence check in blocking position (outside the boundary) and keep only the heavy body inside it
    - As an immediate remedy, guarantee noindex whenever a dynamic route's entity is missing, closing off index pollution (MUST) — the real harm stops even with the status still 200. Verify by measuring the production build, not by reading code, and check both the HTTP status and the robots meta (MUST). Never conclude "there is a `notFound()`, so it is a 404" from reading alone (MUST NOT) — static reading misjudged this on record. When adding a missing-entity branch to the metadata side, first confirm the same ID resolution at the top of that branch so you do not kill the body's "alternative resolution → redirect" path (legacy IDs, etc.) (MUST)

### §137. Offline & Network Resilience
- **Rule 33.138**: API call failure handling:
    - Auto-retry (exponential backoff, max 3 times)
    - Offline detection (`navigator.onLine` / `online`/`offline` events)
    - Optimistic updates + rollback
- **Empty ≠ Error**: A data-fetching layer that returns lists, counts or state returns a value that distinguishes "0 items" from "fetch failed" (`status: 'ok' | 'error'`, etc.), never representing failure as an empty array or 0 (MUST NOT). On failure the UI shows an error and a retry affordance, never the empty-state copy ("You have no …") (MUST). Design the empty state and the failure state as separate components (see `design/000_design_ux.md`)

### §138. Console Warning Protocol
- **Rule 33.139**: `console.error` and `console.warn` are evidence of development failure. Fix all `console.error` calls or replace with proper `Logger`
- **Same-Message Flood Is a Root-Cause Signal**: Never leave a flood of console warnings with identical wording as noise (MUST NOT). The higher the count, the more likely it is the root cause (e.g. a major-version incompatibility between the rendering library and the framework, see §5)

### §139. Graceful Degradation Protocol
- **Rule 33.140**: Loading failures of external services (Analytics, Chat, Ad, etc.) must not impede the app's primary functionality. Isolate with `try-catch` and display fallbacks
- **Terminal Placeholder Mandate**: An N-stage fallback over external dependencies (primary fetch → alternative embed → …) MUST always provide an explicit terminal display (stage N+1) for when every stage fails. Without the terminal case the UX collapses into a blank box, an endless spinner or silent failure. Fall to the terminal when the inputs of every stage are all empty / null. The terminal display conveys the failure to assistive technology as well (`role="img"` + a descriptive label, etc.) (MUST), and tests cover every stage's output branch at the SSR / render level (SHOULD)

---

## Part XXVI: Server Actions & API Safety ⚛️

### §140. Server Actions Core Principles
- **Rule 33.141**: Place `'use server'` directive at the top of the file to define the entire file as a Server Action file. Inline `'use server'` is prohibited
- **Auth Guard**: Execute authentication checks at the beginning of all Server Actions. Unauthenticated Server Actions are prohibited in principle
- **Every Export Is an Endpoint**: Every export of a file declaring `'use server'` is treated as a public endpoint callable anonymously (MUST). "It is only called internally on the server" is no justification (the caller's circumstances are not a defense). Do not co-locate cron jobs, internal aggregation or privileged writes in Server Actions (MUST NOT); move them to ordinary `server-only` modules so they stop being endpoints at all — adding a gate is second best, removing the attack surface is best. Where one remains, run the gate inside that function itself (another export in the same file being guarded is irrelevant). Clamp externally supplied numbers (windows, counts, look-back days) to bounds (MUST)
    - **Machine detection**: Build into lint the check "does an export that uses the privileged client directly also contain a gate-like call", keep intentionally anonymous-callable exceptions in a ledger with reasons, and also check the population size and stale grants (SHOULD). In one measurement, 1 of several hundred exports was an unauthenticated privileged write
- **DB-Hidden Columns Stay Hidden in DTOs**: A path that reads with a privileged client (credentials bypassing RLS / column GRANTs) and converts to a public DTO circumvents the DB-side exposure limits. Columns hidden from anonymous users in the DB are dropped on the DTO side too, with a "behavioral cross-check" test that loads the DB-side expected set and asserts none of it survives in DTO output (MUST). The reverse direction (added to the DTO but missing from the DB ledger) turns CI red while this direction turns nothing red, so make the cross-check bidirectional (SHOULD). Do not read server-only values from the public DTO; split out a server-only reader that selects only the needed columns (see `engineering/200_supabase_architecture.md` Rule 2.9)

### §141. Return Type Safety
- **Rule 33.142**: Server Action return values must be serializable types only. Returning `Date` objects, functions, class instances is prohibited

### §142. Rate Limiting
- **Rule 33.143**: Implement rate limiting for public Server Actions (Contact Form submission, etc.)
- **Entry Order**: The entry order of an externally reachable endpoint is "① format validation of params / path / IDs (immediate 400) → ② rate limit → ③ persistence access" (SHOULD). The canonical rule is "Entry Order" in `engineering/100_api_integration.md`.
- **Public Analytics Actions**: Analytics writes originating from public pages (view / search / click logs) are handled with optional authentication (anonymous is a normal case as null, never an exception), IP rate limiting and format validation of caller-supplied IDs; privileged-client updates are restricted to rows in a public state, and on failure only the log write is skipped — the page still renders (MUST). The canonical rule is "Public Analytics & Observation Endpoints" in `security/000_security_privacy.md`.

### §143. File Upload via Server Actions
- **Rule 33.144**: Pass file uploads to Server Actions via `FormData` and execute server-side validation (file type, size, magic byte verification)

### §144. Mutation Side Effects
- **Rule 33.145**: After data changes (CUD operations) in Server Actions, explicitly invalidate related caches with `revalidateTag()`
- **Invalidation Wiring Before Caching**: A change that adds or extends a cross-request cache MUST enumerate and prove that every mutation path that can change the cached read (create, update, delete, bulk operations) fires the same invalidation tag. Without that proof it is a TTL-dependent staleness regression, and the cache addition is held back. "Path-level invalidation (`revalidatePath`)" and "data-cache invalidation (`revalidateTag`)" are separate mechanisms; never assume the former clears the latter (MUST NOT). When several modules hold different tag schemes for the same data, tag standardization comes first (see `engineering/730_caching_discipline.md`)

### §145. The API Key Isolation Protocol
- **Rule 33.146**: API keys must not be exposed to the client with `NEXT_PUBLIC_` prefix. All API keys are used only in Server Actions / Route Handlers
- **Cross-Reference**: `security/000_security_privacy.md`

### §146. The Input Sanitization Protocol
- **Rule 33.147**: Validate user input passed to Server Actions with `zod`, then execute sanitization as needed. Using raw user input directly in DB queries or HTML output is prohibited
- **Filter Syntax Delimiter Neutralization**: When user input is embedded as a string into a query builder or REST filter language (PostgREST `.or()`, etc.), replace or remove that filter language's syntactic delimiters (commas, parentheses, dots, etc.) immediately before issuing the query (MUST; e.g. `query.replace(/[,()]/g, ' ')`). A filter string that is not parameterized is an injection surface just like SQL, and "a query builder is safe" is a misconception. Neutralize inside the function that assembles the query, separately from the validation layer, leaving no bypass route (SHOULD)

---

## Part XXVII: Data Visualization & Export 🔀

### §147. Chart Libraries
- **Rule 33.148**: Use `Recharts` or `Chart.js` for charts and always lazy load with `next/dynamic`
- **Responsive**: Responsive SVG-based charts recommended (Recharts)
- **Accessibility**: Provide `aria-label` and text alternatives (data tables) for charts

### §148. PDF Export
- **Rule 33.149**: Execute PDF generation server-side (`@react-pdf/renderer` or Puppeteer)

### §149. CSV Export
- **Rule 33.150**: Unify encoding (UTF-8 with BOM) for CSV export using libraries like `papaparse` to ensure Excel compatibility

### §150. Data Table Protocol
- **Rule 33.151**: Use `@tanstack/react-table` for data tables, implementing sort, filter, pagination, and column selection. SSR support for tables via `<Suspense>` progressive display

---

## Part XXVIII: AdTech & Marketing Engineering 🌐

### §151. The OGP Dynamic Generation Protocol
- **Rule 33.152**: Dynamically set OGP (Open Graph Protocol) meta tags on all public pages
- **Image Generation**: Generate dynamic OGP images with `@vercel/og` to improve SNS share CTR

### §152. Conversion API (CAPI) Integration
- **Rule 33.153**: Implement server-side Conversion APIs (Meta CAPI, Google Enhanced Conversions, etc.) to bypass browser-side tracking blockers

### §153. Privacy-First Tracking
- **Rule 33.154**: Determine cookie consent, notice, refusal and third-party sharing requirements from applicable jurisdictions and actual data flows; do not classify Japan as universally opt-out. Verify local primary sources, including the [PPC APPI FAQ](https://www.ppc.go.jp/personalinfo/faq/APPI_QA/) when Japan is in scope.
- **Consent Management**: Control tracking script loading based on user consent state

### §155b. The Post-Privacy Sandbox Tracking Strategy

- **Rule 33.328**: Google Privacy Sandbox was **officially discontinued in October 2025**. Third-party cookies persist in Chromium browsers for the foreseeable future, but promote migration to the following privacy APIs:
    - **CHIPS (Cookies Having Independent Partitioned State)**: Secure cross-site data management with partitioned cookies
    - **FedCM (Federated Credential Management)**: Federated login protocol without third-party cookie dependency
    - **Private State Tokens**: Bot detection and user trust verification without cookies
- **Strategic Shift**: Migration to server-side tracking (§152 CAPI integration) is accelerating. Incrementally reduce client-side cookie dependency
- **ITP/ETP Compliance**: Safari (ITP) and Firefox (ETP) already effectively block third-party cookies. Design architecture that does not rely on Chromium cookie persistence
- **Cross-Reference**: `ai/100_data_analytics.md`, `security/000_security_privacy.md`

### §154. UTM Parameter Management
- **Rule 33.155**: Parse and store UTM parameters via Server Actions for marketing attribution analysis

### §155. Affiliate Link Protocol
- **Rule 33.156**: Load external affiliate links asynchronously with `next/script` to minimize main thread impact

---

## Part XXIX: Testing Strategy 🔀

### §156. Testing Trophy
- **Rule 33.157**: Follow the "Testing Trophy" model:
    - **Static Analysis** (ESLint + TypeScript): Lowest cost, highest coverage
    - **Unit Tests** (Vitest): Pure functions, utilities, validation logic
    - **Integration Tests** (Vitest + Testing Library): Components + hooks
    - **E2E Tests** (Playwright): Critical user flows

### §157. Unit Test Standards
- **Rule 33.158**: Use Vitest as the standard test runner. Jest is deprecated for new projects
- **Coverage Target**: Target **80%** coverage for business logic layers (`lib/`, `utils/`)

### §158. Component Testing
- **Rule 33.159**: Test component **user behavior** with React Testing Library. Testing implementation details (state, props) is prohibited

### §159. E2E Testing
- **Rule 33.160**: Use Playwright as the standard E2E testing tool
- **Critical Paths**: E2E must cover critical flows such as login, signup, payments, content creation

### §160. Visual Regression Testing (VRT)
- **Rule 33.161**: Detect unintended UI changes through Storybook snapshots or Playwright screenshot comparison

### §161. Lighthouse CI
- **Rule 33.162**: Integrate Lighthouse CI into PR pipeline for automatic detection of performance, SEO, and A11y score degradation
- **Threshold**: Performance ≥ 90, Accessibility ≥ 90, SEO ≥ 90
- **Mobile-First Measurement**: The measurement condition of the performance gate defaults to the most constrained environment in the user distribution (mobile simulation with a slow network and CPU throttling) (MUST). A pass on desktop conditions alone is invalid; the Blueprint sets the mobile thresholds. State the conditions (device, network, throttling factor) in the CI config and alongside the report (SHOULD) — a gate with unfixed conditions passes on "it is fast on PC". Never compare scores taken under different conditions

### §162. Storybook
- **Rule 33.163**: Catalog common UI components in Storybook and maintain as interactive documentation
- **Play Function**: Auto-test user interactions with Play Functions

### §163. Server Component Testing
- **Rule 33.164**: Test RSC with `next/test` utilities or integration tests. Use test DBs instead of mocking RSC-specific data fetch logic

---

## Part XXX: Deployment & Infrastructure 🔀

### §164. Vercel Deployment
- **Rule 33.165**: Use Vercel as the standard hosting platform
- **Preview Deployments**: Auto-deploy Preview environments for all PRs to improve code review quality

### §165. ISR (Incremental Static Regeneration)
- **Rule 33.166**: Apply ISR to static content (blog, product pages, etc.). Set `revalidate` values based on content update frequency (default: 3600 seconds)
- **Revalidated Static as Default**: Public list and index pages avoid both extremes — per-request generation (cost, TTFB, crawler load) and fully static (new items never appear) — and default to revalidated static generation scaled to the update frequency, combined with on-demand invalidation on the write side (SHOULD). Whole-page static candidates are limited to pages meeting all four conditions: (a) path params only, (b) no auth state read, (c) public read-only data, (d) update frequency longer than the revalidation interval (MUST) — a page with per-request input such as query strings is inherently dynamic and explodes if included in the cache key
    - Exclude auth-dependent and user-specific pages from static generation entirely and declare the intent explicitly (MUST) — cross-user cache leakage is a serious security incident. For pages with dynamic input choose among (1) promoting the input into the path, (2) static shell + dynamic fragments, (3) caching at the data-fetching-function level (SHOULD). Audit by mechanically listing "pages without revalidation" and pre-filtering by presence of dynamic input before nominating candidates

### §166. Edge Config
- **Rule 33.167**: Manage Feature Flags, A/B test settings, redirect rules, etc. in Edge Config (Vercel Edge Config, etc.) for instant changes without deployment

### §167. CDN Strategy
- **Rule 33.168**: Static asset delivery (images, fonts, CSS/JS) via **CDN** is mandatory
- **Cache-Control**: `public, max-age=31536000, immutable` (hashed assets)
- **Delivery-Layer-First Diagnosis**: Investigate perceived slowness or repeated fetching of static assets by measuring the delivery layer before optimizing components or loaders (MUST): whether transformation (resize / format) actually takes effect, the real `Cache-Control` header, and CDN hit / miss status via curl. Assets without cache-control (served `no-cache`) can coexist depending on the upload path. Image transformation is often disabled in development, so judge srcset / preload effectiveness and LCP on a production-equivalent delivery setup and never cite dev-environment latency as evidence (MUST NOT)
    - A delivery path that switches on when a setting is provided (a CDN / proxy enabled by an environment variable) has never been verified end to end as long as the value is absent — in one case setting the production value would have taken down every image at once. Verify the path end to end with real URLs before setting the value in production (MUST). In diagnosis, use the difference between error codes ("reaches format-invalid" = the transformer itself runs / "rejected" = blocked upstream) to separate "is transformation enabled" from "is this source allowed" (SHOULD)

### §168. Production Monitoring
- **Rule 33.169**: Implement the following monitoring in production:
    - **Error Tracking**: Error tracking services like Sentry
    - **RUM (Real User Monitoring)**: Collect real user CWV data
    - **Alerting**: Alerts on CWV degradation, error rate increase, latency increase

### §169. Environment Separation Protocol
- **Rule 33.170**: Properly separate environment variables across production/staging/preview. Physically prevent production environment variables from leaking to preview environments

---

## Part XXXI: Modern Web Platform APIs 🌐

### §170. The View Transitions API Protocol
- **Rule 33.171**: Leverage the **View Transitions API** for browser-native smooth animations on page transitions and UI state changes
- **Same-Document**: Use `document.startViewTransition()` for SPA navigation
- **Cross-Document**: Configure cross-document transitions for MPA with `@view-transition` at-rule
- **CSS Customization**: Customize animations with `::view-transition-old` / `::view-transition-new` pseudo-elements
- **Next.js Integration**: Implement View Transitions on route transitions by combining with `next/navigation`'s `useRouter`

### §171. The CSS Anchor Positioning Protocol
- **Rule 33.172**: Leverage **CSS Anchor Positioning** to implement tooltip, popover, and dropdown positioning with pure CSS
- **JavaScript Reduction**: Gradually reduce dependency on JS libraries like Floating UI / Popper.js
- **Fallback**: Provide fallback with `@supports (anchor-name: --anchor)` when browser support is insufficient

### §172. The CSS Scope Protocol
- **Rule 33.173**: Use `@scope` at-rule to make CSS scoping explicit and prevent style pollution between components
- **Design System**: Limit design system token application scope with `@scope` to eliminate unintended cascading

### §173. The Popover API Protocol
- **Rule 33.174**: Leverage HTML `popover` attribute for browser-native API implementation of popovers, tooltips, and toasts
- **Top Layer**: Popover API automatically places elements in the Top Layer, eliminating z-index management

### §174. The Dialog Element Protocol
- **Rule 33.175**: Use `<dialog>` element's `showModal()` for modal dialogs. More semantic, accessible, and safe than custom modal implementations
- **The Always-Mounted Drawer Protocol**: UI that opens and closes while always mounted MUST NOT use modal primitives designed on the premise "mounted = active" (e.g. scroll lock tied unconditionally to mount). Read the library's distributed code (dist) to confirm its premises. If hand-built, provide equivalent a11y (`role="dialog"` / `aria-modal` / Escape / Tab trap / focus return). For containment in the closed state, prefer the `inert` attribute (SHOULD) — one attribute removes focus, assistive technology and pointer at once and survives SSR
    - When removing the Portal so the panel exists in SSR HTML, render it outside any ancestor with `transform` / `filter` / `perspective` (MUST) — a transformed ancestor becomes the containing block of `position: fixed` and traps the panel in the ancestor's box. Pin the placement with a source test. Where the declarative UI framework registers wheel / touchmove as passive, `preventDefault` inside a JSX handler is a no-op, so attach a native non-passive listener only while open (MUST). Confirm with a functional test that dispatches a synthetic event and reads `defaultPrevented`. Verify as a pair: on the SSR side, curl and grep for the presence of the attributes and transform (negative side too); on the behavior side, capture intermediate frames in both opening and closing directions (MUST). This is the exception to the Portal mandate in `design/000_design_ux.md` (always-mounted UI that must exist in SSR)

### §175. The Scroll-Driven Animations Protocol
- **Rule 33.176**: Use CSS `animation-timeline: scroll()` or `animation-timeline: view()` for scroll-linked animations, replacing JavaScript `scroll` event + `requestAnimationFrame` patterns

### §176. The CSS Nesting Protocol
- **Rule 33.177**: When native CSS Nesting (`&` selector) is available, gradually reduce dependency on Sass and PostCSS Nesting plugins

### §177. The CSS `@property` Protocol
- **Rule 33.178**: Use `@property` at-rule to declare types, initial values, and inheritance for CSS Custom Properties. Enable custom property animations (gradient transitions, etc.)

### §178. The CSS `@starting-style` Protocol
- **Rule 33.179**: Leverage `@starting-style` for CSS-only entry animations on elements appearing from `display: none`. Implement fade-in and slide-in without JavaScript

### §179. The CSS Grid Lanes (Masonry) Protocol
- **Rule 33.180**: Once CSS Grid Level Masonry Layout (`grid-template-rows: masonry`) stabilizes, gradually replace JavaScript-based Masonry libraries (Masonry.js, etc.)
- **Progressive Enhancement**: Feature detect with `@supports (grid-template-rows: masonry)` and fall back to CSS-native implementation

### §309. The Navigation API Protocol

- **Rule 33.302**: Leverage the **Navigation API** for browser-native SPA navigation control
- **vs History API**: Provides more intuitive event-driven navigation than the History API
- **`navigate` Event**: Intercept all navigation with `navigation.addEventListener('navigate', ...)`
- **Transition Support**: Intercept navigation with `NavigateEvent.intercept()` to perform data fetching and animations
- **State Management**: Safely reference navigation history state with `navigation.entries()`
- **Framework Note**: Next.js App Router manages routing internally. Direct usage is limited to framework-independent cases

```typescript
// ✅ SPA navigation control with Navigation API
navigation.addEventListener('navigate', (event) => {
  if (!event.canIntercept) return;
  const url = new URL(event.destination.url);

  if (url.pathname.startsWith('/app/')) {
    event.intercept({
      async handler() {
        const content = await fetchPageContent(url.pathname);
        renderPage(content);
      },
    });
  }
});
```

### §310. The CSS `color-mix()` & Relative Color Syntax Protocol

- **Rule 33.303**: Leverage CSS `color-mix()` function and **Relative Color Syntax** for dynamic color manipulation of design tokens in pure CSS
- **color-mix()**: Mix two colors at any ratio (`color-mix(in oklch, var(--primary), white 20%)`)
- **Relative Color Syntax**: Modify opacity, saturation, and lightness based on existing colors (`oklch(from var(--primary) l c h / 50%)`)
- **Design System**: Dynamically generate hover, active, and disabled state colors from base colors, reducing token count
- **Color Space**: Recommend `oklch` / `oklab`. Perceptually uniform linear interpolation produces natural color mixing results

```css
/* ✅ color-mix() and Relative Color Syntax */
:root {
  --primary: oklch(0.65 0.25 265);
  --primary-hover: color-mix(in oklch, var(--primary), white 15%);
  --primary-active: color-mix(in oklch, var(--primary), black 10%);
  --primary-ghost: oklch(from var(--primary) l c h / 10%);
}
```

---

## Part XXXII: Frontend Observability & RUM 🌐

### §180. Real User Monitoring (RUM)
- **Rule 33.181**: Implement RUM (Real User Monitoring) in production to detect discrepancies with Lighthouse CI (Lab Data)
- **CWV RUM**: Collect LCP / INP / CLS as real user data with the `web-vitals` library
- **Percentile Tracking**: Track at p75 / p95 / p99 percentiles

### §181. OpenTelemetry Browser SDK
- **Rule 33.182**: Introduce **OpenTelemetry Browser SDK** for frontend-specific traces and integrate with backend traces
- **Span**: Measure spans for page load, navigation, API calls, and user interactions

### §182. Error Boundary Telemetry
- **Rule 33.183**: Automatically send errors caught by Error Boundary to error tracking services like Sentry
- **Context**: Include user ID, page URL, component stack, and last user action when sending errors

### §183. Performance Budget Monitoring
- **Rule 33.184**: Integrate bundle size and initial load time budget monitoring into CI, automatically blocking PRs on budget overruns

### §184. Custom Metrics
- **Rule 33.185**: Define and measure business-specific custom metrics (Time to First Search Result, Time to First Meaningful Paint, etc.)

### §185. Session Replay
- **Rule 33.186**: Introduce session replay (Sentry Session Replay, etc.) for error reproduction. However, PII (Personally Identifiable Information) masking is mandatory
- **Rule 33.186b (Sensitive-Screen Stop Gate)**: When writing a gate that stops a third-party SDK (session recording, analytics, ads) on sensitive screens, confirm how "stop / resume" behaves on four facets — (a) whether data is sent, (b) recording mode, (c) sampling rate, (d) persistence (sticky session) — by reading the distributed implementation, not the public documentation (MUST) — masking still leaves URL, dwell time and interactions, and some SDKs' `stop()` / `start()` ignore the sampling rate. Pin the confirmed premises with a unit test that reads the SDK's distributed code so an SDK update that changes them turns red (SHOULD). Verify the stop order down to the framework's effect execution order (insertion → layout → passive), and if the public API has no "stop without sending", keep an envelope filter right before transmission as the final layer

---

## Part XXXIII: AI Integration & LLM Streaming UI 🔀

### §186. AI Copilot UI
- **Rule 33.187**: Adhere to the following patterns for AI assistant/chatbot UI:
    - **Streaming Display**: Token-by-token streaming rendering via SSE / WebSocket
    - **Skeleton State**: Display structured Skeleton loading while awaiting AI response
    - **Stop Generation**: Provide a button for users to interrupt generation
- **Vercel AI SDK**: Leverage `ai` package's `useChat` / `useCompletion` hooks for declarative streaming UI implementation

### §187. The Citation Transparency Protocol
- **Rule 33.188**: Display source citations and reference links for AI-generated content. AI responses without evidence should display "This AI response is for reference only" disclaimer
- **Cross-Reference**: `ai/000_ai_engineering.md`

### §188. The AI Content Rendering Safety Protocol
- **Rule 33.189**: Sanitization (DOMPurify, etc.) is mandatory for HTML/Markdown rendering of AI-generated text. Prevent XSS injection

### §189. The Optimistic AI Response Protocol
- **Rule 33.190**: Display progress indicators during AI task execution (summarization, translation, etc.) and replace with results upon completion

### §190. The AI Rate Limiting UI Protocol
- **Rule 33.191**: Display user-friendly messages ("Please wait a moment") and estimated wait times when AI service rate limits are reached
- **Cost Friction Design**: UI that automatically triggers expensive processing from input (generative AI, external APIs, heavy search) MUST debounce at the UI level for a fixed interval after input stops (e.g. 800ms). Actions whose single execution is expensive MUST NOT fire on one click; use a two-stage design where a "final run" button fires after options are chosen — structurally preventing cost waste from mis-clicks. When the limit is reached, phrase the message in the brand tone and add an estimate of when it resumes (see `design/000_design_ux.md` The Quota Framing Protocol)

### §191. The AI Accessibility Protocol
- **Rule 33.192**: Notify screen readers of AI-generated content progressively with `aria-live="polite"`

---

## Part XXXIV: Micro-Frontend & Module Federation 🌐

### §192. Micro-Frontend Applicability Criteria
- **Rule 33.193**: Apply Micro-Frontend only when the following conditions are met:
    - Multiple teams independently develop different UI areas of the same app
    - Deployment independence is mandatory
    - Different tech stacks (React + Vue, etc.) need integration
- **Warning**: Over-engineering for small-to-medium single-team projects. Monolithic App Router recommended

### §193. Module Federation 2.0
- **Rule 33.194**: Use **Module Federation 2.0** (Webpack/Rspack) for Micro-Frontend implementation, enabling runtime dependency sharing and version management
- **Shared Dependencies**: Configure React / React DOM as singleton sharing to prevent duplicate loading

### §194. Micro-Frontend Communication
- **Rule 33.195**: Use **Custom Events** or **shared Event Bus** for inter-Micro-Frontend communication. Direct import/export dependencies are prohibited

### §195. Shared Design System
- **Rule 33.196**: In Micro-Frontend environments, publish the design system as an independent package for all teams to share the same UI/UX standards

### §196. Independent Deployment Protocol
- **Rule 33.197**: Each Micro-Frontend module must be independently deployable. Must not depend on other modules' deployments

---

## Part XXXV: Web Worker & Off-Main-Thread 🌐

### §197. The Off-Main-Thread Strategy
- **Rule 33.198**: Main thread blocking is a direct cause of INP degradation. Offload the following to Web Workers:
    - Large data aggregation, transformation, filtering
    - Image processing (resize, format conversion)
    - Encryption and hash computation
    - Large JSON/CSV parsing

### §198. Comlink Integration
- **Rule 33.199**: Use the **Comlink** library for Web Worker communication, calling Workers via a Promise-based intuitive API

### §199. SharedWorker Protocol
- **Rule 33.200**: Consider **SharedWorker** when data sharing across multiple tabs is needed. Verify browser support before use

### §200. Worker CSP Compatibility
- **Rule 33.201**: Include `worker-src 'self' blob:;` in Web Worker CSP settings (ref §18)

---

## Part XXXVI: Frontend Security Deep Dive 🌐

### §201. The Trusted Types Protocol
- **Rule 33.202**: Introduce the **Trusted Types API** to fundamentally prevent DOM XSS
- **CSP Header**: Set `Content-Security-Policy: require-trusted-types-for 'script'`
- **Policy**: Define DOM operation sanitization policies with `trustedTypes.createPolicy()`

### §202. The Subresource Integrity (SRI) Protocol
- **Rule 33.203**: Attach **SRI (Subresource Integrity)** hashes to scripts and stylesheets loaded from external CDNs to detect tampering

### §203. The CSP Strict Dynamic Protocol
- **Rule 33.204**: Recommend `'strict-dynamic'` + nonce-based policies for Content Security Policy
- **Report-Only**: Collect reports with `Content-Security-Policy-Report-Only` during initial adoption without blocking
- **Origin Addition = Allowlist Update**: A change that adds code referencing an external origin (image host, embedded iframe, API endpoint, third-party script) MUST update the corresponding allowlists in the same change — the image optimizer's allowed hosts (`remotePatterns`), each CSP directive, CORS, and `preconnect` targets. A missed setting goes unnoticed in development and surfaces only in production as a crash (500) or a block. Features handling dynamic URLs (affiliates, user avatars, UGC embeds) preset the expected domains at the start of implementation and fall back safely for unknown domains (placeholder image, plain link) (SHOULD). A PR adding an external service makes the cross-check of actually loaded external resources against CSP / allowlists an acceptance condition (SHOULD; see §99)

### §203b. The CSP Level 3 Protocol

- **Rule 33.329**: Incrementally migrate to **CSP Level 3** Working Draft (W3C 2026)
- **Enhanced Directives**: `script-src-elem`, `script-src-attr`, `style-src-elem`, `style-src-attr` for more precise control over script and style application scope
- **Reporting API v2**: Send CSP violation reports to Reporting API v2 via `report-to` directive, migrating from deprecated `report-uri`
- **Worker CSP**: Separately control Web Worker / Service Worker script sources with `worker-src`

### §204. The CORS Protocol
- **Rule 33.205**: Configure CORS for API Routes / Server Actions with least privilege principle. Wildcard `*` Origin is prohibited in production

### §205. The Dependency Vulnerability Protocol
- **Rule 33.206**: Integrate `npm audit` / `pnpm audit` into CI and automatically block PRs containing high/critical vulnerabilities
- **Cross-Reference**: `security/200_oss_compliance.md`

### §206. The Permissions Policy Protocol
- **Rule 33.207**: Set `Permissions-Policy` header to explicitly control access to browser features (camera, microphone, geolocation, etc.). Disable unnecessary features with `=()`

### §206b. The OWASP 2026 Compliance Protocol

- **Rule 33.330**: Reflect **OWASP Top 10 2026** new categories in frontend design:
    - **A03: Software Supply Chain Failures**: Strengthen vulnerability monitoring for npm/pnpm dependency packages. In addition to CI gating with `npm audit --audit-level=high`, mandate lockfile diff reviews. Consider adopting dependency package signature verification (npm provenance)
    - **A10: Mishandling of Exceptional Conditions**: Strengthen frontend exception handling. Ensure test coverage for all Error Boundaries (§134–§139), monitor unhandled Promise rejections (`unhandledrejection` event listener), mandate complete stack trace capture with Sentry or equivalent
- **Supply Chain Defense**: Validate lockfile integrity with `npm-lockfile-lint` and detect unexpected registry changes
- **Cross-Reference**: `security/000_security_privacy.md`, `security/200_oss_compliance.md`

---

## Part XXXVII: Frontend FinOps 🌐

### §207. The Client-Side Cost Awareness
- **Rule 33.208**: Recognize that frontend design decisions directly impact infrastructure costs:
    - Public pages without caching → Direct DB hits → Cost increase
    - Unnecessary API calls → Lambda/Edge Function execution cost increase
    - Excessive image sizes → CDN transfer cost increase

### §208. The Cache Hit Rate Target
- **Rule 33.209**: Target cache hit rate of **≥ 95%** for public pages. Hit rate decreases are FinOps alert targets

### §209. The Build Time Budget
- **Rule 33.210**: Build time budget: **≤ 5 minutes** (CI environment). Optimize Turbopack / Incremental Build if exceeded

---

## Part XXXVIII: Design System Integration 🌐

### §210. Design Token Architecture
- **Rule 33.211**: Centrally manage design tokens in `tailwind.config.ts`'s `theme.extend`. Hardcoding HEX values is prohibited
- **Semantic Tokens**: Use semantic naming: `primary`, `secondary`, `destructive`, `muted`, etc.
- **DTCG Format**: Consider adopting Design Token Community Group (DTCG) format (`$value`, `$type`) for interoperability with design tools (Figma Tokens, etc.)

### §211. Component Variant Pattern
- **Rule 33.212**: Use **cva** (Class Variance Authority) for component variation management, implementing type-safe variant APIs

### §212. Theme Switching Protocol
- **Rule 33.213**: Implement dark mode/light mode switching with CSS Variables + `next-themes`. Persist theme state in `localStorage`

### §213. Design System Documentation
- **Rule 33.214**: Catalog and document design system components in Storybook for designers and developers to use as a common reference point

### §214. Design System Versioning
- **Rule 33.215**: Design system packages follow Semantic Versioning, providing major version upgrades and migration guides for breaking changes

---

## Part XXXIX: Prohibited Anti-Patterns (30 Items) 🌐

### §215. The Client DB Access Ban
- **Rule 33.216**: Direct DB queries from Client Components are strictly prohibited. All DB operations go through Server Actions / Route Handlers

### §216. The Anchor Tag Nesting Violation Ban
- **Rule 33.217**: Nesting `<a>` tags or interactive elements (`<button>`) inside `<a>` tags is prohibited

### §217. The Server-Side DOM Access Ban
- **Rule 33.218**: Accessing `window`, `document`, `localStorage` inside Server Components is prohibited

### §218. The Recursive Rendering Ban
- **Rule 33.219**: Recursively rendering components (tree views, etc.) must always have a **depth limit**

### §219. The Double Scrollbar Ban
- **Rule 33.220**: Double scrollbars from nested scroll containers are strictly prohibited
- **overflow-x Implies overflow-y auto**: Setting only one of `overflow-x` / `overflow-y` to anything other than `visible` computes the other to `auto` (CSS Overflow 3). A box intended to scroll horizontally only MUST set `overflow-y` explicitly (`hidden` or `clip`) — even with zero vertical overflow, touch devices make it the target of rubber-banding, and the body "stops mid-scroll", a cause of abandonment. `overscroll-behavior: contain` only stops propagation to the parent; it has no effect on the box's own bounce

### §220. The Fragment Misuse Ban
- **Rule 33.221**: Using `<>...</>` shorthand in list rendering where `key` attributes are needed, leaving key warnings, is prohibited

### §221. The Inline Style Object Ban
- **Rule 33.222**: Inline style objects (`style={{ margin: '10px' }}`) directly in JSX are prohibited in principle

### §222. The Event Handler Inline Function Ban
- **Rule 33.223**: Inline arrow functions as event handlers within list map renders are prohibited in principle

### §223. The Image Without Dimensions Ban
- **Rule 33.224**: Using `<img>` / `<Image>` without `width` and `height` (or `fill` + wrapper sizing) is prohibited. Direct cause of CLS
- **Reserved Height Is Media-Only (the counterpart principle)**: Reserved height (`min-height` / fixed `height`) is allowed only for media whose dimensions are unknown before load (images, video, maps, embeds, ad slots), minimum tap-target size, and skeletons / pre-initialization placeholders that are replaced after load (MUST). Never place reserved height on containers whose content is text (body copy, rich-text render areas, the outer frame of tabs or lists) (MUST NOT) — besides blank space under short copy, if the SSR stage lacks the same value the box grows at hydration and the `min-height` meant as a CLS countermeasure becomes the source of CLS. Do not carry editing-surface concerns (a minimum height so an empty editor is clickable) into the public read-only renderer. Use `max-height` for fixed-height scroll frames, and check with an automated test that no reserved height has crept into the public renderer (SHOULD)
- **Media Frame Ratio from Real Dimensions**: Never give a media frame drawn with `object-fit: cover` a fixed height unrelated to the image ratio (MUST NOT) — top and bottom get cropped. Derive the frame's aspect ratio from the distribution of real image dimensions and hold it as an SSOT constant. Never fix slide / card width in absolute units (MUST NOT) — at intermediate widths (2-column with sidebar, etc.) the column becomes narrower than the fixed value and the slide overflows. Fit the frame to the column. Since `contain` produces bands on mismatched images, state the policy (keep cover; a few exceptional images get cropped), and verify fixes by measuring the "visible fraction" at each viewport width before and after (SHOULD)
- **Third-Party Content: Reservation and Constraint as a Pair**: The area reserved for lazily loaded third-party content (ads, etc.) is decided from measured sizes per content kind, AND the content side's variable-size behavior (full-width responsive, etc.) is constrained to fit the reservation (MUST) — one-sided handling, reservation only or constraint only, does not remove CLS (in one case a narrow slot received more than twice the reserved height and CLS exceeded 0.4). Before using managed data (width / height stored in the DB) as the basis for a reservation, confirm it matches production measurements (MUST); after changing a reservation or the content-side settings, re-measure CLS in production per page kind and keep evidence that it stays within budget (MUST). Annotate reservation constants with their update rule (when, and from which measurement, they change) (see `product/300_revenue_monetization.md` §5)

### §224. The useEffect for Derived State Ban
- **Rule 33.225**: The "mirroring pattern" of syncing values calculable from other state with `useEffect` + `setState` is prohibited

### §225. The Non-null Assertion Ban
- **Rule 33.226**: Usage of `data!.property` is prohibited. Use Optional Chaining (`data?.property`)

### §226. The Index as Key Ban
- **Rule 33.227**: Using index `key={index}` when lists can be reordered, added to, or deleted from is prohibited

### §227. The String Concatenation for ClassNames Ban
- **Rule 33.228**: Generating CSS classes with template literals or string concatenation is prohibited. Use `cn()` / `clsx`

### §228. The Global CSS Pollution Ban
- **Rule 33.229**: Writing component-specific CSS in global stylesheets is prohibited

### §229. The setTimeout for State Sync Ban
- **Rule 33.230**: Timer hacks like `setTimeout(() => setState(...), 0)` are prohibited

### §230. The Any Type Escape Ban
- **Rule 33.231**: Using TypeScript `any` type to circumvent build errors is prohibited

### §231. The Direct DOM Manipulation Ban
- **Rule 33.232**: Direct DOM manipulation bypassing React's Virtual DOM with `document.getElementById()` is prohibited in principle. Use `useRef`

### §232. The Deeply Nested Ternary Ban
- **Rule 33.233**: Ternary operators nested 3+ levels deep are prohibited. Convert to Early Return pattern

### §233. The Magic Number/String Ban
- **Rule 33.234**: Magic numbers and magic strings in code are prohibited. Define constants or `enum`s
- **Peripheral Literal Drift**: Even with the main body on constants, the periphery drifts. Function default parameters (`getList(limit = 20)`), omission fallbacks, strict HTTP status comparisons, time-unit conversions (`60_000`), sitemap / redirect exclusions and header checks MUST reference the same SSOT. Thresholds shared across display, decisions and alerting are made SSOT before the consumers (dashboards, alerting) are built (MUST), with the unit embedded in the name or a note (`*_MS`, "ratio 0-1") (SHOULD). Detection: grep for numeric literals directly after comparison operators (`> 0.15`, `<= 500`)

### §234. The Lazy Redirect Ban
- **Rule 33.235**: Redundant redirects without conditional logic are prohibited. Resolve through routing structure

### §235. The Uncontrolled Re-render Ban
- **Rule 33.236**: Patterns where `setState` within `useEffect` causes infinite render cycles are prohibited

### §236. The Prop Drilling Ban
- **Rule 33.237**: Prop Drilling through 3+ layers is prohibited. Resolve with Context API, Zustand, or component composition

### §237. The Unreachable Code Ban
- **Rule 33.238**: Unreachable code (code after `return` statements, etc.) must be deleted immediately

### §238. The Console.log in Production Ban
- **Rule 33.239**: `console.log` is for development only. Prohibit in production builds with `no-console`

### §239. The Synchronous localStorage Ban
- **Rule 33.240**: Use asynchronous storage (IndexedDB) for reading/writing large data

### §240. The Wildcard Import Ban
- **Rule 33.241**: Wildcard imports like `import * as X from 'module'` are prohibited as they prevent Tree Shaking. Use named imports

### §241. The Inline SVG Bloat Ban
- **Rule 33.242**: Inlining complex SVGs of 100+ lines in JSX is prohibited. Separate as external files and componentize

### §242. The Untyped Event Handler Ban
- **Rule 33.243**: Receiving event handler arguments as `any` or untyped is prohibited. Use precise types like `React.MouseEvent<HTMLButtonElement>`

### §243. The Layout Thrashing Ban
- **Rule 33.244**: Layout Thrashing patterns alternating reads of `offsetHeight` etc. and `style` writes are prohibited. Batch reads or separate with `requestAnimationFrame`

### §244. The Uncontrolled Third-Party CSS Ban
- **Rule 33.245**: Globally importing third-party library CSS to pollute project styles is prohibited. Isolate with CSS Modules or scoping

---

## Part XL: Monorepo & Multi-App Strategy 🔀

### §245. Turborepo Standard

- **Rule 33.246**: Use **Turborepo** as the standard tool for Monorepo setups
- **Pipeline**: Define task graphs for `build`, `lint`, `test`, `type-check` to maximize parallel execution and caching
- **Remote Cache**: Reduce CI time with Vercel Remote Cache or custom S3 cache

### §246. Shared Package Architecture

- **Rule 33.247**: Standard shared package structure within Monorepo:
    - `packages/ui` — Design system components
    - `packages/config` — ESLint / TypeScript / Tailwind shared configuration
    - `packages/utils` — Shared utility functions
    - `packages/types` — Shared type definitions

### §247. Internal Package Protocol

- **Rule 33.248**: Internal packages reference TypeScript source directly with `"main": "./src/index.ts"` (no build required). Auto-transpile with Next.js `transpilePackages`

### §248. Dependency Boundary Protocol

- **Rule 33.249**: Including app-specific dependencies in shared packages is prohibited. Shared packages must have minimal dependencies

### §249. Workspace Version Protocol

- **Rule 33.250**: Unify dependency versions across workspaces. React / TypeScript / Tailwind version mismatches must be fixed immediately

---

## Part XLI: Real-Time Communication 🌐

### §250. WebSocket Architecture

- **Rule 33.251**: Limit WebSocket usage to the following use cases:
    - Chat / Messaging
    - Real-time collaboration (co-editing, etc.)
    - Gaming / Live streaming
- **Reconnection**: Implement automatic reconnection with exponential backoff

### §251. Server-Sent Events (SSE) Protocol

- **Rule 33.252**: Prefer **SSE** for one-way real-time data streaming (notifications, feed updates, AI response streaming, etc.)
- **Benefit**: Lighter than WebSocket. Higher compatibility with HTTP infrastructure (CDN, load balancers)

### §252. WebTransport Protocol

- **Rule 33.253**: Consider **WebTransport** API for advanced use cases requiring low-latency bidirectional communication. Verify browser support

### §253. Real-Time UI State

- **Rule 33.254**: Apply optimistic UI patterns for real-time data display, preventing network latency from impacting UX
- **Presence**: Implement online status display via WebSocket / SSE, not polling

---

## Part XLII: Authentication UI & Session Management 🔀

### §254. Auth UI Best Practices

- **Rule 33.255**: Login/signup forms must adhere to:
    - Password manager compatibility (proper `autocomplete` attribute settings)
    - Consistent social login button design
    - Error messages must not reveal email existence ("Email or password is incorrect")
- **In-App Browser Tier**: The browser support matrix includes not only general-purpose browsers but the in-app browsers with high share in the target market (messenger, portal and SNS WebViews), tiered on the basis of analytics; Tier 1 means full feature testing (MUST). The canonical rule is "In-App Browsers" in `quality/000_qa_testing.md`.

### §255. Passkey Support

- **Rule 33.256**: Support WebAuthn / Passkey to promote passwordless authentication. Leverage `navigator.credentials.create()` / `get()` APIs

### §256. Session Token Security

- **Rule 33.257**: Store session tokens in `HttpOnly`, `Secure`, `SameSite=Lax` cookies. Storing tokens in `localStorage` is prohibited
- **Cross-Reference**: `security/000_security_privacy.md`

### §257. Auth State UI Protocol

- **Rule 33.258**: Execute auth state-dependent UI switching at the Server Component layer. Auth checks in Client Components are for supplementary use only

### §258. Protected Route Protocol

- **Rule 33.259**: Guard routes requiring authentication at the Edge Middleware level in `middleware.ts`. Do not rely solely on auth checks within page components
- **No Privilege-Acquiring Page Under Its Own Guard**: Never place the screen through which a privilege is acquired (invitation acceptance, onboarding, permission requests, contract consent) under the centralized guard (layout, etc.) that requires that privilege (MUST NOT) — the circular dependency kills the feature structurally. At design time ask "can this page's user pass the guard?", and separate with a mechanism that keeps the URL unchanged (route groups, etc.). Once an unguarded area exists, add a structural gate that enumerates every page beneath the app and enforces "under the guard, or in the exact-match allowlist of unguarded pages", with a lower-bound assert against a false pass on a 0-item scan (MUST) — a new page added to the unguarded area silently loses authorization. Scan sources with comments excluded (see `security/430_authorization_and_access_control.md`)

---

## Part XLIII: Animation & Motion Design 🌐

### §259. The Performance-First Animation Protocol

- **Rule 33.260**: Animations use only `transform` and `opacity`. Animating layout properties like `width`, `height`, `top`, `left` is prohibited in principle as they cause Layout Thrashing
- **will-change**: Use `will-change` only when necessary and remove after animation completion

### §260. The Animation Library Protocol

- **Rule 33.261**: Animation library selection criteria:
    - **CSS Transitions / Animations**: Simple hover, fade, slide
    - **Framer Motion**: React component mount/unmount animations, gestures
    - **GSAP**: Complex timeline, scroll-linked animations
- **Bundle Impact**: Always be mindful of animation library bundle size. Prefer CSS-native when possible
- **The Disclosure UI Mount Protocol**: Disclosure UI (overlays / panels / items) stays mounted at all times and is driven by a fixed initial value plus an animation toggle (MUST). When closing completes, remove it from rendering, hit-testing and the a11y tree with `visibility:hidden` + `inert` (or `pointer-events-none` / `tabIndex=-1`). The dominant cost is the mount → unmount on every open (about 95 nodes) and stacked blur; micro-optimizations (memo / GPU hints) do not remove structural weight. This is the proviso to "prefer conditional rendering" in `design/000_design_ux.md` (disclosure UI with animated transitions stays mounted and toggles the transition)
    - Limit `backdrop-filter` to surfaces where the visual difference actually shows (MUST) — blur over a high-opacity tinted background has zero effect and only costs. On mobile avoid full-screen blur and substitute a darker dimming (SHOULD)
    - A scroll lock that sets body to `position: fixed` reflows the whole document, and releasing it synchronously at the moment of closing eats the first frame of the close animation. Defer release until the close animation feels complete, cancel the scheduled release and keep the lock on reopen during the delay, and release immediately on unmount (SHOULD)
    - Make native `scrollTo({behavior:'smooth'})` the main path for in-page scroll effects (MUST). Hand-rolled rAF easing runs on the main thread and stutters by competing with lazy image loads and scroll handlers. JS-driven scrolling is only the fallback after a watchdog
    - Links that are now always mounted explicitly stop unnecessary prefetch (IntersectionObserver still intersects under `visibility:hidden`) (SHOULD). After always-mount, `querySelector` picks up hidden items and a programmatic `.click()` fires even under `visibility:hidden`, so verification identifies targets by state attributes such as `aria-expanded`

### §261. The Micro-Interaction Protocol

- **Rule 33.262**: Implement micro-interactions (0.1–0.3s short feedback) for major UI events such as button clicks, form submissions, and state changes
- **Paint-Gated Choreography**: An animation that overlaps the heavy first paint right after opening (reflow, first blur paint) is already near its end on the first frame that can be drawn when driven by elapsed-time delays or springs — it pops in. Gate the trigger on "after the first frame's paint commit" (double rAF) (MUST) — a wall-clock delay cannot absorb a stall. Choreograph open and close in stages (SHOULD): open = overlay / panel fade from the gate → item expansion after it completes; close = items collapse → fade out once mostly collapsed → unlock after it completes. Keep timing constants in an SSOT and pin the ordering invariants between stages (e.g. `OPEN_FADE ≤ ITEMS_BASE_DELAY`) in comments (MUST)
    - Where the motion feel is already established, change only the mount strategy and do not swap the driving engine (spring, etc.) (SHOULD) — a CSS bezier approximation can be rejected on perceived difference. rAF does not advance in a hidden tab, so verify by driving frames through screenshot capture and treat the capture of an intermediate state (rotation + mid-way coordinates) as evidence of full playback (SHOULD)

### §262. The Loading Animation Protocol

- **Rule 33.263**: Use Skeleton UI during content loading. Spinners are a last resort. Progress bars are limited to download/upload progress

### §263. The Page Transition Protocol

- **Rule 33.264**: Prefer View Transitions API (§170) for page transition animations. Target 200–400ms transition duration

### §264. The Reduced Motion Compliance

- **Rule 33.265**: All animation implementations must support `prefers-reduced-motion: reduce` media query (integration with §124)

---

## Part XLIV: Responsive & Multi-Device 🌐

### §265. Fluid Typography

- **Rule 33.266**: Implement Fluid Typography with `clamp()` for smooth font size changes based on viewport size
- **Example**: `font-size: clamp(1rem, 0.5rem + 1.5vw, 2rem)`

### §266. Mobile-First Breakpoints

- **Rule 33.267**: Design responsive layouts Mobile-First (`min-width` based). Avoid Desktop-First overrides

### §267. Touch Target Size

- **Rule 33.268**: Touch targets must guarantee minimum **44×44px** (WCAG 2.2 Target Size criteria). Expand area with padding for small links and buttons

### §268. Foldable Device Support

- **Rule 33.269**: Consider `screen-spanning` media queries and `env()` CSS variables for foldable device (Fold) support

### §269. Viewport Unit Protocol

- **Rule 33.270**: Use `dvh` / `svh` / `lvh` appropriately for mobile browser address bar handling. Do not rely solely on legacy `vh`

### §270. Print Stylesheet Protocol

- **Rule 33.271**: Provide `@media print` stylesheets for pages expected to be printed (receipts, invoices, reports, etc.)

---

## Part XLV: E-Commerce Frontend 🔀

### §271. Cart UI Protocol

- **Rule 33.272**: Cart UI uses optimistic update pattern for instant reflection, with server sync executed asynchronously. 300ms debounce recommended for quantity changes

### §272. Checkout Flow Protocol

- **Rule 33.273**: Implement checkout flow as multi-step format with step indicators, executing validation at each step. Detect cart inconsistencies (out of stock, price changes) at final confirmation

### §273. PCI DSS Compliance

- **Rule 33.274**: For payment forms, do not send card information directly to the server for PCI DSS compliance. Use tokenization SDKs like Stripe Elements / PayPay SDK

### §274. Product Display Protocol

- **Rule 33.275**: Product images must support zoom, gallery swipe, and video thumbnails. Image optimization per §99

### §275. Price Display Protocol

- **Rule 33.276**: Format price display with locale-aware formatting using `Intl.NumberFormat`, explicitly showing currency codes. Internally manage in smallest currency units (integers)

### §276. Inventory Status Protocol

- **Rule 33.277**: Update inventory status (in stock / low stock / out of stock) in real-time. Sync accurate inventory counts via SSE/Polling

---

## Part XLVI: Frontend DevOps 🌐

### §277. ESLint Flat Config Standard

- **Rule 33.278**: Standardize on ESLint 9+ Flat Config (`eslint.config.mjs`). Legacy `.eslintrc` format is prohibited for new projects

### §278. Biome Integration

- **Rule 33.279**: **Biome v2** is the **first choice for new projects** as an ESLint + Prettier alternative. Achieve config simplification and performance improvement with a single tool for Lint + Format
- **Maturity**: Biome v2 covers 90%+ of ESLint/Prettier's main rules with 10–100x performance. Provides formatting and linting for TypeScript / JSX / CSS / JSON in a single binary
- **Migration**: For existing projects, recommend incremental migration from ESLint config using `biome migrate` command
- **CI Integration**: Integrate into CI/CD pipelines with `biome ci` command. Achieve PR merge blocking for warnings with `--error-on-warnings` flag

### §279. CI Pipeline Optimization

- **Rule 33.280**: CI pipeline optimization:
    - `pnpm install --frozen-lockfile` for reproducibility
    - Leverage Turbopack / Turborepo Remote Cache
    - Parallel execution of type checks, lint, and tests

### §280. Pre-commit Hooks

- **Rule 33.281**: Execute Lint / Format / type checks before commit with `lint-staged` + `husky`. Physically prevent low-quality code from entering the repository

### §281. Branch Preview Protocol

- **Rule 33.282**: Auto-deploy preview environments for all PRs so reviewers can verify actual UI

### §282. Dependency License Audit

- **Rule 33.283**: Integrate `license-checker` / `license-report` into CI for auto-detection of copyleft license dependencies (GPL, AGPL, etc.)
- **Cross-Reference**: `security/200_oss_compliance.md`

---

## Part XLVII: Third-Party Script Management 🌐

### §283. The Third-Party Script Isolation Protocol

- **Rule 33.284**: Third-party scripts (Analytics, Chat, Ad, etc.) must not block the main thread. Lazy load with `next/script`'s `lazyOnload` strategy
- **Rule 33.284a (Visibility-Gated Mount)**: Intersection checks such as IntersectionObserver look only at geometry. Panels that are `inert`, `visibility`-hidden, mid-transform or positioned off-screen still "intersect", so an intersection check MUST NOT stand in for "the user can see it" — intersection answers "did it come near", not "is it visible". Lazily loaded targets (ads, heavy embeds, measurement) placed on surfaces whose visibility is UI state (drawers, tabs, accordions, modals) MUST be mounted only once that state becomes "open". Always-mounted-but-hidden silently triggers third-party script loading, billing and measurement (an ad slot inside an unopened menu was reported as filled). A correct "pure function that decides the load condition" still misbehaves in production if "the wiring that calls it" is wrong, so keep a test of the wiring (mount condition) separate from the pure-function test and measure in production (MUST)

### §284. The Partytown Protocol

- **Rule 33.285**: Consider offloading third-party scripts with significant main thread impact to Web Workers using **Partytown**

### §285. The GTM Management Protocol

- **Rule 33.286**: Recommend Server-Side GTM for Google Tag Manager (GTM), minimizing client-side script count

### §286. The Consent-Aware Script Loading

- **Rule 33.287**: Load tracking scripts conditionally based on cookie consent state. Loading scripts before consent poses legal risk

### §287. The Third-Party Performance Audit

- **Rule 33.288**: Audit third-party script performance impact quarterly. Unused or high-load scripts are candidates for removal

---

## Part XLVIII: Sustainability & Green Frontend 🌐

### §288. The Carbon-Aware Frontend Protocol

- **Rule 33.289**: Recognize that frontend design decisions impact carbon footprint:
    - Unnecessary API calls → Server energy consumption
    - Excessive image sizes → Network energy consumption
    - Inefficient JavaScript → Client CPU energy consumption

### §289. The Sustainable Image Protocol

- **Rule 33.290**: Thoroughly optimize images per §99–§105, minimizing transfer data volume. AVIF format adoption directly contributes to environmental impact reduction

### §290. The Dark Mode Energy Protocol

- **Rule 33.291**: Dark mode reduces power consumption on OLED devices. Recommend providing dark mode as a default option

### §291. The Efficient Rendering Protocol

- **Rule 33.292**: Eliminate unnecessary re-renders to minimize CPU cycles and battery consumption. Achieve automatic optimization through React Compiler (§47) adoption

### §292. The SCI Measurement Protocol

- **Rule 33.293**: Consider measuring Software Carbon Intensity (SCI) scores. Integrate carbon measurement into CI pipelines with tools like GreenFrame

---

## Part XLIX: Maturity Model & Future Outlook 🌐

### §293. Frontend Maturity Model (5 Levels)

| Level | Name | Characteristics |
|:------|:-----|:---------------|
| **L1** | Reactive | jQuery/Vanilla JS based, manual DOM manipulation |
| **L2** | Component | React/Vue adoption, componentization |
| **L3** | Type-Safe | TypeScript Strict, Zod validation, CI/CD |
| **L4** | Performance-Driven | CWV auto-gate, Bundle Budget, Lighthouse CI |
| **L5** | AI-Augmented | AI-driven optimization, Predictive Prefetch, auto A/B testing |

### §294. React Compiler Evolution

- **Outlook**: With the GA release of React Compiler v1.0, manual `useMemo` / `useCallback` are **completely unnecessary**. Going forward, track further compiler optimizations (Server Component support, etc.)

### §295. Server Components Evolution

- **Outlook**: Track RSC feature expansion (Server Action Streaming, PPR stabilization, etc.)

### §296. WebAssembly Integration

- **Outlook**: Wasm-based module integration of CPU-intensive processing (image processing, encryption, etc.) into frontend will become mainstream

### §297. WebGPU Frontend

- **Outlook**: WebGPU API enables GPU parallel processing for advanced visualization and AI inference on the frontend

### §298. Spatial Computing

- **Outlook**: WebXR / Spatial Computing UI design patterns will be established, standardizing 3D interaction

### §299. AI-Native Frontend

- **Outlook**: Prepare for a frontend development paradigm where AI automates UI component generation, layout optimization, and personalization

### §300. Edge-First Architecture

- **Outlook**: Edge Computing First architecture minimizes origin server dependency, achieving global low latency

---

## Part LI: Next.js 16 Migration & New Features ⚛️

### §311. The proxy.ts Migration Protocol

- **Rule 33.305**: In Next.js 16, `middleware.ts` has been replaced by `proxy.ts`. Migrate all projects to `proxy.ts`
- **Runtime**: `proxy.ts` runs on the Node.js runtime (NOT Edge Runtime). All Node.js APIs are available
- **Migration**: Migrate existing `middleware.ts` logic to `proxy.ts`. Request interception, redirects, and header manipulation APIs are now more explicit
- **Breaking**: `NextResponse.next()` → `proxy.next()` change is required

```typescript
// ✅ proxy.ts (Next.js 16)
import { type ProxyRequest } from 'next/server';

export default function proxy(request: ProxyRequest) {
  // Authentication check
  const token = request.cookies.get('session');
  if (!token && request.nextUrl.pathname.startsWith('/dashboard')) {
    return Response.redirect(new URL('/login', request.url));
  }

  // Add CSP headers
  const nonce = crypto.randomUUID();
  const headers = new Headers(request.headers);
  headers.set('Content-Security-Policy', `script-src 'nonce-${nonce}' 'strict-dynamic'`);
  
  return proxy.next({ headers });
}

export const config = {
  matcher: ['/((?!_next/static|favicon.ico).*)'],
};
```

### §312. The `use cache` GA Protocol

- **Rule 33.306**: Leverage the `'use cache'` directive promoted to GA in Next.js 16 for explicit cache control
- **Scope**: Cache can be applied at page, component, or function granularity
- **vs unstable_cache**: Gradual migration from `unstable_cache` to `'use cache'` is recommended. `unstable_cache` is deprecated
- **Tag Management**: Apply cache tags with `cacheTag()` and selectively invalidate with `revalidateTag()`

```typescript
// ✅ 'use cache' directive (Next.js 16 GA)
import { cacheTag, cacheLife } from 'next/cache';

async function getProduct(id: string) {
  'use cache';
  cacheTag(`product-${id}`);
  cacheLife('hours'); // Presets: 'seconds' | 'minutes' | 'hours' | 'days' | 'weeks' | 'max'
  
  const product = await db.product.findUnique({ where: { id } });
  return product;
}
```

### §313. Turbopack File System Caching

- **Rule 33.307**: Enable Turbopack's **File System Caching** (Beta) to dramatically reduce startup times for large applications
- **Config**: Set `experimental.turbopackFileSystemCaching: true` in `next.config.ts`
- **Benefit**: Leverage incremental caching for subsequent `next dev` / `next build` runs, reducing startup time by up to 70%
- **Cache Location**: Automatically saved to `.next/cache/turbopack`. CI cache persistence is recommended

### §314. Next.js DevTools MCP Protocol

- **Rule 33.308**: Leverage the **Next.js DevTools MCP** (Model Context Protocol) server for AI-assisted debugging
- **Feature**: Build errors, performance bottlenecks, and routing issues are analyzed by AI assistants with full context awareness
- **Integration**: Integrate with AI-enabled editors (VS Code / Cursor, etc.) to improve development efficiency

### §315. The updateTag API Protocol

- **Rule 33.309**: Leverage Next.js 16's `updateTag()` API to update cache tag values without revalidation
- **vs revalidateTag**: `revalidateTag()` invalidates cache and re-fetches. `updateTag()` directly updates the value, reducing server load
- **Use Case**: Maximize cache efficiency for near-real-time updates (inventory counts, like counts, etc.)

### §316. The Incremental Prefetching Protocol

- **Rule 33.310**: Leverage Next.js 16's **incremental prefetching** for progressive prefetching based on viewport detection and hover triggers
- **Layout Deduplication**: Shared layouts are downloaded only once; only route-specific data is additionally fetched
- **Priority**: Apply `hovering` trigger for CTAs and main navigation; `viewport` trigger for sidebar links

---

## Part LII: GraphQL Frontend Architecture 🌐

### §317. GraphQL Client Standard

- **Rule 33.311**: Use **urql** or **Apollo Client** as the GraphQL client. Select based on the following criteria:
    - **urql**: Lightweight, simple, SSR-friendly. Recommended for small-to-medium projects
    - **Apollo Client**: Advanced caching, local state integration. Recommended for large-scale projects
- **Codegen**: Use `graphql-codegen` to auto-generate type-safe hooks and documents. Manual GraphQL query type definitions are prohibited

### §318. The Fragment Colocation Protocol

- **Rule 33.312**: GraphQL Fragments must be colocated with the component that consumes the data (Fragment Colocation)
- **Benefit**: The data structure required by a component is immediately visible. Prevents residual unnecessary fields
- **Naming**: Fragment names must follow the `ComponentName_fieldName` format

```typescript
// ✅ Fragment Colocation
import { graphql } from '@/gql';

const UserAvatar_user = graphql(`
  fragment UserAvatar_user on User {
    id
    name
    avatarUrl
  }
`);

export function UserAvatar({ user }: { user: FragmentType<typeof UserAvatar_user> }) {
  const data = useFragment(UserAvatar_user, user);
  return <img src={data.avatarUrl} alt={data.name} />;
}
```

### §319. The Persisted Query Protocol

- **Rule 33.313**: Use **Persisted Queries** in production to reduce GraphQL query string network transfer and security risks
- **APQ**: Implement hash-based query identification with Automatic Persisted Queries (APQ)
- **Security**: Reject execution of unregistered queries to prevent GraphQL injection attacks

### §320. The GraphQL Error Handling Protocol

- **Rule 33.314**: GraphQL error handling should assume the "partial success" pattern
- **Partial Data**: When `data` and `errors` are returned simultaneously, display available data while notifying the error
- **Error Classification**: Separate network errors (retry-eligible) from GraphQL errors (business logic errors) in processing

---

## Part LIII: Type-Safe API Client & tRPC 🔀

### §321. tRPC Standard

- **Rule 33.315**: Consider **tRPC** for full-stack TypeScript projects to achieve end-to-end type safety
- **Benefit**: No API schema definition, type generation, or client code generation required. TypeScript types serve directly as the API contract
- **Limitation**: For non-TypeScript clients (mobile apps, etc.), use REST API / GraphQL alongside

### §322. The OpenAPI TypeScript Client Protocol

- **Rule 33.316**: Use `openapi-typescript` + `openapi-fetch` for REST API clients to auto-generate type-safe clients from OpenAPI schemas
- **Codegen**: Integrate type generation into the CI pipeline to automatically detect type mismatches on API schema changes
- **Runtime Validation**: Use Zod for runtime validation of received data (type safety alone is insufficient)

```typescript
// ✅ OpenAPI Type-Safe Client
import createClient from 'openapi-fetch';
import type { paths } from '@/generated/api';

const client = createClient<paths>({ baseUrl: process.env.API_BASE_URL });

// Type-safe API call — path, method, params, and response are all typed
const { data, error } = await client.GET('/api/products/{id}', {
  params: { path: { id: 'prod_123' } },
});
```

### §323. The API Schema Versioning Protocol

- **Rule 33.317**: Implement API schema versioning to clarify the contract between frontend and backend
- **Contract Testing**: Use Consumer-Driven Contract Testing (e.g., Pact) to test the API response structure expected by the frontend
- **Breaking Change Detection**: Automatically detect breaking API schema changes (field removal, type changes, etc.) in CI

### §324. The API Response Normalization Protocol

- **Rule 33.318**: API response normalization is a frontend responsibility, implemented in the DTO transformation layer
- **Adapter Pattern**: Centralize API response → frontend model transformation logic in `api/adapters/`
- **Isolation**: Adapters absorb API response structure changes to prevent propagation to the component layer

---

## Part LIV: Frontend Data Quality & Schema Contract 🌐

### §325. The Frontend Data Quality Gate

- **Rule 33.319**: All external data received by the frontend (API, WebSocket, localStorage, etc.) must be validated with Zod before consumption
- **Trust Boundary**: The frontend's Trust Boundary extends only to "own component's props." All external data is treated as untrusted
- **Error Recovery**: On validation failure, fall back to default values or error state. Must not crash
- **Absent-Key Semantics**: An enum mapping table is a constant that covers the whole domain, and out-of-range input is expressed as "no mapping" rather than returning `undefined` (MUST) — an array-index lookup breaks silently the moment the domain grows, and type check, lint and build all pass. The canonical rule is "Rule 740.5.2a" in `engineering/740_data_contracts.md`.

```typescript
// ✅ External Data Validation Gate
import { z } from 'zod';

const ProductSchema = z.object({
  id: z.string(),
  name: z.string(),
  price: z.number().nonnegative(),
  currency: z.enum(['JPY', 'USD', 'EUR']),
  stockCount: z.number().int().nonnegative(),
});

type Product = z.infer<typeof ProductSchema>;

async function fetchProduct(id: string): Promise<Product | null> {
  const res = await fetch(`/api/products/${id}`);
  const json = await res.json();
  const result = ProductSchema.safeParse(json);
  
  if (!result.success) {
    console.error('Product data validation failed:', result.error);
    captureException(result.error); // Send to Sentry
    return null; // Fallback
  }
  return result.data;
}
```

### §326. The Schema Contract Testing Protocol

- **Rule 33.320**: Introduce **schema contract testing** between frontend and backend to detect API structural inconsistencies early
- **Implementation**: Share Zod schema definitions between frontend and backend, testing consistency in CI
- **Monorepo**: Place shared schema packages in `packages/schemas/`

### §327. The Stale Data Detection Protocol

- **Rule 33.321**: Manage cached data freshness to minimize the risk of stale data being presented to users
- **Staleness Indicator**: Display a "Last updated: X minutes ago" indicator for data that has exceeded cache validity
- **Auto-Refresh**: Automatically refresh on tab re-display using the `document.visibilitychange` event

### §328. The Runtime Type Narrowing Protocol

- **Rule 33.322**: Require the Discriminated Union pattern for runtime type narrowing of Union types
- **Discriminant Field**: Narrow types using discriminant fields such as `type` / `kind` / `status`
- **Exhaustive Check**: Implement `never` type checking in the `default` case of `switch` statements (Exhaustive Check) to detect unhandled cases at compile time

```typescript
// ✅ Type-Safe UI Branching with Discriminated Union
type ApiResponse =
  | { status: 'loading' }
  | { status: 'success'; data: Product[] }
  | { status: 'error'; error: string };

function ProductList({ response }: { response: ApiResponse }) {
  switch (response.status) {
    case 'loading':
      return <Skeleton />;
    case 'success':
      return <Grid items={response.data} />;
    case 'error':
      return <ErrorMessage message={response.error} />;
    default:
      return response satisfies never; // Compile-time detection of unhandled cases
  }
}
```

- **Classification Mapping Totality Test**: When stored kinds (type) are routed into coarse categories per surface (family), keep the mapping in an SSOT and pin totality and uniqueness — "every type belongs to exactly one family" — with a test (MUST); a type added without a classification silently disappears from lists. Do not write branches on kind literals in components or DB queries (`type === 'x' || …`); go through the routing function and the allowed-set constants (MUST NOT). This extends the `satisfies never` exhaustiveness check to runtime mapping tables

### §329. The Data Invariant Protocol

- **Rule 33.323**: Validate business-critical data invariants on the frontend as well
- **Examples**: Stock count ≥ 0, price > 0, start date ≤ end date, total amount = sum of line items
- **Implementation**: Use an `invariant()` utility function for runtime checks, with immediate error reporting on violation

### §330. The Null Object Pattern Protocol

- **Rule 33.324**: Instead of passing `null` for unset DB record fields to components, convert to objects with default values using the **Null Object Pattern**
- **Benefit**: Eliminates null check branching in the component layer, improving code readability and testability
- **DTO Layer**: Generate Null Objects during API → DTO transformation
- **The Single-Source Visible Label Protocol**: Fix the source of a user-visible label (caption bands, etc.) to a single field and prohibit implicit fallbacks to other fields (note / annotation / title / alt) such as `a ?? b ?? c` (MUST NOT) — they produce the divergence "text appears where it should be empty". The canonical rule is "Rule 740.5.2b" in `engineering/740_data_contracts.md`.
- **The `a || b` Single-Fallback Display Trap**: The fallback operator is correct only for the requirement "either one is enough". Repurposed for "show both", the subordinate side is structurally and permanently invisible as long as the preferred side exists, and the more complete the data, the more entrenched the symptom. When using `a || b` in display code, make "is it acceptable for b to be hidden when a exists?" an explicit review question (MUST), and render side-by-side requirements as separate elements, each with `value && …` (MUST)

---

## Appendix A: Quick Reference Index

| Keyword | Related Sections |
|:--------|:----------------|
| `'use client'` | §12, §14, §217 |
| `'use server'` | §6, §140, §144 |
| `'use cache'` | §11, §85 |
| `use()` hook | §46 |
| `useOptimistic` | §44 |
| `useFormStatus` | §45 |
| `useActionState` | §45 |
| React Compiler | §47, §294 |
| `<ViewTransition>` | §47, §170, §306 |
| `unstable_cache` | §85, §86 |
| `next/dynamic` | §22, §93, §147 |
| `next/image` | §99, §100, §103, §223 |
| `next/font` | §101 |
| `next/script` | §102, §155, §283 |
| React Hook Form | §54–§66 |
| Zod | §8, §54, §56, §57, §75 |
| shadcn/ui | §19, §20, §21 |
| Tailwind CSS | §25, §27, §210 |
| Server Actions | §57, §84, §140–§146, §154 |
| Hydration | §49–§53 |
| CWV (Core Web Vitals) | §1, §91, §95, §180 |
| SEO | §23, §106–§117 |
| A11y | §118–§124, §191, §267 |
| CSP | §18, §203, §203b |
| State Management | §79–§83 |
| Error Handling | §134–§139, §206b |
| Testing | §156–§163 |
| PWA | §125–§129 |
| i18n | §130–§133 |
| Anti-Patterns | §215–§244 |
| Z-Index | §28, §29 |
| View Transitions | §170, §263, §306 |
| Container Queries | §31 |
| Anchor Positioning | §171 |
| `@property` | §177 |
| `@starting-style` | §178 |
| CSS Grid Masonry | §179 |
| Speculative Rules | §117 |
| Trusted Types | §201 |
| Web Worker | §197–§200, §284 |
| Micro-Frontend | §192–§196 |
| AI UI | §186–§191 |
| RUM | §180–§185 |
| PPR | §11 |
| FinOps | §85, §207–§209 |
| Monorepo | §245–§249 |
| WebSocket / SSE | §250–§253 |
| Authentication | §254–§258 |
| Animation | §259–§264 |
| Responsive | §265–§270 |
| E-Commerce | §271–§276 |
| DevOps | §277–§282 |
| Sustainability | §288–§292 |
| Tailwind CSS 4 | §301 |
| `next/after` | §302 |
| CSS `@layer` | §303 |
| CSS `:has()` | §304 |
| React Activity | §305 |
| `<ViewTransition>` GA | §306 |
| LoAF API | §307 |
| `scheduler.yield()` | §308 |
| Navigation API | §309 |
| `color-mix()` | §310 |
| `proxy.ts` | §311 |
| `'use cache'` GA | §312 |
| Turbopack FS Caching | §313 |
| DevTools MCP | §314 |
| `updateTag()` | §315 |
| Incremental Prefetch | §316 |
| GraphQL | §317–§320 |
| tRPC | §321 |
| OpenAPI Client | §322 |
| Schema Contract | §323, §326 |
| Data Quality | §325–§330 |
| `useEffectEvent` | §48b |
| Discriminated Union | §328 |
| Null Object Pattern | §330 |
| `cacheSignal()` | §305b |
| Performance Tracks | §305c |
| Batching Suspense | §305d |
| Privacy Sandbox | §155b |
| CHIPS / FedCM | §155b |
| OWASP 2026 | §206b |
| Supply Chain Security | §206b |
| CSP Level 3 | §203b |
| Biome | §278 |

## Appendix B: Cross-References

| Referenced Rule | Related Sections in This Rule |
|:---------------|:-----------------------------|
| `design/000_design_ux.md` | §1, §19, §21, §112, §259 |
| `engineering/000_engineering_standards.md` | §2, §96, §277 |
| `engineering/310_headless_cms.md` | §7 (Hardcoding prohibition) |
| `engineering/100_api_integration.md` | §140–§146, §250 |
| `engineering/200_supabase_architecture.md` | §89 (DB Query) |
| `ai/000_ai_engineering.md` | §116 (GEO), §187 |
| `ai/100_data_analytics.md` | §153 (Privacy Tracking) |
| `security/000_security_privacy.md` | §74, §145, §201–§206, §256 |
| `security/200_oss_compliance.md` | §5, §205, §282 |
| `product/500_growth_marketing.md` | §116 (GEO Strategy), §151–§155 |
| `engineering/100_api_integration.md` | §140–§146, §250, §321–§324 |
