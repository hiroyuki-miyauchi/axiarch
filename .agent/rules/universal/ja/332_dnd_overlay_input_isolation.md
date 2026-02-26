# 33. Webフロントエンドエンジニアリング (Web Frontend Engineering - Next.js)

### 14.11. The DnD Overlay Input Isolation Protocol（DnDオーバーレイ入力隔離義務）
*   **Law**: ドラッグ&ドロップ（DnD）ライブラリのDragOverlay（ドラッグ中に表示されるゴースト要素）内に、`<input>`, `<select>`, `<textarea>` などのフォーム入力要素をそのままレンダリングしてはなりません。
*   **Action**:
    1.  **Render-Only Overlay**: DragOverlay内のコンポーネントは、**表示専用**のビュー（テキスト表示、アイコン等）に限定してください。
    2.  **Name Collision Prevention**: フォーム入力要素がOverlayにクローンされると、同一 `name` 属性を持つ `<input>` がDOM上に重複登録され、フォームライブラリのデータ整合性が破壊されます。
    3.  **Conditional Rendering**: DragOverlay用のレンダリングパスでは、入力要素を除外するフラグ（`isOverlay` props等）を使用してフォーム要素の描画を抑制してください。
*   **Rationale**: DnDのDragOverlayは、ドラッグ中のアイテムの「視覚的なコピー」をDOMに追加します。このコピーにフォーム要素が含まれると、React Hook Form等のフォームライブラリはDOM上に同名の入力フィールドが2つ存在する状態となり、値の二重登録やバリデーションの誤作動を引き起こします。

### 14.12. The Form DefaultValues Completeness Mandate（フォーム初期値完全性義務）
*   **Law**: React Hook Form 等のフォームライブラリを使用する際、`defaultValues` にはフォームが使用する**全てのフィールド**を明示的に設定しなければなりません。フィールドの追加・変更時は、**Schema（バリデーション定義）+ defaultValues（初期値）+ Controller/Input（UI描画）の3点同時更新**を義務付けます。
*   **Action**:
    1.  **Exhaustive DefaultValues**: `useForm({ defaultValues: { ... } })` に、フォームで使用する全フィールドの初期値を列挙してください。省略されたフィールドは `undefined` となり、Controlled Component では予期せぬ挙動を引き起こします。
    2.  **Three-Point Sync**: フィールドを追加する際は、以下の3箇所を同時に更新してください。
        *   **Schema**: Zod / Yup 等のバリデーションスキーマ
        *   **DefaultValues**: `useForm` の `defaultValues` オブジェクト
        *   **UI**: `Controller` / `register` によるフォーム入力コンポーネント
    3.  **Type-Safe DefaultValues**: `defaultValues` の型は、Schema から自動推論される型（例: `z.infer<typeof schema>`）と一致させてください。手動で型を定義して乖離させることは禁止です。
*   **Rationale**: `defaultValues` の不完全さは、「フォームを開いた直後は正常だが、特定のフィールドだけ保存されない」というサイレントバグの最大の原因です。3点同時更新を徹底することで、この種のバグを構造的に防止します。

### 14.13. The Deep Type Recursion Break Protocol（深層型再帰分断プロトコル）
*   **Law**: TypeScript の型ジェネリクスが深すぎるために発生する型再帰エラー（`Type instantiation is excessively deep`）に対して、`any` 型への逃避を禁止します。型の安全性を維持しながら再帰の深度を制限する手法を用いてください。
*   **Action**:
    1.  **Bounded Generic**: 深すぎるジェネリクスに対しては、`Record<string, unknown>` 等の「緩いが安全な型」を中間境界として使用し、境界の内側で型ガードまたは明示的なキャストを行ってください。
    2.  **No `any` Escape**: `any` への型バイパスは型安全性の完全な放棄です。代わりに `unknown` を使用し、型ガード（Type Guard）関数で安全に型を絞り込んでください。
    3.  **Library Type Wrapper**: サードパーティライブラリの型定義が深すぎる場合は、ラッパー型を定義してジェネリクスの深度を制限してください。
    4.  **Diagnostic**: エラー発生時は、TypeScript Compiler の `--generateTrace` オプションを使用して、どの型定義が再帰の原因かを特定してください。
*   **Rationale**: `any` への逃避は「コンパイラを黙らせる」だけで、実行時の型安全性を完全に破壊します。`unknown` + 型ガードのパターンは、コンパイル時と実行時の両方で安全性を担保できます。

