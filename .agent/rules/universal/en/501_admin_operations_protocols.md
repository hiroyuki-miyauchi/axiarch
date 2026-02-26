# 50. Admin Operations & Internal Tools
## 8. Admin Operations Protocols

### 8.1. The Admin Hygiene Protocol (Native Language UI)
*   **Law**: "It's just an admin panel" is an excuse that lowers the productivity of non-engineer operators.
*   **Action**:
    *   **Full Localization**: Every text on the screen (Labels, Errors, Log Actions) must be in the **Project Native Language** defined in `GEMINI.md`.
    *   **Mapping**: Always use mapping constants to display Enum values or System Identifiers.

### 8.2. The System Transparency Protocol (Tech Stack Sync)
*   **Context**: Ops/Execs lose trust if the tech stack is a black box.
*   **Law**: When the tech stack changes (New DB, New AI Model), update the "Tech Stack Card" on the dashboard immediately to reflect reality.

### 8.3. The Explicit Explanation Protocol (Zero Jargon)
*   **Law**: "Common sense for developers (UUID, CPM, MRR)" is "mysterious symbols" for operators. Lack of explanation is tool failure.
*   **Action**:
    *   **Zero Jargon**: MUST attach `Info` icon and `Tooltip` to all technical terms, metrics, and calculated values on admin screens, explaining in layperson terms "what it is, how it's calculated, and how it affects business".
    *   **No Assumptions**: Prohibit "obvious from looking" assumptions. All numbers require definitions. New dashboards/metrics are considered "complete" only when Tooltip implementation is done.

### 8.4. The Data Seeding & Caching Protocol
*   **Law**: Cache key staleness or overconfidence in CLI results ("Up to date") causes data inconsistency in production (master data loss, etc.).
*   **Action**:
    *   **Versioning**: Attach version suffix (`_v2` etc.) to master data cache keys when data quantity or quality changes, physically invalidating cache.
    *   **Verification**: After production sync, MUST verify data count matches expectations via application—make this step mandatory.

### 8.5. The Label Mapping Protocol
*   **Law**: Displaying system internal keys (Enum values, status codes, action names, etc.) directly in the UI is "cryptography" for non-engineer operators and a failure as a tool.
*   **Action**:
    1.  **Display Map**: Define display constant maps for all Enum values and system identifiers (e.g., `STATUS_LABEL_MAP: Record<Status, string>`), and retrieve labels via this map from the UI.
    2.  **Fallback**: When a value not present in the map is passed (future extensions, etc.), display the raw key as a fallback while outputting a warning to the Logger. This enables immediate detection of "untranslated" states.
    3.  **Localization Ready**: Write label maps in the project's configured language and design them for easy replacement with i18n keys when future multi-language support is needed.
*   **Scope**: Applies to all button labels, table column headers, audit log action names, and notification messages.
