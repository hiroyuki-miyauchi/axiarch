# 33. Webフロントエンドエンジニアリング (Web Frontend Engineering - Next.js)

## 1. モダンWebアーキテクチャ (Modern Web Architecture)
*   **Next.js & React Server Components (RSC)**:
    *   **デフォルト**: 原則として **App Router** を使用し、可能な限りサーバーコンポーネント（RSC）でレンダリングします。これにより、クライアントに送信するJavaScript量を劇的に削減します。
    *   **データ取得**: データフェッチはサーバーサイドで行い、ウォーターフォール問題を回避します。
    *   **The Server-Only Import Protocol (Bundle Protection)**:
        *   **Law**: サーバー専用ファイル（`lib/api/*`, `lib/actions/*` 等）には、必ず `import 'server-only'` を記述してください。
        *   **Outcome**: 誤ってクライアントコンポーネントからインポートされた場合、ビルド時にエラーとなり、機密ロジックやAPI Keyのクライアントバンドルへの混入を物理的に防ぎます。
*   **エッジコンピューティング (Edge Computing)**:
    *   **ミドルウェア**: 認証チェックやジオロケーションによるリダイレクトは、**Edge Middleware** で実行し、レイテンシを最小化します。
    *   **The Middleware Lightweight Protocol (Performance Guard)**:
        *   **Law**: `middleware.ts` は軽量に保ち、静的アセット（`/_next/static/*`, `/favicon.ico`, `/robots.txt` 等）へのアクセスを処理対象から除外してください。
        *   **Action**: `matcher` 設定を使用して、処理対象をAPI Routes (`/api/*`) とページルート (`/(routes)/*`) に限定します。
        *   **Prohibition**: Middleware内での重いDB呼び出しや外部API呼び出しは、レイテンシ増大の原因となるため禁止します。
*   **ディレクトリ構成 (Directory Ontology)**:
    *   **src/app**: ルーティング定義のみ。ロジックは持ちません。
    *   **src/lib/actions**: Server Actions（データの正門）。
    *   **src/components**: UIパーツ。`ui` (Generic) と `features` (Specific) を分離します。
    *   **The Static Page Prohibition (No Hardcoding)**:
        *   **Law**: 利用規約、プライバシーポリシー等のコンテンツ主体ページを `src/app/(public)/terms/page.tsx` としてハードコードすることを禁止します。必ずHeadless CMSから配信し、動的ルーティングで処理してください。
    *   **The Anti-Haribote UI Protocol (Realism Mandate)**:
        *   **Law**: DBスキーマに存在しない「将来のカラム」や「JSON内の曖昧なデータ」を、あたかも正規化されたデータであるかのように扱うUI実装を禁止します。UIとデータは不可分の原子（Atom）です。
        *   **Action**: 必要なデータがあれば、まずバックエンド憲法に従って正規化されたカラムを追加してから、UIを実装してください。「とりあえずJSON」は技術的負債への招待状です。
*   **設定管理 (Site Settings Architecture)**:
    *   **Runtime Injection**: テーマカラー等の設定は、ビルド時ではなく実行時（RootLayout）にDBから取得し、CSS変数として注入します。これにより、再ビルドなしでデザイン変更を反映させます。
    *   **The Env Validation Protocol (Fail Fast)**:
        *   **Law**: `process.env` を直接使用禁止とし、`t3-env` や `zod` を用いて、ビルド時（または起動時）に環境変数の型と存在を検証してください。
        *   **Outcome**: 必要なキーが不足している場合、アプリは起動してはなりません（クラッシュさせる）。
*   **Global Expansion Protocol**:
    *   **Sub-Directory Strategy**: 言語ごとにユニークなURL (`/en/stores/tokyo`) を持ちます。クエリパラメータやCookieによる言語切り替えはSEO上禁止とします。
    *   **Universal Time**: DBはUTCで保存し、表示時にユーザーのブラウザロケールに合わせて現地時間に変換します。サーバーサイド(JST)決め打ちは禁止です。
    *   **The Freshness Obligation (SDK Modernization)**:
        *   **Law**: AI, Auth, Payment等の外部サービスSDKは進化が速く、古いバージョンは突然機能不全に陥ります（例: Geminiモデル廃止）。
        *   **Action**: 新規実装時は必ず `npm i package@latest` で最新版を使用し、不具合発生時は「まずアップデート」を第一の解決策として検討してください。「最新版を使うこと」は開発ポリシーの義務です。

## 2. UIコンポーネントとスタイリング (UI Components & Styling)
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
    *   **The TrailingSlash URL Integrity Protocol (URL正規化義務)**:
        *   **Law**: フレームワーク（Next.js `trailingSlash` 設定等）、リバースプロキシ（Nginx/Cloudflare）、CDN のTrailingSlash（末尾スラッシュ）設定は、プロジェクト全体で**統一**しなければなりません。`/about` と `/about/` が共存する状態は、SEO評価の分散・リダイレクトループ・キャッシュの二重化を招きます。
        *   **Action**:
            1.  **Config Alignment**: フレームワーク設定（例: `next.config.ts` の `trailingSlash: true | false`）とインフラ設定（リバースプロキシ、CDN）で同一ポリシーを適用してください。
            2.  **Canonical Consistency**: `generateMetadata` の `canonical` URL も、選択したTrailingSlashポリシーと一致させてください。不一致はSEO評価の分散を招きます。
            3.  **Redirect Enforcement**: 非正規URLへのアクセスは、**301リダイレクト**で正規URLへ統一し、検索エンジンのインデックス重複を防いでください。
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


### 2.1. The Component-DTO Interface Protocol (Interface First)
*   **Law**: UIコンポーネント（特に共有Widget）のProps定義に、生のデータベース型（`Row`）を使用してはなりません。これはバックエンドスキーマとUIを密結合させ、再利用性を殺します。
*   **Action**: 必ず `StoreDTO` や `ArticleDTO` などの **DTO Interface** に依存させ、実装詳細（配列インデックス等）をコンポーネント内部に隠蔽してください。
    *   **The Async-UI Boundary Protocol (Client/Server Separation)**:
        *   **Law**: UIコンポーネント（特に Client Component）は、データフェッチを行う Async Server Component を直接インポートしてはなりません。これはビルドエラーや不可解なランタイムクラッシュ、およびシリアライズエラーの原因となります。
        *   **Action**: `JsonLd` や `Analytics` のようなデータロジックを持つコンポーネントは、必ず `layout.tsx` や `page.tsx` の最上位（Server Context）でレンダリングし、`children` パターン等を用いて UI と物理的に分離してください。
### 2.2. The Clean Import & Export Protocol
*   **The Barrel Export Prohibition (Performance Guard)**:
    *   **Law**: ディレクトリ単位の `index.ts` (Barrel file) による一括再エクスポートを禁止します。
    *   **Reason**: 開発環境（Next.js Dev）でのビルド速度を著しく低下させ、かつ意図しないトランスパイル負荷（全コンポーネントの読み込み）を誘発するためです。インポートは必ず物理ファイル・パスから直接行ってください。

*   **The Dead Code Execution Protocol**:
    *   **Law**: 条件分岐や早期リターンの「後」で、重いインポートや外部モジュールの関数実行、DOMへの副作用（useEffect等）を配置しないでください。
    *   **Action**: 条件によって完全に不要なロジックは、コードベース内で「物理的に」実行されないように、Next.jsの `dynamic()` や `Suspense` の境界で分離するか、条件分岐の外側（Top-Level）に定義のみを配置してください。

*   **The Clean Import Protocol**:
    *   **Law**: `import` ステートメントは必ずファイルの最上部（Top-Level）に記述してください。コンポーネント内や制御フロー内でのインポートは、ビルド挙動を不安定にし、HMR (Hot Module Replacement) を破損させ、一見無関係なシリアライズエラーを誘発します。
    *   **Action**: どんなに急いでいても、インポートはファイルの先頭に集約してください。

