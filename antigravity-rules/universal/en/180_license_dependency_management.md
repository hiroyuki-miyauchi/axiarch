# 180. License & Dependency Management

## 1. License Compliance
*   **Permissive Licenses**:
    *   **MIT, Apache 2.0, BSD**: These are suitable for commercial use and are recommended.
    *   **Attribution**: Many licenses require copyright notices. Introduce a mechanism (e.g., `license-plist`, `oss-licenses-plugin`) to automatically generate and display a list of OSS licenses used in the app's "Settings > Licenses" screen.
*   **Prohibited Licenses**:
    *   **GPL, AGPL (Copyleft)**: These have "infectivity" and create an obligation to publish your own linked code, so their use in proprietary commercial apps is **strictly prohibited**. Exceptionally, loose coupling via API may be permitted, but legal confirmation is mandatory.
    *   **CC-BY-NC (Non-Commercial)**: Do not use materials or libraries that prohibit commercial use.
*   **Commercial Assets**:
    *   **Fonts, Images, Paid Plugins**: Strictly adhere to the scope of the purchased license (Web/App, PV limits, seat counts). Centralize management of license certificates.

## 2. Dependency Selection Criteria
*   **Health Metrics**:
    *   **Stars**: Does it have a certain evaluation on GitHub (e.g., over 1,000 stars)?
    *   **Maintenance**: Is the last commit within 6 months? Are Issues and PRs left unattended?
    *   **Bus Factor**: Is the maintainer not just one person? (Sustainability of the project).
*   **Security**:
    *   **Vulnerability Check**: Check for known vulnerabilities with `npm audit` or `dependabot`. Libraries with Critical/High vulnerabilities cannot be introduced.
*   **Size Impact**:
    *   **Bundlephobia**: For Web apps, check the impact on bundle size. Avoid libraries that are too large for their function (e.g., use date-fns or Day.js instead of Moment.js for date manipulation).

## 3. Version Management
*   **Semantic Versioning**:
    *   Understand the meaning of `Major.Minor.Patch` and specify versions in `package.json` etc. (`^`, `~`, fixed) with intention.
*   **Lock Files**:
    *   **Always Commit**: Always commit `package-lock.json`, `yarn.lock`, `Podfile.lock`, `pubspec.lock`, etc., to guarantee that the same versions are installed for all team members and in the CI environment.
*   **Update Strategy**:
    *   **Regular Updates**: Set a "Dependency Day" periodically, such as once a month, to update dependencies.
    *   **Major Updates**: For major version updates involving breaking changes, investigate the scope of impact and plan the migration before implementation.
