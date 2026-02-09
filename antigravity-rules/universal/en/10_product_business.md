# 10. Product & Business Strategy

> [!IMPORTANT]
> **Business Iron Rule**
> We are not a charity. However, **profit gained by violating "Legal & Ethics" has no value**.
> The priority of Level 1 (Legal) > Level 3 (Profit) is absolute.

## 1. Strategic Pillars - C-Level Alignment
*   **CEO (Chief Executive Officer - Vision & Product)**:
    *   **MVP to PMF**: Do not aim for "Perfection"; release the minimum set (MVP) that maximizes "Learning" as fast as possible. Obtaining market feedback and aiming for Product-Market Fit (PMF) is the top priority.
    *   **North Star Metric**: All feature development is done to improve the single most important metric (North Star Metric).
    *   **Exit Strategy**: Always make decisions maximizing asset value (IP, data, user base) with an IPO or M&A Exit in view.
*   **COO (Chief Operating Officer - Operational Excellence)**:
    *   **Automation First**: Optimize the development process itself. Automate everything that can be automated, creating an environment where humans (owners) can focus only on decision-making.
*   **CMO (Chief Marketing Officer - Growth & Brand)**:
    *   **Brand as Experience**: View every touchpoint of the product (UI, copy, error messages) as a branding opportunity.
    *   **Viral Mechanics**: Always be conscious of the LTV > CAC equation and incorporate mechanisms where users bring other users (maximizing viral coefficient) from the design stage.

### 1.1. Entrepreneurial Mindset
*   **Speed vs Quality Trade-off**:
    *   **Principle**: Prioritize speed except for "Security and Legal". A fast product with bugs that reaches the market wins over a slow bug-free product (however, Level 1 Security is absolute).
    *   **Pivot**: If data denies the hypothesis, have the courage to ignore sunk costs and change direction immediately.

## 2. Finance & Cost Management - CFO View
*   **ROI-Driven Development**:
    *   Be conscious of ROI (Return on Investment) in all feature development and technology selection. Adopt not because "it's technically interesting" but because "it has business value".
*   **Burn Rate Control**:
    *   **Variable over Fixed Costs**: Thoroughly utilize serverless architecture (Cloud Run, Firebase) to bring costs close to zero when there is no access.
    *   **SaaS Diet**: Unnecessary SaaS contracts are "wounds bleeding the company". Review and cancel them regularly.
*   **Profitability**:
    *   Prioritize "Profit" over "Revenue". Expansion without established unit economics is merely expansion of losses.

## 3. HR & Organization - Human Capital View
*   **AI as a Team**:
    *   Treat AI not just as a tool but as a "super-excellent expert team working 24/365".
    *   Assign clear Roles and Responsibilities to each AI agent to maximize performance.
*   **The Keeper Test (Netflix)**:
    *   **Talent Density**: Ask yourself, "If a team member (feature/code/library) said they were 'quitting to go elsewhere (being deleted)', would I fight to keep them?"
    *   If the answer is No, immediately delete (lay off) that feature or code and look for a better alternative. Compromise kills the organization (product).
*   **Context not Control (Netflix)**:
    *   **Autonomy**: Do not micromanage (Control) excellent talent (including AI); give them the Context needed for judgment.
    *   **Ownership**: "Waiting for instructions" is prohibited. Understand the purpose and background, and autonomously derive the optimal solution.
*   **Psychological Safety (Google)**:
    *   **Risk Tolerance**: Create an environment where one can challenge without fear of "failure". However, repeating the same failure is not allowed.
    *   **Radical Candor**: Care Personally while Challenging Directly. Flattery and backbiting are prohibited.
*   **Documentation Culture**:
    *   Eliminate "tacit knowledge" and document (explicit knowledge) all decisions and processes. This enhances scalability and onboarding efficiency for future members (humans/AI).

## 4. Monetization Strategy
*   **Freemium Model**:
    *   **Value Metric**: Place the charging point not on "feature restriction" but on "expansion of value (usage, advanced features, speed)".
    *   **Conversion**: Design so that at least **2-5%** of free users become paid members.
