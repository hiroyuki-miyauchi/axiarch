# 13. Pricing Strategy

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-04-06

> [!IMPORTANT]
> **Supreme Directive**
> "Price is the most important message in marketing. Getting pricing wrong is the same as getting positioning wrong."
> Price is not "cost plus margin" — it is **"the exchange for value delivered."** Discounting is the last resort and a signal that value communication has failed.
> **9 Parts · 35 Sections.**

---

## Table of Contents

- [Part I. Pricing Philosophy](#part-i-pricing-philosophy)
- [Part II. Pricing Model Design](#part-ii-pricing-model-design)
- [Part III. Pricing Methodology](#part-iii-pricing-methodology)
- [Part IV. Packaging & Tier Design](#part-iv-packaging--tier-design)
- [Part V. Price Change Protocol](#part-v-price-change-protocol)
- [Part VI. Pricing Experiments (A/B Testing)](#part-vi-pricing-experiments-ab-testing)
- [Part VII. Enterprise Pricing & Negotiation](#part-vii-enterprise-pricing--negotiation)
- [Part VIII. Pricing KPIs & Monitoring](#part-viii-pricing-kpis--monitoring)
- [Part IX. Appendix: Quick Reference & Cross-References](#part-ix-appendix-quick-reference--cross-references)

---

## Part I. Pricing Philosophy

### 1.1. Three Pricing Mistakes

- **Rule 13.001**: The following pricing approaches are defined as inappropriate

| Flawed Approach | Problem |
|:---------------|:--------|
| **Cost-plus pricing** | Ignores customer value; implies low differentiation |
| **Competitor-following** | Denies own differentiation; triggers price war spiral |
| **Gut-feel pricing** | No data; cannot determine if opportunity is being lost or churn is too high |

### 1.2. Value-Based Pricing

- **Rule 13.002**: The correct pricing principle is **to capture a portion of the value the customer receives**

```
Correct pricing starting point:
1. Quantify the value customers achieve with your product
   Example: Save 10 hours/month × $50/hour = $500/month in value
2. Price at 10–30% of that value
   Example: $500 × 20% = $100/month
3. Adjust for positioning vs. competitors
```

### 1.3. WTP Measurement Mandate

- **Rule 13.003**: Before setting price, **quantitatively measure WTP (Willingness to Pay)**
- The **Van Westendorp Price Sensitivity Meter (PSM)** is the standard approach

```
PSM 4 Questions:
1. "At what price would it be too expensive to consider?" (Too Expensive)
2. "At what price would it seem expensive but still consider?" (Expensive but Consider)
3. "At what price would it seem like a bargain?" (Cheap but Accept)
4. "At what price would it be so cheap you'd question quality?" (Too Cheap)

Optimal price range = Near intersection of Q2 and Q3
```

---

## Part II. Pricing Model Design

### 2.1. SaaS Pricing Model Types

- **Rule 13.010**: Select from the following pricing model types based on product characteristics

| Model | Description | Best For |
|:------|:-----------|:---------|
| **Flat Rate** | Single monthly fee | Simple products, early PMF validation |
| **Per Seat** (User-based) | Charge per user | Collaboration / communication tools |
| **Usage-based** | Charge per consumption | APIs, cloud, AI products |
| **Tiered** | Staged pricing by feature/volume | Most SaaS |
| **Hybrid** | Base fee + usage overage | Enterprise SaaS |
| **Freemium** | Free base + paid premium | Consumer, PLG products |

### 2.2. Usage-Based Pricing Design Protocol

- **Rule 13.011**: When adopting usage-based pricing, follow these selection criteria for the Value Metric

```
Value Metric Selection Criteria (choose one):
□ Increases proportionally as customers receive more value?
□ Understandable and predictable for the customer?
□ Measurable and controllable by you?
□ Easy for customers to compare against competitors?

Good Value Metric Examples:
- Twilio: messages sent (directly tied to action)
- Snowflake: compute query volume (proportional to value)
- Stripe: transaction volume (proportional to customer revenue)
```

### 2.3. Freemium Design Protocol

- **Rule 13.012**: When adopting freemium, design free plan limitations using these principles

```
Freemium Limitation Design Principles:
1. Let users "experience" the value but not "fulfill" it
2. Limits cause users to think "I want more"—not frustration
3. Upgrade is required when using with a team or organization

Good limitations:
- Project count (3 free, unlimited paid)
- Storage capacity (2GB free, more paid)
- Team members (3 free)
- API calls (1,000/month free)

Bad limitations:
- Core feature restrictions (can't experience core value)
- Excessive ads (severely damages UX)
```

---

## Part III. Pricing Methodology

### 3.1. Five-Step Pricing Process

- **Rule 13.020**: Set pricing for new products/plans using these 5 steps

```
Step 1: Quantify the Value Proposition
→ Customer interviews + ROI calculation

Step 2: Measure WTP
→ Van Westendorp PSM / Conjoint Analysis / Direct Survey

Step 3: Analyze WTP by Segment
→ Separate by ICP type and company size

Step 4: Compare with Competitor Pricing
→ Tier/Feature comparison positioning

Step 5: A/B Test on Pricing Page (§6)
→ Validate with real conversion data
```

### 3.2. Conjoint Analysis

- **Rule 13.021**: For large-scale services (ARR ≥ $1M), conduct Conjoint Analysis to understand per-attribute WTP
  - Present combinations of product attributes (features, support level, SLA, etc.) for customers to choose between, then reverse-engineer the value of each attribute
  - Minimum 100 responses required

### 3.3. Using Benchmark Pricing

- **Rule 13.022**: Competitor pricing is used as a **reference for the upper bound only**. Targeting lower prices than competitors as a strategy is prohibited in principle
- **Price setting guidelines**:
  - Equivalent functionality to competitors: 90–110% of competitor price
  - Clearly superior to competitors: 120–200% of competitor price
  - Entirely new category: Value-based (no competitor to compare)

---

## Part IV. Packaging & Tier Design

### 4.1. Tier Design Principles

- **Rule 13.030**: Price tiers must always be designed in **odd numbers** (2 choices are hard to decide; 4 choices cause information overload)
- **Rule 13.031**: Design so the most selected tier is the **middle tier** (The Goldilocks Principle)

```
Recommended tier structures:
Starter / Pro / Enterprise (3-tier)
or
Free / Growth / Business / Enterprise (4-tier, presented as 3 choices)
```

### 4.2. Decoy Pricing Design

- **Rule 13.032**: Design a "decoy" tier that makes the middle tier appear most rational—not to push toward the higher tier, but to make the center tier feel reasonable

### 4.3. Anchor Pricing

- **Rule 13.033**: Display higher prices **first / to the left** on the pricing page to lower the perceived price of the middle tier
- **Rule 13.034**: For annual plans, show the monthly equivalent and emphasize savings ("Only $X/month")

### 4.4. Feature Packaging Rules

- **Rule 13.035**: Guidelines for assigning features to tiers

```
Starter should include:
- Core value experience at minimum
- Features completeable by individual or small team

Pro should include:
- Team collaboration and permission management
- Advanced customization / API access
- Priority support

Enterprise should include:
- SSO / SAML
- Custom SLA / Dedicated CSM
- Advanced security & audit logs
- Custom contracts and billing
```

---

## Part V. Price Change Protocol

### 5.1. Price Change Decision Criteria

- **Rule 13.040**: Implement price changes only when the following conditions are met

| Trigger | Criteria |
|:--------|:---------|
| **Price increase justification** | NPS ≥ 50 / NRR ≥ 110% / Competitor price gap ≥ 30% |
| **Price decrease ban** | Permanent discounting outside campaigns is prohibited |
| **New tier** | A segment's WTP diverges significantly from current tiers |

### 5.2. Existing Customer Price Change Notification Protocol

- **Rule 13.041**: For price increases to existing customers, follow these steps

```
Required Steps:
1. Email notice 60 days before change (subject line must mention price change)
2. Clearly explain the reason (feature additions, quality improvements)
3. Provide a transition period (honor old price for 90 days)
4. Guarantee old price for annual subscribers until renewal
5. CS teams personally contact high-impact customers
```

### 5.3. Grandfather Clause

- **Rule 13.042**: When changing prices, consider applying a "Grandfather Clause" that guarantees current customers the existing price for a minimum period (6 months)
- **Exception**: Security or regulatory compliance requirements may override; minimize impact and explain to customers in advance

---

## Part VI. Pricing Experiments (A/B Testing)

### 6.1. Pricing A/B Test Ethics

- **Rule 13.050**: Strictly observe the following in pricing A/B tests
  - The same user must never see different prices simultaneously (use geo or cohort splits)
  - Answer honestly any customer inquiry about why prices differ during the test period
  - Price discrimination based on personal information (race, gender, etc.) is completely prohibited

### 6.2. Pricing Experiment Design Protocol

- **Rule 13.051**: Pre-define the following before running pricing experiments

```yaml
pricing_experiment:
  hypothesis: "Raising price from $39 to $49/month will keep conversion rate within a 5% drop"
  primary_metric: "Trial to Paid Conversion Rate"
  secondary_metrics:
    - "MRR per Signup"
    - "Refund Rate"
    - "NPS"
  sample_size: "Minimum 200 signups per group"
  duration: "Minimum 4 weeks"
  statistical_significance: 95%
```

### 6.3. Prohibited Pricing Experiment Cases

- **Rule 13.052**: Pricing experiments are prohibited in these situations
  - Running independently without CMO/CEO approval
  - Making decisions with insufficient sample size for statistical significance
  - Simultaneously changing multiple variables (feature + price)

---

## Part VII. Enterprise Pricing & Negotiation

### 7.1. Enterprise Pricing Principles

- **Rule 13.060**: Manage Enterprise tier pricing with these principles
  - **Anchor High**: Initial quote is set high—build in buffer for customer discount pressure
  - **Price Floor**: Define a minimum price (floor) not to be breached under any negotiation—defined internally
  - **Discount Authority**: Clearly define discount authority by level (SDR: 0%, AE: ≤10%, VP: ≤20%, CEO: ≤30%)

### 7.2. Discount Request Response Protocol

- **Rule 13.061**: Handle customer discount requests with this process

```
Step 1: Offer an alternative to discounting
  e.g.: Offer annual prepayment (15% discount for upfront)
  e.g.: Success-sharing model (additional charge when ROI materializes)

Step 2: When discounting, always exchange for something
  e.g.: 6-month prepayment / Case study participation / Beta feature access

Step 3: Tie discounts to renewal commitments
  e.g.: "This discount applies only if you commit to renewing next cycle"

Prohibited: Discounting for no reason ("Sure, we can do that" with no structure)
```

### 7.3. Multi-Year Contract Incentive Structure

- **Rule 13.062**: Design the following incentive structure when recommending multi-year contracts

```
Contract Duration Discount Schedule (example):
Monthly: List price (100%)
Annual: 17% discount (equivalent to 2 months free)
2-year: 25% discount
3-year: 30% discount

Note: Discount commitments are designed as prepayment conditions
```

---

## Part VIII. Pricing KPIs & Monitoring

### 8.1. Price Health Metrics

- **Rule 13.070**: Monitor the following metrics monthly to assess pricing strategy health

| Metric | Target | Warning |
|:-------|:-------|:--------|
| **Average Revenue Per Account (ARPA)** | MoM ≥ 0% | 2 consecutive months declining |
| **Discount Rate** | ≤ 15% of deals | > 30% of deals |
| **Net Revenue Retention (NRR)** | ≥ 110% | < 100% (revenue contraction) |
| **Price-to-Value Ratio** | NPS 9-10 spontaneously say "great value" | Increasing "too expensive" mentions |
| **Expansion MRR** | ≥ 20% of total MRR growth | ≤ 5% |

### 8.2. Price-to-Churn Correlation Analysis

- **Rule 13.071**: Analyze churn rates by pricing tier monthly

```
Example:
Starter: Churn 8%/month
Pro: Churn 3%/month
Enterprise: Churn 0.5%/month

If Starter churn is high, choose one:
  a) Improve Starter Onboarding
  b) Lower Starter price to extend lifetime value
  c) Eliminate Starter and push all users to Pro
```

### 8.3. Competitive Pricing Monitoring

- **Rule 13.072**: Monitor competitor pricing quarterly and evaluate:
  - If a competitor raises price: Your relative value-for-money improves → opportunity to raise price
  - If a competitor lowers price: Determine if it's a "price war" or "we need to communicate value better"
  - If a competitor adds a new tier: Evaluate segment trends

---

## Part IX. Appendix: Quick Reference & Cross-References

### Quick Reference Index (Keyword → Section)

| Keyword | Section |
|:--------|:--------|
| Value-Based Pricing, WTP, PSM | §1 Philosophy / §3 Methodology |
| Flat Rate, Per Seat, Usage-based, Freemium | §2 Pricing Models |
| Conjoint Analysis, Benchmarking | §3 Methodology |
| Tier Design, Decoy, Anchoring, Packaging | §4 Packaging |
| Price Increase, Grandfather Clause | §5 Price Change |
| A/B Test, Experiment Ethics | §6 Experiments |
| Enterprise, Discounts, Multi-year | §7 Enterprise |
| ARPA, NRR, Discount Rate | §8 KPI Monitoring |

### Cross-References (Section → Related Rules)

| Section | Related Universal Rules |
|:--------|:-----------------------|
| §1 Value-Based Pricing | `300_revenue_monetization` (Unit Economics) |
| §2 Freemium Design | `000_product_strategy` (§4 Monetization) |
| §3 WTP Measurement | `100_market_validation` (Customer Interviews) |
| §6 Pricing A/B Test | `ai/100_data_analytics` (A/B Test Statistics) |
| §7 Enterprise | `operations/100_sales_bizdev` (Sales Process) |
| §8 NRR / Expansion | `300_revenue_monetization` (Unit Economics) |