### 14.14. The Strict DTO Boundary Protocol（DTO境界の型誠実化プロトコル）
*   **Law**: 外部データソース（データベース、外部API、ファイルシステム等）から取得した「緩い型」のデータを、アプリケーション内部の「厳格な型」に変換する際、**入力境界で `unknown` 型を経由**し、型ガードまたはバリデーション関数を通じて安全に変換しなければなりません。
*   **Action**:
    1.  **Unknown First**: 外部ソースから取得した JSON データ等は、まず `unknown` 型として受け取り、バリデーション（Zod `parse` 等）を通じてアプリケーション型に変換してください。
    2.  **No Direct Cast**: `as TargetType` による直接キャストを禁止します。これはデータの構造が期待通りであることを検証せずに型を付与する行為であり、ランタイムエラーの直接的な原因です。
    3.  **Mapper Function**: DB レコード → DTO の変換は、専用のマッパー関数（例: `toStoreDto(row: DatabaseRow): StoreDto`）を通じて行い、変換ロジックを一箇所に集約してください。
    4.  **Nullable Safety**: 外部データの `null | undefined` を適切にハンドリングし、アプリケーション型ではデフォルト値を提供するか、明示的にオプショナル（`?`）として定義してください。
*   **Rationale**: データベースの JSON カラムや外部 API のレスポンスは、型定義と実際のデータ構造が乖離する可能性が常にあります。`unknown` を経由することで、「型が正しいはず」という仮定に依存しない、防御的なコードを実現します。

### 14.15. The Watch Subscription Safety Protocol（form.watch安全プロトコル）
*   **Law**: React Hook Form の `form.watch()` の戻り値、または `form` オブジェクト全体を `useEffect` の依存配列に含めることを**禁止**します。これらは参照が毎レンダリングで変わるため、無限ループの直接的な原因となります。
*   **Action**:
    1.  **No Watch in Deps**: `const values = form.watch(); useEffect(() => { ... }, [values])` のパターンは禁止です。`watch()` の戻り値はレンダリングのたびに新しいオブジェクト参照を返すため、`useEffect` が毎回トリガーされます。
    2.  **Subscription Pattern**: フォーム値の変更を監視する場合は、`useEffect` 内で `form.watch((value, { name }) => { ... })` のコールバック形式を使用し、サブスクリプションの返り値（unsubscribe関数）をクリーンアップで呼び出してください。
    3.  **Targeted Watch**: 特定のフィールドのみ監視する場合は `form.watch('fieldName')` を使用し、依存配列には個々のプリミティブ値のみを含めてください。
    4.  **Form Object Stability**: `form` オブジェクト自体も `useEffect` の依存配列に含めないでください。`useForm` のオプション変更等でインスタンスが再生成されると、同様の無限ループが発生します。
*   **Rationale**: `useEffect` の依存配列にオブジェクト参照を含めると、Reactの浅い比較（`Object.is`）により毎レンダリングで「変更あり」と判定され、Effect が無限に実行されます。これは React Hook Form に限らず、全ての「オブジェクトを返すフック」に共通するアンチパターンです。

### 14.16. The handleSubmit Validation Visibility Mandate（バリデーション失敗可視化義務）
*   **Law**: `form.handleSubmit(onSuccess)` を使用する際は、**必ず第2引数 `onInvalid` ハンドラを指定**し、バリデーション失敗時のエラー内容を開発者およびユーザーに可視化しなければなりません。
*   **Action**:
    1.  **Mandatory onInvalid**: `form.handleSubmit(onSuccess, onInvalid)` の形式で、バリデーションエラー時のハンドラを必ず実装してください。`onInvalid` が未指定の場合、バリデーションエラーが発生しても「何も起きない」サイレントバグとなります。
    2.  **Error Logging**: `onInvalid` ハンドラ内で `console.error('Validation Errors:', errors)` を出力し、どのフィールドがバリデーションに失敗したかを即座に特定可能にしてください。
    3.  **User Feedback**: 管理画面のような大規模フォームでは、トースト通知で「バリデーションエラーがあります」と表示し、エラーのあるフィールドへのスクロールまたはハイライトを実装してください。
    4.  **Schema Sync**: `handleSubmit` が「黙って」動かない場合は、Zodスキーマとフォームデータの構造不一致を疑い、特にJSONBフィールドや動的に追加されたフィールドのスキーマ定義を確認してください。
*   **Rationale**: 巨大なフォーム（複数タブ、数十フィールド）では、目に見えないフィールドや最近追加されたフィールドのバリデーションエラーが原因で「ボタンが効かない」不具合が頻発します。`onInvalid` の未指定は、デバッグの最も基本的な手がかりを放棄する行為です。
