# 33. Webフロントエンドエンジニアリング (Web Frontend Engineering)

> [!CAUTION]
> **このファイルは Universal Rule（不変ルール）です。「憲法改正」の明示的指示がない限り編集禁止。**
> 改定日: 2026-03-24 | 対象: Next.js 16+ / React 19.2+ / TypeScript 5.x

> [!IMPORTANT]
> **Primary Directive（主要方針）**
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

### §1. Primary Directive — Webフロントエンド・エクセレンス

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
- **Cross-Reference**: `engineering/000_engineering_standards.md`, `design/000_design_ux.md`

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
    - **Compiler-Adjacent Exact Pin（Rule 33.5 の例外）**: コンパイラ隣接依存（compiler / transpiler / bundler plugin / AST 変換・コード生成器、およびそれらと型契約を共有する `@types/*` 相当）は Caret ではなく exact pin とする（MUST）。minor 更新で出力コードや型契約が変わりうるため SemVer caret に委ねない。`@types/*` への major-only 指定（`^19` 等）は任意の minor を許容する最高リスクであり禁止（MUST NOT）
    - 非隣接の一般ライブラリは Caret 維持でよい（MAY）。全依存の exact 化は自動更新 PR を阻害する過剰締め付けであり、対象は「隣接」判定で絞る。exact pin した依存の更新は別コミットで行い bisect 可能性を保つ（SHOULD）。`package.json` の指定が SSOT で lockfile は補助
- **Renovate/Dependabot**: 依存関係の自動更新PRを有効化し、21日間の安定期間後にマージする
- **The Freshness Obligation**: 外部サービスSDK（AI、Auth、Payment等）は進化が速い。新規実装では常に最新版を使用し、問題発生時は「まずアップデート」を第一解決策とする
- **Cross-Reference**: `security/200_oss_compliance.md`
- **Next.js 16 破壊的変更対応**: Next.js 16へのアップグレード時は Node.js 20.9+ および TypeScript 5+ が必須。AMPサポートは廃止済み。`middleware.ts` は `proxy.ts` に移行（詳細は Part LI 参照）
- **Major Upgrade Rendering Compatibility**: フレームワークのメジャー更新時は、レンダリング内部 API（Portal・同期 flush・NodeView 相当）に依存するライブラリ（リッチテキスト、DnD、仮想スクロール等）の対応版を先に確認する（MUST）。型・ビルド・テストは通るため、実ブラウザ検証を更新の完了条件に含める
    - **診断ヒューリスティック**: 「データも配信もスキーマも正しいのに画面へ出ない」が揃ったら、描画ライブラリとフレームワークのメジャー版非互換を最優先で疑う（MUST）。データ層を層ごとに潰す前に「内部状態（ライブラリのモデル）には存在するが DOM に無い」かを 1 回で確認し、描画の最終段に絞る。症状の分布（特定の描画機構を使うノードだけ出ない等）を非互換の指紋として使う（SHOULD）。失敗パターン: 6 層を無罪確認してから真因に到達した例がある

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
- **The Transitive Env Boundary Protocol**: Client Component から参照されるモジュールは、直接・間接を問わず private env の SSOT モジュールを import してはならない（MUST NOT）。`use client` が直接 `env` を読まなくても、logger / utils / 画像 loader のような共通モジュール経由で到達しうる。クライアントで必要な公開変数は公開 env 専用の SSOT へ分離し、server/client 両方から参照される共通モジュールは秘密値ではなく公開可能な実行環境情報（`NODE_ENV` 等）だけに依存させる（MUST）
    - **検証**: クライアント境界ファイルからの private env import が 0 件であることを検索で確認し、lint と本番ビルドの両方で境界の破綻がないことを確認する（SHOULD）
- **Sink Boundary Pattern**: 横断的に import される同期 API（ロガー等）がサーバー専用依存を抱える場合、呼び出し側の全面書き換えや `server-only` マーカーによるビルド失敗化は解にならない。環境依存の実装（書き出し先 = sink）だけを境界モジュールへ切り出し、`package.json` の `imports` 条件（browser / default 等）で実装を差し替える（SHOULD）。両実装は同一インターフェースを保ち、形状ドリフトをテストで固定する（MUST）
    - **検証**: 「クリーンビルド後の公開チャンクに当該依存が 0 件」（否定側）と「サーバー側には存在する」（肯定側）の対で実証する（MUST）。試して効かなかった条件は「再試行しない」と明記して記録し、次の担当者の時間を守る（SHOULD）
- **Server-Only Applicability & Detection（Rule 33.7 補強）**: secret env 参照・RLS バイパス資格情報のクライアント・バックエンド SDK 初期化・管理者専用テーブル書き込みを含むモジュールは、既存の client import 経路が無くても将来の退行防御として `server-only` 境界を宣言する（MUST）。検出は「`server-only` 宣言が無く secret 系シンボルを含むファイル」の grep。テストランタイムでは alias で no-op 化する

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

- **Rule 33.10a: The Static Access Bridge**: バンドラがビルド時に値を置換する公開環境変数（`NEXT_PUBLIC_*`、`VITE_*` 等）は、置換対象となる静的参照形（`process.env.NAME` / `import.meta.env.NAME`）で取得しなければならない（MUST）。キー名を定数オブジェクト経由で動的参照（`process.env[KEYS.NAME]`）するとバンドラが置換できず本番の client bundle で `undefined` になり、起動時バリデーションが全画面エラーに落ちる（MUST NOT）。ローカル開発サーバーでは再現しない
    - キー名の SSOT 化（定数集約）は許容するが、値取得の境界だけは静的参照を残す「静的アクセスブリッジ」を設け、公開 env の追加・削除時はキー定数・schema・ブリッジ・回帰テストを同時に更新する（MUST）。検証: 公開 env モジュールに `process.env[` が残っていないこと、本番ビルド後のブラウザ実行で起動エラーに落ちないこと
- **Rule 33.10b: No Weak Secret Fallback**: secret 系 env に `?? ''` / `?? null` / `?? '<default>'` の fallback を書いてはならない（MUST NOT）。正本は `security/000_security_privacy.md` の「Missing-Secret Behavior」。

### §9. Site Settings Architecture

- **Runtime Injection**: テーマカラー等の設定はDBからランタイム（RootLayout）で取得し、CSS変数として注入する。ビルド時ではなくランタイムで設定することで、再ビルド不要のデザイン変更を実現

### §10. Next.js 15 Async API プロトコル

- **Rule 33.11**: Next.js 15以降、`params`, `searchParams`, `headers`, `cookies`, `draftMode` は Awaitable（Promise）である
- **Action**: これらを参照する際は必ず `await` または React の `use()` フックを使用する

### §11. Partial Prerendering (PPR)

- **Rule 33.12**: Next.js 15のPartial Prerendering（PPR）を活用し、静的シェルと動的コンテンツの最適な組み合わせを実現する
- **Static Shell**: ページのレイアウト・ナビゲーション・静的コンテンツは即座に配信される静的シェルとしてプリレンダリング
- **Dynamic Streaming**: ユーザー固有コンテンツ（認証状態、パーソナライズ等）は `<Suspense>` 境界内で動的にストリーミング
    - **但し書き（公開面の本文）**: AI 検索から見える必要のある公開面の H1・本文・結果一覧・JSON-LD は `<Suspense>` の子に置かない（§114 参照）。JS を実行しないクローラーには遅延境界の子は骨組みしか見えない
- **Action**: `experimental.ppr: true` を `next.config.ts` で有効化し、ページ単位で `export const experimental_ppr = true` を宣言
- **Next.js 16 Cache Components**: PPRの安定版として `'use cache'` ディレクティブがGA化。動的コンポーネント内でもキャッシュ境界を宣言可能

### §302. The next/after API Protocol

- **Rule 33.295**: Next.js 15+ の `after()` API を活用し、レスポンス送信後の非ブロッキング処理を実装する
- **Use Cases**: ログ記録、アナリティクスイベント送信、キャッシュ無効化等のレスポンスに影響しないサイドエフェクト
- **Advantage**: `waitUntil` と異なり `after()` はServer Actions・Route Handlers・Middleware・`generateMetadata` 内で使用可能
- **Side-Effect Boundary**: 通知・メール・外部連携の副作用は応答後実行またはキューへ逃がし、DB 書き込み・決済など業務ロジックは同期 `await` して失敗を応答で伝える。副作用の失敗を「操作の失敗」としてユーザーに誤認させない（MUST）
- **After-Response Hook Contract**: 「失敗の可視化（ログ + 計数）」と「応答後の完走保証（基盤のフックへ登録）」は別問題であり、片方では不十分。両方を満たす合成ヘルパーを唯一の入口にする（MUST）。正本は `engineering/000_engineering_standards.md` の「After-Response Hook Contract」。
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
- **Plain JSON at the Boundary**: エディタ・ライブラリが生成する null-prototype オブジェクト（`Object.create(null)` 由来）・クラスインスタンス・Map/Set を Server Action・RPC・`postMessage`・Worker 等のフレームワーク境界へ渡す層は、境界の直前で純 JSON 化（`JSON.parse(JSON.stringify(x))` 相当）を通す（MUST）。シリアライザはこれらを「プレーンでない」と判定して送信バイト上で無言で置換・欠落させ、型検査・schema 検証（`unknown`）・単体テストのどれにも現れない。`structuredClone` はプロトタイプを保持するため代替にならない（MUST NOT）
    - 純 JSON 化の配線（データ生成元の出口で通っていること）を単体テストで固定する（MUST）。切り分け: 「無編集の保存は成功／編集すると全滅」型の事象は直列化境界を疑い、`fetch` をフックして送信バイトを直接見る（SHOULD）。置換記号（`"$T"` 等）が見えればこの機序

### §13. The Async-UI Boundary Protocol

- **Rule 33.14**: UI コンポーネント（特にClient Components）から、データフェッチを行うAsync Server Componentsを直接インポートすることは禁止
- **Action**: データロジックを持つコンポーネントは `layout.tsx` や `page.tsx`（Server Context）のトップレベルでレンダリングし、`children` パターンでUIと物理的に分離する

### §14. The Component-DTO Interface Protocol

- **Rule 33.15**: UIコンポーネントのProps定義にデータベースの生の型（`Row`）を使用することは禁止。**DTO Interface**に依存し、実装詳細を隠蔽する
- **Two-Key Lock（Rule 33.15 補強）**: 「管理者しか見ない」経路も含め例外なく DTO マッパーを通す（MUST）。SELECT 列 allowlist と DTO 出力 allowlist の両方を opt-in しなければ新列が外へ出ない構造を維持し、schema drift で追加された PII 列が自動的に漏れる経路を断つ。公開境界の serializer は allowlist pick で新オブジェクトを構築し、`{...rest}` + `delete` + `as DTO` の denylist 方式は列挙し忘れた新フィールドが既定で公開されるため禁止（MUST NOT）
    - Server → Client 境界に渡すオブジェクトは、型が公開型でも実行時に存在する全列が RSC ペイロードへシリアライズされブラウザへ届く（client 側が使わなくても漏れる）。機微列を持つ admin DTO は境界の前に公開射影へ変換し、`JSON.stringify(projection)` に機微値が現れないことをテストで固定する（MUST）。PII 列は client 行きの SELECT spec から物理的に除外し server-only spec と分ける。RLS で本人だけ読める ≠ client HTML に出してよい

### §15. Production Build 検証プロトコル

- **Rule 33.16**: **`npm run build` が Exit 0 で通過するまで、そのコードは「存在しない」**
- **SSG Awareness**: `cookies()` 等のdynamic APIを SSG ページでインポートすると本番ビルドでエラーとなる。動的依存を分離せよ
    - **共通レイヤの波及**: ルート layout や i18n のリクエスト設定で `headers()` / `cookies()` を無条件に呼ぶと、個々のページの `force-dynamic` を全て外しても静的プリレンダは 1 本も復活しない。個別最適化の前に全体を一律に制約している要因を先に確認し、「動的レンダリング宣言 N 件」と「動的レンダリング面 N 件」を混同しない（MUST）。実測はビルド成果物（`.next/server/app` の `.html` 件数と `prerender-manifest.json`）で行い、コードの宣言数を根拠にしない
- **Tiered Database Client Protocol**: SSG/ISR互換のDBクライアントは、dynamic API依存と非依存で**物理的に別ファイル**に分離する
- **Build Green ≠ Behavior Correct**: CSS・レイアウト・レスポンシブ分岐の変更はコンパイル成功では正当性を示せない。配信 CSS の実見・算出スタイルの実効値・幅条件の一致をブラウザで実測してから完了とする（MUST）。ビルドが生成物として型制約を作る構成（ルート／アクションファイルの export 制約等）ではビルドを一度通すまで検査自体が存在しないため、完了前に本番ビルドを挟んだ後の型検査を通す（MUST）。開発サーバーでのみ再現する失敗は (a) ランタイム直接呼び出しで到達性確認 (b) 本番ビルドで再現確認 (c) 再現しなければ dev-only として記録、の 3 段で切り分ける。正本は `quality/000_qa_testing.md` の「Build Green ≠ Behavior Correct」。

---

## Part V: Edge Computing & Middleware ⚛️

