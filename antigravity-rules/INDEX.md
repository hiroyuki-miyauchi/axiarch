# Antigravity Rules — Master Index / マスター索引

> [!NOTE]
> **このファイルは `antigravity-rules/` ディレクトリ全体の詳細索引です。**
> 各ルールファイルの役割・概要を日本語と英語で記載しています。
>
> **This file is the detailed index for the entire `antigravity-rules/` directory.**
> It describes the role and summary of each rule file in both Japanese and English.

---

## 🇯🇵 日本語セクション

### 📋 ディレクトリ構成

```
your-project/
 ├── GEMINI.md                 ← 最高法規（行動指針）
 ├── .agent/
 │    └── rules/
 │         └── prompt_pointer.md  ← ポインター（目次・参照先はantigravity-rules/）
 ├── antigravity-rules/
 │    ├── INDEX.md              ← 本ファイル（全体索引）
 │    ├── README.md             ← クイックリファレンス（リンク集・セットアップガイド）
 │    ├── compliance_matrix.md  ← 要件対照表
 │    ├── universal/            ← 不変ルール（憲法）
 │    │    ├── ja/              ← 日本語版
 │    │    └── en/              ← 英語版
 │    └── blueprint/            ← プロジェクト固有ルール（法律）
 │         ├── ja/
 │         └── en/
 └── src/                       ← プロジェクトコード
```

### 📄 ルートファイル

| ファイル | 説明 |
|---|---|
| [README.md](./README.md) | 全ルールモジュールへのリンク集。導入手順・初期セットアップガイドを含む。 |
| [compliance_matrix.md](./compliance_matrix.md) | ユーザーの要望がどのルールファイルでカバーされているかを証明する要件対照表。Universal（不変）と Blueprint（可変）の責務分離を定義。 |

---

### 📚 Universal Rules（不変ルール / 憲法）

> **Status: Immutable（不変）** — 「憲法改正」の明示的指示がない限り編集禁止。

#### 000: コア・マインドセット

| # | ファイル | 概要 |
|---|---|---|
| 000 | [000_core_mindset.md](./universal/ja/000_core_mindset.md) | **最上位の行動原則。** 優先順位の階層（セキュリティ > UX > 収益性 > DX）、ゼロ・トレランス、Headless First、SSOT原則、対症療法の禁止、Git/デプロイ禁止プロトコル、既存機能保護、回帰バグ防止など、全ルールの基盤。 |

#### 100–109: ビジネス・成長戦略

| # | ファイル | 概要 |
|---|---|---|
| 100 | [100_product_strategy.md](./universal/ja/100_product_strategy.md) | プロダクト・ビジネス戦略。MVP→PMF、収益化モデル（フリーミアム/サブスクリプション）、ユニットエコノミクス、法務コンプライアンス、レビュー・信頼性システム（段階的信頼レベル・通報対応・UGC Rate Limit）、タグベース検索設計、インタラクティブエンジン。 |
| 101 | [101_revenue_monetization.md](./universal/ja/101_revenue_monetization.md) | 財務・収益化の詳細戦略。FinOps（コスト管理）、決済（Stripe）、ポイント経済圏、AIトークンエコノミクス、クーポン整合性、動的価格設計、価格A/Bテスト実験基盤、税務・インボイス制度。 |
| 102 | [102_growth_marketing.md](./universal/ja/102_growth_marketing.md) | グロース・マーケティング戦略。PLG（プロダクト主導型成長）、SEO/GEO（AI検索最適化）、オンボーディング、リテンション、広告フィード連携（ブランドセーフティ・Ads.txt）、OGP動的生成、ファーストパーティデータ、トラフィックリスク分散、KPI計測フレームワーク。 |
| 103 | [103_appstore_compliance.md](./universal/ja/103_appstore_compliance.md) | Apple App Store / Google Play のガイドライン準拠。IAP必須、プライバシーマニフェスト、ASO（ストア最適化）、申請前チェックリスト。 |

#### 200: デザイン・UX

| # | ファイル | 概要 |
|---|---|---|
| 200 | [200_design_ux.md](./universal/ja/200_design_ux.md) | デザインとUX戦略。モバイルファースト、アクセシビリティ（WCAG 2.1 AA詳細基準・Image Alt Text）、アニメーション（60fps）、タッチターゲット、デザインシステム、Pixel Perfect基準、おもてなしUX（Input Normalization・ロケール入力補助）、エラーページ設計基準、エラーメッセージUX基準、Ghost Contentプロトコル、リッチ選択UI、IME対応、i18n準備基準。 |

#### 300–399: エンジニアリング（20単位間隔）

##### 300: エンジニアリング汎用

| # | ファイル | 概要 |
|---|---|---|
| 300 | [300_engineering_standards.md](./universal/ja/300_engineering_standards.md) | エンジニアリング全般。セルフチェックリスト、Zero Warnings、Tech Radar、CI/CD、Husky導入義務、コーディング規約、オムニチャネル配信義務、DTO分割義務、マッパー堅牢性、マイグレーション静的解析、フィーチャーフラグ運用規律。 |
| 301 | [301_api_integration.md](./universal/ja/301_api_integration.md) | API統合とマイクロサービス。RESTful設計、バージョニング、レート制限、エラーハンドリング、Server Action戻り値厳格化、安全失敗契約、CORSガバナンス、APIゲートウェイ使用量計測。 |

##### 320: バックエンド・DB

