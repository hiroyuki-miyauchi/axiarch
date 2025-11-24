# 38. Web Standards (HTML/CSS/PHP)

## 1. HTML & CSS (The Foundation)
*   **Semantic HTML**:
    *   "Div soup" is prohibited. Use `header`, `main`, `footer`, `article`, `section` appropriately to maximize SEO and accessibility.

### 1.1. Advanced CSS Architecture
*   **Strict BEM (Block Element Modifier)**:
    *   **Naming**: Strictly adhere to `Block__Element--Modifier`.
    *   **No Grandchildren**: `Block__Element__Grandchild` is prohibited. If the structure gets deep, break it out as a new Block (maintain flat structure).
    *   **State Management**: Use state classes like `is-active`, `has-error` in conjunction with BEM (e.g., `Button--primary.is-active`).
*   **SASS/SCSS Optimization**:
    *   **Nesting Limit**: Limit nesting to **maximum 3 levels**. Deep nesting creates specificity wars and degrades maintainability.
    *   **No Ampersand Abuse**: Combining class names with `&` (e.g., `&__element`) is discouraged as it hurts searchability. Write full names.
*   **Modern Layout**:
    *   **Container Queries**: Prioritize Container Queries (`@container`) over Media Queries (`@media`) to improve component reusability.

### 1.2. CSS Performance (Rendering Performance)
*   **Rendering Optimization**:
    *   **Containment**: Use `contain: content` for complex widgets to isolate browser recalculation scope.
    *   **Will-Change**: Use `will-change` for animated elements but apply it only when necessary to prevent memory consumption.
    *   **GPU Acceleration**: Use only `transform` and `opacity` for animations. Prohibit animating properties that trigger Reflow like `top`, `left`, `width`.
    *   **CSS Variables**: Prioritize CSS Variables over SASS variables for theming and runtime performance.
    *   **Content Visibility**: Use `content-visibility: auto` for long lists (infinite scroll) to reduce off-screen rendering costs.
    *   **Touch Action**: Explicitly set `touch-action: manipulation` on interactive elements to improve scroll performance on mobile.
*   **Responsive**:
    *   **Mobile First**: Always write mobile styles as default and extend for desktop using `min-width` media queries.

## 2. JavaScript (Vanilla & ES6+)
*   **Modern Standards**:
    *   jQuery is prohibited in principle (except for legacy refactoring). Use standard APIs like `querySelector`, `fetch`, `ES Modules` for lightweight and fast code.
    *   **Async**: Avoid callback hell and use `async/await` for readability.
*   **Performance**:
    *   **Minimize DOM Access**: DOM access is costly. Cache in variables or use `DocumentFragment` to minimize Reflow/Repaint.

## 3. PHP (Modern PHP)
*   **PSR Standards**:
    *   **PSR-12**: Strictly adhere to PSR-12 coding style.
    *   **Type Hinting**: Always specify types for arguments and return values to increase robustness (PHP 7.4/8.0+).
*   **Security**:
    *   **XSS Prevention**: Always escape output (`htmlspecialchars`).
    *   **SQL Injection Prevention**: Never write raw SQL; always use PDO prepared statements or ORM.