*   **Subscription Economics**:
    *   **Recurring Revenue**: Prioritize recurring revenue (MRR/ARR) over one-time sales.
    *   **Tiered Pricing**: Create a structure where users can upgrade (Upsell) as they grow (e.g., Basic, Pro, Enterprise).
    *   **Metadata Segregation Protocol (Data Driven Strategy)**:
        *   **Law**: Writing conditional branches in code like "if plan ID is this, then Enterprise plan" (Hardcoding) is a serious design mistake that damages business flexibility.
        *   **Action**: Plan properties (BtoB/BtoC, API permission availability) should be in metadata (e.g., `is_enterprise: true`) in Stripe etc., and application should dynamically reference these to determine behavior—enforce **"Data Driven Strategy"**. This enables immediate response to business plan changes without deployment.
    *   **The API Economy Alignment (Commercialization First)**:
        *   **Law**: Even internal APIs should be designed assuming future external sales (Monetization). Build in concepts of "Tier 1 (Public)" and "Tier 2 (Enterprise)" as business requirements from the start.
        *   **Reason**: "Selling APIs later" pivot costs more than building from scratch.
    *   **The Usage Limit UX & Enforcement Protocol (Tier-based Limit Implementation)**:
        *   **Law**: Feature limits per subscription tier (Free/Standard/Premium, etc.) such as registration counts or API calls MUST be enforced on **both UI and backend**.
        *   **Action**:
            1.  **Server-Side Enforcement (SSOT)**: Limit validation MUST be done on **Server Actions / RPC / DB Trigger** side. Client-side-only limits risk being bypassed.
            2.  **Clear Error Messaging**: On limit exceeded, display **specific and positive messages** to prompt upsell like "Free plan is limited to 1 item. Upgrade to Pro plan for unlimited."
            3.  **Guard Centralization**: Limit check logic MUST be centralized in `src/lib/guards/subscription-guard.ts` etc. Scattering across individual features is prohibited (DRY violation prevention).
*   **Ad-based Model (If applicable)**:
    *   **User Experience First**: Integrate ads naturally as part of the content and ensure they do not hinder UX (Native Ads).
    *   **Viewability**: Value only the ads that users actually see.

## 5. Unit Economics
*   **LTV > 3x CAC**:
    *   Customer Lifetime Value (LTV) must be **more than 3 times** the Customer Acquisition Cost (CAC). If this does not hold, do not expand marketing.
*   **Payback Period**:
    *   Aim for a Payback Period for CAC of **within 12 months**. Ideally within 6 months.
*   **Churn Rate**:
    *   Lowering the Churn Rate is more important than new acquisition. Aim for a monthly churn rate of **3% or less**.
*   **Magic Number**:
    *   For SaaS, ensure the Magic Number (Net New MRR × 12 / Previous Quarter Sales & Marketing Expense) is **0.7 or higher**.

## 6. Legal & Compliance Perspective
*   **Terms of Service & Privacy Policy**:
    *   Must be established before service launch, and user consent flow (checkboxes, etc.) must be embedded in the UI. Avoid "deemed consent" and obtain explicit consent.
*   **Local Commercial Laws**:
    *   If selling for a fee, strictly implement the notation based on **local laws** (e.g., Tokusho-ho).
*   **Prepaid Instrument Regulations**:
    *   When issuing prepaid payment instruments (points, coins), always be aware of the line where the deposit obligation arises (e.g., threshold amount in local currency) and report to relevant authorities if necessary.

### 6.1. The Legal Hardcoding Ban (DB SSOT Mandate)
*   **Law**: Hardcoding (directly writing) "legally binding text" such as Terms of Service, Privacy Policy, or commercial law-required disclosures in source code is **permanently banned (Universal Ban)** as it risks delayed corrections during legal changes.
*   **Action**:
    *   **DB First**: All legal documents MUST be saved in `site_settings` table or dedicated `fixed_pages` table.
    *   **Admin UI**: Standard implementation of a mechanism allowing non-engineers to immediately edit and publish via admin panel without developer involvement.
    *   **Risk Management**: A state where deployment wait occurs on the day of legal changes is declared "defeat" in corporate compliance management.

## 7. Organizational DNA Frameworks
*   **Working Backwards (Amazon)**:
    *   **Press Release Driven Development**: Before writing code, first write the "Press Release at completion" and "FAQ". Completely define what delights the customer and what questions they have, then develop backwards from there.
*   **Day 1 Philosophy**:
    *   Obsession with customers, commitment to results, high-speed decision making. Thoroughly eliminate Big Company Disease (Day 2).

## 8. Search & Discovery Architecture

### 8.1. The Tag-Based Attribute Protocol
*   **Law**: Variable attributes of entities (products, stores, articles, etc.) such as features and conditions MUST be structured as **Tags (M:N relations)** rather than adding dedicated columns.
*   **Action**:
    1.  **Master Table**: Prepare a master table for tag types, defining `category` (classification) and `slug` (search key).
    2.  **Junction Table**: Manage entity-tag associations via a Junction Table, enabling dynamic filtering and search.
    3.  **No Column Explosion**: Proliferating Boolean columns like "supports_feature_A", "supports_feature_B" is prohibited as it causes schema bloat and query complexity.

