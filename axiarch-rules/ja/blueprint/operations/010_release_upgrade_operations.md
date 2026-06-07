# 010. リリース・アップグレード運用ルール

> [!NOTE]
> このファイルは Axiarch本体で結晶化された共有Blueprint Ruleです。
> 採用先プロジェクトでは、manifestに明示された場合のみProject Stateとは分けてレビュー対象にします。
> `core/010_project_lessons_log.md` から自動結晶化されました。
> Created: 2026-05-17

> [!IMPORTANT]
> **Domain**: 運用
> **Location**: `blueprint/operations/010_release_upgrade_operations.md`
> **Related Universal Rules**: `universal/operations/400_site_reliability.md`, `universal/engineering/600_git_workflow.md`
> **12 sections.**

---

## 目次

| セクション | 内容 |
|:--|:--|
| §1 | CHANGELOG参照定義の同期 |
| §2 | Safe Upgrade dry-runの副作用禁止 |
| §3 | Safe Upgrade interactive入力の分離 |
| §4 | local-onlyファイルの明示レビュー |
| §5 | upgrade metadata版数の正規化 |
| §6 | fallbackと任意prompt証跡の同等性 |
| §7 | replace-if-local-unchangedの実行時保護 |
| §8 | ファイル/ディレクトリ型不一致のreview化 |
| §9 | source-onlyファイルの既定skipと明示選択 |
| §10 | 非対話EOF時の確認入力default N |
| §11 | 本体リリース中核ファイルのGit追跡確認 |
| §12 | 対話選択肢の重複排除 |

---

## §1 CHANGELOG参照定義の同期

### Context

v1.9.0正式化で `CHANGELOG.md` の先頭を `[Unreleased]` から `[1.9.0]` に変更した。

### Problem

`[Unreleased]` 見出しを削除した一方、末尾の `[Unreleased]: ...` 参照定義が残り、Markdown Lintの MD053 がCIで失敗した。

### Rule

`CHANGELOG.md` のリンク参照定義は実際の見出しと同期させる。正式リリース化で `[Unreleased]` 見出しを外す場合は `[Unreleased]: ...` 定義も削除する。

### Enforcement

`axiarch-scripts/check-axiarch-health.sh` Check 15 で Unreleased 見出しと参照定義の一致を検査する。

### Reference

`CHANGELOG.md`, `axiarch-scripts/check-axiarch-health.sh`, GitHub Actions run `25918646516`

---

## §2 Safe Upgrade dry-runの副作用禁止

### Context

v1.10.0 Safe Upgrade Wizardの追加監査で、3-way merge競合時のdry-run挙動とupgrade metadataの版数記録を確認した。

### Problem

`--interactive` のdry-runで3-way mergeを試した場合でも `.axiarch/conflicts/` へ競合ファイルを書き得る経路があった。また、`--source` 指定時のupgrade metadataがsource manifestの版数ではなく `local-source` になり得た。

### Rule

dry-runは計画と差分確認に限定し、競合ファイルなどの成果物を書かない。実際に書くのは `--apply` 時だけにする。local sourceから更新する場合も `axiarch-manifest.json` の `axiarchVersion` をmetadataへ記録し、アップグレード後の版管理を曖昧にしない。

### Enforcement

`axiarch-scripts/axiarch-upgrade.sh` はdry-run時の競合を報告だけに留め、`--apply` 時だけ `.axiarch/conflicts/` を書く。`--source` 指定時はsource manifestの `axiarchVersion` を `.axiarch/version.json` に反映する。

### Reference

`axiarch-scripts/axiarch-upgrade.sh`, `axiarch-manifest.json`, `axiarch-scripts/README.md`

---

## §3 Safe Upgrade interactive入力の分離

### Context

v1.10.0 Safe Upgrade Wizardの追加監査で、`--interactive` のグループ選択とファイル単位選択をパイプ入力で検証した。

### Problem

