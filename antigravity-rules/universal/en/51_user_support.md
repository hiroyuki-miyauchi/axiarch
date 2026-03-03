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
    *   **The Churn Signal Detection Protocol**:
        *   **Law**: Define the following risk signals and implement automated detection and staged intervention.

            | Signal | Threshold | Risk Level |
            |:-------|:----------|:-----------|
            | **Login frequency decline** | No login in the past 14 days | Medium |
            | **Key feature non-usage** | Zero key feature usage in the past 7 days | Medium |
            | **Support inquiry increase** | 3+ tickets per month | High |
            | **Payment failure** | 2 consecutive payment failures | Critical |
            | **Cancellation page visit** | Access to cancellation page | Critical |

        *   **Automated Action**: Implement automated intervention based on risk level.
            *   **Medium**: Send personalized re-engagement email
            *   **High**: Notify CS representative + auto-present limited offer
            *   **Critical**: Trigger immediate churn prevention measures (retention offer, etc.)
*   **The Staged Re-engagement Protocol**:
    *   **Law**: For users inactive for 30+ days, attempt staged re-engagement through the following steps.
    *   **Steps**:
        1.  **Day 30**: "We miss you" email + highlights of new features and content
        2.  **Day 60**: Email with limited-time coupon (time-limited perks, etc.)
        3.  **Day 90**: Final notice email + advance notification of account dormancy
        4.  **Day 120**: Account dormancy processing
    *   **Tone**: Emails must be written in natural, warm language appropriate for the target locale. Pressure-inducing expressions (e.g., "If you don't come back now...") are prohibited.
    *   **Measurement**: Measure the Resurrection Rate at each step and continuously improve the effectiveness of each initiative.
*   **The Cancellation Flow Standard**:
    *   **Law**: Cancellation procedures MUST be completable within **3 steps or fewer**.
    *   **Steps**:
        1.  **Reason Collection**: Cancellation reason selection (dropdown + optional free text)
        2.  **Retention Offer**: Optional retention offer (one-time only). E.g., "Next month free", "Plan downgrade"
        3.  **Final Confirmation**: Confirmation screen + immediate cancellation execution
    *   **Confirmation**: Send a confirmation email immediately after cancellation completion, including a "You can restart anytime" call-to-action.
    *   **Anti-Dark Pattern**: The following practices are strictly prohibited.
        *   Intentionally hiding or making the cancellation button hard to find
        *   Displaying multiple consecutive retention modals
        *   Requiring phone calls or physical locations to cancel
        *   Adding unnecessary steps before cancellation completion
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
*   **The VoC Pipeline Protocol**:
    *   **Context**: Establish a process for systematically collecting, analyzing, and reflecting user feedback.
    *   **Collection Channels**:

        | Channel | Collection Method | Frequency |
        |:--------|:-----------------|:----------|
        | **In-App Feedback** | Feedback widget | Ongoing |
        | **NPS/CSAT** | Periodic surveys | Per NPS/CSAT measurement standards |
        | **App Store Reviews** | App Store / Google Play rating analysis | Weekly |
        | **Support Tickets** | Classification and aggregation of inquiries | Weekly |
        | **SNS Monitoring** | Brand mention detection | Daily |

    *   **Analysis**: Classify collected feedback into categories (feature requests, bug reports, UX improvements, content) and reflect in the product roadmap on a monthly basis.
    *   **Close the Loop**: When improvements are made based on feedback, notify the users who reported it of the improvement completion (e.g., "We've made improvements based on your feedback" email). Periodically update the status of unaddressed feedback as well, ensuring user voices do not disappear into a "black hole".
*   **The NPS Measurement Standard**:
    *   **Context**: Adopt Net Promoter Score (NPS) as a quantitative indicator of customer loyalty and measure it continuously.
    *   **Survey Timing**: Display NPS surveys in-app at 30 days, 60 days, and every 90 days thereafter from the start of service usage.
    *   **Question**: "How likely are you to recommend this service to a friend or colleague? (0-10)"
    *   **Follow-up**: Design follow-up questions based on the score.
        *   **Promoter (9-10)**: "What do you like most about the service?"
        *   **Passive (7-8)**: "Is there anything you'd like us to improve?"
        *   **Detractor (0-6)**: "What are you dissatisfied with?"
    *   **Target**: Set NPS **≥ 40** as the target (adjustable based on market/industry averages).
    *   **Response Rate**: Target a survey response rate of **≥ 20%**.
