# 20. Design & UX Strategy

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-03-24

> [!IMPORTANT]
> **Supreme Directive**
> "Design is not decoration — it is the user's first and last impression of quality."
> All design decisions must prioritize consistency, accessibility, and delight.
> Strictly follow the priority order: **Consistency > Accessibility > Delight > Aesthetics > Development Speed**.
> This document is the supreme standard for all design and UX strategy decisions.
> **15 Parts, 62 Sections.**

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
| VII | User Sovereignty | §7 |
| VIII | Tools & Workflow | §8 |
| IX | AI UX Strategy | §9 |
| X | User Onboarding & Guidance | §10 |
| XI | Safety UI Protocols | §11 |
| XII | Hospitality UX | §12 |
| XIII | Design Ops & Tools | §13 |
| XIV | Interaction Safety Protocols | §14 |
| XV | Localization & Internationalization | §15 |

---

> [!WARNING]
> **Rule 20.0: The Consistency Mandate (Professionalism Protocol)**
>
> - **Law**: Inconsistency in UI/UX is a "Lack of Professionalism".
> - **Action**: Do not tolerate minor deviations such as "The button is on the left only on this screen" or "The delete flow is different only here". Elements that disrupt the overall Harmony are bugs, even if they function.
> - **Target**: Maintain "Iron Consistency" especially in critical flows like "Delete", "Save", and "Authentication" to protect the user's mental model.



## 1. Design Philosophy ("Silicon Valley Excellence & Google First")

### 1.1. The "Wow" Factor (Delight)
*   **Mandate**: All interactions must feel "alive". We build **dynamic experiences**, not static screens.
*   **Google Standard**: Adoption of **Material Design 3 (Material You)** and its evolution **"Expressive"**.
*   **Apple Standard**: Respect **Human Interface Guidelines (HIG)** on iOS. Maintain platform fidelity (e.g., switches, pickers).
*   **Differentiation**: While using Google's system, differentiate with **high-precision motion**, **custom shaders**, and **bold typography** to create "Silicon Valley Premium".
*   **The Typography Localization Protocol (Readability First)**:
    *   **Font Fallback Stack**: When using Web Fonts (e.g., Noto Sans JP, Inter), always specify OS standard fonts (e.g., Hiragino Kaku Gothic, Meiryo, system sans-serif) as fallback.
    *   **Line Height for CJK**: For languages with high character density (Japanese, Chinese), set `line-height` wider (`1.6 - 1.8`) to ensure readability.
    *   **Letter Spacing**: Recommend applying `letter-spacing: wider` to bold headings to eliminate character crowding.

### 1.2. Trend Scouting Protocol
For *every* design task, the following "Scouting Loop" is mandatory:
1.  **Analyze Leaders**: Check Mobbin, Awwwards, Google Design.
2.  **Deconstruct**: Why does it feel good? Deconstruct the "Soul".
3.  **Apply**: Adapt that soul to our context. **Steal the soul, don't blindly copy.**
4.  **AI Leverage**: Brainstorm "futuristic" variations using GenAI.

### 1.3. The Realism Mandate (Anti-Haribote / Truth in Design)
*   **Law**: Drawing data that does not exist in DB schema (future columns, fictitious statuses) in design comps is prohibited.
*   **Action**: Designers MUST agree on **DB Schema (ER Diagram)** with backend engineers before drawing in Figma. Ambiguous data like "probably store in JSON somehow" ALWAYS breaks during UI implementation.
*   **Motto**: "No Schema, No Pixel."

## 2. Design Engineering

### 2.1. Design Tokens
*   **Single Source of Truth**: Define all values (color, spacing, typo) in Figma Variables and sync 100% with Code (Tailwind/CSS Variables).
*   **No Hardcoding**: Writing `px` or `#hex` directly is **strictly prohibited**. Use tokens.
*   **Dynamic Theme**: Theme settings (`site_settings`) must be fetched from DB at Runtime (`RootLayout`) and injected as CSS variables.
*   **The Locale Format Mandate (Date/Currency/Number)**:
    *   **Law**: Date, currency, and number formats are **locale-dependent**. Hardcoding specific formats (e.g., `MM/DD/YYYY`) is prohibited.
    *   **Action**:
        1. **Date Library**: When using `date-fns` or `Intl.DateTimeFormat`, always explicitly specify target locale.
        2. **Currency**: Display currency symbols and digit separators using `Intl.NumberFormat` in correct format for locale.
        3. **Consistency**: Maintain unified locale settings across the application and prevent mixing.
        4. **Form Field Order Locale Compliance**: Form fields for personal information (name, address, etc.) MUST follow locale-specific ordering conventions. Name ordering (e.g., "Last → First" in Japan vs "First → Last" in Western countries) and address ordering (e.g., "Prefecture → Street" in Japan vs "Street → State" in Western countries) differ by locale. Forcing an order contrary to the locale is prohibited.
*   **Dark Mode Readiness**:
    *   **CSS Variable Separation**: Define all UI colors as CSS variables (`hsl(var(--...))` tokens) and maintain a design where light/dark mode switching is completed solely by overriding CSS variables.
    *   **Semantic Token Mandate**: Prohibit usage of hardcoded color values (`#ffffff`, `bg-white`, etc.) and use semantic tokens (`bg-background`, `text-foreground`) instead.
    *   **Loading State Unification**: Unify loading displays during data fetching as follows: Page level uses `loading.tsx` with Suspense Boundary + Skeleton, Component level uses `<Skeleton />` component, Action level uses button `disabled` + spinner icon. A blank white screen without any loading indicator is treated as a critical UX deficiency.

## 3. Component Implementation Guidelines

### 3.1. Implementation Patterns
*   **Skeleton Loader**:
    *   Use **Skeleton Screen** (`<Skeleton />`) instead of spinners during loading (Suspense) to prevent Layout Shift (CLS).
*   **Feedback Hierarchy**:
    *   **Toast**: Success/Notification (Async).
    *   **Inline Alert**: Context-dependent errors.