`collect_interactive_choices` が内部のグループ一覧を標準入力として読み込んでいたため、`choose_group_action` の `read` がユーザー入力ではなく内部入力を消費し、対話選択が成立しない経路があった。

### Rule

対話入力を受ける関数のstdinは、内部リスト走査の入力元と分離する。内部リストは別FDまたは配列で扱い、ユーザー入力用stdinを奪わない。

### Enforcement

`axiarch-scripts/axiarch-upgrade.sh` のグループ一覧ループはFD 3を使い、`choose_group_action` と `review_file_action` はユーザー入力用stdinを読める状態にする。

### Reference

`axiarch-scripts/axiarch-upgrade.sh`, `walkthrough.md`

---

## §4 local-onlyファイルの明示レビュー

### Context

ディレクトリ単位のSafe Upgradeでは、source側から削除・移動されたAxiarchファイルや、採用先の独自拡張ファイルがtarget側に残り得る。

### Problem

`cp -R` の重ねコピーだけではsource側に存在しないlocal-onlyファイルは削除されない。自動削除すると採用先の独自拡張を壊す恐れがある一方、黙って残すと古いAxiarchファイルがロード対象に残る恐れがある。

### Rule

ディレクトリ更新時はlocal-onlyファイルを自動削除しない。代わりに `STALE-LOCAL` として表示する。`--apply` 時はupgrade reportにも記録し、dry-run時は成果物を書かない。削除・保持・移植の判断は明示レビュー対象にする。

### Enforcement

`axiarch-scripts/axiarch-upgrade.sh` はディレクトリ更新前にsource側に存在しないtarget側ファイルを検出し、`STALE-LOCAL` として表示する。`ACTION_LOG` へも記録するが、永続化されるのは `--apply` で `.axiarch/upgrade-report.md` を書く場合のみとする。

### Reference

`axiarch-scripts/axiarch-upgrade.sh`, `axiarch-scripts/README.md`, `axiarch-prompts/ja/develop/safe_upgrade_execute.md`

---

## §5 upgrade metadata版数の正規化

### Context

v1.10.0 Safe Upgrade Wizardの追加監査で、`--source . --to v1.10.0 --safe-only --apply` を一時ディレクトリへ実行し、生成された `.axiarch/version.json` を確認した。

### Problem

`write_upgrade_metadata` が `TO_VERSION` をsource manifest版数より優先していたため、`version` に `v1.10.0` が記録された。Axiarch本体の正規版数は `init.sh`、`axiarch-manifest.json`、`CHANGELOG.md` で `1.10.0` として管理しているため、適用後metadataだけがタグ表記になり、後続の版数判定で表記揺れが残る恐れがあった。

### Rule

Safe Upgradeのmetadata版数は、source manifestの `axiarchVersion` を最優先する。`--to vX.Y.Z` や `--ref tags/vX.Y.Z` 由来の値しか使えない場合も、`.axiarch/version.json` に記録する版数ではタグ接頭辞 `v` を外し、Axiarch内部の正規版数表記へ揃える。

### Enforcement

`axiarch-scripts/axiarch-upgrade.sh` は `resolve_upgrade_version_label` と `normalize_axiarch_version_label` でmetadata版数を決定する。`check-axiarch-health.sh` Check 15 は、Safe Upgrade Wizardがmetadata版数正規化の実装配線を持つことを検査する。

### Reference

`axiarch-scripts/axiarch-upgrade.sh`, `axiarch-scripts/check-axiarch-health.sh`, `axiarch-manifest.json`, `.axiarch/version.json`

---

## §6 fallbackと任意prompt証跡の同等性

### Context

v1.10.0 Safe Upgrade Wizardの追加監査で、manifestを `jq` で読めないfallback経路と、`--with-prompts --apply` 時の `.axiarch/files.sha256` を確認した。

### Problem

