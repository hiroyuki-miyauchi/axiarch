# 30. Engineering Excellence - General

## 1. Code Quality & Clean Code
*   **Clean Code Standards**:
    *   **Self-Documenting**: Use comments to explain "Why", let the code explain "What".
    *   **Function Size**: Functions do "one thing". Ideally keep within **20 lines**.
    *   **Naming**: Variable names must be specific and clear. Vague names like `data`, `temp`, `item` are prohibited (e.g., `userData` -> `authenticatedUserProfile`).
*   **Zero Warnings**:
    *   **Rule**: Treat Warnings as Errors. CI fails if there is even one warning. Prevent "Broken Windows Theory".
    *   **Strict Error Handling**: Empty `catch` blocks are prohibited. All errors must be logged and handled appropriately.
*   **Refactoring (The Boy Scout Rule)**:
    *   **Mandate**: "Leave the campground cleaner than you found it." Always make small improvements (renaming, function extraction) when touching a file.
    *   **No "Later"**: "I'll refactor later" is a lie. Do it now, or never.
    *   **Cyclomatic Complexity**: Code with high complexity (deep nesting) is a breeding ground for bugs. Use Early Return to keep nesting shallow.
*   **Cleanup**:
    *   **Immediate Dead Code Deletion**: Commented-out code, unused imports, and debug `console.log` must be completely deleted before commit.
    *   **TODO Management**: If leaving `// TODO:`, always include a ticket number or deadline. Abandoned TODOs are technical debt.

## 2. Performance & Optimization - The "Speed"
*   **Performance Budgets**:
    *   **Lighthouse Score**: Maintain **90+** in all categories: Performance, Accessibility, Best Practices, SEO (Green).
    *   **Core Web Vitals**: Strictly adhere to LCP (<2.5s), FID (<100ms), CLS (<0.1).
*   **Asset Optimization**:
    *   **Images**: Enforce next-gen formats (AVIF/WebP). Use optimization components like `next/image`.
    *   **Lazy Loading**: Lazy load all assets except those in the First View (Above the fold).

## 3. Security by Design - DevSecOps
*   **Zero Trust**:
    *   Suspect all inputs (user input, API responses). Validation is performed on both client and server.
*   **Secrets Management**:
    *   Do not commit API keys or secret keys to code. Use `.env` files and Secret Managers.

## 4. Technical Debt & Cleanup
*   **Debt Paydown**:
    *   **20%** of the sprint is dedicated to paying down technical debt (refactoring, library updates).
*   **Tech Radar**:
    *   **Regular Updates**: Update dependencies quarterly and always maintain "Safe Bleeding Edge".
*   **Digital 5S**:
    *   **Seiri (Sort)**: Immediately delete unused code (Dead Code), images, and files. Do not leave commented-out code.

## 5. AI-First Engineering
*   **Prompt Driven Development (PDD)**:
    *   **Principle**: Code is not written by humans, but by AI. The "Prompt" is the true source code.
    *   **AI Friendly**: Variable and function names should be extremely Descriptive so AI can easily understand the context (e.g., `daysSinceLastLogin` instead of `x`).
*   **RAG Optimization**:
    *   **Modularization**: Keep file sizes small (Atomic) to avoid overwhelming the AI's context window.
    *   **Semantic Structure**: Organize directory structure by Feature to make it easier for AI to find related files.

## 6. Green Coding & Sustainability
*   **Energy Efficiency**:
    *   **Algorithms**: Be conscious of computational complexity (Big O) and write code that does not waste CPU cycles. This protects both battery life and the global environment.
    *   **Dark Mode**: Recommend True Black (#000000) Dark Mode to reduce power consumption on OLED devices.
*   **Data Transfer**:
    *   **Compression**: Always optimize images and videos (AVIF/H.265) to prevent waste of network bandwidth.

## 7. The "Zero Bug Policy"
*   **Fix First**:
    *   Do not develop new features while known bugs exist. Bug fixing is the top priority.
*   **24-Hour Rule**:
    *   Critical bugs (data loss, security, major feature outage) must be fixed within **24 hours** of discovery.

## 7. Continuous Learning & Verification
*   **Latest Info Protocol**:
    *   **Before Dev**: Before writing code, always check the official documentation and latest release notes of the target technology (e.g., "Next.js 15 breaking changes", "Swift 6 concurrency"). Implementation based on old information is a source of rework.
    *   **Deprecation Check**: Check if the API you are about to use is Deprecated.
*   **Trend Awareness**:
    *   Constantly catch up with the latest Silicon Valley trends (AI Agents, Privacy Manifests, etc.) and keep evolving the rules themselves.

## 8. Compatibility & Testing
*   **Real Device Testing**:
    *   Test not only on simulators but always on real devices (iOS, Android). Hardware features like Camera, GPS, Biometrics require real devices.
*   **Browser Compatibility**:
    *   Support the latest 2 versions of Chrome, Safari (iOS/macOS), Firefox, Edge. Pay special attention to Safari (iOS) specific bugs (100vh issue, etc.).
*   **Self-Check List**:
    *   Before submitting a PR, developers review their own code and confirm "Zero Warnings", "No Console Errors", "No Unnecessary Logs".

## 9. Git & Version Control
*   **Trunk Based Development**:
    *   **Principle**: Abolish long-lived branches and merge short-lived branches into `main` frequently (daily).
    *   **Stacked Diffs**: Recommend stacking small dependent PRs instead of giant PRs.
*   **Commit Messages (Conventional Commits)**:
    *   Strictly adhere to `type(scope): subject` format (e.g., `feat(auth): add google login`). Describe details in Japanese in the body.
*   **Pull Requests**:
    *   **100 Lines Rule**: Keep PRs small.
    *   **Protection**: Direct push to `main` is prohibited; CI pass and review approval are mandatory.
*   **Security**:
    *   Never commit secrets like API keys; use `.env`. Mandate secret scanning (TruffleHog) in CI.

## 10. Documentation Ops
*   **Living Documentation**:
    *   **Mermaid.js**: Manage architecture diagrams with code (Mermaid) instead of images to prevent obsolescence.
    *   **ADR**: Record technical decisions in Markdown in `docs/adr`.
*   **Docs as Code**:
    *   Documentation is equivalent to code; manage it in Git and subject it to PR review. Code changes without doc updates are forbidden from merging.
*   **Freshness**:
    *   Automate broken link checks and review major rules quarterly.
