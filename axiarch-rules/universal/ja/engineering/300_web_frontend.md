# 33. Webフロントエンドエンジニアリング (Web Frontend Engineering)

> [!CAUTION]
> **このファイルは Universal Rule（不変ルール）です。「憲法改正」の明示的指示がない限り編集禁止。**
> 改定日: 2026-03-24 | 対象: Next.js 16+ / React 19.2+ / TypeScript 5.x

> [!IMPORTANT]
> **Supreme Directive（最高指令）**
> 「フロントエンドはユーザーとプロダクトの唯一の接点であり、妥協は許されない。」
> パフォーマンス・アクセシビリティ・セキュリティの三位一体を実現し、ユーザー体験の最高水準を保証せよ。
> Webフロントエンド実装において、**セキュリティ > パフォーマンス > アクセシビリティ > UX > 保守性 > 開発速度** の優先順位を厳守せよ。
> この文書はWebフロントエンドに関するすべての設計判断の最上位基準である。
> **54パート・約340セクション構成。**

> [!NOTE]
> **適用スコープアイコン**
> 各Partの冒頭に適用スコープを明示する:
> - 🌐 **Universal** — フレームワーク非依存。どのWeb技術スタックにも適用
> - ⚛️ **React / Next.js** — React 19+ / Next.js 15+ 固有のルール
> - 🔀 **Hybrid** — 汎用原則を含むが、コードスニペットはReact/Next.js向け

---

## 目次

| Part | トピック | スコープ | セクション |
|------|---------|---------|-----------|
| I | 哲学と基本原則 | 🌐 | §1–§3 |
| II | 技術スタック標準 | ⚛️ | §4–§5, §301 |
| III | Next.js App Router アーキテクチャ | ⚛️ | §6–§11, §302 |
| IV | Server Components & Client Components | ⚛️ | §12–§15 |
| V | Edge Computing & Middleware | ⚛️ | §16–§18 |
| VI | UIコンポーネント設計 | 🔀 | §19–§24 |
| VII | CSSアーキテクチャ | 🌐 | §25–§31, §303–§304 |
| VIII | コンポーネント設計原則 | 🔀 | §32–§36 |
| IX | React Hooks ベストプラクティス | ⚛️ | §37–§42 |
| X | React 19 新API & React Compiler | ⚛️ | §43–§48, §305–§306, §305b–§305d |
| XI | Hydration & SSR安定性 | ⚛️ | §49–§53 |
| XII | フォーム設計（React Hook Form + Zod） | 🔀 | §54–§60 |
| XIII | フォーム高度パターン | 🔀 | §61–§66 |
| XIV | 入力UX最適化 | 🌐 | §67–§71 |
| XV | バリデーション & フロントエンドセキュリティ | 🌐 | §72–§78 |
| XVI | State Management | 🔀 | §79–§83 |
| XVII | Data Fetching & キャッシュ | ⚛️ | §84–§90 |
| XVIII | パフォーマンス最適化 | 🌐 | §91–§98, §307–§308 |
| XIX | 画像・フォント・スクリプト最適化 | 🔀 | §99–§105 |
| XX | SEO & メタデータ | 🌐 | §106–§112 |
| XXI | Technical SEO & GEO | 🌐 | §113–§117 |
| XXII | アクセシビリティ（A11y） | 🌐 | §118–§124 |
| XXIII | PWA & クロスプラットフォーム | 🌐 | §125–§129 |
| XXIV | 国際化（i18n） | 🌐 | §130–§133 |
| XXV | エラーハンドリング & レジリエンス | 🔀 | §134–§139 |
| XXVI | Server Actions & API安全性 | ⚛️ | §140–§146 |
| XXVII | データ可視化 & エクスポート | 🔀 | §147–§150 |
| XXVIII | AdTech & マーケティングエンジニアリング | 🌐 | §151–§155, §155b |
| XXIX | テスト戦略 | 🔀 | §156–§163 |
| XXX | デプロイ & インフラ | 🔀 | §164–§169 |
| XXXI | モダンWeb Platform API | 🌐 | §170–§179, §309–§310 |
| XXXII | フロントエンド可観測性 & RUM | 🌐 | §180–§185 |
| XXXIII | AI統合 & LLMストリーミングUI | 🔀 | §186–§191 |
| XXXIV | Micro-Frontend & Module Federation | 🌐 | §192–§196 |
| XXXV | Web Worker & Off-Main-Thread | 🌐 | §197–§200 |
| XXXVI | フロントエンドセキュリティ深化 | 🌐 | §201–§206, §203b, §206b |
| XXXVII | フロントエンドFinOps | 🌐 | §207–§209 |
| XXXVIII | デザインシステム統合 | 🌐 | §210–§214 |
| XXXIX | 禁止アンチパターン集（30選） | 🌐 | §215–§244 |
| XL | Monorepo & Multi-App 戦略 | 🔀 | §245–§249 |
| XLI | リアルタイム通信 | 🌐 | §250–§253 |
| XLII | 認証UI & セッション管理 | 🔀 | §254–§258 |
| XLIII | Animation & Motion Design | 🌐 | §259–§264 |
| XLIV | レスポンシブ & マルチデバイス | 🌐 | §265–§270 |
| XLV | E-Commerce フロントエンド | 🔀 | §271–§276 |
| XLVI | フロントエンドDevOps | 🌐 | §277–§282 |
| XLVII | サードパーティスクリプト管理 | 🌐 | §283–§287 |
| XLVIII | Sustainability & Green Frontend | 🌐 | §288–§292 |
| XLIX | 成熟度モデル・将来展望 | 🌐 | §293–§300 |
| L | 逆引き索引・クロスリファレンス | — | Appendix |
| LI | Next.js 16 移行 & 新機能 | ⚛️ | §311–§316 |
| LII | GraphQL Frontend Architecture | 🌐 | §317–§320 |
| LIII | 型安全APIクライアント & tRPC | 🔀 | §321–§324 |
| LIV | フロントエンドデータ品質 & Schema Contract | 🌐 | §325–§330 |

---

## Part I: 哲学と基本原則 🌐

### §1. Supreme Directive — Webフロントエンド・エクセレンス

- **Rule 33.1**: フロントエンドはビジネスの最前線である。パフォーマンス劣化・アクセシビリティ欠如・セキュリティ欠陥は即座にビジネスインパクトに直結する
- **優先順位**: セキュリティ > パフォーマンス > アクセシビリティ > UX > 保守性 > 開発速度
- **ゼロ妥協**: Core Web Vitals（LCP ≤ 2.5s / INP ≤ 200ms / CLS ≤ 0.1）は「目標」ではなく「デプロイゲート」
- **最新安定版**: 常にフレームワーク・ライブラリの最新安定版を前提とする。非推奨APIの新規使用は禁止
- **型安全**: TypeScript Strictモード必須。`any`型の使用は原則禁止
- **Privacy by Design**: ユーザーデータの収集は最小限、サーバーサイド処理を最優先

### §2. アーキテクチャ原則

- **Rule 33.2**: Server First — データ取得・ビジネスロジックはサーバーサイドで実行。クライアントには最小限のインタラクティブ機能のみ
- **Rule 33.3**: Composition over Inheritance — コンポーネントは継承ではなく合成で設計
- **Progressive Enhancement**: JavaScriptが無効でもコアコンテンツは閲覧可能な設計を目指す
- **Defensive Programming**: 全外部入力（API、URL Params、User Input）を疑い、境界でのバリデーションを徹底
- **Fail Fast**: 環境変数の欠落・型の不整合は起動時にクラッシュさせ、本番での不可解な挙動を物理的に防止

### §3. 汎用原則 vs フレームワーク固有

- **Rule 33.4**: 本ルールは「汎用Webフロントエンド原則（🌐）」と「Next.js / React固有のベストプラクティス（⚛️）」を包含する。各Part冒頭のスコープアイコンで適用範囲を明示する
- **Framework Agnostic (🌐)**: CWV最適化、CSS設計、A11y、SEO、セキュリティ等は特定フレームワークに依存しない汎用ルール
- **Framework Specific (⚛️)**: RSC、App Router、React Hooks、Server Actions等はNext.js/React固有ルール
- **Hybrid (🔀)**: 原則は汎用だが、コードスニペットや具体的実装がReact/Next.js向け
- **Cross-Reference**: `300_engineering_standards.md`, `200_design_ux.md`

> [!TIP]
> **React非依存プロジェクトへの適用ガイド**
> 本ルールは React/Next.js を主要ターゲットとするが、🌐 スコープのPartは**任意のWebフロントエンド技術スタック**（Vue/Nuxt、Svelte/SvelteKit、Astro、Vanilla JS等）にそのまま適用可能である。
> React非依存プロジェクトで単独運用可能な🌐Partの一覧:
> Part I（哲学）/ VII（CSS）/ XIV（入力UX）/ XV（セキュリティ）/ XVIII（パフォーマンス）/ XX–XXI（SEO/GEO）/ XXII（A11y）/ XXIII（PWA）/ XXIV（i18n）/ XXVIII（AdTech）/ XXXI（Web Platform API）/ XXXII（可観測性）/ XXXIV（Micro-Frontend）/ XXXV（Web Worker）/ XXXVI（セキュリティ深化）/ XXXVII（FinOps）/ XXXVIII（デザインシステム）/ XXXIX（アンチパターン）/ XLI（リアルタイム通信）/ XLIII（Animation）/ XLIV（レスポンシブ）/ XLVII（サードパーティスクリプト）/ XLVIII（Sustainability）/ XLIX（成熟度モデル）

---

## Part II: 技術スタック標準 ⚛️

### §4. 推奨技術スタック

| レイヤー | 標準技術 | 備考 |
|:---------|:---------|:-----|
| **フレームワーク** | Next.js 16+ (App Router) | Pages Router は既存維持のみ |
| **UI ライブラリ** | React 19.2+ | Server Components 標準 |
| **言語** | TypeScript 5.x (Strict) | JavaScript は禁止 |
| **スタイリング** | Tailwind CSS 4+ / shadcn/ui | Design Token 管理必須 |
| **フォーム** | React Hook Form + Zod | Schema-Driven Development |
| **状態管理** | Server State: RSC / Client: Zustand or Jotai | Redux は新規禁止 |
| **テスト** | Vitest + Playwright + Storybook | Testing Trophy 準拠 |
| **リンター** | ESLint (Flat Config) + Prettier / Biome | Zero Warnings 必須 |
| **ビルド** | Turbopack (Next.js 16 default) + FS Caching | Webpack は既存維持のみ |
| **パッケージ管理** | pnpm 推奨 | lockfile コミット必須 |

### §5. バージョン管理・依存関係

- **Rule 33.5**: `package.json` の依存関係はCaret Range（`"react": "^19.1.0"`）を使用し、パッチ/マイナーアップデートを自動取得する。ただし**lockfileのコミットを必須**とする
- **Renovate/Dependabot**: 依存関係の自動更新PRを有効化し、21日間の安定期間後にマージする
- **The Freshness Obligation**: 外部サービスSDK（AI、Auth、Payment等）は進化が速い。新規実装では常に最新版を使用し、問題発生時は「まずアップデート」を第一解決策とする
- **Cross-Reference**: `602_oss_compliance.md`
- **Next.js 16 破壊的変更対応**: Next.js 16へのアップグレード時は Node.js 20.9+ および TypeScript 5+ が必須。AMPサポートは廃止済み。`middleware.ts` は `proxy.ts` に移行（詳細は Part LI 参照）

### §301. Tailwind CSS 4 Deep Dive

- **Rule 33.294**: Tailwind CSS 4の新アーキテクチャを理解し、最大限に活用する
- **CSS-First Configuration**: `tailwind.config.ts` から CSS 内の `@theme` ディレクティブへ移行。設定をCSS内で完結させる
- **Oxide Engine**: Rust製の新エンジンにより、ビルド速度が最大10倍高速化。Turbopack との統合で開発体験が飛躍的に向上
- **`@layer` 統合**: Tailwind v4 は CSS `@layer` を組み込み活用。ユーティリティ・コンポーネント・ベースの3層をネイティブで管理
- **Lightning CSS**: PostCSS依存を削減し、Lightning CSSによるネイティブCSSトランスパイルを活用
- **Zero-Config Content Detection**: `@source` ディレクティブにより、自動コンテンツ検出の精度が向上。手動の `content` 配列設定が不要に

```css
/* ✅ Tailwind CSS 4 — CSS-First Configuration */
@import "tailwindcss";

@theme {
  --color-brand: #6366f1;
  --color-brand-light: #818cf8;
  --font-display: "Inter", sans-serif;
  --breakpoint-3xl: 1920px;
}
```

---

## Part III: Next.js App Router アーキテクチャ ⚛️

### §6. App Router & React Server Components

- **Rule 33.6**: **App Router**を原則とし、Server Components（RSC）でのレンダリングを最大化する。クライアントに送信するJavaScript量を劇的に削減する
- **Data Fetching**: サーバーサイドでデータを取得し、ウォーターフォールを回避する
- **The Server-Only Import Protocol（Bundle Protection）**:
    - **Rule 33.7**: サーバー専用ファイル（`lib/api/*`, `lib/actions/*`等）には `import 'server-only'` を必須で含める
    - **効果**: Client Componentsから誤ってインポートされた場合にビルドエラーとなり、機密ロジックやAPIキーのクライアントバンドル混入を物理的に防止

### §7. ディレクトリオントロジー

- **`src/app`**: ルーティング定義のみ。ロジック禁止
- **`src/lib/actions`**: Server Actions（データのゲートウェイ）
- **`src/lib/gateway`**: データアクセス層（DB/外部API）
- **`src/components`**: UIパーツ。`ui`（汎用）と `features`（機能固有）に分離
- **`src/hooks`**: カスタムフック
- **`src/types`**: 型定義・DTO
- **The Static Page Prohibition（No Hardcoding）**:
    - **Rule 33.8**: コンテンツ中心のページ（利用規約、プライバシーポリシー等）をハードコーディングすることは禁止。Headless CMSから配信し、動的ルーティングで処理すること
- **The Anti-Haribote UI Protocol（Realism Mandate）**:
    - **Rule 33.9**: DBスキーマに存在しない「将来のカラム」や「曖昧なJSON」を正規化データとして扱うUI実装は禁止

### §8. 環境変数バリデーション

- **Rule 33.10**: `process.env` の直接使用は禁止。`t3-env` または `zod` で環境変数の型と存在を起動時にバリデーションする。必要なキーが欠落している場合、アプリは起動してはならない

```typescript
// ✅ t3-env による型安全な環境変数
import { createEnv } from "@t3-oss/env-nextjs";
import { z } from "zod";

export const env = createEnv({
  server: {
    DATABASE_URL: z.string().url(),
    API_SECRET: z.string().min(32),
  },
  client: {
    NEXT_PUBLIC_SITE_URL: z.string().url(),
  },
  runtimeEnv: {
    DATABASE_URL: process.env.DATABASE_URL,
    API_SECRET: process.env.API_SECRET,
    NEXT_PUBLIC_SITE_URL: process.env.NEXT_PUBLIC_SITE_URL,
  },
});
```

### §9. Site Settings Architecture

- **Runtime Injection**: テーマカラー等の設定はDBからランタイム（RootLayout）で取得し、CSS変数として注入する。ビルド時ではなくランタイムで設定することで、再ビルド不要のデザイン変更を実現

### §10. Next.js 15 Async API プロトコル

- **Rule 33.11**: Next.js 15以降、`params`, `searchParams`, `headers`, `cookies`, `draftMode` は Awaitable（Promise）である
- **Action**: これらを参照する際は必ず `await` または React の `use()` フックを使用する

### §11. Partial Prerendering (PPR)

- **Rule 33.12**: Next.js 15のPartial Prerendering（PPR）を活用し、静的シェルと動的コンテンツの最適な組み合わせを実現する
- **Static Shell**: ページのレイアウト・ナビゲーション・静的コンテンツは即座に配信される静的シェルとしてプリレンダリング
- **Dynamic Streaming**: ユーザー固有コンテンツ（認証状態、パーソナライズ等）は `<Suspense>` 境界内で動的にストリーミング
- **Action**: `experimental.ppr: true` を `next.config.ts` で有効化し、ページ単位で `export const experimental_ppr = true` を宣言
- **Next.js 16 Cache Components**: PPRの安定版として `'use cache'` ディレクティブがGA化。動的コンポーネント内でもキャッシュ境界を宣言可能