### §16. Edge Middleware 設計

- **Rule 33.17**: 認証チェックやジオロケーションリダイレクトは**Edge Middleware**で実行し、レイテンシを最小化する
- **Rule 33.18**: `middleware.ts` は軽量に保ち、静的資産を処理対象から除外する。Middleware内での重いDBクエリや外部API呼び出しは禁止
- **Rule 33.18a（Framework-Recognized Filename Mandate）**: フレームワークが規約で認識する中核ファイル（ミドルウェア／プロキシ／エラー境界／設定）は、そのバージョンの公式規約どおりの名前・エクスポート名で配置する（MUST）。独自名（`guards.ts` 等）で置くとフレームワークに認識されず、CSP・CORS・レート制限等の全体防御が一度も実行されない「静かな防御喪失」に陥る。ビルドもテストも通るため「機能していると思い込む」。規約名はバージョンで変わる（例: `middleware.ts` → `proxy.ts`、§311 参照）ため、アップグレード時は旧名が「認識されない独自名」に転落していないか確認する。全体防御は「ファイルが存在する」ではなく実配信でレスポンスヘッダー／429 等が出ていることで確認する（SHOULD）
- **Rule 33.18b（ASCII-Only Header Values）**: ミドルウェア／サーバーで設定する HTTP ヘッダー値（CSP の長い文字列のコメント部を含む）は ASCII セーフな文字のみで記述する（MUST）。非 ASCII（全角文字等）は HTTP のバイト列制約に反し、実行時 500 となりビルドでは検出されない
- **Rule 33.18c（Trusted Header Strip）**: ミドルウェアが下流へ「信頼済み」として渡すヘッダー（認証主体 ID・tier・auth source 等）は、入口で全パスにおいてクライアント供給値を無条件に削除し、認証成功時のみ検証済み値を再設定する（MUST）。ミドルウェアが set しないコードパス（bearer / API key の一部経路の fall through）でクライアントの偽装値がそのまま下流に届き、権限昇格になる。ヘッダー伝搬 API の契約（response header への set は下流の `request.headers.get` に届かない）を確認し、意図と実装の乖離をテストで固定する（MUST）。「middleware が x-user-id を set する」というコメントは事実の証明にならない。下流ハンドラは信頼ヘッダーを層 1 とし、DB で再検証する層 2 を持つ（SHOULD）。検出: ミドルウェアが set するヘッダー名と下流が読むヘッダー名を cross check する。正本は `security/000_security_privacy.md` の「Trusted Header Strip」。
- **Rule 33.18d（Rewrite-Before-Authorization Ordering）**: リクエストパスに対する分岐（認可・除外・rewrite）は、rewrite・正規化・prefix 除去のどれが先に効くかを明示してから書く（MUST）。rewrite 方式 i18n で認可判定を rewrite 前のパスで行うと `'/en/owner/x'.startsWith('/owner')` が false になりロケール接頭辞側だけ穴が空く。i18n / SEO rewrite の対象はページリクエストに限定し、API・フレームワーク内部・静的 asset・metadata は prefix 有無に関わらず除外し、認可境界を通らない経路で API パスを後から生成しない（MUST）。パス境界判定は `path === root || path.startsWith(root + '/')` の境界一致で行い、素の `startsWith(root)` は `/owner-guide` のような別ルートを巻き込むため禁止（MUST NOT）。契約テストには prefix 付きパスと類似名の別ルートを必ず含める

### §17. The Non-Blocking Edge Processing Protocol

- **Rule 33.19**: Edge MiddlewareおよびAPI Routesにおいて、メインレスポンスに無関係なブロッキングDB書き込みを `await` で待機させることは禁止
- **Signed Internal Context**: 内部 rewrite がミドルウェアを再入させる構成では、実ランタイムで実行回数と 2 回目に届くヘッダーを観測する（MUST）。1 回目が付与したヘッダーの存在だけを「内部リクエスト」の証拠にすると外部クライアントが偽造できる。内部コンテキストはサーバー secret で HMAC 署名し、検証成功・path 一致・locale 一致の全条件で復元、それ以外は fail closed（MUST）。表示言語は認証・認可・課金判定に流用しない（MUST NOT）。回帰試験は正規署名・偽造・リプレイ・直接アクセスを含む
- **waitUntil**: サイドエフェクトは `event.waitUntil()` でバックグラウンド化
- **Error Isolation**: バックグラウンド処理のエラーは try-catch で隔離

### §18. CSP Worker Integrity

- **Rule 33.20**: `heic2any` 等のライブラリは内部で `Web Worker` を生成し `blob:` URL を使用する。Middleware の CSP 設定に `worker-src 'self' blob:;` を明示的に含める

---

## Part VI: UIコンポーネント設計 🔀

### §19. shadcn/ui + Design Token

- **Rule 33.21**: **shadcn/ui** を標準UIコンポーネントライブラリとして採用し、カスタマイズ性とアクセシビリティを両立する
- **Design Token**: Tailwind Config の `extend` でプロジェクト固有のカラー・フォント・シャドウをトークンとして定義する。HEX値直書きは禁止
    - **正当な例外と検出手順**: hex を保持してよいのは第三者ブランドガイドで色が固定されたもの（外部サービスのロゴ SVG 等）、チャートのデータ系列色、CSS 変数が解決されないメール HTML の inline style に限り（MAY）、理由をコードコメントで明示する。監査は「hex パターンの全件検索 → 既知の正当な置き場（トークン定義・テーマ管理画面・サニタイズ許可リスト等）を除外 → 残りを全件レビュー」で行い、検出ゼロまたは例外注記済みを完了条件にする（MUST）。「全部禁止」のままでは第三者ロゴやメールが違反扱いになり監査が形骸化する
- **Class Sorting**: `prettier-plugin-tailwindcss` の使用を必須とする

### §20. Interactive Components Standard

- **Rich Selection Protocol**: 従来のRadio/Checkboxは原則禁止。**「直感的にクリック可能なリッチカード型UI」**を標準とする
- **Responsive Combobox Protocol**: Desktop: `Popover` / Mobile: **Drawer (Vaul)**
- **Stable IDs**: `CommandItem` の `value` は一意で整合性のある**ASCIIの文字列**であること。非ASCII文字（CJK文字等）を `value` に使うと選択ロジックが壊れる

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
- **Shared ClassName Extraction**: 同一コンポーネント群で 3 箇所以上に完全一致する長いユーティリティクラス文字列が現れたら、共有定数モジュールへ抽出する（MUST）。命名は「対象 + 役割 + 種別接尾辞」（例: `EMBED_CODE_TEXTAREA_CLASSNAME`）、配置はドメインフォルダ直下の private モジュール（先頭アンダースコア等）とし、監査時は 3+ 重複をスクリプトで全件検出する（SHOULD）
- **The Utility Class Definition Check**: プロジェクト固有のユーティリティクラス・接頭辞付きクラスを使うときは定義を実際に開く（MUST）。クラス名は「意図の表明」であって「実装」ではなく、使用箇所の多さは定義がある証拠にならない（使う側は既存例を真似るだけなので、定義が無いまま使用箇所だけが増える方が自然）。`@apply` / `@utility` を経由せずクラス名だけ書いてもビルドもリントもエラーを出さない無音性を前提に、CSS 側に宣言があることを検査で固定する（SHOULD）。失敗パターン: 「対策済み」として使い回されたクラスに定義が無く、スクロールバーが出たままだった

### §26. The CSS Specificity Protocol

- **Rule 33.28**: `!important` によるスタイル上書きは**完全禁止**。根本原因を解決するか、React状態管理で制御する
- **Presence Gate**: `!important` の可否は「理由」を聞く前に「存在するか」で判定する。1 件でも検出されたら原則 `NEEDS_FIX` とし安易な上書きとして扱う（MUST）。反映されないスタイルはセレクタ設計・コンポーネント責務・DOM 階層・トークン・variant・状態属性・条件付きレンダリングで解決し、`!important` を足して通す修正は禁止
    - **例外と検証**: 例外は外部埋め込み・印刷・サードパーティ iframe 等、設計上回避不能な場合のみ。範囲を対象クラスに閉じ、代替不能理由・削除予定条件・検証コマンドをコメントか証跡に残し、人間レビューを必須とする（MUST）。UI/CSS 変更を含むタスクでは対象拡張子を横断した検索（例: `rg -n "!important" src --glob "*.tsx" --glob "*.css"`）で検出ゼロを完了条件に含める（MUST）。「禁止」だけでは例外議論で押し切られる

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
- **The Sticky Travel Protocol**: `position: sticky` が追従しないときは「親の高さ」と「子の高さ合計」を実測する（MUST）。差がそのまま追従距離であり、親が中身の分しか高さを持たないと最後の子は既に下端にいて可動域がゼロになる。grid / flex の item が自分の書いた要素とは限らない（stretch して高さを持つのはラップ要素で、中の `aside` は `height:auto` だった例）。追従距離は本文の長さに依存するため長短両方のページで確認し（SHOULD）、追従中に覆われていないかを枠内の複数点で `elementFromPoint` で確認する。`z-index` 無しは DOM 順のまま後続の `z-10` に負ける

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
- **Container Element Pattern（レイヤへ入れられない場合）**: unlayered なサードパーティ CSS は同じ詳細度なら `@layer utilities` の utility に無条件で勝つ。utility で上書きしたいなら相手をレイヤへ入れ、それができない（各コンポーネントが直接 import している等）なら utility は `display` 等の規則を持たない素の器要素に付ける（MUST）
- **Computed-Value Verification（CSS を書いた ≠ 動いている）**: CSS の遷移・utility クラス・レイヤ指定を追加した変更は「ソースに書いた」「HTML にクラスが出ている」では完了にならない（MUST NOT）。実 DOM の `getComputedStyle()` と `getBoundingClientRect()`、遷移なら時系列の中間値サンプリングをもって完了とする（MUST）。前提機能（`interpolate-size` のような有効化キーワード）が欠けると CSS は無言で止まり、エラーも警告も出ない。失敗パターン: 本番 DOM の computed が `pan-y` のままで「是正済み」に見えていた変更が、4 日後に同じ穴へ再度落ちた。是正の判定を是正前と同じ観測手段（クラスの有無）で行ってはならない。正本は `quality/000_qa_testing.md` の「CSS 効力の実測」。
- **Derived Custom Properties over Instance CSS**: 同じ部品の複数インスタンスに共通する欠陥を、インスタンス名指しの CSS で直してはならない（MUST NOT）。インスタンスが増えるたびに書き足す設計は書き忘れを検出できない（例: 10 本中 4 本に是正漏れ）。各インスタンスが部品へ渡す設定値と同じ値からカスタムプロパティを出し、グローバル CSS は汎用ルール 1 組だけを持つ（MUST）。網羅は部品を使う全ファイルを走査し、インスタンス数と宣言数の一致を補集合で固定する検査で担保する
- **Margin Collapse Across Fragments**: 本文を複数の片に分割して並べる構造（本文とウィジェットの交互配置）では、片のコンテナが `overflow: hidden` で BFC になると片をまたぐ margin が相殺されず足し算になる。横のはみ出しだけを切りたい場合は `overflow-x: clip` を使い BFC を作らない（SHOULD）。見出しの margin-top はブロックの margin-bottom より必ず広く設計して「前の要素が何であれ見出し自身の margin-top だけ」になるようにし、SSR と hydrate 後で外枠の余白を同値にする（MUST）

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
- **The Self-Referencing Route Scan**: 画面の設置先（URL）を移す変更はページ側の diff だけでは完結しない。当該コンポーネントとその依存内で旧 URL・ルート定数を grep し、「完了後に戻る」「ここで変更できます」系の自己参照導線（OAuth 等の redirect 先・キャッシュ再検証パス・リンク・パンくず・通知メール内リンク・ドキュメント）を全て新設置先へ更新する（MUST）。正本は `engineering/000_engineering_standards.md` の「The Self-Referencing Route Scan」。
- **Route Constant ↔ Reality Triangulation**: ルート定数を追加・利用するときは、対応する実ページ／redirect の存在と認証・所有者チェックを同時に確認する（MUST）。定数上は SSOT に見えても実体が無ければ導線は壊れる。404 調査は「リンク呼び出し・定数・実体」の 3 点を同時照合する

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
- **Timer Dependency Rate Rule**: 周期タイマー（interval / debounce / timeout）を持つ副作用の依存は「実行中か」を表す boolean だけにし、進捗そのものを依存にしない（MUST）。依存を書くとき「これは周期より速く変わりうるか」を問う。速く変わる依存 + cleanup を持つ副作用は、発火前に毎回 cleanup → 再作成され一度も tick しない。回線とマシンが速い環境ほど確実に再現し、遅い環境では偶然 tick が間に合って正しく見える
    - 「推定できないときは数字を出さない」設計は、裏返すと「出ないこと」が異常のサインにならず、もっともらしい待機表示で止まる故障は正常系と見分けがつかない。実測値が動いているかを別途確認し（SHOULD）、テストでは「周期より速い更新」を意図的に注入する（SHOULD）

### §41. The Explicit Initial State Typing Mandate

