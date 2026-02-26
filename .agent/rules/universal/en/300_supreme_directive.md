# 30. Engineering Excellence (General)

### 1.0. The Supreme Directive
*   **The Consolidated Naming Convention**:
    *   **Files & Directories**: All file and directory names are unified as `kebab-case` (e.g., `user-profile-card.tsx`). PascalCase and snake_case cause Git compatibility issues (Case Sensitivity) across OSs and are strictly prohibited.
    *   **Components**: File names are `kebab-case`, but component names are `PascalCase` and function names are `camelCase`.
    *   **The Barrel File Ban**: Re-exports via `index.ts` (Barrel Files) are principally prohibited as they cause circular references and inhibit Tree Shaking.
- **UI/Logic Consistency**:
  - **Principle**: "Similar but different" shows a lack of professionalism and is a bug. UI and logic must be unified across all features (Delete, Edit, List).
  - **Tiered Security**: Security is tiered according to risk.
    - **Tier 1**: General single operations require "Confirmation only".
    - **Tier 2**: Bulk operations and **Critical Single Operations (e.g., User Deletion)** require "High-Assurance Verification (OTP, Passkey, 2FA, etc.)". Deviating from this based on personal judgment is not permitted.
*   **The Hierarchical Data Principle (1:N Core)**:
    *   **Law**: When designing complex domains (lifetime data, contracts, high-confidentiality records, etc.), always define a root parent table (e.g., `users`, `accounts`, `master_records`) and hang related data in a loosely-coupled parent-child $1:N$ hierarchy. Stuffing into a single giant table (God Table) is a defeat that breaks migration and RLS design.
*   **The Tiered Service Mandate (Subscription Gating)**:
    *   **Law**: Restrictions by service level (Free/Paid) such as registration counts, AI usage limits, etc. MUST be enforced **server-side (Server Guards)**. Relying only on frontend display control is prohibited as it allows API request bypass.
    *   **Upsell Trigger**: On limit exceeded, return a clear message with upgrade path, not just an "error".
*   **The Interoperable Ecosystem Mandate**:
    *   **Law**: Treat important domain data (achievements, qualifications, records, etc.) held in the app as "standardized assets" usable outside the system. Locking in proprietary specs is defeat that blocks future service integration and value delivery to users.
    *   **Portable Design**: Comply with industry-standard schemas, constants, and international standards as much as possible, designing data itself to have "portability" as a trustworthy certificate to other systems.
*   **Structure First Protocol**:
    *   **Law**: Important business data (qualifications, contracts, health status, assets, etc.) should be managed as master data (M:N) or tag format structured data, not as text (unstructured data).
    *   **Future-Proof Data Strategy (LTV & FinOps)**:
        *   **Context**: Certain data (e.g., medical expenses, failure rates, lifetime events) may become "golden data" for future insurance proposals, advanced personalization, or business model pivots even if currently unneeded.
        *   **Law**: When data modeling, design to retain metadata (cost, timestamps, types, events) that may contribute to future FinOps or LTV maximization in structured form. Minimize "add later" costs and ensure data continuity.
    *   **Autonomous Structure Strategy (Edge AI)**:
        *   **Law**: Avoid forcing users to type whenever possible. Non-structured physical assets (paper certificates, receipts, documents) should have standard implementation flows that use OCR/Vision AI to auto-convert to "high-precision structured data" instantly.
        *   **Standard**: "Just take a photo and all important items go into DB" UX is the supreme mandate for data quality maintenance and user retention improvement.
        *   **Human-in-the-Loop Mandate**: Data extraction/conversion results by AI (OCR/Vision, etc.) MUST always be treated as **"Draft"**, forcing a flow where **users visually verify and correct the results before pressing "Save"**. Direct DB writes by AI (Auto-Save) are prohibited due to the risk of erroneous data contamination.
        *   **PII Scrubbing**: When documents or images processed by AI contain personal information (names, addresses, phone numbers, etc.), do not store them as-is in OCR/AI results — automatically discard or mask them (replace with `***`, etc.). In particular, third-party personal information MUST NOT be retained as structured data without the individual's consent.
*   **Clean Code Standards**:
    *   **Self-Documenting**: Comments explain "Why", Code explains "What".
    *   **Function Size**: One function, one job. Ideally **under 20 lines**.
    *   **Naming**: Clear and descriptive names. No `data`, `temp` (e.g., `userData` -> `authenticatedUserProfile`).
*   **Blueprint Compliance**:
    *   **Entry Point**: All development work starts by checking the corresponding rule files.
    *   **Update First**: If design changes are needed during implementation, **update the Blueprint before (or while) coding**. Discrepancy between docs and code is the biggest technical debt.
    *   **Code as Documentation**: Blueprint files are part of the code. When implementation changes, always update corresponding rule files to prevent drift.
