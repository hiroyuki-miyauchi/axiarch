# 70. QA & Testing Strategy

## 1. Shift Left Testing
*   **Early Detection**:
    *   Start QA process from requirement definition and design stages, not the final stage of development.
    *   **Static Analysis**: Integrate ESLint, SwiftLint, Detekt etc. into CI to automatically detect issues before code review.
*   **Testing Pyramid**:
    *   **Unit Tests (70%)**: Base on fast and stable unit tests. Coverage goal is 80%+, but value "coverage of critical logic" over numbers. Unit tests for UI components are not recommended due to low ROI.
    *   **Integration Tests (20%)**: Verify coordination between API, DB, and components.
    *   **E2E Tests (10%)**: Target only user critical paths (registration, payment, key features) to suppress maintenance costs. Automate only critical flows.
    *   **Priority**: 1. Type Check(tsc) > 2. Lint > 3. Manual > 4. E2E > 5. Unit. Static Analysis (tsc) is the strongest test.
*   **Mock First Strategy**:
    *   **Offline Dev**: Implement `MOCK_MODE` to allow development without external APIs (Stripe, SendGrid). If no API key, mocks respond automatically to keep dev moving.

## 2. Flaky Test Management
*   **Immediate Action**:
    *   Unstable tests (Flaky Tests) are the biggest enemy of developer trust. Fix immediately upon discovery, or Disable (Skip) until fixed.
    *   **No Retry**: "Auto-retry" that hides test failures is prohibited in principle; solve the root cause.
*   **Seed Data Determinism (Fixed Seed)**:
    *   **Law**: To build reproducible test environments, mandate use of **Fixed IDs/Values** for test data (Seed), never random numbers. "Tests that change results every time" are not tests.
    *   **Snapshot**: Tests dependent on timestamps must also fix time using `FakeTimer` etc.

## 3. Real Device & Compatibility
*   **Mandatory Real Device Testing**:
    *   Simulators are not perfect. Always verify operation on physical devices (iOS/Android) before release.
    *   **TestFlight / Internal App Sharing**: All development team members must dogfood on real devices to detect UX awkwardness.
*   **Fragmentation**:
    *   **Android**: Verify operation on major manufacturers (Samsung, Pixel, Xiaomi) and different OS versions using BrowserStack or AWS Device Farm.
    *   **Network**: Test behavior in unstable network environments like Offline, 3G (Slow), Recovery from Airplane Mode.
*   **Manual Verification Protocol**:
    *   Upon feature completion, verification from following perspectives is mandatory.
    *   **Verification Checklist (Mandatory)**:
        *   **Happy Path**: Does the normal flow work?
        *   **Edge Cases**: Zero data, max characters, network error behavior.
        *   **Cross-Device**: Verify display breakage on PC (Chrome) vs Mobile (iOS Safari Real Device). Watch out for iOS `100vh` issues and Safe Area.
        *   **Role Access**: Is permission separation correctly functioning for Guest, General User, and Admin?
        *   **API Security**: Confirm that requests without `x-api-key` are rejected (Public), and requests with `Authorization: Bearer` (User) are allowed (Native Bypass).
        *   **Natural Scrolling**: No unintended "mystery whitespace" at screen bottom? No double scrollbars?

## 4. Fix Twice Principle
*   **Double Fix**:
    *   When fixing a bug, do not just "Fix Once". Make it a set to "Fix Twice" by creating a mechanism (Add Lint, Strict Type, Add Test) to prevent the same bug from happening again.
*   **The Regression Ban Protocol (Zero Recurrence Mandate)**:
    *   **Law**: Defining "Recurrence of a once-fixed bug" (Regression) as the **"Greatest Failure"** in engineering.
    *   **Action**: 
        1. **Visibility**: When fixing a recurring bug, MUST explicity write "Fact of Recurrence" and "WHY previous mechanism failed" in `task.md` or `walkthrough.md`.
        2. **Hardening**: Mandatory condition for task completion is not just code fix, but adding **Automated Test (Regression Test)** that physically catches that bug.

## 5. Release Criteria
*   **Blockers**:
    *   Release with P0 (Critical) and P1 (Major) bugs remaining is **strictly prohibited**.
    *   **0 Warnings**: Release with Warnings remaining in console or build logs is also prohibited.