| # | ファイル | 概要 |
|---|---|---|
| 320 | [320_supabase_architecture.md](./universal/ja/320_supabase_architecture.md) | Supabaseアーキテクチャ戦略。60セクション・200+ルール。DB設計/RLS/Auth/Storage/Migration/Performance/Edge Functions/Realtime/Cron・Queues/Observability/pgvector・AI/Advanced Auth/Testing/Branching/PostgREST/CLI/Connection Pooling/Backup・DR/Rate Limiting/Vault/FDW/Data API Hardening/Multi-tenancy/pg_graphql/DB Functions・Triggers/Log Drain/Auth Hooks/Self-hosted・Email/SSR Integration/DB Extensions/Client SDK/Schema Design Patterns/Social Auth・SSO/Data Migration・Seeding/Multigres水平スケーリング/PostgreSQL 18(AIO・UUIDv7・Skip Scan)/Column-Level Security/Passkeys・Biometric Auth/MCP Server・AI統合/Security Advisor/テーブル別API制御/VPC・Private Link/Read Replicas/Project-scoped Roles/GitHub Actions CI/CD/Advisory Locks/Webhook署名検証/Database Partitioning/Full-Text Search・pg_trgm/AI生成SQL管理/型安全E2E/CDN・Edge Caching/コンプライアンス・データ主権/運用成熟度モデル。サービス別逆引き索引（Appendix A）付き。 |

##### 340: フロントエンド

| # | ファイル | 概要 |
|---|---|---|
| 340 | [340_web_frontend.md](./universal/ja/340_web_frontend.md) | Webフロントエンジニアリング（Next.js / React / TypeScript）。**49パート・300セクション・Rule 33.1–33.293**。哲学・コア原則（Server First・Security Priority・CWV Deployment Gate）、テクノロジースタック標準、App Routerアーキテクチャ（RSC・server-only・Env Fail Fast・Async API・PPR）、Server/Client境界（Leaf Component・DTO Interface）、Edge Computing/Middleware（Non-Blocking・CSP Worker）、UIコンポーネント設計（shadcn/ui・Design Tokens・Rich Selection）、CSSアーキテクチャ（Utility First・!important禁止・cn()・Z-Index階層・CSS Containment・Container Queries）、コンポーネント設計原則（Co-location・Barrel Export禁止・Static Component）、React Hooks（Order Guarantee・Dependency Protocol・Compiler Readiness）、React 19 新API（Actions・useOptimistic・useFormStatus・use()・React Compiler v1.0）、Hydration/SSR安定性、フォーム設計（React Hook Form + Zod・Schema-Driven・Three-Point Sync）、高度フォームパターン（Auto-Save・Dynamic Form・useFieldArray Guard・DnD Overlay）、入力UX（inputMode・NFKC・IME Guard・iOS Zoom Defense）、バリデーション/セキュリティ（Anti-Spam・Turnstile・DTO Boundary）、State Management（Server/Client分離・Zustand/Jotai・URL State）、Data Fetching/Cache（Parallel Fetch・Public Cache FinOps・Resilient RSC）、パフォーマンス最適化（CWV Deployment Gate・Bundle Budget・Dynamic Library Decoupling）、画像/フォント/スクリプト最適化（next/image・AVIF First・next/font・next/script）、SEO/Metadata・Technical SEO/GEO（Speculative Rules API・IndexNow・GEO Strategy）、アクセシビリティ（WCAG 2.2 AA・EAA 2025・axe-core CI）、PWA/クロスプラットフォーム、i18n、エラーハンドリング（Error Boundary・Graceful Degradation）、Server Actions/API安全性、データ可視化/エクスポート、AdTech/マーケティング、テスト戦略（Testing Trophy・Vitest・Playwright・Lighthouse CI・Storybook）、デプロイ/インフラ（Vercel・ISR・Edge Config・CDN）、モダンWeb Platform API（View Transitions・CSS Anchor Positioning・Popover API・@starting-style・CSS Grid Masonry）、フロントエンド可観測性/RUM（OpenTelemetry Browser SDK・Session Replay）、AI統合/LLMストリーミングUI、Micro-Frontend/Module Federation 2.0、Web Worker/Off-Main-Thread（Comlink）、フロントエンドセキュリティ深化（Trusted Types・SRI・CSP Strict Dynamic）、フロントエンドFinOps、デザインシステム統合（Design Token・cva・Theme Switching）、**[新規10パート]** 禁止アンチパターン30選、Monorepo & Multi-App戦略（Turborepo）、リアルタイム通信（WebSocket/SSE/WebTransport）、認証UI & セッション管理（Passkey・Edge Middleware Guard）、Animation & Motion Design、レスポンシブ & マルチデバイス（Fluid Typography・dvh）、E-Commerceフロントエンド（Cart UI・PCI DSS）、フロントエンドDevOps（ESLint Flat Config・Biome・Pre-commit）、サードパーティスクリプト管理（Partytown・Consent-Aware Loading）、Sustainability & Green Frontend（SCI測定）、成熟度モデル5段階・将来展望（WebAssembly・WebGPU・AI-Native Frontend・Edge-First Architecture）。逆引き索引・クロスリファレンス付き。 |
| 341 | [341_headless_cms.md](./universal/ja/341_headless_cms.md) | ヘッドレスCMS。**80パート・160セクション・131ルール構成**。CMS哲学（API-First・Content as Data・優先順位階層）、ヘッドレスアーキテクチャパターン、CMS選定・Composable DXP、コンテンツモデリング、Content Delivery/Management API、GraphQLガバナンス、Webhook、メディアストレージ、画像最適化、DAM統合、レンダリング戦略、CDN・エッジ配信、キャッシュ階層、リッチテキストエディタガバナンス、パブリッシングワークフロー、プレビュー戦略、動的ページビルダー、SEO自動化、AI-Readyコンテンツ、AI駆動オペレーション、Agentic CMS、CMSセキュリティ、コンテンツモデレーション、アクセシビリティ、多言語・翻訳ワークフロー、コンテンツパーソナライゼーション、Content as Code、CMS移行、リアルタイムコラボレーション、コンテンツA/Bテスト、Server-Driven UI、エディタ体験、CMSテスト戦略、コンテンツパイプライン自動化、マルチテナント、DR・BCP、規制コンプライアンス、GEO、Green IT、CMS可観測性・FinOps、成熟度モデル・アンチパターン40選。逆引き索引・クロスリファレンス付き。 |
| 342 | [342_mobile_flutter.md](./universal/ja/342_mobile_flutter.md) | モバイル開発（Flutter）。状態管理、パフォーマンス、プラットフォーム固有対応。 |
| 343 | [343_native_platforms.md](./universal/ja/343_native_platforms.md) | ネイティブプラットフォーム（Kotlin/Swift）。**20パート・80セクション構成**。Kotlin 2.x（K2コンパイラ・Guard Conditions・Sealed）、Swift 6（Strict Concurrency・Sendable・Actor・Typed Throws）、Androidアーキテクチャ（Jetpack Compose・MVI・Hilt・マルチモジュール）、iOSアーキテクチャ（SwiftUI・MVVM/TCA・SwiftData・Privacy Manifest・App Intents・WidgetKit）、KMP（commonMain最大化・Swift Export・段階的導入）、Jetpack Compose性能（Pausable Composition・Baseline Profiles・Strong Skipping）、SwiftUI（Preview-Driven・@Observable）、並行処理（Coroutines/Flow・Swift Concurrency・WorkManager・BGTaskScheduler）、パフォーマンス（起動500ms・120fps・HTTP/3・バッテリー最適化）、オンデバイスAI（Core ML・ML Kit・TFLite・MediaPipe・モデルOTA）、オフラインファースト（Room・SwiftData・SSOT・Delta Sync）、セキュリティ（No Secrets in Binary・RASP・Passkeys FIDO2・Play Integrity・App Attest・Certificate Pinning）、OS機能（Push・Deep Links・Widget・Bridge）、Flutter連携（Pigeon必須）、テスト（JUnit5・Swift Testing・Maestro・Macrobenchmark）、CI/CD（Staged Rollout）、アクセシビリティ（VoiceOver/TalkBack・WCAG 2.1 AA）、可観測性（Crashlytics・OpenTelemetry Mobile）、FinOps（ビルド15分以内・App Size 30MB以下）、成熟度モデル5段階・アンチパターン20選。逆引き索引・クロスリファレンス付き。 |

