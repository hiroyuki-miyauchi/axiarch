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
    *   **URL-Based Versioning (推奨)**: `/api/v{major}/` 形式（例: `/api/v1/stores`）を標準とします。Header-basedやQuery-basedより発見性（Discoverability）が高く、ドキュメント化とテストが容易です。
    *   **Breaking Change Definition (破壊的変更の定義)**:

        | 変更種別 | Breaking | 例 |
        |:--------|:---------|:---|
        | レスポンスフィールドの**削除** | ✅ Yes | `address` フィールドの除去 |
        | レスポンスフィールドの**型変更** | ✅ Yes | `price: string` → `price: number` |
        | 必須パラメータの**追加** | ✅ Yes | 新パラメータ `region` を必須化 |
        | レスポンスフィールドの**追加** | ❌ No | 新フィールド `rating_count` の追加 |
        | オプショナルパラメータの**追加** | ❌ No | `?sort=newest` の追加 |
        | エンドポイントの**追加** | ❌ No | `/api/v1/reviews` の新設 |

    *   **Deprecation Protocol (非推奨化手順)**:
        1.  **並行稼働**: 旧バージョンのAPIは、新バージョンリリースから**最低6ヶ月間**並行稼働してください。
        2.  **Sunset Header**: 非推奨APIのレスポンスに `Sunset: <date>` ヘッダーを付与してください（RFC 8594準拠）。
        3.  **通知義務**: APIキー保持者へ3ヶ月前、1ヶ月前、1週間前にメール通知を行ってください。
        4.  **ドキュメント**: API仕様書に非推奨の旨と移行ガイドを掲載してください。
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

### 3.2. The Transparent Gateway Instrumentation Protocol（ゲートウェイ透過的計装）
*   **Law**: Gateway / Service層の `catch` ブロックにおいて、エラーオブジェクトを**文字列テンプレートに直接埋め込んでログ出力**することを禁止します。エラーの `code`, `message`, `details` を明示的に分解して記録しなければなりません。
*   **Action**:
    1.  **No Generic Messages**: `` `Gateway error: ${error}` `` は `[object Object]` を出力し、RLS違反・権限不足・型不一致等の根本原因を完全に不可視化します。
    2.  **Property Deconstruction**: `catch` ブロックでは `Logger.error('Gateway operation failed', { message: error?.message, code: error?.code, details: error?.details, hint: error?.hint })` の形式で構造化ログを出力してください。
    3.  **HTTP Status Mapping**: データベースエラーコード（例: `23505` = unique violation, `42501` = insufficient privileges）をHTTPステータスコードに適切にマッピングし、クライアントにセマンティックなエラー情報を返却してください。
    4.  **Sensitive Data Guard**: エラーログにリクエストペイロードを含める場合は、PII（個人情報）やクレデンシャルを必ずマスキングしてください。
*   **Rationale**: ゲートウェイ層はアプリケーションのエラー診断における「最初の防衛線」です。ここで `[object Object]` が記録されると、データベース・RLS・認証のいずれが原因かの切り分けが不可能となり、デバッグ時間が指数関数的に増大します。

### 3.3. The Server Action Graceful Return Protocol（Server Action優雅な返却）
*   **Law**: Server Action（またはクライアントから呼び出されるサーバーサイド関数）が業務エラーを検出した場合、`throw new Error()` ではなく**共通レスポンス型**（例: `{ success: false, error: '...', code: '...' }`）で返却しなければなりません。
*   **Action**:
    1.  **No Raw Throw**: Server Actionでの `throw` は、クライアントの `useActionState` / `useTransition` 等のフックが「予期せぬ例外」として処理し、コンポーネントのクリーンアップや再試行ロジックが暴走する原因となります。
    2.  **Typed Response Contract**: 全Server Actionの戻り値を `ActionResponse<T> = { success: true, data: T } | { success: false, error: string, code?: string }` のような共通型で統一してください。
    3.  **Client Graceful Handling**: クライアント側では `if (!result.success)` で分岐し、トースト通知やフォームエラー表示等の適切なUIフィードバックを提供してください。未処理の `throw` に依存するエラーハンドリングは禁止です。
    4.  **Observability**: Server Action内の `catch` ブロックでは、エラーをログに記録した上で、ユーザーフレンドリーなメッセージに変換してレスポンスに含めてください。生の技術的エラーメッセージをクライアントに返却してはなりません。
