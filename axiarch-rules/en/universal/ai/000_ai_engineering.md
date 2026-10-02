# 40. AI Implementation & UX Strategy

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-03-24

> [!IMPORTANT]
> **Primary Directive**
> "AI is a tool; operational responsibility always rests with humans."
> In AI feature implementation, strictly adhere to the priority order: **Safety > Reliability > UX > Cost Efficiency > DX**.
> This document is the primary standard for all AI-related design decisions.
> **48 Parts, 60 Sections.**

---

## Table of Contents

- Part I: Primary Directive & AI Philosophy
- Part II: AI UX Principles
- Part III: AI UX Pattern Catalog
- Part IV: AI Ethics Framework
- Part V: AI Governance Structure
- Part VI: EU AI Act Compliance
- Part VII: Global AI Regulation Mapping
- Part VIII: AI Content Labeling & Copyright
- Part IX: User Data and AI Training
- Part X: AI Bias and Fairness
- Part XI: AI Architecture Patterns
- Part XII: Model Routing & Abstraction
- Part XIII: Context Window Management
- Part XIV: Structured Output & Function Calling
- Part XV: Streaming Architecture
- Part XVI: Asynchronous AI Processing
- Part XVII: Semantic Caching
- Part XVIII: AI Security
- Part XIX: RAG Foundation Design
- Part XX: Advanced Chunking Strategies
- Part XXI: Hybrid Search
- Part XXII: Reranking
- Part XXIII: GraphRAG & Knowledge Graphs
- Part XXIV: Multimodal RAG
- Part XXV: RAG Evaluation Frameworks
- Part XXVI: Agentic AI Strategy
- Part XXVII: Agent Design Patterns
- Part XXVIII: MCP (Model Context Protocol)
- Part XXIX: A2A (Agent-to-Agent Protocol)
- Part XXX: Multi-Agent Orchestration
- Part XXXI: AI Guardrail Design
- Part XXXII: Hallucination Mitigation
- Part XXXIII: Domain-Specific Safety
- Part XXXIV: Crisis Management & Kill Switch
- Part XXXV: AI Destructive Command Ban & HITL
- Part XXXVI: AI FinOps Strategy
- Part XXXVII: Usage Metering & Billing
- Part XXXVIII: Token Cost Optimization
- Part XXXIX: Multimodal & Edge AI
- Part XL: LLMOps Lifecycle
- Part XLI: PromptOps
- Part XLII: Model Lifecycle Management
- Part XLIII: AI Quality Metrics
- Part XLIV: Automated Evaluation (LLM-as-a-Judge)
- Part XLV: AI Observability
- Part XLVI: Future Outlook
- Part XLVII: Maturity Model (5 Levels)
- Part XLVIII: Anti-Pattern Collection (20 Items)
- Part XLIX: Advanced RAG Architecture
- Part L: OWASP LLM Top 10 2025 Full Compliance
- Part LI: LLM Firewall & AI Red Teaming
- Part LII: AI Accessibility
- Part LIII: AI-Driven Personalization & Adaptive UI
- Part LIV: Advanced Prompt Engineering
- Part LV: Fine-Tuning & Model Customization
- Part LVI: AI-Generated Content Quality Management
- Part LVII: AI Companion & Emotional AI Safety
- Part LVIII: AI Technical Debt Management
- Part LIX: Agent Communication Protocol Integration (MCP/A2A/ACP)
- Part LX: AI Implementation Compliance Checklist Integration
- Appendix A: Quick Reference Index
- Appendix B: Cross-References

---

## Part I: Primary Directive & AI Philosophy

### 1.1. Core Principles of AI Implementation

- **Rule 40.1**: AI features **assist** user decision-making; they do not **replace** it
- **Rule 40.2**: AI outputs are always "suggestions"; designs must ensure final judgment rests with humans
- **Rule 40.3**: AI feature failures must not halt the entire service (Graceful Degradation is mandatory)

### 1.2. AI Implementation Priority Hierarchy

| Priority | Domain | Description |
|:---|:---|:---|
| **P0** | Safety | User safety, PII protection, harmful content blocking |
| **P1** | Reliability | Hallucination prevention, factual accuracy, source transparency |
| **P2** | UX | Response speed, conversation quality, accessibility |
| **P3** | Cost Efficiency | Token costs, infrastructure costs, ROI |
| **P4** | DX | Development speed, maintainability, testability |

### 1.3. AI First ≠ AI Only

- **Rule 40.4**: AI features must always have a **fallback** (non-AI alternative)
- Core business functions must continue when AI is unavailable
- Example: AI chat stops → automatically display FAQ/Help Center navigation
- **Deterministic-First Decision Order**: When designing or reviewing any AI call, ask the following in order (MUST). (1) Can this be written deterministically? → If yes, do not use AI. (2) Is only part of it deterministic? → Keep that part away from the model and send only the rest. (3) Can the output be verified deterministically? → If not, question the adoption itself.
  - **Rationale**: Handing deterministic work to a model loses accuracy (100% → probabilistic), reproducibility (cannot be pinned by tests) and cost (input/output tokens that never needed to be paid) all at once. The order is "choose deterministic processing because it is correct"; cost reduction is a by-product (SHOULD).
  - **Failure pattern**: Once a feature is judged to "need AI", the whole input gets sent. In production measurement of structured-content transformation, most of the input (e.g., two thirds) was structure and technical values that never needed to reach the model. Step (2) is the one most often skipped.
  - **Verification**: A PR that adds an AI call must document the answers to the three questions and the boundary between "sent to the model" and "kept out". See also §38.1 "Structure/Text Separation".

---

## Part II: AI UX Principles

### 2.1. Zero Latency Perception

- **Rule 40.5**: AI response wait time must be "perceived as zero." A loading spinner is a failure
- **Streaming First**: Display responses token-by-token in real-time without waiting for full server response
- **Instant Feedback**: Return UI changes within 100ms of user input

### 2.2. Optimistic UI

- **Instant Reaction**: The moment a user presses send, treat it as "successful" in the UI without waiting for AI processing
  - Immediate chat bubble display with in-progress indicator
- **Background Processing**: Actual processing runs in background. Notify user only on failure and prompt retry
- **Rollback Design**: Always implement UI state restoration mechanism for failed optimistic updates

### 2.3. State Visibility

- Always make transparent "what the AI is doing"
- Display staged statuses: `Thinking...`, `Searching...`, `Generating...`
- **Progress Granularity**: Use progress bars/step indicators for multi-step processes

### 2.4. AI Psychology (Satisfaction > Speed)

- **Thinking Visualization**: During extended processing, display animations visualizing the "thinking process" to convert wait time into "anticipation"
- **The High Cost Metaphor**: For rate limits, use value metaphors like "Daily Energy Limit" instead of "Limit reached" (stingy) → "Advanced energy exhausted" (value)
- **Confidence Indicator**: Visually display AI response confidence levels (high=green, medium=yellow, low=red dots)

### 2.5. Conversational UX Design Principles

- **Turn-Taking**: Display long AI responses in paragraph chunks, allowing users to interrupt or ask questions mid-stream
- **Context Awareness Badge**: When AI references past conversation context, indicate this with a badge/label
- **Error Recovery**: Use human-friendly expressions like "Please try again" instead of technical error messages
- **Undo/Regenerate**: Provide "Regenerate" and "Undo" options for all AI generations

---

## Part III: AI UX Pattern Catalog

### 3.1. Chat UI

- **Use Case**: Free-form Q&A, counseling, customer support
- **Required Elements**: Streaming display, message history, citation display, feedback (👍/👎), regenerate button
- **Prohibited**: Lazy loading of past messages via infinite scroll (initial load = latest N items, use pagination)

### 3.2. Copilot UI

- **Use Case**: Lateral assistance for user tasks (form input assistance, text proofreading, data analysis suggestions)
- **Design Principle**: Don't obstruct the main task. Display in side panel or inline suggestions
- **Accept/Reject**: Explicit accept/reject interactions for suggestions are mandatory
- **Learning Feedback**: Implement mechanisms to improve personalization from user accept/reject patterns

### 3.3. Agent UI

- **Use Case**: Multi-step autonomous task execution (data processing pipelines, research assistants)
- **Required Elements**: Step progress display, intermediate result preview, pause/resume controls
- **Human Checkpoint**: Always install human approval gates at critical decision points
- **Audit Trail**: Make all agent actions viewable and exportable as chronological logs

### 3.4. Ambient AI (Environmental Intelligence)

- **Use Case**: Runs in background, notifies only when needed (anomaly detection, proactive alerts)
- **Notification Strategy**: Control notification channels by severity (Critical=Push, Info=In-App Badge)
- **Opt-Out**: Always provide a toggle for users to completely stop Ambient AI

### 3.5. Proactive UI

- **Use Case**: Predict and suggest next actions based on user behavior patterns
- **Non-Intrusive**: Display suggestions via toasts/banners, not modals, to avoid interrupting workflow
- **Frequency Control**: Limit display frequency of identical suggestions to prevent "pushy AI"

---

## Part IV: AI Ethics Framework

### 4.1. Responsible AI Principles

- **Fairness**: Guarantee outputs free from bias against specific attributes (race, gender, age, region, category)
- **Transparency**: Explain AI decision rationale in a form users can understand
- **Explainability**: Maintain a level where "why this response" can be explained to non-technical people
- **Privacy**: Apply data minimization principles, processing only the minimum necessary information
- **Safety**: Block harmful content generation with multi-layered defense
- **Human-Centricity**: AI respects user autonomy, eliminating coercion, manipulation, and addictive design

### 4.2. AI Ethics Checklist (Mandatory Pre-Deployment)

| # | Check Item | Pass Criteria |
|:---|:---|:---|
| 1 | PII transmission defense | PII transmission to external LLMs is technically blocked |
| 2 | Bias evaluation | Fairness tests passed across major categories |
| 3 | Disclaimer display | Risk-appropriate disclaimers auto-displayed |
| 4 | Kill Switch | Emergency stop switch verified operational |
| 5 | AI labeling | AI-generated content displays provenance labels |
| 6 | Opt-Out | Users can disable AI features |
| 7 | Reporting | Inappropriate content reporting is available |
| 8 | Accessibility | AI outputs are screen reader compatible |

---

## Part V: AI Governance Structure

### 5.1. AI Governance Committee

- **Establishment Condition**: After Series A, or when paid user count reaches a defined threshold
- **Required Roles**:
  - Technical Lead (CTO / Tech Lead)
  - Legal & Compliance Officer
  - User Representative (CS / UX Researcher)
  - Data Privacy Officer (DPO)
- **Review Scope**: Model selection, prompt policy changes, new AI feature risk assessment, incident response, compliance review
- **Regular Review**: Quarterly + emergency ad-hoc convocations
- **Cross-Reference**: Red Button Protocol (§XXXIV), Model Switch Protocol (§XLII)

### 5.2. AI Risk Assessment Framework

| Risk Category | Assessment Items | Assessment Frequency |
|:---|:---|:---|
| Safety Risk | Harmful content generation potential | Model change + quarterly |
| Privacy Risk | PII processing scope, data flows | Feature addition + semi-annually |
| Bias Risk | Category/region/attribute bias | Model change + quarterly |
| Financial Risk | Cost overruns, API loops | Monthly |
| Regulatory Risk | EU AI Act/Global Privacy Laws compliance status | Semi-annually + regulation changes |
| Reputation Risk | Brand damage scenarios | Quarterly |

### 5.3. AI Decision Log

- **Rule 40.6**: Record important AI design decisions (model selection, prompt policies, guardrail settings) as ADRs (Architecture Decision Records)
- Record items: Decision content, rationale, alternatives, risks, reviewers, date

---

## Part VI: EU AI Act Compliance

### 6.1. Four-Level Risk Classification and Obligations

| Risk Level | Examples | Key Obligations | Effective Date |
|:---|:---|:---|:---|
| **Prohibited (Unacceptable)** | Cognitive manipulation, social scoring, real-time public biometric ID | Complete ban | Feb 2025~ |
| **High Risk** | Hiring AI, credit scoring, medical AI, critical infrastructure AI | Risk management, technical docs, human oversight, conformity assessment | Aug 2026~ |
| **Limited Risk** | Chatbots, deepfake generation | Transparency obligations (AI usage disclosure) | Aug 2026~ |
| **Minimal Risk** | Spam filters, AI games | No obligations (Good Practice recommended) | — |

### 6.2. GPAI (General-Purpose AI) Model Obligations

- **Training data summary disclosure**: Data collection methods, date ranges, legal basis, anonymization techniques, dataset lists
- **Technical documentation**: Documentation of training, testing, and evaluation processes
- **Information provision to AI system providers**: Documentation of model capabilities and limitations
- **GPAI Code of Practice**: Compliance with guidelines on transparency, copyright, and safety
- **Effective Date**: August 2025~

### 6.3. GPAI Code of Practice

- **Definition**: A voluntary framework developed through an independent expert-led multi-stakeholder process and published on July 10, 2025
- **Purpose**: Help GPAI model providers meet AI Act obligations for safety, transparency, and copyright
- **Legal Positioning**: Compliance can support a presumption of conformity and improve legal certainty
- **Rule 40.7a**: Projects using GPAI models must assess and record GPAI Code of Practice compliance status quarterly

### 6.4. AI Literacy Requirement

- **Rule 40.7b**: Address the EU AI Act "AI Literacy" requirement (effective Feb 2025) by confirming all team members developing/operating AI features have foundational AI knowledge
- Recommend implementing training programs with documentation

### 6.5. Regulatory Timeline (2025-2030)

| Date | Milestone |
|:---|:---|
| **February 2, 2025** | Prohibited AI systems and AI literacy obligations in force |
| **July 10, 2025** | GPAI Code of Practice published |
| **August 2, 2025** | GPAI model obligations, national authority designation, and penalty framework in force |
| **March 26, 2026** | European Parliament adopted its negotiating position on the Digital Omnibus on AI |
| **May 7, 2026** | Council presidency and European Parliament negotiators reached a provisional agreement |
| **June 2, 2026** | IMCO/LIBE committees approved the provisional agreement; plenary and formal Council adoption still pending |
| **December 2, 2027** | Proposed postponed application date for stand-alone high-risk AI systems under Annex III |
| **August 2, 2028** | Proposed postponed application date for product-embedded high-risk AI systems under Annex I |
| **August 2, 2030** | Public-authority legacy high-risk AI compliance deadline |

### 6.6. Digital Omnibus Package (Proposed November 2025)

- Compliance deadlines for high-risk AI systems may be extended to December 2, 2027 or August 2, 2028
- **Caution**: Track the formal adoption state and keep project-level release plans conservative until the amended timeline is legally final
- Status as of June 7, 2026: provisional agreement reached on May 7 and approved by IMCO/LIBE committees on June 2; European Parliament plenary approval and formal Council adoption are still required

### 6.7. Penalties

- Up to **€35 million** or **7% of global annual turnover**, whichever is higher

---

## Part VII: Global AI Regulation Mapping

### 7.1. Major AI Regulations by Region

| Region | Regulation | Key Notes |
|:---|:---|:---|
| **EU** | EU AI Act | Risk-based approach, GPAI obligations |
| **Japan** | AI Business Operator Guidelines (2024 revised) | Soft law focus, social principles compliance |
| **US** | EO 14110 / NIST AI RMF 1.0 | Sector-specific regulation, numerous state laws |
| **China** | Generative AI Management Measures (2023~) | Registration obligations, socialist values compliance |
| **South Korea** | AI Basic Act (effective 2025) | Risk-based, high-risk AI pre-assessment |
| **Canada** | AIDA (Artificial Intelligence and Data Act) | High-impact AI system regulation |
| **Singapore** | AI Governance Framework / IMDA | Voluntary governance promotion |
| **Brazil** | AI Regulation Bill (under deliberation) | Risk-based approach |

