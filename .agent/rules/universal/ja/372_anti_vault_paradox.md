# 37. バックエンド・データ戦略: Supabase (PostgreSQL)

### Rule 3.5: Public Read Protocol (Anti-Vault Paradox)
*   **Principle**: 「セキュリティ」とは機能不全にすることではない。
*   **Law**:
    1.  **Public Read**: 非公開にする理由がないデータ（公開記事、店舗情報、システム設定の公開キー）は `FOR SELECT USING (true)` で積極的に開放。
    2.  **Strict Write**: 書き込み（`INSERT/UPDATE/DELETE`）は引き続き厳格にロック。
    3.  **Separation**: 読み取り（SELECT）と書き込み（WRITE）の権限を混同し、「書き込みを守るついでに読み取りまで塞ぐ」愚を犯さないこと。

---
