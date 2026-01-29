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
    *   **Cost Visualization Dashboard**: Visualize "estimated cost ($)", "tokens consumed per feature" daily in admin panel for fact-based cost management.
    *   **Spend Cap Protocol**: Enable "Spend Cap" in Phase 1 (Dev/Launch) to prevent cloud bankruptcy. Only disable in Phase 2 (Growth).
    *   **Cloud Bankruptcy Prevention (Infinite Loop Countermeasure)**:
        *   **Infinite Loop Ban**: "Infinite DB reads" from `useEffect` or recursion can generate millions of requests in minutes causing bankruptcy—mandate strict loop condition review and dev environment limits.
        *   **Cache Invalidation Storm**: Prohibit implementations that spam cache invalidation (Revalidation) in loops due to explosive API call increase.
    *   **Zombie Resource Elimination**: Regularly run scripts to delete unused dev environments and old backups.
    *   **Preview Cleanup Protocol**: Auto-delete Preview environments (branch DBs etc.) via CI/CD after PR merge to prevent "migration ghosts".
*   **Vendor Lock Avoidance (Exit Strategy)**:
    *   **Portable Schema**: Write DB schema, RLS policies, Triggers in standard SQL (`.sql`), minimizing vendor-specific feature dependency.
    *   **No Proprietary Lock-in**: Avoid vendor-proprietary storage/KV features; use S3/Redis compatible interfaces.
    *   **Domain Sovereignty**: Keep domain NS (nameserver) management authority yourself in independent management account (Cloudflare etc.), not delegated to hosting provider.
*   **The Domain Auto-Renewal Mandate (Suicide Prevention)**:
    *   **Risk**: Domain loss (Drop Catch) due to credit card expiration means instant business death.
    *   **Action**: Always enable **Auto-Renewal** at domain registrar, register 2+ credit cards with different expiration dates or maintain prepaid balance.

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
*   **The Payment Fail-Safe Protocol (Payment Failure Recovery)**:
    *   **Law**: Do not immediately cancel users on payment failure; provide **Grace Period (3-7 days)**.
    *   **Action**:
        1.  **Dunning Emails**: Auto-send "please update card info" reminder emails 1, 3, 5 days after payment failure.
        2.  **Service Continuity**: Allow continued service during Grace Period to minimize involuntary churn.
        3.  **Stripe Smart Retries**: Enable Stripe Billing auto-retry to maximize collection rate.
*   **Hybrid Architecture Strategy**:
    *   **Dual API Integration**: Use `Stripe Billing` for subscriptions and `Stripe Checkout` for one-time payments.
    *   **Metadata-Driven Tiering (Rule 26.2)**:
        *   **Law (Metadata Segregation)**: Plan attributes (BtoB/BtoC, API access rights) MUST be held in Stripe **Metadata (`is_enterprise: true` etc.)**, and code references it dynamically ("data-driven").
        *   **Reason**: Hardcoding plan IDs means app resubmission/redeployment every time plans are recreated on Stripe, hurting business agility.
    *   **The API Product Mindset (Rule 26.3)**:
        *   **Law (Data Monetization)**: All data output is a "Product". Abandon internal API laxity; design APIs strictly separable into **Tier 1 (Public/Free)** and **Tier 2 (Enterprise/Paid)**.
        *   **Action**: Assuming external exposure, never return raw DB data (Information Leak prevention); always package via DTO (Data Transfer Object) as "product".
    *   **The Metered Billing Mandatory Protocol (Rule 26.4)**:
        *   **Law**: When usage-based billing (API call count based, etc.) is part of business model, mandate calling `recordUsage` in **Fire-and-forget** pattern for each successful API request.
        *   **Transparency**: Persist usage logs real-time to `api_usage_logs` etc., maintaining 100% transparency for customers to know "how much they've used" from their dashboard.
    *   **Native Access Privilege**: Grant Tier 2 (Enterprise) equivalent access to users accessing from the official Native App regardless of Stripe status.
