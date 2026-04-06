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
| **Universal Rules** | `axiarch-rules/universal/` | 不変（Immutable） | 「憲法改正」として明示的な承認が必要 |
| **Blueprint** | `axiarch-rules/blueprint/` | 可変（Mutable） | テンプレートの改善・追加を歓迎 |
| **Infrastructure** | `LOADING_PROTOCOL.md` 等 | 準不変 | 機能改善の提案を歓迎 |
| **Prompt Library** | `axiarch-prompts/` | 可変（Mutable） | プロンプトの改善・追加を歓迎 |

> [!IMPORTANT]
> **Universal Rules は「憲法」です。** 変更提案は歓迎しますが、マージには慎重な議論と明示的な承認が必要です。

### バイリンガル要件

Axiarchの全ドキュメントは日英バイリンガルです。ドキュメントの変更・追加時は：

- `universal/ja/` と `universal/en/` の両方を更新
- `blueprint/ja/` と `blueprint/en/` の両方を更新
- `axiarch-prompts/` を導入している場合は、`ja/` と `en/` の対応するフォルダ（`develop/`, `audit/`, `govern/`, `operate/`）の両方を更新（任意導入の場合のみ）
- 片方の言語だけの変更は受け付けません

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
| **Universal Rules** | `axiarch-rules/universal/` | Immutable | Requires explicit "Amend Constitution" approval |
| **Blueprint** | `axiarch-rules/blueprint/` | Mutable | Template improvements and additions welcome |
| **Infrastructure** | `LOADING_PROTOCOL.md` etc. | Semi-immutable | Feature improvement proposals welcome |
| **Prompt Library** | `axiarch-prompts/` | Mutable | Prompt improvements and additions welcome |

> [!IMPORTANT]
> **Universal Rules are the "Constitution."** Change proposals are welcome, but merging requires careful discussion and explicit approval.

### Bilingual Requirement

All Axiarch documentation is bilingual (JA/EN). When modifying or adding documentation:

- Update both `universal/ja/` and `universal/en/`
- Update both `blueprint/ja/` and `blueprint/en/`
- If you have installed `axiarch-prompts/` (optional), update both `ja/` and `en/` in the corresponding subfolders (`develop/`, `audit/`, `govern/`, `operate/`)
- Changes in only one language will not be accepted
