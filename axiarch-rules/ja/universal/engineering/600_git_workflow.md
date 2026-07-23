# 600. Git Workflow & Repository Hygiene（Git ワークフローとリポジトリ衛生）

> **Primary Directive**: 「Git は履歴であり、履歴は資産である。日常運用の不衛生は資産毀損につながる」
>
> **優先順位**: Repository Integrity > Daily Workflow Velocity > Tool Compatibility > Convenience

このファイルは、**日常的な開発・通常作業・upload で発生するドメイン非依存の Git 操作** を集約する Universal Rule である。
ドメイン固有の Git 利用（セキュリティ署名・GitOps・QA hooks 等）は各ドメインファイルに残置し、本ファイルからクロスリファレンスする。

## Universal適用契約

本ファイルで不変なのは、履歴integrity、変更の追跡可能性、ownerと承認、再現可能な統合、復旧可能性、並行作業の隔離である。branch名、寿命、diff行数、commit形式、merge方式、承認人数、SLA、hook、hosting service、AI tool、通知先は、法令・契約・公式platform制約または明示した安全根拠がない限り参考実装またはBlueprint parameterとして扱う。Pull Request、GitHub、CODEOWNERS、merge queue等を使わない環境でも、同等の変更提案、独立承認、ownership、直列化、証跡、rollback能力を満たせば適合する。個人・小規模teamは役割を兼務できるが、高保証変更では可能な限り提案と承認を分離し、分離できない場合はrisk acceptanceと独立したrelease統制を置く。

---

## 目次 (Table of Contents)

| # | パート | セクション | ルール数 |
|---|---|---|---|
| 1 | Trunk-Based Development | §1.0 – §1.2 | 3 |
| 2 | Commit & PR Standards | §2.0 – §2.10 | 11 |
| 3 | Branch Hygiene Mandate | §3.0 – §3.1 | 2 |
| 4 | Worktree Hygiene Protocol | §4.0 – §4.4 | 5 |
| 5 | Repository Hygiene & Config Integrity | §5.0 – §5.1 | 2 |
| 6 | Branch Protection & Code Review | §6.0 – §6.4 | 5 |
| 7 | Tags, Releases & History Operations | §7.0 – §7.6 | 7 |
| 8 | Repository Configuration & Assets | §8.0 – §8.3 | 4 |
| 9 | Modern Tooling & Automation | §9.0 – §9.4 | 5 |
| 10 | Anti-Pattern Catalog | §10.0 | 1 |
| | | **合計** | **45** |

---

## このファイルの守備範囲（Scope Manifesto）

✅ **抽出基準（含める）**:

- 日常的な開発・通常作業・upload で発生する Git 操作
- ブランチ・コミット・worktree・push/pull・PR 等の workflow
- ドメイン非依存の Git ベストプラクティス

❌ **残置基準（含めない・各ドメインファイル参照）**:

- SLSA / Sigstore → `security/200_oss_compliance.md`
- Git history scrubbing for IP → `security/300_ip_due_diligence.md`
- GitOps deployment → `operations/400_site_reliability.md`
- Hot-fix branch protocol → `operations/500_incident_response.md`
- Pre-commit hooks for tests → `quality/000_qa_testing.md`
- DB Migration Immutability → `engineering/200_supabase_architecture.md`（暫定で `engineering/000` §10.4 に滞在）

> **責任分界の補足（Commit / Tag 署名）**: Git 側の how-to（`git config gpg.format`, `git commit -S`, 署名鍵セットアップ）は **§7.1**（本ファイル）。鍵管理・ローテーション・コンプライアンスポリシーは **`security/000_security_privacy.md`**。両者を併用すること。

---

## Part 1: Trunk-Based Development（トランクベース開発）

### 1.0. トランクベース開発（Principle）

- **原則**: 統合差分を小さく保ち、未統合期間と競合riskを測定する。trunk-based development、release branch、stacked diff等の方式は、製品のrelease model、規制、複数version保守、hardware／mobile審査、offline開発の制約からBlueprintで選ぶ。
- **短期統合**: 短命branchと頻繁な統合は通常の既定だが、日次や固定寿命をUniversal要件にしない。長期branchが必要ならowner、同期方法、security fixのbackport、終了条件を持つ。

### 1.1. ブランチ命名規約

- **Branch Naming Standard**: repositoryまたは組織で機械検証可能な命名schemaを一つ定義し、purpose、work itemまたはrelease intentを追跡可能にする。`type/summary`は参照形式である。
- **Types（§2.0 Conventional Commits と完全整合）**:
    - 開発系: `feat/`, `fix/`, `refactor/`, `perf/`
    - 補助系: `docs/`, `style/`, `test/`, `build/`, `ci/`, `chore/`
    - 履歴系: `revert/<reverted-sha>`
    - リリース系: `release/v1.4.0`（リリース凍結用）, `hotfix/critical-auth-bug`（本番緊急修正用）
    - 探索系: `experiment/`, `spike/`
- **Summary 規律**: 人名や秘密情報を含めず、利用中toolとUnicode方針に適合する短い識別子を使う。kebab-case、英小文字、3〜5語は参照既定である。
- **Anti-Pattern**: owner、目的、終了条件を追跡できない一時branchと、保護対象を回避する命名は禁止する。

### 1.2. 短命ブランチの強制

- **Law**: branchのage、base divergence、未解決競合、security patch遅延を可視化し、Blueprintのrisk budgetを超えたbranchへownerと解消計画を要求する。
- **Action**: 大きな変更は互換性shim、branch by abstraction、feature flag、stacked diff、段階migration等から適切な手段を選び、未完成機能を安全に統合または隔離する。固定2日やfeature flagだけを唯一解にしない。

---

## Part 2: Commit & PR Standards（コミットとPR標準）

### 2.0. Conventional Commits

- **Format**: release note、automation、auditがchange intentを再現できるcommit schemaをrepositoryで定義する。Conventional Commitsの`type(scope): subject`はSemVer自動化に適した参照実装であり、他の検証可能なschemaも許容する。
- **Standard Types（Conventional Commits 1.0.0 完全準拠）**:

    | Type | 用途 | SemVer 影響 |
    |---|---|---|
    | `feat` | 新機能追加 | **minor bump** |
    | `fix` | バグ修正 | **patch bump** |
    | `refactor` | 外部挙動を変えないコード改善 | なし |
    | `perf` | パフォーマンス改善（外部挙動不変） | patch bump（推奨） |
    | `docs` | ドキュメントのみ変更 | なし |
    | `style` | コードスタイル（フォーマッタ・空白・セミコロン等、ロジック不変） | なし |
    | `test` | テストコードの追加・修正 | なし |
    | `build` | ビルドシステム・外部依存関係（npm/cargo/poetry 等）の変更 | なし |
    | `ci` | CI 設定・スクリプトの変更 | なし |
    | `chore` | 上記いずれにも該当しない雑務（リネーム・整理等） | なし |
    | `revert` | 過去コミットの取り消し（`git revert` 連動） | コンテキスト依存 |
- **Breaking Change の表現**: 件名末尾に `!` を付与する（例: `feat(api)!: drop /v1 endpoints`）、または本文に `BREAKING CHANGE: <description>` トレイラーを入れる（§2.8 参照）。**いずれかが必須**で SemVer **major bump** をトリガー。
- **Scope（任意だが推奨）**: 影響範囲を明示（例: `feat(auth):`, `fix(api):`, `refactor(db):`）。モノレポでは workspace 名を採用（`feat(web):`, `fix(api):`）。

### 2.1. Atomic Commits

- **Law**: 1つのコミットには「1つの論理的変更」のみを含めます。

### 2.2. Pull Request Template Protocol

