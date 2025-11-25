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
*   **Act on Specified Commercial Transactions**:
    *   If selling for a fee, strictly implement the notation based on the Act on Specified Commercial Transactions.
*   **Payment Services Act**:
    *   When issuing prepaid payment instruments (points, coins), always be aware of the line where the deposit obligation arises (10 million yen) and report to the Finance Bureau if necessary.

## 7. Organizational DNA Frameworks
*   **Working Backwards (Amazon)**:
    *   **Press Release Driven Development**: Before writing code, first write the "Press Release at completion" and "FAQ". Completely define what delights the customer and what questions they have, then develop backwards from there.
*   **Day 1 Philosophy**:
    *   Obsession with customers, commitment to results, high-speed decision making. Thoroughly eliminate Big Company Disease (Day 2).
