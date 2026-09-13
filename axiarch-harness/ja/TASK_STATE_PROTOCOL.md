# TASK_STATE_PROTOCOL.md — ゴールと証拠の実行契約

## 適用範囲

内容の正本は `axiarch-rules/ja/universal/core/300_goal_and_current_state.md`。本書は保存形式と検査手順だけを定義する。ハーネスH0の読み取りには記録生成・準備gateを要求しない。H1は短い目的・対象・結果で足りる。H2以上は以下の構造化記録を用いる。同等の外部台帳でもよいが、機械検査にはこの形式へ出力する。

## 保存先と所有者

| 保存先 | 役割 |
|:--|:--|
| `.axiarch/tasks/{task_id}/state.json` | 同じタスクのゴール・現在値の唯一の正本 |
| `.axiarch/tasks/{task_id}/history/{revision}.json` | 更新前の世代。上書きで判断を失わない |
| `.axiarch/sessions/{session_id}/` | セッション固有の `task.md`、`implementation_plan.md`、`walkthrough.md`、binding |
| `--mode status` | `.axiarch/tasks/` を読み、全担当の共通参照一覧を表示。複製した索引は正本にしない |
| ルートの3文書 | 旧導入先の記録を保持。存在しない場合だけ共通参照ポインターを生成 |

セッションIDはCLI、`AXIARCH_SESSION_ID`、`CODEX_THREAD_ID`、hookの `session_id` / `sessionId` を使用できる。タスクIDはCLIまたは `AXIARCH_TASK_ID`。IDが無い起動は新規IDを生成して出力する。自動的に他セッションを選ばない。次回は出力IDを指定する。IDは認証情報ではない。

UUID形式のフォルダ名は衝突回避と再開に使う内部キーであり、作業名ではない。`--mode status` と `--mode sessions` は正本の `goal` を先頭に表示し、作業の目的で識別する。sessions一覧はbindingとタスク正本から都度読み、別の名称台帳を作らない。既存フォルダの手動改名は参照を壊すため行わない。新規IDを明示する場合は `audit-2026-09-13-agent-a` のような作業に合うASCII名も使えるが、既存IDと重複させない。例の作業名・日付は固定値ではない。

セッション文書・共有タスク・履歴はローカル管理記録で、Git配布物に含めない。`privacy-check` で追跡状態と除外設定を確認する。除外設定はすでに追跡されたファイルや過去の履歴を消さない。公開用の変更説明は機密情報を除いて `CHANGELOG.md` 等へ整理し、内部IDや生ログをそのまま転載しない。

同一セッションの再起動は既存文書を変更しない。別タスクには新しいセッションIDを使う。同じタスクへ別セッションから参加するときは `resume --task` を指定し、共通状態と以前の担当の証跡を読んで引き継ぐ。各セッションは自分の文書だけを編集する。Markdown中のロード履歴は新しいAIによる読み込みを証明しない。

既存セッションが不完全なら、先に新しいタスク状態を作らず停止する。bindingがあるのに共有state.jsonが消えている場合も新規タスクとして再生成しない。残る文書・history・バックアップを確認して復旧し、別タスクを開始する場合は新しいタスク／セッションIDを明示する。

再開時は3文書が通常ファイルとして存在するかも確認し、欠落・リンク・ディレクトリをそのまま起動成功とはしない。共有状態・binding・公開候補のJSONは通常ファイルのみ読み、重複キーやNaN等の非JSON数値は拒否する。FIFO等で書込側を待たず終了2となり、曖昧な記録を後勝ちで解釈しない。既存の不正ファイルは上書きせず、内容を確認して復旧する。

初期導入、セッション文書、任意コマンドは共通の言語設定読取を使う。コード枠・コメント・コードスパン内の例示を除外し、実設定の重複・不明値は生成前に停止する。明示した言語は優先し、未指定時はAXIARCH.md、旧AGENTS.md、最後に導入済み言語フォルダから解決する。status／check／path／snapshot／publishは言語別テンプレートを生成しないため、言語設定の修復を事前条件にしない。

