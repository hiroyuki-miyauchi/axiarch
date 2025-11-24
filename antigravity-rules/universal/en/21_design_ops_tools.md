# 21. Design Ops & Tools

## 1. Design System
*   **Single Source of Truth**:
    *   **Figma**: The design system on Figma (Styles, Variables, Components) is the only source of truth. Code (Tailwind Config) is always subordinate to Figma.
*   **Design Tokens**:
    *   All colors, font sizes, and spacing are defined as "Tokens". Hardcoding values like `#FF0000` is prohibited. Use meaningful names like `primary-500`.

## 2. Tool Usage Protocol
*   **Figma (UI/UX)**:
    *   **Dev Mode**: Engineers must use Figma's **Dev Mode** to check properties. Implementation by "eyeballing" is strictly prohibited.
    *   **Auto Layout**: Designers must use **Auto Layout** for all components to communicate responsive behavior to engineers.
*   **Adobe Creative Cloud (High-Fidelity Assets)**:
    *   **Photoshop / Illustrator**: Use Adobe tools for logos, complex graphics, and photo retouching.
    *   **Integration**: Export created assets as SVG or high-resolution PNG/WebP and place them in Figma for management.
*   **Canva (Marketing Speed)**:
    *   **Speed for Non-Core Tasks**: Actively use **Canva** for "Non-Product UI" such as OGP, SNS posts, and internal documents.
    *   **Templatization**: Register the Brand Kit (Logo, Fonts, Colors) in Canva so anyone can instantly create creatives aligned with brand guidelines.

## 3. Hand-off
*   **Defined Status**:
    *   Clearly mark the status of each frame in Figma: "Draft", "Ready for Dev", "Shipped".
*   **Asset Export**:
    *   Export images as **WebP** or **SVG** by default. Do not use PNG/JPG unless there is a specific reason.
