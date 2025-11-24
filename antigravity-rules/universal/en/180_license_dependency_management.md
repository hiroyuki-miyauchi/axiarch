# 180. License & Dependency Management

## 1. License Compliance
*   **Permissive Licenses**:
    *   **MIT, Apache 2.0, BSD**: These are suitable for commercial use and are recommended.
    *   **Attribution**: Many licenses require copyright notices. Implement a mechanism (e.g., `license-plist`, `oss-licenses-plugin`) to automatically generate and display a list of OSS licenses in the app's "Settings > Licenses" screen.
*   **Prohibited Licenses**:
    *   **GPL, AGPL (Copyleft)**: These have "viral" properties that require you to release your own linked code, so they are **strictly prohibited** in proprietary commercial apps. Exceptions may be allowed only if loosely coupled via API, subject to legal review.
    *   **CC-BY-NC (Non-Commercial)**: Do not use assets or libraries that are restricted to non-commercial use.
*   **Commercial Assets**:
    *   **Fonts, Images, Paid Plugins**: Strictly adhere to the scope of the purchased license (Web/App, PV limits, number of seats). Manage license certificates centrally.

## 2. Dependency Selection Criteria
*   **Health Metrics**:
    *   **Stars**: Does it have a decent rating on GitHub (e.g., > 1,000 stars)?
    *   **Maintenance**: Was the last commit within 6 months? Are issues and PRs being addressed?
    *   **Bus Factor**: Is it maintained by more than just one person? (Sustainability).
*   **Security**:
    *   **Vulnerability Checks**: Use `npm audit` or `dependabot` to check for known vulnerabilities. Libraries with Critical/High vulnerabilities are not allowed.
*   **Size Impact**:
    *   **Bundlephobia**: For web apps, check the impact on bundle size. Avoid libraries that are too large for their function (e.g., use date-fns or Day.js instead of Moment.js).

## 3. Version Management
*   **Semantic Versioning**:
    *   Understand the meaning of `Major.Minor.Patch` and use `package.json` specifiers (`^`, `~`, fixed) intentionally.
*   **Lock Files**:
    *   **Always Commit**: `package-lock.json`, `yarn.lock`, `Podfile.lock`, `pubspec.lock`, etc., must be committed to ensure that the entire team and CI environment install the exact same versions.
*   **Update Strategy**:
    *   **Regular Updates**: Set a "Dependency Day" (e.g., once a month) to update dependencies.
    *   **Major Updates**: For major version updates involving breaking changes, investigate the scope of impact and create a migration plan before execution.
