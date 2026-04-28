# エンジニアリング (Engineering)

> このフォルダは `core/010_project_lessons_log.md` から結晶化された
> **エンジニアリングドメイン** のプロジェクト固有ルールの配置先です。

> [!NOTE]
> **初期状態では空であることが正しい設計です。**
> ファイルは `CRYSTALLIZATION_PROTOCOL.md` に従い、実務で蓄積された教訓が閾値（3件）に達した時点で自動的に生成されます。
> シードファイルの事前配置は YAGNI 原則に反するため禁止です。

## 対応 Universal ルール

| ファイル | 概要 |
|:--------|:-----|
| `universal/{lang}/engineering/000_engineering_standards.md` | エンジニアリング基準 |
| `universal/{lang}/engineering/100_api_integration.md` | API・統合基準 |
| `universal/{lang}/engineering/200_supabase_architecture.md` | Supabaseアーキテクチャ |
| `universal/{lang}/engineering/300_web_frontend.md` | Webフロントエンド基準 |
| `universal/{lang}/engineering/310_headless_cms.md` | Headless CMS基準 |
| `universal/{lang}/engineering/400_mobile_flutter.md` | モバイル（Flutter）基準 |
| `universal/{lang}/engineering/410_native_platforms.md` | ネイティブプラットフォーム基準 |
| `universal/{lang}/engineering/500_firebase_gcp.md` | Firebase・GCP基準 |
| `universal/{lang}/engineering/510_aws_cloud.md` | AWSクラウド基準 |

## 運用ガイド

- 教訓の結晶化プロセスは `axiarch-rules/CRYSTALLIZATION_PROTOCOL.md` に従うこと
- ファイル採番は 3桁 Sparse Numbering（10刻み、`000_` は予約）
- 新規ドメインフォルダの作成は禁止（Universal と同型の既存フォルダのみ使用）
