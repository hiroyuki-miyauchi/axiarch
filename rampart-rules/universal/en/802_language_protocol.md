# 74. Language Protocol

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-03-24

> [!IMPORTANT]
> **Supreme Directive**
> Absolute Compliance with the Project Native Language.
> - **Core Principle**: All communication between users and developers must be conducted in the language defined by `Project Native Language` in `AGENTS.md`. Advanced language proficiency including cultural context and nuance is required.
> - **Scope**: Thinking & planning (`task.md`, `implementation_plan.md`), reporting & dialogue (`notify_user`), deliverables (UI, documentation, error messages).
> - **English Restriction**: English usage is strictly limited to source code, variable names, technical terms, and commit message subjects only. Unnatural translationese or context-ignorant English usage is treated as a **bug**.
> **11 Parts, 43 Sections.**

---

## Table of Contents

- [Part I: Fundamental Principles & Language Hierarchy Model](#part-i-fundamental-principles--language-hierarchy-model)
- [Part II: Code Language Conventions](#part-ii-code-language-conventions)
- [Part III: Documentation & Specification Language Strategy](#part-iii-documentation--specification-language-strategy)
- [Part IV: Git & Version Control Language Conventions](#part-iv-git--version-control-language-conventions)
- [Part V: UI/UX Localization Mandate](#part-v-uiux-localization-mandate)
- [Part VI: UI Glossary & Terminology Consistency](#part-vi-ui-glossary--terminology-consistency)
- [Part VII: Validation & Form Language Protocol](#part-vii-validation--form-language-protocol)
- [Part VIII: Error Handling Language Hierarchy](#part-viii-error-handling-language-hierarchy)
- [Part IX: API Response Language Policy](#part-ix-api-response-language-policy)
- [Part X: Notification & Communication Language Policy](#part-x-notification--communication-language-policy)
- [Part XI: AI Agent Communication Language Protocol](#part-xi-ai-agent-communication-language-protocol)
- [Part XII: Logging, Audit & Observability Language Policy](#part-xii-logging-audit--observability-language-policy)
- [Part XIII: Test Language Policy](#part-xiii-test-language-policy)
- [Part XIV: CMS & Content Language Governance](#part-xiv-cms--content-language-governance)
- [Part XV: SEO & Structured Data Language](#part-xv-seo--structured-data-language)
- [Part XVI: Accessibility Language Requirements](#part-xvi-accessibility-language-requirements)
- [Part XVII: Translation Exclusion Policy](#part-xvii-translation-exclusion-policy)
- [Part XVIII: CI/CD Language Quality Gate](#part-xviii-cicd-language-quality-gate)
- [Part XIX: Type-Safe i18n & Translation Key Design](#part-xix-type-safe-i18n--translation-key-design)
- [Part XX: AI Inter-Agent & Agent-to-Agent Language Protocol](#part-xx-ai-inter-agent--agent-to-agent-language-protocol)
- [Part XXI: Multilingual Safety Guardrails](#part-xxi-multilingual-safety-guardrails)
- [Part XXII: PDF, CSV & Report Export Language](#part-xxii-pdf-csv--report-export-language)
- [Part XXIII: Legal & Contractual Document Language Governance](#part-xxiii-legal--contractual-document-language-governance)
- [Part XXIV: Mobile-Specific Language Protocol](#part-xxiv-mobile-specific-language-protocol)
- [Part XXV: Maturity Model & Anti-Patterns](#part-xxv-maturity-model--anti-patterns)
- [Part XXVI: Database & Infrastructure Language Policy](#part-xxvi-database--infrastructure-language-policy)
- [Part XXVII: Design System & Design Token i18n](#part-xxvii-design-system--design-token-i18n)
- [Part XXVIII: Error Recovery & Graceful Degradation Language](#part-xxviii-error-recovery--graceful-degradation-language)
- [Part XXIX: Performance Optimization & Bundle Strategy](#part-xxix-performance-optimization--bundle-strategy)
- [Part XXX: Team Education & Onboarding Language Protocol](#part-xxx-team-education--onboarding-language-protocol)
- [Part XXXI: Character Encoding & Unicode Safety](#part-xxxi-character-encoding--unicode-safety)
- [Part XXXII: Gender-Inclusive & Inclusive Language](#part-xxxii-gender-inclusive--inclusive-language)
- [Part XXXIII: Real-Time, WebSocket & SSE Language Protocol](#part-xxxiii-real-time-websocket--sse-language-protocol)
- [Part XXXIV: Micro-Frontend & Module Federation i18n](#part-xxxiv-micro-frontend--module-federation-i18n)
- [Part XXXV: AI Translation Quality Assurance & LQA](#part-xxxv-ai-translation-quality-assurance--lqa)
- [Part XXXVI: Voice UI, TTS/SSML Language Protocol](#part-xxxvi-voice-ui-ttsssml-language-protocol)
- [Part XXXVII: Serverless & Edge Computing Language Policy](#part-xxxvii-serverless--edge-computing-language-policy)
- [Part XXXVIII: 3D, Metaverse & Spatial Computing Language](#part-xxxviii-3d-metaverse--spatial-computing-language)
- [Part XXXIX: Healthcare & Regulated Domain Language](#part-xxxix-healthcare--regulated-domain-language)
- [Part XL: Third-Party SDK & Widget Language Governance](#part-xl-third-party-sdk--widget-language-governance)
- [Part XLI: Translation Cost Management & FinOps](#part-xli-translation-cost-management--finops)
- [Part XLII: Language-Related Incident Response](#part-xlii-language-related-incident-response)
- [Part XLIII: Speech Recognition (STT) Input Language Protocol](#part-xliii-speech-recognition-stt-input-language-protocol)
- [Part XLIV: Quick Reference Index (Appendix A)](#part-xliv-quick-reference-index-appendix-a)

---

## Part I: Fundamental Principles & Language Hierarchy Model

### 1.1. Project Native Language Definition

- **Rule 74.1**: Every project MUST define **one authoritative language** via `Project Native Language` in `AGENTS.md`
- **Rule 74.2**: The authoritative language serves as the **default language** for all decision documents, user-facing text, and team communication
- **Rule 74.3**: Changing the authoritative language requires a procedure equivalent to a "Constitutional Amendment" (→ see [801_governance.md](./801_governance.md) Part IV)

### 1.2. Three-Layer Language Usage Model

All text is classified into the following three layers, with language policies applied per layer:

| Layer | Scope | Language | Rationale |
|---|---|---|---|
| **L1: User Layer** | UI, notifications, emails, error messages, help | **Project Native Language (mandatory)** | Zero Cognitive Load Principle |
| **L2: Developer Layer** | Specs, PRs, tasks, commit body, code comments | **Project Native Language (mandatory)**, code itself in English | Accuracy of team communication |
| **L3: System Layer** | Logs, metrics, audit trails, external APIs | **English (recommended)** | International interoperability & tool compatibility |

```
┌─────────────────────────────────────┐
│  L1: User Layer                      │ → Project Native Language
│  (UI, notifications, emails, errors) │
├─────────────────────────────────────┤
│  L2: Developer Layer                 │ → Project Native Language + Code in English
│  (Specs, PRs, tasks, comments)       │
├─────────────────────────────────────┤
│  L3: System Layer                    │ → English
│  (Logs, metrics, audit, ext. APIs)   │
└─────────────────────────────────────┘
```

### 1.3. Zero Cognitive Load Principle

- **Rule 74.4**: Any situation requiring users to perform "translation" as a cognitive task is treated as an **implementation bug**
- **Rule 74.5**: System-generated English (`"Invalid input"`, `"Required"`, `"Unknown"`) reaching end users is prohibited under **zero tolerance**
- **Rule 74.6**: Translation quality is also covered. Unnatural translationese or awkward phrasing is also prohibited. Natural, professional expressions are mandatory

### 1.4. Language Negotiation Strategy

- **Rule 74.7**: The **priority chain** for determining user language is defined as follows:

```
1. DB-stored user language preference (highest priority)
2. Session/Cookie stored language selection
3. HTTP `Accept-Language` header
4. `navigator.language` / `navigator.languages`
5. GeoIP-based estimation (fallback)
6. Project default language (final fallback)
```

- **Rule 74.8**: For single-language projects (only one `Project Native Language`), negotiation is unnecessary. The Project Native Language is always applied
- **Rule 74.9**: Guarantee UI state preservation during language switching (form input values, scroll position, modal state)
- **Rule 74.9A**: Recommend a Service Worker language interceptor strategy. Detect language at the request level and prefetch/cache appropriate locale resources
- **Rule 74.9B**: When using Temporal API (TC39 Stage 3), set `calendar` and `timeZone` of `Temporal.Now.zonedDateTimeISO()` based on the user's locale

### 1.5. Language Policy Governance

- **Rule 74.10A**: Language policy change proposals follow this RACI matrix:

| Role | Responsibility |
|---|---|
| **Responsible** | Tech Lead / Frontend Lead |
| **Accountable** | Product Owner |
| **Consulted** | UX Writer / Localization Engineer |
| **Informed** | Entire development team |

- **Rule 74.10B**: Language policy changes are proposed via PR and require a minimum of 2 reviewers

---

## Part II: Code Language Conventions

### 2.1. Source Code Basic Conventions

- **Rule 74.10**: Source code, variable names, function names, class names, and interface names MUST be written in **English**
- **Rule 74.11**: Use grammatically correct English with clear, meaningful naming
  - ✅ `getUserProfile`, `calculateTotalPrice`, `isAuthenticated`
  - ❌ `getUsrPrf`, `calc`, `flg` (meaningless abbreviations)
  - ❌ `shutokuUserJyouhou` (romanized non-English)
  - ❌ `kensaku`, `touroku`, `sakujo` (romanized verbs)
  - ❌ `handleKakunin` (mixed language)

### 2.2. Type Definitions & Interfaces

- **Rule 74.12**: TypeScript/JSDoc type names and property names MUST be in **English**
- **Rule 74.13**: JSDoc descriptions (`@description`, `@param`, `@returns`) MUST be in **English** (prioritizing international codebase readability)
- **Rule 74.14**: For business domain concepts without adequate English translations, supplementary explanation in the Project Native Language is permitted in comments

```typescript
/**
 * Represents a pet health checkup record.
 * @param petId - The unique identifier of the pet
 * @param checkupDate - Date of the health checkup (ISO 8601)
 * @param veterinarianId - ID of the attending veterinarian
 */
interface HealthCheckup {
  petId: string;
  checkupDate: string;
  veterinarianId: string;
}
```

### 2.3. In-Code Comments

- **Rule 74.15**: Inline comments (`//`, `/* */`) MUST be written in **English**
- **Rule 74.16**: Supplementary comments in the Project Native Language are permitted only when English cannot accurately convey complex business logic intent
- **Rule 74.17**: TODO comment format:
  - `// TODO: [technical description in English]` (in code)
  - Detailed descriptions in task management tools use the Project Native Language

### 2.4. Magic Strings & Constant Naming

- **Rule 74.18**: Constant names (`const`, `enum`) use **English SCREAMING_SNAKE_CASE**
- **Rule 74.19**: When constant values are displayed to users, they MUST go through a display label mapping (see Part VII)

```typescript
// ✅ Correct pattern
const SUBSCRIPTION_STATUS = {
  ACTIVE: 'active',
  CANCELLED: 'cancelled',
  PAST_DUE: 'past_due',
} as const;

const STATUS_LABELS: Record<string, string> = {
  active: 'Active',
  cancelled: 'Cancelled',
  past_due: 'Past Due',
};

// ❌ Prohibited: Displaying constant values directly in UI
// <span className="uppercase">{status}</span>
```

### 2.5. Regex & DSL Literals

- **Rule 74.19A**: Comments and error messages within regex literals are in English
- **Rule 74.19B**: Field names and type names in DSLs (Prisma Schema, GraphQL SDL, etc.) are **English**; comments default to English

---

## Part III: Documentation & Specification Language Strategy

### 3.1. Design Documents & Specifications (Blueprint)

- **Rule 74.20**: Blueprints (under `rampart-rules/blueprint/`) MUST be written in the **Project Native Language**
- **Rule 74.21**: Technical terms and proper nouns (React, Supabase, Next.js, etc.) retain English representation as a rule
- **Rule 74.22**: ADRs (Architecture Decision Records) are also written in the Project Native Language to accurately capture decision rationale

### 3.2. Task Management & Issues

- **Rule 74.23**: `task.md`, `implementation_plan.md`, `walkthrough.md` are in the **Project Native Language**
- **Rule 74.24**: GitHub/GitLab Issue titles and descriptions are in the **Project Native Language**
- **Rule 74.25**: Label names may use English (`bug`, `feature`, `priority:high`, etc.)

### 3.3. README & CHANGELOG

- **Rule 74.26**: Internal project README is in the **Project Native Language**
- **Rule 74.27**: README for public OSS projects is in English, or bilingual (English + Project Native Language)
- **Rule 74.28**: CHANGELOG is in the Project Native Language. However, semantic versioning tags (`feat:`, `fix:`, `BREAKING CHANGE:`) retain English

---

## Part IV: Git & Version Control Language Conventions

### 4.1. Commit Messages

- **Rule 74.30**: Conventional Commits prefixes remain in **English**:
  - `feat:`, `fix:`, `docs:`, `style:`, `refactor:`, `test:`, `chore:`
- **Rule 74.31**: Subject line (first line) is written concisely in **English** (50 characters recommended)
- **Rule 74.32**: Body section (detailed description) is in the **Project Native Language**, describing "intent" and "impact" of changes
- **Rule 74.33**: Breaking Change footer uses English prefix + Project Native Language description

```
feat: add pet health checkup reminder notification

Added periodic health checkup reminder notification feature.
Automatically sends push notifications and emails based on
user-configured intervals (30/60/90 days).

Target tables: pet_health_checkups, notification_schedules
Related Issue: #1234

BREAKING CHANGE: Schema change for notification_schedules table.
Migration `20260318_add_reminder_interval` must be applied.
```

### 4.2. Branch & Tag Naming

- **Rule 74.34**: Branch names are in **English** (`feature/add-checkup-reminder`, `fix/login-validation`)
- **Rule 74.35**: Tag names follow semantic versioning (`v1.2.3`)
- **Rule 74.36**: Release notes are written in the **Project Native Language**

### 4.3. PR/MR (Pull Requests / Merge Requests)

- **Rule 74.37**: PR titles are in the **Project Native Language** (for efficient team review)
- **Rule 74.38**: PR descriptions are in the **Project Native Language**, including:
  - Purpose and background of changes
  - Implementation approach overview
  - Testing methodology
  - Impact scope
- **Rule 74.39**: PR templates are defined in the Project Native Language

---

## Part V: UI/UX Localization Mandate

### 5.1. Comprehensive UI Localization

- **Rule 74.40**: **All UI text**, whether public or internal, MUST be localized in the Project Native Language
- Scope: buttons, labels, placeholders, help text, status displays, tooltips, modals, dropdown options, breadcrumbs, page titles
- **Rule 74.41**: Visually hidden text is also subject to localization **without exception**:
  - Icon `alt` attributes
  - `aria-label`, `aria-describedby`
  - `title` attributes
  - `<meta>` `content`
  - `placeholder`

### 5.2. Microcopy Quality Standards (UX Writing)

- **Rule 74.42**: Microcopy must embody a "hospitality mindset" and meet the following standards:

| Criterion | ❌ Prohibited | ✅ Correct |
|---|---|---|
| Eliminate translationese | Literal word-for-word translations | Natural, idiomatic expressions |
| Avoid excessive formality | Overly formal or stilted phrasing | Professional yet approachable |
| Use concise labels | Verbose button labels | Action-oriented concise labels |
| Context-aware tone | Generic error messages | Situation-specific guidance |
| Positive framing | "Your input is wrong" | "Please enter a valid format" |

- **Rule 74.43**: Error messages MUST contain two elements: "what happened" + "what to do"
  - ❌ `"An error occurred"`
  - ✅ `"Invalid email format. Example: user@example.com"`

### 5.3. Voice & Tone Guidelines

- **Rule 74.44**: Each project MUST define **Voice (brand personality)** and **Tone (context-dependent register)**:
  - **Voice**: Consistent brand personality (e.g., "friendly, professional, trustworthy")
  - **Tone**: Varies by context (success → celebratory, error → empathetic, warning → cautious)
- **Rule 74.45**: Tone Matrix example:

| Situation | Tone | Example |
|---|---|---|
| Success | Celebratory/affirming | "Saved successfully ✓" |
| Error | Empathetic/solution-oriented | "Couldn't save. Please try again" |
| Warning | Cautious/clear | "This action cannot be undone" |
| Guidance | Helpful/concise | "Let's start by setting up your profile" |
| Loading | Reassuring/progress-indicating | "Processing..." |

### 5.4. Empty State & Fallback Text

- **Rule 74.46**: Fallback text for missing data (`"Unknown"`, `"N/A"`, `"null"`, `"undefined"`) displayed to users is a **bug**
- **Rule 74.47**: Empty state display language quality standards:
  - ❌ `"No data available"`
  - ✅ `"No entries yet"` (natural, context-appropriate expression)
- **Rule 74.48**: Loading displays are also covered:
  - ❌ Raw spinner with no text
  - ✅ Properly localized loading message

### 5.5. Interactive Elements

- **Rule 74.49**: Confirmation dialog options MUST use context-specific verb labels:
  - ❌ `"OK" / "Cancel"` (same for all dialogs)
  - ✅ `"Delete" / "Keep"` (for deletion confirmation)
  - ✅ `"Save" / "Discard"` (for unsaved changes warning)
- **Rule 74.50**: Toast/Snackbar notification message quality standards:
  - Success: `"Saved"` (past tense, concise)
  - Error: `"Failed to save. Please try again"` (cause + action)

### 5.6. Text Expansion Rate & Layout Considerations

- **Rule 74.51**: For multilingual UIs, the following text expansion rates MUST be considered during design:

| Direction | Rate | Example |
|---|---|---|
| English → Japanese | ~70-80% shrinkage | "Save changes" → shorter CJK text |
| English → German | ~130-150% expansion | "Save" → "Speichern" |
| English → Arabic | ~120-130% expansion + RTL | — |
| Japanese → English | ~120-150% expansion | Shorter CJK → longer Latin text |

- **Rule 74.52**: Buttons and labels MUST avoid fixed widths and use flexible layouts that tolerate text expansion
- **Rule 74.53**: Pseudo-localization testing MUST be used to detect layout breakage proactively (see Part XIII)

---

## Part VI: UI Glossary & Terminology Consistency

### 6.1. Glossary Establishment Mandate

- **Rule 74.55**: Each project MUST establish a **UI Terminology Glossary** and place it within the Blueprint
- **Rule 74.56**: Terminology inconsistency for the same concept is treated as a **bug**

| Category | ❌ Prohibited (Inconsistency) | ✅ Standard |
|---|---|---|
| Auth | Login/Sign in mixed | Unify to **one** per project |
| Actions | Register/Add/Create mixed | Context-appropriate unification |
| States | Deleted/Disabled/Inactive mixed | Unify per project |
| Currency | $/USD mixed | Unify per project |

### 6.2. Inconsistency Detection & Operations

- **Rule 74.57**: When creating new UI text, always reference the glossary to verify consistency with existing terms
- **Rule 74.58**: PR reviews MUST include glossary consistency checks as a mandatory item
- **Rule 74.59**: Where possible, implement automated glossary reconciliation in CI (see Part XVIII)

### 6.3. Abbreviation & Acronym Policy

- **Rule 74.60**: For abbreviations not commonly known in the Project Native Language, include full spelling or explanation at first use
- **Rule 74.61**: Technical abbreviations (API, URL, CSS, HTML, etc.) retain English representation
- **Rule 74.62**: Business domain-specific abbreviations are registered in the glossary with consistent expansion forms

---

## Part VII: Validation & Form Language Protocol

### 7.1. Validation Messages

- **Rule 74.65**: Displaying default English messages from validation libraries (Zod, Yup, React Hook Form, etc.) to users is a **bug**
- **Rule 74.66**: All validation rules MUST have explicit `message` set in the Project Native Language
- **Rule 74.66A**: When using Zod, configure `z.setErrorMap()` to set a global error map, structurally preventing default message leakage

```typescript
// ✅ Correct pattern: Global error map
const customErrorMap: z.ZodErrorMap = (issue, ctx) => {
  switch (issue.code) {
    case z.ZodIssueCode.too_small:
      return { message: `Must be at least ${issue.minimum} characters` };
    case z.ZodIssueCode.invalid_type:
      return { message: 'Invalid input format' };
    default:
      return { message: ctx.defaultError };
  }
};
z.setErrorMap(customErrorMap);

// ✅ Individual messages
const emailSchema = z.string()
  .min(1, { message: 'Please enter your email address' })
  .email({ message: 'Invalid email format' });

// ❌ Prohibited: Relying on default messages
const emailSchema = z.string().email(); // "Invalid email" displayed
```

### 7.2. Form Labels & Help Text

- **Rule 74.67**: Form `<label>` elements are 100% in the Project Native Language
- **Rule 74.68**: Help text and input assistance text MUST be specific and context-appropriate
  - ❌ `"Please enter a value"` (too generic)
  - ✅ `"Example: 090-1234-5678"` (expected format made explicit)
- **Rule 74.69**: Placeholders MUST 100% match the expected data type and business context of the field

### 7.3. Enum/Status Display Label Mapping

- **Rule 74.70**: Displaying DB values, internal constants, or Enum values directly in UI is **strictly prohibited**
- **Rule 74.71**: MUST use a `Display Label Map` to convert to the Project Native Language
- **Rule 74.72**: Using CSS `uppercase`/`capitalize` to style English constants for display is **strictly prohibited**

```typescript
// ✅ Correct pattern: Via label map
const ORDER_STATUS_LABELS: Record<OrderStatus, string> = {
  pending: 'Pending',
  confirmed: 'Confirmed',
  shipped: 'Shipped',
  delivered: 'Delivered',
  cancelled: 'Cancelled',
};

// UI component
<Badge>{ORDER_STATUS_LABELS[order.status]}</Badge>

// ❌ Strictly prohibited
<Badge className="uppercase">{order.status}</Badge>
```

### 7.4. Locale-Aware Number, Date & Currency Formatting

- **Rule 74.73**: Number formatting MUST follow locale conventions (use `Intl.NumberFormat`)
- **Rule 74.74**: Date formatting MUST follow locale conventions (use `Intl.DateTimeFormat` or `date-fns/locale`)
- **Rule 74.75**: Currency display uses currency symbol + locale-compliant formatting

```typescript
// ✅ Locale-aware formatting
const price = new Intl.NumberFormat('en-US', {
  style: 'currency',
  currency: 'USD',
}).format(19.80); // "$19.80"

const date = new Intl.DateTimeFormat('en-US', {
  year: 'numeric',
  month: 'long',
  day: 'numeric',
}).format(new Date()); // "March 18, 2026"
```

### 7.5. Plural & Ordinal Rules

- **Rule 74.76**: Plural processing MUST use `Intl.PluralRules` or ICU MessageFormat, following language-specific rules
- **Rule 74.77**: String concatenation for plural handling (`count + " items"`) is **prohibited**. Use template literals or message functions

```typescript
// ✅ Using ICU MessageFormat
// messages.json: "itemCount": "{count, plural, =0 {No items} one {1 item} other {{count} items}}"

// ❌ Prohibited: String concatenation
const label = `${count} items available`;
```

### 7.6. Intl.DurationFormat & Advanced Locale Formatting

- **Rule 74.78**: Use `Intl.DurationFormat` (Stage 3) or equivalent polyfills for duration display, guaranteeing locale-specific expressions
- **Rule 74.79**: Use `Intl.RelativeTimeFormat` for relative time display. Manual string construction (e.g., `"3 days ago"`) is **prohibited**

```typescript
// ✅ Intl.RelativeTimeFormat
const rtf = new Intl.RelativeTimeFormat('ja', { numeric: 'auto' });
rtf.format(-3, 'day'); // "3日前"
rtf.format(1, 'hour'); // "1時間後"

// ❌ Prohibited: Manual construction
const label = `${days} days ago`;
```

- **Rule 74.79A**: Recommend adoption of ICU MessageFormat 2.0 (Stable release March 2025, integrated into CLDR 47 / ICU 77). Develop a migration plan from MF 1.0

---

## Part VIII: Error Handling Language Hierarchy

### 8.1. Layer-Based Language Policy

- **Rule 74.80**: Error message language is determined by **who ultimately receives the message**

| Layer | Recipient | Language | Example |
|---|---|---|---|
| **UI Component** | End user | Project Native Language | Toast, Alert, inline |
| **Server Action / API Route** | User via frontend | Project Native Language | `return { error: '...' }` |
| **Service Layer** | User via frontend | Project Native Language | `return { message: '...' }` |
| **Domain/Logic Layer** | Developer logs only | English | `throw new Error('...')` |
| **Infrastructure Layer** | Operations team | English | Logger output |

### 8.2. Error Message Dualization Pattern

- **Rule 74.81**: Separate user-facing and system-facing messages

```typescript
// ✅ Recommended: Dual messaging
class AppError extends Error {
  constructor(
    public readonly userMessage: string,    // Project Native Language
    public readonly systemMessage: string,  // English (for logs)
    public readonly code: string,           // Error code
  ) {
    super(systemMessage);
  }
}

throw new AppError(
  'Failed to update profile. Please try again',
  'Failed to update user profile: constraint violation on email field',
  'USER_PROFILE_UPDATE_FAILED'
);
```

### 8.3. Error Code System

- **Rule 74.82**: Error codes use **English SCREAMING_SNAKE_CASE** (`AUTH_INVALID_TOKEN`, `QUOTA_EXCEEDED`)
- **Rule 74.83**: Maintain a mapping dictionary from error codes to user messages in the Project Native Language

### 8.4. Error Boundary Language Fallback

- **Rule 74.84**: React Error Boundary and Next.js `error.tsx` fallback UIs MUST render in the **Project Native Language**
- **Rule 74.85**: Prepare hard-coded fallback messages in the Project Native Language for cases where Error Boundary fails to load translation files themselves

```typescript
// ✅ Error Boundary fallback
export default function GlobalError() {
  return (
    <html lang="en">
      <body>
        <h1>Something went wrong</h1>
        <p>Please try again later</p>
        <button onClick={() => window.location.reload()}>
          Reload
        </button>
      </body>
    </html>
  );
}
```

---

## Part IX: API Response Language Policy

### 9.1. Internal API vs External API

- **Rule 74.90**: **Internal API** (consumed by frontend) error message `detail` / `message` fields are in the **Project Native Language**
- **Rule 74.91**: **External public API** (`/api/v1/*` for third parties) remains in **English**
- **Rule 74.92**: Verify during PR review that error response function parameters match the target language

### 9.2. GraphQL/gRPC

- **Rule 74.93**: GraphQL `errors[].message` language is selected based on whether it's displayed in the frontend
- **Rule 74.94**: gRPC `status.message` defaults to English; localization happens on the frontend side

### 9.3. Webhooks & Event Payloads

- **Rule 74.95**: External webhook payloads are in **English**
- **Rule 74.96**: Internal event bus messages are in **English** (treated as system layer)

### 9.4. API Documentation & Deprecation Notices

- **Rule 74.97**: External public API documentation is in **English**
- **Rule 74.98**: Internal API documentation is in the **Project Native Language**
- **Rule 74.99**: Deprecation Warning headers are in **English** (HTTP standard compliance)

---

## Part X: Notification & Communication Language Policy

### 10.1. Transactional Emails

- **Rule 74.100**: Automated emails (password reset, order confirmation, receipts, etc.) are in the **Project Native Language**
- **Rule 74.101**: Email subject, body, and footer MUST all be localized
- **Rule 74.102**: Placeholder URLs in email templates (e.g., `example.com`) are **strictly prohibited**. Use actual domains

### 10.2. SMS & Push Notifications

- **Rule 74.103**: SMS/push notifications are in the **Project Native Language**
- **Rule 74.104**: For character-limited notifications, abbreviations MUST use natural forms in the Project Native Language

### 10.3. In-App Notifications

- **Rule 74.105**: All in-app notification banners and inline notifications are in the **Project Native Language**
- **Rule 74.106**: Real-time notifications (via WebSocket/SSE) are also subject to localization

### 10.4. Team Notifications (Slack/Teams, etc.)

- **Rule 74.107**: Team operations notifications (incident alerts, deploy notifications, etc.) default to the **Project Native Language**
- **Rule 74.108**: External integrations (PagerDuty, Opsgenie, etc.) may use **English**

---

## Part XI: AI Agent Communication Language Protocol

### 11.1. AI Agent Language Compliance Mandate

- **Rule 74.110**: **All AI agent output** (thinking processes, plans, reports, questions) MUST use the Project Native Language
- **Rule 74.111**: Generation and updates of `task.md`, `implementation_plan.md`, `walkthrough.md` are in the **Project Native Language**
- **Rule 74.112**: Reports and questions to users via `notify_user` are in the **Project Native Language**
- **Rule 74.113**: If an AI communicates in a non-project language, it is a **protocol violation** requiring immediate correction

### 11.2. AI-Generated Text Language Quality

- **Rule 74.114**: AI-generated UI-facing text (microcopy, error messages, etc.) MUST meet Part V quality standards
- **Rule 74.115**: Verify AI-generated translations for these anti-patterns:
  - Translationese (preserving source language word order)
  - Excessive formality or unnatural politeness
  - Over-reliance on loanwords when natural equivalents exist
  - Ambiguous pronoun retention

### 11.3. Prompts & System Instructions

- **Rule 74.116**: User-facing AI systems (chatbots, AI assistants, etc.) MUST include **language specification** in system prompts
- **Rule 74.117**: AI responses follow the user's input language or Project Native Language
- **Rule 74.118**: Implement **fallback mechanisms** for AI responses returned in unintended languages

### 11.4. RAG & Knowledge Base Multilingual Support

- **Rule 74.119**: When RAG source documents are in a language other than the Project Native Language, AI responses MUST be translated to the Project Native Language
- **Rule 74.120**: Knowledge base search queries are executed in both the Project Native Language and source language to maximize recall

### 11.5. Language Drift Auto-Detection

- **Rule 74.121**: Recommend mechanisms to auto-detect AI output language and alert when non-project language output is mixed in
- **Rule 74.122**: Language drift detection methods:
  - Character code-based (Unicode Script Property analysis)
  - Language detection libraries (`franc`, `cld3`, etc.) sampling inspection
  - LLM self-verification prompt ("Is your output in the Project Native Language?")

### 11.6. AI Code Review & Development Tool Language Settings

- **Rule 74.123**: AI Code Review (GitHub Copilot PR Review, etc.) feedback language is set to the Project Native Language
- **Rule 74.124**: AI development assistant tools (Copilot, Cursor, etc.) comment generation language is English (for in-code comments)

### 11.7. MCP, A2A & ACP Protocol Language Metadata

- **Rule 74.124A**: Include language metadata in MCP (Model Context Protocol) Tool manifests. Tool `description` in English; user-facing output templates in the Project Native Language
- **Rule 74.124B**: Define `supportedLanguages` field in A2A (Agent-to-Agent) Agent Cards to explicitly declare agents' language capabilities
- **Rule 74.124C**: Include `Accept-Language` / `Content-Language` in ACP (Agent Communication Protocol) REST headers to clarify language expectations between agents
- **Rule 74.124D**: In agent chains (sequential multi-agent processing), language context MUST be propagated across the entire chain

```json
// A2A Agent Card example
{
  "name": "translation-agent",
  "description": "Handles document translation tasks",
  "supportedLanguages": ["ja", "en"],
  "defaultLanguage": "ja",
  "capabilities": ["translate", "summarize"]
}
```

---

## Part XII: Logging, Audit & Observability Language Policy

### 12.1. Application Logs

- **Rule 74.125**: Application log messages MUST be written in **English**
  - Rationale: Compatibility with log analysis tools (Datadog, Loki, CloudWatch, etc.), international team support, ease of pattern matching
- **Rule 74.126**: User input data in logs is sanitized and recorded as-is regardless of language (not translated)

```typescript
// ✅ Correct pattern
logger.error('Failed to process payment', {
  userId: user.id,
  amount: payment.amount,
  error: err.message,
});

// ❌ Prohibited: Non-English log messages
logger.error('Payment processing failed in native language', { ... });
```

### 12.2. Structured Log Field Naming

- **Rule 74.127**: Structured log (JSON) field names MUST be unified in **English camelCase or snake_case**
- **Rule 74.128**: OpenTelemetry Span/Trace attribute names are in English (semantic convention compliance)

### 12.3. Audit Trail

- **Rule 74.129**: Audit trail action names and event names are in **English** (`user.login`, `record.create`, `permission.change`)
- **Rule 74.130**: Audit log detail descriptions (admin UI display) go through **Project Native Language** label mapping

### 12.4. Metrics & Dashboards

- **Rule 74.131**: Metric names are in **English** (Prometheus/Grafana compatible): `http_request_duration_seconds`, `db_connection_pool_active`
- **Rule 74.132**: Dashboard titles and descriptions are in **team language** (typically Project Native Language)
- **Rule 74.133**: Alert notifications follow team language settings (see Part X.4)

---

## Part XIII: Test Language Policy

### 13.1. Test Code

- **Rule 74.135**: Test function names and `describe`/`it` block descriptions are in **English**

```typescript
// ✅ Correct pattern
describe('UserProfileService', () => {
  it('should return user profile with localized status labels', () => {
    // ...
  });

  it('should throw AppError when email already exists', () => {
    // ...
  });
});
```

### 13.2. Test Data Language

- **Rule 74.136**: Test data (fixtures, seed data) user-facing fields are in the **Project Native Language**
  - Names, descriptions, addresses, etc. use realistic data in the Project Native Language
  - Rationale: Early detection of localization bugs
- **Rule 74.137**: Test data system fields (IDs, status codes, etc.) are in English

### 13.3. E2E/VRT Tests

- **Rule 74.138**: E2E tests (Playwright, etc.) are executed in the Project Native Language locale to verify UI language accuracy
- **Rule 74.139**: VRT (Visual Regression Test) snapshots are captured in the Project Native Language locale
- **Rule 74.140**: Verify that locale-dependent formatting (dates, numbers, currency) displays correctly in tests

### 13.4. Pseudo-localization Testing

- **Rule 74.141**: For multilingual projects, integrate pseudo-localization testing into CI/CD
- **Rule 74.142**: Items to detect through pseudo-localization:
  - Layout breakage from text expansion
  - Remaining hardcoded strings
  - Character encoding issues (accent characters, CJK character display corruption)
  - Strings missing from translation resources

---

## Part XIV: CMS & Content Language Governance

### 14.1. CMS Admin Panel Language

- **Rule 74.145**: CMS admin panel UI language is the **Project Native Language** (Part V compliant)
- **Rule 74.146**: CMS field labels and help text are in the Project Native Language

### 14.2. Content Modeling

- **Rule 74.147**: CMS field names (API names) are in **English** (`title`, `description`, `published_at`)
- **Rule 74.148**: CMS display labels are in the **Project Native Language**
- **Rule 74.149**: Translation key naming convention:

```
# Translation key naming convention
{scope}.{component}.{element}

# Examples
common.button.save        → "Save"
common.button.cancel      → "Cancel"
auth.login.title          → "Login"
auth.login.email_label    → "Email Address"
pet.profile.name_label    → "Pet Name"
error.network.timeout     → "Connection timed out"
```

### 14.3. Content Versioning

- **Rule 74.150**: For multilingual content version management, the authoritative language version is treated as the "source of truth," with other language versions positioned as derivatives
- **Rule 74.151**: When the authoritative version is updated, automatically flag other language versions as "translation update required"

### 14.4. Translation Memory & Term Base Integration

- **Rule 74.152**: When integrating with a TMS (Translation Management System: Crowdin/Lokalise/Phrase, etc.), leverage Translation Memory (TM) and Term Bases (TB) to ensure translation quality and consistency
- **Rule 74.153**: Standard TMS integration flow:
  1. Auto-extract translation keys from source code
  2. Push to TMS (CI/CD integration)
  3. After translation completion, auto-pull translation files to repository
  4. Auto-generate PR and incorporate into review cycle

---

## Part XV: SEO & Structured Data Language

### 15.1. Metadata

- **Rule 74.155**: `<title>` tags and `<meta name="description">` are in the **Project Native Language**
- **Rule 74.156**: OGP (`og:title`, `og:description`) is in the **Project Native Language**
- **Rule 74.157**: Twitter Card (`twitter:title`, `twitter:description`) is also in the **Project Native Language**

### 15.2. Structured Data (JSON-LD)

- **Rule 74.158**: JSON-LD `name` and `description` fields are in the **Project Native Language**
- **Rule 74.159**: JSON-LD `@type`, `@context`, and other schema definitions are in **English** (Schema.org compliant)
- **Rule 74.160**: Set the `inLanguage` property with an accurate BCP 47 language tag (`ja`, `en`, etc.)

### 15.3. Sitemap & robots.txt

- **Rule 74.161**: For multilingual sites, set `hreflang` attributes accurately on all pages (→ see [800_internationalization.md](./800_internationalization.md) Part X)
- **Rule 74.162**: `robots.txt` is language-independent (written in English)

---

## Part XVI: Accessibility Language Requirements

### 16.1. HTML Language Attributes

- **Rule 74.165**: Set the page's primary language accurately with a BCP 47 tag, e.g., `<html lang="en">` (WCAG 2.2 SC 3.1.1 compliant)
- **Rule 74.166**: Where language switches within a page (e.g., foreign language quotes), mark explicitly with `<span lang="fr">` (WCAG 2.2 SC 3.1.2 compliant)

### 16.2. ARIA Attributes

- **Rule 74.167**: `aria-label`, `aria-describedby`, `aria-placeholder` are in the **Project Native Language**
- **Rule 74.168**: Provide abbreviation expansions for screen reader accessibility
  - ❌ `<abbr>RLS</abbr>`
  - ✅ `<abbr title="Row Level Security">RLS</abbr>`
- **Rule 74.168A**: Prefer `aria-labelledby` over `aria-label`. `aria-labelledby` references visible text, reducing translation omission risk

```html
<!-- ✅ Recommended: aria-labelledby referencing visible text -->
<h2 id="section-title">User Settings</h2>
<section aria-labelledby="section-title">...</section>

<!-- △ Acceptable: aria-label requires translation management -->
<button aria-label="Open menu">☰</button>
```

### 16.3. Image & Media Accessibility

- **Rule 74.169**: Image `alt` text is in the **Project Native Language**; decorative images use `alt=""`
- **Rule 74.170**: `<figcaption>` is in the **Project Native Language**
- **Rule 74.171**: Video subtitles and transcriptions MUST be provided in the **Project Native Language**

### 16.4. Live Regions & Dynamic Content

- **Rule 74.172**: Text inserted into `aria-live` regions is in the **Project Native Language**
- **Rule 74.173**: Dynamically updated counters, statuses, and notifications are also localized in the Project Native Language

### 16.5. Plain Language Principle & EAA Compliance

- **Rule 74.173A**: UI text MUST follow Plain Language principles, minimizing the use of jargon (WCAG 2.2 Understandable principle)
- **Rule 74.173B**: Products/services subject to the EAA (European Accessibility Act, effective June 2025) MUST comply with WCAG 2.2 AA or higher
- **Rule 74.173C**: Missing language attributes are a **blocking item** in accessibility audits (`lang` attribute omission causes incorrect screen reader pronunciation)
- **Rule 74.173D**: From the Cognitive Accessibility perspective, use short sentences, clear meaning, and consistent expressions

| Checkpoint | Standard |
|---|---|
| `<html lang>` setting | WCAG 2.2 SC 3.1.1 (Level A) |
| Partial language switch `<span lang>` | WCAG 2.2 SC 3.1.2 (Level AA) |
| Plain Language | WCAG 2.2 SC 3.1.5 (Level AAA) |
| EAA compliance | WCAG 2.2 AA + EN 301 549 |

---

## Part XVII: Translation Exclusion Policy

### 17.1. Translation Target Decision Flowchart

```
Is the text displayed to users?
├── Yes → Translate to Project Native Language
│         ├── UI labels/buttons/messages → Translation target
│         ├── Error messages (Toast/Alert display) → Translation target
│         ├── Email/notification body → Translation target
│         └── PDF report/CSV export headers → Translation target
└── No → Evaluate with following branching
         ├── Program constants/comparison targets → Do NOT translate
         ├── External API send/receive values → Do NOT translate
         ├── Log messages → Do NOT translate
         ├── DB stored values (enum, status, etc.) → Do NOT translate
         └── Developer-only errors (internal throw) → Do NOT translate
```

### 17.2. Explicit Exclusion Patterns

- **Rule 74.175**: The following are **explicitly excluded** from translation:
  1. **Program constants**: Strings used in frontend conditional branching (`'QUOTA_EXCEEDED'`)
  2. **Flow control strings**: State management strings in auth flows, etc. (`'OTP Required'`)
  3. **External API values**: Strings dependent on third-party API specs (Stripe `status: 'active'`)
  4. **Internal exceptions**: `throw new Error()` processed within try-catch and not reaching UI
  5. **JSON keys / API paths**: `userId`, `/api/v1/users`
  6. **Technical terms**: `HTML`, `CSS`, `JSON`, `OAuth`, `JWT`

### 17.3. Gray Zone Judgment

- **Rule 74.176**: The following patterns may cause uncertainty; **err on the side of translating**:

| Pattern | Judgment | Rationale |
|---|---|---|
| `return { error: '...' }` | ✅ Translate | May be displayed to users |
| `return { message: '...' }` | ✅ Translate | Displayed via Toast/Alert |
| `console.error('...')` | ❌ Do not translate | Developer tools only |
| `logger.warn('...')` | ❌ Do not translate | Operations logs only |
| Admin-only UI errors | ✅ Translate | Admins are also users |

---

## Part XVIII: CI/CD Language Quality Gate

### 18.1. Untranslated String Auto-Scan

- **Rule 74.180**: Detect UI components (`.tsx`, `.vue`, etc.) containing string literals not in the Project Native Language via CI/PR review
- **Rule 74.181**: Scan target layers (Deep Layer Scan):
  - UI component layer
  - Server Action / API Route error messages
  - Service layer return values
  - `title` / `description` properties
  - Email templates
  - Notification messages

### 18.2. Scan Exclusion Configuration

- **Rule 74.182**: The following are excluded from scanning:
  - Component names / variable names
  - Import / export statements
  - External public APIs (`/api/v1/*`)
  - Logger messages
  - `console.*` calls
  - Test files (`*.test.*`, `*.spec.*`)
  - Type definition files (`*.d.ts`)

### 18.3. PR / Deploy Gate

- **Rule 74.183**: Untranslated string detection MUST be configured as a **blocking item** in PR review
- **Rule 74.184**: Automated glossary consistency check for newly added strings is recommended
- **Rule 74.185**: Periodic full scans (weekly/monthly) to monitor residual "placeholder English"
- **Rule 74.185A**: Auto-insert translation coverage as PR comments to visualize progress

### 18.4. ESLint / Biome Custom Rules

- **Rule 74.186**: Introduce ESLint or Biome custom rules for automated language quality detection

```typescript
// eslint-plugin-language-protocol configuration example
module.exports = {
  rules: {
    'no-raw-english-in-jsx': 'error',     // Prohibit English literals in JSX
    'require-label-map': 'error',          // Detect direct Enum display
    'no-default-validation-msg': 'error',  // Detect Zod default messages
    'require-aria-lang': 'warn',           // Check aria-label language
  },
};
```

### 18.5. Language Quality Scoring

- **Rule 74.187**: Recommended metrics for measuring language quality:
  - **Localization coverage rate**: Percentage of all strings localized to the Project Native Language
  - **Glossary compliance rate**: Match rate with standardized expressions registered in the glossary
  - **Untranslated string count**: Trend of untranslated strings detected by CI
- **Rule 74.187A**: Visualize translation diffs in PRs so reviewers can easily verify language changes

---

## Part XIX: Type-Safe i18n & Translation Key Design

### 19.1. Translation Resource Externalization Mandate

- **Rule 74.190**: All user-facing text MUST be separated from source code into **external translation resource files** (JSON/YAML/PO, etc.)
- **Rule 74.191**: Translation resource file placement convention:

```
src/
  locales/
    en/
      common.json      # Common text
      auth.json         # Authentication-related
      errors.json       # Error messages
      validation.json   # Validation
    ja/                 # Japanese version (if needed)
      common.json
      ...
```

### 19.2. TypeScript Type-Safe Translation Keys

- **Rule 74.192**: Translation keys MUST guarantee **compile-time safety** via TypeScript's type system
- **Rule 74.193**: References to non-existent translation keys MUST be detected as **compile errors**

```typescript
// ✅ Type-safe translation keys (next-intl example)
import { useTranslations } from 'next-intl';

function LoginForm() {
  const t = useTranslations('auth.login');
  return (
    <form>
      <label>{t('email_label')}</label>  {/* Type-checked */}
      <button>{t('submit')}</button>     {/* Type-checked */}
    </form>
  );
}

// ❌ Non-type-safe translation key
const label = t('auth.login.emial_label'); // Typo → compile error detection
```

### 19.3. ICU MessageFormat 2.0 Compliance

- **Rule 74.194**: Dynamic messages (containing plurals, gender, dates, etc.) MUST use ICU MessageFormat 2.0
- **Rule 74.195**: String concatenation for dynamic message construction is **prohibited**

```json
{
  "itemCount": "{count, plural, =0 {No items} one {1 item} other {{count} items}}",
  "greeting": "{time, select, morning {Good morning} afternoon {Good afternoon} evening {Good evening}}, {name}"
}
```

### 19.4. Translation Key Orphan Detection

- **Rule 74.196**: Translation keys not referenced by code (orphan keys) MUST be auto-detected in CI and periodically removed
- **Rule 74.197**: Addition and deletion of translation keys are subject to PR review and must maintain glossary consistency

### 19.5. Translation Resource Schema Validation

- **Rule 74.198**: Perform JSON schema validation on translation resource files to detect missing required keys and type mismatches

### 19.6. i18n Library Selection Criteria

- **Rule 74.199**: i18n library selection is evaluated against the following criteria:

| Criterion | Evaluation Points |
|---|---|
| Type safety | TypeScript type inference for translation key auto-completion and validation |
| ICU MF2.0 support | Full support for plurals, gender, ordinals |
| SSR/RSC support | Translation resolution in Server Components / SSR |
| Bundle size | Tree shaking support, per-language split loading |
| Ecosystem | Community size, maintenance frequency |

---

## Part XX: AI Inter-Agent & Agent-to-Agent Language Protocol

### 20.1. Multi-Agent Environment Language Rules

- **Rule 74.200**: In multi-agent systems (environments where multiple AI agents collaborate), inter-agent communication language follows these rules:
  - **User-facing output**: Project Native Language (Part XI compliant)
  - **Internal inter-agent communication**: English recommended (ensuring standardization for structured data exchange)
  - **Agent-to-human reporting**: Project Native Language

### 20.2. A2A / MCP / ACP Protocol Language Rules

- **Rule 74.201**: When using standard protocols such as Agent-to-Agent (A2A), Model Context Protocol (MCP), Agent Communication Protocol (ACP):
  - Protocol metadata and schema definitions in **English**
  - User-facing content within payloads in the **Project Native Language**
  - Agent capability descriptions (Agent Cards, etc.) in **English** for international compatibility

### 20.3. Agent Output Language Verification

- **Rule 74.202**: Verify language compliance at the gateway layer before delivering agent final output to users
- **Rule 74.203**: Output that fails language verification is replaced with a fallback message (in the Project Native Language)

---

## Part XXI: Multilingual Safety Guardrails

### 21.1. LLM Output Language Enforcement

- **Rule 74.205**: User-facing LLM applications MUST implement **guardrails** to enforce output in the Project Native Language
- **Rule 74.206**: Guardrail implementation methods:
  1. **Language specification in system prompt** (first defense line)
  2. **Post-output language verification middleware** (second defense line)
  3. **User feedback-based language correction** (third defense line)

### 21.2. Multilingual Prompt Injection Defense

- **Rule 74.207**: Implement defenses against prompt injection attacks via language switching (guardrail bypass through language change)
- **Rule 74.208**: Defense methods:
  - Input language detection and verification
  - Language-agnostic semantic safety classification
  - Periodic evaluation using multilingual safety benchmarks (PolyGuard, etc.)

### 21.3. Multilingual Content Moderation

- **Rule 74.209**: User-generated content (UGC) moderation MUST cover the Project Native Language plus all expected input languages
- **Rule 74.210**: Multilingual toxicity detection and prohibited word filtering define safety criteria in the Project Native Language

---

## Part XXII: PDF, CSV & Report Export Language

### 22.1. PDF Export

- **Rule 74.215**: PDF report text MUST be output in the **Project Native Language**
- **Rule 74.216**: PDF fonts MUST use fonts capable of accurately rendering the complete character set of the Project Native Language
  - Japanese projects: Embed Unicode-compatible fonts such as Noto Sans JP / Noto Serif JP
  - **Prohibited**: Relying on system fonts (risk of rendering failure due to environment differences)
- **Rule 74.217**: PDF headers, footers, and page number notation MUST also be in the Project Native Language

### 22.2. CSV Export

- **Rule 74.218**: CSV column headers MUST be in the **Project Native Language**
- **Rule 74.219**: CSV encoding should be UTF-8 with BOM (recommended for Excel compatibility)
- **Rule 74.220**: Date and number formats MUST follow the Project Native Language locale

### 22.3. Excel Export

- **Rule 74.221**: Excel sheet names and column headers MUST be in the **Project Native Language**
- **Rule 74.222**: Excel cell formats (dates, currency, etc.) MUST be set to the Project Native Language locale

### 22.4. Receipts & Invoices

- **Rule 74.223**: Receipt and invoice templates MUST be in the **Project Native Language**
- **Rule 74.224**: Documents with legal requirements (e.g., tax notation) MUST also comply with the language requirements of the applicable jurisdiction

---

## Part XXIII: Legal & Contractual Document Language Governance

### 23.1. Terms of Service & Privacy Policy

- **Rule 74.225**: Explicitly define the language of the **legally authoritative version** for Terms of Service and Privacy Policy
- **Rule 74.226**: When providing multilingual versions, explicitly state in each translation that "In case of conflict, the [authoritative language] version prevails"
- **Rule 74.227**: Legal document translations MUST NOT rely solely on AI generation; legal expert review is mandatory

### 23.2. SLA & Contracts

- **Rule 74.228**: Define the authoritative version language for SLAs (Service Level Agreements) and specify legal priority against translated versions
- **Rule 74.229**: Adopt a bilingual notation approach for untranslatable legal terminology in contracts

### 23.3. Cookie Consent & Legal Notices

- **Rule 74.230**: Cookie consent banners and legal notices MUST be displayed in the **Project Native Language**
- **Rule 74.231**: Privacy regulation-required notices (GDPR/APPI, etc.) MUST be provided in the target users' language

---

## Part XXIV: Mobile-Specific Language Protocol

### 24.1. iOS Language Protocol

- **Rule 74.235**: iOS translation resources use `Localizable.strings` / `Localizable.stringsdict` (for plurals) / Xcode String Catalogs
- **Rule 74.236**: `Info.plist` localizable properties (`CFBundleDisplayName`, `CFBundleShortVersionString`, etc.) MUST be set in the Project Native Language
- **Rule 74.237**: App Store Connect app name, subtitle, description, and keywords MUST be provided in the Project Native Language

### 24.2. Android Language Protocol

- **Rule 74.238**: Android translation resources are placed in `res/values-{locale}/strings.xml`
- **Rule 74.239**: `res/values/strings.xml` (default) MUST be written in the Project Native Language
- **Rule 74.240**: Google Play store listing (title, short description, full description) MUST be provided in the Project Native Language

### 24.3. Flutter / React Native / KMP

- **Rule 74.241**: Flutter uses ARB (Application Resource Bundle) files and implements type-safe translations via `intl` package or `slang`
- **Rule 74.242**: React Native uses `react-i18next` + `i18next` for translation resource management
- **Rule 74.243**: KMP (Kotlin Multiplatform) uses `moko-resources` or similar multiplatform translation libraries

### 24.4. Device Language Detection & Application

- **Rule 74.244**: On mobile app launch, detect the device language setting and match against supported languages
- **Rule 74.245**: For unsupported languages, fall back to the project default language

---

## Part XXV: Maturity Model & Anti-Patterns

### 25.1. Language Protocol Maturity Model (5 Levels)

| Level | Name | Characteristics |
|---|---|---|
| **L1: Ad-hoc** | Ad-hoc | No language policy. English/native language mixed based on developer preference |
| **L2: Basic** | Basic | UI layer localization only. Validation/error messages remain in English |
| **L3: Standardized** | Standardized | Three-layer model applied. Glossary established. CI scan introduced. Enum/status label maps complete |
| **L4: Managed** | Managed | Language policy applied across all layers. Quality scoring introduced. Translation drift auto-detection |
| **L5: Optimized** | Optimized | AI-powered language quality auto-verification. Zero untranslated maintenance. Microcopy A/B testing. Type-safe i18n complete. MTPE workflow finalized |

### 25.1A. MTPE (Machine Translation Post-Editing) Quality Classification

- **Rule 74.252**: Operate MTPE in two tiers (Light/Full) based on content criticality:

| Level | Target | Criteria |
|---|---|---|
| **Light PE** | Internal tools, developer docs, FAQs | Focus on accuracy and readability only |
| **Full PE** | UI text, legal documents, marketing | Native-equivalent quality including style and tone optimization |

### 25.2. 20 Major Anti-Patterns

| # | Anti-Pattern Name | Description | Countermeasure Section |
|---|---|---|---|
| 1 | **Lazy Translation** | Placeholder English from development persists into production | Part XVIII |
| 2 | **CSS Uppercase Trick** | Using CSS `uppercase` to style English constants for display | Part VII §7.3 |
| 3 | **Validation Leak** | Zod default English messages leak to users | Part VII §7.1 |
| 4 | **Terminology Chaos** | Multiple notations for the same concept coexist | Part VI |
| 5 | **Fallback Exposure** | `"Unknown"`, `"N/A"` displayed to users | Part V §5.4 |
| 6 | **Ghost English** | Hidden text like `aria-label`, `alt`, `title` remains in English | Part XVI |
| 7 | **Log Language Confusion** | Mixed Project Native Language and English in logs | Part XII |
| 8 | **AI Language Drift** | AI agent unintentionally responds in English | Part XI |
| 9 | **Commit Message Chaos** | Inconsistent commit message language | Part IV |
| 10 | **Error Layer Bleed** | Internal English error messages leak into the UI | Part VIII |
| 11 | **Plural Blindness** | String concatenation ignoring plural rules | Part VII §7.5 |
| 12 | **Font Fallback Hell** | Character rendering failure in PDF/CJK due to unembedded fonts | Part XXII §22.1 |
| 13 | **Translation Key Orphan** | Accumulation of translation keys not referenced by code | Part XIX §19.4 |
| 14 | **Hardcoded String** | Strings hardcoded in source without translation resources | Part XIX §19.1 |
| 15 | **Legal Translation Gap** | Translated version of Terms of Service diverges from authoritative version | Part XXIII |
| 16 | **DB Mixed Language** | English and native language mixed in DB table/column names | Part XXVI |
| 17 | **Design Token Gap** | Design tokens not i18n-aware causing layout breakage | Part XXVII |
| 18 | **Translation Bundle Bloat** | Loading all language resources at once causing performance degradation | Part XXIX |
| 19 | **Unicode Normalization Mismatch** | NFC/NFD inconsistency causing search/comparison failures | Part XXXI |
| 20 | **Gender Bias Leakage** | Gender bias remaining in AI-generated text | Part XXXII |

### 25.3. Periodic Audit Protocol

- **Rule 74.250**: Conduct a language protocol compliance audit quarterly
- **Rule 74.251**: Audit items:
  1. Untranslated string scan results
  2. Glossary currency
  3. Language quality of newly added components
  4. Anti-pattern detection count trends
  5. Translation key orphan count
  6. Legal document synchronization status
  7. DB schema language consistency (Part XXVI)
  8. Design token i18n compliance (Part XXVII)

---

## Part XXVI: Database & Infrastructure Language Policy

### 26.1. Database Schema Language Conventions

- **Rule 74.260**: Table names, column names, index names, and constraint names MUST be in **English snake_case**
- **Rule 74.261**: Table names use English **plurals** (`users`, `pet_health_checkups`)
- **Rule 74.262**: Column names use English with **descending specificity** (`user_id`, `created_at`, `is_active`)
- **Rule 74.263**: Non-English (including romanized) table/column names are **strictly prohibited**
  - ❌ `kensaku_rireki`, `user_jouhou`, `shouhin`
  - ✅ `search_history`, `user_info`, `products`

### 26.2. Migration & Seed Language

- **Rule 74.264**: Migration file names are in **English** (`20260318_add_reminder_interval`)
- **Rule 74.265**: Comments within migrations are in **English**
- **Rule 74.266**: Seed data user-facing fields (names, descriptions, etc.) use realistic data in the **Project Native Language**

### 26.3. Enum Types & Status Values

- **Rule 74.267**: Enum values and status codes stored in DB are in **English lowercase snake_case**
  - ✅ `active`, `pending_review`, `cancelled`
  - ❌ Non-English enum values
- **Rule 74.268**: Mapping between DB stored values and UI display labels is handled at the application layer (Part VII §7.3 compliant)

### 26.4. Infrastructure as Code (IaC) Language

- **Rule 74.269**: Terraform / AWS CDK / Pulumi resource names and variable names are in **English**
- **Rule 74.270**: IaC comments are in **English** (treated as system layer)
- **Rule 74.271**: CloudFormation / Kubernetes YAML labels and annotations are in **English**

### 26.5. Environment Variables & Configuration Files

- **Rule 74.272**: Environment variable names are in **English SCREAMING_SNAKE_CASE** (`DATABASE_URL`, `API_SECRET_KEY`)
- **Rule 74.273**: Configuration file comments (`.env`, `config.yaml`, etc.) are in **English**

---

## Part XXVII: Design System & Design Token i18n

### 27.1. Design Token Language Adaptation

- **Rule 74.275**: Design tokens MUST support value overrides based on language/locale
- **Rule 74.276**: The following token categories MUST have mandatory i18n support:

| Category | i18n Content |
|---|---|
| **Typography** | Language-specific font stacks (CJK: Noto Sans JP, Latin: Inter, etc.) |
| **Spacing** | Minimum widths and padding accommodating text expansion |
| **Direction** | Logical properties for `ltr`/`rtl` (`margin-inline-start`, etc.) |
| **Line Height** | CJK-optimized line spacing (CJK: ≥1.8, Latin: ≥1.5) |

### 27.2. Component API Language Design

- **Rule 74.277**: Component prop names are in **English** (`label`, `placeholder`, `errorMessage`)
- **Rule 74.278**: Components MUST NOT have default text; always inject from translation resources
  - ❌ `<Button>Submit</Button>` (hardcoded)
  - ✅ `<Button>{t('common.button.submit')}</Button>` (via translation key)

### 27.3. Figma Integration & Translation Flow

- **Rule 74.279**: Attach translation keys as metadata to Figma text layers to maintain design-to-implementation translation consistency
- **Rule 74.280**: During design review, verify that text is in the Project Native Language

---

## Part XXVIII: Error Recovery & Graceful Degradation Language

### 28.1. Translation File Load Failure Fallback

- **Rule 74.285**: Define a fallback strategy for translation resource file load failures:

```
1. Use cached translation resources (Service Worker / localStorage)
2. Use inline-embedded critical translations (minimal UI strings)
3. Last resort: Display hard-coded fallback messages
```

- **Rule 74.286**: Fallback messages MUST be hard-coded in the **Project Native Language**

### 28.2. CDN Outage Language Resource Availability

- **Rule 74.287**: When distributing translation resources via CDN, configure fallback to origin server for CDN outages
- **Rule 74.288**: Critical translation resources (error pages, auth flows, etc.) MUST be included in the bundle

### 28.3. Offline Language Resource Caching

- **Rule 74.289**: For PWA/offline-capable apps, implement Service Worker pre-caching of translation resources
- **Rule 74.290**: Explicitly define the scope of translations available offline

---

## Part XXIX: Performance Optimization & Bundle Strategy

### 29.1. Translation Resource Code Splitting

- **Rule 74.295**: Translation resources MUST be code-split **per page/route** to load only required translations
- **Rule 74.296**: Separate common translations (`common.json`) from page-specific translations (`auth.json`, `dashboard.json`, etc.)

```typescript
// ✅ Recommended: Per-route translation loading
// next-intl example
export async function getMessages(locale: string) {
  return {
    ...(await import(`@/locales/${locale}/common.json`)).default,
    ...(await import(`@/locales/${locale}/${getCurrentRoute()}.json`)).default,
  };
}
```

### 29.2. Bundle Size Management

- **Rule 74.297**: Monitor translation resource bundle size with a target of **under 50KB per language**
- **Rule 74.298**: Implement tree shaking for unused translation keys where possible

### 29.3. Translation Resource Cache Strategy

- **Rule 74.299**: Apply **content-hash-based cache busting** to translation resources
- **Rule 74.300**: Set `Cache-Control: public, max-age=31536000, immutable` for translation resources

---

## Part XXX: Team Education & Onboarding Language Protocol

### 30.1. New Member Onboarding

- **Rule 74.305**: Include language protocol overview and required reading sections in new member onboarding materials
- **Rule 74.306**: Provide focused language protocol compliance feedback during first PR reviews

### 30.2. PR Review Language Checklist

- **Rule 74.307**: Apply the following language checklist to PR reviews:
  - [ ] Is UI text in the Project Native Language?
  - [ ] Do validation messages have explicit `message` set?
  - [ ] Are Enum/status values displayed via label maps?
  - [ ] Are `aria-label` / `alt` in the Project Native Language?
  - [ ] Are log messages in English?
  - [ ] Are new translation keys consistent with the glossary?

### 30.3. Language Protocol Violation Graduated Correction

- **Rule 74.308**: Correct language protocol violations in the following priority order:
  1. **P0 (Immediate fix)**: User-facing English leakage (validation, error messages)
  2. **P1 (Next sprint)**: Hidden text English remnants (`aria-label`, `alt`)
  3. **P2 (Planned)**: Log language inconsistency, commit message inconsistency

---

## Part XXXI: Character Encoding & Unicode Safety

### 31.1. Encoding Basic Conventions

- **Rule 74.310**: Unify **UTF-8** as the default encoding across the entire project
- **Rule 74.311**: BOM (Byte Order Mark) is **not used** except for CSV output requiring Excel compatibility
- **Rule 74.312**: Require `.editorconfig` configuration that auto-applies **UTF-8 (without BOM)** on file save

```ini
# .editorconfig
[*]
charset = utf-8

[*.csv]
charset = utf-8-bom
```

### 31.2. Unicode Normalization

- **Rule 74.313**: Normalize user input text to **NFC (Canonical Decomposition followed by Canonical Composition)** before storage
- **Rule 74.314**: Execute search and comparison operations on NFC-normalized text
  - Rationale: macOS uses NFD while Windows uses NFC; without normalization, composed vs decomposed characters cause mismatches

### 31.3. Dangerous & Control Character Removal

- **Rule 74.315**: Remove or detect zero-width characters (ZWJ, ZWNJ, ZWSP, etc.) from user input
- **Rule 74.316**: Implement Homograph Attack (homoglyph attack) defense for usernames and display names
  - Example: Latin `a` vs Cyrillic `а` (visually identical but different code points)
- **Rule 74.317**: Sanitize bidirectional text control characters (RLO, LRO, RLE, LRE, PDF, etc.)

### 31.4. Emoji Consistency

- **Rule 74.318**: Consider cross-platform emoji display differences; do not rely solely on emoji for semantic meaning in important UI
- **Rule 74.319**: When using emoji, provide `aria-label` text alternatives

---

## Part XXXII: Gender-Inclusive & Inclusive Language

### 32.1. Gender-Neutral Expression

- **Rule 74.320**: Use gender-neutral expressions in UI text and documentation
  - English: Use `they/them` as singular pronouns; `chairman` → `chairperson`
  - Other languages: Use expressions that do not presuppose gender

### 32.2. Inclusive Technical Terminology

- **Rule 74.321**: Use inclusive alternatives for technical terminology:

| ❌ Legacy Term | ✅ Inclusive Alternative |
|---|---|
| master/slave | primary/replica, leader/follower |
| whitelist/blacklist | allowlist/denylist |
| sanity check | confidence check, validation |
| dummy | placeholder, sample |

### 32.3. AI-Generated Text Bias Detection

- **Rule 74.322**: Perform gender bias and cultural bias detection on AI-generated UI text and content
- **Rule 74.323**: Recommend integration with bias detection tools (Dottxt/Guardrails, etc.)

### 32.4. Cultural Sensitivity Guidelines

- **Rule 74.324**: For multicultural projects, observe the following cultural sensitivities:
  - Cultural meaning of colors (red = danger is not universal)
  - Culture-dependent gestures and icons
  - Date format order (MM/DD vs DD/MM vs YYYY/MM/DD)
  - Name structure (family→given vs given→family, middle name presence)

### 32.5. Intersectionality Considerations

- **Rule 74.324A**: Recognize that individuals have multiple intersecting identities (intersectionality) and avoid expressions that categorize people by a single attribute
- **Rule 74.324B**: The choice between identity-first language (e.g., "disabled person") and person-first language (e.g., "person with a disability") should respect the preferences of the target community
- **Rule 74.324C**: Personal information form fields should provide free-text options and include a "prefer not to answer" option. Default to "Full name" rather than forcing first/last name separation

---

## Part XXXIII: Real-Time, WebSocket & SSE Language Protocol

### 33.1. Real-Time Event Language

- **Rule 74.330**: Real-time events sent via WebSocket/SSE follow these rules:
  - **User-facing messages**: Project Native Language
  - **System events (heartbeat, reconnect, etc.)**: English
  - **Event type names**: English (`message`, `notification`, `status_change`)

### 33.2. Chat & Message Language Detection

- **Rule 74.331**: In multi-user chat features, each message's language depends on the sender's language setting (no translation required)
- **Rule 74.332**: System-generated chat messages (join/leave notifications, etc.) are displayed in the recipient's Project Native Language

### 33.3. Live Translation Flow

- **Rule 74.333**: When real-time translation is required, execute translation server-side and deliver translated text to clients
- **Rule 74.334**: When translation delay occurs, display the original text first and replace with translated text upon completion (progressive display)

---

## Part XXXIV: Micro-Frontend & Module Federation i18n

### 34.1. Translation Resource Sharing Strategy

- **Rule 74.340**: In micro-frontend architectures, define a translation resource sharing layer:
  - **Shared layer**: Translations common to all micro-frontends (navigation, footer, common buttons, etc.)
  - **Owned layer**: Translations specific to each micro-frontend

### 34.2. Translation Key Namespace Collision Prevention

- **Rule 74.341**: Prefix each micro-frontend's translation keys to prevent namespace collisions
  - `mfe-auth.login.title`, `mfe-dashboard.overview.title`
- **Rule 74.342**: Shared translation keys use the `shared.` prefix

### 34.3. Module Federation Translation Loading

- **Rule 74.343**: When using Module Federation, expose translation resources as remote entries for dynamic loading by host applications
- **Rule 74.344**: Detect translation resource version mismatches and implement automatic fetching of new versions

---

## Part XXXV: AI Translation Quality Assurance & LQA

### 35.1. AI Translation Quality Standards

- **Rule 74.350**: AI (LLM) translation output MUST meet the following LQA (Linguistic Quality Assurance) standards:
  - **Accuracy**: Source meaning is conveyed accurately
  - **Fluency**: Natural and readable in the target language
  - **Terminology consistency**: Alignment with project glossary
  - **Style conformance**: Compliance with Voice & Tone guidelines (Part V §5.3)

### 35.2. MQM Scoring

- **Rule 74.351**: Quantitatively evaluate translation quality based on the MQM (Multidimensional Quality Metrics) framework
- **Rule 74.352**: MQM error classification:

| Category | Subcategory | Severity |
|---|---|---|
| Accuracy | Mistranslation, addition, omission | Critical/Major |
| Fluency | Grammar, punctuation, spelling | Major/Minor |
| Terminology | Consistency, project terms | Major |
| Style | Guideline violation | Minor |
| Locale | Formatting, units | Major |

### 35.3. Human Review Hybrid Workflow

- **Rule 74.353**: Standard AI translation workflow follows these 3 stages:
  1. **AI Translation**: Initial translation generation by LLM
  2. **Automated QA**: Glossary check, style check, MQM scoring
  3. **Human Review**: Final confirmation by domain expert or UX writer
- **Rule 74.354**: Critical UI copy (legal, safety, brand messaging) **requires human review**

### 35.4. AI Translation Feedback Loop

- **Rule 74.355**: Accumulate AI translation correction history as feedback data for continuous translation quality improvement
- **Rule 74.356**: Register frequently occurring correction patterns in Translation Memory (TM) to prevent recurrence

### 35.5. LLM-as-Judge Automated Quality Evaluation

- **Rule 74.356A**: Use LLMs as quality judges for automated MQM score prediction and sentence-level error type detection
- **Rule 74.356B**: LLM-as-Judge evaluation results are reference values; final judgment is made by human reviewers (especially for legal, safety, and brand content)

### 35.6. Translation Risk Classification & Portfolio Strategy

- **Rule 74.356C**: Classify translation strategies based on content risk level:

| Risk | Content Examples | Translation Strategy |
|---|---|---|
| **Critical** | Legal documents, safety warnings, medical info | Human translation required + Full PE |
| **High** | UI text, marketing, brand | AI translation + Full PE + human review |
| **Medium** | Help text, FAQ, tooltips | AI translation + Light PE |
| **Low** | Internal tools, developer docs | AI translation only (with monitoring) |

- **Rule 74.356D**: Recommend a portfolio strategy using multiple translation engines. Optimize quality and cost through automatic routing based on content type and language pair

---

## Part XXXVI: Voice UI, TTS/SSML Language Protocol

### 36.1. TTS (Text-to-Speech) Language Control

- **Rule 74.360**: Default TTS output language is the Project Native Language
- **Rule 74.361**: When language switching occurs during a session, explicitly specify the language using SSML `<lang>` tags
- **Rule 74.362**: TTS voice selection MUST use native speaker voices for the Project Native Language

### 36.2. SSML Markup Language Requirements

- **Rule 74.363**: When using SSML (Speech Synthesis Markup Language), the `xml:lang` attribute MUST be set
- **Rule 74.364**: Control pronunciation of foreign proper nouns using `<phoneme>` or `<say-as>` tags

```xml
<!-- ✅ SSML language switching example -->
<speak xml:lang="ja-JP">
  こんにちは。
  <lang xml:lang="en-US">Welcome to our service.</lang>
  ご利用ありがとうございます。
</speak>

<!-- ✅ Foreign proper noun pronunciation control -->
<speak xml:lang="ja-JP">
  <phoneme alphabet="ipa" ph="ɡuːɡl">Google</phoneme>のサービスです。
</speak>
```

### 36.3. Voice Assistant Platform Compliance

- **Rule 74.365**: Alexa Skills / Google Actions dialog models are defined in the Project Native Language
- **Rule 74.366**: Voice assistant intent names and slot type names are in **English** (technical layer)
- **Rule 74.367**: User interaction utterance models (sample utterances) are in the **Project Native Language**

### 36.4. Voice UI Error Messages

- **Rule 74.368**: Voice UI error messages follow Part VIII hierarchy; user-facing messages are in the Project Native Language
- **Rule 74.369**: For audibility, voice messages should use short sentences, clear wording, and repetitive structure

---

## Part XXXVII: Serverless & Edge Computing Language Policy

### 37.1. Edge Functions Language Resource Management

- **Rule 74.370**: Translation resources in Edge Functions (Cloudflare Workers, Vercel Edge Functions, Lambda@Edge, etc.) are maintained as language variants in the edge cache
- **Rule 74.371**: Language detection at the edge is based on `Accept-Language` header or Geo-IP
- **Rule 74.372**: Include language code in edge cache keys for translation resources (`cache-key: /page:ja`, `/page:en`)

### 37.2. Geo-based Language Routing

- **Rule 74.373**: Language routing at CDN / Edge Router level prioritizes user-configured language; Geo-IP is a fallback only
- **Rule 74.374**: Always provide a language override option (language switch UI) for Geo-based language estimation

### 37.3. Serverless Function Language Context

- **Rule 74.375**: Include language context (`locale`, `language`) in serverless function event payloads
- **Rule 74.376**: In function chains (Step Functions, Workflows), propagate language context across the entire state

### 37.4. Edge SSR/ISR Language Support

- **Rule 74.377**: During Edge SSR (Server-Side Rendering) page generation, include only critical translations in the bundle as translation resource loading impacts cold start time
- **Rule 74.378**: In ISR (Incremental Static Regeneration), separate caches by language

---

## Part XXXVIII: 3D, Metaverse & Spatial Computing Language

### 38.1. Spatial UI Text Language

- **Rule 74.380**: 3D spatial UI text in visionOS / Meta Quest / WebXR, etc., is in the **Project Native Language**
- **Rule 74.381**: Text rendering in 3D space MUST embed fonts to prevent CJK glyph fallback failures
- **Rule 74.382**: Text size in spatial UI MUST guarantee readability based on viewing distance (minimum angular size criteria)

### 38.2. XR Content Language Metadata

- **Rule 74.383**: Include language information in 3D asset metadata (glTF / USD, etc.)
- **Rule 74.384**: AR (augmented reality) overlay text is in the Project Native Language

### 38.3. Spatial Audio Language

- **Rule 74.385**: Spatial audio voice guides and narrations are in the Project Native Language
- **Rule 74.386**: Subtitles/captions in spatial UI follow the user's field of view and display in the Project Native Language

---

## Part XXXIX: Healthcare & Regulated Domain Language

### 39.1. Healthcare Domain Language Requirements

- **Rule 74.390**: Set the `language` field in HL7 FHIR resources to the Project Native Language's BCP 47 tag
- **Rule 74.391**: Medical terminology translations MUST comply with official localized versions of SNOMED CT / ICD-11
- **Rule 74.392**: Patient-facing UI (portals, test result displays) MUST be in the **Project Native Language**. Provide medical abbreviation expansions

### 39.2. Financial Domain Language Requirements

- **Rule 74.393**: SWIFT / ISO 20022 message fields are in **English** (international standard)
- **Rule 74.394**: Financial regulatory documents (important explanatory documents, etc.) MUST be provided in the language required by applicable laws
- **Rule 74.395**: Currency display uses `Intl.NumberFormat` for locale-aware formatting (Part VII §7.5 compliant)

### 39.3. Regulatory Compliance Language

- **Rule 74.396**: Privacy policies for GDPR / APPI / CCPA, etc., have an obligation to be provided in the target users' language
- **Rule 74.397**: Language of documents submitted to regulatory authorities (FDA / PMDA, etc.) follows regulatory requirements

---

## Part XL: Third-Party SDK & Widget Language Governance

### 40.1. Payment SDK Language Settings

- **Rule 74.400**: Set Stripe Elements `locale` parameter to the Project Native Language
- **Rule 74.401**: Unify display language of PayPal / Square and other payment widgets to the Project Native Language
- **Rule 74.402**: When payment SDK error messages default to English, translate them via custom error handling

### 40.2. Maps & Location SDKs

- **Rule 74.403**: Set Google Maps JavaScript API `language` parameter to the Project Native Language
- **Rule 74.404**: Unify language settings for Mapbox / leaflet and other map SDKs similarly

### 40.3. Authentication & Security Widgets

- **Rule 74.405**: Set reCAPTCHA `hl` parameter to the Project Native Language
- **Rule 74.406**: Customizable text in OAuth consent screens is in the Project Native Language

### 40.4. Customer Support Widgets

- **Rule 74.407**: Set display language of Intercom / Zendesk / Freshdesk and other chat widgets to the Project Native Language
- **Rule 74.408**: When third-party widget language settings are not configurable, document the constraint

### 40.5. Centralized Language Configuration

- **Rule 74.409**: Define a configuration file or environment variables to centrally manage language settings for all third-party SDKs

```typescript
// ✅ Centralized third-party SDK language configuration
const LOCALE_CONFIG = {
  projectLanguage: 'ja',
  stripe: { locale: 'ja' },
  googleMaps: { language: 'ja', region: 'JP' },
  recaptcha: { hl: 'ja' },
  intercom: { language_override: 'ja' },
} as const;
```

---

## Part XLI: Translation Cost Management & FinOps

### 41.1. Translation API Usage Monitoring

- **Rule 74.410**: Monitor translation API (Google Translate API, DeepL API, OpenAI, etc.) usage and costs monthly
- **Rule 74.411**: Set budget caps (budget alerts) for translation API costs
- **Rule 74.412**: Prevent unnecessary translation API calls (duplicate translations of identical text, etc.) through caching

### 41.2. AI Translation vs Human Translation Cost Comparison

- **Rule 74.413**: Periodically evaluate cost-effectiveness of AI vs human translation by content type

| Metric | AI Translation | Human Translation |
|---|---|---|
| Cost per word | Low ($0.001–0.02) | High ($0.05–0.30) |
| Turnaround | Seconds to minutes | Hours to days |
| Quality (general text) | High | Highest |
| Quality (legal/brand) | Medium to High | Highest |
| Scalability | High | Low |

### 41.3. Translation ROI Measurement

- **Rule 74.414**: Measure translation investment ROI using the following metrics:
  - User satisfaction (NPS/CSAT comparison by language)
  - Support ticket reduction rate (due to language quality improvement)
  - Conversion rate differences by language
- **Rule 74.415**: Build a translation cost dashboard to visualize cost trends by language and content type

---

## Part XLII: Language-Related Incident Response

### 42.1. Incident Definition

- **Rule 74.420**: Define the following as language-related incidents:
  - **P0 (Emergency)**: Missing translations for legal documents/safety warnings leaked to production
  - **P1 (Critical)**: Extensive English remaining across user-facing UI
  - **P2 (Medium)**: Validation messages on specific screens displayed in English
  - **P3 (Minor)**: Translation omissions in `aria-label` or `alt` text

### 42.2. Incident Response Flow

- **Rule 74.421**: Language-related incident response flow:

```
1. Detection → CI / User report / Monitoring alert
2. Triage → Severity classification (P0–P3)
3. Immediate response → Apply fallback text or hotfix
4. Root cause fix → Add translation resources / Strengthen CI rules
5. Postmortem → Document preventive measures
```

### 42.3. Postmortem & Prevention

- **Rule 74.422**: Conduct a postmortem for P0/P1 incidents and document:
  - Root cause (missing CI gates, review oversights, etc.)
  - Impact scope (number of affected users/screens)
  - Preventive measures (CI rule additions, checklist updates, etc.)
- **Rule 74.423**: Record postmortem lessons in `010_project_lessons_log.md`

---

## Part XLIII: Speech Recognition (STT) Input Language Protocol

### 43.1. Voice Input Language Detection

- **Rule 74.430**: Voice input features MUST explicitly specify the recognition target language (do not rely on automatic language detection)
- **Rule 74.431**: Default recognition language is the Project Native Language
- **Rule 74.432**: When multilingual voice input is required, provide a language switch UI

### 43.2. STT Result Text Conversion

- **Rule 74.433**: Apply NFC normalization to speech recognition result text (Part XXXI §31.2 compliant)
- **Rule 74.434**: When speech recognition confidence is low, display a confirmation UI to the user (in the Project Native Language)

### 43.3. Voice Command Language Design

- **Rule 74.435**: Design voice commands (wake words, action commands) in the Project Native Language
- **Rule 74.436**: Register pronunciation variations for technical terms in voice input (e.g., "ワイファイ" / "WiFi")

---

## Appendix A: Quick Reference Index

### Topic-Based Quick Reference

| What You Want To Do | Reference |
|---|---|
| Know the language for UI/buttons/labels | Part V: UI/UX Localization Mandate |
| Write validation error messages | Part VII §7.1 |
| Display enums and statuses | Part VII §7.3 |
| Determine error message language | Part VIII: Error Handling Language Hierarchy |
| API response language | Part IX: API Response Language Policy |
| Log language | Part XII §12.1 |
| Write commit messages | Part IV §4.1 |
| PR language | Part IV §4.3 |
| AI agent language | Part XI |
| Test code language | Part XIII |
| Unsure whether to translate | Part XVII: Translation Exclusion Policy |
| Ensure language quality in CI | Part XVIII: CI/CD Language Quality Gate |
| Email/notification language | Part X: Notification Policy |
| SEO metadata language | Part XV: SEO & Structured Data Language |
| Accessibility language | Part XVI: Accessibility Language Requirements |
| Design type-safe translation keys | Part XIX: Type-Safe i18n & Translation Key Design |
| AI inter-agent communication language rules | Part XX: AI Inter-Agent & A2A Language Protocol |
| Enforce LLM output language | Part XXI: Multilingual Safety Guardrails |
| PDF/CSV export language | Part XXII: PDF, CSV & Report Export Language |
| Terms of Service translation rules | Part XXIII: Legal Document Language Governance |
| Mobile app language settings | Part XXIV: Mobile-Specific Language Protocol |
| DB/table/column name language | Part XXVI: Database & Infrastructure Language Policy |
| Design token i18n | Part XXVII: Design System i18n |
| Translation file failure handling | Part XXVIII: Error Recovery |
| Translation resource performance | Part XXIX: Performance Optimization |
| Educate team on language rules | Part XXX: Team Education |
| Character encoding safety | Part XXXI: Unicode Safety |
| Gender-inclusive expressions | Part XXXII: Inclusive Language |
| Real-time language rules | Part XXXIII: WebSocket Language Protocol |
| Micro-frontend translation sharing | Part XXXIV: MFE i18n |
| AI translation quality assurance | Part XXXV: AI Translation Quality Assurance & LQA |
| Voice UI / TTS / SSML language rules | Part XXXVI: Voice UI, TTS/SSML Language Protocol |
| Edge computing language settings | Part XXXVII: Serverless & Edge Language Policy |
| 3D / XR spatial language rules | Part XXXVIII: 3D, Metaverse & Spatial Computing Language |
| Healthcare / financial language requirements | Part XXXIX: Healthcare & Regulated Domain Language |
| Third-party SDK language settings | Part XL: Third-Party SDK & Widget Language Governance |
| Translation cost management | Part XLI: Translation Cost Management & FinOps |
| Language incident response | Part XLII: Language-Related Incident Response |
| Voice recognition input language rules | Part XLIII: Speech Recognition (STT) Input Language Protocol |
| Assess language protocol maturity | Part XXV §25.1 |
| Common anti-patterns | Part XXV §25.2 |

### Cross-References (Related Rules)

| Related Rule | Referenced Content | Boundary with This Rule |
|---|---|---|
| [000_core_mindset.md](./000_core_mindset.md) | Zero Tolerance principle | This rule specifies Zero Tolerance for language aspects |
| [200_design_ux.md](./200_design_ux.md) | Accessibility & UX standards | This rule specializes in language aspects of accessibility |
| [300_engineering_standards.md](./300_engineering_standards.md) | Coding conventions | This rule specializes in language selection criteria |
| [301_api_integration.md](./301_api_integration.md) | API design standards | This rule specializes in API language policy |
| [320_supabase_architecture.md](./320_supabase_architecture.md) | DB design standards | This rule specializes in DB naming language policy |
| [400_ai_engineering.md](./400_ai_engineering.md) | AI implementation strategy | This rule specializes in AI communication language protocol |
| [501_customer_experience.md](./501_customer_experience.md) | Email delivery standards | This rule specializes in notification language policy |
| [600_security_privacy.md](./600_security_privacy.md) | Security standards | This rule specializes in multilingual safety guardrails |
| [800_internationalization.md](./800_internationalization.md) | i18n architecture & L10n infrastructure | 71 = international expansion infrastructure, 74 = language selection rules |
| [801_governance.md](./801_governance.md) Part XXII | Rule translation governance | 72 = translation management of rules themselves, 74 = product language protocol |

---
