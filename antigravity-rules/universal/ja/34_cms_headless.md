# 34. コンテンツ管理システム (Content Management System - Headless) CMS

## 1. ヘッドレス・アーキテクチャ (Headless Architecture)
*   **Content as Data**:
    *   **原則**: コンテンツは「表示」から切り離された「純粋なデータ」として管理します。
    *   **API First**: コンテンツの取得は全てAPI経由で行い、Web、モバイルアプリ、スマートウォッチなど、あらゆるデバイス（オムニチャネル）への配信を可能にします。
    *   **The AI-Ready Content Protocol (RAG Optimization)**:
        *   **Law**: コンテンツは、人間だけでなく AI エージェント（RAG/Search）が理解し、引用しやすい構造で設計してください。
        *   **Action**: プレーンテキストのみの巨大な塊（Wall of Text）を避け、可能な限り **セマンティックなマークアップ（H2/H3、リスト、定義リスト）** と、メタデータ（要約、キーワード、信頼性スコア）をセットで保持させてください。
*   **選定基準**:
    *   **推奨**: Contentful, MicroCMS, Sanity などのSaaS型ヘッドレスCMSを第一選択とします。
    *   **WordPress**: WordPressを使用する場合は、必ず **Headless Mode (WPGraphQL)** で使用し、フロントエンド（Next.js）と完全に分離します。PHPによるテーマ開発は禁止です。

## 2. メディア資産管理 (Media Asset Management)
*   **統合ストレージ戦略 (Centralized Media Strategy)**:
    *   **一元管理**: アプリケーションで使用される全ての画像（コンテンツ、ロゴ、アイコン）は、`public/` フォルダへの配置を禁止し、統合メディアライブラリ（Cloud Storage / S3）で管理します。これにより、全ての資産が管理画面から制御可能になります。
    *   **セマンティック構造**: フォルダ構造は `category/YYYY/MM/Slug/` のように意味のある階層構造を強制します。ランダムなIDではなく、人間が識別可能な英数字を使用します。
    *   **ファイル名の一意性**: 同一フォルダ内でのファイル名重複を禁止し、上書きを防ぎます。
*   **安定性とフォールバック (Stability & Fallback)**:
    *   **No-Image規定**: 画像が存在しない、またはリンク切れの場合のフォールバックは、コード内へのハードコーディングを禁止し、必ずストレージ上の「共通No-Image画像」を参照させます。
*   **権限の分離 (Separation of Concerns)**:
    *   **管理者 vs ユーザー**: 「システムアセット（管理者が管理）」と「UGC（ユーザーが投稿）」は、バケットまたはルートフォルダレベルで**物理的に分離**します。UGCがシステム領域を汚染することを防ぎます。
*   **Asset Classification Strategy**:
    *   **Official Assets**: 運営コンテンツ（記事、バナー）は `admin/media/` で管理し、必ず「Media Library」のみを経由して選択させます。
    *   **The Original Preservation Protocol (管理者資産保護)**:
        *   **Law**: 管理者がアップロードする画像は「マスターデータ」であるため、サーバーサイドでの圧縮・破壊的変換を一切行いません。
        *   **Action**: 最適化（WebP化、リサイズ）はすべて配信時（CDN Edge）に行い、オリジナルファイルは劣化なしで保存します。
    *   **User Assets**: UGC（プロフィール、投稿）は `users/{uid}/` に隔離し、ユーザー設定画面からの直接アップロードを許可します。
    *   **The Video Ban Protocol (Cost & Risk Control)**:
        *   **Law**: 動画ファイルのサーバーへの直接アップロードは、帯域コストとコンテンツ監視（不適切な動画）の観点から禁止します。
        *   **Action**: 動画コンテンツは YouTube / Vimeo 等の外部プラットフォームへのアップロードを必須とし、システム側ではその「埋め込みコード（iframe/ID）」のみを保持します。
