# 33. Web Frontend Engineering

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-03-24 | Target: Next.js 16+ / React 19.2+ / TypeScript 5.x

> [!IMPORTANT]
> **Supreme Directive**
> "The frontend is the sole point of contact between the user and the product, and compromise is not allowed."
> Achieve the trinity of Performance, Accessibility, and Security to guarantee the highest standard of user experience.
> In all web frontend implementation, strictly adhere to the priority: **Security > Performance > Accessibility > UX > Maintainability > Development Speed**.
> This document is the supreme standard for all frontend design decisions.
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

### §1. Supreme Directive — Web Frontend Excellence

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
- **Cross-Reference**: `300_engineering_standards.md`, `200_design_ux.md`

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
- **Renovate/Dependabot**: Enable automated dependency update PRs and merge after a 21-day stabilization period
- **The Freshness Obligation**: External service SDKs (AI, Auth, Payment, etc.) evolve rapidly. Always use the latest version for new implementations, and "update first" as the primary resolution strategy when issues arise
- **Cross-Reference**: `602_oss_compliance.md`
- **Next.js 16 Breaking Changes**: Upgrading to Next.js 16 requires Node.js 20.9+ and TypeScript 5+. AMP support has been removed. `middleware.ts` is replaced by `proxy.ts` (see Part LI for details)

### §301. Tailwind CSS 4 Deep Dive [NEW]

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

### §9. Site Settings Architecture

- **Runtime Injection**: Retrieve settings like theme colors from the DB at runtime (RootLayout) and inject as CSS variables. Runtime configuration enables design changes without rebuilds

### §10. Next.js 15 Async API Protocol

- **Rule 33.11**: As of Next.js 15, `params`, `searchParams`, `headers`, `cookies`, `draftMode` are Awaitable (Promise)
- **Action**: Always use `await` or React's `use()` hook when referencing these

### §11. Partial Prerendering (PPR)

- **Rule 33.12**: Leverage Next.js 15's Partial Prerendering (PPR) to achieve the optimal combination of static shells and dynamic content
- **Static Shell**: Page layout, navigation, and static content are prerendered as an immediately-delivered static shell
- **Dynamic Streaming**: User-specific content (auth state, personalization, etc.) streams dynamically within `<Suspense>` boundaries
- **Action**: Enable `experimental.ppr: true` in `next.config.ts` and declare `export const experimental_ppr = true` per page
- **Next.js 16 Cache Components**: The `'use cache'` directive reaches GA as the stable version of PPR. Cache boundaries can be declared even within dynamic components

### §302. The next/after API Protocol [NEW]

- **Rule 33.295**: Leverage Next.js 15+'s `after()` API for non-blocking post-response processing
- **Use Cases**: Logging, analytics event dispatch, cache invalidation, and other side effects that don't affect the response
- **Advantage**: Unlike `waitUntil`, `after()` can be used within Server Actions, Route Handlers, Middleware, and `generateMetadata`
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

### §13. The Async-UI Boundary Protocol

- **Rule 33.14**: Directly importing Async Server Components that perform data fetching from UI components (especially Client Components) is prohibited
- **Action**: Components with data logic should render at the top level of `layout.tsx` or `page.tsx` (Server Context) and physically separate from UI using the `children` pattern

### §14. The Component-DTO Interface Protocol

- **Rule 33.15**: Using raw database types (`Row`) in UI component Props definitions is prohibited. Depend on **DTO Interfaces** and hide implementation details

### §15. Production Build Verification Protocol

- **Rule 33.16**: **Code does not "exist" until `npm run build` passes with Exit 0**
- **SSG Awareness**: Importing dynamic APIs like `cookies()` in SSG pages causes production build errors. Separate dynamic dependencies
- **Tiered Database Client Protocol**: SSG/ISR-compatible DB clients must be **physically separated into different files** based on dynamic API dependency vs non-dependency

---

