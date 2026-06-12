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
- 読み取り専用のセキュリティ調査、脅威モデル、候補発見、証跡整理

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

## 承認境界

読み取り専用のサブエージェント委任は、サブエージェントを使うという理由だけでは人間承認ゲート対象にならない。
次の条件をすべて満たす場合、メインエージェントは追加の「サブエージェント明示許可」を待たずに委任してよい。

1. ユーザー要求が調査、監査、レビュー、検証、security scan などの読み取り専用作業を求めている。
2. 委任範囲が現在の repository / working tree / 提供済み文脈に閉じている。
3. subagent が file write、stage、commit、push、deploy、tag、DB apply、本番データ変更、外部サービス設定変更を行わない。
4. 未承認の認証、install、課金増、機微データ取得、production access を伴わない。
5. メインエージェントが結果を統合し、最終判断、残リスク受容、Evidence Packet を保持する。

上記を満たさない場合だけ、Human Approval Gate へ戻る。

## Codex Security Deep Security Scan

Codex Security Deep Security Scan または同等の名前付き workflow がユーザーから明示された場合、その明示呼び出しは、当該 workflow が必要とする読み取り専用 worker fanout への要求を含むものとして扱う。
「正式な Deep Security Scan はサブエージェント明示許可が必要」と解釈して停止してはならない。

ただし、委任機能そのものが runtime に存在しない場合、Deep Security Scan を実行済みと主張してはならない。
その場合は、制約を明記し、通常の Codex Security scan、またはメインエージェントの順次 role pass による読み取り専用 fallback を選ぶ。

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
「サブエージェントが使えない」こと自体を作業未実施や停止理由にせず、名前付き workflow の要件を満たせない場合だけ、その名称での実行不能を正直に報告する。
