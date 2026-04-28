# 40. AI Implementation & UX Strategy

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-03-24

> [!IMPORTANT]
> **Supreme Directive**
> "AI is a tool; operational responsibility always rests with humans."
> In AI feature implementation, strictly adhere to the priority order: **Safety > Reliability > UX > Cost Efficiency > DX**.
> This document is the supreme standard for all AI-related design decisions.
> **48 Parts, 60 Sections.**

---

## Table of Contents

- Part I: Supreme Directive & AI Philosophy
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

## Part I: Supreme Directive & AI Philosophy

### 1.1. Supreme Principles of AI Implementation

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

### 6.3. AI Literacy Requirement

- **Rule 40.7**: Address the EU AI Act "AI Literacy" requirement (effective Feb 2025) by confirming all team members developing/operating AI features have foundational AI knowledge
- Recommend implementing training programs with documentation

### 6.4. Digital Omnibus Package (Proposed November 2025)

- Compliance deadlines for high-risk AI systems may be extended to December 2027 or August 2028
- **Caution**: Proceed with current timelines until formal adoption
- European Parliament plenary vote: scheduled March 26, 2026

### 6.5. Penalties

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
| **RAG Citation** | `📎 Reference: [Source Name](URL)` | Responses based on externally retrieved RAG information |
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

### 13.3. Token Budget Allocation

```
Total Context Window Budget:
├── System Prompt:     15-20% (fixed)
├── RAG Context:       30-40% (dynamic)
├── Conversation History: 20-30% (sliding)
├── User Input:        10-15% (latest turn)
└── Safety Buffer:     5-10% (margin)
```

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

### 18.3. API Key Management

- **No Client Exposure**: Exposing AI API keys with `NEXT_PUBLIC_` prefix is strictly prohibited
- **Rotation**: Rotate API keys every 90 days
- **Vault Integration**: Integrate with secret management tools (Vault, AWS Secrets Manager, etc.)

### 18.4. Grounding & Fact-Check Standards

- **Rule 40.22**: Facts such as store information and prices must be cross-referenced (Grounded) with confirmed DB data, and sources must be cited
- **Numeric Data Rule**: Numeric data (prices, distances, quantities) is permitted only from direct RAG source or DB citations. AI calculation/speculation is prohibited
- **RAG Source Absence Protocol**: When sources cannot be retrieved, auto-append "This information is for reference only. Accuracy is not guaranteed"

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

### 19.3. Embedding Model Selection

| Criteria | Considerations |
|:---|:---|
| **Multilingual Support** | Must generate high-quality embeddings for both Japanese and English |
| **Dimensions** | Higher dimensions (1536+) improve accuracy; lower dimensions favor cost/speed |
| **Cost** | Consider costs when indexing large document volumes |
| **Update Frequency** | Evaluate re-indexing costs when model updates occur |

### 19.4. Indexing Strategy

- **Vector DB Selection**: pgvector (PostgreSQL integration), Pinecone, Weaviate, Qdrant, etc.
- **Metadata Filtering**: Combine vector search with metadata filters for precise retrieval
- **Periodic Index Updates**: Incremental index updates triggered by source document changes

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

### 36.3. AI Cost Monitoring & Alerting Protocol

- **Rule 40.39**: Mandate the following cost monitoring framework
  1. **Usage Tracking Table**: Aggregate daily/monthly token consumption in `ai_usage_tracking` table
  2. **Budget Alert**: Auto-fire Slack/email alerts when monthly budget reaches **80%**
  3. **Cost Attribution**: Enable AI usage cost attribution by user/feature/tier
  4. **FinOps Dashboard**: Visualize cost trends, per-user costs, cache hit rates

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

### 37.3. Over-Limit Strategy

- Flexible overage handling via point billing (pay-as-you-go)
- Display countdown to next reset

---

## Part XXXVIII: Token Cost Optimization

### 38.1. Prompt Compression Techniques

- **Remove unnecessary modifiers/redundant expressions**: Periodically review and optimize system prompts
- **Abbreviation Strategy**: Replace frequently occurring patterns with shortened expressions
- **Strict Field Selection Application**: Minimize fields during RAG retrieval to reduce prompt tokens

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
| CMS Triple Write | `341_headless_cms.md` | RAG data source quality |
| Security & PII | `600_security_privacy.md` | PII classification, prompt injection |
| Data Privacy | `601_data_governance.md` | GDPR, Global Privacy Laws, data minimization |
| API Design | `301_api_integration.md` | AI API design, rate limiting |
| Analytics & Observability | `401_data_analytics.md` | LLM observability, GenAI metrics |
| QA Testing | `700_qa_testing.md` | AI-driven testing, hallucination detection |
| SRE | `502_site_reliability.md` | AI/ML System SRE, LLMOps |
| FinOps | `101_revenue_monetization.md` | AI token economics |
| Design & UX | `200_design_ux.md` | AI UX patterns, accessibility |
| Admin Tools | `500_internal_tools.md` | AI integrated management, Agentic Admin |
| User Support | `501_customer_experience.md` | AI agent support |
| Crisis Management | `503_incident_response.md` | AI incident response |
| Constitution Authority | `801_governance.md` | AI agent permission control |
| Intellectual Property | `603_ip_due_diligence.md` | AI-generated IP, copyright |
| License | `602_oss_compliance.md` | AI/ML model licensing |
| OWASP Web Top 10 | `600_security_privacy.md` | Web vulnerability integrated defense |
| Accessibility | `200_design_ux.md` | WCAG 2.2, EAA 2025 |
