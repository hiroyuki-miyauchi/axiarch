# 62. License & Dependency Management

## 1. License Compliance
*   **Permissive Licenses**:
    *   **MIT, Apache 2.0, BSD**: These are suitable for commercial use and recommended.
    *   **Attribution**: Many licenses require copyright notice. Introduce a mechanism (e.g., `license-plist`, `oss-licenses-plugin`) to auto-generate and display the list of OSS licenses used in "Settings > Licenses".
*   **Prohibited Licenses**:
    *   **GPL, AGPL (Copyleft)**: These have "infectivity" and create an obligation to publish proprietary code linked to them, so use in proprietary commercial apps is **strictly prohibited**.

*   **License Classification**:

    **✅ Allowed (Safe)**:

    | License | Risk | Notes |
    |:--------|:-----|:------|
    | MIT | ✅ Safe | Most permissive. Commercial use allowed |
    | Apache-2.0 | ✅ Safe | Includes patent clause. Commercial use allowed |
    | BSD-2-Clause / BSD-3-Clause | ✅ Safe | Commercial use allowed |
    | ISC | ✅ Safe | Equivalent to MIT |
    | CC0-1.0 | ✅ Safe | Effectively public domain |
    | 0BSD | ✅ Safe | No attribution required |

    **⚠️ Caution (Legal review required)**:

    | License | Risk | Action |
    |:--------|:-----|:-------|
    | LGPL-2.1 / LGPL-3.0 | ⚠️ Conditional | Dynamic linking is OK. Allow as exception after legal review |
    | MPL-2.0 | ⚠️ Conditional | File-level Copyleft. Allow as exception after legal review |

    **🔴 Prohibited (Immediate block)**:

    | License | Risk | Action |
    |:--------|:-----|:-------|
    | GPL-2.0 / GPL-3.0 | 🔴 High | Obligation to publish entire project source |
    | AGPL-3.0 | 🔴 Critical | Source disclosure obligation even for SaaS usage |
    | SSPL | 🔴 Critical | Similar infectivity. Known as the MongoDB license |
*   **SBOM (Software Bill of Materials)**:
    *   **Mandate**: Automatically generate **SBOM** in SPDX or CycloneDX format for all build artifacts. This guarantees supply chain security and increases reliability for enterprise customers.
    *   **Retention**: Retain each release's SBOM for a minimum of **2 years** to immediately respond to audit requests.

## 2. Auto-Scan & Guardrails
*   **CI Pipeline**:
    *   **FOSSA / Snyk**: Integrate license scan tools into CI/CD pipeline.
    *   **Build Block**: Automatically fail build if prohibited licenses (GPL etc.) or Critical vulnerabilities are detected. Eliminate human oversight.
    *   **License Enforcement**: Integrate tools such as `license-checker` or `license-report` into CI to **automatically block** PRs containing prohibited licenses (GPL/AGPL/SSPL).
    *   **Vulnerability Gate**: Integrate `npm audit` or `Snyk` into CI/CD and **automatically block** PR merges when **Critical/High** vulnerabilities are detected.

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
    *   **Security Patches**: Security patches MUST be applied within **48 hours**. Prioritize Critical/High vulnerabilities above all else.
    *   **Weekly Review**: Review dependency update status **weekly** to monitor for neglected security updates.
    *   **Lockfile Diff Review**: To detect unintended changes in `package-lock.json`, **always review** the Lockfile diff during PR reviews.