*   **Toast Promise Standard (Async Feedback Lifecycle)**:
    *   **Law**: Manually managing Loading→Success→Error feedback cycles for async operations (save, delete, submit, etc.) is a breeding ground for bugs.
    *   **Action**: Use the Toast library's `promise` feature (e.g., `sonner.promise()`) to automatically display processing, success, and failure states. Users must visually perceive "processing" status and reliably receive completion or failure results.
    *   **Z-Index Stratification (The Layering Law)**:
        *   **Overlay (10000)**: Select, Popover, Tooltip, Calendar. Topmost.
        *   **Modal (9999)**: Dialog, Sheet.
        *   **Menu (1000)**: Navigation Drawer.
        *   **Action**: Prohibit magic numbers like `z-50`. Strict adherence required.
*   **Optimistic UI**:
    *   For lightweight actions like "Like", update display immediately without waiting for server response to achieve Native-like speed.
*   **The Sortable Table Standard**:
    *   **Law**: "Cannot sort" in admin tables (Users, Logs) makes it an Incomplete business tool.
    *   **Action**: MUST implement server-side sort (`sortBy`, `sortOrder`) via `SortableTableHead`.
*   **The Carousel Standardization Protocol**:
    *   **Law**: Self-implementing carousels (sliders) tends to introduce bugs in touch interactions and accessibility (A11y). Usage of a validated library is mandatory.
    *   **Synced Sliders**: When implementing thumbnail-synced sliders (Main + Thumbs), use the library's native synchronization feature instead of custom State synchronization.
    *   **A11y**: Always enable `navigation` (arrows) and `pagination` (dots) and ensure keyboard accessibility.
*   **The Native Input Prohibition**:
    *   **Law**: Usage of browser-native input forms (`<input type="date">`, `<input type="time">`, `<input type="color">`, etc.) in designed UIs is prohibited. Their appearance and behavior differ across browsers, destroying design consistency.
    *   **Action**: Use `Popover + Calendar` components for date selection, custom `Select` for time selection, and custom color pickers for color selection.
    *   **Modal Scale**: Ensure sufficient width for modals handling complex settings (e.g., `max-w-4xl` or above, or `80vw`) to eliminate cramped layouts.
*   **The Editor Preview Protocol**:
    *   **Law**: In rich content editors (block editors, etc.), displaying only URL text or icons for embedded media (videos, maps, etc.) is prohibited.
    *   **Action**: Use editor extension features (NodeView, etc.) to display actual previews (iframes, etc.) within the editor. Achieve "True WYSIWYG" where the published layout can be accurately understood during editing.
*   **The Headless UI Architecture (UI-Logic Separation Mandate)**:
    *   **Law**: UI components MUST focus exclusively on "data display" and "event emission", and MUST NOT contain business logic (data fetching, state computation, validation, etc.) internally.
    *   **Anti-Pattern**: Directly performing `fetch` inside components or managing state dependent on specific page DOM structures is a design violation that destroys reusability and portability.
    *   **Goal**: UI components must maintain a state where, when porting to another platform (React Native, etc.) in the future, only the "display layer" needs to be swapped without modifying logic.
*   **The Modal Standard Architecture (Portal & Close UX)**:
    *   **Law**: All modals MUST be rendered at the DOM root using the `Portal` pattern. This prevents clipping caused by parent element's `overflow: hidden` or `z-index` constraints.
    *   **Close Button**: Modal close buttons MUST be placed in the top-right corner with a unified visual design (e.g., circular background) consistent across the entire project. A modal with an unclear close mechanism is a UX deficiency.
*   **The Mobile Media Upload Protocol**:
    *   **Law**: Standard capture formats of mobile devices (e.g., iOS HEIC/HEIF) often cannot be directly displayed in browsers. Components with file upload functionality should account for these formats.
    *   **Action**: To reduce server load, client-side automatic conversion to universal formats (JPEG/PNG/WebP) before upload is recommended. Requiring users to manually convert is a mobile UX failure.

### 3.2. The React/Hydration Hardening Protocol (Lesson 42.18)
*   **The Hooks Order Guarantee**:
    *   **Law**: React Hooks (`useEffect`, `useState`) MUST be declared BEFORE any conditional return (`if`, `return`).
    *   **Violation**: "Rendered more hooks" is a rudimentary error caused by Early Return.
    *   **Action**: Force fixed placement of **Hooks Definition Block** at the top of every component.
*   **The Anchor Nesting Prohibition (Hydration Mismatch)**:
    *   **Law**: Placing `<a>` or `<button>` inside `<a>` is an HTML violation and main cause of Hydration Mismatch.
    *   **Action**: Do not nest. Use `onClick` on parent or Overlay CSS (`absolute inset-0`).
*   **The suppressHydrationWarning Standard**:
    *   **Law**: Not a magic wand.
    *   **Allowed**: Only for text nodes inevitably differing between server/client (Date, Random).
    *   **Banned**: Hiding HTML structure mismatches (nesting errors) is strictly prohibited.
*   **The Hidden Element & Ghost Dimension Protocol**:
    *   **Law 1**: `display: none` (`hidden`) still consumes Render Cost. Use conditional rendering (`{ isOpen && ... }`) for heavy trees like Drawers.
    *   **Law 2**: Hidden elements have 0 dimensions. Trigger `resize` event or force remount when showing `ResizeObserver`-dependent components to prevent "Ghost Dimension".

### 3.3. Layout Architecture
*   **The Single Container Protocol**:
    *   If Layout provides a container, re-defining padding/container in Page is strictly prohibited (Double Padding).
*   **Baseline Harmony (Filter Alignment Protocol)**:
    *   **Law**: When aligning `Input` and `Button` with labels, using `items-center` is prohibited.
    *   **Action**: MUST use **`items-end`** to align baseline considering label height. `items-center` blurs boundaries and looks amateur.
