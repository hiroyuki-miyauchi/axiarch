# 32. バックエンドエンジニアリング (Backend Engineering - Firebase & GCP)

## 1. サーバーレス・アーキテクチャ (Serverless Architecture)
*   **Cloud Functions (第2世代)**:
    *   **標準化**: 原則として **Cloud Functions (2nd Gen)** を使用し、並列処理（Concurrency）とコールドスタート対策を強化します。
    *   **単一責任 (Single Responsibility)**: 1つの関数は1つのタスクのみを実行します。巨大なモノリス関数（Monolithic Function）は禁止です。
*   **イベント駆動 (Event-Driven)**:
    *   **非同期処理**: ユーザーの待機時間を最小化するため、重い処理（メール送信、画像加工、集計）は **Cloud Pub/Sub** や **Eventarc** を使用して非同期に実行します。

## 2. データベース設計 (Database Design - Firestore)
*   **NoSQLモデリング (NoSQL Modeling)**:
    *   **Read最適化**: 書き込み（Write）よりも読み取り（Read）のパフォーマンスを優先して設計します。必要なデータは事前に非正規化（Denormalization）して保存します。
    *   **サブルコレクション**: ユーザーに紐づくデータ（注文履歴など）は、トップレベルではなくサブコレクションとして配置し、クエリの効率化とセキュリティ管理を容易にします。
*   **セキュリティルール (Security Rules)**:
    *   **テスト駆動**: Firestore Security Rulesは必ずユニットテストを書き、意図しないアクセス権限の漏洩を防ぎます。
    *   **最小権限**: デフォルトは `allow read, write: if false;` とし、必要なパスのみを明示的に許可します。
*   **データライフサイクル (Data Lifecycle)**:
    *   **TTL (Time-to-Live)**: 通知履歴、一時的なログ、監査ログなど、永続保存が不要なデータには必ず **Firestore TTLポリシー** を設定し、自動削除させます。Cloud Functionsでの定期削除バッチは（コスト高のため）禁止します。
    *   **Cloud Storage Lifecycle**: 古いバックアップや一時ファイルは、GCPのライフサイクル管理機能を使用して、一定期間後に自動的に削除またはColdline/Archiveクラスへ移動させます。

## 3. データ分析とエクスポート (Analytics & Export)
*   **BigQuery連携 (BigQuery Integration)**:
    *   **生データ (Raw Data)**: Firestoreのデータは **BigQuery Extension** を使用してリアルタイムに同期し、複雑な分析はBigQuery側で行います。アプリ側で集計クエリを走らせることは禁止です（コストとパフォーマンスのため）。
*   **エクスポート処理 (Export Processing)**:
    *   **バッチ処理**: CSVやPDFのエクスポートは、Cloud Functionsのメモリ制限を考慮し、**Stream処理** または **Cloud Run Jobs** で実行します。
    *   **署名付きURL**: 生成されたファイルは直接ダウンロードさせるのではなく、有効期限付きの **Signed URL** を発行して提供します。

## 4. 拡張性と信頼性 (Scalability & Reliability)
*   **冪等性 (Idempotency)**:
    *   **ルール**: 全てのバックグラウンド処理は、何度実行されても結果が変わらない「冪等（Idempotent）」な設計にします。
    *   **実装**: 処理済みIDを記録し、重複実行を防ぎます。
*   **デッドレターキュー (Dead Letter Queue)**:
    *   処理に失敗したメッセージは破棄せず、デッドレターキュー（DLQ）に送り、後で調査・再処理できるようにします。

## 5. 監視とログ (Monitoring & Logging)
*   **構造化ログ (Structured Logging)**:
    *   ログは単なるテキストではなく、JSON形式で出力し、Cloud Loggingでクエリ可能にします（例: `jsonPayload.userId` で検索可能にする）。
*   **アラート (Alerting)**:
    *   エラー率が **1%** を超えた場合、または関数の実行時間が閾値を超えた場合に、即座にSlackへ通知します。
*   **IaC (Infrastructure as Code)**:
    *   Firebaseの設定やGCPのリソースは、TerraformやFirebase CLIを用いてコード管理します。手動操作（ClickOps）によるオペレーションミスを排除します。
