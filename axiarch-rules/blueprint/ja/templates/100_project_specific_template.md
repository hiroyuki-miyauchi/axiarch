# 100. プロジェクト固有ルール・テンプレート (Project Specific Rules Template)

> [!TIP]
> このファイルは、`axiarch-rules/blueprint/{lang}/` の対応ドメインフォルダにコピーして使用します。ファイル名はフォルダ内の連番に従って変更してください（例: `quality/000_security_policy.md`）。
> `universal/` のルールは「憲法」ですが、この `blueprint/` は「法律」であり、プロジェクトの固有事情に合わせて憲法を具体化（または例外的に上書き）する場所です。

---

## 📑 目次 (Table of Contents)

1. [プロジェクト概要](#1-プロジェクト概要-project-overview)
2. [技術スタックの決定](#2-技術スタックの決定-tech-stack-decisions)
3. [デザインシステム上書き](#3-デザインシステム上書き-design-system-overrides)
4. [ビジネスKPI](#4-ビジネスkpi-business-kpis)
5. [セキュリティと法務の特記事項](#5-セキュリティと法務の特記事項-security--legal-specifics)
6. [Appendix A: 逆引き索引 & クロスリファレンス](#appendix-a-逆引き索引--クロスリファレンス)

---

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

---

## Appendix A: 逆引き索引 & クロスリファレンス

### 逆引き索引（キーワード → セクション）

| キーワード | 対応セクション |
|---|---|
| ビジョン・ミッション・ペルソナ | §1 プロジェクト概要 |
| 技術選定・フレームワーク | §2 技術スタック |
| ブランドカラー・フォント・デザイン例外 | §3 デザインシステム上書き |
| KPI・LTV・CAC・ユニットエコノミクス | §4 ビジネスKPI |
| 個人情報・法規制・GDPR・APPI | §5 セキュリティと法務 |

### クロスリファレンス（セクション → Universal ルール）

| セクション | 関連 Universal ルール |
|---|---|
| §1 プロジェクト概要 | `core/000_core_mindset`, `product/000_product_strategy` |
| §2 技術スタック | `engineering/000_engineering_standards`, `engineering/200_supabase_architecture`, `engineering/400_mobile_flutter` |
| §3 デザイン上書き | `design/000_design_ux` |
| §4 ビジネスKPI | `product/000_product_strategy`, `product/300_revenue_monetization` |
| §5 セキュリティ・法務 | `security/000_security_privacy`, `security/100_data_governance`, `security/200_oss_compliance` |

### Blueprint フォルダ & カテゴリ番号帯（ファイル命名ガイド）

| フォルダ | 番号帯 | カテゴリ | 用途例 |
|:--------|:------|:--------|:------|
| `governance/` | 000–099 | ガバナンス & ログ | プロジェクト概要、教訓ログ |
| `quality/` | 000–099 | 品質 & 安全 | セキュリティポリシー、コンプライアンス |
| `design/` | 000–099 | デザイン & UX | デザインシステム、A11y |
| `engineering/` | 000–099 | エンジニアリング | システム構成、API設計 |
| `ai/` | 000–099 | AI & コンテンツ | AI戦略、CMS |
| `product/` | 000–099 | ビジネス & グロース | マネタイズ、マーケティング |
| `specs/` | 000–099 | 機能仕様 | ドメイン固有の設計仕様 |
| `templates/` | 000–099 | テンプレート & 付録 | テンプレートファイル |

> **フォルダ内の連番則 (Universal の慣例に準拠)**: 各フォルダ内で `000_`, `100_`, `200_`... の100単位間隔で採番。フォルダを越えた全体連番は使わない。
