# 12. グロースとマーケティング (Growth & Marketing) Strategy - CMO View

## 1. プロダクト主導型成長 (Product-Led Growth - PLG)
*   **バイラル係数 (Viral K-factor)**:
    *   **目標**: K > 1（1人のユーザーが1人以上の新規ユーザーを連れてくる状態）を目指します。
    *   **招待メカニズム**: ユーザーが友人を招待する動機（インセンティブ）と、招待された側が参加しやすいフロー（ディープリンク）を設計します。
    *   **ネットワーク効果**: ユーザーが増えるほど、プロダクトの価値が指数関数的に高まる仕組み（データ共有、コミュニティ）を実装します。
*   **透かしとブランディング (Watermarks & Branding)**:
    *   **UGC (User Generated Content)**: ユーザーが生成したコンテンツ（画像、動画、共有リンク）には、必ずプロダクトのロゴや「Powered by...」を含め、外部への露出を最大化します。

## 2. テクニカルSEO (Technical SEO)
*   **構造化データ (Structured Data)**:
    *   **JSON-LD**: 全てのパブリックページに `Schema.org`（JSON-LD）を実装し、Google検索結果でのリッチスニペット表示（レビュー、価格、FAQ）を狙います。
*   **インデックス制御 (Indexing Control)**:
    *   **Sitemap自動化**: `next-sitemap` 等を使用し、ビルド時または定期的（ISR）にXMLサイトマップを自動生成します。手動更新は禁止です。
    *   **Search Console API**: 記事公開や更新時に、Google Search Console APIを叩いてインデックス登録を即時リクエストする仕組みを整えます。
    *   **URLの永続性 (URL Persistence)**: リニューアル時、旧URL（例: WordPressの `/archives/123`）からの301リダイレクトを必ず設定し、SEO評価（Link Juice）を継承します。
*   **Core Web Vitals**:
    *   SEO順位に直結するため、LCP, FID, CLSのスコアを常に緑色（Good）に保ちます。

## 3. オンボーディング最適化 (Onboarding Optimization)
*   **Aha! Momentへの短縮**:
    *   **Time to Value (TTV)**: ユーザーが登録してから「価値」を感じるまでの時間を極限まで短縮します。チュートリアルは最小限にし、「使いながら学ぶ」体験を提供します。
    *   **セットアップの遅延**: アカウント登録や詳細設定は、ユーザーが価値を感じた「後」に要求します（Lazy Registration）。
*   **フリクションの排除**:
    *   **SSO (Single Sign-On)**: Google/Appleログインを必須とし、パスワード入力の手間を省きます。

## 4. リテンション戦略 (Retention Strategy)
*   **習慣化 (Habit Formation)**:
    *   **フックモデル (Hook Model)**: トリガー（通知）→ アクション（アプリ起動）→ リワード（価値）→ 投資（データ入力）のサイクルを回します。
*   **復活施策 (Resurrection)**:
    *   休眠ユーザーに対して、単なる「戻ってきて」ではなく、「あなたが見逃している価値（例：新しいAI機能）」を具体的に提示する通知を送ります。

## 5. マーケティングテクノロジー (MarTech Stack)
*   **アトリビューション (Attribution)**:
    *   **AppsFlyer / Adjust**: モバイルアプリのインストール経路を正確に計測し、どの広告チャネルがLTVの高いユーザーを連れてきているかを特定します。
*   **ディープリンク (Deep Linking)**:
    *   **Universal Links / App Links**: Webやメールからアプリ内の特定の画面に直接遷移できるディープリンクを完備します。インストールされていない場合はストアへ誘導します（Deferred Deep Linking）。
