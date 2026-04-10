# Axiarch Rules — Master Index / マスター索引

> [!NOTE]
> **このファイルは `axiarch-rules/` ディレクトリ全体の詳細索引です。**
> 各ルールファイルの役割・概要を日本語と英語で記載しています。
>
> **This file is the detailed index for the entire `axiarch-rules/` directory.**
> It describes the role and summary of each rule file in both Japanese and English.

---

## 🇯🇵 日本語セクション

### 📋 ディレクトリ構成

```
your-project/
 ├── AGENTS.md                 ← 最高法規（行動指針）
 ├── .agents/
 │    └── rules/
 │         └── prompt_pointer.md  ← ポインター（目次・参照先はaxiarch-rules/）
 ├── axiarch-rules/
 │    ├── INDEX.md              ← 本ファイル（全体索引）
 │    ├── README.md             ← クイックリファレンス（リンク集・セットアップガイド）
 │    ├── compliance_matrix.md  ← 要件対照表
 │    ├── universal/            ← 不変ルール（憲法）
 │    │    ├── ja/              ← 日本語版
 │    │    │    ├── core/       ← 基盤哲学・憲法・通信規約
 │    │    │    ├── product/    ← 事業戦略・収益・成長・国際化
 │    │    │    ├── design/     ← デザイン・UX
 │    │    │    ├── engineering/ ← 技術実装全般
 │    │    │    ├── ai/         ← AI・データ・分析
 │    │    │    ├── operations/ ← 運用・SRE・CS・FinOps
 │    │    │    ├── security/   ← セキュリティ・法務・コンプライアンス
 │    │    │    └── quality/    ← テスト・QA
 │    │    └── en/              ← 英語版（同構造）
 │    └── blueprint/            ← プロジェクト固有ルール（法律）
 │         ├── ja/
 │         └── en/
 ├── axiarch-prompts/           ← 任意：プロンプト集
 │    ├── ja/
 │    │    ├── develop/         ← 開発・実行
 │    │    ├── audit/           ← 品質・整合性監査
 │    │    ├── govern/          ← コンプライアンス・ガバナンス
 │    │    └── operate/         ← インシデント・参入
 │    └── en/
 │         ├── develop/
 │         ├── audit/
 │         ├── govern/
 │         └── operate/
 └── src/                       ← プロジェクトコード
```

### 📄 ルートファイル

| ファイル | 説明 |
|---|---|
| [README.md](./README.md) | 全ルールモジュールへのリンク集。導入手順・初期セットアップガイドを含む。 |
| [compliance_matrix.md](./compliance_matrix.md) | ユーザーの要望がどのルールファイルでカバーされているかを証明する要件対照表。Universal（不変）と Blueprint（可変）の責務分離を定義。 |
| [LOADING_PROTOCOL.md](./LOADING_PROTOCOL.md) | AIが対話開始時に必ず実行すべき5ステップのルールロード手順。 |
| [CRYSTALLIZATION_PROTOCOL.md](./CRYSTALLIZATION_PROTOCOL.md) | AIがタスク完了時に教訓を自律的に記録・整理（結晶化）するためのプロトコル。 |

---

### 📚 Universal Rules（不変ルール / 憲法）

> **Status: Immutable（不変）** — 「憲法改正」の明示的指示がない限り編集禁止。

> Universal Rules はプロジェクトで使う可能性のある全技術領域のベストプラクティスライブラリです。AIは LOADING_PROTOCOL に従い、タスクに必要なファイルのみを選択的にロードします。使わない技術のルールが存在しても問題ありません。それ自体が、将来の採用時や未知の技術に直面したときの品質担保の源泉です。
>
> Universal Rules is a comprehensive best-practice library across all major technology domains. The AI selectively loads only what each task requires, following LOADING_PROTOCOL. Rules for technologies your project doesn't currently use cause no harm — they are there when you need them.

#### core/: 基盤哲学・憲法

| # | ファイル | 概要 |
|---|---|---|
| 000 | [000_core_mindset.md](./universal/ja/core/000_core_mindset.md) | **最上位の行動原則。** 優先順位の階層（セキュリティ > UX > 収益性 > DX）、ゼロ・トレランス、Headless First、SSOT原則、対症療法の禁止、Git/デプロイ禁止プロトコル、既存機能保護、回帰バグ防止など、全ルールの基盤。 |
| 100 | [100_governance.md](./universal/ja/core/100_governance.md) | 憲法の権威と不変性。憲法定義・基本原則、改正プロトコル、AI エージェント権限制御、監査・可観測性、マルチプロジェクト連邦制。 |
| 200 | [200_language_protocol.md](./universal/ja/core/200_language_protocol.md) | 言語プロトコル。三層言語モデル、コード言語規約、ドキュメント言語戦略、AIエージェント通信言語プロトコル。 |

#### product/: 事業戦略・収益・成長・国際化

| # | ファイル | 概要 |
|---|---|---|
| 000 | [000_product_strategy.md](./universal/ja/product/000_product_strategy.md) | プロダクト・ビジネス戦略。MVP→PMF、収益化モデル（フリーミアム/サブスクリプション）、ユニットエコノミクス、法務コンプライアンス、レビュー・信頼性システム（段階的信頼レベル・通報対応・UGC Rate Limit）、タグベース検索設計、インタラクティブエンジン。 |
| 300 | [300_revenue_monetization.md](./universal/ja/product/300_revenue_monetization.md) | 財務・収益化の詳細戦略。FinOps（コスト管理）、決済（Stripe）、ポイント経済圏、AIトークンエコノミクス、クーポン整合性、動的価格設計、価格A/Bテスト実験基盤、税務・インボイス制度。 |
| 500 | [500_growth_marketing.md](./universal/ja/product/500_growth_marketing.md) | グロース・マーケティング戦略。PLG（プロダクト主導型成長）、SEO/GEO（AI検索最適化）、オンボーディング、リテンション、広告フィード連携（ブランドセーフティ・Ads.txt）、OGP動的生成、ファーストパーティデータ、トラフィックリスク分散、KPI計測フレームワーク。 |
| 700 | [700_appstore_compliance.md](./universal/ja/product/700_appstore_compliance.md) | Apple App Store / Google Play のガイドライン準拠。IAP必須、プライバシーマニフェスト、ASO（ストア最適化）、申請前チェックリスト。 |
| 800 | [800_internationalization.md](./universal/ja/product/800_internationalization.md) | 国際化・多言語対応（i18n/L10n）。Unicode・CLDR・RTL設計、翻訳ワークフロー、リージョン別コンプライアンス。 |
| 100 | [100_market_validation.md](./universal/ja/product/100_market_validation.md) | 市場検証・PMF戦略（12パート・45セクション）**。Build Trap回避、JTBD・Pain Severity Scoring、TAM/SAM/SOM計算、Mom Testプロトコル、Hypothesis Log 管理、MVP類型（Concierge/Wizard of Oz/Landing Page/Pre-order）、Sean Ellis Test（≥40%）、Retention Curve分析、False PMF Signalプロトコル、Premature Scaling禁止（CB Insights 74%根拠）、Conjoint分析、Continuous Discovery（Teresa Torres）。逆引き索引・クロスリファレンス付き。 |
| 200 | [200_go_to_market.md](./universal/ja/product/200_go_to_market.md) | GTM戦略・ローンチ計画（10パート・38セクション）**。April Dunford Positioning Canvas、Category Creation、Messaging Hierarchy（3層）、ICP定義（B2B/B2C・YAMLスキーマ）、ICP Scoring Model（Tier 1/2/3）、PLG/SLG/MLG/CLGモーション比較・実装プロトコル、Product-Led Sales遷移条件、チャネル評価5軸、Product Huntプロトコル（Launch Day/Post-Launch）、Do Things That Don't Scale、初期顧客10社獲得プロトコル、GTM KPIダッシュボード（Acquisition/Activation/Revenue/Expansion層）、Smarketing（Sales+Marketing統合）。逆引き索引・クロスリファレンス付き。 |
| 400 | [400_pricing_strategy.md](./universal/ja/product/400_pricing_strategy.md) | 価格戦略（9パート・35セクション）**。Value-Based Pricing哲学、Van Westendorp PSM（最適価格帯計算）、Usage-based Value Metric選定基準（Twilio/Snowflake/Stripe事例）、Freemium制限設計原則、5ステップ価格設定プロセス、Conjoint Analysis（ARR≥1億円条件）、Tier設計（奇数・Goldilocks原則）、Decoy Pricing・Anchor Pricing設計、価格改定60日前通知プロトコル・Grandfather Clause、A/Bテスト倫理（geo/コホート分割・個人属性差別禁止）、エンタープライズ交渉：Anchor High・Floor Price・割引権限テーブル（AE≤10%〜CEO≤30%）、Multi-Year Contract設計、ARPA/NRR/Discount Rate KPI監視。逆引き索引・クロスリファレンス付き。 |
| 600 | [600_brand_strategy.md](./universal/ja/product/600_brand_strategy.md) | ブランド戦略（8パート・30セクション）**。Simon Sinek Golden Circle（Why→How→What）、Brand Pyramid（5層）、Brand Promise定義、Brand Personality（5形容詞）、Design Token管理（JSON Token階層）、Logo Usage Guidelines（WCAG AA対比要件含む）、Voice/Tone設計（不変Character vs 状況別Tone）、コピーライティング5原則・ボタンCTAルール、エラーメッセージ3要素設計、Touchpoint Map、Onboardingをブランド体験として設計、Delightの設計（ただしCore完了後のみ）、Brand Crisis対応5原則（24時間以内・Honest・Accountable）。逆引き索引・クロスリファレンス付き。 |
| 900 | [900_fundraising_ir.md](./universal/ja/product/900_fundraising_ir.md) | 資金調達・IR戦略（8パート・32セクション）**。Default Alive・Ramen Profitability哲学、調達アンチパターン3つ（Validation/Raise Max/Valutation Max）、ステージ別達成基準（Pre-seed〜Series C+）、調達タイミング12原則、ピッチデック標準15スライド構成・Narrative設計（Why Now→Problem→Solution→Traction→Vision）、Traction スライドのDo/Don't、Warm Intro優先戦略（Cold返信率<1%）、投資家フィット評価5軸（Thesis/Portfolio/Reputation/Board/Co-investment）、タームシート条件一覧・Red Flagリスト（Participating Preferred等）、Competing Offers FOMO戦略、Data Room構成（8カテゴリ）、DDでのProactive Disclosure原則、月次投資家レポート標準フォーマット（TL;DR付き）、Board Meeting運営プロトコル・Early Warning 24時間プロトコル。逆引き索引・クロスリファレンス付き。 |

