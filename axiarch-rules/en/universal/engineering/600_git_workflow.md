# 600. Git Workflow & Repository Hygiene

> **Primary Directive**: "Git is history, and history is an asset. Daily operational hygiene neglect leads to asset degradation."
>
> **Priority Order**: Repository Integrity > Daily Workflow Velocity > Tool Compatibility > Convenience

This file consolidates **domain-agnostic Git operations that occur during daily development, regular work, and upload tasks** into a Universal Rule.
Domain-specific Git usage (security signing, GitOps, QA hooks, etc.) remains in respective domain files and is referenced from here.

## Universal Application Contract

The invariants in this file are history integrity, change traceability, ownership and approval, reproducible integration, recoverability, and isolation of concurrent work. Branch names, lifetime, diff size, commit format, merge strategy, approval count, SLA, hooks, hosting services, AI tools, and notification destinations are reference implementations or Blueprint parameters unless required by law, contract, an official platform constraint, or an explicit safety rationale. An environment without Pull Requests, GitHub, CODEOWNERS, or merge queues conforms when it provides equivalent change proposals, independent approval, ownership, serialization, evidence, and rollback. Individuals and small teams may combine roles; high-assurance changes separate proposal and approval where possible, or use explicit risk acceptance and an independent release control.

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

- **Principle**: Keep integration changes reviewable and measure unintegrated time and conflict risk. Select trunk-based development, release branches, stacked diffs, or another model in the Blueprint from the product's release model, regulatory obligations, multi-version maintenance, hardware or mobile review, and offline-development constraints.
- **Short-Cycle Integration**: Short-lived branches and frequent integration are the normal default, but neither a daily cadence nor a fixed lifetime is a Universal requirement. A necessary long-lived branch has an owner, synchronization method, security-fix backport policy, and exit condition.

### 1.1. Branch Naming Standard

- **Branch Naming**: Define one machine-verifiable repository or organization schema that makes purpose, work item, or release intent traceable. `type/summary` is a reference format.
- **Types (fully aligned with §2.0 Conventional Commits)**:
    - Development: `feat/`, `fix/`, `refactor/`, `perf/`
    - Auxiliary: `docs/`, `style/`, `test/`, `build/`, `ci/`, `chore/`
    - History: `revert/<reverted-sha>`
    - Release: `release/v1.4.0` (release freeze), `hotfix/critical-auth-bug` (production emergency fix)
    - Exploration: `experiment/`, `spike/`
- **Summary Discipline**: Exclude personal names and secrets, and use a concise identifier compatible with the adopted tools and Unicode policy. Kebab-case, lowercase ASCII, and three to five words are a reference default.
- **Anti-Pattern**: Prohibit temporary branches whose owner, purpose, or exit condition cannot be traced, and names intended to bypass protected-reference policy.

### 1.2. Short-Lived Branch Mandate

- **Law**: Expose branch age, base divergence, unresolved conflicts, and security-patch delay. Require an owner and resolution plan when a branch exceeds the Blueprint's risk budget.
- **Action**: Choose compatibility shims, branch by abstraction, feature flags, stacked diffs, staged migration, or another suitable technique to integrate or isolate incomplete work safely. Neither a fixed two-day limit nor feature flags are the only conforming method.

---

## Part 2: Commit & PR Standards

### 2.0. Conventional Commits

- **Format**: Define a repository commit schema from which release notes, automation, and auditors can reconstruct change intent. Conventional Commits `type(scope): subject` is a reference implementation suited to SemVer automation; another verifiable schema may conform.
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

- **Law**: A change proposal retains enough information for a reviewer to judge at least purpose, difference, verification evidence, risk, rollback, and migration or compatibility impact. `.github/pull_request_template.md` and the following eight fields are a GitHub reference implementation:

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
- **CI Integration**: Machine-validate required fields in the adopted change-proposal schema through the VCS, review system, or CI. Do not make one Action the only conforming mechanism.
- **Anti-Pattern**: Reject placeholders, empty fields, or unverifiable descriptions before approval.

### 2.3. Reviewable Change Size

