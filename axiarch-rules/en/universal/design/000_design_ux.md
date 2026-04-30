# 20. Design & UX Strategy

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-04-19 (Rev 4)

> [!IMPORTANT]
> **Supreme Directive**
> "Design is not decoration — it is the user's first and last impression of quality."
> All design decisions must prioritize consistency, accessibility, and delight.
> Strictly follow the priority order: **Consistency > Accessibility > Delight > Aesthetics > Development Speed**.
> This document is the supreme standard for all design and UX strategy decisions.
> **37 Parts (§1–§37).**

---

## Table of Contents

| Part | Topic | Sections |
|------|-------|----------|
| I | Design Philosophy | §1 |
| II | Design Engineering | §2 |
| III | Component Implementation Guidelines | §3 |
| IV | Performance Animation | §4 |
| V | Adaptability & Foldables | §5 |
| VI | Accessibility & Inclusivity | §6 |
| VII | User Sovereignty & Ethical UX | §7 |
| VIII | Tools & Workflow | §8 |
| IX | AI UX Strategy | §9 |
| X | User Onboarding & Guidance | §10 |
| XI | Safety UI Protocols | §11 |
| XII | Hospitality UX | §12 |
| XIII | Design Ops & Tools | §13 |
| XIV | Interaction Safety Protocols | §14 |
| XV | Localization & Internationalization | §15 |
| XVI | Motion Token Architecture | §16 |
| XVII | Performance UX | §17 |
| XVIII | Spatial Computing & XR UX | §18 |
| XIX | UX Research & Measurement | §19 |
| XX | Maturity Model & Anti-Patterns | §20 |
| XXI | Design System Governance | §21 |
| XXII | Data Visualization & Information Architecture | §22 |
| XXIII | AI-Generated UI Governance | §23 |
| XXIV | Cross-Platform Token Federation | §24 |
| XXV | Sustainability & Green UX | §25 |
| XXVI | Neurodiversity & Inclusive UX | §26 |
| XXVII | Digital Wellbeing & Ethical Digital Design | §27 |
| XXVIII | Voice & Conversational UX | §28 |
| XXIX | Adaptive & Personalization UX | §29 |
| XXX | Design Tokens 2.0 / Advanced Token Architecture | §30 |
| XXXI | Edge & Offline-First Design | §31 |
| XXXII | Gamification Design Governance | §32 |
| XXXIII | Design QA & Visual Regression | §33 |
| XXXIV | Biometrics & Authentication UX | §34 |
| XXXV | Content Safety & Trust Design | §35 |
| XXXVI | Real-Time Collaboration UX | §36 |
| XXXVII | Platform Engineering & Design System Ops | §37 |

---

> [!WARNING]
> **Rule 20.0: The Consistency Mandate (Professionalism Protocol)**
>
> - **Law**: Inconsistency in UI/UX is a "Lack of Professionalism".
> - **Action**: Do not tolerate minor deviations such as "The button is on the left only on this screen" or "The delete flow is different only here". Elements that disrupt the overall Harmony are bugs, even if they function.
> - **Target**: Maintain "Iron Consistency" especially in critical flows like "Delete", "Save", and "Authentication" to protect the user's mental model.



## 1. Design Philosophy ("Silicon Valley Excellence & Google First")

### 1.1. The "Wow" Factor (Delight)
-   **Mandate**: All interactions must feel "alive". We build **dynamic experiences**, not static screens.
-   **Google Standard**: Adoption of **Material Design 3 (Material You)** and its evolution **"Expressive"**.
-   **Apple Standard**: Respect **Human Interface Guidelines (HIG)** on iOS. Maintain platform fidelity (e.g., switches, pickers).
-   **Differentiation**: While using Google's system, differentiate with **high-precision motion**, **custom shaders**, and **bold typography** to create "Silicon Valley Premium".
-   **The Typography Localization Protocol (Readability First)**:
    -   **Font Fallback Stack**: When using Web Fonts (e.g., Noto Sans JP, Inter), always specify OS standard fonts (e.g., Hiragino Kaku Gothic, Meiryo, system sans-serif) as fallback.
    -   **Line Height for CJK**: For languages with high character density (Japanese, Chinese), set `line-height` wider (`1.6 - 1.8`) to ensure readability.
    -   **Letter Spacing**: Recommend applying `letter-spacing: wider` to bold headings to eliminate character crowding.

### 1.2. Trend Scouting Protocol
For *every* design task, the following "Scouting Loop" is mandatory:
1.  **Analyze Leaders**: Check Mobbin, Awwwards, Google Design.
2.  **Deconstruct**: Why does it feel good? Deconstruct the "Soul".
3.  **Apply**: Adapt that soul to our context. **Steal the soul, don't blindly copy.**
4.  **AI Leverage**: Brainstorm "futuristic" variations using GenAI.

### 1.3. The Realism Mandate (Anti-Haribote / Truth in Design)
-   **Law**: Drawing data that does not exist in DB schema (future columns, fictitious statuses) in design comps is prohibited.
-   **Action**: Designers MUST agree on **DB Schema (ER Diagram)** with backend engineers before drawing in Figma. Ambiguous data like "probably store in JSON somehow" ALWAYS breaks during UI implementation.
-   **Motto**: "No Schema, No Pixel."

## 2. Design Engineering

### 2.1. Design Tokens
-   **Single Source of Truth**: Define all values (color, spacing, typography, shadow, radius, motion, etc.) in Figma Variables and sync 100% with code (CSS Variables / Design Token JSON).
-   **No Hardcoding**: Writing `px` or `#hex` directly is **strictly prohibited**. Use tokens.
-   **W3C DTCG Compliance (W3C Design Tokens Community Group)**:
    -   **Standard**: Comply with **W3C DTCG Specification 2025.10 (Stable)** and follow these principles.
    -   **JSON Format**: `.tokens.json` is the standard token definition format.
    -   **Alias / Reference**: Leverage token references (`{color.primary.500}`) to centralize change propagation.
    -   **Type Safety**: Explicitly specify types (`color`, `dimension`, `duration`, `cubicBezier`, etc.) for each token.
    -   **Multi-Brand / Multi-Theme**: Maintain a structure that can generate multiple brands and multiple themes (light/dark/high-contrast) from a single token definition.
    -   **Token Pipeline**: Build an automated conversion pipeline: Figma → JSON → Style Dictionary (or equivalent) → Platform Code (CSS/Swift/Kotlin/Dart).
-   **Token Hierarchy**:
    1.  **Global Tokens (Primitive)**: Raw values (`blue-500: #3B82F6`, `space-4: 16px`)
    2.  **Semantic Tokens (Alias)**: Meaningful references (`color-primary: {blue-500}`, `color-error: {red-500}`)
    3.  **Component Tokens**: Component-specific values (`button-bg-primary: {color-primary}`)
-   **Naming Convention**: Standardize as `{category}-{property}-{variant}-{state}` format.
    -   Example: `color-text-primary-default`, `spacing-padding-card-sm`
-   **Dynamic Theme**: Theme settings are fetched from DB or config at Runtime (e.g., `RootLayout`) and injected as CSS variables. Support both OS-auto-follow and manual dark/light toggle.
-   **CSS Color Module 4 Support**:
    -   Recommend adoption of modern color spaces (**Display P3**, **Oklch**). `oklch()` provides high Perceptual Uniformity, ideal for programmatic color manipulation.
    -   **Fallback**: Implement progressive enhancement with `@supports (color: oklch(0 0 0))` for browsers that do not support P3/Oklch.
-   **The Locale Format Mandate (Date/Currency/Number)**:
    -   **Law**: Date, currency, and number formats are **locale-dependent**. Hardcoding specific formats (e.g., `MM/DD/YYYY`) is prohibited.
    -   **Action**:
        1. **Date Library**: When using `date-fns` or `Intl.DateTimeFormat`, always explicitly specify target locale.
        2. **Currency**: Display currency symbols and digit separators using `Intl.NumberFormat` in correct format for locale.
        3. **Consistency**: Maintain unified locale settings across the application and prevent mixing.
        4. **Form Field Order Locale Compliance**: Form fields for personal information (name, address, etc.) MUST follow locale-specific ordering conventions. Name ordering (e.g., "Last → First" in Japan vs "First → Last" in Western countries) and address ordering (e.g., "Prefecture → Street" in Japan vs "Street → State" in Western countries) differ by locale. Forcing an order contrary to the locale is prohibited.
-   **Dark Mode & Theme Strategy**:
    -   **CSS Variable Separation**: Define all UI colors as CSS variables (`hsl(var(--...))` or `oklch(var(--...))` tokens) and maintain a design where light/dark/high-contrast mode switching is completed solely by overriding CSS variables.
    -   **No Inversion**: Dark mode is NOT simple color inversion. Design background contrast, elevation expression (use surface luminance difference instead of shadows on dark backgrounds), and saturation adjustment independently.
    -   **High-Contrast Mode**: Maintain a design that can serve a high-contrast theme meeting WCAG AAA (7:1) in the future.
    -   **Semantic Token Mandate**: Prohibit usage of hardcoded color values (`#ffffff`, `bg-white`, etc.) and use semantic tokens (`bg-background`, `text-foreground`) instead.
    -   **Role-Based Naming**: Name colors by "role" not "appearance". Use `color-primary` instead of `blue-500`.
    -   **Loading State Unification**: Unify loading displays during data fetching as follows: Page level uses `loading.tsx` with Suspense Boundary + Skeleton, Component level uses `<Skeleton />` component, Action level uses button `disabled` + spinner icon. A blank white screen without any loading indicator is treated as a critical UX deficiency.

## 3. Component Implementation Guidelines

### 3.1. Implementation Patterns
-   **Skeleton Loader**:
    -   Use **Skeleton Screen** (`<Skeleton />`) instead of spinners during loading (Suspense) to prevent Layout Shift (CLS).
-   **Feedback Hierarchy**:
    -   **Toast**: Success/Notification (Async).
    -   **Inline Alert**: Context-dependent errors.
-   **Toast Promise Standard (Async Feedback Lifecycle)**:
    -   **Law**: Manually managing Loading→Success→Error feedback cycles for async operations (save, delete, submit, etc.) is a breeding ground for bugs.
    -   **Action**: Use the Toast library's `promise` feature (e.g., `sonner.promise()`) to automatically display processing, success, and failure states. Users must visually perceive "processing" status and reliably receive completion or failure results.
    -   **Z-Index Stratification (The Layering Law)**:
        -   **Overlay (10000)**: Select, Popover, Tooltip, Calendar. Topmost.
        -   **Modal (9999)**: Dialog, Sheet.
        -   **Menu (1000)**: Navigation Drawer.
        -   **Action**: Prohibit magic numbers like `z-50`. Strict adherence required.
-   **Optimistic UI**:
    -   For lightweight actions like "Like", update display immediately without waiting for server response to achieve Native-like speed.
-   **The Sortable Table Standard**:
    -   **Law**: "Cannot sort" in admin tables (Users, Logs) makes it an Incomplete business tool.
    -   **Action**: MUST implement server-side sort (`sortBy`, `sortOrder`) via `SortableTableHead`.
-   **The Carousel Standardization Protocol**:
    -   **Law**: Self-implementing carousels (sliders) tends to introduce bugs in touch interactions and accessibility (A11y). Usage of a validated library is mandatory.
    -   **Synced Sliders**: When implementing thumbnail-synced sliders (Main + Thumbs), use the library's native synchronization feature instead of custom State synchronization.
    -   **A11y**: Always enable `navigation` (arrows) and `pagination` (dots) and ensure keyboard accessibility.
-   **The Native Input Prohibition**:
    -   **Law**: Usage of browser-native input forms (`<input type="date">`, `<input type="time">`, `<input type="color">`, etc.) in designed UIs is prohibited. Their appearance and behavior differ across browsers, destroying design consistency.
    -   **Action**: Use `Popover + Calendar` components for date selection, custom `Select` for time selection, and custom color pickers for color selection.
    -   **Modal Scale**: Ensure sufficient width for modals handling complex settings (e.g., `max-w-4xl` or above, or `80vw`) to eliminate cramped layouts.
-   **The Editor Preview Protocol**:
    -   **Law**: In rich content editors (block editors, etc.), displaying only URL text or icons for embedded media (videos, maps, etc.) is prohibited.
    -   **Action**: Use editor extension features (NodeView, etc.) to display actual previews (iframes, etc.) within the editor. Achieve "True WYSIWYG" where the published layout can be accurately understood during editing.
-   **The Headless UI Architecture (UI-Logic Separation Mandate)**:
    -   **Law**: UI components MUST focus exclusively on "data display" and "event emission", and MUST NOT contain business logic (data fetching, state computation, validation, etc.) internally.
    -   **Anti-Pattern**: Directly performing `fetch` inside components or managing state dependent on specific page DOM structures is a design violation that destroys reusability and portability.
    -   **Goal**: UI components must maintain a state where, when porting to another platform (React Native, etc.) in the future, only the "display layer" needs to be swapped without modifying logic.
-   **The Modal Standard Architecture (Portal & Close UX)**:
    -   **Law**: All modals MUST be rendered at the DOM root using the `Portal` pattern. This prevents clipping caused by parent element's `overflow: hidden` or `z-index` constraints.
    -   **Close Button**: Modal close buttons MUST be placed in the top-right corner with a unified visual design (e.g., circular background) consistent across the entire project. A modal with an unclear close mechanism is a UX deficiency.
-   **The Mobile Media Upload Protocol**:
    -   **Law**: Standard capture formats of mobile devices (e.g., iOS HEIC/HEIF) often cannot be directly displayed in browsers. Components with file upload functionality should account for these formats.
    -   **Action**: To reduce server load, client-side automatic conversion to universal formats (JPEG/PNG/WebP) before upload is recommended. Requiring users to manually convert is a mobile UX failure.

### 3.2. Frontend Integration Protocol (Universal Principles)
-   **Lifecycle Rule Compliance**: UI components MUST strictly follow framework-specific lifecycle conventions (proper side-effect management, safe state update timing, etc.). Refer to tech-stack-specific rules for framework details.
-   **Hydration Safety (Server/Client Consistency)**: Initial state mismatches between SSR and client hydration cause UX failures (flickering, layout shift, non-interactivity). Maintain designs where SSR/CSR are consistent, with exceptions only for inevitably different elements (timestamps, random values, etc.).
-   **Conditional Rendering over Visibility**: High-cost UI trees (drawers, dialogs, mega menus, etc.) MUST use **conditional rendering** (excluded from DOM when display flag is `false`) rather than `display:none` concealment, to release memory and rendering resources.
-   **Ghost Dimension Prevention**: When size-dependent initialization (carousels, maps, charts, etc.) occurs inside initially hidden elements, explicitly trigger `resize` or force remount when the element becomes visible to prevent "Ghost Dimension" (broken layout).
-   **Interactive Element Nesting Prohibition**: Nesting interactive elements (e.g., `<a>` inside `<a>`, `<button>` inside `<a>`) is an HTML specification violation. To make an entire clickable card a link, use an absolutely-positioned overlay link technique.
-   **Cross-Reference**: For framework-specific implementation details (React Hooks ordering, Hydration Mismatch handling, suppressHydrationWarning, Server Component boundary design, etc.), refer to `engineering/300_web_frontend.md`.

### 3.3. Layout Architecture
-   **The Single Container Protocol**:
    -   If Layout provides a container, re-defining padding/container in Page is strictly prohibited (Double Padding).
-   **Baseline Harmony (Filter Alignment Protocol)**:
    -   **Law**: When aligning `Input` and `Button` with labels, using `items-center` is prohibited.
    -   **Action**: MUST use **`items-end`** to align baseline considering label height. `items-center` blurs boundaries and looks amateur.
-   **The Natural Scrolling Protocol**:
    -   **Law**: Unplanned nesting of `h-screen` + `overflow-y-auto` causing double scrollbars is UX defeat.
    -   **Action**: Ideally only **one** scroll container (body) on screen. If partial scroll needed, consider `dvh`.
-   **The Any-Screen Typography Protocol**:
    -   **Law**: Fixed `text-3xl` destroys mobile UI.
    -   **Action**: Start from mobile base (`text-xl`) and scale via breakpoints (`sm:`, `lg:`). Maintain visual hierarchy.
