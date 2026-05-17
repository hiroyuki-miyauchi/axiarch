# 600. Git Workflow & Repository Hygiene（Git ワークフローとリポジトリ衛生）

> **Primary Directive**: 「Git は履歴であり、履歴は資産である。日常運用の不衛生は資産毀損につながる」
>
> **優先順位**: Repository Integrity > Daily Workflow Velocity > Tool Compatibility > Convenience

このファイルは、**日常的な開発・通常作業・upload で発生するドメイン非依存の Git 操作** を集約する Universal Rule である。
ドメイン固有の Git 利用（セキュリティ署名・GitOps・QA hooks 等）は各ドメインファイルに残置し、本ファイルからクロスリファレンスする。

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

- **原則**: 長寿命のブランチは廃止し、短命のブランチから `main` へ頻繁に（毎日）マージします。
- **Stacked Diffs**: 巨大なPRを避け、依存関係のある小さなPRを積み重ねる手法を推奨します。

### 1.1. ブランチ命名規約

- **Branch Naming Standard**: ブランチ名は `type/summary` 形式で統一します（例: `feat/user-profile`, `fix/login-bug`）。
- **Types（§2.0 Conventional Commits と完全整合）**:
    - 開発系: `feat/`, `fix/`, `refactor/`, `perf/`
    - 補助系: `docs/`, `style/`, `test/`, `build/`, `ci/`, `chore/`
    - 履歴系: `revert/<reverted-sha>`
    - リリース系: `release/v1.4.0`（リリース凍結用）, `hotfix/critical-auth-bug`（本番緊急修正用）
    - 探索系: `experiment/`, `spike/`（**寿命 1 週間以内**、§1.2 短命ブランチ強制と整合）
- **Summary 規律**: kebab-case、英小文字のみ、3〜5 単語以内（例: `feat/oauth-google-login`、NG: `feat/test123`）。
- **Anti-Pattern**: `wip/xxx`, `temp/xxx`, `mybranch/xxx`, `john-test` 等の **type 不在ブランチは禁止**。

### 1.2. 短命ブランチの強制

- **Law**: ブランチの寿命は原則として **数時間〜最大2日**。
- **Action**: 巨大マージ困難ブランチが発生しそうな場合は、Feature Flag で本番非表示にして main に早期統合せよ。

---

## Part 2: Commit & PR Standards（コミットとPR標準）

### 2.0. Conventional Commits

- **Format**: `type(scope): subject` 形式を厳守します。本文にはプロジェクト設定言語で詳細を記述します。
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

- **Law**: `.github/pull_request_template.md` を **必須配置**。以下 **8 項目** を必須テンプレとする：

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
- **CI 連携**: PR description が空 / 必須セクション未記入の場合、**`actions/required-pr-fields-validator`** で fail させる。
- **アンチパターン**: 「テンプレを残したまま空欄で submit」 → 自動 reject。

### 2.3. PR Size Mandate（100行ルール）

- **Law**: PRは小さく保ちます。原則として変更行数 100行以内を目標に。`main` への直接プッシュは禁止し、CI通過とレビュー承認を必須とします。

### 2.4. Pre-Push Branch Protection Hook（プッシュ前ブランチ保護フック）

- **Law**: 全てのプロジェクトで、`pre-push` フックによる `main` 等の保護ブランチへの直接プッシュ禁止を義務とする。
- **実装**: `pre-push` フックで `git symbolic-ref HEAD` をチェックし、`refs/heads/main` 等の保護ブランチへの直接 push を拒否する（実装例は §9.3 lefthook 設定を参照）。
- **クロスリファレンス**: 具体的なフレームワーク（lefthook / Husky 等）の選定は §9.3 Hooks Distribution / §6.0 Branch Protection（サーバー側補完）

### 2.5. Pre-Commit Auto-Formatting Hook（コミット前自動整形フック）

- **Law**: `pre-commit` フックでステージされたファイルに自動整形（`eslint --fix` / `prettier --write` 等）を適用することを義務付ける。実装には **staged ファイルのみ対象とするツール**（lint-staged / lefthook の `glob` + `staged_files` 等）を使用すること。
- **クロスリファレンス**: 具体的なフレームワーク選定は §9.3 Hooks Distribution / §2.10 commitlint（commit-msg フック）