*   **Phased Rollout**:
    *   Do not release to all users at once; expand range gradually 1% -> 5% -> 20% -> 100% to minimize impact of unexpected defects.

## 6. Ultimate User Perspective
*   **The Grandmother Test**:
    *   **Standard**: Always ask yourself "Can my grandmother who is not tech-savvy use this without explanation?".
    *   **Intuitiveness**: UI requiring a manual is considered a "Bug".
*   **Bug Bash**:
    *   Before major releases, hold a "Bug Bash" with everyone including designers and PMs, not just engineers, to wash out edge cases from diverse perspectives.

## 7. CI/CD Environment Awareness

### 7.1. The Clean Room Mirage Protocol
*   **Law**: CI tests against an "empty DB (Clean Room)," so **it cannot detect data-dependent constraint violations (duplicate data, missing foreign key references, etc.)**. Production deployment (CD), on the other hand, runs against a "dirty DB." This gap is the main culprit behind "CI Green but Production Deploy Failure."
*   **Action**:
    1.  **Data-Aware Migration**: Migrations containing DML (`UPDATE`, `INSERT`) MUST be written with defensive code (`DO` blocks, `ON CONFLICT`, duplicate removal logic) anticipating conflicts with production data.
    2.  **No Blind Trust**: "It worked locally" or "CI passed" is not a free pass. Supplement with imagination or reference to production data structures.
    3.  **Staging Verification**: Whenever possible, pre-verify migrations on a staging environment with production-like data.
*   **Rationale**: CI's "all green" is merely "success in a clean room." When you forget the complexity of production (existing data, concurrent access), deployment failure is guaranteed.

