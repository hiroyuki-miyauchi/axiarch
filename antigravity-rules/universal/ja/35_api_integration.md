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
    *   **Admin Data Leak Defense**: 管理者画面用の API においても、`SELECT *` を禁止し、必ず専用の **`AdminDTO`** を定義してください。将来的な `internal_memo` や原価情報等の機密カラム追加時の自動漏洩を物理的に防ぎます。
    *   **Verification (DTO Assertion)**: APIのテストケースには、「除外されるべきフィールド（PII等）が存在しないこと」を確認する **`assert(field is undefined)`** テストを含めなければなりません。
    *   **PII Masking**: パスワードハッシュや内部フラグ（`is_admin`）の流出を構造的に防ぎます。

## 2. 信頼性と回復性 (Reliability & Resilience)
*   **冪等性 (Idempotency)**:
    *   **必須要件**: 決済、作成、更新などの副作用を伴う全てのリクエスト（POST/PUT/PATCH）において、`Idempotency-Key` ヘッダーの実装を義務付けます。
    *   **動作**: ネットワークエラーでリトライが発生しても、同じキーを持つリクエストはサーバー側で「一度だけ」処理され、重複実行（二重課金など）を確実に防ぎます。
*   **エラーハンドリング**:
    *   **Jitter付きリトライ**: 一時的なエラーには、単純なリトライではなく「指数バックオフ + Jitter（ランダムな揺らぎ）」を適用し、Thundering Herd問題を回避します。
    *   **サーキットブレーカー**: 外部サービスがダウンしている場合、即座にエラーを返し、システム全体が巻き込まれてダウンするのを防ぎます。
*   **The Outbound Audit Mandate (External Visibility)**:
    *   **Law**: 外部サービス（Stripe, OpenAI, Supabase API等）への全ての「書き込み」リクエストおよび「AI推論」リクエストは、必ず自社の監査ログテーブル (`outbound_api_logs`) に記録してください。
    *   **Action**: リクエストPayload（個人情報はハッシュ化）、ステータスコード、および処理時間を記録し、外部サービス側の障害やレート制限の予兆を早期に検知可能にします。

## 3. セマンティックAPIとAIレディネス (Semantic API & AI Readiness)
### 3.1. The RFC 7807+ Protocol (Semantic Error Consistency)
*   **Uniform Error**: エラーレスポンスは必ず **RFC 7807 (Problem Details for HTTP APIs)** に準拠した構造で返却してください。単なる文字列メッセージではなく、`type`, `title`, `status`, `detail`, `instance` を具備することで、クライアント（およびAIエージェント）がエラーの文脈を機械的に正確に判別可能にします。
*   **Consistency**: Server Actions の戻り値もこの `ApiResponse` スキーマに統一し、WebフロントエンドとAPIエコノミー間の境界（Boundary）を消失させてください。
*   **The Backend Error Propagation Ban (Localization)**:
    *   **Law**: サーバーサイドから返却される生の技術的エラーメッセージ（例: `"Row not found"`, `"upstream connect error"`, `"p0 description"`）を、そのままトースト通知やUIに表示することを物理的に禁止します。
    *   **Action**: クライアント側でエラータイプに基づいて、ユーザーが理解でき、かつ「次にとるべきアクション」を提示するローカライズされたメッセージへと翻訳してください。
    *   **Reason**: 生のエラーはユーザーに不安を与える「技術的怠慢」であり、信頼を損ないます。
*   **The Metadata Mandate (AI & FinOps Strategy)**:
    *   **AI Context Meta**: 全ての成功レスポンスには、`meta` フィールドを含めることを推奨します。
    *   **Details**: `tier` (public, enterprise), `usage` (metered, unlimited), `revalidation` (ttl) 等の情報を含め、AIエージェントによる推論精度向上と FinOps 最適化を支援してください。

## 4. パフォーマンスとスケーラビリティ (Performance & Scalability)
*   **レート制限 (Rate Limiting)**:
    *   **分散レート制限**: Redisを使用した **Token Bucket** アルゴリズムにより、分散環境下でも正確なレート制限（例: 100 req/min）を実施します。
    *   **ヘッダー通知**: クライアントに対し、`X-RateLimit-Remaining` や `Retry-After` ヘッダーで制限状況を通知します。
*   **キャッシュ戦略 (Caching Strategy)**:
    *   **ETag / Last-Modified**: 適切なキャッシュヘッダーを付与し、クライアント側のキャッシュを最大限活用します（304 Not Modified）。
    *   **Stale-While-Revalidate**: コンテンツの鮮度を保ちつつ、高速なレスポンスを実現するためにCDNレベルでSWRパターンを採用します。

## 5. セキュリティと認証 (Security & Authentication)
*   **Authorization Header (Bearer Token)**:
    *   APIトークンはURLパラメータではなく、必ず `Authorization: Bearer <token>` ヘッダーで送信します。
    *   **The Native Bypass Protocol (VIP Lane Strategy)**: 自社アプリからのアクセスに対して API Key (`x-api-key`) を必須にすることを禁止します。Middleware において「API Key 認証 (Enterprise)」と「Bearer Token 認証 (Native/VIP)」の **OR 条件** を実装し、自社アプリのログインユーザーには無条件で Enterprise 相当の特権を付与してください。
    *   **Session Verification**: Bearer Token の検証には、単なる署名確認ではなく必ず `supabase.auth.getUser()` を使用してください。アカウントの Ban 状態やセッションの失効をリアルタイムに確認することを義務付けます。
