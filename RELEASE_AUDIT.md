# リリース履歴の監査と訂正 / Release history audit and corrections

監査日: 2026-09-14。v1.0.0からv1.17.0までの公開30版、タグ30件、GitHub生成のtar.gz・zip各30件を照合した。公開説明の訂正は配布済みコードの修正ではない。以下は監査時点の結果であり、今後の公開状態や各エージェントの動作を保証しない。

Audit date: 2026-09-14. Covers all 30 published versions from v1.0.0 through v1.17.0, their tags and both GitHub-generated archive formats. Editing release descriptions does not patch previously distributed code. These are observations at the audit date, not guarantees of future public state or agent behavior.

## 確認結果 / Findings

| ID | 対象 / Scope | 訂正・対応 / Correction and action |
|:--|:--|:--|
| R1 | v1.1.0、v1.2.0、v1.3.1 | installerの版数は順に1.0.0、1.0.0、1.3.0のままだった。タグ内容の版を表示値だけで判断しない。公開タグを移動せず、旧版の説明に誤記を明示する。 / Installer versions remained 1.0.0, 1.0.0 and 1.3.0 respectively. Record the mismatch without rewriting tags. |
| R2 | v1.0.0–v1.8.2 | 旧installerの取得URLはmain固定。タグから取得したinit.shでもそのタグの内容を導入する保証はない。旧版再現はタグのアーカイブを確認し、現行導入・移行は取得元を固定して差分確認する。 / Old installers fetch main, so a tagged launcher does not pin its payload. Inspect tag archives for historical reproduction and use pinned, reviewed sources for current migration. |
| R3 | v1.3.0、v1.8.0 | フォルダ変更・scripts改名を破壊的変更と記載しつつminor版で公開していた。これは現在のSemVer方針に整合しない履歴として扱う。タグ番号を後から付け替えず、外部参照・フック・CIの移行を確認する。 / These minor releases explicitly changed public paths incompatibly. Preserve the historical versions and document migration; do not portray them as precedent for compatible minor changes. |
| R4 | v1.3.1–v1.8.2、v1.11.1–v1.11.2等 / and related historical claims | 「後方互換性100%」「無害」「物理的に手順遵守を強制」「トークン費用が無視可能」等は、全環境の検証で裏付けた表現ではない。フック入力・対象操作・導入構成ごとの実挙動と、AIの手順遵守を分ける。関連研究の阻止率や旧版のtoken試算はAxiarch全体の性能実測ではない。 / Universal compatibility, harmlessness, forced procedural adherence and negligible-cost claims are not established across environments. Separate configured hook behavior from agent compliance; external research and historical token estimates are not Axiarch-wide benchmarks. |
| R5 | v1.15.0、v1.16.0 | v1.15.0本文と両版のソース内にあるCodex・Claude Code実証済みの説明を現行根拠にしない。コミット作成者・アダプター・隔離テストは実務実証の代用ではない。Google Antigravityのみ実証済み、他は未実証・動作保証なしという訂正を公開ページにも置く。 / Supersede all-agent validation claims inherited by these versions. Commit authorship, adapters and isolated tests do not establish practical validation. Only Antigravity is practically validated; others remain unverified without operation guarantees. |
| R6 | v1.0.0–v1.15.0 / v1.16.0以降 / onward | 全タグはannotatedだが、前28版は未署名。v1.16.0・v1.17.0の2タグだけ、保存済み公開鍵registryでSSH署名を検証した。現行の署名・同一SHA品質ゲートを過去版の保証に遡及しない。 / All tags are annotated; the first 28 are unsigned. SSH signatures on v1.16.0 and v1.17.0 were verified against the retained public-key registry. Current signing and same-commit quality gates do not retroactively cover earlier releases. |
| R7 | v1.12.0、v1.12.1 | v1.12.0の詳細は英語中心、v1.12.1は日本語説明が無かった。日本語の成果・互換性の要約を追補する。 / Add Japanese outcome and compatibility summaries where the original detail was English-dominant or English-only. |
| R8 | v1.15.0 | 追加された5規則の説明が抜けていた。batch/backfill、data reconciliation、caching、data contracts、capacity planningの日英各5ファイルが追加され、Universalは各言語45→50になった。下記パス一覧とタグ差分を追補する。 / The notes omitted five new rules per language, expanding Universal rules from 45 to 50. Add the paths and their purpose below. |
| R9 | v1.17.0 / 現行管理経路 / current tooling | 主な成果・移行・検証が細かな監査追記に埋もれていた。本文を7項目へ整理し、公開後のPR #65を含まないことを明記する。構造検査・抽出・リンク補完をCIへ接続する。 / Reorganize the notes around outcomes, migration and verification; distinguish post-release PR #65 and add shared checks/extraction with self-contained links. |
| R10 | 現行scripts README / current scripts README | セッション別の記録分離をv1.11.0の機能とする説明を訂正。v1.11.0はルートの現在タスク文書ローテーション、v1.17.0が共有タスクとセッション文書の分離を導入した。 / Correct the introduction version: v1.11.0 rotated root task documents; v1.17.0 introduced shared task state and separate session documents. |

