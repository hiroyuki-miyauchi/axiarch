# 34. Engineering: CMS Strategy (Headless WordPress)

## 1. Modern WordPress Architecture
*   **Headless is King**:
    *   従来のモノリシックなWordPress（PHPによるフロントエンド描画）は原則禁止とする。
    *   **Headless Architecture**を採用し、WordPressは「コンテンツ管理API」としてのみ使用する。
    *   フロントエンドは **Next.js** 等のモダンフレームワークで構築し、圧倒的なパフォーマンスとセキュリティを実現する。

## 2. Bedrock & Roots Stack
*   **Bedrock**:
    *   WordPressのインストールには必ず **Bedrock** (Roots.io) を使用する。
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
