# 37. バックエンド・データ戦略: Supabase (PostgreSQL)

### Rule 12.1: The Admin Write Service Role Protocol（管理者書き込みのService Role使用義務）
*   **Law**: 管理画面やバックグラウンドジョブからのDB書き込み操作は、ユーザー認証セッションに依存しない**特権クライアント（Service Role Key）**を使用しなければなりません。通常クライアント（ユーザーセッション経由）での管理者書き込みは、RLSポリシーによりサイレントに拒否される危険があります。
*   **Action**:
    1.  **Admin Write**: 管理画面からの全書き込み操作（INSERT/UPDATE/DELETE）は、RLSをバイパス可能な特権クライアントを使用してください。
    2.  **System Job**: Cron、Webhook、バッチ処理等のバックグラウンドジョブも同様に特権クライアントを使用してください（ユーザーセッションが存在しないため）。
    3.  **Principle of Least Privilege**: 特権クライアントの使用はサーバーサイドに限定し、クライアントサイドコードでService Role Keyを使用することは**厳禁**です。
    4.  **Audit Trail**: 特権クライアント経由の操作は、RLSをバイパスしているため、アプリケーション層で明示的に監査ログを記録してください。
*   **Rationale**: Server Action等のサーバー実行コードでも、フレームワークのセッション管理の仕組みによっては認証情報が正しく渡らず、RLSが意図せず操作を拒否するケースがあります。管理者操作が「エラーなし・影響0行」で終了する「サイレント失敗」は、最も発見困難なバグです。

### Rule 12.2: The Idempotent Migration Protocol（冪等マイグレーション義務）
*   **Law**: データベースマイグレーションファイルは、**何度実行しても同じ結果になる（冪等性）**ことを保証しなければなりません。CI環境、プレビュー環境、本番環境でマイグレーションが部分実行される可能性を常に想定してください。
*   **Action**:
    1.  **CREATE OR REPLACE**: 関数（Function）やビュー（View）の作成・更新には `CREATE OR REPLACE` を使用し、`ALTER` ではなく宣言的な定義を推奨してください。
    2.  **IF NOT EXISTS**: テーブルやインデックスの作成には `CREATE TABLE IF NOT EXISTS`, `CREATE INDEX IF NOT EXISTS` を使用してください。
    3.  **DROP IF EXISTS + CREATE**: ポリシーやトリガーなど `CREATE OR REPLACE` が使用できないオブジェクトは、`DROP ... IF EXISTS` → `CREATE` のパターンを使用してください。
    4.  **Defensive DML**: シードデータの挿入には `INSERT ... ON CONFLICT DO NOTHING`（または `DO UPDATE`）を使用し、重複挿入エラーを防いでください。
*   **Rationale**: CI環境は空のDBでマイグレーションを適用するため常に冪等ですが、プレビュー環境や手動復旧時には過去のマイグレーションが部分的に適用されている場合があります。冪等でないマイグレーションはこれらの環境でデプロイ障害を引き起こします。

### Rule 12.3: The Anti-Permissive Policy Duplication Mandate（冗長ポリシー禁止義務）
*   **Law**: RLS（Row Level Security）のポリシー設計において、同一ロール・同一アクションに対する**冗長なPermissiveポリシーの作成を禁止**します。特に `service_role` はRLSをバイパスするため、管理者用の別途ポリシーは不要です。
*   **Action**:
    1.  **One Policy Per Role-Action**: 同一テーブルに対し、同一ロール（`authenticated`, `anon` 等）の同一アクション（`SELECT`, `INSERT` 等）で複数の Permissive ポリシーを作成しないでください。複数条件がある場合は `OR` で1つのポリシーにまとめます。
    2.  **No service_role Policy**: `service_role` はRLSを完全にバイパスするため、`service_role` 用のRLSポリシーを作成することは冗長であり禁止します。
    3.  **Policy Audit**: 既存ポリシーの追加・変更時は、同一テーブルの全ポリシーを一覧し、論理的な重複がないか確認してください。
*   **Rationale**: PostgreSQL の Permissive ポリシーは `OR` で結合されるため、意図せず広い範囲を許可してしまうリスクがあります。1ロール1アクション1ポリシーの原則により、権限の意図を明確にし、セキュリティホールを防ぎます。

### Rule 12.3.1: The RLS Auth Function InitPlan Optimization（RLS認証関数InitPlan最適化）
*   **Law**: RLSポリシー内で `auth.uid()`, `auth.role()`, `current_setting()` 等の認証関数を使用する際、必ず **`(select ...)`でラップ** し、各行での再評価を防がなければなりません。
*   **Action**:
    1.  **Subquery Wrap**: `USING (user_id = auth.uid())` ではなく `USING (user_id = (select auth.uid()))` と記述してください。
    2.  **All Auth Functions**: `auth.uid()`, `auth.role()`, `auth.jwt()`, `current_setting()` 等、セッション情報を返す全ての関数に適用してください。
    3.  **EXISTS内も同様**: `EXISTS (SELECT 1 FROM ... WHERE ... = auth.uid())` も、内部の `auth.uid()` を `(select auth.uid())` にラップしてください。
