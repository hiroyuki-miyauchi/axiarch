# 190. Internal Tools & Operations

## 1. Retool First Strategy
*   **Principle**: In principle, build Admin Panels and internal tools using low-code tools like **Retool** to focus engineer resources on customer-facing products.
*   **Exception**: Consider scratch development with Next.js etc. only when complex unique logic is required or performance is extremely critical, but even then, utilize UI libraries (MUI, Ant Design) to avoid spending design costs.

## 2. RBAC (Role-Based Access Control)
*   **Strict Privilege Separation**:
    *   **Super Admin**: Has full authority. Only CTO and designated responsible persons.
    *   **Support**: Can only view user information. Cannot edit or delete.
    *   **Content Manager**: Can only input and edit content.
*   **Principle of Least Privilege**: Grant only the minimum privileges necessary for the task.

## 3. Audit Logs
*   **Complete Tracking**: Record all operations on the admin screen (Who, When, What, Before/After) as logs. This is mandatory for fraud prevention and troubleshooting.
*   **Immutability**: Store audit logs in a tamper-proof state (e.g., Firestore write-only collection, Cloud Logging).

## 4. Operational Workflow
*   **CS Response**: Design so that inquiries from users can be handled smoothly from the admin screen (e.g., User ID search, Status check, Password reset email transmission).
*   **Manualization**: Document operation procedures in Notion etc. to prevent personalization. Utilize AI (chatbots) to streamline manual searches.
