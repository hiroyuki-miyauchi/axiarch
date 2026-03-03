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

### 1.2. The User Persona Definition Protocol
*   **Law**: Target user personas MUST be **explicitly documented** as the decision criteria for all feature development, UI design, and microcopy. Development without personas is a state of "not knowing who you're building for" and is the primary cause of specification drift and rework.
*   **Mandate**:
    *   **Primary Persona**: Define the main target (primary user of the service). Include age range, region, device ratio, key challenges, and goals.
    *   **Secondary Persona**: Define secondary targets (administrators, business operators, etc.).
    *   **Use Case Priority**: List the persona's key use cases with priority ranking and use them as input for determining the order of feature development.
*   **Location**: Persona definitions should be managed in the project-specific Blueprint and reviewed quarterly. This protocol provides the "template."

### 1.3. The Technology Roadmap Protocol
*   **Law**: Ad-hoc feature additions are the primary cause of technical debt and cost inflation. A mid-to-long-term technology roadmap MUST be explicitly documented to grow the product strategically.
*   **Mandate**:
    *   **3-Phase Structure**:
        | Timeframe | Content | Update Frequency |
        |:----------|:--------|:----------------|
        | **Now (This Quarter)** | Features in progress or next to start | Every sprint |
        | **Next (Next Quarter)** | Confirmed but not yet started features | Monthly |
        | **Later (6 months–1 year)** | Conceptual features and tech investments | Quarterly |
    *   **Quarterly Review Obligation**: Review the roadmap at the end of each quarter and evaluate the following:
        1.  KPI achievement status of completed features
        2.  Technical debt inventory (classification and prioritization of accumulated TODO/FIXME items)
        3.  Cost budget vs. actual variance
    *   **Prioritization Framework**: Quantitatively evaluate features using ICE (Impact × Confidence × Ease) scores to eliminate subjective judgment.
*   **Location**: Specific roadmaps should be managed in the project-specific Blueprint. This protocol provides the "template" for the management process.

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

### 8.4. The Multi-Factor Ranking Protocol
*   **Law**: Search result ordering MUST be determined by **multi-factor scoring** aimed at maximizing value for users, not simply by registration date.
*   **Scoring Factors**: Combine the following factors to compose the ranking score. Weighting should be defined in the project-specific Blueprint.

    | Factor | Description |
    |:-------|:-----------|
    | **Review Score** (Bayesian Average) | Bayesian Average from §9.1 |
    | **Completeness** | Image count, description richness, attribute fill rate |
    | **Freshness** | Recency of last update |
    | **Engagement** | Favorites count, view count, inquiry count |
    | **Proximity** | Distance from user's current location (when location permission granted) |
    | **Sponsored Boost** | Score addition via paid advertising |

*   **Sponsored Transparency**: When rank elevation includes an advertising boost, search results MUST display labels such as "PR" or "Sponsored," complying with advertising disclosure regulations of each country.
*   **Pre-calculation**: Scores should NOT be calculated in real-time. Pre-calculate via daily batch or event-driven processes and store in an entity table column (e.g., `search_score`).
*   **User-Controlled Sorting**: Provide user-selectable sort options (Recommended / Rating / Newest / Distance, etc.) with the default being composite score descending.

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

### 9.4. The Automated Spam Filter Protocol
*   **Law**: Apply the following automated filters upon UGC (reviews, etc.) submission and hold content suspected of spam in a `flagged` status.
*   **Detection Rules**:
    *   **Burst Posting**: Same user submitting more than a defined number (e.g., 3+) within a short period (e.g., 10 minutes)
    *   **Template Detection**: High content similarity (e.g., 80%+) across posts targeting different entities
    *   **URL/Contact Info Injection**: Content containing phone numbers, URLs, or other external redirection
    *   **Prohibited Word Dictionary**: Keywords matching discriminatory expressions, violent content, or competitor defamation
*   **AI Augmentation**: Use LLM (lightweight model recommended) for semantic-level spam detection to reduce false positive rates. Log detection results and use them for filter accuracy improvement.

### 9.5. The Progressive Trust Level Protocol
*   **Law**: Assign progressive trust levels to UGC contributors and relax moderation requirements based on trust level.
*   **Trust Level Design**:

    | Level | Conditions | Privileges |
    |:------|:-----------|:-----------|
    | **Lv.0 (New)** | New user | All posts require approval |
    | **Lv.1 (Verified)** | Identity verified + N+ approved posts | Text posts published immediately |
    | **Lv.2 (Trusted)** | Lv.1 conditions + MFA enabled + M+ posts + no report history | Posts with images published immediately |

*   **Demotion**: If reports accumulate to a threshold (e.g., 3+), demote to Lv.0 and subject all posts to re-review.
*   **Mandate**: Define specific thresholds (N, M) for each level in the project-specific Blueprint. This protocol provides the level structure "template."

### 9.6. The User Report Protocol
*   **Law**: Provide a mechanism for users to report inappropriate UGC and define response SLAs.
*   **Report Categories**: Inaccurate information / Inappropriate content / Spam / Personal information exposure / Other
*   **Response SLA**: Complete initial judgment (maintain display or temporarily hide) within **24 hours** of report.
*   **Due Process**: When deleting UGC, notify the poster of the reason and provide an opportunity for appeal (e.g., within 14 days).

### 9.7. The UGC Submission Rate Limit Protocol
*   **Context**: Define frequency limits to structurally prevent spam, self-promotion, and mass bot submissions while ensuring UGC quality.
*   **Mandate**:

    | Limit Type | Threshold Example | Violation Response |
    |:-----------|:-----------------|:-------------------|
    | **Same entity submission** | 1 per 365 days | Allow updates only |
    | **Overall posting frequency** | 5 per 24 hours | Queue excess submissions |
    | **New account restriction** | 2 posts within 72 hours of registration | Linked with Progressive Trust (§9.5) |
    | **Bot detection** | CAPTCHA/challenge authentication required | Block submission on verification failure |

*   **Implementation**:
    *   Manage Rate Limit counters at the DB level using composite keys of `user_id + entity_id`.
    *   Implement a cooldown period (e.g., 30 seconds) on the submission button in the frontend to physically prevent rapid-fire submissions.
*   **Mandate**: Define specific threshold values for each limit in the project-specific Blueprint. This protocol provides the limit structure "template."

## 10. Interactive Engine

### 10.1. The Unified Interactive Schema
*   **Law**: Interactive content such as polls, diagnostics, quizzes, and surveys MUST be managed using a **unified schema (Polymorphic Pattern)** rather than individual tables.
*   **Action**:
    1.  **Single Table**: Use an `interactive_contents` table with a `type` column (`poll`, `quiz`, `survey`, etc.), storing questions and options in JSONB.
    2.  **Responses Table**: Aggregate responses in an `interactive_responses` table, linked by `content_id`.
    3.  **Extensibility**: Maintain a design where adding new interactive types requires only adding a `type` value, without creating new tables.
    4.  **Deterministic Logic**: Implement diagnosis and quiz result calculation algorithms as **deterministic (score-based, etc.), not random**. Even when using AI, ensure reproducibility of results for the same inputs, enabling result traceability for user inquiries.