manifest側の広域Project State globは `blueprint/*/[0-9][0-9][0-9]_*.md` により `core/` 配下の追加番号ファイルも保持対象にできるが、fallback側の探索対象が `ai/ design/ engineering/ operations/ product/ quality/ security/` に限られていた。このため、将来 `core/{NNN}_*.md` が追加された場合、manifestが読めない環境だけProject Stateとして拾えない恐れがあった。また、`--with-prompts` で任意promptを適用しても、hash証跡の対象が `AGENTS.md`、manifest、scripts、rulesに限られていた。

### Rule

manifestを読めないfallback経路でも、所有境界はmanifestと同等に近づける。`core/000`、`core/010`、テンプレートなど明示分類済みファイルは既存分類を維持し、追加の `core/{NNN}_*.md` はProject Stateとして保持対象にする。任意promptは必須ではないが、適用した場合は `.axiarch/files.sha256` にhashを残す。

### Enforcement

`axiarch-scripts/axiarch-upgrade.sh` のfallback discoveryは `core` を含むBlueprint初期フォルダを探索する。`write_upgrade_metadata` は `axiarch-prompts/` が存在する場合、hash証跡に含める。`check-axiarch-health.sh` Check 15 は、fallback core Blueprint検出と任意prompt証跡化の実装配線を検査する。

### Reference

`axiarch-scripts/axiarch-upgrade.sh`, `axiarch-scripts/check-axiarch-health.sh`, `axiarch-prompts/{ja,en}/develop/safe_upgrade_execute.md`, `.axiarch/files.sha256`

---

## §7 replace-if-local-unchangedの実行時保護

### Context

v1.10.0 Safe Upgrade Wizardの追加監査で、manifestに定義された `replace-if-local-unchanged` policyと実行側の分岐を照合した。

### Problem

manifestでは「ローカル所有が曖昧でない場合のみ自動更新し、それ以外はreview」と定義していたが、実行側に専用分岐がなかった。このため、`update-all` のようなグループ単位操作で、baseなし差分やbase不一致のテンプレート・共有Blueprintが無条件コピーに近い扱いになる恐れがあった。

### Rule

`replace-if-local-unchanged` は、targetが存在しない場合、または `--from` / `--from-ref` / `--base-source` で得たbaseとtargetが一致する場合のみ自動更新する。baseがない状態でtargetに差分がある場合、base側に対象パスが存在しない場合、またはbaseとtargetが一致しない場合はreviewへ倒す。review時は `no-base-diff` / `base-missing` / `base-mismatch` のreasonラベルをupgrade reportへ残す。

### Enforcement

`axiarch-scripts/axiarch-upgrade.sh` は `copy_replace_if_local_unchanged` で専用判定を行う。`safe-only` と `update-all` の両方でこのpolicyを無条件の `copy_path` に流さない。`check-axiarch-health.sh` Check 15 は、この専用分岐とreasonラベルが存在することを検査する。

### Reference

`axiarch-manifest.json`, `axiarch-scripts/axiarch-upgrade.sh`, `axiarch-scripts/check-axiarch-health.sh`

---

## §8 ファイル/ディレクトリ型不一致のreview化

### Context

v1.10.0 Safe Upgrade Wizardの追加監査で、sourceがディレクトリでtargetが同名ファイル、またはsourceがファイルでtargetが同名ディレクトリになるケースを一時ディレクトリで検証した。

### Problem

sourceディレクトリとtargetファイルの組み合わせでは、内部の `mkdir -p` が失敗し、そこまでに処理済みのファイルだけが更新される部分適用の恐れがあった。sourceファイルとtargetディレクトリの組み合わせでは、意図しない入れ子コピーや構造誤認につながる恐れがあった。

### Rule

sourceとtargetでファイル/ディレクトリの型が異なる場合は、自動削除・自動置換しない。`TYPE-CONFLICT` としてreviewへ倒し、target側の意味、source側の新構造、移植手順を明示してから判断する。

### Enforcement

