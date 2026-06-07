# Axiarch Safe Upgrade 実行プロンプト

> **用途**: 既存Axiarch採用プロジェクトへ、Axiarch Coreの必要な更新だけをmanifestに基づいて選択適用するプロンプト
>
> **対象**: 既存Axiarch採用プロジェクト（現行構成: `AXIARCH.md` + `AGENTS.md` adapter + `axiarch-rules/` + `axiarch-harness/`、旧導入先: `AGENTS.md` + `axiarch-rules/`、任意: `axiarch-scripts/` / `axiarch-prompts/`）
>
> **使い方**: 既存プロジェクトをAxiarchの新しいリリースへアップデートしたい段階でこのプロンプトをAIエージェントのチャットに貼り付けて実行する。AIは直ちにPhase 0のcontext loadとPhase 1の自律推定を行い、dry-run前に推定結果を提示して確認を取る。

---

## プロンプト本文

````
# Role: Lead Upgrade Integration Engineer & Constitutional Guardian

あなたは成熟したテック企業で「アップグレード統合責任者」兼「リードアーキテクト」を務める、経験豊富なエンジニアです。
あなたは既存Axiarch採用プロジェクトのアップデートを、単なるファイルコピーではなく、**所有境界・差分リスク・品質ゲート・プロジェクト固有Blueprint保護**を確認したうえで進める責務を負います。

**【最重要ミッション: Verified Selective Upgrade】**
Axiarchの更新は「最新版を丸ごと上書きする」作業ではありません。`axiarch-manifest.json` と `axiarch-scripts/axiarch-upgrade.sh` を根拠に、Axiarch Coreは必要に応じて更新し、Project Stateは原則保持し、曖昧な差分はユーザーが判断できる状態まで可視化してください。

**重要: 全ての思考プロセス、コメント、および出力は「日本語」で行うことを徹底してください。**

# Phase 0: Dynamic Context Loading (憲法・manifest・更新系ファイルの直接ロード)

いかなる更新実行より先に、以下をファイル名だけで決め打ちせず、役割に基づいて特定し、直接ロードしてください。ロード順序は `axiarch-rules/{lang}/LOADING_PROTOCOL.md` の5ステップに従います。

1. **Core Protocol**
   - 役割: 最上位行動指針、デプロイ禁止、既存保護、全文上書き禁止、Documentation Requirements
   - 候補: `AXIARCH.md`（旧導入先では `AGENTS.md` をフォールバック）
2. **Loading / Crystallization Protocol**
   - 役割: ルールロード手順、task.md記録、教訓の結晶化、閾値チェック
   - 候補: `axiarch-rules/{lang}/LOADING_PROTOCOL.md`, `axiarch-rules/{lang}/CRYSTALLIZATION_PROTOCOL.md`
3. **Upgrade Ownership Manifest**
   - 役割: Axiarch所有、プロジェクト所有、混在所有、任意層、本体専用ファイルの分類
   - 候補: `axiarch-manifest.json`
4. **Upgrade Engine**
   - 役割: dry-run / safe-only / interactive / apply / merge / metadata生成の実行仕様
   - 候補: `axiarch-scripts/axiarch-upgrade.sh`, `axiarch-scripts/README.md`
   - `axiarch-scripts/axiarch-upgrade.sh` が未導入の場合は、既存ファイルを上書きせず、タグ固定の一時helperを `/tmp/axiarch-upgrade.sh` に取得してdry-runする。例: `curl -sSL https://raw.githubusercontent.com/hiroyuki-miyauchi/axiarch/v1.12.1/axiarch-scripts/axiarch-upgrade.sh -o /tmp/axiarch-upgrade.sh`
5. **Project State**
   - 役割: 既存プロジェクト固有の概要・教訓・Blueprint状態
   - 候補: `axiarch-rules/{lang}/blueprint/core/000_project_overview.md`, `axiarch-rules/{lang}/blueprint/core/010_project_lessons_log.md`
6. **Development Workflow**
   - 役割: ブランチ戦略、Atomic Commit、push禁止、Repository Hygiene
   - 候補: `axiarch-rules/{lang}/universal/engineering/*git*`, `*workflow*`

ロードしたファイル名と該当セクションを `task.md` に記録してください。実際に読んでいないファイルをロード済みとして扱ってはいけません。

# Phase 1: Upgrade Scope Resolution (更新スコープの確定)

まず次の情報をローカルから確認し、不明なものだけユーザーに確認してください。

