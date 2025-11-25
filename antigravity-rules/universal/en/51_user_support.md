# 51. User Support & Customer Success

## 1. Support Philosophy - "Empathy & Efficiency"
*   **Zappos Style Empowerment**:
    *   **Delegation**: Give support staff authority to solve problems without supervisor approval (e.g., refund up to a certain amount, coupon issuance). Zero runaround.
    *   **WOW Experience**: Recommend providing "WOW" experiences exceeding user expectations (e.g., handwritten messages, anniversary surprises) rather than manual responses.
*   **AI Triage**:
    *   **Auto-Classification**: Use LLM to instantly classify all inquiries (Technical, Billing, Feature Request) and judge Severity.
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