### §302. The next/after API Protocol

- **Rule 33.295**: Next.js 15+ の `after()` API を活用し、レスポンス送信後の非ブロッキング処理を実装する
- **Use Cases**: ログ記録、アナリティクスイベント送信、キャッシュ無効化等のレスポンスに影響しないサイドエフェクト
- **Advantage**: `waitUntil` と異なり `after()` はServer Actions・Route Handlers・Middleware・`generateMetadata` 内で使用可能
- **Error Isolation**: `after()` 内のエラーはメインレスポンスに影響しない。ただし `try-catch` で隔離し、エラーログを確保すること

```typescript
// ✅ next/after による非ブロッキングログ
import { after } from 'next/server';

export async function POST(request: Request) {
  const data = await processRequest(request);

  after(async () => {
    await analytics.track('api_call', { endpoint: '/api/data' });
    await auditLog.write({ action: 'data_processed', timestamp: Date.now() });
  });

  return Response.json(data); // レスポンスは即座に返却
}
```

---

## Part IV: Server Components & Client Components ⚛️

### §12. Server / Client 境界設計

- **Rule 33.13**: デフォルトはServer Component。`'use client'` は**インタラクティビティが必要な最小単位**にのみ付与する
- **Leaf Component Strategy**: `'use client'` はコンポーネントツリーの**末端（リーフ）**に配置。ページやレイアウトレベルでの `'use client'` は禁止
- **Props Serialization**: Server → Client の Props はシリアライズ可能な値のみ。関数・クラスインスタンスの受け渡しは不可

### §13. The Async-UI Boundary Protocol

- **Rule 33.14**: UI コンポーネント（特にClient Components）から、データフェッチを行うAsync Server Componentsを直接インポートすることは禁止
- **Action**: データロジックを持つコンポーネントは `layout.tsx` や `page.tsx`（Server Context）のトップレベルでレンダリングし、`children` パターンでUIと物理的に分離する

### §14. The Component-DTO Interface Protocol

- **Rule 33.15**: UIコンポーネントのProps定義にデータベースの生の型（`Row`）を使用することは禁止。**DTO Interface**に依存し、実装詳細を隠蔽する

### §15. Production Build 検証プロトコル

- **Rule 33.16**: **`npm run build` が Exit 0 で通過するまで、そのコードは「存在しない」**
- **SSG Awareness**: `cookies()` 等のdynamic APIを SSG ページでインポートすると本番ビルドでエラーとなる。動的依存を分離せよ
- **Tiered Database Client Protocol**: SSG/ISR互換のDBクライアントは、dynamic API依存と非依存で**物理的に別ファイル**に分離する

---

## Part V: Edge Computing & Middleware ⚛️

### §16. Edge Middleware 設計

- **Rule 33.17**: 認証チェックやジオロケーションリダイレクトは**Edge Middleware**で実行し、レイテンシを最小化する
- **Rule 33.18**: `middleware.ts` は軽量に保ち、静的資産を処理対象から除外する。Middleware内での重いDBクエリや外部API呼び出しは禁止

### §17. The Non-Blocking Edge Processing Protocol

- **Rule 33.19**: Edge MiddlewareおよびAPI Routesにおいて、メインレスポンスに無関係なブロッキングDB書き込みを `await` で待機させることは禁止
- **waitUntil**: サイドエフェクトは `event.waitUntil()` でバックグラウンド化
- **Error Isolation**: バックグラウンド処理のエラーは try-catch で隔離

### §18. CSP Worker Integrity

- **Rule 33.20**: `heic2any` 等のライブラリは内部で `Web Worker` を生成し `blob:` URL を使用する。Middleware の CSP 設定に `worker-src 'self' blob:;` を明示的に含める

---

## Part VI: UIコンポーネント設計 🔀

### §19. shadcn/ui + Design Token

- **Rule 33.21**: **shadcn/ui** を標準UIコンポーネントライブラリとして採用し、カスタマイズ性とアクセシビリティを両立する
- **Design Token**: Tailwind Config の `extend` でプロジェクト固有のカラー・フォント・シャドウをトークンとして定義する。HEX値直書きは禁止
- **Class Sorting**: `prettier-plugin-tailwindcss` の使用を必須とする

### §20. Interactive Components Standard

- **Rich Selection Protocol**: 従来のRadio/Checkboxは原則禁止。**「直感的にクリック可能なリッチカード型UI」**を標準とする
- **Responsive Combobox Protocol**: Desktop: `Popover` / Mobile: **Drawer (Vaul)**
- **Stable IDs**: `CommandItem` の `value` は一意で整合性のある**ASCIIの文字列**であること。日本語を `value` に使うと選択ロジックが壊れる

### §21. The Design Consistency Protocol

- **Rule 33.22**: システムネイティブの `<input type="date">` はデザインシステムの統一性を破壊する「異物」として使用禁止
- **The App-Like Feel Protocol（Overscroll Control）**: モバイルWebアプリでは `overscroll-behavior-y: none` 適用を推奨

### §22. The Performance First Protocol

- **Rule 33.23**: Core Web Vitals はデプロイ要件であり、単なる目標ではない
    - **LCP < 2.5s**, **INP < 200ms**, **CLS < 0.1**
- **Bundle Size SLA**: Initial JS は **150KB (Gzipped)** 以下を維持
- **Rule 33.24**: **30KB** Gzip超過のライブラリのメインバンドル同梱は禁止。`next/dynamic` でCode Splitting

### §23. The Canonical Identity Protocol

- **Rule 33.25**: 公開ページでは `generateMetadata` で `alternates: { canonical: url }` を必ず定義する

### §24. Media Interaction (Crop UI)

- **Rule 33.26**: サーバーサイドでの自動クロッピングは禁止。ユーザーがトリミング範囲を決定できるUIを実装する
- **HEIC Conversion**: iPhone `.HEIC` はアップロード前に `heic2any` でJPEG/PNGへ自動変換
- **Filename Sanitization**: マルチバイトファイル名はクライアントサイドでローマ字に変換する

---

## Part VII: CSSアーキテクチャ 🌐

### §25. Utility First CSS

- **Rule 33.27**: Tailwind Utility クラスを原則使用する
- **Component Extraction**: 共通パターンはReactコンポーネントとしてカプセル化し、`@apply` の使用を可能な限り回避する
- **CSS Modules**: 複雑なアニメーションやTailwindで表現困難なスタイルにのみ許可

### §26. The CSS Specificity Protocol

- **Rule 33.28**: `!important` によるスタイル上書きは**完全禁止**。根本原因を解決するか、React状態管理で制御する

### §27. The CSS Class Merge Utility Protocol

- **Rule 33.29**: テンプレートリテラルや文字列結合による手動連結は禁止。`cn()` / `clsx` + `tailwind-merge` の専用マージユーティリティ使用を義務付ける

### §28. The Z-Index Stratification Protocol

- **Rule 33.30**: Z-Index の「マジックナンバー」を防止する

| レイヤー | Z-Index | 対象 |
|:---------|:--------|:-----|
| **Overlay** | 10000 | `Select`, `Popover`, `Tooltip`, `Calendar` |
| **Modal** | 9999 | `Dialog`, `Sheet` |
| **Menu** | 1000 | Drawer メニュー、Navigation |
| **Header** | 50 | Fixed ヘッダー |
| **Floaters** | 40 | フローティングボタン |

### §29. The Stacking Context Safety Protocol

- **Rule 33.31**: 通常コンテンツ内要素に明示的 `z-index` を適用することは原則禁止。`isolation: isolate` でスコープを隔離する

### §30. The CSS Containment Protocol

- **Rule 33.32**: スクロールコンテナに `contain: layout` を適用し、レイアウト計算スコープを隔離する
- **The Natural Scrolling Protocol**: `h-dvh` + `overflow-y-auto` のネストスクロール構造は禁止。`min-h-dvh` でブラウザネイティブの Window Scroll に委譲する

### §31. Container Queries

- **Rule 33.33**: コンポーネントレベルのレスポンシブ制御には**CSS Container Queries** (`@container`) を活用する。メディアクエリ（`@media`）はビューポート依存であり、再利用可能コンポーネントの自律的レスポンス設計には不適切
- **Container Type**: レスポンシブ制御が必要な親要素に `container-type: inline-size` を設定する
- **Container Units**: `cqw`, `cqi` 等のコンテナクエリ単位を活用し、コンポーネントが自身のコンテナサイズに応じて柔軟にレイアウトを変更する

```css
/* ✅ Container Query によるコンポーネント自律レスポンシブ */
.card-container {
  container-type: inline-size;
}
@container (min-width: 400px) {
  .card { display: grid; grid-template-columns: 1fr 2fr; }
}
@container (max-width: 399px) {
  .card { display: flex; flex-direction: column; }
}
```

### §303. The CSS Layers (`@layer`) Protocol

- **Rule 33.296**: **CSS Cascade Layers** (`@layer`) を活用し、スタイルの優先順位をカスケードレベルで制御する
- **Layer Order**: レイヤーの宣言順序がカスケード優先順位を決定する。後に宣言されたレイヤーが優先される
- **Third-Party Isolation**: サードパーティCSSを専用レイヤーに隔離し、プロジェクトスタイルとの競合を防止する
- **Tailwind CSS 4 統合**: Tailwind v4 は内部的に `@layer base`, `@layer components`, `@layer utilities` を使用。カスタムレイヤーとの統合を理解する
- **Unlayered Styles**: レイヤーに属さないスタイルはすべてのレイヤーより優先される。意図しない上書きを防止するため、全スタイルをレイヤーに配置することを推奨

```css
/* ✅ CSS Layers による優先順位制御 */
@layer reset, third-party, base, components, utilities;

@layer reset {
  *, *::before, *::after { box-sizing: border-box; margin: 0; }
}
@layer third-party {
  /* サードパーティライブラリのスタイルをここに隔離 */
}
@layer components {
  .card { border-radius: var(--radius); padding: 1rem; }
}
```

### §304. The CSS `:has()` Selector Protocol

- **Rule 33.297**: CSS `:has()` セレクタ（親セレクタ）を活用し、子要素の状態に基づくスタイリングをJavaScript不要で実装する
- **Form Validation Styling**: `:has(:invalid)` でフォームグループ全体のエラー状態をスタイリングする
- **Interactive States**: `:has(:focus-within)` でフォーカス中のコンテナスタイルを変更する
- **Layout Adaptation**: `:has(> img)` で画像を含むカードのレイアウトを自動調整する
- **Performance Note**: `:has()` は高コストなセレクタとなりうるため、複雑なネストは避ける。ブラウザの最適化に頼りつつ、計測で確認する

```css
/* ✅ :has() による宣言的スタイリング */
.form-group:has(:invalid) {
  border-color: var(--color-destructive);
}
.card:has(> img) {
  grid-template-rows: 200px 1fr;
}
.sidebar:has(~ main:empty) {
  display: none;
}
```

---

## Part VIII: コンポーネント設計原則 🔀

### §32. The Component Colocation Protocol

- **Rule 33.34**: 特定コンポーネントでのみ使用される「サブコンポーネント」「型定義」「定数」は**同一ファイル（Co-location）**に記述する。ファイルが **300行** を超えた場合のみ分割を許可

### §33. The Barrel Export Prohibition

- **Rule 33.35**: `index.ts`（Barrel file）による一括再エクスポートは禁止。物理ファイルからの直接インポートを義務付ける

### §34. The Dead Code Execution Protocol

- **Rule 33.36**: 条件分岐や早期リターンの「後ろ」に重いインポートを配置してはならない

### §35. The Static Component Persistence Protocol

- **Rule 33.37**: 別コンポーネントのレンダー関数内でコンポーネントを定義することは禁止。サブコンポーネントは**Module Scope（ファイルトップレベル）**で定義する
- **Anti-Pattern**: `const MyComponent = () => { const Sub = () => <div />; return <Sub />; }` — **Technical Felony**

### §36. The Route Conflict Ban

- **Rule 33.38**: ページリファクタリング時、移動元ディレクトリは物理的に削除すること

---

## Part IX: React Hooks ベストプラクティス ⚛️

### §37. The React Hooks Order Guarantee Protocol

- **Rule 33.39**: Hooks 呼び出し順序はレンダー間で不変でなければならない
- **Mandatory Order（Axiarch Standard）**:
    1. **ALL HOOKS FIRST**: 全Hooksをコンポーネント先頭に集約
    2. **DERIVED STATE**: 変数計算・状態判定
    3. **CONDITIONAL RETURNS**: Early Return

### §38. The Hook Dependency Protocol

- **Rule 33.40**: `useEffect` / `useCallback` の依存配列は ESLint (`react-hooks/exhaustive-deps`) に厳密に従う。「無限ループになるから」依存を削除することは厳禁

### §39. The Reactive Subscription Safety Protocol

- **Rule 33.41**: `watch()`, `subscribe()` 等の戻り値を `useEffect` 依存配列に直接含めることは禁止。Callback Subscription Patternを使用する

### §40. The Subscription Timer Sanitization Protocol

- **Rule 33.42**: サブスクリプションコールバック内の `setTimeout` / `setInterval` はタイマーIDを `useRef` で管理。ローカル変数でのタイマー管理は禁止

### §41. The Explicit Initial State Typing Mandate

- **Rule 33.43**: `useState` に `[]` や `null` を渡す場合、ジェネリック型パラメータの明示指定を必須とする
- `useState([])` 禁止 → `useState<Item[]>([])`
- `useState(null)` 禁止 → `useState<User | null>(null)`

### §42. The Compiler Readiness Protocol

- **Rule 33.44**: React Compiler互換のコーディングパターンを推奨する。`useMemo` / `useCallback` の過度な手動使用を避け、コンポーネントは純粋関数として実装する

---

## Part X: React 19 新API & React Compiler ⚛️

### §43. React 19 Actions

- **Rule 33.45**: React 19のActions概念を活用し、`startTransition` でラップされた非同期関数でデータミューテーションを処理する
- **Automatic Pending State**: Actionsは `isPending` 状態を自動管理し、手動の `isLoading` state管理を削減する
- **Error Handling**: Actions内でのエラーはError Boundaryまたは `useActionState` の error stateで自動キャッチされる

### §44. useOptimistic

- **Rule 33.46**: `useOptimistic` フックを使用し、サーバー応答前にUIを即座に更新する楽観的UI更新を実装する
- **Low-Risk Operations**: いいねボタン、コメント追加等の可逆的操作に限定して使用する。決済等の高リスク操作にはサーバー確認を待つ
- **Automatic Rollback**: サーバー操作失敗時はUIが自動的に元の状態にロールバックされる
- **Pure Update Function**: 楽観的状態を計算する関数は純粋関数でなければならない

### §45. useFormStatus & useActionState

- **Rule 33.47**: フォーム送信状態の管理には `useFormStatus` を使用し、ボタンの `disabled` / `loading` 状態を自動制御する
- **Scoping**: `useFormStatus` は親 `<form>` 要素にスコープされる。同一コンポーネント内の別フォームの状態は取得不可
- **useActionState**: `useFormState` の後継として `useActionState` を使用し、Action の pending 状態・戻り値・エラーを統合管理する

### §46. use() フック

- **Rule 33.48**: `use()` フックを使用して、Suspense境界内でPromiseやContextを直接消費する
- **Data Fetching**: Server ComponentからClient Componentにデータを渡す際、Promise を props として渡し `use()` で解決するパターンを活用する
- **条件付き呼び出し**: `use()` は他のHooksと異なり、条件分岐内での呼び出しが許可されている唯一のフック

### §47. React Compiler v1.0

- **Rule 33.49**: React Compiler（v1.0 GA, 2025年10月 / Next.js 16にて安定統合）を導入し、手動の `useMemo` / `useCallback` / `React.memo` を**完全に除去**する
- **Automatic Memoization**: コンパイラがコンポーネントとフックの自動メモ化を実行。手動最適化は原則不要かつ**非推奨**
- **Compatibility Mode**: 段階的導入のため `eslint-plugin-react-compiler` でコンパイラ互換性を事前検証する
- **Pure Component Requirement**: コンパイラ最適化の前提条件として、コンポーネントは純粋関数（同じ入力に対して同じ出力）でなければならない
- **Next.js 16統合**: `next.config.ts` に `experimental.reactCompiler: true` を設定（Next.js 16ではデフォルト有効）

