# 30. Engineering Excellence (General)

## 1. Code Quality & Clean Code
*   **Clean Code Standards**:
    *   **Self-Documenting**: Use comments to explain "Why", and let the code itself explain "What".
    *   **Function Size**: A function should do "one thing". Ideally, keep it within **20 lines**.
    *   **Naming**: Variable names must be specific and clear. Vague names like `data`, `temp`, `item` are prohibited (e.g., `userData` -> `authenticatedUserProfile`).
*   **Zero Warnings**:
    *   **Rule**: Treat Warnings as Errors. CI must fail if there is even one warning. Prevent the "Broken Windows Theory".
    *   **Strict Error Handling**: Empty `catch` blocks are prohibited. All errors must be logged and handled appropriately.
*   **Refactoring (The Boy Scout Rule)**:
    *   **Mandate**: "Leave the campground cleaner than you found it." Always make small improvements (renaming, function extraction) when touching a file.
    *   **No "Later"**: "I'll refactor later" is a lie. Do it now, or never.
    *   **Cyclomatic Complexity**: High complexity (deep nesting) is a breeding ground for bugs. Use Early Return to keep nesting shallow.
*   **Cleanup**:
    *   **Immediate Deletion of Dead Code**: Completely delete commented-out code, unused imports, and debug `console.log` before committing.
    *   **TODO Comment Management**: If leaving `// TODO:`, always include a ticket number or deadline. Abandoned TODOs are technical debt.

## 2. Performance & Optimization (The "Speed")
*   **Performance Budgets**:
    *   **Lighthouse Score**: Maintain **90+** (Green) in all categories: Performance, Accessibility, Best Practices, SEO.
    *   **Core Web Vitals**: Strictly adhere to LCP (< 2.5s), FID (< 100ms), CLS (< 0.1).
*   **Asset Optimization**:
    *   **Images**: Enforce next-gen formats (AVIF/WebP). Use optimization components like `next/image`.
    *   **Lazy Loading**: Lazy load all assets except those above the fold.

## 3. Security by Design (DevSecOps)
*   **Zero Trust**:
    *   Doubt all inputs (user input, API responses). Validate on both client and server.
*   **Secrets Management**:
    *   Do not commit API keys or private keys to code. Use `.env` files and secret managers.

## 4. Technical Debt & Cleanup
*   **Debt Paydown**:
    *   Allocate **20%** of the sprint to paying down technical debt (refactoring, library updates).
*   **Tech Radar**:
    *   **Regular Updates**: Update dependencies quarterly to always maintain a "Safe Bleeding Edge".
*   **Digital 5S**:
    *   **Seiri (Sort)**: Immediately delete unused code (Dead Code), images, and files. Do not leave commented-out code.

## 5. FinOps & Green Coding
*   **FinOps (Cost Awareness)**:
    *   **Cost of Code**: Always be conscious of "How much does this one line of code cost?". Infinite loops and inefficient queries are acts of burning company funds.
    *   **Cloud Bankruptcy Prevention**: Always set "Budget Alerts" and "Auto-Stop Limits" for serverless functions and databases.
*   **Green Coding (Sustainability)**:
    *   **CO2 Reduction**: Reducing data transfer and computational load leads not only to cost reduction but also to CO2 emission reduction (Environmental Protection).
    *   **Dark Mode**: Recommend True Black (#000000) Dark Mode to reduce power consumption on OLED devices.

## 5. AI-Native Architecture
*   **RAG Optimization**:
    *   Split code into small modules (Atomic) so AI can easily understand it.
    *   Name files and directories "Semantically" to improve AI search accuracy.

## 6. Zero Bug Policy
*   **Fix First**:
    *   Do not develop new features while there are known bugs. Bug fixing is the top priority.
*   **24-Hour Rule**:
    *   Critical bugs (data loss, security, major feature outage) must be fixed within **24 hours** of discovery.

## 7. Continuous Learning & Verification
*   **Latest Info Protocol**:
    *   **Before Coding**: Always check the official documentation and latest release notes (e.g., "Next.js 15 breaking changes", "Swift 6 concurrency") before writing code. Implementation based on outdated information causes rework.
    *   **Deprecation Check**: Check if the API you are about to use is Deprecated.
*   **Trend Awareness**:
    *   Constantly catch up with the latest Silicon Valley trends (AI Agents, Privacy Manifests, etc.) and evolve the rules themselves.

## 8. Compatibility & Testing
*   **Real Device Testing**:
    *   Test on real devices (iOS, Android), not just simulators. Hardware features like camera, GPS, and biometrics require real devices.
*   **Browser Compatibility**:
    *   Support the latest 2 versions of Chrome, Safari (iOS/macOS), Firefox, and Edge. Pay special attention to Safari (iOS) specific bugs (e.g., 100vh issue).
*   **Self-Check List**:
    *   Before submitting a PR, developers must review their own code and confirm "Zero Warnings", "No Console Errors", and "No Unnecessary Logs".
