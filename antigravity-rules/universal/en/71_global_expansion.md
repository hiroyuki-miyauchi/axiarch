# 71. Global Expansion & i18n

## 1. Global Strategy & Tiers
*   **Tier Strategy**:
    *   **Tier 1 (High Priority)**: North America, Japan, Western Europe, Australia. Concentrate marketing budget and culturalization (cultural adaptation) as high ARPU is expected.
    *   **Dynamic Pricing Metadata**:
        *   **Law**: Control country-specific pricing and feature restrictions NOT via code variations, but via **Stripe Metadata** (e.g., `allowed_regions: ['JP', 'US']`) as defined in Product Constitution (`10`).
    *   **Tier 2 (Growth)**: Southeast Asia, South America, India. Aim for viral growth and lighten app size to support low-spec devices.
*   **Data Sovereignty**:
    *   **GDPR (EU)**: Store user data in EU servers as much as possible.
    *   **China**: When entering Chinese market, partner with local companies and use domestic servers (ICP License).

## 2. Day 1 i18n Architecture
*   **No Hardcoding**:
    *   Hardcoding text on UI is **strictly prohibited**. Always manage with key-value language files (`en.json`, `ja.json`).
    *   **Pseudo-localization**:
        *   **CI Check**: Test in a mode displaying pseudo-language (e.g., `Account` -> `[!!! Àççôûñţ !!!]`) instead of English during development. This instantly detects hardcoded strings and layout breaks (30% text length increase).
*   **Currency & Numbers**:
    *   Treat price not just as a number but as an object of "Amount + Currency Code" (e.g., `{ amount: 1000, currency: 'JPY' }`).
    *   Use `Intl.NumberFormat` for display to automatically apply format matching the locale.
*   **Translation Key Design Standard**:
    *   **Namespace Design**: Split translation keys by feature/page into Namespaces (e.g., `common`, `auth`, `error`, `admin`).
    *   **Naming Convention**: Use dot (`.`) as delimiter with a maximum depth of **3 levels** (e.g., `feature.section.element`).
    *   **Current Application**: Pre-installing i18n libraries is unnecessary to prevent over-investment, but when consolidating UI text into constant files, follow the above Namespace structure.

## 3. RTL (Right-to-Left) Support
*   **Logical Properties**:
    *   Prohibit use of physical properties like `left` / `right` / `margin-left` in CSS.
    *   Use **Logical Properties** (`start` / `end` / `margin-inline-start`) instead. This automatically flips layout when switched to Arabic or Hebrew (RTL).
*   **Icon Flipping**:
    *   Icons indicating direction (arrows etc.) are automatically flipped in RTL environments.

## 4. Timezone Management
*   **UTC Storage**:
    *   Time storage in DB and backend is done in **UTC (Coordinated Universal Time)** without exception. Storage in specific timezones (e.g., JST, PST) is prohibited.
*   **Local Conversion**:
    *   Convert to user's timezone only at the UI layer just before display to user.
*   **The Physical Location Timezone Override (Physical Store Exception)**:
    *   **Context**: "Universal Time (UTC)" principle is valid for digital services, but **Business Hours of Physical Stores** (Restaurants, Hospitals, etc.) must be judged by the store's location, not the user's location.
    *   **Law**: Display/Search of data tied to physical locations (opening hours, reservation slots) must NOT depend on user's browser locale but force **Timezone of that location (e.g., Asia/Tokyo)**.
    *   **Action**: For queries involving physical stores like "Open Now", enforce judgment using the store's timezone on the server side.

## 5. Cultural Sensitivity
*   **Layout**:
    *   German etc. tend to be longer than English. Design buttons and labels to support variable length and prevent layout breaks.
*   **Colors & Icons**:
    *   Meanings of colors and gestures differ by culture. Adopt global standard UI and avoid depending too much on specific cultures.

## 6. Translation Quality Gate
*   **Law**: When expanding to multiple languages, **releasing with machine translation only is prohibited**. All translated text MUST undergo **review by a native speaker**.
*   **Action**:
    1.  **Native Review Obligation**: Translated text must be reviewed by a native speaker of the target language (or a reviewer with equivalent linguistic proficiency).
    2.  **Git-Managed Translation Files**: Translation files must be managed in JSON format (or equivalent) under Git version control to maintain change history traceability.
    3.  **CI Check**: Introduce a mechanism to detect missing translation keys (keys that exist in code but are undefined in translation files) via CI.
*   **Rationale**: Machine translation frequently misses context and nuance. Especially for short UI text, unnatural expressions damage credibility and user trust.