- **Rule 33.43**: `useState` に `[]` や `null` を渡す場合、ジェネリック型パラメータの明示指定を必須とする
- `useState([])` 禁止 → `useState<Item[]>([])`
- `useState(null)` 禁止 → `useState<User | null>(null)`

### §42. The Compiler Readiness Protocol

- **Rule 33.44**: React Compiler互換のコーディングパターンを推奨する。`useMemo` / `useCallback` の過度な手動使用を避け、コンポーネントは純粋関数として実装する
- **Structural Compliance Checklist**: コンパイラ／並行レンダリングの警告は lint noise ではなく、将来のフレームワーク更新でビルド不能化する構造的実装臭として扱い、ビルド時の compiler 警告を 0 に維持する（MUST）
    - render 中に ref を書き換えない（MUST NOT）。ref 更新はイベントハンドラまたは effect へ移す
    - hydration／クライアント判定は `useSyncExternalStore` ベースの共通 hook へ集約し、`mounted` state を各所で乱立させない（SHOULD）
    - props → state の同期 effect は必要性を再評価し、残す場合も初回 paint 中の同期更新を避けユーザー操作由来の更新と区別する（SHOULD）
    - フォームライブラリの値監視は render ごとに購読を再生成する直呼び（`watch()`）ではなく購読 hook（`useWatch()`）を使う（SHOULD）
- **The Effect Order & Remount Protocol**: effect は子コンポーネント → 親コンポーネントの順で実行される。親の `useEffect` で、子のコールバック（`onReady` / `onInstance` 等）が設定した state を `null` に戻すパターンは禁止する（MUST）— 子の設定が親に上書きされる。サードパーティウィジェット（スライダー・エディタ・地図等）の設定変更で再初期化が必要な場合は、`key` に全設定属性を含めてコンポーネント全体を再マウントさせる（SHOULD、§52 参照）。一部の属性しか含めないと設定変更が伝播しない。破棄済みインスタンスへの参照は `instance && !instance.destroyed` のようにガードする

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
- **Optimistic Update Integrity**: 更新 API の戻り値でローカル状態を上書きする際、戻り値は一覧取得時の DTO と同じ形とは限らない（JOIN・集計由来の項目が欠ける）。欠落しうる項目は既存値を引き継ぐか、更新 API を一覧と同じ射影で返す設計にし、無条件上書きは禁止（MUST NOT）。作成・削除・移動後は直接対象だけでなく派生データ（件数・集計・親エンティティのサマリ）も再取得または再計算する（MUST）。片方だけの更新は「保存したのに数字が変わらない」不具合として利用者に届く

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
- **Deployment Criteria**: 全ページで必ず接続する第三者オリジンと LCP 要素の配信元には、ルートレイアウトの `<head>` で `dns-prefetch` と `preconnect`（CORS 資源は `crossorigin`）を併記する（SHOULD）。前者は非対応環境の fallback、後者は完全ハンドシェイク。同時 preconnect 数にはブラウザ上限（例: 6）があり超過分は無視されるため、遅延読込される広告／解析オリジンには付けず（MUST NOT）、一部ページのみのオリジンは該当ページで宣言する

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

- **Rule 33.51**: SSRとクライアントレンダリングの出力不一致（Hydration Mismatch）の発生リスクを最小化する
- **Root Cause**: SSR中に `Date.now()`, `Math.random()`, ブラウザ固有グローバル (`window.innerWidth` 等) を使用すると不一致が発生する
- **Suppress**: `suppressHydrationWarning` は**日時表示にのみ**許可。それ以外での使用は禁止
- **Allowed vs Prohibited Suppression（補足）**: 抑制属性を許可するのは「自コードで一致させられない差異」— ブラウザ拡張による `<html>` / `<body>` / 共通ナビへの属性注入、サーバー・クライアントの時刻差、乱数・一意 ID — に限る（MAY）。自コードのバグ・データフェッチの不一致・状態管理の問題を隠す目的での使用は禁止（MUST NOT）。付与時はコメントで外部要因を明記し、全ページ共通で拡張機能の標的になりやすいナビゲーション要素には予防的に付与してよいが、ページ内コンテンツのリンクには不要（SHOULD）
- **Dimension Class Parity**: サーバー側の静的レンダラとクライアント側コンポーネントが同じ要素を描く場合、寸法・アスペクト比・余白を決めるクラス／スタイルは同一のトークン／クラス定義を共有し、片方だけ inline style や別ブレークポイント値にしてはならない（MUST）。SSR が単一値（`style="aspect-ratio:3/4"`）、CSR がレスポンシブ値（`aspect-[3/4] md:aspect-[3/2]`）という非対称は hydration で寸法が変わり CLS を生む。両者を同一の定数から生成するか、自動テストで一致を検査する（SHOULD）
- **Hybrid Swap Layout Parity**: サーバー描画 HTML をクライアントで対話的レンダラへ差し替える構成では、両フェーズの wrapper が同じレイアウト規則（class 体系・余白・タイポグラフィ）を持つことを要件にする（MUST）。読み取り専用なら差し替え自体を無くし、対話機能が必要なら差し替えを維持して規則を統一する。「差し替えを全廃する」は対話機能を失う過剰修正であり、誤用の修正を先に検討する（SHOULD）
- **Conditional Render Ban**: 読み込み中と完了後で同じコンポーネントを異なる props で条件分岐描画（`isLoading ? <X /> : <X extra />`）してはならない（MUST NOT）。描画は統一し未取得データは既定値（空配列等）で渡す。スケルトンが必要なら wrapper（グリッド等）を共通化し子だけを差し替え、完成後と同じ DOM 構造・寸法・アスペクト比で作る（SHOULD）
- **Dual-Renderer Content Bake**: 同一コンテンツを SSR 用静的レンダラとクライアント用動的レンダラの二系統で描く場合、外部メタ（alt / caption 等）を片方の描画関数にだけ注入してはならない（MUST NOT）。正本は `engineering/310_headless_cms.md` の「Dual-Renderer Content Bake」。
- **The Pre-Init Appearance Protocol**: 「既定で効かせて、active / initialized クラスで戻す」CSS 設計は、JS 初期化前（SSR 直後〜数百 ms）に「戻される前」の見た目を必ず持つ。演出 CSS は初期化済みを表すクラス（`.initialized .slide` 等）にだけ掛け、初期化の瞬間に active も同時に付く構造にする（MUST）。初期状態の見た目は JS を無効にして撮る（MUST）— 1 枚で分かる。隣が見えないレイアウトでの縮小など効果が無い装飾は黒地や区切りだけを生むため、レイアウト条件を実測して不要な演出を撤去する（SHOULD）

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
- **Step Form Thresholds**: 入力項目数でフォーム形式を選ぶ（SHOULD。閾値は例であり Blueprint で定める）: 例として 1〜5 項目は単一ページ、6〜10 項目は 2 ステップ、11 項目以上は 3 ステップ以上 + プログレスバー。3 ステップ以上ではステップ名を表示し、完了済みステップはチェック表示かつクリックで戻れるようにする（MUST）。ステップ間のデータはセッションストレージ等で保持し、リロード・戻る操作で入力が消えないようにする（MUST）
- **The Cross-Layer Constraint Parity**: 同一入力に対する複数層（client／server／公開 API）のバリデーションスキーマは、文字数上限・数値範囲などの制約値を単一の定数から参照し、エラーメッセージもその定数から生成する（MUST）。層ごとの独立進化は「client OK → server reject」の UX 事故と「API 直叩きで最も緩い層が実効制約になる」防御崩壊を生む。統一時の既定値は最も厳しい値にし（SHOULD）、必須／任意の差が正当な場合は理由をスキーマコメントに明記する。制約を厳しくする変更では既存行が新上限を超えないか確認し、UI の `maxLength` も同期する（MUST）。検出: 同一エンティティのスキーマ定義が複数ある file を列挙する
- **Controlled Select Allow-Set Guard**: 列挙値を選ぶ controlled な Select 系コンポーネントは、ライブラリ内部の native `<select>` 併設や再マウント（配列フィールドの `update()` による key 再生成等）で `onChange('')` を発火しうる。`onValueChange` は許可集合に含まれる値だけを form state へ書き、表示側も許可集合外は既定値へ倒す（MUST）。判定は JSX の中ではなく純関数へ出してテストする
    - スキーマ側は `''` だけを「未設定」として既定値へ倒し、それ以外の不正値は従来どおり拒否する二重化を行う（SHOULD）— 下書きや旧 state の `''` で保存不能にならないため。保存前検証のエラー文言は項目名まで出し、表示名辞書とスキーマの全キーはテストで突合する。アプリの二重ガードが守れない別経路（API 直叩き・移行スクリプト・手作業 SQL）の書き込みは日次の整合性検査で許可集合外（`''` / null / 旧値）を warn として拾い、検査自体の失敗は critical で可視化する（`engineering/710_data_reconciliation.md` 参照）
- **Contact Identity Validation**: 連絡先（メール・電話）の形式検査は、ブラウザ組込みの `type="email"`（`a@b` を通す）/ `type="tel"`（無検査）に頼らず、サーバー側の純関数（構文・予約ドメイン・捨てアド・長さ上限）を正本とし、クライアントは同じ関数を遅延ロードして blur で先に表示する（MUST）。正本は `operations/300_customer_experience.md` の「Contact Identity Validation」。

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
- **Rule 33.65a（Structure by Container, not Delimiter）**: 区切り記号（改行・カンマ・行頭マーカー等）で構造を表す入力方式は、「内容にその記号が絶対現れない」と言い切れるときにしか使ってはならない（MUST NOT）。自由入力テキストではまず保証できず、項目内改行と項目区切りが同じ `\n` になれば入力欄を 1 文字触るだけで項目が増殖し、「1 行 = 1 項目」というラベルのせいで編集者は気づけない。構造は入れ物で表す（MUST）: 1 つの箱 = 1 つの項目にすれば区切りという概念自体が不要になる。エスケープ規則を足す案は「素人でも更新できる」目的から遠ざかる — 規約で守るものは破られる、形で守れるなら形で守る。往復（表示 → 編集 → 保存）を持つ変換は実データで往復させて不変を確かめる（MUST）。合成データでは「改行を含む項目」のような現実の形が出てこない

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

- **Rule 33.70**: ユーザー入力の全角英数字はサーバー送信前に半角（NFKC正規化）に変換する。CJK文字（例: 日本語のひらがな・カタカナ・漢字）はNFKC変換の対象外とする

### §69. The IME Composition Guard

- **Rule 33.71**: IME入力確定前（変換中）のEnterキーでフォーム送信が発火することを防止する。`compositionstart` / `compositionend` イベントでガードする

### §70. The iOS Input Zoom Defense

- **Rule 33.72**: iOSでは `font-size` が**16px**未満の `<input>` にフォーカスすると自動ズームが発生する。モバイル入力フィールドは最低**16px**のフォントサイズを保証する

### §71. The External Link Protocol

- **Rule 33.73**: 外部サイトリンクには必ず `target="_blank"` と `rel="noopener noreferrer"` を付与する
- **No Exception for Hand-Written JSX & Scheme Allowlist**: sanitizer を通らない JSX 直書きの `target="_blank"` も例外なく `rel="noopener noreferrer"` を付ける（MUST）。`next/link` は eslint `jsx-no-target-blank` の対象外なので独自走査で補う。URL を `href` に描画する箇所は全てスキーム許可リスト（http / https / 内部相対パス）を通す（MUST）— HTML エスケープはスキーム XSS（`javascript:`）を防がず、`z.string().url()` 等の URL バリデータは `javascript:` / `data:text/html` を有効な URL として受理するため許可リストではない。入力境界と描画境界の両方で塞ぐ（DB 格納済みの不正値は入力側修正では無害化できない）。詳細は `security/000_security_privacy.md` §22.1

---

## Part XV: バリデーション & フロントエンドセキュリティ 🌐

### §72. The Anti-Spam Shield

- **Rule 33.74**: 公開フォーム（問い合わせ、サインアップ等）にはCloudflare TurnstileまたはreCAPTCHA v3を実装する。Honeypotフィールドとの併用を推奨

### §73. The Frictionless Security UI Protocol

- **Rule 33.75**: セキュリティ対策がユーザー体験を阻害してはならない。Turnstileはinvisibleモードで使用し、ユーザーフローを維持する
- **Rule 33.75b（No Bot Challenge on Admin-Only Mutations）**: 認証済み管理者だけが叩く状態変更に、公開フォーム向けの bot チャレンジ（CAPTCHA / Turnstile）を付けない（SHOULD NOT）。統制は管理者ガード・レート制限・監査ログ・許可集合検証で行う。トークンが得られない配置（非表示の器）になると保存ボタンが恒久 disabled になり、「兄弟の更新は成功しステータス更新だけ成功記録ゼロ」という静かな機能不全になる。「本番の監査ログで当該操作だけ成功記録がゼロ」は機能不全の発見手段として使う
- **Rule 33.75c（Hidden-Ancestor Static Check）**: bot チャレンジを描画するコンポーネントが `display:none` / `hidden` 属性 / 素の `hidden` クラスの祖先を持たないことを、描画確認に加えて AST で検査する（SHOULD。ブレークポイント付き `md:hidden` は許す）。陽性／陰性のテストを固定する。invisible reCAPTCHA でも同じ