*   **The Natural Scrolling Protocol**:
    *   **Law**: Unplanned nesting of `h-screen` + `overflow-y-auto` causing double scrollbars is UX defeat.
    *   **Action**: Ideally only **one** scroll container (body) on screen. If partial scroll needed, consider `dvh`.
*   **The Any-Screen Typography Protocol**:
    *   **Law**: Fixed `text-3xl` destroys mobile UI.
    *   **Action**: Start from mobile base (`text-xl`) and scale via breakpoints (`sm:`, `lg:`). Maintain visual hierarchy.
*   **The Fragmented UI Protocol**:
    *   **Law**: "Similar but different" is worst. Standardize components including their layout context.
    *   **Action**: Prohibit ad-hoc CSS. Follow single "Gold Standard".

    *   **The Action Placement Standard**:
        *   **Law**: Inconsistent placement of primary action buttons ("Add", "Save", etc.) across pages increases user eye movement cost.
        *   **Action**: Primary actions for a section (e.g., "Add", "Save") MUST be placed at the **right end of the section header** (`flex justify-between items-center`). They must never be buried in the middle of content or at the very bottom.

    *   **The Breadcrumb Priority Protocol**:
        *   **Law**: Breadcrumbs are the "lifeline for knowing current location" and MUST be placed at the **very top of the page** without exception.
        *   **Mobile**: On mobile screens, breadcrumbs and action buttons MUST be separated into a **vertical stack**, with breadcrumbs on top. Placing them side-by-side where breadcrumbs are hidden or forced to horizontal scroll is prohibited.
        *   **Visibility**: Handle breadcrumb text overflow with `overflow-x-auto` while ensuring visibility within the first view as much as possible.

    *   **The Sub-Page Header Consistency**:
        *   **Law**: List pages and create/detail pages MUST share the same header structure (icon + title + description) to maintain visual consistency.
        *   **Action**: Even for new registration or edit pages, place the same branding header and navigation as the parent page. A bare-bones form-only page gives users the impression of "arriving at a different site".

### 3.4. Motion & Gestures (The "Soul")
*   **Physics-Based**: All animation uses spring physics. Elements should bounce, stretch, and squash.
*   **Swipe First**: Implement universal swipe-back and swipe-to-action. No lag allowed.

### 3.5. Multi-Sensory Design
*   **Haptics**: Assign delicate "Tap", "Click" haptics to success/error/select events.
*   **Sonic Branding**: Use sound logos for branding and micro-sounds for UI interactions.

## 4. Performance Animation
*   **60fps Target**: Maintain 60fps (120fps preferred).
*   **GPU Optimization**: Animate only `transform` and `opacity`. No layout thrashing properties (`width`, `height`, etc).

## 5. Adaptability & Foldables

### 4.1. Universal Responsiveness
*   **Rule**: "Mobile First" is obsolete. We design for **"Any-Screen"**.
*   **Foldables**: Be Hinge-Aware and maintain continuity across states.
*   **Large Screens**: Use Canonical Layouts. Do not just stretch mobile UI.
*   **The Adaptive Typography Protocol (Screen-Aware Sizing)**:
    *   **Law**: Fixed `text-3xl` etc. works poorly—too small on large screens, overwhelming on small.
    *   **Action**: 
        1. **Adaptive Base**: Text sizes MUST start from mobile baseline (`text-xl`) and scale via breakpoints (`sm:`, `lg:`).
        2. **Visual Hierarchy**: Maintain proper heading/body contrast ratio so information hierarchy persists across screen sizes.
*   **The Fragmented UI Protocol (Consistency Mandate)**:
    *   **Law**: "Similar but different" is the worst. UI components (breadcrumbs, headings, buttons, etc.) MUST be standardized **including their placement context (Wrapper/Layout)**.
    *   **Action**: Prohibit per-page ad-hoc CSS adjustments ("change background color just here", "add margin"). Define one "Gold Standard" site-wide and conform all pages to it.
*   **The CSS Containment Protocol (Whitespace Glitch Prevention)**:
    *   **Context**: Accordion expansion etc. can cause scroll calculation bugs creating massive whitespace.
    *   **Action**: Containers with `overflow-y-auto` MUST apply `style={{ contain: 'layout' }}` to prevent child layout changes from affecting outside.
*   **The Universal Beauty Protocol (Responsive Verification Mandate)**:
    *   **Law**: "Works on PC so OK" is an excuse hiding responsive design flaws; unverified changes are "incomplete".
    *   **Action**: For ALL feature additions/UI implementations, verify and guarantee "beauty" and "functionality" across these 3 environments as **top priority**:
        1. **SP (Mobile)**: Portrait (Width < 640px)
        2. **Tablet**: Portrait/Landscape (Width 768px ～ 1280px) ※Watch for iPad portrait breakage.
        3. **PC (Desktop)**: Full size (Width > 1280px)
    *   **Checklist**:
        *   No element overlap?
        *   Text not too small/too large and overflowing?
        *   Both touch (Touch) and mouse (Hover) interactions comfortable?

## 6. Accessibility & Inclusivity
*   **WCAG 2.1 AA**: Contrast ratio 4.5:1+ (WCAG 1.4.3), supports dynamic type scaling.
    *   **Large Text**: Text at 18px or above (or bold at 14px or above) may use a contrast ratio of **3:1 or above**.
    *   **UI Components**: Borders and icons of interactive elements such as buttons must also maintain a contrast ratio of **3:1 or above** against the background (WCAG 1.4.11).
*   **Touch Targets**: Minimum 44x44dp (iOS) / 48x48dp (Android). Important actions at the bottom.
*   **The Fat Finger Protocol (Label Wrapping)**:
    *   **Law**: Prohibit placing checkboxes/radio buttons standalone.
    *   **Action**: Always wrap with `<label>` tag (or `shadcn/ui` `Label` component) including text to maximize touch target area. "Tapping text doesn't respond" is a bug.
