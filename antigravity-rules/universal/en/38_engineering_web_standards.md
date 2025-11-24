# 38. Web Standards (HTML/CSS/PHP)

## 1. HTML & CSS (The Foundation)
*   **Semantic HTML**:
    *   Prohibit "div soup". Use `header`, `main`, `footer`, `article`, `section` appropriately to maximize SEO and Accessibility.

### 1.1. Advanced CSS Architecture
*   **Strict BEM (Block Element Modifier)**:
    *   **Naming**: Strictly adhere to `Block__Element--Modifier` syntax.
    *   **No Grandchildren**: `Block__Element__Grandchild` is prohibited. If the structure gets deep, break it out into a new Block (Maintain flat structure).
    *   **State Management**: Use state classes like `is-active`, `has-error` combined with BEM (e.g., `Button--primary.is-active`).
*   **SASS/SCSS Optimization**:
    *   **Nesting Limit**: Limit nesting to **Max 3 levels**. Deep nesting causes specificity wars and degrades maintainability.
    *   **Avoid Ampersand Abuse**: Avoid concatenating class names with `&` (e.g., `&__element`) as it hinders searchability. Prefer writing full class names.
*   **Modern Layout**:
    *   **Container Queries**: Prioritize Container Queries (`@container`) over Media Queries (`@media`) to enhance component reusability.

### 1.2. CSS Performance (Rendering)
*   **Rendering Optimization**:
    *   **Containment**: Use `contain: content` for complex widgets to isolate browser layout recalculations.
    *   **Will-Change**: Use `will-change` for animation elements, but apply it sparingly to prevent memory leaks.
    *   **GPU Acceleration**: Use only `transform` and `opacity` for animations. Animating properties that trigger layout changes (Reflow) like `top`, `left`, `width` is prohibited.
    *   **CSS Variables (Custom Properties)**: Prioritize CSS variables over SASS variables for theming and runtime performance.
    *   **Content Visibility**: Use `content-visibility: auto` for long lists (e.g., infinite scroll) to reduce off-screen rendering costs.
    *   **Touch Action**: Explicitly set `touch-action: manipulation` on interactive elements to improve scroll performance on mobile.
*   **Responsive**:
    *   **Mobile First**: CSS must always default to mobile styles and expand to desktop using `min-width` media queries.

## 2. JavaScript (Vanilla & ES6+)
*   **Modern Standards**:
    *   jQuery is prohibited (except for legacy maintenance). Use standard APIs like `querySelector`, `fetch`, `ES Modules` for lightweight and fast code.
    *   **Async**: Avoid callback hell. Use `async/await` for readability.
*   **Performance**:
    *   **Minimize DOM Ops**: DOM access is expensive. Cache variables or use `DocumentFragment` to minimize Reflow/Repaint.

## 3. PHP (Modern PHP)
*   **PSR Standards**:
    *   **PSR-12**: Strictly adhere to PSR-12 coding style.
    *   **Type Declarations**: Always specify types (Type Hinting) for arguments and return values (PHP 7.4/8.0+).
*   **Security**:
    *   **XSS Prevention**: Always escape output (`htmlspecialchars`).
    *   **SQL Injection Prevention**: Never write raw SQL. Always use PDO Prepared Statements or an ORM.