### §74. The Conditional Security Bypass Ban

- **Rule 33.76**: `isAdmin` や `isDev` フラグに基づき認証チェックをスキップするコードは禁止。ベースラインの認証・認可チェックは全パスで例外なく実行される
- **Fail-Closed Secret Comparison**: 環境変数・設定値に格納した秘密との照合で守るエンドポイント（cron、webhook、内部 API）は、秘密が未設定・空のときに拒否する条件式（`if (!secret || token !== secret)`）にする（MUST）。`if (secret && token !== secret)` の形は未設定環境で無認証公開になる。共通の検証関数に集約し、各ルートでの条件式の手書きを禁止する（SHOULD）。レート制限のキーには必ず呼び出し元の識別子（IP・ユーザー ID・API キー）を含める（MUST）— 固定文字列キーは 1 利用者が全体の上限を消費し全利用者を巻き込む（`security/000_security_privacy.md` §10.6 参照）

### §75. The Deep Type Recursion Break Protocol

- **Rule 33.77**: ZodやTypeScriptで再帰型を定義する際、`z.lazy()` や bounded generics で深度制限を設定する。無限再帰によるコンパイルハングを防止

### §76. The Strict DTO Boundary Protocol

- **Rule 33.78**: 外部データ（API Response、URL Params等）は `unknown` 型で受け取り、Zodスキーマでバリデーション後にキャストする。`as` 型アサーションは禁止

### §77. The URL State Management Protocol

- **Rule 33.79**: フィルタリング、ソート、ページネーションのUI状態はURL SearchParamsで管理する。`nuqs` ライブラリを推奨
- **Benefit**: ブックマーク共有、ブラウザ履歴、SSR互換性
- **List Search Contract**: 一覧の絞り込み・並び替え・ページ送りの状態は URL に持ち、JS 無しでも動く GET フォームとリンクで操作できるようにする（MUST）。URL パラメータは許可集合へ丸める（MUST）: 面外の種別・未知のソート・不正なページ番号は既定値へ落としエラーにしない。絞り込み結果 0 件は 200 で返し（404 にしない）、「条件ありの 0 件（見つからない）」と「条件なしの 0 件（準備中）」でコピーを分け「条件をクリア」を出す（MUST）
    - canonical は条件なしの基底 URL に固定し、絞り込みリンクは `rel="nofollow"` にして条件の順列を個別 URL として索引させない（SHOULD）。外部集計（人気順等）に依存する並び替えは選ばれたときだけ呼び、失敗時は既定の並び（新着順）へ退避し、全順序のため最終キーに id を含める（MUST）。ページ送りが条件を引き継ぐことを契約テストで固定する（SHOULD）
- **Receiver-Owned Query Contract**: 画面遷移の URL query は「リンク元」ではなく「受信画面の契約」である。受信画面側の builder 関数と key 定数で組み立て、リンク元ごとに手書きしない（SHOULD）

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
- **Adoption Criterion**: WebSocket／Realtime 購読の採用は、データの更新周期と「気づくまでの許容遅延」を比較し、即時性の価値が常時接続のコスト（接続数・fan-out・再接続嵐・課金）に見合う場合に限る（SHOULD）。更新がバッチ／cron 周期（例: 数分単位）なら、サーバー描画の写し + 鮮度条件付き再取得を既定にする。採用条件（例: 個人宛イベントが入り数秒で気づく必要が出た時点）を先に文書化し、条件到達で切り替える
- **Conditional Refresh Without Layout Shift**: サーバー描画で受け取った写しがある場合、開くたびに無条件で再取得しない（MUST NOT）。正本は `design/000_design_ux.md` の「Refresh Indicator Without Layout Shift」。

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
- **Rule 33.94a（Artifact-Based Toolchain Decision）**: ビルダー／バンドラ／コンパイラの切替はビルド時間・メモリだけで判定してはならない（MUST NOT）。「配信される成果物の総量」と「落ちるはずのコード（デバッグログ・開発専用分岐）が実際に落ちているか」を成果物で実測する。プラグインが特定ビルダー専用オプションを持つなら、それが pin の理由である可能性を最初に疑う
    - 比較計測は同一コミット・各 2 回以上取る（MUST）— 1 回ではばらつきと区別できない。集合比較（ルート数・チャンク数）には肯定側の対照を置く（MUST）: 「N 件抽出できている」を先に確認してから 0 差分を結論する。抽出が両側 0 件なら「0 対 0 で一致」という偽合格になる。遅延読み込み等の効果はマニフェストを解析して「初期チャンク集合から消えたこと」で測る（SHOULD）。ツールチェーンの pin（`--webpack` 等）は理由を記録する（MUST）— 理由不明の pin はセキュリティパッチ適用時に外せない負債になる

### §93. The Dynamic Library Decoupling Protocol

- **Rule 33.95**: 30KB（Gzip）超過のライブラリのメインバンドル同梱は禁止。`next/dynamic` でlazy load
- **Lazy Boundary Placement**: 「利用者操作で初めて可視になる」UI（ダイアログ・ドロワー・エディタ）の重い中身は遅延読込する（MUST）。ただし遅延境界を各呼び出し側に置くと、呼び出し側が 1 つでも eager なら分離効果が消え、トリガーを内包する設計では読み込み中トリガーが消える。境界はコンポーネント内部に置き、トリガーは静的に描画、重い子は初回オープンまでマウントしない（SHOULD）— 1 修正で全呼び出し側が受益する。初回オープン後はマウントを維持し再オープンを即時化してよい（MAY）。判定基準: 「必ず描画される」ものは対象外、「操作起点で初めて可視」は全て候補
- **Server-Side Heavy Import**: サーバー側でも、重い解析ライブラリ（HTML パーサ・画像処理・圧縮）を関数トップレベルで静的 import すると、それを使わないリクエストのコールドスタートまで負担する。関数内の動的 `await import()` にし、バンドル分析で基準値を持つ（SHOULD）

### §94. The LCP & Lazy Loading Performance Protocol

- **Rule 33.96**: Above-the-Fold コンテンツ最適化:
    - ヒーロー画像: `priority` 属性を適用。Lazy Load しない
    - Below-the-Fold 画像: `loading="lazy"` 必須
    - `<Suspense>` + Server Component: ストリーミングで重いコンテンツを段階的表示
- **Hidden-but-Rendered Ban**: CSS の非表示（`display:none` 等）はサーバー描画・hydration・DOM 生成・画像要素数を省略しない。同じデータの一覧を画面幅別に二重描画して片方を隠す構成を避け、単一 DOM をレスポンシブ CSS（モバイルは `overflow-x: auto` + scroll snap、デスクトップは grid）で切り替える（SHOULD）。画面幅で意味やデータが本当に異なる場合のみ別ツリーを許可し、非アクティブ側は遅延読込またはサーバー側分岐にする
- **Hidden Subtree Lazy Images**: 初期表示領域に入る要素を初期化前の一時的な CSS で隠す場合、その配下の `loading="lazy"` 画像は交差判定が走らず取得が始まらない。初期表示分の画像は非遅延（eager）にする（MUST）。ブラウザキャッシュがあると再現しないため初回訪問相当で計測する。画像の読み込み挙動はそれを囲む CSS とセットで判定し、テストは `loading` 属性の式ではなく描画結果の属性を検査する（MUST）
- **Slides-in-View SSOT**: 「同時に表示される枚数」はレイアウト CSS と画像読み込み属性の両方が依存する値であり、定数化して SSOT にし、CSS 側の値との一致をテストで機械検査する（MUST）。片方だけ変えると沈黙故障になる
- **Preload vs Eager Separation**: レスポンシブに表示枚数が変わる場合、preload（LCP 候補 1 枚のみ）と eager（最大同時表示枚数ぶん）を分離し、2 枚目以降は低優先度で「発見は早く、優先度は低く」する（SHOULD）。preload リンクはメディアクエリを持てず SSR 時点で確定するため、全枚に付けると狭い画面で帯域を浪費する。共有表示コンポーネントの `priority` / preload は無条件にせず opt-in にし、真に above-the-fold の用途だけが有効化する。preload の実在は SSR HTML の `<link as="image">` 数で監査できる
- **Carousel Adjacency Exception**: カルーセルの隣接スライド画像は Below-the-Fold 規定を機械適用して `lazy` のままにしない。現在位置の前後 1 枚と先頭だけを eager にする純関数で制御する（MUST）— 送られた瞬間に読込が始まって届くまで黒地が見える一方、全部 eager は初回に全取得して LCP を悪化させる。隣接要素を見せる演出（減光・縮小）は隣が実際に見えるレイアウト条件（メディアクエリ）にだけ掛け、1 枚表示の面に掛けない（MUST）— opacity と brightness は黒地との合成で二重に暗くなる。ライブラリの遷移速度と CSS transition の duration を揃え、検証は遷移中フレームの平均輝度・暗い画素率を実測して前後比較する（SHOULD）
- **LCP Entry Evidence**: LCP を理由に UI 挙動（自動再生停止・遅延）を変える提案は、LCP entry の実測（PerformanceObserver `largest-contentful-paint`）を根拠として添える（MUST）。LCP は「既存候補より大きい」描画でしか候補を更新しないため、等サイズの器に描かれる後続スライドは LCP 候補を更新せず、「切替が LCP を後ろ倒しにする」は仮説であって事実ではない。自動再生を止める最適化で利用者に「動いていない」と知覚させず、`prefers-reduced-motion` の利用者のみ停止し一時停止手段（hover / touch）は残す（MUST）
- **The Lazy Fetch Sentinel Protocol**: 遅延取得の目印（sentinel）は常に見えている要素へ置く（MUST）。閉じた `<details>` や `display:none` 配下は交差せず、「開いた瞬間だけ空」という一番見えにくい形になる。スクロール枠の中の目印は `root` にその枠を渡す（MUST）— 省略は viewport を意味し、枠の底まで送っても一生発火しない。交差だけに頼らず hover / focus / 開閉も受け皿にし、取得済み集合で二重取得を弾く。先読みは枠そのものの接近（root=viewport）と枠の底（root=枠）の 2 段にする（SHOULD）
    - 「発火しない」の切り分けは `getBoundingClientRect()` / `scrollHeight` / `clientHeight` の実測と、同条件の observer をページ内で張り直して `isIntersecting` を直接見ることで行う（SHOULD）。継ぎ目のなさは人のスクロール速度（例: 約 800px/s）を模して「枠へ到達した時点で続きが入っているか」で測る。3 つの「交差しない置き方」はすべて型検査・lint・build を通る

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
- **object-fit Co-Review**: 画像の `object-fit` を `cover` ↔ `contain` で切り替える変更では、同じ要素と親要素の背景色指定も同時に要否判定する（MUST）。正本は `design/000_design_ux.md` の「Object-Fit & Background Co-Review」。

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
- **Single Metadata Helper**: 全ての公開詳細ルートのメタデータ生成は、OG・Twitter card・robots・canonical を一括で出す 1 つのヘルパーを経由する（MUST）。個別ページで `{ title, description }` だけを返す実装は SNS プレビュー欠落・canonical 欠落・将来の仕様変更の取りこぼしを生む。ヘルパー未経由のルートは、動的ルートを走査して `generateMetadata` を持ちながらヘルパーを参照しないファイルを列挙するスクリプトで機械検出する（SHOULD）

### §107. The Structured Data Protocol (JSON-LD)

- **Rule 33.108**: 型安全なJSON-LDスキーマを実装する。`schema-dml` 等の型付きライブラリを使用し、手書きJSONは禁止
- **Required Types**: `Organization`, `WebSite`, `BreadcrumbList`, `FAQPage`, `Product` 等のビジネス関連スキーマ
    - **但し書き（Rich Result Eligibility）**: 必須項目を偽らずに満たせない型は出さない。リッチリザルト対象型（`Product`、`SoftwareApplication`、`SocialMediaPosting` 等）は必須項目（例: `Product` は `image` と購入完結、`SoftwareApplication` は `aggregateRating` または `review`）を型を選ぶ前に確認し、埋められないなら対象外の型（`Service` + `offers`、`WebPage` 等）で意味づけだけ残す（MUST）。対象型の適格性は検索プラットフォームの一次資料で確認する。失敗パターン: 満たせない型を出し続け「有効 0 件・無効 25 件」のまま、ルール自身がその実装を指示していた。迷ったら同業の本番 HTML を実測する（SHOULD）
- **Rule 33.108a（Eligibility First / Measured-vs-Fixed Check）**: 外部プラットフォームの表示機能への対応可否は、自分の構造化データの厚さではなくプラットフォームが対象としているページ種別・型で決まる。着手前に公式ドキュメントで対象タイプと制限を確認する（MUST）— 対象外の面に実装を増やしても成果は出ない。ただし評価軸が複数ある場合（検索リッチリザルトと AI 検索／GEO）、片方で無効でももう片方で読まれる構造化データを撤去してはならない（MUST NOT）。監視画面の「未対応」表示を根拠に工数を割く前に、その表示が測定値か固定値（ハードコード）かを確認する（MUST）
- **Type Ledger & Complement Violation**: 出してよい型の分類（リッチリザルト対象／対象外／禁止）と型ごとの必須項目は 1 つの台帳（定数）に集約し、台帳に無い型が出力されたら違反にする（MUST）— 危険な型を名指しで弾く方式は次に増えた型を取りこぼす。正本は `product/500_growth_marketing.md` の「Type Ledger」「Mechanical Source Collection」。
    - ソース検査は「書かれている型」しか見られない。配信される JSON-LD は DB 内容・ロケール・セクション構成で変わるため、本番 URL を日次で取得し、型・必須項目・重複・パース不能を同じ純関数で判定して失敗を起票する（MUST）
