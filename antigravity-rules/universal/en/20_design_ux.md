# 20. Design & UX Strategy

## 1. Philosophy: "Silicon Valley Excellence & Google First"

### 1.1. The "Wow" Factor - Delight
*   **Mandate**: All interactions must feel "alive". Build **dynamic experiences**, not static screens.
*   **Google Standard**: Adopt **Material Design 3 (Material You)** and its evolution **"Expressive"** (2025+) as the baseline.
*   **Apple Standard**: On iOS, respect **Human Interface Guidelines (HIG)**. Do not force Material Design; maintain Platform Fidelity (e.g., switches, pickers).
*   **Differentiation**: While using Google's system, differentiate with **high-precision motion**, **custom shaders**, and **bold typography** to create a "Silicon Valley Premium Feel".

### 1.2. Trend Scouting Protocol
Before *every* design task (even a single component), the following "Scouting Loop" is mandatory:
1.  **Analyze Leaders**: Check **Mobbin** (iOS/Android flows), **Awwwards** (Web trends), **Google Design** (latest specs).
2.  **Deconstruct**: Dissect why top-tier apps feel "pleasant" (e.g., "This modal's bounce creates playfulness").
3.  **Apply**: Adapt that "Soul" to our context. **Do not blindly copy; steal the "Soul" of the interaction.**
4.  **AI Leverage**: Use Generative AI to brainstorm "futuristic" variations of standard UI components.

## 2. Design Engineering

### 2.1. Design Tokens
*   **Single Source of Truth**: All design values like colors, spacing, typography, shadows, radius are defined in Figma Variables and 100% synced with code (Tailwind Config / CSS Variables).
*   **No Hardcoding**: Writing `px` or `#hex` directly in code is **strictly prohibited**. Always use tokens (e.g., `color-primary-500`, `spacing-4`).

### 2.2. Motion & Gestures - The "Soul"
*   **Physics-Based**: All animations use **Spring Physics** (stiffness/damping). Elements should bounce, stretch, and slightly squash.
*   **Swipe First**:
    *   **Navigation**: Universally support "Swipe Back".
    *   **Actions**: Use **Swipe-to-Action** (archive, delete, etc.) for list items.
    *   **Feel**: Gestures must follow finger movement 1:1. Lag is strictly prohibited.

### 2.3. Multi-Sensory Design
*   **Haptics**:
    *   **Tactile Feedback**: Assign iOS/Android native haptic patterns to Success, Error, Selection, and Impact events.
    *   **Subtlety**: Pursue delicate, premium feedback ("tick", "tock") rather than unpleasant vibrations ("buzz").
*   **Sonic Branding**:
    *   **Sound Logo**: Play a short sound symbolizing the brand (Sound Logo) at app launch or key achievements (conversion) to create a memorable experience.
    *   **UI Sounds**: Add subtle, non-intrusive sounds (Click, Pop) to button presses and toggles (configurable to OFF).

## 3. Performance Animation
*   **60fps (120fps) Target**:
    *   Animations must always maintain 60fps (120fps if possible).
    *   **GPU Optimization**: Animate only `transform` and `opacity` properties. Animating `width`, `height`, `top`, `left` causes layout recalculation (Reflow) and is prohibited.
    *   **Will-Change**: Use `will-change` property only when necessary to give hints to the browser, but avoid abuse (due to increased memory consumption).

## 4. Adaptability & Foldables

### 4.1. Universal Responsiveness
*   **Rule**: "Mobile First" is a dead phrase. We design for **"Any-Screen"**.
*   **Foldables**:
    *   **Hinge Awareness**: UI must recognize the hinge and split intelligently (Tabletop Mode).
    *   **Continuity**: State must be completely preserved during fold/unfold.
*   **Large Screens**: Use **Canonical Layouts** (List-Detail, Supporting Pane, Feed) and utilize whitespace effectively. Simply "stretching" mobile UI is prohibited.

## 5. Accessibility & Inclusivity
*   **WCAG 2.1 AA Standard**:
    *   **Contrast**: Ensure a minimum contrast ratio of **4.5:1** for text and background.
    *   **Scaling**: Font size must follow user settings (Dynamic Type / Text Scaling).
*   **Touch Targets - Mobile First**:
    *   **Rule**: All interactive elements ensure a minimum touch target of **44x44dp (iOS) / 48x48dp (Android)**.
    *   **Reachability**: Place frequently used actions at the bottom of the screen (thumb reach).
