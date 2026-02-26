# 33. Webフロントエンドエンジニアリング (Web Frontend Engineering - Next.js)

### 14.5. The Strict Action Return Type Mandate（Server Action戻り値型厳格化）
*   **Law**: 全てのServer Action（またはAPI呼び出し関数）は、厳格な戻り値型（`ActionResult` 形式等）を定義しなければなりません。`Promise<any>` や型定義なしの戻り値を禁止します。
*   **Action**:
    1.  **Unified Return Shape**: 戻り値は `{ success: boolean; data?: T; error?: string; errorDetails?: Record<string, string> }` のような一貫した構造に統一してください。
    2.  **All Paths Covered**: Action内の全てのreturnパスが同一の型構造を返すことを保証してください。一部のパスで `success` プロパティが欠落する等の不整合は、UI側の `undefined` 参照エラーの直接原因です。
    3.  **No UI-Side Casting**: UI側で `(result as any).error` のようなキャストを禁止します。型が合わない場合は、Action側の戻り値型を修正してください。
*   **Rationale**: Server ActionとUIの間の型不整合は、TypeScriptの型安全性を根底から破壊します。厳格な戻り値型は、Backend-Frontend間の「型による契約」です。

### 14.6. The Reactive Subscription Safety Protocol（リアクティブ監視安全性）
*   **Law**: リアクティブなオブザーバ（`watch()`, `subscribe()`, `onSnapshot()` 等）の戻り値を `useEffect` の依存配列に直接含めることを禁止します。これらのAPIは呼び出しのたびに新しいオブジェクト参照を生成するため、依存配列に含めると無限再レンダリングループが発生します。
*   **Action**:
    1.  **Callback Subscription Pattern**: `useEffect` の依存配列で監視結果を追跡するのではなく、**コールバック方式のサブスクリプション**を使用してください。`useEffect` 内でサブスクリプションを開始し、クリーンアップ関数で `unsubscribe()` を呼び出してください。
    2.  **Stable Dependencies Only**: `useEffect` の依存配列には、安定した参照（フォームオブジェクト自体、プリミティブ値等）のみを含めてください。
    3.  **Timer Sanitization (useRef Pattern)**: サブスクリプションコールバック内でタイマー（`setTimeout` / `setInterval`）を使用する場合は、必ず `useRef` でタイマーIDを管理し、コールバックの冒頭で `clearTimeout` を行うことで、真正のデバウンスを実現してください。未クリーンアップのタイマーは、大量の非同期処理のスタックとメモリリークの直接原因です。
*   **Rationale**: リアクティブライブラリの多くは、値の変更を通知するために内部的に新しいオブジェクトを生成します。この「不安定な参照」をReactの依存追跡メカニズムに接続すると、「値は同じだが参照が異なる」→「再実行」→「状態更新」→「再レンダリング」→「新しい参照」という無限ループが構造的に完成します。
*   **Anti-Pattern**: `const values = form.watch(); useEffect(() => { save(values); }, [values])` — これは毎レンダリングで新しい参照を生成し、無限ループを引き起こします。

### 14.7. The One-Shot Initialization Guard Protocol（一回性初期化ガード）
*   **Law**: 動的配列（`useFieldArray`, 動的リスト等）の初期値の補正・並べ替えロジックは、**`useRef` ベースのフラグで一回性の実行を保証**しなければなりません。リアクティブ配列を `useEffect` の依存配列に含めた状態でその配列を変更するコードは、無限ループを生成します。
*   **Action**:
    1.  **Ref-Based Init Flag**: `const isInitialized = useRef(false)` を使用し、初期化が完了したかどうかを追跡してください。`isInitialized.current` が `false` の場合のみ補正ロジックを実行し、完了後に `true` に設定してください。
    2.  **Empty Dependency Array**: 配列補正用の `useEffect` は、依存配列を空 `[]` にするか、物理的に変化しない値（ID等）のみを含めてください。`fields` 配列そのものを依存に含めることは厳禁です。
    3.  **DTO-Form Completeness**: フォームがタブやサブコンポーネントに分割されている場合、子コンポーネントの全フィールド名がルートの `defaultValues` に存在することを保証してください。`defaultValues` にないフィールドは `undefined` として初期化され、保存時にデータ消失を引き起こします。
