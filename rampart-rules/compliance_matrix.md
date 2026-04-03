# Compliance Matrix / 要件対照表

> [!CAUTION]
> **AI Agent Controls / AIへの重要指示**
>
> ### 🇯🇵 日本語指示 (Japanese Instructions)
> *   **Universal Constitution (普遍憲法)**: `1. Rampart（ランパート）普遍憲法` セクションに記載されているファイル（`universal/*/` 配下）は、**読み取り専用（Read-only）** です。AIはこれらのファイルを、いかなる場合もユーザーの明示的な許可（「憲法改正」の指示）なしに編集・変更してはなりません。
> *   **Blueprint (固有ルール)**: `2. プロジェクト固有ルール` セクションに記載されているファイル（`blueprint/*/` 配下）は、プロジェクトごとにカスタマイズされるべき領域です。AIは要件に応じてこれらを積極的に提案・更新してください。
>
> ### 🇺🇸 English Instructions
> *   **Universal Constitution**: The files listed in the `1. Rampart Universal Constitution` section (under `universal/*/`) are **Read-only**. AI MUST NOT edit or modify these files under any circumstances without explicit user permission (instruction to "Amend Constitution").
> *   **Blueprint Rules**: The files listed in the `2. Project-Specific Blueprint Rules` section (under `blueprint/*/`) are the area to be customized for each project. AI SHOULD proactively propose and update these files according to requirements.

ユーザーの網羅的な要望（プロンプト）が、どのルールファイルでカバーされているかを証明する対照表です。
This matrix proves which rule files cover the user's comprehensive requests (prompts).

## 1. Rampart Universal Constitution (Rampart（ランパート）普遍憲法)
**Immutable / 編集禁止**

