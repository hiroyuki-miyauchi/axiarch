# 21. Design Ops & Tools

## 1. Design System
*   **Single Source of Truth**:
    *   **Figma**: The design system in Figma (Styles, Variables, Components) is the absolute source of truth. Code (Tailwind Config) must always follow Figma.
*   **Design Tokens**:
    *   Define colors, font sizes, and spacing as "Tokens". Hardcoding values like `#FF0000` is prohibited. Use semantic names like `primary-500`.

## 2. Tool Usage Protocol
*   **Figma (UI/UX)**:
    *   **Dev Mode**: Developers must use **Dev Mode** in Figma to inspect properties. Guesswork implementation is strictly prohibited.
    *   **Auto Layout**: Designers must use **Auto Layout** for all components to communicate responsive behavior to engineers.
*   **Adobe Creative Cloud (High-Fidelity Assets)**:
    *   **Photoshop / Illustrator**: Use Adobe tools for logos, complex graphics, and photo retouching.
    *   **Integration**: Export created assets as SVG or high-res PNG/WebP and place them in Figma for management.
*   **Canva (Marketing Speed)**:
    *   **Speed for Non-Core**: Actively use **Canva** for "Non-Product UI" such as OGP, SNS posts, and internal docs.
    *   **Templating**: Register the Brand Kit (Logos, Fonts, Colors) in Canva to allow anyone to instantly create on-brand creatives.

## 3. Hand-off
*   **Status Definition**:
    *   Clearly mark the status of each frame in Figma: "Draft", "Ready for Dev", "Shipped".
*   **Asset Export**:
    *   Export images as **WebP** or **SVG** by default. Do not use PNG/JPG unless there is a specific reason.