*   **Semantics**: Proper labels for screen readers.
*   **Image Alt Text Protocol**:
    *   **Content Images**: Provide an `alt` attribute that accurately conveys the image content (e.g., `alt="Product exterior photo"`).
    *   **Decorative Images**: Set `alt=""` for purely decorative images so screen readers ignore them.
    *   **Omission Prohibited**: Omitting the `alt` attribute (which results in `undefined`) is strictly prohibited. Always specify either an empty string (`""`) or descriptive text.
*   **Focus Ring Protocol (Accessibility Sight)**:
    *   **Law**: UI where focus state (Tab key navigation, etc.) is not visually recognizable is a "maze in the dark" for keyboard users—accessibility failure.
    *   **Action**: When removing browser default focus ring (`outline-none`), MUST redefine **high-contrast focus ring** (e.g., `ring-2 ring-primary ring-offset-2`). "Invisible Focus" is treated as a bug.
*   **A11y Legal Defense (ADA/EAA Compliance)**:
    *   **Risk**: Insufficient accessibility creates litigation risk under the Americans with Disabilities Act (ADA Title III) and European Accessibility Act (EAA).
    *   **Mandate**: Missing `aria-label` and insufficient contrast ratios are not "bugs" but "legal deficiencies." In addition to automated CI checks, mandate quarterly manual verification with screen readers (VoiceOver/NVDA, etc.).
*   **A11y Zero Tolerance CI (Build Gate)**:
    *   **Mandate**: Integrate `axe-core` or `pa11y-ci` into the CI pipeline. If even one `critical` or `serious` violation is detected, **force the build to fail**.
    *   **Exemption**: Only for unfixable external factors within UI library internals—addition to the exception list (Ignore Config) is permitted after documenting the reason.
*   **Non-Color Indication Protocol**:
    *   **Law**: Error displays and critical information MUST NOT rely on **color alone**. Users with color vision diversity will miss the information.
    *   **Action**: Always **combine** icons (⚠️, ✅, ❌) and text ("Required", "Error", "Success") with color to achieve a **triple-channel communication** standard.
*   **Font Size & Zoom Protocol**:
    *   **Minimum Body Text Size**: The minimum font size for body text is **16px**. Smaller font sizes impair readability and should be limited to supplementary text, captions, etc.
    *   **rem Mandate**: Specify `font-size` in `rem` units to respect user browser settings. `px` fixed values are only permitted at the `:root` level.
    *   **Zoom Resilience**: Design layouts to remain intact at browser zoom (**200%**). Content clipping or overlap at 200% zoom is treated as a bug.
*   **Tab Order Protocol (Keyboard Navigation Order)**:
    *   **Law**: DOM order and tab order must match. Positive `tabindex` values (e.g., `tabindex="5"`) are **prohibited**.
    *   **Allowed**: Only `tabindex="0"` (add to natural tab order) and `tabindex="-1"` (programmatic focus only) are permitted.
    *   **Escape Key**: Modals and dropdowns must be closable with the `Escape` key.
*   **Skip Link Protocol**:
    *   **Mandate**: Implement a **"Skip to main content"** link at the beginning of every page.
    *   **Implementation**: Use the `sr-only` + `:focus` pattern—hidden by default, visible only on focus.
*   **ARIA Attributes Standard**:
    *   **aria-live**: Set `aria-live="polite"` on dynamically changing content (toast notifications, countdowns, etc.) to notify screen readers of changes.
    *   **aria-expanded / aria-controls**: Set `aria-expanded` for open/close state and `aria-controls` for target elements on accordions and dropdowns.
    *   **First Rule of ARIA**: Do NOT use ARIA when semantic HTML is sufficient. Excessive ARIA causes more confusion than it solves.
*   **Label Association Protocol**:
    *   **Mandate**: Associate all input fields with `<label>` using the `htmlFor` attribute.
    *   **Placeholder-Only Prohibition**: Using `placeholder` as a substitute for labels is strictly prohibited. Placeholders disappear on focus, causing users to lose track of input purpose.
*   **Error Notification Protocol (Form Error Notification)**:
    *   **Mandate**: Notify screen readers of form errors immediately using `aria-live="assertive"`.
    *   **Association**: Place error messages directly below the field and associate them using `aria-describedby`.
    *   **Clarity**: Error messages MUST **clearly indicate** which field has the issue.
*   **Required Fields Protocol**:
    *   **ARIA**: Set `aria-required="true"` on required fields.
    *   **Visual**: Visually indicate with a "Required" label or `*` mark + text (do not rely on color alone: Non-Color Indication Protocol compliant).
*   **Lighthouse Score Gate**:
    *   **Mandate**: Lighthouse Accessibility Score of **90 or above** is a **deployment requirement**. Pages scoring below 90 are treated as bugs.
    *   **Manual Testing**: Periodically conduct keyboard-only site operation tests, screen reader (VoiceOver / NVDA) read-aloud verification, and 200% zoom testing.
*   **Color Vision Simulation Test**:
    *   **Mandate**: When creating or modifying UI components that use color for information conveyance (status badges, charts, error displays, etc.), verification under the following color vision simulations is mandatory.
        *   Protanopia (Type 1): Difficulty perceiving red
        *   Deuteranopia (Type 2): Difficulty perceiving green
        *   Tritanopia (Type 3): Difficulty perceiving blue
    *   **Tools**: During development, use Chrome DevTools "Rendering > Emulate vision deficiencies". During design, use Figma's `Able` or `Stark` plugin.
    *   **PR Review Gate**: For PRs containing UI components that convey information through color, reviewers are recommended to document confirmation results using the above tools in PR comments.
*   **Media Accessibility Protocol**:
    *   **Subtitles**: Subtitles in the target locale's language are mandatory for video content.
    *   **Transcript**: Provide text transcripts for audio-only content.
    *   **Auto-Play Ban**: Auto-play of media with audio is prohibited. Playback must only begin with explicit user action (click/tap) (WCAG 1.4.2 compliant).
