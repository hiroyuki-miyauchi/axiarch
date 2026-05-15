# 600. Git Workflow & Repository Hygiene

> **Primary Directive**: "Git is history, and history is an asset. Daily operational hygiene neglect leads to asset degradation."
>
> **Priority Order**: Repository Integrity > Daily Workflow Velocity > Tool Compatibility > Convenience

This file consolidates **domain-agnostic Git operations that occur during daily development, regular work, and upload tasks** into a Universal Rule.
Domain-specific Git usage (security signing, GitOps, QA hooks, etc.) remains in respective domain files and is referenced from here.

---

## Table of Contents

| # | Part | Sections | Rule Count |
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
| | | **Total** | **45** |

---

## Scope Manifesto

✅ **Inclusion Criteria**:

- Git operations occurring during daily development, regular work, and upload tasks
- Branch / commit / worktree / push-pull / PR workflows
- Domain-agnostic Git best practices

❌ **Exclusion Criteria (refer to respective domain files)**:

- SLSA / Sigstore → `security/200_oss_compliance.md`
- Git history scrubbing for IP → `security/300_ip_due_diligence.md`
- GitOps deployment → `operations/400_site_reliability.md`
- Hot-fix branch protocol → `operations/500_incident_response.md`
- Pre-commit hooks for tests → `quality/000_qa_testing.md`
- DB Migration Immutability → `engineering/200_supabase_architecture.md` (currently temporarily in `engineering/000` §10.4)

> **Responsibility Split Note (Commit / Tag Signing)**: Git-side how-to (`git config gpg.format`, `git commit -S`, signing-key setup) lives in **§7.1** (this file). Key management, rotation, and compliance policy live in **`security/000_security_privacy.md`**. Use both in tandem.

---

## Part 1: Trunk-Based Development

### 1.0. Trunk-Based Development (Principle)

- **Principle**: Eliminate long-lived branches. Merge short-lived branches to `main` frequently (daily).
- **Stacked Diffs**: Avoid giant PRs by stacking small, dependent PRs.

### 1.1. Branch Naming Standard

- **Branch Naming**: Use `type/summary` format (e.g., `feat/user-profile`, `fix/login-bug`).
- **Types (fully aligned with §2.0 Conventional Commits)**:
    - Development: `feat/`, `fix/`, `refactor/`, `perf/`
    - Auxiliary: `docs/`, `style/`, `test/`, `build/`, `ci/`, `chore/`
    - History: `revert/<reverted-sha>`
    - Release: `release/v1.4.0` (release freeze), `hotfix/critical-auth-bug` (production emergency fix)
    - Exploration: `experiment/`, `spike/` (**lifespan ≤1 week**, aligned with §1.2 short-lived branch mandate)
- **Summary Discipline**: kebab-case, lowercase ASCII, 3–5 words (e.g., `feat/oauth-google-login`; bad: `feat/test123`).
- **Anti-Pattern**: branches without a type prefix (`wip/xxx`, `temp/xxx`, `mybranch/xxx`, `john-test`) are **forbidden**.

### 1.2. Short-Lived Branch Mandate

- **Law**: Branch lifetime should be **a few hours to maximum 2 days**.
- **Action**: When a giant merge-difficult branch threatens to form, hide it behind a Feature Flag in production and integrate to main early.

---

## Part 2: Commit & PR Standards

### 2.0. Conventional Commits

- **Format**: Strictly follow `type(scope): subject` format. Describe details in the project's native language.
- **Standard Types (Conventional Commits 1.0.0 full compliance)**:

    | Type | Use Case | SemVer Impact |
    |---|---|---|
    | `feat` | New feature | **minor bump** |
    | `fix` | Bug fix | **patch bump** |
    | `refactor` | Code change without external behavior change | none |
    | `perf` | Performance improvement (behavior unchanged) | patch bump (recommended) |
    | `docs` | Documentation only | none |
    | `style` | Formatting, whitespace, semicolons (logic unchanged) | none |
    | `test` | Adding/correcting test code | none |
    | `build` | Build system or external dependency changes (npm/cargo/poetry, etc.) | none |
    | `ci` | CI configuration or script changes | none |
    | `chore` | Miscellaneous tasks not covered above (renames, cleanup) | none |
    | `revert` | Revert a previous commit (paired with `git revert`) | context-dependent |
- **Breaking Change Notation**: Append `!` to the subject (e.g., `feat(api)!: drop /v1 endpoints`) OR include `BREAKING CHANGE: <description>` in the body trailer (see §2.8). **Either is required** to trigger a SemVer **major bump**.
- **Scope (Optional but Recommended)**: Make the affected area explicit (e.g., `feat(auth):`, `fix(api):`, `refactor(db):`). In monorepos, use the workspace name (`feat(web):`, `fix(api):`).

### 2.1. Atomic Commits

- **Law**: Each commit contains only "one logical change."

### 2.2. Pull Request Template Protocol

- **Law**: `.github/pull_request_template.md` MUST exist. The following **8 fields** are mandatory:

    ```markdown
    ## Type of Change
    <!-- feat / fix / refactor / perf / docs / style / test / build / ci / chore / revert -->

    ## What
    <!-- What changed. ≤3 sentences -->

    ## Why
    <!-- Motivation, problem, background. Make Linked Issue / ADR explicit -->
    Closes #<issue-number>
    Refs ADR-<number> (if applicable)

    ## How to Test
    <!-- Verification steps for reviewers/QA -->
    1.
    2.

    ## Risk Assessment
    <!-- Low / Medium / High. One-line rationale -->

    ## Rollback Plan
    <!-- Recovery procedure if this change breaks production. Is `git revert <sha>` enough, or are additional steps needed? -->

    ## Migration Notes
    <!-- DB migrations, config changes, breaking API changes. "None" if not applicable -->

    ## Screenshots / Recordings
    <!-- Mandatory for UI changes. Show Before/After side by side -->
    ```
- **CI Integration**: When the PR description is empty or required sections are missing, fail via **`actions/required-pr-fields-validator`**.
- **Anti-Pattern**: Submitting with template placeholders intact and sections empty → auto-rejected.

### 2.3. PR Size Mandate (100-Line Rule)

