# 要件対照表 (Compliance Matrix)

> [!CAUTION]
> **AIへの重要指示**
>
> *   **Layer 1: Universal Constitution (不変憲法)**: `1. Layer 1: Universal Rules` セクションに記載されているファイル（`universal/` 配下）は、**読み取り専用（Read-only）** です。AIはこれらのファイルを、いかなる場合もユーザーの明示的な許可（「憲法改正」の指示）なしに編集・変更してはなりません。`{lang}` は `AXIARCH.md` の `Project Native Language` に従い `ja` または `en` に置換してください。旧導入先では `AGENTS.md` をフォールバックとして参照します。
> *   **Layer 2: Blueprint (固有ルール/可変仕様)**: `2. Layer 2: Blueprint Rules` セクションに記載されているファイル（`blueprint/` 配下）は、プロジェクトごとにカスタマイズされるべき領域です。AIは要件と教訓に応じてこれらを積極的に提案・更新してください。

ユーザーの網羅的な要望（プロンプト）が、どのルールファイルでカバーされているかを証明する対照表です。

## 1. Layer 1: Universal Rules (不変の普遍憲法)
**Immutable / 編集禁止**

| ユーザー要望 | 対応ファイル | 具体的なルール |
| :--- | :--- | :--- |
| **プロジェクト言語での一貫した記述** | `universal/core/000_core_mindset.md` | "プロジェクト言語の一貫性" |
| **ユーザーファースト観点** | `universal/core/000_core_mindset.md` | "レベル2: ユーザー体験" |
| **創業者モード (Founder Mode)** | `universal/core/000_core_mindset.md` | "創業者モード (深掘り・バイパス)" |
| **人事観点** | `universal/product/000_product_strategy.md` | "人事の視点", "採用基準" |
| **収益化観点** | `universal/product/300_revenue_monetization.md` | "ユニットエコノミクス", "フリーミアムモデル" |
| **財務観点** | `universal/product/300_revenue_monetization.md` | "PL管理", "請求書発行" |
| **Google/Appleガイドライン** | `universal/product/700_appstore_compliance.md` | "ヒューマンインターフェースガイドライン" |
| **モバイルファースト観点** | `universal/design/000_design_ux.md` | "モバイルファースト戦略", "タッチ領域" |
| **UIアニメーション・パフォーマンス** | `universal/design/000_design_ux.md` | "60fpsターゲット", "ハプティクス" |
| **コード品質・クリーンコード** | `universal/engineering/000_engineering_standards.md` | "警告ゼロ", "言語ネイティブ命名", "公開API境界" |
| **プログラミング言語ガバナンス** | `universal/engineering/320_programming_language_governance.md` | "Universal適用契約", "支持区分", "フレームワークportfolio", "デスクトップ", "query／semantic／observability／infra DSL", "公開library／SDK／package", "source／binary／behavior互換性", "consumer matrix", "immutable配布", "generated SDK", "組織ownership", "notebook／literate computational artifact", "clean execution", "rich output", "production job", "team引継ぎ", "effective artifact", "継続経路", "ポリグロットCI", "廃止" |
| **React Nativeエンジニアリング** | `universal/engineering/420_react_native.md` | "Universal適用契約", "New Architecture", "両OS test", "OTA rollback", "Mobile Platform機能" |
| **クラウド・アプリケーションプラットフォーム** | `universal/engineering/520_cloud_application_platforms.md` | "Universal適用契約", "共有責任", "artifact／managed runtime lifecycle", "SDK・client interface lifecycle", "managed async・event delivery contract", "fidelity matrix", "managed環境へのconformance", "provider-managed integration／extension lifecycle", "service graph", "aggregate release record", "BaaS capability manifest", "identity portability", "FinOps", "退出戦略" |
| **DevSecOps・設計によるセキュリティ** | `universal/engineering/000_engineering_standards.md` | "ゼロトラスト", "設定の単一真実源", "環境変数ドリフト防止" |
| **技術的負債管理** | `universal/engineering/000_engineering_standards.md` | "risk-based capacity", "テックレーダー", "依存関係ガバナンス" |
| **AIファースト開発** | `universal/engineering/000_engineering_standards.md` | "PDD（プロンプト駆動開発）", "RAG最適化", "スキーマ信頼プロトコル" |
| **バグリスク低減ポリシー** | `universal/engineering/000_engineering_standards.md` | "risk-based欠陥triage", "重大欠陥の即時封じ込め", "Fix Twice" |
| **Git・バージョン管理** | `universal/engineering/600_git_workflow.md` | "Protected Reference Control", "review可能な変更", "ownershipと承認" |
| **ドキュメント運用** | `universal/engineering/000_engineering_standards.md` | "生きたドキュメント", "ADR義務", "ランブック" |
| **アーキテクチャ品質** | `universal/engineering/000_engineering_standards.md` | "Trinity DTO", "CQRS分離", "薄いコントローラー", "Feature Flagライフサイクル" |
| **費用・経費観点** | `universal/engineering/500_firebase_gcp.md` | "FinOps", "クラウド破産防止" |
| **WEB技術網羅 (CSS/BEM)** | `universal/engineering/300_web_frontend.md` | "CSSアーキテクチャ", "パフォーマンス" |
| **PDF/CSVエクスポート** | `universal/engineering/300_web_frontend.md` | "エクスポート機能" |
| **ネイティブアプリ技術網羅** | `universal/engineering/410_native_platforms.md` | "SwiftUI / Jetpack Compose" |
| **画像解析・音声認識・生体認証** | `universal/engineering/410_native_platforms.md` | "生体認証", "エッジAI" |
| **オフラインファースト** | `universal/engineering/410_native_platforms.md` | "オフラインアーキテクチャ" |
| **AI機能導入時の観点** | `universal/ai/000_ai_engineering.md` | "ストリーミングファースト", "楽観的UI" |
| **分析・解析・課題抽出** | `universal/ai/100_data_analytics.md` | "プライバシー重視の分析" |
| **管理画面運用観点** | `universal/operations/000_internal_tools.md` | "低コード/ノーコード優先検討", "監査ログ" |
| **お問い合わせ・FAQ観点** | `universal/operations/300_customer_experience.md` | "サポート哲学" |
| **ブラウザ・OS互換性** | `universal/operations/400_site_reliability.md` | "ブラウザ互換性" |
| **カオスエンジニアリング** | `universal/operations/400_site_reliability.md` | "カオスエンジニアリング" |
| **セキュリティ最優先** | `universal/security/000_security_privacy.md` | "レベル1: セキュリティ > UX" |
| **法務・法的観点** | `universal/security/100_data_governance.md` | "GDPR/Privacy Laws", "利用規約" |
| **利用規約・プライバシー観点** | `universal/security/100_data_governance.md` | "プライバシーポリシー", "データ最小化" |
| **ライセンス・プラグイン規約** | `universal/security/200_oss_compliance.md` | "ライセンスホワイトリスト" |
| **テスト観点** | `universal/quality/000_qa_testing.md` | "シフトレフトテスト", "Flakyテスト", "release topology", "partial deployment" |
| **グロース・マーケティング** | `universal/product/500_growth_marketing.md` | "グロースループ", "バイラル係数" |
| **API設計・マイクロサービス** | `universal/engineering/100_api_integration.md` | "APIファースト", "コントラクトテスト", "release topology", "independent／coordinated／aggregate" |
| **Supabaseアーキテクチャ** | `universal/engineering/200_supabase_architecture.md` | "デフォルトRLS", "エッジファンクション" |
| **ヘッドレスCMS** | `universal/engineering/310_headless_cms.md` | "コンテンツモデリング", "APIファーストCMS" |
| **Flutter/クロスプラットフォーム** | `universal/engineering/400_mobile_flutter.md` | "ウィジェットアーキテクチャ", "プラットフォームチャネル" |
| **AWSクラウド** | `universal/engineering/510_aws_cloud.md` | "Well-Architectedフレームワーク", "IaC" |
| **Microsoft Azureクラウド** | `universal/engineering/530_azure_cloud.md` | "Universal適用契約", "landing zone", "Microsoft Entra", "Azure Policy", "Custom Handler", "managed conformance", "exit plan" |
| **主要PaaS・BaaS・Edge・地域／主権cloud基盤** | `universal/engineering/520_cloud_application_platforms.md` | "Vercel", "Supabase", "Firebase", "Cloudflare", "AWS Amplify", "Appwrite", "Convex", "sovereign cloud", "Platform Engineering" |
| **インシデント対応** | `universal/operations/500_incident_response.md` | "インシデントコマンダー", "ブレームレスポストモーテム" |
| **知財デューデリジェンス** | `universal/security/300_ip_due_diligence.md` | "知財ポートフォリオ", "営業秘密保護" |
| **Cloud FinOps** | `universal/operations/600_cloud_finops.md` | "コスト最適化", "FinOpsライフサイクル" |
| **国際化・多言語対応** | `universal/product/800_internationalization.md` | "ICU MessageFormat", "BiDi/RTL" |
| **ガバナンス・ルール管理** | `universal/core/100_governance.md` | "SSOTアーキテクチャ", "改正プロセス" |
| **言語プロトコル** | `universal/core/200_language_protocol.md` | "ゼロトレランス", "プロジェクト言語ファースト" |

