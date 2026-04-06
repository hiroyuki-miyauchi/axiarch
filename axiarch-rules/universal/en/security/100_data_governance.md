# 61. Legal, Governance & Data Strategy

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-03-24

> [!IMPORTANT]
> **Supreme Directive**
> This document provides integrated rules for "Legal Obligations, Governance Frameworks & Data Strategy."
> For security technical implementation, see `600_security_privacy.md`. For license management, see `602_oss_compliance.md`. For IP strategy, see `603_ip_due_diligence.md`.
> **45 Sections.**

> [!CAUTION]
> **Legal & Security > User Experience**
> Legal compliance **always takes priority** over user convenience, development velocity, and revenue.
> Features with legal risk must not be provided even if users desire them.

---

## Table of Contents

- §1. Supreme Directive & Scope
- §2. Global Privacy Regulation Map
- §3. Data Sovereignty & Cross-Border Transfer
- §4. Consent Management & CMP
- §5. Terms of Service & Privacy Policy
- §6. Regional Compliance
- §7. Children & Vulnerable Persons Data Protection
- §8. Dark Pattern Prohibition
- §9. IP & License Governance
- §10. Anti-Social Forces Exclusion
- §11. AI Regulation & EU AI Act
- §12. Data Lifecycle Management
- §13. Vendor Data Governance
- §14. Data Breach Legal Notification
- §15. Platform Safety & Content Moderation
- §16. Data Governance Organization
- §17. Compliance Review & Audit
- §18. Law Enforcement Data Requests
- §19. Legal Hold & eDiscovery
- §20. Synthetic Data Governance
- §21. Data Clean Room Regulation
- §22. Neural Data & Emerging Biometrics
- §23. ESG & Sustainability Reporting
- §24. Antitrust & Platform Regulation
- §25. AI Management System Standards (ISO 42001 / NIST AI RMF)
- §26. Digital Sovereignty & Technological Independence
- §27. Health Data Protection
- §28. Reproductive Health Data Protection
- §29. Employee Data Protection & Workplace Monitoring
- §30. Sector-Specific Data Protection
- §31. Global AI Regulation Map
- §32. Data Broker Regulation
- §33. Government Surveillance & National Security
- §34. EU Data Act
- §35. AI Companion & Frontier Model Safety Regulation
- §36. Privacy by Design Implementation Framework
- §37. Data Governance Maturity Model
- §38. International Arbitration & ADR
- §39. Digital Contract Law & Smart Contracts
- §40. Data Ethics Board & Ethics Review
- §41. GenAI Copyright & Training Data Governance Enhancement
- §42. Integrated Privacy Impact Assessment (PIA/DPIA) Framework
- §43. Regulatory Technology (RegTech) & Compliance Automation
- §44. Data Trusts & Data Sharing Agreements
- §45. Quantum Computing Threats & Cryptographic Agility
- Appendix A: Quick Reference Index

---

## §1. Supreme Directive & Scope

### 1.1. Core Principles
*   **Privacy by Default**: All personal data processing must adhere to **purpose specification, minimization, and storage limitation**.
*   **Accountability**: Data controllers bear the **burden of proving** compliance with legal obligations (GDPR Art.5(2)).
*   **Transparency**: Obligation to explain data collection, use, and sharing to users in **plain language**.
*   **Purpose Limitation**: Use of data beyond the purpose specified at collection is **prohibited** without legal basis.

### 1.2. Scope of This File

| This File (61) Scope | Other Files' Scope |
|:---------------------|:-------------------|
| Legal obligations, reporting thresholds, deadlines | `60` Technical security implementation |
| Cookie consent legal requirements & classification | `60` §4.12 CMP technical implementation |
| License fundamentals & UGC rights | `62` License management details |
| Contractor IP & anti-social forces exclusion | `63` Patent & DD strategy |
| Data breach legal notification obligations | `60` §10.7 Technical IR procedures |
| ESG & sustainability reporting | `11` FinOps (cost aspects) |
| Antitrust & DMA | `35` API gateway controls |

---

## §2. Global Privacy Regulation Map

### 2.1. Major Regulations Overview

| Regulation | Jurisdiction | Effective | Key Obligations | Max Penalty |
|:-----------|:------------|:----------|:---------------|:-----------|
| **GDPR** | EU/EEA | 2018 | Consent management, DPO, DPIA, data subject rights | 4% global revenue or €20M |
| **APPI** (Amended) | Japan | 2022 (2027 amendment expected) | Pseudonymized/anonymized processing, cross-border restrictions, breach reporting | ¥100M for legal entities |
| **CCPA/CPRA** | California, US | 2020/2023 | Opt-out rights, sensitive PI, ADMT regulation | $7,500/violation (intentional) |
| **EU AI Act** | EU | 2024 (phased) | Risk classification, high-risk AI conformity, GPAI obligations | 7% global revenue or €35M |
| **DSA/DMA** | EU | 2022/2024 | Platform transparency, gatekeeper obligations | 6% global revenue |
| **DORA** | EU (Financial) | 2025.1 | ICT risk management, incident reporting, resilience testing | Determined by national authorities |
| **NIS2** | EU | 2024 | Critical infrastructure cybersecurity obligations | €10M or 2% revenue |
| **COPPA** | US | 1998 (2025 FTC Final Amendment) | Children under 13 data protection, parental consent, targeted advertising opt-in consent | $50,120/violation |
| **AADC (UK)** | UK | 2021 | Age-appropriate design code | 4% global revenue |
| **India DPDP Act** | India | 2023 (phased ~2027) | Data Fiduciary obligations, consent management, cross-border restrictions | ₹250 crore |
| **China PIPL** | China | 2021 | Compliance audit, cross-border security assessment, individual consent | 5% revenue or RMB 50M |
| **Brazil LGPD** | Brazil | 2020 | DPO, SCC obligations, AI/biometric regulation | 2% revenue (max R$50M) |
| **Korea PIPA** | South Korea | 2011 (2025 amended) | Data portability, domestic representative obligation | KRW 50M |
| **Vietnam PDPD** | Vietnam | 2026.1 | Comprehensive personal data protection, cross-border transfer assessment | 5% revenue (2026 enforcement) |

### 2.2. Regulatory Monitoring Obligation
*   **Mandate**: Legal team must review amendment trends of listed regulations **quarterly** and conduct impact assessments.
*   **Action**: When regulatory changes are identified, formulate technical response plans within **30 days**.
*   **Record**: Review results must be recorded in the project lessons log.

### 2.3. Key Regulatory Timeline 2025-2027

| Date | Regulatory Event |
|:-----|:----------------|
| **2025.1** | COPPA Amendment Finalized (FTC): Targeted advertising opt-in parental consent obligation |
| **2025.2** | EU AI Act: Prohibitions & AI literacy obligations apply |
| **2025.6** | European Accessibility Act (EAA) enforcement |
| **2025.8** | EU AI Act: GPAI obligations apply, AI Office operational, penalty regime active. Member States: designate authorities & establish penalties |
| **2025.9** | CCPA/CPRA: ADMT, cybersecurity audit, risk assessment regulations approved |
| **2025.10** | Maryland Online Data Protection Act (MODPA) effective |
| **2025.11** | GDPR Digital Omnibus Package: EC proposal published (personal data definition amendment, cookie consent standardization, SME exemption expansion, etc.) |
| **2026.1** | CCPA/CPRA: New regulations effective (ADMT, risk assessments, enhanced Right to Know) |
| **2026.1** | Vietnam PDPD enforcement |
| **2026.1** | New US state laws effective (Kentucky, Rhode Island, Indiana, etc.) |
| **2026.4** | EU: Cross-border GDPR enforcement regulation enters into force (EU 2025/2518) |
| **2026.6** | Colorado AI Act (CAIA): High-risk AI system regulation effective |
| **2026.7** | Connecticut: Neural Data added to sensitive data categories |
| **2026.8** | EU AI Act: High-risk AI (Annex III) obligations, transparency obligations (Art.50), AI sandbox establishment obligations take effect ※**Deferral proposal pending** (see note below) |
| **2026.8** | California AI Transparency Act (CAITA): AI-generated content transparency obligations effective |
| **2026.8** | California Delete Act/DROP: Data broker bulk deletion functionality operational |
| **2026 H2** | HIPAA Security Rule major amendment: MFA mandatory, all ePHI encryption (expected effective) |
| **2026.11** | India DPDP Act: Consent manager registration & VPC obligations |
| **2025.4** | DOJ Bulk Data Rule: Regulation of US persons' bulk personal data transactions with foreign entities effective (Oct additional requirements) |
| **2025.6** | FTC COPPA Rule Amendment effective: Targeted advertising opt-in parental consent, data retention limits |
| **2025.10** | Google Privacy Sandbox major API retirement: Topics/Protected Audience/Attribution Reporting discontinued |
| **2026.1** | California SB 446: 30-day data breach notification obligation (AG notification 15 days) |
| **2026.3** | COPPA 2.0 (KIDS Act): Protection scope expanded to under-17 (Senate passed) |
| **2026.5** | CIRCIA: Critical infrastructure 72-hour reporting / ransomware payment 24-hour reporting effective (delayed from original 2025.10) |
| **2027** | APPI Amendment Act expected effective (administrative monetary penalty, biometric data regulation, etc.) |
| **2027.4** | EU: Cross-border GDPR enforcement regulation (EU 2025/2518) fully applicable (15-month investigation deadlines, etc.) |
| **2027.8** | EU AI Act: High-risk AI (product safety legislation: medical devices, aviation, etc.) |
| **2025.8** | UK Arbitration Act 2025 effective: Changes to arbitrator immunity and governing law |
| **2026.3** | China New Arbitration Law effective: Modernization to international standards, ad hoc arbitration introduced |
| **2026.12** | Australia Privacy Act amendment: ADM (automated decision-making) transparency obligations effective |

*   **Mandate**: Integrate the above timeline into the project's technical roadmap and formulate plans to complete technical compliance **6 months before** each deadline.
*   **EDPB 2026 Coordinated Enforcement**: GDPR Art.12-14 (transparency obligations) is the 2026 coordinated enforcement priority theme. Conduct focused review of privacy policy clarity and accessibility.
*   **Google Cookie Deprecation Reversal (2025.4)**: Google officially reversed third-party cookie deprecation plans. Transitioning to user-choice model in Chrome settings. Safari/Firefox continue default blocking.
*   **EU AI Act Enforcement Deferral Proposal (2026.3)**: The European Commission published a proposal to defer Annex III high-risk AI system obligations to **December 2027** (16-month delay from original 2026.8). Requires agreement from member states and European Parliament. **Continue preparing based on 2026.8 deadline until deferral is confirmed**.

---

## §3. Data Sovereignty & Cross-Border Transfer

### 3.1. Data Residency
*   **Rule 3.1.1**: Store user data in the region where the user resides.
*   **Rule 3.1.2**: Guarantee that PII is not persisted outside designated regions, including CDN caches and temporary files.
*   **Cross-Reference**: `600_security_privacy.md` §8.2 (Data Residency)

### 3.2. Data Portability
*   **Export Right**: Users have the right to download all their data in a machine-readable format (JSON/CSV).
*   **SLA**: Maintain capability to provide data within **72 hours** of a disclosure request. Implement via async jobs.
*   **Export Frequency Limit**: Export requests limited to **2 per month**. Notify next available date when exceeded.
*   **Import**: Provide bulk import functionality in CSV/JSON format.
    *   **Validation Pipeline**: Pass all type checks, duplicate checks (`ON CONFLICT`), and UTF-8 normalization **before** saving.
    *   **Error Report**: Failed rows reported with line numbers and detailed error messages.
    *   **Dry Run Mode**: Validation-only mode before production writes recommended.

### 3.3. Right to Erasure
*   **Rule 3.3.1**: Account deletion must **hard delete** all related PII, making recovery impossible.
*   **Rule 3.3.2**: Only data with legal retention obligations may be isolated in Cold Storage. Hard delete after retention period.
*   **Rule 3.3.3**: SARs must be completed within **30 days** of receipt.
*   **Rule 3.3.4**: Cascade deletion order across related tables must be explicitly managed in the Service layer.
*   **Cross-Reference**: `600_security_privacy.md` §4.5 (Right to be Forgotten)

### 3.4. Cross-Border Transfer Framework

| Mechanism | Use Case | Requirements |
|:----------|:---------|:------------|
| **Adequacy Decision** | Japan-EU, Japan-UK, etc. | Destination country recognized as providing adequate protection |
| **SCC** | Transfers to non-adequate countries | Execution of EU Standard Contractual Clauses + TIA |
| **BCR** | Intra-group transfers | Supervisory authority approval |
| **CBPR** | APEC region | CBPR certification |
| **Explicit Consent** | Individual cases | Last resort. Not suitable for repetitive transfers |

#### 3.4.1. Data Localization Requirements (by Country)

| Country | Localization Requirement | Cross-Border Conditions | Sanction Risk |
|:--------|:------------------------|:-----------------------|:-------------|
| **China** | CIIOs must store personal info & important data **domestically** | Security assessment / SCC / Certification + individual consent | 5% revenue or RMB 50M |
| **Russia** | Personal data collection & storage must be on **domestic DB** | Foreign DB use prohibited | High fines |
| **Vietnam** | "Important data" and "core data" stored domestically | Impact assessment + authority approval | 5% revenue (2026) |
| **India** | SDF must store certain categories domestically. RBI mandates payment data localization | Whitelist approach | ₹250 crore |

*   **Transfer Impact Assessment (TIA)** — CNIL 2025.1 Final Guidelines 6-Step Methodology:
    1.  **Know Your Transfer**: Identify the data being transferred, parties involved (exporter/importer), and transfer context
    2.  **Identify Transfer Tool**: Determine which GDPR Art.46 mechanism (SCC/BCR, etc.) is being used
    3.  **Assess Third-Country Laws & Practices**: Evaluate the destination country's legal framework (both written laws and actual practices). Focus on government data access risks (surveillance legislation, etc.)
    4.  **Identify & Adopt Supplementary Measures**: Where protection gaps exist, adopt technical (encryption, pseudonymization), contractual, and organizational supplementary measures
    5.  **Implement & Document**: Document all assessment results, adopted measures, and decision rationale. Preserve as audit evidence
    6.  **Re-evaluate Periodically**: Re-evaluate **at least annually** or upon significant changes in law, new risks, or data usage changes
*   **Anti-Pattern**: "We signed SCCs so TIA is unnecessary" is wrong. SCCs require TIA and supplementary measures as prerequisites.
*   **EU-US Data Privacy Framework (DPF)**: Adequacy decision 2023.7. In 2025.9, the EU General Court dismissed a challenge to the DPF, providing temporary stability. However, noyb has indicated intent to re-challenge. TIA is still recommended even when relying on DPF.
*   **UK Adequacy Extension**: EU-UK adequacy decision extended to **December 2031** (draft decision 2025.10). European Commission confirmed adequacy following DUAA impact assessment.

### 3.5. Data Processing Standards
*   **Pseudonymized Information**: Processed so individuals cannot be identified without combining other information. Relaxed internal analysis use. Third-party provision prohibited in principle.
*   **Anonymized Information**: Processed so re-identification is impossible. Third-party provision allowed without consent. Processing standards, publication obligations, and re-identification prohibition must be strictly observed.
*   **Usage Guide**: Internal analysis/product improvement → Pseudonymized / External provision/open data → Anonymized.

### 3.6. DSAR Automation Workflow

| Step | Processing | Automation Level |
|:-----|:----------|:----------------|
| **1. Intake** | Centralized intake via web form / API / email | Fully automated |
| **2. Identity Verification** | Tiered authentication (logged in → immediate / unauthenticated → email + ID verification) | Semi-automated |
| **3. Data Search** | Automated PII search across all data stores (DB, S3, logs, backups) | Fully automated |
| **4. Review & Redaction** | Automated third-party PII masking + human review | Semi-automated |
| **5. Response Preparation** | Auto-packaging in compliant format (JSON/CSV/PDF) | Fully automated |
| **6. Delivery** | Auto-delivery of encrypted download link | Fully automated |
| **7. Audit Log** | Immutable log of all operations (tamper-proof) | Fully automated |

*   **SLA Management**: Auto-track statutory deadlines per request type with alerts firing 5 days before deadline:
    *   GDPR: **30 days** (extension +60 days with justification notification)
    *   CCPA/CPRA: **45 days** (extension +45 days)
    *   APPI: **30 days** (obligation to respond promptly)
*   **Anti-Pattern**: Relying on CS team manual email handling for DSARs will fail at scale.

#### 3.6.1. DSAR API Design Pattern

```typescript
// DSAR Intake API Endpoint Design
interface DSARRequest {
  requestType: 'access' | 'deletion' | 'correction' | 'portability' | 'opt-out';
  subjectId: string;         // User ID or email
  jurisdiction: 'GDPR' | 'CCPA' | 'APPI' | 'LGPD' | 'PIPA';
  verificationMethod: 'authenticated' | 'email' | 'id_document';
  requestedAt: string;       // ISO 8601
}

interface DSARResponse {
  requestId: string;         // UUID v4
  status: 'received' | 'verified' | 'processing' | 'completed' | 'rejected';
  deadlineAt: string;        // Auto-calculated per jurisdiction
  estimatedCompletionAt: string;
}

// Auto-calculate statutory deadlines
const DSAR_DEADLINES: Record<string, number> = {
  'GDPR': 30,    // 30 days (extendable +60 days)
  'CCPA': 45,    // 45 days (extendable +45 days)
  'APPI': 30,    // 30 days
  'LGPD': 15,    // 15 days
  'PIPA': 10,    // 10 days
};

function calculateDeadline(jurisdiction: string, requestedAt: Date): Date {
  const days = DSAR_DEADLINES[jurisdiction] ?? 30;
  const deadline = new Date(requestedAt);
  deadline.setDate(deadline.getDate() + days);
  return deadline;
}
```

*   **Mandate**: DSAR API must record all operations as immutable logs, preserving audit trails.

### 3.7. Automated Decision-Making & Profiling
*   **Law**: GDPR Art.22 guarantees the right to object to **fully automated decision-making** with legal or similarly significant effects. CCPA/CPRA enforces ADMT regulation from 2026.1.
*   **Requirements**:
    *   **Pre-disclosure** of automated decision existence, logic involved, and anticipated outcomes
    *   Guarantee users' **right to request human review**
    *   **Opt-out right**: CCPA/CPRA adds opt-out rights for profiling-based automated decisions
*   **CCPA ADMT Rules (2026.1 effective)**:
    *   Targets technology that "substantially replaces human decision-making"
    *   New processing activities must complete risk assessment **before** initiation
    *   Pre-existing activities must complete risk assessment by **2027.12.31**
*   **Colorado AI Act (2026.6 effective)**:
    *   Targets AI systems making "consequential decisions" (financial, housing, insurance, healthcare, education, employment, etc.)
    *   Deployers: Must build and maintain risk management programs aligned with NIST AI RMF or ISO 42001
    *   Deployers: Complete impact assessment before deployment + annual updates (or within 90 days of substantial modifications)
    *   Consumer disclosure obligation: Notify that AI is involved in decision-making and provide appeal methods
*   **Implementation Pattern**:

```typescript
// Automated decision transparency flag
interface AutomatedDecision {
  decision_id: string;
  decision_type: 'credit_scoring' | 'content_recommendation' | 'pricing';
  is_fully_automated: boolean;
  logic_summary: string; // Plain language explanation for users
  human_review_requested: boolean;
  opt_out_available: boolean;
}
```

#### 3.7.1. Right to Explanation & Algorithmic Transparency Requirements
*   **EU AI Act Art.86**: Individuals affected by decisions from high-risk AI systems have the right to receive **clear and meaningful explanations** of the AI system's role, key decision factors, and decision rationale.
*   **GDPR Art.13-15**: Obligation to provide meaningful information about "the logic involved, its significance, and the envisaged consequences" of automated processing.
*   **XAI (Explainable AI) Implementation Checklist**:
    *   [ ] XAI methods (SHAP / LIME, etc.) integrated to extract model decision factors
    *   [ ] UI providing explanations in **plain language** for end users
    *   [ ] Explanations have sufficient specificity to "identify violations and file complaints"
    *   [ ] Explanation generation/delivery process recorded as audit logs
    *   [ ] Explanation consistency validated upon model updates
