# 30. エンジニアリングの卓越性 (Engineering Excellence - General)

### 13.1. The Trinity DTO Mandate (Constitutional Pillar)
*   **Law**: いかなる機能実装においても、以下の3点を遵守しないコードは、存在自体が憲法違反（Unconstitutional）となり、即時削除の対象となります。
    1.  **Security (PII Defense)**: 生データ（Raw Row）の出力は禁止です。必ず **DTO (White-list)** を経由し、機密情報を物理的に遮断してください。
    2.  **Stability (Frontend Shield)**: DBスキーマとUIを直結させてはなりません。Mapper関数という「防波堤」を築き、変更の影響をサーバー内で吸収してください。
    3.  **AI Economy (Token Optimization)**: AIに無駄なデータを読ませてはなりません。**AI-Optimized DTO** でトークンを極限まで節約し、推論精度を高めてください。
*   **Detailed Action**:
    *   **Strict Segregation**: 機密性の高いフィールド（管理者の内部メモ、PII等）を含むDTOは、必ず `AdminDTO` / `PublicDTO` のように型レベルで物理的に分離し、誤インポートを物理的に防止してください。
    *   **No Raw Return**: Server ActionsやAPIは、生の `Database['public']['Tables']` 型を返してはなりません。必ず明示的に定義されたDTO型を返してください。
    *   **No Blind Spread (The Spread Prohibition)**: `...user` のようなスプレッド構文でのプロパティコピーは、将来追加される機密カラム（例: `internal_memo`, `password_hash`）を意図せず漏洩させるため、DTO変換層では**完全禁止**とします。必ず明示的にフィールドを列挙してください。`as any` による握りつぶしも「セキュリティ犯罪」とみなします。
    *   **No Dynamic DTO**: Server Actions内でDTOMapper関数を動的インポート（`await import`）することは、型安全性と契約（Contract）の安定性を損なうため禁止します。常に静的インポート（Static Import）を使用してください。
    *   **The Return Type Clarity Protocol (Wrapper Ban)**:
        *   **Law**: Server Actionsの戻り値型において、成功時に `{ data: T[] }` のような無意味なラッパーオブジェクトを使用することを禁止します。
        *   **Standard**: 成功時は `T` または `T[]` を直接返し、エラー時は `throw` または `null` を返すパターンに統一してください。呼び出し側での `res.data` アクセスによる混乱（undefined参照）を防ぎます。
    *   **The UI-DTO Binding Protocol (Component Contract)**:
        *   **Law**: 共有UIコンポーネント（Card, Widget等）のPropsは、具体的なDB型（`Database['public']['Tables']['...']`）ではなく、**抽象化されたDTOインターフェース**に依存させなければなりません。
        *   **Reason**: 異なるデータソース（例：人気リストと検索結果）で同じUIを再利用可能にするためです。これによりOmnichannelアーキテクチャを実現します。

### 13.2. The Client DB Access Prohibition (Architecture Law)
*   **Law**: クライアントサイド（React Components）から `supabase.from()` を直接呼び出すことは、RLSポリシーの実装漏れや生データ漏洩（DTO未適用）を招くため、アーキテクチャレベルで禁止します。
*   **Action**:
    *   **Gateway First**: データ取得・更新は必ず `Server Actions` または `Route Handler` (API) を経由してください。
    *   **Secure Write Action Protocol (The Turnstile Mandate)**:
        *   **Law**: 公開フォーム（Auth, Inquiry, Review等）への書き込みを行う Server Action は、必ず `turnstileToken` を引数として受け取り、サーバーサイドで検証することを義務付けます。
        *   **Verification**: 検証を通過しないリクエストは、DBに到達する前に `400 Bad Request` で即時却下してください。
    *   **Exception**: 認証 (`auth`), Realtime購読, Fire-and-forgetなRPC（閲覧数カウント等）のみ例外として許可されます。

### 13.3. The Service Pattern Mandate (Server Component Gateway)
*   **Law**: `page.tsx` や `layout.tsx` 等のServer Component内で、DBアクセス関数（`supabase.from()`等）を直接呼び出すことを禁止します。
*   **Reason**: Omnichannelアーキテクチャにおいて、同じデータ取得ロジックがWeb（Server Component）、モバイルアプリ向けAPI (`/api/v1/*`)、管理画面などから100%再利用可能でなければなりません。
*   **Action**: 必ず `lib/api/gateways/` (Read) または `lib/actions/` (Write) にロジックを抽出し、UIは「Gatewayを呼んで表示するだけ」の状態にしてください。

### 13.4. The VIP Lane Strategy (Native Bypass Protocol)
*   **Context**: 自社開発ネイティブアプリからのAPIアクセスに対し、外部パートナー向けAPI Keyを必須にすると、アプリ内に秘密鍵を埋め込むセキュリティリスクが発生します。
*   **Law (Dual Auth Strategy)**:
    1.  **Common Endpoint**: 読み取りAPIエンドポイントは、Public（他社）とFirst Party（自社）で共有します。
    2.  **Dual Auth**: Middlewareにおいて「API Key認証」と「Bearer Token認証」のOR条件を実装してください。
    3.  **Tier Grant**:
        *   `X-API-KEY` のみに依存するリクエスト → キーに紐付いたTier (Tier 1/2) を適用。
        *   `Authorization: Bearer` (User Session) を持つリクエスト → 正当なログインユーザーであれば、無条件で特権Tierを付与します。