## Part V: Edge Computing & Middleware ⚛️

### §16. Edge Middleware Design

- **Rule 33.17**: Execute authentication checks and geolocation redirects in **Edge Middleware** to minimize latency
- **Rule 33.18**: Keep `middleware.ts` lightweight and exclude static assets from processing scope. Heavy DB queries or external API calls within Middleware are prohibited

### §17. The Non-Blocking Edge Processing Protocol

- **Rule 33.19**: Blocking DB writes unrelated to the main response with `await` in Edge Middleware and API Routes is prohibited
- **waitUntil**: Background side effects using `event.waitUntil()`
- **Error Isolation**: Isolate background processing errors with try-catch

### §18. CSP Worker Integrity

- **Rule 33.20**: Libraries like `heic2any` internally create `Web Workers` and use `blob:` URLs. Explicitly include `worker-src 'self' blob:;` in Middleware CSP settings

---

## Part VI: UI Component Design 🔀

### §19. shadcn/ui + Design Tokens

- **Rule 33.21**: Adopt **shadcn/ui** as the standard UI component library, balancing customizability and accessibility
- **Design Token**: Define project-specific colors, fonts, and shadows as tokens in Tailwind Config's `extend`. Direct HEX value usage is prohibited
- **Class Sorting**: Usage of `prettier-plugin-tailwindcss` is mandatory

### §20. Interactive Components Standard

- **Rich Selection Protocol**: Conventional Radio/Checkbox is prohibited in principle. **"Intuitively clickable rich card-style UI"** is the standard
- **Responsive Combobox Protocol**: Desktop: `Popover` / Mobile: **Drawer (Vaul)**
- **Stable IDs**: `CommandItem` `value` must be a unique, consistent **ASCII string**. Using Japanese in `value` breaks selection logic

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

### §26. The CSS Specificity Protocol

- **Rule 33.28**: Overriding styles with `!important` is **completely prohibited**. Resolve root causes or control through React state management

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

### §303. The CSS Layers (`@layer`) Protocol [NEW]

- **Rule 33.296**: Leverage **CSS Cascade Layers** (`@layer`) to control style priority at the cascade level
- **Layer Order**: Layer declaration order determines cascade priority. Later declared layers take precedence
- **Third-Party Isolation**: Isolate third-party CSS in dedicated layers to prevent conflicts with project styles
- **Tailwind CSS 4 Integration**: Tailwind v4 internally uses `@layer base`, `@layer components`, `@layer utilities`. Understand integration with custom layers
- **Unlayered Styles**: Styles not belonging to any layer take precedence over all layers. Recommend placing all styles in layers to prevent unintended overrides

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

### §304. The CSS `:has()` Selector Protocol [NEW]

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

### §41. The Explicit Initial State Typing Mandate

- **Rule 33.43**: When passing `[]` or `null` to `useState`, explicit generic type parameters are mandatory
- `useState([])` prohibited → `useState<Item[]>([])`
- `useState(null)` prohibited → `useState<User | null>(null)`

### §42. The Compiler Readiness Protocol

- **Rule 33.44**: Promote React Compiler-compatible coding patterns. Avoid excessive manual use of `useMemo` / `useCallback` and implement components as pure functions

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

### §48b. useEffectEvent Hook [NEW]

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

### §305. React Activity Component [NEW]

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

### §306. React `<ViewTransition>` GA Integration [NEW]

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

### §305b. cacheSignal() API [NEW]

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

### §305c. React Performance Tracks (Chrome DevTools) [NEW]

- **Rule 33.326**: Leverage **Performance Tracks** introduced in React 19.2 to visualize React's scheduler behavior and component rendering in Chrome DevTools' Performance panel
- **Feature**: Dedicated tracks with component names are displayed in DevTools, enabling visual understanding of rendering times, re-render causes, and Suspense boundary resolution timing
- **INP Debugging**: Track React's response path to user interactions to identify root causes of INP degradation
- **Status**: Enabled by default in Chrome 131+. Use alongside React DevTools Profiler for both Lab Data and Field Data analysis

