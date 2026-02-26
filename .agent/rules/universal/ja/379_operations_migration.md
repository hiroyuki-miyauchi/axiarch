# 37. バックエンド・データ戦略: Supabase (PostgreSQL)

### Rule 4.3: Scalability Strategy
*   **Infinite Scalability**: `select('*')` および上限なしクエリは禁止。必ずページネーションを実装。
*   **Partitioning**: テーブルレコード数が **1,000万件 (10M)** を超える予測で `pg_partman` を導入。
*   **Read Replica**: 分析クエリはReplicaへオフロード。
*   **Archival**: コールドデータはオブジェクトストレージへ退避。

---

## 5. 認証とセキュリティ (Auth & Security)
*   **Gotrue Delegation**: 認証はSupabase Authに完全委任。
*   **Notification Architecture**:
    *   **Aggregation**: 同一リソースへの重複アクション（例: 複数人のいいね）は、通知テーブルで「集約」し、通知爆撃を防ぎます。
    *   **Async Delivery**: メール送信等は非同期ジョブ (`pgmq`等) を経由させます。
    *   **The Smart Notification Control Protocol (Email Bomb Prevention)**:
        *   **Law**: メール通知は即時送信せず、ジョブキューを介して数分〜数十分遅延させてください。
        *   **Logic**: 送信直前に「アプリ内で既読になっているか」をチェックし、既読の場合はメール送信をスキップします。
        *   **Outcome**: 「既にアプリで確認した内容のメールが後から届く」というUX劣化を防ぎ、メール爆撃による離脱を回避します。

---

## 6. ストレージと配信 (Storage & Delivery)
*   **Cloudflare Proxy Shield**: 画像配信は必ずCloudflare経由。
*   **Bucket Separation**:
    *   **Public**: 店舗写真、アバター。CDNキャッシュ最大化。
    *   **Private**: 請求書、個人書類。**Signed URL** と厳格なRLSチェックが必須。
    *   **Ads**: 広告用バナーは別バケット (`bucket-ads`) に分離。
*   **User Upload Hygiene**: クライアントサイドでリサイズし、**GPS情報（EXIF）を削除**してからアップロード。
*   **The Signed Upload URL Mandate (Direct-to-Storage Pattern)**:
    *   **Law**: 大容量ファイル（画像、動画、ドキュメント）のアップロードにおいて、ファイルデータがアプリケーションサーバー（Vercel/Cloud Functions等）を経由することを禁止します。
    *   **Flow**:
        1. **Server Action**: 認証と権限チェックを行い、問題がなければStorageへの**Signed Upload URL**を発行してクライアントに返す。
        2. **Client Direct Upload**: クライアントから直接Storageへアップロードする。
    *   **Outcome**: アプリケーションサーバーのCPU/メモリ負荷を軽減し、Serverlessプラットフォームの転送量課金とタイムアウトリスクを回避します。

---

## 7. 運用とマイグレーション (Operations & Migration)

### Rule 7.1: The Migration Protocol (Ghost Table Defense)
*   **Remote Execution**: 本番スキーマ変更はDashboardのSQLエディタ等で行い、実行ログを `supabase/migrations` に保存してGit管理します。
*   **Migration Timestamp Hygiene**:
    *   **Context**: 手動作成ファイルのタイムスタンプが「未来」だと、自動生成ファイルの順序が狂います。
    *   **Action**: 必ず `ls supabase/migrations` で**最新の既存タイムスタンプ**を確認し、順序整合性を保ってください。
*   **Atomic Migration**: `DROP POLICY` と `CREATE POLICY` は同一ファイル内で完了させ、セキュリティ空白期間を作らないこと。
*   **Ghost Table Defense**: 
    *   **Law**: 存在しないテーブルへの `ALTER` や `CREATE POLICY` はマイグレーションエラー (`42P01`) を引き起こします。
    *   **Action (Table Existence Verification Protocol)**: 外部依存や古いスキーマダンプを参考にする際は、必ず `DO $$` ブロックを用いた条件付き実行（`IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = '...')`）を徹底してください。記憶や「あるはず」という思い込みでの実装を禁止します。
*   **Remote Schema Warning**: `remote_schema.sql` や生成ファイルは過去のスナップショットに過ぎません。SQL作成前は必ず現在のDB状態（Dashboard または `pg_tables` クエリ）を正として確認してください。

### Rule 7.2: IPv6 & CI/CD Protocol
*   **GitHub Actions**: ランナー環境でのIPv6接続エラーを防ぐため、`supabase link` (Connection Pooler) または `SUPABASE_DB_URL` 直接接続 (Plan C) を適切に使い分け、安定したデプロイ経路を確保してください。

### Rule 7.3: Data Seeding & Caching Determinism
*   **Seed Determinism**: 初期データ (`seed.sql`) は **固定ID・固定値** を使用し、決定論的なテスト状態を保証します。
*   **Cache Versioning**: マスターデータ等を `unstable_cache`等でキャッシュする場合、データの増減やスキーマ変更時に古いキャッシュが残る「Cache Rot」を防ぐため、キャッシュキーには必ずバージョンサフィックス（例: `master_data_v2`）を付与し、物理的に無効化する仕組みを設けてください。
*   **Verification**: シード実行後は、必ずアプリケーション経由またはクエリで実データ件数が期待通りか確認してください。CLIの「Up to date」はデータの存在を保証しません。

### Rule 7.4: Migration Idempotency Protocol
*   **Mandate**: マイグレーションは何度実行しても同じ結果になるよう設計すること。
*   **Implementation**:
    *   `CREATE TABLE IF NOT EXISTS`
    *   `DROP POLICY IF EXISTS` の後に `CREATE POLICY`
    *   `CREATE INDEX IF NOT EXISTS`
