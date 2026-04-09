# 30. Engineering Excellence (General)

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited without explicit "Amend Constitution" instruction.**
> Revision date: 2026-03-31

> [!IMPORTANT]
> **Supreme Directive**
> "Code is a liability, not an asset — every line must justify its existence."
> All engineering decisions must prioritize correctness, security, and maintainability over speed.
> Strictly follow the priority: **Security > Correctness > Maintainability > Performance > Development Speed**.
> This document is the supreme standard for all design decisions regarding engineering quality and standards.
> **13-part, 80-section architecture.**

---

## Table of Contents

| Part | Topic | Sections | Count |
|------|-------|----------|:--:|
| I | Code Quality & Clean Code | §1.0 – §1.9 | 10 |
| II | Infrastructure & Performance | §2.0 – §2.5 | 6 |
| III | Security by Design (DevSecOps) | §3.0 – §3.5 | 6 |
| IV | Technical Debt & Cleanup | §4.0 – §4.4 | 5 |
| V | AI-First Engineering | §5.0 – §5.4 | 5 |
| VI | Green Coding & Sustainability | §6.0 – §6.2 | 3 |
| VII | Zero Bug Policy | §7.0 – §7.3 | 4 |
| VIII | Continuous Learning & Verification | §8.0 – §8.2 | 3 |
| IX | Compatibility & Testing | §9.0 – §9.2 | 3 |
| X | Git & Version Control | §10.0 – §10.6 | 7 |
| XI | Documentation Ops | §11.0 – §11.2 | 3 |
| XII | Engineering Quality Protocols | §12.1 – §12.12 | 12 |
| XIII | Advanced Architectural Mandates | §13.1 – §13.13 | 13 |
| | | **Total** | **80** |

---

## Part I: Code Quality & Clean Code

### 1.0. Naming & Structural Foundations
*   **The Consolidated Naming Convention**:
    *   **Files & Directories**: All file and directory names must use `kebab-case` (e.g., `user-profile-card.tsx`). PascalCase and snake_case are strictly prohibited due to Git case-sensitivity issues across operating systems.
    *   **Components**: File names use `kebab-case`, but component names use `PascalCase`, and function names use `camelCase`.
    *   **The Barrel File Ban**: Re-exporting via `index.ts` (Barrel Files) is prohibited as it causes circular dependencies and hinders Tree Shaking.
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
*   **Zero Tolerance for Band-Aid Solutions**: `// @ts-ignore`, `any` casts, `legacy-peer-deps` are prohibited. Temporary workarounds require `// TODO(#IssueID): reason`.
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
*   **Mandate**: 1. **Impact Scan** all affected files via `grep`. 2. **Approval Gate** if >10 files impacted. 3. **Atomic Fix** all affected files in the same commit/PR.

### 1.9. Codebase-as-Truth Protocol
*   **Law**: When using framework/library APIs, prioritize "existing codebase implementation patterns" over "official documentation."
*   **Action**: Search existing usage via `grep` before using any API. When docs and code conflict, follow the code.
*   **The Silent Async Bug Pattern**: Always use `await` with database write operations and async functions. Enable ESLint `@typescript-eslint/no-floating-promises`.

---

## Part II: Infrastructure & Performance

### 2.0. Infrastructure Standards (The Golden Quad)
*   **Managed Hosting**: Use managed hosting (e.g., Vercel Pro) with DDoS protection and scalability.
*   **BaaS**: Use a Backend-as-a-Service with integrated DB and backup capabilities.
*   **Edge Shield**: Deploy edge WAF/CDN to absorb attacks and load at the edge.
*   **Email Deliverability**: Adopt email infrastructure with excellent developer experience and deliverability.
*   **The Email Deliverability Protocol**: `DMARC`, `SPF`, `DKIM` records are mandatory. Include `List-Unsubscribe` header (RFC 8058) for marketing emails.

### 2.1. Read-Optimized Architecture
*   **Pre-calculation**: Rankings, aggregations, and complex filter results must be pre-calculated during data updates or batch jobs, not on-the-fly per request.
*   **CQRS**: Separate read and write models. Use denormalized read-only tables or materialized views for queries.
*   **The Hybrid CMS Design Strategy**: Manage "layout/order" in JSON and "content" in RDB tables.

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
*   Distrust all inputs (user input, API responses). Validate on both client and server.

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
    1.  **SLSA Level 2+**: Target SLSA Level 2+ for build pipelines with automated provenance generation.
    2.  **Lockfile Pinning**: Verify integrity hashes in lockfiles. Always use `npm ci` in CI.
    3.  **Dependency Review**: Auto-scan new packages for vulnerabilities and licenses via GitHub Dependency Review Action.
    4.  **Sigstore Verification**: Enable package signature verification (npm provenance / Sigstore) when available.
    5.  **SBOM Generation**: Auto-generate SBOM in CI/CD pipelines for each deployment.
*   **Rationale**: As demonstrated by 2025-2026 incidents, attacks on trusted OSS packages are increasing. Only automated verification mechanisms protect the supply chain.