healthも同じパーサーでAXIARCH.md、旧AGENTS.md、導入済み言語フォルダの順に解決する。enだけを導入していればen、それ以外で実設定が無ければjaを既定とする。コード例中のHTMLコメント記号とエスケープした記号は文字列として扱い、後続の実設定を隠さない。設定はコード例・コメント外で、元ファイルの行頭 `Project Native Language:` に記載する。不正・曖昧な実設定や読取不能ではhealthは終了1となる。`AXIARCH_PROCESS_DOC_LANG` は文書生成の上書きであり、healthでプロジェクト設定を隠すためには使わない。healthは旧ルート文書や別セッションの文字種を言語適合の証明とせず、選択セッションとユーザー指定に照らした文章の確認はAI・レビュー担当が行う。

読取は教訓・ローカル参照検査と共通の字句処理で、行番号と列位置を維持する。閉じていない実コメントは末尾まで非表示となる。設定値自体のコード表記は黙って取り除かず不明値とする。導入準備の `configure-language` は値だけを変更し、前後の空白、末尾のHTMLコメント、LF／CRLF／CR、最終改行の有無を保持する。値の途中のコメント・コード表記や空値は書換せず終了3で停止する。この処理は本書の最上位の設定行を対象とし、任意のHTMLや入れ子のMarkdownを描画・解釈するものではない。

`1e999` のように実行系の小数変換で無限大になる値も読取時に拒否し、保存時にもNaN・無限大を許可しない。受理した候補を非JSON値へ変形して共有状態を読み取れなくしないための検査であり、数値の業務上の意味を保証するものではない。

通常の生成エラーでは、その呼出しが新規作成したタスクとセッションだけを取り消し、既存タスク・セッション・旧文書を保持して終了2となる。rendererの終了0だけで成功にせず、3文書が空でない通常ファイルか確認する。旧文書の明示インポートは通常ファイルの内容を新しい文書へコピーし、元の内容・権限は変更しない。読取専用の旧文書もコピーでき、リンク・特殊ファイルは黙って省略せず拒否する。ルートの互換ポインターだけが作れない場合は警告し、利用可能な管理記録のIDを出力して終了0となる。

SIGKILL・電源断や後片付け自体の失敗では途中の記録が残る場合がある。`status` はstate.jsonのないタスクディレクトリを無視せず終了2で示し、同じIDの新規作成も拒否する。残るstate.json・history・binding・文書を確認して復旧し、正常なdraft状態だけが残った場合は同じタスクIDを明示してresumeする。既存の不完全なセッションは上書きせず、元の文書を復旧するか別のセッションIDで同じタスクに参加する。`.axiarch/sessions/.session-*` 等の残骸は、プロセスの終了と内容の要否を確認してから整理する。ロックファイル自体は待機中のプロセスが参照する可能性があるため、競合回避のために削除しない。

## 操作例

```bash
# 新規作業。担当・IDは対象に合わせて指定する
bash axiarch-scripts/axiarch-task-state.sh --mode new --task upgrade-audit --session agent-a --owner Codex
# 同じ作業の再開。既存セッションなら3文書もそのまま保持する
bash axiarch-scripts/axiarch-task-state.sh --mode resume --task upgrade-audit --session agent-a
bash axiarch-scripts/axiarch-task-state.sh --mode status
bash axiarch-scripts/axiarch-task-state.sh --mode sessions
bash axiarch-scripts/axiarch-task-state.sh --mode path --session agent-a
# 旧共有文書を新規セッションへコピー。元ファイルは移動・削除しない
bash axiarch-scripts/axiarch-task-state.sh --mode new --task migration-review --session agent-b --import-legacy
```

`AXIARCH_PROCESS_DOC_MODE=current|append` は互換入力として受理するが、どちらも既存ルート文書を置換しない。旧 `AXIARCH_PROCESS_DOC_ARCHIVE` / `AXIARCH_PROCESS_DOC_HISTORY_DIR` による自動退避は廃止し、既存 `.axiarch/process-doc-history/` を残す。言語は従来どおり `AXIARCH_PROCESS_DOC_LANG`、`AXIARCH.md`、旧 `AGENTS.md` の順に解決する。ネイティブUIが使える場合は別途同期し、使えない場合は理由を記録して作業を続ける。

## 構造化レコード

`schema_version=1`。タスクに `task_id`、`revision`（整数）、`owner`、`goal`、`phase`（draft / active / complete）、`max_age_seconds`（正の秒数、既定86400）、`criteria` 配列を持つ。

各完了条件は一意な `id`、`owner`、`description`、`verification`、`state`、`verified`、`target`、`checked_at`、`evidence` を持つ。状態は `not_started`（未着手）、`in_progress`（進行中）、`done`（完了）、`discarded`（破棄）。破棄には `reason` が必要で、完了条件の達成の代用にはできない。条件変更・除外は合意と理由を計画へ記録する。