- **Law**: change proposalは、少なくとも目的、差分、検証証跡、risk、rollback、migration／互換性影響をreviewerが判断できる形で保持する。`.github/pull_request_template.md`と次の8項目はGitHub向け参照実装である：

    ```markdown
    ## Type of Change
    <!-- feat / fix / refactor / perf / docs / style / test / build / ci / chore / revert -->

    ## What
    <!-- 何を変えたか。3 文以内で要約 -->

    ## Why
    <!-- なぜ変えるのか。動機・問題・背景。Linked Issue / ADR を明示 -->
    Closes #<issue-number>
    Refs ADR-<number>（該当時）

    ## How to Test
    <!-- レビュアー/QA が動作検証する手順 -->
    1.
    2.

    ## Risk Assessment
    <!-- Low / Medium / High。理由を 1 行で -->

    ## Rollback Plan
    <!-- 本変更が問題を起こした場合の復旧手順。`git revert <sha>` で十分か、追加対応必要か -->

    ## Migration Notes
    <!-- DB マイグレーション・config 変更・破壊的 API 変更があれば記載。なければ "None" -->

    ## Screenshots / Recordings
    <!-- UI 変更時は必須。Before/After を並べる -->
    ```
- **CI 連携**: 採用したchange proposal schemaの必須fieldをVCS、review systemまたはCIで機械検証する。特定Actionを唯一の適合手段にしない。
- **アンチパターン**: placeholder、空欄、検証不能な説明のまま承認へ進めることを禁止する。

### 2.3. Reviewable Change Size（レビュー可能な変更サイズ）

- **Law**: change proposalは、一つの意図、独立した検証、明確なrollbackをreviewerが理解できる大きさに保つ。行数だけでriskを判定せず、生成物、lockfile、schema、migration、binary差分を分類する。100行は分割を促す参考signalであり適合閾値ではない。保護対象への変更はserver-side policyまたは同等統制で必須検証と承認を強制する。

### 2.4. Pre-Push Branch Protection Hook（プッシュ前ブランチ保護フック）

- **Law**: protected refへの未承認変更はserver-side policyまたは同等のauthoritative controlで拒否する。local `pre-push` hookは早期feedbackの一例であり、単独では迂回可能なため最終統制にしない。
- **実装**: hookを使う場合はremote ref、複数worktree、detached HEAD、GUI／bot経路を考慮し、§9.3の配布契約へ従う。
- **クロスリファレンス**: 具体的なフレームワーク（lefthook / Husky 等）の選定は §9.3 Hooks Distribution / §6.0 Branch Protection（サーバー側補完）

### 2.5. Pre-Commit Auto-Formatting Hook（コミット前自動整形フック）

- **Law**: formatterと軽量lintはlocalまたはCIで決定論的に再現し、CIをauthoritative gateとする。local hookで自動修正する場合はstaged範囲を逸脱せず、部分stageを壊さず、変更内容を利用者が確認できるようにする。hook自体は全projectの必須実装ではない。
- **クロスリファレンス**: 具体的なフレームワーク選定は §9.3 Hooks Distribution / §2.10 commitlint（commit-msg フック）

### 2.6. Merge Strategy Mandate（マージ戦略義務）

- **Strategy Contract**: squash、merge commit、rebase merge、fast-forwardのいずれを採用しても、change proposal、最終revision、承認、test、release artifact、revert単位を追跡できなければならない。
- **Reference Default**: 一変更提案を一commitとして戻したいproduct repositoryではSquash & Mergeとlinear historyが有効である。複数version保守、upstream同期、署名済みcommit保存等ではmerge commitまたは別方式を選べる。
- **Policy**: merge方式をrepository単位で明示し、同じ保護refへ無秩序に混在させない。hosting serviceの設定、server hook、merge bot等で強制する。
- **Local Rebase Discipline（ローカル Rebase 規律）**:
    - 自分だけが所有するbranchではrebaseを使用できる。共有branchの履歴を書き換える場合は全collaboratorの明示合意と復旧点を必要とし、通常はmergeまたは新branchを選ぶ。

### 2.7. Force-Push Protocol（フォースプッシュ・プロトコル）

- **Law: Use `--force-with-lease`, Never `--force`**:
    - 個人ブランチへの force push が必要な場合は **必ず `git push --force-with-lease`** を使用。`--force` は禁止。
    - 理由: `--force-with-lease` はリモートの最新コミットが自分の知るものと一致する時のみ push を許可する → 他者の作業を上書きする事故を防止。
- **Forbidden: Force-Push to Protected Branches（保護ブランチへの force push 禁止）**:
    - `main` / `release/*` / `production` 等の保護ブランチへの force push は **絶対禁止**。Branch Protection で物理的にブロック（§6.0 参照）。
- **Allowed Use Cases（許可されるケース）**:
    - 個人作業ブランチでの `rebase -i` 後の整形 push
    - PR レビュー指摘を受けた fixup → autosquash → force-push（§2.9 参照）
- **Audit Trail（監査証跡）**:
    - GitHub の `Audit log` で force-push イベントを定期監視。Slack 通知連携を推奨。

### 2.8. Commit Body & Trailer Standards（コミット本文・トレイラー標準）

- **Subject Line（件名）**:
    - 50 文字以内、命令形（`Add`, `Fix`, `Refactor`）、末尾ピリオドなし。
    - フォーマット: `type(scope): subject`（§2.0 参照）
- **Body Wrapping（本文整形）**:
    - 本文は 72 文字で改行（`git log` 表示崩れ防止）。空行で件名と本文を分離。
- **Required Footers（必須トレイラー）**:

    | Trailer | 用途 | 例 |
    |---|---|---|
    | `Refs: #123` | Issue 参照（クローズしない） | `Refs: #123` |
    | `Closes: #123` | Issue 自動クローズ | `Closes: #123` |
    | `BREAKING CHANGE: <desc>` | 破壊的変更（SemVer major bump トリガー） | `BREAKING CHANGE: API v2 endpoints removed` |
    | `Co-Authored-By: Name <email>` | 共同執筆者の帰属（AI Agent 含む） | `Co-Authored-By: Claude <noreply@anthropic.com>` |
    | `Signed-off-by: Name <email>` | DCO サインオフ（OSS プロジェクト必須） | `git commit -s` で自動付与 |
- **AI Pair-Programming Attribution（AI ペアプロ帰属義務）**:
    - AI Agent（Claude / Copilot / Codex 等）が **コードを生成または修正に関与した** すべてのコミットには `Co-Authored-By:` トレイラーを **必須付与**。
    - 用途: 後の監査・脆弱性追跡（§8.7 AI-Generated Code Provenance との連携）。
    - 例: `Co-Authored-By: Claude <noreply@anthropic.com>` / `Co-Authored-By: GitHub Copilot <copilot@github.com>`
- **アンチパターン禁止**:
    - `"fix"` / `"update"` / `"wip"` 等の単語のみのコミット → 何が変わったか不明、即 reject
    - 件名 50 文字超過 → 自動 lint で拒否（commitlint）
    - 本文無しで複雑な変更 → "Why" を本文に書けないコミットは未熟成

### 2.9. Fixup & Autosquash Discipline（fixup・autosquash 規律）

- **Law: Squash WIP Commits Before Merge（マージ前の WIP コミット整理義務）**:
    - PR 内の "WIP" / "review fix" / "typo" コミットは、マージ前に **`git commit --fixup=<sha>` + `git rebase -i --autosquash`** で原コミットに吸収。
    - 理由: `main` 履歴に「PR 単位の論理的変更」のみが残ることを担保（§2.6 Squash Merge と組み合わせれば自動化される）。
- **Workflow（推奨ワークフロー）**:

    ```bash
    # レビュー指摘の修正
    git add .
    git commit --fixup=<元コミットの SHA>

    # PR を update する直前に整形
    git rebase -i --autosquash main

    # force-push（個人ブランチのみ）
    git push --force-with-lease
    ```
- **Auto-Configuration**:
    - `git config --global rebase.autoSquash true` を **全開発者に推奨**。`rebase -i` 時に fixup が自動配置される。

### 2.10. Conventional Commit Validation（コミットメッセージ検証）

