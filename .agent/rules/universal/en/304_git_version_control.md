# 30. Engineering Excellence (General)

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
        *   **Ref**: Absolute prohibition of AI Git operations. Refer to Rule 8.1 in the 000-series (Core & Mindset).
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

*   **Ref**: Absolute prohibition of AI Git operations. Refer to Rule 8.1 in `00_core_mindset.md`.
