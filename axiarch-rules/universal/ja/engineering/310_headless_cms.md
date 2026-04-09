# 34. コンテンツ管理システム (CMS — Headless)

> [!CAUTION]
> **このファイルは Universal Rule（不変ルール）です。「憲法改正」の明示的指示がない限り編集禁止。**
> 改定日: 2026-03-24

> [!IMPORTANT]
> **Supreme Directive（最高指令）**
> 「コンテンツはデータであり、表示ではない。配信チャネルから独立した構造化コンテンツこそがデジタル資産の本質である。」
> CMS実装において、**コンテンツ構造 > 配信柔軟性 > 運用効率 > パフォーマンス > DX** の優先順位を厳守せよ。
> この文書はCMS関連のすべての設計判断の最上位基準である。
> **31パート・80セクション構成。**

---

## 目次

- Part I: Supreme Directive & CMS哲学
- Part II: ヘッドレスアーキテクチャ原則
- Part III: CMS選定戦略 & Composable DXP
- Part IV: コンテンツモデリング基礎
- Part V: 構造化コンテンツ設計
- Part VI: コンテンツタイプ & フィールド設計
- Part VII: コンテンツ関係性 & 参照設計
- Part VIII: Content Delivery API設計
- Part IX: GraphQL APIガバナンス
- Part X: Content Management API & Webhooks
- Part XI: メディアストレージ戦略
- Part XII: 画像最適化 & 配信パイプライン
- Part XIII: UGCメディア管理 & 動画戦略
- Part XIV: DAM（Digital Asset Management）統合
- Part XV: レンダリング戦略（SSG/ISR/SSR）
- Part XVI: CDN & エッジ配信
- Part XVII: キャッシュ階層戦略
- Part XVIII: リッチテキストエディタガバナンス
- Part XIX: Triple Write Protocol & データ整合性
- Part XX: エディタ拡張 & NodeView設計
- Part XXI: パブリッシングワークフロー
- Part XXII: 承認ゲート & ステータス遷移
- Part XXIII: スケジューリング & 予約公開
- Part XXIV: リビジョン管理 & 監査証跡
- Part XXV: プレビュー戦略
- Part XXVI: Dual Mode Fetching
- Part XXVII: Soft 404 & HTTPステータスコード
- Part XXVIII: ハイブリッドレイアウト設計（Content vs Layout）
- Part XXIX: Dynamic Page Builder & Component Registry
- Part XXX: SEO自動化 & メタデータ管理
- Part XXXI: 構造化データ & Schema.org
- Part XXXII: AI-Ready Content Protocol
- Part XXXIII: AI搭載コンテンツ運用
- Part XXXIV: AI生成コンテンツガバナンス
- Part XXXV: Agentic CMS & AI自律コンテンツ管理
- Part XXXVI: CMSセキュリティアーキテクチャ（OWASP 2025対応）
- Part XXXVII: コンテンツサプライチェーンセキュリティ
- Part XXXVIII: コンテンツモデレーション & Trust & Safety
- Part XXXIX: コンテンツアクセシビリティ（WCAG 2.2/EAA）
- Part XL: 多言語コンテンツ管理 & 翻訳ワークフロー
- Part XLI: コンテンツパーソナライゼーション
- Part XLII: コンテンツガバナンス & ライフサイクル管理
- Part XLIII: コンテンツバージョニング & Content as Code
- Part XLIV: CMS移行戦略 & ベンダー切替
- Part XLV: コンテンツフェデレーション & マルチソース
- Part XLVI: リアルタイムコラボレーション
- Part XLVII: コンテンツ実験 & A/Bテスト
- Part XLVIII: サーバードリブンUI & Remote Config
- Part XLIX: エディタ体験（Editor Experience / EX）
- Part L: CMSテスト戦略
- Part LI: コンテンツパイプライン自動化
- Part LII: マルチテナントCMS
- Part LIII: CMS災害復旧 & バックアップ
- Part LIV: CMS規制コンプライアンス（DORA/EU AI Act/DSA）
- Part LV: GEO（Generative Engine Optimization）対応
- Part LVI: CMS Green IT & サステナビリティ
- Part LVII: CMS可観測性 & FinOps
- Part LVIII: 成熟度モデル（5段階）
- Part LIX: アンチパターン集（35選）
- Part LX: 将来展望 & CMS実装チェックリスト
- Part LXI: C2PA コンテンツ出自証明 & Content Credentials
- Part LXII: AI-Native Visual Editor & No-Code Content Modeling
- Part LXIII: Content Ops & コンテンツ運用チーム
- Part LXIV: Headless Commerce統合
- Part LXV: Edge-Native CMS & Edge配信アーキテクチャ
- Part LXVI: Content Intelligence & コンテンツ分析
- Part LXVII: Content Graph & Knowledge Graph
- Part LXVIII: Event-Driven Content Architecture
- Part LXIX: Content Localization 深化（MTPE / MQM）
- Part LXX: Content Design System & トークン管理
- Part LXXI: CMSパフォーマンスバジェット & Core Web Vitals
- Part LXXII: 構造化コンテンツ移行 & ETLパイプライン
- Part LXXIII: CMS SDK & 開発者体験（DX）
- Part LXXIV: モバイルアプリ向けHeadless CMS（App Content）
- Part LXXV: Webhookオーケストレーション & Sagaパターン深化
- Part LXXVI: コンテンツコンプライアンス自動化（PII/GDPR/DSA）
- Part LXXVII: CMS APIレートリミット & クォータ管理
- Part LXXVIII: CDN深化（Stale-While-Revalidate / ESI）
- Part LXXIX: CMS Monorepo & マルチサイトアーキテクチャ
- Part LXXX: CMS開発者ポータル & APIドキュメント
- Appendix A: 逆引き索引
- Appendix B: クロスリファレンス

---

## Part I: Supreme Directive & CMS哲学

### 1.1. CMS実装の最高原則

- **Rule 34.1**: コンテンツは「表示」から分離された「純粋なデータ」として管理しなければならない。コンテンツ層への表示ロジックの混入は禁止
- **Rule 34.2**: すべてのコンテンツはAPI経由で取得可能でなければならない（API-First Mandate）
- **Rule 34.3**: CMSの障害がフロントエンド全体を停止させてはならない（Graceful Degradation必須）

### 1.2. CMS実装の優先順位階層

| 優先度 | 領域 | 説明 |
|:---|:---|:---|
| **P0** | コンテンツ構造化 | 意味ベースモデリング、再利用性、機械可読性 |
| **P1** | 配信柔軟性 | オムニチャネル、API-First、AI-Ready |
| **P2** | 運用効率 | 承認ワークフロー、プレビュー、スケジューリング |
| **P3** | パフォーマンス | CDN、キャッシュ、Core Web Vitals |
| **P4** | DX | 開発速度、SDK、型安全性 |

### 1.3. Content First ≠ CMS First

- **Rule 34.4**: CMSは「コンテンツ管理ツール」であり「アプリケーションフレームワーク」ではない。CMSにビジネスロジックを埋め込むことは禁止
- CMSは多数のデータソースの一つとして扱い、アプリケーションロジックはフロントエンド/バックエンドに帰属させる

---

## Part II: ヘッドレスアーキテクチャ原則

### 2.1. Content as Data

- **Rule 34.5**: すべてのコンテンツ取得はAPIベースとし、Web、モバイルアプリ、IoTデバイス、AIエージェント等あらゆるチャネルへの配信を可能にする
- フロントエンドとバックエンドの**物理的分離**を義務付ける
- CMSテンプレートエンジンやサーバーサイドレンダリング機能に依存した実装は禁止

### 2.2. アーキテクチャパターン

| パターン | 説明 | 推奨ケース |
|:---|:---|:---|
| **Pure Headless** | APIのみのCMS + 独立フロントエンド | 新規プロジェクト、SPA/SSR |
| **Decoupled** | CMS管理画面 + API配信 | 既存CMS移行 |
| **Hybrid Headless** | 一部ページCMS描画 + API配信 | 段階的移行期間 |

- **Rule 34.6**: 新規プロジェクトでは**Pure Headless**を標準とする。Hybrid Headlessは移行期間のみ許可し、完了時にPure Headlessへ統合する

### 2.3. フロントエンドとCMSの責務境界

```
┌─────────────────────────────────────────────┐
│  Headless CMS（Content Backend）            │
│  ├── コンテンツモデリング                   │
│  ├── コンテンツ編集・管理                   │
│  ├── メディアアセット管理                   │
│  ├── APIエンドポイント提供                  │
│  └── Webhook通知                            │
├─────────────────────────────────────────────┤
│  アプリケーション層（Frontend/Backend）     │
│  ├── レンダリング（SSG/ISR/SSR）            │
│  ├── ルーティング                           │
│  ├── ビジネスロジック                       │
│  ├── 認証・認可                             │
│  ├── キャッシュ制御                         │
│  └── パフォーマンス最適化                   │
└─────────────────────────────────────────────┘
```

---

## Part III: CMS選定戦略 & Composable DXP

### 3.1. CMS選定基準

| 基準 | 評価項目 | 重み |
|:---|:---|:---|
| **API品質** | REST/GraphQL対応、レートリミット、SDK型安全性 | 最高 |
| **コンテンツモデリング** | カスタムタイプ、リレーション、バリデーション | 最高 |
| **開発者体験** | SDK、CLI、Webhooks、Preview API | 高 |
| **スケーラビリティ** | CDN統合、グローバル配信、SLA | 高 |
| **コスト** | 入稿席数、APIコール量、ストレージ | 中 |
| **ベンダーロックイン** | データエクスポート、移行容易性 | 高 |
| **AI統合** | AI支援機能、MCP統合、RAGソース品質 | 高 |

### 3.2. CMS分類 & 推奨

| カテゴリ | 例 | 推奨ケース |
|:---|:---|:---|
| **SaaS Headless CMS** | Contentful, Sanity, Hygraph | グローバル配信、エンタープライズ |
| **日本特化SaaS** | MicroCMS, Newt | 日本市場、中小規模 |
| **OSS Headless CMS** | Strapi, Payload CMS, Directus | セルフホスト、カスタマイズ重視 |
| **Git-Based CMS** | Decap CMS, Tina CMS | 開発者ブログ、ドキュメンテーション |

- **Rule 34.7**: WordPressを使用する場合は**Headless Mode（WPGraphQL）** での運用を義務付け、フロントエンド（Next.js等）と完全分離する。PHPテーマ開発は禁止

### 3.3. Composable DXPアーキテクチャ

- **Rule 34.8**: モノリシックCMSではなく、Best-of-Breedサービスを組み合わせた**Composable DXP**を推奨

```
Composable DXP Stack:
├── Content:      Headless CMS (Contentful / Sanity / MicroCMS)
├── Commerce:     Headless Commerce (Shopify Storefront API)
├── Search:       Search Service (Algolia / Meilisearch)
├── Media:        DAM (Cloudinary / imgix)
├── Personalization: CDP + Personalization Engine
├── Analytics:    Analytics Platform (GA4 / Amplitude)
├── AI:           AI Platform (Gemini / OpenAI / Claude)
└── Frontend:     Meta Framework (Next.js / Nuxt / Astro)
```

### 3.4. ベンダーロックイン回避

- **Rule 34.9**: CMS固有のSDKやデータ形式に直接依存せず、抽象化レイヤーを介してアクセスする
- **データポータビリティ**: JSON/CSVコンテンツエクスポート機能はCMS選定の必須条件とする
- **Content Abstraction Layer**: CMSとフロントエンド間にアダプターパターンを導入し、CMS移行時のフロントエンド変更を最小化する

### 3.5. MACH Alliance認証基準

- **Rule 34.85**: エンタープライズCMS選定時はMACH Alliance（Microservices, API-first, Cloud-native, Headless）認証を評価基準に含める

| MACH原則 | 評価ポイント |
|:---|:---|
| **Microservices** | 機能モジュールが独立デプロイ・スケール可能か |
| **API-first** | すべての機能がAPIで公開されているか |
| **Cloud-native** | SaaS / マルチテナント / 自動スケーリングか |
| **Headless** | フロントエンドとバックエンドが物理的に分離されているか |

- **Orchestration Layer**: Composable DXPの各サービスを統合するオーケストレーション層（API Gateway / BFF）を設計し、サービス間の結合度を最小化する
- **API Composition**: 複数マイクロサービスのレスポンスを単一リクエストで集約するAPI Compositionパターンを実装し、フロントエンドからの過剰なAPI呼び出しを防止する

---

## Part IV: コンテンツモデリング基礎

### 4.1. Content Modeling First原則

- **Rule 34.10**: コードを書く前にコンテンツモデルを設計する（Design First, Implement Second）
- コンテンツモデルは**表示**ではなく**意味**に基づいて設計する
- 開発者、編集者、UXデザイナーの共同ワークショップで共同設計する

### 4.2. コンテンツモデリング5原則

| # | 原則 | 説明 |
|:---|:---|:---|
| 1 | **意味ベース設計** | 「見た目」ではなく「意味」でフィールドを定義する |
| 2 | **再利用性** | 複数チャネルでのコンテンツ再利用を可能にする |
| 3 | **原子性** | コンテンツを最小の再利用可能な単位に分解する |
| 4 | **関係性** | コンテンツ間の参照をリレーションで明示する |
| 5 | **拡張性** | 将来の要件変更に最小限の影響で対応できる設計 |

### 4.3. アンチパターン: 表示駆動モデリング

```
// ❌ 禁止: 表示依存のモデリング
{
  "heroTitle": "...",        // 「ヒーローセクション用タイトル」
  "sidebarText": "...",      // 「サイドバー用テキスト」
  "mobileDescription": "..." // 「モバイル用説明文」
}

// ✅ 正解: 意味ベースモデリング
{
  "title": "...",            // 「タイトル」
  "summary": "...",          // 「要約」
  "body": "...",             // 「本文」
  "category": "ref:...",     // 「カテゴリ参照」
}
```

---

## Part V: 構造化コンテンツ設計

### 5.1. 構造化コンテンツ義務

- **Rule 34.11**: すべてのコンテンツは**構造化データ**として定義する。非構造化HTMLブロブの直接保存は禁止
- 構造化コンテンツはAI処理、検索、フィルタリング、多言語化、パーソナライゼーションを可能にする

### 5.2. フィールドタイプ戦略

