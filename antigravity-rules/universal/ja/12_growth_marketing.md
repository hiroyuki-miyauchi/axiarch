# 12. グロースとマーケティング (Growth & Marketing) Strategy - CMO View

## 1. プロダクト主導型成長 (Product-Led Growth - PLG)
*   **バイラル係数 (Viral K-factor)**:
    *   **目標**: K > 1（1人のユーザーが1人以上の新規ユーザーを連れてくる状態）を目指します。
    *   **招待メカニズム**: ユーザーが友人を招待する動機（インセンティブ）と、招待された側が参加しやすいフロー（ディープリンク）を設計します。
    *   **ネットワーク効果**: ユーザーが増えるほど、プロダクトの価値が指数関数的に高まる仕組み（データ共有、コミュニティ）を実装します。
*   **透かしとブランディング (Watermarks & Branding)**:
    *   **UGC (User Generated Content)**: ユーザーが生成したコンテンツ（画像、動画、共有リンク）には、必ずプロダクトのロゴや「Powered by...」を含め、外部への露出を最大化します。

## 2. Technical SEO & GEO (Generative Engine Optimization)
*   **The GEO Mandate**:
    *   **Context**: 従来のSEO（対Google）に加え、PerplexityやSearchGPTなどの「AI検索エンジン」への最適化（GEO）を義務付けます。
    *   **Definition**: GEOとは、AIが学習・引用しやすい形式で情報を提供し、回答生成時の「信頼できる引用元（Primary Source）」として選ばれるための戦略です。
*   **構造化データ (Structured Data)**:
    *   **JSON-LD**: 全てのパブリックページに `Schema.org`（JSON-LD）を実装し、Google検索結果でのリッチスニペット表示（レビュー、価格、FAQ）を狙います。
    *   **The Direct Answer Protocol (アンサーファースト)**:
        *   **Context**: AI検索エンジン（SGE, Perplexity）は、ユーザーの質問に対する「直接的な回答」を抜粋します。
        *   **Action**: コンテンツは「結論を最初に（アンサーファースト）」「手順は番号付きリストで」「比較はテーブルで」記述することを強制します。「〜とは、〜のことである」という定義構文も有効です。
    *   **The Q&A Anchor Protocol (質問形式見出し)**:
        *   **Context**: AI（RAG）は「質問」と「回答」のペアを探しています。
        *   **Action**: 記事の見出し（H2/H3）を「〜とは？」や「〜のメリットは？」等の**質問形式**にし、直後のパラグラフで**結論**を述べる構造を推奨します。これにより、AI検索エンジンが「回答」として抜粋しやすくなります。
    *   **The Data Tokenization Protocol (データ密度向上)**:
        *   **Law**: AIは曖昧な形容詞による表現より、**具体的な数値・データ**（スペック、価格、日付、法規制番号等）を好みます。
        *   **Action**: テーブル（`<table>`）やリスト（`<ul>`/`<ol>`）で整理された情報はAIにとって解析コストが低く引用されやすいため、可能な限りこの形式を採用してください。
    *   **The Primary Source Citation (一次情報引用)**:
        *   **Law**: 事実（統計、法律、医学データ）を述べる際は、可能な限り信頼できる一次情報（公的機関、論文、公式サイト）への発リンクを行います。
        *   **Effect**: これは「情報の裏付け」があることを検索エンジン及びAIに示し、信頼度スコア（Trustworthiness）を向上させます。
    *   **The Author Visibility Protocol (著者情報の明示)**:
        *   **Law**: AIは「誰が言っているか」を重視します。記事やコンテンツには必ず**著者プロフィール（名前、肩書き、顔写真、SNSリンク）**を明記してください。
        *   **Action**: Schema.orgの `author` プロパティを使用し、著者情報を構造化データに含めます。著者ページへのリンクも推奨します。
    *   **The Reviewer Visibility Protocol (監修者明示)**:
        *   **Context**: YMYL (Your Money Your Life) 領域では、誰が書いたか以上に「誰が認めたか」が重要です。
        *   **Action**: 専門家（医師、弁護士等）が監修した記事には、必ず `reviewer` プロパティを使用して監修者情報を構造化データに含めてください。
