# 52. SRE & Reliability Engineering

### 8.10. The Schema-Code Synchronization Sovereignty
*   **Law**: Even when application code achieves "Zero Defects (type check, build, and lint all pass)," the system cannot function correctly if **database schema (migrations) are not applied** to the production/staging environment. "Zero Defects" is only established when both code and schema are synchronized.
*   **Action**:
    1.  **Migration Status Check**: Before deployment and during debugging, verify that no unapplied migrations exist using `migration list` or `migration status` commands.
    2.  **Schema Drift Detection**: Verify that columns and tables referenced by type definitions (auto-generated types like `database.types.ts`) physically exist in the actual database. The existence of a type does not guarantee physical existence.
    3.  **Deploy Pipeline Integration**: In CI/CD pipelines, incorporate migration application as a **prerequisite** for code deployment. Deploying code without applying migrations causes catastrophic failures where all queries fail.
    4.  **Error Pattern Recognition**: When `column "xxx" does not exist` or `relation "xxx" does not exist` errors occur, suspect **Schema Drift** first rather than code bugs.
*   **Rationale**: TypeScript's type safety guarantees "compile-time consistency" but not "runtime consistency with the database." A "Phantom Column" — a column that exists in auto-generated type definitions but not in the actual database — is one of the most diagnostically challenging bugs that passes type checking but crashes at runtime.

*   **Maintenance Mode**:
*   **Switch**: Manage maintenance state via DB settings (`site_settings`) and check in both Middleware and Server Actions. Physically block writes from backdoors.
*   Set timeouts on external API calls and return default values on failure (Fail Safe).
*   **Job Queue**:
*   Decouple heavy processing like email sending and image analysis from API response cycle, and execute asynchronously with **Supabase Edge Functions + pgmq**.