#### design/: デザイン・UX

| # | ファイル | 概要 |
|---|---|---|
| 000 | [000_design_ux.md](./universal/ja/design/000_design_ux.md) | デザインとUX戦略。モバイルファースト、アクセシビリティ（WCAG 2.1 AA詳細基準・Image Alt Text）、アニメーション（60fps）、タッチターゲット、デザインシステム、Pixel Perfect基準、おもてなしUX（Input Normalization・ロケール入力補助）、エラーページ設計基準、エラーメッセージUX基準、Ghost Contentプロトコル、リッチ選択UI、IME対応、i18n準備基準。 |

#### engineering/: 技術実装全般

| # | ファイル | 概要 |
|---|---|---|
| 000 | [000_engineering_standards.md](./universal/ja/engineering/000_engineering_standards.md) | エンジニアリング基準（汎用）。**13パート・80セクション構成（2026-03-31改定）。** Security > Correctness > Maintainability > Performance > Development Speed 優先順位。Part I: コード品質（§1.0-§1.9: 命名規約、Omnichannel、Realism First、Structure First、Blueprint遵守、Zero Warnings、リファクタリング、Root Cause First、Config Impact Analysis、Codebase-as-Truth）。Part II: インフラ＆パフォーマンス（§2.0-§2.5: Golden Quad、読み取り最適化、Performance Budgets/CWV、アセット最適化、API-Free First、Centralized Storage）。Part III: DevSecOps（§3.0-§3.5: Zero Trust、Secrets Management、環境変数テンプレート同期・ドリフト防止、PII Scrubbing、**Software Supply Chain Security [NEW: SLSA/Sigstore/SBOM]**）。Part IV: 技術的負債（§4.0-§4.4: Sprint 20%返済、Tech Radar、Lockfile整合性、Dead Export検出、Ghost Feature Ban）。Part V: AIファースト開発（§5.0-§5.4: PDD、RAG最適化、AI Hygiene、**AI Code Review Governance [NEW]**、**LLM Context Optimization [NEW]**）。Part VI: Green Coding（§6.0-§6.2）。Part VII: ゼロバグ（§7.0-§7.3: Fix Twice）。Part VIII: 継続的学習（§8.0-§8.2: Crystallization）。Part IX: 互換性＆テスト（§9.0-§9.2）。Part X: Git（§10.0-§10.6: Trunk Based、Conventional Commits、IPv6 Deployment、Branch Hygiene、Migration Immutability、Zod Alignment）。Part XI: ドキュメント運用（§11.0-§11.2: Living Docs、README Standard）。Part XII: 品質プロトコル（§12.1-§12.12: Zero-Warning Lint、Code Review、CODEOWNERS、Git Hooks三層防御、SSOT Sync）。Part XIII: 高度アーキテクチャ（§13.1-§13.13: Trinity DTO統合、Client-Server Boundary、Service Layer、CQRS & Cache、Mutation Integrity統合、Type Safety、Error Handling Contract、Dead Code Cleanup、API Product、Auth & Access Control、Build & Deploy Verification、Migration Safety、Feature Flag Lifecycle）。逆引き索引。 |
| 100 | [100_api_integration.md](./universal/ja/engineering/100_api_integration.md) | API統合とマイクロサービス。RESTful設計、バージョニング、レート制限、エラーハンドリング、Server Action戻り値厳格化、安全失敗契約、CORSガバナンス、APIゲートウェイ使用量計測。 |


| # | ファイル | 概要 |
|---|---|---|
| 200 | [200_supabase_architecture.md](./universal/ja/engineering/200_supabase_architecture.md) | Supabaseアーキテクチャ戦略。60セクション・200+ルール。DB設計/RLS/Auth/Storage/Migration/Performance/Edge Functions/Realtime/Cron・Queues/Observability/pgvector・AI/Advanced Auth/Testing/Branching/PostgREST/CLI/Connection Pooling/Backup・DR/Rate Limiting/Vault/FDW/Data API Hardening/Multi-tenancy/pg_graphql/DB Functions・Triggers/Log Drain/Auth Hooks/Self-hosted・Email/SSR Integration/DB Extensions/Client SDK/Schema Design Patterns/Social Auth・SSO/Data Migration・Seeding/Multigres水平スケーリング/PostgreSQL 18(AIO・UUIDv7・Skip Scan)/Column-Level Security/Passkeys・Biometric Auth/MCP Server・AI統合/Security Advisor/テーブル別API制御/VPC・Private Link/Read Replicas/Project-scoped Roles/GitHub Actions CI/CD/Advisory Locks/Webhook署名検証/Database Partitioning/Full-Text Search・pg_trgm/AI生成SQL管理/型安全E2E/CDN・Edge Caching/コンプライアンス・データ主権/運用成熟度モデル。サービス別逆引き索引（Appendix A）付き。 |


