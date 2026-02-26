# 99. プロジェクト固有ルール・テンプレート (Project Specific Rules Template)

> [!TIP]
> このファイルは、`antigravity-rules/blueprint/` ディレクトリにコピーして使用します。ファイル名は `01_project_rules.md` 等に変更してください。
> `universal/` のルールは「憲法」ですが、この `blueprint/` は「法律」であり、プロジェクトの固有事情に合わせて憲法を具体化（または例外的に上書き）する場所です。

## 1. プロジェクト概要 (Project Overview)
*   **プロジェクト名**: [Project Name]
*   **ミッション (Why)**:
    *   [なぜこのプロジェクトが存在するのか？解決する課題は何か？]
*   **ターゲットユーザー (Who)**:
    *   [誰のためのプロダクトか？ペルソナ定義]
*   **主要な価値 (Value Proposition)**:
    *   [ユーザーが得られる最大のメリットは何か？]

## 2. 技術スタックの決定 (Tech Stack Decisions)
*   **Frontend**: Next.js (App Router) / Flutter
*   **Backend**: Firebase / Supabase / AWS
*   **Database**: Firestore / PostgreSQL
*   **Reasoning**:
    *   [なぜこの技術を選んだのか？Universalルールとの整合性は？]

## 3. デザインシステム上書き (Design System Overrides)
*   **Brand Colors**:
    *   Primary: `[Hex Code]`
    *   Secondary: `[Hex Code]`
*   **Typography**:
    *   Font Family: `[Font Name]`
*   **Exceptions**:
    *   [Universalルールのデザイン規定から逸脱する特別な理由があればここに記述]

## 4. ビジネスKPI (Business KPIs)
*   **North Star Metric**:
    *   [プロジェクトの成功を測る唯一の指標]
*   **Unit Economics Targets**:
    *   LTV 目標: `[Amount]`
    *   CAC 目標: `[Amount]`

## 5. セキュリティと法務の特記事項 (Security & Legal Specifics)
*   **扱うデータの種類**:
    *   [個人情報、決済情報、医療情報など]
*   **適用される法規制**:
    *   [GDPR, APPI, 資金決済法, 薬機法など]
