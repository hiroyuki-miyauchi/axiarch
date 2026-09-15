# Axiarch Scripts — Diagnostic & Health Check Tools

> Axiarch 採用プロジェクト向けの診断・ヘルスチェックスクリプト集。`init.sh` 経由で全採用プロジェクトに自動配布される。
>
> Diagnostic and health-check scripts for Axiarch-adopting projects. Distributed automatically by `init.sh`.
>
> `axiarch-scripts/` は最小構成の必須ファイルではありません。`init.sh` は診断・hook補強・安全アップグレードをすぐ使える推奨ツールとして同梱コピーしますが、`AXIARCH.md`、`AGENTS.md` adapter、`axiarch-rules/`、`axiarch-harness/` の最小運用では任意です。
>
> `axiarch-scripts/` is not required for the minimal Axiarch setup. `init.sh` copies it as recommended tooling for diagnostics, hook reinforcement, and safe upgrades, but it remains optional when a project only needs the minimal `AXIARCH.md`, `AGENTS.md` adapter, `axiarch-rules/`, and `axiarch-harness/` setup.
>
> v1.12.0以降の本体リポジトリ診断では、ハーネスエンジニアリングの説明が正本、公開入口、rules索引、harness README、AI向け要約に残っているかも確認します。
>
> In v1.12.0 and later, source-repository diagnostics also check that Harness Engineering remains explicit across the canonical protocol, public entrypoints, rules indexes, harness README, and AI-facing summaries.

---

製品別の入口・信頼設定・作業コピー・日英・OSの検証範囲は [エージェント互換性](AGENT_COMPATIBILITY.md) を参照してください。

See [agent compatibility](AGENT_COMPATIBILITY.md) for entrypoints, trust, worktrees, language and OS verification boundaries.

Windowsの補助ツールはWSL 2内で実行します。ネイティブPython・Git Bash単独は非対応です。[Windows手順](WINDOWS.md) に前提条件・CI範囲・既存導入先の扱いを記載しています。

Run helpers inside WSL 2 on Windows; native Python and Git Bash alone are unsupported. See the [Windows guide](WINDOWS.md) for prerequisites, CI boundaries and existing installations.

## 📋 配布スクリプト一覧 / Available Scripts

