# 270. Global Expansion & i18n

## 1. Day 1 i18n Architecture
*   **No Hardcoding**:
    *   Even if the initial target is only Japan, hardcoding text on the UI is strictly prohibited. Always manage with key-value format language files (`en.json`, `ja.json`).
    *   **Reason**: Retrofitting internationalization (i18n) costs more than 10 times as much as building it in from the start.
*   **Currency & Numbers**:
    *   Treat prices not just as numbers but as objects of "Amount + Currency Code" (e.g., `{ amount: 1000, currency: 'JPY' }`).
    *   Use `Intl.NumberFormat` etc. for display to automatically apply formats (comma separation, currency symbol position) matching the locale.

## 2. Timezone Management
*   **UTC Storage**:
    *   Time storage in databases and backends must be done in **UTC (Coordinated Universal Time)** without exception. Storage in JST (Japan Standard Time) is prohibited.
*   **Local Conversion**:
    *   Convert to the user's timezone only immediately before display to the user (UI layer). This ensures correct time display regardless of access location globally.

## 3. Cultural Sensitivity
*   **Layout**:
    *   English and German tend to be longer than Japanese. Design buttons and labels to support variable lengths and prevent layout breakage.
*   **Colors & Icons**:
    *   Meanings of colors and gestures vary by culture (e.g., red is preferred in some cultures, disliked in others). Adopt global standard UIs and avoid relying too much on specific cultures.
