# 35. API統合とマイクロサービス (API Integration & Microservices)

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
