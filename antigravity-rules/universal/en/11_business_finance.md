# 11. Business, Finance & Monetization Strategy

## 1. Unit Economics & Finance
*   **LTV > CAC (The Golden Rule)**:
    *   **Principle**: Always monitor that Customer Lifetime Value (LTV) exceeds Customer Acquisition Cost (CAC). Ideally aim for **LTV / CAC > 3**.
    *   **Measurement**: Make CAC and ROI measurable for each channel in all marketing measures.
*   **Real-time P&L**:
    *   **Visualization**: Acquire not just sales but server costs (COGS) and ad expenses (CAC) via API to visualize an estimated daily P&L (Profit and Loss statement).
    *   **Unit Contribution Margin**: Always monitor that the Unit Contribution Margin per transaction is positive.
*   **FinOps (Cost Management)**:
    *   **Budget Alerts**: Must set Budget Alerts for AWS/GCP/Firebase to prevent cloud bankruptcy.
    *   **Cost Allocation**: Clarify costs per feature/team using tagging.
    *   **Spend Cap Protocol**: Enable "Spend Cap" in Phase 1 (Dev/Launch) to prevent cloud bankruptcy. Only disable in Phase 2 (Growth).
    *   **Zombie Resource Elimination**: Regularly run scripts to delete unused dev environments and old backups.

## 2. Monetization Models
*   **Subscription**:
    *   **SKU Design**: Limit plans to 3 (e.g., Free, Pro, Business) to prevent Decision Paralysis.
    *   **Annual Plans**: Offer clear discounts (e.g., 2 months free) for annual plans to improve cash flow.
*   **Freemium**:
    *   **Aha! Moment**: Let users experience for free until the moment they realize value.
    *   **Paywall**: On the payment screen, visually appeal to the benefits and clearly state "Cancel anytime" to remove anxiety.
*   **E-Commerce**:
    *   **Cart Abandonment**: Allow guest purchases and eliminate forced membership registration.
    *   **1-Click Payment**: Introduce Apple Pay / Google Pay to minimize input effort to the limit.
*   **Feature Gating Strategy (Tier Restrictions)**:
    *   **Quota Enforcement**: Strictly enforce "Registration Limits (Max N)" or "Feature Restrictions (Vision AI Count)" on the server side (Guard/Policies), not just the frontend.
    *   **Upsell Trigger**: Hook into limit excess events (`LimitExceeded`) and treat them as opportunities to display clear Upsell UIs for higher tiers, rather than just showing errors.

## 3. Payment & Compliance
*   **Payment Gateway Strategy**:
    *   **Stripe First**: From the perspective of developer experience and scalability, strictly use **Stripe** as the first choice.
    *   **Vendor Agnostic**: However, abstract business logic using `PaymentProvider` interface to hedge risks of total vendor lock-in.
*   **Security Pillars (The 19 Pillars of Trust)**:
    *   **NO RAW CARD DATA (PCI-DSS Avoidance)**: Raw credit card data (PAN/CVV) must NEVER be stored or passed through our servers. Strictly enforce tokenization via Stripe.js/Checkout.
    *   **Idempotency & State Consistency**: Prevent double payments via `Idempotency-Key` and ensure state consistency via Webhooks.
    *   **Anti-Fraud**: Utilize Stripe Radar to automatically block fraudulent usage (Credit Master Attacks).
    *   **Auditability**: Completely record logs of operations like amount changes or permission grants.
*   **Hybrid Architecture Strategy**:
    *   **Dual API Integration**: Use `Stripe Billing` for subscriptions and `Stripe Checkout` for one-time payments.
    *   **Metadata-Driven Tiering**: Use metadata like `is_enterprise: "true"` for plan determination. Hardcoding IDs in code is prohibited.
    *   **Native Access Privilege**: Grant Tier 2 (Enterprise) equivalent access to users accessing from the official Native App regardless of Stripe status.
*   **Admin FinOps**:
    *   Implement a dashboard where finance staff can check "Daily Sales", "Instant Refunds", and "Force Plan Overrides".
    *   **Universal Webhook**: Receive Webhooks at a single endpoint and route by event via Async Queue.
*   **Tax**:
    *   **Global Tax Compliance**: Automatically apply the appropriate tax rate (VAT/GST/Consumption Tax) based on the user's country of residence (Stripe Tax recommended).
    *   **Invoice System**: Automatically issue receipts in a format fully compliant with **local invoice systems** (e.g., EU VAT, Japan's Qualified Invoice System).
*   **Legal Notation**:
    *   **Specific Commercial Transactions**: Based on **applicable local laws** (e.g., Tokusho-ho in Japan), correct disclosure of operator info, return policies, etc. is mandatory.
    *   **Payment Services Act**: Be cautious when issuing prepaid payment instruments (points) and only do so if compliant with regulations. Principles dictate using Apple/Google IAP.

## 4. Point Economy System
*   **Ledger Architecture**:
    *   **Immutable Ledger**: Direct updates to point balances (`UPDATE`) are strictly prohibited. All changes must be recorded as `INSERT` (Credit/Debit) into `point_transactions`, calculating balances via aggregation.
*   **Security & Fraud Prevention**:
    *   **Idempotency**: Client-generated UUIDs (`Idempotency-Key`) are mandatory for point grants/consumption to prevent double counting.
    *   **Security-Tiered Allocation**: Vary allocation amounts based on user authentication strength to encourage MFA.
        *   **Tier 1 (Email)**: 1 pt (Minimal / Anti-spam)
        *   **Tier 2 (Google Auth)**: 3 pts (Standard / Bot Verified)
        *   **Tier 3 (MFA/Passkey)**: 5 pts (Premium / High Trust)

## 5. Ad Management Strategy
*   **Independent Architecture**:
    *   **Separation**: Manage ad data (`ads`) and images completely separately from the standard media library (`media_items`) due to differing lifecycles and visibility scopes.
*   **Dynamic Injection**:
    *   **No Hardcoding**: Hardcoding ad banner URLs or links in code is permanently prohibited. Ensure control via the admin panel (`/admin/ads`).
*   **Placement Strategy**:
    *   **Unified System**: Manage ad locations via `location` IDs (e.g., `sidebar_top`). The frontend specifies the location, and the system delivers the appropriate ad.

## 6. AI Token Economics
*   **Profitability Guardrails**:
    *   **The 30% Rule**: Keep AI token costs under **30%** of subscription revenue. Apply hard limits if exceeded.
    *   **Model Tiering**: Do not use highest-spec models (e.g., GPT-4) for everything. Switch to lightweight models (Flash/Mini) based on task complexity.
    *   **Circuit Breaker**: Implement a safety mechanism to auto-stop AI features upon sudden cost spikes (e.g., exceeding budget in 1 hour).