| フィールドタイプ | 用途 | 設計指針 |
|:---|:---|:---|
| **Text (Short)** | タイトル、ラベル | 最大文字数定義、プレーンテキスト |
| **Rich Text** | 本文、説明文 | 許可要素制限、Triple Write |
| **Number** | 価格、並び順 | 整数/小数の区別、最小最大値 |
| **Boolean** | フラグ | デフォルト値を必ず定義 |
| **Date/DateTime** | 公開日、イベント日 | UTC保存、タイムゾーン表示 |
| **Reference** | 他コンテンツへの参照 | 参照先タイプを制限する |
| **Media** | 画像、動画 | メディアライブラリ経由 |
| **JSON** | 構造化メタデータ | JSON Schemaバリデーション |
| **Enum** | ステータス、カテゴリ | 定義済み値のみ |
| **Slug** | URL安全文字列 | ユニーク制約、自動生成 |

### 5.3. コンテンツスキーマ定義義務

- **Rule 34.12**: すべてのコンテンツタイプにスキーマ定義（フィールド名、型、必須/任意、バリデーションルール、デフォルト値）を義務付ける

```typescript
// コンテンツスキーマ定義例
const ArticleSchema = {
  title:       { type: 'text', required: true, maxLength: 100 },
  slug:        { type: 'slug', required: true, unique: true, source: 'title' },
  summary:     { type: 'text', required: true, maxLength: 300 },
  body:        { type: 'richtext', required: true },
  body_html:   { type: 'text', generated: true },  // Triple Write
  body_text:   { type: 'text', generated: true },  // Triple Write
  category:    { type: 'reference', to: 'Category', required: true },
  tags:        { type: 'reference[]', to: 'Tag' },
  author:      { type: 'reference', to: 'Author', required: true },
  thumbnail:   { type: 'media', required: true },
  status:      { type: 'enum', values: ['draft','pending','published','archived'], default: 'draft' },
  published_at: { type: 'datetime' },
  meta_title:  { type: 'text', maxLength: 60 },
  meta_description: { type: 'text', maxLength: 160 },
  is_ai_generated: { type: 'boolean', default: false },
};
```

---

## Part VI: コンテンツタイプ & フィールド設計

### 6.1. コンテンツタイプ分類

| 分類 | 説明 | 例 |
|:---|:---|:---|
| **Document Type** | 独立したコンテンツ単位 | 記事、商品、イベント |
| **Component Type** | 再利用可能パーツ | CTAブロック、FAQアイテム、引用 |
| **Settings Type** | グローバル設定 | サイト設定、ナビゲーション |
| **Taxonomy Type** | 分類体系 | カテゴリ、タグ、地域 |

### 6.2. 命名規則

- **Rule 34.13**: コンテンツタイプ名は**PascalCase**、フィールド名は**camelCase**または**snake_case**（プロジェクト内で統一）
- APIレスポンスのフィールド名と一致させ、マッピングのずれを防止する
- `data`, `info`, `content` 等の曖昧な名称は禁止

### 6.3. フィールド設計原則

- **最小フィールド原則**: 「念のため」のフィールド追加は禁止。YAGNI適用
- **必須フィールド制限**: 公開に真に必要なフィールドのみをrequiredとする。過剰な必須はエディタ体験を悪化させる
- **デフォルト値義務**: すべてのオプションフィールドにデフォルト値を定義し、null状態を最小化する

---

## Part VII: コンテンツ関係性 & 参照設計

### 7.1. 参照パターン

| パターン | 説明 | 用途 |
|:---|:---|:---|
| **1:1 参照** | 単一参照 | 記事 → 著者 |
| **1:N 参照** | 複数参照 | 記事 → タグ[] |
| **Embedded** | インライン埋め込み | 記事内CTAブロック |
| **Bidirectional** | 双方向参照 | 記事 ↔ 関連記事 |

### 7.2. 参照整合性

- **Rule 34.14**: 参照先コンテンツ削除時の**ダングリングリファレンス**防止メカニズムを実装する
  - **Option A**: 参照されているコンテンツの削除をブロック（制約違反通知）
  - **Option B**: 参照フィールドをnull化 + 管理者通知
  - フロントエンドは参照切れに対してGraceful Degradation（非表示またはフォールバック）で対応する

### 7.3. 循環参照防止

- **Rule 34.15**: コンテンツ参照のN段を超える深いネスト（A → B → C → A）を自動検出し警告を表示する
- API取得時の参照解決深度を最大3レベルに制限し、無限ループを物理的に防止する

---

## Part VIII: Content Delivery API設計

### 8.1. API設計原則

- **Rule 34.16**: Content Delivery APIは**読み取り専用**、認証不要（Public API）、高速レスポンスとする
- **レスポンス形式**: JSON APIが標準。XMLレスポンスは非推奨

### 8.2. エンドポイント設計

```
Content Delivery API:
GET /api/content/{type}           → コンテンツ一覧（ページネーション必須）
GET /api/content/{type}/{slug}    → 個別コンテンツ
GET /api/content/{type}/{slug}/revisions → リビジョン一覧
```

### 8.3. クエリパラメータ標準

| パラメータ | 目的 | 例 |
|:---|:---|:---|
| `fields` | フィールド選択 | `?fields=title,slug,thumbnail` |
| `filter` | 条件フィルタ | `?filter[status]=published` |
| `sort` | ソート | `?sort=-published_at` |
| `limit` / `offset` | ページネーション | `?limit=20&offset=0` |
| `include` | 参照展開 | `?include=author,category` |
| `locale` | 言語指定 | `?locale=ja` |

### 8.4. ページネーション義務

- **Rule 34.17**: 一覧APIには必ずページネーションを実装する。全件返却エンドポイントの作成は禁止
- **Cursor-Based**推奨（大規模データでのパフォーマンス優位）
- レスポンスに`total`, `hasNextPage`, `nextCursor`を含める

### 8.5. レスポンス設計

```typescript
// 標準レスポンス構造
interface ContentListResponse<T> {
  data: T[];
  meta: {
    total: number;
    limit: number;
    offset: number;
    hasNextPage: boolean;
    nextCursor?: string;
  };
}
```

---

## Part IX: GraphQL APIガバナンス

### 9.1. GraphQL採用基準

- **Rule 34.18**: GraphQLはコンテンツ関係性が複雑なプロジェクトで推奨。単純なコンテンツ取得にはREST APIで十分
- **Schema-First**: GraphQLスキーマを先に定義し、実装はスキーマに従う

### 9.2. GraphQLセキュリティ義務

| 対策 | 説明 | 基準値 |
|:---|:---|:---|
| **Query Depth Limit** | ネスト深度制限 | 最大5レベル |
| **Query Complexity Limit** | クエリ複雑度上限 | ポイント制（例: 1000点上限） |
| **Rate Limiting** | リクエスト頻度制御 | 100 req/min/client |
| **Introspection制御** | 本番でのスキーマ露出 | 本番環境で**無効化** |
| **Persisted Queries** | 事前登録クエリのみ許可 | 本番環境推奨 |

### 9.3. N+1問題防止

- **Rule 34.19**: GraphQLリゾルバでのN+1クエリ問題を防止するため、DataLoader（バッチローディング）の使用を義務付ける
- Apollo Server / graphql-yoga等のフレームワーク標準機能を活用する

### 9.4. GraphQL Federation

- **Rule 34.20**: 複数CMSまたはデータソースを統合する場合、GraphQL Federation（Apollo Federation / GraphQL Mesh）を採用し、単一エンドポイントから統合スキーマを提供する
- サブグラフの独立デプロイと型安全な合成を保証する

---

## Part X: Content Management API & Webhooks

### 10.1. Management API設計

- **Rule 34.21**: Content Management APIは**認証必須**（Bearer Token / API Key）とし、管理画面やCI/CDパイプラインからのコンテンツ操作に使用する
- **RBAC**: APIの操作権限もユーザーロールに基づいて制御する

### 10.2. Webhook設計

- **Rule 34.22**: コンテンツの作成・更新・公開・削除イベントに対するWebhook通知を標準実装する

| イベント | 用途 | 推奨アクション |
|:---|:---|:---|
| `content.published` | 公開通知 | ISR revalidation、検索インデックス更新 |
| `content.updated` | 更新通知 | キャッシュ無効化 |
| `content.deleted` | 削除通知 | キャッシュ削除、リダイレクト設定 |
| `media.uploaded` | メディアアップロード | 画像最適化パイプライン起動 |

### 10.3. Webhook信頼性

- **Rule 34.23**: Webhookリクエストには改ざん防止のため**HMAC署名検証**を義務付ける
- **リトライポリシー**: 失敗時は指数バックオフでリトライ（最大5回）
- **冪等キー**: イベントIDによる冪等性を保証し、同一イベントの重複処理を防止する

### 10.4. CloudEvents規格準拠

- **Rule 34.86**: CMS Webhookイベントは**CloudEvents仕様（v1.0.2+）** に準拠したペイロード構造を推奨する

```json
{
  "specversion": "1.0",
  "type": "cms.content.published",
  "source": "/cms/articles",
  "id": "evt_abc123",
  "time": "2026-03-22T12:00:00Z",
  "datacontenttype": "application/json",
  "data": { "slug": "spring-campaign", "locale": "ja" }
}
```

- **相互運用性**: CloudEvents準拠により、他のマイクロサービス（検索、分析、通知）との統合をプロトコル互換で実現する
- **Dead Letter Queue**: 処理失敗イベントはDLQに保存し、後続の再処理を保証する

---

## Part XI: メディアストレージ戦略

### 11.1. 統合メディアライブラリ

- **Rule 34.24**: すべてのメディアアセット（コンテンツ画像、ロゴ、アイコン）は`public/`フォルダではなく、**統合メディアライブラリ**（Cloud Storage / S3 / Cloudinary）で管理する
- 管理画面からすべてのアセットを制御可能にする

### 11.2. セマンティックフォルダ構成

- **Rule 34.25**: `category/YYYY/MM/slug/` 等の意味ある階層的フォルダ構成を義務付ける

```
media/
├── articles/2026/03/spring-campaign/
│   ├── hero.webp
│   └── thumbnail.webp
├── products/electronics/laptop-x1/
│   └── main.webp
└── system/
    ├── logo.svg
    └── no-image.webp
```

- ランダムID（UUID等）のみのフォルダ名は禁止
- 同一フォルダ内のファイル名重複は上書き防止のため禁止

### 11.3. 管理アセット vs ユーザーアセットの分離

- **Rule 34.26**: 「システムアセット（管理者管理）」と「UGC（ユーザーアップロード）」は**バケットまたはルートフォルダレベルで物理的に分離**する

| 分類 | パス | 管理方法 |
|:---|:---|:---|
| **公式アセット** | `admin/media/` | メディアライブラリモーダル経由のみ |
| **ユーザーアセット** | `users/{uid}/` | ユーザー設定画面から直接アップロード |

### 11.4. The Original Preservation Protocol

- **Law**: 管理者がアップロードした画像は「マスターデータ」である。サーバーサイドでの圧縮や破壊的変換は一切禁止
- **Action**: すべての最適化（WebP/AVIF変換、リサイズ）は**配信時（CDN Edge）** で実行し、オリジナルファイルを劣化なく保存する

### 11.5. No-Image Policy

- 画像未設定時のフォールバックは、ストレージ上の「共通No-Image画像」を参照する。コード内でのフォールバックのハードコーディングは禁止

---

## Part XII: 画像最適化 & 配信パイプライン

### 12.1. The CDN Delivery Gateway Mandate

- **Law**: ストレージの**オリジンURL**を`<img>`タグの`src`属性に直接記述することは禁止
- **Action**: 画像配信は必ず**CDNまたはリバースプロキシ**を経由し、エッジレベルでのキャッシュ・自動フォーマット変換（WebP/AVIF）・レスポンシブリサイズを適用する

### 12.2. The Storage URL Hardcoding Ban

- **Law**: コード内に画像やファイルのURLをハードコーディングすることは禁止
- **Action**: `getStorageUrl(path)` 等のユーティリティ関数でドメインとパスを解決する

