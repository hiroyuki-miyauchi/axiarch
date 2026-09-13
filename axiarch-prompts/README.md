# プロンプト集 / Prompt Library

## 🇯🇵 日本語

このディレクトリには、Axiarchフレームワークの品質を底上げするための**再利用可能なプロンプトテンプレート**を格納します。

### 使い方

**方法 A — Claude Code スラッシュコマンド（v1.13.0+、推奨）**

1. 一度だけ生成: `bash axiarch-scripts/axiarch-prompts-install.sh`（`init.sh` で Claude Code を選びプロンプトをコピーした場合は opt-in で生成済み）
2. Claude Code で `/axiarch-<name>` を入力（例: `/axiarch-feature-development`、`/axiarch-fullstack-qa-audit`）
3. 必要なら同じ行に追加指示を書く（`$ARGUMENTS` として渡る）

生成コマンドは導入先の正本プロンプトを読むよう指示するポインターです。実際の読み込みや手順遵守はエージェント側で確認します。タイトル・言語・ファイル構成を変えた際は `axiarch-scripts/axiarch-prompts-install.sh` を再実行します。導入先の `axiarch-prompts/{lang}/`、`AXIARCH.md`、該当言語の `axiarch-rules/{lang}/LOADING_PROTOCOL.md` が必要です。`--source` は互換入力として受理しますが、別の場所のファイルを暗黙にコピーしません。

言語の自動判定は初期導入・セッション文書と共通です。コード枠・コメント内の例示を除外し、実設定が複数ある場合や値が不明な場合は停止します。設定を整理するか、意図した `--lang ja|en` を明示してください。既存コマンドとの名前衝突は大文字・小文字を区別せず確認し、独自コマンドや手編集済み生成物を置き換えません。

Automatic language selection shares the parser used by initial setup and session documents. It excludes fenced or commented examples and stops on duplicate or unrecognized actual settings. Resolve the setting or pass the intended `--lang ja|en`. Command-name collision checks ignore case; custom commands and edited generated files are preserved.

新しい生成物は内容のハッシュを持ち、未編集と確認できるものだけ更新・削除します。同名の独自ファイル、編集済み生成物、旧形式は保持して終了3。内容をレビューして別名へ退避・統合してから再実行してください。`--clean --dry-run` は削除予定の表示だけです。機能そのものが任意で、生成の成功はエージェントでの動作実証ではありません。

**方法 B — コピペ運用（全エージェント共通）**

1. プロジェクトの言語に合わせて `ja/` または `en/` を選択
2. 用途に合うフォルダを開く（`develop/`, `audit/`, `govern/`, `operate/`）
3. プロンプトファイルを開く
4. 内容をコピーしてAIエージェントのチャットに貼り付ける
5. 具体的な対象と目的を添えて実行する。提示済みの要件で着手し、不可欠な不足情報だけ確認する

> エージェント別の生成対象: この補助ツールは `.claude/commands/` 向けのファイルだけ生成します。Claude Codeを含む他エージェントはAxiarchでの実務動作が未実証で、動作保証はしません。Google Antigravityの実務実証と、この生成機能の検証は別です。他の導入方法では方法Bまたは `AGENTS.md` から正本を参照します。

> **注意**: 既定では日本語・英語ディレクトリを両方保持します。単一言語運用に明示的に固定する場合だけ、`axiarch-rules/` と同様に、使用しない方の言語ディレクトリをレビューして削除できます。

> ネイティブタスク状態: 適用範囲に応じ、利用可能な場合にCodexの `update_plan`、Claude CodeのTask toolsを併用します。利用できない場合は理由を記録して作業を継続します。`.axiarch/sessions/{session_id}/` の3文書は現在タスク用のMarkdown証跡で、UIを自動更新しません。H0/H1の軽量な扱いは `AXIARCH.md` を参照してください。