| # | ファイル | 概要 |
|---|---|---|
| 300 | [300_web_frontend.md](./universal/ja/engineering/300_web_frontend.md) | Webフロントエンジニアリング（Next.js / React / TypeScript）。**49パート・300セクション・Rule 33.1–33.293**。哲学・コア原則（Server First・Security Priority・CWV Deployment Gate）、テクノロジースタック標準、App Routerアーキテクチャ（RSC・server-only・Env Fail Fast・Async API・PPR）、Server/Client境界（Leaf Component・DTO Interface）、Edge Computing/Middleware（Non-Blocking・CSP Worker）、UIコンポーネント設計（shadcn/ui・Design Tokens・Rich Selection）、CSSアーキテクチャ（Utility First・!important禁止・cn()・Z-Index階層・CSS Containment・Container Queries）、コンポーネント設計原則（Co-location・Barrel Export禁止・Static Component）、React Hooks（Order Guarantee・Dependency Protocol・Compiler Readiness）、React 19 新API（Actions・useOptimistic・useFormStatus・use()・React Compiler v1.0）、Hydration/SSR安定性、フォーム設計（React Hook Form + Zod・Schema-Driven・Three-Point Sync）、高度フォームパターン（Auto-Save・Dynamic Form・useFieldArray Guard・DnD Overlay）、入力UX（inputMode・NFKC・IME Guard・iOS Zoom Defense）、バリデーション/セキュリティ（Anti-Spam・Turnstile・DTO Boundary）、State Management（Server/Client分離・Zustand/Jotai・URL State）、Data Fetching/Cache（Parallel Fetch・Public Cache FinOps・Resilient RSC）、パフォーマンス最適化（CWV Deployment Gate・Bundle Budget・Dynamic Library Decoupling）、画像/フォント/スクリプト最適化（next/image・AVIF First・next/font・next/script）、SEO/Metadata・Technical SEO/GEO（Speculative Rules API・IndexNow・GEO Strategy）、アクセシビリティ（WCAG 2.2 AA・EAA 2025・axe-core CI）、PWA/クロスプラットフォーム、i18n、エラーハンドリング（Error Boundary・Graceful Degradation）、Server Actions/API安全性、データ可視化/エクスポート、AdTech/マーケティング、テスト戦略（Testing Trophy・Vitest・Playwright・Lighthouse CI・Storybook）、デプロイ/インフラ（Vercel・ISR・Edge Config・CDN）、モダンWeb Platform API（View Transitions・CSS Anchor Positioning・Popover API・@starting-style・CSS Grid Masonry）、フロントエンド可観測性/RUM（OpenTelemetry Browser SDK・Session Replay）、AI統合/LLMストリーミングUI、Micro-Frontend/Module Federation 2.0、Web Worker/Off-Main-Thread（Comlink）、フロントエンドセキュリティ深化（Trusted Types・SRI・CSP Strict Dynamic）、フロントエンドFinOps、デザインシステム統合（Design Token・cva・Theme Switching）、**[新規10パート]** 禁止アンチパターン30選、Monorepo & Multi-App戦略（Turborepo）、リアルタイム通信（WebSocket/SSE/WebTransport）、認証UI & セッション管理（Passkey・Edge Middleware Guard）、Animation & Motion Design、レスポンシブ & マルチデバイス（Fluid Typography・dvh）、E-Commerceフロントエンド（Cart UI・PCI DSS）、フロントエンドDevOps（ESLint Flat Config・Biome・Pre-commit）、サードパーティスクリプト管理（Partytown・Consent-Aware Loading）、Sustainability & Green Frontend（SCI測定）、成熟度モデル5段階・将来展望（WebAssembly・WebGPU・AI-Native Frontend・Edge-First Architecture）。逆引き索引・クロスリファレンス付き。 |
| 310 | [310_headless_cms.md](./universal/ja/engineering/310_headless_cms.md) | ヘッドレスCMS。**80パート・160セクション・131ルール構成**。CMS哲学（API-First・Content as Data・優先順位階層）、ヘッドレスアーキテクチャパターン、CMS選定・Composable DXP、コンテンツモデリング、Content Delivery/Management API、GraphQLガバナンス、Webhook、メディアストレージ、画像最適化、DAM統合、レンダリング戦略、CDN・エッジ配信、キャッシュ階層、リッチテキストエディタガバナンス、パブリッシングワークフロー、プレビュー戦略、動的ページビルダー、SEO自動化、AI-Readyコンテンツ、AI駆動オペレーション、Agentic CMS、CMSセキュリティ、コンテンツモデレーション、アクセシビリティ、多言語・翻訳ワークフロー、コンテンツパーソナライゼーション、Content as Code、CMS移行、リアルタイムコラボレーション、コンテンツA/Bテスト、Server-Driven UI、エディタ体験、CMSテスト戦略、コンテンツパイプライン自動化、マルチテナント、DR・BCP、規制コンプライアンス、GEO、Green IT、CMS可観測性・FinOps、成熟度モデル・アンチパターン40選。逆引き索引・クロスリファレンス付き。 |
| 400 | [400_mobile_flutter.md](./universal/ja/engineering/400_mobile_flutter.md) | モバイルエンジニアリング（Flutter）。**55パート・265セクション構成**。哲学・Supreme Directive（UX忠実度>パフォーマンス>セキュリティ>コード再利用>開発速度）、テクノロジースタック標準（Flutter 3.41+・Dart 3.7+・Riverpod 3.0+・Impeller GA）、アーキテクチャ原則（Clean Architecture・レイヤード・フィーチャーベース・DI・SSOT）、Dart 3.7+言語規約（sealed class・パターンマッチング・Wildcard Variables・Extension Types・Records・Null安全）、非同期処理・Isolate、コード生成（build_runner・Macros廃止・Augmentations展望）、状態管理（Riverpod 3.0+ GA・統合Notifier API・コード生成ファースト・@riverpod・ref.watch/read絶対規則・Ref.mounted安全チェック・select粒度制御・等価ベース更新・自動リトライ・Pause/Resume・Freezed不変状態・Mutations コード生成不要化・**riverpod_lint必須**）、高度なRiverpodパターン（依存チェーン・スコープ・AsyncValue・ProviderContainer.test）、オフライン永続化（Experimental・riverpod_sqflite）、GoRouterナビゲーション（宣言的ルーティング・認証ガード・ディープリンク・Universal Links・App Links）、Clean Architectureパターン（UseCase・Entity・DTO・DataSource・Repository・キャッシュ・ページネーション）、DI・環境別設定（Flavor）、パフォーマンス（120fps or Die・constコンストラクタ・リビルド抑制・RepaintBoundary・ListView.builder）、Impellerレンダリング（iOS唯一レンダラー・Skia完全削除・AndroidオプトアウトF非推奨化・**Impeller専用DevTools 2026メトリクス**）、Widget Tree最適化・Sliver API、起動最適化（コールドスタート2秒以内・アプリサイズ30MB以下・Tree Shaking・難読化）、メモリ管理・プロファイリング、オフラインファースト（Drift・SQLCipher・SSOT・同期キュー）、ネットワーク（Dio・VIP Lane戦略・Exponential Backoff・Bearer Token・リトライ）、画像/メディア（cached_network_image・WebP・SVG・動画）、リアルタイム通信（WebSocket・SSE・Supabase Realtime）、プラットフォーム忠実度（Cupertino/Material使い分け・Cupertino Squircles・Pigeon型安全Platform Channel・FFI・ハプティクス）、レスポンシブ/アダプティブUI（AdaptiveScaffold）、Material 3デザインシステム（Design Token・テーマ・ダークモード）、アニメーション（Lottie・Rive・遷移）、フォーム・バリデーション・IME・検索、アクセシビリティ（**WCAG 2.2 AA**・Semantics・SemanticsRole API・TalkBack/VoiceOver・48dp最小タップ・**EU Accessibility Act 2025**）、セキュリティ（**OWASP MASVS Control Groups**・flutter_secure_storage・Certificate Pinning・--dart-define秘密管理）、RASP（freeRASP・Root/Jailbreak/改竄/エミュレータ検出）、AI・ML（ML Kit・TFLite・Gemini・AIエージェント）、テスト戦略（テストピラミッド・Golden Test・Maestro E2E・**patrol E2E新標準**・**alchemist Golden Test強化**・MobSF・カバレッジDomain90%/Data80%）、CI/CD・デプロイ（Fastlane・Firebase App Distribution・Shorebird OTA・デュアルトラック・**ロックファイル永続化**・**fastlane-plugin-shorebird**・段階的ロールアウト）、可観測性（Crashlytics/Sentry・Firebase Performance・Analytics・Remote Config）、マルチプラットフォーム（Flutter Web・Web Hot Reload・WebAssembly・Desktop・SBOM・Melos）、ガバナンス（i18n・プライバシー・App Store/Google Playコンプライアンス・グリーンエンジニアリング）、プッシュ通知アーキテクチャ（FCM/APNs・通知ペイロード・タップハンドリング・**flutter_local_notifications統合**・**冪等性message_id**）、認証・App Check（生体認証local_auth・Firebase App Check・ランタイム権限管理・**Passkeys/FIDO2**）、アプリライフサイクル・バックグラウンド処理（AppLifecycleListener・WorkManager・フォアグラウンドサービス）、IAP・アプリ更新（In-App Purchase・強制アップデート・アプリレビュー促進）、**[新規Part S]** Dart FFI・Native Interop深化（dart:ffi・JNI・jnigen・Swift Interop・Native Build統合）、決済統合アーキテクチャ（Stripe・RevenueCat・PCI DSS・3DS・Apple Pay/Google Pay・Entitlementベース設計・税金通貨管理）、ローカル通知・スケジューリング（flutter_local_notifications・タイムゾーン対応・通知アクション・Deep Link連携）、ウィジェットテスト深化（Golden Test戦略・alchemist・インタラクションテスト・テストマトリクス・ビジュアルリグレッションCI）、エラーバウンダリ・Recovery UX（エラー分類4段階・ErrorBoundary Widget・Recovery UXパターン・クラッシュ後復旧）、Connectivity・ネットワークレジリエンス（connectivity_plus・オフラインキュー・リトライ戦略・Circuit Breaker・帯域適応）、アプリ内ナビゲーションUX設計（Bottom Navigation・BottomSheet・Drawer・ページ遷移・OverlayPortal）、構成管理・Feature Flag深化（Firebase Remote Config・段階的ロールアウト・キルスイッチ・技術的負債管理・緊急統制）、データプライバシー・同意管理深化（CMP・TCF 2.0・ATT・データ主体権利・プライバシーテスト）、モバイルDevOps・DX（FVM・build_runner最適化・Hot Reload・DevTools拡張・PR品質ゲート・ADR・Widget Catalog）、言語固有補遺・拡張アンチパターン（Dart 3.7+最新機能・メモリリーク防止・型安全パターン・コード品質メトリクス・CI自動化拡張）、成熟度モデル5段階・**アンチパターン50選**・FinOps基準値・将来展望（GenUI SDK・Impeller Desktop/Web・Dart Augmentations）。逆引き索引・クロスリファレンス付き。 |
| 410 | [410_native_platforms.md](./universal/ja/engineering/410_native_platforms.md) | ネイティブプラットフォーム（Kotlin/Swift）。**20パート・80セクション構成**。Kotlin 2.x（K2コンパイラ・Guard Conditions・Sealed）、Swift 6（Strict Concurrency・Sendable・Actor・Typed Throws）、Androidアーキテクチャ（Jetpack Compose・MVI・Hilt・マルチモジュール）、iOSアーキテクチャ（SwiftUI・MVVM/TCA・SwiftData・Privacy Manifest・App Intents・WidgetKit）、KMP（commonMain最大化・Swift Export・段階的導入）、Jetpack Compose性能（Pausable Composition・Baseline Profiles・Strong Skipping）、SwiftUI（Preview-Driven・@Observable）、並行処理（Coroutines/Flow・Swift Concurrency・WorkManager・BGTaskScheduler）、パフォーマンス（起動500ms・120fps・HTTP/3・バッテリー最適化）、オンデバイスAI（Core ML・ML Kit・TFLite・MediaPipe・モデルOTA）、オフラインファースト（Room・SwiftData・SSOT・Delta Sync）、セキュリティ（No Secrets in Binary・RASP・Passkeys FIDO2・Play Integrity・App Attest・Certificate Pinning）、OS機能（Push・Deep Links・Widget・Bridge）、Flutter連携（Pigeon必須）、テスト（JUnit5・Swift Testing・Maestro・Macrobenchmark）、CI/CD（Staged Rollout）、アクセシビリティ（VoiceOver/TalkBack・WCAG 2.1 AA）、可観測性（Crashlytics・OpenTelemetry Mobile）、FinOps（ビルド15分以内・App Size 30MB以下）、成熟度モデル5段階・アンチパターン20選。逆引き索引・クロスリファレンス付き。 |


| # | ファイル | 概要 |
|---|---|---|
| 500 | [500_firebase_gcp.md](./universal/ja/engineering/500_firebase_gcp.md) | バックエンドエンジニアリング（Firebase & GCP）。55パート・Rule 32.1〜32.169 + Appendix A〜D構成。Supreme Directives（補助エンジン原則・多層防御・冪等性・FinOps Guardian・Cloud Run統一）、Cloud Run Functions/Services/Jobs/GPU、Eventarc/Pub/Sub/Cloud Tasks、Firebase Auth（Passkeys/FIDO2）、App Check、Firestore（Enterprise Edition/Named Databases/MCP Server）、Data Connect、Cloud Storage、Firebase Hosting/App Hosting（GA）、FCM（HTTP v1 API）、Remote Config、Crashlytics、Performance Monitoring、Analytics、Firebase AI Logic/Genkit（Node.js GA/Go GA/Python Alpha）、Vertex AI/Agent Engine（A2A）、AI Agent セキュリティ & ガバナンス（MCP連携・EU AI Act）、BigQuery連携、セキュリティ多層防御（Zero Trust/OWASP 2025/Cloud Armor WAF）、IAM/WIF、Secret Manager（CMEK）、VPC（Direct VPC Egress/Private Service Connect）、FinOps & コスト最適化（AI FinOps・30%ルール）、予算アラート & 自動応答、Observability（OpenTelemetry）、エラーハンドリング（Circuit Breaker/DLQ）、Terraform/IaC、Firebase CLI、Emulator Suite、CI/CD（GitHub Actions/WIF）、環境管理、マルチリージョン & DR、API設計、Rate Limiting、キャッシング、バッチ処理 & データパイプライン、Google Maps最適化、Google Ecosystem統合、Firebase Studio、コンプライアンス（GDPR/CCPA等）、サプライチェーンセキュリティ（SBOM/Binary Authorization）、運用成熟度モデル（L1〜L5）、マイグレーション & 廃止、トラブルシューティング、言語固有セクション（Node.js TS/Go/Python）、アンチパターン30選、将来展望。 |
| 510 | [510_aws_cloud.md](./universal/ja/engineering/510_aws_cloud.md) | AWSクラウドアーキテクチャ戦略。155セクション・240+ルール・15コードスニペット。Well-Architected基盤から全主要AWSサービスまで網羅（Lambda Durable Functions/AWS Interconnect/EKS Capabilities/Amazon Nova/VPC Encryption Controls/Data Perimeter/Passkey FIDO2/Outposts Gen2/Amazon Transform/Green Insights/Shield AI/成熟度モデル&アンチパターン20選含む）。サービス別逆引き索引（Appendix A）付き。 |