*   **The Semicolon Guard (ASI Safety)**:
    *   **Law**: 副作用実行行の後で、次行が括弧で始まる場合（`(` や `[`）は、必ず明示的にセミコロン `;` を付与してください。ASI（Automatic Semicolon Insertion: 自動セミコロン挿入）の失敗による「ステルス・バグ」を物理的に封殺します。
    *   **Action**: ESLint の `no-unexpected-multiline` ルールを有効にし、CIで自動検出してください。

*   **The Component Colocation Protocol (適切な粒度の維持)**:
    *   **Law**: 特定のコンポーネントでのみ使用される「サブコンポーネント」「型定義」「定数」は、原則として **同一ファイル内 (Co-location)** に記述してください。過剰なファイル分割は認知負荷を増大させます。
    *   **Split Threshold**: ファイルが **300行** を超えた場合にのみ、サブコンポーネントを別ファイルに分離することを許可します。分離時はディレクトリを作成し、関連ファイルをまとめてください。

### 2.3. Headless UI Architecture (Web Only Prohibition)
*   **Rule**: UIコンポーネントは「データの表示」と「イベントの発火」のみに専念し、ビジネスロジックを持たせてはなりません（Dumb UI）。
*   **Prohibition**: コンポーネント内で `fetch` を行ったり、特定ページのDOM構造に依存したステート管理（Web Only設計）を行うことは、将来のNative化を阻害するため厳禁です。

### 2.4. Interactive Components Standard
*   **Rich Selection Protocol**:
    *   従来のラジオボタン/チェックボックスは原則禁止とし、**「押せることが直感的にわかるリッチなカード型UI」** を標準とします。
*   **Responsive Combobox Protocol**:
    *   **Desktop**: `Popover` (modal=true) を使用し、コンテンツとの重なりには `z-[9999]` を付与します。
    *   **Mobile**: タッチ操作性を高めるため、Popoverではなく **Drawer (Vaul)** を使用します。
    *   **Mobile Click/Tap Fix**: `vaul` (Drawer) 内のスクロール可能な領域には `data-vaul-no-drag` 属性を付与し、スワイプ操作による意図しない閉塞を防ぎます。
    *   **Breadcrumb Priority Lesson (Stack Layout)**: モバイルヘッダーでパンくずリストとアクションボタンを横並びにすると、パンくずが画面外に追いやられます。これらは「独立した行」として縦積み（Stack: `flex-col`）にすることを推奨します。
    *   **Interaction**: `CommandItem` には `pointer-events-auto` を強制し、`onClick`/`onPointerUp` をバインドしてタップ漏れを防ぎます。
    *   **Stable IDs**: `CommandItem` や `SelectItem` の `value` には、必ず一意かつ不変な **ASCII文字列**（ID等）を使用してください。日本語を `value` にすると選択ロジックが誤動作します。日本語検索が必要な場合は `keywords` プロパティを使用します。

### 2.5. The Z-Index Stratification Protocol (Menu Dominance)
*   **Law**: Z-Indexの「マジックナンバー化」を防ぎ、UIの重なり順序を保証します。
*   **Definition**:
    *   **Overlay (10000)**: `Select`, `Popover`, `Tooltip`, `Calendar` 等のオーバーレイ要素。これらは常に最前面でなければなりません。
    *   **Modal (9999)**: `Dialog`, `Sheet` 等の画面全体を覆うUI。オーバーレイよりは下です。
    *   **Menu (1000)**: ドロワーメニューやナビゲーションメニュー。
    *   **Header (50)**: 固定ヘッダー。
    *   **Floaters (40)**: チャットボタン等のフローティング要素。決してメニューの上に配置してはなりません。

### 2.6. The Design Consistency Protocol (No Native Inputs)
*   **Law**: システム標準の `<input type="date">` 等の使用を禁止します。Shadcn UI等のデザインシステム内で「異物」となり、デザインの統一性を損なうためです。
*   **Action**: 必ず `Popover + Calendar` や `Select` コンポーネントを使用し、独自のスタイルを適用してください。横並びの要素は `h-10` (40px) 等の固定高さで揃えることを義務付けます。
*   **クラスの整列**: `prettier-plugin-tailwindcss` を導入し、クラス名の並び順を自動的かつ強制的に統一します。
    *   **The App-Like Feel Protocol (Overscroll Control)**:
        *   **Context**: モバイル向けWebアプリ（PWA）や、ネイティブアプリ風の操作性を提供する場合。
        *   **Action**: `overscroll-behavior-y: none` を適用し、ブラウザの「Pull to Refresh」を無効化することを**推奨**します。ただし、ブラウザ標準の更新操作が必要な一般的なWebサイトでは、この設定を強制しないでください。
*   **The Hook Dependency Protocol**:
    *   **Law**: `useEffect` や `useCallback` の依存配列は、ESLintの警告 (`react-hooks/exhaustive-deps`) に完全に従い、使用している変数を全て記述してください。
    *   **Prohibition**: 「無限ループするから」という理由で依存配列を間引く（嘘をつく）ことは厳禁です。それはロジック自体が間違っている（Effect内でStateを更新しすぎている等）証拠です。設計を見直してください。

### 2.7. The React Hooks Order Guarantee Protocol (Hooks First)
*   **Law**: Hooks (useState, usePathname等) の呼び出し順序は、レンダリング間で不変でなければなりません。
*   **Prohibition**: Hooks呼び出しの**後**に配置されるべき早期リターン（`if (!data) return null`）や条件分岐を、Hooksの前（最上部）に置くことは禁止です。また、Hooks呼び出しの後に条件付きリターン（Early Return）を配置してはなりません。これは、後続のHooks呼び出し回数がレンダリング間で変動し、"Rendered more hooks..." エラーを引き起こすためです。
*   **Suspense Mandate (useSearchParams)**:
    *   `useSearchParams()` を使用するコンポーネントは、ビルド時の静的解析エラーを防ぐため、必ず `<Suspense>` 境界でラップすることを義務付けます。
    *   **The Error Boundary Protocol (No White Screen)**:
        *   **Law**: Reactのランタイムエラーによる「画面真っ白（White Screen of Death）」は許されません。
        *   **Action**: `react-error-boundary` を使用し、ルート (`layout.tsx`) および主要な機能セクションごとにエラー境界を設置し、必ず「再試行ボタン付きのエラーUI」を表示してください。
*   **Correct Structure (The Hooks First Protocol)**:
    *   **Law**: Hooks 呼び出しの**後**に条件付きリターン（Early Return）を配置することは、次回レンダリングでの Hooks 数変動を招き React の整合性を破壊するため**有罪**であり、完全禁止とします。これはデバッグを極めて困難にする**「技術的重罪（Felony）」**です。
    *   **Mandatory Order (Google Antigravity Standard)**:
        1.  **ALL HOOKS FIRST**: 全ての Hooks (useState, usePathname 等) をコンポーネント最上部に集約。
        2.  **DERIVED STATE**: Hooks の後に変数計算や状態判定を配置。
        3.  **CONDITIONAL RETURN**: 最後に `if (shouldHide) return null` などのリターンを配置。

### 2.7.1. The Static Component Persistence Protocol (外部定義義務)
*   **Law**: レンダリング関数の内部で別のコンポーネントを定義してはなりません。再レンダリングのたびに新しいコンポーネント型が生成され、React が DOM ツリーを破棄するため、**入力フォーカスの喪失**、**ステートの初期化**、および致命的なパフォーマンス低下を招きます。
*   **Action**: サブコンポーネントやラッパーコンポーネントは必ず **Module Scope（ファイルの最外部）** で定義してください。値を渡す必要がある場合は、明示的に Props を介して行ってください。
*   **Anti-Pattern**: `const MyComponent = () => { const SubComponent = () => <div />; return <SubComponent />; }` — これは**技術的重罪**です。

### 2.7.2. The Route Conflict Ban (Zero Duplicate Route)
*   **Law**: ページのリファクタリング（ディレクトリ移動）時は、必ず**移動元のディレクトリを物理的に削除**してください。古い `page.tsx` が残存していると、フレームワーク（Next.js等）がルート競合を検出し**ビルドエラー**を引き起こします。
*   **Action**: ファイル移動後は `find` や `git status` で旧ファイルの残存がないことを確認してください。

