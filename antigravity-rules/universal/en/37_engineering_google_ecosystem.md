# 37. Engineering: Google Ecosystem & Critical Flows

## 1. Philosophy: "Google First" & Continuous Evolution

### 1.1. Google First Strategy
*   **Default Choice**: We prioritize **Google's ecosystem** (Firebase, GCP, Android, Flutter, Maps, AI) for all technology selections.
    *   **Why**: Seamless integration, world-class scalability, and unified billing/management.
    *   **Exception Policy**: Third-party tools (e.g., RevenueCat, Auth0) are only chosen if they offer **overwhelming** advantages in Cross-Platform UX, Stability, or Developer Experience that Google's native equivalents cannot currently match.

### 1.2. Continuous Trend Analysis
*   **Mandate**: Engineers must continuously monitor the latest trends (e.g., Firebase IAP extensions, new GCP AI models).
*   **Pruning**: If a Google native solution evolves to match a third-party tool's quality, we **migrate back to Google**.
*   **Priority**: **Security > Performance > UX > Cost > Trend**. Never adopt a trend if it compromises security or user experience.

## 2. Google Ecosystem Strategy

### 2.1. Google Maps Platform
*   **Cost Optimization**:
    *   **Static Maps First**: Use **Maps Static API** for non-interactive views (e.g., receipt details, list thumbnails) to significantly reduce costs.
    *   **Lazy Loading**: Load map components only when they enter the viewport.
    *   **Session Billing**: Always use Session Tokens for **Places Autocomplete** to group queries into a single billable session.
*   **Performance**:
    *   **Vector Maps**: Use Vector Maps (Android/iOS SDK v18+) for smoother rendering and lower data usage.
    *   **Lightweight Markers**: Use simple PNGs or optimized vector drawables for markers. Avoid complex SVG rendering on the fly.

### 2.2. Firebase & GCP
*   **Firestore Strategy (NoSQL Optimization)**:
    *   **Flat Data Structure**: Avoid deep nesting. Use **Root-Level Collections** (e.g., `users/{uid}/posts` -> `posts/{postId}`) for scalability.
    *   **Denormalization**: Duplicate data (e.g., `authorName` in `posts`) to minimize Reads. **Optimize for Read Performance**, not Write Storage.
    *   **App Check**: Mandatory for all production apps to block abusive traffic (bots).
*   **Security & Networking**:
    *   **VPC Service Controls**: Use VPC Service Controls to define security perimeters around sensitive resources (Cloud Functions, Firestore) for enterprise-grade protection.
    *   **WAF**: Use Google Cloud Armor if exposing custom endpoints.
*   **Auth**: Use **Firebase Authentication** as the core identity provider.
    *   **MFA**: Mandatory Multi-Factor Authentication for Admin and High-Privilege accounts.
    *   **Social Login**: Support Google and Apple Sign-In as standard.
*   **Cloud Functions**: Use **Gen 2** functions for better concurrency and performance.
*   **AI Integration**: Use **Vertex AI** (Gemini API) via Firebase Extensions or secure backend calls. Never expose API keys in the client.

## 3. Critical Flows (Billing & Auth)

### 3.1. Billing (In-App Purchases)
*   **Current Standard: RevenueCat**
    *   **Why Exception?**: While Google Play Billing is excellent for Android, **RevenueCat** provides superior cross-platform (iOS/Android/Web) entitlement management, receipt validation, and analytics out-of-the-box. Building this securely on raw Firebase requires significant maintenance.
    *   **Google Integration**: RevenueCat must be integrated with **Firebase** (via Extensions/Webhooks) to sync subscription status to Firestore.
    *   **Review Trigger**: Re-evaluate this choice annually. If Firebase releases a comparable "Cross-Platform IAP" extension, plan a migration.
*   **Server-Side Validation**: Even with RevenueCat, listen to **Webhooks** on your backend to sync status and grant/revoke access securely. **Never trust the client side alone.**

### 3.2. Authentication & Session
*   **Token Management**: Handle ID Token refreshes automatically.
*   **Error Handling**: Gracefully handle network failures during auth flows. Provide clear, localized error messages (not "Error 400").
*   **Account Deletion**: Implement **Delete Account** functionality fully compliant with App Store/Play Store guidelines (immediate and visible).

## 4. Data Safety & Integrity

### 4.1. Soft Delete (Logical Deletion)
*   **Rule**: **Never physically delete user data** immediately (except for explicit "Delete Account" requests or GDPR compliance).
*   **Implementation**:
    *   **Flagging**: Use an `isDeleted` (boolean) or `deletedAt` (timestamp) field.
    *   **Archiving**: For complex data, move deleted documents to a `deleted_collections` or `archive` path via Cloud Functions triggers.
*   **Recovery**: Provide a "Trash" or "Restore" capability for admins to recover accidentally deleted data.

### 4.2. Backups
*   **Automated Backups**: Enable automated daily backups for Firestore/Cloud SQL.
*   **Point-in-Time Recovery (PITR)**: Enable PITR for critical databases to recover from specific bad deployments.

## 5. Admin Panel Strategy

### 5.1. Technology Choice
*   **Preference**: **Flutter Web** (if sharing code with app) or **Retool/Low-Code** (for speed).
*   **Separation**: The Admin Panel must be a separate project/deployment from the main user app to isolate risks.

### 5.2. Security (RBAC)
*   **Role-Based Access Control**: Implement strict RBAC (Super Admin, Support, Content Editor).
*   **Read-Only Default**: Default permissions should be Read-Only. Write access is granted explicitly.
*   **Audit Logs**: Log **EVERY** write action in the Admin Panel (Who, What, When) to an immutable audit log collection.