- **Enum Value Constants**: schema.org の enum 値 URL（`https://schema.org/{EnumName}`、大文字小文字厳密）は文字列リテラルで書かず `as const` の定数 SSOT に集約する（MUST）。型付きライブラリでも enum URL は string のため typo が通り、クローラー側で「知らない値」と判定されるだけで開発側に feedback が無い。新規スキーマ追加は「公式仕様確認 → enum を定数へ追加 → リッチリザルトテストで警告 0 → Search Console で error 0」の順で通す。検出: `schema.org` を含む URL のうち非正規パターンを grep
- **Hierarchical Entities & Multiple Scripts**: 階層を持つ一覧ページ（地域・カテゴリ・組織階層）は `ItemList` だけでなくページ自身のエンティティ型（例: `AdministrativeArea` + `containedInPlace`）で親子関係を宣言する（SHOULD）。正本は `product/500_growth_marketing.md` の「Hierarchy & Co-location」。

### §108. The Canonical URL Protocol

- **Rule 33.109**: 全公開ページで `alternates: { canonical: url }` を定義し、重複コンテンツによるSEOペナルティを防止する
- **Trailing Slash**: プロジェクト全体でトレーリングスラッシュの使用を統一する（`next.config.ts` の `trailingSlash`）
    - **Normalization Consistency Across Declarations**: 公開 API や AI 向けエンドポイントのパスは、robots・llms.txt・OpenAPI・プロキシの認証除外条件・ルート実装の全てが同じ正規 URL（末尾スラッシュ含む）を参照する（MUST）。末尾スラッシュ正規化が有効な環境で除外条件が「なし」だけを見ていると公開 API が `401` になる。除外条件はあり／なし両方を扱う。クローラー向け許可パス（llms.txt・robots）は実在する公開ルート・sitemap・ルート定数と照合し、存在しないパスを案内しない（MUST）。公開エンドポイントは build 成功だけでなく実 HTTP で `200` と期待する `Content-Type` を確認する（MUST）
- **URL Key Normalization**: URL パスをキーにした完全一致照合（リダイレクト・canonical・キャッシュキー）は、パーセントエンコードの 16 進を小文字に揃える等の RFC 3986 §6.2.2.1 正規化を通してから引く（MUST）。ブラウザや Wayback Machine は同じ URL を大文字エンコードで送り、完全一致から外れて 404 になる。同一 URI の別綴りに対して行を足して直すのは禁止（次の綴りでまた漏れる）。代表例の検証が緑でも全数の緑を意味しない — 母集団を作って全数を照射し日次で回す（SHOULD）
- **URL Stability（Cool URIs）**: 一覧面を分割・新設しても、既に索引・被リンクされた詳細 URL は変えない（MUST）。分割はナビゲーション（パンくず中段）とサイトマップ・計測の page type に反映する。同型の一覧面は本体 1 つ + 表示設定（見出し・ヒーロー・翻訳名前空間）で分岐し、ページファイルを複製しない（MUST NOT）。新しい一覧 URL は sitemap・HTML サイトマップ・自社計測の page type に同時に載せる（MUST）
- **Canonical via Route SSOT**: canonical URL はテンプレートリテラルのハードコードではなく、ルート定義の SSOT ヘルパー（`ROUTE_PATHS.X(slug)` 相当）から構築する（MUST）— ルート形式変更時の取り残しを防ぐ。正本は `product/500_growth_marketing.md` の「Canonical Construction」。

### §109. The Dynamic OGP Protocol

- **Rule 33.110**: `@vercel/og` または `ImageResponse` でOGP画像を動的生成し、SNSシェアのCTRを向上させる
- **Dimensions**: 1200×630px（Facebook/LinkedIn標準）を基準とする
- **No Fabricated Metadata**: 「メタデータを明示する」型の要件（画像寸法・MIME type・更新日等）を実装するときは、その値を実際に持っているかを先に確かめる（MUST）。正本は `product/500_growth_marketing.md` の「No Fabricated Metadata」。
- **OG Image Dimensions & Robots Directives**: メタデータ生成の共通関数は OG 画像に `width / height / type` を既定で付与する（MUST）— SNS クローラーが画像を取得せずに比率を確定でき切り抜き・ぼけを防ぐ。index 対象ページの `robots` には `max-snippet:-1, max-image-preview:large, max-video-preview:-1` を既定で付与し、`noIndex` 時は `index:false, follow:false, nocache:true` 相当のみを出す（SHOULD）。検出: `openGraph:` / `robots:` の生成箇所で寸法・max-* の不在を grep

### §110. The Robots & Sitemap Protocol

- **Rule 33.111**: `app/robots.ts` と `app/sitemap.ts` を実装し、クローラーのアクセス制御とページの発見可能性を保証する
- **Dynamic Sitemap**: DBからページリストを取得し、動的サイトマップを生成
- **Disallow vs noindex**: `noindex` を効かせたい URL（ログイン・登録・内部リンクされる認証ページ等）を robots で `Disallow` してはならない（MUST）。クローラーが `noindex` を読めず「ブロック済みだがインデックス済み」に育つ。noindex を効かせたい URL はクロールさせる。小規模サイトでのクロール予算節約は、Disallow と noindex の同居という矛盾の害が利益を上回る（SHOULD）。設定ファイルへ追記する前に、そのファイル自身のコメントに書かれた禁止理由を読む（MUST）— 自分のファイルの根拠に反する追記はレビューより先に本人が止められる
- **Freshness Signal Sync**: JSON-LD `dateModified` は `updated_at || created_at` のフォールバック連鎖で出し、`created_at` 直書きは「常に古い」を発信し続けるため禁止（MUST NOT）。正本は `product/500_growth_marketing.md` の「Fallback Chain & Four-Channel Sync」。

### §111. The Ghost Content Protocol (Time-Gated SEO)

- **Rule 33.112**: 公開前コンテンツには `noindex` を設定し、クローラーによる時期尚早なインデックスを防止する
- **Rule 33.112a（AI 学習抑止は別手段）**: 公開前サイトの抑止は「検索インデックス」と「AI 学習」を別の手段で行う（MUST）。`noindex`（`X-Robots-Tag` / `meta robots`）は検索エンジン向けの標準であり、AI クローラーの公式オプトアウト手段は robots.txt の `Disallow` だけ。「noindex にしてあるから学習もされない」は成立しない。検索インデックスは後から削除依頼できるが学習データに入ったものは実質取り消せず損害が非対称
    - UA 別に扱いを分け、両者を同じ設定にしない（MUST NOT）: 検索エンジン（`*`）は `Allow` のまま + `noindex`、AI クローラーは `Disallow: /`。`*` を `Disallow` にするとクローラーが `noindex` を読めなくなり既存インデックスがかえって消えない（§110 参照）。公開後の GEO 方針（AI クローラー明示 Allow）は同じスイッチに連動させ解除時に自動復帰させる（SHOULD）。一般形: ある標準が「クローラー全般に効く」と暗黙に仮定すると、その標準を採用していない新種のクローラーが盲点になる — 「誰が何を尊重するか」はベンダーの一次ドキュメントで確認する（MUST）
- **Authenticated Personal Pages**: 個人データを表示する認証済みページは明示的に noindex / nofollow / nocache を出し layout 単位で継承させる（SHOULD）— 認証済みクローラー（社内 BI ツール・リンク unfurler）が URL を crawl した場合、フレームワークの既定メタデータは `index: true` を暗示する。取得後に `entity.owner_id !== user.id` を page-level で検証し、存在しない場合と所有不一致を同じ not-found で隠す（MUST）。RLS は単一障害点にしない

### §112. The Microcopy Identity Protocol

- **Rule 33.113**: エラーメッセージ、ラベル、プレースホルダーをサービスのTone & Voiceに統一する。「エラーが発生しました」等の汎用的な表現は避ける

---

## Part XXI: Technical SEO & GEO 🌐

### §113. The Semantic HTML Landmark Protocol

- **Rule 33.114**: セマンティックHTML要素（`<header>`, `<nav>`, `<main>`, `<article>`, `<aside>`, `<footer>`）を使用し、ページ構造を明示する
- **Heading Hierarchy**: `<h1>` → `<h2>` → `<h3>` の階層をスキップせず、論理的な見出し構造を維持する
- **Single H1 Rule**: 1ページにつき `<h1>` は**一つだけ**
- **Heading Rebase for Embedded Rich Text**: エディタで自由に選べる見出しレベルは、保存時の矯正では既存データも将来の入力も守れない。ページのアウトライン（h1=題名、h2=区画、h3=節…）に本文を埋め込むときは、描画側で「本文の最も浅い見出しが所定のレベルになるよう全見出しを同じ量だけずらす」再基準化を行い、相対階層を保ち 1〜6 にクランプする（MUST）。DB 上の値は書き換えない。再基準化は描画前の JSON に対して一度だけ行い、SSR とクライアントが同じ JSON を描くようにする（MUST）— 片側だけ HTML を書き換えると hydrate で元に戻り、クローラーは描画後の DOM を見る。意味（タグ）だけを直し見た目は元のレベルに保つ（持ち上げた段数をラッパーのクラスに持たせ CSS で戻す）（SHOULD）。検査は純関数の真理表と、描画結果に対する「階層飛び 0 件」のテストで固定する

### §114. The SSR First Protocol

- **Rule 33.115**: クリティカルコンテンツはServer Side Renderingで初回HTMLに含める。クライアントサイドでのみレンダリングされるコンテンツはクローラーに遅延認識される
- **AI Crawlers Do Not Execute JavaScript**: AI 検索のクローラーは JavaScript を実行せず初期 HTML だけを読み、再訪もしない。公開面の本文・内部リンクをクライアント側の遅延読み込みへ移すことは AI から見て「消える」のと同じである（MUST 前提）。共通ブロック（サイドバー等）からリンクを削るときは、先に文脈の合う場所（例: 親ページに子ページのリンク）へ SSR で置き、その後で削る。逆順は禁止（MUST）— 消えている期間に読まれた分は戻らない。削ってよいかは canonical と sitemap で判定する（MUST）: canonical が別 URL へ正規化され sitemap からも外れたファセットは元から index 対象外で、全ページに積むのはクロール予算の浪費。AI の本文抽出はリンク密度を特徴量にナビ・広告を落とすため、リンクは文脈が合う場所へ置き共通ブロックへ積まない（SHOULD）
- **No Streaming Boundary Around Public Body**: ストリーミング SSR の遅延境界（React Suspense 等）の子は、初期 HTML では非表示のプレースホルダとして末尾に流され JS で差し替えられるため、JS を実行しないクローラーには骨組みしか見えない。AI 検索から見える必要のある公開面では、H1・本文・結果一覧・JSON-LD を遅延境界の子に置いてはならない（MUST）。TTFB より本文到達を優先する。この方針は詳細ページの個別判断ではなく公開面全体の方針として扱い、ガード（テスト・lint）は対象ページを名指しせず公開ルートの集合に対して持つ（SHOULD）— 詳細で直したのに一覧 3 本に残っていた失敗が、個別判断で終わらせる危うさを示す

### §115. The IndexNow Protocol

- **Rule 33.116**: コンテンツ更新時に IndexNow API で検索エンジンに即時通知し、クローリングまでの待機時間を削減する

### §116. The GEO (Generative Engine Optimization) Protocol

- **Rule 33.117**: AI検索エンジン（ChatGPT、Gemini、Perplexity等）向けに以下の最適化を実施する:
    - FAQ構造化データ + 簡潔な回答パラグラフの提供
    - `llms.txt` / `llms-full.txt` の配置
    - E-E-A-T（Experience, Expertise, Authoritativeness, Trustworthiness）の強化
- **Cross-Reference**: `ai/000_ai_engineering.md`

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
- **Label + Hidden Icon Pair**: `<button>` / `<a>` の子がアイコンのみ（text node なし）のとき `aria-label` を動作を表す動詞句で必須とし（MUST）、同時にアイコン側へ `aria-hidden="true"` を付けて二重読み上げを防ぐ（MUST）。`outline-none` で潰されている場合は `focus-visible` のリングを併設する（MUST）。アイコン上の動的バッジは装飾なら `aria-hidden`、意味があるなら親の `aria-label` に含める
    - **Lint は取り切れない**: `jsx-a11y/control-has-associated-label` は子要素のテキスト解析が浅く `<button><Icon/></button>` を通す。監査では `aria-label` / `title` 無しの button を抽出しタグと式を strip した内側テキストが空のものを列挙するソース走査ヒューリスティックを実行し、偽陽性込みの候補を目視で確認する（SHOULD）。同一ルールの退行が複数箇所で繰り返された記録があり、能動的な走査が要る

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
- **Invalid Destination Hygiene**: Push 配信先の識別子（デバイストークン・endpoint 等）は、配信サービスから無効応答（`410 Gone` / `NotRegistered` 相当）を受けた時点で即座に削除する（MUST）— 無効宛先への送信継続は送信元の品質低下・ブロックを招く。起動時に最新識別子を取得して差し替え、長期未使用の識別子は定期削除し、無効率を監視して閾値（例: 10%）超過でアラートする（SHOULD）

