# 15. Fundraising & Investor Relations

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-05-06

> [!IMPORTANT]
> **Supreme Directive**
> "Fundraising is a means, not an end. We are responsible for converting resources obtained through dilution into value at the highest possible probability."
> Investor relationships are not short-term contracts but **long-term partnerships**. **Trust, once lost, cannot be regained.**
> **15 Parts / ~80+ rules.**

---

## Table of Contents

| # | Part | Key Topics |
|---|---|---|
| 0 | Supreme Directive & Scope Manifesto | Scope, priorities |
| I | Philosophy of Fundraising | Default Alive / Ramen Profitability / 3 Errors |
| II | Stages & Timing | Pre-seed → Series C+ / Runway 12-month rule |
| III | Cap Table & ESOP Design | Vesting / Cliff / Option Pool / Dilution Math |
| IV | SAFE / Convertible Note / Bridge | YC SAFE / KISS / Discount / Cap |
| V | Pitch Design Protocol | 15-slide deck / Narrative / Traction |
| VI | Investor Selection & Outreach | Warm Intro / Funnel / Investor Fit |
| VII | Term Sheet Complete Guide | Liquidation / Anti-Dilution / Pro-Rata Math |
| VIII | Due Diligence Response | Data Room / Proactive Disclosure |
| IX | Investor Relations (IR) | Monthly reports / Board Meeting / Early Warning |
| X | Regulatory Compliance | FEFTA / CFIUS / MNPI / Tax / EDINET |
| XI | IPO Preparation Protocol | JPX / NYSE / NASDAQ / S-1 / Pre-IPO Audit |
| XII | M&A Exit Protocol | Indemnification / Escrow / Earnout |
| XIII | Founder Wellbeing & Crisis Communication | Mental health / Crisis comms |
| XIV | Investor Tech Stack & AI Automation | Carta / Pulley / Visible / AI Reports |
| XV | Anti-Pattern Catalog | Forbidden practices |
| App A | Reverse Index | Keyword reverse index |
| App B | Cross-References | Links to other Universal Rules |

---

## Part 0: Supreme Directive & Scope Manifesto

### 0.1. Scope

✅ **Inclusion Criteria**:
- Fundraising strategy for startups and growth-stage companies
- Cap Table / ESOP / Vesting design
- Structure of SAFE / Convertible Notes / Equity Rounds
- Term sheet negotiation and dilution math
- Investor Relations (IR) protocols
- IPO / M&A and other Exit preparation
- Regulatory compliance (foreign investment / MNPI / Tax)
- Investor Tech Stack (Carta, etc.)

❌ **Exclusion Criteria (refer to respective domain files)**:
- Product strategy / unit economics → `product/000_product_strategy.md`
- Pricing / monetization → `product/300_revenue_monetization.md` / `product/400_pricing_strategy.md`
- Pitch market validation data → `product/100_market_validation.md`
- GTM launch → `product/200_go_to_market.md`
- KPI / Analytics infra → `ai/100_data_analytics.md`
- Legal / IP DD → `security/300_ip_due_diligence.md`
- General org / HR → `operations/200_hr_organization.md`

### 0.2. Priority Hierarchy

**Long-term Investor Partnership > Optimal Round Terms > Short-term Headline Maximization**

Rationale: VCs are **permanent shareholders**. Damaging the relationship in one round affects 5 future rounds and Exit.

---

## Part I: Philosophy of Fundraising

### 1.1. The Three Errors of Fundraising

- **Rule 15.001**: The following are **dangerous anti-patterns**:

  | Anti-Pattern | Problem |
  |:--|:--|
  | **Fundraising as Validation** | Mistaking raise amount for success. VC money is no substitute for PMF |
  | **Raise as Much as Possible** | Over-capitalization expands dilution and erodes discipline. Burn Multiple worsens |
  | **Valuation Maximization** | Excessive valuation makes the next round and Exit harder (Down Round risk) |

### 1.2. Default Alive Principle

- **Rule 15.002**: Aim for **Default Alive** before raising (Paul Graham)
  - Default Alive = current growth and cost trajectory naturally reaches profitability
  - Raising while not Default Alive requires **explicit acknowledgment** of risk
- **Formula**: If `current monthly growth × 12-month compounding − Burn` is positive, you are Default Alive

### 1.3. Ramen Profitability First

- **Rule 15.003**: Reach **Ramen Profitability** (minimum survival without external capital) early
  - Founders' minimum cost-of-living covered
  - Creates a **strong negotiating position**; desperate is always disadvantaged

### 1.4. Burn Multiple Discipline

- **Rule 15.004**: **Burn Multiple = Net Burn / Net New ARR** is the primary efficiency metric (David Sacks)

  | Burn Multiple | Assessment |
  |:--|:--|
  | < 1 | Amazing — every $ of burn produces > $ of ARR |
  | 1 – 1.5 | Great — efficient growth |
  | 1.5 – 2 | Good |
  | 2 – 3 | Suspect |
  | > 3 | Bad — cut burn rate immediately |

### 1.5. Post-ZIRP World (2022+)

- **Rule 15.005**: With ZIRP gone, the "Growth at All Costs" era ended. **Rule of 40** (Growth Rate + Profit Margin ≥ 40%) is the SaaS health-bar.
- **Capital Efficiency**: Teams achieving the same ARR with half the capital are the new winners.

### 1.6. Cross-References
- `product/000_product_strategy.md` Unit Economics (CAC/LTV)
- `product/300_revenue_monetization.md` ARR / NRR

---

## Part II: Stages & Timing

### 2.1. Stage-Specific Characteristics & Benchmarks

