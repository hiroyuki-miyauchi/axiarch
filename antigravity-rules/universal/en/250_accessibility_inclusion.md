# 250. Accessibility & Inclusion

## 1. WCAG 2.1 AA Compliance
*   **Legal & Ethical Standard**:
    *   Aim for compliance with Web Content Accessibility Guidelines (WCAG) 2.1 Level AA. This is an ethical obligation to deliver value to all users, not just a way to avoid legal risk.
*   **Contrast Ratio**:
    *   Ensure a contrast ratio of at least **4.5:1** for text and background (3:1 for large text). Check this from the design stage using Figma plugins (e.g., Stark).

## 2. Assistive Technology
*   **Screen Readers**:
    *   **Semantic HTML**: Use appropriate tags like `button`, `nav`, `main` instead of `div`.
    *   **Alt Text**: Always provide `alt` attributes for images (use empty `alt=""` for decorative images).
    *   **Native Support**: Test that key user flows can be completed using iOS VoiceOver and Android TalkBack.
*   **Keyboard Navigation**:
    *   Ensure all interactive elements can be operated using only the keyboard (Tab key) for users who cannot use a mouse or touch panel. Be careful not to remove focus indicators (e.g., blue outlines).

## 3. Inclusive Design
*   **Dark Mode**:
    *   **Dark Mode First**: Implement dark mode that automatically switches based on OS settings. Design a color scheme that is easy on the eyes, not just a simple color inversion.
*   **Dynamic Type**:
    *   Implement the app so that text scales accordingly when users increase font size in OS settings (prevent layout breakage).
*   **Diversity**:
    *   Strive for UI/UX that does not exclude users with diverse backgrounds, such as including "Other" or "Prefer not to say" in gender selection.