*   **Editor Integration Protocol (Admin Side)**:
    *   **Direct Upload Ban**: 管理画面のエディタ（Tiptap等）への直接ドラッグ＆ドロップやペーストによるアップロードは**禁止**します。
    *   **Centralized Flow**: 画像挿入は必ず「Media Library」モーダルを経由させ、既存資産の再利用を強制します。重複アップロードによるストレージの無駄を防ぎます。

## 3. パフォーマンスと配信 (Performance & Delivery)
*   **SSG / ISR**:
    *   コンテンツはビルド時（SSG）またはリクエスト時（ISR）に静的なHTMLとして生成し、CDNから配信します。CMSサーバーへの直接アクセスを極限まで減らし、爆速の表示速度を実現します。
*   **画像最適化**:
    *   CMSから配信される画像は、フロントエンド側で `next/image` 等を使用して最適化・キャッシュします。CMSの画像URLをそのまま`img`タグで使用することは避けます。
*   **The Storage URL Hardcoding Ban (URLハードコード禁止)**:
    *   **Law**: 画像やファイルのURLをコード内に `https://...` と直接記述（ハードコーディング）することを禁じます。
    *   **Action**: 必ず `getStorageUrl(path)` 等のユーティリティ関数を介してドメインやパスを解決してください。これにより、将来的なバケット名の変更やCDNプロバイダの乗り換えに対する柔軟性を確保します。
    *   **Rationale**: ハードコードされたURLは、インフラ変更時にコードベース全体をgrepして修正する負債を生みます。

## 4. 運用とセキュリティ (Operations & Security)
*   **プレビュー機能**:
    *   編集者が公開前にコンテンツを確認できるよう、Next.jsの **Preview Mode** を実装し、ドラフト状態のコンテンツをセキュアに表示します。
*   **セキュリティ**:
    *   CMSの管理画面はIP制限やSSOで保護し、一般公開されるフロントエンドとは完全に切り離します。これにより、CMS特有の脆弱性リスクを最小化します。
    *   **The Media Library Sanctuary (Code Sanctuary)**:
        *   **Context**: メディア管理ロジック（`admin/media`）は、複雑なアップロード、リサイズ、権限管理（RLS）を含むセキュリティの要であり、デリケートです。
        *   **Law**: `components/admin/media/*` および `api/media.ts` 対し、AIによる独断でのリファクタリング・削除を禁止します。変更の際は必ずユーザーの明示的承認を得てください。
## 5. Layout & Widget Architecture (Hybrid Strategy)
*   **The Hybrid Design Protocol (Content vs Layout)**:
    *   **Context**: CMSは「コンテンツの実体（Relational）」と「配置情報（JSON）」を分離するハイブリッド設計をベストプラクティスとします。
    *   **Rule**: 記事や商品は正規化されたテーブルで管理し、トップページのセクション順序やウィジェット配置のみを **JSON配列**（例: `['hero', 'ranking', 'new']`）として管理します。
*   **Dynamic Page Builder**:
    *   **No Hardcoding Strategy**: トップページやLPの構成をハードコーディングせず、管理画面から「特集バナー」「ランキング」「新着」などのセクションを自由に追加・並び替えできるCMS型アーキテクチャを採用します。
    *   **Component Isolation**: 各セクションは独立したコンポーネントとして定義し、エラー時は `ErrorBoundary` で隔離してページ全体のクラッシュを防ぎます。
    *   **LCP Optimization**: ヒーローバナーなどの重要要素は必ずSSRでレンダリングし、`priority={true}` でプリロードして表示速度を最優先します。
    *   **Sidebar Widgets**: サイドバーはDBレコードではなく **Reactコンポーネント** として定義し、設定JSON (`sidebar_order`) に基づいて動的にマッピングします。