```typescript
// ✅ 正しい実装
const imageUrl = getStorageUrl(`articles/2026/03/hero.webp`);

// ❌ 禁止: ハードコーディング
const imageUrl = `https://storage.example.com/articles/2026/03/hero.webp`;
```

### 12.3. フロントエンド画像最適化

- **Rule 34.27**: CMSから配信される画像は `next/image` または同等の機能でフロントエンド側で最適化・キャッシュする。CMS画像URLを直接`<img>`タグで使用することを避ける
- `srcset` / `sizes` によるレスポンシブイメージが標準
- LCP重要画像には `priority={true}` を設定しプリロードする

---

## Part XIII: UGCメディア管理 & 動画戦略

### 13.1. The UGC Capacity Optimization Protocol

- **Law**: ユーザーがアップロードする画像には**クライアントサイド前処理**を義務付ける

| # | 処理 | 基準値 |
|:---|:---|:---|
| 1 | **リサイズ** | 長辺最大1920px |
| 2 | **EXIF除去** | GPS含む全EXIFデータを必ず除去（プライバシー保護） |
| 3 | **フォーマット検証** | JPEG/PNG/WebPのみ許可、明示的ファイルサイズ制限 |

### 13.2. The Video Ban Protocol

- **Law**: サーバーへの動画ファイルの直接アップロードは禁止（帯域コスト + コンテンツ監視リスク）
- **Action**: 外部プラットフォーム（YouTube / Vimeo等）へのアップロードを前提とし、システムには**埋め込みコード（iframe/ID）** のみを保存する

### 13.3. Editor Integration Protocol

- **Rule 34.28**: 管理画面エディタへのドラッグ＆ドロップやペーストによる直接アップロードは**禁止**
- 画像挿入は「メディアライブラリ」モーダルを経由し、既存アセットの再利用を強制する

---

## Part XIV: DAM（Digital Asset Management）統合

### 14.1. DAM統合戦略

- **Rule 34.29**: エンタープライズ環境ではCMS内蔵メディアライブラリに加え、外部DAM（Cloudinary / Bynder / Brandfolder）との統合を推奨する

| 観点 | CMS内蔵メディアライブラリ | 外部DAM |
|:---|:---|:---|
| **用途** | プロジェクト固有のアセット | 企業全体のブランドアセット |
| **機能** | 基本的な管理・検索 | AI自動タグ付け・権限管理・利用追跡 |
| **スケール** | 中小規模 | 大規模・マルチブランド |

### 14.2. DAM統合パターン

- **API連携**: CMSのメディア選択UIからDAMのAPIを呼び出し、アセットをインポート
- **CDN統一**: DAMとCMSのメディアを同一CDN（Cloudinary / imgix）経由で配信し、変換パラメータを統一する
- **メタデータ同期**: DAMのタグ・権限情報をCMSメディアフィールドに同期し、利用権限違反を防止する

### 14.3. アセットライフサイクル管理

- **Rule 34.30**: 未使用アセットの定期棚卸し（四半期）を実施し、ストレージコストを最適化する
- **使用追跡**: 各アセットの引用先（どのコンテンツで使用中か）をトレース可能にする
- **ライセンス管理**: 外部素材のライセンス期限をメタデータとして管理し、期限切れアラートを自動化する

---

## Part XV: レンダリング戦略（SSG/ISR/SSR）

### 15.1. レンダリングパターン選定

| パターン | 説明 | 推奨ケース |
|:---|:---|:---|
| **SSG** | ビルド時にHTML生成 | 利用規約、会社概要（更新頻度低） |
| **ISR** | リクエスト時にバックグラウンド再生成 | 記事一覧、特集ページ |
| **SSR** | リクエスト毎にサーバーサイド生成 | ランキング、パーソナライズ |
| **CSR** | クライアントサイドレンダリング | インタラクティブウィジェットのみ |

- **Rule 34.31**: SEO重要なCMSコンテンツをCSRのみで実装することは禁止。SSG、ISR、またはSSRを使用する

### 15.2. ISR設計原則

- **On-demand Revalidation**: CMS Webhookと連動し、コンテンツ更新時に該当ページを即時リバリデーションする
- **Tag-based Revalidation**: `revalidateTag()` を使用しコンテンツタイプ単位での一括リバリデーションを実装する

---

## Part XVI: CDN & エッジ配信

### 16.1. エッジ配信戦略

- **Rule 34.32**: CMSコンテンツ配信はCDNを活用し、オリジンサーバーへの直接アクセスを最小化する
- グローバル配信にはマルチリージョンCDN PoP（Points of Presence）を活用する

### 16.2. Edge Functions活用

- プレビュー認証、A/Bテストルーティング、ジオロケーション判定等をEdge Functions（Vercel Edge / Cloudflare Workers）で処理し、オリジンへのリクエストを削減する

---

## Part XVII: キャッシュ階層戦略

### 17.1. The Content Cache Tiering Protocol

- **Law**: コンテンツ更新頻度に応じたキャッシュTTLを階層化する。全コンテンツに一律のキャッシュ設定を適用することは禁止

| Tier | コンテンツ例 | キャッシュ戦略 |
|:---|:---|:---|
| **Hot（高頻度）** | ランキング、在庫、価格 | ISR `revalidate: 60`〜300 or SSR |
| **Warm（中頻度）** | 記事一覧、特集ページ | ISR `revalidate: 3600` |
| **Cold（低頻度）** | 利用規約、会社概要 | SSG + On-demand Revalidation |

### 17.2. キャッシュ無効化

- **Rule 34.33**: コンテンツ更新時にOn-demand Revalidationをトリガーし、古いキャッシュの残留を防止する
- **Cache Key設計**: キャッシュキーにロール情報を含め、管理者プレビューと公開ビューのキャッシュ混在を防止する

---

## Part XVIII: リッチテキストエディタガバナンス

### 18.1. Strict Schema

- **Rule 34.34**: エディタ（Tiptap等）は許可された要素（H2/H3等）のみを許可し、運用者によるデザイン崩壊を防止する
- 許可ノードリスト: `heading(2-3)`, `paragraph`, `bold`, `italic`, `link`, `image`, `blockquote`, `bulletList`, `orderedList`, `codeBlock`, `table`
- `<font>`, `<style>`, `<div>` 等のレイアウト破壊要素は禁止

### 18.2. Paste Sanitization

- **Rule 34.35**: ペースト時・表示時にDOMPurify等でサニタイズし、悪意あるスクリプトや壊れたスタイルを除去する

### 18.3. PII リアルタイム警告

- エディタ入力中に電話番号やメールアドレスが検出された場合、保存をブロックするのではなく、即座にToastで「警告」を表示し再考を促す

### 18.4. Code Injection Prevention

- HTML直接入力ノードを使用する場合は、構文エラーによるレイアウト破壊を防止するため、必ずコードエディタ（PrismJS等）を経由させる

### 18.5. The CMS Transparency Protocol

- **Law**: リッチテキストエディタには双方向バインディング対応の「ソース表示」機能を必ず実装する

### 18.6. The Micro-Content Protocol

- **Law**: 小規模テキストフィールド（補足説明等）にリッチテキストエディタを使用することは禁止
- **Action**: `Textarea` + `Markdown` パーサー（`react-markdown`等）でデータ構造をシンプルに保つ

---

## Part XIX: Triple Write Protocol & データ整合性

### 19.1. The Triple Write Protocol

- **Law**: リッチテキストデータは以下3形式を**Atomic Update**で保存する

| # | 形式 | 用途 |
|:---|:---|:---|
| 1 | **JSON（Editor Source）** | 再編集性・将来拡張のための構造化データ |
| 2 | **HTML（View Source）** | フロントエンド表示（パースゼロオーバーヘッド） |
| 3 | **TEXT（Search Source）** | 検索インデックス・AI RAG用プレーンテキスト |

- 権威あるデータ形式は**JSON (`JSONContent`)**とする。HTML文字列ではない

### 19.2. The Content Auto-Save Protocol

- **Law**: エディタコンテンツを複数レイヤーで自動保存する

| レイヤー | 保存先 | 間隔 |
|:---|:---|:---|
| **ローカル自動保存** | `localStorage` | 30秒ごと |
| **サーバードラフト同期** | サーバーDB | 60秒ごと |

- **競合検出**: 同一コンテンツの複数タブでの同時編集を検出し通知する。サイレント上書きは禁止

---

## Part XX: エディタ拡張 & NodeView設計

### 20.1. The NodeView Portal Prohibition

- **Law**: ProseMirrorベースエディタ（Tiptap等）において、カスタムNodeView内からReact Portal（`createPortal`）を使用して外部DOM（`document.body`等）にUIを描画することは**禁止**
- **Action**: NodeViewの`contentDOM`内にインライン描画するか、エディタのコマンドシステムに制御を委譲する

### 20.2. The stopEvent Configuration Mandate

- **Law**: カスタムNodeView内にインタラクティブ要素（`<input>`, `<select>`, `<button>`等）を配置する場合、`stopEvent`関数を必ず設定する
- **Action**: ターゲットイベント（`mousedown`, `keydown`, `input`, `dragstart`）を制御し、エディタへの伝搬を防止する。全イベントの無差別ブロックではなく、インタラクティブ要素のイベントのみを選択的にブロックする

---

## Part XXI: パブリッシングワークフロー

### 21.1. パブリッシングワークフロー

- **Rule 34.36**: コンテンツは以下のステータス遷移フローを厳守する

```
draft → pending → published → archived
  ↑       │                       │
  └───────┘ (差し戻し)            │
  ↑                               │
  └───────────────────────────────┘ (再編集)
```

### 21.2. セキュアプレビュー

- 公開前コンテンツのプレビューは署名付きURL（`verify(token)`）経由のみ許可する

### 21.3. 予約公開

- `status = 'published'` AND `published_at <= NOW()` の両条件を満たした場合のみ公開状態とする
- スケジューリングと連動したキャッシュパージ（ISR/Revalidate）メカニズムを実装する

---

## Part XXII: 承認ゲート & ステータス遷移

### 22.1. The Content Approval Gate Protocol

- **Law**: 「誰が」「どの条件で」ステータス遷移を実行できるかを厳格に制御する

| 遷移 | 実行権限 | 条件 |
|:---|:---|:---|
| `draft → pending` | Writer（作成者） | 本文が空でないこと |
| `pending → published` | **Editor以上** | レビュー完了フラグが`true` |
| `published → archived` | Admin | アーカイブ理由の入力必須 |
| `archived → draft` | Admin | 再編集開始の監査ログ |
| `pending → draft` | WriterまたはAdmin | 差し戻し理由コメント必須 |

- **Self-Publish Ban**: 自分が作成したコンテンツを自ら`published`ステータスへ直接遷移させることを禁止する
- **Audit Trail**: すべてのステータス遷移を監査ログに記録する（`who`, `when`, `from_status`, `to_status`, `reason`）

---

## Part XXIII: スケジューリング & 予約公開

### 23.1. The Page Scheduling Protocol

- **Law**: コンテンツの公開/取り下げを日時指定で実行するスケジューリング機能を標準実装する

| フィールド | 用途 |
|:---|:---|
| `published_at` | 公開日時 |
| `unpublished_at` | 公開終了日時（期間限定コンテンツ用） |

- **Query Filter**: `published_at <= NOW() AND (unpublished_at IS NULL OR unpublished_at > NOW())`
- **二重防御**: CDNキャッシュ/ISRによるバイパスリスクを防ぐため、DBクエリとアプリケーションロジックの両層で時刻チェックする
- **キャッシュ無効化**: スケジュール時刻到達時に関連ページのキャッシュを自動無効化する

---

## Part XXIV: リビジョン管理 & 監査証跡

### 24.1. The Content Revision Protocol

- **Rule 34.37**: コンテンツ保存のたびに `revisions` テーブルに差分を保存する
- **保持**: リビジョンは原則として**無期限保持**する
- **Diff View**: 管理画面で直近Nリビジョン間（推奨: 10件以上）の差分表示を実装する
- **ロールバック**: 過去リビジョンへのワンクリック復元を標準実装する

### 24.2. 法的文書バージョニング

- 法的文書（利用規約、プライバシーポリシー等）は任意の過去バージョン時点を復元・表示できる状態を維持する（Legal Time Machine）

---

## Part XXV: プレビュー戦略

### 25.1. The Preview Gate Protocol

- **Law**: ドラフト/未公開コンテンツのプレビューアクセスを**認証済み管理者のみ**に制限する

| # | 対策 | 説明 |
|:---|:---|:---|
| 1 | **Draft Isolation** | プレビューモードでは`status = 'draft'`を含め、一般ユーザーからの不可視性を維持 |
| 2 | **Auth Gate** | プレビューURLに認証トークンまたはセッション検証を必須化 |
| 3 | **No Draft Leak** | `noindex`メタタグまたは`X-Robots-Tag`で検索インデックスを防止 |
| 4 | **Multi-Factor Preview** | URLトークン + パスワード入力の多要素認証 |
| 5 | **Cookie Fallback** | セッション無効時はパスワード入力画面にリダイレクト |

---

## Part XXVI: Dual Mode Fetching

### 26.1. The Dual Mode Fetching Protocol

- **Law**: プレビュー機能と公開ページを同一コードベースで扱う際、未公開データの公開ページへのリークリスクを物理的に防止する
- **明示的メソッド分離**: 公開用・プレビュー用のデータ取得関数を明示的に分離する
- **Default Deny**: プレビューフラグのデフォルトは`false`（Public Mode）。明示的な認可がある場合のみ権限をエスカレーションする

---

## Part XXVII: Soft 404 & HTTPステータスコード

### 27.1. The Soft 404 Awareness Protocol

- **Law**: 削除済み/未公開コンテンツのURLに対してステータスコード200の空ページを返す「ソフト404」を防止する

| シナリオ | HTTPステータス |
|:---|:---|
| 削除されたリソース | **410 Gone** |
| 存在しないリソース | **404 Not Found** |
| 移動されたコンテンツ | **301 Redirect** |

- **No Empty Pages**: 「このページは存在しません」をステータスコード200で返す実装は禁止（検索エンジンにインデックスされ、SEOに悪影響）
- **コンテンツベース検証**: テスト・監視において、ステータスコードに加えページコンテンツの存在を検証基準とする

---

## Part XXVIII: ハイブリッドレイアウト設計（Content vs Layout）

### 28.1. The Hybrid Design Protocol

- **Rule 34.38**: CMSのベストプラクティスは「コンテンツエンティティ（Relational）」と「配置情報（JSON）」を分離するハイブリッド設計
- 記事や商品は正規化テーブルで管理し、トップページのセクション順序やウィジェット配置のみを**JSON配列**で管理する

### 28.2. The Schema Permission Lock Protocol

- **Law**: JSONベースのレイアウト定義において、「運用者が定義・ロックした構造（System Schema）」と「編集可能な領域（User Data）」を**スキーマレベルで明確に分離**する
- **Lock/Unlock分離**: フィールドに`editable: true/false`のメタデータを付与し、UIで編集可能性を物理的に制御する
- **Validation Gate**: バックエンドはロックされたフィールドへの変更をリジェクトする。フロントエンドの制御のみでの防御は禁止

---

## Part XXIX: Dynamic Page Builder & Component Registry

### 29.1. Dynamic Page Builder

- **Rule 34.39**: トップページやランディングページはハードコードせず、管理画面からセクションの自由な追加・並べ替えを可能にする
- **Component Isolation**: 各セクションは`ErrorBoundary`内で独立したコンポーネントとして隔離する
- **LCP Optimization**: ヒーローバナー等はSSRで描画し`priority={true}`でプリロードする
- **No Deploy for Layout**: レイアウト変更にコードデプロイを必要としない設計を維持する

### 29.2. The Component Mapping Protocol

- **Law**: CMSタイプとフロントエンドコンポーネントの1:1マッピングを提供する**ComponentRegistry**を物理的に定義する

```typescript
// ✅ プラグインアーキテクチャ
const ComponentRegistry: Record<string, React.ComponentType<SectionProps>> = {
  hero:     HeroSection,
  ranking:  RankingSection,
  featured: FeaturedSection,
  newItems: NewItemsSection,
};

