# 33. Webフロントエンドエンジニアリング (Web Frontend Engineering - Next.js)

### 14.22. The Form DefaultValues Completeness Mandate（フォーム初期値完全性義務）
*   **Law**: `useForm` の `defaultValues` には、フォーム内で使用する**全てのフィールドを明示的に設定**しなければなりません。また、`useState` で個別にフォーム状態を管理する場合も、対応するDTOの全プロパティが「State初期化」「UI入力」「Submit payload」の3箇所すべてに存在することを保証しなければなりません。
*   **Action**:
    1.  **Exhaustive DefaultValues**: `Controller` または `register` で `name` を指定した全フィールドが `defaultValues` に存在することを保証してください。`defaultValues` に含まれないフィールドは初期値が `undefined` となり、DBからデータが返されてもUIが空白のままになります（Ghost Mapping）。
    2.  **Tab/Sub-Component Synchronization**: フォームがタブやサブコンポーネントに分割されている場合、子コンポーネント内の全ての `name` 指定を走査し、ルートの `defaultValues` と同期させてください。`useFormContext` はデータの読み書きを委譲しますが、初期化責任はルートコンポーネントにあります。
    3.  **DTO-Form Naming Alignment**: DTOのプロパティ名、Zodバリデーションスキーマのキー名、およびフォームの `name` 属性は**100%一致**させなければなりません。レイヤー間でのリネーム（例: `dog_description` → `description_dog`）は、データマッピングの不整合を引き起こすため禁止です。
    4.  **Schema Addition Protocol**: DTOまたはZodスキーマにフィールドを追加した際は、必ず `defaultValues` にも同時に追加することを鉄則としてください。この同期漏れは「保存したのに一部反映されない」という最も発見が困難なバグの原因です。
    5.  **Vertical Synchronization Audit**: フィールドの欠落を疑う際は、**DB Schema → DTO → Gateway → Validation → Form** の全レイヤーを垂直に検証してください。UIにのみ存在しDBに未実装の「Phantom Field」を発見した場合は、UIから削除してください。
*   **Rationale**: `defaultValues` の欠落は、「データはDBに正しく保存されているのにUIに表示されない」「保存時に既存データが空で上書きされる（Ghost Write）」という2方向の致命的なバグを引き起こします。特に複数タブ構成の大規模フォームでは、タブ追加時のフィールド同期漏れが頻発するため、構造的なチェックプロセスが不可欠です。

### 14.23. The Conditional Security Bypass Ban（条件付きセキュリティバイパス禁止）
*   **Law**: 特権クライアント（Service Role等）を呼び出すアクション層において、データのステータス（下書き/公開等）や重要度に関わらず、**ベースラインとなる認証・認可チェックを省略してはなりません**。ステータスによる認証強度の切り替え（OTPの有無等）は許容されますが、「誰が実行しているか」のアイデンティティ検証は全コードパスで共通化・強制化しなければなりません。
*   **Action**:
    1.  **Unconditional Base Guard**: Server Action内で特権操作を行う全てのコードパスにおいて、`ensureAdminAction()` 等のベースライン認証チェックを**条件分岐の外側**（最初の行）で実行してください。`if (status === 'public') { ensureAuth() }` のように条件付きでガードを適用するパターンは禁止です。
    2.  **Defense in Depth**: ステータスに応じた追加検証（OTP、Turnstile等）は、ベースラインチェックの**上に重ねる形**で実装してください。追加検証がベースラインの代替になってはなりません。
    3.  **Branch Audit**: 条件分岐（`if/else`, `switch`）を持つServer Actionの全ブランチを走査し、いずれかのブランチで認証チェックが欠落していないか定期的に監査してください。
    4.  **Error Symmetry**: 認証ガードが例外をスローする場合、クライアントサイドでそのエラーを適切にキャッチし、UIに表示する仕組みを**同時に整備**してください。サーバーサイドのみを強化し、クライアントサイドのエラーハンドリングを未整備のままにすると、認証エラーが無限ループやフリーズを引き起こす場合があります。