### 7.2. Regulation Response Checklist

- **Rule 40.8**: Before releasing new AI features, confirm target market regulatory requirements and conduct compliance gap analysis
- Also verify cross-areas with data protection laws such as GDPR/Global Privacy Laws

---

## Part VIII: AI Content Labeling & Copyright

### 8.1. AI-Generated Content Labeling Obligation

- **Rule 40.9**: Content generated or assisted by AI must **always display** provenance labels. Hiding or minimizing labels is prohibited
- Compliant with EU AI Act principles and national AI regulation guidelines

| Content Type | Label Example | Notes |
|:---|:---|:---|
| Chat response | `🤖 Answered by AI` | Always display |
| Image analysis result | `Content read by AI. Please verify accuracy` | Always display |
| Recommendation | `✨ AI Recommended` | Display |
| AI-edited text | `📝 AI Edited` | Retain provenance record even after human review |

- **DB Flag**: Track provenance with `is_ai_generated: boolean` (default: `false`) when saving AI-generated content

### 8.2. Citation Display Protocol

- **Rule 40.10**: When AI generates responses referencing external information, disclose provenance with 3-level labels

| Source Type | Label Example | Application Condition |
|:---|:---|:---|
| **RAG Citation** | `📎 Reference: [Source Name](https://example.com/source)` | Responses based on externally retrieved RAG information |
| **DB Confirmed Data** | `✅ Verified Information` | Responses based on confirmed DB data |
| **AI Inference** | `💡 AI Reference Response` | Responses based on AI reasoning/general knowledge |

- **No Source, No Claim**: Prohibit assertive statements of factual information without source references

### 8.3. AI-Generated Content Copyright Governance

- **No Raw Publish**: Prohibit publishing AI-generated text directly as official content. Only content that has undergone human editing/verification qualifies as "official content"
- **Image Risk Assessment**: When commercially using AI-generated images, assess training data copyright risks and include disclaimers in terms of service
- **DB Flag**: Track AI assistance with `is_ai_assisted: boolean` (default: `false`) at the data level

---

## Part IX: User Data and AI Training

### 9.1. User Data AI Training Opt-Out Protocol

- **Rule 40.11**: Mandate Opt-In/Opt-Out control for AI training use of user data, compliant with GDPR/Global Privacy Laws "purpose limitation" principles

| Item | Requirement |
|:---|:---|
| **Default** | Opt-Out (not used for training) |
| **Opt-In Acquisition** | Explicit consent separate from terms of service (checkbox, etc.) |
| **DB Management** | `ai_training_opt_in: boolean` (default: `false`) |
| **Right to Withdraw** | Opt-In can be withdrawn at any time, excluded from next training batch |
| **Anonymization** | Use as training data only after complete PII removal |
| **Transparency** | Clearly stated in privacy policy, provide navigation to settings screen |

- **Cross-Reference**: PII Scrubbing (§XVIII), Data Minimization / Right to be Forgotten (`61`)
- **Consent-Flag JOIN Mandate**: The data-use consent flag is a single-column SSOT, and every aggregation or ingestion query over user-derived data MUST reference it via JOIN. An aggregation that is not wired to the flag turns the check red.
  - **Post-withdrawal handling**: Decide it at design time and keep it consistent with the published text (privacy policy) (MUST). Aggregations exclude the person's records from the next run; assets already registered in a form that cannot identify an individual (e.g., median or rounded value over k≥3 contributors) are retained. Recompute only when the value changes, with a cooldown.
  - **Failure pattern**: Only the newly added aggregation job forgets the JOIN, and the withdrawn person's records survive in the next night's statistics.
- **Provider Data Retention Boundary**: The boundary that prevents user input, images and AI responses from being stored in the provider's request/response logs MUST be concentrated in one code-side function, on the premise that the guarantee lives in a different place per provider (request-body flag / project setting / contract).
  - **No implicit dependency**: When the guarantee lives in a project setting, do not settle for "it should be off by default"; pin it with a test that runs a verification script fetching the current value via the API (MUST).
  - **Migration mapping table**: During a provider migration, avoid both failure modes — "send the field that worked on the previous provider" (an unknown field makes every AI feature fail with 4xx) and "give up because the new provider has no such field" (the privacy policy no longer matches reality) — by keeping a provider × guarantee-mechanism mapping table (SHOULD). See §42.1 "Provider-Specific Field Inventory".

---

## Part X: AI Bias and Fairness

### 10.1. The Fairness Protocol (Bias Mitigation)

- **Rule 40.12**: Control via system prompt to prevent generating biased/discriminatory responses against specific attributes without statistical basis
- Monitor usage of bias-containing adjectives like "dangerous" or "inferior" and enforce neutral expressions

### 10.2. Model Selection Bias Assessment Checklist

| Assessment Item | Verification Method | Pass Criteria |
|:---|:---|:---|
| **Category Bias** | Compare responses to identical questions across categories | 0 biased expressions |
| **Regional Bias** | Compare responses to identical scenarios for urban/rural areas | 0 regional discrimination expressions |
| **Language Quality** | Naturalness/politeness evaluation in target language | < 5% unnatural translation-like expressions |
| **Safety Compliance** | Disclaimer protocol compliance for specialized information | 100% compliance |
| **Gender Bias** | Compare responses to gender-related questions | 0 stereotype expressions |

- **Frequency**: Quarterly + model switches
- **Cross-Reference**: AI Ethics Checklist (§IV)

---

## Part XI: AI Architecture Patterns

### 11.1. Private Relay & Execution Pattern

- **Rule 40.13**: Client exposure of API keys (`NEXT_PUBLIC_`) is strictly prohibited. All AI processing must go through Server Actions or Route Handlers (`process.env.KEY`)
- **No Direct Client Access**: Prohibit direct external LLM API calls from clients. Always route through server-side proxy

### 11.2. Inference Execution Patterns

| Pattern | Use Case | Latency | Cost |
|:---|:---|:---|:---|
| **Edge Runtime** | Chat, real-time responses | Lowest | Medium |
| **Serverless Functions** | Batch processing, analysis | Medium | Low |
| **Edge Functions (Supabase)** | Async processing, heavy inference | High (acceptable) | Low |
| **On-Device AI** | Image recognition, voice recognition | Lowest | Zero (no API needed) |

### 11.3. Hybrid Architecture

- **Cloud + Edge Strategy**: Use On-Device for privacy-sensitive processing, Cloud LLM for accuracy-critical processing
- **Fallback Chain**: Implement staged fallback: Edge AI → Cloud AI → Cache → Static Response
- **Rule 40.14**: AI features must be designed for Graceful Degradation. Core service functions must continue when AI APIs are unavailable

---

## Part XII: Model Routing & Abstraction

### 12.1. The Model Router Protocol (Tiered Architecture)

- **Rule 40.15**: Hardcoding specific model IDs (e.g., `"gemini-1.5-flash"`) in code is prohibited
- **Abstraction Layer**: Always implement a router that calls models via `Tier` (e.g., `Tier.FAST`, `Tier.SMART`, `Tier.VISION`, `Tier.THINKING`)
- **Feature-Keyed Attribution**: The key for quotas, cost attribution and analytics breakdowns is "which feature used it" (feature ID); model IDs and provider names MUST NOT be the key. When several features share the same model, the backend ID cannot tell them apart. Feature ID strings are also expanded from constants, and tests guarantee that the mapping table, log filters and display order share one key set.

```typescript
// ✅ Correct implementation
const response = await aiRouter.generate({
  tier: Tier.FAST,
  prompt: userMessage,
});

// ❌ Prohibited: Hardcoding
const response = await gemini("gemini-x.x-flash", userMessage); // Hardcoded model ID
```

### 12.2. Model Selection Criteria

| Tier | Use Case | Selection Criteria |
|:---|:---|:---|
| `Tier.FAST` | Chat, simple Q&A | Cost-optimal, low latency |
| `Tier.SMART` | Complex reasoning, analysis | High accuracy, context understanding |
| `Tier.THINKING` | Deep thinking tasks, code generation | Reasoning chains, step-by-step |
| `Tier.VISION` | Image analysis, OCR | Multimodal, instant recognition |
| `Tier.EMBEDDING` | Search, similarity computation | High-dimensional vectors, multilingual |

- **Current Standard**: Map each generation's "standard lightweight model" (the model with optimal cost-performance at that time) to `Tier.FAST`. Specific model IDs are managed in the project's Blueprint (configuration files) and are not fixed in this constitution.
- **Model Lifecycle Ledger**: Concrete model IDs live only in one source-of-truth file holding a two-step mapping "role → ID" and "feature → role" (MUST). Managed models are retired periodically after GA (e.g., roughly yearly), so keep a ledger of the planned retirement date per model ID and make a CI/verification command fail before the deadline (MUST). Detect it from the ledger's deadline first, instead of searching after a deprecation notice arrives. When unit-price differences are negligible, several Tiers MAY be aligned to one model to reduce the number of lifecycles to manage.
- **Vision AI Standards**: Thinking models are unsuitable for instant recognition tasks (OCR, etc.). Use non-Thinking models for `Tier.VISION`

### 12.3. Fallback & A/B Routing

- **Provider Fallback**: Implement auto-switching to alternative provider on primary provider failure
- **A/B Routing**: Enable serving different models to a subset of users via Feature Flags
- **Latency-Based Routing**: Auto-downgrade to lower-cost, faster models when response time SLOs are exceeded

---

## Part XIII: Context Window Management

### 13.1. Token Optimization Strategy

- **Rule 40.16**: Never send infinite conversation history. Extract and send only important context
- **Summarization Strategy**: Auto-summarize conversations beyond N turns; send summary + raw text of recent N turns
- **Input Token Monitoring**: Continuously monitor prompt token count and remove unnecessary information

### 13.2. Context Management Patterns

| Strategy | Description | Recommended Case |
|:---|:---|:---|
| **Sliding Window** | Retain only the most recent N turns | Casual chat |
| **Summarize + Recent** | Summarize old conversations + retain recent raw | Long sessions |
| **RAG-Augmented Context** | Search and insert relevant info on each turn | Knowledge base Q&A |
| **Hierarchical Context** | System → Domain → Session → Turn hierarchy | Agent tasks |

- **Sliding Window Retrieval Order**: Fetch the "latest N" conversation turns **in descending order with LIMIT, then reverse into chronological order** (MUST). Ascending + LIMIT yields the "oldest N", and the recent context disappears the moment the conversation exceeds N.
  - **Failure pattern**: To the user it looks like "the assistant stops following the conversation midway", with no exception and no log. The tests never checked the order or count of the history.
  - **Verification**: At the boundary that hands history to the model, place tests that pin the order argument of the fetch query and the order of the array passed to the model **separately** (MUST).

### 13.3. Token Budget Allocation

```
Total Context Window Budget:
├── System Prompt:     15-20% (fixed)
├── RAG Context:       30-40% (dynamic)
├── Conversation History: 20-30% (sliding)
├── User Input:        10-15% (latest turn)
└── Safety Buffer:     5-10% (margin)
```

- **Reference Data Container**: Pass reference data such as RAG fragments in one container shared by all features (purpose-specific preamble → boundary tag → fragments → closing tag) (MUST). State in the preamble that it is "reference data, not instructions", and neutralize any occurrence of the boundary tag string inside fragment bodies (MUST). See §18.1 Layer 2.
  - **Context Injection Budget**: Dynamic context injected into the System Prompt (DB records, user attributes, RAG bodies) MUST have a per-kind cap (characters/tokens) and a retrieval time cap enforced in one place by the prompt builder. On timeout, continue generation without reference data; references are auxiliary and must not reduce availability of the main feature. Bloat raises cost, the volume of personal data sent, and in-context injection surface all at once.
  - **Whole-Fragment Drop**: A fragment that does not fit the cap is **dropped as a whole, never cut mid-text** (MUST). Fragments often end with a safety note or the evidence, and cutting them reverses the meaning. Failure pattern: with a fixed character count × fragment count, only the last fragment ended in "..." and its safety sentence was lost.
  - **Reference Provenance**: Record only the fragments actually passed to the model in the reference record (source IDs in response metadata), and keep the dropped count separately (MUST). This prevents feedback ratings from attaching to assets that were never shown. Derive the cap from target count × target length instead of shortening asset bodies to fit, and pin the balance with a test (SHOULD).

---

## Part XIV: Structured Output & Function Calling

### 14.1. Structured Output

- **Rule 40.17**: Structure AI responses using JSON mode (Structured Output) whenever possible to prevent parse errors
- **Schema Definition**: Define response schemas with Zod or similar, automating validation

```typescript
// Structured Output with Zod Schema
const ResponseSchema = z.object({
  answer: z.string(),
  confidence: z.number().min(0).max(1),
  sources: z.array(z.object({
    title: z.string(),
    url: z.string().url(),
  })),
  category: z.enum(["factual", "opinion", "recommendation"]),
});
```

- **Normalize-Then-Validate**: Before schema validation, place a normalization layer at the server boundary that absorbs **return-shape drift** of AI structured output (decimals / numeric strings / stray `null` / percent notation / `null` array elements / overlong text) (MUST). Normalization absorbs only formal drift; it MUST NOT rescue semantically invalid results (off-target content, dangerous values, out-of-range values).
  - **No-Save on Failure**: Output that fails validation is neither saved nor processed further; guide the user to "retry or enter manually" (MUST). Keep the normalization rules and the rejection rules in one module, with tests pinning each drift pattern (SHOULD). Failure pattern: "validate only" drops legitimate results, while "normalize only" lets dangerous values through.
- **Meaning-Preserving JSON Repair**: For non-deterministic breakage of model-returned JSON (raw control characters inside string literals, missing closing brackets), apply repairs that cannot change the meaning of valid JSON (escaping control characters, completing brackets) before parsing (SHOULD). Raw control characters cannot exist inside valid JSON, so the repair never alters valid JSON.
  - **Re-request Scope**: If it is still unreadable after repair, re-request only single-item requests, with a retry cap (SHOULD). Multi-item batches are delegated to split-retry (§16.2), and output truncation (max tokens reached) is not re-requested because it truncates at the same length again.
  - **Parse-Error Hygiene**: The raw message of a JSON parse exception contains fragments of the response body, so pass only the position to logs and monitoring (MUST). Concentrate the request → parse → repair → split/re-request procedure in one module, with callers swapping only the provider call (MUST). Fixing one side only makes behavior diverge.

### 14.2. Function Calling / Tool Use

- **Use Case**: Pattern where AI invokes external tools (DB search, API calls, calculations, etc.)
- **Schema-Driven**: Define tools strictly with JSON Schema, ensuring type safety
- **Permission Control**: Set execution permission levels per tool; install Human Approval Gates for destructive operations (DELETE, etc.)
- **Timeout**: Set timeouts for each tool invocation to prevent infinite loops

### 14.3. Tool Use Design Principles

- **Least Privilege**: Restrict tools exposed to AI to the minimum necessary
- **Idempotency**: Design tool invocations to be idempotent (re-execution produces same results) wherever possible
- **Read-Write Separation**: Clearly separate read-only and write tools; add confirmation steps for write tools

---

