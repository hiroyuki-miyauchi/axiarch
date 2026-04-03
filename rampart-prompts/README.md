# プロンプト集 / Prompt Library

## 🇯🇵 日本語

このディレクトリには、Rampartフレームワークの品質を底上げするための**再利用可能なプロンプトテンプレート**を格納します。

### 使い方

1. プロジェクトの言語に合わせて `ja/` または `en/` を選択
2. プロンプトファイルを開く
3. 内容をコピーしてAIエージェントのチャットに貼り付ける
4. 必要に応じてプロジェクト固有の情報を追記する

> **注意**: 初期セットアップ時に `rampart-rules/` と同様、使用しない方の言語ディレクトリを削除できます。

### プロンプト一覧

| ファイル | 用途 |
|:--------|:-----|
| `blueprint_governance_audit.md` | 開発知見をBlueprintルールに結晶化する網羅的監査プロンプト |
| `feature_development.md` | 新機能実装・既存改修・バグ修正・憲法監査を網羅的に実行するプロンプト |
| `quality_assurance_audit.md` | コードベース全体の品質監査・バグ完全解消・全方位ブラッシュアッププロンプト |
| `push_execute.md` | 品質ゲート・DB整合性確認・ブランチ戦略遵守を経たGit Push実行プロンプト |
| `ci_fix.md` | CI/CD失敗時のエラー再現・根本原因分析・修正・ルール還元を一貫実行するプロンプト |

### 専門プロンプト一覧（上級者向け）

以下のプロンプトはプロジェクトの成熟度に応じて構築・運用するものです。

- 憲法遵守監査プロンプト — Universal Rules違反の網羅的検出と是正
- セキュリティ最大化プロンプト — ゼロトラスト・PII保護・脆弱性の徹底排除
- データ整合性監査プロンプト — DB設計・マイグレーション・型安全性の検証
- ローカリゼーション監査プロンプト — UI/UXの完全ローカライズ品質保証
- パフォーマンス最適化プロンプト — Core Web Vitals・FinOps・処理負荷の最適化
- AI/GEO戦略プロンプト — 構造化データ・AI検索最適化・LLM連携設計

---

## 🇺🇸 English

This directory contains **reusable prompt templates** designed to elevate the quality of the Rampart framework.

### Usage

1. Select `ja/` or `en/` based on your project's language
2. Open a prompt file
3. Copy the content and paste it into your AI agent's chat
4. Add project-specific information as needed

> **Note**: During initial setup, you can delete the unused language directory, just like with `rampart-rules/`.

### Prompt Library

| File | Purpose |
|:-----|:--------|
| `blueprint_governance_audit.md` | Comprehensive audit prompt to crystallize development insights into Blueprint rules |
| `feature_development.md` | Comprehensive prompt for new feature implementation, improvement, bug fixing, and compliance auditing |
| `quality_assurance_audit.md` | Full codebase quality audit, zero-defect remediation, and omni-directional enhancement prompt |
| `push_execute.md` | Quality gate, DB integrity check, branch strategy compliance, and Atomic Push execution |
| `ci_fix.md` | CI/CD failure error reproduction, root cause analysis, fix, and rule feedback |

### Specialized Prompts (Advanced)

The following prompts are designed to be built and operated as the project matures.

- Constitutional Compliance Audit — Comprehensive detection and remediation of Universal Rules violations
- Security Maximization — Zero Trust, PII protection, and thorough vulnerability elimination
- Data Integrity Audit — DB design, migration, and type safety verification
- Localization Audit — Complete UI/UX localization quality assurance
- Performance Optimization — Core Web Vitals, FinOps, and processing load optimization
- AI/GEO Strategy — Structured data, AI search optimization, and LLM integration design