*   **Anti-Pattern**: "The algorithm is too complex to explain" is legally unacceptable. Technical complexity is the organization's problem and does not justify limiting data subject rights.

---

## §4. Consent Management & CMP

### 4.1. CMP Implementation Mandate
*   **Mandate**: Manage cookie and tracking consent using a trusted CMP (e.g., OneTrust) that auto-adapts to regulatory changes per jurisdiction.
*   **Cross-Reference**: `600_security_privacy.md` §4.12 (Cookie Consent Technical Implementation)

### 4.2. Strict Opt-In
*   **Rule 4.2.1**: All tracking beyond essential cookies must be **blocked** without explicit user consent. No nudging.
*   **Rule 4.2.2**: "Reject All" must have **equal visibility** to "Accept All" on consent banners.

#### 4.2.1. Consent Management API Implementation Pattern

```typescript
// --- Consent Management API Endpoint Design ---
// POST   /api/v1/consents          - Create consent record
// GET    /api/v1/consents/:userId   - Get user consent state
// PATCH  /api/v1/consents/:userId   - Update consent state (partial revocation, etc.)
// DELETE /api/v1/consents/:userId   - Revoke all consents

interface ConsentRecord {
  userId: string;
  consents: {
    category: 'necessary' | 'analytics' | 'marketing' | 'personalization';
    granted: boolean;
    grantedAt: string | null;     // ISO 8601
    revokedAt: string | null;
    legalBasis: 'consent' | 'legitimate_interest' | 'contract';
    policyVersion: string;       // Policy version at time of consent
  }[];
  metadata: {
    ipAddress: string;           // Store hashed
    userAgent: string;
    jurisdiction: string;        // Auto-detected from GeoIP
    consentMethod: 'banner' | 'settings' | 'api';
  };
}
```

```typescript
// --- Server-Side Consent Enforcement Middleware ---
import type { NextRequest, NextResponse } from 'next/server';

export function consentMiddleware(req: NextRequest): NextResponse {
  const consentCookie = req.cookies.get('consent_state');
  const consent = consentCookie
    ? JSON.parse(consentCookie.value)
    : { analytics: false, marketing: false };

  // Block tracking scripts without consent
  const response = NextResponse.next();
  response.headers.set('X-Consent-Analytics', String(consent.analytics));
  response.headers.set('X-Consent-Marketing', String(consent.marketing));

  // Block third-party scripts via CSP when no consent
  if (!consent.marketing) {
    const csp = response.headers.get('Content-Security-Policy') || '';
    response.headers.set(
      'Content-Security-Policy',
      `${csp}; script-src 'self'` // Exclude marketing script domains
    );
  }
  return response;
}
```

*   **Mandate**: Consent state must be managed in DB; cookies are only client-side cache. Server-side enforcement must always be implemented.
*   **Cross-Reference**: `600_security_privacy.md` (CSP configuration)

### 4.3. Cookie Classification & Consent Requirements

| Category | Examples | Consent |
|:---------|:---------|:--------|
| **Essential** | Session ID, CSRF token | Not required (service operation) |
| **Functional** | Language, theme preferences | Not required (user convenience) |
| **Analytics** | Analytics, heatmaps | **Required** |
| **Advertising** | Ad serving, retargeting | **Required** |

### 4.4. CMP Implementation Standards
*   **Initial State**: Analytics and advertising cookies **disabled** on first visit. Enabled only after explicit consent.
*   **Banner UI**: Provide 3 options: "Accept All", "Customize", "Reject".
*   **Persistence**: Store consent state in DB or LocalStorage. Do not re-display banner on return visits.
*   **Consent Withdrawal**: Ensure accessible pathway (e.g., footer link) for users to withdraw consent at any time.
*   **Server-Side Recording**: Record consent state server-side and maintain audit trail.
*   **Mandate**: Default is "Reject All". Only enable categories actively consented to by the user.

### 4.7. GDPR Digital Omnibus Reform (2025.11 Proposal)

> [!NOTE]
> The Digital Omnibus Package does not "replace" the GDPR but aims to "harmonize, clarify, and simplify" it. Under review by the European Parliament and Council. Comply with current rules until enacted.

#### 4.7.1. Cookie Consent Simplification
*   **One-Click Reject**: Mandatory implementation of one-click "Reject All" in cookie banners expected. Must have equal prominence to "Accept All".
*   **Consent Exemption Expansion**: **Audience measurement cookies** and **security maintenance cookies** exempt from consent. Targeting/advertising cookies still require consent.
*   **Re-Request Restriction**: Re-requesting consent from users who rejected is **prohibited for 6 months**.
*   **Cookie Violation Fines**: Cookie-related violation fines aligned to GDPR levels (max €20M / 4% global turnover).
*   **Centralized Settings Concept**: Proposal for users to manage cookie settings centrally via browser settings, simplifying per-site banner displays.

#### 4.7.2. "Personal Data" Definition Clarification
*   **Entity-Specific Identifiability Test**: Assess identifiability per entity based on "means reasonably likely to be used." Codifies the CJEU SRB judgment.
*   **Pseudonymized Data Clarification**: Controllers can assess when pseudonymized data falls outside GDPR scope for specific entities. Impacts analytics and AI pipelines.
*   **Engineering Impact**: Document pseudonymization processing flows and establish re-identification risk assessment processes.

#### 4.7.3. DSAR (Data Subject Access Request) Reform
*   **New Abuse Refusal Ground**: When data subjects abuse DSARs for purposes unrelated to data protection, refusal or reasonable fee charging becomes possible.
*   **Action**: Add abuse determination process to DSAR processing flows. Exercise caution with criteria to avoid wrongly refusing legitimate requests.

#### 4.7.4. AI Data Processing Legitimate Interest Clarification
*   **Legitimate Interest for AI Development**: Legitimate interest applicable as legal basis for personal data processing in AI development/operation (subject to balancing test).
*   **Special Category Data**: New conditions introduced for processing special category data (SCD) in AI development/operation.
*   **Anti-Pattern**: "Digital Omnibus freed AI training" is wrong. Balancing test and transparency obligations remain mandatory.

#### 4.7.5. Data Breach Notification Changes
*   **Threshold Elevation**: DPA notification threshold raised from "risk" to "**high risk**".
*   **Deadline Extension**: 72 hours → **96 hours** extension proposed.
*   **One-Stop Notification**: **Single notification entry point** proposed for multi-regime scenarios.

#### 4.7.6. DPIA Harmonization
*   **EU-Wide Guidance Harmonization**: Harmonize DPIA requirements across the EU. Proposes unified list of processing activities requiring DPIA and a **standard template**.

*   **Mandate**: As this is a proposal, comply with current rules until enacted. However, equal-prominence "Reject All" button is already mandated by current Rule 4.2.2. Monitor Digital Omnibus developments **quarterly** and begin implementation preparation for enactment.

### 4.5. Cookieless Tracking Legal Status
*   **Browser Fingerprinting**: Under ePrivacy Directive, subject to **same consent obligations** as cookies. Fingerprinting without consent is illegal.
*   **Server-Side Tagging**: Server-side tags also require consent when processing personal data. "Server-side means no consent needed" is **wrong**.
*   **Privacy Sandbox API Retirement (2025.10)**: Google **discontinued** Topics API, Protected Audience, Attribution Reporting, and IP Protection. Low adoption and ecosystem feedback drove the decision.
    *   **Continuing APIs**: CHIPS (partitioned cookies), FedCM (federated credential management), Private State Tokens (fraud prevention) remain.
    *   **Engineering Impact**: Implementations dependent on Privacy Sandbox **must immediately migrate to first-party data strategies**.
*   **Google Cookie Deprecation Reversal (2025.4)**: Google officially reversed the complete third-party cookie phase-out plan. Transitioning to user-choice model in Chrome settings.
    *   **Reality**: Safari/Firefox already block by default. Approximately 30-40% of all users are in cookie-blocked environments.
    *   **Mandate**: Default to data collection and advertising designs that do not assume cookie availability. Prioritize first-party data and contextual advertising.
    *   **Anti-Pattern**: "Google reversed, so cookie dependency is fine" is wrong. Cookieless trend is irreversible from both regulatory and browser specification perspectives.
*   **UK DUAA 2025**: UK relaxes consent requirements for low-risk analytics cookies (notice + opt-out). Marketing cookies still require consent. Cookie violation fines raised to GDPR levels (max £17.5M / 4% global turnover).
*   **GDPR Digital Omnibus (Q4 2025 proposal)**: Proposes cookie consent simplification and SME exemption expansion. Comply with current rules until enacted.

### 4.6. Third-Party Script Governance
*   **Principle**: Third-party JS/SDKs must **not load at all** until the user consents to the relevant category.
*   **Tag Manager Rules**: When using GTM etc., implement consent-status-based tag firing control integrated with CMP.
*   **Vendor Contracts**: Specify data collection scope, purpose, and retention period in DPA (§13) when onboarding third-party SDKs.
*   **Audit**: Audit actually-loaded scripts quarterly to detect unauthorized script injection.

### 4.8. Universal Opt-Out Mechanism (GPC) Implementation

> [!IMPORTANT]
> Global Privacy Control (GPC) signal recognition is a **legal obligation** in multiple US states. Mandatory in California under CCPA/CPRA since 2023. Connecticut and Oregon also mandatory from January 2026.

*   **Definition**: GPC is a technical specification that allows users to broadcast a "do not sell/share" preference via browser settings (`Sec-GPC: 1` header).
*   **Mandatory States (as of 2026)**: California, Colorado, Connecticut, Montana, Oregon, Texas
*   **Implementation Requirements**:

```typescript
// --- GPC Signal Detection Middleware ---
import type { NextRequest, NextResponse } from 'next/server';

export function gpcMiddleware(req: NextRequest): NextResponse {
  const gpcSignal = req.headers.get('Sec-GPC');
  const response = NextResponse.next();

  if (gpcSignal === '1') {
    // GPC signal detected: treat as opt-out
    response.headers.set('X-GPC-Honored', 'true');

    // 1. Disable targeted advertising cookies
    // 2. Stop third-party data sharing
    // 3. Record "do not sell/share" state in DB
    // 4. Set analytics cookie consent conservatively
  }

  return response;
}
```

*   **Mandate**: When a GPC signal is received, process it as an opt-out **without requiring additional user action**. "Ignoring GPC and requesting re-confirmation via banner" is illegal.
*   **Cross-Reference**: §6.3.2 (US State Laws), §4.2 (Strict Opt-In)

---

## §5. Terms of Service & Privacy Policy

### 5.1. Dynamic Consent Management
*   **Rule 5.1.1**: Record in the database "when and which version of terms the user consented to" and retain as legal evidence.
*   **Rule 5.1.2**: Upon terms revision, force-display consent screen on next login.
*   **Required Consent Record Fields**: User ID, consent type, consent timestamp, IP address, User-Agent, terms version

### 5.2. Legal Archive
*   **Rule 5.2.1**: Never delete past terms. Keep them permanently accessible as permalinks.
*   **Rule 5.2.2**: When updating terms pages, auto-save pre-update data to a revision table (no deletion).

### 5.3. Layered Notice
*   Privacy policies must display a **plain language summary** before the detailed legal text.

### 5.4. Legal Document SSoT
*   **Law**: Hardcoding legal documents in source code is prohibited.
*   **Action**: Legal documents must use a **Headless CMS** or **database** as the single source of truth.
*   **No Code Deployment for Terms**: A design requiring app redeployment for legal text changes is a design defect.
*   **Cross-Reference**: `600_security_privacy.md` §3.3 (Legal Content Consistency Protocol)

### 5.5. Consent Legal Validity Standards

| Consent Form | Legal Validity | Recommended Use |
|:-------------|:--------------|:---------------|
| **Clickwrap** | ✅ Strong | Terms acceptance, payment consent |
| **Sign-in-wrap** | ⚠️ Moderate | Low-risk terms updates |
| **Browsewrap** | ❌ Weak | Do not use |

### 5.6. Dispute Resolution & Arbitration Clauses
*   **Arbitration**: Arbitration clauses recommended for B2B contracts. Specify governing law, arbitration institution, and language.
*   **Class Action Waiver**: Class action waivers in B2C terms are invalid in the EU. US also has state-level restrictions.
*   **ADR**: Services targeting EU users must provide links to ODR (Online Dispute Resolution) platform.

---

## §6. Regional Compliance

### 6.1. Japanese Law

#### 6.1.1. Act on Specified Commercial Transactions
*   When offering paid services, mandatory display of required disclosures within the app.
*   **Disclosure Items**: Business name, address, phone, representative, pricing, payment timing/method, delivery timing, cancellation policy.
*   **Final Confirmation Screen**: Display **contract period**, **billing timing**, and **cancellation conditions** clearly on the pre-payment screen.

#### 6.1.2. Payment Services Act
*   **Deposit Avoidance**: Issuing prepaid payment instruments carries deposit obligation risks. Prefer Apple/Google IAP.

#### 6.1.3. Advertising Disclosure (Stealth Marketing Regulation)
*   **Law**: Content with monetary consideration from advertisers must display "PR" or "Ad" labeling.
*   **System Guard**: System-level automatic ad labeling on posts with `is_sponsored` flag.

#### 6.1.4. Email Compliance
*   **Opt-In**: Explicit prior consent required for promotional emails; record consent timestamp.
*   **Sender Disclosure**: Display sender name, contact information, and unsubscribe method on all emails.
*   **Unsubscribe**: One-click unsubscribe link required.
*   **Audit Trail**: Log all system email transmissions. Store email addresses masked.

#### 6.1.5. Subscription Auto-Renewal Law
*   Clearly disclose auto-renewal facts and conditions **before** contract
*   Require explicit confirmation step **before** transitioning from free trial to paid
*   Provide cancellation method at **equal or lesser difficulty** than sign-up
*   Send reminder notification **7 days before** renewal
*   **FTC Click-to-Cancel Rule**: Obligation to enable cancellation via the same channel as registration.

#### 6.1.6. APPI Amendment Act (Expected Enforcement 2027)
*   **Legislative Progress**: PPC initiated review in November 2023. Interim report June 2024. **"Amendment Policy Direction" officially published on January 9, 2026**. Amendment bill to be submitted to the ordinary Diet session (opening January 23, 2026). Expected enforcement 2027.
*   **Confirmed Policy Direction (2026.1)**:
    *   **Introduction of Administrative Monetary Penalties**: New **administrative fines** for malicious large-scale personal data trading. Significantly strengthens the current guidance/recommendation/order-based enforcement regime
    *   **AI Development Data Use Relaxation**: Policy to **permit use without consent** for AI training purposes of **special care-required personal information** (criminal history, medical history, race, etc.). Limited to statistical processing and model training
    *   **Certified Organization Incident Reporting Relaxation**: Extends incident reporting deadline for certified organizations to **30 or 60 days** for unauthorized access (relaxed from current immediate reporting obligation)
*   **Items Still Under Discussion**:
    *   **Injunctive Relief**: Discussion on introducing injunctive relief and damage recovery through qualified consumer organizations
    *   **Biometric Data Regulation**: Current APPI does not classify biometric data as "special care-required personal information". Strengthening under consideration
    *   **Children's Data**: Development of clear guidance for children's personal information (consent procedures, security measures)
    *   **Improper Use Clarification**: Specifying and categorizing scope of improper use and unauthorized acquisition regulations
    *   **Opt-Out System Strengthening**: Reinforcing obligations for third-party provision opt-out system
*   **Action**: Monitor bill deliberation in the 2026 Diet. Secure compliance budget **upon confirmation of penalty amounts and application criteria**. AI development relaxation directly impacts handling policies for special care-required personal information; develop response plan through AI Governance Committee (§11.9).
*   **Anti-Pattern**: "AI development relaxation is confirmed so we can freely use special care-required personal information for training data" is WRONG. Relaxation is limited to statistical processing and model training; **purpose limitation violations, re-identification, and third-party provision remain prohibited**.

### 6.2. EU Law

#### 6.2.1. GDPR-Specific Requirements
*   **DPO Appointment**: DPO is mandatory when conducting large-scale personal data processing.
*   **DPIA**: Conduct DPIA before initiating high-risk data processing.
*   **ROPA**: Maintain records of data processing activities.
*   **EDPB 2026 Coordinated Enforcement**: GDPR Art.12-14 (transparency obligations) is the priority theme for 2026 coordinated enforcement.
*   **Cross-Reference**: `600_security_privacy.md` §4.3 (PIA)

#### 6.2.2. DPIA Methodology (7 Steps)
*   **Trigger**: Large-scale profiling / Large-scale sensitive data processing / AI & new technology adoption / Automated decision-making / Vulnerable persons data / Dataset combination
*   **7 Steps**:
    1.  **Necessity Assessment**: Evaluate if triggers apply
    2.  **Processing Description**: Detail nature, scope, context, purpose, data flows, retention periods
    3.  **Necessity & Proportionality**: Verify minimum data needed for the purpose
    4.  **Risk Identification & Assessment**: Evaluate with "Likelihood × Severity" matrix
    5.  **Mitigation Measures**: Document specific measures (anonymization, encryption, access controls)
    6.  **DPO & Stakeholder Consultation**: Obtain DPO advice
    7.  **Approval, Recording & Periodic Review**: Approve residual risk level, re-evaluate when processing changes
*   **Living Document**: DPIA is a **living document** that must be re-evaluated whenever significant changes occur to the processing.

#### 6.2.3. DSA/DMA
*   **Transparency Reporting**: Obligation to publish transparency reports on content moderation activities.
*   **Ad Transparency**: Obligation to disclose targeting advertising delivery reasons to users.

#### 6.2.4. European Accessibility Act (EAA)
*   **Law**: Effective June 2025. Positions WCAG 2.1 AA compliance as a legal obligation.
*   **Cross-Reference**: `200_design_ux.md` (Accessibility detailed standards)

#### 6.2.5. UK Data (Use and Access) Act 2025 (DUAA)
*   **Law**: Royal Assent June 2025. Targeted amendments to UK GDPR. Phased enforcement (2025.6-2026.6).
*   **Key Changes**:
    *   **SAR Response Relaxation**: "Reasonable and proportionate" search standard. "Stop the clock" rule when additional information needed
    *   **ADM (Automated Decision-Making) Relaxation**: Permits ADM for non-special-category data (rights to challenge and request human intervention maintained)
    *   **Recognised Legitimate Interests**: No balancing test required for specific purposes (national security, crime prevention, safeguarding vulnerable individuals)
    *   **International Data Transfers**: Standard relaxed from "essentially equivalent" to "not materially lower"
    *   **Cookie Violation Fines**: Raised to GDPR levels (max **£17.5M / 4% global turnover**)
    *   **Complaint Handling Obligation**: Acknowledge receipt within 30 days, investigate without undue delay
*   **Smart Data Scheme**: Open Banking-extended data portability system. Expansion planned for finance, energy, telecoms, and transport sectors.
*   **DVS (Digital Verification Services)**: Legal foundation for digital identity verification services. UK CertifID trust mark certified DVS registry (effective 2025.12).
*   **Action**: For services targeting UK users, update SAR processing flows, ADM policies, and cookie management for DUAA compliance.

### 6.3. US Law

#### 6.3.1. CCPA/CPRA-Specific Requirements
*   **Do Not Sell / Share**: Place "Do Not Sell or Share My Personal Information" link in website footer.
*   **Sensitive Personal Information**: Processing restrictions on sensitive PI.
*   **Right to Correct**: Support personal information correction requests.
*   **Right to Know (Enhanced)**: From 2026.1, access rights extended beyond past 12 months to information collected since 2022.1.1.
*   **Cybersecurity Audits**: Businesses with revenue >$100M must complete initial certification by **2028.4.1**.

#### 6.3.2. US State Law Proliferation (2025-2026)
*   **Mandate**: In the absence of a federal privacy law, US state laws are proliferating. When serving users across multiple states, design privacy frameworks based on the **most restrictive state law**.
*   **2025 Enforcement States**: Delaware, Iowa, Nebraska, New Hampshire, New Jersey, Tennessee
*   **2026 Enforcement States**: Kentucky, Rhode Island, Indiana, Maryland, Minnesota
*   **Neural Data Addition**: Connecticut (2026.7) adds Neural Data to sensitive data categories.
*   **Multi-State Coordinated Enforcement (2026 Trends)**: Multiple state AGs from Colorado, Connecticut, Maryland, Minnesota, Oregon, New Jersey and others intensifying **coordinated enforcement actions**. Increasing instances of simultaneous enforcement from multiple states for single violations.
*   **Enforcement Priority Areas (2026)**:
    *   User choice integrity (dark pattern countermeasures)
    *   Universal Opt-Out Signal (GPC etc.) recognition obligation
    *   Data broker registration obligation
    *   Children's and teen privacy protection
    *   Privacy policy compliance