*   **The CSAT Measurement Standard**:
    *   **Context**: Measure Customer Satisfaction Score (CSAT) after specific interaction completion.
    *   **Trigger Design**: Display CSAT after events such as the following.

        | Trigger Example | Display Timing | Question Example |
        |:---------------|:--------------|:----------------|
        | **AI feature usage complete** | After feature use ends | "Was the response helpful?" 👍/👎 |
        | **Search complete** | After search results display | "Did you find the information you were looking for?" |
        | **Support interaction complete** | After ticket close | "How satisfied were you with the support? (1-5)" |

    *   **Target**: Target an average CSAT score of **≥ 4.2 / 5.0** across all measurements.
*   **The CES Measurement Standard**:
    *   **Context**: Customer Effort Score (CES) measures how much "effort" a user felt was required to achieve their goal. Lower effort leads to higher satisfaction and retention.
    *   **Trigger**: Measure after support inquiry resolution, self-service feature usage, or any other point where a user has attempted to solve a problem.
    *   **Question**: "How easy was it to resolve your issue?" — Evaluate on a 3-point scale (Easy / Neutral / Difficult) or a 7-point scale. Write in natural language appropriate for the target locale.
    *   **Target**: Aim for average CES score **≥ 5.5 / 7.0** (on a 7-point scale).
    *   **Action**: Analyze friction causes for users who responded "Difficult" and reflect findings in UX improvements or FAQ/documentation expansion.
*   **The Survey Widget UX Standard**:
    *   **Context**: Inappropriate display of NPS/CSAT surveys degrades user experience and lowers response rates.
    *   **Throttling**: Limit survey display to the same user to **maximum once per 7 days** to prevent Survey Fatigue.
    *   **Skip Button**: Always display a "Skip" or "Not now" button; never force responses.
    *   **Auto-Close**: If no response is received within a set time (recommended: 10 seconds) after display, automatically close the survey (eliminate sense of coercion).
    *   **Non-Blocking**: Place survey widgets in a position and layer that does not obstruct main content interaction.
*   **The Survey Data Schema Standard**:
    *   **Context**: When persisting NPS/CSAT survey response data, define a unified schema to ensure analysis accuracy.
    *   **Recommended Schema**:

        | Column | Type | Description |
        |:-------|:-----|:------------|
        | `id` | UUID | Unique identifier |
        | `user_id` | UUID | Respondent (FK to user table) |
        | `survey_type` | TEXT | `nps` / `csat` |
        | `trigger_event` | TEXT | Trigger event identifier (e.g., `ai_chat_complete`, `search_complete`, `day30_check`, etc.) |
        | `score` | INT | Score (NPS: 0-10, CSAT: 1-5, etc.) |
        | `feedback_text` | TEXT | Free-text feedback (optional, NULL allowed) |
        | `segment` | TEXT | User segment at time of response (see customer segmentation standards) |
        | `plan_tier` | TEXT | Plan tier at time of response (e.g., `free`, `standard`, `premium`) |
        | `created_at` | TIMESTAMPTZ | Response datetime |

    *   **Access Control**: Users should only be able to view their own responses. Administrators should be able to view and analyze all responses.