### §305d. Batching Suspense Boundaries for SSR [NEW]

- **Rule 33.327**: Understand the **SSR Suspense boundary batch processing** improvement in React 19.2 to enhance SSR streaming consistency
- **Behavior**: When multiple Suspense boundaries can resolve simultaneously, content is displayed in a consistent order between client and server. Animation and layout shift consistency is improved
- **Impact**: Suspense boundary placement design improves users' perceived load speed and CLS. Overly granular boundary splits reduce the batching effect, so setting boundaries at meaningful units is recommended

---

## Part XI: Hydration & SSR Stability ⚛️

### §49. The Hydration Stability Protocol
- **Rule 33.51**: Completely eliminate output mismatches between SSR and client rendering (Hydration Mismatch)
- **Root Cause**: Using `Date.now()`, `Math.random()`, browser-specific globals (`window.innerWidth`, etc.) during SSR causes mismatches
- **Suppress**: `suppressHydrationWarning` is **only permitted for date/time display**. Usage for anything else is prohibited

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
- **Rule 33.70**: Convert full-width alphanumeric user input to half-width (NFKC normalization) before server submission. Japanese characters (Hiragana, Katakana, Kanji) are excluded from NFKC conversion

### §69. The IME Composition Guard
- **Rule 33.71**: Prevent form submission from firing on Enter key press before IME input is confirmed (during composition). Guard with `compositionstart` / `compositionend` events

### §70. The iOS Input Zoom Defense
- **Rule 33.72**: On iOS, focusing `<input>` with `font-size` below **16px** triggers auto-zoom. Guarantee minimum **16px** font size for mobile input fields

### §71. The External Link Protocol
- **Rule 33.73**: Always add `target="_blank"` and `rel="noopener noreferrer"` to external site links

---

## Part XV: Validation & Frontend Security 🌐

### §72. The Anti-Spam Shield
- **Rule 33.74**: Implement Cloudflare Turnstile or reCAPTCHA v3 for public forms (contact, signup, etc.). Combined use with Honeypot fields is recommended

### §73. The Frictionless Security UI Protocol
- **Rule 33.75**: Security measures must not impede user experience. Use Turnstile in invisible mode to maintain user flow

### §74. The Conditional Security Bypass Ban
- **Rule 33.76**: Code that skips authentication checks based on `isAdmin` or `isDev` flags is prohibited. Baseline auth/authorization checks execute on all paths without exception

### §75. The Deep Type Recursion Break Protocol
- **Rule 33.77**: When defining recursive types with Zod or TypeScript, set depth limits with `z.lazy()` or bounded generics. Prevent compilation hangs from infinite recursion

### §76. The Strict DTO Boundary Protocol
- **Rule 33.78**: Receive external data (API Response, URL Params, etc.) as `unknown` type, validate with Zod schema, then cast. `as` type assertions are prohibited

### §77. The URL State Management Protocol
- **Rule 33.79**: Manage UI state for filtering, sorting, pagination via URL SearchParams. `nuqs` library recommended
- **Benefit**: Bookmark sharing, browser history, SSR compatibility

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

### §93. The Dynamic Library Decoupling Protocol
- **Rule 33.95**: Libraries exceeding 30KB (Gzip) are prohibited from main bundle inclusion. Lazy load with `next/dynamic`

### §94. The LCP & Lazy Loading Performance Protocol
- **Rule 33.96**: Above-the-Fold content optimization:
    - Hero images: Apply `priority` attribute. Do not Lazy Load
    - Below-the-Fold images: `loading="lazy"` mandatory
    - `<Suspense>` + Server Component: Progressive display of heavy content via streaming

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

### §307. The Long Animation Frames (LoAF) API Protocol [NEW]

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

### §308. The Scheduler.yield() API Protocol [NEW]

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

