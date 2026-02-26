# 37. Backend Engineering (Supabase & PostgreSQL)

## 0. Data Sovereignty Law & Supreme Directives

### Supreme Directive 0.1: The Zero Tolerance Linter Protocol
*   **Law**: Database Linter (Supabase Security Advisor, etc.) warnings are NOT "suggestions" but **"vulnerability reports"**.
*   **Mandate**:
    1.  **Zero Warnings**: Schemas deployed to production MUST **always have 0** Linter warnings. Any warnings block release.
    2.  **Universal Fix**: Warnings like "Search Path Mutable" or "Permissive Policy" MUST be **mechanically and immediately fixed**. No project-specific exceptions.

### Supreme Directive 0.2: The Trinity DTO Mandate
*   **Purpose**: Obligation of trinity to guarantee data structure robustness and scalability.
    *   **Security**: Physically prevent raw data leakage (White-list Output).
    *   **Stability**: Protect frontend from DB changes (Mapper Shield).
    *   **AI Economy**: Save AI tokens (Data Minimization).
    *   **Universality**: An engineering **iron rule** regardless of language.

### Supreme Directive 0.3: Omnichannel Data Principle (API First)
*   **Principle**: Data structures must be designed assuming consumption not only by a single Web app but also by native apps, external systems, and AI agents.
*   **Mandate**:
    *   **Universal Types**: Do NOT store data types dependent on specific UI frameworks (React Node, etc.) in DB.
    *   **Neutral JSON**: Manage JSON data as "pure data" without display logic.

### Core Laws
*   **SSOT (Single Source of Truth)**: Settings, user data, and content all have **PostgreSQL (`public` schema)** as the Single Source of Truth. "Dual management" in JSON files or external CMS is strictly prohibited.
    *   **Prohibition**: "Holding temporarily in JSON" is data rebellion.
*   **Migration Only**: DB schema changes must ALWAYS go through coded `supabase/migrations`. Manual changes via admin console (Supabase Dashboard SQL Editor, etc.) are considered "history destruction".
*   **Migration Immutability Law (Sanctuary)**:
    *   **Law**: `supabase/migrations/*.sql` becomes a "sanctuary" the moment it's committed, **permanently prohibiting rename, edit, or delete**.
    *   **Felony**: Post-remote-DB-apply fixes MUST be done via "new file". Past tampering is **instant death-level felony (Instant Felony)**.

---

## 1. Hybrid Stack Responsibility
*   **The Hybrid Stack**:
    *   **Edge (Cloudflare)**: **Shield & Optimize**. Handles DDoS protection, WAF, image resizing, and static asset caching. Contains no logic.
    *   **Frontend (Vercel)**: **Router & Renderer**. Handles stateless UI rendering and API routing. High CPU load tasks (image processing, AI waiting) are prohibited.
    *   **Backend (Supabase)**: **Source of Truth**. Handles DB, Auth, Storage (Origin), and Async Jobs (Edge Functions).

## 2. Database Design (PostgreSQL)

### Rule 2.0: The Realism Mandate (Anti-Haribote Protocol)
*   **Prohibition**: Implementing UI that treats columns not in DB or ambiguously defined data in `jsonb` as if it were normalized data is prohibited.
*   **Requirement**: Attributes involved in important business logic (finance, permissions, state transitions) MUST be defined as normalized columns (`numeric`, `text`, `boolean`) with physical storage secured before UI implementation.
*   **Anti-Pattern**: "Build UI first, save later" is not permitted. UI and data must be released simultaneously as indivisible atoms (Atom).

### Rule 2.0.1: The Settings Column Architecture (No JSON Blob)
*   **Law**: Site settings and system settings MUST NOT be stuffed into a single JSON/JSONB column (`config: jsonb`); manage with **normalized columns**.
*   **Reason**:
    1. **Query Performance**: Enables fast WHERE clauses and aggregation via SQL.
    2. **Type Safety**: TypeScript/zod type inference becomes accurate, preventing "undefined key" errors.
    3. **Integrity**: Foreign key constraints and CHECK constraints become applicable.
*   **Migration**: DB migration is mandatory when adding new settings items.

### Rule 2.1: Integrity & Ownership
*   **RLS Absolute**: Row Level Security (RLS) is absolute. `service_role` key usage is prohibited in principle; all queries must pass through RLS.
*   **Hierarchical Resource Ownership**:
    *   **Context**: Complex ownership structures like family sharing or team projects that cannot be expressed with single owner (`user_id`).
    *   **Law**: When multiple users access resources, define permissions (`role: 'viewer'|'admin'`) via intermediate tables (e.g., `resource_members`) and control access via RLS policies referencing this relationship table.
    *   **Action**:
        1.  **Owner ID**: Retain primary owner as `owner_id`.
        2.  **Role-Based**: Manage permissions via intermediate tables.
        3.  **Inheritance**: Child resources inherit parent resource access via `EXISTS` clause, guaranteeing double security.
*   **PII Encryption**: Recommend encrypting highly confidential personal info (accounts, document numbers, etc.) using Vault or pgcrypto.

### Rule 2.2: Schema & Type Standards
*   **Schema Separation**: Strictly separate `public` (App Data), `extensions` (PostGIS, etc.), `admin` (Audit Logs/Admin Views). Installing `extensions` into `public` is prohibited.
*   **System Schema Immunity**: DDL operations like `ALTER TABLE` on tables in system schemas (`storage`, `auth`, `graphql`) are prohibited in principle (causes permission error `42501`).
*   **Constraints**:
    *   **Identity**: Use `GENERATED BY DEFAULT AS IDENTITY` (Standard SQL) instead of `SERIAL` for auto-increment.
    *   **Money**: Use `numeric`/`decimal` or `integer` (smallest unit) for monetary calculations. `float` is strictly prohibited.
    *   **Boolean**: `boolean` columns must be `NOT NULL DEFAULT false` to prevent 3-valued logic (`null` contamination).

### Rule 2.3: Type Safety Protocol (The Bridge)
*   **Automated Types**: Use `supabase gen types` generated `database.types.ts`.
*   **The Mapped Type Bridge Mandate**:
    *   **Law**: When defining extended types (`DatabaseExtended`), intersection types (`&`) are prohibited (inference conflict risk).
    *   **Action**: MUST use **Mapped Type** to iterate over `keyof Database` and physically override, ensuring 100% type safety.

### Rule 2.4: The New Table Checklist (Creation Protocol)
*   **Law**: The following items MUST ALL be satisfied as completion criteria for new table creation:
    - [ ] **RLS Enable**: Executed `alter table ... enable row level security;`?
    - [ ] **Policy**: At least `TO service_role` policy exists? (Avoid default deny)
    - [ ] **Index**: Added index to foreign keys (`*_id`)?
    - [ ] **Type**: Regenerated `database.types.ts` and updated type definitions?
    - [ ] **Audit**: Set trigger to `audit_logs`? (For important tables)