*   **Federal Trends**:
    *   **December 2025 Executive Order**: Established **federal preemption** policy for state AI regulation hindering national competitiveness. Established AI Litigation Task Force to pursue legal challenges against state laws.
    *   **Federal Funding Conditionality**: Certain federal funding conditioned on states not enacting conflicting AI regulations.
    *   **Commerce Secretary Evaluation Directive**: Directed evaluation of existing state AI laws' impact on national competitiveness.
    *   **Impact**: Rising tension between state laws and federal policy; **state law validity may be challenged in courts**. Continue complying with existing state laws while monitoring federal developments quarterly.
*   **Oregon Precise Geolocation Ban (2026)**: Oregon's privacy law amendment classifies precise geolocation data (within 1,750-foot radius) as **sensitive data**, requiring opt-in consent for collection.

#### 6.3.3. California Delete Act / DROP
*   **Law**: Data brokers must process deletion requests via DROP (Delete Request and Opt-Out Platform) from **2026.8.1**.
*   **Engineering Impact**: If classified as a data broker, consider DROP API integration at design time.
*   **Cross-Reference**: §32 (Data Broker Regulation)

#### 6.3.4. Maryland Online Data Protection Act (MODPA)
*   **Law**: Effective October 2025. Strong data minimization obligation restricting data collection to what is "reasonably necessary and proportionate".
*   **Features**: Prohibits targeted advertising using sensitive data, prohibits targeted advertising to minors under 18.

---

## §7. Children & Vulnerable Persons Data Protection

### 7.1. Age Gate
*   **Rule 7.1.1**: Services with billing must implement age verification (date of birth entry).
*   **Rule 7.1.2**: Technically prevent circumvention of age verification.

### 7.2. Parental Consent
*   **Law**: Processing personal data of users under legal age (Japan: 18, EU: 16 with member state variations 13-16, US COPPA: 13) requires parental consent.
*   **Action**: Mandatory consent checkbox, timestamp & IP logging, VPC for users under 13.
*   **India DPDP Act (2026.11)**: Verifiable Parental Consent and consent manager registration become mandatory.

### 7.3. Age-Appropriate Design
*   **Rule 7.3.1**: Apply **Privacy by Default** at the highest level for services accessible to children.
*   **Rule 7.3.2**: **Prohibit** profiling and targeted advertising for children's content.
*   **Rule 7.3.3**: Location tracking **disabled** by default.
*   **Rule 7.3.4**: Push notifications and engagement-promoting features **disabled** by default.

### 7.4. Spending Limits
*   **Mandate**: Set monthly spending caps for minors with parental notification when exceeded.
*   **Anti-Pattern**: Non-disclosure of loot box (gacha) probabilities is subject to increasing regulation. Explicitly disclose probabilities.

### 7.5. Biometric Data
*   **Law**: Biometric data requires the highest level of protection as it cannot be changed once compromised.
*   **Key Regulations**:
    *   **BIPA (Illinois)**: Written consent before collection, purpose disclosure, retention policy required. Liability per **individual** violation.
    *   **EU AI Act**: Real-time remote biometric identification in public spaces **prohibited** in principle (effective 2025.2).
    *   **GDPR Art.9**: Biometric data classified as "special category" — processing prohibited in principle.
*   **Implementation Requirements**:
    *   Written informed consent before collection (electronic signature acceptable)
    *   Explicit retention period (delete within **3 years** of purpose completion or last interaction)
    *   **AES-256+** encryption for storage, mandatory access logging
    *   Assess and document deepfake surface risks
*   **Cross-Reference**: `600_security_privacy.md` (Zero Trust Authentication)

### 7.6. Global Expansion of Age Verification Obligations
*   **Background**: In 2025-2026, restrictions on minors' social media use are rapidly expanding worldwide. Self-declaration age verification is increasingly deemed insufficient.

| Jurisdiction | Legislation | Target Age | Effective | Requirements |
|:------------|:-----------|:----------|:----------|:------------|
| **UK** | Online Safety Act 2023 | All ages | 2025.7 | "Highly effective age assurance" obligation. Ofcom fines: 10% global revenue |
| **Australia** | Social Media Ban | <16 | 2025.12 | Social media ban for under-16. Age verification obligation on platforms |
| **Malaysia** | SNS Ban + eKYC | <16 | 2026.1 | Under-16 ban. eKYC age verification required |
| **Louisiana** | SB 162 | <16 | 2025.7 | Age verification for all users. Parental consent required for under-16 |
| **California** | SB 976 | <18 | 2026.12 | After age verification, exclude under-18 from addictive feeds |
| **Nebraska** | LB 383 | <18 | 2026.7 | Age verification + parental consent required |
| **Tennessee** | HB 1891 | <18 | 2025.1 | Age verification + parental consent required |

*   **Mandate**: Globally deployed services must design based on the **most stringent jurisdiction's age verification obligations**.
*   **Anti-Pattern**: Self-declaration only (checkbox "I am 18+") is **insufficient** under UK/AU/MY law.

### 7.7. COPPA 2.0 (KIDS Act)
*   **Bill**: Passed unanimously by the Senate in March 2026. Protection scope expanded from under-13 to **under-17**.
*   **Key Requirements**:
    *   **Prohibit** targeted advertising to minors
    *   Default **disable** addictive features (infinite scroll, autoplay, etc.)
    *   Apply strongest privacy settings by default
    *   Mandatory provision of parental control features
*   **FTC COPPA Rule Amendment (effective 2025.6)**: Strengthened opt-in parental consent for targeted advertising and data retention limits. FTC issued policy statement encouraging use of age verification technologies (2026.2).
*   **Action**: Begin preparing to extend current §7.1-7.4 requirements to COPPA 2.0's under-17 standard. Build into design phase for immediate compliance upon enactment.

### 7.8. Age Verification Technology Requirements
*   **Technology Options Comparison**:

| Method | Accuracy | Privacy Risk | Cost | Adoption Examples |
|:-------|:---------|:------------|:-----|:-----------------|
| **Self-Declaration (DOB input)** | Low | Low | Low | Current majority of services |
| **Facial Age Estimation AI** | Medium-High | Medium (biometric processing) | Medium | UK Online Safety Act recommended |
| **Digital ID (DVS/eKYC)** | High | Medium (ID linkage) | Medium | UK DUAA DVS, Malaysia eKYC |
| **Government-Issued ID Verification** | Highest | High (PII processing) | High | Australia ban compliance |
| **Credit Card Verification** | Medium | Low | Low | Existing COPPA method |

*   **Mandate**: When implementing age verification, **DPIA must be conducted** (per §6.2.2).
*   **Principle**: Data collected for age verification must not be used for any other purpose. Delete promptly after verification completion.
*   **Cross-Reference**: §6.2.5 (UK DUAA DVS)

---

## §8. Dark Pattern Prohibition

### 8.1. Definition & Prohibited Actions
*   **Law**: Dark patterns are explicitly prohibited under EU DSA and CCPA/CPRA. Regulators are intensifying scrutiny of CMP consent UI manipulability.

### 8.2. Prohibited Patterns

| Pattern | Definition | Prohibited Example |
|:--------|:----------|:------------------|
| **Confirm Shaming** | Guilt-inducing language for rejection | "No, I don't want discounts" |
| **Trick Questions** | Double negatives causing confusion | "I do not wish to not receive notifications" |
| **Hidden Costs** | Revealing additional fees at final stage | Sudden surcharge at cart checkout |
| **Forced Continuity** | Intentionally difficult cancellation | Phone-only cancellation, hidden cancel button |
| **Roach Motel** | Easy sign-up, hard exit | 1-click signup → 10-step cancellation |
| **Privacy Zuckering** | Default excessive information sharing | All info set to "Public" by default |
| **Nagging** | Repeated permission requests | Pop-up reappearing immediately after rejection |
| **Preselection** | Unfavorable options pre-selected | Promotional email checkbox defaulting to ON |

### 8.3. Design Principles
*   **Rule 8.3.1**: Consent acquisition and withdrawal must be offered with **equal ease** (Symmetry of Choice).
*   **Rule 8.3.2**: Cancellation/withdrawal processes must be completable in **equal or fewer steps** than registration.
*   **Rule 8.3.3**: Default settings must always be set to **maximize user privacy protection**.
*   **Rule 8.3.4**: Visually subordinating rejection options is prohibited (font size, color, position).

---

## §9. IP & License Governance

### 9.1. License Contamination Prevention
*   **GPL Prohibited**: Copyleft license (GPL/AGPL) code contamination is strictly forbidden.
*   **Rights Clearance**: Verify commercial use eligibility for all assets and centrally manage license evidence.
*   **Cross-Reference**: `602_oss_compliance.md`

### 9.2. UGC License Grant
*   **Law**: Include in ToS a "free, non-exclusive license for promotional use" grant clause for UGC.
*   **Safeguard**: Include moral rights non-assertion clause to prevent undue user rights infringement.

### 9.3. Work-for-Hire Protocol
*   **Mandate**: Contractor agreements must include:
    *   Copyright transfer (including Art.27 & 28) to the client upon acceptance
    *   Moral rights non-assertion clause
*   **Cross-Reference**: `603_ip_due_diligence.md`

---

## §10. Anti-Social Forces Exclusion

### 10.1. Contract Clauses (Mandatory)
*   **Mandate**: All contracts and terms must include:
    *   Representation and warranty of non-affiliation with anti-social forces
    *   Covenant not to utilize anti-social forces
    *   Immediate contract termination right (without notice) upon discovery
    *   Reservation of right to claim damages

### 10.2. KYB/KYC Due Diligence
*   **Corporate Transactions**: Conduct KYB screening. **Individual Transactions**: Conduct KYC screening.
*   **Screening**: Cross-reference against anti-social force databases.
*   **Periodic Checks**: Mandate **annual re-screening**, not just initial checks.

### 10.3. Immediate Response Upon Discovery
1.  Immediate report to legal department
2.  Send contract termination via certified mail
3.  Immediately suspend related service accounts
4.  Consult with and report to police and organized crime exclusion centers

---

## §11. AI Regulation & EU AI Act

### 11.1. EU AI Act Risk Classification

| Risk Level | Definition | Examples | Obligations |
|:-----------|:----------|:---------|:-----------|
| **Prohibited** | AI threatening fundamental rights | Social scoring, workplace emotion recognition, real-time remote biometric identification | **Banned** (effective 2025.2) |
| **High Risk** | Significant safety/rights impact | Recruitment AI, credit scoring, critical infrastructure management | Risk management, conformity assessment, human oversight, technical documentation, logging (**effective 2026.8**) |
| **Limited Risk** | Transparency obligations only | Chatbots, deepfake generation | Explicit **AI-generated labeling** (**effective 2026.8**) |
| **Minimal Risk** | No additional obligations | Spam filters, game AI | Voluntary code of conduct recommended |

### 11.2. EU AI Act Phased Enforcement Timeline

| Effective Date | Applicable Content |
|:--------------|:------------------|
| **2025.2.2** | Prohibition provisions (Unacceptable Risk), AI literacy obligations (Art.4) |
| **2025.8.2** | GPAI obligations, governance bodies (AI Board/Scientific Panel), member state authority designation & penalty legislation |
| **2026.8.2** | High-risk AI obligations (Annex III), transparency obligations (Art.50), AI sandbox establishment mandate ※**Deferral proposal pending** (see below) |
| **2027.8.2** | High-risk AI (product safety legislation: medical devices, aviation, etc.) |

> [!WARNING]
> **EU AI Act Enforcement Deferral Proposal (2026.3)**: The European Commission published a proposal to defer Annex III high-risk AI obligations to **December 2027**. Requires member state and European Parliament agreement. **Continue preparing based on 2026.8 deadline until confirmed**. Even if deferral is confirmed, informal guidance and expectations from the AI Office are unlikely to change.

### 11.3. High-Risk AI System Obligations
*   **Risk Management System**: Build and document risk management throughout the AI lifecycle.
*   **Data Quality**: Guarantee training data representativeness, accuracy, and bias elimination.
*   **Technical Documentation**: Create and maintain comprehensive technical documentation before market deployment.
*   **Log Retention**: Retain auto-generated event logs for a **minimum of 6 months**.
*   **Human Oversight**: Design AI systems to enable effective human oversight during operation.
*   **Conformity Assessment**: Conduct Conformity Assessment.

### 11.4. GPAI (General-Purpose AI) Model Obligations
*   **All GPAI Models**: Technical documentation, Copyright Directive compliance, training data summary publication.
*   **Systemic Risk GPAI (Additional)**: Model evaluation (including adversarial testing), risk mitigation measures, serious incident reporting, cybersecurity protection.
*   **Enforcement Timeline**: New GPAI models released from 2025.8.2 must comply immediately. Formal enforcement by AI Office begins **2026.8.2**. Models predating 2025.8.2 must comply by **2027.8.2**.

#### 11.4.1. GPAI Code of Practice (Published 2025.7)
*   **Overview**: Voluntary code of conduct developed by independent experts. Provides **practical guidance** on GPAI model provider transparency, copyright, and safety obligations.
*   **Legal Status**: Not legally binding but functions as a **critical means** of demonstrating AI Act compliance. Non-compliance risks individual AI Office scrutiny.
*   **Key Compliance Domains**:

| Domain | Requirements |
|:-------|:------------|
| **Transparency** | Create and publish technical documentation, provide sufficient training data summaries (data source types, scale, curation methods), describe model capabilities and limitations |
| **Copyright Compliance** | Develop and publish copyright compliance policies for training data. Comply with EU Copyright Directive text & data mining (TDM) exceptions. Technical measures respecting rightholders' opt-out (Art.4 TDM reservation rights) |
| **Safety & Security** | Systemic risk GPAI must conduct adversarial testing (red-teaming), perform risk assessments, and document/publish cybersecurity protection measures |

*   **Copyright Compliance Policy Implementation Requirements**:
    *   Comply with robots.txt / ai.txt crawler control rules (§11.11 reference)
    *   Document rightsholder opt-out request processing flows
    *   Record training dataset data source and curation processes
    *   Conduct legal assessment of TDM exception applicability
*   **Mandate**: When using or providing GPAI models, document compliance status with Code of Practice key requirements and review in AI Governance Committee (§11.9).

### 11.5. Agentic AI Liability Framework
*   **Risk**: Agentic AI (AI systems that autonomously make decisions and take actions) creates a "responsibility gap" in existing liability models, unlike traditional predictable tools.
*   **Legal Challenges**:
    *   Traditional tort law struggles to attribute liability for actions of AI agents that adapt and evolve
    *   Many technology contracts don't cover the types of harm agentic AI can cause
    *   Customer-side risk-bearing contract structures are common
*   **Countermeasures**:
    *   Record **all** agentic AI decision logs to ensure accountability traceability
    *   Explicitly specify **liability demarcation clauses** for agentic AI actions in vendor contracts
    *   Require Human-in-the-Loop (HITL) for critical decisions, limiting fully autonomous scope
    *   Constrain agentic AI behavior scope with **explicit guardrails**
*   **Cross-Reference**: `400_ai_engineering.md` (Guardrails), `600_security_privacy.md` (AI/LLM Security)

### 11.6. AI-Generated Content Copyright
*   **No Direct Publish**: **Prohibit** publishing AI-generated text directly as official articles.
*   **AI Image Risk Assessment**: Evaluate training data copyright risks before commercial use of AI-generated images.
*   **DB Flag**: `is_ai_assisted: boolean` (default: `false`).

### 11.7. User Data AI Training Control
*   **Opt-Out by Default**: User data is **not used** for AI training by default.
*   **Explicit Opt-In**: Usage only after explicit consent, following anonymization.
*   **DB Flag**: `ai_training_opt_in: boolean DEFAULT false`.
*   **Right to Withdraw**: Opt-in can be withdrawn at any time. Excluded from next training batch after withdrawal.

### 11.8. Data Commercialization Opt-Out
*   **Opt-Out Switch**: Place "Data Participation" ON/OFF switch in user settings.
*   **DB Flag**: `data_commercialization_opt_out: boolean DEFAULT false`.
*   **Anonymization Mandate**: Apply **k-anonymization** or **differential privacy** to externally provided data.

### 11.9. AI Governance Committee
*   Establish an **AI Governance Committee** upon reaching a certain business scale:
    *   Technical lead, legal/compliance officer, user representative
*   **Scope**: Model selection, prompt policy changes, new AI feature risk assessment, incident response.
*   **Cadence**: Quarterly reviews + emergency ad-hoc convening.
*   **AI Literacy Mandate**: Deliver AI literacy training to all employees involved in AI-related work (EU AI Act Art.4, **effective 2025.2**).

### 11.10. GenAI Hallucination Liability
*   **Risk**: Hallucinations create legal liability, defamation, and regulatory violation risks.
*   **Countermeasures**:
    *   **Prohibit** using GenAI output directly as official information
    *   **Mandatory disclaimer** "Responses may be inaccurate" for user-facing AI features
    *   Secure **indemnification clauses**, liability demarcation, and training data opt-out rights in GenAI provider contracts
*   **GDPR Risk**: AI generating inaccurate information about individuals may violate GDPR **Art.5(1)(d)** (data accuracy principle).

### 11.11. GenAI Training Data Compliance

#### 11.11.1. Copyright & Scraping Legislation

| Jurisdiction | Regulation | Requirements |
|:-------------|:----------|:-------------|
| **EU** | EU AI Act + DSM Directive Art.4 | GPAI model providers must publish structured summaries of training data. **Obligation to respect** text and data mining opt-outs |
| **US** | CA AB 2013 (effective 2026.1) | Disclosure obligation for training data sources, types, and inclusion of copyrighted content |
| **US** | AI Accountability for Publishers Act (2026 proposed) | Legal enforceability of robots.txt, limiting Fair Use defense, mandatory payment to publishers |
| **Japan** | Copyright Act Art.30-4 | Use of copyrighted works for information analysis is generally lawful. Exception: when it "unreasonably prejudices the interests" of the rights holder |

*   **Anti-Pattern**: Anthropic used pirated data for training and paid a **$1.5B** settlement (2025.8). Training data legality verification must be completed **before model development**.

#### 11.11.2. Crawler Control & Opt-Out
*   **robots.txt**: AI crawler blocking is mandatory. However, compliance is voluntary, so legal enforceability is limited.
*   **ai.txt** (2025 proposal): Domain-level granular AI usage permissions (e.g., summarization allowed, training prohibited). Low adoption but monitor developments.
*   **llms.txt**: Content reference file for AI agents. No legal enforceability.
*   **Mandate**: To protect proprietary content, block AI crawlers (GPTBot, Google-Extended, CCBot, etc.) via robots.txt and explicitly prohibit AI training scraping in terms of service.
*   **GenAI Provider Contracts**: Secure training data opt-out rights, output copyright attribution, and indemnification clauses in contracts.

---

## §12. Data Lifecycle Management

### 12.1. Engagement Data Retention Standards

| Data Type | Retention Period | Post-Expiry Action |
|:----------|:----------------|:------------------|
| **Favorites / Bookmarks** | Indefinite | Hard delete upon account deletion |
| **Browsing History** | Last **90 days** | Monthly batch hard delete |
| **Operation Logs** | Last **1 year** | Legally mandated items archived separately |
| **Audit Logs** | **1 year** | Archive then delete |
| **Payment Data** | **Statutory 7 years** | Delete after statutory period |
| **Campaign Data** | Within **90 days** post-end | Hard delete |

*   **Mandate**: Specific retention periods per data type defined in Blueprint. This protocol provides the "template."

### 12.2. Content Archival Standards
*   **Closed Service Entities**: Change status to `closed`/`archived` and exclude from search. Retain related UGC permanently.
*   **Deleted User Content**: Set `owner_id: null`. Retain content with public interest.
*   **Dormant Data**: Auto-notify administrators of archival suggestions for non-public content unchanged for 2+ years.

### 12.3. Automated Cleanup
*   **Mandate**: Auto-execute periodic cleanup jobs via `pg_cron` / Cloud Scheduler etc.

