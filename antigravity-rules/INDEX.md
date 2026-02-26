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
antigravity-rules/
 ├── INDEX.md                  ← 本ファイル（全体索引）
 ├── README.md                 ← クイックリファレンス（リンク集）
 ├── compliance_matrix.md      ← 要件対照表
 ├── universal/                ← 不変ルール（憲法）
 │    ├── ja/                  ← 日本語版
 │    └── en/                  ← 英語版
 └── blueprint/                ← プロジェクト固有ルール（法律）
      ├── ja/
      └── en/
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
| 10 | [10_product_business.md](./universal/ja/10_product_business.md) | プロダクト・ビジネス戦略。MVP→PMF、収益化モデル（フリーミアム/サブスクリプション）、ユニットエコノミクス、法務コンプライアンス、レビュー・信頼性システム、タグベース検索設計。 |
| 11 | [11_business_finance.md](./universal/ja/11_business_finance.md) | 財務・収益化の詳細戦略。FinOps（コスト管理）、決済（Stripe）、ポイント経済圏、AIトークンエコノミクス、クーポン整合性、動的価格設計、税務・インボイス制度。 |
| 12 | [12_growth_marketing.md](./universal/ja/12_growth_marketing.md) | グロース・マーケティング戦略。PLG（プロダクト主導型成長）、SEO/GEO（AI検索最適化）、オンボーディング、リテンション、広告フィード連携、OGP動的生成、ファーストパーティデータ。 |
| 13 | [13_store_compliance.md](./universal/ja/13_store_compliance.md) | Apple App Store / Google Play のガイドライン準拠。IAP必須、プライバシーマニフェスト、ASO（ストア最適化）、申請前チェックリスト。 |

#### 20-29: デザイン・UX

| # | ファイル | 概要 |
|---|---|---|
| 20 | [20_design_ux.md](./universal/ja/20_design_ux.md) | デザインとUX戦略。モバイルファースト、アクセシビリティ、アニメーション（60fps）、タッチターゲット、デザインシステム、Pixel Perfectの基準。 |

#### 30-39: エンジニアリングコア

| # | ファイル | 概要 |
|---|---|---|
| 30 | [30_engineering_general.md](./universal/ja/30_engineering_general.md) | エンジニアリング全般。セルフチェックリスト、Zero Warnings、Tech Radar、CI/CD、Husky導入義務、コーディング規約。 |
| 31 | [31_mobile_flutter.md](./universal/ja/31_mobile_flutter.md) | モバイル開発（Flutter）。状態管理、パフォーマンス、プラットフォーム固有対応。 |
| 32 | [32_backend_firebase.md](./universal/ja/32_backend_firebase.md) | バックエンド（Firebase/GCP）。Cloud Functions、Firestore設計、セキュリティルール、FinOps。 |
| 33 | [33_web_frontend.md](./universal/ja/33_web_frontend.md) | Webフロントエンド（Next.js）。CSSアーキテクチャ、パフォーマンス最適化、PDF/CSVエクスポート、Server Components。 |
| 34 | [34_cms_headless.md](./universal/ja/34_cms_headless.md) | コンテンツ管理システム（Headless CMS）。コンテンツモデリング、API設計、プレビュー戦略。 |
| 35 | [35_api_integration.md](./universal/ja/35_api_integration.md) | API統合とマイクロサービス。RESTful設計、バージョニング、レート制限、エラーハンドリング。 |
| 36 | [36_native_platforms.md](./universal/ja/36_native_platforms.md) | ネイティブプラットフォーム（Kotlin/Swift）。SwiftUI/Jetpack Compose、生体認証、エッジAI、オフラインアーキテクチャ。 |
| 37 | [37_backend_supabase.md](./universal/ja/37_backend_supabase.md) | バックエンド・データ戦略（Supabase/PostgreSQL）。RLS、マイグレーション、Edge Functions、リアルタイム。 |

#### 40-49: AI・データ

| # | ファイル | 概要 |
|---|---|---|
| 40 | [40_ai_implementation.md](./universal/ja/40_ai_implementation.md) | AI実装とUX戦略。ストリーミングファースト、楽観的UI、ガードレール、RAG設計、トークンコスト管理。 |
| 41 | [41_analytics_intelligence.md](./universal/ja/41_analytics_intelligence.md) | 分析インテリジェンスとオブザーバビリティ。プライバシー重視の分析、GA4統合、カスタムイベント設計。 |

#### 50-59: 運用・管理

