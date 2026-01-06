# 35. API統合とマイクロサービス (API Integration & Microservices)

## 1. API設計原則 (API Design Principles)
*   **APIファースト設計 (API-First Design)**:
    *   **Omnichannel First**: Webフロントエンドを「特権的なクライアント」とせず、iOS/Androidアプリと対等に扱います。Webで可能な全ての操作はAPI経由で外部利用可能にします。
    *   **Tiered Gateway**: 「Tier 1 (Public/Read-Only)」と「Tier 2 (Enterprise/Auth/Paid)」を最初から分離して実装し、将来的なAPI収益化（Stripe Metering）に備えます。
    *   **設計先行**: 実装を始める前に、必ずAPI仕様を定義します。
    *   **OpenAPI (Swagger)**: REST APIの場合はOpenAPI 3.x仕様書を先に記述し、そこからコード（型定義、クライアント）を自動生成します。
    *   **Schema-Driven**: GraphQLの場合はSchema定義を正とし、フロントエンドとバックエンドの型安全性を担保します。
    *   **コード生成の義務化 (Mandatory Code Gen)**: 手書きの型定義は禁止です。必ずOpenAPI/GraphQLスキーマからクライアントコードとサーバーの型定義を自動生成します。
*   **プロトコル選択 (Protocol Selection)**:
    *   **REST**: パブリックAPIやシンプルなCRUD操作に使用します。
    *   **GraphQL**: 複雑なデータ取得や、モバイルアプリ（帯域幅節約）のBFF（Backend for Frontend）として使用します。
    *   **gRPC**: マイクロサービス間の内部通信には、高速で型安全な **gRPC (Protobuf)** を使用します。JSONのオーバーヘッドを排除します。
*   **バージョニング (Versioning)**:
    *   破壊的変更（Breaking Changes）を避けるため、URLまたはヘッダーでバージョン管理を行います（例: `/v1/users`）。
*   **データ転送基準 (Data Transport Standard)**:
    *   **DTO Obligation**: データベースの行オブジェクト（Raw Row）をそのまま返すことを「重罪」とします。必ず `UserDTO` などを経由し、意図的にマッピングされたフィールドのみを出力します。
    *   **PII Masking**: パスワードハッシュや内部フラグ（`is_admin`）の流出を構造的に防ぎます。

## 2. 信頼性と回復性 (Reliability & Resilience)
*   **冪等性 (Idempotency)**:
    *   **必須要件**: 決済、作成、更新などの副作用を伴う全てのリクエスト（POST/PUT/PATCH）において、`Idempotency-Key` ヘッダーの実装を義務付けます。
    *   **動作**: ネットワークエラーでリトライが発生しても、同じキーを持つリクエストはサーバー側で「一度だけ」処理され、重複実行（二重課金など）を確実に防ぎます。
*   **エラーハンドリング**:
    *   **統一フォーマット**: エラーレスポンスは常に統一されたJSON形式（`{ code, message, details }`）で返却します。
    *   **Jitter付きリトライ**: 一時的なエラーには、単純なリトライではなく「指数バックオフ + Jitter（ランダムな揺らぎ）」を適用し、Thundering Herd問題を回避します。
    *   **サーキットブレーカー**: 外部サービスがダウンしている場合、即座にエラーを返し、システム全体が巻き込まれてダウンするのを防ぎます。

## 3. パフォーマンスとスケーラビリティ (Performance & Scalability)
*   **レート制限 (Rate Limiting)**:
    *   **分散レート制限**: Redisを使用した **Token Bucket** アルゴリズムにより、分散環境下でも正確なレート制限（例: 100 req/min）を実施します。
    *   **ヘッダー通知**: クライアントに対し、`X-RateLimit-Remaining` や `Retry-After` ヘッダーで制限状況を通知します。
*   **キャッシュ戦略 (Caching Strategy)**:
    *   **ETag / Last-Modified**: 適切なキャッシュヘッダーを付与し、クライアント側のキャッシュを最大限活用します（304 Not Modified）。
    *   **Stale-While-Revalidate**: コンテンツの鮮度を保ちつつ、高速なレスポンスを実現するためにCDNレベルでSWRパターンを採用します。

## 4. セキュリティと認証 (Security & Authentication)
*   **認証ヘッダー (Authorization Header)**:
    *   APIトークンはURLパラメータではなく、必ず `Authorization: Bearer <token>` ヘッダーで送信します。
    *   **Native Session Bypass**: 自社アプリからのアクセスは、API Keyを埋め込まず、ユーザーセッション（Cookie/Bearer）を検証して自動的に特権（Tier 2）を付与します。
*   **最小権限の原則**:
    *   APIキーやトークンには、必要最小限のスコープ（権限）のみを付与します。

## 5. ドキュメンテーション (Documentation)
*   **ライブドキュメント (Live Documentation)**:
    *   APIドキュメントはコードから自動生成され、常に最新の状態（Live）でなければなりません（Swagger UI, GraphiQL）。手動更新のドキュメントは禁止します。
## 6. APIエコノミーと収益化 (API Economy & Monetization)
*   **Commercialization Protocol (データ販売戦略)**:
    *   **Internal as Public**: 全てのAPIは、将来的に「他社に有料で販売する商品」になると仮定して設計します。「後で有料版を作る」は許されず、最初からPublic版とEnterprise版を考慮します。
    *   **Usage Metering**: API Gateway層でトラフィック量やコール数を計測可能なアーキテクチャを維持し、Stripe Metered Billingでの請求に備えます。
    *   **Tiered Access**: コードレベルで「無料プラン（制限あり）」と「有料プラン（制限解除）」を分岐できるようDTOで制御します。
    *   **Native App Exemption**: 自社ネイティブアプリからのアクセスは特例として「Tier 2 (Enterprise) 相当」として扱い、課金対象外（Bundled）とします。
*   **Data Monetization Privacy**:
    *   **Anonymization Interface**: 外部パートナーへ提供するAPIは、PII（個人情報）を **k-匿名化** または **差分プライバシー** 技術で加工した統計データのみを返します。生データの販売は永久に禁止です。
    *   **Opt-Out**: ユーザー設定に「データ活用への協力」のON/OFFスイッチを設け、OFFの場合は集計対象から除外します。