### §107. The Structured Data Protocol (JSON-LD)
- **Rule 33.108**: Implement type-safe JSON-LD schemas. Use typed libraries like `schema-dml`; handwritten JSON is prohibited
- **Required Types**: Business-relevant schemas: `Organization`, `WebSite`, `BreadcrumbList`, `FAQPage`, `Product`, etc.

### §108. The Canonical URL Protocol
- **Rule 33.109**: Define `alternates: { canonical: url }` on all public pages to prevent SEO penalties from duplicate content
- **Trailing Slash**: Unify trailing slash usage project-wide (`next.config.ts` `trailingSlash`)

### §109. The Dynamic OGP Protocol
- **Rule 33.110**: Generate OGP images dynamically with `@vercel/og` or `ImageResponse` to improve SNS share CTR
- **Dimensions**: Use 1200×630px (Facebook/LinkedIn standard) as baseline

### §110. The Robots & Sitemap Protocol
- **Rule 33.111**: Implement `app/robots.ts` and `app/sitemap.ts` to ensure crawler access control and page discoverability
- **Dynamic Sitemap**: Retrieve page lists from DB and generate dynamic sitemaps

### §111. The Ghost Content Protocol (Time-Gated SEO)
- **Rule 33.112**: Set `noindex` on pre-publication content to prevent premature indexing by crawlers

### §112. The Microcopy Identity Protocol
- **Rule 33.113**: Unify error messages, labels, and placeholders with the service's Tone & Voice. Avoid generic expressions like "An error occurred"

---

## Part XXI: Technical SEO & GEO 🌐

### §113. The Semantic HTML Landmark Protocol
- **Rule 33.114**: Use semantic HTML elements (`<header>`, `<nav>`, `<main>`, `<article>`, `<aside>`, `<footer>`) to make page structure explicit
- **Heading Hierarchy**: Maintain logical heading structure without skipping levels: `<h1>` → `<h2>` → `<h3>`
- **Single H1 Rule**: Only **one** `<h1>` per page

### §114. The SSR First Protocol
- **Rule 33.115**: Include critical content in the initial HTML via Server Side Rendering. Content rendered only client-side is recognized by crawlers with delay

### §115. The IndexNow Protocol
- **Rule 33.116**: Notify search engines immediately when content updates via IndexNow API, reducing waiting time for crawling

### §116. The GEO (Generative Engine Optimization) Protocol
- **Rule 33.117**: Implement the following optimizations for AI search engines (ChatGPT, Gemini, Perplexity, etc.):
    - FAQ structured data + concise answer paragraphs
    - `llms.txt` / `llms-full.txt` placement
    - E-E-A-T (Experience, Expertise, Authoritativeness, Trustworthiness) enhancement
- **Cross-Reference**: `400_ai_engineering.md`

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

### §129. The Install Prompt Protocol
- **Rule 33.130**: Improve PWA install rates with custom install prompts. Capture `beforeinstallprompt` event and display at appropriate timing

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

### §133. Translation Workflow
- **Rule 33.134**: Split i18n dictionary files (JSON/TS) by namespace and lazy load per page
- **Missing Key Handling**: When translation keys are missing, display fallback language text or the key itself. Rendering empty strings or undefined is prohibited

---

## Part XXV: Error Handling & Resilience 🔀

### §134. Error Boundary
- **Rule 33.135**: Place `error.tsx` (App Router error boundary) in all route segments to prevent unhandled exceptions from showing white screens to users
- **Recovery**: Include "Retry" buttons in error UI to enable user recovery actions

### §135. Global Error Handling
- **Rule 33.136**: Catch fatal errors including RootLayout with `global-error.tsx` and display custom error pages

### §136. Not Found Handling
- **Rule 33.137**: Customize `not-found.tsx` to provide useful navigation (home, search, etc.) on 404

