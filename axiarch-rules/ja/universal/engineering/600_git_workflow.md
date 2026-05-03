# 600. Git Workflow & Repository Hygiene（Git ワークフローとリポジトリ衛生）

> **Supreme Directive**: 「Git は履歴であり、履歴は資産である。日常運用の不衛生は資産毀損につながる」
>
> **優先順位**: Repository Integrity > Daily Workflow Velocity > Tool Compatibility > Convenience

このファイルは、**日常的な開発・通常作業・upload で発生するドメイン非依存の Git 操作** を集約する Universal Rule である。
ドメイン固有の Git 利用（セキュリティ署名・GitOps・QA hooks 等）は各ドメインファイルに残置し、本ファイルからクロスリファレンスする。

---

## 目次 (Table of Contents)

| # | パート | セクション | ルール数 |
|---|---|---|---|
| 1 | Trunk-Based Development | §1.0 – §1.2 | 3 |
| 2 | Commit & PR Standards | §2.0 – §2.5 | 6 |
| 3 | Branch Hygiene Mandate | §3.0 – §3.1 | 2 |
| 4 | Worktree Hygiene Protocol | §4.0 – §4.4 | 5 |
| 5 | Repository Hygiene & Config Integrity | §5.0 – §5.1 | 2 |
| | | **合計** | **18** |

---

## このファイルの守備範囲（Scope Manifesto）

✅ **抽出基準（含める）**:

- 日常的な開発・通常作業・upload で発生する Git 操作
- ブランチ・コミット・worktree・push/pull・PR 等の workflow
- ドメイン非依存の Git ベストプラクティス

❌ **残置基準（含めない・各ドメインファイル参照）**:

- Commit signing / GPG → `security/000_security_privacy.md`
- SLSA / Sigstore → `security/200_oss_compliance.md`
- Git history scrubbing for IP → `security/300_ip_due_diligence.md`
- GitOps deployment → `operations/400_site_reliability.md`
- Hot-fix branch protocol → `operations/500_incident_response.md`
- Pre-commit hooks for tests → `quality/000_qa_testing.md`
- DB Migration Immutability → `engineering/200_supabase_architecture.md`（暫定で `engineering/000` §10.4 に滞在）

---

## Part 1: Trunk-Based Development（トランクベース開発）

### 1.0. トランクベース開発（Principle）

- **原則**: 長寿命のブランチは廃止し、短命のブランチから `main` へ頻繁に（毎日）マージします。
- **Stacked Diffs**: 巨大なPRを避け、依存関係のある小さなPRを積み重ねる手法を推奨します。

### 1.1. ブランチ命名規約

- **Branch Naming Standard**: ブランチ名は `type/summary` 形式で統一します（例: `feat/user-profile`, `fix/login-bug`）。
- **Types**: `feat`, `fix`, `refactor`, `chore`。

### 1.2. 短命ブランチの強制

- **Law**: ブランチの寿命は原則として **数時間〜最大2日**。
- **Action**: 巨大マージ困難ブランチが発生しそうな場合は、Feature Flag で本番非表示にして main に早期統合せよ。

---

## Part 2: Commit & PR Standards（コミットとPR標準）

### 2.0. Conventional Commits

- **Format**: `type(scope): subject` 形式を厳守します。本文にはプロジェクト設定言語で詳細を記述します。

### 2.1. Atomic Commits

- **Law**: 1つのコミットには「1つの論理的変更」のみを含めます。

### 2.2. Pull Request Template Protocol

- **Law**: `.github/pull_request_template.md` を作成し、"Type of change", "How to test", "Screenshots" の3項目は必須です。

### 2.3. PR Size Mandate（100行ルール）

- **Law**: PRは小さく保ちます。原則として変更行数 100行以内を目標に。`main` への直接プッシュは禁止し、CI通過とレビュー承認を必須とします。

### 2.4. Husky Pre-Push Guard

- **Law**: 全てのプロジェクトにおいて、`pre-push` フックによる `main` ブランチへの直接プッシュ禁止を義務とします。
- **実装**: husky の `pre-push` で `git symbolic-ref HEAD` をチェックし、`refs/heads/main` 等の保護ブランチへの直接 push を拒否。

### 2.5. Automated Git Hooks Protocol（Lint Staged）

- **Law**: `lint-staged` を導入し、コミットされるファイルに対して自動的に `eslint --fix` と `prettier --write` を実行することを義務付けます。

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
- **Reference Implementation**: `scripts/check-git-config-clean.sh` — axiarch 標準配布の自動検出/修復スクリプト
- **使用例**:

```bash
./scripts/check-git-config-clean.sh         # 検出のみ（exit 1 if dirty）
./scripts/check-git-config-clean.sh --fix   # 検出 + 自動修復
./scripts/check-git-config-clean.sh --quiet # CI 用サイレントモード（汚染なら exit 1）
```

### 4.3. AI Agent 並行使用時の追加注意

- **Context**: Claude Code と Antigravity を並行使用する場合、Claude Code の worktree 操作が Antigravity を破綻させる。
- **Mitigation**:
    1. 単一 AI Agent 運用に集約（推奨）
    2. 並行運用時は `scripts/check-git-config-clean.sh --fix` を頻繁に実行
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
| Husky / pre-push guard | §2.4 |
| lint-staged / git hooks | §2.5 |
| マージ済みブランチ削除 | §3.0 |
| Stale remote tracking | §3.1 |
| Worktree pollution / `worktreeConfig` | §4.0 |
| Worktree cleanup commands | §4.1 |
| `check-git-config-clean.sh` | §4.2 |
| AI Agent 並行使用 | §4.3 |
| `.git/config` 健全性 | §5.0 |
| `.gitignore` AI artifacts | §5.1 |

---

**Last Updated**: 2026-05-04 (v1.4.0)
**Authority**: Universal Constitution (axiarch core)
**Classification**: Engineering — Git Workflow & Repository Hygiene
