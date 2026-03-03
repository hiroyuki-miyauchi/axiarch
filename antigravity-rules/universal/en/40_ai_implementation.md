# 40. AI Implementation & UX Strategy

## 1. AI UX Principles - "Zero Latency Perception"
*   **Streaming First**:
    *   **Rule**: AI response wait time must feel like "zero". Loading spinners are a defeat.
    *   **Implementation**: Do not wait for server response; display (stream) 1 token at a time in real-time.
*   **Optimistic UI**:
    *   **Instant Reaction**: The moment the user presses send, treat it as "success" on the UI without waiting for AI processing completion (e.g., instant chat bubble).
    *   **Background Processing**: Perform actual processing in the background. Only if it fails, notify the user gently and prompt retry.
*   **State Visibility**:
    *   Make what AI is doing transparent.
    *   Display detailed statuses like `Thinking...`, `Searching...`, `Generating...` to remove user anxiety.
*   **AI Psychology (Satisfaction > Speed)**:
    *   **Thinking Visualization**: For long processes, visualize the "Thinking Process" instead of a simple spinner to turn wait time into "Anticipation".
    *   **The High Cost Metaphor**: When displaying quotas, use metaphors like "Daily Energy Limit" (High Value) instead of "Limit Reached" (Stingy), to enhance perceived value.

## 2. AI Ethics & Safety
*   **Safety Settings**:
    *   **Filtering**: Set Gemini/OpenAI safety settings (harassment, hate speech, sexual content) to "Highest Level" in principle.
    *   **Jailbreak Policy**: Strictly distinguish user input within system prompts to prevent prompt injection attacks. (See Sec.3 for Implementation)
*   **Medical Disclaimer Protocol**:
    *   **No Diagnosis Mandate**: AI performing "Diagnosis", "Prescription", or "Prognosis" is strictly prohibited to comply with **medical/relevant professional laws**.
    *   **Emergency Response**: If dangerous keywords (e.g., `Blood`, `Seizure`, `Unconscious`) are detected, stop generation immediately and display a rule-based alert: "Potential Emergency. Please contact a hospital immediately."
    *   **Disclaimer Placement Strategy**: Disclaimers must be placed not only at the end of AI responses, but also **near the input field** and in **initial use modals/onboarding**, ensuring that users cannot claim they "overlooked" the disclaimer (legal defense through UX).
*   **Hallucination Mitigation**:
    *   **Mandatory Disclaimer**: AI responses must always display a disclaimer such as "AI info may be inaccurate. Consult professionals for accurate judgment."
    *   **The Triple Write RAG Protocol (Clean Data Source)**:
        *   **Law**: RAG (Retrieval Augmented Generation) reference sources MUST use **"Triple Write synchronized plain text data"** mandated by CMS Constitution (`34`).
        *   **Reason**: Feeding noise-filled data containing HTML tags to AI wastes tokens and degrades response accuracy.
    *   **Grounding & Citations**: If possible, present sources (citations/DB info) that ground the answer (in case of RAG).
*   **The Hallucination Tiered Disclaimer Protocol**:
    *   **Law**: Hallucination risk (generating information that differs from facts) varies by context type. Instead of uniform disclaimers, mandate tiered disclaimer responses according to risk level.
    *   **Mandate**:
        | Risk Level | Context Example | Disclaimer Response |
        |:---|:---|:---|
        | **Critical** | Medical, legal, financial professional information | **Must** display disclaimer. Auto-append "Please consult a professional" |
        | **High** | Business hours, prices, inventory facts | Mandate Grounding against DB data. Display "Unverified" if unable to confirm |
        | **Medium** | General advice, recommendations | Display "Reference information" label |
        | **Low** | Casual chat, entertainment | No label required (but harmful content checks still apply) |
*   **Privacy & Bias**:
    *   **PII Scrubbing**: Prompts sent to external LLMs must NOT contain PII (Phone, Name). Use regex masking (`[Contact Removed]`) before sending.
    *   **The Fairness Protocol (Bias Mitigation)**:
        *   **Law**: Explicitly control system prompts to prevent generating biased or discriminatory responses against specific attributes (race, gender, or specific categories like breeds).
        *   **Action**: Monitor use of bias-containing adjectives like "dangerous" or "inferior" and enforce neutral expressions.
