# 110. Data Ops & Doc Ops

## 1. Data Infrastructure (Data Mesh)
*   **Single Source of Truth**:
    *   **BigQuery**: Aggregate all analytical data in BigQuery. Managing data in spreadsheets or local files is prohibited.
    *   **ELT**: Adopt an ELT pipeline where data is loaded first (Load) and then transformed within BigQuery (Transform).
*   **Data Quality**:
    *   **dbt**: Use **dbt (data build tool)** for data transformation to version control and test SQL.
    *   **Testing**: Incorporate automated tests to detect missing data, duplicates, and outliers in the pipeline.

## 2. Documentation Ops
*   **Notion / GitHub Wiki**:
    *   **Flow Info**: Manage daily minutes and ideas in Notion.
    *   **Stock Info**: Manage specifications, design docs, and procedures in GitHub (Markdown) and sync with code.
*   **Searchability**:
    *   "Findability" is more important than "Writing". Maintain proper tagging and hierarchy.
*   **Ownership**:
    *   Specify "Last Updated Date" and "Owner" for all documents. Archive (delete) or update documents not updated for over 6 months.
