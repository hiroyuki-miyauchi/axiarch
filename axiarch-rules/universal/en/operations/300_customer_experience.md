# 51. User Support & Customer Success

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-03-24

> [!IMPORTANT]
> **Supreme Directive**
> "**The user's success IS the product's success.**" — Support is not a "cost center" but a "value driver."
> Every support interaction exists to **minimize the user's Time-to-Value** and **minimize their Effort**.
> Target **AI Autonomous Resolution Rate ≥ 80%** (2026 goal), freeing human agents to focus on high-value interactions.
> This rule follows the priority hierarchy of `000_core_mindset.md` (Security > UX > Revenue > DX).
> **33 Parts, 40 Sections.**

---

## Table of Contents

- Part I: Support Philosophy & Core Principles
- Part II: AI Agent Support Strategy
- Part III: Omnichannel Support Design
- Part IV: Ticket Management & SLA
- Part V: Escalation Design
- Part VI: Self-Service & Knowledge Base
- Part VII: Customer Success Strategy
- Part VIII: Customer Health Score
- Part IX: Onboarding Design
- Part X: Churn Prevention & Retention
- Part XI: VoC & Feedback Loop
- Part XII: NPS/CSAT/CES Measurement Standards
- Part XIII: Interaction Design (Forms)
- Part XIV: Notification & Channel Design
- Part XV: Email Template & Quality Standards
- Part XVI: Email Sending Governance
- Part XVII: Community & Forum Strategy
- Part XVIII: Trust & Safety
- Part XIX: Support Accessibility
- Part XX: Support Operations & Team
- Part XXI: Support QA & Quality Management
- Part XXII: Support FinOps
- Part XXIII: Support Analytics & Observability
- Part XXIV: Compliance & Regulatory
- Part XXV: Voice AI & Conversational Support
- Part XXVI: Hyper-Personalization Strategy
- Part XXVII: Digital Customer Success (Digital CS)
- Part XXVIII: CS Revenue Accountability
- Part XXIX: Proactive Support Design
- Part XXX: Customer Journey Orchestration
- Part XXXI: Support Knowledge Management (KCS)
- Part XXXII: Multilingual & Global Support Design
- Part XXXIII: Customer Effort Score Optimization
- Part XXXIV: Support AI Safety & Ethics
- Part XXXV: Outcome-Based Support Pricing
- Part XXXVI: Workforce Management (WFM)
- Part XXXVII: Support Tech Stack Design
- Part XXXVIII: Customer Advocacy & Loyalty
- Part XXXIX: Future Outlook & Emerging Technologies
- Part XL: Maturity Model & Quick Reference Index

---

## Part I: Support Philosophy & Core Principles

### 1.1. The Support-as-Value-Driver Principle
-   **Law**: Position support as a "value driver," not a "cost center."
-   **Metrics Mandate**: Support organization KPIs MUST include the following **3 axes**.

    | Axis | Example Metrics | Purpose |
    |:-----|:---------------|:--------|
    | **Efficiency** | First Response Time, Resolution Time, Deflection Rate, AI Resolution Rate | Operations optimization |
    | **Quality** | CSAT, CES, NPS, QA Score, FCR | User experience assurance |
    | **Business Impact** | Retention Rate, Expansion Revenue, Support-Influenced ARR, Churn Saved Revenue | Revenue contribution visibility |

### 1.2. The Empathy & Efficiency Doctrine
-   **Zappos Style Empowerment**:
    -   Grant support agents authority to resolve issues without manager approval (e.g., refunds up to a set amount, coupon issuance). **Zero runaround** is mandatory.
    -   WOW Experience: Encourage delivery of "WOW" experiences outside the manual (e.g., handwritten messages, anniversary surprises).
-   **First Contact Resolution (FCR) Target**: Aim for FCR rate **≥ 70%**. If FCR is low, suspect insufficient knowledge base, agent training, or empowerment.

### 1.3. The Support-Driven Development Protocol
-   **Law**: Systematically leverage support inquiries as signals for product improvement.
-   **3-Strike Rule**: When the same inquiry occurs **3 times**, automatically create a GitHub Issue and elevate the priority in the development backlog.
-   **Bug Report Fast Track**: Prioritize verification of user-reported bugs, and upon fix completion, always notify the **individual reporter** with a completion notice and thanks.
-   **Product-Support Sync**: Conduct weekly regular meetings between the support and product teams, sharing Top 5 inquiry categories and trend data.

### 1.4. The Effortless Experience Principle
-   **Law**: Minimizing user "Effort" is the greatest driver of loyalty improvement (Gartner CEB research).
-   **Zero Repeat Contact**: Structurally eliminate situations where a user contacts support more than once for the same issue.
-   **Channel Stickiness**: Complete resolution in the channel the user initially chose. Do not force channel switching.
-   **Anticipatory Service**: Detect and proactively resolve issues before the user contacts support (see Part XXIX Proactive Support).
-   **Effort Budget**: Target limiting user actions required for one problem resolution to **5 actions or fewer**.

### 1.5. The Support Excellence Culture
-   **Law**: Support quality is rooted in organizational culture. Institutionalize a company-wide "Customer First" culture.
-   **Executive Support Shadow**: Executives experience support ticket handling at least once per quarter via "Support Shadow Day."
-   **All-Hands Support**: Non-support staff (engineers, PMs, etc.) regularly participate in support handling (recommended: 2 hours/month).
-   **Customer Story Sharing**: Allocate time in all-hands meetings to share support cases (both successes and failures).

---

## Part II: AI Agent Support Strategy

### 2.1. The AI Triage Protocol
-   **Law**: Classify all inquiries instantly via LLM (technical issue/billing/feature request/bug report) and auto-determine severity (P0-P3).
-   **PII Scrubbing Mandate**: Before forwarding inquiries to AI, mask personal information (names, phone numbers, email addresses) using regex etc., in compliance with `400_ai_engineering.md` PII Scrubbing rules.
-   **Confidence Threshold**: If AI classification confidence is **below 80%**, automatically route to a human agent.
-   **Intent Detection**: Standardize semantic analysis-based intent detection rather than simple keyword matching.
-   **Multi-Intent Handling**: When a single message contains multiple intents (e.g., "billing error and feature request"), separate and process each intent in parallel.

### 2.2. The Agentic AI Support Standard
-   **Law**: Post-2025 AI support must standardize on **Agentic AI architecture capable of autonomously executing tasks and resolving problems**, not simple FAQ bots.
-   **Capability Tiers**:

    | Tier | Capability | Example | Resolution Target |
    |:-----|:----------|:--------|:-----------------|
    | **L1: Information** | Answer questions, provide document links | FAQ responses, knowledge base search | 95% |
    | **L2: Guided Action** | Guide step-by-step operations | Account setting change guidance | 90% |
    | **L3: Delegated Execution** | Execute operations with user permission | Plan changes, refund processing | 85% |
    | **L4: Proactive Intervention** | Initiate contact upon risk detection | Pre-notification on anomaly detection | 80% |
    | **L5: Autonomous Resolution** | Autonomously execute complex workflows | Multi-step problem resolution, API integration | 70% |

-   **Human-in-the-Loop Mandate**: For L3 (Delegated Execution) and above, always obtain **explicit user consent** before execution. AI-initiated billing operations or data changes without consent are strictly prohibited.
-   **Escalation Trigger**: If AI cannot resolve after 3+ exchanges, automatically escalate to a human agent.
-   **Multi-Agent Orchestration**: Recommend architecture where multiple specialized AI agents (billing agent, technical agent, account agent) collaborate to resolve complex inquiries.

### 2.3. The AI Agent Tool Use & Integration Standard
-   **Law**: Define design standards for AI agents to safely invoke external tools/APIs in Agentic AI support.
-   **Tool Use Design**:
    -   **Allow List**: Explicitly define APIs/tools callable by AI via whitelist
    -   **Scope Limitation**: Restrict execution scope of each tool to minimum privilege (e.g., refund API capped at $100)
    -   **Dry Run Mode**: Present preview to user before executing destructive operations (deletion, billing changes)
    -   **Audit Trail**: Record all Tool Use executions in audit logs with timestamps
-   **MCP/A2A Integration**: Standardize secure information sharing and task delegation between AI agents using Model Context Protocol (MCP) and Agent-to-Agent (A2A) protocols.

### 2.4. The AI Copilot for Agent Protocol
-   **Law**: Provide AI Copilot to human support agents, improving response quality and speed.
-   **Required Capabilities**:
    -   **Real-time Answer Suggestions**: Draft generation from past knowledge base and ticket history
    -   **Sentiment Analysis**: Real-time detection of user emotional state (anger/frustration/neutral/satisfaction)
    -   **Context Summarization**: Automatic summarization of long ticket histories
    -   **Next-Best-Action Suggestions**: Optimal response strategy recommendations
    -   **Similar Ticket Search**: Automatic detection of similar cases from past resolved tickets
    -   **Compliance Check**: Automatic detection of policy violations and tone deviations in replies
    -   **Real-time Translation**: Real-time translation support when agent and user speak different languages
-   **Override Principle**: AI Copilot suggestions are "suggestions"; the final decision always rests with the human agent.
-   **Copilot Adoption KPI**: Track Copilot suggestion adoption rate, identify and improve low-adoption categories (target: adoption rate ≥ 60%).

