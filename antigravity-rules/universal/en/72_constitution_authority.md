# 72. Constitution Authority & Immutability

> [!CAUTION]
> **Single Source of Truth**
> - **The Constitution**: Rules under `universal/` are the absolute "Constitution" for all projects and are **Immutable** by default. Do not modify these generic rules for specific project convenience.
> - **Extension**: Specific project requirements must be defined by "inheriting and extending" the constitution within `blueprint/` or the project's rule files.
> - **Centralization**: Scattering ad-hoc rules in `.gemini` or chat logs is prohibited. All rules must be centralized as version-controllable Markdown files.

## 1. Duty of Reference

> [!CRITICAL]
> **Rule 7.3: Mandatory Reference Duty**
> - **Requirement**: AI Agents and Developers MUST refer to and understand relevant rules in `antigravity-rules/` before executing any task.
> - **Action**:
>   1. Check Project Constitution (`00` series).
>   2. Check Domain Rules relevant to the task (FE/BE/Admin etc.).
>   3. Check Operational Constraints (Language Protocol etc.).
> - **Compliance**: Code written without referring to/understanding these rules is considered "Broken" by definition.

## 2. Documentation Law (The Logic-Doc Unity)
*   **Law**: `antigravity-rules/blueprint/` is not "reference material" but **part of the Code (Logic)**.
*   **Drift Ban**: Changing implementation without updating the corresponding rule file (design doc) is a bug called **"Drift"** and is strictly prohibited.
*   **Definition**:
    *   **Good**: Changed spec, updated Blueprint, then implemented.
    *   **Felony**: Changed implementation but left Blueprint outdated (guaranteed future confusion).

## 3. The Conflict Resolution Protocol
*   **Law**: When contradictions arise between constitution files (e.g., Firebase Constitution vs Supabase Constitution), the **more "Strict" and "Core" rule** takes precedence.
*   **Hierarchy**: In this project, regarding data management, **Backend Constitution (`37`)** is positioned above all other documents (`32`, `unknown`, etc.) and has absolute decision authority.

## 4. The Sparse Numbering Protocol
*   **Law**: File numbers for rule files and Blueprint specifications MUST be assigned with **gaps of approximately 5–10** to allow for future expansion.
*   **Anti-Pattern**: Sequential numbering (1, 2, 3...) eliminates room for inserting new rules and is prohibited.
*   **Example**: Use numbering like `00, 10, 20, 30...` or `00, 05, 10, 15...` to ensure sufficient gaps between categories.

## 5. The Unique Numbering Protocol
*   **Law**: File prefix numbers for rule files and Blueprint specifications (e.g., `10_`, `30_`) MUST be **completely unique (Unique) across the entire project**.
*   **Prohibition**: Having multiple files with the same number (e.g., `50_business.md` and `50_strategy.md`) causes reference ambiguity and is **strictly prohibited**.
*   **Action**: When creating a new rule file, always check the existing file list and guarantee that numbers do not conflict. If a conflict exists, either merge with the older file or assign a new number.

## 6. The Additive Evolution Protocol
*   **Law**: Changes to rule files and Blueprint specifications MUST be made only through **"Append" or "Amend"**. Deleting past knowledge and lessons is "Regression."
*   **Red Button Protocol**: If deletion of a rule or Blueprint section is truly necessary (e.g., complete deprecation), a **"Red Button" level warning** MUST be issued to the user and explicit approval obtained. The reason "for tidying up" is not accepted.
*   **Rationale**: Documentation assets are the project's "Memory." Erasing memory structurally increases the risk of repeating the same mistakes.
