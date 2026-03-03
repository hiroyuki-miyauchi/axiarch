# 61. Legal, Privacy & Data Governance

## 1. Data Sovereignty
*   **Residency**: Store user data in the region where the user resides (e.g., EU users in EU region) and comply with cross-border transfer regulations (GDPR etc.).
    *   **Portability Protocol**: Users have the right to bulk download all their data (posts, images, logs) in machine-readable format (JSON/CSV). Maintain capability to fulfill data access requests within **72 hours**. Implementation must be via async jobs.
    *   **Right to Erasure**: Account deletion must involve **Hard Delete** of relevant PII, making it unrecoverable. Only data with legal retention obligations shall be isolated in Cold Storage.
    *   **SAR Response Deadline (Subject Access Request)**: Data deletion requests from users MUST be completed within **30 days** of receipt. Data with legal retention obligations (transaction records, etc.) shall be logically deleted, then physically deleted after the retention period expires. Cascade deletion order for related tables must be explicitly managed in the Service layer.
    *   **Cross-Border Transfer & Data Processing Standards**:
        *   **Law**: Cross-border transfer of personal data requires provision of information to users and ensuring appropriate security management measures, regardless of the existence of personal information protection systems in the destination country (GDPR adequacy decisions, APPI amendments, etc.).
        *   **Pseudonymized Information**: Data processed so that individuals cannot be identified without cross-referencing with other information. Relaxed use for internal analysis purposes is permitted, but provision to third parties is prohibited in principle. Security management of processing method information is mandatory.
        *   **Anonymized Information**: Data processed to a state where re-identification of individuals is impossible. Provision to third parties is possible without individual consent, but strict compliance with processing standards, disclosure obligations, and re-identification prohibition is required.
        *   **Usage Guideline**: Internal analysis/product improvement → Pseudonymized Information, External partner provision/open data publication → Anonymized Information shall be the standard approach.
*   **Consent Management**:
    *   **CMP**: Manage Cookie and tracking consent using trusted CMPs (Consent Management Platform) like OneTrust instead of custom implementation, to auto-follow legal changes in each country.
    *   **Strict Opt-In**: Blocking non-essential tracking without explicit consent is mandatory (No Nudging). Place "Reject All" button with **equal visibility** as "Accept All" in consent banners.
    *   **Cookie Classification & Consent Requirements**:

        | Type | Examples | Consent |
        |:-----|:---------|:--------|
        | **Essential Cookies** | Session ID, CSRF Token | Not required (essential for service operation) |
        | **Functional Cookies** | Language settings, Theme settings | Not required (user convenience) |
        | **Analytics Cookies** | Analytics, Heatmaps | **Required** |
        | **Advertising Cookies** | Ad delivery, Retargeting | **Required** |

    *   **CMP Implementation Standards**:
        *   **Initial State**: Analytics and advertising Cookies MUST be **disabled** on first visit and only activated after obtaining explicit user consent.
        *   **Banner UI**: Provide 3 choices in the consent banner: "Accept All", "Customize", and "Reject".
        *   **Persistence**: Save consent state in DB or LocalStorage. Do not re-display banner on revisit.
        *   **Consent Withdrawal**: Ensure users can withdraw consent at any time via footer or equivalent navigation.

