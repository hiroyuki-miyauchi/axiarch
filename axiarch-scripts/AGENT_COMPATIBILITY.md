# エージェント・言語互換性 / Agent and language compatibility

## 日本語

この文書は接続方法と検証範囲を説明します。規則の正本は `AXIARCH.md`、自律ロードは `axiarch-rules/{lang}/LOADING_PROTOCOL.md`、記録は `axiarch-harness/{lang}/TASK_STATE_PROTOCOL.md` です。

### 製品ごとの入口と操作

| 製品 | 入口 | フックと限界 |
|---|---|---|
| Codex | ルートの `AGENTS.md` → `AXIARCH.md` | `.codex/hooks.json`。`apply_patch` の新規作成・移動先が既存なら拒否。通常の `Update File` 差分は許可。編集後の差分検査は1回の宣言に集約 |
| Claude Code | ルートの `CLAUDE.md` → `AXIARCH.md` | `.claude/settings.json`。既存ファイルへの `Write` を拒否。`Edit` / `MultiEdit` / `Write` 後に差分を検査 |
| Google Antigravity | `.agents/rules/prompt_pointer.md` → ルートの `AXIARCH.md` | `trigger: always_on` のルールポインター。Claude/Codexのフックを自動実行する構成ではない。ロードと記録はAIが手順を実行 |

選択製品の入口だけが必要で、その他のadapter・プロンプト集・Claudeコマンド生成・Gitのpre-commit hookは任意です。フックを導入する場合は `axiarch-scripts/` が必要です。プロンプト本文は任意層であり、Claudeのコマンドを生成しなくても3製品とも必要な正本を直接参照できます。

Codexのフックはセッションの作業ディレクトリから実行されます。同梱コマンドは親フォルダをたどり、最も近い `AXIARCH.md` を持つプロジェクトのスクリプトを使います。Gitの有無、通常の空白・日本語を含むパス、サブフォルダからの起動に対応します。正本が見つからない場合は別フォルダへ推測で切り替えません。Codexではプロジェクト設定の信頼に加えてフック定義の確認・信頼登録が必要です。新規・変更済みのフックは `/hooks` で確認してください。Axiarchは信頼登録を代行したり、信頼確認を迂回する設定を追加したりしません。

Claude Codeでは `CLAUDE_PROJECT_DIR` が起動時の場所を指したまま、イベントの `cwd` が別の作業コピーを指す場合があります。記録・補足・許可リスト・差分検査はイベントの作業先から正本を解決します。解決できない場合、起動処理は記録を作らず警告し、差分検査は未確認とします。`cwd` のない旧形式・手動呼び出しは明示プロジェクトまたはスクリプト配置先を使います。

### 日英と記録

Codex・Claude Codeのネイティブイベントには、そのセッションの `session_id` があります。別製品をCodexのシェルから起動しても、継承した `CODEX_THREAD_ID` で置き換えません。意図的に共通の `AXIARCH_SESSION_ID` を指定した場合は、その指定を使います。指定は実行単位に限定し、別の書き手へ同じIDを不用意に継承させないでください。入力IDが不正・競合の場合は、環境変数の有無によらず警告して未解決とします。直接CLIとhookの優先順位は `axiarch-harness/{lang}/TASK_STATE_PROTOCOL.md` を参照してください。

配布するルール・harness・promptは日本語と英語です。`init.sh` で応答の既定言語と両言語保持／単一言語を選びます。`Project Native Language` と記録テンプレートは共通パーサーで解決されます。ユーザーが明示した応答言語は既定より優先し、翻訳のためだけに設定行を自動変更しません。他言語での回答指定は可能ですが、その言語の規則一式が配布されている意味ではありません。設定・コマンド・異常通知には日英併記や英語の機械用ラベルもあり、生成文書の言語と区別します。

起動の補足は読了証明ではありません。実際のロード範囲を記録し、使える場合だけネイティブな計画ツールも同期します。Antigravityやフック未対応環境では、必要なH2以上の記録を `axiarch-scripts/axiarch-task-state.sh` から生成します。H0/H1に全工程を強制しません。同じタスクの参加者はタスクIDを共有し、異なる書き手は別セッションIDを明示します。製品が同じ親セッションIDを子エージェントに渡す場合も、同一文書の並行編集を避けてください。