##### 360: クラウド・BaaS

| # | ファイル | 概要 |
|---|---|---|
| 360 | [360_firebase_gcp.md](./universal/ja/360_firebase_gcp.md) | バックエンドエンジニアリング（Firebase & GCP）。55パート・Rule 32.1〜32.169 + Appendix A〜D構成。Supreme Directives（補助エンジン原則・多層防御・冪等性・FinOps Guardian・Cloud Run統一）、Cloud Run Functions/Services/Jobs/GPU、Eventarc/Pub/Sub/Cloud Tasks、Firebase Auth（Passkeys/FIDO2）、App Check、Firestore（Enterprise Edition/Named Databases/MCP Server）、Data Connect、Cloud Storage、Firebase Hosting/App Hosting（GA）、FCM（HTTP v1 API）、Remote Config、Crashlytics、Performance Monitoring、Analytics、Firebase AI Logic/Genkit（Node.js GA/Go GA/Python Alpha）、Vertex AI/Agent Engine（A2A）、AI Agent セキュリティ & ガバナンス（MCP連携・EU AI Act）、BigQuery連携、セキュリティ多層防御（Zero Trust/OWASP 2025/Cloud Armor WAF）、IAM/WIF、Secret Manager（CMEK）、VPC（Direct VPC Egress/Private Service Connect）、FinOps & コスト最適化（AI FinOps・30%ルール）、予算アラート & 自動応答、Observability（OpenTelemetry）、エラーハンドリング（Circuit Breaker/DLQ）、Terraform/IaC、Firebase CLI、Emulator Suite、CI/CD（GitHub Actions/WIF）、環境管理、マルチリージョン & DR、API設計、Rate Limiting、キャッシング、バッチ処理 & データパイプライン、Google Maps最適化、Google Ecosystem統合、Firebase Studio、コンプライアンス（GDPR/CCPA/APPI）、サプライチェーンセキュリティ（SBOM/Binary Authorization）、運用成熟度モデル（L1〜L5）、マイグレーション & 廃止、トラブルシューティング、言語固有セクション（Node.js TS/Go/Python）、アンチパターン30選、将来展望。 |
| 361 | [361_aws_cloud.md](./universal/ja/361_aws_cloud.md) | AWSクラウドアーキテクチャ戦略。155セクション・240+ルール・15コードスニペット。Well-Architected基盤から全主要AWSサービスまで網羅（Lambda Durable Functions/AWS Interconnect/EKS Capabilities/Amazon Nova/VPC Encryption Controls/Data Perimeter/Passkey FIDO2/Outposts Gen2/Amazon Transform/Green Insights/Shield AI/成熟度モデル&アンチパターン20選含む）。サービス別逆引き索引（Appendix A）付き。 |

#### 400–409: AI・データ

