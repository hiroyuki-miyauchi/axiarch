# 000. Blueprint Index（ブループリント索引）

> [!NOTE]
> **Map to the Brain**:
> このディレクトリはプロジェクトの「脳（仕様と知見）」です。
> `universal/` のルールは **「憲法」** であり、すべてのプロジェクトに共通する不変の原則です。
> `blueprint/` のルールは **「法律」** であり、憲法を具体化し、プロジェクト固有の事情に合わせてカスタマイズする場所です。
> 間隔採番（Sparse Numbering）により、将来の拡張性を確保しています。
> **`universal/` と完全同型（Isomorphic）のフォルダ構成を採用しています。**

---

## 📑 目次 (Table of Contents)

1. [ディレクトリ構成](#-ディレクトリ構成)
2. [core/: コア仕様 & ログ](#-core-コア仕様--ログ)
3. [security/: セキュリティ & 権限](#-security-セキュリティ--権限)
4. [engineering/: エンジニアリング](#-engineering-エンジニアリング)
5. [design/: デザイン & UX](#-design-デザイン--ux)
6. [quality/: QA & テスト](#-quality-qa--テスト)
7. [operations/: 運用 & インシデント](#-operations-運用--インシデント)
8. [product/: ビジネス & 要件](#-product-ビジネス--要件)
9. [ai/: AI & コンテンツ](#-ai-ai--コンテンツ)
10. [運用ガイド](#運用ガイド-operational-guide)
11. [Appendix A: 逆引き索引 & クロスリファレンス](#appendix-a-逆引き索引--クロスリファレンス)

---

## 📁 ディレクトリ構成

```
blueprint/ja/
├── core/            ← プロジェクト概要・教訓ログ・テンプレート
├── security/        ← セキュリティポリシー・コンプライアンス
├── engineering/     ← システム構成・API設計・データモデル
├── design/          ← デザインシステム・A11y
├── quality/         ← QA基準・テスト戦略
├── operations/      ← SRE・インシデント運用
├── product/         ← マネタイズ・グロース・GTM
├── ai/              ← AI戦略・CMS戦略
└── INDEX.md         ← 本ファイル
```

> **Universal との完全同型**: `universal/ja/` の 8 フォルダ（`core/`, `security/`, `engineering/`, `design/`, `quality/`, `operations/`, `product/`, `ai/`）と 1:1 対応。
> 「憲法（Universal）」を「法律（Blueprint）」が具体化する構造が、フォルダ名レベルで視覚的に明確になります。

---

## 📂 core/: コア仕様 & ログ

プロジェクトの概要・教訓インデックス・テンプレートを管理します。

| ファイル | 説明 |
|:--------|:----|
| [000_project_overview.md](core/000_project_overview.md) | プロジェクトビジョン・技術スタック・不変の原則 |
| [core/010_project_lessons_log.md](core/010_project_lessons_log.md) | 教訓インデックス + 未分類教訓の蓄積。Crystallizationの起点。 |
| [998_feature_spec_template.md](core/998_feature_spec_template.md) | **機能仕様テンプレート（Blueprint Firstの核）**。対応ドメインフォルダにコピーして使用。 |
| [999_project_specific_template.md](core/999_project_specific_template.md) | プロジェクト固有ルールファイル追加時のテンプレート。 |

---

## 📂 security/: セキュリティ & 権限

セキュリティポリシー、権限管理、法務コンプライアンス等。

> 対応 Universal: `security/`

---

## 📂 engineering/: エンジニアリング

システムの「骨格」と「血液」の流れを定義します。

> 対応 Universal: `engineering/`

---

## 📂 design/: デザイン & UX

ユーザーの「体験」と「ブランド」を定義します。

> 対応 Universal: `design/`

---

## 📂 quality/: QA & テスト

「信頼」と「品質」を支える防衛ラインです。

> 対応 Universal: `quality/`


---

## 📂 operations/: 運用 & インシデント

SRE、インシデント管理、運用要件。

> 対応 Universal: `operations/`

---

## 📂 product/: ビジネス & 要件

マネタイズ戦略、グロース要件。

> 対応 Universal: `product/`

---

## 📂 ai/: AI & コンテンツ

次世代の「価値」を生み出す戦略です。

> 対応 Universal: `ai/`

---

## 運用ガイド (Operational Guide)

### 初期セットアップ
1. `AGENTS.md` の `Project Native Language` を設定する
2. **使用しない方の言語フォルダ（`ja/` または `en/`）を削除する**
3. `core/000_project_overview.md` をプロジェクトの内容に書き換える

### 機能仕様の追加（Blueprint First の実践）
1. **`core/998_feature_spec_template.md` をコピーする**
2. 対応するドメインフォルダに配置する（例: `product/020_feature_payment.md` ※特定の番号帯域縛りはなく、フォルダ内で000〜999の空き番を使用する）
3. **§3 受け入れ条件（Acceptance Criteria）を最優先で記述する** — このセクションが空の状態でコードを書いてはならない
4. 残りのセクション（データモデル、API設計、テスト戦略等）を埋める
5. **このファイル（INDEX.md）の該当フォルダセクションにエントリを追記する**

### プロジェクト固有ルールの追加
1. `core/999_project_specific_template.md` をコピーする
2. 対応するフォルダ内に番号付きで配置する（例: `security/010_security_policy.md` ※特定の番号帯域縛りはなく、フォルダ内で000〜999の空き番を使用する）
3. テンプレートの各セクションをプロジェクト固有の内容で埋める
4. **このファイル（INDEX.md）の該当フォルダセクションにエントリを追記する**

### 教訓の記録（Crystallization）
- 作業完了時や重要な決定時に `core/010_project_lessons_log.md` に追記する
- 同一ドメインの教訓が3件以上に達したら、AIが自律的にドメイン対応フォルダに正式プロジェクトルールファイル（`{NNN}_{topic}.md`）を作成し教訓を昇華・移動する
- 詳細手順は `axiarch-rules/CRYSTALLIZATION_PROTOCOL.md` を参照

---

## Appendix A: 逆引き索引 & クロスリファレンス

### 逆引き索引（キーワード → ファイル/フォルダ）

| キーワード | 対応ファイル/フォルダ |
|:---------|:--------------------|
| プロジェクト概要・ビジョン・技術スタック | `core/000_project_overview.md` |
| 教訓・アンチパターン・振り返り | `core/010_project_lessons_log.md` |
| 機能仕様テンプレート | `core/998_feature_spec_template.md` |
| プロジェクト固有ルールテンプレート | `core/999_project_specific_template.md` |
| セキュリティ・コンプライアンス | `security/` |
| システム構成・API設計 | `engineering/` |
| デザインシステム・A11y | `design/` |
| QA・テスト戦略 | `quality/` |
| SRE・運用・インシデント | `operations/` |
| マネタイズ・グロース | `product/` |
| AI戦略・CMS | `ai/` |

### クロスリファレンス（Blueprint → Universal 1:1 対照表）

| Blueprint | Universal |
|:----------|:----------|
| `core/` | `core/` |
| `security/` | `security/` |
| `engineering/` | `engineering/` |
| `design/` | `design/` |
| `quality/` | `quality/` |
| `operations/` | `operations/` |
| `product/` | `product/` |
| `ai/` | `ai/` |

---

**Last Updated**: 2026-04-29
**Version**: v1.2.0 — Universal と完全同型（Isomorphic）8フォルダ構成、YAGNI原則に基づく構造正規化
**Structure**: Domain-based subdirectories (8 domains, 1:1 with Universal)
