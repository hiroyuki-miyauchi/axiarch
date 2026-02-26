# 33. Webフロントエンドエンジニアリング (Web Frontend Engineering - Next.js)

### 14.17. The useFieldArray Initialization Guard（配列フィールド初期化ガード）
*   **Law**: `useFieldArray` の `fields` を `useEffect` の依存配列に含め、その `useEffect` 内でフィールドを操作（`append`, `prepend`, `move`, `remove` 等）することを**禁止**します。
*   **Action**:
    1.  **No Fields in Deps**: `useEffect(() => { prepend(defaultItem) }, [fields])` のパターンは禁止です。フィールド操作が `fields` 配列を更新し、それが `useEffect` を再トリガーし、`Maximum update depth exceeded` の無限ループを引き起こします。
    2.  **Ref-Based Guard**: フィールドの初期化（デフォルト項目の追加、順序の補正等）は `useRef` による一回性フラグで制御してください。`isInitialized.current` が `false` の場合のみ操作を実行し、完了後に `true` に設定します。
    3.  **Mount-Only Effect**: 初期化ロジックの `useEffect` は空の依存配列 `[]` を使用し、マウント時に一度だけ実行されるようにしてください。
    4.  **Cascading Awareness**: この無限ループはブラウザのメインスレッドを占有し、保存ボタンや他の非同期処理（認証フロー等）を完全にブロックすることを認識してください。
*   **Rationale**: `useFieldArray` はフォームの配列データを管理する強力なフックですが、そのライフサイクルに `useEffect` で干渉すると、Reactのレンダリングサイクルと衝突します。特に「構造の補正」（必須項目の先頭への挿入等）は初期化時の一回性が保証されなければなりません。

### 14.18. The Stacking Context Sovereignty（スタッキングコンテキスト主権）
*   **Law**: 追従ヘッダー、モーダル、オーバーレイ等の `z-index` と、通常のページコンテンツ内の `z-index` の**競合を構造的に防止**しなければなりません。通常コンテンツには原則として明示的な `z-index` を付与しないでください。
*   **Action**:
    1.  **Layer Hierarchy**: プロジェクト全体で `z-index` の階層を定義してください（例: コンテンツ = auto/0, 追従ヘッダー = 10, ドロップダウン = 20, モーダル = 30, トースト = 40）。
    2.  **No Casual Z-Index**: 通常コンテンツ内の要素（カード、アイコン、バッジ等）に `z-index` を設定することを原則禁止します。`position: relative` と組み合わせた `z-index` が不意にスタッキングコンテキストを生成し、追従ヘッダーを「突き抜ける」原因となります。
    3.  **Context Isolation**: コンテンツ領域にスタッキングコンテキストが必要な場合は、`isolation: isolate` を親要素に設定し、子要素の `z-index` がグローバルな階層を汚染しないようにしてください。
    4.  **Scroll Awareness**: スクロール可能なコンテンツ内に `position: absolute` と `z-index` を持つ要素がある場合、スクロール時に追従ヘッダーの上に表示されないことをテストしてください。
*   **Rationale**: `z-index` の競合は「スクロールすると特定の要素がヘッダーを突き抜ける」という視覚的に目立つバグを引き起こしますが、原因の特定が困難です。特にコンポーネントベースの開発では、各コンポーネントが独自に `z-index` を設定することで、グローバルな階層が破壊されやすくなります。

### 14.19. The Subscription Timer Sanitization Protocol（サブスクリプションタイマー衛生化）
*   **Law**: `form.watch()` のサブスクリプションコールバックや `WebSocket` のメッセージハンドラ等、**外部イベントリスナー内で `setTimeout` / `setInterval` を使用する場合**、タイマーIDを `useRef` で管理し、コールバックの冒頭で前回のタイマーを必ずクリアしなければなりません。
*   **Action**:
    1.  **Ref-Based Timer Management**: `const timerRef = useRef<NodeJS.Timeout | null>(null)` でタイマーIDを保持し、コールバック内で `if (timerRef.current) clearTimeout(timerRef.current)` を実行してから新しいタイマーを設定してください。
    2.  **No Closure Timer**: ローカル変数（`let timer`）でタイマーを管理するパターンは禁止です。サブスクリプションコールバックはクロージャを跨いで複数回呼ばれるため、ローカル変数では前回のタイマー参照が失われ、クリアが不可能になります。
    3.  **Cleanup on Unmount**: `useEffect` のクリーンアップ関数でサブスクリプションの解除と同時に `clearTimeout(timerRef.current)` を実行し、コンポーネントのアンマウント時にタイマーを確実に破棄してください。
    4.  **Debounce Awareness**: オートセーブ等のデバウンス処理では、このパターンが唯一安全な実装方法です。`useCallback` + `setTimeout` の組み合わせは依存配列の変更時にタイマーリークを引き起こします。