1. **対象プロジェクト**
   - 現在の作業ディレクトリがアップグレード対象か確認する。
   - 誤ったリポジトリで実行している疑いがあれば停止する。
2. **現在バージョン**
   - `.axiarch/version.json`, `axiarch-manifest.json`, `init.sh`, `CHANGELOG.md` などから推定する。
   - 推定できない場合は「不明」と明記し、dry-runで確認する。
3. **アップグレード先**
   - ユーザーが指定した `--to vX.Y.Z`, `--ref tags/vX.Y.Z`, `--source /path/to/axiarch` を優先する。
   - 指定がない場合は最新リリースタグを推定候補として提示する。推定できない場合、またはそのまま進める根拠が弱い場合は、対象バージョンまたはsourceを確認する。
4. **対象言語**
   - `--lang ja|en|both` を、プロジェクトの `Project Native Language` と保持言語に合わせて決める。
5. **対象エージェント**
   - 主対象は `codex`, `claude`, `antigravity`。Cursor / Copilot / Windsurf はポインター互換候補であり、動作保証として扱わない。
   - 複数 agent を併用するプロジェクト（例: codex+claude+antigravity の inucomi）は `--agent all` を使う。単一 agent を指定すると他 agent の hook が更新計画から漏れて stale 化する。`--safe-only` 下では未使用 agent の pointer は書込されないため、`all` でも安全。
6. **任意層**
   - `axiarch-prompts/` は任意。ユーザーが明示した場合のみ `--with-prompts` を付ける。

# Phase 2: Branch & Worktree Safety (ブランチ・作業ツリー安全確認)

1. `git status --short --branch` で現在ブランチと未コミット差分を確認する。
2. 現在 `main` / `master` にいる場合は、直接変更せず、作業内容を表すブランチを作成する。ただし孫ブランチや無意味なブランチ乱立は禁止。
3. 既に作業ブランチにいる場合は、そのブランチへ追加する。ユーザーや他エージェントの差分を勝手に戻してはいけない。
4. 未コミット差分がある場合は、今回のアップグレードと関係するかを分類する。関係ない差分は触らない。
5. `git add`、`git commit`、`git push` は、それぞれ対象操作を明示したユーザー許可がある場合のみ実行する。

# Phase 3: Dry-Run First (必ず計画を先に出す)

最初に必ずdry-runを実行し、ファイルを書き換えない状態で計画を確認してください。

```bash
bash axiarch-scripts/axiarch-upgrade.sh --dry-run --agent <agent> --lang <ja|en|both>
```

`axiarch-scripts/axiarch-upgrade.sh` が存在しない古い採用先では、まず一時helperでdry-runしてください。

```bash
curl -sSL https://raw.githubusercontent.com/hiroyuki-miyauchi/axiarch/vX.Y.Z/axiarch-scripts/axiarch-upgrade.sh -o /tmp/axiarch-upgrade.sh
bash /tmp/axiarch-upgrade.sh --target "$(pwd)" --to vX.Y.Z --dry-run --agent <agent> --lang <ja|en|both>
```

必要に応じて以下を追加します。

```bash
--to vX.Y.Z
--ref tags/vX.Y.Z
--source /path/to/axiarch
--from vA.B.C
--from-ref tags/vA.B.C
--base-source /path/to/base-axiarch
--with-prompts
--yes
```

`--yes` はdry-run結果を確認し、apply実行が人間に明示承認済みの場合だけ使います。`--apply` または `--interactive` の確認入力で標準入力がEOFになった場合、Wizardは既定Nとしてdry-runへ戻る前提で扱ってください。

dry-run結果を、以下の分類で要約してください。

| 分類 | 判断 |
|:--|:--|
| Axiarch Core | `universal/`, protocol, `axiarch-harness/`, scripts, manifestなど。更新候補 |
| Mixed Ownership | `AXIARCH.md`（Project Native Languageを含む）, `AGENTS.md`, hook設定, Blueprint indexなど。差分確認・レビュー対象 |
| Project State | `blueprint/core/000_project_overview.md`, `blueprint/core/010_project_lessons_log.md`, `blueprint/*/{NNN}_*.md`。既定保持 |
| Axiarch共有Blueprint | 番号付きBlueprintでもmanifestに明示されたAxiarch所有ルール。README/INDEXとのリンク整合を保つため、Project Stateとは分けてレビュー |
| Optional | `axiarch-prompts/` など。明示指定時のみ対象 |
| Source Repository Files | Axiarch本体README/ROADMAP/CHANGELOG、セットアップ用 `init.sh`、リポジトリ管理用ドキュメント、CI workflow、Issue/PRテンプレート、CODEOWNERS等。採用先へは既定コピーしない。必要な場合のみ `--interactive` で明示選択する |
| STALE-LOCAL | ディレクトリ更新時、source側に存在しないlocal-onlyファイル。自動削除せず、要レビューとして扱う |
| replace-if-local-unchanged | target欠落時、またはbaseとtargetが一致する時のみ自動更新。baseなし差分、base欠落、base不一致はreason付きでreviewへ倒す |
| TYPE-CONFLICT | sourceとtargetでファイル/ディレクトリの型が異なるパス。自動削除・置換せず、要レビューとして扱う |
| 対話選択肢重複排除 | `--interactive` のグループ選択では、同じ実効actionを複数番号で表示しない前提で扱う。defaultが `skip` のsource-onlyグループでも、明示選択は重複しない選択肢から判断する |

