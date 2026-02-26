# 33. Webフロントエンドエンジニアリング (Web Frontend Engineering - Next.js)

### 14.26. The Stacking Context Safety Protocol（スタッキングコンテキスト安全性）
*   **Law**: 追従ヘッダー、モーダル、ドロワー等の**固定配置UI要素**の下に配置されるべき通常コンテンツ内の要素に、明示的な `z-index` を付与することを**原則禁止**します。z-indexの競合による「突き抜け」レイアウト崩れを構造的に防止してください。
*   **Action**:
    1.  **Default Layer Maintenance**: 通常のコンテンツ領域内の要素（カード、バッジ、チェックアイコン等）は、z-indexを未指定（デフォルト: auto/0相当）のまま維持してください。コンテンツ内で `z-10` 以上を付与すると、追従ヘッダー（同 `z-10` 等）と同一レイヤーで競合し、スクロール時に「突き抜ける」現象を引き起こします。
    2.  **Layering Hierarchy Definition**: プロジェクト内で z-index の階層定義を策定してください（例: コンテンツ層 = 0-9、追従ヘッダー = 10-19、ドロワー = 20-29、モーダル = 30-39、トースト = 40-49）。全てのコンポーネントはこの階層に従って z-index を設定してください。
    3.  **Periodic Audit**: スクロール可能なコンテンツ領域内に `z-index` が付与された要素がないか、定期的にコードベースを走査してください。特に `position: absolute` または `position: relative` と組み合わさった `z-index` は「突き抜け」の最も一般的な原因です。
    4.  **Isolation Strategy**: コンテンツ内で要素の重なり順を制御する必要がある場合は、`isolation: isolate` を親要素に適用し、新しいスタッキングコンテキストを作成することで、z-indexの影響範囲をその親要素内に限定してください。
*   **Rationale**: z-index は同一スタッキングコンテキスト内で相対的に評価されるため、コンテンツ内の要素に不用意に高い値を設定すると、追従ヘッダーやモーダルといったUI要素と同一レイヤーで競合します。DOMツリー上の位置によって予測不可能な表示順序となり、特にスクロール時に「チェックアイコンがヘッダーの上に重なる」等のレイアウト崩れが発生します。

### 14.27. The CSS Class Merge Utility Protocol（CSSクラスマージユーティリティ義務）
*   **Law**: Tailwind CSS等のユーティリティファーストCSSフレームワークにおいて、条件付きでクラスを適用する場合、**テンプレートリテラルや文字列連結による手動結合を禁止**します。`cn()` / `clsx` + `tailwind-merge` 等の専用マージユーティリティの使用を義務付けます。
*   **Action**:
    1.  **Utility Function Mandate**: プロジェクトの共有ユーティリティとして `cn()` 関数（`clsx` + `tailwind-merge` の組み合わせ）を定義し、全コンポーネントでこれを使用してください。`className={`px-4 ${isActive ? 'bg-blue-500' : ''}`}` のようなテンプレートリテラルはクラスの競合を検知できません。
    2.  **Conflict Resolution**: `tailwind-merge` は同一CSSプロパティに対する複数のユーティリティクラス（例: `px-4` と `px-8`）が渡された場合、後勝ちのルールで自動的に解決します。手動結合ではこの解決が行われず、予測不可能なスタイルが適用されます。
    3.  **Empty String Prevention**: 条件が `false` の場合に空文字列 `''` や `undefined` がクラスリストに混入しないよう、`cn()` または `clsx` でこれらを自動的にフィルタリングしてください。
    4.  **Component Props Pattern**: コンポーネントが外部から `className` を受け取る場合は、`cn(baseClasses, className)` のパターンで内部クラスと外部クラスをマージしてください。
*   **Rationale**: CSS Utility Classの手動結合は、クラスの重複・競合を検知できず、スタイルの優先順位が予測不可能になります。特に Tailwind CSS では同一CSSプロパティに対する複数のユーティリティが渡された場合、CSSの詳細度ではなくスタイルシート内の出現順序で決まるため、見た目上正しく見えるコードが本番で異なるスタイルを適用するサイレントバグの原因となります。

