# プロンプト集 / Prompt Library

## 🇯🇵 日本語

このディレクトリには、Axiarchフレームワークの品質を底上げするための**再利用可能なプロンプトテンプレート**を格納します。

### 使い方

1. プロジェクトの言語に合わせて `ja/` または `en/` を選択
2. 用途に合うフォルダを開く（`develop/`, `audit/`, `govern/`, `operate/`）
3. プロンプトファイルを開く
4. 内容をコピーしてAIエージェントのチャットに貼り付ける
5. AIが待機状態に入るので、具体的な指示を追加する

> **注意**: 初期セットアップ時に使用しない方の言語ディレクトリを削除できます（`axiarch-rules/` と同様）。

---

### フォルダ構成

```
ja/  (または en/)
├── develop/    🚀 開発・実行
├── audit/      🔍 品質・整合性監査
├── govern/     ⚖️ コンプライアンス・ガバナンス
└── operate/    🛡️ インシデント・参入
```

---

### どのフォルダを選ぶか？ — 今の状況から選ぶ

> [!TIP]
> 「今、何をしたいか」でフォルダを選んでください。

| 今の状況 | フォルダ | プロンプト |
|:--------|:--------|:---------|
| 新機能を実装したい | `develop/` | `feature_development.md` |
| 既存コードを整理・改善したい（動作は変えない） | `develop/` | `refactoring_audit.md` |
| Git Push を実行したい | `develop/` | `push_execute.md` |
| CI/CD が失敗した | `develop/` | `ci_fix.md` |
| コード全体を総合的に品質監査したい | `audit/` | `fullstack_qa_audit.md` |
| API設計・DTO・ゼロトラストを監査したい | `audit/` | `api_architecture_audit.md` |
| データ整合性（JSON逃がし・Split Brain）を検査したい | `audit/` | `data_integrity_audit.md` |
| 型安全性・API/DB同期・ハリボテを検出したい | `audit/` | `system_integrity_audit.md` |
| パフォーマンス・メディア最適化の漏れを検出したい | `audit/` | `deep_optimization_audit.md` |
| 憲法（AGENTS.md / Universal Rules）への準拠を監査したい | `govern/` | `constitution_compliance_audit.md` または `compliance_inspector_audit.md` |
| セキュリティ・法務・AI・アーキテクチャの全方位ガバナンス監査 | `govern/` | `governance_auditor.md` |
| 開発知見をBlueprintルールに結晶化したい | `govern/` | `blueprint_governance_audit.md` |
| ローカリゼーション品質を監査したい | `govern/` | `localization_audit.md` |
| 新しいセッション・新メンバーがプロジェクトを理解したい | `operate/` | `onboarding_audit.md` |
| 本番障害が発生した | `operate/` | `incident_response.md` |

---

### プロンプトの重複解消マトリクス

以下の3つのプロンプトは名前が似ていますが、役割が異なります：

| プロンプト | 焦点 | 使い分け |
|:---------|:----|:--------|
| `governance_auditor.md` | 8柱（Security/Business/Legal/AI/Architecture等）の**全方位ガバナンス**。ビジネス・法務・ROIまで含む広範な監査 | プロジェクト全体の健全性を定期的に評価したいとき |
| `constitution_compliance_audit.md` | **憲法（AGENTS.md / Universal Rules）への準拠**に特化。7つの重大違反フレームワーク | ルール違反が疑われるとき・憲法との乖離を検証したいとき |
| `compliance_inspector_audit.md` | **8つの重大憲法違反**フレームワーク。より詳細かつ厳格な違反検出 | 深層レベルのコンプライアンス徹底調査をしたいとき |

---

### 推奨実行順序（プロンプトの複合利用）

**新規プロジェクト参加時:**
```
operate/onboarding_audit → develop/feature_development（最初のタスク）
```

**定期品質サイクル:**
```
audit/fullstack_qa_audit → govern/blueprint_governance_audit（知見結晶化）
```

**大規模リファクタリング前:**
```
operate/onboarding_audit（現状把握） → develop/refactoring_audit（実行）
```

**本番障害時:**
```
operate/incident_response → develop/ci_fix（CI修正が必要な場合）→ govern/blueprint_governance_audit（再発防止ルール化）
```

**リリース前チェック:**
```
audit/system_integrity_audit → develop/push_execute
```

---

### プロンプト一覧

#### 🚀 develop/ — 開発・実行