### §129. The Install Prompt Protocol

- **Rule 33.130**: カスタムインストールプロンプトでPWAインストール率を向上させる。`beforeinstallprompt` イベントをキャプチャし、適切なタイミングで表示する
- **Display Conditions**: カスタムインストールプロンプトは、関心（訪問回数閾値、例: 3 回以上）・滞在（セッション時間閾値、例: 60 秒以上）・拒否履歴（直近 N 日、例: 30 日に閉じていない）の全条件を満たした場合のみ表示する（MUST）— 初回訪問での即時表示は不信感を招く。非モーダルのバナーで利点を説明してからネイティブプロンプトを出し、表示回数／インストール完了の比率を計測する（SHOULD）。閾値は Blueprint で定める

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
- **Locale-Prefixed Path Matching**: サブディレクトリ方式の i18n では、現在パスとルート定数の比較（ナビの現在地判定・特定ページでの部品の出し分け・メンテナンス除外・パンくず等）は、必ずロケール接頭辞を剥がす共通関数を通してから行う（MUST）。既定ロケールが接頭辞なしの場合、剥がし忘れは既定ロケールでは正しく動き、非既定ロケールだけで機能が同時多発的に壊れる（5 箇所が同時に壊れていた例）。レビューで検出できないため、パス取得 API の利用箇所を走査し、正規化を通さない照合をファイル名付きで報告する自動テストを置く（SHOULD）
- **Locale Verification by Body Text**: 静的レンダリング区間ではリクエスト依存の locale 解決は構造的に不可能で、レイアウトとページで動的性が異なると「半分だけ翻訳された HTML」が生まれる。locale 依存表示の検証は `<html lang>` やメタではなく本文の実文言で判定し（MUST）— lang はレイアウト由来で先に直るため最も誤解を生む指標 — 必ず対象 working tree のサーバーで行う（MUST）。恒久解は locale をルート構造・キャッシュキーへ昇格させること

### §133. Translation Workflow

- **Rule 33.134**: i18n辞書ファイル（JSON/TS）はnamespace分割し、ページ単位でlazy loadする
- **Missing Key Handling**: 翻訳キーが欠落している場合、フォールバック言語のテキストまたはキー自体を表示する。空文字列やundefinedをレンダリングすることは禁止
- **Operator-Entered Values Are Single-Locale**: 管理画面や CMS から運営者が入力する設定値（ラベル・注記等）は、ロケール次元を持たない限り既定ロケール専用の値である。`運営値 || 辞書` のフォールバック順は値が存在する限り辞書を一度も使わず、非既定ロケールで既定言語が漏れ出す。非既定ロケールでは辞書を優先し運営値は既定ロケールでのみ採用するか、ロケール別カラムを持たせる（MUST）。サーバー処理が返す固定文言も同様に扱い、文言ではなくエラーコードを返す設計を優先する（SHOULD、`core/200_language_protocol.md` 参照）

---

## Part XXV: エラーハンドリング & レジリエンス 🔀

### §134. Error Boundary

- **Rule 33.135**: `error.tsx`（App Routerのエラーバウンダリ）を全ルートセグメントに配置し、未処理例外がユーザーに白画面を表示することを防止する
- **Recovery**: エラーUIには「再試行」ボタンを含め、ユーザーが回復アクションを取れるようにする
- **Client Exception Safety Boundary**: Client 側 `catch` で得た未知例外の `message` を toast / alert / inline に直結せず、ユーザー向け文言だけを通し、内部語彙（token / secret / service_role / constraint / ベンダー名）を含む文言は操作別 fallback に落とす安全化境界を 1 箇所に置く（MUST）。個別コンポーネントで「たぶん安全」と判断すると内部文言が画面・スクリーンショット・エラートラッカーの breadcrumb へ流れる。サーバーが意図して返した `result.error` はその境界で安全化済みとして扱う
- **Capture Coverage ≠ PII Scrub**: エラートラッカーの自動計装は「catch して構造化応答を返す」パターンを捕捉しないため、logger.error + capture を 1 helper に集約し `source` タグ（`api:*` / `cron:*` / `webhook:*` / `action:*` / `segment:*`）を付ける（SHOULD）。正本は `operations/400_site_reliability.md` の「Capture Coverage ≠ PII Scrub」。

### §135. Global Error Handling

- **Rule 33.136**: `global-error.tsx` でRootLayoutを含む致命的エラーをキャッチし、カスタムエラーページを表示する

### §136. Not Found Handling

- **Rule 33.137**: `not-found.tsx` をカスタマイズし、404時に有用なナビゲーション（ホーム、検索等）を提供する
- **The Streaming Soft-404 Protocol**: ストリーミング SSR では、ローディング／Suspense 境界の内側で `notFound()` を投げても、シェルが 200 で先行 flush された後はステータスを変えられない（soft-404）。ルート直下の `loading.tsx` が境界を作る構成では page body・`generateMetadata` どちらで投げても捕捉される。真の 404 が必要なルートは、軽い存在チェックをブロッキング（境界の外）で行い重い本体だけを境界内に置く設計にする（MUST）
    - 即効の是正として全動的ルートの欠落時に noindex を保証しインデックス汚染を閉塞する（MUST）— ステータスは 200 のままでも実害は止まる。検証はコードの静的読解ではなく本番ビルドの実測で行い、HTTP ステータスと robots meta の両方を確認する（MUST）。「`notFound()` があるから 404」と読解で断定してはならない（MUST NOT）— 静的読解で誤判定した記録がある。メタデータ側に欠落分岐を追加する際は、本体側の「代替解決 → リダイレクト」経路（レガシー ID 等）を先に殺さないよう、同じ ID 解決を欠落分岐の先頭で確認する（MUST）

### §137. Offline & Network Resilience

- **Rule 33.138**: API呼び出し失敗時の対応:
    - 自動リトライ（指数バックオフ、最大3回）
    - オフライン検知（`navigator.onLine` / `online`/`offline` イベント）
    - 楽観的更新 + ロールバック
- **Empty ≠ Error**: 一覧・件数・状態を取得するデータ取得層は「0 件」と「取得失敗」を区別できる戻り値（`status: 'ok' | 'error'` 等）を返し、失敗を空配列や 0 で表現しない（MUST NOT）。UI は失敗時に空状態文言（「〜はありません」）を出さず、エラー表示と再試行手段を出す（MUST）。空状態と失敗状態は別のコンポーネントとして設計する（`design/000_design_ux.md` 参照）

### §138. Console Warning Protocol

- **Rule 33.139**: `console.error` や `console.warn` は開発の失敗の証拠。全ての `console.error` は修正するか、正当な `Logger` に置き換える
- **Same-Message Flood Is a Root-Cause Signal**: 同一文言の console 警告が大量に出ている状態をノイズとして放置しない（MUST NOT）。件数が多いほど根因（例: 描画ライブラリとフレームワークのメジャー版非互換、§5 参照）である可能性が高い

### §139. Graceful Degradation Protocol

- **Rule 33.140**: 外部サービス（Analytics、Chat、Ad等）の読み込み失敗がアプリの主要機能を阻害してはならない。`try-catch` で隔離し、フォールバックを表示する
- **Terminal Placeholder Mandate**: 外部依存の N 段フォールバック（一次取得 → 代替埋め込み → …）には、全段失敗時の明示的な終端表示（stage N+1）を必ず用意する（MUST）。終端を考慮しないと空白 box・無限スピナー・無音の失敗で UX が崩壊する。判定は各段の入力が全て空 / null のとき終端へ落とす。終端表示は支援技術にも失敗を伝え（`role="img"` + 説明ラベル等）（MUST）、テストは各段の出力分岐を全て SSR / 描画レベルで検証する（SHOULD）

---

## Part XXVI: Server Actions & API安全性 ⚛️

### §140. Server Actions 基本原則

- **Rule 33.141**: `'use server'` ディレクティブはファイルの先頭に配置し、ファイル全体をServer Actionファイルとして定義する。インライン `'use server'` は禁止
- **Auth Guard**: 全Server Actionsの先頭で認証チェックを実行する。認証なしのServer Actionは原則禁止
- **Every Export Is an Endpoint**: `'use server'` を宣言したファイルの export は全て匿名から呼べる公開エンドポイントと見なす（MUST）。「サーバー内部でしか呼んでいない」は根拠にならない（呼び出し側の事情は防御にならない）。cron・内部集計・特権書き込みを Server Action に同居させず（MUST NOT）、`server-only` の通常モジュールへ移してエンドポイントであること自体をやめる — ゲートを足すのは次善で攻撃面を消すのが最善。残す場合はその関数自身の中でゲートを通す（同一ファイルの別 export が守られていても無関係）。外から来る数値（窓・件数・遡り日数）は上下限へ丸める（MUST）
    - **機械検出**: 「特権クライアントを直接使う export に、ゲートらしい呼び出しが同居しているか」を lint に組み込み、匿名から叩ける仕様の例外は理由付きの台帳に置き、母数と古い許可の残留も検査する（SHOULD）。実測で数百 export 中 1 件の異物が未認証の特権書き込みだった
- **DB-Hidden Columns Stay Hidden in DTOs**: 特権クライアント（RLS／列 GRANT をバイパスする資格情報）で読んだ値を公開 DTO へ変換する経路は DB 側の露出制限を迂回する。DB で匿名から隠した列は DTO 側でも落とし、DB 側の期待集合を読み込んで DTO 出力に残らないことを assert する「挙動での突合」テストを置く（MUST）。逆向き（DTO に追加したが DB 台帳に無い）は CI が赤くなるがこちら向きは何も赤くならないため、突合を両方向にする（SHOULD）。サーバー専用の値は公開 DTO から読まず server-only の読み口を分けて必要列だけ select する（`engineering/200_supabase_architecture.md` Rule 2.9 参照）

### §141. Return Type Safety

- **Rule 33.142**: Server Actionsの戻り値はシリアライズ可能な型のみ。`Date`オブジェクト、関数、クラスインスタンスは返却禁止

### §142. Rate Limiting

- **Rule 33.143**: 公開Server Actions（Contact Form送信等）にはレート制限を実装する
- **Entry Order**: 外部から到達するエンドポイントの入口順序は「①パラメータ／パス／ID の形式検証（400 で即時拒否）→ ②レート制限 → ③永続層アクセス」とする（SHOULD）。正本は `engineering/100_api_integration.md` の「Entry Order」。
- **Public Analytics Actions**: 公開ページ由来の analytics 書き込み（閲覧／検索／クリックログ）は任意認証（未ログインは null で正常系とし例外化しない）・IP レート制限・呼び出し元供給 ID の形式検証で扱い、特権クライアントでの更新は公開状態の行に限定し、失敗時はログ書き込みだけスキップしてページ表示を止めない（MUST）。正本は `security/000_security_privacy.md` の「Public Analytics & Observation Endpoints」。

### §143. File Upload via Server Actions

- **Rule 33.144**: ファイルアップロードは `FormData` 経由でServer Actionに渡し、サーバーサイドでバリデーション（ファイルタイプ、サイズ、マジックバイト検証）を実行する

### §144. Mutation Side Effects

- **Rule 33.145**: Server Action内でのデータ変更（CUD操作）後は `revalidateTag()` で関連キャッシュを明示的に無効化する
- **Invalidation Wiring Before Caching**: クロスリクエストキャッシュを新設・拡張する差分は、その読み取り結果を変えうる全 mutation 経路（作成・更新・削除・一括操作）が同一の無効化タグを発火することを列挙して証明する（MUST）。証明できなければ TTL 任せの staleness 回帰でありキャッシュ追加を保留する。「パス単位の無効化（`revalidatePath`）」と「データキャッシュ単位の無効化（`revalidateTag`）」は別機構で、前者が後者を消すと仮定してはならない（MUST NOT）。同一データに複数モジュールが異なるタグ体系を持つならタグ標準化が先（`engineering/730_caching_discipline.md` 参照）

### §145. The API Key Isolation Protocol

- **Rule 33.146**: APIキーは `NEXT_PUBLIC_` プレフィックスでクライアント公開してはならない。全APIキーはServer Actions / Route Handlersでのみ使用
- **Cross-Reference**: `security/000_security_privacy.md`

### §146. The Input Sanitization Protocol

