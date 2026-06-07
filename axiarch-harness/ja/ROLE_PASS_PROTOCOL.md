# ROLE_PASS_PROTOCOL.md — 役割パス

## 目的

役割パスは、1人のメインエージェントでも複数視点の確認を順番に行えるようにするための手順である。
サブエージェントが使える場合は一部を委任してよいが、使えない場合でもメインエージェントが同じ順序で実行する。

## 標準パス

| Pass | 観点 | 成果物 |
|:--|:--|:--|
| Planner | 正本計画、スコープ、既存価値、リスク | `implementation_plan.md` とネイティブ計画 |
| Implementer | 最小差分、既存互換、構造整合 | コードまたは文書差分 |
| Verifier | 実行コマンド、リンク、構文、health、再現性 | 検証結果 |
| Auditor | 正本計画との差分、退行、過剰変更、承認境界 | 指摘またはVerdict |
| Blueprint Drift | Universal / Blueprint / 正本計画 / 実装差分のずれ | drift指摘またはPASS |
| QA | コマンド検証、リンク、構文、health | 検証結果 |
| Docs | README、CHANGELOG、ROADMAP、証跡 | 公開導線と現在タスク文書 |
| Crystallizer | 実タスクで得た教訓、重複、閾値、昇華要否 | 結晶化候補または不要判断 |
| Release Safety | stage、commit、push、deploy、release、tag、DB、破壊的操作の有無 | Human Approval Gate判定 |

## メインエージェント実行

サブエージェントがない場合、メインエージェントは上記パスを順番に実行する。
「サブエージェントがないため未実施」とは扱わない。
Audit Pass中は原則read-onlyとし、修正が必要な場合はFix Passとして明示的に戻る。
計画が間違っている場合はImplementerではなくPlannerへ戻る。

## サブエージェント利用時

サブエージェントに任せられるのは、調査、読み取り専用監査、テスト結果整理、文書整合確認などの bounded work に限る。
最終判断、正本計画からの逸脱承認、人間承認が必要な操作はメインエージェントが保持する。