`axiarch-scripts/axiarch-upgrade.sh` は `copy_path_has_type_conflict` で型不一致を検出し、通常の `copy_path` と `replace-if-local-unchanged` の両方で自動コピー前に止める。`check-axiarch-health.sh` Check 15 は、型不一致reviewの実装配線を検査する。

### Reference

`axiarch-scripts/axiarch-upgrade.sh`, `axiarch-scripts/check-axiarch-health.sh`, `axiarch-prompts/ja/develop/safe_upgrade_execute.md`

---

## §9 source-onlyファイルの既定skipと明示選択

### Context

v1.10.0 Safe Upgrade Wizardの追加監査で、`source_docs` グループのinteractive選択肢と実行分岐を照合した。

### Problem

`source_docs` はAxiarch本体リポジトリ専用ファイルであり既定skipが正しい。一方で、interactiveでは `show-diff` や `update-all` を選べる表示になっていたにもかかわらず、実行側では `policy=skip` が常に先に勝ち、ユーザーが明示選択しても差分表示や適用に進めなかった。これは「グループごとに選択する」Safe Upgradeの操作モデルと矛盾する。

Round30追加監査では、READMEの必須ファイル表で「採用先には不要」と説明している `CONTRIBUTING.md`、`SECURITY.md`、`CODE_OF_CONDUCT.md`、`LICENSE`、`.github/ISSUE_TEMPLATE/` などのリポジトリ管理用ファイルと、Axiarch本体のセットアップ用 `init.sh` が、manifestとfallbackの `source_docs` に含まれていないことも判明した。採用先へ既定コピーしない点では正しいが、Safe Upgradeがsource-onlyとして明示的に扱わないと、過去に丸ごとコピーされた採用先で不要ファイルが見えにくくなる。

### Rule

Source Repository Filesは既定では採用先へコピーしない。`--safe-only` や非対話実行ではskipを維持する。ただし、`--interactive` でユーザーが `show-diff`、`review-each`、`update-all` を明示的に選んだ場合は、その選択を尊重し、差分表示または明示適用に進める。READMEで採用先不要と説明するリポジトリ管理用ファイル、ソース専用ドキュメント、GitHub管理テンプレート、Axiarch本体のセットアップ用 `init.sh` は、manifestとfallbackの両方で `source_docs` / `skip` として分類する。

### Enforcement

`axiarch-scripts/axiarch-upgrade.sh` は `policy=skip` の項目を通常はskipするが、interactiveで明示的な非skip actionが選ばれた場合のみ `SOURCE-ONLY explicit-*` として記録し、選択されたactionへ進める。`check-axiarch-health.sh` Check 15 は、この明示overrideの実装配線と、installerおよびREADME-listed repo-only filesがmanifest/fallbackの両方でsource-only skipに分類されていることを検査する。

### Reference

`axiarch-manifest.json`, `axiarch-scripts/axiarch-upgrade.sh`, `axiarch-scripts/check-axiarch-health.sh`, `axiarch-scripts/README.md`, `README.md`, `axiarch-prompts/ja/develop/safe_upgrade_execute.md`

---

## §10 非対話EOF時の確認入力default N

### Context

v1.10.0 Safe Upgrade Wizardの追加監査で、`--apply` と `--interactive` を標準入力なしで実行し、確認プロンプトの挙動を確認した。

### Problem

`set -euo pipefail` の状態で `read -r answer` または `read -r choice` がEOFを受けると、確認入力を既定Nとして扱う前にスクリプトがexit 1で終了した。これは「非対話では安全に停止する」という意図に近いものの、dry-runへ戻る明示的な安全停止ではなく、CIやAIエージェント実行時に失敗として扱われる恐れがあった。

### Rule

Safe Upgrade Wizardの確認入力は、標準入力がEOFになっても失敗終了にしない。EOFは空入力として扱い、既定値に倒す。`--apply` の最終確認では既定Nとして `APPLY=false` / `DRY_RUN=true` に戻し、`--interactive` の最終確認でも既定Nとしてdry-run扱いにする。非対話で実際に適用する場合は、直前のdry-run結果を確認し、人間がapply実行を明示承認した上で `--yes` を明示する。