```sql
-- pg_cron automated cleanup job example
SELECT cron.schedule(
  'cleanup-browsing-history',
  '0 3 * * 0', -- Every Sunday 03:00 UTC
  $$DELETE FROM browsing_history WHERE created_at < NOW() - INTERVAL '90 days'$$
);
```

*   **Anonymization Obligation**: When deletion is legally difficult, perform **irreversible anonymization**. Hashing alone is insufficient.

### 12.4. Jurisdiction-Specific Data Retention Period Template

| Data Category | GDPR (EU) | CCPA/CPRA (CA) | APPI (Japan) | Common Recommendation |
|:-------------|:----------|:--------------|:-----------|:---------------------|
| **Customer Account Info** | Until purpose achieved + 3 years post-deletion | Disclosure obligation: 12 months | Until purpose achieved | **Max 3 years** post-deletion |
| **Transaction/Payment Data** | Statutory period (tax: 7 years) | Statutory period | Statutory period (tax: 7 years) | **Per statutory period** |
| **Marketing Consent** | Until revocation + 3 years evidence | Immediate stop after opt-out | Until revocation | Evidence for **5 years** |
| **Access Logs** | Legitimate interest period (recommended: 6 months) | No requirement | Recommended: 1 year | **6 months to 1 year** |
| **CCTV/Surveillance** | 72 hours to 30 days (varies by country) | No requirement | No requirement | **Max 30 days** |
| **Employee Data** | 3-10 years post-employment (varies) | Reasonable period post-employment | 3 years post-resignation (Labor Standards Act) | **Per statutory period** |
| **Health Data** | HIPAA: 6 years / GDPR: until purpose achieved | No requirement | APPI + Medical Law | **Per statutory period** |
| **Children's Data** | COPPA/GDPR: promptly delete after purpose achieved | COPPA: reasonable period | APPI: same | **Delete in shortest period** |

*   **Mandate**: Above is a template. Define specific values in Blueprint.
*   **CCPA/CPRA Disclosure Obligation**: Privacy policies must **publicly disclose** specific retention periods for each category.

#### 12.4.1. Litigation Hold
*   **Definition**: Legal obligation to **immediately suspend** routine deletion of relevant data when litigation, investigation, or regulatory action is reasonably anticipated.
*   **Triggers**: Litigation notice (preservation notice), regulatory investigation initiation notice, internal whistleblowing, audit notice.
*   **Procedure**:
    1.  Legal team issues litigation hold notice
    2.  **Immediately suspend** auto-deletion jobs for affected data (`pg_cron` job disable, etc.)
    3.  Identify and document scope and location of affected data
    4.  Notify relevant parties of preservation obligations (send periodic reminders)
    5.  Hold release only by written approval from legal team
*   **Anti-Pattern**: Deleting data during a litigation hold constitutes **Spoliation**, resulting in sanctions and adverse inference.

---

## §13. Vendor Data Governance

### 13.1. Data Processing Agreement (DPA)
*   **Mandatory Contract Clauses**:
    *   Explicit specification of data scope, types, and storage locations
    *   Prohibition of purpose-deviation use
    *   Sub-processing prohibition in principle (written pre-approval when necessary)
    *   Data return/deletion obligation upon contract termination
    *   Incident reporting obligation (initial report within **24 hours** of discovery)
*   **DPA Template Checklist**:
    *   [ ] Explicit data category and volume specification
    *   [ ] Processing purpose and legal basis
    *   [ ] Data processor obligations (encryption, access controls, log management)
    *   [ ] Sub-processor pre-approval clause
    *   [ ] Audit rights specification
    *   [ ] DSAR cooperation obligation
    *   [ ] Post-termination data deletion/return deadline (**within 30 days**) with evidence
    *   [ ] Governing law and dispute resolution
    *   [ ] Liability caps and indemnification conditions

### 13.2. Data Classification & Sharing Restrictions

| Classification | Sharing | Conditions |
|:--------------|:--------|:----------|
| **Sensitive PII** | Prohibited in principle | Only when unavoidable: encrypted + access-logged |
| **Personal Info** | Conditionally permitted | DPA + encrypted transfer + access restrictions |
| **Quasi-Personal Info** | Permitted | DPA only |
| **Anonymized Data** | Freely shareable | Prerequisite: verified re-identification impossibility |

### 13.3. Vendor Audit Obligations
*   **Annual Audit**: Evaluate vendor security management at least **once annually**.
*   **Evaluation Items**: Security policies, access controls, encryption, incident response, training, third-party certifications (ISO 27001, SOC 2, etc.)
*   **Non-Compliance**: Remediation deadline (max **90 days**). Contract review or termination if not remediated.

### 13.4. Vendor Risk Tiering

| Tier | Criteria | Review Frequency | DPIA | Audit Obligation |
|:------|:--------|:----------------|:-----|:-----------------|
| **Tier 1 (High Risk)** | Sensitive PII processing / Bulk data processing / Core infrastructure operations | **Quarterly** | **Required** | Annual on-site audit |
| **Tier 2 (Medium Risk)** | Personal Info processing / Non-core systems | **Semi-annually** | Recommended | Annual remote audit |
| **Tier 3 (Low Risk)** | Anonymized data only / No PII contact | **Annually** | Not required | SOC 2 / ISO 27001 certificate review |

*   **Mandate**: Tier classification must be completed before new vendor contracts. Tier 1 vendors require **CISO approval**.
*   **Tier Change Triggers**: Changes in data processing scope, security incident occurrence, regulatory environment changes.
*   **Continuous Monitoring**: Tier 1 vendors must be subject to **continuous risk monitoring** via security scoring services (e.g., SecurityScorecard).

### 13.5. Fourth-Party Risk Management
*   **Definition**: Risk management of Sub-Processors to whom Processors further subcontract.
*   **Flow-Through Obligations**: DPA contractual clauses must mandate:
    *   **Full flow-through** of data protection obligations to Sub-Processors (impose equal or greater obligations)
    *   **Prior disclosure** of Sub-Processor list and **30-day advance notice** of changes
    *   Data Controller's **right to object** (right to reject Sub-Processor changes)
*   **Chain Monitoring**:
    *   Obtain and update Tier 1 vendor Sub-Processor lists **quarterly**
    *   Verify Sub-Processors are not under jurisdiction of foreign adversary countries (§33.4)
    *   **Immediate escalation** obligation upon significant Sub-Processor security incidents
*   **Anti-Pattern**: "The vendor manages it so we don't need to be involved" is wrong. Under GDPR Art.28, the Controller bears ultimate responsibility.

---

## §14. Data Breach Legal Notification

### 14.1. Legal Basis
*   **Law**: GDPR Art.33/34, amended APPI Art.26 etc. mandate supervisory authority reporting and user notification upon personal data breaches.
*   **Cross-Reference**: `600_security_privacy.md` §10.7, `503_incident_response.md` §3

### 14.2. 5-Phase Flow

| Phase | Deadline | Owner | Action |
|:------|:---------|:------|:-------|
| **1. Detection** | Immediate | Monitoring System | Anomaly detection → immediate notification |
| **2. Initial Response** | Within **1 hour** of detection | Technical Lead | Identify & block breach path, scope investigation, evidence preservation |
| **3. Preliminary Report** | Within **72 hours** of detection | Legal | Submit preliminary report to supervisory authority |
| **4. User Notification** | **Simultaneous** with preliminary report | CS/Operations | Notify affected users |
| **5. Post-Incident** | Within **30 days** of detection | All Teams | Submit final report, Post-Mortem, prevention measures |

### 14.3. Reporting Thresholds
*   Personal data breach of **1,000+ records**
*   Includes special category personal information
*   Potential for financial harm
*   Breach caused by unauthorized access

### 14.4. Jurisdiction-Specific Notification Deadlines

| Jurisdiction | Authority Notification | User Notification | Notes |
|:-------------|:----------------------|:-----------------|:------|
| **GDPR** | Within **72 hours** | "Without undue delay" for high-risk | Amendment proposes **96-hour** relaxation |
| **APPI** | Preliminary: **3-5 days** / Final: **30 days** | Mandatory individual notification | 2027 amendment may change |
| **CCPA/CPRA** | No explicit statutory deadline | "Most expedient means" | State AG report for 500+ records |
| **CA SB 446** | AG notification: **15 days** (500+ records) | **30 days** | **Effective 2026.1**. Clarifies previous "most expedient means" to 30 days |
| **New York** | NYDFS notification obligation | **30 days** | **Effective 2024.12**. From 2025.3, "medical information" and "health insurance information" added to PI definition |
| **COPPA** | Promptly notify FTC | Notify parents | Immediate response for children's data |
| **NIS2** | Initial: **24 hours** / Detailed: **72 hours** | Service user notification | Critical infrastructure operators |
| **CIRCIA** | **72 hours** (ransomware payment: 24 hours) | — | Critical infrastructure. **Effective 2026.5** (delayed from original 2025.10) |

*   **Mandate**: When spanning multiple jurisdictions, design IR flow based on the **most stringent deadline**.

### 14.5. GDPR Fine Statistics & Enforcement Trends (2025-2026)
*   **Cumulative Fines**: Total GDPR fines since enforcement reached **€7.1B** (as of early 2026). Over 60% imposed since 2023.
*   **2025 Fine Amount**: Approximately **€1.15B**. Insufficient technical/organizational measures accounted for 29% (40% increase year-over-year).
*   **Breach Report Volume**: 2025 averaged **443 daily** breach reports (22% increase year-over-year).
*   **Major Enforcement Cases**:
    *   TikTok: €530M (EU→China data transfer violation, 2025.5 Ireland DPC)
    *   TikTok: €345M (Child protection violations, Ireland DPC)
    *   Vodafone Germany: €52M (GDPR violations)
*   **Action**: Report fine escalation trends to executive leadership and use as justification basis for compliance investment.

### 14.6. Incident Response Training & Tabletop Exercises

#### 14.6.1. Training Types & Frequency

| Training Type | Description | Frequency | Participants |
|:-------------|:-----------|:----------|:------------|
| **Tabletop Exercise** | Scenario-based discussion. Validate response procedures and decision-making | **Quarterly** | IR Team + Legal + PR + Executive |
| **Functional Exercise** | Partial simulation using actual tools (notification dispatch testing, etc.) | **Semi-annually** | IR Team + IT |
| **Full-Scale Simulation** | Comprehensive drill under near-production conditions | **Annually** | All relevant departments |

#### 14.6.2. Tabletop Exercise Scenario Examples

| Scenario | Assumed Impact | Key Training Areas |
|:--------|:--------------|:------------------|
| **Ransomware Attack**: Customer DB encrypted | 500K PII potential exposure | 72h notification decision, ransom payment deliberation, law enforcement coordination |
| **Vendor-Originated Breach**: Tier 1 vendor's Sub-Processor hacked | Fourth-party data leak | Vendor notification clause activation, responsibility delineation, cascading notifications |
| **Insider Threat**: Employee exfiltrates customer data | Intentional breach | Forensic preservation, disciplinary procedures, authority reporting |
| **Cross-Border Incident**: Affects EU + Japan + US customers | 3-jurisdiction simultaneous response | Shortest deadline (GDPR 72h) based IR flow |

#### 14.6.3. Cross-Border Incident Coordination Checklist
*   [ ] Identify affected jurisdictions (based on data subject locations)
*   [ ] Identify **shortest notification deadline** per jurisdiction (§14.4 reference)
*   [ ] Identify Lead Supervisory Authority
*   [ ] Prepare statutory notification formats per jurisdiction (GDPR: Art.33/34, APPI: PPC format)
*   [ ] Pre-select external law firms (local jurisdictions) and confirm emergency contact arrangements
*   [ ] Prepare multi-language affected party notification templates in advance

#### 14.6.4. IR Runbook Code Template

```typescript
// --- Incident Response Runbook: Notification Deadline Calculator ---
import { differenceInHours, addHours, format } from 'date-fns';

interface JurisdictionDeadline {
  jurisdiction: string;
  regulation: string;
  deadlineHours: number;
  authority: string;
  notificationUrl: string;
}

const NOTIFICATION_DEADLINES: JurisdictionDeadline[] = [
  { jurisdiction: 'EU/EEA', regulation: 'GDPR Art.33', deadlineHours: 72, authority: 'Lead DPA', notificationUrl: '' },
  { jurisdiction: 'Japan', regulation: 'APPI', deadlineHours: 72, authority: 'PPC', notificationUrl: 'https://www.ppc.go.jp/personalinfo/legal/leakAction/' },
  { jurisdiction: 'US-CA', regulation: 'CCPA/SB446', deadlineHours: 720, authority: 'CA AG', notificationUrl: '' },
  { jurisdiction: 'Australia', regulation: 'Privacy Act (NDB)', deadlineHours: 720, authority: 'OAIC', notificationUrl: '' },
  { jurisdiction: 'US-Federal', regulation: 'CIRCIA', deadlineHours: 72, authority: 'CISA', notificationUrl: '' },
];

function calculateDeadlines(discoveryTime: Date) {
  return NOTIFICATION_DEADLINES.map(d => ({
    ...d,
    deadline: addHours(discoveryTime, d.deadlineHours),
    formattedDeadline: format(addHours(discoveryTime, d.deadlineHours), 'yyyy-MM-dd HH:mm (zzz)'),
    remainingHours: d.deadlineHours - differenceInHours(new Date(), discoveryTime),
  })).sort((a, b) => a.deadlineHours - b.deadlineHours);
}
```

*   **Mandate**: Integrate the above deadline calculation logic into IR tools to **automatically compute notification deadlines across all jurisdictions** upon incident discovery, highlighting the jurisdiction with the shortest deadline.
*   **Cross-Reference**: §14.4 (Jurisdiction-Specific Notification Deadlines), `503_incident_response.md` (Incident Runbooks)
*   [ ] Assess cross-border data transfer existence and destination country surveillance law risks
*   [ ] Full IR timeline recording (preserve audit logs as evidence)

*   **Mandate**: After every tabletop exercise, conduct an **After Action Review (AAR)** and incorporate improvements into the IR plan.
*   **Cross-Reference**: `503_incident_response.md` (Crisis Management, BCP)

---

## §15. Platform Safety & Content Moderation

### 15.1. Automated Toxicity Detection
*   **Filter First**: UGC must pass AI auto-moderation before publication.
*   **SLA**: Zero-tolerance framework preventing even momentary display of illegal content.

### 15.2. Copyright Infringement Response (DMCA/Rights)
*   **Takedown Process**: Fact-check copyright infringement reports within **24 hours**. Takedown when infringement is clear.
*   **Counter-Notice**: Provide counter-notice process.

### 15.3. Transparency Reports
*   **Law**: Per DSA compliance, periodically publish statistics on content moderation activities.

---

## §16. Data Governance Organization

### 16.1. Mandatory Roles

| Role | Responsibilities | Establishment Requirement |
|:-----|:----------------|:------------------------|
| **DPO** | Independent oversight of data protection law compliance, DPIA advisory, supervisory authority liaison | Mandatory when GDPR applies |
| **CPO** | Privacy strategy formulation & execution | Recommended based on business scale |
| **Data Steward** | Data quality management, metadata management | Recommended per domain |

### 16.2. ROPA
*   **Mandate**: Maintain GDPR Art.30 compliant Records of Processing Activities.
*   **Record Items**: Processing purpose, data categories, recipients, cross-border transfers, retention periods, security measures.
*   **Update Frequency**: Immediate update when new processing activities are added + **annual** full review.

### 16.3. Data Classification Framework

| Level | Definition | Handling Standards |
|:------|:----------|:-----------------|
| **Restricted** | Highest confidentiality (medical, financial, credentials) | Encryption mandatory, access logs, least privilege |
| **Confidential** | Business confidential (personal data, contracts) | Access restriction, encrypted transfer |
| **Internal** | Internal only | External sharing prohibited |
| **Public** | Public information | No restrictions |

### 16.4. Privacy Engineering Technical Patterns

*   **Data Minimization at Code Level**: Prohibit `SELECT *` and mandate explicit field selection.

```typescript
// ✅ Correct: Select only necessary columns (Data Minimization)
const user = await supabase.from('profiles')
  .select('id, display_name, avatar_url')
  .eq('id', userId);
```

*   **PII Tagging in Schema**:

```sql
COMMENT ON COLUMN profiles.email IS '@pii:email';
COMMENT ON COLUMN profiles.phone IS '@pii:phone';
COMMENT ON COLUMN profiles.full_name IS '@pii:name';
```

*   **Automated PII Redaction in Logs**:

```typescript
function redactPII(data: Record<string, unknown>): Record<string, unknown> {
  const PII_KEYS = ['email', 'phone', 'full_name', 'address', 'ip_address'];
  return Object.fromEntries(
    Object.entries(data).map(([key, value]) =>
      PII_KEYS.includes(key) ? [key, '[REDACTED]'] : [key, value]
    )
  );
}
```

*   **Privacy-Preserving Computation**:

| Technology | Overview | Use Case |
|:-----------|:---------|:---------|
| **Differential Privacy (DP)** | Add statistical noise to prevent individual identification | Analytics dashboards, A/B testing |
| **Federated Learning (FL)** | Distributed learning without moving data | AI training under cross-border constraints |
| **Homomorphic Encryption (HE)** | Compute on encrypted data | Data processing at vendor sites |
| **Secure Multi-Party Computation (MPC)** | Joint computation on private multi-party data | Benchmarks, cross-industry analysis |

### 16.5. Policy-as-Code
*   **Concept**: Define governance policies as machine-executable code and auto-verify in CI/CD.
*   **Applications**:
    *   Auto-detect PII based on schema comments (`@pii:*`)
    *   Block table creation without `retention_days` during migrations
    *   Auto-reconcile RLS policies with ROPA records
    *   Detect pre-consent tracking script loading in E2E tests

#### 16.5.1. CI/CD Privacy Check Pipeline Example

```yaml
# .github/workflows/privacy-checks.yml
name: Privacy Compliance Checks
on: [pull_request]
jobs:
  privacy-audit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: PII Schema Audit
        run: |
          # Detect personal data columns without @pii: tags
          grep -rn 'email\|phone\|full_name\|address\|ip_address' \
            supabase/migrations/ | grep -v '@pii:' && exit 1 || true

      - name: Retention Policy Check
        run: |
          # Block new table CREATEs without retention_days
          grep -l 'CREATE TABLE' supabase/migrations/*.sql | while read f; do
            grep -q 'retention_days' "$f" || \
              { echo "FAIL: $f missing retention_days"; exit 1; }
          done

      - name: Consent-Before-Tracking Test
        run: |
          # Detect pre-consent tracking scripts with Playwright
          npx playwright test tests/privacy/consent-enforcement.spec.ts
```

*   **Mandate**: All checks above must pass before PR merge. Block merge on failure.

#### 16.5.2. Governance Automation Pipeline
*   **Purpose**: Extend Policy-as-Code to fully automate data governance verification.
*   **Implementation Layers**:

| Layer | Automation Target | Tool Examples |
|:------|:-----------------|:-------------|
| **Schema Layer** | PII tag coverage verification, retention period setting enforcement | CI/CD scripts, Open Policy Agent |
| **Access Control Layer** | Automated cross-referencing of RLS policies with ROPA | Custom linters, Supabase CLI |
| **Runtime Layer** | Pre-consent tracking script detection | Playwright E2E tests |
| **Audit Layer** | DSAR response deadline auto-alerts, retention period exceedance detection | Cron jobs, monitoring dashboards |

*   **Mandate**: Incorporate at minimum Schema Layer and Runtime Layer automation into CI/CD. Audit Layer should be deployed based on business scale.

### 16.6. Data Mapping & Data Flow Diagrams
*   **Mandate**: Create and maintain data flow diagrams for all processing activities including:
    *   Data collection points, storage locations, sharing destinations, retention periods, deletion triggers
*   **Update Frequency**: Update on new feature releases + **semi-annual** full inventory.

### 16.7. Data Ethics Framework
*   **Core Principles**: Transparency, fairness, purpose limitation, accountability, human-centricity
*   **Application**: Conduct "Newspaper Test" when designing data use for new features.

---

## §17. Compliance Review & Audit

### 17.1. Periodic Review Standards