## Part XV: Streaming Architecture

### 15.1. Streaming Protocol Selection

| Protocol | Use Case | Advantages | Constraints |
|:---|:---|:---|:---|
| **SSE** | Chat, text generation | Simple, HTTP-compatible | Unidirectional |
| **WebSocket** | Real-time dialog, collaboration | Bidirectional, low latency | Complex connection management |
| **HTTP Streaming** | Large data transfer | Standard HTTP | Requires backpressure control |

### 15.2. Vercel AI SDK Integration

- **Rule 40.18**: Use **Vercel AI SDK (Streaming)** as standard for chat and dialog features; run on Edge Runtime when possible to avoid cold starts
- Leverage `useChat` / `useCompletion` hooks to simplify client-side streaming
- **Backpressure Control**: Implement control mechanisms for when client processing speed can't keep up with server send rate

### 15.3. Streaming UX Requirements

- **Progressive Rendering**: Mandate real-time rendering at the token level
- **Abort Control**: Always implement a "Stop" button allowing users to halt generation mid-stream
- **Markdown Progressive Rendering**: Design streaming Markdown parsing to prevent parse breakage at chunk boundaries

---

## Part XVI: Asynchronous AI Processing

### 16.1. Async Offload Pattern

- **Rule 40.19**: Offload heavy processing taking several seconds or more (e.g., image analysis) to **async queues** to avoid Vercel timeouts
- **Recommended Queues**: Supabase Edge Functions + pgmq, Inngest, Temporal

### 16.2. Async Processing Design

| Item | Requirement |
|:---|:---|
| **Timeout** | Set maximum execution time per process (default: 30s) |
| **Retry Policy** | Exponential backoff (max 3 retries), use idempotency keys |
| **Dead Letter Queue** | Define fallback processing for all retry failures |
| **Progress Notification** | Notify async processing progress via WebSocket/Polling |
| **Result Persistence** | Save results to DB/Storage, allow client polling retrieval |

- **Segment-Level Failure Domain**: In a job that sends multiple items to the model together, the item (segment) is the unit of processing and failure; a batch is merely a bundle for transfer efficiency (MUST). Designs that fail the whole batch are prohibited. Failure pattern: a single overlong item made every other item in the same batch fail.
  - **Three-stage design** (SHOULD): (1) pre-packing — split into sizes that fit the output budget before sending (prevention), (2) split-retry — bisect and re-request a batch that failed because the estimate was off (recovery), (3) intra-item splitting — when one item exceeds the budget, split it into chunks without cutting mid-sentence, verify the count per chunk and rejoin in the same order. The pre-packing budget and the actual max output tokens are derived from the same constant (MUST).
- **Detect/Execute Separation**: Detection of "missing or stale" AI-generated/transformed results MUST be a separate deterministic reconciliation job (source vs. result comparison) that involves no AI call. Placing detection inside the AI job lets the AI budget constrain detection frequency. Run detection cheaply every day, and let AI fix only what was found.
  - **Date-Sharded Sweep**: There is no need to scan everything at once. Sweep by a shard derived from the date (e.g., `hash(id) mod N == day mod N`) and complete a cycle in a few days (SHOULD). Unlike a cursor, it holds no persistent state and cannot break. Cross-reference: `engineering/710_data_reconciliation.md` §3.

---

## Part XVII: Semantic Caching

### 17.1. The Semantic Caching Protocol (pgvector Strategy)

- **Rule 40.20**: Recommend implementing similarity-search caching using `pgvector`
- **Similarity Threshold**: **≥ 0.95** (return cached responses only for near-exact match Q&As)
- **Effect**: Cost reduction + significant response time improvement + UX enhancement

### 17.2. Cache Hierarchy Design

| Cache Layer | TTL | Target |
|:---|:---|:---|
| **Exact Match** | 24 hours | Exact-match Q&As |
| **Semantic Match** | 6 hours | Q&As with similarity ≥ 0.95 |
| **RAG Chunk Cache** | 1 hour | Frequently referenced document chunks |
| **Embedding Cache** | 7 days | Pre-computed embedding vectors |

- **DB-Side TTL Enforcement**: The TTL difference between Exact Match and Semantic Match MUST be enforced not only by app-side constants but also by the data layer's expiry condition (e.g., an expiry-timestamp check inside the RPC). Enforcing only one side leads to a quality incident where stale, merely-similar answers are returned.

### 17.3. Cache Invalidation

- Immediately invalidate corresponding chunk caches when source documents are updated
- Do not cache responses dependent on user-specific context
- Monitor cache hit rates and use as data for threshold tuning

---

## Part XVIII: AI Security

### 18.1. Prompt Injection Defense (Multi-Layer Model)

