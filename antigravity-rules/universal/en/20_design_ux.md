# 20. Design & UX Strategy

## 1. Philosophy: "Silicon Valley Excellence & Google First"

### 1.1. The "Wow" Factor (Delight)
*   **Mandate**: Every interaction must feel "alive". We do not build static screens; we build **dynamic experiences**.
*   **Google Standard**: Adopt **Material Design 3 (Material You)** and its **"Expressive"** evolution (2025+) as the baseline.
*   **Differentiation**: While using Google's system, we differentiate through **high-fidelity motion**, **custom shaders**, and **bold typography** to achieve a "Premium Silicon Valley" feel.

### 1.2. Trend Scouting Protocol (Mandatory)
Before *any* design task (even a single component), the following "Scouting Loop" is mandatory:
1.  **Analyze Leaders**: Check **Mobbin** (iOS/Android flows), **Awwwards** (Web trends), and **Google Design** (latest specs).
2.  **Deconstruct**: Identify *why* a top-tier app feels good (e.g., "The bounce on this modal makes it feel playful").
3.  **Apply**: Adapt that specific "feel" to our context. **Never copy blindly; steal the "soul" of the interaction.**
4.  **AI Leverage**: Use Generative AI to brainstorm "futuristic" variants of standard UI components.

## 2. Visual Language & System

### 2.1. Material 3 Expressive
*   **Dynamic Color**: Utilize the `dynamic_color` engine to harmonize with the user's wallpaper/OS, but enforce high-contrast overrides for critical actions.
*   **Shapes**: Use **Expressive Shapes** (asymmetric corners, morphing containers) to break the "boxy" grid.
*   **Typography**: Use variable fonts (e.g., Roboto Flex, Inter) to animate weight/width during interactions.

### 2.2. Motion & Gestures (The "Soul")
*   **Physics-Based**: All animations must use **spring physics** (stiffness/damping). Things should bounce, stretch, and squash slightly.
*   **Gestures (Swipe First)**:
    *   **Navigation**: Support "Swipe Back" universally.
    *   **Actions**: Use **Swipe-to-Action** (Archive, Delete) for list items.
    *   **Feel**: Gestures must track 1:1 with the finger. No lag. Use **Haptics** (Light Impact) to confirm threshold crossing.
*   **Micro-interactions**:
    *   **Buttons**: Scale down on press (`0.95x`), bounce up on release.
    *   **Lists**: Staggered entrance animations (Waterfall effect).
    *   **Transitions**: Use **Container Transforms** (card expands to page).

## 3. Design System Ops (Scalability & Performance)

### 3.1. Scalability & Maintenance
*   **Atomic Design**: Strictly follow Atomic Design (Atoms -> Molecules -> Organisms).
*   **Tokenization**: All colors, spacing, and type MUST be tokens. **Hardcoded values are banned.**
*   **Component Governance**: Before creating a new component, check if an existing one can be extended. Avoid "Component Bloat".

### 3.2. Performance & Cost Awareness
*   **Render Cost**: Heavy effects (Blur, Shadows) must be used sparingly. Test on low-end devices.
    *   *Rule*: If a blur causes frame drops, replace with a semi-transparent scrim.
*   **Asset Optimization**: Use **Vector (SVG/Lottie/Rive)** over Raster. If Raster is needed, use **WebP** and lazy load.
*   **Battery Impact**: Avoid infinite looping animations unless user-initiated.

## 4. Adaptability & Foldables

### 4.1. Universal Responsiveness
*   **Rule**: "Mobile-First" is dead. We design for **"Any-Screen"**.
*   **Foldables**:
    *   **Hinge Awareness**: UI must split intelligently around the hinge (Tabletop mode).
    *   **Continuity**: State must be preserved perfectly when folding/unfolding.
*   **Large Screens**: Use **Canonical Layouts** (List-Detail, Supporting Pane, Feed) to utilize extra space. Never just "stretch" the mobile UI.

## 5. Accessibility (A11y)
*   **Non-Negotiable**: A11y is not a "nice to have"; it is a launch blocker.
*   **Touch Targets**: Minimum 48x48dp for all interactive elements.
*   **Semantics**: All custom components must have proper semantic labels for screen readers (TalkBack/VoiceOver).

## 6. Tools & Workflow
*   **Figma**: The source of truth. Dev Mode must be used for exact token handoff.
*   **Rive / Lottie**: Use **Rive** for interactive vector animations (state machines) where code-based animation is too complex.
*   **Inclusive Copywriting**:
    *   Use Inclusive Language that excludes no one regardless of gender, race, age, or ability.

## 4. AI & Personalization
*   **Hyper-Personalization**:
    *   Leverage AI to dynamically optimize displayed content and suggestions based on each user's context.