---

## Part IV: Technical Debt & Cleanup

### 4.0. Debt Paydown Strategy
*   Allocate **20%** of sprint capacity to technical debt (refactoring, library updates).
*   **The TODO/FIXME Protocol (Ticket First)**: TODOs without issue numbers are "graffiti." Always include ticket references: `// TODO(#123): Refactor later`.

### 4.1. Tech Radar & Dependency Governance
*   **Quarterly Updates**: Update dependencies quarterly to maintain "safe bleeding edge."
*   **Dependency Watch (24-Hour Mandate)**: **High/Critical** vulnerabilities must be patched within **24 hours**.
*   **The Dependency Override Protocol**: `legacy-peer-deps=true` is unconstitutional. Use `package.json` `overrides` instead.
*   **The License Quarantine (AGPL Block)**: Refer to `600_security_privacy.md` for license governance.

### 4.2. Lockfile Integrity Protocol
*   **Law**: Lockfile inconsistencies causing CI failures are a "cardinal sin."
*   **CI Discipline**: Always use `npm ci` in CI pipelines.
*   **Silver Bullet**: When local/CI behavior diverges, run `rm -rf node_modules package-lock.json && npm install`.
*   **Prohibition**: Pushing without committing lockfile changes after dependency modifications is prohibited.

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
    4.  **llms.txt / AGENTS.md**: Place project overview and constraints for AI agents at the project root.

---

## Part VI: Green Coding & Sustainability