*   **The Component Mapping Protocol (CMS-UI Bridge)**:
    *   **Law**: CMSの種別（Type）とフロントエンドのコンポーネントを 1:1 で紐付ける **`ComponentRegistry`** を物理的に定義し、ハードコードされた `switch` 文での分岐を排除してください。
    *   **Action**: `Object.entries()` や動的インポートを活用し、CMSのレスポンスを受け取った瞬間に自動で対応する UI が描画される「プラグイン・アーキテクチャ」を維持してください。

## 6. Content Operations Protocol (運用基盤)
*   **Publishing Workflow**:
    *   **Status Transition**: コンテンツは `draft` (下書き) -> `pending` (承認待ち) -> `published` (公開) -> `archived` (論理削除) のステータス遷移を厳守します。
    *   **Secure Preview**: 公開前の記事は、署名付きURL (`verify(token)`) を介してのみプレビュー可能とします。
    *   **Scheduled Publishing**: `status = 'published'` かつ `published_at <= NOW()` の条件でのみ公開とみなします。キャッシュパージ（ISR/Revalidate）をスケジュール実行する仕組みを併用します。
*   **The Content Approval Gate Protocol (承認ゲート)**:
    *   **Law**: ステータス遷移は「誰が」「どの条件で」実行できるかを厳密に制御しなければなりません。条件なき遷移はコンテンツ品質事故の直接原因です。
    *   **Transition Rules**:
        | 遷移 | 実行可能な権限 | 条件 |
        |:---|:---|:---|
        | `draft → pending` | 作成者（Writer） | 本文が空でないこと |
        | `pending → published` | **管理者（Editor以上）** | レビュー完了フラグが `true` |
        | `published → archived` | 管理者 | アーカイブ理由の入力必須 |
        | `archived → draft` | 管理者 | 再編集開始の監査ログ記録 |
        | `pending → draft` | 作成者 or 管理者 | 差し戻し理由のコメント必須 |
    *   **Self-Publish Ban**: 作成者が自身のコンテンツを直接 `published` にすることは **禁止** します。必ず管理者の承認を経てください。
    *   **Audit Trail**: ステータス遷移は全て監査ログテーブルに記録します（`who`, `when`, `from_status`, `to_status`, `reason`）。
*   **Automated SEO**:
    *   **Meta Automation**: タイトルやOGPが未設定の場合、本文からのAI要約やデフォルト画像により自動補完し、不完全な状態での公開を防ぎます。
    *   **Internal Linking**: 関連コンテンツ（タグ・カテゴリ一致）を自動レコメンドし、内部リンク構造を強化します。

## 7. Editor Governance (Rich Text Policy)
*   **Tiptap Governance**:
    *   **Strict Schema**: エディタ（Tiptap等）では、H2/H3などの許可された要素のみを使用可能にし、運用者によるデザイン破壊を防ぎます。
    *   **The Triple Write Protocol (Data Integrity)**:
        *   **Law**: リッチテキストデータは、CMSおよびバックエンドの整合性を保つため、以下の3形式での**Atomic Update**を義務付けます。
            1.  **JSON (Editor Source)**: 将来の拡張性と再編集性のための構造化データ。
            2.  **HTML (View Source)**: フロントエンドでのパース負荷をゼロにするための表示用HTML。
            3.  **TEXT (Search Source)**: 検索インデックス用のプレーンテキスト（タグ除去済み）。
        *   **Outcome**: これにより、「編集の自由度」「表示パフォーマンス」「検索精度」を同時に最大化します。保存データはHTML文字列ではなく、必ず **JSON形式 (`JSONContent`)** とし、将来の拡張性を担保します。
    *   **Paste Sanitization (DOMPurify)**: ペースト時および表示時（Read）には必ずサニタイズを行い、悪意あるスクリプトや崩れたスタイルを排除します。
    *   **PII Real-time Warning**: エディタ内で電話番号やメールアドレスの入力を検知した場合、保存をブロックするのではなく、即座にToast等で「警告（Alert）」を表示し、ユーザーに再考を促します。
    *   **Code Injection**: HTML直接入力ノードを使用する場合は、必ずコードエディタ（PrismJS等）を通し、構文エラーによるレイアウト崩れを防ぎます。
    *   **The CMS Transparency Protocol (View Source Mandate)**:
        *   **Law**: WYSIWYGエディタは複雑なHTML構造のデバッグに限界があります。パワーユーザーやデバッグのために、生のHTMLを閲覧・編集できる機能が不可欠です。
        *   **Action**: リッチテキストエディタには、必ず「ソースコード表示 (View Source)」機能を実装してください。表示だけでなく、その場で修正して反映できる双方向編集（Two-way binding）をサポートすることを義務付けます。
