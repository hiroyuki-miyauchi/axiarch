# Compliance Matrix / 要件対照表

> [!CAUTION]
> **AI Agent Controls / AIへの重要指示**
>
> ### 🇯🇵 日本語指示 (Japanese Instructions)
> *   **Universal Constitution (普遍憲法)**: `1. アンティグラビティ普遍憲法` セクションに記載されているファイル（`universal/*/` 配下）は、**読み取り専用（Read-only）** です。AIはこれらのファイルを、いかなる場合もユーザーの明示的な許可（「憲法改正」の指示）なしに編集・変更してはなりません。
> *   **Blueprint (固有ルール)**: `2. プロジェクト固有ルール` セクションに記載されているファイル（`blueprint/*/` 配下）は、プロジェクトごとにカスタマイズされるべき領域です。AIは要件に応じてこれらを積極的に提案・更新してください。
>
> ### 🇺🇸 English Instructions
> *   **Universal Constitution**: The files listed in the `1. Antigravity Universal Constitution` section (under `universal/*/`) are **Read-only**. AI MUST NOT edit or modify these files under any circumstances without explicit user permission (instruction to "Amend Constitution").
> *   **Blueprint Rules**: The files listed in the `2. Project-Specific Blueprint Rules` section (under `blueprint/*/`) are the area to be customized for each project. AI SHOULD proactively propose and update these files according to requirements.

This matrix proves which rule files cover the user's comprehensive requests (prompts).
ユーザーの網羅的な要望（プロンプト）が、どのルールファイルでカバーされているかを証明する対照表です。

## 1. Antigravity Universal Constitution (アンティグラビティ普遍憲法)
**Immutable / 編集禁止**