### §137. Offline & Network Resilience
- **Rule 33.138**: API call failure handling:
    - Auto-retry (exponential backoff, max 3 times)
    - Offline detection (`navigator.onLine` / `online`/`offline` events)
    - Optimistic updates + rollback

### §138. Console Warning Protocol
- **Rule 33.139**: `console.error` and `console.warn` are evidence of development failure. Fix all `console.error` calls or replace with proper `Logger`

### §139. Graceful Degradation Protocol
- **Rule 33.140**: Loading failures of external services (Analytics, Chat, Ad, etc.) must not impede the app's primary functionality. Isolate with `try-catch` and display fallbacks

---

## Part XXVI: Server Actions & API Safety ⚛️

### §140. Server Actions Core Principles
- **Rule 33.141**: Place `'use server'` directive at the top of the file to define the entire file as a Server Action file. Inline `'use server'` is prohibited
- **Auth Guard**: Execute authentication checks at the beginning of all Server Actions. Unauthenticated Server Actions are prohibited in principle

### §141. Return Type Safety
- **Rule 33.142**: Server Action return values must be serializable types only. Returning `Date` objects, functions, class instances is prohibited

### §142. Rate Limiting
- **Rule 33.143**: Implement rate limiting for public Server Actions (Contact Form submission, etc.)

### §143. File Upload via Server Actions
- **Rule 33.144**: Pass file uploads to Server Actions via `FormData` and execute server-side validation (file type, size, magic byte verification)

### §144. Mutation Side Effects
- **Rule 33.145**: After data changes (CUD operations) in Server Actions, explicitly invalidate related caches with `revalidateTag()`

### §145. The API Key Isolation Protocol
- **Rule 33.146**: API keys must not be exposed to the client with `NEXT_PUBLIC_` prefix. All API keys are used only in Server Actions / Route Handlers
- **Cross-Reference**: `600_security_privacy.md`

### §146. The Input Sanitization Protocol
- **Rule 33.147**: Validate user input passed to Server Actions with `zod`, then execute sanitization as needed. Using raw user input directly in DB queries or HTML output is prohibited

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
- **Rule 33.154**: Implement cookie consent banners by jurisdiction (GDPR: opt-in / Japan: opt-out)
- **Consent Management**: Control tracking script loading based on user consent state

### §155b. The Post-Privacy Sandbox Tracking Strategy [NEW]

- **Rule 33.328**: Google Privacy Sandbox was **officially discontinued in October 2025**. Third-party cookies persist in Chromium browsers for the foreseeable future, but promote migration to the following privacy APIs:
    - **CHIPS (Cookies Having Independent Partitioned State)**: Secure cross-site data management with partitioned cookies
    - **FedCM (Federated Credential Management)**: Federated login protocol without third-party cookie dependency
    - **Private State Tokens**: Bot detection and user trust verification without cookies
- **Strategic Shift**: Migration to server-side tracking (§152 CAPI integration) is accelerating. Incrementally reduce client-side cookie dependency
- **ITP/ETP Compliance**: Safari (ITP) and Firefox (ETP) already effectively block third-party cookies. Design architecture that does not rely on Chromium cookie persistence
- **Cross-Reference**: `401_data_analytics.md`, `600_security_privacy.md`

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

### §166. Edge Config
- **Rule 33.167**: Manage Feature Flags, A/B test settings, redirect rules, etc. in Edge Config (Vercel Edge Config, etc.) for instant changes without deployment

### §167. CDN Strategy
- **Rule 33.168**: Static asset delivery (images, fonts, CSS/JS) via **CDN** is mandatory
- **Cache-Control**: `public, max-age=31536000, immutable` (hashed assets)

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

### §309. The Navigation API Protocol [NEW]

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

### §310. The CSS `color-mix()` & Relative Color Syntax Protocol [NEW]

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
- **Cross-Reference**: `400_ai_engineering.md`

