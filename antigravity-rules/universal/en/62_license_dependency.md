# 62. License & Dependency Management

## 1. License Compliance
*   **Permissive Licenses**:
    *   **MIT, Apache 2.0, BSD**: These are suitable for commercial use and recommended.
    *   **Attribution**: Many licenses require copyright notice. Introduce a mechanism (e.g., `license-plist`, `oss-licenses-plugin`) to auto-generate and display the list of OSS licenses used in "Settings > Licenses".
*   **Prohibited Licenses**:
    *   **GPL, AGPL (Copyleft)**: These have "infectivity" and create an obligation to publish proprietary code linked to them, so use in proprietary commercial apps is **strictly prohibited**.
*   **SBOM (Software Bill of Materials)**:
    *   **Mandate**: Automatically generate **SBOM** in SPDX or CycloneDX format for all build artifacts. This guarantees supply chain security and increases reliability for enterprise customers.

## 2. Auto-Scan & Guardrails
*   **CI Pipeline**:
    *   **FOSSA / Snyk**: Integrate license scan tools into CI/CD pipeline.
    *   **Build Block**: Automatically fail build if prohibited licenses (GPL etc.) or Critical vulnerabilities are detected. Eliminate human oversight.

## 3. Dependency Selection Criteria
*   **Health Metrics**:
    *   **Stars**: Does it have a certain evaluation on GitHub (e.g., 1,000+ stars)?
    *   **Maintenance**: Is the last commit within 6 months? Are Issues/PRs abandoned?
    *   **Bus Factor**: Is the maintainer not just one person? (Project sustainability).
*   **Size Impact**:
    *   **Bundlephobia**: For Web apps, check impact on bundle size. Avoid libraries too large for the feature (e.g., use date-fns or Day.js instead of Moment.js).

## 4. Version Management
*   **Lock Files**:
    *   **The CI Lockfile Protocol**:
        *   **Law**: Management standards for `package-lock.json` comply with SRE Constitution (`52`) "Lockfile Integrity Protocol". In CI environments, MUST use `npm ci` to eliminate ambiguity.
    *   **Always Commit** `package-lock.json`, `yarn.lock`, `Podfile.lock`, `pubspec.lock` to guarantee the same version is installed for all team members and CI environment.
*   **Update Strategy**:
    *   **Regular Updates**: Set a "Dependency Day" (e.g., once a month) to regularly update dependencies.
