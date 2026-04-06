# 000. Blueprint Index（ブループリント索引）

> [!NOTE]
> **Map to the Brain**:
> このディレクトリはプロジェクトの「脳（仕様と知見）」です。
> `universal/` のルールは **「憲法」** であり、すべてのプロジェクトに共通する不変の原則です。
> `blueprint/` のルールは **「法律」** であり、憲法を具体化し、プロジェクト固有の事情に合わせてカスタマイズする場所です。
> 間隔採番（Sparse Numbering）により、将来の拡張性を確保しています。
> **`universal/` と対称のフォルダ分け構造を採用しています。**

---

## 📑 目次 (Table of Contents)

1. [ディレクトリ構成](#-ディレクトリ構成)
2. [governance/: ガバナンス & ログ (000–009)](#-governance-ガバナンス--ログ-000009)
3. [quality/: 品質 & 安全 (100–199)](#-quality-品質--安全-100199)
4. [design/: デザイン & UX (200–299)](#-design-デザイン--ux-200299)
5. [engineering/: エンジニアリングコア (300–399)](#-engineering-エンジニアリングコア-300399)
6. [ai/: AI & コンテンツ (400–499)](#-ai-ai--コンテンツ-400499)
7. [product/: ビジネス & グロース (500–599)](#-product-ビジネス--グロース-500599)
8. [specs/: 機能仕様 (600–899)](#-specs-機能仕様-600899)
9. [templates/: テンプレート & 付録 (900–999)](#-templates-テンプレート--付録-900999)
10. [運用ガイド](#運用ガイド-operational-guide)
11. [Appendix A: 逆引き索引 & クロスリファレンス](#appendix-a-逆引き索引--クロスリファレンス)

---

## 📁 ディレクトリ構成

```
blueprint/ja/
├── governance/      ← 000番台：プロジェクト概要・教訓ログ・Crystallization生成ファイル
├── quality/         ← 100番台：セキュリティポリシー・コンプライアンス・QA基準
├── design/          ← 200番台：デザインシステム・A11y・ブランド定義
├── engineering/     ← 300番台：システム構成・API設計・データモデル
├── ai/              ← 400番台：AI戦略・CMS戦略・SEO/GEO
├── product/         ← 500番台：マネタイズ・グロースマーケティング・GTM
├── specs/           ← 600〜800番台：機能仕様（ドメイン固有設計）
├── templates/       ← 900番台：テンプレートファイル
└── INDEX.md         ← 本ファイル（ルート直下に常駐）
```

> **Universal との対称性**: `universal/ja/` の `core/`, `product/`, `design/`, `engineering/`, `ai/`, `operations/`, `security/`, `quality/` と意味的に対応。
> 「憲法（Universal）」を「法律（Blueprint）」が具体化する構造が、フォルダ名レベルで視覚的に明確になります。

---

## 📂 governance/: ガバナンス & ログ (000–009)

プロジェクトの概要・教訓インデックス・歴史を管理します。教訓ドメインファイルは **Co-location 原則**に従い、各ドメイン対応フォルダ（`engineering/` 等）へ自律生成されます。このフォルダへの教訓集約は行いません。

| ファイル | 説明 |
|:--------|:----|
| [000_project_overview.md](governance/000_project_overview.md) | プロジェクトビジョン・技術スタック・不変の原則 |
| `010_project_lessons_log.md` | 教訓インデックス + 未分類教訓の蓄積。Crystallizationの起点。 |
| `020_{topic}.md` ← 昇華自動生成 | ガバナンス系教訓が3件以上の時に自律作成。他ドメイン（DB・セキュリティ等）の教訓は対応ドメインフォルダへ正式ルールファイルとして昇華。 |

---

## 📂 quality/: 品質 & 安全 (100–199)

「信頼」と「品質」を支える防衛ラインです。

> 例: セキュリティポリシー、法務コンプライアンス、ローカライズ品質、FinOps、Observability 等
>
> 対応 Universal: `security/`, `quality/`

---

## 📂 design/: デザイン & UX (200–299)

ユーザーの「体験」と「ブランド」を定義します。

> 例: デザインシステム上書き、アクセシビリティ (A11y) 方針等
>
> 対応 Universal: `design/`

---

## 📂 engineering/: エンジニアリングコア (300–399)

システムの「骨格」と「血液」の流れを定義します。

> 例: システム構成・Gatewayパターン、データモデリング、開発ワークフロー等
>
> 対応 Universal: `engineering/`

---

## 📂 ai/: AI & コンテンツ (400–499)

次世代の「価値」を生み出す戦略です。

> 例: AI安全性・倫理、CMS戦略、SEO/GEO最適化等
>
> 対応 Universal: `ai/`

---

## 📂 product/: ビジネス & グロース (500–599)

「持続可能性（収益）」を追求します。

> 例: マネタイズ戦略、グロースマーケティング等
>
> 対応 Universal: `product/`, `operations/`

---

## 📂 specs/: 機能仕様 (600–899)

具体的な「機能」のコアロジックを定義します。

> 例: コア機能仕様、ドメイン固有の設計仕様等
> `templates/000_feature_spec_template.md` をコピーして作成します。

---

## 📂 templates/: テンプレート & 付録 (900–999)

| ファイル | 説明 |
|:--------|:----|
| [000_feature_spec_template.md](templates/000_feature_spec_template.md) | **機能仕様テンプレート（SDD核）**。受け入れ条件・データモデル・API設計・テスト戦略を機能単位で定義。`specs/` にコピーして使用。 |
| [100_project_specific_template.md](templates/100_project_specific_template.md) | プロジェクト固有ルールファイル追加時のテンプレート。 |

---

## 運用ガイド (Operational Guide)

### 初期セットアップ
1. `AGENTS.md` の `Project Native Language` を設定する
2. **使用しない方の言語フォルダ（`ja/` または `en/`）を削除する**
3. `governance/000_project_overview.md` をプロジェクトの内容に書き換える

### 機能仕様の追加（Blueprint First の実践）
1. **`templates/000_feature_spec_template.md` をコピーする**
2. `specs/` フォルダ内に 600–800 の番号帯でファイル名を変更する（例: `specs/600_feature_payment.md`）
3. **§3 受け入れ条件（Acceptance Criteria）を最優先で記述する** — このセクションが空の状態でコードを書いてはならない
4. 残りのセクション（データモデル、API設計、テスト戦略等）を埋める
5. **このファイル（INDEX.md）の `specs/` セクションにエントリを追記する**

### プロジェクト固有ルールの追加
1. `templates/100_project_specific_template.md` をコピーする
2. 対応するフォルダ内に番号付きで配置する（例: `quality/100_security_policy.md`）
3. テンプレートの各セクションをプロジェクト固有の内容で埋める
4. **このファイル（INDEX.md）の該当フォルダセクションにエントリを追記する**

### 教訓の記録（Crystallization）
- 作業完了時や重要な決定時に `governance/010_project_lessons_log.md` に追記する
- 同一ドメインの教訓が3件以上に達したら、AIが自律的にドメイン対応フォルダに正式プロジェクトルールファイル（`{NNN}_{topic}.md`）を作成し教訓を昇華・移動する（ファイル名に `lessons_` は不要。例: `engineering/300_database_auth.md`）
- 詳細手順は `axiarch-rules/CRYSTALLIZATION_PROTOCOL.md` を参照

---

## Appendix A: 逆引き索引 & クロスリファレンス

### 逆引き索引（キーワード → ファイル/フォルダ）

| キーワード | 対応ファイル/フォルダ |
|:---------|:-----------------|
| プロジェクト概要・ビジョン・技術スタック | `governance/000_project_overview.md` |
| 教訓・アンチパターン・振り返り | `governance/010_project_lessons_log.md` |
| セキュリティ・コンプライアンス | `quality/` |
| デザインシステム・A11y | `design/` |
| システム構成・API設計 | `engineering/` |
| AI戦略・CMS | `ai/` |
| マネタイズ・グロース | `product/` |
| 機能仕様（ドメイン固有） | `specs/` |
| 機能仕様テンプレート・受け入れ条件 | `templates/000_feature_spec_template.md` |
| プロジェクト固有ルールテンプレート | `templates/100_project_specific_template.md` |

### クロスリファレンス（Blueprint フォルダ → Universal 対照表）

| Blueprint フォルダ | カテゴリ | 関連 Universal フォルダ |
|:----------------|:--------|:-------------------|
| `governance/` | 000 ガバナンス | `core/` (`000_core_mindset`, `100_governance`, `200_language_protocol`) |
| `quality/` | 100 品質・安全 | `security/`, `quality/` |
| `design/` | 200 デザイン・UX | `design/` |
| `engineering/` | 300 エンジニアリング | `engineering/` |
| `ai/` | 400 AI・コンテンツ | `ai/` |
| `product/` | 500 ビジネス・グロース | `product/`, `operations/` |
| `specs/` | 600–800 機能仕様 | 各ドメインに応じた Universal ルールを参照 |
| `templates/` | 900 テンプレート | — |

---

**Last Updated**: 2026-04-06
**Version**: v1.0.0 — ドメインベースのフォルダ分け構造（Universal と対称化）
**Structure**: Domain-based subdirectories + Sparse Numbering (3-digit) system.
