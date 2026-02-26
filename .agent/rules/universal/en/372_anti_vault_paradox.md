# 37. Backend Engineering (Supabase & PostgreSQL)

### Rule 3.5: Public Read Protocol (Anti-Vault Paradox)
*   **Principle**: "Security" does not mean dysfunction.
*   **Law**:
    1.  **Public Read**: Data with no reason to be private (Public Articles, Store Info) should be aggressively opened via `FOR SELECT USING (true)`.
    2.  **Strict Write**: Writes (`INSERT/UPDATE/DELETE`) remain strictly locked.
    3.  **Separation**: Do not confuse Read and Write permissions; do not block Read just to protect Write.

---

## 4. Performance & Scalability
