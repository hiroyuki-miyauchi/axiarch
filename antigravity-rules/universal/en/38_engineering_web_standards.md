# 38. Web Standards (HTML/CSS/PHP)

## 1. HTML & CSS (The Foundation)
*   **Semantic HTML**:
    *   Prohibit "div soup". Use `header`, `main`, `footer`, `article`, `section` appropriately to maximize SEO and Accessibility.
*   **CSS Architecture**:
    *   **BEM (Block Element Modifier)**: For non-Tailwind projects (e.g., WordPress themes), strictly adhere to **BEM** naming conventions to avoid style conflicts and specificity hell.
    *   **SASS/SCSS**: Use nesting, variables, and Mixins for maintainable stylesheets.
*   **Responsive**:
    *   **Mobile First**: Always write CSS for mobile first as the default, and expand for desktop using `min-width` media queries.

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
