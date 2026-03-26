# 30. Engineering Excellence (General)

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-03-24

> [!IMPORTANT]
> **Supreme Directive**
> "Code is a liability, not an asset — every line must earn its place."
> All engineering decisions must prioritize correctness, security, and maintainability over speed.
> Strictly follow the priority order: **Security > Correctness > Maintainability > Performance > Development Speed**.
> This document is the supreme standard for all engineering quality and standards decisions.
> **13 Parts, 85 Sections.**

---

## Table of Contents

| Part | Topic | Sections |
|------|-------|----------|
| I | Code Quality & Clean Code | §1 |
| II | Infrastructure & Performance | §2 |
| III | Security by Design (DevSecOps) | §3 |
| IV | Technical Debt & Cleanup | §4 |
| V | AI-First Engineering | §5 |
| VI | Green Coding & Sustainability | §6 |
| VII | Zero Bug Policy | §7 |
| VIII | Continuous Learning & Verification | §8 |
| IX | Compatibility & Testing | §9 |
| X | Git & Version Control | §10 |
| XI | Documentation Ops | §11 |
| XII | Engineering Quality Protocols | §12 |
| XIII | Advanced Architectural Mandates | §13 |

---

## 1. Code Quality & Clean Code

### 1.0. The Supreme Directive
*   **The Consolidated Naming Convention**:
    *   **Files & Directories**: All file and directory names are unified as `kebab-case` (e.g., `user-profile-card.tsx`). PascalCase and snake_case cause Git compatibility issues (Case Sensitivity) across OSs and are strictly prohibited.
    *   **Components**: File names are `kebab-case`, but component names are `PascalCase` and function names are `camelCase`.
    *   **The Barrel File Ban**: Re-exports via `index.ts` (Barrel Files) are principally prohibited as they cause circular references and inhibit Tree Shaking.
- **UI/Logic Consistency**:
  - **Principle**: "Similar but different" shows a lack of professionalism and is a bug. UI and logic must be unified across all features (Delete, Edit, List).
  - **Tiered Security**: Security is tiered according to risk.
    - **Tier 1**: General single operations require "Confirmation only".
    - **Tier 2**: Bulk operations and **Critical Single Operations (e.g., User Deletion)** require "High-Assurance Verification (OTP, Passkey, 2FA, etc.)". Deviating from this based on personal judgment is not permitted.
*   **The Hierarchical Data Principle (1:N Core)**:
    *   **Law**: When designing complex domains (lifetime data, contracts, high-confidentiality records, etc.), always define a root parent table (e.g., `users`, `accounts`, `master_records`) and hang related data in a loosely-coupled parent-child $1:N$ hierarchy. Stuffing into a single giant table (God Table) is a defeat that breaks migration and RLS design.
*   **The Tiered Service Mandate (Subscription Gating)**:
    *   **Law**: Restrictions by service level (Free/Paid) such as registration counts, AI usage limits, etc. MUST be enforced **server-side (Server Guards)**. Relying only on frontend display control is prohibited as it allows API request bypass.
    *   **Upsell Trigger**: On limit exceeded, return a clear message with upgrade path, not just an "error".
*   **The Interoperable Ecosystem Mandate**:
    *   **Law**: Treat important domain data (achievements, qualifications, records, etc.) held in the app as "standardized assets" usable outside the system. Locking in proprietary specs is defeat that blocks future service integration and value delivery to users.
    *   **Portable Design**: Comply with industry-standard schemas, constants, and international standards as much as possible, designing data itself to have "portability" as a trustworthy certificate to other systems.
*   **Structure First Protocol**:
    *   **Law**: Important business data (qualifications, contracts, health status, assets, etc.) should be managed as master data (M:N) or tag format structured data, not as text (unstructured data).
    *   **Future-Proof Data Strategy (LTV & FinOps)**:
        *   **Context**: Certain data (e.g., medical expenses, failure rates, lifetime events) may become "golden data" for future insurance proposals, advanced personalization, or business model pivots even if currently unneeded.
        *   **Law**: When data modeling, design to retain metadata (cost, timestamps, types, events) that may contribute to future FinOps or LTV maximization in structured form. Minimize "add later" costs and ensure data continuity.
    *   **Autonomous Structure Strategy (Edge AI)**:
        *   **Law**: Avoid forcing users to type whenever possible. Non-structured physical assets (paper certificates, receipts, documents) should have standard implementation flows that use OCR/Vision AI to auto-convert to "high-precision structured data" instantly.
        *   **Standard**: "Just take a photo and all important items go into DB" UX is the supreme mandate for data quality maintenance and user retention improvement.
        *   **Human-in-the-Loop Mandate**: Data extraction/conversion results by AI (OCR/Vision, etc.) MUST always be treated as **"Draft"**, forcing a flow where **users visually verify and correct the results before pressing "Save"**. Direct DB writes by AI (Auto-Save) are prohibited due to the risk of erroneous data contamination.
        *   **PII Scrubbing**: When documents or images processed by AI contain personal information (names, addresses, phone numbers, etc.), do not store them as-is in OCR/AI results — automatically discard or mask them (replace with `***`, etc.). In particular, third-party personal information MUST NOT be retained as structured data without the individual's consent.
*   **Clean Code Standards**:
    *   **Self-Documenting**: Comments explain "Why", Code explains "What".
    *   **Function Size**: One function, one job. Ideally **under 20 lines**.
    *   **Naming**: Clear and descriptive names. No `data`, `temp` (e.g., `userData` -> `authenticatedUserProfile`).
*   **Blueprint Compliance**:
    *   **Entry Point**: All development work starts by checking the corresponding rule files.
    *   **Update First**: If design changes are needed during implementation, **update the Blueprint before (or while) coding**. Discrepancy between docs and code is the biggest technical debt.
    *   **Code as Documentation**: Blueprint files are part of the code. When implementation changes, always update corresponding rule files to prevent drift.
*   **Zero Warnings**:
    *   **Rule**: Warnings are Errors. CI fails on a single warning. Prevent "Broken Windows Theory".
    *   **Strict Error Handling**: No empty `catch` blocks. All errors must be logged and handled appropriately.
    *   **Zero Tolerance for Band-Aid Solutions**:
        *   **Prohibition**: `// @ts-ignore`, `any` casts, `legacy-peer-deps` are "thoughtless" and defeat as an engineer.
        *   **Mandate**: If temporary workaround is needed, MUST include `// TODO(#IssueID): reason` with ticket number. Silent `ignore` is immediate Reject target.
    *   **The Incident Response Protocol (SRE)**: 
        1. **Plan & Drill**: Define contact chain and initial response (service stop criteria, log preservation) for security incidents (data leaks, unauthorized access) and drill semi-annually.
        2. **Post-Mortem & Blueprint Sync**: After incident response, identify and verbalize root cause, then immediately reflect lessons in **Blueprint** as one indivisible process.
    *   **The Anti-Blindness Protocol (AI Hygiene)**:
        *   **Law**: Physically prohibit saving abbreviations like `// ...` or `// implementation details` in AI-generated code to files.
        *   **Action**: Always expand to **complete code**. Abbreviated code is not "bug" but "void" that crashes the system.
    *   **The System Transparency Protocol (Stack Card)**:
        *   **Law**: Maintain version information of tech stack (Framework, DB, UI Lib) in `PROMPT.md` or `tech_stack.md` in current state always.
        *   **Reason**: AI agents have no way to know the "current" environment. Accurate version information is the lifeline for accurate code generation.
*   **Refactoring (The Boy Scout Rule)**:
    *   **Mandate**: Leave the code cleaner than you found it. Always make small improvements (rename, extract function) when touching a file.
    *   **No "Later"**: "Refactor later" is a lie. Now or never.
    *   **Cyclomatic Complexity**: Keep nesting shallow. Use Early Returns.
*   **Cleanup**:
    *   **Dead Code**: Delete immediately. No commented out code, no unused imports, no console.logs.
    *   **The Dependency Governance Protocol**:
        *   **Dual Governance**: If environment diff errors occur in packages with native dependencies, force version unification using `overrides` field in `package.json`.
        *   **The License Quarantine (AGPL Block)**: Strictly prevent unrelated open source code contamination. Reference `600_security_privacy.md` Rule 5 for **AGPL (Affero GPL)** prevention.
    *   **The Console Log Ban (Information Leakage)**:
        *   **Law**: Leaving `console.log` in production build is debugging info leakage and hotbed for sensitive info (token/PII) leak.
        *   **Action**: Physically block by setting `eslint-plugin-no-console` to `error` in CI. Send necessary logs to Sentry via `logger` library.
    *   **The Privacy Scrubbing Protocol (EXIF Wipe)**:
        *   **Context**: User Generated Content (UGC) images may contain personal info like GPS coordinates.
        *   **Law**: Mandate **physical deletion of EXIF data** in client-side image upload processing. Sanitize metadata on browser before reaching server.
    *   **The Backup File Ban (No .bak)**:
        *   **Law**: "Just in case" backup files (`.bak`, `.old`, `_copy`) are noise in Git, polluting search results and inviting confusion with latest code.
        *   **Action**: Backup is Git history. Immediately delete file system backup files. Only production files should exist when `ls` is run.
    *   **The Exhaustive Reference Scan (Grep First)**:
        *   **Law**: Deleting files based on "my memory" is "gambling" inviting undetected import errors and build breakage.
        *   **Action**: When deleting/renaming files, MUST perform **`grep` search** by filename across entire project to identify and eliminate all references.
    *   **The Ghost Feature Ban**: Features without user access paths (unreleased admin code etc.) are debt. Physically delete following YAGNI principle.
    *   **The Ghost Feature Revival (Full-Stack Coherence)**:
        *   **Law**: Features where admin settings change but nothing happens on frontend (Ghost Feature) are bugs destroying trust.
        *   **Action**: When adding admin settings, simultaneously implement frontend reflection logic (CSS var injection, API field display) and perform integration test. Half implementation is "incomplete".
    *   **TODO Management**: If leaving `// TODO:`, always include ticket number or deadline. Abandoned TODOs are technical debt.
*   **Root Cause First (The Root Cause First Protocol)**:
    *   **Prohibition**: Applying "just make it work" fixes (Band-Aid Fixes) without identifying the root cause when errors occur is prohibited.
    *   **Process**:
        1.  **Reproduce**: Reliably reproduce the error locally.
        2.  **Diagnose**: Analyze logs, stack traces, dependency trees, etc. and verbalize "why it happened."
        3.  **Fix Root**: Instead of ad-hoc mitigations (disabling SSL verification, type casts, `--legacy-peer-deps`), resolve the root cause (certificate renewal, type definition fix, `overrides` configuration).
    *   **Rationale**: Band-Aid fixes are "time bombs." They work short-term but cause unpredictable failures during environment changes or library updates.
*   **Config Change Impact Analysis (The Config Change Impact Analysis Protocol)**:
    *   **Context**: Changes to project-wide configuration files — build settings (`next.config.ts`, etc.), compiler settings (`tsconfig.json`, etc.), style settings (`tailwind.config.ts`, etc.) — can propagate unexpected impacts across the entire codebase.
    *   **Mandate**:
        1.  **Impact Scan**: Before changing configuration, identify all potentially affected files using `grep`.
        2.  **Approval Gate**: When affected files exceed 10, obtain reviewer or responsible person's approval before applying changes.
        3.  **Atomic Fix**: Fix all affected files in the same commit (or PR) to prevent half-applied states.
    *   **Scan Examples**:
        *   `trailingSlash` change → Scan all `router.push` / `redirect` / `Link href`
        *   `paths` alias change → Scan all `import` statements
        *   `images.remotePatterns` change → Scan all `<Image>` components
*   **The Silent Async Bug Pattern**:
    *   **Law**: Promise-returning asynchronous operations such as database writes (`.insert()` / `.update()` / `.delete()` / `.upsert()`) and external API calls **MUST always have `await`**. A missing `await` causes writes to "silently fail" — no error is thrown and data is lost, making this the most diagnostically challenging bug.
    *   **Action**:
        1.  Immediately fix any Promise-returning operation inside an `async` function that lacks `await`.
        2.  Enabling the ESLint rule `@typescript-eslint/no-floating-promises` is recommended.
        3.  During audits, use `grep` to detect missing `await` on DB operations.
    *   **Anti-Pattern**: `supabase.from('messages').insert({ content: text })` (❌ no await — Promise floats and silently fails)
*   **The Codebase-as-Truth Protocol**:
    *   **Law**: When using framework or library APIs, treat **"existing codebase implementation patterns"** as the source of truth over **"official documentation"**. Documentation may be outdated, but working code is always current.
    *   **Action**:
        1.  Before using an API or function, MUST search for existing usage examples with `grep` and follow the patterns established within the project.
        2.  When official documentation contradicts existing code implementation, prioritize the existing code implementation.
        3.  When introducing new patterns, verify consistency with the existing codebase and unify existing code first if inconsistencies exist.
    *   **Rationale**: Official documentation can lag behind version upgrades or deprecations. Prevents time waste from "it doesn't work even though I followed the docs."

