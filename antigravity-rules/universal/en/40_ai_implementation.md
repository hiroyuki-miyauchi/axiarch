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
*   **Privacy & Bias**:
    *   **PII Scrubbing**: Prompts sent to external LLMs must NOT contain PII (Phone, Name). Use regex masking (`[Contact Removed]`) before sending.
    *   **The Fairness Protocol (Bias Mitigation)**:
        *   **Law**: Explicitly control system prompts to prevent generating biased or discriminatory responses against specific attributes (race, gender, or specific categories like breeds).
        *   **Action**: Monitor use of bias-containing adjectives like "dangerous" or "inferior" and enforce neutral expressions.
*   **Reporting**:
    *   Always implement a feature for users to report/block inappropriate content in GenAI apps (Google Play 2025 Requirement).

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

## 7. Evaluation & Improvement
*   **PromptOps Workflow**:
    *   **Git-Based Versioning**: Manage prompt changes via PR. Make "Who, When, Why changed" traceable.
    *   **Regression Testing**: Perform regression testing using "Golden Dataset" upon changes to prevent quality degradation.
*   **Automated Evaluation (LLM-as-a-Judge)**:
    *   Introduce automated evaluation using superior models as "Judges" to assess answer quality, and use it as deployment criteria.
