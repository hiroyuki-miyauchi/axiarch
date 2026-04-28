# 品質保証・テスト (Quality Assurance & Testing)

> このフォルダは `core/010_project_lessons_log.md` から結晶化された
> **品質保証・テストドメイン** のプロジェクト固有ルールの配置先です。

> [!NOTE]
> **初期状態では空であることが正しい設計です。**
> ファイルは `CRYSTALLIZATION_PROTOCOL.md` に従い、実務で蓄積された教訓が閾値（3件）に達した時点で自動的に生成されます。
> シードファイルの事前配置は YAGNI 原則に反するため禁止です。

## 対応 Universal ルール

| ファイル | 概要 |
|:--------|:-----|
| `universal/{lang}/quality/000_qa_testing.md` | QA・テスト基準 |

## 運用ガイド

- 教訓の結晶化プロセスは `axiarch-rules/CRYSTALLIZATION_PROTOCOL.md` に従うこと
- ファイル採番は 3桁 Sparse Numbering（10刻み、`000_` は予約）
- 新規ドメインフォルダの作成は禁止（Universal と同型の既存フォルダのみ使用）
