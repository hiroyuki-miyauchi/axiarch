# 250. Accessibility & Inclusion

## 1. WCAG 2.1 AA Compliance
*   **Legal & Ethical Standards**:
    *   Aim for compliance with Web Content Accessibility Guidelines (WCAG) 2.1 Level AA. This is an ethical obligation to deliver value to all users, not just for legal risk avoidance.
*   **Contrast Ratio**:
    *   Ensure a contrast ratio of at least **4.5:1** between text and background (3:1 for large text). Check from the design stage using Figma plugins (Stark, etc.).

## 2. Assistive Technology
*   **Screen Readers**:
    *   **Semantic HTML**: Use appropriate tags like `button`, `nav`, `main` instead of `div`.
    *   **Alt Text**: Always add `alt` attributes to images (empty string `alt=""` for decorative purposes).
    *   **Native Support**: Test that main operation flows can be completed with iOS VoiceOver and Android TalkBack.
*   **Keyboard Navigation**:
    *   Ensure all interactive elements can be operated with just a keyboard (Tab key) for users who cannot use a mouse or touch panel. Be careful not to remove focus indicators (blue outlines, etc.).

## 3. Inclusive Design
*   **Dark Mode**:
    *   **Dark Mode First**: Implement dark mode that automatically switches according to OS settings. Design a color scheme that is easy on the eyes, not just simple color inversion.
*   **Dynamic Type**:
    *   Implement so that text within the app scales accordingly when the user increases text size in OS settings (prevent layout breakage).
*   **Diversity Consideration**:
    *   Strive for UI/UX that does not exclude users with diverse backgrounds, such as including "Other" or "Prefer not to say" in gender selection.
*   **Color Blindness**:
    *   Do not convey information solely by color (e.g., indicate errors with icons and text, not just red color).