| ファイル | 用途 |
|:--------|:-----|
| `feature_development.md` | 新機能実装・既存改修・バグ修正・憲法監査を網羅的に実行するプロンプト |
| `refactoring_audit.md` | 既存コードの動作を保ったまま構造・型安全・DRY原則を極限まで改善する非破壊的リファクタリング監査プロンプト |
| `push_execute.md` | 品質ゲート・DB整合性確認・ブランチ戦略遵守を経たGit Push実行プロンプト |
| `ci_fix.md` | CI/CD失敗時のエラー再現・根本原因分析・修正・ルール還元を一貫実行するプロンプト |

#### 🔍 audit/ — 品質・整合性監査

| ファイル | 用途 |
|:--------|:-----|
| `fullstack_qa_audit.md` | セキュリティ・プライバシー最大化を筆頭にシリコンバレー基準6柱・優先度付き報告（Critical/High/Medium）・ROI提案・Domain Distributionによる知見還元を含む統合監査プロンプト |
| `api_architecture_audit.md` | API設計・DTO義務・ゼロトラスト・オムニチャネル対応を軸とした全方位構造監査プロンプト |
| `data_integrity_audit.md` | JSON逃がし・Hybrid Sync・Split Brain・ハリボテ実装を検知するデータ整合性監査プロンプト |
| `system_integrity_audit.md` | 型安全性・API/DB同期・ハリボテ検知・データマネタイズ戦略を軸としたシステム全体整合性監査プロンプト |
| `deep_optimization_audit.md` | メディア/LCP/SSR最適化漏れの根本原因特定・解消を軸としたシステム全体の深層最適化監査プロンプト |

#### ⚖️ govern/ — コンプライアンス・ガバナンス

| ファイル | 用途 |
|:--------|:-----|
| `compliance_inspector_audit.md` | Universal/Blueprint法への完全準拠を強制する8つの重大憲法違反フレームワークに基づく深層コンプライアンス監査プロンプト |
| `constitution_compliance_audit.md` | 7つの重大憲法違反（アーキテクチャ・収益化統合・型安全・最適化・ハリボテ・根本原因）を軸とした深層憲法遵守スキャンプロンプト |
| `governance_auditor.md` | 8つの柱（Security/Business/Legal/AI/Architecture/保守性/UX/Performance）で行う全方位ガバナンス監査・専用レポートフォーマット付きプロンプト |
| `blueprint_governance_audit.md` | 開発知見をBlueprintルールに結晶化する網羅的監査プロンプト |
| `localization_audit.md` | Lazy English排除・UI日本語化率100%・LTV・AI/GEO・法務の全方位ローカリゼーション監査プロンプト |

#### 🛡️ operate/ — インシデント・参入

| ファイル | 用途 |
|:--------|:-----|
| `onboarding_audit.md` | 新セッション/メンバー参加時にコードベースを深く理解しアーキテクチャ・地雷・最初のアクションを把握する参入監査プロンプト |
| `incident_response.md` | 本番障害のトリアージ・5 Whys根本原因分析・緊急修正・ポストモーテム・再発防止ルール還元まで一貫実行するSRE専用プロンプト |

---

## 🇺🇸 English

This directory contains **reusable prompt templates** designed to elevate the quality of the Axiarch framework.

### Usage

1. Select `ja/` or `en/` based on your project's language
2. Open the folder matching your goal (`develop/`, `audit/`, `govern/`, `operate/`)
3. Open a prompt file
4. Copy the content and paste it into your AI agent's chat
5. The AI enters standby mode — then add your specific instructions

> **Note**: During initial setup, you can delete the unused language directory, just like with `axiarch-rules/`.

---

### Folder Structure

```
ja/  (or en/)
├── develop/    🚀 Development & Execution
├── audit/      🔍 Quality & Integrity Auditing
├── govern/     ⚖️ Compliance & Governance
└── operate/    🛡️ Incident Response & Onboarding
```

---

### Which Folder? — Choose by Situation

> [!TIP]
> Pick the folder that matches what you are doing right now.

| Situation | Folder | Prompt |
|:----------|:-------|:-------|
| Implementing a new feature | `develop/` | `feature_development.md` |
| Cleaning up / improving existing code (without changing behavior) | `develop/` | `refactoring_audit.md` |
| Executing a Git Push | `develop/` | `push_execute.md` |
| CI/CD pipeline has failed | `develop/` | `ci_fix.md` |
| Comprehensive quality audit of the entire codebase | `audit/` | `fullstack_qa_audit.md` |
| Audit API design, DTO obligations, and Zero Trust | `audit/` | `api_architecture_audit.md` |
| Inspect data integrity (JSON dump, Split Brain) | `audit/` | `data_integrity_audit.md` |
| Detect type safety issues, API/DB sync, and facade patterns | `audit/` | `system_integrity_audit.md` |
| Detect performance and media optimization gaps | `audit/` | `deep_optimization_audit.md` |
| Audit compliance with the Constitution (AGENTS.md / Universal Rules) | `govern/` | `constitution_compliance_audit.md` or `compliance_inspector_audit.md` |
| Full-spectrum governance audit (Security/Legal/AI/Architecture) | `govern/` | `governance_auditor.md` |
| Crystallize development insights into Blueprint rules | `govern/` | `blueprint_governance_audit.md` |
| Audit localization quality | `govern/` | `localization_audit.md` |
| New session / member needs to understand the project | `operate/` | `onboarding_audit.md` |
| Production incident has occurred | `operate/` | `incident_response.md` |

