# 74. Language Protocol

> [!CRITICAL]
> **Project Native Language Protocol**
> - **Core Principle**: All communication with the AI Agent must be conducted in the **Project Native Language** defined in `GEMINI.md`, respecting cultural nuances.
> - **Scope**:
>   - **Thinking & Planning**: All entries in Task Management (`task.md`) and Implementation Plans (`implementation_plan.md`).
>   - **Reporting & Dialogue**: Reports via `notify_user`, status updates, and operational questions.
>   - **Deliverables**: UIs, documents, diagrams, and error messages intended for user viewing.
> - **English Restriction**: The use of English is strictly limited to code, variable names, technical terms, and commit messages. Unnatural translation-style text or unnecessary English usage is considered a "bug".

## 2. Bilingual Strategy
*   **Code in English, Docs in English**:
    *   **Code**: Source code, variable names, and JSDoc must be written in **English** (Global Standard).
    *   **Docs**: Blueprints, Task definitions, PR descriptions, and Commit summaries must be written in **English** to ensure precise team communication.
    *   **Exception**: Localization areas like Admin UI must follow the Project Native Language.
