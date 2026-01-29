# 30. Engineering Excellence (General)

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
        *   **The License Quarantine (AGPL Block)**: Strictly prevent unrelated open source code contamination. Reference `60_security_privacy.md` Rule 5 for **AGPL (Affero GPL)** prevention.
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

## 3. Security by Design (DevSecOps)
*   **Zero Trust**:
    *   Trust no input (user input, API responses). Validate on both client and server.
*   **Secrets Management**:
    *   Never commit secrets. Use `.env` and secret managers.
    *   **The Single Source of Config**:
        *   **Prohibition**: Directly referencing `process.env.NEXT_PUBLIC_...` throughout code (in components, etc.) causes modification omissions and lacks type safety—prohibited.
        *   **Action**: Centrally manage in `src/lib/config` (or `env.ts`) and reference only that constant object throughout the application. Recommend existence validation in this layer.

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
        *   **The License Quarantine (AGPL Block)**: For license governance details, refer to `60_security_privacy.md` Rule 5 and thoroughly prevent **AGPL (Affero GPL)** usage.
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
        *   **Ref**: Absolute prohibition of AI Git operations. Refer to Rule 8.1 in `00_core_mindset.md`.
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

## 11. Documentation Ops
*   **Living Documentation**:
    *   **Mermaid.js**: Architecture diagrams must be code (Mermaid), not images, to prevent obsolescence.
    *   **ADR**: Technical decisions are recorded in Markdown at `docs/adr`.
*   **Docs as Code**:
    *   Documentation is equal to code; managed in Git and subject to PR review. No code merge without doc updates.
*   **Freshness**:
    *   Automate link rot checks. Review key rules quarterly.

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
