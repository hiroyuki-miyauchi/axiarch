# 33. Webフロントエンドエンジニアリング (Web Frontend Engineering - Next.js)

## 1. モダンWebアーキテクチャ (Modern Web Architecture)
*   **Next.js & React Server Components (RSC)**:
    *   **デフォルト**: 原則として **App Router** を使用し、可能な限りサーバーコンポーネント（RSC）でレンダリングします。これにより、クライアントに送信するJavaScript量を劇的に削減します。
    *   **データ取得**: データフェッチはサーバーサイドで行い、ウォーターフォール問題を回避します。
*   **エッジコンピューティング (Edge Computing)**:
    *   **ミドルウェア**: 認証チェックやジオロケーションによるリダイレクトは、**Edge Middleware** で実行し、レイテンシを最小化します。
*   **ディレクトリ構成 (Directory Ontology)**:
    *   **src/app**: ルーティング定義のみ。ロジックは持ちません。
    *   **src/lib/actions**: Server Actions（データの正門）。
    *   **src/components**: UIパーツ。`ui` (Generic) と `features` (Specific) を分離します。
*   **設定管理 (Site Settings Architecture)**:
    *   **Runtime Injection**: テーマカラー等の設定は、ビルド時ではなく実行時（RootLayout）にDBから取得し、CSS変数として注入します。これにより、再ビルドなしでデザイン変更を反映させます。
*   **Global Expansion Protocol**:
    *   **Sub-Directory Strategy**: 言語ごとにユニークなURL (`/en/stores/tokyo`) を持ちます。クエリパラメータやCookieによる言語切り替えはSEO上禁止とします。
    *   **Universal Time**: DBはUTCで保存し、表示時にユーザーのブラウザロケールに合わせて現地時間に変換します。サーバーサイド(JST)決め打ちは禁止です。

## 2. UIコンポーネントとスタイリング (UI Components & Styling)
*   **shadcn/ui + Tailwind CSS**:
    *   **標準スタック**: UIコンポーネントライブラリには、アクセシビリティとカスタマイズ性を両立する **shadcn/ui** を標準採用します。
    *   **デザインシステム**: Tailwind Configの `extend` を活用し、プロジェクト固有のカラー、フォント、シャドウをトークンとして定義します。ハードコードされたHEX値（例: `#F00`）の使用を禁止します。
*   **CSSアーキテクチャ**:
    *   **ユーティリティファースト**: 原則としてTailwind Utilityクラスを使用します。
    *   **コンポーネント抽出**: 共通パターン（ボタン、カード）はReactコンポーネントとしてカプセル化し、`@apply` は極力使用しません（Tailwindチームの推奨）。
    *   **CSS Modules**: 複雑なアニメーションや、Tailwindで表現困難な場合にのみ、CSS Modules（または `styled-jsx`）の使用を許可します。
*   **Performance Budget (SLA)**:
    *   **Core Web Vitals**: **LCP < 2.5s**, **INP < 200ms**, **CLS < 0.1**. これらは「目標」ではなく「デプロイ要件」です。
    *   **Bundle Size**: Initial JSサイズを **150KB (Gzipped)** 以内に抑えます。超過時は `next/dynamic` で分割します。

### 2.1. Headless UI Architecture (Web Only Prohibition)
*   **Rule**: UIコンポーネントは「データの表示」と「イベントの発火」のみに専念し、ビジネスロジックを持たせてはなりません（Dumb UI）。
*   **Prohibition**: コンポーネント内で `fetch` を行ったり、特定ページのDOM構造に依存したステート管理（Web Only設計）を行うことは、将来のNative化を阻害するため厳禁です。

### 2.2. Interactive Components Standard
*   **Rich Selection Protocol**:
    *   従来のラジオボタン/チェックボックスは原則禁止とし、**「押せることが直感的にわかるリッチなカード型UI」** を標準とします。
*   **Responsive Combobox Protocol**:
    *   **Desktop**: `Popover` (modal=true) を使用し、コンテンツとの重なりには `z-[9999]` を付与します。
    *   **Mobile**: タッチ操作性を高めるため、Popoverではなく **Drawer (Vaul)** を使用します。
    *   **Interaction**: `CommandItem` には `pointer-events-auto` を強制し、`onClick`/`onPointerUp` をバインドしてタップ漏れを防ぎます。
*   **クラスの整列**: `prettier-plugin-tailwindcss` を導入し、クラス名の並び順を自動的かつ強制的に統一します。

