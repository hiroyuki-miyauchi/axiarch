# 37. バックエンドエンジニアリング (Backend Engineering - Supabase & PostgreSQL)

## 1. データベース設計 (Database Design - PostgreSQL)
*   **整合性と所有権 (Data Integrity & Ownership)**:
    *   **RLSの絶対遵守**: 行レベルセキュリティ（Row Level Security - RLS）は絶対です。`service_role` キーの使用はバッチ処理などの例外を除き禁止し、原則として全てのクエリはRLSを経由させます。
    *   **明示的な所有権**: テーブル作成時には必ず `user_id` カラム（または適切な所有者カラム）を定義し、RLSポリシーで `auth.uid() = user_id` を検証します。「誰でも読込可能」なテーブルはマスターデータ以外認められません。
*   **Type Safety**:
    *   **Database Types**: `supabase gen types` コマンドを使用して、DBスキーマからTypeScript型定義（`database.types.ts`）を自動生成し、これをアプリケーション全体で使用します。手動での型定義は禁止です。

## 2. パフォーマンスとスケーラビリティ (Performance & Scalability)
*   **無限のスケーラビリティ (Infinite Scalability)**:
    *   **Select All 禁止**: `select('*')` はプロトタイピング時以外禁止です。本番コードでは必要なカラムのみを明示的に指定します。
    *   **Pagination**: クライアントサイドで上限（Limit）のないクエリを実行することは**厳禁**です。データ量は常に増加することを前提とし、必ずページネーションまたは無限スクロールを実装します。
*   **インデックス戦略**:
    *   外部キー（Foreign Key）のカラム、および検索・フィルタリングに使用されるカラムには、必ずインデックスを貼ります。

## 3. 認証とセキュリティ (Auth & Security)
*   **Gotrue**:
    *   認証フローはSupabase Auth (Gotrue) に完全に委任します。自前でのパスワードハッシュ化やセッション管理は禁止です。
*   **Triggerによる自動化**:
    *   ユーザー作成時の `public.users` テーブルへのコピーなどは、アプリケーション側ではなく、PostgreSQLのTrigger機能を使用してDB層でアトミックに実行します。データ不整合を防ぐためです。
