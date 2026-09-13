# Axiarch Memory Persistence Template

このファイルは Claude Code 採用時の任意テンプレートです。Axiarch の正式な入口正本は `AXIARCH.md` です。Memory は `AXIARCH.md` を置き換えず、同じ失敗や判断漏れを繰り返しにくくするための短い補助記録として扱います。

This file is an optional template for Claude Code adopters. `AXIARCH.md` is the canonical Axiarch entrypoint. Memory does not replace `AXIARCH.md`; it only stores short operational notes that reduce repeated mistakes or repeated decision gaps.

この配布パスはClaude Codeのauto memoryの自動読込先ではありません。配置だけで読込・同期されたとは扱わず、利用する場合はプロジェクトの運用で参照先を明示します。個人のmemory設定や製品の保存先は変更しません。

This distributed path is not Claude Code's automatically loaded auto-memory location. Placement does not establish loading or synchronization; explicitly reference it in project procedures if adopted. It does not change personal memory settings or the product's storage location.

## 記録してよいもの / Allowed Entries

- 実際に起きた再発しやすいミス / Recurring mistakes that actually occurred
- 実際に採用した運用判断 / Operational decisions actually adopted
- プロジェクト固有の確認手順 / Project-specific verification procedures
- ユーザーが明示した長期的な好みや制約 / Long-term preferences or constraints explicitly provided by the user
- 既存ルールでは拾いにくかった注意点 / Observed caveats not adequately covered by existing rules

## 記録しないもの / Do Not Store

- 秘密情報、APIキー、パスワード、個人情報 / Secrets, API keys, passwords or personal data
- 会話ログ全文や長い引用 / Complete conversation logs or long quotations
- 推測だけのベストプラクティス / Speculative best practices
- その場限りの一時的な作業メモ / Transient task notes
- `AXIARCH.md` と矛盾する指示 / Instructions conflicting with `AXIARCH.md`

## 正本境界 / Canonical Boundary

`AXIARCH.md` が常にAxiarchの正本です。
このMemoryには、実際に起きた再発リスク低減のための短い事実だけを記録します。
プロトコル、ロード順、承認境界、実行手順はこのファイルに複製せず、必ず `AXIARCH.md` を参照してください。

`AXIARCH.md` always remains the canonical Axiarch source.
Use this Memory only for short facts that reduce repeated operational mistakes.
Do not duplicate protocols, loading order, approval boundaries, or execution steps here; always refer to `AXIARCH.md`.

Memory が `AXIARCH.md` と矛盾する場合は、`AXIARCH.md` を優先し、Memory側を更新または削除します。
If Memory conflicts with `AXIARCH.md`, follow `AXIARCH.md` and update or delete the Memory entry.

## 記録形式 / Entry Format

```md
### YYYY-MM-DD — short title

- Domain: governance / engineering / quality / security / product / operations / other
- Trigger: What actually happened
- Rule: What should be remembered next time
- Scope: When this applies
- Source: .axiarch/sessions/{session_id}/task.md or .axiarch/sessions/{session_id}/walkthrough.md; commit / issue / user instruction
```

## 現在の記録 / Current Memory

このテンプレート配布時点では、採用先プロジェクト固有のMemoryはありません。実際に起きた問題やユーザーから明示された長期制約だけを追加してください。

No adopter-specific memory is included in this template. Add only facts that actually happened or long-term constraints explicitly provided by the user.
