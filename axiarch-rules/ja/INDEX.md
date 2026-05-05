# Axiarch Rules — マスター索引

> [!NOTE]
> **このファイルは `axiarch-rules/` ディレクトリ全体の詳細索引です。**
> 各ルールファイルの役割・概要を記載しています。

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
 │    ├── ja/                  ← 日本語版
 │    │    ├── INDEX.md        ← 本ファイル（全体索引）
 │    │    ├── README.md       ← クイックリファレンス
 │    │    ├── compliance_matrix.md
 │    │    ├── LOADING_PROTOCOL.md
 │    │    ├── CRYSTALLIZATION_PROTOCOL.md
 │    │    ├── universal/      ← 不変ルール（憲法）
 │    │    │    ├── core/      ← 基盤哲学・憲法・通信規約
 │    │    │    ├── product/   ← 事業戦略・収益・成長・国際化
 │    │    │    ├── design/    ← デザイン・UX
 │    │    │    ├── engineering/ ← 技術実装全般
 │    │    │    ├── ai/        ← AI・データ・分析
 │    │    │    ├── operations/ ← 運用・SRE・CS・FinOps
 │    │    │    ├── security/  ← セキュリティ・法務・コンプライアンス
 │    │    │    └── quality/   ← テスト・QA
 │    │    └── blueprint/      ← プロジェクト固有ルール（法律）
 │    └── en/                  ← 英語版（同構造）
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

#### core/: 基盤哲学・憲法

| # | ファイル | 概要 |
|---|---|---|
| 000 | [000_core_mindset.md](./universal/core/000_core_mindset.md) | **最上位の行動原則（Rev.9・19セクション）。** 優先順位の階層（セキュリティ > UX > 収益性 > DX）、ゼロ・トレランス、Headless First、SSOT原則、対症療法の禁止、Observability-First、Resilience by Design、Cost as First-Class Citizen、Cognitive Load Minimization、Security-by-Design、AI-Augmented Engineering、Privacy-by-Architecture、Accessibility-by-Design、**Post-Quantum Readiness (§1.14)**、**Regulatory Agility (§1.15)**、Git/デプロイ禁止プロトコル、既存機能保護、Agentic AI時代プロトコル（§9.1〜§9.7）など、全ルールの基盤。 |
| 100 | [100_governance.md](./universal/core/100_governance.md) | 憲法の権威と不変性。憲法定義・基本原則、改正プロトコル、AI エージェント権限制御、監査・可観測性、マルチプロジェクト連邦制。 |
| 200 | [200_language_protocol.md](./universal/core/200_language_protocol.md) | 言語プロトコル。三層言語モデル、コード言語規約、ドキュメント言語戦略、AIエージェント通信言語プロトコル。 |

#### product/: 事業戦略・収益・成長・国際化