### 14.28. The Explicit Initial State Typing Mandate（useState型明示義務）
*   **Law**: React Hooksの `useState` に空配列 `[]`、`null`、または初期値から推論が困難な値を渡す場合、**ジェネリクス型パラメータを明示的に指定**しなければなりません。型推論に頼った暗黙的な初期化を禁止します。
*   **Action**:
    1.  **Empty Array Typing**: `useState([])` を禁止し、`useState<Item[]>([])` のように要素型を明示してください。型パラメータを省略すると TypeScript は `never[]` を推論し、後続の `setState(items)` 呼び出しで型エラーが発生します。
    2.  **Nullable State Typing**: `useState(null)` を禁止し、`useState<User | null>(null)` のようにnull以外の型を明示してください。省略すると `null` リテラル型が推論され、nullでない値の代入が型エラーとなります。
    3.  **Complex Object Typing**: オブジェクトの初期値（`useState({})`）を使用する場合は、`useState<FormState>({})` のように具体的な型を指定してください。空オブジェクトからの推論では必要なプロパティが型に含まれません。
    4.  **Primitive Exception**: `useState(0)`, `useState('')`, `useState(false)` 等のプリミティブ値は、推論が正確であるため型パラメータの明示は任意です。
*   **Rationale**: TypeScriptの型推論は初期値から型を導出しますが、`[]` は `never[]`、`null` は `null` リテラル型と推論されます。これにより、実際にデータを代入する時点で型不整合が発覚し、開発者は `as` キャストに逃げるか、型エラーを無視する悪循環に陥ります。初期化時点での型明示により、この問題を根本から防止します。

### 14.29. The Compiler Readiness Protocol（コンパイラ互換性準備義務）
*   **Law**: React Compiler等の次世代コンパイラ最適化ツールへの将来的な移行に備え、**手動の `useMemo` / `useCallback` の過剰使用を避け**、コンパイラ互換のコーディングパターンを推奨します。
*   **Action**:
    1.  **Avoid Premature Memoization**: パフォーマンス問題が計測により確認される前に、予防的に `useMemo` / `useCallback` を適用することを避けてください。コンパイラはこれらの最適化を自動的に行う能力を持ち、手動メモ化はコンパイラの最適化を妨害する可能性があります。
    2.  **Pure Function Preference**: コンポーネントを可能な限り**純粋関数**として実装してください。副作用を `useEffect` に集約し、レンダリングロジックを副作用フリーに保つことで、コンパイラの静的解析が正確に機能します。
    3.  **Stable Reference Pattern**: オブジェクトや配列をレンダリング中に再生成する代わりに、モジュールスコープの定数として定義するか、`useRef` で安定した参照を維持してください。
    4.  **Migration Path**: 既存の `useMemo` / `useCallback` を即座に削除する必要はありません。新規コードでは過剰な手動メモ化を避け、パフォーマンスプロファイリングで必要性が確認された箇所のみに適用してください。
*   **Rationale**: React Compilerは関数コンポーネントの自動メモ化を実現しますが、手動で `useMemo` / `useCallback` が適用されたコードでは、コンパイラの最適化と手動最適化が二重に適用される可能性があり、かえってパフォーマンスが劣化するリスクがあります。コンパイラ互換のコーディングスタイルを今から採用することで、将来の移行コストを最小化します。

### 14.30. The Server Cookie Write Authority Protocol（Cookie書き込み権限分離）
*   **Law**: Cookie・レスポンスヘッダーの書き込み（Set/Delete）は、**Server Action** または **Route Handler（API Routes）** 内に限定します。Server Component（`page.tsx`, `layout.tsx`）のレンダリング中にCookieの書き込みを行うことを**禁止**します。
*   **Action**:
    1.  **Read Only in RSC**: Server Components は原則として Cookie の**読み取り（`cookies().get()`）のみ**を行ってください。レンダリング中のCookie書き込みはフレームワークの仕様上不安定であり、ストリーミングSSR環境では予測不可能な副作用を引き起こします。
    2.  **Write Authority**: Cookie の書き込み（Set/Delete）は、必ず Server Action（`'use server'`）または Route Handler（`route.ts`）内で行ってください。これらは明確なリクエスト-レスポンスサイクルを持ち、Cookieの操作が安全に実行されます。
    3.  **Session Management**: 認証セッションの更新（トークンリフレッシュ等）は、Middleware または Server Action で行い、レンダリングパイプラインから分離してください。
    4.  **Testing**: Cookie操作を含むServer Actionは、Cookie状態の変更後に期待される挙動（リダイレクト、セッション状態の反映等）を自動テストで検証してください。
*   **Rationale**: Server Component（RSC）のレンダリングはストリーミング的に行われる場合があり、レスポンスヘッダーがすでに送信された後にCookieを設定しようとすると、無視されるかエラーになります。書き込み権限をServer Action / Route Handlerに明確に限定することで、この不安定な挙動を構造的に排除します。