// ❌ 禁止: switch文分岐
switch (section.type) {
  case 'hero': return <HeroSection />;
  // ...
}
```

### 29.3. 固定ページ戦略

- **Rule 34.40**: 利用規約やランディングページ等の「固定ページ」はハードコードせず、Headless CMS（`fixed_pages`）で管理し動的ルーティング（`/[slug]`）で配信する
- **API-First配信**: 将来のアプリ配信のため、JSONデータを返す伴走APIエンドポイントを実装する

---

## Part XXX: SEO自動化 & メタデータ管理

### 30.1. The SEO Preview Mandate

- **Law**: コンテンツ編集画面に**SEOプレビューパネル**を常設する

| 項目 | 基準 | 違反時 |
|:---|:---|:---|
| **meta title** | 15-60文字 | 黄色警告 |
| **meta description** | 50-160文字 | 黄色警告 |
| **OGP画像** | 1200×630px推奨、≦300KB | リサイズ提案 |
| **H1見出し** | 1ページ1つ | 赤色警告 |

- **Auto-Suggestion**: title/description未入力時、本文から自動候補を生成する

### 30.2. Automated SEO

- **Meta Automation**: タイトルやOGPが未設定の場合、AI要約やデフォルト画像で自動補完する
- **Internal Linking**: 関連コンテンツ（タグ・カテゴリ一致）を自動レコメンドし内部リンク構造を強化する

---

## Part XXXI: 構造化データ & Schema.org

### 31.1. 構造化データ自動生成

- **Rule 34.41**: CMSコンテンツからJSON-LD形式のSchema.orgマークアップを自動生成する

| コンテンツタイプ | Schema.org Type |
|:---|:---|
| 記事 | `Article` / `BlogPosting` |
| 商品 | `Product` |
| FAQ | `FAQPage` |
| イベント | `Event` |
| ローカルビジネス | `LocalBusiness` |
| レビュー | `Review` / `AggregateRating` |

### 31.2. パンくずリスト

- **Rule 34.42**: CMSのカテゴリ階層に基づいた `BreadcrumbList` マークアップを自動生成する

---

## Part XXXII: AI-Ready Content Protocol

### 32.1. AI-Ready Content 設計

- **Rule 34.43**: コンテンツは人間だけでなくAIエージェント（RAG/Search/LLM）が理解し引用しやすい構造で設計する

| 原則 | 説明 |
|:---|:---|
| **セマンティックマークアップ** | H2/H3、リスト、定義リストを活用（Wall of Text禁止） |
| **要約メタデータ** | 各コンテンツに要約フィールドを必須とする |
| **キーワードタグ** | 機械可読なキーワード/タグを付与する |
| **信頼性スコア** | コンテンツの信頼度を示すメタデータ（検証済み/AI生成/UGC等） |

### 32.2. LLMs.txt対応

- **Rule 34.44**: AIクローラー向けの `llms.txt` ファイルを配置し、サイト構造とコンテンツのナビゲーションを提供する
- 主要コンテンツへの直接リンクと簡潔な説明を含める

### 32.3. RAGソースとしてのコンテンツ

- Triple Write Protocol（§XIX）で生成される**プレーンテキスト（TEXT形式）** がRAGの参照ソースとなる
- HTMLタグを含むノイズだらけのデータはトークンの浪費であり、回答精度を低下させる
- **Cross-Reference**: `400_ai_engineering.md` §XIX（RAG基盤設計）

### 32.4. MCP Server統合

- **Rule 34.45**: CMSコンテンツをAIエージェントに公開するため、**MCP（Model Context Protocol）Server**を実装し、AIが直接コンテンツを取得・検索・更新できるインターフェースを提供する
- **リソース公開**: コンテンツタイプ一覧、個別コンテンツ取得、検索をMCPリソースとして定義する
- **ツール公開**: コンテンツ作成・更新・ステータス遷移をMCPツールとして定義し、RBACを適用する
- **Cross-Reference**: `400_ai_engineering.md` §XXVIII（MCP設計）

---

## Part XXXIII: AI搭載コンテンツ運用

### 33.1. AI支援機能

| 機能 | 説明 | 実装優先度 |
|:---|:---|:---|
| **自動タグ付け** | コンテンツからカテゴリ・タグを自動推論 | 高 |
| **要約生成** | 本文からmeta description候補を自動生成 | 高 |
| **翻訳支援** | コンテンツの下訳を自動生成、人間がレビュー | 中 |
| **類似コンテンツ検出** | 重複・類似コンテンツを自動検出 | 中 |
| **品質スコアリング** | 読みやすさ・SEO品質を自動評価 | 中 |
| **画像alt生成** | AI画像分析による代替テキスト自動提案 | 中 |

### 33.2. AI Copilot for Editors

- **Rule 34.46**: AIによる編集支援は「提案」であり、最終判断は人間が行う設計を義務付ける
- AI生成の提案にはAccept/Rejectインタラクションを必須とする

---

## Part XXXIV: AI生成コンテンツガバナンス

### 34.1. AI生成コンテンツラベリング

- **Rule 34.47**: AIが生成・補助したコンテンツには出自を明示するラベルを**常時表示**する
- DB Flag: `is_ai_generated: boolean`（デフォルト: `false`）で追跡する
- **No Raw Publish**: AI生成テキストをそのまま公式コンテンツとして掲載することを禁止。人間による編集・検証を経たもののみ公式コンテンツとする
- **Cross-Reference**: `400_ai_engineering.md` §VIII（AIコンテンツラベリング）

### 34.2. AI生成コンテンツ品質保証

- **Rule 34.48**: AI生成コンテンツには追加の品質チェックレイヤーを適用する
  - **事実検証**: RAGソースまたは確定データとの照合を必須とする
  - **ハルシネーション検出**: 検証不能な固有名詞・数値をフラグし人間レビューを要求する
  - **トーン一貫性**: ブランドガイドラインとの自動照合を実施する

---

## Part XXXV: Agentic CMS & AI自律コンテンツ管理

### 35.1. Agentic CMS 自律性レベル

- **Rule 34.49**: AI Agent のCMS操作権限を5段階で定義し、段階的に自律性を拡大する

| Level | 名称 | AIの役割 | 人間の役割 | 例 |
|:---|:---|:---|:---|:---|
| **L1** | 提案 | 改善案の提示 | 全操作実行 | タグ候補提案 |
| **L2** | 下書き | ドラフト自動作成 | レビュー・承認 | AI翻訳下訳 |
| **L3** | 自動実行+通知 | 承認後自動実行 | 事後監視 | SEOメタ自動補完 |
| **L4** | 監視付き自律 | 自律実行+例外報告 | 例外処理 | コンテンツ更新通知の自動配信 |
| **L5** | 完全自律 | 自律判断+自律実行 | ポリシー設定のみ | AI自体への公開権限は禁止 |

- **Rule 34.50**: L3以上の自律性レベルでは、AIによるコンテンツの**直接公開を禁止**する。公開ステータスへの遷移には常に人間の承認を要求する

### 35.2. AI Agent ワークフロー統合

- **Content Refresh Agent**: 古いコンテンツを検出し、更新案を自動生成してレビューキューに投入する
- **SEO Optimization Agent**: コンテンツのSEOスコアを分析し、タイトル・メタデータの最適化案を提案する
- **Translation Agent**: 新規公開コンテンツを検出し、対象言語の下訳を自動生成する

### 35.3. A2A Protocol統合

- **Rule 34.87**: 複数のAI Agentが協調してコンテンツワークフローを実行する場合、**A2A（Agent-to-Agent）Protocol**を採用しエージェント間通信を標準化する
- **Agent Card**: 各CMS Agentの能力（ツール、権限、入出力スキーマ）をAgent Cardとして公開し、動的な協調を可能にする
- **Task Delegation**: Content Refresh Agent → Translation Agent → SEO Agent のように、タスクをチェーン形式で委譲する際はA2Aのタスク管理機能を使用する
- **Cross-Reference**: `400_ai_engineering.md` §XXX（A2A Protocol設計）

### 35.4. Agent Safety Guardrails

- **Rule 34.51**: AI Agentのすべてのアクションを監査ログに記録する
- **Rate Limit**: AI Agentの操作頻度を制限し、暴走を防止する
- **Kill Switch**: AI Agent機能を即座に停止できるキルスイッチを実装する
- **Cross-Reference**: `400_ai_engineering.md` §XXVI-XXXV（Agentic AI・ガードレール設計）

---

## Part XXXVI: CMSセキュリティアーキテクチャ（OWASP 2025対応）

### 36.1. CMS管理画面のセキュリティ

- **Rule 34.52**: CMS管理画面はIP制限、SSO、MFAで保護し、公開フロントエンドとは完全に分離する

| 防御層 | 対策 |
|:---|:---|
| **認証** | SSO / OAuth 2.0 + PKCE + MFA必須 |
| **ネットワーク** | IP制限 / VPN / Zero Trust |
| **API** | APIキーローテーション（90日） / HMAC署名 |
| **入力** | XSS防止 / SQLインジェクション防止 / CSRF対策 |
| **データ** | 暗号化（TLS 1.3 + AES-256 at rest） |
| **依存関係** | Supply Chainセキュリティ（SCA / SBOM） |

### 36.2. The Media Library Sanctuary

- **Law**: メディア管理ロジック（`admin/media`）はセキュリティの要であり、AIによる独断でのリファクタリング・削除を禁止する。変更には必ずユーザーの明示的承認を得る

### 36.3. RBAC（ロールベースアクセス制御）

| ロール | 権限 |
|:---|:---|
| **Viewer** | 公開コンテンツの閲覧のみ |
| **Writer** | ドラフト作成・編集、pendingへの遷移 |
| **Editor** | レビュー・公開・アーカイブ |
| **Admin** | 全操作 + ユーザー管理 + 設定変更 |

### 36.4. OWASP 2025 CMS対応

- **Rule 34.53**: OWASP Top 10 2025の主要リスクに対し、CMS固有の対策を実装する

| OWASP 2025 Risk | CMS対策 |
|:---|:---|
| **A01: Broken Access Control** | RBAC厳格化、Default Deny、API権限分離 |
| **A02: Security Misconfiguration** | CMS設定のハードニング、Introspection無効化 |
| **A03: Supply Chain Failures** | CMS依存関係のSCA定期スキャン、SBOM管理 |
| **A05: Injection** | 入力サニタイズ、ORM使用、パラメータバインド |
| **A07: Authentication Failures** | MFA必須、セッション管理、API Key管理 |

---

## Part XXXVII: コンテンツサプライチェーンセキュリティ

### 37.1. コンテンツ出自追跡

- **Rule 34.54**: すべてのコンテンツに出自メタデータ（作成者、作成手段、レビュー者、AI利用有無）を付与し、コンテンツの信頼性チェーンを構築する

| メタデータ | 説明 |
|:---|:---|
| `created_by` | 作成者ID |
| `creation_method` | `manual` / `ai_assisted` / `ai_generated` / `imported` |
| `reviewed_by` | レビュー承認者ID |
| `source_url` | 元ソースURL（インポートの場合） |
| `content_hash` | コンテンツ改ざん検知用ハッシュ |

### 37.2. C2PA Content Credentials統合

- **Rule 34.88**: メディアアセットの出自証明に**C2PA（Coalition for Content Provenance and Authenticity）** 規格を採用し、改ざん耐性のあるContent Credentialsを埋め込む

| C2PAメタデータ | 説明 |
|:---|:---|
| **作成者** | コンテンツ作成者の署名証明書 |
| **作成ツール** | 使用したツール（CMS名、AIモデル名） |
| **編集履歴** | 変更履歴のチェーン（改ざん検知可能） |
| **AI関与** | AI生成・補助の有無と詳細 |
| **タイムスタンプ** | 暴号化署名付き作成日時 |

- **DAM連携**: DAMからCMSへのアセットインポート時にC2PAマニフェストを検証し、出自不明アセットを警告する
- **Deepfake対策**: AI生成画像の検出と自動ラベリングをC2PAメタデータと組み合わせて実装する

### 37.3. 外部コンテンツ取り込みセキュリティ

- **Rule 34.55**: 外部ソース（RSS、API、スクレイピング）からのコンテンツ取り込み時は以下を義務付ける
  - HTMLサニタイズ（DOMPurify）
  - URL検証（ホワイトリスト）
  - メディアファイルのウイルススキャン
  - レート制限

---

## Part XXXVIII: コンテンツモデレーション & Trust & Safety

### 38.1. The Content Moderation Protocol

- **Law**: UGCを受け入れるサービスでは多層モデレーション体制を構築する

| カテゴリ | 具体例 | 対応 |
|:---|:---|:---|
| **誹謗中傷** | 個人攻撃、名誉毀損、差別的表現 | 即時非公開 + 投稿者警告 |
| **虚偽情報** | ステルスマーケティング含む | 非公開 + 調査 |
| **個人情報** | 電話番号、住所、メールアドレス | 自動マスキング |
| **有害コンテンツ** | 暴力、わいせつ、薬物 | 即時削除 |
| **スパム** | 広告目的、リンクスパム | 自動フィルタで非表示 |
| **著作権侵害** | 無断転載画像、盗用テキスト | 法的対応フロー |

### 38.2. Moderation Layers

1. **自動フィルタ（第1層）**: NGワード辞書 + 正規表現パターンで即時判定
2. **AI判定（第2層）**: センチメント分析・毒性検出で「要確認」フラグ付与
3. **人的レビュー（第3層）**: フラグ付きコンテンツを管理者が24時間以内に確認

- **Transparency**: 非公開理由を投稿者に通知し、異議申立ての機会を提供する

---

## Part XXXIX: コンテンツアクセシビリティ（WCAG 2.2/EAA）

### 39.1. CMS出力のアクセシビリティ義務

- **Rule 34.56**: CMSから配信されるコンテンツはWCAG 2.2 Level AA準拠を義務付ける

| 要件 | 具体策 |
|:---|:---|
| **画像alt属性** | CMS入稿時にalt属性入力を必須化（空文字による装飾画像マーキングも許可） |
| **見出し階層** | H1→H2→H3の順序を厳守。H1スキップやH2→H4飛ばしを禁止 |
| **リンクテキスト** | 「こちら」「詳しくは」等の非記述的リンクテキストを警告 |
| **カラーコントラスト** | テキストと背景の最低コントラスト比4.5:1を保証 |
| **動画キャプション** | 動画コンテンツにはキャプション/トランスクリプトを必須 |

### 39.2. European Accessibility Act (EAA) 対応

- **Rule 34.57**: 2025年6月施行のEAAに対応し、CMS管理画面自体のアクセシビリティもWCAG 2.2 AAレベルで保証する
- CMSリッチテキストエディタはキーボード操作のみで全機能を使用可能にする

---

## Part XL: 多言語コンテンツ管理 & 翻訳ワークフロー

### 40.1. 多言語アーキテクチャ

| パターン | 説明 | 推奨ケース |
|:---|:---|:---|
| **Locale per Field** | 各フィールドにロケール毎の値を保持 | フィールドレベルの翻訳制御 |
| **Locale per Entry** | コンテンツエントリ全体をロケール毎に複製 | 完全に異なるコンテンツ |
| **Hybrid** | 一部フィールドのみ翻訳、残りは共有 | 画像/数値は共有、テキストは翻訳 |

### 40.2. 翻訳ワークフロー

- **Rule 34.58**: 翻訳はCMS内ワークフローまたはTMS（Translation Management System）統合で管理する
- AI翻訳は下訳としてのみ使用し、人間レビューを義務付ける
- **Translation Memory**: 過去の翻訳資産を蓄積・再利用する仕組みを構築する
- **Cross-Reference**: `800_internationalization.md`（グローバル展開）、`802_language_protocol.md`（言語プロトコル）

---

## Part XLI: コンテンツパーソナライゼーション

### 41.1. パーソナライゼーション戦略

- **Rule 34.59**: CMSコンテンツのパーソナライゼーションは、プライバシー規制（GDPR/APPI）に準拠し、明示的な同意に基づいてのみ実施する

| レベル | 手法 | 例 |
|:---|:---|:---|
| **L1: セグメント** | ユーザー属性に基づくセグメント表示 | 新規/既存ユーザーで異なるヒーロー |
| **L2: 行動ベース** | 閲覧履歴に基づくレコメンド | 「あなたへのおすすめ記事」 |
| **L3: リアルタイム** | コンテキスト（位置情報・時刻）に基づく | 地域別イベント表示 |

### 41.2. Edge Personalization

- パーソナライゼーション判定はEdge Functions（Vercel Edge Middleware等）で実行し、オリジンへの追加リクエストなしにコンテンツを出し分ける
- パーソナライズドコンテンツのキャッシュは `Vary` ヘッダーまたはCookie分岐で制御する

---

## Part XLII: コンテンツガバナンス & ライフサイクル管理

### 42.1. コンテンツガバナンスフレームワーク

- **Rule 34.60**: コンテンツのライフサイクル全体（企画→作成→レビュー→公開→更新→アーカイブ→削除）を統制するガバナンスフレームワークを構築する

| フェーズ | 責任者 | チェックポイント |
|:---|:---|:---|
| **企画** | コンテンツストラテジスト | キーワード調査・競合分析 |
| **作成** | Writer | ブランドガイドライン準拠チェック |
| **レビュー** | Editor | 品質・正確性・法務チェック |
| **公開** | Publisher | SEO・アクセシビリティ最終確認 |
| **更新** | Owner | 鮮度チェック（四半期レビュー） |
| **アーカイブ** | Admin | 301リダイレクト設定・SEO影響評価 |

### 42.2. コンテンツ鮮度管理

- **Rule 34.61**: すべてのコンテンツに`content_review_date`（次回レビュー予定日）フィールドを設定し、期限超過時にオーナーへ自動通知する
- **Stale Content Detection**: 公開から180日以上更新のないコンテンツを「要レビュー」として自動フラグ付けする

### 42.3. コンテンツオーナーシップ

- **Rule 34.62**: すべてのコンテンツに`content_owner`フィールドを設定し、更新・削除の責任者を明確化する。オーナー不在コンテンツの発生を防止する

---

## Part XLIII: コンテンツバージョニング & Content as Code

### 43.1. Content as Code

- **Rule 34.63**: コンテンツスキーマ定義（コンテンツタイプ、フィールド定義、バリデーションルール）はコードで管理し、Gitでバージョン管理する
- スキーマ変更はプルリクエストを通じてレビュー・承認後に適用する
- 環境間（dev → staging → production）のスキーマ移行を自動化する

### 43.2. コンテンツスナップショット

- **Rule 34.64**: 本番コンテンツの定期スナップショット（日次）を取得し、障害発生時の復元ポイントとする
- ステージング環境へのコンテンツクローンにも使用する

---

## Part XLIV: CMS移行戦略 & ベンダー切替

### 44.1. CMS移行計画

- **Rule 34.65**: CMS移行は以下のフェーズで段階的に実行する

| フェーズ | 内容 | 期間目安 |
|:---|:---|:---|
| **1. 評価** | 新CMS選定、PoC実施、コスト比較 | 2-4週間 |
| **2. 設計** | コンテンツモデル移行設計、API変換設計 | 2-4週間 |
| **3. パイロット** | 小規模コンテンツでの移行テスト | 2週間 |
| **4. 本番移行** | 全コンテンツの移行実行 | 2-4週間 |
| **5. 検証** | SEO影響確認、リダイレクト検証、監視 | 2週間 |

### 44.2. データポータビリティ

- **Rule 34.66**: CMS移行時のデータ保全チェックリスト
  - コンテンツ本文（構造化データ）の完全移行
  - メディアアセットの移行と参照先の更新
  - 301リダイレクトの設定（旧URL → 新URL）
  - メタデータ（SEO、OGP）の移行
  - リビジョン履歴の移行（可能な場合）
  - 内部リンクの書き換え

### 44.3. Content Abstraction Layer

- **Rule 34.67**: CMS切替時の影響を最小化するため、フロントエンドとCMS間にContent Abstraction Layerを設置する
- CMS固有のレスポンス形式を統一的な内部データモデルに変換する
- CMS移行時はAbstraction Layerのアダプターのみを差し替える

---

## Part XLV: コンテンツフェデレーション & マルチソース

### 45.1. Content Federation

- **Rule 34.68**: 複数のCMSやデータソースを統合して配信する場合、Content Federation（コンテンツの連合）パターンを採用する
- **GraphQL Mesh**: 複数APIを単一GraphQLエンドポイントに統合する
- **BFF（Backend for Frontend）**: フロントエンド専用のAPI層で複数ソースを結合する

### 45.2. マルチソース統合

| ソース | 用途 | 統合方法 |
|:---|:---|:---|
| **Primary CMS** | メインコンテンツ | API直接接続 |
| **Secondary CMS** | ブログ・ニュース | GraphQL Mesh |
| **Commerce Platform** | 商品データ | API / Webhook同期 |
| **DAM** | ブランドアセット | CDN統合 |
| **UGC Platform** | レビュー・コメント | API + モデレーション |

---

## Part XLVI: リアルタイムコラボレーション

### 46.1. 同時編集設計

- **Rule 34.69**: CMS管理画面での同時編集をサポートする場合、以下のいずれかの手法を採用する

| 手法 | 説明 | 推奨ケース |
|:---|:---|:---|
| **Pessimistic Locking** | 編集中は他ユーザーの編集をブロック | シンプルなCMS |
| **Optimistic Locking** | バージョン番号で競合検出、マージ | 中規模CMS |
| **CRDT** | 競合のない自動マージ | リアルタイム重視 |
| **OT（Operational Transform）** | 操作の変換と合成 | Google Docs型 |

### 46.2. プレゼンス表示

- **Rule 34.70**: 同一コンテンツの編集画面では、他の編集者のプレゼンス（アバター・カーソル位置）をリアルタイム表示する
- 編集開始時に「他のユーザーが編集中です」の警告を表示する

---

## Part XLVII: コンテンツ実験 & A/Bテスト

### 47.1. コンテンツ実験基盤

- **Rule 34.71**: CMSコンテンツレベルでのA/Bテストを実施可能にする

| 書コンポーネント | 説明 |
|:---|:---|
| **バリアント管理** | 同一コンテンツの複数バリアントをCMSで管理 |
| **トラフィック配分** | Edge Functionsでバリアントの配分を制御 |
| **計測** | バリアント毎のCTR・滞在時間・CVRを計測 |
| **統計判定** | 統計的有意差を自動判定し、勝者バリアントを提示 |

### 47.2. Feature Flag統合

- CMS内のコンテンツにFeature Flagを紐づけ、段階的リリースやKill Switchを可能にする

---

## Part XLVIII: サーバードリブンUI & Remote Config

### 48.1. Server-Driven UI

- **Rule 34.72**: CMS駆動のServer-Driven UIパターンを採用し、アプリのビルドデプロイなしにUIを更新可能にする
- コンポーネント定義をJSON形式でCMSから配信し、モバイルアプリ・Webが動的にレンダリングする
- **バージョン互換性**: クライアントが認識できないコンポーネントタイプはGraceful Degradationで処理する

### 48.2. Remote Config

- Feature Flag、文言変更、表示制御をCMSから配信し、コードデプロイなしに運用変更を可能にする
- **キャッシュ戦略**: Remote Configのキャッシュは短TTL（60-300秒）で設定し、変更の迅速な反映を保証する

---

## Part XLIX: エディタ体験（Editor Experience / EX）

### 49.1. エディタ体験設計原則

- **Rule 34.73**: CMS管理画面のUXは「開発者」ではなく「コンテンツ編集者」を第一の対象として設計する

| 原則 | 説明 |
|:---|:---|
| **認知負荷最小化** | 必要なフィールドのみ表示、段階的開示 |
| **即時フィードバック** | バリデーションエラーのインライン表示 |
| **ショートカット** | よく使うアクションへのキーボードショートカット |
| **オンボーディング** | 初回利用時のチュートリアルツアー |

### 49.2. Editor Satisfaction Metrics

- **Rule 34.74**: エディタ満足度を定量的に計測し、四半期ごとにCMS改善に反映する
- **計測項目**: タスク完了時間、エラー発生率、NPS、SUS（System Usability Scale）

---

## Part L: CMSテスト戦略

### 50.1. テスト階層

- **Rule 34.75**: CMSコンテンツとスキーマに対するテストを以下の階層で実施する

| テスト層 | 対象 | ツール例 |
|:---|:---|:---|
| **スキーマテスト** | コンテンツモデル定義の妥当性 | Zod / JSON Schema |
| **APIテスト** | エンドポイントのレスポンス検証 | Vitest / Playwright API |
| **コンテンツ整合性** | 参照整合性、必須フィールド充足 | カスタムスクリプト |
| **E2Eテスト** | 管理画面のワークフロー | Playwright / Cypress |
| **ビジュアルリグレッション** | レンダリング結果の視覚的変化 | Percy / Chromatic |

### 50.2. コンテンツスモークテスト

- **Rule 34.76**: デプロイ後に主要ページのコンテンツ存在確認（Smoke Test）を自動実行する
- 空ページ（Soft 404）の検出を含める

---

## Part LI: コンテンツパイプライン自動化

### 51.1. Webhook Chainアーキテクチャ

- **Rule 34.77**: コンテンツ更新に連動する処理をWebhook Chainで自動化する

```
Content Published
├── → ISR Revalidation
├── → Search Index Update (Algolia/Meilisearch)
├── → CDN Cache Purge
├── → RSS/Sitemap Regeneration
├── → Social Media Auto-Share
├── → Translation Queue Trigger
└── → Analytics Event Tracking
```

### 51.2. CI/CD統合

- コンテンツスキーマ変更時のマイグレーション実行をCI/CDパイプラインに統合する
- デプロイ前のコンテンツ整合性チェックをGitHub Actionsで自動化する

---

## Part LII: マルチテナントCMS

### 52.1. マルチテナント設計

- **Rule 34.78**: マルチテナントCMSでは以下の分離レベルを選択する

| レベル | 分離方式 | 推奨ケース |
|:---|:---|:---|
| **L1: Logical** | 同一DB、テナントIDでフィルタ | 小規模SaaS |
| **L2: Schema** | 同一DB、テナント毎スキーマ | 中規模SaaS |
| **L3: Physical** | テナント毎に独立DB | エンタープライズ |

### 52.2. テナント間ガバナンス

- テナント間のコンテンツ・メディア漏洩を防止するRLS（Row Level Security）を義務付ける
- 管理者のクロステナントアクセスは監査ログに記録する

---

## Part LIII: CMS災害復旧 & バックアップ

### 53.1. コンテンツBCP

- **Rule 34.79**: CMS災害復旧計画を策定し、以下のRTO/RPOを目標とする

| 項目 | 目標 |
|:---|:---|
| **RPO（Recovery Point Objective）** | 1時間以内 |
| **RTO（Recovery Time Objective）** | 4時間以内 |
| **バックアップ頻度** | 日次フルバックアップ + 時間毎増分 |

### 53.2. SaaS CMSの可用性

- SaaS CMSのSLAを確認し、99.9%以上を要件とする
- SaaS CMS障害時のフォールバック戦略（キャッシュからの配信継続）を設計する

---

## Part LIV: CMS規制コンプライアンス（DORA/EU AI Act/DSA）

### 54.1. 規制対応マッピング

- **Rule 34.80**: CMSに関連する主要規制を把握し、コンプライアンスを維持する

| 規制 | CMS関連要件 |
|:---|:---|
| **GDPR / APPI** | PII管理、同意管理、データ削除権、越境移転 |
| **EU AI Act** | AI生成コンテンツのラベリング、透明性義務 |
| **DSA（Digital Services Act）** | UGCモデレーション義務、透明性レポート |
| **DORA** | ICTリスク管理、インシデント報告（金融業CMS） |
| **EAA** | CMS管理画面のアクセシビリティ義務 |

### 54.2. コンプライアンス監査

- **Rule 34.81**: CMS関連のコンプライアンス状況を半期ごとに監査し、ギャップ分析を実施する

---

## Part LV: GEO（Generative Engine Optimization）対応

### 55.1. GEO戦略

- **Rule 34.82**: AI検索エンジン（Gemini / SearchGPT / Perplexity等）からのコンテンツ引用を最大化するGEO対策を実施する

| 対策 | 説明 |
|:---|:---|
| **構造化コンテンツ** | 質問→回答形式、定義リスト、箇条書きの活用 |
| **LLMs.txt** | AI向けサイトマップの設置 |
| **引用しやすさ** | 統計データ、具体的事実の明記 |
| **Schema.org** | JSON-LDマークアップの網羅的適用 |
| **権威性** | 著者情報、参考文献、最終更新日の明示 |

### 55.2. AI検索アナリティクス

- AI検索経由のトラフィックを計測し、従来SEOとの比較分析を実施する

---

## Part LVI: CMS Green IT & サステナビリティ

### 56.1. サステナブルコンテンツ配信

- **Rule 34.83**: コンテンツ配信のカーボンフットプリントを意識した設計を推奨する
- **画像最適化**: 不必要な高解像度画像の排除、WebP/AVIF採用
- **キャッシュ最大化**: CDNキャッシュヒット率90%以上を目標とし、オリジンリクエストを最小化する
- **不要コンテンツ削除**: アーカイブ済みで参照のないコンテンツ・メディアを定期的に削除し、ストレージを最適化する

---

## Part LVII: CMS可観測性 & FinOps

### 57.1. CMSメトリクス

| メトリクス | 説明 | ターゲット |
|:---|:---|:---|
| **API Response Time** | Content Delivery APIのレスポンス時間 | p95 < 200ms |
| **Cache Hit Rate** | CDNキャッシュヒット率 | > 90% |
| **Content Freshness** | コンテンツ更新からの反映までの遅延 | < 60s |
| **Webhook Delivery Rate** | Webhook配信成功率 | > 99.5% |
| **Editor Satisfaction** | 編集者のCMS操作満足度 | NPS > 30 |
| **Stale Content Ratio** | 180日以上未更新コンテンツの割合 | < 20% |

### 57.2. CMS FinOps

- **Rule 34.84**: CMSのAPIコール数・ストレージ使用量・帯域幅を月次で監視し、コスト最適化を継続的に実施する
- **SaaS CMS**: プラン上限に対する使用率のアラートを設定する（80%でWarning、90%でCritical）
- **画像最適化によるコスト削減**: CDN Edge変換により、ストレージに保存するのはオリジナル1枚のみとする

---

## Part LVIII: 成熟度モデル（5段階）

### 58.1. CMS成熟度モデル

| Level | 名称 | 特徴 |
|:---|:---|:---|
| **L1: Initial** | 静的・手動 | HTMLハードコード、手動デプロイ |
| **L2: Managed** | CMS導入 | 基本的なCMS運用、手動承認 |
| **L3: Defined** | 構造化 | コンテンツモデリング、API-First、ISR、承認ワークフロー |
| **L4: Optimized** | 自動化 | AI支援、自動SEO、パーソナライゼーション、On-demand Revalidation |
| **L5: Autonomous** | インテリジェント | Agentic CMS、AI自律コンテンツ最適化、Composable DXP完全統合、MCP Server統合 |

---

## Part LIX: アンチパターン集（30選）

### 59.1. アンチパターン集

| # | アンチパターン | 正しいアプローチ |
|:---|:---|:---|
| 1 | HTMLをベタ書きして `dangerouslySetInnerHTML` で描画 | Triple Write Protocol + サニタイズ |
| 2 | 全コンテンツに同一キャッシュTTL | Cache Tiering Protocol |
| 3 | CMSの管理画面を公開ネットワークに露出 | IP制限 + SSO + MFA |
| 4 | モデルなしでリッチテキストフィールドだけ使う | 構造化コンテンツモデリング |
| 5 | 画像をpublicフォルダに直接配置 | 統合メディアライブラリ |
| 6 | オリジンURLを `<img src>` に直接記述 | CDN Delivery Gateway |
| 7 | CMS APIキーをクライアントに露出 | Server-side Only |
| 8 | プレビュー機能を認証なしで公開 | Preview Gate Protocol |
| 9 | 管理者が公開まで一人で完結 | 承認ゲート + Self-Publish Ban |
| 10 | リビジョン管理なし | Content Revision Protocol |
| 11 | switch文でCMSタイプを分岐 | ComponentRegistry |
| 12 | エディタに全HTML要素を許可 | Strict Schema |
| 13 | ソフト404（200で空ページ） | 410 Gone / 404 Not Found |
| 14 | 非構造化HTMLブロブの保存 | JSON形式をSSOT |
| 15 | NodeView内でReact Portal使用 | インライン描画 |
| 16 | AI生成コンテンツのラベルなし公開 | AI生成ラベル義務 |
| 17 | 全コンテンツをCSRのみで描画 | SSG/ISR/SSR |
| 18 | UGC画像をサーバーサイドで処理 | クライアントサイド前処理 |
| 19 | 翻訳をコード内にハードコード | CMS多言語フィールド / TMS |
| 20 | CMSにビジネスロジックを実装 | アプリケーション層に分離 |
| 21 | コンテンツオーナー未設定 | content_owner義務化 |
| 22 | CMS固有SDKへの直接依存 | Content Abstraction Layer |
| 23 | コンテンツ鮮度管理なし | レビュー日自動通知 |
| 24 | AI Agentに公開権限付与 | L3以上で人間承認必須 |
| 25 | Webhook署名検証なし | HMAC署名必須 |
| 26 | コンテンツの出自メタデータなし | 出自追跡メタデータ義務 |
| 27 | 同時編集の競合対策なし | Locking / CRDT |
| 28 | コンテンツスキーマの手動管理 | Content as Code + Git |
| 29 | DAMとCMSの分断運用 | DAM-CMS統合パイプライン |
| 30 | 災害復旧計画なし | BCP策定 + 定期DR訓練 |
| 31 | C2PAなしでのAI生成メディア公開 | C2PA Content Credentials埋め込み |
| 32 | CloudEvents非準拠の独自イベント形式 | CloudEvents v1.0準拠 |
| 33 | コンテンツパフォーマンス未計測 | Content Intelligenceダッシュボード |
| 34 | エディタ科学的根拠なき機能追加 | Editor NPS/SUS計測駆動 |
| 35 | Content Graph無しでのフラットなコンテンツ構造 | Knowledge Graphベースのエンティティ設計 |
| 36 | CWV / INP を考慮しないCMSコンテンツ配信 | Performance Budget + INP最適化 |
| 37 | ETLパイプラインなしでの手動CMS移行 | Structured Content ETL + 増分同期 |
| 38 | CMS SDKの型定義未提供 | TypeScript SDK自動生成 + 型安全API |
| 39 | モバイルアプリ向けオフラインコンテンツ無策 | Delta Sync + SQLiteローカルキャッシュ |
| 40 | APIレートリミット設計なし | 階層型Rate Limiting + Fair Queuing |

---

## Part LX: 将来展望 & CMS実装チェックリスト

### 60.1. CMS将来展望（2026-2030）

| トレンド | 説明 |
|:---|:---|
| **Agentic Content Management** | AI AgentがCMSを自律運用し、コンテンツの企画→作成→最適化→アーカイブを自動化 |
| **Composable DXP成熟** | Best-of-Breedサービスの統合がさらに進化し、プラットフォームレスCMSが主流に |
| **Content Intelligence** | コンテンツの効果分析・予測・最適化をAIがリアルタイムで実行 |
| **Edge-Native CMS** | Edge KV/Durable Objectsを活用し、オリジンレスのコンテンツ配信 |
| **Content Graph** | コンテンツ間関係性をKnowledge Graphで管理し、AIレコメンド精度を向上 |
| **Spatial Content** | AR/VR/Spatial Computing向けの3Dコンテンツ管理 |
| **Voice-First Content** | 音声アシスタント向け構造化コンテンツ設計 |
| **Decentralized Content** | ブロックチェーンベースのコンテンツ認証・著作権管理 |
| **C2PA標準化** | コンテンツ出自証明が業界標準となり、CMSネイティブ統合が進展 |

### 60.2. CMS実装チェックリスト

| # | チェック項目 | 参照 |
|:---|:---|:---|
| 1 | API-First設計の完了 | Part I-II |
| 2 | コンテンツモデルのスキーマ定義 | Part IV-VII |
| 3 | Triple Write Protocol実装 | Part XIX |
| 4 | CDN Delivery Gateway設定 | Part XII, XVI |
| 5 | RBAC + MFA設定 | Part XXXVI |
| 6 | Webhook + HMAC署名設定 | Part X |
| 7 | 承認ワークフロー設定 | Part XXI-XXII |
| 8 | ISR/On-demand Revalidation設定 | Part XV, XVII |
| 9 | SEOプレビューパネル実装 | Part XXX |
| 10 | AI生成コンテンツラベリング | Part XXXIV |
| 11 | アクセシビリティ対応（WCAG 2.2 AA） | Part XXXIX |
| 12 | コンテンツBCP策定 | Part LIII |
| 13 | LLMs.txt配置 | Part XXXII |
| 14 | 監視・アラート設定 | Part LVII |
| 15 | コンプライアンス監査計画 | Part LIV |

---

## Part LXI: C2PA コンテンツ出自証明 & Content Credentials

### 61.1. C2PA統合アーキテクチャ

- **Rule 34.89**: CMS配信メディアに**C2PA（Coalition for Content Provenance and Authenticity）** Content Credentialsを埋め込み、コンテンツの出自・編集履歴・AI関与を暗号学的に証明する

| コンポーネント | 役割 |
|:---|:---|
| **CMS C2PA Signer** | コンテンツ公開時にC2PAマニフェストを生成・署名 |
| **Verification API** | フロントエンドでContent Credentialsを検証・表示するAPI |
| **Trust List** | 信頼する署名者リストの管理（CAチェーン） |
| **Manifest Store** | C2PAマニフェストの永続保存（改ざん検知用） |

### 61.2. CMS公開フローへの組み込み

- コンテンツ公開時に自動でC2PAマニフェストを生成し、画像・動画・PDFに埋め込む
- AI生成・AI補助コンテンツには `c2pa.ai_generated: true` アサーションを必須とする
- **検証UI**: フロントエンドにContent Credentials表示コンポーネント（cr-badge）を実装する

---

## Part LXII: AI-Native Visual Editor & No-Code Content Modeling

### 62.1. AI-Native Visual Editor

- **Rule 34.90**: 非技術系エディタ向けに**AI-Native Visual Editor**を提供し、構造化データの整合性を維持しながらWYSIWYG編集を可能にする
- **構造化データ維持**: Visual EditorはリッチテキストHTMLではなく、構造化JSONを直接操作する
- **AIアシスト**: 画像選択、レイアウト提案、文章校正をエディタ内で直接AIが支援する
- **ライブプレビュー**: 編集内容をリアルタイムでフロントエンド環境にプレビュー表示する

### 62.2. No-Code Content Modeling

- **Rule 34.91**: コンテンツモデル定義をGUIで実行可能な**No-Code Content Modeling**ツールを提供し、非開発者でもフィールド追加・バリデーション設定を安全に行えるようにする
- **スキーマバージョニング**: GUI操作の裏側ではContent as Code（§XLIII）のスキーマファイルが自動生成されGit管理される
- **ガードレール**: 破壊的変更（フィールド削除、型変更）にはGUIレベルで警告と承認フローを適用する

---

## Part LXIII: Content Ops & コンテンツ運用チーム

### 63.1. Content Ops成熟度モデル

- **Rule 34.92**: コンテンツ運用（Content Ops）を組織能力として定義し、段階的に成熟させる

| Level | 名称 | 特徴 |
|:---|:---|:---|
| **L1** | Ad-Hoc | 個人依存、プロセスなし |
| **L2** | Reactive | 基本ワークフロー確立、手動運用 |
| **L3** | Proactive | KPI計測、コンテンツカレンダー、定期レビュー |
| **L4** | Optimized | AI支援、自動化パイプライン、パーソナライゼーション |
| **L5** | Autonomous | Agentic運用、Content Intelligence駆動 |

### 63.2. コンテンツ運用チーム編成

| 役割 | 責務 |
|:---|:---|
| **Content Strategist** | コンテンツ戦略策定、KPI設計、ガバナンス |
| **Content Designer** | Content Design System管理、構造設計 |
| **Content Editor** | コンテンツ作成・編集・品質管理 |
| **Content Engineer** | CMS設定、スキーマ設計、自動化 |
| **Content Analyst** | パフォーマンス分析、A/Bテスト、改善提案 |

---

## Part LXIV: Headless Commerce統合

### 64.1. Commerce Content Bridge

- **Rule 34.93**: Headless CMSとCommerce Platform（Shopify / commercetools / Saleor等）を統合し、**コンテンツ駆動型コマース**を実現する

| 統合パターン | 説明 | 推奨ケース |
|:---|:---|:---|
| **Content-Led** | CMS主導でPDP/PLPを構築、商品データはAPI取得 | メディアコマース |
| **Commerce-Led** | Commerce Platform主導、CMSは補助コンテンツ | 大規模EC |
| **Unified** | BFFで両者を統合、単一APIで配信 | 最も柔軟 |

### 64.2. PDP/PLPコンテンツ設計

- **Rule 34.94**: 商品詳細ページ（PDP）のコンテンツはCMS管理の**エディトリアルコンテンツ**とCommerce Platformの**商品データ**を明確に分離する
- **在庫連動**: 在庫ステータスに基づくコンテンツの自動出し分け（在庫切れ時の代替表示）をEdge Functionsで実行する
- **価格表示**: 価格情報はCommerce Platform APIから直接取得し、CMSにキャッシュしない（鮮度保証）

---

## Part LXV: Edge-Native CMS & Edge配信アーキテクチャ

### 65.1. Edge-First CMS設計

- **Rule 34.95**: コンテンツ配信をEdge-Firstで設計し、オリジンサーバーへの依存を最小化する

| Edge技術 | 用途 |
|:---|:---|
| **Edge KV** | コンテンツメタデータ、設定値、Feature Flagの高速読取 |
| **Durable Objects** | リアルタイム編集セッション、プレゼンス管理 |
| **Edge Functions** | ISR/On-demand Revalidation、パーソナライゼーション判定 |
| **Edge Cache** | 画像変換、HTML断片キャッシュ |

### 65.2. オリジンレス配信

- コンテンツ公開時にEdge KVへ直接書き込み、読取時はオリジンを経由しない
- **フォールバック**: Edge KVミス時のみオリジンAPIにフォールバックし、結果をEdge KVにバックフィルする
- **グローバル一貫性**: Eventual Consistencyを許容し、書込みから読取りまでの伝播遅延を5秒以内に保証する

---

## Part LXVI: Content Intelligence & コンテンツ分析

### 66.1. Content Intelligence ダッシュボード

- **Rule 34.96**: CMSコンテンツのパフォーマンスを定量的に計測し、データ駆動でコンテンツ改善を実施する

| メトリクス | 説明 | データソース |
|:---|:---|:---|
| **Content ROI** | コンテンツ作成コスト対ビジネス成果 | CMS + Analytics |
| **Engagement Score** | 滞在時間・スクロール深度・CTR | Web Analytics |
| **Content Decay** | トラフィック減少率（時系列） | Search Console |
| **Conversion Attribution** | コンテンツ経由のCV寄与度 | Analytics + CRM |
| **SEO Visibility** | 検索順位・表示回数・CTR | Search Console |

### 66.2. 予測的コンテンツ最適化

- **Rule 34.97**: AI予測モデルを活用し、コンテンツパフォーマンスの低下を事前に検出してリフレッシュを推奨する
- **Content Decay Alert**: 過去90日のトラフィック推移から衰退トレンドを検出し、自動アラートを発行する
- **最適公開タイミング**: 過去のエンゲージメントデータから最適な公開曜日・時刻を推定する

---

## Part LXVII: Content Graph & Knowledge Graph

### 67.1. Content Graph設計

- **Rule 34.98**: コンテンツ間の関係性を**Content Graph**として明示的にモデリングし、単純なカテゴリ・タグ分類を超えたセマンティックな関連性を表現する

| 関係タイプ | 説明 | 例 |
|:---|:---|:---|
| **is_about** | コンテンツの主題 | 記事 → トピック |
| **references** | 引用・参照 | 記事 → 記事 |
| **prerequisite** | 前提知識 | ガイド → チュートリアル |
| **supersedes** | 更新・置換 | 新記事 → 旧記事 |
| **part_of** | 所属・構成要素 | チャプター → シリーズ |

### 67.2. Knowledge Graph統合

- コンテンツエンティティ（人物、組織、製品、概念）をKnowledge Graphに登録し、コンテンツ間の暗黙的関連を機械可読にする
- **オントロジー設計**: ドメイン固有のオントロジー（schema.org拡張）を定義し、エンティティ間の関係型を型安全に管理する
- **AI活用**: Content Graphを基にしたレコメンデーション、関連コンテンツ提示、ナレッジベース構築に活用する

---

## Part LXVIII: Event-Driven Content Architecture

### 68.1. Event Mesh設計

- **Rule 34.99**: 大規模コンテンツシステムでは**Event Mesh**アーキテクチャを採用し、CMS・検索・分析・通知サービス間を非同期イベントで疎結合に接続する

```
┌─────────┐    CloudEvents    ┌──────────────┐
│   CMS   │ ──────────────→  │  Event Mesh  │
└─────────┘                   │  (Pub/Sub)   │
                              └──────┬───────┘
                    ┌────────────┬───┴───┬────────────┐
                    ▼            ▼       ▼            ▼
              ┌──────────┐ ┌────────┐ ┌─────┐ ┌───────────┐
              │ Search   │ │ CDN    │ │ ISR │ │ Analytics │
              │ Index    │ │ Purge  │ │     │ │           │
              └──────────┘ └────────┘ └─────┘ └───────────┘