#### ai/: AI・データ・分析

| # | ファイル | 概要 |
|---|---|---|
| 000 | [000_ai_engineering.md](./universal/ja/ai/000_ai_engineering.md) | AI実装とUX戦略（48パート・150+セクション）。AI哲学・UXパターン（Chat/Copilot/Agent/Ambient/Proactive）、倫理・ガバナンス（EU AI Act準拠・グローバル規制マッピング・バイアス公平性）、コアアーキテクチャ（Private Relay・Model Router・Structured Output・ストリーミング・セマンティックキャッシング・プロンプトインジェクション多層防御）、RAGアーキテクチャ（GraphRAG・Hybrid Search・Reranking・評価フレームワーク）、Agentic AI（L1-L5自律性分類・MCP/A2A Protocol・マルチエージェント）、ガードレール多層モデル・ハルシネーション対策・Kill Switch、AI FinOps（30%ルール・トークン最適化）、マルチモーダル・エッジAI、LLMOps（PromptOps・モデルライフサイクル・LLM-as-Judge・AI可観測性）、成熟度モデル・アンチパターン20選。 |
| 100 | [100_data_analytics.md](./universal/ja/ai/100_data_analytics.md) | 分析インテリジェンスとオブザーバビリティ（60パート/206セクション）。Event Taxonomy、プロダクトアナリティクス（NSM/AARRR）、A/Bテスト統計プロトコル（Bayesian/CUPED/Causal AI連携/Adaptive Experimentation）、プライバシーファースト分析（Privacy Sandbox廃止対応/IPA/データクリーンルーム）、GA4/BigQuery AI連携、CDP/ID統合、KPI/指標ガバナンス、ダッシュボード品質基準、Observability 5本柱（+Profiling）、OpenTelemetry 2026、分散トレーシング、RED/USEメトリクス、構造化ログ、Continuous Profiling、RUM/CWV/INP最適化、Synthetic Monitoring、APM、SLO駆動可観測性、AIOps 2.0/Agentic Observability、LLM/GenAI可観測性、データパイプライン可観測性、データ品質6次元、セキュリティ可観測性、コスト可観測性/FinOps Cloud+、Observability as Code、成熟度モデル・アンチパターン25選。 |

#### operations/: 運用・SRE・CS・FinOps

| # | ファイル | 概要 |
|---|---|---|
| 000 | [000_internal_tools.md](./universal/ja/operations/000_internal_tools.md) | 管理運用と内部ツール。**50パート・231セクション・221ルール構成**。Supreme Directive「管理ツールは二級市民ではない」、Admin Excellence Culture、Build vs Buy戦略、管理ツールアーキテクチャ、管理ダッシュボード設計、UI/UX基準・Admin デザインシステム、アクセシビリティ、認証・認可アーキテクチャ（RBAC/ABAC/MFA/JITアクセス/Passkey）、セキュリティ強化（Zero Trust）、データプライバシー・GDPR管理画面対応、不変監査ログ、ユーザー管理、コンテンツ管理、ワークフロー自動化エンジン、AI統合・インテリジェント管理（Agentic AI L1-L5）、コンプライアンス自動化・GRC、FinOps、成熟度モデル5段階・アンチパターン20選。逆引き索引・クロスリファレンス付き。 |
| 300 | [300_customer_experience.md](./universal/ja/operations/300_customer_experience.md) | ユーザーサポートとカスタマーサクセス（**40パート**・160+セクション）。サポート哲学、AIエージェント戦略（Agentic AI L1-L5/AI Copilot/MCP・A2A統合）、オムニチャネル設計、チケット管理・SLA、カスタマーサクセス戦略、Customer Health Score、オンボーディング設計、解約防止・リテンション、VoC・フィードバックループ、コンプライアンス・規制対応、Voice AI・会話型サポート、成熟度モデル（L1-L5）・逆引き索引。 |
| 400 | [400_site_reliability.md](./universal/ja/operations/400_site_reliability.md) | SREと信頼性エンジニアリング。**55パート・166セクション構成**。Supreme Directive「Hope is not a strategy / Slow is the New Down」、SLI/SLO/SLA・エラーバジェット、可観測性（5本柱）、インシデント管理、デプロイメント戦略、カオスエンジニアリング、レジリエンスパターン、IaC・GitOps、Platform Engineering、AIOps（Agentic AI SRE L1-L5）、マルチリージョンDR、成熟度モデル・アンチパターン。逆引き索引・クロスリファレンス付き。 |
| 500 | [500_incident_response.md](./universal/ja/operations/500_incident_response.md) | 危機管理とBCP（事業継続計画）。31パート構成。ISO 22301/NIST CSF 2.0/DORA準拠、BIA、インシデント対応体制、サイバーインシデント対応、AI駆動脅威対応、危機コミュニケーション、BCP・DR戦略、Blamelessポストモーテム、ガバナンス・RACI・KPI、成熟度モデル（5段階）。逆引き索引付き。 |
| 100 | [100_sales_bizdev.md](./universal/ja/operations/100_sales_bizdev.md) | 営業・ビジネス開発（10パート・38セクション）**。Challenger Sale哲学（Teach/Tailor/Take Control）、Value Selling vs 機能説明禁止、Sales Funnel 8ステージ（MQL→SQL→SAL→Opportunity→Proposal→Negotiation→Closed）、MEDDIC資格確認フレームワーク（Champion3条件含む）、MEDDIC CRMスコアリング実装例、Cold Email 5要素200文字以内設計、5タッチシーケンス設計、Anti-Spam法令遵守（CAN-SPAM/GDPR/特定電子メール法）、デモ構成5ステップ・Discovery必須ヒアリング6項目、デモ禁止事項リスト、提案書8構成・PoC成功基準必須プロトコル（30日制限）、Mutual Close Plan、Win/Loss 6分類分析、Sales Playbook必須コンテンツ8項目、新入AE30日onboardingプログラム、BizDevとSalesの責任分界、パートナー評価フレームワーク（25点満点≥15点基準）、Technology Partnership設計原則。逆引き索引・クロスリファレンス付き。 |
| 200 | [200_hr_organization.md](./universal/ja/operations/200_hr_organization.md) | 採用・組織設計（9パート・34セクション）**。Talent Density最大化（Netflix）、A PlayerはA Playerを採用原則、採用判断優先順位4層（Values>Learning>Attitude>Skills）、バーレイザーシステム（Amazon）、JD品質基準6セクション・YAMLロール定義テンプレート、報酬哲学（P75以上・給与バンド）、採用ファネル4週間以内完了・禁止事項（10ステップ超）、Referral Program設計、Structured Interview（全員同一質問）、STAR/ケース/Values/BackchannelReference組み合わせ、Debrief 4ルール（HiPPO禁止）、無意識の偏見4種と防止策、Verbal Offer First原則、90日Onboardingプログラム（Day1完全セットアップ必須）・Buddy制度、OKR設計原則（70%達成=良・全社公開義務）、1on1週1回30分・Listening Mode義務、Performance Review 3次元（What/How/Potential）・サプライズ禁止、Conway's Law対応、Team Topologies 4タイプ（Stream-Aligned/Enabling/Complicated/Platform）、管理範囲5〜8名上限、Remote-First 5原則（Async First/Doc First/Timezone Respect/Camera On/IRL Quarterly）。逆引き索引・クロスリファレンス付き。 |
| 700 | [700_partnership_ecosystem.md](./universal/ja/operations/700_partnership_ecosystem.md) | パートナー・エコシステム戦略（9パート・34セクション）**。パートナーシップ3目的（Market Access/Product Extension/Credibility）・5類型（Technology/Channel/Strategic/Marketplace/Reseller）、Partnership Theaterアンチパターン定義、Ecosystem Flywheel設計（Salesforce AppExchange 7,000+アプリ事例）、Partnership Maturity Model5段階（Ad-hoc→Managed→Scalable→Ecosystem→Platform）、Coopetition管理原則、Integration Tier 3段階（Premier/Select/Registered）管理・統合品質基準YAMLスキーマ（OAuth2.0・HMAC署名必須）・廃止6ヶ月タイムライン、チャネルパートナー15〜30%マージン設計・Deal Registration5日以内登録・Channel Conflict防止ルール、戦略的アライアンス5条件・Joint GTM 5要素・四半期KPI評価、Developer Portal 8必須要素・Sandbox・Changelog、Indirect Network Effects設計、Partner Success 3指標（Activation/Productivity/NPS≥50）・パートナーライフサイクル管理・契約必須条項8項目、Marketplace構築判断基準（MAU≥50,000・Dev1,000+）・他社Marketplace掲載戦略・Revenue Sharing業界標準比較（Shopify/Apple/Google）。逆引き索引・クロスリファレンス付き。 |
| 600 | [600_cloud_finops.md](./universal/ja/operations/600_cloud_finops.md) | Cloud FinOps — クラウドコスト最適化 & 財務運用。**25パート・57セクション構成**。FinOps Foundation Framework 2026（Cloud+ Scope）準拠。FOCUS v1.3仕様。FinOps哲学・6原則、CoE組織モデル、Executive Strategy Alignment、コスト可視化・配賦（Showback/Chargeback）、タギング標準、ユニットエコノミクス、ライトサイジング、コミットメント戦略（RI/SP/CUD）、Spot/Graviton戦略、ストレージ階層化、ネットワーク/Egress最適化、サーバーレスFinOps、DB FinOps（RDS/Aurora/DynamoDB/BigQuery）、AI/ML FinOps（30%ルールサーキットブレーカー）、Agentic AI FinOps（L1-L5成熟度・自律的最適化・OpenCost MCP Server）、LLMコスト最適化（モデルルーティング・セマンティックキャッシング・蒸留）、GPU/TPU最適化（MIG/MPS・Spot GPU）、K8s FinOps（OpenCost/Kubecost・VPA/HPA/KEDA・マルチテナント配賦）、SaaS/ライセンス管理（ITAM統合）、予算・予測・異常検知（ML駆動・多段階アラート）、Cloud Bankruptcy Prevention（多層防御・DDoSコスト攻撃対策）、Policy-as-Code（OPA/Sentinel/Kyverno・Governance-as-Code）、IaCコスト統合（Infracost・PRレビュー基準・ガードレール）、CDN/Edge/IoT FinOps、データパイプラインFinOps（ETL/ストリーミング）、マルチクラウド/マルチアカウント（FOCUS統合）、FinOps×Platform Engineering（Backstage統合・Golden Path）、セキュリティコスト最適化、GreenOps・サステナビリティ（SCI計算・carbon-aware-sdk・EU CSRD/SEC対応）、言語固有セクション（TypeScript/Terraform/Python/Go）、成熟度モデル5段階・ツールエコシステム・アンチパターン30選・将来展望。逆引き索引・クロスリファレンス付き。 |