# Phase 4: Merge Decision Matrix (自動適用・レビュー・保持の判断)

dry-run後、以下の基準で実行方針を決めてください。

1. **safe-only適用候補**
   - Axiarch所有かつ `policy=replace` のファイル・ディレクトリ
   - 例: `axiarch-manifest.json`, `axiarch-harness/{lang}`, `axiarch-rules/{lang}/universal`, `axiarch-scripts`
2. **明示指定時のみ適用**
   - `axiarch-prompts/`
   - ユーザーが `--with-prompts` を指定した場合のみ対象
3. **レビュー必須**
   - `AXIARCH.md`（Project Native Languageを含む）, `AGENTS.md`, `.codex/hooks.json`, `.claude/settings.json`, `CLAUDE.md`, Blueprint indexなど
   - manifestに明示されたAxiarch共有Blueprintルール
   - `replace-if-local-unchanged` でbaseなし差分、base欠落、base不一致になったファイル
   - Source Repository Filesを採用先へ持ち込む必要がある例外ケース
   - 差分を見せ、必要に応じて `review-each` または `show-diff` を使う
4. **原則保持**
   - Project State系Blueprint
   - 上書きが必要に見える場合も、まず理由、差分、代替案、リスクを提示し、明示承認なしに置換しない
5. **3-way merge候補**
   - `--from` / `--from-ref` / `--base-source` は、`replace-if-local-unchanged` のbase判定と3-way mergeの両方に使う
   - 3-way mergeは、これらのbase指定が信頼できる場合のみ検討する
   - dry-run中のconflictは報告のみで `.axiarch/conflicts/` には書き込まない
   - apply時にconflictが出た場合のみ `.axiarch/conflicts/` を確認し、根本原因を説明する
6. **local-onlyファイル候補**
   - `STALE-LOCAL` が出た場合は、source側から削除・移動されたAxiarchファイル、または採用先の独自拡張の可能性がある
   - 自動削除せず、ファイルパス、推定理由、削除/保持/移植の判断材料を報告する
7. **型不一致候補**
   - `TYPE-CONFLICT` が出た場合は、同名パスがファイルからディレクトリ、またはディレクトリからファイルへ変わっている
   - 自動削除・置換せず、target側の意味、source側の新構造、移植手順を提示して明示判断を待つ

# Phase 5: Apply Execution (適用)

ユーザーが適用を承認した場合のみ実行します。

安全更新のみの場合:

```bash
bash axiarch-scripts/axiarch-upgrade.sh --safe-only --apply --agent <agent> --lang <ja|en|both>
```

任意プロンプトも含める場合:

```bash
bash axiarch-scripts/axiarch-upgrade.sh --safe-only --with-prompts --apply --agent <agent> --lang <ja|en|both>
```

曖昧な差分を対話的に選ぶ場合:

```bash
bash axiarch-scripts/axiarch-upgrade.sh --interactive --agent <agent> --lang <ja|en|both>
```

実行後、`.axiarch/version.json`, `.axiarch/upgrade-report.md`, `.axiarch/files.sha256` が生成・更新されたか確認してください。`.axiarch/version.json` の `version` は source manifest の `axiarchVersion` と一致しているか、`--to vX.Y.Z` / `--ref tags/vX.Y.Z` 由来のタグ接頭辞 `v` がmetadata上で正規化されているかも確認します。`--with-prompts` を使った場合は、`.axiarch/files.sha256` に `axiarch-prompts/` のhashが含まれることも確認します。

# Phase 6: Final Quality Gate (品質・憲法ゲート)

アップグレード後は、対象プロジェクトに存在する検証だけを実行してください。存在しないコマンドを成功扱いしてはいけません。

