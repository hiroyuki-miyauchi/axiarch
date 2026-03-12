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

#### 00-09: コア・マインドセット

| # | ファイル | 概要 |
|---|---|---|
| 00 | [00_core_mindset.md](./universal/ja/00_core_mindset.md) | **最上位の行動原則。** 優先順位の階層（セキュリティ > UX > 収益性 > DX）、ゼロ・トレランス、Headless First、SSOT原則、対症療法の禁止、Git/デプロイ禁止プロトコル、既存機能保護、回帰バグ防止など、全ルールの基盤。 |

#### 10-19: ビジネス・成長戦略

| # | ファイル | 概要 |
|---|---|---|
| 10 | [10_product_business.md](./universal/ja/10_product_business.md) | プロダクト・ビジネス戦略。MVP→PMF、収益化モデル（フリーミアム/サブスクリプション）、ユニットエコノミクス、法務コンプライアンス、レビュー・信頼性システム（段階的信頼レベル・通報対応・UGC Rate Limit）、タグベース検索設計、インタラクティブエンジン。 |
| 11 | [11_business_finance.md](./universal/ja/11_business_finance.md) | 財務・収益化の詳細戦略。FinOps（コスト管理）、決済（Stripe）、ポイント経済圏、AIトークンエコノミクス、クーポン整合性、動的価格設計、価格A/Bテスト実験基盤、税務・インボイス制度。 |
| 12 | [12_growth_marketing.md](./universal/ja/12_growth_marketing.md) | グロース・マーケティング戦略。PLG（プロダクト主導型成長）、SEO/GEO（AI検索最適化）、オンボーディング、リテンション、広告フィード連携（ブランドセーフティ・Ads.txt）、OGP動的生成、ファーストパーティデータ、トラフィックリスク分散、KPI計測フレームワーク。 |
| 13 | [13_store_compliance.md](./universal/ja/13_store_compliance.md) | Apple App Store / Google Play のガイドライン準拠。IAP必須、プライバシーマニフェスト、ASO（ストア最適化）、申請前チェックリスト。 |

#### 20-29: デザイン・UX

| # | ファイル | 概要 |
|---|---|---|
| 20 | [20_design_ux.md](./universal/ja/20_design_ux.md) | デザインとUX戦略。モバイルファースト、アクセシビリティ（WCAG 2.1 AA詳細基準・Image Alt Text）、アニメーション（60fps）、タッチターゲット、デザインシステム、Pixel Perfect基準、おもてなしUX（Input Normalization・ロケール入力補助）、エラーページ設計基準、エラーメッセージUX基準、Ghost Contentプロトコル、リッチ選択UI、IME対応、i18n準備基準。 |

#### 30-39: エンジニアリングコア