### 2.8. The Hydration Stability Protocol (Zero Mismatch)
*   **Law 1 (Dynamic Content)**: `new Date()` や `Math.random()` などの動的な値を JSX 内に直接埋め込むことを禁止します。これらは SSR と CSR で値がズレ、Hydration Error を引き起こします。
*   **Law 2 (Identifier Match)**: `id` や `htmlFor` には必ず一意かつ不変な値を付与するか、React の `useId` を使用して物理的な一致を保証してください。
*   **Law 3 (Extension Defense)**: ブラウザ拡張機能（Grammarly, Password Managers 等）による属性注入による不一致を防ぐため、`<html>` や `<body>` には `suppressHydrationWarning` を付与してください。**ただし、開発者自身のロジック不備（バグ）を隠すためにこの属性を使用することは厳禁です。**
*   **Law 4 (Date Formatting)**: 日付の表示は必ずクライアントサイド（`useEffect` 内）でフォーマットするか、サーバーサイドで確定した文字列（UTC等）として渡してください。

## 3. フォームとバリデーション (Forms & Validation)
*   **ライブラリ選定**:
    *   **React Hook Form**: 非制御コンポーネントベースで、再レンダリングを最小限に抑えます。
    *   **Zod**: スキーマ駆動開発を行います。バリデーションロジックはUIから分離し、Zodスキーマとして定義します。
*   **The Atomic Tabbed Form Protocol (God Component Resolution)**:
    *   **Law**: 関連項目が **5つ以上**、またはファイルが **500行** を超えるフォームは、必ず**タブ分割アーキテクチャ**を適用し、子コンポーネントに分離してください。単一の巨大フォームコンポーネント（God Component）は、保守性・テスタビリティ・パフォーマンスの全てを破壊します。
    *   **Action**: 分割後の子コンポーネントは `useFormContext` を使用してルートフォームの状態にアクセスしてください。初期化責任（`defaultValues`）はルートコンポーネントに留めます。
*   **バリデーション**:
    *   **The External Link Protocol (Context Aware)**:
        *   **Law**: 外部サイトへのリンクは、ユーザーのワークフローを中断させないために `target="_blank"` を**推奨**します。
        *   **Exception**: ただし、認証フロー（OAuth）や決済画面への遷移など、文脈的に「移動」が正しい場合はこの限りではありません。一律強制ではなく、ユーザー体験（戻ってくる必要があるか？）に基づいて判断してください。
    *   **クライアントサイド**: 必須入力、文字数、メール形式などは、サーバー送信前にリアルタイムでフィードバックします。
    *   **The Anti-Spam Shield (Bot Protection)**:
        *   **Law**: お問い合わせ、会員登録、口コミ投稿などの公開フォームには、必ず `Cloudflare Turnstile` または `reCAPTCHA` によるBot対策を実装してください。スパムによるDB汚染は、後処理で莫大なコストを発生させます。
    *   **Media Interaction (Crop UI)**: 画像アップロード時、サーバー側での自動トリミング（Center Crop）は禁止です。必ず `react-easy-crop` 等のUIを提供し、ユーザー自身がトリミング範囲を決定できるフローを実装します。
    *   **The iPhone Support Mandate (HEIC Conversion)**:
        *   **Context**: iPhoneの標準写真フォーマット(`.HEIC`)はWebで表示できません。
        *   **Action**: クライアントサイドで `heic2any` 等を使用して **JPEG/PNG に自動変換** してからアップロードすることを義務付けます。未変換のファイルをサーバーに送信してはなりません。また、CSP設定で `worker-src blob:` を許可してください。
    *   **The Worker CSP Protocol**:
        *   **Context**: 画像処理（`heic2any`）や圧縮ライブラリは、内部でWeb Worker (`blob:`) を使用します。厳格なCSP下ではこれがブロックされ、処理がハングアップします。
        *   **Action**: `middleware.ts` のCSP設定において、`worker-src 'self' blob:;` を明示的に許可してください。`script-src` だけでは不十分です。
    *   **Filename Sanitization**: 日本語ファイル名はトラブルの元となるため、アップロード時にクライアントサイドでローマ字変換（`wanakana`）を行います。
    *   **型安全性**: ZodからTypeScriptの型を推論（`z.infer`）し、フォームデータとAPIリクエストの型不一致を根絶します。
    *   **The No-Any Protocol (Resolvers)**: `react-hook-form` と `zodResolver` の型不整合に対し、`as any` を使うことは厳禁です。どうしても必要な場合は `as unknown as Resolver<Schema>` のような安全なキャスト（Safe Casting）を行い、意図を明示してください。
    *   **The Input Mode Mandate (Keyboard Optimization)**:
        *   **Law**: 数値専用フィールド（電話番号、郵便番号、クレジットカード番号等）には、必ず `inputMode` 属性 (`numeric`, `tel`, `email`) を設定し、モバイルデバイスで最適なキーボードが自動表示されるようにしてください。
        *   **Outcome**: ユーザーに手動でキーボード切替を強いる負担を排除します。
    *   **The Input Normalization Protocol (NFKC)**:
        *   **Law**: ユーザーが全角数字（１２３）や全角スペースを入力した場合、バリデーションエラーで弾くのではなく、**`onChange` または `onBlur` で半角に自動変換（Normalize）** して受け入れてください。
        *   **Implementation**: `String.normalize('NFKC')` を使用し、ユーザーにストレスを与えない「おもてなし」設計を採用します。
    *   **The IME Composition Guard (CJK入力安全化)**:
        *   **Law**: CJK言語圏（日本語・中国語・韓国語）のIME入力では、変換確定前（Composition中）に `onChange` イベントが発火し、検索リクエストの暴発や入力値の破壊を引き起こす場合があります。
        *   **Action**: リアルタイム検索やオートコンプリート等の即時反応型入力では、`compositionstart` / `compositionend` イベントを監視し、Composition中はアクションの発火を抑制してください。

### 3.3. Auto-Save & Data Persistence Protocol
*   **Mandatory Scope**: 管理画面の記事、設定、長文入力フォームには **自動保存機能** が必須です（Data Loss Zero Tolerance）。
*   **Implementation Standard**:
    *   **Hook Strategy**: 標準化された `useAutoSave` フックを使用し、入力停止から一定時間後（例: 2000ms）にローカルストレージへ保存します。
    *   **Passive Restoration**: ページロード時に下書きを勝手に復元せず、**「下書きがあります」という通知（バナー）** を出し、ユーザーが選択できる仕様にします。
    *   **Hygiene**: 正常送信（Submit）完了時には、必ずローカルストレージをクリア (`clearDraft`) し、古いデータの残留を防ぎます。
*   **The iOS Input Zoom Defense (Mobile UX Guard)**:
    *   **Problem**: iOS Safariでは、入力フィールドのフォントサイズが **16px未満** の場合、フォーカス時に自動的にズームインし、UXを著しく損なう。
    *   **Mandate**: モバイルビューにおける `input`, `textarea`, `select` の `font-size` は、必ず **16px (`text-base`) 以上** を設定してください。
    *   **Technique**: `text-base` をモバイルで使用し、デスクトップでは `md:text-sm` で切り替える実装を標準とします。

### 3.4. The Dynamic Form Engine Protocol (動的フォームランナー)
*   **Law**: 問い合わせフォームや申請フォームを固定のReactコンポーネント（`ContactForm.tsx`）としてハードコードすることは、ビジネス要件の変更にデプロイが必要となるため禁止します。
*   **Action**:
    1.  **Schema-Driven Rendering**: フォームの構造（フィールド名、型、バリデーション）は、DBテーブル（例: `inquiry_forms`, `form_fields`）またはJSONスキーマで定義し、UIは動的にレンダリングします。
    2.  **Field Type Registry**: テキスト、セレクト、日付、ファイルアップロード等の入力タイプを標準レジストリとして定義し、スキーマから参照できるようにします。
    3.  **Spam Protection**: 全ての公開フォームには **Cloudflare Turnstile** または同等のBot対策を必須とします。

