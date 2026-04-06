# 51. Sales & Business Development

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-04-06

> [!IMPORTANT]
> **Supreme Directive**
> "Sales is not about deceiving customers — it's about helping them make the right decision."
> The sales process is designed as **"a system to accelerate and optimize the customer's learning and decision-making."**
> Design for pull, not push.
> **10 Parts · 38 Sections.**

---

## Table of Contents

- [Part I. Sales Philosophy & Culture](#part-i-sales-philosophy--culture)
- [Part II. Sales Process Design](#part-ii-sales-process-design)
- [Part III. Qualification Framework (MEDDIC)](#part-iii-qualification-framework-meddic)
- [Part IV. Outbound Sales Protocol](#part-iv-outbound-sales-protocol)
- [Part V. Demo & Presentation Design](#part-v-demo--presentation-design)
- [Part VI. Proposals & Price Negotiation Protocol](#part-vi-proposals--price-negotiation-protocol)
- [Part VII. CRM & Pipeline Management](#part-vii-crm--pipeline-management)
- [Part VIII. Sales Enablement](#part-viii-sales-enablement)
- [Part IX. Business Development (BizDev)](#part-ix-business-development-bizdev)
- [Part X. Appendix: Quick Reference & Cross-References](#part-x-appendix-quick-reference--cross-references)

---

## Part I. Sales Philosophy & Culture

### 1.1. Modern Sales Philosophy

- **Rule 51.001**: Completely eliminate any culture that equates "sales" with "manipulation or hard-sell"
- **Rule 51.002**: The best sales activity is **"helping the customer find the reason to buy"**
- **The Challenger Sale Principles (Matthew Dixon & Brent Adamson)**:

| Sales Profile | Characteristics | Performance |
|:-------------|:---------------|:-----------|
| **Relationship Builder** | Relationship-focused | Average (most common type) |
| **Hard Worker** | Diligent, persistent | Average |
| **Lone Wolf** | Unique style | High (hard to replicate) |
| **Problem Solver** | Problem-oriented | High |
| **Challenger** ★ | Teach, tailor, take control | **Highest** |

- **Rule 51.003**: Train and develop toward the Challenger sales type as the standard—providing customers new perspectives and changing their thinking

### 1.2. Value Selling Principles

- **Rule 51.004**: Center all sales activity on value, not price
  - Returning to "feature explanations" when a customer cannot grasp ROI is prohibited
  - If ROI cannot be calculated, return to the Economic Buyer using MEDDIC §3

### 1.3. Customer-Centric Selling

- **Rule 51.005**: Tie all sales communication to "customer business outcomes"

```
Prohibited Talk (feature-centric):
"This tool has a real-time sync feature."

Recommended Talk (outcome-centric):
"You mentioned approval workflows currently take an average of 3 days.
 With real-time sync, same-day completion becomes possible.
 For 10 approvals per month, that's potentially 30 hours recovered monthly."
```

---

## Part II. Sales Process Design

### 2.1. Sales Funnel Definition

- **Rule 51.010**: Define the sales process in the following stages, with progression criteria documented in Blueprint

```
Lead
  ↓ [Condition: ICP match score ≥ 60]
MQL (Marketing Qualified Lead)
  ↓ [Condition: Intent signal confirmed — inquiry, content download, etc.]
SQL (Sales Qualified Lead)
  ↓ [Condition: Initial BANT/MEDDIC qualification]
SAL (Sales Accepted Lead)
  ↓ [Condition: First meeting complete, continued interest confirmed]
Opportunity
  ↓ [Condition: Budget, decision-maker, and timeline identified]
Proposal
  ↓ [Condition: Proposal document and quote delivered]
Negotiation
  ↓ [Condition: Terms agreed]
Closed Won / Closed Lost
```

### 2.2. Opportunity Stage Win Rate Management

- **Rule 51.011**: Assign close probabilities (Win Rates) to each stage to improve forecast accuracy

| Stage | Probability (Example) |
|:------|:---------------------|
| SQL | 10% |
| SAL | 20% |
| Opportunity | 30% |
| Proposal | 60% |
| Negotiation | 80% |
| Verbal Commit | 95% |

- **Rule 51.012**: Calculate weekly pipeline forecasts in 3 scenarios: optimistic, realistic, and pessimistic

### 2.3. Sales Cycle Management

- **Rule 51.013**: Measure average sales cycle from first contact to close and implement continuous reduction initiatives

```
Key Sales Cycle Reduction Strategies:
1. Confirm the next step on every meeting, in the moment (no "floating")
2. Bring in the decision-maker early (identify power sponsor, not just Champion)
3. Create and share a Mutual Close Plan (agreed-upon timeline and steps)
4. When competitors exist, clarify "why us" early
```

---

## Part III. Qualification Framework (MEDDIC)

### 3.1. MEDDIC Framework Definition

- **Rule 51.020**: Use **MEDDIC** to evaluate B2B sales opportunities

| Element | Definition | Questions to Ask |
|:--------|:-----------|:----------------|
| **M** Metrics | Quantified ROI basis | "What's the gap between current state and your goal?" |
| **E** Economic Buyer | Budget decision-maker | "Who gives the final go?" |
| **D** Decision Criteria | Decision-making criteria | "What's the most important factor in your selection?" |
| **D** Decision Process | Decision-making process | "How many weeks does it usually take from approval to contract?" |
| **I** Identify Pain | Identified pain | "What's the most painful problem right now?" |
| **C** Champion | Internal advocate | "Can you champion this internally?" |

### 3.2. Champion Identification Protocol

- **Rule 51.021**: The presence or absence of a Champion is the single biggest driver of win rate

```
3 Conditions for a Champion:
1. Power (Has authentic internal influence)
2. Access (Can directly reach the Economic Buyer)
3. Advocate (Has personal motivation to drive the product's success)

Who is NOT a Champion:
- Just says "I think it's a good product"
- Won't bring senior stakeholders to meetings
- Stuck saying "Let me check with my manager" with no movement
```

### 3.3. MEDDIC Scoring Implementation

- **Rule 51.022**: Score MEDDIC completeness on each CRM Opportunity to track pipeline quality

```javascript
// Example MEDDIC scoring
const meddicScore = {
  metrics: hasQuantifiedROI ? 1 : 0,
  economicBuyer: hasMetEB ? 2 : hasIdentifiedEB ? 1 : 0,
  decisionCriteria: hasDocumentedCriteria ? 1 : 0,
  decisionProcess: hasTimelineAgreed ? 1 : 0,
  identifyPain: hasDocumentedPain ? 1 : 0,
  champion: isValidated ? 2 : hasSuspect ? 1 : 0,
};
// Total ≤ 4: Low quality / 5-6: Average / 7+: High quality
```

---

## Part IV. Outbound Sales Protocol

### 4.1. Cold Email Design Principles

- **Rule 51.030**: Cold emails must be built on these 5 components and kept under 200 words

```
1. Personalization (why you're reaching out to them specifically):
   "I read your article on X. I saw you're working on Y..."

2. Problem (raise a relevant pain):
   "Companies at your stage often struggle with..."

3. Solution (value proposition):
   "We help companies like yours solve this by..."

4. Social Proof (credibility):
   "Company X reduced [metric] by Y% within 3 months..."

5. CTA (clear, low-friction next step):
   "Would you be open to a 15-minute call?"
```

### 4.2. Sequence Design

- **Rule 51.031**: Outbound is a multi-touch sequence, not a single email

```
Day 1: Email (main message)
Day 3: LinkedIn connection + message
Day 5: Follow-up email (add value)
Day 8: Email (different angle)
Day 12: Final Attempt (soft breakup)

Goal: 5 touches per sequence; no reply = move to next target
```

### 4.3. Anti-Spam Compliance Protocol

- **Rule 51.032**: All outbound email activity must comply with applicable law
  - US: CAN-SPAM Act
  - EU: GDPR + ePrivacy Directive
  - Always include an Unsubscribe link; automate processing of opt-outs immediately

---

## Part V. Demo & Presentation Design

### 5.1. Demo Structure Principles

- **Rule 51.040**: Structure demos in the following order

```
1. Agenda confirmation (5%): Share today's goal
2. Discovery confirmation (15%): "You said the biggest pain point is X—correct?"
3. Story-based demo (60%): "Let's walk through what that looks like for your scenario..."
4. Q&A (15%): Address all doubts in real time
5. Next Steps (5%): Agree on next action before leaving the meeting
```

### 5.2. Demo Prohibitions

- **Rule 51.041**: The following behaviors during demos are prohibited

```
Prohibited:
❌ Full product tour (showing features irrelevant to customer's problems)
❌ "Hold questions for the end" (doubts should be resolved as they arise)
❌ Visible unpreparedness in presentation style
❌ Unexpected bugs or errors (use a dedicated demo environment)
❌ Running out of time before Next Steps are agreed
```

### 5.3. Discovery Design (Pre-Demo Needs Assessment)

- **Rule 51.042**: Always conduct **Discovery** before a demo to understand the customer's specific situation

```
Required Discovery Questions:
□ Current workflow and pain points
□ What triggered the search for a solution now
□ Current tools being used and their frustrations
□ Definition of success (what improvement = "success" to them)
□ Decision timeline and decision-maker identity
□ Budget range (confirmed directly or indirectly)
```

---

## Part VI. Proposals & Price Negotiation Protocol

### 6.1. Proposal Document Standard

- **Rule 51.050**: Proposals must be built on this structure

```
1. Executive Summary (1 page): Customer problem and proposed solution summary
2. Current State & Problem: Restate the customer's pain in their own words
3. Proposed Solution: Scope, features, implementation plan
4. ROI Calculation: Before/after quantification
5. Social Proof: Case study from a similar company
6. Pricing: Clear cost breakdown
7. Timeline: Predicted path from implementation to results
8. Next Steps: Clear deadline-attached actions
```

### 6.2. Handling Discount Requests (Linked to §13 Pricing Strategy)

- → See **`400_pricing_strategy.md` §7**

### 6.3. PoC (Proof of Concept) Design Protocol

- **Rule 51.051**: When running a PoC, pre-agree on these conditions before starting

```
Pre-PoC Mutual Close Plan Agreements:
□ Define PoC success criteria quantitatively
   Example: "10 users using the system 3+ times/week in 3 weeks"
□ Time-box the PoC (maximum 30 days)
□ Pre-agree on next action upon PoC success (→ contract!)
□ Clarify mutual commitments (resource allocation, data preparation)

Prohibited: PoCs without success criteria (risk of endless evaluation periods)
```

---

## Part VII. CRM & Pipeline Management

### 7.1. CRM Input Rules

- **Rule 51.060**: CRM data hygiene is a mandatory requirement; the following are required fields

```
Opportunity Required Fields:
- Account Name / Contact Name
- Deal Size (estimated)
- Stage (with MEDDIC score)
- Close Date (estimated)
- Next Step (specific action + date)
- Last Activity Date (auto-updated)
- Source (lead acquisition channel)
```

### 7.2. Pipeline Review Standards

- **Rule 51.061**: Conduct pipeline reviews at the following cadences

| Review | Frequency | Participants | Focus |
|:-------|:----------|:------------|:------|
| **Pipeline Review** | Weekly | AE + Sales Manager | Stage updates / booking forecast |
| **Deal Review** | Bi-weekly | AE + Mgr + SE | Resolve stalled deals |
| **Forecast Review** | Monthly | Sales Leader + CEO | Revenue forecast / resource planning |
| **Win/Loss Review** | Quarterly | All Sales + PM | Win rate improvement / product feedback |

### 7.3. Win/Loss Analysis Protocol

- **Rule 51.062**: All Closed Lost opportunities must be recorded with the following loss reason classification

| Loss Reason | Improvement Owner |
|:-----------|:-----------------|
| **No Budget** | Improve timing / budget cycle awareness |
| **Chose Competitor** | Strengthen differentiation / competitive analysis |
| **No Timeline** | Strengthen early MEDDIC verification |
| **Lost Champion** | Need for Champion diversification |
| **Product Gap** | PM feedback channel |
| **Price** | Pricing strategy / ROI communication improvement |

---

## Part VIII. Sales Enablement

### 8.1. Sales Playbook Structure

- **Rule 51.070**: Manage the Sales Playbook in Blueprint with the following required contents

```
Sales Playbook Required Content:
1. ICP definition and qualification checklist
2. Product Positioning (messaging per persona)
3. Competitor Battle Cards (objection handling per competitor)
4. Objection Handling Guide (common questions and answers)
5. Demo scripts (by scenario)
6. Email templates (Cold / Follow-up / Closing)
7. Proposal templates
8. Reference customer list (customers available for referrals)
```

### 8.2. Sales Training Requirements

- **Rule 51.071**: New AEs must complete the following onboarding before carrying their own book of business

```
Onboarding Program (30 days):
Week 1: Product mastery (use it yourself) + ICP understanding
Week 2: Shadow (observe senior AE demos and calls)
Week 3: Reverse shadow (senior AE observes you)
Week 4: First solo deal (senior AE available for support)

Pass criteria: Sales Manager certifies "ready to show to real customers"
```

---

## Part IX. Business Development (BizDev)

### 9.1. BizDev vs. Sales

- **Rule 51.080**: Clearly distinguish BizDev from Sales

| View | Sales | BizDev |
|:----|:------|:------|
| Goal | Revenue (short-term) | New markets / new channels (mid-long term) |
| Target | Individual customers | Partners / platforms / routes |
| KPI | MRR / Closed Deals | Indirect MRR from pipeline / new market access |

### 9.2. Partnership Evaluation Criteria

- **Rule 51.081**: Evaluate new BizDev partnerships using the following framework

```
Partnership Evaluation Framework:
1. Market Access (ICP reach): Score 1-5
2. Complementarity (supplement, not compete): Score 1-5
3. Credibility (reputation): Score 1-5
4. Commitment (partner's resource willingness): Score 1-5
5. Economic Viability (sustainable revenue share model): Score 1-5

Pursue only partnerships scoring ≥ 15 / 25
```

### 9.3. Technology Partnership Design

- **Rule 51.082**: Principles for designing technology integration partnerships

```
Integration Partnership Strategy:
1. Integrate with tools customers already use (target their existing tech stack)
2. Integration raises switching costs for the customer → benefits retention
3. Maximize discoverability through partner marketplace listings
4. Design co-marketing (joint webinars, case studies, campaigns)
```

---

## Part X. Appendix: Quick Reference & Cross-References

### Quick Reference Index (Keyword → Section)

| Keyword | Section |
|:--------|:--------|
| Challenger Sale, Value Selling | §1 Philosophy |
| Sales Funnel, Stage, Deal Velocity | §2 Sales Process |
| MEDDIC, Champion, Economic Buyer | §3 Qualification |
| Cold Email, Sequence, Outbound | §4 Outbound |
| Demo Design, Discovery, Prohibitions | §5 Demo |
| Proposal, PoC, Mutual Close Plan | §6 Proposal / Negotiation |
| CRM, Pipeline, Win/Loss | §7 CRM |
| Sales Playbook, Battle Card | §8 Enablement |
| BizDev, Partner Evaluation | §9 BizDev |

### Cross-References (Section → Related Rules)

| Section | Related Universal Rules |
|:--------|:-----------------------|
| §3 MEDDIC | `200_go_to_market` (ICP Definition) |
| §5 Demo | `000_product_strategy` (Value Proposition) |
| §6 Price Negotiation | `400_pricing_strategy` (Enterprise Pricing) |
| §7 CRM | `ai/100_data_analytics` (Data Management) |
| §9 Technology Partnership | `operations/700_partnership_ecosystem` |
