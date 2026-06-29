# Axiarch Market Strategy

調査日: 2026-05-15
更新日: 2026-06-12

この文書は Axiarch 本体の価値最大化と市場戦略を管理するための文書です。採用先プロジェクトへコピーされる `axiarch-rules/{lang}/blueprint/` には配置しません。Blueprint は採用先プロジェクトの固有仕様と教訓を蓄積する領域であり、Axiarch 本体の市場戦略を混入させると 3層ガバナンスの責務分離に反します。

## 結論

Axiarch の主戦場は、Google Antigravity、OpenAI Codex、Claude Code の3系統に集中する。
主対象の Google Antigravity・OpenAI Codex・Claude Code は、いずれも実運用（ドッグフーディング）で稼働を確認済みとする。Antigravity を最初の実証対象とし、Codex・Claude Code も本リポジトリ自体の開発を含む実運用で継続使用している。ただし、全環境での動作保証まではしない。

Cursor、GitHub Copilot、Windsurf は、未検証の拡張ポインター候補として扱う。検証済みまたは主対象のように見える表現は避け、ポインター設定と Markdown 互換性に基づく補助対象として位置づける。動作保証はしない。

## 市場認識

AI支援開発は、単発プロンプトの品質競争から、リポジトリに常駐する指示、セッション横断の記憶、ツール実行前後の hook、ブラウザやターミナルを含む自律検証へ移行している。

Axiarch が注力すべき市場は「より賢いプロンプト」ではなく、「AIエージェントがプロジェクトを壊すリスクを下げるためのガバナンス層」である。特に以下の課題が強いチームほど導入価値が高い。

- AIがルールを読まずに作業を始める
- セッションをまたぐと仕様や教訓が消える
- 操縦者のスキル差で品質が大きくぶれる
- 仕様なしでコードが増え、レビュー不能になる
- 全文上書き、勝手な push、手動DB変更などの破壊的操作リスクを下げたい
- 日本語プロジェクトで英語混入やニュアンスずれを抑えたい

## 2026-06-12 市場調査アップデート

2026-06-12時点の一次情報・公式ドキュメント・研究動向を再確認した結果、Axiarch の価値は「特定エージェント向けの設定集」ではなく、agent指示ファイル、hooks、skills、subagents、spec-driven development、agentic securityをまたぐ横断ガバナンスとして説明するのが最も実態に合う。

確認した市場シグナルは以下。

- AGENTS.md は、複数 coding agent が読むオープンな指示ファイル形式として採用が広がっている。Axiarch は AGENTS.md を置き換えるのではなく、共通入口・薄い adapter として扱い、AXIARCH.md とルール体系へ誘導する。
- OpenAI Codex は作業前に AGENTS.md を読む前提を公式に持ち、nested AGENTS.md によるスコープ差分も扱う。Axiarch はこの考え方を、Universal / Blueprint / optional Prompts の責務分離とロード証跡で補う。
- Claude Code は hooks、skills、subagents を公式機能として持つ。Axiarch の Execution Harness は、これらの機能を必須前提にせず、使える場合だけ補強する任意実行層として位置づける。
- GitHub Copilot / VS Code は repository instructions、path-specific instructions、custom agents、skills、prompt files を持つ。Axiarch は Copilot を検証済み主対象とは言わず、pointer-only 互換候補として扱う。
- Kiro と GitHub Spec Kit は requirements / design / tasks、constitution / spec / plan / tasks のような spec-driven development を前面に出している。Axiarch は spec-driven development そのものではなく、その上位で「正本・証跡・承認境界・教訓昇華」を維持する。
- MCP と OWASP の agentic security 動向は、authorization、least privilege、tool boundary、人間承認、PII/secret保護を agent基盤の前提にしている。Axiarch は Human Approval Gate、read-only delegation boundary、security/FinOps/privacyの責務を明確にすることで、この流れに接続する。
- 2026年の agentic coding tool configuration 研究では、Context Files が広く使われ、AGENTS.md が相互運用標準として浮上する一方、Skills / Subagents はまだ浅い採用段階とされる。Axiarch は低摩擦なMarkdown正本を維持しつつ、Skills / Subagents を任意の補助導線として扱う方針が妥当。