*   **Semantic HTML Standard**:
    *   **Law**: Avoid "div hell" — excessive use of `div` / `span`. Use appropriate HTML elements.
    *   **Elements**:
        *   `<button>`: Clickable actions (`<div onClick>` is prohibited)
        *   `<a>`: Navigation (page transitions, external links)
        *   `<nav>`, `<main>`, `<header>`, `<footer>`, `<aside>`: Page structure landmarks
        *   `<article>`, `<section>`: Semantic content divisions
    *   **Landmark Completeness**: Place exactly one `<main>` per page, and `<nav>` must always contain navigation menus.
*   **Locale-Aware Screen Reader Testing**:
    *   **Context**: Screen reader pronunciation behavior differs by locale (e.g., locale-specific pronunciation quirks, currency symbol reading, address format ordering, etc.).
    *   **Mandate**: Before releasing new pages or major UI components, conduct read-aloud testing with VoiceOver (iOS/macOS) or NVDA (Windows) configured in the target locale's language settings.
    *   **Checklist**: Verify button announcements (operations communicated in target language), form labels (input purpose read in target language), error messages (immediate notification via `aria-live`), and numeric/currency values (natural pronunciation).

## 7. User Sovereignty (User First)
*   **Data Ownership**: Users control their data (Easy Export/Delete).
*   **No Dark Patterns**: No deception. Design for "Delight Metrics".
*   **Transparency**: Explainable AI (Why this content?).

## 8. Tools & Workflow
*   **Figma**: The Source of Truth. Use Dev Mode.
*   **Rive**: Use for complex vector animations.
*   **Inclusive Copywriting**: Language that excludes no one.

## 9. AI UX Strategy (Latency Management)
*   **Streaming First**: Zero perceived latency. Stream responses immediately.
*   **Optimistic Updates**: React UI immediately to user actions before AI finishes.
*   **Transparency**: Visually distinguish "Thinking" vs "Generating".
*   **The Quota Framing Protocol**:
    *   **Law**: When displaying usage limits (Quota) for AI generation, API calls, etc., wording that makes users feel "stingy restrictions" is prohibited.
    *   **NG**: "You have reached your limit" / "Usage limit exceeded"
    *   **OK**: "You've used all your AI generation power this month. Upgrade your plan to unlock more?"
    *   **Effect**: Justify the existence of limits as "this feature is so special and powerful that limits exist", simultaneously increasing user acceptance and premium perception.

## 10. User Onboarding & Guidance
*   **Coach Marks**: Context-aware tooltips. Always skippable.
*   **The Feature Tab Protocol**:
    *   **Law**: For pages composing related feature groups (e.g., profile management, settings screens, etc.), place shared tab navigation so users can navigate between features without confusion.
    *   **Disabled State**: When prerequisites are not met (e.g., initial registration incomplete), related tabs should NOT be hidden but instead displayed as **disabled (Disabled / reduced Opacity)**, maintaining awareness of the feature's existence (ensuring discoverability).
    *   **Active State**: Highlight the tab corresponding to the current context. When on a sub-resource (new creation screen, etc.) with no directly corresponding tab, either maintain the parent category tab or leave all tabs unselected.
*   **Feature Discovery**: Progressive disclosure. Zero Data is an onboarding opportunity.
*   **General Consumer Perspective**: No technical jargon ("Database", "API"). Use intuitive words ("Save", "Connect").
*   **Micro-Interaction Standards**:
    *   **Cursor Affordance**: Clickable elements (including Cards and custom inputs) must apply `cursor-pointer` on hover to clarify affordance.
    *   **Hover State Fidelity**: Interactive cards must apply subtle background color change or elevation (`shadow-md`) on hover to signal reactivity to user's subconscious.
        *   **Clipboard Interaction Protocol (Copy Feedback)**: On successful "copy" actions for URLs or codes, always display an immediate **toast notification** or **icon change (checkmark, etc.)** to clearly indicate success. In environments where `navigator.clipboard` fails (non-HTTPS, etc.), implement a fallback that selects the text for manual copying.
        *   **Input Reflection Protocol (Real-time Label Sync)**: In collapsible UIs such as accordions, changes to internal input fields (`name`, `title`, etc.) MUST be reflected **in real-time** in parent components (list views, accordion headers). Behavior where "the title doesn't update until saved" is perceived as UX lag in admin interfaces.
*   **The Microcopy Quality Protocol (Kindness First)**:
    *   **Law (No Blame)**: Error messages must "help" users, not "blame" them.
        *   **NG**: "Invalid Input"
        *   **OK**: "Please enter in email format" / "Only alphanumeric characters allowed"
    *   **Law (Safety Warning)**: For dangerous operations like delete confirmation, add **words emphasizing irreversibility** ("This action cannot be undone") with red UI.
        *   **Law (Error 2-Sentence Rule)**: Error messages MUST follow a **2-sentence structure**: "**What happened**" + "**What to do next**". An error message that only reports the cause without suggesting a solution is incomplete.
        *   **Law (Positive Framing)**: Prefer **affirmative framing** over negation. Tell users "how to achieve" instead of "cannot do".
        *   **Law (Action-Oriented Button Labels)**: Button labels should prefer **verb forms** that clearly state the intended action (e.g., "Save Changes", "Submit Form", "Confirm Details") over bare nouns (e.g., "Save", "Submit"). This encourages user action and contributes to higher conversion rates.
        *   **Law (Debug Artifact Display Ban)**: Runtime debug values (`null`, `undefined`, `NaN`), stack traces, and raw database error messages being displayed in the UI is **strictly prohibited**. These give users the impression that the system is "broken" and constitute a critical UX deficiency. Always catch them with Error Boundaries or fallback UI and display user-comprehensible messages instead.
*   **The Explicit Explanation Protocol (Zero Jargon / Tooltip Mandate)**:
    *   **Law**: What's "common knowledge" to developers (API, Webhook, MRR) is "mystery symbols" to users. Lack of explanation means failure as a tool.
    *   **Action**: 
        1. **No Jargon**: Minimize technical terms in UI text; choose universally understandable words.
        2. **Tooltip Mandate**: When technical terms or calculated values (MRR etc.) are unavoidable, MUST add **`Info` icon with `Tooltip`** explaining "what it is, how it's calculated, how it affects business" in non-engineer language.