#### security/: セキュリティ・法務・コンプライアンス

| # | ファイル | 概要 |
|---|---|---|
| 000 | [000_security_privacy.md](./universal/ja/security/000_security_privacy.md) | セキュリティとプライバシー。**22セクション構成**。ゼロトラスト7柱（NIST 800-207準拠）、認証・認可（FIDO2/Social Login/Session管理）、APIセキュリティ（BOLA/BFLA/SSRF防止）、サプライチェーン（SBOM/SLSA）、AI/LLMセキュリティ（OWASP LLM Top 10 2025）、コンテナセキュリティ（Pod Security Standards/イメージ署名）、暗号化ポリシー（PQC準備）、OWASP Top 10 2025、GraphQL、シークレット管理、クライアントサイドセキュリティ、ボット/DDoS防御、セキュリティガバナンス。逆引き索引付き。 |
| 100 | [100_data_governance.md](./universal/ja/security/100_data_governance.md) | 法務・ガバナンス・データ戦略。**45セクション構成**。グローバル規制マッピング（GDPR/CCPA/EU AI Act等14法）・2025-2027タイムライン・越境移転・同意管理・データガバナンス成熟度・RegTech自動化・量子暗号アジリティ。逆引き索引付き。 |
| 200 | [200_oss_compliance.md](./universal/ja/security/200_oss_compliance.md) | ライセンスと依存関係管理。**49セクション・280+ルール・40+コードスニペット**。ライセンス三層分類・SBOM（CycloneDX 1.6/SPDX 3.0）・サプライチェーンセキュリティ（SLSA v1.1/Sigstore）・SCAツール統合・自動更新戦略・成熟度モデル。逆引き索引付き。 |
| 300 | [300_ip_due_diligence.md](./universal/ja/security/300_ip_due_diligence.md) | 知的財産とExit戦略。**50セクション・10パート構成**。IP所有権・特許戦略・営業秘密・商標・著作権・AI生成物IP・Exit戦略・DD実務・ガバナンス・コンプライアンス。逆引き索引付き。 |

#### quality/: テスト・QA

| # | ファイル | 概要 |
|---|---|---|
| 000 | [000_qa_testing.md](./universal/ja/quality/000_qa_testing.md) | QAとテスト戦略。**40セクション・12パート構成**。テスト哲学、テスト種別（静的/ユニット/統合/コントラクト/E2E/VRT/パフォーマンス/Property-Based/ミューテーション/a11y）、セキュリティ、テスト品質、CI/CD、リリース、ドメイン固有、レジリエンス、AI駆動テスト、データ&API品質、コンプライアンス&可観測性、成熟度モデル5段階。逆引き索引付き。 |

---


> **Status: Mutable（可変）** — プロジェクトのコンテキストに応じて作成・編集可能。
>
> Blueprint配下のファイル一覧・カテゴリ構成・運用ガイドは **Blueprint専用INDEX** を参照してください:
> - 🇯🇵 **[blueprint/ja/INDEX.md](./blueprint/ja/INDEX.md)** — 日本語版Blueprint索引
> - 🇺🇸 **[blueprint/en/INDEX.md](./blueprint/en/INDEX.md)** — English Blueprint Index
>
> ※ 新しいBlueprintファイルの追加・管理はBlueprint専用INDEXで行うため、本ファイル（マスターINDEX）の書き換えは不要です。

---

### 🎯 プロンプト集（任意）

> **Status: Optional（任意）** — AIエージェントに高品質なタスクを実行させるための再利用可能なテンプレート集。プロジェクトの要件に合わせてカスタマイズ可能。

| ディレクトリ | 概要 |
|---|---|
| `../axiarch-prompts/ja/develop/` | 開発・実行系プロンプト（`feature_development.md`、`refactoring_audit.md`、`push_execute.md`、`ci_fix.md`）。AIエージェントのチャットに直接貼り付けて使用する。 |
| `../axiarch-prompts/ja/audit/` | 品質・整合性監査系プロンプト（`fullstack_qa_audit.md`、`api_architecture_audit.md`、`data_integrity_audit.md`、`system_integrity_audit.md`、`deep_optimization_audit.md`）。 |
| `../axiarch-prompts/ja/govern/` | コンプライアンス・ガバナンス系プロンプト（`governance_auditor.md`、`constitution_compliance_audit.md`、`compliance_inspector_audit.md`、`blueprint_governance_audit.md`、`localization_audit.md`）。 |
| `../axiarch-prompts/ja/operate/` | インシデント・参入系プロンプト（`onboarding_audit.md`、`incident_response.md`）。 |

---
---

## 🇺🇸 English Section

### 📋 Directory Structure

```
your-project/
 ├── AGENTS.md                 ← Supreme Law (behavioral guidelines)
 ├── .agents/
 │    └── rules/
 │         └── prompt_pointer.md  ← Pointer (TOC — references axiarch-rules/)
 ├── axiarch-rules/
 │    ├── INDEX.md              ← This file (master index)
 │    ├── README.md             ← Quick reference (links & setup guide)
 │    ├── compliance_matrix.md  ← Compliance matrix
 │    ├── universal/            ← Immutable rules (constitution)
 │    │    ├── ja/              ← Japanese version
 │    │    └── en/              ← English version
 │    └── blueprint/            ← Project-specific rules
 │         ├── ja/
 │         └── en/
 ├── axiarch-prompts/           ← Optional: Prompt Library
 │    ├── ja/
 │    │    ├── develop/         ← Development & Execution
 │    │    ├── audit/           ← Quality & Integrity Auditing
 │    │    ├── govern/          ← Compliance & Governance
 │    │    └── operate/         ← Incident Response & Onboarding
 │    └── en/
 │         ├── develop/
 │         ├── audit/
 │         ├── govern/
 │         └── operate/
 └── src/                       ← Your project code
```

### 📄 Root Files

| File | Description |
|---|---|
| [README.md](./README.md) | Link collection to all rule modules. Includes setup and initialization guide. |
| [compliance_matrix.md](./compliance_matrix.md) | Compliance matrix proving which rule files cover each user requirement. Defines the separation between Universal (immutable) and Blueprint (mutable). |
| [LOADING_PROTOCOL.md](./LOADING_PROTOCOL.md) | The 5-step rule loading protocol that the AI MUST execute at the start of any conversation. |
| [CRYSTALLIZATION_PROTOCOL.md](./CRYSTALLIZATION_PROTOCOL.md) | The protocol for the AI to autonomously record and organize (crystallize) lessons upon task completion. |

---

### 📚 Universal Rules (Immutable / Constitution)

> **Status: Immutable** — DO NOT edit unless explicitly instructed to "Amend Constitution".

#### core/: Core & Mindset

| # | File | Summary |
|---|---|---|
| 000 | [000_core_mindset.md](./universal/en/core/000_core_mindset.md) | **Supreme behavioral principles.** Priority hierarchy (Security > UX > Profitability > DX), Zero Tolerance, Headless First, SSOT principle, band-aid solution ban, Git/deployment ban protocol, existing functionality protection, regression ban. |
| 100 | [100_governance.md](./universal/en/core/100_governance.md) | Constitutional authority and immutability. Constitution definition, core principles, amendment protocol, AI Agent authority control, auditing & observability, multi-project federation. |
| 200 | [200_language_protocol.md](./universal/en/core/200_language_protocol.md) | Language protocol. Three-layer language model, code language conventions, document language strategy, AI Agent communication language protocol. |

#### product/: Business & Growth