| # | ファイル | 概要 |
|---|---|---|
| 30 | [30_engineering_general.md](./universal/ja/30_engineering_general.md) | エンジニアリング全般。セルフチェックリスト、Zero Warnings、Tech Radar、CI/CD、Husky導入義務、コーディング規約、オムニチャネル配信義務、DTO分割義務、マッパー堅牢性、マイグレーション静的解析、フィーチャーフラグ運用規律。 |
| 31 | [31_mobile_flutter.md](./universal/ja/31_mobile_flutter.md) | モバイル開発（Flutter）。状態管理、パフォーマンス、プラットフォーム固有対応。 |
| 32 | [32_firebase_architecture.md](./universal/ja/32_firebase_architecture.md) | バックエンド（Firebase/GCP）。Cloud Functions、Firestore設計、セキュリティルール、FinOps、RLS無限再帰防止、クライアントDB直接アクセス禁止。 |
| 33 | [33_web_frontend.md](./universal/ja/33_web_frontend.md) | Webフロントエンド（Next.js）。CSSアーキテクチャ、パフォーマンス最適化、PDF/CSVエクスポート、Server Components、パフォーマンス予算（CWVデプロイメントゲート・バンドルサイズ・画像サイズ・Lighthouse CI自動ゲート・デグレーション対応）、Tiered DBクライアント分離。 |
| 34 | [34_cms_headless.md](./universal/ja/34_cms_headless.md) | コンテンツ管理システム（Headless CMS）。コンテンツモデリング、API設計、プレビュー戦略（プレビュー認可・Dual Modeフェッチ）、パブリッシング信頼性（スケジューリング・ソフト404対策）。 |
| 35 | [35_api_integration.md](./universal/ja/35_api_integration.md) | API統合とマイクロサービス。RESTful設計、バージョニング、レート制限、エラーハンドリング、Server Action戻り値厳格化、安全失敗契約、CORSガバナンス、APIゲートウェイ使用量計測。 |
| 36 | [36_native_platforms.md](./universal/ja/36_native_platforms.md) | ネイティブプラットフォーム（Kotlin/Swift）。SwiftUI/Jetpack Compose、生体認証、エッジAI、オフラインアーキテクチャ。 |
| 37 | [37_supabase_architecture.md](./universal/ja/37_supabase_architecture.md) | Supabaseアーキテクチャ戦略。40セクション・138ルール・27クロスリファレンス。DB設計/RLS/Auth/Storage/Migration/Performance/Edge Functions/Realtime/Cron・Queues/Observability/pgvector・AI/Advanced Auth/Testing/Branching/PostgREST/CLI/Connection Pooling/Backup・DR/Rate Limiting/Vault/FDW/Data API Hardening/Multi-tenancy/pg_graphql/DB Functions・Triggers/Log Drain/Auth Hooks/Self-hosted・Email/SSR Integration/DB Extensions/Client SDK/Schema Design Patterns/Social Auth・SSO/Data Migration・Seeding。サービス別逆引き索引（Appendix A）付き。 |
| 38 | [38_aws_architecture.md](./universal/ja/38_aws_architecture.md) | AWSクラウドアーキテクチャ戦略。137セクション・220+ルール・14コードスニペット。Well-Architected基盤から全主要AWSサービスまで網羅（TGW/DirectConnect/Detective/AI-ML応用/Snow Family/Lex/WorkSpaces/MediaConvert含む）。サービス別逆引き索引（Appendix A）付き。 |

#### 40-49: AI・データ

| # | ファイル | 概要 |
|---|---|---|
| 40 | [40_ai_implementation.md](./universal/ja/40_ai_implementation.md) | AI実装とUX戦略。ストリーミングファースト、楽観的UI、ガードレール、RAG設計、トークンコスト管理、Human-in-the-Loop監視義務、マルチモーダルAI・エッジAI。 |
| 41 | [41_analytics_intelligence.md](./universal/ja/41_analytics_intelligence.md) | 分析インテリジェンスとオブザーバビリティ。プライバシー重視の分析、GA4統合、カスタムイベント設計、課題自動抽出、分析ダッシュボード品質基準。 |

#### 50-59: 運用・管理

| # | ファイル | 概要 |
|---|---|---|
| 50 | [50_admin_tools.md](./universal/ja/50_admin_tools.md) | 管理運用と内部ツール。Retoolファースト、監査ログ、ダッシュボード設計、権限管理、ラベルマッピング義務、データシーディング＆キャッシュ、管理者エスカレーション基準。 |
| 51 | [51_user_support.md](./universal/ja/51_user_support.md) | ユーザーサポートとカスタマーサクセス。サポート哲学、FAQ設計、チケット管理、メール送信基準（テンプレート構造・本文品質・送信元管理・監査スキーマ）。 |
| 52 | [52_sre_reliability.md](./universal/ja/52_sre_reliability.md) | SREと信頼性エンジニアリング。可用性99.99%、ブラウザ互換性、カオスエンジニアリング、パフォーマンス監視、定量アラート閾値基準、パフォーマンスベンチマーク、自動バックアップ検証、可観測性ダッシュボード、負荷テスト基準。 |
| 53 | [53_crisis_management.md](./universal/ja/53_crisis_management.md) | 危機管理とBCP（事業継続計画）。インシデント対応フロー、障害復旧手順、コミュニケーション計画、委託先障害連携プロトコル、インシデントランブック。 |

#### 60-69: セキュリティ・法務