| Review Item | Frequency | Owner |
|:-----------|:---------|:------|
| Privacy policy legal alignment | **Annual** | Legal |
| Cookie consent banner functional verification | **Quarterly** | Engineering |
| Data retention compliance status | **Quarterly** | Data Steward |
| Vendor security audit | **Annual** | Security |
| AI use risk assessment | **Quarterly** | AI Governance Committee |
| Regulatory change impact assessment | **Quarterly** | Legal |
| Anti-social forces re-screening | **Annual** | Legal |
| ROPA full review | **Annual** | DPO/CPO |
| ESG reporting data verification | **Annual** | Sustainability Lead |
| **Transparency obligations (Art.12-14) compliance** | **Annual (2026 priority)** | DPO/Legal |
| EU Data Act IoT data access compliance | **Semi-annually** | Engineering |

#### 17.1.1. EDPB 2026 Coordinated Enforcement Theme: Transparency Obligations
*   **Background**: EDPB designated **transparency obligations (GDPR Art.12-14)** as the 2026 coordinated enforcement priority theme. National DPAs will investigate and enforce using unified standards.
*   **Art.12**: Conciseness, transparency, intelligibility, and easy accessibility of information provision
*   **Art.13**: Information provision obligation for direct collection (processing purposes, legal basis, retention periods, data subject rights, etc.)
*   **Art.14**: Information provision obligation for indirect collection (data sources, categories)
*   **Action (Immediate)**:
    *   Conduct a **comprehensive audit** verifying privacy policies satisfy all Art.12-14 requirements
    *   Cross-reference **data mapping (§16.6)** for each data processing activity to verify "when, where, and how" information is provided
    *   Verify effectiveness of layered privacy notices (§5.3 Layered Notice)
*   **Cross-Reference**: §5.3 (Layered Notice), §16.2 (ROPA), §16.6 (Data Mapping)

### 17.2. Compliance Checklist
*   [ ] All data processing has GDPR Art.6 lawful basis
*   [ ] Privacy policy reflects latest regulations
*   [ ] Cookie consent banner operating correctly
*   [ ] Data exceeding retention periods auto-deleted
*   [ ] Cross-border transfers have adequate lawful mechanisms
*   [ ] AI-generated content properly labeled
*   [ ] No dark pattern UI elements present
*   [ ] Children's data protection standards met
*   [ ] Vendor DPAs current
*   [ ] Incident response procedures current and tested
*   [ ] Synthetic data use compliant with governance policies
*   [ ] ADMT regulation response plans formulated

### 17.5. Privacy Governance KPI Dashboard

| KPI | Measurement Target | Goal | Frequency |
|:----|:-------------------|:-----|:----------|
| **PIA Completion Rate** | PIA completion rate for new projects | **100%** | Quarterly |
| **DSAR On-Time Response Rate** | DSARs completed within statutory deadline | **≥99%** | Monthly |
| **Consent Opt-In Rate** | Opt-in rate on cookie consent banners | Benchmark comparison | Monthly |
| **Incident Mean Response Time** | Time from detection to initial response | **<1 hour** | Per incident |
| **Privacy Training Completion Rate** | Completion rate across all employees | **≥​95%** | Annually |
| **Vendor DPA Coverage** | Percentage of vendors with signed DPAs | **100%** | Quarterly |
| **Data Retention Compliance Rate** | Remaining rate of expired data | **0%** | Quarterly |
| **Audit Finding Remediation Rate** | Completion rate of audit findings remediation | **≥90% (within 90 days)** | Post-audit |
| **AI Risk Assessment Coverage** | Risk assessment completion rate for AI systems | **100%** | Quarterly |
| **Legal Basis Documentation Rate** | Rate of ROPA-registered processing with documented legal basis | **100%** | Annually |

#### 17.5.1. Board Reporting Checklist
*   [ ] KPI dashboard summary (trends, risks, improvements)
*   [ ] Regulatory landscape changes and business impact summary
*   [ ] Major incidents and near-miss reports
*   [ ] Compliance investment ROI (Cisco study: 96% of organizations recognize positive ROI)
*   [ ] Next quarter priorities and budget requests
*   **Mandate**: DPO/CPO must report privacy program status to the board or executive committee **quarterly**.

### 17.3. Audit Trail
*   **Mandate**: Document all compliance review results and retain for a **minimum of 3 years**.
*   **Action**: When significant non-compliance is found, formulate and execute remediation plan within **30 days**.

---

## §18. Law Enforcement Data Requests

### 18.1. Core Principles
*   All government/law enforcement data requests validated by legal for legal validity before response.
*   Unless prohibited by law, notify affected users before data disclosure.
*   Disclose only the minimum data necessary for the request.
*   **CLOUD Act**: US-based service providers may be required to disclose data stored overseas.

### 18.2. Request Classification & Response

| Request Type | Disclosure Scope | Legal Review | User Notification |
|:------------|:----------------|:------------|:-----------------|
| **Voluntary Request** | Voluntary. Refusal permitted | Recommended | Permitted |
| **Subpoena** | Non-content data only | Mandatory | Permitted |
| **Search Warrant** | Including content | Mandatory | Typically prohibited |
| **NSL** | Restricted | Mandatory | Prohibited |
| **Emergency Disclosure** | Life-threatening situations only | Post-hoc review | Post-hoc notification |

### 18.3. Transparency Report
*   Publish annual **transparency report** on government data requests when business reaches a certain scale.

### 18.4. Whistleblower Protection
*   **Law**: EU Whistleblower Directive mandates internal reporting channels for organizations with 50+ employees.
*   **Implementation Requirements**: Anonymous reporting channel, receipt confirmation within **7 days**, feedback within **3 months**, protection from retaliation.
*   **AI Act Linkage**: From August 2026, EU AI Act violation reports also covered by whistleblower protections.

---

## §19. Legal Hold & eDiscovery

### 19.1. Legal Hold
*   **Law**: When litigation is reasonably anticipated, obligation to preserve relevant data arises. **Immediately suspend** auto-deletion policies (§12).
*   **Flow**:
    1.  Legal determines need for legal hold
    2.  Issue hold notices to relevant Custodians
    3.  Suspend auto-deletion jobs for affected data
    4.  Track Custodian acknowledgments with automated reminders
    5.  Upon hold release, issue formal release notice + resume normal retention policies
*   **Anti-Pattern**: Verbal communication of hold notices. Issue in writing and preserve acknowledgment records.

### 19.2. eDiscovery Readiness
*   **Information Governance**: Maintain data location maps (§16.6) during normal operations to enable rapid identification when eDiscovery requests arise.
*   **Capabilities**:
    *   Establish ESI collection and preservation procedures
    *   Data confidentiality classification and privileged data filtering
    *   AI-assisted review and relevance determination for large datasets
    *   PII masking and redaction procedures
    *   Documentation of all processes (ensuring defensibility)

### 19.3. AI in eDiscovery and AI-Generated Evidence Preservation

> [!IMPORTANT]
> As of 2025, **79%** of law firms utilize AI in eDiscovery (up from 19% in 2023). AI-generated content preservation is an emerging legal challenge.

*   **AI-Assisted Review (TAR/CAL)**:
    *   Recommend adopting Technology Assisted Review (TAR) or Continuous Active Learning (CAL)
    *   Automate relevance determination and privilege filtering for large ESI volumes
    *   Document AI model training data and accuracy metrics (precision/recall) to ensure **defensibility**
*   **AI-Generated Content Preservation**:
    *   Documents, emails, and code generated by AI are **discoverable eDiscovery targets**
    *   Incorporate AI chat logs, prompt history, and generated output preservation obligations into legal hold policies
    *   Manage evidence spoliation risks from **Shadow AI** (unauthorized AI tool usage)
*   **Action**: Explicitly include AI-generated content preservation scope in eDiscovery response plans. Define AI chat log retention periods based on §12.
*   **Cross-Reference**: §12 (Data Lifecycle), `400_ai_engineering.md` (AI Tool Log Management)

---

## §20. Synthetic Data Governance

### 20.1. Definition & Legal Status
*   **Synthetic Data**: Artificially generated data that replicates statistical properties of real data without directly referencing individuals.
*   **Legal Caveat**: Even synthetic data may be treated as personal data if re-identification is possible when combined with source data (EDPB position). "Synthetic data is exempt from GDPR" is **wrong**.

### 20.2. Governance Framework

| Element | Requirement |
|:--------|:-----------|
| **Purpose Documentation** | Clearly define and record intended use cases before generation |
| **Bias Management** | Document efforts to balance demographic representativeness. Verify synthetic data does not amplify source data bias |
| **Quality Verification** | Train-Synthetic-Test-Real (TSTR) validation: test models trained on synthetic data against a small real data sample |
| **Metadata Management** | Tag synthetic data with metadata recording generation method, original purpose, and known limitations |
| **Auditability** | Guarantee full reproducibility of the generation process. Record generation parameters and seed values |
| **Access Control** | Apply access controls corresponding to the source real data's classification level, even for synthetic data |

### 20.3. Usage Restrictions
*   **Prohibited**: Submitting synthetic data as a "substitute for real data" to regulatory authorities is prohibited.
*   **Permitted Uses**: AI/ML model training, test environment data, cross-border scenarios with data access restrictions.
*   **Cross-Reference**: `400_ai_engineering.md` (RAG & training data), `700_qa_testing.md` (test data)

---

## §21. Data Clean Room Regulation

### 21.1. Definition & Legal Status
*   **Data Clean Room**: An **isolated analytics environment** where multiple parties can securely combine and analyze data without row-level data exposure to external parties.
*   **FTC Warning**: Data Clean Rooms do not automatically prevent impermissible data disclosure or use. They must not be used as a means to circumvent legal obligations (FTC 2024 guidance).

### 21.2. Operational Requirements

| Requirement | Content |
|:-----------|:--------|
| **Data Minimization** | Only inject minimum necessary data for the analytical purpose into the Clean Room |
| **Anonymization Threshold** | Output limited to aggregate data meeting predefined thresholds (e.g., k≥50). Row-level data leakage prohibited |
| **Differential Privacy** | Apply noise injection to output to mathematically limit individual identifiability |
| **Contractual Constraints** | Execute DCR agreements specifying data use purpose, scope, and duration among participants |
| **Third-Party Audit** | Annual third-party audit verifying Clean Room operations comply with privacy regulations |
| **Log Retention** | Maintain complete audit logs of all queries and outputs |

### 21.3. Use Cases
*   Advertising effectiveness measurement (post-cookie solution as cookie alternative)
*   Cross-industry benchmark analysis
*   Privacy-compliant data collaboration with vendors

---

## §22. Neural Data & Emerging Biometrics

### 22.1. Definition & Legal Risk
*   **Neural Data**: Information derived directly from the brain and nervous system. Contains extremely sensitive insights about mental states, emotions, and intentions.
*   **Risk**: Irreversible once compromised (equivalent to biometric data), vulnerable to misuse for mental privacy invasion, discrimination, or manipulation.

### 22.2. Regulatory Map

| Jurisdiction | Regulation | Effective | Requirements |
|:------------|:----------|:----------|:------------|
| **California** | SB 1223 (CCPA amendment) | 2025.1 | Classifies neural data as sensitive PI. Grants access, deletion, sharing restriction rights |
| **Colorado / Montana** | Neural Data Protection Laws | 2025 | Explicit consent for collection, separate consent for third-party disclosure, deletion rights |
| **Connecticut** | Privacy Law Amendment | 2026.7 | Adds neural data to sensitive data categories |
| **EU** | GDPR Art.9 | Active | Classifies neural data as special category information |
| **Chile** | Constitutional Amendment | 2021 | World's first constitutional "Neurorights" protection |

### 22.3. Implementation Requirements
*   Obtain **explicit written consent** for neural data processing (electronic signature acceptable)
*   Neural data **commercial use prohibited in principle**. Exceptions only for medical/healthcare purposes
*   **AES-256+** encryption for storage, **separate storage** from other personal data
*   **DPIA mandatory**: Conduct DPIA (§6.2.2) before neural data processing
*   Obtain **separate explicit consent** for neural data third-party provision
*   **Retention Period**: Delete within **1 year** of purpose completion

---

## §23. ESG & Sustainability Reporting

### 23.1. CSRD (Corporate Sustainability Reporting Directive)
*   **Law**: EU CSRD phases in expanding scope:
    *   **2025** (FY2024 reporting): Former NFRD-subject companies
    *   **2026** (FY2025 reporting): Large EU companies (employees >250 or revenue >€50M or assets >€25M, meeting 2 of 3)
    *   **2027** (FY2026 reporting): Listed SMEs (opt-out deferral available)
    *   **2029** (FY2028 reporting): Non-EU companies with EU revenue >€150M
*   **Omnibus Simplification (2026.2)**: Proposes threshold increase, timeline extension, and 70%+ data point reduction. Comply with current rules until enacted.

### 23.2. Digital Product Passport (DPP)
*   **Law**: Digital lifecycle record of product information under EU ESPR (Ecodesign for Sustainable Products Regulation).
*   **Enforcement Timeline**: Batteries (2026.7), Iron & Steel (2027), Textiles/Aluminum (2028).
*   **Engineering Impact**: Services handling DPP-compliant products must consider DPP data retrieval, display, and API access capabilities at design time.

### 23.3. Impact on Digital Services
*   **Data Center Environmental Reporting**: Large digital services may face energy efficiency and carbon emission disclosure requirements.
*   **Greenwashing Prohibition**: False or misleading environmental claims carry legal risk. Applies to AI-generated environmental claims as well.
*   **Cross-Reference**: `101_revenue_monetization.md` (FinOps)

---

## §24. Antitrust & Platform Regulation

### 24.1. EU DMA (Digital Markets Act)
*   **Law**: Prohibits the following for Gatekeepers (Alphabet, Amazon, Apple, ByteDance, Meta, Microsoft):
    *   **Self-Preferencing**: Favoring own services in search results or rankings
    *   **Cross-Platform Data Combination**: Combining data across platforms without explicit user consent
    *   **Sideloading Restrictions**: Unduly restricting app installation from sources other than app stores
*   **Penalties**: **10%** of global revenue (20% for repeat violations).

### 24.2. Algorithmic Collusion Regulation
*   **Risk**: Pricing AI or similar algorithms may inadvertently produce collusive outcomes, constituting antitrust violations.
*   **Case**: US DOJ settlement with RealPage (2025.11) — algorithm-based information sharing inhibited competition in concentrated markets.
*   **Countermeasure**: When using AI for pricing or market analysis, guarantee designs that prevent direct sharing with competitor data.

### 24.3. Engineering Impact
*   When providing apps/services on platforms, ensure architectural flexibility to accommodate specification changes from gatekeepers' DMA compliance.
*   **Cross-Reference**: `301_api_integration.md` (API Gateways), `103_appstore_compliance.md` (Store Guidelines)

---

## §25. AI Management System Standards (ISO 42001 / NIST AI RMF)

### 25.1. ISO/IEC 42001 (AI Management System)
*   **Overview**: Published December 2023. Management system standard for responsible AI development, deployment, and operation.
*   **Key Requirements**:
    *   Establish AI risk management processes
    *   Conduct AI system impact assessments
    *   Lifecycle management
    *   Third-party supplier oversight
    *   Continuous improvement processes
*   **Application**: Referenced in EU AI Act regulatory guidance. Certification is effective proof of compliance.

### 25.2. NIST AI RMF (AI Risk Management Framework)
*   **Overview**: Published January 2023. Voluntary guidelines for improving AI trustworthiness.
*   **4 Core Functions**:

| Function | Purpose |
|:---------|:--------|
| **Govern** | Build AI risk management governance |
| **Map** | Identify AI system risks in context |
| **Measure** | Analyze and evaluate identified risks |
| **Manage** | Implement and monitor risk mitigation measures |

*   **GenAI Profile**: NIST-published generative AI-specific risk management profile (July 2024). Focuses on hallucination, data privacy, and IP risks.
*   **Cross-Reference**: `400_ai_engineering.md` (AI Implementation), §11 (AI Regulation)

### 25.3. Integrated Approach
*   Recommended **integrated approach**: Use ISO 42001 framework for EU AI Act compliance, supplemented with NIST AI RMF practical guidance.
*   **Mandate**: When deploying high-risk AI systems, create and maintain risk management documentation based on ISO 42001 or NIST AI RMF.

---

## §26. Digital Sovereignty & Technological Independence

### 26.1. Concept
*   **Digital Sovereignty**: The ability of nations, organizations, and individuals to control their data, technology, and digital infrastructure independently from external entities.
*   **Two Dimensions**: Data residency (physical storage location) + Legal jurisdiction (legal control over data).

### 26.2. EU Initiatives
*   **EuroStack / SECA**: European-led digital supply chain. Investment in sovereign cloud, AI, quantum computing, and cybersecurity.
*   **DMA/DSA/AI Act**: Regulatory framework for the digital economy and emerging technologies.

### 26.3. Engineering Impact
*   **Cloud Strategy**: Services targeting EU users should prioritize EU cloud regions. Consider Sovereign Cloud usage.
*   **OSS Priority**: Recommend open-source software adoption from a digital sovereignty perspective. Ensures transparency and technological independence.
*   **Vendor Lock-In Avoidance**: Avoid excessive dependence on non-EU-based cloud providers. Consider multi-cloud portability at design stage.
*   **Cross-Reference**: `361_aws_cloud.md` (Cloud Architecture), §3.4.1 (Data Localization)

---

## §27. Health Data Protection

### 27.1. HIPAA Amendment (Expected 2026 Effective)
*   **Law**: Major HIPAA Security Rule amendment proposed (2025.1 proposal, expected effective 2026 H2). Most comprehensive overhaul in decades.
*   **Key Changes**:
    *   Elimination of "required" vs "addressable" distinction — nearly all security measures become **mandatory**
    *   **MFA (multi-factor authentication) mandatory** for ePHI access
    *   **Encryption obligation** expanded to all ePHI
    *   **Annual compliance audits**, semi-annual vulnerability scans, annual penetration testing
    *   Most provisions require compliance within **180 days** of effective date
*   **Cross-Reference**: `600_security_privacy.md` (Authentication & Encryption)

### 27.2. Non-HIPAA Health Data Protection
*   **Background**: Health data collected by smartwatches, health apps, etc. is largely outside HIPAA scope.
*   **Health Information Privacy Reform Act**: Bill extending HIPAA-like protections to consumer health tech (introduced Senate November 2025).
*   **Washington MHMDA**: Mandates consent for collection/sharing and deletion rights for consumer health data.

### 27.3. Engineering Response
*   Services processing health data must incorporate **highest-level data protection** in design, regardless of HIPAA applicability
*   Classify health data in DB with `@pii:health` tags and apply §16.4 Privacy Engineering patterns
*   **Cross-Reference**: §16.4 (Privacy Engineering)

---

## §28. Reproductive Health Data Protection

### 28.1. Legal Background
*   **Post-Dobbs Impact**: HIPAA Reproductive Health Care Privacy Rule (expanding HIPAA protections to reproductive health data) was **nationwide vacated** by Texas federal judge in June 2025.
*   **State-Level Protection**: Some states (California, Virginia, etc.) have enacted independent reproductive health data protections. With no federal protection, response is **state-law-based**.

### 28.2. Engineering Requirements
*   Classify data related to reproductive health (including location data, search history) as **sensitive data**
*   Strictly apply §18 procedures for law enforcement requests
*   Minimize location data retention periods, adopting designs that make reproductive facility visit inference difficult
*   **Anti-Pattern**: Retaining location data indefinitely, leaving reproductive health information inferable upon law enforcement requests

---

## §29. Employee Data Protection & Workplace Monitoring

### 29.1. Legal Framework

| Jurisdiction | Regulation | Requirements |
|:------------|:----------|:------------|
| **US (Federal)** | ECPA | Permits monitoring for legitimate business purposes. Notice recommended |
| **California** | CCPA/CPRA | Obligation to disclose data collection practices to employees. Access, deletion, correction rights |
| **EU** | GDPR + AI Act | Strict legitimate interest assessment. AI monitoring tools classified as high-risk (2026.8 effective) |
| **N/A** | NLRB Case Law | Scrutinizes overly invasive electronic monitoring and algorithm-based management |

### 29.2. Legal Risks of AI-Assisted Monitoring Tools
*   **EU AI Act**: AI systems in employment/workforce management classified as **high-risk** (2026.8 effective). Conformity assessment, technical documentation, and human oversight mandatory.
*   **Emotion Recognition AI in Workplace**: **Prohibited** under EU AI Act (2025.2 already effective).
*   **Algorithm-Based HR Evaluation**: When using AI for employee promotion, termination decisions, §3.7 automated decision-making regulations apply.