*   **Rationale**: `throw` によるエラー伝播は、クライアント-サーバー境界（Next.js Server Actions等）を跨ぐ場合、シリアライゼーションの問題やReactのライフサイクルとの競合を引き起こします。共通レスポンス型はこれらの問題を構造的に回避し、予測可能なエラーハンドリングを実現します。

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
    *   **Replay Attack Prevention (リプレイアタック防止)**: Webhookペイロード内の `timestamp` を検証し、**5分以上前のリクエストは拒否**してください。処理済みイベントIDを一定期間キャッシュし、重複実行を防止します。
    *   **Idempotency（冪等性保証）**: 同一 `event_id` の Webhook が複数回到達しても、副作用が1回のみ発生するよう設計してください。冪等性キーとしてWebhook固有IDを使用し、処理前にDB上で重複チェックを実施します。
    *   **Error Handling**: 処理失敗時は `5xx` を返し、送信元のリトライ機構に委ねてください。`2xx` を返すと「成功した」とみなされリトライが発生しないため、処理が未完了のまま消失します。署名が一致しないリクエストは即座に `401 Unauthorized` を返し、アラートログに記録してください。
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

### 7.1. The API Documentation Standard（API公開ドキュメント基準）
*   **Law**: 外部に公開するAPIは、開発者が契約前に動作検証可能な**Sandbox環境**と、主要言語でのリクエスト例を提供しなければなりません。
*   **Action**:
    1.  **OpenAPI 3.x**: 全APIエンドポイントをOpenAPI仕様で定義し、自動生成ドキュメントを公開してください。
    2.  **Sandbox Environment**: テスト用APIキーとサンドボックス環境を提供し、契約前に動作検証を可能にしてください。本番データへの影響がない隔離環境を用意します。
    3.  **Code Examples**: 最低3言語（JavaScript、Python、cURL）でのリクエスト例をドキュメントに含めてください。コピーペーストで動作するコード例を標準とします。
    4.  **Bilingual Documentation**: グローバル展開を前提とするAPIは、プロジェクト設定言語と英語の**バイリンガル**でドキュメントを提供することを推奨します。
*   **Rationale**: 「APIが存在するが試す方法がない」状態は、潜在顧客の離脱を招きます。Sandbox環境とコード例により、開発者のオンボーディング時間を最小化し、API採用率を最大化します。

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

### 8.2. The API Gateway Metering Mandate (ゲートウェイ使用量計測義務)
*   **Law**: 将来的な従量課金（Metered Billing）に備え、API Gateway / Middleware 層には**使用量計測（Metering Log）**を実装しなければなりません。計測はレスポンス遅延を発生させずに非同期で行うことを標準とします。
*   **Action**:
    1.  **Gateway-Level Metering**: API Gateway層で、リクエストごとにエンドポイント、呼び出し元（Tier/API Key）、レスポンスステータスを記録してください。ビジネスロジック層の `recordUsage` とは独立した、インフラ層での計測です。
    2.  **Async Logging**: ログ記録は `event.waitUntil()` パターン（または同等の非同期メカニズム）を使用し、メインレスポンスをブロックせずにバックグラウンドで行ってください。
    3.  **Aggregation Ready**: 計測データは「日次/月次の集計」「Tier別のトラフィック分析」「コスト配分」に利用可能な粒度で記録してください。
*   **Rationale**: ビジネスロジック層の `recordUsage` は「課金対象のアクション」を記録しますが、Gateway層の計測は「全トラフィックの可視化」を目的とします。この二層計測により、従量課金の正確性とインフラのキャパシティプランニングの両方を支えます。

### 6.2. The Strict Action Return Type Protocol（Server Action戻り値厳格化）
*   **Law**: Server Action（またはサーバーサイド関数）は、全ての戻り値に対して**厳格な型定義**を持たなければなりません。UI側での `as any` キャストによる戻り値の型変換を永久に禁止します。
*   **Action**:
    1.  **Typed Response Contract**: 全てのServer Actionは、共通の戻り値型（例: `ActionResponse<T> = { success: true, data: T } | { success: false, error: string, code?: string }`）を使用してください。`void` や `any` を戻り値型にすることを禁止します。
    2.  **No Client-Side Cast**: UI（呼び出し側）で `result as any` や `result as MyType` を使用して戻り値の型を無理やり合わせる行為を禁止します。型が合わない場合はServer Action側の型定義を修正してください。
    3.  **Error Typing**: エラーケースも型で表現してください。`catch` ブロックで `unknown` を返すのではなく、想定されるエラーパターンを全てUnion型で列挙することを推奨します。
    4.  **Serialization Boundary**: Server Actionの戻り値はReactのシリアライゼーション境界を通過します。`Date`, `Map`, `Set`, クラスインスタンス等の非シリアライズ可能な値を含めないでください。