### 2.6. Merge Strategy Mandate（マージ戦略義務）

- **Default Strategy: Squash & Merge（既定: スカッシュマージ）**:
    - 機能ブランチ → `main` への統合は **Squash & Merge** を既定とする。理由: `main` 履歴が「PR 単位の論理的変更」で線形化され、`git log --oneline` が読める。
    - GitHub の `Settings > General > Pull Requests` で「Allow squash merging」のみ有効化、他は無効化（強制）。
- **Exception: Merge Commit（例外: マージコミット）**:
    - リリースブランチ統合・複数機能の協調マージなど、**個別コミット履歴を保持する正当な理由がある場合のみ** マージコミットを許可。
- **Forbidden: Rebase Merge to main（禁止: main への Rebase Merge）**:
    - `main` への Rebase Merge は **禁止**。複数コミットが個別に `main` に積まれると後方互換性確認・revert・bisect が困難になる。
- **Linear History on main（main の線形履歴）**:
    - GitHub Branch Protection で「Require linear history」を **有効化**。マージコミット禁止と組み合わせて履歴の単純性を担保。
- **Local Rebase Discipline（ローカル Rebase 規律）**:
    - 自分の作業ブランチでの `git rebase main` は **推奨**（PR 出す前に最新化）。ただし **共有ブランチに対する rebase は厳禁**。

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

> **Domain**: 通常作業 / 開発時 / 開発環境 / AI Agent ツール統合
>
> **Severity**: HIGH — 放置で他 AI Agent（Antigravity 等）が完全停止する

### 4.0. The Worktree Config Pollution Problem（worktree 残留問題）

- **Context**: 任意の AI エージェント（Claude Code, Cursor 等）または `git worktree add` を実行する開発者が worktree を作成すると、Git は `.git/config` に `[extensions] worktreeConfig = true` を **自動追記** する。
- **Critical Gap**: `git worktree remove` ではこのエントリは **削除されない**（Git の仕様: 他 worktree が依存している可能性を考慮した保守的挙動）。
- **累積結果**: worktree の作成・削除を繰り返すたび、`.git/config` には：
    1. `[extensions] worktreeConfig = true`（永続）
    2. `[branch "<name>"]` ステイル設定（worktree 削除後も残る）
- **症状**: 累積した汚染は以下を引き起こす:
    - **Antigravity の Go ベース language server クラッシュ** — 起動時に "does not support extension: worktreeconfig" エラー、`ECONNREFUSED 127.0.0.1:50347`
    - 該当プロジェクトの **チャット機能完全停止**
    - 他のプロジェクトには影響しないため、原因特定が **著しく困難**

### 4.1. Mandatory Cleanup Protocol（毎回義務）

- **Law**: `git worktree add` および `git worktree remove` を実行する毎に、`.git/config` の健全性を検証する。
- **Required Checks**:
    1. `git config --get extensions.worktreeConfig` の有無確認
    2. `git config --list | grep "branch\."` でステイル `[branch "*"]` エントリ確認
- **Cleanup Commands** (Copy-paste-ready):

```bash
# 1. worktree 拡張フラグを除去
git config --unset extensions.worktreeConfig 2>/dev/null

# 2. ステイル claude/* ブランチ config を一括除去
for b in $(git branch | grep "claude/" | sed 's/^[ *]*//'); do
  git config --unset "branch.$b.vscode-merge-base" 2>/dev/null
  git config --unset "branch.$b.remote" 2>/dev/null
  git config --unset "branch.$b.merge" 2>/dev/null
done

# 3. 不要な claude/* ブランチ自体を削除（Optional）
git branch | grep "claude/" | xargs -I {} git branch -D {} 2>/dev/null
```

### 4.2. Automated Detection Script（推奨）

- **Law**: 大規模プロジェクトでは手動確認は形骸化する。**自動検出スクリプト** を CI / pre-commit に組み込むこと。
- **Reference Implementation**: `axiarch-scripts/check-git-config-clean.sh` — axiarch 標準配布の自動検出/修復スクリプト
- **使用例**:

