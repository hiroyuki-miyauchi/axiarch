# 30. Engineering Excellence (General)

### 13.31. The CI/CD Environment Gap Protocol
*   **Law**: CI environments run tests against an "empty database (Clean Room)" and therefore **cannot detect collisions with existing data** (unique constraint violations, foreign key inconsistencies, missing NOT NULL defaults, etc.). Changes involving data manipulation MUST be written with defensive code that anticipates collisions with production data.
*   **Action**:
    1.  **Defensive DML**: Use `ON CONFLICT ... DO UPDATE` or `DO NOTHING` in `INSERT` statements to ensure idempotency.
    2.  **Pre-Check**: When adding `NOT NULL` constraints via `ALTER TABLE`, pre-fill existing `NULL` values with `UPDATE` to set defaults.
    3.  **Staging Verification**: Whenever possible, pre-verify data changes on a staging environment with production-like data.
*   **Rationale**: CI's "all green" is merely "success in a sterile room." When you forget the complexity of production (existing data, concurrent access, historical maintenance debt), deployment incidents will inevitably occur.

### 13.33. The Dead Code Prohibition Protocol
*   **Law**: Keeping code "just in case it's needed later" is the biggest source of technical debt. **Immediate deletion of all currently unused code (unused variables, imports, functions, type definitions) is mandatory.**
*   **Action**:
    1.  **No Future-Use Code**: Code not used by current features must not be kept, including commented-out code. Restore from Git history when needed.
    2.  **Strict Variable Hygiene**: Variables, constants, and imports that are declared but never referenced must be removed before building. The `_` prefix is only permitted for explicit value discarding in destructuring (e.g., `const [_, setValue] = useState()`).
    3.  **Lint Enforcement**: Set ESLint's `no-unused-vars` / `@typescript-eslint/no-unused-vars` to `error` and physically block in CI.
*   **Rationale**: Unused code is a "broken window." If one is tolerated, the entire team judges "a little is fine," and the overall codebase quality deteriorates.

### 13.34. The Warning Suppression Prohibition Protocol
*   **Law**: The casual use of directives that **suppress or ignore linter and type checker warnings** is prohibited in principle. Warnings are "code smells that need fixing" — fix the root cause instead of silencing them.
*   **Action**:
    1.  **ESLint**: `eslint-disable` and `eslint-disable-next-line` usage is prohibited in principle. When unavoidable, a **comment explaining the reason** must be added (e.g., `// eslint-disable-next-line -- library type definition is inaccurate`).
    2.  **TypeScript**: `@ts-ignore`, `@ts-nocheck`, and `@ts-expect-error` usage is prohibited in principle. Resolve type errors by fixing type definitions.
    3.  **Other Tools**: For Stylelint, Prettier, and similar tools, suppression directives are only acceptable as a last resort after root cause resolution.
    4.  **CI Enforcement**: Introducing lint rules that detect new suppression directive additions (e.g., `eslint-comments/no-unlimited-disable`) is recommended.
*   **Rationale**: Warning suppression only "makes problems invisible" without solving them. As suppression comments proliferate, codebase reliability degrades, and truly important warnings get buried.

### 13.35. The Type Integrity Mandate
*   **Law**: Bypassing TypeScript's type system is defined as "embedding bugs." **`as any` type casts are prohibited in principle**, and type accuracy is the highest priority.
*   **Action**:
    1.  **No `as any`**: `as any` completely disables the type checker and is prohibited. When external library types are inaccurate, provide accurate type definitions via `declare module`.
    2.  **Strict Action Return Types**: Server Actions, API handlers, and Service functions must always have explicit return type definitions. Using `any` or `unknown` as return types is prohibited.
    3.  **No Type Assertion Chains**: Multi-step casts like `(value as unknown as TargetType)` are an anti-pattern indicating type safety destruction. Create data transformation functions and perform type conversions with runtime validation.
    4.  **Lint Enforcement**: Set `@typescript-eslint/no-explicit-any` to `error`.
*   **Rationale**: `as any` is a "lie to the type checker." While problems become invisible at compile time, unexpected types circulate at runtime, causing bugs that are extremely difficult to debug.