| # | ファイル | 概要 |
|---|---|---|
| 400 | [400_ai_engineering.md](./universal/ja/400_ai_engineering.md) | AI実装とUX戦略（48パート・150+セクション）。AI哲学・UXパターン（Chat/Copilot/Agent/Ambient/Proactive）、倫理・ガバナンス（EU AI Act準拠・グローバル規制マッピング・バイアス公平性）、コアアーキテクチャ（Private Relay・Model Router・Structured Output・ストリーミング・セマンティックキャッシング・プロンプトインジェクション多層防御）、RAGアーキテクチャ（GraphRAG・Hybrid Search・Reranking・評価フレームワーク）、Agentic AI（L1-L5自律性分類・MCP/A2A Protocol・マルチエージェント）、ガードレール多層モデル・ハルシネーション対策・Kill Switch、AI FinOps（30%ルール・トークン最適化）、マルチモーダル・エッジAI、LLMOps（PromptOps・モデルライフサイクル・LLM-as-Judge・AI可観測性）、成熟度モデル・アンチパターン20選。 |
| 401 | [401_data_analytics.md](./universal/ja/401_data_analytics.md) | 分析インテリジェンスとオブザーバビリティ（60パート/206セクション）。Event Taxonomy、プロダクトアナリティクス（NSM/AARRR）、A/Bテスト統計プロトコル（Bayesian/CUPED/Causal AI連携/Adaptive Experimentation）、プライバシーファースト分析（Privacy Sandbox廃止対応/IPA/データクリーンルーム）、GA4/BigQuery AI連携、CDP/ID統合、KPI/指標ガバナンス、ダッシュボード品質基準、Observability 5本柱（+Profiling）、OpenTelemetry 2026、分散トレーシング、RED/USEメトリクス、構造化ログ、Continuous Profiling、RUM/CWV/INP最適化、Synthetic Monitoring、APM、SLO駆動可観測性、AIOps 2.0/Agentic Observability、LLM/GenAI可観測性、データパイプライン可観測性、データ品質6次元、セキュリティ可観測性、コスト可観測性/FinOps Cloud+、Observability as Code、成熟度モデル・アンチパターン25選。 |

#### 500–509: 運用・SRE

| # | ファイル | 概要 |
|---|---|---|
| 500 | [500_internal_tools.md](./universal/ja/500_internal_tools.md) | 管理運用と内部ツール。**50パート・231セクション・221ルール構成**。Supreme Directive「管理ツールは二級市民ではない」、Admin Excellence Culture、Build vs Buy戦略、管理ツールアーキテクチャ、管理ダッシュボード設計、UI/UX基準・Admin デザインシステム、アクセシビリティ、認証・認可アーキテクチャ（RBAC/ABAC/MFA/JITアクセス/Passkey）、セキュリティ強化（Zero Trust）、データプライバシー・GDPR管理画面対応、不変監査ログ、ユーザー管理、コンテンツ管理、ワークフロー自動化エンジン、AI統合・インテリジェント管理（Agentic AI L1-L5）、コンプライアンス自動化・GRC、FinOps、成熟度モデル5段階・アンチパターン20選。逆引き索引・クロスリファレンス付き。 |
| 501 | [501_customer_experience.md](./universal/ja/501_customer_experience.md) | ユーザーサポートとカスタマーサクセス（**40パート**・160+セクション）。サポート哲学、AIエージェント戦略（Agentic AI L1-L5/AI Copilot/MCP・A2A統合）、オムニチャネル設計、チケット管理・SLA、カスタマーサクセス戦略、Customer Health Score、オンボーディング設計、解約防止・リテンション、VoC・フィードバックループ、コンプライアンス・規制対応、Voice AI・会話型サポート、成熟度モデル（L1-L5）・逆引き索引。 |
| 502 | [502_site_reliability.md](./universal/ja/502_site_reliability.md) | SREと信頼性エンジニアリング。**55パート・166セクション構成**。Supreme Directive「Hope is not a strategy / Slow is the New Down」、SLI/SLO/SLA・エラーバジェット、可観測性（5本柱）、インシデント管理、デプロイメント戦略、カオスエンジニアリング、レジリエンスパターン、IaC・GitOps、Platform Engineering、AIOps（Agentic AI SRE L1-L5）、マルチリージョンDR、成熟度モデル・アンチパターン。逆引き索引・クロスリファレンス付き。 |
| 503 | [503_incident_response.md](./universal/ja/503_incident_response.md) | 危機管理とBCP（事業継続計画）。31パート構成。ISO 22301/NIST CSF 2.0/DORA準拠、BIA、インシデント対応体制、サイバーインシデント対応、AI駆動脅威対応、危機コミュニケーション、BCP・DR戦略、Blamelessポストモーテム、ガバナンス・RACI・KPI、成熟度モデル（5段階）。逆引き索引付き。 |

#### 600–609: セキュリティ・法務

| # | ファイル | 概要 |
|---|---|---|
| 600 | [600_security_privacy.md](./universal/ja/600_security_privacy.md) | セキュリティとプライバシー。**22セクション構成**。ゼロトラスト7柱（NIST 800-207準拠）、認証・認可（FIDO2/Social Login/Session管理）、APIセキュリティ（BOLA/BFLA/SSRF防止）、サプライチェーン（SBOM/SLSA）、AI/LLMセキュリティ（OWASP LLM Top 10 2025）、コンテナセキュリティ（Pod Security Standards/イメージ署名）、暗号化ポリシー（PQC準備）、OWASP Top 10 2025、GraphQL、シークレット管理、クライアントサイドセキュリティ、ボット/DDoS防御、セキュリティガバナンス。逆引き索引付き。 |
| 601 | [601_data_governance.md](./universal/ja/601_data_governance.md) | 法務・ガバナンス・データ戦略。**45セクション構成**。グローバル規制マッピング（GDPR/APPI/CCPA/EU AI Act等14法）・2025-2027タイムライン・越境移転・同意管理・データガバナンス成熟度・RegTech自動化・量子暗号アジリティ。逆引き索引付き。 |
| 602 | [602_oss_compliance.md](./universal/ja/602_oss_compliance.md) | ライセンスと依存関係管理。**49セクション・280+ルール・40+コードスニペット**。ライセンス三層分類・SBOM（CycloneDX 1.6/SPDX 3.0）・サプライチェーンセキュリティ（SLSA v1.1/Sigstore）・SCAツール統合・自動更新戦略・成熟度モデル。逆引き索引付き。 |
| 603 | [603_ip_due_diligence.md](./universal/ja/603_ip_due_diligence.md) | 知的財産とExit戦略。**50セクション・10パート構成**。IP所有権・特許戦略・営業秘密・商標・著作権・AI生成物IP・Exit戦略・DD実務・ガバナンス・コンプライアンス。逆引き索引付き。 |

