# 30. Engineering Excellence (General)

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