## 2. Layer 2: Blueprint Rules (動的成長する固有仕様)
**Mutable / 積極提案・更新推奨**

このセクションは、プロジェクト固有の要件を定義する「Blueprint」領域です。AIはここを積極的に参照し、提案・更新を行ってください。

| ユーザー要望 | 対応ファイル | 具体的なルール |
| :--- | :--- | :--- |
| **プロジェクト概要・基本アーキテクチャ** | `blueprint/core/000_project_overview.md` | "技術スタック", "ディレクトリ構造" |
| **プロジェクト固有の教訓・ログ** | `blueprint/core/010_project_lessons_log.md` | "コンテキストログ", "固有の制約" |
| **機能仕様テンプレート（Blueprint First）** | `blueprint/core/998_feature_spec_template.md` | "受け入れ条件", "Given/When/Then" |
| **その他プロジェクト固有の要件** | `blueprint/core/999_project_specific_template.md` | (必要に応じて) |

## 3. Layer 3: Prompts (任意実行エンジン)
**Optional (任意) / Mutable**

このセクションは、特定の高品質なタスクをAIエージェントに指示するための任意のプロンプトテンプレート集（`axiarch-prompts/`）を定義します。

| ユーザー要望 | 対応ファイル | 具体的なルール |
| :--- | :--- | :--- |
| **開発・実行系プロンプト活用** | `axiarch-prompts/*/develop/` | `feature_development`, `refactoring_audit`, `push_execute`, `ci_fix` |
| **品質・整合性監査プロンプト活用** | `axiarch-prompts/*/audit/` | `fullstack_qa_audit`, `api_architecture_audit`, `data_integrity_audit`, `system_integrity_audit`, `deep_optimization_audit` |
| **コンプライアンス・ガバナンスプロンプト活用** | `axiarch-prompts/*/govern/` | `governance_auditor`, `constitution_compliance_audit`, `compliance_inspector_audit`, `blueprint_governance_audit`, `localization_audit` |
| **インシデント・参入系プロンプト活用** | `axiarch-prompts/*/operate/` | `incident_response`, `onboarding_audit` |

**カバレッジ注記**:
このマトリクスは、一般的なエンジニアリング要件とルールファイルの対応関係を定義します。Universal Rules は汎用的な基準を網羅し、プロジェクト固有の要件は Blueprint で補完されることを前提とします。
