# 11. Business, Finance & Monetization Strategy
## 7. Promotion & Pricing Strategy

### 7.1. The Coupon Integrity Protocol
*   **Law**: Coupon and discount application logic MUST be **strictly validated on the server side**. Applying discounts on the frontend only is prohibited due to tampering risks.
*   **Action**:
    1.  **Server-Side Validation**: Validate coupon code validity (expiration, usage count, eligibility conditions) on the server side.
    2.  **Idempotency**: Manage usage history in the DB with Unique Constraints to prevent duplicate application of the same coupon.
    3.  **Audit Trail**: Record coupon usage history in audit logs to enable fraud tracking.
    4.  **Budget Guard**: Manage total coupon budgets (usage limits, total discount caps) in the DB and automatically deactivate upon budget exhaustion.
    5.  **Per-User Limit**: Set per-user usage limits (`max_uses_per_user`) to prevent multiple fraudulent redemptions. For multi-account prevention, combine with SMS verification, device fingerprinting, etc.
    6.  **Immutable Redemption History**: Coupon redemption history (`coupon_redemptions`) MUST be recorded after payment confirmation (e.g., after Webhook receipt), and **any modification or deletion is strictly prohibited**. Retain permanently as an audit trail.

### 7.2. The Dynamic Pricing Protocol
*   **Law**: Price and subscription plan changes MUST be designed to be **immediately reflected from the admin panel without code deployment** as the standard.
*   **Action**:
    1.  **Price as Data**: Manage pricing information in DB tables (e.g., `plans`, `prices`); hardcoding in source code is prohibited.
    2.  **Version Control**: Create new records for price changes, managing validity periods with `valid_from` / `valid_until`. Consider grandfathering design so existing user contracts are not affected by changes.
    3.  **Display Sync**: Design cache invalidation strategies to ensure price changes are immediately reflected on the frontend (LPs, pricing pages, etc.).
    4.  **Server-Side Recalculation**: Final price and discount calculations MUST be **re-executed on the server side**. Frontend display prices are merely "reference prices"; recalculating on the server side during payment processing eliminates frontend tampering risks.
