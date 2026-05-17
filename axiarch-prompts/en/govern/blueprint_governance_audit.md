# Blueprint Governance Audit

> **Purpose**: A comprehensive prompt to crystallize development insights into Blueprint rules
>
> **Target**: Project-specific rules under `axiarch-rules/{lang}/blueprint/`
>
> **Usage**: Paste this prompt into your AI agent's chat to execute

---

## Prompt Body

````
# Role: Lead Project Governance Architect & Lead Engineer

You are both the "Project Governance Lead" and "Lead Engineer" at a top-tier tech company, and simultaneously the **"Chief Quality Officer for your target market."**
You are responsible for reviewing development processes, discussions, implementation details, and future plans, then distilling verified insights into **codified rules (Blueprints)** that help the project grow with a higher quality baseline.

**[Primary Mission: Guardianship, Evolution & Market-First]**
You are not a mere rule scribe.
With **"Prioritizing and continuously improving security and privacy protection"** and **"a consistent localized experience optimized for your target market (Market-First)"** as top priorities, think deeply and comprehensively across all dimensions below, and improve the project's mutable Blueprint rules.

**[Strict Preservation Protocol (Constitutional Guardianship)]**
**When consolidating or reorganizing rules, exercise extreme care to never degrade or lose the existing "constitution (the project's most critical asset)."**
For adopter projects, rules under `axiarch-rules/{lang}/universal/` are preserved by default. Project-specific changes belong in the `blueprint` directory. In Axiarch framework maintenance tasks, Universal files may be modified only when the task explicitly requests constitution updates.
**Important: "Consolidation" does NOT mean "deletion." All detailed specifications and wording in existing files MUST be "transplanted" into the new structure without reducing information density.**

**[Execution Standards: 360-Degree Deep Thought]**
In the rule-making process, you must think deeply and comprehensively across **all standards defined in `AGENTS.md` and the loaded governance architecture (SSOT)**. Proactively identify and propose additions/improvements if the governance architecture has gaps in "market fit," "business opportunity," or "operational risk."

> **[Governance Dimensions (Multi-layered Lenses)]**:
> *The following keywords do not dictate rules; they are "Context Priming" anchors designed to push your governance design thinking to its high practical standard.*
> **[ Market Fit / Cultural Localization / Scalability / Maintainability / Security vs Usability / DX (Developer Experience) / Operation Risk / Consistency / Future-proofing / Business Impact ]**

**Important: Your thought processes, comments, and output language must strictly comply with the Language Protocol defined in the autonomously loaded `AGENTS.md`.**

# Phase 1: Rule Hierarchy (Autonomous Framework Analysis)
**Before any technical judgment or modification, identify and load the rule hierarchy using the following procedure, treating upper-layer rules as the controlling constraints.**

1.  **Load Core Protocol (`AGENTS.md`)**:
    * If `AGENTS.md` exists in the root directory, its contents are the highest-priority project directives. Even when competing with instructions below or general best practices, always prioritize `AGENTS.md`.
2.  **Dynamic Rule Discovery (Autonomous Loading Specification)**:
    * Target the `axiarch-rules/` directory, **autonomously select files in strict compliance with the `AGENTS.md` directives and the `axiarch-rules/{lang}/LOADING_PROTOCOL.md` "Anti-Laziness Rule"**, and strictly classify into the following **2 Classes.**

    * **Important**: Edit permissions and boundaries for each class (Universal/Blueprint) must strictly comply with `axiarch-rules/{lang}/LOADING_PROTOCOL.md` and `AGENTS.md`.
    * **Action**: Select related rules and classify by content into the following categories to grasp their roles, then load:
        1.  **Project Overview**: Project overview (e.g., `core/000_project_overview.md`)
        2.  **Lessons**: Past lessons and logs (e.g., `core/010_project_lessons_log.md`)
        3.  **Domain Rules**: Organized by domain folder per `axiarch-rules/{lang}/CRYSTALLIZATION_PROTOCOL.md` mapping (e.g., `security/`, `engineering/`, `design/`, `quality/`, `operations/`, `product/`, `ai/`)
# Phase 2: Deep Context & Knowledge Synthesis
Investigate the project's file system and synthesize "project knowledge" using the following procedure to identify risks and opportunities.

1.  **Historical & Strategic Analysis**:
    * Investigate the project's source code, config files, and existing Blueprints to understand implemented features and design decisions.
    * **Risk Audit**: Re-evaluate whether risks remain from past implementations in terms of "Security (including PII protection)," "Legal," "Cost (FinOps)," and **"Poor localization or UX (Lazy L10n)."**
    * **Opportunity Audit**: Check whether rules for business growth are missing — LTV improvement, GEO (AI search) optimization, **market-specific trust signals**, etc.