### 7.2. The RFC 7807 Error Response Standard
*   **Law**: All API error responses MUST be returned in a structured format compliant with [RFC 7807 (Problem Details for HTTP APIs)](https://www.rfc-editor.org/rfc/rfc7807). Simple string errors (`"Something went wrong"`) are prohibited.
*   **Action**:
    1.  **Structured Format**: Error responses MUST include at minimum `type` (error type URI), `title` (human-readable summary), `status` (HTTP status code), and `detail` (specific description).
    2.  **Machine-Readable**: Make the error type uniquely identifiable via the `type` field so that AI agents and external SaaS can autonomously analyze and handle errors.
    3.  **Consistent Handler**: Centralize error response generation in a common helper function (`errorResponse()`, etc.) to guarantee format consistency.
*   **Rationale**: Unstructured errors are "uncooperative design for AI." In the generative AI era, API consumers are not just humans. Machine-readable error formats enable automatic retries, error classification, and incident response automation.

## 8. Schema Synchronization & Diagnostics

### 8.1. The Full-Stack Schema Synchronicity Protocol
*   **Law**: When modifying data models (table structures, settings schemas, etc.), **all layers — Migration → Schema/Type definition → DTO → Action/Service → UI — MUST be modified in a single batch**, maintaining Zero Defect state in a single commit. "Partial update commits" where even one old reference remains are prohibited.
*   **Action**:
    1.  **Vertical Slice**: When changing schemas, use a "Vertical Slice" approach to change all layers at once. Horizontal splitting ("first DB only," "then API only") creates intermediate states that lead to type errors and runtime crashes.
    2.  **Type-Driven Discovery**: If you change type definitions (TypeScript Interface / Zod Schema, etc.) first, the compiler will automatically detect all "old references." Continue fixing until type errors reach zero.
    3.  **Search & Destroy**: For references undetectable by the type system (dynamic keys, JSON paths, test fixtures, etc.), Grep across the entire project and fix manually.
*   **Rationale**: "Fix later" is a synonym for "forget." Until schema changes propagate to all layers, the system enters the most difficult-to-diagnose state: "types are correct but it breaks at runtime."

### 8.2. The Phantom File Awareness Protocol
*   **Law**: When build errors indicate "non-existent files" or "line number mismatches," they may be pointing to **actual files resolved via re-exports or Barrel files** by the bundler or transpiler. Do NOT take error message file names at face value — **Grep by the error line's code content to identify the real culprit**.
*   **Action**:
    1.  **Content Grep**: Execute `grep -rn "error content" src/` using the "code content of the error line" from build errors to identify the file where the code actually exists.
    2.  **Import Chain Trace**: If the error points to an `index.ts` (Barrel File), individually examine each file re-exported from it.
    3.  **Source Map Awareness**: Error messages after minification/bundling may have broken correspondence with original sources. Verify build errors with Source Maps enabled.
*   **Rationale**: Module bundlers (Webpack, Turbopack, esbuild, etc.) combine and transform multiple files, so error message file paths and line numbers may not match the "real file" the developer needs to edit. Without recognizing this "Phantom File" problem, developers waste time endlessly searching for non-existent files.

### 8.3. The Vertical Synchronization Protocol
*   **Law**: When field omissions or inconsistencies in forms are suspected, **all layers — DB Schema → DTO → Gateway/Service → UI Interface (form definition) — must be vertically verified**. "Ghost fields" that exist only in the UI but not in the DB must be immediately removed.
*   **Action**:
    1.  **Top-Down Trace**: For the field in question, verify existence and naming consistency in order: DB table definition → DTO type definition → Gateway/Service Select Spec → UI form definition (`defaultValues` / `register` / `Controller`).
    2.  **Ghost Field Detection**: Fields defined in the UI interface but not existing in the DB schema are "Phantom Fields." Unimplemented fields reserved for the future cause misidentification as "missing" during form audits (Rule 35.100, etc.) — remove them from the UI interface.
    3.  **Bottom-Up Verification**: Verify that newly added DB columns have propagated to all layers: DTO, Gateway, and UI. If any single layer is missing, "saves successfully but doesn't display" or "displays but doesn't save" inconsistencies occur.
    4.  **Naming Consistency**: Verify that field names (property names) are completely identical across all layers. Subtle naming variations (e.g., `dog_description` vs `description_dog`) cause silent mapping failures.
*   **Rationale**: Modern web applications flow data through multiple layers (DB → type definitions → Service → UI). When a change in one layer does not propagate to others, "vertical synchronization inconsistencies" occur where data is lost or becomes undisplayable at runtime even though type checks pass. These are not detected by build errors and can only be discovered through manual vertical traversal.

### 8.4. The Zero Future-Use Code Mandate
*   **Law**: Committing code "just in case it's needed in the future" (unused variables, imports, functions, components, type definitions) is prohibited. All code in the codebase must be **currently in use**.
*   **Action**:
    1.  **YAGNI Enforcement**: Enforce "You Aren't Gonna Need It" and immediately delete unused code. Since it can be recovered from Git history, "keeping it just in case" is unnecessary.
    2.  **Lint Guard**: Set ESLint rules `no-unused-vars`, `no-unused-imports`, etc. to `error` level and physically block them in CI.
    3.  **eslint-disable Prohibition**: Using `// eslint-disable-next-line` is prohibited in principle. When unavoidable, note the reason and Issue number, and require code review approval.
    4.  **Dead Code Scan**: Run dead code scanning tools (`ts-prune`, `knip`, etc.) quarterly to detect and remove unused exports.
*   **Rationale**: Unused code is the classic "broken window" — it causes compiler misdiagnosis, hinders newcomer understanding, and bloats bundle size. If it's needed in the future, rewriting it with the correct specifications at that time is always safer and faster than modifying code based on old assumptions.

### 8.5. The Production Build Verification Protocol
*   **Law**: A development server (`dev` mode) running successfully **in no way guarantees** code correctness. Before creating pull requests and declaring feature completion, `npm run build` (or equivalent production build command) must **always pass**.
*   **Action**:
    1.  **Build Before PR**: Before creating a pull request, run the production build locally and confirm zero errors. "I'll fix it when CI fails" is not acceptable.
    2.  **Dev ≠ Prod**: Development servers hide many errors for hot-reload purposes (skipping type checks, omitting Tree Shaking, disabling Strict Mode, etc.). Always assume that errors only manifesting in production builds exist.
    3.  **CI Enforcement**: Mandate 3-stage gates in the CI/CD pipeline: type check (`tsc --noEmit`) → lint (`eslint --max-warnings=0`) → build (`npm run build`). Block merges if any single stage fails.
    4.  **Build Time Budget**: Start performance investigation when build time exceeds 5 minutes, and treat speed improvement as highest priority when it exceeds 10 minutes.
*   **Rationale**: "It was working in the dev environment" is the most frequent and least valuable report during production incidents. The behavioral differences between development servers and production builds are structural — a workflow that skips build verification is synonymous with "scheduling an outage."