- **Law**: §2.0 で定めた Type の遵守は **commitlint で機械的に強制**する。手動レビューに頼らない。
- **Required Setup（commitlint）**:

    ```bash
    npm install --save-dev @commitlint/cli @commitlint/config-conventional
    ```

    `commitlint.config.js`:

    ```js
    module.exports = {
      extends: ['@commitlint/config-conventional'],
      rules: {
        'type-enum': [2, 'always', [
          'feat', 'fix', 'refactor', 'perf', 'docs', 'style',
          'test', 'build', 'ci', 'chore', 'revert'
        ]],
        'subject-max-length': [2, 'always', 50],
        'body-max-line-length': [2, 'always', 72],
        'footer-leading-blank': [2, 'always']
      }
    };
    ```
- **Hook Integration（Husky commit-msg）**:

    ```bash
    npx husky add .husky/commit-msg 'npx --no-install commitlint --edit $1'
    ```
- **CI Validation（PR タイトル・全コミット）**:
    - GitHub Actions: `wagoid/commitlint-github-action@v6` で PR 単位の検証を必須 check 化。
    - Squash & Merge 採用時は、**PR タイトル**が squash 後のコミットメッセージになるため、PR タイトルも commitlint で検証する。
- **Optional UX Enhancement: commitizen**:
    - `npx cz` で対話形式にコミットメッセージを構築。新規開発者の学習曲線を平坦化。
- **アンチパターン禁止**:
    - `--no-verify` での hook bypass → §10.0 Anti-Pattern Catalog で禁則
    - 「commitlint 落ちたら無効化」 → 規律を緩める方向の修正は禁止

---

## Part 3: Branch Hygiene Mandate（ブランチ衛生）

### 3.0. Branch Hygiene Mandate (Garbage Collection)

- **Law**: 作業ブランチを放置することは、環境差異による事故の最大の原因です。マージ済みのブランチは即時削除。
- **Action**:
    1. タスク完了報告の直前に、必ず `git branch --merged` を確認
    2. マージ済みの作業ブランチを `git branch -d <branch>` で削除
    3. リモートブランチも同様にクリーンアップ（`git push origin --delete <branch>` または GitHub の auto-delete on merge 機能を有効化）
- **継続性**: `git branch --merged` の確認を **エンジニアの呼吸** として日常化せよ。

### 3.1. Stale Remote Tracking References

- **Law**: 削除済みリモートブランチの local tracking ref が残ると `git branch -a` が汚染される。
- **Action**: 定期的に `git fetch --prune` または `git remote prune origin` を実行する。

---

## Part 4: Worktree Hygiene Protocol（Worktree 衛生）

> **Domain**: 通常作業 / 開発時 / 開発環境 / 並行tool統合
>
> **Severity**: HIGH — stale管理情報やtool非互換はbranch誤認、作業損失、tool停止を起こし得る

### 4.0. Worktree State and Compatibility（worktree状態と互換性）

- **公式境界**: `extensions.worktreeConfig`はworktree固有設定を読むGitの正式機能であり、sparse-checkout等が有効化する場合もある。存在だけを汚染と判定せず、active worktreeや`config.worktree`が依存する状態で無条件にunsetしない。
- **stale状態**: worktree directoryを正規command外で削除した場合のprunable管理情報、実在しないlocal branchの`branch.<name>`設定、移動後のpath不整合を検出対象とする。
- **tool互換性**: 古いGitまたは周辺toolが正式extensionを読めない場合は、Git version、error、再現手順、影響範囲を確認し、tool更新・隔離・serial execution・期限付き例外から選ぶ。正当なGit設定の削除を既定復旧にしない。
- **正規操作**: 状態確認は`git worktree list --porcelain`、整理は`git worktree remove`または`git worktree prune`、移動不整合は`git worktree repair`を使用し、`.git/worktrees`を直接編集しない。

### 4.1. Mandatory Cleanup Protocol（毎回義務）

- **Law**: worktreeを追加・削除・移動する変更境界で、worktree一覧、prunable状態、branch config、未保存変更を検証する。毎command後の手動実行を固定せず、自動化またはtask終了gateで同じ成果を保証してよい。
- **Required Checks**:
    1. `git worktree list --porcelain`で登録worktree、HEAD、branch、lock／prunable状態を確認
    2. `git worktree prune --dry-run --verbose`でGitがprune可能と判定した管理情報を確認
    3. `git config --local --name-only --get-regexp '^branch\.'`とlocal branch refを照合
    4. `extensions.worktreeConfig`利用時は`git config --worktree`と対象Git／toolのsupportを確認
- **Cleanup Commands**:

```bash
git worktree list --porcelain
git worktree prune --dry-run --verbose
git worktree prune --verbose
git worktree repair <moved-worktree-path>
```

`git worktree prune`と`repair`はGitが管理するmetadataに限定する。branch refの削除、未保存変更の破棄、`extensions.worktreeConfig`の無効化は別の人間判断であり、本cleanupへ含めない。

### 4.2. Automated Detection Script（推奨）

- **Law**: 複数worktreeや複数toolを使うrepositoryでは、Gitの正規commandに基づく検出をtask終了gate、CI、scheduled audit等へ組み込む。個人repositoryでは同じ確認を手動実行してよい。
- **Reference Implementation**: `axiarch-scripts/check-git-config-clean.sh` — prunable worktree metadataと実在しないlocal branchのconfigを検出・修復する参考script
- **使用例**:

```bash
./axiarch-scripts/check-git-config-clean.sh         # 検出のみ（exit 1 if dirty）
./axiarch-scripts/check-git-config-clean.sh --fix   # 検出 + 自動修復
./axiarch-scripts/check-git-config-clean.sh --quiet # CI 用サイレントモード（汚染なら exit 1）
```

### 4.3. 複数tool・AI Agent並行使用時の追加注意

- **Context**: IDE、AI agent、automation、開発者が同じrepository metadata、branch、index、worktreeを並行変更すると、support差、lock、base誤認、未取得変更の上書きが起こり得る。
- **Mitigation**:
    1. toolごとにworktree、branch、credential、write scope、ownerを分離する
    2. 同じbranch／indexへ書く操作はlock、queue、handoff等で直列化する
    3. task開始・handoff・終了時にstatus、worktree一覧、remote parity、未公開変更を確認する
    4. 自動修復前にdry-runを確認し、active worktree、branch ref、未保存変更を削除しない

### 4.4. Failure Pattern Documentation（失敗パターン）

- **Law**: incidentや互換性問題は、特定project名、利用者名、実branch名をUniversalへ持ち込まず、再利用可能なcondition、signal、controlへ匿名化する。実観測の日時、project、機密logはBlueprintまたはincident recordに保持する。
- **再利用可能な失敗パターン**:

    | 条件 | signal | control |
    |---|---|---|
    | worktree pathをfile操作で削除 | `git worktree prune --dry-run --verbose`がprunable entryを表示 | clean確認後に`git worktree prune` |
    | worktreeをfile操作で移動 | 登録pathと実pathが不一致 | `git worktree repair` |
    | local branch削除後にconfig sectionが残る | local refなしで`branch.<name>` keyが存在 | 対象sectionだけをreview後に削除 |
    | toolが正式Git extensionを未support | 再現可能なunsupported-extension error | tool／Git更新、隔離、serial execution、期限付き例外 |

---

## Part 5: Repository Hygiene & Config Integrity（リポジトリ衛生）

### 5.0. `.git/config` Health Audit

- **Law**: `.git/config` は **リポジトリの神経系統**。汚染は様々なツール連携を断絶する。
- **Action**: `git config --show-origin --list`、`git worktree list --porcelain`、local branch refとの照合を、変更eventとBlueprintのrisk-based cadenceで実行する。正式extensionの存在だけを異常とせず、設定sourceと利用者を確認する。

### 5.1. `.gitignore` for AI Agent Artifacts

