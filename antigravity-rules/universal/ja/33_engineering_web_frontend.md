# 33. Webフロントエンドエンジニアリング (Web Frontend Engineering - Next.js)

## 1. モダンWebアーキテクチャ (Modern Web Architecture)
*   **Next.js & React Server Components (RSC)**:
    *   **デフォルト**: 原則として **App Router** を使用し、可能な限りサーバーコンポーネント（RSC）でレンダリングします。これにより、クライアントに送信するJavaScript量を劇的に削減します。
    *   **データ取得**: データフェッチはサーバーサイドで行い、ウォーターフォール問題を回避します。
*   **エッジコンピューティング (Edge Computing)**:
    *   **ミドルウェア**: 認証チェックやジオロケーションによるリダイレクトは、**Edge Middleware** で実行し、レイテンシを最小化します。

## 2. CSSアーキテクチャとスタイリング (CSS Architecture & Styling)
*   **Tailwind CSS (Utility-First)**:
    *   **基本戦略**: Tailwind CSSを標準とします。クラス名の衝突を防ぎ、バンドルサイズを最小化します。
    *   **BEMの思想**: Tailwindを使用する場合でも、コンポーネントの構造はBEM（Block Element Modifier）の思想（依存関係の分離）を維持します。
*   **CSSパフォーマンス (CSS Performance)**:
    *   **リフロー/リペイント回避**: アニメーションには `transform` と `opacity` のみを使用します。`left`, `top`, `width` のアニメーションは禁止です。
    *   **CSS Containment**: 複雑なレイアウトには `contain` プロパティを使用し、ブラウザのレンダリングコストを削減します。
*   **モバイルファースト (Mobile First)**:
    *   **デフォルトスタイル**: メディアクエリなしのスタイルは「モバイル用」として記述します。
    *   **拡張**: `sm:`, `md:`, `lg:` プレフィックスを使用して、画面サイズが大きくなるにつれてスタイルを上書きします（Min-width Media Queries）。

## 3. パフォーマンスとSEO (Performance & SEO - "Core Web Vitals")
*   **画像最適化 (Image Optimization)**:
    *   `next/image` コンポーネントを必ず使用し、デバイスサイズに応じた最適な画像サイズとフォーマット（AVIF/WebP）を自動配信します。
    *   **CLS対策**: 画像には必ず `width` と `height` を指定（または `fill`）し、レイアウトシフトを防ぎます。
*   **フォント最適化 (Font Optimization)**:
    *   `next/font` を使用してGoogle Fontsをセルフホストし、レイアウトシフト（CLS）と外部リクエストを排除します。
*   **メタデータ管理 (Metadata Management)**:
    *   SEOのための `title`, `description`, `og:image` は、各ページで動的に生成し、完全に最適化します。

## 4. コンポーネント設計 (Component Design)
*   **アトミックデザイン (Atomic Design)**:
    *   コンポーネントは再利用性を考慮して設計しますが、過度な抽象化は避けます。「早すぎる最適化」よりも「変更の容易さ（Colocation）」を優先します。
*   **アクセシビリティ (Accessibility - A11y)**:
    *   **Radix UI / Headless UI**: 複雑なインタラクティブコンポーネント（ダイアログ、ドロップダウン）は、アクセシビリティが担保されたヘッドレスUIライブラリを使用し、スタイルのみをTailwind CSSで適用します。

## 5. デプロイとインフラ (Deployment & Infrastructure)
*   **Vercel**:
    *   デプロイ先は **Vercel** を第一選択肢とします。
    *   **プレビュー環境**: プルリクエストごとにプレビュー環境を自動生成し、デザインレビューや動作確認を容易にします。
*   **ISR (Incremental Static Regeneration)**:
    *   静的なコンテンツ（ブログ記事、ヘルプページ）はISRを使用し、ビルド時間の短縮と常に最新のコンテンツ表示を両立させます。
*   **Edge Functions**:
    *   低遅延が求められる処理（AIストリーミング、認証ミドルウェア）はEdge Runtimeで実行する。