### v1.15.0の追加規則 / Rules omitted from the v1.15.0 notes

以下は当該タグで確認した日英共通の相対パスで、先頭の言語は `ja` / `en` を選ぶ。 / These paths exist under both language roots in the tag.

- `axiarch-rules/{lang}/universal/engineering/700_batch_backfill_operations.md`: バッチ・再実行・途中再開 / Batch execution, retries and resumption.
- `axiarch-rules/{lang}/universal/engineering/710_data_reconciliation.md`: データ突合・差分分類・修復 / Data reconciliation, discrepancy classification and repair.
- `axiarch-rules/{lang}/universal/engineering/730_caching_discipline.md`: キャッシュの鮮度・無効化・所有境界 / Cache freshness, invalidation and ownership.
- `axiarch-rules/{lang}/universal/engineering/740_data_contracts.md`: データ契約・schema変更・互換性 / Data contracts, schema changes and compatibility.
- `axiarch-rules/{lang}/universal/operations/650_capacity_planning.md`: 容量・需要・余力・増設判断 / Capacity, demand, headroom and scaling decisions.

### 日本語追補 / Japanese-language addenda

v1.12.0は、正本をAGENTS.mdからAXIARCH.mdへ移し、旧入口を薄いアダプターとして保持した。実行・監査・証拠・承認を扱うハーネスを追加し、言語設定を含むAXIARCH.mdを更新時の個別レビュー対象にした。既存仕様・独自設定を保持して更新差分を確認する。

v1.12.0 moved canonical guidance into AXIARCH.md, retained adapters and added the execution harness. AXIARCH.md requires review during upgrades because it includes adopter language settings.

v1.12.1は、ハーネスを独立した第4層とせず、3層の実行手順として説明し直した修正版。更新時のグループ表示と版固定の取得案内、healthの説明検査、配布メタデータを同期した。v1.12.0のタグは上書きしていない。

v1.12.1 clarified that the harness executes the three-layer model rather than adding a fourth layer, and aligned upgrade labels, pinned guidance, health checks and release metadata without replacing v1.12.0.

## 全版の照合表 / Complete version inventory

全60アーカイブで、タグ内の全ファイルのGit blobハッシュと通常／実行ファイルの権限が一致した。追加添付assetは全版0件。管理記録の予約ディレクトリがGitツリーに含まれないことも確認したが、任意の本文に含まれる機密情報の網羅検知ではない。

All 60 archives matched the tagged Git blob hashes and file modes. No release had separately uploaded assets. Reserved task/session/recovery directories were absent from the Git trees; this is not exhaustive secret detection in arbitrary file contents.

