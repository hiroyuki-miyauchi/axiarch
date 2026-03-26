# 000. Blueprint Index (ブループリント索引)

> [!NOTE]
> **Map to the Brain**:
> このディレクトリはプロジェクトの「脳（仕様と知見）」です。
> `universal/` のルールは **「憲法」** であり、すべてのプロジェクトに共通する不変の原則です。
> `blueprint/` のルールは **「法律」** であり、憲法を具体化し、プロジェクト固有の事情に合わせてカスタマイズする場所です。
> 間隔採番（Sparse Numbering）により、将来の拡張性を確保しています。

---

## 📑 目次 (Table of Contents)

1. [Category 000: ガバナンス & ログ](#-category-000-governance--logs-000009)
2. [Category 100: 品質 & 安全](#-category-100-quality--safety-100199)
3. [Category 200: デザイン & UX](#-category-200-design--ux-200299)
4. [Category 300: エンジニアリングコア](#-category-300-engineering-core-300399)
5. [Category 400: AI & コンテンツ](#-category-400-ai--content-400499)
6. [Category 500: ビジネス & グロース](#-category-500-business--growth-500599)
7. [Category 600–800: 機能仕様](#-category-600800-feature-specifications-600899)
8. [Category 900: テンプレート & 付録](#-category-900-templates--appendix-900999)
9. [運用ガイド](#運用ガイド-operational-guide)
10. [Appendix A: 逆引き索引 & クロスリファレンス](#appendix-a-逆引き索引--クロスリファレンス)

---

## 📂 Category 000: Governance & Logs (000–009)

プロジェクトの憲法、教訓、歴史を管理します。

- [000. Project Overview & Constitution](000_project_overview.md) - プロジェクトビジョン・技術スタック・不変の原則。
- [001. Project Lessons Log](010_project_lessons_log.md) - 開発を通じて得られた「教訓」と「アンチパターン」の蓄積。

## 📂 Category 100: Quality & Safety (100–199)

「信頼」と「品質」を支える防衛ラインです。

> 例: セキュリティ、法務コンプライアンス、ローカライズ品質、FinOps、Observability 等

## 📂 Category 200: Design & UX (200–299)

ユーザーの「体験」と「ブランド」を定義します。

> 例: デザインシステム、アクセシビリティ (A11y) 等

## 📂 Category 300: Engineering Core (300–399)

システムの「骨格」と「血液」の流れを定義します。

> 例: システム構成・Gatewayパターン、データモデリング、開発ワークフロー 等

## 📂 Category 400: AI & Content (400–499)

次世代の「価値」を生み出す戦略です。

> 例: AI安全性・倫理、CMS戦略、SEO/GEO最適化 等

## 📂 Category 500: Business & Growth (500–599)

「持続可能性（収益）」を追求します。

> 例: マネタイズ戦略、グロースマーケティング 等

## 📂 Category 600–800: Feature Specifications (600–899)

具体的な「機能」のコアロジックを定義します。

> 例: コア機能仕様、ドメイン固有の設計仕様 等

## 📂 Category 900: Templates & Appendix (900–999)

- [999. Project Specific Template](999_project_specific_template.md) - ルールファイル追加時のテンプレート。

---

## 運用ガイド (Operational Guide)

### 初期セットアップ
1. `GEMINI.md` の `Project Native Language` を設定する
2. **使用しない方の言語フォルダ（`ja/` または `en/`）を削除する**
3. `000_project_overview.md` をプロジェクトの内容に書き換える

### 新規仕様書の追加
1. `999_project_specific_template.md` をコピーする
2. 上記のカテゴリ番号帯に従ってファイル名を変更する（例: `600_feature_payment.md`）
3. テンプレートの各セクションをプロジェクト固有の内容で埋める
4. **このファイル（INDEX.md）の該当カテゴリにエントリを追記する**

### 教訓の記録
- 作業完了時や重要な決定時に、`010_project_lessons_log.md` に所定フォーマットで追記する
- `GEMINI.md` の「Continuous Improvement」プロセスに基づく義務的な振り返り

---

## Appendix A: 逆引き索引 & クロスリファレンス

### 逆引き索引（キーワード → ファイル）

| キーワード | 対応ファイル |
|---|---|
| プロジェクト概要・ビジョン・技術スタック | `000_project_overview.md` |
| 教訓・アンチパターン・振り返り | `010_project_lessons_log.md` |
| 新規仕様書テンプレート | `999_project_specific_template.md` |
| セキュリティ・コンプライアンス | Category 100 に追加 |
| デザインシステム・A11y | Category 200 に追加 |
| システム構成・API設計 | Category 300 に追加 |
| AI戦略・CMS | Category 400 に追加 |
| マネタイズ・グロース | Category 500 に追加 |
| 機能仕様（ドメイン固有） | Category 600–800 に追加 |

### クロスリファレンス（Blueprint → Universal 対照表）

| Blueprint カテゴリ | 関連 Universal ルール |
|---|---|
| 000 ガバナンス | `000_core_mindset`, `801_governance` |
| 100 品質 & 安全 | `600_security_privacy`, `601_data_governance`, `602_oss_compliance`, `700_qa_testing` |
| 200 デザイン & UX | `200_design_ux` |
| 300 エンジニアリング | `300_engineering_standards`, `301_api_integration`, `320_supabase_architecture`, `340_web_frontend`, `360_firebase_gcp`, `361_aws_cloud` |
| 400 AI & コンテンツ | `400_ai_engineering`, `401_data_analytics`, `341_headless_cms` |
| 500 ビジネス | `100_product_strategy`, `101_revenue_monetization`, `102_growth_marketing` |
| 600–800 機能仕様 | 各ドメインに応じた Universal ルールを参照 |
| 900 テンプレート | — |

---

**Last Updated**: 2026-03-24
**Structure**: Sparse Numbering (3-digit) system.
**Total Files**: 4 (including INDEX)
