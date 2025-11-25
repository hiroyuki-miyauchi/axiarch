# 33. Webフロントエンドエンジニアリング (Web Frontend Engineering - Next.js)

## 1. モダンWebアーキテクチャ (Modern Web Architecture)
*   **Next.js & React Server Components (RSC)**:
    *   **デフォルト**: 原則として **App Router** を使用し、可能な限りサーバーコンポーネント（RSC）でレンダリングします。これにより、クライアントに送信するJavaScript量を劇的に削減します。
    *   **データ取得**: データフェッチはサーバーサイドで行い、ウォーターフォール問題を回避します。
*   **エッジコンピューティング (Edge Computing)**:
    *   **ミドルウェア**: 認証チェックやジオロケーションによるリダイレクトは、**Edge Middleware** で実行し、レイテンシを最小化します。

## 2. CSSアーキテクチャとスタイリング (CSS Architecture & Styling)
*   **Tailwind CSS x BEM (Hybrid Approach)**:
    *   **基本戦略**: Tailwind CSSを標準としますが、クラス名の羅列による可読性低下を防ぐため、意味のあるコンポーネント単位で管理します。
    *   **BEMの厳格化**:
        *   **命名規則**: `Block__Element--Modifier` を厳守します。
        *   **孫要素の禁止**: `Block__Element__Grandchild` は禁止です。構造が深くなる場合は、新しいBlockとして切り出します（フラット構造の維持）。
        *   **状態管理**: BEMと合わせて `is-active`, `has-error` などのステートクラスを使用します（例: `Button--primary.is-active`）。
    *   **@applyの使用**: 5つ以上のUtilityクラスが並ぶ場合や、再利用可能なパターンは `@apply` を使用してCSSファイルに抽出することを検討します。
*   **ネスト構造の制限 (Nesting Limits)**:
    *   **深さ制限**: CSSのネストは **3階層まで** とします。それ以上深くなる場合は、コンポーネント設計が間違っています。
    *   **アンパサンド (`&`) の乱用禁止**: 検索性を損なうため、クラス名の一部を `&` で結合すること（例: `&__element`）は推奨しません。
*   **CSSパフォーマンス (CSS Performance)**:
    *   **アニメーション**: `transform` と `opacity` プロパティのみを使用します。`left`, `top`, `width`, `height` のアニメーションは、リフロー（レイアウト再計算）を引き起こすため**厳禁**です。
    *   **GPUアクセラレーション**: アニメーション要素には `will-change` プロパティを適切に使用し、GPUレイヤーを生成させます。
    *   **CSS Containment**: 複雑なレイアウトには `contain: content;` 等を使用し、レンダリング範囲を限定します。
    *   **Content Visibility**: 長大なリスト（無限スクロール等）には `content-visibility: auto` を使用し、画面外のレンダリングコストを削減します。

## 3. PWAとクロスプラットフォーム (PWA & Cross-Platform)
*   **PWA (Progressive Web App)**:
    *   **インストール可能**: `manifest.json` を適切に設定し、ホーム画面への追加を可能にします。
    *   **オフライン対応**: Service Workerを使用して、オフラインでも主要機能（閲覧済みコンテンツ等）が動作するように設計します。
*   **Deep Linking**:
    *   **Smart App Banners**: モバイルブラウザで表示された際、ネイティブアプリがインストールされていればアプリを開き、なければストアへ誘導するバナーを実装します。

## 3. 互換性とエラーハンドリング (Compatibility & Error Handling)
*   **ブラウザ互換性 (Browser Compatibility)**:
    *   **ターゲット**: Chrome, Safari, Firefox, Edgeの最新2バージョン、およびiOS Safari, Android Chromeの最新2バージョンをサポートします。
    *   **Polyfill**: `core-js` 等を使用し、必要な機能のみをPolyfillします。
*   **エラーハンドリング (Error Handling)**:
    *   **Error Boundaries**: Reactの `ErrorBoundary` を使用し、コンポーネントレベルでのクラッシュがアプリ全体を巻き込まないようにします。
    *   **グレースフル・デグラデーション**: JavaScriptが無効な場合やエラー発生時でも、最低限のコンテンツが表示されるように設計します。
    *   **0 Warnings**: コンソールに出力されるWarningは、技術的負債の予兆です。開発中に全て解消し、**Warning 0件** でなければリリースできません。

## 4. パフォーマンスとSEO (Performance & SEO - "Core Web Vitals")
*   **画像最適化 (Image Optimization)**:
    *   `next/image` コンポーネントを必ず使用し、デバイスサイズに応じた最適な画像サイズとフォーマット（AVIF/WebP）を自動配信します。
    *   **CLS対策**: 画像には必ず `width` と `height` を指定（または `fill`）し、レイアウトシフトを防ぎます。
*   **フォント最適化 (Font Optimization)**:
    *   `next/font` を使用してGoogle Fontsをセルフホストし、レイアウトシフト（CLS）と外部リクエストを排除します。
*   **メタデータ管理 (Metadata Management)**:
    *   SEOのための `title`, `description`, `og:image` は、各ページで動的に生成し、完全に最適化します。

## 5. コンポーネント設計とアクセシビリティ (Component Design & A11y)
*   **アクセシビリティ (Accessibility - "Shift Left")**:
    *   **自動テスト**: CIで `axe-core` を実行し、コントラスト不足やラベル欠損を自動検知してブロックします。
    *   **スクリーンリーダー**: 主要フローは必ずスクリーンリーダー（VoiceOver/TalkBack）で実機テストを行います。
    *   **WAI-ARIA**: 「No ARIA is better than Bad ARIA」。可能な限りネイティブHTML要素を使用し、必要な場合のみARIA属性を付与します。
    *   **Radix UI / Headless UI**: 複雑なコンポーネントは、アクセシビリティ対応済みのヘッドレスUIライブラリを使用します。
*   **アトミックデザイン**:
    *   コンポーネントは再利用性を考慮して設計しますが、過度な抽象化は避けます。

## 6. データ可視化とエクスポート (Data Visualization & Export)
*   **チャート (Charts)**:
    *   **ライブラリ**: `Recharts` または `Chart.js` を推奨します。
    *   **UX**: 静止画ではなく、ホバー時のツールチップ、ズーム、パンに対応したインタラクティブなグラフを実装します。
*   **エクスポート (Export)**:
    *   **Web Workers**: PDF/CSV生成はメインスレッドをブロックしないよう、Web Worker内で実行します。
    *   **互換性**: CSVは **BOM付きUTF-8** で出力し、Excelでの文字化けを防ぎます。PDFには日本語フォントを埋め込みます。

## 6. ユーザーガイド実装 (User Guidance Implementation)
*   **オンボーディングツアー (Onboarding Tours)**:
    *   **ライブラリ**: `driver.js` などの軽量かつアクセシブルなライブラリを使用し、フォーカストラップ（Focus Trap）とキーボード操作を保証します。
    *   **React Portals**: ガイド要素は `createPortal` を使用してDOMツリーの最上位にレンダリングし、`z-index` 戦争（スタッキングコンテキストの問題）を回避します。

## 7. デプロイとインフラ (Deployment & Infrastructure)
*   **Vercel**:
    *   デプロイ先は **Vercel** を第一選択肢とします。
    *   **プレビュー環境**: プルリクエストごとにプレビュー環境を自動生成し、デザインレビューや動作確認を容易にします。
*   **ISR (Incremental Static Regeneration)**:
    *   静的なコンテンツ（ブログ記事、ヘルプページ）はISRを使用し、ビルド時間の短縮と常に最新のコンテンツ表示を両立させます。
