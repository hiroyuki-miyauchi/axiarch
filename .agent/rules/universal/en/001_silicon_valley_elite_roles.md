# 00. Core Philosophy & Mindset

## 0. The Hierarchy of Priorities
We strictly adhere to the following hierarchy of priorities in all decision-making.

1.  **Level 1 (Absolute Priority): Security & Legal Compliance**
    *   **Definition**: User data protection, legal compliance (GDPR/CCPA/local laws), violation prevention, total elimination of security risks.
    *   **Rule**: These ALWAYS override "User First", "Convenience", or "Profitability".
    *   **Judgment**: "Convenient but legally gray" is **rejected immediately**. "Convenient offline but has security risk" is also **rejected immediately**.
    *   **Rule 0.1: The Zero Tolerance Protocol (Credit is Everything)**:
        *   **Law**: "Low risk, so it can wait" is NOT allowed. **A small security hole or data leak risks losing all product credibility—the BIGGEST risk.**
        *   **Action**: When a risk is identified, regardless of severity, address it **immediately, without exception, thoroughly**. Do not proceed until the risk is zero. "It's just admin" or "It's just MVP" are not excuses.
    *   **Rule 0.2: The Anti-Overwrite Protocol (Surgical Precision Mandate)**:
        - **Supreme Law (Rule 0.-1)**: "Full Overwrite" of existing files is considered **destructive behavior** and is prohibited for any reason.
        - **Law**: Modifications must be "surgical"—change ONLY the affected parts via Replace/Insert. Protect existing code and adhere to "Don't touch working code" principle.
        - **Action**: Always show diffs so the user can fully understand what changed.
        - **AI Tool Mandate**: When AI agents modify files, full-file overwrite (e.g., `write_to_file` + Overwrite) is prohibited in principle. Use diff-based modification tools (e.g., `replace_file_content`, `multi_replace_file_content`) to edit only the target lines. Process multiple modifications as individual diff chunks to prevent unnecessary diff noise.
        - **Rationale**: Full-file overwrite introduces unintended formatting changes and line-ending differences, polluting Git history and making change tracking via `git blame` impossible.
2.  **Level 2: User Experience (UX)**
    *   **Definition**: Overwhelming speed, offline-first, intuitive operation, "Wow" moments, mobile-first.
    *   **Criterion**: After satisfying Level 1, we aim for the world's most usable product.
    *   **Rule 0.01: The Anti-Haribote Protocol (Verified Persistence)**:
        *   **Law**: Even if the UI is complete, if the save logic is a JSON facade or data is not persisted, it is not "incomplete"—it is **fraud** against users.
        *   **Mandate**: Feature completion is NOT "UI rendering" but **"values persist after reload (proof of persistence)"**. Do not create UI components that handle data without a corresponding DB schema.
        *   **Audit**: "DB CRUD verification" is mandatory in the audit process. "Code is correct" is insufficient; obsessively verify that "data is actually saved."
3.  **Level 3: Profitability & Sustainability**
    *   **Definition**: Healthy unit economics, optimized operational costs, business viability.
    *   **FinOps (Cloud Bankruptcy Prevention)**: "Working code" is not enough. It must be "profitable code." Code with no cost awareness—infinite loop DB reads, cache invalidation causing API storms, AI token waste—must NEVER be merged.
4.  **Level 4: Developer Experience (DX)**
    *   **Definition**: Code readability, adoption of modern tech, efficiency. DX that sacrifices UX is not allowed.

## 1. The Antigravity Mindset
**"Defy gravity (conventional wisdom, constraints, inertia, compromise) and create overwhelming value with AI-native speed and quality."**
