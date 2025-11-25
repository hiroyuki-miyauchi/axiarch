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

## 2. AI Ethics & Safety
*   **Safety Settings**:
    *   **Filtering**: Set Gemini/OpenAI safety settings (harassment, hate speech, sexual content) to "Highest Level" in principle.
    *   **Jailbreak Protection**: Strictly distinguish user input within system prompts to prevent prompt injection attacks.
*   **Hallucination Mitigation**:
    *   **Disclaimer**: Always display a disclaimer that "AI may generate inaccurate information".
    *   **Citations**: If possible, present sources (citations) that ground the answer (in case of RAG).
*   **Reporting**:
    *   Always implement a feature for users to report/block inappropriate content in GenAI apps (Google Play 2025 Requirement).

## 3. Technical Architecture
*   **Context Window Management**:
    *   **Token Saving**: Do not send infinite conversation history; extract and send only summaries or important context.
    *   **Cost Optimization**: Always monitor input token count and remove unnecessary information from prompts.
*   **Prompt Engineering**:
    *   **Version Control**: Treat prompts as code and version control them with Git.
    *   **Structured Output**: Use JSON mode for AI responses as much as possible to prevent parse errors.
*   **Caching**:
    *   Cache AI answers for the same input to reduce API costs and latency (Semantic Caching).

## 4. Multimodal & Edge AI
*   **Tech Stack**:
    *   **Web**: Use **TensorFlow.js** or **ONNX Runtime Web** to complete inference within the browser.
    *   **Mobile**: Use **CoreML** (iOS) and **TensorFlow Lite** (Android) to ensure native performance and privacy.
*   **Vision**:
    *   **Privacy**: Perform image analysis on the client side (On-Device AI) as much as possible to minimize transmission to server. Ideally, "Raw Image Data" should not leave the device.
    *   **Accessibility**: Always support `alt` text and voice reading for analysis results.
*   **Voice**:
    *   **Latency**: Provide immediate feedback for voice input (waveform animation, etc.) to visually convey that recording is in progress.
    *   **Misrecognition**: Do not complete critical actions (transfer, delete) by voice alone; always interpose a confirmation step on the screen.

## 5. Evaluation & Improvement
*   **Automated Evaluation**:
    *   Introduce a mechanism to quantitatively evaluate "Quality of Answer" (LLM-as-a-Judge).
*   **User Feedback**:
    *   Place "Good/Bad" buttons for each answer to collect user feedback. Use this for next fine-tuning or prompt improvement. Collect data for RLHF (Reinforcement Learning from Human Feedback).
