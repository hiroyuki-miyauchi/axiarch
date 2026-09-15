# Axiarchのリリース管理 / Maintaining Axiarch releases

本書はAxiarch本体の管理者向け手順であり、採用先への追加の必須手続きではない。版数、配布コード、変更説明、検証結果を対応させ、更新する利用者が判断できる状態にする。歴史的な不整合と訂正は [RELEASE_AUDIT.md](RELEASE_AUDIT.md) に記録する。

This is the maintainer procedure for Axiarch itself, not an additional requirement for adopter projects. Version numbers, distributed code, change descriptions and verification evidence must agree so users can assess an upgrade. Historical corrections are recorded in the audit above.

## 版の決め方と対象 / Version selection and scope

- 判断対象は公開パス、CLI・終了値、設定、保存形式、必須手順などの利用者との契約。後方互換の機能追加はminor、不具合修正はpatch。非互換の契約変更はmajorとして移行を説明する。ファイル数や作業量だけでは決めない。
- Evaluate public paths, CLI/exit behavior, configuration, storage formats and mandatory procedures. Use minor for compatible additions, patch for fixes and major for incompatible contract changes with migration instructions. File counts do not determine the version.
- 文書だけの訂正は既存Release本文とmainの説明を改訂し、日付・理由・対象を残せる。配布コードの変更はUnreleasedへ置き、次の承認された版で公開する。既存タグを移動せず、後続コミットの成果を旧タグに含めない。
- Documentation corrections may revise the existing release body and main documentation with a date, reason and scope. Code changes remain Unreleased until the next authorized release. Never move an existing tag or attribute later changes to an earlier tag.
- [SemVer 2.0.0](https://semver.org/spec/v2.0.0.html)を適用する。v1.3.0・v1.8.0等の過去の番号付けは、今後の非互換minor公開を正当化する前例にしない。
- Apply SemVer; historical incompatible minor releases are not precedents for future version selection.

リリース準備ブランチでは対象版のメタデータ・日付・タグ参照を揃えるが、GitへのpushやPR作成を公開済みとは扱わない。版見出しの日付はリリース対象日の記録で、GitHubのpublished_atとは別に確認する。マージ・タグ・公開の承認範囲を確認し、公開前の導入は既存の公開タグまたは明示的に選んだ候補コミットを使う。

Release-preparation branches align the target version, date and tag references; a push or PR is not publication. The section date records the intended release date and is checked separately from GitHub's published_at. Confirm authorization for merging, tagging and publication. Before publication, installations use an existing published tag or an explicitly selected candidate commit.

## CHANGELOGに必要な内容 / Required changelog content

v1.17.0以降の公開節は次の見出しを使用する。追加・変更・修正が無い欄は日英で「該当なし」と説明できる。Unreleasedは準備中の記録なので、この完成書式を要求しない。旧版の書式は改変せず、訂正を追記として区別する。

Released sections from v1.17.0 onward use these headings. A category with no changes may explicitly say so in both languages. Unreleased work does not need publication-ready content. Preserve older formats and identify later corrections as addenda.

| 見出し / Heading | 内容 / Content |
|:--|:--|
| `概要 / Overview` | 前版に対して何が変わり、誰に役立つか。 / The outcome relative to the previous release and its intended users. |
| `追加 / Added` | 新しい能力、入口となるパス。 / New capabilities and entry paths. |
| `変更 / Changed` | 既存の規則・処理で変わる挙動。 / Changes to existing rules and behavior. |
| `修正 / Fixed` | 発生条件、以前の問題、修正後の挙動。 / Triggers, prior defects and corrected behavior. |
| `互換性と更新 / Compatibility and upgrade` | 影響を受ける構成、調整・更新手順、保持する固有状態、保留時の対応。 / Affected configurations, migration, retained project state and handling of pending work. |
| `検証と限界 / Verification and limits` | 検査したcommit・環境・結果と証拠。失敗・再実行・未検証も記載。 / Tested commit, environment, outcome and evidence, including failures, retries and unverified scope. |
| `比較と関連情報 / References` | 前公開版との比較、PR、固定版の手順、後から訂正した場合の日付。 / Previous-release comparison, PRs, pinned instructions and correction dates. |

実タグ差分から追加・削除・変更を確認し、新設ファイルや互換性への影響を説明へ対応させる。内部の作業順、担当ID、生ログをそのまま利用者向け説明にしない。英語側も要点と移行・限界を読めるようにし、特定法域の判断を一律に翻訳して適用しない。

Review additions, removals and changes against the actual tag range and map new files and compatibility impacts to the notes. Do not publish raw task chronology, internal IDs or logs as release prose. Both languages must convey outcomes, migration and limitations with jurisdiction-sensitive applicability.

## 検査から公開まで / From validation to publication

1. 変更をレビューし、承認された公開候補の先頭節を日付付きの版見出しにする。CHANGELOG、installer、manifest、ROADMAP、README、llms、配布ref、日英indexを整合させる。 / Review the authorized candidate and align the dated release section and all release metadata.
2. 下記の本文検査と隔離回帰を行う。CIではMarkdown、ShellCheck、health、日英対称性も実行する。Ubuntu・macOSと、[Windows native診断・WSL 2回帰](axiarch-scripts/WINDOWS.md)が共通品質検査の対象。PRの成功とマージ後のmainの成功は別に確認する。 / Run note checks and isolated regressions on Ubuntu/macOS and the Windows native-diagnostic/WSL 2 path, alongside Markdown, ShellCheck, health and bilingual checks. Verify PR checks and post-merge main checks separately.
3. `.github/workflows/release.yml` は同じSHAの再利用可能な品質workflow成功を待つ。先頭がUnreleasedなら公開しない。版数・固定ref・署名鍵registry・既存タグとReleaseの状態を確認してから署名付きannotated tagとReleaseを作る。 / The release workflow requires same-SHA quality success, skips Unreleased, validates metadata and release state, then creates the signed tag and Release.
4. 公開後はremote tag object、署名、対象commit、本文、draft/prerelease、最新Releaseを照合し、公開アーカイブの内容と導入を確認する。workflowが照合する項目だけで配布内容の実行検証まで済んだと扱わない。 / Verify remote identity, signatures, notes and release flags, then inspect and exercise the public archive; workflow convergence checks alone do not perform all archive/runtime verification.

```bash
python3 tests/release_notes.py
python3 -m unittest discover -s tests -p 'test_*.py' -v
# 対象版に置換し、公開される本文を確認 / Replace with the candidate version and review the rendered body
python3 tests/release_notes.py --version 1.17.0 --output /tmp/axiarch-release-preview.md
```

上の版は実行例で、以後の公開候補へ自動追従しない。本文検査は実際のMarkdownの見出し・日付・重複・比較参照・各欄の日英記入・単独の未記入マーカーを確認し、指定版だけを抽出する。コード枠やコメントの例示を版見出しとして扱わない。文章の意味、完全な翻訳、主張とコードの対応はレビュー対象であり、この検査の保証に含めない。

The example version is illustrative, not a moving release target. The checker validates real headings, dates, duplicates, comparison references, bilingual section presence and standalone placeholders, then extracts only the selected release. Fenced/commented examples do not select a release. Semantic accuracy, complete translation and correspondence with code require review.

## 失敗と訂正の扱い / Failures and corrections

タグ作成前の失敗は原因を修正して再検査する。タグだけ作成済みなら、タグ対象と同じcommitのworkflow再実行でRelease作成を復旧する。タグとReleaseが完成済みなら、後続mainは同じ版を作り直さない。署名・タグの型・版数・APIの不整合を、タグ削除や強制pushで回避しない。

Fix and revalidate failures before tagging. Recover tag-only partial publication by rerunning the exact tagged commit. A completed tag/Release pair is not recreated by later main commits. Do not bypass signature, object-type, version or API checks by deleting tags or force-pushing.

公開済み本文を訂正する場合は、元のAPI応答とタグ対象を保存し、改訂本文をレビューしてから本文だけを更新する。再取得で本文一致とタグ・公開状態の保持を確認する。通常workflowは既存本文を自動上書きしないため、mainのCHANGELOGを直しただけで公開ページまで直ったとは報告しない。ログや復旧資料の公開は、秘密・個人情報を除いた説明に限定する。

For a published-body correction, retain the original API response and tag identity, review the revised body, update only the description and reread it to verify content and unchanged release state. Normal automation does not overwrite existing bodies; editing main's changelog is not proof that the public page changed. Publish sanitized explanations rather than raw logs or recovery material.