- **Rule 15.010**: Stages with achievement standards (2026 SF Bay Area / Tokyo)

  | Stage | Raise Size | Benchmark | Investors | Pre-money Valuation |
  |:--|:--|:--|:--|:--|
  | **Pre-seed** | $300K–$1M | Idea + Team + Prototype | Angels / FFF / Pre-seed VC | $3M–$10M |
  | **Seed** | $1M–$5M | PMF signs + MRR $20K | Seed VC / Angels | $8M–$30M |
  | **Series A** | $5M–$25M | PMF confirmed + ARR $1M–$3M + 10%+ MoM | Series A VC | $30M–$100M |
  | **Series B** | $20M–$80M | Unit Economics confirmed + ARR $5M–$20M | Growth VC / CVC | $100M–$500M |
  | **Series C+** | $50M+ | Scale confirmed + market leadership | PE / Mega-VC | $500M–$5B |
  | **Pre-IPO** | $100M+ | Clear IPO path | Crossover / Mutual Funds | $1B+ |

### 2.2. Timing Laws

- **Rule 15.011**: Iron rules of timing:

```
1. Start working on it 12 months before you need it (closing takes 3–6 months)
2. Begin while you have 12+ months of runway
3. Move while you have strong momentum (growth numbers)
4. Desperate negotiating worsens terms

"Borrow when you have abundance; not when you need it"
```

### 2.3. Equity vs Debt vs Bootstrap

- **Rule 15.012**: Choose financing form by criteria:

  | Mode | Best Fit | Caveats |
  |:--|:--|:--|
  | **Equity** | High-growth requiring lump sum | Dilution / shareholder accountability |
  | **Debt (Loans)** | Stable cash flow | Repayment / collateral |
  | **Revenue-based Financing** | SaaS with stable MRR | Repayment terms warrant scrutiny |
  | **Venture Debt** | Already raised VC equity | Confirm Warrants / Covenants |
  | **Bootstrap** | Niche, high-margin / long-term ownership | Growth speed limited |
  | **Government (METI / JIC / NEDO)** | R&D / Deep Tech | Audit obligations / use restrictions |
  | **Crowdfunding (FUNDINNO etc.)** | Strong individual fanbase | Disclosure / operational cost |

### 2.4. Runway Calculation

- **Rule 15.013**: Runway = `cash on hand / monthly Net Burn`
  - **Net Burn** = monthly expense − monthly revenue
  - **Gross Burn** = monthly expense only
  - Use Net Burn in investor reports — don't fudge

### 2.5. Bridge Round Decision

- **Rule 15.014**: Criteria for Bridge Round (small raise to extend runway):
  - If you can hit the next round's KPIs within 6 months → Bridge OK
  - Otherwise prepare for **Down Round** or major burn cuts
  - Bridges are typically structured as SAFE / Convertible (avoiding valuation debate)

---

## Part III: Cap Table & ESOP Design

### 3.1. Cap Table Basics

- **Rule 15.020**: Maintain accurate Cap Table from **Day 1**. Move from manual Excel to Carta / Pulley early.
- **Cap Table Components**:
  - Founders (co-founder shares + Vesting Schedule)
  - Common Stock
  - Preferred Stock (Series A/B/C, etc.)
  - Option Pool (ESOP / Stock Options)
  - SAFE / Convertible Notes (unconverted)
  - Warrants (Venture Debt etc.)

### 3.2. Founder Vesting & Cliff

- **Rule 15.021**: All founder shares MUST follow **4-year Vesting + 1-year Cliff**
  - **Cliff**: 100% forfeit if leaving before year 1
  - **4-year Vesting**: After year 1, monthly 1/48 vests
  - **Acceleration**:
    - **Single Trigger**: Auto-vest unvested on M&A (founder-friendly)
    - **Double Trigger**: Auto-vest on M&A + termination (balanced; recommended)
- **Re-vesting on Round**: Sometimes demanded by Series A investors (resets existing Vesting)

### 3.3. ESOP (Employee Stock Option Plan) Design

- **Rule 15.022**: Design ESOP at the following sizes:

  | Stage | ESOP Size (% of Pre-money) |
  |:--|:--|
  | Pre-seed | 5–10% |
  | Seed | 10–15% |
  | Series A | 15–20% |
  | Series B | 18–22% |
  | Series C+ | 20–25% |
- **Option Pool Shuffle**: VCs requesting Option Pool expansion in Pre-money = "stealth dilution" of founders. Negotiate **Post-money expansion** instead.

### 3.4. Equity Composition Health Check

- **Rule 15.023**: Healthy ownership at Series A (typical US startup):

  | Party | Ownership (Post-Series A) |
  |:--|:--|
  | Founders (2–3 co-founders) | 50–65% |
  | Series A investors | 20–25% |
  | Seed investors | 10–15% |
  | ESOP (remaining) | 8–12% |

  Founder ownership below 40% creates control risk in Series B/C. Be mindful of Founder-Friendly structuring early.

### 3.5. Dilution Math

- **Rule 15.024**: Basic dilution calculation

```
Pre-money Valuation = $20M
New Investment = $5M
Post-money Valuation = $25M
New Investor Ownership = $5M / $25M = 20%
Existing Shareholder Dilution = 20% (1 - 80% = 20% reduction)
```

- **Pre-money vs Post-money SAFE / Note Impact**:
  - **Pre-money SAFE**: SAFE investors' ownership counted in Pre-money (further dilutes existing shareholders)
  - **Post-money SAFE (YC v2.0+)**: SAFE investors' ownership fixed → transparent calculation; current standard

### 3.6. Cap Table Tools (Mandatory)

- **Rule 15.025**: Manual Excel management is **forbidden after Seed**. Adopt one of:
  - **Carta** — US largest; ESOP / 409A / Secondary
  - **Pulley** — Carta competitor; price advantage
  - **Capdesk** — European
  - **Shareworks (Morgan Stanley)** — for large enterprises

### 3.7. 409A Valuation (US)

- **Rule 15.026**: For ESOP exercise price determination, US companies MUST obtain **409A Valuation** (independent appraisal) annually + after major events (IRS regulation). Carta automates this.

### 3.8. Cross-References
- `security/300_ip_due_diligence.md` Legal management of corporate / shareholder records
- `operations/200_hr_organization.md` HR / hiring / compensation design

---

## Part IV: SAFE / Convertible Note / Bridge

### 4.1. SAFE (Simple Agreement for Future Equity)

