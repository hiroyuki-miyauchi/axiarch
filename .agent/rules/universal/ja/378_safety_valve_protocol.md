# 37. バックエンド・データ戦略: Supabase (PostgreSQL)

### Rule 2.12: The Safety Valve Protocol（安全弁カラム義務）
*   **Law**: 主要なエンティティテーブル（ユーザー、コンテンツ、商品、店舗等）には、スキーマ変更を必要とせずにイレギュラー情報を記録できる**自由記述カラム**（`notes`, `remarks`, `internal_memo` 等）を必ず1つ以上設置しなければなりません。
*   **Action**:
    1.  **Escape Hatch**: 現実の運用では、厳格なスキーマだけでは表現しきれない例外（「冬季閉鎖」「要電話確認」「特別対応あり」等）が頻繁に発生します。自由記述カラムは、スキーマ変更を待たずにこれらの情報を記録する「安全弁（Escape Hatch）」として機能します。
    2.  **Type**: `TEXT` 型（またはMarkdown対応が必要な場合は `TEXT`）を推奨します。`VARCHAR(n)` の文字数制限は運用時の障害要因となるため、特段の理由がない限り避けてください。
    3.  **Nullable**: 自由記述カラムは `NULL` を許容してください。全レコードに記述が必要な性質のものではありません。
    4.  **No Business Logic**: 自由記述カラムの値にビジネスロジック（条件分岐、フィルタリング）を依存させることを禁止します。ロジックに必要な情報は正規化カラムとして昇格させてください。
*   **Rationale**: スキーマ変更にはマイグレーション・デプロイ・テストのサイクルが必要であり、即座に対応できません。安全弁カラムの設置により、「今すぐ記録する必要がある」情報をロスなく保存でき、運用の柔軟性と開発速度の両立を実現します。

### Rule 2.13: The Time-Series Partitioning & Retention Protocol（時系列パーティション＆保持期間戦略）
*   **Law**: ログデータ（`audit_logs`, `access_logs`）やトランザクション履歴（`point_transactions` 等）など、時系列で肥大化するテーブルには、`created_at` をキーとした**Range Partitioning**を設計しなければなりません。
*   **Action**:
    1.  **Range Partitioning**: 時系列テーブルは `pg_partman` 等を使用し、月次または四半期でパーティションを自動作成してください。単一テーブルのレコード数が1,000万件（10M）を超える予測で導入を検討します。
    2.  **Retention Policy**: 古いパーティション（例: 2年以上前）は自動的に**Detached Partition**とし、アクティブなクエリ対象から除外してください。Detach後はCold Storageへの移動またはObject Storageへのエクスポートを計画します。
    3.  **No Premature Partitioning**: データが少ない開発フェーズでのパーティション導入は過剰設計です。閾値（10M件）に達する前に設計を完了し、達した時点で適用する「Ready-to-Fire」戦略を採用してください。
*   **Rationale**: パーティションなしで肥大化したテーブルは、インデックスサイズの増大、バキューム時間の延長、バックアップ時間の増加を引き起こします。時系列パーティションにより、古いデータの運用負荷をゼロに近づけつつ、法的保管義務への対応も可能になります。

### Rule 2.14: The Cold Data Offloading Protocol（アーカイブ戦略）
*   **Law**: 「1年以上アクセスがない」「法的保管義務があるが参照頻度が低い」データは、アクティブなDBから切り離し、**Archived Tables**またはObject Storage（CSV/Parquet）へ退避させなければなりません。
*   **Action**:
    1.  **Archived Tables**: アーカイブ用スキーマ（例: `archives`）を用意し、古いデータを移動してください（例: `archives.old_audit_logs`）。アプリケーションの通常クエリはこのスキーマを参照しません。
    2.  **Object Storage Export**: 大量の古いデータは、CSVまたはParquet形式でObject Storage（S3/R2/GCS等）にエクスポートしてください。分析が必要な場合はData Warehouse（BigQuery等）から参照します。
    3.  **Transparent Migration**: データの退避は、アプリケーションの動作に一切影響を与えない形で実行してください。アーカイブ対象のレコードがAPI応答に含まれないことを確認します。
    4.  **Compliance**: 法的保管義務（税法：7年、労働法：3年等）のあるデータは、保管期間が経過するまで物理削除してはなりません。アーカイブ先で保管期間を管理してください。
*   **Rationale**: アクティブDBに古いデータを残し続けると、インデックスサイズの膨張、クエリパフォーマンスの低下、バックアップ時間の増加を招きます。データの「温度」で保管先を分けることにより、アクティブデータのパフォーマンスとコスト効率を最大化します。

### Rule 2.15: The RLS Inheritance Protocol（権限継承・Chain of Trust）
*   **Law**: 子テーブル・孫テーブル（例: 医療記録、コメント、添付ファイル等）のアクセス権限は、**単独で定義せず**、必ず親テーブル（例: ペット、投稿、プロジェクト等）の所有権や参加状況を `EXISTS` サブクエリで参照して決定しなければなりません。
*   **Action**:
    1.  **Parent Ownership Check**: 子テーブルのRLSポリシーでは、直接 `auth.uid() = user_id` で認証するのではなく、親テーブルの所有権を `EXISTS (SELECT 1 FROM parent_table WHERE id = child_table.parent_id AND user_id = (select auth.uid()))` で検証してください。
    2.  **Chain of Trust**: テーブル階層が3段階以上（祖父→親→子）になる場合も、常に最上位の所有権まで遡って検証してください。中間テーブルだけの検証はセキュリティホールを生みます。
    3.  **SECURITY DEFINER for Cross-Table**: 権限チェックで他テーブル（`profiles` 等）を参照する必要がある場合は、`SECURITY DEFINER` 関数内でラップし、`search_path` を固定（`SET search_path = public, pg_temp`）してください。
    4.  **No Redundant Columns**: 子テーブルに `user_id` を重複して持たせることで権限チェックを「簡略化」するアプローチは、データ不整合の温床となるため非推奨です。権限は常に関係（Relation）で導出してください。
*   **Rationale**: 子テーブルごとに独立した権限ロジックを定義すると、親テーブルの権限変更時に子テーブルの更新漏れが発生し、セキュリティホールの原因となります。親テーブルの所有権を信頼の連鎖（Chain of Trust）として継承することで、権限ロジックの一元化と不整合の排除を実現します。

### Rule 2.16: The Brittle Table Reference Prohibition（動的テーブル参照禁止）
*   **Law**: SQL関数（`CREATE FUNCTION`）やRPC内で、テーブル名を動的な文字列として結合（`EXECUTE 'SELECT * FROM ' || table_name`）することを**禁止**します。
*   **Action**:
    1.  **Static References Only**: すべてのSQL関数内のテーブル参照は、静的なSQL文として記述してください。コンパイル時（またはマイグレーション適用時）に依存関係が解決されなければなりません。
    2.  **No Dynamic EXECUTE**: `EXECUTE format('SELECT * FROM %I', variable)` のようなパターンは、テーブル名のタイポや存在しないテーブルへの参照をランタイムまで検出できないため禁止します。
    3.  **Schema Change Safety**: 静的なテーブル参照により、テーブルのリネームや削除時に依存関数がマイグレーション時点でエラーとなり、問題を早期検出できます。
*   **Rationale**: 動的テーブル参照はSQLインジェクションの温床となり、スキーマ変更時の影響範囲追跡も不可能にします。静的参照を義務付けることで、コンパイル時安全性と保守性を確保します。