| # | ファイル | 概要 |
|---|---|---|
| 60 | [60_security_privacy.md](./universal/ja/60_security_privacy.md) | セキュリティとプライバシー。16セクション構成。ゼロトラスト7柱（NIST 800-207準拠）、認証・認可（FIDO2/Social Login/Session管理）、APIセキュリティ（BOLA/BFLA/SSRF防止）、サプライチェーン（SBOM/SLSA）、AI/LLMセキュリティ（OWASP LLM Top 10 2025）、コンテナセキュリティ（Pod Security Standards/イメージ署名）、ファイルアップロードセキュリティ、暗号化ポリシー（禁止アルゴリズム/PQC準備）、OWASP Top 10 2025マッピング、委託先管理、インシデント対応。逆引き索引（Appendix A）付き。 |
| 61 | [61_legal_data_privacy.md](./universal/ja/61_legal_data_privacy.md) | 法務・ガバナンス・データ戦略。利用規約、プライバシーポリシー、データ最小化、忘れられる権利、反社会的勢力排除プロトコル、Cookie分類＆同意管理（CMP基準）、AI生成コンテンツ著作権、データライフサイクル管理、委託先データガバナンス。 |
| 62 | [62_license_dependency.md](./universal/ja/62_license_dependency.md) | ライセンスと依存関係管理。ライセンスホワイトリスト、脆弱性スキャン、アップデート戦略、依存関係選定基準。 |
| 63 | [63_ip_due_diligence.md](./universal/ja/63_ip_due_diligence.md) | 知的財産とExit戦略。特許、商標、デューデリジェンス対応、IP資産管理。 |

#### 70-79: QA・グローバル

| # | ファイル | 概要 |
|---|---|---|
| 70 | [70_qa_testing.md](./universal/ja/70_qa_testing.md) | QAとテスト戦略。シフトレフトテスト、Flakyテスト対策、E2E/統合/ユニットテスト方針、垂直同期プロトコル、将来用コード禁止、本番ビルド検証、タイムゾーン境界テスト。 |
| 71 | [71_global_expansion.md](./universal/ja/71_global_expansion.md) | グローバル展開と国際化（i18n）。多言語対応、通貨・タイムゾーン、ローカライゼーション品質、RTL対応、翻訳品質ゲート。 |
| 72 | [72_constitution_authority.md](./universal/ja/72_constitution_authority.md) | 憲法の権威と不変性。ルール改正手続き、優先順位の確定、ガバナンス構造の定義、疎番プロトコル、採番一意性、追記的進化プロトコル。 |
| 74 | [74_language_protocol.md](./universal/ja/74_language_protocol.md) | 言語プロトコル。日本語/英語の使い分けルール、バイリンガル文書基準、UI用語集策定義務、バリデーションメッセージローカライゼーション、ローカライゼーションCI自動スキャン、API応答言語ポリシー。 |

---

### 📐 Blueprint Rules（プロジェクト固有ルール / 法律）

> **Status: Mutable（可変）** — プロジェクトのコンテキストに応じて作成・編集可能。

| # | ファイル | 概要 |
|---|---|---|
| 00 | [00_project_overview.md](./blueprint/ja/00_project_overview.md) | プロジェクト概要。ビジョン、技術スタック、ディレクトリ構造、不変の原則。 |
| 01 | [01_project_lessons_log.md](./blueprint/ja/01_project_lessons_log.md) | プロジェクト教訓ログ。開発を通じて得られた教訓とアンチパターンの蓄積。**最優先で適用。** |
| 99 | [99_project_specific_template.md](./blueprint/ja/99_project_specific_template.md) | ルールファイル追加時のテンプレート。新規仕様書の雛形。 |
| — | [INDEX.md](./blueprint/ja/INDEX.md) | Blueprint 専用の索引。カテゴリ番号帯と運用ガイドを含む。 |

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

#### 00-09: Core & Mindset

| # | File | Summary |
|---|---|---|
| 00 | [00_core_mindset.md](./universal/en/00_core_mindset.md) | **Supreme behavioral principles.** Priority hierarchy (Security > UX > Profitability > DX), Zero Tolerance, Headless First, SSOT principle, band-aid solution ban, Git/deployment ban protocol, existing functionality protection, regression ban. |

#### 10-19: Business & Growth

| # | File | Summary |
|---|---|---|
| 10 | [10_product_business.md](./universal/en/10_product_business.md) | Product & business strategy. MVP→PMF, monetization models (freemium/subscription), unit economics, legal compliance, review/trust system (progressive trust levels, user reports, UGC rate limits), tag-based search design, interactive engine. |
| 11 | [11_business_finance.md](./universal/en/11_business_finance.md) | Finance & monetization details. FinOps (cost management), payments (Stripe), point economy, AI token economics, coupon integrity, dynamic pricing, pricing A/B test framework, tax/invoice compliance. |
| 12 | [12_growth_marketing.md](./universal/en/12_growth_marketing.md) | Growth & marketing strategy. PLG (Product-Led Growth), SEO/GEO (AI search optimization), onboarding, retention, ad feeds (brand safety, ads.txt), dynamic OGP, first-party data, traffic risk diversification, KPI measurement framework. |
| 13 | [13_store_compliance.md](./universal/en/13_store_compliance.md) | Apple App Store / Google Play guideline compliance. IAP mandate, privacy manifests, ASO (App Store Optimization), pre-submission checklist. |

