# 120. AI Implementation & UX Strategy

## 1. AI UX Principles ("Zero Latency Perception")
*   **Streaming First**:
    *   **Rule**: AI response wait time must be "perceived zero". Loading spinners are a defeat.
    *   **Implementation**: Display in real-time, one token at a time (streaming), without waiting for the server response to complete.
*   **Optimistic UI**:
    *   **Immediate Reaction**: Treat as "Success" on the UI the moment the user presses the send button, without waiting for AI processing completion (e.g., instant chat bubble).
    *   **Background Processing**: Perform actual processing in the background, and only notify the user gently and prompt for retry if it fails.
*   **State Visibility**:
    *   Make "What AI is doing" transparent.
    *   Display detailed statuses like `Thinking...`, `Searching...`, `Generating...` to remove user anxiety.

## 2. AI Ethics & Safety
*   **Safety Settings**:
    *   **Filtering**: Set safety settings for Gemini/OpenAI (harassment, hate speech, sexual content, etc.) to the "Highest Level" in principle.
    *   **Jailbreak Protection**: Strictly distinguish user input within system prompts to prevent prompt injection attacks.
*   **Hallucination Mitigation**:
    *   **Disclaimer**: Always display a disclaimer that "AI may generate inaccurate information" on AI-generated content.
    *   **Citations**: If possible, present sources (citations) that serve as the basis for the answer (in case of RAG).
*   **Reporting**:
    *   GenAI apps must implement a feature for users to report and block inappropriate content (Google Play 2025 requirement).

## 3. Technical Architecture
*   **Context Window Management**:
    *   **Token Saving**: Do not send infinite conversation history; send only summaries or extracted important contexts.
    *   **Cost Optimization**: Constantly monitor input token counts and remove unnecessary information from prompts.
*   **Prompt Engineering**:
    *   **Version Control**: Treat prompts as code and manage them with Git.
    *   **Structured Output**: Use JSON mode for AI responses whenever possible to prevent parsing errors.
*   **Caching**:
    *   Cache AI responses for the same input to reduce API costs and latency (Semantic Caching).

## 4. Multimodal & Edge AI
*   **Tech Stack**:
    *   **Web**: Use **TensorFlow.js** or **ONNX Runtime Web** to complete inference within the browser.
    *   **Mobile**: Use **CoreML** (iOS) and **TensorFlow Lite** (Android) to ensure native performance and privacy.
*   **Vision**:
    *   **Privacy**: Perform image analysis on the client side (On-Device AI) as much as possible and minimize transmission to the server. Ideally, "Raw Image Data" should not leave the device.
    *   **Accessibility**: Always support analysis results with `alt` text or voice reading.
*   **Voice**:
    *   **Latency**: Provide immediate feedback for voice input (waveform animation, etc.) to visually convey that recording is in progress.
    *   **Misrecognition Prevention**: Do not complete critical actions (remittance, deletion) solely by voice; always insert a confirmation step on the screen.

## 5. Evaluation & Improvement
*   **Automated Evaluation**:
    *   Introduce a mechanism (LLM-as-a-Judge) to quantitatively evaluate "Answer Quality".
*   **User Feedback**:
    *   Place "Good/Bad" buttons for each answer to collect user feedback. Use this for the next fine-tuning or prompt improvement. Collect data for RLHF (Reinforcement Learning from Human Feedback).
