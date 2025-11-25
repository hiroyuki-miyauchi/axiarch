# 110. Data Ops & Doc Ops

## 1. Data Infrastructure ("Data Mesh")
*   **Single Source of Truth**:
    *   **BigQuery**: All analytical data is aggregated in BigQuery. Management in spreadsheets or local files is prohibited.
    *   **ELT**: Adopt an ELT pipeline where data is loaded first without modification and then transformed within BigQuery.
*   **Data Quality**:
    *   **dbt**: Use **dbt (data build tool)** for data transformation to version control and test SQL.
    *   **Testing**: Incorporate tests into the pipeline to automatically detect missing data, duplicates, and outliers.

## 2. Documentation Ops
*   **Living Documentation**:
    *   **Mermaid.js**: Architecture diagrams and flowcharts must be written in code bases like **Mermaid.js**, not images (png/jpg). This allows version control and editing, preventing obsolescence.
    *   **ADR (Architecture Decision Records)**: Record important decisions like "Why we chose this technology" or "Why we designed it this way" in Markdown format in the `docs/adr` directory to preserve historical context.
*   **Notion / GitHub Wiki**:
    *   **Flow Info**: Manage daily minutes and ideas in Notion.
    *   **Stock Info**: Manage specifications, design documents, and procedures in GitHub (Markdown) and synchronize them with the code.
*   **Searchability**:
    *   It is more important for documentation to be "findable" than "written". Maintain appropriate tagging and hierarchy.
*   **Ownership**:
    *   Clearly state the "Last Updated Date" and "Owner" on all documents. Documents not updated for more than 6 months should be updated or archived (deleted).
*   **Docs as Code**:
    *   Documentation is equivalent to code. Manage it with Git and make it subject to PR reviews.
    *   Code changes and documentation updates are "atomic" (inseparable). Do not merge code changes without documentation updates.
*   **Freshness & Maintenance**:
    *   **Dead Link Check**: Introduce a mechanism to automatically detect broken links.
    *   **Review Cycle**: Review major rule files quarterly to prevent obsolescence.
*   **AI Generation**:
    *   Use AI to automatically generate API specifications and boilerplate code documentation, allowing humans to focus on describing the "Why".
