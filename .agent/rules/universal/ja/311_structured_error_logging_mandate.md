# 30. エンジニアリングの卓越性 (Engineering Excellence - General)

### 13.42. The Structured Error Logging Mandate（構造化エラーログ義務）
*   **Law**: エラーオブジェクトをログに出力する際、**文字列テンプレートへの直接埋め込み**（例: `` `Error: ${error}` ``）を禁止します。エラーオブジェクトは必ず**構造化された形式**でログに記録しなければなりません。
*   **Action**:
    1.  **No Template Embedding**: `` `Error occurred: ${error}` `` のパターンは `[object Object]` を出力し、根本原因の情報を完全に喪失させます。
    2.  **Destructured Logging**: エラーオブジェクトの `message`, `code`, `details`, `hint` 等のプロパティを明示的に分解してログに出力してください（例: `Logger.error('Operation failed', { message: error.message, code: error.code, details: error.details })`）。
    3.  **JSON Serialization**: 構造化ログシステムを使用する場合は、`JSON.stringify(error, null, 2)` 等でエラーオブジェクト全体をシリアライズし、全プロパティを保存してください。
    4.  **Stack Trace Preservation**: `Error` インスタンスの `stack` プロパティは、テンプレートリテラルに含めると消失します。常に第2引数またはメタデータオブジェクトとして渡してください。
*   **Rationale**: `[object Object]` としてログに記録されたエラーは、根本原因の特定を事実上不可能にします。特にRLS違反、認証エラー、型不一致等の微妙なエラーは `code` や `details` に重要な診断情報を含んでおり、テンプレート埋め込みはこれらを全て喪失させます。

### 13.43. The Type Integrity Prohibition Protocol（型詐称の禁止）
*   **Law**: `as any` や `as never` を用いて型エラーを黙殺する行為は「バグの埋め込み」と定義します。型を正しく合致させることが**唯一の正当な解決策**であり、キャストによる回避は全面禁止です。
*   **Action**:
    1.  **Zero `as any` Policy**: コードベース全体で `as any` の使用を原則禁止します。ESLint ルール `@typescript-eslint/no-explicit-any` を `error` に設定し、CIで物理的にブロックしてください。
    2.  **Root Cause Resolution**: 型エラーが発生した場合は、キャストではなく「型定義の修正」「DTOの再設計」「ジェネリクスの適用」のいずれかで**根本原因**を解消してください。
    3.  **Exceptional Cast Documentation**: やむを得ず型アサーションが必要な場合（外部ライブラリの型定義不備等）は、`// SAFETY: <理由>` コメントを必ず付記し、コードレビューで承認を得てください。
    4.  **Lint Suppression Audit**: `// eslint-disable` や `// @ts-ignore` の使用は「技術的負債の宣言」です。使用時は必ず対応するIssue番号を併記し、四半期ごとに棚卸しを義務付けます。
*   **Rationale**: `as any` は型安全性を完全に無効化し、本来コンパイル時に検出されるべきバグを実行時に先送りします。特にDTO変換やAPI境界での使用は、データ不整合を隠蔽し、障害発生時の原因特定を著しく困難にします。

### 13.44. The Thin Controller Mandate（薄いコントローラー原則）
*   **Law**: API Route / Controller / Route Handler は、リクエストのパース・バリデーションと権限チェックのみを担当する「薄い層」として設計しなければなりません。ビジネスロジックはService層に委譲し、Controllerに直接記述することを禁止します。
*   **Action**:
    1.  **Controller Responsibilities**: Controller内のコードは以下に限定します: (a) リクエストボディ/パラメータのパースとバリデーション、(b) 認証/認可チェック、(c) Service層の呼び出し、(d) レスポンスの構築と返却。
    2.  **No DB Access in Controllers**: Controller / Route Handler 内での直接的なDB呼び出し（ORMクエリ、SQL実行等）を禁止します。全てのデータアクセスはService/Gateway層を経由してください。
    3.  **Testability**: Service層はControllerから独立してユニットテスト可能でなければなりません。Controllerに密結合したロジックはテスタビリティを破壊します。
    4.  **Error Translation**: Service層から発生した例外は、Controller層でHTTPステータスコードとエラーレスポンス形式に変換してください。Service層がHTTPステータスコードを知っていてはなりません。
*   **Rationale**: 肥大化したControllerはテスト困難、再利用不能、変更影響の把握不能という三重苦を生みます。薄いController + 厚いServiceの分離は、保守性とスケーラビリティの基盤です。

