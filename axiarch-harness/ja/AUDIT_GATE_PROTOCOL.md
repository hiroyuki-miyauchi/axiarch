# AUDIT_GATE_PROTOCOL.md — 監査ゲート

## 目的

Audit Gateは、実装後またはレビュー後に「このまま進めてよいか」を判定するための関門である。
監査は原則読み取り専用であり、ユーザーが実装修正を依頼した場合だけ修正ループへ進む。

## Verdict

| Verdict | 意味 | 次の行動 |
|:--|:--|:--|
| PASS | 要求を満たし、重大な懸念がない | Evidence Packetへ進む |
| PASS_WITH_NOTES | 進行可能だが軽微な残リスクや補足がある | 残リスクを明記してEvidence Packetへ進む |
| NEEDS_FIX | 実装、品質、検証、互換性のいずれかに修正が必要 | Fix Loopへ戻る |
| NEEDS_REPLAN | 正本計画、スコープ、前提に問題がある | Plan Gateへ戻る |
| NEEDS_HUMAN | 判断または承認が人間所有者に属する | Human Approval Gateで停止する |
| BLOCKED | 外部要因または未解決の遮断要因で進められない | blocker、選択肢、必要な人間判断を示して停止する |
| CRYSTALLIZE_ONLY | 実装変更は不要だが、実タスクで得た教訓の結晶化だけが必要 | CRYSTALLIZATION_PROTOCOLに従い、Evidence Packetへ進む |

互換メモ: 旧 `WARN` は `PASS_WITH_NOTES`、旧 `BLOCK` は `NEEDS_FIX` または `BLOCKED`、旧 `NEEDS HUMAN` は `NEEDS_HUMAN` として扱う。

## チェック観点

- 正本計画と実装差分が一致している
- 既存機能、自律ロード、現在タスク文書、Safe Upgrade導線を壊していない
- ja/enが必要な文書で意味対応している
- ポインターが正本を重複していない
- 新規ファイルが配布、manifest、health、READMEに反映されている
- 検証コマンドが実行され、失敗時は根本原因が確認されている
- 教訓が発生した場合、Crystallization Step 5まで確認されている
- stage、commit、push、deploy、release、tag、DB適用などの承認対象を勝手に実行していない

## 修正ループ

`NEEDS_FIX` が出た場合は、以下の順で戻る。
`BLOCKED` は、遮断要因が承認不要かつ現在スコープ内で解消できる場合だけ同じ手順で切り分ける。それ以外はHuman Approval Gateまたはblocker報告で停止する。

1. 失敗した観点を1行で特定する。
2. 影響範囲を最小化して修正する。
3. 同じ検証を再実行する。
4. `walkthrough.md` に修正後の結果を記録する。
5. それでも解消しない場合は、残リスクと選択肢を示して人間判断へ回す。