- **Law**: Keep a change proposal small enough for a reviewer to understand one intent, independent verification, and an explicit rollback. Do not use line count alone to classify risk; distinguish generated files, lockfiles, schemas, migrations, and binary changes. One hundred lines is a reference signal for considering a split, not a conformance threshold. Enforce mandatory checks and approval for protected changes through server-side policy or an equivalent control.

### 2.4. Pre-Push Branch Protection Hook

- **Law**: Reject unauthorized changes to protected references through an authoritative server-side policy or equivalent control. A local `pre-push` hook is one early-feedback mechanism and cannot be the final control because it is bypassable.
- **Implementation**: If a hook is used, account for remote references, multiple worktrees, detached HEAD, and GUI or bot paths, and follow the distribution contract in §9.3.
- **Cross-References**: Framework selection (lefthook / Husky / etc.) → §9.3 Hooks Distribution. Server-side complement → §6.0 Branch Protection.

### 2.5. Pre-Commit Auto-Formatting Hook

- **Law**: Reproduce formatter and lightweight-lint results deterministically in local tooling or CI, with CI as the authoritative gate. If a local hook auto-fixes content, it stays within the staged scope, preserves partial staging, and lets the user inspect the mutation. A hook itself is not mandatory for every project.
- **Cross-References**: Framework selection → §9.3 Hooks Distribution. Commit-message hook (commitlint) → §2.10.

### 2.6. Merge Strategy Mandate

- **Strategy Contract**: Whether the repository uses squash, merge commits, rebase merge, or fast-forward, it must trace the change proposal, final revision, approval, tests, release artifact, and rollback unit.
- **Reference Default**: Squash & Merge with linear history is effective for a product repository that wants one revertable commit per proposal. A repository that maintains multiple versions, synchronizes an upstream, or preserves signed commits may choose merge commits or another method.
- **Policy**: Declare the merge method per repository and do not mix methods chaotically on the same protected reference. Enforce it with hosting settings, server hooks, a merge bot, or an equivalent control.
- **Local Rebase Discipline**:
    - A solely owned branch may be rebased. Rewriting a shared branch requires explicit agreement from every collaborator and a recovery point; normally prefer a merge or a new branch.

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

> **Domain**: Daily work / development environment / concurrent-tool integration
>
> **Severity**: HIGH — stale metadata or tool incompatibility can cause branch confusion, work loss, or tool failure

### 4.0. Worktree State and Compatibility

- **Official Boundary**: `extensions.worktreeConfig` is a supported Git feature for worktree-specific configuration and may be enabled by features such as sparse checkout. Its presence alone is not pollution. Never unset it unconditionally while an active worktree or `config.worktree` depends on it.
- **Stale State**: Detect prunable administrative data after a worktree directory was removed outside supported commands, `branch.<name>` configuration for a missing local branch, and path inconsistency after a move.
- **Tool Compatibility**: If an older Git or surrounding tool cannot read a supported extension, confirm the Git version, error, reproduction, and scope, then choose tool upgrade, isolation, serialized execution, or a time-bounded exception. Deleting valid Git configuration is not the default recovery.
- **Supported Operations**: Inspect with `git worktree list --porcelain`, clean with `git worktree remove` or `git worktree prune`, and repair move inconsistencies with `git worktree repair`. Never edit `.git/worktrees` directly.

### 4.1. Mandatory Cleanup Protocol

- **Law**: At a change boundary that adds, removes, or moves a worktree, verify the worktree inventory, prunable state, branch configuration, and unsaved changes. The same outcome may be automated or enforced at task completion instead of requiring a manual action after every command.
- **Required Checks**:
    1. Inspect registered worktrees, HEAD, branch, and lock or prunable state with `git worktree list --porcelain`
    2. Inspect administrative data Git considers prunable with `git worktree prune --dry-run --verbose`
    3. Compare `git config --local --name-only --get-regexp '^branch\.'` with local branch refs
    4. When using `extensions.worktreeConfig`, verify `git config --worktree` and support in adopted Git and tools
- **Cleanup Commands**:

```bash
git worktree list --porcelain
git worktree prune --dry-run --verbose
git worktree prune --verbose
git worktree repair <moved-worktree-path>
```