## 4. PWAとクロスプラットフォーム (PWA & Cross-Platform)
*   **PWA (Progressive Web App)**:
    *   **インストール可能**: `manifest.json` を適切に設定し、ホーム画面への追加を可能にします。
    *   **オフライン対応**: Service Workerを使用して、オフラインでも主要機能（閲覧済みコンテンツ等）が動作するように設計します。
*   **Deep Linking**:
    *   **Smart App Banners**: モバイルブラウザで表示された際、ネイティブアプリがインストールされていればアプリを開き、なければストアへ誘導するバナーを実装します。

*   **Server Actions Protocol**:
    *   **The 'use server' Mandate**:
        *   **Law**: Server Actionsを定義するファイルは、必ずファイルの先頭行に `'use server'` を記述しなければなりません。関数単位ではなくファイル単位での宣言を基本とし、Server/Clientの境界漏れ（Leak）を防ぎます。
*   **Hard Session Refresh Protocol (Cookie Sync)**:
    *   **Context**: Server ActionでセッションCookieを更新しても、SPA遷移だけではMiddlewareやServer Componentに即座に反映されない場合があります。
    *   **Mandate**: 認証状態や重要権限の変更時（Login/Logout等）は、`window.location.reload()` でハードリフレッシュし、最新のCookie状態でサーバーにアクセスさせてください。権限不整合によるエラー画面の方がUXを損なうため、一瞬の白画面は許容します。

## 5. 互換性とエラーハンドリング (Compatibility & Error Handling)
*   **ブラウザ互換性 (Browser Compatibility)**:
    *   **ターゲット**: Chrome, Safari, Firefox, Edgeの最新2バージョン、およびiOS Safari, Android Chromeの最新2バージョンをサポートします。
    *   **Polyfill**: `core-js` 等を使用し、必要な機能のみをPolyfillします。
    *   **Tier Classification (サポート階層)**:
        | Tier | 対象 | テスト義務 |
        |:-----|:-----|:---------|
        | **Tier 1（必須）** | Chrome / Safari（最新2バージョン）| 全機能テスト |
        | **Tier 1（必須）** | 主要In-Appブラウザ（LINE等、市場に応じて）| 全機能テスト |
        | **Tier 2（推奨）** | Firefox / Edge（最新2バージョン）| 主要機能テスト |
        | **Tier 3（ベストエフォート）** | その他In-Appブラウザ | 表示確認のみ |
        | **非サポート** | IE11 | 対応不要 |
    *   **In-App Browser Considerations**: In-Appブラウザ（LINE内ブラウザ等）はOAuth認証フローのリダイレクトに制約がある場合があります。ソーシャルログイン実装時は必ず動作確認してください。
    *   **Private Browsing Defense**: プライベートブラウジングモードでは `localStorage` が制限される問題があります。`localStorage` に依存する機能（下書き保存、テーマ設定等）にはフォールバック実装を検討してください。
    *   **Polyfill Policy**: `browserslist` に基づき自動ポリフィルを適用してください。手動ポリフィルは禁止します。
    *   **Hydration Warning Control**:
        *   **Extension Defense**: ブラウザ拡張機能による属性注入（Hydration Error）を防ぐため、`<html>`, `<body>`, およびヘッダー/フッター内の主な `Link` には `suppressHydrationWarning` を付与することを推奨します。
        *   **Link Extension Guard**: ヘッダーやフッターなど、全ページ共通のナビゲーションリンクは、ブラウザ拡張機能（例: McAfee WebAdvisor, Video Downloader, Grammarly等）による `vcdaldp-fin` や `data-nodal` 等の属性注入の標的になりやすいため、予防的に `<Link suppressHydrationWarning>` を付与してください。
        *   **Prohibition**: 開発者自身のコードによる「データ不一致（バグ）」を隠すためにこの属性を使用することは厳命により禁止します。使用はあくまで「外部拡張機能」や「ブラウザ固有の動作」による不可避な不一致に限ります。
*   **エラーハンドリング (Error Handling)**:
    *   **Error Boundaries**: Reactの `ErrorBoundary` を使用し、コンポーネントレベルでのクラッシュがアプリ全体を巻き込まないようにします。
    *   **グレースフル・デグラデーション**: JavaScriptが無効な場合やエラー発生時でも、最低限のコンテンツが表示されるように設計します。
    *   **Offline Defense Protocol (Network Resilience)**:
        *   **Component-Level Recovery**: グローバルな Error Boundary が発火する前に、データ取得に失敗したコンポーネントレベルで「再読み込みボタン」付きのスケルトンまたはエラーメッセージを表示してください。
        *   **Offline Guard**: `navigator.onLine` を監視し、オフライン状態ではフォーム送信ボタンを `disabled` にしてデータ損失を防ぎます。
    *   **0 Warnings**: コンソールに出力されるWarningは、技術的負債の予兆です。開発中に全て解消し、**Warning 0件** でなければリリースできません。

## 6. パフォーマンスとSEO (Performance & SEO - "Core Web Vitals")
*   **スクリプト最適化 (Script Optimization)**:
    *   **外部スクリプト**: アフィリエイトタグや分析スクリプトは `next/script` を使用し、`strategy="lazyOnload"` または `afterInteractive` で読み込みます。メインスレッドをブロックしてはなりません。
    *   **SPA対応**: ページ遷移（Client-side Navigation）時に再発火が必要なスクリプト（例: リンク置換系）については、`useEffect` や `usePathname` フックを用いて適切に再初期化処理を実装します。
    *   **Memory Leak**: スクリプトの再初期化時は、古いイベントリスナーの削除など、メモリリーク対策を徹底します。
*   **画像最適化 (Image Optimization)**:
    *   `next/image` コンポーネントを必ず使用し、デバイスサイズに応じた最適な画像サイズとフォーマット（AVIF/WebP）を自動配信します。
    *   **Loader Mandate**: **Cloudflare Transformations** を利用するため、必ず `cloudflare-loader.ts` (または `loader` prop) を適用します。Vercel Default Optimizer の使用（転送量浪費）は厳禁です。
    *   **CLS対策**: 画像には必ず `width` と `height` を指定（または `fill`）し、レイアウトシフトを防ぎます。
    *   **The LCP Performance Mandate**: ファーストビューの主要要素（Hero画像、タイトル等）には、Next.js の `priority` 属性に加え、**`fetchPriority="high"`** を明示的に付与することを最高位のパフォーマンス規律とします。これを怠ることは「UXへの背信行為」とみなします。
    *   **The Client-Side Resize Mandate (UGC容量最適化)**:
        *   **Law**: ユーザーがアップロードする画像（UGC）は、サーバー送信前に必ずクライアントサイドでリサイズ（長辺1920px推奨）し、パケット節約とストレージ容量の最適化を強制します。生データのアップロードは禁止です。
        *   **Privacy**: 同時にEXIF情報（位置情報等）を削除する処理を必須とします。
*   **フォント最適化 (Font Optimization)**:
    *   `next/font` を使用してGoogle Fontsをセルフホストし、レイアウトシフト（CLS）と外部リクエストを排除します。
