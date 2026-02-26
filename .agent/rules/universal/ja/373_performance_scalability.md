# 37. バックエンド・データ戦略: Supabase (PostgreSQL)

## 4. パフォーマンスとスケーラビリティ (Performance & Scalability)

### Rule 4.1: Indexing Hygiene Protocol
*   **FK Indexing**: 外部キー (FK) には**必ず**インデックスを作成します（JOIN最適化）。インデックスなきFKは「パフォーマンスの負債」です。
*   **Naming Convention**: `idx_<table_name>_<column_name>` 形式で統一（例: `idx_posts_user_id`）。
*   **Unused Purge**: 
    1. 定期的に `unused_index` 警告を確認し、読み取り負荷の軽減に貢献していない「死んだインデックス」は、書き込みパフォーマンス向上のために即座に削除せよ。
    2. ただし、開発初期や小規模データ時に「現在未使用」という理由だけで削除しないこと。インデックスは「冬用の備え」であり、データ増加を待って判断せよ。

### Rule 4.2: Japanese Search Optimization
*   日本語全文検索には `pg_search` (tsvector) または `pgroonga` を使用します。

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
