# Google Antigravity Development Rules (Creating-strict-rules)

このリポジトリは、Google Antigravityプロジェクトにおける**絶対的な開発ルール（憲法）**を管理・保存するためのものです。

## 📂 構成

*   **[ANTIGRAVITY_RULES.md](./ANTIGRAVITY_RULES.md)**: 全ルールのマスターインデックス。
*   **[rules/](./rules/)**: カテゴリ別にモジュール化された詳細ルール群。
    *   `00_core_mindset.md`: マインドセット、日本語ルール。
    *   `10_product_business.md`: ビジネス戦略、KPI。
    *   `20_design_ux.md`: デザイン、UX。
    *   `30_engineering_general.md`: エンジニアリング一般。
    *   `31_engineering_mobile_flutter.md`: Flutter開発基準。
    *   `32_engineering_backend_firebase_gcp.md`: Firebase/GCP基準。
    *   `40_operations_workflow.md`: 開発ワークフロー。
*   **[project_specific_rules.md](./project_specific_rules.md)**: 新規プロジェクト用の固有ルールテンプレート。

## 🚀 使い方

新規プロジェクトを開始する際は、本リポジトリの `rules/` フォルダと `ANTIGRAVITY_RULES.md` をプロジェクトのルートにコピー（またはサブモジュールとして追加）し、`project_specific_rules.md` をテンプレートとして固有ルールを定義してください。

## ⚠️ 運用ルール

1.  **絶対遵守**: ここに記載されたルールは、オーナー（ユーザー）と開発チーム（AI）の間の契約であり、絶対的な効力を持つ。
2.  **完全日本語**: 全てのドキュメント、コミット、コミュニケーションは日本語で行う。
3.  **Silicon Valley Standard**: 常にシリコンバレーのトップティア基準で更新し続けること。