-   **The Fragmented UI Protocol**:
    -   **Law**: "Similar but different" is worst. Standardize components including their layout context.
    -   **Action**: Prohibit ad-hoc CSS. Follow single "Gold Standard".

    -   **The Action Placement Standard**:
        -   **Law**: Inconsistent placement of primary action buttons ("Add", "Save", etc.) across pages increases user eye movement cost.
        -   **Action**: Primary actions for a section (e.g., "Add", "Save") MUST be placed at the **right end of the section header** (`flex justify-between items-center`). They must never be buried in the middle of content or at the very bottom.

    -   **The Breadcrumb Priority Protocol**:
        -   **Law**: Breadcrumbs are the "lifeline for knowing current location" and MUST be placed at the **very top of the page** without exception.
        -   **Mobile**: On mobile screens, breadcrumbs and action buttons MUST be separated into a **vertical stack**, with breadcrumbs on top. Placing them side-by-side where breadcrumbs are hidden or forced to horizontal scroll is prohibited.
        -   **Visibility**: Handle breadcrumb text overflow with `overflow-x-auto` while ensuring visibility within the first view as much as possible.

    -   **The Sub-Page Header Consistency**:
        -   **Law**: List pages and create/detail pages MUST share the same header structure (icon + title + description) to maintain visual consistency.
        -   **Action**: Even for new registration or edit pages, place the same branding header and navigation as the parent page. A bare-bones form-only page gives users the impression of "arriving at a different site".

### 3.4. Motion & Gestures (The "Soul")
-   **Physics-Based**: All animation uses spring physics. Elements should bounce, stretch, and squash.
-   **Swipe First**: Implement universal swipe-back and swipe-to-action. No lag allowed.

### 3.5. Multi-Sensory Design
-   **Haptics**: Assign delicate "Tap", "Click" haptics to success/error/select events.
-   **Sonic Branding**: Use sound logos for branding and micro-sounds for UI interactions.

## 4. Performance Animation
-   **60fps Target**: Maintain 60fps (120fps preferred).
-   **GPU Optimization**: Animate only `transform` and `opacity`. No layout thrashing properties (`width`, `height`, etc).

## 5. Adaptability & Foldables

### 5.1. Universal Responsiveness
-   **Rule**: "Mobile First" is obsolete. We design for **"Any-Screen"**.
-   **Foldables**: Be Hinge-Aware and maintain continuity across states.
-   **Large Screens**: Use Canonical Layouts. Do not just stretch mobile UI.
-   **The Adaptive Typography Protocol (Screen-Aware Sizing)**:
    -   **Law**: Fixed `text-3xl` etc. works poorly—too small on large screens, overwhelming on small.
    -   **Action**: 
        1. **Adaptive Base**: Text sizes MUST start from mobile baseline (`text-xl`) and scale via breakpoints (`sm:`, `lg:`).
        2. **Visual Hierarchy**: Maintain proper heading/body contrast ratio so information hierarchy persists across screen sizes.
-   **The Fragmented UI Protocol (Consistency Mandate)**:
    -   **Law**: "Similar but different" is the worst. UI components (breadcrumbs, headings, buttons, etc.) MUST be standardized **including their placement context (Wrapper/Layout)**.
    -   **Action**: Prohibit per-page ad-hoc CSS adjustments ("change background color just here", "add margin"). Define one "Gold Standard" site-wide and conform all pages to it.
-   **The CSS Containment Protocol (Whitespace Glitch Prevention)**:
    -   **Context**: Accordion expansion etc. can cause scroll calculation bugs creating massive whitespace.
    -   **Action**: Containers with `overflow-y-auto` MUST apply `style={{ contain: 'layout' }}` to prevent child layout changes from affecting outside.
-   **The Universal Beauty Protocol (Responsive Verification Mandate)**:
    -   **Law**: "Works on PC so OK" is an excuse hiding responsive design flaws; unverified changes are "incomplete".
    -   **Action**: For ALL feature additions/UI implementations, verify and guarantee "beauty" and "functionality" across these 3 environments as **top priority**:
        1. **SP (Mobile)**: Portrait (Width < 640px)
        2. **Tablet**: Portrait/Landscape (Width 768px ～ 1280px) ※Watch for iPad portrait breakage.
        3. **PC (Desktop)**: Full size (Width > 1280px)
    -   **Checklist**:
        -   No element overlap?
        -   Text not too small/too large and overflowing?
        -   Both touch (Touch) and mouse (Hover) interactions comfortable?

## 6. Accessibility & Inclusivity
-   **WCAG 2.2 AA Standard**:
    -   **Baseline**: **WCAG 2.2 Level AA** + **EN 301 549** (EAA technical standard) as minimum baseline.
    -   **Contrast**: Minimum **4.5:1** text-to-background contrast ratio (WCAG 1.4.3).
    -   **Large Text**: Text at 18px or above (or bold at 14px or above) may use a contrast ratio of **3:1 or above**.
    -   **UI Components**: Borders and icons of interactive elements such as buttons must also maintain a contrast ratio of **3:1 or above** against the background (WCAG 1.4.11).
    -   **Scaling**: Font sizes must follow user settings (Dynamic Type / Text Scaling).
-   **Target Size (WCAG 2.2 New Criterion)**:
    -   **Minimum Target Size**: All interactive elements must maintain a minimum target size of **24x24 CSS px** (WCAG 2.2 2.5.8).
    -   **Recommended Size**: **44x44dp (iOS HIG)** / **48x48dp (Material Design)** recommended.
    -   **Reachability**: Important actions at screen bottom (thumb-reachable zone).
-   **The Fat Finger Protocol (Label Wrapping)**:
    -   **Law**: Prohibit placing checkboxes/radio buttons standalone.
    -   **Action**: Always wrap with `<label>` tag (or `shadcn/ui` `Label` component) including text to maximize touch target area. "Tapping text doesn't respond" is a bug.
-   **Semantics**: Proper labels for screen readers.
-   **Image Alt Text Protocol**:
    -   **Content Images**: Provide an `alt` attribute that accurately conveys the image content (e.g., `alt="Product exterior photo"`).
    -   **Decorative Images**: Set `alt=""` for purely decorative images so screen readers ignore them.
    -   **Omission Prohibited**: Omitting the `alt` attribute (which results in `undefined`) is strictly prohibited. Always specify either an empty string (`""`) or descriptive text.
-   **Focus Ring Protocol (Accessibility Sight)**:
    -   **Law**: UI where focus state (Tab key navigation, etc.) is not visually recognizable is a "maze in the dark" for keyboard users—accessibility failure.
    -   **Action**: When removing browser default focus ring (`outline-none`), MUST redefine **high-contrast focus ring** (e.g., `ring-2 ring-primary ring-offset-2`). "Invisible Focus" is treated as a bug.
-   **A11y Legal Defense (ADA/EAA Compliance)**:
    -   **Risk**: Insufficient accessibility creates litigation risk under the Americans with Disabilities Act (ADA Title III), European Accessibility Act (EAA, effective June 2025), and equivalent national legislation.
    -   **Mandate**: Missing `aria-label` and insufficient contrast ratios are not "bugs" but "legal deficiencies.".
-   **Focus Appearance (WCAG 2.2 New Criterion)**:
    -   **Focus Indicator**: Keyboard navigation focus indicators must meet clear contrast and size requirements (WCAG 2.2 2.4.13).
    -   **Focus Not Obscured**: Focused elements must not be hidden behind fixed headers or floating popups (WCAG 2.2 2.4.11).
-   **Accessible Authentication (WCAG 2.2 New Criterion)**:
    -   **Law**: Authentication flows must not force complex cognitive tasks such as re-entering passwords, solving complex logic puzzles, or memorizing information (WCAG 2.2 3.3.8).
    -   **Action**: Prioritize Passkeys (FIDO2), social login, and password manager auto-fill.
-   **A11y Zero Tolerance CI (Build Gate)**:
    -   **Mandate**: Integrate `axe-core` or `pa11y-ci` into the CI pipeline. If even one `critical` or `serious` violation is detected, **force the build to fail**.
    -   **Exemption**: Only for unfixable external factors within UI library internals—addition to the exception list (Ignore Config) is permitted after documenting the reason.
-   **Non-Color Indication Protocol**:
    -   **Law**: Error displays and critical information MUST NOT rely on **color alone**. Users with color vision diversity will miss the information.
    -   **Action**: Always **combine** icons (⚠️, ✅, ❌) and text ("Required", "Error", "Success") with color to achieve a **triple-channel communication** standard.
-   **Font Size & Zoom Protocol**:
    -   **Minimum Body Text Size**: The minimum font size for body text is **16px**. Smaller font sizes impair readability and should be limited to supplementary text, captions, etc.
    -   **rem Mandate**: Specify `font-size` in `rem` units to respect user browser settings. `px` fixed values are only permitted at the `:root` level.
    -   **Zoom Resilience**: Design layouts to remain intact at browser zoom (**200%**). Content clipping or overlap at 200% zoom is treated as a bug.
-   **Tab Order Protocol (Keyboard Navigation Order)**:
    -   **Law**: DOM order and tab order must match. Positive `tabindex` values (e.g., `tabindex="5"`) are **prohibited**.
    -   **Allowed**: Only `tabindex="0"` (add to natural tab order) and `tabindex="-1"` (programmatic focus only) are permitted.
    -   **Escape Key**: Modals and dropdowns must be closable with the `Escape` key.
-   **Skip Link Protocol**:
    -   **Mandate**: Implement a **"Skip to main content"** link at the beginning of every page.
    -   **Implementation**: Use the `sr-only` + `:focus` pattern—hidden by default, visible only on focus.
-   **ARIA Attributes Standard**:
    -   **aria-live**: Set `aria-live="polite"` on dynamically changing content (toast notifications, countdowns, etc.) to notify screen readers of changes.
    -   **aria-expanded / aria-controls**: Set `aria-expanded` for open/close state and `aria-controls` for target elements on accordions and dropdowns.
    -   **First Rule of ARIA**: Do NOT use ARIA when semantic HTML is sufficient. Excessive ARIA causes more confusion than it solves.
-   **Label Association Protocol**:
    -   **Mandate**: Associate all input fields with `<label>` using the `htmlFor` attribute.
    -   **Placeholder-Only Prohibition**: Using `placeholder` as a substitute for labels is strictly prohibited. Placeholders disappear on focus, causing users to lose track of input purpose.
-   **Error Notification Protocol (Form Error Notification)**:
    -   **Mandate**: Notify screen readers of form errors immediately using `aria-live="assertive"`.
    -   **Association**: Place error messages directly below the field and associate them using `aria-describedby`.
    -   **Clarity**: Error messages MUST **clearly indicate** which field has the issue.
-   **Required Fields Protocol**:
    -   **ARIA**: Set `aria-required="true"` on required fields.
    -   **Visual**: Visually indicate with a "Required" label or `*` mark + text (do not rely on color alone: Non-Color Indication Protocol compliant).
-   **Lighthouse Score Gate**:
    -   **Mandate**: Lighthouse Accessibility Score of **90 or above** is a **deployment requirement**. Pages scoring below 90 are treated as bugs.
    -   **Manual Testing**: Periodically conduct keyboard-only site operation tests, screen reader (VoiceOver / NVDA) read-aloud verification, and 200% zoom testing.
-   **Color Vision Simulation Test**:
    -   **Mandate**: When creating or modifying UI components that use color for information conveyance (status badges, charts, error displays, etc.), verification under the following color vision simulations is mandatory.
        -   Protanopia (Type 1): Difficulty perceiving red
        -   Deuteranopia (Type 2): Difficulty perceiving green
        -   Tritanopia (Type 3): Difficulty perceiving blue
    -   **Tools**: During development, use Chrome DevTools "Rendering > Emulate vision deficiencies". During design, use Figma's `Able` or `Stark` plugin.
    -   **PR Review Gate**: For PRs containing UI components that convey information through color, reviewers are recommended to document confirmation results using the above tools in PR comments.
-   **Media Accessibility Protocol**:
    -   **Subtitles**: Subtitles in the target locale's language are mandatory for video content.
    -   **Transcript**: Provide text transcripts for audio-only content.
    -   **Auto-Play Ban**: Auto-play of media with audio is prohibited. Playback must only begin with explicit user action (click/tap) (WCAG 1.4.2 compliant).
-   **Semantic HTML Standard**:
    -   **Law**: Avoid "div hell" — excessive use of `div` / `span`. Use appropriate HTML elements.
    -   **Elements**:
        -   `<button>`: Clickable actions (`<div onClick>` is prohibited)
        -   `<a>`: Navigation (page transitions, external links)
        -   `<nav>`, `<main>`, `<header>`, `<footer>`, `<aside>`: Page structure landmarks
        -   `<article>`, `<section>`: Semantic content divisions
    -   **Landmark Completeness**: Place exactly one `<main>` per page, and `<nav>` must always contain navigation menus.
-   **Locale-Aware Screen Reader Testing**:
    -   **Context**: Screen reader pronunciation behavior differs by locale (e.g., locale-specific pronunciation quirks, currency symbol reading, address format ordering, etc.).
    -   **Mandate**: Before releasing new pages or major UI components, conduct read-aloud testing with VoiceOver (iOS/macOS) or NVDA (Windows) configured in the target locale's language settings.
    -   **Checklist**: Verify button announcements (operations communicated in target language), form labels (input purpose read in target language), error messages (immediate notification via `aria-live`), and numeric/currency values (natural pronunciation).

## 7. User Sovereignty & Ethical UX
-   **Data Ownership**: Users control their data (Easy Export/Delete).
-   **Dark Pattern Complete Ban**:
    -   **Law**: Dark patterns are treated as **"legal risk"**, not "design optimization".
    -   **Regulatory Landscape**:
        -   **FTC (US)**: Section 5 + Negative Option Rule enforcement strengthening. Click-to-Cancel mandate.
        -   **DSA (EU)**: Prohibition of manipulative interfaces that distort or restrict user autonomy (up to 6% of global annual revenue in fines).
        -   **CPRA/CCPA (California)**: Explicit prohibition of consent obtained through dark patterns.
    -   **Specific Prohibitions**:
        -   **Confirmshaming**: Guilt-inducing decline button wording ("No, I don't care about quality")
        -   **Roach Motel**: Easy to sign up, hard to cancel
        -   **Hidden Costs**: Additional charges discovered at final purchase
        -   **Pre-checked Boxes**: Default checked opt-ins
        -   **Forced Continuity**: Auto-billing after free trial without explicit notification
        -   **Trick Questions**: Double negatives or confusing phrasing
    -   **Symmetry Principle**: Opt-out/cancellation flows must be designed with equal ease as opt-in/registration flows.
-   **Transparency**: Explainable AI (Why this content?). Provide "Why am I seeing this?" explanations for algorithmic recommendations.
-   **Consent & Privacy UX**:
    -   **Granular Consent**: Obtain consent per category (essential/analytics/marketing). A single "Allow All" button is insufficient.
    -   **Revocable**: Consent must be easily revocable at any time.
    -   **Plain Language**: Present privacy policy summaries in plain language users can understand, not legal jargon.

## 8. Tools & Workflow
-   **Figma**: The Source of Truth. Use Dev Mode.
-   **Rive**: Use for complex vector animations.
-   **Inclusive Copywriting**: Language that excludes no one.

## 9. AI UX Strategy
-   **AI UX Philosophy**:
    -   **Law**: AI is designed as a "collaborator" not a "tool". Prioritize the 3 principles of transparency, controllability, and safety.
-   **AI Interaction Patterns (5 Types)**:
    -   **Chat**: Text-based dialogue. Suitable for search, Q&A, casual inquiries.
    -   **Copilot**: Side-panel assistant for work screens. Understands user context and provides real-time support.
        -   *Assistive*: Continuous task support in side panel
        -   *Immersive*: Full-screen data-intensive AI workspace
        -   *Embedded*: Inline minimal triggers ("Rewrite", "Summarize" buttons, etc.)
    -   **Agent**: Autonomous multi-step task execution. User defines goals, AI plans and executes.
    -   **Ambient**: Operates intelligently in background, surfaces proactively only when needed.
    -   **Proactive**: Predicts and suggests based on user behavior patterns.
-   **Agentic AI UX Patterns**:
    -   **Intent Preview**: Display plan preview before action execution so users can approve, edit, or reject.
    -   **Autonomy Dial**: Allow users to adjust AI autonomy level ("Suggest Only", "Execute After Approval", "Full Autonomy").
    -   **Explainable Rationale**: Transparently display AI reasoning and confidence levels. Black box output is prohibited.
    -   **Action Audit & Recovery**: Log all autonomous actions and provide easy "Undo" / "Rollback" capabilities.
-   **Generative UI (GenUI)**:
    -   **Dynamic Component Selection**: AI selects appropriate components from a pre-defined brand UI component library and injects live data.
    -   **Adaptive Layout**: Dynamically reconfigure UI based on user's current task and history.
    -   **Contextual Assistance**: Surfaces (side panels, tooltips, embedded overlays) that appear only in relevant contexts. Prevent chat fatigue.
-   **Streaming First**: Zero perceived latency. Stream responses token-by-token in real-time.
    -   React UI immediately to user actions before AI finishes processing.
-   **Transparency**: Visually distinguish "Thinking" vs "Generating".
    -   **AI Content Differentiation**: Visually differentiate AI-generated content from human-created content (glow effects, dedicated icons, etc.).
    -   **Confidence Signals**: Design mechanisms to convey AI confidence levels to users.
-   **AI Failure Handling**:
    -   Design graceful recovery paths for AI errors. Provide correction, regeneration, and comparison UI patterns.
    -   **Human-in-the-Loop**: In Copilot experiences, always treat AI output as "suggestions". Maintain design where users hold final judgment authority.
