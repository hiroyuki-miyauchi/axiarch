# 37. Backend Engineering (Supabase & PostgreSQL)


### Rule 4.3: Scalability Strategy
*   **Infinite Scalability**: `select('*')` and unlimited queries banned. Pagination mandatory.
*   **Partitioning**: Introduce `pg_partman` when table records exceed **10 Million (10M)**.
*   **Read Replica**: Offload analysis queries to Replica.
*   **Archival**: Evacuate cold data to Object Storage.

---

## 5. Auth & Security
*   **Gotrue Delegation**: Delegate auth completely to Supabase Auth.
*   **Notification Architecture**:
    *   **Aggregation**: Aggregate duplicate actions (e.g., multiple likes) to prevent bombing.
    *   **Async Delivery**: Send emails via async job (`pgmq`).
    *   **The Smart Notification Control Protocol (Email Bomb Prevention)**:
        *   **Law**: Delay email notifications via job queue (mins to tens of mins).
        *   **Logic**: Check "if already read in app" before sending; skip if read.
        *   **Outcome**: Prevent "spamming for seen content" and user churn.

---

## 6. Storage & Delivery
*   **Cloudflare Proxy Shield**: Image delivery must go through Cloudflare.
*   **Bucket Separation**:
    *   **Public**: Store photos, avatars. Maximize CDN cache.
    *   **Private**: Invoices, personal docs. **Signed URL** and strict RLS mandatory.
    *   **Ads**: Separate banner ads (`bucket-ads`).
*   **User Upload Hygiene**: Resize on client, **Delete EXIF GPS** before upload.
*   **The Signed Upload URL Mandate (Direct-to-Storage Pattern)**:
    *   **Law**: Prohibit uploading large files (images, videos) through application servers (Vercel/Cloud Functions).
    *   **Flow**:
        1. **Server Action**: Verify auth/permissions, issue **Signed Upload URL**, return to client.
        2. **Client Direct Upload**: Client uploads directly to Storage.
    *   **Outcome**: Reduce app server load and avoid transfer costs/timeouts.

---

## 7. Operations & Migration

### Rule 7.1: The Migration Protocol (Ghost Table Defense)
*   **Remote Execution**: Use Dashboard SQL Editor for schema changes, save log to `supabase/migrations` (Git).
*   **Migration Timestamp Hygiene**:
    *   **Action**: Always check `ls supabase/migrations` for **latest timestamp** to ensure order integrity.
*   **Atomic Migration**: `DROP` and `CREATE` policies in same file.
*   **Ghost Table Defense**:
    *   **Law**: `ALTER` or `CREATE POLICY` on non-existent tables causes errors.
    *   **Action (Table Existence Verification)**: Use `DO $$ ... IF EXISTS ...` block when referencing external/uncertain schemas. No assumptions.
*   **Remote Schema Warning**: Always check current DB state (Dashboard/`pg_tables`) before writing SQL.

### Rule 7.2: IPv6 & CI/CD Protocol
*   **GitHub Actions**: Use `supabase link` (Connection Pooler) or `SUPABASE_DB_URL` (Direct) appropriately to prevent IPv6 errors.

### Rule 7.3: Data Seeding & Caching Determinism
*   **Seed Determinism**: Initial data (`seed.sql`) must use **Fixed IDs/Values**.
*   **Cache Versioning**: When caching master data (`unstable_cache`), always suffix cache keys (e.g., `master_data_v2`) to prevent Cache Rot during schema changes.
*   **Verification**: Verify actual data count after seeding. CLI "Up to date" is not proof.

### Rule 7.4: Migration Idempotency Protocol
*   **Mandate**: Migrations must produce same result upon re-execution.
*   **Implementation**: Use `CREATE TABLE IF NOT EXISTS`, `DROP ... IF EXISTS`, etc.

### Rule 7.5: Cache Reload Protocol
*   **Mandate**: After major schema changes (column add/delete, type change):
    1.  Regenerate `database.types.ts`.
    2.  Restart Dev Server.
    3.  Restart Production Service / Refresh Connection Pool.

### Rule 7.6: The Zero SQL Editor Policy (History Protection)
*   **Law**: **Direct INSERT/UPDATE/DELETE** or **DDL** via Supabase Dashboard SQL Editor is **Strictly Prohibited** (No History).
*   **Action**:
    1.  Create local migration `supabase migration new fix`, deploy via Git.
    2.  Restrict SQL Editor to Read-only usage (Query Debugging).

---

## 8. Maintenance & Hardening