## 公式情報から見た主対象3系統

| 対象 | 市場上の意味 | Axiarch の接続点 | 戦略上の扱い |
|:-----|:-------------|:-----------------|:-------------|
| Google Antigravity | editor、terminal、browser に直接アクセスする agent-first IDE として、長い自律タスクの需要が強い | `.agents/rules/prompt_pointer.md`、Axiarchのルールロード、実運用知見 | 実運用（ドッグフーディング）で稼働確認済みの主対象（最初の実証対象）。agent-first時代の品質床として訴求する |
| OpenAI Codex | `AGENTS.md` をプロジェクト指示として扱い、hook も公式に持つエージェント環境 | `AGENTS.md`、`.codex/hooks.json`、Axiarch診断、作業文書3点セット、`update_plan` | 実運用（ドッグフーディング）で稼働確認済みの主対象。ただし全環境での動作保証はしない |
| Claude Code | `CLAUDE.md`、memory、hooks、skills、subagents により、継続的な指示、支援ファイル、専門コンテキスト、実行前後の制御を組み合わせられる環境 | `CLAUDE.md`、`.claude/settings.json`、UserPromptSubmit、PreToolUse、SessionStart、Task tools、optional skills/subagents | 実運用（ドッグフーディング）で稼働確認済みの主対象。ただし全環境での動作保証はしない |

## 拡張互換の扱い

| 対象 | 扱い | 表現ルール |
|:-----|:-----|:-----------|
| Cursor | 拡張ポインター候補 | `.cursor/rules/axiarch.mdc` によるポインター設定。未検証で動作保証しない |
| GitHub Copilot | 拡張ポインター候補 | `.github/copilot-instructions.md` による補助設定。未検証で動作保証しない |
| Windsurf | 拡張ポインター候補 | `.windsurfrules` による補助設定。未検証で動作保証しない |

拡張互換は「使える可能性がある」ではなく、「Axiarch の Markdown ルールを接続する入口を用意している」と説明する。ここを誇張すると、Axiarch の信頼性を損なう。

## ポジショニング

Axiarch は、AI coding agent のための Constitution-Driven Governance Layer である。

市場にある多くの選択肢は、エージェント本体、IDE、チャット体験、補完体験、またはプロンプトテンプレートである。Axiarch はそれらと競合するより、上に載る横断ガバナンス層として価値を出す。

一言で言うなら、Axiarch は「AIに何を作らせるか」ではなく「AIがどう振る舞うべきか」をリポジトリに固定する仕組みである。

## 差別化軸

| 軸 | Axiarch の価値 |
|:---|:---------------|
| 3層ガバナンス | Universal、Blueprint、Prompts を分け、普遍原則とプロジェクト固有知を混ぜない |
| Blueprint First | コードより先に仕様を持たせ、vibe coding の暴走を抑える |
| 作業文書3点セット | `task.md`、`implementation_plan.md`、`walkthrough.md` により、作業の意図、判断、確認を残す |
| 結晶化プロトコル | 失敗や判断を一回限りの会話で終わらせず、再利用可能なルールへ変える |
| hook による物理制御 | Claude Code と Codex では、読み忘れや全文上書きなどを hook 層で検出しやすくし、一部の危険操作をブロックしやすくする |
| エージェント横断 | エージェントを乗り換えても、リポジトリ内の憲法とルールは残る |
| 日本語実務適性 | 日本語プロジェクトで、英語混入や曖昧な指示を抑える運用規律を持つ |
| 診断可能性 | `check-axiarch-health.sh` により、遵守状態を人間の感覚ではなくコマンドで確認できる |
| 標準との相互運用 | AGENTS.md、repository instructions、skills、prompt files などの入口を置き換えず、Axiarch正本へつなぐ |
| Spec-driven governance | Kiro / Spec Kit 型の仕様駆動開発を補完し、実装前後の証跡、承認境界、教訓昇華を保つ |
| Agentic security alignment | MCP authorization、least privilege、OWASP agentic risk などを背景に、read-only delegation と高リスク操作承認を分ける |