### §48. Resource Preloading API

- **Rule 33.50**: React 19の `preload()`, `preinit()`, `prefetchDNS()`, `preconnect()` APIを活用し、リソースの先読みをプログラマティックに制御する
- **Font Preloading**: `preinit()` でクリティカルフォントを先行初期化
- **Third-Party DNS**: 外部サービスへの `prefetchDNS()` でDNS解決時間を最小化

### §48b. useEffectEvent Hook

- **Rule 33.304**: React 19.2で安定化された `useEffectEvent` フックを活用し、Effect内の非リアクティブロジックを分離する
- **Problem**: `useEffect` の依存配列に含めたくないが、最新値を参照したいロジック（例: ログ送信時の最新state参照）
- **Solution**: `useEffectEvent` で非リアクティブ関数を定義し、Effect内から呼び出す。依存配列の肥大化とstale closure問題を根本解決
- **Prohibition**: `useEffectEvent` で定義した関数を他のコンポーネントやフックに渡すことは禁止。Effect内でのみ使用する

```typescript
// ✅ useEffectEvent による非リアクティブロジック分離
import { useEffect, useEffectEvent } from 'react';

function ChatRoom({ roomId, theme }: Props) {
  const onConnected = useEffectEvent((connectedRoomId: string) => {
    // theme は最新値を参照するが、Effectの依存配列には不要
    showNotification(`${connectedRoomId} に接続しました`, theme);
  });

  useEffect(() => {
    const connection = createConnection(roomId);
    connection.on('connected', () => onConnected(roomId));
    connection.connect();
    return () => connection.disconnect();
  }, [roomId]); // theme は依存配列に不要
}
```

### §305. React Activity コンポーネント

- **Rule 33.298**: React 19.2で GA に昇格した `<Activity>` コンポーネントを活用し、非表示コンポーネントの状態を保持したままDOMから除外する
- **Mode**: `mode="visible"` で通常表示、`mode="hidden"` でDOMから除外しつつ状態を保持
- **Use Cases**:
    - タブ切り替え時の入力フォーム状態保持
    - モーダル/ドロワーのプリレンダリング
    - ルート遷移時のバックグラウンドページ保持
- **Priority**: Hidden状態のコンポーネントは低優先度でレンダリングされ、メインスレッドへの影響を最小化
- **Status**: React 19.2 GA — Next.js 16で完全サポート。積極的に採用する

```tsx
// ✅ Activity による状態保持型タブUI
import { Activity } from 'react';

function TabPanel({ activeTab }: { activeTab: string }) {
  return (
    <>
      <Activity mode={activeTab === 'edit' ? 'visible' : 'hidden'}>
        <EditForm /> {/* hidden時もフォーム状態を保持 */}
      </Activity>
      <Activity mode={activeTab === 'preview' ? 'visible' : 'hidden'}>
        <Preview />
      </Activity>
    </>
  );
}
```

### §306. React `<ViewTransition>` GA 統合

- **Rule 33.299**: React の `<ViewTransition>` コンポーネント（GA版）を活用し、ルート遷移・UI状態変更のアニメーションを宣言的に実装する
- **Declarative API**: `startTransition` と連携し、Reactの更新サイクル内でView Transitions APIを自動的にトリガーする
- **Cross-Document**: Next.js App Router のクロスページ遷移で自動的にView Transitionを適用する設定を推奨
- **CSS Customization**: `::view-transition-group()`, `::view-transition-old()`, `::view-transition-new()` 擬似要素でアニメーションを細粒度制御
- **Fallback**: View Transitions API非対応ブラウザでは通常のDOM更新にフォールバック（プログレッシブエンハンスメント）

```tsx
// ✅ ViewTransition によるルート遷移アニメーション
import { ViewTransition } from 'react';
import { useRouter } from 'next/navigation';

function NavigationLink({ href, children }: Props) {
  const router = useRouter();
  return (
    <ViewTransition>
      <a onClick={() => startTransition(() => router.push(href))}>
        {children}
      </a>
    </ViewTransition>
  );
}
```

### §305b. cacheSignal() API

- **Rule 33.325**: React 19.2で導入された `cacheSignal()` APIを活用し、RSC（React Server Components）のキャッシュライフサイクルを精密に制御する
- **Purpose**: `cache()` APIで生成されたキャッシュの有効期間に連動する `AbortSignal` を提供する。キャッシュが無効化された際に進行中の非同期処理（fetch、DB接続等）を自動キャンセルする
- **Use Case**: 長時間実行されるデータフェッチや外部API呼び出しのリソースリーク防止
- **Integration**: `cacheSignal()` を `fetch` の `signal` オプションに渡してキャッシュ寿命と HTTP リクエストを連動させる

```typescript
// ✅ cacheSignal() によるキャッシュ連動キャンセル
import { cache } from 'react';
import { cacheSignal } from 'react';

const getProduct = cache(async (id: string) => {
  const signal = cacheSignal();
  const res = await fetch(`https://api.example.com/products/${id}`, { signal });
  // キャッシュが無効化されると signal が abort され、不要なリクエストが自動キャンセルされる
  return res.json();
});
```

### §305c. React Performance Tracks (Chrome DevTools)

- **Rule 33.326**: React 19.2で導入された **Performance Tracks** を活用し、Chrome DevToolsのPerformanceパネルでReactのスケジューラ挙動・コンポーネントレンダリングを可視化する
- **Feature**: コンポーネント名付きの専用トラックがDevToolsに表示され、レンダリング時間・再レンダリング原因・Suspenseバウンダリの解決タイミングを視覚的に把握可能
- **INP Debugging**: ユーザーインタラクションに対するReactの応答パスをトラックで追跡し、INP劣化の根本原因を特定する
- **Status**: Chrome 131+ でデフォルト有効。React DevTools Profilerと併用し、Lab Data / Field Data の両面から分析する

### §305d. Batching Suspense Boundaries for SSR

- **Rule 33.327**: React 19.2で改善された **SSR Suspense バウンダリのバッチ処理** を理解し、SSRストリーミングの一貫性を向上させる
- **Behavior**: 複数のSuspenseバウンダリが同時に解決可能な場合、クライアントとサーバーで一貫した順序でコンテンツを表示する。アニメーションやレイアウトシフトの一貫性が向上
- **Impact**: Suspense境界の配置設計により、ユーザーの知覚的なロード速度とCLSが改善される。細かすぎる境界分割はバッチ効果を減少させるため、意味のある単位での境界設定を推奨

---

## Part XI: Hydration & SSR安定性 ⚛️

### §49. The Hydration Stability Protocol

- **Rule 33.51**: SSRとクライアントレンダリングの出力不一致（Hydration Mismatch）を完全に排除する
- **Root Cause**: SSR中に `Date.now()`, `Math.random()`, ブラウザ固有グローバル (`window.innerWidth` 等) を使用すると不一致が発生する
- **Suppress**: `suppressHydrationWarning` は**日時表示にのみ**許可。それ以外での使用は禁止

### §50. The SSR Stream Resilience Protocol

- **Rule 33.52**: SSRストリーミング中のデータアクセスに厳格なnullガードを実装する。nullチェックなしのプロパティアクセスは禁止
- **Debug Protocol**: SSRエラーのデバッグはブラウザDevToolsではなく**サーバーターミナル出力**で確認する

### §51. The Server Cookie Write Authority Protocol

- **Rule 33.53**: Cookie書き込みは**Server Actions**または**Route Handlers**に限定する。SSR中（`page.tsx` レンダリング時）のCookie書き込みは不可

### §52. The Component Config Re-mount Protocol

- **Rule 33.54**: 動的設定（テーマ、ロケール等）の変更時にコンポーネント内部状態のリセットが必要な場合、設定値をReactの `key` propに含めて強制的に再マウントする

### §53. The Hydration-Safe Dynamic Content

- **Rule 33.55**: クライアント専用コンテンツ（`window.location`、ブラウザ固有値等）は `useEffect` + state パターンで遅延レンダリングし、SSR中は `null` またはフォールバックを返す

---

## Part XII: フォーム設計（React Hook Form + Zod）🔀

### §54. Schema-Driven Development

- **Rule 33.56**: フォーム設計はZodスキーマから開始する。**Three-Point Sync**（型・バリデーション・UIの三点同期）を保証する
- **Three-Point Sync**: Schema (Zod) + DefaultValues + UI は常に一致していること

### §55. The Form DefaultValues Completeness Mandate

- **Rule 33.57**: `useForm({ defaultValues })` で全フィールドの初期値を明示的に設定する。未定義フィールドの暗黙的 `undefined` 依存は禁止

### §56. The Validation Error Transparency Mandate

- **Rule 33.58**: `handleSubmit(onValid)` に加え、`onInvalid` コールバックを必ず実装する: `handleSubmit(onValid, onInvalid)`
- Zodバリデーションエラーの詳細を `console.error` でログ出力し、サイレントな送信失敗を防止

### §57. The Strict Action Return Type

- **Rule 33.59**: Server Action の戻り値は **`ActionResult<T>`** のような厳格なUnion Typeで定義する

```typescript
type ActionResult<T> =
  | { success: true; data: T }
  | { success: false; error: string; fieldErrors?: Record<string, string[]> };