- **Law**: agent生成物をcanonicalなteam共有設定・task証跡と、credential、個人設定、cache、session log、temporary worktree等のephemeral／sensitive artifactへ分類する。前者はschema、review、retentionに従ってversion管理でき、後者だけをignoreする。`plan files`を名称だけで一律除外しない。
- **Required `.gitignore` Entries**:

    ```gitignore
    # Claude Code: ignore session data and personal settings only
    # (do NOT blanket-ignore .claude/ — it may contain team-shared config that should be committed)
    .claude/worktrees/
    .claude/projects/
    .claude/settings.local.json

    # Antigravity session data (if applicable)
    .agents/sessions/
    ```

---

## Part 6: Branch Protection & Code Review（ブランチ保護とコードレビュー）

> **Domain**: GitHub / GitLab / Bitbucket の Settings レベル統制
>
> **Severity**: HIGH — 不在は本番事故・誤マージ・履歴汚染を直接引き起こす

### 6.0. Protected Reference Control（保護ref統制）

- **Law**: 本番、release、policy、CI、署名鍵、配布metadataへ到達するprotected refには、利用中VCSが提供するruleset、branch protection、server hook、ACLまたは同等統制を適用する。次表はGitHubの参考profileであり、列挙値を全repositoryへ一律要求しない：

    | 設定項目 | 値 | 理由 |
    |---|---|---|
    | Require a pull request before merging | ✅ ON | 直接 push 禁止 |
    | Require approvals | risk-based。高保証変更は二者review | レビューバイパス防止 |
    | Dismiss stale approvals when new commits are pushed | ✅ ON | 改変後の再レビュー強制 |
    | Require review from Code Owners | ✅ ON | §6.1 と連携 |
    | Require status checks to pass | ✅ ON（必須 check 列挙） | CI 緑のみマージ可 |
    | Require branches to be up to date before merging | ✅ ON | 古い base での merge 防止 |
    | Require signed commits | artifact／source identity要件に応じてON | §7.1 と連携 |
    | Require linear history | 選択したmerge方式に応じてON | §2.6 と連携 |
    | Require deployments to succeed before merging | ✅ ON（preview deploy あり） | preview の動作確認強制 |
    | Lock branch | ⚠️ 一時的に ON（リリース凍結時） | 非常時のみ |
    | Do not allow bypassing the above | 通常ON。緊急bypassはbreak-glass記録 | 無証跡例外を作らない |
    | Restrict who can push | 承認済みactorとautomationだけ | 直接変更を最小化 |
    | Allow force pushes | ❌ OFF | §2.7 と連携 |
    | Allow deletions | ❌ OFF | 履歴消失防止 |
- **必須成果**: required check、最終revisionに対する承認、承認後変更時の再review、force push／削除の制御、bypassのowner・理由・期限・監査証跡を機械確認できること。承認人数はrisk、規制、team規模で定め、高保証領域ではSLSA Sourceの二者review要件を満たす。

### 6.1. Ownership Resolution（所有者解決）

- **Law**: 変更されたpath、component、schema、policyからaccountable ownerと必要reviewerを機械的に解決できること。`.github/CODEOWNERS`はGitHubの参考実装であり、GitLab Code Owners、Gerrit group、ownership registry等の同等手段を許容する。
- **Format**:

    ```
    # 構文: <pattern> <@owner1> <@owner2> <@team>
    *                      @core-team
    /apps/web/             @frontend-team
    /apps/api/             @backend-team
    /infra/                @platform-team
    /docs/                 @docs-team
    *.sql                  @dba-team
    /security/             @security-team @cto
    ```
- **Required Practice**:
    - 全保護対象が少なくとも一つのaccountable ownerまたは継続経路へ解決される
    - 重要pathはowner不在をblockし、riskに応じて専門reviewと独立承認を強制する
    - ownership policy自体の変更にもowner、review、承認後変更時の再reviewを適用する
- **連携**: §6.0のprotected reference controlと組み合わせ、owner解決を単なる通知先で終わらせない。

### 6.2. PR Review SLA & Stale PR Hygiene（PR レビュー SLA・停滞 PR 衛生）

- **Review Response SLO（応答目標）**:
    - change risk、team timezone、incident／release urgencyに応じた応答目標とescalation routeをBlueprintへ定義し、待ち時間とreview loadを測定する。24営業時間は参考初期値である。
    - 通知先はSlackに固定せず、利用中のchat、email、ticket、pager等から選ぶ。
- **Stale Change Hygiene（停滞変更の衛生）**:
    - inactive changeにはowner確認、base更新、分割、supersede、closeの判断を行う。固定日数で無条件auto-closeせず、security fix、外部contributor、長期migration等を分類する。
- **Draft PR の正しい使用**:
    - WIP は **Draft PR** として作成し、レビュー対象外であることを明示。Ready for review に変更したタイミングで SLA カウント開始。
- **Re-Review Triggering**:
    - レビュー後に commit が追加された場合、`Dismiss stale approvals` (§6.0) で承認は自動失効。再レビューを必須とする。

### 6.3. Conventional Comments for Code Review（コードレビュー慣用語彙）

- **Law**: コードレビューコメントは **Conventional Comments** 形式を採用し、**意図の明確化** を担保する。
- **Required Labels**:

    | Label | 意図 | ブロッキング |
    |---|---|---|
    | `praise:` | 良い実装への賞賛 | No |
    | `nitpick:` / `nit:` | 些細な指摘（マージブロックしない） | No |
    | `suggestion:` | 改善提案（採否は author 判断） | No |
    | `issue:` | 問題指摘（修正必須） | **Yes** |
    | `question:` | 理解確認のための質問 | 場合による |
    | `thought:` | 議論の種・将来検討事項 | No |
    | `chore:` | リファクタ等の小タスク | No |
- **Format Example**:

    ```
    issue (security): この入力は schema 検証されていない。Zod でラップせよ。

    nitpick: 変数名 `data` より `userPayload` の方が意図が伝わる。
    ```
- **アンチパターン禁止**:
    - ラベルなしで批判的なコメント → 意図不明・人格攻撃に見える
    - `nitpick:` を `issue:` に偽装 → レビューの優先順位を歪める

### 6.4. AI-Assisted PR Review（AI 補助コードレビュー）

- **Law**: AI補助reviewを使う場合はdefense-in-depthとし、責任ある承認主体、secure SDLC、SAST／SCA／testの代替にしない。AI導入自体を全projectの必須要件にしない。
- **Recommended Tools（2026 stable）**:

    | Tool | 強み | 言語/エコシステム |
    |---|---|---|
    | **CodeRabbit** | 包括的レビュー、line-level コメント、要約生成、対話型 | 多言語 |
    | **Greptile** | リポジトリ全体の文脈理解、影響範囲分析 | 多言語 |
    | **Codium PR-Agent** | OSS、自前ホスト可能、カスタムプロンプト | 多言語 |
    | **GitHub Copilot Code Review** | GitHub 統合、IDE 連携 | 多言語 |
- **Mandatory Boundaries（必須の境界）**:
    - AI出力にはmodel／service、対象revision、実行時刻、policy、resultを追跡できる証跡を残し、機密code、prompt injection、data retentionをthreat modelへ含める。
    - **AIコメントは示唆であり決定ではない**。riskに基づく人間または明示的に承認されたgovernance主体が最終責任を持つ。AI結果が未完了でも無期限に人間reviewを停止しないfail-open／fail-closed方針を定める。
    - review品質は経過分数やコメント数で証明せず、最終revision、重要risk、test evidence、未解決指摘への判断を記録する。
- **Use Cases（補助範囲）**:
    - スタイル / 命名規約の自動検出
    - 明白なバグ・null チェック漏れ・エラーハンドリング不足
    - PR description と実装の乖離検出
    - セキュリティ簡易スキャン（OWASP 上位）— ただし §9.0 Multi-Layer Secret Scanning の代替にはならない
