# 11. Business, Finance & Monetization Strategy

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-03-24

> [!IMPORTANT]
> **Supreme Directive**
> "Revenue is not a feature — it is the lifeblood of sustainable product development."
> All monetization decisions must be data-driven, ethically sound, and architecturally resilient.
> Strictly follow the priority order: **User Trust > Revenue Sustainability > Growth Speed > Short-Term Profit**.
> This document is the supreme standard for all business, finance, and monetization strategy decisions.
> **7 Parts, 29 Sections.**

---

## Table of Contents

| Part | Topic | Sections |
|------|-------|----------|
| I | Unit Economics & Finance | §1 |
| II | Monetization Models | §2 |
| III | Payment & Compliance | §3 |
| IV | Point Economy System | §4 |
| V | Ad Management Strategy | §5 |
| VI | AI Token Economics | §6 |
| VII | Promotion & Pricing Strategy | §7 |

---

## 1. Unit Economics & Finance
*   **LTV > CAC (The Golden Rule)**:
    *   **Principle**: Always monitor that Customer Lifetime Value (LTV) exceeds Customer Acquisition Cost (CAC). Ideally aim for **LTV / CAC > 3**.
    *   **Measurement**: Make CAC and ROI measurable for each channel in all marketing measures.
*   **The LTV Calculation Standard Protocol**:
    *   **Formula**: `LTV = ARPU × Gross Margin × Average Lifespan (months)`
    *   **Metrics Definition**:

        | Metric | Definition | Measurement Method |
        |:-------|:-----------|:-------------------|
        | **ARPU** | Average Revenue Per User (monthly) | MRR ÷ Active Paid Users |
        | **Gross Margin** | Gross Profit Margin | (Revenue - Cost) ÷ Revenue |
        | **Average Lifespan** | Average Contract Duration (months) | 1 ÷ Monthly Churn Rate |
        | **CAC** | Customer Acquisition Cost | Marketing Spend ÷ New Paid Users |

    *   **Segmentation**: Aggregate LTV by **plan tier** (e.g., Free / Standard / Premium) and **acquisition channel** (e.g., Organic / Paid / Referral) to visualize ROI per segment.
*   **The AARRR × LTV Optimization Framework**:
    *   **Context**: Optimize each stage of AARRR (Acquisition → Activation → Retention → Revenue → Referral) from the perspective of LTV improvement.
    *   **Mandate**:

        | Stage | KPI | Impact on LTV | Example Tactics |
        |:------|:----|:-------------|:----------------|
        | **Acquisition** | New registrations, CPA | Acquiring high-quality users is the starting point of LTV | SEO optimization, content marketing |
        | **Activation** | Day1 retention, first experience completion rate | Quality of first experience greatly influences LTV | Onboarding flow optimization |
        | **Retention** | WAU/MAU, Day7/Day30 retention | Continued usage is the multiplier of LTV | Push notifications, personalization |
        | **Revenue** | ARPU, paid conversion rate | Direct LTV component | Upsell, cross-sell campaigns |
        | **Referral** | K-Factor, NPS | Referred users tend to have higher LTV | Referral programs |

    *   **Action**: Regularly monitor KPIs for each stage and prioritize improvement of stages with the lowest contribution to LTV.
*   **The Value-Based Customer Segmentation Protocol**:
    *   **Law**: Classify users into the following segments and design segment-specific strategies.

        | Segment | Definition | Response Strategy |
        |:--------|:-----------|:------------------|
        | **Champion** | Paid plan + High-frequency usage + High engagement | VIP experience, beta feature early access |
        | **Loyal** | Paid plan + Regular usage | Upsell campaigns, loyalty programs |
        | **Promising** | Free plan + High-frequency usage | Paid conversion campaigns, limited offers |
        | **Hibernating** | Long-term inactive (30+ days since last login) | Re-engagement campaigns |
        | **At Risk** | Churn risk signals detected | Immediate intervention, CS outreach |

    *   **Action**: Automate segment classification via daily batch processing and visualize in the management dashboard.