### 6.0. Energy Efficiency
*   **Algorithms**: Write code conscious of computational complexity (Big-O notation). This protects both battery life and the environment.
*   **Dark Mode**: Recommend true black (#000000) dark mode for OLED power savings.

### 6.1. Data Transfer Optimization
*   **Compression**: Always optimize images and videos (AVIF/H.265) to prevent bandwidth waste.
*   **Cache Maximization**: Target CDN cache hit rate of **80%+**.

### 6.2. Centralized Storage Shield
*   Centralize image originals in BaaS storage with CDN optimization for cost-performance balance.

---

## Part VII: Zero Bug Policy

### 7.0. Fix First
*   Never develop new features while known bugs exist. Bug fixes are the top priority.

### 7.1. 24-Hour Rule
*   Critical bugs (data loss, security, major feature outage) must be fixed within **24 hours** of discovery.

### 7.2. Framework Signature Reality (Codebase as Truth)
*   **Law**: Prioritize "existing codebase signatures (actual type definitions)" over official documentation. Always verify existing usage and type definitions via `grep` or IDE before using an API.

### 7.3. Fix Twice Principle
*   When fixing a bug, not only "Fix Once" but also "Fix Twice" — create mechanisms (lint rules, type strictness, tests) to prevent recurrence.

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
*   Test on real devices (iOS, Android), not just simulators. Hardware features (camera, GPS, biometrics) require real devices.

### 9.1. Browser Compatibility
*   Support the latest 2 versions of Chrome, Safari (iOS/macOS), Firefox, and Edge. Pay attention to Safari-specific bugs (100vh issue, etc.).

### 9.2. Self-Check List
*   Before submitting PRs, developers must self-review for "zero warnings," "no console errors," and "no unnecessary logs."

---

## Part X: Git & Version Control

### 10.0. Trunk Based Development
*   **Principle**: Eliminate long-lived branches. Merge short-lived branches to `main` frequently (daily).
*   **Stacked Diffs**: Avoid giant PRs by stacking small, dependent PRs.
*   **Branch Naming Standard**: Use `type/summary` format (e.g., `feat/user-profile`, `fix/login-bug`). Types: `feat`, `fix`, `refactor`, `chore`.

### 10.1. Commit & PR Standards
*   **Conventional Commits**: Follow `type(scope): subject` format strictly.
*   **Atomic Commits**: Each commit contains only "one logical change."
*   **The Pull Request Template Protocol**: Create `.github/pull_request_template.md` with mandatory "Type of change," "How to test," "Screenshots."
*   **The CI Timeout Protocol**: All CI jobs must have `timeout-minutes: 10`. Builds exceeding 10 minutes indicate "design failure."
*   **PR Size**: Keep PRs small. Direct push to `main` is prohibited; CI pass and review approval are mandatory.
*   **Husky Guard (Deep Defense)**: Mandate `pre-push` hook to block direct pushes to `main`.
*   **The Automated Git Hooks Protocol (Lint Staged)**: Mandate `lint-staged` for automatic `eslint --fix` and `prettier --write` on committed files.
*   **The Red Button Checklist**: Before production deployment, mandatory verification of Legal, Security (RLS), FinOps (Spend Cap), and Data.
*   **Branch Hygiene Mandate**: Delete merged branches immediately. Checking `git branch --merged` is an "engineer's breathing."
*   **Omnichannel Check**: During review, prioritize checking "Is this also usable outside Web?"
*   **Deployment Safety Protocol**:
    *   **Supreme Directive: The AI Git Ban**: Refer to `000_core_mindset.md` Rule 8.1 for the absolute prohibition of AI Git operations.
    *   **The Automated Deployment Mandate (CD First)**: Manual deployment to production is **completely prohibited**. CI/CD pipeline only.
    *   **The Architectural Preservation Protocol**: Mark core feature files with `@preservation_level CRITICAL` to prevent AI-initiated destructive changes.
*   **Security**: Never commit secrets. Mandate CI secret scanning (TruffleHog).
*   **The Lockfile Regeneration Reflex**: When only CI fails, first regenerate lockfile: `rm -rf package-lock.json node_modules && npm install`.
*   **The Connection Verification Protocol**: On DB connection errors, first check `.env.local` connection target.

### 10.2. The IPv6 Deployment Protocol
*   **Law**: Do not attempt to fix CI Supabase connection failures caused by IPv6 resolution issues through application code changes.
*   **Action**: Establish connections via Connection Pooler (IPv4).

### 10.3. The Branch Hygiene Mandate (Garbage Collection)
*   **Law**: Abandoned branches are the #1 cause of environment-gap accidents.
*   **Action**: Before final task notification, verify `git branch --merged` and delete merged branches.

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
*   **Law**: True CI pass means zero warnings. `npm run lint` must produce zero warnings. Remove unused variables immediately.

### 12.2. The Clean Import Protocol
*   **Law**: `import` statements must be at the top-level. In-function or in-control-flow imports are strictly prohibited.

### 12.3. The Explicit Explanation Protocol (Zero Jargon)
*   **Law**: Add `Tooltip` to all technical terms and metrics in admin UIs, explaining "what it is and how it impacts the business" in layperson terms.

### 12.4. Localization First Protocol
*   **Action**: Localize all error and validation messages (including Zod custom errors).

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
*   **Law**: Code review is the final line of defense. PR size target: **≤400 lines**.
*   **Review Checklist**:
    | Aspect | Check |
    |:-------|:------|
    | **Type Safety** | No `as any`, proper type definitions |
    | **Security** | No PII exposure, access control verified |
    | **Performance** | No N+1 queries, no unnecessary re-renders |
    | **FinOps** | No infinite DB read loops, proper caching |
    | **i18n** | UI text in operator's native language |
    | **Accessibility** | Keyboard navigable, proper `aria-label` |

### 12.9. The CODEOWNERS Protocol
*   **Law**: Define per-directory owners in `.github/CODEOWNERS`. Require CODEOWNER approval for PR merges.

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
*   **Law**: After merging work branches, local `main` must be **100% synchronized** with remote.
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
*   **Zero `as any` Policy**: Using `as any` or `as never` to suppress type errors is "embedding bugs." Set ESLint `@typescript-eslint/no-explicit-any` to `error`.
*   **Root Cause Resolution**: Resolve type errors through "type definition fixes," "DTO redesign," or "generics application," not casts.
*   **Type Bridge Mandate**: For auto-generated type gaps, define extension types in `database-extensions.ts` using Mapped Types to prevent type collisions.
*   **Linter Suppression Prohibition**: `eslint-disable` / `@ts-ignore` usage is prohibited in principle. If unavoidable, always include reason comment and Issue number.
*   **Generic Type Inference Safety**: Prohibit `Record<string, any>`. Use `Record<string, unknown>` or constrained generics.
*   **Zero Defect Sovereignty**: Committing code that doesn't pass type checking (`tsc --noEmit`) and linting with **zero warnings** is prohibited.

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

---

## Appendix A: Quick Reference Index

| Keyword | Section | Related Rules |
|---------|---------|---------------|
| Naming / kebab-case | §1.0 | `340_web_frontend`, `342_mobile_flutter` |
| DTO / Type Mapping | §13.1, §13.6 | `340_web_frontend` |
| Performance / LCP / CWV | §2.2 | `340_web_frontend`, `502_site_reliability` |
| DevSecOps / Security | §3.0 – §3.5 | `600_security_privacy`, `601_data_governance` |
| Supply Chain Security | §3.5 | `600_security_privacy` |
| Technical Debt | §4.0 – §4.4 | `720_cloud_finops` |
| AI-First / Code Review | §5.0 – §5.4 | `400_ai_engineering` |
| Green Coding | §6.0 – §6.2 | `720_cloud_finops` |
| Zero Bug Policy | §7.0 – §7.3 | `700_qa_testing`, `503_incident_response` |
| Git / Version Control | §10.0 – §10.6 | `502_site_reliability` |
| Documentation Ops | §11.0 – §11.2 | `500_internal_tools` |
| Feature Flags | §13.13 | `502_site_reliability`, `700_qa_testing` |
| Mutation Integrity | §13.5 | `340_web_frontend` |
| CQRS / Cache | §13.4 | `502_site_reliability` |
| Authentication / Access Control | §13.10 | `600_security_privacy` |
| Migration Safety | §13.12 | `502_site_reliability` |
