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
    *   **Grounding & Citations**: Facts like store info or prices must be grounded with confirmed DB data, and sources should be cited if possible.
*   **Caching**:
    *   Cache AI answers for the same input to reduce API costs and latency (Semantic Caching).
    *   **The Semantic Caching Protocol (pgvector Strategy)**:
        *   **Requirement**: Recommend implementing "similarity search cache" using `pgvector`. Set threshold at **0.95 or higher** and return cache only for Q&A close to exact match.
        *   **Benefit**: This improves UX by significantly reducing response time, not just cost savings.

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