`git worktree prune` and `repair` are limited to metadata Git manages. Deleting branch refs or unsaved changes and disabling `extensions.worktreeConfig` are separate human decisions and are not part of this cleanup.

### 4.2. Automated Detection Script (Recommended)

- **Law**: Repositories using multiple worktrees or tools integrate detection based on supported Git commands into a task-completion gate, CI, scheduled audit, or equivalent. An individual repository may perform the same check manually.
- **Reference Implementation**: `axiarch-scripts/check-git-config-clean.sh` — a reference script that detects and repairs prunable worktree metadata and configuration for missing local branches.
- **Usage**:

```bash
./axiarch-scripts/check-git-config-clean.sh         # Detection only (exit 1 if dirty)
./axiarch-scripts/check-git-config-clean.sh --fix   # Detection + auto-repair
./axiarch-scripts/check-git-config-clean.sh --quiet # CI silent mode (exit 1 if dirty)
```

### 4.3. Additional Caution for Concurrent Tools and AI Agents

- **Context**: IDEs, AI agents, automation, and developers that concurrently modify repository metadata, branches, indexes, or worktrees can encounter support differences, locks, base confusion, or overwriting of unseen changes.
- **Mitigation**:
    1. Isolate worktrees, branches, credentials, write scope, and owners per tool
    2. Serialize operations writing the same branch or index with a lock, queue, handoff, or equivalent
    3. Check status, worktree inventory, remote parity, and unpublished changes at task start, handoff, and completion
    4. Review dry-run output before repair and never delete active worktrees, branch refs, or unsaved changes automatically

### 4.4. Failure Pattern Documentation

- **Law**: An incident or compatibility issue is anonymized into reusable conditions, signals, and controls rather than importing a project name, user name, or real branch name into Universal. Keep observation dates, projects, and sensitive logs in a Blueprint or incident record.
- **Reusable Failure Patterns**:

    | Condition | Signal | Control |
    |---|---|---|
    | Worktree path deleted through file operations | `git worktree prune --dry-run --verbose` reports a prunable entry | run `git worktree prune` after confirming cleanliness |
    | Worktree moved through file operations | registered path differs from actual path | run `git worktree repair` |
    | Config section remains after local branch deletion | `branch.<name>` key exists without a local ref | review and remove only that section |
    | Tool does not support a valid Git extension | reproducible unsupported-extension error | upgrade tool or Git, isolate, serialize, or use a time-bounded exception |

---

## Part 5: Repository Hygiene & Config Integrity

### 5.0. `.git/config` Health Audit

- **Law**: `.git/config` is the **repository's nervous system**. Pollution disrupts various tool integrations.
- **Action**: Run `git config --show-origin --list`, `git worktree list --porcelain`, and comparison with local branch refs on material events and the Blueprint's risk-based cadence. Do not treat a supported extension as anomalous solely because it exists; identify its source and consumer.

### 5.1. `.gitignore` for AI Agent Artifacts

- **Law**: Classify agent output into canonical team-shared configuration and task evidence versus credentials, personal settings, caches, session logs, and temporary worktrees. The former may be versioned under schema, review, and retention rules; only ephemeral or sensitive artifacts are ignored. Do not exclude `plan files` based on their name alone.
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

### 6.0. Protected Reference Control

- **Law**: Apply a ruleset, branch protection, server hook, ACL, or equivalent control from the adopted VCS to protected references that can reach production, releases, policy, CI, signing keys, or distribution metadata. The table is a GitHub reference profile; its values are not universal for every repository:

    | Setting | Value | Rationale |
    |---|---|---|
    | Require a pull request before merging | ✅ ON | Block direct push |
    | Require approvals | Risk-based; two-party review for high assurance | Prevent review bypass |
    | Dismiss stale approvals when new commits are pushed | ✅ ON | Force re-review after edits |
    | Require review from Code Owners | ✅ ON | Pairs with §6.1 |
    | Require status checks to pass | ✅ ON (enumerate required checks) | Merge only on green CI |
    | Require branches to be up to date before merging | ✅ ON | Prevent merge against stale base |
    | Require signed commits | ON when required by source or artifact identity policy | Pairs with §7.1 |
    | Require linear history | ON when required by the selected merge method | Pairs with §2.6 |
    | Require deployments to succeed before merging | ✅ ON (when preview deploys exist) | Force preview verification |
    | Lock branch | ⚠️ Temporarily ON (during release freeze) | Emergency only |
    | Do not allow bypassing the above | Normally ON; emergency bypass is a recorded break-glass event | No unaudited exceptions |
    | Restrict who can push | Approved actors and automation only | Minimize direct changes |
    | Allow force pushes | ❌ OFF | Pairs with §2.7 |
    | Allow deletions | ❌ OFF | Prevent history loss |