| ユーザー要望 (User Request) <br> [JP / EN] | 対応ファイル <br> (Covered In) | 具体的なルール (Specific Rule) <br> [EN / JP] |
| :--- | :--- | :--- |
| **全ての言語や説明は日本語** <br> All languages and descriptions in Japanese | `universal/*/00_core_mindset.md` | "Absolute Japanese Fluency" <br> "絶対的な日本語の流暢さ" |
| **ユーザーファースト観点** <br> User-First Perspective | `universal/*/00_core_mindset.md` | "Level 2: User Experience" <br> "レベル2: ユーザー体験" |
| **創業者モード (Founder Mode)** <br> Founder Mode | `universal/*/00_core_mindset.md` | "Founder Mode (Deep Dive, Bypass)" <br> "創業者モード (深掘り・バイパス)" |
| **人事観点** <br> HR Perspective | `universal/*/10_product_business.md` | "HR Perspective", "Hiring Bar" <br> "人事の視点", "採用基準" |
| **収益化観点** <br> Monetization Perspective | `universal/*/11_business_finance.md` | "Unit Economics", "Freemium Model" <br> "ユニットエコノミクス", "フリーミアムモデル" |
| **財務観点** <br> Financial Perspective | `universal/*/11_business_finance.md` | "PL Management", "Invoicing" <br> "PL管理", "請求書発行" |
| **Google/Appleガイドライン** <br> Google/Apple Guidelines | `universal/*/13_store_compliance.md` | "Human Interface Guidelines" <br> "ヒューマンインターフェースガイドライン" |
| **モバイルファースト観点** <br> Mobile-First Perspective | `universal/*/20_design_ux.md` | "Mobile First Strategy", "Touch Targets" <br> "モバイルファースト戦略", "タッチ領域" |
| **UIアニメーション・パフォーマンス** <br> UI Animation & Performance | `universal/*/20_design_ux.md` | "60fps Target", "Haptics" <br> "60fpsターゲット", "ハプティクス" |
| **セルフチェック** <br> Self-Check | `universal/*/30_engineering_general.md` | "Self-Check List", "Zero Warnings" <br> "セルフチェックリスト", "警告ゼロ" |
| **最新技術の取り込み** <br> Adopting Latest Tech | `universal/*/30_engineering_general.md` | "Tech Radar", "Continuous Learning" <br> "テックレーダー", "継続的学習" |
| **費用・経費観点** <br> Cost & Expense Perspective | `universal/*/32_firebase_architecture.md` | "FinOps", "Cloud Bankruptcy Prevention" <br> "FinOps", "クラウド破産防止" |
| **WEB技術網羅 (CSS/BEM)** <br> Web Tech Coverage | `universal/*/33_web_frontend.md` | "CSS Architecture", "Performance" <br> "CSSアーキテクチャ", "パフォーマンス" |
| **PDF/CSVエクスポート** <br> PDF/CSV Export | `universal/*/33_web_frontend.md` | "Export Functionality" <br> "エクスポート機能" |
| **ネイティブアプリ技術網羅** <br> Native App Tech Coverage | `universal/*/36_native_platforms.md` | "SwiftUI/Jetpack Compose" <br> "SwiftUI / Jetpack Compose" |
| **画像解析・音声認識・生体認証** <br> Vision/Voice/Biometrics | `universal/*/36_native_platforms.md` | "Biometrics", "Edge AI" <br> "生体認証", "エッジAI" |
| **オフラインファースト** <br> Offline-First | `universal/*/36_native_platforms.md` | "Offline Architecture" <br> "オフラインアーキテクチャ" |
| **AI機能導入時の観点** <br> AI Implementation Perspective | `universal/*/40_ai_implementation.md` | "Streaming First", "Optimistic UI" <br> "ストリーミングファースト", "楽観的UI" |
| **分析・解析・課題抽出** <br> Analytics & Insights | `universal/*/41_analytics_intelligence.md` | "Privacy-First Analytics" <br> "プライバシー重視の分析" |
| **管理画面運用観点** <br> Admin Operations Perspective | `universal/*/50_admin_tools.md` | "Retool First", "Audit Logs" <br> "Retoolファースト", "監査ログ" |
| **お問い合わせ・FAQ観点** <br> Support & FAQ Perspective | `universal/*/51_user_support.md` | "Support Philosophy" <br> "サポート哲学" |
| **ブラウザ・OS互換性** <br> Browser/OS Compatibility | `universal/*/52_sre_reliability.md` | "Browser Compatibility" <br> "ブラウザ互換性" |
| **カオスエンジニアリング** <br> Chaos Engineering | `universal/*/52_sre_reliability.md` | "Chaos Engineering" <br> "カオスエンジニアリング" |
| **セキュリティ最優先** <br> Security First | `universal/*/60_security_privacy.md` | "Level 1: Security > UX" <br> "レベル1: セキュリティ > UX" |
| **法務・法的観点** <br> Legal Perspective | `universal/*/61_legal_data_privacy.md` | "GDPR/APPI", "Terms of Service" <br> "GDPR/個人情報保護法", "利用規約" |
| **利用規約・プライバシー観点** <br> Terms & Privacy Perspective | `universal/*/61_legal_data_privacy.md` | "Privacy Policy", "Data Minimization" <br> "プライバシーポリシー", "データ最小化" |
| **ライセンス・プラグイン規約** <br> License/Plugin Rules | `universal/*/62_license_dependency.md` | "License Whitelist" <br> "ライセンスホワイトリスト" |
| **テスト観点** <br> Testing Perspective | `universal/*/70_qa_testing.md` | "Shift Left Testing", "Flaky Tests" <br> "シフトレフトテスト", "Flakyテスト" |

## 2. Project-Specific Blueprint Rules (プロジェクト固有ルール)
**Mutable / 積極提案・更新推奨**

This section defines the "Blueprint" area for project-specific requirements. AI SHOULD proactively reference, propose, and update this section.
このセクションは、プロジェクト固有の要件を定義する「Blueprint」領域です。AIはここを積極的に参照し、提案・更新を行ってください。

| ユーザー要望 (User Request) <br> [JP / EN] | 対応ファイル <br> (Covered In) | 具体的なルール (Specific Rule) <br> [EN / JP] |
| :--- | :--- | :--- |
| **プロジェクト概要・基本アーキテクチャ** <br> Project Overview & Architecture | `blueprint/*/00_project_overview.md` | "Tech Stack", "Directory Structure" <br> "技術スタック", "ディレクトリ構造" |
| **プロジェクト固有の教訓・ログ** <br> Project Lessons Log | `blueprint/*/01_project_lessons_log.md` | "Context Log", "Specific Constraints" <br> "コンテキストログ", "固有の制約" |
| **その他プロジェクト固有の要件** <br> Other Specific Requirements | `blueprint/*/99_project_specific_template.md` | (As needed) |

**Proof Complete / 証明完了**:
All user requests are completely covered by the rule files above.
ユーザーの全ての要望は、上記のルールファイル群によって完全に網羅されています。