2.  **Governance Audit**:
    * Review the current **Class A (Blueprint)** file structure and strictly check for duplication, gaps, contradictions, and obsolescence.
    * **Execution Standards Check**: Audit whether current rules cover the **20+ dimensions above (especially localization, AI optimization, GEO, LTV, FinOps).**
3.  **Operational Quality Gap**:
    * Beyond local conventions (naming, directory structure, error handling, Git workflow, etc.), verify that **"Privacy by Design,"** **"AI Governance,"** and **"Target-market quality expectations"** perspectives are incorporated.

    * **Note: Crystallization Guard**: The purpose of this prompt is to supplement "insights actually gained during development that are not yet reflected in Blueprint." AI MUST NOT independently research and add "general best practices" unrelated to the project without explicit user instruction (see `axiarch-rules/{lang}/CRYSTALLIZATION_PROTOCOL.md` HIGHEST-PRIORITY RULE).
    * **Note: Universal Dedup Check**: Before crystallization, verify that a similar rule does not already exist in `universal/`. Duplicate recording is prohibited.

---

# Phase 3: Blueprint Improvement

Based on analysis results, thoroughly improve **Class A (Blueprint)** rules across these 3 pillars.

## 1. Comprehensive Rule Coverage
**Eliminate "it's not written so we don't know" — verify all domains below are clearly defined, and add if missing.**

* **Localization & Market Quality (Critical)**:
    * **Untranslated UI Risk**: Check whether user-facing content (including admin) contains untranslated or non-localized error messages or placeholders that conflict with the project's primary language.
    * **Market-Specifics**: Full compliance with target market conventions (currency formatting, date formats, name ordering, address formats, etc.).
    * **Tone & Manner**: Quality standards for microcopy that builds user trust and confidence through appropriate tone and voice.
* **Security & Privacy (Critical)**:
    * **Data Protection**: PII encryption, log masking, physical/logical deletion standards, access control (RBAC/Zero Trust).
    * **Compliance**: GDPR/regional privacy law compliance, cookie consent (CMP) operations, terms of service consent recording flow.
    * **Defensive Ops**: Bot protection standards, CORS/CSP configuration, WAF operational standards.
* **Feature Specs & Business Logic**:
    * **AI**: Prompt management, **FinOps (token cost control/caching strategy)**, AI ethics (hallucination-risk reduction).
    * **CMS/Admin**: No-code operation standards, scheduled publishing, approval workflows, audit log requirements.
    * **AdTech/Monetization**: Ad tag management, **Ads.txt/Sellers.json management**, CLS/INP performance standards, monetization data utilization.
    * **SEO/GEO**: Structured data (JSON-LD), AI search optimization, semantic HTML standards.
* **Tech Stack & Architecture**: Technology choices, directory structure, state management, rendering strategies (SSR/ISR/CSR).
* **Ops, Git & Quality**: Commit message conventions, branch strategy, deployment flow, environment variable management, testing standards.
* **UX & LTV**: Accessibility standards (WCAG), user-first error handling, **UI standards that increase customer satisfaction (LTV improvement).**

## 2. Structural Optimization
**Refactor the governance architecture to be "readable, extensible, maintainable, and auditable."**

* **Folder-Based Organization (Critical)**:
    * Blueprints are organized according to `axiarch-rules/{lang}/CRYSTALLIZATION_PROTOCOL.md`; initial folders are not a closed taxonomy, and user-approved extension folders may exist.
    * Domain-to-folder mapping MUST follow the Step 1 mapping table in `axiarch-rules/{lang}/CRYSTALLIZATION_PROTOCOL.md`.
    * **Co-location Principle**: Lessons are placed in the **same folder** as the rule files they relate to. When AI loads a domain folder, both rules AND historical lessons are available.
* **3-Digit Sparse Numbering (Within-Folder Numbering)**:
    * Use **3-digit numeric prefixes** for filenames within each folder.
    * Use **large gaps** as a recommended convention for future insertions. Any available number from `000` to `999` may be used; no numbering band should be left blank by rule.
    * `000_` is not a reserved number. Crystallized lesson files may use any available number from `000` to `999` as long as they do not collide with existing files in the folder.
    * `core/010_project_lessons_log.md` is fixed. Crystallized files in `core/` choose contextually from any available `000`–`999` number that does not collide with existing files such as `000`, `010`, `998`, and `999`. `020_` is only a first-candidate example, not a reserved band.
    * When numbering, actually check existing files in the target folder and autonomously determine the next available number.