*   **Semantics**:
    *   Assign appropriate semantic labels for screen readers (TalkBack/VoiceOver) to all custom components. Always set `alt` text for images.

## 6. User Sovereignty - User First
*   **Data Ownership**:
    *   Users have the right to fully control their data. Place "Export" and "Delete Account" in obvious locations.
*   **No Dark Patterns**:
    *   Deceptive designs (hiding cancellation, auto-adding to cart) are strictly prohibited.
    *   **Delight Metric**: Intentionally design moments where users feel "fun to use" (Micro-delights).
*   **Transparency**:
    *   Enable users to understand the rationale behind AI decisions or why content is displayed (Explainable AI).

## 7. Tools & Workflow
*   **Figma**: The Single Source of Truth. Use Dev Mode for accurate token handoff.
*   **Rive / Lottie**: If code-based animation is too complex, use **Rive** (vector animation with state machines).
*   **Inclusive Copywriting**:
    *   Use Inclusive Language that does not exclude anyone regardless of gender, race, age, or ability.

## 8. AI UX Strategy - Latency Management
*   **Streaming First**:
    *   AI generation wait time must feel like "zero".
    *   **Streaming Responses**: Display 1 token at a time in real-time without waiting for completion (Typing Animation).
*   **Optimistic Updates**:
    *   React immediately to user actions (e.g., send button press) without waiting for AI processing (e.g., instant chat bubble).
*   **Transparency**:
    *   Visually distinguish between AI "Thinking..." and "Generating..." states to reassure users.

## 9. User Onboarding & Guidance
*   **Coach Marks**:
    *   **Context-Driven**: Display only when the user visits the screen for the first time or when a new feature is added.
    *   **UI Pattern**: Highlight the target element (button, etc.) and present a concise explanation and action ("Record", etc.) in a tooltip.
    *   **Skippable**: Always provide a "Skip" or "Close" means to avoid the stress of forced tutorials.
*   **Feature Discovery**:
    *   **Progressive Disclosure**: Do not explain all features at once; gradually present advanced features according to user proficiency.
    *   **Empty States**: View Zero Data states not as "errors" but as "onboarding opportunities". Place a clear Call to Action (CTA) like "Let's add your first record" instead of just "No records".
*   **General Consumer Perspective**:
    *   **No Jargon**: Do not use technical terms like "Database", "Sync", "API" in UI text. Choose words anyone understands like "Save", "Update", "Connect".
    *   **Intuitiveness**: The goal is "usable without reading the manual". Always label icons to eliminate ambiguity.

## 10. Omotenashi UX - Japanese Hospitality
*   **Kigakiku - Anticipatory Design**:
    *   **Anticipation**: Anticipate needs and present solutions before the user gets stuck.
    *   **Example**: When an error occurs in form input, instead of just turning red, present a fix button: "Full-width characters detected. Convert to half-width?".
*   **Ma - Negative Space**:
    *   **Aesthetics of Whitespace**: Fuse Silicon Valley's "Information Density" with Japan's "Ma (Space)". Whitespace is not just space but a function to give users "time to think".
*   **Aizuchi - Reassuring Feedback**:
    *   **Reaction**: Return visual or haptic "Aizuchi" (nodding/acknowledgment) to every user action (tap, scroll, input). Constantly provide reassurance that "Your operation is correctly transmitted".

## 11. Design Ops & Tools
*   **Design System**:
    *   **Single Source of Truth**: The Design System in Figma (Styles, Variables, Components) is the only truth. Code (Tailwind Config) is always subordinate to Figma.
*   **Tool Usage Protocol**:
    *   **Figma (UI/UX)**: Engineers must use **Dev Mode** to check properties. Implementation by eye is strictly prohibited.
    *   **Adobe Creative Cloud**: Use Photoshop/Illustrator for logos and complex graphics, and place them in Figma as SVG or WebP.
    *   **Canva**: Actively use Canva for "Non-Product UI" like OGP and internal documents, utilizing templates for efficiency.
*   **Hand-off**:
    *   **Status Management**: Clearly state statuses like "Draft", "Ready for Dev", "Shipped" on each frame in Figma.
    *   **Export**: Export images as **WebP** or **SVG** in principle. Do not use PNG/JPG unless there is a special reason.