#### 700–729: テスト・QA・FinOps

| # | ファイル | 概要 |
|---|---|---|
| 700 | [700_qa_testing.md](./universal/ja/700_qa_testing.md) | QAとテスト戦略。**40セクション・12パート構成**。テスト哲学、テスト種別（静的/ユニット/統合/コントラクト/E2E/VRT/パフォーマンス/Property-Based/ミューテーション/a11y）、セキュリティ、テスト品質、CI/CD、リリース、ドメイン固有、レジリエンス、AI駆動テスト、データ&API品質、コンプライアンス&可観測性、成熟度モデル5段階。逆引き索引付き。 |
| 720 | [720_cloud_finops.md](./universal/ja/720_cloud_finops.md) | Cloud FinOps — クラウドコスト最適化 & 財務運用。**13パート・39セクション構成**。FinOps Foundation Framework 2026（Cloud+ Scope）準拠。FinOps哲学・6原則、FOCUS v1.3仕様、CoE組織モデル、コスト可視化・配賦（Showback/Chargeback）、タギング標準、ユニットエコノミクス、ライトサイジング、コミットメント戦略（RI/SP/CUD）、Spot戦略、ストレージ階層化、ネットワークコスト最適化、サーバーレスFinOps、AI/ML FinOps（サーキットブレーカー・LLMコスト最適化・GPU最適化）、K8s FinOps（OpenCost/Kubecost・VPA/HPA）、SaaS/ライセンス管理、予算・予測・異常検知、Cloud Bankruptcy Prevention、Policy-as-Code（IaCコスト見積もり・Infracost）、マルチクラウド/マルチアカウント、GreenOps・サステナビリティ（SCI計算）、成熟度モデル5段階・アンチパターン20選。逆引き索引・クロスリファレンス付き。 |

#### 800–809: グローバル・ガバナンス

| # | ファイル | 概要 |
|---|---|---|
| 800 | [800_internationalization.md](./universal/ja/800_internationalization.md) | グローバル展開と国際化（i18n）。**16パート・80セクション構成**。グローバル展開戦略、i18nアーキテクチャ、L10n基盤、RTL/BiDi、CJK、タイムゾーン、カルチャライゼーション、マルチリージョンインフラ、決済/税制、SEO/GEO、AI/LLM多言語、モバイルi18n、テスト、成熟度モデル5段階。逆引き索引・クロスリファレンス付き。 |
| 801 | [801_governance.md](./universal/ja/801_governance.md) | 憲法の権威と不変性。**22パート・80+セクション構成**。憲法定義・基本原則、法規範階層、参照義務、憲法改正プロトコル、紛争解決、文書統治、AIエージェント権限制御、監査・可観測性、ガバナンス組織、成熟度モデル5段階、Policy-as-Code統合、マルチプロジェクト連邦制。逆引き索引・クロスリファレンス付き。 |
| 802 | [802_language_protocol.md](./universal/ja/802_language_protocol.md) | 言語プロトコル。**36パート・150+ルール構成**。基本原則・三層言語モデル、コード言語規約、ドキュメント言語戦略、Git言語規約、UI/UXローカライゼーション、バリデーション・フォーム言語プロトコル、エラーハンドリング言語階層、API応答言語ポリシー、AIエージェント通信言語プロトコル、成熟度モデル5段階・20大アンチパターン。逆引き索引・クロスリファレンス付き。 |

---

### 📐 Blueprint Rules（プロジェクト固有ルール / 法律）

> **Status: Mutable（可変）** — プロジェクトのコンテキストに応じて作成・編集可能。
>
> Blueprint配下のファイル一覧・カテゴリ構成・運用ガイドは **Blueprint専用INDEX** を参照してください:
> - 🇯🇵 **[blueprint/ja/INDEX.md](./blueprint/ja/INDEX.md)** — 日本語版Blueprint索引
> - 🇺🇸 **[blueprint/en/INDEX.md](./blueprint/en/INDEX.md)** — English Blueprint Index
>
> ※ 新しいBlueprintファイルの追加・管理はBlueprint専用INDEXで行うため、本ファイル（マスターINDEX）の書き換えは不要です。

---
---

## 🇺🇸 English Section

### 📋 Directory Structure

```
your-project/
 ├── GEMINI.md                 ← Supreme Law (behavioral guidelines)
 ├── .agent/
 │    └── rules/
 │         └── prompt_pointer.md  ← Pointer (TOC — references antigravity-rules/)
 ├── antigravity-rules/
 │    ├── INDEX.md              ← This file (master index)
 │    ├── README.md             ← Quick reference (links & setup guide)
 │    ├── compliance_matrix.md  ← Compliance matrix
 │    ├── universal/            ← Immutable rules (constitution)
 │    │    ├── ja/              ← Japanese version
 │    │    └── en/              ← English version
 │    └── blueprint/            ← Project-specific rules
 │         ├── ja/
 │         └── en/
 └── src/                       ← Your project code
```

### 📄 Root Files

| File | Description |
|---|---|
| [README.md](./README.md) | Link collection to all rule modules. Includes setup and initialization guide. |
| [compliance_matrix.md](./compliance_matrix.md) | Compliance matrix proving which rule files cover each user requirement. Defines the separation between Universal (immutable) and Blueprint (mutable). |

---

### 📚 Universal Rules (Immutable / Constitution)

> **Status: Immutable** — DO NOT edit unless explicitly instructed to "Amend Constitution".

#### 000: Core & Mindset

