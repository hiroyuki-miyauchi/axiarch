# 30. Engineering Excellence (General)

## 1. Code Quality & Clean Code
*   **Clean Code Standards**:
    *   **Self-Documenting**: Comments explain "Why", Code explains "What".
    *   **Function Size**: One function, one job. Ideally **under 20 lines**.
    *   **Naming**: Clear and descriptive names. No `data`, `temp` (e.g., `userData` -> `authenticatedUserProfile`).
*   **Blueprint Compliance**:
    *   **Entry Point**: All development work starts by checking `000_blueprint_index.md` (or corresponding rule files).
    *   **Update First**: If design changes are needed during implementation, **update the Blueprint before (or while) coding**. Discrepancy between docs and code is the biggest technical debt.
*   **Zero Warnings**:
    *   **Rule**: Warnings are Errors. CI fails on a single warning.
    *   **Strict Error Handling**: No empty `catch` blocks.
*   **Refactoring (The Boy Scout Rule)**:
    *   **Mandate**: Leave the code cleaner than you found it.
    *   **No "Later"**: Refactor now or never.
    *   **Cyclomatic Complexity**: Keep nesting shallow. Use Early Returns.
*   **Cleanup**:
    *   **Dead Code**: Delete immediately. No commented out code, no unused imports, no console.logs.

## 2. Infrastructure & Performance
*   **Infrastructure Standard (The Golden Quad)**:
    *   **Managed Hosting**: Use managed hosting (e.g., Vercel Pro) with DDoS protection and scalability.
    *   **BaaS**: Use BaaS (e.g., Supabase) with integrated DB and backups as the "Single Source of Truth".
    *   **Edge Shield**: Deploy Edge WAF/CDN (e.g., Cloudflare) to absorb attacks and load at the edge.
    *   **Email Deliverability**: Adopt email infrastructure (e.g., Resend) with excellent DX and deliverability.
*   **Read-Optimized Architecture**:
    *   **Pre-calculation**: Store calculated values (ranking, total sales) in DB columns. No on-the-fly calculation.
    *   **CQRS**: Separate read and write models. Use materialized views.
*   **Performance Budgets**:
    *   **Lighthouse**: Maintain **90+** on all metrics.
    *   **Core Web Vitals**: Strict adherence to LCP, FID, CLS limits.
*   **Asset Optimization**:
    *   **Images**: Force AVIF/WebP. Use optimization components.
    *   **Lazy Loading**: Lazy load everything below the fold.

## 3. Security by Design (DevSecOps)
*   **Zero Trust**:
    *   Trust no input. Validate on both client and server.
*   **Secrets Management**:
    *   Never commit secrets. Use `.env` and secret managers.

## 4. Technical Debt & Cleanup
*   **Debt Paydown**:
    *   Allocate **20%** of sprint to debt repayment.
*   **Tech Radar**:
    *   Update dependencies quarterly. Stay "Bleeding Edge" but safe.
*   **Digital 5S**:
    *   **Seiri**: Delete unused code and files immediately.

## 5. AI-First Engineering
*   **Prompt Driven Development (PDD)**:
    *   **Principle**: The prompt is the source code.
    *   **AI Friendly**: Use descriptive naming (e.g., `daysSinceLastLogin`) for AI context.
*   **RAG Optimization**:
    *   **Modular**: Keep files small (Atomic).
    *   **Semantic Structure**: Organize by feature for retrieval.

## 6. Green Coding & Sustainability
*   **Energy Efficiency**:
    *   **Algorithm**: Optimize O-notation to save battery and planet.
    *   **Dark Mode**: Recommend True Black (#000000) for OLED power saving.
*   **Data Transfer**:
    *   **Compression**: Optimize images and video (AVIF/H.265).
    *   **Cache Maximization**: Aim for **80%+** CDN cache hit ratio to minimize origin load for static assets.
    *   **Centralized Storage Shield**: Centralize image origins in BaaS Storage and route delivery via CDN Optimization features to balance cost and performance.

## 7. Zero Bug Policy
*   **Fix First**: No new features with known bugs. Fixing is top priority.
*   **24-Hour Rule**: Critical bugs must be fixed within **24 hours**.

## 8. Continuous Learning & Verification
*   **Latest Info Protocol**:
    *   **Before Coding**: Check official docs and release notes. Old info triggers rework.
*   **Trend Awareness**: Catch up with Silicon Valley trends (Agents, Privacy Manifests).

## 9. Compatibility & Testing
*   **Real Device Testing**: Test on physical iOS/Android devices.
*   **Browser Compatibility**: Support last 2 versions of major browsers. Watch out for Safari bugs.
*   **Self-Check**: Zero warnings, no clean logs before PR.

## 10. Git & Version Control
*   **Trunk Based Development**: Short-lived branches, daily merges.
*   **Conventional Commits**: Strict `type(scope): subject` format.
    *   **Atomic Commits**: Include only "one logical change" per commit. Maintain granularity that allows reverting "only that commit" to fix a bug.
*   **Pull Requests**: Keep it small (100 lines). Require CI (Build, Test, Lint) pass and review.
    *   **Omnichannel Check**: Reviewers must check "Is this change available for non-Web (iOS/Android)?". "Web Only" logic must be Rejected immediately.
*   **Deployment Safety Protocol**:
    *   **No Unauthorized Push**: The AI Agent MUST NOT execute `git push` without user's explicit permission.
    *   **Pre-Check**: Always pass `tsc --noEmit` (Type Check) and `npm run build` (Build Check) locally before pushing.
*   **Security**: No secrets in repo. TruffleHog scan required.

## 10. Documentation Ops
*   **Living Documentation**:
    *   **Mermaid.js**: Architecture diagrams must be code (Mermaid), not images, to prevent obsolescence.
    *   **ADR**: Technical decisions are recorded in Markdown at `docs/adr`.
*   **Docs as Code**:
    *   Documentation is equal to code; managed in Git and subject to PR review. No code merge without doc updates.
*   **Freshness**:
    *   Automate link rot checks. Review key rules quarterly.

## 12. Engineering Quality Protocols

### 11.1. The Zero-Warning Lint Protocol
*   **Law**: "It works with warnings" is a compromise that leads to quality decay. CI All Green means Zero Warnings.
*   **Action**: `npm run lint` must return **Zero Warnings**. Delete unused variables immediately.

### 11.2. The Clean Import Protocol
*   **Law**: `import` statements must be at the **Top-Level** of the file.
*   **Action**: Imports inside functions or control flows are strictly prohibited. Move them to the top immediately.

### 11.3. The Explicit Explanation Protocol (Zero Jargon)
*   **Law**: Developer "common sense" is user "jargon".
*   **Action**: Always attach a `Tooltip` to technical terms and metrics on the admin panel, explaining "what it is and how it affects business" in layperson terms.

### 11.4. Localization First Protocol
*   **Law**: English error messages cause user churn.
*   **Action**: Localize all error messages and validation messages (including Zod custom errors) into the **Project Native Language** defined in `GEMINI.md`.
