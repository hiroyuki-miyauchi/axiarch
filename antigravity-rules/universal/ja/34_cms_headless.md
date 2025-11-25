# 34. コンテンツ管理システム (Content Management System - Headless) CMS)

## 1. ヘッドレス・アーキテクチャ (Headless Architecture)
*   **Content as Data**:
    *   **原則**: コンテンツは「表示」から切り離された「純粋なデータ」として管理します。
    *   **API First**: コンテンツの取得は全てAPI経由で行い、Web、モバイルアプリ、スマートウォッチなど、あらゆるデバイス（オムニチャネル）への配信を可能にします。
*   **選定基準**:
    *   **推奨**: Contentful, MicroCMS, Sanity などのSaaS型ヘッドレスCMSを第一選択とします。
    *   **WordPress**: WordPressを使用する場合は、必ず **Headless Mode (WPGraphQL)** で使用し、フロントエンド（Next.js）と完全に分離します。PHPによるテーマ開発は禁止です。

## 2. パフォーマンスと配信 (Performance & Delivery)
*   **SSG / ISR**:
    *   コンテンツはビルド時（SSG）またはリクエスト時（ISR）に静的なHTMLとして生成し、CDNから配信します。CMSサーバーへの直接アクセスを極限まで減らし、爆速の表示速度を実現します。
*   **画像最適化**:
    *   CMSから配信される画像は、フロントエンド側で `next/image` 等を使用して最適化・キャッシュします。CMSの画像URLをそのまま`img`タグで使用することは避けます。

## 3. 運用とセキュリティ (Operations & Security)
*   **プレビュー機能**:
    *   編集者が公開前にコンテンツを確認できるよう、Next.jsの **Preview Mode** を実装し、ドラフト状態のコンテンツをセキュアに表示します。
*   **セキュリティ**:
    *   CMSの管理画面はIP制限やSSOで保護し、一般公開されるフロントエンドとは完全に切り離します。これにより、CMS特有の脆弱性リスクを最小化します。