*   **最小権限の原則**:
    *   APIキーやトークンには、必要最小限のスコープ（権限）のみを付与します。
    *   **API Key Security**: アプリケーション側で発行する API Key (`sk_live_...`) は、**絶対に平文でDBに保存してはなりません**。必ず **`SHA-256`** 等でハッシュ化して保存し、認証時は入力値をハッシュ化して照合してください。
*   **The Webhook Security Mandate (Signature Verification)**:
    *   **Law**: 外部サービス（Stripe, Meta, GitHub等）からの Webhook 受信時、署名検証（`X-Hub-Signature` 等の検証）を行わずに処理を開始することを禁止します。
    *   **Action**: 必ずプラットフォームから提供される `Signing Secret` を用いてリクエストの真正性を検証し、なりすましによる不正なデータ更新（例：未払いなのに支払い済みへの変更）を物理的に阻止してください。
*   **The Stateless Gateway Protocol (Scale First)**:
    *   **Law**: API Gateway および Middleware 層において、スティッキーセッションやサーバー内メモリに依存した状態保持を禁止します。
    *   **Action**: 全ての認証・認可は Bearer Token (JWT) または API Key に集約し、水平スケーリングがいつでも可能な状態を維持してください。

## 6. 高度書き込みプロトコル (Advanced Write Protocols)
*   **The Secure Write Action Protocol (Audit Result)**:
    *   **Law**: 決済、重要設定（財務・権限）、または最重要データの変更に関わる全アクションは、Tier 2 (Strict) 保護対象です。
    *   **Mandate**: これらの Server Action は必ず `otp?: string` および `turnstileToken?: string` を引数に受け取らなければなりません。処理冒頭で認証失敗時は即座に例外をスローしてください。
    *   **Frontend**: フロントエンドは `SecureActionModal` を使用し、明示的な承認と認証を求めるフローを義務付けます。
*   **The Hybrid Sync Prohibition (Data Integrity)**:
    *   **Context**: 同一データを RDB カラムと JSON (`config` 等) の両方に持たせる「二重管理」は、将来的な不整合（Split Brain）の主因となります。
    *   **Rule**: 新旧データ構造間の二重書き込みを禁止します。移行時は、ビジネスロジックとDBスキーマを即座かつ完全に新構造へ切り替え、旧構造を物理削除（Rule 99.9）してください。

## 7. ドキュメンテーション (Documentation)
*   **ライブドキュメント (Live Documentation)**:
    *   APIドキュメントはコードから自動生成され、常に最新の状態（Live）でなければなりません（Swagger UI, GraphiQL）。手動更新のドキュメントは禁止します。
## 8. APIエコノミーと収益化 (API Economy & Monetization)
### 8.1. The API Product Mindset (Highest Engineering Standard)
*   **Law**: 全ての API 出力を「販売可能な商品（Asset）」と捉え、Tiering と DTO による保護を徹底してください。内部用の手抜きは、将来の負債として指数関数的に増大します。
*   **Rule**: API の破壊的変更は「商品の欠陥（Recall級）」であり、エンジニアリングチームの信用失墜に直結します。
*   **Tiered Access**: コードレベルで「無料プラン（制限あり）」と「有料プラン（制限解除）」を分岐できるよう DTO で制御します。
*   **Metadata Strategy (Stripe/FinOps)**:
    *   **Law**: プランの性質（Enterprise か、特定機能が有効か等）は、必ず決済プラットフォーム側の **Metadata** に持たせ、コードはそれを参照して動的に振舞え。
    *   **Outcome**: これにより、エンジニアの手を借りず（デプロイなし）に、マーケターや経営陣が販売戦略を即座に変更できる柔軟性を確保せよ。
    *   **Tier 2 Readiness (Monetization First)**: 有料版 API (`/api/v1/*`) を公開する際は、必ず API Key 認証 (`X-API-KEY`) と Stripe 契約状態のチェックを完了させてください。この「収益化防壁」を実装せずに、単なる Public API のみを公開（ゲートウェイなし）することは、事業設計上の「敗北」として認められません。
    *   **Native App Exemption**: 自社ネイティブアプリからのアクセスは特例として「Tier 2 (Enterprise) 相当」として扱い、課金対象外（Bundled）とします。
*   **Data Monetization Privacy**:
    *   **Anonymization Interface**: 外部パートナーへ提供するAPIは、PII（個人情報）を **k-匿名化** または **差分プライバシー** 技術で加工した統計データのみを返します。生データの販売は永久に禁止です。
*   **The Data-Driven Marketing Protocol (Plan Abstraction Mandate)**:
    *   **Law**: コード内に特定のプラン ID をハードコードすることを禁止します。
    *   **Action**: プランの属性（Enterprise か、特定機能が有効か等）は、必ず Stripe 等の決済プラットフォーム側の **Metadata** または DB のプラン定義テーブルで管理してください。
    *   **Success**: これにより、エンジニアの手を借りず（デプロイなし）に、マーケターや経営陣が販売戦略を即座に変更できる柔軟性を確保します。