- **Required Outcome**: Machine-verify required checks, approval of the final revision, renewed review after approval-changing commits, force-push and deletion controls, and the owner, reason, expiry, and audit trail of any bypass. Derive approval counts from risk, regulation, and team size; high-assurance areas meet SLSA Source two-party-review requirements.

### 6.1. Ownership Resolution

- **Law**: Resolve an accountable owner and required reviewer mechanically from a changed path, component, schema, or policy. `.github/CODEOWNERS` is a GitHub reference implementation; GitLab Code Owners, Gerrit groups, ownership registries, and equivalent mechanisms may conform.
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
    - Every protected subject resolves to at least one accountable owner or continuity route
    - An ownerless critical path blocks the change; enforce expert review and independent approval according to risk
    - Apply ownership, review, and renewed-review controls to the ownership policy itself
- **Synergy**: Combine ownership resolution with §6.0 protected-reference control so ownership is more than a notification list.

### 6.2. PR Review SLA & Stale PR Hygiene

- **Review Response SLO**:
    - Define a response objective and escalation route in the Blueprint from change risk, team time zones, and incident or release urgency, then measure wait time and review load. Twenty-four business hours is a reference starting value.
    - Do not fix the destination to Slack; use the adopted chat, email, ticket, pager, or equivalent route.
- **Stale Change Hygiene**:
    - For inactive changes, decide whether to confirm ownership, update the base, split, supersede, or close. Do not unconditionally auto-close at a fixed age; classify security fixes, external contributions, and long-running migrations.
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

- **Law**: If AI-assisted review is used, treat it as defense-in-depth, not a replacement for an accountable approval authority, the secure SDLC, SAST, SCA, or tests. AI adoption itself is not mandatory for every project.
- **Recommended Tools (2026 stable)**:

    | Tool | Strengths | Languages/Ecosystem |
    |---|---|---|
    | **CodeRabbit** | Comprehensive review, line-level comments, summarization, conversational | Polyglot |
    | **Greptile** | Whole-repo context understanding, impact analysis | Polyglot |
    | **Codium PR-Agent** | OSS, self-hostable, custom prompts | Polyglot |
    | **GitHub Copilot Code Review** | GitHub-native, IDE integration | Polyglot |
- **Mandatory Boundaries**:
    - Retain traceable evidence of model or service, target revision, execution time, policy, and result. Include confidential code, prompt injection, and data retention in the threat model.
    - **AI comments are suggestions, not decisions.** A risk-based human or explicitly approved governance authority retains final accountability. Define fail-open or fail-closed behavior so an unavailable AI result does not block human review indefinitely.
    - Prove review quality through the final revision, material risks, test evidence, and decisions on unresolved findings, not elapsed minutes or comment count.
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

### 9.2. Dependency Update Automation

- **Law**: Continuously detect support retirement, vulnerabilities, and version drift for every ecosystem, and generate or file an update change with an owner, deadline, and compatibility tests. Renovate, Dependabot, registry bots, platform services, and in-house automation are interchangeable implementations.
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
    - Do not infer risk only from semantic-version labels. Classify runtime, lockfile, build plugin, native binary, container base, transitive dependency, and maintainer or source changes
    - Limit auto-merge to low-risk updates with sufficient impact tests, provenance, license and reachability checks, rollback, and post-change monitoring
    - Triage actively exploited vulnerabilities immediately and choose mitigation, update, or rollback; green CI alone does not justify unconditional merge
- **Anti-Pattern Prohibitions**:
    - PR explosion → cap with `prConcurrentLimit`; adopt batched updates
    - All-auto-merge → major bumps will break; gate with review

### 9.3. Hooks Distribution & Framework Choice

