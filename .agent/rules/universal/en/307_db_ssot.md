# 30. Engineering Excellence (General)


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

### 13.19. The Clean Workspace Mandate
*   **Law**: Upon task completion, temporary files created for verification (`test-*.ts`, `*.log`, `debug-*.ts`) and build caches (`*.tsbuildinfo`) MUST be **immediately discarded** ("Use and Dispose").
*   **Action**:
    *   **Scorched Earth**: Empty directories (`snapshots/`, `snippets/`), leftover backup files, and JSON dumps used only during development are "relics of the past" — committing them to the repository is prohibited.
    *   **Build Artifact**: Build caches like `.tsbuildinfo`, `.next/cache` MUST be managed in `.gitignore` and never included in the repository.
    *   **Verification**: Before committing, verify with `git status` that no unintended files are included.
*   **Rationale**: Leaving unnecessary files degrades the codebase's S/N ratio (Signal to Noise ratio), misleading subsequent developers and AI agents.

*   **Law**: Upon task completion, all temporary files, build caches, empty directories, and debug `console.log` statements generated during work MUST be **removed** before committing. Repositories maintain a clean state following the "Scorched Earth" principle.
1.  **Checklist**: Verify the following before committing:
*   No temporary files (`.tmp`, `.bak`, `*.log`, etc.) remain
*   No empty directories (folders with 0 files) remain
*   No `console.log` / `console.debug` remains in code
*   Build caches (`.next/cache`, etc.) are not included in Git tracking
2.  **Gitignore Hygiene**: Verify that `.gitignore` comprehensively covers build outputs, environment files, and IDE settings at initialization.
3.  **Branch Hygiene**: Promptly delete merged branches. Abandoned branches are breeding grounds for "incidents caused by environment differences."
*   **Rationale**: Leftover temporary files and debug code impose unnecessary cognitive load on the next developer (including your future self) — "Was this code intentionally left?" A clean repository directly impacts the entire team's productivity.
