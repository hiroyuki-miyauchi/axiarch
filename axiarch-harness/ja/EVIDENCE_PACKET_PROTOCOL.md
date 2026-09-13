# EVIDENCE_PACKET_PROTOCOL.md — 証跡パケット

## 目的

Evidence Packetは、作業完了時に「何を変え、何を確認し、何が残っているか」を短く再現可能にするための報告単位である。

## 必須項目

| 項目 | 内容 |
|:--|:--|
| Scope | 実施した作業範囲 |
| Canonical Plan | 正本計画または実装判断の根拠 |
| Loaded Rules | 実際に開いたルールファイルと主なセクション |
| Changed Files | 変更ファイルと役割 |
| Verification | 実行した検証コマンドと結果 |
| Audit Verdict | `PASS` / `PASS_WITH_NOTES` / `NEEDS_FIX` / `NEEDS_REPLAN` / `NEEDS_HUMAN` / `BLOCKED` / `CRYSTALLIZE_ONLY` |
| Residual Risks | 残リスク、未検証、既知の注意点 |
| Approval Boundary | stage、commit、push、deploy、release、tag、DB適用など未実行の承認対象 |
| Crystallization | 教訓候補、重複確認、閾値チェック結果 |

## テンプレート

```markdown
## Evidence Packet

- Scope:
- Canonical Plan:
- Loaded Rules:
- Changed Files:
- Verification:
- Audit Verdict:
- Residual Risks:
- Approval Boundary:
- Crystallization:
```

## 注意

Evidence Packetは長文の作業日誌ではない。
ユーザーが次の判断をできるだけの情報を、短く具体的にまとめる。
証跡なき完了報告は禁止する。

## ゴールと証拠の接続

`axiarch-rules/ja/universal/core/300_goal_and_current_state.md` を内容の正本とし、[TASK_STATE_PROTOCOL.md](./TASK_STATE_PROTOCOL.md) のID・担当・4状態・確認対象・時刻・証拠を使う。H0/H1は軽量適用。H2以上は準備検査と完了検査を分離し、全条件の証拠を監査する。構造healthの成功だけで完了としない。