### 1.1. The Data Import Standard (Portability Inbound)
*   **Law**: To facilitate user migration from competing services and standardize the "inbound" side of data portability, a structured data import function MUST be provided.
*   **Action**:
    1.  **Format Support**: Provide bulk import functionality in CSV / JSON format via admin panel or API.
    2.  **Validation Pipeline**: Import data MUST pass **all** of the following validations before being saved:
        *   **Type Check**: Whether each field conforms to the expected data type (numeric, date, string, etc.).
        *   **Duplicate Check**: Whether there are unique constraint violations against existing data (controlled via `ON CONFLICT`).
        *   **Character Encoding Normalization**: Unification to UTF-8. Support for BOM-marked files and different encodings.
    3.  **Error Report**: Failed import rows must be reported with clear error messages (in the operator's native language) and line numbers. Not just "M of N failed" summaries, but line-level details are mandatory.
    4.  **Dry Run Mode**: Implementation of a "dry run" mode that returns only validation results before writing to production data is recommended.
*   **Export Frequency Limit**:
    *   **Law**: To prevent abuse of data export functionality (repeated bulk downloads), export requests MUST be limited to **2 per month**.
    *   **Action**: When the limit is exceeded, notify the user of the next available date.
*   **Rationale**: Data portability is only complete when it includes both "export (out)" and "import (in)." A standardized import function lowers migration barriers from competing services and directly reduces user acquisition costs.

### 1.2. Platform Safety & Rights Management
*   **Automated Toxicity Detection (Brand Safety)**:
    *   **Filter First**: Pass UGC through auto-moderation (AI) before publication, immediately blocking or flagging inappropriate content (sexual, violent, hate) and building defense wall that rejects before DB save.
    *   **SLA**: Maintain zero-tolerance posture to prevent illegal content from being displayed "even momentarily".
*   **Infringement Handling (DMCA/Rights)**:
    *   **Takedown Process**: For copyright infringement reports, SRE/Legal team verifies within 24 hours; if infringement is clear, establish process to hide content (Takedown). Preserve deletion logs as evidence.

### 1.3. The Data Breach Notification Protocol
*   **Law**: Data protection regulations (GDPR Art.33/34, Japan's amended APPI Art.26, etc.) mandate reporting to supervisory authorities and notifying affected users in the event of a personal data breach. This obligation is a **legal duty** independent of technical incident response, and failure to comply may result in administrative sanctions and fines.
*   **Mandate**: When a data breach is confirmed or reasonably suspected, the following 5-phase flow MUST be **initiated immediately**.

    | Phase | Deadline | Responsible | Action |
    |:------|:---------|:------------|:-------|
    | **1. Detection** | Immediate | Monitoring System | Anomaly detection (authorization bypass, bulk data retrieval, concentrated unauthorized login attempts) → Automatic notification to instant alert channel |
    | **2. Containment** | Within **1 hour** of detection | Technical Lead | ① Identify and block the breach vector ② Preliminary impact assessment (affected tables, record count, PII types) ③ Preserve access logs as evidence |
    | **3. Initial Report** | Within **72 hours** of detection | Legal/Compliance | ① Submit initial report to the relevant supervisory authority ② Report contents: Summary, number of records breached, PII types, presence of secondary damage, preventive measures |
    | **4. User Notification** | **Simultaneously** with initial report | CS/Operations | ① Notify affected users (via email, etc.) ② Notification contents: Summary of breach, scope of impact, recommended actions (password change, etc.), contact point |
    | **5. Post-Mortem** | Within **30 days** of detection | All Teams | ① Submit final report to supervisory authority ② Create Post-Mortem report ③ Implement preventive measures → Record in project lessons log |

*   **Reporting Thresholds**: Activate the above flow if any of the following conditions are met:
    *   Personal data breach involves **1,000 or more** records
    *   Sensitive personal information is involved (medical information, beliefs, criminal history, etc.)
    *   There is a risk of financial damage (credit card information, bank account information, etc.)
    *   The breach was caused by unauthorized access
*   **Cross-Reference**: `60_security_privacy.md` §8.17 (Incident Response & Drill Protocol), `53_crisis_management.md` §3 (Data Breach Protocol)

## 2. ToS & Privacy
*   **Dynamic Consent**:
    *   **Version Control**: Record "When and which version of ToS user agreed to" in DB as legal trail. Force display consent screen at next login upon revision.
    *   **Consent Record Legal Trail**: Consent records MUST include the following fields to maintain a state where they can be submitted as evidence in response to legal requests.
        *   User ID, Agreement type (ToS / Privacy Policy), Agreed timestamp, IP address, User-Agent, Agreement version
    *   **Legal Archive**: Keep past agreements accessible via Permalinks to guarantee user's right to verify contract conditions.
    *   **The Legal Snapshot Protocol (Audit Trace)**:
        *   **Law**: ToS system MUST be 100% restorable for "who agreed when" and "how ToS content changed over time".
        *   **Action**: On ToS page updates, auto-save pre-update data to revision table and persist as audit log (deletion prohibited).
*   **Layered Notice**:
    *   Always display a summary in Plain Language understandable by users before legal detailed clauses in Privacy Policy.

## 3. Local Compliance Examples
*   **Act on Specified Commercial Transactions**:
    *   When charging, always place the notation based on **local commercial transaction laws** (e.g., Japan's Tokusho-ho: Operator, Contact, Return Policy) in an easily accessible place in the app.
    *   **Disclosure Items Example**: Business name, Address, Phone number, Representative name, Selling price, Payment timing & method, Delivery timing, Cancellation/Return policy. Cover all items required by applicable local laws.
    *   **Final Confirm Screen**: Display the following elements clearly on the screen immediately before payment, and eliminate dark patterns that hinder cancellation.
        *   **Contract Period**: Clearly state Indefinite / 1 month / 1 year, etc.
        *   **Billing Timing**: Specific billing date such as "Charged today" or "Next renewal: YYYY/MM/DD"
        *   **Cancellation Terms**: Clear navigation such as "Cancel anytime from settings page"
*   **Payment Services Laws**:
    *   **Deposit Avoidance**: Be cautious with issuing prepaid payment instruments (points, coins) as deposit obligations may arise (e.g., Japan's PSA). In principle, use Apple/Google IAP systems and avoid self-issued points.
*   **Minor Safety Protocol**:
    *   **Age Gate**: For services with payment features, implement age verification (date of birth input) at registration or before first payment.
    *   **Parental Consent**: When users under the legal age make a purchase, display a mandatory "I have obtained parental consent" checkbox and record the consent log (timestamp, IP). Unauthorized contracts by minors are subject to cancellation rights.
*   **Stealth Marketing Regulation (Ad Disclosure Obligation)**:
    *   **Law**: Content involving monetary compensation from advertisers MUST display legally required ad labels ("PR", "Ad", "Sponsored", etc.). Omission of labeling constitutes a legal violation.
    *   **System Guard**: Implement a system-level Guardrail that automatically appends ad labeling to posts with the `is_sponsored` flag.
*   **Email Compliance Protocol**:
    *   **Opt-In**: Explicit prior consent (checkbox, etc.) is mandatory for sending advertising/promotional emails. Record the consent timestamp.
    *   **Sender Disclosure**: All emails must display the sender name, contact information, and unsubscribe method.
    *   **Unsubscribe**: Marketing emails must always include a one-click unsubscribe link. Upon receiving an opt-out request, email delivery must be stopped promptly.
    *   **Audit Trail**: Log all system email sends. Mask recipient email addresses before storage (direct PII storage prohibited). Define a retention period and auto-delete after expiration.

## 4. IP & Licenses
*   **License Contamination Prevention**:
    *   **No GPL**: Mixing Copyleft license (GPL/AGPL) code is strictly prohibited due to risk of source code disclosure obligation.
    *   **Rights Clearance**: Confirm commercial use allows for all assets (images, fonts) used and centrally manage license trails.
    *   **UGC License Grant**:
        *   **Law**: Include a clause in Terms of Service granting the operator a "free, non-exclusive right to use (reproduce, publicly transmit, etc.) user-generated content (reviews, images, etc.) for promotional purposes".
        *   **Safeguard**: Include a clause for non-assertion of moral rights, while ensuring user rights are not unfairly infringed.
    *   **The Work-for-Hire Protocol (Contractor IP Rights)**:
        *   **Risk**: Risk that copyright of outsourced deliverables remains with contractor.
        *   **Mandate**: In contractor agreements, MUST require that deliverable copyright (including derivative rights) transfers to client upon acceptance, and include clause for non-assertion of moral rights.

### 4.1. The Anti-Social Forces Exclusion Protocol
*   **Law**: Complete severance of all relationships with anti-social forces is an absolute requirement for legal compliance and maintaining corporate social credibility. Anti-social forces exclusion clauses MUST be included in all Terms of Service, outsourcing agreements, and basic transaction agreements.
*   **Mandate**:
    *   **Contract Clauses (Mandatory)**: Include the following clauses in all contracts and terms:
        *   Representations and warranties of non-affiliation with anti-social forces (organized crime groups, members, affiliated enterprises, corporate extortionists, etc.)
        *   Pledge not to utilize anti-social forces
        *   Right to immediate contract termination upon discovery (no prior notice required)
        *   Reservation of right to claim damages upon discovery
    *   **KYB/KYC Due Diligence**: Conduct KYB (Know Your Business) screening before initiating corporate transactions, and KYC (Know Your Customer) screening for individual transactions.
        *   **Screening**: Cross-reference against anti-social forces databases (commercial services or government-provided lists)
        *   **Periodic Checks**: Mandate **annual re-screening**, not just initial verification
    *   **Immediate Response Upon Discovery**: When a business partner or user is found to be affiliated with anti-social forces:
        1.  Immediately report to the legal department
        2.  Send notice of contract termination (based on no-prior-notice clause)
        3.  Immediately suspend related service accounts
        4.  Consult with and report to local law enforcement agencies
*   **Rationale**: Association with anti-social forces leads not only to compliance violations but directly to business continuity risks such as bank account freezes and payment service suspensions. Building a preventive exclusion system is essential.

## 5. AI Content & Data Usage Governance

### 5.1. AI-Generated Content Copyright
*   **Law**: Copyright of AI-generated content is a legal gray area, requiring careful operation in compliance with national guidelines (e.g., Japan's Agency for Cultural Affairs guidelines, EU AI Act, etc.).
*   **Mandate**:
    *   **No Direct Publish**: Publishing AI-generated text directly as official articles is **prohibited**. Only content that has undergone human editing, verification, and augmentation shall be treated as "Official Content".
    *   **AI Image Risk Assessment**: When commercially using AI-generated images, assess copyright risks of training data in advance and explicitly state disclaimers in Terms of Service.
    *   **DB Flag**: To track AI assistance at the data level, add an `is_ai_assisted: boolean` column (default: `false`) to content tables (in conjunction with AI Generated Content Labeling Protocol).

### 5.2. User Data AI Training Opt-Out
*   **Law**: When using data entered by users on the service (chat history, reviews, search logs, etc.) for AI model improvement or fine-tuning, Opt-Out/Opt-In mechanisms compliant with data protection laws (GDPR, APPI, etc.) and the "prohibition of purpose-external use" principle are essential.
*   **Mandate**:
    *   **Opt-Out by Default**: User data MUST NOT be used for AI training by default.
    *   **Explicit Opt-In**: Separately from ToS agreement, only when **explicit consent** (checkbox, etc.) is obtained for "providing data for AI quality improvement" may data be used as training data after anonymization.
    *   **DB Flag**: Add an `ai_training_opt_in: boolean DEFAULT false` column to the user table to manage consent state per user.
    *   **Right to Withdraw**: Users can withdraw Opt-In at any time, and their data must be excluded from the next training batch after withdrawal.
    *   **Anonymization**: Even when using data for training purposes, PII (name, email address, location, etc.) MUST be **completely removed** before use (PII Scrubbing applied).
    *   **Transparency**: Clearly state "use of data for AI quality improvement purposes" in the Privacy Policy and provide navigation to the Opt-In/Out settings page.

### 5.3. Data Commercialization Opt-Out
*   **Law**: When using anonymized and aggregated user data for provision to external partners or data sales, an **explicit Opt-Out mechanism** MUST be provided to users. This requires consent management independent of AI training usage (§5.2).
*   **Mandate**:
    *   **Opt-Out Switch**: Provide an ON/OFF switch in user settings for "Participation in data utilization (statistical data provision to external parties)".
    *   **Default State**: The default follows the project's privacy policy, but **data from users who have opted out MUST be immediately excluded from aggregation**.
    *   **DB Flag**: Add a `data_commercialization_opt_out: boolean DEFAULT false` column to the user table to manage the setting state per user.
    *   **Anonymization Mandate**: Even for opted-in users, external data provision MUST apply **k-anonymity** or **Differential Privacy** techniques, providing data only in a state where individual identification is impossible. Providing raw user lists is permanently prohibited.
    *   **Transparency**: Clearly state "provision of anonymized data to external parties" in the Privacy Policy and ensure navigation to the Opt-Out settings page.

### 5.4. AI Governance Committee
*   **Law**: With the evolution of AI technology and increasing risks, decision-making that integrates business, legal, and ethical perspectives—not just technical judgment—becomes necessary.
*   **Mandate**:
    *   It is recommended to establish an **AI Governance Committee** including the following roles once the business reaches a certain scale.
        *   Technical Lead (CTO/Tech Lead)
        *   Legal/Compliance Officer
        *   User Representative (CS/UX Researcher)
    *   **Scope**: Deliberate on model selection, prompt policy changes, risk assessment of new AI features, and incident response.
    *   **Cadence**: Quarterly reviews + ad-hoc emergency convocations.

## 6. Data Lifecycle Management

### 6.1. The Engagement Data Retention Protocol
*   **Law**: Define retention periods for user engagement data (favorites, browsing history, etc.) to prevent unnecessary data accumulation.
*   **Retention Standard**:
    *   **Favorites / Bookmarks**: Retain indefinitely. Physically delete upon user account deletion in compliance with GDPR/APPI.
    *   **Browsing History**: Retain only the most recent **90 days**. Physically delete older data via monthly batch.
    *   **Operation Logs**: Retain the most recent **1 year**. Separately archive data with legal retention obligations.
*   **Anonymization**: Data retained for analytical purposes MUST have `user_id` removed and be aggregated as statistical information. Use of data that enables re-identification of individuals for analytics is prohibited.
*   **Mandate**: Define specific retention periods for each data type in the project-specific Blueprint. This protocol provides the retention standard "template."

### 6.2. The Content Archival Protocol
*   **Law**: Define data processing policies for content removed from the service (closed stores, ended events, etc.).
*   **Archival Rules**:
    *   **Decommissioned Entities**: Change status to `closed` / `archived` and exclude from search results, but retain related UGC data (reviews, etc.) permanently as **historical trust assets**.
    *   **Deleted User Content**: Remove ownership association (`owner_id: null`) but retain the content itself if it has public interest value.
    *   **Dormant Data**: For unpublished content not updated for a defined period (e.g., 2+ years), automatically notify administrators with an archive suggestion to encourage cleanup.

## 7. The Vendor Data Governance Protocol

### 7.1. Vendor Data Sharing Standards
*   **Law**: When sharing or providing user data to external vendors (development vendors, data analysis partners, customer support outsourcers, etc.), the data controller MUST require the vendor to maintain data protection standards equal to or exceeding their own.
*   **Mandate**:
    *   **Contract Clauses (Mandatory)**: Include the following in Data Processing Agreements (DPA):
        *   Explicit specification of scope, types, and storage locations of handled data
        *   Prohibition of purpose-external use
        *   Prohibition of sub-processing in principle (when necessary, require prior written approval and obligation of equivalent conditions)
        *   Data return/deletion obligation upon contract termination (including obligation to submit evidence)
        *   Incident reporting obligation (initial report within **24 hours** of discovery)
    *   **Data Classification and Sharing Restrictions**:

        | Data Classification | Sharing Permission | Conditions |
        |:---------|:--------|:-----|
        | **Sensitive PII** (medical, financial, identity documents) | Prohibited in principle | Share only when unavoidable with encryption + access logging |
        | **Personal Info** (name, email, address) | Conditional permission | DPA execution + encrypted transfer + access restrictions |
        | **Quasi-Personal Info** (organization name, region-level info) | Permitted | DPA execution only |
        | **Anonymized Data** | Freely shareable | Prerequisite: verified that re-identification is impossible |

### 7.2. Vendor Audit Requirements
*   **Law**: Periodic security and privacy audits MUST be conducted for all external partners to whom data processing is delegated.
*   **Mandate**:
    *   **Annual Audit**: Evaluate the vendor's information security management system **at least once per year**.
    *   **Evaluation Checklist**:
        *   Information security policy documentation status
        *   Access control and log management implementation status
        *   Data encryption (at rest + in transit) application status
        *   Incident response framework readiness
        *   Employee security training implementation status
        *   Third-party certification (ISO 27001, SOC 2, etc.) acquisition status
    *   **Non-Compliance Response**: When significant non-compliance is discovered during audit, set a remediation deadline (maximum **90 days**), and consider contract review or termination if not remediated within the deadline.
*   **Rationale**: Data controllers bear legal responsibility for vendor data processing (GDPR Art.28, APPI amendments). The argument "we outsourced it, so the vendor is responsible" does not hold legally.

