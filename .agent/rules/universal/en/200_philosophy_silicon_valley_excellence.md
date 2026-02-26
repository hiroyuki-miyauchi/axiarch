# 20. Design & UX Strategy

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

# 20. Design & UX Strategy

> [!CRITICAL]
> **Rule 20.0: The Consistency Mandate (Professionalism Protocol)**
>
> - **Law**: Inconsistency in UI/UX is a "Lack of Professionalism".
> - **Action**: Do not tolerate minor deviations such as "The button is on the left only on this screen" or "The delete flow is different only here". Elements that disrupt the overall Harmony are bugs, even if they function.
> - **Target**: Maintain "Iron Consistency" especially in critical flows like "Delete", "Save", and "Authentication" to protect the user's mental model.