| # | File | Summary |
|---|---|---|
| 000 | [000_core_mindset.md](./universal/en/000_core_mindset.md) | **Supreme behavioral principles.** Priority hierarchy (Security > UX > Profitability > DX), Zero Tolerance, Headless First, SSOT principle, band-aid solution ban, Git/deployment ban protocol, existing functionality protection, regression ban. |

#### 100–109: Business & Growth

| # | File | Summary |
|---|---|---|
| 100 | [100_product_strategy.md](./universal/en/100_product_strategy.md) | Product & business strategy. MVP→PMF, monetization models (freemium/subscription), unit economics, legal compliance, review/trust system (progressive trust levels, user reports, UGC rate limits), tag-based search design, interactive engine. |
| 101 | [101_revenue_monetization.md](./universal/en/101_revenue_monetization.md) | Finance & monetization details. FinOps (cost management), payments (Stripe), point economy, AI token economics, coupon integrity, dynamic pricing, pricing A/B test framework, tax/invoice compliance. |
| 102 | [102_growth_marketing.md](./universal/en/102_growth_marketing.md) | Growth & marketing strategy. PLG (Product-Led Growth), SEO/GEO (AI search optimization), onboarding, retention, ad feeds (brand safety, ads.txt), dynamic OGP, first-party data, traffic risk diversification, KPI measurement framework. |
| 103 | [103_appstore_compliance.md](./universal/en/103_appstore_compliance.md) | Apple App Store / Google Play guideline compliance. IAP mandate, privacy manifests, ASO (App Store Optimization), pre-submission checklist. |

#### 200: Design & UX

| # | File | Summary |
|---|---|---|
| 200 | [200_design_ux.md](./universal/en/200_design_ux.md) | Design & UX strategy. Mobile-first, accessibility (WCAG 2.1 AA detailed criteria, image alt text), animations (60fps), touch targets, design system, Pixel Perfect standards, Omotenashi UX (input normalization, locale input assistance), error page design, error message UX, Ghost Content protocol, rich selection UI, IME handling, i18n readiness. |

#### 300–399: Engineering (20-unit intervals)

##### 300: Engineering Standards

| # | File | Summary |
|---|---|---|
| 300 | [300_engineering_standards.md](./universal/en/300_engineering_standards.md) | General engineering. Self-check list, Zero Warnings, Tech Radar, CI/CD, Husky mandate, coding standards, omnichannel delivery mandate, DTO segregation, mapper robustness, migration static analysis, feature flag lifecycle. |
| 301 | [301_api_integration.md](./universal/en/301_api_integration.md) | API integration & microservices. RESTful design, versioning, rate limiting, error handling, strict action return type, graceful failure contract, CORS governance, API gateway metering. |

##### 320: Backend & DB

| # | File | Summary |
|---|---|---|
| 320 | [320_supabase_architecture.md](./universal/en/320_supabase_architecture.md) | Supabase architecture strategy. 60 sections, 200+ rules. Comprehensive coverage: DB design/RLS/Auth/Storage/Migration/Performance/Edge Functions/Realtime/Cron・Queues/Observability/pgvector/AI/Advanced Auth/Testing/Branching/PostgREST/CLI/Connection Pooling/Backup/DR/Rate Limiting/Vault/FDW/Data API Hardening/Multi-tenancy/pg_graphql/DB Functions/Triggers/Log Drain/Auth Hooks/Self-hosted/SSR Integration/DB Extensions/Client SDK/Schema Design Patterns/Social Auth/SSO/Data Migration/Seeding/Multigres Horizontal Scaling/PostgreSQL 18/Passkeys/MCP Server/AI Integration/Security Advisor/VPC/Private Link/Read Replicas/GitHub Actions CI/CD/Database Partitioning/Full-Text Search/Type-Safe E2E/CDN/Edge Caching/Compliance/Data Sovereignty/Operational Maturity Model. Service Quick Reference Index (Appendix A). |

##### 340: Frontend

| # | File | Summary |
|---|---|---|
| 340 | [340_web_frontend.md](./universal/en/340_web_frontend.md) | Web Frontend Engineering (Next.js / React / TypeScript). **49 Parts, 300 Sections, Rule 33.1–33.293**. Philosophy & Core Principles, App Router Architecture, Server/Client Boundary, Edge Computing/Middleware, UI Component Design, CSS Architecture, Component Design, React Hooks, React 19 New APIs, Hydration/SSR Stability, Form Design, Advanced Forms, Input UX, Validation/Security, State Management, Data Fetching/Cache, Performance, Image/Font/Script optimization, SEO/GEO, Accessibility, PWA, i18n, Error Handling, Server Actions, Testing, Deployment/Infra, Modern Web Platform APIs, Frontend Observability, AI Integration, Micro-Frontend, Web Worker, Frontend Security, Frontend FinOps, Design System, Anti-Patterns, Monorepo, Real-Time Communication, Authentication UI, Animation, Responsive Design, E-Commerce, Frontend DevOps, Third-Party Scripts, Sustainability, 5-Level Maturity Model & Future Outlook. Reverse lookup index & cross-references. |
| 341 | [341_headless_cms.md](./universal/en/341_headless_cms.md) | Content Management System (Headless CMS). **80-part, 160-section, 131-rule architecture**. CMS philosophy, headless architecture patterns, CMS selection, content modeling, Content Delivery/Management API, GraphQL governance, Webhooks, media storage, image optimization, DAM integration, rendering strategies, CDN, cache tiering, rich text editor governance, publishing workflow, preview strategy, dynamic page builder, SEO automation, AI-Ready Content, AI-powered operations, Agentic CMS, CMS security, content moderation, accessibility, multilingual, content personalization, Content as Code, CMS migration, real-time collaboration, content A/B testing, Server-Driven UI, CMS testing, content pipeline automation, multi-tenant, DR/BCP, regulatory compliance, GEO, Green IT, CMS observability/FinOps, 5-level maturity model, 40 anti-patterns. Reverse lookup index & cross-references. |
| 342 | [342_mobile_flutter.md](./universal/en/342_mobile_flutter.md) | Mobile engineering (Flutter). State management, performance, platform-specific handling. |
| 343 | [343_native_platforms.md](./universal/en/343_native_platforms.md) | Native platforms (Kotlin/Swift). **20-part, 80-section architecture**. Kotlin 2.x, Swift 6, Android Architecture, iOS Architecture, KMP, Jetpack Compose Performance, SwiftUI, Concurrency, Performance, On-Device AI, Offline-First, Security, OS Features, Flutter Integration, Testing, CI/CD, Accessibility, Observability, FinOps, 5-level maturity model, 20 anti-patterns. Quick reference index & cross-references. |

