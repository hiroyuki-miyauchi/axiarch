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

## 4. 運用とマイグレーション (Operations & Migration)
*   **マイグレーション運用規定 (Migration Protocol)**:
    *   **Remote Execution**: リモートデータベース（本番/Staging）へのスキーマ変更は、CLI (`db push`) の不安定さを回避するため、原則として **Supabase管理画面のSQLエディタ** でSQLを実行することを推奨します。
    *   **Version Control**: 実行したSQLは必ず `supabase/migrations/` にファイルとして保存し、Git管理します。「誰がいつ何を実行したか」を追跡可能にします。
*   **型安全性プロトコル (Type Safety Protocol)**:
    *   **Internal Casting**: 複雑なJOINやViewに対してSupabaseクライアントの型推論が効かない（`never`等になる）場合に限り、クエリビルダ呼び出し箇所での `as any` キャストと、その直後の「明示的な型定義へのキャスト」を許可します（Internal Casting Pattern）。
    *   **Restriction**: この例外処理以外での `any` の使用は引き続き厳禁です。