| # | File | Summary |
|---|---|---|
| 000 | [000_product_strategy.md](./universal/en/product/000_product_strategy.md) | Product & business strategy. MVP→PMF, monetization models (freemium/subscription), unit economics, legal compliance, review/trust system (progressive trust levels, user reports, UGC rate limits), tag-based search design, interactive engine. |
| 300 | [300_revenue_monetization.md](./universal/en/product/300_revenue_monetization.md) | Finance & monetization details. FinOps (cost management), payments (Stripe), point economy, AI token economics, coupon integrity, dynamic pricing, pricing A/B test framework, tax/invoice compliance. |
| 500 | [500_growth_marketing.md](./universal/en/product/500_growth_marketing.md) | Growth & marketing strategy. PLG (Product-Led Growth), SEO/GEO (AI search optimization), onboarding, retention, ad feeds (brand safety, ads.txt), dynamic OGP, first-party data, traffic risk diversification, KPI measurement framework. |
| 700 | [700_appstore_compliance.md](./universal/en/product/700_appstore_compliance.md) | Apple App Store / Google Play guideline compliance. IAP mandate, privacy manifests, ASO (App Store Optimization), pre-submission checklist. |
| 800 | [800_internationalization.md](./universal/en/product/800_internationalization.md) | Internationalization & localization (i18n/L10n). Unicode, CLDR, RTL design, translation workflows, region-specific compliance. |
| 100 | [100_market_validation.md](./universal/en/product/100_market_validation.md) | Market Validation & PMF Strategy (12 Parts · 45 Sections)**. Build Trap avoidance, Jobs-to-be-Done (JTBD) framework, Pain Severity Scoring, TAM/SAM/SOM calculation, Mom Test protocol, Hypothesis Log management, MVP types (Concierge/Wizard of Oz/Landing Page/Pre-order/Fake Door), Sean Ellis Test (≥40%), Retention Curve analysis, False PMF Signal protocol, Premature Scaling ban (CB Insights 74% evidence), Conjoint Analysis, Continuous Discovery (Teresa Torres / Opportunity Solution Tree). Quick reference index & cross-references. |
| 200 | [200_go_to_market.md](./universal/en/product/200_go_to_market.md) | GTM Strategy & Launch (10 Parts · 38 Sections)**. April Dunford Positioning Canvas, Category Creation strategy, Messaging Hierarchy (3 layers), ICP definition (B2B/B2C YAML schema), ICP Scoring Model (Tier 1/2/3), PLG/SLG/MLG/CLG motion selection & implementation protocols, Product-Led Sales transition criteria, 5-axis channel evaluation, Product Hunt protocol (pre-launch/launch day/post-launch), Do Things That Don't Scale, First 10 Customers protocol, GTM KPI Dashboard (Acquisition/Activation/Revenue/Expansion layers), Smarketing (Sales+Marketing integration). Quick reference index & cross-references. |
| 400 | [400_pricing_strategy.md](./universal/en/product/400_pricing_strategy.md) | Pricing Strategy (9 Parts · 35 Sections)**. Value-Based Pricing philosophy, Van Westendorp PSM (optimal price range calculation), Usage-based Value Metric selection criteria (Twilio/Snowflake/Stripe examples), Freemium limitation design principles, 5-step pricing process, Conjoint Analysis (ARR ≥ $1M condition), Tier design (odd numbers, Goldilocks principle), Decoy Pricing & Anchor Pricing design, 60-day pre-notification price change protocol & Grandfather Clause, A/B test ethics (geo/cohort splits, personal attribute discrimination prohibited), Enterprise negotiation: Anchor High, Floor Price, discount authority table (AE≤10% to CEO≤30%), Multi-Year Contract design, ARPA/NRR/Discount Rate KPI monitoring. Quick reference index & cross-references. |
| 600 | [600_brand_strategy.md](./universal/en/product/600_brand_strategy.md) | Brand Strategy (8 Parts · 30 Sections)**. Simon Sinek Golden Circle (Why→How→What), Brand Pyramid (5 layers), Brand Promise definition, Brand Personality (5 adjectives), Design Token management (JSON Token hierarchy), Logo Usage Guidelines (WCAG AA contrast requirement), Voice/Tone design (immutable Character vs situational Tone), Copywriting 5 principles & button CTA rules, Error message 3-component design, Touchpoint Map, Onboarding as brand experience design, Designing Delight (only after core is complete), Brand Crisis 5-principle response protocol (24h / Honest / Accountable). Quick reference index & cross-references. |
| 900 | [900_fundraising_ir.md](./universal/en/product/900_fundraising_ir.md) | Fundraising & Investor Relations (8 Parts · 32 Sections)**. Default Alive & Ramen Profitability philosophy, 3 fundraising anti-patterns (Validation/Raise Max/Valuation Max), stage-by-stage benchmarks (Pre-seed to Series C+), fundraising timing 12-month rule, 15-slide pitch deck standard & Narrative design (Why Now→Problem→Solution→Traction→Vision), Traction slide Do/Don't, Warm Intro priority strategy (cold <1% response rate), Investor Fit 5-axis evaluation (Thesis/Portfolio/Reputation/Board/Co-investment), term sheet conditions & Red Flag list (Participating Preferred etc.), Competing Offers FOMO strategy, Data Room structure (8 categories), DD Proactive Disclosure principle, monthly investor report standard format (with TL;DR), Board Meeting protocol & Early Warning 24-hour protocol. Quick reference index & cross-references. |

#### design/: Design & UX

| # | File | Summary |
|---|---|---|
| 000 | [000_design_ux.md](./universal/en/design/000_design_ux.md) | Design & UX strategy. Mobile-first, accessibility (WCAG 2.1 AA detailed criteria, image alt text), animations (60fps), touch targets, design system, Pixel Perfect standards, Hospitality UX (input normalization, locale input assistance), error page design, error message UX, Ghost Content protocol, rich selection UI, IME handling, i18n readiness. |

#### engineering/: Engineering Implementation

| # | File | Summary |
|---|---|---|
| 000 | [000_engineering_standards.md](./universal/en/engineering/000_engineering_standards.md) | Engineering Standards (General). **13-part, 80-section architecture (revised 2026-03-31).** Security > Correctness > Maintainability > Performance > Development Speed priority. Part I: Code Quality (§1.0-§1.9: Naming, Omnichannel, Realism First, Structure First, Blueprint Compliance, Zero Warnings, Refactoring, Root Cause First, Config Impact Analysis, Codebase-as-Truth). Part II: Infrastructure & Performance (§2.0-§2.5: Golden Quad, Read-Optimized, Performance Budgets/CWV, Asset Optimization, API-Free First, Centralized Storage). Part III: DevSecOps (§3.0-§3.5: Zero Trust, Secrets Management, Env Template Sync & Drift Prevention, PII Scrubbing, **Software Supply Chain Security [NEW: SLSA/Sigstore/SBOM]**). Part IV: Technical Debt (§4.0-§4.4: Sprint 20%, Tech Radar, Lockfile Integrity, Dead Export, Ghost Feature Ban). Part V: AI-First Engineering (§5.0-§5.4: PDD, RAG Optimization, AI Hygiene, **AI Code Review Governance [NEW]**, **LLM Context Optimization [NEW]**). Part VI: Green Coding (§6.0-§6.2). Part VII: Zero Bug Policy (§7.0-§7.3: Fix Twice). Part VIII: Continuous Learning (§8.0-§8.2: Crystallization). Part IX: Compatibility & Testing (§9.0-§9.2). Part X: Git (§10.0-§10.6: Trunk Based, Conventional Commits, IPv6, Branch Hygiene, Migration Immutability, Zod Alignment). Part XI: Documentation Ops (§11.0-§11.2: Living Docs, README Standard). Part XII: Quality Protocols (§12.1-§12.12: Zero-Warning Lint, Code Review, CODEOWNERS, Git Hooks 3-Layer, SSOT Sync). Part XIII: Advanced Architecture (§13.1-§13.13: Trinity DTO consolidated, Client-Server Boundary, Service Layer, CQRS & Cache, Mutation Integrity consolidated, Type Safety, Error Handling Contract, Dead Code Cleanup, API Product, Auth & Access Control, Build & Deploy Verification, Migration Safety, Feature Flag Lifecycle). Quick reference index. |
| 100 | [100_api_integration.md](./universal/en/engineering/100_api_integration.md) | API integration & microservices. RESTful design, versioning, rate limiting, error handling, strict action return type, graceful failure contract, CORS governance, API gateway metering. |


| # | File | Summary |
|---|---|---|
| 200 | [200_supabase_architecture.md](./universal/en/engineering/200_supabase_architecture.md) | Supabase architecture strategy. 60 sections, 200+ rules. Comprehensive coverage: DB design/RLS/Auth/Storage/Migration/Performance/Edge Functions/Realtime/Cron・Queues/Observability/pgvector/AI/Advanced Auth/Testing/Branching/PostgREST/CLI/Connection Pooling/Backup/DR/Rate Limiting/Vault/FDW/Data API Hardening/Multi-tenancy/pg_graphql/DB Functions/Triggers/Log Drain/Auth Hooks/Self-hosted/SSR Integration/DB Extensions/Client SDK/Schema Design Patterns/Social Auth/SSO/Data Migration/Seeding/Multigres Horizontal Scaling/PostgreSQL 18/Passkeys/MCP Server/AI Integration/Security Advisor/VPC/Private Link/Read Replicas/GitHub Actions CI/CD/Database Partitioning/Full-Text Search/Type-Safe E2E/CDN/Edge Caching/Compliance/Data Sovereignty/Operational Maturity Model. Service Quick Reference Index (Appendix A). |