*   **Rationale**: 型の不整合をUI側で `as any` により隠蔽すると、Server Action の仕様変更時にUIが想定外のデータでサイレントに破壊されます。Server ActionとUIの型契約を厳密に維持することが、フルスタック型安全性の要です。

### 6.3. The Graceful Failure Contract（Server Action安全失敗契約）
*   **Law**: Server Action（`'use server'` 関数）内で発生したエラーを `throw` によりクライアントに伝播させることを**原則禁止**します。全てのエラーを `{ success: false, error: string, code?: string }` 形式の構造化レスポンスとして返却しなければなりません。
*   **Action**:
    1.  **No Throw Propagation**: Server Action がエラーを `throw` すると、Reactのエラーバウンダリが発火し、ページ全体または大きなUIセグメントが破壊される可能性があります。ビジネスロジックのエラー（バリデーション失敗、権限不足、データ不整合等）は全て戻り値で表現してください。
    2.  **Try-Catch Envelope**: Server Action のルート関数は必ず `try-catch` で全体を包み、内部で発生した例外を `{ success: false, error: e.message }` に変換してください。予期しない例外もユーザーに適切なフィードバックを返せるようにしてください。
    3.  **Typed Error Codes**: エラーレスポンスには機械可読な `code`（例: `VALIDATION_ERROR`, `PERMISSION_DENIED`, `NOT_FOUND`）を含め、UI側でエラーの種類に応じた分岐処理（トースト表示、リダイレクト、リトライ等）を可能にしてください。
    4.  **Logging Before Return**: エラーを戻り値として返す前に、必ずサーバーサイドでログ（`Logger.error`）を出力してください。戻り値によるエラーハンドリングは、ログ出力を怠ると観測性を失う危険があります。
*   **Rationale**: Server Action の `throw` はReactのストリーミングレンダリングと複雑に相互作用し、エラーバウンダリの意図しない発火、フォーム状態のリセット、再レンダリングの連鎖など、予測困難な副作用を引き起こします。構造化された戻り値によるエラーハンドリングは、UIの安定性とデバッグの容易さの両方を保証します。

## 9. CORS ガバナンス

### 9.1. The CORS Governance Protocol（CORSガバナンス基準）
*   **Context**: API外販やサードパーティ統合を前提とし、CORSポリシーの明確な管理基準が必要です。
*   **Default Policy**: 明示的に許可されていないオリジンからのリクエストは**全てブロック**してください。
*   **Environment Matrix**:
    | 環境 | 許可オリジン | 設定方法 |
    |:-----|:-----------|:--------|
    | **Production** | 自社ドメインのみ | フレームワーク設定ファイル |
    | **Preview/Staging** | Preview用ドメインパターン | 環境変数で動的設定 |
    | **Development** | `http://localhost:*` | `.env.local` |
    | **API外販（将来）** | 契約者ドメインのホワイトリスト | DB管理 + APIキーに紐付け |
*   **Credentials Rule**: `Access-Control-Allow-Credentials: true` は認証が必要なエンドポイントのみに限定し、`Allow-Origin: *` との組み合わせを**厳禁**としてください。
*   **Preflight Cache**: `Access-Control-Max-Age: 86400`（24時間）を設定し、不要なOPTIONSリクエストを削減してください。
*   **Prohibition**: 本番環境での `Access-Control-Allow-Origin: *` の使用は厳禁です（`60_security_privacy.md` 参照）。
*   **Rationale**: CORSの設定ミスは、XSSやCSRFの攻撃面を広げるセキュリティリスクであると同時に、意図しないオリジンからのAPIアクセスを許可することで認証バイパスやデータ流出のリスクを生みます。環境別に厳格なポリシーを適用することで、開発の利便性とセキュリティを両立します。
