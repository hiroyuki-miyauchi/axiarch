# 20. デザインとUX戦略 (Design & UX Strategy)

> [!CRITICAL]
> **Rule 20.0: The Consistency Mandate (Professionalism Protocol)**
>
> - **Law**: UI/UXの不統一は「プロ意識の欠如」である。
> - **Action**: 「この画面だけボタンが左にある」「ここだけ削除フローが違う」といった些細なズレを許容してはならない。全体の調和（Harmony）を乱す要素は、機能していようとバグである。
> - **Target**: 特に「削除」「保存」「認証」などのクリティカルなフローにおいては、ユーザーのメンタルモデルを守るため、鉄の統一（Iron Consistency）を維持せよ。

## 3. コンポーネント実装ガイド (Component Guidelines)
### 3.1. Implementation Patterns
*   **Skeleton Loader**:
    *   データ読み込み中（Suspense）は、スピナーではなく **Skeleton Screen** (`<Skeleton />`) を使用し、レイアウトシフト（CLS）を防ぎます。
*   **Feedback Hierarchy**:
    *   **Toast**: 成功・通知（非同期）。
    *   **Inline Alert**: 文脈依存のエラー。
*   **Toast Promise Standard (Async Feedback Lifecycle)**:
    *   **Law**: 非同期処理（保存・削除・送信等）において、Loading→Success→Errorのフィードバックサイクルを手動で管理することはバグの温床です。
    *   **Action**: Toastライブラリの `promise` 機能（例: `sonner.promise()`）を使用し、処理中・成功・失敗の3状態を自動的に表示してください。ユーザーは「処理中」であることを視覚的に認識し、完了または失敗の結果を確実に受け取れなければなりません。
*   **Z-Index Stratification (The Layering Law)**:
    *   **Overlay (10000)**: Select, Popover, Tooltip, Calendar 等。常に最前面。
    *   **Modal (9999)**: Dialog, Sheet 等。
    *   **Menu (1000)**: Navigation Drawer 等。
    *   **Action**: 恣意的な `z-50` 等のマジックナンバーは禁止し、この階層構造を厳守してください。
*   **Optimistic UI (楽観的更新)**:
    *   いいね等の軽量アクションは、サーバー応答を待たずに即座に表示更新し、ネイティブアプリ並みの応答速度を実現します。
*   **The Sortable Table Standard**:
    *   **Law**: 管理画面の一覧テーブル（ユーザー、商品、ログ等）において、「項目の並び替え（Sort）ができない」状態は、業務ツールとして不完全（Incomplete）です。
    *   **Action**: 必ず `SortableTableHead` コンポーネントを使用し、ヘッダークリックによるサーバーサイドソート（`sortBy`, `sortOrder`）を標準機能として実装してください。矢印アイコンの挙動やパラメータ名は全機能で統一を義務付けます。

### 3.2. The React/Hydration Hardening Protocol (Lesson 42.18)
*   **The Hooks Order Guarantee**:
    *   **Law**: React Hooks (`useEffect`, `useState`, `useQuery`) は、いかなる条件分岐（`if`, `return`）よりも**前**に記述しなければなりません。
    *   **Violation**: "Rendered more hooks than during the previous render" エラーは、早期リターン（Early Return）の後に Hooks を置いたことによる**初歩的な実装ミス**です。
    *   **Action**: 全てのコンポーネントにおいて、**Hooks 定義ブロック** を最上部に固定配置する構造を強制します。

*   **The Anchor Nesting Prohibition (Hydration Mismatch)**:
    *   **Law**: `<a>` タグの中に `<a>` タグや `<button>` を入れることは HTML 仕様違反であり、React の Hydration Mismatch の主因です。
    *   **Context**: Widget全体をリンクにしたい場合によく発生します。
    *   **Action**: ネストするのではなく、親要素に `onClick` ハンドラを設定するか、CSS (`absolute inset-0`) でリンクをオーバーレイさせる手法を使用してください。

*   **The suppressHydrationWarning Standard**:
    *   **Law**: `suppressHydrationWarning` は「魔法の杖」ではありません。
    *   **Allowed**: 日付（`Date`）、乱数、ローカルストレージ依存の初期値など、**サーバーとクライアントで値が異なることが不可避なテキストノード**にのみ使用を許可します。
    *   **Banned**: HTML構造の不一致（タグの入れ子ミス）を隠蔽するために使用することは厳禁です。

*   **The Hidden Element & Ghost Dimension Protocol**:
    *   **Law 1 (Render Cost)**: `display: none` (`hidden`) の要素は、画面上は見えませんが、Reactのレンダリングコストと仮想DOMのノード数を消費し続けます。
    *   **Action**: モバイルメニューやドロワーなど、表示頻度が低い大きな要素には `hidden` ではなく条件付きレンダリング（`{ isOpen && <Drawer /> }`）を使用し、DOMツリーをクリーンに保ってください。
    *   **Law 2 (Dimension Trap)**: 非表示状態の要素は、`width/height` が「0」として計算されます。
    *   **Action**: 初期状態で非表示の要素内で `ResizeObserver` やカルーセル、マップ等の「サイズ依存の初期化」を行う場合は、表示された瞬間に `resize` イベントを明示的に発火させるか、再マウントを強制して「表示が崩れる（Ghost Dimension）」を防いでください。

