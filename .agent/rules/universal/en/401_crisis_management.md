# 40. AI Implementation & UX Strategy
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
*   **The Model Switch Protocol**:
    *   **Law**: AI model generation changes occur frequently, with risk of quality degradation during transitions. Model changes MUST go through the following 4-step process.
    *   **Step 1 (Staging Test)**: Enable the new model only in the staging environment and verify accuracy with Golden Dataset.
    *   **Step 2 (Shadow Mode)**: Run old and new models simultaneously (Shadow Traffic) in production and record response differences. Recommended comparison period is at least **48 hours**.
    *   **Step 3 (Canary Release)**: Deploy the new model to a subset of users (e.g., 10%) and monitor error rates and satisfaction.
    *   **Step 4 (Full Rollout)**: If no issues, roll out to all users.
    *   **Rollback**: Maintain the ability to immediately rollback (switch to old model) at each step. Control via environment variable (e.g., `AI_MODEL_VERSION`) is recommended.
