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

## 3. Comprehensive UI Localization Protocol
*   **Law**: Regardless of public or internal use, **all UI text** (buttons, placeholders, help text, statuses, screen reader text, documents) and **automatically sent transactional emails, SMS, and push notifications** MUST be localized to the Project Native Language.
*   **Action**:
    1.  **Hidden Text Coverage**: Visually hidden text such as icon `alt` attributes, `aria-label`, and `title` attributes MUST be localized **without exception**.
    2.  **Error & Fallback**: Fallback text for missing data or error states ("Unknown," "N/A," etc.) MUST be replaced with Project Native Language equivalents (e.g., "Unknown" → localized equivalent). Exposing English fallback text to users is an "implementation omission bug."
    3.  **Third-Party Extension**: When wrapping external libraries (editors, UI kits, etc.), always verify that UI labels and tooltips match the Project Native Language.
    4.  **Placeholder Integrity**: Placeholders MUST 100% match the data type and business context expected by that field. When copying from other components, re-verification of "semantic consistency" is mandatory.
    5.  **Context-Aware Nominalization**: Use concise, nominalized expressions for buttons and labels, avoiding verbose phrasing, to maintain a professional tone.
*   **Exception**: API paths, JSON keys, and technical terms (HTML, CSS, JSON, etc.) may remain in English for developer convenience, but explanatory text MUST always be in the Project Native Language.

## 3.1. UI Terminology Glossary Mandate
*   **Law**: Each project MUST establish a **UI Terminology Glossary** and treat inconsistent terminology for the same concept (e.g., mixing "Login" and "Sign In") as a **bug**.
*   **Action**:
    1.  **Glossary Definition**: Create a reference table of "Prohibited Expressions" vs "Standard Expressions" organized by category (authentication, operations, errors, etc.) and place it in the project documentation.
    2.  **Consistency Guarantee**: When creating new UI text, always reference the glossary and verify consistency with existing terminology.
    3.  **PR Review Item**: Include checking for glossary contradictions as a PR review checklist item.
*   **Rationale**: Terminology inconsistency increases user cognitive load and creates anxiety ("Is this a different feature?"). Unified terminology is the foundation of brand quality.

## 4. Validation Message Localization Protocol
*   **Law**: Default error messages from validation libraries (Zod, Yup, React Hook Form, etc.) are in English. Exposing them to users is a "bug."
*   **Action**:
    1.  **Explicit Message**: Set explicit `message` properties in the Project Native Language for all validation rules (especially `.url()`, `.email()`, `.datetime()`, `.enum()`, etc.).
    2.  **System Key Translation**: When displaying status codes or Enum values ('active', 'pending', etc.) in the UI, translate them through a Display Label Map to the Project Native Language. Displaying DB values, internal constants, or enum string values **directly using CSS `uppercase` or similar styling is strictly prohibited** (e.g., `<span class="uppercase">{status}</span>` → internal value shown as-is). Always pass through a mapping dictionary or label property.
    3.  **Logic-Layer Coverage**: Even messages passed to `throw new Error()` or Logger MUST be written in the Project Native Language if they may be displayed to end users.
    4.  **Placeholder URL Domain Guard**: When including URL references in code (e.g., emergency contacts, documentation links), the use of generic placeholder domains such as `example.com` is prohibited. Always replace with the project's actual domain to prevent broken links and misunderstanding in production.
*   **Rationale**: "Required" or "Invalid input" suddenly appearing in an otherwise localized UI damages user trust and gives an impression of an "incomplete system."

## 4.1. Localization CI Scan Protocol
*   **Law**: To structurally prevent untranslated strings from reaching production, it is **recommended** to incorporate **automated detection of untranslated strings** into CI/PR review.
*   **Action**:
    1.  **Automated Scan**: Use CI scripts or custom lint rules to detect strings in UI components (`.tsx`, etc.) that remain in a language other than the Project Native Language.
    2.  **Deep Layer Scan**: Scan not only UI component layer but also "hidden layers" such as error response functions (`errorResponse`, etc.), Service layer return values, Action layer return values, and `title` properties.
    3.  **Exclusion Config**: Component names, variable names, external public APIs (`/api/v1/*`, etc.), and Logger-targeted messages are excluded from scanning.
*   **Rationale**: Physically prevents the "Lazy Translation" problem where placeholder English labels and messages from development are released to production as-is.

## 5. Translation Exclusion Policy
*   **Law**: While localization is mandatory, there are cases where "translating every English string would break program logic." The following patterns are **explicitly excluded from translation**.
*   **Exclusion List**:
    1.  **Program Constants**: String constants used in frontend conditional logic (e.g., `'QUOTA_EXCEEDED'`).
    2.  **Flow Control Strings**: Strings used for state management in authentication flows, etc. (e.g., `'OTP Required'`).
    3.  **External API Values**: Strings dependent on third-party API specifications (e.g., Stripe's `status: 'active'`).
    4.  **Internal Exceptions (`throw new Error`)**: Developer-facing assertions processed within try-catch blocks that do not reach the UI.
*   **Judgment Criteria**:
    *   ✅ **Translate**: `return { error: '...' }` → May be displayed to users.
    *   ✅ **Translate**: `return { message: '...' }` → Displayed in toasts or alerts.
    *   ❌ **Do NOT Translate**: `throw new Error('...')` when a separate user-facing message is displayed in the catch block.
    *   ❌ **Do NOT Translate**: Constant strings used as comparison targets in conditional logic.

## 6. API Response Language Policy
*   **Law**: The `detail` and `message` fields in API error responses have different display layers depending on the caller. Therefore, the language policy MUST be separated between **internal APIs** and **external public APIs**.
*   **Action**:
    1.  **Internal APIs** (APIs consumed by the frontend): Write the `detail` argument of error messages in the **Project Native Language**. These may be displayed to users as Toast notifications or alerts.
    2.  **External Public APIs** (`/api/v1/*` and other third-party-facing APIs): Maintain **English** as the international standard API specification.
    3.  **PR Scan**: During PR review, verify that error response function arguments match the target language.
*   **Rationale**: Internal API error messages have a pathway to being displayed on the user's UI, making them subject to localization obligations. External public APIs maintain English as standard to ensure international interoperability.
