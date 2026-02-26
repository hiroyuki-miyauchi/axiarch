# 20. Design & UX Strategy

## 10. User Onboarding & Guidance
*   **Coach Marks**: Context-aware tooltips. Always skippable.
*   **Feature Discovery**: Progressive disclosure. Zero Data is an onboarding opportunity.
*   **General Consumer Perspective**: No technical jargon ("Database", "API"). Use intuitive words ("Save", "Connect").
*   **Micro-Interaction Standards**:
    *   **Cursor Affordance**: Clickable elements (including Cards and custom inputs) must apply `cursor-pointer` on hover to clarify affordance.
    *   **Hover State Fidelity**: Interactive cards must apply subtle background color change or elevation (`shadow-md`) on hover to signal reactivity to user's subconscious.
        *   **Clipboard Interaction Protocol (Copy Feedback)**: On successful "copy" actions for URLs or codes, always display an immediate **toast notification** or **icon change (checkmark, etc.)** to clearly indicate success. In environments where `navigator.clipboard` fails (non-HTTPS, etc.), implement a fallback that selects the text for manual copying.
        *   **Input Reflection Protocol (Real-time Label Sync)**: In collapsible UIs such as accordions, changes to internal input fields (`name`, `title`, etc.) MUST be reflected **in real-time** in parent components (list views, accordion headers). Behavior where "the title doesn't update until saved" is perceived as UX lag in admin interfaces.
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
*   **Loading Lock Protocol (Double-Submit Prevention)**:
    *   **Law**: Leaving buttons clickable during form submission or async processing causes double-registration and Race Conditions, and is strictly prohibited.
    *   **Action**: During processing (`isLoading`), disable buttons with the `disabled` attribute and visually indicate with greyout or spinner. For actions with significant side effects, additionally use `pointer-events-none` to physically block clicks.
*   **Responsive Action Button Protocol**:
    *   **Mobile**: Important action buttons (register, save, purchase, etc.) should be `w-full` (full screen width) for easy tapping.
    *   **Desktop**: Use `w-auto` with sufficient minimum width and **center alignment**. Making buttons `w-full` on PC causing visual stretching is prohibited.
    *   **Affordance**: Apply shadows (`shadow-md`) and hover effects to convey "clickability".