*   **Rationale**: CI/CDパイプラインでの再実行やロールバック後の再適用に対応。

### Rule 7.5: Cache Reload Protocol
*   **Context**: マイグレーション適用後、接続プールやORMのスキーマキャッシュが古い状態を保持する場合がある。
*   **Mandate**: 重大なスキーマ変更（カラム追加/削除、型変更）後は、以下を確認すること:
    1.  型定義ファイル（`database.types.ts` 等）の再生成
    2.  開発サーバーの再起動
    3.  本番環境でのサービス再起動またはコネクションプールのリフレッシュ

### Rule 7.6: The Zero SQL Editor Policy (History Protection)
*   **Law**: Supabase Dashboard の SQL Editor での **直接的な書き込み (INSERT/UPDATE/DELETE)** および **スキーマ変更 (DDL)** は、変更履歴が残らず、再現性が失われるため**完全禁止**です。
*   **Action**: 
    1. 修正や操作が必要な場合は、必ずローカルで `supabase migration new your_fix` を作成し、Git 経由でデプロイしてください。
    2. SQL Editor は、「現在値の確認」や「クエリのデバッグ」という参照専用（Read-only）として利用を制限してください。

---

## 8. 保守と堅牢化 (Maintenance & Hardening)

### Rule 11.5: The Idempotent Migration Protocol (冪等マイグレーション)
*   **Context**: マイグレーションは「クリーンルーム」（CIの新規DB）と「ダーティルーム」（既にデータが存在する本番DB）の両方で実行されます。両環境で成功することを保証する設計が必要です。
*   **Law**: マイグレーションファイルは、何度実行しても同じ結果になる**冪等性（Idempotency）**を持たなければなりません。
*   **Action**:
    *   **Functions**: `CREATE FUNCTION` ではなく `CREATE OR REPLACE FUNCTION` を使用してください。
    *   **Policies**: `CREATE POLICY` の前に `DROP POLICY IF EXISTS` を記述してください。
    *   **DML**: `INSERT` には `ON CONFLICT ... DO NOTHING` または `DO UPDATE` を付与し、既存データとの衝突を防いでください。
    *   **Tables/Indexes**: `IF NOT EXISTS` を必ず付与してください。
*   **Rationale**: CI/CDパイプラインでの再実行やロールバック後の再適用に対応するため。冪等でないマイグレーションは「爆弾」です。

### Rule 12.2: The Idempotent Migration Protocol（冪等マイグレーション義務）
*   **Law**: データベースマイグレーションファイルは、**何度実行しても同じ結果になる（冪等性）**ことを保証しなければなりません。CI環境、プレビュー環境、本番環境でマイグレーションが部分実行される可能性を常に想定してください。
*   **Action**:
    1.  **CREATE OR REPLACE**: 関数（Function）やビュー（View）の作成・更新には `CREATE OR REPLACE` を使用し、`ALTER` ではなく宣言的な定義を推奨してください。
    2.  **IF NOT EXISTS**: テーブルやインデックスの作成には `CREATE TABLE IF NOT EXISTS`, `CREATE INDEX IF NOT EXISTS` を使用してください。
    3.  **DROP IF EXISTS + CREATE**: ポリシーやトリガーなど `CREATE OR REPLACE` が使用できないオブジェクトは、`DROP ... IF EXISTS` → `CREATE` のパターンを使用してください。
    4.  **Defensive DML**: シードデータの挿入には `INSERT ... ON CONFLICT DO NOTHING`（または `DO UPDATE`）を使用し、重複挿入エラーを防いでください。
*   **Rationale**: CI環境は空のDBでマイグレーションを適用するため常に冪等ですが、プレビュー環境や手動復旧時には過去のマイグレーションが部分的に適用されている場合があります。冪等でないマイグレーションはこれらの環境でデプロイ障害を引き起こします。

### Rule 2.8: The Idempotent Migration Protocol（冪等マイグレーション義務）
*   **Law**: マイグレーションファイルは、何度実行しても同じ結果を生む**冪等な構造**で記述しなければなりません。DML（データ操作）を含む場合は、本番データとの衝突を想定した防衛的コードで記述してください。
*   **Action**:
    1.  **DDL Idempotency**: `CREATE TABLE` は `IF NOT EXISTS`、`DROP TABLE` は `IF EXISTS`、`ALTER TABLE ADD COLUMN` は `IF NOT EXISTS`（PostgreSQL 9.6+）を必ず付与してください。
    2.  **DML Idempotency**: `INSERT` は `ON CONFLICT DO NOTHING` または `ON CONFLICT DO UPDATE` を使用し、既存データとの重複時にエラーにならないようにしてください。
    3.  **Function/Trigger Idempotency**: `CREATE OR REPLACE FUNCTION` を使用し、関数の再作成が安全に行えるようにしてください。トリガーは `DROP TRIGGER IF EXISTS ... ; CREATE TRIGGER ...` のパターンで記述してください。
    4.  **RLS Policy Idempotency**: ポリシーの作成前に `DROP POLICY IF EXISTS "policy_name" ON table_name;` を実行し、既存ポリシーとの衝突を防止してください。
*   **Rationale**: マイグレーションの非冪等性は、ステージング環境と本番環境の差異、マイグレーションの再実行、ブランチ間の競合時に「一度通ったはずのマイグレーションが壊れる」致命的な障害を引き起こします。冪等性は、安全なデプロイと環境再現性の基盤です。