*   **メタデータ管理**:
    *   **Dynamic Metadata**: ページタイトルは `[ページ名] | [サイト名]` の形式で統一し、サイト設定（DB）から動的に値を取得します。ハードコーディングは禁止です。
    *   **Image Fallback**: OGPやコンテンツ画像がDBに存在しない場合、`public/assets` 内のデフォルト画像をフォールバックとして使用するロジックを実装し、画像欠損（404）を防ぎます。
    *   **The Data Seeding & Caching Protocol (Cache Key Versioning)**:
        *   **Law**: `unstable_cache` 等のキャッシュキーを不変の名前（例: `master_data`）に固定することを禁止します。
        *   **Action**: DBデータの大幅な増減や仕様変更時には、キャッシュキーにバージョンサフィックス（例: `_v2`, `_20260123`）を付与し、物理的に新しいキャッシュ空間を確保してください。古いキャッシュの残留による「表示の不整合」はバグとみなします。
    *   **The Public Cache Mandate (FinOps Protocol)**:
        *   **Law 1 (Unstable Cache Wrapping)**: 公開Read系アクション（トップページ、店舗一覧、ナビゲーション取得等）は、必ず `unstable_cache` (Next.js Data Cache) でラップし、DB負荷を一定に保ってください。
        *   **Law 2 (Tag Revalidation)**: データ更新時は `revalidateTag` を使用し、On-Demand Revalidationを実現してください。`revalidatePath`（ページ単位）よりも `revalidateTag`（リソース単位）を優先します。
    *   **Structured Data (JSON-LD)**: Machine-Readableであることを重視し、`LocalBusiness` (店舗), `Article` (記事), `BreadcrumbList` 等の構造化データを必ず実装します。AI (Perplexity/SGE) からの引用率を高めます。
        *   **The JSON-LD Precision Protocol (サイトリンク戦略)**:
            *   **Law**: トップページには単なる `WebSite` だけでなく、`Organization` (ロゴ, 代表者) と `SearchAction` (サイト内検索) を含む複合スキーマを実装してください。
            *   **Goal**: Google検索結果でのナレッジパネル表示やサイトリンク階層化を確実にします。
        *   **The Type-Safe Schema Protocol (型安全)**:
            *   **Law**: JSON-LDを文字列結合や生オブジェクトで構築することを禁止します。
            *   **Action**: `schema-dts` 等のライブラリを使用し、Schema.orgの仕様に準拠した型安全なオブジェクトとして構築してください。必須プロパティの欠損をビルド時に検知します。
    *   **The Code Input Standard (Rule 14.12)**:
        *   **Law**: HTML/CSS/JSON等のコード編集が必要な箇所で、生の `textarea` を使用することは、シンタックスハイライトがなくミスを誘発し、品質を著しく損なうため厳禁です。
        *   **Action**: 必ず `react-simple-code-editor` (+ `prismjs`) などのエディタコンポーネントを使用し、プロフェッショナルな品質を提供してください。
    *   **Microcopy Identity**: エラーメッセージやラベルの文言は、ユーザーを責めず、次のアクションを明示する「おもてなしの心」を持って執筆してください。
    *   **Technical SEO**:
        *   **SSR**: `<h1>`、メタデータ、メインコンテンツは必ずサーバーサイドレンダリングします。
        *   **Single H1**: 1ページにつき `<h1>` は1つ。ロゴではなく、そのページの「主題」をH1にします。
        *   **The Semantic HTML Landmark Protocol (ランドマーク要素)**:
            *   **Law**: AIクローラーはHTML構造を読み解きます。`<div>` だけでなく、`<article>`, `<section>`, `<header>`, `<nav>`, `<aside>` 等のランドマーク要素を適切に使用し、コンテンツの意味的な区切りを明確にしてください。
            *   **Action**: 見出しタグ（`<h1>`〜`<h6>`）の階層構造を厳守します。デザイン上の都合で `<h3>` の後に `<h2>` を置くような**階層破壊は禁止**です。
        *   **IndexNow**: 記事や店舗情報の更新時は、**IndexNow API** を通じて検索エンジンに即時通知します。
    *   **Ghost Content Protocol (Time-Gated SEO)**:
        *   **Law**: 公開予約（`published_at > NOW()`）されたコンテンツは、検索エンジンには「存在しないもの」として振る舞わなければなりません。
        *   **404 Mock**: 一般ユーザーからのアクセスには通常の404と同じUI・ステータスコードを返し、存在を推測させません。
        *   **NoIndex**: 非公開状態のページには `<meta name="robots" content="noindex, nofollow" />` を強制挿入します。
*   **Marketing Engineering**:
    *   **Dynamic Assets**: `@vercel/og` を使用してOGP画像をオンデマンド生成し、Cloudflare CDNでキャッシュ (`s-maxage=86400`) します。
    *   **Tracking Infrastructure**:
        *   **CAPI**: 重要コンバージョン（購入等）は、Pixelだけでなく **Server-Side Conversion API** からも各媒体へ送信します（Cookieレス対策）。
        *   **First-Party Data**: 初回流入時のパラメータ（`utm_source`等）をSessionに保存し、ユーザー登録時に記録します（First Touch評価）。
    *   **Privacy-First**: **Consent Mode v2** に準拠し、未同意ユーザーのトラッキングCookieをブロックする仕組みを実装します。

## 7. コンポーネント設計とアクセシビリティ (Component Design & A11y)
*   **アクセシビリティ (Accessibility - "Shift Left")**:
    *   **自動テスト**: CIで `axe-core` を実行し、コントラスト不足やラベル欠損を自動検知してブロックします。
    *   **The Alt Text Mandate (Invisible UX)**:
        *   **Law**: 全ての画像 (`<Image>`) に `alt` 属性を義務付けます (`eslint-plugin-jsx-a11y` error)。
        *   **Detail**: 装飾目的の画像には `alt=""` (空) を設定し、意味のある画像には「画像が見えない人にも内容が伝わるテキスト」を設定してください。「image」や「photo」という単語を含めることは禁止です（スクリーンリーダーが読み上げるため重複する）。
    *   **The Alt Text Quality Standard (画像alt品質基準)**:
        *   **Context**: `alt` 属性は (1) スクリーンリーダーによる読み上げ、(2) 画像読み込み失敗時の代替テキスト、(3) 検索エンジン/AIクローラーの画像理解の3つの役割を持ちます。alt テキストの品質はSEO・A11y・GEOの全てに影響します。
        *   **Law**: コンテンツ画像には運用者の母国語で具体的な alt を**必須**とし、装飾画像は `alt=""` で除外、`alt` 属性自体の省略は**永久に禁止**します。
        *   **Quality Matrix**:
            | 画像種別 | 基準 | 悪い例 ❌ | 良い例 ✅ |
            |:---------|:-----|:---------|:---------|
            | **店舗・施設写真** | 名称+特徴を含む | `alt="photo1"` | `alt="渋谷のカフェ○○の店内写真"` |
            | **商品画像** | 商品名+特徴 | `alt="image"` | `alt="オーガニック商品名 100g"` |
            | **地図** | 地域+目的 | `alt="map"` | `alt="東京都渋谷区周辺の施設マップ"` |
            | **アイコン** | アイコンの意味 | `alt="icon"` | `alt="評価: 星4つ"` |
            | **バナー** | キャンペーン内容 | `alt="banner"` | `alt="春のキャンペーン 2026年3月開催"` |
            | **ロゴ** | サービス名 | `alt="logo"` | `alt="サービス名"` |
            | **装飾** | 空文字 | `alt="decoration"` | `alt=""` |
        *   **CI Detection (推奨)**: PRレビュー時に `<img` タグの `alt` 属性を確認し、英語のみの値（例: `alt="[A-Za-z ]+"` パターン）を検出して警告するCI自動検出を推奨します。
    *   **Screen Reader**: 主要フローにおいて、スクリーンリーダー（VoiceOver/TalkBack）での実機テストを義務付けます。
    *   **Icon Labels**: テキストを含まないアイコンのみのボタンには、必ず `aria-label` 属性を付与し、機能を明示します。
    *   **WAI-ARIA**: "No ARIA is better than Bad ARIA". 可能な限りネイティブHTML要素を使用し、ARIA属性は必要最小限に留めます。
    *   **Radix UI / Headless UI**: 複雑なコンポーネントには、アクセシビリティ対応済みのヘッドレスUIライブラリを使用します。
*   **アトミックデザイン**:
    *   コンポーネントは再利用性を考慮して設計しますが、過度な抽象化は避けます。
    *   **The Direct Dependency Ban (Component Encapsulation)**:
        *   **Law**: `react-simple-code-editor` や `react-dropzone` などの外部UIライブラリを、各ページで直接インポートして使用することを禁止します。
        *   **Action**: 必ず `components/ui/` 配下のラッパーコンポーネント（例: `CodeEditor`, `ImageUploader`）に隠蔽し、ドメインコードからはそのラッパーのみを使用してください。これにより、将来のライブラリ置換コストを最小化します。

## 8. データ可視化とエクスポート (Data Visualization & Export)
*   **チャート (Charts)**:
    *   **ライブラリ**: `Recharts` または `Chart.js` を推奨します。
    *   **UX**: 静止画ではなく、ホバー時のツールチップ、ズーム、パンに対応したインタラクティブなグラフを実装します。