### 更新・確認手順

Codex/Claudeの作業範囲の補足検査は、既知の日英語彙と全角表記を同じラベルへ照合します。独自のPOSIX正規表現指定は任意で、既定語彙を置換します。異常時は未確認と通知し、語彙一致を読了証明にしません。詳細と移行条件は [scripts README](README.md#axiarch-boot-remindersh) を参照してください。この補足をAntigravityへ自動注入する構成ではありません。

1. 利用先の `AXIARCH.md`、adapter、hook設定、任意の許可リストを確認し、既存仕様・記録を保持します。
2. `axiarch-scripts/axiarch-upgrade.sh --dry-run` で対象言語と製品を選びます。3製品の設定を共存させる場合は `--agent all` を指定できますが、他製品のadapterも含むため差分を確認します。
3. 更新候補の `REVIEW` / 競合を確認します。今回のhookコマンド変更も既存の独自設定を無条件に置換しません。旧版を比較元にしたreview-eachでのマージ、または設定内のAxiarch handlerだけのレビュー済み差分で反映します。古いhandlerを残して重複追加しません。
4. `axiarch-scripts/check-axiarch-health.sh --phase structure` と利用する製品の設定画面で配線・有効化・信頼状態を確認します。Codexは `/hooks`、Claude Codeは `/hooks` とプロジェクト設定、AntigravityはCustomizationsのRulesで入口の適用を確認します。
5. 製品の新しいセッションで入口から正本を参照できることを確認します。隔離した作業場所で新規作成、通常の差分編集、既存ファイル保護、再開、選択言語の記録を確認し、製品版・OS・結果を残します。

以前の環境変数優先で作られた記録は、自動で移動・改名・結合しません。`axiarch-scripts/axiarch-task-state.sh --mode sessions` で目的とbindingを確認します。継続するタスクへは、`--mode resume --task <確認したタスクID> --session <新しい書き手のID>` で参加し、元の証跡を保持します。hookから以前の同一セッションを意図的に再開する必要がある場合だけ、その起動に `AXIARCH_SESSION_ID` を指定します。複数の書き手で共用しません。

### 言語の追加・切替と任意コマンド

`axiarch-scripts/axiarch-upgrade.sh --lang en` は英語の配布ファイルを選ぶ指定です。`AXIARCH.md` の `Project Native Language` を英語へ変更する指定ではありません。`--lang ja` も同様で、既存の言語フォルダを削除しません。

1. 追加する言語を選んでdry-runし、必要な更新を適用します。プロンプト集も必要な場合だけ `--with-prompts` を付けます。`REVIEW`、保留、競合は結果記録で確認します。
2. 更新は利用先の仕様・教訓を自動翻訳せず、未導入言語の `axiarch-rules/{lang}/blueprint/core/000_project_overview.md` 等も配布例で補いません。追加言語を主に使う前に、既存の実仕様・教訓を根拠として必要なBlueprintと索引を整えます。構造healthの成功だけを新言語の準備完了としません。
3. プロジェクトの既定応答言語を変える依頼がある場合に、`AXIARCH.md` の設定行を差分で変更します。一時的な翻訳依頼だけでは変更しません。既存セッションの再開は記録を保持するため、言語が自動的に書き換わるものではありません。
4. Claudeの任意コマンドも切り替える場合は、導入済みの正本を対象に `bash axiarch-scripts/axiarch-prompts-install.sh --lang en --dry-run` で確認し、同じ指定から `--dry-run` を外して再生成します。日本語は `--lang ja`。再生成はコマンドを1つの選択言語へそろえる操作で、言語別コマンドを同時に増やしません。編集済み・競合する独自コマンドは保持して終了3となるため、差分を確認してから再実行します。Codex・Antigravityは任意プロンプトの正本を直接参照できます。

製品の追加も選択だけでは適用されません。`--agent all` の既定実行では必要なadapterが `REVIEW` として残る場合があります。`--interactive` で対象ファイルを確認して反映するか、レビュー済みの差分を統合します。既存handlerを変更する場合は製品の信頼状態も再確認します。

新しい言語の `LOADING_PROTOCOL.md` がレビュー待ちのままの場合、`Goal/state contract missing for en`（または `ja`）で診断が失敗し、更新は終了4となります。同じ更新元・言語を指定した `--safe-only --dry-run` で中核ファイルの追加を確認し、適用する場合は `--dry-run` を `--apply` へ変更します。中核を補っても `lesson log unavailable` が出る場合は、追加言語の `axiarch-rules/{lang}/blueprint/core/010_project_lessons_log.md`、概要、索引を既存の実状態から整えます。検査を通すために教訓を捨てたり、架空の仕様で埋めたりしません。再実行で診断が成功してもmixed設定・索引等の `REVIEW` があれば終了3の部分更新です。結果記録と残る差分を確認し、版数の確認だけを目的に利用先の設定を置換しないでください。

### 検証した範囲と保証しない範囲

Claude/Codexの任意の上書き許可リストは、リンク・所有者・通常ファイル・UTF-8・NULの共通検査を通してから利用します。壊れた例外設定で別製品の許可へ切り替えず、新規作成・差分編集には例外を要求しません。形式と旧設定の移行は [scripts READMEの許可リスト手順](README.md#whitelist-サポート--whitelist-support) を参照してください。Antigravityに同じフックが自動適用される意味ではありません。

2026-09-14の監査では公式仕様、ローカルCLIの版表示（Codex 0.153.4、Claude Code 2.1.167）、隔離した12通りの導入構成と実health、公式形式のイベント入力によるスクリプト実行、Codex本体の差分適用処理を照合します。これはモデル推論・実製品UI・権限設定まで含む全工程の実証ではありません。Google Antigravityは従来確認した環境・実務の範囲で実証済みです。Codex・Claude Codeの実務実証と動作保証は引き続き主張しません。

補助スクリプトはBash、Python 3、POSIXファイルシステムを前提とします。CIはUbuntu・macOSに加え、Windowsランナー上でネイティブPythonの安全な拒否とWSL 2内の実動作を検査します。ネイティブWindows PythonやGit Bash単独での実行は非対応です。Windowsでは製品の実行環境・Bash・Python・プロジェクトをWSL 2内に揃えます。製品のWindows UIやWSL/Windows混在までは実証していません。対応範囲・移行・改行の扱いは [Windows手順](WINDOWS.md) を参照してください。

保護フックは設定された対応ツール経路だけを検査します。シェル・MCP・別ツールからの書き換え、差分形式による実質的全面置換、競合による検査後の変更まで網羅しません。Codexの未知のpatch形式や前後空白で解釈が変わるパスは、未確認のまま許可せず終了2とします。削除の是非は承認手順が担います。許可リストは権限そのものではなく記録済み承認を実行へ反映する設定です。差分フックのblockは編集後の停止要求であり、編集を取り消しません。healthは構造・記録の整合性検査で、完全なルール読了、意味理解、翻訳の正確性、全操作の安全性を証明しません。

## English

This document describes adapters and verification boundaries. `AXIARCH.md` remains canonical; use `axiarch-rules/{lang}/LOADING_PROTOCOL.md` for selective loading and `axiarch-harness/{lang}/TASK_STATE_PROTOCOL.md` for records.

| Product | Entrypoint | Hook coverage |
|---|---|---|
| Codex | Root `AGENTS.md` → `AXIARCH.md` | `.codex/hooks.json`; checks `apply_patch` add/move destinations for existing paths, permits focused updates, and declares one post-edit observer |
| Claude Code | Root `CLAUDE.md` → `AXIARCH.md` | `.claude/settings.json`; denies `Write` to existing files and observes `Edit`, `MultiEdit`, and `Write` afterward |
| Google Antigravity | `.agents/rules/prompt_pointer.md` → root `AXIARCH.md` | Always-on rule pointer; does not automatically execute Claude/Codex hook configurations. The agent follows loading and record procedures |

Only the selected adapter is required. Other adapters, prompt libraries, generated Claude commands and Git pre-commit hooks are optional. Installed hooks require `axiarch-scripts/`. All three products can directly read optional canonical prompts without generating Claude commands.

Codex runs hooks in the session working directory. Bundled commands search upward for the nearest `AXIARCH.md`, supporting nested starts, non-Git projects, spaces and Unicode paths. An unresolved root is not replaced with a guessed project. Project trust and review/trust of the exact hook definition are runtime requirements: review new or changed definitions in `/hooks`. Axiarch does not approve or bypass trust on the user's behalf.

Claude Code can retain its initial `CLAUDE_PROJECT_DIR` after moving to a worktree. Records, reminders, allowlists and diff measurement resolve the active project from event `cwd`. An unresolved project produces a startup warning without records and an unassessed diff result. Legacy/manual calls without `cwd` use the explicit project or script location.

Native Codex and Claude Code events supply the current `session_id`. Launching another product from a Codex shell does not replace that identity with inherited `CODEX_THREAD_ID`. An intentional `AXIARCH_SESSION_ID` override still applies; scope it to the intended invocation instead of sharing it inadvertently across writers. Invalid or conflicting native IDs remain unresolved with a warning even when environment variables exist. See `axiarch-harness/{lang}/TASK_STATE_PROTOCOL.md` for direct CLI and hook precedence.

Distributed rules, harnesses and prompts are Japanese and English. `init.sh` selects the default response language and either both language trees or one. The language setting and record templates share a parser. Explicit user response language takes precedence; do not rewrite the project setting merely for translation. Requesting another response language does not imply a distributed rule tree in that language. Setup, commands and diagnostic messages may remain bilingual or use English machine labels.

Startup reminders do not prove loading. Record actual read ranges and synchronize native planning tools only when available. For Antigravity or environments without hooks, create necessary H2+ records through `axiarch-scripts/axiarch-task-state.sh`; do not impose the full workflow on H0/H1. Share task IDs for shared work and use distinct session IDs for different writers, including runtimes that pass a parent's session ID to subagents.

### Updating and checking

Codex/Claude scope hints map known Japanese/English aliases and fullwidth notation to shared labels. Optional custom POSIX expressions replace the defaults. Inspection failures are reported as unassessed; keyword matches do not prove reading. See the [scripts README](README.md#axiarch-boot-remindersh) for details and migration. This reminder is not automatically injected into Antigravity.

1. Inspect and preserve local canonical settings, adapters, hook configurations, allowlists, specifications and records.
2. Preview with `axiarch-scripts/axiarch-upgrade.sh --dry-run`, selecting the language and agent. `--agent all` can install coexisting adapters but also includes other products, so review its scope.
3. Resolve `REVIEW` and conflicts. Hook command changes do not overwrite custom configurations unconditionally. For mixed hook settings, use review-each with the previous version as the merge base, or apply reviewed diffs only to Axiarch handlers. A comparison source alone does not auto-apply a review-policy file. Replace obsolete handlers instead of appending duplicates.
4. Run `axiarch-scripts/check-axiarch-health.sh --phase structure` and verify activation/trust in the actual product: Codex `/hooks`, Claude Code `/hooks` and project settings, or Antigravity Customizations → Rules.
5. Start a new product session in an isolated project and verify entrypoint discovery, creation, focused edits, existing-file protection, resumption and selected-language records. Record the product version, OS and observations.

Records created under the earlier environment-first behavior are not moved, renamed or merged automatically. Inspect goals and bindings with `axiarch-scripts/axiarch-task-state.sh --mode sessions`. Join continuing work using `--mode resume --task <inspected-task-id> --session <new-writer-id>` and retain the original evidence. Set `AXIARCH_SESSION_ID` for a particular hook launch only when intentionally resuming the same previous session; do not share it across writers.

### Adding or switching languages and optional commands

`axiarch-scripts/axiarch-upgrade.sh --lang en` selects English distribution files; it does not change `Project Native Language` in `AXIARCH.md`. The same applies to `--lang ja`. Neither option removes an existing language tree.

1. Preview the additional language and apply the needed updates. Add `--with-prompts` only when the optional library is wanted. Inspect `REVIEW`, pending items and conflicts in the result record.
2. Upgrade does not translate adopter specifications or lessons, or populate missing project-owned files such as `axiarch-rules/{lang}/blueprint/core/000_project_overview.md` with reference examples. Before using the additional language as primary, prepare the necessary Blueprint files and indexes from the existing actual project state. A passing structure health check alone does not establish readiness in that language.
3. Change the setting line in `AXIARCH.md` through a focused edit when a change of project default is requested. A temporary translation request does not require this. Resuming a session preserves its records rather than automatically translating them.
4. To switch optional Claude commands, preview the installed canonical library with `bash axiarch-scripts/axiarch-prompts-install.sh --lang en --dry-run`, then repeat without `--dry-run` to regenerate. Use `--lang ja` for Japanese. Regeneration selects one command language; it does not add simultaneous language-specific copies. Edited or conflicting custom commands remain intact with exit 3; review their differences before retrying. Codex and Antigravity can read the canonical optional prompts directly.

Selecting an additional agent does not itself apply its configuration. A default `--agent all` run may leave required adapters as `REVIEW`. Use `--interactive` to review and apply the relevant files, or integrate reviewed diffs. Recheck product trust when existing handlers change.

If the new language's `LOADING_PROTOCOL.md` remains pending review, diagnosis reports `Goal/state contract missing for en` (or `ja`) and upgrade exits 4. Preview safe-owned core additions with the same source and language plus `--safe-only --dry-run`; replace `--dry-run` with `--apply` when applying that selection. If `lesson log unavailable` remains, prepare `axiarch-rules/{lang}/blueprint/core/010_project_lessons_log.md`, the overview and index from the actual existing project state. Do not discard lessons or fabricate specifications to pass a check. Even after a successful diagnosis on retry, pending mixed settings or indexes produce a partial result with exit 3. Inspect the result and remaining differences; do not replace adopter settings merely to obtain a confirmed version.

### Verification boundaries

Optional Claude/Codex overwrite lists share link, ownership, regular-file, UTF-8 and NUL checks before use. Damaged exception settings do not switch to another agent's permission; new-file creation and focused edits need no exception. See the [scripts README allowlist instructions](README.md#whitelist-サポート--whitelist-support) for format and migration. This does not mean the same hooks run automatically in Antigravity.

The 2026-09-14 audit compares official documentation, local CLI version output (Codex 0.153.4 and Claude Code 2.1.167), twelve isolated installation configurations with real health diagnostics, script execution using documented event payloads, and the native Codex patch engine. It is not end-to-end validation of model reasoning, product UI or permission settings. Antigravity's prior practical validation remains limited to the environments and tasks exercised. Codex and Claude Code remain unvalidated in practice, with no operation guarantee.

Helpers require Bash, Python 3 and POSIX filesystem behavior. Alongside Ubuntu/macOS, CI runs native Python rejection checks and WSL 2 runtime regressions on a Windows runner. Native Windows Python and Git Bash alone are unsupported. Keep the agent execution environment, Bash, Python and project inside WSL 2. Windows product UIs and mixed Windows/WSL execution remain unvalidated. See the [Windows guide](WINDOWS.md) for scope, migration and line endings.

Guards inspect only configured supported tool paths. Shell/MCP/other writes, effective full rewrites expressed as update hunks, and races after inspection are not comprehensively covered. Unknown Codex patch syntax and ambiguous padded paths exit 2 rather than granting unassessed permission. Deletion decisions still follow approval rules. Allowlists implement recorded approval; they do not establish authorization themselves. Post-edit blocking requests a pause without undoing edits. Health checks structural and record consistency, not complete loading, understanding, translation accuracy or safety of every operation.

## 公式参照 / Official references

- [Codex hooks](https://learn.chatgpt.com/docs/hooks)
- [Codex instruction discovery](https://learn.chatgpt.com/docs/agent-configuration/agents-md)
- [Claude Code hooks](https://code.claude.com/docs/en/hooks)
- [Claude Code project instructions and memory](https://code.claude.com/docs/en/memory)
- [Antigravity workspace rules](https://antigravity.google/docs/ide/rules/)
