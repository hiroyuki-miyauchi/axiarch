# 35. API統合と設計 (API Integration & Design)

## 1. API設計原則 (API Design Principles)
*   **APIファースト設計 (API-First Design)**:
    *   **設計先行**: 実装を始める前に、必ずAPI仕様を定義します。
    *   **OpenAPI (Swagger)**: REST APIの場合はOpenAPI 3.x仕様書を先に記述し、そこからコード（型定義、クライアント）を自動生成します。これにより、開発の効率化と一貫性を保ちます。
    *   **Schema-Driven**: GraphQLの場合はSchema定義を正とし、フロントエンドとバックエンドの型安全性を担保します。
*   **RESTful & GraphQL**:
    *   **REST**: リソース指向のURL設計（例: `GET /users/{id}/orders`）を遵守し、適切なHTTPメソッド（GET, POST, PUT, DELETE）を使用します。ステートレス性を厳守し、各リクエストが独立して処理されるようにします。
    *   **GraphQL**: 複雑なデータ取得や、クライアントが必要なデータを細かく指定したい場合はGraphQLを採用し、オーバーフェッチ（無駄なデータ取得）を防ぎます。
*   **バージョニング (Versioning)**:
    *   破壊的変更（Breaking Changes）を避けるため、URLまたはヘッダーでバージョン管理を行います（例: `/v1/users`）。これにより、既存のクライアントへの影響を最小限に抑えます。

## 2. エラーハンドリング (Error Handling)
*   **統一された形式 (Unified Format)**:
    *   エラーレスポンスは常に統一されたJSON形式（例: `{ "code": "INVALID_INPUT", "message": "入力値が不正です。" }`）で返却します。これにより、クライアント側でのエラー処理を簡素化します。
    *   HTTPステータスコード（200 OK, 400 Bad Request, 401 Unauthorized, 403 Forbidden, 404 Not Found, 500 Internal Server Error）を正しく使い分けます。全てを200 OKで返してはいけません。
*   **リトライ戦略 (Retry Strategy)**:
    *   一時的なネットワークエラー（503 Service Unavailable, タイムアウト）に対しては、**指数バックオフ (Exponential Backoff)** を用いて自動的にリトライするロジックをクライアント側に実装します。これにより、システムの可用性を向上させます。

## 3. セキュリティと認証 (Security & Authentication)
*   **認証ヘッダー (Authorization Header)**:
    *   APIトークンはURLパラメータではなく、必ず `Authorization: Bearer <token>` ヘッダーで送信します。これにより、セキュリティリスクを低減します。
*   **レート制限 (Rate Limiting)**:
    *   DDoS攻撃やスクレイピングを防ぐため、IPアドレスやユーザーごとのレート制限（Throttling）を実装します。これにより、APIの安定稼働を確保します。

## 4. ベストプラクティス (Best Practices)
*   **冪等性 (Idempotency)**:
    *   決済や重要な更新処理には、必ず `Idempotency-Key` ヘッダーを実装し、ネットワークエラーによる二重実行を防ぎます。同じリクエストが複数回送信されても、結果が一度実行された場合と同じになるようにします。

## 5. ドキュメンテーション (Documentation)
*   **ライブドキュメント (Live Documentation)**:
    *   APIドキュメントはコードから自動生成され、常に最新の状態（Live）でなければなりません（Swagger UI, GraphiQL）。手動更新のドキュメントは禁止します。これにより、開発者間の認識齟齬を防ぎ、開発効率を向上させます。
