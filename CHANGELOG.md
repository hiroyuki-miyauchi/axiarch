# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] — 2026-04-01

### 🎉 Initial Public Release

**Rampart（ランパート）** — 憲法駆動型 AIエージェントガバナンスフレームワーク初回公開リリース。

**Rampart** — Constitution-Driven AI Agent Governance Framework, initial public release.

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
  - `000_project_overview.md` — プロジェクト概要 / Project overview
  - `010_project_lessons_log.md` — 教訓ログ / Lessons log
  - `998_feature_spec_template.md` — SDD機能仕様テンプレート / SDD feature spec template
  - `999_project_specific_template.md` — プロジェクト固有ルール / Project-specific rules
- **LOADING_PROTOCOL.md** — 5ステップのルールロード手順 / 5-step rule loading protocol
- **CRYSTALLIZATION_PROTOCOL.md** — 教訓の自動結晶化プロトコル / Lesson auto-crystallization protocol
- **INDEX.md** — 全ルールの詳細索引 / Detailed index of all rules
- **compliance_matrix.md** — 要件対照表 / Compliance matrix
- **Prompt Library (`rampart-prompts/`)** — 5本 × 2言語（JA/EN）の再利用可能プロンプトテンプレート / 5 templates × 2 languages (JA/EN), reusable prompt library
  - `blueprint_governance_audit.md` — Blueprint結晶化監査 / Blueprint crystallization audit
  - `feature_development.md` — 汎用新規機能追加 / Feature development
  - `quality_assurance_audit.md` — 品質監査 / Quality assurance audit
  - `push_execute.md` — Git Push実行 / Git Push execution
  - `ci_fix.md` — CI/CDエラー修正 / CI/CD error fix

### Background

実際のプロダクション開発でのAI支援開発（Google Antigravity）を通じた数百セッションの実践知見から構築。

Built from hundreds of AI-assisted development sessions on Google Antigravity during real production development.

[1.0.0]: https://github.com/hiroyuki-miyauchi/rampart/releases/tag/v1.0.0