*   **Zero Warnings**:
    *   **Rule**: Warnings are Errors. CI fails on a single warning. Prevent "Broken Windows Theory".
    *   **Strict Error Handling**: No empty `catch` blocks. All errors must be logged and handled appropriately.
    *   **Zero Tolerance for Band-Aid Solutions**:
        *   **Prohibition**: `// @ts-ignore`, `any` casts, `legacy-peer-deps` are "thoughtless" and defeat as an engineer.
        *   **Mandate**: If temporary workaround is needed, MUST include `// TODO(#IssueID): reason` with ticket number. Silent `ignore` is immediate Reject target.
    *   **The Incident Response Protocol (SRE)**: 
        1. **Plan & Drill**: Define contact chain and initial response (service stop criteria, log preservation) for security incidents (data leaks, unauthorized access) and drill semi-annually.
        2. **Post-Mortem & Blueprint Sync**: After incident response, identify and verbalize root cause, then immediately reflect lessons in **Blueprint** as one indivisible process.
    *   **The Anti-Blindness Protocol (AI Hygiene)**:
        *   **Law**: Physically prohibit saving abbreviations like `// ...` or `// implementation details` in AI-generated code to files.
        *   **Action**: Always expand to **complete code**. Abbreviated code is not "bug" but "void" that crashes the system.
    *   **The System Transparency Protocol (Stack Card)**:
        *   **Law**: Maintain version information of tech stack (Framework, DB, UI Lib) in `PROMPT.md` or `tech_stack.md` in current state always.
        *   **Reason**: AI agents have no way to know the "current" environment. Accurate version information is the lifeline for accurate code generation.
*   **Refactoring (The Boy Scout Rule)**:
    *   **Mandate**: Leave the code cleaner than you found it. Always make small improvements (rename, extract function) when touching a file.
    *   **No "Later"**: "Refactor later" is a lie. Now or never.
    *   **Cyclomatic Complexity**: Keep nesting shallow. Use Early Returns.
*   **Cleanup**:
    *   **Dead Code**: Delete immediately. No commented out code, no unused imports, no console.logs.
    *   **The Dependency Governance Protocol**:
        *   **Dual Governance**: If environment diff errors occur in packages with native dependencies, force version unification using `overrides` field in `package.json`.
        *   **The License Quarantine (AGPL Block)**: Strictly prevent unrelated open source code contamination. Reference the 600-series (Security & Privacy) Rule 5 for **AGPL (Affero GPL)** prevention.
    *   **The Console Log Ban (Information Leakage)**:
        *   **Law**: Leaving `console.log` in production build is debugging info leakage and hotbed for sensitive info (token/PII) leak.
        *   **Action**: Physically block by setting `eslint-plugin-no-console` to `error` in CI. Send necessary logs to Sentry via `logger` library.
    *   **The Privacy Scrubbing Protocol (EXIF Wipe)**:
        *   **Context**: User Generated Content (UGC) images may contain personal info like GPS coordinates.
        *   **Law**: Mandate **physical deletion of EXIF data** in client-side image upload processing. Sanitize metadata on browser before reaching server.
    *   **The Backup File Ban (No .bak)**:
        *   **Law**: "Just in case" backup files (`.bak`, `.old`, `_copy`) are noise in Git, polluting search results and inviting confusion with latest code.
        *   **Action**: Backup is Git history. Immediately delete file system backup files. Only production files should exist when `ls` is run.
    *   **The Exhaustive Reference Scan (Grep First)**:
        *   **Law**: Deleting files based on "my memory" is "gambling" inviting undetected import errors and build breakage.
        *   **Action**: When deleting/renaming files, MUST perform **`grep` search** by filename across entire project to identify and eliminate all references.
    *   **The Ghost Feature Ban**: Features without user access paths (unreleased admin code etc.) are debt. Physically delete following YAGNI principle.
    *   **The Ghost Feature Revival (Full-Stack Coherence)**:
        *   **Law**: Features where admin settings change but nothing happens on frontend (Ghost Feature) are bugs destroying trust.
        *   **Action**: When adding admin settings, simultaneously implement frontend reflection logic (CSS var injection, API field display) and perform integration test. Half implementation is "incomplete".
    *   **TODO Management**: If leaving `// TODO:`, always include ticket number or deadline. Abandoned TODOs are technical debt.

### 1.1. Supreme Directive: Omnichannel & Headless First Protocol
*   **Web is just ONE Client**:
    *   **Definition**: When designing the entire system, the "Website (Next.js)" is just **one of many** clients.
    *   **Vision**: Assumes future native apps (iOS/Android), external media integrations, IoT delivery, AI agent interactions.
*   **API Mandate**:
    *   **Law**: **All features and data** must be provided through reusable APIs (Headless Architecture).
*   **Prohibition (The Web-Only Ban)**:
    *   **Felony**: Business logic encapsulation in React components or HTML structure-dependent data design (Web Only design) is **strictly prohibited as "violation of highest priority items"**. Immediate Reject target.

*   **The License Quarantine (AGPL Block)**: Strictly prevent unrelated open source code contamination. Reference `60_security_privacy.md` Rule 5 for **AGPL (Affero GPL)** prevention.

*   **The License Quarantine (AGPL Block)**: For license governance details, refer to `60_security_privacy.md` Rule 5 and thoroughly prevent **AGPL (Affero GPL)** usage.
