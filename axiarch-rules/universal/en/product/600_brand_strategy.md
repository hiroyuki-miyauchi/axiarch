# 14. Brand Strategy

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-04-06

> [!IMPORTANT]
> **Supreme Directive**
> "Brand seeps from the inside of a company outward, not from an ad agency."
> A brand is **"the accumulation of promises"** to users. Every touchpoint with the user forms the brand.
> A brand without consistency destroys trust. Brand building is the source of the most durable competitive advantage.
> **8 Parts · 30 Sections.**

---

## Table of Contents

- [Part I. Brand Philosophy](#part-i-brand-philosophy)
- [Part II. Brand Identity Design](#part-ii-brand-identity-design)
- [Part III. Visual Identity Management](#part-iii-visual-identity-management)
- [Part IV. Voice, Tone & Copywriting](#part-iv-voice-tone--copywriting)
- [Part V. Brand Experience (BX) Design](#part-v-brand-experience-bx-design)
- [Part VI. Brand Protection & Governance](#part-vi-brand-protection--governance)
- [Part VII. Brand Measurement & Management](#part-vii-brand-measurement--management)
- [Part VIII. Appendix: Quick Reference & Cross-References](#part-viii-appendix-quick-reference--cross-references)

---

## Part I. Brand Philosophy

### 1.1. What a Brand Is

- **Rule 14.001**: Trivializing brand as "logo, color, and font" is prohibited. A brand is **"the totality of emotional associations a user holds"**
- **Simon Sinek's Golden Circle**:

```
Why (Why do we exist?) ← The core of brand
  ↓
How (How do we deliver it?)
  ↓
What (What do we provide?) ← Where most companies start

Rule: All brand communication must start from "Why"
```

### 1.2. Brand as a Moat

- **Rule 14.002**: A strong brand generates the following economic value
  - **Lower CAC**: Higher awareness increases inbound, lowering CAC
  - **Price premium**: Justify higher prices for equivalent features (Apple vs. commodity PC)
  - **Recruiting advantage**: Attracts high-quality talent
  - **Partnership magnetism**: Trusted brands attract partners

### 1.3. Brand Promise

- **Rule 14.003**: Define a **Brand Promise** at the core of the brand
  - Brand Promise expresses in one sentence "what users can reliably expect every time"
  - Brand Promise is defined by the CEO / CPO, not the marketing department
  - Examples: "Amazon: The most customer-centric company on Earth" / "Apple: Innovative technology for everyone"

---

## Part II. Brand Identity Design

### 2.1. Brand Pyramid

- **Rule 14.010**: Define brand identity in the following 5-layer structure

```
    ┌─────────────────┐
    │   Brand Essence  │ (Why: Reason for existence)
    ├─────────────────┤
    │ Brand Personality│ (Character / Persona)
    ├─────────────────┤
    │  Brand Values    │ (Values that constrain behavior)
    ├─────────────────┤
    │  Brand Promise   │ (Promise to users)
    ├─────────────────┤
    │  Brand Position  │ (Market positioning)
    └─────────────────┘
```

### 2.2. Brand Personality

- **Rule 14.011**: Define brand personality through up to 5 adjectives framed as "if the brand were a person"
  - Example (Stripe): Polished / Engineer-founded / Straightforward / Meticulous / Innovative
  - Example (Notion): Playful / Minimalist / Inclusive / Thoughtful

### 2.3. Brand Values

- **Rule 14.012**: Brand values also define "what we don't do"

```yaml
brand_values_template:
  values:
    - name: "Radical Simplicity"
      do: "Make complex things appear simple"
      dont: "Add features that complicate the UI"
    - name: "Transparent by Default"
      do: "Communicate errors honestly and humanly"
      dont: "Show meaningless error messages like 'An error occurred'"
```

### 2.4. Mission / Vision / Values Alignment

- **Rule 14.013**: Verify that Mission, Vision, and Values are consistent and mutually reinforcing

| Element | Definition | Time Horizon |
|:--------|:-----------|:------------|
| **Mission** | Why we exist / current purpose | Present progressive |
| **Vision** | The future we're building toward | 5–10 years |
| **Values** | How we act | Immutable |

---

## Part III. Visual Identity Management

### 3.1. Visual System Components

- **Rule 14.020**: Compose visual identity from the following elements

| Element | Managed File | Update Frequency |
|:--------|:-----------|:----------------|
| **Logo** | SVG (color, white, black, mark only) | Brand revision only |
| **Color Palette** | Primary / Secondary / Accent | Annual review |
| **Typography** | Heading / Body / Code font definitions | Annual review |
| **Icon System** | Unified icon library | When features are added |
| **Imagery Style** | Photo / illustration / screenshot tone | Annual review |
| **Motion** | Micro-animation principles | Annual review |

### 3.2. Logo Usage Guidelines (Brand Safety)

- **Rule 14.021**: The following rules are absolute for logo usage

```
Permitted:
✅ Use official SVG files without modification
✅ Maintain clear space ≥ 0.5× logo height on all sides

Prohibited:
❌ Changing aspect ratio / distorting scale
❌ Overlaying shadows, gradients, or textures on the logo
❌ Using unauthorized color variations
❌ Insufficient contrast with background (below WCAG AA)
```

### 3.3. Design Token Hierarchy Management

- **Rule 14.022**: Manage all design elements as Design Tokens and establish a single source of truth between code and Figma

```json
{
  "color": {
    "brand": {
      "primary":   { "value": "#6366F1", "description": "Indigo: Main brand color" },
      "secondary": { "value": "#8B5CF6", "description": "Violet: Accent color" }
    },
    "semantic": {
      "success": { "value": "{color.brand.primary}" },
      "error":   { "value": "#EF4444" }
    }
  }
}
```

---

## Part IV. Voice, Tone & Copywriting

### 4.1. Brand Voice

- **Rule 14.030**: Define Brand Voice as **"a permanent character that never changes"** and distinguish it from Tone (situational adjustment)

```
Brand Voice (Immutable):
- Direct; no wasted words
- Technically accurate but never alienating through jargon
- Human, with a sense of humor
- Confident but never arrogant

Brand Tone (Situational):
- During errors: More empathetic, support-focused
- New feature launch: More excited, energetic
- Terms of service: More precise, formal
```

### 4.2. Copywriting Principles

- **Rule 14.031**: Apply the following 5 principles to all external-facing copy

| Principle | Rule |
|:----------|:----|
| **Clarity First** | Clarity over cleverness. Is it immediately understandable on first read? |
| **Benefits over Features** | Write the benefit the user gets, not the feature itself |
| **Active Voice** | Use active voice over passive voice |
| **No Jargon** | Don't use industry buzz words or internal terminology |
| **Read Aloud Test** | Verify it doesn't sound unnatural when read aloud |

### 4.3. Button Copy Standards

- **Rule 14.032**: CTA button copy must be designed with these rules

```
Good button copy:
✅ Start with a verb: "Get started," "Try free," "Invite your team"
✅ Be specific: "Send feedback" instead of "Submit"
✅ User perspective: Self-referential form like "Start my [X]"

Bad button copy:
❌ "Yes," "OK," "Submit" (unclear what happens)
❌ "Click here" (describes the action, not the value)
❌ ALL CAPS everywhere (feels aggressive)
```

### 4.4. Error Message Design Protocol

- **Rule 14.033**: Error messages are the moment brand voice is most tested. Design them with this structure

```
3 Components of an Error Message:
1. What happened (What): Communicate the state clearly
2. Why it happened (Why): Provide the cause when possible
3. What to do next (How): Show a clear next action

Good example:
"This feature is available on the Pro plan.
 You're currently on the Starter plan.
 [Upgrade to Pro] to start using this feature."

Bad example:
"Error occurred (Error: 403)"
```

---

## Part V. Brand Experience (BX) Design

### 5.1. Brand Experience Touchpoint Map

- **Rule 14.040**: Map all touchpoints between users and the brand and design the brand experience at each one

```
Touchpoint Examples:
Awareness: Ads, PR, social posts, word of mouth
Consideration: LP, demo videos, comparison sites
Experience: Signup, Onboarding, first use
Retention: Email notifications, live chat, in-product experience
Expansion: Referral program, upgrade flow, events
```

### 5.2. Onboarding as Brand Experience

- **Rule 14.041**: Onboarding is the most critical opportunity for brand impression formation
  - Design the first 5 minutes to let users "experience" the brand's "Why"
  - Frame it not as "explaining the product" but as **"the beginning of the user's success story"**

### 5.3. Designing Delight

- **Rule 14.042**: Intentionally design small moments of delight that exceed user expectations
  - Example: Celebration animation on 100th completed task
  - Example: Special design for birthday email
  - Example: 404 page with humor and brand character
  - Exception: Implement delight only after core features are complete. Presentation before a polished experience backfires

### 5.4. Community as a Brand Asset

- **Rule 14.043**: Design communities (Slack, Discord, Forum) as part of the brand experience
  - Community tone must conform to brand voice
  - Official accounts in the community must model the brand voice
  - Community health (safe, welcoming, valuable) is tracked as a KPI

---

## Part VI. Brand Protection & Governance

### 6.1. Brand Governance

- **Rule 14.050**: Establish the following governance structure to ensure brand consistency

| Role | Responsibility |
|:-----|:--------------|
| **Brand Owner** (CPO/CMO) | Final approval authority for Brand Identity changes |
| **Brand Guardian** | Maintain and educate on brand guidelines |
| **Design Review** | Approval process for all new visual materials |

### 6.2. Brand Guideline Maintenance

- **Rule 14.051**: Maintain a Brand Book accessible to all teams
  - Minimum contents: Voice/Tone, Color, Typography, Logo Usage, Imagery
  - Synced with Figma Brand Kit so the "latest version" is always available

### 6.3. Third-Party Brand Usage Policy

- **Rule 14.052**: Publish a public policy governing brand usage by partners and users (fan art, promotional articles, etc.)
  - **Permitted**: Non-commercial logo use ("Powered by ○○," etc.) is welcomed
  - **Prohibited**: Usage that creates confusion with official channels / trademark infringement

---

## Part VII. Brand Measurement & Management

### 7.1. Brand Equity Metrics

- **Rule 14.060**: Measure brand asset value quarterly using the following metrics

| Metric | Measurement |
|:-------|:-----------|
| **Aided Brand Awareness** | Survey: Can recall brand when given category name |
| **Unaided Brand Recall** | Survey: Brand appears top-of-mind for category question |
| **Brand NPS** | "Would you recommend this brand to a friend?" |
| **Share of Voice** | Brand media mentions / total industry mentions |
| **Social Sentiment Score** | Positive mentions / total mentions (including negative) |

### 7.2. Brand Crisis Response Protocol

- **Rule 14.061**: Define these situations as brand crises requiring official response within 24 hours

```
Brand Crisis Definition:
- Spike in negative social mentions (500%+ vs. previous week within 24h)
- Critical coverage in major media
- Data breach or security incident announcement
- Criticism from a prominent influencer

5 Crisis Response Principles:
1. Swift: Official response within 24 hours of fact verification
2. Honest: Fact-based explanation (concealment / minimization prohibited)
3. Empathetic: Acknowledge user impact as the top priority
4. Actionable: Present concrete improvement / response steps
5. Accountable: Continue monitoring the situation after response
```

---

## Part VIII. Appendix: Quick Reference & Cross-References

### Quick Reference Index (Keyword → Section)

| Keyword | Section |
|:--------|:--------|
| Brand Promise, Golden Circle, Moat | §1 Philosophy |
| Brand Pyramid, Mission, Vision, Values | §2 Identity |
| Logo, Color, Token, Design System | §3 Visual |
| Voice, Tone, Copy, Error Messages | §4 Voice & Copy |
| Touchpoint, Onboarding, Delight, Community | §5 Brand Experience |
| Brand Book, Third-party Policy | §6 Brand Protection |
| Brand Awareness, NPS, Crisis | §7 Brand Measurement |

### Cross-References (Section → Related Rules)

| Section | Related Universal Rules |
|:--------|:-----------------------|
| §2 Mission/Vision | `000_core_mindset` (Organizational DNA) |
| §3 Design Token | `000_design_ux` (Design System) |
| §4 Copywriting | `000_design_ux` (UX Writing) |
| §5 Onboarding | `200_go_to_market`, `000_product_strategy` |
| §6 Brand Protection | `security/300_ip_due_diligence` |
| §7 Brand NPS | `operations/300_customer_experience` |
