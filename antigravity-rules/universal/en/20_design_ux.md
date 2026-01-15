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

### 1.2. Trend Scouting Protocol
For *every* design task, the following "Scouting Loop" is mandatory:
1.  **Analyze Leaders**: Check Mobbin, Awwwards, Google Design.
2.  **Deconstruct**: Why does it feel good? Deconstruct the "Soul".
3.  **Apply**: Adapt that soul to our context. **Steal the soul, don't blindly copy.**
4.  **AI Leverage**: Brainstorm "futuristic" variations using GenAI.

## 2. Design Engineering

### 2.1. Design Tokens
*   **Single Source of Truth**: Define all values (color, spacing, typo) in Figma Variables and sync 100% with Code (Tailwind/CSS Variables).
*   **No Hardcoding**: Writing `px` or `#hex` directly is **strictly prohibited**. Use tokens.
*   **Dynamic Theme**: Theme settings (`site_settings`) must be fetched from DB at Runtime (`RootLayout`) and injected as CSS variables.

## 2. Component Implementation Guidelines
### 2.1. Implementation Patterns
*   **Skeleton Loader**:
    *   Use **Skeleton Screen** (`<Skeleton />`) instead of spinners during loading (Suspense) to prevent Layout Shift (CLS).
*   **Feedback Hierarchy**:
    *   **Toast**: Success/Notification (Async).
    *   **Inline Alert**: Context-dependent errors.
    *   **Modal Dialog**: Critical warnings. Display at `z-[9999]`.
*   **Optimistic UI**:
    *   For lightweight actions like "Like", update display immediately without waiting for server response to achieve Native-like speed.

### 2.2. Layout Architecture
*   **The Natural Scrolling Protocol**:
    *   Prohibit custom scroll containers (`h-screen` + `overflow-scroll`). Adopt browser-native scroll with `min-h-screen`.
*   **The Single Container Protocol**:
    *   If Layout provides a container, re-defining padding/container in Page is strictly prohibited (Double Padding).
*   **Navigation Standards**:
    *   **Breadcrumb Priority**: Breadcrumbs are the "Lifeline". Must be placed at the **top of the page** on both Mobile and PC. Stack vertically with action buttons on Mobile.
    *   **Extension Defense**: Apply `suppressHydrationWarning` to global navigation links (Link) to protect from DOM modification by browser extensions.

### 2.2. Motion & Gestures (The "Soul")
*   **Physics-Based**: All animation uses spring physics. Elements should bounce, stretch, and squash.
*   **Swipe First**: Implement universal swipe-back and swipe-to-action. No lag allowed.

### 2.3. Multi-Sensory Design
*   **Haptics**: Assign delicate "Tap", "Click" haptics to success/error/select events. Avoid heavy vibration.
*   **Sonic Branding**: Use sound logos for branding and micro-sounds for UI interactions.

## 3. Performance Animation
*   **60fps Target**: Maintain 60fps (120fps preferred).
*   **GPU Optimization**: Animate only `transform` and `opacity`. No layout thrashing properties (`width`, `height`, etc).

## 4. Adaptability & Foldables

### 4.1. Universal Responsiveness
*   **Rule**: "Mobile First" is obsolete. We design for **"Any-Screen"**.
*   **Foldables**: Be Hinge-Aware and maintain continuity across states.
*   **Large Screens**: Use Canonical Layouts. Do not just stretch mobile UI.

## 5. Accessibility & Inclusivity
*   **WCAG 2.1 AA**: Contrast ratio 4.5:1+, supports dynamic type scaling.
*   **Touch Targets**: Minimum 44x44dp (iOS) / 48x48dp (Android). Important actions at the bottom.
*   **Semantics**: Proper labels for screen readers.

## 6. User Sovereignty (User First)
*   **Data Ownership**: Users control their data (Easy Export/Delete).
*   **No Dark Patterns**: No deception. Design for "Delight Metrics".
*   **Transparency**: Explainable AI (Why this content?).

## 7. Tools & Workflow
*   **Figma**: The Source of Truth. Use Dev Mode.
*   **Rive**: Use for complex vector animations.
*   **Inclusive Copywriting**: Language that excludes no one.

