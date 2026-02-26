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
