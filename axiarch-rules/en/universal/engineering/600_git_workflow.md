# 600. Git Workflow & Repository Hygiene

> **Supreme Directive**: "Git is history, and history is an asset. Daily operational hygiene neglect leads to asset degradation."
>
> **Priority Order**: Repository Integrity > Daily Workflow Velocity > Tool Compatibility > Convenience

This file consolidates **domain-agnostic Git operations that occur during daily development, regular work, and upload tasks** into a Universal Rule.
Domain-specific Git usage (security signing, GitOps, QA hooks, etc.) remains in respective domain files and is referenced from here.

---

## Table of Contents

| # | Part | Sections | Rule Count |
|---|---|---|---|
| 1 | Trunk-Based Development | §1.0 – §1.2 | 3 |
| 2 | Commit & PR Standards | §2.0 – §2.5 | 6 |
| 3 | Branch Hygiene Mandate | §3.0 – §3.1 | 2 |
| 4 | Worktree Hygiene Protocol | §4.0 – §4.4 | 5 |
| 5 | Repository Hygiene & Config Integrity | §5.0 – §5.1 | 2 |
| | | **Total** | **18** |

---

## Scope Manifesto

✅ **Inclusion Criteria**:

- Git operations occurring during daily development, regular work, and upload tasks
- Branch / commit / worktree / push-pull / PR workflows
- Domain-agnostic Git best practices

❌ **Exclusion Criteria (refer to respective domain files)**:

- Commit signing / GPG → `security/000_security_privacy.md`
- SLSA / Sigstore → `security/200_oss_compliance.md`
- Git history scrubbing for IP → `security/300_ip_due_diligence.md`
- GitOps deployment → `operations/400_site_reliability.md`
- Hot-fix branch protocol → `operations/500_incident_response.md`
- Pre-commit hooks for tests → `quality/000_qa_testing.md`
- DB Migration Immutability → `engineering/200_supabase_architecture.md` (currently temporarily in `engineering/000` §10.4)

---

## Part 1: Trunk-Based Development

### 1.0. Trunk-Based Development (Principle)

- **Principle**: Eliminate long-lived branches. Merge short-lived branches to `main` frequently (daily).
- **Stacked Diffs**: Avoid giant PRs by stacking small, dependent PRs.

### 1.1. Branch Naming Standard

- **Branch Naming**: Use `type/summary` format (e.g., `feat/user-profile`, `fix/login-bug`).
- **Types**: `feat`, `fix`, `refactor`, `chore`.

### 1.2. Short-Lived Branch Mandate

- **Law**: Branch lifetime should be **a few hours to maximum 2 days**.
- **Action**: When a giant merge-difficult branch threatens to form, hide it behind a Feature Flag in production and integrate to main early.

---

## Part 2: Commit & PR Standards

### 2.0. Conventional Commits

- **Format**: Strictly follow `type(scope): subject` format. Describe details in the project's native language.

### 2.1. Atomic Commits

- **Law**: Each commit contains only "one logical change."

### 2.2. Pull Request Template Protocol

- **Law**: Create `.github/pull_request_template.md` with mandatory "Type of change," "How to test," "Screenshots."

### 2.3. PR Size Mandate (100-Line Rule)

- **Law**: Keep PRs small. Aim for under 100 lines of changes. Direct push to `main` is prohibited; CI pass and review approval are mandatory.

### 2.4. Husky Pre-Push Guard

- **Law**: All projects must mandate a `pre-push` hook to block direct pushes to `main`.
- **Implementation**: husky's `pre-push` should check `git symbolic-ref HEAD` and reject pushes to protected branches like `refs/heads/main`.

### 2.5. Automated Git Hooks Protocol (Lint Staged)

- **Law**: Mandate `lint-staged` to automatically run `eslint --fix` and `prettier --write` on committed files.

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
| Husky / pre-push guard | §2.4 |
| lint-staged / git hooks | §2.5 |
| Merged branch deletion | §3.0 |
| Stale remote tracking | §3.1 |
| Worktree pollution / `worktreeConfig` | §4.0 |
| Worktree cleanup commands | §4.1 |
| `check-git-config-clean.sh` | §4.2 |
| Parallel AI agent use | §4.3 |
| `.git/config` health | §5.0 |
| `.gitignore` AI artifacts | §5.1 |

---

**Last Updated**: 2026-05-04 (v1.4.0)
**Authority**: Universal Constitution (axiarch core)
**Classification**: Engineering — Git Workflow & Repository Hygiene
