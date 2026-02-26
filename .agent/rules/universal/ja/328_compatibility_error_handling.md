# 33. Webフロントエンドエンジニアリング (Web Frontend Engineering - Next.js)

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