*   **エクスポート (Export)**:
    *   **Web Workers**: PDF/CSV生成はメインスレッドをブロックしないよう、Web Worker内で実行します。
    *   **ライブラリ選定**:
        *   **PDF**: クライアントサイド生成には `@react-pdf/renderer` を推奨します。複雑な帳票はサーバーサイド（Puppeteer/Playwright）で生成します。
        *   **CSV**: `papaparse` 等を使用し、RFC 4180準拠のフォーマットを保証します。
    *   **互換性**: CSVは **BOM付きUTF-8** で出力し、Excelでの文字化けを防ぎます。PDFには日本語フォント（Noto Sans JP等）を必ず埋め込みます。

## 9. ユーザーガイド実装 (User Guidance Implementation)
*   **オンボーディングツアー (Onboarding Tours)**:
    *   **ライブラリ**: `driver.js` などの軽量かつアクセシブルなライブラリを使用し、フォーカストラップ（Focus Trap）とキーボード操作を保証します。
    *   **React Portals**: ガイド要素は `createPortal` を使用してDOMツリーの最上位にレンダリングし、`z-index` 戦争（スタッキングコンテキストの問題）を回避します。

## 10. デプロイとインフラ (Deployment & Infrastructure)
*   **Vercel**:
    *   デプロイ先は **Vercel** を第一選択肢とします。
    *   **プレビュー環境**: プルリクエストごとにプレビュー環境を自動生成し、デザインレビューや動作確認を容易にします。
*   **ISR (Incremental Static Regeneration)**:
    *   静的なコンテンツ（ブログ記事、ヘルプページ）はISRを使用し、ビルド時間の短縮と常に最新のコンテンツ表示を両立させます。
## 11. AdTech Engineering (For Monetization)
*   **Ads Platform Strategy**:
    *   **Ads.txt & Sellers.json**: ドメインなりすまし（Ad Fraud）を防ぐため、認定販売者情報を動的に配信し、サプライチェーンの透明性を担保します。
    *   **Ad Labeling**: 広告枠やスポンサーコンテンツには、ユーザーが認識できる位置に「PR」「Sponsored」表記を自動付与します。表記のないステルスマーケティングはシステムレベルでブロックします。
*   **Performance (Core Web Vitals)**:
    *   **Zero CLS (Layout Shift Guard)**: 広告バナーによるレイアウトシフトを「0」にします。広告枠には必ず `min-height` または `aspect-ratio` をCSSで指定し、表示領域を事前に確保します（Late Loading Pushの禁止）。
*   **The Ad Category Exclusion Protocol (広告禁止カテゴリ)**:
    *   **Context**: サービスのブランドイメージに不適切な広告はLTVを毀損し、ユーザーの信頼を失います。
    *   **Law**: ギャンブル、アダルト、暴力、政治的広告など、サービスのブランドに不適切なカテゴリの広告を**システムレベルで配信禁止**してください。
    *   **Action**:
        1.  **External Ads（Google AdSense等）**: 管理画面のカテゴリブロック設定を適用し、設定内容を定期的に監査します。
        2.  **Self-Served Ads（自社広告）**: 広告入稿時にカテゴリ分類を義務付け、禁止カテゴリに該当する広告はバリデーションでRejectします。

## 12. 禁止されたアンチパターン (Prohibited Anti-Patterns)

### 12.0. The Lazy Redirect Anti-Pattern (UX Failure)
*   **Law**: 処理完了後やエラー時に、ユーザーへのフィードバック（Toast/通知）なしに `redirect()` で画面を強制遷移させる行為は、UX上の「無責任な放置」であり禁止します。
*   **Action**: ユーザーは「何が起きたか」を知る権利があります。リダイレクトは「リソースの場所が変わった」場合のみ使用し、状態通知には必ず Toast または Flash Message を併用してください。

### 12.1. The Client DB Access Prohibition (Proxy Action Mandate)
*   **Ref**: クライアントサイドからの直接DBアクセス禁止に関する詳細は、アーキテクチャ憲法 `30_engineering_general.md` の Rule 13.2 を参照し、これを厳守してください。
*   **Law**: Client Component で `supabase.from()` を直接呼び出すことは、RLSポリシーの潜在的脆弱性と、DTO（Mapper）を介さない生データの肥大化を招くため禁止します。
*   **Action**: クエリは必ず Server Action（`src/lib/actions`）を経由する「Proxyパターン」を実装し、クライアントには必要最小限の正規化されたデータ（DTO）のみを返却してください。

### 12.2. The Anchor Tag Nesting Prohibition (aタグ入れ子禁止)
*   **Law**: `<a>` タグ（`Link` コンポーネント含む）の中に別の `<a>` タグを含めることは、ブラウザによる DOM の自動分離を招き、Next.js の Hydration Mismatch を引き起こす HTML 仕様違反です。
*   **Prohibition**: 「見た目だけで動くからOK」という妥録は許されません。ブラウザはネストされた `<a>` を自動的に外側へ押し出すため、サーバーとクライアントのDOMが物理的に一致しなくなります。
*   **Action**: カード全体をクリック可能にする場合、以下のパターンで回避してください：
    1.  **Overlay Pattern**: カードを `relative` にし、メインリンクを `::before` 疑似要素等で `absolute inset-0` に広げ、内部のサブリンクは `relative z-10` で前面に出す。
    2.  **Separate Pattern**: タイトルや画像のみをリンクにし、ネストを物理的に避ける。

### 12.3. The Server-Side DOM Prohibition (No jsdom)
*   **Law**: Server Component (Node.js/Edge) 環境において、`document` や `window` などのブラウザ固有オブジェクトにアクセスすることは**最高度の禁止事項**です。`jsdom` 等のポリフィル導入は、サーバーサイド設計の敗北を意味します。
*   **Action**: サーバーサイドでの HTML 解析・サニタイズには、軽量な `xss` ライブラリ、または `cheerio` (解析が必要な場合) を使用してください。`isomorphic-dompurify` 等の「ブラウザ依存ラッパー」の使用も、副作用が不明瞭なため原則禁止します。



### 12.5. The Recursive Rendering Ban (Depth Safety)
*   **Law**: コンポーネントツリー内での、終了条件（Base Case）が不明確な「自己再帰レンダリング」を禁止します。
*   **Action**: コメントのツリー表示などの再帰構造が必要な場合は、必ず **`maxDepth`** を Props として定義し、それを超える場合は「もっと見る」ボタンやフラット表示に切り替えてください。

### 12.6. The Double Scrollbar Prohibition (UX Integrity)
*   **Law**: `h-screen` と `overflow-y-auto` を無計画にネストさせ、画面上に二重のスクロールバーを発生させることは、UXの敗北です。
*   **Action**: スクロールコンテナは画面内に**ただ一つ**（通常は `body` またはメインレイアウト）であることを原則とします。部分スクロールが必要な場合は、必ず `dvh` (Dynamic Viewport Height) を考慮し、Mobile Safari での挙動を検証してください。

### 12.7. The Metadata Obligation (Page Title Protocol)
*   **Law**: ページタイトルが「undefined」やサイト名のみになることは、ユーザーの信頼を損なう品質欠陥です。
*   **Action**: すべての `page.tsx` において、必ず `export const metadata: Metadata` を定義してください。ビルド前のセルフチェックとして、ブラウザタブのタイトル目視を確認項目に含めてください。

### 13.0. The Security & Performance Boundary
*   **The Next.js 15 Async API Protocol**:
    *   **Law**: Next.js 15 以降、`params`, `searchParams`, `headers`, `cookies`, `draftMode` は Awaitable (Promise) です。
    *   **Action**: これらを参照する際は必ず `await` するか、Reactの `use()` フックを用いて展開してください。非同期処理を怠ると、本番環境でのみ発生する「値の欠損」や「無限レンダリング」の直接原因となります。
