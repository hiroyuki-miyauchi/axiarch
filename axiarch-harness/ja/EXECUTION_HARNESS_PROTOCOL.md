# EXECUTION_HARNESS_PROTOCOL.md — 実行ハーネス

## 目的

この文書は、Axiarchのルールを実務タスクに落とし込む実行手順を定義する。
`AXIARCH.md` と `axiarch-rules/{lang}/LOADING_PROTOCOL.md` を読んだ後、タスクの重さに応じてこの手順を適用する。
この手順は、`AXIARCH.md` で定義するハーネスエンジニアリングをタスク実行へ適用する中核プロトコルであり、第4のルール層ではなく、3層モデルを実行順序、監査、証跡、人間承認へ接続する。

旧文書のハーネスL0–L4はH0–H4の旧称。自律距離D1–D5や成熟度M1–M5とは別の軸で、数値対応はない。

## タスクレベル

| Level | 例 | 必須対応 |
|:--|:--|:--|
| H0 | 質問回答、短い説明、読み取りのみ | 必要な範囲だけ確認し、実装はしない |
| H1 | ドキュメント微修正、ポインター整理、証跡更新 | 計画とwalkthroughを短く更新し、差分を確認 |
| H2 | 小規模コード修正、局所的な仕様更新 | 実装計画、実装、検証、監査ゲート |
| H3 | 複数領域の設計変更、ルール変更、配布スクリプト変更 | Blueprintまたは正本計画、役割パス、ja/en parity、health確認 |
| H4 | DB適用、stage、commit、push、deploy、release、tag、破壊的操作、セキュリティ境界変更 | 実装前後の人間承認ゲート。自律実行禁止 |

`AXIARCH.md` §8 が「ハーネスは非自明な作業における必須手順」と定めるとき、その「非自明」は **H2 以上**を指す。H0/H1（質問回答・読み取り・軽微なドキュメント修正）はハーネス全工程を要さず、H2 以上で実装計画・実装・検証・監査ゲート（および H3/H4 の追加要件）が必須になる。

## 標準ライフサイクル

1. 最新のユーザー指示と正本計画を確認する。
2. 言語とタスクレベルを決める。
3. 必要なルールとharnessを直接開く。
4. `task.md`、`implementation_plan.md`、`walkthrough.md` を現在タスクに同期する。
5. 利用可能な場合、Codexでは `update_plan`、Claude CodeではTask toolsを併用する。利用不能は明記し、同等のセッション記録で進める。
6. 既存機能と正本計画の差分を確認する。
7. 実装は差分ベースで行う。
8. 関連する検証を実行して結果を記録し、その証拠を使って役割パスを実行する。
9. Audit Gateで `PASS` / `PASS_WITH_NOTES` / `NEEDS_FIX` / `NEEDS_REPLAN` / `NEEDS_HUMAN` / `BLOCKED` / `CRYSTALLIZE_ONLY` を判定する。
10. `NEEDS_FIX` は修正ループへ、`NEEDS_REPLAN` はPlan Gateへ戻す。
11. 検証結果をEvidence Packetにまとめる。
12. stage、commit、push、deploy、release、tag、破壊的操作はHuman Approval Gateで停止する。
13. 実際に発生した教訓だけをCrystallization対象として確認する。

## 実装計画の扱い

ユーザーが「添付の実装計画を正本」と明示した場合、その添付計画が作業のSSOTになる。
既存の `implementation_plan.md` は、添付計画を現在タスク用に写像した証跡として更新する。

## 完了条件

- 正本計画に対する実装が完了している
- 変更ファイルと理由が説明できる
- 検証が実行済み、または未実行理由が明記されている
- 残リスクが整理されている
- 人間承認が必要な操作を勝手に実行していない

## ゴールと証拠の接続

`axiarch-rules/ja/universal/core/300_goal_and_current_state.md` を内容の正本とし、[TASK_STATE_PROTOCOL.md](./TASK_STATE_PROTOCOL.md) のID・担当・4状態・確認対象・時刻・証拠を使う。H0/H1は軽量適用。H2以上は準備検査と完了検査を分離し、全条件の証拠を監査する。構造healthの成功だけで完了としない。