*   **The NPS/CSAT Analytics Dashboard Standard**:
    *   **Context**: Define analytics dashboard standards for visualizing NPS/CSAT measurement results in the admin panel, enabling data-driven improvement cycles.
    *   **Required Visualizations**:
        *   **NPS Trend Chart**: Display monthly NPS score trends (past 12 months trend).
        *   **CSAT Distribution**: Display CSAT score distribution by trigger (histogram, etc.).
        *   **Detractor Alert**: Implement a mechanism to immediately notify administrators when a Detractor response (NPS 0-6) is received.
        *   **Text Analysis**: Display word clouds or category-based aggregation of free-text feedback.
        *   **Segment Comparison**: Display score comparisons by plan tier (e.g., Free / Standard / Premium).

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
*   **Notification Channel Selection Matrix**:
    *   Select the optimal notification channel for users based on the urgency and importance of the content.

        | Urgency / Importance | Low Importance | High Importance |
        |:---------------------|:---------------|:----------------|
        | **Immediate (Urgent)** | In-app notification (Toast) | Email + Push notification |
        | **Normal** | In-app notification (Bell) | Email |
        | **Batch (Periodic)** | — | Email digest (weekly, etc.) |

    *   **Unsubscribe**: Marketing-related notification channels (newsletters, etc.) must always provide a one-click opt-out mechanism.
*   **In-App Notification Classification Standard**:
    *   Classify in-app notifications into the following 3 types and use them according to their purpose.

        | Type | Use Case | Display Method |
        |:-----|:---------|:---------------|
        | **Toast (Temporary)** | Success/completion messages | Auto-dismiss after a few seconds |
        | **Bell (Persistent)** | Unread notifications | Display via badge on bell icon. Manage read status in DB |
        | **Banner (Global)** | Maintenance notices, etc. | Fixed display at top of screen. Controllable from admin panel |

    *   **Locale Compliance**: All notification text must be written naturally in the target locale's language.

### 6.3. The Notification Frequency Control Protocol
*   **Law**: Marketing and promotional notifications MUST respect users' daily lives and apply the following frequency controls.
*   **Daily Cap**: Marketing notifications per user MUST be limited to **3 per day**.
*   **Quiet Hours**: Marketing notifications during nighttime (e.g., 21:00-8:00 in the target timezone) MUST be deferred to the next morning. Transaction notifications (payment confirmations, security alerts, etc.) are exempt.
*   **One-Click Unsubscribe**: Marketing notifications MUST include an "Unsubscribe" link enabling **one-click opt-out**. Email unsubscribe MUST comply with applicable laws (CAN-SPAM Act, local email marketing laws, etc.).
*   **Preference Center**: Provide a settings page where users can control ON/OFF per notification category (Transaction / Communication / Marketing / Reminder).

### 6.4. The Notification Category Matrix
*   **Law**: User notifications MUST be classified into the following categories, with delivery channel and immediacy defined per category.

    | Category | Examples | Channel | Immediacy |
    |:---------|:---------|:--------|:----------|
    | **Transaction** | Reservation confirmed, Payment complete | Email + Push | Instant |
    | **Communication** | Reply to UGC, Inquiry response | Email + Push | Instant |
    | **Marketing** | New arrivals, Recommended content | Push | Batch (daily) |
    | **System** | Password change, Security alert | Email | Instant |
    | **Reminder** | Pre-reservation notice, Action prompts | Push | Scheduled |

*   **Mandate**: Define specific notification copy and delivery timing for each category in the project-specific Blueprint. This matrix provides the category classification "template."
## 7. Automation & Anti-Ghost

### 7.1. The Auto-Reply Mandate
*   **Law**: Upon receiving user inquiries, sending an **Auto-Reply** for acknowledgment is mandatory.
*   **Action**:
    1.  **Instant Acknowledgment**: Immediately after form submission, send an auto-reply email such as "Your inquiry has been received. A representative will contact you within X business days."
    2.  **SLA Display**: Include the expected response time (SLA) in the auto-reply to alleviate user anxiety.
    3.  **No Silent Submission**: A state where no feedback is provided after form submission (Ghost Feature) is strictly prohibited as users will perceive "the system is broken."

### 7.2. The Email Template Structure Protocol
*   **Mandate**: All system emails (transactional emails) must include the following 5 elements.

    | Element | Content | Quality Standard |
    |:--------|:--------|:----------------|
    | **Subject** | Concise and specific. 30 characters or less recommended | Service name prefix recommended |
    | **Greeting** | Polite greeting including user name | Target locale's honorific format |
    | **Body** | Clearly state purpose, result, and next action | Unified in target locale's polite register |
    | **CTA (Call to Action)** | Link to the next action to take | Button format recommended, with plain URL alongside |
    | **Footer** | Service name, contact info, unsubscribe link | Compliant with applicable local laws |