## 8. AI UX Strategy (Latency Management)
*   **Streaming First**: Zero perceived latency. Stream responses immediately.
*   **Optimistic Updates**: React UI immediately to user actions before AI finishes.
*   **Transparency**: Visually distinguish "Thinking" vs "Generating".

## 9. User Onboarding & Guidance
*   **Coach Marks**: Context-aware tooltips. Always skippable.
*   **Feature Discovery**: Progressive disclosure. Zero Data is an onboarding opportunity.
*   **General Consumer Perspective**: No technical jargon ("Database", "API"). Use intuitive words ("Save", "Connect").

    *   **Micro-Interaction Standards**:
        *   **Cursor Affordance**: Clickable elements (including Cards and custom inputs) must apply `cursor-pointer` on hover to clarify affordance.

## 10. Safety UI Protocols
*   **No Native Popups**:
    *   Use of `window.alert`, `confirm`, `prompt` is prohibited as they block threads and damage UX. Always use `Dialog` components.
*   **Destructive Actions**:
    *   **Magic Word**: For irreversible actions like permanent deletion, verify with **Magic Word Input** (e.g., type "delete") instead of a simple "OK" button.
*   **Dirty Check**:
    *   Warn users ("Changes will be lost") when attempting to leave with unsaved changes.

## 10. Hospitality UX (Anticipatory Design)
*   **Kigakiku (Anticipatory)**: Anticipate needs before users struggle.
*   **Ma (Negative Space)**: White space is for "Thinking Time", not just empty space.
*   **Aizuchi (Reassuring Feedback)**: Give reassuring feedback (Visual/Haptic) to every action.

## 11. Design Ops & Tools
*   **Design System**: Figma is truth. Code follows Figma.
*   **Figma -> Code**: Use Dev Mode. No guesswork.
*   **Hand-off**: Mark status (Draft/Ready/Shipped). Export as WebP/SVG.

## 12. Universal Beauty Protocol

### 12.1. The Responsive Mandate
*   **Law**: Verifying "Beauty" and "Functionality" across 3 environments is the **Top Priority**.
    1.  **SP (Mobile)**: Portrait (Width < 640px)
    2.  **Tablet**: Portrait/Landscape (Width 768px ~ 1280px) *Watch out for iPad Portrait.*
    3.  **PC (Desktop)**: Full size (Width > 1280px)
*   **Action**: "It works on PC" is not acceptable. Responsive defects are considered "Incomplete".

### 12.2. The Fragmented UI Lesson (Lack of Unity)
*   **Law**: "Similar but different" is the worst. UI components must be standardized including their layout context.
*   **Action**: Ad-hoc CSS adjustments per page are prohibited. Follow the single "Gold Standard".

### 12.3. The Mobile First Typography
*   **Law**: PC-first giant fonts (e.g., direct `text-3xl`) destroy mobile screens.
*   **Action**: Start writing font sizes from mobile standards (`text-xl`) and scale up using breakpoints (`sm:`, `lg:`).

## 13. Interaction Safety Protocols

### 13.1. The Responsive Safety Protocol (No-Trap Mandate)
*   **Law**: Physics differ between PC and SP.
*   **Action**:
    1.  **SP (Drawer Safety)**: Add `data-vaul-no-drag` to scrollable areas in Drawers.
    2.  **PC (Viewport Safety)**: Set `max-height` for floating elements like Popovers to prevent overflow.
    3.  **Responsive Split**: Use `Drawer` for Mobile, `Popover` for PC.

### 13.2. The Mobile Click/Tap Fix
*   **Law**: Mobile Popovers may fail to capture tap events due to focus conflicts.
*   **Action**: Force `pointer-events-auto` on interactive items and ensure event firing with multiple bindings (`onClick`, `onPointerUp`).

### 13.3. The Z-Index Stratification Protocol
*   **Law**: End the Z-Index war.
    *   **Level 4 (Max)**: `z-[10000]` - Overlay Components (Select, Popover, Tooltip) *Above Modal*
    *   **Level 3**: `z-[9999]` - Dialog / Modal
    *   **Level 2**: `z-[1000]` - Full Screen UI (Mobile Menu)
    *   **Level 1**: `z-50` - Fixed Header
    *   **Level 0**: `z-0` ~ `z-40` - Page Content
*   **Action**: No magic numbers like `z-100`. Strictly adhere to this hierarchy.