```

### §58. Server Action Form Integration

- **Rule 33.60**: フォーム送信後は `revalidatePath` / `revalidateTag` で関連キャッシュを無効化し、UI とサーバー状態の同期を保証する

### §59. Reset Form Protocol

- **Rule 33.61**: 送信後のリセットには `form.reset()` を使用する。`defaultValues` の更新時は `reset(newValues)` で明示的に上書きする

### §60. Multi-Step Form Protocol

- **Rule 33.62**: マルチステップフォームではステップ毎に個別のZodスキーマを定義し、ステップ遷移時にバリデーションを実行する。最終送信時に全ステップデータを統合バリデーション

---

## Part XIII: フォーム高度パターン 🔀

### §61. The Atomic Tabbed Form Protocol

- **Rule 33.63**: 大規模フォーム（15フィールド以上）はタブ分割して認知負荷を軽減する
- **Tab Validation**: タブ切り替え時は現在のタブフィールドのみバリデーション実行

### §62. The Auto-Save & Data Persistence Protocol

- **Rule 33.64**: 重要フォーム（プロフィール編集、投稿作成等）にはオートセーブを実装する
- **Debounce**: 変更検知後500ms〜1000msのデバウンス後にオートセーブ実行
- **Visual Feedback**: セーブステート（「保存中...」「保存完了 ✓」） を常に表示
- **Conflict Resolution**: タブ/デバイス間の同時編集はOptimistic Locking（`updatedAt` 比較）で検出

### §63. The Dynamic Form Engine Protocol

- **Rule 33.65**: 動的フォーム生成（管理画面等）はスキーマ駆動でフィールドをレンダリングする

### §64. The useFieldArray Initialization Guard

- **Rule 33.66**: useEffect で `useFieldArray` の `fields` をウォッチし `append` / `replace` を呼び出すと無限ループが発生する
- **Pattern**: `fields.length === 0` のガード条件 + `useRef` フラグで1回限りの実行を保証する

### §65. The One-Shot Initialization Guard Protocol

- **Rule 33.67**: 動的配列（`useFieldArray`）の初期化は `useRef` フラグパターンで厳密に1回のみ実行する

### §66. The DnD Overlay Input Isolation Protocol

- **Rule 33.68**: Drag & Drop のオーバーレイ内にフォーム入力フィールドを配置してはならない。`DragOverlay` のレンダリングは読み取り専用プレビューに限定する

---

## Part XIV: 入力UX最適化 🌐

### §67. The Input Mode Mandate

- **Rule 33.69**: モバイルキーボード最適化のため適切な `inputMode` 属性を設定する
    - 数値入力 → `inputMode="numeric"`
    - 電話番号 → `inputMode="tel"`
    - メール → `inputMode="email"`
    - URL → `inputMode="url"`

### §68. The Input Normalization Protocol (NFKC)

- **Rule 33.70**: ユーザー入力の全角英数字はサーバー送信前に半角（NFKC正規化）に変換する。日本語文字（ひらがな・カタカナ・漢字）はNFKC変換の対象外とする

### §69. The IME Composition Guard

- **Rule 33.71**: IME入力確定前（変換中）のEnterキーでフォーム送信が発火することを防止する。`compositionstart` / `compositionend` イベントでガードする

### §70. The iOS Input Zoom Defense

- **Rule 33.72**: iOSでは `font-size` が**16px**未満の `<input>` にフォーカスすると自動ズームが発生する。モバイル入力フィールドは最低**16px**のフォントサイズを保証する

### §71. The External Link Protocol

- **Rule 33.73**: 外部サイトリンクには必ず `target="_blank"` と `rel="noopener noreferrer"` を付与する

---

## Part XV: バリデーション & フロントエンドセキュリティ 🌐

### §72. The Anti-Spam Shield

- **Rule 33.74**: 公開フォーム（問い合わせ、サインアップ等）にはCloudflare TurnstileまたはreCAPTCHA v3を実装する。Honeypotフィールドとの併用を推奨

### §73. The Frictionless Security UI Protocol

- **Rule 33.75**: セキュリティ対策がユーザー体験を阻害してはならない。Turnstileはinvisibleモードで使用し、ユーザーフローを維持する

### §74. The Conditional Security Bypass Ban

- **Rule 33.76**: `isAdmin` や `isDev` フラグに基づき認証チェックをスキップするコードは禁止。ベースラインの認証・認可チェックは全パスで例外なく実行される

### §75. The Deep Type Recursion Break Protocol

- **Rule 33.77**: ZodやTypeScriptで再帰型を定義する際、`z.lazy()` や bounded generics で深度制限を設定する。無限再帰によるコンパイルハングを防止

### §76. The Strict DTO Boundary Protocol

- **Rule 33.78**: 外部データ（API Response、URL Params等）は `unknown` 型で受け取り、Zodスキーマでバリデーション後にキャストする。`as` 型アサーションは禁止

### §77. The URL State Management Protocol

- **Rule 33.79**: フィルタリング、ソート、ページネーションのUI状態はURL SearchParamsで管理する。`nuqs` ライブラリを推奨
- **Benefit**: ブックマーク共有、ブラウザ履歴、SSR互換性

### §78. The Hard Session Refresh Protocol

- **Rule 33.80**: 重要な認証状態変更（ログイン、ログアウト、権限変更）後は `window.location.reload()` で強制リフレッシュする。`router.refresh()` では認証コンテキストが完全にリセットされない場合がある

---

## Part XVI: State Management 🔀

### §79. State Management Philosophy

- **Rule 33.81**: 状態管理の階層を明確化する:
    - **Server State**: RSC / Server Actions / React Query で管理。フロントエンドはキャッシュのみ
    - **URL State**: SearchParams で管理（§77参照）
    - **Form State**: React Hook Formで管理
    - **Client UI State**: `useState` / Zustand / Jotai で管理
    - **Derived State**: 導出により計算。Stateとして持たない
- **Global State Prohibition**: グローバルState Storeの乱用は禁止。最小スコープで状態を管理する

### §80. Zustand / Jotai

- **Rule 33.82**: クライアントサイドUI状態管理には **Zustand**（中〜大規模Store）または **Jotai**（アトミック状態）を使用する
- **Redux Prohibition**: 新規プロジェクトでの Redux / Redux Toolkit の使用は禁止
- **Immer Integration**: Zustand のネストオブジェクト更新には `immer` middleware を使い、不変更新を簡潔に記述する

### §81. The Derived State Anti-Pattern

- **Rule 33.83**: 他のstateから計算可能な値を `useState` + `useEffect` で同期する「ミラーリングパターン」は禁止。レンダー内計算または `useMemo` を使用する

### §82. Context API Usage Criteria

- **Rule 33.84**: React Contextは**頻繁に更新されないデータ**（テーマ、認証状態）にのみ使用する。頻繁に更新されるデータ（入力値、アニメーション状態）にContextを使用するとパフォーマンスが劣化する
- **Provider Hell Prevention**: 3層以上のネストした Provider は状態管理ライブラリへの移行を検討する

### §83. Persistent State Protocol

- **Rule 33.85**: Zustandの `persist` middleware を使って localStorage への状態永続化を実装し、バージョニングとマイグレーション戦略を策定する

---

## Part XVII: Data Fetching & キャッシュ ⚛️

### §84. Data Fetching 原則

- **Rule 33.86**: データフェッチはServer Componentsで実行し、以下の原則を遵守する:
    1. **Parallel**: 独立データは `Promise.all` で並列取得。ウォーターフォールは禁止
    2. **Suspense**: `<Suspense>` 境界でローディング状態を宣言的に管理
    3. **Prefetch**: 予測可能なナビゲーションでは `<Link prefetch>` でデータを先読み

### §85. The Public Cache Mandate (FinOps Protocol)

- **Rule 33.87**: 公開読み取りアクション（非認証データフェッチ）は `unstable_cache`（または Next.js 15 の `'use cache'` ディレクティブ）でキャッシュする
- **Cache Tags**: `['stores', storeId]` のようなセマンティックタグでキャッシュキーを管理し、`revalidateTag` で精密に無効化する
- **FinOps Impact**: キャッシュなしの公開ページは全アクセスがDB直撃となり、コストが指数関数的に増大する

### §86. The Data Seeding & Cache Versioning Protocol

- **Rule 33.88**: DBデータシーディングまたはマイグレーション後、キャッシュバージョンキーを更新して強制的にキャッシュを無効化する

### §87. The Resilient RSC Data Access Protocol

- **Rule 33.89**: RSC内のデータアクセスにはnullガードを必須とする。`data.property` の前に `data?.property` またはnullチェックを配置する

### §88. React Query Usage Criteria

- **Rule 33.90**: クライアントサイドのサーバー状態管理には **TanStack Query (React Query)** を使用する
- **Stale Time**: グローバルな `staleTime` を設定し、不要なリフェッチを抑制する（推奨: 5分）
- **Deduplication**: 同一キーの同時リクエストは自動的に重複排除される

### §89. DB Query Performance Target

- **Rule 33.91**: フロントエンドから呼び出されるDBクエリは **≤ 50ms** を目標とする。100msを超えるクエリはインデックス追加またはクエリ最適化が必要

### §90. SWR vs Polling

- **Rule 33.92**: リアルタイムデータ更新が必要な場合、以下の優先順位で選択:
    1. Server-Sent Events (SSE)
    2. WebSocket
    3. Polling（最終手段、interval ≥ 30秒）

---

## Part XVIII: パフォーマンス最適化 🌐

### §91. The CWV Deployment Gate

- **Rule 33.93**: 以下の Core Web Vitals 閾値をデプロイゲートとして厳守する:

| メトリクス | Good | Needs Improvement | Poor |
|:-----------|:-----|:-------------------|:-----|
| **LCP** | ≤ 2.5s | ≤ 4.0s | > 4.0s |
| **INP** | ≤ 200ms | ≤ 500ms | > 500ms |
| **CLS** | ≤ 0.1 | ≤ 0.25 | > 0.25 |

- **Enforcement**: Lighthouse CIで自動計測し、`Poor` ステータスでのマージを禁止する

### §92. The Bundle Size Budget

- **Rule 33.94**: バンドルサイズ予算を厳守する:
    - **JS (Gzipped)**: Initial ≤ 150KB, Route Chunk ≤ 50KB
    - **CSS (Gzipped)**: ≤ 30KB
    - **Measurement**: `@next/bundle-analyzer` で定期監査

### §93. The Dynamic Library Decoupling Protocol

- **Rule 33.95**: 30KB（Gzip）超過のライブラリのメインバンドル同梱は禁止。`next/dynamic` でlazy load

### §94. The LCP & Lazy Loading Performance Protocol

- **Rule 33.96**: Above-the-Fold コンテンツ最適化:
    - ヒーロー画像: `priority` 属性を適用。Lazy Load しない
    - Below-the-Fold 画像: `loading="lazy"` 必須
    - `<Suspense>` + Server Component: ストリーミングで重いコンテンツを段階的表示

### §95. The Performance Regression Response

- **Rule 33.97**: パフォーマンス劣化時の対応プロトコル:

| 優先度 | 条件 | 対応 |
|:-------|:-----|:-----|
| **P0** | LCP > 4s or INP > 500ms | 即座にリバート。全タスクより優先 |
| **P1** | LCP > 2.5s or INP > 200ms | 次リリースまでに修正 |
| **P2** | Bundle Size Budget 超過 | 2スプリント以内に最適化 |

### §96. The Semicolon Guard (ASI Safety)

- **Rule 33.98**: ASI（Automatic Semicolon Insertion）による予期しない動作を防止するためセミコロンを使用する

### §97. The Baseline Alignment Protocol

- **Rule 33.99**: ラベルとフォーム要素のベースラインが揃わない場合、`items-end` / `items-baseline` で修正する

### §98. The Code Input Standard

- **Rule 33.100**: コード入力フィールドにはプレーンな `<textarea>` ではなく、構文ハイライト付きエディタコンポーネント（Monaco Editor / CodeMirror）を使用する

### §307. The Long Animation Frames (LoAF) API Protocol

- **Rule 33.300**: **Long Animation Frames (LoAF) API** を活用し、INP劣化の原因を特定する
- **Long Tasksとの違い**: Long Tasks API は50ms超のタスクを検出するが、原因の特定が困難。LoAF はスクリプト単位の帰属・レンダリング時間を含む詳細データを提供
- **Threshold**: `duration > 100ms` を監視ラインとする。`blockingDuration` がINPに直結する指標
- **Script Attribution**: `scripts` 配列から原因スクリプト、実行型（`user-callback`, `event-listener`, `script-block`）、ソースURLを特定可能
- **CI Integration**: RUMデータと統合し、p75 LoAF Durationの劣化をアラート対象とする

```typescript
// ✅ LoAF API によるINPデバッグ
const observer = new PerformanceObserver((list) => {
  for (const entry of list.getEntries()) {
    if (entry.duration > 100) {
      console.warn('Long Animation Frame:', {
        duration: entry.duration,
        blockingDuration: entry.blockingDuration,
        scripts: entry.scripts.map(s => ({
          sourceURL: s.sourceURL,
          invokerType: s.invokerType,
          duration: s.duration,
        })),
      });
    }
  }
});
observer.observe({ type: 'long-animation-frame', buffered: true });
```

### §308. The Scheduler.yield() API Protocol

- **Rule 33.301**: **`scheduler.yield()`** を活用し、メインスレッドの長時間ブロッキングを回避する
- **INP改善**: 長いタスクを `scheduler.yield()` で分割し、ブラウザがユーザーインタラクションに応答する機会を確保する
- **vs setTimeout(0)**: `scheduler.yield()` はメインタスクの継続を優先的にスケジュールする。`setTimeout(0)` はタスクキューの末尾に回されるためUXが劣化する
- **Polyfill**: `scheduler-polyfill` パッケージで未対応ブラウザをカバー
- **React統合**: React の `startTransition` と組み合わせ、低優先度更新をスケジュールするパターンを推奨

```typescript
// ✅ scheduler.yield() によるメインスレッド解放
async function processLargeDataset(items: Item[]) {
  for (let i = 0; i < items.length; i++) {
    processItem(items[i]);
    if (i % 100 === 0) {
      await scheduler.yield(); // 100件ごとにメインスレッドを解放
    }
  }
}
```

---

## Part XIX: 画像・フォント・スクリプト最適化 🔀

### §99. The Image Optimization Protocol

- **Rule 33.101**: 画像には `next/image`（または同等の最適化コンポーネント）を使用し、以下を保証する:
    - 自動フォーマット変換（WebP / AVIF）
    - レスポンシブサイズ（`sizes` 属性）
    - CLS防止（`width`/`height` 必須、または `fill` + wrapper sizing）
    - CDN配信（Cloudflare Image Transformations 等）

### §100. The Image Size Budget

| 用途 | 最大サイズ | フォーマット |
|:-----|:---------|:-----------|
| ヒーロー / バナー | 200KB | WebP / AVIF |
| サムネイル | 50KB | WebP |
| アイコン / ロゴ | 10KB | SVG / WebP |
| OGP画像 | 100KB | PNG / WebP |

### §101. The Font Optimization Protocol

- **Rule 33.102**: `next/font` でフォントをセルフホストし、以下を実装する:
    - `font-display: swap` でFOIT（Flash of Invisible Text）を防止
    - サブセット化でファイルサイズを最小化
    - クリティカルフォントのプリロード

### §102. The Script Optimization Protocol

- **Rule 33.103**: 外部スクリプト（Analytics、Chat Widget等）は `next/script` でlazy loadする:
    - **strategy**: `afterInteractive`（デフォルト）または `lazyOnload`（非クリティカル）
    - CWVに影響するスクリプトは `lazyOnload` 必須

### §103. The AVIF First Protocol

- **Rule 33.104**: 画像フォーマット優先順位: **AVIF > WebP > PNG/JPEG**。`next/image` で `formats: ['image/avif', 'image/webp']` を設定する

### §104. The SVG Optimization Protocol

- **Rule 33.105**: SVGアイコンは `svgo` で不要メタデータを除去して最適化する。インラインSVGでは `currentColor` を使用しテーマサポートを実現

### §105. The Responsive Image Protocol

- **Rule 33.106**: レスポンシブ画像には `sizes` 属性を正確に設定し、不要な大サイズ画像のダウンロードを防止する。一律 `sizes="100vw"` は禁止

---

## Part XX: SEO & メタデータ 🌐

### §106. The Dynamic Metadata Protocol

- **Rule 33.107**: 全公開ページで `generateMetadata` を実装し、動的なtitle/descriptionを生成する
- **Title Template**: `layout.tsx` で `title: { template: '%s | サービス名', default: 'サービス名' }` を設定
- **Fallback**: DB取得失敗時のフォールバックメタデータを必ず定義する

### §107. The Structured Data Protocol (JSON-LD)

- **Rule 33.108**: 型安全なJSON-LDスキーマを実装する。`schema-dml` 等の型付きライブラリを使用し、手書きJSONは禁止
- **Required Types**: `Organization`, `WebSite`, `BreadcrumbList`, `FAQPage`, `Product` 等のビジネス関連スキーマ

### §108. The Canonical URL Protocol

- **Rule 33.109**: 全公開ページで `alternates: { canonical: url }` を定義し、重複コンテンツによるSEOペナルティを防止する
- **Trailing Slash**: プロジェクト全体でトレーリングスラッシュの使用を統一する（`next.config.ts` の `trailingSlash`）

### §109. The Dynamic OGP Protocol

- **Rule 33.110**: `@vercel/og` または `ImageResponse` でOGP画像を動的生成し、SNSシェアのCTRを向上させる
- **Dimensions**: 1200×630px（Facebook/LinkedIn標準）を基準とする

### §110. The Robots & Sitemap Protocol

- **Rule 33.111**: `app/robots.ts` と `app/sitemap.ts` を実装し、クローラーのアクセス制御とページの発見可能性を保証する
- **Dynamic Sitemap**: DBからページリストを取得し、動的サイトマップを生成

### §111. The Ghost Content Protocol (Time-Gated SEO)

- **Rule 33.112**: 公開前コンテンツには `noindex` を設定し、クローラーによる時期尚早なインデックスを防止する

### §112. The Microcopy Identity Protocol

- **Rule 33.113**: エラーメッセージ、ラベル、プレースホルダーをサービスのTone & Voiceに統一する。「エラーが発生しました」等の汎用的な表現は避ける

---

## Part XXI: Technical SEO & GEO 🌐

### §113. The Semantic HTML Landmark Protocol

- **Rule 33.114**: セマンティックHTML要素（`<header>`, `<nav>`, `<main>`, `<article>`, `<aside>`, `<footer>`）を使用し、ページ構造を明示する
- **Heading Hierarchy**: `<h1>` → `<h2>` → `<h3>` の階層をスキップせず、論理的な見出し構造を維持する
- **Single H1 Rule**: 1ページにつき `<h1>` は**一つだけ**

### §114. The SSR First Protocol

- **Rule 33.115**: クリティカルコンテンツはServer Side Renderingで初回HTMLに含める。クライアントサイドでのみレンダリングされるコンテンツはクローラーに遅延認識される

### §115. The IndexNow Protocol

- **Rule 33.116**: コンテンツ更新時に IndexNow API で検索エンジンに即時通知し、クローリングまでの待機時間を削減する

### §116. The GEO (Generative Engine Optimization) Protocol

- **Rule 33.117**: AI検索エンジン（ChatGPT、Gemini、Perplexity等）向けに以下の最適化を実施する:
    - FAQ構造化データ + 簡潔な回答パラグラフの提供
    - `llms.txt` / `llms-full.txt` の配置
    - E-E-A-T（Experience, Expertise, Authoritativeness, Trustworthiness）の強化
- **Cross-Reference**: `400_ai_engineering.md`

### §117. The Speculative Rules API Protocol

- **Rule 33.118**: **Speculation Rules API** (`<script type="speculationrules">`) を活用し、ブラウザネイティブのプリレンダリング・プリフェッチを実装する
- **Prerender**: ユーザーが高確率でナビゲーションするリンク（CTA、メインナビ等）にはプリレンダリングを適用
- **Prefetch**: 不確実なリンクにはプリフェッチ（リソース先読みのみ）を適用
- **Eagerness**: `moderate`（hoverまたはpointerdown時）を推奨。`eager`（即時全件）はリソース消費に注意

```html
<script type="speculationrules">
{
  "prerender": [
    { "where": { "href_matches": "/dashboard/*" }, "eagerness": "moderate" }
  ],
  "prefetch": [
    { "where": { "selector_matches": "a[data-prefetch]" }, "eagerness": "moderate" }
  ]
}
</script>
```

---

## Part XXII: アクセシビリティ（A11y）🌐

### §118. The Accessibility Shift Left Protocol

- **Rule 33.119**: アクセシビリティはリリース後の修正ではなく、設計・開発の初期段階で組み込む（Shift Left）
- **CI Integration**: `axe-core` / `jest-axe` をCIパイプラインに統合し、A11y違反をPRレベルで自動検出する
- **Target**: WCAG 2.2 Level AA 準拠
- **EAA 2025**: 欧州アクセシビリティ法（EAA）が2025年6月に施行。EU市場向けプロダクトはEN 301 549準拠が法的義務

### §119. The Alt Text Mandate

- **Rule 33.120**: コンテンツ画像には運営者のネイティブ言語で具体的なalt textを設定する。`alt` 属性そのものの省略は**永久禁止**

| 画像種類 | 基準 | Bad ❌ | Good ✅ |
|:---------|:-----|:-------|:--------|
| **店舗/施設写真** | 名前＋特徴 | `alt="photo1"` | `alt="渋谷のカフェXYZの内観"` |
| **商品画像** | 商品名＋特徴 | `alt="image"` | `alt="オーガニック商品名 100g"` |
| **地図** | エリア＋用途 | `alt="map"` | `alt="東京都渋谷区周辺のペット可カフェマップ"` |
| **アイコン** | アイコンの意味 | `alt="icon"` | `alt="評価: 星4つ"` |
| **装飾** | 空文字列 | `alt="decoration"` | `alt=""` |

### §120. Screen Reader & Icon Labels

- **Rule 33.121**: 主要フローのスクリーンリーダー（VoiceOver/TalkBack）での検証を実機で実施すること
- **Icon Labels**: テキストを含まないアイコンのみのボタンには `aria-label` 属性でその機能を明示する

### §121. WAI-ARIA Protocol

- **Rule 33.122**: 「No ARIA is better than Bad ARIA」。ネイティブHTML要素を可能な限り使用し、ARIA属性は最小限に留める
- **Radix UI / Headless UI**: 複雑なコンポーネントにはアクセシブルなheadless UIライブラリを使用する

### §122. The Focus Management Protocol

- **Rule 33.123**: モーダル・ダイアログのオープン時はフォーカスをモーダル内にトラップし、クローズ時は起動元にフォーカスを返す
- **Focus Visible**: `:focus-visible` でキーボードフォーカスのみスタイルを適用し、マウスクリック時の不要なフォーカスリングを排除する

### §123. The Color Contrast Protocol

- **Rule 33.124**: テキストのコントラスト比は WCAG 2.2 AA 基準を満たす:
    - 通常テキスト: **4.5:1** 以上
    - 大テキスト（18px以上）: **3:1** 以上
    - UIコンポーネント: **3:1** 以上

### §124. The Reduced Motion Protocol

- **Rule 33.125**: `prefers-reduced-motion: reduce` メディアクエリを実装し、モーション過敏なユーザーのアニメーションを無効化する

---

## Part XXIII: PWA & クロスプラットフォーム 🌐

### §125. PWA Standard

- **Rule 33.126**: `manifest.json` でPWAメタ情報を定義し、アイコン、テーマカラー、ディスプレイモードを設定する
- **Service Worker**: オフラインキャッシュ戦略は `Cache First`（静的資産）+ `Network First`（API）を基本とする

### §126. Deep Linking

- **Rule 33.127**: `universal links`（iOS）/ `app links`（Android）を設定し、Webリンクからネイティブアプリへの適切なルーティングを実現する

### §127. Server Actions (PWA Context)

- **Rule 33.128**: PWA環境でのServer Actionsはオフライン時のフォールバック処理を必ず実装する

### §128. Web Push Notifications

- **Rule 33.129**: Web Push通知はユーザーの明示的なオプトイン（CTA）後にのみ許可を要求する。ページロード直後のパーミッション要求は禁止

### §129. The Install Prompt Protocol

- **Rule 33.130**: カスタムインストールプロンプトでPWAインストール率を向上させる。`beforeinstallprompt` イベントをキャプチャし、適切なタイミングで表示する

---

## Part XXIV: 国際化（i18n）🌐

### §130. Multi-Language Architecture

- **Rule 33.131**: 国際化は `Sub-Directory` 方式（`/ja/about`, `/en/about`）を標準とする。ドメイン分離方式はコスト・運用負荷が高いため非推奨
- **next-intl / next-i18n-router**: Next.js App Routerとの統合が成熟したi18nライブラリを使用する

### §131. UTC Time Storage

- **Rule 33.132**: 日時データは常に**UTC**でDB保存し、表示時にユーザーのタイムゾーンに変換する
- **Formatter**: `Intl.DateTimeFormat` または `date-fns-tz` でタイムゾーン変換を実行する

### §132. Locale Management

- **Rule 33.133**: ロケール検出の優先順位: URLパス > Cookie > Accept-Language ヘッダー

### §133. Translation Workflow

- **Rule 33.134**: i18n辞書ファイル（JSON/TS）はnamespace分割し、ページ単位でlazy loadする
- **Missing Key Handling**: 翻訳キーが欠落している場合、フォールバック言語のテキストまたはキー自体を表示する。空文字列やundefinedをレンダリングすることは禁止

---

## Part XXV: エラーハンドリング & レジリエンス 🔀

### §134. Error Boundary

- **Rule 33.135**: `error.tsx`（App Routerのエラーバウンダリ）を全ルートセグメントに配置し、未処理例外がユーザーに白画面を表示することを防止する
- **Recovery**: エラーUIには「再試行」ボタンを含め、ユーザーが回復アクションを取れるようにする

### §135. Global Error Handling

- **Rule 33.136**: `global-error.tsx` でRootLayoutを含む致命的エラーをキャッチし、カスタムエラーページを表示する

### §136. Not Found Handling

- **Rule 33.137**: `not-found.tsx` をカスタマイズし、404時に有用なナビゲーション（ホーム、検索等）を提供する

### §137. Offline & Network Resilience

- **Rule 33.138**: API呼び出し失敗時の対応:
    - 自動リトライ（指数バックオフ、最大3回）
    - オフライン検知（`navigator.onLine` / `online`/`offline` イベント）
    - 楽観的更新 + ロールバック

### §138. Console Warning Protocol

- **Rule 33.139**: `console.error` や `console.warn` は開発の失敗の証拠。全ての `console.error` は修正するか、正当な `Logger` に置き換える

### §139. Graceful Degradation Protocol

- **Rule 33.140**: 外部サービス（Analytics、Chat、Ad等）の読み込み失敗がアプリの主要機能を阻害してはならない。`try-catch` で隔離し、フォールバックを表示する

---

## Part XXVI: Server Actions & API安全性 ⚛️

### §140. Server Actions 基本原則

- **Rule 33.141**: `'use server'` ディレクティブはファイルの先頭に配置し、ファイル全体をServer Actionファイルとして定義する。インライン `'use server'` は禁止
- **Auth Guard**: 全Server Actionsの先頭で認証チェックを実行する。認証なしのServer Actionは原則禁止

### §141. Return Type Safety

- **Rule 33.142**: Server Actionsの戻り値はシリアライズ可能な型のみ。`Date`オブジェクト、関数、クラスインスタンスは返却禁止

### §142. Rate Limiting

- **Rule 33.143**: 公開Server Actions（Contact Form送信等）にはレート制限を実装する

### §143. File Upload via Server Actions

- **Rule 33.144**: ファイルアップロードは `FormData` 経由でServer Actionに渡し、サーバーサイドでバリデーション（ファイルタイプ、サイズ、マジックバイト検証）を実行する

### §144. Mutation Side Effects

- **Rule 33.145**: Server Action内でのデータ変更（CUD操作）後は `revalidateTag()` で関連キャッシュを明示的に無効化する

### §145. The API Key Isolation Protocol

- **Rule 33.146**: APIキーは `NEXT_PUBLIC_` プレフィックスでクライアント公開してはならない。全APIキーはServer Actions / Route Handlersでのみ使用
- **Cross-Reference**: `600_security_privacy.md`

### §146. The Input Sanitization Protocol

- **Rule 33.147**: Server Actionsに渡されるユーザー入力は `zod` でバリデーション後、必要に応じてサニタイズ処理を実行する。生のユーザー入力を直接DBクエリやHTML出力に使用することは禁止

---

## Part XXVII: データ可視化 & エクスポート 🔀

### §147. Chart Libraries

- **Rule 33.148**: チャートは `Recharts` または `Chart.js` を使用し、必ず `next/dynamic` でlazy loadする
- **Responsive**: レスポンシブなSVGベースのチャートを推奨（Recharts）
- **Accessibility**: チャートには `aria-label` とテキスト代替（データテーブル）を提供する

### §148. PDF Export

- **Rule 33.149**: PDF生成はサーバーサイド（`@react-pdf/renderer` または Puppeteer）で実行する

### §149. CSV Export

- **Rule 33.150**: CSVエクスポートは `papaparse` 等のライブラリでエンコーディング（UTF-8 BOM付き）を統一し、Excel互換性を保証する

### §150. Data Table Protocol

- **Rule 33.151**: データテーブルには `@tanstack/react-table` を使用し、ソート・フィルタ・ページネーション・列選択を実装する。テーブルのSSR対応は `<Suspense>` で段階的表示する

---

## Part XXVIII: AdTech & マーケティングエンジニアリング 🌐

### §151. The OGP Dynamic Generation Protocol

- **Rule 33.152**: 全公開ページにOGP（Open Graph Protocol）メタタグを動的に設定する
- **Image Generation**: `@vercel/og` で動的OGP画像を生成し、SNSシェア時のCTRを向上させる

### §152. Conversion API (CAPI) Integration

- **Rule 33.153**: サーバーサイドのConversion API（Meta CAPI、Google Enhanced Conversions等）を実装し、ブラウザ側のトラッキングブロッカーを回避する

### §153. Privacy-First Tracking

- **Rule 33.154**: Cookie同意バナーを法域に応じて実装する（GDPR: オプトイン / 日本: オプトアウト）
- **Consent Management**: ユーザーの同意状態に基づきトラッキングスクリプトのロードを制御する

### §155b. The Post-Privacy Sandbox Tracking Strategy

- **Rule 33.328**: Google Privacy Sandbox は **2025年10月に正式廃止**された。サードパーティCookieはChromiumブラウザで当面存続するが、以下のプライバシーAPIへの移行を推進する:
    - **CHIPS (Cookies Having Independent Partitioned State)**: パーティション化されたCookieで安全なクロスサイトデータ管理
    - **FedCM (Federated Credential Management)**: サードパーティCookieに依存しない連携ログインプロトコル
    - **Private State Tokens**: ボット判別・ユーザー信頼度の検証をCookie不要で実現
- **Strategic Shift**: サーバーサイドトラッキング（§152のCAPI統合）への移行が加速。クライアントサイドCookie依存度を段階的に削減する
- **ITP/ETP対応**: Safari（ITP）・Firefox（ETP）はサードパーティCookieを既に事実上ブロック済み。Chromiumでの存続に依存しないアーキテクチャを設計する
- **Cross-Reference**: `401_data_analytics.md`, `600_security_privacy.md`

### §154. UTM Parameter Management

- **Rule 33.155**: UTMパラメータをServer Actionで解析・保存し、マーケティングアトリビューション分析に活用する

### §155. Affiliate Link Protocol

- **Rule 33.156**: 外部アフィリエイトリンクは `next/script` で非同期ロードし、メインスレッドへの影響を最小化する

---

## Part XXIX: テスト戦略 🔀

### §156. Testing Trophy

- **Rule 33.157**: テスト戦略は「テストトロフィー」モデルに従う:
    - **Static Analysis** (ESLint + TypeScript): 最もコストが低く、最も多いカバレッジ
    - **Unit Tests** (Vitest): 純粋関数、ユーティリティ、バリデーションロジック
    - **Integration Tests** (Vitest + Testing Library): コンポーネント + フック
    - **E2E Tests** (Playwright): クリティカルユーザーフロー

### §157. Unit Test Standards

- **Rule 33.158**: Vitest を標準テストランナーとして使用する。Jest は新規プロジェクトでは非推奨
- **Coverage Target**: ビジネスロジック層（`lib/`, `utils/`）は **80%** カバレッジを目標

### §158. Component Testing

- **Rule 33.159**: React Testing Library でコンポーネントの**ユーザー行動**をテストする。実装詳細（state、props）のテストは禁止

### §159. E2E Testing

- **Rule 33.160**: Playwright を標準E2Eテストツールとして使用する
- **Critical Paths**: ログイン、サインアップ、決済、コンテンツ投稿等のクリティカルフローは必ずE2Eカバーする

### §160. Visual Regression Testing (VRT)

- **Rule 33.161**: StorybookのスナップショットまたはPlaywrightのスクリーンショット比較で意図しないUI変更を検出する

### §161. Lighthouse CI

- **Rule 33.162**: Lighthouse CIをPRパイプラインに統合し、パフォーマンス・SEO・A11yスコアの劣化を自動検出する
- **Threshold**: Performance ≥ 90, Accessibility ≥ 90, SEO ≥ 90

### §162. Storybook

- **Rule 33.163**: 共通UIコンポーネントはStorybookでカタログ化し、インタラクティブなドキュメントとして維持する
- **Play Function**: ユーザーインタラクションをPlay Functionで自動テストする

### §163. Server Component Testing

- **Rule 33.164**: RSCのテストは `next/test` ユーティリティまたは統合テストで実行する。RSC固有のデータフェッチロジックはモックせず、テスト用DBを使用する

---

## Part XXX: デプロイ & インフラ 🔀

### §164. Vercel Deployment

- **Rule 33.165**: Vercel を標準ホスティングプラットフォームとして使用する
- **Preview Deployments**: 全PRにPreview環境を自動デプロイし、コードレビューの品質を向上させる

### §165. ISR (Incremental Static Regeneration)

- **Rule 33.166**: 静的コンテンツ（ブログ、商品ページ等）にはISRを適用。`revalidate` 値はコンテンツ更新頻度に基づき設定（デフォルト: 3600秒）

### §166. Edge Config

- **Rule 33.167**: Feature Flags、A/Bテスト設定、リダイレクトルール等はEdge Config（Vercel Edge Config等）で管理し、デプロイ不要の即時反映を実現する

### §167. CDN Strategy

- **Rule 33.168**: 静的資産（画像、フォント、CSS/JS）は**CDN**からの配信を必須とする
- **Cache-Control**: `public, max-age=31536000, immutable`（ハッシュ付きアセット）

### §168. Production Monitoring

- **Rule 33.169**: 本番環境には以下のモニタリングを実装する:
    - **Error Tracking**: Sentry 等のエラートラッキングサービス
    - **RUM (Real User Monitoring)**: 実ユーザーのCWVデータ収集
    - **Alerting**: CWV劣化、エラー率上昇、レイテンシ増大時のアラート

### §169. Environment Separation Protocol

- **Rule 33.170**: 本番/ステージング/プレビューで環境変数を適切に分離する。本番環境変数がプレビュー環境に漏洩することを物理的に防止する

---

## Part XXXI: モダンWeb Platform API 🌐

### §170. The View Transitions API Protocol

- **Rule 33.171**: **View Transitions API** を活用し、ページ遷移・UI状態変更にブラウザネイティブのスムーズアニメーションを実装する
- **Same-Document**: SPAナビゲーションには `document.startViewTransition()` を使用
- **Cross-Document**: MPA対応のクロスドキュメント遷移は `@view-transition` at-rule で設定
- **CSS Customization**: `::view-transition-old` / `::view-transition-new` 擬似要素でアニメーションをカスタマイズ
- **Next.js Integration**: `next/navigation` の `useRouter` と組み合わせてルート遷移時のView Transitionを実装

### §171. The CSS Anchor Positioning Protocol

- **Rule 33.172**: **CSS Anchor Positioning** を活用し、ツールチップ・ポップオーバー・ドロップダウンのポジショニングをCSS純正で実装する
- **JavaScript Reduction**: Floating UI / Popper.js 等のJSライブラリ依存を段階的に削減する
- **Fallback**: ブラウザサポートが不十分な場合は `@supports (anchor-name: --anchor)` でフォールバックを提供

### §172. The CSS Scope Protocol

- **Rule 33.173**: `@scope` at-rule を使用してCSSのスコーピングを明示化し、コンポーネント間のスタイル汚染を防止する
- **Design System**: デザインシステムのトークン適用範囲を `@scope` で制限し、意図しないカスケードを排除

### §173. The Popover API Protocol

- **Rule 33.174**: HTML `popover` 属性を活用し、ポップオーバー・ツールチップ・トーストの表示をブラウザネイティブAPIで実装する
- **Top Layer**: Popover APIは自動的にTop Layerに配置されるため、z-index管理が不要

### §174. The Dialog Element Protocol

- **Rule 33.175**: モーダルダイアログには `<dialog>` 要素の `showModal()` を使用する。カスタムモーダル実装よりセマンティック・アクセシブル・安全

### §175. The Scroll-Driven Animations Protocol

- **Rule 33.176**: スクロール連動アニメーションには CSS `animation-timeline: scroll()` または `animation-timeline: view()` を使用し、JavaScriptの `scroll` イベント + `requestAnimationFrame` パターンを置き換える

### §176. The CSS Nesting Protocol

- **Rule 33.177**: ネイティブCSS Nesting（`&` セレクタ）が利用可能な環境では、SassやPostCSS Nestingプラグインの依存を段階的に削減する

### §177. The CSS `@property` Protocol

- **Rule 33.178**: `@property` at-rule を使用しCSS Custom Propertiesの型・初期値・継承を宣言する。カスタムプロパティのアニメーション（グラデーション遷移等）を実現

### §178. The CSS `@starting-style` Protocol

- **Rule 33.179**: `@starting-style` を活用し、`display: none` から表示される要素のエントリーアニメーションをCSS純正で実現する。JavaScript不要のフェードイン・スライドインを実装

### §179. The CSS Grid Lanes (Masonry) Protocol

- **Rule 33.180**: CSS Grid LevelsのMasonry Layout（`grid-template-rows: masonry`）が安定化次第、JavaScriptベースのMasonryライブラリ（Masonry.js等）を段階的に置き換える
- **Progressive Enhancement**: `@supports (grid-template-rows: masonry)` でフィーチャーディテクトし、CSSネイティブ実装にフォールバック

### §309. The Navigation API Protocol

- **Rule 33.302**: **Navigation API** を活用し、SPAナビゲーションをブラウザネイティブで制御する
- **vs History API**: History API よりも直感的なイベントドリブンナビゲーションを提供
- **`navigate` イベント**: `navigation.addEventListener('navigate', ...)` で全ナビゲーションをインターセプト
- **Transition Support**: `NavigateEvent.intercept()` でナビゲーションをインターセプトし、データフェッチやアニメーションを実行
- **State Management**: `navigation.entries()` でナビゲーション履歴の状態を安全に参照
- **Framework Note**: Next.js App Routerは内部的にルーティングを管理するため、直接の使用はフレームワーク非依存のケースに限定

```typescript
// ✅ Navigation API によるSPAナビゲーション制御
navigation.addEventListener('navigate', (event) => {
  if (!event.canIntercept) return;
  const url = new URL(event.destination.url);

  if (url.pathname.startsWith('/app/')) {
    event.intercept({
      async handler() {
        const content = await fetchPageContent(url.pathname);
        renderPage(content);
      },
    });
  }
});
```

### §310. The CSS `color-mix()` & Relative Color Syntax Protocol

- **Rule 33.303**: CSS `color-mix()` 関数と **Relative Color Syntax** を活用し、設計トークンの動的な色操作をCSS純正で実現する
- **color-mix()**: 2色を任意の比率で混合（`color-mix(in oklch, var(--primary), white 20%)`）
- **Relative Color Syntax**: 既存の色をベースに透過度・彩度・明度を変更（`oklch(from var(--primary) l c h / 50%)`）
- **Design System**: hover・アクティブ・ディスエーブルの各状態色をベースカラーから動的生成し、トークン数を削減
- **Color Space**: `oklch` / `oklab` を推奨。人間の知覚に基づいた線形補間で色混合結果が自然

```css
/* ✅ color-mix() と Relative Color Syntax */
:root {
  --primary: oklch(0.65 0.25 265);
  --primary-hover: color-mix(in oklch, var(--primary), white 15%);
  --primary-active: color-mix(in oklch, var(--primary), black 10%);
  --primary-ghost: oklch(from var(--primary) l c h / 10%);
}
```

---

## Part XXXII: フロントエンド可観測性 & RUM 🌐

### §180. Real User Monitoring (RUM)

- **Rule 33.181**: 本番環境ではRUM（Real User Monitoring）を実装し、Lighthouse CI（Lab Data）との乖離を検出する
- **CWV RUM**: `web-vitals` ライブラリで LCP / INP / CLS を実ユーザーデータとして収集する
- **Percentile Tracking**: p75 / p95 / p99 の各パーセンタイルで追跡する

### §181. OpenTelemetry Browser SDK

- **Rule 33.182**: フロントエンド固有のトレースには **OpenTelemetry Browser SDK** を導入し、バックエンドのトレースと統合する
- **Span**: ページロード、ナビゲーション、API呼び出し、ユーザーインタラクションの各スパンを計測

### §182. Error Boundary Telemetry

- **Rule 33.183**: Error Boundary でキャッチされたエラーは Sentry 等のエラートラッキングサービスに自動送信する
- **Context**: エラー送信時にユーザーID、ページURL、コンポーネントスタック、直前のユーザー操作を付与する

### §183. Performance Budget Monitoring

- **Rule 33.184**: バンドルサイズ・初期ロード時間の予算監視をCIに統合し、予算超過時にPRを自動ブロックする

### §184. Custom Metrics

- **Rule 33.185**: ビジネス固有のカスタムメトリクス（Time to First Search Result、Time to First Meaningful Paint等）を定義・計測する

### §185. Session Replay

- **Rule 33.186**: エラー再現のためにセッションリプレイ（Sentry Session Replay等）を導入する。ただし PII（個人識別情報）はマスキング必須

---

## Part XXXIII: AI統合 & LLMストリーミングUI 🔀

### §186. AI Copilot UI

- **Rule 33.187**: AIアシスタント・チャットボットUIには以下のパターンを遵守する:
    - **ストリーミング表示**: SSE / WebSocket でトークン単位のストリーミングレンダリング
    - **Skeleton State**: AI応答待ち時は構造化されたSkeletonローディングを表示
    - **Stop Generation**: ユーザーが生成を中断できるボタンを提供
- **Vercel AI SDK**: `ai` パッケージの `useChat` / `useCompletion` フックを活用し、ストリーミングUIを宣言的に実装する

### §187. The Citation Transparency Protocol

- **Rule 33.188**: AI生成コンテンツには情報源の引用・参照リンクを表示する。根拠なしのAI回答は「このAI回答は参考情報です」と免責表示する
- **Cross-Reference**: `400_ai_engineering.md`

### §188. The AI Content Rendering Safety Protocol

- **Rule 33.189**: AI生成テキストのHTML/Markdownレンダリングにはサニタイズ処理（DOMPurify等）を必須とする。XSSインジェクションを防止

### §189. The Optimistic AI Response Protocol

- **Rule 33.190**: AIタスク（要約、翻訳等）の実行中はプログレスインジケータを表示し、完了後に結果を差し替える

### §190. The AI Rate Limiting UI Protocol

- **Rule 33.191**: AIサービスのレート制限到達時は、ユーザーに分かりやすいメッセージ（「しばらくお待ちください」）と待機時間の目安を表示する

### §191. The AI Accessibility Protocol

- **Rule 33.192**: AI生成コンテンツは `aria-live="polite"` で段階的にスクリーンリーダーに通知する

---

## Part XXXIV: Micro-Frontend & Module Federation 🌐

### §192. Micro-Frontend 適用基準

- **Rule 33.193**: Micro-Frontend は以下の条件を満たす場合にのみ適用する:
    - 複数チームが同一アプリのUI異なる領域を独立開発する
    - デプロイ独立性が必須
    - 異なる技術スタック（React + Vue等）を統合する必要がある
- **Warning**: 単一チームの小〜中規模プロジェクトでは過剰設計。モノリシックApp Router推奨

### §193. Module Federation 2.0

- **Rule 33.194**: Micro-Frontend の実装には **Module Federation 2.0**（Webpack/Rspack）を使用し、ランタイム依存共有とバージョン管理を実現する
- **Shared Dependencies**: React / React DOM はシングルトン共有として設定し、重複ロードを防止

### §194. Micro-Frontend Communication

- **Rule 33.195**: Micro-Frontend間の通信には **Custom Events** または **共有Event Bus** を使用する。直接的なimport/export依存は禁止

### §195. Shared Design System

- **Rule 33.196**: Micro-Frontend環境ではデザインシステムを独立パッケージとして公開し、全チームが同一のUI/UX基準を共有する

### §196. Independent Deployment Protocol

- **Rule 33.197**: 各Micro-Frontendモジュールは独立してデプロイ可能であること。他モジュールのデプロイに依存してはならない

---

## Part XXXV: Web Worker & Off-Main-Thread 🌐

### §197. The Off-Main-Thread Strategy

- **Rule 33.198**: メインスレッドのブロッキングは INP 劣化の直接原因。以下の処理はWeb Workerにオフロードする:
    - 大量データの集計・変換・フィルタリング
    - 画像処理（リサイズ、フォーマット変換）
    - 暗号化・ハッシュ計算
    - JSON/CSVの大量パース

### §198. Comlink Integration

- **Rule 33.199**: Web Worker との通信には **Comlink** ライブラリを使用し、Promise ベースの直感的なAPIでWorkerを呼び出す

### §199. SharedWorker Protocol

- **Rule 33.200**: 複数タブ間でのデータ共有が必要な場合は **SharedWorker** を検討する。ただしブラウザサポートを確認の上で使用する

### §200. Worker CSP Compatibility

- **Rule 33.201**: Web Worker の CSP 設定に `worker-src 'self' blob:;` を含める（§18参照）

---

## Part XXXVI: フロントエンドセキュリティ深化 🌐

### §201. The Trusted Types Protocol

- **Rule 33.202**: **Trusted Types API** を導入し、DOM XSS を根本的に防止する
- **CSP Header**: `Content-Security-Policy: require-trusted-types-for 'script'` を設定
- **Policy**: `trustedTypes.createPolicy()` でDOM操作のサニタイズポリシーを定義する

### §202. The Subresource Integrity (SRI) Protocol

- **Rule 33.203**: 外部CDNから読み込むスクリプト・スタイルシートには **SRI（Subresource Integrity）** ハッシュを付与し、改竄を検出する

### §203. The CSP Strict Dynamic Protocol

- **Rule 33.204**: Content Security Policy は `'strict-dynamic'` + nonce ベースのポリシーを推奨する
- **Report-Only**: 導入初期は `Content-Security-Policy-Report-Only` でレポート収集し、ブロッキングはしない

### §203b. The CSP Level 3 Protocol

- **Rule 33.329**: **CSP Level 3** Working Draft（W3C 2026）へ段階的に移行する
- **Enhanced Directives**: `script-src-elem`, `script-src-attr`, `style-src-elem`, `style-src-attr` でスクリプト・スタイルの適用範囲をより精密に制御
- **Reporting API v2**: `report-to` ディレクティブで CSP 違反レポートを Reporting API v2 に送信し、`report-uri`（非推奨）からの移行を進める
- **Worker CSP**: `worker-src` でWeb Worker / Service Workerのスクリプトソースを分離制御する

### §204. The CORS Protocol

- **Rule 33.205**: API Routes / Server Actions の CORS 設定は最小権限原則で設定する。`*` のワイルドカード Origin は本番禁止

### §205. The Dependency Vulnerability Protocol

- **Rule 33.206**: `npm audit` / `pnpm audit` をCIに統合し、高・クリティカルの脆弱性を含むPRを自動ブロックする
- **Cross-Reference**: `602_oss_compliance.md`

### §206. The Permissions Policy Protocol

- **Rule 33.207**: `Permissions-Policy` ヘッダーを設定し、ブラウザ機能（カメラ、マイク、位置情報等）へのアクセスを明示的に制御する。不要な機能は `=()` で無効化

### §206b. The OWASP 2026 Compliance Protocol

- **Rule 33.330**: **OWASP Top 10 2026** の新カテゴリをフロントエンド設計に反映する:
    - **A03: Software Supply Chain Failures**: npm/pnpmの依存パッケージの脆弱性監視を強化する。`npm audit --audit-level=high` のCIゲート化に加え、lockfileの差分レビューを必須化。依存パッケージの署名検証（npm provenance）の導入を検討する
    - **A10: Mishandling of Exceptional Conditions**: フロントエンドの例外処理を厳格化する。全Error Boundary（§134–§139）のテストカバレッジ確保、未処理Promise rejectionの監視（`unhandledrejection` イベントリスナー）、Sentry等でのスタックトレース完全補捉を義務付ける
- **Supply Chain Defense**: `npm-lockfile-lint` でlockfileの整合性を検証し、予期しないレジストリ変更を検出する
- **Cross-Reference**: `600_security_privacy.md`, `602_oss_compliance.md`

---

## Part XXXVII: フロントエンドFinOps 🌐

### §207. The Client-Side Cost Awareness

- **Rule 33.208**: フロントエンドの設計判断がインフラコストに直結することを認識する:
    - キャッシュなしの公開ページ → DB直撃 → コスト増大
    - 不要なAPI呼び出し → Lambda/Edge Function実行コスト増大
    - 過剰な画像サイズ → CDN転送コスト増大

### §208. The Cache Hit Rate Target

- **Rule 33.209**: 公開ページのキャッシュヒット率 **≥ 95%** を目標とする。ヒット率の低下はFinOpsアラートの対象

### §209. The Build Time Budget

- **Rule 33.210**: ビルド時間の予算: **≤ 5分**（CI環境）。超過する場合はTurbopack / Incremental Build の最適化を実施する

---

## Part XXXVIII: デザインシステム統合 🌐

### §210. Design Token Architecture

- **Rule 33.211**: デザイントークンは `tailwind.config.ts` の `theme.extend` で一元管理する。HEX値のハードコーディングは禁止
- **Semantic Tokens**: `primary`, `secondary`, `destructive`, `muted` 等のセマンティックな命名を使用する
- **DTCG Format**: Design Token Community Group（DTCG）フォーマット（`$value`, `$type`）の採用を検討し、デザインツール（Figma Tokens等）との相互運用性を確保する

### §211. Component Variant Pattern

- **Rule 33.212**: コンポーネントのバリエーション管理には **cva** (Class Variance Authority) を使用し、型安全なバリアントAPIを実装する

### §212. Theme Switching Protocol

- **Rule 33.213**: ダークモード/ライトモード切り替えは CSS Variables + `next-themes` で実装する。テーマ状態は `localStorage` に永続化

### §213. Design System Documentation

- **Rule 33.214**: デザインシステムのコンポーネントは Storybook でカタログ化・ドキュメント化し、デザイナー・開発者が共通参照点として活用できるようにする

### §214. Design System Versioning

- **Rule 33.215**: デザインシステムパッケージはSemantic Versioningに従い、破壊的変更にはメジャーバージョンアップとマイグレーションガイドを提供する

---

## Part XXXIX: 禁止アンチパターン集（30選）🌐

### §215. The Client DB Access Ban
- **Rule 33.216**: クライアントコンポーネントからDBに直接クエリを発行することは厳禁。全DB操作はServer Actions / Route Handlersを経由する

### §216. The Anchor Tag Nesting Violation Ban
- **Rule 33.217**: `<a>` タグ内に `<a>` タグやインタラクティブ要素（`<button>`）をネストすることは禁止

### §217. The Server-Side DOM Access Ban
- **Rule 33.218**: Server Components 内で `window`, `document`, `localStorage` にアクセスすることは禁止

### §218. The Recursive Rendering Ban
- **Rule 33.219**: 再帰的にレンダリングするコンポーネント（ツリービュー等）には必ず**深さ制限**を設定する

### §219. The Double Scrollbar Ban
- **Rule 33.220**: ネストされたスクロールコンテナの二重スクロールバーは厳禁

### §220. The Fragment Misuse Ban
- **Rule 33.221**: `key` 属性が必要なリストレンダリングで `<>...</>` ショートハンドを使用し、キー警告を放置することは禁止

### §221. The Inline Style Object Ban
- **Rule 33.222**: JSX内でインラインスタイルオブジェクト（`style={{ margin: '10px' }}`）を直接記述することは原則禁止

### §222. The Event Handler Inline Function Ban
- **Rule 33.223**: リストのmapレンダー内でインラインアロー関数をイベントハンドラとして使用することは原則禁止

### §223. The Image Without Dimensions Ban
- **Rule 33.224**: `<img>` / `<Image>` に `width` と `height`（または `fill` + wrapper sizing）なしで使用することは禁止。CLS直接原因

### §224. The useEffect for Derived State Ban
- **Rule 33.225**: 他のstateから計算可能な値を `useEffect` + `setState` で同期する「ミラーリングパターン」は禁止

### §225. The Non-null Assertion Ban
- **Rule 33.226**: `data!.property` の使用は禁止。Optional Chaining（`data?.property`）を使用

### §226. The Index as Key Ban
- **Rule 33.227**: リストの順序変更・追加・削除がある場合のインデックス `key={index}` 使用は禁止

### §227. The String Concatenation for ClassNames Ban
- **Rule 33.228**: テンプレートリテラルや文字列結合でCSSクラスを生成することは禁止。`cn()` / `clsx` を使用

### §228. The Global CSS Pollution Ban
- **Rule 33.229**: コンポーネント固有のCSSをグローバルスタイルシートに記述することは禁止

### §229. The setTimeout for State Sync Ban
- **Rule 33.230**: `setTimeout(() => setState(...), 0)` のタイマーハックは禁止

### §230. The Any Type Escape Ban
- **Rule 33.231**: TypeScriptの `any` 型でビルドエラーを回避することは禁止

### §231. The Direct DOM Manipulation Ban
- **Rule 33.232**: `document.getElementById()` を使ったReactの仮想DOMをバイパスする直接DOM操作は原則禁止。`useRef` を使用

### §232. The Deeply Nested Ternary Ban
- **Rule 33.233**: 3段階以上ネストした三項演算子は禁止。Early Return パターンに変換

### §233. The Magic Number/String Ban
- **Rule 33.234**: コード内のマジックナンバー・マジックストリングは禁止。定数や`enum`を定義

### §234. The Lazy Redirect Ban
- **Rule 33.235**: 条件分岐のない冗長リダイレクトは禁止。ルーティング構造で解決

### §235. The Uncontrolled Re-render Ban
- **Rule 33.236**: `useEffect` 内での `setState` がレンダーサイクルを無限に繰り返すパターンは禁止

### §236. The Prop Drilling Ban
- **Rule 33.237**: 3層以上のProp Drillingは禁止。Context API、Zustand、またはコンポーネント合成で解決

### §237. The Unreachable Code Ban
- **Rule 33.238**: `return` 文の後のコード等の到達不能コードは即座に削除

### §238. The Console.log in Production Ban
- **Rule 33.239**: `console.log` は開発専用。本番ビルドでは `no-console` で禁止

### §239. The Synchronous localStorage Ban
- **Rule 33.240**: 大量データの読み書きは非同期ストレージ（IndexedDB）を使用

### §240. The Wildcard Import Ban
- **Rule 33.241**: `import * as X from 'module'` のワイルドカードインポートはTree Shakingを阻害するため禁止。named importを使用

### §241. The Inline SVG Bloat Ban
- **Rule 33.242**: 100行以上の複雑なSVGをJSX内にインライン展開することは禁止。外部ファイルとして分離しコンポーネント化する

### §242. The Untyped Event Handler Ban
- **Rule 33.243**: イベントハンドラの引数を `any` や未型付きで受け取ることは禁止。`React.MouseEvent<HTMLButtonElement>` 等の正確な型を使用

### §243. The Layout Thrashing Ban
- **Rule 33.244**: `offsetHeight` 等の読み取りと `style` 書き込みを交互に行うLayout Thrashingパターンは禁止。読み取りをバッチ化するか `requestAnimationFrame` で分離

### §244. The Uncontrolled Third-Party CSS Ban
- **Rule 33.245**: サードパーティライブラリのCSSをグローバルインポートしてプロジェクトのスタイルを汚染することは禁止。CSS Modulesまたはスコープ化して隔離

---

## Part XL: Monorepo & Multi-App 戦略 🔀

### §245. Turborepo Standard

- **Rule 33.246**: Monorepo構成には **Turborepo** を標準ツールとして使用する
- **Pipeline**: `build`, `lint`, `test`, `type-check` のタスクグラフを定義し、並列実行とキャッシュを最大化
- **Remote Cache**: Vercel Remote CacheまたはカスタムS3キャッシュでCI時間を短縮

### §246. Shared Package Architecture

- **Rule 33.247**: Monorepo内の共有パッケージは以下の構成を標準とする:
    - `packages/ui` — デザインシステムコンポーネント
    - `packages/config` — ESLint / TypeScript / Tailwind 共有設定
    - `packages/utils` — 共有ユーティリティ関数
    - `packages/types` — 共有型定義

### §247. Internal Package Protocol

- **Rule 33.248**: 内部パッケージは `"main": "./src/index.ts"` で直接TypeScriptソースを参照する（ビルド不要）。Next.js の `transpilePackages` で自動トランスパイル

### §248. Dependency Boundary Protocol

- **Rule 33.249**: アプリ固有の依存関係を共有パッケージに含めることは禁止。共有パッケージは最小限の依存で構成する

### §249. Workspace Version Protocol

- **Rule 33.250**: ワークスペース間の依存バージョンは統一する。React / TypeScript / Tailwind のバージョン不整合は即座に修正

---

## Part XLI: リアルタイム通信 🌐

### §250. WebSocket Architecture

- **Rule 33.251**: WebSocketの使用は以下のユースケースに限定する:
    - チャット・メッセージング
    - リアルタイムコラボレーション（共同編集等）
    - ゲーム・ライブ配信
- **Reconnection**: 指数バックオフ付き自動再接続を実装する

### §251. Server-Sent Events (SSE) Protocol

- **Rule 33.252**: 一方向のリアルタイムデータストリーミング（通知、フィード更新、AI応答ストリーミング等）には **SSE** を優先する
- **Benefit**: WebSocketより軽量。HTTPインフラ（CDN、ロードバランサー）との互換性が高い

### §252. WebTransport Protocol

- **Rule 33.253**: 低レイテンシ双方向通信が必要な先進的ユースケースでは **WebTransport** APIを検討する。ただしブラウザサポートを確認

### §253. Real-Time UI State

- **Rule 33.254**: リアルタイムデータの表示には楽観的UIパターンを適用し、ネットワーク遅延がUXに影響しないようにする
- **Presence**: オンライン状態表示は polling ではなく WebSocket / SSE で実装する

---

## Part XLII: 認証UI & セッション管理 🔀

### §254. Auth UI Best Practices

- **Rule 33.255**: ログイン/サインアップフォームは以下を遵守する:
    - パスワードマネージャー互換（`autocomplete` 属性の適切な設定）
    - ソーシャルログインボタンの一貫したデザイン
    - エラーメッセージでメールアドレスの存在を暴露しない（「メールまたはパスワードが正しくありません」）

### §255. Passkey Support

- **Rule 33.256**: WebAuthn / Passkey をサポートし、パスワードレス認証を推進する。`navigator.credentials.create()` / `get()` APIを活用

### §256. Session Token Security

- **Rule 33.257**: セッショントークンは `HttpOnly`, `Secure`, `SameSite=Lax` のCookieに保存する。`localStorage` へのトークン保存は禁止
- **Cross-Reference**: `600_security_privacy.md`

### §257. Auth State UI Protocol

- **Rule 33.258**: 認証状態に応じたUI切り替えはServer Component層で実行する。Client Componentでの認証チェックは補助的にのみ使用

### §258. Protected Route Protocol

- **Rule 33.259**: 認証が必要なルートは `middleware.ts` でEdge Middlewareレベルでガードする。ページコンポーネント内での認証チェックのみに依存しない

---

## Part XLIII: Animation & Motion Design 🌐

### §259. The Performance-First Animation Protocol

- **Rule 33.260**: アニメーションは `transform` と `opacity` のみを使用する。`width`, `height`, `top`, `left` 等のレイアウトプロパティのアニメーションはLayout Thrashingの原因となるため原則禁止
- **will-change**: 必要な場合のみ `will-change` を使用し、アニメーション完了後は削除する

### §260. The Animation Library Protocol

- **Rule 33.261**: アニメーションライブラリの選定基準:
    - **CSS Transitions / Animations**: 単純なホバー・フェード・スライド
    - **Framer Motion**: Reactコンポーネントのマウント/アンマウントアニメーション、ジェスチャー
    - **GSAP**: 複雑なタイムライン・スクロール連動アニメーション
- **Bundle Impact**: アニメーションライブラリのバンドルサイズを常に意識。CSS純正で可能な場合はCSS優先

### §261. The Micro-Interaction Protocol

- **Rule 33.262**: ボタンクリック、フォーム送信、状態変更等の主要UIイベントにマイクロインタラクション（0.1〜0.3秒の短いフィードバック）を実装する

### §262. The Loading Animation Protocol

- **Rule 33.263**: コンテンツロード中はSkeleton UIを使用する。スピナーは最終手段。プログレスバーはダウンロード/アップロードの進捗に限定

### §263. The Page Transition Protocol

- **Rule 33.264**: ページ遷移アニメーションはView Transitions API（§170）を優先する。200〜400msの遷移時間を目安とする

### §264. The Reduced Motion Compliance

- **Rule 33.265**: 全アニメーション実装は `prefers-reduced-motion: reduce` メディアクエリ対応を必須とする（§124との統合）

---

## Part XLIV: レスポンシブ & マルチデバイス 🌐

### §265. Fluid Typography

- **Rule 33.266**: `clamp()` 関数を使用したFluid Typographyで、ビューポートサイズに応じた滑らかなフォントサイズ変更を実装する
- **Example**: `font-size: clamp(1rem, 0.5rem + 1.5vw, 2rem)`

### §266. Mobile-First Breakpoints

- **Rule 33.267**: レスポンシブデザインはMobile-First（`min-width` ベース）で設計する。Desktop-Firstのオーバーライドは避ける

### §267. Touch Target Size

- **Rule 33.268**: タッチターゲットは最低 **44×44px** を保証する（WCAG 2.2 Target Size 基準）。小さなリンクやボタンにはパディングで領域を拡大

### §268. Foldable Device Support

- **Rule 33.269**: 折りたたみデバイス（Fold）対応として `screen-spanning` メディアクエリと `env()` CSS変数を検討する

### §269. Viewport Unit Protocol

- **Rule 33.270**: モバイルブラウザのアドレスバー対応として `dvh` / `svh` / `lvh` を適切に使い分ける。レガシーな `vh` のみに依存しない

### §270. Print Stylesheet Protocol

- **Rule 33.271**: 印刷が想定されるページ（レシート、請求書、レポート等）には `@media print` スタイルシートを提供する

---

## Part XLV: E-Commerce フロントエンド 🔀

### §271. Cart UI Protocol

- **Rule 33.272**: カートUIは楽観的更新パターンで即座に反映し、サーバー同期は非同期で実行する。数量変更のデバウンスは300msを推奨

### §272. Checkout Flow Protocol

- **Rule 33.273**: チェックアウトフローはステップインジケータ付きのマルチステップ形式で実装し、各ステップでバリデーションを実行する。カートの不整合（在庫切れ、価格変更）を最終確認で検出する

### §273. PCI DSS Compliance

- **Rule 33.274**: 決済フォームではPCI DSS準拠のため、カード情報を直接サーバーに送信しない。Stripe Elements / PayPay SDK等のトークン化SDKを使用する

### §274. Product Display Protocol

- **Rule 33.275**: 商品画像はズーム機能、ギャラリースワイプ、動画サムネイルをサポートする。画像最適化は §99 に準拠

### §275. Price Display Protocol

- **Rule 33.276**: 価格表示は `Intl.NumberFormat` でロケール対応フォーマットし、通貨コードを明示する。内部的には最小通貨単位（整数）で管理する

### §276. Inventory Status Protocol

- **Rule 33.277**: 在庫状況（在庫あり / 残りわずか / 在庫切れ）はリアルタイムで更新する。在庫数の正確な表示はSSE/Pollingで同期する

---

## Part XLVI: フロントエンドDevOps 🌐

### §277. ESLint Flat Config Standard

- **Rule 33.278**: ESLint 9+の Flat Config（`eslint.config.mjs`）を標準とする。レガシー `.eslintrc` 形式は新規プロジェクトで禁止

### §278. Biome Integration

- **Rule 33.279**: **Biome v2** を ESLint + Prettier の代替として**新規プロジェクトでは第一選択**とする。単一ツールでのLint + Formatにより設定の簡素化とパフォーマンス向上を実現
- **Maturity**: Biome v2 は ESLint/Prettier の主要ルールの90%以上をカバーし、10〜100倍のパフォーマンスを実現。TypeScript / JSX / CSS / JSON のフォーマットとリントを単一バイナリで提供
- **Migration**: 既存プロジェクトでは `biome migrate` コマンドでESLint設定からの段階的移行を推奨
- **CI Integration**: `biome ci` コマンドでCI/CDパイプラインに統合。`--error-on-warnings` フラグで警告のPRマージブロックを実現

### §279. CI Pipeline Optimization

- **Rule 33.280**: CI パイプラインの最適化:
    - `pnpm install --frozen-lockfile` で再現性を保証
    - Turbopack / Turborepo の Remote Cache を活用
    - 型チェック・Lint・テストの並列実行

### §280. Pre-commit Hooks

- **Rule 33.281**: `lint-staged` + `husky` でコミット前にLint / Format / 型チェックを実行する。低品質コードのリポジトリ混入を物理的に防止

### §281. Branch Preview Protocol

- **Rule 33.282**: 全PRにプレビュー環境を自動デプロイし、PRレビュアーが実際のUIを確認できるようにする

### §282. Dependency License Audit

- **Rule 33.283**: `license-checker` / `license-report` をCIに統合し、GPLl・AGPL等のコピーレフトライセンス依存を自動検出する
- **Cross-Reference**: `602_oss_compliance.md`

---

## Part XLVII: サードパーティスクリプト管理 🌐

### §283. The Third-Party Script Isolation Protocol

- **Rule 33.284**: サードパーティスクリプト（Analytics、Chat、Ad等）はメインスレッドをブロックしてはならない。`next/script` の `lazyOnload` 戦略で遅延ロードする

### §284. The Partytown Protocol

- **Rule 33.285**: メインスレッドへの影響が大きいサードパーティスクリプトは **Partytown** でWeb Workerにオフロードすることを検討する

### §285. The GTM Management Protocol

- **Rule 33.286**: Google Tag Manager（GTM）はServer-Side GTMを推奨し、クライアントサイドのスクリプト数を最小化する

### §286. The Consent-Aware Script Loading

- **Rule 33.287**: トラッキングスクリプトはCookie同意状態に基づき条件分岐でロードする。同意前のスクリプトロードは法的リスク

### §287. The Third-Party Performance Audit

- **Rule 33.288**: 四半期毎にサードパーティスクリプトのパフォーマンス影響を監査する。不使用または高負荷のスクリプトは削除対象

---

## Part XLVIII: Sustainability & Green Frontend 🌐

### §288. The Carbon-Aware Frontend Protocol

- **Rule 33.289**: フロントエンドの設計判断がカーボンフットプリントに影響することを認識する:
    - 不要なAPI呼び出し → サーバーエネルギー消費
    - 過剰な画像サイズ → ネットワークエネルギー消費
    - 非効率なJavaScript → クライアントCPUエネルギー消費

### §289. The Sustainable Image Protocol

- **Rule 33.290**: 画像は §99–§105 の最適化を徹底し、転送データ量を最小化する。AVIFフォーマットの採用は環境負荷低減にも直結する

### §290. The Dark Mode Energy Protocol

- **Rule 33.291**: OLEDデバイスではダークモードが消費電力を削減する。ダークモードをデフォルトオプションとして提供することを推奨

### §291. The Efficient Rendering Protocol

- **Rule 33.292**: 不要な再レンダリングを排除し、CPUサイクルとバッテリー消費を最小化する。React Compiler（§47）の採用により自動最適化

### §292. The SCI Measurement Protocol

- **Rule 33.293**: Software Carbon Intensity（SCI）スコアの計測を検討する。GreenFrame等のツールでCIパイプラインにカーボン測定を統合

---

## Part XLIX: 成熟度モデル・将来展望 🌐

### §293. フロントエンド成熟度モデル（5段階）

| レベル | 名称 | 特徴 |
|:------|:-----|:-----|
| **L1** | Reactive | jQuery/Vanilla JSベース、手動DOM操作 |
| **L2** | Component | React/Vue導入、コンポーネント化 |
| **L3** | Type-Safe | TypeScript Strict、Zodバリデーション、CI/CD |
| **L4** | Performance-Driven | CWV自動ゲート、Bundle Budget、Lighthouse CI |
| **L5** | AI-Augmented | AI駆動最適化、Predictive Prefetch、自動A/Bテスト |

### §294. React Compiler Evolution

- **展望**: React Compiler v1.0の GA リリースにより、手動の `useMemo` / `useCallback` は**完全に不要**となった。今後はコンパイラの更なる最適化（サーバーコンポーネント対応等）に追従する

### §295. Server Components Evolution

- **展望**: RSCの機能拡張（Server Action Streaming、PPR安定化等）に追従する

### §296. WebAssembly Integration

- **展望**: WasmベースのモジュールによるCPU集約処理（画像処理、暗号化等）のフロントエンド統合が一般化する

### §297. WebGPU Frontend

- **展望**: WebGPU APIによるGPU並列処理がフロントエンドでの高度な可視化・AI推論を実現する

### §298. Spatial Computing

- **展望**: WebXR / Spatial Computing対応のUI設計パターンが確立され、3Dインタラクションが標準化する

### §299. AI-Native Frontend

- **展望**: AIがUIコンポーネント生成・レイアウト最適化・パーソナライゼーションを自動化するフロントエンド開発パラダイムへの準備を進める

### §300. Edge-First Architecture

- **展望**: Edge Computing First のアーキテクチャにより、オリジンサーバーへの依存を最小限にし、グローバルな低レイテンシを実現する

---

## Part LI: Next.js 16 移行 & 新機能 ⚛️

### §311. The proxy.ts Migration Protocol

- **Rule 33.305**: Next.js 16 では `middleware.ts` が `proxy.ts` に置き換えられた。全プロジェクトで `proxy.ts` への移行を実施する
- **Runtime**: `proxy.ts` は Node.js ランタイムで実行される（Edge Runtime ではない）。全Node.js APIが利用可能
- **Migration**: 既存の `middleware.ts` のロジックを `proxy.ts` に移行。リクエストインターセプト・リダイレクト・ヘッダー操作のAPIが明確化
- **Breaking**: `NextResponse.next()` → `proxy.next()` への変更が必要

```typescript
// ✅ proxy.ts（Next.js 16）
import { type ProxyRequest } from 'next/server';

