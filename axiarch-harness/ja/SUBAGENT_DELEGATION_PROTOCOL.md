# SUBAGENT_DELEGATION_PROTOCOL.md — サブエージェント委任

## 目的

サブエージェントは任意の実行補助である。
Axiarchはサブエージェントの存在を前提にしない。
サブエージェントがない環境では、メインエージェントが同じ作業を順番にこなす。

## 委任できる作業

- 読み取り専用のコード調査
- ドキュメント整合確認
- ja/en parity確認
- テスト結果やログの要約
- 変更案のリスク列挙
- 監査観点ごとの独立レビュー

## 任意ロール例

- Architecture Guardian
- Security Reviewer
- Quality Auditor
- Blueprint Auditor
- Crystallization Scribe
- Docs Curator
- Release Warden

## 委任してはいけない作業

- 最終判断
- 人間承認が必要な操作
- stage、commit、push、deploy、release、tag
- DB適用、production data変更
- Universal Ruleや `AXIARCH.md` の正本改変判断
- 正本計画からの逸脱判断

## メインエージェントの責務

1. 委任範囲を具体的に限定する。
2. サブエージェント結果をそのまま採用せず、必ず統合レビューする。
3. 矛盾があれば正本計画、`AXIARCH.md`、Universal、Blueprintの順に照合する。
4. 最終Evidence Packetはメインエージェントが作成する。

## フォールバック

サブエージェントが使えない場合:

1. Planner pass
2. Implementer pass
3. Reviewer pass
4. QA pass
5. Docs pass
6. Release Safety pass

この順序でメインエージェントが実行する。
