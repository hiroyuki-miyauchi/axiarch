# 71. Global Expansion & Internationalization (i18n)

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Revision Date: 2026-03-28 | Version 6.0 — Technology Update (Temporal Stage 4 / CLDR 49 / Unicode 18.0 / next-intl 4.0)

> [!IMPORTANT]
> **Supreme Directive**
> "Internationalization is not translation — it is architectural respect for every user's culture."
> All i18n decisions MUST prioritize cultural accuracy, architectural extensibility, and user trust.
> **Cultural Accuracy > Functional Parity > Performance > Speed** — Enforce this priority hierarchy strictly.
> **25 Parts, 114 Sections structure.**

---

## Table of Contents

- [Part I: Global Expansion Strategy Foundation](#part-i-global-expansion-strategy-foundation)
- [Part II: Internationalization (i18n) Architecture](#part-ii-internationalization-i18n-architecture)
- [Part III: Localization (L10n) Foundation](#part-iii-localization-l10n-foundation)
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
- [Part XVI: Microcopy & UX Writing Internationalization](#part-xvi-microcopy--ux-writing-internationalization)
- [Part XVII: Design System & Design Token Internationalization](#part-xvii-design-system--design-token-internationalization)
- [Part XVIII: Voice & Multimodal i18n](#part-xviii-voice--multimodal-i18n)
- [Part XIX: Language-Specific — CJK](#part-xix-language-specific--cjk)
- [Part XX: Language-Specific — RTL](#part-xx-language-specific--rtl)
- [Part XXI: Language-Specific — South & Southeast Asia](#part-xxi-language-specific--south--southeast-asia)
- [Part XXII: Language-Specific — European Languages](#part-xxii-language-specific--european-languages)
- [Part XXIII: Language-Specific — LATAM, Africa & Emerging Markets](#part-xxiii-language-specific--latam-africa--emerging-markets)
- [Part XXIV: 30 Anti-Patterns](#part-xxiv-30-anti-patterns)
- [Part XXV: Organization, Process & Maturity](#part-xxv-organization-process--maturity)
- [Appendix A: Reverse Lookup Index](#appendix-a-reverse-lookup-index)
- [Appendix B: Cross-References](#appendix-b-cross-references)

---

## Part I: Global Expansion Strategy Foundation

### Section 1: Global Expansion Philosophy & Principles

- **i18n-First Principle**: i18n MUST be built into the architecture from Day 1. Retrofitting is the #1 cause of technical debt
- **L10n ≠ Translation**: Localization is not translation. It is a comprehensive process including cultural adaptation, legal adaptation, and technical adaptation
- **Priority Hierarchy**:
  1. **Functional Accuracy**: Accurate display of data (currency, dates, numbers)
  2. **Legal Compliance**: Adherence to regional regulations (GDPR, CCPA, Global Privacy Laws, etc.)
  3. **Cultural Appropriateness**: Elimination of culturally inappropriate expressions/designs
  4. **Linguistic Quality**: Natural translations, accurate terminology
- **Locale-Agnostic Code**: Business logic MUST NOT depend on locale. Locale-dependent processing is confined to UI/formatting layers
- **AI-Ready i18n**: Translation resource files MUST be structured for LLM parsing. Attach context metadata, enforce consistent naming conventions

### Section 2: Market Tier Strategy & GTM

- **Tier Classification**:

| Tier | Example Regions | Strategy | Investment Criteria |
|---|---|---|---|
| Tier 1 (Highest Priority) | North America, Japan, Western Europe, Australia | Full culturalization, marketing focus | High ARPU, mature regulations |
| Tier 2 (Growth Markets) | Southeast Asia, South America, India | Viral growth, lightweight, low-bandwidth optimized | User growth, mobile-first |
| Tier 3 (Watch) | Africa, Middle East, Central Asia | Minimal i18n, market monitoring | Future potential assessment |

- **Dynamic Pricing Metadata**: Per-country pricing and feature restrictions MUST be controlled via **Stripe Metadata**, not in-code branching → `100_product_strategy.md`
- **Tier Promotion Criteria**: MAU growth > 20%/month, ARPU > 50% of global average, regulatory stability

### Section 3: Data Sovereignty & Residency Strategy

- **Data Sovereignty Mapping**:

| Region | Key Regulation | Data Storage Requirement | Action Item |
|---|---|---|---|
| EU | GDPR, EU Data Act (Sep 2025 enforcement) | EU servers in principle | SCC/BCR, Sovereign Cloud consideration |
| China | PIPL, Cross-Border Data Transfer Assessment | Domestic server mandatory, ICP required | Local partner alliance |
| Russia | Federal Law No. 242-FZ | Russia-domestic storage mandatory | Local DC deployment |
| India | DPDPA 2023 | Critical personal data cross-border restrictions | Data classification, DPIA execution |
| South Korea | PIPA | Appropriate safeguard obligations | Regional encryption policies |
| Brazil | LGPD | Adequate protection level required | International transfer agreements |
| Saudi Arabia | PDPL (2024 enforcement) | In-region processing principle, cross-border restrictions | Local infra build |

- **Sovereign Cloud Adoption**: Use AWS European Sovereign Cloud / Azure Sovereign Cloud / GCP Sovereign Cloud for strict sovereignty requirements
- **Data Flow Diagrams**: Document **all paths** where data crosses borders, annotate legal basis. Annual review mandatory
- → See `601_data_governance.md` for data residency details

---

## Part II: Internationalization (i18n) Architecture

### Section 4: Day 1 i18n Architecture

- **Hardcoding Strictly Prohibited**: Hardcoding UI text (buttons, labels, placeholders, error messages, tooltips, aria-labels) is **absolutely forbidden**
- **Externalization Mandatory**: All translatable text MUST be managed in key-value external resource files (`en.json`, `ja.json`, etc.)
- **Pseudo-localization**:
  - Test with pseudo-locale during development (e.g., `Account` → `[!!! Àççôûñţ !!!]`)
  - **Detection targets**: Hardcoded strings, layout breakage (30-40% text expansion tolerance), encoding issues
  - **CI Integration**: Embed pseudo-localization tests in CI/CD pipeline for automatic hardcode detection

```javascript
// ❌ Prohibited: Hardcoded
const label = "Enter your name";

// ✅ Correct: Externalized
const label = t('form.name.placeholder');
```

### Section 5: Translation Key Design & Namespace Management

- **Namespace Design**: Split by feature/page (`common`, `auth`, `error`, `admin`, `settings`)
- **Naming Convention**: Dot-separated, max 3 levels, English snake_case (`auth.login.submit_button`)
- **Context Annotation**: Same text in different contexts MUST have separate keys
- **AI-Ready Metadata**: Attach context, max character count, screenshot links as metadata per key
- **Prohibited**: Do not use translated text as keys. Dynamic key generation (`t(\`error.${code}\`)`) prohibited
- **W3C String-Meta Compliance**: Design structures that can attach language and direction metadata to all fields containing natural language text

### Section 6: ICU MessageFormat 2.0 & CLDR 48/49 Integration

- **ICU MessageFormat 2.0 Adoption**: Stabilized in CLDR 47 / ICU 77. CLDR 48.2 (March 17, 2026 Stable release) stabilized combined formatters
- **CLDR Usage Mandatory**: Custom implementations for date/time/number/currency formatting are prohibited. Use CLDR data
- **CLDR 48/48.2 Key Features**:
  - Rational number formatting (e.g., `5½`) — Tech Preview
  - Combined relative date+time formatting (e.g., `tomorrow at 12:30`)
  - New units: coulomb, farad, tesla, fortnight, imperial pint
  - Timezone `usesMetazone` gains `stdOffset`/`dstOffset` attributes
- **CLDR 49** (April 2026 release expected):
  - **H24 Deprecation**: H24 will exhibit H23 behavior going forward. Mandatory review of time format codes
  - **Pre-Meiji Japanese Era Removal**: Pre-Meiji era data removed (Gregorian dates are conventional). Impact assessment required for Japanese era code
  - **XML/JSON File Reorganization**: More logical file splitting. Improved data filtering and maintenance
- **ICU 79** (October 2026 release expected): CLDR 49 + Unicode 18.0 support. MF 2.0 Java implementation expected to promote from Draft→Stable
- **MF 2.0 Implementation Status**:
  - **Java**: CLDR 48 level. Core API at Draft status
  - **C++**: CLDR 47 level. Tech Preview
  - **JavaScript**: Tech Preview implementation available
- **MF 1.0→2.0 Migration**: New code MUST use MF 2.0. Existing code: quarterly migration plan execution

```
// MessageFormat 2.0 Syntax Example
.local $count = {$itemCount :number}
.match $count
one {{You have {$count} item in your cart.}}
*   {{You have {$count} items in your cart.}}
```

### Section 7: Plurals, Gender & Grammar Rules

- **CLDR Plural Rules Mandatory**: Custom plural logic is prohibited. Use CLDR plural categories (zero/one/two/few/many/other)
- **Language-Specific Category Count**: English: 2, Arabic: 6, Japanese: 1, Polish: 4
- **Gender Support**: Messages involving person references MUST use MF 2.0 `.match` directive for gender branching
- **Ordinal Support**: Rankings MUST also follow CLDR ordinal rules

### Section 8: Date, Time & Calendar Systems

- **Intl.DateTimeFormat Mandatory**: Locale-aware automatic formatting for dates and times
- **Temporal API — TC39 Stage 4 Achieved (March 2026)**:
  - **Status**: **Officially integrated** into ECMAScript 2026 spec. Stage 4 reached after 9 years of development
  - **Browser Support**:

  | Engine | Version | Release | Status |
  |---|---|---|---|
  | Firefox | 139+ | May 2025 | ✅ GA |
  | Chrome / Edge | 144+ | Jan 2026 | ✅ GA |
  | Safari | Technology Preview | — | ⚠️ Partial |
  | Node.js | v26+ | 2026 expected | ✅ GA expected |
  | TypeScript | 6.0 Beta+ | Feb 2026 | ✅ Built-in types |

  - **Adoption Roadmap**:
    - **Immediate**: Temporal usage **mandatory** in new code. Ban new usage of legacy `Date`
    - **2026 Q4 Target**: Complete migration of existing code to Temporal
  - **Polyfill Phase-out**: Begin gradual removal of `@js-temporal/polyfill` as major browsers now support natively
- **ECMA-402 13th Edition (2026)**: ECMAScript 2026 Internationalization API Specification. Leverage Intl API extensions accompanying Temporal integration
- **Calendar System Support**: Japanese era, Buddhist, Hijri, Minguo calendars. Note CLDR 49 pre-Meiji era removal
- **Relative Time**: Use `Intl.RelativeTimeFormat`. Leverage CLDR 48 combined formatters
- **Week Start Day**: Account for locale differences (Sunday/Monday/Saturday)

```javascript
// ✅ Temporal API (Mandatory — ECMAScript 2026 Standard, Stage 4)
const zdt = Temporal.ZonedDateTime.from({
  timeZone: 'America/New_York',
  year: 2026, month: 3, day: 28, hour: 17,
});
// ✅ Temporal.PlainDate (no timezone needed)
const date = Temporal.PlainDate.from('2026-03-28');
```

### Section 9: Number, Currency & Measurement Unit Formatting

- **Currency Object Mandatory**: `{ amount: 1000, currency: 'JPY' }` — Designs that don't separate amount and currency are prohibited
- **Intl.NumberFormat Mandatory**: Use for numeric and currency display formatting
- **Decimal Handling**: Process decimal places per currency based on CLDR (JPY: 0, USD: 2, BHD: 3)
- **Measurement Units**: Use `Intl.NumberFormat` `unit` option for locale adaptation
- **Large Numbers**: Use `notation: 'compact'` for locale-specific compact notation

### Section 10: String Concatenation Ban & Contextual Messages

- **String Concatenation Absolutely Prohibited**: Translations break due to word order differences (SOV vs SVO)
- **Placeholder Approach**: Use `{name}` for variable interpolation
- **HTML in Translations Prohibited**: Use MF 2.0 markup features or component splitting for rich text

### Section 11: Resource File Management & Bundle Optimization

- **File Splitting Criteria**: Split by page/feature. Max ~500 keys per file
- **Lazy Loading**: Dynamically load only required Namespaces on navigation
- **Fallback Chain**: `ja-JP` → `ja` → `en` (default language)
- **Translation File Immutability**: Key deletion after Deprecated marking, executed after 2 release cycles
- **RSC Integration**: Translations in React Server Components resolved server-side. No translation JSON in client bundles
- **Tree-shaking**: Configure automatic exclusion of unused Namespaces at build time

### Section 12: Framework-Specific i18n Implementation

- **Next.js App Router**: `next-intl` v4.0+ (March 2025 GA) as standard library
  - `app/[locale]/` subpath routing
  - Middleware for locale detection and redirect
  - Server Component translations: zero bytes in client bundle
  - `createNextIntlPlugin` for configuration integration
  - **v4.0 New Features**:
    - **Strictly Typed Locales**: `hasLocale` function for locale type narrowing. `Locale` type import
    - **Strictly Typed ICU Arguments**: Type-safe ICU arguments. IDE autocomplete support (opt-in)
    - **ESM-only Distribution**: Improved tree-shaking (`next-intl/plugin` exception)
    - **GDPR Compliance**: Proper cookie expiration control
    - **PPR/dynamicIO Prep**: `NextIntlClientProvider` required, `await requestLocale`
- **React**: `react-intl` (FormatJS) or i18next ecosystem
- **Vue**: `vue-i18n` v10+
- **Edge i18n Processing**: Complete locale detection, redirects, and dynamic content generation at Edge Middleware/Cloudflare Workers

```javascript
// Next.js Middleware Locale Detection Example
export function middleware(request) {
  const locale = request.headers.get('accept-language')?.split(',')[0]?.split('-')[0] || 'en';
  const supportedLocales = ['ja', 'en', 'ko', 'zh'];
  const resolved = supportedLocales.includes(locale) ? locale : 'en';
  // ...redirect logic
}
```

---

## Part III: Localization (L10n) Foundation

### Section 13: Translation Management System (TMS) Integration

- **TMS Adoption Threshold**: TMS adoption mandatory when expanding to 3+ languages
- **Recommended TMS**:

| TMS | Strength | Git Integration | MF 2.0 Support | AI Translation Integration |
|---|---|---|---|---|
| Crowdin | Community translation, large-scale | ✅ | ✅ | ✅ DeepL/Google/OpenAI |
| Lokalise | Developer-friendly, REST API | ✅ | ✅ | ✅ DeepL/Google |
| Phrase | Enterprise, TMS+Strings unified | ✅ | ✅ | ✅ In-house AI+external |

- **Required Features**: Direct Git repo integration, TM/Glossary support, MF 2.0 support, CLI/CI integration, branch-based workflows
- **OTA Translation Updates**: Design mobile apps for translation deployment without app store resubmission

### Section 14: Continuous Localization (CI/CD Integration)

- **Workflow**: Developer adds key → CI/CD detects new key, sends to TMS → Translator translates in TMS → Approved translation auto-merges via PR
- **Missing Key Detection**: Compare source code keys with translation files, auto-detect untranslated keys in CI, fail build
- **Translation Completion Gate**: Tier 1 languages: 100% required, Tier 2 languages: 95%+

```yaml
# CI/CD Pipeline Example
- name: i18n-check
  run: |
    npx i18n-check --source src/ --locales locales/ --fail-on-missing
    npx i18n-coverage --threshold 95 --tier1-threshold 100
```

### Section 15: Translation Quality Assurance (LQA & MTPE)

- **Machine-Translation-Only Release Prohibited**: All translated text MUST have native speaker review
- **MQM (Multidimensional Quality Metrics)**: Quantitative evaluation based on error classification. Pass threshold: **98+ points**
- **MTPE**: Light PE (UI label short text) / Full PE (marketing, legal documents)
- **Review Process**: Translator → Reviewer → Technical verification (3-stage)

### Section 16: Translation Memory, Glossary & Style Guide

- **TM Usage**: Reuse past translations for consistency and cost efficiency
- **Glossary Mandatory**: Define unified terminology per language. Explicitly list "do not translate" words
- **Style Guide**: Define tone, style, formality level per language
- **Glossary Git-Managed, PR Review Mandatory**

### Section 17: AI Translation Governance & Maturity Levels

- **AI Translation Usage Scope**:

| Use Case | AI Translation | Post-Edit | Native Review |
|---|:---:|:---:|:---:|
| UI labels, buttons | ✅ | ✅ Light PE | ✅ |
| Help, FAQ | ✅ | ✅ Full PE | ✅ |
| Marketing copy | ⚠️ Reference only | — | ✅ Write from scratch recommended |
| Legal documents, ToS | ❌ Prohibited | — | ✅ Legal review mandatory |
| UGC | ✅ Real-time | — | ❌ Not required |

- **Multi-Engine Routing**:
  - Single MT/LLM engine dependency prohibited. **Dynamically select** optimal engine based on content type, language pair, and context
  - Routing criteria: Language pair quality score → Content type suitability → Cost → Latency
  - Inter-engine A/B testing: Regular benchmarking via COMET/xCOMET scores

- **AI Translation Maturity Levels (L1-L5)**:

| Level | Name | Characteristics |
|:---:|---|---|
| L1 | Rule-Based | Rule-based MT. Limited quality |
| L2 | Neural MT | DeepL/Google NMT. MTPE mandatory |
| L3 | LLM-Assisted | GPT-4o/Claude. Improved context understanding |
| L4 | Adaptive | Project-specific TM/glossary-trained AI. Automated quality gate |
| L5 | Autonomous | Autonomous translation agents. Auto-deploy if quality > threshold. Humans do spot audits only |

- **Quality Monitoring**: Monthly baseline management via BLEU/COMET scores
- **Data Privacy**: PII removal/anonymization mandatory before sending to translation APIs

### Section 18: Global Content Governance

- **Establish regional content review workflows**
- **Content Localization Priority**: Legal documents > Critical UI > Marketing > Help Center
- **Translation-Prohibited Content**: Brand names, product names, trademarks retain original form

### Section 19: Translation ROI & Cost Optimization

- **Cost Optimization Strategy**: TM reuse rate 70%+, AI translation + Light PE for 50% UI label translation cost reduction, source content quality improvement

---

## Part IV: RTL & BiDi Support

### Section 20: CSS Logical Properties Mandate

- **Physical Properties Prohibited**: `left`/`right`/`margin-left`/`padding-right` usage banned
- **Logical Properties Mandatory**: `margin-inline-start`/`padding-inline-end`/`inset-inline-start`/`text-align: start`
- **Lint Enforcement**: ESLint/Stylelint auto-detection and error on physical properties

```css
/* ❌ Prohibited */
.sidebar { margin-left: 16px; text-align: left; }
/* ✅ Correct */
.sidebar { margin-inline-start: 16px; text-align: start; }
```

### Section 21: BiDi (Bidirectional Text) Control

- **`dir`/`lang` Attribute Setting**: `<html lang="ar" dir="rtl">`
- **Unicode BiDi Control Characters**: Proper use of LRM/RLM/LRE/RLE etc. in mixed text
- **`bdi` Element**: Isolate text with unknown direction (UGC etc.)
- **CSS `direction` Property Prohibited**: Control via HTML `dir` attribute (for a11y reasons)

### Section 22: RTL Test Automation

- **RTL Snapshot Testing**: Automatic screenshot capture and comparison for both LTR/RTL
- **Storybook RTL Decorator**: Standard equipment in component libraries
- **CI Checks**: Physical property lint, RTL layout VRT, BiDi text validation, form input RTL testing

### Section 23: Icon & Media Flip Rules

- **Must Flip**: Directional icons (arrows, forward/back, sliders, progress bars)
- **Must NOT Flip**: Real-world objects (clocks, checkmarks, play buttons), brand logos, mathematical symbols
- **CSS**: `[dir="rtl"] .icon-arrow { transform: scaleX(-1); }`

### Section 24: RTL Component Design Patterns

- **Flexbox/Grid RTL Auto-Adaptation**: `flex-direction: row` auto-reverses with `dir="rtl"`
- **Absolute Positioning**: Use `inset-inline-start`/`inset-inline-end`
- **Animation Direction**: Reverse slide-in/out directions in RTL environments

---

## Part V: CJK & Multi-Script Support

### Section 25: CJK Font Strategy

- **Font Subsetting Mandatory**: Split loading via `unicode-range` / Google Fonts `text=` parameter
- **Variable Fonts Recommended**: Flexible weight/width adjustment via CSS
- **Fallback Definition**: CJK → System fonts → Generic families
- **size-adjust**: Suppress layout shift during fallback
- **WOFF2 Mandatory**: Prioritize high-compression WOFF2 format. TTF/OTF/EOT deprecated

```css
font-family: 'Noto Sans JP', 'Hiragino Sans', 'Yu Gothic UI', 'Meiryo', sans-serif;
```

### Section 26: Character Encoding & Unicode 17.0 / 18.0

- **UTF-8 Unified**: UTF-8 as the sole encoding across the entire project
- **BOM Prohibited**: Do not use UTF-8 BOM
- **Unicode 17.0** (September 2025 released):
  - 4,803 new characters added (total 159,801)
  - 4 new scripts: Beria Erfe, Tolong Siki, Tai Yo, Sidetic
  - Emoji 17.0: 8 new emoji
  - **CJK Extension J**: 4,298 new CJK Unified Ideographs (CJK total exceeds 100,000)
  - Saudi Riyal currency sign addition
  - UTS #10 (Collation Algorithm) and UTS #39 (Security) synchronized updates
- **Unicode 18.0** (September 15, 2026 release expected):
  - **13,048 new characters added** (total 172,000+)
  - **4 new scripts**: Chisoi (includes new decimal digits), Jurchen (914 characters), Seal/Small Seal Script (11,328 characters), Proto-Cuneiform numerals (311 characters)
  - **Emoji 18.0**: 19 candidates (9 new concepts + 10 skin tone variations)
  - Additional CJK Unified Ideograph refinements
  - ICU 79 (October 2026) to include Unicode 18.0 support
- **Normalization**: Consistent NFC form usage
- **DB Collation**: `utf8mb4` (MySQL) or `C.UTF-8`/`ICU`

### Section 27: Input Method (IME) Support

- **`compositionstart`/`compositionend` Events**: Prohibit search/validation execution on uncommitted IME text
- **Text Field Design**: Account for IME candidate window overlap
- **`inputmode` Attribute**: Appropriate keyboard display on mobile
- **`virtualKeyboardPolicy` API**: Leverage on supported browsers
- → See `200_design_ux.md` for IME details

### Section 28: Vertical Writing, Ruby & Special Notation

- **Vertical Writing**: CSS `writing-mode: vertical-rl`
- **Ruby**: `<ruby>`/`<rt>` elements. `<rp>` fallback
- **Emphasis Marks**: Use `text-emphasis` property (not underlines)
- **Fullwidth/Halfwidth Normalization**: NFKC normalization
- **CJK Line Breaking**: `word-break: auto-phrase` (Chrome 130+). Fallback `overflow-wrap: anywhere`

### Section 29: Multi-Script Support

- **Indic Scripts**: Devanagari, Tamil, Bengali complex ligature and conjunct rendering
- **Arabic Shaping**: Context-dependent forms (isolated/initial/medial/final) accurate rendering
- **Thai/Khmer**: Word segmentation via `Intl.Segmenter`
- **Emoji**: Skin tone modifiers, ZWJ Sequences, Emoji 17.0 support

```javascript
// ✅ Intl.Segmenter Word Segmentation
const segmenter = new Intl.Segmenter('th', { granularity: 'word' });
```

---

## Part VI: Timezone, Calendar & Locale Management

### Section 30: UTC Storage & Local Conversion Principle

- **UTC Storage Mandatory**: Time storage in databases/backends is **UTC without exception**
- **Local Conversion Timing**: Convert only at the UI layer, immediately before user display
- **`timestamptz` Mandatory**: PostgreSQL MUST use `timestamptz`. `timestamp without time zone` prohibited

```sql
-- ❌ Prohibited
CREATE TABLE events (start_at TIMESTAMP);
-- ✅ Correct
CREATE TABLE events (start_at TIMESTAMPTZ DEFAULT NOW());
```

### Section 31: IANA Time Zone DB & DST Handling

- **IANA TZ DB Usage**: Timezone identifiers MUST follow IANA (`America/New_York`, `Europe/London`)
- **Fixed Offset Prohibited**: Storing/processing as `UTC+9` prohibited (no DST support)
- **DST Testing**: Always test Spring Forward (non-existent times) and Fall Back (duplicate times)
- **TZ DB Update Tracking**: Establish process for auto-tracking 2-4 annual IANA updates

### Section 32: Physical Location Exception Rules

- **Physical store hours** MUST be evaluated using the **store's timezone**, not the user's location
- **"Currently Open" Search**: Server-side determination using store location TZ

### Section 33: Calendar System Support

- **Supported**: Gregorian (standard), Japanese era, Buddhist, Hijri, Minguo
- **Intl API Usage**: `Intl.DateTimeFormat` `calendar` option
- **Week Start Day**: Based on CLDR `firstDay` data
- **Fiscal Year**: Varies by country (Japan: April, US: September/October)

### Section 34: Locale Detection & Configuration Management

- **Locale Priority Chain**: User setting > Accept-Language > Geo-IP > Default (en)
- **Locale Persistence**: Server-side storage (Cookie + DB)
- **Locale Switcher UI**: Accessible from all pages. Language names in native script (日本語, English, العربية)
- **BCP 47 Compliance**: `ja-JP`, `en-US`, `ar-SA` format
- **Unicode Locale Extension**: `-u-` subtag (RFC 6067) for locale-specific settings (calendar, numbering system, currency, etc.)

---

## Part VII: Cultural Adaptation & Culturalization

### Section 35: Color, Icon & Gesture Cultural Considerations

- **Color Cultural Meaning Differences**: Red (China: luck vs West: danger), White (Japan: purity+mourning vs West: purity), Green (Islam: sacred), Purple (Thailand: mourning)
- **Mitigation**: Avoid color-only meaning conveyance in global UI. Combine with icons and text
- **Gestures**: 👍 inappropriate in some cultures, 👌 offensive in Brazil. Regional verification required
- **Images/Photos**: Ensure model diversity. Avoid culturally biased imagery

### Section 36: Layout Expansion/Contraction

- **Text Length Variation**: EN→DE +30-40%, EN→JA character count decreases but character width increases, EN→ZH -30-50%
- **Design Principle**: Variable-length design (fixed-width prohibited), ellipsis as last resort, Flexbox/Grid, `min-width`/`max-width`
- **Testing**: Verify 30-40% text expansion via pseudo-localization

### Section 37: Name, Address & Phone Number Formatting

- **Name Diversity**: Family-given name order (JA/ZH/KO/HU), middle names, mononyms (Indonesia)
- **Design**: Use `full_name` field where possible. When split, display in locale-appropriate order
- **Address**: Google libaddressinput / CLDR territoryData compliance
- **Phone Numbers**: libphonenumber (Google) for validation. International prefix support

### Section 38: Legal & Regulatory Localization

- **Terms of Service / Privacy Policy**: Must be provided in target country language (GDPR Article 12, etc.)
- **Consent Mechanisms**: EU: explicit opt-in (TCF 2.2), US: opt-out (GPP), Japan: Global Privacy Laws compliant
- **Age Restrictions**: Country-specific minimum age management
- → See `601_data_governance.md`

### Section 39: Religion, Holidays & Calendar Events

- **Religious Considerations**: Suppress food ads during Ramadan, marketing self-restraint on religious holidays
- **Holiday Calendar**: Maintain country-specific holiday DB. Reflect in marketing/notification schedules
- **Seasonality**: Account for hemisphere season reversal
- **Calendar Notes**: Japanese Rokuyo, Chinese Lunar New Year, etc.

---

## Part VIII: Multi-Region Infrastructure & Performance

### Section 40: CDN & Edge Delivery Strategy

- **Multi-CDN Strategy**: Select optimal CDN per region (Asia: Cloudflare/Akamai, China: Alibaba Cloud CDN + ICP required)
- **Edge Computing**: Process locale detection, redirects, dynamic content generation at edge
- **Vary Header**: `Vary: Accept-Language` for language-specific cache separation

### Section 41: Multi-Region Deployment

- **Region-Agnostic Design**: Hardcoded region logic prohibited. Inject via environment variables
- **Data Replication**: Read → nearest read replica, Write → primary region
- **Failover**: Automatic regional failover (define RTO/RPO)
- **Canary Releases**: Gradual deployment per region

### Section 42: Data Residency Technical Implementation

- **Sovereign Cloud**: Use Sovereign Cloud for strict sovereignty requirements
- **Technical Controls**: Regional key management, PII auto-routing, logs/telemetry also subject to sovereignty requirements
- → See `601_data_governance.md`

### Section 43: Font & Image Performance Optimization

- **Fonts**: `font-display: swap`, Critical CSS `preload`, CJK `unicode-range` subset splitting
- **Images**: Serve regional banners from nearest CDN. Enhanced compression for Tier 2/3
- **AVIF/WebP**: Modern format optimization for global delivery

### Section 44: Global Performance Budget

| Metric | Tier 1 Target | Tier 2 Target | Tier 3 Target |
|---|---|---|---|
| LCP | < 2.5s | < 3.0s | < 4.0s |
| INP | < 200ms | < 300ms | < 500ms |
| CLS | < 0.1 | < 0.15 | < 0.2 |

- **Font Load Impact**: Quantitatively measure CJK font loading LCP impact. Subset splitting to < 1MB
- **Low-Bandwidth Simulation**: Conduct 3G/4G throttling tests

### Section 45: Network Resilience & Offline Support

- **Service Worker Offline i18n**: Pre-cache translation resources
- **Low-Bandwidth Optimization**: Brotli compression and differential updates for translation files
- **CDN Fallback**: Automatic switchover on primary CDN failure

---

## Part IX: Payments, Taxation & Compliance

### Section 46: Multi-Currency Payments & Exchange Management

- **Zero-Decimal Currencies**: JPY, KRW processing. Stripe smallest unit compliance
- **Exchange Rates**: Real-time retrieval. Ensure transparency between display and settlement rates
- **Regional Payment Methods**:

| Region | Primary Payment Methods | Priority |
|---|---|---|
| Japan | Credit cards, convenience store payments, PayPay | Required |
| China | WeChat Pay, Alipay | Required |
| EU | SEPA, iDEAL, Bancontact, Klarna | Required |
| India | UPI, RuPay | Required |
| Southeast Asia | GrabPay, DANA, GCash | Recommended |
| Brazil | Pix, Boleto | Recommended |

- → See `101_revenue_monetization.md`

### Section 47: International Taxation (VAT/GST/Consumption Tax)

- **Tax Rate Management**: Dynamic management via Stripe Tax
- **Display Requirements**: EU: Tax-inclusive B2C mandatory, US: Tax-exclusive common, Japan: Total price display mandatory
- **DST (Digital Services Tax)**: UK 2%, France 3%, Italy 3% (2025 threshold removal), Philippines 12% VAT (June 2025+)

### Section 48: EU OSS/IOSS & Cross-Border E-Commerce Taxation

- **OSS**: Single VAT filing for EU intra-community B2C cross-border sales (registration required above €10,000)
- **IOSS**: Single VAT filing for cross-border e-commerce goods under €150
- **Stripe Tax Integration**: Automated tax calculation for 100+ countries

### Section 49: Global Regulatory Compliance

- **EAA (European Accessibility Act)**: June 2025 enforcement. EN 301 549 compliance mandatory
- **DMA**: Gatekeeper data portability obligations
- **EU Data Act**: Full enforcement September 2025
- **EU AI Act**: Feb 2025 prohibited AI enforcement, Aug 2025 general-purpose AI rules, **Aug 2026 high-risk AI rules enforcement**. Multilingual AI output transparency obligation
- **Regulatory Checklist**: GDPR, CCPA/CPRA, Global Privacy Laws, PIPL, LGPD, PIPA, DPDPA, EAA, EU AI Act

### Section 50: Multilingual E-Invoicing

- **Japan**: Invoice system. Registration number, tax rate classification
- **EU**: EN 16931 compliance. Peppol BIS 3.0
- **Technical Implementation**: JSON/XML multilingual metadata

### Section 51: PCI DSS & International Payment Security

- **PCI DSS 4.0**: Full enforcement March 2025
- **SCA (Strong Customer Authentication)**: EU PSD2 compliance. 3D Secure 2.0 mandatory
- **Regional Requirements**: India (additional authentication), Brazil (CPF verification)

---

## Part X: SEO/GEO & Content Internationalization

### Section 52: International SEO

- **hreflang Implementation Mandatory**: `x-default` fallback, self-referencing, bidirectional links
- **URL Structure**: Subdirectory recommended (`example.com/ja/`). Subdomains not recommended
- **sitemap.xml**: Language-specific URLs + hreflang annotations
- **hreflang Audit Automation**: CI validation of bidirectionality, `x-default` presence, self-references

```html
<link rel="alternate" hreflang="ja" href="https://example.com/ja/page" />
<link rel="alternate" hreflang="en" href="https://example.com/en/page" />
<link rel="alternate" hreflang="x-default" href="https://example.com/en/page" />
```

### Section 53: GEO (AI Search Optimization) Multilingual Support

- **Multilingual Structured Data**: Language-specific JSON-LD provision
- **Multilingual LLMs.txt**: Prepare per-language files for AI search engines
- **Answer Engine Optimization**: FAQ structuring for Perplexity/ChatGPT Search/Google AI Overviews
- → See `102_growth_marketing.md`

### Section 54: Multilingual Content Strategy

- **Headless CMS Integration**: Language-variant management
- **Fallback**: `fr-CA` → `fr` → `en`
- **Content Freshness Sync**: Auto-detect translation staleness when source is updated
- → See `341_headless_cms.md`

### Section 55: Multilingual SEO Technical Debt Management

- **hreflang Audit**: Detect orphaned language pages, 404-pointing hreflang
- **Duplicate Content Detection**: Auto-detect untranslated pages across languages
- **Index Coverage**: Per-language monitoring via Google Search Console / Bing Webmaster Tools

### Section 56: International Content Moderation

- **Regional Policies**: EU DSA, German NetzDG, Japanese Provider Liability Limitation Act
- **Multilingual Moderation**: AI + human hybrid framework

---

## Part XI: AI/LLM Multilingual Support

### Section 57: LLM Prompt Internationalization

- **Multilingual Prompt Templates**: Manage system prompts and response templates per language
- **Language Detection & Response Control**: Guardrails to detect input language and respond in same language
- **Token Efficiency**: CJK languages consume 1.5-2x tokens vs English. Prompt compression, few-shot optimization
- **Language Pinning Guardrails**: Explicitly specify response language in system prompt. Prevent context document language bleed

```
System: You MUST respond in the same language as the user's query.
If the user writes in Japanese, respond in Japanese.
Never switch languages mid-response.
```

### Section 58: RAG Multilingual Knowledge Base

- **Multilingual Vector Index**: Build knowledge base with cross-lingual embedding models
- **Embedding Model Selection**:

| Model | Multilingual Support | Characteristics | Recommended Use |
|---|---|---|---|
| multilingual-e5-large-instruct | 100+ languages | MMTEB top-tier, instruction-tuned | Cross-lingual search |
| Cohere embed-v4 | 100+ languages | Commercial, high accuracy | Enterprise RAG |
| BGE-M3 | 100+ languages | Multi-Granularity | Hybrid search |

- **Cross-Lingual Search**: Design for retrieving documents in languages different from the query
- **Language-Specific Chunking**: CJK character-based, Western languages word-based
- **Language-Aware Reranking**: Penalize documents in different languages from query
- → See `400_ai_engineering.md`

### Section 59: Multilingual AI-Generated Content Quality Assurance

- **Hallucination Detection**: Factuality verification per language
- **Cultural Appropriateness Filter**: Guardrails for culturally inappropriate AI output
- **Quality Metrics & Evaluation Framework**:

| Metric | Purpose | Characteristics | Recommended Threshold |
|---|---|---|---|
| COMET | MT quality evaluation | Source+reference prediction of human judgment | ≥ 0.85 |
| xCOMET | COMET extended | Reference-free QE mode support | ≥ 0.80 |
| GEMBA | LLM-based evaluation | Uses GPT-4 as evaluator | Reference value |
| BLEU | Baseline | n-gram match rate. Not recommended standalone | ≥ 40 |
| BERTScore | Semantic similarity | Embedding-based evaluation | ≥ 0.90 |

- **COMET Limitations & Complementation**:
  - LLM translations may be fluent but not match reference translations, causing COMET underestimation risk
  - **Mitigation**: Combine with xCOMET (QE mode). Cross-validate critical content with GEMBA
  - **Low-Resource Languages**: COMET scores tend to degrade. Increase human review frequency
- **Output Language Validation**: Auto-verify AI responses are in specified language

### Section 60: LLM Multilingual Safety & Bias

- **Multilingual Jailbreak Countermeasures**: Prompt injection/jailbreak protection for non-English languages
- **Cross-Language Bias Detection**: Monitor quality differences across languages. Detect quality degradation in low-resource languages
- **Multilingual Harmful Content Filters**: Language-specific harmful expression and hate speech detection
- → See `600_security_privacy.md`

### Section 61: AI Translation Workflow Integration

- **Real-Time AI Translation Pipeline**: Source text → PII removal → AI translation → Auto quality scoring → Below threshold: human review → TM registration & deploy
- **Translation Cache**: Prevent duplicate translation API calls for identical text

### Section 62: Agentic AI Translation Agents

- **Autonomous Translation Agents**: Translation workflow automation via MCP/A2A protocol integration
  - Autonomous execution: content detection → translation → quality assessment → deployment
  - Automated integration with TMS, Git, CI/CD
- **Micro-Agent Design**: Ensure controllability with task-specialized micro-agents rather than a single monolithic agent
  - **Detection Agent**: Auto-detect new/updated content, add to translation queue
  - **Translation Agent**: Optimal engine selection by content type, glossary/TM reference, self-critique
  - **Quality Gate Agent**: COMET/xCOMET score auto-evaluation, human escalation on failure
- **Agent Permission Control**: Strict quality threshold for auto-deploy (COMET > 0.85 AND xCOMET > 0.80)
- **Human-in-the-Loop**: Marketing and legal documents MUST have human approval after agent translation
- **i18n Automation Agent**: Auto-detection of hardcoded strings, translation key conversion proposals
- **EU AI Act Compliance**: AI translation system risk classification and transparency obligations
- → See `400_ai_engineering.md` Agentic AI section

### Section 63: Multilingual Embedding & Semantic Search

- **Intl.Segmenter Usage**: Locale-aware text segmentation
- **Language Detection Accuracy**: Low accuracy for short text (< 20 chars). Fallback to user profile language setting
- **Multilingual Synonym Dictionaries**: Maintain per-language synonym mappings

---

## Part XII: Mobile & Cross-Platform i18n

### Section 64: iOS/Android-Specific i18n

- **iOS**: `String Catalog` (Xcode 15+/16). Compiler-integrated key auto-extraction. `CFBundleLocalizations` declaration
- **Android**: `res/values-{locale}/strings.xml`. `autoSizeTextType`. BCP 47 support (API 24+). Per-app language preferences (API 33+)
- **Common Principle**: Prefer platform-native i18n mechanisms

### Section 65: Flutter/React Native Multilingual Architecture

- **Flutter**: `flutter_localizations` + `intl` + ARB files
- **React Native**: `react-native-localize` + `i18next`/`react-intl` + JSON
- **KMP**: `moko-resources` cross-platform translation resource sharing
- **OTA Updates**: Translation deployment without app updates
- **RTL Layout**: React Native `I18nManager.forceRTL()` / Flutter `Directionality`

### Section 66: Mobile-Specific i18n Challenges

- **App Store Metadata**: Per-language title, description, screenshot management
- **Push Notification Multilingualization**: FCM/APNs template switching based on language setting
- **App Clips/Instant Apps**: Limited i18n resource bundle optimization

---

## Part XIII: Testing & Quality Assurance

### Section 67: i18n Test Automation

- **Pseudo-Localization Testing**: Automated rendering tests with pseudo-locales in CI/CD
- **Missing Key Testing**: Verify all translation keys exist in all target languages
- **Variable Consistency Testing**: Placeholders (`{name}`, etc.) match source language
- **ICU Message Syntax Validation**: MF syntax validity check in CI
- **Translation Coverage Check**: Per-language coverage validation

```bash
npx i18n-check --source src/ --locales locales/ --fail-on-missing
npx messageformat-validator locales/**/*.json
```

### Section 68: VRT (Multilingual Visual Regression)

- **Multilingual VRT**: Screenshot comparison tests across all target languages
- **RTL VRT**: Layout comparison between LTR/RTL
- **Text Length Testing**: Layout breakage detection with longest-text languages (German, etc.)
- **Tools**: Chromatic / Percy / Playwright
- → See `700_qa_testing.md`

### Section 69: Accessibility Testing (Multilingual)

- **Per-Language Screen Reader Testing**: Screen reader behavior verification for major languages
- **`lang` Attribute Validation**: Automated checks
- **WCAG 2.2 Multilingual Support**: AA compliance across all languages
- **EAA Compliance**: EN 301 549 compliance testing for EU markets
- → See `200_design_ux.md`

### Section 70: i18n-Specific E2E Testing

- **Locale Switching Test**: Full UI re-render validation with Playwright
- **Form Input Testing**: IME, RTL, fullwidth/halfwidth mixed input testing
- **Date/Currency Display Testing**: Locale-specific format accuracy
- **Timezone Testing**: Event time display before/after DST transitions

### Section 71: LLMs.txt & AI Search Multilingual Testing

- **Multilingual LLMs.txt Verification**: Verify accurate content delivery per language
- **Structured Data Verification**: CI validation of JSON-LD multilingual variants
- **AI Search Result Quality**: Sampling verification on major AI search engines

---

## Part XIV: Security & Privacy Internationalization

### Section 72: International Cryptographic Regulation Differences

- **Encryption Strength Requirements**: EU eIDAS 2.0, China SM2/SM3/SM4, Russia GOST
- **Regional Key Management Policies**: EU keys managed in EU-region KMS, etc.
- **PQC Preparation**: Track NIST PQC Standards (ML-KEM/ML-DSA)
- → See `600_security_privacy.md`

### Section 73: Regional Cookie Consent Implementation

- **EU**: TCF 2.2 compliant CMP. Prior consent mandatory
- **US**: GPP support. Opt-out links
- **Japan**: Global Privacy Laws/Applicable Regional Telecommunications Law compliance. External transmission regulations
- **Technical Implementation**: Locale-specific CMP SDK initialization. Dynamic script control based on consent state

### Section 74: Cross-Border Data Transfer Technical Controls

- **In-Transit Encryption**: TLS 1.3 mandatory. VPN/PrivateLink recommended for inter-region
- **At-Rest Encryption**: AES-256-GCM minimum. Managed via target region KMS
- **Tokenization**: Tokenize PII within region, only tokens cross borders
- **Pseudonymization**: GDPR Article 4(5) compliant. Recovery keys stored in EU

### Section 75: EU AI Act i18n Impact

- **Multilingual AI Transparency**: Under EU AI Act, AI systems with multilingual output MUST provide transparency disclosures in all languages
- **High-Risk AI (Aug 2026+)**: High-risk AI systems with multilingual UIs MUST provide risk and technical documentation in all target languages
- **AI Literacy Obligation (Feb 2025+)**: Provide multilingual training materials for AI users
- **GPAI (Aug 2025+)**: Prepare training data summaries in multiple languages for general-purpose AI models
- → See `400_ai_engineering.md` EU AI Act section

---

## Part XV: Observability & FinOps

### Section 76: i18n Observability

| Metric | Description | Target |
|---|---|---|
| Translation Coverage Rate | Translated key ratio per language | Tier 1: 100%, Tier 2: 95%+ |
| Missing Key Rate | Untranslated key occurrence frequency | 0/build |
| LQA Score (MQM) | Translation quality score | 98+ points |
| Locale Error Rate | Format error occurrence rate | < 0.01% |
| Font Load Time | CJK font load completion time | < 1.5s |

- **Alerts**: Trigger on Missing Key Rate > 0 or Locale Error Rate > 0.1%
- **Dashboard**: Unified view of per-language translation status, quality, and performance

### Section 77: Regional Cost Visibility & FinOps

- **CDN Costs**: Per-region transfer volume and cost visibility
- **Translation Costs**: Monthly tracking of AI translation API and human review costs
- **Infrastructure Costs**: Multi-region per-region cost analysis
- **Optimization**: CJK font subset optimization, TM reuse rate improvement, per-region right-sizing

### Section 78: AI Translation Token Cost Management

- **Token Budgets**: Monthly allocation per language pair
- **Cost Monitoring**: Real-time LLM translation token consumption monitoring
- **Optimization**: Minimize API calls via translation cache and TM integration
- → See `720_cloud_finops.md`

---

## Part XVI: Microcopy & UX Writing Internationalization

### Section 79: Microcopy Translation Strategy

- **Microcopy Definition**: Short UI text — button labels, tooltips, error messages, empty states, confirmation dialogs
- **Context-Dependent Translation**: Same word translates differently by location (e.g., "Save" → button: 保存 vs menu: 保存する)
- **Character Constraints**: Microcopy has strict space constraints. Specify per-language max character counts in metadata
- **Tone & Voice**: Establish per-language brand tone guidelines. Formality levels (Japanese honorifics, German Sie/Du, etc.)

### Section 80: Error Message & Validation Internationalization

- **Error Message Structure**: Error code + localized message + resolution action
- **Validation Messages**: Locale-aware. Regex patterns also per-region (phone numbers, postal codes, etc.)
- **User-Facing Language**: No technical jargon. User-friendly expressions in each language

### Section 81: Empty State & Onboarding Internationalization

- **Empty State Text**: Prepare appropriate illustrations and copy per language. Culturally appropriate expressions
- **Onboarding Flow**: Per-locale step optimization. Reflect legal requirement differences (EU: GDPR consent step, etc.)
- **Tooltips & Help Text**: Variable-width design for text length variation

---

## Part XVII: Design System & Design Token Internationalization

### Section 82: Design Token i18n Support

- **Direction Tokens**: Logical spacing with `spacing-inline-start` / `spacing-inline-end`
- **Typography Tokens**: Per-language font family, line-height, letter-spacing definitions
  - Japanese: `line-height: 1.8`, Western: `line-height: 1.5`
  - Arabic: `letter-spacing: 0` (no kerning needed)
- **Size Tokens**: CJK characters appear visually larger at same font size — per-language fine-tuning

### Section 83: Component Library i18n Support

- **RTL-Ready Components**: All components MUST be BiDi-ready
- **Text Length Adaptation**: `min-width`/`max-width` tokens, truncation strategy definitions
- **Icon Flip Rules**: Per-component flip/no-flip flags
- **Storybook Locale Decorator**: Multilingual/RTL preview available for all components

### Section 84: Theme & Color Scheme Cultural Adaptation

- **Culture-Specific Color Variants**: Regional theme tokens where needed
- **Dark Mode**: WCAG AA contrast ratio compliance across all languages
- **Semantic Colors**: Design culturally neutral color meanings (don't hardcode success=green, etc.)

---

## Part XVIII: Voice & Multimodal i18n

### Section 85: Voice UI (VUI) Multilingual Support

- **ASR (Speech Recognition)**: Per-language model selection, dialect support (English: US/UK/AU, Chinese: Mandarin/Cantonese)
- **TTS (Speech Synthesis)**: Per-language natural voice generation. Account for regional pitch/speed differences
- **Wake Words**: Per-language wake word design. False positive testing
- **Voice Fallback**: Text input fallback on ASR accuracy degradation

### Section 86: Multimodal AI Multilingual Support

- **Image Text Recognition (OCR)**: Multi-script OCR. CJK, Arabic, Indic support
- **Video Subtitles & Audio Translation**: Real-time multilingual subtitle generation and audio translation
- **Image Generation AI**: Cultural appropriateness of generated images. Multilingual text rendering quality
- → See `400_ai_engineering.md` multimodal section

### Section 87: Conversational AI & Chatbot Internationalization

- **Multilingual Chatbot**: Language detection → auto language switching → cultural appropriateness filtering
- **Conversation Design**: Per-language conversation flow design (Japanese: polite form base, English: casual acceptable, etc.)
- **Real-Time Translation Support**: Cross-language conversation support between users and agents

---

## Part XIX: Language-Specific — CJK

### Section 88: Japanese-Specific Implementation Requirements

- **Honorific Level Management**: Unify UI honorific levels (teineigo, sonkeigo, kenjougo). Define in style guide
- **Japanese Era Support**: Systematically handle era changes (`Reiwa`, `Heisei`). Leverage `Intl.DateTimeFormat` `era` option
- **Fullwidth/Halfwidth Normalization**: Normalize fullwidth alphanumeric and halfwidth katakana input. Use `String.prototype.normalize('NFKC')`
- **Furigana (Reading)**: Standard furigana field in name input forms
- **Japanese Search**: Morphological analysis (MeCab/Kuromoji) for accurate tokenization. Okurigana variation handling
- **Address Format**: 〒Postal code → Prefecture → City → Street → Building (reverse international format also supported)
- **Invoice System**: Qualified Invoice Issuer Registration Number (T+13 digits) display and validation
- **Phone Numbers**: 0AB-J format (landline), 090/080/070 (mobile) validation. `+81` prefix conversion

### Section 89: Chinese (Simplified & Traditional) Specific Requirements

- **Simplified/Traditional Separation**: `zh-CN` (Simplified) and `zh-TW`/`zh-HK` (Traditional) treated as separate languages. No auto-conversion dependency
- **Mainland China Specific**: ICP number display obligation, Great Firewall compliance, Alipay/WeChat Pay integration
- **Taiwan/Hong Kong Specific**: Regional Traditional character differences (Taiwan zhengti vs Hong Kong fantizi). Minguo calendar
- **Chinese Fonts**: `Noto Sans SC`/`Noto Sans TC` primary. `PingFang SC`/`Microsoft YaHei` fallback
- **Chinese Input**: Pinyin, Zhuyin (BoPoMoFo), Cangjie input method considerations
- **PIPL Compliance**: Domestic storage obligation for Chinese user personal data. Cross-border transfer assessment

### Section 90: Korean-Specific Requirements

- **Hangul Composition**: Initial/medial/final consonant combination processing. Choseong (initial consonant) search support
- **Particle Variation**: Particle changes based on presence of final consonant (patchim): 은/는, 이/가, 을/를. Programmatic processing required
- **Korean Fonts**: `Noto Sans KR` primary. `Malgun Gothic`/`Apple SD Gothic Neo` fallback
- **PIPA Compliance**: Korean Personal Information Protection Act. Strict consent requirements
- **RRN (Resident Registration Number)**: Collection restrictions. Alternative authentication (PASS certification, etc.)
- **Korean Won Display**: Zero-decimal currency. `₩` symbol prefix

---

## Part XX: Language-Specific — RTL

### Section 91: Arabic-Specific Requirements

- **Arabic Character Shaping**: Context-dependent form (isolated/initial/medial/final) rendering guarantee
- **Tashkeel (Vowel Marks)**: Accurate short vowel mark placement. Ignore marks for search normalization
- **Arabic Numerals**: Eastern Arabic numerals (٠١٢) vs Arabic numerals (012) selection. Respect regional conventions
- **Kashida Justification**: Accurate Kashida insertion for text justification
- **Hijri Calendar**: Islamic calendar support. `Intl.DateTimeFormat` with `calendar: 'islamic'`
- **Arabic Plurals**: 6 forms (zero/one/two/few/many/other) support. CLDR compliance mandatory
- **Dialect Differences**: MSA (Modern Standard Arabic) base, but consider Egyptian, Levantine, Gulf dialect terminology

### Section 92: Hebrew-Specific Requirements

- **Nikkud (Vowel Marks)**: Technical documents typically omit Nikkud. Guarantee accurate placement when needed
- **Hebrew Calendar**: `Intl.DateTimeFormat` with `calendar: 'hebrew'`
- **Numbers/Currency**: New Shekel (₪ NIS). Display in LTR

### Section 93: Persian (Farsi) Specific Requirements

- **Persian Numerals**: ۰۱۲۳ (different code points from Arabic Eastern numerals)
- **Iranian Calendar (Jalali/Solar Hijri)**: `Intl.DateTimeFormat` with `calendar: 'persian'`
- **Persian Keyboard**: Account for differences from Arabic keyboard (additional characters: پ, چ, ژ, گ)

### Section 94: Urdu-Specific Requirements

- **Nastaliq Script**: Urdu standard script is Nastaliq. Differentiate from Naskh usage
- **Urdu Numerals**: Same system as Persian numerals. Use `۰۱۲۳`
- **Pakistan Regulations**: PTA (Pakistan Telecommunication Authority) content regulation compliance

---

## Part XXI: Language-Specific — South & Southeast Asia

### Section 95: Hindi & Indic Scripts

- **Devanagari**: Accurate rendering of conjuncts and ligatures
- **Hindi Numerals**: `०१२३` Devanagari numerals. User-configurable switching
- **Hindi Fonts**: `Noto Sans Devanagari` primary. Subset optimization
- **India's Multilingualism**: 22 official languages. Monitor `Intl.Segmenter` support status
- **DPDPA 2023 Compliance**: India Digital Personal Data Protection Act. Consent management, data localization

### Section 96: Thai

- **No Word Boundaries**: Thai has no space-separated words. `Intl.Segmenter` mandatory
- **Thai Sorting**: Complex Thai dictionary order. Leverage ICU Collation
- **Buddhist Calendar**: Gregorian + 543. `Intl.DateTimeFormat` with `calendar: 'buddhist'`
- **Thai Numerals**: `๐๑๒๓` available (user-configurable switching)
- **PDPA (Thailand Personal Data Protection Act)**: 2022 enforcement. Consent management obligation

### Section 97: Vietnamese

- **Tone Marks**: Accurate rendering of 5 tone marks. NFC normalization mandatory
- **Vietnamese Fonts**: Latin alphabet base but requires tone mark-compatible fonts
- **Vietnamese Address**: Province/Municipality → District → Ward → Street number hierarchy

### Section 98: Indonesian & Malay

- **Common Base**: High similarity between Indonesian and Malay. However, shared translations not recommended (vocabulary/spelling differences)
- **Mononym Culture**: Mononyms common in Indonesia. Flexible name form design (surname field optional)
- **Latin Alphabet**: Few special characters, minimal font challenges

---

## Part XXII: Language-Specific — European Languages

### Section 99: German-Specific Requirements

- **Text Length Expansion**: +30-40% vs English. Most critical test language for UI layout design
- **Compound Nouns**: Extremely long compound words occur (e.g., Donaudampfschifffahrt). `overflow-wrap: anywhere` mandatory
- **Capitalization**: Nouns always capitalized. Caution with `text-transform` usage
- **Eszett (ß)**: Uppercases to `SS`. Unicode 5.1+ `ẞ` (capital Eszett) processing
- **Formality**: Sie/Du distinction. Formality level differences in B2C vs B2B
- **Number Format**: Decimal `,` (comma), thousands `.` (period). Reversed vs English

### Section 100: French-Specific Requirements

- **French Variants**: Metropolitan France (`fr-FR`) and Canada (`fr-CA`) vocabulary/spelling differences
- **Pre-Punctuation Space**: Narrow no-break space (U+202F) before `!`, `?`, `:`. CSS `white-space` handling
- **Elision/Liaison**: Translation quality check items
- **Grammatical Gender**: Article gender agreement with product/feature names

### Section 101: Spanish-Specific Requirements

- **Spanish Variants**: Spain (`es-ES`) and Latin America (`es-419`/`es-MX`) significant vocabulary differences
- **Inverted Question/Exclamation Marks**: Accurate `¿` and `¡` usage
- **Vos/Tú/Usted**: Regional formality distinctions. Variations even within Latin America
- **LGPD Compliance**: Data protection for Brazilian Portuguese markets

### Section 102: Italian, Portuguese & Other Languages

- **Italian**: Text expansion +15-20%. Article-preposition contractions
- **Portuguese Variants**: Portugal (`pt-PT`) and Brazil (`pt-BR`) major differences. Manage as separate languages
- **Dutch**: Compound word processing. Belgian Dutch (`nl-BE`) differences
- **Polish**: 4 plural categories. Case declension translation quality

---

## Part XXIII: Language-Specific — LATAM, Africa & Emerging Markets

### Section 103: Latin American Markets

- **Diverse Currencies**: MXN, BRL, ARS, COP, etc. Design for frequent price updates with high-inflation currencies
- **Payment Methods**: Pix (Brazil), OXXO (Mexico), PSE (Colombia) regional payments
- **Mobile-First**: Low-bandwidth optimization. Lightweight app design
- **Hybrid Address Systems**: Flexible input forms for non-structured addresses (Colombia, etc.)

### Section 104: African Markets

- **Multilingual Environments**: Multiple official languages per country (South Africa: 11, Nigeria: 500+)
- **Mobile Money**: M-Pesa, Airtel Money integration. Feature phone support
- **Low-Bandwidth Design**: Text-based UI, aggressive image compression, offline-first design
- **Francophone Africa**: Account for variants like `fr-CI` (Côte d'Ivoire)

### Section 105: Turkish & Central Asia

- **Turkish I Problem**: Case conversion specificity (i→İ, I→ı). `toLocaleLowerCase('tr')` mandatory
- **Currency**: Turkish Lira (₺) high-inflation handling. Frequent price table updates
- **Central Asia**: Parallel Cyrillic/Latin usage (Kazakhstan: transitioning to Latin)

---

## Part XXIV: 30 Anti-Patterns

### Section 106: i18n Anti-Patterns — Design & Architecture

| # | Anti-Pattern | Problem | Correct Approach |
|:---:|---|---|---|
| 1 | Hardcoding UI text | Untranslatable. Code changes required for fixes | External translation key files |
| 2 | Building messages via string concatenation | Translation breaks due to word order differences | ICU MessageFormat 2.0 |
| 3 | Building custom i18n frameworks | Maintenance cost explosion, quality degradation | Adopt industry-standard libraries |
| 4 | Retrofitting i18n | Exponential technical debt increase | i18n-First from Day 1 |
| 5 | Using translation text as keys | Key collisions, unmanageable | Semantic dot-separated keys |
| 6 | Ignoring translation context | Mistranslation of identical words | Per-key context metadata |

### Section 107: i18n Anti-Patterns — Formatting & Display

| # | Anti-Pattern | Problem | Correct Approach |
|:---:|---|---|---|
| 7 | Hardcoding date formats | MM/DD vs DD/MM confusion | `Intl.DateTimeFormat` |
| 8 | Fixed timezone offsets | Cannot handle DST | IANA TZ DB + Temporal API |
| 9 | Fixed currency decimal places (2) | Zero-decimal currencies (JPY/KRW) | CLDR currency data reference |
| 10 | Simple if/else for plurals | Cannot handle Arabic 6-form etc. | CLDR Plural Rules |
| 11 | Direct `Date` object usage | Timezone handling fragility | Temporal API migration |
| 12 | Fixed comma/period for numbers | Regional decimal notation differences | `Intl.NumberFormat` |

### Section 108: i18n Anti-Patterns — UI/UX

| # | Anti-Pattern | Problem | Correct Approach |
|:---:|---|---|---|
| 13 | Fixed-width UI components | Layout breakage from text length variation | Variable-length design, Flexbox/Grid |
| 14 | CSS physical properties | Full rebuild for RTL | CSS logical properties |
| 15 | Retrofitting RTL support | Full UI redesign cost | BiDi-ready design from Day 1 |
| 16 | Unconditional directional icon display | Confusion in RTL | RTL flip rules |
| 17 | Color-only meaning conveyance | Misunderstanding due to cultural differences | Color + icon + text |
| 18 | Country flags in locale switcher | Language ≠ country (Spanish, etc.) | Native language name text |

### Section 109: i18n Anti-Patterns — Infrastructure & Operations

| # | Anti-Pattern | Problem | Correct Approach |
|:---:|---|---|---|
| 19 | Bulk-loading all translation files | Bundle bloat, performance degradation | Namespace splitting, lazy loading |
| 20 | Managing 3+ languages without TMS | Scalability collapse | TMS + CI/CD integration |
| 21 | Releasing with machine translation only | Quality issues, brand damage | MTPE + native review |
| 22 | Neglecting PII in translation data | Privacy violation risk | PII removal/anonymization pipeline |
| 23 | Hardcoding region-specific logic | Cannot scale | Environment variables, feature flags |
| 24 | Unrestricted AI translation usage | Cost explosion, inconsistent quality | Token budgets, quality gates |

### Section 110: i18n Anti-Patterns — Data & Security

| # | Anti-Pattern | Problem | Correct Approach |
|:---:|---|---|---|
| 25 | Using encodings other than UTF-8 | Mojibake, data loss | UTF-8 unified |
| 26 | Ignoring Unicode normalization | Search/comparison inconsistency | NFC normalization unified |
| 27 | Ignoring data sovereignty requirements | Legal risk, fines | Regional data flow design |
| 28 | Global sharing of encryption keys | Regional crypto regulation violations | Regional KMS isolation |
| 29 | One-size-fits-all cookie consent | Regional regulation violations | Locale-specific CMP control |
| 30 | Ignoring Turkish I problem | Case conversion bugs | `toLocaleLowerCase(locale)` |

---

## Part XXV: Organization, Process & Maturity

### Section 111: Localization Maturity Model

| Level | Name | Characteristics | KPI Criteria |
|:---:|---|---|---|
| 1 | **Ad-Hoc** | Ad-hoc translation. Hardcoded remnants. TZ unconsidered | Translation coverage < 50% |
| 2 | **Reactive** | Keys externalized. Major languages only. Manual translation | 50-80%, Missing Key > 10/month |
| 3 | **Proactive** | TMS adopted. CI/CD integrated. Pseudo-L10n. CLDR compliant | 95%+, MQM 95+, Missing Key < 5/month |
| 4 | **Strategic** | Full culturalization all markets. Multi-region infra. Quantitative LQA | 100%, MQM 98+, Missing Key 0 |
| 5 | **Optimized** | AI translation + MTPE integrated. Cross-lingual RAG. Real-time L10n. Sustainable i18n | Above + AI translation COMET > 0.85 |

- **Goal**: All projects MUST maintain **Level 3 (Proactive) or above**
- **Evaluation Frequency**: Quarterly
- **Promotion Trigger**: New market entry or tier change

### Section 112: Global Team Operations & Communication

- **Timezone Awareness**: Async-first communication design. Golden Hours utilization
- **Language Policy**: Define team common language. Leverage auto-translation tools
- **Cultural Diversity**: Communication guidelines respecting cultural backgrounds
- **i18n Champion**: Assign i18n advocate per team

### Section 113: i18n Education & Knowledge Base

- **Onboarding**: Provide i18n best practices guide for new members
- **Code Review Criteria**: Always flag hardcoded text, physical properties, string concatenation
- **Incident DB**: Accumulate and share i18n-related incidents and improvements
- **Regular Study Sessions**: Quarterly i18n topic study sessions

### Section 114: Sustainable i18n & Green Localization

- **Font Subset Optimization**: Exclude unnecessary glyphs to reduce data transfer and CO2
- **Translation Cache**: Reduce duplicate translation API calls (reduce API power consumption)
- **Regional Right-Sizing**: Avoid over-provisioning
- **SCI (Software Carbon Intensity)**: Measure carbon footprint of i18n-related infrastructure
- → See `720_cloud_finops.md` GreenOps section

---

## Appendix A: Reverse Lookup Index

| Technology / Service | Related Sections |
|---|---|
| ICU MessageFormat 2.0 | 6, 7, 67 |
| ICU 79 | 6, 26 |
| CLDR 48/48.2/49 | 6, 7, 8, 9, 33 |
| Intl API (JavaScript) | 8, 9, 29, 34 |
| ECMA-402 2026 | 8 |
| Temporal API | 8, 30, 31 |
| W3C String-Meta | 5 |
| CSS Logical Properties | 20 |
| BiDi / RTL | 20, 21, 22, 23, 24, 91-94 |
| CJK Fonts | 25, 43, 88-90 |
| UTF-8 / Unicode 17.0 / 18.0 | 26 |
| IME | 27 |
| Intl.Segmenter | 29, 63, 96 |
| TMS | 13, 14, 16 |
| AI Translation / MTPE / L1-L5 | 17, 59, 61 |
| Multi-Engine Routing | 17 |
| COMET / xCOMET / GEMBA | 17, 59, 62 |
| Agentic AI Translation | 62 |
| CDN / Edge | 40, 43, 45 |
| Edge i18n / Middleware | 12, 40 |
| Multi-Region | 41, 42 |
| Sovereign Cloud | 3, 42 |
| Data Residency | 3, 42, 74 |
| Stripe / Payments | 46, 48, 51 |
| VAT / GST / DST | 47 |
| OSS / IOSS | 48 |
| hreflang / International SEO | 52, 55 |
| LLMs.txt / GEO | 53, 71 |
| LLM / RAG Multilingual | 57, 58, 59, 60 |
| Embedding / Semantic Search | 58, 63 |
| iOS / Android | 64 |
| Flutter / React Native | 65 |
| KMP | 65 |
| Pseudo-Localization | 4, 67 |
| VRT | 68 |
| Accessibility / EAA / WCAG 2.2 | 49, 69 |
| EU AI Act | 49, 62, 75 |
| Cookie Consent / TCF 2.2 / GPP | 73 |
| Cryptographic Regulation / PQC | 72 |
| PCI DSS / SCA | 51 |
| DMA / EU Data Act | 49 |
| DSA / Content Moderation | 56 |
| Microcopy / UX Writing | 79, 80, 81 |
| Design Tokens | 82, 83, 84 |
| Voice / VUI / TTS | 85 |
| Multimodal AI | 86 |
| Chatbot | 87 |
| i18n Observability | 76 |
| FinOps / Cost Management | 19, 77, 78 |
| E-Invoicing | 50 |
| next-intl 4.0 / Next.js | 12 |
| Japanese-Specific | 88 |
| Chinese-Specific | 89 |
| Korean-Specific | 90 |
| Arabic-Specific | 91 |
| Hindi / Indic | 95 |
| Thai | 96 |
| German | 99 |
| French | 100 |
| Spanish | 101 |
| Latin America | 103 |
| Africa | 104 |
| Turkish | 105 |
| Sustainable i18n | 114 |
| Anti-Patterns | 106-110 |
| Maturity Model | 111 |

---

## Appendix B: Cross-References

| Rule File | Related Content |
|---|---|
| [100_product_strategy.md](../product/000_product_strategy.md) | Dynamic Pricing metadata, tier strategy |
| [101_revenue_monetization.md](../product/300_revenue_monetization.md) | Payments, currency, FinOps |
| [102_growth_marketing.md](../product/500_growth_marketing.md) | SEO/GEO, OGP, ASO |
| [200_design_ux.md](../design/000_design_ux.md) | Accessibility, IME, layout |
| [300_engineering_standards.md](../engineering/000_engineering_standards.md) | CI/CD, coding standards |
| [340_web_frontend.md](../engineering/300_web_frontend.md) | CSS architecture, performance |
| [341_headless_cms.md](../engineering/310_headless_cms.md) | Multilingual content management |
| [320_supabase_architecture.md](../engineering/200_supabase_architecture.md) | DB design, timezone |
| [400_ai_engineering.md](../ai/000_ai_engineering.md) | AI/LLM, RAG, Agentic AI |
| [502_site_reliability.md](../operations/400_site_reliability.md) | Multi-region availability |
| [600_security_privacy.md](../security/000_security_privacy.md) | Data protection, encryption, crypto regulation |
| [601_data_governance.md](../security/100_data_governance.md) | GDPR, Global Privacy Laws, cross-border data, EU Data Act |
| [700_qa_testing.md](../quality/000_qa_testing.md) | VRT, accessibility testing |
| [720_cloud_finops.md](../operations/600_cloud_finops.md) | Cloud cost management, GreenOps |
| [802_language_protocol.md](../core/200_language_protocol.md) | Language usage protocol, UI glossary |

| Section | Related Rule |
|---|---|
| §1–§5 (i18n Architecture) | `300_engineering_standards`, `340_web_frontend` |
| §6–§9 (Locale & Formatting) | `200_design_ux` |
| §12 (Framework-Specific) | `340_web_frontend` |
| §17 (AI Translation) | `400_ai_engineering` |
| §20–§24 (BiDi / RTL) | `200_design_ux` |
| §40–§42 (Edge / Multi-Region) | `502_site_reliability` |
| §46–§51 (Payments / Taxation) | `101_revenue_monetization` |
| §52–§56 (International SEO) | `102_growth_marketing` |
| §57–§63 (LLM Multilingual / Agentic AI) | `400_ai_engineering` |
| §64–§66 (Mobile i18n) | `340_web_frontend` |
| §74–§75 (Data Residency / EU AI Act) | `601_data_governance`, `600_security_privacy` |
| §79–§81 (Microcopy) | `200_design_ux` |
| §82–§84 (Design Tokens) | `340_web_frontend` |
| §85–§87 (Voice / Multimodal) | `400_ai_engineering` |
| §88–§105 (Language-Specific) | `200_design_ux`, `601_data_governance` |
| §114 (Sustainable i18n) | `720_cloud_finops` |