## 3. フォームとバリデーション (Forms & Validation)
*   **ライブラリ選定**:
    *   **React Hook Form**: 非制御コンポーネントベースで、再レンダリングを最小限に抑えます。
    *   **Zod**: スキーマ駆動開発を行います。バリデーションロジックはUIから分離し、Zodスキーマとして定義します。
*   **バリデーション**:
    *   **クライアントサイド**: 必須入力、文字数、メール形式などは、サーバー送信前にリアルタイムでフィードバックします。
    *   **Media Interaction (Crop UI)**: 画像アップロード時、サーバー側での自動トリミング（Center Crop）は禁止です。必ず `react-easy-crop` 等のUIを提供し、ユーザー自身がトリミング範囲を決定できるフローを実装します。
    *   **Filename Sanitization**: 日本語ファイル名はトラブルの元となるため、アップロード時にクライアントサイドでローマ字変換（`wanakana`）を行います。
    *   **型安全性**: ZodからTypeScriptの型を推論（`z.infer`）し、フォームデータとAPIリクエストの型不一致を根絶します。

### 3.3. Auto-Save & Data Persistence Protocol
*   **Mandatory Scope**: 管理画面の記事、設定、長文入力フォームには **自動保存機能** が必須です（Data Loss Zero Tolerance）。
*   **Implementation Standard**:
    *   **Hook Strategy**: 標準化された `useAutoSave` フックを使用し、入力停止から一定時間後（例: 2000ms）にローカルストレージへ保存します。
    *   **Passive Restoration**: ページロード時に下書きを勝手に復元せず、**「下書きがあります」という通知（バナー）** を出し、ユーザーが選択できる仕様にします。
    *   **Hygiene**: 正常送信（Submit）完了時には、必ずローカルストレージをクリア (`clearDraft`) し、古いデータの残留を防ぎます。

## 4. PWAとクロスプラットフォーム (PWA & Cross-Platform)
*   **PWA (Progressive Web App)**:
    *   **インストール可能**: `manifest.json` を適切に設定し、ホーム画面への追加を可能にします。
    *   **オフライン対応**: Service Workerを使用して、オフラインでも主要機能（閲覧済みコンテンツ等）が動作するように設計します。
*   **Deep Linking**:
    *   **Smart App Banners**: モバイルブラウザで表示された際、ネイティブアプリがインストールされていればアプリを開き、なければストアへ誘導するバナーを実装します。

## 5. 互換性とエラーハンドリング (Compatibility & Error Handling)
*   **ブラウザ互換性 (Browser Compatibility)**:
    *   **ターゲット**: Chrome, Safari, Firefox, Edgeの最新2バージョン、およびiOS Safari, Android Chromeの最新2バージョンをサポートします。
    *   **Polyfill**: `core-js` 等を使用し、必要な機能のみをPolyfillします。
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
*   **フォント最適化 (Font Optimization)**:
    *   `next/font` を使用してGoogle Fontsをセルフホストし、レイアウトシフト（CLS）と外部リクエストを排除します。
*   **メタデータ管理**:
    *   **Dynamic Metadata**: ページタイトルは `[ページ名] | [サイト名]` の形式で統一し、サイト設定（DB）から動的に値を取得します。ハードコーディングは禁止です。
    *   **Image Fallback**: OGPやコンテンツ画像がDBに存在しない場合、`public/assets` 内のデフォルト画像をフォールバックとして使用するロジックを実装し、画像欠損（404）を防ぎます。
*   **SEO & GEO Strategy (Search & Generative)**:
    *   **Structured Data (JSON-LD)**: Machine-Readableであることを重視し、`LocalBusiness` (店舗), `Article` (記事), `BreadcrumbList` 等の構造化データを必ず実装します。AI (Perplexity/SGE) からの引用率を高めます。
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
    *   **Screen Reader**: 主要フローにおいて、スクリーンリーダー（VoiceOver/TalkBack）での実機テストを義務付けます。
    *   **Icon Labels**: テキストを含まないアイコンのみのボタンには、必ず `aria-label` 属性を付与し、機能を明示します。
    *   **WAI-ARIA**: "No ARIA is better than Bad ARIA". 可能な限りネイティブHTML要素を使用し、ARIA属性は必要最小限に留めます。
    *   **Radix UI / Headless UI**: 複雑なコンポーネントには、アクセシビリティ対応済みのヘッドレスUIライブラリを使用します。
*   **アトミックデザイン**:
    *   コンポーネントは再利用性を考慮して設計しますが、過度な抽象化は避けます。

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