- **Law**: Keep PRs small. Aim for under 100 lines of changes. Direct push to `main` is prohibited; CI pass and review approval are mandatory.

### 2.4. Pre-Push Branch Protection Hook

- **Law**: All projects MUST mandate a `pre-push` hook that blocks direct pushes to protected branches (`main`, `release/*`, `production`).
- **Implementation**: The `pre-push` hook MUST check `git symbolic-ref HEAD` and reject pushes to protected refs such as `refs/heads/main`. (See §9.3 lefthook config for a concrete example.)
- **Cross-References**: Framework selection (lefthook / Husky / etc.) → §9.3 Hooks Distribution. Server-side complement → §6.0 Branch Protection.

### 2.5. Pre-Commit Auto-Formatting Hook

- **Law**: A `pre-commit` hook MUST auto-format staged files (`eslint --fix` / `prettier --write` / etc.). Use a tool that **scopes to staged files only** (lint-staged, or lefthook's `glob` + `staged_files`).
- **Cross-References**: Framework selection → §9.3 Hooks Distribution. Commit-message hook (commitlint) → §2.10.

### 2.6. Merge Strategy Mandate

- **Default Strategy: Squash & Merge**:
    - Feature-branch → `main` integration MUST default to **Squash & Merge**. Reason: `main` history becomes linear at the "logical change per PR" granularity, making `git log --oneline` readable.
    - In GitHub `Settings > General > Pull Requests`, enable ONLY "Allow squash merging"; disable the others.
- **Exception: Merge Commit**:
    - Permitted only when there is a legitimate need to preserve individual commit history (release-branch integration, multi-feature coordination merges).
- **Forbidden: Rebase Merge to main**:
    - Rebase Merge to `main` is **forbidden**. Stacking individual commits onto `main` makes back-compat checks, revert, and bisect harder.
- **Linear History on main**:
    - Enable "Require linear history" in GitHub Branch Protection. Combined with the merge-commit ban, this keeps history easier to understand and audit.
- **Local Rebase Discipline**:
    - `git rebase main` on your own working branch is **recommended** (sync before opening a PR). Rebasing **shared** branches is **strictly forbidden**.

### 2.7. Force-Push Protocol

- **Law: Use `--force-with-lease`, Never `--force`**:
    - When force-pushing personal branches is needed, MUST use `git push --force-with-lease`. `--force` is forbidden.
    - Reason: `--force-with-lease` only allows the push if the remote tip matches what you have locally → prevents overwriting collaborators' work.
- **Forbidden: Force-Push to Protected Branches**:
    - Force-push to `main` / `release/*` / `production` is **absolutely forbidden**. Block at the Branch Protection layer (see §6.0).
- **Allowed Use Cases**:
    - Cleanup-push after `rebase -i` on a personal branch
    - fixup → autosquash → force-push following review feedback (see §2.9)
- **Audit Trail**:
    - Monitor force-push events via GitHub `Audit log`. Slack notification integration is recommended.

### 2.8. Commit Body & Trailer Standards

- **Subject Line**:
    - ≤50 characters, imperative mood (`Add`, `Fix`, `Refactor`), no trailing period.
    - Format: `type(scope): subject` (see §2.0)
- **Body Wrapping**:
    - Wrap body at 72 chars (prevents `git log` display issues). Separate subject and body with a blank line.
- **Required Footers**:

    | Trailer | Purpose | Example |
    |---|---|---|
    | `Refs: #123` | Issue reference (no auto-close) | `Refs: #123` |
    | `Closes: #123` | Auto-close issue | `Closes: #123` |
    | `BREAKING CHANGE: <desc>` | Breaking change (triggers SemVer major bump) | `BREAKING CHANGE: API v2 endpoints removed` |
    | `Co-Authored-By: Name <email>` | Co-author attribution (incl. AI Agents) | `Co-Authored-By: Claude <noreply@anthropic.com>` |
    | `Signed-off-by: Name <email>` | DCO sign-off (mandatory for OSS) | Auto-added via `git commit -s` |
- **AI Pair-Programming Attribution Mandate**:
    - Every commit where an AI Agent (Claude / Copilot / Codex / etc.) **generated or modified code** MUST include a `Co-Authored-By:` trailer.
    - Purpose: post-hoc auditing and vulnerability tracking (synergy with §8.7 AI-Generated Code Provenance).
    - Example: `Co-Authored-By: Claude <noreply@anthropic.com>` / `Co-Authored-By: GitHub Copilot <copilot@github.com>`
- **Anti-Pattern Prohibitions**:
    - Single-word commits like `"fix"` / `"update"` / `"wip"` → unintelligible, auto-rejected
    - Subject > 50 chars → blocked by commitlint
    - Complex change with no body → if you can't articulate "why", the commit is immature

### 2.9. Fixup & Autosquash Discipline

- **Law: Squash WIP Commits Before Merge**:
    - "WIP" / "review fix" / "typo" commits in a PR MUST be absorbed into the original commit before merge using **`git commit --fixup=<sha>` + `git rebase -i --autosquash`**.
    - Reason: ensures `main` history retains only "logical change per PR" (when combined with §2.6 Squash Merge, this is automated).
- **Recommended Workflow**:

    ```bash
    # Apply review feedback
    git add .
    git commit --fixup=<original-commit-sha>

    # Reshape just before updating the PR
    git rebase -i --autosquash main

    # Force-push (personal branch only)
    git push --force-with-lease
    ```
- **Auto-Configuration**:
    - Recommend ALL developers run `git config --global rebase.autoSquash true`. fixup commits will be auto-positioned during `rebase -i`.

### 2.10. Conventional Commit Validation

- **Law**: Compliance with §2.0 types MUST be enforced **mechanically via commitlint**. Do not rely on manual review.
- **Required Setup (commitlint)**:

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
- **Hook Integration (Husky commit-msg)**:

    ```bash
    npx husky add .husky/commit-msg 'npx --no-install commitlint --edit $1'
    ```
- **CI Validation (PR title + all commits)**:
    - GitHub Actions: `wagoid/commitlint-github-action@v6` enforced as a required check.
    - When using Squash & Merge, the **PR title** becomes the squash commit message; lint the PR title too.
- **Optional UX Enhancement — commitizen**:
    - `npx cz` provides an interactive commit-message builder, flattening the learning curve for new developers.
- **Anti-Pattern Prohibitions**:
    - Bypassing the hook with `--no-verify` → forbidden by §10.0 Anti-Pattern Catalog
    - "commitlint failing? Just disable it" → discipline-loosening fixes are forbidden

---

## Part 3: Branch Hygiene Mandate

### 3.0. Branch Hygiene Mandate (Garbage Collection)

- **Law**: Abandoned branches are the #1 cause of environment-gap accidents. Delete merged branches immediately.
- **Action**:
    1. Before final task notification, verify `git branch --merged`
    2. Delete merged branches via `git branch -d <branch>`
    3. Clean up remote branches similarly (`git push origin --delete <branch>` or enable GitHub's auto-delete on merge)
- **Continuity**: Make checking `git branch --merged` an **engineer's breathing**.

### 3.1. Stale Remote Tracking References

- **Law**: Stale local tracking refs (for deleted remote branches) pollute `git branch -a`.
- **Action**: Periodically run `git fetch --prune` or `git remote prune origin`.

---

## Part 4: Worktree Hygiene Protocol

> **Domain**: Daily / dev environment / AI Agent tooling integration
>
> **Severity**: HIGH — Neglect causes complete failure of other AI agents (e.g., Antigravity).

### 4.0. The Worktree Config Pollution Problem

- **Context**: When any AI agent (Claude Code, Cursor, etc.) or developer runs `git worktree add`, Git **automatically appends** `[extensions] worktreeConfig = true` to `.git/config`.
- **Critical Gap**: `git worktree remove` does **NOT delete** this entry (Git's conservative behavior accounting for other potentially dependent worktrees).
- **Cumulative Result**: Each worktree creation/removal cycle adds to `.git/config`:
    1. `[extensions] worktreeConfig = true` (persistent)
    2. `[branch "<name>"]` stale settings (remain after worktree removal)
- **Symptoms**: Accumulated pollution causes:
    - **Antigravity's Go-based language server crash** — startup error "does not support extension: worktreeconfig", `ECONNREFUSED 127.0.0.1:50347`
    - **Complete chat function stoppage** for the affected project
    - Other projects unaffected, making **root cause identification extremely difficult**

### 4.1. Mandatory Cleanup Protocol

- **Law**: Verify `.git/config` health every time `git worktree add` or `git worktree remove` is executed.
- **Required Checks**:
    1. Check `git config --get extensions.worktreeConfig`
    2. Detect stale `[branch "*"]` entries via `git config --list | grep "branch\."`
- **Cleanup Commands** (Copy-paste-ready):

```bash
# 1. Remove worktree extension flag
git config --unset extensions.worktreeConfig 2>/dev/null

# 2. Bulk-remove stale claude/* branch config
for b in $(git branch | grep "claude/" | sed 's/^[ *]*//'); do
  git config --unset "branch.$b.vscode-merge-base" 2>/dev/null
  git config --unset "branch.$b.remote" 2>/dev/null
  git config --unset "branch.$b.merge" 2>/dev/null
done

# 3. (Optional) Delete unnecessary claude/* branches
git branch | grep "claude/" | xargs -I {} git branch -D {} 2>/dev/null
```

### 4.2. Automated Detection Script (Recommended)

- **Law**: Manual verification becomes ritualistic in large projects. Integrate **automated detection scripts** into CI / pre-commit hooks.
- **Reference Implementation**: `scripts/check-git-config-clean.sh` — axiarch's standard distributed detection/repair script.
- **Usage**:

```bash
./scripts/check-git-config-clean.sh         # Detection only (exit 1 if dirty)
./scripts/check-git-config-clean.sh --fix   # Detection + auto-repair
./scripts/check-git-config-clean.sh --quiet # CI silent mode (exit 1 if dirty)
```

### 4.3. Additional Caution for Parallel AI Agent Use

- **Context**: When using Claude Code and Antigravity in parallel, Claude Code's worktree operations break Antigravity.
- **Mitigation**:
    1. Consolidate to a single AI agent (recommended)
    2. When running in parallel, frequently execute `scripts/check-git-config-clean.sh --fix`
    3. Always run cleanup at AI agent termination / switching

### 4.4. Recurrence Documentation (Observed Cases)

- **Law**: This problem **structurally recurs** (persists as long as Git's behavior remains unchanged). Maintain the strategy of automated mitigation rather than manual response.
- **Observed Recurrences**:

    | Date | Project | Residual Entries |
    |---|---|---|
    | 2026-04-29 | inucomi (initial detection) | `[extensions] worktreeConfig = true` + `[branch "claude/agitated-rubin-1a895e"]` |
    | 2026-05-03 | inucomi (recurrence) | `[extensions] worktreeConfig = true` + 5 instances of `[branch "claude/*"]` |
    | 2026-05-03 | axiarch (detected during v1.3.2 release) | `[extensions] worktreeConfig = true` + `[branch "claude/nostalgic-moser-a1d7c8"]` |

---

## Part 5: Repository Hygiene & Config Integrity

### 5.0. `.git/config` Health Audit

- **Law**: `.git/config` is the **repository's nervous system**. Pollution disrupts various tool integrations.
- **Action**: Periodically `cat .git/config` and detect unexpected entries (especially `[extensions]` sections and stale `[branch "*"]`).

### 5.1. `.gitignore` for AI Agent Artifacts

- **Law**: Session-specific files generated by AI agents (worktrees, session logs, plan files, etc.) **must NEVER be committed**.
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

## Part 6: Branch Protection & Code Review

> **Domain**: Settings-level governance on GitHub / GitLab / Bitbucket
>
> **Severity**: HIGH — absence directly causes production incidents, miss-merges, and history pollution

### 6.0. Branch Protection Rules Mandate

- **Law**: `main` and all release branches MUST enforce the following Branch Protection rules:

    | Setting | Value | Rationale |
    |---|---|---|
    | Require a pull request before merging | ✅ ON | Block direct push |
    | Require approvals | **≥2 (minimum 1)** | Prevent review bypass |
    | Dismiss stale approvals when new commits are pushed | ✅ ON | Force re-review after edits |
    | Require review from Code Owners | ✅ ON | Pairs with §6.1 |
    | Require status checks to pass | ✅ ON (enumerate required checks) | Merge only on green CI |
    | Require branches to be up to date before merging | ✅ ON | Prevent merge against stale base |
    | Require signed commits | ✅ ON (for repos at SemVer minor+) | Pairs with §7.1 |
    | Require linear history | ✅ ON | Pairs with §2.6 |
    | Require deployments to succeed before merging | ✅ ON (when preview deploys exist) | Force preview verification |
    | Lock branch | ⚠️ Temporarily ON (during release freeze) | Emergency only |
    | Do not allow bypassing the above | ✅ ON (incl. admins) | No exceptions |
    | Restrict who can push | ✅ ON (CI bots only) | No human direct pushes |
    | Allow force pushes | ❌ OFF | Pairs with §2.7 |
    | Allow deletions | ❌ OFF | Prevent history loss |
- **Anti-Pattern Prohibitions**:
    - "Admins can bypass" setting → invites accidents and insider threat in emergencies
    - approvals = 1 in practice → single-perspective bias, rubber-stamping from review fatigue

### 6.1. CODEOWNERS Discipline

- **Law**: `.github/CODEOWNERS` MUST be present, mapping responsible engineers per directory.
- **Format**:

    ```
    # Syntax: <pattern> <@owner1> <@owner2> <@team>
    *                      @core-team
    /apps/web/             @frontend-team
    /apps/api/             @backend-team
    /infra/                @platform-team
    /docs/                 @docs-team
    *.sql                  @dba-team
    /security/             @security-team @cto
    ```
- **Required Practices**:
    - Every path MUST resolve to at least one owner (use `*` fallback as the last line)
    - Critical paths (`/security/`, `/infra/`, `*.sql`) MUST have **≥2 owners**
- **Synergy**: pairs with §6.0 "Require review from Code Owners" — every owner-tagged path goes through owner review.

### 6.2. PR Review SLA & Stale PR Hygiene

- **Review Response SLA**:
    - Once a PR is assigned to a reviewer, they MUST respond (Approve / Request Changes / Comment) within **24 business hours**.
    - SLA breach → Slack notification → escalation.
- **Stale PR Auto-Close**:
    - PRs idle for 7 days are auto-tagged "stale". After another 7 days, auto-closed.
    - Implementation: GitHub Actions `actions/stale@v9`.
- **Proper Use of Draft PRs**:
    - WIP MUST be a **Draft PR**, signaling "not ready for review". The SLA timer starts on "Ready for review".
- **Re-Review Triggering**:
    - When new commits arrive after approval, `Dismiss stale approvals` (§6.0) auto-invalidates them. Re-review is mandatory.

### 6.3. Conventional Comments for Code Review

- **Law**: Code review comments MUST follow the **Conventional Comments** format to ensure clarity of intent.
- **Required Labels**:

    | Label | Intent | Blocking |
    |---|---|---|
    | `praise:` | Praise for good implementation | No |
    | `nitpick:` / `nit:` | Minor remark (does not block merge) | No |
    | `suggestion:` | Improvement suggestion (author decides) | No |
    | `issue:` | Problem (must fix) | **Yes** |
    | `question:` | Clarification request | Sometimes |
    | `thought:` | Discussion seed / future consideration | No |
    | `chore:` | Small refactor / cleanup task | No |
- **Format Example**:

    ```
    issue (security): This input isn't schema-validated. Wrap with Zod.

    nitpick: `userPayload` conveys intent better than `data`.
    ```
- **Anti-Pattern Prohibitions**:
    - Unlabeled critical comments → unclear intent, can read as personal attack
    - Disguising `nitpick:` as `issue:` → distorts review priorities

### 6.4. AI-Assisted PR Review

- **Law**: AI-assisted review tools are adopted as **defense-in-depth** and MUST NOT replace human reviewers. **AI never becomes an approver.**
- **Recommended Tools (2026 stable)**:

    | Tool | Strengths | Languages/Ecosystem |
    |---|---|---|
    | **CodeRabbit** | Comprehensive review, line-level comments, summarization, conversational | Polyglot |
    | **Greptile** | Whole-repo context understanding, impact analysis | Polyglot |
    | **Codium PR-Agent** | OSS, self-hostable, custom prompts | Polyglot |
    | **GitHub Copilot Code Review** | GitHub-native, IDE integration | Polyglot |
- **Mandatory Boundaries**:
    - AI review MUST run **in parallel with** human review (not sequentially).
    - **AI comments are "suggestions", not "decisions".** Approval by the human reviewer designated in CODEOWNERS is the **only merge gate** (aligned with §6.0 / §6.1).
    - Even when AI says "LGTM", human reviewers MUST signal that they performed a deep review (≥10 minutes) using Conventional Comments labels (§6.3) like `praise:` / `issue:`.
- **Use Cases (Assistive Scope)**:
    - Style / naming-convention auto-detection
    - Obvious bugs, missing null checks, missing error handling
    - Detecting drift between PR description and actual implementation
    - Lightweight security scanning (OWASP top items) — but does NOT replace §9.0 Multi-Layer Secret Scanning
- **Anti-Pattern Prohibitions**:
    - **AI Rubber-Stamp**: human approves in seconds because AI said OK → violates the spirit of §6.2 PR Review SLA
    - **AI Over-Reliance**: delegating "design judgment" to AI → architectural decisions belong to ADR + humans (§1.33 Strong Opinions, Weakly Held / Disagree & Commit)
    - **AI Comment Suppression**: silently closing AI-flagged issues without resolving them → transparency violation
- **Cross-References**: §6.0 Branch Protection / §6.3 Conventional Comments / §1.11 AI-Augmented Engineering / §9.1 AI-Generated Commit Attribution

---

## Part 7: Tags, Releases & History Operations

> **Domain**: SemVer governance / release automation / past-history repair

### 7.0. SemVer Tag Discipline

- **Law**: All releases MUST be tagged following **Semantic Versioning 2.0.0**: `v<MAJOR>.<MINOR>.<PATCH>`.
- **Required Format**:
    - `vX.Y.Z` (leading `v` mandatory — Stripe / Vercel / Next.js convention)
    - Pre-release: `v1.4.0-rc.1` / `v1.4.0-beta.2` / `v1.4.0-alpha.1`
    - Build metadata: `v1.4.0+build.20260504` (informational only — no SemVer comparison effect)
- **Annotated Tags Mandatory**:
    - All release tags MUST be **annotated** (`git tag -a v1.4.0 -m "Release v1.4.0"`)
    - Lightweight tags are **forbidden** — they retain neither author, date, nor message.
- **Signed Tags (Recommended)**:
    - Production release tags MUST be GPG/SSH-signed (`git tag -s v1.4.0`)
    - Verify with `git tag -v v1.4.0`
- **Tag Immutability**:
    - Once pushed, tags MUST NOT be deleted or rewritten. Issue a new tag (`v1.4.1`) for fixes.

### 7.1. Commit & Tag Signing

- **Law**: Production repos at SemVer minor+ MUST require **signed commits and signed tags**.
- **Signing Methods**:

    | Method | Recommendation | Configuration |
    |---|---|---|
    | **SSH signing (recommended, Git 2.34+)** | ✅ | `git config gpg.format ssh; git config user.signingkey ~/.ssh/id_ed25519.pub` |
    | GPG signing (legacy) | ⚠️ Complex key management | `git config gpg.format openpgp` |
    | S/MIME (X.509) | ⚠️ Enterprise use | `git config gpg.format x509` |
- **Auto-Sign Configuration**:

    ```bash
    git config --global commit.gpgsign true
    git config --global tag.gpgsign true
    ```
- **GitHub Verification**: Register signing keys at Settings > SSH and GPG keys → commits show a `Verified` badge.
- **Cross-Reference**: Aligns with commit-signing requirements in `security/000_security_privacy.md`.

### 7.2. Release Automation

- **Recommended Tooling**:

    | Tool | Use Case | Language/Ecosystem |
    |---|---|---|
    | **release-please** (Google) | Conventional Commits → Release PR + Changelog | Polyglot |
    | **semantic-release** | Fully automated CI release (commit→tag→publish) | npm-centric |
    | **changesets** | Monorepo-friendly version management | npm/pnpm workspaces |
    | **goreleaser** | Go binary releases | Go |
- **Conventional Changelog**: Premised on Conventional Commits (§2.0). `feat:` → minor bump, `fix:` → patch bump, `BREAKING CHANGE` → major bump.
- **Required Outputs**:
    - Auto-generated Changelog on the GitHub Release page
    - SemVer-compliant tag (per §7.0, annotated)
    - Auto-publish to npm/PyPI/crates.io etc. (where applicable)

### 7.3. Revert over Force-Push

- **Law**: To undo a problematic commit already merged to `main`, use **`git revert`**. **Never** rewrite history via `git push --force`.
- **Reasons**:
    - Preserves history immutability (audit trail)
    - Doesn't break consistency with other developers' clones
    - The revert itself is recorded as a commit, providing transparency
- **Multi-Commit Revert**:

    ```bash
    # Single commit
    git revert <sha>

    # Consecutive range
    git revert <oldest-sha>^..<newest-sha>

    # Merge commit
    git revert -m 1 <merge-sha>
    ```

### 7.4. Bisect & Reflog as Safety Net

- **`git bisect` for Regression Hunting**:
    - Binary-search "when did it break?". With automated tests, runs unattended:

    ```bash
    git bisect start
    git bisect bad HEAD
    git bisect good v1.3.2
    git bisect run npm test         # pass/fail concludes
    git bisect reset                # cleanup
    ```
- **`git reflog` as Last-Resort Recovery**:
    - Commits accidentally lost via `reset --hard` / `rebase` are recoverable for ~90 days (default) via `git reflog`.

    ```bash
    git reflog                      # list of operations
    git reset --hard HEAD@{5}       # rewind 5 operations
    ```
- **Lesson**: with `git reflog`, almost every "oh no" is recoverable. Educate every engineer on its existence.

### 7.5. Sensitive History Cleansing

- **Law**: Accidentally committed **secrets / PII / confidential files** MUST be excised from history. On discovery, treat as the highest-priority task.
- **Modern Tool: `git filter-repo` (Recommended)**:
    - `git filter-branch` is **deprecated**. Use `git filter-repo` (officially recommended):

    ```bash
    pip install git-filter-repo

    # Remove a specific file from all history
    git filter-repo --invert-paths --path secrets.env --force

    # Replace a specific string across all history
    echo 'literal:OLD_API_KEY==>REDACTED' > replacements.txt
    git filter-repo --replace-text replacements.txt
    ```
- **Post-Cleansing Mandatory Steps**:
    1. force-push (request all team members re-clone)
    2. **Immediately revoke and rotate the secret** — history removal alone is insufficient; treat as already leaked
    3. Check GitHub Secret Scanning Alerts
    4. Record as an incident (`incident_report.md`)
- **Anti-Pattern Prohibitions**:
    - "Removed from history, so we're safe" → ❌ Secrets MUST be revoked. If pushed, treat as leaked.
    - Hiding commits via `git rebase` → ❌ shallow fix; recoverable from git reflog or forks.

### 7.6. Modern Repository Maintenance via `git maintenance`

- **Law**: The era of manual `git gc` is over. Starting with Git 2.31+, **enable `git maintenance` for background auto-housekeeping** as a mandatory practice.
- **Required Setup**:

    ```bash
    # Run once on every developer machine and CI runner
    git maintenance start
    ```

    This schedules the following tasks to run automatically via `cron` / `systemd timer` (or `launchd` on macOS, Scheduled Tasks on Windows):

    | Task | Frequency | Role |
    |---|---|---|
    | `gc` | weekly | Light cleanup of stale refs and unreachable objects |
    | `loose-objects` | hourly | Pack scattered loose objects |
    | `incremental-repack` | daily | Incremental repack of pack files |
    | `commit-graph` | hourly | Update commit-graph file (speeds up `git log`) |
    | `prefetch` | hourly | Pre-fetch remote refs (improves push/pull responsiveness) |
- **Verification**:

    ```bash
    git maintenance run --task=commit-graph    # Run a specific task manually
    cat .git/config | grep -A 10 maintenance   # Inspect configuration
    git config --get-all maintenance.repo      # List managed repos
    ```
- **Why Mandatory**:
    - On large repos (>10K commits), `git status` / `git log` perceived speed improves **2-10×**
    - Structurally solves the "nobody runs `git gc`" forgetfulness problem
- **Anti-Pattern Prohibitions**:
    - Running `git gc --aggressive` for the first time on a bloated repo → may hang for hours. Daily maintenance prevents this
    - Configuring `git maintenance start` only on CI → developer machines are left behind. **Required on all environments**
- **Cross-References**: §7.4 Bisect & Reflog (reflog is also maintained) / §8.1 Git LFS (LFS objects are managed separately)

---

## Part 8: Repository Configuration & Assets

### 8.0. `.gitattributes` Mandate

- **Law**: Every repository MUST contain a `.gitattributes` file explicitly governing line endings, LFS, and diff/merge drivers.
- **Required Minimum Content**:

    ```gitattributes
    # Line-ending normalization (Windows/macOS/Linux mixed environments)
    * text=auto eol=lf

    # Force LF (shell, YAML, Dockerfile, etc.)
    *.sh        text eol=lf
    *.yml       text eol=lf
    *.yaml      text eol=lf
    Dockerfile  text eol=lf
    Makefile    text eol=lf

    # Force CRLF (Windows-native)
    *.bat       text eol=crlf
    *.cmd       text eol=crlf

    # Binary declaration (no diff)
    *.png       binary
    *.jpg       binary
    *.pdf       binary
    *.zip       binary

    # Git LFS-managed (see §8.1)
    *.psd       filter=lfs diff=lfs merge=lfs -text
    *.mp4       filter=lfs diff=lfs merge=lfs -text

    # diff drivers
    *.md        diff=markdown

    # Merge strategy (union for lockfiles)
    package-lock.json  merge=union
    ```
- **Rationale**: Line-ending drift is the source of "diffs that only appear in CI". `.gitattributes` enforces uniformity at the source.

### 8.1. Git LFS Policy

- **Threshold**:
    - Binary files **>10 MB** SHOULD use Git LFS (recommended)
    - **>100 MB** MUST use Git LFS (GitHub hard limit)
- **Recommended Tracked Patterns**:

    ```bash
    git lfs install
    git lfs track "*.psd" "*.ai" "*.sketch" "*.fig"   # Design
    git lfs track "*.mp4" "*.mov" "*.wav" "*.flac"    # Media
    git lfs track "*.gguf" "*.safetensors" "*.bin"    # ML models
    git lfs track "*.zip" "*.tar.gz"                  # Archives (when needed)
    ```
- **Anti-Pattern Prohibitions**:
    - Migrating to LFS only after `git push` errors → bloated files persist in history (must remove via §7.5)
    - Pushing >10 MB files to `main` without LFS → slow clones, ballooning CI cost

### 8.2. Submodule Policy: Last Resort

- **Default: Avoid Submodules**:
    - Submodules are a notorious source of broken **clone / CI / DX**. Avoid by default.
- **Alternatives First**:
    1. **Package manager dependencies** (npm / pip / cargo / go modules) — top priority
    2. **Monorepo** (pnpm workspaces / Nx / Turborepo / Bazel)
    3. **`git subtree`** — when you want history embedded yet preserve independence
- **When Submodules ARE Justified**:
    - Tag-pinned fork of an OSS to avoid vendor lock-in
    - Internal SDK with independent release cycle, reused across multiple repos
- **Mandatory When Adopted**:
    - **Pin to a tag or specific SHA** (no `master` tracking)
    - Document responsibility clearly in `.gitmodules`
    - Always include `git submodule update --init --recursive` in README Setup

### 8.3. `.git-blame-ignore-revs` Discipline

- **Law**: **Mass-format commits** (Prettier / Black / gofmt sweeps, line-ending conversions, renames) MUST be recorded in `.git-blame-ignore-revs` to make them transparent to `git blame`.
- **Why Critical**:
    - When mass-format commits dominate `git blame`, "who wrote this line" is **permanently lost**
    - GitHub / GitLab / VS Code GitLens automatically recognize `.git-blame-ignore-revs` and skip listed SHAs
- **Required Setup**:

    `.git-blame-ignore-revs` (at repo root):

    ```
    # Apply Prettier across the codebase (2026-05-01)
    a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0

    # Apply Black to all Python files (2026-04-15)
    f0e9d8c7b6a5d4c3b2a1d0e9f8g7h6i5j4k3l2m1

    # Bulk CRLF → LF line-ending conversion (2026-03-20)
    1234567890abcdef1234567890abcdef12345678
    ```
- **Local Git Configuration**:

    ```bash
    # Make local `git blame` automatically skip listed SHAs
    git config blame.ignoreRevsFile .git-blame-ignore-revs
    ```
- **Mandatory Practices**:
    - Update `.git-blame-ignore-revs` **in the same PR** as the mass-format commit (post-hoc additions get forgotten)
    - **Comments are required**: prefix each SHA with a comment describing "what format / when"
    - **Use full SHAs** (short SHAs risk future collisions and invalidation)
- **Anti-Patterns**:
    - Merging a mass-format `chore: format` to `main` without updating `.git-blame-ignore-revs` → `git blame` is permanently broken
    - Adding regular commits (feat/fix) to `.git-blame-ignore-revs` → history concealment, audit violation
- **Cross-References**: §2.0 Conventional Commits (distinction between `style:` / `refactor:`) / §8.0 `.gitattributes`

---

## Part 9: Modern Tooling & Automation

### 9.0. Multi-Layer Secret Scanning

- **Law**: Block secret introduction with **≥2 defensive layers**. Single layer assumes it will be bypassed.

    | Layer | Tool | Timing | On Detection |
    |---|---|---|---|
    | **L1: Pre-commit (client)** | `gitleaks` / `trufflehog` / `detect-secrets` | Before `git commit` | Reject commit |
    | **L2: Pre-push (client)** | husky pre-push + gitleaks | Before `git push` | Reject push |
    | **L3: Server-side (last line)** | **GitHub Push Protection** / GitLab Secret Detection | On push receipt | Reject + notify |
    | **L4: Periodic Scan** | GitHub Secret Scanning / GitGuardian | Full history | Alert + auto-revoke integration |
- **Required for Public Repos**: GitHub Push Protection MUST be ON (free). Private repos: subscribe to Advanced Security.
- **Anti-Pattern Prohibitions**:
    - "We have pre-commit, that's enough" → ❌ bypassable via `--no-verify`. Always re-scan server-side.
    - Removing from history only → ❌ per §7.5, **secrets MUST be revoked and rotated**.

### 9.1. AI-Generated Commit Attribution Mandate

- **Law**: Every commit where an AI Agent **generated, modified, or contributed** code MUST include a `Co-Authored-By:` trailer.
- **Standard Attributions**:

    | AI Agent | Trailer |
    |---|---|
    | Claude Code (Anthropic) | `Co-Authored-By: Claude <noreply@anthropic.com>` |
    | GitHub Copilot | `Co-Authored-By: GitHub Copilot <copilot@github.com>` |
    | Cursor | `Co-Authored-By: Cursor <cursor@cursor.sh>` |
    | OpenAI Codex | `Co-Authored-By: OpenAI Codex <noreply@openai.com>` |
    | Google Antigravity | `Co-Authored-By: Antigravity <noreply@google.com>` |
- **Why Mandatory**:
    - **Audit trail**: when a future vulnerability surfaces, AI-generated code is searchable across history (`git log --grep="Co-Authored-By: Claude"`)
    - **Legal clarity**: explicit attribution and responsibility split
    - **Quality governance**: measure AI-generation rate (e.g., 60% of all commits are AI co-authored)
- **Preservation Through Squash Merge**:
    - GitHub's Squash & Merge **automatically preserves** Co-Authored-By trailers (concatenating from all PR commits)
    - When squashing locally, retain manually
- **Cross-Reference**: §8.7 AI-Generated Code Provenance Protocol (paired with `@ai-coauthor` headers)

### 9.2. Renovate / Dependabot Discipline

- **Law**: Every project MUST adopt **Renovate or Dependabot** for automated dependency-update PRs.
- **Required Configuration (Recommended)**:

    ```json
    // renovate.json (recommended)
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
    - **patch / minor**: green CI → auto-merge (no human review)
    - **major**: human review required (potential breaking changes)
    - **security alert**: immediate PR; auto-merge on green CI
- **Anti-Pattern Prohibitions**:
    - PR explosion → cap with `prConcurrentLimit`; adopt batched updates
    - All-auto-merge → major bumps will break; gate with review

### 9.3. Hooks Distribution & Framework Choice

- **Law**: Git Hooks MUST guarantee **all team members run the same implementation**. Putting hooks only in personal `~/.gitconfig` is forbidden.
- **Framework Comparison (2026 stable)**:

    | Framework | Language | Config File | Performance | Recommendation |
    |---|---|---|---|---|
    | **lefthook** | Go binary | `lefthook.yml` (single) | ⚡ Parallel, fastest | ✅ **First choice (2026+)** |
    | **Husky** | Node.js | `.husky/<hook-name>` shell scripts | 🐢 Sequential, Node startup overhead | ⚠️ Node-only projects |
    | **pre-commit (Python)** | Python | `.pre-commit-config.yaml` | 🐢 Medium speed, requires Python | ⚠️ Python / monorepo-friendly |
    | **Native `core.hooksPath`** | Shell | `.githooks/<hook-name>` | ⚡ Fastest | ⚠️ Poor team-config automation |
- **Recommended Default: lefthook**:
    - Single YAML declaration for all hooks, parallel execution, language-agnostic, full Windows/macOS/Linux support.
    - Sample config (`lefthook.yml`):

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
- **Mandatory Practices**:
    - Configuration files MUST be **checked into the repo** (`.husky/` / `lefthook.yml` / `.pre-commit-config.yaml`)
    - `package.json` `prepare` script (or README Setup section) MUST **auto-install hooks after clone**
    - `--no-verify` is a **last resort**; when used, the reason MUST be stated in the PR description (see §10.0 Anti-Pattern Catalog)
- **Migration Note (Existing Husky → lefthook)**:
    - In large repos, `pre-commit` often exceeds 5 seconds. lefthook's parallel execution typically delivers 3–5× speedup.
    - Migrate gradually: keep husky alongside lefthook → 1 week of verification → remove husky.
- **Cross-References**: §2.5 lint-staged / §2.10 commitlint / §9.0 Multi-Layer Secret Scanning

### 9.4. Shallow Clone & Sparse Checkout for CI

> **Note**: This section governs **Git-side mechanisms**. End-to-end CI/CD pipeline optimization belongs to `engineering/000` and `operations/` domains.

- **Law**: In CI (GitHub Actions / CircleCI / GitLab CI / etc.), clone **only the minimum history and files needed** to eliminate wasted transfer, storage, and time.
- **Shallow Clone (history shallowing)**:

    ```bash
    # Default for all CI jobs (GitHub Actions actions/checkout@v4 already defaults to fetch-depth: 1)
    git clone --depth=1 <url>

    # Only jobs that need `git log` or bisect should fetch deeper
    git clone --depth=50 <url>
    git fetch --deepen=50              # Extend depth on demand
    ```

    | fetch-depth | Use Case |
    |---|---|
    | `1` | Simple lint / build / test jobs (default) |
    | `50` | Conventional-commit validation, changelog generation |
    | `0` (full) | Only jobs that analyze full history (release-please / semantic-release) |
- **Sparse Checkout (partial file fetch — for monorepos)**:

    ```bash
    git clone --no-checkout --depth=1 <url> repo
    cd repo
    git sparse-checkout init --cone
    git sparse-checkout set apps/web packages/shared    # Only the target dirs
    git checkout main
    ```

    Effect: a 100GB monorepo can be checked out at <1GB.
- **GitHub Actions Example**:

    ```yaml
    - uses: actions/checkout@v4
      with:
        fetch-depth: 1                      # Enough for most jobs
        sparse-checkout: |                  # In a monorepo, only the relevant workspaces
          apps/web
          packages/shared
        sparse-checkout-cone-mode: true
    ```
- **Cost Impact**:
    - Shallow clone: **30-60% reduction** in CI startup time on large repos
    - Sparse checkout (monorepos): **80-95% reduction** in storage / I/O; enables affected-workspace-only builds
- **Anti-Patterns**:
    - Specifying `fetch-depth: 0` (full history) on **every job** → wasteful transfer, runaway CI cost
    - Monorepo without sparse-checkout → every job expands all files, I/O dominates
- **Cross-References**: §8.1 Git LFS (large-file transfer optimization) / §9.2 Renovate (batched dependency updates)

---

## Part 10: Anti-Pattern Catalog

> **Usage**: Reference this table during PR review / CI auto-checks / onboarding checklists.

### 10.0. Forbidden Practices Quick Reference

| Category | Anti-Pattern | Detection | Reference |
|---|---|---|---|
| **Branch** | Direct push to `master`/`main` | Branch Protection | §6.0 |
| **Branch** | Long-running branch (>2 days) | Stale check / Slack alert | §1.2 |
| **Branch** | Abandoned merged branches | Auto `git branch --merged` check | §3.0 |
| **Commit** | Single-word messages (`"fix"` / `"wip"`) | commitlint | §2.0, §2.8 |
| **Commit** | Non-atomic (multiple logical changes) | Caught at review | §2.1 |
| **Commit** | AI-generated without `Co-Authored-By:` | commit-msg hook | §9.1 |
| **Commit** | PR exceeding 100 lines | PR template / lint | §2.3 |
| **Push** | `git push --force` in general (especially to protected branches) | pre-push hook (`--force-with-lease` required) + Branch Protection | §2.7, §6.0 |
| **Push** | `--no-verify` abuse (hook bypass) | Watch in code review | §9.3 |
| **Tag** | Lightweight tag for release | `git tag --list --format='%(taggerdate)'` check | §7.0 |
| **Tag** | Moving / deleting an existing tag | Branch Protection (tag protection rules) | §7.0 |
| **Merge** | Rebase Merge to `main` | GitHub merge button settings | §2.6 |
| **Merge** | Conflict markers (`<<<<<<<`) committed | grep + CI gate | — |
| **History** | Secret commit → only history removal | Secret scanning | §7.5, §9.0 |
| **History** | Using `git filter-branch` (deprecated) | Caught at code review | §7.5 |
| **Worktree** | `worktreeConfig` residue | `check-git-config-clean.sh` | §4.0–§4.4 |
| **Repo** | No `.gitattributes` → line-ending drift | Verify in CI | §8.0 |
| **Repo** | >10 MB binary not in LFS | pre-commit + CI | §8.1 |
| **Repo** | Unjustified submodule adoption | Architecture review | §8.2 |
| **Review** | Rubber-stamp approval (seconds) | Avg review-time metric | §6.2 |
| **Review** | Self-merging your own PR | Defended by CODEOWNERS | §6.0, §6.1 |
| **Tooling** | No server-side secret scan | GitHub Push Protection | §9.0 |
| **Commit** | Branch/commit without type prefix (commitlint failure) | commitlint CI gate | §2.0, §2.10 |
| **Review** | AI Rubber-Stamp (human approves in seconds because AI said OK) | Avg review-time metric | §6.4 |
| **Tooling** | Hook config only on personal machine (no team distribution) | Repository review | §9.3 |

---

## Appendix A: Cross-References (Git Usage in Other Domains)

| Related Topic | Reference | Primary Concern |
|---|---|---|
| Commit signing / GPG | `security/000_security_privacy.md` | Security |
| SLSA / Sigstore | `security/200_oss_compliance.md` | Supply Chain |
| Git history scrubbing | `security/300_ip_due_diligence.md` | IP/Legal |
| GitOps deployment | `operations/400_site_reliability.md` | SRE/IaC |
| Hot-fix branch protocol | `operations/500_incident_response.md` | Incident Response |
| Pre-commit hooks for tests | `quality/000_qa_testing.md` | QA Gate |
| Pre-commit secret scanning | `engineering/000_engineering_standards.md` Part III | Secrets Protection |
| DB Migration Immutability (transitional) | `engineering/000_engineering_standards.md` §10.4 | DB Safety |
| Zod/RHF Version Alignment (transitional) | `engineering/000_engineering_standards.md` §10.5 | Form Integrity |
| Zod Nullable Alignment (transitional) | `engineering/000_engineering_standards.md` §10.6 | DB-Code Integrity |

> **Note**: §10.4-10.6 are domain-specific and candidates for relocation to `engineering/200_supabase_architecture.md` or `engineering/300_web_frontend.md`. Scheduled for review in v1.4.x.

---

## Appendix B: Reverse Index (Keyword → Section)

| Keyword | Section |
|---|---|
| Trunk-Based / short-lived branches | §1.0 – §1.2 |
| Branch naming (`feat/`, `fix/`) | §1.1 |
| Conventional Commits | §2.0 |
| Atomic Commits | §2.1 |
| PR Template | §2.2 |
| 100-line rule / PR Size | §2.3 |
| Pre-Push Branch Protection Hook (block direct push to protected branches) | §2.4 |
| Pre-Commit Auto-Formatting Hook (lint-staged, etc.) | §2.5 |
| Merged branch deletion | §3.0 |
| Stale remote tracking | §3.1 |
| Worktree pollution / `worktreeConfig` | §4.0 |
| Worktree cleanup commands | §4.1 |
| `check-git-config-clean.sh` | §4.2 |
| Parallel AI agent use | §4.3 |
| `.git/config` health | §5.0 |
| `.gitignore` AI artifacts | §5.1 |
| Merge Strategy / Squash & Merge / Rebase forbidden | §2.6 |
| Force-Push / `--force-with-lease` | §2.7 |
| Commit Body / Trailers / `Co-Authored-By:` / Sign-off | §2.8 |
| fixup / autosquash / WIP cleanup | §2.9 |
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
| `git maintenance` / auto GC / commit-graph / prefetch | §7.6 |
| `.git-blame-ignore-revs` / mass-format / git blame transparency | §8.3 |
| Shallow Clone / Sparse Checkout / CI optimization / fetch-depth | §9.4 |

---

**Last Updated**: 2026-05-05
**Authority**: Universal Constitution (axiarch core)
**Classification**: Engineering — Git Workflow & Repository Hygiene