- **Law**: When local hooks are adopted, provide version-controlled configuration and a reproducible installation path, and enforce the same checks in CI or a server-side gate. Do not use only personal `~/.gitconfig` as an organization control.
- **Selection Contract**: Choose lefthook, Husky, pre-commit, native `core.hooksPath`, or another mechanism by recording target languages, OS support, IDE and GUI-client behavior, partial staging, installation-failure behavior, measured latency, and maintenance ownership in the Blueprint. The Universal layer does not mandate one framework.
- **Reference Implementation**: The following lefthook configuration is one example, not a mandatory product, command set, or file layout.

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
    - Version the hook definition, its generator, or its installation recipe so that it is reproducible from the same revision.
    - Provide a consistent installation path after clone or workspace bootstrap that fits the adopted runtime and package manager.
    - Treat local hooks as fast feedback, not final merge or release evidence. Re-run material checks in CI or a server-side control.
    - When bypass is allowed, require a reason, compensating verification, and audit evidence proportionate to risk.
- **Migration Note**: Before changing hook frameworks, compare OS, IDE and GUI-client compatibility, installation failure, measured latency, partial staging, and existing development environments. Define the observation period and rollback criteria in the Blueprint.
- **Cross-References**: §2.5 lint-staged / §2.10 commitlint / §9.0 Multi-Layer Secret Scanning

### 9.4. Shallow Clone & Sparse Checkout for CI

> **Note**: This section governs **Git-side mechanisms**. End-to-end CI/CD pipeline optimization belongs to `engineering/000` and `operations/` domains.

- **Law**: In CI, declare the history, tags, submodules, LFS objects, and paths required for job correctness, then minimize transfer, storage, and I/O without breaking completeness.
- **Depth Contract**: Do not make one `fetch-depth` value a fixed standard. Derive it from the history actually consumed by merge-base calculation, change detection, versioning, changelog, provenance, bisect, and other job logic.
- **Shallow Clone (history shallowing)**:

    ```bash
    # Example for a job that is complete with the current revision only
    git clone --depth=1 <url>

    # Example for a history-dependent job, extended explicitly when needed
    git clone --depth=50 <url>
    git fetch --deepen=50
    ```
- **Sparse Checkout (partial file fetch — for monorepos)**:

    ```bash
    git clone --no-checkout --depth=1 <url> repo
    cd repo
    git sparse-checkout init --cone
    git sparse-checkout set apps/web packages/shared    # Only the target dirs
    git checkout <revision>
    ```
- **Verification**: Measure checkout time, transferred data, cache hits, and job results before and after optimization. Use fixtures or representative changes to verify that required artifacts, policies, and change detection remain complete.
- **Anti-Patterns**:
    - Applying either full history or minimum history to every job without evidence.
    - Using sparse checkout or path filters that omit dependencies, policy files, generated artifacts, or security checks.
    - Treating vendor defaults or unverified reduction percentages as Universal performance guarantees.
- **Cross-References**: §8.1 Git LFS (large-file transfer optimization) / §9.2 Renovate (batched dependency updates)

---

## Part 10: Anti-Pattern Catalog

> **Usage**: Reference this table during PR review / CI auto-checks / onboarding checklists.

### 10.0. Forbidden Practices Quick Reference