*   **Plain Text**: HTML emails must always include a plain text version.
*   **Subject Anti-Pattern**:
    *   ❌ Vague generic subjects (e.g., "Notification")
    *   ❌ Overly emotional or urgency-baiting subjects (e.g., "URGENT! Please check immediately!!")
    *   ❌ Subjects in a language different from the target locale

### 7.3. The Email Body Protocol
*   **Structure**: Email body should follow this 3-part structure as standard.
    1.  **What**: What happened / What is being notified
    2.  **Why**: Why this email was sent (include guidance for cases where the recipient has no recollection)
    3.  **Next**: What to do next (CTA button + text link)
*   **Anti-Pattern**:
    *   Exposing technical terms ("OTP Token", "Session ID", "UUID", etc.) is prohibited
    *   Commanding tone ("Click the link below", etc.) is prohibited
*   **Best Practice**:
    *   Security-related emails should include guidance such as "If you did not initiate this, please ignore this email."
    *   Links should clearly state their expiration (e.g., "This link is valid for 24 hours").
*   **Send Retry**: On send failure, retry up to 3 times. If still failing, log the error and notify administrators.

### 7.4. The Sender Identity Governance Protocol
*   **Law**: The "From" field of all system-sent emails must be organized by purpose and standardized with display names that inspire trust and recognition in users.
*   **Action**:
    1.  **Purpose-Based Separation**: Separate email sender addresses by purpose and maintain them as a managed inventory. The following 3 purposes are the minimum standard.

        | Purpose | Address Example | Display Name | Notes |
        |:--------|:---------------|:-------------|:------|
        | **Transactional Notifications** | `noreply@{domain}` | {Service Name} | Password reset, payment confirmation, etc. |
        | **Marketing** | `news@{domain}` | {Service Name} | Campaigns, newsletters, etc. |
        | **Support Replies** | `support@{domain}` | {Service Name} Support | CS responses |

    2.  **Display Name**: The sender display name must use a format that allows target locale users to instantly recognize the service. Including the service name is mandatory.
    3.  **Free Email Prohibition**: Sending system emails from free email addresses (`@gmail.com`, `@yahoo.com`, etc.) is prohibited.
    4.  **Reply-To Mandate**: Even when sending from `noreply@`, a support address must be set in the `Reply-To` header.
*   **Cross-Reference**: `60_security_privacy.md` — Email Domain Authentication Protocol (SPF/DKIM/DMARC), Email Domain Separation Protocol (Transactional/Marketing sender domain separation)

### 7.5. The Email Audit Schema Standard
*   **Law**: All system email sends must be recorded in an audit table (`email_logs` or equivalent mechanism). The design must make it possible to trace send success/failure and delivery status, enabling both incident root cause investigation and preservation of legal evidence trails.
*   **Recommended Schema**:

    | Column | Type | Description |
    |:-------|:-----|:------------|
    | `id` | UUID | Unique identifier |
    | `recipient_email` | TEXT (masked) | Recipient (stored masked: `a***z@...`) |
    | `template_type` | TEXT | Template type (`password_reset`, `welcome`, etc.) |
    | `subject` | TEXT | Subject line |
    | `status` | TEXT | `sent`, `failed`, `bounced` |
    | `provider_id` | TEXT | Send provider's transmission ID |
    | `sent_at` | TIMESTAMPTZ | Send timestamp |
    | `error_detail` | TEXT | Error details on failure |

*   **PII Protection**: `recipient_email` must be stored with masking applied (direct PII storage prohibited).
*   **Retention**: Define a retention period for send logs and automatically delete them after expiration. The specific retention period should be defined in the project-specific Blueprint (recommended: 1 year).
*   **Cross-Reference**: `61_legal_data_privacy.md` §3 — Email Compliance Protocol (Opt-In, Sender Disclosure, Unsubscribe, Audit Trail legal requirements)