### §188. The AI Content Rendering Safety Protocol
- **Rule 33.189**: Sanitization (DOMPurify, etc.) is mandatory for HTML/Markdown rendering of AI-generated text. Prevent XSS injection

### §189. The Optimistic AI Response Protocol
- **Rule 33.190**: Display progress indicators during AI task execution (summarization, translation, etc.) and replace with results upon completion

### §190. The AI Rate Limiting UI Protocol
- **Rule 33.191**: Display user-friendly messages ("Please wait a moment") and estimated wait times when AI service rate limits are reached

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

### §203b. The CSP Level 3 Protocol [NEW]

- **Rule 33.329**: Incrementally migrate to **CSP Level 3** Working Draft (W3C 2026)
- **Enhanced Directives**: `script-src-elem`, `script-src-attr`, `style-src-elem`, `style-src-attr` for more precise control over script and style application scope
- **Reporting API v2**: Send CSP violation reports to Reporting API v2 via `report-to` directive, migrating from deprecated `report-uri`
- **Worker CSP**: Separately control Web Worker / Service Worker script sources with `worker-src`

### §204. The CORS Protocol
- **Rule 33.205**: Configure CORS for API Routes / Server Actions with least privilege principle. Wildcard `*` Origin is prohibited in production

### §205. The Dependency Vulnerability Protocol
- **Rule 33.206**: Integrate `npm audit` / `pnpm audit` into CI and automatically block PRs containing high/critical vulnerabilities
- **Cross-Reference**: `602_oss_compliance.md`

### §206. The Permissions Policy Protocol
- **Rule 33.207**: Set `Permissions-Policy` header to explicitly control access to browser features (camera, microphone, geolocation, etc.). Disable unnecessary features with `=()`

### §206b. The OWASP 2026 Compliance Protocol [NEW]

- **Rule 33.330**: Reflect **OWASP Top 10 2026** new categories in frontend design:
    - **A03: Software Supply Chain Failures**: Strengthen vulnerability monitoring for npm/pnpm dependency packages. In addition to CI gating with `npm audit --audit-level=high`, mandate lockfile diff reviews. Consider adopting dependency package signature verification (npm provenance)
    - **A10: Mishandling of Exceptional Conditions**: Strengthen frontend exception handling. Ensure test coverage for all Error Boundaries (§134–§139), monitor unhandled Promise rejections (`unhandledrejection` event listener), mandate complete stack trace capture with Sentry or equivalent
- **Supply Chain Defense**: Validate lockfile integrity with `npm-lockfile-lint` and detect unexpected registry changes
- **Cross-Reference**: `600_security_privacy.md`, `602_oss_compliance.md`

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

### §220. The Fragment Misuse Ban
- **Rule 33.221**: Using `<>...</>` shorthand in list rendering where `key` attributes are needed, leaving key warnings, is prohibited

### §221. The Inline Style Object Ban
- **Rule 33.222**: Inline style objects (`style={{ margin: '10px' }}`) directly in JSX are prohibited in principle

### §222. The Event Handler Inline Function Ban
- **Rule 33.223**: Inline arrow functions as event handlers within list map renders are prohibited in principle

### §223. The Image Without Dimensions Ban
- **Rule 33.224**: Using `<img>` / `<Image>` without `width` and `height` (or `fill` + wrapper sizing) is prohibited. Direct cause of CLS

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

### §255. Passkey Support

- **Rule 33.256**: Support WebAuthn / Passkey to promote passwordless authentication. Leverage `navigator.credentials.create()` / `get()` APIs

### §256. Session Token Security

- **Rule 33.257**: Store session tokens in `HttpOnly`, `Secure`, `SameSite=Lax` cookies. Storing tokens in `localStorage` is prohibited
- **Cross-Reference**: `600_security_privacy.md`

### §257. Auth State UI Protocol

- **Rule 33.258**: Execute auth state-dependent UI switching at the Server Component layer. Auth checks in Client Components are for supplementary use only