*   **Outcome**: アプリに秘密鍵を持たせず（No Secrets）、ログインユーザーであること（Trust）を担保にVIPレーンを確立します。

### 13.5. The Centralized Logging Protocol (Zero Console)
*   **Law**: 本番環境における `console.log` や `console.error` の放置は「衛生管理欠如」です。構造化されていないログは検索不能であり、ノイズです。
*   **Action**:
    *   **Logger Only**: APIやAction内では、必ず `src/lib/logger.ts` (Logger) を使用してください。
    *   **Prohibition**: `console.*` メソッドの使用を禁止します（Linterでブロック推奨）。

### 13.6. The Pragmatic Casting Protocol (Type Survival)
*   **Context**: 自動生成された型定義（`Database`）にまだ存在しないテーブル（Phantom Tables）へのアクセスが必要な場合、CIを通すために一時的なバイパスが必要です。
*   **Law**: `as any` は禁止ですが、意図的なブリッジキャストは許容します。
*   **Action**:
    *   **Local Extension**: 不足している型定義を `src/types/database-extensions.ts` に局所定義してください。
    *   **Bridge Pattern**: `(supabase as any).from('table')` を許容し、戻り値を直後に `data as MyLocalRow[]` とアサーションすることで、実用的な型安全性を確保してください。ただし、これは正規の型定義が生成されるまでの**一時的な処置**としてください。

### 13.7. The Unstable Timer Protocol (SetTimeout Ban)
*   **Law**: `setTimeout` や `setInterval` は実行タイミングが保証されず、サーバーレス環境（Edge）や高負荷時にシステムを不安定にします。
*   **Action**: ロジック制御のためにタイマーを使用することを禁止します。必要な場合はイベント駆動アーキテクチャ、ジョブキュー（Background Jobs）、または `requestAnimationFrame` を使用してください。

### 13.8. The Type Bridge Mandate (No Implicit Any)
*   **Law**: 自動生成型（`database.types.ts`）に不足がある場合でも、`as any` で逃げることは許されません。「ビルドが通る」と「型が安全」は別物です。
*   **Action**:
    *   **Extension**: `src/types/database-extensions.ts` に拡張型 (`DatabaseExtended`) を定義し、不足しているViewやRPCを補完してください。
    *   **Bridge**: Supabaseクライアント初期化時にこの拡張型をジェネリクスとして渡し、アプリ全体で型安全性を維持してください。
    *   **Mapped Type**: 拡張型を定義する際は、交差型（`&`）ではなく **Mapped Type (写像型)** を使用し、型衝突による `never` や `undefined` への退化を防いでください。

### 13.9. The API Product Mindset (Data Monetization Protocol)
*   **Law**: 全てのデータ出力は「商品（Product）」です。「Internal APIだから」という甘えは、セキュリティと収益化の機会を損ないます。
*   **Action**:
    *   **Strict Tiering**: APIは必ず **Tier 1 (Public/Free)** と **Tier 2 (Enterprise/Paid)** に分離できる設計にしてください。
    *   **Usage Recording**: 全ての Enterprise API エンドポイントにおいて、成功時に `recordApiUsage` を **Fire-and-forget** パターンで呼び出し、使用量を監査ログに残してください。
    *   **Metadata**: レスポンスには `meta` フィールド（AI用メタデータ、Tier情報、生存期間TTL）を含め、AIエージェントの自律判断を支援してください。
    *   **Metadata Segregation Protocol (Stripe vs App)**:
        *   **Law**: Stripe等の外部決済プロバイダの `metadata` フィールドと、アプリ内部の `metadata` カラムを混同・同期することは、上書き事故の元凶であり厳禁とします。
        *   **Action**: 決済メタデータには `app_` 接頭辞（例: `app_user_id`）を付与し、プロバイダ固有キー（`subscription_id`等）との衝突を物理的に回避してください。
    *   **Standard Metadata**: Tier 1/2 の API においては、メタデータ内に `tier` (public, enterprise), `usage` (metered, unlimited), `revalidation` (ttl) 等の情報を付与し、FinOps最適化を支援してください。
    *   **The API Latency Budget (Rule 26.5)**:
        *   **Law (Speed First)**: 全ての Public/Enterprise API の TTI (Time to Interaction) は、**200ms 以内** に抑えることを設計目標とします。
        *   **Action**: 200ms を超える処理（重い集計、外部API連携）は、同期的に行わず Webhook または非同期 Queue に逃がし、API は `202 Accepted` と `request_id` を即座に返却してください。

### 13.10. The Tenant-Aware Naming Protocol
*   **Law**: 将来的なSaaS化（マルチテナント）を見据え、リソース名は明確に区別します。
*   **Action**:
    *   **Site/Tenant**: 顧客（テナント）ごとの設定やリソースには `site_` や `account_` を接頭辞として使用します（例: `site_settings`）。
    *   **System**: 全テナント共通の不変な基盤設定にのみ `system_` を使用します。これにより `tenant_id` 追加時の設計破綻を防ぎます。
