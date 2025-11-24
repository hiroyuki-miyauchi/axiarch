# 71. Geo Strategy & Localization

## 1. Internationalization (i18n)
*   **Day 1 Support**:
    *   **No Hardcoding**: Strictly prohibit hardcoding text in UI code. Always separate into resource files (ARB/JSON).
    *   **LTR/RTL**: Design layouts to support Right-to-Left (RTL) languages like Arabic.
*   **Cultural Sensitivity**:
    *   Colors, icons, and gestures have different meanings in different cultures. Adopt designs that are culturally neutral or appropriate for each region.

## 2. Geo Expansion Strategy
*   **Tier Strategy**:
    *   **Tier 1 (Priority)**: Japan, USA. Focus resources here until PMF is achieved.
    *   **Tier 2 (Expansion)**: English-speaking world, Europe. Expand the successful model from Tier 1.
*   **Local Payments**:
    *   Support major local payment methods (PayPay, Venmo, WeChat Pay, etc.) to prevent CVR drop-off.

## 3. Timezones & Dates
*   **UTC Standard**:
    *   **Storage**: Store and process all times in **UTC** in the database and backend.
    *   **Display**: Convert to the user's local timezone (JST, etc.) only at the moment of display.