### 13.45. The DTO Boundary Casting Protocol（DTO境界キャスト規約）
*   **Law**: データベースやORMからの戻り値（緩い型）を厳格なDTO型に変換する際、`as any` によるキャストを禁止します。安全な型変換戦略を義務付けます。
*   **Action**:
    1.  **No `as any` Bridge**: `dbResult as any as MyDTO` のようなダブルキャストは、型安全性の完全な放棄です。禁止します。
    2.  **Explicit Mapping**: DB結果からDTOへの変換は、明示的なマッピング関数（`toDTO(dbResult): MyDTO`）を作成し、各フィールドを個別にマップしてください。
    3.  **Validated Cast**: やむを得ず型アサーションが必要な場合は、`as unknown as TargetType` による意図的な二段階変換を使用し、変換意図を明示してください。ただし、Zodなどのランタイムバリデーションとの併用を強く推奨します。
    4.  **Generated Types**: DB型定義は自動生成（Prisma, Drizzle, Supabase CLI等）を使用し、手書きの型定義との乖離を物理的に防止してください。
*   **Rationale**: DB層とアプリケーション層の型境界は、最もデータ不整合が発生しやすい箇所です。`as any` によるキャストは、カラム追加・名変更時のサイレントなデータ消失を引き起こし、ビルドは通るがデータが壊れる最悪のバグを生み出します。

### 13.46. The CQRS Separation Mandate（コマンドクエリ責務分離義務）
*   **Law**: Read操作（参照）とWrite操作（更新）のロジックを同一の関数・クラスに混在させることを禁止します。Query（Read専用）とCommand（Write専用）を明確に分離してください。
*   **Action**:
    1.  **Query/Command Split**: データアクセス層は、読み取り専用の `QueryGateway`（または `ReadService`）と、書き込み専用の `CommandGateway`（または `WriteService`）に分離してください。
    2.  **No Side Effects in Queries**: Query系のメソッドは、データの読み取りと変換のみを行い、DBへの書き込みや外部APIの呼び出し等の副作用を一切持ってはなりません。
    3.  **Independent Scaling**: Read/Writeの分離により、読み取り負荷が高い場合はRead Replicaの追加、書き込みが集中する場合はWrite最適化と、独立したスケーリング判断が可能になります。
    4.  **Naming Convention**: メソッド名でRead/Writeの意図を明示してください（例: `getUser` / `findUsers` は Read、`createUser` / `updateUser` は Write）。
*   **Rationale**: Read/Writeの混在は、キャッシュ戦略の適用を困難にし、パフォーマンスボトルネックの特定を遅延させます。CQRS分離は、コードの可読性向上、テスタビリティの改善、そして将来のイベントソーシングやマイクロサービス化への移行パスを確保します。

### 13.47. The Cache Strategy Layer Protocol（階層化キャッシュ戦略義務）
*   **Law**: データ特性を無視した一律のキャッシュ戦略（全件TTL固定 / キャッシュ完全無効化）を禁止します。データの変更頻度と鮮度要件に基づいた**階層化キャッシュ戦略**を定義してください。
*   **Action**:
    1.  **Data Classification**: アプリケーションで扱うデータを以下のティアに分類してください:
        - **STATIC** (変更なし): 法的文書、利用規約等。CDN/ISR（リビルドトリガー式）。
        - **WARM** (日次〜週次変更): マスターデータ、カテゴリ等。TTL 5分〜1時間 + SWR (Stale-While-Revalidate)。
        - **HOT** (分単位変更): ユーザー投稿コンテンツ、商品在庫等。短TTL (30秒〜5分) + オンデマンドリバリデーション。
        - **REALTIME** (即時反映): チャット、通知、決済ステータス等。キャッシュ無効 + WebSocket/SSE。
    2.  **No Blind Cache**: `cache: 'force-cache'` や `revalidate: 0` を「とりあえず」で設定することを禁止します。各データソースに対してティア分類に基づいた明示的なキャッシュ戦略を文書化してください。
    3.  **Cache Invalidation Strategy**: 書き込み時のキャッシュ無効化戦略（`revalidateTag` / `revalidatePath` / Purge API等）を、データ更新フローと一体で設計してください。
    4.  **Monitoring**: キャッシュヒット率を計測し、90%未満のエンドポイントは最適化対象としてください。
*   **Rationale**: 一律のキャッシュ戦略は、静的データに不要なリクエストを送り（コスト増加）、リアルタイムデータに古い情報を返す（UX劣化）という両面で損害を与えます。データ特性に基づく階層化は、コスト効率とユーザー体験の両立を実現する唯一の設計パターンです。