| 版 / Version | 対象commit / Commit | ファイル数 / Files | installer版 / Installer version | manifest版 / Manifest version | 署名 / Signature |
|:--|:--|--:|:--|:--|:--|
| [v1.0.0](https://github.com/hiroyuki-miyauchi/axiarch/releases/tag/v1.0.0) | `8a4ff7f5` | 165 | 1.0.0 | 未導入 / absent | 未署名 / unsigned |
| [v1.1.0](https://github.com/hiroyuki-miyauchi/axiarch/releases/tag/v1.1.0) | `34e66c72` | 166 | 1.0.0 | 未導入 / absent | 未署名 / unsigned |
| [v1.2.0](https://github.com/hiroyuki-miyauchi/axiarch/releases/tag/v1.2.0) | `741863ab` | 167 | 1.0.0 | 未導入 / absent | 未署名 / unsigned |
| [v1.3.0](https://github.com/hiroyuki-miyauchi/axiarch/releases/tag/v1.3.0) | `6a98fc76` | 173 | 1.3.0 | 未導入 / absent | 未署名 / unsigned |
| [v1.3.1](https://github.com/hiroyuki-miyauchi/axiarch/releases/tag/v1.3.1) | `f84d391f` | 173 | 1.3.0 | 未導入 / absent | 未署名 / unsigned |
| [v1.3.2](https://github.com/hiroyuki-miyauchi/axiarch/releases/tag/v1.3.2) | `8e538252` | 176 | 1.3.2 | 未導入 / absent | 未署名 / unsigned |
| [v1.4.0](https://github.com/hiroyuki-miyauchi/axiarch/releases/tag/v1.4.0) | `9727c3d4` | 177 | 1.4.0 | 未導入 / absent | 未署名 / unsigned |
| [v1.5.0](https://github.com/hiroyuki-miyauchi/axiarch/releases/tag/v1.5.0) | `b9b98c7d` | 177 | 1.5.0 | 未導入 / absent | 未署名 / unsigned |
| [v1.5.1](https://github.com/hiroyuki-miyauchi/axiarch/releases/tag/v1.5.1) | `c168f7d3` | 179 | 1.5.1 | 未導入 / absent | 未署名 / unsigned |
| [v1.5.2](https://github.com/hiroyuki-miyauchi/axiarch/releases/tag/v1.5.2) | `329fe33e` | 179 | 1.5.2 | 未導入 / absent | 未署名 / unsigned |
| [v1.5.3](https://github.com/hiroyuki-miyauchi/axiarch/releases/tag/v1.5.3) | `8670579c` | 180 | 1.5.3 | 未導入 / absent | 未署名 / unsigned |
| [v1.5.4](https://github.com/hiroyuki-miyauchi/axiarch/releases/tag/v1.5.4) | `06b78e9a` | 180 | 1.5.4 | 未導入 / absent | 未署名 / unsigned |
| [v1.5.5](https://github.com/hiroyuki-miyauchi/axiarch/releases/tag/v1.5.5) | `5b6d18f4` | 182 | 1.5.5 | 未導入 / absent | 未署名 / unsigned |
| [v1.6.0](https://github.com/hiroyuki-miyauchi/axiarch/releases/tag/v1.6.0) | `00b2e787` | 182 | 1.6.0 | 未導入 / absent | 未署名 / unsigned |
| [v1.8.0](https://github.com/hiroyuki-miyauchi/axiarch/releases/tag/v1.8.0) | `a273b931` | 182 | 1.8.0 | 未導入 / absent | 未署名 / unsigned |
| [v1.8.1](https://github.com/hiroyuki-miyauchi/axiarch/releases/tag/v1.8.1) | `9a9c55c0` | 182 | 1.8.1 | 未導入 / absent | 未署名 / unsigned |
| [v1.8.2](https://github.com/hiroyuki-miyauchi/axiarch/releases/tag/v1.8.2) | `8d41d9b7` | 183 | 1.8.2 | 未導入 / absent | 未署名 / unsigned |
| [v1.9.0](https://github.com/hiroyuki-miyauchi/axiarch/releases/tag/v1.9.0) | `007bbee7` | 186 | 1.9.0 | 未導入 / absent | 未署名 / unsigned |
| [v1.10.0](https://github.com/hiroyuki-miyauchi/axiarch/releases/tag/v1.10.0) | `aaf3fb3b` | 192 | 1.10.0 | 1.10.0 | 未署名 / unsigned |
| [v1.11.0](https://github.com/hiroyuki-miyauchi/axiarch/releases/tag/v1.11.0) | `ff3654c2` | 193 | 1.11.0 | 1.11.0 | 未署名 / unsigned |
| [v1.11.1](https://github.com/hiroyuki-miyauchi/axiarch/releases/tag/v1.11.1) | `3ab4ddd1` | 193 | 1.11.1 | 1.11.1 | 未署名 / unsigned |
| [v1.11.2](https://github.com/hiroyuki-miyauchi/axiarch/releases/tag/v1.11.2) | `8cd7004a` | 193 | 1.11.2 | 1.11.2 | 未署名 / unsigned |
| [v1.12.0](https://github.com/hiroyuki-miyauchi/axiarch/releases/tag/v1.12.0) | `ff20d216` | 207 | 1.12.0 | 1.12.0 | 未署名 / unsigned |
| [v1.12.1](https://github.com/hiroyuki-miyauchi/axiarch/releases/tag/v1.12.1) | `377a4bba` | 207 | 1.12.1 | 1.12.1 | 未署名 / unsigned |
| [v1.13.0](https://github.com/hiroyuki-miyauchi/axiarch/releases/tag/v1.13.0) | `f6ce952a` | 208 | 1.13.0 | 1.13.0 | 未署名 / unsigned |
| [v1.13.1](https://github.com/hiroyuki-miyauchi/axiarch/releases/tag/v1.13.1) | `60104daa` | 208 | 1.13.1 | 1.13.1 | 未署名 / unsigned |
| [v1.14.0](https://github.com/hiroyuki-miyauchi/axiarch/releases/tag/v1.14.0) | `9d258dc1` | 220 | 1.14.0 | 1.14.0 | 未署名 / unsigned |
| [v1.15.0](https://github.com/hiroyuki-miyauchi/axiarch/releases/tag/v1.15.0) | `8794b37d` | 232 | 1.15.0 | 1.15.0 | 未署名 / unsigned |
| [v1.16.0](https://github.com/hiroyuki-miyauchi/axiarch/releases/tag/v1.16.0) | `0eb6d1f8` | 240 | 1.16.0 | 1.16.0 | 検証済み / verified |
| [v1.17.0](https://github.com/hiroyuki-miyauchi/axiarch/releases/tag/v1.17.0) | `89dee831` | 270 | 1.17.0 | 1.17.0 | 検証済み / verified |

v1.7.0は内部開発分で、独立したタグ・Releaseは存在しない。v1.8.0へ統合したというCHANGELOGと一致する。公開本文は29版が当時のCHANGELOG節と一致し、v1.0.0だけ文書冒頭の共通前書きも含んでいた。内容一致は説明の十分性や正しさを示すものではない。

v1.7.0 has no separate public tag or Release; its changes shipped in v1.8.0 as documented. Before this correction, 29 release bodies matched their tagged changelog section; v1.0.0 also included the document preamble. Matching text is not proof that the description is sufficient or accurate.

## 管理ファイルの確認 / Maintainer-file review

| 対象 / Files | 確認・変更 / Review and change |
|:--|:--|
| `CHANGELOG.md`、`ROADMAP.md` | 公開済み・未公開の区分、比較先、日英案内、過去表記の訂正導線。 / Released/unreleased boundaries, comparisons, bilingual guidance and correction references. |
| `.github/workflows/release.yml`、`.github/workflows/lint.yml` | 同一SHA品質検査、署名、版数整合、既存タグ不変、tagのみ成功した状態の復旧を保持。本文の構造・抽出を共有する。 / Preserve existing quality/signing/version/recovery gates and share note checks/extraction. |
| `init.sh`、`axiarch-manifest.json`、`README.md`、`llms.txt`、`llms-full.txt` | 現行の版と固定ref、選択言語、配布範囲を既存実行回帰・版数検査で確認。監査文書は採用先へ既定配布しない。 / Check versions, pinned refs, languages and payload boundaries; audit documents remain source-only. |
| `axiarch-scripts/README.md`、`axiarch-scripts/axiarch-upgrade.sh` | 移行案内と実装の終了値・取得・helper配布を突合。記録分離の導入版を訂正。 / Reconcile migration guidance with exit statuses and helper/source handling; correct the record-isolation introduction version. |
| `axiarch-prompts/{ja,en}/develop/safe_upgrade_execute.md`、`axiarch-rules/{ja,en}/blueprint/INDEX.md`、`axiarch-rules/{ja,en}/blueprint/operations/010_release_upgrade_operations.md` | 現行版、所有区分、承認済み範囲の適用、部分更新・既存状態保持を確認。 / Check current-version references, ownership, authorized scope and partial-upgrade preservation. |
| `CONTRIBUTING.md`、`RELEASING.md`、`tests/release_notes.py`、`tests/test_release_notes.py` | 公開手順、説明だけの訂正とコード変更の区分、必須内容、検査の限界、失敗例の回帰を接続。 / Connect publication/correction procedure, content requirements, structural limits and failure regressions. |

## 検証の限界 / Verification limits

旧タグ内のコードは改変も再公開もしていない。全版のソース同一性と説明を点検したが、全旧版を各製品・各OSで実務運用し直したわけではない。旧版の外部製品・法令・研究・性能値は当時の記述として扱い、現在の採用判断では一次資料を再確認する。CIの緑表示から、文章の意味・翻訳の十分性・すべての脆弱性不在を推定しない。

Historical code and tags remain unchanged. Source identity and release descriptions were audited; every old version was not re-operated on every product and OS. Historical product, legal, research and performance statements are not current adoption advice. Recheck primary sources when applying them. Green CI does not establish semantic accuracy, complete translation or absence of vulnerabilities.