| # | File | Summary |
|---|---|---|
| 300 | [300_web_frontend.md](./universal/en/engineering/300_web_frontend.md) | Web Frontend Engineering (Next.js / React / TypeScript). **49 Parts, 300 Sections, Rule 33.1–33.293**. Philosophy & Core Principles, App Router Architecture, Server/Client Boundary, Edge Computing/Middleware, UI Component Design, CSS Architecture, Component Design, React Hooks, React 19 New APIs, Hydration/SSR Stability, Form Design, Advanced Forms, Input UX, Validation/Security, State Management, Data Fetching/Cache, Performance, Image/Font/Script optimization, SEO/GEO, Accessibility, PWA, i18n, Error Handling, Server Actions, Testing, Deployment/Infra, Modern Web Platform APIs, Frontend Observability, AI Integration, Micro-Frontend, Web Worker, Frontend Security, Frontend FinOps, Design System, Anti-Patterns, Monorepo, Real-Time Communication, Authentication UI, Animation, Responsive Design, E-Commerce, Frontend DevOps, Third-Party Scripts, Sustainability, 5-Level Maturity Model & Future Outlook. Reverse lookup index & cross-references. |
| 310 | [310_headless_cms.md](./universal/en/engineering/310_headless_cms.md) | Content Management System (Headless CMS). **80-part, 160-section, 131-rule architecture**. CMS philosophy, headless architecture patterns, CMS selection, content modeling, Content Delivery/Management API, GraphQL governance, Webhooks, media storage, image optimization, DAM integration, rendering strategies, CDN, cache tiering, rich text editor governance, publishing workflow, preview strategy, dynamic page builder, SEO automation, AI-Ready Content, AI-powered operations, Agentic CMS, CMS security, content moderation, accessibility, multilingual, content personalization, Content as Code, CMS migration, real-time collaboration, content A/B testing, Server-Driven UI, CMS testing, content pipeline automation, multi-tenant, DR/BCP, regulatory compliance, GEO, Green IT, CMS observability/FinOps, 5-level maturity model, 40 anti-patterns. Reverse lookup index & cross-references. |
| 400 | [400_mobile_flutter.md](./universal/en/engineering/400_mobile_flutter.md) | Mobile Engineering (Flutter). **55-part, 265-section architecture**. Philosophy & Supreme Directive (UX Fidelity > Performance > Security > Code Reuse > Dev Speed), Technology Stack Standards (Flutter 3.41+, Dart 3.7+, Riverpod 3.0+, Impeller GA), Architecture Principles (Clean Architecture, Layered, Feature-Based, DI, SSOT), Dart 3.7+ Language Conventions (sealed class, pattern matching, Wildcard Variables, Extension Types, Records, Null Safety), Async Processing & Isolates, Code Generation (build_runner, Macros cancellation, Augmentations outlook), State Management (Riverpod 3.0+ GA, Unified Notifier API, code-gen first, @riverpod, ref.watch/read absolute rule, Ref.mounted safety check, select granularity, equality-based updates, automatic retry, Pause/Resume, Freezed immutability, Mutations code-gen-free, **riverpod_lint required**), Advanced Riverpod Patterns, Offline Persistence, GoRouter Navigation, Clean Architecture Patterns, DI & Environment Config, Performance ("120fps or Die"), Impeller Rendering (**Impeller-specific DevTools 2026 metrics**), Widget Tree Optimization, Startup Optimization, Memory Management, Offline-First (Drift, SQLCipher), Network (Dio, VIP Lane), Image/Media, Real-time Communication, Platform Fidelity, Responsive/Adaptive UI, Material 3 Design System, Animation, Forms & Validation, Accessibility (**WCAG 2.2 AA**, SemanticsRole API, **EU Accessibility Act 2025**), Security (**OWASP MASVS Control Groups**, flutter_secure_storage, Certificate Pinning), RASP, AI & ML, Testing (**patrol E2E new standard**, **alchemist Golden Test enhancement**, MobSF), CI/CD & Deployment (Shorebird OTA, **lock file persistence**, **fastlane-plugin-shorebird**, staged rollout), Observability, Multi-Platform, Governance, Push Notification Architecture (**flutter_local_notifications integration**, **idempotency message_id**), Authentication & App Check (**Passkeys/FIDO2**), App Lifecycle & Background Processing, IAP & App Updates, **[New Part S]** Dart FFI & Native Interop Deep Dive (dart:ffi, JNI, jnigen, Swift Interop, Native Build integration), Payment Integration Architecture (Stripe, RevenueCat, PCI DSS, 3DS, Apple Pay/Google Pay, Entitlement-based design, tax & currency), Local Notifications & Scheduling (flutter_local_notifications, timezone-aware, notification actions, Deep Link integration), Widget Testing Deep Dive (Golden Test strategy, alchemist, interaction testing, test matrix, visual regression CI), Error Boundary & Recovery UX (4-level error classification, ErrorBoundary Widget, Recovery UX patterns, post-crash recovery), Connectivity & Network Resilience (connectivity_plus, offline queue, retry strategy, Circuit Breaker, bandwidth adaptation), In-App Navigation UX Design (Bottom Navigation, BottomSheet, Drawer, page transitions, OverlayPortal), Configuration Management & Feature Flags (Firebase Remote Config, staged rollout, kill switch, technical debt management, emergency control), Data Privacy & Consent Management (CMP, TCF 2.0, ATT, data subject rights, privacy testing), Mobile DevOps & DX (FVM, build_runner optimization, Hot Reload, DevTools extensions, PR quality gates, ADR, Widget Catalog), Language-Specific Addendum & Extended Anti-Patterns (Dart 3.7+ latest features, memory leak prevention, type safety patterns, code quality metrics, CI automation extensions), 5-level maturity model, **50 anti-patterns**, FinOps benchmarks, Future Outlook (GenUI SDK, Impeller Desktop/Web, Dart Augmentations). Reverse lookup index & cross-references. |
| 410 | [410_native_platforms.md](./universal/en/engineering/410_native_platforms.md) | Native platforms (Kotlin/Swift). **20-part, 80-section architecture**. Kotlin 2.x, Swift 6, Android Architecture, iOS Architecture, KMP, Jetpack Compose Performance, SwiftUI, Concurrency, Performance, On-Device AI, Offline-First, Security, OS Features, Flutter Integration, Testing, CI/CD, Accessibility, Observability, FinOps, 5-level maturity model, 20 anti-patterns. Quick reference index & cross-references. |


| # | File | Summary |
|---|---|---|
| 500 | [500_firebase_gcp.md](./universal/en/engineering/500_firebase_gcp.md) | Backend Engineering (Firebase & GCP). 55 sections, Rule 32.1–32.169 + Appendix A–D. Supreme Directives (Auxiliary Engine, Defense in Depth, Idempotency, FinOps Guardian, Cloud Run Unified), Cloud Run Functions/Services/Jobs/GPU, Eventarc/Pub/Sub/Cloud Tasks, Firebase Auth (Passkeys/FIDO2), App Check, Firestore (Enterprise Edition/Named Databases/MCP Server), Data Connect, Cloud Storage, Firebase Hosting/App Hosting (GA), FCM (HTTP v1 API), Remote Config, Crashlytics, Performance Monitoring, Analytics, Firebase AI Logic/Genkit, Vertex AI/Agent Engine (A2A), AI Agent Security & Governance, BigQuery integration, Defense in Depth (Zero Trust/OWASP 2025/Cloud Armor WAF), IAM/WIF, Secret Manager (CMEK), VPC (Direct VPC Egress/Private Service Connect), FinOps & Cost Optimization, Budget Alerts & Automation, Observability (OpenTelemetry), Error Handling (Circuit Breaker/DLQ), Terraform/IaC, Firebase CLI, Emulator Suite, CI/CD (GitHub Actions/WIF), Environment Management, Multi-Region & DR, API Design, Rate Limiting, Caching, Batch Processing, Google Maps, Google Ecosystem, Firebase Studio, Compliance (GDPR/CCPA/Global Privacy Laws), Supply Chain Security, Operational Maturity Model (L1–L5), Migration, Troubleshooting, Language-Specific, Top 30 Anti-Patterns, Future Outlook. |
| 510 | [510_aws_cloud.md](./universal/en/engineering/510_aws_cloud.md) | AWS cloud architecture strategy. 155 sections, 240+ rules, 15 code snippets. Comprehensive coverage from Well-Architected to all major AWS services (including Lambda Durable Functions/AWS Interconnect/EKS Capabilities/Amazon Nova/VPC Encryption Controls/Data Perimeter/Passkey FIDO2/Outposts Gen2/Amazon Transform/Green Insights/Shield AI/Maturity Model & 20 Anti-Patterns). Service Quick Reference Index (Appendix A). |

#### ai/: AI & Data

| # | File | Summary |
|---|---|---|
| 000 | [000_ai_engineering.md](./universal/en/ai/000_ai_engineering.md) | AI Implementation & UX Strategy (48 Parts, 150+ Sections). AI Philosophy & UX Patterns, Ethics & Governance, Core Architecture, RAG Architecture, Agentic AI (L1-L5, MCP/A2A Protocol), multi-layer guardrails, hallucination mitigation, Kill Switch, AI FinOps (30% rule), Multimodal & Edge AI, LLMOps, maturity model, 20 anti-patterns. |
| 100 | [100_data_analytics.md](./universal/en/ai/100_data_analytics.md) | Analytics Intelligence & Observability (60 Parts / 206 Sections). Event Taxonomy, Product Analytics, A/B Testing, Privacy-First Analytics, GA4/BigQuery AI Integration, CDP/Identity Resolution, KPI/Metric Governance, Dashboard Quality Standards, Observability 5 Pillars, OpenTelemetry 2026, SLO-Driven Observability, AIOps 2.0/Agentic Observability, LLM/GenAI Observability, Data Pipeline Observability, Data Quality, Security Observability, Cost Observability/FinOps Cloud+, Observability as Code, 5-Level Maturity Model, 25 Anti-Patterns. |

#### operations/: Operations, SRE, CS & FinOps