### 2.5. The Conversational AI Design Standard
-   **Law**: AI chatbots and virtual assistants must meet the following quality standards.
-   **Persona Consistency**: Set a persona consistent with brand voice and tone, maintained across all interactions.
-   **Graceful Handoff**: When transitioning from AI to human agent, seamlessly transfer the entire conversation context (including summary). Users must never need to repeat explanations.
-   **Multilingual Support**: Support target market languages with automatic language detection and switching.
-   **Anti-Hallucination**: Prohibit "fabricating" answers from information not in the knowledge base. When uncertain, escalate to human with "Let me look into this."
-   **Grounding & Citation**: AI answers must always be grounded in specific knowledge base articles, including source reference links in responses.
-   **Conversation Memory**: Reference past conversation history with the same user, maintaining context.
-   **Prompt Injection Defense**: Implement guardrails to detect and defend against prompt injection attacks from user input (see `600_security_privacy.md`).
-   **Cross-Reference**: `400_ai_engineering.md` — Guardrail design, RAG design, Hallucination prevention

### 2.6. The AI Quality Assurance Standard
-   **Law**: Continuously monitor and improve AI support quality.
-   **AI QA Metrics**:

    | Metric | Target | Measurement Frequency |
    |:-------|:-------|:---------------------|
    | **Autonomous Resolution Rate** | ≥ 80% | Real-time |
    | **AI CSAT** | ≥ 4.0 / 5.0 | Daily |
    | **Hallucination Rate** | ≤ 1% | Weekly |
    | **Grounding Accuracy** | ≥ 98% | Weekly |
    | **Escalation Rate** | ≤ 20% | Daily |
    | **Average Handle Time (AI)** | ≤ 2 min | Real-time |
    | **Intent Recognition Accuracy** | ≥ 95% | Weekly |
    | **Tool Use Success Rate** | ≥ 95% | Daily |

-   **Feedback Loop**: When AI gives incorrect answers, human agents flag them, driving a knowledge base update → AI model improvement loop.
-   **AI Agent Observability**: Instrument AI agent reasoning processes, Tool Use invocations, and latency with OpenTelemetry, building anomaly detection alerts.

---

## Part III: Omnichannel Support Design

### 3.1. The Omnichannel Integration Mandate
-   **Law**: Integrate email, chat, SNS, phone, and in-app support into a **unified management platform** (Zendesk, Intercom, Freshdesk, etc.), fully sharing context across channels.
-   **Zero Context Loss**: When users switch channels (e.g., chat → email), past conversation history and context must be fully carried over. Requiring users to repeat explanations is prohibited.
-   **Unified Customer View**: Provide agents with a "Unified Customer View" integrating interaction history across all channels.
-   **Channel Performance Parity**: Maintain equivalent quality levels across all channels (CSAT within ± 0.3 variance). Monitor channel quality gaps monthly.

### 3.2. The Channel Strategy Matrix
-   **Law**: Define optimal channels by inquiry type and guide users accordingly.

    | Inquiry Type | Recommended Channel | Reason |
    |:------------|:-------------------|:-------|
    | **Urgent technical outage** | Live chat / Phone / Video | Immediate response needed |
    | **General questions** | AI chatbot / FAQ | Instant self-service resolution |
    | **Complex technical issues** | Email / Ticket / Screen share | Detailed investigation needed |
    | **Feature requests/feedback** | In-app feedback | Direct connection to product team |
    | **Account/billing** | Live chat / Email | Authentication required |
    | **SNS mentions/complaints** | SNS direct reply | Public rapid response |
    | **B2B Enterprise** | Dedicated CSM / Slack Connect | Relationship-focused |

### 3.3. The Real-Time Channel Standard
-   **Live Chat SLA**: Target first response within **30 seconds** for live chat.
-   **Typing Indicator**: Display real-time typing indicator when agent is composing (prevents user abandonment).
-   **Proactive Chat**: Proactively present chat to users who dwell on specific pages (pricing, cancellation, etc.) for a set time (recommended: 60 seconds).
-   **Chat Transcript**: Offer option to email the complete transcript after chat ends.
-   **Video Support**: Provide video call and screen share real-time support options for complex technical issues.
-   **Messaging Platforms**: Support integration with messaging platforms such as WhatsApp Business API, LINE Official Account, etc.
-   **Async-First Design**: Default to asynchronous chat (conversation continues after user leaves), respecting user time constraints.

---

## Part IV: Ticket Management & SLA

### 4.1. The Tiered SLA Standard
-   **Law**: Define tiered SLAs based on inquiry urgency/importance and strictly adhere to them.

    | Priority | Definition | First Response | Resolution Target |
    |:---------|:----------|:--------------|:-----------------|
    | **P0 (Critical)** | Full service outage, data breach | **Within 15 min** | **Within 4 hours** |
    | **P1 (High)** | Major feature outage, billing error | **Within 1 hour** | **Within 8 hours** |
    | **P2 (Medium)** | Partial functionality issues | **Within 4 hours** | **Within 24 hours** |
    | **P3 (Low)** | General questions, feature requests | **Within 24 hours** | **Within 72 hours** |

-   **Business Hours Definition**: Explicitly document SLA business hours definition (e.g., Weekdays 9:00-18:00 JST. P0 is 24/7).
-   **SLA Breach Alert**: Automatically notify manager when SLA breach approaches (at 20% remaining).
-   **SLA by Segment**: Provide dedicated SLA (Premium SLA) for Enterprise segment with stricter standards than standard SLA.
-   **SLA Clock Pause**: Pause SLA timer during user-pending status for accurate response time measurement.

### 4.2. The Ticket Lifecycle Standard
-   **Law**: Standardize ticket state transitions and make all tickets trackable.
-   **Standard States**: `New → Open → Pending (User wait) → In Progress → Resolved → Closed`
-   **Auto-Close Rule**: Auto-transition to "Closed" after **7 days** without user reply in "Resolved" state. Send confirmation notification before closing.
-   **Reopen Policy**: Allow ticket reopen within **30 days** of closing, continuing with same context.
-   **Merge Protocol**: Auto-detect duplicate tickets from same user and suggest merge.
-   **Stale Ticket Alert**: Fire automatic alert on active tickets with no updates for 5+ days to prevent abandonment.

### 4.3. The Ticket Tagging & Classification Standard
-   **Law**: Apply classification tags to all tickets for accumulation as analyzable data.
-   **Required Tags**:
    -   **Category**: `bug` / `feature_request` / `billing` / `account` / `how_to` / `integration`
    -   **Product Area**: Classification by feature/module
    -   **Root Cause**: `product_bug` / `documentation_gap` / `user_error` / `third_party`
    -   **Resolution Method**: `self_resolved` / `agent_resolved` / `ai_resolved` / `engineering_fix` / `escalated`
    -   **Sentiment**: `positive` / `neutral` / `negative` / `escalated`
-   **AI Auto-Tagging**: Implement AI-powered automatic tagging, reducing manual tagging burden by 80%+. Audit tagging accuracy weekly (target: accuracy ≥ 90%).

---

## Part V: Escalation Design

### 5.1. The Escalation Matrix Protocol
-   **Law**: Clearly define escalation criteria, paths, and responsibilities, enabling all agents to escalate without delay.
-   **Escalation Types**:

    | Type | Trigger | Escalation Target |
    |:-----|:--------|:-----------------|
    | **Hierarchical** | SLA exceeded, user explicit request | Team Lead → Manager → Director |
    | **Functional** | Specialized knowledge required | Technical Support → Engineering → SRE |
    | **Priority** | P0/P1 incident | Incident Commander (see `503_incident_response.md`) |
    | **Emotional** | Strong user frustration/anger | De-escalation specialist |
    | **Security** | Suspected security incident | Security team immediately (see `600_security_privacy.md`) |

### 5.2. The Escalation Handoff Standard
-   **Law**: Include the following information in escalation handoff notes.
-   **Required Information**:
    1.  **Problem Summary**: Concise 1-2 sentence problem description
    2.  **Reproduction Steps**: Steps to reproduce for technical issues
    3.  **Actions Taken**: List of attempted solutions so far
    4.  **User Sentiment**: Sentiment assessment (anger/frustration/neutral)
    5.  **Business Impact**: Number of affected users and revenue impact
    6.  **Timeline**: SLA remaining time and elapsed time
-   **Anti-Pattern**: Escalation without handoff information ("please look at this" only) is prohibited.
-   **AI-Assisted Handoff**: AI automatically generates escalation summaries, eliminating handoff quality variance.

### 5.3. The Engineering Escalation Protocol
-   **Law**: Clarify escalation criteria from support to engineering.
-   **Trigger Criteria**:
    -   Bug reproduction confirmed and unresolvable by support
    -   Signs of infrastructure failure
    -   Suspected security incident (immediate escalation mandatory)
-   **Engineering SLA**: Complete initial triage (receipt confirmation + priority determination) within **4 hours** after engineering escalation.
-   **Feedback Loop**: Feed back root causes of engineering-resolved issues to the support team and reflect in the knowledge base.
-   **Cross-Reference**: `502_site_reliability.md` — Incident management protocol

---

## Part VI: Self-Service & Knowledge Base

### 6.1. The Self-Service First Principle
-   **Law**: Prioritize building an environment where users can resolve issues via self-service **before** contacting human support.
-   **Deflection Rate Target**: Target ticket deflection rate via self-service **≥ 40%**.
-   **Self-Service Channels**: AI chatbot, Knowledge base / FAQ, Community forums, Interactive tutorials / walkthroughs, Status page, Troubleshooting wizards, Interactive diagnostic tools (Decision Tree).

