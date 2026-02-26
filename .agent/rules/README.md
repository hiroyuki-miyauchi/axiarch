# Antigravity Development Rules
# Antigravity 開発ルール集

> [!IMPORTANT]
> **Constitution of Antigravity**
>
> All rules in this folder (`.agent/rules/`) are the absolute constitution of the Antigravity project.
> The `universal/` rules are **Immutable (Read-only)** — AI MUST NOT edit without explicit "Amend Constitution" instruction.
> The `blueprint/` rules are **Mutable (Project-specific)** — AI SHOULD proactively propose and update.
>
> 本フォルダ（`.agent/rules/`）の全ルールはAntigravityプロジェクトの絶対的な憲法です。
> `universal/` ルールは**不変（読み取り専用）**。明示的な「憲法改正」指示なしに編集禁止。
> `blueprint/` ルールは**可変（プロジェクト固有）**。積極的に提案・更新すること。

> [!NOTE]
> **Language Standard / 言語基準**
>
> Rules are provided in **Japanese (`ja/`) and English (`en/`)**. During setup, choose one language and delete the other folder. After setup, rule files exist directly under `universal/` and `blueprint/`.
>
> ルールは**日本語（`ja/`）と英語（`en/`）**で提供されます。セットアップ時に使用する言語を選び、不要な方のフォルダを削除してください。セットアップ後、ルールファイルは `universal/` と `blueprint/` 直下に配置されます。

---

## 📚 Universal Rules / 汎用ルール

Files are split into 3-digit numbered units. During setup, choose `ja/` or `en/` and delete the other.
ファイルは3桁番号で細分化されています。セットアップ時に `ja/` または `en/` を選び、不要な方を削除してください。

### 000-099: Core & Mindset / コア・マインドセット
Decision hierarchy, elite roles, operational iron rules, governance.
意思決定ヒエラルキー、エリート役割、運用鉄則、ガバナンス。

### 100-199: Business & Growth / ビジネス・成長戦略
Strategic alignment, unit economics, payments, PLG, App Store compliance.
経営層戦略整合、ユニットエコノミクス、決済、PLG、ストア準拠。

### 200-299: Design & UX / デザイン・UX
Silicon Valley-grade design philosophy, components, accessibility, foldables.
シリコンバレー水準デザイン哲学、コンポーネント、アクセシビリティ。

### 300-399: Engineering / エンジニアリング
Code quality, Git, architecture mandates, Next.js frontend, CMS/headless, API design, native platforms, backend/data governance.
コード品質、Git、アーキテクチャ指令、Next.jsフロントエンド、CMS/ヘッドレス、API設計、ネイティブ、バックエンド/データガバナンス。

### 400-499: AI & Data / AI・データ
AI UX principles, edge AI, behavioral analytics.
AI UX原則、エッジAI、行動分析。

### 500-599: Operations / オペレーション
Build vs buy, admin tools, user support, SRE, chaos engineering, incident response.
内製vs外注、管理ツール、ユーザーサポート、SRE、カオスエンジニアリング、インシデント対応。

### 600-699: Security & Legal / セキュリティ・法務
Security golden rules, auth (Turnstile, OTP, MFA), CSP, error handling, data privacy, licensing, IP.
セキュリティ黄金律、認証（Turnstile, OTP, MFA）、CSP、エラー処理、データプライバシー、ライセンス、知的財産。

### 700-799: QA & Global / QA・グローバル
Shift-left testing, schema sync, internationalization, duty reference.
シフトレフトテスト、スキーマ同期、国際化、義務リファレンス。

---

## 📐 Blueprint Rules / プロジェクト固有ルール

Located under `blueprint/`. Choose `ja/` or `en/` during setup and delete the other.
`blueprint/` 配下に配置。セットアップ時に `ja/` または `en/` を選び、不要な方を削除。

- **000_project_overview.md** — Project vision, tech stack, architecture / プロジェクトビジョン・技術スタック
- **001_project_lessons_log.md** — Lessons learned & anti-patterns / 教訓＆アンチパターン
- **999_project_specific_template.md** — Template for new rule files / 新規ルールファイルテンプレート

---

## 🚀 Setup / セットアップ

### 🇺🇸 English Guide

1. **Copy** the `.agent/rules/` folder and `GEMINI.md` to your project root.
   ```bash
   cp -r .agent/ GEMINI.md /path/to/your/project/
   ```

2. **Initialize**:
   - Edit `GEMINI.md`: Set `Project Native Language` to `English`
   - **Delete Japanese folder**: `rm -rf .agent/rules/universal/ja .agent/rules/blueprint/ja`

3. **Configure**: Edit `blueprint/en/000_project_overview.md` and `001_project_lessons_log.md` for your project.

4. **Develop**: AI will strictly adhere to these rules.

### 🇯🇵 日本語ガイド

1. `.agent/rules/` フォルダと `GEMINI.md` をプロジェクトルートにコピー。
   ```bash
   cp -r .agent/ GEMINI.md /path/to/your/project/
   ```

2. **初期化**:
   - `GEMINI.md` の `Project Native Language` を `Japanese` に設定
   - **英語フォルダを削除**: `rm -rf .agent/rules/universal/en .agent/rules/blueprint/en`

3. **設定**: `blueprint/ja/000_project_overview.md` と `001_project_lessons_log.md` をプロジェクトに合わせて編集。

4. **開発開始**: AIがこれらのルールを厳格に遵守して開発を行います。

---

## ⚙️ Activation Mode / ルール読み込み設定

> [!TIP]
> **Recommended: Set all rule files to "Always On" / 推奨: 全ルールファイルを「常時読み込み」に設定**
>
> Most AI development tools (Windsurf, Cursor, etc.) allow you to configure whether each rule file is loaded automatically.
> We recommend setting **all rule files to "Always On"** (auto-load) so the AI always operates under the full constitution.
> Adjust individual files to "Manual" only if you experience context window limitations.
>
> 多くのAI開発ツール（Windsurf、Cursor等）では、ルールファイルの読み込みモードを設定できます。
> **全ルールファイルを「Always On」（常時読み込み）**に設定することを推奨します。
> AIが常に憲法全体を遵守して動作するためです。
> コンテキストウィンドウの制約がある場合のみ、個別に「Manual」に変更してください。