| ユーザー要望 (User Request) <br> [JP / EN] | 対応ファイル <br> (Covered In) | 具体的なルール (Specific Rule) <br> [JP / EN] |
| :--- | :--- | :--- |
| **全ての言語や説明は日本語** <br> All languages and descriptions in Japanese | `universal/*/000_core_mindset.md` | "絶対的な日本語の流暢さ" <br> "Absolute Japanese Fluency" |
| **ユーザーファースト観点** <br> User-First Perspective | `universal/*/000_core_mindset.md` | "レベル2: ユーザー体験" <br> "Level 2: User Experience" |
| **創業者モード (Founder Mode)** <br> Founder Mode | `universal/*/000_core_mindset.md` | "創業者モード (深掘り・バイパス)" <br> "Founder Mode (Deep Dive, Bypass)" |
| **人事観点** <br> HR Perspective | `universal/*/100_product_strategy.md` | "人事の視点", "採用基準" <br> "HR Perspective", "Hiring Bar" |
| **収益化観点** <br> Monetization Perspective | `universal/*/101_revenue_monetization.md` | "ユニットエコノミクス", "フリーミアムモデル" <br> "Unit Economics", "Freemium Model" |
| **財務観点** <br> Financial Perspective | `universal/*/101_revenue_monetization.md` | "PL管理", "請求書発行" <br> "PL Management", "Invoicing" |
| **Google/Appleガイドライン** <br> Google/Apple Guidelines | `universal/*/103_appstore_compliance.md` | "ヒューマンインターフェースガイドライン" <br> "Human Interface Guidelines" |
| **モバイルファースト観点** <br> Mobile-First Perspective | `universal/*/200_design_ux.md` | "モバイルファースト戦略", "タッチ領域" <br> "Mobile First Strategy", "Touch Targets" |
| **UIアニメーション・パフォーマンス** <br> UI Animation & Performance | `universal/*/200_design_ux.md` | "60fpsターゲット", "ハプティクス" <br> "60fps Target", "Haptics" |
| **コード品質・クリーンコード** <br> Code Quality & Clean Code | `universal/*/300_engineering_standards.md` | "警告ゼロ", "kebab-case統一", "Barrel File禁止" <br> "Zero Warnings", "kebab-case", "Barrel File Ban" |
| **DevSecOps・設計によるセキュリティ** <br> Security by Design (DevSecOps) | `universal/*/300_engineering_standards.md` | "ゼロトラスト", "設定の単一真実源", "環境変数ドリフト防止" <br> "Zero Trust", "Single Source of Config", "Env Drift Prevention" |
| **技術的負債管理** <br> Technical Debt Management | `universal/*/300_engineering_standards.md` | "スプリント20%負債返済", "テックレーダー", "依存関係ガバナンス" <br> "Sprint 20% Debt Paydown", "Tech Radar", "Dependency Governance" |
| **AIファースト開発** <br> AI-First Engineering | `universal/*/300_engineering_standards.md` | "PDD（プロンプト駆動開発）", "RAG最適化", "スキーマ信頼プロトコル" <br> "PDD", "RAG Optimization", "Schema Trust Protocol" |
| **ゼロバグ・ポリシー** <br> Zero Bug Policy | `universal/*/300_engineering_standards.md` | "24時間ルール", "二度直し原則" <br> "24-Hour Rule", "Fix Twice Principle" |
| **Git・バージョン管理** <br> Git & Version Control | `universal/*/300_engineering_standards.md` | "トランクベース開発", "Conventional Commits", "Git Hooks三層防御" <br> "Trunk Based Development", "Conventional Commits", "Git Hooks 3-Layer Defense" |
| **ドキュメント運用** <br> Documentation Ops | `universal/*/300_engineering_standards.md` | "生きたドキュメント", "ADR義務", "ランブック" <br> "Living Documentation", "ADR Mandate", "Runbook" |
| **アーキテクチャ品質** <br> Architecture Quality | `universal/*/300_engineering_standards.md` | "Trinity DTO", "CQRS分離", "薄いコントローラー", "Feature Flagライフサイクル" <br> "Trinity DTO", "CQRS Separation", "Thin Controller", "Feature Flag Lifecycle" |
| **費用・経費観点** <br> Cost & Expense Perspective | `universal/*/360_firebase_gcp.md` | "FinOps", "クラウド破産防止" <br> "FinOps", "Cloud Bankruptcy Prevention" |
| **WEB技術網羅 (CSS/BEM)** <br> Web Tech Coverage | `universal/*/340_web_frontend.md` | "CSSアーキテクチャ", "パフォーマンス" <br> "CSS Architecture", "Performance" |
| **PDF/CSVエクスポート** <br> PDF/CSV Export | `universal/*/340_web_frontend.md` | "エクスポート機能" <br> "Export Functionality" |
| **ネイティブアプリ技術網羅** <br> Native App Tech Coverage | `universal/*/343_native_platforms.md` | "SwiftUI / Jetpack Compose" <br> "SwiftUI/Jetpack Compose" |
| **画像解析・音声認識・生体認証** <br> Vision/Voice/Biometrics | `universal/*/343_native_platforms.md` | "生体認証", "エッジAI" <br> "Biometrics", "Edge AI" |
| **オフラインファースト** <br> Offline-First | `universal/*/343_native_platforms.md` | "オフラインアーキテクチャ" <br> "Offline Architecture" |
| **AI機能導入時の観点** <br> AI Implementation Perspective | `universal/*/400_ai_engineering.md` | "ストリーミングファースト", "楽観的UI" <br> "Streaming First", "Optimistic UI" |
| **分析・解析・課題抽出** <br> Analytics & Insights | `universal/*/401_data_analytics.md` | "プライバシー重視の分析" <br> "Privacy-First Analytics" |
| **管理画面運用観点** <br> Admin Operations Perspective | `universal/*/500_internal_tools.md` | "Retoolファースト", "監査ログ" <br> "Retool First", "Audit Logs" |
| **お問い合わせ・FAQ観点** <br> Support & FAQ Perspective | `universal/*/501_customer_experience.md` | "サポート哲学" <br> "Support Philosophy" |
| **ブラウザ・OS互換性** <br> Browser/OS Compatibility | `universal/*/502_site_reliability.md` | "ブラウザ互換性" <br> "Browser Compatibility" |
| **カオスエンジニアリング** <br> Chaos Engineering | `universal/*/502_site_reliability.md` | "カオスエンジニアリング" <br> "Chaos Engineering" |
| **セキュリティ最優先** <br> Security First | `universal/*/600_security_privacy.md` | "レベル1: セキュリティ > UX" <br> "Level 1: Security > UX" |
| **法務・法的観点** <br> Legal Perspective | `universal/*/601_data_governance.md` | "GDPR/個人情報保護法", "利用規約" <br> "GDPR/APPI", "Terms of Service" |
| **利用規約・プライバシー観点** <br> Terms & Privacy Perspective | `universal/*/601_data_governance.md` | "プライバシーポリシー", "データ最小化" <br> "Privacy Policy", "Data Minimization" |
| **ライセンス・プラグイン規約** <br> License/Plugin Rules | `universal/*/602_oss_compliance.md` | "ライセンスホワイトリスト" <br> "License Whitelist" |
| **テスト観点** <br> Testing Perspective | `universal/*/700_qa_testing.md` | "シフトレフトテスト", "Flakyテスト" <br> "Shift Left Testing", "Flaky Tests" |
| **グロース・マーケティング** <br> Growth & Marketing | `universal/*/102_growth_marketing.md` | "グロースループ", "バイラル係数" <br> "Growth Loops", "Viral Coefficient" |
| **API設計・マイクロサービス** <br> API Design & Microservices | `universal/*/301_api_integration.md` | "APIファースト", "コントラクトテスト" <br> "API First", "Contract Testing" |
| **Supabaseアーキテクチャ** <br> Supabase Architecture | `universal/*/320_supabase_architecture.md` | "デフォルトRLS", "エッジファンクション" <br> "RLS by Default", "Edge Functions" |
| **ヘッドレスCMS** <br> Headless CMS | `universal/*/341_headless_cms.md` | "コンテンツモデリング", "APIファーストCMS" <br> "Content Modeling", "API-First CMS" |
| **Flutter/クロスプラットフォーム** <br> Flutter / Cross-Platform | `universal/*/342_mobile_flutter.md` | "ウィジェットアーキテクチャ", "プラットフォームチャネル" <br> "Widget Architecture", "Platform Channels" |
| **AWSクラウド** <br> AWS Cloud | `universal/*/361_aws_cloud.md` | "Well-Architectedフレームワーク", "IaC" <br> "Well-Architected Framework", "IaC" |
| **インシデント対応** <br> Incident Response | `universal/*/503_incident_response.md` | "インシデントコマンダー", "ブレームレスポストモーテム" <br> "Incident Commander", "Blameless Postmortem" |
| **知財デューデリジェンス** <br> IP Due Diligence | `universal/*/603_ip_due_diligence.md` | "知財ポートフォリオ", "営業秘密保護" <br> "IP Portfolio", "Trade Secret Protection" |
| **Cloud FinOps** <br> Cloud FinOps | `universal/*/720_cloud_finops.md` | "コスト最適化", "FinOpsライフサイクル" <br> "Cost Optimization", "FinOps Lifecycle" |
| **国際化・多言語対応** <br> Internationalization & Localization | `universal/*/800_internationalization.md` | "ICU MessageFormat", "BiDi/RTL" <br> "ICU MessageFormat", "BiDi/RTL" |
| **ガバナンス・ルール管理** <br> Governance & Rule Management | `universal/*/801_governance.md` | "SSOTアーキテクチャ", "改正プロセス" <br> "SSOT Architecture", "Amendment Process" |
| **言語プロトコル** <br> Language Protocol | `universal/*/802_language_protocol.md` | "ゼロトレランス", "日本語ファースト" <br> "Zero Tolerance", "Japanese-First" |