*   **Code Input Standard**:
    *   **Law**: Using raw `textarea` for HTML/CSS/JSON code editing is prohibited—lacks syntax highlighting, invites errors, damages quality.
    *   **Action**: MUST use editor components like `react-simple-code-editor` (+ `prismjs`) for professional quality. Raw `Textarea` is considered incomplete.

## 11. Safety UI Protocols
*   **No Native Popups**:
    *   Use of `window.alert`, `confirm`, `prompt` is prohibited as they block threads and damage UX. Always use `Dialog` components.
*   **Destructive Actions**:
    *   **Magic Word**: For irreversible actions like permanent deletion, verify with **Magic Word Input** (e.g., type "delete") instead of a simple "OK" button.
*   **Dirty Check**:
    *   Warn users ("Changes will be lost") when attempting to leave with unsaved changes.
*   **Loading Lock Protocol (Double-Submit Prevention)**:
    *   **Law**: Leaving buttons clickable during form submission or async processing causes double-registration and Race Conditions, and is strictly prohibited.
    *   **Action**: During processing (`isLoading`), disable buttons with the `disabled` attribute and visually indicate with greyout or spinner. For actions with significant side effects, additionally use `pointer-events-none` to physically block clicks.
*   **Responsive Action Button Protocol**:
    *   **Mobile**: Important action buttons (register, save, purchase, etc.) should be `w-full` (full screen width) for easy tapping.
    *   **Desktop**: Use `w-auto` with sufficient minimum width and **center alignment**. Making buttons `w-full` on PC causing visual stretching is prohibited.
    *   **Affordance**: Apply shadows (`shadow-md`) and hover effects to convey "clickability".
*   **Rich Selection Protocol**:
    *   **Law**: Standalone use of small radio buttons or checkboxes is prohibited for important selection UIs, as their hit area is insufficient for touch devices and the selected state has poor visibility.
    *   **Standard**: Use **Selectable Card Grid** as the standard—featuring large hit areas, clear borders, color changes on selection (background/border color changes), and icon-based visual aids.
    *   **Implementation**: Hide native radio/checkbox elements with `sr-only` for screen readers, and style adjacent label elements using `peer-data-[state=checked]:` or equivalent techniques.

## 12. Hospitality UX (Omotenashi - Japanese Hospitality)
*   **Kigakiku (Anticipatory)**: Anticipate needs before users struggle. (e.g., Offer "Convert to Half-width?" button on Full-width error).
    *   **Input Normalization (Tolerant Input Principle)**: When users enter data in an imprecise format (full-width numbers, full-width spaces, etc.), do NOT reject with validation errors. Instead, **silently auto-convert (Normalize)** on `onChange` or `onBlur`. Use `String.normalize('NFKC')` etc. to minimize user input burden.
    *   **Locale-Specific Input Assistance**: For locale-specific data entry (address, name, etc.), implement **locale-tailored input assistance features** (e.g., postal code to address auto-complete, phonetic reading auto-generation, phone number formatting, etc.) to reduce user input burden. Always allow manual correction after auto-completion to preserve user control.
*   **Ma (Negative Space)**: White space is for "Thinking Time", not just empty space. Merge Silicon Valley density with Japanese Ma.
*   **Aizuchi (Reassuring Feedback)**: Give reassuring feedback (Visual/Haptic) to every action. "Your operation is conveyed."
*   **The Graceful Error Recovery Protocol**:
    *   **Law**: When unexpected errors occur, do not merely state the facts—express empathy to the user, and **always provide action buttons for the user's next step** (reload, return home, contact support, etc.).
    *   **Action**: Error pages and error modals MUST include a concise explanation of the cause along with at least one recovery action button. A "Dead End" error screen that offers no escape accelerates user churn and constitutes a UX failure.
*   **Error Page Design Protocol**:
    *   **Law**: Error pages are the moment users feel the most anxious. The following design standards are established to prevent churn and maintain trust.
    *   **Design Principles**:
        1.  Maintain brand logo and color scheme (blank white pages are prohibited)
        2.  Visually convey the situation using illustrations or icons
        3.  Present next actions clearly, limited to 3 or fewer (e.g., "Return to Top", "Search", "Contact Us")
    *   **HTTP Status Compliance**: Error pages MUST return the correct HTTP status code. Returning 200 is prohibited. 404 pages MUST include `<meta name="robots" content="noindex">`.
    *   **Prohibited**: Displaying stack traces or debug information, and wording that blames the user (e.g., "There is a problem with your operation") are strictly prohibited.
*   **The Ghost Content Protocol (Time-Gated SEO / Scheduled Content Isolation)**:
    *   **Context**: Scheduled content (published_at > NOW()) exists on the server but must behave as if it "does not exist" for general users and search engines.
    *   **Action**:
        1.  **404 Mock**: For access from general users, return the same UI and status code as a regular 404 error, preventing them from guessing the content's existence.
        2.  **NoIndex Guard**: As a safeguard against URL leakage, force-inject `<meta name="robots" content="noindex, nofollow" />` on all unpublished pages.

## 13. Design Ops & Tools
*   **Design System**: Figma is truth. Code follows Figma.
*   **Tool Usage Protocol**:
    *   **Figma (UI/UX)**: Engineers MUST use **Dev Mode**. No guesswork.
    *   **Adobe CC**: Use Photoshop/Illustrator for logos/graphics. Export as SVG/WebP.
    *   **Canva**: Use for non-product UI (OGP, Documents).
*   **Hand-off**:
    *   **Status**: Mark frames (Draft/Ready/Shipped).
    *   **Export**: WebP or SVG by default. Avoid PNG/JPG.

## 14. Interaction Safety Protocols

