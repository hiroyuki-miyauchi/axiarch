# 10. Product & Business Strategy

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-04-21 Rev.13

> [!IMPORTANT]
> **Business Iron Rule**
> We are not a charity. However, **profit gained by violating "Legal & Ethics" has no value**.
> The priority of Level 1 (Legal) > Level 3 (Profit) is absolute.
> **24 Sections + Appendix (2026-04-21 Rev.13 Update: §1.9 Strategic Partnership & BD Protocol / §9.10 AI Reasoning & Test-Time Compute Protocol / §12.5 DE&I as Product Strategy Protocol / §23.6 Sales Enablement & Revenue Readiness Protocol).**

---

## Table of Contents

1. [§1. Vision & Strategic Pillars](#1-vision--strategic-pillars)
2. [§2. Product Discovery & Positioning](#2-product-discovery--positioning)
3. [§3. Product Metrics Governance](#3-product-metrics-governance)
4. [§4. Monetization Strategy](#4-monetization-strategy)
5. [§5. Unit Economics](#5-unit-economics)
6. [§6. Finance & Cost Management](#6-finance--cost-management)
7. [§7. Legal & Compliance](#7-legal--compliance)
8. [§8. Organizational DNA Frameworks](#8-organizational-dna-frameworks)
9. [§9. AI-Native Product Design Protocol](#9-ai-native-product-design-protocol)
10. [§10. Platform & Ecosystem Strategy](#10-platform--ecosystem-strategy)
11. [§11. Data Product Strategy](#11-data-product-strategy)
12. [§12. Sustainable & Ethical Product Design](#12-sustainable--ethical-product-design)
13. [§13. Search & Discovery Architecture](#13-search--discovery-architecture)
14. [§14. Review & Trust System](#14-review--trust-system)
15. [§15. Interactive Engine](#15-interactive-engine)
16. [§16. Growth Loop Design Protocol](#16-growth-loop-design-protocol)
17. [§17. Competitive Intelligence Protocol](#17-competitive-intelligence-protocol)
18. [§18. Customer Success Design Protocol](#18-customer-success-design-protocol)
19. [§19. Product Portfolio Strategy](#19-product-portfolio-strategy)
20. [§20. GTM Launch Protocol](#20-gtm-launch-protocol-go-to-market-launch-protocol)
21. [§21. Global Expansion Protocol](#21-global-expansion-protocol-internationalization--global-expansion)
22. [§22. Fundraising & Investor Relations Protocol](#22-fundraising--investor-relations-protocol)
23. [§23. Revenue Operations (RevOps) Protocol](#23-revenue-operations-revops-protocol)
24. [§24. Brand Architecture & Corporate Communications Protocol](#24-brand-architecture--corporate-communications-protocol)
25. [Appendix A: Quick Reference Index](#appendix-a-quick-reference-index)
26. [Appendix B: GTM Launch Checklist](#appendix-b-gtm-launch-checklist)
27. [Appendix C: Fundraising Readiness Checklist](#appendix-c-fundraising-readiness-checklist)


---

## 1. Vision & Strategic Pillars

### 1.1. Why We Exist (The Why — Vision & Mission)
*   **Supreme Law**: Define "Why we build it" before "What we build." Using **Simon Sinek's Golden Circle** as the foundation, explicitly document Mission, Vision, and Values first—making them the North Star for all decisions.
*   **Mandate**:
    *   **Mission (Purpose)**: Express in one sentence: "Whose problem do we exist to solve, and what problem is it?"
    *   **Vision (Destination)**: Paint the picture of "How we will change the world in 10 years."
    *   **Values (Code of Conduct)**: The elevation of Mission and Vision into decision criteria. Applied to hiring, product prioritization, and partner selection.
*   **Anti-Pattern**: "We'll figure out the mission later, just build first" is the **first failure** that causes product direction to drift.

### 1.2. MVP to PMF Protocol
*   **Law**: Do not aim for "Perfection." Release the minimum set (MVP) that maximizes "Learning" as fast as possible. Obtaining market feedback and validating Product-Market Fit (PMF) is the only objective.
*   **PMF Benchmark (Sean Ellis Test)**: The minimum PMF threshold is when ≥ **40%** of surveyed users say they would be "Very disappointed" if they could no longer use the product.
*   **Pivot Protocol**: If data refutes a hypothesis, have the courage to **immediately ignore sunk costs** and change direction. Delayed pivots maximize cash burn and are fatal.
*   **Build Trap Prohibition**: Prohibit the illusion that adding more features creates value (Build Trap). "Validate" before "Build." → See `product/100_market_validation.md` for details.
*   **MLP Protocol (Minimum Lovable Product)**:
    *   **Definition**: If MVP is "validating a hypothesis with the minimum feature set for the right users," MLP is "the minimum something that the right users can **be emotionally delighted** by." This concept is actively practiced by top-tier products like Figma and Stripe.
    *   **MVP vs MLP Distinction**: MVP validates "does it work (Functional)?"; MLP validates "does it delight (Delightful)?". The goal is not the number of features, but a **high density of Delight** in a small feature set.
    *   **When to Apply**: Especially effective for B2C/consumer products, markets where the "feel" of the experience is a key differentiator, and products designed around Viral Loops. B2B SaaS teams should pair MLP with the Design Partner Protocol (§2.5).
    *   **Measurement**: Proxy-measure MLP effectiveness via NPS ("Would you recommend to a friend?") and Time-to-Value (TtV) to Aha! Moment.

### 1.3. North Star Metric Protocol
*   **Law**: All feature development is done to improve **exactly one North Star Metric (NSM)**. The NSM must most accurately represent "customer success" (do not select a revenue-only metric).
*   **NSM Selection Criteria**:
    *   Reflects customer value (e.g., "weekly posts" rather than "monthly active users")
    *   Correlates with revenue but is not revenue itself
    *   The entire team can influence it
*   **Counter Metrics (Guardrail Metrics)**: Maximizing NSM alone may undermine core value. Always define Counter Metrics alongside NSM and continuously monitor that NSM improvements are not degrading Counter Metrics.
    *   Example: NSM = DAU growth → Counter Metrics = support ticket volume, error rate, cancellation count

### 1.4. Exit Strategy & Asset Value Maximization
*   **Law**: Always make decisions that maximize asset value (IP, data, user base, technical capability) with an IPO or M&A Exit in view.
*   **Value Drivers**:
    *   **IP (Intellectual Property)**: Proprietary algorithms, patents, trademarks
    *   **Data Moat**: User data assets that competitors cannot easily replicate
    *   **Network Effects**: Design so that value increases as users grow
    *   **Switching Cost**: Deep integration into users' data and workflows
*   **Investability**: Always ask from the investor's perspective: "Can this product be explained clearly?" and "Are the metrics clean?" → See `product/900_fundraising_ir.md` for details.

### 1.5. Roadmap Management Protocol
*   **Law**: Ad-hoc feature additions are the primary cause of technical debt and cost inflation. Explicitly document a mid-to-long-term roadmap and grow strategically.
*   **3-Phase Structure (Now/Next/Later)**:

    | Timeframe | Content | Update Frequency |
    |:----------|:--------|:----------------|
    | **Now (This Quarter)** | Features in progress or next to start | Every sprint |
    | **Next (Next Quarter)** | Confirmed but not yet started | Monthly |
    | **Later (6 months–1 year)** | Conceptual features and tech investments | Quarterly |

*   **Prioritization Framework**: Use `RICE` (Reach × Impact × Confidence / Effort) or `ICE` (Impact × Confidence × Ease) scores to quantitatively evaluate features and eliminate subjective judgment.
*   **OKR Linkage Mandate**: Every item on the roadmap MUST be linked to an OKR (Key Result) for that quarter. Feature development that cannot be traced to a current OKR is prohibited by default.
*   **Feature Flag Strategy Integration**:
    *   Features on the roadmap MUST NOT ship as "release = instant full rollout." Use **Feature Flags for staged rollout** as the standard.
    *   **Ring Deployment**: Standardize 4-stage rollout: `1% (Canary) → 10% (Trial) → 50% (Gradual) → 100% (GA)`. Validate NSM and Counter Metrics at each stage before advancing.
    *   **Stale Flag Policy**: Feature Flags that have been live in production for **more than 90 days** are classified as "technical debt" and MUST be removed.
*   **Tech Debt Triangle**: Target a **70% / 15% / 15%** split between new feature development / bug fixes / technical debt paydown. Review quarterly. Invert the ratio if debt accumulates.
*   **Quarterly Review Obligation**: Simultaneously evaluate KPI achievement of completed features, technical debt inventory, cost budget vs. actuals, and OKR achievement rate.

### 1.6. Category Creation Protocol
*   **Law**: The most disruptive competitive advantage comes not from "winning an existing category" but from **"defining and owning a new one."** Salesforce (CRM→SaaS), HubSpot (Inbound Marketing), and Notion (Connected Workspace) are all category creators.
*   **Conditions for Category Creation (Apply only if ALL THREE are Yes)**:
    1.  **Dissatisfaction with Existing Categories**: Do users hold deep, structural dissatisfaction with existing solutions? (Not a feature gap — a mismatch in the cognitive model they bring to the problem.)
    2.  **A Unique POV (Point of View)**: Can you tell a story of the form: "The world has changed in this way, which means the conventional approach is wrong"?
    3.  **Ecosystem Orchestration Capability**: Can you orchestrate an entire ecosystem — including partners, standards, and community — not just your own product?
*   **Category Design Execution Protocol** (Play Bigger framework):
    1.  **POV Document (1-pager)**: Articulate in one page: "Why does this problem matter now?", "What is wrong with the existing category?", and "What is our vision?" The CEO carries this into every pitch.
    2.  **Category Name**: Name the new category. Naming establishes intellectual ownership of the category (e.g., HubSpot named "Inbound Marketing" and thus owned the category). Choose vocabulary competitors cannot avoid quoting.
    3.  **Lightning Strike Event**: Design a single, concentrated marketing event that announces the category to the world. Not a press release alone — create **a moment the entire industry talks about** (keynote, joint research publication, market report release, etc.).
    4.  **Ecosystem Orchestration**: Draw other players (partners, academic institutions, standards bodies) into the category, so that "our definition" becomes the industry standard.
*   **KPIs (Category Awareness Measurement)**:
    *   **Share of Search**: Ratio of your category name's Google search volume vs. the incumbent category name's volume.
    *   **Analyst Mention**: In §20.5 Analyst Relations — are analysts spontaneously using the category name in their own research?
    *   **Competitor Adoption**: Are competitors adopting the category name in their own product descriptions? (The ultimate mimicry signal.)
*   **Anti-Pattern**: Treating category creation as "rebranding" is prohibited. Changing only the logo without changing anything in product, GTM, or ecosystem does not move a category. All four — technology, product, GTM, and ecosystem — must change in concert.

### 1.7. Strategic Narrative \& Founder-Led Sales Protocol
*   **Law**: The most powerful sales tool is not a PM or a Sales rep — it is the **Founder (or CEO)'s own Narrative**. Strategically construct and operationalize the "company's story" that moves investors, customers, candidates, and media.
*   **Strategic Narrative Structure**:
    The "Narrative Design" framework practiced by Tien Tzuo of Zuora and others:
    1.  **World Changed**: "XXX technology/social change has occurred" — declare an irreversible, massive shift.
    2.  **Winners and Losers**: "Those who embrace this change win; those who ignore it lose" — create urgency and binary opposition.
    3.  **Our Land**: "Therefore we have solution YY in category XX" — declare your position, linked to §1.6 Category Creation.
*   **Founder-Led Sales Protocol**:
    *   **CEO runs 100 calls before PMF**: Until PMF is confirmed (§1.2 Sean Ellis Test 40%), delegating to external sales is prohibited. The CEO personally acquires 20–50 customers and collects market signals first-hand.
    *   **60-Minute Rule**: The CEO devotes at minimum 4 hours/week (≈ 60 min/day × 4 days) to direct customer touchpoints (sales calls, user interviews, CS calls).
    *   **Sales Playbook Creation**: Document the first 10 success patterns as a "Sales Playbook" — the foundation for transitioning to the first sales hires. Include all slide, email, and demo frameworks in the Playbook to ensure narrative consistency.
    *   **Multi-Persona Narrative**: Pre-design distinct "narrative entry points" for End Users, Economic Buyers, and C-Suite respectively. The same feature requires different language for an engineer, a CFO, and a CEO.
*   **Anti-Pattern**: Delegating the narrative to sales and marketing is prohibited. The narrative generates trust precisely because the founder delivers it in their own voice — authenticity is lost the moment it is outsourced.

### 1.8. DACI Decision Protocol (Decision-Making at Scale)
*   **Law**: Once an organization exceeds 5 people, "who decides what" becomes ambiguous, causing decision delays, duplication, and accountability avoidance. Apply the **DACI (Driver / Approver / Contributor / Informed) framework** to all decisions to combine speed with quality.
*   **DACI Role Definitions**:

    | Role | Definition | Headcount Limit | Responsibility |
    |:-----|:-----------|:----------------|:--------------|
    | **Driver** | The accountable owner who drives the decision process and delivers a conclusion within the deadline | **1 person only** | Information gathering, issue framing, meeting facilitation, documentation of conclusion |
    | **Approver** | The decision authority who issues the final Go | **1–2 people only** | Grant final approval or exercise Veto |
    | **Contributor** | Stakeholders who provide expert input | Multiple | Provide input within the deadline; no decision authority |
    | **Informed** | Stakeholders notified of the outcome after the decision | Multiple | Receive notification only; no participation in the decision |

*   **DACI Process (Standard Decision Procedure)**:
    1.  **Framing**: The Driver documents the "Decision Question," "Deadline," and "Success Criteria" in a single page.
    2.  **Assignment**: DACI roles are explicitly assigned to all stakeholders and recorded in a DACI matrix.
    3.  **Input Collection**: Contributors submit inputs to the Driver within the deadline. Meetings are used for "converging opinions," not "sharing inputs."
    4.  **Decision**: The Approver evaluates the Driver's recommendation and pronounces Go / No-Go / Revise.
    5.  **Documentation**: The "decision, rationale, summary of opposing views, and next review timing" are recorded in one page and shared with all Informed parties.
*   **Decision Quality Standards (Anti-Patterns)**:

    | Anti-Pattern | Example | Correct Action |
    |:------------|:--------|:--------------|
    | **HiPPO (Highest Paid Person's Opinion)** | A senior leader's view is adopted without justification | Decisions are made on data and evaluation criteria, regardless of seniority |
    | **Analysis Paralysis** | Decision deferred because data is incomplete | Approver defaults to "decide on 70% information (Bezos principle)" |
    | **Consensus Requirement** | Decision withheld until everyone agrees | DACI explicitly grants the Approver final authority |
    | **Informed Skip** | Stakeholders are confused because they "didn't know" | DACI documentation shared with all Informed parties same day via Slack/Notion |

*   **Decision SLAs**:
    *   **Small Decision (1 Approver · impact < $10K)**: Decided within 24 hours
    *   **Medium Decision (2 Approvers · impact < $100K)**: Within 1 week
    *   **Large Decision (Board level · impact ≥ $1M)**: Within 1 month via a Stage-Gate process
*   **Anti-Pattern**: "Let's all decide together (Consensus Culture)" kills startup velocity. DACI is not Democracy — it is **distributed decision-making grounded in domain expertise**. Limiting the Approver to clearly 1–2 people is the key to productivity.

### 1.9. Strategic Partnership & Business Development Protocol
*   **Law**: The fastest lever for growth is not only building features yourself — it is also achieved by **"acquiring distribution channels, technical capabilities, and market trust through strategic partnerships."** However, partnerships are neither "insurance" nor "diplomatic courtesy." They must be managed and evaluated as **business assets with quantifiable ROI**.
*   **Partnership Type Matrix**:

    | Type | Purpose | Typical Examples | Primary KPIs |
    |:-----|:--------|:----------------|:------------|
    | **Tech Integration Partner** | Feature expansion, co-development | API integrations, co-build projects, SDK provision | ARR via integration / TTFAC reduction rate |
    | **Distribution Partner** | Expanding new customer acquisition channels | Resellers, OEM arrangements, marketplace listings | New ARR via partner / CAC ratio |
    | **Content / Ecosystem Partner** | Building awareness and authority | Joint whitepapers, events, certification programs | Share of Voice growth / Lead Volume |
    | **Strategic Investment Partner (CVC)** | Acquiring capital + distribution + technology in one | Fundraising from Corporate Venture Capital | ARR via partnership / Valuation impact |
    | **M&A / Acqui-hire** | Acquiring technology, talent, and customers in bulk | Linked to §20.7 M&A Playbook | Post-integration NRR / PMI completion time |

*   **Partnership ROI Evaluation Standards (Required)**:
    *   All partnerships must define "Projected ROI (Projected ARR Contribution / Cost)" **within 90 days** of signing.
    *   **Quarterly Review (Partnership QBR)**: Evaluate actual ROI vs. projected ROI. If underperforming, make a Renegotiate / Exit decision.
    *   Partners whose ROI falls **below 50% of target for 12 consecutive months** are classified as "Dormant Partners" and must be terminated or downgraded.
*   **BD (Business Development) Process Design**:
    1.  **ICP-Partner Fit (Compatibility Assessment)**: The partner's customer base must **overlap with your ICP by ≥ 70%** as a prerequisite to signing.
    2.  **Joint GTM Design**: Agree in writing on a joint GTM plan with the partner (who sells what, when, and through which channels). Oral commitments are prohibited.
    3.  **Technical Readiness Certification**: For integration-type partnerships, complete `Sandbox → Staging → Production` three-stage certification before making any public announcement.
    4.  **Legal & Commercial Review**: All partner contracts must be reviewed by legal counsel on five points before signing: exclusivity clauses, NDA, IP ownership, termination conditions, and renewal terms.
*   **Anti-Pattern**:
    *   **"Press Release Partnership" Prohibition**: Partnerships formed only for a press release drain resources from both parties. Ensure "a concrete mechanism for revenue contribution" is completed before the announcement.
    *   **Exclusivity Trap Avoidance**: Careless exclusive contracts with distribution partners can choke off competing channels. Exclusivity clauses are only permitted in exchange for **a guaranteed MRR commitment of $50K or more**.

---

## 2. Product Discovery & Positioning

### 2.1. Continuous Discovery Protocol
*   **Law**: Product development must not be a one-way pipeline of "Idea → Build → Release." It must be driven by **continuous dialogue with users (Continuous Discovery)** — following Teresa Torres's Opportunity Solution Tree methodology.
*   **Mandate**:
    *   **Weekly User Interviews**: Establish at least one opportunity per week to directly engage with target users.
    *   **Opportunity Solution Tree**: Systematize opportunities in a tree structure: "Desired Outcome" → "Opportunity" → "Solution" → "Experiment."
    *   **Hypothesis Log**: Record all hypotheses, validation results, and learnings for organizational reuse in decision-making.
*   **Anti-Pattern**: Treating user interviews as "feedback collection after completion" is prohibited. Discovery starts **before** building.

### 2.2. Jobs-to-be-Done Protocol (JTBD)
*   **Law**: Users don't buy "products." They "hire" products to solve a "Job to be Done." Use this JTBD framework as the foundation for all feature design.
*   **Job Statement Format**: `When [situation], I want to [motivation], so I can [expected outcome]`
*   **Pain Severity Scoring**: Quantify the pain severity of each Job (Frequency × Intensity × Current Solution Inadequacy) and prioritize the problems to solve.

### 2.3. Positioning Protocol
*   **Law**: A "good product" presupposes that it is "correctly communicated." Establish correct positioning using April Dunford's **Positioning Canvas**.
*   **5 Elements**:
    1.  **Competitive Alternatives**: What users do without this product
    2.  **Unique Capabilities**: Our characteristics that alternatives lack
    3.  **Value**: Specific benefits those capabilities bring to customers
    4.  **Target Customers**: The segment that values those benefits most
    5.  **Market Category**: The frame that sets context versus competitors
*   **Anti-Pattern**: "For everyone" is "for no one." Products without a clear target and position get buried in the market.
*   **Primary Persona**: Define the main target, including age range, region, device ratio, key challenges, and goals. Manage in the project-specific Blueprint and review quarterly.
*   **ICP Dynamic Management Protocol (Ideal Customer Profile — Dynamic Management)**:
    *   **Definition**: An ICP (Ideal Customer Profile) is "the set of characteristics of customers most likely to succeed and deliver the highest LTV." While a Persona describes demographics, an ICP defines **business and behavioral attributes** (B2B example: "50–200 FTE · SaaS spend ≥ $5K/mo · CTO with decision authority").
    *   **4-Axis ICP Design**:
        *   **Firmographic**: Industry, headcount, revenue size, geography, tech stack
        *   **Behavioral**: Purchase cycle length, current alternative tools, feedback response speed
        *   **Economic**: ACV range, WTP (§2.7), budget approval flow
        *   **Fit**: Does the product's core capability directly solve the customer's top-priority problem?
    *   **ICP Scoring**:
        ```
        ICP Score = (Firmographic Fit × 0.25) + (Behavioral Fit × 0.30)
                   + (Economic Fit × 0.25) + (Problem Fit × 0.20)
        Rate each axis 1–5 → Total ≥ 4.0 = "Ideal", 3.0–3.9 = "Acceptable", < 3.0 = "Non-ICP"
        ```
    *   **Dynamic Update Protocol**:
        *   **Quarterly Update Obligation**: Reconcile Win/Loss data (§17.2), NRR cohort analysis (§5.2), and VoC (§18.4) to revise the ICP definition.
        *   **ICP Drift Prevention**: If the initial ICP diverges from the actual customer base (e.g., designed for SMB but Enterprise is now 60%), immediately revisit GTM strategy, Packaging, and Pricing.
        *   **ICP Score Integration with Sales Pipeline**: Automatically assign ICP Scores to all CRM leads; as a default, prohibit deploying sales resources on leads with Score < 3.0.
    *   **Anti-Pattern**: Treating the ICP as "a document defined once at the start" is prohibited. The ICP must evolve as the market, product, and competitive landscape change.

### 2.4. Competitive Moat Protocol
*   **Law**: Temporary feature advantages are quickly replicated by competitors. Consciously design and strengthen sustainable competitive advantages (Moats).
*   **Moat Types**:

    | Moat Type | Description | Strengthening Method |
    |:----------|:------------|:--------------------|
    | **Network Effects** | Value grows as users grow | Invite features, community design |
    | **Data Moat** | Accumulation of training and behavioral data | First-party data strategy |
    | **Switching Cost** | High migration cost | Data integration, workflow deepening |
    | **Brand Moat** | Accumulated trust and recognition | Brand consistency, UGC utilization |
    | **Scale Economies** | Cost advantage from scale | Infrastructure efficiency, standardization |

*   **Mandate**: Annually evaluate the strength of each Moat and determine investment priorities.

### 2.5. Design Partner Protocol
*   **Law**: For B2B SaaS and complex consumer products, the most important pre-PMF asset is **"Design Partners who co-design with you and share the risk."** Designing based on market assumptions and validating afterward is a waste of resources.
*   **Definition of a Design Partner**:
    *   A small group of elite target users (typically 3–10 companies for B2B) who use your product without a formal contract and participate deeply in the co-design process as partners.
*   **Qualification Criteria (Who to Select as a Design Partner)**:
    1.  **Pain Urgency**: They have the problem you're solving most urgently (anyone who could wait is disqualified).
    2.  **Willingness to Give Feedback**: They have the time and willingness to provide feedback weekly or bi-weekly.
    3.  **Market Representativeness**: If they succeed, others in the same company type or user segment will also succeed.
    4.  **Willingness to Pay Later**: They are open to converting to a paid plan at an Early Adopter price.
*   **Operating Rules**:
    *   **Set Modification Boundaries**: Clearly distinguish between individual requests and generalizable requests so Design Partner asks don't turn your roadmap into a **custom factory**.
    *   **Progress Sharing Obligation**: Provide weekly/monthly Roadmap sharing sessions to Design Partners to foster co-ownership of the design.
    *   **Formalize the Pilot Plan**: Agree on "transition conditions toward paid conversion" upfront. Surprise monetization demands destroy trust.
    *   **Best Timing**: Most effective pre-PMF (fire-starting phase). Post-PMF, transition to GA (General Availability) model.
*   **Anti-Pattern**: Having more than **10 active Design Partners** simultaneously is prohibited. Broad feedback creates chaos and causes the product to lose its spine. Concentrate deep relationships on a small number of partners.

### 2.6. Market Sizing Protocol
*   **Law**: Abstract claims like "it's a huge market" do not move investor or management decisions. **Prove market size through bottom-up quantitative estimation.**
*   **Strict Definitions of TAM / SAM / SOM**:

    | Metric | Definition | Estimation Approach |
    |:-------|:-----------|:--------------------|
    | **TAM (Total Addressable Market)** | The theoretical entire market (a world where everyone uses your product) | Top-down (industry report reference) or Bottom-up (target company count × average price) |
    | **SAM (Serviceable Addressable Market)** | The market realistically reachable with today's product and geography | Narrow TAM to regions and segments your company can actually reach |
    | **SOM (Serviceable Obtainable Market)** | The market you can realistically capture within 3–5 years | From SAM, apply your GTM capacity and competitive share assumptions |

*   **Bottom-up Estimation Process (Mandatory)**:
    1.  **Identify Target Company/User Count**: Estimate from LinkedIn, industry directories, annual reports (e.g., Japanese SaaS companies with 50–500 employees ≈ ~8,000 companies).
    2.  **Set Penetration Rate**: Estimate "what % can we capture in 3 years" from competitive share and your GTM capacity (2–5% is realistic in the early phase).
    3.  **Calculate Average Contract Value (ACV)**: Derive from Design Partner WTP (Willingness to Pay) interviews (§2.5).
    4.  **SOM = Target Count × Penetration % × ACV** is the formula.
*   **Market Size Validation Rules**:
    *   **SOM ≥ $10M** is required to qualify as a business worth angel investment (VC investment typically requires SOM $100M+).
    *   Always calculate market growth rate (CAGR). Static markets have entrenched competitors and limit new entry opportunity.
    *   **Anti-Pattern**: The "world market is $1 trillion, capture 1% = $10 billion" top-down single-line calculation is instantly discarded by investors. Always include bottom-up evidence.

### 2.7. Pricing Discovery Protocol
*   **Law**: The answer to "what price should we set?" comes not from competitive benchmarking or gut feel, but from **scientifically discovering what customers are Willing to Pay (WTP)**. Before PMF, do not "set" a price — "discover" it together with your customers.
*   **WTP Discovery Methods (3 Techniques)**:

    | Method | Overview | Best-Fit Phase |
    |:-------|:---------|:--------------|
    | **Van Westendorp PSM** | 4-question survey identifying the acceptable price band via "too expensive / too cheap / expensive but acceptable / cheap and acceptable" | Pre-PMF – early stage |
    | **Gabor-Granger** | Present multiple price points and measure purchase intent at each — constructs a demand curve | Post-PMF / price revision |
    | **Conjoint Analysis** | Trade-off analysis combining price, features, and support level | SKU design / plan structure optimization |

*   **Implementation Protocol (Van Westendorp PSM — most immediately actionable)**:
    1.  **4-Question Script**: After showing a prototype or demo to Design Partners (§2.5) or Waitlist users, ask:
        *   Q1: At what price would this be too expensive and make you reconsider the purchase?
        *   Q2: At what price would it be so cheap that you'd question the quality?
        *   Q3: At what price is it expensive but you'd still consider buying?
        *   Q4: At what price does it feel cheap enough to be a great deal?
    2.  **Acceptable Price Range (APR)**: Locate the price band with no purchase barriers from the four-curve intersections.
    3.  **Optimal Price Point (OPP)**: The intersection of "too expensive" and "too cheap" curves identifies minimum resistance pricing.
*   **Pricing Discovery Principles**:
    *   **Price is a translation of product value**: Design price based on "the magnitude of the outcome customers receive" — not the number of features. Use an ROI Calculator (e.g., "This tool saves you XX hours/month → at $YY/hr, that's $ZZ/month in value") as a pricing rationale tool.
    *   **Price Anchoring**: Presenting the top-tier plan at a high price creates an "value" perception around the mid-tier plan. In a 3-Tier structure, weighting toward the 2nd Tier (Pro) is the standard approach.
    *   **Price Change Protocol**: Raising prices for existing customers requires **minimum 90-day advance notice** and a Grandfather period (locked-in pricing for existing customers). All price increase communications MUST be framed as "expanded value delivery" — never as "price going up."
*   **Anti-Pattern**: Setting price by saying "the competitor charges $X, so we'll charge $0.8X" ignores your own cost structure and value proposition, locking you into a permanently low-margin cycle.

### 2.8. Customer Advisory Board (CAB) Design Protocol
*   **Law**: A Customer Advisory Board (CAB) is a **strategic advisory body that systematically and periodically convenes representatives of your most critical customers to obtain direct input on product strategy, roadmap, and market direction**. If Design Partners (§2.5) are "co-designers before PMF," the CAB is "the strategic compass after PMF." In Enterprise B2B SaaS, a well-run CAB can directly influence procurement decisions.
*   **Three CAB Design Principles**:
    1.  **Elite & Small**: The optimal member count is **8–15**. Too many dilutes discussion; too few sacrifices diversity. Members should be executives (VP/CXO) from customers who "depend most on your product and can provide the most candid feedback."
    2.  **Strategic, Not Tactical**: The CAB is not a place for individual support tickets. Focus on **strategic-level discussions**: "How will the market change in a year?", "What are competitors doing?", "Does this roadmap direction create real value for our organization?"
    3.  **Reciprocal Value**: "Compensation" for CAB members is not cash — it’s **influence over your roadmap, early access, and a network of industry executives**. A clear commitment to "prioritizing our customers' voices" is the prerequisite for membership.
*   **CAB Operations Protocol**:
    *   **Cadence**: One full meeting (half-day to full-day format) per half-year (twice annually). Optional monthly lightweight consultations (30–60 min) with individual members.
    *   **Agenda Design**:
        1.  **Market Trends (25%)**: Participants share industry shifts and regulatory developments (shared by CAB members, not PMs)
        2.  **Roadmap Preview (35%)**: Share next 6–12 months of roadmap and collect reactions. Deep-dive on "what should be prioritized" and "does this create value for us?"
        3.  **Open Innovation (25%)**: Open session on "what problems remain unsolved?" and "what integrations would create value?"
        4.  **Action Items (15%)**: Mutual confirmation of CAB recommendations and PM-side commitments
    *   **Insight Capture and Implementation**:
        *   CAB meeting minutes are summarized by the PM team within 24 hours and incorporated into the roadmap decision process.
        *   When a CAB member’s suggestion is adopted into the roadmap, **individually notify** them that "your voice was reflected" (same Closed-Loop effect as §18.4).
*   **CAB Launch Timing**:
    *   **B2B SaaS**: When ARR reaches ≥ $500K AND 5+ Enterprise customers.
    *   **B2C**: When MAU exceeds 100K and Power Users (top 5%) can be organized.
*   **Anti-Pattern**: Operating the CAB as "a thank-you event for existing customers" is prohibited. The CAB is a strategic input mechanism — it cannot be substituted with golf outings or dinners.

---

## 3. Product Metrics Governance

### 3.1. Metrics Hierarchy Design
*   **Law**: Metrics must not be "measure everything." The **purpose and hierarchy** must be clear. Always design the following hierarchy:

    | Layer | Type | Description |
    |:------|:-----|:-----------|
    | L1 | **North Star Metric (NSM)** | The single most important metric representing product success |
    | L2 | **Driver Metrics** | 3–5 leading indicators that move the NSM |
    | L3 | **Counter Metrics** | Guardrails monitoring side effects of NSM improvements |
    | L4 | **Operational Metrics** | Team's daily metrics (velocity, etc.) |

*   **Anti-Pattern**: Managing only L4 metrics while the connection to NSM is invisible creates "metric islands" that mass-produce development with unclear ROI.

### 3.2. A/B Testing & Experiment Governance
*   **Law**: Feature effectiveness must be proven through **statistically validated experiments**, not gut feelings or intuition.
*   **Mandate**:
    *   **Statistical Significance**: p-value < 0.05 and statistical Power ≥ 0.80 are the minimum standards for experiments.
    *   **Minimum Sample Size**: Pre-calculate the desired effect size and required sample size. Judgment based on insufficient samples is prohibited.
    *   **Experiment Log**: Record all experiments as "hypothesis, results, learnings" and treat them as organizational knowledge assets.
    *   **Novelty Effect Caution**: New features tend to show inflated metrics from temporary excitement (Novelty Effect). Mandate a minimum run of **2+ weeks**.
*   **Anti-Pattern**: Extending experiments that show poor results "because the sample is too small" is prohibited. Judge upon reaching the pre-defined sample size.
*   **⚠️ Goodhart's Law Warning**: "When a measure becomes a target, it ceases to be a good measure" (Charles Goodhart). To prevent teams from gaming NSMs directly (e.g., artificially inflating DAU), always pair Counter Metrics with qualitative user interviews. Revisit each quarter whether numeric improvement genuinely reflects an increase in core customer value.

### 3.3. Behavioral Analytics Protocol
*   **Law**: Measure "what users DO" rather than "what users SAY."
*   **Event Taxonomy**:
    *   Adhere to unified naming for `page_view` / `feature_used` / `conversion` / `error_encountered` / `session_end`.
    *   Use `object_action` format for event names (e.g., `onboarding_completed`, `plan_upgraded`).
*   **Funnel Integrity**: Measure each step of the conversion funnel, identify the largest drop-off step, and run continuous PDCA improvement cycles.
*   **Detailed Implementation**: Refer to `ai/100_data_analytics.md`.

### 3.4. HEART Framework (User Experience Metrics)
*   **Law**: Measure not only pure business metrics but also **user experience quality** systematically. Adopt Google's HEART Framework.

    | Dimension | Description | Measurement Examples |
    |:----------|:------------|:--------------------|
    | **H**appiness | Subjective satisfaction | NPS, SUS, CSAT, App Store rating |
    | **E**ngagement | Depth and frequency of involvement | Session depth, feature usage frequency, DAU/MAU ratio |
    | **A**doption | New feature / new user adoption rate | Feature activation rate, onboarding completion rate |
    | **R**etention | Continued usage rate | D7/D30/D90 Retention, cohort churn rate |
    | **T**ask Success | Task completion rate and efficiency | Completion rate, error rate, time-on-task |

*   **Goals-Signals-Metrics (GSM) Process**: For each HEART dimension, define in 3 steps: "Goal → Signal → Metric". Prohibit metric collection without a corresponding goal.
*   **Timing**: Essential for pre/post comparison on new feature releases, measuring UX redesign impact, and benchmarking experience quality against competitors.

### 3.5. Instrumentation & Observability-as-Product
*   **Law**: "What you can't measure, you can't improve" — but "if you measure it, you can improve it" is an illusion. **Design the measurement architecture itself as part of product strategy** to build a reliable instrumentation layer that directly drives decisions.
*   **Instrumentation SLA**:

    | Data Type | Collection SLA | Precision Requirement |
    |:----------|:--------------|:---------------------|
    | **Business Critical** (conversion, billing events) | Real-time (≤ 5s latency) | Loss rate ≤ 0.1% |
    | **Product Behavior** (feature use, flow completion) | ≤ 5-minute buffer | Loss rate ≤ 1% |
    | **Performance** (Core Web Vitals, error rate) | Real-time | Loss rate ≤ 0.5% |
    | **Marketing Attribution** (UTM, channel) | ≤ 24 hours | Loss rate ≤ 5% |

*   **Event Schema Governance**:
    *   **3-Layer Schema**: Design events using three layers: `Global Properties (shared across all events)` / `Entity Properties (specific to the target object)` / `Event Properties (specific to that event)`.
    *   **Schema Registry**: Event definitions MUST be centrally managed in a **schema registry** (e.g., Segment Protocols, Amplitude Data Catalog), not scattered in code. Schema changes require a review equivalent to a pull request.
    *   **Breaking Change Policy**: Deleting existing events or renaming fields is a "Breaking Change" — mandate **30-day advance notice** and a coexistence period (because external dashboards and alerts will break).
*   **Data Trust Protocol**:
    *   **Instrumentation Tests**: Embed Unit Tests for Analytics events (e.g., "Does the checkout-complete event fire with the correct properties?") into the CI/CD pipeline.
    *   **Data Quality Dashboard**: Maintain a standing dashboard showing loss rate, duplication rate, and type error rate for measurement data — alert when thresholds are exceeded.
    *   **Sampling Audit**: When sampling is used, explicitly document the sampling rate and its implications in all analysis reports (to prevent invisible "measurement lies").
*   **Privacy-Safe Analytics**:
    *   **PII Scrubbing**: Only `user_id` (hashed) is permitted into the Analytics Layer. PII such as email address, name, or IP address MUST NOT flow into the measurement infrastructure.
    *   **Consent-Gated Tracking**: Tracking of GDPR/CCPA-subject users before obtaining consent is prohibited. Users who refuse consent are limited to "anonymous aggregate" data only.
    *   **Details**: Refer to `security/100_data_governance.md` and `ai/100_data_analytics.md`.

---

## 4. Monetization Strategy

### 4.1. Value-Based Monetization
*   **Law**: Place charging points not on "feature restrictions" but on **"expansion of value (usage, speed, advanced features)."** The best design is one where the more value users experience, the higher their willingness to pay.
*   **Freemium Design Principles**:
    *   Free users must not exceed the line where they "can experience value" (too-strong restrictions make PMF invisible)
    *   Design so users intuitively understand from the UI what changes with a paid plan (Upgrade Nudge)
    *   Free-to-paid conversion target: **2–5%**

### 4.2. Subscription Economics
*   **Recurring Revenue First (MRR/ARR First)**: Prioritize recurring revenue over one-time sales.
*   **Tiered Pricing**: Design an Upsell structure that grows with users (Basic / Pro / Enterprise).
*   **Metadata Segregation Protocol (Data-Driven Strategy)**:
    *   **Law**: Writing conditional branches in code like "if plan ID is this, then Enterprise plan" (Hardcoding) is a serious design mistake that damages business flexibility.
    *   **Action**: Plan properties should be stored in metadata (e.g., `is_enterprise: true`) in Stripe etc., and the application dynamically references these. This enables immediate response to business plan changes without deployment.
*   **The API Economy Alignment (Commercialization First)**:
    *   **Law**: Even internal APIs should be designed assuming future external sales (Monetization). Build in concepts of "Tier 1 (Public)" and "Tier 2 (Enterprise)" from the start.
*   **Usage Limit & Enforcement Protocol (Tier-based Limit Implementation)**:
    *   **Law**: Feature limits per subscription tier MUST be enforced on **both UI and backend**.
    *   **Server-Side Enforcement (SSOT)**: Limit validation MUST be done on Server Actions / RPC / DB Trigger side. Client-side-only limits risk being bypassed.
    *   **Guard Centralization**: Limit check logic must be centralized in `src/lib/guards/subscription-guard.ts` etc. DRY violation prevention.
    *   **Positive Upsell Messaging**: Turn limit-exceeded events into upgrade opportunities: "Free plan is limited to 1 item. Upgrade to Pro for unlimited."
*   **AI Credits Economy (AI-Native Billing Model)**:
    *   **Definition**: The "pre-purchased credits → consume deposit on AI feature calls" model adopted by OpenAI, Anthropic, and others. Best fit for products where AI token cost is the primary variable cost.
    *   **Design Principles**:
        *   **Credits ≠ Currency**: Credits abstract the conversion rate to real costs (tokens/API calls). Changes to the conversion rate require user notification at least **30 days in advance**.
        *   **Expiry Policy**: If unused credits have an expiration, this MUST be disclosed before purchase. Silent expiration constitutes a Dark Pattern (§12.1) and is prohibited.
        *   **Rollover Option**: Designs allowing monthly credits to roll over to the next month are effective at reducing churn and improving customer satisfaction (especially for B2B).
        *   **Transparency Dashboard**: A dashboard allowing users to view remaining credits, consumption rate, and per-feature breakdown in real time is mandatory.
    *   **Accounting & Tax Note**: Sales of prepaid credits are recorded as "Deferred Revenue" and recognized as revenue when consumed. Verify with legal counsel whether prepaid instrument regulations in relevant jurisdictions apply.

### 4.3. Ad-based Model
*   **User Experience First**: Integrate ads naturally as part of content in native ad format so they don't hinder UX.
*   **Transparency Obligation**: Ad content must always carry labels such as "PR" or "Sponsored," complying with advertising disclosure regulations of each country.

### 4.4. Advanced Pricing Models
*   **Law**: In SaaS and platform markets, a "flat subscription" is not always the optimal model. Select the pricing model that fits your business.
*   **Usage-Based Pricing**:
    *   **Definition**: A model where customers are billed in proportion to the resources they consume (API calls, storage, token count, etc.).
    *   **Best Fit**: User segments with high variability in consumption, or markets with high price elasticity.
    *   **Implementation Warning**: "Surprise billing" at month-end is one of the top causes of churn. Always provide a **two-stage system: Soft Limit (warning notification) → Hard Limit (feature shutdown)** paired with a consumption dashboard.
    *   **Circuit Breaker**: Provide a default opt-in setting that auto-stops when the estimated monthly cap is exceeded, maintaining customer trust.
*   **Outcome-Based Pricing**:
    *   **Definition**: A model that bills based on outcomes (e.g., costs reduced, leads generated, time saved).
    *   **Best Fit**: B2B SaaS where ROI is clearly measurable, or "Agentic Workflow" products where AI autonomously generates value.
    *   **Anti-Pattern**: Deploying without pre-agreement on outcome definitions and measurement methods with the customer invites measurement disputes and churn. Formalize "Outcome SLAs" in contracts, similar to reliability SLAs.
*   **Platform / Marketplace Pricing**:
    *   **Take Rate Design**: The core of marketplace take rate design is balancing supplier willingness to participate (too low = revenue infeasible) vs. buyer disintermediation risk (too high = buyers transact off-platform). A typical initial Take Rate target is **10–20%**.
    *   **Minimum Guarantee**: A minimum guaranteed payout to suppliers is effective for early supply-side acquisition, but carries risk of locking in fixed cost structures long-term. Plan to phase out systematically.

---

## 5. Unit Economics

### 5.1. Core Metrics

| Metric | Target Benchmark | Description |
|:-------|:----------------|:-----------|
| **LTV / CAC** | **≥ 3.0** | LTV must be 3x or more CAC. If not, marketing expansion = loss expansion |
| **Payback Period** | **≤ 12 months** (ideal ≤ 6 months) | Period to recover CAC |
| **Monthly Churn** | **≤ 3%** | Monthly churn rate. Reducing churn is more important than new acquisition |
| **Magic Number** | **≥ 0.7** | Net New MRR×12 / Previous Quarter S&M. SaaS sales efficiency benchmark |
| **NRR (Net Revenue Retention)** | **≥ 100%** | Is revenue from existing customers growing net positive? Expansion revenue health |

### 5.2. Cohort Analysis Protocol
*   **Law**: Aggregate retention numbers can "hide good cohorts." **Cohort-by-cohort LTV, churn, and engagement** must be analyzed.
*   **Retention Curve D30 Verification**: If D30 (30-day) retention is **> 20%**, it's an indicator that core value exists in the product (varies by industry). Prioritize churn improvement until the curve flattens.

### 5.3. Rule of 40 \& SaaS Health Dashboard
*   **Law**: SaaS company health is not judged by growth rate or profitability in isolation — it is evaluated through the composite benchmark **"Growth Rate + Profit Margin ≥ 40% (Rule of 40)."** This metric is the first evaluation criterion for investors, acquirers, and boards.
*   **Rule of 40 Formula**:
    ```
    Rule of 40 Score = Revenue Growth Rate (%) + FCF Margin (%)

    Example 1: Growth 50% + Margin -15% = 35 → Below benchmark
    Example 2: Growth 30% + Margin +15% = 45 → Healthy
    Example 3: Growth 80% + Margin -20% = 60 → Acceptable for high-growth phase
    ```
*   **Phase-Specific Targets**:

    | Phase | Target Rule of 40 Score | Notes |
    |:------|:------------------------|:------|
    | **Seed–Series A** | ≥ 40 (growth-weighted) | Acceptable to disregard profitability if growth ≥ 80% |
    | **Series B–C** | ≥ 40 (balanced growth + margin) | Stage where investors demand FCF improvement as growth rate matures |
    | **Pre-IPO / Public** | ≥ 40 mandatory; ≥ 50 is "top quartile" | Failing Rule of 40 ≥ 40 at IPO results in significant valuation discount |

*   **SaaS Health Dashboard (Metrics CEO and CFO must always monitor)**:

    | Metric Category | Metrics | §Reference |
    |:----------------|:--------|:-----------|
    | **Growth Efficiency** | ARR Growth Rate, Magic Number, CAC Payback | §5.1 |
    | **Revenue Quality** | NRR, Gross Margin, ARR/Employee | §5.1, §5.2 |
    | **Health Composite** | Rule of 40, Burn Multiple (Net Cash Burned / Net New ARR) | This section |
    | **Runway** | Monthly Burn Rate, Cash Balance, Runway (months) | §6.2 |

*   **Burn Multiple (Supplementary Metric)**:
    *   Complementary metric to Rule of 40: `Burn Multiple = Net Cash Burned / Net New ARR`
    *   **≤ 1.0**: Efficient ($1 cash burn generates $1+ of ARR growth)
    *   **1.5–2.0**: Average (investors begin scrutinizing)
    *   **> 3.0**: Danger zone (a concrete improvement plan is required)
*   **Anti-Pattern**: Treating Rule of 40 as a "fundraising-only number" is prohibited. Evaluate quarterly and always include in Board Updates.

### 5.4. Capital Efficiency Metrics
*   **Law**: Manage not just "how fast are we growing" but **"how much growth are we generating per dollar of capital invested."** Declining capital efficiency directly predicts worsening fundraising terms in the next round.
*   **Required Metric Set**:

    | Metric | Formula | Healthy Line | Danger Line |
    |:-------|:--------|:-------------|:------------|
    | **ARR per FTE** | Annual ARR ÷ Total Headcount | ≥ $150K (Series A) / ≥ $300K (Series B) | < $100K |
    | **Gross Margin** | (Revenue − COGS) ÷ Revenue | SaaS: ≥ 70%, AI-Native: ≥ 50% | SaaS < 60% |
    | **ARR/Burn** | Net New ARR ÷ Net Cash Burn (annual) | ≥ 1.0 ($1 burned generates $1+ ARR) | < 0.5 |
    | **Hype Ratio** | Total Capital Raised ÷ ARR | ≤ 5.0 (appropriate leverage) | > 10.0 |
    | **Sales Efficiency** | Net New ARR ÷ S&M Spend | ≥ 0.7 (equivalent to Magic Number) | < 0.5 |

*   **Gross Margin Profile Management**:
    *   **AI-Native GPU/API Cost Problem**: Products with large AI inference costs suffer compressed Gross Margins. Defend Gross Margin with **Model Caching, RAG-based token reduction, and model tiering (routing heavy vs. lightweight LLMs by task)**.
    *   **Target**: Even AI-Native products must have a plan to achieve **Gross Margin ≥ 60% by Series B**. Below 60%, you cannot attract SaaS-comparable multiples, and your value as a software company is impaired.
*   **Efficient Growth Score (EGS)**:
    ```
    EGS = NRR (%) + ARR Growth Rate (%) - Burn Multiple × 10
    
    Example: NRR 120% + Growth 80% - (1.5 × 10) = 185 → Excellent
    Example: NRR 90% + Growth 40% - (3.0 × 10) = 100 → Needs improvement
    ```
    *   EGS is an evolution of Rule of 40, evaluating the trinity of **"Customer Retention Power × Growth Velocity × Capital Efficiency"** in a single score.
*   **Cohort-Based Revenue Quality**:
    *   Track Gross Margin trends by cohort. If new cohorts show lower Gross Margin than older ones, this signals "discount-driven acquisition" or "influx of lower-quality customers."
    *   **Rule**: Review cohort-level Gross Margin reports quarterly. Three consecutive months of decline is an immediate trigger to revisit Pricing or ICP (Ideal Customer Profile).
*   **Anti-Pattern**: "It's fine to have low Gross Margin because growth is high" is a pattern frequently rejected at Series B evaluation as "Unit Economics don't work." Manage growth and revenue quality in parallel.

### 5.5. SaaS Revenue Recognition Protocol (ASC 606 / IFRS 15)
*   **Law**: Revenue recognition timing in a SaaS business is not "when you receive cash." **Revenue is recognized over the service delivery period based on the "satisfaction of performance obligations" under ASC 606 (US) / IFRS 15 (international).** Without this understanding, producing financial statements will trigger major accounting restatements in audits at Series A and beyond, destroying investor trust.
*   **SaaS-Specific Revenue Recognition Types**:

    | Revenue Type | Recognition Timing | Accounting Treatment |
    |:------------|:------------------|:--------------------|
    | **Subscription (monthly)** | Recognize each month services are delivered | Prepayments: next months go to Deferred Revenue |
    | **Subscription (annual)** | Recognize amortized monthly over 12 months | Full amount is Deferred Revenue at receipt; 1/12 transferred to revenue monthly |
    | **Implementation / Setup Fee** | Recognize based on % completion of implementation services | Identified as a separate performance obligation, or bundled with main service |
    | **Usage-Based** | Recognize in the period usage occurs | Monthly confirmed amount booked as current-period revenue |
    | **AI Credits Prepaid** | Recognize when Credits are consumed | Full amount is Deferred Revenue at purchase; transfer to revenue as consumed |
    | **Refund** | Reverse revenue at time of refund | If refund guarantee exists, estimate as Variable Consideration at contract inception |

*   **Deferred Revenue Management Protocol**:
    *   Annual subscription revenue requires distinguishing three separate concepts: **"cash received ≠ ARR ≠ recognized revenue"**.
    *   **MRR Monthly Roll Forward**: Track `Prior MRR + New + Expansion − Contraction − Churn = Current MRR` monthly to trace the "quality" of ARR.
    *   Deferred Revenue balance → Provides investors visibility into "backlog" of future revenue.
*   **Revenue Recognition Implementation Checklist**:
    *   [ ] Are "billing amounts" from Stripe/payment systems managed **separately** from accounting "revenue"?
    *   [ ] Is the Deferred Revenue balance for annual-pay customers accurately calculated monthly?
    *   [ ] Is the "ARR" used for NRR calculations based on ASC 606-defined recognized revenue?
    *   [ ] Are implementation fees identified as a separate "performance obligation" from the main service?
    *   [ ] Is Variable Consideration estimated to reflect refund policy?
*   **Cash Flow vs. Recognized Revenue (Series A Frequent Debate Points)**:
    *   When annual-pay customers surge, cash surges but recognized revenue is amortized. Investors separately review **"Billings (invoiced amount)"**, **"ARR (annualized)"**, and **"Revenue (recognized)"**. Conflated reporting instantly destroys capital market trust.
    *   **Dashboard Separation Requirement**: Finance dashboards MUST display "Billings / Revenue / Deferred Revenue" as **three separate columns always**, preventing conflation.
*   **Anti-Pattern**: "We received $120K annual prepayment so we booked the full amount as current-month revenue — ARR looked great" constitutes Revenue Recognition Manipulation. Full restatement in audit and loss of board trust is the maximum risk.

---

## 6. Finance & Cost Management

### 6.1. ROI-Driven Development
*   **Law**: Be conscious of ROI in all feature development and technology selection. Adopt not because "it's technically interesting" but because "it has business value."

### 6.2. Burn Rate Control
*   **Variable over Fixed Costs**: Utilize serverless architecture to bring idle costs close to zero.
*   **SaaS Diet**: Monthly inventory of SaaS contracts; immediately terminate those with < 20% utilization.
*   **Default Alive Principle**: Continuously ask: "Can we survive without fundraising at our current revenue and growth rate?"

### 6.3. FinOps Integration
*   Refer to `operations/600_cloud_finops.md` for detailed cloud cost management.
*   Refer to the AI FinOps section of `product/300_revenue_monetization.md` for AI token cost management.

---

## 7. Legal & Compliance

### 7.1. Fundamental Legal Requirements
*   **Terms of Service & Privacy Policy**: Must be established before service launch, with explicit consent flows (checkboxes, etc.) embedded in the UI. "Deemed consent" is absolutely prohibited.
*   **Local Commercial Laws**: When selling for a fee, strictly implement required disclosures per local laws (e.g., Japan's Tokusho-ho).
*   **Prepaid Instrument Regulations**: When issuing prepaid payment instruments (points, coins), always track the deposit obligation threshold in local currency and report to relevant authorities if necessary.

### 7.2. The Legal Hardcoding Ban (DB SSOT Mandate)
*   **Law**: Hardcoding legally binding text (Terms of Service, Privacy Policy, commercial law disclosures, etc.) into source code is **permanently banned (Universal Ban)** as it risks delayed corrections during legal changes.
*   **Action**:
    *   **DB First**: All legal documents MUST be saved in `site_settings` table or dedicated `fixed_pages` table.
    *   **Admin UI**: Standard implementation of a mechanism allowing non-engineers to immediately edit and publish via admin panel without developer involvement.
    *   **Risk**: A state where deployment wait occurs on the day of legal changes is "failure" in corporate compliance management.

### 7.3. Global Compliance
*   Refer to `security/100_data_governance.md` for GDPR / CCPA / EU AI Act compliance details.
*   Refer to `product/700_appstore_compliance.md` for App Store / Google Play compliance.

---

## 8. Organizational DNA Frameworks

### 8.1. Working Backwards (Amazon)
*   **Law**: Before writing code, write the "Press Release at completion" and "FAQ." Completely define what delights the customer and what questions they have, then develop backwards from there.
*   **Template**:
    ```
    [Product Name] enables [target] to solve [problem].
    [Primary benefit] [Supporting fact] [CTA]
    ```

### 8.2. Day 1 Philosophy (Amazon)
*   **Law**: Never rest on success; act every day as if it's the first day of the company. Maintain obsession with customers, commitment to results, and high-speed decision-making. Thoroughly eliminate Big Company Disease (Day 2: process-first, status quo, reliance on external signals).

### 8.3. Keeper Test (Netflix)
*   "If this team member (feature/code/library) said they were going elsewhere, would I fight to keep them?" If the answer is No, immediately delete and find a superior alternative. Compromise kills the product.

### 8.4. Context not Control (Netflix)
*   Rather than micromanaging excellent talent (including AI), provide the Context needed for judgment (purpose, background, constraints). "Waiting for instructions" is prohibited.

### 8.5. Behavioral Economics & Habit Formation
*   **Nir Eyal's Hook Model**: Consciously design the `Trigger → Action → Variable Reward → Investment` cycle to promote product habit formation.
    *   **External Trigger**: Trigger design via push notifications, email, etc.
    *   **Variable Reward**: Unpredictable value delivery (social feeds, random discoveries) creates stronger habits
    *   **Investment**: Users accumulate data, content, and connections, increasing switching costs
*   **IKEA Effect**: Users develop stronger attachment to products they have customized or built themselves than to ready-made products. Consciously design settings freedom and personalization.
*   **Anti-Pattern**: Habit formation via Dark Patterns (see §12) may temporarily improve KPIs but destroys long-term trust.

### 8.6. Shape Up (Basecamp)
*   **Law**: A **fixed-scope, 6-week-cycle development methodology** applicable to organizations where Scrum/SAFe is not working. Uses the concept of the "scope hammer" — when time runs out, cut scope instead of extending the deadline.
*   **Core Concepts**:
    *   **Appetite**: Decide upfront "how much time is this problem worth?" then design a solution that fits within that budget (reverse estimation). Never let the solution determine the timeline.
    *   **Betting Table**: Leadership curates "what to bet on" per 6-week cycle, not sprints. The backlog is not automatically prioritized — unmade bets simply die.
    *   **Cool-down**: A 2-week free period after each cycle for teams to resolve technical debt and explore the next set of challenges.
*   **When to Apply**: Particularly effective when team size exceeds 5 people, when Scrum ceremonies feel ceremonial rather than useful, or when product complexity makes up-front requirement definition impractical.

### 8.7. Product Packaging Architecture Protocol
*   **Law**: "Which feature belongs in which Tier" is a strategic decision of equal importance to pricing (§4). Poor packaging design creates **a growth ceiling where Free users never convert and Pro users never move to Enterprise**. Packaging is a core product strategy component — PMs must own and design it with intention.
*   **Good / Better / Best (3-Tier Design Principles)**:
    *   **Free / Starter (Good)**: Users can experience the product’s **core value** but growth is capped. Role: bring users inside. Include all `"show the value"` features. Place `"scale the value"` features behind a paywall.
    *   **Pro / Growth (Better)**: Enables maximum productivity for individuals or small teams. The primary revenue-generating Tier. **Designed to maximize ARPA.** Free users who hit their limits should naturally migrate here.
    *   **Enterprise (Best)**: Meets the security, administration, and compliance needs of large organizations. **SSO, audit logs, SLA guarantees, and custom contracts** are the primary differentiators. Pricing is often Quote-based (custom).
*   **Feature Fencing Design (Where each feature belongs)**:

    | Placement Rule | Description | Examples |
    |:-------------|:------------|:--------|
    | **Free Required Features** | Features enabling the Core Value Loop (§16) | Basic creation, viewing, sharing |
    | **Upgrade Trigger Features** | Experienced in Free, unlocked in Pro | Storage limits, team member count |
    | **Pro Differentiators** | Team productivity, automation, analytics | Advanced analytics, automated workflows |
    | **Enterprise-Only Features** | Administration, security, compliance | SSO, audit logs, custom SLA |

*   **Packaging Design Warning Signs**:
    *   **Value Leakage**: Placing too many Pro/Enterprise features in Free removes upgrade motivation. Symptom: Free → Pro conversion rate < 1%.
    *   **Tier Gap**: Migration from Free to Pro is blocked by "price shock" rather than feature addition. Symptom: "Free is enough but $99/month feels high" is a frequent objection.
    *   **Complexity Creep**: When there are 4+ Tiers, customers suffer comparison fatigue and drop out. Keep Tiers to 3 at most.
*   **Packaging Validation Protocol**:
    *   New packaging designs are reviewed by Design Partners (§2.5) and the CAB (§2.8) in advance.
    *   **Price-Value Audit (Quarterly)**: Survey customers on "Top 3 features delivering most value" per Tier and validate packaging placement appropriateness.
    *   **Tier Migration Analysis**: Track Free→Pro and Pro→Enterprise migration rates (Conversion Rate) by cohort; 3 consecutive quarterly declines trigger a packaging review.
*   **Anti-Pattern**: Packaging design as an afterthought — "engineering builds features, sales decides placement after" — is prohibited. Packaging must be decided **in parallel with feature design** and reflected consistently in UI upgrade CTAs and backend Guards (§4.2).

---

## 9. AI-Native Product Design Protocol

### 9.1. Responsible AI Feature Design
*   **Law**: When designing features using AI, design "reliability, transparency, and fairness" simultaneously with "convenience."

    | Design Principle | Content |
    |:----------------|:--------|
    | **Transparency** | AI-generated or recommended results must always be disclosed to users |
    | **Explainability** | Where possible, present the rationale for "why this was recommended" |
    | **Human-in-the-Loop** | High-risk decisions (medical, financial, legal) must always include human review |
    | **Graceful Degradation** | Design to say "I don't know" when AI is uncertain. Prevent over-reliance |
    | **Bias Awareness** | Recognize in design that training data bias can affect results |

*   **EU AI Act Compliance**: For high-risk AI systems (hiring, credit scoring, etc.), mandate the EU AI Act requirements (risk assessment, declaration of conformity, logging). → See `ai/000_ai_engineering.md` for details.
*   **Vibe Coding / Shadow AI Defense Protocol**:
    *   **Law**: Uncontrolled proliferation of AI code generation tools within the organization — known as "Shadow AI" — is a breeding ground for security vulnerabilities and technical debt.
    *   **Action**: AI-generated code MUST pass **security review and quality gates** before being merged to production. "Vibe Coding" — adopting AI-generated snippets just because they appear to work — is strictly prohibited.
    *   **AI Usage Policy (Mandatory)**: Define an organization-wide allowlist and blocklist for AI tools. Govern where product data and prompts are sent (in particular, prohibit sending sensitive data to external LM APIs without explicit approval).
*   **AI PM Role Definition (AI Product Manager)**:
    *   Products with AI-powered features MUST designate a dedicated or dual-role **AI PM**. Responsibilities: (1) Establish and regularly run an LLM evaluation framework (e.g., RAGAS), (2) Formalize hallucination rate and response quality as measurable KPIs, (3) Continuously track regulatory updates (EU AI Act, US Executive Orders) and maintain a compliance roadmap.

### 9.2. AI UX Design Patterns
*   **5 Types and Use Cases**:

    | Type | Description | Application |
    |:-----|:-----------|:-----------|
    | **Chat** | Conversational AI | Customer support bot |
    | **Copilot** | Assistive AI (suggestions, completion) | Code completion, document writing |
    | **Agent** | Autonomous AI (task execution) | Automatic scheduling |
    | **Ambient** | AI operating in background | Automatic classification, tagging |
    | **Proactive** | Preemptive AI (unsolicited suggestions) | Recommendations |

*   **Autonomy Dial**: The higher AI autonomy, the higher the risk. Set the dial at the appropriate position from "suggestions only" to "automatic execution" based on impact to users.
*   **Intent Preview**: Before an Agent executes multiple actions, present its plan to users and require approval.

### 9.3. AI Cost & Product Revenue Alignment (AI FinOps)
*   **Law**: AI token costs are "variable within variable costs." Understand the AI cost per feature and align it with the revenue model.
*   **30% Rule**: If AI costs **exceed 30% of revenue** from that feature, activate a Circuit Breaker to limit the AI feature or switch to an alternative. → See the AI FinOps section of `product/300_revenue_monetization.md`.

### 9.4. Agentic Commerce & the AI Agent Economy (2026/27+)
*   **Law**: From 2026 onward, AI Agents (OpenAI Operator, Google Agentspace, Anthropic Claude Computer Use, etc.) will autonomously execute purchasing, booking, and comparison tasks on behalf of users — ushering in the era of **Agentic Commerce**. Design for this shift **now**.
*   **Agent-Readable Interface Design**:
    *   **Structured Data First**: Provide machine-readable structured data via `schema.org` (Product, Offer, Review, Availability, etc.) to ensure AI Agents receive accurate, parseable information.
    *   **LLMs.txt Protocol**: Place a `/llms.txt` file at the site root to explicitly declare where AI Agents can find authoritative information about your product. → See `product/500_growth_marketing.md` GEO section.
    *   **MCP Server Readiness (Optional)**: Evaluate implementing an MCP (Model Context Protocol)-compliant server to enable future external AI Agents to call your product's APIs as first-class tools.
*   **Agentic Purchase Flow Design Principles**:
    *   **Deterministic Pricing**: When AI Agents conduct comparisons and purchasing decisions, ensure price, inventory, and specifications are available clearly and in real-time (vague "contact us for pricing" is fatal in the Agentic era).
    *   **Trust Signal Amplification**: AI Agents use trust signals (review star ratings, verified badges, response speed, etc.) as weighted inputs. Investing in §14's Review & Trust System directly translates to Agentic SEO competitive advantage.
    *   **Consent & Privacy for Agents**: Providing data to agents acting on behalf of users MUST be based on explicit user delegation (e.g., OAuth 2.0/PKCE). Unauthorized data sharing with agents is strictly prohibited.
*   **AI Safety Scorecard**:
    *   Before releasing any AI-powered feature, evaluate all 5 dimensions below. Release is prohibited unless all dimensions pass.

    | Evaluation Dimension | Pass Criteria |
    |:--------------------|:--------------|
    | **Hallucination Rate** | Hallucination rate on evaluation dataset ≤ 5% |
    | **Bias Test** | Output differential across demographic attributes (gender, race, region) ≤ 10% |
    | **Adversarial Robustness** | Prompt Injection attack success rate ≤ 1% |
    | **Privacy Leakage** | Zero unauthorized PII output (Red Team validation required) |
    | **Explainability** | Rationale for key recommendations/decisions can be disclosed to users |

    → For detailed implementation, refer to `ai/000_ai_engineering.md`.

### 9.5. AI Safety Governance & Risk Classification Protocol
*   **Law**: Treating AI systems merely as "convenient tools" is insufficient. Building a governance framework to **systematically classify and manage risk** is becoming a market entry requirement from 2026 onward.
*   **AI Risk Tier**:

    | Tier | Definition | Examples | Required Action |
    |:-----|:-----------|:---------|:----------------|
    | **Tier 0 (Prohibited)** | Unacceptable risk | Large-scale biometric surveillance | Development & deployment banned |
    | **Tier 1 (High Risk)** | Direct impact on rights/safety | Hiring AI, medical diagnosis, credit scoring | Full EU AI Act compliance, human oversight mandatory |
    | **Tier 2 (Medium Risk)** | Intentional user influence | Chatbots, recommendation systems | Transparency disclosure, hallucination mitigation |
    | **Tier 3 (Low Risk)** | Minimal societal impact | Spam filter, auto-tagging | Lightweight disclosure requirements |

*   **AI Incident Response Protocol**:
    *   For AI-caused incidents (biased output, PII leakage, misinformation spread, etc.), apply the following SLA:
    *   **Immediate (0–4 hours)**: Suspend the affected AI feature → Identify impact scope → Report to leadership.
    *   **Short-term (4–48 hours)**: Notify and apologize to affected users → Report to regulators (per applicable national law).
    *   **Long-term (48h+)**: Root Cause Analysis (RCA) → Model re-evaluation and correction → Implement recurrence prevention.
*   **AI Model Versioning & Rollback**:
    *   Manage the LLM model version in use via environment variables, with an established procedure to **roll back to the previous version within 5 minutes** if issues emerge.
    *   Model version changes are treated equivalently to "Feature Flags" and MUST follow staged rollout (§1.5 Ring Deployment).

### 9.6. Compound AI System Protocol
*   **Law**: From 2026 onward, **"Compound AI Systems"—combining multiple AI models, tools, and agents**—will become the standard enterprise AI design pattern, superseding single LLM prompting. Build product-level and technical readiness for this pattern into your design today.
*   **Compound AI System Components**:

    | Layer | Role | Implementation Examples |
    |:------|:-----|:-----------------------|
    | **Orchestrator** | Task decomposition, sub-agent delegation, result synthesis | LangGraph / CrewAI / AutoGen |
    | **Specialist Workers** | Specialist agents executing specific tasks | Search Agent, Code Agent, Judgment Agent |
    | **Tool Layer** | Access to external APIs and databases | Web Search / SQL / File System |
    | **Memory Layer** | Long-term memory, session management, RAG | Vector DB (Pinecone, pgvector) |
    | **Guardrails** | Output validation, safety filters, cost control | NeMo Guardrails / Custom Validators |

*   **Required Product Design Principles**:
    *   **Human Checkpoints**: Before an agent executes any external action (send email, place order, payment, etc.), a **user approval step** is mandatory. Design in conjunction with "§9.2 Intent Preview."
    *   **Deterministic Fallback**: Always implement a "deterministic fallback (rule-based processing)" for when agents fail or time out. Sole reliance on agents makes SLA compliance impossible.
    *   **Cost Ceiling**: Define a maximum AI cost per task (e.g., $0.10/request) and auto-stop on excess. Compound AI carries high cost explosion risk (apply §9.3 30% Rule).
    *   **Observability First**: Log every agent step, tool call, execution time, and cost as trace logs. Black-box agent behavior is impossible to debug.
    *   **Stateless Worker Design**: Each Agent Worker is stateless; the Orchestrator's State Machine centrally manages session state (for scalability and fault recovery).
*   **Anti-Pattern**:
    *   Designs that allow agents to "recursively self-call without limits" will cause cost explosions and infinite loops. Always set a maximum step count (e.g., `max_iterations=20`).
    *   Having agents execute external actions invisibly to users is a privacy risk (apply §9.4 Consent & Privacy for Agents).

### 9.7. AI Red Team & Adversarial Testing Protocol
*   **Law**: Before releasing any AI feature, a **Red Team exercise — where a dedicated internal team or external specialists attack the system and probe for vulnerabilities from an Attacker's perspective** — is mandatory. The AI Safety Scorecard (§9.4) is "normal-path evaluation"; Red Teaming is "abnormal-path and adversarial scenario evaluation."
*   **Red Team Obligation Triggers**:
    *   **Tier 1 (Mandatory)**: Before GA (General Availability) release of any new AI feature.
    *   **Tier 2 (Recommended)**: Model version upgrades / Significant prompt changes / Deployment to new user segments.
    *   **Tier 3 (Optional)**: Minor prompt tuning or UI-only changes.
*   **Mandatory Red Team Attack Scenarios**:

    | Attack Category | Test Scenario Examples | Pass Criteria |
    |:---------------|:-----------------------|:--------------|
    | **Prompt Injection** | Command hijacking via "Ignore previous instructions and..." | Success rate ≤ 1% |
    | **Jailbreak** | Bypassing safety filters via roleplay or hypothetical framing | Success rate ≤ 2% |
    | **PII Extraction** | Inducing leakage of training data or other users' PII | 0 incidents (zero tolerance) |
    | **Hallucination Weaponization** | Deliberately causing the model to generate and spread misinformation | Detection rate ≥ 95% |
    | **Data Poisoning** | Manipulating model behavior via user-input data | Manipulation success rate ≤ 0.1% |
    | **Denial of Service (Cost Attack)** | Continuously triggering intentionally high-cost AI calls | Circuit Breaker activation verified |

*   **Red Team Execution Process**:
    1.  **Scoping**: Explicitly document AI features to be attacked, user permission roles in scope, and the test period.
    2.  **Execution**: Combine manual Red Teaming by humans (creative attacks) with automated tools (Garak, PyRIT, etc.).
    3.  **Documentation**: Classify discovered vulnerabilities with a `CVSS for AI`-equivalent score and record all findings.
    4.  **Remediation Gate**: If even one Critical or High severity vulnerability remains, **physically block the release**.
    5.  **Re-test**: After remediation, a re-test using the same scenarios is mandatory to confirm effectiveness.
*   **Continuous Adversarial Monitoring**:
    *   Automatically monitor production for abnormal API call patterns, anomalous responses, and user reports — accumulate these as Attack Signatures.
    *   Monthly, add new attack patterns to Red Team scenarios and incorporate into recurring exercises.
*   **Anti-Pattern**: Treating Red Teaming as "Security's job only" is prohibited. The goal is to cultivate a "Security Mindset" — Attacker-perspective thinking — in everyone: PMs, designers, and engineers.

### 9.8. AI Agent Identity \& Authorization Protocol
*   **Law**: From 2026 onward, "Agentic Architecture" — where AI Agents call APIs "on behalf of users" — becomes the standard. **Designing an authorization layer that cryptographically verifies that an AI Agent is operating under legitimate delegation becomes mandatory.**
*   **Core Risks**:
    *   **Rogue Agents**: A malicious third party impersonates "the user's agent" to call APIs.
    *   **Over-Privileged Agents**: An agent with excess permissions over-acquires or manipulates data.
    *   **Privilege Escalation**: Via prompt injection, an agent executes actions outside its legitimate scope.
*   **AI Agent Authorization Implementation Requirements (Minimum Standard)**:

    | Requirement | Implementation | Rationale |
    |:------------|:---------------|:----------|
    | **Explicit Delegation Consent** | OAuth 2.0 + PKCE flow / OpenID Connect | User explicitly approves "this agent has permission to do X" |
    | **Principle of Least Privilege (PoLP)** | Design OAuth Scopes with fine granularity (e.g., `read:orders` only) | Grant agents only the minimum scope required for their function |
    | **Rich Authorization Request (RAR)** | RFC 9396-compliant context-aware authorization requests | Enables server to verify "what purpose" the agent is requesting permissions for |
    | **Session Time Limits** | Access Token TTL ≤ 15 min / Refresh Token TTL ≤ 24 hours | Limits hijacking risk of long-lived agent tokens |
    | **Action Audit Log** | All agent actions recorded in an Activity Log visible to users | Detecting anomalies and ensuring transparency to users |

*   **MCP (Model Context Protocol) Security Design**:
    *   When publishing an MCP Server, design `Tool-Level Permission` for each Tool invocation.
    *   **Tool Description Injection Prevention**: Establish a validation layer to catch cases where malicious instructions are embedded in MCP Tool Descriptions (add to §9.7 Red Team attack scenarios).
*   **Anti-Pattern**: The mindset of "giving agents broad permissions is more convenient" is prohibited. Minimizing the Blast Radius in the event an agent is compromised is the top-priority design principle.

### 9.9. LLMOps as Product Strategy
*   **Law**: The quality of LLM-powered product features is determined not by "which model you use" but by **"how you evaluate, monitor, and iteratively improve the model (LLMOps)."** Embed LLMOps at the core of product strategy — not as an engineering afterthought.
*   **Evaluation-Driven Development (EDD)**:
    *   **Principle**: Developing LLM-powered features means not "write prompt → deploy" but **"Evaluation Set → Improve Prompt → Validate Against Evaluation Set → Deploy"** as a repeating cycle.
    *   **Evaluation Set Design**:
        *   Prepare at minimum 100 (recommended: 500+) input → expected output pairs.
        *   Structure cases across four difficulty tiers: "Easy / Medium / Hard / Edge Case" — verify that improving Hard cases doesn't break Easy ones.
        *   Version-control the Evaluation Set in Git, exactly like production code.
    *   **Auto-Evaluation vs Human Evaluation Hybrid**:
        *   **LLM-as-Judge**: Embed a high-speed, low-cost automated evaluation pipeline (a separate LLM scores "is this a good response?") as the primary pipeline.
        *   **Human Eval**: Weekly, randomly sample outputs for human review to calibrate the accuracy of the LLM-as-Judge scoring.
*   **Prompt Version Control**:
    *   Prompts are code. **Manage them in Git.** When changes are made, always document the Evaluation Set score delta in the review comment.
    *   **Prompt Registry**: All production prompts MUST be centrally managed in a **Prompt Registry** (e.g., LangSmith, PromptLayer, Helicone). Direct injection via environment variables is prohibited as a **Prompt Debt** breeding ground.
    *   **Rollback SLA**: If evaluation scores degrade by 5% or more after a prompt change, an infrastructure capable of **rolling back to the prior version within 30 minutes** MUST be in place.
*   **Model Routing Strategy**:
    *   **Tiered Model Architecture**: Using the highest-performance model for every request is the worst-case cost architecture.

    | Tier | Model Examples | Application Scenario | Cost Ratio |
    |:----|:--------------|:--------------------|:-----------|
    | **Heavy** | GPT-4o, Claude Sonnet | Complex reasoning, document generation, high-value tasks | × 10–50 |
    | **Medium** | GPT-4o-mini, Gemini Flash | Standard classification, summarization, retrieval | × 1–5 |
    | **Light** | Embedding models, small SLMs | Keyword extraction, intent classification, post-cache processing | × 0.1–0.5 |

    *   **Routing Logic**: Design a Routing layer that automatically selects a Tier based on task complexity, expected quality, and cost ceiling (implement via rule-based logic or a lightweight classifier model).
*   **LLM Observability Stack**:
    *   Trace the following for every LLM call: `model_version` / `prompt_hash` / `token_in` / `token_out` / `latency_ms` / `cost_usd` / `eval_score`
    *   **P95 Latency SLA**: Target P95 latency for generative AI features **≤ 3 seconds** (the threshold at which users perceive a response as "slow"). When exceeded, respond with streaming output or model downgrade.
    *   **Cost per Feature**: Report LLM cost by feature monthly and reconcile against the §9.3 "30% Rule."
*   **Anti-Pattern**: "Using GPT-4 for everything guarantees quality" is an architectural anti-pattern that leads to cost explosions and inability to scale. Routing the right model to the right task is the foundation of a sustainable AI product.

### 9.10. AI Reasoning & Test-Time Compute Scaling Protocol
*   **Law**: "Reasoning Models" such as GPT-o1 / o3, Claude 3.7 Thinking, and Gemini Thinking implement a new paradigm called **Test-Time Compute Scaling** — improving answer quality by increasing the number of inference steps. These models operate on a fundamentally different design philosophy from standard LLMs. **Using them in the wrong context causes cost explosions and UX degradation**, making strict application criteria essential.
*   **Reasoning Model Application Decision Matrix**:

    | Task Characteristic | Reasoning Model | Standard LLM | Rationale |
    |:-------------------|:--------------:|:------------:|:---------|
    | **Complex math / logical reasoning** | ◎ Strongly Recommended | △ Insufficient | Chain-of-Thought significantly improves accuracy |
    | **Code generation (complex algorithms)** | ◎ Strongly Recommended | ○ Partial | Effective for debugging and edge case detection |
    | **Long document summarization** | △ Over-investment | ◎ Strongly Recommended | Contextual comprehension matters more than reasoning depth |
    | **User chat responses (low-latency requirement)** | × Prohibited | ◎ Strongly Recommended | Thinking Time severely degrades perceived performance |
    | **Strategic decision support** | ◎ Strongly Recommended | △ Insufficient | Multi-step hypothesis evaluation required |
    | **Templated content generation (emails, boilerplate)** | × Prohibited | ◎ Strongly Recommended | ROI doesn't justify the cost (over-engineering) |

*   **Thinking Budget Protocol**:
    *   Reasoning Models allow you to configure "reasoning depth" (Thinking Budget / Max Tokens for Thinking). Failing to configure this correctly can cause **costs to increase 10–100×**.
    *   **Tiered Budget Guidelines**:
        ```
        Light Thinking  (Budget: 1,024 tokens)  — Basic reasoning tasks
        Medium Thinking (Budget: 4,096 tokens)  — Complex problem-solving
        Deep Thinking   (Budget: 16,384 tokens) — Research, analysis, strategic planning (monthly tasks, etc.)
        ```
    *   When the budget is exceeded, a model bust-stopper must automatically fall back to a Standard Model (integrated with §9.3 Circuit Breaker).
*   **UX Protocol (Designing the Thinking Time Experience)**:
    *   Reasoning Models require **3–60 seconds** of thinking time before responding. How you frame this wait time to users determines experience quality.
    *   **Required Thinking UX Patterns**:
        *   **Streaming Thinking Summary**: Display thinking steps in real time such as "Analyzing XX…" or "Verifying YY…" (dumping complete internal thinking verbatim is prohibited).
        *   **Progress Indicator**: Show estimated time remaining or a progress bar to reduce user anxiety during the wait.
        *   **Early Exit Option**: If responses are delayed, provide a UX option allowing the user to "Retry in standard mode."
*   **Security Considerations (Reasoning Model-Specific Risks)**:
    *   Extended Thinking logs may contain system prompt content or user PII. **As a principle, thinking logs must not be stored in external storage.**
    *   Prompt Injection attacks (§9.7 AI Red Team) can be executed in more sophisticated ways against Reasoning Models. Apply input sanitization more stringently than for standard LLMs.
*   **Cost Monitoring KPIs (Required)**:
    *   Monitor "average Thinking Token consumption" per feature on a weekly basis.
    *   Integrate costs across all Reasoning Model features into §9.3's **30% Rule (LLM costs must not exceed 30% of Gross Margin)**.
    *   Account for Thinking Token costs separately from Input/Output tokens to maintain cost structure transparency.
*   **Anti-Pattern**: Indiscriminate adoption driven by hype — "Reasoning Models can solve all problems" — is prohibited. Applying Reasoning Models to chat, summarization, and templated generation tasks destroys both cost efficiency and UX. **"Knowing when NOT to use them" is the core of effective Reasoning Model deployment.**

---

## 10. Platform & Ecosystem Strategy

### 10.1. Platform Thinking
*   **Law**: Designing a product as a "platform where value is exchanged" rather than "a collection of features" enables network effects and extensibility.
*   **Platform Types**:
    *   **Marketplace**: Connecting demand and supply sides (e.g., Airbnb, Uber)
    *   **Developer Platform**: External developers can build on top (e.g., Stripe, Twilio)
    *   **Data Platform**: Value exchanged around data
*   **Cold Start Strategy**: Platform growth faces the "chicken-and-egg problem." Design the strategy to first acquire the supply side (e.g., businesses), which then attracts the demand side (e.g., users).

### 10.2. API-as-Product Protocol
*   **Law**: Design internal APIs assuming future external sales. This dramatically reduces the cost of "pivoting to sell APIs later."
*   **Design Tiers**:
    *   `Tier 1 (Public)`: Accessible to all, with rate limiting
    *   `Tier 2 (Partner)`: Higher rate limits and additional endpoints
    *   `Tier 3 (Enterprise)`: Dedicated SLA and custom integrations
*   **Developer Experience (DX)**: Treat the API as a "product"; provide documentation, SDK samples, and a sandbox environment as standard.
*   **Details**: Refer to `engineering/100_api_integration.md` and `operations/700_partnership_ecosystem.md`.

### 10.3. Network Effect Design
*   **4 Types of Network Effects**:

    | Type | Description | Design Guidance |
    |:-----|:-----------|:---------------|
    | **Direct** | Value grows for all users as users grow | Messaging, SNS |
    | **Indirect** | Growth of one side increases value for the other | Marketplace |
    | **Data** | AI accuracy improves as usage data grows | Recommendations |
    | **Platform** | Developer/partner participation creates value | Ecosystem design |

*   **Critical Mass**: Estimate the minimum number of users (Critical Mass) needed for network effects to occur and design a "subsidy strategy" (e.g., free provision to supply side) to reach it.

---

## 11. Data Product Strategy

### 11.1. Data as Asset
*   **Law**: Data generated by users is one of the most important strategic assets of the product. Design the collection, storage, and utilization of data strategically.
*   **Data Flywheel**: Consciously design the flywheel: `Data Collection → AI/ML Improvement → Enhanced Product Experience → User Growth → Even More Data`.
*   **First-Party Data Priority**: With the progressive deprecation of third-party cookies, the collection and use of first-party data (data obtained directly from users) is the top strategic priority.

### 11.2. Privacy-by-Design
*   **Law**: Treat privacy protection not as "post-hoc compliance work" but as "competitive advantage built into the design stage." User trust is the product's greatest asset.
*   **7 Principles (Ann Cavoukian's Framework)**:
    1.  **Proactive**: Preventive design, not reactive
    2.  **Privacy as Default**: Privacy-protecting settings by default
    3.  **Embedded**: Privacy built into design
    4.  **Full Functionality**: No trade-off between functionality and privacy
    5.  **End-to-End**: Protection throughout the data lifecycle
    6.  **Visibility**: Transparency to users
    7.  **Respect**: User-centric design
*   **Anti-Pattern**: "We added a GDPR banner" as the extent of privacy compliance is the minimum acceptable level. Make data minimization (collect only the minimum necessary data) a design principle.
*   **Details**: Refer to `security/100_data_governance.md`.

### 11.3. Data Monetization Protocol
*   **Law**: When monetizing data, **selling or externally sharing personal data without explicit user consent is absolutely prohibited**.
*   **Permissible Monetization Methods**:
    *   **Aggregated Insights**: Provide non-identifiable aggregated data as reports or industry analysis
    *   **AI Model Training**: Train models on data users have consented to, improving product value
    *   **Personalization**: Provide premium experiences using users' own data for personalization
*   **Data Trust Score**: Make "users feel comfortable entrusting their data to this product" the design target.

---

## 12. Sustainable & Ethical Product Design

### 12.1. Anti-Dark Pattern Protocol (Complete Prohibition)
*   **Law**: "Dark patterns" that deceive, manipulate, or confuse users to drive behavior are **completely prohibited in all forms**. While they may appear to improve short-term KPIs, they bring long-term user trust destruction and legal risk.

    | Dark Pattern | Example | Risk |
    |:------------|:--------|:-----|
    | **Roach Motel** | Easy to enter, difficult to cancel | FTC/DSA violation |
    | **Confirmshaming** | "No, I prefer to keep losing money" as a choice | Brand damage |
    | **Hidden Costs** | Additional fees revealed at final confirmation | CCPA/GDPR violation |
    | **Trick Questions** | Misleading checkbox design | User churn |
    | **Forced Continuity** | Auto-charging after free trial without notification | Consumer protection law violation |
    | **Social Proof Manipulation** | Fake stock counts, fake reviews | Unfair competition law violation |

*   **Legal Exposure**: Dark patterns face intensified regulation globally under EU Digital Services Act (DSA), FTC Act, consumer protection laws, etc. Compliance violations carry enormous fine risk.

### 12.2. Accessibility as Strategy
*   **Law**: Accessibility is not "consideration for people with disabilities" — it is a "market expansion strategy." 15% of the world's population (approximately 1.2 billion people) have some form of disability.
*   **Standard**: WCAG 2.2 AA level is the minimum compliance standard (legally mandated by EU European Accessibility Act (EAA) from 2025).
*   **SEO Impact**: Accessible semantic HTML directly contributes to SEO improvement.
*   **Detailed Implementation**: Refer to `design/000_design_ux.md` and `engineering/000_engineering_standards.md` §18.

### 12.3. Environmental Sustainability
*   **Law**: Cloud and AI energy consumption is scrutinized by investors and regulators as a corporate ESG metric.
*   **Green Engineering Metric (SCI: Software Carbon Intensity)**: `SCI = (E × I + M) / R`
    *   E = Energy consumption (kWh), I = Carbon intensity, M = Embodied carbon, R = Functional unit
*   **AI Carbon Cost**: Large-scale LLM execution has significant CO₂ emissions. Reducing unnecessary AI calls simultaneously achieves cost optimization and environmental contribution.
*   **Details**: Refer to `engineering/000_engineering_standards.md` §6 and the GreenOps section of `operations/600_cloud_finops.md`.

### 12.4. Responsible Scaling Policy (RSP)
*   **Law**: When a product grows rapidly and begins to wield significant social influence, it becomes necessary to formalize a **Responsible Scaling Policy (RSP) that consciously balances "the speed of expansion" with "social responsibility."** Anthropic's RSP is the most advanced public implementation of this concept.
*   **RSP Formulation Triggers (Begin formulation if ANY of the following apply)**:
    *   MAU **exceeds 1 million**
    *   The product is used in **high-risk domains such as healthcare, finance, education, legal, or hiring**
    *   AI features are at **Tier 1 (High Risk) or above** (→ see §9.5 AI Risk Tier)
    *   **A regulatory authority or media outlet has made inquiries**
*   **Mandatory RSP Contents**:

    | Section | Content |
    |:--------|:--------|
    | **Safety Level Definition** | Classify features/products by safety risk level (Tier 0–3 linked to §9.5) |
    | **Capability Thresholds** | Trigger lines: "if this capability is achieved, pause development and conduct a review" |
    | **Evaluation Protocol** | Pre-release safety evaluation process (§9.4 AI Safety Scorecard + §9.7 Red Team) |
    | **Incident SLA** | Response speed and designated owners for safety incidents (§9.5 AI Incident Response) |
    | **Third-Party Audit** | At least annually, an external safety audit organization reviews RSP compliance |

*   **RSP Publication Principle**:
    *   Publish the full RSP (or an executive summary) **publicly on your website** (e.g., Anthropic's public RSP). This builds transparency and trust with regulators, media, and users.
    *   Review and version the RSP at least annually (e.g., RSP v1.0 → v2.0).
*   **Anti-Pattern**: Letting the RSP be buried on the website as "legal department boilerplate" is prohibited. Actively deploy the RSP as a trust signal for brand strategy, recruiting, and investor communications.

### 12.5. DE&I as Product Strategy Protocol (Diversity, Equity & Inclusion)
*   **Law**: DE&I (Diversity, Equity & Inclusion) is not an HR policy issue — it is **the core of product strategy, determining who builds the product and for whom**. Teams lacking diversity embed cognitive biases into their products, excluding certain users and shrinking their own market opportunity.
*   **Inclusive Design Mandate**:
    *   **Design Target User**: When designing a product, explicitly define "the Hardest to Serve User" (the user with the fewest ability-related, economic, or geographic advantages) and use their requirements as the design standard. Meeting this bar produces a better design for all users (e.g., captions → also benefit all users in noisy environments).
    *   **Accessibility-First**: Integrated with §12.2 (Accessibility), WCAG 2.2 AA is positioned as the "starting point," not the "minimum bar."
    *   **Inclusive Language**: Gender-binary expressions in UI/copy (e.g., forcing "he/she"), and culturally or religiously exclusionary metaphors and idioms are prohibited. An **Inclusive Language Review** is conducted quarterly.
*   **AI Bias Audit Protocol**:
    *   Before releasing any AI features (recommendations, scoring, content moderation, etc.), you **must** evaluate outcome disparities across the following demographic axes:
        *   Gender / Age / Race & Ethnicity / Geography / Disability Status
    *   **Evaluation Criteria**: `False Positive Rate disparity ≤ 5%` and `False Negative Rate disparity ≤ 5%` across demographic groups constitutes a passing standard.
    *   Features that fail to meet the criteria are **automatically blocked** from release. Bias mitigation (resampling, reweighting, or architectural changes) must be applied before re-evaluation.
*   **Diverse Team Composition KPIs**:

    | Metric | Scope | Target (Phased Goal by 2027) |
    |:-------|:------|:---------------------------|
    | **Gender Diversity** | All Engineering, PM, and Design roles | Women & non-binary representation ≥ 40% |
    | **URG (Underrepresented Group) Ratio** | All roles | Within ±10% of regional labor force representation |
    | **Pay Equity Audit** | Same role & level compensation gaps | Disparity by gender & race ≤ 5% |
    | **Inclusive Leadership** | Director-level and above positions | URG leader ratio ≥ 30% |

    *   These KPIs must be measured annually and reported in **CXO-level reports** — and progressively **disclosed publicly**.
*   **DE&I × GTM Strategy Integration**:
    *   Marketing campaigns, visuals, and case studies must consciously reflect a diverse range of user archetypes (the "default bias" of featuring only white male engineers is prohibited).
    *   In partnership decisions (§1.9) and vendor selection, incorporate DE&I commitment as an evaluation criterion (recommended weight: ≥ 10%).
*   **Anti-Pattern**:
    *   **"Diverse hiring = DE&I complete" misconception**: Hiring diverse team members without building an inclusive decision-making culture and career pathways results in high attrition and zero ROI on the investment. Hiring is only the "first step" of DE&I.
    *   **Performative DE&I Prohibition**: DE&I statements on social media and diversity-themed campaigns that mask internal inequities and injustice function as "washing" and are not tolerated. Progress disclosure based on measurable indicators is proof of integrity.

---

## 13. Search & Discovery Architecture

> [!NOTE]
> This section provides design guidance from a product strategy perspective. Refer to `engineering/200_supabase_architecture.md` for implementation specification details.

### 13.1. Tag-Based Attribute Protocol
*   **Law**: Variable attributes of entities (products, stores, articles, etc.) MUST be structured as **Tags (M:N relations)** rather than adding dedicated columns.
*   **Anti-Pattern**: Proliferating Boolean columns like "supports_feature_A" is prohibited as it causes schema bloat and query complexity.

### 13.2. Structured Business Hours Protocol
*   **Law**: Business hours MUST be managed as **structured data in JSONB format**, not free text. Internal storage uses UTC as the standard, converting at display time.

### 13.3. Search Freshness SLA
*   **Standard**:
    *   **Critical Data** (inventory, price, status): Reflected in search index within **5 minutes**
    *   **Content Data** (descriptions, images): Reflected within **1 hour**

### 13.4. Multi-Factor Ranking Protocol
*   **Law**: Search result ordering MUST be determined by **multi-factor scoring**, not simply by registration date.

    | Factor | Description |
    |:-------|:-----------|
    | **Review Score** (Bayesian Average) | Bayesian Average from §14.1 |
    | **Completeness** | Image count, description quality, attribute fill rate |
    | **Freshness** | Recency of last update |
    | **Engagement** | Favorites, views, inquiries |
    | **Proximity** | Distance from user's current location |
    | **Sponsored Boost** | Score addition via paid advertising (requires "Sponsored" label) |

---

## 14. Review & Trust System

> [!NOTE]
> This section provides design guidance from a product strategy perspective. Refer to `engineering/200_supabase_architecture.md` for implementation specification details.

### 14.1. Bayesian Average Protocol
*   **Law**: For aggregating review ratings, use **Bayesian Average** instead of simple arithmetic mean.
*   **Formula**: `bayesian_score = (C × m + Σ(ratings)) / (C + n)` (C: confidence threshold, m: global average, n: review count)
*   Mitigates bias from small review samples for fair display.

### 14.2. Pre-Moderation Protocol
*   **Status Flow**: `pending → approved / rejected`
*   Only `approved` reviews displayed publicly. Entity owners posting reviews on their own entities are systematically blocked.

### 14.3. Immutable Deletion Protocol
*   Once published, review data MUST use **Soft Delete** as standard; physical deletion is prohibited. Retained for aggregate score integrity and irregular operation auditing.

### 14.4. Automated Spam Filter
*   Apply a multi-layer filter combining burst posting detection, template detection, URL/contact injection, and prohibited word dictionaries. Use LLM-based semantic spam detection to reduce false positive rates.

### 14.5. Progressive Trust Level Protocol

| Level | Conditions | Privileges |
|:------|:-----------|:-----------|
| **Lv.0 (New)** | New user | All posts require approval |
| **Lv.1 (Verified)** | Identity verified + N approved posts | Text posts published immediately |
| **Lv.2 (Trusted)** | Lv.1 + MFA + M posts + no report history | Image posts published immediately |

Define specific thresholds (N, M) in the project-specific Blueprint.

### 14.6. User Report Protocol
*   **Response SLA**: Complete initial judgment (maintain display or temporarily hide) within **24 hours** of report.
*   When deleting UGC, notify the poster of the reason and provide an opportunity for appeal (within 14 days).

### 14.7. UGC Submission Rate Limits

| Limit Type | Threshold Example | Violation Response |
|:-----------|:-----------------|:------------------|
| Same entity submission | 1 per 365 days | Allow updates only |
| Overall posting frequency | 5 per 24 hours | Queue excess submissions |
| New account restriction | 2 posts within 72 hours of registration | Linked with Progressive Trust (§14.5) |
| Bot detection | CAPTCHA/challenge auth required | Block submission on failure |

---

## 15. Interactive Engine

> [!NOTE]
> This section provides design guidance from a product strategy perspective. Refer to `engineering/200_supabase_architecture.md` for implementation specification details.

### 15.1. Unified Interactive Schema
*   **Law**: Interactive content such as polls, diagnostics, quizzes, and surveys MUST be managed using a **unified schema (Polymorphic Pattern)** rather than individual tables.
*   **Single Table**: Use an `interactive_contents` table with a `type` column (`poll`, `quiz`, `survey`, etc.), storing questions and options in JSONB.
*   **Deterministic Logic**: Implement result calculation algorithms as **deterministic (score-based, etc.), not random.** Ensure reproducibility of results for the same inputs.

---

## 16. Growth Loop Design Protocol

### 16.1. Growth Loop vs. Funnel
*   **Law**: Transition from the traditional **"funnel thinking" (linear, leaky)** to **"loop thinking" (self-reinforcing cycles)**. A funnel is a one-way linear flow; a loop is a self-compounding growth engine where outputs feed back as inputs.
*   **Definition**: `Input → Action → Output → Reinvestment → More Input`
*   **Anti-Pattern**: Relying exclusively on a paid acquisition loop ("spend more on ads → get more users") degrades LTV/CAC, creates a fundraising-dependent business model, and is strategically fragile. Designing a sustainable, self-reinforcing loop is mandatory.

### 16.2. Growth Loop Archetypes

    | Loop Type | Mechanism | Examples |
    |:----------|:---------|:--------|
    | **Viral Loop** | User invites friend → Friend becomes user → Friend invites more | WhatsApp, Slack |
    | **Content Loop** | User creates content → SEO/social attracts new users → New users create content | Pinterest, Reddit |
    | **Product-Led Loop** | Free use → Value experienced → Shared with team → Team members join | Notion, Figma, Loom |
    | **Community Loop** | Users gather → Community creates value → Community attracts new users | Duolingo, Stack Overflow |
    | **Data Loop (AI-Powered)** | Usage data grows → AI model improves → Experience improves → More usage | Spotify, Netflix |
    | **Paid Loop** | Ad spend → New users → Revenue → More ad spend | Requires LTV/CAC ≥ 3 as a prerequisite |

*   **Compound Loops**: The best products in the world combine multiple loops. Example: Notion runs a "Product-Led Loop" PLUS a "Content Loop" (template gallery).

### 16.3. Growth Loop Design Protocol
1.  **Identify the Loop**: Decompose existing growth drivers and identify loops already in motion. Visualizing loops you didn't consciously design is the starting point.
2.  **Measure Cycle Time**: Measure how long one complete loop cycle takes. Shorter is better (e.g., Viral Loop: invite-to-signup ideally in hours).
3.  **Measure Loop Efficiency (Virality / K-factor)**:
    *   **K-factor**: `K = (invites sent per user) × (invite conversion rate)`
    *   K ≥ 1.0 = exponential (viral) growth; K < 1.0 = linear growth (paid channel required to supplement)
    *   K = 0.5 is still sustainable if CAC is recovered within the Payback Period
4.  **Identify and Fix the Bottleneck**: Measure conversion at each step of the loop. Focus improvement resources on the lowest-converting step first.
5.  **Stack Loops**: Once a single loop is stable, design and connect additional loops to compound growth.

### 16.4. Product-Led Growth (PLG) → Product-Led Sales (PLS) Transition Protocol
*   **Law**: Once PLG is operating, evolve expansion into large accounts (Enterprise) from "sales-led" to **"product-data-led"** via PLS — not the inverse.
*   **Product Qualified Account (PQA) Definition**:
    *   A PQA is an account whose product usage data signals readiness for sales engagement.
    *   **PQA Signal Examples**: `5+ active users` + `Core feature used 3+ times/week` + `Approaching usage limit` + `Domain matches enterprise.com pattern`
    *   PQA scoring is defined in the project Blueprint and synced to CRM.
*   **PLG → PLS Transition Criteria**:
    1.  **10+ PQAs consistently identified per month**
    2.  **Average self-serve ARPA exceeds $2,000/year** (signals organizational expansion headroom)
    3.  **NRR (Net Revenue Retention) ≥ 110%** (proof that existing customers are expanding autonomously)
*   **Evolving the Sales Role**: In a PLS motion, Sales doesn't "sell" — they **maximize opportunities that the product has already created**. Core activities shift to: responding to inbound PQAs, customization negotiation, and demoing Enterprise features.

### 16.5. Minimizing Activation Energy
*   **Law**: To spin growth loops faster, minimize the **"startup cost" (activation energy)** at each stage of the loop.
*   **Aha! Moment Protocol**:
    *   **Definition**: The first moment a user experiences the product's core value (e.g., for Slack: the instant you realize your inbox reply time just dropped dramatically).
    *   **Measurement**: Analyze cohorts to compare LTV top-quartile users vs. churned users on whether an "Aha! Moment" occurred.
    *   **Time-to-Value (TtV)**: Measure the time from user registration to their Aha! Moment. Make shortening TtV the top-priority KPI.
    *   **TtV Targets**: Consumer apps ≤ 5 minutes; B2B tools ≤ 1 session (within 24 hours).
*   **Onboarding Loop**: Design new user onboarding explicitly as a growth loop. Intentionally architect the sequence: `Sign Up → Aha! Moment → First Success → Share with Friends/Colleagues → Invite` — and measure conversion at each step.

### 16.6. Retention Loop Design
*   **Law**: Pouring water (new acquisition) into a leaky bucket (high churn) is futile. **Fix the retention loop first, then accelerate growth.**
*   **Retention Improvement Priority Order**:
    1.  **Day 1 Retention**: Re-visit rate on day after signup (Target: Consumer ≥ 40%, B2B ≥ 60%)
    2.  **D7 Retention**: 7-day survival rate (Target: Consumer ≥ 20%, B2B ≥ 40%)
    3.  **D30 Retention**: 30-day survival rate (Target: > 20% is a signal that core value exists)
    4.  **Resurrection Rate**: Rate at which churned users return. Design resurrection loops via email sequences and new feature notifications.
*   **Habit-Forming Frequency**: Every product requires a minimum usage frequency for the product to become a habit.
    *   **Daily Habit**: Social, health apps (DAU is the core metric)
    *   **Weekly Habit**: Productivity tools, B2B apps (WAU/DAU ratio matters)
    *   **Monthly/Event-based**: Travel, finance (conversion rate and LTV are priorities)
    *   Accurately identify your product's natural usage frequency and align NSM to that frequency.

### 16.7. Community-Led Growth (CLG) Protocol
*   **Law**: Community-Led Growth (CLG) is a growth model where users experience, share, and teach each other about product value—making **the community itself the most powerful channel for acquisition, retention, and expansion**. Slack, Figma, Notion, and Duolingo are the benchmark examples.
*   **CLG vs PLG vs SLG Definitions**:

    | Model | Core Driver | Examples |
    |:------|:-----------|:--------|
    | **PLG (Product-Led)** | Self-service product experience | Notion, Dropbox |
    | **SLG (Sales-Led)** | Human-driven sales | Salesforce, SAP |
    | **CLG (Community-Led)** | Sense of belonging and peer learning | Figma, Canva, HubSpot |

*   **CLG Design Principles**:
    1.  **Community ≠ Forum**: A simple Q&A forum is not a community. The core is a design where **members feel recognized and grow through contribution**.
    2.  **Power User (Ambassador) Program**: Identify users who contribute most to the community and grant them special status (badges, early access, direct feedback channels).
    3.  **Perpetualize User-Generated Content (UGC)**: Publish templates, tutorials, and case studies as SEO assets, linking them to your Content Loop.
    4.  **Community KPIs (Community Health Metrics)**:
        *   **Active Community Rate**: Monthly posts / Total members ≥ 20%
        *   **Peer Answer Rate**: Percentage of questions answered by members rather than staff ≥ 60%
        *   **Community-Sourced NPS**: NPS delta between community participants vs non-participants (Target: ≥ +15pt)
*   **CLG Preconditions**:
    *   Core product retention (D30 > 20%) must be stable.
    *   At least **1,000 Monthly Active Users** (minimum density for community self-sustenance).
    *   A dedicated or part-time **Community Manager** must be in place.
*   **Anti-Pattern**: Treating community solely as a "support cost reduction tool" is prohibited. Investment in community is a long-term asset for LTV improvement.

### 16.9. Referral \& Affiliate Program Design Protocol
*   **Law**: As proven by Dropbox (500MB per referral) and Airbnb (travel credit per referral), referral programs are one of the **most capital-efficient acquisition channels**. When virality is inherent in the product, designing it intentionally enables compound growth without paid advertising.
*   **Referral vs. Affiliate — Definitions and Use Cases**:

    | Type | Referrer | Incentive Structure | Optimal Use Case |
    |:-----|:---------|:--------------------|:----------------|
    | **Referral Program** | Existing users | Double-sided reward (both sides) | B2C · PLG SaaS · Consumer apps |
    | **Affiliate Program** | Content creators · Media | One-sided commission (referrer only), often revenue-linked | B2B SaaS · High-ASP products · Niche markets |

*   **Referral Program Design Protocol**:
    1.  **Double-sided Reward**: Provide value to both the referrer and the new user (e.g., Dropbox: "Referrer +500MB, Referred +250MB"). Single-sided rewards significantly reduce conversion rates.
    2.  **Product-in-Value Priority**: **Product-intrinsic value (storage expansion, free credits, plan extension)** is more cost-efficient than cash and deepens product loyalty.
    3.  **Milestone Referral**: An escalating reward structure as referral count grows (1 → A, 5 → B, 10 → C) habituates referral behavior.
    4.  **Referral UX Optimization**:
        *   Generate the referral link immediately after the **Aha! Moment** (§16.5) post-registration — when engagement is at its peak.
        *   Place a short URL easy to copy alongside SNS share buttons (WhatsApp / LINE / X etc.) on the same screen.
        *   **Mobile Deep Link**: For mobile apps, implement a Deep Link that auto-pairs the referral link → direct app launch.
*   **Affiliate Program Design Protocol**:
    *   **Commission Structure Selection**:

        | Structure | Description | Optimal Condition |
        |:----------|:------------|:-----------------|
        | **CPA (Cost Per Acquisition)** | Fixed amount per paid conversion | SaaS where conversion is clearly trackable |
        | **Revenue Share** | A % of the referred customer's monthly billing (e.g., 20%/mo, up to 12 months) | B2B SaaS with high LTV |
        | **Hybrid** | Initial CPA + ongoing Revenue Share | High LTV × retention of strong affiliates |

    *   **Affiliate Selection Criteria (Quality over Quantity)**:
        *   **ICP Audience Overlap**: The overlap between §2.3 ICP and the affiliate's audience attributes is the top evaluation criterion. Follower count is secondary.
        *   **Content Authority**: Verify domain expertise and past content quality in the product category. "Promote anything" generalists produce low quality and low conversion.
    *   **Anti-Fraud**:
        *   Systematically detect and block self-referrals and fake-account referrals (IP lookup, device fingerprinting, payment method deduplication).
        *   Confirm and pay commissions **after a 30-day return window** to avoid refund risk.
*   **Measurement KPIs**:
    *   **Referral Conversion Rate**: Referral link click → paid conversion rate (target: ≥ 15%)
    *   **Viral Coefficient (K-factor)**: Integrated K-factor including §16.3 conversions via referral program
    *   **Referral CAC**: Program cost ÷ conversions via referral (compare monthly vs. other channel CAC)
    *   **Referral NRR**: Verify that the NRR of the referred cohort exceeds the non-referred cohort (quality referrals produce quality customers)
*   **Legal & Compliance**:
    *   Affiliate and referral program content is subject to **advertising disclosure obligations** in each jurisdiction (see §20.6).
    *   Commission income is taxable for affiliates — verify issuance obligations (1099 / withholding statements, etc.) with legal counsel in advance.
*   **Anti-Pattern**: Designing referral incentives as "cash only" attracts low-quality users who will churn once they receive the payment. Tying incentives to product-intrinsic value ensures both referrers and referred users are designed to "earn more the longer they stay."

### 16.10. Developer Relations (DevRel) as a Growth Channel Protocol
*   **Law**: For products that provide APIs, platforms, or developer tools, **investing in developer community trust and infrastructure (Developer Relations: DevRel) is a compound-output growth engine capable of simultaneously achieving acquisition, retention, and ecosystem expansion**. Twilio, Stripe, and HubSpot are the benchmark cases that achieved market de-facto status through this strategy.
*   **DevRel Pillars**:

    | Pillar | Content | Primary Outcome |
    |:------|:--------|:---------------|
    | **Developer Experience (DX)** | SDK, Docs, API quality | Time-to-First-API-Call ≤ 5 min |
    | **Community Building** | Developer community design | Community-Sourced resolution rate ≥ 60% |
    | **Technical Content** | Tutorials, case studies, open source | Organic Traffic & GitHub Stars |

*   **Time-to-First-API-Call (TTFAC) Protocol**:
    *   **Definition**: The time from when a developer first touches your documentation to when they successfully make their first API call.
    *   **Target**: **≤ 5 minutes**. Stripe proved that "receiving a payment in 7 lines of code" directly correlates TTFAC reduction to business growth.
    *   **Design Principle**: Always provide a `Hello World tutorial` for beginners. This tutorial is the Aha! Moment where developers feel "It works!"
*   **Developer Content Strategy**:
    *   **Tutorials**: "How to implement XX" format. Provide per language/framework to capture SEO traffic.
    *   **Recipe / Cookbook (Use Case Patterns)**: "I want to do this, here’s how to achieve it with our service" format. Easily discovered by active developers.
    *   **Changelog**: Communicate API changes and new features clearly to developers. Directly linked to active developer retention.
    *   **Open Source Strategy**:
        *   Publish peripheral libraries and tools of your core functionality as OSS, designing "Bottom-up distribution" anchored by GitHub Stars (Hashicorp, Grafana model).
        *   **OSS → Commercial Conversion**: Provide OSS as a free, excellent tool → monetize enterprise features, support, and permissions network via the "Open Core Model" — the approach with the fewest side effects.
*   **DevRel KPIs**:
    *   **TTFAC**: Target ≤ 5 minutes
    *   **Docs NPS**: Documentation satisfaction. Target ≥ +40pt
    *   **API MAU**: % of developers who begin active use within 90 days of API key issuance
    *   **SDK Adoption Rate**: Usage share and growth rate per language SDK (Node/Python/Go, etc.)
    *   **Community Health**: Answer rate and MTTR (Mean Time to Resolution) on Stack Overflow / GitHub Issues
*   **DevRel Launch Timing**:
    *   **Developer Launch**: Begin documentation, community, and feedback programs 3 months before API/platform products are scheduled for Public Beta.
    *   **Responsibility Separation**: DevRel is not "a position that mops up after product launch." Community activates only when DevRel **earns respect** by embedding into developer workflows and demonstrating genuine investment in the product roadmap’s pain points.
*   **Anti-Pattern**: Before hiring 2–3 DevRel engineers, ensure your documentation TTFAC, quality, and SDK completeness are solid. No matter how talented a developer advocate is, they cannot compensate for a poor documentation experience. Invest in the order: **Product → Documentation → Community**.

### 16.8. Distribution-as-Infrastructure Protocol
*   **Law**: No matter how good the product, if it can't be found, it doesn't exist. From 2026 onward, **designing and operating Search (SEO), AI Search (GEO), video, and email as product infrastructure — not as "advertising channels" — is the prerequisite for sustainable growth.**
*   **SEO as Growth Infrastructure**:
    *   **Programmatic SEO**: Design in from the start the ability to auto-generate comprehensive long-tail pages from user-generated data (stores, products, user profiles, reviews).
        *   Examples: Auto-generating thousands to tens of thousands of pages for combinations like `"[City] × [Category]"` or `"[Product Name] Review."`
        *   **Quality Threshold**: Even auto-generated pages must guarantee "unique value for users (not Thin Content)." To avoid Google Core Update penalties, each page should contain unique data equivalent to at least 500 words.
    *   **Technical SEO Checklist (verify on every release)**:
        *   Core Web Vitals (LCP ≤ 2.5s / CLS ≤ 0.1 / INP ≤ 200ms) achieved across all pages
        *   Structured data (JSON-LD: Article, Product, FAQ, BreadcrumbList) implemented
        *   Canonical URL and hreflang (for multilingual) correctly configured
        *   Internal link strategy (PageRank distribution, zero orphan pages)
*   **GEO (Generative Engine Optimization) Protocol**:
    *   **Context**: AI search engines like ChatGPT, Perplexity, and Gemini have entered an estimated 20–30% of the search market (2026 projection). Optimizing for AI search engines (GEO) is a required distribution infrastructure alongside SEO.
    *   **GEO Design Principles**:
        1.  **Answer-First Content**: AI search extracts and presents "the best direct answer." Structure content as "Answer → Detail → Evidence" (inverted pyramid).
        2.  **Citation Authority**: AI search prioritizes authoritative sources. **Regular original research, industry reports, and public data releases** are the most citable content types.
        3.  **LLMs.txt Protocol**: Use `/llms.txt` (see §9.4) to explicitly declare your authoritative product information to AI agents.
        4.  **Structured Answers (Q&A Schema)**: Structure frequently asked questions with `FAQPage` JSON-LD to accelerate AI search direct extraction.
    *   **GEO KPI**: Measure "organic sessions from AI search" monthly (aggregate Perplexity/ChatGPT referral traffic independently).
*   **Email as Distribution Infrastructure**:
    *   **Newsletter as Moat**: A branded newsletter subscriber list is "Owned Media" immune to algorithm changes. A list of 1,000+ subscribers functions as an alternative distribution channel to Product Hunt and paid social advertising.
    *   **Deliverability SLA**: Maintain Bounce Rate ≤ 2%, Spam Complaint Rate ≤ 0.1%, Open Rate target ≥ 25% (above industry average). Full SPF/DKIM/DMARC configuration is mandatory.
    *   **Behavioral Triggering**: Trigger emails based on "user behavior" (nudges for users who haven't reached their Aha! Moment; Upsell emails for customers with expansion opportunity) generate 7–10× higher open rates and CVR vs. broadcast.
*   **Anti-Pattern**: "We'll hire an SEO specialist later" is prohibited. Programmatic SEO architecture (URL schema, data pipeline) is deeply coupled to product architecture — **Distribution must be considered from initial design.**

---

## 17. Competitive Intelligence Protocol

### 17.1. Continuous Competitive Analysis
*   **Law**: Competitive analysis is not a "one-time exercise done before market entry" — it is **ongoing intelligence gathering continuously reflected in decision-making**. Static spreadsheet-based competitive comparisons are prohibited.
*   **4-Layer Monitoring Framework**:

    | Layer | Scope | Monitoring Cadence |
    |:------|:------|:------------------|
    | **Direct Competitors** | Same segment, same value proposition | Weekly |
    | **Indirect Competitors** | Non-identical category products users may select instead | Monthly |
    | **Substitute Solutions** | Spreadsheets, manual processes, and analog alternatives | Quarterly |
    | **Emerging Threats** | VC-backed startups, regulatory shifts | Monthly |

*   **Recommended Monitoring Stack**:
    *   Product changes: Set alerts for G2/Capterra/App Store review shifts
    *   Pricing changes: Automated URL monitoring of competitor pages (e.g., Visualping)
    *   Hiring signals: LinkedIn job postings to infer competitor investment areas
    *   Fundraising: Crunchbase/PitchBook alerts

### 17.2. Win/Loss Analysis Protocol
*   **Law**: Win/loss reviews on sales opportunities MUST be driven by **structured interviews and data analysis**, not anecdotal recollection.
*   **Loss Interview Protocol**:
    *   Conduct an interview with the prospect within **7 days** of losing the deal.
    *   **5 Mandatory Questions**: (1) What solution did they ultimately choose? (2) What was the primary reason for the decision? (3) What did we fall short on? (4) Did pricing influence the decision? (5) Would they reconsider if circumstances changed?
*   **Win/Loss Classification Dashboard**: Categorize all deals into 5 buckets — "Product Fit / Price / Relationship / Timing / Competition" — and visualize monthly trends. A rising proportion of Product Fit losses MUST be **immediately escalated to the roadmap**.

### 17.3. Maintaining the Differentiation Matrix
*   **Law**: Competitive comparison tables MUST be built and maintained against **the evaluation dimensions customers actually care about** — not the dimensions where your product happens to win.
*   **Mandate**:
    *   Update the differentiation matrix against key competitors at least **once every 3 months**, evaluated through the lens of Porter's Five Forces and Blue Ocean Strategy.
    *   Select evaluation axes based on **dimensions that surface frequently in customer interviews** — not dimensions the internal team feels confident about.
    *   **Anti-Pattern**: Publishing a "cherry-picked comparison table" that only shows dimensions where you win is transparent to customers and destroys credibility. Honestly document weaknesses and commit to investment plans to close them.

### 17.4. Competitive Response Playbook
*   **Law**: When a competitor launches a direct attack (price disruption, feature copy, market invasion), **responding emotionally, ignoring it entirely, or being paralyzed by it are all failures.** A structured evaluation and response process is the hallmark of organizational maturity.
*   **Attack Types and Initial Response Flow**:

    | Attack Type | Signal | Initial Response SLA |
    |:-----------|:-------|:--------------------|
    | **Price Disruption** | Competitor announces pricing ≤ 50% of yours | Determine response direction within 48 hours |
    | **Feature Parity** | Competitor announces your differentiation feature | Assess impact scope within 1 week |
    | **Market Invasion** | Competitor announces entry into your core segment | Define GTM countermeasure within 2 weeks |
    | **Funding Announcement** | Competitor raises ≥ 2× your total funding | Consolidate investor positioning within 1 week |

*   **Competitive Attack Evaluation Framework (War Room Protocol)**:
    *   Upon recognizing a competitive attack, convene **PM, CEO, Marketing, Sales, and CS** in a War Room within 24 hours.
    *   **4-Axis Evaluation (RICE Competitive)**:
        1.  **Reach**: What % of existing customers are affected by this attack?
        2.  **Impact**: Estimated effect on ARR, Win Rate, and Churn
        3.  **Confidence**: Probability the competitor’s announcement actually materializes (announcement ≠ execution)
        4.  **Effort**: Engineering, marketing, and sales resources required to respond
    *   **Evaluation Score** = (Reach × Impact × Confidence) / Effort to derive priority — and decide whether to respond or strategically ignore.
*   **Four Response Strategy Options**:
    1.  **Counter (Direct Response)**: Implement equivalent features or pricing. ⚠ Risks eroding your own differentiation — last resort only.
    2.  **Differentiate (Strengthen Differentiation)**: Present **1 level higher value** than what the competitor copied, backed by third-party evidence. The most recommended response.
    3.  **Ignore (Strategic Ignore)**: Intentional inaction when the attack doesn’t impact your core segment or response cost outweighs benefit. Document it as "strategically ignoring" — not "we didn't see it."
    4.  **Reframe (Redefine the Battlefield)**: Shift the competitive arena to different evaluation axes (§17.3 Differentiation Matrix) where your strengths dominate.
*   **Customer Communication (Battle Card Playbook)**:
    *   When existing customers are receiving competitor switch proposals, CS teams use **Battle Cards** to respond.
    *   **Battle Card Required Elements**: (1) Competitor weaknesses (Win/Loss analysis §17.2-based), (2) proof of your unique value (Case Studies, ROI figures), (3) quantified migration costs (data, learning curve), (4) upcoming roadmap points that reverse the gap.
    *   **Anti-Pattern**: Using exaggeration or false claims about competitors in Battle Cards is prohibited. Customers always verify with the competitor — exaggeration destroys trust at double speed.
*   **Post-Battle Review**:
    *   After the competitive response concludes, **document all evaluations, decisions, and learnings** within the War Room. This minimizes response time when the next similar attack occurs.
*   **Anti-Pattern**: "We don't watch or care about competitors" is founder arrogance. Equally, "being distracted by every competitive move weekly" loses your roadmap focus. **Systematically monitor via quarterly Structured Competitive Review (§17.1)** and process individual attacks through the War Room Protocol.

---

## 18. Customer Success Design Protocol

> [!NOTE]
> This section provides product strategy design guidance. For operational details, refer to `operations/300_customer_experience.md`.

### 18.1. Revenue Retention Maximization (NRR Maximization)
*   **Law**: **Design for Expansion before you design for Churn Prevention.** Prioritize product designs that target NRR (Net Revenue Retention) > 120%.
*   **Designing Expansion Revenue Paths**:
    *   **Usage Expansion**: Design so that users naturally consume more as they succeed (Snowflake model). The ideal is expansion through "wanting to use more" rather than hitting limits.
    *   **Seat Expansion**: Design team sharing and invitation features so that the number of users within an organization grows organically.
    *   **Module Expansion (Cross-sell)**: Identify when mature users will seek the next module or feature, and engineer the appropriate upsell trigger at that moment.
*   **Expansion Trigger Design**:
    *   Combine PQA scoring (§16.4) with Health Score to automatically detect Expansion opportunities.
    *   Anchor upsell design to **"deepening value experience = Upgrade opportunity"**, not "hitting a limit = Upgrade opportunity" (Positive Upsell Principle).

### 18.2. Customer Health Score Protocol
*   **Law**: Churn does not "happen suddenly" — **health signal degradation is observable weeks to months in advance**. Design a Health Score and get ahead of it.
*   **4-Axis Health Score Design**:

    | Axis | What to Measure | Degradation Signal Example |
    |:-----|:---------------|:--------------------------|
    | **Product Usage** | Login frequency, core feature utilization rate | DAU drops 50%+ for 2 consecutive weeks |
    | **Outcome Achievement** | Is the user achieving their goals? | NSM plateau, KPI miss |
    | **Relationship** | CS contact frequency, escalation count | Zero inquiries OR sudden spike |
    | **Financial** | Payment delays, downgrade requests | Inquiry 60 days before renewal |

*   **Traffic Light System**: Display the composite score as Red / Yellow / Green. Red accounts MUST receive a CS first-touch within **48 hours**.

### 18.3. Onboarding as Strategy
*   **Law**: Onboarding is not "implementing a tutorial" — design it as the **fastest route to Aha! Moment (§16.5)**.
*   **3 Onboarding Models and Selection Criteria**:
    *   **Self-Serve Onboarding**: For consumer and SMB audiences. Target TtV (Time-to-Value) ≤ 5 minutes. Use Progressive Disclosure to hide complexity.
    *   **High-Touch Onboarding**: For Mid-Market and Enterprise. CS accompanies the customer and defines + delivers a Quick Win within 60 days.
    *   **Tech-Touch Onboarding**: Automated email and in-app message sequences that progressively educate users. Sync with Health Score to deliver the right touch at the right time.

### 18.4. Voice of Customer (VoC) System Design
*   **Law**: Health Score and utilization rates show "how the product is being used" — they do not reveal "what users genuinely feel." **Embed a VoC system that systematically collects, classifies, and connects qualitative customer voice to action** into product design.
*   **4 VoC Channels & Collection Protocols**:

    | Channel | Collection Method | Cadence | How to Use |
    |:--------|:-----------------|:--------|:-----------|
    | **In-product Feedback** | Micro-survey (Thumbs Up/Down + reason selection) | After key flow completion | Real-time Slack notification — PM reviews every entry |
    | **Support Tickets** | NLP classification & sentiment analysis of ticket content | Continuous | Theme-based aggregation → monthly roadmap prioritization |
    | **User Interviews** | Structured interviews (JTBD format, see §2.2) | Weekly (§2.1) | Logged to Hypothesis Log, integrated into Opportunity Tree |
    | **Public Reviews** | G2/Capterra/App Store/social monitoring | Daily alerts | Linked to Competitive Intelligence (§17.1) |

*   **VoC Classification Tag System**:
    *   Tag all VoC inputs along 4 axes: `[Theme] × [Sentiment] × [Feature Area] × [User Segment]`.
    *   Theme examples: `#onboarding` `#pricing` `#performance` `#missing-feature` `#bug` `#trust`
    *   Sentiment: `positive` / `frustrated` / `confused` / `churned`
    *   **Goal**: Monthly, directly surface the Top 5 themes with the most "Frustrated" labels into roadmap prioritization.
*   **Closed-Loop Protocol**:
    *   When an improvement corresponding to feedback is released, send **personalized notifications** to the users who submitted that feedback ("We improved this because of your feedback").
    *   This creates a sense of "my voice was heard" — increasing participation rates in future feedback rounds (fostering a sense of contribution).
    *   Closed-Loop completion rate target (feedback → notification sent): **≥ 80%**
*   **VoC to Roadmap Pipeline**:
    *   In monthly product reviews, reconcile VoC aggregate data against the OST and roadmap.
    *   Visualize frequently-cited but unaddressed JTBDs as an **Unmet Needs Heatmap** and make OKR-linkage decisions based on it.
*   **Anti-Pattern**: Treating VoC as "a complaint-collection tool that Support reads" is prohibited. VoC is the most critical input to product strategy — PMs must directly read responses and react.

### 18.5. Customer Expansion Playbook
*   **Law**: Achieving NRR ≥ 120% requires not "stumbling upon expansion opportunities" but rather a **Playbook that systematically predicts, designs, and executes expansion**. Revenue expansion from existing customers is 70% more cost-efficient than new acquisition (Bain & Company research) — it is the highest-priority revenue strategy.
*   **Three Expansion Revenue Types and Design Principles**:

    | Type | Description | Design Point |
    |:-----|:------------|:------------|
    | **Upsell (upgrade to higher tier)** | Moving to a higher-priced plan to grow ARPA | Design usage-limit "warning moments" as expansion triggers (§18.1) |
    | **Cross-sell (purchase additional modules)** | Adding features/products currently not in use | Drive discovery via in-product Discoverability and In-App Announcement |
    | **Seat Expansion (increase license count)** | Expanding to more users/departments within the org | Design intra-org virality via "sharing" and "collaboration" features (PLG + CS combined) |

*   **Expansion Trigger Calendar**:
    *   Calendar-schedule "when an expansion opportunity arises" for every customer.
    *   **Example Trigger Events**:

        | Trigger | Action | Owner |
        |:--------|:-------|:------|
        | Usage reaches **80%** of limit | Soft warning + Upgrade CTA displayed | Product (automated) |
        | Core feature used **3+ times/week** | CS-initiated Upsell proposal | CS + AE |
        | **5+ users** active within the organization | Team-plan migration proposal | Product + CS |
        | Contract renewal **90 days out** | QBR (Quarterly Business Review) conducted | AE + CS |
        | Health Score **Green for 3 consecutive weeks** | Optimal timing for Cross-sell proposal | CS |

*   **Upsell Conversation Design (Expansion Conversation Playbook)**:
    *   **Frame = Value, Not Limitation**: Instead of "You've hit your limit (constraint frame)", say "At this pace you'll achieve XX next month. Moving to the higher plan also unlocks YY (opportunity frame)."
    *   **ROI Anchoring**: Quantify the ROI the customer is currently receiving (using the §2.7 ROI calculator) before making the expansion proposal. The format "saving $5K/mo on the current plan → $3K more with Pro" produces the highest conversion rates.
    *   **Multi-Stakeholder Alignment**: Upsell negotiations require not only end-user satisfaction but **the Economic Buyer's (budget holder's) ROI awareness**. Prepare a one-page Executive Summary.
*   **QBR (Quarterly Business Review) Protocol**:
    *   **Obligation**: Conduct a QBR once per quarter for all customers with ARPA ≥ $5,000/year.
    *   **Standard QBR Agenda**:
        1.  **Past Quarter Review (25%)**: KPI achievement status, product usage data, challenges encountered
        2.  **Customer Goals Realignment (25%)**: Confirm changes in the customer's business objectives; update product fit
        3.  **Roadmap Sharing (25%)**: Share next-quarter new features and improvements (cross-reference with customer requests)
        4.  **Success Plan (25%)**: Agree on next-quarter success targets and accountability assignments
    *   Embed QBR completion rate and customer satisfaction (CSAT) into CS team KPIs. Missing QBRs are reflected in the following month's Health Score.
*   **Expansion Pipeline Management**:
    *   The CS team manages an "Upsell/Cross-sell candidate list" in the CRM and conducts monthly pipeline reviews with the sales team.
    *   **Expansion ARR Target**: Aim to **cover ≥ 30% of monthly new ARR with Expansion ARR** (the higher this ratio, the less dependent the business is on new acquisition — a sign of healthy growth).
*   **Anti-Pattern**: Depending on the CS team's "gut instinct" for Upsell is prohibited. Data-driven expansion proposals based on Health Score, usage data, and the Trigger Calendar are the foundation for reproducible growth.

### 18.6. Churn Prediction & Save Protocol
*   **Law**: Churn is not "something you respond to only after receiving a cancellation notice." **Predicting churn through Leading Indicators and intervening before departure** is the only reliable save strategy. At ARR ≥ $1M, building an ML-based churn prediction model is one of the highest ROI CS investments available.
*   **Leading Churn Indicators**:

    | Signal | Definition | Churn Correlation |
    |:------|:-----------|:-----------------|
    | **Login Frequency Drop** | Login frequency over 7 days drops **≥ 50% vs. prior month** | High (DAU-based) |
    | **Feature Usage Regression** | Core feature usage count declines 3 consecutive weeks | High |
    | **Support Ticket Spike** | 3+ technical or billing-related tickets in 1 week | Medium |
    | **Admin Turnover** | Change of primary user (admin/owner) | High (B2B-specific) |
    | **Integration Disconnect** | API/integration service rejection | High (signal of business no longer needing the product) |
    | **NPS Drop** | NPS drops ≥ 10 points or falls to Detractor | Medium |

*   **Churn Prediction Model Building Protocol**:
    *   **Simple Recipe (Early Stage)**: Use Health Score (§18.3) weighted by the above leading indicators as a proxy variable for churn prediction. This is the first step.
    *   **ML-Based Prediction (ARR $2M+)**: Generate a **Churn Probability Score** via ML using historical data including login frequency, feature usage, support tickets, and payment patterns.
        *   Model options: Logistic Regression (interpretability-focused) or XGBoost (accuracy-focused)
        *   **Threshold Setting**: Churn Probability ≥ 70% → auto-classify as "High Risk" and trigger a CSM alert.
        *   **Retrain the model quarterly** to track seasonal patterns and business changes in churn behavior.
*   **Save Playbook**:

    | Risk Tier | Target Customers | Intervention Action | SLA |
    |:---------|:----------------|:-------------------|:----|
    | **Highest Risk (Red)** | Churn Probability ≥ 70% | Direct call from VP/CSM + dedicated save badge | **Within 24 hours** |
    | **High Risk (Orange)** | Churn Probability 50–69% | CSM email + schedule check-in call | **Within 72 hours** |
    | **Medium Risk (Yellow)** | Health Score Yellow for 2 consecutive weeks | Automated email (tips & tutorials) + in-app nudge | **Within 1 week** |

*   **Save Intervention Script (Rescue Conversation Design)**:
    *   **Frame = Customer Success**: Approach with "I’d like to identify together why you haven’t been able to achieve your goals with the product" — never "please don’t cancel."
    *   **3-Question Protocol**: (1) "What was the goal you originally expected to achieve?" → (2) "What’s your current progress toward that goal?" → (3) "If you could change just one thing, what would be improved within the next year?"
    *   **Concession Guidelines**:
        *   **Temporary Feature Unlock**: Grant 1-month free access to a premium feature, with a defined review period.
        *   **Plan Downgrade**: Last resort to prevent ARR loss and relationship damage. Provides short-term save but impacts NRR — **prohibited for more than 7% of annual-pay customers**.
*   **Post-Churn Analysis (Exit Interview) Protocol**:
    *   Send a single-item, switch-format micro-survey (churn reason) within **7 days** of cancellation.
    *   **Churn Classification**: Categorize into (1) "Price (too expensive)", (2) "Product (missing features)", (3) "Competitor (switched)", (4) "Circumstance (no longer needed)" and reflect monthly trends into the roadmap.
    *   If "Product" category churn is increasing, **escalate to roadmap immediately as top priority**.
*   **Anti-Pattern**: Treating churn response as "sending a discount coupon to customers who notify cancellation" is prohibited. Discounts train customers to expect concessions "only at the last minute," undermining future pricing credibility. Early intervention based on leading indicators and Customer Success design are the only structural churn defenses.

---

## 19. Product Portfolio Strategy

### 19.1. The Three Horizons Framework
*   **Law**: Dependence on a single product is a long-term strategic risk. Use McKinsey's **Three Horizons** framework to design an investment portfolio for sustained growth.
*   **The Three Horizons**:

    | Horizon | Time Frame | Purpose | Target Investment Ratio |
    |:--------|:-----------|:--------|:-----------------------|
    | **Horizon 1 (Core Business)** | Now–1 year | Maximize revenue and efficiency of existing products | **70%** |
    | **Horizon 2 (Growth Business)** | 1–3 years | Investments in expanded features, new markets, adjacent segments | **20%** |
    | **Horizon 3 (Emerging Business)** | 3–10 years | Creating entirely new business models and market categories | **10%** |

*   **Anti-Pattern**: Concentrating all investment in H1 is the "mature-phase trap." If H2/H3 are not developed when a competitor's disruptive innovation emerges, there is no path to respond.
*   **H3 Team Isolation Principle**: H3 exploration SHOULD be conducted by a team **organizationally and physically isolated** from H1 KPI pressure (equivalent to a Skunk Works model).

### 19.2. Portfolio Evaluation Matrix (BCG Matrix — Evolved)
*   **Law**: When managing multiple products or feature lines, use a quantitative evaluation matrix to eliminate subjective resource allocation decisions.

    | Quadrant | Market Growth Rate | Own Market Share | Strategy |
    |:---------|:-----------------|:----------------|:--------|
    | **Star** | High | High | Invest aggressively to lock in competitive advantage |
    | **Cash Cow** | Low | High | Maximize efficiency and revenue; fund H2/H3 |
    | **Question Mark** | High | Low | Validate; decide whether to grow into a Star or exit |
    | **Dog** | Low | Low | **Evaluate for immediate retirement/discontinuation** |

*   **Dog Feature Retirement Process**: (1) Data-driven confirmation as a "Dog," (2) 90-day advance user notification, (3) Provide data export capability 60 days before end-of-life (GDPR-compliant), (4) Discontinue. Following this sequence ensures retiring features without destroying user trust.

### 19.3. Build vs Buy vs Partner Decision Protocol
*   **Law**: "Build everything in-house" is a waste of resources. Additions of new capabilities MUST be strategically decided among **Build / Buy / Partner**.
*   **Decision Criteria**:
    *   **Build**: Core to competitive differentiation (high Coreness) AND difficult to source externally. Building creates a genuine moat.
    *   **Buy (Acquire or License)**: The capability is mature, Cost of Making Do (COMD) is high, and time-to-market advantage is critical. M&A or licensing accelerates.
    *   **Partner**: Non-core domain OR mutual complementarity generates ecosystem value. → Refer to `operations/700_partnership_ecosystem.md`.
*   **Coreness Evaluation Axes**: (1) Does it create competitive differentiation? (2) Is it central to user trust or data? (3) Does external vendor dependency create strategic risk? → If all three are YES → **Build**.

### 19.4. Product Sunset Protocol
*   **Law**: Discontinuing a feature or product is a product decision of equal importance to a release. Abrupt sunsets executed without proper process destroy user trust.
*   **Sunset Decision Criteria**:
    *   DAU/MAU has fallen to **50% or less of its peak for 6 consecutive months**
    *   NPS/satisfaction scores are clearly low (bottom quartile)
    *   Maintenance costs **exceed 3x** the revenue generated by that feature
*   **Sunset Execution Process**:
    1.  **Internal Decision**: Data-driven Go/No-Go determination (confirm Dog quadrant via §19.2)
    2.  **User Notification**: Announce via email, in-app notifications, and blog at least **90 days in advance**
    3.  **Data Export**: Provide data export functionality for users to retrieve their data starting 60 days before end-of-life
    4.  **Staged Shutdown**: Stop new registrations → Continue existing use → Final discontinuation (3 phases)
    5.  **Post-Mortem**: Record why users didn't choose this feature as organizational learning

---

## 20. GTM Launch Protocol (Go-to-Market Launch Protocol)

### 20.1. Go-to-Market Design Principles
*   **Law**: No matter how excellent the product, reaching the wrong people through the wrong channel with the wrong message yields zero. GTM strategy deserves equal design priority to the product itself.
*   **Channel-Market Fit (CMF) Protocol**:
    *   Just as with Product-Market Fit, validate **Channel-Market Fit** (which acquisition channel reaches your target market most efficiently) through rigorous experimentation.
    *   **Rule of One Channel First**: In the early phase, do NOT spread thin across multiple channels. **Master one most-promising channel completely**, then expand to the next.
    *   **GTM Channel Classification**:

        | Channel | Best Fit | KPI |
        |:--------|:---------|:----|
        | **Inbound (SEO/Content)** | High LTV, long payback period, long decision cycle | Organic MQLs |
        | **Outbound (Cold Reach)** | Low market awareness, clear target, Enterprise | SQLs / Meetings booked |
        | **Product-Led (PLG)** | Self-serve capable, network effects present | PQLs / Activation Rate |
        | **Partner/Ecosystem** | Complementary product fit, API ecosystem | Partner-sourced ARR |
        | **Event/Community** | Niche market, high-engagement users | Attendee ARR conversion |

### 20.2. Launch Tiers
*   **Law**: It is not rational to apply a "full launch" to every feature or product. Select the appropriate Launch Tier based on impact.

    | Tier | Scope | Tactical Examples | Measurement Window |
    |:-----|:------|:------------------|:------------------|
    | **Tier 1 (Full Launch)** | Core product, major feature overhaul | Press release, Product Hunt, full email blast, paid ads | 30 days |
    | **Tier 2 (Feature Launch)** | Mid-sized new feature addition | In-app announcement, blog post, social posts | 14 days |
    | **Tier 3 (Silent Launch)** | Minor updates, bug fixes | Changelog update only | 7 days |

*   **Product Hunt Strategy (Tier 1)**:
    *   The optimal launch day is **Tuesday through Thursday** (weekend vote rates drop significantly).
    *   Select a "Hunter" who genuinely knows the product; the full team should be on-call all day on launch day.
    *   **2 weeks before** launch, notify existing users and beta users of the launch date and request their support.

### 20.3. Early Access & Beta Strategy
*   **Law**: Rather than "publish when finished," the Early Access model of "finish while learning" accelerates innovation.
*   **3 Principles of Early Access Design**:
    1.  **Intent-Gated**: Do not accept anyone who just "wants to try for free." Use the application form to select users who "genuinely have this problem and can provide feedback."
    2.  **Time-Boxed**: Set a hard deadline of **no more than 90 days** for Early Access, and explicitly communicate the General Availability transition timeline.
    3.  **Feedback Loop Mandatory**: Always establish weekly calls or a Slack channel with Early Access users, and directly connect their feedback to the roadmap.
*   **Waitlist Strategy**:
    *   Waitlists are a powerful tool for creating **scarcity**, but **waiting longer than 6 months converts expectation into disappointment**. Keep Waitlist periods within 6 months.
    *   Send rough progress updates to Waitlist registrants monthly to sustain enthusiasm.

### 20.4. GTM Narrative Design
*   **Law**: The market responds to "stories (Narratives)" — not feature lists. Without a clear narrative, even the best product gets buried.
*   **3-Part Narrative Structure**:
    1.  **Why Now**: Present the "external shift" (technology, regulation, market change) that makes solving this problem urgent today.
    2.  **Why Us**: Articulate the flaws in existing solutions and why our approach is fundamentally different.
    3.  **Why Win**: Present the defensibility (Moat) against competitors and evidence from best customers (Case Studies).
*   **Messaging Architecture**:
    *   **Tagline (1 sentence)**: The single sentence expressing core value. Words the CEO can say in an elevator.
    *   **Elevator Pitch (30 seconds)**: 4 elements — Target Persona + Problem + Solution + Differentiation.
    *   **Full Deck (10 minutes)**: Expanded in Working Backwards (§8.1) format with full detail.

### 20.5. Analyst Relations Protocol
*   **Law**: Placement and evaluation in Gartner Magic Quadrant, Forrester Wave, and IDC Marketscape **influences up to 40% of purchase decisions in Enterprise B2B sales**. Analyst Relations (AR) is not a marketing activity—treat it as an infrastructure investment for Enterprise sales.
*   **When to Start AR**:
    *   Launch a full AR investment (dedicated staff or AR agency) once you reach **ARR ≥ $1M and 10+ Enterprise customers**.
    *   Before that threshold, run quarterly "Analyst Briefings" to build the relationship.
*   **AR Execution Protocol**:
    1.  **Briefing**: Regularly present your product direction, customer results, and market position to analysts. Briefings are "deposits" into your analyst relationship account.
    2.  **Inquiry**: Most research firms (Gartner, Forrester, etc.) include Inquiry entitlements in their contracts. Leverage these aggressively to validate strategy, GTM, and pricing decisions.
    3.  **RFI Response**: Understand the inclusion criteria for reports like Magic Quadrant (minimum customer count, geography, feature requirements) in advance and build eligibility into your growth plan.
*   **AR KPIs**:
    *   **Mention Score**: Frequency and sentiment (positive/negative) of your company being mentioned in competitive research reports.
    *   **Analyst-Influenced Pipeline**: Percentage of sales pipeline sourced through analyst channels (Target: ≥ 15% of Enterprise ARR).
*   **Anti-Pattern**: Viewing analysts solely as "report readers" is prohibited. Analysts directly recommend vendors to Enterprise customers—treat them as a word-of-mouth channel.

### 20.6. Creator & Influencer Economy GTM Protocol
*   **Law**: From 2026 onward, for B2C products and PLG (Product-Led Growth) SaaS, **the Creator and Influencer Economy has become one of the highest ROI acquisition channels available.** Shift your GTM mental model from "advertising campaigns" to "creator partnerships."
*   **Creator Type Classification & Applications**:

    | Type | Follower Scale | Characteristics | Best-Fit Scenario |
    |:-----|:--------------|:----------------|:-----------------|
    | **Mega Creator** | 1M+ | Max reach, lower trust | Brand awareness phase |
    | **Macro Creator** | 100K–1M | Balanced | Launch acceleration, product recognition |
    | **Micro Creator** | 10K–100K | High trust, niche appeal | **Optimal for PMF validation & core target acquisition** |
    | **Nano Creator** | 1K–10K | Ultra-high engagement, word-of-mouth | Community seeding, CLG kindling |

*   **Creator Partnership Protocol**:
    1.  **Authentic Use First**: Only propose partnerships to creators who genuinely use your product. Content recommending something the creator doesn't actually use is transparent to audiences — and backfires.
    2.  **Product Access Before Payment**: Provide early product access and exclusive features before any financial compensation — prioritize making them genuine fans first.
    3.  **Long-Term > One-Shot**: Design **3–6 month ongoing partnerships** rather than single-post PR deals. Sustained content generates long-term exposure via search and recommendation algorithms.
    4.  **Content Rights & Repurposing**: Include secondary usage rights for creator-produced content in contracts — deploy it in your own ads, social, and website (minimizing content production costs).
*   **Measurement KPIs (Creator Channel Performance)**:
    *   **Creator CAC**: Creator investment cost ÷ conversions. Compare against CAC from other channels.
    *   **Attribution Model**: Apply **multi-touch attribution**, not last-click. Creator content often functions as "the trigger for a search" rather than direct conversion — assist-credit measurement is critical.
    *   **Earned Media Amplification**: Measure the volume and reach of UGC (user-generated content independently created by users) that creator partnership content sparked.
*   **Compliance Requirements**:
    *   **Stealth marketing regulations** for PR/advertising content are intensifying across Japan, the US, and EU (Japan: Revised Premiums & Representations Act; US: FTC Guides; EU: DSA).
    *   ALL creator partnership content MUST include `#PR` / `#Sponsored` / `#ad` hashtags PLUS the platform's paid promotion setting. Violations carry a dual risk: legal penalties and brand damage.
*   **Anti-Pattern**: Selecting creators based on follower count alone is prohibited. Treat **engagement rate** (comments ÷ impressions) and **audience quality** (alignment with target personas) as the primary evaluation axes.

### 20.7. M\&A Growth Playbook
*   **Law**: M&A is not "only for big companies." For post-Series B startups, **"Acqui-hire" (talent acquisition), "Product Tuck-in" (feature gap acquisition), and "Channel Buy" (distribution acquisition)** are the fastest ways to compress the roadmap and should always be maintained as strategic options. Design your company to also be attractive as an acquisition target.
*   **Acquirer Playbook**:
    *   **Define an M&A Thesis in Advance**:
        1.  **Talent**: Acquiring an engineering team that is difficult to hire in the market (Acqui-hire)
        2.  **Technology**: Eliminating 12+ months of in-house development cost for mature technology (Tuck-in)
        3.  **Customers**: Distribution into new segments for an existing product (Channel Buy)
        4.  **Competitive Neutralization**: Early acquisition of a potential future threat
    *   **Valuation Framework (Extension of Build vs Buy vs Partner)**:
        *   M&A decisions expand on the "Buy" branch in §19.3.
        *   **Speed Premium Calculation**: When comparing "12 months to build in-house" vs. "acquire for $5M," calculate the Opportunity Cost of 12 months first. In the growth phase, time sits at the top of the cost hierarchy.
    *   **Integration Playbook**:
        *   **Day 1 Plan**: Design "which systems to integrate" and "which talent to place in which team" on Day 1 — before the deal closes. "We'll figure out integration after" is the most common failure pattern.
        *   **30/60/90-Day Milestones**: (30 days) Culture integration + Onboarding complete / (60 days) Technical integration begins + duplicate systems identified / (90 days) KPI unification + standalone team dissolved
        *   **Retention Cliff**: The 12–18 months post-acquisition carries the highest risk of acquired talent attrition. **Embed an equity Vesting Cliff (18 months) and a Retention Bonus structure** into acquisition terms.
*   **Being-Acquired Preparation**:
    *   **Exit Readiness Checklist (integrated with §22)**:
        *   Complex cap tables (convertible notes, SAFEs, multiple rounds) are **the single largest barrier to acquisition diligence**. Maintain a clean Cap Table at all times.
        *   IP ownership clarity: Verify that all code copyright is assigned to the company (explicitly in employment contracts). Conduct regular audits to ensure copyleft open-source licenses (e.g., GPL) have not infiltrated your commercial API.
        *   **Acqui-hire vs Strategic Acquisition differentiation**: If targeting full-company acquisition, you need financial evidence (P&L, NRR, Churn) proving "an independently revenue-generating business." This evaluation baseline is fundamentally different from a talent/technology bet (Acqui-hire).
    *   **Acquirer Attraction (design to attract buyers)**:
        *   **API-first design** (§10.2) dramatically reduces post-acquisition technical integration costs, making you more attractive to potential Acquirers.
        *   **High NRR (≥120%)** and **low Churn (≤3%/month)** are the strongest signals guaranteeing Revenue Retention post-acquisition.
        *   **Defensible Data Moat** (§2.4) creates an "Acquirer-only Value" that competitors cannot replicate.
*   **Anti-Pattern**: Treating M&A as "the last resort (rescue acquisition)" is prohibited. The highest valuations in acquisitions go to companies that are "well-capitalized and evaluating M&A as one of several options." Negotiating leverage always belongs to the less-needy party.

---

## 21. Global Expansion Protocol (Internationalization & Global Expansion)

### 21.1. Market Entry Decision Framework
*   **Law**: A "let's just create an English version" approach is resource waste without market intelligence. Market entry MUST be based on a **structured decision framework**.
*   **Market Prioritization Matrix**:

    | Evaluation Axis | Weight | What to Assess |
    |:---------------|:-------|:--------------|
    | **Market Size** | 25% | TAM/SAM/SOM estimation |
    | **Competitive Intensity** | 20% | Number and strength of direct competitors |
    | **Regulatory Complexity** | 20% | Compliance cost (GDPR/PDPA etc.) |
    | **GTM Ease** | 20% | Reusability of existing channels, language cost |
    | **Strategic Fit** | 15% | Complementarity with core business, Exit value contribution |

*   **Ring Expansion Strategy**:
    *   Enter new markets via "concentric circle expansion": `Adjacent country/culture (minimum GTM cost) → Similar regulatory zone → New regulatory zone`.
    *   Example expansion order for a Japanese SaaS: `Japan → Taiwan (CJK characters, similar culture) → South Korea (similar East Asian regulatory landscape) → US`

### 21.2. Technical Localization Protocol
*   **Law**: "Internationalization (i18n)" added as an afterthought incurs massive refactoring costs. **Embed i18n architecture from the initial design phase.**
*   **i18n Design Requirements**:
    *   **String Externalization**: All UI text MUST be externalized to resource files (`en.json`, `ja.json`, etc.). Hardcoding is prohibited (an extension of the §7.2 Legal Hardcoding Ban principle).
    *   **Plural & Gender Rules**: Rather than simple substitution (`{count} item(s)`), implement language-specific plural rules using `Intl.PluralRules` or equivalent.
    *   **Date & Number Formatting**: Use `Intl.DateTimeFormat` / `Intl.NumberFormat` to automate locale-specific display (e.g., $1,234.56 ↔ ¥1,234).
    *   **RTL (Right-to-Left) Support**: If Arabic or Hebrew markets are in scope, use CSS `logical properties` (`margin-inline-start`, etc.) from the start.
*   **Content Localization**:
    *   **Translation ≠ Localization**: Machine translation is effective for cost reduction, but marketing copy, legal documents, and customer support MUST always go through **native speaker review**.
    *   **Cultural Fit**: Have market specialists review colors, icons, and images for cultural taboos (e.g., white symbolizes mourning in Japan).

### 21.3. Global Compliance Map
*   **Law**: Rather than treating each country's regulatory requirements as a separate project, design a **common compliance framework** to enable scalable response across markets.

    | Regulation | Region | Key Requirements | Reference |
    |:-----------|:-------|:----------------|:---------|
    | **GDPR** | EU/EEA | Explicit consent, right to erasure, DPA | `security/100_data_governance.md` |
    | **CCPA/CPRA** | California | Opt-out rights, data sale prohibition | `security/100_data_governance.md` |
    | **PDPA** | Thailand | Similar to GDPR, local DPO appointment | `security/100_data_governance.md` |
    | **PIPL** | China | Strict data cross-border transfer restrictions, local server obligation | Consult specialists |
    | **APPI** | Japan | Restrictions on sharing sensitive PII with third parties | `security/100_data_governance.md` |
    | **EU AI Act** | EU | AI risk classification, high-risk AI registration obligation | `ai/000_ai_engineering.md` |
    | **DSA/DMA** | EU | Transparency and mediation obligations for large platforms | Consult specialists |

*   **Data Residency Protocol**:
    *   Requirements to **store data within the EU (Data Residency)** for EU-facing services are intensifying. Consider this when selecting cloud regions (AWS eu-west / GCP europe-west).
    *   The Chinese market effectively mandates domestic servers under PIPL. Consider VIE structure or establishing a local entity.

### 21.4. Localized GTM Strategy
*   **Law**: The largest failure pattern in global expansion is "exporting the home market GTM strategy as-is." Each market's channels, influencers, and purchase decision processes are fundamentally different.
*   **Market-Specific Channel Characteristics (Examples)**:
    *   **Japan**: LINE and Instagram dominant. Trust and word-of-mouth are critical. High expectations for feature "completeness." "Trial version" resonates more than "free trial."
    *   **Southeast Asia**: Mobile First. Purchase via WhatsApp/TikTok. Instalment Payment support reduces purchase barriers.
    *   **North America B2B**: G2/Capterra/LinkedIn dominant. Case Studies and ROI calculators are essential.
    *   **EU**: High privacy consciousness — marketing that explicitly addresses data handling builds trust.
*   **Local Team Hiring Strategy**:
    *   The first 1–2 hires in a new market should be **T-shaped individuals covering both sales and marketing**. Specialization comes after market establishment (ARR $500K+).
    *   Before hiring, verify **local regulations, labor law, and social insurance systems** to manage employment risk.

---

## 22. Fundraising & Investor Relations Protocol

> [!NOTE]
> This section provides fundraising guidance from a product and business strategy perspective. For detailed financial models, refer to `product/900_fundraising_ir.md`.

### 22.1. Fundraising Strategy Design
*   **Law**: Fundraising is not "getting money" — it is **"building a relationship with the optimal capital partner."** Who you raise from and how much profoundly impacts your product direction, velocity, and Exit strategy.
*   **Fundraising Type Selection Matrix**:

    | Type | Phase Estimate | Raise Scale | Primary Providers | Best-Fit Product |
    |:-----|:--------------|:------------|:-----------------|:----------------|
    | **Bootstrapping** | Pre-Seed | Own capital | Founders | Low-burn SaaS capable of early PMF |
    | **Angel / Pre-Seed** | Idea–MVP | $100K–$1M | Angel investors | PoC stage, betting on the founders |
    | **Seed** | MVP–PMF | $1M–$5M | Seed VC, CVC | PMF validation underway, user growth starting |
    | **Series A** | PMF–Scale | $5M–$20M | Tier 1 VC | PMF confirmed, growth channel established |
    | **Series B+** | Scale | $20M+ | Growth VC | Market dominance, international expansion |
    | **Strategic / CVC** | Any | Any | Corporates | Ecosystem integration, distribution acquisition |

*   **Default Alive First**:
    *   Frame fundraising not as "a necessary evil for survival" but as "an optional accelerant."
    *   Reaching **Default Alive** (the state of surviving on profit without fundraising) before entering negotiations gives you an overwhelming advantage in valuation and terms.
    *   Raising from a position of need (with runway running out) fundamentally destroys your negotiating leverage.

### 22.2. Investor Narrative Design
*   **Law**: Investors invest not in the product, but in the story of **"why this team, in this market, at this moment, will win."** The Deck must answer that question.
*   **Mandatory Investor Deck Structure (Sequoia Capital format)**:

    | Slide | Content | Checkpoint |
    |:------|:--------|:----------|
    | **Purpose** | Company mission (1 sentence) | Understandable in 10 seconds? |
    | **Problem** | The pain users face | Is it a problem the investor personally recognizes? |
    | **Solution** | Product demo or screenshots | Does it actually work? |
    | **Why Now** | Why now? (tech, regulation, market shift) | Is the timing inevitable? |
    | **Market** | TAM/SAM/SOM | Is there a bottom-up estimate? |
    | **Competition** | Competitive map, differentiation (§2.4) | Are weaknesses documented honestly? |
    | **Business Model** | Revenue model, Unit Economics (§5.1) | LTV/CAC ≥ 3 achieved? |
    | **Traction** | NSM growth, ARR, Retention | Are the numbers free of exaggeration? |
    | **Team** | Founding team background, Why Us | Is there a compelling reason this team solves this problem? |
    | **Ask** | Raise amount, use of funds breakdown | Does it generate 18–24 months of Runway? |

*   **Metrics Integrity**:
    *   For core metrics such as ARR, MAU, and Retention, explicitly state the definition (e.g., "ARR excludes canceled accounts; annualized MRR × 12").
    *   Nothing destroys investor trust more than discovering after the fact that the definition was different.

### 22.3. IR Calendar & Data Room Design
*   **Law**: Fundraising activities do not "start when you feel like it" — **systematic calendar management and advance data preparation** increase the probability of success.
*   **Standard Fundraising Timeline**:

    | Phase | Duration | Actions |
    |:------|:---------|:--------|
    | **Preparation** | 3 months before raise | Create Deck, build Data Room, draft target investor list |
    | **Warm-up** | 1 month before raise | Briefings to lower-priority investors (practice + relationship building) |
    | **Primary Round** | 4–8 weeks | Concentrated pitches to Tier 1 investors. Compress all meetings into 2 weeks to create competitive dynamics |
    | **Term Sheet** | 1–2 weeks | Obtain multiple Term Sheets and compare terms. Select the optimal partner, not the highest valuation |
    | **Due Diligence** | 4–6 weeks | Legal, financial, technical, and customer reference checks |
    | **Close** | 2–4 weeks | Contract execution, wire confirmation |

*   **Required Data Room Contents**:
    *   Financial statements (last 2 years and most recent monthly P&L)
    *   Cap Table (capitalization table)
    *   Key customer contracts (under NDA protection)
    *   Product demo and technical architecture documentation
    *   Org chart and key staff bios
    *   IP (patents, trademarks) list
    *   Risk factors and mitigations (honest disclosure builds trust)

### 22.4. Investor Relations Protocol
*   **Law**: Post-raise investor communication is not an "obligation" — it is a **"strategic asset."** Build relationships where investors become introducers for your next round, customer network, and recruiting pipeline.
*   **Monthly Investor Update (Recommended Format)**:
    ```
    [Highlights]  Positive events this month (KPI achievements, key customer wins, etc.)
    [Lowlights]   Challenges, failures, and what we learned (disclose honestly)
    [Metrics]     NSM / ARR / MRR / Churn / Burn Rate / Runway
    [Ask]         Specific requests for the investor's network (hiring, customer, partner introductions)
    ```
*   **Investor Update Design Principles**:
    *   **Good news + Bad news**: Updates that report only good news destroy trust. Founders who share Lowlights honestly are the ones investors most want to support in the next round.
    *   **Always include an Ask**: Investors want to be told "here's how you can help." Writing a specific Ask each month enables strategic use of the investor's network.
    *   **Same format every month**: Consistency in structure creates comparability and readability of data over time.
*   **Board Meeting Protocol (when applicable)**:
    *   Board Materials MUST be distributed **72 hours before** the meeting (day-before distribution is prohibited).
    *   Allocate **60% of agenda to forward-looking strategic discussion** and limit 40% to reporting (backward-looking review).
    *   **Action Item Minutes**: Within 24 hours of the meeting, share "decisions made, owner, and deadline-stamped action items" with all Board Members.

### 22.5. SAFE \& Convertible Note Negotiation Protocol
*   **Law**: At the angel-to-seed stage, SAFE (Simple Agreement for Future Equity) or a Convertible Note are the most common fundraising instruments. However, **poor term design leads to severe dilution and investor conflict at Series A and beyond**. Fully understand the implications of every term before negotiating.
*   **Key SAFE Terms and Negotiation Benchmarks**:

    | Term | Description | Founder-Favorable Benchmark | Pitfall |
    |:-----|:------------|:---------------------------|:-------|
    | **Valuation Cap** | Upper valuation at conversion (too low = founder dilution) | Pre-Money Cap should not be **below 40–60% of projected Series A valuation** | Uncapped SAFEs are discouraged — investors perceive them as high-risk |
    | **Discount Rate** | Price reduction at conversion | **≤ 20%** (>20% is over-favorable to investors) | Dual application with Cap (both/lesser) is typical |
    | **Pro-Rata Rights** | Right to participate in future rounds | Grant Pro-Rata but **limit to Major Investor threshold ($100K+)** | Many small-check investors holding Pro-Rata complicates Series A cap table cleanup |
    | **MFN (Most Favored Nation)** | Auto-updates if a later SAFE has more favorable terms | If granted, **set an expiry to the last issuance within the same round** | Unlimited MFN becomes self-binding |

*   **Convertible Note-Specific Alerts**:
    *   **Maturity Date**: If conversion does not occur at maturity, a Repayment (cash) obligation arises. Set maturity at **minimum 18–24 months** and include an extension-option clause.
    *   **Interest Rate**: Base on the statutory minimum (IRS AFR reference: ~3–5% p.a.) and avoid high rates (>8%). Include Accrued Interest Equity conversion in the terms.
    *   **Conversion Triggers**: Designate only a "Qualified Financing (round above a minimum raise amount XX)" as the Auto-Conversion trigger to prevent unintended conversions in small rounds.
*   **Cap Table Impact Simulation Obligation**:
    *   Before issuing any SAFE/CN, simulate the "founder and investor ownership percentages at the time of Series A."
    *   **Example Calculation**:
        ```
        Seed: SAFE $1M @ Cap $5M (Post-Money)
        Series A: $5M @ Pre-Money $15M

        SAFE conversion shares = $1M / ($15M × (1 - 20% Discount)) = $1M / $12M ≈ 8.3%
        → Understand founder dilution impact upfront
        ```
    *   If the simulation results in Founder ownership < 60%, reassess the Cap or adjust the total SAFE amount.
*   **SAFE vs. Convertible Note Selection Criteria**:

    | Dimension | SAFE | Convertible Note |
    |:----------|:-----|:----------------|
    | **Legal nature** | Not equity (no debt characteristic) | Debt instrument (Maturity exists) |
    | **Interest** | None | Required (≥ AFR) |
    | **Repayment obligation** | None | Triggered if unconverted at Maturity |
    | **Complexity** | Simple (Y Combinator standard) | Somewhat complex; higher legal cost |
    | **Investor preference** | Angels · early-stage VCs | Traditional VCs · Japanese investors |

*   **Anti-Pattern**: Treating SAFE/CN terms as something "someone will sort out eventually" is prohibited. When unconverted SAFEs accumulate across multiple rounds, the Cap Table becomes a "hidden time bomb" that severely complicates due diligence at Series A and beyond. Commit to Cap Table cleanup **within 6 months of issuance**.

---

## 23. Revenue Operations (RevOps) Protocol

### 23.1. RevOps Architecture & GTM Alignment
*   **Law**: Organizations where Sales, Marketing, and Customer Success (CS) operate in their own silos constantly generate data misalignments, goal conflicts, and revenue forecast errors. RevOps (Revenue Operations) is the architectural design principle that integrates these three functions into a **single unified revenue engine**.
*   **GTM Three-Layer Model**:
    *   **Demand Generation**: Marketing-led. Injects qualified leads into the pipeline aligned to ICP (§2.3).
    *   **Pipeline Conversion**: Sales-led. Drives deals through a structured process from first meeting to close.
    *   **Revenue Expansion**: CS/Account Management-led. Centers on NRR maximization (§18.1–§18.5).
*   **RevOps KPI Dashboard (Required Metrics)**:

    | Metric | Definition | Target |
    |:-------|:----------|:-------|
    | **Pipeline Coverage** | Total pipeline value as a multiple of ARR target | ≥ 3× |
    | **Win Rate** | Closed-Won deals / Total Closed deals | Industry median +10% |
    | **Sales Cycle Length** | Average days from deal creation to close | QoQ decreasing trend |
    | **Lead-to-MQL** | MQL conversion rate across all leads | ≥ 15% |
    | **MQL-to-SQL** | SQL conversion rate from MQLs | ≥ 30% |
    | **ARR per Sales Rep** | ARR contribution per individual rep | $500K+ (mature stage) |

*   **Anti-Pattern**: A culture of “revenue is Sales' sole responsibility” causes Marketing to optimize only for lead volume and CS to own churn in isolation — creating silo fragmentation. RevOps dismantles this vertical ownership structure.

### 23.2. Revenue Attribution
*   **Law**: Evaluating marketing ROI using only “Last Touch” (crediting 100% to the final channel) causes budgets for upper-funnel channels — brand awareness, educational content — to be cut, starving the long-term pipeline. Adopt **multi-touch attribution models** to accurately measure every channel’s contribution.
*   **Attribution Models (Comparison)**:

    | Model | Description | Best Use Case |
    |:------|:-----------|:-------------|
    | **First Touch** | 100% credit to the first touchpoint | Evaluating brand awareness channels |
    | **Last Touch** | 100% credit to the last touchpoint | Evaluating closing channels |
    | **Linear** | Equal credit distributed across all touches | Simple multi-channel analysis |
    | **Time Decay** | Higher weight for touches closer to close | Long Sales Cycles (B2B SaaS, etc.) |
    | **Data-Driven (Shapley Value)** | ML-based contribution estimation | When sufficient data volume exists (recommended) |

*   **Implementation Protocol**:
    *   Integrate your CRM with your MAP (HubSpot / Marketo / Salesforce, etc.) to capture every touchpoint event (aligned with §3.5 Instrumentation SLA).
    *   Limit attribution model changes to **no more than once per quarter** to preserve time-series comparability.
    *   **Minimum requirement** for Data-Driven Attribution: ≥ 50 Closed-Won deals per month. Below this threshold, use the Linear model.
*   **Anti-Pattern**: Evaluating all channels with Last Touch Attribution leads to underinvestment in long-cycle asset channels (SEO, PR, community), resulting in structurally rising CAC over time.

### 23.3. CRM Hygiene & Pipeline Management
*   **Law**: The CRM is not “a personal notebook for sales reps” — it is the **“central database of the organization’s revenue system.”** Maintaining and auditing data quality fundamentally improves forecast accuracy and decision quality.
*   **CRM Hygiene Standards (Required Data Quality)**:
    *   **Field Completeness**: All deals must have `Close Date`, `Amount`, `Stage`, and `ICP Score` (§2.3 supplement) filled in. Deals missing these fields are automatically downgraded to `Draft Stage` and excluded from forecast reports.
    *   **Stale Deal Policy**: Deals with no updates for 30 days trigger an automatic alert requiring the owner to review. After 90 days without updates, the deal is automatically moved to `Closed-Lost`.
    *   **Contact Ownership**: Upon rep offboarding, customer contacts are automatically reassigned within 72 hours (implemented via CRM Automation).
*   **Pipeline Review Cadence**:

    | Review Type | Frequency | Participants | Key Actions |
    |:-----------|:---------|:------------|:-----------|
    | **Deal Review** | Weekly | Sales + Manager | Review progress and Next Actions per deal |
    | **Forecast Call** | Weekly | Sales + Finance + RevOps | Update Commit / Best Case / Pipeline classifications |
    | **Pipeline Health Review** | Monthly | GTM Leaders + RevOps | Analyze Coverage and Conversion Rates |
    | **QBR (Quarterly Business Review)** | Quarterly | All GTM + Exec | Assess goal achievement, determine strategic pivots |

### 23.4. Sales Forecasting Protocol
*   **Law**: “Gut-feel forecasting” is tolerated below $1M ARR, but **structured forecasting processes become mandatory at ARR $1M+.** Credibility in Board Meetings (§22.4) is directly tied to forecast accuracy.
*   **Forecast Categories**:

    | Category | Definition | Accuracy Target |
    |:---------|:----------|:---------------|
    | **Commit** | Deals the rep is certain will close this quarter | ±5% |
    | **Best Case** | Deals that would close if ideal conditions are met | ±15% |
    | **Pipeline** | All active deals in the CRM | ±30% |

*   **Forecast Integrity Protocol**:
    *   Reps whose Commit actuals deviate by **> ±10% for two consecutive quarters** must complete Commit Criteria retraining.
    *   Deploy **AI-Assisted Forecasting** (Salesforce Einstein / Gong.io / Clari, etc.) to correct for individual rep subjective bias using machine learning.
    *   **Bottom-Up (rep → manager → CRO)** and **Top-Down (market data → CFO → CEO)** forecasts must be cross-referenced monthly. Deviations of **≥ 15%** require a mandatory Deep Dive.
*   **Anti-Pattern**: A CRO treating a single CRM view as gospel without external validation is prohibited. Forecasts must always be verified against multiple independent data sources.

### 23.5. Revenue Leakage Audit Protocol
*   **Law**: Most SaaS companies are leaking revenue without realizing it. One of RevOps’ most critical responsibilities is to periodically discover and seal these leaks. **Minimizing the gap between “Theoretical ARR” and “Collected ARR” is the shortest path to revenue maximization.**
*   **Primary Revenue Leakage Sources & Mitigations**:

    | Leakage Source | Symptom | Recommended Mitigation |
    |:-------------|:--------|:-----------------------|
    | **Billing Misalignment** | Contract ARR ≠ Billed ARR | Monthly CRM ↔ Billing System (Stripe / Zuora, etc.) reconciliation audit |
    | **Discounting Without Approval** | Rampant unauthorized discounts | Establish a Deal Desk; discounts ≥ 15% require CRO approval |
    | **Auto-Renewal Failures** | System errors or overlooked renewals | 90-day renewal reminder + manual confirmation SLA (aligned with §18.5) |
    | **Seat Undercount** | Under-billing for actual paid users | Reconcile Usage Metering against Billing System monthly |
    | **Free Tier Abuse** | Free users consuming Pro-tier resources | Usage threshold monitoring + auto-trigger Conversion Playbook |
    | **Contract Renewal Lapses** | Delayed or unsigned renewal contracts | Renewal Pipeline management (§18.5) + RevOps owner follow-ups |

*   **Revenue Leakage KPI (Required Dashboard Metric)**:
    *   Measure the monthly gap rate between **“Theoretical ARR”** (sum of all active contracts) and **“Collected ARR”** (sum of actual invoiced and received amounts), targeting a **gap rate ≤ 0.5%**.
    *   A gap rate **exceeding 1%** in any month is treated as a P1 Incident, triggering an immediate Root Cause Analysis (RCA).
*   **Deal Desk Design**:
    *   Establish a `Deal Desk` (under RevOps authority) at ARR $2M+. The Deal Desk governs three functions: “discount authorization,” “custom contract term adjustments,” and “exceptional bundle design” — preventing sales reps from making unilateral condition changes.

### 23.6. Sales Enablement & Revenue Readiness Protocol
*   **Law**: If RevOps’ mandate is “measuring, forecasting, and sealing revenue,” Sales Enablement’s mandate is **“systematically building the capability of the teams that generate revenue.”** Rather than delivering one-time training sessions, it must be designed as a continuous, measurable, and ROI-linked system.
*   **Sales Playbook Design Protocol**:
    *   **Required Playbook Contents**:

        | Content | Description | Update Frequency |
        |:--------|:-----------|:----------------|
        | **ICP Qualification Guide** | Deal qualification criteria based on ICP scoring (§2.3 supplement) | Quarterly |
        | **Competitive Battle Card** | Key competitors’ weaknesses and differentiation points (linked to §17.2) | Monthly |
        | **Objection Handling Library** | Response library for common objections (pricing, competition, timing) | Monthly |
        | **Demo Playbook** | Phase-by-phase demo scripts (Discovery → Value Demo → Technical Demo) | Quarterly |
        | **Pricing & Discounting Guide** | Approved pricing tiers, discount matrix, and bundle design (linked to Deal Desk) | As needed |
        | **Reference Customer List** | Reference customers organized by industry, size, and use case | Monthly |

    *   Playbook content is jointly reviewed **quarterly by RevOps + Sales Manager + PM**, incorporating field feedback and market changes.
*   **Revenue Readiness Certification**:
    *   New sales hires are prohibited from closing deals independently until they complete the following checkpoints within the **Ramp Period (typically 90 days)**:
        ```
        Week 1–2:  Product comprehension + ICP definition + Competitive Landscape test (≥ 80% passing score)
        Week 3–4:  Discovery Calls × 5 (reviewed and scored by RevOps or Manager)
        Week 5–8:  Demo certification test passed + Objection Handling role-play assessment
        Week 9–12: Close ≥ 1 actual deal (Manager co-attendance permitted)
        ```
    *   Reps who complete all of the above are awarded a **“Revenue Ready” badge** and granted independent deal-closing authority.
*   **Enablement ROI Measurement (Required KPIs)**:

    | Metric | Definition | Target |
    |:-------|:----------|:-------|
    | **Ramp Time** | Average days from hire to first close | QoQ decreasing trend (target: ≤ 90 days) |
    | **Playbook Adoption Rate** | Usage rate of sales tools (CRM logging, Battle Card references, etc.) | ≥ 80% |
    | **Certified Rep Win Rate** | Win rate of “Revenue Ready”-certified reps vs. uncertified | Certified reps outperform by +15% or more |
    | **Content Usage → Revenue Correlation** | Win rate improvement effect for deals where Enablement content was used | Tracked monthly |

*   **Enablement Stack (Required Tools)**:
    *   **Sales Intelligence**: Gong.io / Chorus.ai (call recording, AI analysis, coaching)
    *   **Enablement Platform**: Highspot / Seismic / Showpad (content management, distribution, usage tracking)
    *   **CRM Integration**: All Enablement content usage logs linked to CRM deal records (integrated with §23.3 CRM Hygiene)
*   **Anti-Pattern**:
    *   **“One training session = done” Prohibition**: Markets, competitors, and products evolve. Enablement is not a one-time event — it must operate as a **continuous capability renewal system**.
    *   **Playbook Enforcement Prohibition**: Playbooks are “accelerating guidelines,” not “constraining rules.” Foster a culture where top-performing sales reps are encouraged to adapt the Playbook to the situation.

---

## 24. Brand Architecture & Corporate Communications Protocol

> [!NOTE]
> This section is complementary to §1.6 (Category Creation) and §20.4 (GTM Narrative). Brand strategy connects upstream to Category Design and downstream to GTM Narrative execution.

### 24.1. Brand Architecture Design
*   **Law**: As product lines and businesses expand, adding brands without a plan causes **“brand dilution”** — fragmenting customers’ cognitive resources. Brand strategy must be designed in sync with product portfolio strategy (§19).
*   **Brand Architecture Models**:

    | Model | Description | Representative Examples | Optimal Conditions |
    |:------|:-----------|:----------------------|:------------------|
    | **Monolithic (Branded House)** | All products unified under a single parent brand | Google, Apple, Salesforce | Brand recognition is the core purchase driver |
    | **House of Brands** | Each product carries an independent brand | P&G, Unilever, IAC | Serving different market segments and price points |
    | **Endorsed Brand** | Parent brand “endorses” the product brand | Marriott Courtyard, Nestlé KitKat | Leveraging parent brand trust while differentiating |
    | **Hybrid** | Combination of Monolithic and House of Brands | Amazon / AWS | Diversification that a single model cannot accommodate |

*   **Brand Architecture Change Protocol**:
    *   Adding new brands or consolidating existing ones requires **CXO approval + a brand audit**. “Spinning up a sub-brand out of momentum” is prohibited.
    *   Before any change, conduct a **Brand Impact Assessment** across three axes: cognitive confusion risk for existing users, SEO impact, and legal trademark implications.
    *   Brand changes must be executed in alignment with the annual `Brand Architecture Review` (integrated with §24.2) — never reactively.
*   **Naming Protocol**:
    *   Product names and feature names must pass review by a `Naming Council` (PM, Design, Marketing, and Legal — four parties).
    *   Naming criteria: Must satisfy all four conditions — **Pronounceable, Memorable, Trademarkable, Domainable**.
    *   Reusing vocabulary or category names already owned by competitors is prohibited (an abdication of differentiation opportunity).

### 24.2. Brand Equity Measurement
*   **Law**: Brand is not “something vague and qualitative” — it is a **quantitatively measurable and manageable business asset**. Since brand equity decline precedes revenue decline, it must be monitored as a leading indicator.
*   **Brand Equity KPIs**:

    | Metric | Measurement Method | Target |
    |:-------|:-----------------|:-------|
    | **Unaided Brand Awareness** | Spontaneous mention rate for “brands that come to mind in this space?” | Top 3 within the target segment |
    | **Net Promoter Score (NPS)** | Integrated with §3.4 HEART Framework | Industry median +10pt |
    | **Share of Voice (SoV)** | Own share of brand mentions vs. competitors | **1.5×** or more vs. market share |
    | **Branded Search Volume** | Monthly Google searches for brand name | Maintaining QoQ growth trend |
    | **Press Sentiment Score** | Positive / Negative ratio across media coverage | Positive ≥ 70% |
    | **Employee NPS (eNPS)** | Employees’ likelihood to recommend the brand | ≥ 30 |

*   **Brand Equity Review Cadence**:
    *   **Semi-annually**: Unaided Awareness and customer NPS surveys via external research firms (Kantar / Nielsen / YouGov, etc.) or SurveyMonkey.
    *   **Monthly**: Share of Voice monitoring (auto-collected via Brandwatch / Mention.com, etc.) and Branded Search Volume tracking.
    *   **Annually**: Produce a comprehensive `Brand Health Report` and present it to CXOs and the Board (§22.4).

### 24.3. PR & Earned Media Strategy
*   **Law**: PR (Public Relations) is not merely sending press releases. It is a **strategic activity of “building long-term trust relationships with journalists, analysts, and influencers, and controlling the company’s narrative in the market.”** Design this in integration with §20.5 (Analyst Relations) and §1.7 (Strategic Narrative).
*   **PR Tier Model**:

    | Tier | Action | Expected Outcome |
    |:-----|:------|:----------------|
    | **Tier 1: Reporter Relationships** | Monthly–quarterly Exclusive Briefings with key journalists (TechCrunch / Fortune / Nikkei / Forbes, etc.) | Exclusive coverage and positive editorial |
    | **Tier 2: Contributed Content** | Contributed articles by CEO / CTO (Harvard Business Review / Forbes / Substack, etc.) | Thought Leadership + SEO asset |
    | **Tier 3: Press Releases** | Official announcements for new products, fundraising, partnerships | Basic press coverage |
    | **Tier 4: Podcast & Panels** | Industry conference keynotes, podcast appearances (aligned with §20.6 Creator Economy) | Reach into niche communities |

*   **PR Calendar Standards**:
    *   **Monthly**: 1 Contributed Content piece (blog, Substack, or equivalent by CEO/CTO/CPO)
    *   **Quarterly**: Exclusive Briefings to Tier 1 media (previewing product roadmap direction)
    *   **Annually**: Secure 2+ major conference speaking slots (aligned with Lightning Strike §1.6)
*   **Exclusivity Protocol**:
    *   Provide “Exclusive information” to Tier 1 media one outlet at a time. Simultaneously granting exclusivity to multiple Tier 1 outlets damages relationships irreparably.
    *   Allow a maximum of 48 hours from Exclusive provision to publication. If not published within the window, revoke exclusivity and offer to other outlets.
*   **Anti-Pattern**: Expecting that “sending a press release will get coverage” via a PR agency is prohibited. Journalists move only on compelling narratives and trusted human relationships.

### 24.4. Crisis Communication Protocol
*   **Law**: A crisis is not a question of “if” but “**when.**” Organizations without a pre-built protocol respond in chaos when a crisis hits, exponentially amplifying brand damage.
*   **Crisis Severity Classification**:

    | Level | Definition | Examples | Initial Response Timeline |
    |:------|:----------|:--------|:------------------------|
    | **P0: Critical** | Full service outage / Large-scale data breach / Legal prosecution risk | Complete outage, PII leak, regulatory enforcement | First statement within **1 hour** |
    | **P1: Major** | Key feature failure / Key member scandal / Major negative coverage | Payment failure, executive misconduct, key customer data issue | Within **4 hours** |
    | **P2: Moderate** | Partial outage / Social media firestorm / Misinformation spread | Partial service delay, viral user complaints on social media | Within **24 hours** |

*   **Crisis Response Playbook (7-Step Response Flow)**:
    1.  **Detect**: Real-time detection via monitoring tools (Mention.com / Brandwatch / PagerDuty, etc.) integrated with on-call protocols.
    2.  **Assess**: Classify as P0 / P1 / P2 and immediately identify Impact Scope (number of affected users, regions, media exposure scale).
    3.  **Acknowledge**: Even before facts are confirmed, issue an immediate statement: “We are aware of the issue and are investigating.” Silence is interpreted as dishonesty.
    4.  **Contain**: Execute technical containment (incident recovery, data isolation, etc.) while controlling internal communications (activate War Room — §17.4).
    5.  **Communicate**: Update the Status Page (statuspage.io, etc.) every 30–60 minutes. Even when there is “no new update,” explicitly state “investigation is ongoing.”
    6.  **Resolve**: Within **48 hours of full resolution**, publish a Post-Mortem. Formally document the technical root cause and prevention measures.
    7.  **Restore**: Where appropriate, implement compensation, apologies, refunds, and feature improvement reports. Track trust restoration using Brand Equity KPIs (§24.2).
*   **Spokespeople Protocol**:
    *   **P0**: Only statements jointly approved by the CEO + General Counsel (Legal) are published. Informal personal social media comments by all employees are prohibited.
    *   **P1 and below**: A designated PR Manager controls all external communications.
    *   **“No comment” is prohibited**: Always respond honestly with “We are investigating and will provide updates.” “No comment” is interpreted as an admission of guilt.
*   **Crisis Simulation Mandate**: Conduct an annual **“Tabletop Exercise”** to rehearse a P0 scenario in a controlled drill. Real-world crisis response capability cannot be developed without advance practice.

---

## Appendix A: Quick Reference Index

### Reverse Lookup Index (Keyword → Section)

| Keyword | Section |
|---|---|
| Vision, Mission, Golden Circle | §1.1 |
| MVP, PMF, Sean Ellis Test, Build Trap | §1.2 |
| North Star Metric, Counter Metrics | §1.3 |
| Exit strategy, Data Moat, Network Effects | §1.4 |
| Roadmap, RICE, ICE, Quarterly Review, Feature Flag | §1.5 |
| Continuous Discovery, JTBD, Pain Severity | §2.1, §2.2 |
| Positioning, April Dunford, Persona | §2.3 |
| Competitive Moat, Network Effects (design) | §2.4 |
| NSM, Driver Metrics, Metrics Hierarchy | §3.1 |
| A/B Testing, Statistical Significance, Experiment Governance, Goodhart's Law | §3.2 |
| Event tracking, Funnel, Behavioral Analytics | §3.3 |
| HEART, Happiness, Engagement, Adoption, Retention, Task Success, GSM | §3.4 |
| Freemium, Value Metric, Conversion | §4.1 |
| Subscription, MRR, Tiered Pricing | §4.2 |
| Ads, Sponsored, Native Ads | §4.3 |
| Usage-based Pricing, Outcome-based Pricing, Take Rate, Waitlist | §4.4 |
| LTV, CAC, Churn, Magic Number, NRR | §5.1 |
| Cohort Analysis, Retention Curve, D30 | §5.2 |
| ROI, Burn Rate, SaaS, Default Alive | §6.1, §6.2 |
| FinOps, Cloud Cost | §6.3 |
| Terms of Service, Privacy Policy, Commercial Law | §7.1 |
| Legal Hardcoding Ban, DB SSOT | §7.2 |
| GDPR, CCPA, App Store | §7.3 |
| Working Backwards, Day 1, Keeper Test | §8.1–§8.3 |
| Hook Model, IKEA Effect, Habit Formation | §8.5 |
| Shape Up, Appetite, Betting Table, Cool-down | §8.6 |
| AI, EU AI Act, Transparency, Explainability, Vibe Coding, AI PM | §9.1 |
| AI UX, Copilot, Agent, Autonomy Dial, Intent Preview | §9.2 |
| AI FinOps, 30% Rule, Circuit Breaker | §9.3 |
| Agentic Commerce, LLMs.txt, MCP, AI Safety Scorecard | §9.4 |
| AI Risk Tier, AI Incident Response, Model Versioning | §9.5 |
| Platform Thinking, Marketplace, Developer Platform | §10.1 |
| API-as-Product, Commercialization, Developer DX | §10.2 |
| Network Effects, Critical Mass | §10.3 |
| Data Flywheel, First-Party Data, Data Asset | §11.1 |
| Privacy-by-Design, Data Minimization | §11.2 |
| Data Monetization, Aggregated Insights | §11.3 |
| Dark Pattern, Roach Motel, Confirmshaming | §12.1 |
| Accessibility, WCAG, EAA | §12.2 |
| Sustainability, SCI, Green Engineering | §12.3 |
| Tag design, Business hours, Search SLA, Multi-factor ranking | §13 |
| Bayesian average, Moderation, Spam, Trust levels | §14 |
| Poll, Quiz, Survey, Unified Schema | §15 |
| Growth Loop, Viral Loop, Content Loop, PLG, PLS | §16.1, §16.2 |
| K-factor, Virality, Growth Loop Design | §16.3 |
| PQA, Product Qualified Account, PLG→PLS Transition | §16.4 |
| Aha! Moment, Time-to-Value, Activation Energy | §16.5 |
| Retention Loop, Resurrection Rate, Habit-Forming Frequency | §16.6 |
| Competitive Intelligence, Win/Loss Analysis, Differentiation Matrix | §17.1, §17.2, §17.3 |
| NRR Maximization, Expansion Revenue, Customer Health Score, Onboarding as Strategy | §18.1, §18.2, §18.3 |
| Three Horizons, BCG Matrix, Build vs Buy vs Partner | §19.1, §19.2, §19.3 |
| Sunset Protocol, Product Retirement, Coreness, Dog Feature | §19.2, §19.4 |
| GTM, Channel-Market Fit, Product Hunt, Early Access | §20.1, §20.2, §20.3 |
| GTM Narrative, Why Now, Messaging Architecture | §20.4 |
| Analyst Relations, Gartner, Forrester, Magic Quadrant | §20.5 |
| Global Expansion, Ring Expansion, Market Prioritization | §21.1 |
| i18n, RTL, Content Localization, Data Residency | §21.2, §21.3 |
| Localized GTM, PDPA, PIPL, DSA | §21.3, §21.4 |
| Fundraising, Round types, Default Alive, Deck structure | §22.1, §22.2 |
| IR Calendar, Data Room, Term Sheet | §22.3 |
| Investor Update, Board Meeting, Shareholder communication | §22.4 |
| MLP, Minimum Lovable Product | §1.2 |
| Design Partner, Pre-PMF, Co-design | §2.5 |
| AI Credits, Credits Economy, Prepaid Deposit | §4.2 |
| Compound AI, Orchestrator, Worker, Guardrails | §9.6 |
| Community-Led Growth, CLG, Community Manager, Power User | §16.7 |
| Analyst Relations, Briefing, Inquiry, RFI | §20.5 |
| Category Creation, POV Document, Lightning Strike | §1.6 |
| Instrumentation SLA, Event Schema, Privacy-Safe Analytics | §3.5 |
| AI Red Team, Adversarial Testing, Prompt Injection, Jailbreak | §9.7 |
| VoC, Closed-Loop, Unmet Needs Heatmap | §18.4 |
| Creator, Influencer, Micro Creator, Stealth Marketing Regulation | §20.6 |
| Strategic Narrative, Founder-Led Sales, Sales Playbook | §1.7 |
| TAM/SAM/SOM, Bottom-up Estimation, SOM Formula | §2.6 |
| Rule of 40, Burn Multiple, SaaS Health Dashboard | §5.3 |
| AI Agent Authorization, OAuth RAR, MCP Security, PoLP | §9.8 |
| RSP, Responsible Scaling, Capability Thresholds, Safety Audit | §12.4 |
| Fundraising Readiness Checklist | Appendix C |
| Pricing Discovery, Van Westendorp, WTP, Price Anchoring | §2.7 |
| Capital Efficiency, ARR per FTE, Gross Margin Profile, EGS | §5.4 |
| LLMOps, EDD, Prompt Registry, Model Routing, LLM Observability | §9.9 |
| Programmatic SEO, GEO, LLMs.txt, Distribution Infra, Email Moat | §16.8 |
| M&A Playbook, Acqui-hire, Tuck-in, Exit Readiness, IP Audit | §20.7 |
| DACI, Driver, Approver, Contributor, Informed, Decision SLA | §1.8 |
| ICP, ICP Scoring, ICP Drift, ICP Dynamic Management | §2.3 supplement |
| Referral Program, Affiliate Program, Double-sided Reward, K-factor | §16.9 |
| Expansion Playbook, QBR, Expansion ARR, Upsell Conversation Design | §18.5 |
| SAFE, Convertible Note, Valuation Cap, Discount Rate, MFN | §22.5 |
| Customer Advisory Board, CAB, Elite Members, Reciprocal Value | §2.8 |
| ASC 606, IFRS 15, Deferred Revenue, Billings, Revenue Recognition | §5.5 |
| Packaging Architecture, Feature Fencing, Good/Better/Best, Value Leakage | §8.7 |
| DevRel, Developer Relations, TTFAC, Open Core, Docs NPS | §16.10 |
| Competitive Response, War Room, Battle Card, Price Disruption, Reframe | §17.4 |
| Churn Prediction, Save Protocol, Leading Indicator, Churn Probability, Exit Interview | §18.6 |
| RevOps, GTM Three-Layer Model, Pipeline Coverage, Win Rate, ARR per Rep | §23.1 |
| Revenue Attribution, Shapley Value, Last Touch Avoidance, Data-Driven Attribution | §23.2 |
| CRM Hygiene, Field Completeness, Stale Deal Policy, Pipeline Review Cadence | §23.3 |
| Sales Forecasting, Commit, Best Case, Bottom-Up vs Top-Down, AI-Assisted Forecasting | §23.4 |
| Revenue Leakage, Billing Misalignment, Deal Desk, Theoretical ARR, Collected ARR | §23.5 |
| Brand Architecture, Branded House, House of Brands, Endorsed Brand, Hybrid | §24.1 |
| Brand Equity, Unaided Awareness, Share of Voice, Press Sentiment, eNPS, Brand Health | §24.2 |
| PR, Earned Media, Reporter Relationship, Contributed Content, Exclusivity Protocol | §24.3 |
| Crisis Communication, P0/P1/P2 Classification, 7-Step Response, Tabletop Exercise, Spokespeople | §24.4 |
| Strategic Partnership, BD Protocol, ICP-Partner Fit, Partnership QBR, Exclusivity Clause | §1.9 |
| AI Reasoning Model, Test-Time Compute, Thinking Budget, Streaming Thinking, Reasoning UX | §9.10 |
| DE&I, Inclusive Design, AI Bias Audit, Hardest to Serve User, Pay Equity, URG | §12.5 |
| Sales Enablement, Revenue Readiness, Ramp Certification, Playbook Adoption, Enablement ROI | §23.6 |

### Cross-References (Section → Related Rules)

| Section | Related Universal Rules |
|---|---|
| §1 Vision & Strategy | `core/000_core_mindset`, `product/900_fundraising_ir` |
| §2 Product Discovery | `product/100_market_validation`, `product/200_go_to_market` |
| §3 Metrics Governance | `ai/100_data_analytics`, `product/500_growth_marketing` |
| §4 Monetization | `product/300_revenue_monetization`, `product/400_pricing_strategy` |
| §5 Unit Economics | `product/300_revenue_monetization`, `product/500_growth_marketing` |
| §6 Finance | `operations/600_cloud_finops`, `product/300_revenue_monetization` |
| §7 Legal | `security/100_data_governance`, `product/700_appstore_compliance` |
| §8 Org DNA | `core/000_core_mindset`, `operations/200_hr_organization` |
| §9 AI-Native | `ai/000_ai_engineering`, `product/300_revenue_monetization` |
| §10 Platform | `engineering/100_api_integration`, `operations/700_partnership_ecosystem` |
| §11 Data Product | `security/100_data_governance`, `ai/100_data_analytics` |
| §12 Ethics & Sustainability | `design/000_design_ux`, `engineering/000_engineering_standards` |
| §13 Search Architecture | `engineering/200_supabase_architecture` |
| §14 Review System | `security/000_security_privacy`, `ai/000_ai_engineering` |
| §15 Interactive | `engineering/200_supabase_architecture` |
| §16 Growth Loop | `product/500_growth_marketing`, `product/200_go_to_market`, `ai/100_data_analytics` |
| §17 Competitive Intelligence | `product/100_market_validation`, `product/200_go_to_market` |
| §18 Customer Success | `operations/300_customer_experience`, `product/500_growth_marketing` |
| §19 Product Portfolio | `product/100_market_validation`, `product/900_fundraising_ir`, `operations/700_partnership_ecosystem` |
| §20 GTM Launch | `product/200_go_to_market`, `product/500_growth_marketing` |
| §21 Global Expansion | `security/100_data_governance`, `product/200_go_to_market`, `operations/700_partnership_ecosystem` |
| §22 Fundraising & IR | `product/900_fundraising_ir`, `core/000_core_mindset`, `operations/200_hr_organization` |
| §23 RevOps | `product/300_revenue_monetization`, `product/200_go_to_market`, `product/500_growth_marketing` |
| §24 Brand & PR | `product/200_go_to_market`, `core/000_core_mindset`, `product/500_growth_marketing` |
| §1.9 Strategic Partnership & BD | `operations/700_partnership_ecosystem`, `product/200_go_to_market`, `product/900_fundraising_ir` |
| §9.10 AI Reasoning | `ai/000_ai_engineering`, `product/300_revenue_monetization` |
| §12.5 DE&I as Product Strategy | `core/000_core_mindset`, `design/000_design_ux`, `operations/200_hr_organization` |
| §23.6 Sales Enablement | `product/300_revenue_monetization`, `product/200_go_to_market`, `operations/300_customer_experience` |

---

## Appendix B: GTM Launch Checklist

> [!NOTE]
> This checklist targets Tier 1 (Full Launch). Apply only applicable items for Tier 2/3.

### Phase 1: 4 Weeks Before Launch (Preparation)

- [ ] **NSM Defined**: Target NSM achievement value for the 30 days post-launch is defined
- [ ] **Counter Metrics Set**: Guardrail metrics monitoring NSM side effects are configured
- [ ] **Positioning Finalized**: Positioning Canvas (§2.3) completed and shared company-wide
- [ ] **GTM Narrative Complete**: Why Now / Why Us / Why Win 3-part structure completed
- [ ] **Early Access Users Secured**: 3+ users capable of providing Testimonials on launch day confirmed
- [ ] **Legal Cleared**: Terms of Service and Privacy Policy cover the new feature (§7.1)
- [ ] **Pricing Implemented**: All tier Pricing and limits implemented on both UI and backend (§4.1/4.2/4.4)

### Phase 2: 1 Week Before Launch (Readiness)

- [ ] **Feature Flags Configured**: Setup complete to start with Canary (1%) rollout (§1.5)
- [ ] **Monitoring Configured**: NSM and Counter Metrics alerts set on dashboard
- [ ] **Support Prepared**: FAQ updated, support team briefed
- [ ] **Rollback Plan Documented**: Immediate rollback procedure documented
- [ ] **Product Hunt Ready (if applicable)**: Hunter confirmed, Assets (icon, screenshots, demo video) prepared

### Phase 3: Launch Day

- [ ] **Ring Deployment Running**: Advancing `1% → 10% → 50% → 100%` only after verifying NSM at each step
- [ ] **Real-Time Monitoring**: Error rate and latency within normal range (SLO confirmed)
- [ ] **PR/Social Publishing**: Content published broadly only after confirming NSM upward trend

### Phase 4: 30 Days Post-Launch (Review)

- [ ] **NSM Achievement Verified**: Actuals evaluated against defined target
- [ ] **Novelty Effect Cleared**: NSM still maintained 2+ weeks post-launch (§3.2)
- [ ] **Experiment Log Recorded**: Experiment results and learnings logged as organizational knowledge asset
- [ ] **Stale Flag Review**: Feature Flag removal plan established per 90-day rule (§1.5)

---

## Appendix C: Fundraising Readiness Checklist

> [!NOTE]
> This checklist targets Seed–Series A fundraising. Validate readiness across Deck, Data Room, and Investor Management **at least 3 months before** initiating the raise.

### Phase 1: Story & Metrics Readiness (Deck Prerequisites)

- [ ] **Strategic Narrative Confirmed**: §1.7 structure (World Changed / Winners / Our Land) — 1-page Narrative Document created
- [ ] **Market Sizing Proven**: §2.6 Bottom-up approach — SAM/SOM quantitative evidence prepared
- [ ] **Rule of 40 Calculated**: §5.3 score computed and explainable relative to current growth phase
- [ ] **NSM & Traction Data**: §1.3 NSM growth charts prepared by cohort
- [ ] **Unit Economics Computed**: §5.1 LTV/CAC / Payback / NRR calculated
- [ ] **Default Alive Verified**: §6.2 question answered ("can we survive X months on current revenue/growth?")

### Phase 2: Data Room Readiness

- [ ] **Financial Statements**: Monthly P&L / Balance Sheet / Cash Flow for past 2 years (or since founding)
- [ ] **Cap Table**: Latest capitalization table (founders, existing investors, ESOP)
- [ ] **Key Customer Contracts**: 3–5 representative customer contracts (under NDA)
- [ ] **IP List**: Patent applications, trademarks, and copyrights inventory
- [ ] **Tech Architecture Doc**: Infrastructure diagram, data flow, security design overview
- [ ] **Org Chart & Team Bio**: Founding team and key members' bios
- [ ] **Risk Register**: Risk factors and current mitigations (honest disclosure builds trust)

### Phase 3: Process & Investor Readiness

- [ ] **Target Investor List**: 3-tier list (Tier 1 / Tier 2 / Warm-up) created — 10–20 per tier
- [ ] **Introduction Path Confirmed**: "Warm Intro" to Tier 1 investors secured for at least 50%
- [ ] **IR Calendar Designed**: §22.3 fundraising timeline designed and agreed with internal stakeholders
- [ ] **Legal Prepared**: Corporate governance docs, shareholder agreements, software license review complete
- [ ] **RSP Prepared (if applicable)**: If §12.4 RSP triggers are met, first-version RSP document prepared