```bash
./axiarch-scripts/check-git-config-clean.sh         # 検出のみ（exit 1 if dirty）
./axiarch-scripts/check-git-config-clean.sh --fix   # 検出 + 自動修復
./axiarch-scripts/check-git-config-clean.sh --quiet # CI 用サイレントモード（汚染なら exit 1）
```

### 4.3. AI Agent 並行使用時の追加注意

- **Context**: Claude Code と Antigravity を並行使用する場合、Claude Code の worktree 操作が Antigravity を破綻させる。
- **Mitigation**:
    1. 単一 AI Agent 運用に集約（推奨）
    2. 並行運用時は `axiarch-scripts/check-git-config-clean.sh --fix` を頻繁に実行
    3. AI Agent 終了時 / 切替時に必ずクリーンアップ実行

### 4.4. Recurrence Documentation（再発履歴・観測例）

- **Law**: この問題は **構造的に再発する**（Git 本体の挙動が変わらない限り永続）。手動対応に頼らず自動化で受け流す戦略を堅持せよ。
- **観測された再発例**:

    | 発生日 | プロジェクト | 残留エントリ |
    |---|---|---|
    | 2026-04-29 | inucomi（初回検出） | `[extensions] worktreeConfig = true` + `[branch "claude/agitated-rubin-1a895e"]` |
    | 2026-05-03 | inucomi（再発） | `[extensions] worktreeConfig = true` + 5 件の `[branch "claude/*"]` |
    | 2026-05-03 | axiarch（v1.3.2 リリース時に検出） | `[extensions] worktreeConfig = true` + `[branch "claude/nostalgic-moser-a1d7c8"]` |

---

## Part 5: Repository Hygiene & Config Integrity（リポジトリ衛生）

### 5.0. `.git/config` Health Audit

- **Law**: `.git/config` は **リポジトリの神経系統**。汚染は様々なツール連携を断絶する。
- **Action**: 定期的に `cat .git/config` を確認し、想定外のエントリ（特に `[extensions]` セクションや stale `[branch "*"]`）を検知せよ。

### 5.1. `.gitignore` for AI Agent Artifacts

- **Law**: AI Agent が生成するセッション固有ファイル（worktree、session log、plan files 等）は **絶対にコミットしない**。
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

### 6.0. Branch Protection Rules Mandate（ブランチ保護規則義務）

- **Law**: `main` および全 release ブランチには **以下の Branch Protection** を必須適用：

    | 設定項目 | 値 | 理由 |
    |---|---|---|
    | Require a pull request before merging | ✅ ON | 直接 push 禁止 |
    | Require approvals | **2 名以上**（最低 1 名） | レビューバイパス防止 |
    | Dismiss stale approvals when new commits are pushed | ✅ ON | 改変後の再レビュー強制 |
    | Require review from Code Owners | ✅ ON | §6.1 と連携 |
    | Require status checks to pass | ✅ ON（必須 check 列挙） | CI 緑のみマージ可 |
    | Require branches to be up to date before merging | ✅ ON | 古い base での merge 防止 |
    | Require signed commits | ✅ ON（SemVer minor 以上のリポジトリ） | §7.1 と連携 |
    | Require linear history | ✅ ON | §2.6 と連携 |
    | Require deployments to succeed before merging | ✅ ON（preview deploy あり） | preview の動作確認強制 |
    | Lock branch | ⚠️ 一時的に ON（リリース凍結時） | 非常時のみ |
    | Do not allow bypassing the above | ✅ ON（管理者含む） | 例外を作らない |
    | Restrict who can push | ✅ ON（CI bot のみ） | 人間の直接 push を禁止 |
    | Allow force pushes | ❌ OFF | §2.7 と連携 |
    | Allow deletions | ❌ OFF | 履歴消失防止 |
- **アンチパターン禁止**:
    - 「管理者は bypass 可」設定 → 緊急時の事故・内部脅威を招く
    - approvals = 1 で運用 → 単一視点バイアス、レビュー疲労による rubber-stamp

### 6.1. CODEOWNERS Discipline（CODEOWNERS 規律）

- **Law**: `.github/CODEOWNERS` を **必須配置**し、ディレクトリ単位で responsible engineers を明示する。
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
    - 全パスは少なくとも 1 つの owner に到達すること（fallback `*` を最終行に）
    - 重要パス（`/security/`, `/infra/`, `*.sql`）は **2 名以上の owner** を指定
