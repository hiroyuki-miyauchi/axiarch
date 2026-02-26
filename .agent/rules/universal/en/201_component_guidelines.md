# 20. Design & UX Strategy

# 20. Design & UX Strategy

> [!CRITICAL]
> **Rule 20.0: The Consistency Mandate (Professionalism Protocol)**
>
> - **Law**: Inconsistency in UI/UX is a "Lack of Professionalism".
> - **Action**: Do not tolerate minor deviations such as "The button is on the left only on this screen" or "The delete flow is different only here". Elements that disrupt the overall Harmony are bugs, even if they function.
> - **Target**: Maintain "Iron Consistency" especially in critical flows like "Delete", "Save", and "Authentication" to protect the user's mental model.

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
