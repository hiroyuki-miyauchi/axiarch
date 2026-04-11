# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.1.0] — 2026-04-12

### ✨ Design & UX Strategy v3.0 / AGENTS.md Protocol 6 追加

### Added

- **AGENTS.md §6: Anti-Full-Overwrite Protocol** — 既存ファイルの全文上書き（`write_to_file(Overwrite: true)` 相当）を原則禁止する新プロトコル。差分編集（`replace_file_content` / `multi_replace_file_content`）を義務化 / New protocol prohibiting full-file overwrite of existing files by default. Mandates diff-based editing.
- **`.github/workflows/release.yml`** — PRマージ時にCHANGELOG.mdからバージョンを自動検出し、タグ作成→GitHub Release生成まで一気通貫で自動実行するCI/CDワークフロー / Auto-detect version from CHANGELOG.md on PR merge, create tag & GitHub Release automatically

### Changed

- **`universal/{ja,en}/design/000_design_ux.md`** — 25パート完成版 v3.0 にリファクタリング / Refactored to 25-part complete edition v3.0
  - 新規5パート追加: §21 Calm UI, §22 Voice UI, §23 Design System as a Product, §24 WCAG 3.0前方互換性, §25 Design FinOps
  - 技術固有ルール（React/Hydration）を `engineering/` へ委譲
  - EU Digital Fairness Act (DFA) 追加、アンチパターン 30→35選に拡張
  - JA/EN完全構造同期（§25, ###96, 1046行）
- **AGENTS.md** — §5.1→§6昇格、全セクション番号リナンバー（§6→§7, §7→§8, §8→§9） / Section renumbering: Anti-Full-Overwrite promoted to §6, subsequent sections renumbered
- **`axiarch-rules/INDEX.md`** — Design UX概要文を25パート完成版に同期 / Design UX summary synced to 25-part edition
- **`axiarch-rules/LOADING_PROTOCOL.md`** — §7→§8 参照更新 / Reference updated §7→§8
- **`axiarch-rules/CRYSTALLIZATION_PROTOCOL.md`** — §8→§9 参照更新 / Reference updated §8→§9
- **`blueprint/{ja,en}/core/010_project_lessons_log.md`** — §8→§9 参照更新 / Reference updated §8→§9
- **`ROADMAP.md`** — 8プロトコル→9プロトコル / 8 protocols → 9 protocols
- **`llms-full.txt`** — Protocol 6追加、Protocol 7-9リナンバー、Design概要更新 / Protocol 6 added, 7-9 renumbered, Design summary updated

---

## [1.0.0] — 2026-04-10

### 🎉 Initial Public Release

**Axiarch（アクシアーク）** — 憲法駆動型 AIエージェントガバナンスフレームワーク初回公開リリース。

**Axiarch (AX-ee-ark)** — Constitution-Driven AI Agent Governance Framework, initial public release.

### Added

- **AGENTS.md** — AI行動憲法（9プロトコル定義） / AI Behavior Constitution (9 protocols)
- **Universal Rules** — 38ファイル × 2言語（JA/EN）、2,500以上の憲法基準 / 38 files × 2 languages, 2,500+ constitution standards
  - 000: Core & Mindset
  - 100–150: Product & Business Strategy
  - 200: Design & UX
  - 300–361: Engineering (Standards, API, Supabase, Web, CMS, Flutter, Native, Firebase, AWS)
  - 400–401: AI & Data
  - 500–530: Operations & Reliability
  - 600–603: Security & Legal
  - 700–720: QA & FinOps
  - 800–802: Global & Governance
- **Blueprint Templates** — プロジェクト固有テンプレート / Project-specific templates
  - `core/000_project_overview.md` — プロジェクト概要 / Project overview
  - `core/010_project_lessons_log.md` — 教訓ログ / Lessons log
  - `core/998_feature_spec_template.md` — 機能仕様テンプレート / feature spec template
  - `core/999_project_specific_template.md` — プロジェクト固有ルール / Project-specific rules
- **LOADING_PROTOCOL.md** — 5ステップのルールロード手順 / 5-step rule loading protocol
- **CRYSTALLIZATION_PROTOCOL.md** — 教訓の自動結晶化プロトコル / Lesson auto-crystallization protocol
- **INDEX.md** — 全ルールの詳細索引 / Detailed index of all rules
- **compliance_matrix.md** — 要件対照表 / Compliance matrix
- **`init.sh`** — インタラクティブなセットアップスクリプト。言語・エージェント選択→ファイルコピー→次のステップ案内まで自動化 / Interactive setup script automating language/agent selection, file copy, and next-step guidance
- **`.github/CODEOWNERS`** — 最高法規・Universal Rules・Blueprint・プロンプト集の責任範囲を区分したコードオーナー定義 / Code owner definitions with responsibility boundaries
- **`.github/workflows/lint.yml`** — Markdownリント + JA/EN対称性をすべてのPR/pushで自動検証するGitHub Actions CI / GitHub Actions CI: Markdown lint + JA/EN symmetry validation
- **`llms.txt`** — AI検索エンジン向けに構造化されたプロジェクトサマリー（GEO対応） / Structured project summary for AI search engine optimization (GEO)
- **`llms-full.txt`** — AI検索エンジン向け完全仕様書（詳細版） / Full specification document for AI search engines (detailed version)
- **GitHub Discussions** — Q&A・ユースケース共有のコミュニティ基盤 / Community foundation for Q&A and use case sharing
- **`question.yml`** — Q&A用 Issue テンプレート / Q&A issue template
- **Prompt Library (`axiarch-prompts/`)** — 16本 × 2言語（JA/EN）の再利用可能プロンプトテンプレート / 16 templates × 2 languages (JA/EN), reusable prompt library
  - `develop/` — 開発・実行系 4本 / Development & execution (4 prompts): `feature_development`, `refactoring_audit`, `push_execute`, `ci_fix`
  - `audit/` — 品質・整合性監査系 5本 / Quality & integrity auditing (5 prompts): `fullstack_qa_audit`, `api_architecture_audit`, `data_integrity_audit`, `system_integrity_audit`, `deep_optimization_audit`
  - `govern/` — コンプライアンス・ガバナンス系 5本 / Compliance & governance (5 prompts): `compliance_inspector_audit`, `constitution_compliance_audit`, `governance_auditor`, `blueprint_governance_audit`, `localization_audit`
  - `operate/` — インシデント・参入系 2本 / Incident response & onboarding (2 prompts): `onboarding_audit`, `incident_response`
- **`axiarch-prompts/README.md`** — ユースケース別フローチャート・重複解消マトリクス・複合利用ガイドを含む包括的なプロンプト選択ガイド / Comprehensive prompt selection guide with use-case flowchart and compound usage guide

### Background

実際のプロダクション開発でのAI支援開発（Google Antigravity）を通じた数百セッションの実践知見から構築。

Built from hundreds of AI-assisted development sessions on Google Antigravity during real production development.

[1.1.0]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/hiroyuki-miyauchi/axiarch/releases/tag/v1.0.0
