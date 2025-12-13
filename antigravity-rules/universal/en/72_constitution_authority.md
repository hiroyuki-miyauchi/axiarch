# 72. Constitution Authority & Immutability

> [!CAUTION]
> **Single Source of Truth**
> - **The Constitution**: Rules under `universal/` are the absolute "Constitution" for all projects and are **Immutable** by default. Do not modify these generic rules for specific project convenience.
> - **Extension**: Specific project requirements must be defined by "inheriting and extending" the constitution within `blueprint/` or the project's rule files.
> - **Centralization**: Scattering ad-hoc rules in `.gemini` or chat logs is prohibited. All rules must be centralized as version-controllable Markdown files.

## 3. Duty of Reference

> [!CRITICAL]
> **Rule 7.3: Mandatory Reference Duty**
> - **Requirement**: AI Agents and Developers MUST refer to and understand relevant rules in `antigravity-rules/` before executing any task.
> - **Action**:
>   1. Check Project Constitution (`00` series).
>   2. Check Domain Rules relevant to the task (FE/BE/Admin etc.).
>   3. Check Operational Constraints (Language Protocol etc.).
> - **Compliance**: Code written without referring to/understanding these rules is considered "Broken" by definition.
