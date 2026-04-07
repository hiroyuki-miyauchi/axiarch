# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] — 2026-04-10

### 🎉 Initial Public Release

**Axiarch（アクシアーク）** — 憲法駆動型 AIエージェントガバナンスフレームワーク初回公開リリース。

**Axiarch (AX-ee-ark)** — Constitution-Driven AI Agent Governance Framework, initial public release.

### Added

- **AGENTS.md** — AI行動憲法（8プロトコル定義） / AI Behavior Constitution (8 protocols)
- **Universal Rules** — 30ファイル × 2言語（JA/EN）、2,500以上のエンジニアリング基準 / 30 files × 2 languages, 2,500+ engineering standards
  - 000: Core & Mindset
  - 100–103: Product & Business Strategy
  - 200: Design & UX
  - 300–361: Engineering (Standards, API, Supabase, Web, CMS, Flutter, Native, Firebase, AWS)
  - 400–401: AI & Data
  - 500–503: Operations & Reliability
  - 600–603: Security & Legal
  - 700–720: QA & FinOps
  - 800–802: Global & Governance
- **Blueprint Templates** — プロジェクト固有テンプレート / Project-specific templates
  - `governance/000_project_overview.md` — プロジェクト概要 / Project overview
  - `governance/010_project_lessons_log.md` — 教訓ログ / Lessons log
  - `templates/000_feature_spec_template.md` — SDD機能仕様テンプレート / SDD feature spec template
  - `templates/100_project_specific_template.md` — プロジェクト固有ルール / Project-specific rules
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

[1.0.0]: https://github.com/hiroyuki-miyauchi/axiarch/releases/tag/v1.0.0
