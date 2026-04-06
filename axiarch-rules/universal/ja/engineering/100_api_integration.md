# 35. API統合とマイクロサービス (API Integration & Microservices)

> [!CAUTION]
> **このファイルは Universal Rule（不変ルール）です。「憲法改正」の明示的指示がない限り編集禁止。**
> 改定日: 2026-03-24

> [!IMPORTANT]
> **Supreme Directive（最高指令）**
> 「APIは組織の最も価値ある資産であり、販売可能な商品として設計せよ。」
> API設計において、**セキュリティ > 信頼性 > 互換性 > パフォーマンス > DX** の優先順位を厳守せよ。
> この文書は API統合・マイクロサービスに関するすべての設計判断の最上位基準である。
> **35パート・70セクション構成。**

---

## 目次

- Part I: Supreme Directive & API哲学
- Part II: API設計原則（API-First・Contract-First）
- Part III: プロトコル選択戦略（REST/GraphQL/gRPC/AsyncAPI）
- Part IV: RESTful API設計基準
- Part V: URLとリソース設計
- Part VI: バージョニング戦略
- Part VII: リクエスト・レスポンス設計
- Part VIII: RFC 7807+セマンティックエラー
- Part IX: GraphQL設計基準
- Part X: GraphQL Federation
- Part XI: GraphQLセキュリティ・パフォーマンス
- Part XII: gRPC設計基準
- Part XIII: gRPC高度パターン
- Part XIV: Protocol Buffers管理
- Part XV: イベント駆動アーキテクチャ
- Part XVI: AsyncAPI・メッセージング設計
- Part XVII: Webhook設計・運用
- Part XVIII: API Gatewayアーキテクチャ
- Part XIX: Service Mesh設計
- Part XX: BFF（Backend for Frontend）パターン
- Part XXI: レジリエンスパターン
- Part XXII: 冪等性設計
- Part XXIII: レート制限・スロットリング
- Part XXIV: API SLO・信頼性契約
- Part XXV: Graceful Degradation・障害隔離
- Part XXVI: APIセキュリティ基盤
- Part XXVII: 認証・認可アーキテクチャ
- Part XXVIII: APIキー・トークン管理
- Part XXIX: 入力バリデーション・サニタイズ
- Part XXX: CORSガバナンス
- Part XXXI: DTO設計・データマッピング
- Part XXXII: データシリアライゼーション
- Part XXXIII: Server Action設計
- Part XXXIV: キャッシュ戦略
- Part XXXV: ペイロード最適化
- Part XXXVI: スケーラビリティ設計
- Part XXXVII: API可観測性
- Part XXXVIII: API監査ログ
- Part XXXIX: APIヘルスチェック・ステータス
- Part XL: API公開ドキュメント基準
- Part XLI: 開発者エクスペリエンス（DX）
- Part XLII: API Contract Testing
- Part XLIII: API Product Mindset
- Part XLIV: API Gateway使用量計測
- Part XLV: API FinOps
- Part XLVI: マイクロサービス設計原則
- Part XLVII: サービス間通信パターン
- Part XLVIII: 分散データ管理
- Part XLIX: 高度書き込みプロトコル
- Part L: AI統合API設計
- Part LI: APIライフサイクル管理
- Part LII: マイクロサービス運用
- Part LIII: 規制コンプライアンス
- Part LIV: 成熟度モデル（5段階）
- Part LV: アンチパターン集（25選）
- Part LVI: Agentic API設計（MCP/A2A/ACP）
- Part LVII: HTTP/3 & QUIC移行
- Part LVIII: WebTransport設計
- Part LIX: API Supply Chain Security
- Part LX: Kubernetes Gateway API
- Part LXI: AI駆動APIテスト
- Part LXII: API Governance深化
- Part LXIII: GraphQL 2025+拡張
- Part LXIV: gRPC 2025+拡張
- Part LXV: API Evolution Strategy
- Part LXVI: Multi-Cloud API管理
- Part LXVII: Edge-Native API
- Part LXVIII: API Marketplace & Ecosystem
- Part LXIX: Green API / サステナビリティ
- Part LXX: 将来展望
- Appendix A: 逆引き索引
- Appendix B: クロスリファレンス

---

## Part I: Supreme Directive & API哲学

### 1.1. API実装の最高原則

- **Rule 35.1**: 全APIは「販売可能な商品（Salable Asset）」として設計する。内部専用であっても手抜きは「技術的負債の種」である
- **Rule 35.2**: APIの破壊的変更は「商品のリコール」と等価。互換性を最優先に設計する
- **Rule 35.3**: API設計はコードより先にコントラクト（仕様書）を定義する（Contract-First）

### 1.2. 優先順位階層

| 優先度 | 領域 | 説明 |
|:---|:---|:---|
| **P0** | セキュリティ | 認証認可、入力検証、PII保護、Zero Trust |
| **P1** | 信頼性 | 冪等性、サーキットブレーカー、Graceful Degradation |
| **P2** | 互換性 | バージョニング、非推奨化、後方互換 |
| **P3** | パフォーマンス | レイテンシ、スループット、キャッシュ最適化 |
| **P4** | DX | ドキュメント、SDK、エラーメッセージの明瞭さ |

### 1.3. Omnichannel First原則

- **Rule 35.4**: Webフロントエンドを「特権的なクライアント」として扱うことを禁止する。iOS/Androidアプリと対等に扱い、Webで可能な全操作をAPI経由で外部利用可能にする
- Tiered Gateway: 「Tier 1 (Public/Read-Only)」と「Tier 2 (Enterprise/Auth/Paid)」を初期から分離し、将来的なAPI収益化（Stripe Metering）に備える

---

## Part II: API設計原則

### 2.1. API-First Design

- **Rule 35.5**: 実装を始める前に、必ずAPI仕様（コントラクト）を定義する
- フロントエンドとバックエンドの並行開発を可能にする
- 仕様からモック/スタブを自動生成し、統合テストを先行実施する

### 2.2. Contract-First Development

- **OpenAPI 3.1**: REST APIは OpenAPI 3.1 仕様書を正として定義し、コード・型定義・クライアントSDKを自動生成する
- **Schema-Driven (GraphQL)**: GraphQLはスキーマ定義を正とし、フロントエンド・バックエンド間の型安全性を担保する
- **Protobuf (gRPC)**: gRPCは `.proto` ファイルを正とし、多言語コード生成を自動化する

### 2.3. コード生成の義務化

- **Rule 35.6**: 手書きの型定義は禁止。必ず OpenAPI/GraphQL/Protobuf スキーマからクライアントコードとサーバーの型定義を自動生成する

```typescript
// ✅ 正: OpenAPI仕様から自動生成
import type { paths } from '@/generated/api-types';
type StoreResponse = paths['/api/v1/stores/{id}']['get']['responses']['200']['content']['application/json'];

// ❌ 禁止: 手書き型定義
interface StoreResponse {
  id: string;
  name: string;
  // ... 手動メンテナンスは破綻する
}
```

### 2.4. API Governance

- **API Review Board**: 新規API・Breaking Changeは設計レビューを経てからのみ実装を許可する
- **API Style Guide**: 組織内でAPI設計ガイドラインを統一し、一貫性を維持する
- **Linting**: OpenAPI仕様のLint（Spectral等）をCIに組み込み、設計ルール違反を自動検出する

---

## Part III: プロトコル選択戦略

### 3.1. プロトコル選択マトリクス

| プロトコル | ユースケース | 利点 | 制約 |
|:---|:---|:---|:---|
| **REST** | パブリックAPI、CRUD、3rdパーティ統合 | 汎用性、キャッシュ、ツール充実 | Over-fetching、複数リソース取得が冗長 |
| **GraphQL** | 複雑なデータ取得、BFF、モバイル最適化 | 柔軟なクエリ、型安全、Under-fetching解消 | 学習コスト、キャッシュ複雑、N+1問題 |
| **gRPC** | マイクロサービス内部通信、リアルタイム | 高性能、型安全、ストリーミング | ブラウザ非対応（gRPC-Web要）、デバッグ困難 |
| **AsyncAPI** | イベント駆動、非同期メッセージング | 疎結合、スケーラビリティ | 設計複雑度、イベント順序保証の課題 |
| **WebSocket** | リアルタイム双方向通信、チャット、通知 | 低レイテンシ、常時接続 | 接続管理、スケーリング複雑 |
| **SSE** | サーバーからのリアルタイム配信、ストリーミング | シンプル、HTTP互換 | 単方向のみ |

### 3.2. プロトコル選択原則

- **Rule 35.7**: 外部公開APIはRESTを標準とする（最大の汎用性とツールエコシステム）
- **Rule 35.8**: マイクロサービス間の内部通信にはgRPCを推奨する（パフォーマンス・型安全）
- **Rule 35.9**: フロントエンド向けBFFにはGraphQLを推奨する（Over-fetching解消・帯域幅節約）
- **Rule 35.10**: イベント駆動パターンにはAsyncAPI仕様でコントラクトを定義する

### 3.3. マルチプロトコルゲートウェイ

- API Gatewayを「プロトコルオーケストレーター」として配置し、外部REST→内部gRPC等のプロトコル変換を透過的に実行する

---

## Part IV: RESTful API設計基準

### 4.1. リソース指向設計

- **Rule 35.11**: URLにはアクション動詞ではなくリソース名詞（複数形）を使用する

```
✅ GET    /api/v1/stores
✅ POST   /api/v1/stores
✅ GET    /api/v1/stores/{storeId}
✅ PATCH  /api/v1/stores/{storeId}
✅ DELETE /api/v1/stores/{storeId}

❌ GET    /api/v1/getStores
❌ POST   /api/v1/createStore
❌ POST   /api/v1/deleteStore/{id}
```

### 4.2. HTTPメソッドのセマンティクス

| メソッド | 用途 | 冪等性 | 安全性 |
|:---|:---|:---|:---|
| **GET** | リソース取得 | ✅ 冪等 | ✅ 安全 |
| **POST** | リソース作成、非冪等操作 | ❌ 非冪等 | ❌ 非安全 |
| **PUT** | リソース全体置換 | ✅ 冪等 | ❌ 非安全 |
| **PATCH** | リソース部分更新 | ❌ 非冪等 | ❌ 非安全 |
| **DELETE** | リソース削除 | ✅ 冪等 | ❌ 非安全 |

### 4.3. HTTPステータスコード使用基準

| コード | 用途 | 注意事項 |
|:---|:---|:---|
| **200** | 成功（データ返却あり） | GET/PATCH/PUT の成功 |
| **201** | リソース作成成功 | POST成功時。`Location` ヘッダーで新リソースURLを返す |
| **204** | 成功（データ返却なし） | DELETE成功時 |
| **400** | リクエスト不正 | バリデーションエラー |
| **401** | 認証エラー | トークン未提供または無効 |
| **403** | 認可エラー | 権限不足 |
| **404** | リソース未発見 | |
| **409** | 競合 | 楽観的ロック失敗、重複作成 |
| **422** | 処理不能エンティティ | ビジネスロジックバリデーション |
| **429** | レート制限超過 | `Retry-After` ヘッダー必須 |
| **500** | 内部サーバーエラー | 詳細を外部に漏洩しない |
| **503** | サービス利用不可 | メンテナンス時 |

- **Rule 35.12**: `2xx` 以外のレスポンスでは必ず RFC 7807 準拠のエラーボディを返す

---

## Part V: URLとリソース設計

### 5.1. URL命名規約

- **kebab-case**: URLパスセグメントは `kebab-case` を使用する（例: `/store-categories`）
- **複数形**: コレクションリソースは複数形（例: `/stores`, `/users`）
- **最大深度**: ネストは2レベル以内（例: `/stores/{id}/reviews` は可、`/stores/{id}/reviews/{rid}/comments` は不可→ `/comments?reviewId={rid}` へ）

### 5.2. フィルタリング・ソート・ページネーション

- **フィルタリング**: クエリパラメータ使用（例: `?status=active&region=tokyo`）
- **ソート**: `?sort=created_at:desc,name:asc`
- **ページネーション**:

| 方式 | 推奨度 | ユースケース |
|:---|:---|:---|
| **Cursor-Based** | ✅ 推奨 | 大規模データセット、リアルタイム更新 |
| **Offset-Based** | ⚠ 限定的 | 小規模固定データ、管理画面 |
| **Keyset-Based** | ✅ 推奨 | 高パフォーマンス要求 |

- **Rule 35.13**: Cursor-Based Pagination を標準とする。Offset-Based は大規模データでパフォーマンス劣化するため管理画面に限定する

```json
{
  "data": [...],
  "pagination": {
    "next_cursor": "eyJpZCI6MTAwfQ==",
    "has_more": true,
    "total_count": 1523
  }
}
```

### 5.3. Field Selection（Sparse Fieldsets）

- `?fields=id,name,address` パラメータで返却フィールドを制限可能にする
- 帯域幅の節約とモバイルアプリのパフォーマンス最適化に有効

---

## Part VI: バージョニング戦略

### 6.1. URL-Based Versioning（推奨）

- **Rule 35.14**: `/api/v{major}/` 形式を標準とする（例: `/api/v1/stores`）
- Header-based や Query-based より発見性が高く、ドキュメント化・テストが容易

### 6.2. Breaking Change（破壊的変更）の定義

| 変更種別 | Breaking | 例 |
|:---|:---|:---|
| レスポンスフィールドの**削除** | ✅ Yes | `address` フィールドの除去 |
| レスポンスフィールドの**型変更** | ✅ Yes | `price: string` → `price: number` |
| 必須パラメータの**追加** | ✅ Yes | 新パラメータ `region` を必須化 |
| レスポンスフィールドの**追加** | ❌ No | 新フィールド `rating_count` の追加 |
| オプショナルパラメータの**追加** | ❌ No | `?sort=newest` の追加 |
| エンドポイントの**追加** | ❌ No | `/api/v1/reviews` の新設 |
| HTTPステータスコードの**変更** | ✅ Yes | 200 → 201 への変更 |
| エラーレスポンス構造の**変更** | ✅ Yes | エラーJSONのスキーマ変更 |

### 6.3. Deprecation Protocol（非推奨化手順）

1. **並行稼働**: 旧バージョンは新バージョンリリースから**最低6ヶ月間**稼働
2. **Sunset Header**: 非推奨APIのレスポンスに `Sunset: <date>` ヘッダーを付与（RFC 8594準拠）
3. **Deprecation Header**: `Deprecation: true` ヘッダーを付与（RFC 8594準拠）
4. **通知義務**: APIキー保持者へ3ヶ月前、1ヶ月前、1週間前にメール通知
5. **ドキュメント**: 仕様書に非推奨の旨と移行ガイドを掲載
6. **Usage Monitoring**: 旧バージョンの利用状況を監視し、利用者がゼロになるまで廃止しない

### 6.4. Additive Change（追加的変更）戦略

- **Rule 35.15**: バージョンインクリメントを避けるため、可能な限り追加的変更（Additive Change）で進化する
- 新フィールドの追加、新エンドポイントの追加、オプショナルパラメータの追加はBreaking Changeではない
- クライアントは未知のフィールドを無視する「寛容なパーサー（Tolerant Reader）」パターンを実装する

---

## Part VII: リクエスト・レスポンス設計

### 7.1. DTO義務（Data Transport Obligation）

- **Rule 35.16**: データベースのRowオブジェクト（Raw Row）をそのまま返すことを「重罪」とする。必ず `UserDTO` 等を経由し、意図的にマッピングされたフィールドのみを出力する
- **Admin Data Leak Defense**: 管理者画面用APIにおいても `SELECT *` を禁止し、専用の `AdminDTO` を定義する。将来的な `internal_memo` や原価情報等の機密カラム追加時の自動漏洩を物理的に防ぐ
- **DTO Assertion Testing**: APIテストケースには、除外されるべきフィールド（PII等）が存在しないことを確認する `assert(field is undefined)` テストを含めなければならない

### 7.2. レスポンスエンベロープ

```json
{
  "data": { ... },
  "meta": {
    "request_id": "req_abc123",
    "timestamp": "2026-03-22T09:00:00Z",
    "tier": "enterprise",
    "usage": "metered",
    "revalidation_ttl": 300
  },
  "pagination": { ... }
}
```

- **Rule 35.17**: 全成功レスポンスに `meta` フィールドを含め、`request_id`・`timestamp` を必須とする
- **AI Context Meta**: `tier`, `usage`, `revalidation` 等をメタ情報として含め、AIエージェントの推論精度向上とFinOps最適化を支援する

### 7.3. PII Masking

- パスワードハッシュ、内部フラグ（`is_admin`）、個人情報の流出を構造的に防止する
- レスポンスのシリアライゼーション段階でPIIフィールドを自動除外する仕組みを実装する

---

## Part VIII: RFC 7807+セマンティックエラー

### 8.1. RFC 7807 Problem Details

- **Rule 35.18**: エラーレスポンスは必ず RFC 7807（Problem Details for HTTP APIs）に準拠する

```json
{
  "type": "https://api.example.com/errors/validation-failed",
  "title": "Validation Failed",
  "status": 422,
  "detail": "The 'email' field must be a valid email address.",
  "instance": "/api/v1/users",
  "errors": [
    {
      "field": "email",
      "code": "INVALID_FORMAT",
      "message": "Must be a valid email address"
    }
  ],
  "trace_id": "trace_abc123"
}
```

### 8.2. バックエンドエラー伝播禁止

- **Rule 35.19**: サーバーサイドの生の技術的エラーメッセージ（`"Row not found"`, `"upstream connect error"`）をそのままUIに表示することを禁止する
- クライアント側でエラータイプに基づいて、ユーザーが理解できるローカライズされたメッセージへ翻訳する

### 8.3. Gateway Instrumentation Protocol

- **Rule 35.20**: Gateway/Service層の `catch` ブロックでエラーオブジェクトを文字列テンプレートに直接埋め込むことを禁止する

```typescript
// ❌ 禁止: [object Object] を出力し根本原因が不可視化
catch (error) {
  logger.error(`Gateway error: ${error}`);
}

// ✅ 正: 構造化ログで明示的に分解
catch (error) {
  logger.error('Gateway operation failed', {
    message: error?.message,
    code: error?.code,
    details: error?.details,
    hint: error?.hint,
  });
}
```

### 8.4. HTTPステータスマッピング

- データベースエラーコードをHTTPステータスコードに適切にマッピングする

| DBエラーコード | 意味 | HTTPステータス |
|:---|:---|:---|
| `23505` | Unique Violation | `409 Conflict` |
| `23503` | Foreign Key Violation | `422 Unprocessable Entity` |
| `42501` | Insufficient Privileges | `403 Forbidden` |
| `PGRST301` | Row-Level Security Violation | `403 Forbidden` |

---

## Part IX: GraphQL設計基準

### 9.1. スキーマ設計原則

- **Rule 35.21**: GraphQLスキーマはドメインモデルを忠実に反映し、「クライアントが何を必要とするか」で設計する
- 全操作に名前を付ける（匿名クエリ禁止）
- 動的入力には変数を使用する（クエリ内のリテラル値埋め込み禁止）

### 9.2. 命名規約

| 要素 | 規約 | 例 |
|:---|:---|:---|
| Type | PascalCase | `Store`, `UserProfile` |
| Field | camelCase | `storeName`, `createdAt` |
| Query | camelCase | `store`, `stores`, `storeById` |
| Mutation | camelCase（動詞+名詞） | `createStore`, `updateUser` |
| Enum | SCREAMING_SNAKE_CASE | `STORE_STATUS_ACTIVE` |
| Input | PascalCase + `Input` サフィックス | `CreateStoreInput` |

### 9.3. Pagination（Relay Specification）

- **Rule 35.22**: GraphQLのページネーションはRelay Cursor Connections仕様に準拠する

```graphql
type Query {
  stores(first: Int, after: String, last: Int, before: String): StoreConnection!
}

type StoreConnection {
  edges: [StoreEdge!]!
  pageInfo: PageInfo!
  totalCount: Int!
}

type StoreEdge {
  node: Store!
  cursor: String!
}
```

---

## Part X: GraphQL Federation

### 10.1. GraphQL Federationアーキテクチャ

- **Supergraph**: 複数のSubgraphを統合した単一のGraphQLエンドポイント
- **Subgraph**: 各マイクロサービスが管理する独立したGraphQLスキーマ
- **Router**: クエリを適切なSubgraphにルーティングするゲートウェイ（Apollo Router等）

### 10.2. Subgraph設計原則

- **Rule 35.23**: 各Subgraphはドメイン境界（Bounded Context）に一致させる
- Subgraph間の循環依存を禁止する
- `@key` ディレクティブでエンティティの所有権を明示する
- `@shareable` でフィールドの共有を宣言する

### 10.3. Composition検証

- **CI/CDパイプライン**: Subgraph変更時にSupergraph Composition検証を自動実行する
- **Breaking Change検出**: スキーマ変更が既存クエリを破壊しないかCI上で自動チェックする

---

## Part XI: GraphQLセキュリティ・パフォーマンス

### 11.1. セキュリティ対策

| 対策 | 説明 | 設定基準 |
|:---|:---|:---|
| **Query Depth Limiting** | ネストの深さを制限 | 最大深度: 10 |
| **Query Complexity** | クエリの計算コストを制限 | 最大コスト: 1000 |
| **Persisted Queries** | 事前登録クエリのみ許可 | 本番環境で必須 |
| **Introspection無効化** | 本番でのスキーマ公開を阻止 | 本番環境で必須 |
| **Rate Limiting** | クエリ単位のレート制限 | エンドポイント + クエリ複雑度 |

### 11.2. N+1問題の解決

- **DataLoader パターン**: バッチ処理とキャッシュでN+1クエリを排除する

```typescript
// ✅ DataLoaderによるバッチ化
const storeLoader = new DataLoader<string, Store>(async (ids) => {
  const stores = await db.stores.findMany({ where: { id: { in: ids } } });
  return ids.map(id => stores.find(s => s.id === id)!);
});
```

### 11.3. パフォーマンス最適化

- **自動Persisted Queries (APQ)**: クエリハッシュのみを送信し、ペイロードを最小化する
- **@defer / @stream**: 大きなレスポンスを段階的にストリーミング配信する
- **キャッシュ**: グローバルデータとユーザー固有データを分離し、キャッシュ効率を最大化する

---

## Part XII: gRPC設計基準

### 12.1. サービス定義

- **Rule 35.24**: gRPCサービスはドメイン指向で設計し、ビジネス境界に一致させる

```protobuf
syntax = "proto3";

package store.v1;

service StoreService {
  rpc GetStore(GetStoreRequest) returns (Store);
  rpc ListStores(ListStoresRequest) returns (ListStoresResponse);
  rpc CreateStore(CreateStoreRequest) returns (Store);
  rpc UpdateStore(UpdateStoreRequest) returns (Store);
  rpc DeleteStore(DeleteStoreRequest) returns (google.protobuf.Empty);
  rpc WatchStoreUpdates(WatchStoreUpdatesRequest) returns (stream StoreUpdate);
}
```

### 12.2. ストリーミングパターン

| パターン | 説明 | ユースケース |
|:---|:---|:---|
| **Unary** | 単一リクエスト→単一レスポンス | 標準CRUD |
| **Server Streaming** | 単一リクエスト→複数レスポンス | リアルタイム更新、大量データ |
| **Client Streaming** | 複数リクエスト→単一レスポンス | ファイルアップロード |
| **Bidirectional Streaming** | 複数リクエスト↔複数レスポンス | チャット、コラボレーション |

### 12.3. エラーハンドリング

- gRPCステータスコードを適切に使用し、`google.rpc.Status` でリッチなエラー情報を返す
- `UNAVAILABLE` はリトライ可能、`INVALID_ARGUMENT` はリトライ不可のように分類する

---

## Part XIII: gRPC高度パターン

### 13.1. Channel管理

- **Rule 35.25**: gRPC Channelの再利用を義務付ける。Channel生成は複数のネットワークラウンドトリップを伴う高コスト操作であるため、リクエストごとの生成を禁止する

### 13.2. Interceptor（ミドルウェア）

- 認証、ロギング、メトリクス収集、リトライ等の横断的関心事はInterceptorで実装する
- 各Interceptorは単一責務とし、チェーンで合成する

