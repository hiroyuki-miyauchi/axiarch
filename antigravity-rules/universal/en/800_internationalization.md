# 71. Global Expansion & i18n

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-03-24 | Version 3.0 — Zero-based reconstruction

> [!IMPORTANT]
> **Supreme Directive**
> "Internationalization is not translation — it is architectural respect for every user's culture."
> All i18n decisions must prioritize cultural accuracy, architectural scalability, and user trust.
> Strictly follow: **Cultural Accuracy > Functional Parity > Performance > Speed**.
> **16 Parts, 74 Sections.**

---

## Table of Contents

- [Part I: Global Expansion Strategy Foundation](#part-i-global-expansion-strategy-foundation)
- [Part II: Internationalization (i18n) Architecture](#part-ii-internationalization-i18n-architecture)
- [Part III: Localization (L10n) Infrastructure](#part-iii-localization-l10n-infrastructure)
- [Part IV: RTL & BiDi Support](#part-iv-rtl--bidi-support)
- [Part V: CJK & Multi-Script Support](#part-v-cjk--multi-script-support)
- [Part VI: Timezone, Calendar & Locale Management](#part-vi-timezone-calendar--locale-management)
- [Part VII: Cultural Adaptation & Culturalization](#part-vii-cultural-adaptation--culturalization)
- [Part VIII: Multi-Region Infrastructure & Performance](#part-viii-multi-region-infrastructure--performance)
- [Part IX: Payments, Taxation & Compliance](#part-ix-payments-taxation--compliance)
- [Part X: SEO/GEO & Content Internationalization](#part-x-seogeo--content-internationalization)
- [Part XI: AI/LLM Multilingual Support](#part-xi-aillm-multilingual-support)
- [Part XII: Mobile & Cross-Platform i18n](#part-xii-mobile--cross-platform-i18n)
- [Part XIII: Testing & Quality Assurance](#part-xiii-testing--quality-assurance)
- [Part XIV: Security & Privacy Internationalization](#part-xiv-security--privacy-internationalization)
- [Part XV: Observability & FinOps](#part-xv-observability--finops)
- [Part XVI: Organization, Process & Maturity](#part-xvi-organization-process--maturity)
- [Appendix A: Quick Reference Index](#appendix-a-quick-reference-index)

---

## Part I: Global Expansion Strategy Foundation

### Section 1: Global Expansion Philosophy & Principles

- **i18n-First Principle**: Internationalization (i18n) MUST be embedded into the architecture from Day 1. Retrofitting is the single largest source of technical debt
- **L10n ≠ Translation**: Localization is NOT translation. It is a comprehensive process encompassing cultural adaptation (culturalization), legal adaptation, and technical adaptation
- **Priority Hierarchy**:
  1. **Functional Accuracy**: Correct data display (currency, dates, numbers)
  2. **Legal Compliance**: Adherence to regional regulations (GDPR, APPI, CCPA, etc.)
  3. **Cultural Appropriateness**: Elimination of culturally inappropriate expressions/designs
  4. **Linguistic Quality**: Natural translations, accurate terminology
- **Locale-Agnostic Code**: Business logic MUST be locale-independent. Locale-dependent processing is confined to the UI layer and formatting layer
- **AI-Ready i18n**: Translation resource files MUST be structured for easy parsing and processing by LLMs. Attach context metadata and enforce consistent naming conventions to improve AI translation accuracy

### Section 2: Market Tier Strategy & GTM

- **Tier Classification**:

| Tier | Example Regions | Strategy | Investment Criteria |
|---|---|---|---|
| Tier 1 (Highest Priority) | North America, Japan, Western Europe, Australia | Full culturalization, concentrated marketing | High ARPU, mature regulations |
| Tier 2 (Growth Markets) | Southeast Asia, South America, India | Viral growth, lightweight optimization, low-bandwidth | User base growth, mobile-first |
| Tier 3 (Watch List) | Africa, Middle East, Central Asia | Minimum i18n, market monitoring | Future potential assessment |

- **Dynamic Pricing Metadata**: Control country-specific pricing and feature restrictions via **Stripe Metadata** (e.g., `allowed_regions: ['JP', 'US']`) — NOT via code branching → `100_product_strategy.md`
- **Tier Promotion Criteria**: Tier changes based on quarterly KPI evaluation
  - MAU growth rate > 20%/month
  - ARPU > 50% of global average
  - Regulatory environment stabilization

### Section 3: Data Sovereignty & Residency Strategy

- **Data Sovereignty Mapping**:

| Region | Key Regulation | Data Storage Requirement | Implementation Action |
|---|---|---|---|
| EU | GDPR, EU Data Act (Sept 2025) | EU servers by default | SCC/BCR, Sovereign Cloud consideration |
| China | PIPL, Data Cross-Border Security Assessment | Domestic servers mandatory, ICP required | Local partner engagement |
| Russia | Federal Law No.242-FZ | Domestic storage obligation | Domestic DC usage |
| India | DPDPA 2023 | Critical personal data cross-border restrictions | Data classification, DPIA execution |
| South Korea | PIPA | Appropriate safeguards obligation | Regional encryption policy |
| Brazil | LGPD | Adequate protection level obligation | International transfer agreements |

- **Sovereign Cloud Usage**:
  - For strict sovereignty requirements, leverage AWS European Sovereign Cloud / Azure Sovereign Cloud / GCP Sovereign Cloud
  - Sovereign Cloud selection criteria: Self-managed encryption keys, staff nationality requirements, government audit readiness
- **Data Flow Diagram**: Document ALL paths where data crosses borders, specify legal basis. Annual review mandatory
- → See `601_data_governance.md` for data residency details

---

## Part II: Internationalization (i18n) Architecture

### Section 4: Day 1 i18n Architecture

- **No Hardcoding — Absolute Ban**: Hardcoding text on UI (buttons, labels, placeholders, error messages, tooltips, aria-labels) is **strictly prohibited**
- **Externalization Mandate**: All translatable text MUST be managed in key-value resource files (`en.json`, `ja.json`, etc.)
- **Pseudo-localization**:
  - Test in pseudo-language mode during development (e.g., `Account` → `[!!! Àççôûñţ !!!]`)
  - **Detection targets**: Hardcoded strings, layout breakage (30-40% text length increase tolerance), character corruption
  - **CI Integration**: Embed pseudo-localization tests in CI/CD pipeline for automatic hardcode detection

```javascript
// ❌ Prohibited: Hardcoded
const label = "Enter your name";

// ✅ Correct: Externalized
const label = t('form.name.placeholder');
```

### Section 5: Translation Key Design & Namespace Management

- **Namespace Design**: Split translation keys by feature/page into Namespaces
  - Examples: `common`, `auth`, `error`, `admin`, `settings`, `notification`
- **Naming Convention**:
  - Delimiter: Dot (`.`)
  - Maximum depth: **3 levels** (`feature.section.element`)
  - Key names: English snake_case (`auth.login.submit_button`)
- **Context Attachment**: Use separate keys for identical text with different contexts
  - Example: `common.save` (generic) vs `settings.profile.save` (profile-specific)
- **AI-Ready Metadata**: Attach context, max character length, and screenshot links as metadata for each key
- **Prohibited Practices**:
  - Do NOT use translation text itself as key (e.g., do NOT use `"Save changes"` as key)
  - Dynamic key generation prohibited (`t(\`error.${code}\`)`) — prevents static analysis and missing key detection

```json
{
  "common": {
    "save": "Save",
    "cancel": "Cancel",
    "delete": "Delete"
  },
  "auth": {
    "login": {
      "title": "Log in",
      "submit_button": "Log in",
      "error_invalid": "Invalid email or password"
    }
  }
}
```

### Section 6: ICU MessageFormat 2.0 & CLDR Integration

- **ICU MessageFormat 2.0 Adoption**: MessageFormat 2.0, stabilized in CLDR 47 / ICU 77 (March 2025), is the standard for new implementations
- **CLDR (Common Locale Data Repository) Usage Mandate**:
  - Custom implementations for date/time/number/currency formatting are prohibited. Comply with CLDR data
  - Use via `Intl` API (JavaScript) or ICU libraries
- **MessageFormat 2.0 Key Features**:
  - Modular structure with custom function extension points
  - Safe markup embedding (XSS prevention)
  - Incremental migration path from MessageFormat 1.0
- **Custom Function Extension**: Register domain-specific formatters (currency display, relative date display, etc.) as custom functions
- **MF 1.0→2.0 Migration**: New code requires MF 2.0. Existing code: formulate and execute quarterly migration plans

```
// MessageFormat 2.0 syntax example
.local $count = {$itemCount :number}
.match $count
one {{You have {$count} item in your cart.}}
*   {{You have {$count} items in your cart.}}
```

### Section 7: Pluralization, Gender & Grammar Rules

- **CLDR Plural Rules Mandatory**: Custom pluralization logic is prohibited. Use CLDR plural categories (zero/one/two/few/many/other)
  - English: 2 categories (one/other)
  - Arabic: 6 categories (zero/one/two/few/many/other)
  - Japanese: 1 category (other only)
  - Polish: 4 categories (one/few/many/other)
- **Gender Support**: Messages containing personal references MUST be structured to accommodate grammatical gender
  - Use MF 2.0 `.match` directive for gender branching
- **Ordinal Support**: Ordinal displays (1st, 2nd, 3rd...) MUST comply with CLDR ordinal rules

### Section 8: Date, Time & Calendar Systems

- **Intl.DateTimeFormat Mandate**: Date/time formatting MUST use `Intl.DateTimeFormat` with automatic locale application
- **Temporal API Adoption**: Actively adopt `Temporal` (TC39 Stage 3, stable in Chrome 130+ / Node 24+)
  - `Temporal.ZonedDateTime`: Timezone-aware date-time processing
  - `Temporal.PlainDate`: Timezone-independent date processing
  - New usage of legacy `Date` object is prohibited (Temporal migration recommended)
- **Calendar System Support**: Support major market calendar systems
  - Japanese Era (Japan: Reiwa)
  - Buddhist Calendar (Thailand)
  - Hijri Calendar (Middle East: Islamic Calendar)
- **Relative Time**: Use `Intl.RelativeTimeFormat` ("3 days ago", "in 2 hours", etc.)
- **Week Start Day**: Account for locale differences (Sunday vs Monday vs Saturday)

```javascript
// ✅ Locale-aware date formatting
const formatter = new Intl.DateTimeFormat('ja-JP-u-ca-japanese', {
  era: 'long', year: 'numeric', month: 'long', day: 'numeric',
});
// → "令和8年3月16日"

// ✅ Temporal API (recommended)
const zdt = Temporal.ZonedDateTime.from({
  timeZone: 'Asia/Tokyo',
  year: 2026, month: 3, day: 16, hour: 23,
});
```

### Section 9: Number, Currency & Measurement Unit Formatting

- **Currency Object Mandatory**: Treat prices as "Amount + Currency Code" objects
  - `{ amount: 1000, currency: 'JPY' }` — designs that do NOT separate amount from currency are prohibited
- **Intl.NumberFormat Mandate**: Use for number and currency display formatting
- **Decimal Handling**: Process decimal places per currency based on CLDR (JPY: 0, USD: 2, BHD: 3)
- **Measurement Units**: Use `Intl.NumberFormat` `unit` option for locale-aware formatting (km/mi, kg/lb, °C/°F)
- **Large Numbers**: Use `notation: 'compact'` for locale-specific abbreviated notation (English: 1.2K, Japanese: 1.2万)

```javascript
// ✅ Currency formatting
new Intl.NumberFormat('ja-JP', {
  style: 'currency', currency: 'JPY'
}).format(1000); // → "￥1,000"

new Intl.NumberFormat('en-US', {
  style: 'currency', currency: 'USD'
}).format(9.99); // → "$9.99"

// ✅ Compact notation
new Intl.NumberFormat('ja-JP', {
  notation: 'compact', compactDisplay: 'short'
}).format(12000); // → "1.2万"
```

### Section 10: String Concatenation Ban & Contextual Messages

- **Absolute Ban on String Concatenation**: Dynamic construction of translated text (`"Hello, " + name + "!"`) is prohibited
  - Word order differences across languages (SOV vs SVO) make concatenated strings untranslatable
- **Placeholder Approach**: Use placeholders (`{name}`) for variable insertion
- **Context Notes**: Attach context notes for translators describing the usage context of each key
- **HTML in Translation Prohibited**: Do NOT include HTML tags directly in translation strings. Use MF 2.0 markup features or component splitting for rich text

```javascript
// ❌ Prohibited: String concatenation
const msg = greeting + ", " + userName + "!";

// ✅ Correct: Placeholders
const msg = t('greeting.personal', { name: userName });
// en: "Hello, {name}!"
// ja: "{name}さん、こんにちは！"
```

### Section 11: Resource File Management & Splitting Strategy

- **File Splitting Criteria**:
  - Split by page/feature (`auth.json`, `settings.json`, `common.json`)
  - Target maximum 500 keys per file
- **Lazy Loading**: Dynamically load only required Namespaces on navigation (bundle size optimization)
- **Fallback Chain**: Resolve in order: `ja-JP` → `ja` → `en` (default language)
- **Translation File Immutability**: Key deletion is discouraged. Mark as Deprecated, then delete after 2 release cycles

### Section 12: Edge i18n & Middleware Processing

- **Edge Locale Detection**:
  - Parse `Accept-Language` header at the edge (Cloudflare Workers / Vercel Edge Middleware / Next.js Middleware)
  - Geo-IP region detection as fallback (User Setting > Accept-Language > Geo-IP)
- **Edge Redirects**: Process locale-unspecified URL redirects to appropriate locale URLs at the edge (reduce origin server load)
- **Edge Caching**: Isolate per-locale caches with `Vary: Accept-Language`

```javascript
// Next.js Middleware locale detection example
export function middleware(request) {
  const locale = request.headers.get('accept-language')?.split(',')[0]?.split('-')[0] || 'en';
  const supportedLocales = ['ja', 'en', 'ko', 'zh'];
  const resolved = supportedLocales.includes(locale) ? locale : 'en';
  // ...redirect processing
}
```

---

## Part III: Localization (L10n) Infrastructure

### Section 13: Translation Management System (TMS) Integration

- **TMS Adoption Threshold**: TMS is mandatory when expanding to 3+ languages
- **Recommended TMS Comparison**:

| TMS | Strengths | Git Integration | MF 2.0 Support | AI Translation |
|---|---|---|---|---|
| Crowdin | Community translation, large-scale | ✅ GitHub/GitLab/Bitbucket | ✅ | ✅ DeepL/Google/OpenAI |
| Lokalise | Developer-friendly, REST API | ✅ GitHub/GitLab | ✅ | ✅ DeepL/Google |
| Phrase | Enterprise, TMS+Strings unified | ✅ GitHub/GitLab | ✅ | ✅ Own AI+External |

- **TMS Selection Requirements**:
  - Direct Git repository integration (automatic PR generation)
  - Translation Memory (TM) and Glossary support
  - ICU MessageFormat 2.0 support
  - CLI/CI integration via API
  - Branch-based translation workflows
- **OTA Translation Updates**: Design mobile apps to update translations without app store resubmission

### Section 14: Continuous Localization (CI/CD Integration)

- **Continuous Localization**: Integrate the translation process into CI/CD pipelines for parallel development and translation
- **Workflow**:
  1. Developers add translation keys in source code
  2. CI/CD automatically detects new/changed keys and pushes to TMS
  3. Translators translate and review in TMS
  4. Approved translations auto-merge as PRs
- **Missing Key Detection**: Compare source code keys against translation files; fail build on untranslated keys via CI
- **Translation File Git Management**: All translation files MUST be stored in JSON/YAML format under Git version control
- **Translation Coverage Gate**: Validate translation coverage in CI/CD. Tier 1 languages require 100%, Tier 2 languages require 95%+

```yaml
# CI/CD pipeline example (GitHub Actions)
- name: i18n-check
  run: |
    npx i18n-check --source src/ --locales locales/ --fail-on-missing
    npx i18n-coverage --threshold 95 --tier1-threshold 100
```

### Section 15: Translation Quality Assurance (LQA, MTPE, Native Review)

- **Machine Translation-Only Releases Prohibited**: All translated text MUST undergo native speaker review
- **LQA (Linguistic Quality Assurance) Metrics**:
  - **MQM (Multidimensional Quality Metrics)**: Quantitative evaluation based on error classification (accuracy, fluency, terminology, style)
  - Pass threshold: MQM score **98+ out of 100**
- **MTPE (Machine Translation Post-Editing)**: When using AI translation, post-editing is mandatory
  - **Light PE**: Short UI labels — verify meaning accuracy
  - **Full PE**: Marketing copy, legal documents — bring to native quality
- **Review Process**: Translator → Reviewer → Technical verification (variable/tag integrity) — 3-stage pipeline

### Section 16: Translation Memory, Glossary & Style Guide

- **Translation Memory (TM) Usage**: Reuse past translations for consistency and cost efficiency
- **Glossary Mandatory**: Maintain per-language glossaries for all projects
  - Define unified translations for technical, brand, and industry terms
  - Explicitly list do-not-translate words (brand names, product names, etc.)
- **Style Guide**: Define per-language tone, writing style, and formality levels
  - Japanese: Polite form (desu/masu) / formality standards
  - English: American English vs British English standardization
- **Glossary Version Control**: Manage glossaries in Git; PR review required on changes

### Section 17: AI/Machine Translation Usage & Governance

- **AI Translation Scope**:

| Use Case | AI Translation | Post-Editing | Native Review |
|---|:---:|:---:|:---:|
| UI labels, buttons | ✅ | ✅ Light PE | ✅ |
| Help, FAQ | ✅ | ✅ Full PE | ✅ |
| Marketing copy | ⚠️ Reference only | — | ✅ Write from scratch recommended |
| Legal documents, ToS | ❌ Prohibited | — | ✅ Legal review required |
| UGC (User-Generated Content) | ✅ Real-time | — | ❌ Not required |

- **AI Translation Provider Comparison**:

| Provider | Strengths | Languages | Notes |
|---|---|---|---|
| DeepL API | High quality, natural output | 30+ | EU company, GDPR-friendly |
| Google Cloud Translation Advanced | Broad language coverage | 130+ | AutoML Translation support |
| AWS Translate | AWS ecosystem integration | 75+ | Active Custom Translation |
| Claude/GPT-4o | Context understanding, style adaptation | 100+ | Token cost management required |

- **Quality Monitoring**: Periodically sample and evaluate AI translation quality (monthly). Manage baselines with BLEU/COMET scores
- **Data Privacy**: PII removal/anonymization is mandatory before sending data to translation APIs
- **Cost Management**: Set token budgets for AI translation API calls; monitor monthly

### Section 18: Global Content Governance

- **Regional Content Review Workflow**:
  - Establish content review processes based on cultural and legal requirements for each target market
  - Legal/compliance teams approve content per region
- **Content Localization Priority**:
  1. Legal documents (ToS, Privacy Policy) — Required in each country's language
  2. Critical UI, onboarding — Required for Tier 1 languages
  3. Marketing, blog — Recommended for Tier 1 languages
  4. Help center — Phased rollout
- **Do-Not-Translate Content**: Brand names, product names, trademarks retain original text

### Section 19: Translation ROI & Cost Optimization

- **Translation Cost Metrics**:
  - Cost per word ($/word) × annual translation volume
  - AI translation+MTPE vs full human translation cost comparison
  - TM utilization rate (higher = more cost savings)
- **Cost Optimization Strategy**:
  - Maximize TM reuse rate (target: 70%+)
  - Use AI translation Light PE for UI label translation to reduce costs by 50%
  - Improve source content quality (reduce ambiguous source text to improve translation efficiency)

---

## Part IV: RTL & BiDi Support

### Section 20: CSS Logical Properties Mandate

- **Physical Properties Prohibited**: Usage of `left`/`right`/`margin-left`/`padding-right` and other physical direction properties is prohibited
- **Logical Properties Required**:
  - `margin-inline-start` / `margin-inline-end`
  - `padding-block-start` / `padding-block-end`
  - `inset-inline-start` / `inset-inline-end`
  - `border-inline-start` / `border-inline-end`
  - `text-align: start` / `text-align: end`
- **Lint Enforcement**: Auto-detect physical property usage via ESLint/Stylelint with errors

```css
/* ❌ Prohibited: Physical properties */
.sidebar { margin-left: 16px; padding-right: 24px; text-align: left; }

/* ✅ Correct: Logical properties */
.sidebar { margin-inline-start: 16px; padding-inline-end: 24px; text-align: start; }
```

### Section 21: BiDi (Bidirectional Text) Control

- **`dir` Attribute Setting**: Explicitly set `dir="ltr"` or `dir="rtl"` on HTML elements
- **`lang` Attribute Setting**: Set locale and direction simultaneously: `<html lang="ar" dir="rtl">`
- **Unicode BiDi Control Characters**: Use Unicode BiDi control characters (LRM/RLM/LRE/RLE, etc.) for mixed-direction text
- **`bdi` Element**: Isolate text with unknown direction (e.g., UGC) using `<bdi>` element
- **Number Direction**: Numbers display left-to-right even in RTL environments (both Arabic and Indic numeral systems)
- **CSS `direction` Property Prohibited**: Do NOT set `direction: rtl` in CSS; control via HTML `dir` attribute (accessibility reasons)

### Section 22: RTL Test Automation

- **RTL Snapshot Testing**: Automatically capture and compare screenshots for major screens in both LTR and RTL
- **Storybook RTL Decorator**: Equip component libraries with RTL decorators as standard
- **CI Checks**:
  - Physical property lint checks
  - RTL layout visual regression testing
  - BiDi text display accuracy verification
  - Form input RTL behavior testing

### Section 23: Icon & Media Flipping Rules

- **Icons to Flip**: Directional icons (arrows, forward/back, sliders, progress bars, list/tree indentation)
- **Icons NOT to Flip**: Real-world objects (clocks, checkmarks, play buttons), brand logos, mathematical symbols
- **CSS Implementation**: `[dir="rtl"] .icon-arrow { transform: scaleX(-1); }`
- **Images & Video**: Prepare separate RTL versions for images containing text

### Section 24: RTL-Ready Component Design Patterns

- **Flexbox/Grid RTL Auto-Adaptation**: `flex-direction: row` auto-reverses with `dir="rtl"`. Combine with logical properties
- **Absolute Positioning**: Use `inset-inline-start`/`inset-inline-end` (`left`/`right` prohibited)
- **Scroll Direction**: RTL support for horizontal scrolling (`direction: rtl` on scroll container — CSS direction permitted only in this case)
- **Animation Direction**: Reverse slide-in/out animation directions in RTL environments

---

## Part V: CJK & Multi-Script Support

### Section 25: CJK Font Strategy

- **Font Subsetting**: CJK fonts have enormous character sets (tens of thousands); subsetting is mandatory
  - Subset-split loading via `unicode-range`
  - Dynamic subsetting via Google Fonts `text=` parameter
- **Variable Fonts Recommended**: Prefer variable fonts for flexible CSS weight/width adjustment
- **Fallback Definition**: CJK → System font → Generic family fallback chain
- **size-adjust**: Suppress layout shifts during fallback with `size-adjust` / `ascent-override` / `descent-override`

```css
/* CJK font stack example */
font-family: 'Noto Sans JP', 'Hiragino Sans', 'Yu Gothic UI',
             'Meiryo', sans-serif;
```

### Section 26: Character Encoding & Unicode 16.0

- **UTF-8 Unified**: Use UTF-8 as the sole encoding across the entire project
- **BOM (Byte Order Mark) Prohibited**: Do NOT use UTF-8 BOM
- **Unicode 16.0 Support**: Support Unicode 16.0 (released September 2024) / Emoji 16.1 new characters
  - Test rendering of new scripts and emoji
  - Consistent usage of normalization form (NFC)
- **DB Collation**: Use `utf8mb4` (MySQL) or `C.UTF-8`/`ICU` for database collation — full emoji and surrogate pair support
- **HTTP Headers**: Always explicitly specify `Content-Type: text/html; charset=utf-8`

### Section 27: Input Method (IME) Support

- **`compositionstart`/`compositionend` Events**: Do NOT execute search or validation on uncommitted IME text
- **Text Field Design**: Account for IME candidate window overlap in layouts
- **`inputmode` Attribute**: Display appropriate mobile keyboards (`numeric`, `email`, `tel`, etc.)
- **Virtual Keyboard Support**: Leverage `virtualKeyboardPolicy` API (supported browsers)
- → Also see IME section in `200_design_ux.md`

### Section 28: Vertical Writing, Ruby & Special Notation

- **Vertical Writing**: Use CSS `writing-mode: vertical-rl` for Japanese content when required
- **Ruby (Furigana)**: Use `<ruby>` / `<rt>` elements. Provide `<rp>` fallback for unsupported browsers
- **Emphasis Dots**: Use `text-emphasis` property for emphasis (NOT underlines)
- **Full-width/Half-width Normalization**: Properly normalize user input for full-width alphanumerics and half-width katakana
- **CJK Line Breaking**: Use `word-break: auto-phrase` (Chrome 130+) for natural Japanese line breaks. Fallback to `overflow-wrap: anywhere`

### Section 29: Multi-Script & Complex Script Support

- **Indic Scripts**: Support complex ligatures and combining characters for Devanagari (Hindi), Tamil, Bengali, etc.
- **Arabic Shaping**: Accurate rendering of context-dependent forms (isolated/initial/medial/final)
- **Thai/Khmer**: Text processing for languages without word boundaries (leverage `Intl.Segmenter`)
- **Emoji**: Skin tone modifiers and ZWJ Sequence support. Test rendering differences across platforms

```javascript
// ✅ Intl.Segmenter for word segmentation (Thai, etc.)
const segmenter = new Intl.Segmenter('th', { granularity: 'word' });
const segments = segmenter.segment('สวัสดีครับ');
```

---

## Part VI: Timezone, Calendar & Locale Management

### Section 30: UTC Storage & Local Conversion Principle

- **UTC Storage Mandatory**: Time storage in database and backend MUST be in **UTC without exception**. Storage in specific timezones (JST, PST, etc.) is prohibited
- **Conversion Timing**: Convert to user's timezone only at the UI layer immediately before display
- **`timestamptz` Usage Mandatory**: In PostgreSQL, use `timestamptz` (`timestamp with time zone`), NOT `timestamp without time zone`

```sql
-- ❌ Prohibited
CREATE TABLE events (start_at TIMESTAMP);

-- ✅ Correct
CREATE TABLE events (start_at TIMESTAMPTZ DEFAULT NOW());
```

### Section 31: IANA Time Zone DB & DST Support

- **IANA TZ DB Usage**: Timezone identifiers MUST follow IANA Time Zone Database (e.g., `Asia/Tokyo`, `America/New_York`)
- **Fixed Offset Prohibited**: Storing/processing with fixed offsets (`UTC+9`) is prohibited — cannot correctly handle DST
- **DST (Daylight Saving Time) Support**: MUST test DST transition handling
  - Non-existent times (Spring Forward: e.g., 2:30 between 2:00→3:00 skip)
  - Ambiguous times (Fall Back: e.g., 1:00-2:00 occurs twice)
- **TZ DB Update Tracking**: Establish maintenance process to track IANA TZ DB updates (2-4 times/year)
  - Node.js: Via `full-icu` or ICU4X
  - OS: Auto-update tzdata packages

### Section 32: Physical Location Timezone Override

- **Context**: UTC principle works for digital services, but **Physical Store Business Hours** (restaurants, hospitals, etc.) MUST be judged by the store's location, NOT the user's
- **Rule**: Display and search of data tied to physical locations (opening hours, reservation slots) MUST NOT depend on user's browser locale — force **the location's timezone**
- **Implementation**: For queries like "Open Now" involving physical stores, enforce server-side judgment using the store's timezone

### Section 33: Calendar System Support

- **Supported Calendar Systems**:
  - Gregorian (standard)
  - Japanese Era (`ja-JP-u-ca-japanese`)
  - Buddhist Calendar (`th-TH-u-ca-buddhist`)
  - Hijri Calendar (`ar-SA-u-ca-islamic-civil`)
  - Minguo Calendar (`zh-TW-u-ca-roc`)
- **Intl API Usage**: Specify calendar system via `Intl.DateTimeFormat` `calendar` option
- **Week Start Day**: Process based on CLDR `firstDay` data (Japan: Sunday, France: Monday, Middle East: Saturday)
- **Fiscal Year Concept**: Fiscal and academic years differ by country (Japan: April start, US: September/October start)

### Section 34: Locale Detection & Settings Management

- **Locale Priority Chain**:
  1. User's explicit setting (profile / cookie)
  2. `Accept-Language` header
  3. Geo-IP estimation
  4. Default language (`en`)
- **Locale Setting Persistence**: Store user's locale selection server-side (Cookie + DB)
- **Locale Switcher UI**: Provide locale switching UI accessible from all pages. Display language names in native script (日本語, English, العربية)
- **BCP 47 Compliance**: Locale tags MUST use BCP 47 format (`ja-JP`, `en-US`, `ar-SA`)

---

## Part VII: Cultural Adaptation & Culturalization

### Section 35: Color, Icon & Gesture Cultural Sensitivity

- **Cultural Meaning of Colors**:
  - Red: China (luck, prosperity) vs Western (danger, warning)
  - White: Japan (purity, also mourning) vs Western (purity, marriage)
  - Green: Islamic world (sacred) vs Western (nature, eco)
  - Purple: Thailand (mourning) vs Western (nobility, luxury)
- **Countermeasure**: Avoid relying on color alone for meaning in global UI. Use icons and text alongside color
- **Gestures**: Thumbs-up (👍) is offensive in some cultures. OK sign (👌) is insulting in Brazil. Verify gesture icons per region
- **Images & Photos**: Ensure diversity in models (race, gender, age). Avoid images biased toward specific cultures

### Section 36: Layout Expansion & Contraction

- **Text Length Variation Reference**:

| Language Pair | Text Length Change | Design Consideration |
|---|---|---|
| English → German | +30-40% increase | Button/nav width flexibility |
| English → Finnish | +30-40% increase | Label wrapping support |
| English → Japanese | Fewer chars, wider glyphs | line-height adjustment |
| English → Arabic | +25% increase | RTL + expansion |
| English → Chinese (Simplified) | -30-50% decrease | Ensure minimum width |

- **Design Principles**:
  - Buttons and labels MUST accommodate variable lengths (fixed widths prohibited)
  - Text truncation (ellipsis) is a last resort
  - Use Flexbox/Grid for flexible layout design
  - Set safe boundaries with `min-width`/`max-width`
- **Testing**: Verify layout tolerance for 30-40% text length increase via pseudo-localization

### Section 37: Name, Address & Phone Number Formatting

- **Name Diversity**:
  - Family-given order (Japan, China, Korea, Hungary)
  - Middle names, patronymics (Russia, Iceland)
  - Mononyms (Indonesia, etc.)
  - **Design**: Prefer a single `full_name` field when possible. If separation is required, implement locale-specific display order logic
- **Address Formatting**: Use locale-specific formats based on Google libaddressinput / CLDR territoryData
  - Postal code position and format (Japan: 〒xxx-xxxx, UK: postcode, India: PIN code)
- **Phone Numbers**: Validate and format with libphonenumber (Google). International prefix (`+81`, etc.) support required

### Section 38: Legal & Regulatory Localization

- **Terms of Service & Privacy Policy**: Mandatory provision in target country's language (GDPR Article 12, consumer contract laws, etc.)
- **Consent Mechanisms**: Reflect opt-in/opt-out differences by country/region
  - EU: Explicit opt-in required (GDPR). TCF 2.2 / CMP integration
  - US: Opt-out model. GPP (Global Privacy Platform) support
  - Japan: APPI 2024 revision compliance. Third-party sharing consent
- **Age Restrictions**: Manage per-country minimum age for digital services (13/16 years, etc.)
- → See `601_data_governance.md` for legal details

### Section 39: Religion, Holidays & Calendar Events

- **Religious Sensitivity**: Auto-schedule suppression of food advertising during Ramadan, marketing restraint during religious holidays, etc.
- **Holiday Calendar**: Maintain per-country holiday database; reflect in marketing and notification schedules
- **Seasonality**: Account for reversed seasons between Northern and Southern hemispheres (summer sale timing, etc.)
- **Cultural Calendar Events**: Japanese rokuyō (taian, butsumetsu), Chinese Lunar New Year, etc.

---

## Part VIII: Multi-Region Infrastructure & Performance

### Section 40: CDN & Edge Delivery Strategy

- **Multi-CDN Strategy**: Avoid single CDN dependency; select optimal CDN providers per region
  - Asia: Cloudflare / Akamai / Fastly
  - China: Alibaba Cloud CDN / Tencent Cloud CDN (ICP required)
- **Edge Computing**: Process locale detection, redirects, and dynamic content generation at the edge
- **Locale-Specific Static Asset Delivery**: Edge-cache language-specific images and font files
- **Vary Header**: Properly manage per-locale caching with `Vary: Accept-Language`
- **Edge i18n Processing**: Complete locale detection/routing at edge via Next.js Middleware / Cloudflare Workers

### Section 41: Multi-Region Deployment

- **Region-Agnostic Design**: Applications MUST NOT contain hardcoded region logic; inject region configuration via environment variables
- **Data Replication**: Serve read loads from nearest region's read replicas. Route writes to primary region
- **Failover**: Design automatic failover for regional failures (define RTO/RPO)
- **Observability**: Configure cross-region monitoring and alerting
- **Regional Deployment Strategy**: Stage canary releases by region incrementally

### Section 42: Data Residency & Sovereignty Requirements (Technical Implementation)

- **Regulation Mapping**: Continuously track data localization laws for target countries
- **Sovereign Cloud**: Consider AWS European Sovereign Cloud / Azure Sovereign Cloud / GCP Sovereign Cloud for strict data sovereignty requirements
- **Data Flow Diagrams**: Document all paths where data crosses borders with explicit legal basis
- **Technical Controls**:
  - Regional encryption key management (KMS per region)
  - Automatic routing based on data classification (PII → regional servers)
  - Log and telemetry data also subject to sovereignty requirements
- → See `601_data_governance.md` for data privacy details

### Section 43: Font & Image Performance Optimization

- **Font Loading Strategy**:
  - `font-display: swap` (show text immediately, lazy-load font)
  - `preload` minimal fonts in Critical CSS
  - Split CJK fonts via `unicode-range` subsetting
- **Regional Image Optimization**: Deliver region-specific banners/marketing images from nearest CDN edge
- **Low Bandwidth Support**: Strengthen image compression and lazy loading for Tier 2/3 regions
- **AVIF/WebP Support**: Optimize global delivery including CJK environments with modern formats

### Section 44: Global Performance Budget

- **Regional CWV Targets**:

| Metric | Tier 1 Target | Tier 2 Target | Tier 3 Target |
|---|---|---|---|
| LCP | < 2.5s | < 3.0s | < 4.0s |
| FID/INP | < 100ms | < 200ms | < 300ms |
| CLS | < 0.1 | < 0.15 | < 0.2 |

- **Font Load Impact Measurement**: Quantitatively measure CJK font load impact on LCP. Suppress to under 1MB via subset splitting
- **Low Bandwidth Simulation**: Perform 3G/4G throttling tests simulating Tier 2/3 regions

### Section 45: Network Resilience & Offline Support

- **Service Worker Offline i18n**: Pre-cache translation resources. Provide localized UI even when offline
- **Low Bandwidth Optimization**: Compress translation files (Brotli), enable delta updates
- **CDN Fallback**: Automatic failover to backup CDN on primary CDN failure

---

## Part IX: Payments, Taxation & Compliance

### Section 46: Multi-Currency Payments & Exchange Rate Management

- **Zero-Decimal Currency Support**: Handle currencies with no decimal places (JPY, KRW, etc.). Follow Stripe's smallest unit convention
- **Exchange Rate Management**: Fetch real-time exchange rates. Ensure transparency between displayed and settlement rates
- **Multi-Currency Balances**: Leverage Stripe Multi-Currency Balances. Hold balances in each currency, instant conversion, local bank transfers
- **Regional Payment Methods**: Support per-country primary payment methods

| Region | Primary Payment Methods | Priority |
|---|---|---|
| Japan | Credit cards, Convenience store payment, PayPay | Required |
| China | WeChat Pay, Alipay | Required |
| EU | SEPA, iDEAL (NL), Bancontact (BE), Klarna | Required |
| India | UPI, RuPay | Required |
| Southeast Asia | GrabPay, DANA, GCash | Recommended |
| Brazil | Pix, Boleto | Recommended |

- → See `101_revenue_monetization.md` for payment details

### Section 47: International Taxation (VAT/GST/Sales Tax)

- **Tax Rate Management**: Dynamically manage country/region-specific tax rates via database or Stripe Tax
- **VAT/GST Display Requirements**: Tax-inclusive/exclusive display requirements vary by law
  - EU: Tax-inclusive display mandatory for B2C
  - US: Tax-exclusive typical (state-specific sales tax)
  - Japan: Total amount display mandatory
- **Digital Services Tax (DST)**: Systematize per-country DST compliance

| Country/Region | DST Rate | Threshold | Status |
|---|---|---|---|
| UK | 2% | Global revenue £500M+ | Active |
| France | 3% | Global revenue €750M+ | Active |
| Italy | 3% | Global revenue €750M+ (2025 threshold removed) | Active |
| Philippines | 12% VAT | Foreign digital services (June 2025~) | New |
| Sri Lanka | 18% VAT | Foreign digital services (2025~) | New |

- **Invoice Compliance**: Japan Qualified Invoice System (Invoice System) and EU e-Invoice regulation support

### Section 48: EU OSS/IOSS & Cross-Border E-Commerce Taxation

- **OSS (One Stop Shop)**: Unified VAT reporting for B2C cross-border sales within EU
  - Registration obligation triggered above €10,000
  - Apply customer's country VAT rate
  - Quarterly consolidated filing
- **IOSS (Import One Stop Shop)**: Unified VAT reporting for cross-border e-commerce goods ≤€150
  - Collect destination country VAT rate at point of sale
  - Monthly filing
  - Non-EU businesses must appoint an EU-based intermediary
- **Stripe Tax Integration**: Automate tax calculation, collection, and reporting across 100+ countries. OSS/IOSS supported

```javascript
// Stripe Tax integration example
const session = await stripe.checkout.sessions.create({
  automatic_tax: { enabled: true },
  line_items: [{ price: 'price_xxx', quantity: 1 }],
  mode: 'payment',
});
```

### Section 49: Global Regulatory Compliance

- **EAA (European Accessibility Act)**: Effective June 2025. Mandatory accessibility for digital products targeting EU market
  - EN 301 549 compliance (encompasses WCAG 2.1 AA. WCAG 2.2 recommended)
  - June 2030: Existing products/services must also comply
  - Violations: Fines, market access loss, reputational risk
- **DMA (Digital Markets Act)**: Data portability and fair competition obligations for gatekeeper platforms
- **EU Data Act**: Full effect September 2025. IoT data access rights, cloud switching promotion

### Section 50: Regulation Checklist

| Regulation | Applicable Region | Key Requirements | Priority |
|---|---|---|---|
| GDPR | EU/EEA | Data protection, cross-border transfer restrictions | Required |
| CCPA/CPRA | California | Consumer privacy | Required |
| APPI | Japan | Personal information protection | Required |
| PIPL | China | Personal information protection | Required |
| LGPD | Brazil | Data protection | Tier-dependent |
| PIPA | South Korea | Personal information protection | Tier-dependent |
| DPDPA | India | Digital personal data protection | Tier-dependent |
| EAA | EU | Accessibility mandate | Required |
| EU AI Act | EU | AI risk classification, transparency | Conditional |

- **Cookie Consent**: Implement regional cookie consent requirements (EU: TCF 2.2 prior consent, US: GPP notice-based)
- → See `600_security_privacy.md` / `601_data_governance.md` for security and legal details

### Section 51: Multilingual E-Invoicing

- **Japan**: Qualified Invoice System (Invoice System). Accurate registration number and tax rate category notation
- **EU**: EN 16931-compliant e-Invoice. Expanding B2G electronic submission mandate via Peppol BIS 3.0
- **Technical Implementation**: Invoice data holds multilingual metadata in JSON/XML format. Currency, tax rates, and dates comply with each country's format

### Section 52: PCI DSS & International Payment Security

- **PCI DSS 4.0**: Global card information security standard (full enforcement March 2025)
- **Strong Customer Authentication (SCA)**: EU PSD2-compliant strong authentication. 3D Secure 2.0 required
- **Regional Payment Security Requirements**: India (additional authentication), Brazil (CPF verification), etc.

---

## Part X: SEO/GEO & Content Internationalization

### Section 53: International SEO

- **hreflang Implementation Mandatory**: Multi-language pages MUST include `<link rel="alternate" hreflang="xx">`
  - Include `x-default` fallback
  - Include self-referencing hreflang
  - Set up bidirectional links between all language variants
- **URL Structure Strategy**:
  - Subdirectory recommended: `example.com/ja/`, `example.com/en/`
  - ccTLD: `example.jp`, `example.de` (if significant brand investment)
  - Subdomain: `ja.example.com` (NOT recommended — SEO signal dilution)
- **sitemap.xml**: Generate sitemap including per-language URLs with hreflang annotations
- **Canonical Settings**: Set canonical URLs correctly per language
- **hreflang Audit Automation**: Auto-verify hreflang bidirectionality, `x-default` presence, and self-referencing in CI

```html
<link rel="alternate" hreflang="ja" href="https://example.com/ja/page" />
<link rel="alternate" hreflang="en" href="https://example.com/en/page" />
<link rel="alternate" hreflang="x-default" href="https://example.com/en/page" />
```

### Section 54: GEO (AI Search Optimization) Multilingual Support

- **Multilingual Structured Data**: Provide JSON-LD structured data per language
- **Multilingual LLMs.txt**: Prepare per-language `llms.txt` for AI search engines
- **Per-Language Metadata**: Optimize title / description / OGP per language
- **Answer Engine Optimization**: FAQ structuring for AI search (Perplexity / ChatGPT Search / Google AI Overviews)
- → See `102_growth_marketing.md` for GEO details

### Section 55: Multilingual Content Strategy

- **Headless CMS Integration**: Embed language fields in content models; manage per-language variants
- **Translation Workflow Integration**: Auto-send content from CMS to TMS; auto-import translated content
- **Fallback Strategy**: Define fallback language for untranslated content (e.g., fr-CA → fr → en)
- **Content Freshness Sync**: Auto-detect stale translations when source content updates; trigger re-translation
- → See `341_headless_cms.md` for CMS details

### Section 56: Multilingual SEO Technical Debt Management

- **hreflang Audit**: Periodically auto-audit hreflang implementation accuracy
  - Detect orphan language pages (not linked from other languages)
  - Detect hreflang pointing to 404s or redirects
- **Duplicate Content Detection**: Auto-detect cross-language duplicate content (untranslated pages)
- **Index Coverage**: Monitor per-language indexing status via Google Search Console / Bing Webmaster Tools

### Section 57: International Content Moderation

- **Regional Content Policies**: Content moderation rules based on per-country regulations
  - EU: DSA (Digital Services Act) illegal content response obligations
  - Germany: NetzDG (Network Enforcement Act)
  - Japan: Provider Liability Limitation Act
- **Multilingual Moderation**: Perform UGC moderation in target languages. AI + human hybrid approach

---

## Part XI: AI/LLM Multilingual Support

### Section 58: LLM Prompt Internationalization

- **Multilingual Prompt Templates**: Manage system prompts and user-facing response templates per language
- **Language Detection & Response Language Control**: Implement guardrails to detect user input language and respond in the same language
- **Token Efficiency**: CJK languages consume more tokens; account for token budget in prompt design
  - Japanese: ~1.5-2x token consumption vs English
  - Countermeasure: Prompt compression, Few-shot example optimization
- **Language Specification Guardrails**: Explicitly specify response language in system prompt. Prevent output language from being influenced by context document language

```
// Multilingual prompt control example
System: You MUST respond in the same language as the user's query.
If the user writes in Japanese, respond in Japanese.
Never switch languages mid-response.
```

### Section 59: RAG Multilingual Knowledge Base

- **Multilingual Vector Index**: Build knowledge base with per-language or cross-lingual embedding models
- **Embedding Model Selection**:

| Model | Multilingual Support | Features | Recommended Use |
|---|---|---|---|
| multilingual-e5-large-instruct | 100+ languages | MMTEB top-tier, instruction-tuned | Cross-lingual search |
| Cohere embed-v4 | 100+ languages | Commercial, high accuracy | Enterprise RAG |
| BGE-M3 | 100+ languages | Multi-Granularity | Hybrid search |

- **Cross-Lingual Search**: Design for retrieving documents in languages different from the user's query language
- **Per-Language Chunk Management**: Adjust document splitting granularity per language characteristics (CJK: character-based, Western: word-based)
- **Language-Aware Reranking**: Factor language affinity into result reranking. Penalize documents in languages different from query
- → See `400_ai_engineering.md` for AI implementation details

### Section 60: AI-Generated Content Multilingual Quality Assurance

- **Hallucination Detection**: Perform fact-checking of AI-generated text per language
- **Cultural Appropriateness Filter**: Guardrails ensuring AI output is culturally appropriate for target audiences
- **Quality Metrics**: Per-language quality benchmarking with BLEU/COMET/BERTScore
- **Output Language Validation**: Auto-verify that AI responses are in the specified language

### Section 61: LLM Multilingual Safety & Bias

- **Multilingual Jailbreak Countermeasures**: Defend against prompt injection and jailbreak attempts in non-English languages
- **Cross-Language Bias Detection**: Monitor cross-language quality differences in LLM output. Detect quality degradation in low-resource languages
- **Multilingual Harmful Content Filter**: Detect language-specific harmful expressions and hate speech
- → See `600_security_privacy.md` for security details

### Section 62: AI Translation Workflow Integration

- **Real-Time AI Translation Pipeline**:
  1. Receive source text
  2. PII removal / anonymization
  3. Execute AI translation (DeepL / Google / LLM)
  4. Auto-evaluate quality score
  5. Route below-threshold results to human review queue
  6. Register in TM and deploy upon approval
- **Translation Cache**: Prevent duplicate translation API calls for identical text

### Section 63: Multilingual Embedding & Semantic Search

- **Intl.Segmenter Usage**: Perform locale-aware text splitting and tokenization
- **Language Detection Accuracy**: Short texts (< 20 chars) have low language detection accuracy; fall back to user profile language setting
- **Multilingual Synonym Dictionary**: Maintain per-language synonym mappings for improved search accuracy

---

## Part XII: Mobile & Cross-Platform i18n

### Section 64: iOS/Android Platform-Specific i18n

- **iOS**:
  - Manage translations with `String Catalog` (Xcode 15+/16). Compiler-integrated automatic key extraction
  - Resource access via `Bundle.main.localizedString`
  - Declare supported languages in Info.plist `CFBundleLocalizations`
  - String Catalog per-platform translation variants (iOS/macOS/watchOS)
- **Android**:
  - Manage language resources in `res/values-{locale}/strings.xml`
  - Auto-size text with `android:autoSizeTextType`
  - `BCP 47` locale tag support (API 24+)
  - Per-app language preferences API (API 33+)
- **Common Principle**: Prioritize platform-native i18n mechanisms, avoid custom implementations

### Section 65: Flutter/React Native Multilingual Architecture

- **Flutter**: `flutter_localizations` package + `intl` package + ARB files
- **React Native**: `react-native-localize` + `i18next`/`react-intl` + JSON translation files
- **Kotlin Multiplatform**: Cross-platform translation resource sharing via `moko-resources`
- **OTA Updates**: Translation update strategy without app store resubmission via CodePush, etc.
- **RTL Layout**: React Native `I18nManager.forceRTL()` / Flutter `Directionality` widget

### Section 66: Mobile-Specific i18n Challenges

- **App Store Metadata**: Manage per-language titles, descriptions, and screenshots in App Store Connect / Google Play Console
- **Push Notification Multilingualization**: Switch notification templates based on user language settings via FCM/APNs
- **In-App Messaging**: Per-language in-app message template management
- **App Clips / Instant Apps**: Optimize limited i18n resource bundling

---

## Part XIII: Testing & Quality Assurance

### Section 67: i18n Test Automation

- **Pseudo-localization Testing**: Automatic rendering tests with pseudo-locales in CI/CD
- **Missing Key Tests**: Verify all translation keys in source code exist in translation files for all target languages
- **Variable Integrity Tests**: Verify placeholders (`{name}`, etc.) in translated text match the source language
- **ICU Message Syntax Validation**: Validate MessageFormat syntax correctness in CI
- **Translation Coverage Check**: Verify per-language translation coverage in CI

```bash
# CI/CD i18n testing example
npx i18n-check --source src/ --locales locales/ --fail-on-missing
npx messageformat-validator locales/**/*.json
```

### Section 68: VRT (Multilingual Visual Regression)

- **Multilingual VRT**: Screenshot comparison testing across all target languages for major screens
- **RTL VRT**: Layout comparison testing between LTR and RTL
- **Text Length Testing**: Layout breakage detection with longest-text languages (German, etc.)
- **Tools**: Chromatic / Percy / Playwright + screenshot comparison
- → See `700_qa_testing.md` for VRT details

### Section 69: Accessibility Testing (Multilingual)

- **Per-Language Screen Reader Testing**: Verify screen reader behavior in major languages
- **`lang` Attribute Verification**: Auto-check `lang` attribute settings on pages and inline language switches
- **WCAG 2.2 Multilingual Compliance**: Verify WCAG 2.2 AA criteria across all languages
  - WCAG 2.2 new criteria: Focus Appearance / Dragging Movements / Target Size / Consistent Help / Redundant Entry / Accessible Authentication
- **EAA Compliance**: EU market products must undergo EN 301 549-compliant accessibility testing
- → See `200_design_ux.md` for accessibility details

### Section 70: i18n-Specific E2E Tests

- **Locale Switch Testing**: Verify correct UI re-rendering on language switch via Playwright
- **Form Input Testing**: Test IME input, RTL text input, mixed full-width/half-width text
- **Date & Currency Display Testing**: E2E verification of per-locale formatting accuracy
- **Timezone Testing**: Event time display testing around DST transitions

### Section 71: LLMs.txt & AI Search Multilingual Testing

- **Multilingual LLMs.txt Verification**: Verify each language's LLMs.txt returns correct content
- **Structured Data Verification**: CI validation of multilingual JSON-LD variant correctness
- **AI Search Result Quality Testing**: Sample-verify multilingual query results across major AI search engines

---

## Part XIV: Security & Privacy Internationalization

### Section 72: International Cryptographic Regulation Differences

- **Encryption Strength Requirements**:
  - EU: eIDAS 2.0 compliance. QES (Qualified Electronic Signature) support
  - China: National cryptographic algorithm (SM2/SM3/SM4) usage requirements
  - Russia: GOST cryptographic standard usage requirements (certain scenarios)
- **Regional Encryption Key Management Policy**: Isolate encryption keys by region (e.g., EU keys managed in EU KMS)
- **Post-Quantum Crypto Agility**: Prepare for post-quantum cryptography migration. Track NIST PQC standards (ML-KEM/ML-DSA)
- → See `600_security_privacy.md` for cryptography details

### Section 73: Regional Cookie Consent Implementation

- **EU (GDPR/ePrivacy)**: TCF 2.2-compliant CMP (Consent Management Platform) implementation. Prior consent required
- **US (CCPA/State Laws)**: GPP (Global Privacy Platform) support. Opt-out link placement
- **Japan (APPI/Telecommunications Business Act)**: External transmission rule compliance. Notification/publication obligations
- **Technical Implementation**: Locale-specific CMP SDK initialization. Dynamic third-party script control based on consent state

### Section 74: Cross-Border Data Transfer Technical Controls

- **In-Transit Encryption**: TLS 1.3 required. Dedicated VPN/PrivateLink recommended for inter-region communication
- **At-Rest Encryption**: AES-256-GCM minimum. Encryption keys managed in target region's KMS
- **Tokenization**: Tokenize PII within region; only tokens cross borders (data minimization principle)
- **Pseudonymization**: GDPR Article 4(5)-compliant pseudonymization. Additional information (restoration keys) stored within EU

---

## Part XV: Observability & FinOps

### Section 75: i18n Observability

- **i18n-Specific Metrics**:

| Metric | Description | Target Value |
|---|---|---|
| Translation Coverage Rate | Per-language translated key percentage | Tier 1: 100%, Tier 2: 95%+ |
| Missing Key Rate | Frequency of untranslated key occurrence | 0 per build |
| LQA Score (MQM) | Translation quality score | 98+ out of 100 |
| Locale Error Rate | Formatting error occurrence rate | < 0.01% |
| Font Load Time | CJK font load completion time | < 1.5s |

- **Alert Configuration**: Trigger alerts when Missing Key Rate > 0 or Locale Error Rate > 0.1%
- **Dashboard**: Unified display of per-language translation status, quality scores, and performance metrics

### Section 76: Regional Cost Visibility & FinOps

- **CDN Costs**: Visualize per-region CDN transfer volume and costs
- **Translation Costs**: Track AI translation API call counts, costs, and human review costs monthly
- **Infrastructure Costs**: Per-region cost analysis of multi-region deployment
- **Cost Optimization Actions**:
  - Reduce CDN transfer volume via CJK font subset optimization
  - Reduce translation costs via TM reuse rate improvement
  - Right-size infrastructure based on per-region traffic

### Section 77: AI Translation Token Cost Management

- **Token Budget**: Set monthly AI translation token budgets per language pair
- **Cost Monitoring**: Real-time monitoring of LLM-based translation token consumption
- **Optimization**: Minimize API calls via translation cache and TM integration
- → See `101_revenue_monetization.md` for FinOps details

---

## Part XVI: Organization, Process & Maturity

### Section 78: Localization Maturity Model

| Level | Name | Characteristics | KPI Criteria |
|:---:|---|---|---|
| 1 | **Ad-Hoc** | Ad-hoc translation. Hardcoded strings remain. TZ not considered | Translation coverage < 50% |
| 2 | **Reactive** | Keys externalized. Major languages only. Manual translation | Coverage 50-80%, Missing Key > 10/month |
| 3 | **Proactive** | TMS adopted. CI/CD integration. Pseudo-localization. CLDR compliant | Coverage 95%+, MQM 95+, Missing Key < 5/month |
| 4 | **Strategic** | Full culturalization for all markets. Multi-region infra. Quantitative LQA | Coverage 100%, MQM 98+, Missing Key 0 |
| 5 | **Optimized** | AI translation+MTPE integration. Cross-lingual RAG. Real-time L10n. Continuous optimization | Above + AI translation COMET > 0.85 |

- **Target**: All projects MUST maintain Level 3 (Proactive) or above
- **Evaluation Frequency**: Evaluate maturity level quarterly
- **Promotion Trigger**: Re-evaluate maturity level on new market entry or Tier changes

### Section 79: Global Team Operations & Communication

- **Timezone Consideration**: Design asynchronous communication for global teams
  - Leverage "Golden Hours" (overlap in active hours for all members) for synchronous meetings
  - Document-driven (ADR, RFC, Wiki) asynchronous decision-making
- **Language Policy**: Define team working language (typically English) and leverage auto-translation tools
- **Cultural Diversity**: Communication guidelines respecting cultural backgrounds of global team members
- **i18n Champion**: Assign an i18n advocate to each development team. Responsible for i18n education and reviews

### Section 80: i18n Education & Knowledge Base

- **Onboarding**: Provide i18n best practices guide for new team members
- **Code Review Criteria**: Always flag i18n violations (hardcoded text, physical properties, string concatenation) in code reviews
- **Incident Database**: Accumulate i18n-related incident and improvement cases; share across the team
- **Regular Study Sessions**: Conduct i18n topic study sessions quarterly

---

## Appendix A: Quick Reference Index

| Technology / Service | Related Sections |
|---|---|
| ICU MessageFormat 2.0 | 6, 7, 67 |
| CLDR | 6, 7, 8, 9, 33 |
| Intl API (JavaScript) | 8, 9, 29 |
| Temporal API | 8 |
| CSS Logical Properties | 20 |
| BiDi / RTL | 20, 21, 22, 23, 24 |
| CJK Fonts | 25, 43 |
| UTF-8 / Unicode 16.0 | 26 |
| IME | 27 |
| Intl.Segmenter | 29, 63 |
| TMS (Translation Management System) | 13, 14, 16 |
| AI Translation / MTPE | 17, 60, 62 |
| CDN / Edge | 40, 43, 45 |
| Edge i18n / Middleware | 12, 40 |
| Multi-Region | 41, 42 |
| Sovereign Cloud | 3, 42 |
| Data Residency | 3, 42, 74 |
| Stripe / Payments | 46, 48, 52 |
| VAT / GST / DST | 47 |
| OSS / IOSS | 48 |
| hreflang / International SEO | 53, 56 |
| LLMs.txt / GEO | 54, 71 |
| LLM / RAG Multilingual | 58, 59, 60, 61 |
| Embedding / Semantic Search | 59, 63 |
| iOS / Android | 64 |
| Flutter / React Native | 65 |
| Kotlin Multiplatform | 65 |
| Pseudo-localization | 4, 67 |
| VRT (Visual Regression Testing) | 68 |
| Accessibility / EAA / WCAG 2.2 | 49, 69 |
| Cookie Consent / TCF 2.2 / GPP | 73 |
| Cryptographic Regulation / PQC | 72 |
| PCI DSS / SCA | 52 |
| DMA / EU Data Act | 49 |
| DSA / Content Moderation | 57 |
| i18n Observability | 75 |
| FinOps / Cost Management | 19, 76, 77 |
| E-Invoicing | 51 |

---

## Cross-References

| Rule File | Related Content |
|---|---|
| [100_product_strategy.md](../en/100_product_strategy.md) | Dynamic Pricing Metadata, Tier strategy |
| [101_revenue_monetization.md](../en/101_revenue_monetization.md) | Payments, currency, FinOps |
| [102_growth_marketing.md](../en/102_growth_marketing.md) | SEO/GEO, OGP, ASO |
| [200_design_ux.md](../en/200_design_ux.md) | Accessibility, IME, layout |
| [300_engineering_standards.md](../en/300_engineering_standards.md) | CI/CD, coding standards |
| [340_web_frontend.md](../en/340_web_frontend.md) | CSS architecture, performance |
| [341_headless_cms.md](../en/341_headless_cms.md) | Multilingual content management |
| [320_supabase_architecture.md](../en/320_supabase_architecture.md) | DB design, timezone |
| [400_ai_engineering.md](../en/400_ai_engineering.md) | AI/LLM, RAG |
| [502_site_reliability.md](../en/502_site_reliability.md) | Multi-region availability |
| [600_security_privacy.md](../en/600_security_privacy.md) | Data protection, encryption, crypto regulation |
| [601_data_governance.md](../en/601_data_governance.md) | GDPR, APPI, cross-border data, EU Data Act |
| [700_qa_testing.md](../en/700_qa_testing.md) | VRT, accessibility testing |
| [802_language_protocol.md](../en/802_language_protocol.md) | Language usage protocol, UI glossary |

### Cross-References

| Section | Related Rules |
|---------|---------------|
| §1–§5 (i18n Architecture) | `300_engineering_standards`, `340_web_frontend` |
| §6–§9 (Locale & Formatting) | `200_design_ux` |
| §17 (AI Translation) | `400_ai_engineering` |
| §20–§24 (BiDi / RTL) | `200_design_ux`, `342_mobile_flutter` |
| §40–§42 (Edge / Multi-Region) | `361_aws_cloud`, `360_firebase_gcp` |
| §46–§48 (Payments / Tax) | `101_revenue_monetization`, `103_appstore_compliance` |
| §53–§56 (International SEO) | `102_growth_marketing` |
| §58–§61 (LLM Multilingual) | `400_ai_engineering` |
| §64–§65 (Mobile i18n) | `342_mobile_flutter`, `343_native_platforms` |
| §74 (Data Residency) | `601_data_governance`, `600_security_privacy` |
