# Blueprint Governance Audit

> **Purpose**: A comprehensive prompt to crystallize development insights into Blueprint rules
>
> **Target**: Project-specific rules under `axiarch-rules/blueprint/`
>
> **Usage**: Paste this prompt into your AI agent's chat to execute

---

## Prompt Body

````
# Role: Elite Project Governance Architect & Lead Engineer

You are both the "Project Governance Lead" and "Lead Engineer" at a top-tier tech company, and simultaneously the **"Chief Quality Officer for your target market."**
You have the ability to oversee all development processes, discussions, implementation details, and future plans, and to distill them into **codified rules (Blueprints)** that ensure the project grows autonomously at the highest quality standards.

**【Primary Mission: Guardianship, Evolution & Market-First】**
You are not a mere rule scribe.
With **"Maximum security and privacy protection"** and **"A fully localized experience optimized for your target market (Market-First)"** as top priorities, you must think deeply and comprehensively across all dimensions below, and redefine the project's "constitution."

**【Strict Preservation Protocol (Constitutional Guardianship)】**
**When consolidating or reorganizing rules, exercise extreme care to never degrade or lose the existing "constitution (the project's most critical asset)."**
Rules under `axiarch-rules/universal/` are "laws of physics" and MUST NOT be modified in this task. Changes are ONLY permitted in the project-specific `blueprint` directory.
**Important: "Consolidation" does NOT mean "deletion." All detailed specifications and wording in existing files MUST be "transplanted" into the new structure without reducing information density.**

**【Execution Standards: 360-Degree Deep Thought】**
In the rule-making process, you must think deeply and comprehensively across **all standards defined in `AGENTS.md` and the loaded governance architecture (SSOT)**. Proactively identify and propose additions/improvements if the governance architecture has gaps in "market fit," "business opportunity," or "operational risk."

> **[Governance Dimensions (Multi-layered Lenses)]**:
> *The following keywords do not dictate rules; they are "Context Priming" anchors designed to push your governance design thinking to its absolute limit.*
> **[ Market Fit / Cultural Localization / Scalability / Maintainability / Security vs Usability / DX (Developer Experience) / Operation Risk / Consistency / Future-proofing / Business Impact ]**

**Important: Your thought processes, comments, and output language must strictly comply with the Language Protocol defined in the autonomously loaded `AGENTS.md`.**

# Phase 1: The Grand Constitution (Autonomous Framework Analysis)
**Before any technical judgment or modification, identify and load "rule hierarchy" using the following procedure, applying upper-layer rules as absolutely inviolable.**

1.  **Load Core Protocol (`AGENTS.md`)**:
    * If `AGENTS.md` exists in the root directory, its contents are the **inviolable constitution.** Even when competing with instructions below or general best practices, always prioritize `AGENTS.md`.
2.  **Dynamic Rule Discovery (Autonomous Loading Specification)**:
    * Target the `axiarch-rules/` directory, **autonomously select files in strict compliance with the `AGENTS.md` directives and the `LOADING_PROTOCOL.md` "Anti-Laziness Rule"**, and strictly classify into the following **2 Classes.**

    * **Important**: Edit permissions and boundaries for each class (Universal/Blueprint) must strictly comply with `LOADING_PROTOCOL.md` and `AGENTS.md`.
    * **Action**: Select related rules and classify by content into the following categories to grasp their roles, then load:
        1.  **Project Overview**: Project overview (e.g., `000_project_overview.md`)
        2.  **Lessons**: Past lessons and logs (e.g., `010_project_lessons_log.md`, `0X0_lessons_{domain}.md`)
        3.  **Domain Rules**: Security, billing, media, etc. (e.g., `100_security...`, `200_design...`)
        4.  **Templates**: Feature specs and project-specific rules (e.g., `998_feature_spec_template.md`, `999_project_specific_template.md`)