### 14.1. The Responsive Safety Protocol (No-Trap Mandate)
*   **Law**: Physics differ between PC and SP.
*   **Action**:
    1.  **SP (Drawer Safety)**: Add `data-vaul-no-drag` to scrollable areas in Drawers to prevent accidental close.
    2.  **PC (Viewport Safety)**: Set `max-height` for floating elements like Popovers to prevent overflow outside screen.
    3.  **Responsive Split**: Use `Drawer` for Mobile, `Popover` for PC standard.
    4.  **iOS Input Zoom Defense**: On iOS Safari, when input field `font-size` is **below 16px**, the browser auto-zooms on focus, damaging UX. The `font-size` of `input`, `textarea`, `select` in mobile views MUST be enforced at **16px (`text-base`)** or above.

### 14.2. The Mobile Click/Tap Fix
*   **Law**: Mobile Popovers may fail to capture tap events due to focus conflicts.
*   **Action**: Force `pointer-events-auto` on interactive items and ensure event firing with multiple bindings (`onClick`, `onPointerUp`).
*   **Combobox Interaction Protocol**:
    *   **Stable IDs**: `value` attributes in virtual lists (CMDK) MUST use unique/immutable **ASCII Strings** (IDs). Usage of Japanese triggers selection logic bugs.
    *   **Searchability**: If Japanese search is needed, explicitly specify `keywords` property (array) to guarantee searchability.

### 14.3. The Z-Index Stratification Protocol
*   **Law**: End the Z-Index war.
    *   **Level 4 (Max)**: `z-[10000]` - Overlay Components (Select, Popover, Tooltip) *Above Modal*
    *   **Level 3**: `z-[9999]` - Dialog / Modal
    *   **Level 2**: `z-[1000]` - Full Screen UI (Mobile Menu, Drawer)
    *   **Level 1**: `z-50` - Fixed Header, Floating Buttons
    *   **Level 0**: `z-0` ~ `z-40` - Page Content
*   **Action**: No magic numbers like `z-100`. Strictly adhere to this hierarchy.

### 14.4. The Drag & Drop Safety Protocol
*   **Portal Rendering (Clipping Defense)**: `DragOverlay` MUST be rendered directly under `document.body` using `createPortal` to prevent clipping caused by parent element's `overflow: hidden`.
*   **Context Isolation**: When multiple DnD areas exist on a single page, isolate `DndContext` or assign unique IDs to prevent interference between areas.
*   **DragOverlay Input Ban**: Rendering form input elements (`input`, `textarea`) directly inside `DragOverlay` is prohibited. Form libraries (React Hook Form, etc.) will misidentify two input fields with the same `name`, causing validation bugs. Implement an `isOverlay` property branch that returns Read-Only JSX during overlay rendering.
*   **Accordion Handling**: When dragging elements containing Accordions, force all-closed state (`defaultValue={[]}`) inside the Overlay to prevent oversized elements from dominating the screen.

### 14.5. The Auto-Save Protocol
*   **Scope**: For admin screens and forms involving long-text input (articles, settings, content editing, etc.), implementing auto-save functionality is recommended.
*   **Hook Strategy**: Use a standardized `useAutoSave` hook to implement draft saving with debounce (2 seconds or more).
*   **Passive Restoration**: When a draft exists at page load, do NOT auto-apply it. Display a "Draft found" notification and give the user the choice to restore.
*   **Hygiene**: On successful form submission, call `clearDraft()` to clean up local storage.
*   **Roadmap**: Transitioning to server-side draft saving in the future is recommended to enable cross-device continuity (resume in progress).
*   **The Public Form Persistence Protocol**:
    *   **Context**: When end-user facing forms (contact, registration, etc.) lose all input due to browser closure during entry, it constitutes a UX loss.
    *   **Action**: Even for public-facing forms, using `localStorage` or `sessionStorage` for temporary input data persistence is recommended. Propose restoration on next visit to reduce user re-entry burden.

### 14.6. The Hard Session Refresh Protocol (Auth State Hard Reload)
*   **Context**: Even when session cookies (login, permission changes, etc.) are updated via Server Actions or APIs, SPA transitions (client-side routing) alone may not immediately reflect changes in Middleware or Server Components.
*   **Action**: When authentication state or critical permissions change (Login / Logout / privilege escalation, etc.), use `window.location.reload()` or `window.location.href` for a **hard refresh** to ensure the server is accessed with the latest cookie state.
*   **Rationale**: Soft navigation via client-side routing does not reflect Cookie/Session changes to Middleware, causing permission mismatch errors or security holes. The momentary white screen from a reload is a far more minor UX cost than permission inconsistencies.

### 14.7. The Offline Resilience Protocol (Network Instability Defense)
*   **Context**: When the app stops with a "white screen" in environments with unstable network (mobile connections, commuting, etc.), it constitutes a critical user experience deficiency.
*   **Action**:
    1.  **Component-Level Recovery**: Handle `onError` in data fetching libraries (SWR, React Query, etc.) and display skeleton or error messages with a "Reload" button at the component level before global Error Boundaries fire.
    2.  **Online Status Watch**: Monitor `navigator.onLine` and disable form submission buttons when offline is detected to prevent data loss. Displaying a banner notifying "You are currently offline" is recommended.

## 15. Localization & Internationalization

### 15.1. The Localization Completeness Protocol
*   **Law**: UI strings that remain untranslated in the target locale's language (button labels, placeholders, toast notifications, validation messages, empty state text, tooltips, etc.) are treated as **"bugs"**.
*   **Scope**: The following areas are priority scan targets:
    1.  **Static UI**: Button labels, headings, menu items
    2.  **Placeholders**: Input examples must be concrete and locale-appropriate
    3.  **Toasts & Alerts**: Success/error notification text
    4.  **Validation Messages**: Framework/library default messages (override with Zod `message` parameter, etc.)
    5.  **Date & Currency**: Locale-compliant formatting (see §2.1 Locale Format Mandate)
    6.  **Admin Panel**: Administrators are also speakers of the target locale's language. Untranslated labels in admin panels are bugs without exception
    7.  **Automated Emails & Notifications**: From subject line to signature, all text must be natural in the target language