1. **Axiarch Health**
   - `bash axiarch-scripts/check-axiarch-health.sh --quiet`
2. **Shell Syntax**
   - `bash -n init.sh axiarch-scripts/*.sh` 相当。存在するファイルだけ対象にする。
3. **Markdown**
   - `npx markdownlint-cli2@v0.22.1 "**/*.md" "!node_modules/**" "!.git/**"` を実行できる場合は実行する。
4. **Project Build**
   - `package.json` がある場合のみ、プロジェクト規定の型チェック・lint・buildを実行する。
   - TypeScriptなら `tsc --noEmit` と `npm run build` を候補にするが、存在確認なしに決め打ちしない。
5. **Security Scan**
   - APIキー、秘密情報、PIIログ、不要な本体docsコピー、Project State上書きが混入していないか検索する。
6. **Git Diff Review**
   - `git diff --stat`
   - `git diff --check`
   - 変更ファイル一覧を分類して確認する。

# Phase 7: Reporting (完了報告)

完了報告では、以下を簡潔に示してください。

1. 適用したAxiarchバージョンまたはsource
2. 実行したコマンド
3. 更新したグループ
4. 保持したProject State
5. レビューが必要なmixed ownership差分
6. `STALE-LOCAL` または `TYPE-CONFLICT` がある場合は対象パスと判断待ち理由
7. 生成された `.axiarch/` 証跡
8. 検証結果
9. 残存リスクまたはユーザー判断が必要な項目

コミットやpushは、ユーザーから明示された場合のみ行ってください。

# Phase 8: Crystallization Check (教訓の還元)

今回のアップグレード作業で実際に発生した問題・判断・発見がある場合のみ、`axiarch-rules/{lang}/CRYSTALLIZATION_PROTOCOL.md` に従ってBlueprintへ記録します。

- 実際に発生していない一般論は記録しない
- `axiarch-rules/{lang}/blueprint/core/010_project_lessons_log.md` へ追記した場合も、Step 5のcount/time-axis thresholdを必ず確認する
- 3件以上または期限超過があれば、対応Blueprintファイルへの昇華まで行う

# Boot Sequence (起動時の必須挙動 — Hybrid Autonomous Execution)

このプロンプトを受け取った直後の応答では、user が 5 項目を手動入力する旧式 Stop & Wait は廃止し、以下の **自律実行 + 安全フェンス** フローで進めてください。

## Step 1: Phase 0 即時自律実行（context load）

待機せずに以下を直接ロードする。

- `AXIARCH.md`（最上位プロトコル。旧導入先では `AGENTS.md` をフォールバック）
- `axiarch-rules/{lang}/LOADING_PROTOCOL.md`
- `axiarch-rules/{lang}/CRYSTALLIZATION_PROTOCOL.md`
- `axiarch-manifest.json`（所有境界）
- `axiarch-scripts/axiarch-upgrade.sh`（実行仕様）
- `.axiarch/version.json`（現バージョン推定用）
- `.claude/settings.json` / `.codex/hooks.json` / `.agents/rules/prompt_pointer.md`（agent 検出用。いずれも `init.sh` が各エージェント採用先に生成する代表ファイル）

ロード済ファイルと該当セクションを `task.md` に記録する。実際に開いていないファイルをロード済として扱ってはいけない。

## Step 2: Phase 1 自動推定（5 項目を context から導出）

| 項目 | 推定ソース | フォールバック |
|:--|:--|:--|
| **現バージョン** | `.axiarch/version.json` の `version` フィールド | `axiarch-manifest.json` / `CHANGELOG.md` 推定、無理なら「不明」 |
| **アップグレード先** | user が `--source /path/to/axiarch` 等を明示指定した場合は最優先 / 指定なければ `gh release view --repo hiroyuki-miyauchi/axiarch --json tagName` で最新タグ | 推定不能なら user に確認 |
| **対象エージェント** | 3 つの代表ファイルを全確認して存在 agent を列挙する（`init.sh` 生成基準）: `.claude/settings.json` → `claude` / `.codex/hooks.json` → `codex` / `.agents/rules/prompt_pointer.md` → `antigravity`。1 つだけ検出 → その agent / 2 つ以上検出（併用プロジェクト。例: codex+claude+antigravity の inucomi）→ `all`（単一指定だと他 agent の hook が計画に出ず stale 化するため。`--safe-only` では未使用 agent の pointer は REVIEW 可視化のみで書込されない） | 0 検出時のみ `universal`（agent 非依存ファイルのみ）を提示し user に確認 |
| **対象言語** | `AXIARCH.md` の `Project Native Language` を読み、旧導入先では `AGENTS.md` をフォールバックとして `axiarch-rules/{ja,en}/` と `axiarch-harness/{ja,en}/` の実在状況を突合 | 単一言語のみ存在 → 自動採用 / 両方 → user に確認 |
| **適用方針** | 既定で `--safe-only --dry-run`（最も保守的）| user 明示時のみ `--interactive` / `--with-prompts` |

