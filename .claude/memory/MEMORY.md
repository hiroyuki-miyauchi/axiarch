# Axiarch Memory Persistence Template

このファイルは Claude Code 採用時の任意テンプレートです。Axiarch の正式な仕様、憲法、プロジェクト固有ルールは `AGENTS.md` と `axiarch-rules/` を正とします。Memory はそれらを置き換えず、同じ失敗や判断漏れを繰り返しにくくするための短い補助記録として扱います。

This file is an optional template for Claude Code adopters. `AGENTS.md` and `axiarch-rules/` remain the source of truth for Axiarch protocols and project rules. Memory does not replace them; it only stores short operational notes that reduce repeated mistakes or repeated decision gaps.

## 記録してよいもの / Allowed Entries

- 実際に起きた再発しやすいミス
- 実際に採用した運用判断
- プロジェクト固有の確認手順
- ユーザーが明示した長期的な好みや制約
- 既存ルールでは拾いにくかった注意点

## 記録しないもの / Do Not Store

- 秘密情報、APIキー、パスワード、個人情報
- 会話ログ全文や長い引用
- 推測だけのベストプラクティス
- その場限りの一時的な作業メモ
- `AGENTS.md` や `axiarch-rules/` と矛盾する指示

## 優先順位 / Priority

1. `AGENTS.md`
2. `axiarch-rules/{lang}/universal/`
3. `axiarch-rules/{lang}/blueprint/`
4. `axiarch-prompts/` when installed and explicitly used
5. `.claude/memory/MEMORY.md`

Memory が上位ルールと矛盾する場合は、上位ルールを優先し、Memory側を更新または削除します。

## Entry Format

```md
### YYYY-MM-DD — short title

- Domain: governance / engineering / quality / security / product / operations / other
- Trigger: What actually happened
- Rule: What should be remembered next time
- Scope: When this applies
- Source: task.md / walkthrough.md / commit / issue / user instruction
```

## Current Memory

このテンプレート配布時点では、採用先プロジェクト固有のMemoryはありません。実際に起きた問題やユーザーから明示された長期制約だけを追加してください。

No adopter-specific memory is included in this template. Add only facts that actually happened or long-term constraints explicitly provided by the user.
