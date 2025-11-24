# 270. Global Expansion & i18n

## 1. Day 1 i18n Architecture
*   **No Hardcoding**:
    *   Even if the initial target is only Japan, hardcoding UI text is strictly prohibited. Always manage text using key-value language files (e.g., `en.json`, `ja.json`).
    *   **Reason**: Retrofitting internationalization (i18n) later costs 10x more than building it in from the start.
*   **Currency & Numbers**:
    *   Treat prices as objects (Amount + Currency Code), not just numbers (e.g., `{ amount: 1000, currency: 'JPY' }`).
    *   Use `Intl.NumberFormat` or similar to automatically apply locale-specific formatting (comma separators, currency symbol placement) when displaying.

## 2. Timezone Management
*   **UTC Storage**:
    *   All time data in the database and backend MUST be stored in **UTC (Coordinated Universal Time)** without exception. Storing in JST (Japan Standard Time) is prohibited.
*   **Local Conversion**:
    *   Convert to the user's local timezone only at the UI layer (just before display). This ensures correct time display regardless of where the user accesses from.

## 3. Cultural Sensitivity
*   **Layout**:
    *   English and German text tends to be longer than Japanese. Design buttons and labels to be variable-width to prevent layout breakage.
*   **Colors & Icons**:
    *   The meaning of colors and gestures varies by culture (e.g., red is lucky in some cultures, a warning in others). Adopt global standard UI patterns and avoid over-reliance on specific cultural contexts.