*   **Admin FinOps**:
    *   Implement a dashboard where finance staff can check "Daily Sales", "Instant Refunds", and "Force Plan Overrides".
    *   **Universal Webhook**: Receive Webhooks at a single endpoint and route by event via Async Queue.
*   **Tax**:
    *   **Global Tax Compliance**: Automatically apply the appropriate tax rate (VAT/GST/Consumption Tax) based on the user's country of residence (Stripe Tax recommended).
    *   **Invoice System**: Automatically issue receipts in a format fully compliant with **local invoice systems** (e.g., EU VAT, Japan's Qualified Invoice System).
    *   **The Invoice Preservation Protocol (7-Year Retention)**:
        *   **Law**: Per electronic bookkeeping laws, issued receipts/invoices must NOT be deleted for **7 years**. Archive PDFs to S3/Storage in addition to Stripe data for dual-redundancy to handle tax audits even if account frozen.
*   **The Secure Write Action Protocol (Tier 2 Mandate)**:
    *   **Law**: All Server Actions involving "money, critical settings, permissions" are Tier 2 (Strict) protected without exception.
    *   **Action**: 
        1. **Parameter Mandate**: Server Actions MUST accept `otp?: string` and `turnstileToken?: string` arguments.
        2. **Verification First**: Call `verifyActionOtp` or `verifyTurnstileAction` at start; throw exception immediately on auth failure.
        3. **UI Standard**: Frontend MUST use `SecureActionModal` (or `OTPModal`) requiring explicit user approval and authentication.
*   **Legal Notation**:
    *   **Specific Commercial Transactions**: Based on **applicable local laws** (e.g., Tokusho-ho in Japan), correct disclosure of operator info, return policies, etc. is mandatory.
    *   **Payment Services Act**: Be cautious when issuing prepaid payment instruments (points) and only do so if compliant with regulations. Principles dictate using Apple/Google IAP.
    *   **The Service Termination Refund Protocol (End of Service Refund)**:
        *   **Law**: Per Payment Services Act Article 20.1, upon service termination (End of Service), there is obligation to **refund in full** unused paid point balances. Maintain financial state where deposits or reserved assets cover total refund amount.
*   **The Zombie Revenue Stop (Dormant Billing Stop)**:
    *   **Risk**: Continued billing while user is not using service (death, extended hospitalization, etc.) creates refund lawsuit and brand damage risk.
    *   **Law**: For paid members with **12 months** since last login, send email to confirm billing continuation; auto-stop subscription if no response.
    *   **Action**: Monitor `last_login_at` and implement dormancy detection → notification → auto-stop flow.

## 4. Point Economy System
*   **Ledger Architecture**:
    *   **Immutable Ledger**: Direct updates to point balances (`UPDATE`) are strictly prohibited. All changes must be recorded as `INSERT` (Credit/Debit) into `point_transactions`, calculating balances via aggregation.
*   **Security & Fraud Prevention**:
    *   **Idempotency**: Client-generated UUIDs (`Idempotency-Key`) are mandatory for point grants/consumption to prevent double counting.
    *   **Security-Tiered Allocation**: Vary allocation amounts based on user authentication strength to encourage MFA.
        *   **Tier 1 (Email)**: 1 pt (Minimal / Anti-spam)
        *   **Tier 2 (Google Auth)**: 3 pts (Standard / Bot Verified)
        *   **Tier 3 (MFA/Passkey)**: 5 pts (Premium / High Trust)
*   **The 180-Day Expiration Protocol (Payment Services Act Avoidance)**:
    *   **Law**: To avoid prepaid payment instrument deposit obligations (over 10M yen), recommend setting self-issued point expiration to **180 days (6 months) from issuance**.
    *   **Action**: Expire points via nightly batch processing with advance notifications (30 days, 7 days before). Issuance of non-expiring points is prohibited in principle.

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