| スクリプト / Script | 目的 / Purpose | 主な使用場面 / When to use |
|:--|:--|:--|
| [`check-axiarch-health.sh`](#check-axiarch-healthsh) | **Axiarchの構造・記録の健全性診断**（16 段階、`--quiet` 対応、v1.11.0でルートのタスク文書生成、v1.17.0でセッション別タスク記録、ネイティブタスク状態同期、v1.10.0+由来のリリース整合とROADMAP Current Stable・正規AI-facing header・CHANGELOG compare ref・Actions immutable SHA厳密一致・署名tag経路・日英完了release entry、Blueprint INDEX版数、safe upgrade実行promptのREADME/llms/rules索引、source-only既定skipとinteractive明示override、対話選択肢重複排除、本体リポジトリ専用ファイル分類、README/llms/scripts READMEの必須/任意境界、ハーネスエンジニアリング入口保持、ja/en相対path・番号見出しparity、SECURITY private reporting境界、Claude Memory正本境界、AXIARCH.md・axiarch-harness・中核ファイルのGit追跡状態、AXIARCH.md mixed/review所有境界、fallback core Blueprint検出、任意prompt証跡、`replace-if-local-unchanged` 実行時保護、型不一致review検査を追加） / Structure and record health diagnostic (16-stage, `--quiet` support; v1.11.0 adds root task documents; v1.17.0 adds session-specific task records and native state sync, v1.10.0+ release parity with exact ROADMAP Current Stable, canonical AI-facing headers, the CHANGELOG compare ref, immutable Actions SHAs, the signed-tag path, and completed ja/en release entries, Blueprint INDEX version metadata, safe-upgrade execution prompt indexing across README, llms, and rules indexes, source-only default skip with explicit interactive override, deduplicated interactive choices, source-repository-only file classification, required/optional boundary checks for README, llms, and scripts README, Harness Engineering entrypoint retention, ja/en relative-path and numbered-heading parity, the SECURITY private-reporting boundary, Claude Memory canonical boundary, source release-file Git tracking for AXIARCH.md, axiarch-harness, and core files, AXIARCH.md mixed/review ownership boundary, fallback core Blueprint discovery, optional prompt evidence checks, `replace-if-local-unchanged` runtime protection, and type-conflict review checks) | 「フックが動いていない気がする」「結晶化されていない」「タスク切替で再 load 漏れ」と感じた時 / When you suspect protocol violations or task-boundary misses |
| [`axiarch-boot-reminder.sh`](#axiarch-boot-remindersh) | **UserPromptSubmit hook の外出しスクリプト**（v1.6.0+ TTL 二段階出力 + v1.8.0+ Check D Task Boundary Detection）。毎ターンの見直し候補 (A/B/C/D) + TTL 内 + 候補なしなら短縮版 / Externalized hook script (v1.6.0+ two-stage TTL + v1.8.0+ Check D task-boundary); review hints A/B/C/D, short-circuits within TTL when no hint is detected | `init.sh` 経由で `.claude/settings.json` や `.codex/hooks.json` に自動配線される / Auto-wired by `init.sh` |
| [`axiarch-protect-antifull.sh`](#axiarch-protect-antifullsh) | **PreToolUse hook の外出しスクリプト**。`Write` tool の既存ファイル上書きを物理遮断（§7.6 ANTI-FULL-OVERWRITE）/ Externalized PreToolUse hook; physically blocks `Write` tool calls targeting existing files | `init.sh` 経由で `.claude/settings.json` や `.codex/hooks.json` に自動配線される / Auto-wired by `init.sh` |
| [`axiarch-diff-guard.sh`](#axiarch-diff-guardsh) | **PostToolUse hook の外出しスクリプト**。ClaudeのEdit / MultiEdit / Write、Codexのapply_patch後のgit diff規模を測定し、閾値超過時に warn / block / Externalized PostToolUse hook; measures git diff size after Claude Edit / MultiEdit / Write or Codex apply_patch and warns or blocks above thresholds | `init.sh` 経由で `.claude/settings.json` や `.codex/hooks.json` に自動配線される / Auto-wired by `init.sh` |
| [`axiarch-init-task-md.sh`](#axiarch-init-task-mdsh) | **SessionStart hook の外出しスクリプト**。会話開始時に3つの現在タスク文書を自動ブートストラップ / Externalized SessionStart hook; auto-bootstraps the three current-task docs on session start | `init.sh` 経由で `.claude/settings.json` や `.codex/hooks.json` に自動配線される / Auto-wired by `init.sh` |
| [`axiarch-task-state.sh`](#axiarch-task-statesh) | **現在タスク文書ライフサイクル補助**。`task.md` / `implementation_plan.md` / `walkthrough.md` をセッション別に保持 / Current-task document lifecycle helper; session-specific storage for `task.md` / `implementation_plan.md` / `walkthrough.md` | `axiarch-init-task-md.sh` から呼び出し / Called by `axiarch-init-task-md.sh` |
| [`axiarch-upgrade.sh`](#axiarch-upgradesh) | **Safe Upgrade Wizard**。`axiarch-manifest.json` に基づき、Axiarch本体・プロジェクト固有Blueprint・任意ファイルをグループ単位で更新判断 / Manifest-based safe upgrade wizard; groups Axiarch-owned files, project Blueprint state, and optional files | 既存プロジェクトへ必要分だけアップグレードしたい時 / When upgrading only the needed parts of an existing adopter project |
| [`axiarch-prompts-install.sh`](axiarch-prompts-install.sh) | **プロンプト → Claude Code slash command 生成**（v1.13.0+）。`axiarch-prompts/` から `.claude/commands/axiarch-<name>.md`（`/axiarch-<name>`）を冪等生成。コマンドは正本プロンプトを Read+実行する thin pointer / Generates Claude Code slash commands (`/axiarch-<name>`) from `axiarch-prompts/`; thin pointers (idempotent, bilingual, `--clean`/`--dry-run`) | プロンプトを `/` から呼びたい時（Claude Code）。`init.sh` で opt-in 生成、または手動実行 / To invoke prompts via `/` in Claude Code |
| [`check-git-config-clean.sh`](#check-git-config-cleansh) | Git worktree管理情報・branch config整合チェック / Git worktree metadata and branch-config integrity | 複数worktree／tool利用後、prunable metadataやstale branch configを確認する時 / after concurrent worktree or tool use |

---

## `axiarch-upgrade.sh`

### 概要 / Overview

既存のAxiarch採用プロジェクトを、プロジェクト固有のBlueprint状態を壊さずに更新するためのローカルファーストなアップグレード補助ツール。
`axiarch-manifest.json` の所有境界に従い、Universal、プロトコル、scripts、agent hook、Blueprintテンプレート・共有ルール、Blueprint索引、プロジェクト固有Blueprint、prompts、pointer files、Axiarch本体リポジトリ専用ファイルをグループ化して扱う。
本体リポジトリ専用ファイルは既定ではskipし、`--interactive` で明示選択された場合だけ差分確認や適用候補に進める。
対象ファイル、除外条件、グループの既定方針は必須のPython 3で `axiarch-manifest.json` から読み込むため、jqの有無で対象は変わりません。`files` キーがない旧manifestだけ既定リストへ移行し、不正なJSON・型・所有区分は適用前に停止します。

Local-first upgrade helper for existing Axiarch adopter projects. It follows `axiarch-manifest.json` ownership boundaries and groups Universal rules, protocols, scripts, agent hooks, Blueprint templates and shared rules, Blueprint index, project-owned Blueprint state, prompts, pointer files, and Axiarch source-repository-only files.
Source-repository-only files stay skipped by default and move into diff review or application only when explicitly selected with `--interactive`.
The required Python 3 runtime reads file lists, exclusions and group defaults from `axiarch-manifest.json`, independently of jq. Only a legacy manifest without a `files` key uses embedded defaults. Invalid JSON, types or ownership stop before application.

フォルダの除外指定は配下のファイルにも適用します。同一パス・glob展開後の重複に異なる所有区分や方針がある場合、親フォルダと子ファイルが重複選択される場合は、適用前に終了5で停止します。manifestで親側から子を除外して所有境界を明確にしてから再実行します。FIFO等の通常ファイル・ディレクトリ以外もプレビュー前に拒否します。この停止は採用先を変更せず、端末の診断が原因確認の記録です。

Directory exclusions include descendants. Conflicting policies or ownership for the same resolved path, including glob overlaps, and overlapping parent/child selections stop with exit 5 before application. Exclude children from the parent manifest entry to make ownership explicit, then retry. Special files such as FIFOs are rejected before preview. These preflight failures leave the adopter unchanged; terminal diagnostics explain the cause.

### 使い方 / Usage

```bash
# 変更計画だけ確認 / Preview only
bash axiarch-scripts/axiarch-upgrade.sh --to v1.18.0 --dry-run

# 古い採用先で helper が未導入の場合 / Bootstrap the helper temporarily when it is not installed yet
# TMPDIR（未指定・空なら/tmp）内に専用領域を作成 / Use TMPDIR, defaulting to /tmp if unset or empty
axiarch_bootstrap_dir="$(mktemp -d "${TMPDIR:-/tmp}/axiarch-bootstrap.XXXXXXXX")" &&
curl --fail --silent --show-error --location --proto '=https' --proto-redir '=https' --connect-timeout 15 --max-time 120 \
  https://raw.githubusercontent.com/hiroyuki-miyauchi/axiarch/v1.18.0/axiarch-scripts/axiarch-upgrade.sh \
  -o "$axiarch_bootstrap_dir/download.part" &&
mv "$axiarch_bootstrap_dir/download.part" "$axiarch_bootstrap_dir/axiarch-upgrade.sh"
# 取得成功と内容・提供元を確認後に実行 / Run after checking successful download, contents and source
test -n "$axiarch_bootstrap_dir" && bash "$axiarch_bootstrap_dir/axiarch-upgrade.sh" --target "$(pwd)" --to v1.18.0 --dry-run

# Axiarch所有の安全更新だけ反映 / Apply only low-risk Axiarch-owned updates
bash axiarch-scripts/axiarch-upgrade.sh --to v1.18.0 --safe-only --apply

# Codex向けに必要なものだけ対象化 / Scope to Codex-oriented files
bash axiarch-scripts/axiarch-upgrade.sh --to v1.18.0 --agent codex --dry-run

# グループごとに対話選択 / Choose group actions interactively
bash axiarch-scripts/axiarch-upgrade.sh --to v1.18.0 --interactive
```

### 取得・入力検査の境界 / Download and input validation boundary

この段落の追加処理はv1.17.0に含まれます。初期導入と更新のリモート取得はcurl・Python 3・tarを必要とし、HTTPSとHTTPSへのリダイレクトに限定します。wgetへの自動切替は行いません。curlを使わない環境では確認済みローカルソースを指定します。`AXIARCH_DOWNLOAD_TIMEOUT_SECONDS` は1–600秒、既定120秒で、取得と展開にそれぞれ適用します。複数の更新元を取得する場合、呼出し全体の時間上限ではありません。

These additions are included in v1.17.0. Remote installation and upgrade retrieval require curl, Python 3 and tar, with HTTPS-only transfers and redirects. There is no automatic wget fallback; use a reviewed local source when curl is unavailable. `AXIARCH_DOWNLOAD_TIMEOUT_SECONDS` accepts 1–600 seconds, default 120, separately for retrieval and extraction. It is not a whole-command deadline when multiple sources are retrieved.

HTTP失敗・時間切れ・破損gzipを適用前に拒否します。圧縮64 MiB、展開tar 512 MiB、1項目64 MiB、10,000項目を上限とし、絶対パス・親参照・制御文字・リンク・特殊ファイル・重複や大文字小文字／Unicodeで衝突する同一パス・複数ルートを拒否します。異常は端末と非0終了で示し、成功表示や利用先への適用へ進めません。適用前の失敗では利用先に結果記録を作らず、自動処理側で終了値を受け取り、必要なら機密情報を除いた診断を保持します。

HTTP failures, timeouts and corrupt gzip stop before application. Limits are 64 MiB compressed, 512 MiB expanded tar, 64 MiB per entry and 10,000 entries. Absolute/parent/control paths, links, special files, duplicate or case/Unicode-colliding paths and multiple roots are rejected. Failures produce terminal diagnostics and nonzero exit without reporting preparation success or applying files. Pre-application failures create no adopter outcome record; automation should capture the exit status and retain sanitized diagnostics if needed.

これらは配布物の真正性・コードの安全性・全OSでの動作を証明しません。タグ名の固定も署名検証の代用ではありません。アーカイブ検査はディスクの完全なクォータではなく、curlの実装によっては圧縮サイズを取得後に判定します。確認したソースを使い、終了後は専用一時ディレクトリの内容と不要になったことを確認して整理してください。公開済みの古いランチャーに新処理が追加されたとは扱いません。

These checks do not establish distribution authenticity, code safety or operation on every OS. Pinning a tag is not signature verification. Archive checks are not a complete disk quota; depending on curl, compressed size may be checked after retrieval. Use a reviewed source and remove the private temporary directory after inspecting its contents and confirming it is no longer needed. Previously published launchers do not gain this new behavior retroactively.

初期導入・更新・healthは同じ厳密なJSON読取を使い、重複キー・NaN・無限大と数値オーバーフローを拒否します。キー・値・入れ子の配列にもUnicodeとして表せない単独サロゲートを許可しません。manifestの版数・型・所有区分も検査します。healthは導入済みのClaude/Codex両設定のJSONを確認し、異常時は残りの検査を実行せず失敗を返します。個別のhook宣言も両設定について検査します。JSON合格は全エージェントの実行確認ではありません。

Installation, upgrades and health share strict JSON decoding, rejecting duplicate keys, NaN, infinity and numeric overflow. Unpaired surrogates that do not represent Unicode scalar values are rejected in keys, values and nested arrays as well. Manifest version, types and ownership are also validated. Health checks JSON in both installed Claude/Codex configurations and stops with failure before subsequent checks on invalid input. Individual hook declarations are checked in both configurations; valid JSON is not proof that every agent executes the hooks.

起動・補足・保護フックと作業範囲CLIは、標準入力のバイト列をUTF-8として厳密に読みます。`PYTHONIOENCODING` の置換・別文字コード指定で壊れた入力を修復したり、日本語を別の文字列へ変えたりしません。正常な日本語・英語・絵文字と正規化形式は保持します。端末全体の文字コード設定を変更する機能ではありません。この制約は [RFC 8259 §8](https://www.rfc-editor.org/rfc/rfc8259#section-8) の相互運用性に基づくAxiarchの入力契約です。単独サロゲートはJSON文法上表現できても受理しません。

Startup, reminder and protection hooks and the scope CLI decode stdin bytes strictly as UTF-8. Replacement or alternate decoding selected by `PYTHONIOENCODING` cannot repair damaged input or reinterpret Japanese text. Valid Japanese, English, emoji and normalization forms are preserved. This does not configure terminal-wide encoding. The restriction is Axiarch's input contract for the interoperability described in [RFC 8259 §8](https://www.rfc-editor.org/rfc/rfc8259#section-8); unpaired surrogates are rejected even though the JSON grammar can express them.

言語設定・プロンプト・作業証跡・比較用記録もUTF-8で読み、OSの既定文字コードへ依存しません。UTF-8以外で保存された旧文書は自動変換しません。元の文字コードと内容を確認し、原本を保全してレビュー済みのUTF-8版を適用してください。

Language settings, prompts, task evidence and comparison records are also read as UTF-8 rather than using the OS default encoding. Older documents saved in another encoding are not converted automatically. Confirm the original encoding and content, preserve the originals and apply a reviewed UTF-8 version.

利用者向けのシェル入口は、子Pythonの `PYTHONUTF8=1` と `PYTHONIOENCODING=utf-8` を指定します。継承したASCII・Latin-1・文字置換の設定やCロケールに左右されず、パス・プロンプト・許可リスト・診断をUTF-8で受け渡すためです。文字置換によって日本語名の既存ファイルを別名として調べ、Writeを許可する誤判定も抑えます。不正な入力を修復する指定ではありません。変更は実行中のシェルと子プロセス内に限り、呼出し元の環境や保存済みファイル、製品の信頼設定は変更しません。

Public shell entrypoints set `PYTHONUTF8=1` and `PYTHONIOENCODING=utf-8` for child Python processes. Paths, prompts, allowlists and diagnostics use UTF-8 regardless of inherited ASCII, Latin-1, replacement settings or the C locale. This also addresses Write checks incorrectly allowing an existing Unicode filename after character replacement turns it into a different path. Invalid input is not repaired. These settings affect only the running shell and its children, leaving the caller's environment, stored files and product trust settings unchanged.

更新時は、使用する `axiarch-scripts/` のシェル入口を一緒に反映してください。初期導入には更新済みの `init.sh` を使います。Python補助を直接組み込む独自連携は、UTF-8の実行・入出力契約を呼出し側で指定する必要があります。端末側の表示設定やWindowsネイティブの動作保証を追加する変更ではありません。

When upgrading, apply the shell entrypoints in the selected `axiarch-scripts/` together; use the updated `init.sh` for initial installation. Custom integrations invoking internal Python helpers directly must configure their UTF-8 execution and I/O contract at the caller. This change does not configure terminal rendering or add native Windows support.

文字の検査に失敗すると、起動・補足は既存の警告経路を使い、作業記録を新規生成しません。保護フックは新規作成の入力でも終了2で拒否します。正常な新規作成は引き続き許可します。Unicode診断は入力本文を転載しません。古いJSON記録や設定に単独サロゲートがあれば共通CLIも失敗します。元の記録を保持し、生成元・バックアップと照合して意図した値を復旧してください。文字の削除・置換で検査だけを通す自動修復は行いません。Antigravity等でも共通記録CLIには同じ制約を適用しますが、フックの自動適用を意味しません。

On invalid character input, startup/reminder hooks use their existing warning paths without creating work records. Protection hooks exit 2 even for a new-file request with invalid input; valid creation remains allowed. Unicode diagnostics do not echo payload contents. Shared CLIs also reject old JSON records or settings containing unpaired surrogates. Preserve the originals and recover intended values from the producer or reviewed backups. No automatic character deletion or replacement is performed merely to pass validation. The shared record CLI applies the same restriction for Antigravity and other agents; it does not imply automatic hook execution there.

### 主な選択肢 / Main Choices

配布範囲の検査では、プロジェクト全体の `.` と `.git` / `.axiarch` の管理領域を予約パスとして拒否する。詳細は [実行記録の保護](../axiarch-harness/ja/TASK_STATE_PROTOCOL.md#実行記録の保護)。引数入力の不備は終了2、manifest・展開結果・選択パスの検査拒否は適用前に終了5、初期導入の配布検査は終了3となり、利用先へ結果ファイルを作らない。終了5だけでは適用前の拒否と適用中の失敗を区別できないため、端末診断と当該実行の記録の有無・状態を確認する。以前の実行結果を今回の結果と取り違えない。自動処理は終了値を受け取り、通知が必要なら機密を除いた診断へ接続する。初期導入は必須項目をファイルとディレクトリに分けて検査し、NOTICE等がディレクトリでも正常としない。対応するinstaller・Python補助一式を使い、既存導入先の内部記録を配布物へ混ぜない。

Distribution checks reject the whole-project `.` selection and reserved `.git` / `.axiarch` components; see [Runtime artifact protection](../axiarch-harness/en/TASK_STATE_PROTOCOL.md#runtime-artifact-protection). Argument errors exit 2; invalid manifests, expansions and selected paths exit 5 before application; installation source checks exit 3, without creating adopter outcome files. Exit 5 alone does not distinguish preflight rejection from apply failure: inspect diagnostics and the presence/status of the current run record, without treating a previous result as current. Automation should capture the status and route sanitized diagnostics to authorized notifications when needed. Installation distinguishes required files from directories, so a directory named NOTICE does not pass. Use the matching installer and Python helpers, keeping adopter internal records out of distributions.

v1.17.0以降の配布物は `axiarch-rules/LICENSE` と `axiarch-rules/NOTICE` を保持する。利用先ルートのLICENSE／NOTICEは変更しない。旧導入先では確認済み更新元のスクリプトでdry-runし、中核プロトコルのreview-eachでこの2ファイルを確認・適用する。変更済みまたは比較元不明のコピーは保留されるため、独自の帰属表示を失わないよう差分を判断する。初期導入は配布コピーが欠けた更新元を適用前に拒否する。ソース管理の正本はルートのLICENSE／NOTICEで、CIは配布コピーとの一致を検査する。

Distributions from v1.17.0 retain `axiarch-rules/LICENSE` and `axiarch-rules/NOTICE` without modifying adopter root notices. For older adopters, run a dry-run using the reviewed source's upgrade script, then review and apply these files in the Core Protocol group. Modified or unknown-base copies remain pending for review; retain adopter attribution when resolving differences. Installation rejects sources missing either copy before application. Root LICENSE/NOTICE are the source-maintenance authority; CI checks equality with distributed copies.

| 選択肢 / Choice | 用途 / Purpose |
|:--|:--|
| `preserve（保持・上書きしない）` | `blueprint/core/000_project_overview.md` や `blueprint/core/010_project_lessons_log.md` など、採用先プロジェクト固有状態を維持 |
| `show-diff（差分だけ表示）` | 変更せずに差分だけ確認 |
| `update-all（すべて更新）` | 対象グループ内の変更を適用。利用先の変更・比較元不明は保留し、明示的なuse-axiarchで置換 |
| `review-each（ファイルごとに確認）` | ファイル単位で `keep-local（ローカル版を維持）` / `use-axiarch（Axiarch最新版で置換）` / `merge（3-way mergeを試す）` などを選択 |
| `skip（今回はスキップ）` | 今回は対象外にする |

### 対象範囲 / Scope

- `--lang ja|en|both` で言語フォルダを絞り込み
- `--agent codex|claude|antigravity|cursor|copilot|windsurf|all` でエージェント別ポインターやhookを絞り込み
- `--with-prompts` を付けた場合のみ `axiarch-prompts/` を更新対象に含める
- `--from` / `--from-ref` / `--base-source` は `replace-if-local-unchanged` のbase判定と3-way mergeの両方に使う
- `--yes` は `--apply` の最終確認を省略する。CI等の非対話実行で、直前のdry-run結果を確認し、人間がapply実行を明示承認済みの場合だけ使う / `--yes` skips final confirmation for `--apply`; use only for non-interactive automation after reviewing the dry-run output and after the human owner has explicitly approved apply
- `--apply` または `--interactive` の確認入力で標準入力がEOFになった場合は、既定Nとしてdry-runへ戻す / If confirmation input reaches EOF during `--apply` or `--interactive`, it defaults to N and returns to dry-run behavior
- 不正な `--agent` 値は静かに無視せずエラーにする
- `--apply` しない限り dry-run。dry-run中の3-way merge競合は報告のみで、`.axiarch/conflicts/` には書き込まない
- ディレクトリ更新時、source側に存在しないlocal-onlyファイルは自動削除せず、`STALE-LOCAL` として表示する。`--apply` 時はupgrade reportにも記録し、dry-run時は成果物を書かない
- sourceとtargetでファイル/ディレクトリの型が異なる場合は自動削除・置換せず、`TYPE-CONFLICT` としてreview対象にする。`--apply` 時はupgrade reportにも記録する
- Source Repository Filesは既定でskipする。`--interactive` でユーザーが明示的に `show-diff` / `review-each` / `update-all` を選んだ場合だけ、差分表示や明示適用に進む
- `replace-if-local-unchanged` policyは、target欠落時または `--from` / `--from-ref` / `--base-source` のbaseとtargetが一致する場合のみ自動更新する。baseなし差分、base欠落、base不一致はreason付きでreviewへ倒す
- 番号付きBlueprintは原則Project Stateとして保持する。ただし、manifestに明示されたAxiarch共有Blueprintルールは、README/INDEXのリンク切れを避けるため `Blueprint Templates & Shared Rules（Blueprintテンプレート・共有ルール）` としてレビュー対象に含める。Project Stateの広域globにはmanifestの `exclude` を適用し、明示管理済みのテンプレートや共有Blueprintを二重分類しない
- 反映時は `.axiarch/upgrades/{run_id}/result.json`、`health.log`、`actions.log` と最新の `.axiarch/upgrade-result.json` を記録。旧 `upgrade-report.md` は保持し、新規結果はJSONへ移行。`.axiarch/version.json` の `version` は適用完了・診断成功時だけ進め、保留・競合・失敗では従来の確認済み版数を保持する。source manifest由来の版数は `requestedVersion` に記録し、タグ接頭辞 `v` は正規化する。`.axiarch/files.sha256` は今回適用したファイルの比較元だけを更新する。任意promptも実際に適用したファイルを含む。
- `--apply` 後は対象導入先を明示してhealthを実行し、出力を保存する。診断失敗・診断不可は終了コード4、診断成功でも部分適用は3、適用失敗は5。詳しくはREADMEの更新結果・保証範囲を参照。

Upgrade results use per-run JSON, action/health logs and backups. Legacy reports are retained. Only complete application plus passing diagnosis advances the confirmed version; partial application, failed/unavailable diagnosis and apply failure exit with 3, 4 and 5 respectively. Modified or unknown-base files remain pending unless explicitly replaced. Hash baselines only advance for applied files.

---

## `check-axiarch-health.sh`

### 概要 / Overview

**Axiarch 公式健全性診断ツール**。Hook（導入済みの場合）+ LOADING_PROTOCOL + CRYSTALLIZATION_PROTOCOL + AXIARCH.mdプロトコルのうち**外部検証可能な 10 領域以上**を一発診断する（v1.5.5 で Anti-Full-Overwrite が物理遮断対象に追加、v1.6.0 で sublimated files index 追加、v1.8.0 で Check D Task Boundary Detection 追加、v1.9.0 で PostToolUse diff guard を追加、v1.10.0でAxiarch本体のリリース版メタデータ整合とSafe Upgrade Wizard検査を追加し、現行版ではROADMAP Current Stable、正規AI-facing header、CHANGELOG compare ref、GitHub Actions immutable SHA、署名tag経路、日英相対path・完了release entry、SECURITY private reporting境界も検証、v1.11.0でルートのタスク文書生成、v1.17.0でセッション別タスク記録、ネイティブタスク状態同期検査、Claude Memory正本境界検査を追加）。Claude Code / Codex の hook 設定が存在しない場合は「任意 hook 層が未導入」として扱い、hook 未導入だけを理由に失敗させない。「どこに不整合があるか」を見つけやすくする設計。

The official Axiarch health diagnostic. One-shot 16-stage check covering hook configuration when installed, recorded adherence signals, crystallization threshold (count + time-axis), the verifiable subset of AXIARCH.md protocols, the v1.5.5 physical-block / bootstrap hooks, the v1.6.0 sublimated-files index, the v1.8.0 task-boundary detection wiring, the v1.9.0 PostToolUse diff guard, v1.10.0 release metadata parity and Safe Upgrade Wizard checks including exact ROADMAP Current Stable, canonical AI-facing headers, the CHANGELOG compare ref, immutable GitHub Actions SHAs, signed-tag workflow, exact ja/en relative paths, completed ja/en release entries, and the SECURITY private-reporting boundary, v1.11.0 root task-document generation, v1.17.0 session-specific task records, native task-state sync, ja/en numbered-heading parity, Claude Memory canonical-boundary checks, and Check 16 reminder invariants including Language First, Execution Harness, and the read-only subagent/security-scan delegation boundary. If Claude Code / Codex hook settings are absent, the diagnostic treats the hook layer as optional and not installed rather than failing only on hook absence. `--quiet` flag for pre-commit usage.

言語・mobile・platform統治については、日英`axiarch-rules/{lang}/universal/engineering/320_programming_language_governance.md`、`axiarch-rules/{lang}/universal/engineering/420_react_native.md`、`axiarch-rules/{lang}/universal/engineering/520_cloud_application_platforms.md`、`axiarch-rules/{lang}/universal/engineering/530_azure_cloud.md`のsection数、Rule連番、必須成果、INDEX／README／compliance／公開digest導線、Universal件数を検証する。これらの新設正本がGit追跡外のままrelease候補になることもblockする。Provider profileがSupabase固定SSOT、Firestore一律禁止、全project固定plan、TypeScript固定へ逆戻りしていないことも回帰検査する。

For language, mobile, and platform governance, the diagnostic verifies section counts, consecutive Rule IDs, required outcomes, INDEX/README/compliance/public-digest links, Universal counts, and Git tracking for the ja/en 320, 420, 520, and 530 rules. It blocks a release candidate while a new canonical rule remains untracked, and guards provider profiles against regressions to a fixed Supabase SSOT, universal Firestore prohibition, one billing plan for every project, or TypeScript-only compute.

### 使い方 / Usage

```bash
# カレントディレクトリを診断 / Diagnose current directory
bash axiarch-scripts/check-axiarch-health.sh

# 特定パスを診断 / Diagnose a specific path
bash axiarch-scripts/check-axiarch-health.sh /path/to/project
```

言語設定の読取は起動・文書生成と共通です。コード枠・コメント内の例示を除外し、設定の重複・不明値・読取不能はhealth終了1となります。旧AGENTS.mdと未指定時の言語フォルダによる既定値は維持します。生成時の `AXIARCH_PROCESS_DOC_LANG` はプロジェクト設定の診断を迂回しません。healthの言語診断は設定解決のみで、旧ルート記録・他セッションの文字種を使った適合判定は行いません。詳しくは [タスク状態の実行契約](../axiarch-harness/ja/TASK_STATE_PROTOCOL.md) を参照してください。

Language parsing is shared with startup and document generation. Fenced/commented examples are ignored; duplicates, unknown values and unreadable configuration make health exit 1. Legacy AGENTS.md and folder-based defaults remain supported. `AXIARCH_PROCESS_DOC_LANG` only overrides generation and cannot bypass configuration diagnosis. Health resolves configuration without claiming language compliance from scripts in legacy or other-session documents. See the [task-state contract](../axiarch-harness/en/TASK_STATE_PROTOCOL.md).

コード例とコメントの区別は教訓・参照検査でも共通です。言語設定の書換は値以外の空白・末尾注記・改行を保持し、途中に記法が混ざる曖昧な値では停止します。対応する最上位の設定形式と限界は上記の実行契約に記載しています。

Code/comment boundaries are shared with lesson and reference checks. Language updates preserve whitespace, trailing notes and line endings outside the value, and stop on ambiguous embedded markup. The contracts above define the supported top-level format and its limits.

### 診断項目 / Check Items

本体の開発版（`-dev`）では、installerとmanifestを開発版として突合し、安定版はCHANGELOGの最初の正式版見出しから取得する。ROADMAPの安定版、タグ固定の導入例、llms-fullの安定版欄も照合する。これは履歴上の表記の検査であり、GitHub上の公開状況は別途確認する。

For source development builds (`-dev`), installer and manifest must agree on the build version. The first stable CHANGELOG heading supplies the recorded stable version for ROADMAP, pinned installation examples and the llms-full stable field. This checks declared metadata; GitHub publication status requires a separate check.

| # | カテゴリ / Category | 検証対象 / Target |
|:--|:--|:--|
| 1 | Hook | `.claude/settings.json` または `.codex/hooks.json` の検出（未導入時は任意 hook 層として warn のみ） / Detects hook config; absence is warn-only when hooks are not installed |
| 2 | Hook | JSON 構文 / Syntax validation |
| 3 | Hook | UserPromptSubmit hook 構造 + AXIARCH BOOT marker / Hook structure + marker |
| 4 | Hook | hook層導入時のセッションログ発火履歴（Codex hookのみの場合は構造検査中心） / Firing history when the hook layer is installed; Codex-only hooks use structural validation because Claude JSONL logs do not apply |
| 5 | LOADING_PROTOCOL | 旧ルート `task.md` の履歴形式を参考表示。読了は証明しない / Legacy root history-format hints, not proof of reading |
| 6 | CRYSTALLIZATION_PROTOCOL | インストール済み両言語の中央教訓ログのタグ・件数・経過日検査 / Recorded tags, count and age in both installed lesson logs |
| 7 | AXIARCH Evidence | `task.md` / `implementation_plan.md` / `walkthrough.md` 存在 / Process documentation presence |
| 8 | AXIARCH Release Safety | 選択したGitのブランチ・reflogによる見直し候補 / Selected Git branch and reflog review hints |
| 9 | AXIARCH SSOT | ローカルorigin/mainとの比較。リモートの鮮度は未確認 / Local origin/main comparison; remote freshness unassessed |
| 10 | AXIARCH Language | 起動・生成と共通の設定解決。文章の言語・意味は未確認 / Shared configuration resolver; document language and meaning unassessed |
| 11 | AXIARCH Anti-Full-Overwrite | PreToolUse宣言の照合。実際の拒否動作は別検証 / PreToolUse declaration matching; runtime rejection is a separate test — **v1.5.5+** |
| 12 | Bootstrap | SessionStart hook 配線確認 / SessionStart hook wiring — **v1.5.5+** |
| 13 | Sublimated Index | 既存の `axiarch-rules/{lang}/blueprint/{domain}/{NNN}_*.md` を一覧表示し APPEND を促進 / Lists existing sublimated files to promote APPEND — **v1.6.0+** |
| 14 | Task Boundary | Check D wiring 確認（`axiarch-boot-reminder.sh` に LOAD REVIEW + AXIARCH_TASK_BOUNDARY_DETECT 含有を確認） / Verifies Check D wiring in `axiarch-boot-reminder.sh` — **v1.8.0+** |
| 15 | v1.9+ / v1.11+ Integration | hook層導入時のPostToolUse diff guard 配線確認（`axiarch-diff-guard.sh` + Edit / MultiEdit / Write matcher）+ セッション別タスク記録（`axiarch-task-state.sh`）+ Codex `update_plan` / Claude Code Task tools のネイティブ状態同期説明 + Axiarch本体リポジトリでのみsource repository docs / indexes反映確認 + ハーネスエンジニアリング入口保持確認 + ja/en相対path・番号見出しparity確認 + SECURITY private reporting境界 + Claude Memory正本境界確認 + AXIARCH.md・axiarch-harness・中核ファイルのGit追跡確認 + AXIARCH.md mixed/review所有境界確認 + CHANGELOGのUnreleased参照整合 + リリース版メタデータ整合 + ROADMAP Current Stable・正規AI-facing header・CHANGELOG compare ref・Actions immutable SHA厳密一致・署名tag経路・日英完了release entry + Safe Upgrade Wizard検査 / Verifies PostToolUse diff guard wiring, session-specific task records (`axiarch-task-state.sh`), native state-sync wording for Codex `update_plan` and Claude Code Task tools, source repository docs/index integration, Harness Engineering entrypoint retention, ja/en relative-path and numbered-heading parity, the SECURITY private-reporting boundary, Claude Memory canonical boundary, Git tracking for AXIARCH.md, axiarch-harness, and core files, AXIARCH.md mixed/review ownership boundary, CHANGELOG reference parity, release metadata parity with exact ROADMAP Current Stable, canonical AI-facing headers, the CHANGELOG compare ref, immutable Actions SHAs, the signed-tag path, and completed ja/en release entries, and Safe Upgrade Wizard checks — **v1.9.0+ / v1.11.0** |
| 16 | Reminder | Language First・ハーネス・読取専用委任の補足文言。実際のロードは別確認 / Reminder wording for Language First, harness and read-only delegation; actual loading requires separate evidence |

### 環境変数 / Environment Variables（v1.6.0+, extended in v1.8.0+）

| 変数 / Variable | デフォルト / Default | 説明 / Description |
|:--|:--:|:--|
| `AXIARCH_REMINDER_TTL_SECONDS` | `1800` (30 分) | `axiarch-boot-reminder.sh` の short-circuit TTL。`0` で disable / Two-stage reminder TTL; `0` disables short-circuit |
| `AXIARCH_LESSON_STALE_DAYS` | `180` | Check 6 (b) / Check C の time-axis trigger 閾値（日数）。`0` で disable / Time-axis trigger threshold; `0` disables Check C |
| `AXIARCH_PRECOMMIT_SKIP` | unset | `1` をセットすると pre-commit hook を 1 回だけ bypass / Set to `1` to bypass the pre-commit hook for one commit |
| **`AXIARCH_TASK_BOUNDARY_DETECT`** | **`1`** | **v1.8.0+: `0` で Check D Task Boundary Detection を完全 disable（v1.6.0 動作再現）/ Set to `0` to fully disable Check D task-boundary detection (reproduces v1.6.0 behaviour)** |
| **`AXIARCH_TASK_DOMAIN_KEYWORDS`** | (組込 default 集合) | **v1.8.0+: Check D の domain keyword 集合をオーバーライド（pipe-separated regex, 採用先カスタマイズ用）/ Override Check D's domain keyword set (pipe-separated regex; for adopter customisation)** |
| `AXIARCH_DIFF_GUARD_MODE` | `warn` | v1.9.0: diff guard の動作。`warn` / `block` / `off` / Diff guard mode |
| `AXIARCH_DIFF_GUARD_MAX_LINES` | `400` | v1.9.0: 追加+削除行数の閾値 / Added plus deleted line threshold |
| `AXIARCH_DIFF_GUARD_MAX_FILES` | `20` | v1.9.0: 変更ファイル数の閾値 / Changed file threshold |
| `AXIARCH_DIFF_GUARD_INCLUDE_UNTRACKED` | `1` | v1.9.0: untracked files を閾値計算に含める / Include untracked files in threshold calculation |
| `AXIARCH_DIFF_GUARD_ALLOW` | unset | v1.9.0: `1` を設定した呼出しでdiff guardをbypass / Bypass diff guard while set to `1` |

### Out of Scope（外部検証困難・人間レビュー必須） / Manual Review Required

`AXIARCH.md` §7.1（AI自己完結）、§7.3（DB整合性）、§7.5（既存機能保護）、§7.9（役割・振る舞い）は意味的判断を含み、自動診断だけでは遵守を確認できません。§7.6（差分編集と全文上書き禁止）は、対応するPreToolUse hookが起動する場合に既存ファイルへの `Write` を拒否します（Check 11）。

`AXIARCH.md` sections 7.1, 7.3, 7.5 and 7.9 require semantic review; diagnostics alone cannot establish compliance. For section 7.6, the configured PreToolUse hook rejects `Write` to existing files when the supporting hook runs (Check 11).

### Exit Code

- `0` — ブロッキング失敗なし。警告はAIが確認可能な証拠を調べ、アクセスできない情報や承認など人間の判断が必要な事項だけを確認する / No blocking automated failures. The agent investigates accessible warning evidence and asks only about inaccessible information or decisions reserved for the owner
- `1` — 構造・診断失敗または指定phase不成立 / Structural, diagnostic or requested-phase failure

### Git診断の範囲 / Git observation scope

Check 8・9と本体の追跡確認は、引き継いだ `GIT_` 環境上書きやglobal/system設定を診断から切り離し、指定した作業ツリーを確認する。ブランチ・reflog・参照・件数の取得失敗を空文字や0件へ置き換えず、`GIT UNASSESSED` と終了1を返す。Git管理外、ローカル `origin/main` の未作成、初回コミット前は検査対象外の範囲を説明し、それだけでは失敗にしない。detached HEADを機能ブランチと表示しない。

Checks 8/9 and source tracking checks isolate inherited `GIT_` overrides and global/system configuration, and inspect the selected worktree. Failed branch, reflog, reference or count queries produce `GIT UNASSESSED` and exit 1, never fabricated empty/zero results. A non-Git project, absent local `origin/main`, or an unborn branch is explicitly scoped out without failing solely for that reason. Detached HEAD is not reported as a feature branch.

reflogの文言は完全なpush履歴や承認証拠ではなく、`origin/main` は取得済みのローカル参照である。診断はfetch・pullを実行せず、リモートの最新状態や承認の有無を保証しない。Git呼出しではfsmonitor・任意のindex更新・不足オブジェクトの自動取得を抑止する。`--no-lazy-fetch` に非対応のGit、壊れたworktree設定等で既存リポジトリを調べられない場合は診断失敗となる。通常のGit設定ファイルは変更しない。

Reflog messages are neither complete push history nor approval evidence; `origin/main` is a locally fetched reference. Diagnostics do not fetch/pull or establish remote freshness or authorization. Git observation suppresses fsmonitor, optional index writes and lazy object downloads. An existing repository that cannot be inspected, including Git without `--no-lazy-fetch` or broken worktree configuration, fails diagnostics. Ordinary Git configuration files are not changed.

---

## `axiarch-boot-reminder.sh`

### 概要 / Overview

`.claude/settings.json` または `.codex/hooks.json` の `UserPromptSubmit` hook から呼ばれる外出しスクリプト。毎ターン記録上の見直し候補を確認し、reminderへ補足する。候補の検知は未読や違反の証明ではない：

- **Check A**: 解決済みセッションの `.axiarch/sessions/{session_id}/task.md` に識別可能なロード履歴行がない場合の見直し候補。未読を断定しない
- **Check B / C**: `axiarch-rules/{lang}/blueprint/core/010_project_lessons_log.md` の実教訓の件数・経過日等を調べる。閾値は分類・昇華の見直し候補であり、違反の証明ではない

Check Dは `axiarch-scripts/axiarch_scope.py` の既知の日英語彙で、現在の依頼と解決済みセッションの3文書を照合します。例えば「認証」と `authentication` を同じラベルとして扱い、全角英数字も正規化するため、表記や言語の切替だけを新しい話題にしにくくします。全言語の意味理解ではなく、登録されていない言い換え・否定・文脈は判断できません。候補が出た場合だけ実タスクとの関連を確認し、不要なルール読込やユーザーへの確認を要求しないでください。

Check D uses known Japanese/English aliases in `axiarch-scripts/axiarch_scope.py` to compare the current request with the resolved session's three documents. Equivalent terms such as the Japanese word for authentication and `authentication` share a label, and fullwidth Latin characters are normalized. Changing language or notation alone is therefore less likely to produce a new-topic hint. This is not semantic understanding across languages: unlisted paraphrases, negation and context remain unassessed. Review relevance to the actual task rather than demanding unnecessary rule loading or user checks.

`AXIARCH_TASK_BOUNDARY_DETECT=0` でこの補助検査を無効化できます。`AXIARCH_TASK_DOMAIN_KEYWORDS` を指定すると既定語彙を置換し、従来どおりgrepのPOSIX拡張正規表現・単語境界で照合します（例: `client-[[:digit:]]+`）。独自パターンの一致内容には個人情報が含まれうるため、通知には値や依頼本文を出しません。不正な式、検査の時間切れ、解決済み文書のリンク・特殊ファイル・読取不能、補助ファイル欠落は `SCOPE REVIEW UNASSESSED` とし、TTL内でも完全な補足を表示します。フック自体は警告として終了0を保ちます。記録未作成のH0に文書を要求せず、共有ルート文書を別セッションの証拠として使いません。

Set `AXIARCH_TASK_BOUNDARY_DETECT=0` to disable this optional hint. `AXIARCH_TASK_DOMAIN_KEYWORDS` replaces the built-in aliases and retains grep's POSIX extended regular expressions and word boundaries, for example `client-[[:digit:]]+`. Custom matches can contain personal data, so notifications do not echo matched values or prompt text. Invalid expressions, inspection timeouts, linked/special/unreadable resolved documents or a missing helper produce `SCOPE REVIEW UNASSESSED` and force the full reminder even within the TTL. The hook remains a non-blocking warning with exit 0. H0 work without records does not require documents, and shared root documents are not borrowed as another session's evidence.

更新は `axiarch-scripts/` 一式で適用します。healthは `axiarch_scope.py` の欠落を診断失敗とし、フックは既存文書や独自設定を自動修復しません。語彙の候補一致やhealth成功を、読了・意味理解・作業完了の証明には使いません。

Update the complete `axiarch-scripts/` bundle. Health reports a missing `axiarch_scope.py` as a diagnostic failure; hooks do not repair existing documents or custom settings automatically. Keyword matches and passing health checks do not prove reading, understanding or task completion.

Checks A/D use the resolved session; B/C inspect actual entries in installed lesson logs. Missing history rows or threshold matches prompt review rather than proving missed reading or a protocol violation.

既存セッションのbindingや共有状態が解決できない場合は `TASK STATE WARNING` として完全な補足を表示します。未記録のH0とは区別し、任意の語彙検知を無効化しても異常を隠しません。記録を自動修復せず、過去の証拠の参照を現在の完了判定と混同しません。復旧とCLIの契約は [記録先の確認](../axiarch-harness/ja/TASK_STATE_PROTOCOL.md#構造化レコード) を参照してください。更新はscripts一式で適用します。

An unresolved binding or shared state for an existing session produces `TASK STATE WARNING` and the full reminder. This is distinct from unrecorded H0 work; disabling optional keyword hints does not hide the anomaly. Records are not repaired automatically, and locating historical evidence is not a current completion claim. See [record location checks](../axiarch-harness/en/TASK_STATE_PROTOCOL.md#structured-record) for recovery and the CLI contract. Apply updates as a complete scripts bundle.

入力とJSON応答はPython 3の共通補助 `axiarch-scripts/axiarch_hook.py` で処理します。jqなしでもUnicodeエスケープと長文を同じように解析します。解析失敗は見直し警告であり、未読や手順違反の証明とは扱いません。既存Writeの拒否とは異なり、この補足フックは終了0で情報を返します。

Input and context JSON use the Python 3 helper `axiarch-scripts/axiarch_hook.py`. Unicode escapes and long prompts are decoded consistently without jq. Parsing failures produce review warnings, not proof of missed reading or rule violations. This informational hook returns exit 0; the existing-file Write guard has a separate blocking contract.

表示間隔は0–2147483647秒の10進整数で、先頭の0も10進として扱います。0は短縮を無効化。不正な値、読めないキャッシュ、リンク・FIFO等では完全な補足を返します。キャッシュは所有者を確認した通常ファイルだけ読み、一時ファイルから原子的に更新します。プロジェクトとセッション別の一時キャッシュは作業状態や読了の証拠ではなく、削除しても次の補足が完全表示になるだけです。

TTL is a decimal integer from 0 to 2147483647 seconds, including leading zeros; 0 disables shortening. Invalid values, inaccessible caches, links or FIFOs fall back to full context. Only owner-checked regular files are read, and writes use an atomic temporary-file replacement. This project/session cache controls verbosity only; deleting it merely causes a full reminder, and it never proves loading or task completion.

「完全な補足」はAxiarchのTTL短縮を行わず生成する本文を指し、製品側の全文受領を意味しません。受領が不明な場合は [補足の受領確認](#補足の受領確認--checking-reminder-delivery) に従います。

A full reminder means the text generated without Axiarch's TTL shortening; it does not establish complete delivery by the product. Follow [delivery checks](#補足の受領確認--checking-reminder-delivery) when receipt is uncertain.

### 使い方 / Usage

直接実行する用途は通常なし（hook 経由で自動呼出）。デバッグ時のみ：

```bash
bash axiarch-scripts/axiarch-boot-reminder.sh | jq .
# → hookSpecificOutput.additionalContext に reminder + 見直し候補
```

### 仕組み / Mechanism

1. `CLAUDE_PROJECT_DIR` または相対パスからプロジェクトルートを解決
2. 静的 base reminder（バイリンガル）を組み立て
3. 選択セッションのCheck AとD、導入済み言語の教訓Check BとCを実行
4. 見直し候補を検出した場合は base reminder に追記。未確認を違反確定や読了の証明として扱わない
5. JSON 形式で `printf` 出力

---

## `axiarch-protect-antifull.sh`

### 概要 / Overview

`.claude/settings.json` または `.codex/hooks.json` の `PreToolUse` hook（Claude: `Write`、Codex: `apply_patch`）から呼ばれるスクリプト。対応runtimeがhookを呼び出して結果を尊重する場合、既存ファイルへの `Write` を `decision:"block"` JSON + exit code 2 で拒否する。Shell・Edit・外部APIによる変更はこのhookの対象外である。

A PreToolUse hook script invoked from `.claude/settings.json` or `.codex/hooks.json`. When the runtime invokes and honors the hook, existing-file `Write` calls are rejected with decision:"block" JSON and exit 2. Shell, Edit and external API changes are outside this hook's scope.

Python 3でJSONを解釈し、jqの有無に左右されず引用符・日本語・改行を含むパスを扱います。不正JSON、重複キー、Writeのパス欠落、Python 3不足は終了2で停止し、許可とは扱いません。通常の新規作成とWrite/apply_patch以外の正しいイベントは許可します。この判定は呼び出されたフックの入力に対するもので、全操作の安全性の保証ではありません。

Python 3 decodes JSON consistently with or without jq, including quoted, Unicode and newline-containing paths. Malformed JSON, duplicate keys, a missing Write path or unavailable Python 3 stop with exit 2 rather than granting permission. Ordinary new-file creation and valid non-Write/non-apply_patch events pass. The decision applies only to the supplied hook event, not all-operation safety.

入力は `axiarch-scripts/axiarch_hook.py` と `axiarch-scripts/axiarch_state.py` でBashへの格納前に検証します。生のNUL文字を含む不正JSONが、取り込み時に変形されて許可されることを避けます。補助ファイルが欠落した場合も終了2です。Writeフックもscripts一式で更新してください。

`axiarch-scripts/axiarch_hook.py` and `axiarch-scripts/axiarch_state.py` validate raw input before Bash stores it, so invalid JSON containing raw NUL bytes is not silently repaired and allowed. Missing helpers also return exit 2. Update the Write guard with the complete scripts bundle.

Claudeのネイティブ `PreToolUse` / `Write` は、ローカル設定の有無によらずClaudeの許可リストだけを使います。イベント名が不正・別イベントの場合、既存ファイルの置換を終了2で拒否し、入力値を通知へ転載しません。イベント名を持たない旧呼び出しも、Claude設定・Claude許可リスト（壊れたリンク等を含む）または明示した `AXIARCH_HOOK_AGENT=claude` があればClaudeを選びます。継承した `AXIARCH_HOOK_AGENT=codex` でこの選択を置き換えません。これらがすべてない旧単独Write呼び出しに限り、Codex許可リストfallbackを保持します。

Native Claude `PreToolUse` / `Write` uses only the Claude allowlist even without local settings. An invalid or different event name rejects an existing-file replacement with exit 2 without echoing the supplied value. Legacy calls without an event name also select Claude when Claude settings, a Claude allowlist (including damaged links), or explicit `AXIARCH_HOOK_AGENT=claude` exists. An inherited `AXIARCH_HOOK_AGENT=codex` cannot replace that selection. The Codex fallback remains only for standalone legacy Write calls without any of that Claude context.

Codexの `apply_patch` は既存の新規作成・移動先を拒否し、通常のUpdate File差分を許可します。delete/addの組み合わせも適用前の実体と突合します。未知のpatch形式は終了2です。専用のCodex許可リストを使い、Claudeの例外は流用しません。詳しい契約は [エージェント互換性](AGENT_COMPATIBILITY.md) を参照してください。

Codex `apply_patch` checks add/move destinations against the original filesystem, including delete/add pairs, and permits ordinary Update File diffs. Unknown syntax exits 2. It uses the Codex allowlist without borrowing Claude exceptions. See [agent compatibility](AGENT_COMPATIBILITY.md).

旧呼び出しでCodexのリストをClaudeにも流用していた場合は、承認済みの対象を確認し、Claude側の通常ファイルへ必要な項目だけ設定します。環境変数自体は上書き承認の証拠ではありません。修正は `axiarch-scripts/` 一式で反映し、既存リストの自動コピー・移動・削除は行いません。新規作成や通常の差分編集には上書き例外を要求しません。

If a legacy caller borrowed Codex entries for Claude, review the approved scope and configure only the necessary entries in a regular Claude allowlist. An environment hint is not evidence of overwrite approval. Apply the complete `axiarch-scripts/` bundle; existing lists are not automatically copied, moved or deleted. New-file creation and ordinary focused edits need no overwrite exception.

### Whitelist サポート / Whitelist Support

`.claude/axiarch-overwrite-allow.txt` または `.codex/axiarch-overwrite-allow.txt` で 1 行 1 path/glob 形式で whitelist を定義可能（自動生成 build artefact 等の正当な full-overwrite 用 escape hatch）。コメント (`#`) と空行はスキップ。

`.claude/axiarch-overwrite-allow.txt` or `.codex/axiarch-overwrite-allow.txt` supports one-path-per-line glob whitelist (escape hatch for legitimate full-overwrite cases like autogenerated artefacts). Comments (`#`) and empty lines are skipped.

許可リストは任意です。使う場合は、親フォルダを含めシンボリックリンクでない場所に、実行ユーザー所有・ハードリンクなしの通常ファイルを配置します。UTF-8のLF/CRLF形式を使い、NULを含めないでください。既存宛先の置換時に全内容を読み取り、不正・読み取り不能なら例外を許可せず、内容を出力しない日英のエラーと終了2を返します。不正なClaudeのリストをCodexの例外で補いません。例外を必要としない新規作成・通常の差分編集は維持します。ClaudeのWriteはBash glob、Codexのapply_patchはPython fnmatchで照合するため、Bash固有の文字クラスはCodexへ流用できません。

Allowlists are optional. When used, keep them in a location without symlinks, including parent directories, as regular files owned by the executing user with no hardlinks. Use UTF-8 with LF/CRLF and no NUL bytes. Before replacing an existing destination, the guard reads the complete list; invalid or unreadable lists grant no exception and produce a bilingual error with exit 2 without printing their contents. A damaged Claude list does not borrow Codex exceptions. New-file creation and ordinary focused edits require no exception and remain available. Claude Write matches Bash globs; Codex apply_patch uses Python fnmatch, so Bash-specific character classes are not portable to Codex.

従来リンクで共有していた許可リストは、承認済みの対象と内容を確認して、使用する各製品の通常ファイルへ移します。親フォルダがリンクの場合は、その設定配置も確認してください。更新やフックは既存リストを自動削除・置換・権限変更しません。変更が必要な場合も、現在の承認範囲を確認し、不足する場合だけ承認を求めます。適用前の確認であり、同一ユーザーの別プロセスによる同時変更や、全操作の安全性を保証する仕組みではありません。

If an older installation shares a list through links, review its approved scope and contents and migrate it to a regular file for each selected agent. Review configuration placement when a parent directory is linked. Upgrade and hooks do not automatically delete, replace or change permissions on existing lists. Check the current authorization scope for required changes and request approval only when it is missing. These pre-operation checks do not guarantee protection from concurrent changes by another same-user process or the safety of every operation.

相対パスのパターンは実体のプロジェクトルートを基準にします。既存判定はリンクと `..` の実際のファイルシステム上の解決順序に従い、壊れたリンクも既存として拒否します。例外パターンはリンクを解決した実体パスと照合するため、許可フォルダから外部を指すリンクは外部の許可にはなりません。絶対パターンも実体パスで指定してください。改行を含む例外パターンは1行1項目の形式では指定できません。判定から実際の書込までに他プロセスがパスを変更する競合は、このフックだけでは防げません。

Relative patterns use the physical project root. Existence checks follow filesystem resolution order for symlinks and `..`; broken symlinks also count as existing. Exception patterns match the resolved physical path, so a link from an allowed directory to an external file does not grant external permission. Absolute patterns must also name physical paths. Newline-containing exception patterns cannot be represented in this line-based format. This hook alone cannot prevent another process from changing the path between the check and the actual write.

### 使い方 / Usage

直接実行する用途は通常なし（hook 経由で自動呼出）。デバッグ時のみ：

```bash
echo '{"tool_name":"Write","tool_input":{"file_path":"/existing/file.md"}}' \
  | bash axiarch-scripts/axiarch-protect-antifull.sh
# → JSON `{"decision":"block",...}` + stderr message + exit 2
```

### 関連研究と評価範囲 / Related Research and Evaluation Scope

- [AgentSpec](https://arxiv.org/abs/2503.18666) は、構造化した制約を実行時に適用する別の実装を評価した研究です。その数値はAxiarchの性能や安全性の実測ではありません。
- [Control Illusion](https://arxiv.org/abs/2502.15851) は、指示の優先順位をモデルが一貫して守れるかを評価した研究です。Axiarchのリマインダーやフックを直接比較した試験ではありません。

AgentSpec evaluates a separate implementation of runtime constraints; its results are not measurements of Axiarch performance or safety. Control Illusion evaluates instruction prioritization, not a direct comparison of Axiarch reminders and hooks. These studies inform the design rationale; Axiarch's own evidence is limited to the documented tests and operational observations.

---

## `axiarch-diff-guard.sh`

### 概要 / Overview

`.claude/settings.json` または `.codex/hooks.json` の `PostToolUse` hook から呼ばれる外出しスクリプト。Python 3と同梱の `axiarch-scripts/axiarch_diff.py` を使い、`Edit` / `MultiEdit` / `Write` 後に作業ツリーとHEADの差分、および未追跡ファイルを測定する。初回コミット前は空のツリーと比較し、ステージ済みの新規ファイルも含む。リポジトリ内のサブフォルダから呼んだ場合もリポジトリ全体を測る。閾値超過時はwarnで通知（終了0）、blockで停止要求（終了2）を返す。

Externalized PostToolUse hook invoked from `.claude/settings.json` or `.codex/hooks.json`. It requires Python 3 and the bundled `axiarch-scripts/axiarch_diff.py`. After `Edit`, `MultiEdit`, or `Write`, it measures the working tree against HEAD plus untracked files. An unborn branch is compared with the empty tree, including staged additions. Invocation from a subdirectory still measures the entire repository. Above thresholds, warn emits a notice (exit 0); block requests a pause (exit 2).

計測失敗、Git対象外、補助の欠落、不正設定は `DIFF GUARD UNASSESSED` として同じmodeの通知・停止要求へ進み、小差分として成功扱いしない。Git呼出しは各10秒で打ち切り、external diff・textconv・fsmonitorの設定プログラムを実行しない。閾値は1〜10桁の十進数0〜2147483647で、先頭ゼロを許可する。未追跡ファイルは末尾改行がない最終行も数え、NULを含むバイナリは行数0・ファイル数1とする。リンクは切れたものもファイル数1・行数0で、リンク先やリンクに置き換わった親フォルダの内容を読まない。名前変更検出を無効にし、移動は削除と追加の2ファイルとして数える。

Measurement failure, a non-repository, missing helpers or invalid settings produce `DIFF GUARD UNASSESSED` using the same mode; they are not successful small-diff results. Each Git call has a 10-second timeout; configured external diff, textconv and fsmonitor programs are disabled. Thresholds accept 1–10 decimal digits from 0 to 2147483647, including leading zeros. Untracked text counts an unterminated final line; NUL-containing binary data contributes zero lines and one file. Symlinks, including dangling links, contribute one file and zero lines without reading their targets or replaced parent links. Rename detection is disabled, so a move counts as deletion and addition of two files.

診断用Gitは、呼出し元の `GIT_DIR`・`GIT_WORK_TREE`・`GIT_INDEX_FILE` 等の `GIT_` 環境上書きとglobal/system設定を使わず、指定フォルダが属する実作業ツリーを検査する。通常のlinked worktreeはそのworktreeのindexを使用する。解決された作業ツリーの外に指定フォルダがある場合は未確認とする。local設定・include・worktree設定にある `filter.<driver>.clean/smudge/process/required` のキーを列挙し、診断プロセス内だけ無効化する。列挙できなければdiffへ進まず、コマンド本文は出力しない。元の設定・index・作業ファイルは変更しない。

Diagnostic Git discards inherited `GIT_` overrides such as `GIT_DIR`, `GIT_WORK_TREE` and `GIT_INDEX_FILE`, and excludes global/system configuration. It inspects the actual worktree containing the selected directory, using a linked worktree's own index. A selected directory outside the resolved worktree is unassessed. It inventories `filter.<driver>.clean/smudge/process/required` keys from local, included and worktree configuration, then disables them only for the diagnostic subprocess. Inventory failure stops before diff; command values are not printed. Original configuration, indexes and work files are retained.

外部変換を行わないため、Git LFS等のフィルターを使う環境やglobal設定に依存する環境では、通常のGit表示と件数が異なる場合がある。これは変更量の目安であり、フィルター適用後の内容比較ではない。`--no-lazy-fetch` により不足オブジェクトを自動取得せず、欠落は未確認とする。このオプションに非対応のGitも未確認となるため、利用する環境で単体確認する。通常のGit操作やダウンロード設定自体は変更しない。仕組みの参照先は [Gitのフィルター仕様](https://git-scm.com/docs/gitattributes) と [Gitの実行オプション](https://git-scm.com/docs/git)。

With external conversion disabled, counts can differ from ordinary Git output in repositories using filters such as Git LFS or relying on global configuration. Counts estimate change size, not post-filter content equivalence. `--no-lazy-fetch` prevents on-demand object downloads; missing objects or Git versions without that option produce an unassessed result. Verify the standalone hook in the adopter environment. Ordinary Git operations and download settings are unchanged. See [Git filter documentation](https://git-scm.com/docs/gitattributes) and [Git execution options](https://git-scm.com/docs/git).

この事後通知は適用済み編集を取り消さない。停止要求の扱いは呼出し側に依存し、次の全操作の遮断を保証しない。Gitの除外・属性・index設定、バイナリ、submodule、並行編集などにより観測範囲に限界があり、行数は変更内容の安全性・意味・ロード完了の証拠ではない。未追跡の通常ファイルは順次読み取るため、大きなファイル集合の総処理時間に上限は設けていない。対応する停止要求をAIが確認し、解決済みセッション記録へ範囲・検証方針を反映する。

Post-use notices do not undo applied edits. How pause requests are handled depends on the caller; blocking every subsequent operation is not guaranteed. Git exclusions, attributes, index flags, binary data, submodules and concurrent edits limit observation. Counts do not establish safety, meaning or completed loading. Untracked regular files are streamed; total processing time for a large file set is not bounded. The agent must review the notice and update scope and verification in its resolved session records.

旧導入先ではShellだけを単独コピーせず、対応する `axiarch-scripts/` 一式を更新する。新しい補助はmanifestのscriptsグループに含まれ、導入前検査とhealthで存在を確認する。利用先で変更したスクリプトは既存の更新方針どおり保留・個別レビューとなる。

Existing adopters should update the matching `axiarch-scripts/` bundle rather than copying only the shell wrapper. The manifest scripts group includes the helper; installation preflight and health check its presence. Locally modified scripts retain the existing hold-and-review update policy.

### 使い方 / Usage

通常はhook経由で自動実行される。単体確認では閾値を低くして実行する。

```bash
AXIARCH_DIFF_GUARD_MAX_LINES=1 \
AXIARCH_DIFF_GUARD_MAX_FILES=1 \
bash axiarch-scripts/axiarch-diff-guard.sh
```

### 環境変数 / Environment Variables

| 変数 / Variable | デフォルト / Default | 説明 / Description |
|:--|:--:|:--|
| `AXIARCH_DIFF_GUARD_MODE` | `warn` | `warn`、`block`、`off` を選択 / Select warn, block, or off |
| `AXIARCH_DIFF_GUARD_MAX_LINES` | `400` | 追加+削除行数の閾値 / Added plus deleted line threshold |
| `AXIARCH_DIFF_GUARD_MAX_FILES` | `20` | 変更ファイル数の閾値 / Changed file threshold |
| `AXIARCH_DIFF_GUARD_INCLUDE_UNTRACKED` | `1` | untracked files を含める / Include untracked files |
| `AXIARCH_DIFF_GUARD_ALLOW` | unset | `1` が設定された呼出しをbypass。exportを残すと継続する / Bypasses each invocation while set to `1`; unset an exported value after use |

---

## hook宣言の静的検査 / Static hook declaration checks

hook宣言の検査基盤はv1.17.0で導入しました。以下はv1.18.0の製品別起動条件の修正を含む現行仕様です。healthは `axiarch-scripts/axiarch_inspect.py --mode hooks` を使い、Check 3・11・12・15で両方の導入済み設定を検査します。イベント、対象操作、`type=command`、同期の呼出し先を同じ宣言内で結び付けます。独自hookが先頭にあっても、その後のAxiarch宣言を確認します。両設定がない場合は任意層の未導入として扱います。

Hook declaration checking was introduced in v1.17.0. The following describes current behavior, including v1.18.0 agent-specific startup-source fixes. Health uses `axiarch-scripts/axiarch_inspect.py --mode hooks` in Checks 3, 11, 12 and 15 for both installed configurations. Each event, matched operation, `type=command` and synchronous script invocation must belong to the same declaration. Additional hooks before Axiarch hooks do not hide them. If neither configuration exists, the optional layer is treated as not installed.

対応する形式は、配布スクリプトの直接実行または `bash` による単一スクリプト呼出し（shell文字列またはcommandとargsの形式）です。対象操作は省略・空・全件指定、単純な名前と `|` の組合せ、これらを括弧やアンカーで囲んだ形式を確認します。SessionStartはCodexではstartup・resume・clear・compact、Claude Codeではこれらにforkを加えた宣言を確認します。複雑な正規表現、inline処理、独自wrapper、条件付き・非同期の必須呼出しは、実行して確かめず未確認とします。

Supported forms are a direct bundled-script invocation or a single script invoked through `bash`, either a shell string or command plus args. Matchers support omitted/empty/all forms, simple names separated by `|`, and grouped or anchored versions of those names. SessionStart declarations cover startup, resume, clear and compact for Codex; Claude Code additionally requires fork. Complex regex, inline code, custom wrappers, conditional or asynchronous required calls remain unassessed; the diagnostic never runs them to find out what they do.

起動条件は2026-09-14時点の [Codex公式仕様](https://learn.chatgpt.com/docs/hooks) と [Claude Code公式仕様](https://code.claude.com/docs/en/hooks) に対応します。診断スクリプトを更新すると製品別の判定になります。既定の全件指定は引き続き有効で、既存の独自matcherを書き換える必要はありません。

Startup sources follow the [Codex reference](https://learn.chatgpt.com/docs/hooks) and [Claude Code reference](https://code.claude.com/docs/en/hooks) reviewed on 2026-09-14. Updating the diagnostic script applies the product-specific checks. Default match-all declarations remain valid; existing custom matchers do not need to be rewritten.

必要な宣言の欠落、`disableAllHooks`、未確認形式はhealthの非0終了へ接続します。JSONや独自設定を自動修正・削除しません。旧inline設定やwrapper利用先では、実際の呼出しをレビューして配布形式と整合させるか、未確認を残した追加証拠を別途用意してください。診断を通すために独自設定を無条件で置換してはなりません。hook宣言の検査にjqは不要で、他の診断項目の依存条件は変わりません。

Missing required declarations, `disableAllHooks` and unassessed forms produce a nonzero health result. JSON and custom settings are never automatically changed or removed. For legacy inline hooks or wrappers, review the actual invocation and reconcile it with the supported form, or retain the unassessed result alongside separate evidence. Do not blindly replace custom settings to make the diagnostic pass. Hook declaration checks do not require jq; other checks retain their existing dependencies.

この検査はプロジェクト内の2設定ファイルだけが対象です。ユーザー設定・管理ポリシー・CLI上書き・実行環境の採用状況や起動後の発火は評価しません。非同期hookは処理の遮断に使えず、設定の優先順位も実動作へ影響するため、宣言の合格を実動作・安全性の保証としません。[Claude Code公式仕様](https://code.claude.com/docs/en/hooks)

Only the two project configuration files are inspected. User settings, managed policy, CLI overrides, runtime adoption and actual firing are outside this check. Async hooks cannot block an action, and settings precedence affects runtime behavior, so a declaration pass is not proof of execution or safety. See the [Claude Code reference](https://code.claude.com/docs/en/hooks). Other agents remain unverified compatibility candidates.

## 補足の受領確認 / Checking reminder delivery

設定の存在、スクリプトのJSON出力、製品側の受領、AIによる正本の実読込は別の確認対象です。healthや単独実行の終了0を、後続のすべての確認の代わりにしません。次は2026-09-14時点の公式仕様との照合であり、製品UI・認証済みモデル推論を含む実証ではありません。

Configuration presence, JSON emitted by a script, product delivery and the agent's actual reading of canonical files are separate checks. Neither health nor a standalone exit 0 establishes all of them. The following reflects official documentation reviewed on 2026-09-14, not product-UI or authenticated-model validation.

| 製品 / Product | 確認点 / Check |
|---|---|
| Codex | 長いhook出力は保存先付きの短い表示へ置き換わる場合がある。案内された保存先が利用できる場合だけ内容を確認する。上限変更・無制限化で読了を代用しない / Large output may become a shortened preview with a saved-file reference. Inspect that file when available; changing or removing limits does not establish reading. [公式仕様 / Reference](https://learn.chatgpt.com/docs/hooks#large-hook-output) |
| Claude Code | 同期のUserPromptSubmit command hookが時間切れになると、出力が破棄されても依頼は処理されうる。対象イベントの診断ログで発火・終了・受領を確認する / A timed-out synchronous UserPromptSubmit command hook can lose its output while the prompt continues. Inspect diagnostics for that event's invocation, completion and delivery. [公式仕様 / Reference](https://code.claude.com/docs/en/hooks#userpromptsubmit) |
| Antigravity | 現行の配布入口は `.agents/rules/prompt_pointer.md`。Rulesで適用状態を確認し、指示先のルート `AXIARCH.md` を実際に読む。他製品用hookの成功を受領証拠にしない / Check the distributed pointer's activation in Rules and actually read root `AXIARCH.md`; another product's hook success is not delivery evidence. [公式仕様 / Reference](https://antigravity.google/docs/ide/rules/) |

受領を確認できない場合、AIは対象の製品・作業先・セッション・イベントに範囲を絞り、取得可能な設定と診断を自ら調べます。会話やログ全体を無加工で転載・外部送信せず、確認した範囲と未確認の理由を記録します。実装前の必要な正本は直接読み、既存記録は [TASK_STATE_PROTOCOL.md](../axiarch-harness/ja/TASK_STATE_PROTOCOL.md) の読み取り専用 `--mode path --session <ID>` 等で確認します。受領確認だけの目的で、ID未指定のSessionStartを再実行して別の記録を作りません。H0に記録生成・修復の全工程を要求しません。

When delivery is uncertain, the agent inspects accessible configuration and diagnostics for the relevant product, project, session and event. Record the inspected scope and uncertainty without copying entire conversations or raw logs into external messages. Read applicable canonical files before implementation, and inspect existing records through read-only commands such as `--mode path --session <ID>` in [TASK_STATE_PROTOCOL.md](../axiarch-harness/en/TASK_STATE_PROTOCOL.md). Do not rerun SessionStart without an ID merely to check delivery and thereby create unrelated records. H0 does not require a full record-creation or repair workflow.

時間制限・出力上限・非同期化・フック無効化・信頼設定を、自動で緩めて成功扱いにしません。設定変更が必要なら既存の承認範囲と独自設定を確認し、対象の差分をレビューして再検証します。設定調整は必須の導入手順ではなく、確認した原因に応じた選択です。確認不能でも未確認を保ち、アクセスできない情報や承認など人間の判断が必要な事項が残る場合だけ質問します。

Do not automatically relax timeouts, output limits, synchronous execution, hook activation or trust settings to report success. If a configuration change is needed, preserve local customization, check existing authorization, review the affected diff and verify it again. Tuning is an optional response to an established cause, not a mandatory installation step. Keep unresolved delivery unverified and ask only when inaccessible information or a human-owned decision remains.

## `axiarch-init-task-md.sh`

### 概要 / Overview

`.claude/settings.json` または `.codex/hooks.json` の `SessionStart` hook から呼ばれる外出しスクリプト。会話開始時に `axiarch-task-state.sh` へ委譲し、セッション固有の `task.md` / `implementation_plan.md` / `walkthrough.md` を用意する。同じセッションの再開と既存ルート文書は保持する。起動に成功した場合は AXIARCH.md とネイティブタスク状態同期の reminder および実際の記録先を `additionalContext` で示し、失敗した場合は警告する。製品側の受領は上の手順で別途確認する。

Externalized SessionStart hook script invoked from `.claude/settings.json` or `.codex/hooks.json`. On session start, delegates to `axiarch-task-state.sh` and prepares `task.md` / `implementation_plan.md` / `walkthrough.md` as session-specific documents, preserving same-session resumes and legacy root files. Successful initialization outputs the protocol reminder and actual record location; initialization failure emits a warning. Product delivery is a separate check described above.

起動・補足フックは共通補助でセッションIDを解決します。不正JSON、重複キー、競合するsession_id／sessionId、不正なIDを新規作業とは解釈しません。起動時は記録を作らず警告し、補足時はセッション未解決として扱います。環境変数があっても入力IDを検証します。正しい空入力は旧呼出しとの互換を保ち、解決できるIDがなければ新規IDを生成します。優先順位は [実行契約](../axiarch-harness/ja/TASK_STATE_PROTOCOL.md) に従い、継承したCodexのIDで別製品のネイティブIDを隠しません。Python 3や共通補助がない場合は、確認できていないことを示す短い警告を返します。

Startup and reminder hooks share session-ID resolution. Invalid JSON, duplicate keys, conflicting session_id/sessionId fields and invalid IDs do not imply new work: startup preserves records and warns, while reminders leave the session unresolved. Input IDs are validated even when environment variables are present. Empty input remains supported and generates fresh IDs when no identity can be resolved. Precedence follows the [execution contract](../axiarch-harness/en/TASK_STATE_PROTOCOL.md); inherited Codex identity never hides another product's native ID. Missing Python 3 or helpers produces a short warning without claiming successful inspection.

### 使い方 / Usage

直接実行する用途は通常なし（hook 経由で自動呼出）。デバッグ時のみ：

```bash
bash axiarch-scripts/axiarch-init-task-md.sh | jq .
# → hookSpecificOutput.additionalContext に reminder + (必要なら scaffold note)
```

---

## `axiarch_hook.py`

起動・補足・Writeフックから呼ぶ内部補助です。生のJSON入力の検証、セッションIDとプロンプトの解析、補足JSONの生成、表示間隔キャッシュを担当します。状態JSONの厳密な解析は `axiarch-scripts/axiarch_state.py` と共有します。単独ファイルだけで配布せず、scripts一式で更新してください。初期導入の事前確認とhealthは、この補助ファイルの欠落も検出します。

Internal helper for startup, reminder and Write hooks: raw JSON validation, session/prompt decoding, context JSON and verbosity caching. Strict JSON decoding is shared with `axiarch-scripts/axiarch_state.py`. Update the scripts as a complete set. Installation preflight and health detect a missing helper; its presence alone does not prove correct runtime invocation.

---

## `axiarch-task-state.sh`

### 概要 / Overview

セッション別Markdownとタスク共通JSONを管理する。既存ルート文書を自動置換しない。ID、再開、旧記録のコピー移行、世代競合、構造・準備・完了検査は [日本語の実行契約](../axiarch-harness/ja/TASK_STATE_PROTOCOL.md) を参照する。Python 3標準ライブラリとPOSIXローカルファイルシステムが必要。

Manages session-specific Markdown and shared task JSON without replacing existing root documents. See the [English execution contract](../axiarch-harness/en/TASK_STATE_PROTOCOL.md) for IDs, resume, legacy import, revision conflicts and structure/readiness/completion phases. Requires Python 3 standard library and a POSIX local filesystem.

```bash
bash axiarch-scripts/axiarch-task-state.sh --mode new --task review --session agent-a --owner Codex
bash axiarch-scripts/axiarch-task-state.sh --mode resume --task review --session agent-a
bash axiarch-scripts/axiarch-task-state.sh --mode status
bash axiarch-scripts/check-axiarch-health.sh --phase readiness --task review
bash axiarch-scripts/check-axiarch-health.sh --phase completion --session agent-a
```

`AXIARCH_PROCESS_DOC_MODE=current|append` は互換入力であり、いずれも既存文書を保持する。`AXIARCH_PROCESS_DOC_LANG=auto|ja|en` は従来どおり言語を選択する。旧退避先 `.axiarch/process-doc-history/` は保持する。

`AXIARCH_PROCESS_DOC_MODE=current|append` remains accepted; both preserve existing evidence. `AXIARCH_PROCESS_DOC_LANG=auto|ja|en` retains language selection. Legacy `.axiarch/process-doc-history/` remains intact.

通常の生成失敗では新規記録だけを取り消し、既存記録を保持する。rendererの成功コードだけでなく3文書の実在・通常ファイル・空欄でないことも確認する。互換ポインターだけの失敗は警告とし、管理記録の成功と区別する。強制終了後は残る記録を検査して明示したIDで再開し、不完全なタスクを新規状態へ上書きしない。ロックの種類・所有者・リンク数、JSON数値の有限性も検査する。保存単位と復旧方法の正本は [タスク状態の実行契約](../axiarch-harness/ja/TASK_STATE_PROTOCOL.md)。共有ロックファイルの削除で競合を回避してはならない。

Ordinary generation failures roll back only new records and preserve existing work. Renderer success requires three nonempty regular documents, not just exit 0. Optional root-pointer failure is a warning, distinct from successful managed-record creation. After forced termination, inspect retained records and resume explicit IDs; do not overwrite an incomplete task with new state. Lock type, ownership, link count and finite JSON numbers are checked. See the [task-state contract](../axiarch-harness/en/TASK_STATE_PROTOCOL.md) for write boundaries and recovery. Do not delete shared lock files to bypass contention.

---

## `check-git-config-clean.sh`

### 概要 / Overview

Gitがprune可能と判定するworktree管理情報と、local branchが存在しない`branch.<name>` configを検出し、`--fix`ではGitの正規操作で対象metadataだけを修復する。`extensions.worktreeConfig`は正式機能として保持し、active worktree、branch ref、未保存変更は削除しない。`engineering/600_git_workflow.md` Worktree Hygiene Protocol と連動。

Detects worktree administrative data that Git marks as prunable and `branch.<name>` configuration whose local branch no longer exists. With `--fix`, it repairs only that metadata through supported Git operations. It preserves the supported `extensions.worktreeConfig` feature and never deletes active worktrees, branch refs, or unsaved changes. Linked with the `engineering/600_git_workflow.md` Worktree Hygiene Protocol.

### 使い方 / Usage

```bash
# 検出のみ（dry-run、デフォルト）/ Detection only (default)
bash axiarch-scripts/check-git-config-clean.sh

# 自動修復 / Auto-fix
bash axiarch-scripts/check-git-config-clean.sh --fix

# サイレント実行（CI 用）/ Silent mode (for CI)
bash axiarch-scripts/check-git-config-clean.sh --quiet

# 非推奨の互換alias。--fixと同じでbranchやactive worktreeは削除しない
# Deprecated compatibility alias. Same as --fix; never deletes branches or active worktrees
bash axiarch-scripts/check-git-config-clean.sh --full-clean
```

### 推奨ワークフロー / Recommended Workflow

- worktreeの追加・削除・移動後、またはtask終了gateで`--quiet`を実行
- 検出内容と`git worktree prune --dry-run --verbose`を確認してから`--fix`を実行
- active worktree、branch ref、未保存変更の削除は本scriptと分離し、人間判断で行う

---

## 自動配布 / Auto Distribution via `init.sh`

`init.sh` は新規導入向けです。スクリプト群を一時領域へ用意し、Pythonのキャッシュを除外して、選択構成の欠落・構文・導入先との衝突を確認してから配置します。既存導入先は `axiarch-scripts/axiarch-upgrade.sh` を使います。独自ファイルを上書きする再導入は行いません。

`init.sh` stages a fresh installation, excludes Python caches, and checks selected files, syntax and destination collisions before copying. Existing adopters use `axiarch-scripts/axiarch-upgrade.sh`; reinstalling over local files is not supported.

## 初期導入と任意生成の結果 / Setup and optional generation outcomes

初期導入は全入力が揃うまで対象を書き換えず、EOFでは適用しません。適用後の構造診断が成功した場合だけ確認済み版数を記録します。`.axiarch/install-result.json` は適用結果・診断結果・選択範囲、`install-health.log` は診断出力です。診断失敗は終了4で版数未確認、衝突など適用前の停止は3、適用中の失敗は5、同時更新中は6。入力・不足ツール・準備失敗は1または2です。中断時はin_progressが残る場合があり、成功を意味しません。記録とファイルを確認しSafe Upgradeで復旧します。既存pre-commitやhook管理ツールには追記せず、手動統合が必要な旨を記録します。

Fresh installation leaves the target unchanged until all input is available; EOF never approves application. Only a passing post-install structure diagnosis confirms a version. `.axiarch/install-result.json` separates application, diagnosis and selection, and `install-health.log` stores output. Exit 4 means failed diagnosis with an unconfirmed version; 3 means a pre-application stop, 5 an application failure, and 6 another writer. Input, prerequisites or preparation may exit 1 or 2. Interruption may leave in_progress, which is not success; inspect the result and files before repairing through Safe Upgrade. Existing pre-commit hooks/managers remain untouched and require manual integration.

更新の `--dry-run` は `--apply` の指定順や対話回答に関係なく非変更です。`--lang en --with-prompts` は英語のプロンプトと共通READMEだけを対象にし、日本語を削除・更新しません。確認済み版数は選択した範囲に限ります。

An explicit upgrade `--dry-run` remains read-only regardless of option order or interactive answers. `--lang en --with-prompts` selects English prompts and the shared README without deleting or updating Japanese files. Confirmed versions cover only the selected scope.

言語・製品の追加は、配布対象の選択、設定の適用、固有Blueprintの準備、応答言語と任意コマンドの切替を区別します。中核ファイルのレビュー待ちによる診断失敗からの復旧を含め、[互換性・移行手順](AGENT_COMPATIBILITY.md) を参照してください。

Adding a language or agent separates distribution selection, configuration application, local Blueprint preparation, response language and optional command regeneration. See the [compatibility and migration guide](AGENT_COMPATIBILITY.md), including recovery when pending core files cause diagnosis to fail.

任意のコマンド生成は `axiarch-scripts/axiarch-prompts-install.sh` から `axiarch-scripts/axiarch_setup.py` を使用し、導入先にある正本だけを参照します。再生成・削除は未編集の生成物のみ。独自・編集済み・旧形式のファイルは保持して終了3、引数不正は2、同時更新中は6です。導入・更新・生成は同一導入先の協調ロックを共用し、ファイル単位で原子的に書き込みます。全ファイルを一括で元に戻す取引や、直接書き込む別ツールまでの排他は保証しません。

Optional command generation uses `axiarch-scripts/axiarch_setup.py` through `axiarch-scripts/axiarch-prompts-install.sh` and points only to installed canonical files. Regeneration/cleanup changes only unmodified generated output. Custom, edited or legacy files are preserved with exit 3; invalid arguments exit 2 and a busy target exits 6. Install, upgrade and generation share a cooperative target lock and atomic per-file writes, not an all-files rollback transaction or exclusion of unrelated direct writers.

---

## 関連ドキュメント / Related Documentation

- [`README.md`](../README.md) — `Hook Reinforcement Mechanism` トラブルシュート章
- [`axiarch-rules/{ja,en}/LOADING_PROTOCOL.md`](../axiarch-rules/) — フック診断手順
- [`axiarch-rules/{ja,en}/CRYSTALLIZATION_PROTOCOL.md`](../axiarch-rules/) — 結晶化遵守の §5 強化
- [`axiarch-rules/{ja,en}/universal/engineering/600_git_workflow.md`](../axiarch-rules/) — Worktree Hygiene Protocol
- [Claude Code Hooks (公式 / official)](https://code.claude.com/docs/en/hooks)

## 更新結果と実動作検証 / Outcomes and behavioral verification

更新には `axiarch-scripts/axiarch-upgrade.sh` を使う。内部Python補助の `copy` は共通の事前検査とコピー失敗の終了5を持つが、全体の排他・診断・版数確定を単独では行わない。終了0だけで更新完了を判定しない。部分書込と再実行の境界は [実行記録の保護](../axiarch-harness/ja/TASK_STATE_PROTOCOL.md#実行記録の保護) を参照。

Use `axiarch-scripts/axiarch-upgrade.sh` for upgrades. The internal Python `copy` helper shares preflight checks and returns 5 for copy failures, but does not provide the overall lock, diagnosis or version confirmation by itself. Its exit 0 alone is not an upgrade-completion verdict. See [runtime artifact protection](../axiarch-harness/en/TASK_STATE_PROTOCOL.md#runtime-artifact-protection) for partial-write and retry boundaries.

管理記録の誤コミットを抑えるため、適用する導入・更新とセッション起動は `.axiarch/.gitignore` を補完する。既存内容を保持し、Git管理済み・除外漏れは診断失敗とする。保存権限、保持・共有、通知の契約は [実行記録の保護](../axiarch-harness/ja/TASK_STATE_PROTOCOL.md#実行記録の保護) を参照。過去記録は自動削除・untrackしない。導入・更新後の保護検査失敗も終了4となり、正常確認済みの版数へ進めない。適用前の保護設定失敗は導入3、更新5、セッション2となる（導入側のロック競合は6）。補完済みの除外設定だけが残ることがある。

Install/apply/session operations supplement `.axiarch/.gitignore` without removing existing content. Tracked or unignored private artifacts fail diagnosis; see [runtime artifact protection](../axiarch-harness/en/TASK_STATE_PROTOCOL.md#runtime-artifact-protection) for permissions, retention, sharing and notification boundaries. No automatic deletion or untracking occurs. Failed post-application protection checks return 4 without confirming the new version. Pre-application protection failures return 3 for installation, 5 for upgrade and 2 for session operations (installation lock contention returns 6); supplemented exclusions may remain.

更新manifestの制御文字は適用前に拒否し、表示ラベル内のバックスラッシュは文字のまま出力する。CLI引数の制御文字も拒否する。診断ログ・対話diffの内容を安全な指示として解釈せず、外部共有前に確認する。この表示検査は入力の意味理解やログの機密除去を保証しない。

Upgrade manifests containing control characters are rejected before application; backslashes in displayed labels remain literal. CLI control characters are also rejected. Treat diagnostic logs and interactive diffs as untrusted content and review before sharing. Display validation does not prove semantic correctness or redact private data.

終了コード0〜6・130・143、`version`と`requestedVersion`、更新排他・中断復帰、旧導入先移行、hookの保証範囲は [READMEの実行・更新契約](../README.md#実行記録更新結果保証範囲--runtime-evidence-upgrade-outcomes-and-guarantees) を参照。Python補助 `axiarch-scripts/axiarch_state.py` / `axiarch-scripts/axiarch_upgrade.py` / `axiarch-scripts/axiarch_inspect.py` / `axiarch-scripts/axiarch_setup.py` はscriptsグループで配布する。`tests/` はsource-only（採用先へ既定配布しない）。

See the linked README for exit codes, version semantics, legacy migration and hook coverage. Python helpers ship with the scripts group; `tests/` is source-only. Run `python3 -m unittest discover -s tests -p 'test_*.py' -v` in the source repository.


追加の読取診断 / Additional read-only inspection:

`python3 axiarch-scripts/axiarch_inspect.py --project PATH` は両言語の実教訓を検査します。引用・コード内テンプレートを除外し、タグ不足、無効日付、件数・経過日、存在しない格納先を報告します。`--mode blueprint-files` は初期8分類以外も含む000–999の実ファイル候補を表示します。配置や語句の一致を読了・理解・完了と扱いません。この追加実装はv1.17.0に含まれます。

`python3 axiarch-scripts/axiarch_inspect.py --project PATH` inspects real lessons in both installed languages, excluding quoted/fenced templates, and reports missing tags, invalid dates, count/age triggers and missing target folders. `--mode blueprint-files` discovers 000–999 candidates in actual folders, including additional categories. Neither placement nor keywords prove reading, understanding or completion. These additions are included in v1.17.0.

コード例内のコメント記号で後続の教訓やリンクを隠さず、未閉鎖の実コメント内を実記録として数えません。通常のリンク検査はコードスパン内のリンク構文例を除外し、別途行う具体的なルールパスの検査はコード表記の参照も対象にします。任意のMarkdown描画や意味の検証ではありません。

Literal comment tokens in code examples do not hide later lessons or links, and unclosed real comments do not count as records. Ordinary link checks exclude syntax examples inside code spans; the separate concrete rule-path check still inspects code-formatted references. This is not arbitrary Markdown rendering or semantic validation.

参照検査は `python3 tests/check_documentation.py`、回帰全体は `python3 -m unittest discover -s tests -p 'test_*.py' -v`。ローカルリンク、見出し、日英パス、同一フォルダの採番衝突、旧実証表現に加え、コード枠内の任意プロンプトの正本参照と既知の一律待機・全ルールロード指示を検査します。外部リンクの可用性や本文の意味的正しさは保証しません。

Use the commands above for local reference checks and the full regression suite. Checks cover local links/headings, bilingual paths, per-folder prefix collisions, obsolete validation claims, and canonical references and known unconditional-wait/full-rule-loading instructions inside fenced prompts. They do not certify external-link availability or semantic correctness.


旧教訓ログは更新時に上書きしません。新しい診断でTarget Folder不足・古い日付・認識できない旧形式が出た場合は、元の内容と日付を保持して分類先を補完するか、CRYSTALLIZATION_PROTOCOLに沿って昇華します。既存の引用テンプレートは実教訓として数えません。新フォルダは既存分類で収まらない場合に承認範囲を確認し、空フォルダ用.gitkeepは追加しません。

Existing lesson logs are preserved during upgrades. Resolve missing Target Folder tags, age triggers or unrecognized legacy formats by retaining original content/dates and classifying or promoting the actual lessons through CRYSTALLIZATION_PROTOCOL. Quoted templates are not real entries. Additional folders follow the approved scope; no .gitkeep is needed.
