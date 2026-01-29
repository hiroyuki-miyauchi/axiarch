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

### 2.8. The Hydration Stability Protocol (Zero Mismatch)
*   **Law 1 (Dynamic Content)**: `new Date()` や `Math.random()` などの動的な値を JSX 内に直接埋め込むことを禁止します。これらは SSR と CSR で値がズレ、Hydration Error を引き起こします。
*   **Law 2 (Identifier Match)**: `id` や `htmlFor` には必ず一意かつ不変な値を付与するか、React の `useId` を使用して物理的な一致を保証してください。
*   **Law 3 (Extension Defense)**: ブラウザ拡張機能（Grammarly, Password Managers 等）による属性注入による不一致を防ぐため、`<html>` や `<body>` には `suppressHydrationWarning` を付与してください。**ただし、開発者自身のロジック不備（バグ）を隠すためにこの属性を使用することは厳禁です。**
*   **Law 4 (Date Formatting)**: 日付の表示は必ずクライアントサイド（`useEffect` 内）でフォーマットするか、サーバーサイドで確定した文字列（UTC等）として渡してください。

## 3. フォームとバリデーション (Forms & Validation)
*   **ライブラリ選定**:
    *   **React Hook Form**: 非制御コンポーネントベースで、再レンダリングを最小限に抑えます。
    *   **Zod**: スキーマ駆動開発を行います。バリデーションロジックはUIから分離し、Zodスキーマとして定義します。
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

## 5. 互換性とエラーハンドリング (Compatibility & Error Handling)
*   **ブラウザ互換性 (Browser Compatibility)**:
    *   **ターゲット**: Chrome, Safari, Firefox, Edgeの最新2バージョン、およびiOS Safari, Android Chromeの最新2バージョンをサポートします。
    *   **Polyfill**: `core-js` 等を使用し、必要な機能のみをPolyfillします。
    *   **Hydration Warning Control**:
        *   **Extension Defense**: ブラウザ拡張機能による属性注入（Hydration Error）を防ぐため、`<html>`, `<body>`, およびヘッダー/フッター内の主な `Link` には `suppressHydrationWarning` を付与することを推奨します。
        *   **Link Extension Guard**: ヘッダーやフッターなど、全ページ共通のナビゲーションリンクは、ブラウザ拡張機能（例: McAfee WebAdvisor, Video Downloader, Grammarly等）による `vcdaldp-fin` や `data-nodal` 等の属性注入の標的になりやすいため、予防的に `<Link suppressHydrationWarning>` を付与してください。
        *   **Prohibition**: 開発者自身のコードによる「データ不一致（バグ）」を隠すためにこの属性を使用することは厳命により禁止します。使用はあくまで「外部拡張機能」や「ブラウザ固有の動作」による不可避な不一致に限ります。
*   **エラーハンドリング (Error Handling)**:
    *   **Error Boundaries**: Reactの `ErrorBoundary` を使用し、コンポーネントレベルでのクラッシュがアプリ全体を巻き込まないようにします。
    *   **グレースフル・デグラデーション**: JavaScriptが無効な場合やエラー発生時でも、最低限のコンテンツが表示されるように設計します。
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
        *   **IndexNow**: 記事や店舗情報の更新時は、**IndexNow API** を通じて検索エンジンに即時通知します。
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