```

### 68.2. イベント設計原則

- **Single Writer**: 各イベントタイプの発行元は1つのサービスに限定する
- **Event Sourcing**: コンテンツ変更履歴をイベントログとして永続化し、任意時点の状態を再構築可能にする
- **Saga Pattern**: 複数サービスにまたがるワークフロー（公開→翻訳→通知→分析）はSagaパターンで整合性を保証する

---

## Part LXIX: Content Localization 深化（MTPE / MQM）

### 69.1. MTPE（Machine Translation Post-Editing）ワークフロー

- **Rule 34.100**: AI翻訳の品質管理に**MTPE**ワークフローを導入し、翻訳品質と効率のバランスを最適化する

| ティア | 品質レベル | 用途 | MTPE工程 |
|:---|:---|:---|:---|
| **Tier 1: Raw MT** | 低 | 社内参考資料 | 機械翻訳のみ |
| **Tier 2: Light PE** | 中 | ブログ・SNS | 流暢さ・文法チェック |
| **Tier 3: Full PE** | 高 | マーケティング | 完全なポストエディット |
| **Tier 4: Human** | 最高 | 法的文書・ブランド | 人間翻訳 + ダブルチェック |

### 69.2. MQM（Multidimensional Quality Metrics）

- 翻訳品質をMQMフレームワークで定量評価する
- **評価軸**: 正確性（Accuracy）、流暢さ（Fluency）、用語一貫性（Terminology）、スタイル（Style）
- **閾値設定**: Tier 2以上ではMQMスコア95点以上を公開基準とする
- **Cross-Reference**: `800_internationalization.md`（グローバル展開）、`802_language_protocol.md`（言語プロトコル）

---

## Part LXX: Content Design System & トークン管理

### 70.1. Content Design System

- コンテンツのスタイル・トーン・構造を統一する**Content Design System**を構築し、ブランド一貫性を保証する

| コンポーネント | 説明 |
|:---|:---|
| **Voice & Tone Guide** | ブランドボイス定義、状況別トーン指針 |
| **Content Patterns** | 再利用可能なコンテンツ構造パターン集 |
| **Vocabulary** | 用語統一辞書、禁止用語リスト |
| **Content Templates** | コンテンツタイプ別の入稿テンプレート |
| **Visual Content Rules** | 画像スタイル、サムネイル仕様、配色ルール |

### 70.2. Content Token管理

- UI Design Systemのデザイントークンと同様に、**コンテンツトークン**（見出しの最大文字数、要約の推奨文字数、画像アスペクト比等）をJSON定義し、CMS Validationとフロントエンドの両方で参照する
- **Cross-Reference**: `200_design_ux.md`（デザインシステム）

---

## Part LXXI: CMSパフォーマンスバジェット & Core Web Vitals

### 71.1. CMSコンテンツのパフォーマンスバジェット

- **Rule 34.101**: CMSから配信されるコンテンツページに対し、**パフォーマンスバジェット**を設定し、CMS側・フロントエンド側双方で遵守する

| メトリクス | バジェット | 測定ツール |
|:---|:---|:---|
| **LCP (Largest Contentful Paint)** | ≦ 2.5s | Lighthouse / CrUX |
| **INP (Interaction to Next Paint)** | ≦ 200ms | Web Vitals / CrUX |
| **CLS (Cumulative Layout Shift)** | ≦ 0.1 | Lighthouse / CrUX |
| **TTFB (Time to First Byte)** | ≦ 800ms | WebPageTest |
| **Total Page Weight** | ≦ 1.5MB | Lighthouse |
| **Image Weight per Page** | ≦ 500KB | カスタムCI |

### 71.2. CMS起因のINP劣化防止

- **Rule 34.102**: CMS由来のコンテンツレンダリングがINP（Interaction to Next Paint）を劣化させないよう、以下の対策を義務付ける

| 対策 | 説明 |
|:---|:---|
| **Long Task回避** | CMSデータのパース・変換処理を50ms以内に制限。超過する場合は`requestIdleCallback`または`scheduler.yield()`で分割する |
| **Hydration最適化** | CMSコンテンツ領域はPartial Hydration / Island Architectureで必要箇所のみHydrateする |
| **Third-Party分離** | CMS管理の埋め込みスクリプト（広告、ウィジェット）はweb workerまたは`<iframe sandbox>`で主スレッドから隔離する |
| **Lazy Rendering** | 下部セクション（Below the Fold）はIntersection Observerで遅延レンダリングする |

### 71.3. CMS画像のCWV最適化

- **Rule 34.103**: CMSメディアライブラリから配信される画像は、CWVスコアへの影響を最小化する設定を義務付ける
  - LCP候補画像: `priority` / `fetchpriority="high"` + レスポンシブ `srcset` + `sizes` 属性必須
  - 非LCP画像: `loading="lazy"` + `decoding="async"` 必須
  - すべての画像: `width` / `height` 属性を明示し、CLS防止のためアスペクト比を確保する
  - **フォーマット**: WebP（デフォルト）/ AVIF（対応ブラウザ）をCDN Edge変換で自動配信する
- **Cross-Reference**: `340_web_frontend.md`（パフォーマンスバジェット）

---

## Part LXXII: 構造化コンテンツ移行 & ETLパイプライン

### 72.1. Content ETLパイプライン

- **Rule 34.104**: CMS間のコンテンツ移行は**ETL（Extract → Transform → Load）パイプライン**として設計し、手動コピーや一括インポートのみに依存しない

| フェーズ | 内容 | ツール例 |
|:---|:---|:---|
| **Extract** | ソースCMSからAPIまたはエクスポートでコンテンツを抽出 | REST/GraphQL API, DB Dump |
| **Transform** | スキーママッピング、フィールド変換、リッチテキスト正規化 | Node.js Script, Apache Airflow |
| **Load** | ターゲットCMSにManagement APIで書き込み | CMS SDK, Bulk Import API |

### 72.2. スキーママッピング

- **Rule 34.105**: ソースCMSとターゲットCMSのコンテンツモデル差異を**スキーママッピングテーブル**で定義し、変換ルールをコードで管理する

| マッピング項目 | 説明 |
|:---|:---|
| **フィールド名変換** | `body` → `content`, `hero_image` → `featured_media` 等 |
| **型変換** | Rich Text → JSON, Markdown → HTML 等 |
| **参照解決** | 旧ID → 新ID のマッピングテーブルを構築 |
| **デフォルト値** | ターゲットCMSの必須フィールドに対するデフォルト値定義 |
| **検証ルール** | 移行後データのバリデーション（Schema Validation） |

### 72.3. 増分同期（Delta Sync）

- **Rule 34.106**: 大規模移行では、初回フルインポート後に**増分同期（Delta Sync）** を実行し、移行期間中のコンテンツ更新を反映する
  - ソースCMSの`updated_at`タイムスタンプを基準に差分を取得する
  - 並行運用期間は双方向同期ではなく**一方向同期（Source → Target）** を原則とする
  - **移行完了判定**: ソースとターゲットのコンテンツ件数・ハッシュ一致で移行完了を判定する

### 72.4. 移行リスク管理

- **Rule 34.107**: CMS移行はリスクの高いオペレーションであり、以下のセーフガードを義務付ける
  - **Dry Run**: 本番移行前にステージング環境でフルリハーサルを実施する
  - **Rollback Plan**: 移行失敗時の切り戻し手順を事前に文書化する
  - **Content Freeze**: 本番移行実行中はソースCMSでのコンテンツ編集を凍結する
  - **SEO監視**: 移行後30日間、Search Consoleのインデックスカバレッジを日次監視する

---

## Part LXXIII: CMS SDK & 開発者体験（DX）

### 73.1. TypeScript SDK設計

- **Rule 34.108**: Headless CMS APIに対する**TypeScript SDK**を提供し、型安全なコンテンツアクセスを保証する

| 設計原則 | 説明 |
|:---|:---|
| **型自動生成** | CMSスキーマ定義からTypeScript型定義を自動生成する（`codegen`） |
| **Null Safety** | オプショナルフィールドは`T | undefined`として型で表現する |
| **Builder Pattern** | クエリビルダーはメソッドチェーンで型安全にフィルタ・ソート・ページネーションを構築する |
| **Tree-Shakable** | 未使用のAPI関数がバンドルに含まれないようESMで提供する |
| **Error Typing** | APIエラーを型付きエラー型（`CmsApiError`）で返し、`instanceof`で分岐可能にする |

```typescript
// ✅ 型安全なCMSクエリ例
const articles = await cms.getEntries<Article>({
  contentType: 'article',
  where: { status: 'published', category: 'tech' },
  orderBy: 'publishedAt',
  limit: 10,
  include: ['author', 'tags'],
});
// articles は Article[] 型で推論される
```

### 73.2. 開発者ポータル & Sandbox

- **Rule 34.109**: CMS APIを利用する開発者向けに以下を提供する

| 提供物 | 説明 |
|:---|:---|
| **インタラクティブAPI Playground** | ブラウザ上でAPIを試行できるサンドボックス（GraphiQL / Swagger UI） |
| **クイックスタートガイド** | 5分以内にコンテンツ取得が完了するチュートリアル |
| **サンプルプロジェクト** | Next.js, Nuxt, Astro等の主要フレームワーク別スターターテンプレート |
| **Changelog** | APIバージョニングと破壊的変更の事前通知（Deprecation Notice 90日前） |
| **Status Page** | APIの稼働状況とインシデント履歴の公開ページ |

### 73.3. CMS CLI ツール

- **Rule 34.110**: CMS環境の管理・コンテンツ操作をCLIで実行可能にする
  - `cms pull` — 本番コンテンツモデルをローカルにエクスポート
  - `cms push` — ローカルのスキーマ変更を環境に適用
  - `cms diff` — 環境間のスキーマ差異を表示
  - `cms seed` — 開発用サンプルデータの投入
  - `cms migrate` — スキーママイグレーションの適用
- **Cross-Reference**: `300_engineering_standards.md`（CLI設計原則）

---

## Part LXXIV: モバイルアプリ向けHeadless CMS（App Content）

### 74.1. モバイルアプリコンテンツ配信

- **Rule 34.111**: モバイルアプリ向けCMSコンテンツ配信は、Web向けとは異なる以下の要件を満たす設計を義務付ける

| 要件 | 説明 |
|:---|:---|
| **オフラインファースト** | ネットワーク切断時もキャッシュ済みコンテンツを閲覧可能にする |
| **差分同期（Delta Sync）** | 前回同期以降の変更分のみを取得し、帯域消費を最小化する |
| **バージョン互換性** | 旧アプリバージョンにも対応するAPIバージョニング戦略を維持する |
| **Push通知連動** | コンテンツ公開をトリガーにPush通知を自動送信する |
| **Deep Link対応** | CMS内のコンテンツとアプリ内画面を1:1でマッピングする |

### 74.2. モバイルローカルキャッシュ戦略

- **Rule 34.112**: モバイルアプリでのCMSコンテンツキャッシュは以下の階層で設計する

| 層 | 実装 | 用途 |
|:---|:---|:---|
| **メモリキャッシュ** | In-Memory Map / LRU | アクティブ画面のコンテンツ |
| **ディスクキャッシュ** | SQLite / Realm | オフライン閲覧用の永続化 |
| **画像キャッシュ** | Coil (Android) / Kingfisher (iOS) | メディアアセットのローカルキャッシュ |

- **TTL管理**: コンテンツタイプ毎にキャッシュTTLを設定し、ニュースは短い（5分）、ヘルプ記事は長い（24時間）等の使い分けを行う
- **キャッシュ無効化**: Push通知でサイレントプッシュを送信し、特定コンテンツのキャッシュ無効化をトリガーする

### 74.3. モバイルAPI最適化

- **Rule 34.113**: モバイル向けAPIは以下の最適化を適用する
  - **フィールド選択**: 必要なフィールドのみ返す`fields`パラメータ（Over-Fetching防止）
  - **レスポンス圧縮**: Brotli / gzip圧縮を必須とする
  - **ペイロードサイズ制限**: 1レスポンスあたり500KB以下を目標とする
  - **Batch API**: 複数コンテンツ取得を1リクエストに集約するBatch APIを提供する

---

## Part LXXV: Webhookオーケストレーション & Sagaパターン深化

### 75.1. Webhook Orchestration設計

- **Rule 34.114**: コンテンツ公開に連動する複数のWebhookアクションを**オーケストレーション**として設計し、依存関係・実行順序・エラーハンドリングを明示的に定義する

```
Content Published Event
│
├─[1] Parallel:
│   ├── ISR Revalidation
│   ├── CDN Cache Purge
│   └── Analytics Event
│
├─[2] Sequential (1完了後):
│   ├── Search Index Update → [3] SEO Validation
│   └── RSS/Sitemap Regeneration
│
└─[4] Conditional:
    ├── (if multilingual) → Translation Queue
    └── (if featured) → Social Media Auto-Share
