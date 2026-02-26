# 33. Webフロントエンドエンジニアリング (Web Frontend Engineering - Next.js)

### 14.3. The Non-Blocking Edge Processing Protocol (Edge非同期処理義務)
*   **Law**: Edge Middleware やAPI Route において、分析ログや使用量計測などの「メインレスポンスに関係ないDB書き込み」を `await` でブロックすることは、ユーザーへのレスポンス遅延を招く行為であり禁止します。
*   **Action**:
    1.  **waitUntil**: サイドエフェクト（ログ記録、計測、通知）は `event.waitUntil()` または同等のメカニズムでバックグラウンド処理化してください。
    2.  **Fire-and-Forget**: レスポンスに影響しない処理を `await` する正当な理由がない限り、非同期で発火してください。
    3.  **Error Isolation**: バックグラウンド処理のエラーがメインレスポンスに影響しないよう、try-catchで隔離してください。
*   **Outcome**: ユーザーが体感するレスポンスタイム（TTFB）を最小化し、副次的な処理は裏側で完了させます。

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

*   **shadcn/ui + Tailwind CSS**:
    *   **標準スタック**: UIコンポーネントライブラリには、アクセシビリティとカスタマイズ性を両立する **shadcn/ui** を標準採用します。
    *   **デザインシステム**: Tailwind Configの `extend` を活用し、プロジェクト固有のカラー、フォント、シャドウをトークンとして定義します。ハードコードされたHEX値（例: `#F00`）の使用を禁止します。