*   **Exception**: Proper nouns (Google, LINE, Instagram, etc.) and technical terms where translation would be unnatural (URL, ID, API, etc.) are permitted.
*   **Internal Value Display Guard**: Directly displaying DB values, internal constants, or enum string values in the UI is prohibited. Always convert to the target language via mapping dictionaries or label properties.
*   **Scan Protocol**: Include verification that string literals in UI files (`.tsx`, etc.) are localized as a PR review checklist item. When possible, build CI script-based automated detection.

### 15.2. The Error Message UX Standard
*   **Law**: Error messages MUST meet the following quality standards.
*   **2-Sentence Rule**: Error messages MUST follow a **2-sentence structure**: "**What happened**" + "**What to do next**". A message that only reports the cause without suggesting a solution is incomplete.
*   **No Tech-Speak**: Displaying technical terms and debug information such as `null`, `undefined`, `NaN`, `UUID`, stack traces, and DB-specific error messages in the UI is physically prohibited. Always catch them with Error Boundaries or fallback UI and convert to user-comprehensible messages.
*   **Empathy First**: Error messages should "help" users, not "blame" them. Prefer affirmative framing over negation.
*   **Positive Framing**: Instead of "Cannot do X", say "Please do Y and try again" to show how to achieve the goal.
*   **Graceful Recovery**: Error screens and error modals MUST include a concise explanation of the cause plus **at least one recovery action button** (reload, return home, contact support, etc.). A dead-end error screen is a critical UX deficiency.

### 15.3. The IME/Input Method Handling Protocol
*   **Context**: In CJK language regions (Japanese, Chinese, Korean, etc.), input via IME (Input Method Editor) is standard, and `onChange` event firing timing differs from direct input.
*   **Composition Event Handling**:
    *   For search bars and instant-filtering UIs, properly handle `compositionstart` / `compositionend` events to prevent requests from firing before IME conversion is confirmed.
    *   When implementing or modifying input forms, testing with the following 3 patterns is recommended:
        1.  **IME ON (with conversion)**: The full sequence of candidate selection → confirmation
        2.  **IME OFF (direct input)**: Direct alphanumeric or URL input
        3.  **Mixed input**: Cases mixing target language and alphanumeric characters
*   **Input Normalization**: When users enter full-width numbers, full-width spaces, etc., do NOT reject with validation errors. Instead, silently auto-convert to half-width using **`String.normalize('NFKC')`** on `onChange` or `onBlur`. The principle is "tolerant input" that minimizes user input burden.

### 15.4. The i18n Readiness Protocol
*   **Context**: Even for single-language projects, maintaining a translation-ready architecture for future multilingual expansion is important.
*   **Design Principles**:
    1.  **String Resource Consolidation**: Consolidate UI text into constant files or dictionary objects as much as possible, minimizing hardcoding within components.
    2.  **Intl API Usage**: Use `Intl.DateTimeFormat` and `Intl.NumberFormat` for date, currency, and number formatting to maintain locale-switchable state.
    3.  **Translation Key Design**: In preparation for future i18n adoption, design translation keys with namespace separation per feature/page (e.g., `common.save`, `auth.login`, `error.network`), with a maximum depth of 3 levels.
    4.  **No Premature Investment**: Premature adoption of i18n libraries or creation of translated UIs before demand is confirmed is prohibited.
*   **Trigger Conditions**: Formally start a multilingual project when any of the following are met:
    *   International traffic exceeds **10%** of total
    *   Partnership offer from an international partner
    *   Business strategy decision for international expansion

### 15.5. The Error Message Catalog Protocol
*   **Law**: Writing error messages ad-hoc within individual components or actions is prohibited.
*   **SSOT**: Error messages MUST be centrally managed (Single Source of Truth) in a constants file (e.g., `error-messages.ts`) with a nested structure organized by category.
*   **Quality Standard**:
    | Element | Criteria |
    |:--------|:---------|
    | **Tone** | Unified in the standard polite expression of the target locale |
    | **Technical Terms** | Never expose (`UUID`, `500`, `null`, etc. are prohibited) |
    | **Untranslated Strings** | Not permitted (see §15.1 Localization Completeness) |
    | **Next Action** | Suggest solutions whenever possible |
*   **Fallback**: When no matching error exists in the catalog, display a generic fallback message.

### 15.6. The Accessible Native Language Label Protocol
*   **Law**: `aria-label` is text read aloud by screen readers—it is **information that reaches the user's ears**. It is not a developer-facing attribute.
*   **Mandate**: `aria-label` for user-facing UI elements MUST be written in the **target locale's language** as a rule.
*   **Exception**: Brand names and technical terms where transliteration is natural (e.g., PDF) may be mixed.
*   **Cross-Reference**: §6 (Accessibility & Inclusivity) aria-label related rules

---

## Appendix A: Quick Reference Index

| Keyword | Sections | Related Rules |
|---------|----------|---------------|
| Material Design / Expressive | §1 | `340_web_frontend`, `342_mobile_flutter` |
| Design Tokens / CSS | §2, §3 | `340_web_frontend`, `300_engineering_standards` |
| Animation / Motion | §4 | `343_native_platforms` |
| Responsive / Foldable | §5 | `342_mobile_flutter`, `343_native_platforms` |
| Accessibility / WCAG | §6 | `800_internationalization`, `340_web_frontend` |
| User Sovereignty | §7 | `600_security_privacy`, `601_data_governance` |
| AI UX / Latency | §9 | `400_ai_engineering` |
| Onboarding | §10 | `102_growth_marketing`, `501_customer_experience` |
| Safety UI | §11, §14 | `600_security_privacy`, `503_incident_response` |
| Hospitality / Omotenashi | §12 | `501_customer_experience` |
| Localization / i18n | §15 | `800_internationalization`, `802_language_protocol` |