- **アンチパターン禁止**:
    - **AI Rubber-Stamp**: AI が OK と言ったから人間が秒で approve → §6.2 PR Review SLA の精神違反
    - **AI Over-Reliance**: AI に「設計判断」を委ねる → アーキテクチャ判断は ADR + 人間で行う（§1.33 Strong Opinions Weakly Held / Disagree & Commit）
    - **AI Comment Suppression**: AI が指摘した issue を黙って解決せず close する → 透明性違反
- **クロスリファレンス**: §6.0 Branch Protection / §6.3 Conventional Comments / §1.11 AI-Augmented Engineering / §9.1 AI-Generated Commit Attribution

---

## Part 7: Tags, Releases & History Operations（タグ・リリース・履歴操作）

> **Domain**: SemVer 統治 / リリース自動化 / 過去履歴の修復

### 7.0. SemVer Tag Discipline（SemVer タグ規律）

- **Law**: 全リリースは **Semantic Versioning 2.0.0** に準拠したタグを付与する: `v<MAJOR>.<MINOR>.<PATCH>`
- **Required Format**:
    - `vX.Y.Z` 形式（先頭 `v` 必須、Stripe / Vercel / Next.js 慣習）
    - Pre-release: `v1.4.0-rc.1` / `v1.4.0-beta.2` / `v1.4.0-alpha.1`
    - Build metadata: `v1.4.0+build.20260504` (情報目的のみ、SemVer 比較に影響しない)
- **Annotated Tags Mandatory（注釈付きタグ必須）**:
    - 全 release タグは **annotated tag** で作成（`git tag -a v1.4.0 -m "Release v1.4.0"`）
    - 軽量タグ（lightweight tag）は **禁止** — 作者・日時・メッセージが残らない
- **Signed Tags（署名タグ、推奨）**:
    - Production release タグは GPG/SSH 署名（`git tag -s v1.4.0`）
    - 検証: `git tag -v v1.4.0`
- **Tag Immutability**:
    - 一度 push したタグは **削除・上書き禁止**。修正は新タグ（`v1.4.1`）で行う。

### 7.1. Commit & Tag Signing（コミット・タグ署名）

- **Law**: SemVer minor 以上の本番リポジトリでは **全コミットおよび全タグの署名を必須化**。
- **Signing Methods**:

    | 方式 | 推奨 | 設定 |
    |---|---|---|
    | **SSH 署名（推奨・Git 2.34+）** | ✅ | `git config gpg.format ssh; git config user.signingkey ~/.ssh/id_ed25519.pub` |
    | GPG 署名（従来） | ⚠️ 鍵管理が複雑 | `git config gpg.format openpgp` |
    | S/MIME（X.509） | ⚠️ エンタープライズ用途 | `git config gpg.format x509` |
- **Auto-sign Configuration**:

    ```bash
    git config --global commit.gpgsign true
    git config --global tag.gpgsign true
    ```
- **GitHub Verification**: Settings > SSH and GPG keys に署名鍵を登録すると、コミットに `Verified` バッジが表示される。
- **クロスリファレンス**: `security/000_security_privacy.md` のコミット署名要件と整合。

### 7.2. Release Automation（リリース自動化）

- **Recommended Tooling**:

    | Tool | 用途 | 言語/エコシステム |
    |---|---|---|
    | **release-please** (Google) | Conventional Commits → Release PR + Changelog | 多言語 |
    | **semantic-release** | 完全自動 release（CI 上で commit→tag→publish） | npm 中心 |
    | **changesets** | モノレポ向けバージョン管理 | npm/pnpm workspaces |
    | **goreleaser** | Go バイナリリリース | Go |
- **Conventional Changelog**: Conventional Commits（§2.0）が前提。`feat:` → minor bump、`fix:` → patch bump、`BREAKING CHANGE` → major bump。
- **Required Output**:
    - GitHub Release ページに自動生成された Changelog
    - SemVer タグ（§7.0 準拠、annotated）
    - npm/PyPI/crates.io 等への自動 publish（該当時）

### 7.3. Revert over Force-Push（Force-Push より Revert）

- **Law**: `main` にマージ済みの問題コミットを取り消す際は、**`git revert` を使用**する。`git push --force` で履歴を書き換えてはならない。
- **Reasons**:
    - 履歴の不変性が保たれる（監査証跡）
    - 他開発者の clone と整合性が崩れない
    - revert 自体も commit として記録され、判断の透明性がある
- **Multi-Commit Revert**:

    ```bash
    # 単一コミット
    git revert <sha>

    # 連続複数コミット
    git revert <oldest-sha>^..<newest-sha>

    # マージコミット
    git revert -m 1 <merge-sha>
    ```

### 7.4. Bisect & Reflog as Safety Net（Bisect・Reflog による安全網）

- **`git bisect` for Regression Hunting**:
    - 「いつから壊れたか」を二分探索で特定する。テストが automate されていれば無人実行可能：

    ```bash
    git bisect start
    git bisect bad HEAD
    git bisect good v1.3.2
    git bisect run npm test         # テストが pass/fail で結論
    git bisect reset                # 完了後
    ```
- **`git reflog` as Last-Resort Recovery**:
    - 誤って `reset --hard` / `rebase` で消したコミットも `git reflog` で 90 日間（既定）追跡可能。

    ```bash
    git reflog                      # 履歴一覧
    git reset --hard HEAD@{5}       # 5 操作前に戻る
    ```
- **教訓**: `git reflog` が見えれば、ほぼ全ての「やらかし」は復元可能。reflog の存在を全エンジニアに教育せよ。

### 7.5. Sensitive History Cleansing（機密履歴の除去）

- **Law**: 誤コミットされた **シークレット・PII・機密ファイル** は履歴ごと完全除去する。発見時は即時対応の最高優先タスク。
- **Modern Tool: `git filter-repo`（推奨）**:
    - `git filter-branch` は **Deprecated**。`git filter-repo` を使用（公式推奨）：

    ```bash
    pip install git-filter-repo

    # 特定ファイルを全履歴から削除
    git filter-repo --invert-paths --path secrets.env --force

    # 特定文字列を全履歴で置換
    echo 'literal:OLD_API_KEY==>REDACTED' > replacements.txt
    git filter-repo --replace-text replacements.txt
    ```
- **Post-Cleansing Mandatory Steps**:
    1. force-push（チーム全員に再 clone を依頼）
    2. **即座にシークレットを失効・ローテーション**（履歴除去だけでは不十分、漏洩済みと見なす）
    3. GitHub Secret Scanning Alerts を確認
    4. インシデントログとして記録（`incident_report.md`）
- **アンチパターン禁止**:
    - 「履歴から消したから安全」 → ❌ シークレットは失効必須。Push 済みなら漏洩済みと見なせ
    - `git rebase` で commit を消す → ❌ 浅い修正、git reflog や fork から復元される

### 7.6. Modern Repository Maintenance（`git maintenance` による現代的リポジトリ保守）

- **Law**: 手動 `git gc` 時代は終焉。Git 2.31+ では **`git maintenance` でバックグラウンド自動保守** を有効化することを義務とする。
- **Required Setup**:

    ```bash
    # 全開発者・CI ランナーで一度だけ実行
    git maintenance start
    ```

    これにより以下のタスクが **`cron` または `systemd timer` 経由で自動実行**される（macOS は `launchd`、Windows は Scheduled Tasks）:

    | タスク | 実行頻度 | 役割 |
    |---|---|---|
    | `gc` | 週次 | 古い refs と参照されないオブジェクトの整理（軽量版） |
    | `loose-objects` | 時間毎 | 散在するオブジェクトを pack 化 |
    | `incremental-repack` | 日次 | pack ファイルの増分再構築 |
    | `commit-graph` | 時間毎 | `git log` 高速化用のコミットグラフ更新 |
    | `prefetch` | 時間毎 | リモート refs の事前取得（push/pull 体感速度向上） |