> **実行ハーネスとの関係**: これらのプロンプトは `AXIARCH.md` と `axiarch-harness/` の代替ではありません。ハーネスエンジニアリングとして扱う実行、監査、証跡、人間承認、サブエージェント委任の境界は、常に `AXIARCH.md` と関連する harness protocol を正本として確認してください。

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
| 新機能を実装したい | `develop/` | `axiarch-prompts/ja/develop/feature_development.md` |
| 既存コードを整理・改善したい（動作は変えない） | `develop/` | `axiarch-prompts/ja/develop/refactoring_audit.md` |
| Git Push を実行したい | `develop/` | `axiarch-prompts/ja/develop/push_execute.md` |
| CI/CD が失敗した | `develop/` | `axiarch-prompts/ja/develop/ci_fix.md` |
| 既存Axiarch採用プロジェクトを必要分だけアップグレードしたい | `develop/` | `axiarch-prompts/ja/develop/safe_upgrade_execute.md` |
| コード全体を総合的に品質監査したい | `audit/` | `axiarch-prompts/ja/audit/fullstack_qa_audit.md` |
| API設計・DTO・ゼロトラストを監査したい | `audit/` | `axiarch-prompts/ja/audit/api_architecture_audit.md` |
| データ整合性（JSON逃がし・Split Brain）を検査したい | `audit/` | `axiarch-prompts/ja/audit/data_integrity_audit.md` |
| 型安全性・API/DB同期・ハリボテを検出したい | `audit/` | `axiarch-prompts/ja/audit/system_integrity_audit.md` |
| パフォーマンス・メディア最適化の漏れを検出したい | `audit/` | `axiarch-prompts/ja/audit/deep_optimization_audit.md` |
| 憲法（AXIARCH.md / Universal Rules）への準拠を監査したい | `govern/` | `axiarch-prompts/ja/govern/constitution_compliance_audit.md` または `axiarch-prompts/ja/govern/compliance_inspector_audit.md` |
| セキュリティ・法務・AI・アーキテクチャの全方位ガバナンス監査 | `govern/` | `axiarch-prompts/ja/govern/governance_auditor.md` |
| 開発知見をBlueprintルールに結晶化したい | `govern/` | `axiarch-prompts/ja/govern/blueprint_governance_audit.md` |
| ローカリゼーション品質を監査したい | `govern/` | `axiarch-prompts/ja/govern/localization_audit.md` |
| 新しいセッション・新メンバーがプロジェクトを理解したい | `operate/` | `axiarch-prompts/ja/operate/onboarding_audit.md` |
| 本番障害が発生した | `operate/` | `axiarch-prompts/ja/operate/incident_response.md` |

---

### プロンプトの重複解消マトリクス

以下の3つのプロンプトは名前が似ていますが、役割が異なります：