## 顧客セグメント

| 優先度 | 対象 | 強い訴求 |
|:------|:-----|:---------|
| 1 | AIで開発速度を上げたい個人開発者、創業者 | AI任せでも最低品質を落としにくい |
| 1 | 小規模プロダクトチーム | 操縦者ごとの品質差、レビュー負荷、仕様消失を抑える |
| 1 | 日本語中心の開発組織 | 日本語ルール、ドキュメント、判断基準を維持できる |
| 2 | 受託、開発支援、AI導入支援チーム | 顧客ごとに品質ルールを再現できる |
| 2 | セキュリティ、DB、法務リスクがあるスタートアップ | 手動DB変更、push、上書き、セキュリティ軽視を抑止する |
| 3 | 大企業のAI開発PoC | エージェント導入時のガバナンス雛形として使える |

## 戦略優先順位

1. Google Antigravity、Codex、Claude Code の主対象3系統を README、ROADMAP、llms 系文書で一貫させる。
2. 実運用（ドッグフーディング）で稼働確認済みの主対象として扱うのは Google Antigravity・OpenAI Codex・Claude Code の3つとする。ただし、全プロジェクト環境での動作保証とは表現しない。
3. Codex は「主対象、ネイティブ統合対応、release gate検証対象、`update_plan` 連携対象」として扱う。実運用（ドッグフーディング）で稼働確認済みだが、全環境での動作保証済みとは表現しない。
4. Claude Code は「主対象、hook補強モデルとTask tools連携対象」として扱う。実運用（ドッグフーディング）で稼働確認済みだが、全環境での動作保証済みとは表現しない。
5. Cursor、GitHub Copilot、Windsurf は「拡張ポインター候補」とし、過度に前面へ出さない。
6. Compatibility Matrix では、検証済みの意味を「実運用稼働確認済み」と「全環境での動作保証ではない」に分け、検証日、検証項目、検証範囲を記録する。
7. `axiarch-rules/{lang}/blueprint/` に Axiarch 本体の市場戦略を入れない責務分離を維持する。

## 30日アクション

- README の互換性表を、主対象と拡張互換に分ける。
- ROADMAP に主対象3系統への集中方針を追記する。
- llms.txt と llms-full.txt を README と同じ市場表現へ同期する。
- Antigravity・Codex・Claude Code の表現を「Production-validated primary / real operational use (dogfooding) / no operation guarantee for every environment」に統一する。
- Cursor、GitHub Copilot、Windsurf の表現を「Extended pointer-only candidate / no operation guarantee」に統一する。
- docs と script 表示で、Antigravity・Codex・Claude Code を実運用（ドッグフーディング）で稼働確認済みのステータスにそろえる（全環境保証はしない境界も併記）。
- ROADMAP と MARKET_STRATEGY の市場調査節は、一次情報で確認できた範囲と推測を分け、過度な「防止」「唯一」「実現」表現を避ける。

## 60日アクション

- 3主対象それぞれの検証範囲、確認済み操作、対象バージョン、未保証範囲をCompatibility Matrixに記録する。
- Claude Code と Codex の hook 差分表を追加し、どの制御がどちらで有効かを明確にする。
- Antigravity の起動、ルールロード、ブラウザ検証導線を短いセットアップ例にまとめる。
- `check-axiarch-health.sh` に、主対象3系統の設定検出結果をさらに読みやすく出す改善を検討する。
- Claude Code Skills / subagents と Codex / Copilot 系 custom instruction の互換方針を、optional adapter としてCompatibility Matrixに分離する。

## 90日アクション