| Category | Anti-Pattern | Detection | Reference |
|---|---|---|---|
| **Branch** | Changing a protected reference directly by bypassing policy | Protected Reference Control | §6.0 |
| **Branch** | Keeping a branch active without an owner, status, or integration plan | inactivity and ownership check | §1.2 |
| **Branch** | Retaining merged branches or tracking metadata indefinitely | repository hygiene check | §3.0, §3.1 |
| **Commit** | Intent is not identifiable under the adopted message schema | schema validation + review | §2.0, §2.8, §2.10 |
| **Commit** | Combining logical changes that cannot be verified and reverted independently | review + change graph | §2.1 |
| **Commit** | Omitting AI-use, authorship, or sign-off data required by organization policy | policy validation | §2.8, §9.1 |
| **Change** | Exceeding the risk-based reviewability budget without a reason the change cannot be split | measured size and complexity signal | §2.3 |
| **Push** | Rewriting shared history without an approved recovery procedure, lease, and audit trail | client feedback + server policy | §2.7, §6.0 |
| **Push** | Bypassing a local control without compensating verification or rationale | CI evidence + audit log | §9.3 |
| **Release** | Replacing an existing release reference or published artifact without traceability | release integrity check | §7.0, §7.1 |
| **Merge** | Integrating conflict markers or unresolved generated differences | content scan + CI gate | — |
| **History** | Closing a secret incident by rewriting history without revocation or impact review | incident evidence + secret scan | §7.5, §9.0 |
| **History** | Rewriting shared history without backup, mapping, coordination, and verification | approved runbook | §7.5 |
| **Worktree** | Leaving prunable metadata, stale branch config, or tool incompatibility unresolved | `check-git-config-clean.sh` or equivalent | §4.0–§4.4 |
| **Repo** | Non-reproducible line endings, encoding, or binary classification across target platforms | cross-platform CI | §8.0 |
| **Repo** | Storing large artifacts as Git objects without rationale | repository size policy | §8.1 |
| **Repo** | Adopting submodules or other external references without ownership, update, trust, and recovery models | architecture review | §8.2 |
| **Review** | Approval lacks evidence of final-revision, material-risk, and unresolved-finding review | approval evidence | §6.2, §6.3 |
| **Review** | Author-only approval and integration when independent approval is required | ownership + approval policy | §6.0, §6.1 |
| **Tooling** | Depending on local checks without server-side or CI secret prevention | layered secret-control check | §9.0 |
| **Review** | Replacing approval with an AI result without rationale, false-positive disposition, or final-revision review | finding disposition + human approval evidence | §6.4 |
| **Tooling** | Hook definitions and installation paths exist only on personal machines | repository or bootstrap review | §9.3 |

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
| Reviewable Change Size / risk budget | §2.3 |
| Protected Reference Control / local pre-push feedback | §2.4 |
| Pre-Commit Auto-Formatting Hook (lint-staged, etc.) | §2.5 |
| Merged branch deletion | §3.0 |
| Stale remote tracking | §3.1 |
| Worktree state / `worktreeConfig` compatibility | §4.0 |
| Worktree cleanup commands | §4.1 |
| `check-git-config-clean.sh` | §4.2 |
| Parallel AI agent use | §4.3 |
| `.git/config` health | §5.0 |
| `.gitignore` AI artifacts | §5.1 |
| Merge Strategy Contract / history traceability | §2.6 |
| Force-Push / `--force-with-lease` | §2.7 |
| Commit Body / Trailers / `Co-Authored-By:` / Sign-off | §2.8 |
| fixup / autosquash / WIP cleanup | §2.9 |
| Protected Reference Control / Required Reviews / history policy | §6.0 |
| Ownership Resolution / CODEOWNERS and equivalents | §6.1 |
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
| AI-Assisted Review Governance / review assistants | §6.4 |
| Hook Distribution and Tool Choice / lefthook / Husky / pre-commit | §9.3 |
| `git maintenance` / auto GC / commit-graph / prefetch | §7.6 |
| `.git-blame-ignore-revs` / mass-format / git blame transparency | §8.3 |
| Shallow Clone / Sparse Checkout / CI optimization / fetch-depth | §9.4 |

---

## Primary Sources

- [Official git-worktree documentation](https://git-scm.com/docs/git-worktree.html) — worktree listing, removal, pruning, repair, and worktree-specific configuration
- [Official git-config documentation](https://git-scm.com/docs/git-config.html) — authoritative behavior of `--worktree` and `extensions.worktreeConfig`
- [SLSA Source Track requirements](https://slsa.dev/spec/v1.2/source-requirements) — review, change history, and protected controls for high-assurance source
- [GitHub Rulesets documentation](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets) — one implementation of protection rules for branches, tags, and pushes
- [GitLab Approval Rules documentation](https://docs.gitlab.com/user/project/merge_requests/approvals/rules/) — one implementation of approval rules by role, group, and target branch

---

**Last Updated**: 2026-07-23
**Authority**: Universal Constitution (axiarch core)
**Classification**: Engineering — Git Workflow & Repository Hygiene