### 29.3. Implementation Requirements
*   When conducting employee monitoring, provide **written privacy notice**
*   Limit data collection scope to **minimum necessary for business purposes**
*   For remote work screen monitoring/keystroke logging, document **purpose legitimacy**
*   Restrict monitoring data access to **HR and Security departments**, maintain access logs

---

## §30. Sector-Specific Data Protection

### 30.1. Financial Data

| Regulation | Applicability | Key Requirements |
|:-----------|:-------------|:----------------|
| **GLBA** | US Financial Institutions | Privacy notice obligation, information sharing opt-out, data security |
| **FCRA** | Credit Information | Consumer credit report accuracy, dispute rights, purpose limitations |
| **PCI DSS v4.0** | Card Payments | Cardholder data protection (2025.3 full enforcement) |

### 30.2. Education Data
*   **FERPA**: Protection of student education records. Parent/adult student access and consent rights.
*   **Engineering Impact**: Education-related services must implement opt-out functionality for third-party disclosure of student data.

### 30.3. Communications Data
*   **TCPA**: Consent obligation for telemarketing and automated communications. Violations carry **$500-$1,500/call** damages.
*   **TCPA AI Impact**: AI-generated voice calls/texts require TCPA-compliant prior consent. FCC classifies AI-generated voice as "artificial voice" (2024).

### 30.4. FTC Section 5
*   **Enhanced Enforcement**: FTC increasing enforcement against unfair/deceptive data practices. Active crackdown on "AI Washing" (exaggerated AI capability claims).
*   **Cross-Reference**: §8 (Dark Pattern Prohibition)

### 30.5. Defense Industry (CMMC)
*   **Law**: Cybersecurity Maturity Model Certification (CMMC) is a cybersecurity certification requirement for US Department of Defense (DoD) contractors. **Final rule effective October 2025**.
*   **3-Tier Structure**:

| Level | Target | Requirements |
|:------|:-------|:-------------|
| **Level 1** | FCI (Federal Contract Information) handling | Self-assessment, basic cyber hygiene (17 practices) |
| **Level 2** | CUI (Controlled Unclassified Information) handling | NIST SP 800-171r2 (110 controls), third-party certification |
| **Level 3** | High-priority CUI handling | NIST SP 800-172 (additional requirements), government-led assessment |

*   **Engineering Impact**: Services with US government agency customers or participants in defense supply chains must implement security measures aligned with the appropriate CMMC level.
*   **Cross-Reference**: `600_security_privacy.md` (Security Implementation)

---

## §31. Global AI Regulation Map

### 31.1. Major AI Regulation Overview

| Jurisdiction | Legislation | Effective | Approach | Key Requirements |
|:------------|:-----------|:----------|:---------|:----------------|
| **EU** | AI Act | Phased (2025.2-2027.8) | Risk-based | Risk classification, conformity assessment, GPAI obligations |
| **Colorado** | AI Act (CAIA) | 2026.6 | High-risk AI only | Impact assessment, risk management, consumer disclosure |
| **California** | CAITA (SB 942) | 2026.8 | Transparency-focused | AI-generated content watermarking & labeling |
| **California** | SB 53 | 2026.1 | Frontier models | Revenue >$500M developers must publish risk management framework |
| **Texas** | RAIGA | 2026 | High-impact AI | Documentation, transparency, red-teaming |
| **China** | GenAI Measures / Deep Synthesis | 2023 | Comprehensive | Content labeling, training data management, algorithm registration |
| **South Korea** | AI Basic Act | 2026 | Risk-based | High-impact AI regulation, AI ethics guidelines |
| **Brazil** | AI Bill | Under review | Risk-based | Risk classification similar to EU model |
| **New York** | AI Transparency Law | Mid-2026 | Transparency-focused | Mandatory conspicuous disclosure when ads contain "synthetic performers" |

### 31.2. Trend Monitoring
*   **Mandate**: Review AI regulation amendment trends **quarterly**.
*   **Cross-Reference**: §11 (EU AI Act Details), §25 (ISO 42001/NIST AI RMF)

---

## §32. Data Broker Regulation

### 32.1. Definition
*   **Data Broker**: Entity that collects, sells, or licenses personal information of consumers with whom it has no direct relationship.

### 32.2. Regulatory Map

| Jurisdiction | Regulation | Requirements |
|:------------|:----------|:------------|
| **California** | Delete Act / DROP | Data broker registration obligation. Bulk deletion request processing obligation via DROP (2026.8) |
| **Vermont** | Data Broker Act | Annual registration obligation, security standard compliance |
| **Texas** | Data Broker Law | Registration obligation, consumer opt-out rights |
| **Oregon** | Data Broker Registration | Annual registration, privacy policy disclosure |

### 32.3. Engineering Impact
*   Conduct legal evaluation of whether own service qualifies as a "data broker"
*   If applicable, implement bulk deletion API and consumer opt-out mechanisms
*   **Anti-Pattern**: Third-party data purchases/usage inadvertently falling under data broker regulations

---

## §33. Government Surveillance & National Security

### 33.1. FISA Section 702
*   **Law**: Authorizes warrantless surveillance of non-US persons abroad. Set to **expire April 2026** (reauthorization under review).
*   **Risk**: "Incidental" collection of US persons' communications. Impact on EU-US Data Privacy Framework.
*   **Engineering Impact**: Under Schrems II, EU→US data transfers require TIA (§3.4) evaluating US surveillance laws.

### 33.2. Schrems II Impact & Cross-Border Transfers
*   **Mandate**: For EU→US data transfers, continuously monitor FISA 702 developments even when relying on EU-US Data Privacy Framework.
*   **Supplementary Measures**: Document technical supplementary measures in TIA: encryption (at rest & in transit), pseudonymization, split processing.
*   **Cross-Reference**: §3.4 (Cross-Border Transfer Framework)

### 33.3. Technical Countermeasures Against Government Data Access
*   **End-to-End Encryption**: Where possible, implement E2E encryption with designs where service providers cannot access data themselves
*   **Data Minimization**: Minimize retained data volume to limit government access request scope
*   **Transparency Reports**: Include government surveillance request statistics in §18.3 reports

### 33.4. FTC Foreign Adversary Data Act (Protecting Americans’ Data From Foreign Adversaries Act)
*   **Law**: Enacted 2024. **Prohibits** data brokers from sharing sensitive personal data of US individuals (location, health, financial, biometric data, etc.) with **foreign adversary countries** (China, Russia, Iran, North Korea, etc.) or entities controlled by them.
*   **FTC Enforcement**: FTC holds enforcement authority.
*   **Action**: As part of vendor screening, verify that data sharing recipients are not under the control of foreign adversary countries.
*   **Cross-Reference**: §32 (Data Broker Regulation)

### 33.5. DOJ Bulk Data Rule (Effective 2025.4)
*   **Law**: New regulatory framework for how US persons engage in certain transactions with foreign and covered persons that process bulk personal data or government-related data.
*   **Effective**: April 2025 (additional requirements effective October 2025).
*   **Action**: Conduct screening of covered transactions. Verify whether data processing outsourcing to foreign vendors constitutes bulk personal data transactions.

---

## §34. EU Data Act

### 34.1. Overview & Enforcement Timeline
*   **Law**: EU Data Act (Regulation (EU) 2023/2854) establishes new rules governing access, sharing, and use of data generated by connected devices.
*   **Entry into Force**: January 11, 2024.
*   **Phased Enforcement**:

| Phase | Effective Date | Content |
|:------|:-------------|:--------|
| **Phase 1** | **2025.9.12** | User data access & sharing rights, unfair contract terms regulation, data sharing obligations |
| **Phase 2** | **2026.9.12** | **Access-by-Design** for new products (design-stage access obligations), enhanced interoperability requirements |
| **Phase 3** | **2027.1** | **Switching fee & data egress fee abolition** for cloud services |
| **Phase 4** | **2027.9.12** | Full implementation of data portability standards |

*   **Scope**: Connected product manufacturers, related service providers, cloud operators. **Non-EU companies** offering services to EU customers are also covered.

### 34.2. Connected Device Data Access Rights
*   **User Access Rights**: Users (both businesses and consumers) have the right to access data generated by their connected devices.
*   **Covered Data**: All data generated during device use (including personal and non-personal data). Encompasses raw data output, pre-processed information, and metadata.
*   **Third-Party Sharing**: Users have the right to share their data with user-designated third parties.
*   **Connected Product Definition**: Physical items that collect or generate data and can communicate it (smart home products, connected cars, industrial equipment, medical devices, etc.).
*   **Data Format**: Data must be provided in a structured, commonly used, machine-readable format. Where technically feasible, provide **continuously and in real-time**.
*   **Free of Charge**: Data provision to users must be **free of charge**.

### 34.3. Access-by-Design Requirements (From 2026.9.12)
*   **Design-Stage Obligation**: New connected products and related services placed on the EU market from 2026.9.12 must incorporate **data accessibility from the design stage**.
*   **Implementation Requirements**:
    *   Design interfaces enabling users to easily, securely, and freely obtain data
    *   Standard implementation of data access APIs
    *   Specify data types, volume, format, and access methods in product documentation
*   **Anti-Pattern**: "We can add APIs later" is unacceptable. Design-stage incorporation is mandatory.

### 34.4. Cloud Service Portability
*   **Switching Obligation**: Cloud service providers must facilitate switching between cloud services.
*   **Barrier Removal**: Remove contractual and technical barriers to data migration and ensure interoperability.
*   **Fee Abolition**: From **January 2027**, switching fees and data egress fees are **abolished**.
*   **Cross-Reference**: `361_aws_cloud.md` (Cloud Architecture)

### 34.5. Engineering Impact
*   **IoT Services**: Services handling connected devices must incorporate data access APIs and data export functionality at **design stage**.
*   **Data Formats**: Consider data provision format standardization (machine-readable formats like JSON/CSV) at design time.
*   **GDPR Delineation**: Data Act is **fully GDPR-compliant**. GDPR takes precedence when personal data is involved. Separate management of personal and non-personal data is required.
*   **Trade Secret Protection**: Unjustifiably refusing data access on trade secret grounds is prohibited. However, data disclosure can be exceptionally restricted when clear and serious economic harm is demonstrated.
*   **Pre-Contractual Disclosure**: Data holders must **pre-disclose** data types, volume, format, access methods, and manufacturer/third-party access to users.

### 34.6. Contractual Protections
*   **Unfair Terms Regulation**: Regulates unfair terms in data sharing contracts (particularly SME protection).
*   **Take-it-or-leave-it Prohibition**: "Accept or reject" clauses imposing excessive burdens on users are prohibited.
*   **Model Contractual Terms (MCT)**: European Commission developing model contractual terms for data access and use (September 2025). Includes terms on reasonable compensation and trade secret protection.
*   **Cross-Reference**: §13 (Vendor Data Governance / DPA)

---

## §35. AI Companion & Frontier Model Safety Regulation

### 35.1. California SB 53 (Frontier Model Safety Obligations)
*   **Law**: Effective January 2026. Mandates **risk management framework** publication for frontier AI model developers with revenue exceeding $500M.
*   **Key Requirements**:
    *   Develop and publish risk management framework
    *   Document safety testing results
    *   Implement significant risk mitigation measures
*   **Scope**: Limited to frontier model developers. Users/deployers are not directly covered.

### 35.2. AI Companion Chatbot Safety Regulation
*   **Law**: California law (effective January 2026). Introduces safety standards for AI companion chatbots.
*   **Background**: Concerns about emotional dependency on AI companions and mental health impacts (particularly on minors) led to legislation.
*   **Requirements**:
    *   **Explicit disclosure** that the entity is an AI companion
    *   **Additional protection measures** for minors (usage time limits, prohibition of emotional manipulation, etc.)
    *   **Emergency resource referral** functionality for conversations about self-harm or suicide
    *   Protection of AI companion interaction data

### 35.3. AI-Generated Content Labeling Code of Practice (EU Art.50)
*   **Law**: Transparency obligations under EU AI Act Art.50. Mandates labeling AI system interactions and AI-generated content (including deepfakes).
*   **Code of Practice 2nd Draft (2026.3)**: Voluntary code of practice for marking and labeling AI-generated content.
*   **Key Requirements**:
    *   **AI interaction notification** obligation when interacting with chatbots (2026.8 effective)
    *   **Clear labeling** obligation for deepfakes and AI-generated text (public information purposes)
    *   **EU common icon standard**: Recommends use of standardized EU icon indicating AI-generated content
    *   Encourages adoption of open technical standards
*   **Engineering Implementation**:
    *   Tag AI-generated content with `ai_generated: true` flag and metadata (generation model, generation timestamp)
    *   Place **visual indicators** in user interfaces indicating AI-generated content
    *   Prepare for EU common icon standard adoption once finalized

### 35.4. Engineering Requirements
*   **Cross-Reference**: §11 (AI Regulation), §31 (Global AI Regulation Map), §25 (ISO 42001 / NIST AI RMF)
*   **Mandate**: When providing AI features to users, review compliance with above regulations in AI Governance Committee (§11.9) **quarterly**.

---

## §36. Privacy by Design Implementation Framework

### 36.1. GDPR Art.25 Seven Principles Implementation Mapping

| # | PbD Principle | Implementation Pattern | Verification Method |
|:--|:-------------|:----------------------|:-------------------|
| **1** | **Proactive** | Conduct threat modeling (STRIDE/LINDDUN) during design phase | Verify DPIA record existence |
| **2** | **Default Setting** | Minimal data collection by default. `SELECT *` prohibited, cookie consent OFF by default | CI/CD SELECT * detection, consent banner E2E tests |
| **3** | **Embedded into Design** | Integrate PII-tagged schemas (§16.4), RLS policies, encryption into architecture | Schema audits, RLS verification scripts |
| **4** | **Full Functionality** | Design for privacy AND UX coexistence, not trade-offs | Parallel usability testing and privacy review |
| **5** | **End-to-End Lifecycle** | Automatic retention period enforcement (§12), physical deletion on account cancellation | Retention job verification, cancellation flow E2E tests |
| **6** | **Visibility/Transparency** | Layered notices (§5.3), DSAR API (§3.6.1) | Privacy policy audits, DSAR response time KPIs |
| **7** | **User-Centric** | Granular consent management (§4), privacy dashboard | Consent management UI accessibility testing |

### 36.2. PbD Assessment Checklist

> Verify the following before releasing new features/services.

*   [ ] **Data Minimization**: Is collected data the minimum necessary for the stated purpose?
*   [ ] **Purpose Limitation**: Are data usage purposes clearly defined and documented?
*   [ ] **Default Settings**: Are privacy settings in the most protective state by default?
*   [ ] **Legal Basis**: Is the appropriate legal basis (consent, contractual necessity, legitimate interest, etc.) identified?
*   [ ] **Access Control**: Is minimum-privilege access implemented via RLS/RBAC?
*   [ ] **Encryption**: Is encryption implemented for data at rest and in transit?
*   [ ] **Retention Period**: Are data retention periods defined with automatic deletion implemented?
*   [ ] **PII Tagging**: Are PII columns tagged with `@pii:*` tags?
*   [ ] **DPIA**: Has a DPIA (§6.2.2) been conducted for high-risk processing?
*   [ ] **PII Log Redaction**: Are logs free of unnecessary PII (§16.4)?
*   [ ] **Third-Party Data Sharing**: Is a DPA (§13) executed for data sharing with third parties?

*   **Mandate**: **Block** new feature releases until all checklist items pass.

### 36.3. Privacy Review Gates by Design Phase

| Phase | Review Scope | Owner | Output |
|:------|:-----------|:------|:-------|
| **Requirements** | Data collection purpose and legal basis identification | PM + Legal | Privacy requirements document |
| **Design** | Schema PII tagging, RLS policy design, consent flow design | Engineer + DPO | Design review record |
| **Implementation** | Code-level privacy pattern application (Data Minimization, etc.) | Engineer (peer review) | PR review record |
| **Testing** | PbD checklist verification, E2E privacy tests | QA + Security | Test results report |
| **Release** | Final PIA/DPIA approval | DPO/CPO | Release approval document |

### 36.4. PET (Privacy Enhancing Technologies) Selection Guide

| Technology | Use Case | Privacy Guarantee | Performance Impact |
|:-----------|:---------|:-----------------|:------------------|
| **Differential Privacy** | Analytics, reporting | Mathematical privacy guarantee (ε-DP) | Low to Medium |
| **k-Anonymization** | Data publishing, sharing | Grouping into k+ individuals | Low |
| **Federated Learning** | AI training under cross-border data constraints | Data doesn't move | High (communication cost) |
| **Homomorphic Encryption** | Data processing at vendor sites | Computation on encrypted data | Very High |
| **Synthetic Data** | Test/development environments | Non-linkability to source data | Low (generation time only) |
| **Tokenization** | Payment/authentication data | Protection via irreversible tokens | Low |

*   **Selection Criteria**: Select PETs based on data sensitivity, processing purpose, performance requirements, and regulatory requirements. Recommend **defense-in-depth** combining multiple PETs.
*   **Cross-Reference**: §16.4 (Privacy-Preserving Computation), §20 (Synthetic Data Governance)

---

## §37. Data Governance Maturity Model

### 37.1. Five-Stage Maturity Model

| Stage | Level Name | Characteristics | Representative State |
|:------|:----------|:---------------|:--------------------|
| **Level 1** | **Ad-Hoc** | Governance undefined. Depends on individual discretion | PII location unknown, retention periods not set, DSAR handled manually |
| **Level 2** | **Managed** | Basic policies exist but lack consistency | Privacy policy exists but irregularly updated, DPAs only partially executed |
| **Level 3** | **Defined** | Cross-organizational framework established | ROPA operational, DPIA process standardized, privacy checks in CI/CD |
| **Level 4** | **Measured** | Quantitative governance management based on KPIs | §17.5 KPI dashboard operational, continuous improvement of incident response times |
| **Level 5** | **Optimized** | Governance fully automated and continuously optimized | Policy-as-Code fully operational, AI-driven risk detection, automated regulatory change impact analysis |

### 37.2. Stage-Specific KPIs and Evaluation Criteria

| KPI | L1 Target | L3 Target | L5 Target |
|:----|:---------|:---------|:---------|
| **DSAR Response Within Deadline Rate** | Manual handling | ≥90% | ≥99% (automated) |
| **PII Column Tagging Rate** | Not implemented | ≥80% | **100%** |
| **DPA Execution Rate** | Major vendors only | ≥90% | **100%** |
| **Average Incident Response Time** | Not measured | <4 hours | **<1 hour** |
| **CI/CD Privacy Check Pass Rate** | N/A | ≥95% | **100%** |
| **Data Retention Compliance Rate** | Unmanaged | ≥80% | **100%** (auto-deletion) |
| **Privacy Training Completion Rate** | Optional | ≥80% | **≥95%** |

### 37.3. Action Plan for Stage Transition

*   **L1→L2 (Foundation Building)**:
    1.  Develop and publish privacy policy (§5)
    2.  Conduct PII inventory and data mapping (§16.6)
    3.  Create DSAR response procedures (§3.6)
    4.  Execute DPAs with major vendors (§13)

*   **L2→L3 (Standardization & Organization)**:
    1.  Appoint DPO/CPO or designate privacy officer (§16.1)
    2.  Standardize and operationalize DPIA process (§6.2.2)
    3.  Build and maintain ROPA (§16.2)
    4.  Introduce privacy checks into CI/CD (§16.5)
    5.  Develop incident response plan and conduct training (§14)

*   **L3→L4 (Quantitative Management)**:
    1.  Build and operate KPI dashboard (§17.5)
    2.  Establish periodic board/executive reporting (§17.5.1)
    3.  Introduce vendor risk tiering (§13.4)
    4.  Conduct quarterly tabletop exercises (§14.6)

*   **L4→L5 (Automation & AI Utilization)**:
    1.  Deploy Policy-as-Code across all layers (§16.5.2)
    2.  Introduce AI-driven risk detection and classification
    3.  Build automated regulatory change monitoring and impact analysis pipeline
    4.  Implement continuous compliance monitoring

### 37.4. Framework References

