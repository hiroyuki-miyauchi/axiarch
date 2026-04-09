# Compliance Matrix / 要件対照表

> [!CAUTION]
> **AI Agent Controls / AIへの重要指示**
>
> ## 🇯🇵 日本語指示 (Japanese Instructions)
> *   **Layer 1: Universal Constitution (不変憲法)**: `1. Layer 1: Universal Rules` セクションに記載されているファイル（`universal/{lang}/` 配下）は、**読み取り専用（Read-only）** です。AIはこれらのファイルを、いかなる場合もユーザーの明示的な許可（「憲法改正」の指示）なしに編集・変更してはなりません。`{lang}` は `AGENTS.md` の `Project Native Language` に従い `ja` または `en` に置換してください。
> *   **Layer 2: Blueprint (固有ルール/可変仕様)**: `2. Layer 2: Blueprint Rules` セクションに記載されているファイル（`blueprint/{lang}/` 配下）は、プロジェクトごとにカスタマイズされるべき領域です。AIは要件と教訓に応じてこれらを積極的に提案・更新してください。
>
> ## 🇺🇸 English Instructions
> *   **Layer 1: Universal Constitution**: The files listed in the `1. Layer 1: Universal Rules` section (under `universal/{lang}/`) are **Read-only**. AI MUST NOT edit or modify these files under any circumstances without explicit user permission (instruction to "Amend Constitution"). Replace `{lang}` with `ja` or `en` based on the `Project Native Language` setting in `AGENTS.md`.
> *   **Layer 2: Blueprint Rules**: The files listed in the `2. Layer 2: Blueprint Rules` section (under `blueprint/{lang}/`) are the area to be customized for each project. AI SHOULD proactively propose and update these files according to requirements and lessons.

ユーザーの網羅的な要望（プロンプト）が、どのルールファイルでカバーされているかを証明する対照表です。
This matrix proves which rule files cover the user's comprehensive requests (prompts).

## 1. Layer 1: Universal Rules (不変の普遍憲法 / Immutable Constitution)
**Immutable / 編集禁止**

