# 20. Design & UX Strategy

## 5. Adaptability & Foldables

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

## 7. User Sovereignty (User First)
*   **Data Ownership**: Users control their data (Easy Export/Delete).
*   **No Dark Patterns**: No deception. Design for "Delight Metrics".
*   **Transparency**: Explainable AI (Why this content?).

## 8. Tools & Workflow
*   **Figma**: The Source of Truth. Use Dev Mode.
*   **Rive**: Use for complex vector animations.
*   **Inclusive Copywriting**: Language that excludes no one.