### 8.2. The Structured Business Hours Protocol
*   **Law**: Business hours MUST be managed as **structured data in JSONB format**, not free text.
*   **Schema Standard**:
    *   Store opening/closing times per day of the week as an array, supporting multiple time slots (lunch, dinner, etc.).
    *   Closed days are represented as `null` or empty arrays, flexibly accommodating temporary closures.
*   **Timezone Strategy**: The display layer should show times based on the target market's timezone. Internal storage uses UTC as the standard, converting at display time.
*   **Holiday Priority**: Prepare a holidays/temporary closures table (e.g., `entity_holidays`) and **prioritize holiday settings over regular weekly schedules** when determining availability.
*   **Search Optimization**: For real-time searches like "Currently Open," instead of calculating against the current time per request, leverage pre-computed columns (e.g., `next_open_at`, `is_currently_open`) updated via triggers or batch processes.

### 8.3. The Search Freshness SLA
*   **Law**: Define an SLA (Service Level Agreement) for the delay (Staleness) until user-updated data is reflected in search results.
*   **Standard**:
    *   **Critical Data** (inventory, price, status): Reflected in search index within **5 minutes**.
    *   **Content Data** (descriptions, images): Reflected within **1 hour**.
*   **Action**: Design appropriate search index update triggers (Webhooks, Realtime Subscriptions, scheduled batches) to build an architecture that meets the SLA.
*   **Cache Purge Sync**: Even if immediate search index reflection is achieved, stale data may be displayed due to missed CDN or application cache purges. Execute cache tag purges (e.g., `revalidateTag`) synchronously upon data updates.

## 9. Review & Trust System

### 9.1. The Bayesian Average Protocol
*   **Law**: For aggregating review ratings, use **Bayesian Average instead of simple arithmetic mean**.
*   **Reason**: With few reviews, a single extreme rating (5-star or 1-star) can significantly skew the average. Bayesian Average incorporates the global average as a prior distribution, mitigating bias from small sample sizes.
*   **Formula**: `bayesian_score = (C × m + Σ(ratings)) / (C + n)` (C: confidence threshold, m: global average, n: review count)
*   **Pre-calculation**: Calculation should NOT be performed per-request. Pre-calculate via batch or trigger on review submission/update and store in an entity table column (e.g., `bayesian_score`).

### 9.2. The Pre-Moderation Protocol
*   **Law**: User-Generated Content (UGC), especially reviews, MUST **pass moderation (review) before publication** as the standard.
*   **Action**:
    1.  **Status Flow**: Manage review status as `pending → approved / rejected` (3 states).
    2.  **Visibility**: Include only `approved` reviews in public queries; display unreviewed content as "Under Review" to users.
    3.  **Automation**: Automate spam detection and prohibited word filtering to reduce human moderation costs.
    4.  **Self-Review Ban**: Systematically block entity owners (e.g., store owners) from posting reviews on their own entities. Self-reviews by stakeholders undermine trust and credibility.
    5.  **Trusted User Exception**: For users who have achieved a certain trust score (e.g., N or more previously approved reviews), allow an exception to skip pre-moderation, balancing review costs with user experience.

### 9.3. The Immutable Deletion Protocol
*   **Law**: Once published, review data MUST use **Soft Delete** as the standard; physical deletion is prohibited in principle.
*   **Reason**: To maintain integrity of aggregate scores (Bayesian Average) and to enable auditing of irregular operations (deletion of unfavorable reviews).
*   **Action**: Set a deletion flag (`deleted_at`) to exclude from public queries while retaining the record in the database.
*   **Destructive Action Confirmation**: Since soft deletion of reviews has irreversible impacts (e.g., aggregate score recalculation), require **confirmation word input** (e.g., typing "delete") in the admin panel for deletion operations to prevent accidental actions.

## 10. Interactive Engine

### 10.1. The Unified Interactive Schema
*   **Law**: Interactive content such as polls, diagnostics, quizzes, and surveys MUST be managed using a **unified schema (Polymorphic Pattern)** rather than individual tables.
*   **Action**:
    1.  **Single Table**: Use an `interactive_contents` table with a `type` column (`poll`, `quiz`, `survey`, etc.), storing questions and options in JSONB.
    2.  **Responses Table**: Aggregate responses in an `interactive_responses` table, linked by `content_id`.
    3.  **Extensibility**: Maintain a design where adding new interactive types requires only adding a `type` value, without creating new tables.
    4.  **Deterministic Logic**: Implement diagnosis and quiz result calculation algorithms as **deterministic (score-based, etc.), not random**. Even when using AI, ensure reproducibility of results for the same inputs, enabling result traceability for user inquiries.
