# オペレーション (Operations)

> このフォルダは `core/010_project_lessons_log.md` から結晶化された
> **オペレーションドメイン** のプロジェクト固有ルールの配置先です。

> [!NOTE]
> ファイルは `CRYSTALLIZATION_PROTOCOL.md` に従い、実務で蓄積された教訓が閾値（3件）に達した時点で自動的に生成されます。
> シードファイルの事前配置は YAGNI 原則に反するため禁止です。現在のファイルは実際の運用教訓が閾値に達したため生成されたものです。

## 結晶化済みルール

| ファイル | 概要 |
|:--|:--|
| [010_release_upgrade_operations.md](./010_release_upgrade_operations.md) | リリース・アップグレード運用におけるCHANGELOG整合、dry-run副作用禁止、interactive入力、local-onlyファイルレビュー、source-only既定skip・明示選択・本体リポジトリ専用ファイル分類、EOF時の確認入力default N、本体リリース中核ファイルのGit追跡確認、対話選択肢重複排除 |

## 対応 Universal ルール

| ファイル | 概要 |
|:--------|:-----|
| `universal/operations/000_internal_tools.md` | 社内ツール基準 |
| `universal/operations/100_sales_bizdev.md` | 営業・事業開発基準 |
| `universal/operations/200_hr_organization.md` | HR・組織基準 |
| `universal/operations/300_customer_experience.md` | 顧客体験基準 |
| `universal/operations/400_site_reliability.md` | サイト信頼性基準 |
| `universal/operations/500_incident_response.md` | インシデント対応基準 |
| `universal/operations/600_cloud_finops.md` | クラウドFinOps基準 |
| `universal/operations/700_partnership_ecosystem.md` | パートナーシップ基準 |

## 運用ガイド

- 教訓の結晶化プロセスは `axiarch-rules/{lang}/CRYSTALLIZATION_PROTOCOL.md` に従うこと
- ファイル採番は 3桁 Sparse Numbering（000〜999の空き番号を使用可能。10刻みは推奨例であり、000も使用可能）
- 新規ドメインフォルダはAIが独断作成しない。既存フォルダを優先し、分類不能な新ドメインはユーザー承認後に拡張可能。