### 6.2. The Knowledge Base Architecture Standard
-   **Law**: Build the knowledge base according to the following design principles.
-   **Structure**: Category-based logical classification by feature area, full-text + AI semantic search support, multilingual coverage for all target markets.
-   **Article Quality Standard**: Avoid jargon, use plain language; **always** include screenshots/GIF videos (text-only articles prohibited); use **step-by-step format** (numbered lists); include "Was this article helpful?" feedback widget on each article; maintain reading level at middle school level or below (Flesch-Kincaid equivalent).

### 6.3. The Dynamic Knowledge Update Protocol
-   **Law**: Continuously update the knowledge base as a "living document."
-   **3-Strike Auto-Create Rule**: When the same question is asked 3 times, create a knowledge base article within **48 hours** or improve the product UI to prevent the question from arising.
-   **Freshness Check**: Review all articles every **90 days**, updating or archiving outdated information.
-   **Usage Analytics**: Track each article's views, feedback scores, and search hit rates, prioritizing improvement of low-rated articles.
-   **Version History**: Maintain article change history enabling rollback.
-   **Content Gap Analysis**: AI analyzes search queries and auto-identifies content gaps from terms that returned zero results.

### 6.4. The In-App Contextual Help Standard
-   **Law**: Provide **context-aware help within the app**, not just links to the knowledge base.
-   **Tooltip / Guided Tour**: Implement tooltips and guided tours for complex features.
-   **Contextual Search**: Automatically suggest help articles related to the user's current screen.
-   **Interactive Troubleshooter**: Implement Decision Tree-type interactive troubleshooters that progressively narrow down problem symptoms.
-   **Smart Suggestions**: Directly link relevant help articles within error messages when errors occur.
-   **Cross-Reference**: `200_design_ux.md` — Omotenashi UX, Error message UX standards

---

## Part VII: Customer Success Strategy

### 7.1. The Customer Success Operating Model
-   **Law**: Operate customer success as "proactive value realization support," not "reactive support."
-   **CS vs. Support Responsibility Separation**:

    | Function | Support (Reactive) | Customer Success (Proactive) |
    |:---------|:-------------------|:---------------------------|
    | **Trigger** | User inquiry | Data signals, lifecycle events |
    | **Goal** | Problem resolution, ticket closure | Value realization, retention, expansion |
    | **KPI** | Response time, resolution time, CSAT | NRR, health score, Time-to-Value |

### 7.2. The Customer Segmentation Standard
-   **Law**: Segment all customers by ARR (Annual Recurring Revenue) or plan type and define touch models.

    | Segment | Criteria (Example) | Touch Model | CSM Allocation |
    |:--------|:------------------|:-----------|:--------------|
    | **Enterprise** | ARR ≥ $100K | High-touch (dedicated CSM) | 1:10-20 |
    | **Mid-Market** | ARR $10K-$100K | Mid-touch (shared CSM + automation) | 1:50-100 |
    | **SMB / Self-Serve** | ARR < $10K | Tech-touch (fully automated) | None (Digital CS) |

-   **Tech-Touch Automation**: Implement automated onboarding emails, in-app guides, and health alerts for tech-touch segments.
-   **Dynamic Segmentation**: Dynamically reclassify segments based on changes in customer lifecycle stage and usage patterns.

### 7.3. The Expansion & Upsell Protocol
-   **Law**: CS team identifies expansion opportunities at appropriate timing and contributes to revenue.
-   **Trigger Events**: Usage at **80%** of plan limit; repeated access to advanced features (paid plan trial usage); positive feedback from high Health Score (Promoter) users; **Product Qualified Signals (PQS)**: specific feature usage patterns as strong expansion signals.
-   **Anti-Pattern**: Selling to low Health Score (Detractor) users is prohibited. Address their issues first.
-   **Consumption-Based Alerts**: For Usage-Based Pricing (UBP) models, automate predictive upgrade recommendations based on usage trends.

---

## Part VIII: Customer Health Score

### 8.1. The Health Score Framework
-   **Law**: Calculate a dynamic Health Score for all customers, leveraging it for risk management and proactive intervention.
-   **Score Components (Recommended Weights)**:

    | Category | Example Metrics | Weight |
    |:---------|:---------------|:-------|
    | **Product Usage** | DAU/MAU ratio, key feature usage rate, session time, Feature Adoption | 30% |
    | **Engagement** | Login frequency, NPS/CSAT scores, community participation, training completion rate | 25% |
    | **Support** | Ticket count, unresolved tickets, escalation frequency, CES score | 20% |
    | **Contract/Financial** | Payment delays, renewal timing, usage trends, billing error rate | 15% |
    | **Relationship** | Regular CSM meeting attendance, exec sponsor presence, champion count | 10% |

-   **Score Range**: Express as 0-100 score and trigger actions at the following thresholds.

    | Score | Status | Action |
    |:------|:-------|:-------|
    | **80-100** | 🟢 Healthy | Explore expansion opportunities, request advocacy |
    | **60-79** | 🟡 Neutral | Regular check-ins, strengthen engagement |
    | **40-59** | 🟠 At Risk | Develop risk mitigation plan, immediate intervention |
    | **0-39** | 🔴 Critical | Immediate intervention (CSM + Manager + Exec Sponsor) |

### 8.2. The Predictive Health Analytics Standard
-   **Law**: Health Score must incorporate **predictive analytics** via ML models, not just static snapshots.
-   **Trend Detection**: Visualize score trends (rising/declining/flat) and fire alerts when a **declining trend persists for 2+ weeks**.
-   **Churn Prediction**: Build a model that predicts churn probability by learning from historical churn data.
-   **Feature Engineering (Recommended Features)**: Login days in past 30 days vs. previous month; weekly change rate in key feature usage; moving average of support ticket sentiment scores; days until contract renewal; payment failure count (past 90 days); champion user activity change rate.
-   **Cohort Analysis**: Conduct cohort analysis by segment, industry, and onboarding date to identify patterns.
-   **Propensity Scoring**: Calculate Propensity Score predicting Expansion/Upsell likelihood and use for CSQL prioritization.
-   **Cross-Reference**: `401_data_analytics.md` — Analytics dashboard quality standards

---

## Part IX: Onboarding Design

### 9.1. The Onboarding Success Framework
-   **Law**: Design an onboarding experience that **minimizes the user's Time-to-Value**.
-   **First Value Milestone**: Define the "Aha! Moment" where the user first experiences value, targeting milestone achievement within **7 days**.
-   **Progressive Disclosure**: Adopt design that introduces features progressively, not all at once.
-   **Time-to-Value Benchmark**: Measure TTV by segment and continuously reduce it.
-   **Onboarding Completion Correlation**: Analyze correlation between onboarding completion rate and 12-month retention rate, quantifying onboarding improvement impact on retention.

### 9.2. The Onboarding Checklist Standard
-   **Law**: Provide interactive onboarding checklists to new users.
-   **Requirements**: Progress bar display (sense of achievement); estimated time display for each step; skippable design (forcing is prohibited); celebration on completion (confetti micro-interactions).
-   **Completion Tracking**: Track checklist completion rates by segment, identifying and improving steps with high abandonment.

### 9.3. The Segmented Onboarding Standard
-   **Law**: Branch onboarding flows based on user persona and intended use.
-   **Role-Based**: Provide different onboarding paths for Admin/General User/Guest.
-   **Use-Case Based**: Ask intended use at signup, providing personalized initial setup.
-   **Cross-Reference**: `102_growth_marketing.md` — PLG (Product-Led Growth), Onboarding

### 9.4. The Customer Education & Academy Standard
-   **Law**: Build a Customer Education system supporting continuous learning after onboarding.
-   **Education Programs**:

    | Program | Target | Format | Purpose |
    |:--------|:-------|:-------|:--------|
    | **Introductory Course** | New users | Self-paced video | Master basic operations |
    | **Advanced Course** | Active users | Webinar / Workshop | Advanced feature utilization |
    | **Certification Program** | Power users / Partners | Exam + Badge | Demonstrate expertise |
    | **Best Practices** | All users | Blog / Case study | Share success patterns |

-   **LMS Integration**: Leverage Learning Management System (LMS) to track learning progress and completion rates.
-   **Training-Revenue Correlation**: Analyze correlation between education enrollment rates and expansion rates, visualizing ROI.

---

## Part X: Churn Prevention & Retention

### 10.1. The Churn Signal Detection Protocol
-   **Law**: Define the following risk signals and implement automated detection with staged interventions.

    | Signal | Threshold | Risk Level |
    |:-------|:---------|:----------:|
    | **Login frequency decline** | No login in past 14 days | Medium |
    | **Key feature non-usage** | Zero key feature usage in past 7 days | Medium |
    | **Support inquiry increase** | 3+ tickets per month | High |
    | **Payment failure** | 2 consecutive payment failures | Critical |
    | **Cancellation page visit** | Access to cancellation page | Critical |
    | **NPS Detractor response** | NPS 0-6 response | High |
    | **Usage volume drop** | 50%+ decrease vs. previous month | High |
    | **Champion user departure** | Key user account deactivation | Critical |
    | **Competitor tool search** | Searching competitor names in help | Medium |

-   **Automated Action**: **Medium**: Send personalized re-engagement email; **High**: Notify CS + auto-present limited offer; **Critical**: Trigger immediate retention measures.

