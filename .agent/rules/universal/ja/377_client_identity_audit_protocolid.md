# 37. バックエンド・データ戦略: Supabase (PostgreSQL)

### Rule 12.7: The Client Identity Audit Protocol（クライアントIDコンテキスト監査義務）
*   **Law**: RLSポリシーの最適化（統合・削除）を行う前に、対象データにアクセスする**全ての経路**（Server Action、API Route、SSR、管理画面等）が**どのIDENTITY**（`service_role` / User JWT / Anonymous）を使用しているかを**網羅的に監査**しなければなりません。
*   **Action**:
    1.  **Access Path Inventory**: 対象テーブルにアクセスする全てのコードパス（Service層、Gateway層、Server Action等）をリストアップし、それぞれが使用するクライアント初期化関数（`createClient`, `createAdminClient` 等）を特定してください。
    2.  **No Blind Optimization**: 「`service_role` で十分だから」という理由でユーザーJWT向けのポリシーを削除しないでください。Server Action等がユーザーJWTを使用している場合、そのポリシーの削除は正規アクセスのサイレントな遮断を引き起こします。
    3.  **Identity Matrix**: 複雑なテーブルに対しては、「テーブル × 操作 × 使用IDENTITY」のマトリクスを作成し、全てのアクセスパターンが少なくとも1つのRLSポリシーでカバーされていることを確認してください。
    4.  **Post-Change Verification**: ポリシーを変更・削除した後は、影響を受ける全てのUIフロー（管理画面の編集・保存、ユーザー向けの閲覧等）を実際に操作して動作を確認してください。
*   **Rationale**: RLSポリシーの「最適化」による不用意な削除は、セキュリティホールではなく「正規アクセスの不可視化」を招きます。特に管理画面がServer Action（ユーザーJWTコンテキスト）を使用している場合、service_roleで十分だと思ってJWT向けポリシーを削除すると、管理者のCRUD操作がサイレントに拒否されます。

### Rule 2.8: The Idempotent Migration Protocol（冪等マイグレーション義務）
*   **Law**: マイグレーションファイルは、何度実行しても同じ結果を生む**冪等な構造**で記述しなければなりません。DML（データ操作）を含む場合は、本番データとの衝突を想定した防衛的コードで記述してください。
*   **Action**:
    1.  **DDL Idempotency**: `CREATE TABLE` は `IF NOT EXISTS`、`DROP TABLE` は `IF EXISTS`、`ALTER TABLE ADD COLUMN` は `IF NOT EXISTS`（PostgreSQL 9.6+）を必ず付与してください。
    2.  **DML Idempotency**: `INSERT` は `ON CONFLICT DO NOTHING` または `ON CONFLICT DO UPDATE` を使用し、既存データとの重複時にエラーにならないようにしてください。
    3.  **Function/Trigger Idempotency**: `CREATE OR REPLACE FUNCTION` を使用し、関数の再作成が安全に行えるようにしてください。トリガーは `DROP TRIGGER IF EXISTS ... ; CREATE TRIGGER ...` のパターンで記述してください。
    4.  **RLS Policy Idempotency**: ポリシーの作成前に `DROP POLICY IF EXISTS "policy_name" ON table_name;` を実行し、既存ポリシーとの衝突を防止してください。
*   **Rationale**: マイグレーションの非冪等性は、ステージング環境と本番環境の差異、マイグレーションの再実行、ブランチ間の競合時に「一度通ったはずのマイグレーションが壊れる」致命的な障害を引き起こします。冪等性は、安全なデプロイと環境再現性の基盤です。

### Rule 2.9: The Read-Write Privilege Symmetry（読み書き権限の対称性）
*   **Law**: 管理画面等において、書き込み（Mutation）が特権クライアント（`service_role` 等）で実行される場合、**読み込み（Query for Edit Form）も同等の可視性を保証**しなければなりません。書き込みと読み込みで異なる権限レベルのクライアントを使用すると、「保存は成功するがリロードすると元に戻る」という不透明なバグが発生します。
*   **Action**:
    1.  **Privilege Parity Check**: 書き込みに `createAdminClient()`（RLSバイパス）を使用している場合、対応する「編集のための取得」も同等の権限で実行されるか確認してください。読み込みが `anon` や制限された `authenticated` 権限で行われると、RLSにより一部のデータがフィルタされ、フォームに古いデータや空データが流し込まれます。
    2.  **Select Spec Synchronization**: DTOで使用する Select Specification が、保存対象の全カラムを包含しているか確認してください。片方にだけカラムを追加すると、「保存はされるが編集画面に表示されない」片肺状態になります。
    3.  **Admin Gateway Awareness**: 管理目的が明示的な関数（例: `getAdminStoreById`）では、必要に応じて特権クライアントを使用するか、RLSポリシーを管理ロールに対して完全に開放してください。
    4.  **Post-Update Verification**: 重要度の高いミューテーション（画像の並び替え、ステータス変更等）では、更新直後に同じIDで `select` を実行し、現在値をログで確認する「Verification Fetch」パターンの適用を検討してください。