| # | ファイル | 概要 |
|---|---|---|
| 50 | [50_admin_tools.md](./universal/ja/50_admin_tools.md) | 管理運用と内部ツール。Retoolファースト、監査ログ、ダッシュボード設計、権限管理。 |
| 51 | [51_user_support.md](./universal/ja/51_user_support.md) | ユーザーサポートとカスタマーサクセス。サポート哲学、FAQ設計、チケット管理。 |
| 52 | [52_sre_reliability.md](./universal/ja/52_sre_reliability.md) | SREと信頼性エンジニアリング。可用性99.99%、ブラウザ互換性、カオスエンジニアリング、パフォーマンス監視。 |
| 53 | [53_crisis_management.md](./universal/ja/53_crisis_management.md) | 危機管理とBCP（事業継続計画）。インシデント対応フロー、障害復旧手順、コミュニケーション計画。 |

#### 60-69: セキュリティ・法務

| # | ファイル | 概要 |
|---|---|---|
| 60 | [60_security_privacy.md](./universal/ja/60_security_privacy.md) | セキュリティとプライバシー。OWASP Top 10対策、認証・認可、データ暗号化、GDPR/APPI準拠。 |
| 61 | [61_legal_data_privacy.md](./universal/ja/61_legal_data_privacy.md) | 法務・ガバナンス・データ戦略。利用規約、プライバシーポリシー、データ最小化、忘れられる権利。 |
| 62 | [62_license_dependency.md](./universal/ja/62_license_dependency.md) | ライセンスと依存関係管理。ライセンスホワイトリスト、脆弱性スキャン、アップデート戦略。 |
| 63 | [63_ip_due_diligence.md](./universal/ja/63_ip_due_diligence.md) | 知的財産とExit戦略。特許、商標、デューデリジェンス対応、IP資産管理。 |

#### 70-79: QA・グローバル

| # | ファイル | 概要 |
|---|---|---|
| 70 | [70_qa_testing.md](./universal/ja/70_qa_testing.md) | QAとテスト戦略。シフトレフトテスト、Flakyテスト対策、E2E/統合/ユニットテスト方針。 |
| 71 | [71_global_expansion.md](./universal/ja/71_global_expansion.md) | グローバル展開と国際化（i18n）。多言語対応、通貨・タイムゾーン、ローカライゼーション品質。 |
| 72 | [72_constitution_authority.md](./universal/ja/72_constitution_authority.md) | 憲法の権威と不変性。ルール改正手続き、優先順位の確定、ガバナンス構造の定義。 |
| 74 | [74_language_protocol.md](./universal/ja/74_language_protocol.md) | 言語プロトコル。日本語/英語の使い分けルール、バイリンガル文書基準。 |

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
antigravity-rules/
 ├── INDEX.md                  ← This file (master index)
 ├── README.md                 ← Quick reference (link collection)
 ├── compliance_matrix.md      ← Compliance matrix
 ├── universal/                ← Immutable rules (constitution)
 │    ├── ja/                  ← Japanese version
 │    └── en/                  ← English version
 └── blueprint/                ← Project-specific rules
      ├── ja/
      └── en/
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
| 10 | [10_product_business.md](./universal/en/10_product_business.md) | Product & business strategy. MVP→PMF, monetization models (freemium/subscription), unit economics, legal compliance, review/trust system, tag-based search design. |
| 11 | [11_business_finance.md](./universal/en/11_business_finance.md) | Finance & monetization details. FinOps (cost management), payments (Stripe), point economy, AI token economics, coupon integrity, dynamic pricing, tax/invoice compliance. |
| 12 | [12_growth_marketing.md](./universal/en/12_growth_marketing.md) | Growth & marketing strategy. PLG (Product-Led Growth), SEO/GEO (AI search optimization), onboarding, retention, ad feeds, dynamic OGP, first-party data. |
| 13 | [13_store_compliance.md](./universal/en/13_store_compliance.md) | Apple App Store / Google Play guideline compliance. IAP mandate, privacy manifests, ASO (App Store Optimization), pre-submission checklist. |

#### 20-29: Design & UX

| # | File | Summary |
|---|---|---|
| 20 | [20_design_ux.md](./universal/en/20_design_ux.md) | Design & UX strategy. Mobile-first, accessibility, animations (60fps), touch targets, design system, Pixel Perfect standards. |

#### 30-39: Engineering Core

