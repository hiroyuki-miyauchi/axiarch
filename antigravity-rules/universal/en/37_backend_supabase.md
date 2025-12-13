# 37. Backend Engineering - Supabase & PostgreSQL

## 1. Database Design (PostgreSQL)
*   **Data Integrity & Ownership**:
    *   **Strict RLS**: Row Level Security (RLS) is absolute. The use of `service_role` keys is prohibited except for batch processing, and all queries must go through RLS in principle.
    *   **Explicit Ownership**: Always define a `user_id` column (or appropriate owner column) when creating tables, and verify `auth.uid() = user_id` in RLS policies. "Publicly readable" tables are not allowed except for Master Data.
*   **Type Safety**:
    *   **Database Types**: Use `supabase gen types` command to auto-generate TypeScript definitions (`database.types.ts`) from the DB schema and enforce their use throughout the application. Manual type definition is prohibited.

## 2. Performance & Scalability
*   **Infinite Scalability**:
    *   **No Select All**: `select('*')` is prohibited except during prototyping. Explicitly select only necessary columns in production code.
    *   **Pagination**: Executing unlimited queries on the client side is **strictly prohibited**. Always assume data growth and implement pagination or infinite scroll using `limit` and `range`.
*   **Index Strategy**:
    *   Always creates indexes on Foreign Keys and columns used for search/filtering strategies.

## 3. Auth & Security
*   **Supabase Auth**:
    *   Delegate the authentication flow entirely to Supabase Auth (Gotrue). Self-implemented password hashing or session management is prohibited.
*   **Automation via Triggers**:
    *   Operations like copying to `public.users` table upon user creation must be executed atomically at the DB layer using PostgreSQL Triggers, not on the application side, to prevent data inconsistency.
