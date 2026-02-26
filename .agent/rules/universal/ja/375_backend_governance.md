# 37. バックエンド・データ戦略: Supabase (PostgreSQL)

## 11. バックエンド・ガバナンス (Backend Governance)

### Rule 11.1: The Data Residency Protocol (Rule 26.1)
*   **Law**: 特定の個人情報（PII）や法的文書は、準拠法（GDPR/APPI等）に基づき、特定のリージョン（例: 日本国内）に物理的に存在することを保証しなければならない場合があります。
*   **Action**: ストレージバケットやDBインスタンスのリージョン設計時に、将来の「データローカライゼーション要件」を考慮した構成（Multi-region Read/Local Write）を検討し、文書化してください。

### Rule 11.2: The Audit Bypass Anti-Pattern (Server Action Mandate)
*   **Law**: クライアントサイドからの直接書き込みは、サーバーサイドの監査ログ（Audit Logs）や複雑なバリデーションをバイパスする「ガバナンスの穴」となります。
*   **Action**: 
    1. **Surgical Write**: 原則として書き込みは **Server Actions** に集約し、その内部で `recordAuditLog` を呼び出すことを義務付けます。
    2. **Exception Recognition**: 現実的な制約でクライアントから INSERT する場合は、DBトリガー (`AFTER INSERT`) に `recordAuditLog` 相当のロジックを実装し、物理的にバイパスを不可能にしてください。

### Rule 11.3: The RLS Best Practices Protocol (ポリシー衛生)
*   **Law 1: No Redundant Admin Policy**: `service_role` キーはRLSを完全にバイパスします。したがって、`TO service_role` のポリシーは**意味がなく冗長**です。管理者アクセスはアプリケーション層（`is_admin()` ヘルパー）で制御してください。
*   **Law 2: One Policy Per Action**: 同一テーブル、同一アクション（例: `SELECT`）に対して複数の `PERMISSIVE` ポリシーが存在する場合、PostgreSQLはそれらを `OR` で結合します。これは意図しないアクセス許可を生みます。**1テーブル、1アクションにつき、原則1ポリシー**を徹底してください。
*   **Law 3: No WITH CHECK (true)**: `WITH CHECK (true)` は「誰でも書き込み可能」を意味します。本番テーブルへの適用は厳禁です。必ず `auth.uid()` 等による所有権チェックか、管理者ロールチェックを含めてください。

### Rule 11.4: The Poison Row Prevention Protocol (型崩壊防止)
*   **Context**: 自動生成型 (`database.types.ts`) を拡張する際に、交差型 (`&`) で `Insert` / `Update` を `never` に設定すると、型推論が壊れ（Type Collapse）、正当なINSERT/UPDATE操作が型エラーで拒否されるようになります。
*   **Law**: 拡張型定義において、自動生成型の `Insert` / `Update` サブタイプを `never` で上書きすることを禁止します。
*   **Action**:
    1.  **Type Alias**: 拡張型は `interface` ではなく **`type` エイリアス** を使用してください（Mapped Typeとの互換性）。
    2.  **Intersection Safety**: 交差型で拡張する場合は、`Row` のみを対象にし、`Insert` / `Update` は元の型をそのまま継承させてください。
    3.  **Validation**: 拡張型を定義した後、必ず `supabase.from('table').insert({...})` がコンパイルを通ることを確認してください。

### Rule 11.5: The Idempotent Migration Protocol (冪等マイグレーション)
*   **Context**: マイグレーションは「クリーンルーム」（CIの新規DB）と「ダーティルーム」（既にデータが存在する本番DB）の両方で実行されます。両環境で成功することを保証する設計が必要です。
*   **Law**: マイグレーションファイルは、何度実行しても同じ結果になる**冪等性（Idempotency）**を持たなければなりません。
*   **Action**:
    *   **Functions**: `CREATE FUNCTION` ではなく `CREATE OR REPLACE FUNCTION` を使用してください。
    *   **Policies**: `CREATE POLICY` の前に `DROP POLICY IF EXISTS` を記述してください。
    *   **DML**: `INSERT` には `ON CONFLICT ... DO NOTHING` または `DO UPDATE` を付与し、既存データとの衝突を防いでください。
    *   **Tables/Indexes**: `IF NOT EXISTS` を必ず付与してください。
*   **Rationale**: CI/CDパイプラインでの再実行やロールバック後の再適用に対応するため。冪等でないマイグレーションは「爆弾」です。

### Rule 11.6: The Admin/System Write Service Role Mandate (管理者書き込みのService Role義務)
*   **Law**: 管理者（Admin）の書き込み操作（Create/Update/Delete）は、`anon` キー + Cookie セッション（`createClient()`）ではなく、**`serviceRoleKey`（`createAdminClient()`）を使用**しなければなりません。
*   **Reason**:
    1.  Server Action経由でSupabaseを呼び出す際、セッション情報が正しく渡されない場合がある。
    2.  RLSが `UPDATE` を拒否しても**エラーを返さず0行更新（サイレント失敗）**になる。
    3.  管理者操作は業務都合上RLSの制約を超える必要があるケースが多い。