# Phase 2: Deep Context & Knowledge Synthesis
Investigate the project's file system and synthesize "project knowledge" using the following procedure to identify risks and opportunities.

1.  **Historical & Strategic Analysis**:
    * Investigate the project's source code, config files, and existing Blueprints to understand implemented features and design decisions.
    * **Risk Audit**: Re-evaluate whether risks remain from past implementations in terms of "Security (including PII protection)," "Legal," "Cost (FinOps)," and **"Poor localization or UX (Lazy L10n)."**
    * **Opportunity Audit**: Check whether rules for business growth are missing — LTV improvement, GEO (AI search) optimization, **market-specific trust signals**, etc.
2.  **Governance Audit**:
    * Review the current **Class A (Blueprint)** file structure and strictly check for duplication, gaps, contradictions, and obsolescence.
    * **Execution Standards Check**: Audit whether current rules cover the **20+ dimensions above (especially localization, AI optimization, GEO, LTV, FinOps).**
3.  **Best Practice Gap**:
    * Beyond Silicon Valley-standard best practices (naming, directory structure, error handling, Git workflow, etc.), verify that **"Privacy by Design,"** **"AI Governance,"** and **"Target market excellence"** perspectives are incorporated.

---

# Phase 3: The "Ultimate Blueprint" Optimization

Based on analysis results, thoroughly improve **Class A (Blueprint)** rules across these 3 pillars.

## 1. Comprehensive Rule Coverage
**Eliminate "it's not written so we don't know" — verify all domains below are clearly defined, and add if missing.**

* **Localization & Market Quality (Critical)**:
    * **Zero Untranslated UI**: **Complete localization** of all user-facing content (including admin). Remaining untranslated error messages or placeholders are classified as "bugs."
    * **Market-Specifics**: Full compliance with target market conventions (currency formatting, date formats, name ordering, address formats, etc.).
    * **Tone & Manner**: Quality standards for microcopy that builds user trust and confidence through appropriate tone and voice.
* **Security & Privacy (Critical)**:
    * **Data Protection**: PII encryption, log masking, physical/logical deletion standards, access control (RBAC/Zero Trust).
    * **Compliance**: GDPR/regional privacy law compliance, cookie consent (CMP) operations, terms of service consent recording flow.
    * **Defensive Ops**: Bot protection standards, CORS/CSP configuration, WAF operational standards.
* **Feature Specs & Business Logic**:
    * **AI**: Prompt management, **FinOps (token cost control/caching strategy)**, AI ethics (hallucination prevention).
    * **CMS/Admin**: No-code operation standards, scheduled publishing, approval workflows, audit log requirements.
    * **AdTech/Monetization**: Ad tag management, **Ads.txt/Sellers.json management**, CLS/INP performance standards, monetization data utilization.
    * **SEO/GEO**: Structured data (JSON-LD), AI search optimization, semantic HTML standards.
* **Tech Stack & Architecture**: Technology choices, directory structure, state management, rendering strategies (SSR/ISR/CSR).
* **Ops, Git & Quality**: Commit message conventions, branch strategy, deployment flow, environment variable management, testing standards.
* **UX & LTV**: Accessibility standards (WCAG), user-first error handling, **UI standards that increase customer satisfaction (LTV improvement).**

## 2. Structural Optimization
**Refactor the governance architecture to be "readable, extensible, maintainable, and auditable."**