### 10.2. The Staged Re-engagement Protocol
-   **Law**: Attempt staged re-engagement for users inactive 30+ days.
-   **Steps**: Day 30: "Welcome back" email + new feature highlights; Day 60: Limited coupon email; Day 90: Final notice + account dormancy pre-notification; Day 120: Account dormancy processing.
-   **Tone**: Use warm tone; pressure language ("If you don't come back now...") is prohibited.
-   **Measurement**: Measure Resurrection Rate at each step, continuously improving measure effectiveness.
-   **A/B Testing**: Optimize re-engagement email subjects, content, and send timing via A/B testing.

### 10.3. The Cancellation Flow Standard
-   **Law**: Mandate cancellation procedures completable within **3 steps**.
-   **Steps**: 1. **Reason Collection**: Cancellation reason selection (dropdown + optional free text); 2. **Retention Offer**: Optional retention offer (**one-time only**), e.g., "next month free," "plan downgrade"; 3. **Final Confirmation**: Confirmation screen + immediate cancellation execution.
-   **Confirmation**: Send confirmation email immediately after cancellation completion, including "rejoin anytime" pathway.
-   **Anti-Dark Pattern (Strictly Prohibited)**: Intentionally hiding/making cancellation button hard to find; displaying multiple consecutive retention modals; requiring phone/in-person only cancellation; adding unnecessary steps before cancellation completion.
-   **Win-Back Campaign**: Send Win-Back emails at 30/60/90 days post-cancellation with special offers.
-   **Involuntary Churn Prevention**: Implement Dunning Management for payment failure-driven involuntary churn (retry schedule, card update reminder, alternative payment method presentation).
-   **Cancellation Reason Analytics**: Aggregate and analyze cancellation reason data monthly, feeding back to product improvement. Always develop action plans for Top 3 cancellation reasons.
-   **Cross-Reference**: `601_data_governance.md` — Dark pattern prohibition, GDPR deletion rights

---

## Part XI: VoC & Feedback Loop

### 11.1. The VoC Pipeline Protocol
-   **Law**: Establish a systematic process for collecting, analyzing, and reflecting User Voice (Voice of Customer).
-   **Collection Channels**: In-app feedback (always-on), NPS/CSAT/CES surveys (per measurement standards), App store reviews (weekly), Support tickets (weekly), SNS monitoring (daily), Sales/CS feedback (ad-hoc), Community forums (daily), Call/chat log analysis via Conversation Intelligence (weekly).
-   **Analysis**: Classify collected feedback (feature requests, bug reports, UX improvements, content) and **reflect in product roadmap monthly**.
-   **Close the Loop**: After implementing improvements based on feedback, notify the users who provided the feedback. Regularly update status for unaddressed feedback to prevent user voices from becoming a "black hole."
-   **AI-Powered Theme Detection**: AI performs automatic theme extraction from feedback, identifying emerging trends and issues early.

### 11.2. The Feedback Widget UX Standard
-   **Law**: In-app feedback widgets must meet the following quality standards.
-   **Accessibility**: Accessible within 2 clicks from any screen.
-   **Low Friction**: Submittable with minimum input (emotion selection + optional free text).
-   **Screenshot Attach**: Provide screenshot attachment functionality.
-   **Context Auto-Attach**: Automatically attach URL, device info, and browser info on submission (excluding PII).
-   **Session Replay Link**: Auto-attach session replay link on feedback submission to improve issue reproducibility (requires user consent).

---

## Part XII: NPS/CSAT/CES Measurement Standards

### 12.1. The NPS Measurement Standard
-   **Law**: Adopt NPS as a quantitative metric for customer loyalty, measuring continuously.
-   **Survey Timing**: Display NPS survey in-app at 30 days, 60 days, then every 90 days after service start.
-   **Question**: "How likely are you to recommend this service to a friend or colleague? (0-10)"
-   **Follow-up**: Promoter (9-10): "What do you like most?"; Passive (7-8): "What could we improve?"; Detractor (0-6): "What disappointed you?"
-   **Target**: NPS **≥ 40**. **Response Rate Target**: **≥ 20%**.

### 12.2. The CSAT Measurement Standard
-   **Law**: Measure CSAT after specific interaction completion.
-   **Trigger Design**: AI feature completion → "Was this answer helpful?" 👍/👎; Search completion → "Did you find what you were looking for?"; Support resolution → "How satisfied were you? (1-5)"
-   **Target**: Average CSAT score **≥ 4.2 / 5.0**.

### 12.3. The CES Measurement Standard
-   **Law**: CES measures how much "effort" users felt achieving their goal.
-   **Trigger**: After support inquiry resolution, after self-service feature use.
-   **Question**: "Was the problem easy to resolve?" (7-point scale)
-   **Target**: Average CES score **≥ 5.5 / 7.0**.
-   **Action**: Analyze friction causes for users who responded "difficult" and reflect in UX improvement or FAQ expansion.

### 12.4. The Survey Widget UX Standard
-   **Throttling**: Maximum **1 survey per 7 days** for the same user (Survey Fatigue prevention).
-   **Skip Button**: Always display "Skip" button; forced responses prohibited.
-   **Auto-Close**: Auto-close after 10 seconds without response.
-   **Non-Blocking**: Position on layer that doesn't obstruct main content interaction.

### 12.5. The Survey Data Schema Standard
-   **Recommended Schema**: `id` (UUID), `user_id` (UUID, FK to user table), `survey_type` (TEXT: nps/csat/ces), `trigger_event` (TEXT), `score` (INT), `feedback_text` (TEXT, nullable), `segment` (TEXT), `plan_tier` (TEXT), `created_at` (TIMESTAMPTZ).

### 12.6. The Analytics Dashboard Standard
-   **Required Visualizations**: NPS trend chart (monthly, past 12 months); CSAT distribution (trigger-based histogram); Detractor alert (NPS 0-6 instant notification); Text analysis (word cloud / category breakdown); Segment comparison (plan tier score comparison); CES trends (by channel, by feature); AI vs Human CSAT comparison chart.

---

## Part XIII: Interaction Design (Forms)

### 13.1. The Dynamic Form Runner
-   **Law**: Standardize design where input forms (contact forms, etc.) are **dynamically generated from DB/CMS-defined schemas** rather than hardcoded.
-   **Action**: Schema-Driven (form field definitions in DB JSONB or dedicated table); No Deploy for Forms (no code deploy required for form changes); Validation Sync (auto-generate frontend validation from DB schema); Anti-Bot/Spam Protection (CAPTCHA or challenge auth on all forms); PII Access Restriction (admin-only PII viewing); Smart Pre-fill (auto-fill known info for logged-in users).

---

## Part XIV: Notification & Channel Design

### 14.1. The Channel Priority Protocol
-   **Law**: Define priority for user contact channels, delivering from highest-reach channel first.
-   **Priority Cascade**: `In-app notification > Email > SMS`. Fallback when upper channel unavailable.
-   **User Preference**: Provide UI for users to enable/disable notification channels.

### 14.2. The Notification Channel Selection Matrix

| Urgency / Importance | Low Importance | High Importance |
|:---------------------|:--------------|:----------------|
| **Immediate (Urgent)** | In-app (Toast) | Email + Push |
| **Normal** | In-app (Bell) | Email |
| **Batch (Scheduled)** | — | Email digest (weekly, etc.) |

-   **Unsubscribe**: Always provide one-click unsubscribe for marketing notifications.

### 14.3-14.5. Notification Standards
-   **In-App Types**: Toast (auto-dismiss), Bell (persistent with read management), Banner (fixed header, admin-controlled).
-   **Frequency Control**: Marketing notification cap **3/day**; Quiet Hours (21:00-8:00 marketing postponed to next morning; transactional exempt); One-Click Unsubscribe with legal compliance (CAN-SPAM, etc.); Preference Center with per-category ON/OFF control.
-   **Category Matrix**: Transaction (immediate email+push), Communication (immediate email+push), Marketing (batched push), System (immediate email), Reminder (scheduled push).

---

## Part XV: Email Template & Quality Standards

### 15.1. The Auto-Reply Mandate
-   **Law**: Mandate **Auto-Reply** acknowledgment immediately upon user inquiry submission.
-   **Instant Acknowledgment**: Send receipt confirmation email immediately after inquiry submission.
-   **SLA Display**: Include expected response time (SLA) in auto-reply.
-   **No Silent Submission (Ghost Feature Prohibition)**: No feedback after form submission is strictly prohibited.

### 15.2. The Email Template Structure Protocol
-   **Mandate**: All system emails require 5 elements: Subject (concise, ≤30 chars recommended), Greeting (personalized with user name), Body (purpose/result/next action), CTA (button format with URL fallback), Signature (service name, contact info, unsubscribe link with legal compliance).
-   **Plain Text**: Always include plain text version with HTML emails.

### 15.3. The Email Body Protocol
-   **Structure (3-Part)**: What (what happened), Why (why this email was sent), Next (what to do next with CTA).
-   **Anti-Pattern**: No technical term exposure ("OTP Token," "Session ID," "UUID"); no commanding tone.
-   **Best Practice**: Security emails include "If you didn't request this, ignore this email"; links with explicit expiration ("Valid for 24 hours").
-   **Send Retry**: Max 3 retries on failure; failures logged + admin notified.
-   **Email Deliverability**: Measure monthly; maintain **≥ 98%**; monitor bounce rate and spam classification rate.