### 13.3. デッドライン伝播

- **Rule 35.26**: 全gRPCコールにデッドライン（タイムアウト）を設定する。デッドラインなしの呼び出しは暴走リスクがあるため禁止する
- サービスチェーンではデッドラインを伝播させ、残り時間の範囲内で処理を完了する

### 13.4. ヘルスチェック

- gRPC Health Checking Protocol（`grpc.health.v1.Health`）を全サービスに実装する
- Kubernetes Readiness/Liveness Probeと統合する

---

## Part XIV: Protocol Buffers管理

### 14.1. スキーマレジストリ

- **Rule 35.27**: `.proto` ファイルは専用リポジトリ（Schema Registry）で一元管理する
- **Buf CLI**: Lint、Breaking Change検出、コード生成を `buf` CLI で統一的に実行する

### 14.2. Breaking Change検出

- `buf breaking` コマンドをCIパイプラインに組み込み、Breaking Change（フィールド削除、型変更、フィールド番号再利用等）を自動検出・ブロックする

### 14.3. フィールド番号管理

- 一度使用したフィールド番号は `reserved` で予約し、再利用を禁止する
- 削除したフィールドの番号と名前を `reserved` に追加する

```protobuf
message Store {
  reserved 3, 7;
  reserved "old_field_name";
  
  string id = 1;
  string name = 2;
  // field 3 was 'legacy_code', removed in v2
}
```

---

## Part XV: イベント駆動アーキテクチャ

### 15.1. イベント駆動パターン

| パターン | 説明 | ユースケース |
|:---|:---|:---|
| **Event Notification** | 軽量イベント（ID+タイプのみ） | 疎結合な通知 |
| **Event-Carried State Transfer** | イベントにデータ全体を含む | キャッシュ同期、読み取り最適化 |
| **Event Sourcing** | イベントを唯一の真実のソースとする | 監査ログ、Undo/Redo |
| **CQRS** | コマンドとクエリの責務分離 | 高スケーラビリティ要求 |

### 15.2. イベント設計基準

- **Rule 35.28**: イベントは不変（Immutable）とし、過去のイベントの修正は禁止する
- イベント名は過去形を使用する（例: `StoreCreated`, `OrderCompleted`）

```json
{
  "event_id": "evt_abc123",
  "event_type": "store.created",
  "event_version": "1.0",
  "timestamp": "2026-03-22T09:00:00Z",
  "source": "store-service",
  "correlation_id": "corr_xyz789",
  "data": {
    "store_id": "store_001",
    "name": "Example Store"
  },
  "metadata": {
    "actor_id": "user_456",
    "trace_id": "trace_def456"
  }
}
```

### 15.3. Saga Pattern

- 分散トランザクションの整合性を保証するためにSagaパターンを使用する

| 方式 | 説明 | 推奨度 |
|:---|:---|:---|
| **Choreography** | 各サービスがイベントを発行・購読 | シンプルなフロー向け |
| **Orchestration** | 中央のオーケストレーターがフロー制御 | 複雑なフロー向け（推奨） |

- 各ステップに補償トランザクション（Compensating Transaction）を定義する
- Sagaの状態を永続化し、障害時のリカバリを保証する

### 15.4. Outbox Pattern

- **Rule 35.29**: データベース更新とイベント発行のアトミック性を保証するため、Outboxパターンを義務付ける
- DBトランザクション内で `outbox` テーブルにイベントを書き込み、別プロセスがポーリングまたはCDC（Change Data Capture）でイベントを発行する

---

## Part XVI: AsyncAPI・メッセージング設計

### 16.1. AsyncAPI仕様

- **Rule 35.30**: 非同期メッセージングのコントラクトは AsyncAPI 3.0 仕様で定義する
- チャネル、メッセージスキーマ、サーバー、セキュリティ要件を一元管理する
- AsyncAPIからドキュメント・コード・バリデーターを自動生成する

### 16.2. メッセージブローカー選択基準

| ブローカー | ユースケース | 特性 |
|:---|:---|:---|
| **Apache Kafka** | 大規模イベントストリーム、ログ集約 | 高スループット、永続化、順序保証 |
| **RabbitMQ** | タスクキュー、ワークディスパッチ | 柔軟なルーティング、ACK制御 |
| **Amazon SQS/SNS** | サーバーレス連携、Fan-out | マネージド、スケーラブル |
| **pgmq** | PostgreSQL統合キュー | トランザクション一体型、シンプル |
| **Redis Streams** | 低レイテンシ、軽量イベント | インメモリ、Consumer Group |

### 16.3. メッセージ設計原則

- **スキーマバージョニング**: メッセージスキーマは後方互換を維持しながら進化する
- **Dead Letter Queue (DLQ)**: 処理失敗メッセージの隔離と再処理メカニズムを必ず実装する
- **At-Least-Once + 冪等性**: メッセージ配信は At-Least-Once を前提とし、コンシューマー側で冪等性を保証する
- **Poison Message防止**: 不正なメッセージがコンシューマーを無限リトライさせないよう、リトライ上限とDLQ転送を設定する

---

## Part XVII: Webhook設計・運用

### 17.1. Webhook署名検証

- **Rule 35.31**: 外部サービス（Stripe, Meta, GitHub等）からのWebhook受信時、署名検証（`X-Hub-Signature` 等）なしでの処理開始を禁止する
- プラットフォーム提供の `Signing Secret` を用いてリクエストの真正性を検証する

### 17.2. Replay Attack防止

- Webhookペイロード内の `timestamp` を検証し、**5分以上前**のリクエストは拒否する
- 処理済みイベントIDを一定期間キャッシュし、重複実行を防止する

### 17.3. 冪等性保証

- 同一 `event_id` の Webhook が複数回到達しても副作用が1回のみ発生するよう設計する
- Webhook固有IDを冪等性キーとして使用し、処理前にDB上で重複チェックを実施する

### 17.4. Webhookエラーハンドリング

- 処理失敗時は `5xx` を返し、送信元のリトライ機構に委ねる
- `2xx` を返すと送信元は「成功」とみなしリトライしないため、処理が未完了のまま消失する
- 署名不一致のリクエストは即座に `401 Unauthorized` を返しアラートログに記録する

### 17.5. Webhook送信設計（プロバイダ側）

- **指数バックオフリトライ**: 最大5回、5s→30s→2min→10min→30min
- **イベント登録**: ユーザーが受信するイベントタイプを選択可能にする
- **Webhook管理API**: 登録・更新・削除・テスト送信のAPIを提供する
- **配信ログ**: 送信結果（成功/失敗、ステータスコード、レスポンスタイム）をログに記録し、ダッシュボードで可視化する

---

## Part XVIII: API Gatewayアーキテクチャ

### 18.1. API Gateway責務

| 責務 | 説明 |
|:---|:---|
| **ルーティング** | リクエストを適切なバックエンドサービスに転送 |
| **認証・認可** | JWT/APIキー検証、OAuth 2.1トークン検証 |
| **レート制限** | トラフィック制御、DDoS防止 |
| **プロトコル変換** | REST↔gRPC等のプロトコルブリッジ |
| **リクエスト/レスポンス変換** | ヘッダー追加、ペイロード変換 |
| **キャッシュ** | レスポンスキャッシュ |
| **可観測性** | アクセスログ、メトリクス、トレーシング |
| **使用量計測** | Metering Log |

### 18.2. Gateway配置パターン

- **Edge Gateway**: 外部トラフィック（North-South）のエントリーポイント
- **Internal Gateway**: マイクロサービス間（East-West）のルーティング（Service Mesh併用推奨）
- **Domain Gateway**: ドメイン境界ごとのルーティング

### 18.3. Intelligent Gateway

- AI/ML駆動のスマートトラフィック管理
- 異常検知によるリアルタイムレート制限調整
- トラフィックパターン分析による予測的キャパシティ管理

---

## Part XIX: Service Mesh設計

### 19.1. Service Mesh vs API Gateway

| 観点 | API Gateway | Service Mesh |
|:---|:---|:---|
| **トラフィック方向** | North-South（外部→内部） | East-West（サービス間） |
| **配置** | エッジ | サイドカープロキシ |
| **主要機能** | 認証集約、レート制限、プロトコル変換 | mTLS自動化、リトライ、サーキットブレーカー |
| **可観測性** | APIレベルメトリクス | サービス間通信メトリクス |

- **Rule 35.32**: API GatewayとService Meshは対立するものではなく**補完的**に使用する

### 19.2. mTLS自動化

- Service Meshによるサービス間通信の自動mTLS暗号化を義務付ける
- 証明書のローテーションを自動化し、手動管理を排除する

### 19.3. トラフィック管理

- **Traffic Shifting**: カナリアデプロイでの段階的トラフィック移行
- **Fault Injection**: テスト環境での障害シミュレーション
- **Retry Policy**: サービスメッシュレベルでのリトライ設定

---

## Part XX: BFF（Backend for Frontend）パターン

### 20.1. BFF設計原則

- **Rule 35.33**: フロントエンドプラットフォームごとに最適化されたBFFレイヤーを設計する

| BFF種別 | 対象 | 最適化方針 |
|:---|:---|:---|
| **Web BFF** | Webアプリ | SSR/ISR対応、SEOメタデータ |
| **Mobile BFF** | iOS/Androidアプリ | 帯域幅最小化、バッチAPI |
| **Admin BFF** | 管理画面 | 高密度データ、バルク操作 |

### 20.2. GraphQL BFF

- フロントエンド向けBFFにGraphQLを採用し、Over-fetchingを解消する
- 各BFFは背後の複数マイクロサービスを集約し、フロントエンドは単一エンドポイントへアクセスする

### 20.3. BFFアンチパターン

- ❌ BFFにビジネスロジックを配置する（BFFはデータ集約・変換のみ）
- ❌ BFFが直接DBにアクセスする（必ずAPIレイヤーを経由）
- ❌ 全プラットフォームで単一BFFを共有する（プラットフォーム固有のニーズを無視）

---

## Part XXI: レジリエンスパターン

### 21.1. サーキットブレーカー

- **Rule 35.34**: 外部サービス呼び出しには必ずサーキットブレーカーを実装する

| 状態 | 動作 |
|:---|:---|
| **Closed** | 正常動作。失敗カウント監視中 |
| **Open** | 即座にエラーを返却。バックエンドへのリクエストを遮断 |
| **Half-Open** | 少量のリクエストを試行。成功ならClosed、失敗ならOpenへ |

- **Adaptive Circuit Breaker**: トラフィックパターンとレイテンシから失敗率閾値を動的調整する

### 21.2. リトライ戦略

- **Rule 35.35**: 一時的エラーには「指数バックオフ + Jitter」を適用し、Thundering Herd問題を回避する

```typescript
// 指数バックオフ + Jitter
const delay = Math.min(
  baseDelay * Math.pow(2, attempt) + Math.random() * jitterMs,
  maxDelay
);
```

- リトライ可能な条件（5xx、UNAVAILABLE、タイムアウト等）を明確に定義する
- 最大リトライ回数を設定する（推奨: 3回）

### 21.3. Bulkhead（隔壁）パターン

- リソースプール（スレッド、コネクション）をサービスごとに分離し、障害の波及を防止する
- 1つのサービスの障害が他サービスのリソースを枯渇させない

### 21.4. Timeout設計

- **Rule 35.36**: 全外部呼び出しにタイムアウトを設定する。タイムアウトなしの呼び出しは禁止する
- 接続タイムアウト（推奨: 3秒）とリクエストタイムアウト（推奨: 10秒）を個別に設定する
- サービスチェーンではダウンストリームのタイムアウトを考慮して上流のタイムアウトを設定する

### 21.5. Fallbackパターン

- プライマリサービス障害時の代替動作を事前定義する
- キャッシュデータの返却、デフォルト値、機能の縮退運転等

---

## Part XXII: 冪等性設計

### 22.1. Idempotency-Key

- **Rule 35.37**: 決済・作成・更新等の副作用を伴う全リクエスト（POST/PUT/PATCH）において `Idempotency-Key` ヘッダーの実装を義務付ける
- ネットワークエラーでリトライが発生しても、同じキーのリクエストはサーバー側で「一度だけ」処理し、二重課金等を確実に防ぐ