| プロンプト | 焦点 | 使い分け |
|:---------|:----|:--------|
| `axiarch-prompts/ja/govern/governance_auditor.md` | 8柱（Security/Business/Legal/AI/Architecture等）の**全方位ガバナンス**。ビジネス・法務・ROIまで含む広範な監査 | プロジェクト全体の健全性を定期的に評価したいとき |
| `axiarch-prompts/ja/govern/constitution_compliance_audit.md` | **憲法（AXIARCH.md / Universal Rules）への準拠**に特化。7つの重大違反フレームワーク | ルール違反が疑われるとき・憲法との乖離を検証したいとき |
| `axiarch-prompts/ja/govern/compliance_inspector_audit.md` | **8つの重大憲法違反**フレームワーク。より詳細かつ厳格な違反検出 | 深層レベルのコンプライアンス徹底調査をしたいとき |

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
operate/incident_response → develop/ci_fix（CI修正が必要な場合）→ govern/blueprint_governance_audit（再発リスク低減ルール化）
```

**リリース前チェック:**
```
audit/system_integrity_audit → develop/push_execute
```

**既存Axiarch採用プロジェクトのアップグレード:**
```
develop/safe_upgrade_execute → develop/push_execute（pushが必要な場合）
```

---

### プロンプト一覧

#### 🚀 develop/ — 開発・実行

| ファイル | 用途 |
|:--------|:-----|
| `axiarch-prompts/ja/develop/feature_development.md` | 新機能実装・既存改修・バグ修正・憲法監査を網羅的に実行するプロンプト |
| `axiarch-prompts/ja/develop/refactoring_audit.md` | 既存コードの動作を保ったまま構造・型安全・DRY原則を高い水準まで改善する非破壊的リファクタリング監査プロンプト |
| `axiarch-prompts/ja/develop/push_execute.md` | 品質ゲート・DB整合性確認・ブランチ戦略遵守を経たGit Push実行プロンプト |
| `axiarch-prompts/ja/develop/ci_fix.md` | CI/CD失敗時のエラー再現・根本原因分析・修正・ルール還元を一貫実行するプロンプト |
| `axiarch-prompts/ja/develop/safe_upgrade_execute.md` | Safe Upgrade Wizardを使い、manifestに基づくAxiarch Core更新・Project State保持・source-only既定skip・明示選択・対話選択肢重複排除・任意prompt選択・dry-run/apply検証を実行するプロンプト |

#### 🔍 audit/ — 品質・整合性監査

| ファイル | 用途 |
|:--------|:-----|
| `axiarch-prompts/ja/audit/fullstack_qa_audit.md` | セキュリティ・プライバシーの継続改善を筆頭に実務で検証可能な高い品質基準6柱・優先度付き報告（Critical/High/Medium）・ROI提案・Domain Distributionによる知見還元を含む統合監査プロンプト |
| `axiarch-prompts/ja/audit/api_architecture_audit.md` | API設計・DTO義務・ゼロトラスト・オムニチャネル対応を軸とした全方位構造監査プロンプト |
| `axiarch-prompts/ja/audit/data_integrity_audit.md` | JSON逃がし・Hybrid Sync・Split Brain・ハリボテ実装を検知するデータ整合性監査プロンプト |
| `axiarch-prompts/ja/audit/system_integrity_audit.md` | 型安全性・API/DB同期・ハリボテ検知・データマネタイズ戦略を軸としたシステム全体整合性監査プロンプト |
| `axiarch-prompts/ja/audit/deep_optimization_audit.md` | メディア/LCP/SSR最適化漏れの根本原因特定・解消を軸としたシステム全体の深層最適化監査プロンプト |

#### ⚖️ govern/ — コンプライアンス・ガバナンス

| ファイル | 用途 |
|:--------|:-----|
| `axiarch-prompts/ja/govern/compliance_inspector_audit.md` | Universal/Blueprint法への準拠状況を深く点検する8つの重大憲法違反フレームワークに基づくコンプライアンス監査プロンプト |
| `axiarch-prompts/ja/govern/constitution_compliance_audit.md` | 7つの重大憲法違反（アーキテクチャ・収益化統合・型安全・最適化・ハリボテ・根本原因）を軸とした深層憲法遵守スキャンプロンプト |
| `axiarch-prompts/ja/govern/governance_auditor.md` | 8つの柱（Security/Business/Legal/AI/Architecture/保守性/UX/Performance）で行う全方位ガバナンス監査・専用レポートフォーマット付きプロンプト |
| `axiarch-prompts/ja/govern/blueprint_governance_audit.md` | 開発知見をBlueprintルールに結晶化する網羅的監査プロンプト |
| `axiarch-prompts/ja/govern/localization_audit.md` | Lazy English検出・一貫した日本語UI・LTV・AI/GEO・法務の全方位ローカリゼーション監査プロンプト |

#### 🛡️ operate/ — インシデント・参入

| ファイル | 用途 |
|:--------|:-----|
| `axiarch-prompts/ja/operate/onboarding_audit.md` | 新セッション/メンバー参加時にコードベースを深く理解しアーキテクチャ・地雷・最初のアクションを把握する参入監査プロンプト |
| `axiarch-prompts/ja/operate/incident_response.md` | 本番障害のトリアージ・5 Whys根本原因分析・緊急修正・ポストモーテム・再発リスク低減のためのルール還元まで扱うSRE専用プロンプト |

---

## 🇺🇸 English

This directory contains **reusable prompt templates** designed to elevate the quality of the Axiarch framework.

### Usage

**Option A — Claude Code slash commands (v1.13.0+, recommended)**

1. Generate once: `bash axiarch-scripts/axiarch-prompts-install.sh` (already generated opt-in if you chose Claude Code and copied prompts during `init.sh`)
2. In Claude Code, type `/axiarch-<name>` (e.g. `/axiarch-feature-development`, `/axiarch-fullstack-qa-audit`)
3. Optionally add instructions on the same line (passed as `$ARGUMENTS`)

Generated commands instruct the agent to read an installed canonical prompt; actual reading and adherence still need verification. Regenerate after changing titles, language or file layout. The target must contain `axiarch-prompts/{lang}/`, `AXIARCH.md` and the selected language's `axiarch-rules/{lang}/LOADING_PROTOCOL.md`. `--source` is accepted for compatibility but never implicitly copies external files.

New commands include a content hash; only unmodified generated files are replaced or removed. Custom collisions, edited commands and legacy output are preserved with exit 3. Review and move or reconcile them before retrying. `--clean --dry-run` only previews deletion. This feature is optional, and successful file generation is not an agent runtime validation.

**Option B — Copy-paste (all agents)**

1. Select `ja/` or `en/` based on your project's language
2. Open the folder matching your goal (`develop/`, `audit/`, `govern/`, `operate/`)
3. Open a prompt file
4. Copy the content and paste it into your AI agent's chat
5. Include the target and objective. The agent starts from supplied requirements and asks only for essential missing information.

> Generated adapter scope: This helper only generates files under `.claude/commands/`. Axiarch operation with Claude Code and other agents remains unverified, with no operation guarantee. Practical validation with Google Antigravity is separate from testing this generator. Other workflows may use Option B or reference the canonical prompt through `AGENTS.md`.

> **Note**: Keep both Japanese and English directories by default. Only when intentionally fixing the project to single-language operation, review and remove the unused language directory, as with `axiarch-rules/`.

> Native task state: Within the applicable scope, use Codex `update_plan` or Claude Code Task tools when available. Otherwise record the limitation and continue. The three Markdown records under `.axiarch/sessions/{session_id}/` do not update the native UI automatically. See `AXIARCH.md` for lighter H0/H1 handling.

> **Execution harness relationship**: These prompts do not replace `AXIARCH.md` or `axiarch-harness/`. Harness Engineering boundaries for execution, audit, evidence, human approval, and subagent delegation must always be checked against `AXIARCH.md` and the relevant harness protocol as the source of truth.

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
| Implementing a new feature | `develop/` | `axiarch-prompts/en/develop/feature_development.md` |
| Cleaning up / improving existing code (without changing behavior) | `develop/` | `axiarch-prompts/en/develop/refactoring_audit.md` |
| Executing a Git Push | `develop/` | `axiarch-prompts/en/develop/push_execute.md` |
| CI/CD pipeline has failed | `develop/` | `axiarch-prompts/en/develop/ci_fix.md` |
| Selectively upgrading an existing Axiarch adopter project | `develop/` | `axiarch-prompts/en/develop/safe_upgrade_execute.md` — source-only default skip with explicit selection, deduplicated interactive choices, optional prompts, and dry-run/apply verification |
| Comprehensive quality audit of the entire codebase | `audit/` | `axiarch-prompts/en/audit/fullstack_qa_audit.md` |
| Audit API design, DTO obligations, and Zero Trust | `audit/` | `axiarch-prompts/en/audit/api_architecture_audit.md` |
| Inspect data integrity (JSON dump, Split Brain) | `audit/` | `axiarch-prompts/en/audit/data_integrity_audit.md` |
| Detect type safety issues, API/DB sync, and facade patterns | `audit/` | `axiarch-prompts/en/audit/system_integrity_audit.md` |
| Detect performance and media optimization gaps | `audit/` | `axiarch-prompts/en/audit/deep_optimization_audit.md` |
| Audit compliance with the Constitution (AXIARCH.md / Universal Rules) | `govern/` | `axiarch-prompts/en/govern/constitution_compliance_audit.md` or `axiarch-prompts/en/govern/compliance_inspector_audit.md` |
| Full-spectrum governance audit (Security/Legal/AI/Architecture) | `govern/` | `axiarch-prompts/en/govern/governance_auditor.md` |
| Crystallize development insights into Blueprint rules | `govern/` | `axiarch-prompts/en/govern/blueprint_governance_audit.md` |
| Audit localization quality | `govern/` | `axiarch-prompts/en/govern/localization_audit.md` |
| New session / member needs to understand the project | `operate/` | `axiarch-prompts/en/operate/onboarding_audit.md` |
| Production incident has occurred | `operate/` | `axiarch-prompts/en/operate/incident_response.md` |

---

### Duplicate Resolution Matrix

These three prompts have similar names but distinct roles:

| Prompt | Focus | When to Use |
|:-------|:------|:------------|
| `axiarch-prompts/en/govern/governance_auditor.md` | **Full-spectrum governance** across 8 pillars (Security/Business/Legal/AI/Architecture, etc.). Covers business, legal, and ROI. | Periodic overall health evaluation of the project |
| `axiarch-prompts/en/govern/constitution_compliance_audit.md` | **Constitutional compliance** (AXIARCH.md / Universal Rules). 7 major violation framework. | When rule violations are suspected or you want to verify alignment |
| `axiarch-prompts/en/govern/compliance_inspector_audit.md` | **8 major constitutional violations** framework — deeper and more rigorous. | Deep-dive constitutional compliance investigation |

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
operate/incident_response → develop/ci_fix (if CI fix needed) → govern/blueprint_governance_audit (reduce recurrence risk)
```