*   **Rationale**: 特権クライアント（`service_role`）はRLSをバイパスするため、アプリケーション層の認証チェックがデータ保護の最後の防衛線となります。特定のステータスに対して認証を省略すると、そのコードパスを通じて認証されたユーザーが管理者権限なしに特権操作を実行できる「権限昇格脆弱性」が生まれます。

### 14.24. The Validation Visibility Mandate（バリデーション可視化義務）
*   **Law**: フォーム送信関数（`handleSubmit` 等）には、バリデーション成功時のハンドラだけでなく、**バリデーション失敗時のハンドラ（`onInvalid`）を必ず設定**し、エラー内容をログまたはUIで可視化しなければなりません。
*   **Action**:
    1.  **Always Set onInvalid**: `form.handleSubmit(onValid, onInvalid)` の第2引数を省略しないでください。省略すると、バリデーションエラーが発生してもユーザーには「ボタンを押しても何も起きない」としか認識されず、原因特定が著しく困難になります。
    2.  **Error Logging**: `onInvalid` ハンドラ内では、エラーオブジェクトをコンソールまたは構造化ログに出力し、どのフィールドのどのバリデーションルールが失敗したかを開発環境で即座に特定できるようにしてください。
    3.  **User Notification**: 本番環境では、トースト通知等でユーザーに「入力内容に不備があります」と伝え、エラーのあるフィールドまでスクロールする等のUXを提供してください。
    4.  **Schema-Form Sync Audit**: バリデーションエラーが頻発する場合、Zodスキーマの制約とフォームのデータ構造（特にJSONBフィールドやネストされたオブジェクト）に不整合がないか確認してください。過度に厳格なスキーマ（例: `z.record(z.string(), z.boolean())`）が、実際のフォームデータの構造と合致しないケースが頻出します。
*   **Rationale**: 大規模な管理画面フォームでは、目に見えないフィールドや最近追加されたフィールドのバリデーションエラーが原因で「ボタンが効かない」不具合が頻発します。`onInvalid` ハンドラの欠落は、本来数秒で解決できるバリデーションエラーを、数時間のデバッグ作業に変えてしまう元凶です。

### 14.25. The Recursive Field Initialization Guard（配列フィールド初期化ガード）
*   **Law**: `useFieldArray` の `fields` オブジェクトを `useEffect` の依存配列に含め、その中で `prepend`, `append`, `move`, `remove` 等のフィールド操作メソッドを呼び出すことを**禁止**します。フィールド配列の構造補正（標準項目の先頭挿入等）は、`useRef` によるワンタイム初期化ガードで一度だけ実行しなければなりません。
*   **Action**:
    1.  **Fields Dependency Ban**: `useEffect` の依存配列に `fields`（`useFieldArray` の戻り値）を含めないでください。`fields` はフィールド操作のたびに新しい参照を返すため、操作→参照更新→再実行→操作の無限ループ（`Maximum update depth exceeded`）を引き起こします。
    2.  **Ref-Based One-Time Guard**: フィールド配列の初期状態を検証・補正する必要がある場合は、`useRef(false)` で初期化フラグを作成し、`useEffect(() => { if (!isInitialized.current) { /* 補正ロジック */ isInitialized.current = true; } }, [])` のパターンで一度だけ実行してください。
    3.  **Empty Dependency Array**: 初期化用の `useEffect` は原則として空の依存配列 `[]` を使用してください。`fields` の変化に応じた動的な処理が必要な場合は、`useEffect` ではなく `form.watch` のサブスクリプションパターンを使用してください。
    4.  **Cascading Failure Awareness**: この無限ループはブラウザのメインスレッドを占有し、保存ボタンや認証フローなど他の非同期処理を完全にブロックします。影響範囲がコンポーネント内に限定されないことを認識してください。
*   **Rationale**: `useFieldArray` の `fields` は操作のたびに新しい配列参照を生成するため、`useEffect` の依存配列に含めると、フィールド操作→再レンダリング→`useEffect`再実行→フィールド操作の無限再帰が発生します。この問題はReact Hook Formの既知の設計特性であり、公式ドキュメントでも依存配列への `fields` の直接使用は推奨されていません。