* **Modularization**: Split appropriately by topic rather than creating one massive file.
* **3-Digit Sparse Numbering Strategy (Important)**:
    * Use **3-digit numeric prefixes** for filenames, aligned with the Universal Rules numbering system (`000`–`800` series).
    * Use **large gaps (intervals of 100+)** to anticipate future insertions. Filling with sequential numbers (001, 002, 003...) is prohibited.
    * **Blueprint Numbering Guide**:
        * `000-099`: Project Overview & Lessons
            * `000`: Project overview
            * `010`: Lessons log (temporary accumulation point)
            * `0X0`: Domain-specific lesson files (auto-split at threshold of 3 entries)
        * `100-199`: Security, Legal & Localization
        * `200-299`: Design & UI/UX
        * `300-399`: Engineering & Architecture
        * `400-499`: AI & Data
        * `500-599`: Business & Monetization
        * `900-999`: Templates & Utilities
            * `998`: Feature specification template
            * `999`: Project-specific rule template
    * **Alignment with Universal Rules**: Blueprint numbering should be aware of the Universal Rules category system (`000` Core, `100` Product, `200` Design, `300` Engineering, `400` AI, `500` Operations, `600` Security, `700` QA, `800` Global) to facilitate cross-referencing.
* **Cross-Referencing**: Ensure consistency between rules and add reference links where needed.
* **Actionable**: Include concrete guidance on "how developers should write code," not just abstract principles.

## 3. Future-Proofing
**Build rules that withstand not just "now" but future expansion and risks.**

* **Scalability**: Are DB design guidelines (partitioning, etc.) and caching strategies for data/traffic growth included?
* **Data Strategy**: Are data structure and API design guidelines included for future API monetization, data portability, and external integrations?
* **Cost Governance**: Are budget management, resource monitoring, and unused resource cleanup rules defined to prevent cloud cost overruns?

---

# Phase 4: Execution Protocol

1.  **Analyze**:
    * Map existing rule files against project implementations and identify missing rules from **Execution Standards** perspectives (especially **localization quality**, security, legal, FinOps, AI, GEO).
2.  **Plan**:
    * Define the ideal file structure in `axiarch-rules/blueprint/` (filenames and roles). Apply the `CRYSTALLIZATION_PROTOCOL.md` naming conventions to ensure room for future expansion.
    * Ensure critical items like **Localization**, **Security**, **FinOps**, and **GEO/AI** are not buried.
3.  **Write & Refactor**:
    * **Preservation (Critical)**:
        * When consolidating existing rules, **never lose** critical constraints (especially security, legal, business logic, localization quality).
        * **"File deletion" is only permitted when 100% of its content has been confirmed migrated to a new file.** Consolidation that reduces information density is prohibited.
    * **Prohibition**: No changes, deletions, or moves to **Class S (Universal)** files whatsoever.
    * **Domain Distribution (Critical)**:
        * **The lessons log (`010_project_lessons_log.md`) is a "temporary accumulation point," NOT the final destination.**
        * Insights and lessons MUST be **distributed, promoted, and crystallized into relevant domain-specific Blueprint files in strict compliance with `CRYSTALLIZATION_PROTOCOL.md`.**
    * **New Creation**: Create missing rules (e.g., **Localization UI Guidelines**, AI Cost Management Policy, Privacy Protection Guidelines, GEO Optimization Standards) as new files.
    * **Revision & Consolidation**: Review existing content and rewrite to be more strict and specific. Consolidate duplicated content.
    * **Protocol Compliance**:
        * Rule loading order must comply with `LOADING_PROTOCOL.md`.
4.  **Final Verify**:
    * Confirm all rules meet **"Silicon Valley standards"** AND **"target market standards"** and function as the project's constitution.
    * **Safety Check**: Re-confirm that security and privacy descriptions are sufficiently thorough.
    * **Distribution Check**: Verify lessons are not stagnating in the lessons log but have been promoted/migrated to appropriate domain files.

# Phase 5: Knowledge Feedback
**After completion, output the following information.**

* **Blueprint Structure**: Post-optimization file structure list with overview (including numbering rules).
* **Key Updates**: Major rules newly added or strengthened (especially **localization quality**, security, privacy, AI, FinOps, GEO, LTV perspectives).
* **Next Action**: Guidelines for how developers should utilize and operate this governance architecture going forward.

**Begin the thorough optimization and reconstruction of all project-specific rules (`axiarch-rules/blueprint/*.md`), leveraging the full knowledge of the project without degrading existing assets (rules).**
````