*   **Rationale**: ラップなしの場合、PostgreSQLは各行のスキャンごとにこれらの関数を再評価します（Volatile扱い）。`(select ...)`でラップすることで、PostgreSQLのオプティマイザは結果を**InitPlan（事前計算）**として1回だけ評価し、大規模テーブルでの劇的なパフォーマンス改善を実現します。
*   **Anti-Pattern**:
    ```sql
    -- ❌ 禁止: 各行で auth.uid() が再評価される
    USING (user_id = auth.uid())
    ```
*   **Correct Pattern**:
    ```sql
    -- ✅ 正解: InitPlanにより1回だけ評価
    USING (user_id = (select auth.uid()))
    ```

### Rule 12.4: The Type Extension Safety Protocol（型拡張安全プロトコル）
*   **Law**: データベースSDKやORM等が自動生成する型定義を、アプリケーション固有の型で拡張する際には、型の安全性を損なわない手法を用いなければなりません。
*   **Action**:
    1.  **No `never` in Type Extensions**: 自動生成型のプロパティを `never` で上書きする型拡張を禁止します。`never` は「到達不能」を意味するため、実行時にはプロパティが存在するにも関わらず型レベルではアクセス不能となる「Poison Row」を引き起こします。
    2.  **Type Alias over Interface**: 自動生成型の拡張には `interface extends` よりも `type` エイリアスと交差型（`&`）を優先してください。Interface の `extends` は宣言マージ（Declaration Merging）による意図しない汚染のリスクがあります。
    3.  **Simple Intersection over Omit**: `Omit<GeneratedType, 'key1' | 'key2' | ...>` の多用は型の可読性を著しく低下させます。可能な限り単純な交差型で拡張し、`Omit` はプロパティの型を変更する場合にのみ使用してください。
    4.  **Generated Type Sovereignty**: 自動生成型のファイル自体を手動で編集することは厳に禁止します。拡張は常に別ファイルで行ってください。
*   **Rationale**: 自動生成型は「DBスキーマの真実」を反映する重要な資産です。不適切な拡張はこの真実を歪め、型定義と実データの乖離を引き起こします。

### Rule 12.5: The Migration System Schema Exclusion Protocol（マイグレーション・システムスキーマ除外プロトコル）
*   **Law**: データベースマイグレーションにおいて、関数のセキュリティ設定（`search_path`、`SECURITY DEFINER/INVOKER`等）を一括変更するスクリプトを作成する際、**マネージドサービスが管理するシステムスキーマの関数は除外リストに含める**ことを義務付けます。
*   **Action**:
    1.  **Exclusion List**: `auth`, `storage`, `realtime`, `supabase_functions`, `graphql`, `graphql_public`, `pgsodium`, `vault`, `extensions` などのシステムスキーマの関数は、一括変更の対象から明示的に除外してください。
    2.  **Schema Filter**: マイグレーションスクリプトの `WHERE` 句で `n.nspname NOT IN ('auth', 'storage', ...)` を使用し、システムスキーマの関数への干渉を物理的に防止してください。
    3.  **Dry Run**: 一括変更マイグレーションを適用する前に、対象となる関数の一覧をプレビュー（`SELECT` のみ実行）し、システム関数が含まれていないことを確認してください。
*   **Rationale**: マネージドサービスのシステム関数（認証、ストレージ管理等）の `search_path` やセキュリティ設定を変更すると、サービスの基盤機能が破壊される可能性があります。これは即座にサービス全停止につながる致命的な障害です。

### Rule 12.6: The RLS InitPlan Optimization Protocol（RLS InitPlan最適化義務）
*   **Law**: RLS（Row Level Security）ポリシー内での `auth.uid()`、`auth.role()` 等のセッション関数呼び出しは、**`(SELECT auth.uid())` のようにサブクエリ（Sub-Select）として記述**しなければなりません。
*   **Action**:
    1.  **Sub-Select Wrapping**: RLSポリシーの `USING` 句や `WITH CHECK` 句で `auth.uid()` を使用する場合、必ず `(SELECT auth.uid())` の形式にしてください。これにより、PostgreSQLのクエリプランナが関数を一度だけ評価してその結果をInitPlanとしてキャッシュし、行ごとの再評価を防止します。
    2.  **All Auth Functions**: `auth.uid()` だけでなく、`auth.role()`、`auth.jwt()` 等の全てのセッション関数に同じパターンを適用してください。
    3.  **Linter Integration**: Supabaseのセキュリティリンター等が `auth_rls_initplan` 警告を出す場合は、即座に修正してください。
    4.  **Performance Impact**: 大規模テーブル（数万行以上）では、このパターンの適用で数十倍のパフォーマンス差が生じる場合があります。
*   **Rationale**: RLSポリシー内の関数が行ごとに再評価されると、テーブルスキャンのたびにO(N)回の関数呼び出しが発生します。サブクエリ化によりO(1)に削減され、大規模テーブルでのクエリパフォーマンスが劇的に向上します。
