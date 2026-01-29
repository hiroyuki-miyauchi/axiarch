# 74. Language Protocol

> [!CRITICAL]
> **Project Native Language Protocol**
> - **Core Principle**: All communication with the AI Agent must be conducted in the **Project Native Language** defined in `GEMINI.md`, respecting cultural nuances.
> - **Scope**:
>   - **Thinking & Planning**: All entries in Task Management (`task.md`) and Implementation Plans (`implementation_plan.md`).
>   - **Reporting & Dialogue**: Reports via `notify_user`, status updates, and operational questions.
>   - **Deliverables**: UIs, documents, diagrams, and error messages intended for user viewing.
> - **English Restriction**: The use of English is strictly limited to code, variable names, technical terms, and commit messages. Unnatural translation-style text or unnecessary English usage is considered a "bug".

## 1. Zero Cognitive Load Protocol
*   **Law**: To achieve zero communication loss with native language users and developers, make **Project Native Language the primary language** for UI, documents, commit message intent (comments), and physically eliminate cognitive load (translation effort).
*   **Localization Mandate**:
    *   **UI Compliance**: Error messages and validation notifications MUST be in **natural, polite Native Language** that users can intuitively understand, not system-generated English (e.g., "Invalid input").
    *   **Validation Guard**: When using schema validation libraries like Zod, MUST set custom messages in Native Language. Exposing English error messages to users is defined as "implementation omission bug".
*   **Quality Standard (The Professional Tone)**:
    *   **Anti-Translation Feel**: Prohibit unnatural direct-translation style language (e.g., "It has been succeeded", "Invalid value"). Pursue natural expressions appropriate for a professional SaaS (e.g., "Saved successfully", "Please enter in valid format").
    *   **Politeness**: Mandate micro-copy that conveys respect for users and spirit of "Hospitality", not mere translation of "Please".

## 2. Bilingual Strategy
*   **Code in English, Docs in Native Language**:
    *   **Code**: Source code, variable names, and JSDoc must be written in **English** (Global Standard).
    *   **Docs**: Blueprints, Task definitions, PR descriptions, and Commit summaries must be written in **Project Native Language** to ensure precise team communication.
    *   **Exception**: Localization areas like Admin UI must follow the Project Native Language.
