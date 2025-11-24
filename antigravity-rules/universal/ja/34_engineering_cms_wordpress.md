# 34. CMSとコンテンツ管理 (CMS & Content Management - Headless WordPress)

## 1. ヘッドレス・アーキテクチャ (Headless Architecture)
*   **分離の原則 (Decoupling)**:
    *   **ルール**: WordPressは「コンテンツ管理（入稿）」のためだけに使用し、フロントエンド（表示）には一切使用しません。
    *   **API利用**: コンテンツは **WPGraphQL** または **REST API** を通じて取得し、Next.js等のモダンなフロントエンドでレンダリングします。
*   **セキュリティ (Security)**:
    *   管理画面（/wp-admin）はIP制限やBasic認証で保護し、一般公開されるフロントエンドとは完全に切り離します。これにより、WordPress特有の脆弱性リスクを最小化します。

## 2. パフォーマンスと静的化 (Performance & Static Generation)
*   **SSG/ISR**:
    *   記事コンテンツはビルド時（SSG）またはリクエスト時（ISR）に静的なHTMLとして生成し、CDNから配信します。WordPressサーバーへの直接アクセスを極限まで減らします。
*   **画像最適化 (Image Optimization)**:
    *   WordPressにアップロードされた画像は、フロントエンド側で `next/image` 等を使用して最適化・キャッシュします。

## 3. 運用と保守 (Operations & Maintenance)
*   **プラグイン管理 (Plugin Management)**:
    *   プラグインは必要最小限に留めます。機能追加よりもパフォーマンスとセキュリティを優先します。
    *   **自動更新**: セキュリティパッチは自動的に適用されるように設定します。
    *   `wp-config.php` ではなく `.env` で環境変数を管理し、Git管理しやすいディレクトリ構造を強制する。
*   **Composer**:
    *   プラグインとコアの管理は全て **Composer** で行う。管理画面からの直接インストールは禁止する（本番環境でのファイル変更禁止）。

## 3. API & Data Fetching
*   **WPGraphQL**:
    *   REST APIではなく、**WPGraphQL** を標準とする。必要なデータのみを取得し、オーバーフェッチを防ぐ。
*   **Advanced Custom Fields (ACF)**:
    *   構造化データにはACFを使用し、GraphQLスキーマに露出させる。

## 4. Security & Performance
*   **Static Generation (SSG/ISR)**:
    *   WordPressへのリクエストはビルド時（SSG）または再検証時（ISR）のみ発生させ、ユーザーアクセス時には静的HTMLを配信する。これによりWordPress特有のセキュリティリスク（SQLインジェクション等）を無効化する。
