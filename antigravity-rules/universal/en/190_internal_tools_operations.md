# 190. Internal Tools & Operations

## 1. Retool First Strategy
*   **Principle**: To focus engineering resources on customer-facing products, internal Admin Panels and tools should generally be built using low-code tools like **Retool**.
*   **Exception**: Only consider scratch development (e.g., Next.js) if complex custom logic is required or performance is critical. Even then, use UI libraries (MUI, Ant Design) to minimize design costs.

## 2. Role-Based Access Control (RBAC)
*   **Strict Separation**:
    *   **Super Admin**: Full access. Restricted to the CTO and designated responsible persons only.
    *   **Support**: Read-only access to user information. No edit/delete permissions.
    *   **Content Manager**: Can only input and edit content.
*   **Principle of Least Privilege**: Grant only the minimum permissions necessary for the job.

## 3. Audit Logs
*   **Full Traceability**: Record all actions in the Admin Panel (Who, When, What, Before/After) as logs. This is mandatory for fraud prevention and troubleshooting.
*   **Immutability**: Store audit logs in a tamper-proof state (e.g., Firestore write-only collections, Cloud Logging).

## 4. Operational Workflow
*   **CS Support**: Design the Admin Panel to facilitate smooth customer support (e.g., User ID search, status check, password reset email trigger).
*   **Documentation**: Document operational procedures in Notion to prevent knowledge silos. Use AI (Chatbots) to make manual searching efficient.
