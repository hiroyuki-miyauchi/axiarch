# 12. Go-to-Market Strategy & Launch

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-04-06

> [!IMPORTANT]
> **Supreme Directive**
> "Even a great product doesn't exist if it isn't delivered correctly."
> **GTM is a design act equal to product development.** Eliminate the illusion that "if you build it, they will come."
> Launch is not "a one-day event" but "a continuous process."
> **10 Parts · 38 Sections.**

---

## Table of Contents

- [Part I. GTM Philosophy & Prerequisites](#part-i-gtm-philosophy--prerequisites)
- [Part II. Positioning Strategy](#part-ii-positioning-strategy)
- [Part III. ICP (Ideal Customer Profile) Definition](#part-iii-icp-ideal-customer-profile-definition)
- [Part IV. GTM Motion Selection](#part-iv-gtm-motion-selection)
- [Part V. Channel Strategy](#part-v-channel-strategy)
- [Part VI. Launch Plan Design](#part-vi-launch-plan-design)
- [Part VII. Initial Customer Acquisition Protocol](#part-vii-initial-customer-acquisition-protocol)
- [Part VIII. GTM Metrics & Measurement](#part-viii-gtm-metrics--measurement)
- [Part IX. GTM Organization & Ownership](#part-ix-gtm-organization--ownership)
- [Part X. Appendix: Quick Reference & Cross-References](#part-x-appendix-quick-reference--cross-references)

---

## Part I. GTM Philosophy & Prerequisites

### 1.1. GTM Definition & Scope

- **Rule 12.001**: Define GTM (Go-To-Market) strategy as "the comprehensive design of who, what, how, and at what price to deliver value"
- **Rule 12.002**: GTM is the product team's responsibility. Siloing it as "marketing's job" is prohibited
- **The 4 GTM Elements**:

```
Who:   Who to reach (ICP / Persona)
What:  What to deliver (Value Proposition / Positioning)
How:   How to deliver (Channel / GTM Motion)
When:  Timing in the launch sequence
```

### 1.2. GTM Prerequisites

- **Rule 12.003**: Do not begin significant GTM investment until all of the following are confirmed

```
Prerequisites:
□ Problem-Solution Fit confirmed (Customer Discovery from §100_market_validation complete)
□ ICP is concretized with 3+ real customers
□ Core value proposition can be stated in one sentence
□ Clear differentiation from competitors is defined
□ Basic product delivery capability (MVP or above) exists
```

### 1.3. GTM ≠ Marketing Campaign

- **Rule 12.004**: Do not conflate GTM strategy with "running ads." It is a comprehensive design including:
  - Pricing design
  - Sales channel construction
  - Sales process design
  - Customer success preparation
  - Onboarding design

---

## Part II. Positioning Strategy

### 2.1. Positioning Principles

- **Rule 12.010**: Define positioning not as "what we are" but as **"the position occupied in the customer's mind"** (Al Ries & Jack Trout)
- **Rule 12.011**: Aim not to compare against competitors but to **create a new category** within the customer's existing mental framework

### 2.2. April Dunford's Positioning Canvas

- **Rule 12.012**: Define positioning using these 5 elements ([Obviously Awesome, April Dunford])

| Element | Question | Example |
|:--------|:---------|:--------|
| **Competitive Alternatives** | What would customers use without you? | Excel, email, nothing |
| **Unique Attributes** | What do you have that others don't? | Real-time sync, AI suggestion |
| **Value for Customer** | What value does that attribute deliver? | 60% reduction in approval time |
| **Target Customer** | Who benefits most? | Finance managers with 10+ monthly approvals |
| **Market Category** | How should you be categorized? | "AI Financial Approval Platform" |

### 2.3. Category Creation Strategy

- **Rule 12.013**: Entering existing categories risks price competition. Explore creating a new category when:
  - Existing categories don't accurately describe the customer's need
  - A new problem definition can make competitors "incomparable"
  - You can establish the category definition before industry peers

### 2.4. Messaging Hierarchy

- **Rule 12.014**: Organize external messaging in 3 layers

```
Layer 1: Tagline / Headline (Capture attention in 3 seconds)
         Example: "Expense reports done in 5 minutes"

Layer 2: Sub-headline / Value Proposition (Convey value in 30 seconds)
         Example: "Just scan your receipt. Automatic categorization frees you from end-of-month expense nightmares."

Layer 3: Feature Proof Points (Demonstrate evidence in 3 minutes)
         Example: 99.5% accuracy AI OCR / Real-time sync / ...
```

---

## Part III. ICP (Ideal Customer Profile) Definition

### 3.1. ICP vs Persona

- **Rule 12.020**: Clearly distinguish between ICP and Persona

| Concept | Level | Purpose |
|:--------|:------|:--------|
| **ICP** | Organization (B2B) / Segment (B2C) | Strategic target selection |
| **Persona** | Individual | UI design and copywriting |

### 3.2. B2B ICP Definition

- **Rule 12.021**: Define B2B ICP with the following attributes

```yaml
b2b_icp:
  firmographics:
    industry: ["SaaS", "Fintech"]
    employees: "50-500"
    revenue: "$5M–$50M"
    geography: ["US", "UK", "EU"]
    tech_stack: ["Salesforce", "Slack", "AWS"]
  
  situational:
    trigger_events:
      - "Post-Series A scaling phase"
      - "Sales team exceeds 10 people"
      - "90 days before existing tool contract renewal"
    pain_indicators:
      - "3+ sales job openings on LinkedIn"
      - "Active CRO hiring post"
    disqualifiers:
      - "Fewer than 10 employees"
      - "Under long-term contract with a competitor"
```

### 3.3. B2C ICP Definition

- **Rule 12.022**: Define B2C ICP based on behavior and situation (demographics are supplementary)

```yaml
b2c_icp:
  behavioral:
    trigger: "Currently paying $20+/month for an alternative solution"
    frequency: "Faces this problem 3+ times per week"
    digital_savvy: "Has 10+ apps installed on smartphone"
  
  attitudinal:
    pain_awareness: "Clearly aware of the problem (Pain-Aware)"
    solution_awareness: "Knows solutions exist"
    urgency: "Wants to solve within the next 90 days"
```

### 3.4. ICP Scoring Model

- **Rule 12.023**: Build an ICP match scoring system to improve sales and marketing efficiency

```
ICP Score = Σ(Attribute Match × Weight)

Score ≥ 80: Tier 1 (Priority) → AE direct contact
Score 60-79: Tier 2 → SDR + sequence
Score 40-59: Tier 3 → Marketing nurture
Score < 40: Disqualified → Auto-remove
```

---

## Part IV. GTM Motion Selection

### 4.1. GTM Motion Types

- **Rule 12.030**: Select from the following 4 GTM motions (overlap allowed); clearly define the primary motion

| Motion | Description | Best Fit |
|:-------|:-----------|:---------|
| **PLG** (Product-Led Growth) | Product itself is the primary acquisition/expansion engine | Viral SaaS, consumer products |
| **SLG** (Sales-Led Growth) | Sales team is the primary acquisition engine | Enterprise, high-ACV B2B |
| **MLG** (Marketing-Led Growth) | Content / brand is the primary acquisition engine | Education, complex decision SaaS |
| **CLG** (Community-Led Growth) | Community is the primary acquisition/expansion engine | DevTools, OSS, niche professionals |

### 4.2. PLG Implementation Protocol

- **Rule 12.031**: When adopting PLG, design the following 3 engines

```
3 PLG Engines:
1. Acquisition Engine
   - Freemium / free trial WTP threshold design
   - Viral loop embedding (sharing, invitations, embeds)
   - App Store / Product Hunt optimization

2. Activation Engine
   - Time-to-Value (first value experience) ≤ 5 minutes
   - Minimize steps to "Aha Moment"

3. Expansion Engine
   - Seat expansion / department spread design
   - Usage-based billing alignment (more use = more value)
```

### 4.3. SLG Implementation Protocol

- **Rule 12.032**: When adopting SLG, design and document each stage

```
SLG Basic Structure:
Lead → MQL → SQL → SAL → Opportunity → Closed Won

Define in Blueprint:
- MQL definition criteria
- SQL definition criteria
- BANT / MEDDIC qualification criteria
```

### 4.4. GTM Motion Transition Protocol

- **Rule 12.033**: Consider transitioning from PLG to SLG (Product-Led Sales) when:
  - 5+ inbound enterprise inquiries per month
  - Organic expansion from free plan begins stalling
  - Customers with ACV > $10K appear

---

## Part V. Channel Strategy

### 5.1. Channel Discovery Protocol

- **Rule 12.040**: Run 3–5 parallel channel experiments initially, then **concentrate resources on 1 channel** within 4–8 weeks
- **Rule 12.041**: Evaluate each channel using the following criteria

| Axis | Score | Description |
|:-----|:------|:-----------|
| Reach | 1-5 | Volume of ICP reachable |
| Targeting | 1-5 | Ability to reach only ICP |
| Cost | 1-5 | Estimated CAC |
| Speed | 1-5 | Time to first results |
| Control | 1-5 | Company's ability to control the channel |

### 5.2. Channel Characteristics

| Channel | Strengths | Weaknesses | Best Phase |
|:--------|:----------|:-----------|:----------|
| **SEO / Content** | Scalable, low CAC | Slow to take effect | Post-PMF scale |
| **SEM / Paid** | Immediate, measurable | Expensive, disappears if paused | Validation / Scale |
| **Cold Email / SDR** | High targeting | Hard to scale | Early adopter acquisition |
| **Partnerships** | Bulk reach | Dependency risk | After channel diversification |
| **PR / Media** | Brand awareness | Low sales conversion | Launch / fundraising |
| **Product Viral** | Low cost | Requires PMF | Post-PMF |
| **Community** | High engagement | Time to build | Niche markets |
| **Events / Webinars** | High-quality leads | Low repeatability | Early adopters |

### 5.3. Channel Concentration Law

- **Rule 12.042**: Prioritize **concentration over diversification** in acquisition channels. Do not pursue the next channel until CAC recovery is established in one
- **Rule 12.043**: "Channel diversification" is a dependency risk management activity—target ARR > $1M before pursuing it

---

## Part VI. Launch Plan Design

### 6.1. Three-Phase Launch Structure

- **Rule 12.050**: Design every product launch in the following 3 phases

```
Phase 1: Soft Launch (Limited access)
Goal: Real feedback from early adopters
Target: Top of waitlist / trusted existing network
KPI: NPS ≥ 30, Day-7 Retention ≥ 30%

Phase 2: Closed Beta (Invite-only)
Goal: Strengthen PMF signals / Squash bugs / Collect testimonials
Target: 50–200 ICP-matching users
KPI: Sean Ellis Test ≥ 40%, Churn < 10%/month

Phase 3: Public Launch
Goal: Maximum awareness / Channel validation
Target: Public
KPI: Web traffic, Signups, Conversion, MRR
```

### 6.2. Product Hunt Launch Protocol

- **Rule 12.051**: When using Product Hunt, execute the following

```
Pre-Launch (4 weeks before):
□ Build up Hunter / Maker profiles
□ Contribute to the PH community (comments / upvotes)
□ Build awareness with teaser page / waitlist
□ Build supporter list (200+ people who will upvote)

Launch Day:
□ Go live at 12:01 AM PST (use the full day)
□ Blast across all social channels (Twitter/X, LinkedIn, Slack communities)
□ Upvote velocity in the first 2 hours determines Top 5 entry

Post-Launch:
□ Reply to all comments within 24 hours
□ Add acquired users to Soft Launch list
□ Publish follow-up metrics 1 month later
```

### 6.3. Launch Timing Principles

- **Rule 12.052**: Optimize launch timing based on the following

| Factor | Best Practice |
|:-------|:-------------|
| Day of week | Tue–Thu (B2B) / Around weekend (B2C consumer) |
| Season | Q1 & Q3 (budget execution periods; avoid Q4 holiday rush) |
| Industry events | Aim for the week before major conferences |
| Competitor activity | Avoid overlapping with major competitor launches |

---

## Part VII. Initial Customer Acquisition Protocol

### 7.1. Do Things That Don't Scale

- **Rule 12.060**: Initial customer acquisition is not bound by scalability. Prioritize building high-quality relationships directly, even if labor-intensive (Paul Graham, Y Combinator)

```
Unscalable acquisition examples:
- Founders manually respond to all support tickets
- Attend every conference where target customers are
- Individually customized outreach to 100 target companies
- Manual DMs to competitor's Twitter followers
- Directly embed in local communities
```

### 7.2. First 10 Customers Protocol

- **Rule 12.061**: Acquire the first 10 customers in this order

```
Step 1: Direct personal network (colleagues, friends, former coworkers)
Step 2: Ask for warm introductions to second-degree network
Step 3: Join target communities directly (lead with value, not pitches)
Step 4: Manual outreach in places where ICP gathers
Step 5: Cold Email (highly personalized only)
```

- **Rule 12.062**: The first 10 customers must **fully match the ICP**. A "whoever will sign up" attitude is prohibited

### 7.3. Customer Success as a GTM Engine

- **Rule 12.063**: In early stages, treat Customer Success (CS) as an acquisition engine
  - Proactively create case studies from existing customer successes
  - Ask NPS 9–10 customers for referrals
  - Playbook the behavior patterns of successful customers to enable replication

---

## Part VIII. GTM Metrics & Measurement

### 8.1. GTM KPI Dashboard

- **Rule 12.070**: Monitor GTM effectiveness with this metric framework

```
Acquisition Layer:
- Website sessions
- MQL count
- CAC per channel

Activation Layer:
- Signup → Trial Conversion Rate
- Time-to-First-Value
- Onboarding Completion Rate

Revenue Layer:
- MRR / ARR
- ACV distribution
- Deal Velocity (days from first contact to close)

Expansion Layer:
- Net Revenue Retention (NRR) ≥ 100% target
- Expansion MRR
- Referral Rate
```

### 8.2. Funnel Conversion Benchmarks

- **Rule 12.071**: Compare against these benchmarks to set improvement priorities

| Stage | B2B SaaS Standard | B2C Standard |
|:------|:-----------------|:------------|
| Visit → Signup | 2–5% | 5–15% |
| Signup → Activated | 20–40% | 30–60% |
| Trial → Paid | 15–30% | 2–8% |
| MQL → SQL | 15–25% | — |
| SQL → Closed Won | 20–30% | — |

### 8.3. GTM Attribution

- **Rule 12.072**: Implement multi-touch attribution to measure true channel contribution
  - Understand First Touch, Last Touch, Linear, Time Decay, and Data-driven models—then select the model appropriate for your business
  - Implement UTM parameters consistently across all channels; missing attribution is not acceptable

---

## Part IX. GTM Organization & Ownership

### 9.1. Revenue Team Structure

- **Rule 12.080**: Design GTM functions with the following roles (stack roles as appropriate for company stage)

| Role | Focus | When Needed |
|:-----|:------|:-----------|
| **AE** (Account Executive) | Closing | Monthly MRR ≥ $50K |
| **SDR** (Sales Dev Rep) | Pipeline generation | When AE is too busy |
| **CSM** (Customer Success Mgr) | Retain & expand | When churn becomes an issue |
| **PMM** (Product Marketing Mgr) | Positioning & enablement | Around Series A |
| **Growth Eng** | PLG & funnel optimization | When PLG is primary motion |

### 9.2. GTM Ownership Boundaries

- **Rule 12.081**: Clarify the boundary between Product and GTM ownership

```
Product owns:
- Onboarding flow (UI and copy)
- Product viral loop design
- Activation metric definition and achievement

GTM owns:
- Channel selection and execution
- Messaging & Positioning
- Pricing setting and changes
- Deal closing
```

### 9.3. Smarketing Protocol (Sales + Marketing Integration)

- **Rule 12.082**: Define collaboration protocols to eliminate Sales and Marketing silos
  - MQL/SQL definitions must be jointly agreed and documented by both
  - Share weekly MQL quality and feedback bidirectionally
  - Design evaluation systems where both teams are measured against a shared Revenue Target

---

## Part X. Appendix: Quick Reference & Cross-References

### Quick Reference Index (Keyword → Section)

| Keyword | Section |
|:--------|:--------|
| Positioning, Category Creation, Messaging Hierarchy | §2 Positioning |
| ICP, Persona, B2B, B2C, Scoring | §3 ICP |
| PLG, SLG, MLG, CLG | §4 GTM Motion |
| SEO, Paid, Cold Email, Channel Evaluation | §5 Channel Strategy |
| Product Hunt, Soft Launch, Beta | §6 Launch Plan |
| 10 Customers, Do Things That Don't Scale | §7 Initial Acquisition |
| KPI, Funnel, Attribution, NRR | §8 GTM Metrics |
| AE, SDR, CSM, PMM, Smarketing | §9 GTM Organization |

### Cross-References (Section → Related Rules)

| Section | Related Universal Rules |
|:--------|:-----------------------|
| §2 Positioning | `600_brand_strategy`, `000_product_strategy` |
| §3 ICP | `100_market_validation` (Customer Discovery) |
| §4 PLG | `000_product_strategy` (§4 Monetization) |
| §5 Channel | `500_growth_marketing` |
| §6 Launch | `500_growth_marketing` (PLG / SEO-GEO) |
| §7 Initial Acquisition | `operations/100_sales_bizdev` |
| §8 Metrics | `ai/100_data_analytics` |
| §9 GTM Organization | `operations/200_hr_organization` |