**Pre-release check:**
```
audit/system_integrity_audit → develop/push_execute
```

**Existing Axiarch adopter upgrade:**
```
develop/safe_upgrade_execute → develop/push_execute (when push is required)
```

---

### Prompt Library

#### 🚀 develop/ — Development & Execution

| File | Purpose |
|:-----|:--------|
| `axiarch-prompts/en/develop/feature_development.md` | Comprehensive prompt for new feature implementation, improvement, bug fixing, and compliance auditing |
| `axiarch-prompts/en/develop/refactoring_audit.md` | Non-destructive refactoring audit — elevate structure, type safety, and DRY principles to the maximum without changing existing behavior |
| `axiarch-prompts/en/develop/push_execute.md` | Quality gate, DB integrity check, branch strategy compliance, and Atomic Push execution |
| `axiarch-prompts/en/develop/ci_fix.md` | CI/CD failure error reproduction, root cause analysis, fix, and rule feedback |
| `axiarch-prompts/en/develop/safe_upgrade_execute.md` (`axiarch-prompts/en/develop/safe_upgrade_execute.md`) | Safe Upgrade Wizard execution prompt for manifest-based Axiarch Core updates, Project State preservation, source-only default skip with explicit selection, deduplicated interactive choices, optional prompt selection, and dry-run/apply verification |

