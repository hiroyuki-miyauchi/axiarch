# 30. Engineering Excellence (General)

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
        *   **The License Quarantine (AGPL Block)**: For license governance details, refer to the 600-series (Security & Privacy) Rule 5 and thoroughly prevent **AGPL (Affero GPL)** usage.
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