*   **The URL as State Protocol (状態のURL表現)**:
    *   **Law**: フィルタ、ソート、ページネーション等のUI状態は、クエリパラメータ（例: `?area=tokyo&sort=rating`）で再現可能にします。
    *   **Action**:
        1.  **Shareable URLs**: ユーザーが状態を共有・ブックマークできるようにします。
        2.  **Canonical Normalization**: 同一コンテンツへの複数URL（パラメータ順序違い等）は `canonical` タグで正規化し、SEO評価の分散を防ぎます。
*   **インデックス制御 (Indexing Control)**:
    *   **Sitemap自動化**: `next-sitemap` 等を使用し、ビルド時または定期的（ISR）にXMLサイトマップを自動生成します。手動更新は禁止です。
    *   **Search Console API**: 記事公開や更新時に、Google Search Console APIを叩いてインデックス登録を即時リクエストする仕組みを整えます。
    *   **URLの永続性 (URL Persistence)**: リニューアル時、旧URL（例: WordPressの `/archives/123`）からの301リダイレクトを必ず設定し、SEO評価（Link Juice）を継承します。
    *   **The Pre-Launch Indexing Protocol (Sealed SEO)**:
        *   **Law**: 正式ドメインへの移行およびステークホルダーからの明示的な「Launch承認」があるまで、`robots: noindex` 設定を**絶対に解除してはなりません**。
        *   **Risk**: 未完成の状態でのインデックス登録は、ドメイン評価の毀損、重複コンテンツ、ブランドイメージの低下を招きます。
        *   **Action**: 開発・ステージング環境では、`next.config.js` や `middleware` でnoindex を強制し、本番かつ明示的承認後のみ解除するフローを構築してください。
    *   **The Hreflang Protocol (国際化URL戦略)**:
        *   **Context**: 将来の多言語展開に備え、SEOを損なわないURL設計を予約します。
        *   **Law**: 言語ごとにユニークなURL（例: `/en/products/tokyo`）を持つ**サブディレクトリ戦略**を採用してください。クエリパラメータ（`?lang=en`）やCookieによる言語切り替えはSEO上禁止です。
        *   **Action**: 多言語対応時は `hreflang` タグを実装し、各言語版ページの対応関係を検索エンジンに正確に伝えてください。
*   **Core Web Vitals**:
    *   SEO順位に直結するため、**LCP, INP, CLS** のスコアを常に緑色（Good）に保ちます。
*   **The SEO Integrity Protocol (Canonical & Internal Link)**:
    *   **Law**: 全ての公開ページにおいて、`generateMetadata` を用いた `canonical` URLのリターンを義務付けます。
    *   **Action**: ページ遷移時にパンくずリスト（Breadcrumbs）の階層構造をJSON-LDとして動的に生成し、クローラにサイト構造を正確に伝えてください。
*   **The Consent Mode v2 Protocol (Compliance Tracking)**:
    *   **Context**: 欧州経済領域 (EEA) や日本国内の法規制（改正電気通信事業法等）への対応。
    *   **Law**: Google Consent Mode v2 を実装し、ユーザーの同意状態 (`ad_storage`, `analytics_storage`, `ad_user_data`, `ad_personalization`) に応じてタグの発火を動的に制御してください。
    *   **Action**: 同意管理プラットフォーム (CMP) を導入するか、自社で同意取得 UI を構築し、`gtag('consent', 'default'|'update', ...)` を正確に叩くフローを標準化します。
*   **The Data Layer Standard (Standardized Observation)**:
    *   **Law**: コンバージョンやユーザー行動の計測において、DOMスクレイピング（「ボタンのテキストが〜なら」といった判定）を禁止します。
    *   **Action**: 必ず `window.dataLayer.push({ event: 'event_name', ... })` という構造化されたデータレイヤーを介して GTM (Google Tag Manager) 等へ情報を渡してください。

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