### 3.3. Layout Architecture
*   **The Single Container Protocol**:
    *   Layoutがコンテナ (`container`) を提供する場合、Page側での再定義（二重パディング）を厳禁とします。
    *   **Baseline Harmony (Filter Alignment Protocol)**:
        *   **Law**: ラベル付きの `Input` と `Button` を横並びにする際、`items-center` で中央揃えにすることを禁止します。
        *   **Action**: 必ず **`items-end`** を使用し、ラベルの高さを考慮した「下端（Baseline）揃え」を徹底してください。これにより、ピクセルパーフェクトな視覚的一貫性を保証します。`items-center` はラベルと入力の境界をあやふやにし、デザインの品位を損なう「素人仕事」とみなされます。

    *   **The Natural Scrolling Protocol (Rule 12.6)**:
        *   **Law**: `h-screen` と `overflow-y-auto` を無計画にネストさせ、二重スクロールバーを発生させることは UX の敗北です。
        *   **Action**: スクロールコンテナは画面内に**ただ一つ**（通常は `body` またはメインレイアウト）であることを原則とします。部分スクロールが必要な場合は、必ず `dvh` (Dynamic Viewport Height) を考慮し、Mobile Safari でのアドレスバー挙動を検証してください。

    *   **The Any-Screen Typography Protocol (Adaptive Scaling)**:
        *   **Law**: 固定の `text-3xl` 等の指定は、大画面では貧弱に、小画面では暴力的に働きます。
        *   **Action**: 
            1. **Adaptive Base**: 文字サイズは必ずモバイル基準（`text-xl`）から書き始め、`sm:` や `lg:` などのブレークポイントで最適化（Scaling）を行うことを義務付けます。
            2. **Visual Hierarchy**: 画面サイズが変わっても「情報の重要度（Hierarchy）」が維持されるよう、見出しと本文のコントラスト比を適切に管理してください。

    *   **The Fragmented UI Protocol (Consistency Mandate)**:
        *   **Law**: 「似ているが違う」は最悪です。UIコンポーネント（パンくず、見出し、ボタン等すべて）は、**その配置コンテキスト（Wrapper/Layout）まで含めて** 標準化しなければなりません。
        *   **Action**: ページごとのアドホックなCSS調整（「ここだけ少し背景色を変える」「マージンを足す」）を禁止します。サイト全体で一つの「正解（Gold Standard）」を定め、全てのページをそれに準拠させてください。

### 3.4. モーションとジェスチャー (Motion & Gestures - The "Soul")
*   **物理ベース (Physics-Based)**: すべてのアニメーションは**スプリング物理**（剛性/減衰）を使用します。要素は弾み、伸び、わずかに潰れるべきです。
*   **ジェスチャー (Swipe First)**:
    *   **ナビゲーション (Navigation)**: 「スワイプバック」を普遍的にサポートします。
    *   **アクション (Actions)**: リスト項目には**Swipe-to-Action**（アーカイブ、削除など）を使用します。
    *   **感触 (Feel)**: ジェスチャーは指の動きに 1:1 で追従しなければなりません。ラグは厳禁です。

### 3.5. 五感のデザイン (Multi-Sensory Design)
*   **ハプティクス (Haptics)**:
    *   **触覚フィードバック**: 成功（Success）、失敗（Error）、選択（Selection）、衝突（Impact）の各イベントに対して、iOS/Androidのネイティブハプティクスパターンを割り当てます。
    *   **繊細さ**: 「ブブッ」という不快な振動ではなく、「コツッ」「コンッ」という繊細で高級感のあるフィードバックを追求します。
*   **ソニック・ブランディング (Sonic Branding)**:
    *   **サウンドロゴ**: アプリ起動時や重要な達成時（コンバージョン）には、ブランドを象徴する短いサウンド（サウンドロゴ）を再生し、記憶に残る体験を作ります。
    *   **UIサウンド**: ボタン押下やトグル切り替えにも、邪魔にならない微細なサウンド（Click, Pop）を付与します（設定でOFF可能にする）。

## 4. パフォーマンス・アニメーション (Performance Animation)
*   **60fps (120fps) ターゲット**:
    *   アニメーションは常に60fps（可能なら120fps）を維持しなければなりません。
    *   **GPU最適化**: `transform` と `opacity` プロパティのみをアニメーションさせます。`width`, `height`, `top`, `left` のアニメーションはレイアウト再計算（Reflow）を引き起こすため禁止します。
    *   **Will-Change**: 必要な場合のみ `will-change` プロパティを使用し、ブラウザにヒントを与えますが、乱用は避けます（メモリ消費増大のため）。