#### 20-29: Design & UX

| # | File | Summary |
|---|---|---|
| 20 | [20_design_ux.md](./universal/en/20_design_ux.md) | Design & UX strategy. Mobile-first, accessibility (WCAG 2.1 AA detailed criteria, image alt text), animations (60fps), touch targets, design system, Pixel Perfect standards, Omotenashi UX (input normalization, locale input assistance), error page design, error message UX, Ghost Content protocol, rich selection UI, IME handling, i18n readiness. |

#### 30-39: Engineering Core

| # | File | Summary |
|---|---|---|
| 30 | [30_engineering_general.md](./universal/en/30_engineering_general.md) | General engineering. Self-check list, Zero Warnings, Tech Radar, CI/CD, Husky mandate, coding standards, omnichannel delivery mandate, DTO segregation, mapper robustness, migration static analysis, feature flag lifecycle. |
| 31 | [31_mobile_flutter.md](./universal/en/31_mobile_flutter.md) | Mobile engineering (Flutter). State management, performance, platform-specific handling. |
| 32 | [32_firebase_architecture.md](./universal/en/32_firebase_architecture.md) | Backend (Firebase/GCP). Cloud Functions, Firestore design, security rules, FinOps, RLS infinite recursion prevention, client DB direct access prohibition. |
| 33 | [33_web_frontend.md](./universal/en/33_web_frontend.md) | Web frontend (Next.js). CSS architecture, performance optimization, PDF/CSV export, Server Components, performance budget (CWV deployment gate, bundle size, image size, Lighthouse CI auto gate, regression response), tiered DB client separation. |
| 34 | [34_cms_headless.md](./universal/en/34_cms_headless.md) | Content Management System (Headless CMS). Content modeling, API design, preview strategy (preview gate, dual mode fetching), publishing reliability (scheduling, soft 404). |
| 35 | [35_api_integration.md](./universal/en/35_api_integration.md) | API integration & microservices. RESTful design, versioning, rate limiting, error handling, strict action return type, graceful failure contract, CORS governance, API gateway metering. |
| 36 | [36_native_platforms.md](./universal/en/36_native_platforms.md) | Native platforms (Kotlin/Swift). SwiftUI/Jetpack Compose, biometrics, edge AI, offline architecture. |
| 37 | [37_supabase_architecture.md](./universal/en/37_supabase_architecture.md) | Supabase architecture strategy. 40 sections, 138 rules, 27 cross-references. Comprehensive coverage: DB design/RLS/Auth/Storage/Migration/Performance/Edge Functions/Realtime/Cron・Queues/Observability/pgvector・AI/Advanced Auth/Testing/Branching/PostgREST/CLI/Connection Pooling/Backup・DR/Rate Limiting/Vault/FDW/Data API Hardening/Multi-tenancy/pg_graphql/DB Functions・Triggers/Log Drain/Auth Hooks/Self-hosted・Email/SSR Integration/DB Extensions/Client SDK/Schema Design Patterns/Social Auth・SSO/Data Migration・Seeding. Service Quick Reference Index (Appendix A). |
| 38 | [38_aws_architecture.md](./universal/en/38_aws_architecture.md) | AWS cloud architecture strategy. 137 sections, 220+ rules, 14 code snippets. Comprehensive coverage from Well-Architected to all major AWS services (including TGW/DirectConnect/Detective/Applied AI-ML/Snow Family/Lex/WorkSpaces/MediaConvert). Service Quick Reference Index (Appendix A). |

#### 40-49: AI & Data

| # | File | Summary |
|---|---|---|
| 40 | [40_ai_implementation.md](./universal/en/40_ai_implementation.md) | AI implementation & UX strategy. Streaming-first, optimistic UI, guardrails, RAG design, token cost management, Human-in-the-Loop supervision mandate, multimodal & edge AI. |
| 41 | [41_analytics_intelligence.md](./universal/en/41_analytics_intelligence.md) | Analytics intelligence & observability. Privacy-first analytics, GA4 integration, custom event design, automated issue extraction, analytics dashboard integrity protocol. |

