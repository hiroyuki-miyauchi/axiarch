# セキュリティ・プライバシー (Security & Privacy)

> このフォルダは `core/010_project_lessons_log.md` から結晶化された
> **セキュリティ・プライバシードメイン** のプロジェクト固有ルールの配置先です。

> [!NOTE]
> **初期状態では、このREADME以外のドメインルールファイルが未生成であることが正しい設計です。**
> ドメインルールファイルは `CRYSTALLIZATION_PROTOCOL.md` に従い、実務で蓄積された教訓が閾値（3件）に達した時点で生成されます。
> シードファイルの事前配置は YAGNI 原則に反するため禁止です。

## 対応 Universal ルール

| ファイル | 概要 |
|:--------|:-----|
| `universal/security/000_security_privacy.md` | セキュリティ・プライバシー基準 |
| `universal/security/100_data_governance.md` | データガバナンス基準 |
| `universal/security/200_oss_compliance.md` | OSSコンプライアンス基準 |
| `universal/security/300_ip_due_diligence.md` | 知的財産デューデリジェンス |

## 運用ガイド

- 教訓の結晶化プロセスは `axiarch-rules/{lang}/CRYSTALLIZATION_PROTOCOL.md` に従うこと
- ファイル採番は 3桁 Sparse Numbering（000〜999の空き番号を使用可能。10刻みは推奨例であり、000も使用可能）
- 新規ドメインフォルダはAIが独断作成しない。既存フォルダを優先し、分類不能な新ドメインはユーザー承認後に拡張可能。