`verified=false` のとき `checked_at=null`、`target=null`、`evidence=[]` とする。過去の証拠はhistoryに残る。`verified=true` には時刻と1件以上の証拠が必要。`done` は必ず `verified=true`。`target` と証拠の各要素は `{"path":"project-relative-file","sha256":"64桁のハッシュ"}` とする。対象が複数ある場合、確認対象一覧をファイルへ記録し、個々のファイルを証拠配列へ追加する。外部検証は取得結果を機密情報なしのローカル証跡へ保存する。外部の現状をハッシュだけで保証しない。

```bash
bash axiarch-scripts/axiarch-task-state.sh --mode snapshot --input axiarch-scripts/axiarch-task-state.sh
# state.jsonを読み候補JSONを自セッションへ作成してから、読んだ世代番号で公開する
bash axiarch-scripts/axiarch-task-state.sh --mode publish --session agent-a --input candidate.json --expected-revision 0
```

共通状態を直接上書きせず `publish` を使う。POSIXローカルファイルシステムでPython 3標準の `flock` と一時ファイル・renameを使う。競合・古いrevisionは終了コード2で拒否する。再読込・差分の突合・再実行はAIが行う。ロックはプロセス終了で解放される。更新途中に停止した場合、旧または新の完全なJSONが残り、historyで回復できる。一時ディレクトリは実行中でないことを確認してから片付ける。ネットワーク共有ディスク、複数ホスト、直接書込、悪意あるローカルwriter、OS電源断までを原子的更新の保証範囲に含めない。

タスクロックは同じ実行ユーザーが所有し、ハードリンク数1の通常ファイルに限る。FIFO・リンク・所有者不一致は待たず拒否する。原子的な置換は各JSONファイル単位であり、タスク・セッション・互換ポインター全体の同時確定を保証しない。historyの保存後に現在値の更新が失敗した場合は旧state.jsonを保持し、同じ内容のhistoryを使って再実行できる。

## 実行記録の保護

更新シェルの `check-paths` とPython補助の `copy` は、更新元・利用先・比較元の選択範囲に同じ事前検査を適用する。制御文字・リンク・特殊ファイル・予約パス・別名衝突はコピー前に拒否する。コピー中のI/O失敗は終了5で示すが、先に成功したファイルは残る。全体の排他・保護設定・診断・結果記録は `axiarch-scripts/axiarch-upgrade.sh` を使う。内部 `copy` 単体の終了0は更新全体の完了を表さず、REVIEWやTYPE-CONFLICTの保留判定はシェルの集計・確定処理が担う。

配布パスの識別では、大文字・小文字とUnicodeの正規等価な表記差をcasefoldとNFDで比較する。選択パス、親フォルダ、展開した子孫で別表記が衝突する場合は、保持対象を別名から更新しないよう適用前に拒否する。更新元・利用先・比較元の選択範囲で比較し、初期導入元と準備済みpayloadにも同じ名前検査を使う。これは移植性のための保守的な制約で、大小文字を区別するOSでも拒否する。通常の日本語・空白は使用できる。大文字小文字だけの改名を自動マージせず、元データを保全して配布用コピーとmanifestの表記を揃え、dry-run後に再実行する。利用先の改名は所有者の許可範囲で行う。ハードリンク等の全ての同一実体を識別する検査ではない。

更新のワイルドカード展開は、元のファイル名を検査してから行単位の選択へ変換する。改行・制御文字・Unicodeの行区切り（NEL、LINE SEPARATOR、PARAGRAPH SEPARATOR）を含むパスは拒否する。旧manifestのBlueprint探索でも名前の境界を保持し、別パスへの分割や操作ログへの混入を避ける。通常の空白・日本語名、隠しファイルの明示選択、除外設定は使用できる。拒否された名前は配布専用ソース側で確認し、利用先の記録を自動改名・削除しない。

配布元のmanifestはGit内部情報やローカル管理記録の所有権を取得しない。導入・更新のpayloadとしてプロジェクト全体の `.`、パス中の `.git` / `.axiarch`（大文字小文字の違いを含む）を受け付けない。更新では展開後の選択パスとその子孫も検査する。初期導入では配布フォルダと準備済みpayloadを検査する。管理記録の正規生成・更新は各専用処理で行い、この拒否を回避するために既存記録を削除しない。混在する場合は配布専用のソースを用意し、更新では必要な除外設定をレビューする。これはパスの境界検査であり、別名ファイルの内容に含まれる秘密を自動検知・匿名化するものではない。

