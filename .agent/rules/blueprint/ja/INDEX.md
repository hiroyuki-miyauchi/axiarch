# 000. Blueprint Index (ブループリント索引)

> [!NOTE]
> **Map to the Brain**:
> このディレクトリはプロジェクトの「脳（仕様と知見）」です。
> `universal/` のルールは **「憲法」** であり、すべてのプロジェクトに共通する不変の原則です。
> `blueprint/` のルールは **「法律」** であり、憲法を具体化し、プロジェクト固有の事情に合わせてカスタマイズする場所です。
> 間隔採番（Sparse Numbering / Gap-10）により、将来の拡張性を確保しています。

---

## 📂 Category 0: Governance & Logs (000-009)

プロジェクトの憲法、教訓、歴史を管理します。

- [000. Project Overview & Constitution](000_project_overview.md) - プロジェクトビジョン・技術スタック・不変の原則。
- [001. Project Lessons Log](001_project_lessons_log.md) - 開発を通じて得られた「教訓」と「アンチパターン」の蓄積。

## 📂 Category 1: Quality & Safety (010-019)

「信頼」と「品質」を支える防衛ラインです。

> 例: セキュリティ、法務コンプライアンス、ローカライズ品質、FinOps、Observability 等

## 📂 Category 2: Design & UX (020-029)

ユーザーの「体験」と「ブランド」を定義します。

> 例: デザインシステム、アクセシビリティ (A11y) 等

## 📂 Category 3: Engineering Core (030-039)

システムの「骨格」と「血液」の流れを定義します。

> 例: システム構成・Gatewayパターン、データモデリング、開発ワークフロー 等

## 📂 Category 4: AI & Content (040-049)

次世代の「価値」を生み出す戦略です。

> 例: AI安全性・倫理、CMS戦略、SEO/GEO最適化 等

## 📂 Category 5: Business & Growth (050-059)

「持続可能性（収益）」を追求します。

> 例: マネタイズ戦略、グロースマーケティング 等

## 📂 Category 6-8: Feature Specifications (060-089)

具体的な「機能」のコアロジックを定義します。

> 例: コア機能仕様、ドメイン固有の設計仕様 等

## 📂 Category 9: Templates & Appendix (090-999)

- [999. Project Specific Template](999_project_specific_template.md) - ルールファイル追加時のテンプレート。

---

## 運用ガイド (Operational Guide)

### 初期セットアップ
1. `GEMINI.md` の `Project Native Language` を設定する
2. **使用しない方の言語フォルダ（`ja/` または `en/`）を削除する**
3. `000_project_overview.md` をプロジェクトの内容に書き換える

### 新規ルールファイルの追加
1. `999_project_specific_template.md` をコピーする
2. 上記のカテゴリ番号帯に従ってファイル名を変更する（例: `060_feature_payment.md`）
3. テンプレートの各セクションをプロジェクト固有の内容で埋める
4. **このファイル（INDEX.md）の該当カテゴリにエントリを追記する**

### 教訓の記録
- 作業完了時や重要な決定時に、`001_project_lessons_log.md` に所定フォーマットで追記する
- `GEMINI.md` の「Continuous Improvement」プロセスに基づく義務的な振り返り

---

**Last Updated**: [YYYY-MM-DD]
**Structure**: Sparse Numbering (Gap-10) system.
**Total Files**: 4 (including INDEX)