*   **Rationale**: 特権クライアントによる書き込みは RLS をバイパスしてデータを正しく保存しますが、編集画面の再読み込み時に非特権クライアントが使用されると、RLS の `SELECT` ポリシーにより一部のカラムやレコードが除外されます。結果として、ユーザーは「保存したのに反映されない」と感じ、同じ操作を繰り返すことでデータの不整合がさらに拡大する悪循環に陥ります。

### Rule 2.10: The RLS Policy Consolidation Mandate（RLSポリシー統合義務）
*   **Law**: 同一テーブル・同一操作（SELECT, INSERT, UPDATE, DELETE）に対して、複数の `PERMISSIVE` ポリシーが定義されている場合、評価オーバーヘッドを削減するため、可能な限り**単一のポリシーにOR条件で統合**しなければなりません。
*   **Action**:
    1.  **Consolidation by Operation**: `anon` 向けと `authenticated` 向けに別々の `SELECT` ポリシーを定義するのではなく、`USING (true)` や `USING (auth.role() IN ('anon', 'authenticated'))` のように単一ポリシーに統合してください。PostgreSQLは全ての `PERMISSIVE` ポリシーをOR結合で評価するため、個別ポリシーの分割は評価回数を不必要に増加させます。
    2.  **Service Role Redundancy Elimination**: `service_role` はRLSを完全にバイパスするため、`service_role` 向けの明示的なポリシーは冗長です。`service_role` のみを対象としたポリシーが存在する場合は削除してください。
    3.  **RESTRICTIVE Policy Awareness**: `RESTRICTIVE` ポリシーは全ての `PERMISSIVE` ポリシーの**AND条件**として評価されるため、統合対象は `PERMISSIVE` ポリシーのみです。`RESTRICTIVE` ポリシーの統合は副作用を引き起こす可能性があります。
    4.  **New Table Checklist**: 新規テーブル作成時のRLSポリシー設計では、「操作ごとに最小数のポリシー」を設計原則としてください。同一操作に2つ以上のポリシーを作成する場合は、統合不可能な理由を明示的にコメントしてください。
*   **Rationale**: PostgreSQLは同一操作に対する全ての `PERMISSIVE` ポリシーをOR結合で評価するため、機能的に同等の条件を複数のポリシーに分割しても結果は変わりませんが、評価のオーバーヘッドが増加します。特に大量のレコードを持つテーブルでは、不要なポリシーの分割がクエリパフォーマンスに直接影響します。

### Rule 2.11: The Orphan File Defense Protocol（孤立ファイル防衛）
*   **Law**: データベースレコードの削除時に、関連するストレージ上のファイルを放置する（Orphan Files）ことを禁止します。孤立ファイルはストレージコストを継続的に増大させ、意図しない情報残存のリスクを生みます。
*   **Action**:
    1.  **Cascade Deletion**: `DELETE` トリガー、またはアプリケーションのミューテーションロジック内で、DBレコード削除時に関連するストレージファイルも**非同期で削除**する処理を組み込んでください。同期的な削除はレスポンスタイムに影響するため、非同期ジョブ（Queue/Worker）を推奨します。
    2.  **Batch Cleanup**: 定期的（例: 週次）にバッチジョブを実行し、DBに参照が存在しないストレージファイル（孤立ファイル）を検出・削除するスイーパーを設置してください。
    3.  **Soft Delete Awareness**: 論理削除（`deleted_at`）を採用している場合、ファイル削除はレコードの物理削除時（またはアーカイブ移行時）まで遅延させてください。論理削除時点でファイルを消すと、復元時にファイルが失われます。
*   **Rationale**: レコードのみ削除してファイルを放置する運用は、ストレージコストの「サイレントリーク」を引き起こします。特にUGC（ユーザー生成コンテンツ）が多いサービスでは、月単位で数十GBの孤立ファイルが蓄積し、FinOps上の重大な損失となります。