- **連携**: §6.0「Require review from Code Owners」と組み合わせ、責任所在のあるパスは必ず owner レビューを通過させる。

### 6.2. PR Review SLA & Stale PR Hygiene（PR レビュー SLA・停滞 PR 衛生）

- **Review Response SLA（応答期限）**:
    - PR が assigned reviewer に通知されてから **24 営業時間以内** に「Approve / Request Changes / Comment」のいずれかで応答する義務。
    - SLA 違反時は Slack 通知 → エスカレーション。
- **Stale PR Auto-Close（停滞 PR の自動クローズ）**:
    - 7 日間活動のない PR は自動的に "stale" ラベル付与。さらに 7 日経過で auto-close。
    - GitHub Actions: `actions/stale@v9` で実装。
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

- **Law**: AI 補助レビューツールは **defense-in-depth** として導入し、**人間レビュアーの代替にはしない**。AI は approver にならない。
- **Recommended Tools（2026 stable）**:

    | Tool | 強み | 言語/エコシステム |
    |---|---|---|
    | **CodeRabbit** | 包括的レビュー、line-level コメント、要約生成、対話型 | 多言語 |
    | **Greptile** | リポジトリ全体の文脈理解、影響範囲分析 | 多言語 |
    | **Codium PR-Agent** | OSS、自前ホスト可能、カスタムプロンプト | 多言語 |
    | **GitHub Copilot Code Review** | GitHub 統合、IDE 連携 | 多言語 |
- **Mandatory Boundaries（必須の境界）**:
    - AI レビューは **必ず人間レビューと並行** で実行する（順次ではなく並列）。
    - **AI コメントは "示唆" であり "決定" ではない**。CODEOWNERS で指定された人間 reviewer の approval が **唯一の merge ゲート**（§6.0 / §6.1 と整合）。
    - AI が「LGTM」と返しても、人間 reviewer が deep review（≥10 分）したことを `praise:` / `issue:` 等の Conventional Comments（§6.3）で示すこと。
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

### 9.2. Renovate / Dependabot Discipline（依存関係自動更新規律）

- **Law**: 全プロジェクトに **Renovate または Dependabot** を導入し、依存関係更新を自動 PR 化する。
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
    - **patch / minor**: CI 緑 → 自動マージ（人間レビュー不要）
    - **major**: 人間レビュー必須（破壊的変更の可能性）
    - **security alert**: 即時 PR、CI 緑なら自動マージ
- **アンチパターン禁止**:
    - PR 数の爆発 → `prConcurrentLimit` で上限設定、batched updates 採用
    - 全自動マージ → major bump で破綻、レビューゲートを設けよ

### 9.3. Hooks Distribution & Framework Choice（フック配布・フレームワーク選定）

- **Law**: Git Hook は **チームメンバー全員が同じ実装を使う** ことを担保する。「個人の `~/.gitconfig` に書く」は禁止。
- **Framework Comparison（2026 stable）**:

    | Framework | 言語 | 設定ファイル | パフォーマンス | 推奨度 |
    |---|---|---|---|---|
    | **lefthook** | Go バイナリ | `lefthook.yml`（単一）| ⚡ 並列実行・最速 | ✅ **第一選択（2026+）** |
    | **Husky** | Node.js | `.husky/<hook-name>` シェルスクリプト | 🐢 直列、Node 起動オーバーヘッド | ⚠️ Node プロジェクトのみ |
    | **pre-commit (Python)** | Python | `.pre-commit-config.yaml` | 🐢 中速、Python 環境必須 | ⚠️ Python/モノレポ向け |
    | **Native `core.hooksPath`** | Shell | `.githooks/<hook-name>` | ⚡ 最速 | ⚠️ 共有設定の自動化が貧弱 |
- **Recommended Default: lefthook**:
    - 単一 YAML 定義で全 hook を宣言、並列実行、言語非依存、Windows/macOS/Linux 完全対応。
    - 設定例 (`lefthook.yml`):

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
    - **設定ファイルは必ず checked-in**（`.husky/` / `lefthook.yml` / `.pre-commit-config.yaml`）
    - `package.json` の `prepare` スクリプト（または README の Setup 節）で **clone 後に自動セットアップ** されること
    - `--no-verify` 使用は **最終手段**、使用時は PR description に理由明記（§10.0 Anti-Pattern Catalog 参照）