export default function proxy(request: ProxyRequest) {
  // 認証チェック
  const token = request.cookies.get('session');
  if (!token && request.nextUrl.pathname.startsWith('/dashboard')) {
    return Response.redirect(new URL('/login', request.url));
  }

  // CSPヘッダー追加
  const nonce = crypto.randomUUID();
  const headers = new Headers(request.headers);
  headers.set('Content-Security-Policy', `script-src 'nonce-${nonce}' 'strict-dynamic'`);
  
  return proxy.next({ headers });
}

export const config = {
  matcher: ['/((?!_next/static|favicon.ico).*)'],
};
```

### §312. The `use cache` GA Protocol

- **Rule 33.306**: Next.js 16で GA に昇格した `'use cache'` ディレクティブを活用し、明示的なキャッシュ制御を実装する
- **Scope**: ページ全体、コンポーネント単位、関数単位でキャッシュを適用可能
- **vs unstable_cache**: `unstable_cache` から `'use cache'` への段階的移行を推奨。`unstable_cache` は非推奨
- **Tag Management**: `cacheTag()` でキャッシュタグを付与し、`revalidateTag()` で選択的無効化

```typescript
// ✅ 'use cache' ディレクティブ（Next.js 16 GA）
import { cacheTag, cacheLife } from 'next/cache';

