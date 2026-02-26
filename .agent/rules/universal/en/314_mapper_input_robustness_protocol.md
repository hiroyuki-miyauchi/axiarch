# 30. Engineering Excellence (General)

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
