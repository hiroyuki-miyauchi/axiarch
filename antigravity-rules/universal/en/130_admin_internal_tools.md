# 130. Admin Operations & Internal Tools

## 1. Build vs Buy Strategy ("Retool First")
*   **Retool First Policy**:
    *   **Rule**: **Strictly prohibit scratch development (React/Flutter)** for Admin Panels, CS Tools, and Operation Dashboards.
    *   **Solution**: Use **Retool** as the first choice to reduce build time from "weeks" to "hours". Focus engineering resources on the Core Product for users.
    *   **Exception**: Scratch development is allowed only if the dashboard is directly used by customers (End Users) or requires advanced UI/UX impossible with Retool.

## 2. Admin Dashboard Requirements
*   **KPI Monitoring**:
    *   Must place widgets to display key KPIs (MRR, DAU, Churn Rate, New Signups) in real-time.
    *   Maintain a state where "Current Business Status" is visible at a glance.
*   **User Management**:
    *   **Search & Filter**: Implement instant search/filter for users by ID, Email, Status, and Plan.
    *   **Audit Trail**: Record all admin actions (User Deletion, Refund, Status Change) as logs to track who did what and when.
*   **Impersonation (Masquerade)**:
    *   Implement a feature for admins to log in as a specific user to see the same screen for CS support.
    *   **Security**: Restrict this to Super Admins only and always log usage.

## 3. Operational Workflow
*   **Approval Flows**:
    *   Must incorporate "Approval Flows (Double Check)" for irreversible or high-risk actions like Refunds, Physical Data Deletion, or Mass Notifications. Use Retool's workflow features.
*   **Alerting Integration**:
    *   Build integration to instantly notify Slack/Email in case of System Errors (spike in 5xx) or Abnormal KPI changes (spike in Churn).
    *   Create a mechanism to notice abnormalities without actively checking the dashboard.
