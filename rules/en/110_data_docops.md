# 110. Data & DocOps Strategy

## 1. Modern Data Stack (BI Strategy)
*   **Architecture**:
    *   **Ingest**: Aggregate raw data from Firebase/GCP into BigQuery.
    *   **Transform**: Process raw data into analytical tables (Marts).
    *   **Visualize**: Use Looker Studio to visualize KPIs (LTV, CAC, Retention) required for management decisions in real-time.
*   **Single Source of Truth**:
    *   "Manual aggregation in spreadsheets" is prohibited. All numbers must be sourced from dashboards automatically generated from BigQuery.

## 2. DocOps (Documentation Operations)
*   **Docs as Code**:
    *   Documentation is equivalent to code. Manage it with Git and subject it to PR reviews.
    *   Code changes and documentation updates are "Atomic." Do not merge code changes without documentation updates.
*   **Freshness & Maintenance**:
    *   **Dead Link Check**: Introduce mechanisms to automatically detect broken links.
    *   **Review Cycle**: Review major rule files quarterly to prevent obsolescence.
*   **AI Generation**:
    *   Leverage AI to automatically generate API specifications and boilerplate documentation, allowing humans to focus on describing "Why."
