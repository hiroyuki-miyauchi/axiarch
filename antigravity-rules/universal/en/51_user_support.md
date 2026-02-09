# 51. User Support & Customer Success

## 1. Support Philosophy - "Empathy & Efficiency"
*   **Zappos Style Empowerment**:
    *   **Delegation**: Give support staff authority to solve problems without supervisor approval (e.g., refund up to a certain amount, coupon issuance). Zero runaround.
    *   **WOW Experience**: Recommend providing "WOW" experiences exceeding user expectations (e.g., handwritten messages, anniversary surprises) rather than manual responses.
*   **AI Triage**:
    *   **Auto-Classification**: Use LLM to instantly classify all inquiries (Technical, Billing, Feature Request) and judge Severity.
    *   **The AI Triage PII Protocol**:
        *   **Law**: When using AI (LLM) for auto-classification or draft generation, strictly observe "PII Scrubbing" in AI Constitution (`40`). Mask Personal Information (Name, Phone phone) via Regex before sending to AI.
    *   **Draft Generation**: AI generates draft answers from past knowledge base, but **humans must review** and add warmth before sending. Cold AI-only responses are prohibited.

## 2. Proactive Success
*   **Churn Prediction**:
    *   **Data-Driven**: Do not wait for contact from users; monitor behavioral data (drop in login frequency, non-use of key features) and automatically follow up (email, push) when churn risk rises.
*   **Support-Driven Development**:
    *   **Issue Linking**: Link support inquiries directly to GitHub Issues. Automate rule: "If same inquiry comes 3 times, raise priority as dev task".

## 3. Inquiry Handling
*   **SLA (Service Level Agreement)**:
    *   **First Response**: Guarantee first reply within **2 hours** during business hours, and within **24 hours** otherwise.
    *   **Resolution Time**: Aim for complete resolution within **48 hours** except for complex technical issues.
*   **Tooling**:
    *   **Centralization**: Centralize inquiries from Email, Chat, SNS in tools like Zendesk or Intercom. Zero missed inquiries.

## 4. FAQ & Knowledge Base
*   **Dynamic Updates**:
    *   **Rule**: If the same question comes "3 times", always add to FAQ or improve product UI to prevent the question.
*   **Clarity**:
    *   Explain without technical jargon, using plenty of screenshots and GIFs so anyone can understand.

## 5. Feedback Loop
*   **Voice of Customer**:
    *   Aggregate "User Voices (Requests, Complaints)" from support weekly and feedback to Product Team.
    *   **Bug Report**: Verify bug reports from users with top priority, and once fixed, always report individually to the user and express gratitude.

## 6. Interaction Design

### 6.1. The Dynamic Form Runner
*   **Law**: Input forms such as inquiry forms MUST be **dynamically generated from schemas defined in DB/CMS**, not hardcoded.
*   **Action**:
    1.  **Schema-Driven**: Manage form field definitions (name, type, validation, order) in DB JSONB columns or dedicated tables.
    2.  **No Deploy for Forms**: Maintain a design where adding, modifying, or deleting form fields does not require code deployment.
    3.  **Validation Sync**: Auto-generate frontend validation rules based on DB-side schema definitions.
    4.  **Anti-Bot / Spam Protection**: Implement **CAPTCHA or challenge authentication** (e.g., Cloudflare Turnstile, reCAPTCHA) on all user input forms to prevent automated Bot submissions.
    5.  **PII Access Restriction**: Personal Identifiable Information (PII) submitted through forms MUST be viewable only by **users with administrator privileges**; restrict access from general users or unauthorized staff.

### 6.2. The Channel Priority Protocol
*   **Law**: Define priority rankings for user communication channels (Email, in-app notifications, SMS, LINE, etc.) and adopt a design that delivers via the highest-reach channel first.
*   **Action**:
    1.  **Priority Cascade**: Attempt delivery based on user notification settings with priority such as `In-app Notification > Email > SMS`.
    2.  **Fallback**: If the higher-priority channel is unavailable (unregistered, etc.), automatically fall back to the next channel.
    3.  **User Preference**: Provide UI for users to enable/disable their notification channels.

## 7. Automation & Anti-Ghost

### 7.1. The Auto-Reply Mandate
*   **Law**: Upon receiving user inquiries, sending an **Auto-Reply** for acknowledgment is mandatory.
*   **Action**:
    1.  **Instant Acknowledgment**: Immediately after form submission, send an auto-reply email such as "Your inquiry has been received. A representative will contact you within X business days."
    2.  **SLA Display**: Include the expected response time (SLA) in the auto-reply to alleviate user anxiety.
    3.  **No Silent Submission**: A state where no feedback is provided after form submission (Ghost Feature) is strictly prohibited as users will perceive "the system is broken."