| Framework | Provider | Characteristics |
|:----------|:--------|:---------------|
| **DAMA-DMBOK** | DAMA International | 11 Knowledge Areas. Comprehensively defines data governance. v3.0 in development |
| **DCAM** | EDM Council | Capability-based assessment. Widely adopted in financial industry |
| **NIST Privacy Framework** | NIST | 5 core functions: Identify, Govern, Control, Communicate, Protect |
| **ISO/IEC 27701** | ISO/IEC | Privacy extension for ISO 27001/27002. PIMS certification |

*   **Mandate**: Conduct annual data governance maturity self-assessment and formulate next year's improvement plan.
*   **Cross-Reference**: §17 (Compliance Review & Audit), §16 (Data Governance Organization)

---

## §38. International Arbitration & ADR

### 38.1. Dispute Resolution Strategy Design
*   **Principle**: Explicitly specify data privacy dispute resolution mechanisms in DPAs and ToS.
*   **ADR Priority**: For data privacy disputes, prioritize arbitration and mediation over litigation. Recommended for confidentiality and expertise.

### 38.2. Dispute Resolution Clause Checklist

*   [ ] **Governing Law**: Specify governing law in DPA/ToS (data processing jurisdiction law recommended)
*   [ ] **Arbitral Institution**: Select from ICC, LCIA, SIAC, JCAA, etc.
*   [ ] **Seat of Arbitration**: Designate neutral arbitral seat (Singapore, London, Paris, etc.)
*   [ ] **Language**: Specify arbitration language
*   [ ] **Confidentiality**: Confidentiality obligations for arbitral proceedings and awards
*   [ ] **Multi-tier Clause**: Staged resolution flow from mediation to arbitration
*   [ ] **Arbitrator Expertise**: Selection criteria for arbitrators with data privacy and technology law expertise

### 38.3. AI and Arbitration Trends (2025-2026)
*   **AI Arbitrator**: AAA/ICDR launched documents-only AI arbitrator in September 2025. Plans to expand to other institutions in 2026.
*   **AI Usage Guidelines**: Arbitral institutions issuing guidelines on responsible AI use. Prioritizing due process, confidentiality, transparency, and enforceability.
*   **Procedural Order AI Provisions**: Trend of tribunals explicitly specifying AI permitted use cases, AI assistance disclosure, data security, and human oversight in procedural orders.

### 38.4. Legislation Updates
*   **UK Arbitration Act 2025**: Effective August 2025. Important changes to arbitrator immunity and governing law.
*   **China New Arbitration Law**: Effective March 2026. Modernization to international standards, introduction of ad hoc arbitration.
*   **Cross-Reference**: §13 (Vendor Data Governance - DPA dispute resolution clauses)

---

## §39. Digital Contract Law & Smart Contracts

### 39.1. Legal Validity of Digital Contracts
*   **Principle**: Digital signatures and electronic contracts are legally valid in most jurisdictions. However, legal validity depends on **clear disclosure and consent**.
*   **Japan**: Based on the Act on Electronic Signatures and Certification Business, electronic signatures have legal effect equivalent to written signatures.
*   **EU**: EU Digital Identity Wallet mandatory under eIDAS 2.0 (2026-2027)
*   **US**: Broad legal recognition of electronic signatures under ESIGN Act / UETA

### 39.2. Smart Contract Legal Framework

> [!WARNING]
> The legal framework for smart contracts is still evolving. Interpretive challenges remain regarding enforceability, liability, and jurisdiction.

*   **Definition**: Self-executing programs on blockchain. Automatically execute contract terms upon condition fulfillment.
*   **Legal Challenges**:
    *   **Enforceability**: Whether courts recognize code as contracts varies by jurisdiction
    *   **Liability**: Allocation of liability for damages from code bugs/vulnerabilities
    *   **Dispute Resolution**: Jurisdictional determination in decentralized systems
    *   **Consumer Protection**: Ensuring readability and transparency of complex contract terms
*   **Regulatory Trends**:
    *   **EU MiCA**: Regulation of crypto assets and blockchain financial services (including smart contracts)
    *   **US Deploying American Blockchains Act (2025)**: Promoting blockchain technology and smart contract utilization
*   **Mandate**: When using smart contracts, they must always be supplemented with **legally binding human-readable contracts**. Code-only contracts are prohibited.

### 39.3. Australia ADM Transparency Obligations (Effective 2026.12)
*   **Law**: Under Privacy Act amendment (POLA Act 2024), APP entities must disclose use of **automated decision-making (ADM)** in privacy policies.
*   **Scope**: ADM processes reasonably expected to **significantly affect** individuals' rights or interests. Covers not just AI/ML but also rule-based tools and potentially spreadsheets.
*   **Disclosure Requirements**:
    *   **Types** of personal information used in ADM
    *   **Types** of decisions made by ADM
*   **Penalties**: Up to $330,000 (compliance notices)
*   **Action**: Update privacy policies by December 2026 to include ADM usage disclosures.
*   **Cross-Reference**: §3.7 (Automated Decision-Making), §11 (AI Regulation)

---

## §40. Data Ethics Board & Ethics Review

### 40.1. Ethics Review Board Establishment & Composition
*   **Mandate**: Establish a **Data Ethics Board** when AI/data utilization becomes core to business operations.
*   **Composition (Recommended)**:

| Role | Count | Selection Criteria |
|:-----|:------|:-------------------|
| **Technical Lead** | 1 | Practical experience in AI/ML engineering |
| **Legal / Compliance** | 1 | Expertise in data protection law and AI regulation |
| **Product Manager** | 1 | Ability to assess user impact |
| **External Expert (Ethics)** | 1 | Academic expertise in technology ethics and social impact |
| **User Representative / D&I Officer** | 1 | Diversity and inclusion perspective |

*   **Independence**: The Ethics Board must maintain independence from management. Members with conflicts of interest must be excluded from voting.
*   **Cross-Reference**: §11.9 (AI Governance Committee) — Clarify the division of responsibilities between the AI Governance Committee and the Ethics Board.

### 40.2. Ethics Review Triggers & Decision-Making Criteria
*   **Trigger Conditions (ethics review is mandatory if any of the following apply)**:
    *   [ ] New features that **profile** user behavior, preferences, or emotions
    *   [ ] Data processing that may affect **vulnerable persons** (children, elderly, persons with disabilities)
    *   [ ] Algorithms that may produce **discriminatory outcomes** (hiring, lending, insurance, housing, etc.)
    *   [ ] New services involving **large-scale personal data collection**
    *   [ ] Designs that affect users' **digital wellbeing** (addictive UI, etc.)
    *   [ ] New use of **biometric or neural data**
    *   [ ] **Synthetic data** generation/use (bias amplification risk)
    *   [ ] Introduction of technology in a **legal gray zone**
*   **Decision-Making Criteria (FAST Principles)**:
    *   **F**airness: Are there no undue disadvantages to specific groups?
    *   **A**ccountability: Is the locus of responsibility for decisions clear?
    *   **S**ustainability: Have long-term social impacts been considered?
    *   **T**ransparency: Is the explanation to users sufficient?

### 40.3. Ethical Risk Assessment Framework

| Risk Level | Definition | Response | Approval Authority |
|:-----------|:-----------|:---------|:-------------------|
| **Critical** | Risk of fundamental human rights violation | **Halt development** or fundamental redesign | Ethics Board unanimous + executive approval |
| **High** | Risk of significant disadvantage to specific groups | Implement mitigation measures + periodic monitoring | Ethics Board majority |
| **Medium** | Potential bias or unfairness risk | Document mitigation measures + monitoring | Technical Lead + Legal approval |
| **Low** | Minimal ethical concerns | Address through standard development processes | PM approval |

### 40.4. Newspaper Test
*   **Definition**: A thought experiment to verify "how would it affect the company's reputation if this feature/data use became a front-page news story?"
*   **Timing**: When ethics review triggers are met, and during data utilization design for new features.
*   **Documentation**: Include test results and rationale in ethics review records.
*   **Anti-Pattern**: Skipping ethics review because "it's legally fine." Legal compliance and ethical justification are separate concepts.

### 40.5. Ethics Review Records & Audit
*   **Record Items**: Review date/time, participants, target feature/service, risk assessment results, decisions, conditions for conditional approvals
*   **Retention Period**: **Minimum 5 years**
*   **Annual Report**: Report Ethics Board activity summary to executive management annually
*   **Cross-Reference**: §17 (Compliance Review)

---

## §41. GenAI Copyright & Training Data Governance Enhancement

### 41.1. AI Copyright Litigation Case Map (2024-2026)

> [!WARNING]
> AI copyright law is evolving rapidly. The following are key litigation and settlement cases and should NOT be relied upon as settled precedent. Legal team reviews the latest status quarterly.

| Case | Jurisdiction | Status | Key Issues | Impact |
|:-----|:-------------|:-------|:-----------|:-------|
| **NYT v. OpenAI/Microsoft** | US | Filed 2024 → 2026 trial | Fair Use, substantial similarity of outputs | Precedent for LLM training data legality |
| **Anthropic Settlement** | US | 2025.8 settlement (**$1.5B**) | Use of pirated data for training | Demonstrated importance of training data legality verification |
| **Getty v. Stability AI** | US/UK | In trial | Unauthorized image training | Copyright risk of image generation AI |
| **Thomson Reuters v. Ross Intelligence** | US | 2025 ruling | AI training use of works is NOT Fair Use | Warning against easy assumption that "training = Fair Use" |
| **Concord Music v. Anthropic** | US | In trial | Unauthorized lyric training/regeneration | Music copyright and AI output relationship |

*   **Mandate**: When developing/deploying AI features, evaluate the litigation risk of model providers through **due diligence**.

### 41.2. Training Data Due Diligence Checklist

> Conduct when training AI models in-house or using external models.

#### 41.2.1. In-House Training
*   [ ] Have you documented the **complete source list** of training datasets?
*   [ ] Have you verified **license terms** for each source and confirmed AI training use is permitted?
*   [ ] Have you assessed the proportion of **copyrighted content** included?
*   [ ] Are you respecting EU DSM Directive Art.4 **TDM opt-outs** (checking robots.txt / ai.txt)?
*   [ ] Have you conducted a legal assessment that the **"unduly prejudice" exception** under Japan Copyright Act Art.30-4 does not apply?
*   [ ] If training data contains **personal data**, are §1-§4 privacy requirements satisfied?
*   [ ] **Bias Audit**: Have you assessed demographic representativeness of training data?
*   [ ] Have you recorded and preserved **Data Provenance** documentation for training data?

#### 41.2.2. External Model Usage
*   [ ] Does the model provider **guarantee training data legality** (contract terms verified)?
*   [ ] Is an **Indemnification clause** included in the provider contract?
*   [ ] Have you confirmed the provider's **training data opt-out policy** (can user data learning be refused)?
*   [ ] Have you assessed the provider's published **copyright litigation risks** (see §41.1)?
*   [ ] Is **output copyright attribution** clearly defined in the contract?

### 41.3. AI-Generated Work Copyrightability by Jurisdiction

| Jurisdiction | AI-Generated Work Copyrightability | Conditions |
|:-------------|:----------------------------------|:-----------|
| **US** | ❌ Generally denied | Human creative involvement required. Purely AI-generated works are public domain (USCO 2023, Thaler v. Perlmutter) |
| **EU** | ❌ Generally denied | "Author's intellectual creation" requirement. Human creative choice/arrangement needed |
| **Japan** | ⚠️ Undetermined | Agency for Cultural Affairs 2024 draft: "AI-assisted works" judged individually by degree of human creative contribution |
| **China** | ✅ Conditionally affirmed | Beijing Internet Court (2023): Copyright recognized for AI-generated works with sufficient "intellectual investment" |
| **UK** | ✅ Conditionally affirmed | CDPA s.9(3): Author of "computer-generated works" is the person who made the necessary arrangements |

*   **Mandate**: When publishing AI-generated content, pre-assess copyrightability based on target jurisdiction criteria. In jurisdictions where protection is unavailable, consider **trade secret or contractual protection**.

### 41.4. Input/Output Copyright Risk Matrix

| Risk Classification | Input (Training Data) | Output (Generated Content) | Countermeasures |
|:-------------------|:--------------------|:--------------------------|:----------------|
| **High Risk** | Copyrighted content trained without permission | Output substantially similar to existing works | Prohibit use. Implement filtering/guardrails |
| **Medium Risk** | Open-license data trained | Mimics existing styles but has originality | Verify license compliance. Similarity check on output |
| **Low Risk** | License-cleared data trained | Completely original output | Address through standard processes |

*   **Output Filtering Implementation**:

```typescript
// AI output copyright risk filtering
interface ContentRiskCheck {
  outputId: string;
  similarityScore: number;     // 0-1: similarity to known works
  riskLevel: 'high' | 'medium' | 'low';
  matchedSources: string[];    // Works where similarity was detected
  action: 'block' | 'review' | 'pass';
}

const SIMILARITY_THRESHOLDS = {
  block: 0.85,    // 85%+: auto-block
  review: 0.60,   // 60%+: human review
  pass: 0.0,      // <60%: pass
};
```

*   **Mandate**: Conduct similarity checks when publishing AI-generated content externally.
*   **Cross-Reference**: §11.6 (AI-Generated Content Copyright), §11.11 (GenAI Training Data Compliance), `602_oss_compliance.md`

---

## §42. Integrated Privacy Impact Assessment (PIA/DPIA) Framework

### 42.1. Impact Assessment Matrix

> [!IMPORTANT]
> Multiple regulations require different types of impact assessments. This section organizes the relationships between each assessment and enables integrated implementation.

| Assessment Type | Legal Basis | Trigger | Primary Assessment Target | Update Frequency |
|:---------------|:------------|:--------|:-------------------------|:-----------------|
| **DPIA** | GDPR Art.35 | High-risk data processing | Privacy risk & impact on data subjects | On processing change + annual review |
| **TIA** | GDPR Art.44-49 + CNIL | Cross-border data transfer | Legal protection level in destination country | At least annually + on significant changes |
| **AI Impact Assessment** | EU AI Act / Colorado AI Act | High-risk AI systems | AI safety, impact on rights, bias | Pre-deployment + annual (or 90 days after significant changes) |
| **CCPA Risk Assessment** | CCPA/CPRA (effective 2026.1) | ADMT use, profiling | Balance of consumer benefits and privacy invasion risk | Before new processing + annual |
| **Ethics Impact Assessment** | §40 (this file) | Ethics review trigger applies | Fairness, transparency, social impact | Before feature release |

### 42.2. CCPA Risk Assessment Requirements (Effective 2026.1)
*   **Scope**: Businesses conducting significant profiling, ADMT use, or sensitive PI processing
*   **Requirements**:
    *   Description of processing **purpose and necessity**
    *   Comparative weighing of consumer **benefits** and privacy invasion **risks**
    *   Documentation of risk mitigation measures
    *   **Pre-2026.1 existing processing**: Complete assessment by 2027.12.31
*   **Action**: Create CCPA Risk Assessment template and integrate with existing DPIA process.

### 42.3. Integrated Impact Assessment Template

```typescript
// Integrated Impact Assessment Management Framework
interface IntegratedImpactAssessment {
  assessmentId: string;          // UUID
  projectName: string;
  assessmentTypes: ('DPIA' | 'TIA' | 'AI_IA' | 'CCPA_RA' | 'Ethics_IA')[];
  status: 'draft' | 'in_review' | 'approved' | 'expired';
  riskLevel: 'critical' | 'high' | 'medium' | 'low';
  dataCategories: string[];      // Data categories being processed
  jurisdictions: string[];       // Affected jurisdictions
  approvedBy: string;            // Approver
  approvedAt: string;            // ISO 8601
  nextReviewDate: string;        // Next review date
  mitigationMeasures: {
    measure: string;
    status: 'planned' | 'implemented' | 'verified';
    verifiedAt: string | null;
  }[];
}

// Auto-determine required assessment types
function determineRequiredAssessments(
  processing: { hasHighRiskAI: boolean; hasCrossBorderTransfer: boolean;
    hasADMT: boolean; hasEthicsTrigger: boolean; jurisdictions: string[] }
): string[] {
  const required: string[] = ['DPIA']; // DPIA always recommended
  if (processing.hasCrossBorderTransfer) required.push('TIA');
  if (processing.hasHighRiskAI) required.push('AI_IA');
  if (processing.hasADMT && processing.jurisdictions.includes('US-CA'))
    required.push('CCPA_RA');
  if (processing.hasEthicsTrigger) required.push('Ethics_IA');
  return required;
}
```

*   **Mandate**: At the start of new projects, perform determination equivalent to `determineRequiredAssessments` to **identify all required assessments without omission**.
*   **Cross-Reference**: §6.2.2 (DPIA 7 Steps), §3.4 (TIA), §3.7 (ADMT), §40 (Ethics Review)

---

## §43. Regulatory Technology (RegTech) & Compliance Automation

### 43.1. RegTech Tool Selection Criteria

| Evaluation Category | Evaluation Items | Importance |
|:-------------------|:-----------------|:-----------|
| **Regulatory Coverage** | Scope of supported regulations (GDPR/CCPA/APPI/AI Act, etc.) | Required |
| **Auto-Tracking** | Automatic regulatory change detection and alerting | Required |
| **Integration** | Interoperability with existing tools (SIEM, GRC, CMP, etc.) | Important |
| **Reporting** | Auto-generation of board reports and regulatory authority submissions | Important |
| **Audit Trail** | Immutable logging of all operations | Required |
| **Customizability** | Adaptability to custom policies and workflows | Important |
| **Data Security** | Security of the tool itself and data storage location | Required |

*   **Key Tool Categories**:
    *   **GRC (Governance, Risk & Compliance)**: OneTrust, TrustArc, Vanta, Drata
    *   **Regulatory Change Tracking**: Ascent RegTech, CUBE, Thomson Reuters Regulatory Intelligence
    *   **Data Mapping & ROPA Automation**: OneTrust Data Mapping, BigID, Securiti.ai
    *   **DSAR Automation**: DataGrail, Mine PrivacyOps, Transcend

### 43.2. Regulatory Change Auto-Tracking Pipeline

```yaml
# Regulatory Change Auto-Tracking Pipeline (Conceptual Design)
name: Regulatory Change Tracking
schedule: 'weekly'
steps:
  1_monitor:
    sources:
      - GDPR / ePrivacy Official Journal
      - IAPP Daily Dashboard
      - National DPA Official Announcements
      - Legislative Bill Trackers
    output: raw_regulatory_changes

  2_classify:
    input: raw_regulatory_changes
    actions:
      - Auto-classify impact level (High / Medium / Low)
      - Auto-map to related sections (this file)
    output: classified_changes

  3_alert:
    input: classified_changes
    actions:
      - 'High': Immediate notification to legal team + DPO
      - 'Medium': Include in weekly summary
      - 'Low': Archive for quarterly review

  4_action:
    input: classified_changes (High/Medium)
    actions:
      - Auto-set deadline for technical response plan (within 30 days)
      - Propose additions to §2.3 timeline
```

*   **Mandate**: Regulatory change tracking must use **manual quarterly review** as a minimum, transitioning to **weekly automated monitoring** after tool adoption.

### 43.3. Compliance Automation Maturity Map

| Maturity | Manual → Automated | Target Domain | Tool Examples |
|:---------|:-------------------|:--------------|:--------------|
| **L1** | Manual | Regulatory review, DSAR email responses | Spreadsheets, email |
| **L2** | Semi-automated | DSAR management, consent records, DPA management | GRC tool basic features |
| **L3** | Automated | Regulatory change tracking, PII detection, retention management | RegTech + CI/CD integration |
| **L4** | AI-assisted | Risk prediction, anomaly detection, impact analysis | AI-driven GRC |
| **L5** | Fully automated | Adaptive compliance (regulatory change → auto-proposed technical response) | Future target |

*   **Cross-Reference**: §16.5 (Policy-as-Code), §37 (Data Governance Maturity Model)

### 43.4. ROI Measurement & Adoption Decision Criteria
*   **Quantitative Metrics**:
    *   DSAR average processing time reduction rate
    *   Compliance personnel productivity improvement
    *   Incident detection time reduction
    *   Audit preparation time reduction
*   **Qualitative Metrics**:
    *   Response speed to regulatory changes (days from detection to plan formulation)
    *   Reduction in audit findings
    *   Improvement in board report quality and timeliness
