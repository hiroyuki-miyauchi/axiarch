# 37. Backend Engineering (Supabase & PostgreSQL)

## 0. Data Sovereignty Law & Supreme Directives

### Rule 4.1: Indexing Hygiene Protocol
*   **FK Indexing**: **Always** index Foreign Keys (FK). FK without index is "Performance Debt".
*   **Naming Convention**: `idx_<table_name>_<column_name>`.
*   **Unused Purge**: Regularly check `unused_index` warnings. Delete dead indexes to improve write performance, but wait for data growth before judging.

### Rule 4.2: Japanese Search Optimization
*   Use `pg_search` (tsvector) or `pgroonga` for Japanese full-text search.
