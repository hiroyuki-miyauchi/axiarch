# HUMAN_APPROVAL_GATE.md — 人間承認ゲート

## 目的

人間承認ゲートは、AIが自律的に進めてはいけない操作を止めるための境界である。
作業実施の承認と、公開・破壊・費用発生・データ変更の承認は別物として扱う。

## 明示承認が必要な操作

- `git add` などのstage操作
- `git commit`
- `git push`
- release作成、tag作成、package公開
- deploy、production反映、外部サービス設定変更
- DB migrationの適用、production data変更、手動SQL
- ファイル削除、大規模移動、既存ファイルの全面書き換え
- 課金、料金、外部API利用量を増やす変更
- 認証、認可、個人情報、セキュリティ境界の変更
- Class S / Universal Rule の変更
- 主要Blueprintの変更、またはプロジェクト判断を伴うBlueprint反映
- 法務、ライセンス、契約、採用、市場公開情報に関わる判断
- `--apply --yes` のような非対話一括適用

## 明示承認が不要な読み取り専用操作

以下は、それ自体では Human Approval Gate の停止対象ではない。
ただし、上記の承認対象操作を伴う場合は、その時点で停止する。

- repository / working tree / 提供済み文脈の読み取り専用調査
- 読み取り専用の role pass、audit、review、verification
- ユーザーが要求した読み取り専用 security scan の実行
- 範囲を限定した読み取り専用サブエージェント委任
- テスト結果、ログ、diff、ドキュメント整合の要約

サブエージェントや scan tool を使うという理由だけで、追加の人間承認を求めて停止してはならない。
停止が必要なのは、file write、stage、commit、push、deploy、DB apply、production data変更、外部サービス設定変更、課金増、機微データ取得など、承認対象操作へ移る場合である。

## 承認の取り方

承認依頼は、1回につき1つの判断に絞る。
承認依頼、理由、残リスクはユーザーが判断できる言語で書く。
Project Native Language の利用者には、既定でその言語で確認する。

```text
次の操作は人間承認が必要です。
操作: git commit
対象: 現在のブランチ
理由: 検証済み差分からローカルcommitを作成するため
承認されるまで実行しません。
```

## 禁止

- 「実装してよい」を「stage、commit、push、releaseしてよい」と解釈する
- 「検証してよい」を「deployしてよい」と解釈する
- 曖昧な承認で破壊的操作を進める
- 承認対象をEvidence Packetから省略する