#### 🔍 audit/ — Quality & Integrity Auditing

| File | Purpose |
|:-----|:--------|
| `axiarch-prompts/en/audit/fullstack_qa_audit.md` | Full-Stack QA & Strategic audit — 6-Pillar practice-proven quality standard with priority reporting (Critical/High/Medium), ROI proposals, Domain Distribution knowledge feedback |
| `axiarch-prompts/en/audit/api_architecture_audit.md` | Omni-directional structural audit — API design, DTO obligations, Zero Trust, and omnichannel readiness |
| `axiarch-prompts/en/audit/data_integrity_audit.md` | Data integrity audit — JSON dump detection, Hybrid Sync / Split Brain elimination, and lazy redirect (haribote) detection |
| `axiarch-prompts/en/audit/system_integrity_audit.md` | System integrity audit — type safety, API/DB sync, facade detection, and data monetization readiness |
| `axiarch-prompts/en/audit/deep_optimization_audit.md` | Deep optimization audit — media/LCP/SSR gap root cause detection, elimination, and full-system integrity |

#### ⚖️ govern/ — Compliance & Governance

| File | Purpose |
|:-----|:--------|
| `axiarch-prompts/en/govern/compliance_inspector_audit.md` | Deep constitutional compliance audit — 8 Major Constitutional Violations framework for assessing adherence to Universal/Blueprint laws |
| `axiarch-prompts/en/govern/constitution_compliance_audit.md` | Constitutional compliance scan — 7 Major Violations (architecture & monetization combined, type safety, optimization, facade, root cause) |
| `axiarch-prompts/en/govern/governance_auditor.md` | Holistic governance audit — 8-Pillar framework (Security/Business/Legal/AI/Architecture/Maintainability/UX/Performance) with structured report format |
| `axiarch-prompts/en/govern/blueprint_governance_audit.md` | Comprehensive audit prompt to crystallize development insights into Blueprint rules |
| `axiarch-prompts/en/govern/localization_audit.md` | Localization audit — detecting untranslated/non-localized UI text and improving localized UI consistency with LTV/AI/GEO/Legal multi-dimensional optimization |

#### 🛡️ operate/ — Incident Response & Onboarding

| File | Purpose |
|:-----|:--------|
| `axiarch-prompts/en/operate/onboarding_audit.md` | Codebase onboarding audit — deeply understand architecture, landmines, and first actions when joining a new session or project |
| `axiarch-prompts/en/operate/incident_response.md` | SRE-focused prompt — triage, 5 Whys RCA, emergency fix, post-mortem, and recurrence-risk-reduction rule crystallization for production incidents |
