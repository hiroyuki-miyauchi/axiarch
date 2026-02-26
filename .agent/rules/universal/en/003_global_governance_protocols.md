# 00. Core Philosophy & Mindset
## 8. Global Governance Protocols

### 8.1. The Supreme Sovereignty Protocol (Deployment & Git Ban)
*   **Supreme Law**: **AI must NEVER execute Git commands (add, commit, push, stash, restore, etc.) without explicit instruction ("Commit", "Push", etc.) from the user.** This violation is considered the **highest severity constitutional violation**, deemed as "opportunistic" spirit that robs user confirmation opportunities and pollutes history.
*   **Action**:
    1.  **Wait**: After work, just save files and show `git status`.
    2.  **Ask**: Ask "May I commit and push?" and execute only after explicit approval.
    3.  **STRICT BRANCH CHECK**:
        *   **Before Code**: Execute `git branch --show-current` BEFORE starting work (before writing the first line of code).
        *   **Before Commit**: Reconfirm just before commit and physically verify the current location is NOT `main` (or `master`). If output is `main`, STOP immediately regardless of reason.
    4.  **No Exceptions**: "Lint fix", "chore", "typo fix"—direct commits to `main` are strictly prohibited.
    5.  **No Assumption**: "SafeToAutoRun" flag does NOT mean "chores can bypass workflow." AI autonomous judgment is never allowed for Git operations.

### 8.2. The Main Branch Sanctuary (Strict Enforcement)
*   **Law 1**: Direct commits and work on `main` (or `master`) branch are **physically prohibited**. Even "Lint fix", "chore", "typo fix"—NO exceptions.
*   **Law 2 (Husky Guard)**: All projects MUST implement **Husky** and `pre-push` hook to physically block direct pushes to `main` as a **Universal Mandate**. "Being careful" as an operational rule is meaningless; only code-enforced physical defense lines are trusted.
    *   **Implementation**: For specific setup procedures and technical details, refer to the 300-series (Engineering).
*   **Action**:
    *   **Stop**: If `git branch` shows `main`, immediately stop ALL code editing.
    *   **Create**: Always create an appropriately named branch (`feature/xxx`, `fix/xxx`) and switch to it before starting.

### 8.3. The Migration Immutability Protocol
*   **Law**: Renaming, modifying, or deleting applied migration files is **absolutely forbidden**.
*   **Action**:
    *   **No Renaming**: Altering history is the root of integrity errors.
    *   **Forward Only**: Fixes must be done by "Adding a new migration file". Never rewrite the past.
    *   **Timestamp Singularity**: Migration IDs (timestamps) must be unique. Deployment with inconsistency between remote (e.g., due to renaming) is prohibited.

### 8.4. The Dead Code Elimination Protocol (Debt Bankruptcy)
*   **Law**: Commented-out or unused code kept "just in case" is not debt, it is "Garbage".
*   **Action**:
    *   **No Mercy**: Delete unused code immediately. It can be restored from Git history. Do not leave tombstones in the code.
    *   **The Ghost Feature Ban**: Features with no user navigation (unpublished admin screen code, etc.) are debt. Physically delete per YAGNI principle.
    *   **No Backup Files**: Prohibit `.bak`, `.old`, `_copy` backup files in Git. Backup IS Git history. `ls` should show only production files.
    *   **The Anti-Overwrite Protocol**:
        *   **Supreme Law (Rule 0.-1)**: "Full Overwrite" of existing files is **destructive behavior** and prohibited.
        *   **Law 2 (Surgical Precision)**: Modifications are "surgical"—change only the problem areas. Always show diffs so user can 100% understand changes.
        *   **Law 3 (Anti-Blindness Protocol)**: When outputting source code, do NOT mix abbreviations like `// ... (imports remain)`. This displays "unintended strings" on user screens—the "Greatest Shame" that loses user trust. Output full content or use exact replacement tools.

### 8.5. The Regression Ban Protocol (Rule 100.0)
*   **Law**: Recurrence of once-fixed bugs (Regression) is the "Greatest Failure" in engineering.
*   **Action**:
    1.  **Recurrence Punitive Measure**: When fixing bugs, verbalize not only "Why it happened (Root Cause)" but "How to systematically prevent it (Prevention Loop)."
    2.  **Visibility**: After UI/UX fixes, ALWAYS confirm and record with real device screenshots or videos (Screen Recording). "I think I saw it" completion reports are false reports.
    3.  **Zero Recurrence**: If similar bugs recur, treat it not as "personal mistake" but "system deficiency (Constitutional Violation)" and immediately harden project-wide guardrails (Linter, Test, CI).

### 8.6. The Branch Hygiene Protocol (Clean Up After Yourself - Rule 99.2)
*   **Law**: Leaving work branches is an accident waiting to happen due to environment differences. "Delete when merged" is an engineer's breath.
*   **Action**:
    *   **Before Final Notify**: Just before task completion report (Final Notify), check `git branch --merged` and automatically delete merged work branches.
    *   **Clean**: Remote branches auto-delete on GitHub side, but don't leave corpses locally. "Create and forget" is shameful for an engineer.

*   **Implementation**: For specific setup procedures and technical details, refer to `30_engineering_general.md`.