---

## Part XVI: Email Sending Governance

### 16.1. The Sender Identity Governance Protocol
-   **Law**: Organize all system email "From" addresses by purpose with trusted display names.
-   **Purpose-Based Separation**: Transaction (`noreply@{domain}`), Marketing (`news@{domain}`), Support replies (`support@{domain}`).
-   **Free Email Prohibition**: System emails from free email addresses prohibited.
-   **Reply-To Mandate**: Set support address as `Reply-To` even for `noreply@` senders.
-   **Cross-Reference**: `600_security_privacy.md` — SPF/DKIM/DMARC

### 16.2. The Email Audit Schema Standard
-   **Law**: Record all system email sends in an audit table.
-   **Schema**: `id` (UUID), `recipient_email` (TEXT, masked: `a***z@...`), `template_type` (TEXT), `subject` (TEXT), `status` (sent/failed/bounced), `provider_id` (TEXT), `sent_at` (TIMESTAMPTZ), `error_detail` (TEXT).
-   **PII Protection**: `recipient_email` stored masked. **Retention**: Defined by Blueprint (recommended: 1 year), auto-delete after.
-   **Cross-Reference**: `601_data_governance.md` §3 — Email Compliance Protocol

---

## Part XVII: Community & Forum Strategy

### 17.1. The Community-Led Support Strategy
-   **Law**: Build and operate the user community as a key pillar of the support ecosystem.
-   **Community Types**: Help forum (Discourse, GitHub Discussions), Feature requests (Canny, ProductBoard), Beta testers (invite-only), Champion program, User groups (industry/regional networking), Developer community (Discord, Stack Overflow).

### 17.2. The Community Moderation Protocol
-   **Law**: Establish clear guidelines and moderation framework for community forums.
-   **Community Guidelines**: Clear definition of allowed/prohibited behavior; PII posting prohibition; harassment/discrimination prohibition; spam/self-promotion limits; violation handling process (warning → suspension → permanent ban).
-   **Moderation Tools**: AI auto-flag for inappropriate content; user reporting; moderator dashboard.
-   **Response Time**: Complete moderation action within **24 hours** for reports.