*   **Action**:
    1.  **Admin Write**: 管理画面からの全書き込み操作は `createAdminClient()` を使用してください。
    2.  **System Job**: Cron、Webhook等のバックグラウンドジョブも同様に `createAdminClient()` を使用してください（ユーザーセッションが存在しないため）。
    3.  **Read is OK**: 管理者の読み取り操作は `createClient()` でも問題ありませんが、一貫性のため `createAdminClient()` の使用を推奨します。

### Rule 11.7: The Silent RLS Failure Detection Protocol (RLSサイレント失敗検知)
*   **Law**: SupabaseのRLSポリシーにより操作が拒否された場合、PostgRESTは**エラーを返さずに「0行影響（affected rows = 0）」を返す**仕様です。これは「サイレント失敗」であり、最も検知困難なバグの原因です。
*   **Action**:
    1.  **Count Check**: UPDATE/DELETE操作後は、戻り値の `count` が `null` または `0` でないことを検証してください。`hasError: false` かつ `count: null` はRLS違反のシグナルです。
    2.  **Explicit Error**: `count === 0` の場合は、明示的なエラーを返すラッパー関数を実装してください（例: `throw new Error('RLS policy may have blocked this operation')`）。
    3.  **Logging**: サイレント失敗が疑われるケースではログに `{ operation, table, userId, affectedRows }` を記録し、後日の原因調査を可能にしてください。
*   **Diagnostic**: 「保存成功なのにリロードすると元に戻る」→ **RLSサイレント失敗を疑え**。

### Rule 11.8: The RPC Scope Limitation Protocol（RPCスコープ制限）
*   **Law**: DB側のRPC（PL/pgSQL関数）に複雑なビジネスロジック（条件分岐の連鎖、外部API呼び出しの模倣、複数エンティティにまたがるワークフロー）を押し込むことを**禁止**します。
*   **Action**:
    1.  **Atomic Operations Only**: RPCの用途は「アトミックなデータ操作」に限定してください。許可される用途: バルク更新（`UPDATE ... WHERE id = ANY(...)`）、システム権限チェック、集計クエリ、トランザクション内の複数テーブル同時操作。
    2.  **Application Layer Logic**: 条件分岐、ワークフロー制御、外部サービス連携、通知送信等のビジネスロジックは、アプリケーション層（Server Actions / TypeScript等）で記述してください。
    3.  **Debuggability**: PL/pgSQLは型安全性が低く、デバッグツールも限定的です。ロジックをアプリケーション層に保つことで、ブレークポイント設定・ログ出力・テスト記述が容易になります。
    4.  **DB Load Offloading**: 重い計算処理をDB側に押し込むと、DB接続プールを圧迫し、他のクエリの遅延を招きます。計算はアプリケーション層にオフロードしてください。
*   **Rationale**: RPCへのビジネスロジック集中は、デバッグ困難性・型安全性の欠如・DB負荷増大という三重のリスクを生みます。RPCは「DBが最も効率的に処理できる操作」に限定し、アプリケーション層との適切な責務分離を維持してください。

### Rule 11.9: The Ghost Migration Ban（ゴーストマイグレーション禁止）
*   **Law**: マイグレーションファイル化されていないDB操作（手動でのカラム追加・変更・削除、Dashboard上でのスキーマ変更等）を**「ゴーストマイグレーション」と定義し、厳禁**とします。
*   **Action**:
    1.  **Migration File Mandate**: すべてのスキーマ変更は、必ずマイグレーションツール（`supabase migration new` 等）を経由し、マイグレーションファイルとしてGitに保存されなければなりません。
    2.  **No Dashboard Edits**: DB管理画面（Supabase Dashboard、pgAdmin等）での直接的なスキーマ変更は、履歴追跡が不可能となるため禁止します。緊急対応であっても、事後に必ずマイグレーションファイルを作成してGitに反映してください。
    3.  **Schema Consistency Protocol**: ローカル環境のスキーマがマイグレーションファイルと乖離（汚染）した場合は、DB再構築（`supabase db reset` 等）を躊躇してはなりません。常にマイグレーションファイルをSource of Truth（正）として扱い、ローカルDBを従とします。
    4.  **Verification**: マイグレーション適用後は、ローカルスキーマとリモートスキーマの差分がゼロであることを確認してください。差分がある場合はゴーストマイグレーションの存在を疑います。
*   **Rationale**: マイグレーションファイルに記録されない変更は、チーム間での再現不能、CI/CD障害、本番環境との不整合を引き起こします。「全ての変更は記録される」という原則こそが、スキーマの信頼性を担保する唯一の方法です。