*   **Real-time P&L**:
    *   **Visualization**: Acquire not just sales but server costs (COGS) and ad expenses (CAC) via API to visualize an estimated daily P&L (Profit and Loss statement).
    *   **Unit Contribution Margin**: Always monitor that the Unit Contribution Margin per transaction is positive.
*   **FinOps (Cost Management)**:
    *   **Budget Alerts**: Must set Budget Alerts for AWS/GCP/Firebase to prevent cloud bankruptcy.
    *   **Cost Allocation**: Clarify costs per feature/team using tagging.
    *   **Cost Visualization Dashboard**: Visualize "estimated cost ($)", "tokens consumed per feature" daily in admin panel for fact-based cost management.
    *   **Exchange Rate Defense**: When using cloud services billed in foreign currencies (e.g., USD), record costs converted to local currency during monthly settlements and monitor profit margin erosion from exchange rate fluctuations. It is recommended to set pricing review triggers during periods of sharp exchange rate volatility.
    *   **Spend Cap Protocol**: Enable "Spend Cap" in Phase 1 (Dev/Launch) to prevent cloud bankruptcy. Only disable in Phase 2 (Growth).
    *   **Scale First Credit Strategy (Premature Optimization Avoidance)**: Until usage alerts for managed service base quotas (bandwidth, request counts, etc.) are triggered, avoid excessive cost cutting (premature optimization) and **focus all resources on user experience and feature development**. It is recommended to document manual recovery procedures (e.g., disabling Spend Cap) in advance in case quotas are exceeded.
    *   **Cloud Bankruptcy Prevention (Infinite Loop Countermeasure)**:
        *   **Infinite Loop Ban**: "Infinite DB reads" from `useEffect` or recursion can generate millions of requests in minutes causing bankruptcy—mandate strict loop condition review and dev environment limits.
        *   **Cache Invalidation Storm**: Prohibit implementations that spam cache invalidation (Revalidation) in loops due to explosive API call increase.
    *   **Zombie Resource Elimination**: Regularly run scripts to delete unused dev environments and old backups.
    *   **Zombie Hunter Protocol (Monthly Audit Checklist)**: Audit all cloud environments once a month to identify and remove unnecessary resources.
        *   **Target Checklist**:
            *   Unused static IP addresses (incur costs simply by being held)
            *   Preview environments and branch DBs associated with merged/deleted PRs
            *   Orphaned files in Storage (assets with no referencing records)
            *   Stopped DB instances or serverless functions (verify they are not still incurring charges)
    *   **Preview Cleanup Protocol**: Auto-delete Preview environments (branch DBs etc.) via CI/CD after PR merge to prevent "migration ghosts".
    *   **Storage Tiering Protocol**: Configure lifecycle policies to move infrequently accessed logs and archive data from Hot Storage (expensive) to Cold Storage (S3 Glacier / R2 etc.) to optimize storage costs.
    *   **Cache Hierarchy Standard (Cache-First FinOps)**: Apply the following cache hierarchy to all queries to minimize DB load and cost.
        *   **STATIC (86400s)**: Master data (categories, configurations) — zero DB load.
        *   **WARM (300s)**: Search results, list views.
        *   **HOT (60s)**: Detail pages, reviews.
        *   **REALTIME (0s)**: Payments, authentication — no cache.
    *   **Heavy Media Bandwidth Watch (Bandwidth Cost Monitoring)**: For media that consumes significant bandwidth such as high-resolution images and videos, when its traffic exceeds **30%** of the hosting provider's total bandwidth quota, immediately consider offloading to a **dedicated media delivery infrastructure** (video streaming service, image CDN, etc.). Sudden traffic spikes from viral content can exhaust hosting quotas instantly.
    *   **The Vendor Cost Governance Protocol**:
        *   **Law**: External vendor costs (SaaS, IaaS, outsourcing partners, etc.) are "hidden costs" that tend to be loosely managed despite constituting a significant portion of overall project operational costs. Visibility and periodic optimization are mandatory.
        *   **Monthly Cost Review**: Aggregate and visualize all vendor costs on a monthly basis, and display budget-to-actual comparisons in the management dashboard.
        *   **Benchmark Comparison**: At contract renewal (or annually), conduct benchmark comparisons against market prices for equivalent services and use as negotiation leverage.
        *   **Cost Overrun Response**: Trigger alerts when vendor costs exceed **80%** of budget, and mandate a cost optimization review when **100%** is exceeded.
        *   **Contract Terms Standardization**: Negotiate and document volume discounts, annual contract discounts, and early termination conditions in all vendor contracts.
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
    *   **The Provider Freeze Resilience Protocol**:
        *   **Risk**: If the payment provider (Stripe, etc.) account is frozen, all billing stops and business continuity becomes impossible.
        *   **Action**:
            1.  **Adapter Pattern**: Abstract billing logic via `PaymentProvider` interface and maintain a design that enables switching to an alternative provider (PayPal, Square, etc.) within 48 hours.
            2.  **Invoice Archive**: Archive PDFs to your own Storage in addition to the payment provider's Invoice data, maintaining dual-redundancy for tax and legal compliance even when the provider is frozen.
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
*   **The Smart Retention Protocol (Voluntary Churn Mitigation)**:
    *   **Context**: Even when users choose to cancel, appropriate flows can reduce churn (attrition).
    *   **Action**:
        1.  **Cancel Reason Survey**: After the cancel button is pressed, collect cancellation reasons via multiple-choice survey (data collection for improvement).
        2.  **Retention Offer**: Present retention offers based on the reason (free month coupon, upcoming feature improvement notifications, etc.).
    *   **Guardrail**: Intentionally complicating the cancellation flow — **Dark Patterns are strictly prohibited**. If the user declines the offer, complete the cancellation immediately.
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
        *   **Async-First Logging**: Recording metered logs MUST be performed asynchronously (background jobs, queues, etc.) to avoid delaying responses.
        *   **Zero Exception**: Failure to record metered logs MUST NOT result in a 500 error returned to users. Prioritize UX continuity over log completeness.
    *   **Native Access Privilege**: Grant Tier 2 (Enterprise) equivalent access to users accessing from the official Native App regardless of Stripe status.
