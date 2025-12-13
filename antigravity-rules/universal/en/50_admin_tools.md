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
*   **UI/UX Standards**:
    *   **Modal Visibility**: Key operational modals like media pickers must use **80% (80vw)** or more of screen width to ensure visibility. Narrow modals reduce work efficiency.
    *   **Action Feedback**: Implement clear feedback for save/update actions using "Toast Notification" plus "Button Greenify + Text Change (Saved!)". Zero the time users wonder "Was it saved?".
    *   **Copyright Automation**: Implement footer copyright year to update automatically in `[Start Year]–[Current Year]` format. Manual updates are abolished.
*   **User Management**:
    *   **Search & Filter**: Implement features to instantly search/filter users by ID, email, status, billing plan.
    *   **Audit Trail**: Record all operations performed by admins (user deletion, refund, status change) as logs to track who did what when.
*   **Impersonation / Masquerade**:
    *   Implement a feature (Impersonation) for admins to login as a specific user and check the same screen for CS support.
    *   **Security**: Restrict this feature to Super Admins only and always log usage.


## 3. Content Management Strategy
*   **No Raw HTML**:
    *   **Principle**: It is **strictly prohibited** for admins to directly write or edit HTML tags in the admin panel. This causes XSS vulnerabilities and destroys design consistency.
    *   **Block Editor**: If article creation features are needed, introduce a Block-based Editor like **Tiptap** or a Headless CMS.
    *   **Structured Data**: Save content as JSON structure, not HTML strings, separating the presentation layer from data.
*   **Custom Fields UI**:
    *   For map or video embedding, do not paste iframe codes. Provide dedicated fields (Address input, YouTube ID input) and safely generate tags on the frontend side.

## 4. Operational Workflow
*   **Approval Flows**:
    *   Always incorporate "Approval Flows (Double Check)" for irreversible or high-risk operations like refund, physical data deletion, notification to all users. Utilize Retool's approval workflows.
*   **Alerting Integration**:
    *   Build integration to instantly notify Slack or Email when system errors (surge in 5xx) or abnormal KPI fluctuations (surge in churn) occur.
    *   Create a mechanism to notice abnormalities without checking the admin screen.

## 5. Data Import & Export
*   **Bulk Operations**:
    *   **Async Processing**: Execute CSV exports or bulk updates exceeding thousands of records as **background jobs** (Cloud Tasks, etc.) to prevent timeouts. Notify via email or notification upon completion.
    *   **Validation**: For import features, always implement a "Preview Screen" to display error rows (type mismatch, missing required fields) and allow correction before execution. Writing directly to DB without review is prohibited.

## 6. Support & FAQ
*   **SLA (Service Level Agreement)**:
    *   **First Response**: React **instantly** (including auto-response) to user inquiries, and aim for first response within **24 hours** even for human support.
*   **FAQ Management**:
    *   Immediately add frequently asked items to FAQ (Help Center) to increase self-resolution rate. Manage FAQ with CMS (Notion or Zendesk Guide) so non-engineers can update.
*   **Chat Support**:
    *   **Intercom / Zendesk**: Introduce in-app chat support to solve user issues in real-time. Utilize AI bots (Fin etc.) to automate first response.

## 7. Security & Access Control
*   **RBAC (Role-Based Access Control)**:
    *   Set permission levels (Super Admin, Support, Analyst) for admins and allow access only to necessary information (Least Privilege).
*   **IP Restriction**:
    *   Allow access to admin screens only via VPN or specific IP addresses to prevent external attacks.