*   **The Micro-Content Protocol (軽量テキスト戦略)**:
    *   **Context**: 「補足注釈」「アクセス情報の備考」など、記事ほどリッチではないが改行やリンクが必要な小規模テキストフィールド。
    *   **Law**: このようなフィールドにリッチテキストエディタ（Tiptap等）を使用することを禁止します。データ構造の肥大化（`string` vs `JSON`）とパフォーマンス劣化を招きます。
    *   **Action**: 標準の `Textarea` + `Markdown` パーサー（`react-markdown` 等）構成を採用し、データ構造をシンプルに保ってください。

## 8. Audit & Revision History
*   **Historian Protocol**:
    *   **Revisioning**: コンテンツ保存ごとに `revisions` テーブルへ差分を保存し、「いつ誰が変更したか」を追跡可能にします。
    *   **Rollback**: 誤操作時に過去のリビジョンへワンクリックで復元できる機能を標準実装します。
    *   **The Content Revision Protocol (リビジョン管理の詳細化)**:
        *   **Retention**: リビジョンは **無期限保存** を原則とします。ストレージコストが問題になる場合のみ、アーカイブポリシーを別途定義してください。
        *   **Diff View**: 管理画面から直近N件（推奨: 10件以上）のリビジョン間差分表示（Diff View）を実装し、変更内容の可視化を義務付けます。
        *   **Legal Document Versioning**: 利用規約やプライバシーポリシー等の法的文書は特に厳格に管理し、任意の過去時点のバージョンを復元・表示可能にしてください（Legal Time Machine）。

## 9. Fixed Page Strategy (Static & Headless)
*   **The "Fixed Page" Engine**:
    *   **Dynamic & Static**: 利用規約やLPなどの「固定ページ」もハードコードせず、ヘッドレスCMS (`fixed_pages`) と動的ルーティング (`/[slug]`) で管理します。
    *   **ISR Strategy**: 更新頻度が低いため、`revalidate: 3600` (1時間) 以上のISRを設定し、DB負荷を最小化します。
    *   **PII Protection**: エディタ入力時に個人情報（電話番号等）が含まれる場合、リアルタイムで警告を表示するガードレールを設置します。
    *   **API-First Delivery**: Webだけでなく、将来のアプリ配信（WebView回避）を見据え、必ずJSONデータを返すAPIエンドポイントをセットで実装します。

## 10. 動的コンテンツ管理 (Dynamic Content Management)

### 10.1. The Dynamic Sections Protocol (動的セクション管理)
*   **Law**: トップページやランディングページの構成（セクションの順序、表示/非表示、データソース）は、コードにハードコードせず、**DB/CMS から動的に取得** してください。
*   **Action**:
    1.  **Section Registry**: 利用可能なセクションタイプ（ヒーロー、ランキング、新着、特集等）をマスターデータとして定義します。
    2.  **Page Composition**: ページ単位で「どのセクションを何番目に表示するか」を管理テーブルまたは JSONB で設定可能にします。
    3.  **No Deploy for Layout**: ページレイアウトの変更にコードデプロイを必要としない設計を維持してください。
    4.  **LCP Performance**: ファーストビュー（ヒーローセクション等）は必ずSSR（Server-Side Rendering）し、画像には `priority` 属性を設定してプリロードすることで、LCP（Largest Contentful Paint）を最適化してください。