## 2. Project-Specific Blueprint Rules (プロジェクト固有ルール)
**Mutable / 積極提案・更新推奨**

This section defines the "Blueprint" area for project-specific requirements. AI SHOULD proactively reference, propose, and update this section.
このセクションは、プロジェクト固有の要件を定義する「Blueprint」領域です。AIはここを積極的に参照し、提案・更新を行ってください。

| ユーザー要望 (User Request) <br> [JP / EN] | 対応ファイル <br> (Covered In) | 具体的なルール (Specific Rule) <br> [JP / EN] |
| :--- | :--- | :--- |
| **プロジェクト概要・基本アーキテクチャ** <br> Project Overview & Architecture | `blueprint/*/000_project_overview.md` | "技術スタック", "ディレクトリ構造" <br> "Tech Stack", "Directory Structure" |
| **プロジェクト固有の教訓・ログ** <br> Project Lessons Log | `blueprint/*/010_project_lessons_log.md` | "コンテキストログ", "固有の制約" <br> "Context Log", "Specific Constraints" |
| **その他プロジェクト固有の要件** <br> Other Specific Requirements | `blueprint/*/999_project_specific_template.md` | (As needed) |

## 3. Reusable Prompt Templates (再利用可能プロンプトテンプレート)
**Optional (任意) / Mutable**

This section defines the optional prompt templates used to instruct AI agents for specific high-quality tasks.
このセクションは、特定の高品質なタスクをAIエージェントに指示するための任意のプロンプトテンプレート集（`rampart-prompts/`）を定義します。

| ユーザー要望 (User Request) <br> [JP / EN] | 対応ファイル <br> (Covered In) | 具体的なルール (Specific Rule) <br> [JP / EN] |
| :--- | :--- | :--- |
| **再利用可能プロンプトの活用** <br> Reusable Prompt Utilization | `rampart-prompts/*/` | "Blueprint化監査", "品質保証監査" <br> "Blueprint Audit", "QA Audit" |

**Proof Complete / 証明完了**:
All user requests are completely covered by the rule files above.
ユーザーの全ての要望は、上記のルールファイル群によって完全に網羅されています。