| ユーザー要望 (User Request) <br> [JP / EN] | 対応ファイル <br> (Covered In) | 具体的なルール (Specific Rule) <br> [JP / EN] |
| :--- | :--- | :--- |
| **プロジェクト言語での一貫した記述** <br> Consistent documentation in project language | `universal/*/000_core_mindset.md` | "プロジェクト言語の一貫性" <br> "Project Language Consistency" |
| **ユーザーファースト観点** <br> User-First Perspective | `universal/*/000_core_mindset.md` | "レベル2: ユーザー体験" <br> "Level 2: User Experience" |
| **創業者モード (Founder Mode)** <br> Founder Mode | `universal/*/000_core_mindset.md` | "創業者モード (深掘り・バイパス)" <br> "Founder Mode (Deep Dive, Bypass)" |
| **人事観点** <br> HR Perspective | `universal/*/000_product_strategy.md` | "人事の視点", "採用基準" <br> "HR Perspective", "Hiring Bar" |
| **収益化観点** <br> Monetization Perspective | `universal/*/300_revenue_monetization.md` | "ユニットエコノミクス", "フリーミアムモデル" <br> "Unit Economics", "Freemium Model" |
| **財務観点** <br> Financial Perspective | `universal/*/300_revenue_monetization.md` | "PL管理", "請求書発行" <br> "PL Management", "Invoicing" |
| **Google/Appleガイドライン** <br> Google/Apple Guidelines | `universal/*/700_appstore_compliance.md` | "ヒューマンインターフェースガイドライン" <br> "Human Interface Guidelines" |
| **モバイルファースト観点** <br> Mobile-First Perspective | `universal/*/000_design_ux.md` | "モバイルファースト戦略", "タッチ領域" <br> "Mobile First Strategy", "Touch Targets" |
| **UIアニメーション・パフォーマンス** <br> UI Animation & Performance | `universal/*/000_design_ux.md` | "60fpsターゲット", "ハプティクス" <br> "60fps Target", "Haptics" |
| **コード品質・クリーンコード** <br> Code Quality & Clean Code | `universal/*/000_engineering_standards.md` | "警告ゼロ", "kebab-case統一", "Barrel File禁止" <br> "Zero Warnings", "kebab-case", "Barrel File Ban" |
| **DevSecOps・設計によるセキュリティ** <br> Security by Design (DevSecOps) | `universal/*/000_engineering_standards.md` | "ゼロトラスト", "設定の単一真実源", "環境変数ドリフト防止" <br> "Zero Trust", "Single Source of Config", "Env Drift Prevention" |
| **技術的負債管理** <br> Technical Debt Management | `universal/*/000_engineering_standards.md` | "スプリント20%負債返済", "テックレーダー", "依存関係ガバナンス" <br> "Sprint 20% Debt Paydown", "Tech Radar", "Dependency Governance" |
| **AIファースト開発** <br> AI-First Engineering | `universal/*/000_engineering_standards.md` | "PDD（プロンプト駆動開発）", "RAG最適化", "スキーマ信頼プロトコル" <br> "PDD", "RAG Optimization", "Schema Trust Protocol" |
| **ゼロバグ・ポリシー** <br> Zero Bug Policy | `universal/*/000_engineering_standards.md` | "24時間ルール", "二度直し原則" <br> "24-Hour Rule", "Fix Twice Principle" |
| **Git・バージョン管理** <br> Git & Version Control | `universal/*/000_engineering_standards.md` | "トランクベース開発", "Conventional Commits", "Git Hooks三層防御" <br> "Trunk Based Development", "Conventional Commits", "Git Hooks 3-Layer Defense" |
| **ドキュメント運用** <br> Documentation Ops | `universal/*/000_engineering_standards.md` | "生きたドキュメント", "ADR義務", "ランブック" <br> "Living Documentation", "ADR Mandate", "Runbook" |
| **アーキテクチャ品質** <br> Architecture Quality | `universal/*/000_engineering_standards.md` | "Trinity DTO", "CQRS分離", "薄いコントローラー", "Feature Flagライフサイクル" <br> "Trinity DTO", "CQRS Separation", "Thin Controller", "Feature Flag Lifecycle" |
| **費用・経費観点** <br> Cost & Expense Perspective | `universal/*/500_firebase_gcp.md` | "FinOps", "クラウド破産防止" <br> "FinOps", "Cloud Bankruptcy Prevention" |
| **WEB技術網羅 (CSS/BEM)** <br> Web Tech Coverage | `universal/*/300_web_frontend.md` | "CSSアーキテクチャ", "パフォーマンス" <br> "CSS Architecture", "Performance" |
| **PDF/CSVエクスポート** <br> PDF/CSV Export | `universal/*/300_web_frontend.md` | "エクスポート機能" <br> "Export Functionality" |
| **ネイティブアプリ技術網羅** <br> Native App Tech Coverage | `universal/*/410_native_platforms.md` | "SwiftUI / Jetpack Compose" <br> "SwiftUI/Jetpack Compose" |
| **画像解析・音声認識・生体認証** <br> Vision/Voice/Biometrics | `universal/*/410_native_platforms.md` | "生体認証", "エッジAI" <br> "Biometrics", "Edge AI" |
| **オフラインファースト** <br> Offline-First | `universal/*/410_native_platforms.md` | "オフラインアーキテクチャ" <br> "Offline Architecture" |
| **AI機能導入時の観点** <br> AI Implementation Perspective | `universal/*/000_ai_engineering.md` | "ストリーミングファースト", "楽観的UI" <br> "Streaming First", "Optimistic UI" |
| **分析・解析・課題抽出** <br> Analytics & Insights | `universal/*/100_data_analytics.md` | "プライバシー重視の分析" <br> "Privacy-First Analytics" |
| **管理画面運用観点** <br> Admin Operations Perspective | `universal/*/000_internal_tools.md` | "低コード/ノーコード優先検討", "監査ログ" <br> "Low-code/No-code First Evaluation", "Audit Logs" |
| **お問い合わせ・FAQ観点** <br> Support & FAQ Perspective | `universal/*/300_customer_experience.md` | "サポート哲学" <br> "Support Philosophy" |
| **ブラウザ・OS互換性** <br> Browser/OS Compatibility | `universal/*/400_site_reliability.md` | "ブラウザ互換性" <br> "Browser Compatibility" |
| **カオスエンジニアリング** <br> Chaos Engineering | `universal/*/400_site_reliability.md` | "カオスエンジニアリング" <br> "Chaos Engineering" |
| **セキュリティ最優先** <br> Security First | `universal/*/000_security_privacy.md` | "レベル1: セキュリティ > UX" <br> "Level 1: Security > UX" |
| **法務・法的観点** <br> Legal Perspective | `universal/*/100_data_governance.md` | "GDPR/個人情報保護法", "利用規約" <br> "GDPR/APPI", "Terms of Service" |
| **利用規約・プライバシー観点** <br> Terms & Privacy Perspective | `universal/*/100_data_governance.md` | "プライバシーポリシー", "データ最小化" <br> "Privacy Policy", "Data Minimization" |
| **ライセンス・プラグイン規約** <br> License/Plugin Rules | `universal/*/200_oss_compliance.md` | "ライセンスホワイトリスト" <br> "License Whitelist" |
| **テスト観点** <br> Testing Perspective | `universal/*/000_qa_testing.md` | "シフトレフトテスト", "Flakyテスト" <br> "Shift Left Testing", "Flaky Tests" |
| **グロース・マーケティング** <br> Growth & Marketing | `universal/*/500_growth_marketing.md` | "グロースループ", "バイラル係数" <br> "Growth Loops", "Viral Coefficient" |
| **API設計・マイクロサービス** <br> API Design & Microservices | `universal/*/100_api_integration.md` | "APIファースト", "コントラクトテスト" <br> "API First", "Contract Testing" |
| **Supabaseアーキテクチャ** <br> Supabase Architecture | `universal/*/200_supabase_architecture.md` | "デフォルトRLS", "エッジファンクション" <br> "RLS by Default", "Edge Functions" |
| **ヘッドレスCMS** <br> Headless CMS | `universal/*/310_headless_cms.md` | "コンテンツモデリング", "APIファーストCMS" <br> "Content Modeling", "API-First CMS" |
| **Flutter/クロスプラットフォーム** <br> Flutter / Cross-Platform | `universal/*/400_mobile_flutter.md` | "ウィジェットアーキテクチャ", "プラットフォームチャネル" <br> "Widget Architecture", "Platform Channels" |
| **AWSクラウド** <br> AWS Cloud | `universal/*/510_aws_cloud.md` | "Well-Architectedフレームワーク", "IaC" <br> "Well-Architected Framework", "IaC" |
| **インシデント対応** <br> Incident Response | `universal/*/500_incident_response.md` | "インシデントコマンダー", "ブレームレスポストモーテム" <br> "Incident Commander", "Blameless Postmortem" |
| **知財デューデリジェンス** <br> IP Due Diligence | `universal/*/300_ip_due_diligence.md` | "知財ポートフォリオ", "営業秘密保護" <br> "IP Portfolio", "Trade Secret Protection" |
| **Cloud FinOps** <br> Cloud FinOps | `universal/*/600_cloud_finops.md` | "コスト最適化", "FinOpsライフサイクル" <br> "Cost Optimization", "FinOps Lifecycle" |
| **国際化・多言語対応** <br> Internationalization & Localization | `universal/*/800_internationalization.md` | "ICU MessageFormat", "BiDi/RTL" <br> "ICU MessageFormat", "BiDi/RTL" |
| **ガバナンス・ルール管理** <br> Governance & Rule Management | `universal/*/100_governance.md` | "SSOTアーキテクチャ", "改正プロセス" <br> "SSOT Architecture", "Amendment Process" |
| **言語プロトコル** <br> Language Protocol | `universal/*/200_language_protocol.md` | "ゼロトレランス", "プロジェクト言語ファースト" <br> "Zero Tolerance", "Project Language-First" |