### 10.2. The Preview Gate Protocol (プレビュー認可)
*   **Law**: 下書き（Draft）や非公開コンテンツのプレビューは、**認証済み管理者のみ** がアクセスできるよう制御してください。
*   **Action**:
    1.  **Draft Isolation**: プレビューモードでは、公開クエリに `status = 'draft'` を含め、通常ユーザーには見えない状態を維持します。
    2.  **Auth Gate**: プレビュー URL には認証トークンまたはセッション検証を必須とし、未認証ユーザーには 403/404 を返します。
    3.  **No Draft Leak**: プレビューコンテンツが検索エンジンにインデックスされないよう、`noindex` メタタグまたは `X-Robots-Tag` ヘッダーを設定してください。
    4.  **Multi-Factor Preview**: プレビュー機能にパスワード保護が設定されている場合、URLトークン検証に加えて **パスワード入力（Knowledge Factor）** を必須とする多要素認証を実装してください。URL漏洩時の防壁として機能します。
    5.  **Cookie Fallback**: トークンが正しくてもセッションCookieが無効な場合は、必ずパスワード入力画面へリダイレクトし、認証をやり直させてください。

### 10.3. The Dual Mode Fetching Protocol (Public/Preview データ分離)
*   **Law**: プレビュー機能と公開ページを同じコードベースで扱う際、**非公開データが公開ページに露出するリスク**を物理的に防止してください。
*   **Action**:
    1.  **Explicit Method Separation**: データ取得関数は、公開用（公開条件のみ適用）とプレビュー用（トークン検証付き）を明示的に分離するか、単一関数内でフラグにより厳格に分岐させてください。
    2.  **Default Deny**: プレビューフラグのデフォルト値は必ず `false`（Public Mode）とし、明示的に許可された場合のみ権限を昇格させます。未指定時に非公開データが露出する設計は禁止です。

## 11. パブリッシング信頼性 (Publishing Reliability)

### 11.1. The Page Scheduling Protocol (ページスケジューリング)
*   **Law**: コンテンツの公開・非公開を日時指定でスケジューリングする機能を標準で実装してください。
*   **Action**:
    1.  **Scheduling Fields**: コンテンツテーブルに `published_at`（公開日時）と `unpublished_at`（非公開日時）を持たせます。
    2.  **Query Filter**: 公開クエリは `published_at <= NOW() AND (unpublished_at IS NULL OR unpublished_at > NOW())` でフィルタリングします。
    3.  **Cache Invalidation**: スケジュール時刻到達時に、関連するページキャッシュを自動的に無効化する仕組みを設計してください。
    4.  **Double Defense**: DBクエリによる公開制限（`WHERE published_at <= NOW()`）に加え、アプリケーションロジック層でも必ず時刻チェックを行い、予約時刻前のコンテンツにはアクセスを拒否してください。CDNキャッシュやISRのコンテキストにおいて、DBフィルタリングがバイパスされるリスクを物理的に防ぎます。

### 11.2. The Soft 404 Awareness Protocol (ソフト404対策)
*   **Law**: 削除・非公開されたコンテンツのURLに対し、200ステータスで空ページを返す「ソフト404」を防止してください。
*   **Action**:
    1.  **Proper HTTP Status**: 削除されたリソースには **410 Gone**、存在しないリソースには **404 Not Found** を正しく返却します。
    2.  **Redirect Strategy**: コンテンツ移動時は **301 Redirect** を適用し、SEO資産（リンクジュース）を引き継ぎます。
    3.  **No Empty Pages**: 200ステータスで「このページは存在しません」と表示する実装は、検索エンジンにインデックスされ、SEOを毀損するため禁止です。
    4.  **Content-Based Verification**: フレームワークによっては、`notFound()` 呼び出し時にHTTPステータスコードが正しく 404 にならない場合があります。テストや監視においては、ステータスコードだけに依存せず、**ページ内コンテンツの有無**（エラーメッセージ文言等）を正の判定基準として検証してください。