*   **Rationale**: `prepend` / `move` / `append` 等の配列操作は配列の参照を更新し、それが `useEffect` の再実行をトリガーします。再実行された `useEffect` がさらに配列操作を行うと、`Maximum update depth exceeded` エラーによるブラウザクラッシュが発生します。
*   **Anti-Pattern**: `useEffect(() => { if (fields[0]?.type !== 'header') prepend(headerItem); }, [fields])` — `fields` を監視しつつ `prepend` するため無限ループが確定します。

### 14.8. The Validation Error Transparency Mandate（バリデーションエラー透明性義務）
*   **Law**: フォームの送信ハンドラ（`handleSubmit` 等）には、**成功コールバックだけでなく、バリデーション失敗時のコールバック（`onInvalid`）を必ず設定**しなければなりません。「ボタンを押しても何も起きない」原因の大半は、サイレントなバリデーション失敗です。
*   **Action**:
    1.  **Always Provide onInvalid**: バリデーション失敗時にエラー内容をログ出力（`console.error` / `Logger.warn`）し、可能であればトースト通知でユーザーに表示してください。
    2.  **Flexible JSONB Schemas**: 動的に拡張されるJSONBフィールド（`features`, `settings` 等）のバリデーションスキーマは、過度に厳格にせず、実際のUI構造と常に同期させてください。
    3.  **Debug Visibility**: 開発環境では、バリデーションエラーの詳細（フィールド名、エラーメッセージ）を画面上にインラインで表示する仕組みを推奨します。
*   **Rationale**: フォームライブラリの`handleSubmit` は、バリデーションエラーがある場合、`onSubmit`（成功ハンドラ）を黙って呼び出しません。`onInvalid` が未設定だと、エラー内容が開発者にもユーザーにも通知されず、「ボタンが壊れている」と誤認されます。
*   **Anti-Pattern**: `form.handleSubmit(onSubmit)` — `onInvalid` が省略されているため、バリデーション失敗はサイレントに無視されます。

### 14.9. The SSR Stream Resilience Protocol（SSRストリーム耐性）
*   **Law**: サーバーサイドレンダリング（SSR/RSC）によるストリーミング中にデータ取得が失敗した場合、ブラウザ側では汎用的なネットワークエラー（404、接続リセット等）として表示され、根本原因が完全に隠蔽されます。ストリーミングコンポーネント内のデータアクセスには必ず防御的ガードを設けてください。
*   **Action**:
    1.  **Strict Null Guards**: データ取得後、プロパティにアクセスする前に `if (!data) return notFound()` 等のガードを必ず設置してください。`null` に対するプロパティアクセスはRSCストリーム全体をクラッシュさせます。
    2.  **Server Terminal as Primary Source**: SSRストリーミングエラーのデバッグでは、ブラウザコンソールではなく、**サーバー端末の出力を一次診断情報源**として活用してください。ブラウザ側のエラーは意図的にサニタイズされ、具体性を欠きます。
    3.  **Gateway Instrumentation**: データアクセス層（Gateway）の `catch` ブロックでは、エラーオブジェクトから `code`, `message` を明示的に抽出してログ出力してください。`[object Object]` をそのまま出力することは禁止です。
*   **Rationale**: SSRストリーミングは、サーバー上でHTMLの生成中にクラッシュが発生するため、従来のSSRとは異なり、ブラウザには「ストリームが途中で切断された」という汎用エラーしか届きません。これにより、根本原因（データ不在、権限不足、スキーマ不一致等）の特定が極めて困難になります。

### 14.10. The Non-Blocking Edge Middleware Protocol（ノンブロッキングMiddleware義務）
*   **Law**: Edge Middleware（またはリクエスト前処理レイヤー）において、分析ログの記録、使用量計測、アクセス統計の更新など、**メインレスポンスに影響しない副次的なDB書き込み**は `event.waitUntil()` で非同期化してください。`await` でブロックすることは、全リクエストのレスポンス遅延を招きます。
*   **Action**:
    1.  **Classification**: Middleware内のDB操作を「Critical（認証チェック等）」と「Non-Critical（ログ記録等）」に分類してください。
    2.  **waitUntil for Non-Critical**: Non-Criticalな操作は `event.waitUntil(promise)` でバックグラウンド実行し、レスポンスを即座に返してください。
    3.  **Error Isolation**: `waitUntil` 内の失敗がメインレスポンスに影響しないよう、`try-catch` で独立したエラーハンドリングを設けてください。
*   **Rationale**: Edge Middlewareは全リクエストのホットパスに位置するため、ここでの遅延はアプリケーション全体のパフォーマンスに直結します。非同期化により、ログ記録の失敗がユーザーのページ表示を妨げることを防ぎます。
