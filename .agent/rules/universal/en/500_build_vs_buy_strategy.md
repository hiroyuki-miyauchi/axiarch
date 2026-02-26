# 50. Admin Operations & Internal Tools
## 1. Build vs Buy Strategy ("Retool First")
*   **Retool First Policy**:
    *   **Rule**: Building Admin Panels and CS Dashboards from scratch (React/Flutter) is **generally prohibited**.
    *   **Solution**: Use **Retool** as the first choice to cut dev time from weeks to hours. Focus engineering resources on Core Products.
    *   **Exception**: Scratch development is allowed only for client-facing dashboards or complex UI/UX not possible in Retool.

## 2. Admin Dashboard Requirements
*   **Mobile First Admin**:
    *   **Emergency**: Admins may handle bans or refunds on the go. Admin panels must be mobile-friendly.
*   **KPI Monitoring**:
    *   Always display real-time widgets for KPI (MRR, DAU, Churn).
*   **UI/UX Standards**:
    *   **Modal Visibility**: Use **80vw+** for main task modals (e.g., Media Picker). Small modals kill productivity.
    *   **Action Feedback**: Use "Toast" + "Button Green/Text Change" for clear feedback. Zero ambiguity.
    *   **Copyright Automation**: Auto-update copyright year `[Start]–[Current]`. No Manual updates.
    *   **The Code Input Standard (Mandatory Code Editor)**:
        *   **Law**: Editing code (HTML/CSS/JS/Config) in raw `textarea` lacks syntax highlighting, invites input errors, and severely degrades site quality—strictly prohibited.
        *   **Action**: MUST use editor components like `react-simple-code-editor` (+ `prismjs`) for code input fields (HTML/CSS/Config etc.).
    *   **The CSS Containment Protocol (Admin Layout Protection)**:
        *   **Law**: Prevent "Whitespace Glitch" where accordion expansion etc. in admin screens disrupts parent container scroll calculation causing huge whitespace.
        *   **Action**: Main containers in admin screens with `overflow-y-auto` should generally have `style={{ contain: 'layout' }}` to isolate child element layout changes.
*   **Information Density Strategy**:
    *   **Card Strategy**: Use white cards (`bg-white shadow-sm`) for content areas, separated from background (`bg-muted/40`).
    *   **Action Placement**: Place primary actions like "Save" at the top right of the header.
    *   **Layman Accessibility**: Avoid technical jargon like "Slug", "UUID". Use plain words like "URL Identifier". Tooltips are mandatory for all inputs.
    *   **Visual Theme Editor**: Implement a Theme Editor in "Site Settings" to allow intuitive design changes with real-time preview.
*   **User Management**:
    *   **Search & Filter**: Instant filtering by ID, Email, Status, Plan.
    *   **Audit Trail**: Log all admin actions (Delete, Refund, Status Change).
*   **Impersonation**:
    *   Allow Admins to log in as users for support. Strict permissions and logging required.

## 3. Content Management Strategy
*   **No Raw HTML**:
    *   **Principle**: Admins strictly prohibited from editing Raw HTML. Prevents XSS and design breakage.
    *   **Block Editor**: Use **Tiptap** or Headless CMS.
    *   **Structured Data**: Store content as JSON, not HTML strings.
*   **Custom Fields**:
    *   Use dedicated fields for Video IDs or Maps instead of iframe pasting.

## 4. Operational Workflow
*   **Approval Flows**:
    *   Require double-check/approval for high-risk actions (Refunds, Physical Delete).
*   **Alerting Integration**:
    *   Notify Slack/Email immediately on System Errors (5xx spike) or Biz Anomalies (Churn spike).

## 5. Data Import & Export
*   **Bulk Operations**:
    *   **Async**: CSV exports/updates >1000 rows must be background jobs.
    *   **Validation**: Always show a "Preview" with error validation before committing to DB.

## 6. Support & FAQ
*   **SLA**:
    *   **Response**: Instant auto-reply, 24h human response target.
*   **FAQ Management**:
    *   Move frequent queries to FAQ immediately. Managed by CS (Notion/Zendesk), not engineers.
*   **Chat Support**:
    *   Use Intercom/Zendesk with AI bots for first response.

## 7. Security & Access Control
*   **RBAC**:
    *   Role-Based access (Super Admin, Support, Analyst). Least privilege.
*   **IP Restriction**:
    *   Restrict Admin access to VPN or specific IPs.