### 22.2. 冪等性実装パターン

```typescript
// サーバー側冪等性チェック
async function processWithIdempotency(key: string, handler: () => Promise<Result>) {
  const existing = await db.idempotencyKeys.findUnique({ where: { key } });
  if (existing) return existing.response; // キャッシュ済みレスポンスを返却

  const result = await handler();
  await db.idempotencyKeys.create({
    data: { key, response: result, expires_at: addHours(24) }
  });
  return result;
}
```

### 22.3. 冪等性キーの管理

- TTL: 24時間以上保持し、期限切れ後に自動削除
- ストレージ: Redis（高速）またはDB（永続）
- キー形式: `{client_id}:{operation}:{unique_id}`

---

## Part XXIII: レート制限・スロットリング

### 23.1. レート制限アルゴリズム

| アルゴリズム | 特性 | 推奨ケース |
|:---|:---|:---|
| **Token Bucket** | バースト許容、安定スループット | API全般（推奨） |
| **Sliding Window** | 正確な時間窓、均一分散 | 厳密な制限が必要な場合 |
| **Fixed Window** | シンプル実装 | 低精度で十分な場合 |
| **Leaky Bucket** | 一定レートで処理 | 均一な処理が必要な場合 |

### 23.2. 分散レート制限

- **Rule 35.38**: RedisをバックストアとしたToken Bucketアルゴリズムで分散環境下でも正確なレート制限を実施する

### 23.3. レート制限ヘッダー

- **Rule 35.39**: レスポンスヘッダーでレート制限情報を通知する

```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 42
X-RateLimit-Reset: 1711101600
Retry-After: 30
```

### 23.4. Tier別レート制限

| Tier | レート制限 | バースト |
|:---|:---|:---|
| **Free** | 100 req/min | 10 req/sec |
| **Pro** | 1,000 req/min | 50 req/sec |
| **Enterprise** | 10,000 req/min | 500 req/sec |
| **Native App (VIP)** | Enterprise相当 | Enterprise相当 |

---

## Part XXIV: API SLO・信頼性契約

### 24.1. API SLI/SLO定義

| SLI | 計測方法 | SLO目標 |
|:---|:---|:---|
| **可用性** | 成功リクエスト / 総リクエスト | ≥ 99.9% |
| **レイテンシ (p50)** | リクエスト処理時間の中央値 | ≤ 100ms |
| **レイテンシ (p99)** | リクエスト処理時間の99パーセンタイル | ≤ 500ms |
| **エラー率** | 5xxレスポンス / 総レスポンス | ≤ 0.1% |
| **スループット** | 1秒あたりの処理リクエスト数 | ≥ 1,000 rps |

### 24.2. 外部依存SLO

- **Rule 35.40**: 外部サービス（Stripe, OpenAI等）のSLOを自社SLOに加味する。外部依存を含めた「End-to-End SLO」を定義する
- 外部サービスのダウンタイムは自社のError Budgetを消費する

### 24.3. Error Budget Policy

- Error Budgetが枯渇した場合、新機能開発を凍結し信頼性改善に集中する
- Error Budget消費率に基づくアラート閾値を設定する

---

## Part XXV: Graceful Degradation・障害隔離

### 25.1. Graceful Degradation

- **Rule 35.41**: APIは外部依存サービスの障害時にも部分的に機能を継続する設計を義務付ける
- Feature Flagと連動し、障害サービスに依存する機能のみを無効化する
- キャッシュされたデータでの代替応答、デフォルト値の返却等のフォールバック戦略を事前定義する

### 25.2. 障害隔離レベル

| レベル | 対象 | 方法 |
|:---|:---|:---|
| **プロセス隔離** | CPU/メモリ | Bulkhead、リソースプール分離 |
| **サービス隔離** | サービス間依存 | サーキットブレーカー、タイムアウト |
| **データ隔離** | データアクセス | Database-per-Service、Read Replica |
| **インフラ隔離** | インフラ障害 | マルチAZ、Cell-Based Architecture |

---

## Part XXVI: APIセキュリティ基盤

### 26.1. Zero Trust API Security

- **Rule 35.42**: 全APIリクエストを「信頼しない」前提で設計する。ネットワーク境界ではなくリクエスト単位で認証・認可を検証する
- マイクロサービス間通信もmTLSで相互認証する

### 26.2. OWASP API Security Top 10 2023/2025準拠

**API Security Top 10 2023（API固有）:**

| # | リスク | 対策 |
|:---|:---|:---|
| **API1** | Broken Object Level Authorization (BOLA) | リソースアクセス時にオブジェクトレベルの認可チェック |
| **API2** | Broken Authentication | OAuth 2.1、MFA、レート制限 |
| **API3** | Broken Object Property Level Authorization | DTO義務、フィールドレベル認可 |
| **API4** | Unrestricted Resource Consumption | レート制限、ペイロードサイズ制限 |
| **API5** | Broken Function Level Authorization | RBAC/ABAC、最小権限 |
| **API6** | Unrestricted Access to Sensitive Business Flows | ビジネスフローレベルのレート制限 |
| **API7** | Server Side Request Forgery (SSRF) | URLホワイトリスト、内部ネットワークブロック |
| **API8** | Security Misconfiguration | 設定の自動検証、最小公開 |
| **API9** | Improper Inventory Management | APIカタログ、バージョン管理 |
| **API10** | Unsafe Consumption of APIs | サードパーティAPI応答のバリデーション |

**OWASP Top 10:2025（Web全般、API関連強化）:**

| # | リスク | API観点での対策 |
|:---|:---|:---|
| **A01** | Broken Access Control（SSRFを統合） | BOLA/BFLA徹底、SSRF防御をAPI層で実装 |
| **A02** | Security Misconfiguration | API Gateway設定自動検証、デフォルト拒否 |
| **A03** | Software Supply Chain Failures（新規） | API依存関係のSBOM管理（→ Part LIX参照） |
| **A05** | Injection | API入力のスキーマバリデーション必須化 |
| **A10** | Mishandling of Exceptional Conditions（新規） | API例外処理の標準化、RFC 7807徹底 |

### 26.3. AI Agent API セキュリティ

- **Rule 35.79**: AIエージェントからのAPI呼び出しには、通常ユーザーと異なるレート制限・スコープ制限・監査ポリシーを適用する
- AIエージェントの「権限昇格」「過剰ツール実行」を防止するガードレールを実装する
- OWASP Top 10 for LLM Applications 2025（Prompt Injection、Sensitive Data Exposure、Supply Chain）への対応を義務付ける

### 26.4. HTTPS義務化

- **Rule 35.80**: 全環境（開発含む）でHTTPS/TLS 1.3を義務付ける。HTTP通信は全面禁止する

---

## Part XXVII: 認証・認可アーキテクチャ

### 27.1. OAuth 2.1

- **Rule 35.44**: 認証フローはOAuth 2.1に準拠する
- **PKCE必須**: 全認証コードフロー（パブリック・コンフィデンシャルクライアント両方）でPKCEを義務付ける
- **非推奨フロー排除**: Implicit Grant、Resource Owner Password Credentials Grantを全面禁止する
- **Sender-Constrained Tokens**: DPoPまたはmTLSによるトークンバインディングを推奨する

### 27.2. DPoP（Demonstrating Proof of Possession）

- アクセストークンをクライアントの秘密鍵にバインドし、トークン窃取時の悪用を防止する
- モバイルアプリやパブリッククライアントで特に有効

### 27.3. Passkeys / FIDO2

- パスワードレス認証の実装を推奨する
- フィッシング耐性があり、デバイスの生体認証（指紋、顔認証）でユーザー体験を向上する
- WebAuthn APIとの統合

### 27.4. Bearer Token検証

- **Rule 35.45**: Bearer Tokenの検証には単なる署名確認ではなく、必ず `supabase.auth.getUser()` 等のサーバーサイド検証を使用する。Ban状態やセッション失効をリアルタイムに確認する

### 27.5. Native Bypass Protocol（VIP Lane Strategy）

- **Rule 35.46**: 自社アプリからのアクセスにAPI Key（`x-api-key`）を要求することを禁止する。MiddlewareでAPI Key認証（Enterprise）とBearer Token認証（Native/VIP）のOR条件を実装し、自社アプリのログインユーザーにはEnterprise相当の特権を付与する

---

## Part XXVIII: APIキー・トークン管理

### 28.1. APIキー保存

- **Rule 35.47**: API Key（`sk_live_...`）を平文でDBに保存することを厳禁する。`SHA-256` でハッシュ化して保存し、認証時は入力値をハッシュ化して照合する

### 28.2. トークンライフサイクル

| トークン種別 | TTL | ローテーション |
|:---|:---|:---|
| **Access Token** | 15分 | 自動（Refresh Token使用） |
| **Refresh Token** | 7日 | ローテーション方式（使用で新発行） |
| **API Key** | 無期限 | 90日ごとの手動ローテーション |

### 28.3. Scope最小化

- **Rule 35.48**: APIキー・トークンには必要最小限のスコープのみ付与する
- 読み取り専用、書き込み専用、管理者等のスコープを細分化する

---

## Part XXIX: 入力バリデーション・サニタイズ

### 29.1. Schema Validation

- **Rule 35.49**: 全APIエンドポイントでリクエストボディのスキーマバリデーションを実施する（Zod, Joi等）
- 未知のフィールドは拒否する（`strictMode`）

### 29.2. Content-Type強制

- `Content-Type` ヘッダーの検証を必須とし、想定外のContent-Typeは拒否する
- JSONエンドポイントで `text/plain` 等の不正なContent-Typeを受け入れない

### 29.3. ペイロードサイズ制限

- リクエストボディサイズの上限を設定する（推奨: 1MB、ファイルアップロードは別途設計）
- 過大なJSONペイロードによるDoS攻撃を防止する

### 29.4. SSRF防止

- ユーザー提供のURLを内部リクエストに使用する場合、ホワイトリスト検証・内部IPブラック確認を必須とする
- `169.254.169.254`（クラウドメタデータ）, `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16` 等のプライベートIPへのリクエストをブロックする

---

## Part XXX: CORSガバナンス

### 30.1. CORS Governance Protocol

- **Rule 35.50**: 明示的に許可されていないオリジンからのリクエストは全てブロックする

### 30.2. 環境別CORSポリシー

| 環境 | 許可オリジン | 設定方法 |
|:---|:---|:---|
| **Production** | 自社ドメインのみ | フレームワーク設定ファイル |
| **Preview/Staging** | Preview用ドメインパターン | 環境変数で動的設定 |
| **Development** | `http://localhost:*` | `.env.local` |
| **API外販（将来）** | 契約者ドメインのホワイトリスト | DB管理 + APIキーに紐付け |

### 30.3. CORSセキュリティルール

- `Access-Control-Allow-Credentials: true` は認証必要エンドポイントのみに限定し、`Allow-Origin: *` との組み合わせを**厳禁**とする
- `Access-Control-Max-Age: 86400` を設定し、不要なOPTIONSリクエストを削減する
- 本番環境での `Access-Control-Allow-Origin: *` 使用は厳禁（`600_security_privacy.md` 参照）

---

## Part XXXI: DTO設計・データマッピング

### 31.1. DTO Obligation（データ転送義務）

- **Rule 35.51**: データベースのRawオブジェクトを直接APIレスポンスとして返却することを「重罪」とする
- レイヤー別DTOを定義し、各レイヤーで意図的なフィールドマッピングを行う

### 31.2. DTO階層

| DTO | 用途 | 含まれるフィールド |
|:---|:---|:---|
| **PublicDTO** | 一般ユーザー向けAPI | 公開可能な基本情報のみ |
| **AuthenticatedDTO** | ログインユーザー向け | ユーザー固有情報を追加 |
| **AdminDTO** | 管理者向けAPI | 運用情報を追加（内部メモ等は除外） |
| **InternalDTO** | サービス内部通信 | 全フィールド（外部に公開しない） |

### 31.3. DTO Assertionテスト

```typescript
// ✅ 除外フィールドの不在を検証するテスト
it('should not expose password_hash in response', async () => {
  const response = await api.get('/api/v1/users/1');
  expect(response.data).not.toHaveProperty('password_hash');
  expect(response.data).not.toHaveProperty('is_admin');
  expect(response.data).not.toHaveProperty('internal_memo');
});
```