## 6. Marketing Feeds & Integrations (広告フィード連携)
*   **The Marketing Feed Protocol (自動同期)**:
    *   **Law**: 商品やサービスを広告プラットフォーム（Google Shopping, Meta Dynamic Ads等）で展開する場合、手動更新に依存せず、常に最新のデータを自動同期するフィードを整備します。
    *   **Action**:
        1.  **Feed Endpoint**: 商品データフィード (XML/TSV/JSON) を出力するAPIエンドポイント（例: `/api/feeds/ads`）を実装します。
        2.  **Realtime Sync**: 在庫、価格、ステータスの変更は、フィード経由で広告媒体に即時反映されるようにします。
        3.  **Schema Compliance**: Google Merchant Center等のスキーマ要件を厳守し、審査エラーを未然に防ぎます。

## 7. Traffic Risk Diversification (トラフィック・リスク分散)
*   **The Owned Audience Mandate (脱プラットフォーム依存)**:
    *   **Risk**: 外部プラットフォーム（Google検索アルゴリズム変更、SNSポリシー変更）によるトラフィックの突然の蒸発。
    *   **Law**: 外部プラットフォームに依存しない「自社保有の顧客リスト（Owned Audience）」を構築することを義務付けます。
    *   **Action**:
        1.  **Newsletter/LINE**: ユーザー登録時にメルマガまたはチャットプラットフォーム（LINE等）への登録を促し（Opt-in）、検索を経由せず直接リーチできる手段を確保します。
        2.  **Web Push**: PWAのWeb Push通知を実装し、リテンション（再訪）をコントロール可能にします。
        3.  **Community Building**: 自社フォーラムやDiscord等のコミュニティを構築し、プラットフォームに依存しないユーザー基盤を形成します。
*   **The CAPI Direct Connection Protocol (First-Party Sovereignty)**:
    *   **Context**: ブラウザのCookie制限や広告ブロックによる欠損対策。
    *   **Law**: Meta CAPI や Google Ads Enhanced Conversions を、Pixel（フロントエンド）経由だけでなく、**サーバーサイド (Next.js Server Actions) から直接** 送信する「二重送信プロトコル」を標準とします。
    *   **Action**: 
        1. **Deduplication**: PixelとCAPIで同一の `event_id` (UUID) を使用し、媒体側での重複排除を保証してください。
        2. **PII Normalization**: サーバーから送信する個人情報（メールアドレス、電話番号等）は、必ずクライアントサイドではなくサーバーサイドで **SHA-256 ハッシュ化** してから送信することを厳守してください。
*   **The Data-Driven Marketing Protocol (Plan Abstraction)**:
    *   **Law**: コード内で特定のプラン ID を直接判定することを禁止します。
    *   **Mandate**: プランの性質（Enterprise かどうか、特定機能の開放等）は、必ず決済プラットフォーム（Stripe 等）の **Metadata** に持たせ、コードはそれを動的に参照してください。
    *   **Goal**: 開発チームを介さずに、ビジネス側でプランごとの権限や機能を即座に変更できる「経営の機動力」を最大化します。
### 7.1. The Metadata Segregation Protocol (Marketing Content Hygiene)
*   **Law**: コンテンツの「本来の属性（名前、価格、説明）」と、マーケティング用の「メタ情報（SEO用タイトル、広告用キャッチコピー）」を物理的に分離して管理してください。
*   **Action**: `items` テーブル等の主データと、`marketing_metadata` (jsonb または専用テーブル) を分離し、UI においてマーケターが後者を編集しても、システムの基盤ロジック（注文処理、通知等）が壊れない依存関係を構築してください。
*   **Rationale**: 広告表現の最適化（ABテスト）のために商品名を変えた結果、発送伝票の名前まで変わってしまう「密結合の悲劇」を物理的に回避します。