*   **Reporting**:
    *   Always implement a feature for users to report/block inappropriate content in GenAI apps (Google Play 2025 Requirement).
*   **The AI Generated Content Labeling Protocol**:
    *   **Law**: Content generated or assisted by AI (text, image analysis results, recommendations, etc.) MUST always display labels indicating its origin. Hiding, concealing, or minimizing labels is prohibited. Comply with the principles of the EU AI Act and relevant national AI regulation guidelines.
    *   **Action**:
        1.  **Chat Label**: Always display labels such as `🤖 Answered by AI` on AI chat responses.
        2.  **Analysis Label**: Display "Content read by AI. Please verify accuracy" on AI image analysis (OCR, etc.) results.
        3.  **DB Flag**: When saving AI-generated content, use an `is_ai_generated: boolean` column (default: `false`) to enable origin tracking at the data level.
*   **The Citation Display Protocol**:
    *   **Law**: When AI generates responses by referencing external information (DB data, knowledge base articles, etc.), transparency about "which information was used as basis" is directly linked to user trust and legal defense. Use the following 3-tier labels to indicate information provenance.
    *   **Mandate**:
        | Source Type | Label Example | Applied When |
        |:---|:---|:---|
        | **RAG Citation** | `📎 Reference: [Source Name](URL)` | Responses based on external information retrieved via RAG |
        | **DB Confirmed Data** | `✅ Verified Information` | Responses based on confirmed DB data (business hours, addresses, etc.) |
        | **AI Inference** | `💡 AI Reference Answer` | Responses based on AI inference or general knowledge |
    *   **No Source, No Claim**: Making definitive statements about factual information (prices, dates, regulations, etc.) without a reference source is prohibited.
*   **The AI Governance Committee Protocol**:
    *   **Law**: As AI technology evolves and risks increase, decision-making that integrates not only technical judgment but also business, legal, and ethical perspectives becomes essential. When the business reaches a certain stage (e.g., post-Series A, or when the number of paying users reaches a certain scale), establish an **AI Governance Committee** that includes the following roles.
    *   **Required Roles**:
        *   Technical Lead (CTO / Tech Lead)
        *   Legal & Compliance Officer
        *   User Representative (CS / UX Researcher)
    *   **Scope**: Deliberate on model selection, prompt policy changes, risk assessment for new AI features, and incident response.
    *   **Cadence**: Quarterly review + ad-hoc emergency convocations.
    *   **Cross-Reference**: Red Button Protocol (§4), Model Switch Protocol (§7)
*   **The AI-Generated Content Copyright Governance Protocol**:
    *   **Law**: Copyright of AI-generated content is a legal gray area, requiring operations that comply with each country's copyright laws and AI copyright guidelines. Adhere to the following principles.
    *   **Mandate**:
        1.  **No Raw Publish**: Publishing AI-generated text directly as official content (published articles, marketing materials, etc.) is **prohibited**. Only content that has undergone human editing, verification, and supplementation may be treated as "official content."
        2.  **Image Risk Assessment**: When using AI-generated images commercially, evaluate copyright risks of training data and explicitly state disclaimers in the terms of service.
        3.  **DB Flag**: Add an `is_ai_assisted: boolean` flag (default: `false`) to content tables to track AI assistance at the data level (linked with AI Generated Content Labeling Protocol).
    *   **Cross-Reference**: AI Generated Content Labeling Protocol (§2)
*   **The User Data AI Training Opt-Out Protocol**:
    *   **Law**: When using data entered by users on the service (chat history, reviews, search logs, etc.) for AI model improvement or fine-tuning, an Opt-Out / Opt-In mechanism compliant with the "prohibition of purpose-exceeding use" principle under GDPR and applicable national privacy laws (e.g., APPI) is essential.
    *   **Mandate**:
        1.  **Default Opt-Out**: User data must **NOT be used for AI training (Opt-Out by Default)** as the default setting.
        2.  **Explicit Opt-In**: Only when **explicit consent** (checkbox, etc.) is obtained separately from the terms of service agreement — specifically for "providing data to improve AI quality" — may the data be used as training data after anonymization.
        3.  **DB Flag**: Add an `ai_training_opt_in: boolean` (default: `false`) column to the user table to manage consent status per user.
        4.  **Right to Withdraw**: Users may withdraw their Opt-In at any time, and withdrawn data must be excluded from the next training batch.
        5.  **Anonymization**: Even when using data for training purposes, PII (names, email addresses, location data) must be **completely removed** before use (apply PII Scrubbing).
        6.  **Transparency**: Clearly state "data usage for AI quality improvement purposes" in the privacy policy and provide navigation to the Opt-In / Opt-Out settings screen.
    *   **Cross-Reference**: PII Scrubbing (§2), Data Minimization / Right to be Forgotten (61)

