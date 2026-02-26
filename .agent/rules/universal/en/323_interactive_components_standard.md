# 33. Web Frontend Engineering - Next.js

### 2.4. Interactive Components Standard
*   **Rich Selection Protocol**:
    *   Conventional Radio/Checkbox are prohibited in principle. Adopt **"Rich Card-type UI that is intuitively clickable"** as standard.
*   **Responsive Combobox Protocol**:
    *   **Desktop**: Use `Popover` (modal=true).
    *   **Mobile**: Use **Drawer (Vaul)**.
    *   **Mobile Click/Tap Fix**: Add `data-vaul-no-drag` attribute to scrollable areas in `vaul` (Drawer) to prevent unintended closing by swipe.
    *   **Breadcrumb Priority Lesson (Stack Layout)**: Placing breadcrumbs and action buttons horizontally on mobile headers pushes breadcrumbs off-screen. Recommend strict vertical **Stack (flex-col)** layout.
    *   **Interaction**: Force `pointer-events-auto` on `CommandItem` and bind `onClick`/`onPointerUp` to prevent tap failure.
    *   **Stable IDs**: `value` of `CommandItem` MUST be unique, coherent **ASCII string** (IDs). Using Japanese for `value` breaks selection logic. Use `keywords` for Japanese search.

### 2.5. The Z-Index Stratification Protocol (Menu Dominance)
*   **Law**: Prevent Z-Index "Magic Numbers" and guarantee UI stacking order.
*   **Definition**:
    *   **Overlay (10000)**: `Select`, `Popover`, `Tooltip`, `Calendar`. Must be topmost.
    *   **Modal (9999)**: `Dialog`, `Sheet`. Below Overlays.
    *   **Menu (1000)**: Drawer menus, Navigation.
    *   **Header (50)**: Fixed header.
    *   **Floaters (40)**: Floating buttons (Chat). NEVER place above menus.
