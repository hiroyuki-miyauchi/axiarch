# 20. Design & UX Strategy

> [!CRITICAL]
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

## 3. Component Implementation Guidelines

### 3.1. Implementation Patterns
*   **Skeleton Loader**:
    *   Use **Skeleton Screen** (`<Skeleton />`) instead of spinners during loading (Suspense) to prevent Layout Shift (CLS).
*   **Feedback Hierarchy**:
    *   **Toast**: Success/Notification (Async).
    *   **Inline Alert**: Context-dependent errors.
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
*   **WCAG 2.1 AA**: Contrast ratio 4.5:1+, supports dynamic type scaling.
*   **Touch Targets**: Minimum 44x44dp (iOS) / 48x48dp (Android). Important actions at the bottom.
*   **The Fat Finger Protocol (Label Wrapping)**:
    *   **Law**: Prohibit placing checkboxes/radio buttons standalone.
    *   **Action**: Always wrap with `<label>` tag (or `shadcn/ui` `Label` component) including text to maximize touch target area. "Tapping text doesn't respond" is a bug.
*   **Semantics**: Proper labels for screen readers.
*   **Focus Ring Protocol (Accessibility Sight)**:
    *   **Law**: UI where focus state (Tab key navigation, etc.) is not visually recognizable is a "maze in the dark" for keyboard users—accessibility failure.
    *   **Action**: When removing browser default focus ring (`outline-none`), MUST redefine **high-contrast focus ring** (e.g., `ring-2 ring-primary ring-offset-2`). "Invisible Focus" is treated as a bug.

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

## 10. User Onboarding & Guidance
*   **Coach Marks**: Context-aware tooltips. Always skippable.
*   **Feature Discovery**: Progressive disclosure. Zero Data is an onboarding opportunity.
*   **General Consumer Perspective**: No technical jargon ("Database", "API"). Use intuitive words ("Save", "Connect").
*   **Micro-Interaction Standards**:
    *   **Cursor Affordance**: Clickable elements (including Cards and custom inputs) must apply `cursor-pointer` on hover to clarify affordance.
    *   **Hover State Fidelity**: Interactive cards must apply subtle background color change or elevation (`shadow-md`) on hover to signal reactivity to user's subconscious.
*   **The Microcopy Quality Protocol (Kindness First)**:
    *   **Law (No Blame)**: Error messages must "help" users, not "blame" them.
        *   **NG**: "Invalid Input"
        *   **OK**: "Please enter in email format" / "Only alphanumeric characters allowed"
    *   **Law (Safety Warning)**: For dangerous operations like delete confirmation, add **words emphasizing irreversibility** ("This action cannot be undone") with red UI.
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

## 12. Hospitality UX (Omotenashi - Japanese Hospitality)
*   **Kigakiku (Anticipatory)**: Anticipate needs before users struggle. (e.g., Offer "Convert to Half-width?" button on Full-width error).
*   **Ma (Negative Space)**: White space is for "Thinking Time", not just empty space. Merge Silicon Valley density with Japanese Ma.
*   **Aizuchi (Reassuring Feedback)**: Give reassuring feedback (Visual/Haptic) to every action. "Your operation is conveyed."

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