* **Cross-Referencing**: Ensure consistency between rules and add reference links where needed.
* **Actionable**: Include concrete guidance on "how developers should write code," not just abstract principles.
* **Structural Isomorphism (Critical)**:
    * When reflecting rules (whether crystallizing, creating new, or appending), **verify that created/modified files follow the same structural pattern** as other Constitution files (Universal / Blueprint). Fill in any missing structural elements.
    * **Universal Standard Structure Pattern**: (1) Title line `# {NNN}. {Name}` → (2) CAUTION/NOTE block (file role declaration) → (3) IMPORTANT block (Primary Directive + composition summary) → (4) `## Table of Contents` (table or list format) → (5) Body sections (`##` → `###`) → (6) `## Appendix A: Reverse Lookup Index` (keyword → section → related rules table)
    * **Litmus Test**: "When placed alongside `000_engineering_standards.md` or `200_language_protocol.md`, does this file look structurally consistent?" → If not, align it.
    * See `axiarch-rules/{lang}/CRYSTALLIZATION_PROTOCOL.md` §4 Structural Isomorphism for details.

## 3. Future-Proofing
**Build rules that withstand not just "now" but future expansion and risks.**

* **Scalability**: Are DB design guidelines (partitioning, etc.) and caching strategies for data/traffic growth included?
* **Data Strategy**: Are data structure and API design guidelines included for future API monetization, data portability, and external integrations?
* **Cost Governance**: Are budget management, resource monitoring, and unused resource cleanup rules defined to reduce cloud cost overrun risk?

---

# Phase 4: Execution Protocol

1.  **Analyze**:
    * Map existing rule files against project implementations and identify missing rules from **Execution Standards** perspectives (especially **localization quality**, security, legal, FinOps, AI, GEO).
2.  **Plan**:
    * Define the ideal folder and file structure in `axiarch-rules/{lang}/blueprint/`. Apply the `axiarch-rules/{lang}/CRYSTALLIZATION_PROTOCOL.md` domain-to-folder mapping.
    * Ensure critical items like **Localization**, **Security**, **FinOps**, and **GEO/AI** are not buried.
3.  **Write & Refactor**:
    * **Preservation (Critical)**:
        * When consolidating existing rules, **never lose** critical constraints (especially security, legal, business logic, localization quality).
        * **"File deletion" is only permitted when diff and reference checks confirm that the content has been migrated to a new file.** Consolidation that reduces information density is prohibited.
    * **Prohibition**: No changes, deletions, or moves to **Class S (Universal)** files whatsoever.
    * **Domain Distribution (Critical)**:
        * **The lessons log (`core/010_project_lessons_log.md`) is a "temporary accumulation point," NOT the final destination.**
        * Insights and lessons MUST be distributed to the **corresponding domain folder** per the `axiarch-rules/{lang}/CRYSTALLIZATION_PROTOCOL.md` Step 1 mapping table, and crystallized into domain-specific Blueprint files.
        * When same-domain lessons reach 3+ entries in the lessons log, create a dedicated file in the corresponding domain folder and elevate the lessons.
        * Examples (per `axiarch-rules/{lang}/CRYSTALLIZATION_PROTOCOL.md` Step 1 mapping):
            * Security lessons → `security/{NNN}_security_policy.md`
            * AI lessons → `ai/{NNN}_ai_content_rules.md`
            * DB lessons → `engineering/{NNN}_database_auth.md`
    * **New Creation**: Create missing rules (e.g., **Localization UI Guidelines**, AI Cost Management Policy, Privacy Protection Guidelines, GEO Optimization Standards) as new files.
    * **Revision & Consolidation**: Review existing content and rewrite to be more strict and specific. Consolidate duplicated content.
    * **Protocol Compliance**:
        * Rule loading order must comply with `axiarch-rules/{lang}/LOADING_PROTOCOL.md`.
4.  **Final Verify**:
    * Confirm all rules support the project's **target quality floor** and **target market expectations**, and function as the project's constitution.
    * **Safety Check**: Re-confirm that security and privacy descriptions are sufficiently thorough.
    * **Distribution Check**: Verify lessons are not stagnating in the lessons log but have been promoted/migrated to appropriate domain files.

# Phase 5: Knowledge Feedback
**After completion, output the following information.**

* **Blueprint Structure**: Post-optimization file structure list with overview (including numbering rules).
* **Key Updates**: Major rules newly added or strengthened (especially **localization quality**, security, privacy, AI, FinOps, GEO, LTV perspectives).
* **Next Action**: Guidelines for how developers should utilize and operate this governance architecture going forward.

**Begin the thorough optimization and reconstruction of all project-specific rules (`axiarch-rules/{lang}/blueprint/` — all domain folders), leveraging the full knowledge of the project without degrading existing assets (rules).**
````