async function getProduct(id: string) {
  'use cache';
  cacheTag(`product-${id}`);
  cacheLife('hours'); // プリセット: 'seconds' | 'minutes' | 'hours' | 'days' | 'weeks' | 'max'
  
  const product = await db.product.findUnique({ where: { id } });
  return product;
}
```

### §313. Turbopack File System Caching

- **Rule 33.307**: Turbopack の **ファイルシステムキャッシング**（Beta）を有効化し、大規模アプリケーションの起動時間を大幅に短縮する
- **Config**: `next.config.ts` に `experimental.turbopackFileSystemCaching: true` を設定
- **Benefit**: 2回目以降の `next dev` / `next build` でインクリメンタルキャッシュを活用し、起動時間を最大70%短縮
- **Cache Location**: `.next/cache/turbopack` に自動保存。CIでのキャッシュ保存を推奨

### §314. Next.js DevTools MCP Protocol

- **Rule 33.308**: **Next.js DevTools MCP**（Model Context Protocol）サーバーを活用し、AI支援のデバッグ環境を構築する
- **Feature**: ビルドエラー、パフォーマンスボトルネック、ルーティング問題をAIアシスタントがコンテキストを理解した上で分析
- **Integration**: VS Code / Cursor 等のAI対応エディタと連携し、開発効率を向上

### §315. The updateTag API Protocol

- **Rule 33.309**: Next.js 16 の `updateTag()` API を活用し、キャッシュタグの値をリバリデーションなしに更新する
- **vs revalidateTag**: `revalidateTag()` はキャッシュを無効化して再取得。`updateTag()` は値を直接更新し、サーバー負荷を軽減
- **Use Case**: リアルタイムに近い更新（在庫数、いいね数等）でキャッシュ効率を最大化

### §316. The Incremental Prefetching Protocol

- **Rule 33.310**: Next.js 16 の **インクリメンタルプリフェッチ**を活用し、ビューポート検出とホバートリガーに基づく段階的プリフェッチを実現する
- **Layout Deduplication**: 共有レイアウトは1回のみダウンロードし、ルート個別のデータのみ追加フェッチ
- **Priority**: CTA・メインナビゲーションは `hovering` トリガー、サイドバーリンクは `viewport` トリガーを適用

---

## Part LII: GraphQL Frontend Architecture 🌐

### §317. GraphQL Client Standard

- **Rule 33.311**: GraphQL クライアントには **urql** または **Apollo Client** を使用する。以下の基準で選択:
    - **urql**: 軽量・シンプル・SSR友好。小〜中規模プロジェクト推奨
    - **Apollo Client**: 高度なキャッシュ・ローカル状態統合。大規模プロジェクト推奨
- **Codegen**: `graphql-codegen` で型安全なフック・ドキュメントを自動生成する。手書きGraphQLクエリの型定義は禁止

### §318. The Fragment Colocation Protocol

- **Rule 33.312**: GraphQL Fragment はデータを消費するコンポーネントと同一ファイルに配置する（Fragment Colocation）
- **Benefit**: コンポーネントが必要とするデータ構造が一目で把握可能。不要フィールドの残留を防止
- **Naming**: Fragment名は `ComponentName_fieldName` 形式を必須とする

```typescript
// ✅ Fragment Colocation
import { graphql } from '@/gql';

