# Antigravity Rules - Directory Index

> [!IMPORTANT]
> **AI Agent Loading Instructions**
>
> 1. **GEMINI.md** (project root): Core protocol for all actions. Load first.
> 2. **universal/**: Immutable universal rules. **Read-only. DO NOT edit.**
> 3. **blueprint/**: Project-specific rules. Actively reference and update.
> 4. **Priority on conflict**: blueprint/ > universal/ > GEMINI.md
> 5. **Language**: Use `ja/` or `en/` matching the project configuration.

> [!IMPORTANT]
> **AIエージェント読み込み指示**
>
> 1. **GEMINI.md**（プロジェクトルート）: 全行動の基礎プロトコル。最初に読み込む
> 2. **universal/**: 不変の汎用ルール。**読み取り専用。編集禁止**
> 3. **blueprint/**: プロジェクト固有ルール。積極的に参照・更新すること
> 4. **矛盾時の優先度**: blueprint/ > universal/ > GEMINI.md
> 5. **言語**: プロジェクト設定に合った `ja/` または `en/` を使用

---

## Directory Structure / ディレクトリ構成

During setup, choose either `ja/` or `en/` and delete the other. After setup, rule files are directly under `universal/` and `blueprint/`.
セットアップ時に `ja/` か `en/` を選択し、不要な方を削除してください。セットアップ後、ルールファイルは `universal/` と `blueprint/` 直下に配置されます。

```
.agent/rules/
├── INDEX.md              ← This file / このファイル（目次・読み込み指示）
├── compliance_matrix.md  ← Request → rule mapping / 要望→ルール対応表
├── README.md             ← Setup guide / セットアップガイド
│
├── universal/            ← Universal rules (Immutable) / 汎用ルール（編集禁止）
│   ├── ja/               ← Japanese / 日本語版（92 files）← セットアップ時に選択
│   └── en/               ← English / 英語版（92 files）  ← Choose during setup
│
└── blueprint/            ← Project-specific (Mutable) / プロジェクト固有（更新推奨）
    ├── ja/               ← セットアップ時に選択
    │   ├── INDEX.md
    │   ├── 000_project_overview.md
    │   ├── 001_project_lessons_log.md
    │   └── 999_project_specific_template.md
    └── en/               ← Choose during setup
        ├── INDEX.md
        ├── 000_project_overview.md
        ├── 001_project_lessons_log.md
        └── 999_project_specific_template.md
```

---

## Universal Rules - Category Map

Each category uses a 3-digit numbering system. Files exist in both `ja/` and `en/` with equivalent content.

各カテゴリは3桁の番号体系を使用。`ja/` と `en/` に同等の内容のファイルが存在します。

---

### 000-099: Core & Mindset / コア・マインドセット

Foundational decision-making hierarchy, elite engineering roles, operational iron rules, and governance protocols.

意思決定ヒエラルキー、エリートエンジニアリングの役割定義、運用鉄則、ガバナンスプロトコル。

| # | Topic (EN) | トピック (JP) |
|---|-----------|-------------|
| 000 | Decision hierarchy & priorities | 意思決定ヒエラルキーと優先度 |
| 001 | Elite roles & collaboration protocol | エリート役割＆協働プロトコル |
| 002 | Development operations iron rules | 開発オペレーション鉄則 |
| 003 | Global governance protocols | グローバルガバナンスプロトコル |

---

### 100-199: Business & Growth / ビジネス・成長戦略

Strategic alignment, unit economics, payment systems, PLG strategy, App Store compliance.

経営層戦略整合、ユニットエコノミクス、決済システム、PLG戦略、ストア準拠。

| # | Topic (EN) | トピック (JP) |
|---|-----------|-------------|
| 100 | C-Level strategic alignment | 経営層戦略整合 |
| 101 | Organizational DNA & search architecture | 組織DNA・検索アーキテクチャ |
| 110 | Unit economics & finance | ユニットエコノミクス・財務 |
| 111 | Payment & compliance | 決済＆コンプライアンス |
| 112 | Promotion & pricing strategy | プロモーション・価格戦略 |
| 120 | Product-Led Growth (PLG) | プロダクト主導成長 |
| 121 | OGP & traffic architecture | OGP・トラフィック |
| 130 | iOS & App Store compliance | iOS＆App Store準拠 |

---

### 200-299: Design & UX / デザイン・UX

Silicon Valley-grade design philosophy, component guidelines, accessibility, responsive/foldable design.

シリコンバレー水準のデザイン哲学、コンポーネント指針、アクセシビリティ、レスポンシブ・折りたたみ対応。

| # | Topic (EN) | トピック (JP) |
|---|-----------|-------------|
| 200 | Design philosophy (Silicon Valley excellence) | デザイン哲学（シリコンバレー基準） |
| 201 | Component guidelines & accessibility | コンポーネント指針＆アクセシビリティ |
| 202-203 | Foldables, adaptability, AI UX strategy | 折りたたみ対応・AI UX戦略 |
| 204 | Design ops & tooling | デザインOps・ツール |

---

### 300-399: Engineering / エンジニアリング

The largest category. Covers code quality, Git workflow, architecture mandates, web frontend (Next.js), CMS/headless, API design, native platforms, and backend/data governance.

最大カテゴリ。コード品質、Gitワークフロー、アーキテクチャ指令、Webフロントエンド（Next.js）、CMS/ヘッドレス、API設計、ネイティブ、バックエンド/データガバナンスを網羅。

| Range | Topic (EN) | トピック (JP) |
|-------|-----------|-------------|
| 300-315 | Core engineering: code quality, Git, architecture mandates, CQRS, type safety | コアエンジニアリング: 品質, Git, アーキテクチャ指令, CQRS, 型安全 |
| 316 | Serverless architecture | サーバーレスアーキテクチャ |
| 320-335 | Web frontend: Next.js, forms, performance, anti-patterns, SSR, React hooks | Webフロントエンド: Next.js, フォーム, パフォーマンス, アンチパターン, SSR |
| 340-341 | CMS & headless architecture, rich text | CMS・ヘッドレス、リッチテキスト |
| 350-351 | API design principles & economy | API設計原則・エコノミー |
| 360 | Native & cross-platform excellence | ネイティブ・クロスプラットフォーム |
| 370-378 | Backend & data: DB sovereignty, RLS, governance, admin services | バックエンド: DB主権, RLS, ガバナンス, 管理サービス |

---

### 400-499: AI & Data / AI・データ

AI UX principles, financial strategy for AI resources, behavioral analytics.

AI UX原則、AIリソースの財務戦略、行動分析。

| # | Topic (EN) | トピック (JP) |
|---|-----------|-------------|
| 400 | AI UX principles (Zero Hallucination) | AI UX原則（ゼロハルシネーション） |
| 401 | Crisis management & edge AI | 危機管理・エッジAI |
| 410 | Behavioral analytics (Amplitude First) | 行動分析（Amplitudeファースト） |

---

### 500-599: Operations / オペレーション

Build vs buy decisions, admin tooling, user support philosophy, SRE, chaos engineering, incident response.

内製 vs 外注判断、管理ツール、ユーザーサポート哲学、SRE、カオスエンジニアリング、インシデント対応。

| # | Topic (EN) | トピック (JP) |
|---|-----------|-------------|
| 500-501 | Build vs buy strategy & admin tools | 内製vs外注戦略・管理ツール |
| 510 | Support philosophy (empathy & efficiency) | サポート哲学（共感＆効率） |
| 520-522 | Chaos engineering, SRE & reliability | カオスエンジニアリング・SRE・信頼性 |
| 530 | Incident response (war room protocol) | インシデント対応（ウォールーム） |

---

### 600-699: Security & Legal / セキュリティ・法務

Security golden rules, authentication (Turnstile, OTP, MFA), CSP, error handling standards, data privacy, licensing, IP protection.

セキュリティ黄金律、認証（Turnstile, OTP, MFA）、CSP、エラー処理標準、データプライバシー、ライセンス、知的財産保護。

| # | Topic (EN) | トピック (JP) |
|---|-----------|-------------|
| 600 | Security golden rule (Security > UX) | セキュリティ黄金律（セキュリティ > UX） |
| 601-606 | Auth, OTP, CSP, error handling, RLS | 認証, OTP, CSP, エラー処理, RLS |
| 610 | Data privacy & consent | データプライバシー・同意 |
| 620 | License compliance | ライセンスコンプライアンス |
| 630 | IP protection | 知的財産保護 |

---

### 700-799: QA & Global / QA・グローバル

Shift-left testing, schema synchronization, internationalization strategy, duty reference.

シフトレフトテスト、スキーマ同期、国際化戦略、義務リファレンス。

| # | Topic (EN) | トピック (JP) |
|---|-----------|-------------|
| 700-701 | Shift-left testing & schema sync diagnostics | シフトレフトテスト・スキーマ同期診断 |
| 710 | Global strategy & internationalization tiers | グローバル戦略・国際化ティア |
| 720 | Duty reference | 義務リファレンス |
| 740 | Language protocol & cognitive load | 言語プロトコル・認知負荷 |
