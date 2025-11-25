# 20. Design & UX Strategy

## 1. Design Philosophy (Silicon Valley Excellence & Google First)

### 1.1. The "Wow" Factor (Delight)
*   **Mandate**: Every interaction must feel "alive". Build **dynamic experiences**, not static screens.
*   **Google Standard**: Adopt **Material Design 3 (Material You)** and its evolution **"Expressive"** (2025+) as the baseline.
*   **Apple Standard**: On iOS, respect the **Human Interface Guidelines (HIG)**. Do not force Material Design; maintain Platform Fidelity (e.g., switches, pickers).
*   **Differentiation**: While using Google's system, differentiate with **high-fidelity motion**, **custom shaders**, and **bold typography** to create a "Silicon Valley Premium" feel.
*   **Tools**: Refer to `21_design_ops_tools.md` for specific rules on Figma, Adobe, and Canva.

### 1.2. Trend Scouting Protocol
Before *every* design task (even a single component), the following "Scouting Loop" is mandatory:
1.  **Analyze Leaders**: Check **Mobbin** (iOS/Android flows), **Awwwards** (Web trends), and **Google Design** (latest specs).
2.  **Deconstruct**: Dissect why top-tier apps feel "pleasant" (e.g., "This modal's bounce creates playfulness").
3.  **Apply**: Adapt that "Soul" to our context. **Do not blindly copy; steal the "Soul" of the interaction.**
4.  **AI Leverage**: Use Generative AI to brainstorm "futuristic" variations of standard UI components.

## 2. Visual Language & System

### 2.1. Material 3 Expressive
*   **Dynamic Color**: Leverage the `dynamic_color` engine to harmonize with the user's wallpaper/OS, but force high-contrast overrides for critical actions.
*   **Shapes**: Use **Expressive Shapes** (asymmetrical corners, morphing containers) to break the "boxy" grid.
*   **Typography**: Use variable fonts (Roboto Flex, Inter, etc.) and animate weight/width during interactions.

### 2.2. Motion & Gestures (The "Soul")
*   **Physics-Based**: All animations use **Spring Physics** (stiffness/damping). Elements should bounce, stretch, and slightly squash.
*   **Swipe First**:
    *   **Navigation**: Universally support "Swipe Back".
    *   **Actions**: Use **Swipe-to-Action** (Archive, Delete) for list items.
    *   **Feel**: Gestures must track finger movement 1:1. Lag is strictly prohibited. Use **Haptics** (light vibration) for confirmation when thresholds are crossed.
*   **Micro-interactions**:
    *   **Buttons**: Scale down (`0.95x`) on press, bounce back on release.
    *   **Lists**: Adopt staggered entrance animations.
    *   **Transitions**: Use **Container Transforms** (card expands into page) instead of simple push transitions.
*   **Sliders & Carousels**:
    *   **Snap Physics**: Scrolling must always snap to snap points. Prevent stopping in halfway positions.
    *   **Parallax**: Use parallax effects on backgrounds or elements during swipes to create depth.

### 2.3. Performance Animation
*   **60fps (120fps) Target**:
    *   Animations must always maintain 60fps (120fps if possible).
    *   **GPU Optimization**: Animate only `transform` and `opacity` properties. Animating `width`, `height`, `top`, `left` causes layout recalculation (Reflow) and is prohibited.
    *   **Will-Change**: Use the `will-change` property only when necessary to give hints to the browser, but avoid overuse (to prevent memory bloat).

## 3. Design System Ops

### 3.1. Scalability & Maintenance
*   **Atomic Design**: Strictly adhere to Atomic Design (Atoms -> Molecules -> Organisms).
*   **Tokenization**: All colors, spacing, and typography must be tokenized. **Hardcoded values are prohibited.**
*   **Component Governance**: Before creating a new component, check if an existing one can be extended. Avoid "Component Bloat".

### 3.2. Performance & Cost Awareness
*   **Render Cost**: Use heavy effects (Blur, Shadows) carefully. Testing on low-end devices is mandatory.
    *   *Rule*: If blur causes frame drops, replace it with a translucent Scrim.
*   **Asset Optimization**: Prioritize **Vectors (SVG/Lottie/Rive)** over raster images. If raster is needed, use **WebP** and Lazy Load.
*   **Battery Impact**: Avoid infinite loop animations when the user is not interacting (to suppress battery consumption).

## 4. Adaptability & Foldables