### 1.1. Supreme Directive: Omnichannel & Headless First Protocol
*   **Web is just ONE Client**:
    *   **Definition**: When designing the entire system, the "Website (Next.js)" is just **one of many** clients.
    *   **Vision**: Assumes future native apps (iOS/Android), external media integrations, IoT delivery, AI agent interactions.
*   **API Mandate**:
    *   **Law**: **All features and data** must be provided through reusable APIs (Headless Architecture).
*   **Prohibition (The Web-Only Ban)**:
    *   **Felony**: Business logic encapsulation in React components or HTML structure-dependent data design (Web Only design) is **strictly prohibited as "violation of highest priority items"**. Immediate Reject target.

### 1.2. Supreme Directive: Realism First Protocol (Anti-Haribote)
*   **Definition**:
    *   **Haribote (Facade)**: Features where UI (skin) exists but "data persistence" and "re-fetch (Hydration)" are not completely done behind it are defined as **"Deceptive Implementation"** for any reason, and NOT considered implementation complete.
*   **Mandate (The Vein Check)**:
    *   **Rule**: Feature completion is NOT UI rendering, but verifying that data vessels (Round-Trip) of **"UI → Action → DB → Action → UI"** are connected before committing.
    *   **Physical Verification**: Obligation to verify **values are physically written** in DB (psql/Table Editor), not just dev tools. "Looks like it's working" is prohibited.
*   **Deception Penalty**:
    *   Including settings screens that don't save or input forms that disappear on reload in PRs is **Betrayal** to reviewers and users; freeze all work until fix is complete.

## 2. Infrastructure & Performance
*   **Infrastructure Standard (The Golden Quad)**:
    *   **Managed Hosting**: Use managed hosting (e.g., Vercel Pro) with DDoS protection and scalability.
    *   **BaaS**: Use BaaS (e.g., Supabase) with integrated DB and backups as the "Single Source of Truth".
    *   **Edge Shield**: Deploy Edge WAF/CDN (e.g., Cloudflare) to absorb attacks and load at the edge.
    *   **Email Deliverability**: Adopt email infrastructure (e.g., Resend) with excellent DX and deliverability.
    *   **The Email Deliverability Protocol (DMARC/RFC 8058)**:
        *   **Authentication**: Setting `DMARC`, `SPF`, `DKIM` records is **mandatory**. Sending from domains without these is blocked by major providers (Gmail/Yahoo) and considered **"functionally broken"**.
        *   **One-Click Unsubscribe**: Marketing emails MUST include `List-Unsubscribe` header (RFC 8058) enabling 1-click unsubscribe from native email apps. Without this, spam judgment risk is maximized and domain reputation is damaged.
*   **Read-Optimized Architecture**:
    *   **Pre-calculation**: Store calculated values (ranking, total sales) in DB columns at data update time or periodic batch. No on-the-fly calculation per request.
    *   **CQRS**: Separate read and write models. Use denormalized read-only tables or materialized views for reads.
    *   **The Hybrid CMS Design Strategy (Layout vs Content)**:
        *   **Context**: Normalizing sort order and display settings (RDB) complicates UI implementation and causes N+1.
        *   **Action**: Manage "layout/order" as JSON (`site_settings.sidebar_order`) and "content" as RDB tables (`posts`) as standard hybrid configuration. Balance JSON flexibility with SQL searchability.
*   **Performance Budgets**:
    *   **Lighthouse**: Maintain **90+** on all metrics (Performance, Accessibility, Best Practices, SEO).
    *   **Core Web Vitals**: LCP (≤2.5s), **INP (≤200ms)**, CLS (≤0.1) are mandatory.
*   **Asset Optimization**:
    *   **Images**: Force next-gen formats (AVIF/WebP). Use optimization components like `next/image`.
    *   **Lazy Loading**: Lazy load all assets below the fold (Above the fold excluded).
    *   **The Fixed Page Protocol (Dynamic Static Pages / SEO & Legal)**:
        *   **Law**: Creating "static but updatable pages" (Terms of Service, Privacy Policy, Legal Commerce Act) as physical `page.tsx` files is strictly prohibited.
        *   **Action**: Use dynamic routes like `src/app/(public)/[slug]/page.tsx` and fetch content from DB `fixed_pages` table (or `site_settings`). This eliminates code change/redeploy time lag for legal amendments and physically guarantees compliance.
*   **API-Free First Protocol**:
    *   **Law**: Before adopting paid external APIs (Geocoding, address autocomplete, image optimization, etc.), you are obligated to consider the following free alternatives. Casual adoption of paid APIs is a FinOps defeat.
    *   **Free Alternatives Checklist**:
        1.  **Extract from existing data**: Consider whether needed information can be obtained via URL parsing, metadata analysis, etc.
        2.  **Client-side APIs**: Leverage browser-standard APIs such as Browser Geolocation API, Web Crypto API, etc.
        3.  **Open data**: Utilize publicly available datasets such as postal code→address databases, public statistics, etc.
        4.  **Fetch-once → DB-save pattern**: For data that doesn't change frequently (coordinates, address autocomplete results, currency rates), fetch once and save to DB for reuse.
    *   **Documentation**: When adopting a paid API, explicitly state in the implementation plan "why free alternatives are not feasible."

## 3. Security by Design (DevSecOps)
*   **Zero Trust**:
    *   Trust no input (user input, API responses). Validate on both client and server.
*   **Secrets Management**:
    *   Never commit secrets. Use `.env` and secret managers.
    *   **The Single Source of Config**:
        *   **Prohibition**: Directly referencing `process.env.NEXT_PUBLIC_...` throughout code (in components, etc.) causes modification omissions and lacks type safety—prohibited.
        *   **Action**: Centrally manage in `src/lib/config` (or `env.ts`) and reference only that constant object throughout the application. Recommend existence validation in this layer.
    *   **The Environment Template Sync Protocol**:
        *   **Law**: A `.env.example` (or `.env.template`) file MUST be maintained at the project root, recording **only the keys** of all required environment variables (values should be empty strings or placeholders).
        *   **Sync Mandate**: When adding new environment variables, `.env.example` MUST also be updated **in the same PR**. Failure to do so is considered an "onboarding failure for new developers."
        *   **Git Safety**: Files containing actual values such as `.env.local` / `.env.production` MUST be included in `.gitignore` and **MUST NEVER be committed**.
        *   **Rationale**: Projects without a `.env.example`, or with an outdated one, are a "breeding ground for tribal knowledge" where new members spend hours on environment setup and constantly ask existing members for help.
    *   **The Environment Variable Drift Prevention Protocol**:
        *   **Law**: Missing environment variables or inconsistencies across environments (Drift) are the primary cause of "works locally but breaks in CI/production." Build mechanisms to automatically verify the completeness of environment variables.
        *   **Action**:
            1.  **Startup Validation**: Execute existence checks (validation) for all required environment variables at application startup, and **abort startup** if any are missing. Physically prevent the state of "running with `undefined` and crashing midway."
            2.  **CI Parity Check**: Add a step in the CI pipeline to verify that all keys listed in `.env.example` are defined as secrets/variables in the CI environment.
            3.  **Type-Safe Config**: Beyond retrieving environment variables as strings, perform **type-level validation** using Zod, io-ts, or similar to detect invalid values (empty strings, malformed URL formats, etc.) at startup.
        *   **Rationale**: Missing environment variables are infrastructure configuration bugs, not code-level bugs, and cannot be detected by type checking or linting. Startup validation is the only reliable means to detect this category of bugs "immediately after deployment."

## 4. Technical Debt & Cleanup
*   **Debt Paydown**:
    *   Allocate **20%** of sprint to debt repayment (refactoring, library updates).
    *   **The TODO/FIXME Protocol (Ticket First)**:
        *   **Law**: `// TODO:` or `// FIXME:` in code without a ticket (Issue) is just "graffiti".
        *   **Action**: When leaving TODO comments, MUST include corresponding Issue number (e.g., `// TODO(#123): Refactor later`). TODOs without numbers are rejected in PR.
*   **Tech Radar**:
    *   **Regular Updates**: Update dependencies quarterly and always maintain "safe Bleeding Edge".
    *   **Dependency Watch (24-Hour Mandate)**: Run `npm audit` regularly. If **High/Critical** vulnerabilities are found, MUST apply patch (`npm audit fix`) or emergency workaround within **24 hours** of discovery.
*   **Digital 5S**:
    *   **Seiri**: Delete unused code (Dead Code), images, files immediately. No commented-out code.
    *   **The Dependency Governance Protocol**:
        *   **Dual Governance**: For environment difference errors with packages containing native dependencies (`tree-sitter`, etc.), use `package.json` `overrides` field to force version unification.
        *   **The License Quarantine (AGPL Block)**: For license governance details, refer to `600_security_privacy.md` Rule 5 and thoroughly prevent **AGPL (Affero GPL)** usage.
        *   **The Lockfile Integrity Protocol**:
            *   **Law**: CI failures and "ghost errors" caused by lockfile (`package-lock.json` / `yarn.lock`) inconsistencies are classified as a "mortal sin."
            *   **CI Discipline**: MUST use `npm ci` (or equivalent) in CI pipelines to strictly enforce the lockfile. Using `npm install` in CI is an act of ignoring the lockfile and is prohibited.
            *   **Silver Bullet**: When behavior differs between local and CI, before spending time investigating, execute `rm -rf node_modules package-lock.json && npm install` to completely regenerate the lockfile.
            *   **Prohibition**: Pushing without committing the lockfile after dependency changes is prohibited.
    *   **The Console Log Ban (Information Leakage)**:
        *   **Law**: Leaving `console.log` in production builds is debug info spill and source of sensitive information (tokens, PII) leakage.
        *   **Action**: Set `eslint-plugin-no-console` to `error` and physically block in CI. Send necessary logs to Sentry etc. via `logger` library.
    *   **The Privacy Scrubbing Protocol (EXIF Wipe)**:
        *   **Context**: User-uploaded images (UGC) may contain personal info like shooting location (GPS coordinates).
        *   **Law**: **Physical deletion of EXIF information** is mandatory in client-side image upload processing. Sanitize metadata in browser before reaching server.
    *   **The Backup File Ban (No .bak)**:
        *   **Law**: "Just in case" backup files (`.bak`, `.old`, `_copy`) are noise under Git management, pollute search results, and cause confusion with latest code.
        *   **Action**: Backup is Git history. Delete backup files on filesystem immediately. `ls` should show only production files.
    *   **The Exhaustive Reference Scan (Grep First)**:
        *   **Law**: Deleting files based on "memory" is a gamble that causes undetected import errors and build breakage.
        *   **Action**: When deleting/renaming files, MUST **`grep` search** the entire project by filename to identify and eliminate all references before executing.
    *   **The Dead Export Detection Protocol**:
        *   **Law**: When the usage count of exported functions, types, or constants drops to zero, they MUST be immediately removed. Not just "Dead Code" — "Dead Exports" are also debt.
        *   **Action**:
            1.  During audits, verify usage of all exports with `grep -r "functionName" src/`.
            2.  Remove exports with zero usage immediately, and chain-cleanup related type definitions.
            3.  If a type alias (`type X = Y`) is the only usage site, consider removing the alias entirely.
        *   **Rationale**: Dead Exports tend to be left alone due to the psychological block of "someone might be using this," but unused exports complicate the dependency graph, inhibit Tree Shaking effectiveness, and increase cognitive load during refactoring.
    *   **The Ghost Feature Ban**: Features with no user navigation (unpublished admin screen code, etc.) are debt. Physically delete per YAGNI principle.
    *   **The Ghost Feature Revival (Full-Stack Coherence)**:
        *   **Law**: Features where settings change in admin screen but nothing changes in frontend (Ghost Feature) are bugs that destroy system trust.
        *   **Action**: When adding admin screen settings, MUST implement frontend reflection logic (CSS variable injection, API item display, etc.) simultaneously and perform integration tests. Half-design implementation is "incomplete".

## 5. AI-First Engineering
*   **Prompt Driven Development (PDD)**:
    *   **Principle**: Code is not written by humans, but by AI. The "prompt" is the true source code.
    *   **AI Friendly**: Make variable and function names extremely descriptive for AI context understanding (e.g., not `x` but `daysSinceLastLogin`).
*   **RAG Optimization**:
    *   **Modular**: Keep file sizes small (Atomic) and don't overwhelm AI context windows.
    *   **Explicit Imports**: `import` statements MUST be at file **Top-Level**. Imports inside functions or control flows inhibit static analysis and make AI understanding difficult.
    *   **Semantic Structure**: Organize directory structure by feature to make it easy for AI to find related files.
*   **Schema Trust Protocol (No Ghost Columns)**:
    *   **Law**: Using column names in queries (SELECT/INSERT/UPDATE) that are planned in the Blueprint but whose DB migration has not yet been applied is prohibited. Accessing non-existent columns crashes the entire page.
    *   **Action**: Limit query columns to those that "currently, definitely exist." Supplement data for unimplemented features with application-layer constants (Default Config).