| # | File | Summary |
|---|---|---|
| 30 | [30_engineering_general.md](./universal/en/30_engineering_general.md) | General engineering. Self-check list, Zero Warnings, Tech Radar, CI/CD, Husky mandate, coding standards. |
| 31 | [31_mobile_flutter.md](./universal/en/31_mobile_flutter.md) | Mobile engineering (Flutter). State management, performance, platform-specific handling. |
| 32 | [32_backend_firebase.md](./universal/en/32_backend_firebase.md) | Backend (Firebase/GCP). Cloud Functions, Firestore design, security rules, FinOps. |
| 33 | [33_web_frontend.md](./universal/en/33_web_frontend.md) | Web frontend (Next.js). CSS architecture, performance optimization, PDF/CSV export, Server Components. |
| 34 | [34_cms_headless.md](./universal/en/34_cms_headless.md) | Content Management System (Headless CMS). Content modeling, API design, preview strategy. |
| 35 | [35_api_integration.md](./universal/en/35_api_integration.md) | API integration & microservices. RESTful design, versioning, rate limiting, error handling. |
| 36 | [36_native_platforms.md](./universal/en/36_native_platforms.md) | Native platforms (Kotlin/Swift). SwiftUI/Jetpack Compose, biometrics, edge AI, offline architecture. |
| 37 | [37_backend_supabase.md](./universal/en/37_backend_supabase.md) | Backend & data strategy (Supabase/PostgreSQL). RLS, migrations, Edge Functions, realtime. |

#### 40-49: AI & Data

| # | File | Summary |
|---|---|---|
| 40 | [40_ai_implementation.md](./universal/en/40_ai_implementation.md) | AI implementation & UX strategy. Streaming-first, optimistic UI, guardrails, RAG design, token cost management. |
| 41 | [41_analytics_intelligence.md](./universal/en/41_analytics_intelligence.md) | Analytics intelligence & observability. Privacy-first analytics, GA4 integration, custom event design. |

#### 50-59: Operations & Admin

| # | File | Summary |
|---|---|---|
| 50 | [50_admin_tools.md](./universal/en/50_admin_tools.md) | Admin operations & internal tools. Retool-first, audit logs, dashboard design, permission management. |
| 51 | [51_user_support.md](./universal/en/51_user_support.md) | User support & customer success. Support philosophy, FAQ design, ticket management. |
| 52 | [52_sre_reliability.md](./universal/en/52_sre_reliability.md) | SRE & reliability engineering. 99.99% availability, browser compatibility, chaos engineering, performance monitoring. |
| 53 | [53_crisis_management.md](./universal/en/53_crisis_management.md) | Crisis management & BCP (Business Continuity Plan). Incident response flow, disaster recovery procedures, communication plan. |

#### 60-69: Security & Legal

| # | File | Summary |
|---|---|---|
| 60 | [60_security_privacy.md](./universal/en/60_security_privacy.md) | Security & privacy. OWASP Top 10, authentication/authorization, data encryption, GDPR/APPI compliance. |
| 61 | [61_legal_data_privacy.md](./universal/en/61_legal_data_privacy.md) | Legal, governance & data strategy. Terms of service, privacy policy, data minimization, right to be forgotten. |
| 62 | [62_license_dependency.md](./universal/en/62_license_dependency.md) | License & dependency management. License whitelist, vulnerability scanning, update strategy. |
| 63 | [63_ip_due_diligence.md](./universal/en/63_ip_due_diligence.md) | IP strategy & due diligence. Patents, trademarks, due diligence preparation, IP asset management. |

#### 70-79: QA & Global

| # | File | Summary |
|---|---|---|
| 70 | [70_qa_testing.md](./universal/en/70_qa_testing.md) | QA & testing strategy. Shift-left testing, flaky test prevention, E2E/integration/unit test policies. |
| 71 | [71_global_expansion.md](./universal/en/71_global_expansion.md) | Global expansion & i18n. Multi-language support, currency/timezone, localization quality. |
| 72 | [72_constitution_authority.md](./universal/en/72_constitution_authority.md) | Constitution authority & immutability. Amendment procedures, priority confirmation, governance structure. |
| 74 | [74_language_protocol.md](./universal/en/74_language_protocol.md) | Language protocol. Japanese/English usage rules, bilingual documentation standards. |

---

### 📐 Blueprint Rules (Project-Specific)

> **Status: Mutable** — Create and edit to define project-specific context.

| # | File | Summary |
|---|---|---|
| 00 | [00_project_overview.md](./blueprint/en/00_project_overview.md) | Project overview. Vision, tech stack, directory structure, immutable principles. |
| 01 | [01_project_lessons_log.md](./blueprint/en/01_project_lessons_log.md) | Project lessons log. Accumulated lessons and anti-patterns from development. **Highest priority for application.** |
| 99 | [99_project_specific_template.md](./blueprint/en/99_project_specific_template.md) | Template for adding new rule files. Boilerplate for new specifications. |
| — | [INDEX.md](./blueprint/en/INDEX.md) | Blueprint-specific index. Category numbering bands and operational guide. |
