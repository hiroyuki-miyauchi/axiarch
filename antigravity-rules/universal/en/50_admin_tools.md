# 50. Admin Operations & Internal Tools

## 1. Build vs Buy Strategy - "Retool First"
*   **Retool First Policy**:
    *   **Rule**: **Scratch development (React/Flutter) is prohibited in principle** for Admin Panels, CS tools, and Operation Dashboards.
    *   **Solution**: Make **Retool** the first choice, reducing build time from "weeks" to "hours". Focus engineer resources on Core Product for users.
    *   **Exception**: Scratch development is allowed only for dashboards directly used by customers (end users) or when advanced UI/UX impossible with Retool is required.

## 2. Admin Dashboard Requirements
*   **Mobile First Admin**:
    *   **Emergency Response**: Admins may perform emergency responses (User BAN, Refund Approval) while out or moving. Guarantee **mobile operability** even for admin screens.
*   **KPI Monitoring**:
    *   Always place widgets displaying key KPIs (MRR, DAU, Churn Rate, New Signups) in real-time.
    *   Maintain a state where "How the business is doing now" is visible at a glance.
*   **User Management**:
    *   **Search & Filter**: Implement features to instantly search/filter users by ID, email, status, billing plan.
    *   **Audit Trail**: Record all operations performed by admins (user deletion, refund, status change) as logs to track who did what when.
*   **Impersonation / Masquerade**:
    *   Implement a feature (Impersonation) for admins to login as a specific user and check the same screen for CS support.
    *   **Security**: Restrict this feature to Super Admins only and always log usage.

## 3. Operational Workflow
*   **Approval Flows**:
    *   Always incorporate "Approval Flows (Double Check)" for irreversible or high-risk operations like refund, physical data deletion, notification to all users. Utilize Retool's approval workflows.
*   **Alerting Integration**:
    *   Build integration to instantly notify Slack or Email when system errors (surge in 5xx) or abnormal KPI fluctuations (surge in churn) occur.
    *   Create a mechanism to notice abnormalities without checking the admin screen.

## 4. Support & FAQ
*   **SLA (Service Level Agreement)**:
    *   **First Response**: React **instantly** (including auto-response) to user inquiries, and aim for first response within **24 hours** even for human support.
*   **FAQ Management**:
    *   Immediately add frequently asked items to FAQ (Help Center) to increase self-resolution rate. Manage FAQ with CMS (Notion or Zendesk Guide) so non-engineers can update.
*   **Chat Support**:
    *   **Intercom / Zendesk**: Introduce in-app chat support to solve user issues in real-time. Utilize AI bots (Fin etc.) to automate first response.

## 5. Security & Access Control
*   **RBAC (Role-Based Access Control)**:
    *   Set permission levels (Super Admin, Support, Analyst) for admins and allow access only to necessary information (Least Privilege).
*   **IP Restriction**:
    *   Allow access to admin screens only via VPN or specific IP addresses to prevent external attacks.
