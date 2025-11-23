# 50. Git & Version Control Standards (Silicon Valley Style)

## 1. Branching Strategy (Trunk Based Development)
*   **Main Branch is Holy**: The `main` branch must always be in a Deployable state.
*   **Short-Lived Feature Branches**: Feature development is done in short-lived branches like `feat/user-login` and merged into `main` within a few days. Long-lived branches are the source of merge hell and are prohibited.

## 2. Commit Convention (Conventional Commits in Japanese)
Commit messages must be written in "Japanese" so the content is instantly understandable. Apply Silicon Valley standard "Conventional Commits" localized to Japanese.

*   **Format**: `type(scope): subject`
*   **Types**:
    *   `feat: ...`: New Feature
    *   `fix: ...`: Bug Fix
    *   `docs: ...`: Documentation only
    *   `style: ...`: Formatting, missing semi colons, etc; no code change
    *   `refactor: ...`: Refactoring production code
    *   `perf: ...`: Performance improvement
    *   `test: ...`: Adding tests, refactoring test; no production code change
    *   `chore: ...`: Updating build tasks, package manager configs, etc; no production code change

*   **Example**:
    *   ⭕️ `feat(auth): ログイン画面のUI実装` (Impl login UI)
    *   ⭕️ `fix(api): タイムアウト処理のバグを修正` (Fix timeout bug)
    *   ❌ `update code` (No specificity)
    *   ❌ `fix bug` (English prohibited in subject)

## 3. Pull Requests (PR) & Code Review
*   **The "100 Lines" Rule**: Keep PRs small. Fewer lines mean higher bug detection rates and faster reviews.
*   **Description is Mandatory**: Always describe "What," "Why," and "How" in Japanese in the PR description.
*   **Review Standard**:
    *   **Nitpicks are Welcome**: Minor points (variable names, readability) are welcome.
    *   **Blockers**: Firmly block merges (Request Changes) if there are critical bugs or security risks.

## 4. Production Exclusion (Deployment Safety)
*   **Internal Only**: Development rule files such as `rules/` folder and `ANTIGRAVITY_RULES.md` must **NEVER be deployed to the Production environment**.
*   **Configuration**:
    *   Docker: Add `rules/` to `.dockerignore`.
    *   Web/Mobile Build: Exclude markdown files in build settings.
    *   These are "Internal Documents for the Dev Team" and not for users or competitors.

## 5. Security & Risk Management (Silicon Valley Standard)
*   **Branch Protection Rules**:
    *   Direct Push to `main` branch is systematically prohibited.
    *   Merging requires "Approval from at least 1 person (Review)" and "Passing CI Checks (Test/Lint)".
*   **Secret Management (No Credential in Code)**:
    *   **NEVER** commit sensitive information like API keys, passwords, private keys to the Git repository.
    *   Use `.env` files and always add them to `.gitignore`.
    *   If committed by mistake, immediately Revoke the credential and reissue. Even if history is rewritten with `git filter-branch`, consider leaked info as "Already Leaked."
*   **Code Signing (Verified Commits)**:
    *   Use GPG signing whenever possible to guarantee commit authenticity (Verified badge). Prevent spoofing.
*   **Dependency Security**:
    *   Use `npm audit` or `Dependabot` to constantly monitor library vulnerabilities. Respond immediately to High or higher vulnerabilities.

## 6. AI-Managed Workflow (Owner Friendly)
*   **Zero-Touch for Owner**:
    *   The Owner (User) does not need to be aware of Git commands or branch strategies. The Dev Team (AI) strictly manages these in the background.
    *   Reports to the Owner are made in business language, e.g., "Feature A implementation is complete (Internally merged `feat/feature-a`)."
*   **Automatic Safety**:
    *   AI performs a self-review before every commit to ensure no sensitive info leakage and adherence to Japanese rules.
    *   If complex Git operations (rebase, cherry-pick, etc.) are needed, AI executes them safely and reports only the result to the Owner.

## 7. Critical Merge Protocol (User Confirmation)
*   **Mandatory Confirmation**:
    *   **Always obtain Owner (User) approval beforehand** when performing Breaking Changes, Database Schema Changes, or critical merges related to security. Execution without permission is strictly prohibited.
*   **Layman-Friendly Explanation**:
    *   When asking for approval, do not use technical terms like "Execute `DROP TABLE users`." Instead, explain in **simple Japanese that a layman can fully understand the risks and results**, such as "**We will completely delete and recreate the table managing user information. All existing data will be lost. Is this okay?**"
    *   There is an obligation to thoroughly explain "what will happen" before asking "Can I merge?".
