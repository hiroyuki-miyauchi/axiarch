# 30. Engineering Excellence (General)

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
