# 20. Design & UX Strategy

> [!CRITICAL]
> **Rule 20.0: The Consistency Mandate (Professionalism Protocol)**
>
> - **Law**: Inconsistency in UI/UX is a "Lack of Professionalism".
> - **Action**: Do not tolerate minor deviations such as "The button is on the left only on this screen" or "The delete flow is different only here". Elements that disrupt the overall Harmony are bugs, even if they function.
> - **Target**: Maintain "Iron Consistency" especially in critical flows like "Delete", "Save", and "Authentication" to protect the user's mental model.

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

*   **Streaming First**: Zero perceived latency. Stream responses immediately.
*   **Optimistic Updates**: React UI immediately to user actions before AI finishes.
*   **Transparency**: Visually distinguish "Thinking" vs "Generating".

*   **Kigakiku (Anticipatory)**: Anticipate needs before users struggle. (e.g., Offer "Convert to Half-width?" button on Full-width error).
*   **Ma (Negative Space)**: White space is for "Thinking Time", not just empty space. Merge Silicon Valley density with Japanese Ma.
*   **Aizuchi (Reassuring Feedback)**: Give reassuring feedback (Visual/Haptic) to every action. "Your operation is conveyed."
*   **The Graceful Error Recovery Protocol**:
*   **Law**: When unexpected errors occur, do not merely state the facts—express empathy to the user, and **always provide action buttons for the user's next step** (reload, return home, contact support, etc.).
*   **Action**: Error pages and error modals MUST include a concise explanation of the cause along with at least one recovery action button. A "Dead End" error screen that offers no escape accelerates user churn and constitutes a UX failure.