| # | ファイル | 概要 |
|---|---|---|
| 000 | [000_product_strategy.md](./universal/product/000_product_strategy.md) | プロダクト・ビジネス戦略（24セクション + Appendix、Rev.13）。ビジョン・戦略ピラー、プロダクト発見・ポジショニング、指標ガバナンス、収益化戦略、ユニットエコノミクス、財務管理、法務・コンプライアンス、組織DNA、AI-Nativeプロトコル（LLMOps・リーズニングモデル・AI Red Team・Agent認可・RSP）、プラットフォーム戦略、データプロダクト戦略、倫理・サステナビリティ（Inclusive Design・DE&I）、検索・発見アーキテクチャ、レビュー・信頼システム、インタラクティブエンジン、グロース・ループ、競合インテリジェンス、カスタマーサクセス、プロダクトポートフォリオ戦略、GTMローンチ、グローバル展開、資金調達・IR、Revenue Operations (RevOps)、ブランドアーキテクチャ & コーポレートコミュニケーション。§1.9 戦略的パートナーシップ&BD / §23.6 Sales Enablement含む。逆引き索引・クロスリファレンス付き。 |
| 300 | [300_revenue_monetization.md](./universal/product/300_revenue_monetization.md) | 財務・収益化の詳細戦略（12パート・62アンチパターン）。FinOps（コスト管理）、決済（Stripe）、ポイント経済圏、AIトークンエコノミクス、クーポン整合性、動的価格設計、価格A/Bテスト実験基盤、税務・インボイス制度、**Decoupled Metering Architecture**（メータリング分離設計）、**Agent Execution Liability Protocol**（Agentic AI課金責任・失敗分類）、ASC 606収益認識・**Variable Consideration推定**、エンタイトルメント管理・**Prepaid Credit権限管理**、RevOpsデータアーキテクチャ・**Customer Health Score収益統合**、Expansion Revenue & NRRプロトコル、成熟度モデル5段階。逆引き索引・クロスリファレンス付き。 |
| 500 | [500_growth_marketing.md](./universal/product/500_growth_marketing.md) | グロース・マーケティング戦略。PLG（プロダクト主導型成長）、SEO/GEO（AI検索最適化）、オンボーディング、リテンション、広告フィード連携（ブランドセーフティ・Ads.txt）、OGP動的生成、ファーストパーティデータ、トラフィックリスク分散、KPI計測フレームワーク。 |
| 700 | [700_appstore_compliance.md](./universal/product/700_appstore_compliance.md) | **ストアガイドラインとコンプライアンス（20 Part / 80+ ルール構成）**。Apple App Store / Google Play のガイドライン準拠を網羅的に規定。HIG / Material Design / Dark Mode / Dynamic Type、**Apple Privacy 4 層モデル（ATT / Privacy Manifests `PrivacyInfo.xcprivacy` / Required Reason API / Privacy Nutrition Labels）**、SKAdNetwork v4 / AdAttributionKit、StoreKit 2 / Auto-Renewable Subscription / Promotional・Win-back・Introductory Offer / App Store Server Notifications V2、Sign in with Apple 義務 / Account Deletion 5.1.1(v) / Passkey、TestFlight / Phased Release / Expedited / Appeal、Code Signing & Provisioning、Google Play Target API 年次更新 / Data Safety section / Play Billing Library 7+ / Real-time Developer Notifications / **Android App Bundle (AAB) 必須化** / Closed・Open・Internal Testing / Phased Rollout / In-App Updates API、Play Integrity API（SafetyNet 後継）、**子供向けアプリ規制（COPPA / GDPR-K / Apple Kids / Google Designed for Families）**、Platform API Terms（Maps / YouTube / APNs / FCM）、ASO Deep Dive（キーワード / A/B Test / Custom Product Pages / ASO+ASA Synergy）、ローカライゼーション（40+ 言語）、**DMA Compliance（EU Digital Markets Act・Alternative Marketplaces・Sideloading・Browser Choice Screen）**、**Generative AI App Compliance（Apple/Google GenAI ポリシー・Content Moderation 義務）**、Specialized Verticals（Health/HealthKit/Health Connect・Finance/Crypto・Games/Loot Box・Hybrid/PWA）、Common Rejections Top 10 / Pre-Submission Master Checklist、Anti-Pattern Catalog 統合表。逆引き索引・クロスリファレンス付き。 |
| 800 | [800_internationalization.md](./universal/product/800_internationalization.md) | 国際化・多言語対応（i18n/L10n）。Unicode・CLDR・RTL設計、翻訳ワークフロー、リージョン別コンプライアンス。 |
| 100 | [100_market_validation.md](./universal/product/100_market_validation.md) | 市場検証・PMF戦略（18パート・105+セクション・120ルール）**。Evidence Hierarchy（7段階）・検証データ有効期限・**Founder-Market Fit評価（5軸スコアリング）**、JTBD 3層・Pain Severity Scoring・Gap分析、TAM/SAM/SOM・Why Now Canvas（市場タイミング）・市場構造分析・**規制リスク評価プロトコル（Regulatory PMF）**・**Regulatory Sandbox活用プロトコル**、Mom Testプロトコル・Signal Strength Scoring・AI-Augmented Interview分析・**Community-Led Validation（DevTool/OSS市場）**・**動的ICP精緻化プロトコル**、Hypothesis Log・RAT（Riskiest Assumption Test）、MVP 8類型・MLP（Minimum Lovable Product）・Prototype Fidelity Matrix・Smoke Test・**Pre-PMF価格感度検証（簡易Van Westendorp）**、PMF Composite Score（5指標加重平均）・Superhuman PMF Engine（Rahul Vohra 4ステップ反復）・B2B/B2C PMF分岐テーブル・Cohort-Level PMF・Leading/Lagging指標分類・False PMFシグナル8種・**Marketplace PMF（Liquidity Score・Chicken-and-Egg解決戦略）**・**Platform & API PMF（DXS算出）**・**NRR/Expansion Revenue as PMF Signal**・**PLG-SLG Hybrid PMF（PQL・NRG・Behavioral Cohort・Smile Curve）**・**Vertical SaaS & Embedded Product PMF**、Unit Economics Gate（LTV/CAC≥3.0）・Premature Scaling禁止、Moat設計（AI Moat含む7種）・Blue Ocean/Red Ocean判定、ピボット8類型・Kill Criteria・Pivot vs Persevere Framework、Continuous Discovery（Teresa Torres / OST）、PMF Decay概念・PMF半減期（業界別）・PMF Erosion早期警告（7シグナル）・**Technology Platform Shift Risk**、Adjacent Market PMF拡張・Dilution管理・**Geographic PMF Expansion（Localization PMF）**・**Second Product PMF（共食いモニタリング）**、Demand-Side Validation（LOI/Waitlist/Pre-order/Design Partner転換）、AI-Native検証（Synthetic Research・PoV vs PoC・AI Commoditization対策・**Agentic AI PMF（Goal Attainment Rate・Autonomy Ratio・Context Chain Health）**・**AI Safety & Trust as PMF Dimension**・**Deep Tech & Hardware PMF（TRL連動・Climate Tech Impact）**）、成熟度モデル5段階（L1 Intuition→L5 Predictive）、アンチパターンカタログ40選。逆引き索引・クロスリファレンス付き。 |
| 200 | [200_go_to_market.md](./universal/product/200_go_to_market.md) | GTM戦略・ローンチ計画（15パート・80+セクション・101ルール）**。Non-Linear Buyer Journey（Dark Funnel前提）、April Dunford Positioning Canvas、Category Creation、Messaging Hierarchy（3層）、**Narrative Design（ストーリーテリング4構成要素）**、ICP定義（B2B/B2C・YAMLスキーマ）、ICP Scoring Model（Tier 1/2/3）、PLG/SLG/MLG/CLG/**ELG**モーション比較・実装プロトコル、Product-Led Sales遷移条件、GTMモーション成熟度モデル、チャネル評価5軸、Partner-Led Growth 4類型・Co-Selling運用、**ABM 3 Tier設計（1-to-1/1-to-Few/1-to-Many）・Signal-Based ABM・Intent Data活用**、Product Huntプロトコル（Launch Day/Post-Launch）、AI-Nativeローンチプロトコル（Safety Gate含む）、International Launch（Beachhead Market Strategy）、**Competitive Displacement 4フェーズ（Intelligence→Positioning→De-risking→Lock-in Prevention）**、Do Things That Don't Scale、初期顧客10社獲得プロトコル、GTM KPIダッシュボード（Acquisition/Activation/Revenue/Expansion層）、Revenue Velocity & Pipeline Health、GTM Efficiency Scorecard（LTV/CAC・Magic Number・CAC Payback）、Smarketing（Sales+Marketing統合）、GTM Playbook テンプレート、Analyst Relations プロトコル、**Signal-Based GTM & Dark Funnel（Self-Reported Attribution・Intent-Based Prioritization・Agent-Readable GTM）**、**Agentic GTM & AI GTMオーケストレーション 5層（L1 Automation→L5 Autonomous）・AI Sales Copilot・Digital Sales Room（DSR）**、**GTMアンチパターンカタログ25選（Premature Scaling・Channel Spray・Feature Selling等）**、**GTM成熟度モデル L1-L5（Ad-hoc→Predictive）・移行条件**、**将来展望（Agentic Commerce・Outcome-as-a-Service・Zero-Click Discovery等6領域）**。逆引き索引・クロスリファレンス付き。 |
| 400 | [400_pricing_strategy.md](./universal/product/400_pricing_strategy.md) | 価格戦略（17パート・87セクション・99ルール・30アンチパターン）**。**Part I** 価格哲学: Value-Based Pricing原則、Price-Value Equation（Perceived Value ≥ Price > Cost-to-Serve）、WTP計測義務（Van Westendorp PSM）、Pricing as Product。**Part II** モデル設計: 8モデル比較（Flat/Seat/Usage/Tiered/Hybrid/Freemium/Outcome/Credits）、AI時代モデル選択マトリクス。**Part III** 方法論: 5ステップ価格設定、Conjoint Analysis、Gabor-Granger法、EVC分析、Cost-to-Serve（AI 3層コスト）。**Part IV** ティア設計: GBB Framework、Decoy/Anchor設計、Add-on/Bundle Protocol。**Part V** 価格心理学・行動経済学: Anchoring/Decoy/Loss Aversion/Framing/Social Proof/端数価格・倫理的ガードレール。**Part VI** 価格変更: Grandfather Clause、Price Increase Playbook（5 Phase）、Migration Strategy。**Part VII** 実験: A/Bテスト倫理、成熟度L1-L5、MAB、弾力性測定。**Part VIII** エンタープライズ: 値引き権限テーブル（SDR 0%〜CEO 30%）、Deal Desk Protocol。**Part IX** 動的価格: AI駆動アーキテクチャ、倫理的ガードレール。**Part X** グローバル: 多通貨・PPP・ローカライズ・為替ヘッジ。**Part XI** Price Page UX: 情報設計・CTA最適化・Machine-Readable Pricing。**Part XII** KPI: ARPA/NRR/Price Realization/Discount Leakage。**Part XIII** AI時代: Agentic AI Pricing、Seat-to-Outcome移行、A2A Commerce。**Part XIV** ガバナンス: Pricing Committee・承認フロー・監査証跡。**Part XV** 規制: 価格差別禁止法・消費者保護・Dark Pattern禁止。**Part XVI** 成熟度モデルL1-L5・Anti-Pattern 30選・将来展望。逆引き索引・クロスリファレンス付き。 |
| 600 | [600_brand_strategy.md](./universal/product/600_brand_strategy.md) | ブランド戦略（8パート・30セクション）**。Simon Sinek Golden Circle（Why→How→What）、Brand Pyramid（5層）、Brand Promise定義、Brand Personality（5形容詞）、Design Token管理（JSON Token階層）、Logo Usage Guidelines（WCAG AA対比要件含む）、Voice/Tone設計（不変Character vs 状況別Tone）、コピーライティング5原則・ボタンCTAルール、エラーメッセージ3要素設計、Touchpoint Map、Onboardingをブランド体験として設計、Delightの設計（ただしCore完了後のみ）、Brand Crisis対応5原則（24時間以内・Honest・Accountable）。逆引き索引・クロスリファレンス付き。 |
| 900 | [900_fundraising_ir.md](./universal/product/900_fundraising_ir.md) | **資金調達・IR 戦略（15 Part / 80+ ルール構成）**。Default Alive・Ramen Profitability 哲学、調達 3 アンチパターン、**Burn Multiple 規律（David Sacks）**、Rule of 40、ステージ別達成基準（Pre-seed〜Pre-IPO・調達額目安・評価額レンジ）、調達タイミング 4 鉄則、エクイティ vs デット vs ブートストラップ vs Venture Debt vs Government 比較、**Cap Table & ESOP 設計（Founder 4 年 Vesting+1 年 Cliff・Single/Double Trigger Acceleration・ESOP サイズ・Option Pool Shuffle・Dilution 数学・409A Valuation・Carta/Pulley）**、**SAFE / Convertible Note / Bridge（YC SAFE v2.0 Post-money・Discount・Valuation Cap・MFN・Pro-rata Side Letter・KISS / J-KISS）**、ピッチデック 15 スライド・Narrative 設計・Traction Do/Don't・Pitch Memo（Sequoia/a16z）、Warm Intro 優先・Investor Fit 6 軸評価・Investor Reference Check、**Term Sheet 完全ガイド数学的深掘り（Liquidation Preference 1×/2× Participating/Non-participating 計算・Anti-dilution Full Ratchet vs Broad/Narrow Weighted Average 数学・Pro-rata/Drag-along/ROFR/No-Shop・Red Flag リスト）**、Competing Offers FOMO 戦略、Data Room 9 カテゴリ・Proactive Disclosure・DocSend/Datasite、月次投資家レポート標準・Board Meeting 運営・Early Warning 24h・Annual Letter、**規制コンプライアンス（FEFTA / CFIUS / EU FDI Screening / Insider Trading / MNPI / 10b5-1 Plan / QSBS / エンジェル税制 / Transfer Pricing / EDINET / SEC EDGAR / ESG・CSRD・TCFD）**、**IPO 準備プロトコル 36 ヶ月タイムライン（NYSE/NASDAQ/JPX 比較・S-1 Prep・SOX Compliance・Direct Listing/SPAC・Lock-up/Greenshoe）**、**M&A Exit プロトコル（Stock/Asset Purchase・Indemnification・Escrow・Earnout・Acqui-hire）**、Founder Wellbeing & Crisis Communication（メンタルヘルス・Layoff 倫理・危機 Board 運営）、Investor Tech Stack（Carta/Pulley/Visible.vc/Quaestor/Affinity・AI-Augmented IR・Human-in-the-Loop）、Anti-Pattern Catalog。逆引き索引・クロスリファレンス付き。 |

#### design/: デザイン・UX

| # | ファイル | 概要 |
|---|---|---|
| 000 | [000_design_ux.md](./universal/design/000_design_ux.md) | デザインとUX戦略（**25パート構成、2026-04-12改定**）。Supreme Directive: Consistency > Accessibility > Delight > Aesthetics > Dev Speed。W3C DTCG 2025.10準拠Design Token（3層階層: Global/Semantic/Component）、CSS Color Module 4（P3/Oklch）、WCAG 2.2 AA + EN 301 549（Target Size 2.5.8、Focus Appearance 2.4.13、Accessible Authentication 3.3.8）、Dark Pattern Complete Ban（FTC/DSA/CPRA/CCPA規制対応）、AI UX 5類型（Chat/Copilot/Agent/Ambient/Proactive）、Agentic AI UXパターン（Intent Preview/Autonomy Dial）、Generative UI（GenUI）、Motion Token Architecture（prefers-reduced-motion準拠）、Spatial Computing & XR UX（visionOS HIG）、パフォーマンスUX（CWV意識）、UXリサーチ & 計測（NPS/SUS/CSAT）、成熟度モデル（5段階）、アンチパターン・カタログ（30選）。技術スタック固有実装はengineering/へ委譲。 |

#### engineering/: 技術実装全般

| # | ファイル | 概要 |
|---|---|---|
| 000 | [000_engineering_standards.md](./universal/engineering/000_engineering_standards.md) | エンジニアリング基準（汎用）。**13パート・80セクション構成（2026-03-31改定）。** Security > Correctness > Maintainability > Performance > Development Speed 優先順位。Part I: コード品質（§1.0-§1.9: 命名規約、Omnichannel、Realism First、Structure First、Blueprint遵守、Zero Warnings、リファクタリング、Root Cause First、Config Impact Analysis、Codebase-as-Truth）。Part II: インフラ＆パフォーマンス（§2.0-§2.5: Golden Quad、読み取り最適化、Performance Budgets/CWV、アセット最適化、API-Free First、Centralized Storage）。Part III: DevSecOps（§3.0-§3.5: Zero Trust、Secrets Management、環境変数テンプレート同期・ドリフト防止、PII Scrubbing、**Software Supply Chain Security (SLSA/Sigstore/SBOM)**）。Part IV: 技術的負債（§4.0-§4.4: Sprint 20%返済、Tech Radar、Lockfile整合性、Dead Export検出、Ghost Feature Ban）。Part V: AIファースト開発（§5.0-§5.4: PDD、RAG最適化、AI Hygiene、**AI Code Review Governance **、**LLM Context Optimization **）。Part VI: Green Coding（§6.0-§6.2）。Part VII: ゼロバグ（§7.0-§7.3: Fix Twice）。Part VIII: 継続的学習（§8.0-§8.2: Crystallization）。Part IX: 互換性＆テスト（§9.0-§9.2）。Part X: CI/Deploy & 補助規約（§10.1, §10.2, §10.4-§10.6: CI/Deployment Safety、IPv6 Deployment、Migration Immutability、Zod Alignment）※ pure git workflow は `engineering/600_git_workflow.md` へ移動（v1.3.2）。Part XI: ドキュメント運用（§11.0-§11.2: Living Docs、README Standard）。Part XII: 品質プロトコル（§12.1-§12.12: Zero-Warning Lint、Code Review、CODEOWNERS、Git Hooks三層防御、SSOT Sync）。Part XIII: 高度アーキテクチャ（§13.1-§13.13: Trinity DTO統合、Client-Server Boundary、Service Layer、CQRS & Cache、Mutation Integrity統合、Type Safety、Error Handling Contract、Dead Code Cleanup、API Product、Auth & Access Control、Build & Deploy Verification、Migration Safety、Feature Flag Lifecycle）。逆引き索引。 |
| 100 | [100_api_integration.md](./universal/engineering/100_api_integration.md) | API統合とマイクロサービス。RESTful設計、バージョニング、レート制限、エラーハンドリング、Server Action戻り値厳格化、安全失敗契約、CORSガバナンス、APIゲートウェイ使用量計測。 |


| # | ファイル | 概要 |
|---|---|---|
| 200 | [200_supabase_architecture.md](./universal/engineering/200_supabase_architecture.md) | Supabaseアーキテクチャ戦略。60セクション・200+ルール。DB設計/RLS/Auth/Storage/Migration/Performance/Edge Functions/Realtime/Cron・Queues/Observability/pgvector・AI/Advanced Auth/Testing/Branching/PostgREST/CLI/Connection Pooling/Backup・DR/Rate Limiting/Vault/FDW/Data API Hardening/Multi-tenancy/pg_graphql/DB Functions・Triggers/Log Drain/Auth Hooks/Self-hosted・Email/SSR Integration/DB Extensions/Client SDK/Schema Design Patterns/Social Auth・SSO/Data Migration・Seeding/Multigres水平スケーリング/PostgreSQL 18(AIO・UUIDv7・Skip Scan)/Column-Level Security/Passkeys・Biometric Auth/MCP Server・AI統合/Security Advisor/テーブル別API制御/VPC・Private Link/Read Replicas/Project-scoped Roles/GitHub Actions CI/CD/Advisory Locks/Webhook署名検証/Database Partitioning/Full-Text Search・pg_trgm/AI生成SQL管理/型安全E2E/CDN・Edge Caching/コンプライアンス・データ主権/運用成熟度モデル。サービス別逆引き索引（Appendix A）付き。 |


| # | ファイル | 概要 |
|---|---|---|
| 300 | [300_web_frontend.md](./universal/engineering/300_web_frontend.md) | Webフロントエンジニアリング（Next.js / React / TypeScript）。**49パート・300セクション・Rule 33.1–33.293**。哲学・コア原則（Server First・Security Priority・CWV Deployment Gate）、テクノロジースタック標準、App Routerアーキテクチャ（RSC・server-only・Env Fail Fast・Async API・PPR）、Server/Client境界（Leaf Component・DTO Interface）、Edge Computing/Middleware（Non-Blocking・CSP Worker）、UIコンポーネント設計（shadcn/ui・Design Tokens・Rich Selection）、CSSアーキテクチャ（Utility First・!important禁止・cn()・Z-Index階層・CSS Containment・Container Queries）、コンポーネント設計原則（Co-location・Barrel Export禁止・Static Component）、React Hooks（Order Guarantee・Dependency Protocol・Compiler Readiness）、React 19 新API（Actions・useOptimistic・useFormStatus・use()・React Compiler v1.0）、Hydration/SSR安定性、フォーム設計（React Hook Form + Zod・Schema-Driven・Three-Point Sync）、高度フォームパターン（Auto-Save・Dynamic Form・useFieldArray Guard・DnD Overlay）、入力UX（inputMode・NFKC・IME Guard・iOS Zoom Defense）、バリデーション/セキュリティ（Anti-Spam・Turnstile・DTO Boundary）、State Management（Server/Client分離・Zustand/Jotai・URL State）、Data Fetching/Cache（Parallel Fetch・Public Cache FinOps・Resilient RSC）、パフォーマンス最適化（CWV Deployment Gate・Bundle Budget・Dynamic Library Decoupling）、画像/フォント/スクリプト最適化（next/image・AVIF First・next/font・next/script）、SEO/Metadata・Technical SEO/GEO（Speculative Rules API・IndexNow・GEO Strategy）、アクセシビリティ（WCAG 2.2 AA・EAA 2025・axe-core CI）、PWA/クロスプラットフォーム、i18n、エラーハンドリング（Error Boundary・Graceful Degradation）、Server Actions/API安全性、データ可視化/エクスポート、AdTech/マーケティング、テスト戦略（Testing Trophy・Vitest・Playwright・Lighthouse CI・Storybook）、デプロイ/インフラ（Vercel・ISR・Edge Config・CDN）、モダンWeb Platform API（View Transitions・CSS Anchor Positioning・Popover API・@starting-style・CSS Grid Masonry）、フロントエンド可観測性/RUM（OpenTelemetry Browser SDK・Session Replay）、AI統合/LLMストリーミングUI、Micro-Frontend/Module Federation 2.0、Web Worker/Off-Main-Thread（Comlink）、フロントエンドセキュリティ深化（Trusted Types・SRI・CSP Strict Dynamic）、フロントエンドFinOps、デザインシステム統合（Design Token・cva・Theme Switching）、禁止アンチパターン30選、Monorepo & Multi-App戦略（Turborepo）、リアルタイム通信（WebSocket/SSE/WebTransport）、認証UI & セッション管理（Passkey・Edge Middleware Guard）、Animation & Motion Design、レスポンシブ & マルチデバイス（Fluid Typography・dvh）、E-Commerceフロントエンド（Cart UI・PCI DSS）、フロントエンドDevOps（ESLint Flat Config・Biome・Pre-commit）、サードパーティスクリプト管理（Partytown・Consent-Aware Loading）、Sustainability & Green Frontend（SCI測定）、成熟度モデル5段階・将来展望（WebAssembly・WebGPU・AI-Native Frontend・Edge-First Architecture）。逆引き索引・クロスリファレンス付き。 |
| 310 | [310_headless_cms.md](./universal/engineering/310_headless_cms.md) | ヘッドレスCMS。**80パート・160セクション・131ルール構成**。CMS哲学（API-First・Content as Data・優先順位階層）、ヘッドレスアーキテクチャパターン、CMS選定・Composable DXP、コンテンツモデリング、Content Delivery/Management API、GraphQLガバナンス、Webhook、メディアストレージ、画像最適化、DAM統合、レンダリング戦略、CDN・エッジ配信、キャッシュ階層、リッチテキストエディタガバナンス、パブリッシングワークフロー、プレビュー戦略、動的ページビルダー、SEO自動化、AI-Readyコンテンツ、AI駆動オペレーション、Agentic CMS、CMSセキュリティ、コンテンツモデレーション、アクセシビリティ、多言語・翻訳ワークフロー、コンテンツパーソナライゼーション、Content as Code、CMS移行、リアルタイムコラボレーション、コンテンツA/Bテスト、Server-Driven UI、エディタ体験、CMSテスト戦略、コンテンツパイプライン自動化、マルチテナント、DR・BCP、規制コンプライアンス、GEO、Green IT、CMS可観測性・FinOps、成熟度モデル・アンチパターン40選。逆引き索引・クロスリファレンス付き。 |
| 400 | [400_mobile_flutter.md](./universal/engineering/400_mobile_flutter.md) | モバイルエンジニアリング（Flutter）。**55パート・265セクション構成**。哲学・Supreme Directive（UX忠実度>パフォーマンス>セキュリティ>コード再利用>開発速度）、テクノロジースタック標準（Flutter 3.41+・Dart 3.7+・Riverpod 3.0+・Impeller GA）、アーキテクチャ原則（Clean Architecture・レイヤード・フィーチャーベース・DI・SSOT）、Dart 3.7+言語規約（sealed class・パターンマッチング・Wildcard Variables・Extension Types・Records・Null安全）、非同期処理・Isolate、コード生成（build_runner・Macros廃止・Augmentations展望）、状態管理（Riverpod 3.0+ GA・統合Notifier API・コード生成ファースト・@riverpod・ref.watch/read絶対規則・Ref.mounted安全チェック・select粒度制御・等価ベース更新・自動リトライ・Pause/Resume・Freezed不変状態・Mutations コード生成不要化・**riverpod_lint必須**）、高度なRiverpodパターン（依存チェーン・スコープ・AsyncValue・ProviderContainer.test）、オフライン永続化（Experimental・riverpod_sqflite）、GoRouterナビゲーション（宣言的ルーティング・認証ガード・ディープリンク・Universal Links・App Links）、Clean Architectureパターン（UseCase・Entity・DTO・DataSource・Repository・キャッシュ・ページネーション）、DI・環境別設定（Flavor）、パフォーマンス（120fps or Die・constコンストラクタ・リビルド抑制・RepaintBoundary・ListView.builder）、Impellerレンダリング（iOS唯一レンダラー・Skia完全削除・AndroidオプトアウトF非推奨化・**Impeller専用DevTools 2026メトリクス**）、Widget Tree最適化・Sliver API、起動最適化（コールドスタート2秒以内・アプリサイズ30MB以下・Tree Shaking・難読化）、メモリ管理・プロファイリング、オフラインファースト（Drift・SQLCipher・SSOT・同期キュー）、ネットワーク（Dio・VIP Lane戦略・Exponential Backoff・Bearer Token・リトライ）、画像/メディア（cached_network_image・WebP・SVG・動画）、リアルタイム通信（WebSocket・SSE・Supabase Realtime）、プラットフォーム忠実度（Cupertino/Material使い分け・Cupertino Squircles・Pigeon型安全Platform Channel・FFI・ハプティクス）、レスポンシブ/アダプティブUI（AdaptiveScaffold）、Material 3デザインシステム（Design Token・テーマ・ダークモード）、アニメーション（Lottie・Rive・遷移）、フォーム・バリデーション・IME・検索、アクセシビリティ（**WCAG 2.2 AA**・Semantics・SemanticsRole API・TalkBack/VoiceOver・48dp最小タップ・**EU Accessibility Act 2025**）、セキュリティ（**OWASP MASVS Control Groups**・flutter_secure_storage・Certificate Pinning・--dart-define秘密管理）、RASP（freeRASP・Root/Jailbreak/改竄/エミュレータ検出）、AI・ML（ML Kit・TFLite・Gemini・AIエージェント）、テスト戦略（テストピラミッド・Golden Test・Maestro E2E・**patrol E2E新標準**・**alchemist Golden Test強化**・MobSF・カバレッジDomain90%/Data80%）、CI/CD・デプロイ（Fastlane・Firebase App Distribution・Shorebird OTA・デュアルトラック・**ロックファイル永続化**・**fastlane-plugin-shorebird**・段階的ロールアウト）、可観測性（Crashlytics/Sentry・Firebase Performance・Analytics・Remote Config）、マルチプラットフォーム（Flutter Web・Web Hot Reload・WebAssembly・Desktop・SBOM・Melos）、ガバナンス（i18n・プライバシー・App Store/Google Playコンプライアンス・グリーンエンジニアリング）、プッシュ通知アーキテクチャ（FCM/APNs・通知ペイロード・タップハンドリング・**flutter_local_notifications統合**・**冪等性message_id**）、認証・App Check（生体認証local_auth・Firebase App Check・ランタイム権限管理・**Passkeys/FIDO2**）、アプリライフサイクル・バックグラウンド処理（AppLifecycleListener・WorkManager・フォアグラウンドサービス）、IAP・アプリ更新（In-App Purchase・強制アップデート・アプリレビュー促進）、Dart FFI・Native Interop深化（dart:ffi・JNI・jnigen・Swift Interop・Native Build統合）、決済統合アーキテクチャ（Stripe・RevenueCat・PCI DSS・3DS・Apple Pay/Google Pay・Entitlementベース設計・税金通貨管理）、ローカル通知・スケジューリング（flutter_local_notifications・タイムゾーン対応・通知アクション・Deep Link連携）、ウィジェットテスト深化（Golden Test戦略・alchemist・インタラクションテスト・テストマトリクス・ビジュアルリグレッションCI）、エラーバウンダリ・Recovery UX（エラー分類4段階・ErrorBoundary Widget・Recovery UXパターン・クラッシュ後復旧）、Connectivity・ネットワークレジリエンス（connectivity_plus・オフラインキュー・リトライ戦略・Circuit Breaker・帯域適応）、アプリ内ナビゲーションUX設計（Bottom Navigation・BottomSheet・Drawer・ページ遷移・OverlayPortal）、構成管理・Feature Flag深化（Firebase Remote Config・段階的ロールアウト・キルスイッチ・技術的負債管理・緊急統制）、データプライバシー・同意管理深化（CMP・TCF 2.0・ATT・データ主体権利・プライバシーテスト）、モバイルDevOps・DX（FVM・build_runner最適化・Hot Reload・DevTools拡張・PR品質ゲート・ADR・Widget Catalog）、言語固有補遺・拡張アンチパターン（Dart 3.7+最新機能・メモリリーク防止・型安全パターン・コード品質メトリクス・CI自動化拡張）、成熟度モデル5段階・**アンチパターン50選**・FinOps基準値・将来展望（GenUI SDK・Impeller Desktop/Web・Dart Augmentations）。逆引き索引・クロスリファレンス付き。 |
| 410 | [410_native_platforms.md](./universal/engineering/410_native_platforms.md) | ネイティブプラットフォーム（Kotlin/Swift）。**20パート・80セクション構成**。Kotlin 2.x（K2コンパイラ・Guard Conditions・Sealed）、Swift 6（Strict Concurrency・Sendable・Actor・Typed Throws）、Androidアーキテクチャ（Jetpack Compose・MVI・Hilt・マルチモジュール）、iOSアーキテクチャ（SwiftUI・MVVM/TCA・SwiftData・Privacy Manifest・App Intents・WidgetKit）、KMP（commonMain最大化・Swift Export・段階的導入）、Jetpack Compose性能（Pausable Composition・Baseline Profiles・Strong Skipping）、SwiftUI（Preview-Driven・@Observable）、並行処理（Coroutines/Flow・Swift Concurrency・WorkManager・BGTaskScheduler）、パフォーマンス（起動500ms・120fps・HTTP/3・バッテリー最適化）、オンデバイスAI（Core ML・ML Kit・TFLite・MediaPipe・モデルOTA）、オフラインファースト（Room・SwiftData・SSOT・Delta Sync）、セキュリティ（No Secrets in Binary・RASP・Passkeys FIDO2・Play Integrity・App Attest・Certificate Pinning）、OS機能（Push・Deep Links・Widget・Bridge）、Flutter連携（Pigeon必須）、テスト（JUnit5・Swift Testing・Maestro・Macrobenchmark）、CI/CD（Staged Rollout）、アクセシビリティ（VoiceOver/TalkBack・WCAG 2.1 AA）、可観測性（Crashlytics・OpenTelemetry Mobile）、FinOps（ビルド15分以内・App Size 30MB以下）、成熟度モデル5段階・アンチパターン20選。逆引き索引・クロスリファレンス付き。 |


| # | ファイル | 概要 |
|---|---|---|
| 500 | [500_firebase_gcp.md](./universal/engineering/500_firebase_gcp.md) | バックエンドエンジニアリング（Firebase & GCP）。55パート・Rule 32.1〜32.169 + Appendix A〜D構成。Supreme Directives（補助エンジン原則・多層防御・冪等性・FinOps Guardian・Cloud Run統一）、Cloud Run Functions/Services/Jobs/GPU、Eventarc/Pub/Sub/Cloud Tasks、Firebase Auth（Passkeys/FIDO2）、App Check、Firestore（Enterprise Edition/Named Databases/MCP Server）、Data Connect、Cloud Storage、Firebase Hosting/App Hosting（GA）、FCM（HTTP v1 API）、Remote Config、Crashlytics、Performance Monitoring、Analytics、Firebase AI Logic/Genkit（Node.js GA/Go GA/Python Alpha）、Vertex AI/Agent Engine（A2A）、AI Agent セキュリティ & ガバナンス（MCP連携・EU AI Act）、BigQuery連携、セキュリティ多層防御（Zero Trust/OWASP 2025/Cloud Armor WAF）、IAM/WIF、Secret Manager（CMEK）、VPC（Direct VPC Egress/Private Service Connect）、FinOps & コスト最適化（AI FinOps・30%ルール）、予算アラート & 自動応答、Observability（OpenTelemetry）、エラーハンドリング（Circuit Breaker/DLQ）、Terraform/IaC、Firebase CLI、Emulator Suite、CI/CD（GitHub Actions/WIF）、環境管理、マルチリージョン & DR、API設計、Rate Limiting、キャッシング、バッチ処理 & データパイプライン、Google Maps最適化、Google Ecosystem統合、Firebase Studio、コンプライアンス（GDPR/CCPA等）、サプライチェーンセキュリティ（SBOM/Binary Authorization）、運用成熟度モデル（L1〜L5）、マイグレーション & 廃止、トラブルシューティング、言語固有セクション（Node.js TS/Go/Python）、アンチパターン30選、将来展望。 |
| 510 | [510_aws_cloud.md](./universal/engineering/510_aws_cloud.md) | AWSクラウドアーキテクチャ戦略。163セクション・260+ルール・20コードスニペット。§0コア・フィロソフィー（Directive 0.1〜0.12）を2026-05-04拡充：Platform Engineering（Golden Path/IDP）・Cost機能要件化（PRコスト評価Gate）・Agentic AIガバナンス（Bedrock最小権限/HitL）・データ主権&PQC準備（ML-KEM/Crypto Agility）。**[2026-05-04追加]** Directive 0.9（Resilience & Chaos Engineering：FIS障害注入・Multi-AZ必須・Graceful Degradation・ゲームデー義務）・0.10（Observability-First：Three Pillars義務化・SLOベースアラート・Observability as Code）・0.11（Compliance-by-Design：責任共有モデル明文化・Compliance as Code・データ分類義務・常時監査可能状態）・0.12（Ops Excellence Culture：ランブック義務・Blameless Postmortem・DORA 4指標・自動化90%目標）を追加。哲学レベルアンチパターン11選。サービス別逆引き索引（Appendix A）付き。 |
| 600 | [600_git_workflow.md](./universal/engineering/600_git_workflow.md) | **Git Workflow & Repository Hygiene（v1.3.2 新設）**。日常的な開発・通常作業・upload で発生するドメイン非依存の Git 操作を集約。**5パート・18ルール構成**：Trunk-Based Development（短命ブランチ・命名規約）、Commit & PR Standards（Conventional Commits/Atomic/PR Template/100行ルール/Husky/lint-staged）、Branch Hygiene Mandate（Garbage Collection/Stale tracking）、**Worktree Hygiene Protocol（worktreeConfig 残留問題・Antigravity Go ベース language server クラッシュ対策・Mandatory Cleanup Protocol・Automated Detection Script・並行AI Agent運用注意・再発履歴）**、Repository Hygiene & Config Integrity（`.git/config` Health Audit・AI Agent artifacts gitignore）。`scripts/check-git-config-clean.sh` と連動。クロスリファレンス（security/operations/quality 等の Git 利用）・逆引き索引付き。`engineering/000` Part X §10.0/§10.1（部分）/§10.3 から抽出。 |

#### ai/: AI・データ・分析

| # | ファイル | 概要 |
|---|---|---|
| 000 | [000_ai_engineering.md](./universal/ai/000_ai_engineering.md) | AI実装とUX戦略（48パート・150+セクション）。AI哲学・UXパターン（Chat/Copilot/Agent/Ambient/Proactive）、倫理・ガバナンス（EU AI Act準拠・グローバル規制マッピング・バイアス公平性）、コアアーキテクチャ（Private Relay・Model Router・Structured Output・ストリーミング・セマンティックキャッシング・プロンプトインジェクション多層防御）、RAGアーキテクチャ（GraphRAG・Hybrid Search・Reranking・評価フレームワーク）、Agentic AI（L1-L5自律性分類・MCP/A2A Protocol・マルチエージェント）、ガードレール多層モデル・ハルシネーション対策・Kill Switch、AI FinOps（30%ルール・トークン最適化）、マルチモーダル・エッジAI、LLMOps（PromptOps・モデルライフサイクル・LLM-as-Judge・AI可観測性）、成熟度モデル・アンチパターン20選。 |
| 100 | [100_data_analytics.md](./universal/ai/100_data_analytics.md) | 分析インテリジェンスとオブザーバビリティ（60パート/206セクション）。Event Taxonomy、プロダクトアナリティクス（NSM/AARRR）、A/Bテスト統計プロトコル（Bayesian/CUPED/Causal AI連携/Adaptive Experimentation）、プライバシーファースト分析（Privacy Sandbox廃止対応/IPA/データクリーンルーム）、GA4/BigQuery AI連携、CDP/ID統合、KPI/指標ガバナンス、ダッシュボード品質基準、Observability 5本柱（+Profiling）、OpenTelemetry 2026、分散トレーシング、RED/USEメトリクス、構造化ログ、Continuous Profiling、RUM/CWV/INP最適化、Synthetic Monitoring、APM、SLO駆動可観測性、AIOps 2.0/Agentic Observability、LLM/GenAI可観測性、データパイプライン可観測性、データ品質6次元、セキュリティ可観測性、コスト可観測性/FinOps Cloud+、Observability as Code、成熟度モデル・アンチパターン25選。 |

#### operations/: 運用・SRE・CS・FinOps

| # | ファイル | 概要 |
|---|---|---|
| 000 | [000_internal_tools.md](./universal/operations/000_internal_tools.md) | 管理運用と内部ツール。**50パート・231セクション・221ルール構成**。Supreme Directive「管理ツールは二級市民ではない」、Admin Excellence Culture、Build vs Buy戦略、管理ツールアーキテクチャ、管理ダッシュボード設計、UI/UX基準・Admin デザインシステム、アクセシビリティ、認証・認可アーキテクチャ（RBAC/ABAC/MFA/JITアクセス/Passkey）、セキュリティ強化（Zero Trust）、データプライバシー・GDPR管理画面対応、不変監査ログ、ユーザー管理、コンテンツ管理、ワークフロー自動化エンジン、AI統合・インテリジェント管理（Agentic AI L1-L5）、コンプライアンス自動化・GRC、FinOps、成熟度モデル5段階・アンチパターン20選。逆引き索引・クロスリファレンス付き。 |
| 300 | [300_customer_experience.md](./universal/operations/300_customer_experience.md) | ユーザーサポートとカスタマーサクセス（**40パート**・160+セクション）。サポート哲学、AIエージェント戦略（Agentic AI L1-L5/AI Copilot/MCP・A2A統合）、オムニチャネル設計、チケット管理・SLA、カスタマーサクセス戦略、Customer Health Score、オンボーディング設計、解約防止・リテンション、VoC・フィードバックループ、コンプライアンス・規制対応、Voice AI・会話型サポート、成熟度モデル（L1-L5）・逆引き索引。 |
| 400 | [400_site_reliability.md](./universal/operations/400_site_reliability.md) | SREと信頼性エンジニアリング。**55パート・166セクション構成**。Supreme Directive「Hope is not a strategy / Slow is the New Down」、SLI/SLO/SLA・エラーバジェット、可観測性（5本柱）、インシデント管理、デプロイメント戦略、カオスエンジニアリング、レジリエンスパターン、IaC・GitOps、Platform Engineering、AIOps（Agentic AI SRE L1-L5）、マルチリージョンDR、成熟度モデル・アンチパターン。逆引き索引・クロスリファレンス付き。 |
| 500 | [500_incident_response.md](./universal/operations/500_incident_response.md) | 危機管理とBCP（事業継続計画）。31パート構成。ISO 22301/NIST CSF 2.0/DORA準拠、BIA、インシデント対応体制、サイバーインシデント対応、AI駆動脅威対応、危機コミュニケーション、BCP・DR戦略、Blamelessポストモーテム、ガバナンス・RACI・KPI、成熟度モデル（5段階）。逆引き索引付き。 |
| 100 | [100_sales_bizdev.md](./universal/operations/100_sales_bizdev.md) | 営業・ビジネス開発（10パート・38セクション）**。Challenger Sale哲学（Teach/Tailor/Take Control）、Value Selling vs 機能説明禁止、Sales Funnel 8ステージ（MQL→SQL→SAL→Opportunity→Proposal→Negotiation→Closed）、MEDDIC資格確認フレームワーク（Champion3条件含む）、MEDDIC CRMスコアリング実装例、Cold Email 5要素200文字以内設計、5タッチシーケンス設計、Anti-Spam法令遵守（CAN-SPAM/GDPR/特定電子メール法）、デモ構成5ステップ・Discovery必須ヒアリング6項目、デモ禁止事項リスト、提案書8構成・PoC成功基準必須プロトコル（30日制限）、Mutual Close Plan、Win/Loss 6分類分析、Sales Playbook必須コンテンツ8項目、新入AE30日onboardingプログラム、BizDevとSalesの責任分界、パートナー評価フレームワーク（25点満点≥15点基準）、Technology Partnership設計原則。逆引き索引・クロスリファレンス付き。 |
| 200 | [200_hr_organization.md](./universal/operations/200_hr_organization.md) | 採用・組織設計（9パート・34セクション）**。Talent Density最大化（Netflix）、A PlayerはA Playerを採用原則、採用判断優先順位4層（Values>Learning>Attitude>Skills）、バーレイザーシステム（Amazon）、JD品質基準6セクション・YAMLロール定義テンプレート、報酬哲学（P75以上・給与バンド）、採用ファネル4週間以内完了・禁止事項（10ステップ超）、Referral Program設計、Structured Interview（全員同一質問）、STAR/ケース/Values/BackchannelReference組み合わせ、Debrief 4ルール（HiPPO禁止）、無意識の偏見4種と防止策、Verbal Offer First原則、90日Onboardingプログラム（Day1完全セットアップ必須）・Buddy制度、OKR設計原則（70%達成=良・全社公開義務）、1on1週1回30分・Listening Mode義務、Performance Review 3次元（What/How/Potential）・サプライズ禁止、Conway's Law対応、Team Topologies 4タイプ（Stream-Aligned/Enabling/Complicated/Platform）、管理範囲5〜8名上限、Remote-First 5原則（Async First/Doc First/Timezone Respect/Camera On/IRL Quarterly）。逆引き索引・クロスリファレンス付き。 |
| 700 | [700_partnership_ecosystem.md](./universal/operations/700_partnership_ecosystem.md) | パートナー・エコシステム戦略（9パート・34セクション）**。パートナーシップ3目的（Market Access/Product Extension/Credibility）・5類型（Technology/Channel/Strategic/Marketplace/Reseller）、Partnership Theaterアンチパターン定義、Ecosystem Flywheel設計（Salesforce AppExchange 7,000+アプリ事例）、Partnership Maturity Model5段階（Ad-hoc→Managed→Scalable→Ecosystem→Platform）、Coopetition管理原則、Integration Tier 3段階（Premier/Select/Registered）管理・統合品質基準YAMLスキーマ（OAuth2.0・HMAC署名必須）・廃止6ヶ月タイムライン、チャネルパートナー15〜30%マージン設計・Deal Registration5日以内登録・Channel Conflict防止ルール、戦略的アライアンス5条件・Joint GTM 5要素・四半期KPI評価、Developer Portal 8必須要素・Sandbox・Changelog、Indirect Network Effects設計、Partner Success 3指標（Activation/Productivity/NPS≥50）・パートナーライフサイクル管理・契約必須条項8項目、Marketplace構築判断基準（MAU≥50,000・Dev1,000+）・他社Marketplace掲載戦略・Revenue Sharing業界標準比較（Shopify/Apple/Google）。逆引き索引・クロスリファレンス付き。 |
| 600 | [600_cloud_finops.md](./universal/operations/600_cloud_finops.md) | Cloud FinOps — クラウドコスト最適化 & 財務運用。**25パート・57セクション構成**。FinOps Foundation Framework 2026（Cloud+ Scope）準拠。FOCUS v1.3仕様。FinOps哲学・6原則、CoE組織モデル、Executive Strategy Alignment、コスト可視化・配賦（Showback/Chargeback）、タギング標準、ユニットエコノミクス、ライトサイジング、コミットメント戦略（RI/SP/CUD）、Spot/Graviton戦略、ストレージ階層化、ネットワーク/Egress最適化、サーバーレスFinOps、DB FinOps（RDS/Aurora/DynamoDB/BigQuery）、AI/ML FinOps（30%ルールサーキットブレーカー）、Agentic AI FinOps（L1-L5成熟度・自律的最適化・OpenCost MCP Server）、LLMコスト最適化（モデルルーティング・セマンティックキャッシング・蒸留）、GPU/TPU最適化（MIG/MPS・Spot GPU）、K8s FinOps（OpenCost/Kubecost・VPA/HPA/KEDA・マルチテナント配賦）、SaaS/ライセンス管理（ITAM統合）、予算・予測・異常検知（ML駆動・多段階アラート）、Cloud Bankruptcy Prevention（多層防御・DDoSコスト攻撃対策）、Policy-as-Code（OPA/Sentinel/Kyverno・Governance-as-Code）、IaCコスト統合（Infracost・PRレビュー基準・ガードレール）、CDN/Edge/IoT FinOps、データパイプラインFinOps（ETL/ストリーミング）、マルチクラウド/マルチアカウント（FOCUS統合）、FinOps×Platform Engineering（Backstage統合・Golden Path）、セキュリティコスト最適化、GreenOps・サステナビリティ（SCI計算・carbon-aware-sdk・EU CSRD/SEC対応）、言語固有セクション（TypeScript/Terraform/Python/Go）、成熟度モデル5段階・ツールエコシステム・アンチパターン30選・将来展望。逆引き索引・クロスリファレンス付き。 |

#### security/: セキュリティ・法務・コンプライアンス

| # | ファイル | 概要 |
|---|---|---|
| 000 | [000_security_privacy.md](./universal/security/000_security_privacy.md) | セキュリティとプライバシー。**22セクション構成**。ゼロトラスト7柱（NIST 800-207準拠）、認証・認可（FIDO2/Social Login/Session管理）、APIセキュリティ（BOLA/BFLA/SSRF防止）、サプライチェーン（SBOM/SLSA）、AI/LLMセキュリティ（OWASP LLM Top 10 2025）、コンテナセキュリティ（Pod Security Standards/イメージ署名）、暗号化ポリシー（PQC準備）、OWASP Top 10 2025、GraphQL、シークレット管理、クライアントサイドセキュリティ、ボット/DDoS防御、セキュリティガバナンス。逆引き索引付き。 |
| 100 | [100_data_governance.md](./universal/security/100_data_governance.md) | 法務・ガバナンス・データ戦略。**45セクション構成**。グローバル規制マッピング（GDPR/CCPA/EU AI Act等14法）・2025-2027タイムライン・越境移転・同意管理・データガバナンス成熟度・RegTech自動化・量子暗号アジリティ。逆引き索引付き。 |
| 200 | [200_oss_compliance.md](./universal/security/200_oss_compliance.md) | ライセンスと依存関係管理。**49セクション・280+ルール・40+コードスニペット**。ライセンス三層分類・SBOM（CycloneDX 1.6/SPDX 3.0）・サプライチェーンセキュリティ（SLSA v1.1/Sigstore）・SCAツール統合・自動更新戦略・成熟度モデル。逆引き索引付き。 |
| 300 | [300_ip_due_diligence.md](./universal/security/300_ip_due_diligence.md) | 知的財産とExit戦略。**50セクション・10パート構成**。IP所有権・特許戦略・営業秘密・商標・著作権・AI生成物IP・Exit戦略・DD実務・ガバナンス・コンプライアンス。逆引き索引付き。 |

#### quality/: テスト・QA

| # | ファイル | 概要 |
|---|---|---|
| 000 | [000_qa_testing.md](./universal/quality/000_qa_testing.md) | QAとテスト戦略。**40セクション・12パート構成**。テスト哲学、テスト種別（静的/ユニット/統合/コントラクト/E2E/VRT/パフォーマンス/Property-Based/ミューテーション/a11y）、セキュリティ、テスト品質、CI/CD、リリース、ドメイン固有、レジリエンス、AI駆動テスト、データ&API品質、コンプライアンス&可観測性、成熟度モデル5段階。逆引き索引付き。 |

---


> **Status: Mutable（可変）** — プロジェクトのコンテキストに応じて作成・編集可能。
>
> Blueprint配下のファイル一覧・カテゴリ構成・運用ガイドは **Blueprint専用INDEX** を参照してください:
> - 🇯🇵 **[blueprint/INDEX.md](./blueprint/INDEX.md)** — 日本語版Blueprint索引
> - 🇺🇸 **[../en/blueprint/INDEX.md](./../en/blueprint/INDEX.md)** — English Blueprint Index
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