| # | File | Summary |
|---|---|---|
| 000 | [000_internal_tools.md](./universal/en/operations/000_internal_tools.md) | Admin operations & internal tools. **50-part, 231-section, 221-rule architecture**. Supreme Directive, Admin Excellence Culture, Build vs Buy strategy, admin tool architecture, admin dashboard design, UI/UX standards, accessibility, authentication & authorization, security hardening, data privacy & GDPR, immutable audit logging, workflow automation engine, AI integration (Agentic AI L1-L5), compliance automation & GRC, FinOps, 5-level maturity model & 20 anti-patterns. Quick reference index & cross-references. |
| 300 | [300_customer_experience.md](./universal/en/operations/300_customer_experience.md) | User Support & Customer Success (**40 parts**, 160+ sections). Support philosophy, AI agent strategy (Agentic AI L1-L5), omnichannel design, ticket management & SLA, customer success strategy, Customer Health Score, onboarding design, churn prevention, VoC & feedback loop, compliance & regulatory, Voice AI, maturity model (L1-L5) & quick reference index. |
| 400 | [400_site_reliability.md](./universal/en/operations/400_site_reliability.md) | SRE & reliability engineering. **55 parts / 166 sections**. Supreme Directive, SLI/SLO/SLA & error budgets, observability (5 pillars), incident management, deployment, chaos engineering, resilience patterns, IaC & GitOps, Platform Engineering, AIOps (Agentic AI SRE L1-L5), multi-region DR, maturity model & anti-patterns. Quick reference index & cross-references. |
| 500 | [500_incident_response.md](./universal/en/operations/500_incident_response.md) | Crisis management & BCP. ISO 22301/NIST CSF 2.0/DORA compliance, BIA, incident response framework, cyber incident response, AI-driven threat response, crisis communication, BCP/DR strategy, governance, maturity model. Quick reference index. |
| 100 | [100_sales_bizdev.md](./universal/en/operations/100_sales_bizdev.md) | Sales & Business Development (10 Parts · 38 Sections)**. Challenger Sale philosophy (Teach/Tailor/Take Control), Value Selling vs feature explanation ban, 8-stage Sales Funnel (MQL→SQL→SAL→Opportunity→Proposal→Negotiation→Closed), MEDDIC qualification framework (including Champion 3 conditions), MEDDIC CRM scoring implementation, Cold Email 5-component 200-word design, 5-touch sequence, Anti-Spam compliance (CAN-SPAM/GDPR/ePrivacy), 5-step demo structure & Discovery 6-item checklist, demo prohibition list, 8-component proposal structure, PoC success criteria mandatory (30-day limit), Mutual Close Plan, Win/Loss 6-category analysis, Sales Playbook 8 required items, New AE 30-day onboarding, BizDev vs Sales distinction, Partner evaluation framework (25-point ≥15 criteria), Technology Partnership design principles. Quick reference index & cross-references. |
| 200 | [200_hr_organization.md](./universal/en/operations/200_hr_organization.md) | HR & Organization Design (9 Parts · 34 Sections)**. Maximizing Talent Density (Netflix), A players hire A players principle, 4-tier hiring priority (Values > Learning > Attitude > Skills), Bar Raiser system (Amazon), JD quality standard 6 sections & YAML role definition template, compensation philosophy (P75+ / salary bands), hiring funnel within 4 weeks / 10-step prohibition, Referral Program design, Structured Interviews (same questions for all), STAR/Case/Values/Backchannel Reference mix, Debrief 4 rules (HiPPO prohibited), 4 unconscious bias types & prevention, Verbal Offer First principle, 90-day Onboarding program (Day 1 full setup mandatory) & Buddy Program, OKR design principles (70% achievement = great, company-wide transparency), weekly 1:1 30min / Listening Mode mandatory, Performance Review 3 dimensions (What/How/Potential) / no surprises, Conway's Law alignment, Team Topologies 4 types (Stream-Aligned/Enabling/Complicated/Platform), span of control 5–8 cap, Remote-First 5 principles (Async First/Doc First/Timezone Respect/Camera On/IRL Quarterly). Quick reference index & cross-references. |
| 700 | [700_partnership_ecosystem.md](./universal/en/operations/700_partnership_ecosystem.md) | Partner & Ecosystem Strategy (9 Parts · 34 Sections)**. Partnership 3 purposes (Market Access/Product Extension/Credibility) & 5 types (Technology/Channel/Strategic/Marketplace/Reseller), Partnership Theater anti-pattern definition, Ecosystem Flywheel design (Salesforce AppExchange 7,000+ apps example), Partnership Maturity Model 5 levels (Ad-hoc→Managed→Scalable→Ecosystem→Platform), Coopetition management principles, Integration Tier 3 levels (Premier/Select/Registered) & quality standards YAML schema (OAuth 2.0 + HMAC signature required) & 6-month deprecation timeline, Channel Partner 15–30% margin design / Deal Registration within 5 days / Channel Conflict prevention rules, Strategic Alliance 5 conditions / Joint GTM 5 components / quarterly KPI evaluation, Developer Portal 8 required elements / Sandbox / Changelog, Indirect Network Effects design, Partner Success 3 metrics (Activation/Productivity/NPS≥50) / partner lifecycle management / contract 8 required clauses, Marketplace build criteria (MAU≥50K / Dev 1K+) / third-party marketplace listing strategy / Revenue Sharing industry benchmark comparison (Shopify/Apple/Google). Quick reference index & cross-references. |
| 600 | [600_cloud_finops.md](./universal/en/operations/600_cloud_finops.md) | Cloud FinOps — Cloud Cost Optimization & Financial Operations. **25-part, 57-section architecture**. FinOps Foundation Framework 2026 (Cloud+ Scope) compliant. FOCUS v1.3 specification. FinOps philosophy & 6 principles, CoE organization model, Executive Strategy Alignment, cost visibility & allocation (Showback/Chargeback), tagging standards, unit economics, rightsizing, commitment strategy (RI/SP/CUD), Spot/Graviton strategy, storage tiering, network/Egress optimization, serverless FinOps, DB FinOps (RDS/Aurora/DynamoDB/BigQuery), AI/ML FinOps (30% Rule Circuit Breaker), Agentic AI FinOps (L1-L5 maturity, autonomous optimization, OpenCost MCP Server), LLM cost optimization (model routing, semantic caching, distillation), GPU/TPU optimization (MIG/MPS, Spot GPU), K8s FinOps (OpenCost/Kubecost, VPA/HPA/KEDA, multi-tenant allocation), SaaS/license management (ITAM integration), budget/forecasting/anomaly detection (ML-driven, multi-tier alerts), Cloud Bankruptcy Prevention (multi-layer defense, DDoS cost attack mitigation), Policy-as-Code (OPA/Sentinel/Kyverno, Governance-as-Code), IaC cost integration (Infracost, PR review criteria, guardrails), CDN/Edge/IoT FinOps, data pipeline FinOps (ETL/streaming), multi-cloud/multi-account (FOCUS integration), FinOps×Platform Engineering (Backstage integration, Golden Path), security cost optimization, GreenOps & sustainability (SCI calculation, carbon-aware-sdk, EU CSRD/SEC compliance), language-specific sections (TypeScript/Terraform/Python/Go), 5-level maturity model, tool ecosystem, top 30 anti-patterns, future outlook. Quick reference index & cross-references. |

#### security/: Security, Legal & Compliance

| # | File | Summary |
|---|---|---|
| 000 | [000_security_privacy.md](./universal/en/security/000_security_privacy.md) | Security & privacy. **22-section architecture**. Zero Trust 7 pillars (NIST 800-207), authentication/authorization (FIDO2/Social Login/Session management), API security (BOLA/BFLA/SSRF prevention), supply chain security (SBOM/SLSA), AI/LLM security (OWASP LLM Top 10 2025), container security (Pod Security Standards/image signing), file upload security, cryptographic policy (prohibited algorithms/PQC readiness), OWASP Top 10 2025 mapping, GraphQL, secrets management, client-side security, bot/DDoS defense, vendor management, incident response, security governance. Quick Reference Index (Appendix A). |
| 100 | [100_data_governance.md](./universal/en/security/100_data_governance.md) | Legal, governance & data strategy. **45-section architecture**. Global regulation map (GDPR/CCPA/EU AI Act + Global Privacy Laws), 2025-2027 timeline, cross-border transfer, consent management, data governance maturity model, RegTech automation, quantum cryptographic agility. Quick Reference Index. |
| 200 | [200_oss_compliance.md](./universal/en/security/200_oss_compliance.md) | License & dependency management. **49 sections, 280+ rules, 40+ code snippets**. Three-tier license classification, SBOM (CycloneDX 1.6/SPDX 3.0), supply chain security (SLSA v1.1/Sigstore), SCA tool integration, automated update strategy, maturity model. Quick Reference Index. |
| 300 | [300_ip_due_diligence.md](./universal/en/security/300_ip_due_diligence.md) | IP strategy & due diligence. **50-section, 10-part architecture**. IP ownership, patent strategy, trade secrets, trademarks, copyright, AI-generated IP, exit strategy, DD operations, governance, compliance. Quick Reference Index. |

#### quality/: Testing & QA

| # | File | Summary |
|---|---|---|
| 000 | [000_qa_testing.md](./universal/en/quality/000_qa_testing.md) | QA & testing strategy. **40-section, 12-part architecture**. Testing philosophy, test types (static/unit/integration/contract/E2E/VRT/performance/property-based/mutation/a11y), security, test quality, CI/CD, release, domain-specific, resilience, AI-driven testing, data & API quality, compliance & observability, 5-level testing maturity model. Quick Reference Index. |

### 📐 Blueprint Rules (Project-Specific)

> **Status: Mutable** — Create and edit to define project-specific context.
>
> For the full file listing, category structure, and operational guide, refer to the **Blueprint-specific INDEX**:
> - 🇯🇵 **[blueprint/ja/INDEX.md](./blueprint/ja/INDEX.md)** — Japanese Blueprint Index
> - 🇺🇸 **[blueprint/en/INDEX.md](./blueprint/en/INDEX.md)** — English Blueprint Index
>
> Adding or managing Blueprint files is done in the Blueprint INDEX — no changes to this master INDEX are required.

---

### 🎯 Prompt Library (Optional)

> **Status: Optional** — Reusable templates to instruct AI agents to execute high-quality tasks. Customizable to project requirements.

| Directory | Summary |
|---|---|
| `../axiarch-prompts/en/develop/` | Development & execution prompts (`feature_development.md`, `refactoring_audit.md`, `push_execute.md`, `ci_fix.md`). Copy and paste directly into the AI agent's chat. |
| `../axiarch-prompts/en/audit/` | Quality & integrity audit prompts (`fullstack_qa_audit.md`, `api_architecture_audit.md`, `data_integrity_audit.md`, `system_integrity_audit.md`, `deep_optimization_audit.md`). |
| `../axiarch-prompts/en/govern/` | Compliance & governance prompts (`governance_auditor.md`, `constitution_compliance_audit.md`, `compliance_inspector_audit.md`, `blueprint_governance_audit.md`, `localization_audit.md`). |
| `../axiarch-prompts/en/operate/` | Incident response & onboarding prompts (`onboarding_audit.md`, `incident_response.md`). |