*   **Anti-Pattern**: Making RegTech tool adoption an end in itself, divorced from organizational process improvement. Tools are means to automate processes; adopting them without defined processes yields limited results.

---

## §44. Data Trusts & Data Sharing Agreements

### 44.1. EU Data Governance Act & Data Altruism
*   **Law**: The EU Data Governance Act (DGA, effective 2023.9) establishes a legal framework for voluntary data sharing for public interest purposes (**Data Altruism**).
*   **Key Concepts**:

| Concept | Definition | Legal Basis |
|:--------|:-----------|:------------|
| **Data Altruism** | Voluntary provision of data for public interest purposes (scientific research, public health, etc.) | DGA Chapter IV |
| **Data Altruism Organization (DAO)** | Certified entity promoting data altruism activities | Under EU member state registration/supervision |
| **Data Intermediation Service** | Matching data holders with data users | DGA Chapter III, notification regime |
| **European Common Data Spaces** | Sector-specific data sharing ecosystems (health, agriculture, manufacturing, etc.) | Core of EU data strategy |

*   **Engineering Impact**: When participating in EU data spaces, incorporate data sharing API interfaces, access controls, and usage purpose traceability into design.

### 44.2. Data Trust Structure & Legal Framework
*   **Definition**: A Data Trust is a structure where an independent trustee manages data for the benefit of data providers based on trust law.
*   **Key Models**:

| Model | Characteristics | Use Cases |
|:------|:---------------|:----------|
| **Civic Data Trust** | Manages citizen data for public benefit | Smart cities, public health |
| **Commercial Data Trust** | Intermediates data sharing between enterprises | Cross-industry benchmarks |
| **Personal Data Trust** | Individuals entrust their data and delegate management | Collective management of personal data |

*   **Legal Considerations**: Trust law varies significantly by jurisdiction. The UK's Data Trust Pioneer project serves as a leading example. In Japan, METI's 2022 "Study on Data Transactions" provides reference.

### 44.3. Data Sharing Agreement Template Requirements
*   **Mandatory Clauses**:
    *   [ ] Clear definition of shared data scope and categories
    *   [ ] Purpose Limitation
    *   [ ] Re-sharing/re-use prohibition clause
    *   [ ] Disclaimer on data quality and accuracy
    *   [ ] Intellectual property rights attribution
    *   [ ] Data breach notification obligations
    *   [ ] Data deletion/return obligation upon contract termination
    *   [ ] Governing law and dispute resolution mechanism
    *   [ ] DPA clauses when personal data is included (per §13)
*   **Cross-Reference**: §13 (Vendor Data Governance), §21 (Data Clean Room)

### 44.4. Public Interest Data Use & Ethical Considerations
*   **Principle**: Even for public interest data sharing, individual privacy rights are protected.
*   **Requirements**:
    *   Data provision based on data altruism requires **explicit and voluntary consent**
    *   Consent is **revocable at any time**
    *   Public interest must be **narrowly and strictly** interpreted ("improving business marketing" does not qualify)
    *   Maximize anonymization/pseudonymization to minimize individual re-identification risk
*   **Cross-Reference**: §20 (Synthetic Data Governance), §3.5 (Data Processing Standards)

---

## §45. Quantum Computing Threats & Cryptographic Agility

### 45.1. Threat Overview

> [!CAUTION]
> Cryptographically Relevant Quantum Computers (CRQC) are predicted to break current public-key cryptography within 10-20 years. **Harvest-Now-Decrypt-Later (HNDL)** attacks are already underway, and countermeasures for sensitive data requiring long-term protection should be initiated **immediately**.

*   **Harvest-Now-Decrypt-Later (HNDL)**: An attack strategy of collecting and storing currently encrypted data to decrypt it with quantum computers in the future. Likely already being executed at government level.
*   **Affected Cryptography**:

| Cipher | Impact | Current Use |
|:-------|:-------|:------------|
| **RSA** | ❌ **Broken** | TLS/SSL, digital signatures, key exchange |
| **ECDSA / ECDH** | ❌ **Broken** | TLS 1.3, cryptocurrency, code signing |
| **AES-256** | ⚠️ **Safe (key length halved equivalent)** | Symmetric encryption. AES-256 maintains AES-128 equivalent security under Grover's algorithm |
| **SHA-256** | ⚠️ **Safe (collision resistance reduced)** | Hashing. Collision search accelerated but sufficient preimage resistance |

### 45.2. NIST Post-Quantum Cryptography Standards

| Standard | Algorithm | Type | NIST Published | Use Case |
|:---------|:----------|:-----|:---------------|:---------|
| **FIPS 203** | ML-KEM (CRYSTALS-Kyber) | Key Encapsulation | 2024.8 | TLS key exchange (RSA/ECDH replacement) |
| **FIPS 204** | ML-DSA (CRYSTALS-Dilithium) | Digital Signature | 2024.8 | Code signing, authentication (ECDSA/RSA replacement) |
| **FIPS 205** | SLH-DSA (SPHINCS+) | Stateless Signature | 2024.8 | Long-term document signing (alternative to stateful signatures) |
| **FIPS 206** | FN-DSA (FALCON) | Digital Signature | 2025 (in progress) | Compact signatures (bandwidth-constrained environments) |

### 45.3. Jurisdiction-Specific PQC Migration Mandates & Guidance

| Jurisdiction | Regulation/Guidance | Requirements | Deadline |
|:-------------|:-------------------|:-------------|:---------|
| **US** | NSM-10 (2022) + OMB M-23-02 | Federal government system PQC migration plan mandate | 2035 (phased) |
| **US** | CISA PQC Guidance | Recommends CRQC risk assessment and PQC migration roadmap for critical infrastructure | Recommended (mandate under consideration) |
| **EU** | ENISA PQC Report (2025) | Guidance for EU institution PQC migration roadmaps | Recommended |
| **France** | ANSSI (2024) | Recommends hybrid cryptography (PQC + traditional crypto combined) | Recommended |
| **Germany** | BSI (2024) | Recommends ML-KEM / ML-DSA for government use | Recommended |

### 45.4. Cryptographic Agility Governance Framework
*   **Definition**: **Cryptographic Agility** is the design property enabling cryptographic algorithm changes to be executed without large-scale system-wide modifications.
*   **Implementation Principles**:
    *   Manage cryptographic algorithms as **configuration parameters**, not hardcoded in code
    *   **Support multiple ciphersuites** in TLS configuration to facilitate PQC algorithm addition
    *   Attach **algorithm metadata** (cipher used, key length, version) to encrypted data
    *   Create and maintain a **CBOM (Cryptography Bill of Materials)** to visualize all cryptographic assets in use

```typescript
// Cryptographic Agility Design Pattern
interface CryptoConfig {
  keyEncapsulation: 'ML-KEM-768' | 'ML-KEM-1024' | 'X25519';
  digitalSignature: 'ML-DSA-65' | 'ML-DSA-87' | 'Ed25519';
  symmetricEncryption: 'AES-256-GCM';
  hashFunction: 'SHA-256' | 'SHA-3-256';
}

// Enable algorithm switching via environment variables
const cryptoConfig: CryptoConfig = {
  keyEncapsulation: (process.env.CRYPTO_KEM as CryptoConfig['keyEncapsulation']) || 'X25519',
  digitalSignature: (process.env.CRYPTO_SIG as CryptoConfig['digitalSignature']) || 'Ed25519',
  symmetricEncryption: 'AES-256-GCM',
  hashFunction: 'SHA-256',
};
```

### 45.5. PQC Migration Roadmap

| Phase | Timeline | Actions |
|:------|:---------|:--------|
| **Phase 1: Inventory** | Start immediately | Create CBOM. Inventory all cryptographic algorithms, protocols, and keys in use |
| **Phase 2: Risk Assessment** | Within 3 months | Assess HNDL risk. Identify data requiring long-term protection (health data, government data, etc.) |
| **Phase 3: Hybrid Migration** | 6-12 months | Introduce hybrid cryptography (PQC + traditional crypto combined) starting from high-risk areas |
| **Phase 4: Full PQC Migration** | 2030 target | Fully migrate all systems to PQC algorithms |

*   **Mandate**: Phase 1 (CBOM creation) must be started **immediately**. PQC migration planning is impossible without cryptographic asset visibility.
*   **Anti-Pattern**: Deferring countermeasures because "quantum computers are still far off." HNDL risk is **currently in progress**.
*   **Cross-Reference**: `600_security_privacy.md` (Encryption & Key Management), §30.5 (CMMC — NIST SP 800-171 PQC readiness)

## Appendix A: Quick Reference Index

> Quick reference index for AI partial loading of this file.

| Keyword | Reference Section |
|:--------|:-----------------|
| GDPR / Digital Omnibus | §2.1, §2.3, §3.4, §4.7, §6.2.1, §6.2.2, §16.2 |
| APPI / Personal Information Protection / 2027 Amendment | §2.1, §3.5, §6.1, §6.1.6 |
| CCPA / CPRA / ADMT | §2.1, §3.6, §3.7, §6.3.1, §6.3.2 |
| EU AI Act / Phased Enforcement | §2.1, §2.3, §11.1-11.4, §25, §31 |
| DSA / DMA | §2.1, §6.2.3, §15.3, §24.1 |
| DORA / NIS2 | §2.1, §14.4 |
| COPPA / AADC | §2.1, §7, §14.4 |
| Cookie / CMP / Consent Management | §4, §4.7 |
| Terms of Service / ToS | §5 |
| Privacy Policy | §5.3, §5.4 |
| Data Portability | §3.2 |
| Right to Erasure | §3.3 |
| DSAR / Data Subject Requests | §3.6 |
| Cross-Border Transfer / SCC / BCR | §3.4 |
| Pseudonymization / Anonymization | §3.5 |
| DPIA | §6.2.1, §6.2.2 |
| Commercial Transactions Act | §6.1.1 |
| Payment Services Act | §6.1.2 |
| Stealth Marketing | §6.1.3 |
| Email Compliance | §6.1.4 |
| Children's Data Protection / Age Gate | §7 |
| Dark Patterns | §8 |
| License / GPL | §9.1 |
| UGC / User-Generated Content | §9.2 |
| Contractor / IP | §9.3 |
| Anti-Social Forces / KYC / KYB | §10 |
| AI Copyright / AI Training | §11.6, §11.7 |
| Data Commercialization / Opt-Out | §11.8 |
| AI Governance Committee | §11.9 |
| Data Retention Period | §12.1 |
| Content Archival | §12.2 |
| Vendor / DPA / Contract Template | §13 |
| Data Breach Notification / Jurisdiction Timeline | §14, §14.4 |
| Content Moderation / DMCA | §15 |
| DPO / CPO / Data Steward | §16.1 |
| ROPA | §16.2 |
| Privacy Engineering / Code Snippets | §16.4 |
| Policy-as-Code | §16.5 |
| Data Mapping / Data Flow Diagrams | §16.6 |
| Compliance Audit | §17 |
| India DPDP Act | §2.1, §7.2 |
| China PIPL | §2.1, §3.4.1 |
| Brazil LGPD | §2.1 |
| Korea PIPA | §2.1 |
| Vietnam PDPD | §2.1 |
| Dispute Resolution / Arbitration / ODR | §5.6 |
| Subscription Auto-Renewal / Click-to-Cancel | §6.1.5 |
| Biometric Data / BIPA / Deepfake | §7.5 |
| GenAI Hallucination / Indemnification | §11.10 |
| Agentic AI / Liability | §11.5 |
| Law Enforcement / CLOUD Act / Transparency Report | §18 |
| Legal Hold / eDiscovery / Evidence Preservation | §19 |
| Data Localization / Country Requirements | §3.4.1 |
| Automated Decision-Making / GDPR Art.22 / ADMT / Colorado AI Act | §3.7, §31 |
| Cookieless Tracking / Fingerprinting / Privacy Sandbox | §4.5 |
| Third-Party Scripts / Tag Manager | §4.6 |
| Differential Privacy / Federated Learning / Homomorphic Encryption | §16.4 |
| Data Ethics / Newspaper Test | §16.7 |
| Whistleblower Protection | §18.4 |
| Synthetic Data / TSTR Validation | §20 |
| Data Clean Room / DCR | §21 |
| Neural Data / Neurorights / SB 1223 | §22 |
| ESG / CSRD / Sustainability Reporting | §23 |
| Digital Product Passport / DPP | §23.2 |
| Antitrust / DMA / Algorithmic Collusion | §24 |
| ISO 42001 / NIST AI RMF | §25 |
| Digital Sovereignty / Sovereign Cloud / EuroStack | §26 |
| US State Laws / State Law Proliferation | §6.3.2 |
| EAA / Accessibility | §6.2.4 |
| HIPAA / Health Data / MHMDA | §27 |
| Reproductive Health Data / Dobbs | §28 |
| Employee Data / Workplace Monitoring / ECPA | §29 |
| GLBA / FCRA / PCI DSS / Financial Data | §30.1 |
| FERPA / Education Data | §30.2 |
| TCPA / Communications Data | §30.3 |
| FTC Section 5 / AI Washing | §30.4 |
| Global AI Regulation / CAITA / Colorado AI Act / Texas RAIGA | §31 |
| Data Broker / Delete Act / DROP | §32 |
| FISA §702 / Government Surveillance / Schrems II | §33 |
| Maryland MODPA | §6.3.4 |
| California Delete Act / DROP | §6.3.3, §32 |
| UK DUAA 2025 / Smart Data / DVS | §4.5, §6.2.5 |
| Cookie Deprecation Reversal / Privacy Sandbox Retirement | §2.3, §4.5 |
| COPPA 2.0 / KIDS Act / Age Verification | §2.3, §7.6, §7.7, §7.8 |
| CA SB 446 / NY Notification Law Amendment | §2.3, §14.4 |
| FTC Foreign Adversary Data Act / DOJ Bulk Data | §33.4, §33.5 |
| CIRCIA / Critical Infrastructure | §2.3, §14.4 |
| GDPR Fine Statistics / Enforcement Trends | §14.5 |
| Online Safety Act / AU Social Media Ban | §7.6 |
| NY Synthetic AI Performer Law | §31.1 |
| TIA 6-Step / CNIL 2025 Guidelines | §3.4 |
| EU-US DPF / UK Adequacy Extension | §3.4 |
| Consent Management API / Server-Side Enforcement | §4.2.1 |
| DSAR API / Statutory Deadline Auto-Calculation | §3.6.1 |
| Policy-as-Code / CI/CD Privacy Checks | §16.5.1 |
| Vendor Risk Tiering / Continuous Monitoring | §13.4 |
| Fourth-Party Risk / Sub-Processor / Flow-Through | §13.5 |
| Tabletop Exercise / Cross-Border Incident Coordination | §14.6 |
| Jurisdiction-Specific Retention / Litigation Hold | §12.4 |
| Right to Explanation / XAI / SHAP / LIME / Algorithmic Transparency | §3.7.1 |
| GenAI Training Data / Copyright / robots.txt / ai.txt | §11.11 |
| Privacy KPI / Board Reporting / DPO | §17.5 |
| GPAI Code of Practice / Copyright Compliance Policy | §11.4.1 |
| Digital Omnibus / Pseudonymization / DSAR Abuse / AI Legitimate Interest / Cookie Simplification | §4.7 |
| EDPB 2026 Coordinated Enforcement / Transparency Obligations / Art.12-14 | §17.1.1 |
| Multi-State Coordinated Enforcement / GPC / Universal Opt-Out | §6.3.2 |
| EU Data Act / IoT Data Access / Connected Devices | §34 |
| Access-by-Design / Cloud Portability / Data Egress | §34.3, §34.4 |
| AI Companion / Chatbot Safety / SB 53 / Frontier Model | §35 |
| AI-Generated Content Labeling / EU Common Icon / Art.50 | §35.3 |
| International Arbitration / ADR / Dispute Resolution Clause / JCAA / ICC | §38 |
| AI Arbitrator / AAA / ICDR | §38.3 |
| UK Arbitration Act / China Arbitration Law | §38.4 |
| Digital Contract / Smart Contract / eIDAS / MiCA | §39 |
| Australia ADM Transparency Obligation / POLA Act | §39.3 |
| eDiscovery AI / TAR / CAL / AI-Generated Evidence / Shadow AI | §19.3 |
| IR Runbook / Notification Deadline Calculator / Incident Response Automation | §14.6.4 |
| Privacy by Design / PbD / GDPR Art.25 / LINDDUN | §36 |
| PbD Checklist / Privacy Review Gates | §36.2, §36.3 |
| PET / Differential Privacy / k-Anonymization / Tokenization | §36.4, §16.4 |
| Data Governance Maturity / DAMA-DMBOK / DCAM | §37 |
| Governance KPI / Stage Transition / Maturity Assessment | §37.2, §37.3 |
| NIST Privacy Framework / ISO 27701 / PIMS | §37.4 |
| GPC / Universal Opt-Out / Sec-GPC | §4.8, §6.3.2 |
| Governance Automation / Open Policy Agent | §16.5.2 |
| CMMC / Defense Industry / NIST SP 800-171 / CUI | §30.5 |
| Federal Preemption / AI Litigation Task Force | §6.3.2 |
| Oregon Precise Geolocation / Sensitive Data | §6.3.2 |
| APPI Administrative Penalties / AI Development Relaxation / 2026 Bill | §6.1.6 |
| EU AI Act Enforcement Deferral / 2027.12 / Annex III | §2.3, §11.2 |
| Data Ethics Board / Ethics Review / FAST Principles / Newspaper Test | §40 |
| Ethical Risk Assessment / Ethics Triggers | §40.2, §40.3 |
| AI Copyright Litigation / Anthropic Settlement / NYT v. OpenAI / Fair Use | §41.1 |
| Training Data Due Diligence / Data Provenance | §41.2 |
| AI-Generated Work Copyrightability / Jurisdiction-Specific / USCO | §41.3 |
| Output Filtering / Similarity Check / Copyright Risk Matrix | §41.4 |
| PIA / DPIA Integration / Impact Assessment Matrix | §42 |
| CCPA Risk Assessment / Effective 2026.1 | §42.2 |
| Integrated Impact Assessment Template / Auto-Determine Assessment Types | §42.3 |
| RegTech / GRC / Regulatory Change Tracking / Compliance Automation | §43 |
| RegTech Maturity / Auto-Monitoring / AI-Driven GRC | §43.3 |
| Data Trust / Data Altruism | §44 |
| EU Data Governance Act / DGA / Data Altruism | §44.1 |
| Data Sharing Agreement / Purpose Limitation / Re-Sharing Prohibition | §44.3 |
| Quantum Computing / PQC / Post-Quantum / CRQC | §45 |
| HNDL / Harvest-Now-Decrypt-Later | §45.1 |
| NIST PQC / FIPS 203 / ML-KEM / FIPS 204 / ML-DSA | §45.2 |
| Cryptographic Agility / CBOM / Hybrid Cryptography | §45.4 |
| PQC Migration Roadmap / NSM-10 / CISA / ENISA | §45.3, §45.5 |

---

**Cross-Reference (Related Rules):**
*   `600_security_privacy.md` — Security technical implementation, Zero Trust, encryption
*   `602_oss_compliance.md` — License detailed management, vulnerability scanning
*   `603_ip_due_diligence.md` — Patent strategy, due diligence, IP asset management
*   `503_incident_response.md` — Crisis management, BCP, incident runbooks
*   `200_design_ux.md` — Accessibility (WCAG 2.1 AA)
*   `400_ai_engineering.md` — AI implementation, guardrails, RAG design
*   `101_revenue_monetization.md` — FinOps, payments, tax
*   `301_api_integration.md` — API gateways, CORS
*   `103_appstore_compliance.md` — App Store / Google Play guidelines
*   `361_aws_cloud.md` — Cloud architecture, region design
*   `700_qa_testing.md` — Test strategy, test data

### Cross-References

| Section | Related Rules |
|---------|---------------|
| §1–§3 (Data Classification & Lifecycle) | `600_security_privacy`, `320_supabase_architecture` |
| §4–§6 (Privacy & Consent) | `600_security_privacy` |
| §7–§9 (Data Quality & Lineage) | `401_data_analytics`, `300_engineering_standards` |
| §10–§12 (Regulatory Compliance) | `603_ip_due_diligence`, `103_appstore_compliance` |
| §13–§15 (Access Control & Audit) | `801_governance` |