-   **The Quota Framing Protocol**:
    -   **Law**: When displaying usage limits (Quota) for AI generation, API calls, etc., wording that makes users feel "stingy restrictions" is prohibited.
    -   **NG**: "You have reached your limit" / "Usage limit exceeded"
    -   **OK**: "You've used all your AI generation power this month. Upgrade your plan to unlock more?"

-   **MCP (Model Context Protocol) UX Integration Protocol**:
    -   **Background**: MCP (Model Context Protocol), released by Anthropic in 2024 and now an open standard, provides a standardized interface connecting AI agents with external tools and data sources. When applications connect to external MCP servers, appropriate UI governance becomes essential.
    -   **Tool Call Transparency**: When AI agents invoke external tools (file operations, API calls, DB access, etc.), display "which tool is being invoked for what purpose" to the user in the UI.
    -   **Permission UI**: When connecting to MCP servers, provide a UI that allows users to explicitly grant consent on first connection. Recommend offering OAuth-equivalent granularity so users can select "read-only" vs. "write access" per tool.
    -   **Action Log UI**: All actions executed by agents via MCP (file creation/deletion, API calls, etc.) must be displayed as human-readable logs in the UI, maintaining a design where users can review and undo them (integrate with §9's "Action Audit & Recovery").
    -   **Minimal Scope Principle**: Access permissions to MCP servers must be limited to the minimum necessary for task completion. Acquiring "full permissions" is prohibited; designing sessions to be destroyed after task completion is recommended.
-   **Multimodal AI UX**:
    -   **Modality-State Display**: When using AI that processes multiple modalities (text, images, audio, video, etc.), display "what the AI is currently processing" (which modality it is recognizing) in the UI.
    -   **Per-Modality Review UI**: For inputs across image, audio, and text modalities, providing a "per-modality review UI" where users can individually confirm or remove each modality input is recommended.

## 10. User Onboarding & Guidance
-   **Coach Marks**: Context-aware tooltips. Always skippable.
-   **The Feature Tab Protocol**:
    -   **Law**: For pages composing related feature groups (e.g., profile management, settings screens, etc.), place shared tab navigation so users can navigate between features without confusion.
    -   **Disabled State**: When prerequisites are not met (e.g., initial registration incomplete), related tabs should NOT be hidden but instead displayed as **disabled (Disabled / reduced Opacity)**, maintaining awareness of the feature's existence (ensuring discoverability).
    -   **Active State**: Highlight the tab corresponding to the current context. When on a sub-resource (new creation screen, etc.) with no directly corresponding tab, either maintain the parent category tab or leave all tabs unselected.
-   **Feature Discovery**: Progressive disclosure. Zero Data is an onboarding opportunity.
-   **General Consumer Perspective**: No technical jargon ("Database", "API"). Use intuitive words ("Save", "Connect").
-   **Micro-Interaction Standards**:
    -   **Cursor Affordance**: Clickable elements (including Cards and custom inputs) must apply `cursor-pointer` on hover to clarify affordance.
    -   **Hover State Fidelity**: Interactive cards must apply subtle background color change or elevation (`shadow-md`) on hover to signal reactivity to user's subconscious.
        -   **Clipboard Interaction Protocol (Copy Feedback)**: On successful "copy" actions for URLs or codes, always display an immediate **toast notification** or **icon change (checkmark, etc.)** to clearly indicate success. In environments where `navigator.clipboard` fails (non-HTTPS, etc.), implement a fallback that selects the text for manual copying.
        -   **Input Reflection Protocol (Real-time Label Sync)**: In collapsible UIs such as accordions, changes to internal input fields (`name`, `title`, etc.) MUST be reflected **in real-time** in parent components (list views, accordion headers). Behavior where "the title doesn't update until saved" is perceived as UX lag in admin interfaces.
-   **The Microcopy Quality Protocol (Kindness First)**:
    -   **Law (No Blame)**: Error messages must "help" users, not "blame" them.
        -   **NG**: "Invalid Input"
        -   **OK**: "Please enter in email format" / "Only alphanumeric characters allowed"
    -   **Law (Safety Warning)**: For dangerous operations like delete confirmation, add **words emphasizing irreversibility** ("This action cannot be undone") with red UI.
        -   **Law (Error 2-Sentence Rule)**: Error messages MUST follow a **2-sentence structure**: "**What happened**" + "**What to do next**". An error message that only reports the cause without suggesting a solution is incomplete.
        -   **Law (Positive Framing)**: Prefer **affirmative framing** over negation. Tell users "how to achieve" instead of "cannot do".
        -   **Law (Action-Oriented Button Labels)**: Button labels should prefer **verb forms** that clearly state the intended action (e.g., "Save Changes", "Submit Form", "Confirm Details") over bare nouns (e.g., "Save", "Submit"). This encourages user action and contributes to higher conversion rates.
        -   **Law (Debug Artifact Display Ban)**: Runtime debug values (`null`, `undefined`, `NaN`), stack traces, and raw database error messages being displayed in the UI is **strictly prohibited**. These give users the impression that the system is "broken" and constitute a critical UX deficiency. Always catch them with Error Boundaries or fallback UI and display user-comprehensible messages instead.
-   **The Explicit Explanation Protocol (Zero Jargon / Tooltip Mandate)**:
    -   **Law**: What's "common knowledge" to developers (API, Webhook, MRR) is "mystery symbols" to users. Lack of explanation means failure as a tool.
    -   **Action**: 
        1. **No Jargon**: Minimize technical terms in UI text; choose universally understandable words.
        2. **Tooltip Mandate**: When technical terms or calculated values (MRR etc.) are unavoidable, MUST add **`Info` icon with `Tooltip`** explaining "what it is, how it's calculated, how it affects business" in non-engineer language.
-   **Code Input Standard**:
    -   **Law**: Using raw `textarea` for HTML/CSS/JSON code editing is prohibited—lacks syntax highlighting, invites errors, damages quality.
    -   **Action**: MUST use editor components like `react-simple-code-editor` (+ `prismjs`) for professional quality. Raw `Textarea` is considered incomplete.

## 11. Safety UI Protocols
-   **No Native Popups**:
    -   Use of `window.alert`, `confirm`, `prompt` is prohibited as they block threads and damage UX. Always use `Dialog` components.
-   **Destructive Actions**:
    -   **Magic Word**: For irreversible actions like permanent deletion, verify with **Magic Word Input** (e.g., type "delete") instead of a simple "OK" button.
-   **Dirty Check**:
    -   Warn users ("Changes will be lost") when attempting to leave with unsaved changes.
-   **Loading Lock Protocol (Double-Submit Prevention)**:
    -   **Law**: Leaving buttons clickable during form submission or async processing causes double-registration and Race Conditions, and is strictly prohibited.
    -   **Action**: During processing (`isLoading`), disable buttons with the `disabled` attribute and visually indicate with greyout or spinner. For actions with significant side effects, additionally use `pointer-events-none` to physically block clicks.
-   **Responsive Action Button Protocol**:
    -   **Mobile**: Important action buttons (register, save, purchase, etc.) should be `w-full` (full screen width) for easy tapping.
    -   **Desktop**: Use `w-auto` with sufficient minimum width and **center alignment**. Making buttons `w-full` on PC causing visual stretching is prohibited.
    -   **Affordance**: Apply shadows (`shadow-md`) and hover effects to convey "clickability".
-   **Rich Selection Protocol**:
    -   **Law**: Standalone use of small radio buttons or checkboxes is prohibited for important selection UIs, as their hit area is insufficient for touch devices and the selected state has poor visibility.
    -   **Standard**: Use **Selectable Card Grid** as the standard—featuring large hit areas, clear borders, color changes on selection (background/border color changes), and icon-based visual aids.
    -   **Implementation**: Hide native radio/checkbox elements with `sr-only` for screen readers, and style adjacent label elements using `peer-data-[state=checked]:` or equivalent techniques.

## 12. Hospitality UX (Omotenashi - Japanese Hospitality)
-   **Kigakiku (Anticipatory)**: Anticipate needs before users struggle. (e.g., Offer "Convert to Half-width?" button on Full-width error).
    -   **Input Normalization (Tolerant Input Principle)**: When users enter data in an imprecise format (full-width numbers, full-width spaces, etc.), do NOT reject with validation errors. Instead, **silently auto-convert (Normalize)** on `onChange` or `onBlur`. Use `String.normalize('NFKC')` etc. to minimize user input burden.
    -   **Locale-Specific Input Assistance**: For locale-specific data entry (address, name, etc.), implement **locale-tailored input assistance features** (e.g., postal code to address auto-complete, phonetic reading auto-generation, phone number formatting, etc.) to reduce user input burden. Always allow manual correction after auto-completion to preserve user control.
-   **Ma (Negative Space)**: White space is for "Thinking Time", not just empty space. Merge Silicon Valley density with Japanese Ma.
-   **Aizuchi (Reassuring Feedback)**: Give reassuring feedback (Visual/Haptic) to every action. "Your operation is conveyed."
-   **The Graceful Error Recovery Protocol**:
    -   **Law**: When unexpected errors occur, do not merely state the facts—express empathy to the user, and **always provide action buttons for the user's next step** (reload, return home, contact support, etc.).
    -   **Action**: Error pages and error modals MUST include a concise explanation of the cause along with at least one recovery action button. A "Dead End" error screen that offers no escape accelerates user churn and constitutes a UX failure.
-   **Error Page Design Protocol**:
    -   **Law**: Error pages are the moment users feel the most anxious. The following design standards are established to prevent churn and maintain trust.
    -   **Design Principles**:
        1.  Maintain brand logo and color scheme (blank white pages are prohibited)
        2.  Visually convey the situation using illustrations or icons
        3.  Present next actions clearly, limited to 3 or fewer (e.g., "Return to Top", "Search", "Contact Us")
    -   **HTTP Status Compliance**: Error pages MUST return the correct HTTP status code. Returning 200 is prohibited. 404 pages MUST include `<meta name="robots" content="noindex">`.
    -   **Prohibited**: Displaying stack traces or debug information, and wording that blames the user (e.g., "There is a problem with your operation") are strictly prohibited.
-   **The Ghost Content Protocol (Time-Gated SEO / Scheduled Content Isolation)**:
    -   **Context**: Scheduled content (published_at > NOW()) exists on the server but must behave as if it "does not exist" for general users and search engines.
    -   **Action**:
        1.  **404 Mock**: For access from general users, return the same UI and status code as a regular 404 error, preventing them from guessing the content's existence.
        2.  **NoIndex Guard**: As a safeguard against URL leakage, force-inject `<meta name="robots" content="noindex, nofollow" />` on all unpublished pages.

## 13. Design Ops & Tools
-   **Design System**: Figma is truth. Code follows Figma.
-   **Tool Usage Protocol**:
    -   **Figma (UI/UX)**: Engineers MUST use **Dev Mode**. No guesswork.
    -   **Adobe CC**: Use Photoshop/Illustrator for logos/graphics. Export as SVG/WebP.
    -   **Canva**: Use for non-product UI (OGP, Documents).
-   **Hand-off**:
    -   **Status**: Mark frames (Draft/Ready/Shipped).
    -   **Export**: WebP or SVG by default. Avoid PNG/JPG.

## 14. Interaction Safety Protocols

### 14.1. The Responsive Safety Protocol (No-Trap Mandate)
-   **Law**: Physics differ between PC and SP.
-   **Action**:
    1.  **SP (Drawer Safety)**: Add `data-vaul-no-drag` to scrollable areas in Drawers to prevent accidental close.
    2.  **PC (Viewport Safety)**: Set `max-height` for floating elements like Popovers to prevent overflow outside screen.
    3.  **Responsive Split**: Use `Drawer` for Mobile, `Popover` for PC standard.
    4.  **iOS Input Zoom Defense**: On iOS Safari, when input field `font-size` is **below 16px**, the browser auto-zooms on focus, damaging UX. The `font-size` of `input`, `textarea`, `select` in mobile views MUST be enforced at **16px (`text-base`)** or above.

### 14.2. The Mobile Click/Tap Fix
-   **Law**: Mobile Popovers may fail to capture tap events due to focus conflicts.
-   **Action**: Force `pointer-events-auto` on interactive items and ensure event firing with multiple bindings (`onClick`, `onPointerUp`).
-   **Combobox Interaction Protocol**:
    -   **Stable IDs**: `value` attributes in virtual lists (CMDK) MUST use unique/immutable **ASCII Strings** (IDs). Usage of Japanese triggers selection logic bugs.
    -   **Searchability**: If Japanese search is needed, explicitly specify `keywords` property (array) to guarantee searchability.

### 14.3. The Z-Index Stratification Protocol
-   **Law**: End the Z-Index war.
    -   **Level 4 (Max)**: `z-[10000]` - Overlay Components (Select, Popover, Tooltip) *Above Modal*
    -   **Level 3**: `z-[9999]` - Dialog / Modal
    -   **Level 2**: `z-[1000]` - Full Screen UI (Mobile Menu, Drawer)
    -   **Level 1**: `z-50` - Fixed Header, Floating Buttons
    -   **Level 0**: `z-0` ~ `z-40` - Page Content
-   **Action**: No magic numbers like `z-100`. Strictly adhere to this hierarchy.

### 14.4. The Drag & Drop Safety Protocol
-   **Portal Rendering (Clipping Defense)**: `DragOverlay` MUST be rendered directly under `document.body` using `createPortal` to prevent clipping caused by parent element's `overflow: hidden`.
-   **Context Isolation**: When multiple DnD areas exist on a single page, isolate `DndContext` or assign unique IDs to prevent interference between areas.
-   **DragOverlay Input Ban**: Rendering form input elements (`input`, `textarea`) directly inside `DragOverlay` is prohibited. Form libraries (React Hook Form, etc.) will misidentify two input fields with the same `name`, causing validation bugs. Implement an `isOverlay` property branch that returns Read-Only JSX during overlay rendering.
-   **Accordion Handling**: When dragging elements containing Accordions, force all-closed state (`defaultValue={[]}`) inside the Overlay to prevent oversized elements from dominating the screen.

### 14.5. The Auto-Save Protocol
-   **Scope**: For admin screens and forms involving long-text input (articles, settings, content editing, etc.), implementing auto-save functionality is recommended.
-   **Hook Strategy**: Use a standardized `useAutoSave` hook to implement draft saving with debounce (2 seconds or more).
-   **Passive Restoration**: When a draft exists at page load, do NOT auto-apply it. Display a "Draft found" notification and give the user the choice to restore.
-   **Hygiene**: On successful form submission, call `clearDraft()` to clean up local storage.
-   **Roadmap**: Transitioning to server-side draft saving in the future is recommended to enable cross-device continuity (resume in progress).
-   **The Public Form Persistence Protocol**:
    -   **Context**: When end-user facing forms (contact, registration, etc.) lose all input due to browser closure during entry, it constitutes a UX loss.
    -   **Action**: Even for public-facing forms, using `localStorage` or `sessionStorage` for temporary input data persistence is recommended. Propose restoration on next visit to reduce user re-entry burden.

### 14.6. The Hard Session Refresh Protocol (Auth State Hard Reload)
-   **Context**: Even when session cookies (login, permission changes, etc.) are updated via Server Actions or APIs, SPA transitions (client-side routing) alone may not immediately reflect changes in Middleware or Server Components.
-   **Action**: When authentication state or critical permissions change (Login / Logout / privilege escalation, etc.), use `window.location.reload()` or `window.location.href` for a **hard refresh** to ensure the server is accessed with the latest cookie state.
-   **Rationale**: Soft navigation via client-side routing does not reflect Cookie/Session changes to Middleware, causing permission mismatch errors or security holes. The momentary white screen from a reload is a far more minor UX cost than permission inconsistencies.

### 14.7. The Offline Resilience Protocol (Network Instability Defense)
-   **Context**: When the app stops with a "white screen" in environments with unstable network (mobile connections, commuting, etc.), it constitutes a critical user experience deficiency.
-   **Action**:
    1.  **Component-Level Recovery**: Handle `onError` in data fetching libraries (SWR, React Query, etc.) and display skeleton or error messages with a "Reload" button at the component level before global Error Boundaries fire.
    2.  **Online Status Watch**: Monitor `navigator.onLine` and disable form submission buttons when offline is detected to prevent data loss. Displaying a banner notifying "You are currently offline" is recommended.

## 15. Localization & Internationalization

### 15.1. The Localization Completeness Protocol
-   **Law**: UI strings that remain untranslated in the target locale's language (button labels, placeholders, toast notifications, validation messages, empty state text, tooltips, etc.) are treated as **"bugs"**.
-   **Scope**: The following areas are priority scan targets:
    1.  **Static UI**: Button labels, headings, menu items
    2.  **Placeholders**: Input examples must be concrete and locale-appropriate
    3.  **Toasts & Alerts**: Success/error notification text
    4.  **Validation Messages**: Framework/library default messages (override with Zod `message` parameter, etc.)
    5.  **Date & Currency**: Locale-compliant formatting (see §2.1 Locale Format Mandate)
    6.  **Admin Panel**: Administrators are also speakers of the target locale's language. Untranslated labels in admin panels are bugs without exception
    7.  **Automated Emails & Notifications**: From subject line to signature, all text must be natural in the target language
-   **Exception**: Proper nouns (Google, LINE, Instagram, etc.) and technical terms where translation would be unnatural (URL, ID, API, etc.) are permitted.
-   **Internal Value Display Guard**: Directly displaying DB values, internal constants, or enum string values in the UI is prohibited. Always convert to the target language via mapping dictionaries or label properties.
-   **Scan Protocol**: Include verification that string literals in UI files (`.tsx`, etc.) are localized as a PR review checklist item. When possible, build CI script-based automated detection.

### 15.2. The Error Message UX Standard
-   **Law**: Error messages MUST meet the following quality standards.
-   **2-Sentence Rule**: Error messages MUST follow a **2-sentence structure**: "**What happened**" + "**What to do next**". A message that only reports the cause without suggesting a solution is incomplete.
-   **No Tech-Speak**: Displaying technical terms and debug information such as `null`, `undefined`, `NaN`, `UUID`, stack traces, and DB-specific error messages in the UI is physically prohibited. Always catch them with Error Boundaries or fallback UI and convert to user-comprehensible messages.
-   **Empathy First**: Error messages should "help" users, not "blame" them. Prefer affirmative framing over negation.
-   **Positive Framing**: Instead of "Cannot do X", say "Please do Y and try again" to show how to achieve the goal.
-   **Graceful Recovery**: Error screens and error modals MUST include a concise explanation of the cause plus **at least one recovery action button** (reload, return home, contact support, etc.). A dead-end error screen is a critical UX deficiency.

### 15.3. The IME/Input Method Handling Protocol
-   **Context**: In CJK language regions (Japanese, Chinese, Korean, etc.), input via IME (Input Method Editor) is standard, and `onChange` event firing timing differs from direct input.
-   **Composition Event Handling**:
    -   For search bars and instant-filtering UIs, properly handle `compositionstart` / `compositionend` events to prevent requests from firing before IME conversion is confirmed.
    -   When implementing or modifying input forms, testing with the following 3 patterns is recommended:
        1.  **IME ON (with conversion)**: The full sequence of candidate selection → confirmation
        2.  **IME OFF (direct input)**: Direct alphanumeric or URL input
        3.  **Mixed input**: Cases mixing target language and alphanumeric characters
-   **Input Normalization**: When users enter full-width numbers, full-width spaces, etc., do NOT reject with validation errors. Instead, silently auto-convert to half-width using **`String.normalize('NFKC')`** on `onChange` or `onBlur`. The principle is "tolerant input" that minimizes user input burden.

### 15.4. The i18n Readiness Protocol
-   **Context**: Even for single-language projects, maintaining a translation-ready architecture for future multilingual expansion is important.
-   **Design Principles**:
    1.  **String Resource Consolidation**: Consolidate UI text into constant files or dictionary objects as much as possible, minimizing hardcoding within components.
    2.  **Intl API Usage**: Use `Intl.DateTimeFormat` and `Intl.NumberFormat` for date, currency, and number formatting to maintain locale-switchable state.
    3.  **Translation Key Design**: In preparation for future i18n adoption, design translation keys with namespace separation per feature/page (e.g., `common.save`, `auth.login`, `error.network`), with a maximum depth of 3 levels.
    4.  **No Premature Investment**: Premature adoption of i18n libraries or creation of translated UIs before demand is confirmed is prohibited.
-   **Trigger Conditions**: Formally start a multilingual project when any of the following are met:
    -   International traffic exceeds **10%** of total
    -   Partnership offer from an international partner
    -   Business strategy decision for international expansion

### 15.5. The Error Message Catalog Protocol
-   **Law**: Writing error messages ad-hoc within individual components or actions is prohibited.
-   **SSOT**: Error messages MUST be centrally managed (Single Source of Truth) in a constants file (e.g., `error-messages.ts`) with a nested structure organized by category.
-   **Quality Standard**:
    | Element | Criteria |
    |:--------|:---------|
    | **Tone** | Unified in the standard polite expression of the target locale |
    | **Technical Terms** | Never expose (`UUID`, `500`, `null`, etc. are prohibited) |
    | **Untranslated Strings** | Not permitted (see §15.1 Localization Completeness) |
    | **Next Action** | Suggest solutions whenever possible |
-   **Fallback**: When no matching error exists in the catalog, display a generic fallback message.

### 15.6. The Accessible Native Language Label Protocol
-   **Law**: `aria-label` is text read aloud by screen readers—it is **information that reaches the user's ears**. It is not a developer-facing attribute.
-   **Mandate**: `aria-label` for user-facing UI elements MUST be written in the **target locale's language** as a rule.
-   **Exception**: Brand names and technical terms where transliteration is natural (e.g., PDF) may be mixed.
-   **Cross-Reference**: §6 (Accessibility & Inclusivity) aria-label related rules

---

## 16. Motion Token Architecture

### 16.1. Motion Design Token Mandate
-   **Law**: Motion design must be structured as Design Tokens. Define the following token categories.
-   **Duration**:
    -   `motion.duration.instant: 100ms`
    -   `motion.duration.fast: 150ms`
    -   `motion.duration.normal: 250ms`
    -   `motion.duration.slow: 400ms`
    -   `motion.duration.complex: 600ms`
-   **Easing**:
    -   `motion.easing.standard: cubic-bezier(0.4, 0, 0.2, 1)`
    -   `motion.easing.decelerate: cubic-bezier(0, 0, 0.2, 1)`
    -   `motion.easing.accelerate: cubic-bezier(0.4, 0, 1, 1)`
    -   `motion.easing.spring: cubic-bezier(0.175, 0.885, 0.32, 1.275)`
-   **Properties**: `motion.property.enter`, `motion.property.exit`, `motion.property.hover`, `motion.property.expand`
-   **Cross-Platform Consistency**: Guarantee identical motion experience across Web / iOS / Android / Flutter through tokens.

### 16.2. prefers-reduced-motion Compliance
-   **Law**: Accommodating users with vestibular disorders or high motion sensitivity is a **legal obligation** (EAA/WCAG 2.2 2.3.3).
-   **Action**:
    1. Define alternative behavior for all animations with `prefers-reduced-motion: reduce` media query.
    2. In reduced motion mode, switch to instant transitions (`duration: 0ms`) or crossfade (`opacity` only).
    3. **Essential Motion Exception**: Animations essential for content understanding (progress bars, etc.) should be slowed rather than completely disabled.

---

## 17. Performance UX

### 17.1. Perceived Performance
-   **Law**: "How fast the user feels" is more important than actual speed.
-   **Skeleton > Spinner**: Use Skeleton for loading to preview content shapes rather than spinners.
-   **Optimistic UI**: Update UI before server response for lightweight actions.
-   **Instant Feedback**: Guarantee visual feedback within 100ms of button press.

### 17.2. Core Web Vitals (CWV) Awareness
-   **LCP** (Largest Contentful Paint): Display the largest first-view element within **2.5 seconds**.
    -   **Design Action**: Preload hero images with `<link rel="preload">`. Optimize to WebP or AVIF format.
-   **INP** (Interaction to Next Paint): Interaction to next paint within **200ms**. (Officially replaced FID in March 2024.)
    -   **200ms Budget Breakdown**: **Input Delay ≤ 50ms** (lightweight event handlers) + **Processing Time ≤ 100ms** (minimize rendering work) + **Presentation Delay ≤ 50ms** (paint optimization).
    -   **Long Task Splitting**: Split tasks exceeding 50ms using `setTimeout` / `requestIdleCallback` to free the main thread.
        ```javascript
        // Scheduler API pattern for splitting Long Tasks (Chrome 115+ stable)
        async function processHeavyTask(items) {
          for (const item of items) {
            await scheduler.yield(); // Yield to main thread
            processItem(item);
          }
        }
        // Fallback: yield via setTimeout(0)
        function yieldToMain() {
          return new Promise(resolve => setTimeout(resolve, 0));
        }
        ```
    -   **Animation Preservation**: Removing animations to "improve INP" is prohibited. Leverage GPU composited layers (`transform`/`opacity`) to free the main thread without sacrificing motion.
    -   **React 19 Compiler / PPR Support**: Leverage React 19 Compiler's Auto-Memoization and Next.js 15+ Partial Prerendering (PPR) to optimize hydration priority for interactive elements. Designs that return static shells instantly and stream dynamic content directly improve INP.
-   **CLS** (Cumulative Layout Shift): Maintain layout shift below **0.1**.
    -   **Design Action**: Specify explicit `width`/`height` on images, videos, and ad slots. Use `font-display: optional` or `swap` for fonts.
-   **TTFB** (Time to First Byte): Target server response time within **800ms**. Prioritize CDN edge caching and SSG.
-   **Design Impact**: Plan image/font lazy loading, appropriate sizing, and `font-display: swap` from the design stage.

### 17.3. Progressive Enhancement
-   Maintain designs where core functionality works without JavaScript (where feasible).
-   Add enhancements (animations, interactions) progressively.

---

## 18. Spatial Computing & XR UX

### 18.1. Spatial Design Principles
-   **Depth as Hierarchy**: In 3D space, distance becomes a hierarchy tool. Elements closer to user feel more active/important.
-   **Ergonomic Zones**: Place interactive elements within natural reach to prevent user fatigue.
-   **Grounding Effect**: Anchor UI to the physical world to reduce motion sickness and cognitive load.

### 18.2. Multimodal Input Design
-   **Eye Tracking**: "Gaze is the new hover". Design eye tracking + gesture input combinations.
-   **Gesture Input**: Use subtle gestures (pinch, tap) for confirmation actions.
-   **Voice Input**: Leverage voice for complex commands and navigation.
-   **Input Agnostic**: Design independent of input method. Gaze, hand, voice, and controller should be interchangeable.

### 18.3. Volumetric Design System
-   Plan long-term extension from flat design systems to "spatial design systems".
-   Define how components behave in 3D space (wall-anchored vs floating, gaze-reactive vs touch-reactive).

### 18.4. visionOS / HIG (Apple) Compliance
-   **Windowing & Volumes**: Prioritize window-based experiences in Shared Space.
-   **Materials**: Use system materials like Liquid Glass to maintain harmony with the environment.
-   **Spatial Audio**: Plan Spatial Audio as UI feedback.
-   **Comfort & Safety**: Guarantee users can easily exit immersive states.

---

## 19. UX Research & Measurement

### 19.1. UX Research Methods
-   **Quantitative Methods**: A/B testing, funnel analysis, heatmaps, task completion rate, error rate.
-   **Qualitative Methods**: User interviews, usability testing (moderated/unmoderated), diary studies, card sorting.
-   **Continuous Discovery**: Leverage Teresa Torres's Opportunity Solution Tree for continuous hypothesis validation.

### 19.2. UX KPIs
-   **NPS (Net Promoter Score)**: User recommendation measurement.
-   **SUS (System Usability Scale)**: Standardized usability score.
-   **Task Success Rate**: Task completion rate.
-   **Time on Task**: Task completion time.
-   **Error Rate**: Error occurrence rate.
-   **CSAT (Customer Satisfaction Score)**: Customer satisfaction.

### 19.3. Design Review Process
-   **Heuristic Evaluation**: Regular expert reviews based on Nielsen's 10 Usability Heuristics.
-   **Accessibility Audit**: In addition to the CI Gate in §6, mandate quarterly manual A11y audit.
-   **Competitive Analysis**: Quarterly UX analysis of competing products.

### 19.4. AI-Augmented UX Research
-   **AI-Assisted Qualitative Analysis**:
    -   **Interview Transcription**: Leverage AI summarization tools (e.g., Otter.ai, Dovetail, Grain) to automate transcription and theme extraction from user interviews. However, **insight validation MUST be performed by humans**.
    -   **Pattern Detection**: Apply AI-based sentiment and theme classification to large volumes of qualitative data (NPS free-text, app store reviews, etc.) to accelerate discovery of priority issues.
-   **Synthetic Usability Testing**:
    -   **Law**: AI simulation-based synthetic user testing is a "supplementary tool" and MUST NOT replace real user testing.
    -   **Permitted Use**: Only for identifying rough issues in prototypes as a pre-screening step before real user testing.
-   **Behavioral Analytics Ethics**:
    -   AI-based user behavior prediction and segmentation MUST be disclosed in privacy policies and designed to be opt-out capable (§7 Ethical UX compliant).
-   **UX Data Quality Gate**:
    -   A/B tests MUST be conducted with sample sizes sufficient to achieve a minimum **statistical significance level of p<0.05**. Decision-making based on small samples is prohibited.
    -   **Novelty Effect Mitigation**: Run A/B tests for a minimum of 2 weeks to eliminate "Novelty Effect" bias.

---

## 20. Maturity Model & Anti-Patterns

### 20.1. UX Design Maturity Model (5 Levels)

| Level | Name | Characteristics |
|-------|------|-----------------|
| L1 | Ad-hoc | No design system. UI created by individual judgment. Zero consistency. |
| L2 | Emerging | Basic color palette and typography defined. Some component reuse. |
| L3 | Structured | Design Tokens defined. Figma-Code sync pipeline operational. WCAG AA compliant. A11y CI gate. |
| L4 | Integrated | W3C DTCG compliant tokens. Motion Token Architecture. Agentic AI UX implemented. Continuous UX research. |
| L5 | Optimized | Consistent design experience across all platforms. Spatial Computing ready. Data-driven UX optimization. Design System as a Product. |

### 20.2. Anti-Pattern Catalog (46 Items)

| # | Anti-Pattern | Impact |
|---|-------------|--------|
| 1 | Hardcoded colors | Theme switching impossible. Dark mode difficulties. |
| 2 | Div hell | A11y destruction. Screen reader unusable. |
| 3 | Z-index magic numbers | Layer conflicts. UI element invisibility. |
| 4 | Spinner dependency | CLS degradation. Perceived speed decrease. |
| 5 | Color-only information | Information loss for color vision diversity users. Legal risk. |
| 6 | Native date/time input | Cross-browser inconsistency. Design consistency destruction. |
| 7 | Unlabeled inputs | A11y bug. Screen reader unusable. |
| 8 | Double scrolling | Mobile UX destruction. Content unreachable. |
| 9 | Missing `alt` attribute | A11y legal deficiency. SEO penalty. |
| 10 | Technical jargon in UI | User churn. Support cost increase. |
| 11 | Focus ring removal | Keyboard user inability. Legal risk. |
| 12 | Modal Escape unhandled | A11y bug. User trapped. |
| 13 | Placeholder-only label | Purpose lost during input. A11y violation. |
| 14 | Dead-end error screen | 100% churn. Trust destruction. |
| 15 | Dark pattern usage | Legal risk (FTC/DSA/CPRA fines). Brand damage. |
| 16 | Fixed font size (px) | User settings ignored. A11y violation. |
| 17 | No double-submit prevention | Data duplication. Race Condition. |
| 18 | DnD clipping | Dragged element invisible. Operation impossible. |
| 19 | Custom carousel | Touch issues. A11y non-compliant. |
| 20 | Ad-hoc animations | No consistency. Performance degradation. prefers-reduced-motion ignored. |
| 21 | Headless UI violation | Component reuse impossible. Platform portability hindered. |
| 22 | Responsive not verified | UI breakage on mobile/tablet. |
| 23 | Scattered error messages | Translation leaks. Tone inconsistency. Maintenance difficulty. |
| 24 | IME-unaware search | CJK language user search failure. |
| 25 | 200% zoom untested | Content clipping. A11y violation. |
| 26 | Asymmetric consent UX | Regulatory violation (CPRA/DSA). Fine risk. |
| 27 | prefers-reduced-motion ignored | Health harm to vestibular disorder users. EAA violation. |
| 28 | Opaque AI output | User distrust. EU AI Act violation risk. |
| 29 | Design without schema | Implementation failure guaranteed. Rework cost increase. |
| 30 | No Design Tokens | Theme switching impossible. Multi-platform expansion blocked. |
| 31 | AI-generated UI released without review | Broken accessibility and inconsistent design infiltration. |
| 32 | Color-only data visualization | Information loss for color vision diversity users. Legal risk. |
| 33 | A/B test terminated ignoring Novelty Effect | Flawed decision-making. Inaccurate ROI measurement. |
| 34 | Design system without version control | Unmanaged breaking changes. Frequent regressions. |
| 35 | High bitrate-dependent visual effects | UX failure on low-power mode/slow networks. Green UX violation. |
| 36 | No ADHD/cognitive-considerate design | Cognitive overload. Lower task completion. Inclusion violation. |
| 37 | Notification/push abuse | User burnout. Increased app deletion risk. |
| 38 | Screen time manipulation design | Addiction-inducing design. Regulatory risk (DSA/UK Online Safety Act). Brand damage. |
| 39 | No VUI/Voice UI fallback | Dead-end on speech recognition failure. A11y violation. |
| 40 | Opaque personalization | User distrust. Filter bubble. EU AI Act violation risk. |
| 41 | No Token Scoping (global pollution) | Theme collision. Component isolation impossible. Large-scale ops failure. |
| 42 | Silent failure when offline | Data loss. User frustration. Increased churn rate. |
| 43 | No privacy indicator in Voice UI | Suspicion of always-listening. Regulatory risk (GDPR/CCPA). |
| 44 | No opt-out for personalization | Regulatory violation (GDPR Art.21/DSA). User trust erosion. |
| 45 | Stale UI served via outdated Service Worker | Cache pollution. Production bugs persist unexpectedly long. |
| 46 | Gender/cultural bias in voice commands | Reduced recognition accuracy for specific user groups. Inclusion violation. |
| 47 | No Passkey/biometric authentication UI | Forces legacy passwords. Phishing risk continues. WCAG 3.3.8 violation. |
| 48 | No trust signals on AI/user-generated content | EU DSA Art.16 violation risk. Misinformation spread. Brand damage. |
| 49 | No Conflict UI in real-time collaboration | Data overwrite/loss. Breakdown of user trust. |
| 50 | No Figma-to-code sync automation for design system | Permanent Token Drift. Quality degradation from design-implementation divergence. |

---

## 21. Design System Governance

### 21.1. Design System as a Product (DSaaP)
-   **Strategic Positioning**: A design system MUST be operated as a **Product**, not merely a library. Assign dedicated PM/DX engineers and manage a roadmap, backlog, and release cycle.
-   **SLA Definition**: Establish response SLAs for design system bug reports (e.g., Critical=24h, Major=1week, Minor=1month).
-   **Internal Customers**: Product teams are "customers" of the design system. Regularly collect user feedback (e.g., quarterly surveys) and make ROI visible.

### 21.2. Contribution Model
-   **Closed Model**: Only the core team can make changes. High quality but slow velocity. Suited for small teams.
-   **Federated Model**: Product teams can submit PRs under clear Contribution Guidelines. Quality gates (review + CI) are mandatory. **Recommended model.**
-   **Open Model**: For large organizations. A dedicated Design System Team serves as the final "gatekeeper" with approval authority.
-   **Governance Gate**: Regardless of model, only components passing the following gates may be released:
    1. Figma design review approval
    2. Accessibility (WCAG AA) compliance
    3. Jest/Storybook unit tests passed (≥80% coverage)
    4. Cross-browser and cross-device verification complete

### 21.3. Versioning & Deprecation
-   **SemVer Compliance**: Component libraries MUST be managed under `MAJOR.MINOR.PATCH` Semantic Versioning.
    -   **MAJOR**: Breaking changes (API signature changes, component deletion)
    -   **MINOR**: Backward-compatible feature additions
    -   **PATCH**: Bug fixes
-   **Deprecation Protocol**:
    1. Tag components with `@deprecated` and provide a migration guide to successor components
    2. Maintain a minimum deprecation period of **2 MINOR versions** (or 3 months)
    3. Send Deprecation Notices to consuming teams in advance
    4. After deprecation period ends, delete entirely (no stubs) to optimize bundle size
-   **Breaking Change Policy**: For MAJOR version bumps, providing migration scripts (codemods) is strongly recommended.

### 21.4. Design System Metrics
-   **Adoption Rate**: Measure what percentage of all UI components are composed of design system components. Target: **≥85%**.
-   **Component Health Score**: A composite metric of test coverage × accessibility score × Figma sync rate.
-   **Time-to-Ship Reduction**: Compare feature implementation effort before and after design system adoption to visualize ROI.

---

## 22. Data Visualization & Information Architecture

### 22.1. Data Visualization Principles
-   **Purpose First**: Select chart types based on the "message to convey", not "visual aesthetics".
    | Purpose | Recommended Chart Type |
    |---------|----------------------|
    | Change (time series) | Line chart, Area chart |
    | Comparison | Bar chart (horizontal/vertical), Grouped bar chart |
    | Proportion/Composition | Stacked bar chart (preferred over pie charts) |
    | Correlation | Scatter plot, Bubble chart |
    | Distribution | Histogram, Box plot, Violin plot |
    | Geographic data | Choropleth map, Proportional symbol map |
-   **Data-Ink Ratio**: Following Tufte's principle, eliminate unnecessary decoration (3D effects, excessive grid lines, gradients) and focus on the data itself.
-   **Zero-Line Mandate**: Bar chart Y-axes MUST always start at zero. Truncation creates exaggeration and distorts information.

### 22.2. Chart Accessibility
-   **Color-Only Prohibition**: Data series in charts MUST be distinguished using patterns (hatching), marker shapes (●■▲), and labels in addition to color.
-   **Text Alternative**: Provide a data summary for all charts via `aria-label` or `<title>`/`<desc>` tags.
    ```html
    <!-- SVG chart example -->
    <svg role="img" aria-labelledby="chart-title chart-desc">
      <title id="chart-title">Monthly Revenue Trend (2025)</title>
      <desc id="chart-desc">Monthly revenue from January to December 2025. Peak was August at $1.2M, lowest was February at $450K.</desc>
    </svg>
    ```
-   **Data Table Provision**: For complex charts, provide equivalent data in an HTML table or downloadable CSV.
-   **Interactive Support**: Enable keyboard navigation of data points (arrow keys) and announce selected values via `aria-live`.

### 22.3. Information Architecture
-   **5 Key IA Components (Rosenfeld/Morville)**:
    1. **Organization**: Classify content into logical groups (aligned with user mental models)
    2. **Labeling**: Consistent terminology (§10 Zero Jargon compliant)
    3. **Navigation**: Always clarify current location, destination, and return path
    4. **Search**: Faceted search and autocomplete as top priority
    5. **Discovery**: Progressive Disclosure to guide users toward advanced features
-   **Card Sorting**: When designing new navigation structures, conduct open/closed card sorting with users to validate mental models.
-   **Tree Testing**: Measure the rate at which users reach target content (Task Success Rate) with the final navigation structure. Target: **≥80%**.

### 22.4. Dashboard Design Standards
-   **Information Density Hierarchy**: Design dashboards in 3 layers:
    1. **Layer 1 (Summary / KPI)**: Most critical metrics at the top. Business state comprehensible at a glance.
    2. **Layer 2 (Analysis / Trend)**: Detailed charts and period comparisons.
    3. **Layer 3 (Detail / Drill-down)**: Individual records and Raw Data.
-   **Cognitive Load Limit**: Recommend a maximum of **7±2 charts** per dashboard view (Miller's Law).
-   **Real-Time Update**: When data auto-refreshes, display an update indicator (e.g., "Last updated: XX seconds ago") so users can gauge data freshness.

---

## 23. AI-Generated UI Governance

### 23.1. Quality Gate for AI-Generated Code (Vibe Coding Era)
-   **Background**: As UI generation via LLMs and AI coding assistants (GitHub Copilot, Cursor, Gemini, etc.) becomes mainstream, there is a sharply increasing risk of code that appears functional but lacks **accessibility, security, and design system consistency** entering the codebase.
-   **Mandatory Review Items for AI-Generated UI**:
    1. **A11y**: No WCAG AA-level violations detected by axe-core / Lighthouse
    2. **Design Token Consistency**: No hardcoded color or spacing values infiltrating the code
    3. **Component Duplication**: No possibility of substitution with existing design system components
    4. **TypeScript Type Safety**: No unrestricted use of `any` / `unknown`
    5. **Security**: No improper use of `innerHTML` or `dangerouslySetInnerHTML`
-   **Self-Serve Checklist**: When including AI-generated UI code in a PR, the author MUST self-verify the above 5 items and document the verification results in the PR description.

### 23.2. AI Content Disclosure
-   **Legal Context**: The EU AI Act (in force 2024) mandates disclosure of AI-generated text, images, audio, and video (Article 50).
-   **Disclosure UI Standards**:
    -   Display a dedicated badge for AI-generated content (e.g., ✨ AI Generated).
    -   **Glow Effect**: Visually distinguish AI content with a subtle gradient background (e.g., `linear-gradient(135deg, #667eea22, #764ba222)`).
    -   **Editability Disclosure**: When users can edit or delete generated content, provide clear UI affordances for those actions.
-   **Human Review Label**: Labels like "AI-generated, reviewed by experts" are effective for building trust. However, false "human-reviewed" labels are strictly prohibited.

### 23.3. Prompt Injection Defense in UI
-   **Risk**: When user input is directly concatenated into AI prompts, malicious users may manipulate prompts to trigger unintended behavior.
-   **UI-Layer Countermeasures**:
    -   Implement character count limits (`maxLength`) and character type restrictions on input fields.
    -   Clearly separate user input from internal prompt context to prevent conflation in the UI.
    -   Apply UI-layer validation for suspicious input (excessive special characters, extremely long text, etc.).

---

## 24. Cross-Platform Token Federation

### 24.1. Universal Token Pipeline
-   **Goal**: From a single design token definition (W3C DTCG format), automatically generate code for **Web, iOS, Android, Flutter, and Electron** to ensure design consistency across all platforms.
-   **Recommended Pipeline**:
    ```
    Figma Variables
        ↓ (Figma Variables Plugin or manual export)
    tokens.json (W3C DTCG format / Style Dictionary compatible)
        ↓ (Style Dictionary / Theo / Token Transformer)
    ├── CSS Custom Properties (Web)
    ├── Swift Package (iOS: UIColor, Font, Spacing)
    ├── Kotlin Object (Android: Color, Dimension)
    └── Dart Package (Flutter: ThemeData)
    ```
-   **CI Automation**: Build a CI pipeline that automatically generates and commits the above platform code for all platforms when a token definition file PR is merged.

### 24.2. Platform-Specific Token Overrides
-   **Tier 1 (Global)**: Base values shared across all platforms (colors, spacing base values)
-   **Tier 2 (Platform)**: Platform-specific overrides (e.g., iOS Dynamic Type, Android Material Dynamic Color)
-   **Tier 3 (Component)**: Component-level dedicated tokens
-   **Prohibition**: Directly overriding Tier 1 definitions in platform code is prohibited. Always create a Tier 2 Platform Override file to maintain change traceability.

### 24.3. Token Drift Detection
-   **Token Drift**: A state where code values have diverged from the design definition (Figma, etc.). It is a primary cause of design system quality degradation.
-   **Automated Detection**: Introduce CI scripts that automatically compare token values in implementation code against Figma/tokens.json definitions during PR review and report discrepancies.
-   **Weekly Sync**: Generate a weekly Token Drift Report and establish a cycle for both design and engineering teams to review it.

---

## 25. Sustainability & Green UX

### 25.1. Digital Carbon Footprint
-   **Background**: The global ICT industry accounts for approximately 4% of CO2 emissions—equivalent to the aviation industry. UI design choices directly impact energy consumption.
-   **Measurement Tools**: Use Website Carbon Calculator, Ecograder, or Sustainableweb to quantitatively measure page CO2 emissions.
-   **Target**: Set a CO2 emission target of **≤0.5g CO2/page view** for new pages (global median: ~0.8g).

### 25.2. Eco-Friendly UI Design
-   **Dark Mode Power Consumption**: On OLED displays, pure black (#000000) backgrounds can reduce power consumption by up to 60%. Dark mode is simultaneously a UX initiative and a Green initiative.
    -   **Pure Black Option**: Providing a "Pure Black" theme option based on `#000000` as a dark mode variant is recommended.
-   **Animation Power Efficiency**:
    -   `prefers-reduced-motion` compliance (§16.2) is both a legal obligation and a power-saving measure.
    -   Eliminate unnecessary infinite-loop animations (other than loading indicators).
-   **Image & Video Optimization**:
    -   Prioritize AVIF format (30% reduction vs. WebP) with WebP as fallback.
    -   Auto-play video is prohibited (§6 Auto-Play Ban compliant). User-initiated playback only.
    -   Standardize `loading="lazy"` for all off-screen images.
-   **Font Optimization**:
    -   Subset web fonts using `unicode-range` to include only the required character ranges.
    -   Prefer system font stacks when feasible.

### 25.3. Carbon-Aware UX
-   **Concept**: A design approach that leverages real-time variation in electricity grid carbon intensity (g CO2eq/kWh) to schedule heavy processing during periods when renewable energy is abundant.
-   **Application Scenarios**:
    -   Provide scheduling UIs for large batch processing (AI training, video encoding, etc.) that run during low-carbon periods.
    -   Consider a "Green Mode" that automatically switches to high-quality rendering during low carbon intensity periods and compressed data mode during high carbon intensity periods.
-   **APIs**: Use Electricity Maps API, WattTime API, etc. to retrieve carbon intensity data.

### 25.4. Sustainable Design Ops
-   **Deprecation Cleanup**: Remove deprecated, unused components from bundles to reduce user download size.
-   **Third-Party Script Audit**: Periodically audit third-party scripts (analytics, ads, chat widgets, etc.) and remove unnecessary ones. Weigh each script's CO2 cost against its business value.
-   **Performance Budget (Page Weight)**:
    | Resource Type | Budget Limit |
    |---------------|-------------|
    | HTML | 50KB |
    | CSS (compressed) | 100KB |
    | JS (compressed) | 300KB |
    | Images (total) | 500KB |
    | Web Fonts | 100KB |
    - Budget overruns MUST be detected and flagged in CI/CD build gates (Bundlesize, Lighthouse CI, etc.).

## 26. Neurodiversity & Inclusive UX

### 26.1. Neurodiversity Design Principles
-   **Background**: Users with neurodivergent conditions such as ADHD, ASD (Autism Spectrum Disorder), Dyslexia, and Sensory Processing Disorder are estimated to comprise approximately 15–20% of the population (WHO). Considering these users is an accessibility obligation and simultaneously improves the experience of all users (**Social Model of Disability**).
-   **ADHD-Friendly Design**:
    -   **Cognitive Load Reduction**: Minimize information density per screen and use Progressive Disclosure to present information incrementally.
    -   **Visual Focus Guidance**: Apply visual "focus emphasis" (border reinforcement, color highlights) to important CTAs and forms to assist attention guidance.
    -   **Task Chunking**: Split long forms or tasks into multiple steps and provide explicit feedback upon completion of each step.
    -   **Enforce Auto-Save**: Considering mid-input abandonment, strictly adhere to §14.5 Auto-Save Protocol.
    -   **Minimize Interruption Notifications**: Keep in-task interrupt notifications to a minimum (provide granular notification control settings).
-   **ASD-Friendly Design**:
    -   **Absolute Consistency**: Per-screen UI pattern variations cause significant stress for ASD users. Enforce §20.0 The Consistency Mandate to the maximum degree.
    -   **Eliminate Ambiguous Expressions**: Eliminate icon-only buttons, context-dependent abbreviations, and implicit operation procedures. Always provide labels and explicit explanations.
    -   **Sensory Stimulus Control**: Eliminate auto-play video, flashing elements, and intense particle effects. Providing settings for users to adjust sensory stimulus levels is recommended.
-   **Dyslexia-Friendly Design**:
    -   **Font Selection**: Adopt dyslexia-friendly fonts (OpenDyslexic, etc.) as a switchable option, or use highly readable general fonts (Inter, Atkinson Hyperlegible, etc.) as defaults.
    -   **Character Spacing & Line Height**: Use `letter-spacing: 0.05em` or more and `line-height: 1.6` or more as body text baselines (per §1.1 Typography Localization Protocol).
    -   **Left-Aligned Text**: Justified (full-width-aligned) text creates uneven word spacing that makes reading difficult for dyslexic users. **Text must always be left-aligned (`text-left`)**.
    -   **Contrast Options**: Pure white backgrounds (#FFFFFF) can be too glaring for some dyslexic users. Providing a "Soft White" (e.g., `#FAF9F6`) or "Paper" theme is recommended.

### 26.2. Cognitive Accessibility
-   **COGA Compliance (W3C Cognitive and Learning Disabilities Accessibility Task Force)**: Following W3C COGA guidelines (to be integrated into WCAG 2.1/2.2), implement:
    -   **Recognizable Patterns**: Use industry-standard UI patterns (hamburger menu, search icon, etc.) to leverage cognitive familiarity.
    -   **Error Prevention**: Provide confirmation screens before form submission and pre-disclose input constraints (character limits, allowed character types, etc.).
    -   **Timeout Warnings**: Alert users at least **20 seconds before** session timeout and provide an extension option (WCAG 2.2 2.2.6).
    -   **Simple Navigation**: Maintain a navigation structure where primary features are reachable within 3 clicks.
-   **Reading Level**: UI text directed at users should be kept at a difficulty level understandable to middle school students (approximately 6th-8th grade reading level for English). Flesch-Kincaid readability checks are recommended.

### 26.3. Inclusive Language Protocol
-   **Prohibit Outdated Terms**: Do not use terms that negatively characterize disability conditions (outdated clinical or derogatory language).
-   **Person-First / Identity-First Choice**: Whether to use "person with a disability (Person-First)" or "disabled person (Identity-First)" should follow community preferences. User research is recommended before standardizing on either.
-   **Gender-Neutral Language**: Avoid expressions that assume a specific gender (e.g., "he," "male user," etc.) and use gender-neutral expressions (e.g., "the user," "the team member").
-   **Cultural Sensitivity**: Colors, symbols, and illustrations carry different cultural meanings by region (e.g., white symbolizes mourning in some Asian contexts). Conduct cultural validation of icons, colors, and illustrations when expanding globally.

---

## 27. Digital Wellbeing & Ethical Digital Design

### 27.1. Digital Wellbeing Design Principles
-   **Background**: From 2025 onward, the UK Online Safety Act, EU DSA (Digital Services Act), US CHILDS proposals, and similar regulations are making "Design-based Manipulation" — particularly towards minors — a subject of regulation. Wellbeing design is both an ethical obligation and legal risk management.
-   **Screen Time Respect Protocol**:
    -   **Design Natural Stopping Points**: Design explicit "ending points" at content endpoints (end of articles, end of videos). Chains of infinite scroll and auto-play may be viewed as design-based addiction induction.
    -   **Break Reminders**: For apps expected to be used for extended periods (games, social media, learning apps, etc.), providing optional break reminder functionality after a set time (e.g., 60 minutes) is recommended. Make it configurable to turn off.
    -   **Usage Time Visualization**: Providing dashboards where users can understand and control their in-app usage time is recommended.
-   **Anti-Addiction Pattern Checklist**:
    -   **Prohibited**: Limitless infinite scroll (no endpoint)
    -   **Prohibited**: Notifications that excessively promote social comparison ("User X has achieved more than you")
    -   **Prohibited**: UX that induces fear of losing badges or streaks (Loss Aversion Exploitation)
    -   **Prohibited**: Targeted advertising/profiling for minor users
    -   **Recommended**: Gentle disengagement nudges (e.g., "Would you like to wrap up for today?")

### 27.2. Vulnerable User Protection
-   **Age Verification & Age-Appropriate Content**: Implement appropriate age verification UIs for age-restricted content (alcohol, gambling, adult content, etc.) and prevent access by minors.
-   **Mental Health Consideration**: Content dealing with self-harm or suicide-related topics must always provide crisis support resources (emergency contacts, etc.) in accordance with Safe Messaging Guidelines (WHO guidelines).
-   **Gambling-Like UX Prohibition**: When implementing random reward mechanisms (gacha, loot boxes, etc.):
    1. Disclose probabilities explicitly (mandated by many regulations)
    2. Provide monthly spending cap (Spending Cap) setting functionality
    3. Prohibit provision to minor users

### 27.3. Privacy by Design in UX
-   **Data Minimization UX Expression**: Place inline "Why this data is needed" explanatory text at collection points to communicate data minimization to users.
-   **Consent Fatigue Prevention**: Do not flood users with consent banners and pop-ups. Request only essential consents and consolidate optional items in a settings screen.
-   **Data Deletion UX**: Account deletion and data deletion flows must:
    1. Be placed in easily discoverable locations (Settings > Account, etc.)
    2. Be initiatable within 2 clicks
    3. Allow users to track deletion progress until completion within 30 days (GDPR compliant)
-   **Cross-Reference**: §7 (User Sovereignty & Ethical UX), `security/100_data_governance.md`

### 27.4. Ethical AI & Algorithmic Transparency
-   **Algorithm Recommendation Transparency**: Provide UI (e.g., "Why is this shown to me?" and "Show less of this") that allows users to understand and control the basis of recommendations (content recommendations, search rankings, etc.).
-   **Bias Disclosure**: In contexts where AI influences human decisions (hiring screening, credit scoring, etc.), there is an obligation to disclose the training data and model bias risks of AI systems to users (EU AI Act Art. 13 compliant).
-   **Human Override**: For significant decisions (insurance rejection, loan screening, hiring rejection, etc.), the right for users to request human review of AI-automated decisions (EU AI Act Art. 14 compliant) must be made explicit in the UI.

---

## 28. Voice & Conversational UX

### 28.1. Voice UI Design Principles (VUI)
-   **Background**: The rapid expansion of smart speakers, voice assistants (Siri, Google Assistant, Alexa), in-vehicle UIs, XR headsets, and LLM-based conversational AI has made **voice a primary UI paradigm**. From 2026 onward, VUI design is a core domain, not an optional feature.
-   **Voice-First vs. Voice-Enhanced**:
    -   **Voice-First**: Voice is the only interface (smart speakers, in-vehicle). No visual UI.
    -   **Voice-Enhanced**: Voice added to existing GUI (voice commands in mobile apps, website read-aloud). MUST coexist with visual accessibility (§6).
-   **VUI Feedback Triad (3-Step Feedback)**:
    1. **Acknowledgment**: Immediately confirm that the user's voice input was received (e.g., "Got it", "One moment please").
    2. **Progress**: For longer processing, periodically provide status (e.g., "Searching...").
    3. **Result**: Return the result in a concise, actionable form.
-   **7 Principles of Conversational Design**:
    1. **Brevity**: Voice responses must be shorter than visual responses. Max 3 choices per response.
    2. **Context Retention**: Remember the context of previous utterances. Never ask for the same information twice.
    3. **Natural Language Tolerance**: Accept paraphrase variations (treat "cancel", "stop", "quit", "exit" as synonyms).
    4. **Graceful Fallback**: On recognition failure, follow 3 steps: apologize → ask again → offer an alternative input method.
    5. **Initiative Balance**: Design "Open Prompts" where users can take the lead, rather than AI-only-driven flows.
    6. **Error Prevention**: High-stakes actions (deletion, purchase) MUST require voice confirmation ("Are you sure you want to delete?").
    7. **Exit Path**: Always support exit commands ("cancel", "stop", "help") at any point in the conversation.

### 28.2. Voice Accessibility
-   **WCAG 2.2 + Voice Guidelines**: Voice UIs must also satisfy WCAG 2.2 Understandable and Operable principles.
-   **STT/TTS Quality Standards**:
    -   **STT (Speech-to-Text)**: Periodically measure recognition accuracy across target locale accents, dialects, and noisy environments. Target: **≥95% recognition accuracy on primary use cases**.
    -   **TTS (Text-to-Speech)**: Read aloud at natural cadence and speed (150–160 wpm) and support SSML (Speech Synthesis Markup Language) to customize pronunciation of proper nouns and acronyms.
-   **Multi-Language / Multi-Dialect Support**: Design to tolerate dialect variations or provide a graceful prompt for users to speak more clearly. Rigid dialect rejection causes user churn.
-   **Noisy Environment UX**: For high-noise environments (public transit, etc.), provide a Push-to-Talk UI (record only while button is held) as a fallback.

### 28.3. Voice Privacy & Consent
-   **No Always-On Listening by Default**: Recording beyond Wake Word is prohibited by default. Prefer Push-to-Talk or explicit activation gestures.
-   **Recording State Visual Indicator**: When the microphone is active, MUST display a visual indicator (red blinking dot, microphone icon). Designs where users cannot tell if they are being listened to are strictly prohibited.
-   **Voice Data Retention Policy Disclosure**: Explain the retention period, purpose, and third-party sharing of voice recordings to users in plain language at the point of collection. Verify GDPR/CCPA compliance.
-   **Data Deletion UI**: Place a clear UI for users to delete their voice history in a prominent location in settings (per §27.3 Data Deletion UX).

### 28.4. Voice + Visual Integration (Multimodal)
-   **Voice + Screen Coordination**: When reflecting voice command results in the visual UI, keep the gap between voice response and screen update within 100ms (maintaining perceived performance, per §17.1).
-   **Handoff Protocol**: When a user switches from voice input to touch mid-interaction, design a "modality handoff" that carries input content seamlessly without data loss.
-   **Context Sharing**: When a user says "delete this", implement context linking so the system accurately understands "this" refers to the focused element on screen.

---

## 29. Adaptive & Personalization UX

### 29.1. Ethical Design Principles for Personalization
-   **Background**: From 2026 onward, AI-powered Hyper-Personalization is the frontline of competitive advantage. However, risks of **filter bubbles, privacy violations, bias amplification, and addiction induction** are also growing. The following principles are design judgment criteria for maintaining that balance.
-   **4 Ethical Personalization Principles**:
    1. **Transparency**: Users can recognize that personalization is active (e.g., "Showing based on your preferences").
    2. **Controllability**: Users can adjust the intensity of personalization or disable it entirely.
    3. **Diversity**: To prevent filter bubbles (confinement to homogeneous content), embed intentional "Serendipity Injection" of diverse content into the design.
    4. **Explainability**: Provide a feature for users to verify "why this is shown" (per §7 Transparency).

### 29.2. Context-Adaptive UI Patterns
-   **Time-of-Day Adaptation**: Adapt the UI based on the user's usage time of day.
    -   Morning: Summary/digest-first view prioritizing key takeaways
    -   Evening: Automatic shift to lower contrast and warmer color tones (Blue Light Reduction)
-   **Frequency-Based Adaptation**: Prioritize frequently used features in the UI and progressively simplify rarely used ones (Progressive Disclosure adaptive version).
-   **Device Context Adaptation**:
    -   Mobile: Automatically switch to one-hand optimized layout
    -   Desktop: Expand to professional view with keyboard shortcuts and high-density information
    -   XR/Spatial: Anchor UI in space (per §18)
-   **Network-Aware Design**: Dynamically lower image/video quality and switch to low-bandwidth mode based on connection quality (adaptive serving).
    ```javascript
    // Network Information API (implementation reference)
    const connection = navigator.connection;
    if (connection.effectiveType === '2g' || connection.saveData) {
      // Switch to low-quality mode: higher image compression, disable video
      setQualityMode('low');
    }
    ```

### 29.3. Privacy Design for Personalization
-   **Data Minimization Obligation**: Data required for personalization must be the minimum necessary. Excessive collection for the purpose of building a full user profile is prohibited.
-   **On-Device Inference First**: From a privacy-protection perspective, prioritize architectures that perform inference on-device without sending data to servers (Core ML, TensorFlow Lite, etc.).
-   **Opt-Out UI Mandate**: Based on GDPR Art. 21 (Right to Object), place a UI in a prominent location in settings where users can object to personalization processing and request it to stop.
-   **Ethical Boundaries for A/B Testing**: Personalization experiments (A/B tests) within the same user group must be designed to IRB (Institutional Review Board) equivalent standards, with prior assessment of impacts on price discrimination and vulnerable users.

### 29.4. Technical Governance for Adaptive Design
-   **Feature Flag Integration**: Control personalization features via Feature Flags (LaunchDarkly, etc.) and maintain designs that allow immediate global rollback when issues arise.
-   **Model Drift Monitoring**: Periodically monitor the recommendation accuracy of personalization models and trigger automatic alerts when accuracy falls below thresholds (e.g., CTR drops by ≥20%).
-   **Group Fairness Validation**: Conduct quarterly verification that personalization results do not produce unfair disparities for specific demographic groups (gender, age, ethnicity, etc.).

---

## 30. Design Tokens 2.0 / Advanced Token Architecture

> [!NOTE]
> This section is an advanced extension of §2 (Design Tokens foundational rules). It presupposes §2 fundamentals and addresses advanced token management at enterprise scale from 2025 onward.

### 30.1. Figma Variables 2.0 & DTCG Modes (Scopes and Modes)
-   **Scoping**: Use Figma Variables' "Scope" feature to restrict the applicable properties of each token, eliminating the risk of color tokens being misapplied as spacing at design time.
    ```
    color-primary: scope=[Fill, Stroke] (NOT spacing, NOT font-size)
    spacing-4: scope=[Gap, Padding, Margin] (NOT color)
    ```
-   **Modes**: Implement the W3C DTCG "$theme" concept to generate multiple modes from a single token definition.
    ```json
    {
      "color-bg-surface": {
        "$type": "color",
        "$value": "oklch(98% 0 0)",
        "$modes": {
          "dark": "oklch(10% 0 0)",
          "high-contrast": "oklch(100% 0 0)",
          "pure-black": "oklch(0% 0 0)"
        }
      }
    }
    ```
-   **Nested Modes**: Manage combinations of brand modes × theme modes.
    ```
    Brand A / Light → Brand A / Dark
    Brand B / Light → Brand B / Dark
    ```

### 30.2. Component-Scoped Tokens
-   **Problem**: With only global tokens, a style change to Component A can unintentionally propagate to Component B — a "global pollution" issue.
-   **Solution — Component-Local Tokens**:
    ```css
    /* Isolate component-specific tokens via CSS variable namespacing */
    .c-button {
      --c-button-bg: var(--color-primary);
      --c-button-fg: var(--color-on-primary);
      --c-button-radius: var(--radius-md);
      background: var(--c-button-bg);
      color: var(--c-button-fg);
      border-radius: var(--c-button-radius);
    }
    /* Component variant overrides modify only local tokens */
    .c-button--danger {
      --c-button-bg: var(--color-error);
    }
    ```
-   **Naming Convention**: Standardize component-local tokens as `--c-{component}-{property}` and clearly distinguish them from global tokens (`--color-*`).

### 30.3. Enterprise Multi-Brand Token Management
-   **Brand Hierarchy Design**:
    ```
    Tier 0: Primitive Tokens (raw values: blue-500, space-4)
    Tier 1: Global Semantic Tokens (color-primary) ← common across brands
    Tier 2: Brand Tokens (brand-a-color-primary) ← brand-specific overrides
    Tier 3: Component Tokens (button-bg) ← component-specific
    ```
-   **Token Library as NPM Package**: At enterprise scale, publish token definitions as a private NPM package shared across all products via `@company/tokens` imports. Apply SemVer to version management (per §21.3).
-   **Token Diff PR Automation**: Build a GitHub Actions workflow that automatically comments a token diff report (summary of additions, changes, and deletions) on `tokens.json` change PRs.

### 30.4. Runtime Token Injection
-   **Dynamic Multi-Tenant Support**: In SaaS and multi-tenant apps, fetch per-tenant brand colors from the DB and dynamically inject them as CSS custom properties in a `<style>` tag.
    ```typescript
    // Server-side token injection example (Next.js App Router)
    async function RootLayout({ children }) {
      const tenant = await getCurrentTenant();
      const tokens = tenant.brandTokens; // { primaryColor: 'oklch(55% 0.2 250)' }
      return (
        <html>
          <head>
            <style>{`:root { --color-primary: ${tokens.primaryColor}; }`}</style>
          </head>
          <body>{children}</body>
        </html>
      );
    }
    ```
-   **CSP Compliance**: Dynamic `<style>` injection may violate Content Security Policy `style-src` directives. Consider Nonce-based style injection or CSS Variables via `element.style.setProperty()` as alternatives.

---

## 31. Edge & Offline-First Design

### 31.1. Offline-First Design Philosophy
-   **Background**: Approximately 4 billion people worldwide use slow or unstable mobile connections (2G/3G). A UI that assumes constant connectivity fails as a global product. Offline-first is both an ethical and business imperative.
-   **4 Levels of Offline-First**:
    | Level | Coverage | Target State |
    |-------|----------|--------------|
    | L0 | Silent crash when offline | ❌ Prohibited |
    | L1 | Offline detection + user notification | ✅ Minimum standard |
    | L2 | Read from cache (read-only offline) | ✅ Recommended |
    | L3 | Offline writes + auto-sync on reconnect (Background Sync) | ✅ Gold standard |
-   **Design Principles**:
    -   Design for network as: "faster when available, functional when not".
    -   Treat local as the source of truth for data operations; sync with server asynchronously (Offline-first CRDT philosophy).
    -   Provide non-intrusive UI so users can always recognize their current connectivity state.

### 31.2. Service Worker Design Governance
-   **Cache Strategy Selection**:
    | Strategy | Use Case | Description |
    |----------|----------|-------------|
    | Cache First | Static assets (CSS/JS/Font/Icon) | Cache-priority. Fallback to network if cache miss. |
    | Network First | API responses, dynamic content | Network-priority. Fall back to cache on failure. |
    | Stale While Revalidate | News feeds, product listings | Return cache immediately while revalidating from network in background. |
    | Network Only | Payments, auth, security-sensitive ops | No caching. Always via network. |
-   **Service Worker Update Governance**:
    -   **Update Detection UI**: When a new Service Worker version enters waiting state, display a "New version available. Update now?" banner to users and trigger `skipWaiting()` via user action.
    -   **No Silent Force Update**: Silent auto-update in the background (automatic `skipWaiting()` during active user sessions) is prohibited as it causes data loss.
    -   **Version Management**: Include the Service Worker version in the cache name (e.g., `cache-v1.2.3`). Always implement old cache deletion (`caches.delete()`) on version upgrade.

### 31.3. Background Sync & Push UX
-   **Background Sync**:
    -   Queue actions performed by users while offline (form submissions, data updates, etc.) in IndexedDB and auto-submit when connectivity is restored.
    -   On successful submission, notify users via Toast: "Your entry has been saved (recorded while you were offline)".
    -   On submission failure (e.g., 409 Conflict), present users with choices ("Overwrite with local version", "Accept server version", "Manual merge") to preserve user agency.
-   **Web Push Notifications Governance**:
    -   **Permission Request Timing**: Requesting notification permission immediately after `DOMContentLoaded` results in rejection rates above 90% due to lack of user context. Always request after the user understands the value (after first key action completion, or on a dedicated "Notification Settings" page).
    -   **Notification Frequency Cap**: Recommend a maximum of **3 push notifications per day** (per §27.1 Anti-Addiction Pattern).
    -   **Notification Relevance Scoring**: Before sending, evaluate "Is this highly relevant to this user right now?" using a model, and implement push scoring that only sends when the relevance score exceeds a threshold.

### 31.4. IndexedDB & Local Data Design
-   **Schema Version Management**: IndexedDB schema changes (adding/removing Object Stores, index changes) MUST be managed via version numbers (`onupgradeneeded`). Schema migration failures cause data loss.
-   **Library Recommendation**: Raw IndexedDB API is complex and error-prone. Use `Dexie.js` or `idb` instead. Both also provide TypeScript type safety.
    ```typescript
    // Dexie.js usage example
    import Dexie from 'dexie';
    const db = new Dexie('MyApp');
    db.version(1).stores({ drafts: '++id, createdAt, syncStatus' });
    db.version(2).stores({ drafts: '++id, createdAt, syncStatus, priority' });
    // v2 adds priority field (automatic migration)
    ```
-   **Storage Quota Management**: Monitor local storage usage with `navigator.storage.estimate()` and notify users / prompt cache cleanup when usage exceeds 85%.
-   **Prohibition on Local Storage of Sensitive Data**: Storing sensitive information such as passwords, credit card numbers, and security tokens in IndexedDB/localStorage is strictly prohibited (per security rules in `security/000_security_privacy.md`).

---

## 32. Gamification Design Governance

> [!WARNING]
> Gamification is simultaneously a tool for increasing engagement and a tool for inducing dependency. The following rules define design judgment criteria for maintaining that balance.

### 32.1. Gamification Design Principles

-   **Purpose-Driven Gamification**: Before introducing gamification elements (badges, points, rankings, streaks, etc.), clearly define "what behavioral change is being encouraged." Introducing gamification solely to "somehow increase engagement" is prohibited.
-   **Behavioral Science Foundation**:
    -   **Protecting Intrinsic Motivation**: External rewards (points, badges) increase short-term engagement, but over-reliance diminishes intrinsic motivation ("using it because it's fun") — the **Undermining Effect**. Only attach rewards to behaviors with inherent value.
    -   **Prohibition of Variable Ratio Schedules**: Implementation of random rewards (gacha, etc.) must be strictly governed per §27.2 (Gambling-Like UX Prohibition).
    -   **Milestone-Based Rewards Recommended**: Design rewards granted at meaningful milestones as "commemorations of achievement." These should function as meaningful progress visualization, not arbitrary rewards.

### 32.2. Game Mechanics Implementation Guidelines

-   **Badge Design**:
    -   **Scarcity Balance**: Badges lose value when too easily attained. However, badges that are too difficult cause churn. Target an attainment rate achievable by the **top 20–40% of users**.
    -   **Meaningful Achievement**: Badges must be "commemorations of genuinely meaningful actions." Auto-granted badges for simple login counts quickly lose their value.
    -   **Opt-Out Provision**: Provide opt-out settings for users who do not wish to receive badge notifications or participate in rankings.
    -   **Accessibility**: Provide `alt` text for badge images to ensure screen readers accurately convey badge meaning.

-   **Points / Currency Design**:
    -   **Transparent Exchange Rate**: Clearly display the exchange rate between points and actual value (currency, rewards). Points that "somehow accumulate" erode user trust.
    -   **Expiration UX Sensitivity**: When points are approaching expiration, design notifications that encourage spending but **do not induce anxiety** (maintain the boundary with Loss Aversion Exploitation).
    -   **Minor User Purchase Limits**: If a point purchase feature exists, implement purchase caps for minor users and a parental consent flow.

-   **Leaderboard Design**:
    -   **Ethics of Relative Comparison**: Global rankings force "comparison with others," causing discomfort for lower-ranked users. Prioritize **local rankings (friends only)** or **self-comparison (against last week's self)**.
    -   **Privacy**: Listing in rankings defaults to OFF (opt-in only) is recommended.
    -   **Competition vs. Cooperation Balance**: Cooperative gamification (team challenges, etc.) carries lower social division risk than competitive models and is effective for community building.

-   **Streak Design**:
    -   **Prohibition of Exploiting Loss Aversion (Linked to §27.1 Anti-Addiction Pattern)**: Making excessive fear of losing a streak the core of the design is prohibited. Base the design on positive reinforcement ("I did it again today") and eliminate coercive messaging like "losing it makes everything pointless."
    -   **Streak Protection Feature**: Providing a "Streak Shield" or similar protection for unavoidable interruptions (travel, illness, etc.) is recommended. Excessive penalties negatively impact wellbeing.

### 32.3. Gamification Measurement & Ethics Audit

-   **KPIs**:
    | Metric | Purpose | Note |
    |--------|---------|------|
    | Task Completion Rate | Determine behavioral change success | Primary goal |
    | Session Duration | Engagement measurement | Excessive increase is a dependency signal |
    | Opt-Out Rate | Gamification rejection rate | High rate signals design revision needed |
    | NPS (Net Promoter Score) | Overall satisfaction | Compare before and after gamification introduction |

-   **Quarterly Ethics Audit**: Verify the following each quarter:
    1.  **Dependency Metrics**: Is the DAU/MAU ratio rising sharply beyond design intent?
    2.  **Vulnerable User Impact**: Is there abnormal concentration of spending/usage time among minor users?
    3.  **Regulatory Compliance**: Alignment with DSA, UK Online Safety Act, and applicable national consumer protection laws
    4.  **Dark Pattern Verification**: Consistency with §7's dark pattern prohibition list

---

## 33. Design QA & Visual Regression

> [!NOTE]
> Visual regression prevention is the "guardian of quality." This section defines the framework for continuously and automatically guaranteeing that design system changes do not introduce unintended destructive effects on UI.

### 33.1. Visual Regression Testing Framework

-   **Law**: Component changes, token updates, and library upgrades that introduce unintended visual changes (regressions) to existing UI are the worst form of "silent bugs" — changes that reviewers cannot catch slip into production. Visual regression testing is a mandatory CI requirement.
-   **Recommended Tools**:
    | Tool | Characteristics | Recommended Use Case |
    |------|----------------|---------------------|
    | **Chromatic** | Storybook integration. Cloud-based visual diff. For SaaS projects. | Mainstream recommendation |
    | **Percy** (BrowserStack) | Strong cross-browser support. Enterprise-grade. | Cross-browser compatibility-critical projects |
    | **Playwright + pixelmatch** | E2E screenshot comparison. Self-hosted. Cost-conscious. | Open-source-oriented projects |
    | **Backstop.js** | Simple setup. Page-level comparison. | Retroactive addition to legacy projects |

-   **CI Pipeline Integration**:
    ```yaml
    # GitHub Actions: Visual Regression Example (Chromatic)
    - name: Run Chromatic Visual Testing
      uses: chromaui/action@v11
      with:
        projectToken: ${{ secrets.CHROMATIC_PROJECT_TOKEN }}
        exitOnceUploaded: false
        onlyChanged: true  # Only Stories related to changed files
        autoAcceptChanges: false  # Always require human review
    ```

### 33.2. Storybook Design Governance

-   **Story Coverage Mandate**:
    -   All new UI components MUST include at minimum the following Stories:
        1.  **Default**: Default state
        2.  **Loading**: Skeleton/spinner state during data fetching
        3.  **Error**: Error state (error message + recovery UI)
        4.  **Empty**: Empty data state (per §10 Empty State guidelines)
        5.  **Dark Mode**: Dark theme (`globals.theme: 'dark'`)
        6.  **Mobile (375px)**: Layout at mobile width
    -   **A11y Addon Mandate**: Install `@storybook/addon-a11y` in all projects to automatically run axe-core accessibility checks with each Story render.
    -   **Token Coverage**: Components using Design Tokens must document token value violations (hardcoded values) alongside Storybook args.

-   **Story Quality Gate**:
    ```typescript
    // Required fields in Storybook meta definition
    const meta: Meta<typeof Button> = {
      title: 'UI/Button',
      component: Button,
      tags: ['autodocs'],          // Auto-documentation generation
      parameters: {
        a11y: { disable: false },  // Always enable A11y checks
        chromatic: {
          modes: {                 // Chromatic mode support
            light: { theme: 'light' },
            dark: { theme: 'dark' },
          },
        },
      },
      argTypes: {
        // Explicitly define all Props (ensure documentation quality)
      },
    };
    ```

### 33.3. Design QA Process

-   **Mandating a Design QA Phase**: MUST incorporate a **Design QA phase** as a required step in the release flow for new features and UI modifications.
    ```
    Design (Figma)
        ↓
    Implementation (Code)
        ↓
    【Design QA】← Required step
      ├── Visual comparison with Figma design (using Dev Mode)
      ├── Visual regression test approval (Chromatic, etc.)
      ├── A11y automated check (axe-core CI)
      └── Responsive verification across 3 environments (§5.1 Universal Beauty Protocol)
        ↓
    Staging verification
        ↓
    Production release
    ```

-   **Design Review Checklist (Pre-PR Merge)**:
    | Checklist Item | Owner | Verification Method |
    |----------------|-------|---------------------|
    | Implementation matches Figma design | Designer or Frontend Engineer | Figma Dev Mode + Browser comparison |
    | No visual regressions | CI auto + Reviewer approval | Chromatic / Percy |
    | No A11y violations (critical/serious) | CI auto | axe-core / Lighthouse |
    | Design Token compliance | CI auto | Token Drift Checker (§24.3) |
    | Dark mode display verification | Implementer + Reviewer | Storybook / DevTools |
    | Mobile (375px) display verification | Implementer | DevTools / Physical device |

-   **Pixel-Perfect Definition**: Requiring 100% pixel-perfect match is unrealistic. Apply the following tolerance standards:
    -   **Tolerated**: Font rendering differences (across OS/browser): ±1px
    -   **Tolerated**: Color differences due to anti-aliasing: ≤5% luminance difference
    -   **Not Tolerated**: Spacing differences, explicit color changes, element position shifts (≥2px)

### 33.4. Storybook-Driven Development (SDD)

-   **SDD Recommended**: The approach of developing new components first in Storybook before integrating into pages (Storybook-Driven Development) is recommended.
    -   **Benefits**: Components available for immediate isolated review. A11y checks applied early. Faster feedback loop with designers.
    -   **Workflow**:
        1. Review design in Figma
        2. Implement component in Storybook (using mocks/MSW)
        3. Designer reviews and approves in Storybook
        4. Integration into pages
        5. Visual regression approval via Chromatic

---



## 34. Biometrics & Authentication UX

> [!IMPORTANT]
> Passkeys and biometric authentication are the "gold standard for frictionless authentication". As of 2026, FIDO2/WebAuthn support is a mandatory requirement for all new products.

### 34.1. Passkey (FIDO2/WebAuthn) UX Design Principles

-   **Background**: Apple, Google, and Microsoft completed platform-wide passkey support (2023–), and as of 2026, passkeys are supported across all major browsers and OSes as the "successor standard to passwords". Under WCAG 2.2 3.3.8 (Accessible Authentication), adopting authentication methods that do not require complex cognitive tasks is a **legal obligation**.
-   **Passkey-First Design Principles**:
    1.  **Registration Flow UX**: Display a "Set up a passkey?" banner immediately after the first successful login or account creation, and actively guide users toward the secure authentication method.
    2.  **Authentication Trigger UI**: Passkey authentication button labels MUST explicitly state the biometric type: "Sign in with Face ID", "Sign in with fingerprint", etc. The generic label "Sign in with passkey" is also acceptable.
    3.  **Fallback Guarantee**: When a device does not support passkeys or authentication fails, always clearly present alternative methods: SMS OTP, email OTP, or password.
    4.  **Cross-Device Support**: Implement CTAP2 (Cross-Device Authentication) UI using QR codes, enabling authentication via a smartphone passkey even in a PC browser.

    ```typescript
    // WebAuthn Authentication Flow Implementation (Minimum configuration)
    async function authenticateWithPasskey() {
      const options = await fetchAuthenticationOptions(); // Retrieve challenge from server
      try {
        const credential = await navigator.credentials.get({
          publicKey: options,
        });
        await verifyCredential(credential); // Server-side verification
      } catch (err) {
        if (err.name === 'NotAllowedError') {
          // User cancelled → guide to alternative methods (do NOT display error)
          showAlternativeLoginOptions();
        } else {
          showFriendlyError('Authentication failed. Please try another method.');
        }
      }
    }
    ```

-   **Passkey Registration UX Design**:
    -   On the registration confirmation screen, explicitly display "This passkey will be saved to this device" to clearly communicate the storage location and provide user reassurance.
    -   For multi-device environments, provide a UI in account settings for viewing, deleting, and managing registered passkeys by device.
    -   **Device Loss Scenario**: Proactively provide an account recovery flow (backup codes, fallback to email/SMS authentication) in case of device loss, ensuring users are never locked out.

### 34.2. Biometric Authentication UX

-   **Platform API Utilization**: Maximize the use of platform-native APIs for Face ID/Touch ID (iOS) and fingerprint/facial recognition (Android), avoiding custom implementations. Native APIs guarantee appropriate privacy handling and OS-level security.
-   **Clear Authentication State Display**:
    -   In progress (scanning): Clear indicator with animation
    -   Success: Immediate success feedback (haptics + screen transition)
    -   Failure: Clear display of remaining attempts + guidance to alternative methods
-   **Privacy Declaration**: Provide explicit UI text stating "Biometric data is stored on your device and is never sent to servers" to dispel user concerns.
-   **Conditional UI**: Use HTML `autocomplete="username webauthn"` to implement **Conditional UI** that automatically displays passkey candidates in the autocomplete when the form is focused.

    ```html
    <!-- Conditional UI Implementation Example -->
    <input
      type="email"
      autocomplete="username webauthn"
      placeholder="Email address"
    />
    ```

### 34.3. Multi-Factor Authentication (MFA) UX

-   **Two-Factor Authentication UI Standards**:
    -   TOTP (authenticator app) input: Set `inputmode="numeric"` + `autocomplete="one-time-code"` on the 6-digit input field to support iOS SMS autocomplete and Autofill.
    -   SMS OTP: After OTP is sent, display a "Sent icon + countdown timer for remaining validity" to reduce user anxiety.
    -   **Auto-Focus on Authentication Code**: Automatically focus the OTP input field to minimize physical keyboard and IME interference.
-   **Remember This Device UX**: Activate the "Trust this device for 30 days" option ONLY when the user explicitly checks it (Pre-checked prohibited: compliance with §7 Dark Pattern Ban).
-   **Cross-Reference**: §6 (Authentication Accessibility), `security/000_security_privacy.md`

---

## 35. Content Safety & Trust Design

> [!WARNING]
> The EU DSA (Digital Services Act) and UK Online Safety Act mandate platforms to provide UI for responding to illegal content. Content trust design is a compliance requirement.

### 35.1. Content Reporting & Flag UI (EU DSA Art.16 Compliant)

-   **Illegal Content Report UI (Mandatory)**: For platforms subject to EU DSA Art.16 (Very Large Online Platforms), it is a legal obligation to provide a **"Report (Flag)" button** on all user-generated content.
    -   **Report Flow Design**:
        1.  Category selection for reason (Spam / Harassment / Misinformation / Illegal content / Copyright infringement, etc.)
        2.  Optional supplementary text field
        3.  Submission confirmation + "Your report has been received. Check status here" link
    -   **Response UX**: After reporting, issue a "report ID" and provide a **transparency dashboard** where users can track the response status (recommended).
-   **Content Moderation Result UX**:
    -   When content is removed or hidden, notify the poster of the "reason for removal" and "means to appeal" (EU DSA Art.17 compliant).
    -   The appeal flow MUST be designed with equal ease as the reporting flow (§7 Symmetry Principle compliant).

### 35.2. Trust Signal Design

-   **Content Trust Hierarchy**:
    | Content Type | Trust Signal Design |
    |--------------|--------------------|
    | Official / Verified Account | Verification badge (✓) + hover tooltip explaining verification reason |
    | AI-Generated Content | Dedicated badge (§23 compliant) + glow effect |
    | User-Generated Content | Report button always visible + community guidelines compliance display |
    | Confidential / Sensitive Content | Content warning (confirmation required to view) design |
    | Disputed / Misinformation Content | "Reviewed" label + link to fact-checking organization |

-   **Author Trust Display**: Recommend providing **context cards** displaying contextual information such as account creation date and post history summary on user profiles (togglable via privacy settings).
-   **Pre-Share Fact-Check Nudge**: When sharing external links, design **Friction Nudges** such as "This article was published more than 2 weeks ago. Have you checked for the latest information?" to suppress misinformation spread.

### 35.3. Sensitive Content UX (Safe Messaging Design)

-   **Content Warning Patterns**:
    -   For graphic violence, self-harm, or sexual content, place a **blur overlay + warning text + "Show content" button** until the content is expanded.
    -   Use `aria-hidden="true"` to hide post-warning content from screen readers, and design to reveal it after a confirmation action.
-   **Mental Health-Related Content**: For searches or posts containing keywords related to self-harm or suicide, automatically display crisis resources based on **Safe Messaging Guidelines (WHO-compliant)** (§27.2 compliant).
-   **Age Verification UX (Age Gate)**:
    -   For age-restricted content, recommend a direct date-of-birth input method (`YYYY/MM/DD`). Click-through type ("I am 18+" button only) is considered invalid from a regulatory standpoint.
    -   After passing the Age Gate, do not re-display it during the same session (avoid UX penalty), but do not cache it.

### 35.4. Content Integrity & Provenance

-   **C2PA (Content Credentials) Support**: Plan for future adoption of **Content Credentials UI** that embeds creator and tool information as metadata for images and videos, adhering to the C2PA (Coalition for Content Provenance and Authenticity) standard promoted by Adobe, Microsoft, and others.
-   **Watermarking UX**: For AI-generated images and videos, recommend applying steganographic invisible watermarks (e.g., Google SynthID). Double-protect with an "AI-generated" badge visible to users (§23 compliant) and invisible watermarks for machine detection.
-   **Cross-Reference**: §23 (AI-Generated UI Governance), §27 (Digital Wellbeing), `security/100_data_governance.md`

---

## 36. Real-Time Collaboration UX

> [!NOTE]
> Figma / Linear / Notion / Google Docs-style real-time collaborative editing is the "default experience" for SaaS products from 2026 onwards. While CRDT technology maturity has lowered implementation barriers, UX design complexity has increased.

### 36.1. Presence Design (Presence Indicators)

-   **Awareness UI**: In real-time collaboration environments, **Presence UI** that allows users to always know "who is here now" is essential.
    -   **User Cursors**: Display the cursor position of other users in real time. Attach an avatar + name to each cursor. Automatically assign a color per user (Design Token: `--c-user-{index}-color`); recommend limiting to a maximum of 8 simultaneous displays.
    -   **Focus Area Display**: Provide Focus Indicators such as "Person A is viewing Section 3" to prevent overlapping work.
    -   **Active User List**: Always display a list of avatars of users currently in the session. Users who go offline should be distinguished by graying out.
-   **Presence Privacy Settings**: Provide an option to "hide current work status from other users (ghost mode)". Default is ON (shared), but allow changes from privacy settings.

### 36.2. Conflict Resolution UX

-   **CRDT (Conflict-free Replicated Data Type)-Based UI Design**: When CRDTs are adopted, most conflicts are automatically merged, but semantic conflicts (e.g., simultaneous edits to the same field) can still occur.
    -   **Auto-Merge Transparency**: When an automatic merge occurs, display a subtle toast notification: "Changes have been merged". Recommend providing a link to a **change history UI** where users can review how the merge was performed.
    -   **Conflict Detection UI**:
        ```
        ┌─────────────────────────────────────────┐
        │ ⚠️  Conflict detected                       │
        │                                         │
        │ Your change          Person A's change   │
        │ [Priority: High]     [Priority: Medium]  │
        │                                         │
        │ [Use my version]     [Use their version] │
        │ [Manual merge...]                        │
        └─────────────────────────────────────────┘
        ```
    -   Always provide users with **3 choices (my version / their version / manual merge)** to guarantee zero data loss.
-   **Optimistic Updates and Rollback**: Reflect user actions to the local state immediately (Optimistic UI), and automatically restore operations from the **Undo queue** when server sync fails.

### 36.3. Version History UX

-   **Undo/Redo Scope Design**: In multi-user environments, "undo only my own operations" aligns with user intuition. Global Undo that involves other users' operations is prohibited.
-   **Version Snapshot UI**:
    -   **Auto-Snapshot**: Automatically create a snapshot before significant changes (mass deletion, structural changes, etc.).
    -   **Named Versions**: Provide the ability for users to manually assign version names, enabling natural restore operations such as "go back to how it looked yesterday evening".
    -   **Diff View**: Provide a UI for visually comparing changes between versions in Diff format (added: green / deleted: red).
-   **Contribution Visualization**: Provide a **Blame feature** (similar concept to Git blame) that displays "who changed what and when" for each content element, improving team accountability.

### 36.4. Comment & Feedback System UX

-   **Contextual Comments**: **Inline comments** tied to "specific elements or text ranges" rather than the "entire page" are recommended (Google Docs-style).
-   **Thread UX**:
    -   Allow comments to be nested in reply threads, with a maximum depth of 3 levels (unlimited nesting causes cognitive overload).
    -   Provide a **Resolve feature** for threads, and keep resolved comments retained in a default-collapsed state (available for reference as history).
-   **Notification Design**: Deliver notifications for replies and @mentions in **real-time push**, while also providing a "digest notification" option (e.g., hourly) (preventing notification fatigue: §27.1 compliant).
-   **Cross-Reference**: §14 (Interaction Safety Protocols), §19 (UX Research)

---

## 37. Platform Engineering & Design System Ops

> [!NOTE]
> Evolving design system operations from "manual work" to "automated pipelines" is a prerequisite for Design Ops Maturity Level 5 from 2026 onwards.

### 37.1. Figma REST API & Design Automation

-   **Figma REST API Usage Scenarios**:
    -   **Token Extraction**: Build a Bot that regularly retrieves Figma Variables via the Figma REST API and automatically commits them as `tokens.json` in W3C DTCG format (eliminating manual exports).
    -   **Design Quality Reports**: Build automated check reports that generate usage statistics for components, Variable application status, and detection of undefined styles.
    -   **Design-Implementation Divergence Detection**: Design a workflow that automatically compares Figma component specifications with Storybook component Props definitions and periodically reports divergence to Slack/GitHub.

    ```typescript
    // Figma REST API: Example of retrieving Variables
    const response = await fetch(
      `https://api.figma.com/v1/files/${FILE_ID}/variables/local`,
      { headers: { 'X-Figma-Token': FIGMA_TOKEN } }
    );
    const { variables, variableCollections } = await response.json();
    // Convert to W3C DTCG format → write to tokens.json
    ```

-   **Design Sprint Automation**:
    -   Recommend building a GitHub Actions / Make (formerly Integromat) workflow that detects Figma frame status changes (Draft/Ready/Shipped) via Webhook and **automatically updates Jira/Linear ticket status**.

### 37.2. Internal Developer Portal (IDP) & Design System Integration

-   **Background**: With the spread of Platform Engineering (Internal Developer Platforms: IDPs), integrating IDPs like Backstage with the design system makes it possible to build an **Integrated Developer Portal** where "component catalog → Storybook → Figma Spec" can be explored from a single source.
-   **Catalog Integration Design**:
    -   Integrate a design system plugin into Backstage (or equivalent IDP) and build a catalog where **component name → Storybook URL → Figma Frame URL → npm package version** can be referenced in one place.
    -   Display **README and usage statistics** (number of uses and version distribution across projects) in the catalog, and automate the decision to deprecate unused components.
-   **Golden Path Definition**: Use the IDP to define an "approved step-by-step flow (Golden Path)" for adding new components, updating existing components, and deprecations, ensuring governance consistency.

### 37.3. Advanced Continuous Integration for Design Systems

-   **Progressive Design CI**:
    ```yaml
    # GitHub Actions: Advanced Design System CI example
    name: Design System CI
    on: [push, pull_request]
    jobs:
      token-validation:
        runs-on: ubuntu-latest
        steps:
          - uses: actions/checkout@v4
          - name: Validate W3C DTCG Token Schema
            run: npx @tokens-studio/sd-transforms validate tokens.json
          - name: Check Token Drift vs Figma
            run: node scripts/token-drift-check.js
            env:
              FIGMA_TOKEN: ${{ secrets.FIGMA_TOKEN }}
      component-quality:
        runs-on: ubuntu-latest
        steps:
          - name: Storybook Build
            run: npm run build-storybook
          - name: A11y Test (axe-core)
            run: npx storybook test --coverage
          - name: Visual Regression (Chromatic)
            uses: chromaui/action@v11
            with:
              projectToken: ${{ secrets.CHROMATIC_TOKEN }}
    ```

-   **Migration from Snapshot Tests to Visual Tests**: DOM snapshots from `jest-snapshot` have high maintenance costs and do not detect actual visual changes. Recommend fully migrating to visual regression testing with Chromatic/Percy.

### 37.4. Design System Monitoring & Observability

-   **Design System Observability**:
    -   **Adoption Analytics**: Build a **usage dashboard** that tracks how many times and in which versions each component in the component library is being used across real projects.
    -   **Breaking Change Impact Assessment**: Before a MAJOR version release, pre-calculate the number of affected projects using `semver-diff` tools or dependency graph analysis, and visualize release risk.
    -   **Error Rate Tracking**: Classify errors from error tracking tools like Sentry by component, and integrate "this component is causing ◯ errors in production" into the health score (§21.4 compliant).

-   **SLO (Service Level Objective) Definitions**:
    | SLO Metric | Target |
    |------------|---------|
    | Storybook Build Time | ≤ 5 minutes |
    | Visual Regression Review Time | ≤ 24 hours |
    | Critical A11y Bug Fix Time | ≤ 24 hours |
    | Token Drift Detection to Fix | ≤ 1 week |
    | MAJOR Breaking Change Deprecation Notice Lead Time | ≥ 3 months |

-   **Cross-Reference**: §21 (Design System Governance), §24 (Cross-Platform Token Federation), §33 (Design QA & Visual Regression), `engineering/000_engineering_standards.md`

---

## Appendix A: Quick Reference Index

| Keyword | Sections | Related Rules |
|---------|----------|---------------|
| Material Design / Expressive / HIG | §1 | `engineering/300_web_frontend`, `engineering/400_mobile_flutter` |
| Design Tokens / W3C DTCG / CSS | §2 | `engineering/300_web_frontend`, `engineering/000_engineering_standards` |
| Typography / CJK / Font | §1.1, §3.3 | `product/800_internationalization` |
| Color / Dark Mode / P3 / Oklch | §2.1 | `engineering/300_web_frontend` |
| Responsive / Foldable / Any-Screen | §5 | `engineering/400_mobile_flutter`, `engineering/410_native_platforms` |
| Component / Headless UI / Skeleton | §3 | `engineering/300_web_frontend` |
| Feedback / Toast / Z-Index | §3.1, §14.3 | `engineering/300_web_frontend` |
| Animation / Motion Token / 60fps | §4, §16 | `engineering/300_web_frontend`, `engineering/400_mobile_flutter` |
| Haptics / Sound | §3.5 | `engineering/400_mobile_flutter`, `engineering/410_native_platforms` |
| Accessibility / WCAG 2.2 / EAA | §6 | `engineering/300_web_frontend`, `engineering/400_mobile_flutter`, `security/100_data_governance` |
| Form / IME / Input | §14.1, §14.2, §15.3 | `engineering/300_web_frontend` |
| Navigation / Breadcrumb / Tab | §3.3, §10 | `engineering/300_web_frontend` |
| Error / Recovery / Error Catalog | §12, §15.2, §15.5 | `engineering/300_web_frontend`, `operations/300_customer_experience` |
| Safety UI / Destructive Actions / DnD | §11, §14.4 | `security/000_security_privacy` |
| Onboarding / Empty State | §10 | `product/500_growth_marketing`, `operations/300_customer_experience` |
| Microcopy / Writing / Tooltip | §10 | `product/600_brand_strategy` |
| AI UX / Agentic / GenUI / Copilot | §9 | `ai/000_ai_engineering` |
| MCP / Tool Call Transparency / Permission UI | §9 | `ai/000_ai_engineering`, `security/000_security_privacy` |
| Multimodal AI UX / Modality State Display | §9 | `ai/000_ai_engineering` |
| User Sovereignty / Dark Patterns / Ethical UX | §7 | `security/100_data_governance`, `product/000_product_strategy` |
| Hospitality / Anticipatory / Locale Format | §12 | `product/800_internationalization` |
| i18n / Localization | §15 | `product/800_internationalization`, `core/200_language_protocol` |
| Performance UX / CWV / Perceived | §17 | `engineering/000_engineering_standards`, `operations/400_site_reliability` |
| Spatial Computing / XR / visionOS | §18 | `engineering/410_native_platforms` |
| UX Research / Measurement / NPS | §19 | `ai/100_data_analytics`, `product/100_market_validation` |
| AI-Augmented UX Research / Synthetic Testing / Behavioral Analytics Ethics | §19.4 | `ai/100_data_analytics`, `ai/000_ai_engineering` |
| Maturity Model / Anti-Patterns | §20 | All rules (universal) |
| Design System Governance / DSaaP / SemVer | §21 | `engineering/000_engineering_standards` |
| Data Visualization / Chart A11y / IA | §22 | `ai/100_data_analytics`, `engineering/300_web_frontend` |
| AI-Generated UI / Vibe Coding / EU AI Act Disclosure | §23 | `ai/000_ai_engineering`, `security/000_security_privacy` |
| Cross-Platform / Token Pipeline / Token Drift | §24 | `engineering/400_mobile_flutter`, `engineering/410_native_platforms` |
| Sustainability / Green UX / Carbon-Aware | §25 | `operations/400_site_reliability` |
| Neurodiversity / ADHD / Cognitive Accessibility | §26 | `security/100_data_governance`, `product/000_product_strategy` |
| Digital Wellbeing / Ethical Design / Screen Time | §27 | `security/100_data_governance`, `product/000_product_strategy` |
| Voice UX / VUI / Voice Accessibility / STT/TTS | §28 | `ai/000_ai_engineering`, `engineering/410_native_platforms` |
| Personalization / Filter Bubble / Context Adaptation | §29 | `ai/100_data_analytics`, `security/100_data_governance`, `product/000_product_strategy` |
| Design Tokens 2.0 / Modes / Scoping / Multi-Brand | §30 | `engineering/300_web_frontend`, `engineering/000_engineering_standards` |
| Offline-First / Service Worker / Background Sync / IndexedDB | §31 | `engineering/300_web_frontend`, `operations/400_site_reliability` |
| Gamification / Game Mechanics / Points / Badges / Ethics | §32 | `product/000_product_strategy`, `security/100_data_governance` |
| Visual Regression / Design QA / Storybook / Chromatic / CI | §33 | `engineering/000_engineering_standards`, `engineering/300_web_frontend` |
| Passkey / FIDO2 / WebAuthn / Biometric Auth / Conditional UI | §34 | `security/000_security_privacy` |
| Content Safety / DSA Art.16 / Trust Signal / Age Gate / C2PA | §35 | `security/100_data_governance`, `product/000_product_strategy` |
| Real-Time Collaboration / CRDT / Conflict Resolution / Presence | §36 | `engineering/000_engineering_standards`, `engineering/300_web_frontend` |
| Platform Engineering / IDP / Figma API / Design System CI / SLO | §37 | `engineering/000_engineering_standards` |

---

> **Cross-Reference (Tech Stack-Specific Rule References)**
> This file (§1–§37) defines technology stack-agnostic Universal design and UX principles. For framework-specific implementation details, refer to:
> - **Web (React/Next.js, etc.)**: `engineering/300_web_frontend.md` — Hooks ordering, Hydration Mismatch, suppressHydrationWarning, Server Component boundaries, Hard Session Refresh
> - **Mobile (Flutter)**: `engineering/400_mobile_flutter.md` — Widget lifecycle and platform-specific UI
> - **Native (Kotlin/Swift)**: `engineering/410_native_platforms.md` — HIG/Material-specific implementation, Haptics API
> - **AI/ML**: `ai/000_ai_engineering.md` — GenAI quality assurance, EU AI Act detailed compliance, Voice AI integration
> - **Data Analytics**: `ai/100_data_analytics.md` — Measurement, A/B testing methodologies, Personalization model governance
> - **Internationalization**: `product/800_internationalization.md` — i18n library selection, translation workflows
> - **Site Reliability**: `operations/400_site_reliability.md` — Service Worker monitoring, offline metrics
> - **Product Strategy**: `product/000_product_strategy.md` — Gamification ethics, dependency design risk
> - **Engineering Standards**: `engineering/000_engineering_standards.md` — Visual regression automation, CI quality gates