*   **The Frictionless Security UI Protocol (Design Handshake)**:
    *   **Law**: セキュリティ機能（Turnstile/OTP）は、ユーザーの「目的達成」を阻害しない形でのみ実装してください。
    *   **Action**:
        *   **Draft Save Exemption**: 下書き保存などの「日常操作」では、TurnstileやOTPを要求しないでください（`60_security_privacy.md` Rule 8.6参照）。
        *   **Physical Lock UI**: セキュリティチェック中（Turnstile回転中）は、送信ボタンを `disabled` ではなく `loading` 状態にし、進行中であることを明示してください。
*   **CSP Worker Integrity (blob: permission)**:
    *   **Context**: `heic2any` や高性能な画像圧縮ライブラリは、内部で `Web Worker` を生成し `blob:` URLを使用する場合があります。これがブロックされると処理がハングアップします。
    *   **Action**: Middleware の CSP 設定に必ず `worker-src 'self' blob:;` を含め、画像処理プロセスの可用性を保証してください。

### 14.1. The Form DefaultValues Completeness Mandate (フォーム初期値完全性義務)
*   **Law**: React Hook Form（またはそれに類するフォームライブラリ）で `useForm` を使用する際、`defaultValues` には**使用する全てのフィールドを明示的に設定**しなければなりません。
*   **Reason**: `Controller` や `useController` で `name` を指定したフィールドが `defaultValues` に存在しない場合、DBからデータが正しく返されても、UIが空の状態でレンダリングされます（「DB成功なのにUIが空」問題）。
*   **Action**:
    1.  **Exhaustive Default**: フォームで使用する全フィールドを `defaultValues` に列挙してください。新フィールド追加時は**必ず `defaultValues` にも追加**してください。
    2.  **Checklist**: フィールド追加時は以下を全て確認: Schema定義 + `defaultValues` + Controller/register + `setValue`呼び出し箇所 + `useFieldArray`使用箇所。
    3.  **Zod Sync**: Zod Schemaに定義されている全フィールドが `defaultValues` にも含まれていることを体系的に比較・検証してください。
*   **Diagnostic**: 「DB書き込み成功 + DB読み取り成功」なのにUIが空 → **`defaultValues` の欠落を疑え**。

### 14.2. The Production Build Verification Protocol (本番ビルド検証義務)
*   **Law**: 開発サーバー (`npm run dev`) が動作することは、コードが正しいことを意味しません。**`npm run build` が Exit 0 で通過するまで、そのコードは「存在しない」ものとみなしてください。**
*   **Action**:
    1.  **Local Build**: コミット前に必ずローカルで `npm run build` を実行し、成功を確認してください。
    2.  **SSG Awareness**: 静的生成（SSG）ページで `cookies()` 等の動的APIをインポートすると、開発時は動作するが本番ビルドで "Dynamic server usage" エラーになります。動的依存を分離してください。
    3.  **Tiered Database Client Protocol**: SSG/ISR互換のDBクライアントは、動的APIに依存するクライアント（`cookies()`, `headers()` 使用）と依存しないクライアントを**別ファイルに物理分離**してください。同一ファイルからのexportでは、Tree Shakingが効かず未使用の動的依存まで引きずる場合があります。
    4.  **Phantom File**: ビルドエラーが「存在しないファイル」を示す場合、re-export や動的インポートで隠蔽された実体ファイルを `grep` で特定してください。
*   **Rationale**: 開発サーバーはHot Module Replacementにより型エラーやインポートエラーを隠蔽します。ビルドのみが真実です。

### 14.3. The Non-Blocking Edge Processing Protocol (Edge非同期処理義務)
*   **Law**: Edge Middleware やAPI Route において、分析ログや使用量計測などの「メインレスポンスに関係ないDB書き込み」を `await` でブロックすることは、ユーザーへのレスポンス遅延を招く行為であり禁止します。
*   **Action**:
    1.  **waitUntil**: サイドエフェクト（ログ記録、計測、通知）は `event.waitUntil()` または同等のメカニズムでバックグラウンド処理化してください。
    2.  **Fire-and-Forget**: レスポンスに影響しない処理を `await` する正当な理由がない限り、非同期で発火してください。
    3.  **Error Isolation**: バックグラウンド処理のエラーがメインレスポンスに影響しないよう、try-catchで隔離してください。
*   **Outcome**: ユーザーが体感するレスポンスタイム（TTFB）を最小化し、副次的な処理は裏側で完了させます。

### 14.4. The LCP & Lazy Loading Performance Protocol (ファーストビュー最適化義務)
*   **Law**: ファーストビュー（Above the Fold）の最重要要素の描画速度と、それ以外の遅延読み込みを全ページに適用します。
*   **Action**:
    1.  **LCP Priority**: ビューポート内の最重要要素（ヒーロー画像、メインサムネイル等）には `priority` 属性および `fetchPriority="high"` を付与してください。
    2.  **CLS Prevention**: 画像・動画には固定の `aspect-ratio` またはスケルトンによる領域確保を義務付け、レイアウトシフト（CLS）をゼロにしてください。
    3.  **Lazy Everything Else**: ファーストビュー以外の全ての画像、動画、高負荷コンポーネント（マップ、SNS埋め込み等）は `loading="lazy"` または `next/dynamic` による遅延読み込みを徹底してください。
    4.  **Heavy Library Decoupling**: 50KB超の重量ライブラリ（リッチエディタ、スライダー等）は `dynamic import` で遅延読み込みし、初期バンドルサイズを最小化してください。
    5.  **Incremental Loading**: 大量リストの初期読み込みは10〜12件に制限し、「もっと見る」やインクリメンタルスクロールで追加取得してください。

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

### 14.31. The Component Config Re-mount Protocol（コンポーネント設定変更時の再マウント義務）
*   **Law**: 命令型初期化を行う外部ライブラリ（スライダー、マップSDK、チャートライブラリ等）をラップするReactコンポーネントにおいて、設定Props（スライド数、オプション、データソース等）が動的に変更される場合、Reactのリアクティブ更新に依存せず、**`key` propの変更による強制再マウント**を標準戦略として採用しなければなりません。
*   **Action**:
    1.  **Key-Based Re-mount**: 設定Propsが変更された際にコンポーネントを再初期化する必要がある場合、親コンポーネントから `key={configHash}` や `key={configVersion}` を渡し、Reactに完全な再マウントを強制してください。`useEffect` 内での手動の`destroy()` → `init()` パターンは、Reactのeffect実行順序（子→親の順で実行される）により競合状態を引き起こすため禁止します。
    2.  **Config Hashing**: 複数の設定値から `key` を生成する場合は、`JSON.stringify(config)` や設定値の連結文字列など、設定が変わった時に確実に異なる値になるキーを使用してください。
    3.  **Cleanup Guarantee**: ラップされたライブラリの`destroy()`メソッドは、Reactのアンマウント時（`useEffect`のクリーンアップ関数内）で**確実に**呼び出し、メモリリークとDOMの残骸を防いでください。
    4.  **No Manual Re-init in Effects**: `useEffect(() => { instance.destroy(); instance = new Library(options); }, [options])` のようなパターンを禁止します。Reactのeffect実行順序（子コンポーネントの`useEffect`が親より先に実行される）により、内部状態の競合やDOMの不整合が発生します。
*   **Rationale**: 命令型ライブラリ（Swiper, Chart.js, Google Maps等）は、初期化時にDOMを直接操作し、内部状態を保持します。ReactのProps変更はこれらのライブラリの内部状態を自動的に更新しないため、古いインスタンスが新しいPropsと不整合な状態で動作し続けます。`key` propによる再マウントは、Reactが提供する「コンポーネントのアイデンティティをリセットする」唯一の公式メカニズムであり、命令型ライブラリとの統合において最も安全で予測可能な戦略です。

## 15. パフォーマンス予算と最適化 (Performance Budget & Optimization)