---

## Part XXXII: データシリアライゼーション

### 32.1. JSON設計基準

- フィールド名は `camelCase`（REST）または `snake_case`（DB連携）で統一する
- 日時は ISO 8601 形式（`2026-03-22T09:00:00Z`）で返却する
- 金額は最小単位の整数値で返却する（例: ¥100 → `10000` = 100円 × 100）
- `null` と未定義の区別: `null` は「値が存在しない」、フィールド省略は「情報なし」

### 32.2. Content Negotiation

- `Accept` ヘッダーに基づくレスポンス形式の切り替え（JSON, XML, Protocol Buffers等）
- デフォルトは `application/json`

---

## Part XXXIII: Server Action設計

### 33.1. Graceful Return Protocol

- **Rule 35.52**: Server Action（`'use server'` 関数）でのエラーを `throw` によりクライアントに伝播させることを原則禁止する。全エラーを構造化レスポンスとして返却する

```typescript
// ✅ 正: 構造化レスポンス
type ActionResponse<T> =
  | { success: true; data: T }
  | { success: false; error: string; code?: string };

async function createStore(input: CreateStoreInput): Promise<ActionResponse<Store>> {
  try {
    const store = await db.stores.create({ data: input });
    return { success: true, data: store };
  } catch (error) {
    logger.error('Failed to create store', { error });
    return { success: false, error: 'Store creation failed', code: 'CREATION_FAILED' };
  }
}
```

### 33.2. Strict Action Return Type Protocol

- **Rule 35.53**: Server Actionの戻り値に対する厳格な型定義を義務付ける。UI側での `as any` キャストを永久禁止する
- `void` や `any` を戻り値型にすることを禁止する
- シリアライゼーション境界を通過するため、`Date`, `Map`, `Set`, クラスインスタンスを含めない

### 33.3. Typed Error Codes

- エラーレスポンスに機械可読な `code` を含める

| コード | 説明 | UI側アクション |
|:---|:---|:---|
| `VALIDATION_ERROR` | 入力バリデーション失敗 | フォームエラー表示 |
| `PERMISSION_DENIED` | 権限不足 | 権限エラーメッセージ |
| `NOT_FOUND` | リソース未発見 | 404画面遷移 |
| `CONFLICT` | データ競合 | リロード促進 |
| `RATE_LIMITED` | レート制限超過 | リトライ案内 |

### 33.4. ロギング義務

- **Rule 35.54**: エラーを戻り値として返す前に、必ずサーバーサイドでログ出力する。戻り値によるエラーハンドリングはログ出力を怠ると可観測性を失う

---

## Part XXXIV: キャッシュ戦略

### 34.1. HTTPキャッシュ

- **Rule 35.55**: 適切なキャッシュヘッダーを全APIレスポンスに設定する

| ヘッダー | 用途 | 設定例 |
|:---|:---|:---|
| **Cache-Control** | キャッシュ動作の制御 | `max-age=300, stale-while-revalidate=60` |
| **ETag** | コンテンツハッシュによる条件付きリクエスト | `"v1-abc123"` |
| **Last-Modified** | 最終更新日時 | `Sun, 22 Mar 2026 09:00:00 GMT` |
| **Vary** | キャッシュキーの差異化 | `Accept, Authorization` |

### 34.2. Stale-While-Revalidate

- 期限切れキャッシュを即座に返却しながらバックグラウンドで再検証する
- ユーザー体験（レイテンシ）とデータ鮮度のバランスを最適化する

### 34.3. キャッシュ階層

| 階層 | 対象 | TTL |
|:---|:---|:---|
| **CDN** | 静的アセット、公開API | 1時間〜1日 |
| **API Gateway** | レスポンスキャッシュ | 5分〜1時間 |
| **Application** | DB結果、計算結果 | 1分〜30分 |
| **Client** | ローカルキャッシュ | SWR戦略 |

### 34.4. Semantic Caching

- AIレスポンス等の意味的に類似したリクエストに対し、ベクトル類似度に基づくキャッシュを実装する
- コスト削減とレイテンシ改善に有効

---

## Part XXXV: ペイロード最適化

### 35.1. 圧縮

- **Rule 35.56**: `Content-Encoding: gzip` または `br`（Brotli）でレスポンスを圧縮する
- 1KB以下のレスポンスは圧縮オーバーヘッドが上回るため非圧縮とする

### 35.2. Pagination

- Part V で定義したCursor-Based Paginationを標準とする
- ページサイズのデフォルト値と最大値を設定する（推奨: default=20, max=100）

### 35.3. Field Selection

- クライアントが必要なフィールドのみを指定可能にする（`?fields=id,name,address`）
- 帯域幅の削減とモバイルパフォーマンスの向上に有効

### 35.4. Batch API

- 複数のリソース取得を単一リクエストで実行可能にする
- `POST /api/v1/batch` エンドポイントで複数操作をバンドルする
- 個別リクエストのオーバーヘッド（接続確立、認証検証等）を削減する

---

## Part XXXVI: スケーラビリティ設計

### 36.1. Stateless Gateway Protocol

- **Rule 35.57**: API Gateway・バックエンドサービスはステートレスに設計する。Sticky Sessionを禁止し、水平スケーリングを可能にする
- セッション状態は外部ストア（Redis等）に保持する

### 36.2. Cell-Based Architecture

- インフラを独立したセル（Cell）に分割し、障害の影響範囲を限定する
- 各セルは独立してスケーリング・デプロイ可能にする

### 36.3. 水平スケーリング指針

- ステートレスサービスはPod/インスタンスの追加でスケーリング
- ステートフルサービス（DB等）はRead Replica、シャーディングで対応
- Auto-Scaling: CPU使用率、リクエストレート、キューの深さに基づくスケーリングルールを設定する

---

## Part XXXVII: API可観測性

### 37.1. OpenTelemetry計装

- **Rule 35.58**: 全APIサービスにOpenTelemetry（OTel）計装を義務付ける。ベンダーロックインを回避し、統一的な可観測性基盤を構築する

### 37.2. 分散トレーシング

- 全リクエストに一意の `trace_id` を付与し、サービスチェーン全体のフローを追跡可能にする
- `W3C Trace Context` ヘッダー（`traceparent`）を伝播する

### 37.3. API Metrics（Golden Signals）

| メトリクス | 説明 | アラート閾値 |
|:---|:---|:---|
| **Latency** | リクエスト処理時間 | p99 > 500ms |
| **Traffic** | リクエストレート | 異常増減 |
| **Errors** | エラーレート | > 1% |
| **Saturation** | リソース使用率 | > 80% |

### 37.4. カスタムメトリクス

- ビジネスメトリクス（API呼び出し回数/顧客、エンドポイント別使用量等）を収集し、FinOpsとAPI Product分析に活用する

---

## Part XXXVIII: API監査ログ

### 38.1. Outbound Audit Mandate

- **Rule 35.59**: 全外部APIコール（Stripe, OpenAI, 地図API等）のリクエスト・レスポンスを構造化ログとして記録する

```typescript
logger.info('External API call', {
  direction: 'outbound',
  service: 'stripe',
  method: 'POST',
  endpoint: '/v1/payment_intents',
  status: 200,
  duration_ms: 342,
  request_id: 'req_abc123',
  trace_id: 'trace_def456',
});
```

### 38.2. AI推論ログ

- AI API呼び出しのモデル名、Token消費量、コスト、レスポンスタイムを記録する
- FinOps最適化とモデル選択の判断材料とする

### 38.3. 機密データのマスキング

- ログに含まれるPII（メールアドレス、電話番号等）を自動マスキングする
- APIキーやトークンの全文をログに出力しない（先頭4文字+マスク）

---

## Part XXXIX: APIヘルスチェック・ステータス

### 39.1. ヘルスチェックエンドポイント

| エンドポイント | 用途 | 検証内容 |
|:---|:---|:---|
| **GET /health** | Liveness Check | プロセスの生存確認 |
| **GET /ready** | Readiness Check | 依存サービス（DB、Redis等）の接続確認 |
| **GET /status** | 詳細ステータス | バージョン、ビルド情報、依存サービス状態 |

### 39.2. ヘルスチェック設計

- `/health` は認証不要で、常に高速応答（<100ms）する
- `/ready` は依存サービスのヘルスチェックを含み、全依存が正常な場合のみ `200` を返す
- KubernetesのLiveness/Readiness Probeと統合する

---

## Part XL: API公開ドキュメント基準

### 40.1. Live Documentation

- **Rule 35.60**: APIドキュメントはコードから自動生成し、常に最新の状態を維持する。手書きドキュメントの単独運用を禁止する
- RESTはOpenAPI仕様からSwagger UI/Redocを自動生成する
- GraphQLはGraphiQL/Apollo Studioで対話的に探索可能にする

### 40.2. ドキュメント必須要素

| 要素 | 説明 |
|:---|:---|
| **エンドポイント一覧** | URL、メソッド、パラメータ |
| **リクエスト/レスポンス例** | 実データに近いサンプル |
| **エラーレスポンス例** | 各ステータスコードのサンプル |
| **認証方法** | Bearer Token、API Key等の取得・使用方法 |
| **レート制限情報** | Tier別制限値 |
| **Sandbox環境** | テスト用エンドポイント |
| **多言語コード例** | cURL, JavaScript, Python, Go等 |
| **Changelog** | バージョン別の変更履歴 |

### 40.3. バイリンガル対応

- APIドキュメントは原則として英語で作成し、必要に応じて日本語版を併設する

---

## Part XLI: 開発者エクスペリエンス（DX）

### 41.1. Developer Portal

- API利用者向けのポータルサイトを提供する
- 登録・APIキー発行・使用量確認・課金管理を自己完結可能にする

### 41.2. SDK自動生成

- **Rule 35.61**: OpenAPI仕様から TypeScript, Python, Go, Swift, Kotlin のクライアントSDKを自動生成する
- `openapi-generator-cli` または `openapi-typescript` を使用する

### 41.3. Onboarding最適化

- 「5分以内に最初のAPIコールを成功させる」をDX目標とする
- Quick Startガイド、Sandbox環境、サンプルコードを充実させる

### 41.4. Changelog管理

- 全バージョンの変更履歴をChangelogに記録する
- Breaking Change、新機能追加、バグ修正を明確に分類する

---

## Part XLII: API Contract Testing

### 42.1. Consumer-Driven Contract Testing（CDC）

- **Rule 35.62**: API変更がコンシューマーを破壊しないことをCIパイプラインで自動検証する
- Pact等のCDCフレームワークを使用し、Provider-Consumer間の契約を自動テストする

### 42.2. スキーマ駆動テスト

- OpenAPI仕様に対するレスポンスの適合性テストを自動実行する
- レスポンスが仕様と乖離した場合にCIを失敗させる

### 42.3. Breaking Change CI Gate

- **Rule 35.63**: OpenAPI差分比較（`oasdiff` 等）をCI Gateとして設置し、Breaking Changeを含むPRを自動ブロックする
- レビューと承認を経てのみBreaking Changeをマージ可能にする

---

## Part XLIII: API Product Mindset

### 43.1. API as Asset

- **Rule 35.64**: APIは技術的エンドポイントではなく「販売可能な商品」として管理する
- 利用者数・利用頻度・収益・満足度をKPIとして追跡する

### 43.2. Tiered Access

| Tier | 対象 | 利用範囲 |
|:---|:---|:---|
| **Free** | 評価・開発用 | Rate Limit厳格、機能制限 |
| **Pro** | 小規模プロダクション | Rate Limit緩和 |
| **Enterprise** | 大規模サービス | カスタムRate Limit、SLA付き |
| **Native App (VIP)** | 自社アプリ | Enterprise相当（課金なし） |

### 43.3. Data Monetization Privacy

- **Rule 35.65**: API経由で提供するデータの匿名化インターフェースを実装し、プライバシーとデータ収益化を両立する

---

## Part XLIV: API Gateway使用量計測

### 44.1. Metering Log

- **Rule 35.66**: API Gateway層で全リクエストの使用量ログを非同期で記録する
- ログには API Key, エンドポイント, タイムスタンプ, レスポンスサイズ, レイテンシ を含める

