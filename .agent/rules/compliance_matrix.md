# Compliance Matrix / 要件対照表

> [!IMPORTANT]
> **AI Agent Controls / AIへの重要指示**
>
> ### 🇺🇸 English Instructions
> *   **Universal Constitution** (`universal/`): **Read-only**. AI MUST NOT edit without explicit "Amend Constitution" instruction.
> *   **Blueprint Rules** (`blueprint/`): **Mutable**. AI SHOULD proactively propose and update.
>
> ### 🇯🇵 日本語指示
> *   **Universal Constitution** (`universal/`): **読み取り専用**。「憲法改正」の指示なしに編集禁止。
> *   **Blueprint Rules** (`blueprint/`): **可変**。積極的に提案・更新すること。

This matrix maps user requests to the rule files that cover them.
ユーザーの要望がどのルールファイルでカバーされているかを示す対照表です。

---

## 1. Antigravity Universal Constitution / 普遍憲法
**Immutable / 編集禁止**

Files are located under `universal/` with 3-digit numbering. (Source: `ja/` and `en/` — choose one during setup.)
ファイルは `universal/` 配下に3桁番号で配置。（ソース: `ja/` と `en/` — セットアップ時に選択）

| User Request / ユーザー要望 | Files (3-digit range) | Specific Rules / 具体的なルール |
| :--- | :--- | :--- |
| All languages in Japanese / 全ての説明は日本語 | `000-003` | Absolute Japanese Fluency / 絶対的な日本語の流暢さ |
| User-First Perspective / ユーザーファースト | `000-003` | Level 2: User Experience / レベル2: ユーザー体験 |
| Founder Mode / 創業者モード | `000-003` | Founder Mode (Deep Dive) / 創業者モード（深掘り） |
| HR Perspective / 人事観点 | `100-101` | HR Perspective, Hiring Bar / 人事の視点, 採用基準 |
| Monetization / 収益化観点 | `110-112` | Unit Economics, Freemium / ユニットエコノミクス, フリーミアム |
| Financial Perspective / 財務観点 | `110-112` | PL Management, Invoicing / PL管理, 請求書発行 |
| Google/Apple Guidelines / ストアガイドライン | `130` | Human Interface Guidelines / ヒューマンインターフェースガイドライン |
| Mobile-First / モバイルファースト | `200-204` | Mobile First, Touch Targets / モバイルファースト, タッチ領域 |
| UI Animation & Performance / アニメーション | `200-204` | 60fps Target, Haptics / 60fpsターゲット, ハプティクス |
| Self-Check / セルフチェック | `300-315` | Self-Check List, Zero Warnings / セルフチェックリスト, 警告ゼロ |
| Latest Tech / 最新技術 | `300-315` | Tech Radar, Continuous Learning / テックレーダー, 継続的学習 |
| Cost & Expenses / 費用・経費 | `316, 370-378` | FinOps, Cloud Bankruptcy Prevention / FinOps, クラウド破産防止 |
| Web Tech (CSS/BEM) / WEB技術 | `320-335` | CSS Architecture, Performance / CSSアーキテクチャ, パフォーマンス |
| PDF/CSV Export / エクスポート | `320-335` | Export Functionality / エクスポート機能 |
| Native App Tech / ネイティブアプリ | `360` | SwiftUI/Jetpack Compose |
| Vision/Voice/Biometrics / 画像・音声・生体 | `360` | Biometrics, Edge AI / 生体認証, エッジAI |
| Offline-First / オフラインファースト | `360` | Offline Architecture / オフラインアーキテクチャ |
| AI Implementation / AI機能 | `400-401` | Streaming First, Optimistic UI / ストリーミングファースト, 楽観的UI |
| Analytics / 分析・解析 | `410` | Privacy-First Analytics / プライバシー重視の分析 |
| Admin Operations / 管理画面 | `500-501` | Retool First, Audit Logs / Retoolファースト, 監査ログ |
| Support & FAQ / お問い合わせ | `510` | Support Philosophy / サポート哲学 |
| Browser/OS Compatibility / 互換性 | `520-522` | Browser Compatibility / ブラウザ互換性 |
| Chaos Engineering / カオスエンジニアリング | `520-522` | Chaos Engineering |
| Security First / セキュリティ最優先 | `600-606` | Level 1: Security > UX / レベル1: セキュリティ > UX |
| Legal / 法務・法的観点 | `610` | GDPR/APPI, Terms of Service / GDPR/個人情報保護法, 利用規約 |
| Privacy / プライバシー | `610` | Privacy Policy, Data Minimization / プライバシーポリシー, データ最小化 |
| License/Plugin Rules / ライセンス規約 | `620` | License Whitelist / ライセンスホワイトリスト |
| Testing / テスト観点 | `700-701` | Shift Left Testing, Flaky Tests / シフトレフトテスト, Flakyテスト |

---

## 2. Project-Specific Blueprint Rules / プロジェクト固有ルール
**Mutable / 積極提案・更新推奨**

AI SHOULD proactively reference, propose, and update this section.
AIはここを積極的に参照し、提案・更新を行ってください。

| User Request / ユーザー要望 | File | Specific Rules / 具体的なルール |
| :--- | :--- | :--- |
| Project Overview & Architecture / 概要 | `000_project_overview.md` | Tech Stack, Directory Structure / 技術スタック, ディレクトリ構造 |
| Lessons Log / 教訓ログ | `001_project_lessons_log.md` | Context Log, Constraints / コンテキストログ, 固有の制約 |
| Other Requirements / その他固有要件 | `999_project_specific_template.md` | (As needed / 必要に応じて) |

---

**Proof Complete / 証明完了**:
All user requests are completely covered by the rule files above.
ユーザーの全ての要望は、上記のルールファイル群によって完全に網羅されています。