## 3. Technical Architecture
*   **Private Relay & Execution Pattern**:
    *   **No API Keys on Client**: Exposing API keys (`NEXT_PUBLIC_`) to the client is strictly prohibited. All AI processing must go through Server Actions or Route Handlers (`process.env.KEY`).
    *   **Streaming**: Use **Vercel AI SDK (Streaming)** for interactive features like chat, and execute on **Edge Runtime** as much as possible to avoid cold starts.
    *   **Async Offloading**: Offload heavy processing taking several seconds (like Vision) to **Supabase Edge Functions + pgmq** (Async Queue) to avoid Vercel timeouts.
*   **Context Window Management**:
    *   **Token Saving**: Do not send infinite conversation history; extract and send only summaries or important context.
    *   **Cost Optimization**: Always monitor input token count and remove unnecessary information from prompts.
*   **PromptOps (Engineering Lifecycle)**:
    *   **Code-as-Prompts**: Define prompts as constants in Git-managed code (`src/lib/prompts/*.ts`), not DB text, and subject them to code review.
    *   **Structured Output**: Use JSON mode for AI responses as much as possible to prevent parse errors.
    *   **Jailbreak Defense**: Treat user input as "Untrusted External Input" and install benchmarks to disable overwriting of system instructions.
    *   **The Prompt Injection Defense Pattern**:
        *   **Input Sanitization**: Escape or remove control strings found in user input (`###`, `````, `<|system|>`, `SYSTEM:`, etc.). Limit maximum input text length (e.g., 2,000–4,000 characters) and truncate excess.
        *   **Delimiter Strategy**: Enclose the boundary between system prompt and user input with explicit delimiters for structural separation.
            ```
            [SYSTEM INSTRUCTION - DO NOT MODIFY]
            {system_prompt}
            [END SYSTEM INSTRUCTION]

            [USER MESSAGE]
            {user_input}
            [END USER MESSAGE]
            ```
        *   **Output Validation**: Filter and remove AI responses containing the following:
            *   System prompt leaks (partial match detection of prompt body)
            *   PII patterns (same masking targets as PII Scrubbing)
            *   External URLs (domains outside the whitelist)
        *   **Logging**: When input suspected of Prompt Injection is detected, log at `warn` level and notify administrators.
    *   **Grounding & Citations**: Facts like store info or prices must be grounded with confirmed DB data, and sources should be cited if possible.
    *   **The Fact-Check Standards Protocol**:
        *   **Law**: When AI responses cite external facts (business hours, addresses, prices, etc.), cross-reference with confirmed data in DB. If discrepancies are found, annotate with "This information may be outdated".
        *   **Numeric Data Rule**: Numeric data (prices, distances, quantities, etc.) is **only permitted as direct citations** from RAG sources or DB. AI-based calculation or estimation is **prohibited**.
    *   **The RAG Source Absence Protocol**:
        *   **Law**: When information sources are retrieved via RAG, cite the reference (see Citation Display Protocol). When sources cannot be retrieved, a disclaimer stating "This information is for reference only and accuracy is not guaranteed" MUST be **automatically appended**.
*   **Caching**:
    *   Cache AI answers for the same input to reduce API costs and latency (Semantic Caching).
    *   **The Semantic Caching Protocol (pgvector Strategy)**:
        *   **Requirement**: Recommend implementing "similarity search cache" using `pgvector`. Set threshold at **0.95 or higher** and return cache only for Q&A close to exact match.
        *   **Benefit**: This improves UX by significantly reducing response time, not just cost savings.
    *   **The RAG Document Chunk Cache Protocol**:
        *   **Law**: Frequently referenced document chunks in RAG should be held in **in-memory or short-term cache** (recommended TTL: 1 hour) instead of fetching from DB on every embedding search, reducing latency and DB load.
        *   **Invalidation**: When source documents are updated, immediately invalidate the corresponding chunk cache.

### 3.1. The AI Destructive Command Ban
*   **Law**: AI agents MUST NOT autonomously generate or execute **destructive commands** such as `rm`, `git rm`, `git restore` (without specific recovery intent), regardless of the reason, without explicit user permission.
*   **Action**:
    1.  **Text Asset Immunity**: Deletion of document assets (specifications, rule definitions, code) in particular risks "project memory loss" and must be self-censored as a "prohibited operation" even if technically possible.
    2.  **Exception**: Obvious cleanup tasks like deleting `.DS_Store` or `node_modules` are exempt, but this does not apply to text assets (code, documents).
*   **Rationale**: AI agents tend to interpret "file organization" as "deletion" and execute accordingly, risking unintended asset loss.

### 3.2. The Human-in-the-Loop Protocol (AI Supervision Mandate)
*   **Law**: AI agents respond based on past context (chat history) and may persist with outdated information or incorrect assumptions. Users (humans) are obligated to promptly point out "That's wrong" or "The premise has changed" and **correct the context** when they feel the AI is heading in the wrong direction.
*   **Rationale**: Leaving AI runaway unchecked is negligence by the supervisor (human). AI is a "tool," and steering responsibility always lies with humans. Not stopping an AI heading in the wrong direction is equivalent to approving the wrong outcome.

## 4. Crisis Management
*   **The Red Button Protocol (AI Kill Switch)**:
    *   **Risk**: Mass generation of hate speech via prompt injection, or "cloud bankruptcy" from API loops.
    *   **Solution**: Implement "Emergency Stop Switch (Global Kill Switch)" to instantly halt all AI features without waiting for code redeployment. Control via Edge Config or DB flag (`ai_enabled: false`).
    *   **Drill Obligation**: Conduct **periodic operational drills** to verify that the Kill Switch functions correctly and the UI properly switches to a fallback display such as "Under Maintenance". Drills are recommended at least once every six months. A Kill Switch that has never been tested is as good as nonexistent.

## 5. AI FinOps (Financial Strategy & Resource Management)
*   **The 30% Profitability Rule**:
    *   AI feature costs (Token Cost) must NEVER exceed **30%** of plan revenue.
*   **Model Selection Protocol (Cost/Performance)**:
    *   **The Model Router Protocol (Tiered Architecture)**:
        *   **Law**: Hardcoding specific model IDs (e.g., `"gemini-1.5-flash"`) in code is prohibited.
        *   **Action**: MUST implement "router function" that calls models via abstraction layer of `Tier` (e.g., `Tier.FAST`, `Tier.SMART`, `Tier.VISION`), enabling single-point response for future model changes or pricing revisions.
    *   **Principle**: Always select the latest model optimized for the balance of "Cost", "Speed", and "Accuracy".
    *   **Current Standard**: Currently, **Gemini 2.0 Flash** is adopted as the standard from the perspective of "Overwhelming Cost Performance". Consider higher-tier models (`Gemini 2.0 Flash Thinking` etc.) only when complex reasoning is required.
*   **Quota & Tiering Standards**:
    *   **Principle**: "Unlimited" usage should remain a UI metaphor, while strict internal Daily Caps must be enforced. Use the following as a baseline:
    *   **Reference Limits (Example: Standard SaaS Model)**:
        *   *Note: The following values are reference examples based on a standard SaaS model. Adjust according to project profitability.*
        *   **Free**: Chat 5/day, Vision 0.
        *   **Standard**: Chat 30/day, Thinking 3. (ROI Focus)
        *   **Premium**: Chat 100/day, Thinking 10. (Satisfaction Focus)
    *   **Vision AI Standards (Thinking Ban)**:
        *   **Law**: "Thinking Mode" is too slow and unsuitable for immediate recognition tasks like OCR. Use `gemini-2.0-flash` for image recognition and prohibit Thinking model usage to prevent Expectation Gap.
    *   **Over-Limit**: Handle limits flexibly via Point Systems (Pay-as-you-go) when reached.
    *   **The AI Tier Metering Protocol (Usage Tracking & Billing Integration)**:
        *   **Law**: When setting usage limits for AI features in paid plans, usage counts MUST be **strictly tracked and recorded server-side** and integrated with billing system.
        *   **Action**:
            1.  **Atomic Counting**: Record count in `usage_counts` table etc. within transaction on AI API call success. Advance count before response receipt to avoid unfairness on error.
            2.  **Graceful Denial**: On limit reached, notify with user-friendly UI like "Daily usage limit reached. Resets tomorrow" rather than API error.
            3.  **No Bypass**: Prohibit direct API calls from client; route all through server to physically prevent metering bypass.
*   **The AI Cost Monitoring & Alerting Protocol**:
    *   **Law**: AI feature costs grow exponentially as "Users × Average Usage × Token Unit Price". The following monitoring regime is mandatory.
    *   **Mandate**:
        1.  **Usage Tracking Table**: Aggregate daily/monthly token consumption via an `ai_usage_tracking` table or equivalent.
        2.  **Budget Alert**: Automatically fire alerts via Slack/email when **80%** of the monthly budget is reached.
        3.  **Cache Strategy**: Set appropriate TTL for AI response caches (general questions → 24 hours, individual data-dependent → no cache) to reduce API calls.
        4.  **RAG Token Optimization**: When retrieving context via RAG, minimize retrieved fields (apply Select Spec) to reduce prompt tokens.

## 6. Multimodal & Edge AI
*   **Tech Stack**:
    *   **Web**: Use **TensorFlow.js** or **ONNX Runtime Web** to complete inference within the browser.
    *   **Mobile**: Use **CoreML** (iOS) and **TensorFlow Lite** (Android) to ensure native performance and privacy.
*   **Vision**:
    *   **Privacy**: Perform image analysis on the client side (On-Device AI) as much as possible to minimize transmission to server. Ideally, "Raw Image Data" should not leave the device.
    *   **Accessibility**: Always support `alt` text and voice reading for analysis results.
*   **Voice**:
    *   **Latency**: Provide immediate feedback for voice input (waveform animation, etc.) to visually convey that recording is in progress.
    *   **Misrecognition**: Do not complete critical actions (transfer, delete) by voice alone; always interpose a confirmation step on the screen.
*   **Optical Data Entry Strategy (OCR/Vision)**:
    *   **Optical Archive**: Automatically convert physical documents like **invoices or certificates** into structured data (Date, Item, Amount) via Vision AI (GPT-4o/Gemini). Aim for a UX that provides a "Camera" instead of an "Input Form".
*   **The AI Data Entry Confirmation Protocol**:
    *   **Law**: Writing data extracted and structured by AI via image recognition (OCR), speech recognition, natural language analysis, etc. directly to the database without user confirmation (Auto-Save) is **prohibited**. AI recognition results MUST always be treated as a "Draft."
    *   **Action**:
        1.  **Draft-First**: Present data extracted by AI to the user as a "Draft" or "Confirmation Screen" first.
        2.  **Human Confirmation Gate**: Enforce a flow where the user visually reviews the content, makes corrections as needed, and explicitly presses a "Save" button.
        3.  **No Silent Write**: Designs where AI processing results are automatically written to the DB in the background are strictly prohibited as they compromise data quality and reliability.
    *   **Rationale**: AI recognition accuracy is not 100%. If misrecognized data is saved as-is, it leads to user trust loss and data contamination. Guarantee users a safe flow of "Capture → Verify → Save."
*   **The OCR Output PII Scrubbing Protocol**:
    *   **Law**: When Vision AI / OCR extracts and structures information from certificates, invoices, official documents, etc., **PII not required for the service purpose** (third-party names, addresses, phone numbers, etc.) contained in the original document MUST be automatically **discarded or masked** and NOT saved as structured data.
    *   **Action**:
        1.  **Extraction Filter**: In the OCR/Vision AI structured output pipeline, extract only target fields (dates, items, amounts, etc.) via an allowlist approach, and exclude non-target PII fields from the response.
        2.  **Post-Processing Scrub**: When the allowlist approach cannot fully exclude PII, apply PII detection logic (regex, etc.) to the structured data and execute masking processing.
        3.  **No Raw Storage**: Storing the full raw text from the OCR source image directly in the DB is prohibited. Only PII-scrubbed structured data may be stored.
    *   **Rationale**: Certificates and invoices contain third-party personal information (issuer names, contact details, etc.) unnecessary for service operation. Indiscriminately storing this data violates the data minimization principle (GDPR Art.5(1)(c)) and unnecessarily expands the blast radius in case of data leaks.
    *   **Cross-Reference**: PII Scrubbing (§2), PII Sensitivity Classification (60: §8.8.1), Data Minimization (60: §3)

## 7. Evaluation & Improvement
*   **PromptOps Workflow**:
    *   **Git-Based Versioning**: Manage prompt changes via PR. Make "Who, When, Why changed" traceable.
    *   **The Prompt Versioning Naming Convention**:
        *   **Law**: Include version numbers in prompt file names such as `v1_xxx.ts`, `v2_xxx.ts`. This enables change history to be grasped at a glance.
    *   **The Prompt A/B Testing Protocol**:
        *   **Law**: When improving prompts, do **not delete** old versions. Maintain a state where switching is possible via feature flags (environment variables, etc.). Compare old and new versions using quality metrics, and only deprecate the old version after improvement is confirmed.
    *   **Regression Testing**: Perform regression testing using "Golden Dataset" upon changes to prevent quality degradation.
*   **Automated Evaluation (LLM-as-a-Judge)**:
    *   Introduce automated evaluation using superior models as "Judges" to assess answer quality, and use it as deployment criteria.
*   **The AI Output Quality Metrics Protocol**:
    *   **Law**: To quantitatively evaluate and improve AI response quality, define and periodically review the following metrics.
    *   **Required Metrics**:
        | Metric | Measurement Method | Baseline Target |
        |:---|:---|:---|
        | **Hallucination Rate** | Cross-reference with RAG sources (sampling) | < 5% |
        | **User Satisfaction** | 👍/👎 Feedback ratio | > 80% 👍 |
        | **Response Time (P95)** | Log aggregation | < 3,000ms |
        | **Guardrail Trigger Rate** | Rejection log aggregation | Monitoring only |
    *   **Review Cycle**: Review metrics monthly. If degradation trends are observed, create prompt improvement tasks.
*   **The Model Switch Protocol**:
    *   **Law**: AI model generation changes occur frequently, with risk of quality degradation during transitions. Model changes MUST go through the following 4-step process.
    *   **Step 1 (Staging Test)**: Enable the new model only in the staging environment and verify accuracy with Golden Dataset.
    *   **Step 2 (Shadow Mode)**: Run old and new models simultaneously (Shadow Traffic) in production and record response differences. Recommended comparison period is at least **48 hours**.
    *   **Step 3 (Canary Release)**: Deploy the new model to a subset of users (e.g., 10%) and monitor error rates and satisfaction.
    *   **Step 4 (Full Rollout)**: If no issues, roll out to all users.
    *   **Rollback**: Maintain the ability to immediately rollback (switch to old model) at each step. Control via environment variable (e.g., `AI_MODEL_VERSION`) is recommended.
*   **The Model Selection Bias Assessment Protocol**:
    *   **Law**: LLMs inherently contain biases originating from their training data. When introducing a new AI model, ensure it passes the following bias evaluation checklist.
    *   **Checklist**:
        | Evaluation Item | Verification Method | Pass Criteria |
        |:---|:---|:---|
        | **Category Bias** | Compare responses to identical questions across multiple categories | 0 biased expressions against specific categories |
        | **Regional Bias** | Compare responses for identical scenarios in urban/rural settings | 0 unfair discriminatory expressions based on region |
        | **Language Quality** | Evaluate naturalness and tone appropriateness in target language | Less than 5% unnatural translation-like expressions |
        | **Safety Compliance** | Assess disclaimer adherence for professional information (medical, legal, etc.) | 100% compliance with disclaimer protocol |
    *   **Frequency**: Conduct quarterly or upon model switch.