### 44.2. 非同期記録

- メインのリクエスト処理パスに使用量記録のレイテンシを加えない
- バックグラウンドプロセスまたはメッセージキューで非同期処理する

### 44.3. 集計と可視化

- 日次・月次の使用量集計を実行し、課金・FinOps分析に活用する
- ダッシュボードで使用量トレンドを可視化する

---

## Part XLV: API FinOps

### 45.1. コスト配分

- **Rule 35.67**: API呼び出しコストをサービス・チーム・顧客ごとに配分する
- OpenTelemetryのメタデータ（`tier`, `customer_id`）を活用してコスト帰属を実現する

### 45.2. 外部API予算管理

- 外部API（OpenAI, Stripe, Maps等）の利用にサービスごとの月次予算上限を設定する
- 予算の80%消費時にアラート、100%消費時に自動スロットリングを実施する

### 45.3. コスト最適化

- 使用頻度の低いエンドポイントの特定と統合
- キャッシュ強化による外部API呼び出し削減
- レスポンスペイロードの最適化による転送コスト削減

---

## Part XLVI: マイクロサービス設計原則

### 46.1. Bounded Context

- **Rule 35.68**: マイクロサービスの境界はDDD（Domain-Driven Design）のBounded Contextに一致させる
- サービス間で直接DBを共有することを「重罪」とする（Database-per-Service原則）

### 46.2. Decomposition Strategy

| 戦略 | 説明 | 適用ケース |
|:---|:---|:---|
| **By Business Capability** | ビジネス機能に基づく分割 | 明確な業務ドメインがある場合 |
| **By Subdomain** | DDDサブドメインに基づく分割 | 複雑なドメインモデルの場合 |
| **Strangler Fig** | レガシーからの段階的移行 | モノリスからの移行 |

### 46.3. サービスサイズの指針

- 「1チームが所有・運用できるサイズ」を基準とする（Two-Pizza Teamルール）
- 大きすぎるサービスはBounded Contextの見直し、小さすぎるサービスは統合を検討する

### 46.4. サービス間API設計

- 内部APIはgRPCを推奨（パフォーマンス・型安全）
- 公開APIはRESTを推奨（汎用性・ツールエコシステム）
- 内部APIにもContract Testing（Part XLII）を適用する

---

## Part XLVII: サービス間通信パターン

### 47.1. 同期 vs 非同期

| パターン | 特性 | ユースケース |
|:---|:---|:---|
| **同期（Request-Response）** | 即時応答、強い一貫性 | クエリ、リアルタイム要求 |
| **非同期（Event-Driven）** | 疎結合、高回復力 | コマンド、バックグラウンド処理 |

- **Rule 35.69**: デフォルトは非同期通信を推奨する。同期通信はリアルタイム応答が必要なクエリに限定する

### 47.2. Choreography vs Orchestration

| 方式 | 特性 | 推奨ケース |
|:---|:---|:---|
| **Choreography** | 各サービスが独立してイベント発行・購読 | シンプルなフロー（2-3ステップ） |
| **Orchestration** | 中央のオーケストレーターがフロー制御 | 複雑なフロー（4ステップ以上） |

### 47.3. Data Mesh連携

- 各マイクロサービスが「データプロダクト」としてAPIを公開する
- データの所有権はドメインチームが持ち、中央データチームはプラットフォーム提供に集中する

---

## Part XLVIII: 分散データ管理

### 48.1. Saga Pattern詳細

- Part XVで概説したSagaパターンの詳細実装ガイド
- 各ステップの補償トランザクションを事前定義する
- Sagaの状態を永続化し、障害時のリカバリを保証する

### 48.2. Outbox Pattern詳細

- **Rule 35.70**: ローカルDBトランザクションとイベント発行のアトミック性を保証する
- `outbox` テーブルにイベントを書き込み、Debezium等のCDCツールでイベントブローカーに転送する

```sql
-- Outboxテーブル
CREATE TABLE outbox (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  aggregate_type VARCHAR(255) NOT NULL,
  aggregate_id VARCHAR(255) NOT NULL,
  event_type VARCHAR(255) NOT NULL,
  payload JSONB NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now(),
  published_at TIMESTAMPTZ
);
```

### 48.3. Change Data Capture (CDC)

- Debezium等のCDCツールでDBの変更をリアルタイムにイベントストリームへ変換する
- Outbox Patternとの併用でイベント駆動アーキテクチャを実現する

### 48.4. 結果整合性（Eventual Consistency）

- **Rule 35.71**: マイクロサービス間のデータ整合性は結果整合性を前提にし、補償トランザクションで一貫性を保証する
- 強い一貫性が必要な場合は同一サービス内で処理を完結させる

---

## Part XLIX: 高度書き込みプロトコル

### 49.1. Secure Write Action Protocol

- **Rule 35.72**: 以下の重要操作にはOTP＋Turnstile Token（Bot検証）の二重認証を義務付ける
  - パスワード変更
  - メールアドレス変更
  - アカウント削除
  - 決済情報変更
  - 管理者権限の変更

### 49.2. Hybrid Sync禁止

- **Rule 35.73**: DBとサードパーティサービス（例: Stripe Customer）の二重管理を禁止する
- 一方を正（Source of Truth）とし、他方はAPI経由で参照する

### 49.3. 楽観的ロック

- 同時更新による競合を検出・防止するために `version` カラムまたは `updated_at` を使用する
- 競合時は `409 Conflict` を返し、クライアントに再取得・再送信を促す

---

## Part L: AI統合API設計

### 50.1. MCP / A2A対応

- **Rule 35.74**: AIエージェントがAPIを発見・呼び出しできるよう、OpenAPI仕様にメタデータ（`x-ai-description`, `x-ai-examples`）を付与する
- MCP（Model Context Protocol）対応のツール定義を提供する
- A2A（Agent-to-Agent）通信のためのAPI設計を検討する

### 50.2. LLM Function Calling対応

- OpenAPI仕様から LLM の Function Calling スキーマを自動生成する
- 各パラメータに明確な `description` を付与し、AIの推論精度を向上する

### 50.3. メタデータ戦略

- APIレスポンスに以下のメタデータを含め、AIエージェントの判断材料を提供する

| メタデータ | 説明 |
|:---|:---|
| `tier` | アクセス層（Free/Pro/Enterprise） |
| `usage` | 使用量計測方法（metered/unlimited） |
| `revalidation_ttl` | データ鮮度（秒） |
| `confidence` | データの信頼度（AI生成データの場合） |

### 50.4. AI Gateway

- AI API（OpenAI, Anthropic, Google AI等）への呼び出しを集約するAI Gatewayを設計する
- レート制限、コスト管理、フォールバック（モデル切替）、監査ログを一元管理する

---

## Part LI: APIライフサイクル管理

### 51.1. ライフサイクルフェーズ

| フェーズ | 説明 | 成果物 |
|:---|:---|:---|
| **Design** | API仕様の設計・レビュー | OpenAPI仕様書 |
| **Develop** | 実装・ユニットテスト | コード、テスト |
| **Test** | 統合テスト・Contract Test | テスト結果 |
| **Deploy** | ステージング→本番デプロイ | デプロイメント |
| **Monitor** | 可観測性・SLO監視 | ダッシュボード |
| **Deprecate** | 非推奨化・移行誘導 | Sunset Notice |
| **Retire** | エンドポイント廃止 | 廃止通知 |

### 51.2. API Catalog

- **Rule 35.75**: 全APIをカタログに登録し、エンドポイント・所有チーム・ステータス・バージョンを一元管理する
- シャドウAPI（未登録API）の定期検出と登録を義務付ける

---

## Part LII: マイクロサービス運用

### 52.1. デプロイ戦略

| 戦略 | 説明 | リスク |
|:---|:---|:---|
| **Blue-Green** | 旧環境と新環境を切り替え | 低リスク、高コスト |
| **Canary** | 段階的にトラフィックを移行 | 低リスク、漸進的 |
| **Rolling** | インスタンスを順次更新 | 中リスク |
| **Feature Flag** | コードレベルで機能ON/OFF | 最低リスク |

### 52.2. Progressive Delivery

- **Rule 35.76**: 新APIバージョンの展開はCanary→段階的拡大→全面切替のProgressive Deliveryを義務付ける
- 各段階でSLIを監視し、閾値違反時は自動ロールバックする

### 52.3. サービスの独立デプロイ

- **Rule 35.77**: 各マイクロサービスは他のサービスと独立してデプロイ可能でなければならない
- デプロイ順序への依存を排除する

---

## Part LIII: 規制コンプライアンス

### 53.1. EU Data Act

- API経由のデータアクセスにおいてEU Data Act要件（データポータビリティ、公正なデータ共有）を遵守する

### 53.2. PCI DSS

- 決済関連APIはPCI DSS準拠を義務付ける
- カード番号の直接取り扱いを禁止し、トークン化（Stripe Tokens等）を使用する

### 53.3. データ越境

- API経由のデータ転送においてデータレジデンシー要件（GDPR、日本の個人情報保護法等）を遵守する
- データの保存・処理場所を明示し、越境転送時は適切な保護措置を実施する

### 53.4. API Boundary

- **Rule 35.78**: 規制対象データを扱うAPIは専用のAPI Boundaryに隔離し、監査ログ・アクセス制御を強化する

---

## Part LIV: 成熟度モデル（5段階）

### 54.1. API Maturity Model

| レベル | 名称 | 特性 |
|:---|:---|:---|
| **L1** | Ad-hoc | ルールなし。各チームが独自にAPI設計 |
| **L2** | Defined | API設計ガイドラインが存在。一部自動化 |
| **L3** | Managed | OpenAPI必須。CI/CD統合。Contract Testing開始 |
| **L4** | Optimized | API Product化。FinOps統合。SLO駆動 |
| **L5** | Strategic | APIエコノミー確立。AI統合。データ収益化 |

### 54.2. 段階的導入ロードマップ

- **Phase 1 (L1→L2)**: API Style Guideの策定、OpenAPI導入
- **Phase 2 (L2→L3)**: CI/CD統合、Contract Testing、自動ドキュメント生成
- **Phase 3 (L3→L4)**: API Catalog、FinOps統合、SLO/Error Budget運用
- **Phase 4 (L4→L5)**: API収益化、AI統合（MCP/A2A）、Data Monetization

---

## Part LV: アンチパターン集（25選）

### 55.1. 設計アンチパターン

| # | アンチパターン | 正しいアプローチ |
|:---|:---|:---|
| 1 | **God API**: 全機能を1エンドポイントに集約 | リソース指向で分割 |
| 2 | **Chatty API**: 大量の小さなリクエストが必要 | BFF/GraphQLで集約 |
| 3 | **手書き型定義**: OpenAPI/Protobufから自動生成しない | スキーマからの自動生成を義務化 |
| 4 | **Versioning地獄**: 過剰なバージョン増加 | Additive Changeで進化 |
| 5 | **RPC-style URL**: `/getUsers`, `/createOrder` | リソース名詞 + HTTPメソッド |

### 55.2. セキュリティアンチパターン

| # | アンチパターン | 正しいアプローチ |
|:---|:---|:---|
| 6 | **APIキー平文保存** | SHA-256ハッシュ化 |
| 7 | **CORS `*` in Production** | 明示的オリジンホワイトリスト |
| 8 | **Implicit Grant使用** | OAuth 2.1 + PKCE |
| 9 | **入力バリデーション省略** | 全エンドポイントでSchema Validation |
| 10 | **内部エラーメッセージ漏洩** | RFC 7807準拠のセマンティックエラー |

### 55.3. 信頼性アンチパターン

| # | アンチパターン | 正しいアプローチ |
|:---|:---|:---|
| 11 | **タイムアウト未設定** | 全外部呼び出しにタイムアウト必須 |
| 12 | **リトライなしの外部呼び出し** | 指数バックオフ + Jitter |
| 13 | **サーキットブレーカー未実装** | 全外部依存にサーキットブレーカー |
| 14 | **冪等性未実装の決済API** | Idempotency-Key必須 |
| 15 | **Thundering Herd** | Jitter付きリトライ + キャッシュ |

### 55.4. 運用アンチパターン

