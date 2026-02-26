# 33. Webフロントエンドエンジニアリング (Web Frontend Engineering - Next.js)

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
*   **The Ad Category Exclusion Protocol (広告禁止カテゴリ)**:
    *   **Context**: サービスのブランドイメージに不適切な広告はLTVを毀損し、ユーザーの信頼を失います。
    *   **Law**: ギャンブル、アダルト、暴力、政治的広告など、サービスのブランドに不適切なカテゴリの広告を**システムレベルで配信禁止**してください。
    *   **Action**:
        1.  **External Ads（Google AdSense等）**: 管理画面のカテゴリブロック設定を適用し、設定内容を定期的に監査します。
        2.  **Self-Served Ads（自社広告）**: 広告入稿時にカテゴリ分類を義務付け、禁止カテゴリに該当する広告はバリデーションでRejectします。