- Compatibility Matrix を機械可読な形式で追加する。
- 主対象3系統ごとの最小サンプルリポジトリ、または導入済みサンプル手順を整備する。
- GitHub Actions 上で Markdown、リンク、hook JSON、shell 構文、配布物整合性を継続検証する。
- 市場説明を「エージェント別セットアップ」から「AI開発ガバナンスの品質床」へ寄せる。
- 公開市場調査の更新日、参照URL、検証範囲、未検証範囲を1箇所で追跡する。

## リスクと抑止策

| リスク | 影響 | 抑止策 |
|:-------|:-----|:-------|
| 互換性の過大表現 | 信頼低下 | Verified、Primary target、Extended pointer-only、Unverified を明確に分ける |
| Blueprint 汚染 | Axiarch の概念違反 | 本体市場戦略はルート文書に置き、採用先 Blueprint へ入れない |
| ルール量の多さ | 導入負荷 | LOADING_PROTOCOL と診断ツールで必要なものだけ読む運用を強調する |
| hook 依存の差 | エージェント間で体験差が出る | hook 有無と制御範囲を正直に説明する |
| プラットフォーム仕様変更 | 設定が古くなる | 公式ドキュメントに基づく定期的な compatibility review を行う |
| 日本語特化に見えすぎる | 海外採用の阻害 | JA/EN 対称構造と英語 README/llms を維持する |

## 成功指標

- README、ROADMAP、llms 系文書で主対象3系統の表現が一致している。
- Google Antigravity・Codex・Claude Code が、いずれも実運用（ドッグフーディング）で稼働確認済みの主対象として説明されている（全環境保証はしない境界つき）。
- Codex と Claude Code が「期待互換」ではなく、主対象として説明されている。
- Cursor、GitHub Copilot、Windsurf が検証済みまたは動作保証済みのように見えない。
- `init.sh` の選択肢と README の互換性表に矛盾がない。
- 健全性診断が PASS し、Markdown の差分チェックに失敗しない。
- 将来の Compatibility Matrix で、検証日と検証範囲を追跡できる。

## 参照した公式情報

- [AGENTS.md: Open format for coding agents](https://agents.md/)
- [OpenAI Codex: Custom instructions with AGENTS.md](https://developers.openai.com/codex/guides/agents-md)
- [OpenAI Codex: Customization](https://developers.openai.com/codex/concepts/customization)
- [OpenAI Codex: Hooks](https://developers.openai.com/codex/hooks)
- [Claude Code: Hooks](https://code.claude.com/docs/en/hooks)
- [Claude Code: Memory](https://code.claude.com/docs/en/memory)
- [Claude Code: Skills](https://code.claude.com/docs/en/skills)
- [Claude Code: Subagents](https://code.claude.com/docs/en/sub-agents)
- [GitHub Copilot: Repository custom instructions](https://docs.github.com/en/copilot/how-tos/configure-custom-instructions/add-repository-instructions)
- [VS Code: Customize AI responses](https://code.visualstudio.com/docs/copilot/customization/overview)
- [Kiro: Specs](https://kiro.dev/docs/specs/)
- [GitHub Spec Kit](https://github.com/github/spec-kit)
- [Model Context Protocol: Authorization specification](https://modelcontextprotocol.io/specification/latest/basic/authorization)
- [OWASP Top 10 for LLM Applications](https://owasp.org/www-project-top-10-for-large-language-model-applications/)
- [arXiv: Configuring Agentic AI Coding Tools](https://arxiv.org/abs/2602.14690)
- [Google: Gemini 3 and Google Antigravity](https://blog.google/products-and-platforms/products/gemini/gemini-3/)
- [Google Antigravity](https://antigravity.google/)

補助情報として、Google Antigravity の公開プレビューや agent-first IDE としての報道も確認した。ただし、Axiarchの「実運用稼働確認済み」表現は、外部報道ではなく本プロジェクトでの実務確認に基づいて扱う。