##### 360: Cloud & BaaS

| # | File | Summary |
|---|---|---|
| 360 | [360_firebase_gcp.md](./universal/en/360_firebase_gcp.md) | Backend Engineering (Firebase & GCP). 55 sections, Rule 32.1–32.169 + Appendix A–D. Supreme Directives (Auxiliary Engine, Defense in Depth, Idempotency, FinOps Guardian, Cloud Run Unified), Cloud Run Functions/Services/Jobs/GPU, Eventarc/Pub/Sub/Cloud Tasks, Firebase Auth (Passkeys/FIDO2), App Check, Firestore (Enterprise Edition/Named Databases/MCP Server), Data Connect, Cloud Storage, Firebase Hosting/App Hosting (GA), FCM (HTTP v1 API), Remote Config, Crashlytics, Performance Monitoring, Analytics, Firebase AI Logic/Genkit, Vertex AI/Agent Engine (A2A), AI Agent Security & Governance, BigQuery integration, Defense in Depth (Zero Trust/OWASP 2025/Cloud Armor WAF), IAM/WIF, Secret Manager (CMEK), VPC (Direct VPC Egress/Private Service Connect), FinOps & Cost Optimization, Budget Alerts & Automation, Observability (OpenTelemetry), Error Handling (Circuit Breaker/DLQ), Terraform/IaC, Firebase CLI, Emulator Suite, CI/CD (GitHub Actions/WIF), Environment Management, Multi-Region & DR, API Design, Rate Limiting, Caching, Batch Processing, Google Maps, Google Ecosystem, Firebase Studio, Compliance (GDPR/CCPA/APPI), Supply Chain Security, Operational Maturity Model (L1–L5), Migration, Troubleshooting, Language-Specific, Top 30 Anti-Patterns, Future Outlook. |
| 361 | [361_aws_cloud.md](./universal/en/361_aws_cloud.md) | AWS cloud architecture strategy. 155 sections, 240+ rules, 15 code snippets. Comprehensive coverage from Well-Architected to all major AWS services (including Lambda Durable Functions/AWS Interconnect/EKS Capabilities/Amazon Nova/VPC Encryption Controls/Data Perimeter/Passkey FIDO2/Outposts Gen2/Amazon Transform/Green Insights/Shield AI/Maturity Model & 20 Anti-Patterns). Service Quick Reference Index (Appendix A). |

#### 400–409: AI & Data

| # | File | Summary |
|---|---|---|
| 400 | [400_ai_engineering.md](./universal/en/400_ai_engineering.md) | AI Implementation & UX Strategy (48 Parts, 150+ Sections). AI Philosophy & UX Patterns, Ethics & Governance, Core Architecture, RAG Architecture, Agentic AI (L1-L5, MCP/A2A Protocol), multi-layer guardrails, hallucination mitigation, Kill Switch, AI FinOps (30% rule), Multimodal & Edge AI, LLMOps, maturity model, 20 anti-patterns. |
| 401 | [401_data_analytics.md](./universal/en/401_data_analytics.md) | Analytics Intelligence & Observability (60 Parts / 206 Sections). Event Taxonomy, Product Analytics, A/B Testing, Privacy-First Analytics, GA4/BigQuery AI Integration, CDP/Identity Resolution, KPI/Metric Governance, Dashboard Quality Standards, Observability 5 Pillars, OpenTelemetry 2026, SLO-Driven Observability, AIOps 2.0/Agentic Observability, LLM/GenAI Observability, Data Pipeline Observability, Data Quality, Security Observability, Cost Observability/FinOps Cloud+, Observability as Code, 5-Level Maturity Model, 25 Anti-Patterns. |

#### 500–509: Operations & SRE

| # | File | Summary |
|---|---|---|
| 500 | [500_internal_tools.md](./universal/en/500_internal_tools.md) | Admin operations & internal tools. **50-part, 231-section, 221-rule architecture**. Supreme Directive, Admin Excellence Culture, Build vs Buy strategy, admin tool architecture, admin dashboard design, UI/UX standards, accessibility, authentication & authorization, security hardening, data privacy & GDPR, immutable audit logging, workflow automation engine, AI integration (Agentic AI L1-L5), compliance automation & GRC, FinOps, 5-level maturity model & 20 anti-patterns. Quick reference index & cross-references. |
| 501 | [501_customer_experience.md](./universal/en/501_customer_experience.md) | User Support & Customer Success (**40 parts**, 160+ sections). Support philosophy, AI agent strategy (Agentic AI L1-L5), omnichannel design, ticket management & SLA, customer success strategy, Customer Health Score, onboarding design, churn prevention, VoC & feedback loop, compliance & regulatory, Voice AI, maturity model (L1-L5) & quick reference index. |
| 502 | [502_site_reliability.md](./universal/en/502_site_reliability.md) | SRE & reliability engineering. **55 parts / 166 sections**. Supreme Directive, SLI/SLO/SLA & error budgets, observability (5 pillars), incident management, deployment, chaos engineering, resilience patterns, IaC & GitOps, Platform Engineering, AIOps (Agentic AI SRE L1-L5), multi-region DR, maturity model & anti-patterns. Quick reference index & cross-references. |
| 503 | [503_incident_response.md](./universal/en/503_incident_response.md) | Crisis management & BCP. ISO 22301/NIST CSF 2.0/DORA compliance, BIA, incident response framework, cyber incident response, AI-driven threat response, crisis communication, BCP/DR strategy, governance, maturity model. Quick reference index. |