---

### Duplicate Resolution Matrix

These three prompts have similar names but distinct roles:

| Prompt | Focus | When to Use |
|:-------|:------|:------------|
| `governance_auditor.md` | **Full-spectrum governance** across 8 pillars (Security/Business/Legal/AI/Architecture, etc.). Covers business, legal, and ROI. | Periodic overall health evaluation of the project |
| `constitution_compliance_audit.md` | **Constitutional compliance** (AGENTS.md / Universal Rules). 7 major violation framework. | When rule violations are suspected or you want to verify alignment |
| `compliance_inspector_audit.md` | **8 major constitutional violations** framework — deeper and more rigorous. | Deep-dive constitutional compliance investigation |

---

### Recommended Execution Order (Compound Usage)

**When joining a new project:**
```
operate/onboarding_audit → develop/feature_development (first task)
```

**Regular quality cycle:**
```
audit/fullstack_qa_audit → govern/blueprint_governance_audit (crystallize insights)
```

**Before major refactoring:**
```
operate/onboarding_audit (assess current state) → develop/refactoring_audit (execute)
```

**During a production incident:**
```
operate/incident_response → develop/ci_fix (if CI fix needed) → govern/blueprint_governance_audit (prevent recurrence)
```

**Pre-release check:**
```
audit/system_integrity_audit → develop/push_execute
```

---

### Prompt Library

#### 🚀 develop/ — Development & Execution

| File | Purpose |
|:-----|:--------|
| `feature_development.md` | Comprehensive prompt for new feature implementation, improvement, bug fixing, and compliance auditing |
| `refactoring_audit.md` | Non-destructive refactoring audit — elevate structure, type safety, and DRY principles to the maximum without changing existing behavior |
| `push_execute.md` | Quality gate, DB integrity check, branch strategy compliance, and Atomic Push execution |
| `ci_fix.md` | CI/CD failure error reproduction, root cause analysis, fix, and rule feedback |

#### 🔍 audit/ — Quality & Integrity Auditing

| File | Purpose |
|:-----|:--------|
| `fullstack_qa_audit.md` | Full-Stack QA & Strategic audit — 6-Pillar Silicon Valley Standard with priority reporting (Critical/High/Medium), ROI proposals, Domain Distribution knowledge feedback |
| `api_architecture_audit.md` | Omni-directional structural audit — API design, DTO obligations, Zero Trust, and omnichannel readiness |
| `data_integrity_audit.md` | Data integrity audit — JSON dump detection, Hybrid Sync / Split Brain elimination, and lazy redirect (haribote) detection |
| `system_integrity_audit.md` | System integrity audit — type safety, API/DB sync, facade detection, and data monetization readiness |
| `deep_optimization_audit.md` | Deep optimization audit — media/LCP/SSR gap root cause detection, elimination, and full-system integrity |

#### ⚖️ govern/ — Compliance & Governance

| File | Purpose |
|:-----|:--------|
| `compliance_inspector_audit.md` | Deep constitutional compliance audit — 8 Major Constitutional Violations framework enforcing full adherence to Universal/Blueprint laws |
| `constitution_compliance_audit.md` | Constitutional compliance scan — 7 Major Violations (architecture & monetization combined, type safety, optimization, facade, root cause) |
| `governance_auditor.md` | Holistic governance audit — 8-Pillar framework (Security/Business/Legal/AI/Architecture/Maintainability/UX/Performance) with structured report format |
| `blueprint_governance_audit.md` | Comprehensive audit prompt to crystallize development insights into Blueprint rules |
| `localization_audit.md` | Localization audit — eliminating Lazy non-English UI text, achieving 100% English UI with LTV/AI/GEO/Legal multi-dimensional optimization |

#### 🛡️ operate/ — Incident Response & Onboarding

| File | Purpose |
|:-----|:--------|
| `onboarding_audit.md` | Codebase onboarding audit — deeply understand architecture, landmines, and first actions when joining a new session or project |
| `incident_response.md` | SRE-focused prompt — triage, 5 Whys RCA, emergency fix, post-mortem, and recurrence-prevention rule crystallization for production incidents |