- **Verification**:

    ```bash
    git maintenance run --task=commit-graph    # 任意タスクを手動実行
    cat .git/config | grep -A 10 maintenance   # 設定確認
    git config --get-all maintenance.repo      # 管理対象リポジトリ一覧
    ```
- **Why Mandatory**:
    - 大規模リポジトリ（>10K commits）で `git status` / `git log` の体感速度が **2-10 倍**改善
    - 手動 `git gc` の忘却問題（やる人がいない → リポジトリが太る）を構造的に解決
- **アンチパターン禁止**:
    - 巨大化したリポジトリで初めて `git gc --aggressive` を打つ → 数時間ハングする可能性。日次 maintenance で予防
    - `git maintenance start` を CI のみに設定 → 開発者ローカルが置き去り。**全環境で必須**
- **クロスリファレンス**: §7.4 Bisect & Reflog（reflog も maintenance 対象）/ §8.1 Git LFS（LFS objects は別管理）

---

## Part 8: Repository Configuration & Assets（リポジトリ設定・アセット管理）

### 8.0. `.gitattributes` Mandate（`.gitattributes` 義務）

- **Law**: 全リポジトリは `.gitattributes` を **必須配置**し、改行コード・LFS・diff/merge ドライバを明示的に統制する。
- **Required Minimum Content**:

    ```gitattributes
    # 改行コード正規化（Windows/macOS/Linux 混在対策）
    * text=auto eol=lf

    # 強制 LF（シェル・YAML・Dockerfile 等）
    *.sh        text eol=lf
    *.yml       text eol=lf
    *.yaml      text eol=lf
    Dockerfile  text eol=lf
    Makefile    text eol=lf

    # 強制 CRLF（Windows ネイティブ）
    *.bat       text eol=crlf
    *.cmd       text eol=crlf

    # バイナリ宣言（diff 不要）
    *.png       binary
    *.jpg       binary
    *.pdf       binary
    *.zip       binary

    # Git LFS 管理対象（§8.1 参照）
    *.psd       filter=lfs diff=lfs merge=lfs -text
    *.mp4       filter=lfs diff=lfs merge=lfs -text

    # diff ドライバ
    *.md        diff=markdown

    # マージ戦略（package-lock.json は union マージ）
    package-lock.json  merge=union
    ```
- **理由**: 改行コードの揺れは **CI でのみ発生する謎の diff** の温床。`.gitattributes` で物理的に統一する。

### 8.1. Git LFS Policy（Git LFS 採用基準）

- **Threshold（採用閾値）**:
    - **>10 MB** のバイナリファイルは **Git LFS 必須**（推奨）
    - **>100 MB** は GitHub のハードリミットに触れるため **強制 LFS**
- **Recommended Tracked Patterns**:

    ```bash
    git lfs install
    git lfs track "*.psd" "*.ai" "*.sketch" "*.fig"   # デザイン
    git lfs track "*.mp4" "*.mov" "*.wav" "*.flac"    # メディア
    git lfs track "*.gguf" "*.safetensors" "*.bin"    # ML モデル
    git lfs track "*.zip" "*.tar.gz"                  # アーカイブ（必要時）
    ```
- **アンチパターン禁止**:
    - `git push` 後にエラーになってから LFS 化 → 履歴に肥大ファイルが残り続ける（§7.5 で除去必須）
    - LFS なしで >10 MB ファイルを `main` に積む → clone が遅く、CI コストが膨張

### 8.2. Submodule Policy: Last Resort（サブモジュール採用基準: 最終手段）

- **Default: Avoid Submodules（既定: サブモジュール回避）**:
    - サブモジュールは **clone / CI / 開発者体験を破壊** する温床。原則として採用しない。
- **Alternatives First（先に検討すべき代替）**:
    1. **パッケージマネージャ依存**（npm / pip / cargo / go modules）— 最優先
    2. **Monorepo 化**（pnpm workspaces / Nx / Turborepo / Bazel）
    3. **`git subtree`** — 履歴を取り込みつつ独立性も保ちたい場合
- **Submodule が正当化される場合**:
    - ベンダーロック回避のため fork した OSS を tag-pin で管理
    - 独立リリースサイクルの内部 SDK を複数リポジトリで再利用
- **Mandatory if Adopted（採用時の必須事項）**:
    - **タグまたは特定 SHA に固定**（`master` 追従禁止）
    - `.gitmodules` に明確な責務記述
    - `git submodule update --init --recursive` を README の Setup に必ず明記

### 8.3. `.git-blame-ignore-revs` Discipline（`git blame` 透明化規律）

- **Law**: **Mass-format コミット**（Prettier / Black / gofmt 一括適用、改行コード変換、リネーム等）は **`.git-blame-ignore-revs` に記録** し、`git blame` から透明化する。
- **Why Critical**:
    - 一括フォーマットコミットが `git blame` の最上位を占めると、**「誰がこの行を書いたか」が永遠に消失**
    - GitHub / GitLab / VS Code GitLens は `.git-blame-ignore-revs` を自動認識し、該当 SHA をスキップ
- **Required Setup**:

    `.git-blame-ignore-revs`（リポジトリルート）:

    ```
    # Prettier 全体適用（2026-05-01）
    a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0

    # Black 全 Python ファイル適用（2026-04-15）
    f0e9d8c7b6a5d4c3b2a1d0e9f8g7h6i5j4k3l2m1

    # 改行コード CRLF → LF 一括変換（2026-03-20）
    1234567890abcdef1234567890abcdef12345678
    ```
- **Local Git Configuration**:

    ```bash
    # ローカル `git blame` でも自動的に該当 SHA をスキップ
    git config blame.ignoreRevsFile .git-blame-ignore-revs
    ```
- **Mandatory Practices**:
    - mass-format コミットを実施する **その PR で同時に `.git-blame-ignore-revs` を更新**する（事後追加は記憶任せで漏れる）
    - **コメント必須**: 各 SHA の上に「何の format か / 日付」をコメント
    - **完全 SHA を使用**（短縮 SHA は将来の衝突で無効化リスク）
- **Anti-Pattern**:
    - mass-format を `chore: format` の 1 コミットで `main` にマージしたまま `.git-blame-ignore-revs` を更新しない → blame が永遠に壊れる
    - 通常コミット（feat/fix）を `.git-blame-ignore-revs` に追加 → 履歴隠蔽になり監査違反
- **クロスリファレンス**: §2.0 Conventional Commits（`style:` / `refactor:` 区別）/ §8.0 `.gitattributes`

---

## Part 9: Modern Tooling & Automation（モダンツーリング・自動化）

### 9.0. Multi-Layer Secret Scanning（多層シークレットスキャン）

- **Law**: シークレット混入は **2 層以上の防御** で阻止する。単層は突破される前提。

    | 層 | ツール | タイミング | 検出後の挙動 |
    |---|---|---|---|
    | **L1: Pre-commit（クライアント側）** | `gitleaks` / `trufflehog` / `detect-secrets` | `git commit` 前 | コミット拒否 |
    | **L2: Pre-push（クライアント側）** | husky pre-push + gitleaks | `git push` 前 | push 拒否 |
    | **L3: Server-side（サーバー側、最後の砦）** | **GitHub Push Protection** / GitLab Secret Detection | push 受信時 | push 拒否 + 通知 |
    | **L4: Periodic Scan（定期）** | GitHub Secret Scanning / GitGuardian | 全履歴 | アラート + 自動失効連携 |
- **Required for Public Repos**: GitHub Push Protection を **必ず ON**（無料）。Private リポジトリは Advanced Security 購読推奨。
- **アンチパターン禁止**:
    - 「pre-commit で見てるから大丈夫」 → ❌ `--no-verify` でバイパス可能。サーバー側で必ず再検査
    - 検出後に履歴除去のみ → ❌ §7.5 通り **シークレット失効・ローテーション必須**

### 9.1. AI-Generated Commit Attribution（AI 生成コミット帰属義務）