#### 600–609: Security & Legal

| # | File | Summary |
|---|---|---|
| 600 | [600_security_privacy.md](./universal/en/600_security_privacy.md) | Security & privacy. **22-section architecture**. Zero Trust 7 pillars (NIST 800-207), authentication/authorization (FIDO2/Social Login/Session management), API security (BOLA/BFLA/SSRF prevention), supply chain security (SBOM/SLSA), AI/LLM security (OWASP LLM Top 10 2025), container security (Pod Security Standards/image signing), file upload security, cryptographic policy (prohibited algorithms/PQC readiness), OWASP Top 10 2025 mapping, GraphQL, secrets management, client-side security, bot/DDoS defense, vendor management, incident response, security governance. Quick Reference Index (Appendix A). |
| 601 | [601_data_governance.md](./universal/en/601_data_governance.md) | Legal, governance & data strategy. **45-section architecture**. Global regulation map (GDPR/APPI/CCPA/EU AI Act + 10 more), 2025-2027 timeline, cross-border transfer, consent management, data governance maturity model, RegTech automation, quantum cryptographic agility. Quick Reference Index. |
| 602 | [602_oss_compliance.md](./universal/en/602_oss_compliance.md) | License & dependency management. **49 sections, 280+ rules, 40+ code snippets**. Three-tier license classification, SBOM (CycloneDX 1.6/SPDX 3.0), supply chain security (SLSA v1.1/Sigstore), SCA tool integration, automated update strategy, maturity model. Quick Reference Index. |
| 603 | [603_ip_due_diligence.md](./universal/en/603_ip_due_diligence.md) | IP strategy & due diligence. **50-section, 10-part architecture**. IP ownership, patent strategy, trade secrets, trademarks, copyright, AI-generated IP, exit strategy, DD operations, governance, compliance. Quick Reference Index. |

#### 700–729: Testing, QA & FinOps

| # | File | Summary |
|---|---|---|
| 700 | [700_qa_testing.md](./universal/en/700_qa_testing.md) | QA & testing strategy. **40-section, 12-part architecture**. Testing philosophy, test types (static/unit/integration/contract/E2E/VRT/performance/property-based/mutation/a11y), security, test quality, CI/CD, release, domain-specific, resilience, AI-driven testing, data & API quality, compliance & observability, 5-level testing maturity model. Quick Reference Index. |
| 720 | [720_cloud_finops.md](./universal/en/720_cloud_finops.md) | Cloud FinOps — Cloud Cost Optimization & Financial Operations. **13-part, 39-section architecture**. FinOps Foundation Framework 2026 (Cloud+ Scope) compliant. FinOps philosophy & 6 principles, FOCUS v1.3 specification, CoE organization model, cost visibility & allocation (Showback/Chargeback), tagging standards, unit economics, rightsizing, commitment strategy (RI/SP/CUD), Spot strategy, storage tiering, network cost optimization, serverless FinOps, AI/ML FinOps (circuit breaker, LLM cost optimization, GPU optimization), K8s FinOps (OpenCost/Kubecost, VPA/HPA), SaaS/license management, budget/forecasting/anomaly detection, Cloud Bankruptcy Prevention, Policy-as-Code (IaC cost estimation, Infracost), multi-cloud/multi-account, GreenOps & sustainability (SCI calculation), 5-level maturity model, top 20 anti-patterns. Quick reference index & cross-references. |

#### 800–809: Global & Governance

| # | File | Summary |
|---|---|---|
| 800 | [800_internationalization.md](./universal/en/800_internationalization.md) | Global expansion & i18n. **16-part, 80-section architecture**. Global expansion strategy, i18n architecture, L10n infrastructure, RTL/BiDi, CJK, timezone, culturalization, multi-region infra, payments/taxation, SEO/GEO, AI/LLM multilingual, mobile i18n, testing, 5-level maturity model. Quick reference index & cross references. |
| 801 | [801_governance.md](./universal/en/801_governance.md) | Constitution authority & immutability. **22-part, 80+ section architecture**. Definition & fundamental principles, normative hierarchy, duty of reference, constitutional amendment protocol, dispute resolution, documentation law, AI agent permission control, audit & observability, governance organization, 5-level maturity model, Policy-as-Code integration, multi-project federation. Quick reference index & cross-references. |
| 802 | [802_language_protocol.md](./universal/en/802_language_protocol.md) | Language protocol. **44-part, 200+ rules architecture**. Fundamental principles & language hierarchy model, code language conventions, documentation language strategy, Git language conventions, UI/UX localization, validation & form language, error handling language hierarchy, API response language, AI agent communication, maturity model & anti-patterns. Quick Reference Index. |

---

### 📐 Blueprint Rules (Project-Specific)

> **Status: Mutable** — Create and edit to define project-specific context.
>
> For the full file listing, category structure, and operational guide, refer to the **Blueprint-specific INDEX**:
> - 🇯🇵 **[blueprint/ja/INDEX.md](./blueprint/ja/INDEX.md)** — Japanese Blueprint Index
> - 🇺🇸 **[blueprint/en/INDEX.md](./blueprint/en/INDEX.md)** — English Blueprint Index
>
> Adding or managing Blueprint files is done in the Blueprint INDEX — no changes to this master INDEX are required.
