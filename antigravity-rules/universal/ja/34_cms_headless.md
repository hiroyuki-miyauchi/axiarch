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

## 8. Audit & Revision History
*   **Historian Protocol**:
    *   **Revisioning**: コンテンツ保存ごとに `revisions` テーブルへ差分を保存し、「いつ誰が変更したか」を追跡可能にします。
    *   **Rollback**: 誤操作時に過去のリビジョンへワンクリックで復元できる機能を標準実装します。

## 9. Fixed Page Strategy (Static & Headless)
*   **The "Fixed Page" Engine**:
    *   **Dynamic & Static**: 利用規約やLPなどの「固定ページ」もハードコードせず、ヘッドレスCMS (`fixed_pages`) と動的ルーティング (`/[slug]`) で管理します。
    *   **ISR Strategy**: 更新頻度が低いため、`revalidate: 3600` (1時間) 以上のISRを設定し、DB負荷を最小化します。
    *   **PII Protection**: エディタ入力時に個人情報（電話番号等）が含まれる場合、リアルタイムで警告を表示するガードレールを設置します。
    *   **API-First Delivery**: Webだけでなく、将来のアプリ配信（WebView回避）を見据え、必ずJSONデータを返すAPIエンドポイントをセットで実装します。
