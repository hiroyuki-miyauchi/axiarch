# 33. Webフロントエンドエンジニアリング (Web Frontend Engineering - Next.js)

## 1. モダンWebアーキテクチャ (Modern Web Architecture)
*   **Next.js & React Server Components (RSC)**:
    *   **デフォルト**: 原則として **App Router** を使用し、可能な限りサーバーコンポーネント（RSC）でレンダリングします。これにより、クライアントに送信するJavaScript量を劇的に削減します。
    *   **データ取得**: データフェッチはサーバーサイドで行い、ウォーターフォール問題を回避します。
*   **エッジコンピューティング (Edge Computing)**:
    *   **ミドルウェア**: 認証チェックやジオロケーションによるリダイレクトは、**Edge Middleware** で実行し、レイテンシを最小化します。

## 2. UIコンポーネントとスタイリング (UI Components & Styling)
*   **shadcn/ui + Tailwind CSS**:
    *   **標準スタック**: UIコンポーネントライブラリには、アクセシビリティとカスタマイズ性を両立する **shadcn/ui** を標準採用します。
    *   **デザインシステム**: Tailwind Configの `extend` を活用し、プロジェクト固有のカラー、フォント、シャドウをトークンとして定義します。ハードコードされたHEX値（例: `#F00`）の使用を禁止します。
*   **CSSアーキテクチャ**:
    *   **ユーティリティファースト**: 原則としてTailwind Utilityクラスを使用します。
    *   **コンポーネント抽出**: 共通パターン（ボタン、カード）はReactコンポーネントとしてカプセル化し、`@apply` は極力使用しません（Tailwindチームの推奨）。
    *   **CSS Modules**: 複雑なアニメーションや、Tailwindで表現困難な場合にのみ、CSS Modules（または `styled-jsx`）の使用を許可します。
*   **クラスの整列**: `prettier-plugin-tailwindcss` を導入し、クラス名の並び順を自動的かつ強制的に統一します。

## 3. フォームとバリデーション (Forms & Validation)
*   **ライブラリ選定**:
    *   **React Hook Form**: 非制御コンポーネントベースで、再レンダリングを最小限に抑えます。
    *   **Zod**: スキーマ駆動開発を行います。バリデーションロジックはUIから分離し、Zodスキーマとして定義します。
*   **バリデーション**:
    *   **クライアントサイド**: 必須入力、文字数、メール形式などは、サーバー送信前にリアルタイムでフィードバックします。
    *   **型安全性**: ZodからTypeScriptの型を推論（`z.infer`）し、フォームデータとAPIリクエストの型不一致を根絶します。

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
    *   **CLS対策**: 画像には必ず `width` と `height` を指定（または `fill`）し、レイアウトシフトを防ぎます。
*   **フォント最適化 (Font Optimization)**:
    *   `next/font` を使用してGoogle Fontsをセルフホストし、レイアウトシフト（CLS）と外部リクエストを排除します。
*   **メタデータ管理 (Metadata Management)**:
    *   SEOのための `title`, `description`, `og:image` は、各ページで動的に生成し、完全に最適化します。

## 7. コンポーネント設計とアクセシビリティ (Component Design & A11y)
*   **アクセシビリティ (Accessibility - "Shift Left")**:
    *   **自動テスト**: CIで `axe-core` を実行し、コントラスト不足やラベル欠損を自動検知してブロックします。
    *   **スクリーンリーダー**: 主要フローは必ずスクリーンリーダー（VoiceOver/TalkBack）で実機テストを行います。
    *   **WAI-ARIA**: 「No ARIA is better than Bad ARIA」。可能な限りネイティブHTML要素を使用し、必要な場合のみARIA属性を付与します。
    *   **Radix UI / Headless UI**: 複雑なコンポーネントは、アクセシビリティ対応済みのヘッドレスUIライブラリを使用します。
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