- **Migration Note（既存 Husky → lefthook）**:
    - 大規模リポジトリでは `pre-commit` が 5 秒超になりがち。lefthook の並列実行で 3-5 倍高速化が一般的。
    - 移行は段階的に: 既存 husky 設定を残しつつ lefthook 並走 → 1 週間動作確認 → husky 撤去。
- **クロスリファレンス**: §2.5 lint-staged / §2.10 commitlint / §9.0 Multi-Layer Secret Scanning

### 9.4. Shallow Clone & Sparse Checkout for CI（CI 最適化のための部分 clone）

> **Note**: 本セクションは **Git 側の機能** の規律。CI/CD パイプライン全体の最適化は `engineering/000` および `operations/` ドメイン参照。

- **Law**: CI（GitHub Actions / CircleCI / GitLab CI 等）では **必要最小限の履歴・ファイル** のみを clone し、無駄な転送・ストレージ・時間を排除する。
- **Shallow Clone（履歴の浅化）**:

    ```bash
    # 全 CI ジョブの既定（GitHub Actions actions/checkout@v4 では fetch-depth: 1 が既定）
    git clone --depth=1 <url>

    # `git log` や bisect が必要なジョブのみ深く取得
    git clone --depth=50 <url>
    git fetch --deepen=50              # 必要時に追加取得
    ```

    | fetch-depth | 用途 |
    |---|---|
    | `1` | 単純な lint / build / test ジョブ（既定） |
    | `50` | conventional-commit 検証、changelog 生成 |
    | `0`（full） | release-please / semantic-release 等の履歴解析が必要なジョブのみ |
- **Sparse Checkout（ファイルの部分取得・モノレポ向け）**:

    ```bash
    git clone --no-checkout --depth=1 <url> repo
    cd repo
    git sparse-checkout init --cone
    git sparse-checkout set apps/web packages/shared    # 対象ディレクトリのみ
    git checkout main
    ```

    効果: 100GB モノレポでも 1GB 以下に絞れる。
- **GitHub Actions 例**:

    ```yaml
    - uses: actions/checkout@v4
      with:
        fetch-depth: 1                      # ほとんどのジョブはこれで十分
        sparse-checkout: |                  # モノレポなら対象 workspace のみ
          apps/web
          packages/shared
        sparse-checkout-cone-mode: true
    ```
- **Cost Impact**:
    - shallow clone: 大規模リポジトリで CI 起動時間 **30-60% 削減**
    - sparse checkout（モノレポ）: ストレージ・I/O **80-95% 削減**、affected workspaces のみビルド可能
- **Anti-Pattern**:
    - `fetch-depth: 0`（full history）を **全ジョブで指定** → 無駄な転送、CI 課金爆増
    - sparse-checkout 未採用のモノレポ → ジョブごとに全ファイル展開、I/O が支配的に
- **クロスリファレンス**: §8.1 Git LFS（大ファイルの転送最適化）/ §9.2 Renovate（依存更新の batched 実行）

---

## Part 10: Anti-Pattern Catalog（アンチパターン統合表）

> **使い方**: PR レビュー / CI 自動チェック / オンボーディングチェックリストでこの表を参照

### 10.0. Forbidden Practices Quick Reference（禁則行為クイックリファレンス）