- **Rule 15.030**: Adopt **SAFE v2.0+ (Post-money SAFE)** — Y Combinator standard. Pre-money SAFE is legacy.
- **Key SAFE Parameters**:

  | Parameter | Description |
  |:--|:--|
  | **Valuation Cap** | Maximum valuation at which SAFE converts (Cap or Discount applies) |
  | **Discount** | Discount on next round's valuation (typical 20%) |
  | **Most Favored Nation (MFN)** | Clause inheriting better terms from later SAFEs |
  | **Pro-rata Side Letter** | Right to participate in next round (separate agreement) |

### 4.2. SAFE Math Example

```
SAFE: $1M @ $10M Valuation Cap
Next Series A: $5M @ $20M Pre-money / $25M Post-money

SAFE investor's stake:
  Cap-applied: $1M / $10M = 10%
  Discount 20%-applied: $1M / ($25M × 0.8) = 5%
  → SAFE investor takes the better one (10%)
```

### 4.3. Convertible Note Comparison

| Feature | SAFE | Convertible Note |
|:--|:--|:--|
| **Legal Form** | Equity reservation | Debt |
| **Interest** | None | 5–8% standard |
| **Maturity Date** | None | 18–24 months for conversion or repayment |
| **Simplicity** | ◎ | △ (interest, expiry) |
| **US Adoption** | Standard | Legacy |
| **Japan Adoption** | Growing | Standard (incl. J-KISS) |

### 4.4. KISS (Keep It Simple Security) / J-KISS

- **KISS** (500 Startups): Hybrid between SAFE and Convertible
- **J-KISS** (published by Coral Capital): Japan-law-compliant seed financing template
- **Usage**: US entity → SAFE; Japan entity → J-KISS is the modern standard

### 4.5. Bridge Financing

- **Rule 15.031**: Bridge Round (gap funding to next round) options:
  - **SAFE / Convertible Bridge**: Avoid valuation debate; resolved at next round
  - **Equity Bridge**: Additional investment from existing investors (same terms)
  - **Venture Debt Bridge**: From SVB / Hercules etc. (low default risk required)

### 4.6. Cross-References
- `product/300_revenue_monetization.md` Financial metrics like ARR

---

## Part V: Pitch Design Protocol

### 5.1. Standard 15-Slide Pitch Deck

- **Rule 15.040**: Standard pitch deck structure:

```
Required slides (10):
1. Cover (Company name / tagline / logo)
2. Problem (Definition / scale / Why Now)
3. Solution (Product / demo)
4. Market Size (TAM / SAM / SOM)
5. Business Model (Revenue mechanism / pricing)
6. Traction (Results / KPIs / growth chart)
7. Go-to-Market (Acquisition strategy)
8. Competition (Competitive comparison / positioning)
9. Team (Founder / key member backgrounds)
10. Financials (3-year forecast / raise amount / use of funds)

Appendix (5):
11. Unit Economics (CAC / LTV / Magic Number / Burn Multiple)
12. Product Roadmap
13. Customer Testimonials / Case Study
14. Technology / Architecture / Moat
15. Cap Table (current ownership) + Use of Funds
```

### 5.2. Traction Slide Design Principles

- **Rule 15.041**: Traction slide is **most important**

```
Good Traction Presentation:
✅ Emphasize growth rate (MoM 20% = 792% annualized)
✅ Show logos (well-known customers / brands)
✅ Combine quantitative + qualitative (NPS + MRR)
✅ Before/After to show customer success
✅ Cohort analysis (Retention curve)

Avoid:
❌ Absolute values only ("100K users" alone says nothing)
❌ Vanity Metrics (PV / DL only — show engagement)
❌ Cherry-picked windows (only-good-period selection)
❌ Misleading dual-axis charts
```

### 5.3. Narrative Design

- **Rule 15.042**: Design **a coherent narrative** for the pitch

```
Recommended Narrative (April Dunford / Andy Raskin style):
1. Why Now: Tech / market structural change
2. Problem: Issue created by the change
3. Solution: How we solve it
4. Traction: Evidence the market wants it
5. Vision: What world we're building in 5 years
6. Antagonist: Old-solution / competitor limitations (explicit)
```

### 5.4. Pitch Delivery Protocol

- **Rule 15.043**: Pitch meeting operations:
  - 30-min slot: Intro 5 / Presentation 10 / Q&A 15
  - **Demo video preferred**: 30-second video beats static screenshots
  - **Practice Q&A 100x** (Founder Pitch Trainer / Mock Pitch)
  - **In-person preferred**: Top VCs face-to-face; Zoom for round-2

### 5.5. Pitch Memo (Deck Alternative)

- **Rule 15.044**: Some VCs (Sequoia / a16z) request **Pitch Memo** (5–10 page prose).
  - Same heritage as Bezos's "no PowerPoint" philosophy
  - Conveys the rigor of thinking
  - Takes more prep than slides but content depth is greater

### 5.6. Cross-References
- `product/100_market_validation.md` Market Size / TAM calculation
- `product/200_go_to_market.md` GTM strategy

---

## Part VI: Investor Selection & Outreach

### 6.1. Investor List Construction Protocol

- **Rule 15.050**: Run outreach as **funnel management**:

```
Target: investor candidate list (200+)
  ↓ research
Qualified: aligned with stage/theme (50)
  ↓ confirm Warm Intro path
Priority: have intro routes (20)
  ↓ meeting
Meeting: first meetings (10)
  ↓ confirm interest
Active: deeper diligence (5)
  ↓ Term Sheet
Closing: term offers (1–3)
```

### 6.2. The Importance of Warm Intro

- **Rule 15.051**: Cold outreach reply rate is **<1%**. **Always go via Warm Intro**
  - Source priority: **Portfolio Founder > LP > Other VC > Advisor > Industry contact**
  - Cold is last resort

### 6.3. Investor Fit Evaluation