### Enforcement

`axiarch-scripts/axiarch-upgrade.sh` の確認入力は `read -r answer || answer=""` と `read -r choice || choice=""` でEOFを空入力化する。`check-axiarch-health.sh` Check 15 は、Safe Upgrade WizardがEOF-safeな確認入力defaultを持つことを検査する。

### Reference

`axiarch-scripts/axiarch-upgrade.sh`, `axiarch-scripts/check-axiarch-health.sh`, `axiarch-scripts/README.md`, `README.md`

---

## §11 本体リリース中核ファイルのGit追跡確認

### Context

v1.10.0 Safe Upgrade Wizardの追加監査で、`git diff --name-only` と `git diff --stat` が未追跡ファイルを表示しないことを確認した。今回のリリースでは `axiarch-manifest.json`、`axiarch-scripts/axiarch-upgrade.sh`、safe upgrade実行prompt日英、Operations Blueprint日英が新規ファイルとして追加された。

### Problem

新規ファイルが未追跡のまま残ると、tracked差分だけを見たレビューやリリース前確認では中核ファイルが見えない。特にmanifestとupgrade helperが欠けると、既存採用先へ必要分だけアップグレードする導線そのものが成立しない。

### Rule

Axiarch本体リポジトリでリリースする中核ファイルは、存在確認だけでなくGit tracking状態まで確認する。`axiarch-manifest.json`、Safe Upgrade Wizard、safe upgrade実行prompt、共有Operations Blueprintのようなリリース成立に必要な新規ファイルは、未追跡のまま最終検証を通過させない。採用先プロジェクトではこの検査を行わない。

### Enforcement

`axiarch-scripts/check-axiarch-health.sh` Check 15 は、Axiarch本体リポジトリかつGit worktree内の場合に、v1.10.0中核ファイルが `git ls-files` で追跡対象になっているかを検査する。未追跡または欠落があればHealthを失敗させる。

### Reference

`axiarch-scripts/check-axiarch-health.sh`, `axiarch-manifest.json`, `axiarch-scripts/axiarch-upgrade.sh`, `axiarch-prompts/ja/develop/safe_upgrade_execute.md`, `axiarch-prompts/en/develop/safe_upgrade_execute.md`

---

## §12 対話選択肢の重複排除

### Context

v1.10.0 Safe Upgrade Wizardの追加監査で、`source_docs` グループの既定actionが `skip` の状態で `--interactive` を実行し、ユーザーに表示される選択肢を確認した。

### Problem

`choose_group_action` は1番にdefault actionを表示しつつ、固定候補として `skip` も常に表示していた。そのためdefault actionが `skip` のグループでは、同じ実効actionが1番と5番に重複表示され、どちらを選ぶべきか曖昧に見える状態だった。これはsource-onlyを既定skipしつつ、必要時だけ明示選択させるSafe Upgradeの操作モデルを弱くする。

### Rule

対話式のグループ選択では、同じ実効actionを複数の番号で表示しない。1番にdefault actionを置く場合、固定候補からdefault actionと同じものを除外する。番号とactionの対応は表示後の配列や明示マップから解決し、選択肢の表示順や候補数が変わっても、ユーザー入力が別actionへずれないようにする。

### Enforcement

`axiarch-scripts/axiarch-upgrade.sh` は `choose_group_action` で `option_actions` を動的に組み立て、default actionと同じ固定候補を除外してから番号を割り当てる。`check-axiarch-health.sh` Check 15 は、Safe Upgrade Wizardが対話選択肢の動的action mapを持つことを検査する。

### Reference

`axiarch-scripts/axiarch-upgrade.sh`, `axiarch-scripts/check-axiarch-health.sh`, `task.md`, `walkthrough.md`