| カテゴリ | アンチパターン | 検出手段 | 関連 |
|---|---|---|---|
| **Branch** | `master`/`main` への直接 push | Branch Protection | §6.0 |
| **Branch** | Long-running branch（>2日） | Stale check / Slack alert | §1.2 |
| **Branch** | マージ済みブランチ放置 | `git branch --merged` 自動チェック | §3.0 |
| **Commit** | `"fix"` / `"wip"` のみのメッセージ | commitlint | §2.0, §2.8 |
| **Commit** | Atomic でない（複数論理変更） | レビューで指摘 | §2.1 |
| **Commit** | AI 生成だが `Co-Authored-By:` なし | commit-msg hook | §9.1 |
| **Commit** | 100 行超 PR | PR template / lint | §2.3 |
| **Push** | `git push --force` 全般（特に保護ブランチへの force push） | pre-push hook (`--force-with-lease` 必須) + Branch Protection | §2.7, §6.0 |
| **Push** | `--no-verify` 濫用（hook bypass） | コードレビューで監視 | §9.3 |
| **Tag** | 軽量タグのリリース | `git tag --list --format='%(taggerdate)'` チェック | §7.0 |
| **Tag** | 既存タグの移動・削除 | Branch Protection (tag protection rules) | §7.0 |
| **Merge** | `main` への Rebase Merge | GitHub merge button 設定 | §2.6 |
| **Merge** | Conflict marker (`<<<<<<<`) を含むコミット | grep + CI gate | — |
| **History** | secret コミット → 履歴から消すだけ | secret scanning | §7.5, §9.0 |
| **History** | `git filter-branch` 使用（deprecated） | コードレビュー | §7.5 |
| **Worktree** | worktreeConfig 残留 | `check-git-config-clean.sh` | §4.0–§4.4 |
| **Repo** | `.gitattributes` なし → 改行揺れ | CI で検証 | §8.0 |
| **Repo** | >10MB バイナリ非 LFS | pre-commit + CI | §8.1 |
| **Repo** | 不要 submodule 採用 | アーキテクチャレビュー | §8.2 |
| **Review** | rubber-stamp approval（数秒で承認） | 平均レビュー時間メトリクス監視 | §6.2 |
| **Review** | 自分の PR を自分で merge | CODEOWNERS で防御 | §6.0, §6.1 |
| **Tooling** | サーバー側 secret scan なし | GitHub Push Protection | §9.0 |
| **Commit** | type 不在ブランチ・コミット（commitlint 不通過） | commitlint CI gate | §2.0, §2.10 |
| **Review** | AI Rubber-Stamp（AI が OK → 人間が秒で approve） | レビュー時間メトリクス監視 | §6.4 |
| **Tooling** | hook 設定が個人のみ・チーム共有なし | Repository review | §9.3 |

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
| 100行ルール / PR Size | §2.3 |
| Pre-Push Branch Protection Hook（保護ブランチ直 push 禁止） | §2.4 |
| Pre-Commit Auto-Formatting Hook（lint-staged 等） | §2.5 |
| マージ済みブランチ削除 | §3.0 |
| Stale remote tracking | §3.1 |
| Worktree pollution / `worktreeConfig` | §4.0 |
| Worktree cleanup commands | §4.1 |
| `check-git-config-clean.sh` | §4.2 |
| AI Agent 並行使用 | §4.3 |
| `.git/config` 健全性 | §5.0 |
| `.gitignore` AI artifacts | §5.1 |
| Merge Strategy / Squash & Merge / Rebase 禁止 | §2.6 |
| Force-Push / `--force-with-lease` | §2.7 |
| Commit Body / Trailers / `Co-Authored-By:` / Sign-off | §2.8 |
| fixup / autosquash / WIP 整理 | §2.9 |
| Branch Protection Rules / Required Reviews / Linear History | §6.0 |
| CODEOWNERS | §6.1 |
| PR Review SLA / Stale PR / Draft PR | §6.2 |
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
| Renovate / Dependabot / Auto-Merge Policy | §9.2 |
| Anti-Pattern Catalog | §10.0 |
| Conventional Commits Types (feat/fix/refactor/perf/docs/style/test/build/ci/chore/revert) | §2.0 |
| commitlint / commitizen / commit-msg validation | §2.10 |
| PR Required Fields (Risk / Rollback / Migration / ADR) | §2.2 |
| AI-Assisted PR Review (CodeRabbit / Greptile / Codium) | §6.4 |
| lefthook / Husky / pre-commit / Hooks Distribution | §9.3 |
| `git maintenance` / 自動 GC / commit-graph / prefetch | §7.6 |
| `.git-blame-ignore-revs` / mass-format / git blame 透明化 | §8.3 |
| Shallow Clone / Sparse Checkout / CI 最適化 / fetch-depth | §9.4 |

---

**Last Updated**: 2026-05-05
**Authority**: Universal Constitution (axiarch core)
**Classification**: Engineering — Git Workflow & Repository Hygiene
