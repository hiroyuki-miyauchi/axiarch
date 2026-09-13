# Project Lessons Log (プロジェクト教訓ログ)

このファイルは、プロジェクト開発を通じて得られた重要な教訓、アンチパターン、および新たに確立された運用ルールの **索引兼・未分類の一時蓄積所** です。全教訓をここに蓄積し続ける場所ではありません。同一ドメインの教訓が3件以上に達した時点で、対応する Blueprint フォルダへ正式ルールファイルとして昇華し、本ファイルには参照リンクのみを残します。
`AXIARCH.md` からロードされる `axiarch-rules/{lang}/CRYSTALLIZATION_PROTOCOL.md` に基づき、AIが自律的にこのファイルを管理します。

> 実務で得た教訓の記録・分類・重複確認・既存ルール検索・件数／経過日による昇華・索引更新は `axiarch-rules/{lang}/CRYSTALLIZATION_PROTOCOL.md` を正本とする。既存の適切なルールがある場合は、読んだうえでそこへ差分を追記する。このログは未整理の一時置き場であり、ファイル配置だけでは読込済みにならない。更新はAIの手順遵守に依存し、診断は記録の構造と閾値を確認する。

---

## 📑 目次 (Table of Contents)

1. [分離済みドメインファイル一覧](#分離済みドメインファイル一覧-separated-domain-files)
2. [未分類の教訓](#未分類の教訓-unsorted-lessons)
3. [Appendix A: 逆引き索引 & クロスリファレンス](#appendix-a-逆引き索引--クロスリファレンス)
4. [Appendix B: ドメインファイルテンプレート](#appendix-b-ドメインファイルテンプレート)

---

## 分離済みドメインファイル一覧 (Separated Domain Files)

> [!NOTE]
> 昇華時にAIが手順に従ってこの表を更新します。スクリプトが自動作成する表ではありません。

| # | ドメイン | ファイル | 教訓数 |
|:--|:--------|:--------|:-------|
| 1 | 運用 | [operations/010_release_upgrade_operations.md](../operations/010_release_upgrade_operations.md) | 13 |
| 2 | ガバナンス | [core/020_governance_rules.md](./020_governance_rules.md) | 4 |

<!-- AUTO-CRYSTALLIZATION: ドメインファイル作成時、上の表に行を追加してください -->
<!-- 例: | 1 | DB・認証 | `engineering/010_database_auth.md` | 3 | -->

---

## 未分類の教訓 (Unsorted Lessons)

> [!TIP]
> **教訓の追加形式**
> 新しい教訓を追加する際は、以下のフォーマットを使用してください。
> **必ず `Domain:` と `Target Folder:` タグを付けること。** これが自動分離の判定基準になります。
>
> ### [YYYY-MM-DD] 教訓のタイトル
> **Domain:** DB・認証 / セキュリティ / アーキテクチャ / 品質 / デザイン / 運用 / ガバナンス / パフォーマンス / その他
> **Target Folder:** blueprint/{実在する対象フォルダ}/
> **Context:** 問題が発生した状況や背景
> **Problem:** 具体的な問題点や失敗内容
> **Solution/Rule:** 解決策、または再発リスク低減のために制定されたルール
> **Reference:** 関連するファイルやコミット（あれば）

---

> [!NOTE]
> ガバナンス教訓は閾値に達したため、[core/020_governance_rules.md](./020_governance_rules.md) に昇華済み。
> このセクションは新しい未分類教訓の一時置き場として空けておく。

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

> [!NOTE]
> 「関連 Universal ルール」列の番号（例: `engineering/200_...`）は参照先 Universal ルールの番号です。教訓を昇華して作成する Blueprint ファイルの採番は `axiarch-rules/{lang}/CRYSTALLIZATION_PROTOCOL.md` に従って文脈で決定し、この番号には拘束されません（フォルダ内 000〜999 の空き番号を使用）。

### クロスリファレンス（関連 Universal ルール）

| カテゴリ | 関連 Universal ルール |
|---|---|
| 教訓の結晶化プロセス | `axiarch-rules/{lang}/CRYSTALLIZATION_PROTOCOL.md` |
| コア原則違反の教訓 | `core/000_core_mindset` |
| セキュリティ教訓 | `security/000_security_privacy` |
| パフォーマンス教訓 | `engineering/000_engineering_standards`, `quality/000_qa_testing` |
| 設計判断の教訓 | 対象ドメインの Universal ルールを参照 |

---

## Appendix B: ドメインファイルテンプレート

> [!IMPORTANT]
> **テンプレートの参照先**
>
> ドメイン教訓ファイルを新規作成する際は、**必ず** `axiarch-rules/{lang}/CRYSTALLIZATION_PROTOCOL.md` の
> 「Crystallized Rule File Template」セクションに記載された**公式テンプレート**に従うこと。
>
> このファイルにテンプレートを二重管理すると CRYSTALLIZATION_PROTOCOL.md との乖離リスクが生じるため廃止。
> **常に `axiarch-rules/{lang}/CRYSTALLIZATION_PROTOCOL.md` を Single Source of Truth とすること。**