- **Rule 15.052**: Evaluate investors on these axes:

  | Axis | What to Confirm |
  |:--|:--|
  | **Thesis Fit** | Investment theme aligns with our stage / domain |
  | **Portfolio Value-add** | Portfolio contains potential customers / partners |
  | **Founder Reputation** | Reputation among portfolio founders (Reference Check) |
  | **Board Value** | What the investor brings as Board Member |
  | **Co-investment** | Willingness / track record of follow-on |
  | **Reserve Capital** | Follow-on investment headroom |

### 6.4. Investor Reference Check (DD on the investor)

- **Rule 15.053**: Before selecting a VC, **reference-check the investor**
  - Talk to 5 founders they invested in over the past 3 years (both successes and failures)
  - Probe "Tough-Time behavior", "contractual flexibility", "next-round follow-on"

### 6.5. AI-Assisted Investor Matching

- **Rule 15.054**: As of 2026, AI tools improve investor matching efficiency:
  - **Pitchbook**: fund focus / check size
  - **Crunchbase Pro**: stage / region filters
  - **OpenVC** / **VC Sheet** (community-driven): free-form search

### 6.6. Cross-References
- `product/200_go_to_market.md` Network building

---

## Part VII: Term Sheet Complete Guide (Math-Heavy)

### 7.1. Key Term Sheet Conditions

- **Rule 15.060**: Key conditions MUST be reviewed with **legal counsel**:

  | Condition | Founder-Friendly | Warning |
  |:--|:--|:--|
  | **Valuation (Pre/Post-money)** | Realistically high | Excessive triggers next-round risk |
  | **Liquidation Preference** | 1× Non-participating | 2×+ / Participating |
  | **Anti-dilution** | Broad-based Weighted Average | Full Ratchet |
  | **Pro-rata Rights** | Standard (investor follow-on) | OK |
  | **Board Composition** | Founder majority | Investor majority |
  | **Information Rights** | Monthly / quarterly | Excessively detailed |
  | **Founder Vesting Re-set** | None or with Acceleration | Full reset |
  | **Drag-along** | Standard (majority) | Minority-shareholder trigger |
  | **ROFR / ROFO** | Standard | Too broad |
  | **No-Shop / Exclusivity** | 30–45 days | 60+ days |

### 7.2. Liquidation Preference Math

- **Rule 15.061**: Example (Series A investor, $10M @ $30M Pre-money / $40M Post-money):

```
Exit Scenario A: Company sold for $30M
  1× Non-participating:
    Investor option: (a) $10M (Preference) or (b) 25% × $30M = $7.5M
    → Selects $10M
    Founders: $30M − $10M = $20M

  1× Participating:
    Investor: $10M + 25% × ($30M − $10M) = $10M + $5M = $15M
    Founders: $15M (worse)

  2× Non-participating:
    Investor option: (a) $20M or (b) $7.5M
    → Selects $20M
    Founders: $10M (worst)
```

- **Capped Participation**: Participating with a cap (e.g., 3× Cap) — hybrid.

### 7.3. Anti-Dilution Math

- **Rule 15.062**: Down-round Anti-dilution:

```
Scenario: Series A at $1/share, then Series B at $0.5/share (Down Round)
Series A investor's protections:

Full Ratchet (most investor-favorable):
  Series A's converted price reduces to $0.5
  → Series A share count doubles, founders dilute massively

Broad-based Weighted Average (standard / recommended):
  CP_new = CP_old × (A + B) / (A + C)
    A = shares outstanding
    B = new raise / CP_old
    C = new shares issued
  → Mild adjustment

Narrow-based Weighted Average:
  Excludes ESOP / Convertibles from denominator
  → More investor-favorable than Broad
```

### 7.4. Red Flag Term List

- **Rule 15.063**: Conditions to watch (require legal review):

```
Watch-list:
❌ Participating Preferred Stock (double-dip: preference + residual participation)
❌ 2x+ Liquidation Preference
❌ Full Ratchet Anti-dilution
❌ No Drag-along Right with weak founder protection
❌ Excessive investor control (hire/fire consent, key-decision veto)
❌ Aggressive Ratchet provisions
❌ Overly broad ROFR (restricting Secondary)
❌ No-Shop > 60 days
❌ Mandatory Re-vesting of all founders
```

### 7.5. Competing Offers Strategy

- **Rule 15.064**: Multiple simultaneous offers create **the strongest negotiating leverage**:
  - **FOMO Strategy**: Set deadline "decision by month-end as interest is rising"
  - **Competitive Tension**: Pit a specific VC against "best terms if others match"
  - **Ethical Line**: No fake numbers; no fabricated bids

### 7.6. Cross-References
- `security/300_ip_due_diligence.md` Legal review

---

## Part VIII: Due Diligence Response

### 8.1. Data Room Structure

- **Rule 15.070**: Maintain Data Room **at all times** to prepare for DD:

```
Recommended Data Room Structure:
├── Corporate/ (incorporation / shareholder roster / minutes / Cap Table)
├── Financials/ (monthly P&L / BS / CF / budget / 3-year plan)
├── Product/ (Product Roadmap / architecture diagram / Tech Stack)
├── Legal/ (contracts / IP rights / litigation risk / compliance)
├── HR/ (org chart / employment contracts / ESOP / Board composition)
├── Customers/ (customer list / MRR breakdown / Churn analysis / Cohort)
├── Technology/ (code quality / security / SOC 2)
├── Market/ (market research / competitive analysis / TAM/SAM/SOM)
├── References/ (customer / advisor / hiring-candidate references)
└── Press & Branding/ (past media coverage / brand assets)
```

### 8.2. DD Response Principles

- **Rule 15.071**: Three principles of DD disclosure:
  - **Proactive Disclosure**: Disclose problems **proactively**. Damage from concealment exposed later is far greater than disclosing
  - **Consistency**: Provide same info to all investors. No information asymmetry
  - **Completeness**: "Didn't know" is unacceptable. Have full grasp of own state

### 8.3. Data Room Tools