#### 50-59: Operations & Admin

| # | File | Summary |
|---|---|---|
| 50 | [50_admin_tools.md](./universal/en/50_admin_tools.md) | Admin operations & internal tools. Retool-first, audit logs, dashboard design, permission management, label mapping mandate, data seeding & caching, admin escalation standards. |
| 51 | [51_user_support.md](./universal/en/51_user_support.md) | User support & customer success. Support philosophy, FAQ design, ticket management, email standards (template structure, body quality, sender identity governance, audit schema). |
| 52 | [52_sre_reliability.md](./universal/en/52_sre_reliability.md) | SRE & reliability engineering. 99.99% availability, browser compatibility, chaos engineering, performance monitoring, quantitative alert thresholds, performance benchmarks, automated backup verification, observability dashboard, load test protocol. |
| 53 | [53_crisis_management.md](./universal/en/53_crisis_management.md) | Crisis management & BCP (Business Continuity Plan). Incident response flow, disaster recovery procedures, communication plan, vendor incident coordination protocol, incident runbooks. |

#### 60-69: Security & Legal

| # | File | Summary |
|---|---|---|
| 60 | [60_security_privacy.md](./universal/en/60_security_privacy.md) | Security & privacy. 16-section architecture. Zero Trust 7 pillars (NIST 800-207), authentication/authorization (FIDO2/Social Login/Session management), API security (BOLA/BFLA/SSRF prevention), supply chain security (SBOM/SLSA), AI/LLM security (OWASP LLM Top 10 2025), container security (Pod Security Standards/image signing), file upload security, cryptographic policy (prohibited algorithms/PQC readiness), OWASP Top 10 2025 mapping, vendor management, incident response. Quick Reference Index (Appendix A). |
| 61 | [61_legal_data_privacy.md](./universal/en/61_legal_data_privacy.md) | Legal, governance & data strategy. Terms of service, privacy policy, data minimization, right to be forgotten, anti-social forces exclusion protocol, cookie classification & consent management (CMP standards), AI-generated content copyright, data lifecycle management, vendor data governance. |
| 62 | [62_license_dependency.md](./universal/en/62_license_dependency.md) | License & dependency management. License whitelist, vulnerability scanning, update strategy, dependency selection criteria. |
| 63 | [63_ip_due_diligence.md](./universal/en/63_ip_due_diligence.md) | IP strategy & due diligence. Patents, trademarks, due diligence preparation, IP asset management. |

#### 70-79: QA & Global

| # | File | Summary |
|---|---|---|
| 70 | [70_qa_testing.md](./universal/en/70_qa_testing.md) | QA & testing strategy. Shift-left testing, flaky test prevention, E2E/integration/unit test policies, vertical synchronization protocol, zero future-use code mandate, production build verification, timezone boundary testing. |
| 71 | [71_global_expansion.md](./universal/en/71_global_expansion.md) | Global expansion & i18n. Multi-language support, currency/timezone, localization quality, RTL support, translation quality gate. |
| 72 | [72_constitution_authority.md](./universal/en/72_constitution_authority.md) | Constitution authority & immutability. Amendment procedures, priority confirmation, governance structure, sparse numbering protocol, unique numbering, additive evolution protocol. |
| 74 | [74_language_protocol.md](./universal/en/74_language_protocol.md) | Language protocol. Japanese/English usage rules, bilingual documentation standards, UI terminology glossary mandate, validation message localization, localization CI scan, API response language policy. |

---

### 📐 Blueprint Rules (Project-Specific)

> **Status: Mutable** — Create and edit to define project-specific context.

| # | File | Summary |
|---|---|---|
| 00 | [00_project_overview.md](./blueprint/en/00_project_overview.md) | Project overview. Vision, tech stack, directory structure, immutable principles. |
| 01 | [01_project_lessons_log.md](./blueprint/en/01_project_lessons_log.md) | Project lessons log. Accumulated lessons and anti-patterns from development. **Highest priority for application.** |
| 99 | [99_project_specific_template.md](./blueprint/en/99_project_specific_template.md) | Template for adding new rule files. Boilerplate for new specifications. |
| — | [INDEX.md](./blueprint/en/INDEX.md) | Blueprint-specific index. Category numbering bands and operational guide. |