状態の秘密・個人データ制約は `axiarch-rules/ja/universal/core/300_goal_and_current_state.md` §4.6を正本とする。初期導入・適用する更新・セッション生成／再開時は、`.axiarch/.gitignore` に管理記録の除外を補完する。対象はtasks、sessions、upgrades、conflicts、process-doc-history、process-doc-stateの各ディレクトリ、task-state.lock、privacy.lock、upgrade-result.json、install-result.json、install-health.logである（すべて `.axiarch/` 配下）。既存の除外内容とルートの `.gitignore` を保持し、Git管理下で独自ルールの否定指定が保護を打ち消す場合は診断失敗とする。dry-runと読取診断は変更しない。

除外設定の更新は `.axiarch/privacy.lock` で排他し、一時ファイルから原子的に置換する。リンク・特殊ファイル・別所有者を拒否する。通常エラー後に補完済みの除外設定が残る場合がある。既存の記録は削除しない。新しい更新runディレクトリは0700、導入診断ログと互換競合コピーは0600で作成する。既存ディレクトリ全体の権限は自動変更せず、過去の保存物の権限・保持期間、ACLや同期設定は別途確認する。

`bash axiarch-scripts/axiarch-task-state.sh --mode privacy-check` はGit管理済みの記録、除外から漏れたファイル、必要な除外設定を調べる。Gitリポジトリ内はGitコマンドを必要とし、検査失敗・必要な追跡状態の確認不能は終了2、healthは終了1となる。Gitリポジトリでない場合はローカルの除外設定だけの確認で終了0となり、Git追跡状態は未確認と表示する。この非Git運用ではGitの追加導入は不要。記録内容、過去のGit履歴、外部同期先は検査しない。既に管理されたファイルを自動でuntrackしたり履歴を書き換えたりしない。

バックアップ・競合ファイル・診断出力は復旧用の元情報を含み、自動匿名化されない。除外は暗号化やアクセス認証ではなく、強制追加、IDE同期、会話への貼付、外部アップロードを止めない。共有前に機密情報を除き、保管先・読者・保持期限を固有ルールへ記録する。復旧や証拠に必要な記録を無条件に自動削除しない。異常は端末・終了コード・ローカル記録へ出力し、外部への自動通知は行わない。監視やCIで使う場合は非0終了を通知へ接続し、ログ本文を無加工で転送しない。

## 検査段階

構造検査は過去の記録の形式と主張内の整合を調べる。時刻経過や対象の後日の変更だけで過去の完了記録を壊れた形式とは扱わない。現在の判断に使う準備・完了検査、および新たな `publish` では、対象と証拠を実ファイル・鮮度と突合する。未確認へ戻す際は `target=null` も指定し、過去の確認対象はhistoryを参照する。再開と完了検査はタスク・セッション・bindingのID対応を確認する。

| 段階 | コマンド | 判定 |
|:--|:--|:--|
| 配布構造 | `bash axiarch-scripts/check-axiarch-health.sh --phase structure` | 従来16段階の構造・配線・整合。作業中の未達成は失敗にしない |
| 記録構造 | `bash axiarch-scripts/axiarch-task-state.sh --mode check --task ID --phase structure` | draftの空ゴールは許可。状態・ID・証拠主張の矛盾は拒否 |
| 準備 | `bash axiarch-scripts/check-axiarch-health.sh --phase readiness --task ID` | ゴール・担当・条件・検証方法を必須化。条件の未達成は許可 |
| 完了 | `bash axiarch-scripts/check-axiarch-health.sh --phase completion --session ID` | 全条件done、証拠・対象のハッシュ一致、時刻・鮮度、テンプレート残存を検査 |

完了検査が成功した後に監査・証跡パケットと最終突合を行う。これらは記録の整合性検査であり、AIが意味を理解したこと、証拠の十分性、見落としの不存在、全操作の安全性を証明しない。確認対象・証拠の選び方と結論の妥当性は役割監査で判断する。AIが参照できるファイルやログの確認をユーザーへ委ねない。

active以降にゴール・条件ID・条件本文・検証方法を変更する場合は、候補JSONに `scope_change` の `reason` と `approval_ref` を記録する。検査は承認参照の記入を確認するだけで、承認の真正性は人間承認ゲートで確認する。