- **Rule 15.072**: Use dedicated tools:
  - **DocSend** — view history / dwell time / screenshot prevention
  - **Datasite** — enterprise DD
  - **Dropbox Capture** — simple
  - **Carta** — Cap Table-integrated Data Room
- **Anti-Pattern**: Sharing via Google Drive URL → leak risk; no audit trail

### 8.4. Common DD Landmines

- **Rule 15.073**: Common founder pitfalls:
  - **Verbal founder agreements**: Stock grants / terms not documented
  - **IP attribution from departed employees**: Employment contract lacks IP-assignment clause
  - **Open-source license violations**: GPL incorporated commercially, etc.
  - **PIPL / GDPR / US export controls**: Violations involving China / EU / restricted countries
  - **Unpaid taxes**: Consumption tax / corporate tax / withholdings

### 8.5. Cross-References
- `security/300_ip_due_diligence.md` IP legal DD
- `security/100_data_governance.md` Personal data DD
- `security/200_oss_compliance.md` OSS license DD

---

## Part IX: Investor Relations (IR)

### 9.1. Standard Monthly Investor Report Format

- **Rule 15.080**: Sending **monthly reports** is mandatory:

```markdown
# [Monthly] Investor Report - YYYY-MM

## TL;DR (3-line summary)
- WIN: ◯◯ achieved / ◯◯ Customer acquired
- MISS: ◯◯ missed / reason and remedy
- ASK: this month's request

## Key Metrics
| Metric | This Month | Last Month | MoM |
| MRR | $◯◯K | $◯◯K | +◯% |
| Customers | ◯ | ◯ | +◯% |
| ARR | $◯◯K | | |
| Churn Rate | ◯% | | |
| CAC Payback | ◯ months | | |
| Cash | $◯◯K | | Runway: ◯ months |
| Burn Multiple | ◯ | | |
| NRR | ◯% | | |

## Highlights (what went well)

## Lowlights (challenges / lessons)

## Help Needed (request to investors)
- Hiring: looking for ◯◯ engineers
- Intro: please introduce ◯◯ industry customers
- Advice: want input on ◯◯ decision

## Hiring (status)

## Looking Ahead (next month focus)
```

### 9.2. Board Meeting Operations Protocol

- **Rule 15.081**: Run Board Meetings with this protocol:

```
Frequency: monthly (pre-Series A) / bimonthly (Series A+)
Board Pack distribution: 72 hours before meeting (48h minimum)
Structure:
  1. Performance review (KPI / financials) — 30%
  2. Major topic discussion — 40%
  3. Decisions needed — 20%
  4. Next Actions and owners — 10%

Forbidden: Surprises in Board Meetings. Communicate critical bad news in advance.
Recommended: Discuss assuming pre-read; do not read slides aloud.
```

### 9.3. Early Warning Protocol

- **Rule 15.082**: Notify all investors within **24 hours** when these critical events occur:

```
Early Warning Required:
- Runway expected to fall below 6 months
- Key Person (founder / CTO etc.) departure
- Major security incident
- Loss of major customer (>10% of MRR)
- Significant legal risk
- Major competitor move (acquisition / large raise)
- Regulatory change impacting business
- Founder mental-health issue (→ Part XIII)
```

### 9.4. Maintaining Investor Relationships

