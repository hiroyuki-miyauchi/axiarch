# 32. バックエンドエンジニアリング (Backend Engineering - Firebase & GCP)

## 1. サーバーレス・アーキテクチャ (Serverless Architecture)
*   **Cloud Functions (第2世代)**:
    *   **標準化**: 原則として **Cloud Functions (2nd Gen)** を使用し、並列処理（Concurrency）とコールドスタート対策を強化します。
    *   **コールドスタート対策 (Cold Start Mitigation)**:
        *   **Min Instances**: ログインや決済など、レイテンシに敏感なクリティカルな関数には、必ず `minInstances: 1` 以上を設定し、即応性を保証します。
*   **イベント駆動 (Event-Driven)**:
    *   **非同期処理**: ユーザーの待機時間を最小化するため、重い処理（メール送信、画像加工、集計）は **Cloud Pub/Sub** や **Eventarc** を使用して非同期に実行します。

## 2. データベース設計 (Database Design - Firestore)
*   **整合性とセキュリティ (Integrity & Security)**:
    *   **Security Rulesの絶対遵守**: Firestore Security Rulesは絶対です。全てのドキュメントには適切なアクセス制御を設定します。
    *   **厳格な検証**: `request.auth.uid` を使用して、ユーザーが自分自身のデータにのみアクセスできるように制限します。
*   **無限のスケーラビリティ (Infinite Scalability)**:
    *   **Unbounded Queries 禁止**: クライアントサイドで上限（Limit）のないクエリ（例: `collection('posts').get()`）を実行することは**厳禁**です。Firestoreの読み取りコストを抑制し、パフォーマンスを維持するため、必ずページネーションを実装します。
    *   **遅延読み込み**: 必要なデータのみをオンデマンドで取得します。
*   **NoSQLモデリング (NoSQL Modeling)**:
    *   **Read最適化**: 書き込み（Write）よりも読み取り（Read）のパフォーマンスを優先して設計します。必要なデータは事前に非正規化（Denormalization）して保存します。
    *   **サブルコレクション**: ユーザーに紐づくデータ（注文履歴など）は、トップレベルではなくサブコレクションとして配置し、クエリの効率化とセキュリティ管理を容易にします。
*   **セキュリティルール (Security Rules)**:
    *   **テスト駆動**: Firestore Security Rulesは必ずユニットテストを書き、意図しないアクセス権限の漏洩を防ぎます。
    *   **最小権限**: デフォルトは `allow read, write: if false;` とし、必要なパスのみを明示的に許可します。

## 3. FinOpsとコスト管理 (FinOps & Cost Management)
*   **コスト配分 (Cost Allocation)**:
    *   **タグ付け**: 全てのGCPリソースに `Environment` (prod/dev), `Service` (api/worker), `Owner` タグを付与し、コストの発生源を明確にします。
*   **予算アラート (Budget Alerts)**:
    *   **異常検知**: 予算の50%, 80%, 100%に達した際のアラートに加え、前日比で急激なコスト増（スパイク）があった場合に即座にSlack通知する設定を行います。無限ループや攻撃による「クラウド破産」を防ぎます。

## 4. データ分析とエクスポート (Analytics & Export)
*   **BigQuery連携 (BigQuery Integration)**:
    *   **生データ (Raw Data)**: Firestoreのデータは **BigQuery Extension** を使用してリアルタイムに同期し、複雑な分析はBigQuery側で行います。アプリ側で集計クエリを走らせることは禁止です。
*   **エクスポート処理 (Export Processing)**:
    *   **バッチ処理**: CSVやPDFのエクスポートは、Cloud Functionsのメモリ制限を考慮し、**Stream処理** または **Cloud Run Jobs** で実行します。

## 5. 監視とログ (Monitoring & Logging)
*   **構造化ログ (Structured Logging)**:
    *   ログは単なるテキストではなく、JSON形式で出力し、Cloud Loggingでクエリ可能にします（例: `jsonPayload.userId` で検索可能にする）。
*   **IaC (Infrastructure as Code)**:
    *   Firebaseの設定やGCPのリソースは、TerraformやFirebase CLIを用いてコード管理します。手動操作（ClickOps）によるオペレーションミスを排除します。
## 6. Googleエコシステム戦略 (Google Ecosystem Strategy)
*   **Google First**:
    *   技術選定は **Googleエコシステム**（Firebase, GCP, Maps, AI）を最優先します。サードパーティ製品は、圧倒的な利点がある場合のみ採用します。
*   **Google Maps Platform**:
    *   **コスト最適化**: 非対話型ビューには **Static Maps** を使用し、Places Autocompleteにはセッショントークンを使用します。
    *   **パフォーマンス**: Vector Maps SDKを使用し、レンダリングを最適化します。

## 7. データ基盤 (Data Infrastructure - "Data Mesh")
*   **Single Source of Truth**:
    *   全ての分析データは **BigQuery** に集約します。スプレッドシート管理は禁止です。
    *   **ELT**: データは加工せずにロードし、BigQuery内で **dbt** を使用して変換・テストします。
*   **データ品質**:
    *   データの欠損や異常値を検知する自動テストをパイプラインに組み込みます。