## 8. Growth Performance Architecture (成長パフォーマンス基盤)
*   **The Growth-Critical Performance Mandate (成長KPI直結ページのパフォーマンス義務)**:
    *   **Law**: ユーザー獲得（Acquisition）と定着（Retention）に直結するページ（LP、フィード、検索結果等）は、パフォーマンスを最優先し、キャッシュ戦略の適用を必須とします。
    *   **Targets**:
        1.  **First Paint < 1秒**: 新規ユーザーの離脱防止のため、初期データはキャッシュから即時配信します。
        2.  **Engagement API < 100ms**: いいね・ブックマーク等のインタラクションは Optimistic UI で即座に反映します。
        3.  **Feed/Search < 200ms**: パーソナライズされたコンテンツ推薦や検索結果はキャッシュを活用して高速配信します。
    *   **Retention Strategy**:
        *   **Push Data Prefetch**: 通知経由での復帰時、対象コンテンツをキャッシュで即時表示します。
        *   **Offline-First**: 既読コンテンツをローカルキャッシュし、オフライン時でも閲覧可能にします。
    *   **Mandate**: 成長KPI（DAU/MAU、セッション時間）に直結するページは、必ずキャッシュ階層（`11_business_finance.md` §1 Cache Hierarchy Standard 参照）を適用してください。

## 9. Dynamic OGP & Social Sharing (動的OGPとソーシャル共有)
*   **The Dynamic OGP Protocol (動的OGP画像生成)**:
    *   **Law**: 詳細ページや記事ページなど、ソーシャル共有される可能性が高いページでは、タイトル、評価、画像を合成した**動的OGP画像**をオンデマンド生成し、SNS共有時のCTR（クリック率）を最大化します。
    *   **Action**:
        1.  **Server-Side Generation**: Edge Function やサーバーサイドのOGP画像生成ライブラリを使用し、リクエスト時に動的にOGP画像を生成します。
        2.  **CDN Cache**: 生成コスト削減のため、CDNキャッシュ（例: `s-maxage=86400`）を適用し、同一ページへの繰り返しリクエストでは再生成を防ぎます。
        3.  **Fallback**: 動的生成に失敗した場合、サイト共通のデフォルトOGP画像にフォールバックし、空のOGPを避けます。

## 10. First-Party Data & Attribution (ファーストパーティデータと帰属分析)
*   **The First-Party Data Strategy (ファーストパーティデータ戦略)**:
    *   **Context**: サードパーティCookieの廃止やブラウザのプライバシー強化により、広告媒体経由のトラッキング精度が低下しています。
    *   **Law**: 初回流入時の `utm_source`、`utm_medium`、`utm_campaign` 等のパラメータをCookieまたはSessionに保存し、ユーザー登録時にユーザーレコードの参照元メタデータとして記録します。
    *   **Attribution Model**: Last Click（最後のタッチポイント）ではなく、**First Touch（最初の接触）**を評価することで、新規ユーザー獲得に最も貢献したチャネルを正確に特定します。
    *   **Data Ownership**: 広告プラットフォームが提供するデータに依存せず、自社データベースに帰属情報を蓄積することで、プラットフォーム変更やポリシー変更に左右されない分析基盤を構築します。

## 11. Product Feedback & Continuous Improvement (プロダクトフィードバック)
*   **The Feedback Loop Protocol (NPS/CSAT)**:
    *   **Context**: GA4等の定量データだけでは「なぜ離脱したか」「なぜ不満か」の定性的な理由は分かりません。
    *   **Micro-Survey**:
        *   **Relevance**: コンテンツ（記事、検索結果、推薦等）の末尾に「この情報は役に立ちましたか？ (Yes/No)」を配置し、コンテンツ品質のシグナルを収集します。
        *   **NPS (Net Promoter Score)**: サービス利用開始から一定期間（例: 30日）後のアクティブユーザーに、「このサービスを友人に勧めたいですか？ (0-10)」を問うモーダルを表示します。
    *   **Action**: 低評価（Detractor: 0-6）ユーザーには「どのような点が不満でしたか？」と深堀りの自由記述を促し、プロダクト改善のヒントを取得します（Product-Led Growth）。
    *   **Frequency Control**: 同一ユーザーへのサーベイ表示は、最低でも**90日間隔**を空け、サーベイ疲れ（Survey Fatigue）を防ぎます。