const UserAvatar_user = graphql(`
  fragment UserAvatar_user on User {
    id
    name
    avatarUrl
  }
`);

export function UserAvatar({ user }: { user: FragmentType<typeof UserAvatar_user> }) {
  const data = useFragment(UserAvatar_user, user);
  return <img src={data.avatarUrl} alt={data.name} />;
}
```

### §319. The Persisted Query Protocol

- **Rule 33.313**: 本番環境では **Persisted Queries** を使用し、GraphQLクエリ文字列のネットワーク転送とセキュリティリスクを削減する
- **APQ**: Automatic Persisted Queries（APQ）でハッシュベースのクエリ識別を実装
- **Security**: 未登録クエリの実行拒否により、GraphQLインジェクション攻撃を防止

### §320. The GraphQL Error Handling Protocol

- **Rule 33.314**: GraphQL のエラーハンドリングは「部分成功」パターンを前提とする
- **Partial Data**: `data` と `errors` が同時に返される場合、利用可能なデータは表示しつつエラーを通知する
- **Error Classification**: ネットワークエラー（リトライ対象）とGraphQLエラー（ビジネスロジックエラー）を分離して処理する

---

## Part LIII: 型安全APIクライアント & tRPC 🔀

### §321. tRPC Standard

- **Rule 33.315**: フルスタックTypeScriptプロジェクトでは **tRPC** を検討し、エンドツーエンドの型安全性を実現する
- **Benefit**: APIスキーマ定義・型生成・クライアントコード生成が不要。TypeScript型がそのままAPI契約
- **Limitation**: TypeScript以外のクライアント（モバイルアプリ等）にはREST API / GraphQL を併用する

### §322. The OpenAPI TypeScript Client Protocol

- **Rule 33.316**: REST APIクライアントには `openapi-typescript` + `openapi-fetch` を使用し、OpenAPIスキーマから型安全なクライアントを自動生成する
- **Codegen**: CIパイプラインに型生成を統合し、APIスキーマ変更時に型不整合を自動検出する
- **Runtime Validation**: 受信データの実行時バリデーションには Zod を併用する（型安全だけでは不十分）

```typescript
// ✅ OpenAPI型安全クライアント
import createClient from 'openapi-fetch';
import type { paths } from '@/generated/api';

