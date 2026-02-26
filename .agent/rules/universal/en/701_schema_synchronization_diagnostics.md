# 70. QA & Testing Strategy

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
