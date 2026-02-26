# 30. Engineering Excellence (General)

### 12.1. The Zero-Warning Lint Protocol
*   **Law**: "It works with warnings" is a compromise that leads to quality decay. CI All Green means Zero Warnings.
*   **Action**: `npm run lint` must return **Zero Warnings**. Delete unused variables immediately.

### 12.2. The Clean Import Protocol
*   **Law**: `import` statements must be at the **Top-Level** of the file.
*   **Action**: Imports inside functions or control flows are strictly prohibited. Move them to the top immediately.

### 12.3. The Explicit Explanation Protocol (Zero Jargon)
*   **Law**: Developer "common sense" is user "jargon".
*   **Action**: Always attach a `Tooltip` to technical terms and metrics on the admin panel, explaining "what it is and how it affects business" in layperson terms.

### 12.4. Localization First Protocol
*   **Law**: English error messages cause user churn.
*   **Action**: Localize all error messages and validation messages (including Zod custom errors) into the **Project Native Language** defined in `GEMINI.md`.

### 12.5. The Recursive Logic Ban (Infinite Recursion Shield)
*   **Law**: Deep recursion with unclear termination in component trees or business logic is prohibited.
*   **Reason**: Causes Stack Overflow and infinite DB reads (when combined with useEffect), leading to cloud bankruptcy.
*   **Action**: Always define a **MAX_DEPTH** constant (e.g., 5) for recursive structures. Throw exception or normalize data if exceeded.

# 30. Engineering Excellence (General)
