# 35. Engineering: API Integration Strategy

## 1. API-First Design
*   **Design Before Code**:
    *   実装を始める前に、必ずAPI仕様を定義する。
    *   **OpenAPI (Swagger)**: REST APIの場合はOpenAPI 3.x仕様書を先に記述し、そこからコード（型定義、クライアント）を自動生成する。
    *   **Schema-Driven**: GraphQLの場合はSchema定義を正とし、フロントエンドとバックエンドの型安全性を担保する。

## 2. Protocols & Standards
*   **REST**: リソース指向のCRUD操作に適する。ステートレス性を厳守する。
*   **GraphQL**: 複雑なデータ構造や、フロントエンドが柔軟なデータを必要とする場合に採用する。
*   **gRPC**: マイクロサービス間通信や、低遅延が求められるリアルタイム通信に採用する（Protocol Buffers）。

## 3. Best Practices
*   **Idempotency (冪等性)**:
    *   決済や重要な更新処理には、必ず `Idempotency-Key` ヘッダーを実装し、ネットワークエラーによる二重実行を防ぐ。
*   **Versioning**:
    *   破壊的変更を行う場合は、必ずURL（`/v1/`, `/v2/`）またはヘッダーでバージョニングを行う。
*   **Rate Limiting**:
    *   DDoS攻撃や過負荷を防ぐため、全ての公開APIにレートリミットを設定する。

## 4. Documentation
*   **Live Documentation**:
    *   APIドキュメントはコードから自動生成され、常に最新の状態（Live）でなければならない（Swagger UI, GraphiQL）。手動更新のドキュメントは禁止する。
