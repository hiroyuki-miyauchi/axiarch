# 37. Backend Engineering (Supabase & PostgreSQL)

### Rule 8.1: Security Hardening (The Fortress)
*   **Public Schema Guard**: `REVOKE CREATE ON SCHEMA public FROM PUBLIC;`.
*   **View Security**: `security_invoker = true`.
*   **Search Path Defense**: `SECURITY DEFINER` functions MUST use `SET search_path = ''` and schema-qualified references (`public.users`).

### Rule 8.2: The Audit Log Mandate / WORM
*   Record DB changes in `audit_logs`. Table must be **Append-Only** (RLS protected).

### Rule 8.3: The Comprehensive RLS Audit
*   **Cascading Verification**: Verify RLS changes with **Anonymous User**.
*   **Monthly Audit Mandate**: Checklist:
    - [ ] Policy exists for all actions?
    - [ ] Admin access guaranteed?
    - [ ] General users restricted to own data?
    - [ ] Scalar subquery wrapping applied?

### Rule 8.4: RLS Post-Change Verification Protocol
*   **Verification Scope**:
    1.  **Security Advisor**: Zero warnings.
    2.  **Functional Test**: Admin/User/Anon.
    3.  **Performance**: No unintended sequential scans.
*   **Emergency Recovery**: Immediate `FOR SELECT USING (true)` for affected tables if incident occurs.

---

## 9. Domain Data Modeling

### Rule 9.1: Universal Settings & Tenant-Aware Naming
*   **Strict Column Enforced**: App settings in normalized columns. No `jsonb` config.
*   **Tenant-Aware Naming (SaaS Readiness)**:
    *   **Law**: Distinguish internal resource names for Multi-tenant/Whitelabel.
    *   **Action**: Use `site_` or `account_` for tenant-specifics. Use `system_` only for immutable platform settings.

### Rule 9.2: Static Page Ban (CMS Sovereignty)
*   ToS/Privacy Policy managed in **Headless CMS**. No hardcoded static files.

### Rule 9.3: Structural Integrity Protocols
*   **Structured Tagging**: `tags` table for centralized management.
*   **Business Hours**: Structured JSONB, prioritizing `holidays` logic.
*   **Reputation System**: **Bayesian Average** for reliable scoring.
*   **Geo-Centric**: Physical locations MUST have `latitude`/`longitude` and support location-based search.

---

## 10. Universal Portability
*   **Ecosystem Portability**: Data is a "Digital Asset". Adopt industry standard schemas and metadata for ecosystem compatibility.

---

# 37. Backend Engineering (Supabase & PostgreSQL)