*   **CSSアーキテクチャ**:
    *   **ユーティリティファースト**: 原則としてTailwind Utilityクラスを使用します。
    *   **コンポーネント抽出**: 共通パターン（ボタン、カード）はReactコンポーネントとしてカプセル化し、`@apply` は極力使用しません（Tailwindチームの推奨）。
    *   **CSS Modules**: 複雑なアニメーションや、Tailwindで表現困難な場合にのみ、CSS Modules（または `styled-jsx`）の使用を許可します。
    *   **The CSS Specificity Protocol (!important Ban)**:
        *   **Prohibition**: `!important` でスタイルを強制上書きすることは、CSSの詳細度戦争を引き起こす「黒魔術」であり、エンジニアとしての恥です。機能的な表示/非表示やレイアウト調整において、`!important` で逃げることを**完全禁止**とします。
        *   **React Way**: スタイルが効かないときは、DOM構造やクラスの競合といった根本原因を解消するか、Reactの状態管理（State）で制御してください。
    *   **The Gold Standard UI Mandate (Universal Placement)**:
        *   **Law**: ページごとのアドホックな CSS 調整（その場しのぎの `margin` や `padding` の微調整）を禁止します。
        *   **Mandate**: 全ての UI コンポーネントは、配置コンテキストを含めた「標準化されたバリアント」として定義せよ。エリートは「このページのこの場所だけ」という例外を作らない。
    *   **The Anchor Tag Nesting Prohibition Protocol (Invalid Nesting)**:
        *   **Law**: `<a>` または `<Link>` の中に、別の `<a>` または `<Link>` を含めてはなりません（HTML仕様違反）。Next.js の Hydration Error の物理的原因となります。
        *   **Action**: カード全体をリンクにする場合は、親を `div` にして `position: relative` と `::before` 疑似要素（`inset-0`）を使用するか、機能的にリンクを分離してください。
    *   **The CSS Containment Protocol (Whitespace Glitch)**:
        *   **Context**: `overflow-y-auto` を持つネストされたコンテナや、アコーディオン等の動的高さ要素は、スクロールバーの再計算により「無限の空白」や「レイアウト崩れ」を引き起こすことがあります。
        *   **Action**: スクロールコンテナには `contain: layout` (Tailwind: `contain-layout` プラグイン推奨または `style={{ contain: 'layout' }}`) を適用し、レイアウト計算の影響範囲を隔離してください。
    *   **Baseline Alignment**: フィルタUI等でラベル付き入力とボタンを横並びにする際は、必ず `items-end` で下端（Baseline）を揃えてください。`items-center` はズレを生みます。
    *   **The Natural Scrolling Protocol**:
        *   **Context**: `h-dvh` + `overflow-y-auto` による「入れ子スクロール」構造は、ブラウザのスクロール計算と競合し、無限余白グリッチを引き起こします。
        *   **Action**: 特別な理由がない限り、独自スクロール領域を作らず、常に `min-h-dvh` を使用してブラウザ本来の **Window Scroll** に委ねてください。サイドバーは `sticky` で追従させます。
    *   **Performance Budget (SLA)**:
        *   **Core Web Vitals**: **LCP < 2.5s**, **INP < 200ms**, **CLS < 0.1**. これらは「目標」ではなく「デプロイ要件」です。
    *   **Bundle Size**: Initial JSサイズを **150KB (Gzipped)** 以内に抑えます。超過時は `next/dynamic` で分割します。
    *   **The Dynamic Import Mandate (Payload Optimization)**:
        *   **Law**: Gzip圧縮後 **30KB** を超えるライブラリ（Charts, Editors, Maps, 3D, PDF Viewer等）は、メインバンドルへの同梱を禁止します。
        *   **Action**: 必ず `next/dynamic` または `React.lazy` を使用してコンポーネント単位で分割（Code Splitting）し、ユーザーがその機能にアクセスするまで読み込まない設計としてください。
        *   **UX**: ロード中はスケルトン（`loading` prop）を表示し、CLS（レイアウトシフト）を防いでください。
    *   **The Canonical Identity Protocol (SEO Duplicate Protection)**:
        *   **Context**: 検索エンジンに公開するページ（Public Pages）において。
        *   **Law**: Next.js の `generateMetadata` で必ず `alternates: { canonical: url }` を定義し、パラメータ違いによる評価分散を防いでください。認証後の管理画面ページでは不要です。
    *   **The Performance First Protocol (LCP & Lazy Loading Mandate)**:
        *   **Law 1 (First View Optimization)**: ビューポート内（ファーストビュー）の最重要要素（ヒーロー画像等）には、必ず `priority` (Next.js) および `fetchPriority="high"` を付与してください。
        *   **Law 2 (Lazy Load Everything Else)**: ファーストビュー以外の全ての画像、動画、高負荷コンポーネントは、例外なく `loading="lazy"` または `next/dynamic` による遅延読み込みを徹底し、初期リソースを節約してください。
        *   **Law 3 (Layout Shift Zero)**: 読み込み中のレイアウトシフト（CLS）を「0」にするため、固定のアスペクト比またはスケルトンによる領域確保を義務付けます。
        *   **Law 4 (Incremental Loading Mandate)**: 大量のリスト（口コミ、商品、写真ギャラリー等）の初期読み込みは、サーバー負荷とクライアントのパケット消費を抑えるため、**1ページあたり最大 10～12 件** に制限してください。
        *   **Action**: 13件目以降は、必ず「もっと見る（Load More）」ボタン、またはスクロールに応じた「インクリメンタル・読み込み（Infinite Scroll）」を実装して提供してください。「全件取得（fetch entire list）」は、データ量が増加した際にシステムを麻痺させる「爆弾」であり、UXの欠陥として即時却下（Reject）されます。
    *   **The Suspense LCP Mandate (Streaming Shell Protocol)**:
        *   **Law 3 (Skeleton UI)**: ロード中は適切なスケルトン（コンテンツの骨格）を表示し、CLSを防ぎます。これによりLCP（Largest Contentful Paint）を最短化します。

    *   **The UI Interaction Protocol (Combobox/CMDK Handling)**:
        *   **Law**: `cmdk` 等のリスト項目において、`value` 属性にマルチバイト文字（日本語）を直接使用することを禁止します。
        *   **Action**: `value` には必ず ASCII 一意 ID を使用し、日本語検索が必要な場合は `keywords` プロパティを明示的に指定して、検索性と選択ロジックの堅牢性を担保してください。