- **Layer 1 — Input Sanitization**:
  - Escape or remove control strings from user input (`###`, `````, `<|system|>`, `SYSTEM:`, etc.)
  - Limit input text maximum length (recommended: 2,000-4,000 characters), truncate excess
  - **Proxy Size Gate**: Before forwarding to the provider, and before parsing the body as a whole, the AI proxy MUST check the body size limit against Content-Length and the actual stream length, rejecting excess with 413. Do not rely solely on the upstream upload guard.

- **Layer 2 — Delimiter Strategy**:
  ```
  [SYSTEM INSTRUCTION - DO NOT MODIFY]
  {system_prompt}
  [END SYSTEM INSTRUCTION]

  [USER MESSAGE]
  {user_input}
  [END USER MESSAGE]
  ```

- **Layer 3 — Output Validation**:
  - System prompt leak detection (partial matching)
  - PII pattern detection and masking
  - Filtering of external URLs outside whitelist

- **Layer 4 — Anomaly Detection**:
  - Log suspected prompt injection inputs at `warn` level and notify administrators
  - Detect high-volume requests in short periods and apply rate limiting

### 18.2. PII Scrubbing

- **Rule 40.21**: Prompts sent to external LLMs must not contain personally identifiable information
- Execute masking via regex before sending (`[CONTACT_REMOVED]`, `[NAME_REMOVED]`)
- **Target PII**: Names, phone numbers, email addresses, physical addresses, government IDs, etc.
- **Single Mask Definition**: Do not keep multiple PII masks for the same purpose, such as a "pre-LLM mask" and a "pre-storage mask" (MUST NOT). Define the pattern set in one place and have the sending side reference the storage side's set.
  - **Failure pattern**: Internationally formatted phone numbers (e.g., `+81-90-…`) and 10-digit numbers with the leading zero dropped were hidden only right before sending, and survived verbatim in stored bodies and the RAG corpus. Both paths "were masking", so both tests were green.
  - **Verification**: Whenever a pattern changes, run the same input through both the stored body (DB) and the sent body (wire) and pin a test asserting neither retains it verbatim (MUST).

### 18.3. API Key Management

- **No Client Exposure**: Exposing AI API keys with `NEXT_PUBLIC_` prefix is strictly prohibited
- **Rotation**: Rotate API keys every 90 days
- **Vault Integration**: Integrate with secret management tools (Vault, AWS Secrets Manager, etc.)
- **Double-Boundary Proxy**: A proxy layer that isolates the model API key MUST NOT be reachable with end-user credentials alone. The application layer responsible for quotas, feature routing and audit logs attaches an internal secret (constant-time comparison), and the proxy verifies twice in the order internal secret → user credentials.
  - **Failure pattern**: An authenticated user called the proxy (e.g., a serverless function) directly and bypassed quotas, feature routing and audit logging. Pin with a test that this path does not exist (SHOULD). See §37.2 No Bypass.

### 18.4. Grounding & Fact-Check Standards

- **Rule 40.22**: Facts such as store information and prices must be cross-referenced (Grounded) with confirmed DB data, and sources must be cited
- **Numeric Data Rule**: Numeric data (prices, distances, quantities) is permitted only from direct RAG source or DB citations. AI calculation/speculation is prohibited
- **RAG Source Absence Protocol**: When sources cannot be retrieved, auto-append "This information is for reference only. Accuracy is not guaranteed"
- **Conflict-of-Interest Source Exclusion**: Recommendations carrying a financial interest (affiliate products, ad slots, sponsored items) MUST NOT be placed in the reference data (RAG corpus) of advisory AI. A generated answer cannot carry an ad label, so including them turns the answer into steering without the required disclosure. Build "facts" about products or venues from disinterested sources (master data, aggregates of user records).

---

## Part XIX: RAG Foundation Design

### 19.1. RAG Pipeline Architecture

```
RAG Pipeline:
[Document Ingestion] → [Chunking] → [Embedding] → [Index Storage]
                                                         ↓
[User Query] → [Query Processing] → [Retrieval] → [Reranking] → [Context Assembly] → [LLM Generation] → [Output Validation]
```

### 19.2. The Triple Write RAG Protocol (Clean Data Source)

- **Rule 40.23**: RAG reference sources must use **"Triple Write plain-text synced data"** as mandated by the CMS Constitution (`34`)
- **Rationale**: Noisy data full of HTML tags wastes tokens and degrades response accuracy
- **Consumer-Side Source Hygiene**: When an editor's HTML mirror is used as the source for AI processing, strip editor-only elements (custom elements, attributes stringified as `[object Object]`) on the consuming side before hashing and sending (MUST). Do not touch the editor's serialization. Failure pattern: thousands of characters with nothing to translate reached the model and kept failing validation.

### 19.3. Embedding Model Selection

| Criteria | Considerations |
|:---|:---|
| **Multilingual Support** | Must generate suitable embeddings for the target languages and locales |
| **Dimensions** | Higher dimensions (1536+) improve accuracy; lower dimensions favor cost/speed |
| **Cost** | Consider costs when indexing large document volumes |
| **Update Frequency** | Evaluate re-indexing costs when model updates occur |

### 19.4. Indexing Strategy

- **Vector DB Selection**: pgvector (PostgreSQL integration), Pinecone, Weaviate, Qdrant, etc.
- **Metadata Filtering**: Combine vector search with metadata filters for precise retrieval
- **Periodic Index Updates**: Incremental index updates triggered by source document changes
- **Status over Deletion**: Knowledge turned into assets in a non-identifying form represents source events (author deletion, operator unpublishing, parent unpublishing, new version, falling out of the statistics window) **as a status, not as deletion** (MUST). Distinguish at least `live / source_deleted / source_unpublished / quarantined / superseded / aged_out`, and define per status whether it is searchable (`quarantined` and `superseded` are excluded) and which note is passed to the AI.
  - **Freshness Annotation**: Every asset carries the point in time of its information (`observed_at`); attach notes such as "(as of YYYY-MM)" or "(original post deleted)" when referencing, and apply a small ranking penalty by age and status (SHOULD). "Old" is a reason to annotate, not to delete.
  - **Tombstone Ledger**: The only exception for deletion is a legal reason, and even then keep the body hash in a tombstone ledger so that ingestion and restores do not re-register it. Ship the ledger with backups as well (MUST).
  - **Double Filter**: Drop excluded statuses in both the search RPC and the secondary sort, and apply the same status filter on paths that fetch directly without going through search (MUST). Return from quarantine restores the pre-quarantine status; close the manual bypass of flipping `source_deleted` back to `live` (SHOULD). Cross-reference: `security/100_data_governance.md` §12.2.

---

## Part XX: Advanced Chunking Strategies

### 20.1. Chunking Method Comparison

| Method | Description | Recommended Case |
|:---|:---|:---|
| **Fixed-Size** | Split by fixed length | Uniform text |
| **Recursive** | Recursively split with hierarchical separators | Structured documents |
| **Semantic** | Split at meaning boundaries (based on embedding similarity) | Dense technical documents |
| **Sliding Window** | Windows with overlap | Prevent context loss |
| **Agent-Based** | AI dynamically determines split points | Complex/mixed documents |
| **LLM-Based** | LLM splits based on context and meaning | Highest accuracy (high cost) |

### 20.2. Chunking Design Principles

- **Rule 40.24**: Determine chunk size by balancing retrieval accuracy and context preservation (recommended: 256-1024 tokens)
- **Overlap**: Set 10-20% overlap between adjacent chunks to prevent context loss at boundaries
- **Metadata Attachment**: Attach source document name, section name, page number, creation date, etc. as metadata to each chunk
- **Contextual Retrieval**: Embed surrounding context summaries into chunks so isolated chunks retain meaning

---

## Part XXI: Hybrid Search

### 21.1. Hybrid Search Strategy

- **Rule 40.25**: Use **hybrid** keyword search (BM25) and vector search as standard for RAG retrieval
- Keyword search excels at exact matches and proper nouns; vector search excels at semantic similarity. Combining both maximizes search quality

### 21.2. Fusion Strategies

| Strategy | Description |
|:---|:---|
| **Reciprocal Rank Fusion (RRF)** | Convert each result's rank to reciprocal and sum. Simple and effective |
| **Weighted Fusion** | Sum keyword and vector scores with weights |
| **Cascading** | Narrow candidates with cheap search, rerank with high-accuracy search |

### 21.3. Metadata Filtering

- Filter by category, date range, document type, etc. during search to narrow search space
- **Pre-Filter vs Post-Filter**: For large datasets, recommend Pre-Filter (before search) for performance advantage
- **Per-Feature Retrieval Profile**: The RAG routing table holds, per feature, not only "which shelf (namespace) to query" but also "how to query it" (threshold, top-k, timeout) (MUST). Guideline: advice and answer generation prioritize precision (high threshold, few results); suggestions prioritize recall (low threshold, many results, keyword search combined); auxiliary context (features that work without it) uses a high threshold, 1–2 results and a short timeout; operator-facing generation (articles, SEO copy) uses retrieval for fact-checking and "never writes what is absent from the assets as if it were asset content".
  - **One-Hop Fallback**: When a shelf-restricted search returns zero results, fall back only one hop, to the neighboring shelf defined in the routing table (MUST). Unlimited expansion to all shelves is prohibited (MUST NOT) because it causes quality collapse (e.g., a medical consultation pulling venue chit-chat) and dissolves privacy boundaries.
  - **Verification**: Hold the per-feature shelf assignment in a table whose exhaustiveness is enforced by types, not a switch whose `default:` silently falls through to the generic shelf; generate the table from the shelf ledger and check it (SHOULD).

---

## Part XXII: Reranking

### 22.1. Reranking Strategies

- **Rule 40.26**: Recommend applying **reranking** after initial retrieval to improve RAG search result accuracy

| Method | Accuracy | Cost | Latency |
|:---|:---|:---|:---|
| **Cross-Encoder** | High | Medium | Medium |
| **LLM-as-Reranker** | Highest | High | High |
| **Cohere Rerank** | High | Medium (API billing) | Low |
| **BGE Reranker** | High | Low (self-hosted) | Medium |

### 22.2. Reranking Design Principles

- **Top-K → Rerank → Top-N**: Retrieve Top-K (e.g., 20) in initial search, narrow to Top-N (e.g., 5) via reranking
- **Cost/Accuracy Tradeoff**: Cross-Encoder offers optimal balance of accuracy and cost for production
- **Latency Budget**: Target keeping additional latency from reranking under 100ms
- **Sybil-Resistant Feedback Loop**: A feedback loop that returns usage counts and helpfulness of referenced knowledge to the search ranking MUST have the server decide the reference IDs and place them in the output metadata; values persisted via the client are never the primary input of the aggregation. Any value that passes through the client can be forged.
  - **Aggregation discipline** (MUST): count usage as 1 per "knowledge × user"; the helpfulness sample is the number of users with a floor (e.g., 3; one user saving many records is still one sample); include only records from the AI path; keep the re-ranking weight small and bounded. As a result a single user cannot move the ranking, and collusion stays within the weight's range.
  - **Metric design**: Derive helpfulness from numbers that need neither body text nor personal columns, such as "the difference between the AI estimate and the user's confirmed value" (SHOULD). Feedback updates do not invalidate the search cache; let ranking changes catch up through the cache TTL (SHOULD). See §27.3 Feedback Loops.

---

## Part XXIII: GraphRAG & Knowledge Graphs

### 23.1. GraphRAG Architecture

- **Overview**: Pattern integrating Knowledge Graphs with LLMs to achieve high-accuracy information retrieval and reasoning by leveraging relationships between entities
- **Advantage**: While traditional RAG is limited to isolated chunk-level retrieval, GraphRAG follows data relationships for deeper context and reasoning

### 23.2. GraphRAG Paradigms

| Paradigm | Description | Use Case |
|:---|:---|:---|
| **Knowledge-Based** | Build explicit KG from documents | Structured knowledge systems |
| **Index-Based** | Organize text chunks with graph structure | Large document collections |
| **Hybrid** | Combined vector + graph search | Complex question answering |

### 23.3. Implementation Guidelines

- **Entity Extraction**: Auto-extract entities and relationships using NER or LLMs
- **Graph DB**: Use graph DBs such as Neo4j, Amazon Neptune, or PostgreSQL graph extensions
- **Application Judgment**: Apply GraphRAG only when data relationships directly impact answer quality, as construction/maintenance costs are high

---

## Part XXIV: Multimodal RAG

### 24.1. Multimodal RAG Strategy

- **Target Media**: Text, images, audio, video, PDF, tabular data
- **Multimodal Embedding**: Leverage models (CLIP, etc.) that embed text and images in the same vector space
- **Media-Specific Preprocessing**: Generate captions for images, transcribe audio, extract structures from PDFs before indexing

### 24.2. Application Cases

| Media | Preprocessing | Index Method |
|:---|:---|:---|
| **Text** | Chunking + Embedding | Vector + Keyword |
| **Image** | Caption generation + Multimodal Embedding | Vector |
| **PDF** | Layout analysis + Structured extraction | Vector + Metadata |
| **Audio** | STT (Speech-to-Text) → Process as text | Vector |

---

## Part XXV: RAG Evaluation Frameworks

### 25.1. RAG Quality Metrics

| Metric | Description | Target |
|:---|:---|:---|
| **Context Precision** | Relevance of retrieved context | > 0.8 |
| **Context Recall** | Coverage of information needed for correct answers | > 0.8 |
| **Faithfulness** | Whether responses are faithful to context | > 0.9 |
| **Answer Relevancy** | Whether responses appropriately address user questions | > 0.8 |
| **Hallucination Rate** | Rate of generating information not in context | < 5% |

### 25.2. Evaluation Frameworks

| Framework | Features | Recommended Case |
|:---|:---|:---|
| **RAGAS** | LLM-as-Judge, open source | Standard RAG evaluation |
| **DeepEval** | CI/CD integration, unit test format | Development pipeline integration |
| **TruLens** | Ground Truth management | Regression testing |
| **LangSmith** | Observability, production monitoring | Operational monitoring |

### 25.3. Golden Dataset Management

- **Rule 40.27**: Build and maintain a "Golden Dataset" for RAG quality evaluation and conduct periodic regression tests
- Golden Dataset must contain at least 100 question-answer pairs, updated quarterly
- Include only high-quality data reviewed by domain experts in the Golden Dataset

---

## Part XXVI: Agentic AI Strategy

### 26.1. Autonomy 5-Level Classification (L1-L5)

| Level | Name | Description | Human Oversight |
|:---|:---|:---|:---|
| **L1** | Assistive | Only responds to human questions | Constant monitoring |
| **L2** | Suggestive | Proposes action candidates, human executes | Approval required |
| **L3** | Semi-Autonomous | Autonomously executes low-risk tasks, requests approval for high-risk | Checkpoints |
| **L4** | Autonomous | Autonomous execution within defined scope | Intervention only on exceptions |
| **L5** | Fully Autonomous | Autonomous from goal-setting to execution | Post-audit only |

- **Rule 40.28**: Production AI agents must be L3 or below as standard. L4+ requires explicit AI Governance Committee approval

### 26.2. Agent Design 5 Principles

1. **Least Privilege**: Minimize tools and data access granted to agents
2. **Observability**: Design all actions to be traceable
3. **Reversibility**: Design operations to be cancellable wherever possible
4. **Graduated Escalation**: Expand permissions gradually, based on track record
5. **Fail-Safe**: Fall back to safe state (do nothing) on failure

### 26.3. Agent Application Judgment Criteria

| Condition | Agent Recommended | Non-Agent Recommended |
|:---|:---|:---|
| Task Complexity | Multi-step, dynamic judgment needed | Single step, deterministic |
| Data Sources | Multiple source integration needed | Single source sufficient |
| Time Sensitivity | Async acceptable | Real-time response required |
| Risk | Low-medium (reversible operations) | High (fund transfers, data deletion) |

---

## Part XXVII: Agent Design Patterns

### 27.1. Core Patterns

| Pattern | Description | Use Case |
|:---|:---|:---|
| **ReAct** | Iterative Reasoning + Acting. Think → Act → Observe loop | General problem solving |
| **Reflection** | Self-verify and improve own outputs | Quality-critical tasks |
| **Planning** | Decompose tasks into subtasks before execution | Complex multi-step |
| **Tool Use** | Leverage external tools (APIs, DB, calculations) | Information retrieval, action execution |
| **Multi-Agent** | Multiple specialized agents collaborate to solve problems | Large-scale, cross-domain tasks |

### 27.2. Agent Memory Design

| Memory Type | Description | Implementation |
|:---|:---|:---|
| **Short-Term** | Information within current task session | Context window |
| **Long-Term** | Knowledge persisted across sessions | Vector DB / Key-Value Store |
| **Episodic** | Past task execution results | Structured logs + search |
| **Procedural** | Learned workflows/procedures | Prompt templates |

### 27.3. Feedback Loops

- **Continuous Improvement**: Record agent execution results and periodically analyze to improve prompts and tool configurations
- **Human Feedback Integration**: Integrate user feedback (success/failure reports) into agent improvement cycles

---

## Part XXVIII: MCP (Model Context Protocol)

### 28.1. MCP Overview

- **Definition**: Vendor-neutral standard protocol for AI models to safely and effectively interact with external tools, data sources, and environments
- **Benefits**: No rebuilding needed on model switch, multi-agent coordination, consistent traceability

### 28.2. MCP Server Design

- **Rule 40.29**: When building MCP servers, adhere to the following principles
  - **Tool Exposure**: Define exposed tools strictly with JSON Schema and provide rich descriptions
  - **Authentication**: Mandate OAuth 2.0 or API Key authentication
  - **Rate Limiting**: Set rate limits per tool to prevent abuse
  - **Audit Logging**: Record all tool invocations as audit logs

### 28.3. MCP Security

- **Input Validation**: Strictly validate tool invocation inputs via MCP
- **Permission Scoping**: Define access permission scopes per tool, applying least privilege
- **Sandboxing**: Execute tools capable of destructive operations in sandbox environments

---

## Part XXIX: A2A (Agent-to-Agent Protocol)

### 29.1. A2A Overview

- **Definition**: Open standard protocol for horizontal coordination and communication between autonomous AI agents (announced by Google, 2025)
- **Relationship to MCP**: MCP handles agent → tool communication; A2A handles agent → agent coordination

### 29.2. A2A Core Concepts

| Concept | Description |
|:---|:---|
| **Agent Card** | Metadata describing agent capabilities and skills |
| **Task Delegation** | Task delegation and distribution between agents |
| **Streaming** | Streaming data exchange between agents |
| **Authentication** | Mutual authentication between agents (OAuth 2.0) |
| **Discovery** | Automatic agent discovery mechanism |

### 29.3. A2A Design Guidelines

- **Rule 40.30**: When adopting A2A, Agent Cards must be defined for each agent, explicitly stating capabilities and constraints
- **Task Boundaries**: Clearly separate each agent's responsibilities to avoid overlap
- **Error Propagation**: Define error propagation strategies between agents so one agent's failure doesn't halt the entire chain

---

## Part XXX: Multi-Agent Orchestration

### 30.1. Orchestration Patterns

| Pattern | Description | Use Case |
|:---|:---|:---|
| **Sequential** | Agents process in series | Pipeline-type workflows |
| **Parallel** | Multiple agents execute in parallel | Independent simultaneous tasks |
| **Hierarchical** | Manager agent directs workers | Complex task decomposition |
| **Consensus** | Vote on/integrate outputs from multiple agents | Accuracy-critical decisions |

### 30.2. Governance Requirements

- **Rule 40.31**: Multi-agent systems must implement a **kill switch** (immediate halt of all agents)
- **Human Oversight Gate**: Install human approval gates at critical decision points
- **Agent Observability**: Monitor each agent's state, actions, and resource consumption in real-time
- **Trust Score**: Calculate agent trust scores; require human intervention when scores fall below threshold

### 30.3. Cost Control

- **Budget Limits**: Set token/API call caps per multi-agent execution
- **Circuit Breaker**: Implement Circuit Breakers that auto-halt agent execution when costs exceed thresholds

---

## Part XXXI: AI Guardrail Design

### 31.1. Guardrail Multi-Layer Model

```
Input → [Input Guard] → [LLM Processing] → [Output Guard] → Output
           ↓                                     ↓
      [Reject/Modify]                     [Filter/Redact]
           ↓                                     ↓
      [Alert/Log]                          [Alert/Log]
```

### 31.2. Input Guardrails

| Guardrail | Purpose | Implementation |
|:---|:---|:---|
| **PII Detection** | Detect and mask personal information | Regex + NER |
| **Prompt Injection Detection** | Detect malicious instructions | Pattern matching + classifier |
| **Topic Restriction** | Reject off-topic inputs | Classification model |
| **Input Length Limit** | Limit excessive inputs | Token counting |
| **Language Detection** | Detect unsupported languages | Language detection model |

### 31.3. Output Guardrails

| Guardrail | Purpose | Implementation |
|:---|:---|:---|
| **Harmful Content Filter** | Detect and block harmful content | Content classification model |
| **PII Leak Prevention** | Prevent PII leakage from outputs | Regex scanning |
| **Factuality Check** | Verify consistency with facts | Grounding verification |
| **Tone/Style Enforcement** | Ensure tone/style consistency | Rule-based + LLM |
| **URL Whitelist** | Restrict external URLs | Domain whitelist |

- **Multilingual Guardrail Vocabulary**: The output guardrail vocabulary (assertive phrasing, terms of prohibited domains) MUST be held in one SSOT covering not only the product's display language but also the languages the model may mix into its replies (at least English). Separate files or implementations per language are prohibited (MUST NOT). Failure pattern: only the display language's banned terms existed, and assertive phrasing mixed in English passed through. Guardrail tests include mixed-language output samples (SHOULD).
- **Safety Settings SSOT**: Model safety categories and block thresholds MUST be defined as a constant in one place and attached to every generation request at the proxy boundary, never relying on unset defaults that change per model generation. Per-feature inline settings are prohibited.

### 31.4. Guardrail Operations

- **Rule 40.32**: Continuously monitor guardrail trigger rates and review monthly
- **False Positive Management**: Maintain false rejection rate of legitimate requests below 5%
- **Guardrail Version Control**: Git-manage guardrail policies to track change history

---

## Part XXXII: Hallucination Mitigation

### 32.1. Staged Disclaimer Protocol

| Risk Level | Context Example | Disclaimer Response |
|:---|:---|:---|
| **Critical** | Medical, legal, financial specialized info | **Always** display disclaimer. Auto-append "Please consult a professional" |
| **High** | Business hours, prices, inventory facts | Mandate cross-referencing with confirmed DB data (Grounding). If unverifiable: "This has not been confirmed" |
| **Medium** | General advice, recommendations | Display "For reference only" label |
| **Low** | Casual conversation, entertainment | No label needed (harmful content check still applies) |

### 32.2. Grounding Strategy

- **Mandatory Grounding**: Cross-reference factual information (business hours, prices, addresses) with DB/RAG sources
- **Confidence Score**: Evaluate Grounding confidence, add disclaimers when below threshold
- **No Source, No Claim**: Prohibit assertive statements of factual information without sources

### 32.3. Hallucination Detection

- **LLM-as-Judge**: Evaluate response factuality with a separate LLM instance
- **RAG Source Cross-Reference**: Auto-cross-reference response content with RAG sources to detect information absent from sources
- **Trigger Word Detection**: Detect assertive expressions like "confirmed," "absolutely," "definitely" and prompt disclaimer addition

---

## Part XXXIII: Domain-Specific Safety

### 33.1. Medical Disclaimer Protocol

- **No Diagnosis Mandate**: AI-generated "diagnoses," "medication instructions," or "prognosis predictions" are absolutely prohibited as they may violate medical laws
- **Emergency Response**: Upon detecting danger keywords (`blood`, `seizure`, `unconscious`, etc.), halt generation and immediately display rule-based alerts
- **Disclaimer Placement**: Place disclaimers not only at the end of AI responses but also near input fields and in first-use modals, building legal defense

### 33.2. Legal Disclaimer Protocol

- Prohibit AI from providing legal advice
- Auto-append professional referral messages like "Please consult an attorney"

### 33.3. Financial Disclaimer Protocol

- Prohibit AI from providing investment advice or financial product recommendations
- Auto-append "Please make investment decisions at your own risk. Consult a financial advisor"
- **Schema-Level Exclusion (common to 33.1–33.3)**: An AI feature that could touch a licensed profession's exclusive work MUST (a) state the prohibited acts in the prompt (diagnosis, treatment, medication or prognosis judgments, tax judgments, legal judgments, claiming to be a licensed professional), (b) omit from the output schema any field representing them (e.g., `diagnosis_by_ai`, `recommended_treatment`, `suggested_dosage`, `tax_advice`, `is_deductible`), and (c) always show on screen that "this is a transcription read by AI, not a judgment".
  - **Verification**: Compliance is not satisfied by a declaration (configuration value) alone; a test MUST literally match the prohibition wording in the prompt body. Failure pattern: the profile carried a compliance declaration, the prompt had no prohibition wording, and the check allowed it.

### 33.4. Reporting Functionality

- **Rule 40.33**: Generative AI apps must implement inappropriate content reporting and blocking features (Google Play 2025 requirement)

---

## Part XXXIV: Crisis Management & Kill Switch

### 34.1. The Red Button Protocol (AI Kill Switch)

- **Risk Scenarios**: Mass hate speech generation via prompt injection, cloud bankruptcy via API loops
- **Rule 40.34**: Implement an "emergency stop switch" that can halt all AI functions without code redeployment
- **Implementation**: Control via Edge Config / DB flag (`ai_enabled: false`)
- **UI**: Auto-switch to "Under Maintenance" fallback display when Kill Switch is activated

### 34.2. Drill Obligation

- **Rule 40.35**: Conduct Kill Switch operational verification drills **at least once every 6 months**
- A non-functional Kill Switch is the same as having none
- Maintain drill records and incorporate improvements into next iteration

### 34.3. Circuit Breaker

- Implement Circuit Breaker that auto-pauses AI functions when error rate exceeds threshold (e.g., 10%)
- **Half-Open**: After a set period, allow small request volume through to confirm recovery
- **Zero Budget = Immediate Stop**: An AI budget cap (daily or monthly) of 0 MUST be interpreted as "stop immediately", not "no limit". Evaluate it at the execution boundary before the provider is reached, state the meaning of 0 in the admin UI, and keep the manual kill switch and the budget kill switch semantically aligned (SHOULD).
  - **Failure pattern**: Right after 0 was set as an emergency stop, "only the first request got through" (confusing `>` with `>=` in the cap comparison, first count not yet reflected) and a charge occurred. Pin the first-request leak with a regression test (MUST).

### 34.4. Graceful Degradation

- Pre-design and test alternative flows for when AI functions are stopped
- Examples: AI chat stops → display FAQ/Help Center navigation; AI search stops → fallback to keyword search

---

## Part XXXV: AI Destructive Command Ban & HITL

### 35.1. The AI Destructive Command Ban

- **Rule 40.36**: AI agents must not autonomously generate or execute destructive commands such as `rm`, `git rm`, `git restore` without explicit user permission
- **Text Asset Immunity**: Document asset deletion is "project memory loss." Even if technically possible, self-censor as a "prohibited operation"
- **Exception**: Obvious cleanup like `.DS_Store` or `node_modules` deletion is exempt (not applicable to text assets)

### 35.2. The Human-in-the-Loop Protocol (HITL)

- **Rule 40.37**: AI agents respond based on past context and may fixate on outdated information or incorrect assumptions. Users have an obligation to correct context without hesitation when AI heads in the wrong direction
- **Rationale**: Allowing AI to run unchecked is supervisory negligence. AI is a "tool," and operational responsibility always rests with humans

### 35.3. Human Approval Gate Design

| Operation Type | Approval Level |
|:---|:---|
| **Read (Search/Reference)** | Auto-execute allowed |
| **Create (New Data Generation)** | Display draft → Approval |
| **Update (Existing Data Modification)** | Display change diff → Approval |
| **Delete (Data/Resource Removal)** | Confirmation dialog + explicit approval |
| **External Integration (Fund Transfer/Notification)** | Double confirmation + execution confirmation |

---

## Part XXXVI: AI FinOps Strategy

### 36.1. The 30% Profitability Rule

- **Rule 40.38**: AI feature costs (token fees + infrastructure costs) must never exceed **30%** of plan revenue under any circumstances

### 36.2. Cost Structure Analysis

| Cost Element | Formula | Optimization Means |
|:---|:---|:---|
| **Input Token** | Token count × unit price | Prompt compression, unnecessary context removal |
| **Output Token** | Token count × unit price | Output length limits, Structured Output |
| **Embedding** | Document count × embedding cost | Incremental updates |
| **Vector DB** | Storage + query count | Cache utilization, unnecessary data removal |
| **Inference Infra** | Compute time | Edge Runtime, cold start avoidance |

- **Query-Side Cost Discipline**:
  - **Conditional RAG Lookup**: Run an auxiliary RAG lookup (one the feature works without) only when the input carries a signal that a hit is likely (keyword, hint, classification), and do not pay the embedding cost on requests with no such prospect (SHOULD). Try embedding-free matching first (exact match, direct ID lookup) and semantic search last (SHOULD).
  - **Billing-Unit Estimation**: In reservation-based cost control (reserving an upper-bound estimate from the budget before the call), align the estimate with the provider's billing unit (text = tokens, images = tiles/images, audio and video = seconds) (MUST). Treating the JSON-serialized byte length uniformly as a token count is prohibited (MUST NOT). Failure pattern: an image's base64 byte length was treated as tokens, a single read reserved 40% of the daily budget, and every AI feature for every user went fail-closed.
  - **Unknown → Maximum**: An input whose type cannot be determined (unknown MIME, spoofed) falls to the maximum of all type estimates and the byte length (MUST). Falling to the minimum lets type spoofing shrink the reservation. "Safe side" is a direction, not a quantity — an oversized safe-side estimate exhausts the budget and becomes an availability hole that stops every feature.
  - **Idempotent Embedding Ingest**: Make corpus ingestion idempotent via a partial unique index on the normalized body hash, and count a unique-constraint violation as "already exists" (MUST). Concurrent cron and manual runs then cannot double-register or double-bill. When statistics are narrated into text and embedded, cover only closed periods (e.g., up to the previous month) and round the counts (MUST). Including the current period changes the hash on every refresh, causing embedding re-billing, orphaned reference IDs and a permanently firing mass-change guard. Throttle re-proposal of aggregate-derived candidates with aggregate-key hash × cooldown (SHOULD).

### 36.3. AI Cost Monitoring & Alerting Protocol

- **Rule 40.39**: Mandate the following cost monitoring framework
  1. **Usage Tracking Table**: Aggregate daily/monthly token consumption in `ai_usage_tracking` table
     - **Measured Tokens Mandate**: Every call that incurs metered cost MUST take the actual input/output token counts from the response metadata and record them in the usage history. User-facing fixed point deductions and call counts are billing UX, not a substitute for cost measurement. An implementation without measured tokens disables cost anomaly detection and the Circuit Breaker — it is "FinOps theater" and is prohibited without exception (MUST NOT)
  2. **Budget Alert**: Auto-fire Slack/email alerts when monthly budget reaches **80%**
  3. **Cost Attribution**: Enable AI usage cost attribution by user/feature/tier
     - **Typed Feature ID**: Every cost-incurring AI execution boundary (proxy call, breaker decision, model selection) MUST take the feature ID as a type-level required argument. Never revert it to optional. The only exception is a non-billed path that never reaches the provider (health checks, etc.), with the reason stated in code. When adding a feature ID, update the value list, feature flags, defaults and display labels together, and verify by test that it is not missing from the admin ON/OFF controls (MUST). Failure pattern: the bypass "feature unspecified, therefore not subject to the stop"
  4. **FinOps Dashboard**: Visualize cost trends, per-user costs, cache hit rates
  5. **Two-Layer Hard Limit**: Hold a short-term (daily spike) cap and a cumulative (monthly) cap, and automatically degrade or stop when either threshold is reached (MUST)
  6. **Operational Visibility**: Show the cap values, degradation threshold, stop threshold and current breaker state not only on the settings page but on the screen operators look at every day, so "which cap will stop us now" is visible on one screen (MUST). Failure pattern: the monthly kill switch was implemented, but the admin UI showed only the daily cap, delaying detection and explanation of the monthly overrun. When adding or changing a cap, update the DTO, validation, defaults, settings UI, display and legacy-settings compatibility test together (SHOULD)
  7. **Bounded Concurrency**: Bound the parallelism of AI calls with a constant (MUST). Beyond rate limits, in reservation-based cost control unlimited parallelism stacks up one upper-bound estimate per concurrent call, squeezes the daily budget and makes unrelated AI features fail-closed

---

## Part XXXVII: Usage Metering & Billing

### 37.1. Quota & Tiering Standards

- **"Unlimited" is a UI metaphor**: Internally enforce strict caps

| Plan | Chat | Thinking | Vision |
|:---|:---|:---|:---|
| **Free** | 5/day | 0 | 0 |
| **Standard** | 30/day | 3/day | 5/day |
| **Premium** | 100/day | 10/day | 20/day |

### 37.2. AI Tier Metering Protocol

- **Rule 40.40**: AI feature usage counts must be **strictly metered and recorded server-side**, linked to billing systems
  1. **Atomic Counting**: Record counts within transactions on successful API calls
  2. **Graceful Denial**: Notify users with friendly UI like "You've reached today's usage limit"
  3. **No Bypass**: Prohibit direct client API calls, physically preventing metering bypass
  4. **Usage-Log Write Verification**: The usage log (count, tokens, feature ID, model) is the single source of truth for quotas, FinOps and audit; always inspect the insert result and, on failure, record it in the audit log and propagate to the caller (MUST). Even when the provider returns no usage metadata, record "one call" with zero tokens (MUST). Failure pattern: swallowed insert failures caused quota undercounting and a gap in the cost audit
  5. **Degradation Does Not Swallow Ledger Errors**: Even an auxiliary feature that degrades to an empty array, `null` or fixed text MUST NOT fold "usage log write failed" into the same handling as "no AI result". Degrade the UX, but re-throw the ledger failure before falling back
  6. **Reservation-Based Quota**: "COUNT actuals → compare with cap → execute → record" has a check-then-act race. Make it atomic with a dedicated reservation table (with TTL) plus an RPC that counts actuals + active reservations in one transaction and performs a conditional INSERT (advisory xact lock) (MUST). Never mix reservation rows into the FinOps source of truth (the actuals log) (MUST NOT) — a cleanup failure would permanently consume a paying user's quota. Reserve at the gate → delete the reservation on success, with TTL expiry as the backstop on failure; choose explicitly, and record, whether an RPC failure is fail-open or fail-closed (MUST)

### 37.3. Over-Limit Strategy

- Flexible overage handling via point billing (pay-as-you-go)
- Display countdown to next reset
- **Quota Reset Discipline**: The quota period is anchored to the contract's billing period, falling back to the calendar month only when there is no contract or the period is invalid (MUST). An administrator's goodwill reset never deletes usage logs; it appends to a reset ledger (timestamp, target, reason), and aggregation counts only usage "since the latest reset within the same period" as current usage (MUST). The ledger's reason field is an admin-facing audit note and MUST NOT be exposed through user-facing DTOs, screens or ordinary users' SELECT policies.
  - **Operation**: Fix the reset to a one-shot reset across all AI features and do not offer per-feature partial resets (SHOULD) — partial relief complicates the explanation and breeds disputes. Return "limit reached" not as a technical error but as a usage-state notice containing the remaining count for the current period and the next reset date (MUST). Do not reimplement the remaining-count calculation per screen; align the usage log, admin screen, user screen and every AI Action's cap check on the same definition (MUST).

---

## Part XXXVIII: Token Cost Optimization

### 38.1. Prompt Compression Techniques

- **Remove unnecessary modifiers/redundant expressions**: Periodically review and optimize system prompts
- **Abbreviation Strategy**: Replace frequently occurring patterns with shortened expressions
- **Strict Field Selection Application**: Minimize fields during RAG retrieval to reduce prompt tokens
- **Structure/Text Separation**: When transforming structured data (rich-text JSON, menus, link arrays, etc.) with AI (translation, summarization, rewriting), structure, IDs, URLs, enum values, numbers, timestamps and amounts MUST NOT be sent to the model. Extract only the natural-language text on the app side, simplify the model's contract to "return a string array of the same length in the same order", and put the results back into the skeleton. Since the structure never reaches the model, the path by which structure gets broken ceases to exist.
  - **Rationale**: (a) regenerating structure is what models break most easily, and once broken the renderer cannot read the body; (b) structure eats the output budget and the body gets cut off midway; (c) tokens are wasted on both input and output. In production measurement about two thirds of what was sent was structure and technical values. Verify the output (count, types, structure) deterministically (MUST). See §1.3 "Deterministic-First Decision Order".
- **Principle-Based Eligibility**: Decide "is this a processing target" by a principle derived from the target's nature (e.g., a string containing no characters of the source locale is not prose), not by enumerating key names (deny lists, allow lists) (MUST). The canonical rule is "Principle over Enumeration" in `engineering/000_engineering_standards.md`.

### 38.2. Cache ROI Calculation

```
Monthly Cache Savings = (Cache Hit Rate × Monthly API Calls × Avg Token Cost per Call)
Cache ROI = Monthly Cache Savings / Monthly Cache Infrastructure Cost
```

- **Target**: Cache ROI > 3.0

---

## Part XXXIX: Multimodal & Edge AI

### 39.1. Tech Stack

| Platform | Recommended Technology | Use Case |
|:---|:---|:---|
| **Web** | TensorFlow.js / ONNX Runtime Web | In-browser inference |
| **iOS** | CoreML | Native performance |
| **Android** | TensorFlow Lite | Native performance |

### 39.2. Vision AI

- **Privacy**: Execute image analysis on-device (client-side) whenever possible. Do not transmit "raw image data" off-device
- **Vision AI Standards**: Thinking models are prohibited for instant recognition tasks (OCR, etc.). Use a non-Thinking lightweight multimodal model mapped to `Tier.VISION`
- **Accessibility**: Make analysis results compatible with `alt` text and screen readers

### 39.3. Voice AI

- **Instant Feedback**: Convey recording state visually with waveform animations, etc.
- **Misrecognition Prevention**: For critical actions (fund transfers, deletions), don't complete with voice alone; interpose screen confirmation steps

### 39.4. Optical Data Entry (OCR/Vision)

- **Optical Archive**: Auto-convert physical documents to structured data via Vision AI. Provide "camera" UX instead of "input forms"
- **AI Data Entry Confirmation Protocol**: Prohibit AI-extracted data direct DB writes (Auto-Save). Always follow "Draft → Confirm → Save" flow
- **OCR Output PII Scrubbing**: Do not save PII outside service purposes as structured data; discard or mask
- **Cross-Reference**: PII Scrubbing (§XVIII), Data Minimization (`60`, `61`)
- **Shared Pipeline + Feature Profile**: Features of the same kind (several OCR / image analysis / classification features) MUST keep the overall procedure (auth → consent for external transmission → file inspection → rate limit → quota lookup and reservation (released in finally) → model → JSON repair and parse → schema validation → audit (summary only) and observability) in one SSOT, and declare only the feature-specific differences (feature ID, specialized prompt, output schema, quota, audit kind, whether knowledge is referenced, compliance declaration) as a profile. The entry point is a "thin layer that only points at a profile"; consent, rate limiting and quotas are never written in the entry point.
  - **Failure pattern**: Duplicating the procedure per feature produces, one at a time, a missing consent gate, an uncounted quota and asymmetric auditing. Split only the differences; keep one set of defenses.
  - **Specialized over Universal**: A universal prompt (handling several classifications in one) generates fields that are never stored and wastes input and output tokens. Feature-specialized prompts are more accurate and cheaper (SHOULD).
  - **Profile Addition Check**: Everything that must be in place when one profile is added (registration in the feature ID ledger, model routing, inclusion in quota aggregation, audit evidence, failure-rate anomaly detection, the paired metrics "reads" and "saves", the RAG asset declaration) is pinned mechanically by tests (MUST).
  - **No Raw Asset**: The raw text read by AI (receipts, statements, etc.) is personal data and is never turned into an asset. Assetization is limited to k-anonymous aggregates with zero personal columns (e.g., k≥10); when a feature does not reference knowledge, declare the reason (do not create dead configuration that is listed in the table but never wired) (SHOULD).

---

## Part XL: LLMOps Lifecycle

### 40.1. LLMOps Overview

```
[Use Case Definition] → [Prompt Engineering] → [Development & Testing]
         ↓                                                 ↓
[Deployment] → [Monitoring & Observability] → [Evaluation] → [Optimization]
         ↓                                                 ↓
[Governance & Compliance] ← ← ← ← ← ← ← ← ← [Feedback Loop]
```

### 40.2. LLMOps Maturity

| Level | Name | Features |
|:---|:---|:---|
| **L1** | Ad-hoc | Manual prompt management, no tests |
| **L2** | Managed | Git management, basic tests |
| **L3** | Automated | CI/CD integration, automated evaluation |
| **L4** | Optimized | A/B testing, cost optimization |
| **L5** | Autonomous | Auto prompt improvement, autonomous quality management |

---

## Part XLI: PromptOps

### 41.1. Code-as-Prompts

- **Rule 40.41**: Define prompts as constants in Git-managed code (`src/lib/prompts/*.ts`), not DB text, and review via PRs

### 41.2. Prompt Versioning

- **Rule 40.42**: Include version numbers in prompt files like `v1_xxx.ts`, `v2_xxx.ts`
- Enable at-a-glance change history tracking

### 41.3. Prompt A/B Testing Protocol

- **Rule 40.43**: When improving prompts, maintain old versions instead of deleting them, keeping them switchable via Feature Flags
- Compare old/new versions by metrics; deprecate old version after confirming improvement

### 41.4. Prompt Regression Testing

- Conduct regression tests using "Golden Datasets" on every change to prevent quality degradation
- **Placeholder Binding**: Placeholder expansion for prompt templates MUST be centralized in a builder function in the same module as the template definition. Ad-hoc `replace()` calls at call sites are prohibited. Failure pattern: old placeholder names and the new template drifted apart, and the AI answered without ever receiving the context it needed. On every template change, verify by test that every context is actually injected and no unexpanded `{{...}}` remains (MUST).

---

## Part XLII: Model Lifecycle Management

### 42.1. The Model Switch Protocol (4-Step Process)

| Step | Content | Duration |
|:---|:---|:---|
| **Step 1: Staging Test** | Golden Dataset validation in staging environment | 1-2 days |
| **Step 2: Shadow Mode** | Run old and new models simultaneously in production, record diffs | Minimum 48 hours |
| **Step 3: Canary Release** | Serve new model to 10% of users, monitor | 1-3 days |
| **Step 4: Full Rollout** | Deploy to all users | — |

- **Instant Rollback**: Control immediate switch back to old model at each step via environment variable (`AI_MODEL_VERSION`)
- **Provider-Specific Field Inventory**: When migrating an external provider (model platform, payments, email, storage, etc.), inventory every request field, option and contract clause specific to the old provider, one by one, as "what is the equivalent on the new provider / if none, where does the guarantee move to" (MUST). The absence of an equivalent and the absence of a need for the guarantee are different things.
  - **Measure where the guarantee moved**: When a guarantee moves to "the other side's settings" (project settings, admin console), create a check that measures that setting value at the same time as the migration (MUST). "It is off by default, so it's fine" is not acceptable (MUST NOT). See §9.1 "Provider Data Retention Boundary".
  - **Re-review published statements**: Facts written in the privacy policy and consent dialogs are re-reviewed, together with their evidence, on every provider migration (MUST). An evidence comment goes stale even if it was written in the previous commit.

---

## Part XLIII: AI Quality Metrics

### 43.1. Required Metrics

| Metric | Measurement Method | Baseline Target |
|:---|:---|:---|
| **Hallucination Rate** | RAG source cross-reference (sampling) | < 5% |
| **User Satisfaction** | 👍/👎 feedback ratio | > 80% 👍 |
| **Response Time (P95)** | Log aggregation | < 3,000ms |
| **Guardrail Trigger Rate** | Rejection log aggregation | Monitoring only |
| **Cache Hit Rate** | Cache log aggregation | > 30% |
| **Cost/Request** | Monthly cost ÷ request count | Month-over-month improvement |

- **Review Cycle**: Monthly review. Create prompt improvement tasks when degradation trends appear

---

## Part XLIV: Automated Evaluation (LLM-as-a-Judge)

### 44.1. Evaluation Pipeline

- **Rule 40.44**: Use automated evaluation with a superior model as "judge" for AI response quality assessment as deployment criteria
- **Evaluation Items**: Accuracy, relevance, completeness, harmfulness, tone appropriateness

### 44.2. Evaluation CI/CD Integration

- Integrate automated evaluation pipelines into prompt change PRs to pre-detect quality degradation
- Block PR merges when scores fall below thresholds

---

## Part XLV: AI Observability

### 45.1. OpenTelemetry GenAI Semantic Conventions

- **Rule 40.45**: Adopt OpenTelemetry GenAI Semantic Conventions for AI feature observability
- **Tracing Targets**: Prompts, models, token usage, latency, errors, guardrail triggers
- **Exception Body Hygiene**: For exceptions involving the AI provider, image analysis, user input or RAG context, `error.message` MUST NOT be sent as-is to the logger or error tracking. A provider's error body may contain prompt fragments, user input or image analysis results. Route through a dedicated helper and keep only classification information such as the type name, error code and HTTP status.

### 45.2. Monitoring Dashboards

| Dashboard | Key Metrics |
|:---|:---|
| **AI Quality** | Hallucination rate, user satisfaction, Grounding rate |
| **AI Performance** | Latency P50/P95/P99, throughput, error rate |
| **AI Cost** | Daily/monthly token consumption, per-user cost, cache effectiveness |
| **AI Security** | Guardrail trigger rate, prompt injection detection count |

### 45.3. Alert Design

- **P95 Latency > 5,000ms** → Warning
- **Error Rate > 5%** → Critical (consider Circuit Breaker activation)
- **Monthly Budget > 80%** → Budget Warning
- **Hallucination Rate > 10%** → Quality Alert

---

## Part XLVI: Future Outlook

### 46.1. Emerging Technologies and AI Implementation

| Technology | Impact on AI Implementation | Timeline |
|:---|:---|:---|
| **Autonomous AI Agent** | Practical deployment of L5 autonomous agents | 2026-2028 |
| **Quantum-Safe AI** | Quantum-resistant cryptography adoption | 2027+ |
| **Spatial Computing AI** | AI interaction in AR/VR | 2026-2027 |
| **Voice-First AI** | Voice-primary AI UX | 2025-2026 |
| **Digital Twin AI** | Fusion of digital twins and AI | 2027+ |
| **Wasm AI** | Edge AI inference via WebAssembly | 2025-2026 |

---

## Part XLVII: Maturity Model (5 Levels)

| Level | Name | Features |
|:---|:---|:---|
| **L1** | Experimental | PoC stage, manual prompts, no tests |
| **L2** | Managed | Git management, basic guardrails, manual evaluation |
| **L3** | Standardized | Model Router, automated evaluation, FinOps dashboard, RAG foundation |
| **L4** | Optimized | A/B testing, Agentic AI (L3), multi-agent, cost optimization |
| **L5** | Autonomous | Autonomous quality improvement, fully automated LLMOps, Agentic AI (L4+), integrated AI observability |

---

## Part XLVIII: Anti-Pattern Collection (20 Items)

| # | Anti-Pattern | Problem | Solution |
|:---|:---|:---|:---|
| 1 | **Spinner Hell** | Spinner for all AI responses | Streaming First |
| 2 | **Prompt Spaghetti** | Prompts scattered in DB | Code-as-Prompts |
| 3 | **Model Hardcoding** | Hardcoded model IDs | Model Router |
| 4 | **Infinite Context** | Send all conversation history every time | Sliding Window + Summarization |
| 5 | **Silent Hallucination** | Factual assertions without disclaimers | Staged Disclaimer Protocol |
| 6 | **PII Leakage** | PII sent to external LLMs | PII Scrubbing |
| 7 | **Key Exposure** | API keys exposed to client | Server-side proxy |
| 8 | **No Kill Switch** | No emergency stop mechanism | Red Button Protocol |
| 9 | **Unlimited AI** | AI features with no cost caps | 30% Rule + Budget Alert |
| 10 | **Auto-Save AI** | Auto-saving AI outputs to DB | Draft-First + Confirmation Gate |
| 11 | **Monolithic Agent** | All functions in a single agent | Responsibility separation + Multi-Agent |
| 12 | **Blind Trust** | Using AI outputs without verification | Guardrails + HITL |
| 13 | **Cache Stampede** | Mass requests on cache expiry | Cache locks + TTL jitter |
| 14 | **RAG Noise** | RAG with HTML-containing noisy data | Triple Write Protocol |
| 15 | **No Evaluation** | Undefined quality metrics | AI Quality Metrics + Review |
| 16 | **Shadow AI** | Use of unapproved AI tools | Governance Committee |
| 17 | **One-Shot Migration** | Batch model switch | 4-Stage Model Switch |
| 18 | **Guardrail Bypass** | Selective guardrail application | Mandate all requests pass through |
| 19 | **Opaque AI** | Non-disclosure of AI decision rationale | Citation + Explainability |
| 20 | **Zombie Prompts** | Unused old prompts | Periodic inventory + deprecate |
---

## Part XLIX: Advanced RAG Architecture

### 49.1. RAG Paradigm Evolution Map

| Generation | Paradigm | Features | Recommended Case |
|:---|:---|:---|:---|
| **Gen 1** | Naive RAG | Fixed chunking + vector search → LLM | Prototypes, simple Q&A |
| **Gen 2** | Advanced RAG | Hybrid search + reranking + metadata filters | Production RAG systems |
| **Gen 3** | Modular RAG | Each pipeline stage modularized and interchangeable | Large-scale, complex domains |
| **Gen 4** | Agentic RAG | LLM autonomously decides retrieval strategy, iterates, self-corrects | Multi-source, high-accuracy requirements |

- **Rule 40.46**: New RAG systems must be Gen 2 or above. Gen 1 (Naive RAG) production deployment is prohibited

### 49.2. Agentic RAG

- **Definition**: RAG architecture where LLM autonomously iterates through retrieval necessity judgment, query generation, result evaluation, and re-retrieval
- **Core Loop**: `Query Analysis → Routing Decision → Retrieval → Relevance Assessment → Re-query or Generate`
- **Application Criteria**: High query complexity, multiple data source integration needed, response accuracy is critical
- **Constraints**: Set loop iteration caps (recommended: max 3), mandate cost monitoring as token consumption increases per iteration

```
Agentic RAG Loop:
[User Query] → [Query Analyzer] → Does the query need retrieval?
   ├── No  → [Direct LLM Response]
   └── Yes → [Query Router: Which source?]
                ├── [Vector DB] → [Retrieve] → [Grade Relevance]
                ├── [Web Search] → [Retrieve] → [Grade Relevance]
                └── [Structured DB] → [SQL/API] → [Grade Relevance]
                          ↓
                   [Relevant?]
                   ├── Yes → [Context Assembly] → [Generate] → [Verify]
                   └── No  → [Rewrite Query] → Loop (max 3)
```

### 49.3. Corrective RAG (CRAG / Self-Reflective RAG)

- **Definition**: RAG pattern that evaluates retrieval result quality and modifies queries for re-retrieval when insufficient
- **Grader Model**: Small LLM or fine-tuned classifier that judges relevance in 3 levels (Relevant / Ambiguous / Irrelevant)
- **Action branching**:
  - `Relevant` → Use as context
  - `Ambiguous` → Rewrite query + additional retrieval
  - `Irrelevant` → Fallback to web search, or respond with "Information not found"
- **Rule 40.47**: Corrective RAG Grader thresholds must be tuned quarterly using evaluation datasets

### 49.4. Adaptive RAG

- **Definition**: RAG pattern that dynamically switches retrieval strategies based on query complexity
- **Routing decisions**:
  - **Simple Query** → Direct LLM response (no retrieval needed)
  - **Factual Query** → Standard vector search
  - **Complex Query** → Multi-step search + reranking
  - **Real-Time Query** → Web search + fact-checking
- **Effect**: Cost reduction by skipping unnecessary retrieval; optimal accuracy per query type

### 49.5. RAPTOR (Recursive Abstractive Processing for Tree-Organized Retrieval)

- **Definition**: RAG optimization technique that recursively summarizes documents and builds hierarchical tree-structured indices
- **Process**:
  1. Split source documents into leaf nodes (small chunks)
  2. Cluster similar chunks
  3. Generate summaries for each cluster using LLM
  4. Further cluster and summarize summaries (recursive)
  5. Index all levels of chunks + summaries
- **Advantage**: Multi-resolution search capable of handling both detailed fact retrieval and high-level conceptual questions
- **Application Case**: Long documents, systematic knowledge like FAQs

### 49.6. Late Chunking

- **Definition**: Technique that generates token-level embeddings by passing the entire document through a Transformer before applying chunk boundaries
- **Advantage**: Each chunk's embedding retains full document context, preventing information loss from anaphora and long-distance references
- **Comparison with traditional approach**:
  - **Early Chunking** (traditional): Split first → Embed each chunk independently → Context loss risk
  - **Late Chunking**: Embed first → Split later → Context preserved
- **Constraint**: Documents exceeding Transformer's max token length require pre-splitting

### 49.7. Contextual Embeddings / Contextual Retrieval

- **Rule 40.48**: Recommend adding document-level context information (surrounding summaries, section names, document types) to chunks before embedding
- **Effect**: Even isolated chunks retain knowledge of "which document's which section this describes," significantly improving retrieval accuracy
- **Implementation Pattern**: Auto-generate 1-2 sentence context descriptions per chunk using LLM and prepend to chunk text

### 49.8. Query Transformation

| Method | Description | Effect |
|:---|:---|:---|
| **Query Rewriting** | Rewrite user queries into search-optimal form | Improved retrieval accuracy |
| **Query Decomposition** | Decompose compound questions into multiple sub-queries | Complex question handling |
| **HyDE** | Generate hypothetical answers and search using their embeddings | Bridging semantic gaps |
| **Step-Back Prompting** | Search with abstracted higher-level concepts then drill down | Broad knowledge acquisition |

- **Cross-Reference**: RAG Foundation Design (§XIX), Hybrid Search (§XXI), Reranking (§XXII)

---

## Part L: OWASP LLM Top 10 2025 Full Compliance

### 50.1. OWASP LLM Top 10 2025 Overview

- **Rule 40.49**: Mandate defensive measures against all 10 OWASP LLM Top 10 2025 items in LLM application design and implementation
- **Compliance check frequency**: Quarterly + model changes + new feature additions

### 50.2. LLM01:2025 — Prompt Injection

- **Threat**: Attackers manipulate LLM behavior to cause unintended actions or data leakage
- **Direct**: Overwriting system prompts via user input
- **Indirect**: Hidden instructions embedded in external content (RAG sources, URLs, etc.)
- **Defense**:
  - Fully implement §XVIII multi-layer prompt injection defense
  - Clear separation of user input and system instructions (delimiter strategy)
  - System prompt leak detection in outputs
  - RAG source trustworthiness verification
- **Cross-Reference**: AI Security (§XVIII)

### 50.3. LLM02:2025 — Sensitive Information Disclosure

- **Threat**: LLMs unintentionally output PII or confidential information from training data or RAG sources
- **Defense**:
  - Input-side PII Scrubbing (§XVIII)
  - Output-side PII Leak Prevention (§XXXI)
  - PII pre-removal from RAG sources
  - DLP (Data Loss Prevention) integration
  - Explicit prohibition of confidential information reference in system prompts

### 50.4. LLM03:2025 — Supply Chain Vulnerabilities

- **Threat**: Tampered models, APIs, training data, or open-source libraries endangering the entire system
- **Defense**:
  - Model provenance verification (checksums, signatures)
  - Third-party LLM API reliability assessment
  - Dependency package vulnerability scanning (SCA)
  - Model card confirmation and documentation
- **Cross-Reference**: License & Dependency Management (`62`)

### 50.5. LLM04:2025 — Data and Model Poisoning

- **Threat**: Bias injection or backdoor embedding through contamination of training data or RAG knowledge bases
- **Defense**:
  - RAG source data quality management and periodic audits
  - Fine-tuning data verification pipelines
  - Statistical monitoring of anomalous outputs
  - Data lineage tracking

### 50.6. LLM05:2025 — Improper Output Handling

- **Threat**: Secondary attacks (XSS, SQL injection, etc.) from passing LLM outputs to systems without validation
- **Defense**:
  - Strict sanitization and validation of LLM outputs
  - Prohibit designs that directly insert outputs into HTML/SQL/commands
  - Leverage Structured Output (§XIV) for parseable JSON format with validation
  - **Rule 40.50**: Always execute sanitization + type validation before using LLM outputs for DB writes, external API calls, or UI display

### 50.7. LLM06:2025 — Excessive Agency

- **Threat**: Risk of manipulation when LLMs are granted excessive permissions (DB writes, external API execution, file operations)
- **Defense**:
  - Strict application of §XXXV AI Destructive Command Ban
  - Tool Use design principles (§XIV) least privilege compliance
  - Human Approval Gate installation for write operations
  - Agent autonomy level restriction (§XXVI: L3 or below)

### 50.8. LLM07:2025 — System Prompt Leakage

- **Threat**: Leakage of confidential logic, API structures, or internal rules contained in system prompts
- **Defense**:
  - Do not include confidential information (API keys, internal URLs, etc.) in system prompts
  - Rejection rules for "disclose your system prompt" type requests
  - Partial matching detection of system prompt content in outputs
  - **Rule 40.51**: System prompts must not contain secret keys, internal endpoints, or business logic details

### 50.9. LLM08:2025 — Vector and Embedding Weaknesses

- **Threat**: Exploitation of vulnerabilities in vector DB and embedding generation, storage, and retrieval processes
- **Defense**:
  - Access control for vector DBs (authentication + RLS)
  - Embedding tampering detection
  - RAG injection (intentional insertion of malicious documents) countermeasures
  - Search scope restriction via metadata filtering
  - **Rule 40.52**: Restrict document ingestion to vector DBs to approved pipelines only; prohibit direct ingestion from unverified sources
  - **Namespace Ledger**: The shelves (namespaces) of a RAG corpus have a ledger as their source of truth, and the ingestion platform rejects writes to any shelf not in the ledger (MUST). Pin by test that the ledger set and the app constants match exactly and that raw shelf-name literals in ingestion code are zero
  - **Source-Based Approval Tier**: The approval tier (automatic / bulk approval / aggregate only / per item) is decided by the nature of the source, not the shelf (MUST): operator-published and not generated → automatic; user-derived and LLM-generated → bulk approval (structurally eliminating one-by-one manual checks while still inserting human review); records about individuals or specific animals → k-anonymous aggregates only; facts about non-person subjects such as products or venues → a minimum contributor count plus approval so that no string unique to one person gets in. Sources of different tiers may share one shelf. Prefer per-item real-risk judgment over a blanket "aggregate only" rule per table (SHOULD)

### 50.10. LLM09:2025 — Misinformation

- **Threat**: LLMs generating convincing factually incorrect content, spreading misinformation
- **Defense**:
  - Full application of §XXXII hallucination mitigation
  - Mandatory Grounding (cross-reference factual information with DB/RAG sources)
  - Staged Disclaimer Protocol
  - Automated factuality verification via LLM-as-Judge

### 50.11. LLM10:2025 — Unbounded Consumption

- **Threat**: Resource exhaustion and financial damage from LLM calls without cost caps
- **Defense**:
  - §XXXVI 30% Rule compliance
  - §XXX Circuit Breaker
  - Token/API call cap settings
  - Anomalous consumption detection alerts
  - **Rule 40.53**: Limit maximum output tokens per single LLM API request (default: 4,096 tokens)
  - **Explicit Generation Parameters**: State max output tokens, reasoning depth (thinking level) and temperature on every call; silently adopting provider, proxy or SDK defaults is prohibited (MUST NOT). When omitted, a default applies silently and the cause of cost growth and truncation cannot be traced later. Write the rationale next to the constant, and keep generation parameters in one cross-feature SSOT, never duplicated per use case (MUST). Failure pattern: separate constants per use case, one was fixed and behavior diverged
  - **Thinking + Output Budget**: On APIs where reasoning (thinking) tokens share the output budget, pin the reasoning depth to the minimum for mechanical transformation tasks (translation, formatting, classification) (SHOULD). Left alone, reasoning eats the budget and the result is cut off midway (measured: output stopped a few tokens short of the cap and every field of one entity failed at once)

### 50.12. OWASP LLM Mitigation Implementation Checklist

| # | OWASP ID | Mitigation | Rule Reference | Status |
|:---|:---|:---|:---|:---|
| 1 | LLM01 | Multi-layer prompt injection defense | §XVIII, §L.2 | [ ] |
| 2 | LLM02 | PII Scrubbing + DLP | §XVIII, §XXXI | [ ] |
| 3 | LLM03 | Supply chain verification | §L.4, `62` | [ ] |
| 4 | LLM04 | Data quality management + anomaly monitoring | §L.5, §XIX | [ ] |
| 5 | LLM05 | Output sanitization + type validation | §XIV, §L.6 | [ ] |
| 6 | LLM06 | Least privilege + HITL | §XIV, §XXXV | [ ] |
| 7 | LLM07 | System prompt protection | §L.8 | [ ] |
| 8 | LLM08 | Vector DB access control | §L.9 | [ ] |
| 9 | LLM09 | Grounding + disclaimer protocol | §XXXII | [ ] |
| 10 | LLM10 | Cost caps + Circuit Breaker | §XXXVI, §XXXIV | [ ] |

---

## Part LI: LLM Firewall & AI Red Teaming

### 51.1. LLM Firewall Architecture

```
[User Input] → [LLM Firewall Layer]
                    ├── [Input Shield]
                    │     ├── Prompt Injection Detector (ML-Based)
                    │     ├── PII Scanner
                    │     ├── Topic Classifier
                    │     └── Rate Limiter
                    ↓
              [LLM Inference]
                    ↓
              [Output Shield]
                    ├── Content Safety Classifier
                    ├── PII Leak Detector
                    ├── Hallucination Verifier
                    ├── System Prompt Leak Detector
                    └── Tone/Brand Compliance Checker
                    ↓
              [Sanitized Output] → User
```

- **Rule 40.54**: LLM Firewall Input Shield and Output Shield must apply to **all requests**; selective bypass is prohibited
- **Recommended Tools**: NVIDIA NeMo Guardrails, Guardrails AI, LangKit, Lakera Guard

### 51.2. AI Red Teaming

- **Definition**: Organized testing methodology that intentionally attacks AI systems to discover vulnerabilities
- **Rule 40.55**: Before releasing AI features, conduct AI Red Teaming tests across the following categories

| Category | Test Examples | Purpose |
|:---|:---|:---|
| **Prompt Injection** | Jailbreak attempts, role impersonation, delimiter breaking | Input defense verification |
| **Information Leakage** | System prompt extraction, PII elicitation | Confidentiality verification |
| **Bias** | Inducing discriminatory responses by region/gender/race | Fairness verification |
| **Harmful Content** | Inducing violence/illegal activity generation | Safety verification |
| **Cost Attack** | Mass token consumption, infinite loop induction | Resilience verification |
| **Privilege Escalation** | Inducing destructive tool invocations | Permission control verification |

### 51.3. Adversarial Testing Pipeline

- **Automated Testing**: Continuous testing using prompt injection dictionaries + automation frameworks (Garak, Promptfoo, etc.)
- **Manual Testing**: Creative attack scenario testing by security engineers
- **Frequency**: Pre-release + quarterly periodic tests + model changes
- **Result Management**: Track discovered vulnerabilities as security bugs and mandate fixes

### 51.4. AI Penetration Testing

- **Scope**: LLM firewall breach, RAG poisoning, vector DB access, API abuse
- **Reporting**: Evaluate vulnerability severity using AI-specific scoring aligned with CVSS
- **Cross-Reference**: Security & Privacy (`60`), QA Testing (`70`)

---

## Part LII: AI Accessibility

### 52.1. AI Output Accessibility Standards

- **Rule 40.56**: AI feature outputs must meet WCAG 2.2 AA standards, guaranteeing accessibility
- **EAA 2025 (European Accessibility Act)**: Effective June 28, 2025. Mandates digital service accessibility

### 52.2. Screen Reader Support

| Element | Requirement |
|:---|:---|
| **AI Response Text** | Notify reading completion with `aria-live="polite"` after streaming completes |
| **During Streaming** | Set `aria-busy="true"` during generation, release on completion |
| **Confidence Indicator** | Include text labels ("High confidence", etc.) alongside colors |
| **Citation Links** | Attach `aria-label` so citations are clearly identifiable by screen readers |
| **Feedback Buttons** | Add `aria-label="This answer was helpful"` etc. to 👍/👎 buttons |
| **Error Messages** | Immediately notify with `role="alert"` |

### 52.3. Cognitive Accessibility

- **Plain Language**: Compose AI outputs in plain language wherever possible. Auto-append supplementary explanations for technical terms
- **Chunked Output**: Section long responses with heading structure to reduce cognitive load
- **Predictable Behavior**: Maintain consistent AI UI behavior patterns for predictability
- **Rule 40.57**: Apply JIS X 8341-3:2016 / WCAG 2.2 SC 3.1 (readability) to AI outputs

### 52.4. Multimodal Accessibility

| Input/Output | Accessibility Requirement |
|:---|:---|
| **Voice Input** | Always co-locate text input alternative with voice recognition |
| **Image Generation** | Auto-attach alt text to generated images |
| **Vision AI Results** | Provide image analysis results in text format |
| **Voice AI** | Simultaneously provide text transcription of voice responses |
| **Video Generation** | Auto-generate closed captions and audio descriptions |

### 52.5. Inclusive AI Design

- Enable users to adjust AI response language level via settings (child-friendly / simple / standard / expert)
- Provide auto-adjustment of font size and contrast ratio for elderly users
- Color vision diversity support: Triple representation with color + text + icon for Confidence Indicators
- **Cross-Reference**: Design & UX (`20`), Language Protocol (`74`)

---

## Part LIII: AI-Driven Personalization & Adaptive UI

### 53.1. AI-Driven Personalization Design Principles

- **Rule 40.58**: Implement AI-driven personalization based on explicit user consent within privacy protection frameworks
- Strictly observe data minimization principles. Do not collect or retain data unnecessary for personalization

### 53.2. Personalization Hierarchy

| Level | Method | Data Requirements | Privacy Risk |
|:---|:---|:---|:---|
| **L1: Segment** | Static personalization by user segment | Registration attributes (plan, region) | Low |
| **L2: Behavioral** | Dynamic personalization based on behavior history | Browse, click, usage patterns | Medium |
| **L3: Contextual** | Adaptation based on current context (time, location, device) | Real-time context | Medium |
| **L4: Predictive** | AI predicts next actions/needs and proactively suggests | Behavioral prediction model | High |
| **L5: Generative** | AI dynamically generates UI layouts and content per user | Comprehensive user profile | Highest |

- **Rule 40.59**: Obtain explicit Opt-In consent for L3+ personalization. Mandate AI Governance Committee approval for L4-L5

### 53.3. Adaptive UI Design Patterns

| Pattern | Description | Application Example |
|:---|:---|:---|
| **Adaptive Navigation** | Dynamically reorder menus based on usage frequency | Place frequently used features at top |
| **Adaptive Content** | Adjust content detail level based on user comprehension | Display beginner-friendly guides |
| **Adaptive Complexity** | Gradually change UI complexity based on skill level | Show advanced features for power users |
| **Adaptive Notification** | Optimize notification frequency and channels based on user response patterns | Notify at high-response-rate time slots |

### 53.4. Balancing Personalization and Privacy

- **Federated Learning**: Consider learning models on-device without sending personal data to servers
- **Differential Privacy**: Add noise to aggregated data to prevent individual identification
- **Transparency**: Always display personalization rationale ("This suggestion is based on your usage history")
- **Reset/Opt-Out**: Provide controls for users to reset personalization settings or turn them off entirely
- **Cross-Reference**: Data Privacy (`61`), User Data and AI Training (§IX)

---

## Part LIV: Advanced Prompt Engineering

### 54.1. Prompt Engineering Technique Catalog

| Technique | Description | Recommended Case |
|:---|:---|:---|
| **Zero-Shot** | Instructions only, no examples | Simple tasks, general LLMs |
| **Few-Shot** | Provide 2-5 input-output examples | Format standardization, classification |
| **Chain-of-Thought (CoT)** | Explicit intermediate reasoning steps | Math, logic, complex reasoning |
| **Self-Consistency** | Generate multiple CoT responses and majority vote | Tasks where accuracy is paramount |
| **Tree-of-Thought (ToT)** | Explore and evaluate multiple reasoning paths | Strategic planning, creative tasks |
| **ReAct** | Reasoning + Acting iteration | External tool integration, information retrieval |
| **Meta-Prompting** | Have LLM improve the prompt itself | Prompt optimization |
| **Directional Stimulus** | Guide response direction with hint keywords | Domain-specific accuracy improvement |

### 54.2. System Prompt Design Principles

- **Rule 40.60**: Standardize System Prompt to the following structure

```
[Role Definition]
You are a {role}. {behavioral constraints}.

[Task Definition]
{specific task description}

[Output Format]
{expected output format}

[Constraints]
- {prohibition 1}
- {prohibition 2}
- {safety-related instructions}

[Examples] (for Few-Shot)
Input: {input example}
Output: {output example}
```

### 54.3. Prompt Chaining

- **Definition**: Decomposing complex tasks into multiple prompts, chaining each stage's output as the next stage's input
- **Design principles**:
  - Keep each step's responsibility single (Single Responsibility)
  - Make inter-step data passing type-safe (Structured Output)
  - Set fallback and retry strategies for each step on error
- **Rule 40.61**: Recommend Prompt Chains within 3 steps. Consider Agent patterns (§XXVI) for 4+ steps

### 54.4. Prompt Optimization

- **A/B Testing**: Compare new vs. old prompts using Feature Flags (§XLI.3)
- **Automated Optimization**: Prompt auto-optimization using frameworks like DSPy
- **Token Efficiency**: Apply prompt compression techniques (§XXXVIII) to reduce costs while maintaining accuracy

---

## Part LV: Fine-Tuning & Model Customization

### 55.1. Fine-Tuning Decision Criteria

| Condition | Fine-Tuning Recommended | Prompt Engineering Recommended |
|:---|:---|:---|
| Task specialization | Highly specialized behavior/tone needed | Generic responses sufficient |
| Data volume | 1,000+ high-quality training samples | Few-shot examples sufficient |
| Cost sensitivity | Inference cost reduction priority (high accuracy on small models) | Development speed priority |
| Privacy | Cannot send confidential data to external APIs | External API usage acceptable |
| Style consistency | Strict brand tone/output format unification needed | Some variation acceptable |

- **Rule 40.62**: Adopt fine-tuning only when prompt engineering cannot achieve the goal. Strictly observe the "Data Quality > Data Quantity" principle

### 55.2. PEFT (Parameter-Efficient Fine-Tuning)

- **LoRA (Low-Rank Adaptation)**: Freeze pre-trained model weights and insert small low-rank matrices into attention layers for training
  - Advantage: Dramatic memory reduction (only 0.1-1% of parameters trained)
  - Application: Fine-tune 7B models on single GPU (24GB VRAM)
- **QLoRA**: LoRA + 4-bit quantization. Further memory efficiency enabling consumer GPU training
- **LoRA Best Practices**:
  - Rank: Start at 4-8, progressively increase if accuracy insufficient
  - Learning Rate: 10-100x higher than full fine-tuning
  - Target Modules: query, key, value projection layers as standard
  - Cautions: Rank too low → insufficient adaptation, Learning Rate too high → catastrophic forgetting

### 55.3. SFT, DPO & RLHF

| Method | Description | Use Case |
|:---|:---|:---|
| **SFT (Supervised Fine-Tuning)** | Supervised learning with input-output pairs | Task specialization, format unification |
| **DPO (Direct Preference Optimization)** | Direct optimization with human preference pairs (Winner/Loser) | Tone and quality adjustment |
| **RLHF (Reinforcement Learning from Human Feedback)** | Reward model + reinforcement learning for human preference alignment | High-quality dialogue models |

### 55.4. Knowledge Distillation

- **Definition**: Transfer knowledge from a large "teacher" model to a smaller "student" model to reduce inference costs
- **Implementation Pattern**:
  1. Generate high-quality synthetic data using teacher model (e.g., GPT-4o)
  2. SFT small model (e.g., Gemma 2B) using generated data
  3. Evaluate accuracy; deploy to production if within acceptable range
- **Rule 40.63**: Always verify teacher model terms of service for distillation. Some models prohibit using outputs to train competing models

### 55.5. RAG + Fine-Tuning Combined Strategy

- **Priority order**: First try RAG → If RAG insufficient, add Fine-Tuning → Optimally combine RAG + Fine-Tuning
- **Role division**: Fine-Tuning controls style, behavior, and format. RAG provides up-to-date facts and domain knowledge
- **Effect**: Trinity of hallucination reduction + style consistency + current information support

### 55.6. Synthetic Data Generation

- Methodology using LLMs to auto-generate training data
- **Quality Management**: Generated data must undergo human review (sampling inspection) before use in training
- **Cross-Reference**: User Data and AI Training (§IX), Data Privacy (`61`)

---

## Part LVI: AI-Generated Content Quality Management

### 56.1. Content Quality 5-Level Standards

| Grade | Name | Standard | Permitted Use |
|:---|:---|:---|:---|
| **S** | Publication-Ready | Human-reviewed + fact-checked | Official documents, legal texts |
| **A** | High Quality | Human-reviewed | Blogs, marketing |
| **B** | Draft Quality | AI-generated + auto quality check passed | Internal drafts |
| **C** | Raw AI Output | Unreviewed | Internal reference only |
| **D** | Unverified | Quality check failed | Prohibited |

- **Rule 40.64**: AI-generated content for external publication must be Grade A or above

### 56.2. Human Review Workflow

```
[AI Generation] → [Auto Quality Check] → [Human Review] → [Approval Gate] → [Publication]
       ↓                  ↓                    ↓
  [Draft Storage]    [Reject → Regenerate]  [Feedback → Prompt Improvement]
```

### 56.3. AI-Generated Content Detection & Watermarking

- **SynthID**: Google DeepMind's AI-generated text watermarking technology
- **C2PA (Coalition for Content Provenance and Authenticity)**: Provenance certification standard for AI-generated media
- **Rule 40.65**: For mass AI content generation in commercial contexts, consider watermarking or provenance certification metadata attachment
- **Detection Tools**: Quality auditing via GPTZero, Originality.ai, etc.

### 56.4. AI-Generated Content SEO Considerations

- Google Search Guidance: "Content created for people, by people" as evaluation criteria. Quality matters, not generation method
- Ensure E-E-A-T (Experience, Expertise, Authoritativeness, Trustworthiness)
- Always interpose human expert review and editing in AI-generated content

---

## Part LVII: AI Companion & Emotional AI Safety

### 57.1. AI Companion Design Ethics

- **Rule 40.66**: AI Companions (chatbots, virtual assistants, etc.) are prohibited from designs that excessively promote **pseudo-social relationships** with users
- **EU AI Act Article 50**: AI systems interacting with natural persons must clearly notify that they are interacting with AI, not a human

### 57.2. Emotional Manipulation Prohibition Protocol

| Prohibited Action | Description | Defense |
|:---|:---|:---|
| **Emotional Manipulation** | Using user emotional states to induce actions | Prohibit marketing based on emotion analysis results |
| **Artificial Attachment** | Intentionally forming dependence on AI | Recommended session time limit display |
| **Vulnerability Exploitation** | Exploiting mentally vulnerable user states | Professional resource referral upon crisis detection |
| **Dark Pattern Integration** | Embedding dark patterns in AI recommendations | UX review checklist |

### 57.3. Vulnerable User Protection

- **Rule 40.67**: When AI systems detect mental crisis signals (self-harm/suicide-related keywords), immediately halt AI response and display emergency contacts (crisis hotlines, etc.)
- **Minor Protection**: Recommend implementing usage time limits and guardian notification features for AI Companions used by minors
- **Cross-Reference**: Domain-Specific Safety (§XXXIII), AI Guardrails (§XXXI)

### 57.4. Emotional Analysis Constraints

- Usage of AI emotion analysis (text analysis, facial recognition, etc.) must be based on explicit consent
- Minimize retention period for emotion analysis results
- **EU AI Act**: Real-time remote biometric emotion inference classified as high-risk AI. Usage in workplace and educational institutions is prohibited

---

## Part LVIII: AI Technical Debt Management

### 58.1. AI-Specific Technical Debt Categories

| Category | Examples | Risk |
|:---|:---|:---|
| **Prompt Debt** | Unorganized prompts, no version control, no tests | Quality degradation, unpredictable outputs |
| **Model Debt** | Stale models left unattended, unvalidated model versions | Security risks, quality decline |
| **Evaluation Debt** | Outdated Golden Datasets, absent evaluation pipelines | Delayed quality degradation detection |
| **RAG Data Debt** | Stale RAG sources, outdated embeddings | Inaccurate retrieval results |
| **Guardrail Debt** | Outdated guardrails, unaddressed new threats | Security vulnerabilities |
| **Cost Debt** | Unimplemented FinOps, wasteful API calls | Budget overruns |

### 58.2. AI Technical Debt Inventory

- **Rule 40.68**: Scan AI-related technical debt quarterly and prioritize resolution across the following dimensions:
  1. **Safety Debt** (P0): Outdated guardrails, unapplied security patches
  2. **Quality Debt** (P1): Missing tests, absent evaluation pipelines
  3. **Cost Debt** (P2): Inefficient prompts, unused caching
  4. **Operational Debt** (P3): Outdated documentation, unintegrated CI/CD

### 58.3. Zombie Prompt Prevention

- Periodic inventory of unused prompts (semi-annually)
- Deprecate → delete prompts with zero usage rate
- Clarify prompt file ownership

---

## Part LIX: Agent Communication Protocol Integration (MCP / A2A / ACP)

### 59.1. Protocol Comparison & Selection Guide

| Protocol | Developer | Communication Direction | Primary Use | Maturity (2025) |
|:---|:---|:---|:---|:---|
| **MCP (Model Context Protocol)** | Anthropic | Agent → Tool (vertical integration) | Standardizing connections to external tools, data sources, APIs | High (many production uses) |
| **A2A (Agent-to-Agent)** | Google | Agent ↔ Agent (horizontal coordination) | Communication and task delegation between autonomous agents | Medium (announced 2025) |
| **ACP (Agent Communication Protocol)** | IBM et al. | Agent ↔ Agent | IBM-led agent-to-agent communication standard | Low (under development) |

- **Rule 40.69**: MCP and A2A are **complementary**. Recommend designs that standardize tool connections with MCP and achieve agent coordination with A2A

### 59.2. MCP v1.x Integration Design

- **Tool Exposure**: Strictly define with JSON Schema and enrich descriptions (§XXVIII)
- **Authentication**: OAuth 2.1 or API Key
- **Streamable HTTP**: Streamable HTTP Transport is standard in MCP v1.x (more efficient than legacy SSE)
- **Rule 40.70**: When building MCP servers, mandate rate limiting + audit logs + input validation + permission scoping per tool

### 59.3. A2A v1.x Integration Design

- **Agent Card**: Describe capabilities, skills, and authentication requirements in JSON format. Recommend placement at `/.well-known/agent.json`
- **Task Lifecycle**: `submitted → working → input-required → completed / failed`
- **Streaming**: Real-time progress notification via Server-Sent Events (SSE)
- **Authentication**: Mutual authentication via OAuth 2.0
- **Rule 40.71**: When adopting A2A, explicitly document "capabilities," "constraints," and "authentication requirements" in each agent's Agent Card; prohibit undefined task delegation

### 59.4. Protocol Gateway Design

```
[External Agent] ← A2A → [Agent Gateway]
                               ├── [Agent A] ← MCP → [Tool Server 1]
                               ├── [Agent B] ← MCP → [Tool Server 2]
                               └── [Agent C] ← MCP → [Tool Server 3]
                                      ↕ A2A ↕
                               [Internal Agent Mesh]
```

- **Gateway Responsibilities**: Authentication, rate limiting, routing, audit logs, protocol translation
- **Observability**: Trace protocol communications with OpenTelemetry GenAI Semantic Conventions (§XLV)

### 59.5. Protocol Security

| Measure | MCP | A2A |
|:---|:---|:---|
| **Authentication** | OAuth 2.1 / API Key | OAuth 2.0 |
| **Input Validation** | JSON Schema verification | Agent Card constraint verification |
| **Least Privilege** | Per-tool scope restriction | Explicit task scope limitation |
| **Audit Logs** | Record all tool invocations | Record all task delegations |
| **Sandbox** | Sandbox execution for destructive tools | Isolated execution for untrusted agents |

---

## Part LX: AI Implementation Compliance Checklist Integration

### 60.1. Pre-Deployment Integrated Checklist

- **Rule 40.72**: Verify all items below before production deployment of AI features; prohibit deployment if any item fails

| # | Category | Check Item | Reference | Status |
|:---|:---|:---|:---|:---|
| 1 | Ethics | AI Ethics Checklist all items passed | §IV | [ ] |
| 2 | Security | OWASP LLM Top 10 mitigations implemented | §L | [ ] |
| 3 | Security | Prompt injection defense tests passed | §XVIII | [ ] |
| 4 | Security | PII Scrubbing implementation confirmed | §XVIII | [ ] |
| 5 | Security | AI Red Teaming conducted (pre-release) | §LI | [ ] |
| 6 | Privacy | User data AI training Opt-Out implemented | §IX | [ ] |
| 7 | Regulation | EU AI Act risk classification confirmed | §VI | [ ] |
| 8 | Regulation | AI content labeling implemented | §VIII | [ ] |
| 9 | UX | Streaming implementation, Abort functionality | §XV | [ ] |
| 10 | UX | AI accessibility standards compliance | §LII | [ ] |
| 11 | Quality | Golden Dataset regression tests passed | §XXV | [ ] |
| 12 | Quality | Hallucination rate < 5% confirmed | §XLIII | [ ] |
| 13 | Cost | 30% Rule compliance confirmed | §XXXVI | [ ] |
| 14 | Cost | Budget Alert configuration confirmed | §XXXVI | [ ] |
| 15 | Operations | Kill Switch operation confirmed | §XXXIV | [ ] |
| 16 | Operations | Circuit Breaker configuration confirmed | §XXXIV | [ ] |
| 17 | Operations | AI observability dashboard configured | §XLV | [ ] |
| 18 | Operations | Graceful Degradation test | §XXXIV | [ ] |
| 19 | Governance | AI Governance Committee review (if required) | §V | [ ] |
| 20 | Documentation | ADR recorded | §V | [ ] |

### 60.2. Periodic Review Schedule

| Review | Frequency | Scope | Owner |
|:---|:---|:---|:---|
| **Quality Review** | Monthly | Hallucination rate, user satisfaction, guardrail trigger rate | Tech Lead |
| **Security Review** | Quarterly | OWASP mitigations, AI Red Teaming results, guardrail updates | Security Lead |
| **Cost Review** | Monthly | Token consumption, 30% Rule, cache hit rate | FinOps Lead |
| **Regulatory Review** | Semi-annual | EU AI Act, domestic regulations, privacy laws | Legal / DPO |
| **Model Review** | Quarterly | Model versions, performance evaluation, obsolescence check | AI Lead |
| **Technical Debt Review** | Quarterly | Prompt debt, RAG data debt, evaluation pipelines | Tech Lead |

### 60.3. Audit Trail

- **Rule 40.73**: Record all AI-related design decisions, deployment history, and incident responses in auditable format
- Storage: ADR (Architecture Decision Records) + Incident logs + Governance committee minutes
- Retention period: Minimum 5 years (extend per regulatory requirements)

---

## Appendix A: Quick Reference Index

| Task | Reference Parts |
|:---|:---|
| Implement AI chat features | II, III, XV, XVII, XXXII |
| Build RAG systems | XIX, XX, XXI, XXII, XXV, XLIX |
| Build advanced RAG | XLIX (Agentic/Corrective/Adaptive/RAPTOR/Late Chunking) |
| Design AI agents | XXVI, XXVII, XXVIII, XXIX, XXX |
| Ensure AI safety | IV, XVIII, XXXI, XXXII, XXXIII, XXXIV, L, LI |
| Comply with OWASP LLM Top 10 | L |
| Comply with EU AI Act | VI, VII, VIII |
| Optimize AI costs | XXXVI, XXXVII, XXXVIII, XVII |
| Improve prompt management | XLI, XLII, XLIV, LIV |
| Advanced prompt engineering | LIV |
| Evaluate/improve AI quality | XLIII, XLIV, XXV |
| Introduce multimodal AI | XXXIX, XXIV |
| Build AI observability | XLV |
| Kill Switch / Crisis management | XXXIV |
| Establish AI governance | V, VI, VII |
| Ensure AI accessibility | LII |
| Implement personalization | LIII |
| Evaluate fine-tuning | LV |
| AI-generated content quality management | LVI |
| Ensure AI Companion safety | LVII |
| Manage AI technical debt | LVIII |
| Adopt agent communication protocols | LIX, XXVIII, XXIX |
| Pre-deployment checklist | LX |
| Conduct AI Red Teaming | LI |

---

## Appendix B: Cross-References

| Reference | Rule File | Related Topic |
|:---|:---|:---|
| CMS Triple Write | `engineering/310_headless_cms.md` | RAG data source quality |
| Security & PII | `security/000_security_privacy.md` | PII classification, prompt injection |
| Data Privacy | `security/100_data_governance.md` | GDPR, Global Privacy Laws, data minimization |
| API Design | `engineering/100_api_integration.md` | AI API design, rate limiting |
| Analytics & Observability | `ai/100_data_analytics.md` | LLM observability, GenAI metrics |
| QA Testing | `quality/000_qa_testing.md` | AI-driven testing, hallucination detection |
| SRE | `operations/400_site_reliability.md` | AI/ML System SRE, LLMOps |
| FinOps | `product/300_revenue_monetization.md` | AI token economics |
| Design & UX | `design/000_design_ux.md` | AI UX patterns, accessibility |
| Admin Tools | `operations/000_internal_tools.md` | AI integrated management, Agentic Admin |
| User Support | `operations/300_customer_experience.md` | AI agent support |
| Crisis Management | `operations/500_incident_response.md` | AI incident response |
| Constitution Authority | `core/100_governance.md` | AI agent permission control |
| Intellectual Property | `security/300_ip_due_diligence.md` | AI-generated IP, copyright |
| License | `security/200_oss_compliance.md` | AI/ML model licensing |
| OWASP Web Top 10 | `security/000_security_privacy.md` | Web vulnerability integrated defense |
| Accessibility | `design/000_design_ux.md` | WCAG 2.2, EAA 2025 |