*   **Admin FinOps**:
    *   Implement a dashboard where finance staff can check "Daily Sales", "Instant Refunds", and "Force Plan Overrides".
    *   **Universal Webhook**: Receive Webhooks at a single endpoint and route by event via Async Queue.
    *   **The Webhook-Driven State Machine Protocol**:
        *   **Law**: The "Source of Truth" for payment/subscription authorization states always resides on the payment provider side. Treat your own DB as a cache and guarantee **Eventual Consistency** via Webhook events within seconds.
        *   **Action**:
            1.  **Event Routing**: Receive all events at a single Webhook endpoint and route to async queues based on event type (e.g., `invoice.payment_succeeded`, `checkout.session.completed`, `customer.subscription.updated`).
            2.  **State Sync**: Subscription status changes (`active` → `canceled`, etc.) must update your DB triggered by Webhook events. Direct DB updates from user actions are prohibited.
            3.  **Tier Auto-Sync**: Implement a mechanism for automatic promotion/demotion of API access permissions (Tier 1 ⇄ Tier 2) in conjunction with plan changes.
*   **The Payment Data Attribution Protocol**:
    *   **Law**: Record traffic source information (`utm_source`, `utm_medium`, `campaign_id`, etc.) in the payment provider's **Metadata** or your own DB payment records at the time of payment, enabling per-channel ROI and LTV analysis.
    *   **Action**:
        1.  **UTM Persistence**: Save UTM parameters from the user's initial visit to Session/Cookie and automatically carry over to payment metadata upon payment completion.
        2.  **Attribution Analytics**: Design a reporting infrastructure capable of aggregating "acquired users × LTV" per marketing channel.