## 6. Green Coding & Sustainability
*   **Energy Efficiency**:
    *   **Algorithm**: Be conscious of computational complexity (O-notation) and write code that doesn't waste CPU cycles. This protects both battery life and the environment.
    *   **Dark Mode**: Recommend True Black (#000000) for OLED power saving.
*   **Data Transfer**:
    *   **Compression**: Always optimize images and video (AVIF/H.265) to prevent network bandwidth waste.
    *   **Cache Maximization**: Target CDN cache hit ratio of **80%+** to minimize origin load for static assets.
    *   **Centralized Storage Shield**: Centralize image entities in BaaS Storage (Origin) and route delivery via CDN Optimization features to balance cost and performance.

## 7. Zero Bug Policy
*   **Fix First**: Do not develop new features with known bugs. Bug fixing is top priority.
*   **24-Hour Rule**: Critical bugs (data loss, security, major feature outage) must be fixed within **24 hours** of discovery.
*   **The Framework Signature Reality (Codebase as Truth)**:
    *   **Context**: Official library/framework documentation may be outdated.
    *   **Law**: Consider "existing codebase signatures (actual type definitions)" as truth over official docs. Before using APIs, always check existing usage examples and type definitions via `grep` or IDE definition jump. "Wrote it per docs but it doesn't work" is not an excuse.
*   **The Fix Twice Principle (Recurrence Prevention)**:
    *   When fixing bugs, not just "Fix Once" but also "Fix Twice"—create mechanisms to prevent the same bug from recurring (add Lint, strict types, add tests)—as one set.

## 8. Continuous Learning & Verification
*   **Latest Info Protocol**:
    *   **Before Coding**: Check official docs and latest release notes (e.g., "Next.js 15 breaking changes", "Swift 6 concurrency") BEFORE coding. Implementations based on old info cause rework.
    *   **Deprecation Check**: Verify APIs you're about to use are not Deprecated.
*   **Trend Awareness**: Continuously catch up with Silicon Valley trends (AI Agents, Privacy Manifests, etc.) and keep evolving the rules themselves.
*   **The Crystallization Protocol (Knowledge Extraction)**:
    *   **Law**: After completing a feature implementation, you are obligated to document "tacit knowledge," "new patterns," and "pain points" encountered during the process back into design documents (Blueprints) or rule files.
    *   **Rationale**: Knowledge existing only in code is "volatile experience." To prevent the next developer (human or AI) from repeating the same mistakes, the habit of immediately documenting learnings exponentially improves team productivity.

## 9. Compatibility & Testing
*   **Real Device Testing**: Test on real devices (iOS, Android), not just simulators. Hardware features (camera, GPS, biometrics) require real devices.
*   **Browser Compatibility**: Support last 2 versions of Chrome, Safari (iOS/macOS), Firefox, Edge. Be especially careful of Safari (iOS) specific bugs (100vh issue, etc.).
*   **Self-Check List**: Before PR, developers self-review code and confirm "zero warnings", "no console errors", "deleted unused logs".

## 10. Git & Version Control
*   **Development Flow (Trunk Based Development)**:
    *   **Principle**: Abolish long-lived branches; frequently merge (daily) from short-lived branches to `main`.
    *   **Stacked Diffs**: Recommend stacking small dependent PRs rather than huge PRs.
    *   **Branch Naming Standard**: Unify branch names as `type/summary` format (e.g., `feat/user-profile`, `fix/login-bug`). Types: `feat` (feature), `fix` (fix), `refactor` (improvement), `chore` (housekeeping).
*   **Conventional Commits**: Strict `type(scope): subject` format (e.g., `feat(auth): add google login`). Body describes details.
    *   **Atomic Commits**: Include only "one logical change" per commit. Maintain granularity that allows reverting "only that commit" to fix a bug.
*   **Pull Requests**:
    *   **The Pull Request Template Protocol**:
        *   **Law**: Create `.github/pull_request_template.md` forcing reviewers to input "what, why, how to verify".
        *   **Content**: "Type of change", "How to test", "Screenshots" are mandatory.
    *   **The CI Timeout Protocol**:
        *   **Law**: Set `timeout-minutes: 10` on all CI jobs. Builds exceeding 10 minutes are considered "design mistakes" to prevent resource waste and infinite loops.
    *   **100-Line Rule**: Keep PRs small. Require CI (Build, Test, Lint) pass and review.
    *   **Omnichannel Check**: Reviewers MUST check "Is this change available for non-Web (iOS/Android)?". "Web Only" logic must be Rejected immediately.
    *   **Husky Guard (Universal Mandate - Deep Defense)**:
        *   **Law**: Implementation of **Husky** and `pre-push` hooks prohibiting direct pushes to `main`/`master` is a **Universal Mandate** in all projects. Even if server-side protection exists, physically duplicate defense lines (Deep Defense) to make "accidental push" excuses physically impossible.
        *   **Law 2 (No Human Trust)**: "I'll be careful" rules are meaningless. Trust only mechanics (Code not Policy) that make pushing physically impossible.
        *   **Action**: Running `npx husky init` to set up guardrails is a mandatory requirement during project initialization phase.
    *   **The Automated Git Hooks Protocol (Lint Staged)**:
        *   **Law**: Eliminate human "care". Mandate `lint-staged` to automatically execute `eslint --fix` and `prettier --write` on committed files.
        *   **Outcome**: Physically prevent "dirty code" from entering Git history.
    *   **The Red Button Checklist (Deploy Final Gate)**:
        *   **Law**: Immediately before production deployment, mandatory "Point-and-Call" verification of:
            1. **Legal**: ToS/Privacy Policy up to date?
            2. **Security**: RLS Policy tested with `Anon`?
            3. **FinOps**: Cloud Budget Cap (Spend Cap) active?
            4. **Data**: Production Master Data inserted?
    *   **Branch Hygiene Mandate (Garbage Collection)**:
        *   **Law**: Leaving merged local branches is "shameful act as engineer" inviting accidents and confusion.
        *   **Action**: Before Final Notify, MUST check `git branch --merged` and physically delete merged branches. "Merge then Delete" is breathing.
*   **Deployment Safety Protocol**:
    *   **Supreme Directive: The AI Git Ban (Refer to 00)**:
        *   **Ref**: Absolute prohibition of AI Git operations. Refer to Rule 8.1 in `000_core_mindset.md`.
    *   **No Unauthorized Push**: The AI Agent MUST NOT execute `git push` without user's explicit permission.
    *   **Pre-Check**: Always pass `tsc --noEmit` (Type Check) and `npm run build` (Build Check) locally before pushing.
    *   **The Automated Deployment Mandate (CD First)**:
        *   **No Manual Deployment**: Deploying to production (including DB changes) via manual developer commands (e.g., `supabase db push`) is the root cause of operation errors and inconsistencies, and is **strictly prohibited**.
        *   **CI/CD Only**: Deployment must only be executed as a result of "verified code" passing through a "trusted pipeline (GitHub Actions)". Eliminate human error.
    *   **The Architectural Preservation Protocol (Code Sanctuary)**:
        *   **Context**: Prevents accidental deletion (Friendly Fire) of core features by automatic refactoring or cleanup tasks.
        *   **Action**: Add the header **`@preservation_level CRITICAL`** to files constituting core project features. The AI must never delete, move, or destructively change files with this mark without users' explicit approval.

*   **Security**: No secrets in repo. TruffleHog/gitleaks scan required.
    *   **The Lockfile Regeneration Reflex (CI Consistency)**:
        *   **Problem**: If `build/lint` passes locally (macOS) but fails in CI (Linux), 90% of the time the cause is `package-lock.json` inconsistency (OS diffs or uncommitted updates).
        *   **Action**: If CI alone fails, before spending time investigating, first execute `rm -rf package-lock.json node_modules && npm install` to regenerate the Lockfile and push. Complete synchronization of the dependency tree is the only means to eradicate environment difference bugs.
    *   **The Connection Verification Protocol (Env Awareness)**:
        *   **Problem**: When errors like "Connection Refused" occur, developers often suspect Docker failure before checking environment variable connection destinations.
        *   **Action**: When database connection errors occur, before suggesting solutions, you are obligated to strictly check `NEXT_PUBLIC_SUPABASE_URL` in `.env.local` and identify **"Where are we trying to connect? (Target)"**. Guesswork-based instructions are prohibited.
    *   **The Dependency Override Protocol**:
        *   **Law**: `legacy-peer-deps=true` is an abandonment of the rule of law that disables all dependency checks, and is unconstitutional.
        *   **Action**: If compatibility errors occur (e.g., React 19), use the `overrides` field in `package.json` to explicitly define "which library" is treated as "which version". Place dependency exceptions under code (`package.json`) governance.

### 10.2. The IPv6 Deployment Protocol (Rule 38.7)
*   **Law**: In CI environments like GitHub Actions, failing to connect to Supabase (PostgreSQL) due to IPv6 name resolution issues (Connection Refused) MUST NOT be solved by changing application code.
*   **Action**:
    1.  **Connection Pooler**: Always use `supabase link` and establish connection via Connection Pooler (IPv4).
    2.  **DNS Bypass**: Prioritize "infrastructure level resolution" such as hardcoding DB host and IP in runner `/etc/hosts` or directly specifying `SUPABASE_DB_URL` if necessary.

### 10.3. The Branch Hygiene Mandate (Garbage Collection)
*   **Law**: Leaving work branches is the biggest cause of accidents (conflicts, friendly fire) due to environmental differences. "Delete upon merge" is the engineer's breath.
*   **Action**:
    *   **Before Final Notify**: Immediately before the task completion report (Final Notify), ALWAYS check `git branch --merged` and automatically delete merged work branches.
    *   **Local Cleanup**: Remote branches are auto-deleted by GitHub, but do not leave corpses locally. "Leaving it created" is a shameful act for an engineer.

### 10.4. The Migration Immutability Protocol (History Protection)
*   **Law**: Using column names scheduled for future implementation (Blueprint) in actual code (Queries) before DB migration is complete is prohibited as it drives the page to crash.
*   **Action**:
    *   **Trust**: Limit columns used in queries to those "currently, certainly existing".
    *   **Fallback**: Do not fetch un-implemented feature data from DB; complement with constants (Default Config) in application layer.

### 10.5. The Version Alignment Protocol (Zod/RHF)
*   **Law**: Version mismatches between `zod`, `react-hook-form`, and `@hookform/resolvers` cause "runtime validation failure" and "incomprehensible type errors" hard to detect by static analysis.
*   **Action**: When introducing/updating form libraries, always confirm compatible versions within these three ecosystems and update en masse.
*   **No "as any"**: Silencing type errors due to version mismatch with `as any` is prohibited. Solve the root cause (version divergence).

### 10.6. The Zod Nullable DB Alignment Protocol (DB NULL Correspondence Mandate)
*   **Law**: Zod schemas corresponding to DB columns that allow `NULL` MUST use **`.nullable()`** (allows `null`) instead of `.optional()` (allows `undefined`).
*   **Action**:
    1.  **Schema Parity**: When a DB column has `DEFAULT NULL` or lacks a `NOT NULL` constraint, the corresponding Zod field MUST use `.nullable()` such as `z.string().nullable()`. `.optional()` permits `undefined`, which has a different semantic meaning from DB `NULL`.
    2.  **Transform Awareness**: When a value retrieved from the DB is `null` but needs to be handled as `undefined` on the UI side, use `.nullable().transform(v => v ?? undefined)` for explicit conversion. MUST NOT rely on implicit conversion.
    3.  **Migration Sync**: When adding or removing `NOT NULL` constraints via DB migrations, the corresponding Zod schema's `.nullable()` / `.required()` MUST be **updated simultaneously**. Mismatch is a direct cause of runtime validation errors.
*   **Rationale**: `null` (value does not exist) and `undefined` (value has not been set) are distinct concepts in JavaScript/TypeScript. When the DB returns `NULL` but the Zod schema is defined with `.optional()`, validation passes but the type becomes inaccurate, causing unexpected behavior.

## 11. Documentation Ops
*   **Living Documentation**:
    *   **Mermaid.js**: Architecture diagrams must be code (Mermaid), not images, to prevent obsolescence.
    *   **ADR**: Technical decisions are recorded in Markdown at `docs/adr`.
*   **Docs as Code**:
    *   Documentation is equal to code; managed in Git and subject to PR review. No code merge without doc updates.
*   **Freshness**:
    *   Automate link rot checks. Review key rules quarterly.
*   **The README Standard Protocol**:
    *   **Law**: The project's README.md MUST include the following sections to ensure new team members can set up their development environment and submit a PR on their first day.
    *   **Required Sections**:
        | Section | Content |
        |:--------|:--------|
        | **Overview** | Project purpose (1-2 sentences) |
        | **Tech Stack** | Major frameworks and libraries |
        | **Local Development** | `npm install` → `npm run dev` steps |
        | **Environment Variables** | All variables in `.env.example` with descriptions |
        | **Directory Structure** | Role of major directories |
        | **Deployment** | Flow from local to production deployment |
    *   **Update Obligation**: Include documentation updates in PR checklists when adding features or changing architecture. "The code speaks for itself" is prohibited.

## 12. Engineering Quality Protocols

### 12.1. The Zero-Warning Lint Protocol
*   **Law**: "It works with warnings" is a compromise that leads to quality decay. CI All Green means Zero Warnings.
*   **Action**: `npm run lint` must return **Zero Warnings**. Delete unused variables immediately.

### 12.2. The Clean Import Protocol
*   **Law**: `import` statements must be at the **Top-Level** of the file.
*   **Action**: Imports inside functions or control flows are strictly prohibited. Move them to the top immediately.

### 12.3. The Explicit Explanation Protocol (Zero Jargon)
*   **Law**: Developer "common sense" is user "jargon".
*   **Action**: Always attach a `Tooltip` to technical terms and metrics on the admin panel, explaining "what it is and how it affects business" in layperson terms.

### 12.4. Localization First Protocol
*   **Law**: English error messages cause user churn.
*   **Action**: Localize all error messages and validation messages (including Zod custom errors) into the **Project Native Language** defined in `GEMINI.md`.

### 12.5. The Recursive Logic Ban (Infinite Recursion Shield)
*   **Law**: Deep recursion with unclear termination in component trees or business logic is prohibited.
*   **Reason**: Causes Stack Overflow and infinite DB reads (when combined with useEffect), leading to cloud bankruptcy.
*   **Action**: Always define a **MAX_DEPTH** constant (e.g., 5) for recursive structures. Throw exception or normalize data if exceeded.

### 12.6. The Atomic Commits Protocol
*   **Law**: Each commit MUST contain only **one logical change**. Mixing formatting fixes with feature additions is prohibited.
*   **Revertability**: Maintain granularity where reverting "just that commit" fixes a bug.
*   **Prohibition**: Pushing WIP (Work In Progress) commits to production branches is prohibited. Organize commits via Squash before merge.

### 12.7. The Conventional Commits Standard
*   **Law**: Commit messages MUST follow the `type(scope): subject` format. This is mandatory for improving accuracy of AI/tool history analysis and automated Changelog generation.
*   **Types**:
    | Type | Purpose |
    |:-----|:--------|
    | `feat` | New feature |
    | `fix` | Bug fix |
    | `refactor` | Refactoring (no feature change) |
    | `perf` | Performance improvement |
    | `docs` | Documentation change |
    | `style` | Code style change (formatting etc.) |
    | `test` | Test addition/modification |
    | `chore` | Build/CI configuration change |
    | `security` | Security fix |
*   **Breaking Change**: For breaking changes, use `feat!:` or include `BREAKING CHANGE:` in the footer.

### 12.8. The Code Review Protocol
*   **Law**: Code review is the last line of defense for quality, and an opportunity for preventing knowledge silos and sharing expertise.
*   **PR Size**: Target **400 lines or fewer** of changes. Split PRs when exceeding.
*   **Review Perspective Checklist**:
    | Perspective | Check Content |
    |:-----------|:-------------|
    | **Type Safety** | No `as any` usage, proper type definitions |
    | **Security** | No PII exposure, access control verified |
    | **Performance** | No N+1 queries, no unnecessary re-renders |
    | **FinOps (Cost Impact)** | No infinite loop DB reads, appropriate cache strategy, no AI token waste |
    | **Internationalization / Localization** | UI text written in the operator's native language |
    | **Accessibility** | Keyboard operable, appropriate `aria-label` |
*   **Self-Review**: PR authors MUST self-check against the above checklist and fill in the PR template before submission.

### 12.9. The CODEOWNERS Protocol
*   **Law**: As the codebase grows, clarify the responsible person for each area. Auto-assignment of appropriate reviewers balances quality and speed.
*   **Action**:
    1.  Define owners per directory in the `.github/CODEOWNERS` file.
    2.  Make Approve from designated CODEOWNERS a merge requirement (enforce via Branch Protection).
    3.  Immediately update CODEOWNERS when team members are added or leave.
    4.  Explicitly designate owners in PRs when creating new directories.
*   **Rationale**: Code without clear owners receives no reviews and quality degrades. A sense of ownership ("my area") sustains quality.

### 12.10. The Git Hooks Automation Protocol
*   **Law**: Guarantee quality not through "being careful" (operational rules) but through "mechanisms that make violations physically impossible (Code not Policy)."
*   **Three-Layer Defense**:
    | Layer | Hook | Content | Tool Example |
    |:------|:-----|:--------|:-------------|
    | **Pre-Commit** | `pre-commit` | Auto-run lint/format on staged files | `husky` + `lint-staged` |
    | **Commit-Msg** | `commit-msg` | Verify commit message conforms to Conventional Commits format | `commitlint` |
    | **Pre-Push** | `pre-push` | Physically block direct pushes to protected branches (`main`, `master`) | Branch name check script |
*   **Action**:
    1.  Introduce a Git Hooks management tool during project initialization.
    2.  In the pre-push hook, inspect the current branch and force abort with `exit 1` if it matches a protected branch name.
    3.  Bypassing hooks via `--no-verify` is Zero Tolerance — prohibited.
*   **Rationale**: Server-side Branch Protection alone cannot prevent accidental local pushes. Client-side and server-side Defense in Depth is required.

### 12.11. The Branch Naming Convention
*   **Law**: Branch names MUST follow the `type/summary` format. Mandatory for history readability and automation tool integration.
*   **Types**: `feat/`, `fix/`, `refactor/`, `chore/`, `hotfix/`
*   **Example**: `feat/user-profile`, `fix/login-redirect-loop`, `refactor/dto-cleanup`
*   **Merge Strategy**: PRs should assume **Squash Merge** to keep commit history clean.
*   **Branch Cleanup Protocol**:
    1.  `git checkout main` to leave the working branch.
    2.  `git pull origin main` to update local `main` to latest.
    3.  Delete merged branches immediately. Abandoned branches are "technical debt."
*   **Rationale**: Inconsistent branch names break CI/CD pipelines and automated release note generation, making history tracking difficult.

### 12.12. The SSOT Sync Protocol
*   **Law**: After merging a work branch or leaving a work branch, you MUST synchronize your local `main` branch **100%** with the remote state. Your local `main` must always match the "Single Source of Truth."
*   **Action**:
    1.  **Post-Merge Sync**: Upon completing work, execute the following:
        *   `git checkout main`
        *   `git pull origin main`
        *   Delete merged branches
    2.  **Pre-Task Verification**: Before starting a new task, verify that your local `main` is up-to-date. Creating branches from a stale `main` is the root cause of conflicts and rework.
    3.  **No Stale Development**: Starting development from an outdated `main` branch is prohibited. Verify alignment by comparing `git log --oneline -1 origin/main` with `git log --oneline -1 main`.
*   **Rationale**: Divergence between local and remote is the primary cause of merge conflicts, redundant bug fixes, and unexpected behavior due to environment differences. Institutionalizing "sync forgetting" as a "process defect" structurally prevents this class of incidents.

## 13. Advanced Architectural Mandates

### 13.1. The Trinity DTO Mandate (Constitutional Pillar)
*   **Law**: Any implementation violating these 3 points is unconstitutional and subject to immediate deletion:
    1.  **Security (PII Defense)**: Output of Raw Rows is prohibited. Must pass through **DTO (White-list)** to physically block sensitive info.
    2.  **Stability (Frontend Shield)**: Do not link DB Schema directly to UI. Build a Mapper function barrier to absorb changes within server.
    3.  **AI Economy (Token Optimization)**: Do not feed waste to AI. Use **AI-Optimized DTO** to save tokens and improve inference accuracy.
*   **Detailed Action**:
    *   **Strict Segregation**: DTOs containing sensitive fields (Admin memos, PII) must be physically separated at type level (e.g., `AdminDTO`, `PublicDTO`).
    *   **No Raw Return**: Server Actions/API must not return raw `Database['public']['Tables']` types. Always return explicitly defined DTOs.
    *   **No Blind Spread**: Spread syntax like `...user` is **strictly prohibited** in DTO conversion layers as it leaks future sensitive columns. Explicitly list fields.
    *   **The UI-DTO Binding Protocol**: Shared UI components (Cards, Widgets) must depend on **Abstract DTO Interfaces**, not concrete DB types, enabling Omnichannel reuse.

### 13.2. The Client DB Access Prohibition (Architecture Law)
*   **Law**: Calling `supabase.from()` directly from Client Components is prohibited to prevent RLS leaks and raw data exposure.
*   **Action**:
    *   **Gateway First**: Data fetch/update must go through `Server Actions` or `Route Handler` (API).
    *   **Secure Write Action Protocol**: Public write actions (Auth, Inquiry) must accept `turnstileToken` and verify on server. Reject invalid requests before DB access.

### 13.3. The Service Pattern Mandate
*   **Law**: Do not call DB access functions directly in `page.tsx` or `layout.tsx`.
*   **Action**: Extract logic to `lib/api/gateways/` (Read) or `lib/actions/` (Write). UI should only "call Gateway and display".

### 13.4. The VIP Lane Strategy (Native Bypass Protocol)
*   **Context**: Native Apps cannot safely hold API Keys.
*   **Law (Dual Auth)**:
    1.  **Common Endpoint**: Share endpoints for Public and First Party.
    2.  **Dual Auth**: Middleware checks OR condition of "API Key" and "Bearer Token".
    3.  **Mechanism**: If `Authorization: Bearer` exists (User Session), grant privileged Tier unconditionally (Trust Base).

### 13.5. The Centralized Logging Protocol
*   **Law**: Leaving `console.log` in production is hygiene failure.
*   **Action**: Use `src/lib/logger.ts` only. Prohibit `console.*` via Linter.

### 13.6. The Pragmatic Casting Protocol (Type Survival)
*   **Law**: `as any` is prohibited, but intentional **Bridge Casting** for non-existent schema (Phantom Tables) is allowed temporarily.
*   **Action**: Use `src/types/database-extensions.ts` to define local extensions.

### 13.7. The Unstable Timer Protocol
*   **Law**: `setTimeout`/`setInterval` are prohibited for logic control due to instability in Serverless/Edge. Use Job Queues.

### 13.8. The Type Bridge Mandate
*   **Law**: Never use `as any` for missing DB types.
*   **Action**: Define **Mapped Type** extensions in `database-extensions.ts` and pass to Supabase Client generics.

### 13.9. The API Product Mindset
*   **Law**: All data output is a "Product".
*   **Action**:
    *   **Tiering**: Separate **Tier 1 (Public)** and **Tier 2 (Enterprise)**.
    *   **Usage Recording**: Fire-and-forget `recordApiUsage` on Enterprise endpoints.
    *   **Metadata**: Include `meta` (AI metadata, Tier, TTL) in response.
    *   **Metadata Segregation**: Prefix internal metadata with `app_` to avoid collision with Stripe `metadata`.
    *   **The API Latency Budget (Rule 26.5)**:
        *   **Law (Speed First)**: The design goal for TTI (Time to Interaction) of all Public/Enterprise APIs is **under 200ms**.
        *   **Action**: Processing exceeding 200ms (heavy aggregation, external API integration) MUST NOT be done synchronously; offload to Webhook or Async Queue, and immediately return `202 Accepted` with `request_id`.

### 13.10. The Tenant-Aware Naming Protocol
*   **Law**: Distinguish resource names for SaaS.
*   **Action**: Use `site_` or `account_` prefix for tenant resources. Use `system_` only for immutable platform settings.

### 13.11. The Legal Hardcoding Ban
*   **Law**: Hardcoding ToS/Privacy Policy text is prohibited.
*   **Action**: Store in DB `site_settings` to allow non-engineer updates.

### 13.12. The Audit Bypass Anti-Pattern
*   **Law**: Client-side DB writes bypass Server-side Audit Logs.
*   **Action**: All updates via Admin Panel must go through `Server Actions` that call `recordAuditLog`.

### 13.13. The Async Boundary Protocol
*   **Law**: Importing `async` Server Components directly into `'use client'` components causes Serialization Errors.
*   **Action**: Pass Server Components as `children` prop or use Composition pattern.

### 13.14. The Dead Code Elimination Protocol
*   **Law**: "Just in case" code is Garbage.
*   **Action**: **Physical Deletion** of unused code, dead branches, and ghost features. Trust Git history.

### 13.15. The Select Specification Pattern (Explicit Data Retrieval)
*   **Law**: `SELECT *` or `.select('*')` (i.e., "fetch all columns") is prohibited in ORMs, Query Builders, and direct DB calls.
*   **Reason**:
    1.  **Security**: Risk of unintentionally exposing sensitive columns added in the future (`internal_memo`, `password_hash`, etc.) to the client.
    2.  **Performance**: Transferring unnecessary columns wastes network bandwidth and memory.
    3.  **AI Economy**: Feeding unnecessary data to AI agents wastes tokens and degrades inference accuracy.
*   **Action**:
    *   **Explicit Select**: Enumerate only necessary columns explicitly (e.g., `.select('id, name, status, created_at')`).
    *   **Purpose-Driven Spec**: Define Select specs per use case (list view, detail view, admin view) to retrieve data without excess or deficiency.
    *   **Registry**: For larger projects, centrally manage Select specs as constants (Select Spec Registry) to prevent scattering and duplication.

### 13.16. The Type Lying Prohibition Protocol
*   **Law**: Deceiving the type system is the gravest crime that betrays compiler and reviewer trust. The following are prohibited:
    *   `as any` / `as never`: Suppressing type errors.
    *   `@ts-ignore` / `@ts-expect-error` (without reason): Disabling type checking.
    *   `eslint-disable` (without reason): Arbitrarily disabling lint rules.
*   **Exception**: When unavoidable, ALL of the following must be met:
    1.  **Reason**: A one-line comment explaining the root cause of the type mismatch.
    2.  **Ticket**: An associated Issue number (e.g., `// TODO(#456): Fix after library update`).
    3.  **Scope**: Minimize the scope of impact (line-level, not file-level).
*   **Outcome**: "Build passes" and "type-safe" are different things. Feeling secure with only the former is self-destructive.

### 13.17. The No Future-Use Code Protocol (YAGNI Strict)
*   **Law**: "Might use in the future" code, variables, imports, and functions are "noise" if not currently in use and are subject to immediate deletion.
*   **Action**:
    *   **Unused Imports**: Not a single unused import shall remain. Enforce Linter (`no-unused-vars`) at `error` level.
    *   **Unused Variables**: `_` prefix is permitted ONLY to indicate "intentionally unused" (e.g., `const [_, setCount] = useState(0)`). All other unused variables must be physically deleted.
    *   **Speculative Code**: Pre-emptive implementation not included in the current user story is technical debt. Write it when you need it.

### 13.18. The Service Layer Extraction Mandate
*   **Law**: Entry points such as Route Handlers, Server Actions, and Controllers MUST remain "thin interfaces." Writing business logic (validation, DB operations, external API calls, calculations) directly in entry points is prohibited.
*   **Action**:
    1.  **Service Layer**: Extract business logic to `lib/services/` or `lib/api/` to make it testable and reusable.
    2.  **DTO Boundary**: Define Service layer input/output with DTOs (Data Transfer Objects) for type safety. Do not leak DB types or framework-specific types to the UI.
    3.  **Single Responsibility**: One Service function has one responsibility. Functions that "fetch, transform, save, and notify" must be split.
*   **Reason**: Tight coupling of logic to entry points leads to a triple affliction: untestable, unreusable, and Omnichannel-incompatible.

### 13.19. The Clean Workspace Mandate
*   **Law**: Upon task completion, temporary files created for verification (`test-*.ts`, `*.log`, `debug-*.ts`) and build caches (`*.tsbuildinfo`) MUST be **immediately discarded** ("Use and Dispose").
*   **Action**:
    *   **Scorched Earth**: Empty directories (`snapshots/`, `snippets/`), leftover backup files, and JSON dumps used only during development are "relics of the past" — committing them to the repository is prohibited.
    *   **Build Artifact**: Build caches like `.tsbuildinfo`, `.next/cache` MUST be managed in `.gitignore` and never included in the repository.
    *   **Verification**: Before committing, verify with `git status` that no unintended files are included.
*   **Rationale**: Leaving unnecessary files degrades the codebase's S/N ratio (Signal to Noise ratio), misleading subsequent developers and AI agents.

### 13.20. The CQRS Pattern (Command Query Responsibility Segregation)
*   **Law**: Mixing Read and Write operations in the same Service/Repository becomes a barrier to future scaling (Read Replicas, Cache Optimization).
*   **Action**:
    1.  **Read Layer (Query)**: Establish a dedicated data retrieval layer requiring Select Spec (explicit column specification) and cache strategy as mandatory parameters. Provide filtering, sorting, and pagination in this layer.
    2.  **Write Layer (Command)**: Establish a dedicated data mutation layer, recommending audit log integration for all operations. Design Soft Delete support as an option.
    3.  **Cache Invalidation**: Introduce a mechanism (tag-based, etc.) to automatically invalidate related Read caches upon Write operation completion.
*   **Benefit**: Separating Read/Write responsibilities enables independent optimization, scaling, and testing.

### 13.21. The DTO Synchronicity Protocol
*   **Law**: When Backend (Server Action/API) return values are DTO-ized, the Frontend (UI Component/Form) Props types receiving them MUST **always be synchronized to the same DTO**.
*   **Action**:
    1.  **Single Source**: Centralize DTO definitions in `lib/dto/` or equivalent, and import from both Backend and Frontend.
    2.  **No Drift**: When Backend DTOs change, all Frontend component Props types referencing them MUST be updated simultaneously. One-sided updates are a direct cause of `undefined` reference runtime errors.
    3.  **Type Guard**: At DTO boundaries, always perform type guards (`in` operator, `typeof` checks) to guarantee external data safety.
*   **Anti-Pattern**: Receiving a DTO from Backend but casting it with `as any` on the Frontend completely nullifies the DTO's purpose — a "Type Betrayal."

### 13.22. The Omnichannel Delivery Mandate
*   **Law**: Writing business logic or data access directly in UI components (`page.tsx`, `layout.tsx`, etc.) is prohibited. All data retrieval, update, and aggregation logic MUST be extracted to a **Service or Gateway layer** and provided as type-safe interfaces.
*   **Rationale**: Logic tightly coupled to Web UI becomes "Web-only legacy code" that cannot be reused from mobile apps, AI agents, or external APIs. Centralizing logic in Service/Gateway layers guarantees consistent behavior across all channels.
*   **Action**:
    1.  **UI = Thin Controller**: UI components should focus solely on calling Services/Actions and presentation. Direct DB client references are prohibited.
    2.  **Service Aggregation**: "Aggregation logic" that integrates multiple Gateways/Actions to produce data for a single screen MUST be extracted to the Service layer as `get...Data()` methods.
    3.  **DTO Response Only**: Service/Action return values MUST be converted to DTOs. Never return raw DB records to the UI layer.
*   **Anti-Pattern**: Calling `supabase.from('table').select()` directly inside `page.tsx` is a fundamental architectural violation.

### 13.23. The Zero Defect Sovereignty
*   **Law**: Committing code that does not pass type checking (`tsc --noEmit`, etc.) and Linting (`eslint`, `biome`, etc.) with **zero warnings (Exit 0)** is prohibited.
*   **Action**:
    1.  **Local First**: Run type checks and linting locally before committing and confirm zero warnings. Relying on CI for detection causes delays.
    2.  **No Escape Hatches**: `as any`, `@ts-ignore`, `@ts-nocheck` are not "warning suppression" — they are "bug implantation." Their use is prohibited in principle; if used, the rationale MUST be documented in a comment.
    3.  **Zero Tolerance**: "Ignore for now, fix later" is not acceptable. Resolve warnings on the spot.
*   **Rationale**: Leaving type errors and lint warnings unresolved plants time bombs that "build successfully but crash at runtime" when schemas change. Zero defects is the minimum quality bar, not a goal.

### 13.24. The Linter Suppression Prohibition
*   **Law**: Use of linter suppression comments such as `eslint-disable` / `eslint-disable-next-line` / `@ts-ignore` / `biome-ignore` is prohibited in principle.
*   **Exception**: Permitted only for compatibility issues with external libraries where root cause resolution is impossible. Even then:
    1.  Document the specific reason for suppression in a comment.
    2.  Create a corresponding Issue to track future root cause resolution.
*   **Rationale**: Suppression comments merely make problems "invisible" — they push root causes onto the next developer. When warnings appear, resolve the root cause instead of suppressing.
*   **Anti-Pattern**: Silencing "might use in the future" variables with `eslint-disable` is preservation of unnecessary code and is prohibited. Write it when you need it.

### 13.25. The Structured Error Return Protocol
*   **Law**: Backend APIs and server actions MUST return **structured responses in `{ success: boolean; data?: T; error?: string }` format** rather than throwing exceptions (`throw`) as a general principle.
*   **Action**:
    1.  **No Raw Throw**: Do not use `throw new Error()` for "expected errors" such as validation failures or insufficient permissions. `throw` causes frontend state management hooks (`useActionState`, etc.) to process them as "unexpected exceptions," leading to runaway component cleanup or retry logic.
    2.  **Graceful Failure Contract**: On error, return `{ success: false, error: 'human-readable message' }` and display it as a toast or inline message on the frontend.
    3.  **Server-Client Symmetry**: When strengthening server-side guards (adding auth checks, etc.), always simultaneously prepare the frontend's "error reception point." One-sided strengthening risks escalating into system-wide crashes.
*   **Rationale**: Returning "expected errors" via `throw` triggers the frontend framework's exception handling mechanism, causing infinite re-render loops or full page crashes. Structured responses delegate error handling control to frontend developers and guarantee system stability.

### 13.26. The Cache Invalidation Ceremony Protocol
*   **Law**: When modifying core query logic (filter conditions, projection specifications, visibility guards, etc.), **physical deletion of build caches and full restart of the development server** is mandatory.
*   **Action**:
    1.  **Full Environment Reset**: After query logic changes, physically delete build cache directories (`.next/`, `dist/`, `.cache/`, etc.) and restart the development server.
    2.  **Kill Process**: Graceful shutdown may be insufficient. Force terminate with `kill -9` etc. and restart from a clean state.
    3.  **Pre-Verification**: Verify the effect of changes only after cache clearing. Cache residue leads to the false conclusion that "code changes are not being reflected."
*   **Rationale**: In applications employing multi-layer caching strategies (memory cache, file cache, CDN cache, etc.), caches may continue serving stale data after code changes. This causes misdiagnosis of "code is correct but doesn't work," wasting enormous time on unnecessary debugging.

### 13.27. The Projection-Schema Parity Mandate
*   **Law**: Projection specifications (Select Specifications, GraphQL fragments, etc.) for data retrieval MUST **match the physical DB schema 100%**. "Phantom Fields" defined in UI or DTOs but not present in the DB are a direct cause of silent runtime crashes.
*   **Action**:
    1.  **Vertical Synchronization Audit**: When adding new fields, verify **DB Schema → DTO → Gateway → UI Interface** across all layers vertically. A state where a field exists in only one layer is not acceptable.
    2.  **Ghost Hunt Protocol**: When a field included in the projection specification triggers a "column does not exist" error, conduct a "recursive ghost audit" comparing not just that field but the entire specification against the physical schema. One mismatch is a signal of systemic drift.
    3.  **No Speculative Fields**: Defining fields in DTOs or UI based on the speculation that they "will probably be needed in the future" while they are unimplemented in the DB is prohibited. Implement when needed.
*   **Rationale**: Projection specification patterns (Select Specifications, etc.) are powerful for PII leak prevention and API billing control, but inherently carry "coupling risk" with the schema. Accessing fields not returned from the DB becomes an invisible bug that crashes the entire frontend.

### 13.28. The Mutation Integrity Verification Protocol
*   **Law**: In data write operations (Create/Update/Delete), **`error: null` does NOT mean success**. Always verify affected row count (`count` / `affectedRows`), and explicitly throw an error when the count is 0.
*   **Action**:
    1.  **Count Validation**: For single-record operations with ID specification (`WHERE id = ?`), always verify that the affected row count is `1` (or the expected value). If `0`, throw an explicit error as a signal of "insufficient permissions" or "record not found."
    2.  **Sub-Step Integrity**: When performing multiple write operations within a single transactional process (main table update → relation update → tag update, etc.), verify each step's error object individually. Prevent "Partial Phantom Success" where intermediate steps fail but the final result returns "success."
    3.  **Post-Mutation Verification Fetch**: For particularly critical updates (image reordering, status changes, etc.), perform an immediate re-fetch (`SELECT`) with the same ID after updating, and log or assert the current value. This enables 100% differentiation between "DB write failure" and "UI display failure (cache)."
*   **Rationale**: Many DB clients/ORMs (especially RLS-enabled ones) return a "successful response affecting 0 rows" without throwing errors when access is denied due to insufficient permissions. This "silent rejection" displays false success messages in the UI and makes data inconsistencies undetectable.

### 13.29. The Service Aggregation Protocol
*   **Law**: "Aggregation logic" that calls multiple Gateways/Repositories/Actions to assemble data for a single screen (page) MUST be **extracted into a Service layer**. The UI layer (page components, controllers) MUST remain a thin entry point that only calls the Service.
*   **Action**:
    1.  **Single Responsibility**: If a single page fetches from 5 or more data sources, that is a signal that "the page is doing Service layer work." Aggregate into `XxxService.getPageData()`.
    2.  **Testability**: Compose the Service layer with Pure Functions or injectable dependencies only, without UI/framework dependencies. This enables unit testing.
    3.  **Reusability**: When the same dataset is used from multiple UIs (admin panel, public page, API), share the Service to prevent "different interpretations of the same data."
*   **Rationale**: When data aggregation logic is scattered across the UI layer, multiple access paths to the same data emerge, making unified caching strategies and error handling impossible. The Service layer functions as the "front gate for business logic."

### 13.30. The Production Build Verification Protocol
*   **Law**: A running development server (`dev` mode) is **NOT proof** of code correctness. Until type checking (`tsc --noEmit`) and production build (`npm run build`, etc.) pass, treat the code as "non-existent."
*   **Action**:
    1.  **Mandatory Triple Crown**: Before completing a task, the following 3 checks MUST pass:
        *   ① Type check (`tsc --noEmit`): Zero type errors
        *   ② Linter (`eslint --max-warnings=0`): Zero warnings
        *   ③ Production build (`npm run build`): Build success
    2.  **PR Rejection**: PRs without evidence of passing all 3 checks above MUST be immediately rejected.
    3.  **Dev Mode Trap**: In `dev` mode, Hot Module Replacement (HMR) and lazy runtime error evaluation conceal errors that would surface in production. `import` resolution, Tree Shaking, and SSR path execution are fully verified only in `build`.
*   **Rationale**: The development server is a "too-forgiving" environment. Production build is the only mechanism that surfaces errors silent in dev mode, such as dead import detection, SSR path crashes, and dynamic route type mismatches.

### 13.31. The CI/CD Environment Gap Protocol
*   **Law**: CI environments run tests against an "empty database (Clean Room)" and therefore **cannot detect collisions with existing data** (unique constraint violations, foreign key inconsistencies, missing NOT NULL defaults, etc.). Changes involving data manipulation MUST be written with defensive code that anticipates collisions with production data.
*   **Action**:
    1.  **Defensive DML**: Use `ON CONFLICT ... DO UPDATE` or `DO NOTHING` in `INSERT` statements to ensure idempotency.
    2.  **Pre-Check**: When adding `NOT NULL` constraints via `ALTER TABLE`, pre-fill existing `NULL` values with `UPDATE` to set defaults.
    3.  **Staging Verification**: Whenever possible, pre-verify data changes on a staging environment with production-like data.
*   **Rationale**: CI's "all green" is merely "success in a sterile room." When you forget the complexity of production (existing data, concurrent access, historical maintenance debt), deployment incidents will inevitably occur.

### 13.32. The Clean Workspace Mandate
*   **Law**: Upon task completion, all temporary files, build caches, empty directories, and debug `console.log` statements generated during work MUST be **removed** before committing. Repositories maintain a clean state following the "Scorched Earth" principle.
*   **Action**:
    1.  **Checklist**: Verify the following before committing:
        *   No temporary files (`.tmp`, `.bak`, `*.log`, etc.) remain
        *   No empty directories (folders with 0 files) remain
        *   No `console.log` / `console.debug` remains in code
        *   Build caches (`.next/cache`, etc.) are not included in Git tracking
    2.  **Gitignore Hygiene**: Verify that `.gitignore` comprehensively covers build outputs, environment files, and IDE settings at initialization.
    3.  **Branch Hygiene**: Promptly delete merged branches. Abandoned branches are breeding grounds for "incidents caused by environment differences."
*   **Rationale**: Leftover temporary files and debug code impose unnecessary cognitive load on the next developer (including your future self) — "Was this code intentionally left?" A clean repository directly impacts the entire team's productivity.

### 13.33. The Dead Code Prohibition Protocol
*   **Law**: Keeping code "just in case it's needed later" is the biggest source of technical debt. **Immediate deletion of all currently unused code (unused variables, imports, functions, type definitions) is mandatory.**
*   **Action**:
    1.  **No Future-Use Code**: Code not used by current features must not be kept, including commented-out code. Restore from Git history when needed.
    2.  **Strict Variable Hygiene**: Variables, constants, and imports that are declared but never referenced must be removed before building. The `_` prefix is only permitted for explicit value discarding in destructuring (e.g., `const [_, setValue] = useState()`).
    3.  **Lint Enforcement**: Set ESLint's `no-unused-vars` / `@typescript-eslint/no-unused-vars` to `error` and physically block in CI.
*   **Rationale**: Unused code is a "broken window." If one is tolerated, the entire team judges "a little is fine," and the overall codebase quality deteriorates.

### 13.34. The Warning Suppression Prohibition Protocol
*   **Law**: The casual use of directives that **suppress or ignore linter and type checker warnings** is prohibited in principle. Warnings are "code smells that need fixing" — fix the root cause instead of silencing them.
*   **Action**:
    1.  **ESLint**: `eslint-disable` and `eslint-disable-next-line` usage is prohibited in principle. When unavoidable, a **comment explaining the reason** must be added (e.g., `// eslint-disable-next-line -- library type definition is inaccurate`).
    2.  **TypeScript**: `@ts-ignore`, `@ts-nocheck`, and `@ts-expect-error` usage is prohibited in principle. Resolve type errors by fixing type definitions.
    3.  **Other Tools**: For Stylelint, Prettier, and similar tools, suppression directives are only acceptable as a last resort after root cause resolution.
    4.  **CI Enforcement**: Introducing lint rules that detect new suppression directive additions (e.g., `eslint-comments/no-unlimited-disable`) is recommended.
*   **Rationale**: Warning suppression only "makes problems invisible" without solving them. As suppression comments proliferate, codebase reliability degrades, and truly important warnings get buried.

### 13.35. The Type Integrity Mandate
*   **Law**: Bypassing TypeScript's type system is defined as "embedding bugs." **`as any` type casts are prohibited in principle**, and type accuracy is the highest priority.
*   **Action**:
    1.  **No `as any`**: `as any` completely disables the type checker and is prohibited. When external library types are inaccurate, provide accurate type definitions via `declare module`.
    2.  **Strict Action Return Types**: Server Actions, API handlers, and Service functions must always have explicit return type definitions. Using `any` or `unknown` as return types is prohibited.
    3.  **No Type Assertion Chains**: Multi-step casts like `(value as unknown as TargetType)` are an anti-pattern indicating type safety destruction. Create data transformation functions and perform type conversions with runtime validation.
    4.  **Lint Enforcement**: Set `@typescript-eslint/no-explicit-any` to `error`.
*   **Rationale**: `as any` is a "lie to the type checker." While problems become invisible at compile time, unexpected types circulate at runtime, causing bugs that are extremely difficult to debug.

### 13.36. The UI-Layer Data Access Prohibition
*   **Law**: **Direct access to databases or external APIs from UI components** (page components, layout components, client components) is prohibited. All data access must go through the Service or Gateway layer.
*   **Action**:
    1.  **Service Layer Mandate**: Data retrieval and modification must always go through dedicated Service / Gateway / Action functions. The UI layer handles only the return values (DTOs) of these functions.
    2.  **No DB Client in UI**: Directly importing and using DB clients (ORM, SDK, etc.) in UI files is prohibited.
    3.  **DTO Boundary**: The Service layer must not return DB record structures as-is, but transform them into **DTOs (Data Transfer Objects)** containing only the data the UI requires.
    4.  **Omnichannel Readiness**: This separation enables reuse of the same Service layer across multiple clients — Web, native apps, external APIs, etc.
*   **Rationale**: Direct coupling between UI and data layers destroys testability and makes omnichannel deployment impossible. Inserting a Service layer achieves business logic aggregation, ease of testing, and client-agnostic architecture.

### 13.37. The Graceful Failure Contract
*   **Law**: Server-side processes (Server Actions, API handlers, etc.) are **prohibited in principle from using `throw new Error()`** for business logic failures. Instead, they must return **structured error responses** (e.g., `{ success: false, error: '...' }`) to be properly handled by the client side.
*   **Action**:
    1.  **No Raw Throw**: When Server Actions `throw`, client-side UI frameworks (React's `useActionState`, etc.) may process the error as an "unexpected exception," causing component cleanup or retry logic to run amok, potentially triggering infinite loops. Business errors (insufficient permissions, validation failures, etc.) must always be returned as structured responses.
    2.  **Common Response Type**: Define a common response type for all server actions (e.g., `ActionResult<T> = { success: true, data: T } | { success: false, error: string }`) so that clients can handle errors uniformly.
    3.  **Client-Side Feedback**: On the client side, display `success: false` cases as toast notifications or inline error messages to provide appropriate feedback to the user.
    4.  **Exception**: The use of `throw` is permitted only for fatal errors where program continuation is impossible (DB connection loss, missing environment configuration, etc.).
*   **Rationale**: Server-side security hardening (adding guards, etc.) and client-side error handling must be developed as a "pair." Hardening only the server without preparing the client's "error reception point" risks escalating a normal "insufficient permissions error" into a system-wide "infinite loop crash."

### 13.38. The Mutation Count Validation
*   **Law**: After database write operations (UPDATE / DELETE), **the number of affected rows (`count`) must always be verified**. Even when `error: null` (no error), `count: 0` may indicate a "silent rejection."
*   **Action**:
    1.  **Count Check**: For single-record update/delete operations specifying an ID, always retrieve `count` from the response and verify it equals the expected number of rows (typically `1`).
    2.  **Explicit Failure**: If `count` is `0` or `null`, throw an explicit error (e.g., `throw new Error('Update failed: No rows affected.')`) to prevent the UI from displaying a false success state.
    3.  **Instrumentation**: During debugging, log the mutation result's `count` to visualize write effectiveness.
    4.  **RLS Awareness**: In databases using Row Level Security (RLS), always keep in mind that insufficient permissions are returned as "0 rows affected" rather than as an error.
*   **Rationale**: Many database APIs (especially HTTP wrappers like PostgREST) do not report write failures due to insufficient permissions as errors. Implementations that only verify `error: null` cause the most difficult-to-diagnose "Phantom Success" — appearing to succeed while data is not actually persisted.

### 13.39. The Post-Mutation Verification Fetch
*   **Law**: For particularly critical mutations (image reordering, status changes, permission changes, etc.), it is recommended to **re-fetch the same record (SELECT)** immediately after the write operation and confirm via logs or assertions that the intended values have been persisted in the database.
*   **Action**:
    1.  **Verification Fetch**: Execute a `select()` with the same ID immediately after `update()` and log the current values. This enables 100% reliable isolation of whether the problem is "a write failure to the DB" or "a read/cache issue in the application."
    2.  **Diagnostic Isolation**: When data reverting after reload is reported, first use this pattern to verify the physical server-side values and identify the problem layer (DB / Cache / UI).
    3.  **Production Guard**: In production environments, consider the performance impact and enable this verification via a flag (`DEBUG_MUTATIONS=true`) or control it through log levels.
*   **Rationale**: There are many cases where data is not reflected even though the write operation itself succeeded — cache inconsistencies (framework Data Cache / Router Cache, etc.), value overwrites by triggers, etc. The immediate verification fetch is the most reliable debugging technique for swiftly identifying silent persistence failures.

### 13.40. The Read-Write Privilege Symmetry
*   **Law**: When a privileged client (admin permissions, etc.) is used for data writes (Mutations), **the "read for editing" must also guarantee equivalent visibility**. Mismatch between write and read permissions causes a "single-lung state."
*   **Action**:
    1.  **Read-Write Parity**: In admin panels and similar contexts, if writes are performed with a privileged client (RLS bypass, etc.), data retrieval for edit forms must also be performed at an equivalent permission level. Permission mismatch causes an extremely opaque bug where "saving succeeds but data reverts after reload."
    2.  **Spec Synchronization**: Verify that the projection used for data retrieval (Select Spec / column specification) encompasses all columns that are write targets. If the retrieval spec is missing columns, items will be saved but not displayed.
    3.  **Gateway Awareness**: Data retrieval functions for administrative purposes should explicitly indicate their purpose in the function name (e.g., `getAdminItemById`) and use an appropriately privileged client.
*   **Rationale**: Using different permission levels for writes and reads may not be a security "hole," but it causes data "invisibility." Especially in environments using RLS, if SELECT policies are incomplete, data existing in the DB is filtered out during retrieval and not displayed in the UI — creating a diagnostically challenging bug.

### 13.41. The Sub-Step Mutation Integrity Protocol
*   **Law**: When performing **multiple asynchronous write operations** within a single service method or transaction (INSERT/UPDATE to multiple tables, sequential calls to external APIs, etc.), **each step's result must be individually verified**.
*   **Action**:
    1.  **Per-Step Error Check**: Verify `error` / `count` / `status` immediately after each write operation. Executing subsequent steps assuming the first step succeeded while swallowing intermediate errors is the direct cause of "Partial Phantom Success."
    2.  **Fail-Fast Cascade**: If an error is detected at any step, return the error immediately without executing subsequent steps. Leaving partially updated state is a breeding ground for data inconsistency.
    3.  **Composite Error Reporting**: Aggregate results from multiple steps and construct an error response that clearly communicates to the caller which step failed (e.g., `{ step: 'update_metadata', error: '...' }`).
    4.  **Diagnostic Logging**: Log the execution result of each step (number of affected rows, impacted columns, etc.) to accelerate root cause identification during incidents.
*   **Rationale**: In multi-step write processes, ignoring errors at intermediate steps causes inconsistencies such as "main data was updated but related data remains stale." This type of partial success is extremely difficult to discover because the user sees "save successful."

### 13.42. The Structured Error Logging Mandate
*   **Law**: When logging error objects, **direct embedding in string templates** (e.g., `` `Error: ${error}` ``) is prohibited. Error objects must be logged in a **structured format**.
*   **Action**:
    1.  **No Template Embedding**: The pattern `` `Error occurred: ${error}` `` outputs `[object Object]`, completely losing root cause information.
    2.  **Destructured Logging**: Explicitly deconstruct error object properties (`message`, `code`, `details`, `hint`, etc.) for logging (e.g., `Logger.error('Operation failed', { message: error.message, code: error.code, details: error.details })`).
    3.  **JSON Serialization**: When using structured logging systems, serialize the entire error object with `JSON.stringify(error, null, 2)` to preserve all properties.
    4.  **Stack Trace Preservation**: The `stack` property of `Error` instances is lost when included in template literals. Always pass it as a second argument or metadata object.
*   **Rationale**: Errors logged as `[object Object]` make root cause identification virtually impossible. RLS violations, authentication errors, type mismatches, and similar subtle errors contain critical diagnostic information in `code` and `details` — template embedding loses all of this.

### 13.43. The Type Integrity Prohibition Protocol
*   **Law**: Using `as any` or `as never` to silence type errors is defined as "embedding bugs." Making types correctly align is the **only legitimate solution** — circumvention via casting is completely prohibited.
*   **Action**:
    1.  **Zero `as any` Policy**: Prohibit `as any` usage across the entire codebase. Set ESLint rule `@typescript-eslint/no-explicit-any` to `error` and physically block it in CI.
    2.  **Root Cause Resolution**: When type errors occur, resolve the **root cause** through "fixing type definitions," "redesigning DTOs," or "applying generics" — not through casting.
    3.  **Exceptional Cast Documentation**: When type assertions are unavoidable (e.g., external library type definition deficiencies), always add a `// SAFETY: <reason>` comment and require code review approval.
    4.  **Lint Suppression Audit**: Using `// eslint-disable` or `// @ts-ignore` is a "declaration of technical debt." Always note the corresponding Issue number when used, and mandate quarterly inventory reviews.
*   **Rationale**: `as any` completely disables type safety, deferring bugs that should be caught at compile time to runtime. Especially at DTO conversions and API boundaries, its use conceals data inconsistencies and makes root cause identification during incidents extremely difficult.

### 13.44. The Thin Controller Mandate
*   **Law**: API Routes / Controllers / Route Handlers must be designed as a "thin layer" responsible only for request parsing/validation and authorization checks. Business logic must be delegated to the Service layer — direct implementation in Controllers is prohibited.
*   **Action**:
    1.  **Controller Responsibilities**: Code within Controllers is limited to: (a) parsing and validating request body/parameters, (b) authentication/authorization checks, (c) calling Service layer, (d) constructing and returning responses.
    2.  **No DB Access in Controllers**: Direct DB calls (ORM queries, SQL execution, etc.) within Controllers / Route Handlers are prohibited. All data access must go through the Service/Gateway layer.
    3.  **Testability**: The Service layer must be independently unit-testable from Controllers. Logic tightly coupled to Controllers destroys testability.
    4.  **Error Translation**: Exceptions from the Service layer must be translated to HTTP status codes and error response formats at the Controller layer. The Service layer must not know about HTTP status codes.
*   **Rationale**: Bloated Controllers create a triple burden: untestable, non-reusable, and impossible to assess change impact. The separation of thin Controllers + thick Services is the foundation of maintainability and scalability.

### 13.45. The DTO Boundary Casting Protocol
*   **Law**: When converting database or ORM return values (loose types) to strict DTO types, casting via `as any` is prohibited. A safe type conversion strategy is mandated.
*   **Action**:
    1.  **No `as any` Bridge**: Double casting like `dbResult as any as MyDTO` is a complete abandonment of type safety. It is prohibited.
    2.  **Explicit Mapping**: Conversion from DB results to DTOs must use explicit mapping functions (`toDTO(dbResult): MyDTO`) that individually map each field.
    3.  **Validated Cast**: When type assertions are unavoidable, use intentional two-stage conversion via `as unknown as TargetType` to make the conversion intent explicit. However, combining with runtime validation (Zod, etc.) is strongly recommended.
    4.  **Generated Types**: DB type definitions must use auto-generation (Prisma, Drizzle, Supabase CLI, etc.) to physically prevent divergence from hand-written type definitions.
*   **Rationale**: The type boundary between DB and application layers is where data inconsistencies most frequently occur. Casting via `as any` causes silent data loss during column additions/renames, producing the worst kind of bugs — where builds pass but data is corrupted.

### 13.46. The CQRS Separation Mandate
*   **Law**: Mixing Read operations (queries) and Write operations (mutations) in the same function or class is prohibited. Query (Read-only) and Command (Write-only) must be clearly separated.
*   **Action**:
    1.  **Query/Command Split**: The data access layer must be separated into read-only `QueryGateway` (or `ReadService`) and write-only `CommandGateway` (or `WriteService`).
    2.  **No Side Effects in Queries**: Query methods must only perform data reading and transformation — they must have zero side effects such as DB writes or external API calls.
    3.  **Independent Scaling**: Read/Write separation enables independent scaling decisions: adding Read Replicas for high read load, or Write optimization for write-heavy scenarios.
    4.  **Naming Convention**: Method names must explicitly indicate Read/Write intent (e.g., `getUser` / `findUsers` for Read, `createUser` / `updateUser` for Write).
*   **Rationale**: Mixing Read/Write makes cache strategy application difficult and delays performance bottleneck identification. CQRS separation improves code readability, testability, and secures migration paths to future event sourcing or microservice architectures.

### 13.47. The Cache Strategy Layer Protocol
*   **Law**: Uniform cache strategies that ignore data characteristics (fixed TTL for everything / completely disabling cache) are prohibited. Define a **layered cache strategy** based on data change frequency and freshness requirements.
*   **Action**:
    1.  **Data Classification**: Classify application data into the following tiers:
        - **STATIC** (No changes): Legal documents, terms of service, etc. CDN/ISR (rebuild-triggered).
        - **WARM** (Daily to weekly changes): Master data, categories, etc. TTL 5min–1hr + SWR (Stale-While-Revalidate).
        - **HOT** (Minute-level changes): User-generated content, inventory, etc. Short TTL (30s–5min) + on-demand revalidation.
        - **REALTIME** (Immediate reflection): Chat, notifications, payment status, etc. No cache + WebSocket/SSE.
    2.  **No Blind Cache**: Setting `cache: 'force-cache'` or `revalidate: 0` "just because" is prohibited. Document an explicit cache strategy based on tier classification for each data source.
    3.  **Cache Invalidation Strategy**: Design cache invalidation strategies (`revalidateTag` / `revalidatePath` / Purge API, etc.) as an integral part of data update flows.
    4.  **Monitoring**: Measure cache hit rates and flag endpoints below 90% as optimization targets.
*   **Rationale**: Uniform cache strategies cause damage on both fronts: sending unnecessary requests for static data (increased cost) and returning stale information for real-time data (degraded UX). Layering based on data characteristics is the only design pattern that achieves both cost efficiency and user experience.

### 13.48. The Explicit Mapping Mandate
*   **Law**: When constructing write payloads for database operations in Service layers or Server Actions, using spread syntax (`...input`) for bulk expansion is **prohibited**. All fields must be explicitly mapped.
*   **Action**:
    1.  **No Spread Payload**: Spread-based payload construction like `supabase.from('table').update({ ...formData })` is prohibited. Unexpected fields in the input object (UI state management fields, etc.) will be sent to the DB, causing errors or data contamination.
    2.  **Field-by-Field Construction**: Construct payloads by specifying each field individually, e.g., `{ name: input.name, email: input.email, status: input.status }`. This makes the scope of transmitted data explicit and review easier.
    3.  **JSONB Structural Mapping**: Nested JSON/JSONB structure fields must also be explicitly constructed rather than relying on top-level spread. Array data (image lists, etc.) in particular requires mapping that accurately maintains the original data's order and content.
    4.  **DTO-Payload Alignment Check**: When fields are added to DTOs, simultaneously add them to the Service layer mapping. Missing mappings are the most common cause of "saved but not reflected" silent bugs.
*   **Rationale**: While spread syntax is concise, it abandons control over "what gets sent." In large admin forms especially, the risk of UI state management fields, computed fields, and undefined fields contaminating the payload is high. Only explicit mapping guarantees data integrity.

### 13.49. The Mutation Count Verification Protocol
*   **Law**: When verifying the results of database write operations (INSERT/UPDATE/DELETE), you must check not only the presence of `error` but also the **number of affected rows (`count`)**. The combination of `error: null` and `count: 0` is a "Phantom Success" and must be treated as an effective failure.
*   **Action**:
    1.  **Count Validation**: For single-record operations with ID specification (`.eq('id', id)`), verify that `count` is `1` (or the expected number). If `count` is `0` or `null`, throw an exception indicating permission denial (RLS rejection) or record absence.
    2.  **Bulk Operation Awareness**: For bulk update/delete operations, verify that `count` matches the number of input data items. Partial success (only 7 out of 10 updated) indicates data inconsistency.
    3.  **Sub-Step Integrity**: When updating multiple tables sequentially within a single Service function, verify both `error` and `count` at every sub-step. Skipping a failed intermediate step results in a "Partial Phantom Success" where only some data is updated.
    4.  **Diagnostic Logging**: Always include `count` in mutation result logs (e.g., `Logger.info('Update result:', { count })`). In post-incident analysis, affected row count is the most critical clue.
*   **Rationale**: In databases using Row Level Security (RLS), queries with insufficient permissions may be silently rejected as "no error, 0 rows affected." The traditional pattern of checking only `error` cannot detect this "failure that looks like success," manifesting to users as the most opaque bug: "saved but not reflected."

### 13.50. The Authentication Guard Enumeration Consistency
*   **Law**: In Role-Based Access Control (RBAC), maintaining separate lists of allowed roles across multiple guard functions is **prohibited**. All guard functions must reference a shared constant array (e.g., `ALLOWED_ADMIN_ROLES`) to establish a Single Source of Truth (SSOT) for role definitions.
*   **Action**:
    1.  **Shared Role Constants**: Define allowed roles (`admin`, `super_admin`, `master_admin`, etc.) as a single constant array, and have all guard functions (page access control, Server Action authorization, RLS policies, etc.) reference this constant.
    2.  **Simultaneous Update Mandate**: When adding new roles, structure the system so all guard functions are automatically updated. Sharing a constant array means only one update location is needed.
    3.  **Dead Zone Detection**: To prevent opaque deadlocks where "you can access the screen but operations (save, etc.) fail silently," periodically audit that page-level guards and action-level guards reference the same role set.
    4.  **Failure Transparency**: When guard functions return authorization errors, catch them on the frontend and detect role inconsistencies immediately via `Logger.warn` in development environments.
*   **Rationale**: When the number of roles increases and not all guard functions are simultaneously updated, an extremely opaque deadlock occurs: "can log into the admin panel, but specific operations are silently rejected." These bugs produce no error messages, wasting enormous time on root cause identification.

### 13.51. The Sub-Step Mutation Integrity Protocol
*   **Law**: When executing multiple asynchronous write operations (INSERT/UPDATE/DELETE) sequentially within a single service method, **the `error` object must be verified at every sub-step**, and if an error occurs, the process must be immediately stopped with an exception thrown.
*   **Action**:
    1.  **No Silent Continue**: Proceeding to subsequent processing without checking the `error` return value, as in `await supabase.from('table').delete()`, is prohibited. Receive results as `const { error } = await ...` for every write operation and perform error checking.
    2.  **Step-by-Step Logging**: Output logs at the start and completion of each sub-step (e.g., `Logger.info('[Step 2/5] Updating tags...')`), enabling immediate identification of which step failed during incidents.
    3.  **Aggregate Error Reporting**: Wrap the entire service method in `try-catch` to prevent intermediate step failures from contaminating the final result (`return { success: true }`), returning an explicit failure response if any step throws an exception.
    4.  **Transaction Awareness**: Recognize that simple external API calls (PostgREST, etc.) are not treated as atomic transactions by default, and incorporate compensating transactions (rollback equivalents) and idempotency guarantees into the design for mid-process failures.
*   **Rationale**: Ignoring intermediate step failures in multi-table updates causes "Partial Phantom Success" where the main table is updated but related tables remain stale. Despite showing "save successful" to users, only some data is reflected, significantly delaying problem discovery.

### 13.52. The Error Object Transparency Mandate
*   **Law**: In error handling, directly concatenating error objects as strings (resulting in `[object Object]` output) is **prohibited**. Error properties such as `message`, `code`, and `details` must be **explicitly destructured** and recorded in logs.
*   **Action**:
    1.  **Structured Error Logging**: Output error object properties as individual fields, e.g., `Logger.error('Operation failed', { error: err.message, code: err.code, details: err.details })`. `Logger.error('Failed: ' + error)` produces `[object Object]`, making root cause identification impossible.
    2.  **Catch Block Standard**: In all `catch` blocks, determine whether the caught error is an `Error` instance, `PostgrestError`, etc., and extract properties appropriately for each type.
    3.  **Error Serialization**: In error responses returned to clients, appropriately transform the internal error structure and return in `{ success: false, error: 'Human-readable message', code: 'ERROR_CODE' }` format.
    4.  **Development vs. Production**: In development environments, include all error properties in logs. In production, mask sensitive information (stack traces, internal paths, etc.) and output only operationally necessary information (`code`, `message`).
*   **Rationale**: `[object Object]` is the most worthless piece of information in incident response. Database errors (Supabase `PostgrestError`, etc.) in particular carry rich diagnostic information such as `message`, `code`, `details`, and `hint`, but direct object concatenation loses all of these, making root cause analysis effectively impossible.

### 13.53. The Post-Mutation Verification Fetch Protocol
*   **Law**: Immediately after high-importance write operations (image reordering, status changes, permission changes, etc.), **execute an immediate `select` (re-fetch) with the same ID** and verify via logs that data has actually been persisted to the database.
*   **Action**:
    1.  **Verification Fetch Pattern**: Immediately after a mutation (`update`, `insert`, `delete`), retrieve the same record via `select` and output the post-update values to logs (e.g., `Logger.info('[Verify] Post-update:', { id, updatedAt: result?.updated_at })`). This enables 100% reliable differentiation between whether the problem is "DB write failure (RLS/Trigger)" or "application-side read/display failure (Cache/UI)."
    2.  **Diagnostic Isolation**: If the verification fetch returns updated values but the UI doesn't reflect them, the problem is definitively in the cache (Data Cache / Router Cache) or form re-initialization. Conversely, if the fetch returns old values, the problem is definitively in the DB layer (RLS rejection, trigger overwrite, etc.).
    3.  **Conditional Application**: Not every mutation needs this. Apply intensively in: (a) privileged operations involving RLS, (b) sequential multi-table updates, (c) areas where users report "saved but not reflected," (d) updates to complex JSONB data structures.
    4.  **Production Consideration**: In production environments, lower the verification fetch log level to `debug` or make it disableable via feature flags. However, maintain the ability to immediately enable it during debugging.
*   **Rationale**: "Saved but not reflected" is one of the most diagnostically difficult bugs in web applications. The only way to distinguish whether the cause is DB write failure (RLS, triggers, insufficient permissions), cache inconsistency, or form re-initialization issues is to verify the physical value in the DB immediately after the mutation. The verification fetch is the only reliable method for this immediate differentiation.

### 13.54. The Static Master Protocol (Centralized Constants Mandate)
*   **Law**: Constant values used across the application (menu items, category definitions, status labels, option lists, etc.) MUST be **centrally defined in dedicated constant files (e.g., `constants/`, `config/`)**. Hardcoding constants within component or page files is prohibited.
*   **Action**:
    1.  **Single Source of Truth**: Consolidate each domain's constants in dedicated files such as `constants/<domain>.ts`, defined immutably with `as const`. Defining literal arrays or objects directly within components is prohibited.
    2.  **Type Derivation**: Automatically derive types from constant definitions using `typeof` + index access types (e.g., `type Status = typeof STATUSES[number]`). Managing constants and types separately causes synchronization failures.
    3.  **Change Impact Control**: Export constants and use them by reference so that all affected locations can be immediately identified when changes occur. Scattered magic strings are the primary cause of silent bugs from missed updates.
    4.  **i18n Readiness**: When defining display labels as constants, clarify the mapping relationship with i18n keys, structuring so that future multilingual support requires only constant file changes.
*   **Rationale**: When constants are scattered across components, every business rule change requires searching and modifying all files, causing frequent UI inconsistencies and logic bugs from missed updates. Centralized management is fundamental to the SSOT principle and dramatically reduces refactoring costs.

### 13.55. The Generic Type Inference Safety Protocol
*   **Law**: Using **any-indexed signatures** such as `Record<string, any>` or `{ [key: string]: any }` as "convenient types" in generic components, utility functions, and shared type definitions is **prohibited**. Concrete type parameters, `unknown`, or constrained generics are mandatory.
*   **Action**:
    1.  **No Any Index**: Use `Record<string, unknown>` instead of `Record<string, any>`, and narrow with type guards at access points. `any` completely disables type checking, making even property name typos undetectable.
    2.  **Constrained Generics**: Use constrained generics like `<T extends BaseType>` for generic functions to guarantee type safety at call sites. `<T>` alone risks `T` being inferred as `any`.
    3.  **Mapped Type Preference**: When dynamic keys are needed, prefer Mapped Types such as `Pick<FullType, K>` or `Partial<FullType>` over `Record`. This ensures the range of permitted keys is verified at compile time.
    4.  **Inference Verification**: At generic function call sites, verify via TypeScript hover display that inference results match expectations. If inferred as `any`, review the type parameter constraints.
*   **Rationale**: `any` index signatures fundamentally destroy type safety, making access to nonexistent properties, incorrect type assignments, and structural mismatches all undetectable at compile time. This is "typed `any`" — one of the most dangerous anti-patterns that nullifies the very purpose of using TypeScript.

### 13.56. The Multi-Axis Deployment Audit Protocol
*   **Law**: When adding or modifying features, "it works" alone does not meet deployment criteria. All **4 axes must be green** before deployment is permitted, verified autonomously.
*   **Action**:
    1.  **Security (Audit Log)**: Verify that destructive actions (create, update, delete) have audit logging (`recordAuditLog`, etc.) instrumented. Operations without audit trails are ungovernable and make incident investigation impossible.
    2.  **Structured Data**: When modifying public pages, verify that structured data (JSON-LD, OpenGraph, etc.) is updated to the latest state. This directly impacts SEO and accurate information retrieval by AI agents.
    3.  **UX (User Experience)**: Verify that error messages, tooltips, and confirmation dialogs are appropriately provided in the user's language. Exposing technical messages degrades production quality.
    4.  **Type Safety**: Verify that no new `any`, opaque casts (`as unknown as`), or any-indexed signatures have been introduced.
*   **Rationale**: The mindset of "it works, so it's done" leaves blind spots in security, SEO, UX, or maintainability. Structurally requiring multi-axis quality criteria prevents post-deployment rework and incidents.

### 13.57. The DTO Segregation Protocol
*   **Law**: Aggregating all project DTOs and interfaces into a single bloated type definition file (e.g., `types/index.ts`) is **prohibited**. Split files by functional domain.
*   **Action**:
    1.  **Domain-Based Splitting**: Split DTO definitions by functional domain (e.g., `types/store.ts`, `types/user.ts`, `types/article.ts`). When a single file contains more than 10 DTO definitions, splitting review is mandatory.
    2.  **No Circular References**: Prevent circular references between type definition files (`A → B → A`). Place common base types in shared files like `types/common.ts` and keep dependency direction unidirectional.
    3.  **AI Context Efficiency**: Maintain a structure that allows AI agents to pinpoint-read only relevant types. Bloated type files waste AI context windows and degrade accuracy.
    4.  **Index Re-export**: Re-exports from `types/index.ts` (`export { StoreDTO } from './store'`) are permitted for convenience, but defining types directly in that file is prohibited.
*   **Rationale**: Bloated type definition files increase developer cognitive load, degrade AI agent context efficiency, and cause frequent merge conflicts on Git. Domain-based splitting achieves separation of concerns and parallel development efficiency.

### 13.58. The Mapper Input Robustness Protocol
*   **Law**: In DTO mapper function design (database row → DTO conversion functions), apply **Postel's Law**: "Be conservative in what you send, be liberal in what you accept."
*   **Action**:
    1.  **Liberal Input**: Mapper function input types should assume that ORM/DB client inference results are incomplete (Partial, null-mixed, amorphous join results, etc.) and must not enforce overly strict types. Use of `Record<string, unknown>` or lossless intermediate types is permitted.
    2.  **Conservative Output**: Mapper function return values must always be explicitly defined DTO types (`StoreDTO`, `UserDTO`, etc.) where the type checker guarantees the existence and type of all fields.
    3.  **Internal Validation**: In exchange for relaxed input types, mandate thorough value validation/fallback processing within mapper functions (`input.name ?? ''`, `Number(input.price) || 0`, etc.). This converts invalid inputs to safe default values.
    4.  **No Partial Cascade**: Prevent "Partial propagation" where using Partial in mapper input types causes output DTO fields to also become optional. Output types must always be complete types (Required).
*   **Rationale**: ORM/DB client type inference frequently returns incomplete types for table joins and RPC calls. Enforcing strict input types causes frequent Partial mismatches and `never` type errors, pushing developers into a vicious cycle of `as any` escape casts. Being liberal with input and conservative with output achieves both practicality and type safety.

### 13.59. The Migration Static Analysis Guard Protocol
*   **Law**: Mandate execution of **static analysis** via CI pipelines and Pre-push hooks (Git Hooks) when pushing/merging database migration files, physically rejecting dangerous SQL patterns. "Operational rules" that depend on human attention will inevitably be broken. Only automated guards that reject at the system level protect the production environment.
*   **Action**:
    1.  **Forbidden Pattern Detection**: Reject Push/Merge when the following patterns are detected in migration files:
        -   **`UPDATE` without `DO` block**: Unprotected updates without WHERE clause or conflict handling. Leads to data inconsistency (Constraint Violation).
        -   **`INSERT` without `ON CONFLICT`**: Unprotected insertions that invite unique constraint violations.
        -   **`UNIQUE` constraint without Cleanup**: Adding unique constraints without cleaning up existing duplicate data causes migration to fail with errors.
    2.  **Pre-push Hook**: Execute a script (e.g., `scripts/migration-guard.ts`) before local pushes to provide immediate feedback on dangerous SQL. Bypassing the hook with `--no-verify` is prohibited as an act that destroys project reliability.
    3.  **CI Pipeline**: Keep a `migration:check` job constantly running in CI (GitHub Actions, etc.) as the final defense line against human error. Deletion or disabling of this CI job is prohibited.
    4.  **Custom Rules**: Design the rule set to be extensible so project-specific dangerous patterns (e.g., `DROP TABLE` without `IF EXISTS`, `ALTER TABLE DROP COLUMN` without backup) can be added.
*   **Rationale**: Migration accidents directly lead to "irreversible destruction of production data". Defense relying solely on code review is easily breached through reviewer oversights or skipping during emergency deployments. Mechanical static analysis guards protect the production environment 24/7, without any exceptions.

### 13.60. The Feature Flag Lifecycle Protocol
*   **Context**: Feature Flags enable safe releases, but unmanaged flags increase code complexity and become technical debt. Strictly manage the lifecycle from creation to deletion.
*   **Lifecycle**:
    | Phase | Description |
    |:------|:-----------|
    | **Creation** | Document flag name, purpose, and expiration date |
    | **Activation** | Verify in staging environment, then gradually roll out to production |
    | **Full Rollout** | Rollout complete to all users, start countdown to flag removal |
    | **Removal** | Delete all flag-related code and restore to a clean state |
*   **Maximum Lifespan**: **90 days**. Flags exceeding this duration MUST be recorded as technical debt and prioritized for removal in the next sprint.
*   **Naming Convention**: The `FF_<FEATURE_NAME>` format is recommended.
*   **Prohibition**: Nesting Feature Flags (flags within flags) is **prohibited** as it causes cognitive complexity to explode.
*   **Cleanup Obligation**: When removing a flag, all related conditional branching code (e.g., `if (featureFlags.ff_xxx)`) MUST be deleted **in the same PR**. Leaving them behind is considered accumulation of technical debt.
*   **Quarterly Inventory Obligation**: Conduct an inventory of all flags at the end of each quarter and apply the following rules.
    | State | Days | Action |
    |:------|:-----|:-------|
    | ON (fully rolled out to all users) | > 30 days | Remove the flag and keep only the new feature code |
    | OFF (deprecated) | > 30 days | Remove both the flag and the legacy code |
    | Experimenting | > 90 days | Record as technical debt, resolve in next sprint |
*   **Rationale**: Feature Flags are "temporary switches," not "permanent configurations." Abandoned flags exponentially increase code paths, raise testing difficulty, and become breeding grounds for unexpected bugs. Regular inventory and lifecycle management maintain codebase health.

---

## Appendix A: Quick Reference Index

| Keyword | Sections | Related Rules |
|---------|----------|---------------|
| Naming / kebab-case | §1 | `340_web_frontend`, `342_mobile_flutter` |
| Performance / LCP / CWV | §2 | `340_web_frontend`, `502_site_reliability` |
| DevSecOps / Security | §3 | `600_security_privacy`, `601_data_governance` |
| Technical Debt | §4 | `720_cloud_finops` |
| AI-First / Code Review | §5 | `400_ai_engineering` |
| Green Coding / Sustainability | §6 | `720_cloud_finops` |
| Zero Bug Policy | §7 | `700_qa_testing`, `503_incident_response` |
| Git / Version Control | §10 | `502_site_reliability` |
| Documentation Ops | §11 | `500_internal_tools` |
| Feature Flags | §12, §13 | `502_site_reliability`, `700_qa_testing` |