### 4.1. Universal Responsiveness
*   **Rule**: "Mobile First" is dead. We design for **"Any-Screen"**.
*   **Foldables**:
    *   **Hinge Awareness**: UI must recognize the hinge and split intelligently (Tabletop Mode).
    *   **Continuity**: State must be fully preserved during fold/unfold.
*   **Large Screens**: Use **Canonical Layouts** (List-Detail, Supporting Pane, Feed) to utilize whitespace effectively. Simply "stretching" mobile UI is prohibited.

## 5. Accessibility & Inclusivity
*   **WCAG 2.1 AA Standard**:
    *   **Contrast**: Ensure a minimum contrast ratio of **4.5:1** for text and background.
    *   **Scaling**: Font size must follow user settings (Dynamic Type / Text Scaling).
*   **Touch Targets (Mobile First)**:
    *   **Rule**: Ensure a minimum touch target of **44x44dp (iOS) / 48x48dp (Android)** for all interactive elements.
    *   **Reachability**: Place frequently used actions at the bottom of the screen (within thumb reach).
*   **Semantics**:
    *   Assign appropriate semantic labels for screen readers (TalkBack/VoiceOver) to all custom components. Always set `alt` text for images.
    *   **ARIA**: Use WAI-ARIA attributes only when native HTML elements cannot express the semantics.

## 6. User Sovereignty (User First)
*   **Data Ownership**:
    *   Users have the right to fully control their data. Place "Export" and "Delete Account" in accessible locations.
*   **No Dark Patterns**:
    *   Deceptive designs (hiding cancellation, auto-adding to cart) are strictly prohibited.
    *   **Delight Metric**: Intentionally design moments where users feel "fun to use" (Micro-delights).
*   **Transparency**:
    *   Make AI decision logic and reasons for content display understandable to users (Explainable AI).

## 7. Tools & Workflow
*   **Figma**: The Single Source of Truth. Use Dev Mode for accurate token hand-off.
*   **Rive / Lottie**: Use **Rive** (vector animation with state machines) if code-based animation is too complex.
*   **Inclusive Copywriting**:
    *   Choose words that do not exclude anyone based on gender, race, age, or ability (Inclusive Language).

## 8. AI UX Strategy (Latency Management)
*   **Streaming First**:
    *   AI generation wait time must be "perceived zero".
    *   **Streaming Responses**: Display in real-time, one token at a time, without waiting for completion (Typing Animation).
*   **Optimistic Updates**:
    *   React the UI immediately to user actions (e.g., send button press) without waiting for AI processing (e.g., instant chat bubble).
*   **Transparency**:
    *   Visually distinguish between AI "Thinking..." and "Generating..." states to reassure the user.
## 9. User Onboarding & Guidance
*   **Coach Marks**:
    *   **Context-Aware**: Display only when the user visits the screen for the first time or when a new feature is added.
    *   **UI Pattern**: As shown in the attached image, highlight the target element (e.g., button) and present a concise explanation and action (e.g., "Record") in a tooltip.
    *   **Skippable**: Always provide a means to "Skip" or "Close" to avoid the stress of forced tutorials.
*   **Feature Discovery**:
    *   **Progressive Disclosure**: Do not explain all features at once; reveal advanced features gradually according to the user's proficiency.
    *   **Empty States**: Treat the "Zero Data" state not as an "Error" but as an "Onboarding Opportunity". Instead of just "No records", place a clear Call to Action (CTA) like "Add your first record".
*   **General Consumer Perspective**:
    *   **No Jargon**: Do not use technical terms like "Database", "Sync", or "API" in UI text. Choose words anyone can understand, like "Save", "Update", or "Connect".
    *   **Intuitiveness**: The goal is "Usable without reading a manual". Always add labels to icons to eliminate ambiguity.

## 10. Omotenashi UX (Japanese Hospitality)
*   **Kigakiku (Anticipatory Design)**:
    *   **Anticipation**: Anticipate needs and present solutions before the user gets stuck.
    *   **Example**: The moment an error occurs in a form input, instead of just turning it red, offer a correction button like "It's full-width. Shall we fix it to half-width?".
*   **Ma (Negative Space)**:
    *   **Aesthetics of Emptiness**: Fuse Silicon Valley's "Information Density" with Japan's "Ma (Space)". White space is not just empty space, but a function to give the user "Time to Think".
*   **Aizuchi (Reassuring Feedback)**:
    *   **Reaction**: Return visual or haptic "Aizuchi (Nods)" for every user action (tap, scroll, input). Constantly provide reassurance that "Your operation is being correctly received".