```

### 75.2. Dead Letter Queue（DLQ）運用

- **Rule 34.115**: Webhook配信に失敗した場合の**Dead Letter Queue**を設計し、手動/自動リトライを可能にする

| 設計項目 | 仕様 |
|:---|:---|
| **リトライ戦略** | Exponential Backoff（1s → 2s → 4s → 8s → 16s）、最大5回 |
| **DLQ保存期間** | 7日間保持。期限後は管理者通知の上アーカイブ |
| **リプレイ機能** | DLQから任意のイベントを選択し手動リプレイを実行可能にする |
| **アラート** | DLQ滞留数が閾値（50件）を超えた場合に即時アラート |
| **べき等性** | すべてのWebookハンドラはべき等（idempotent）に設計する |

### 75.3. Saga Pattern深化

- **Rule 34.116**: コンテンツ公開に連動する複数サービスの整合性を**Saga Pattern**で保証する
  - **Orchestration Saga**: コーディネーターが各ステップを逐次実行し、失敗時は補償トランザクション（Compensating Transaction）を実行する
  - **例**: 公開 → 翻訳開始 → 翻訳失敗 → 公開ステータスを「翻訳保留」に戻す
  - **タイムアウト**: 各ステップに最大実行時間を設定し、タイムアウト時は補償トランザクションを実行する
- **Cross-Reference**: `300_engineering_standards.md`（分散トランザクション設計）、Part LXVIII（Event-Driven Architecture）

---

## Part LXXVI: コンテンツコンプライアンス自動化（PII/GDPR/DSA）

### 76.1. コンテンツPII自動検出

- **Rule 34.117**: CMSに入稿されるコンテンツに対し、**PII（個人識別情報）の自動検出**を実施する

| 検出対象 | 手法 | 対応 |
|:---|:---|:---|
| **電話番号** | 正規表現 + NLP | 入稿時に警告表示 |
| **メールアドレス** | 正規表現 | 自動マスキング提案 |
| **住所** | NER（固有表現認識） | レビュー時にフラグ |
| **マイナンバー/SSN** | パターンマッチング | 即時ブロック + 管理者通知 |
| **顔画像** | AI顔検出 | 同意確認フロー開始 |

### 76.2. GDPR Right to Erasure対応

- **Rule 34.118**: GDPR第17条（忘れられる権利）に対応し、CMS内のコンテンツから特定個人に関するデータを**体系的に削除**するワークフローを実装する
  - **スキャン**: 対象者の名前・メールアドレスで全コンテンツを横断検索する
  - **確認**: 削除対象コンテンツの一覧を管理者に提示し、承認を得る
  - **削除**: コンテンツ本文、メタデータ、メディア（顔画像含む）、リビジョン履歴から対象データを削除する
  - **証跡**: 削除完了の監査ログを保持する（削除内容自体は保持しない）
- **Cross-Reference**: `601_data_governance.md`（GDPR対応）

### 76.3. DSA透明性レポート自動化

- **Rule 34.119**: EU DSA（Digital Services Act）のコンテンツモデレーション透明性レポートに必要なデータを自動収集する
  - モデレーション件数（カテゴリ別、対応種別別）
  - 平均対応時間（検出→非公開）
  - 異議申立て件数と復元率
  - AI自動判定の精度（False Positive / False Negative率）
- **Cross-Reference**: `601_data_governance.md`（DSA対応）、Part XXXVIII（コンテンツモデレーション）

---

## Part LXXVII: CMS APIレートリミット & クォータ管理

### 77.1. 階層型Rate Limiting

- **Rule 34.120**: CMS APIのRate Limitingを以下の階層で設計する

| 階層 | 制限 | 適用先 |
|:---|:---|:---|
| **Global** | 10,000 req/min | API全体 |
| **Per Tenant** | 2,000 req/min | マルチテナント環境 |
| **Per API Key** | 500 req/min | アプリケーション単位 |
| **Per Endpoint** | 100 req/min | 高負荷エンドポイント（検索、GraphQL） |
| **Per User** | 60 req/min | 管理画面操作 |

### 77.2. Quota Management

- **Rule 34.121**: SaaS CMS利用時のAPIクォータを以下の仕組みで管理する
  - **使用量ダッシュボード**: リアルタイムのAPI使用量（コール数、帯域幅、ストレージ）を可視化する
  - **アラート閾値**: 80%到達でWarning、90%到達でCriticalアラートを発報する
  - **バースト制御**: Token Bucket Algorithm でバーストトラフィックを平滑化する
  - **Fair Queuing**: 複数クライアント間で公平にAPI帯域を分配する

### 77.3. Rate Limitレスポンス設計

- **Rule 34.122**: Rate Limit超過時のHTTPレスポンスを以下の仕様で設計する
  - ステータスコード: `429 Too Many Requests`
  - `Retry-After` ヘッダー: 次回リクエスト可能時刻（秒数またはHTTP-date）を返す
  - `X-RateLimit-Limit` / `X-RateLimit-Remaining` / `X-RateLimit-Reset` ヘッダーで現在の制限状況を通知する
  - **Graceful Degradation**: CDNキャッシュで配信可能なGETリクエストはRate Limit適用外とする

---

## Part LXXVIII: CDN深化 (Stale-While-Revalidate / ESI)

### 78.1. Stale-While-Revalidate戦略

- **Rule 34.123**: CMSコンテンツのCDN配信において、**Stale-While-Revalidate（SWR）** パターンを適用し、キャッシュ更新中も古いコンテンツを返してユーザー体験を維持する

```
Cache-Control: public, max-age=60, stale-while-revalidate=3600, stale-if-error=86400
```

| ディレクティブ | 用途 |
|:---|:---|
| `max-age=60` | 60秒間はキャッシュを新鮮とみなす |
| `stale-while-revalidate=3600` | max-age経過後1時間は古いキャッシュを返しながらバックグラウンドで更新 |
| `stale-if-error=86400` | オリジン障害時は24時間古いキャッシュで配信継続 |

### 78.2. Edge Side Includes (ESI)

- **Rule 34.124**: ページ内の動的コンテンツ断片（パーソナライズヘッダー、ユーザーメニュー等）をESIで分離し、静的コンテンツのキャッシュ効率を最大化する
  - **テンプレート**: `<esi:include src="/api/user-header" />` でページ内断片を遅延取得する
  - **TTL分離**: 静的コンテンツ（記事本文）は長TTL、動的断片は短TTLまたはno-cacheとする
  - **フォールバック**: `<esi:try>` / `<esi:except>` でESI取得失敗時のデフォルト表示を定義する

### 78.3. CDN Shielding & Cache Warming

- **Rule 34.125**: 大規模トラフィック時のオリジン保護とキャッシュ効率化を設計する
  - **CDN Shielding**: 1つのPoPをシールドとしてオリジン前段に配置し、他PoPはシールド経由でオリジンにアクセスする
  - **Cache Warming**: コンテンツ公開直後にPOP全体にプリフェッチリクエストを発行し、キャッシュミスによるオリジン集中を防止する
  - **Request Coalescing**: 同一URLへの同時リクエストをCDNが束ねて1リクエストにまとめる設定を有効化する

---

## Part LXXIX: CMS Monorepo & マルチサイトアーキテクチャ

### 79.1. マルチサイト設計

- **Rule 34.126**: 1つのCMSインスタンスで複数サイト/ブランドを管理する場合、以下のアーキテクチャパターンを選択する

| パターン | 説明 | 推奨ケース |
|:---|:---|:---|
| **Shared Model** | コンテンツモデルを全サイト共有 | ブランド統一の複数地域サイト |
| **Per-Site Model** | サイト毎にコンテンツモデルを独立定義 | 異業種マルチブランド |
| **Hybrid** | 共通モデル（ヘッダー、フッター、FAQ）+ サイト固有モデル | 最も柔軟 |

### 79.2. コンテンツ共有 & 分離

- **Rule 34.127**: マルチサイト環境でのコンテンツ共有・分離ルール
  - **共有コンテンツ**: 企業概要、プライバシーポリシー等は「グローバルコンテンツ」として全サイトで参照する（Single Source of Truth）
  - **サイト固有コンテンツ**: 各サイト専用のコンテンツは`site_id`フィールドで分離し、APIクエリでフィルタする
  - **オーバーライド**: グローバルコンテンツの一部をサイト固有にオーバーライドする仕組み（Locale per Siteと類似）を提供する

### 79.3. Monorepo構成

- **Rule 34.128**: 複数サイトのフロントエンドを1つのMonorepoで管理する場合の推奨構成

```
monorepo/
├── packages/
│   ├── cms-client/          # CMS SDK（共通）
│   ├── shared-components/   # 共通UIコンポーネント
│   └── content-types/       # CMSスキーマ型定義（codegen）
├── apps/
│   ├── site-a/              # サイトA（Next.js）
│   ├── site-b/              # サイトB（Next.js）
│   └── site-c/              # サイトC（Astro）
└── turbo.json               # ビルドパイプライン定義
```

- **依存関係**: `cms-client` と `content-types` は全サイトで共有し、CMS SDK更新時は全サイトに自動で反映する
- **Cross-Reference**: `300_engineering_standards.md`（Monorepo管理）

---

## Part LXXX: CMS開発者ポータル & APIドキュメント

### 80.1. APIドキュメント自動生成

- **Rule 34.129**: CMS APIのドキュメントをスキーマ定義から**自動生成**し、実装とドキュメントの乖離を物理的に防止する

| API方式 | ドキュメント形式 | 生成ツール例 |
|:---|:---|:---|
| **REST** | OpenAPI 3.1 Specification | Swagger Codegen / Redocly |
| **GraphQL** | GraphQL Schema + Introspection | GraphiQL / Apollo Sandbox |
| **SDKリファレンス** | TypeDoc / Typedoc | TypeDoc (`tsdoc`) |

### 80.2. インタラクティブAPI Playground

- **Rule 34.130**: 開発者がブラウザ上でAPIを試行できるPlaygroundを提供する
  - **認証**: テスト用APIキーをPlayground内で発行可能にする（本番キーではない）
  - **サンプルデータ**: Sandboxモードで事前投入されたサンプルコンテンツを用意する
  - **コード生成**: Playground上のリクエストからcURL / JavaScript / Python等のクライアントコードを自動生成する
  - **バージョン切替**: APIバージョンを切り替えてレスポンスの差異を確認可能にする

### 80.3. APIバージョニングポリシー

- **Rule 34.131**: CMS APIのバージョニングは以下のポリシーに従う

| 項目 | ポリシー |
|:---|:---|
| **バージョニング方式** | URLパス (`/v1/`, `/v2/`) またはヘッダー (`X-API-Version`) |
| **Deprecation Notice** | 破壊的変更の90日前に通知 |
| **Sunset Header** | 廃止予定日を`Sunset`ヘッダーで通知 |
| **サポート期間** | 旧バージョンは最低12ヶ月間サポート |
| **Breaking Change定義** | フィールド削除、型変更、必須フィールド追加を破壊的変更とする |

- **Cross-Reference**: `301_api_integration.md`（APIバージョニング）

---

## Appendix A: 逆引き索引

| タスク・キーワード | 参照先 |
|:---|:---|
| CMS選定 | Part III |
| MACH認証 | Part III (3.5) |
| コンテンツモデリング | Part IV-VII |
| API設計（REST） | Part VIII |
| GraphQL / Federation | Part IX |
| Webhook / CloudEvents | Part X |
| メディア管理 | Part XI-XIII |
| DAM統合 | Part XIV |
| SSG/ISR/SSR | Part XV |
| CDN | Part XVI |
| キャッシュ | Part XVII |
| リッチテキスト / Tiptap | Part XVIII-XX |
| 公開ワークフロー | Part XXI-XXII |
| スケジューリング | Part XXIII |
| リビジョン管理 | Part XXIV |
| プレビュー | Part XXV-XXVI |
| HTTP ステータス / 404 | Part XXVII |
| ページビルダー | Part XXVIII-XXIX |
| SEO / Schema.org | Part XXX-XXXI |
| AI統合 / RAG / MCP | Part XXXII-XXXV |
| A2A Protocol | Part XXXV (35.3) |
| セキュリティ / OWASP | Part XXXVI-XXXVII |
| C2PA / Content Credentials | Part XXXVII (37.2), LXI |
| モデレーション / UGC | Part XXXVIII |
| アクセシビリティ | Part XXXIX |
| 多言語 / 翻訳 | Part XL |
| パーソナライゼーション | Part XLI |
| コンテンツガバナンス | Part XLII |
| Content as Code | Part XLIII |
| CMS移行 | Part XLIV |
| コンテンツフェデレーション | Part XLV |
| リアルタイムコラボレーション | Part XLVI |
| A/Bテスト | Part XLVII |
| Server-Driven UI | Part XLVIII |
| エディタ体験 | Part XLIX |
| テスト戦略 | Part L |
| パイプライン自動化 | Part LI |
| マルチテナント | Part LII |
| 災害復旧 | Part LIII |
| 規制コンプライアンス | Part LIV |
| GEO | Part LV |
| Green IT | Part LVI |
| 可観測性 / FinOps | Part LVII |
| 成熟度モデル | Part LVIII |
| アンチパターン | Part LIX |
| AI Visual Editor / No-Code | Part LXII |
| コンテンツ運用チーム | Part LXIII |
| ヘッドレスコマース | Part LXIV |
| Edge CMS | Part LXV |
| コンテンツ分析 | Part LXVI |
| コンテンツグラフ | Part LXVII |
| イベント駆動 | Part LXVIII |
| 翻訳品質管理 / MTPE / MQM | Part LXIX |
| コンテンツデザインシステム | Part LXX |
| パフォーマンスバジェット / CWV / INP | Part LXXI |
| コンテンツ移行 / ETL | Part LXXII |
| CMS SDK / 開発者体験 | Part LXXIII |
| モバイルアプリコンテンツ | Part LXXIV |
| Webhookオーケストレーション / Saga / DLQ | Part LXXV |
| PII検出 / GDPR / DSA自動化 | Part LXXVI |
| APIレートリミット / クォータ | Part LXXVII |
| CDN SWR / ESI / シールディング | Part LXXVIII |
| マルチサイト / Monorepo | Part LXXIX |
| 開発者ポータル / APIドキュメント | Part LXXX |

---

## Appendix B: クロスリファレンス

| 関連ルールファイル | 参照理由 |
|:---|:---|
| [000_core_mindset.md](../core/000_core_mindset.md) | Headless First原則、既存機能保護 |
| [200_design_ux.md](../design/000_design_ux.md) | アクセシビリティ、デザインシステム、Content Design System |
| [300_engineering_standards.md](../engineering/000_engineering_standards.md) | CI/CD、コーディング規約、Event-Driven設計 |
| [340_web_frontend.md](../engineering/300_web_frontend.md) | Next.js、パフォーマンスバジェット、Edge Functions |
| [301_api_integration.md](../engineering/100_api_integration.md) | API設計、エラーハンドリング、CloudEvents |
| [320_supabase_architecture.md](../engineering/200_supabase_architecture.md) | DB設計、RLS、Storage |
| [400_ai_engineering.md](../ai/000_ai_engineering.md) | RAG、AI生成コンテンツ、EU AI Act、MCP、Agentic AI、A2A |
| [600_security_privacy.md](../security/000_security_privacy.md) | Zero Trust、認証認可、OWASP、C2PA |
| [601_data_governance.md](../security/100_data_governance.md) | GDPR、プライバシー、DSA |
| [602_oss_compliance.md](../security/200_oss_compliance.md) | 依存関係管理 |
| [800_internationalization.md](../product/800_internationalization.md) | i18n、多言語、グローバル展開、MTPE |
| [802_language_protocol.md](../core/200_language_protocol.md) | CMS言語ガバナンス |

