# Project Lessons Log (プロジェクト教訓ログ)

このファイルは、プロジェクト開発を通じて得られた重要な教訓、アンチパターン、および新たに確立された運用ルールを集約するためのログです。
`AGENTS.md` の "Continuous Improvement — Auto-Crystallization Protocol" に基づき、AIが自律的にこのファイルを管理します。

> [!IMPORTANT]
> **Auto-Crystallization Protocol（自動結晶化プロトコル）**
>
> このファイルは **教訓のインデックス兼一時蓄積場所** として機能します。
> 同一ドメインの教訓が **3件以上** 蓄積された場合、AIは自律的に以下を実行します：
>
> 1. ドメインに対応した Blueprint フォルダ内に正式プロジェクトルールファイルを昇華作成
>    例: DB・認証の教訓 → `engineering/{NNN}_database_auth.md`
>    例: セキュリティの教訓 → `security/{NNN}_security_policy.md`
> 2. 該当する教訓を新ファイルに移動
> 3. このファイルにドメインファイルへの参照リンクを追記
>
> **設計哲学**: 教訓はルールと同じフォルダに Co-locate する。このファイルへの集約は行わない。
> **操縦者（ユーザー）は何もする必要がありません。** AIが自動的にドメイン別構造を構築します。
> 詳細は `axiarch-rules/CRYSTALLIZATION_PROTOCOL.md` を参照。

---

## 📑 目次 (Table of Contents)

1. [分離済みドメインファイル一覧](#分離済みドメインファイル一覧-separated-domain-files)
2. [未分類の教訓](#未分類の教訓-unsorted-lessons)
3. [Appendix A: 逆引き索引 & クロスリファレンス](#appendix-a-逆引き索引--クロスリファレンス)
4. [Appendix B: ドメインファイルテンプレート](#appendix-b-ドメインファイルテンプレート)

---

## 分離済みドメインファイル一覧 (Separated Domain Files)

> [!NOTE]
> 同一ドメインの教訓が3件以上蓄積されると、AIが自動的にドメイン別ファイルを作成します。
> 以下のリンク一覧は自動的に更新されます。

| # | ドメイン | ファイル | 教訓数 |
|:--|:--------|:--------|:-------|
| — | *(まだ分離されたドメインファイルはありません)* | — | — |

<!-- AUTO-CRYSTALLIZATION: ドメインファイル作成時、上の表に行を追加してください -->
<!-- 例: | 1 | DB・認証 | [engineering/010_database_auth.md](../engineering/200_supabase_architecture.md) | 3 | -->

---

## 未分類の教訓 (Unsorted Lessons)

> [!TIP]
> **教訓の追加形式**
> 新しい教訓を追加する際は、以下のフォーマットを使用してください。
> **必ず `Domain:` タグを付けること。** これが自動分離の判定基準になります。
>
> ### [YYYY-MM-DD] 教訓のタイトル
> **Domain:** DB・認証 / セキュリティ / アーキテクチャ / 品質 / デザイン / 運用 / ガバナンス / パフォーマンス / その他
> **Context:** 問題が発生した状況や背景
> **Problem:** 具体的な問題点や失敗内容
> **Solution/Rule:** 解決策、または再発防止のために制定されたルール
> **Reference:** 関連するファイルやコミット（あれば）

---

### [Initial] プロジェクト開始時の教訓
**Domain:** ガバナンス
**Context:** 新規プロジェクトまたはルールの刷新時。
**Rule:** `AGENTS.md` および `axiarch-rules` のプロトコルを基準として遵守すること。

---

## Appendix A: 逆引き索引 & クロスリファレンス

### 推奨ドメインカテゴリ

| ドメイン | 主な教訓の種類 | 関連 Universal ルール |
|:--------|:------------|:--------------------|
| DB・認証 | スキーマ設計、マイグレーション、RLS、認証フロー | `engineering/200_supabase_architecture`, `security/000_security_privacy` |
| セキュリティ | 脆弱性、インシデント、プライバシー | `security/000_security_privacy` |
| アーキテクチャ | 設計判断、ADR、レイヤー設計 | `engineering/000_engineering_standards` |
| 品質 | テスト戦略、バグ回帰、コードレビュー | `quality/000_qa_testing` |
| デザイン | UI/UX判断、デザインシステム、A11y | `design/000_design_ux` |
| 運用 | CI/CD、デプロイ、SRE、インシデント対応 | `operations/400_site_reliability` |
| ガバナンス | ルール運用、プロトコル改善、教訓管理 | `core/100_governance` |
| パフォーマンス | 速度改善、メモリ、コスト最適化 | `engineering/000_engineering_standards`, `operations/600_cloud_finops` |
| FinOps | クラウドコスト、リソース効率 | `operations/600_cloud_finops` |

### クロスリファレンス（関連 Universal ルール）

| カテゴリ | 関連 Universal ルール |
|---|---|
| 教訓の結晶化プロセス | `AGENTS.md` §8 Continuous Improvement — Auto-Crystallization Protocol |
| コア原則違反の教訓 | `core/000_core_mindset` |
| セキュリティ教訓 | `security/000_security_privacy` |
| パフォーマンス教訓 | `engineering/000_engineering_standards`, `quality/000_qa_testing` |
| 設計判断の教訓 | 対象ドメインの Universal ルールを参照 |

---

## Appendix B: ドメインファイルテンプレート

> [!IMPORTANT]
> **テンプレートの参照先**
>
> ドメイン教訓ファイルを新規作成する際は、**必ず** `axiarch-rules/CRYSTALLIZATION_PROTOCOL.md` の
> 「Crystallized Rule File Template」セクションに記載された**公式テンプレート**に従うこと。
>
> このファイルにテンプレートを二重管理すると CRYSTALLIZATION_PROTOCOL.md との乖離リスクが生じるため廃止。
> **常に `CRYSTALLIZATION_PROTOCOL.md` を Single Source of Truth とすること。**