## 2. Layer 2: Blueprint Rules (動的成長する固有仕様 / Mutable Project State)
**Mutable / 積極提案・更新推奨**

このセクションは、プロジェクト固有の要件を定義する「Blueprint」領域です。AIはここを積極的に参照し、提案・更新を行ってください。
This section defines the "Blueprint" area for project-specific requirements. AI SHOULD proactively reference, propose, and update this section.

| ユーザー要望 (User Request) <br> [JP / EN] | 対応ファイル <br> (Covered In) | 具体的なルール (Specific Rule) <br> [JP / EN] |
| :--- | :--- | :--- |
| **プロジェクト概要・基本アーキテクチャ** <br> Project Overview & Architecture | `blueprint/*/core/000_project_overview.md` | "技術スタック", "ディレクトリ構造" <br> "Tech Stack", "Directory Structure" |
| **プロジェクト固有の教訓・ログ** <br> Project Lessons Log | `blueprint/*/core/010_project_lessons_log.md` | "コンテキストログ", "固有の制約" <br> "Context Log", "Specific Constraints" |
| **その他プロジェクト固有の要件** <br> Other Specific Requirements | `blueprint/*/core/999_project_specific_template.md` | (As needed) |

## 3. Layer 3: Prompts (任意実行エンジン / Optional Execution Engine)
**Optional (任意) / Mutable**

このセクションは、特定の高品質なタスクをAIエージェントに指示するための任意のプロンプトテンプレート集（`axiarch-prompts/`）を定義します。
This section defines the optional prompt templates used to instruct AI agents for specific high-quality tasks.

| ユーザー要望 (User Request) <br> [JP / EN] | 対応ファイル <br> (Covered In) | 具体的なルール (Specific Rule) <br> [JP / EN] |
| :--- | :--- | :--- |
| **開発・実行系プロンプト活用** <br> Development & Execution Prompts | `axiarch-prompts/*/develop/` | `feature_development`, `refactoring_audit`, `push_execute`, `ci_fix` |
| **品質・整合性監査プロンプト活用** <br> Quality & Integrity Audit Prompts | `axiarch-prompts/*/audit/` | `fullstack_qa_audit`, `api_architecture_audit`, `data_integrity_audit`, `system_integrity_audit`, `deep_optimization_audit` |
| **コンプライアンス・ガバナンスプロンプト活用** <br> Compliance & Governance Prompts | `axiarch-prompts/*/govern/` | `governance_auditor`, `constitution_compliance_audit`, `compliance_inspector_audit`, `blueprint_governance_audit`, `localization_audit` |
| **インシデント・参入系プロンプト活用** <br> Incident Response & Onboarding Prompts | `axiarch-prompts/*/operate/` | `incident_response`, `onboarding_audit` |

**Compliance Coverage Note**:
This matrix defines the mapping between common engineering request types and the corresponding rule files.
Universal Rules cover general engineering standards; project-specific requirements are supplemented via Blueprint.
このマトリクスは、一般的なエンジニアリング要件とルールファイルの対応関係を定義します。Universal Rules は汎用的な基準を網羅し、プロジェクト固有の要件は Blueprint で補完されることを前提とします。
