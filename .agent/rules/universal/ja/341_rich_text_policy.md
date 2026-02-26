# 34. コンテンツ管理システム (Content Management System - Headless) CMS

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