- **Rule 33.147**: Server Actionsに渡されるユーザー入力は `zod` でバリデーション後、必要に応じてサニタイズ処理を実行する。生のユーザー入力を直接DBクエリやHTML出力に使用することは禁止
- **Filter Syntax Delimiter Neutralization**: クエリビルダーや REST フィルタ言語（PostgREST の `.or()` 等）に文字列としてユーザー入力を埋め込む場合、そのフィルタ言語の構文区切り文字（カンマ・括弧・ドット等）をクエリ発行の直前で置換・削除する（MUST。例: `query.replace(/[,()]/g, ' ')`）。プレースホルダ化されないフィルタ文字列は SQL 同様に Injection 面であり、「クエリビルダーなら安全」は誤解。無害化はバリデーション層とは別にクエリを組み立てる関数の内側で行い、迂回経路を残さない（SHOULD）

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

- **Rule 33.154**: Cookie等の同意・通知・拒否・第三者提供を、適用法域と実際のデータフローで判定する。日本を一律オプトアウトと扱わない。[個人情報保護委員会FAQ](https://www.ppc.go.jp/personalinfo/faq/APPI_QA/)を含む対象法域の一次資料で確認する。
- **Consent Management**: ユーザーの同意状態に基づきトラッキングスクリプトのロードを制御する

### §155b. The Post-Privacy Sandbox Tracking Strategy

- **Rule 33.328**: Google Privacy Sandbox は **2025年10月に正式廃止**された。サードパーティCookieはChromiumブラウザで当面存続するが、以下のプライバシーAPIへの移行を推進する:
    - **CHIPS (Cookies Having Independent Partitioned State)**: パーティション化されたCookieで安全なクロスサイトデータ管理
    - **FedCM (Federated Credential Management)**: サードパーティCookieに依存しない連携ログインプロトコル
    - **Private State Tokens**: ボット判別・ユーザー信頼度の検証をCookie不要で実現
- **Strategic Shift**: サーバーサイドトラッキング（§152のCAPI統合）への移行が加速。クライアントサイドCookie依存度を段階的に削減する
- **ITP/ETP対応**: Safari（ITP）・Firefox（ETP）はサードパーティCookieを既に事実上ブロック済み。Chromiumでの存続に依存しないアーキテクチャを設計する
- **Cross-Reference**: `ai/100_data_analytics.md`, `security/000_security_privacy.md`

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
- **Mobile-First Measurement**: 性能ゲートの計測条件は、利用者分布のうち最も制約の強い環境（低速回線 + CPU スロットリングのモバイルシミュレーション）を既定とする（MUST）。デスクトップ条件のみでの合格は無効とし、モバイル条件の閾値を Blueprint で定める。計測条件（デバイス・回線・スロットリング倍率）は CI 設定に明記しレポートに併記する（SHOULD）— 条件を固定しない性能ゲートは「PC では速い」で通ってしまう。条件の異なるスコアを比較しない

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
- **Revalidated Static as Default**: 公開一覧・索引ページは、毎リクエスト生成（コスト・TTFB・クローラー負荷）と完全静的（新着が永遠に出ない）の両極端を避け、更新頻度に応じた再検証付き静的化を既定とし、書き込み側の on-demand 無効化と組み合わせる（SHOULD）。ページ全体の静的化候補は (a) パスパラメータのみ (b) 認証状態を読まない (c) 公開読み取り専用 (d) 更新頻度が再検証間隔より長い、の 4 条件を満たすものに限る（MUST）— クエリ文字列等のリクエスト単位入力を持つページは本質的に動的で、キャッシュキーに含めると爆発する
    - 認証依存・ユーザー固有ページは静的化から完全除外し意図を明示宣言する（MUST）— ユーザー間キャッシュ漏えいは重大なセキュリティ事故。動的入力を持つページの代替は (1) 入力をパス化 (2) 静的シェル + 動的断片 (3) データ取得関数単位のキャッシュ、から選ぶ（SHOULD）。監査は「再検証未設定ページ」を機械列挙し、動的入力の有無で事前フィルタしてから候補化する

### §166. Edge Config

- **Rule 33.167**: Feature Flags、A/Bテスト設定、リダイレクトルール等はEdge Config（Vercel Edge Config等）で管理し、デプロイ不要の即時反映を実現する

### §167. CDN Strategy

- **Rule 33.168**: 静的資産（画像、フォント、CSS/JS）は**CDN**からの配信を必須とする
- **Cache-Control**: `public, max-age=31536000, immutable`（ハッシュ付きアセット）
- **Delivery-Layer-First Diagnosis**: 静的資産の体感遅延・再取得の調査は、コンポーネントやローダーの最適化より先に配信層を実測する（MUST）: 変換（リサイズ／フォーマット）が実際に効いているか、`Cache-Control` の実ヘッダー、CDN のヒット／ミス状態を curl で確認する。アップロード経路によって cache-control 未指定（`no-cache` 配信）になる資産が混在しうる。開発環境では画像変換が無効なことが多く、srcset / preload の実効性と LCP は本番相当の配信構成で判断し開発環境の遅延を根拠にしない（MUST NOT）
    - 設定値を入れれば切り替わる配信経路（環境変数で有効化する CDN／プロキシ）は、値が入っていない限り一度も通しで検証されていない — 本番に値を入れた瞬間に全画像が落ちる状態だった例がある。本番へ値を入れる前に対象経路を実 URL で end-to-end に検証する（MUST）。診断ではエラーコードの差（「形式不正」まで進む = 変換自体は稼働／「拒否」= 手前で弾かれている）を「変換が有効か」と「その source が許されるか」の切り分けに使う（SHOULD）

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
- **The Always-Mounted Drawer Protocol**: 常時マウントで開閉する UI に「マウント = アクティブ」前提のモーダルプリミティブ（スクロールロックがマウントに無条件連動するもの等）を使ってはならない（MUST NOT）。ライブラリの配布物（dist）を実読して前提を確かめる。手組みするなら a11y（`role="dialog"` / `aria-modal` / Escape / Tab トラップ / フォーカス返却）を等価に提供する。閉状態の閉じ込めは `inert` 属性を第一候補にする（SHOULD）— 1 属性でフォーカス・支援技術・ポインタを一括除外でき SSR にも乗る
    - Portal を外して SSR HTML に実在させる場合、`transform` / `filter` / `perspective` を持つ祖先の外に描画する（MUST）— 変換祖先は `position: fixed` の containing block になりパネルが祖先の箱に拘束される。配置は source テストで固定する。宣言的 UI フレームワークが wheel / touchmove を受動（passive）で登録する場合、JSX ハンドラ内の `preventDefault` は無効なので、スクロール抑止は開いている間だけ native の非受動リスナーを装着する（MUST）。合成イベントを dispatch して `defaultPrevented` を読む機能テストで確認する。検証は対で行う: SSR 側は curl で属性・transform の実在 grep（否定側も）、挙動側は開閉両方向の中間フレーム捕捉（MUST）。`design/000_design_ux.md` の Portal 必須規定に対する例外（SSR 実在が必要な常時マウント UI）

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
- **Rule 33.186b（Sensitive-Screen Stop Gate）**: 機微画面で第三者 SDK（セッション記録・分析・広告）を止める門を書くときは、「止める／再開する」が (a) 送信の有無 (b) 記録モード (c) 標本率 (d) 永続化（sticky session）の 4 面でどう変わるかを、公開ドキュメントではなく配布物（実装）を読んで確認する（MUST）— マスキングしても URL・滞在・操作は残り、`stop()` / `start()` が標本率を無視する SDK がある。確認した前提は SDK の配布物を読む単体テストで固定し、SDK 更新で前提が変わったら赤くなるようにする（SHOULD）。止める順序はフレームワークの effect 実行順（insertion → layout → passive）まで確かめ、公開 API に「送らずに止める」が無ければ送信直前の envelope フィルタを最終層として持つ

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
- **Cross-Reference**: `ai/000_ai_engineering.md`

### §188. The AI Content Rendering Safety Protocol

- **Rule 33.189**: AI生成テキストのHTML/Markdownレンダリングにはサニタイズ処理（DOMPurify等）を必須とする。XSSインジェクションを防止

### §189. The Optimistic AI Response Protocol

- **Rule 33.190**: AIタスク（要約、翻訳等）の実行中はプログレスインジケータを表示し、完了後に結果を差し替える

### §190. The AI Rate Limiting UI Protocol

- **Rule 33.191**: AIサービスのレート制限到達時は、ユーザーに分かりやすいメッセージ（「しばらくお待ちください」）と待機時間の目安を表示する
- **Cost Friction Design**: 入力に連動して自動的に高コスト処理（生成 AI・外部 API・重い検索）が走る UI は、入力完了から一定時間（例: 800ms）のデバウンスを UI レベルで必須とする（MUST）。1 回の実行コストが高いアクションはワンクリックで発火させず、オプション選択後の「最終実行」ボタンで発火させる二段構成にする（MUST）— 誤クリックによるコスト浪費を構造的に防ぐ。制限到達時の文言はブランドトーンに合わせ再開時期の目安を添える（`design/000_design_ux.md` The Quota Framing Protocol 参照）

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
- **Origin Addition = Allowlist Update**: 外部オリジン（画像ホスト・埋め込み iframe・API 接続先・サードパーティスクリプト）を参照するコードを追加する変更は、対応する許可リスト（画像最適化の許可ホスト `remotePatterns`、CSP の各ディレクティブ、CORS、`preconnect` 対象）を同じ変更で更新する（MUST）。設定漏れは開発環境で気づかず本番でのみクラッシュ（500）／ブロックとして顕在化する。動的 URL（アフィリエイト・ユーザーアバター・UGC 埋め込み）を扱う機能では想定ドメインを実装初期にプリセットし、未知ドメインは安全にフォールバック（プレースホルダー画像・リンク化）させる（SHOULD）。外部サービスを追加した PR では、実際に読み込まれる外部リソースと CSP／許可リストの照合を受入条件にする（SHOULD。§99 参照）

### §203b. The CSP Level 3 Protocol

- **Rule 33.329**: **CSP Level 3** Working Draft（W3C 2026）へ段階的に移行する
- **Enhanced Directives**: `script-src-elem`, `script-src-attr`, `style-src-elem`, `style-src-attr` でスクリプト・スタイルの適用範囲をより精密に制御
- **Reporting API v2**: `report-to` ディレクティブで CSP 違反レポートを Reporting API v2 に送信し、`report-uri`（非推奨）からの移行を進める
- **Worker CSP**: `worker-src` でWeb Worker / Service Workerのスクリプトソースを分離制御する

### §204. The CORS Protocol

- **Rule 33.205**: API Routes / Server Actions の CORS 設定は最小権限原則で設定する。`*` のワイルドカード Origin は本番禁止

### §205. The Dependency Vulnerability Protocol

- **Rule 33.206**: `npm audit` / `pnpm audit` をCIに統合し、高・クリティカルの脆弱性を含むPRを自動ブロックする
- **Cross-Reference**: `security/200_oss_compliance.md`

### §206. The Permissions Policy Protocol

- **Rule 33.207**: `Permissions-Policy` ヘッダーを設定し、ブラウザ機能（カメラ、マイク、位置情報等）へのアクセスを明示的に制御する。不要な機能は `=()` で無効化

### §206b. The OWASP 2026 Compliance Protocol

- **Rule 33.330**: **OWASP Top 10 2026** の新カテゴリをフロントエンド設計に反映する:
    - **A03: Software Supply Chain Failures**: npm/pnpmの依存パッケージの脆弱性監視を強化する。`npm audit --audit-level=high` のCIゲート化に加え、lockfileの差分レビューを必須化。依存パッケージの署名検証（npm provenance）の導入を検討する
    - **A10: Mishandling of Exceptional Conditions**: フロントエンドの例外処理を厳格化する。全Error Boundary（§134–§139）のテストカバレッジ確保、未処理Promise rejectionの監視（`unhandledrejection` イベントリスナー）、Sentry等でのスタックトレース完全補捉を義務付ける
- **Supply Chain Defense**: `npm-lockfile-lint` でlockfileの整合性を検証し、予期しないレジストリ変更を検出する
- **Cross-Reference**: `security/000_security_privacy.md`, `security/200_oss_compliance.md`

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
- **overflow-x Implies overflow-y auto**: `overflow-x` / `overflow-y` の片方だけを `visible` 以外にすると、もう片方は `auto` に計算される（CSS Overflow 3）。横スクロールだけを意図する箱は `overflow-y` を明示（`hidden` または `clip`）する（MUST）— 縦のはみ出しが 0 でもタッチ端末はラバーバンドの受け皿にし、本文スクロール中に止まる離脱要因になる。`overscroll-behavior: contain` は親への伝播を止めるだけで箱自身のバウンスには効かない

### §220. The Fragment Misuse Ban
- **Rule 33.221**: `key` 属性が必要なリストレンダリングで `<>...</>` ショートハンドを使用し、キー警告を放置することは禁止

### §221. The Inline Style Object Ban
- **Rule 33.222**: JSX内でインラインスタイルオブジェクト（`style={{ margin: '10px' }}`）を直接記述することは原則禁止

### §222. The Event Handler Inline Function Ban
- **Rule 33.223**: リストのmapレンダー内でインラインアロー関数をイベントハンドラとして使用することは原則禁止

### §223. The Image Without Dimensions Ban
- **Rule 33.224**: `<img>` / `<Image>` に `width` と `height`（または `fill` + wrapper sizing）なしで使用することは禁止。CLS直接原因
- **Reserved Height Is Media-Only（対になる原則）**: 予約高さ（`min-height` / 固定 `height`）を許すのは、読み込み前に寸法が確定しない媒体（画像・動画・地図・埋め込み・広告枠）、タップ領域の最小寸法、読み込み後に置換される skeleton / 初期化前占位に限る（MUST）。テキストが中身となる器（本文・リッチテキストの描画領域・タブや一覧の外枠）に予約高さを置いてはならない（MUST NOT）— 短い本文の下に空白が出るだけでなく、SSR 段に同じ値が無ければ hydration で伸びて CLS 対策のつもりの `min-height` が CLS の発生源になる。編集面の都合（空エディタでもクリックできる最低高さ）を公開面の読み取り専用レンダラへ持ち込まない。固定高さのスクロール枠は `max-height` にし、公開レンダラに予約高さが混入していないことを自動テストで検査する（SHOULD）
- **Media Frame Ratio from Real Dimensions**: `object-fit: cover` で描くメディア枠に、画像の比率と無関係な固定高さを与えない（MUST NOT）— 上下が切れる。枠のアスペクト比は実データの画像寸法の分布から導き SSOT 定数として持つ。スライド・カードの幅を絶対値で固定しない（MUST NOT）— 中間幅（サイドバー付き 2 列等）でカラム幅が固定値より狭くなりはみ出す。枠 = カラムに合わせる。`contain` にすると比率の合わない画像で帯が出るため方針（cover を維持し少数の例外画像は切れる）を明記し、是正は各画面幅で「見えている割合」を実測して前後比較する（SHOULD）
- **Third-Party Content: Reservation and Constraint as a Pair**: 遅延読込される第三者コンテンツ（広告等）の領域予約は、コンテンツ種別ごとの実測サイズから決め、かつコンテンツ側の可変サイズ動作（全幅レスポンシブ等）を予約に収まるよう制限する（MUST）— 予約だけ・制限だけの片側対応では CLS は解消しない（狭い枠で予約の 2 倍超のサイズが返り CLS 0.4 超になった例）。管理データ（DB 上の幅・高さ）を予約値の根拠にする前に本番の実測と一致することを確認し（MUST）、予約値やコンテンツ側設定を変更したら本番で対象ページ種別ごとに CLS を再測して予算内であることを証跡にする（MUST）。予約定数には更新ルール（いつ・何を測って変えるか）を併記する（`product/300_revenue_monetization.md` §5 参照）

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
- **Peripheral Literal Drift**: 本体を定数参照にしても周辺で drift する。関数の default parameter（`getList(limit = 20)`）・省略時 fallback・HTTP ステータスの厳密比較・時間単位換算（`60_000`）・sitemap／redirect 除外・ヘッダー判定などの周辺境界も同じ SSOT を参照する（MUST）。表示・判定・アラートで共有される閾値は消費側（ダッシュボード・アラート）を作る前に SSOT 化し（MUST）、単位を名前または注記に埋め込む（`*_MS`、「比率 0-1」）（SHOULD）。検出: 比較演算子直後の数値リテラル（`> 0.15`、`<= 500`）を grep 対象にする

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
- **In-App Browser Tier**: ブラウザサポートマトリクスは汎用ブラウザだけでなく、対象市場でシェアの高いアプリ内ブラウザ（メッセンジャー・ポータル・SNS の WebView）をアナリティクスに基づき Tier に組み込み、Tier 1 なら全機能テストの対象にする（MUST）。正本は `quality/000_qa_testing.md` の「In-App Browsers」。

### §255. Passkey Support

- **Rule 33.256**: WebAuthn / Passkey をサポートし、パスワードレス認証を推進する。`navigator.credentials.create()` / `get()` APIを活用

### §256. Session Token Security

- **Rule 33.257**: セッショントークンは `HttpOnly`, `Secure`, `SameSite=Lax` のCookieに保存する。`localStorage` へのトークン保存は禁止
- **Cross-Reference**: `security/000_security_privacy.md`

### §257. Auth State UI Protocol

- **Rule 33.258**: 認証状態に応じたUI切り替えはServer Component層で実行する。Client Componentでの認証チェックは補助的にのみ使用

### §258. Protected Route Protocol

- **Rule 33.259**: 認証が必要なルートは `middleware.ts` でEdge Middlewareレベルでガードする。ページコンポーネント内での認証チェックのみに依存しない
- **No Privilege-Acquiring Page Under Its Own Guard**: 集中 guard（layout 等）の配下に、その権限を獲得する画面（招待受諾・オンボーディング・権限申請・契約同意）を置かない（MUST NOT）— 循環依存で機能が構造的に死ぬ。設計時に「このページの利用者は guard を通過できる状態か」を問い、分離は URL を変えない機構（route group 等）で行う。guard 外区画を作ったら配下の全ページを列挙して「guard 配下 or 完全一致 allowlist の guard 外」を強制する構造ゲートを置き、走査 0 件での偽合格を防ぐ下限 assert を併設する（MUST）— guard 外区画へ新しいページを足すと無言で認可が外れる。ソース走査はコメント除外で行う（`security/430_authorization_and_access_control.md` 参照）

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
- **The Disclosure UI Mount Protocol**: 展開 UI（オーバーレイ／パネル／項目）は常時マウントし、開閉は初期値固定 + アニメーショントグルで駆動する（MUST）。閉完了時は `visibility:hidden` + `inert`（または `pointer-events-none` / `tabIndex=-1`）で非描画化・hit-test / a11y ツリー除外する。重さの支配的コストは開くたびのマウント → 破棄（約 95 ノード）と blur の多重であり、マイクロ最適化（memo / GPU ヒント）では構造的な重さは解消しない。`design/000_design_ux.md` の「条件付きレンダリング優先」に対する但し書き（アニメーション遷移を持つ開閉 UI は常時マウント + 遷移トグル）
    - `backdrop-filter` は視覚差が実際に出る面に限定する（MUST）— 不透明度の高い色付き背景上の blur は効果ゼロでコストだけ発生する。モバイルでは全画面 blur を避け濃い調光で代替する（SHOULD）
    - body を `position: fixed` にするスクロールロックは全文書リフローを起こし、閉じた瞬間の同期解除は閉アニメの最初のフレームを食い潰す。解除は閉アニメの体感完了まで遅延し、遅延中の再オープンは予約キャンセルでロック継続、アンマウント時は即時解除（SHOULD）
    - ページ内スクロール演出はネイティブ `scrollTo({behavior:'smooth'})` を主経路にする（MUST）。rAF 駆動の自前イージングはメインスレッド実行のため遅延画像ロードやスクロールハンドラと競合してカクつく。JS 駆動は watchdog 後のフォールバック専用
    - 常時マウント化したリンクは不要な prefetch を明示的に止める（`visibility:hidden` でも IntersectionObserver は交差する）（SHOULD）。常時マウント後は `querySelector` が隠れた項目を拾い、プログラム `.click()` は `visibility:hidden` でも発火するため、検証は `aria-expanded` 等の状態属性で対象を特定する

### §261. The Micro-Interaction Protocol

- **Rule 33.262**: ボタンクリック、フォーム送信、状態変更等の主要UIイベントにマイクロインタラクション（0.1〜0.3秒の短いフィードバック）を実装する
- **Paint-Gated Choreography**: 展開直後の重い初回描画（リフロー・blur 初回描画）と重なるアニメーションは、経過時間ベースの遅延・spring では最初に描画できたフレームで既に終盤 = ポップインになる。発火は「初回フレームの描画コミット後」（double rAF）でゲートする（MUST）— 壁時計遅延は停滞を吸収できない。開閉は段階振付にする（SHOULD）: 開 = ゲート起点でオーバーレイ／パネルのフェード → 完了後に項目の展開、閉 = 項目収納 → 概ね収納後にフェードアウト → 完了後にロック解除。タイミング定数は SSOT に置き、段階間の順序不変条件（例: `OPEN_FADE ≤ ITEMS_BASE_DELAY`）をコメントで固定する（MUST）
    - モーションの質感が確立済みの UI では駆動エンジン（spring 等）を差し替えず「マウント方式だけ」を変える（SHOULD）— CSS bezier 近似は体感差で棄却されうる。非表示タブでは rAF が進まないため、検証はスクリーンショット取得でフレームを駆動し、中間状態（回転 + 中間座標）の捕捉をもって全区間再生の証拠とする（SHOULD）

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
- **Cross-Reference**: `security/200_oss_compliance.md`

---

## Part XLVII: サードパーティスクリプト管理 🌐

### §283. The Third-Party Script Isolation Protocol

- **Rule 33.284**: サードパーティスクリプト（Analytics、Chat、Ad等）はメインスレッドをブロックしてはならない。`next/script` の `lazyOnload` 戦略で遅延ロードする
- **Rule 33.284a（Visibility-Gated Mount）**: IntersectionObserver 等の交差判定は幾何のみを見る。`inert`・`visibility`・transform 途中・オフスクリーン配置のパネルも「交差」するため、交差判定を「ユーザーに見えている」の代替にしてはならない（MUST）— 交差判定は「近づいたか」の判定であって「見えるか」の判定ではない。開閉状態を UI が持つ面（ドロワー・タブ・アコーディオン・モーダル）に置く遅延ロード対象（広告・重い埋め込み・計測）は、その状態が「開いた」になってから初めてマウントする（MUST）。常時マウント + 非表示は第三者スクリプトの読込・課金・計測を隠れて発生させる（開かれていないメニューの広告枠が filled になっていた例）。「読み込み条件を判定する純関数」が正しくても「その関数を呼ぶ配線」が誤っていれば本番で誤動作するため、純関数のテストとは別に配線（マウント条件）を検査するテストを置き本番で実測する（MUST）

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
- **Absent-Key Semantics**: 列挙値の対応表は定義域を全部持つ定数として置き、範囲外は `undefined` を返すのではなく「対応が無い」と判断できる形にする（MUST）— 配列添字で引く実装は定義域が広がった瞬間に静かに壊れ、型検査・lint・build は通る。正本は `engineering/740_data_contracts.md` の「Rule 740.5.2a」。

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

- **Classification Mapping Totality Test**: 保存値の種別（type）を面ごとの大分類（family）へ振り分ける場合、対応表を SSOT に置き、「全 type がちょうど 1 つの family に属する」全域性・一意性をテストで固定する（MUST）— type を増やして分類漏れが起きると一覧から静かに消える。コンポーネントや DB クエリで種別リテラルを直書きした分岐（`type === 'x' || …`）を書かず、振り分け関数と許可集合定数を経由する（MUST NOT）。`satisfies never` の網羅検出を実行時の対応表にも延長する実務手段

### §329. The Data Invariant Protocol

- **Rule 33.323**: ビジネスクリティカルなデータの不変条件（Invariant）をフロントエンドでも検証する
- **Examples**: 在庫数 ≥ 0、価格 > 0、開始日 ≤ 終了日、合計金額 = 各明細の合計
- **Implementation**: `invariant()` ユーティリティ関数でランタイムチェックし、違反時は即座にエラーレポート

### §330. The Null Object Pattern Protocol

- **Rule 33.324**: DBレコードの未設定フィールドを `null` でコンポーネントに渡す代わりに、**Null Object パターン**でデフォルト値を持つオブジェクトに変換する
- **Benefit**: コンポーネント層での null チェック分岐を排除し、コードの可読性とテスタビリティを向上
- **DTO Layer**: API → DTO 変換時にNull Objectを生成する
- **The Single-Source Visible Label Protocol**: 利用者に見えるラベル（キャプション帯等）の値の出所は単一フィールドに固定し、別フィールド（note / annotation / title / alt）への暗黙フォールバック（`a ?? b ?? c`）を禁止する（MUST NOT）— 「空のはずの場所に別の文字が出る」乖離を生む。正本は `engineering/740_data_contracts.md` の「Rule 740.5.2b」。
- **The `a || b` Single-Fallback Display Trap**: フォールバック演算子は「どちらか片方があればよい」要件にのみ正しい。「両方見せたい」要件に流用すると、優先側が存在する限り劣後側が構造的に永久に不可視になり、データが揃っているほど症状が固定化する。表示系で `a || b` を使う場合、「b は a があるとき表示されなくてよいか」をレビュー観点として明示し（MUST）、併記要件は要素を分けて各々 `value && …` で描画する（MUST）

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
| `design/000_design_ux.md` | §1, §19, §21, §112, §259 |
| `engineering/000_engineering_standards.md` | §2, §96, §277 |
| `engineering/310_headless_cms.md` | §7 (ハードコーディング禁止) |
| `engineering/100_api_integration.md` | §140–§146, §250 |
| `engineering/200_supabase_architecture.md` | §89 (DB Query) |
| `ai/000_ai_engineering.md` | §116 (GEO), §187 |
| `ai/100_data_analytics.md` | §153 (Privacy Tracking) |
| `security/000_security_privacy.md` | §74, §145, §201–§206, §256 |
| `security/200_oss_compliance.md` | §5, §205, §282 |
| `product/500_growth_marketing.md` | §116 (GEO戦略), §151–§155 |
| `engineering/100_api_integration.md` | §140–§146, §250, §321–§324 |
