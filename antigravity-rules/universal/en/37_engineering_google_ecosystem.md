# 37. Engineering: Google Ecosystem & Critical Flows

## 1. Philosophy: "Google First" & Continuous Evolution
### 1.1. Google First Strategy
*   **Default Choice**: Prioritize the **Google Ecosystem** (Firebase, GCP, Android, Flutter, Maps, AI) in technology selection.
    *   **Reason**: To achieve seamless integration, world-class scalability, and unified billing/management.
    *   **Exception Policy**: Adopt third-party tools (RevenueCat, Auth0, etc.) ONLY when they offer **overwhelming** advantages (cross-platform UX, stability, developer experience) compared to Google native products.

### 1.2. Continuous Trend Analysis
*   **Obligation**: Engineers are obligated to constantly monitor the latest trends (Firebase IAP extensions, new GCP AI models, etc.).
*   **Review**: If Google native solutions evolve and catch up with the quality of third-party tools, **revert (migrate) to Google native**.

## 2. Google Ecosystem Strategy
### 2.1. Google Maps Platform
*   **Cost Optimization**:
    *   **Prioritize Static Maps**: Use **Maps Static API** for non-interactive views (receipt details, list thumbnails) to significantly reduce costs.
    *   **Lazy Load**: Load map components only when they enter the viewport.
    *   **Session Billing**: Always use session tokens for **Places Autocomplete** to group queries into a single billable session.
*   **Performance**:
    *   **Vector Maps**: Use Vector Maps (Android/iOS SDK v18+) for smoother rendering and reduced data usage.

### 2.2. Firebase & GCP
*   **Firestore Strategy (NoSQL Optimization)**:
    *   **Flat Data Structure**: Avoid deep nesting. Use **Root Level Collections** (e.g., `posts/{postId}` instead of `users/{uid}/posts`) for scalability.
    *   **Denormalization**: Duplicate (denormalize) data to minimize Read counts. **Optimize for Read performance, not Write storage.**
    *   **App Check**: Mandatory for production apps to block malicious traffic (bots).
*   **Security & Networking**:
    *   **VPC Service Controls**: Define security perimeters around sensitive resources (Cloud Functions, Firestore) using VPC Service Controls for enterprise-grade protection.
    *   **WAF**: Use Google Cloud Armor when exposing custom endpoints.

## 3. Critical Flows
### 3.1. In-App Purchases
*   **Current Standard: RevenueCat**:
    *   **Exception Reason**: Because it is currently overwhelmingly superior to building solely with Google native tools for cross-platform (iOS/Android/Web) entitlement management, receipt validation, and analytics.
    *   **Google Integration**: RevenueCat must be integrated with **Firebase** (via Extensions/Webhooks) to sync subscription status to Firestore.
*   **Server-Side Validation**: Even when using RevenueCat, listen for **Webhooks** on the backend to sync status and safely grant/revoke access rights. **Never trust the client side alone.**

### 3.2. Authentication & Session
*   **Account Deletion**: Implement an **Account Deletion** feature that fully complies with App Store/Play Store guidelines (immediate and placed in an obvious location).

## 4. Data Safety & Integrity
### 4.1. Soft Delete
*   **Rule**: Do not **physically delete** user data immediately (except for explicit "Account Deletion" requests or GDPR compliance).
*   **Implementation**: Use `isDeleted` (boolean) or `deletedAt` (timestamp) fields.

### 4.2. Backups
*   **Auto Backup**: Enable automatic daily backups for Firestore/Cloud SQL.
*   **PITR**: Enable Point-in-Time Recovery (PITR) for critical databases to allow recovery from specific bad deployments.