### 17.3. The Champion Program Standard
-   **Law**: Identify and nurture passionate users (Champions/Advocates; build community self-sufficiency.
-   **Recognition**: Badges, dedicated forums, early feature access, annual event invitations.
-   **Empowerment**: Grant champions moderation rights and knowledge base edit proposal rights.
-   **Community Health Metrics**: Monthly active posters, average question response time, community resolution rate, new member retention rate (posting within 30 days of registration).

---

## Part XVIII: Trust & Safety

### 18.1. The Trust & Safety Framework
-   **Law**: Build and operate a comprehensive framework to protect user safety and trust.
-   **Scope**: Abuse detection and response; harmful content moderation; inter-user harassment prevention; minor protection; fraud/scam prevention; AI-generated content identification/labeling; Social engineering attack detection via support channels.

### 18.2. The Content Moderation Standard
-   **Law**: For services with UGC, implement multi-layered content moderation.
-   **Moderation Layers**: L1: Auto-filter (keyword filter, AI model — real-time blocking); L2: AI Classification (LLM context understanding — nuanced harmful content); L3: Human Review (moderator judgment — difficult cases); L4: User Reports (community reports — catch missed content).
-   **Transparency Report**: Recommend periodic publication of moderation activity (removal count, reason breakdown).
-   **DSA Compliance**: EU-market services must comply with Digital Services Act content moderation transparency requirements.

### 18.3. The User Report & Appeal Protocol
-   **Law**: Provide user reporting and appeal processes for moderation decisions.
-   **Report Flow**: 2-click report → reason selection → 24-hour moderation decision → action (warning/removal/suspension) → notify both parties.
-   **Appeal Process**: Appeal within **7 days**; separate moderator re-reviews.
-   **Cross-Reference**: `600_security_privacy.md` — Bot/DDoS defense, `601_data_governance.md` — Child/vulnerable person protection

### 18.4. The Support Channel Security Standard
-   **Law**: Implement security measures to prevent social engineering attacks via support channels.
-   **Agent Identity Verification**: Multi-factor user identity verification before account changes (registered email confirmation + security question or in-app authentication).
-   **Social Engineering Detection**: AI detects suspicious request patterns (sudden contact change requests, abnormal access patterns), triggering additional authentication.
-   **Sensitive Operation Lock**: High-risk operations (account deletion, full data export) only via authenticated in-app flows, not support channel requests.

---

## Part XIX: Support Accessibility

### 19.1. The Support Accessibility Mandate
-   **Law**: All support channels (chat, forms, knowledge base, community) must comply with **WCAG 2.2 Level AA**.
-   **EAA Compliance**: EU-market services must meet European Accessibility Act (EAA, effective June 2025) requirements.
-   **Key Requirements**: Full screen reader support (ARIA labels, semantic HTML); keyboard-only operation completion; sufficient color contrast ratio (4.5:1+); visible focus indicators; video captions/subtitles; alt text on all images; touch target size (min 24x24px, recommended 44x44px).

### 19.2. The Accessible Communication Standard
-   **Law**: Provide communication means considerate of diverse user needs in support interactions.
-   **Requirements**: Text-based chat support (for hearing-impaired users); large font size / high contrast mode; Plain Language writing; multilingual support; cognitive disability accommodation (simple navigation, clear labeling).
-   **Accessibility Testing**: Always run accessibility tests (axe-core, etc.) on support UI/UX changes.
-   **Cross-Reference**: `200_design_ux.md` — WCAG 2.1 AA standards, Accessibility

---

## Part XX: Support Operations & Team

### 20.1. The Support Team Structure Standard
-   **Law**: Structure the support organization with clear hierarchical responsibilities.

    | Tier | Role | Responsibility |
    |:-----|:-----|:--------------|
    | **Tier 1** | Frontline | General inquiry handling, FAQ guidance, ticket creation |
    | **Tier 2** | Specialist | Technical issue investigation/resolution, escalation management |
    | **Tier 3** | Engineering | Bug fixes, infrastructure response, root cause analysis |
    | **CS** | CSM | Proactive support, health score management, expansion |
    | **Support Ops** | Operations | Tool management, data analysis, process optimization |

### 20.2. The Agent Training & Certification Protocol
-   **Law**: Institutionalize continuous skill development for support agents.
-   **Onboarding Training**: Minimum **2-week** training before independent handling.
-   **Training Areas**: Product knowledge; communication skills (empathy, de-escalation); tool proficiency; security/privacy awareness; accessibility awareness; AI Copilot skills; social engineering attack identification.
-   **Continuous Learning**: Monthly training (product updates, case study sharing).
-   **Certification**: Quarterly skill assessments; additional training for those below threshold.
-   **Shadowing Program**: New agents shadow veteran agents for minimum 1 week.

### 20.3. The Agent Wellbeing Protocol
-   **Law**: Protect support agent mental health and sustainable work practices.
-   **Burnout Prevention**: Consecutive handling time limits (recommended: 2-hour handling + 15-minute break cycles); cooldown time after difficult cases; psychological safety for escalation ("asking for help ≠ weakness" culture).
-   **Toxic Interaction Shield**: Guarantee agent right to discontinue handling and hand off to manager for clearly aggressive/harassing users.
-   **Wellbeing Metrics**: Measure agent turnover rate, satisfaction (eNPS), and burnout risk score quarterly.
-   **Workload Balance**: Prevent load concentration on specific agents through AI-powered ticket auto-routing.

---

## Part XXI: Support QA & Quality Management

### 21.1. The Support QA Framework
-   **Law**: Operate a QA program that quantitatively measures and manages support quality.
-   **QA Scorecard**: Accuracy (30%), Empathy (20%), Efficiency (15%), Completeness (20%), Process Adherence (15%).
-   **Sampling Rate**: QA review on **≥ 5%** of all tickets via random sampling.
-   **Calibration Session**: Monthly calibration sessions to align QA evaluator scoring standards.

### 21.2. The AutoQA & Conversation Intelligence Standard
-   **Law**: Leverage AI for automated QA scoring across all tickets, dramatically improving quality management coverage.
-   **AutoQA Coverage**: Apply AI QA scoring to **100%** of all tickets (supplementing human QA's 5% sampling).
-   **AutoQA Dimensions**: Answer accuracy (knowledge base consistency verification); tone/empathy evaluation; SLA compliance auto-determination; follow-up appropriateness.
-   **Conversation Intelligence**: Analyze all conversation data to auto-extract: top friction points; agent skill gaps; best practice case auto-discovery; AI answer quality trends.
-   **Low-Score Alert**: Auto-route tickets below AutoQA score threshold to human review queue.

### 21.3. The DSAT Analysis Protocol
-   **Law**: Conduct root cause analysis on **all** low CSAT score (1-2/5) tickets.
-   **Root Cause Categories**: `product_issue` / `agent_error` / `process_gap` / `expectation_mismatch` / `sla_breach`
-   **Action Loop**: Aggregate weekly, develop and execute improvement actions for top 3 root causes.
-   **Agent Performance Analytics**: Visualize individual agent performance (CSAT, AHT, FCR, QA score) for individual coaching plans.

---

## Part XXII: Support FinOps

### 22.1. The Support Cost Optimization Protocol
-   **Law**: Visualize support costs and optimize the balance between efficiency and user experience.
-   **Key Metrics**: Cost per Ticket (CPT), Cost per Resolution (CPR), AI Deflection Savings, Self-Service Savings, Cost per AI Resolution (target: ≤ 1/5 of human CPR).
-   **CPR Optimization Curve**: Create Resolution Rate vs Cost curve to identify optimal AI/human ratio.
-   **Budget Allocation**: Review support budget allocation (personnel/tools/AI/training) quarterly for ROI maximization.

### 22.2. The AI Support ROI Standard
-   **Law**: Continuously measure AI adoption ROI.
-   **Efficiency Gain**: Pre/post AI CPT and resolution time comparison.
-   **Quality Impact**: Pre/post AI CSAT and FCR changes.
-   **Token Cost Management**: Track AI model token consumption/cost real-time; optimize cost-inefficient prompts; compare model cost-performance; set token budget caps with alerts (notification at 80% monthly budget consumption).
-   **AI Token Budget Formula (Recommended)**:
    ```
    Monthly AI Budget = (Projected Tickets × AI Processing Rate × Avg Tokens/Ticket × Token Unit Price) × 1.2 (Buffer)
    ```
-   **Cross-Reference**: `101_revenue_monetization.md` — AI Token Economics, FinOps

---

## Part XXIII: Support Analytics & Observability

### 23.1. The Support Analytics Dashboard Standard
-   **Law**: Operate a dashboard that visualizes support performance in real-time.
-   **Required Visualizations**: Real-time queue; SLA compliance rates by priority; agent status; trend analysis (hourly/daily inquiry volumes); topic analysis; CSAT/NPS trends; AI Resolution Rate real-time monitoring; AI vs Human performance comparison.

### 23.2. The Support Observability Standard
-   **Law**: Monitor support system health from an observability perspective.
-   **Monitoring Targets**: Chatbot response time/error rate; email send success/bounce rate; knowledge base search hit/zero-result rate; AI model classification accuracy/escalation rate; support API latency/error rate; AI Agent Tool Use success rate/latency.
-   **Alerting**: Fire alerts immediately when metrics exceed thresholds.
-   **Cross-Reference**: `502_site_reliability.md` — 5 Observability Pillars, `401_data_analytics.md` — Analytics dashboard quality standards

---

## Part XXIV: Compliance & Regulatory

### 24.1. The Customer Support Compliance Standard
-   **Law**: Comply with the following regulations in support operations.
-   **Data Protection**: GDPR/APPI/CCPA-compliant PII handling; minimum retention/scheduled deletion of PII in tickets; DSR response process.
-   **Consumer Rights**: Cancellation freedom (dark pattern prohibition); legal complaint handling compliance; clear refund policy disclosure.
-   **Accessibility Compliance**: WCAG 2.2 Level AA (Part XIX); EAA; ADA.
-   **AI Transparency**: EU AI Act compliance (AI usage disclosure); AI decision explainability.

### 24.2. The Data Subject Request Protocol
-   **Law**: Respond to user DSR (data access/deletion/correction) within legally mandated timeframes.
-   **Response SLA**: GDPR: **30 days**; CCPA: **45 days**; APPI: **without delay**.
-   **Process**: When support receives DSR, route via dedicated workflow to data protection team.
-   **Cross-Reference**: `601_data_governance.md` — GDPR/APPI/CCPA compliance, Data subject rights

---

## Part XXV: Voice AI & Conversational Support

### 25.1. The Voice AI Agent Standard
-   **Law**: Deploy Voice AI agents in phone support for autonomous problem resolution.
-   **Capability Requirements**: NLU intent detection accuracy **≥ 95%**; multi-turn context maintenance; emotion recognition with tone adjustment; real-time ASR; multilingual support.
-   **Resolution Target**: Voice AI autonomous resolution rate **≥ 60%**.
-   **Handoff Design**: Design seamless human agent handoff with mandatory full conversation context transfer.

### 25.2. The IVR Modernization Standard
-   **Law**: Drive migration from menu-based IVR to Conversational IVR.
-   **Anti-Pattern**: Legacy IVR with deep menu hierarchy (3+ levels) is prohibited.
-   **Requirements**: Natural language request capture; estimated wait time announcement; callback reservation option; Visual IVR support.

### 25.3. The Speech Analytics Standard
-   **Law**: Analyze all call audio for quality improvement and compliance verification.
-   **Required Analytics**: Sentiment analysis (real-time); keyword/topic detection; compliance term detection; silence/hold time analysis; agent tone/speed analysis.
-   **Privacy**: Comply with legal requirements for call recording (consent obligations).

### 25.4. The Conversational AI Safety Standard
-   **Law**: Implement LLM safety guardrails in Voice AI and Chat AI.
-   **Guard Layer Architecture**: Input Guard (prompt injection detection); System Prompt Protection (leakage prevention); Output Guard (harmful content prevention via Content Safety API); Topic Guard (out-of-scope topic rejection); PII Guard (PII output prevention with masking).
-   **Red Team Testing**: Conduct Red Team Testing (adversarial testing) on AI support systems quarterly to identify and fix vulnerabilities.
-   **Cross-Reference**: `400_ai_engineering.md` — Guardrail design, `600_security_privacy.md` — Security standards

---

## Part XXVI: Hyper-Personalization Strategy

### 26.1. The Hyper-Personalization Framework
-   **Law**: Individually optimize all support interactions through AI-driven hyper-personalization.
-   **Personalization Layers**: Context (current screen/state/last action — app events); Behavioral history (past usage patterns/ticket history — behavioral logs); Segment (plan/industry/region — CRM/CDP); Preferences (notification settings/channel preference/language — user settings); Prediction (churn risk/expansion potential — ML models).

### 26.2. The Next-Best-Action Engine
-   **Law**: Present AI-powered Next-Best-Action at all support touchpoints.
-   **Action Types**: Real-time article/tutorial suggestions; personalized onboarding steps; segment-specific upsell/cross-sell offers; proactive risk mitigation actions; Next-Best-Offer based on usage patterns.
-   **Anti-Pattern**: "One-Size-Fits-All" approaches showing same guidance to all users are prohibited.
-   **Propensity Model Integration**: Integrate with Propensity Score to display offers only to high-expansion-potential customers.

### 26.3. The CDP Integration
-   **Law**: Integrate support systems with Customer Data Platform (CDP) for 360-degree customer view.
-   **Required Data Points**: Product usage data; support history; contract/billing data; marketing engagement.
-   **Privacy**: Personal data in CDP must comply with `601_data_governance.md` consent management and data protection regulations.

---

## Part XXVII: Digital Customer Success (Digital CS)

### 27.1. The Digital CS Strategy
-   **Law**: Build fully automated digital CS programs for tech-touch/low-touch segments.
-   **Digital CS Playbook**: Onboarding (welcome series, checklists — In-App + Email, Day 0-30); Adoption (feature guides, best practices — In-App, Day 30-90); Engagement (usage tips, new feature announcements — In-App + Email, continuous); Retention (risk alerts, re-engagement — Email + In-App, trigger-based); Expansion (upgrade guidance, usage alerts — In-App, trigger-based).
-   **PLG Integration**: Align with Product-Led Growth strategy, making in-product experience the primary CS channel.
-   **Usage-Based Triggers**: For UBP models, set automation triggers based on usage thresholds.

### 27.2. The Digital Adoption Platform Integration
-   **Law**: Leverage DAP to promote autonomous learning and adoption within the product.
-   **DAP Capabilities**: Context-aware in-app walkthroughs; interactive guided tours; Smart Tips; Feature Discovery (highlight unused features); personalized checklists.
-   **Requirements**: Segment-personalized messaging; trigger-based display; A/B testing for optimization; display frequency control (same guide max once per 24 hours).

### 27.3. The Automated QBR Standard
-   **Law**: Automate Quarterly Business Reviews for mid-touch and below segments.
-   **Digital QBR Contents**: Usage summary (KPI trends); ROI calculation (cost savings/productivity gains quantified); unused feature recommendations; benchmark comparison (industry average); next quarter action plan proposal.
-   **Delivery**: Personalized dashboard URL or interactive PDF.

---

## Part XXVIII: CS Revenue Accountability

### 28.1. The CS Revenue Framework
-   **Law**: Assign clear NRR responsibility to CS teams and quantify revenue contribution.
-   **Key Revenue Metrics**: NRR (target ≥ 110%); GRR (target ≥ 90%); Expansion Revenue (≥ 30% of new ARR); Churn Saved Revenue; Support-Influenced ARR.
-   **CS-Led Growth**: Position CS team as a Revenue Engineering function, leading expansion strategy development and execution.

### 28.2. The CSQL Standard
-   **Law**: Define process for CS team to hand off identified expansion/upsell opportunities as CSQLs to sales.
-   **CSQL Criteria**: Health Score ≥ 80; usage at 70%+ of plan limit; positive feedback from champions; renewal within 90 days; Product Qualified Signals (PQS).
-   **Handoff Process**: Register CSQLs in CRM and conduct regular joint reviews with sales.
-   **Consumption-Based Expansion**: For UBP models, automate predictive upgrade recommendations based on usage trends.

### 28.3. The Renewal Management Standard
-   **Law**: Systematize contract renewal process with target renewal rate **≥ 95%**.
-   **Renewal Timeline**: T-120: Pre-renewal review start; T-90: Renewal plan proposal; T-60: Terms agreement; T-30: Contract preparation/send; T-0: Renewal complete.
-   **At-Risk Renewal Playbook**: Prepare dedicated retention playbook for renewals with low Health Score customers.

---

## Part XXIX: Proactive Support Design

### 29.1. The Proactive Support Framework
-   **Law**: Build a proactive support system that detects and resolves issues **before** inquiries arrive.
-   **Proactive Intervention Types**: Incident pre-notification (on detection → affected user notification); Usage guidance (unused feature detection → personalized tips); Risk intervention (Health Score decline → CSM outreach); Preventive maintenance (usage spike → scaling recommendation); Quality alerts (error rate increase → auto diagnostic report).

### 29.2. The Predictive Issue Resolution Standard
-   **Law**: Leverage ML/AI to predict and resolve issues before users encounter them.
-   **Data Sources**: App error logs, performance metrics, usage pattern anomaly detection.
-   **Automated Resolution**: Implement Self-Healing for known problem patterns.
-   **Notification**: Notify users post-resolution ("We detected and automatically fixed an issue").

### 29.3. The Incident Communication Standard
-   **Law**: Perform proactive and transparent communication during service outages.
-   **Communication Timeline**: T+5min: Status page update; T+15min: In-app/email notification to affected users; Every T+30min: Progress update; Post-resolution: Root cause postmortem publication.
-   **Cross-Reference**: `503_incident_response.md` — Incident communication protocol

---

## Part XXX: Customer Journey Orchestration

### 30.1. The Journey Mapping Standard
-   **Law**: Visualize the entire customer lifecycle as a journey map, designing optimal experiences at each touchpoint.
-   **Lifecycle Phases**: 1. Awareness → 2. Consideration → 3. Onboarding → 4. Adoption → 5. Expansion → 6. Renewal → 7. Advocacy
-   **Touchpoint Design**: Define support/CS touchpoints, channels, and content for each phase.

### 30.2. The Lifecycle Automation Standard
-   **Law**: Trigger automated actions at each journey phase transition.
-   **Automation Triggers**: Phase transition; time-based; behavior-based; risk-based.

### 30.3. The Moment of Truth Design
-   **Law**: Identify and design exceptional experiences for "Moments of Truth" that decisively impact customer loyalty.
-   **Critical Moments**: First value experience ("Aha! Moment"); first support inquiry; major outage response; contract renewal; cancellation consideration.

---

## Part XXXI: Support Knowledge Management (KCS)

### 31.1. The Knowledge-Centered Service Standard
-   **Law**: Adopt KCS methodology, continuously generating and updating knowledge within the support process.
-   **KCS Principles**: Capture (capture knowledge instantly during resolution); Structure (unified format structuring); Reuse (prioritize existing knowledge reuse); Improve (improve knowledge with each use).

### 31.2. The Knowledge Quality Metrics Standard
-   **Law**: Measure knowledge base quality with the following metrics.

    | Metric | Definition | Target |
    |:-------|:----------|:-------|
    | **Reuse Rate** | Existing article reuse rate | ≥ 60% |
    | **Article Resolution Rate** | Ticket avoidance rate after article view | ≥ 50% |
    | **Freshness Score** | % of articles updated within 90 days | ≥ 80% |
    | **Feedback Score** | "Helpful" rating rate | ≥ 75% |
    | **Zero Results Rate** | % of searches with 0 results | ≤ 10% |
    | **AI Citation Accuracy** | % AI correctly cited articles | ≥ 95% |

### 31.3. The AI-Assisted Knowledge Generation Standard
-   **Law**: Leverage AI to streamline knowledge generation.
-   **Capabilities**: Auto-generate article drafts from resolved tickets; auto-summarize/simplify existing articles; multilingual auto-translation (with human review); detect article staleness and recommend updates; Knowledge Graph construction for improved AI answer accuracy; Semantic Search using vector search for improved similar-concept search accuracy.

---

## Part XXXII: Multilingual & Global Support Design

### 32.1. The Global Support Architecture
-   **Law**: Design support delivery across multiple regions and languages.
-   **Follow-the-Sun Model**: Recommend Follow-the-Sun with global teams for 24/7 coverage.
-   **Regional SLA**: Define per-region SLAs accounting for business hours and legal requirements.

### 32.2. The Multilingual Support Standard
-   **Law**: Provide support in all target market languages.
-   **Translation Quality Tiers**: Tier 1: Human translation (legal documents, contracts, policies); Tier 2: AI translation + human review (KB articles, important emails); Tier 3: Real-time AI translation (live chat, low-priority — with quality monitoring).
-   **Language Detection**: Implement automatic language detection and switching in chat and forms.
-   **Real-time Translation API Integration**: Integrate real-time translation APIs (Google Translate API, DeepL API, etc.) into the support platform for multilingual scalability.
-   **Translation Memory**: Leverage Translation Memory (TM) for consistent quality while reducing costs.
-   **Cross-Reference**: `802_language_protocol.md` — Multilingual protocol

### 32.3. The Cultural Sensitivity Standard
-   **Law**: Communicate with consideration for regional cultural differences.
-   **Considerations**: Formality level adjustment (Japanese keigo); timezone/holiday consideration; currency/date format localization; cultural interpretation differences in colors and icons.

---

## Part XXXIII: Customer Effort Score Optimization

### 33.1. The Friction Mapping Framework
-   **Law**: Systematically map and eliminate friction points from support access to problem resolution.
-   **Friction Points Analysis**: Support access path complexity; contact form field count; wait times (first response, resolution); channel switching frequency; repeat explanation count.

### 33.2. The Effortless Experience Design Standard
-   **Law**: Implement designs that minimize user effort across all support interactions.
-   **Design Principles**: Proactive > Reactive; Self-Service > Agent; AI > Manual; Single Contact > Multiple.

---

## Part XXXIV: Support AI Safety & Ethics

### 34.1. The AI Transparency Mandate
-   **Law**: Always disclose when users are interacting with AI.
-   **Disclosure Requirements**: State "AI Assistant" at chat start; label AI-generated content; always present human agent switch option.
-   **Anti-Pattern**: Disguising AI as a human agent is strictly prohibited.

### 34.2. The AI Bias Prevention Standard
-   **Law**: Prevent and monitor bias in AI support systems.
-   **Monitoring**: Regular audits for language/region/race-based quality differences; monthly review of AI response bias; testing across diverse demographics.

### 34.3. The EU AI Act Compliance Standard
-   **Law**: Meet EU AI Act requirements for EU-market services.
-   **Risk Classification**: Customer support AI is typically classified as "Limited Risk" with transparency obligations.
-   **Article 50 Compliance Checklist**: ☐ AI usage disclosure implemented (chatbot notification at start); ☐ AI-generated content labeling (all AI outputs labeled); ☐ Human oversight mechanism (Human-in-the-Loop); ☐ AI decision-making explainability; ☐ User right to human handling guaranteed; ☐ Regular AI system risk assessment (annual minimum); ☐ Technical documentation maintained (AI model purpose/capabilities/limitations).
-   **GPAI Obligations (Effective August 2025)**: Technical documentation retention; training data transparency for copyright compliance; EU AI Office reporting obligations (for systemic risk models).
-   **Penalties**: Fines up to **7%** of global annual turnover or EUR 35M, whichever is higher.
-   **Cross-Reference**: `601_data_governance.md` — EU AI Act details

### 34.4. The Responsible AI in Support Framework
-   **Law**: Adhere to the following ethical principles in AI support development and operation.
-   **Principles**: Fairness (equitable quality for all users); Accountability (clear responsibility for AI decisions); Transparency (AI behavior explainability); Privacy (data minimization principle); Safety (no harmful outputs); Human Control (human final decision rights for important decisions).

---

## Part XXXV: Outcome-Based Support Pricing

### 35.1. The Outcome-Based Pricing Framework
-   **Law**: Evaluate and adopt Outcome-Based Pricing models for AI support tools.
-   **Pricing Models Comparison**: Per-Seat (predictable cost, low AI incentive); Per-Ticket (usage proportional, low deflection incentive); Per-Resolution (outcome-linked, quality risk); Platform Fee + Resolution (balanced — recommended model).

### 35.2. The AI Vendor Selection Standard
-   **Law**: Use the following evaluation axes for AI support vendor selection.
-   **Evaluation Criteria**: Resolution Rate track record; Hallucination rate; multilingual capability; existing stack integration ease; data privacy/security compliance; Outcome-Based Pricing support; vendor SLA (uptime guarantee); EU AI Act compliance status.

---

## Part XXXVI: Workforce Management (WFM)

### 36.1. The Workforce Management Framework
-   **Law**: Scientifically manage support team staffing and shift management.
-   **Forecasting**: Demand forecasting by time/day/season based on historical inquiry data.
-   **AI-Powered Scheduling**: AI generates optimal shift schedules considering demand forecasts, agent skills, and preferences.
-   **Real-time Adherence**: Real-time schedule adherence monitoring.

### 36.2. The Skill-Based Routing Standard
-   **Law**: Auto-route inquiries to agents with optimal skill sets based on inquiry content.
-   **Skill Matrix**: Profile agent skill sets (languages, technical areas, product knowledge).
-   **Intelligent Routing**: AI analyzes ticket content for skill-matching-based routing.
-   **Load Balancing**: Implement workload distribution algorithms for agent balance.
-   **Sentiment-Based Routing**: Auto-route to de-escalation specialists when user sentiment detects "anger."

### 36.3. The Capacity Planning Standard
-   **Law**: Manage support team capacity systematically.
-   **Metrics**: Occupancy Rate (target: 75-85%); Utilization Rate; Shrinkage.
-   **Planning Horizon**: Monthly (short-term) + Quarterly (mid-term) + Annual (long-term).
-   **Gig Worker Integration**: Define processes for temporary surge capacity using gig workers/freelance agents. Maintain quality and security standards equal to full-time agents.

---

## Part XXXVII: Support Tech Stack Design

### 37.1. The Support Tech Stack Architecture
-   **Law**: Design support tech stack holistically, preventing data silos.
-   **Core Components**: Help Desk (Zendesk, Intercom, Freshdesk); Chatbot (Intercom Fin, Zendesk AI, custom LLM); Knowledge Base (Zendesk Guide, Notion, GitBook); CRM (Salesforce, HubSpot); CDP (Segment, mParticle); Analytics (Metabase, Looker, Tableau); WFM (NICE, Assembled); QA (Klaus, MaestroQA); DAP (Pendo, WalkMe, Appcues); CS Platform (Gainsight, Totango, ChurnZero).

### 37.2. The Integration Architecture Standard
-   **Law**: Design API-based data integration between support tools for seamless data flow.
-   **Integration Requirements**: Help desk ↔ CRM bidirectional sync; Chatbot ↔ KB real-time reference; Support data → analytics streaming; CDP → help desk context injection.
-   **Data Flow**: Propagate support interaction data via real-time event streams (Webhook/Event Bus).

### 37.3. The Support Channel Security Architecture
-   **Law**: Design support system security with defense-in-depth.
-   **Security Layers**: Authentication (SSO/MFA for agent access); Authorization (RBAC with least privilege — PII viewing for certified agents only); Encryption (TLS 1.3 in transit, at-rest encryption); Audit Logs (all agent operations logged); DLP (prevent external copying of PII-containing ticket content).
-   **Cross-Reference**: `600_security_privacy.md` — Security standards

---

## Part XXXVIII: Customer Advocacy & Loyalty

### 38.1. The Customer Advocacy Framework
-   **Law**: Nurture and leverage high-satisfaction customers as brand Advocates.
-   **Advocacy Programs**: Referral program (referral rewards); Case studies (co-created success stories); Review requests (G2/Capterra reviews); Speakers (conference/webinar speakers); User board (product development participation).

### 38.2. The Referral Program Standard
-   **Law**: Systematically design and operate the referral program.
-   **Requirements**: Simple referral flow (one-click invite link generation); bidirectional incentives (benefits for both referrer and referee); automated tracking/measurement; fraud prevention (self-referral, duplicate detection).

---

## Part XXXIX: Future Outlook & Emerging Technologies

### 39.1. The Emerging Technology Watch
-   **Law**: Continuously watch emerging technologies in support/CS and plan experimentation/adoption.
-   **Watch Areas (2025-2027)**: AR/VR Support (product 3D guides — experimental); Digital Twin (virtual customer environment diagnostics — early); Spatial Computing (headset support UI — early); Emotion AI (real-time emotion recognition — growing); Autonomous CS Agents (fully autonomous CS — growing); Predictive Support (pre-incident AI prediction/auto-repair — mature); Ambient Computing (wearable/IoT device support — early); Multi-Agent Systems (coordinated AI agent end-to-end resolution — growing).

### 39.2. The Innovation Experimentation Protocol
-   **Law**: Follow staged experimentation for new technology adoption.
-   **Process**: 1. PoC (Proof of Concept); 2. Pilot (limited users); 3. Limited GA (staged rollout); 4. Full GA (full user deployment).

---

## Part XL: Maturity Model & Quick Reference Index

### 40.1. The Support Maturity Model

| Level | Name | Characteristics |
|:------|:-----|:---------------|
| **L1: Reactive** | Reactive | Inquiry-based only. No SLA. No knowledge base. |
| **L2: Defined** | Defined | SLA defined. Basic FAQ/KB. Manual ticket classification. |
| **L3: Managed** | Managed | Omnichannel integration. AI triage. QA program. Systematic VoC. |
| **L4: Proactive** | Proactive | Health Score operations. Predictive detection with proactive intervention. Agentic AI. Community self-running. Digital CS. |
| **L5: Optimized** | Optimized | Predictive analytics-driven full automation. Support-Influenced ARR visibility. NRR ≥ 110%. AI Autonomous Resolution ≥ 80%. Continuous experimentation. |

-   **Assessment**: Quarterly self-assessment of maturity level with roadmap to next level.

### 40.2. Anti-Pattern Collection

| # | Anti-Pattern | Correct Approach |
|:--|:------------|:----------------|
| 1 | **Black Hole Support**: Receive feedback but reflect nothing | Close the Loop obligation |
| 2 | **Runaround Escalation**: No resolution through endless transfers | Empowerment + FCR maximization |
| 3 | **Cold AI Response**: Lack of warmth from AI-only responses | Human-in-the-Loop + AI Copilot |
| 4 | **Dark Pattern Cancellation**: Deliberately making cancellation difficult | 3-step cancellation + Anti-Dark Pattern |
| 5 | **Survey Fatigue**: Excessive survey display | 7-day max 1 throttling |
| 6 | **Context Loss Handoff**: Context loss on channel switch | Omnichannel + Unified Customer View |
| 7 | **Silent Ghost Feature**: No feedback after form submission | Auto-Reply Mandate |
| 8 | **Support Silo**: Not leveraging support data for product improvement | Support-Driven Development |
| 9 | **One-Size-Fits-All**: Same support model for all customers | Segment-based touch models |
| 10 | **Agent Burnout**: Excessive agent workload | Wellbeing Protocol |
| 11 | **AI Impersonation**: Disguising AI as human | AI Transparency Mandate |
| 12 | **Knowledge Hoarding**: Knowledge siloed to individuals | KCS (Knowledge-Centered Service) |
| 13 | **Hallucination Tolerance**: Ignoring AI hallucinations | Grounding + Citation + AutoQA |
| 14 | **Tool Use Without Audit**: Not auditing AI Tool Use | Audit Trail + Dry Run mode |

---

## Appendix A: Quick Reference Index

| Keyword | Reference Section |
|:--------|:-----------------|
| AI Copilot | 2.4 |
| AI Triage | 2.1 |
| AI Quality Assurance | 2.6 |
| AI Safety & Ethics | 34.1-34.4 |
| AI Tool Use | 2.3 |
| AI Agent Observability | 2.6 |
| Agentic AI | 2.2 |
| AutoQA | 21.2 |
| CDP Integration | 26.3 |
| CSAT | 12.2 |
| CES | 12.3, 33.1-33.2 |
| CSQL | 28.2 |
| CS-Led Growth | 28.1 |
| Customer Education | 9.4 |
| Customer Health Score | 8.1, 8.2 |
| DAP | 27.2 |
| Digital CS | 27.1-27.3 |
| DSR | 24.2 |
| EU AI Act | 34.3 |
| Gig Worker | 36.3 |
| Grounding | 2.5 |
| IVR | 25.2 |
| KCS | 31.1-31.3 |
| Knowledge Graph | 31.3 |
| MCP/A2A | 2.3 |
| NPS | 12.1 |
| NRR | 28.1 |
| Outcome-Based Pricing | 35.1 |
| PLG | 27.1 |
| Propensity Scoring | 8.2, 26.2 |
| Prompt Injection Defense | 2.5, 25.4 |
| SLA | 4.1 |
| Social Engineering | 18.4 |
| Support Excellence Culture | 1.5 |
| Token Cost Management | 22.2 |
| Trust & Safety | 18.1-18.4 |
| VoC | 11.1 |
| Voice AI | 25.1-25.4 |
| WFM | 36.1-36.3 |
| Accessibility | 19.1, 19.2 |
| Advocacy | 38.1-38.2 |
| Cancellation | 10.3 |
| Community | 17.1-17.3 |
| Compliance | 24.1, 24.2 |
| Escalation | 5.1-5.3 |
| Knowledge Base | 6.2, 6.3, 31.1-31.3 |
| Onboarding | 9.1-9.4 |
| Proactive Support | 29.1-29.3 |
| Retention | 10.1-10.3 |
| Self-Service | 6.1-6.4 |

## Appendix B: Cross-References

| Referenced Rule | Related Topic |
|:----------------|:-------------|
| `000_core_mindset.md` | Priority hierarchy, existing functionality protection |
| `100_product_strategy.md` | Review/trust systems |
| `101_revenue_monetization.md` | AI Token Economics, FinOps |
| `102_growth_marketing.md` | PLG, Onboarding, Retention |
| `200_design_ux.md` | WCAG compliance, Omotenashi UX, Error messages |
| `400_ai_engineering.md` | Guardrails, RAG, PII Scrubbing |
| `401_data_analytics.md` | Analytics dashboard quality standards |
| `500_internal_tools.md` | Admin escalation standards |
| `502_site_reliability.md` | Incident management, Observability |
| `503_incident_response.md` | P0 incident escalation, outage communication |
| `600_security_privacy.md` | SPF/DKIM/DMARC, bot defense, prompt injection |
| `601_data_governance.md` | GDPR/APPI/CCPA, dark pattern prohibition, child protection, EU AI Act |
| `700_qa_testing.md` | Test strategy, accessibility testing |
| `802_language_protocol.md` | Notification/email language protocol, multilingual support |