- **Law**: AI Agent が **コードを生成・修正・提案に関与した** 全コミットには、`Co-Authored-By:` トレイラーを **必須付与**する。
- **Standard Attributions（標準的な帰属表記）**:

    | AI Agent | Trailer |
    |---|---|
    | Claude Code (Anthropic) | `Co-Authored-By: Claude <noreply@anthropic.com>` |
    | GitHub Copilot | `Co-Authored-By: GitHub Copilot <copilot@github.com>` |
    | Cursor | `Co-Authored-By: Cursor <cursor@cursor.sh>` |
    | OpenAI Codex | `Co-Authored-By: OpenAI Codex <noreply@openai.com>` |
    | Google Antigravity | `Co-Authored-By: Antigravity <noreply@google.com>` |
- **Why Mandatory**:
    - **監査証跡**: 後の脆弱性発見時に AI 生成コードを横断検索できる（`git log --grep="Co-Authored-By: Claude"`）
    - **法的明確化**: 著作権・責任分界の明示
    - **品質ガバナンス**: AI 生成率の計測（例: 全コミットの 60% が AI co-authored 等の組織指標）
- **Squash Merge での維持**:
    - GitHub の Squash & Merge は Co-Authored-By を **自動的に保持**（PR 内全コミットの結合）
    - ローカル squash 時は手動で残すこと
- **クロスリファレンス**: §8.7 AI-Generated Code Provenance Protocol（`@ai-coauthor` ヘッダー併用）

### 9.2. Dependency Update Automation（依存関係更新自動化）

- **Law**: 各ecosystemのsupport終了、脆弱性、version driftを継続検出し、owner、期限、compatibility testを持つ更新changeを生成または起票する。Renovate、Dependabot、registry bot、platform service、自社automationは交換可能な実装である。
- **Required Configuration（推奨設定）**:

    ```json
    // renovate.json (推奨)
    {
      "extends": ["config:base", ":semanticCommits"],
      "schedule": ["before 6am on monday"],
      "labels": ["dependencies"],
      "prHourlyLimit": 5,
      "prConcurrentLimit": 10,
      "rangeStrategy": "bump",
      "lockFileMaintenance": { "enabled": true, "schedule": ["before 6am on monday"] },
      "vulnerabilityAlerts": { "labels": ["security"], "schedule": ["at any time"] },
      "packageRules": [
        { "matchUpdateTypes": ["minor", "patch"], "automerge": true, "automergeType": "pr", "platformAutomerge": true },
        { "matchUpdateTypes": ["major"], "automerge": false, "labels": ["needs-review"] }
      ]
    }
    ```
- **Auto-Merge Policy**:
    - semantic versionのpatch／minor／majorだけでriskを決めない。runtime、lockfile、build plugin、native binary、container base、transitive dependency、maintainer／source変更を分類する
    - auto-mergeは影響範囲test、provenance、license、reachability、rollback、変更後monitoringが十分なlow-risk updateに限定する
    - 悪用中脆弱性は即時triageし、緩和、update、rollbackを選ぶ。CI greenだけで無条件mergeしない
- **アンチパターン禁止**:
    - PR 数の爆発 → `prConcurrentLimit` で上限設定、batched updates 採用
    - 全自動マージ → major bump で破綻、レビューゲートを設けよ

### 9.3. Hooks Distribution & Framework Choice（フック配布・フレームワーク選定）

- **Law**: local hookを採用する場合、version管理された設定と再現可能な導入経路を提供し、同じ検査をCIまたはserver-side gateでも強制する。個人の`~/.gitconfig`だけを組織統制にしない。
- **選定契約**: lefthook、Husky、pre-commit、native `core.hooksPath` その他の採用は、対象言語、OS、IDE／GUI client、部分stage、導入失敗時の挙動、実測latency、保守責任者をBlueprintへ記録して決める。Universal層は特定frameworkを必須化しない。
- **Reference Implementation**: 次はlefthookを使う一例であり、必須の製品、コマンド、ファイル構成ではない。

    ```yaml
    pre-commit:
      parallel: true
      commands:
        lint:
          glob: "*.{js,ts,tsx}"
          run: npx eslint --fix {staged_files} && npx prettier --write {staged_files}
          stage_fixed: true
        secret-scan:
          run: gitleaks protect --staged --redact

    commit-msg:
      commands:
        commitlint:
          run: npx --no-install commitlint --edit {1}

    pre-push:
      commands:
        block-main-push:
          run: |
            branch=$(git symbolic-ref --short HEAD)
            [ "$branch" = "main" ] && echo "Direct push to main forbidden" && exit 1 || exit 0
    ```
- **Mandatory Practices（必須事項）**:
    - hookの定義、生成元、導入手順のいずれかをversion管理し、同じrevisionから再現できること。
    - clone／workspace bootstrap後に、採用したruntimeとpackage managerへ適した一貫した導入経路を提供すること。
    - local hookは高速なfeedbackであり、merge／releaseの最終根拠にしない。重要検査はCIまたはserver-side controlで再実行すること。
    - bypassを許可する場合は、理由、補償検査、監査証跡をriskに応じて要求すること。
- **Migration Note**: hook frameworkを変更する前に、OS／IDE／GUI clientの互換性、導入失敗、実測latency、部分stage、既存開発環境を比較し、観測期間とrollback条件をBlueprintへ定義する。
- **クロスリファレンス**: §2.5 lint-staged / §2.10 commitlint / §9.0 Multi-Layer Secret Scanning

### 9.4. Shallow Clone & Sparse Checkout for CI（CI 最適化のための部分 clone）

> **Note**: 本セクションは **Git 側の機能** の規律。CI/CD パイプライン全体の最適化は `engineering/000` および `operations/` ドメイン参照。

- **Law**: CIでは、jobの正しさに必要な履歴、tag、submodule、LFS object、pathを宣言し、完全性を壊さない範囲で転送、storage、I/Oを最小化する。
- **Depth Contract**: `fetch-depth`の数値は固定標準にしない。merge-base、変更範囲、versioning、changelog、provenance、bisectなど、jobが実際に参照する履歴から導く。
- **Shallow Clone（履歴の浅化）**:

    ```bash
    # 現在のrevisionだけで完結するjobの例
    git clone --depth=1 <url>

    # 履歴が必要なjobは必要量を取得し、不足時は明示的に拡張する例
    git clone --depth=50 <url>
    git fetch --deepen=50
    ```
- **Sparse Checkout（ファイルの部分取得・モノレポ向け）**:

    ```bash
    git clone --no-checkout --depth=1 <url> repo
    cd repo
    git sparse-checkout init --cone
    git sparse-checkout set apps/web packages/shared    # 対象ディレクトリのみ
    git checkout <revision>
    ```
- **Verification**: 最適化前後でcheckout時間、転送量、cache hit、job結果を実測し、必要な生成物、policy、変更検出が欠落しないことをfixtureまたはrepresentative changeで検証する。
- **Anti-Pattern**:
    - 根拠なく全履歴または最小履歴を全jobへ一律適用する。
    - sparse checkoutやpath filterにより、依存関係、policy file、generated artifact、security checkを取りこぼす。
    - ベンダー既定値や未検証の削減率をUniversalな性能保証として扱う。
- **クロスリファレンス**: §8.1 Git LFS（大ファイルの転送最適化）/ §9.2 Renovate（依存更新の batched 実行）

---

## Part 10: Anti-Pattern Catalog（アンチパターン統合表）

> **使い方**: PR レビュー / CI 自動チェック / オンボーディングチェックリストでこの表を参照

### 10.0. Forbidden Practices Quick Reference（禁則行為クイックリファレンス）