*   **Tax**:
    *   **Global Tax Compliance**: Automatically apply the appropriate tax rate (VAT/GST/Consumption Tax) based on the user's country of residence (Stripe Tax recommended).
    *   **Invoice System**: Automatically issue receipts in a format fully compliant with **local invoice systems** (e.g., EU VAT, Japan's Qualified Invoice System).
    *   **The Multi-Currency Readiness Protocol**:
        *   **Law**: Payment systems must maintain a design that ensures extensibility to multi-currency (Multi-Currency) support.
        *   **Action**:
            1.  **Currency Isolation**: Always pair amount columns/variables with a currency code (`currency: 'JPY'`); storing amounts without currency information is prohibited.
            2.  **Provider Delegation**: Do not calculate currency conversions yourself; delegate to the payment provider's (Stripe, etc.) multi-currency features.
            3.  **Display Locale**: Design amount displays to dynamically switch formats based on user locale (e.g., `$10.00` / `€10,00`).
    *   **The Invoice Preservation Protocol (7-Year Retention)**:
        *   **Law**: Per electronic bookkeeping laws, issued receipts/invoices must NOT be deleted for **7 years**. Archive PDFs to S3/Storage in addition to Stripe data for dual-redundancy to handle tax audits even if account frozen.
        *   **Searchability Requirements (Technical Implementation)**: In compliance with electronic bookkeeping law search requirements, maintain the ability to search transaction data by the following 3 criteria.

            | Search Criteria | DB Implementation Example | Index |
            |:---------------|:------------------------|:------|
            | **Transaction Date** | `transaction_date` (date) | Required |
            | **Counterparty** | `counterparty_name` (text) | Required |
            | **Amount** | `amount` (integer) | Required |

        *   **Authenticity Assurance**: When storing payment provider Webhook payloads as originals, record a `SHA-256` hash to enable tamper detection. `UPDATE` of once-stored original data is prohibited; if corrections are needed, add a correction history record instead.
    *   **The Tax Registration Number Protocol**:
        *   **Law**: Tax registration numbers (e.g., Japan's T-number for Qualified Invoice Issuer, EU VAT numbers) MUST be centrally managed in a system settings table (e.g., `site_settings`) and configured to be **automatically printed** on invoices, receipts, and PDFs.
        *   **Action**:
            1.  **Centralized Storage**: Do not hardcode registration numbers in environment variables or source code. Manage them in a DB table editable from the admin panel. Maintain a design where number changes do not require deployment.
            2.  **Auto-Print**: Implement a mechanism to automatically print the registration number on payment provider templates (Stripe Invoice, etc.) and self-issued PDF receipts.
            3.  **Validation**: Perform format validation of the registration number at input time (e.g., Japan's T-number is `T` + 13 digits).
*   **The Secure Write Action Protocol (Tier 2 Mandate)**:
    *   **Law**: All Server Actions involving "money, critical settings, permissions" are Tier 2 (Strict) protected without exception.
    *   **Action**: 
        1. **Parameter Mandate**: Server Actions MUST accept `otp?: string` and `turnstileToken?: string` arguments.
        2. **Verification First**: Call `verifyActionOtp` or `verifyTurnstileAction` at start; throw exception immediately on auth failure.
        3. **UI Standard**: Frontend MUST use `SecureActionModal` (or `OTPModal`) requiring explicit user approval and authentication.
*   **Legal Notation**:
    *   **Specific Commercial Transactions**: Based on **applicable local laws** (e.g., Tokusho-ho in Japan), correct disclosure of operator info, return policies, etc. is mandatory.
    *   **Financial Regulations**: Be cautious when issuing prepaid payment instruments (points) and only do so if compliant with regulations. Principles dictate using Apple/Google IAP.
    *   **The Service Termination Refund Protocol (End of Service Refund)**:
        *   **Law**: Per Financial Regulations Article 20.1, upon service termination (End of Service), there is obligation to **refund in full** unused paid point balances. Maintain financial state where deposits or reserved assets cover total refund amount.
*   **The Zombie Revenue Stop (Dormant Billing Stop)**:
    *   **Risk**: Continued billing while user is not using service (death, extended hospitalization, etc.) creates refund lawsuit and brand damage risk.
    *   **Law**: For paid members with **12 months** since last login, send email to confirm billing continuation; auto-stop subscription if no response.
    *   **Action**: Monitor `last_login_at` and implement dormancy detection → notification → auto-stop flow.
*   **The Payment Trust Checklist**:
    *   **Context**: A comprehensive checklist for ensuring all necessary requirements for reliability and growth are met when introducing or expanding a payment system. Individual rules are detailed in the sections above; this list serves as a cross-check reference.
    *   **Checklist**:

        | # | Category | Check Item | Reference |
        |:--|:---------|:-----------|:----------|
        | 1 | **Security** | PCI-DSS compliance (thorough tokenization, no raw card data retention) | §3 Security Pillars |
        | 2 | **Security** | Idempotency-Key for double payment prevention | §3 Security Pillars |
        | 3 | **Security** | Fraud detection (Stripe Radar, etc.) enabled | §3 Security Pillars |
        | 4 | **Security** | Audit logs (complete records of amount changes and permission grants) | §3 Security Pillars |
        | 5 | **Consistency** | Webhook-driven state management (Source of Truth on provider side) | §3 Webhook State Machine |
        | 6 | **Consistency** | Provider freeze risk mitigation (Adapter Pattern + Invoice dual redundancy) | §3 Provider Freeze |
        | 7 | **Resilience** | Grace Period (3-7 days) + Dunning emails on payment failure | §3 Payment Fail-Safe |
        | 8 | **Resilience** | Smart retention (cancellation reason survey + offer, Dark Pattern ban) | §3 Smart Retention |
        | 9 | **Legal** | Centralized management and auto-printing of tax registration numbers | §3 Tax Registration |
        | 10 | **Legal** | Electronic bookkeeping law compliance (7-year retention + 3 search criteria + authenticity assurance) | §3 Invoice Preservation |
        | 11 | **Legal** | Full refund preparation for paid points upon service termination | §3 Service Termination Refund |
        | 12 | **Legal** | Dormant billing stop (auto-stop after 12 months of no login) | §3 Zombie Revenue Stop |
        | 13 | **Scalability** | Multi-currency design (Currency Isolation + Provider Delegation) | §3 Multi-Currency |
        | 14 | **Scalability** | Metadata-driven Tier separation (ID hardcoding ban) | §3 Metadata-Driven Tiering |
        | 15 | **Scalability** | Usage-based billing support (Gateway Metering + Usage Log) | §3 Metered Billing |
        | 16 | **Analytics** | Payment data attribution (UTM → Payment Metadata integration) | §3 Payment Data Attribution |
        | 17 | **UX** | WCAG 2.1 AA compliant accessible payment flow | — |
        | 18 | **Scalability** | A/B testing infrastructure (price and plan optimization) | §7.2 Dynamic Pricing |

## 4. Point Economy System
*   **Ledger Architecture**:
    *   **Immutable Ledger**: Direct updates to point balances (`UPDATE`) are strictly prohibited. All changes must be recorded as `INSERT` (Credit/Debit) into `point_transactions`, calculating balances via aggregation.
*   **Security & Fraud Prevention**:
    *   **Idempotency**: Client-generated UUIDs (`Idempotency-Key`) are mandatory for point grants/consumption to prevent double counting.
    *   **Security-Tiered Allocation**: Vary allocation amounts based on user authentication strength to encourage MFA.
        *   **Tier 1 (Email)**: 1 pt (Minimal / Anti-spam)
        *   **Tier 2 (Google Auth)**: 3 pts (Standard / Bot Verified)
        *   **Tier 3 (MFA/Passkey)**: 5 pts (Premium / High Trust)
    *   **The Security-Incentive Resource Allocation Principle**:
        *   **Law**: Security-level-linked resource allocation is a universal principle applicable not only to points but to **all service resources** (API rate limits, storage capacity, AI feature usage, feature unlocking, etc.).
        *   **Action**:
            1.  **Tiered Privileges**: For users adopting high-security authentication (MFA, Passkey, etc.), design preferential treatment such as relaxed API Rate Limits, expanded storage capacity, and access to premium features.
            2.  **Bot Deterrence**: Grant only minimal resources to accounts with low-security authentication (Email Only, etc.) to suppress resource waste from bots and disposable accounts.
            3.  **Security Upgrade Incentive**: When users upgrade their security level, provide immediate feedback with concrete resource increases to function as an incentive for security enhancement.
        *   **Rationale**: By making security enhancement a "benefit" rather than an "obligation" for users, you promote voluntary improvement of security levels.
*   **The 180-Day Expiration Protocol (Financial Regulations Avoidance)**:
    *   **Law**: To avoid prepaid payment instrument deposit obligations (over 10M yen), recommend setting self-issued point expiration to **180 days (6 months) from issuance**.
    *   **Action**: Expire points via nightly batch processing with advance notifications (30 days, 7 days before). Issuance of non-expiring points is prohibited in principle.

## 5. Ad Management Strategy
*   **Independent Architecture**:
    *   **Separation**: Manage ad data (`ads`) and images completely separately from the standard media library (`media_items`) due to differing lifecycles and visibility scopes.
*   **Dynamic Injection**:
    *   **No Hardcoding**: Hardcoding ad banner URLs or links in code is permanently prohibited. Ensure control via the admin panel (`/admin/ads`).
    *   **The Ad Creative Upload Standard**:
        *   **Law**: The ad submission flow MUST support not only external URL specification but also **direct image file uploads (Storage saving)**.
        *   **Action**: Store uploaded images in a dedicated bucket (e.g., `ads-assets`) and deliver via CDN. Mixing with general user-uploaded images in the same bucket is prohibited.
*   **Placement Strategy**:
    *   **Unified System**: Manage ad locations via `location` IDs (e.g., `sidebar_top`). The frontend specifies the location, and the system delivers the appropriate ad.
*   **Ad Quality & Performance Standards**:
    *   **The CLS/INP Performance Guard (Ad Performance Mandate)**:
        *   **Context**: Lazy loading of ads worsens CLS (Cumulative Layout Shift), directly impacting search rankings.
        *   **Law**: CLS caused by ad insertion MUST be kept **≦ 0.1** (Core Web Vitals standard). Ad-related interactions (close buttons, etc.) MUST respond within **≦ 200ms** (INP standard).
        *   **Action**:
            1.  All ad slots MUST have `min-height` and `width` specified as **fixed CSS values** to pre-reserve layout area.
            2.  Ad images MUST have `loading="lazy"` and `decoding="async"` applied.
            3.  **Above-the-Fold Exception**: First-view ads MUST use `loading="eager"` + `priority={true}` for preloading to minimize blank time.
*   **The Ad Schema Standard**:
    *   **Law**: Ad management tables MUST include at minimum the following columns, enabling delivery control and performance measurement.

        | Column | Type | Description |
        |:------|:-----|:-----------|
        | `id` | UUID | Primary Key |
        | `title` | Text | Administrative name |
        | `image_url` | Text | Creative URL (CDN) |
        | `storage_path` | Text | Storage path (for self-hosted uploads) |
        | `link_url` | Text | Destination URL (Optional) |
        | `location` | Text | Placement identifier |
        | `priority` | Int | Display priority |
        | `start_at` | Timestamptz | Publication start datetime |
        | `end_at` | Timestamptz | Publication end datetime |
        | `is_active` | Boolean | Immediate publish/stop flag |
        | `views` | Int | Impression count |
        | `clicks` | Int | Click count |

*   **The Ads.txt & Sellers.json Integrity Protocol (Ad Supply Chain Transparency)**:
    *   **Law**: Dynamically serve authorized seller information (Ads.txt) to prevent domain spoofing (Ad Fraud). Also, publish ad inventory seller information via `/sellers.json` to ensure supply chain transparency.
    *   **Action**:
        1.  **Ads.txt**: Set `Cache-Control: public, s-maxage=3600` (1 hour) via Route Handler etc. to avoid server load from high-volume crawler access.
        2.  **Sellers.json**: Publish your own and partner information via `/sellers.json`.
        3.  **Validation**: Periodically monitor that your status on ad platforms (Google AdSense / GAM, etc.) is "Authorized".
*   **The Ad Labeling Protocol (Automatic Ad Disclosure / Anti-Stealth Marketing)**:
    *   **Law**: Ad slots, PR articles, and sponsored content MUST have labels such as "PR", "Ad", "Sponsored" etc. **automatically applied at the system level** in a position and size that users can immediately recognize.
    *   **Action**:
        1.  **Auto-Label**: Design ad components to automatically display labels at delivery time. Block ad delivery without labeling at the system level.
        2.  **Compliance**: Maintain labeling that complies with advertising disclosure regulations in each jurisdiction (e.g., FTC Endorsement Guides, local stealth marketing regulations).
*   **The Brand Safety Protocol (Ad Brand Safety)**:
    *   **Law**: Ads of inappropriate categories that would damage the service's brand value MUST be **prohibited from delivery at the system level**.
    *   **Action**:
        1.  **Category Exclusion List**: Define a prohibited category list based on the nature of your service (e.g., gambling, adult content, violence, political ads, etc.).
        2.  **Third-Party Ads**: Block the relevant categories in Google AdSense etc. management panels and save screenshots of the settings annually.
        3.  **Self-Hosted Ads**: Add a `category` column to your ad table and mandate category classification at submission time. Reject ads matching prohibited categories via validation.
*   **The Ads.txt Operations Protocol (Ads.txt Operations & Periodic Audit)**:
    *   **Law**: Ads.txt / Sellers.json require updates whenever partners are added or removed; it is NOT a "set it and forget it" configuration.
    *   **Action**:
        1.  **Monthly Audit**: Monthly, verify via Ads.txt Validator etc. that there are no syntax errors, that registered partners are valid, and that your own information in Sellers.json is accurate.
        2.  **Update Procedure**: Perform updates via code repository (PR → Review → Merge → Deploy) and confirm status on the ad platform management panel.
        3.  **Emergency Response**: If a fraudulent ad partner is detected, immediately remove from Ads.txt and deploy within 24 hours.

## 6. AI Token Economics
*   **Profitability Guardrails**:
    *   **The 30% Rule**: Keep AI token costs under **30%** of subscription revenue. Apply hard limits if exceeded.
    *   **Model Tiering**: Do not use highest-spec models (e.g., GPT-4) for everything. Switch to lightweight models (Flash/Mini) based on task complexity.
    *   **Circuit Breaker**: Implement a safety mechanism to auto-stop AI features upon sudden cost spikes (e.g., exceeding budget in 1 hour).

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

### 7.3. The Pricing AB Test Protocol
*   **Context**: Optimization of pricing and plan structures should be continuously performed through data-driven A/B testing, but experimentation velocity is severely reduced when design requires code changes for each test.
*   **Law**: Build an infrastructure that enables experimentation with price, plan, and discount rate changes without code deployment.
*   **Action**:
    1.  **Feature Flag Integration**: Use feature flags for switching price displays and plan configurations, enabling delivery of A/B variants by user segment.
    2.  **Conversion Tracking**: Automatically measure conversion rate (CVR), average revenue per user (ARPU), and churn rate for each variant, and design dashboard infrastructure supporting statistical significance determination.
    3.  **Grandfathering Guard**: Ensure grandfathering design consideration so that prices for existing users who contracted during A/B testing are maintained at the original price even after the test concludes.

---

## Appendix A: Quick Reference Index

| Keyword | Sections | Related Rules |
|---------|----------|---------------|
| LTV / CAC | §1 | `102_growth_marketing`, `720_cloud_finops` |
| Subscription / SaaS | §2 | `103_appstore_compliance` |
| Payment / Stripe | §3 | `600_security_privacy`, `601_data_governance` |
| Point Economy | §4 | `400_ai_engineering` |
| Ad Management | §5 | `102_growth_marketing` |
| AI Token Economics | §6 | `400_ai_engineering`, `720_cloud_finops` |
| Pricing / Promotion | §7 | `102_growth_marketing` |
| Churn / Retention | §1, §7 | `102_growth_marketing`, `501_customer_experience` |
| Compliance / Tax | §3 | `103_appstore_compliance`, `601_data_governance` |
