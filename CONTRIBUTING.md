# Contributing to Axiarch / Axiarchへの貢献

## 🇯🇵 日本語

Axiarchへの関心をお寄せいただきありがとうございます。

### 貢献の方針

Axiarchは現在、個人プロジェクトとして管理されています。以下の方針でコントリビューションを受け付けています。

**歓迎するもの:**

- バグ報告・ルールの矛盾や欠陥の指摘（[GitHub Issues](https://github.com/hiroyuki-miyauchi/axiarch/issues)）
- 新しいUniversal Ruleの提案
- 既存ルールの改善提案
- ドキュメントの誤字・翻訳改善の指摘

**PRについて:**

- プルリクエストの受け入れは慎重に行います
- PRを送る前に、必ず [GitHub Issues](https://github.com/hiroyuki-miyauchi/axiarch/issues) で提案を議論してください
- 事前のIssueなしのPRは原則マージしません

### Universal Rules と Blueprint の責務分離

| 区分 | パス | 性質 | 貢献ルール |
|:-----|:-----|:-----|:---------|
| **Universal Rules** | `axiarch-rules/{lang}/universal/` | 不変（Immutable） | 「憲法改正」として明示的な承認が必要 |
| **Blueprint** | `axiarch-rules/{lang}/blueprint/` | 可変（Mutable） | テンプレートの改善・追加を歓迎 |
| **Canonical Entrypoint & Adapters** | `AXIARCH.md`, adapter pointers | 準不変 | 正本入口変更として慎重なレビューが必要 |
| **Execution Harness** | `axiarch-harness/{lang}/` | 準不変 | 実行、監査、証跡、承認境界として慎重なレビューが必要 |
| **Infrastructure** | `LOADING_PROTOCOL.md` 等 | 準不変 | 機能改善の提案を歓迎 |
| **Prompt Library** | `axiarch-prompts/` | 可変（Mutable） | プロンプトの改善・追加を歓迎 |

> [!IMPORTANT]
> **Universal Rules は「憲法」です。** 変更提案は歓迎しますが、マージには慎重な議論と明示的な承認が必要です。

### バイリンガル要件

Axiarchの全ドキュメントは日英バイリンガルです。ドキュメントの変更・追加時は：

- `AXIARCH.md` は単一ファイル内の日英併記を維持
- `AGENTS.md` / `CLAUDE.md` / 各ツール固有ファイルは `AXIARCH.md` だけを指す薄いポインターを維持
- `axiarch-harness/ja/` と `axiarch-harness/en/` の両方を更新
- `ja/universal/` と `en/universal/` の両方を更新
- `ja/blueprint/` と `en/blueprint/` の両方を更新
- `axiarch-prompts/` を導入している場合は、`ja/` と `en/` の対応するフォルダ（`develop/`, `audit/`, `govern/`, `operate/`）の両方を更新（任意導入の場合のみ）
- 片方の言語だけの変更は受け付けません

### 🚨 Axiarch 本体（OSS template）運用ルール — Maintainer Guide

> [!CAUTION]
> **Axiarch 本体は採用先プロジェクトに配布される template です。** 採用先用の baseline と、axiarch 開発者側で蓄積される情報を厳格に区別する必要があります。本セクションは axiarch 本体の maintainer 向けガイドです。

#### Lesson の蓄積場所（重要）

| 種類 | 蓄積場所 | 例 |
|:--|:--|:--|
| **採用先で蓄積する Lesson**（採用先プロジェクト固有の知見） | `axiarch-rules/{lang}/blueprint/core/010_project_lessons_log.md` | DB スキーマ設計の失敗例、特定インシデント対応 等 |
| **axiarch 開発側で蓄積する Lesson**（本体改善で得た知見） | `CHANGELOG.md` の Diagnostic Outcome / Design retrospective セクション、`ROADMAP.md` の対応バージョンセクション、commit body | hook format 変更時の運用、release 設計の反省 等 |

**🚫 axiarch 本体の `core/010_project_lessons_log.md` には、`[Initial]` entry 以外を追加しないこと。** 本ファイルは採用先プロジェクトが自身の知見を蓄積する **template/baseline** であり、axiarch 開発側の lesson を蓄積すると採用先に noise が配布される。

過去事例（v1.5.4 中間 commit）: 開発側で得た「hook format 変更時の運用ルール」を `core/010` に結晶化追加した結果、採用先 noise になる問題が発生。v1.5.5 で revert し、本ガイドを明文化した。

#### 採用先で削除推奨されるファイル（README の必須ファイル表参照）

- `CHANGELOG.md` / `CONTRIBUTING.md` / `SECURITY.md` / `CODE_OF_CONDUCT.md` / `LICENSE` / `NOTICE`
- これらは axiarch 本体の repository 管理用であり、採用先では不要。

#### 採用先で書き換えられる template（axiarch 本体では placeholder 形式を保つ）

- `AXIARCH.md` の Project Native Language 設定行
- `axiarch-rules/{lang}/blueprint/core/000_project_overview.md` の sample 値
- `axiarch-rules/{lang}/blueprint/core/998_feature_spec_template.md` / `999_project_specific_template.md`

axiarch 本体では実値ではなく **template 形式** を維持する。`init.sh` が採用先で動的に書き換える設計。

---

## 🇺🇸 English

Thank you for your interest in Axiarch.

### Contribution Policy

Axiarch is currently maintained as a personal project. Contributions are accepted under the following policy.

**Welcome:**

- Bug reports and rule flaw identification ([GitHub Issues](https://github.com/hiroyuki-miyauchi/axiarch/issues))
- New Universal Rule proposals
- Improvements to existing rules
- Typo fixes and translation improvements

**Regarding Pull Requests:**

- Pull requests are accepted with careful review
- Before submitting a PR, please discuss your proposal via [GitHub Issues](https://github.com/hiroyuki-miyauchi/axiarch/issues)
- PRs without a prior Issue will generally not be merged

### Universal Rules vs Blueprint Separation of Concerns

| Category | Path | Nature | Contribution Rules |
|:---------|:-----|:-------|:------------------|
| **Universal Rules** | `axiarch-rules/{lang}/universal/` | Immutable | Requires explicit "Amend Constitution" approval |
| **Blueprint** | `axiarch-rules/{lang}/blueprint/` | Mutable | Template improvements and additions welcome |
| **Canonical Entrypoint & Adapters** | `AXIARCH.md`, adapter pointers | Semi-immutable | Requires careful review as canonical-entrypoint change |
| **Execution Harness** | `axiarch-harness/{lang}/` | Semi-immutable | Requires careful review as execution, audit, evidence, and approval boundary |
| **Infrastructure** | `LOADING_PROTOCOL.md` etc. | Semi-immutable | Feature improvement proposals welcome |
| **Prompt Library** | `axiarch-prompts/` | Mutable | Prompt improvements and additions welcome |

> [!IMPORTANT]
> **Universal Rules are the "Constitution."** Change proposals are welcome, but merging requires careful discussion and explicit approval.

### Bilingual Requirement

All Axiarch documentation is bilingual (JA/EN). When modifying or adding documentation:

- Keep the bilingual structure inside the single `AXIARCH.md` file
- Keep `AGENTS.md`, `CLAUDE.md`, and tool-native files as thin pointers that only point to `AXIARCH.md`
- Update both `axiarch-harness/ja/` and `axiarch-harness/en/`
- Update both `ja/universal/` and `en/universal/`
- Update both `ja/blueprint/` and `en/blueprint/`
- If you have installed `axiarch-prompts/` (optional), update both `ja/` and `en/` in the corresponding subfolders (`develop/`, `audit/`, `govern/`, `operate/`)
- Changes in only one language will not be accepted

### 🚨 Axiarch Core (OSS Template) Operational Rules — Maintainer Guide

> [!CAUTION]
> **Axiarch core is a template distributed to adopting projects.** Strictly separate the adopter-side baseline from information accumulated by axiarch maintainers. This section is a guide for axiarch maintainers.

#### Lesson Accumulation Location (Critical)

| Type | Storage location | Examples |
|:--|:--|:--|
| **Adopter-side lessons** (project-specific insights) | `axiarch-rules/{lang}/blueprint/core/010_project_lessons_log.md` | DB schema design failures, specific incident handling, etc. |
| **Axiarch maintainer-side lessons** (knowledge from improving the core) | `CHANGELOG.md` Diagnostic Outcome / Design retrospective sections, `ROADMAP.md` corresponding-version section, commit body | Hook format change operations, release design retrospectives, etc. |

**🚫 Do NOT add anything other than the `[Initial]` entry to `core/010_project_lessons_log.md` in axiarch core.** This file is a template/baseline for adopting projects to accumulate their own insights; storing axiarch maintainer-side lessons here ships noise to adopters.

Past incident (v1.5.4 interim commit): A maintainer-side lesson on "hook format change operations" was crystallised into `core/010`, becoming adopter noise. v1.5.5 reverted this and documented the policy here.

#### Files recommended for deletion in adopter projects (see Required Files table in README)

- `CHANGELOG.md` / `CONTRIBUTING.md` / `SECURITY.md` / `CODE_OF_CONDUCT.md` / `LICENSE` / `NOTICE`
- These are axiarch core repository management files and not needed in adopter projects.

#### Templates rewritten in adopter projects (keep placeholder form in axiarch core)

- Project Native Language setting line in `AXIARCH.md`
- Sample values in `axiarch-rules/{lang}/blueprint/core/000_project_overview.md`
- `axiarch-rules/{lang}/blueprint/core/998_feature_spec_template.md` / `999_project_specific_template.md`

In axiarch core, maintain **template form** rather than concrete values. `init.sh` rewrites these dynamically in adopter projects.