*   **Rationale**: サブスクリプション（`form.watch(callback)` 等）内のタイマーはReactの通常のライフサイクル管理の外にあるため、`useEffect` のクリーンアップだけではリークを防止できません。`useRef` による明示的なタイマー管理は、競合状態とメモリリークの両方を構造的に回避する唯一のパターンです。

### 14.20. The Resilient RSC Data Access Protocol（RSCデータアクセス防御）
*   **Law**: React Server Component（RSC）やストリーミングSSRにおいて、データ取得結果が `null` / `undefined` となる可能性がある場合、**プロパティアクセス前に必ずnullガード**を実装しなければなりません。未ガードのnullアクセスはRSCストリームをクラッシュさせます。
*   **Action**:
    1.  **Early Return Guard**: Server Componentの冒頭でデータ取得を行い、結果が `null` の場合は `notFound()` または適切なフォールバックUIを即座に返却してください。`null` のまま子コンポーネントへpropsを渡すことは禁止です。
    2.  **Non-Null Assertion Ban**: データ取得結果に対する `data!.property`（Non-null Assertion）の使用を禁止します。型システム上は安全に見えますが、実行時のnullは型を貫通してストリームをクラッシュさせます。
    3.  **Error Boundary Integration**: RSCのエラーは通常のReactエラーバウンダリでキャッチされないことがあります。`error.tsx` / `not-found.tsx` を適切に配置し、ストリーミングエラー時のユーザー体験を保証してください。
    4.  **Opaque Error Awareness**: RSCストリームのクラッシュは、ブラウザコンソールに `TypeError` ではなく不透明なネットワークエラー（`Failed to fetch`等）として表示されるため、原因特定が困難です。サーバーログを一次情報源としてください。
*   **Rationale**: 従来のクライアントサイドレンダリングでは `null` アクセスは該当コンポーネントのみをクラッシュさせますが、RSCではストリーム全体が中断されるため、ページ全体が白画面またはネットワークエラーとなります。この影響範囲の違いを理解し、防御的なコーディングを徹底する必要があります。

### 14.21. The Dynamic Library Decoupling Protocol（重量ライブラリ遅延読込義務）
*   **Law**: 50KB超の重量ライブラリ（リッチテキストエディタ、チャートライブラリ、マップSDK、構文ハイライタ等）は、初期バンドルに含めることを禁止します。必ず**動的インポート**（`next/dynamic`, `React.lazy`, `import()` 等）で遅延読み込みしてください。
*   **Action**:
    1.  **Bundle Analysis**: `next build` の出力または `@next/bundle-analyzer` 等のツールで各チャンクのサイズを定期的に監視してください。50KB超のクライアントサイドチャンクは最適化候補です。
    2.  **Dynamic Import with SSR Control**: SSR不要のクライアント専用ライブラリには `dynamic(() => import('...'), { ssr: false })` を使用し、サーバーサイドでのバンドル・評価を回避してください。
    3.  **Loading Skeleton**: 動的インポートのフォールバックには、フルサイズのスピナーではなく、コンテンツの形状を模倣した**Skeleton UI**を表示し、体感待ち時間を最小化してください。
    4.  **Preload Hint**: ユーザー操作で確実に必要になるライブラリは、`prefetch` / `preload` ヒントを用いて、ユーザー操作の前からバックグラウンドで読み込みを開始してください。
*   **Rationale**: 初期バンドルサイズの肥大化は、TTI（Time to Interactive）を直接悪化させ、Core Web Vitalsのスコアを低下させます。重量ライブラリの遅延読込は、初期表示パフォーマンスとユーザー体験の両方を保護する必須の設計パターンです。