| カテゴリ | アンチパターン | 検出手段 | 関連 |
|---|---|---|---|
| **Branch** | 保護対象referenceへpolicyを迂回して直接変更する | Protected Reference Control | §6.0 |
| **Branch** | active owner、更新状態、統合計画なしにbranchを長期化する | inactivity／ownership check | §1.2 |
| **Branch** | マージ済みbranchや追跡情報を無期限に放置する | repository hygiene check | §3.0, §3.1 |
| **Commit** | 採用したmessage schemaで意図を識別できない | schema validation + review | §2.0, §2.8, §2.10 |
| **Commit** | 独立に検証・revertできない複数論理変更を混在させる | review + change graph | §2.1 |
| **Commit** | 組織が要求するAI利用・著作者・sign-off情報を欠く | policy validation | §2.8, §9.1 |
| **Change** | riskに対するreview可能性のbudgetを超え、分割不能の根拠もない | measured size／complexity signal | §2.3 |
| **Push** | 許可された復旧手順、lease、auditなしに共有履歴を上書きする | client feedback + server policy | §2.7, §6.0 |
| **Push** | local controlを迂回し、補償検査や理由を残さない | CI evidence + audit log | §9.3 |
| **Release** | 既存release referenceまたは公開済みartifactを追跡不能に差し替える | release integrity check | §7.0, §7.1 |
| **Merge** | conflict markerまたは未解決の生成差分を統合する | content scan + CI gate | — |
| **History** | credential失効・影響確認をせず、履歴削除だけでsecret incidentを閉じる | incident evidence + secret scan | §7.5, §9.0 |
| **History** | backup、mapping、coordination、検証なしに共有履歴を書き換える | approved runbook | §7.5 |
| **Worktree** | prunable metadata、stale branch config、tool互換性を放置する | `check-git-config-clean.sh` または同等検査 | §4.0–§4.4 |
| **Repo** | 対象platform間で改行、encoding、binary判定が再現できない | cross-platform CI | §8.0 |
| **Repo** | 大容量artifactを根拠なくGit objectへ格納する | repository size policy | §8.1 |
| **Repo** | ownership、update、trust、recovery modelなしにsubmodule等の外部参照を採用する | architecture review | §8.2 |
| **Review** | final revision、material risk、unresolved findingを確認した証拠がない承認 | approval evidence | §6.2, §6.3 |
| **Review** | 独立承認が必要な変更を作成者だけで承認・統合する | ownership + approval policy | §6.0, §6.1 |
| **Tooling** | local検査だけに依存し、server-sideまたはCIのsecret preventionがない | layered secret-control check | §9.0 |
| **Review** | AIの結果を根拠、誤検知判断、final revision確認なしに承認へ置換する | finding disposition + human approval evidence | §6.4 |
| **Tooling** | hook定義と導入経路が個人環境にしか存在しない | repository／bootstrap review | §9.3 |

---

## Appendix A: Cross-References（他ドメインの Git 利用）

| 関連トピック | 参照先 | 主関心事 |
|---|---|---|
| Commit signing / GPG | `security/000_security_privacy.md` | セキュリティ |
| SLSA / Sigstore | `security/200_oss_compliance.md` | サプライチェーン |
| Git history scrubbing | `security/300_ip_due_diligence.md` | IP/法務 |
| GitOps deployment | `operations/400_site_reliability.md` | SRE/IaC |
| Hot-fix branch protocol | `operations/500_incident_response.md` | インシデント対応 |
| Pre-commit hooks for tests | `quality/000_qa_testing.md` | QA Gate |
| Pre-commit secret scanning | `engineering/000_engineering_standards.md` Part III | シークレット保護 |
| DB Migration Immutability（暫定） | `engineering/000_engineering_standards.md` §10.4 | DB 安全性 |
| Zod/RHF Version Alignment（暫定） | `engineering/000_engineering_standards.md` §10.5 | フォーム整合性 |
| Zod Nullable Alignment（暫定） | `engineering/000_engineering_standards.md` §10.6 | DB-Code 整合性 |

> **Note**: §10.4-10.6 は本来ドメイン固有のため `engineering/200_supabase_architecture.md` または `engineering/300_web_frontend.md` へ移動候補。v1.4.x で再配置検討予定。

---

## Appendix B: 逆引き索引（キーワード → セクション）

| キーワード | セクション |
|---|---|
| Trunk-Based / 短命ブランチ | §1.0 – §1.2 |
| ブランチ命名（`feat/`, `fix/`） | §1.1 |
| Conventional Commits | §2.0 |
| Atomic Commits | §2.1 |
| PR Template | §2.2 |
| Reviewable Change Size / risk budget | §2.3 |
| Protected Reference Control / local pre-push feedback | §2.4 |
| Pre-Commit Auto-Formatting Hook（lint-staged 等） | §2.5 |
| マージ済みブランチ削除 | §3.0 |
| Stale remote tracking | §3.1 |
| Worktree状態 / `worktreeConfig`互換性 | §4.0 |
| Worktree cleanup commands | §4.1 |
| `check-git-config-clean.sh` | §4.2 |
| AI Agent 並行使用 | §4.3 |
| `.git/config` 健全性 | §5.0 |
| `.gitignore` AI artifacts | §5.1 |
| Merge Strategy Contract / history traceability | §2.6 |
| Force-Push / `--force-with-lease` | §2.7 |
| Commit Body / Trailers / `Co-Authored-By:` / Sign-off | §2.8 |
| fixup / autosquash / WIP 整理 | §2.9 |
| Protected Reference Control / Required Reviews / history policy | §6.0 |
| Ownership Resolution / CODEOWNERS等 | §6.1 |
| Review Response SLO / inactive change / Draft | §6.2 |
| Conventional Comments | §6.3 |
| SemVer Tag / annotated tag / pre-release | §7.0 |
| Commit Signing / Tag Signing / SSH Signing | §7.1 |
| Release Automation / release-please / semantic-release | §7.2 |
| Revert / Multi-Commit Revert | §7.3 |
| `git bisect` / `git reflog` | §7.4 |
| `git filter-repo` / Sensitive History Cleansing | §7.5 |
| `.gitattributes` / LF normalization | §8.0 |
| Git LFS / >10MB threshold | §8.1 |
| Submodule Policy / `git subtree` | §8.2 |
| Multi-Layer Secret Scanning / GitHub Push Protection | §9.0 |
| AI Co-Authored-By / AI Attribution | §9.1 |
| Dependency Update Automation / Renovate / Dependabot | §9.2 |
| Anti-Pattern Catalog | §10.0 |
| Conventional Commits Types (feat/fix/refactor/perf/docs/style/test/build/ci/chore/revert) | §2.0 |
| commitlint / commitizen / commit-msg validation | §2.10 |
| PR Required Fields (Risk / Rollback / Migration / ADR) | §2.2 |
| AI-Assisted Review Governance / review assistant | §6.4 |
| Hook Distribution and Tool Choice / lefthook / Husky / pre-commit | §9.3 |
| `git maintenance` / 自動 GC / commit-graph / prefetch | §7.6 |
| `.git-blame-ignore-revs` / mass-format / git blame 透明化 | §8.3 |
| Shallow Clone / Sparse Checkout / CI 最適化 / fetch-depth | §9.4 |

---

## 一次資料

- [git-worktree 公式ドキュメント](https://git-scm.com/docs/git-worktree.html) — worktree の一覧、削除、prune、repair、および worktree 固有設定
- [git-config 公式ドキュメント](https://git-scm.com/docs/git-config.html) — `--worktree` と `extensions.worktreeConfig` の正式な挙動
- [SLSA Source Track 要件](https://slsa.dev/spec/v1.2/source-requirements) — 高保証sourceにおけるreview、変更履歴、保護統制
- [GitHub Rulesets 公式ドキュメント](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets) — branch、tag、pushを対象にする保護規則の実装例
- [GitLab Approval Rules 公式ドキュメント](https://docs.gitlab.com/user/project/merge_requests/approvals/rules/) — role、group、対象branchに応じたapproval ruleの実装例

---

**Last Updated**: 2026-07-23
**Authority**: Universal Constitution (axiarch core)
**Classification**: Engineering — Git Workflow & Repository Hygiene