### §258. Protected Route Protocol

- **Rule 33.259**: Guard routes requiring authentication at the Edge Middleware level in `middleware.ts`. Do not rely solely on auth checks within page components

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

### §261. The Micro-Interaction Protocol

- **Rule 33.262**: Implement micro-interactions (0.1–0.3s short feedback) for major UI events such as button clicks, form submissions, and state changes

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
- **Cross-Reference**: `602_oss_compliance.md`

---

## Part XLVII: Third-Party Script Management 🌐

### §283. The Third-Party Script Isolation Protocol

- **Rule 33.284**: Third-party scripts (Analytics, Chat, Ad, etc.) must not block the main thread. Lazy load with `next/script`'s `lazyOnload` strategy

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

### §311. The proxy.ts Migration Protocol [NEW]

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

### §312. The `use cache` GA Protocol [NEW]

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

### §313. Turbopack File System Caching [NEW]

- **Rule 33.307**: Enable Turbopack's **File System Caching** (Beta) to dramatically reduce startup times for large applications
- **Config**: Set `experimental.turbopackFileSystemCaching: true` in `next.config.ts`
- **Benefit**: Leverage incremental caching for subsequent `next dev` / `next build` runs, reducing startup time by up to 70%
- **Cache Location**: Automatically saved to `.next/cache/turbopack`. CI cache persistence is recommended

### §314. Next.js DevTools MCP Protocol [NEW]

- **Rule 33.308**: Leverage the **Next.js DevTools MCP** (Model Context Protocol) server for AI-assisted debugging
- **Feature**: Build errors, performance bottlenecks, and routing issues are analyzed by AI assistants with full context awareness
- **Integration**: Integrate with AI-enabled editors (VS Code / Cursor, etc.) to improve development efficiency

### §315. The updateTag API Protocol [NEW]

- **Rule 33.309**: Leverage Next.js 16's `updateTag()` API to update cache tag values without revalidation
- **vs revalidateTag**: `revalidateTag()` invalidates cache and re-fetches. `updateTag()` directly updates the value, reducing server load
- **Use Case**: Maximize cache efficiency for near-real-time updates (inventory counts, like counts, etc.)

### §316. The Incremental Prefetching Protocol [NEW]

- **Rule 33.310**: Leverage Next.js 16's **incremental prefetching** for progressive prefetching based on viewport detection and hover triggers
- **Layout Deduplication**: Shared layouts are downloaded only once; only route-specific data is additionally fetched
- **Priority**: Apply `hovering` trigger for CTAs and main navigation; `viewport` trigger for sidebar links

---

## Part LII: GraphQL Frontend Architecture 🌐

### §317. GraphQL Client Standard [NEW]

- **Rule 33.311**: Use **urql** or **Apollo Client** as the GraphQL client. Select based on the following criteria:
    - **urql**: Lightweight, simple, SSR-friendly. Recommended for small-to-medium projects
    - **Apollo Client**: Advanced caching, local state integration. Recommended for large-scale projects
- **Codegen**: Use `graphql-codegen` to auto-generate type-safe hooks and documents. Manual GraphQL query type definitions are prohibited

### §318. The Fragment Colocation Protocol [NEW]

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

### §319. The Persisted Query Protocol [NEW]

- **Rule 33.313**: Use **Persisted Queries** in production to reduce GraphQL query string network transfer and security risks
- **APQ**: Implement hash-based query identification with Automatic Persisted Queries (APQ)
- **Security**: Reject execution of unregistered queries to prevent GraphQL injection attacks

### §320. The GraphQL Error Handling Protocol [NEW]

- **Rule 33.314**: GraphQL error handling should assume the "partial success" pattern
- **Partial Data**: When `data` and `errors` are returned simultaneously, display available data while notifying the error
- **Error Classification**: Separate network errors (retry-eligible) from GraphQL errors (business logic errors) in processing

---