const client = createClient<paths>({ baseUrl: process.env.API_BASE_URL });

// 型安全なAPIコール — パス・メソッド・パラメータ・レスポンスすべてが型付き
const { data, error } = await client.GET('/api/products/{id}', {
  params: { path: { id: 'prod_123' } },
});
```

### §323. The API Schema Versioning Protocol

- **Rule 33.317**: APIスキーマのバージョン管理を実施し、フロントエンド・バックエンド間の契約を明確化する
- **Contract Testing**: Pact等のConsumer-Driven Contract Testingでフロントエンドの期待するAPIレスポンス構造をテストする
- **Breaking Change Detection**: CIでAPIスキーマの破壊的変更（フィールド削除、型変更等）を自動検出する

### §324. The API Response Normalization Protocol

- **Rule 33.318**: APIレスポンスの正規化はフロントエンド側の責務としてDTO変換層で実施する
- **Adapter Pattern**: `api/adapters/` にAPIレスポンス → フロントエンドモデルの変換ロジックを集約する
- **Isolation**: APIレスポンスの構造変更がコンポーネント層に波及しないよう、アダプターが変更を吸収する

---

## Part LIV: フロントエンドデータ品質 & Schema Contract 🌐

### §325. The Frontend Data Quality Gate

- **Rule 33.319**: フロントエンドで受信する外部データ（API・WebSocket・localStorage等）は、消費前に必ず Zod でバリデーションする
- **Trust Boundary**: フロントエンドの Trust Boundary は「自コンポーネントの props」まで。外部データはすべて untrusted として扱う
- **Error Recovery**: バリデーション失敗時はデフォルト値またはエラー状態にフォールバックする。クラッシュさせてはならない

```typescript
// ✅ 外部データのバリデーションゲート
import { z } from 'zod';

const ProductSchema = z.object({
  id: z.string(),
  name: z.string(),
  price: z.number().nonnegative(),
  currency: z.enum(['JPY', 'USD', 'EUR']),
  stockCount: z.number().int().nonnegative(),
});

type Product = z.infer<typeof ProductSchema>;

async function fetchProduct(id: string): Promise<Product | null> {
  const res = await fetch(`/api/products/${id}`);
  const json = await res.json();
  const result = ProductSchema.safeParse(json);
  
  if (!result.success) {
    console.error('Product data validation failed:', result.error);
    captureException(result.error); // Sentryに送信
    return null; // フォールバック
  }
  return result.data;
}
```

### §326. The Schema Contract Testing Protocol

- **Rule 33.320**: フロントエンドとバックエンドの間に**スキーマ契約テスト**を導入し、API構造の不整合を早期検出する
- **Implementation**: Zodスキーマ定義をフロントエンドとバックエンドで共有し、CIで整合性をテストする
- **Monorepo**: `packages/schemas/` に共有スキーマパッケージを配置する

### §327. The Stale Data Detection Protocol

- **Rule 33.321**: キャッシュされたデータの鮮度を管理し、Stale Dataがユーザーに表示されるリスクを最小化する
- **Staleness Indicator**: キャッシュ有効期限を超えたデータには表示上の「最終更新: X分前」インジケータを付与する
- **Auto-Refresh**: `document.visibilitychange` イベントでタブ再表示時に自動リフレッシュする

### §328. The Runtime Type Narrowing Protocol

- **Rule 33.322**: Union型のランタイム型絞り込みには Discriminated Union パターンを必須とする
- **Discriminant Field**: `type` / `kind` / `status` 等の判別フィールドで型を絞り込む
- **Exhaustive Check**: `switch` 文の `default` で `never` 型チェック（Exhaustive Check）を実施し、未処理のケースをコンパイル時に検出する

```typescript
// ✅ Discriminated Union による型安全なUI分岐
type ApiResponse =
  | { status: 'loading' }
  | { status: 'success'; data: Product[] }
  | { status: 'error'; error: string };

function ProductList({ response }: { response: ApiResponse }) {
  switch (response.status) {
    case 'loading':
      return <Skeleton />;
    case 'success':
      return <Grid items={response.data} />;
    case 'error':
      return <ErrorMessage message={response.error} />;
    default:
      return response satisfies never; // 未処理ケースをコンパイル時検出
  }
}
```

### §329. The Data Invariant Protocol

- **Rule 33.323**: ビジネスクリティカルなデータの不変条件（Invariant）をフロントエンドでも検証する
- **Examples**: 在庫数 ≥ 0、価格 > 0、開始日 ≤ 終了日、合計金額 = 各明細の合計
- **Implementation**: `invariant()` ユーティリティ関数でランタイムチェックし、違反時は即座にエラーレポート

### §330. The Null Object Pattern Protocol

- **Rule 33.324**: DBレコードの未設定フィールドを `null` でコンポーネントに渡す代わりに、**Null Object パターン**でデフォルト値を持つオブジェクトに変換する
- **Benefit**: コンポーネント層での null チェック分岐を排除し、コードの可読性とテスタビリティを向上
- **DTO Layer**: API → DTO 変換時にNull Objectを生成する

---

## Appendix A: 逆引き索引

| キーワード | 関連セクション |
|:----------|:-------------|
| `'use client'` | §12, §14, §217 |
| `'use server'` | §6, §140, §144 |
| `'use cache'` | §11, §85 |
| `use()` フック | §46 |
| `useOptimistic` | §44 |
| `useFormStatus` | §45 |
| `useActionState` | §45 |
| React Compiler | §47, §294 |
| `<ViewTransition>` | §47, §170, §306 |
| `unstable_cache` | §85, §86 |
| `next/dynamic` | §22, §93, §147 |
| `next/image` | §99, §100, §103, §223 |
| `next/font` | §101 |
| `next/script` | §102, §155, §283 |
| React Hook Form | §54–§66 |
| Zod | §8, §54, §56, §57, §75 |
| shadcn/ui | §19, §20, §21 |
| Tailwind CSS | §25, §27, §210 |
| Server Actions | §57, §84, §140–§146, §154 |
| Hydration | §49–§53 |
| CWV (Core Web Vitals) | §1, §91, §95, §180 |
| SEO | §23, §106–§117 |
| A11y | §118–§124, §191, §267 |
| CSP | §18, §203, §203b |
| State Management | §79–§83 |
| Error Handling | §134–§139, §206b |
| Testing | §156–§163 |
| PWA | §125–§129 |
| i18n | §130–§133 |
| Anti-Patterns | §215–§244 |
| Z-Index | §28, §29 |
| View Transitions | §170, §263, §306 |
| Container Queries | §31 |
| Anchor Positioning | §171 |
| `@property` | §177 |
| `@starting-style` | §178 |
| CSS Grid Masonry | §179 |
| Speculative Rules | §117 |
| Trusted Types | §201 |
| Web Worker | §197–§200, §284 |
| Micro-Frontend | §192–§196 |
| AI UI | §186–§191 |
| RUM | §180–§185 |
| PPR | §11 |
| FinOps | §85, §207–§209 |
| Monorepo | §245–§249 |
| WebSocket / SSE | §250–§253 |
| Authentication | §254–§258 |
| Animation | §259–§264 |
| Responsive | §265–§270 |
| E-Commerce | §271–§276 |
| DevOps | §277–§282 |
| Sustainability | §288–§292 |
| Tailwind CSS 4 | §301 |
| `next/after` | §302 |
| CSS `@layer` | §303 |
| CSS `:has()` | §304 |
| React Activity | §305 |
| `<ViewTransition>` GA | §306 |
| LoAF API | §307 |
| `scheduler.yield()` | §308 |
| Navigation API | §309 |
| `color-mix()` | §310 |
| `proxy.ts` | §311 |
| `'use cache'` GA | §312 |
| Turbopack FS Caching | §313 |
| DevTools MCP | §314 |
| `updateTag()` | §315 |
| Incremental Prefetch | §316 |
| GraphQL | §317–§320 |
| tRPC | §321 |
| OpenAPI Client | §322 |
| Schema Contract | §323, §326 |
| Data Quality | §325–§330 |
| `useEffectEvent` | §48b |
| Discriminated Union | §328 |
| Null Object Pattern | §330 |
| `cacheSignal()` | §305b |
| Performance Tracks | §305c |
| Batching Suspense | §305d |
| Privacy Sandbox | §155b |
| CHIPS / FedCM | §155b |
| OWASP 2026 | §206b |
| Supply Chain Security | §206b |
| CSP Level 3 | §203b |
| Biome | §278 |

## Appendix B: クロスリファレンス

| 参照先ルール | 関連する本ルールセクション |
|:-----------|:----------------------|
| `200_design_ux.md` | §1, §19, §21, §112, §259 |
| `300_engineering_standards.md` | §2, §96, §277 |
| `341_headless_cms.md` | §7 (ハードコーディング禁止) |
| `301_api_integration.md` | §140–§146, §250 |
| `320_supabase_architecture.md` | §89 (DB Query) |
| `400_ai_engineering.md` | §116 (GEO), §187 |
| `401_data_analytics.md` | §153 (Privacy Tracking) |
| `600_security_privacy.md` | §74, §145, §201–§206, §256 |
| `602_oss_compliance.md` | §5, §205, §282 |
| `102_growth_marketing.md` | §116 (GEO戦略), §151–§155 |
| `301_api_integration.md` | §140–§146, §250, §321–§324 |

