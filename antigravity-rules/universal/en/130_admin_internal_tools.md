# 130. Admin Operations & Internal Tools

## 1. Build vs Buy Strategy ("Retool First")
*   **Retool First Policy**:
    *   **Rule**: **Scratch development (React/Flutter) is prohibited in principle** for Admin Panels, CS tools, and operation dashboards.
    *   **Solution**: Use **Retool** as the first choice to shorten build time from "weeks" to "hours". Focus engineer resources on core features for users (Core Product).
    *   **Exception**: Scratch development is permitted only when a dashboard is directly used by customers (end users) or when advanced UI/UX impossible with Retool is required.

## 2. Admin Dashboard Requirements
*   **KPI Monitoring**:
    *   Always place widgets that display key KPIs (MRR, DAU, Churn Rate, New Registrations) in real-time.
    *   Maintain a state where "how the business is doing now" can be understood at a glance.
*   **User Management**:
    *   **Search & Filter**: Implement features to instantly search and filter users by ID, email address, status, and billing plan.
    *   **Action Logs / Audit Trail**: Record all operations performed by admins (user deletion, refund processing, status change, etc.) as logs to track who did what and when.
*   **Impersonation / Masquerade**:
    *   Implement a feature (Impersonation) that allows admins to log in as a specific user and check the same screen as the user for CS support.
    *   **Security**: Restrict this feature to admins with the highest level of authority and always log its use.

## 3. Operational Workflow
*   **Approval Flows**:
    *   Incorporate an "Approval Flow (Double Check)" for irreversible or high-risk operations such as refund processing, physical deletion of data, or notification to all users. Leverage Retool's approval workflow features.
*   **Alerting Integration**:
    *   Build an integration to immediately notify Slack or Email when system errors (surge in 5xx errors) or abnormal KPI fluctuations (surge in cancellations) occur.
    *   Create a mechanism to notice abnormalities without looking at the admin screen.

## 4. Support & FAQ
*   **FAQ Management**:
    *   Immediately add items frequently asked by users to the FAQ (Help Center) to increase the self-resolution rate. Manage FAQs with a CMS (Notion or Zendesk Guide) so that non-engineers can update them.
*   **Chat Support**:
    *   **Intercom / Zendesk**: Introduce in-app chat support to solve user issues in real-time. Leverage AI bots (like Fin) to automate initial responses.

## 5. Security & Access Control
*   **RBAC (Role-Based Access Control)**:
    *   Set authority levels (Super Admin, Support, Analyst) for admins as well, allowing access only to necessary information (Principle of Least Privilege).
*   **IP Restriction**:
    *   Allow access to the admin screen only via VPN or from specific IP addresses to prevent external attacks.