| # | アンチパターン | 正しいアプローチ |
|:---|:---|:---|
| 16 | **DB共有マイクロサービス** | Database-per-Service |
| 17 | **ログなし外部API呼び出し** | Outbound Audit Mandate |
| 18 | **手書きドキュメントのみ** | OpenAPIからの自動生成 |
| 19 | **ヘルスチェック未実装** | `/health` + `/ready` 必須 |
| 20 | **Raw Row直接返却** | DTO義務 |

### 55.5. AI・Agenticアンチパターン

| # | アンチパターン | 正しいアプローチ |
|:---|:---|:---|
| 21 | **AIエージェントに無制限APIアクセス** | Agent専用Scope・レート制限 |
| 22 | **MCPツール定義なしのAI統合** | OpenAPIからMCP Tool自動生成 |
| 23 | **HTTP/2のみでHTTP/3未対応** | QUIC/HTTP/3の段階的導入 |
| 24 | **API依存関係のSBOM未管理** | API Supply ChainのSBOM管理義務化 |
| 25 | **単一Gatewayでの全トラフィック処理** | K8s Gateway API・Multi-Gateway戦略 |

---

## Part LVI: Agentic API設計（MCP/A2A/ACP）

### 56.1. Agentic API哲学

- **Rule 35.81**: APIは「人間の開発者」だけでなく「AIエージェント」も第一級の利用者として設計する
- AIエージェントがAPIを自律的に発見・理解・呼び出しできる「Machine-Readable API」を義務付ける
- Agent Card（エージェント能力宣言）とTool Description（ツール説明）の標準化

### 56.2. MCP（Model Context Protocol）統合

- **Rule 35.82**: OpenAPI仕様から MCP Tool 定義を自動生成するパイプラインを構築する

```typescript
// OpenAPI → MCP Tool 変換例
const mcpTool = {
  name: 'get_store',
  description: 'Retrieve store details by ID. Returns store name, address, and operating hours.',
  inputSchema: {
    type: 'object',
    properties: {
      store_id: { type: 'string', description: 'Unique store identifier (e.g., store_001)' }
    },
    required: ['store_id']
  }
};
```

- 各パラメータに明確な `description` と `examples` を付与（AIの推論精度向上に直結）
- MCP Server のセキュリティ: 認証トークンのスコープ制限、ツール実行の監査ログ必須

### 56.3. A2A（Agent-to-Agent）プロトコル

- **Rule 35.83**: マルチエージェントシステムではA2Aプロトコル（Linux Foundation管理）に準拠する
- A2AはHTTP上で動作し、OpenAPI認証スキームを使用する
- Agent Card（`/.well-known/agent.json`）でエージェント能力を宣言する

| A2A機能 | 説明 |
|:---|:---|
| **Agent Discovery** | Agent Cardによるエージェント能力の発見 |
| **Task Delegation** | タスクの委任と結果の受け取り |
| **Status Streaming** | SSE/WebSocketによるタスク進捗ストリーミング |
| **Artifact Exchange** | エージェント間のファイル・データ交換 |

### 56.4. AI Gateway

- **Rule 35.84**: AI APIへのアクセスはAI Gatewayを経由し、コスト管理・レート制限・フォールバック・監査を一元管理する
- モデルRouter: レイテンシ・コスト・精度に基づくモデル自動選択
- トークン消費量の予算管理: サービス・チーム・顧客ごとの月次予算上限

### 56.5. Agentic APIの監査とガバナンス

- AIエージェントの全API呼び出しに `agent_id`、`session_id`、`tool_name` を含む監査ログを記録する
- 「意図しない大量操作」「権限昇格」を検知するアノマリー検出を実装する
- Kill Switch: AIエージェントの暴走時に即座にAPI呼び出しを遮断する機構を実装する

---

## Part LVII: HTTP/3 & QUIC移行

### 57.1. HTTP/3義務化ロードマップ

- **Rule 35.85**: 新規APIサービスはHTTP/3（QUIC）対応を義務付ける。既存サービスは段階的に移行する
- 2026年3月時点でHTTP/3のグローバル採用率は35%（Cloudflareデータ）。主要ブラウザ全てがネイティブ対応済み

### 57.2. HTTP/3の利点

| 利点 | 説明 |
|:---|:---|
| **HOL Blocking解消** | ストリーム単位の損失回復。TCP固有のHOL Blockingを排除 |
| **0-RTT接続** | 再接続時のレイテンシ排除 |
| **組み込みTLS 1.3** | プロトコルレベルでの暗号化義務化 |
| **マルチパス（実験的）** | 複数ネットワークパスの同時利用 |

### 57.3. gRPC over QUIC

- gRPCのHTTP/2依存をHTTP/3に移行し、パフォーマンスを更に向上する
- QUIC の UDP ベースにより、モバイル環境でのネットワーク切替時のコネクション維持が向上

### 57.4. 移行戦略

- **Phase 1**: CDN/Edge層でHTTP/3を有効化（ALTSVCヘッダーによるネゴシエーション）
- **Phase 2**: API Gateway層でHTTP/3を有効化
- **Phase 3**: サービス間通信をHTTP/3に移行
- HTTP/2との後方互換を維持し、クライアント対応状況に応じてプロトコルをネゴシエーションする

---

## Part LVIII: WebTransport設計

### 58.1. WebTransport概要

- **Rule 35.86**: リアルタイム双方向通信の新規実装にはWebTransportの採用を検討する（WebSocketの後継技術）
- HTTP/3（QUIC）上で動作し、ストリーム多重化とデータグラム送信を両立する

### 58.2. WebTransport vs WebSocket

| 観点 | WebSocket | WebTransport |
|:---|:---|:---|
| **プロトコル** | TCP上のフレームプロトコル | QUIC/HTTP/3上 |
| **HOL Blocking** | あり（TCP由来） | なし（QUIC由来） |
| **多重化** | 単一ストリーム | 複数ストリーム + データグラム |
| **暗号化** | 任意（wss推奨） | TLS 1.3必須 |
| **ブラウザ対応** | 全ブラウザ | Chrome/Edge/Firefox（Safari実験的） |

### 58.3. ユースケース

- ゲーム・リアルタイムコラボレーション（低レイテンシデータグラム）
- メディアストリーミング（順序不要のデータ配信）
- IoTデバイス通信（大量接続の効率的管理）

---

## Part LIX: API Supply Chain Security

### 59.1. API依存関係のSBOM

- **Rule 35.87**: 自社APIが依存する外部API（Stripe, OpenAI, Maps等）のインベントリを管理し、SBOM（Software Bill of Materials）に含める
- 各外部APIの障害影響範囲、SLO、契約条件を文書化する

### 59.2. サードパーティAPIリスク管理

| リスク | 対策 |
|:---|:---|
| **APIキー漏洩** | Vault管理、ローテーション自動化 |
| **Breaking Change** | Contract Testing、Changelog監視 |
| **サービス停止** | サーキットブレーカー、フォールバック |
| **料金変更** | FinOps予算アラート |
| **セキュリティ脆弱性** | 定期的なセキュリティ評価 |

### 59.3. 外部APIセキュリティ評価

- **Rule 35.88**: 新規外部API統合前にセキュリティ評価チェックリストを実施する
- SOC2/ISO 27001認証の確認、データ処理場所、暗号化ポリシー、インシデント通知手順を評価する

### 59.4. API Dependency Firewall

- サードパーティAPIからのレスポンスを信頼しない。入力バリデーション同様にレスポンスのスキーマ検証を実施する
- 不正なレスポンスの検知と隔離メカニズムを実装する

---

## Part LX: Kubernetes Gateway API

### 60.1. Ingress → Gateway API移行

- **Rule 35.89**: 新規Kubernetesクラスタではk8s Gateway APIを標準採用する。従来のIngress APIからの段階的移行を計画する
- Gateway APIはIngressの後継として、より表現力豊かなルーティング・トラフィック管理を提供する

### 60.2. Gateway API リソースモデル

| リソース | 説明 |
|:---|:---|
| **GatewayClass** | Gatewayの実装プロバイダ定義 |
| **Gateway** | リスナー（ポート・プロトコル）の定義 |
| **HTTPRoute** | HTTPルーティングルール |
| **GRPCRoute** | gRPCルーティングルール |
| **TLSRoute** | TLSパススルールーティング |

### 60.3. トラフィック分割

```yaml
# Gateway API によるカナリアリリース
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: store-api-canary
spec:
  parentRefs:
    - name: api-gateway
  rules:
    - backendRefs:
        - name: store-api-v1
          port: 8080
          weight: 90
        - name: store-api-v2
          port: 8080
          weight: 10
```

---

## Part LXI: AI駆動APIテスト

### 61.1. AI支援テスト生成

- **Rule 35.90**: OpenAPI仕様からAIを活用してテストケースを自動生成するパイプラインを構築する
- 正常系・異常系・エッジケース・セキュリティテストの自動生成
- Property-Based Testing のプロパティをAIが推論・提案する

### 61.2. Fuzz Testing自動化

- **Schemathesis**: OpenAPI/GraphQL仕様からファジングテストを自動生成・実行する
- 仕様書に記載のないエッジケースやクラッシングインプットを発見する

```bash
# Schemathesis による自動ファジング
schemathesis run https://api.example.com/openapi.json \
  --checks all \
  --hypothesis-max-examples 1000
```

### 61.3. AI駆動Contract Drift検出

- 本番トラフィックとOpenAPI仕様の乖離（Contract Drift）をAIで自動検出する
- 仕様に未定義のフィールドやステータスコードが返却された場合にアラートを発する

---

## Part LXII: API Governance深化

### 62.1. API Design Linting自動化

- **Rule 35.91**: OpenAPI仕様のLintをCIパイプラインに義務付ける。Spectral/Opticをデフォルトツールとする

```yaml
# Spectral ルールセット例
rules:
  operation-operationId: error
  operation-description: warn
  oas3-valid-media-example: error
  path-params: error
  no-eval-in-markdown: error
  typed-enum: warn
  # カスタムルール
  api-version-in-path:
    severity: error
    given: "$.paths.*~"
    then:
      function: pattern
      functionOptions:
        match: "^/api/v[0-9]+/"
```

### 62.2. APIスコアリング

| スコア項目 | 重み | 評価基準 |
|:---|:---|:---|
| **仕様完全性** | 25% | 全エンドポイントにdescription・examples |\
| **セキュリティ** | 30% | 認証定義・スコープ・レート制限 |
| **一貫性** | 20% | 命名規約・レスポンス構造の統一 |
| **ドキュメント** | 15% | Changelog・エラー仕様・サンプル |
| **テスト** | 10% | Contract Test・Breaking Change Gate |

### 62.3. API Review Board運用

- **Rule 35.92**: Breaking ChangeまたはAPI新規公開には、API Review Boardでの設計レビュー承認を義務付ける
- レビュー基準: セキュリティ・命名規約・バージョニング・SLO定義・ドキュメント品質

---

## Part LXIII: GraphQL 2025+拡張

### 63.1. Nullability RFC

- **Rule 35.93**: GraphQLスキーマにおけるNull/Non-Null設計を厳格化する
- 入力型はデフォルトNon-Null、出力型はネットワーク障害を考慮しNullable許容
- `@semanticNonNull` ディレクティブの採用を検討する

### 63.2. @oneOf Input Validation

- GraphQL `@oneOf` を活用し、入力型のユニオンバリデーション（排他的選択）を実装する
- 複数の入力パターンのうち1つだけが有効な場合の型安全な設計

### 63.3. Composite Schema

- 複数のGraphQL Subgraphを統合するComposite Schema仕様に準拠する
- Apollo Federation v2 / Composite Schema Specの最新動向を追跡する

### 63.4. GraphQL over HTTP仕様

- **Rule 35.94**: GraphQLのHTTPトランスポートは「GraphQL over HTTP」仕様に準拠する
- `GET`（Persisted Query）と `POST` の適切な使い分け
- `Accept: application/graphql-response+json` ヘッダーの使用

---

## Part LXIV: gRPC 2025+拡張

### 64.1. xDS API統合

- Service Mesh（Envoy/Istio）の xDS API を活用し、gRPCサービスの動的設定（ルーティング、負荷分散、認証）を管理する
- コントロールプレーンからのポリシー配信によりアプリケーションコードを変更せずにトラフィック管理を実現する