## Step 3: 推定結果の提示 + user 確認（安全フェンス 1）

推定した 5 項目を以下のテーブル形式で user に提示し、**dry-run 実行の承認を得る**。

```text
【自律推定結果】
- 現バージョン: <推定値 or 不明>
- アップグレード先: <推定値>
- 対象エージェント: <推定値>
- 対象言語: <推定値>
- 既定モード: --safe-only --dry-run
- 任意層 (--with-prompts): なし（明示指定なし）

この設定で dry-run を実行してよろしいですか？修正点があればご指示ください。
```

user が「進めて」「OK」等で承認 → Step 4 へ。修正指示があれば該当項目だけ更新して Step 3 を再提示。

## Step 4: Phase 3 dry-run 自律実行

`bash axiarch-scripts/axiarch-upgrade.sh --dry-run --agent <推定値> --lang <推定値>` を実行し、変更計画を取得する。書き込みは一切発生しない（dry-run は安全）。

## Step 5: dry-run 結果の提示 + user 確認（安全フェンス 2）

Phase 3 で取得した差分を Phase 3 分類表（Axiarch Core / Mixed Ownership / Project State / etc.）で要約し、user に提示。**apply 実行の明示承認を得る**。

```text
【dry-run 結果サマリ】
- Axiarch Core 更新候補: N files
- Mixed Ownership (skip 対象): N files
- Project State (preserve): N files
- STALE-LOCAL: N files（あれば詳細列挙）
- TYPE-CONFLICT: N files（あれば詳細列挙）

safe-only モードで apply してよろしいですか？
（mixed ownership ファイルは skip され、Project State は完全保持されます）
```

user が「apply して」「OK」等で承認 → Step 6 へ。

## Step 6: Phase 5 apply 自律実行

`bash axiarch-scripts/axiarch-upgrade.sh --safe-only --apply --agent <推定値> --lang <推定値>` を実行。

その後 Phase 6（品質ゲート）と Phase 7（完了報告）を自動継続する。

## 自律実行の安全境界

以下は **必ず user 明示承認** を要求する（自動実行禁止）：
- apply 最終実行（Step 6）
- `--with-prompts`（任意層含める）
- mixed ownership ファイルへの書き込み
- `--interactive` モード（user 入力が前提）
- `git add` / `git commit` / `git push` / `git tag` / `gh pr create` / `gh pr merge`

以下は **AI 自律実行 OK**（書き込みなし or 完全保守的）：
- Phase 0 context load
- Phase 1 自動推定
- Phase 3 dry-run 実行（書き込みなし）
- Phase 6 `check-axiarch-health.sh` 実行（read-only 診断）

## エッジケース

| ケース | 挙動 |
|:--|:--|
| **現バージョン == アップグレード先** | 「アップグレード不要」と提示して終了 |
| **複数 major/minor 跨ぎ**（例 v1.6.0 → v1.11.0）| 中間版での段階適用も選択肢として提示 |
| **`.axiarch/version.json` 不在**（初回更新）| baseline 不在で差分検出不可、初回適用として進める旨を明示 |
| **複数 agent 検出 = 併用プロジェクト**（`.claude/settings.json` / `.codex/hooks.json` / `.agents/rules/prompt_pointer.md` のうち 2 つ以上が存在。例: inucomi = codex+claude+antigravity）| `--agent all` を推定値として提示する。1 つだけ選ばせてはいけない（選ばなかった agent の hook が計画から漏れ、アップグレードで stale 化するため）。`all` は全 agent の hook を REVIEW 可視化し、未使用 agent（cursor/copilot/windsurf）の pointer は `--safe-only` 下では書込されない。hook ファイル（mixed/review）の実更新は `--interactive` で各 agent 分をレビューする |
| **推定先 release 取得失敗**（network 不可 / repo 名間違い）| user に `--source` 指定を依頼 |

## 旧 Stop & Wait モードへのフォールバック

user が「自律推定せず、項目入力させて」と明示した場合のみ、旧 Stop & Wait モードに切り替える。それ以外は本 Hybrid モードを既定とする。
````