- **Rule 15.083**: Better investor relationships:
  - Quarterly 1-on-1 (large-check investors)
  - Annual Strategy Review
  - Birthday / holiday messages (human relationship)
  - Sharing failures (don't hide; convey lessons)

### 9.5. Annual Letter

- **Rule 15.084**: Year-end Investor Letter (PG / Brian Chesky style):
  - Year in review (wins / misses / lessons)
  - Next-year vision / strategy
  - Gratitude to investors
  - 4–8 pages of well-crafted prose

---

## Part X: Regulatory Compliance (FEFTA / CFIUS / MNPI / Tax / EDINET)

### 10.1. Foreign Investment Restrictions

- **Rule 15.090**: Regulatory checks when accepting foreign investors:

#### 10.1.1. Japan: FEFTA (Foreign Exchange and Foreign Trade Act)

- Investments in **core technology areas** (semiconductors / quantum / AI / bio / cybersecurity etc.) by foreign investors require **prior notification**
- Notification triggered at 1% voting rights (some industries), 10%+ in principle
- **Action**: Especially relevant for Japan-incorporated startups preparing IPO

#### 10.1.2. US: CFIUS (Committee on Foreign Investment)

- Foreign investment (especially from China / Russia / North Korea / Iran) into US-incorporated / US-business companies triggers CFIUS review
- **TID businesses** (Technology / Infrastructure / Data) face strict review
- **Action**: From Series A onward in US, confirm at Term Sheet stage

#### 10.1.3. EU: FDI Screening Regulation

- Foreign-investment screening mechanism by EU member states
- Strategic industries (5G / AI / quantum / bio) face strict review

### 10.2. Insider Trading & MNPI (Material Non-Public Information)

- **Rule 15.091**: Pre-IPO / near-IPO MNPI regulations:
  - **MNPI**: Non-public info materially affecting investment decisions (results / major contracts / acquisition talks)
  - **Insider Trading prohibited**: Trading by MNPI holders is a **felony** (US SEC / Japan FIEA)
  - **Tipping**: Sharing MNPI with friends to trade is also forbidden
- **Action**:
  - In IPO preparation, **Trading Window** (only weeks after Earnings)
  - **10b5-1 Plan**: Pre-set sale schedule (allows insider sales as exception)

### 10.3. Tax Considerations

- **Rule 15.092**: Tax optimization for founders / investors:

#### 10.3.1. US: QSBS (Qualified Small Business Stock)

- IRS Section 1202: After 5-year holding, **up to $10M of capital gains is tax-free**
- Conditions: US C Corp, issued under $50M, Active Business
- **Action**: Founders should acquire common stock on Day 1 (tax advantage)

#### 10.3.2. Japan: Angel Tax / J-KISS

- Tax incentives for individual investors in startups (income deduction on investment)
- Significantly expanded by 2023 reform
- **Action**: Account for tax efficiency in founder comp / option design

#### 10.3.3. International Tax: Transfer Pricing / Tax Havens

- US-Japan parent-subsidiary structures face Transfer Pricing regulation
- BVI / Cayman tax-haven structures **face strengthened regulation post-2026** (OECD Pillar Two)

### 10.4. Regulatory Disclosure

- **Rule 15.093**: Disclosure obligations post-IPO / during preparation:
  - **EDINET** (Japan): Annual / quarterly reports / timely disclosure
  - **SEC EDGAR** (US): S-1 / 10-K / 10-Q / 8-K
  - **DPNDD** (EU): Equivalent obligations
- **Pre-IPO Confidential Filing**: SEC permits Confidential Filing until just before IPO for Emerging Growth Companies (revenue < $1.235B).

### 10.5. ESG Reporting

- **Rule 15.094**: Investor demand for ESG disclosure rises in Series B+ (2026+):
  - **CSRD** (EU Corporate Sustainability Reporting Directive): mandatory for 1,000+ employees
  - **TCFD** (Task Force on Climate-related Financial Disclosures): standard for listed companies
  - **Sustainability KPI**: Carbon footprint / Diversity / Governance scores

### 10.6. Cross-References
- `security/100_data_governance.md` GDPR / PIPL / CCPA
- `security/300_ip_due_diligence.md` Legal in general

---

## Part XI: IPO Preparation Protocol

### 11.1. IPO Preparation Period

- **Rule 15.100**: Typical IPO prep is **18–36 months**:

```
T-36 months: Target ARR $50M+, establish Path to Profitability
T-24 months: Select audit firm (Big 4 recommended), Audit-Ready Financials
T-18 months: Select Lead Bank, retain Legal Counsel
T-12 months: Build SOX Compliance, add independent directors
T-9 months: Begin S-1 draft (incl. Confidential Filing)
T-6 months: Complete Roadshow Pitch Deck, build IR team
T-3 months: Public Filing, begin Roadshow
T-0: Pricing → Listing
```

### 11.2. Listing Venue Selection

- **Rule 15.101**: Major listing venues:

  | Market | Size Guidance | Strengths | Cautions |
  |:--|:--|:--|:--|
  | **NYSE** | ARR $100M+ | Large-IPO / Brand prestige | Strict listing standards |
  | **NASDAQ** | ARR $50M+ | Tech home base | High liquidity |
  | **JPX Growth** | Tens of billions JPY | Japanese investor access | Lower foreign liquidity |
  | **JPX Standard** | Mid-cap | Japanese standard | |
  | **JPX Prime** | Large-cap | Highest status | Strict standards |
  | **HKEX** | Various | Asian access | Political risk |
  | **LSE / Euronext** | Various | European | |

### 11.3. S-1 / Form 1-A Preparation

- **Rule 15.102**: Major S-1 (US IPO prospectus) sections:
  - **Risk Factors**: List all foreseeable risks (conservatively)
  - **Use of Proceeds**: Use of raised capital
  - **MD&A**: Management's Discussion and Analysis
  - **Financials**: Audited 3 years
  - **Cap Table**: Full disclosure

### 11.4. SOX Compliance (US)

- **Rule 15.103**: Sarbanes-Oxley Act 404: **Internal control design and operation** mandate (post-IPO)
  - **Audit-Ready Financials**: audit trails for all transactions
  - **SoD (Segregation of Duties)**
  - **ITGC (IT General Controls)**: access / change / operations management
- **Action**: Build SOX team T-12 months out (CFO + Internal Audit Manager)

### 11.5. Direct Listing & SPAC Considerations

- **Rule 15.104**: Alternatives to traditional IPO:
  - **Direct Listing**: Existing shareholders sell directly on NYSE/NASDAQ (no Underwriter; Spotify / Slack used). No new capital
  - **SPAC merger**: Merge with existing public SPAC (peaked 2021; now ~1/10)
  - **When to use**: High notoriety + no need to raise = Direct Listing; speed = SPAC; standard = IPO

### 11.6. Lock-up & Greenshoe

- **Rule 15.105**:
  - **Lock-up**: 180-day post-IPO insider sale restriction (typical)
  - **Greenshoe Option**: Right for lead underwriter to issue additional 15% (price stabilization)
  - **Cliff Lock-up Expiration**: Sell pressure after 180 days → price drop risk

### 11.7. Cross-References
- `security/300_ip_due_diligence.md` Legal in general

---

## Part XII: M&A Exit Protocol

### 12.1. M&A vs IPO Decision

- **Rule 15.110**: Exit-path criteria:

  | Condition | Recommended Exit |
  |:--|:--|
  | ARR $50M+, high standalone growth | IPO |
  | Multiple strategic acquirers | M&A (strategic synergy) |
  | Founder liquidity priority | M&A (immediate cash) |
  | IPO-cold market | M&A or wait |
  | Founder wants to keep operating | IPO (stay CEO) |
  | Burn pressure | M&A (survival strategy) |

### 12.2. M&A Structures

- **Rule 15.111**: Major M&A structures:

  | Structure | Characteristics |
  |:--|:--|
  | **Stock Purchase** | Acquire all shares; buyer assumes all liabilities |
  | **Asset Purchase** | Acquire specific assets; can split off liabilities |
  | **Forward Triangular Merger** | Subsidiary-mediated merger (US typical) |
  | **Reverse Triangular Merger** | Target survives; tax-efficient |
  | **All-Stock Deal** | Buyer pays in own stock (when buyer's stock attractive) |
  | **All-Cash Deal** | Cash consideration (immediate liquidity) |
  | **Mixed (Cash + Stock)** | Part cash + part stock |

### 12.3. Indemnification

- **Rule 15.112**: Indemnification clauses in sale agreements:
  - **Cap**: maximum indemnification (10–20% of deal value standard)
  - **Basket / Threshold**: minimum loss before indemnification triggers
  - **Survival Period**: indemnification window (12–24 months)
  - **Exclusions**: Fraud / IP / Tax handled with separate Cap or statute

### 12.4. Escrow

- **Rule 15.113**: Escrow a portion of consideration (indemnification source):
  - 10–15% of deal value
  - Released after 12–24 months
  - Reduced by indemnification claims during escrow

### 12.5. Earnout

- **Rule 15.114**: Performance-linked additional consideration:
  - Additional payment if 1–3 year post-sale targets hit
  - **Risk**: Buyer's investment decisions / management interference may make targets unreachable
  - **Mitigation**: Specify Earnout calculation and buyer's good-faith duty in contract

### 12.6. Acqui-hire

- **Rule 15.115**: Acquisition primarily for talent, not product:
  - Retention Bonus + equity for founders / key engineers
  - 4-year Vesting to prevent attrition
  - **Founder Reality**: Acqui-hire is not failure but **a bridge to next career**

### 12.7. Cross-References
- `security/300_ip_due_diligence.md` Legal in general
- `operations/700_partnership_ecosystem.md` Strategic partnerships

---

## Part XIII: Founder Wellbeing & Crisis Communication

### 13.1. Founder Mental Health

- **Rule 15.120**: Founder **mental health** is a business-continuity risk:
  - **Stat**: 72% of startup founders experience mental-health issues (Michael Freeman, UCSF)
  - **Symptoms**: burnout / depression / anxiety / relationship breakdown
- **Action**:
  - Monthly therapy or coaching (build a culture where investors permit it as expense)
  - **Founder Peer Group**: YC Founders' Office / cohort-mate networks
  - Time with spouse / family (correlates more with happiness than results)

### 13.2. Crisis Communication

- **Rule 15.121**: Communication of bad news (Down Round / Layoff / major customer loss):
  - **Speed**: Notify investors / key stakeholders within 24 hours
  - **Honesty**: No excuses or concealment; state facts + remedy
  - **Action Plan**: Include "what we will do next"
  - **Lead by Example**: Founder takes responsibility

### 13.3. Layoff Ethics

- **Rule 15.122**: Protocol for large-scale layoffs:
  - **Severance**: Industry average (US: 2–12 weeks salary + benefits / continued health insurance)
  - **Communication**: Individual notification by manager, not group
  - **Public Statement**: Sincere CEO statement (Brian Chesky / Stripe Patrick letters as exemplars)
  - **Support for departed**: LinkedIn intros, references, job-search support

### 13.4. Founder Departure Response

- **Rule 15.123**: Co-founder departure protocol:
  - **Founder Buyback**: Buy back unvested shares
  - **Earnout Mechanism**: Additional grants for remaining founders
  - **Investor Communication**: Immediate Early Warning (Part IX)
  - **NDA / Non-compete**: Confirm restrictive covenants

### 13.5. Crisis Board Operations

- **Rule 15.124**: Special operations during crisis:
  - **Frequency**: Normal bimonthly → emergency weekly
  - **Pre-read**: 24 hours ahead (vs normal 72)
  - **Decision Pace**: Standard consensus → CEO proposes; Board approves/rejects immediately
  - **Ringfencing**: Separate crisis Board from performance Board

---

## Part XIV: Investor Tech Stack & AI Automation

### 14.1. Cap Table & Equity Management

- **Rule 15.130**:
  - **Carta**: Industry standard. ESOP / 409A / Secondary. $10K-50K/year
  - **Pulley**: Carta competitor; price advantage; simple UI
  - **Capdesk** (UK): European
  - **Shareworks**: Post-IPO / large-enterprise

### 14.2. Investor Reporting

- **Rule 15.131**:
  - **Visible.vc**: Auto-distribute monthly reports to investors
  - **Carta CapTable Reports**: Built-in to Carta
  - **Notion + Mailchimp**: Simple operations
  - **Quaestor**: AI-driven auto-report generation

### 14.3. Investor CRM

- **Rule 15.132**:
  - **Affinity**: VC-industry standard Relationship Intelligence
  - **HubSpot / Salesforce + custom**: in-house
  - **Streak**: Gmail-native; lightweight

### 14.4. Pitch Deck Tools

- **Rule 15.133**:
  - **DocSend**: view history / screenshot prevention
  - **Pitch.com**: collaborative
  - **Beautiful.ai**: AI design assistance
  - **Tome**: AI-driven deck generation

### 14.5. AI-Augmented IR (2026+)

- **Rule 15.134**: AI for IR automation:
  - **AI monthly-report summarization**: monthly metrics → AI auto-summary in 1 page
  - **AI Investor Q&A**: auto-answer similar questions from past reports
  - **Sentiment Analysis**: AI-analyze investor email replies (interest estimation)
  - **CAUTION**: AI output **must be human-approved** before sending. Misinformation risk

### 14.6. Data Room Tools

- **Rule 15.135**:
  - **DocSend**: Pitch + Data Room integrated
  - **Datasite**: Enterprise DD (Big 4 standard)
  - **Carta Data Room**: Cap Table-integrated

### 14.7. AI Governance for IR

- **Rule 15.136**: **Human-in-the-Loop** for AI-generated reports / answers:
  - Final monthly-report check by CEO / CFO
  - Investor reply emails also human-reviewed
  - AI hallucination → misinformation = **trust destruction**

---

## Part XV: Anti-Pattern Catalog

### 15.0. Forbidden Practices Quick Reference

| Category | Anti-Pattern | Reference |
|---|---|---|
| **Philosophy** | Fundraising as Validation | §1.1 |
| **Philosophy** | Over-raise / Burn Multiple > 3 | §1.4 |
| **Timing** | Negotiating from desperation (Runway < 3 months) | §2.2 |
| **Cap Table** | Excel Cap Table after Seed | §3.6 |
| **Cap Table** | Founder shares without Vesting | §3.2 |
| **Cap Table** | Missing Option Pool Shuffle | §3.3 |
| **SAFE** | Pre-money SAFE (when v2.0+ exists) | §4.1 |
| **Pitch** | Vanity Metrics-only Traction | §5.2 |
| **Pitch** | Machine-translated localization | §5.6 |
| **Outreach** | Over-reliance on Cold outreach | §6.2 |
| **Outreach** | Skipping investor reference checks | §6.4 |
| **Term Sheet** | Accepting Participating Preferred | §7.4 |
| **Term Sheet** | Full Ratchet Anti-dilution | §7.4 |
| **Term Sheet** | 60+ day No-Shop | §7.4 |
| **DD** | Concealment (damage on later exposure is enormous) | §8.2 |
| **DD** | Sharing Data Room via Google Drive | §8.3 |
| **IR** | Surprises in Board Meetings | §9.2 |
| **IR** | Late / missing monthly reports | §9.1 |
| **IR** | Bad-news 24h rule violation | §9.3 |
| **Compliance** | Forgotten FEFTA / CFIUS prior notification | §10.1 |
| **Compliance** | Pre-IPO Trading Window violation | §10.2 |
| **Compliance** | EDINET / SEC disclosure delay | §10.4 |
| **IPO** | Insufficient SOX prep at Public Filing | §11.4 |
| **IPO** | Mismanaging Lock-up Expiration | §11.6 |
| **M&A** | Ambiguous Earnout calculation | §12.5 |
| **M&A** | Indemnification Cap too high | §12.3 |
| **Wellbeing** | Ignoring founder burnout | §13.1 |
| **Crisis** | Excuses / blame-shifting in layoffs | §13.3 |
| **Tech** | Sending AI output to investors without human check | §14.7 |

---

## Appendix A: Reverse Index (Keyword → Section)

| Keyword | Section |
|---|---|
| Default Alive / Ramen Profitability | §1 |
| Burn Multiple / Rule of 40 | §1.4, §1.5 |
| Pre-seed / Seed / Series A / Series B / C+ | §2.1 |
| Runway / Bridge Round | §2.4, §2.5 |
| Cap Table / Founder Vesting / Cliff | §3.1, §3.2 |
| ESOP / Option Pool Shuffle | §3.3 |
| 409A Valuation | §3.7 |
| Carta / Pulley | §3.6, §14.1 |
| SAFE (Y Combinator) / Post-money SAFE | §4.1 |
| Convertible Note / J-KISS / KISS | §4.3, §4.4 |
| Discount / Valuation Cap / MFN | §4.1 |
| Pitch Deck 15-slide / Narrative | §5.1, §5.3 |
| Traction Slide / Vanity Metrics | §5.2 |
| Pitch Memo (Sequoia / a16z) | §5.5 |
| Warm Intro / Investor Funnel | §6.1, §6.2 |
| Investor Fit / Reference Check | §6.3, §6.4 |
| Liquidation Preference / Participating | §7.2 |
| Anti-dilution / Full Ratchet / Weighted Average | §7.3 |
| Pro-rata / Drag-along / ROFR | §7.1 |
| Red Flag Term Sheet | §7.4 |
| Competing Offers / FOMO | §7.5 |
| Data Room / Proactive Disclosure | §8.1, §8.2 |
| DocSend / Datasite | §8.3, §14.6 |
| Monthly Investor Report | §9.1 |
| Board Meeting / Board Pack | §9.2 |
| Early Warning Protocol | §9.3 |
| FEFTA / CFIUS / EU FDI | §10.1 |
| Insider Trading / MNPI / 10b5-1 Plan | §10.2 |
| QSBS / Angel Tax | §10.3 |
| EDINET / SEC EDGAR / S-1 | §10.4, §11.3 |
| ESG / CSRD / TCFD | §10.5 |
| IPO prep timeline / Lead Bank selection | §11.1 |
| SOX Compliance | §11.4 |
| Direct Listing / SPAC | §11.5 |
| Lock-up / Greenshoe | §11.6 |
| M&A Structure / Stock vs Asset Purchase | §12.2 |
| Indemnification / Escrow / Earnout | §12.3, §12.4, §12.5 |
| Acqui-hire | §12.6 |
| Founder Mental Health | §13.1 |
| Layoff Communication | §13.3 |
| Visible.vc / Quaestor / Affinity | §14 |
| AI-Augmented IR / Human-in-the-Loop | §14.5, §14.7 |
| Anti-Pattern Catalog | §15.0 |

---

## Appendix B: Cross-References (Section → Related Universal Rules)

| Section | Related Universal Rules |
|---|---|
| §I Philosophy | `core/000_core_mindset.md` §1.8 Cost as First-Class Citizen |
| §II Stages | `product/100_market_validation.md` PMF / Unit Economics |
| §III Cap Table | `operations/200_hr_organization.md` HR / comp / `security/300_ip_due_diligence.md` Legal |
| §IV SAFE | `product/300_revenue_monetization.md` Financial metrics |
| §V Pitch | `product/100_market_validation.md` Market Size / `product/200_go_to_market.md` GTM |
| §VI Investor Selection | `operations/700_partnership_ecosystem.md` Network |
| §VII Term Sheet | `security/300_ip_due_diligence.md` Legal / `core/000_core_mindset.md` §1.31 Pre-Mortem |
| §VIII DD | `security/100_data_governance.md` / `security/200_oss_compliance.md` / `security/300_ip_due_diligence.md` |
| §IX IR | `core/000_core_mindset.md` §1.6 Observability-First / `ai/100_data_analytics.md` KPI |
| §X Compliance | `security/100_data_governance.md` / `security/000_security_privacy.md` |
| §XI IPO | `security/300_ip_due_diligence.md` / `operations/400_site_reliability.md` |
| §XII M&A | `security/300_ip_due_diligence.md` / `operations/700_partnership_ecosystem.md` |
| §XIII Wellbeing | `core/000_core_mindset.md` §1.16 Developer Wellbeing & Sustainable Velocity |
| §XIV Tech Stack | `ai/000_ai_engineering.md` / `core/000_core_mindset.md` §1.11 AI-Augmented Engineering |

---

**Last Updated**: 2026-05-06 (v1.5.0-pending)
**Authority**: Universal Constitution (axiarch core)
**Classification**: Product — Fundraising & Investor Relations