### 15.1. CWVデプロイメントゲート (CWV Deployment Gate)
*   **Law**: Core Web Vitalsの以下の数値は「目標」ではなく**「デプロイ要件（Deployment Gate）」**とする。超過したPRはマージを禁止する。

    | 指標 | 閾値 | 測定条件 | ブロック条件 |
    |:-----|:-----|:---------|:-----------|
    | **LCP** (Largest Contentful Paint) | **≤ 2.5秒** | Lighthouse CI / CrUX | P75 超過 → マージブロック |
    | **INP** (Interaction to Next Paint) | **≤ 200ms** | Lighthouse CI / CrUX | P75 超過 → マージブロック |
    | **CLS** (Cumulative Layout Shift) | **≤ 0.1** | Lighthouse CI / CrUX | P75 超過 → マージブロック |
    | **FCP** (First Contentful Paint) | **≤ 1.8秒** | Lighthouse CI | 目標値（警告のみ） |
    | **TTFB** (Time to First Byte) | **≤ 800ms** | Lighthouse CI | 目標値（警告のみ） |

*   **Edge Target**: キャッシュヒット時のページ応答は **≤ 200ms** を目標とする。
*   **Mobile-First Measurement**: Lighthouse CIの測定は **モバイルシミュレーション（Slow 4G + CPU Throttling 4x）** をデフォルトとする。デスクトップスコアのみでの合格判定を禁止する。モバイルスコアが **≥ 90** であることを要件とする。
*   **Touch Target**: タップ可能な要素（ボタン、リンク等）は最低 **44×44px** のタッチターゲットを確保すること。
*   **Cross-Reference**: §2 Performance Budget (SLA), `52_sre_reliability.md` §10.2 (Performance Benchmark)

### 15.2. バンドルサイズ予算 (Bundle Size Budget)
*   **Law**: 以下のサイズ上限を超過した場合、ビルド警告またはPRコメントで通知する。

    | 対象 | 上限 | 測定ツール（例） | 備考 |
    |:-----|:-----|:---------------|:-----|
    | **Initial JS** (First Load JS) | **≤ 150KB** (gzip) | `next build` 出力 | ルートページ初期ロード |
    | **Route Chunk** (ページ単位) | **≤ 80KB** (gzip) | `next build` 出力 | 各ページの固有JS |
    | **Third-party JS** (外部スクリプト) | **≤ 50KB** (gzip) | Bundle Analyzer | Analytics等の総量 |
    | **Total CSS** | **≤ 50KB** (gzip) | ビルド出力 | UI Framework出力含む |

*   **Diff Alert**: Bundle AnalyzerをCI上で実行し、前回ビルドとの差分が **+10KB** を超えた場合はPRに警告コメントを自動付与する。
*   **Tree Shaking**: 未使用モジュール混入防止のため、`import` は名前付きインポートを必須とする（`import { format } from 'date-fns'` ✅ / `import * as dateFns` ❌）。
*   **Unused CSS**: 未使用CSSクラスが全体の **20%** を超えないこと。CSSフレームワークの `content` 設定やPurgeCSSで不要クラスを除去する。
*   **Cross-Reference**: §2 Bundle Size (150KB SLA), §14.21 Dynamic Library Decoupling

### 15.3. 画像サイズ予算 (Image Size Budget)
*   **Law**: 用途ごとに画像の最大サイズとフォーマットを制約する。

    | 用途 | フォーマット | 最大サイズ | 備考 |
    |:-----|:-----------|:---------|:-----|
    | **ヒーロー画像** | WebP / AVIF | ≤ 200KB | LCP要素の場合は `priority` 必須 |
    | **サムネイル** | WebP | ≤ 30KB | `sizes` prop による最適配信 |
    | **アイコン/ロゴ** | SVG / WebP | ≤ 10KB | ベクター優先 |
    | **OGP画像** | JPEG / PNG | ≤ 100KB | 1200×630px固定 |
    | **ユーザーアップロード** | WebP (変換後) | ≤ 500KB | Image Resizing経由 |

*   **Lazy Loading Strategy**:
    *   **Above-the-Fold**: ファーストビューの画像は `loading="eager"` + `priority={true}` で即時読み込み。
    *   **Below-the-Fold**: スクロール下の画像は `loading="lazy"` でNative Lazy Loading。
*   **Cross-Reference**: §6 Image Optimization, §14.4 LCP & Lazy Loading

### 15.4. データ取得ウォーターフォール防止 (Data Loading Waterfall Prevention)
*   **Law**: データ取得の「直列連鎖（Waterfall）」を禁止する。独立したデータ取得は並列で実行しなければならない。
*   **Action**:
    1.  **Parallel Fetch**: 独立したデータ取得は `Promise.all()` / `Promise.allSettled()` で並列実行する。
    2.  **Streaming SSR**: `React.Suspense` + `loading.tsx` を活用し、重いデータ取得を遅延させつつUIの初期描画を高速化する。
    3.  **Prefetch**: ナビゲーション前に次ページのデータをプリフェッチする（フレームワークの `prefetch` 機能活用）。
    4.  **DB Query Target**: 単一クエリの実行時間は **≤ 50ms** を目標とする。50ms超のクエリは `EXPLAIN ANALYZE` で分析し、インデックスまたはクエリ最適化を施す。
*   **Cross-Reference**: §1 Data Fetching (RSC), §14.9 SSR Stream Resilience

### 15.5. フォント読み込み戦略 (Font Loading Strategy)
*   **Law**: Webフォントの読み込みがCWV（特にCLS・LCP）を劣化させないよう、以下の戦略を適用する。
*   **Action**:
    1.  **`font-display: swap`**: Webフォント読み込み中はシステムフォントを表示し、FOIT（Flash of Invisible Text）を防ぐ。
    2.  **Preload**: ファーストビューで使用するフォントウェイト（Regular, Bold）のみを `<link rel="preload">` で事前読み込みする。不要なウェイトのPreloadは帯域浪費。
    3.  **Subset化**: CJKフォント（Noto Sans JP等）はサブセット化し、フォントファイルサイズを削減する。フレームワーク標準のフォント機能（`next/font/google` 等）が自動的にこれを行う場合はそちらを利用する。
    4.  **Variable Font**: 可能であればVariable Fontを採用し、複数ウェイトのHTTPリクエストを1つに集約する。
*   **Cross-Reference**: §6 Font Optimization

### 15.6. Lighthouse CI 自動ゲートプロトコル (Lighthouse CI Auto Gate Protocol)
*   **Law**: PR毎にLighthouse CIを実行し、以下の自動ゲート閾値を適用する。
*   **Auto Gate Thresholds**:
    | カテゴリ | 最低スコア | ブロック条件 |
    |:--------|:----------|:-----------|
    | **Performance** | **≧ 90** | < 80 → PRマージ自動ブロック |
    | **Accessibility** | **≧ 90** | 目標値（警告のみ） |
    | **SEO** | **≧ 90** | 目標値（警告のみ） |
    | **Best Practices** | **≧ 90** | 目標値（警告のみ） |
*   **Score Degradation Alert**: 前回PRとの比較でスコアが **-5pt** 以上低下した場合、PRに自動アラートコメントを付与する。
*   **RUM (Real User Monitoring)**: Web Vitalsデータを日次でダッシュボードに表示し、フィールドデータのデグレーションを即座に検知する仕組みを構築する。
*   **CrUX Monthly Review**: Google Search Console の CrUX レポートを月次で確認し、フィールドデータが予算を超過したページを特定・対処する。
*   **Cross-Reference**: §15.1 CWV Deployment Gate, `52_sre_reliability.md` §10.2 (Performance Benchmark)

### 15.7. パフォーマンスデグレーション対応 (Performance Regression Response)
*   **Law**: パフォーマンスの劣化を検知した場合、以下の重大度分類に基づき対応する。

    | 重大度 | 条件 | 対応期限 | アクション |
    |:------|:-----|:--------|:---------|
    | **P0 (Critical)** | LCP > 4秒 または CLS > 0.25 | **即時** | ロールバック検討、緊急hotfix |
    | **P1 (Major)** | LCP 2.5〜4秒 または INP 200〜500ms | **24時間以内** | 原因特定・修正PR作成 |
    | **P2 (Minor)** | Lighthouseスコア 80〜90 | **1スプリント以内** | バックログに起票 |

*   **Escalation**: P0 は発生即座にオンコール担当へ通知する。P1 は日次スタンドアップで報告する。
*   **Cross-Reference**: §15.1 CWV Deployment Gate, §15.6 Lighthouse CI Auto Gate, `52_sre_reliability.md` §10.2
