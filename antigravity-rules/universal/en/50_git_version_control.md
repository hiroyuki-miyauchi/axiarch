# 50. Git & Version Control

## 1. Commit Message Convention
*   **Conventional Commits**:
    *   **Format**: Strictly adhere to `type(scope): subject` (e.g., `feat(auth): add google login`).
    *   **Types**:
        *   `feat`: New feature
        *   `fix`: Bug fix
        *   `docs`: Documentation only changes
        *   `style`: Changes that do not affect the meaning of the code (white-space, formatting)
        *   `refactor`: A code change that neither fixes a bug nor adds a feature
        *   `perf`: A code change that improves performance
        *   `test`: Adding missing tests or correcting existing tests
        *   `chore`: Changes to the build process or auxiliary tools
*   **Japanese Description**:
    *   The Subject can be in English, but the Body must be in Japanese describing "What was done" and "Why it was done".

## 2. Branching Strategy
*   **GitHub Flow**:
    *   Prioritize simplicity. Use only `main` branch and feature branches (`feat/xxx`, `fix/xxx`). Do not use `develop` or `release` branches in principle (cover with CI/CD automation).
*   **Branch Protection**:
    *   Direct Push to `main` branch is systemically prohibited.
    *   Merging requires "Approval from at least 1 person" and "Passing CI checks (Test/Lint)".

## 3. Pull Requests
*   **100-Line Rule**:
    *   Keep PRs small. The fewer lines changed, the higher the bug discovery rate and the faster the review speed.
*   **Accountability**:
    *   In the PR description, always describe "What", "Why", and "How". Attach screenshots or videos if available.

## 4. Security & Secrets
*   **Credential Leak Prevention**:
    *   **Absolutely NEVER** commit confidential information such as API keys, passwords, or private keys to the Git repository. Use `.env` files and always add them to `.gitignore`.
*   **Verified Commits**:
    *   Use GPG signing whenever possible to guarantee the authenticity of commits (Verified badge). Prevent spoofing.
