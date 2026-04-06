# 11. Market Validation & Product-Market Fit

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-04-06

> [!IMPORTANT]
> **Supreme Directive**
> "A hypothesis is not a fact. Conviction without data is an illusion."
> **43% of startups fail due to unvalidated Product-Market Fit (CB Insights, 2025).**
> Ask the market before you build. Maximize learning. Evidence comes before code.
> **12 Parts · 45 Sections.**

---

## Table of Contents

- [Part I. Market Validation Philosophy](#part-i-market-validation-philosophy)
- [Part II. Problem Discovery & Definition](#part-ii-problem-discovery--definition)
- [Part III. Market Size Quantification](#part-iii-market-size-quantification)
- [Part IV. Customer Discovery Process](#part-iv-customer-discovery-process)
- [Part V. Hypothesis Structuring & Prioritization](#part-v-hypothesis-structuring--prioritization)
- [Part VI. MVP Design](#part-vi-mvp-design)
- [Part VII. PMF Measurement & Determination](#part-vii-pmf-measurement--determination)
- [Part VIII. Post-PMF Scale Judgment](#part-viii-post-pmf-scale-judgment)
- [Part IX. Competitive Analysis Framework](#part-ix-competitive-analysis-framework)
- [Part X. Pivot Decision Protocol](#part-x-pivot-decision-protocol)
- [Part XI. Research & Data Collection Architecture](#part-xi-research--data-collection-architecture)
- [Part XII. Appendix: Quick Reference & Cross-References](#part-xii-appendix-quick-reference--cross-references)

---

## Part I. Market Validation Philosophy

### 1.1. Avoiding the Build Trap

- **Rule 11.001**: The absolute principle is "Build because there is demand," not "Build because we can"
- **Rule 11.002**: In the first 3 months, allocate ≥ 50% of resources to "validation." Premature over-investment in building is prohibited
- **Build Trap Definition**: The state of mistaking feature count or shipping speed for progress instead of user value

### 1.2. Validated Learning

- **Rule 11.003**: All decisions follow: Hypothesis → Experiment → Measure → Learn
- **Rule 11.004**: The statement "We believe this is correct" must be treated as a hypothesis—not a certainty
- **Lean Startup Loop**:

```
Hypothesis (Build) → Minimum Validation (Measure) → Data Analysis (Learn) → Next Hypothesis
```

### 1.3. Evidence Hierarchy

| Rank | Evidence Type | Reliability |
|:-----|:-------------|:-----------|
| 1 | Actual purchase / payment behavior | ★★★★★ |
| 2 | Pre-order / Letter of Intent (LOI) | ★★★★ |
| 3 | Active prototype usage | ★★★★ |
| 4 | Behavioral user interviews | ★★★ |
| 5 | Surveys / intent polls | ★★ |
| 6 | Competitor existence / market trends | ★ |
| 7 | Emotional reactions ("interesting!") | ✗ (Invalid) |

- **Rule 11.005**: Making major investment decisions based solely on Rank 5 or below evidence is prohibited

---

## Part II. Problem Discovery & Definition

### 2.1. Jobs-to-be-Done (JTBD) Framework

- **Rule 11.010**: Design starting from "the Job the user wants to accomplish," not "the product's features"
- **Three Layers of JTBD**:

```
Functional Job: The actual task to be accomplished
    Example: Complete tax filing accurately before the deadline

Emotional Job: How the user wants to feel
    Example: Feel accomplished and free of anxiety

Social Job: How they want to be perceived by others
    Example: Be recognized as someone who manages finances well
```

### 2.2. Pain Severity Scoring

- **Rule 11.011**: Score discovered problems with the following criteria to prioritize

| Axis | Score | Criteria |
|:-----|:------|:---------|
| **Frequency** | 0-3 | Daily=3, Weekly=2, Monthly=1, Less=0 |
| **Severity** | 0-3 | Operations halted=3, Very inefficient=2, Minor=1, Not a problem=0 |
| **Urgency** | 0-3 | Pay now=3, Budget permitting=2, Eventually=1, No change desired=0 |
| **Dissatisfaction with alternatives** | 0-3 | No alternatives=3, Very dissatisfied=2, Dissatisfied=1, Satisfied=0 |

- **Pain Score ≥ 8**: Worth pursuing
- **Pain Score < 5**: Question the market opportunity

### 2.3. Formalizing the Problem Statement

- **Rule 11.012**: Explicitly document the problem being addressed in the following format

```
[Persona] in [situation/context],
experiences [challenge/frustration],
and currently uses [current solution],
but cannot fully resolve it because of [shortcoming].
```

---

## Part III. Market Size Quantification

### 3.1. TAM / SAM / SOM Definition

- **Rule 11.020**: Always quantify TAM, SAM, and SOM before starting a business

| Metric | Definition | Approach |
|:-------|:-----------|:---------|
| **TAM** | Total size of the market with the problem | Top-down (industry reports) |
| **SAM** | Market that can actually be reached | Bottom-up (segment × price) |
| **SOM** | Market realistically obtainable | Based on competitive share & GTM capacity |

- **Rule 11.021**: Use TAM ≥ $1B and SOM ≥ $10M as entry threshold guidelines

### 3.2. Bottom-Up Market Sizing Protocol

- **Rule 11.022**: Use top-down reports only as "reality checks." **Always run bottom-up calculations for strategic decisions**

```
SOM = Target Users × Conversion Rate × ARPU × 12 months

Example:
Target Users: 500,000
Conversion Rate: 3%
ARPU: $20/month
SOM = 500,000 × 0.03 × 20 × 12 = $3.6M/year
```

### 3.3. Market Growth Evaluation

- **Rule 11.023**: Evaluate **CAGR (Compound Annual Growth Rate)**, not just current market size
- **Standard**: Prioritize markets with CAGR ≥ 15%
- **Rule 11.024**: **Entering markets with negative CAGR (< 0%) is prohibited in principle**

---

## Part IV. Customer Discovery Process

### 4.1. Customer Interview Protocol

- **Rule 11.030**: Conduct at least **20 customer interviews** before starting product development
- **Rule 11.031**: Strictly enforce the following prohibitions during interviews

| Prohibited | Reason |
|:-----------|:-------|
| Leading questions ("Do you think X?") | Reinforces confirmation bias |
| Describing product idea first | Respondent will affirm to be polite |
| Hypothetical future questions ("Would you use...?") | Intent diverges from behavior |
| Asking for feedback on solutions | Becomes validation, not discovery |

- **The Mom Test Principle**: Only ask questions your mother couldn't lie about. Don't talk about your idea; just dig into problems

### 4.2. Interview Question Design

```
Recommended patterns:
1. "What is the hardest thing about [problem area]?"
2. "Tell me about the last time that happened."
3. "How do you currently handle that?"
4. "What's frustrating about your current approach?"
5. "Have you ever paid for a solution to this problem?"
6. "Would you switch from your current approach if something better existed?"
```

### 4.3. Early Adopter Identification Protocol

- **Rule 11.032**: Focus first customers entirely on "Early Adopters"—targeting the mass market simultaneously is prohibited
- **4 Conditions for Early Adopters**:
  1. Strongly aware of the problem
  2. Already actively trying to solve it
  3. Currently paying for a solution (or willing to)
  4. Willing to tolerate an imperfect solution

### 4.4. Interview Analysis Process

- **Rule 11.033**: Structure notes within 24 hours of each interview

```yaml
interview_record:
  date: "YYYY-MM-DD"
  persona_match: [high|medium|low]
  top_pain: "Concise description of the most critical pain"
  current_solution: "Current workaround"
  willingness_to_pay: [confirmed|likely|unlikely|no]
  key_quote: "Important verbatim statement"
  signals:
    - type: [positive|negative|neutral]
      note: "Specific insight"
```

---

## Part V. Hypothesis Structuring & Prioritization

### 5.1. Assumption Map

- **Rule 11.040**: Identify "critical yet unvalidated assumptions" and place them on a priority matrix

```
High Risk (High Importance × Unvalidated) → Top priority to test
Low Priority (Low Importance × Unvalidated) → Defer
Validated (Any importance) → Treat as established premise
```

### 5.2. Leap of Faith Hypotheses

- **Rule 11.041**: Explicitly identify the "Leap of Faith" hypotheses on which the entire business rests
  - **Value Hypothesis**: Will users actually use this product?
  - **Growth Hypothesis**: How will new users be acquired?

### 5.3. Hypothesis Log (Mandatory)

- **Rule 11.042**: Track all major hypotheses in a hypothesis log in Blueprint

| Column | Content |
|:-------|:--------|
| Hypothesis ID | Format: H-001 |
| Hypothesis | Specific description |
| Importance | Critical / High / Medium / Low |
| Status | Unvalidated / Testing / Validated / Invalidated |
| Test Method | Experiment design |
| Results | Data and insights |

---

## Part VI. MVP Design

### 6.1. Clarifying the Definition of MVP

- **Rule 11.050**: Define MVP not as "minimum feature set" but as "the smallest experimental unit to learn the fastest"
- **Rule 11.051**: MVP types and their purposes

| MVP Type | Description | Use |
|:---------|:-----------|:----|
| **Concierge MVP** | Deliver service manually | Demand & willingness validation |
| **Wizard of Oz MVP** | Manual backend behind automated-looking UI | UX and feasibility |
| **Landing Page MVP** | Measure response rate from LP only | Demand & messaging |
| **Prototype MVP** | Interactive mockup | UX validation |
| **Pre-order MVP** | Sell before building | Strongest WTP validation |
| **Fake Door MVP** | CTA for non-existent feature | Feature demand quantification |

### 6.2. MVP Scope Restriction Protocol

- **Rule 11.052**: MVP features are limited to "the minimum set to test one core value hypothesis"
- **Rule 11.053**: MVP development period must not exceed **8 weeks**. Reduce scope if it does
- **Rule 11.054**: Explicitly document "what will be learned" from the MVP before development begins

### 6.3. Smoke Test Protocol

- **Rule 11.055**: Before building, run smoke tests with predefined success criteria

```
Success Criteria Examples:
- LP email capture rate ≥ 15%
- Early access or pre-order signups ≥ 100 in 30 days
- Signed LOI from ≥ 5 interviews
```

---

## Part VII. PMF Measurement & Determination

### 7.1. Key PMF Metrics

- **Rule 11.060**: Use the following composite metrics to declare PMF. Declaring based on a single metric alone is prohibited

| Metric | PMF Threshold | Method |
|:-------|:-------------|:-------|
| **Sean Ellis Test** | "Very Disappointed" ≥ 40% | Survey |
| **Net Promoter Score** | ≥ +50 (consumer) / ≥ +30 (B2B) | 0-10 survey |
| **Retention Curve** | Flattens to horizontal | Cohort analysis |
| **Organic Growth** | ≥ 30% of new users are organic | Channel breakdown |
| **DAU/MAU** | ≥ 20% (social/messaging) | Active user ratio |

### 7.2. Sean Ellis Test Protocol

- **Rule 11.061**: Administer the following question to **at least 50 actual users**

```
"How would you feel if you could no longer use this product?"
□ Very Disappointed ← 40%+ = PMF signal
□ Somewhat Disappointed
□ Not Disappointed
□ I no longer use it
```

### 7.3. Retention Curve Analysis

- **Rule 11.062**: Monitor cohort retention curves weekly

```
Characteristics of a Healthy Retention Curve:
1. After the initial drop (post Day 1), curve flattens horizontally
2. D30 Retention exceeds:
   - Social / Messaging: ≥ 25%
   - Professional SaaS: ≥ 80%
   - E-commerce: ≥ 20% (repurchase within 90 days)
3. Newer cohorts show improving retention (product is getting better)
```

### 7.4. False PMF Signal Warning Protocol

- **Rule 11.063**: The following situations must be treated as "false PMF signals"

| False Signal | Reason | Correct Action |
|:------------|:-------|:--------------|
| Only friends/colleagues using it | Social pressure, not genuine demand | Re-test with 50+ strangers |
| High usage only during free period | Price sensitivity untested | Measure paid conversion rate |
| Temporary spike after PR/buzz | Sustained usage not validated | Check retention 1 month later |
| Usage dependent on a specific event | No repeatability | Measure out-of-event usage |

---

## Part VIII. Post-PMF Scale Judgment

### 8.1. PMF → Growth Transition Criteria

- **Rule 11.070**: Expand marketing investment **only when ALL of the following are met**

```
Required (AND):
□ Sean Ellis Test ≥ 40% (n≥50)
□ D30 Retention exceeds industry standard
□ NPS ≥ 30
□ CAC payback period ≤ 12 months
□ Organic growth ≥ 20% of total acquisition
```

### 8.2. Premature Scaling Ban

- **Rule 11.071**: Increasing ad spend, rapid hiring, or excessive feature launches before PMF is explicitly prohibited as "Premature Scaling"
- **Evidence**: CB Insights analysis shows 74% of startup failures are attributed to premature scaling before PMF

### 8.3. Product Health Check Before Scaling

- **Rule 11.072**: Perform the following product health check before transitioning to scale

| Check | Standard |
|:------|:---------|
| Core Feature Activation Rate | ≥ 60% |
| Onboarding Completion Rate | ≥ 50% |
| Support Tickets / DAU | ≤ 5% |
| Page Load Performance (LCP) | ≤ 2.5 seconds |
| Uptime (last 30 days) | ≥ 99.5% |

---

## Part IX. Competitive Analysis Framework

### 9.1. Competitive Mapping Protocol

- **Rule 11.080**: Before entering, map direct and indirect competitors in a 4-quadrant framework

```
            High Performance / High Price
                       │
    Niche Competitors  │  Market Leaders
                       │
  ─────────────────────────────────
  Narrow Audience      │           Broad Audience
                       │
    Weak Competitors   │  Challenger Competitors
                       │
            Low Performance / Low Price
```

### 9.2. Differentiation Principles

- **Rule 11.081**: Define at least one point where you are "10x Better" than competitors. "2x Better" is insufficient justification to enter
- **10x Better Examples**:
  - 10x faster (Uber vs. waiting for a taxi)
  - 1/10 the cost (Airbnb vs. hotel)
  - 10x more accessible (Canva vs. Photoshop)
  - Dramatically superior experience (iPhone vs. feature phone)

### 9.3. Moat Design

- **Rule 11.082**: Consciously design competitive moats from the earliest stage

| Moat Type | Description | Example |
|:----------|:-----------|:--------|
| **Network Effects** | More users = more value | Slack, WhatsApp |
| **Switching Costs** | High cost to switch | Salesforce, SAP |
| **Data Moat** | Proprietary data accumulation | Google, Netflix |
| **Economies of Scale** | Larger = greater advantage | Amazon |
| **Brand** | Trust and loyalty | Apple, Nike |

---

## Part X. Pivot Decision Protocol

### 10.1. Objective Pivot Criteria

- **Rule 11.090**: Pivot decisions are made based on data, not emotion

| Pivot Trigger | Definition |
|:-------------|:-----------|
| **PMF not achieved** | Sean Ellis Test < 30% after 2+ MVP tests |
| **Retention collapse** | D30 Retention < 10% for 3 consecutive cohorts |
| **CAC > LTV** | Unit economics not viable |
| **Market disappears** | Regulatory or technology shift eliminates market |
| **Loss of competitive advantage** | Big player entry makes differentiation meaningless |

### 10.2. Types of Pivots

- **Rule 11.091**: When pivoting, clearly define the pivot type

| Pivot Type | Example |
|:-----------|:--------|
| **Zoom-in** | One feature becomes the entire product |
| **Zoom-out** | Product becomes part of a larger system |
| **Customer Segment** | Change the target customer |
| **Platform** | App becomes a platform |
| **Business Architecture** | B2C to B2B2C |
| **Value Capture** | Change the revenue model |
| **Technology** | Solve same problem with different technology |

### 10.3. Pivot Execution Protocol

- **Rule 11.092**: Always follow this process when executing a pivot
  1. Update current hypothesis log to "Invalidated"
  2. Define new Leap of Faith hypotheses
  3. Design new MVP and success metrics
  4. Assess impact on existing users and create communication plan
  5. Explain to the full team and re-establish commitment

---

## Part XI. Research & Data Collection Architecture

### 11.1. Mixed Methods Protocol

- **Rule 11.100**: Always combine quantitative and qualitative market research

| Method | Role | When |
|:-------|:----|:------|
| **Qualitative Interviews** | Understand "Why?" | Hypothesis building phase |
| **Surveys / Quantitative** | Measure "How much?" | Hypothesis validation phase |
| **Behavioral Data** | See "What actually happened?" | Ongoing PMF measurement |
| **A/B Testing** | Determine "Which is better?" | Optimization phase |

### 11.2. Research Data Quality Control

- **Rule 11.101**: Apply the following quality standards to collected data

| Bias Type | Prevention |
|:----------|:-----------|
| **Survivorship Bias** | Collect failure cases as well as successes |
| **Confirmation Bias** | Actively seek data that contradicts the hypothesis |
| **Self-report Bias** | Prioritize behavioral data over stated intent |
| **Sampling Bias** | Exclude users outside the target |

### 11.3. Continuous Discovery Process

- **Rule 11.102**: After achieving PMF, continue weekly user research (Teresa Torres method)
  - Conduct at least 1 user interview per week as a standard team activity
  - Visualize and manage insights in an Opportunity Solution Tree (OST)
  - All feature proposals must be linked to user research

---

## Part XII. Appendix: Quick Reference & Cross-References

### Quick Reference Index (Keyword → Section)

| Keyword | Section |
|:--------|:--------|
| Build Trap, Validated Learning | §1 Philosophy |
| JTBD, Pain Score, Problem Statement | §2 Problem Definition |
| TAM, SAM, SOM, CAGR | §3 Market Size |
| Customer Discovery, Interview, Mom Test | §4 Customer Discovery |
| Hypothesis, Leap of Faith, Hypothesis Log | §5 Hypothesis Management |
| MVP, Smoke Test, Concierge | §6 MVP Design |
| Sean Ellis Test, PMF, NPS, Retention | §7 PMF Measurement |
| Premature Scaling, Scale Criteria | §8 Scale Judgment |
| Competitor, Moat, 10x Better | §9 Competitive Analysis |
| Pivot, Pivot Triggers | §10 Pivot |
| Mixed Methods, Continuous Discovery | §11 Data Collection |

### Cross-References (Section → Related Rules)

| Section | Related Universal Rules |
|:--------|:-----------------------|
| §3 Market Size | `300_revenue_monetization` (Unit Economics) |
| §4 Customer Discovery | `000_core_mindset` (Persona Protocol) |
| §6 MVP Design | `000_product_strategy` (§1.1 MVP to PMF) |
| §7 PMF Measurement | `500_growth_marketing`, `ai/100_data_analytics` |
| §8 Scale | `200_go_to_market`, `300_revenue_monetization` |
| §9 Competitive Analysis | `000_product_strategy` (Exit Strategy) |
| §10 Pivot | `000_core_mindset` (§1.1 Pivot Principle) |