### 64.2. gRPC-Web改善

- **Rule 35.95**: ブラウザからのgRPC呼び出しにはgRPC-Webを使用する。Envoyプロキシでのプロトコル変換を推奨する
- HTTP/3上でのgRPC-Web動作の検証と最適化

### 64.3. Connect Protocol

- gRPCの代替として Connect Protocol（HTTP/1.1互換のgRPC）の採用を検討する
- ブラウザ直接呼び出し、デバッグ容易性、cURLテスト可能性を重視する場合に有効

### 64.4. gRPC負荷分散

| 方式 | 説明 | 推奨ケース |
|:---|:---|:---|
| **Proxy-based** | L7プロキシ（Envoy等）による分散 | 一般推奨 |
| **Client-side** | クライアントが直接バックエンドを選択 | 低レイテンシ要求 |
| **Look-aside** | 外部ロードバランサーが負荷情報を提供 | 大規模クラスタ |

---

## Part LXV: API Evolution Strategy

### 65.1. Stripe型バージョニング

- **Rule 35.96**: Stripeに倣い、各APIリクエストに `Stripe-Version` （自社では `API-Version`）ヘッダーを含め、クライアントごとに異なるバージョンのレスポンスを提供する
- サーバー側で全バージョンの変換ロジックを保持し、クライアントのペースでの段階的移行を可能にする

### 65.2. API Changelog自動化

- OpenAPIの差分検出（`oasdiff`）をCIに統合し、Changelogを自動生成する
- Breaking/Non-Breaking/Deprecation を自動分類する

### 65.3. Consumer-Aware Deprecation

- **Rule 35.97**: 非推奨APIの利用者をASN/APIキー単位で追跡し、個別に移行ガイダンスを提供する
- 利用者ゼロになるまで廃止しない原則を厳守する

---

## Part LXVI: Multi-Cloud API管理

### 66.1. 統一コントロールプレーン

- **Rule 35.98**: マルチクラウド環境では統一のAPI管理コントロールプレーンを導入し、クラウド間で一貫したポリシー（認証・レート制限・可観測性）を適用する
- GitOps方式で設定をバージョン管理し、ドリフトを防止する

### 66.2. クロスクラウドAPI一貫性

| 項目 | 要件 |
|:---|:---|
| **認証** | 全クラウドで同一の認証基盤（OAuth 2.1） |
| **レート制限** | 分散レート制限（グローバルカウンター） |
| **可観測性** | OpenTelemetryによるクラウド横断トレーシング |
| **ドキュメント** | 統一Developer Portal |

### 66.3. データレジデンシー対応

- API Gateway層でリクエスト元のリージョンを判定し、データレジデンシー要件に基づき適切なバックエンドにルーティングする
- GDPRリージョン（EU）のデータがEU外に流出しないことを物理的に保証する

---

## Part LXVII: Edge-Native API

### 67.1. Edge Computing上のAPI実行

- **Rule 35.99**: レイテンシ要件の厳格なAPIはEdge Worker/Edge Function上で実行する
- Cloudflare Workers、Deno Deploy、Vercel Edge Functions等を活用する

### 67.2. Edge API設計原則

| 原則 | 説明 |
|:---|:---|
| **ステートレス** | Edge Workerにローカル状態を持たない |
| **キャッシュファースト** | Edge KVやR2でのデータローカリゼーション |
| **フォールバック** | Edgeダウン時のOriginフォールバック設計 |
| **サイズ制限** | バンドルサイズの最小化（V8 Isolateの制約） |

### 67.3. Edge API Gateway

- Edge上でのJWT検証・レート制限・GeoIPルーティングを実装し、Originへの不要なリクエストを排除する
- Edge→Origin間の通信にmTLSを義務付ける

---

## Part LXVIII: API Marketplace & Ecosystem

### 68.1. API Marketplace構築

- **Rule 35.100**: API収益化を目指す場合、Developer Portal を核とした API Marketplace を設計する
- API検索・試用・契約・課金のセルフサービスフローを提供する

### 68.2. パートナーエコシステム

| 層 | 説明 | 要件 |
|:---|:---|:---|
| **Public** | 誰でもアクセス可能 | API Key + Free Tier |
| **Partner** | 審査済みパートナー | 契約 + 専用Support |
| **Enterprise** | 大規模顧客 | カスタムSLA + 専用インスタンス |

### 68.3. Stripe Metering連携

- API呼び出し回数に基づくUsage-Based Billing（従量課金）をStripe Meteringで実装する
- Tier別の無料枠・超過料金・ボリュームディスカウントを設計する

---

## Part LXIX: Green API / サステナビリティ

### 69.1. APIのカーボンフットプリント

- **Rule 35.101**: API呼び出しのカーボンフットプリントを計測・可視化する
- SCI（Software Carbon Intensity）スコアの追跡
- レスポンスヘッダー `X-Carbon-Intensity: low/medium/high` の付与を検討する

### 69.2. 効率的API設計

| 施策 | 効果 |
|:---|:---|
| **ペイロード最適化** | 転送データ量削減 → ネットワークエネルギー削減 |
| **キャッシュ最大化** | 不要なOriginリクエスト削減 → サーバー電力削減 |
| **Batch API** | リクエスト数削減 → ラウンドトリップ削減 |
| **Edge実行** | データ移動距離短縮 → ネットワークエネルギー削減 |
| **HTTP/3** | ハンドシェイク削減により接続確立エネルギー削減 |

### 69.3. Green SLA

- SLO目標にカーボン効率指標を追加する（例: API呼び出し1万回あたりのCO2排出量）
- 低カーボンリージョンへのトラフィック優先ルーティングを検討する

---

## Part LXX: 将来展望

### 70.1. 技術トレンドロードマップ

| 時期 | 技術 | API への影響 |
|:---|:---|:---|
| **2025-2026** | HTTP/3普及・MCP/A2A標準化 | AI Agent対応API設計が必須化 |
| **2026-2027** | OpenAPI 4.0（Moonwalk） | 仕様表現力の拡張、AI駆動の仕様生成 |
| **2027-2028** | Quantum-Safe暗号 | TLS 1.3 + PQC（Post-Quantum Cryptography）への移行 |
| **2028+** | Autonomous API Management | AIによるAPI設計・テスト・デプロイの完全自動化 |

### 70.2. WebAssembly（Wasm）API

- Wasm上でのAPIロジック実行によるポータブルな計算環境の実現
- WASI（WebAssembly System Interface）を活用したサーバーレスAPIの多言語対応

### 70.3. Digital Twin API

- 物理システムのデジタルツインへのAPIアクセス
- IoTデバイスとの双方向通信プロトコル標準化

### 70.4. Autonomous API Lifecycle

- AI/MLによるAPI設計提案→自動テスト→Progressive Delivery→SLO監視→自動最適化の完全自動化パイプライン
- 「Human-in-the-Loop」から「Human-on-the-Loop」への移行

---

## Appendix A: 逆引き索引

| キーワード | 参照先 |
|:---|:---|
| A2A Protocol | Part LVI (§56.3) |
| AI Agent Security | Part XXVI (§26.3) |
| AI Gateway | Part LVI (§56.4) |
| AI Testing | Part LXI |
| API-First | Part II (§2.1) |
| API Marketplace | Part LXVIII |
| API Scoring | Part LXII (§62.2) |
| API Supply Chain | Part LIX |
| AsyncAPI | Part XVI (§16.1) |
| Authentication / OAuth 2.1 | Part XXVII (§27.1) |
| Batch API | Part XXXV (§35.4) |
| BFF | Part XX |
| Breaking Change | Part VI (§6.2), Part XLII (§42.3), Part LXV |
| Bulkhead | Part XXI (§21.3) |
| Cache / ETag | Part XXXIV |
| Carbon Footprint | Part LXIX |
| CDC (Change Data Capture) | Part XLVIII (§48.3) |
| Cell-Based Architecture | Part XXXVI (§36.2) |
| Circuit Breaker | Part XXI (§21.1) |
| Connect Protocol | Part LXIV (§64.3) |
| Contract Testing | Part XLII |
| CORS | Part XXX |
| CQRS | Part XV (§15.1) |
| DataLoader | Part XI (§11.2) |
| Deprecation | Part VI (§6.3), Part LXV (§65.3) |
| DPoP | Part XXVII (§27.2) |
| DTO | Part VII (§7.1), Part XXXI |
| Edge-Native API | Part LXVII |
| Error Budget | Part XXIV (§24.3) |
| Event-Driven | Part XV |
| FIDO2 / Passkeys | Part XXVII (§27.3) |
| FinOps | Part XLV |
| Fuzz Testing | Part LXI (§61.2) |
| Gateway | Part XVIII |
| Gateway API (K8s) | Part LX |
| Golden Signals | Part XXXVII (§37.3) |
| Graceful Degradation | Part XXV |
| GraphQL | Part IX〜XI, Part LXIII |
| GraphQL over HTTP | Part LXIII (§63.4) |
| Green API | Part LXIX |
| gRPC | Part XII〜XIV, Part LXIV |
| gRPC-Web | Part LXIV (§64.2) |
| Health Check | Part XXXIX |
| HTTP/3 / QUIC | Part LVII |
| Idempotency | Part XXII |
| LLM Function Calling | Part L (§50.2) |
| MCP (Model Context Protocol) | Part LVI (§56.2) |
| Metering | Part XLIV |
| Microservices | Part XLVI〜XLVIII |
| mTLS | Part XIX (§19.2) |
| Multi-Cloud | Part LXVI |
| OpenAPI | Part II (§2.2), Part XL |
| OpenTelemetry | Part XXXVII (§37.1) |
| Outbox Pattern | Part XV (§15.4), Part XLVIII (§48.2) |
| OWASP API Top 10 | Part XXVI (§26.2) |
| OWASP Top 10:2025 | Part XXVI (§26.2) |
| Pagination | Part V (§5.2) |
| PCI DSS | Part LIII (§53.2) |
| PII Masking | Part VII (§7.3), Part XXXVIII (§38.3) |
| Progressive Delivery | Part LII (§52.2) |
| Protocol Buffers | Part XIV |
| Rate Limiting | Part XXIII |
| RFC 7807 | Part VIII |
| Saga Pattern | Part XV (§15.3), Part XLVIII (§48.1) |
| SBOM (API) | Part LIX (§59.1) |
| Schemathesis | Part LXI (§61.2) |
| Server Action | Part XXXIII |
| Service Mesh | Part XIX |
| SLI / SLO | Part XXIV |
| Spectral | Part LXII (§62.1) |
| SSRF | Part XXIX (§29.4) |
| Stale-While-Revalidate | Part XXXIV (§34.2) |
| Stateless Gateway | Part XXXVI (§36.1) |
| Stripe Versioning | Part LXV (§65.1) |
| Versioning | Part VI |
| Wasm API | Part LXX (§70.2) |
| Webhook | Part XVII |
| WebTransport | Part LVIII |
| xDS API | Part LXIV (§64.1) |
| Zero Trust | Part XXVI (§26.1) |

---

## Appendix B: クロスリファレンス

| 参照先ルールファイル | 関連トピック |
|:---|:---|
| `300_engineering_standards.md` | コーディング規約・テスト戦略 |
| `340_web_frontend.md` | フロントエンドからのAPI呼び出しパターン |
| `343_native_platforms.md` | モバイルアプリのAPI統合 |
| `320_supabase_architecture.md` | Supabase RPC / Edge Functions / RLS |
| `361_aws_cloud.md` | AWS API Gateway / Lambda / SQS |
| `400_ai_engineering.md` | AI API統合・LLM統合・MCP/A2Aパターン |
| `401_data_analytics.md` | API使用量分析・FinOps・OTel統合 |
| `500_internal_tools.md` | 管理者API・内部ツール・Agentic Admin |
| `502_site_reliability.md` | SLO/SLI・インシデント管理・可観測性 |
| `600_security_privacy.md` | 認証認可・CORS・PII保護・Zero Trust・OWASP |
| `601_data_governance.md` | GDPR・データ越境・規制コンプライアンス |
| `602_oss_compliance.md` | SBOM・Supply Chain Security・依存関係管理 |
| `700_qa_testing.md` | テスト戦略・Contract Testing・Fuzz Testing |