## Part LIII: Type-Safe API Client & tRPC 🔀

### §321. tRPC Standard [NEW]

- **Rule 33.315**: Consider **tRPC** for full-stack TypeScript projects to achieve end-to-end type safety
- **Benefit**: No API schema definition, type generation, or client code generation required. TypeScript types serve directly as the API contract
- **Limitation**: For non-TypeScript clients (mobile apps, etc.), use REST API / GraphQL alongside

### §322. The OpenAPI TypeScript Client Protocol [NEW]

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

### §323. The API Schema Versioning Protocol [NEW]

- **Rule 33.317**: Implement API schema versioning to clarify the contract between frontend and backend
- **Contract Testing**: Use Consumer-Driven Contract Testing (e.g., Pact) to test the API response structure expected by the frontend
- **Breaking Change Detection**: Automatically detect breaking API schema changes (field removal, type changes, etc.) in CI

### §324. The API Response Normalization Protocol [NEW]

- **Rule 33.318**: API response normalization is a frontend responsibility, implemented in the DTO transformation layer
- **Adapter Pattern**: Centralize API response → frontend model transformation logic in `api/adapters/`
- **Isolation**: Adapters absorb API response structure changes to prevent propagation to the component layer

---

## Part LIV: Frontend Data Quality & Schema Contract 🌐

### §325. The Frontend Data Quality Gate [NEW]

- **Rule 33.319**: All external data received by the frontend (API, WebSocket, localStorage, etc.) must be validated with Zod before consumption
- **Trust Boundary**: The frontend's Trust Boundary extends only to "own component's props." All external data is treated as untrusted
- **Error Recovery**: On validation failure, fall back to default values or error state. Must not crash

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

### §326. The Schema Contract Testing Protocol [NEW]

- **Rule 33.320**: Introduce **schema contract testing** between frontend and backend to detect API structural inconsistencies early
- **Implementation**: Share Zod schema definitions between frontend and backend, testing consistency in CI
- **Monorepo**: Place shared schema packages in `packages/schemas/`

### §327. The Stale Data Detection Protocol [NEW]

- **Rule 33.321**: Manage cached data freshness to minimize the risk of stale data being presented to users
- **Staleness Indicator**: Display a "Last updated: X minutes ago" indicator for data that has exceeded cache validity
- **Auto-Refresh**: Automatically refresh on tab re-display using the `document.visibilitychange` event

### §328. The Runtime Type Narrowing Protocol [NEW]

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

### §329. The Data Invariant Protocol [NEW]

- **Rule 33.323**: Validate business-critical data invariants on the frontend as well
- **Examples**: Stock count ≥ 0, price > 0, start date ≤ end date, total amount = sum of line items
- **Implementation**: Use an `invariant()` utility function for runtime checks, with immediate error reporting on violation

### §330. The Null Object Pattern Protocol [NEW]

- **Rule 33.324**: Instead of passing `null` for unset DB record fields to components, convert to objects with default values using the **Null Object Pattern**
- **Benefit**: Eliminates null check branching in the component layer, improving code readability and testability
- **DTO Layer**: Generate Null Objects during API → DTO transformation

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
| `200_design_ux.md` | §1, §19, §21, §112, §259 |
| `300_engineering_standards.md` | §2, §96, §277 |
| `341_headless_cms.md` | §7 (Hardcoding prohibition) |
| `301_api_integration.md` | §140–§146, §250 |
| `320_supabase_architecture.md` | §89 (DB Query) |
| `400_ai_engineering.md` | §116 (GEO), §187 |
| `401_data_analytics.md` | §153 (Privacy Tracking) |
| `600_security_privacy.md` | §74, §145, §201–§206, §256 |
| `602_oss_compliance.md` | §5, §205, §282 |
| `102_growth_marketing.md` | §116 (GEO Strategy), §151–§155 |
| `301_api_integration.md` | §140–§146, §250, §321–§324 |

