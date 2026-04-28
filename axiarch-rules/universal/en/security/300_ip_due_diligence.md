# 63. IP Strategy & Due Diligence

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-04-19

> [!IMPORTANT]
> **Supreme Directive**
> "Intellectual property is the invisible moat — unprotected IP is an invitation to competitors."
> All IP decisions must treat protection, ownership clarity, and due diligence as non-negotiable.
> Strictly follow: **IP Protection > Legal Compliance > Business Strategy > Speed**.
> **61 Sections.**

---

## Table of Contents

- [I. IP Ownership & Rights Attribution (§1-§5)](#i-ip-ownership--rights-attribution-1-5)
- [II. Patent Strategy (§6-§12)](#ii-patent-strategy-6-12)
- [III. Trade Secrets & Confidential Information (§13-§16)](#iii-trade-secrets--confidential-information-13-16)
- [IV. Trademarks, Branding & Domains (§17-§19)](#iv-trademarks-branding--domains-17-19)
- [V. Copyright & Data Rights (§20-§22)](#v-copyright--data-rights-20-22)
- [VI. AI-Generated IP (§23-§26)](#vi-ai-generated-ip-23-26)
- [VII. Exit Strategy Foundation (§27-§34)](#vii-exit-strategy-foundation-27-34)
- [VIII. Due Diligence Operations (§35-§41)](#viii-due-diligence-operations-35-41)
- [IX. Governance & Ongoing Management (§42-§47)](#ix-governance--ongoing-management-42-47)
- [X. Compliance & Timeline (§48-§50)](#x-compliance--timeline-48-50)
- [XI. Geopolitical Risk & Export Controls (§51)](#xi-geopolitical-risk--export-controls-51)
- [XII. GenAI Supply Chain IP Governance (§52)](#xii-genai-supply-chain-ip-governance-52)
- [XIII. IP Monetization Strategy (§53)](#xiii-ip-monetization-strategy-53)
- [XIV. Antitrust & IP (§54)](#xiv-antitrust--ip-54)
- [XV. VC Fundraising & IP Milestones (§55)](#xv-vc-fundraising--ip-milestones-55)
- [XVI. IP Automation Under EU AI Act Full Enforcement (§56)](#xvi-ip-automation-under-eu-ai-act-full-enforcement-56)
- [XVII. Clean Tech & Carbon Credit IP (§57)](#xvii-clean-tech--carbon-credit-ip-57)
- [XVIII. IP Litigation Finance (§58)](#xviii-ip-litigation-finance-58)
- [XIX. Layered IP Protection Strategy (§59)](#xix-layered-ip-protection-strategy-59)
- [XX. Sovereign IP & National Security (§60)](#xx-sovereign-ip--national-security-60)
- [XXI. IP-Centric Deal Architecture (§61)](#xxi-ip-centric-deal-architecture-61)
- [Appendix A: Quick Reference Index](#appendix-a-quick-reference-index)
- [Appendix B: Global Jurisdiction IP Protection Matrix](#appendix-b-global-jurisdiction-ip-protection-matrix)

---

# I. IP Ownership & Rights Attribution (§1-§5)

---

## §1. Fundamental Principles of IP Ownership

### Rule 63.001: Work for Hire Clarification
- **Mandatory**: Employment policies must explicitly state that all deliverables created during employment (source code, design docs, algorithms, trained models, etc.) are **Work for Hire**
- **Day-1 onboarding**: The following must be executed on the first day of employment:
  - **IP Assignment Agreement**
  - **Prior Invention Disclosure**: List and exclude pre-existing inventions
  - **NDA**: Confidentiality obligations during and after employment

### Rule 63.002: Completeness of IP Assignment (Global Jurisdictions)
- Explicitly state that all copyrights, inventions, designs, and database rights vest in the legal entity
- **Territoriality compliance**: Use IP assignment clauses valid in each jurisdiction:
  - **US**: Work for Hire Doctrine + Assignment Agreement (note state-specific exclusions like California Labor Code §2870)
  - **EU**: Respect moral rights per member state (e.g., Germany UrhG §7: no waiver; France Code IP L.121-1: same)
  - **China**: Copyright Law §18 + Patent Law §6 — explicit contract recommended for corporate ownership
  - **India**: Patents Act §§19-21 — explicit assignment in employment contract required

### Rule 63.003: Compensation & Reward Systems
- Establish internal rules for calculating **reasonable compensation** for employee inventions where required by local statute (e.g., Germany ArbEG)
- Design invention reward programs: staged rewards at filing, registration, and commercialization
- Ensure transparency in the calculation process to mitigate compensation disputes
- **China**: Comply with minimum compensation standards (Patent Law Implementation Rules §77-78)

---

## §2. Contributor Rights Management

### Rule 63.010: CLA (Contributor License Agreement) Mandate
- External contributors (freelancers, contractors, side-job engineers) must sign a CLA before any code submission
- **CLA type selection**:
  - **Individual CLA**: For individual contributors
  - **Corporate CLA**: For corporation-affiliated contributors (requires company approval)
- CLA management: Deploy CLA Assistant (GitHub App) with OIDC-linked auto-verification on PRs

### Rule 63.011: IP Clauses in Contractor Agreements
- **Mandatory clause checklist**:
  - [ ] Explicit IP ownership attribution to the commissioning party
  - [ ] Moral rights non-assertion covenant (where jurisdictionally valid)
  - [ ] Third-Party IP Warranty (no unauthorized IP usage)
  - [ ] AI-generated code usage disclosure obligation
  - [ ] Source code and design document delivery obligation
  - [ ] Confidentiality obligation (explicit survival period: min 3 years; trade secrets: indefinite)
  - [ ] Non-compete clause (reasonable scope — note: generally unenforceable in California)

### Rule 63.012: OSS Contribution Policy
- Establish policy for engineers contributing to OSS during business hours
- **Approval flow**: Manager + Legal pre-approval required
- Review procedures to prevent proprietary code or trade secrets from leaking into OSS
- **Inbound/Outbound separation**: Verify alignment between inbound OSS licenses and outbound licenses granted

---

## §3. Joint Development & JV IP Arrangements

### Rule 63.020: Background IP / Foreground IP Separation
- **Background IP**: Pre-existing IP each party holds → remains with original owner
- **Foreground IP**: Newly created IP from joint development → pre-determine ownership in contract
- **Sideground IP**: IP independently developed by one party related to the project → belongs to developer
- **Improvement IP**: Improvements to Background IP → pre-agree ownership and license terms

### Rule 63.021: Joint IP Management Contract Requirements
- **Mandatory provisions**:
  - Inventorship criteria (per each jurisdiction's requirements)
  - Patent filing cost allocation and decision-making process
  - License granting terms (including sublicense rights)
  - Post-collaboration IP usage restrictions and license-back
  - Dispute resolution (jurisdiction, governing law, ADR-first clause)
  - Treatment of joint IP during IPO/M&A (ROFR/ROFO provisions)

---

## §4. IP Protection at Employee Departure

### Rule 63.030: Departure Checklist (IP Perspective)
- [ ] Complete all invention disclosures before departure date
- [ ] Immediately revoke access to company-owned code, documents, and data
- [ ] Confirm deletion of company data from personal devices (MDM/DLP integration + deletion certificate)
- [ ] Obtain written reconfirmation of post-employment confidentiality obligations
- [ ] Confirm scope and duration of non-compete and non-solicitation clauses
- [ ] Deactivate AI Copilot/LLM tool business accounts (prevent internal info leakage into training data)
- [ ] Preserve Git history and code review records (evidence of departing employee's contribution scope)

### Rule 63.031: Garden Leave
- Consider garden leave clauses (3-6 months) for key personnel handling sensitive technology
- **Jurisdiction-specific validity**:
  - US California: Non-competes generally unenforceable (Bus. & Prof. Code §16600) → use Garden Leave
  - US other states: Enforceable within reasonable scope (time, geography, industry)
  - EU: Varies by member state (Germany: HGB §74 ff.; France: compensation mandatory)

---

## §5. Automated IP Rights Attribution Audit

### Rule 63.040: Automated Audit Mechanisms (CI/CD Integration)
- **Commit signature verification**: Mandate `Signed-off-by` on all commits (DCO: Developer Certificate of Origin)
- **CLA verification gate**: Auto-check CLA signatures on PR creation; block merge for unsigned PRs

```yaml
# GitHub Actions: CLA Check Example
name: CLA Check
on: [pull_request]
jobs:
  cla-check:
    runs-on: ubuntu-latest
    steps:
      - uses: contributor-assistant/github-action@v2
        with:
          path-to-signatures: 'signatures/cla.json'
          branch: 'main'
          remote-organization-name: 'your-org'
```

### Rule 63.041: Periodic IP Audits
- **Quarterly** audits covering:
  - IP assignment agreement completion status for new hires
  - IP clause adequacy in contractor agreements
  - Detection of unsigned CLA contributions
  - OSS usage and license compliance (→ see [602_oss_compliance.md](../security/200_oss_compliance.md))
  - AI-generated code usage status and rights attribution record verification

---

# II. Patent Strategy (§6-§12)

---

## §6. Patent Filing vs. Trade Secret Decision Framework

### Rule 63.050: Decision Matrix

| Criterion | Choose Patent Filing | Choose Trade Secret |
|---|---|---|
| **Reverse Engineering** | Easy (hardware/UI) | Difficult (server-side algorithms) |
| **Technology Lifespan** | Long-term (20+ years useful) | Short-term (rapid obsolescence) |
| **Competitor Imitation Risk** | High | Low (only feasible internally) |
| **Protection Period** | 20 years (patent right) | Indefinite (as long as secrecy is maintained) |
| **Disclosure** | Publishable | Must remain confidential (Secret Sauce) |
| **Enforcement** | Enforceable via litigation | Difficult to prove upon leakage |
| **Cost** | High filing & maintenance costs | Primarily management costs |
| **AI Training Risk** | Risk of inclusion in AI training data after publication | Low risk as information remains undisclosed |

### Rule 63.051: Decision Process
1. Submit Invention Disclosure Form
2. Review by Patent Committee
3. Determination based on above matrix
4. Preserve decision records (especially access restriction records when trade secret is chosen)
5. **Periodic re-evaluation**: Consider strategic shift from trade secret → patent filing as technology landscape evolves

---

## §7. Defensive Patent Strategy

### Rule 63.060: Defensive Publishing
- Instead of filing everything, **prevent competitors from patenting** by publishing as prior art via tech blogs, academic papers, preprint servers
- **Recommended publication channels**:
  - Company engineering blog
  - arXiv / SSRN preprint servers
  - Linux Foundation Defensive Publication Program
  - IP.com Prior Art Database
- Secure evidence of publication date (timestamped archives, Wayback Machine registration)

### Rule 63.061: Defensive Patent License (DPL) / LOT Network
- **DPL**: Mutual non-aggression pact — no patent litigation among DPL participants
- **LOT Network**: Automatic license grant to member companies if a patent is transferred to a PAE
- **Open Invention Network (OIN)**: Linux-related patent mutual non-aggression (2,000+ participating companies)
- Strongly recommended for startups and SMEs

### Rule 63.062: Patent Non-Infringement Insurance
- Consider **IP insurance** as a defense against patent litigation (especially PAE/NPE suits)
- **Coverage**: Litigation costs, settlement payments, license fees (→ §45 IP Insurance for details)

---

## §8. Patent Portfolio Management

### Rule 63.070: Periodic Portfolio Audit
- **Annual audit items**:
  - Alignment of each patent with active products/services (mapping)
  - Cost-effectiveness evaluation → Pruning decisions for unnecessary patents
  - Gap analysis vs. competitor portfolios
  - Geographic coverage evaluation (filing status in key markets)
  - **AI-powered portfolio analysis**: Quantitative assessment using Patsnap / Clarivate / LexisNexis PatentSight

### Rule 63.071: Portfolio Visualization
- Create annual Patent Landscape Maps
- Overview of held patents via technology domain × business domain matrix
- **Heat map analysis**: Visualization of patent density by technology cluster and competitor comparison

### Rule 63.072: Continuation Strategy
- Leverage Divisional / Continuation / CIP (Continuation-in-Part) applications for core inventions
- Maximize protection scope through claim broadening and defensive claim additions
- **Portfolio balance**: Maintain balance between offensive patents (monetization/licensing) and defensive patents (FTO)

---

## §9. Standard Essential Patents (SEP) & FRAND

### Rule 63.080: Obligations upon SEP Declaration
- When submitting technical proposals to standards bodies (ETSI, IEEE, IETF, etc.), sincerely disclose SEP applicability
- **FRAND terms**: Obligation to license under Fair, Reasonable, And Non-Discriminatory conditions

### Rule 63.081: EU SEP Regulation Developments (2025 Latest)
- **EU SEP Regulation withdrawn**: October 2025, the European Commission formally withdrew the proposal citing "no foreseeable agreement"
- Key provisions of the withdrawn proposal (potential re-proposal):
  - SEP register (under EUIPO)
  - Essentiality checks
  - Expert opinions on aggregate royalty
  - Conciliation process for FRAND determination
- **UPC PMAC**: Patent Mediation and Arbitration Centre launched website in late 2025 as dedicated SEP dispute forum — monitor developments
- **Strategic response**: Prepare for regulatory uncertainty by maintaining documented SEP licensing programs and FRAND rate justification materials

### Rule 63.082: IP Policy for Standards Participation
- Establish internal IP policy before joining standards bodies
- Engineer training: Relationship between statements at standardization meetings and patent enforcement
- **Anti-Hold-Up / Anti-Hold-Out**: Understand obligations of both licensors and licensees for fair negotiations

---

## §10. Software Patent Special Considerations

### Rule 63.090: Patentability Analysis (US)
- **Alice/Mayo Test (2-step analysis)**:
  - Step 1: Is the claim directed to an abstract idea, law of nature, or natural phenomenon?
  - Step 2: Does the claim contain an "inventive concept" — additional elements beyond the abstract idea?
- **Strategy**: Clearly recite Technical Improvement in claims:
  - Computational resource efficiency gains (memory reduction, processing speed improvement)
  - Technical effects through specific hardware integration
  - Technical solutions to specific technical problems in prior art

### Rule 63.091: Software Patents in Europe & Global
- **Global Considerations**: Ensure claims satisfy technical requirements of targeted jurisdictions (e.g., hardware resource utilization or natural law utilization)
- **Europe (EPO)**: "Further Technical Effect" argument is critical — COMVIK approach applied
- **UPC**: Launched June 2023 → consider leveraging Unitary Patent (→ §12 for details)

---

## §11. Design Patent Strategy

### Rule 63.095: Strategic Use of Design Rights
- **Protected subject matter**: GUI/UI designs, icons, fonts, product appearance, packaging
- **Dual protection with patents**: Protect technical inventions via patents, appearance/UI via design rights
- **Filing strategy**:
  - **US**: Design Patent (35 USC §171) — 15-year protection, no maintenance fees
  - **EU**: Registered Community Design (RCD) via EUIPO; 3-year Unregistered Community Design (UCD)
  - **Hague Agreement**: International filing to cover multiple jurisdictions simultaneously

### Rule 63.096: GUI/UI Design Protection Best Practices
- **Documentation habits**: Record creation date, creator, and version history of designs
- **File before publication**: File UI design applications before public disclosure (novelty requirement — especially EU & China)
- **Partial designs**: File characteristic UI elements as partial designs to optimize claim scope
- **Animation/transitions**: Consider dynamic designs and Animated Design Patents (US)

---

## §12. EU Unitary Patent (UP) & Unified Patent Court (UPC) Practice

### Rule 63.098: UPC Overview and Strategic Use
- **Launched June 2023**: 18 participating countries covering ~80% of EU GDP
- **As of Feb 2025**: 48,000+ UPs registered, 752 cases filed
- **Benefits**:
  - Single filing for patent protection across up to 25 countries
  - Pan-European injunctions available
  - Dedicated SEP dispute forum (PMAC)
- **Risks**:
  - Single invalidity decision revokes protection across all participating states (Central Revocation)
  - Long-arm jurisdiction risk (BSH v Electrolux, 2025 CJEU ruling)

### Rule 63.099: Opt-out Strategy
- **Transitional period (~2030)**: Opt-out from UPC jurisdiction available for existing classical European patents
- **Decision criteria**:
  - **Opt-out preferred**: Avoid Central Revocation risk for critical patents
  - **Stay in UPC**: When pan-European enforcement is desired
- **Sunrise Period**: Opt-outs are reversible, but once litigation is initiated on the patent, changes are impossible
- **Costs**: UPC court fees increase by average 33% from January 2026 — factor into cost estimates

---

# III. Trade Secrets & Confidential Information (§13-§16)

---

## §13. Trade Secret Definition & Protection Framework

### Rule 63.100: Three Requirements for Trade Secrets
- All three requirements must be met for legal protection:
  1. **Secrecy management**: Access controls, "Confidential" markings, etc.
  2. **Usefulness**: Technically or commercially useful information for business activities
  3. **Non-public knowledge**: Information not publicly known

### Rule 63.101: Technical Controls
- **Access control**:
  - Manage Secret Sauce source code in isolated repositories; grant access on Need-to-Know basis
  - Minimum-privilege access via IAM roles
  - Retain access audit trails for minimum 7 years
- **Encryption**:
  - At-rest encryption (AES-256+)
  - In-transit encryption (TLS 1.3)
  - Key management via HSM/KMS
- **DLP (Data Loss Prevention)**:
  - Detect and block clipboard/external transfer of confidential code
  - Control confidential file uploads to email/cloud storage
  - Detect and block pasting of confidential code to AI Copilot/ChatGPT and other LLMs

### Rule 63.102: Legal Basis for Protection
- **US**: Defend Trade Secrets Act (DTSA, 2016) + state laws (UTSA)
  - **DTSA Whistleblower Immunity**: All contracts after May 11, 2016 must include immunity notice (18 USC §1833(b))
- **EU**: Trade Secrets Directive (2016/943) — transposition completed across member states
- **China**: Anti-Unfair Competition Law — reversal of burden of proof for trade secret misappropriation (2019 amendment)
- Pre-identify procedural requirements in each jurisdiction (evidence preservation, preliminary injunction requirements)

---

## §14. NDA Management

### Rule 63.110: Standard NDA Templates
- **Mutual NDA**: When both parties disclose confidential information
- **One-Way NDA**: When only one party discloses (primarily recruitment interviews, investor DD)
- **Mandatory clauses**:
  - [ ] Definition of confidential information (comprehensive vs. enumerated)
  - [ ] Exclusions (publicly known, independently developed, lawfully obtained from third parties)
  - [ ] Confidentiality period (minimum 3 years; indefinite recommended for trade secrets)
  - [ ] Limitation of disclosure purpose
  - [ ] Return/Destroy clause (post-termination return/destruction obligation + destruction certificate)
  - [ ] Equitable relief clause (express right to injunctive relief)
  - [ ] Governing law and dispute resolution (jurisdiction/arbitration)
  - [ ] **AI tool input prohibition**: Explicitly prohibit use of confidential information as input data for AI/LLMs

### Rule 63.111: NDA Lifecycle Management
- Centralized management via CLM (Contract Lifecycle Management) tools
- NDA expiration alerts (90 days / 30 days prior)
- Annual inventory: Clean up expired/unnecessary NDAs

---

## §15. Trade Secret Protection in Remote Work Environments

### Rule 63.120: Remote Work-Specific Risk Countermeasures
- **Physical security**:
  - Mandatory screen privacy filters
  - Prohibit public Wi-Fi use (VPN mandatory)
  - Awareness training for screen sharing and eavesdropping risks at home
- **Technical controls**:
  - VDI (Virtual Desktop Infrastructure) for accessing confidential code
  - Mandatory MDM/MAM for BYOD devices
  - Prohibit local storage of confidential information
  - Screen capture/recording restrictions (DRM integration)
- **Procedural controls**:
  - Obtain remote work pledge at initiation
  - Mandatory annual information security training
  - Home office security audit (self-assessment checklist)

---

## §16. Trade Secret Risks in GenAI Environments

### Rule 63.125: Confidential Information Leakage to AI/LLMs
- **Risk scenarios**:
  - Engineers pasting proprietary code into AI Copilot/ChatGPT for code improvement
  - Sales staff inputting customer lists and pricing strategies into LLMs for analysis
  - Executives inputting M&A strategies and business plans into AI for review
- **Redefining "reasonable measures"**: In the AI era, DTSA/Unfair Competition "reasonable measures" are interpreted to include LLM input controls (2025 case law trends)

### Rule 63.126: GenAI Trade Secret Protection Policy
- **Tier 1 (Prohibited)**: Trade secrets/Secret Sauce — complete ban on input to external AI services
- **Tier 2 (Restricted)**: Confidential information — permitted only via Enterprise API (services contractually committed to not training on data)
- **Tier 3 (Permitted)**: Public information and general code patterns — no restrictions
- **Technical controls**:
  - AI gateway proxy (Nightfall AI / Harmonic Security) for real-time detection and blocking
  - Endpoint DLP extension (AI web app data transmission monitoring)
  - Promote on-premises LLM/internal model usage (avoid external transmission of confidential data)

```yaml
# DLP Policy: AI Service Upload Detection
rules:
  - name: "Block Trade Secret Upload to AI"
    condition:
      destination_domains:
        - "api.openai.com"
        - "generativelanguage.googleapis.com"
        - "api.anthropic.com"
      content_classification: ["TRADE_SECRET", "CONFIDENTIAL"]
    action: BLOCK
    notification: security-team@company.com
```

---

# IV. Trademarks, Branding & Domains (§17-§19)

---

## §17. Trademark Strategy & Filing Management

### Rule 63.130: Trademark Filing Principles
- **Filing timing**: File before public launch once product/service name is finalized
- **Pre-filing searches**:
  - Search national trademark databases (USPTO TESS, EUIPO TMview, WIPO Global Brand Database)
  - Confirm Common Law Rights (US)
  - AI-powered trademark search tools (TrademarkVision / Corsearch AI) for image similarity checks
- **International filing**:
  - Leverage Madrid Protocol for consolidated filing
  - Prioritize target markets; cover at least 5 major markets
  - **Nice Classification**: Comprehensively designate relevant classes (especially software: Class 9, SaaS: Class 42)

### Rule 63.131: Trademark Monitoring & Usage Management
- **Brand monitoring services**: Auto-monitor new filings and domain registrations (CompuMark / Corsearch / TrademarkNow)
- **Usage evidence management**:
  - Periodically save timestamped screenshots of trademark use (ads, packaging, web)
  - Prepare for non-use cancellation trials (typically 3-5 years non-use depending on jurisdiction)
  - US: Manage Section 8/9 Affidavit deadlines (years 5-6 and 9-10 post-registration)

### Rule 63.132: Brand Guidelines Internal Deployment
- Include IP protection in brand guidelines:
  - Correct ™/® mark usage
  - License terms for third-party trademark usage
  - Genericide prevention (always use as adjective, never as verb)

---

## §18. Brand Protection & Enforcement

### Rule 63.140: Counterfeit & Infringement Response
- **Online infringement response**:
  - Register with platform brand protection programs (Amazon Brand Registry, Google Brand Shield, Meta Brand Rights Protection)
  - Rapid DMCA takedown response capability
  - AI-generated brand imitation content detection
- **Offline infringement response**:
  - Customs registration (e.g., US PROTECT Act) for border measures
  - Cease & Desist letters as appropriate

### Rule 63.141: Domain Dispute Resolution
- **UDRP**: WIPO arbitration for bad-faith domain registrations
- **ccTLD DRPs**: Country code specific dispute resolution policies
- **URS (Uniform Rapid Suspension System)**: Faster provisional suspension than UDRP
- Consider preemptive acquisition of key TLDs against cybersquatting

---

## §19. Domain Names & Digital Asset Management

### Rule 63.150: Domain Portfolio Management
- **Core domains**: Manage business domains (`.com`, `.co.jp`, `.io`) under company name
- **Defensive acquisition**: Similar domains (typosquatting defense), key ccTLDs
- **DNS Security**:
  - DNSSEC implementation
  - Registrar Lock (Transfer Lock) activation
  - 2FA/MFA for registrar account protection
  - Multi-registrar consolidation (MarkMonitor / CSC Digital Brand Services)

### Rule 63.151: Digital Asset Management
- Inventory and ownership management for social media accounts, app store accounts, API keys
- Centralized credential management (password manager + MFA)
- Immediate access revocation procedures for departing employees
- **Digital asset ledger**: Record all digital assets (SNS, store accounts, crypto keys, certificates) in a centralized ledger

---

# V. Copyright & Data Rights (§20-§22)

---

## §20. Copyright Registration Strategy

### Rule 63.155: Strategic Use of Copyright Registration
- **US (USCO)**:
  - Copyright registration is a **prerequisite for litigation** (17 USC §411(a)) — cannot file in federal court without registration
  - **Statutory Damages** availability depends on registration timing:
    - Registered before infringement OR within 3 months of publication → statutory damages (up to $150,000/work) + attorney's fees
    - Registered after infringement → actual damages only
  - Software copyright registration: Submit first/last 25 pages of source code (redaction available for trade secret portions)
- **International**: Berne Convention no-formality principle is standard, but strategic registration is recommended in key jurisdictions for enhanced enforcement capabilities and evidentiary presumption.

### Rule 63.156: Software Copyright & Code Protection
- **Protection scope**: Source code and object code protected as copyrighted works (API structure contested per Oracle v. Google)
- **Copyright vs. patent**: Algorithms and functional aspects not protectable by copyright → consider patent protection
- **Code convention documentation**: Maintain evidence of originality and creativity in proprietary coding styles

---

## §21. Data Rights & Database Rights

### Rule 63.160: Legal Protection for Data
- **EU sui generis database right**: Protection for databases with substantial investment (Directive 96/9/EC) — 15 years
- **EU Data Act (enforcement begins 2024)**: IoT data access rights and data portability obligations
  - Switching cost reduction obligations for data holders
  - Public authority data access rights (emergencies)
  - Regulation of unfair contractual terms
- **China**: Data Security Law (DSL) + PIPL data management rights
- **Data property rights**: Most jurisdictions do not recognize ownership of data per se; indirect protection via contract, trade secrets, and database rights

### Rule 63.161: Data Licensing & Monetization
- **Data license agreement mandatory clauses**:
  - Purpose limitation (explicitly state whether AI training is included)
  - Redistribution/secondary use restrictions
  - Data quality warranty level
  - Data protection clauses if personal data included (e.g., GDPR compliant)
  - Data return/deletion obligation upon contract termination
- **Data marketplaces**: License design for Snowflake Marketplace / AWS Data Exchange sales

---

## §22. IP Tokenization, NFTs & Blockchain

### Rule 63.165: IP Tokenization Overview & Strategy
- **IP tokenization**: Representing patents, trademarks, and copyrights as blockchain tokens for efficient trading and management
- **Key use cases**:
  - **Fractional IP ownership**: Tokenize patent shares enabling co-investment by multiple investors
  - **Automated royalty distribution**: Smart contract-based automatic license income distribution
  - **IP provenance**: Immutable ownership history tracking on blockchain
  - **IP-backed financing**: Using tokenized IP as collateral (→ §41 IP-backed Financing)

### Rule 63.166: NFTs & IP Protection
- **NFTs and copyright**: NFT purchase does NOT constitute copyright transfer — purchasers typically acquire "limited license"
- **NFT license design**:
  - Explicit commercial use rights scope (CC0 / Creative Commons-based or NFT License 2.0)
  - Automatic secondary sale royalties (ERC-2981 standard)
  - Derivative work creation permissions
- **Risk management**:
  - Verify original author's rights for NFT-ized works
  - Legal risks of wash trading and market manipulation
  - Comply with crypto-asset regulations per jurisdiction (e.g., EU: MiCA)

### Rule 63.167: Future of Blockchain IP Management
- **On-chain IP registries**: WIPO/EPO research programs on blockchain-based patent/trademark registries
- **C2PA**: Convergence of AI-generated content provenance and blockchain
- **Market size**: Tokenized asset market projected at $30T by 2034 — early IP strategy development builds competitive advantage

---

# VI. AI-Generated IP (§23-§26)

---

## §23. Copyright in AI-Generated Content

### Rule 63.170: Human Authorship Principle
- **US (USCO January 2025 Part 2 Report)**:
  - Copyright does not arise for content generated solely by AI
  - Copyright recognized only when humans sufficiently determine expressive elements
  - Prompt input alone is **insufficient** — creative judgment in selection, arrangement, editing, modification required
  - **Disclosure obligation** when registering works containing AI-generated material
  - AI-generated portions exceeding de minimis must be explicitly excluded
  - Existing copyright law principles deemed sufficient; no new legislation endorsed
- **EU (AI Act + Copyright Directive)**: AI-generated content labeling obligation, training data copyright respect/opt-out compliance
- **International Trend**: Copyright typically recognized only when AI is used merely as an assisting "tool" and a human makes creative contributions.
- **Case law**: Thaler v. Perlmutter (2023 final) — AI cannot be registered as sole author

### Rule 63.171: Internal Guidelines for AI-Generated Content
- For deliverables requiring copyright (marketing materials, brand assets): humans must exercise substantial creative judgment with documentation
- **Required documentation**:
  - Creative choices made by humans (prompt design, output selection, editing, arrangement, composition)
  - Human modifications to AI output (quantitative change tracking)
  - AI tool/model name/version used
  - Demarcation of human-created vs. AI-generated portions in final deliverable
- Reinforce via internal training that prompts alone are insufficient for copyright claims

### Rule 63.172: Third-Party Copyright Infringement Risk from AI Output
- Countermeasures for AI reproducing copyrighted works from training data:
  - Deploy similarity checking tools (plagiarism detection, image similarity search)
  - Conduct copyright clearance for high-risk uses (commercial publications, advertising)
  - Review AI tool ToS for output ownership and indemnification
- **2025 Fair Use case law trends**: AI training on legally acquired copyrighted works → likely fair use; training on pirated data → fair use denial trend

---

## §24. Patent Filing for AI-Assisted Inventions

### Rule 63.175: Human Inventorship Requirements
- **USPTO November 2025 Revised Guidance**:
  - Explicitly rescinds February 2024 guidance
  - AI systems cannot be named as inventors (natural persons only)
  - AI systems positioned as "tools" equivalent to lab instruments/software
  - Traditional Pannu factors do not apply to AI-assisted inventions under new framework
  - Human **significant contribution** to the "conception" of the invention is required
  - Duty of Candor compliance in AI utilization — appropriately disclose AI assistance
- **Europe**: EPO rejected AI as sole inventor in Dabus decision (2025 final)
- **General Consensus**: Inventors are limited to natural persons across nearly all major jurisdictions.

### Rule 63.176: AI-Assisted Invention Filing Strategy
- **Documentation obligation**: Detailed recording in invention notebooks of which stages AI was used vs. human creative judgment
- **Claim design**: Focus on processes utilizing AI and results of human selection/improvement of AI output, not the AI model itself
- **Disclosure obligation**: Properly disclose AI use when filing in each country (concealment risks later invalidation)
- **AI invention notebook template**:
  - Technical problem definition (set by human)
  - AI model/tool selection rationale (judged by human)
  - Input parameters/conditions to AI (designed by human)
  - AI output evaluation/selection criteria (determined by human)
  - Selected output refinement/optimization (performed by human)

### Rule 63.177: Patent Eligibility of AI-Generated Code
- When filing software inventions containing AI-generated code:
  - Frame claims as technical solutions to technical problems, not the code itself
  - Clearly delineate AI-generated vs. human-designed portions
  - Confirm from licensing risk perspective (→ see [602_oss_compliance.md](../security/200_oss_compliance.md) AI-generated code section)

---

## §25. Training Data Rights Clearance

### Rule 63.180: IP Management for Training Data
- **Copyright clearance**:
  - License verification when training data includes third-party copyrighted works
  - EU AI Act: General-purpose AI model providers must disclose training data summaries (full enforcement August 2026)
  - Verify applicability of local copyright exceptions for text and data mining (TDM)
- **Opt-out compliance**:
  - `robots.txt` `ai` directive, `ai.txt` (C2PA-compatible) for crawling control
  - TDM opt-out compliance (EU DSM Directive Article 4)
- **Data provenance tracking**:
  - Maintain data catalog recording licenses, sources, and versions of training datasets
  - C2PA preparation
  - **Model Cards / Data Sheets**: Document model training data composition and licensing status

---

## §26. AI-Generated IP Governance Framework

### Rule 63.185: Organizational AI-IP Governance
- **AI-IP Committee**: Cross-functional team (Legal + Engineering + Business) for decision-making
- **AI-IP Policy mandatory elements**:
  - Approved AI Tool List management
  - Risk tiering by use case (copyright needed vs. internal use only vs. not needed)
  - Default IP attribution rules for AI-generated output (default: corporate ownership)
  - AI usage recording and audit framework
  - Incident response (escalation flow when AI output infringes third-party IP)

### Rule 63.186: AI-IP Risk Tiering Matrix

| Risk Level | Use Case Examples | Copyright Needed | Human Creativity Requirement | Documentation |
|---|---|---|---|---|
| **High** | Brand assets, ad materials, commercial publications | Required | Substantial human creative judgment | Detailed records mandatory |
| **Medium** | Internal presentations, documents, prototypes | Recommended | Editing/selection level involvement | Summary records |
| **Low** | Code completion, test data generation, internal analysis | Not needed | AI-led acceptable | Tool name only |

---

# VII. Exit Strategy Foundation (§27-§34)

---

## §27. Exit Types & Selection

### Rule 63.190: Exit Type Comparison Framework

| Exit Type | Characteristics | IP Significance | Preparation Period |
|---|---|---|---|
| **M&A (Acquisition)** | Most common. Business synergy is key | ★★★★★ | 12-24 months |
| **IPO** | Maximum fundraising. High regulatory compliance cost | ★★★★☆ | 18-36 months |
| **SPAC** | Faster IPO alternative. Tightening SEC regulation | ★★★★☆ | 6-12 months |
| **Direct Listing** | No underwriting. Existing shareholders sell directly | ★★★★☆ | 12-18 months |
| **Secondary Sale** | Partial liquidity for existing shareholders | ★★★☆☆ | 3-6 months |
| **IP Licensing** | IP-only monetization | ★★★★★ | Negotiation-dependent |
| **Acqui-hire** | Talent acquisition as primary purpose | ★★☆☆☆ | 1-3 months |

### Rule 63.191: Exit Strategy & IP Readiness Alignment
- **M&A**: Acquirers prioritize IP completeness and exclusivity → thorough IP DD essential
- **IPO**: IP risk disclosure required for financial regulators (e.g., SEC) → accurate risk factor descriptions
- **SPAC**: SEC 2024 final rules require IPO-equivalent disclosures → Target co-registrant liability (→ §32)
- **Direct Listing**: No underwriter due diligence; voluntary IP risk disclosure even more critical
- For tech companies where 80%+ of value resides in intangible assets, IP valuation is the core of deal valuation

---

## §28. IP Asset Valuation

### Rule 63.200: Valuation Methods Overview

| Method | Overview | Application | Accuracy |
|---|---|---|---|
| **Cost Approach** | Calculate actual cost of IP development (replacement cost) | Early-stage, internal reference | Low-Medium |
| **Income Approach (DCF)** | Calculate discounted present value of future IP-generated revenues | IPs with revenue track record | Medium-High |
| **Market Approach** | Reference comparable IP transactions and royalty rates | When comparable cases exist | Medium |
| **Hybrid Approach** | Combination of above (2025 best practice recommendation) | Complex IP portfolios | High |
| **Real Options** | Flexible valuation considering future uncertainty | Research-stage IP, AI/quantum | Medium-High |

### Rule 63.201: Valuation Execution Requirements
- **Timing**: Exit preparation, fundraising rounds, annual IP inventory
- **External expert involvement**: Recommend third-party IP specialists (CPAs, patent attorneys, IP consultants)
- **AI tool utilization**: Quantitative assessment via Patsnap / Clarivate / LexisNexis PatentSight / IPlytics

### Rule 63.202: Royalty Rate Benchmarks
- Reference industry-standard royalty rates:
  - Software: 10-20%
  - Semiconductors: 3-5%
  - Pharmaceuticals: 15-25%
  - SaaS/Cloud: 15-30%
  - AI/ML Models: 10-25% (emerging field, building precedent)
- **25% Rule**: Rule of thumb allocating 25% of profit to royalties (use as supplementary reference; multi-factor analysis preferred)

---

## §29. Exit Readiness Roadmap

### Rule 63.210: Timeline

| Timing | Action |
|---|---|
| **24 months prior** | Conduct IP audit, establish IP ledger, inventory technical debt |
| **18 months prior** | File unfiled key inventions, international trademark filing, initial IP valuation |
| **12 months prior** | Begin data room construction, VDR setup |
| **9 months prior** | Complete OSS/license audit (→ see [602_oss_compliance.md](../security/200_oss_compliance.md)) |
| **6 months prior** | Conduct Mock Due Diligence, pre-create technical DD report |
| **3 months prior** | Final data room update, draft IP representations & warranties |
| **Pre-Exit** | Final IP inventory, confirm resolution of all open IP issues |

### Rule 63.211: Exit Ready Scorecard

```markdown
## IP Exit Readiness Scorecard
| Item | Status | Completion Criteria |
|---|---|---|
| IP Assignment Agreements | ☐ | All employees/contractors completed |
| Patent Portfolio Organization | ☐ | Unnecessary patents pruned |
| Trademark Registration | ☐ | Registration complete in key markets |
| Design Registration | ☐ | Key GUI/UI design protection complete |
| Copyright Registration (US) | ☐ | Key software USCO registration complete |
| OSS/License Audit | ☐ | SCA results clean |
| SBOM Generation | ☐ | Auto-generated in CycloneDX/SPDX format |
| Security Audit | ☐ | Penetration test within last 6 months |
| Data Room Construction | ☐ | All documents instantly accessible via VDR |
| IP Valuation Report | ☐ | External expert valuation complete |
| IP Insurance | ☐ | Obtained as needed |
| AI-IP Audit | ☐ | AI-generated code usage scope and rights confirmed |
```

---

## §30. IP Negotiation in M&A

### Rule 63.220: IP Representations & Warranties
- **Seller warranties**:
  - Lawful ownership of all IP
  - No infringement of third-party IP
  - All IP assignment agreements are valid and effective
  - No pending IP litigation
  - Full compliance with OSS licenses
  - No unauthorized access to material trade secrets
  - AI-generated code usage scope and rights attribution are clear
  - Compliance with global data privacy regulations (e.g., GDPR, CCPA)

### Rule 63.221: Indemnification
- Damages clause for discovered IP infringement
- **Basket**: Small claim filtering (De Minimis / Basket)
- **Cap**: Maximum indemnification amount (typically 10-20% of purchase price; consider special IP cap)
- **Escrow**: Hold portion of purchase price in escrow (typically 12-24 months)
- **Earnout**: Additional consideration based on IP monetization performance

### Rule 63.222: Change of Control Provisions
- When existing license agreements contain change of control provisions:
  - Pre-assess risk of contract termination/renegotiation upon M&A
  - Confirm assignability of critical third-party licenses
  - Review change of control provisions in cloud service agreements (AWS/GCP/Azure)

---

## §31. IPO IP Disclosure Requirements

### Rule 63.230: SEC IP Disclosure (US Listing)
- **Form S-1 (Registration Statement)**:
  - IP rights overview (patents, trademarks, copyrights, trade secrets — count and significance)
  - IP-related risk factors (infringement risk, patent expiration, dependency)
  - Pending/potential IP litigation disclosure
  - OSS usage and related risks
  - AI technology usage and IP attribution risks
  - IP theft/unauthorized access risks in foreign operations (especially China, Russia)
- **Ongoing disclosure**: Periodic IP risk updates in 10-K/10-Q
- **Actual IP compromise**: Hypothetical risk disclosure insufficient when IP has been materially compromised — must describe specific events and consequences

### Rule 63.231: JFSA IP Disclosure (Japan Listing)
- **Securities Registration Statement**:
  - IP overview and business significance
  - Technology risk disclosure
  - Degree of dependency on third-party IP
- **IP Investment & Utilization Strategy Disclosure Guidance** (Cabinet Office 2023)
- **Integrated report**: Recommended disclosure of IP KPIs (filing count, license revenue, IP investment)

---

## §32. SPAC/De-SPAC IP Disclosure

### Rule 63.235: SEC 2024 Final Rules (Subpart 1600)
- **Adopted January 2024**: Comprehensive rules imposing IPO-equivalent disclosure obligations on SPAC IPOs and De-SPAC transactions
- **Target co-registrant liability**: Target company becomes co-registrant in De-SPAC transactions; directors and officers are liable for Registration Statement disclosures
- **Forward-Looking Statement Safe Harbor exclusion**: PSLRA safe harbor unavailable for SPACs — no immunity for projections
- **Dilution disclosure**: Detailed disclosure of dilution from sponsor compensation, underwriting fees, warrants, convertible securities, PIPE
- **Minimum dissemination period**: 20 calendar days for De-SPAC prospectus/proxy statements

### Rule 63.236: SPAC-Specific IP Disclosure Items
- In addition to above SEC rules, prepare the following from an IP perspective:
  - Detailed target company IP asset description (patent, trademark, trade secret portfolio)
  - IP-related risk factors (infringement, OSS, AI risks)
  - IP valuation methodology and rationale (IP value underlying projections)
  - Conflict of interest disclosure (IP-related transactions between sponsor and target)

---

## §33. Post-Merger IP Integration (PMI)

### Rule 63.240: PMI IP Integration Roadmap

| Phase | Period | Actions |
|---|---|---|
| **Day-1** | Closing date | Confirm legal IP ownership transfer, verify critical license continuity, begin IP ledger integration |
| **Day-30** | ~1 month | Consolidated IP portfolio overlap analysis, pruning plan, trademark usage unification |
| **Day-100** | ~3 months | Complete integrated data room, IP cost optimization, develop combined patent strategy |
| **Day-365** | ~1 year | Full IP portfolio migration, synergy measurement, integrated IP maturity assessment |

### Rule 63.241: PMI-Specific IP Risks
- **Key person retention**: Retention strategies for key inventors (Retention Bonus / IP Earnout)
- **Cultural integration**: IP creation culture (invention disclosure promotion vs. trade secret emphasis)
- **Brand integration**: Co-branding → brand absorption → new brand timeline design
- **Tech stack integration**: OSS license compatibility verification, duplicate SaaS license cleanup

---

## §34. Carve-out & Spin-off IP Separation

### Rule 63.245: IP Separation Framework
- **Shared IP**: IP used by both parent company and separated entity
  - **License-back**: IP license grant to separated entity (pre-agree term, scope, royalty)
  - **Shared IP Agreement**: Joint-ownership IP usage terms
- **Exclusive IP**: Clear separation of IP belonging exclusively to one party
- **TSA (Transition Services Agreement)**: IP-related service provision terms during transition period

### Rule 63.246: Carve-out IP Due Diligence Checklist
- [ ] Complete identification and ledger of IP to be separated
- [ ] Determine attribution of mixed IP (shared vs. exclusive license)
- [ ] Employee IP assignment agreement transfer procedures
- [ ] Third-party license assignment/renegotiation
- [ ] OSS component usability confirmation for separated entity
- [ ] Trade secret transfer security procedures
- [ ] Data (including customer data) attribution, transfer, and privacy compliance

---

# VIII. Due Diligence Operations (§35-§41)

---

## §35. Data Room Construction & Automation

### Rule 63.250: Automated Data Room Mandate
- **Principle**: DD materials for M&A/fundraising must be **auto-generated via CI/CD pipelines**, not manually updated
- Outdated materials are a critical DD risk and cause valuation haircuts

### Rule 63.251: VDR Required Documents

| Category | Document | Auto-Generated |
|---|---|---|
| **Architecture** | System diagrams | ✅ `tbls`/`mermaid` |
| **Dependencies** | SBOM (CycloneDX/SPDX) | ✅ CI auto-gen |
| **Licenses** | OSS library + license list | ✅ SCA tools |
| **Security** | Penetration test report | — External |
| **Security** | Vulnerability scan results | ✅ CI auto-run |
| **Cost** | External service (SaaS) contracts + monthly cost | △ Semi-auto |
| **Legal** | IP assignment agreement list | — Legal managed |
| **Legal** | NDA list | — CLM tool |
| **Legal** | License agreement list | — Legal managed |
| **Technical** | API specifications | ✅ OpenAPI auto-gen |
| **Technical** | Test coverage report | ✅ CI auto-gen |
| **Technical** | Technical debt inventory | △ Tool + manual |
| **AI** | AI-generated code usage report | ✅ AI usage logs |
| **AI** | Model Card / Data Sheet | △ Semi-auto |
| **HR** | Org chart and key personnel | — HR managed |
| **Financial** | Audited financial statements | — External audit |
| **Patents** | Patent portfolio list | — IP management tool |
| **Trademarks** | Trademark registration list | — IP management tool |

### Rule 63.252: CI/CD Data Room Auto-Update

```yaml
# GitHub Actions: Data Room Auto-Update
name: Data Room Update
on:
  schedule:
    - cron: '0 0 * * 1'  # Every Monday
  push:
    branches: [main]
jobs:
  update-data-room:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Generate SBOM
        run: npx @cyclonedx/cyclonedx-npm --output-file data-room/sbom.json
      - name: Generate Architecture Diagram
        run: tbls doc --force --rm-dist
      - name: License Report
        run: npx license-checker --json > data-room/licenses.json
      - name: AI Usage Report
        run: ./scripts/generate-ai-usage-report.sh > data-room/ai-usage.json
      - name: Upload to VDR
        run: ./scripts/upload-to-vdr.sh
```

---

## §36. IP DD Checklist

### Rule 63.260: Sell-Side Checklist

```markdown
## Sell-Side IP DD Checklist
### Ownership & Attribution
- [ ] IP assignment agreement copies for all employees
- [ ] CLA/contractor agreements for all external contributors
- [ ] Invention disclosure report list and processing status
- [ ] Joint development agreement IP clause confirmation

### Patents
- [ ] Patent portfolio list (filed/registered/pending)
- [ ] Patent-to-product/service mapping
- [ ] Annual maintenance cost
- [ ] Licensed-out patent list
- [ ] Third-party patent license-in list

### Trademarks & Designs
- [ ] Trademark registration list (by country/class)
- [ ] Design registration list
- [ ] Usage evidence preservation status
- [ ] Pending trademark/design disputes

### Trade Secrets
- [ ] Trade secret identification list
- [ ] Protection measures documentation
- [ ] Access log preservation status
- [ ] GenAI-related secrecy protection measures

### Software & Licenses
- [ ] SBOM (latest version)
- [ ] SCA report (no license conflicts confirmed)
- [ ] Copyleft license usage locations and remediation status
- [ ] Third-party software license list
- [ ] AI-generated code usage scope and rights attribution records

### Risks
- [ ] Pending/past IP litigation list
- [ ] Received Cease & Desist letters
- [ ] Potential IP risk assessment
```

### Rule 63.261: Buy-Side Checklist
- All items above, plus:
  - [ ] Freedom to Operate (FTO) analysis
  - [ ] Target vs. acquirer IP overlap/conflict analysis
  - [ ] Post-integration IP portfolio optimization plan
  - [ ] Change of control provision impact assessment
  - [ ] Key person (inventor) retention plan
  - [ ] Target AI/ML model rights attribution confirmation
  - [ ] Data asset attribution and transferability confirmation

---

## §37. Technical Due Diligence

### Rule 63.270: Code Quality Evaluation Criteria

| Criterion | Green (Good) | Yellow (Caution) | Red (High Risk) |
|---|---|---|---|
| Test Coverage | ≥80% | 50-79% | <50% |
| Technical Debt Ratio | ≤5% | 5-15% | >15% |
| Dependency Vulnerabilities | 0 Critical/High | 1-3 High | 4+ High or Critical |
| Documentation Completeness | API/architecture docs complete | Major parts only | Mostly absent |
| CI/CD Pipeline | Fully automated | Partially automated | Manual deployment |
| Deploy Frequency | Daily+ | Weekly | Monthly or less |
| MTTR | <1 hour | 1-4 hours | >4 hours |
| AI-Generated Code Ratio | Recorded and managed | Partially recorded | No records |

### Rule 63.271: Architecture Evaluation
- **Scalability**: Can the architecture handle 10x load increase?
- **SPOF**: If present, are mitigation measures in place?
- **Cloud-native maturity**: Degree of containerization/IaC/managed services
- **Modularity**: Microservices/monolith ratio, coupling assessment
- **AI/ML infrastructure**: Model versioning, reproducibility, data pipeline maturity

### Rule 63.272: Technical Team Evaluation
- Bus Factor per key technology area (target: ≥2)
- Key engineer retention risk assessment
- Hiring difficulty for the technology stack in the talent market

---

## §38. OSS/License Due Diligence

### Rule 63.280: SCA-Integrated Automated License Audit
- **SCA tools**: Use Snyk / FOSSA / Socket.dev / Black Duck for automated license compliance verification as part of DD
- **Details** → see [602_oss_compliance.md](../security/200_oss_compliance.md)

### Rule 63.281: Quantifying OSS Risk in M&A
- **Black Duck 2025 Report findings**:
  - **85%** of M&A audit targets had license conflicts detected
  - **96%** had unpatched vulnerabilities
  - Average of thousands of OSS components per transaction
- **Mitigation**: Continuously run SCA/SBOM generation from early stages (18+ months prior)

### Rule 63.282: Copyleft Remediation
- Verify GPL/AGPL copyleft licenses are not contaminating proprietary code
- Develop remediation plans when contamination is detected
- Execute license renegotiation or component replacement

---

## §39. Vendor Lock-in Assessment & Portability

### Rule 63.290: Vendor Lock-in Assessment Matrix

| Criterion | Low Risk | Medium Risk | High Risk |
|---|---|---|---|
| **Data Portability** | Standard format export | Partially custom format | Vendor-proprietary only |
| **API Compatibility** | Industry-standard APIs | Some proprietary APIs | Fully proprietary APIs |
| **Infrastructure Abstraction** | IaC + multi-cloud ready | Some provider-specific | Deep provider dependency |
| **Migration Cost** | Days to weeks | Months | 6+ months |
| **Contractual Constraints** | Immediate termination | Long-term contract/penalties | Exclusive agreement |

### Rule 63.291: Portability Strategy
- **Abstraction layers**: Abstract database/storage/auth service access
- **Multi-cloud/hybrid**: Full multi-cloud unnecessary, but ensure data portability
- **Egress cost awareness**: Pre-estimate data transfer costs from cloud vendors
- **Standards compliance**: Prioritize OpenAPI, CloudEvents, OCI standards

---

## §40. Cross-Border IP Dispute Resolution

### Rule 63.295: International IP Dispute Resolution Mechanisms

| Mechanism | Scope | Characteristics | Duration |
|---|---|---|---|
| **UPC** | European patent disputes | Pan-European injunctions, central revocation | 12-18 months |
| **ITC Section 337** | US import patent infringement | Exclusion orders (import ban), expedited process | 12-16 months |
| **WIPO Arbitration Center** | International IP disputes | Confidentiality, expertise, enforceability | 6-12 months |
| **ICC Arbitration** | International license disputes | New York Convention enforcement | 12-24 months |
| **ISDS** | Investment treaty IP disputes | Investor-state disputes | 24-48 months |

### Rule 63.296: Dispute Resolution Clause Design
- International IP contracts must include:
  - **Tiered dispute resolution**: Negotiation → mediation → arbitration/litigation
  - **Governing law**: IP existence/validity under protecting country law; contractual matters under agreed law
  - **Arbitration clause**: Specify WIPO / ICC / SIAC rules
  - **Interim measures**: Emergency Arbitrator provisions for evidence preservation and injunctions

---

## §41. IP-backed Financing

### Rule 63.300: IP Security Interest
- **Overview**: Securing financing from financial institutions using patents, trademarks, etc. as collateral
- **Legal basis**:
  - US: UCC Article 9 (personal property security) — perfection of IP security interest required
  - Japan: Patent Act §95 ff. (patent pledge) — registration with JPO is perfection requirement
  - EU: Member state law-dependent (no unified IP security interest regime)
- **Practical challenges**:
  - IP asset valuation (→ §28 IP Valuation)
  - IP obsolescence risk
  - Treatment of IP in bankruptcy

### Rule 63.301: Strategic Use of IP-backed Financing
- **Avoid equity dilution**: Fundraising without additional share issuance
- **Applications**: Bridge financing, R&D funding, pre-Exit runway extension
- **Market trends (2025)**: IP-backed financing market growing — specialized players include Aon / Intellectual Ventures / IPwe
- **Cautions**: Verify impact on IP disposition rights and licensing ability before pledging

---

# IX. Governance & Ongoing Management (§42-§47)

---

## §42. IP Asset Ledger & Inventory

### Rule 63.310: IP Registry Management
- **Centralized ledger** recording:
  - Patents (application no., registration no., priority date, expiry, annuity due dates, UPC opt-out status)
  - Trademarks (registration no., class, country, renewal date, usage evidence status)
  - Designs (registration no., target product, country, expiry)
  - Domain names (registrar, expiry, auto-renewal, DNSSEC status)
  - Trade secrets (name, classification level, authorized access list, last access audit date)
  - Copyright registrations (jurisdiction, registration no., date)
  - Software licenses (type, term, cost)
  - Data assets (database rights, license terms, usage restrictions)
  - AI/ML models (training data licenses, model cards, usage terms)

### Rule 63.311: Annual IP Inventory Process
1. Update full IP asset inventory
2. Reassess each IP's business relevance
3. Renewal decisions for expiring/near-expiry IP
4. Consider disposition of unused IP (abandonment/licensing/sale)
5. Identify new IP to be acquired
6. Annual budget review of IP costs (annuities, registration fees, management)
7. Verify currency of AI-generated output IP records

---

## §43. IP Incident Response

### Rule 63.320: Infringement Notice Response Flow
1. **Day 0**: Notify legal team, begin evidence preservation
2. **Within 72 hours**: External IP counsel engagement decision
3. **Within 2 weeks**: Non-infringement/invalidity counter-argument assessment
4. **Response decision**: Choose litigation, license negotiation, or Design Around
5. **Record**: Log all response history in IP incident log

### Rule 63.321: Own IP Infringement Discovery Flow
1. Evidence collection (recommend notarized preservation — Wayback Machine/screenshots/blockchain timestamps)
2. Assess infringement scope and impact
3. Cease & Desist letter decision
4. Choose negotiation/litigation/ADR (→ §40 Cross-Border Dispute Resolution)
5. Consider license grant possibility

### Rule 63.322: Incident Response Team
- **Composition**: Chief Legal Officer + CTO/VP Engineering + External IP Counsel + Business Lead
- **Escalation criteria**: Pre-define 3-tier criteria based on potential damages/injunction risk/business impact

---

## §44. IP Maturity Model

### Rule 63.330: 5-Level Maturity Model

| Level | Name | Characteristics | Checklist |
|---|---|---|---|
| **Level 1** | Ad Hoc | IP management is person-dependent, unsystematic | No IP ledger exists |
| **Level 2** | Basic | Basic IP assignment agreements and NDAs in place | Employment rules include IP clauses |
| **Level 3** | Managed | Patent/trademark filing strategy exists, IP ledger operated | Regular IP audits conducted |
| **Level 4** | Optimized | Data room automated, regular IP valuation, AI-IP policy established | Exit Ready Scorecard ≥80% |
| **Level 5** | Strategic | IP is core to business strategy, active licensing/M&A use, IP-backed financing track record | IP is a revenue source |

### Rule 63.331: Maturity Improvement Roadmap
- **Level 1→2**: Complete IP assignment agreements for all, establish standard NDA template
- **Level 2→3**: Establish Patent Committee, deploy trademark monitoring, build IP ledger
- **Level 3→4**: CI/CD data room automation, external IP valuation, OSS compliance automation, AI-IP policy
- **Level 4→5**: Create IP licensing revenue, establish M&A IP strategy, explore IP tokenization

---

## §45. IP Insurance (IP Litigation Insurance)

### Rule 63.335: IP Insurance Types

| Type | Protection | Coverage | Application |
|---|---|---|---|
| **Defensive** | Defense costs from IP infringement suits | Litigation costs, settlements, damages | PAE/NPE lawsuit defense |
| **Offensive/Abatement** | Enforcement costs for own IP infringement | Litigation costs, investigation costs | Active IP protection |
| **R&W Insurance** | IP-related R&W breaches in M&A | Damages | M&A closing |
| **POSI (Public Offering of Securities Insurance)** | IP litigation post-IPO | Litigation costs, damages | Pre-IPO protection |

### Rule 63.336: IP Insurance Adoption Criteria
- **Adoption indicators**:
  - Annual IP litigation risk score is medium-high
  - M&A or IPO is planned
  - PAE/NPE is active in your technology field
  - Patent portfolio size is medium-large (50+ patents)
- **Key providers**: Aon / Marsh / RPX / IPISC

---

## §46. ESG, Sustainability & IP

### Rule 63.340: Green Patents & Environmental Technology IP
- **WIPO GREEN**: Environmental technology IP matching platform — consider registering your green IP
- **Green Patent Fast Track programs**:
  - Japan: Super-expedited examination (green inventions eligible)
  - US: Patents for Humanity / Climate Change Mitigation Technologies Patent Pilot
  - Europe: EPO PACE (accelerated examination program)
- **SDG-aligned IP portfolio**: Visualize IP contributing to environmental/social issue resolution for ESG investors

### Rule 63.341: IP in ESG Disclosure
- **TCFD/ISSB/CSRD**: Include IP assets (environmental technology patents) in climate-related risk disclosures
- **Integrated reports**: Quantitatively disclose how IP contributes to corporate sustainability strategy
- **Greenwashing prevention**: Accurately disclose actual usage and impact of environmental IP

---

## §47. Open Innovation IP Policy

### Rule 63.345: CVC / Accelerator IP Requirements
- **CVC portfolio company IP clauses**:
  - IP ownership remains with portfolio company (secure access rights, not control)
  - Preferential licensing (ROFR for IP licensing)
  - IP access guarantees during M&A
- **Accelerator participant IP protection**:
  - Protect participant Background IP
  - Mentor confidentiality obligations
  - Clear IP attribution for co-created deliverables

### Rule 63.346: University-Industry IP Management
- **University collaboration agreement IP clauses**:
  - Research output IP attribution (US: Bayh-Dole Act — university has priority ownership)
  - Secure exclusive/non-exclusive license for the enterprise
  - Coordinate academic publication and patent filing timing (leverage Grace Period)
  - Confirm IP attribution for student/postdoc outputs

---

# X. Compliance & Timeline (§48-§50)

---

## §48. Global IP Compliance Timeline

### Rule 63.350: 2025-2028 Key Regulatory Calendar

| Timing | Regulation/Event | Impact |
|---|---|---|
| **Aug 2025** | EU AI Act: GPAI model obligations (training data summary disclosure) take effect | Training data rights clearance compliance |
| **Oct 2025** | EU SEP Regulation: European Commission formally withdraws | SEP strategy uncertainty — monitor alternative frameworks |
| **Nov 2025** | USPTO: Revised AI-assisted invention guidance takes effect | AI invention filing strategy review |
| **Jan 2026** | UPC court fees increase by average 33% | European patent litigation cost planning revision |
| **Jun 2026** | Colorado AI Act takes effect | High-risk AI system governance obligations |
| **Aug 2026** | EU AI Act: Full enforcement (all risk categories) | Complete AI-related IP attribution and disclosure compliance |
| **2027** | EU CRA (Cyber Resilience Act): Software security requirements fully enforced | SBOM/vulnerability management and IP protection alignment |
| **2027** | EU CSDDD (Corporate Sustainability Due Diligence Directive): Corporate sustainability DD obligations (incl. supply chain) | Assess green IP disclosure obligations in supply chain context (→ §57) |
| **2027 Q1** | India DPDP Act (Digital Personal Data Protection Act) expected to take effect | Review data processing policies for training datasets and IP-related confidential information targeting the Indian market |
| **2027 Q2** | Brazil LGPD Second Amendment (enhanced data processing obligations for IP-related data expected) | Confirm local law compliance for IP monetization strategies targeting South American markets |
| **2027** | CHIPS Act (US): IP disclosure and compulsory license conditions for subsidy recipients enter full effect | If holding semiconductor/hardware IP, integrate with national security review process (→ §60) |
| **2028** | WIPO: Member state conferences on international AI-copyright standards (negotiations ongoing) | Monitor global harmonization trends for AI-IP attribution |
| **2028** | Japan: Next Unfair Competition Prevention Act amendment (under review) | Monitor trade secret and limited-provision data protection trends |
| **2028** | EU Cyber Solidarity Act: Full enforcement | AI/cloud system IP disclosures may be required by European cyber authorities |
| **2028–2030** | Quantum computing practicality window: Practical threat to existing RSA/ECC crypto | Final PQC migration and IP strategy integration phase (→ §50 Rule 63.362) |

### Rule 63.351: Compliance Monitoring
- **Quarterly**: Scan IP-related legislation and case law developments in key jurisdictions
- **Annual**: Update global IP compliance matrix
- **Sources**: Auto-monitor official announcements from WIPO Lex / USPTO / EPO / JPO / CNIPA

---

## §49. IP Education & Organizational Capability Building

### Rule 63.355: Inventor Education Program
- **All engineers**:
  - IP fundamentals training (annual, 2 hours): Patents, trade secrets, copyright basics, invention disclosure
  - AI-generated IP training: AI Copilot usage precautions, documentation obligations
- **Inventor candidates**:
  - Invention writing workshop (claim design basics, prior art search methods)
  - Patent reading training (competitor patent reverse engineering)
- **Leadership**:
  - IP strategy workshop: Portfolio strategy, exit preparation, IP valuation
  - DD readiness training: Data room construction, R&W understanding

### Rule 63.356: IP Champion Program
- Appoint an **IP Champion** on each technical team
- **Roles**:
  - Promote invention disclosures and initial screening
  - IP awareness activities
  - Bridge to Patent Committee
  - Daily OSS license compliance monitoring
- **Incentives**: Reflect IP Champion activities in performance evaluations

---

## §50. Future Technology IP Strategy

### Rule 63.360: IP Protection Approaches for Emerging Technologies

| Technology | IP Protection Methods | Considerations |
|---|---|---|
| **Quantum Computing** | Patents (quantum algorithms, gate design) + trade secrets | IP updates alongside quantum-resistant crypto migration |
| **Post-Quantum Cryptography (PQC)** | Patents (PQC implementation optimization, HW acceleration) + NIST standards participation | Standard algorithms themselves difficult to patent — implementation optimization is the main battleground |
| **Agentic AI / MCP / A2A** | Patents (agent orchestration methods) + trade secrets (prompt design) | Inter-agent IP attribution is a gray zone — human oversight records are mandatory |
| **OSS AI Model Fine-Tuning** | Protect delta weights (LoRA/QLoRA) as trade secrets | Check Llama/Mistral etc. license terms carefully (commercial use restrictions) |
| **Web3/Decentralized Apps** | Patents + trade secrets (smart contract logic) | OSS-first ecosystem — careful license strategy design |
| **Metaverse/XR** | Design rights (virtual space) + trademarks (virtual brands) | Jurisdiction issues for IP infringement in virtual worlds |
| **BMI (Brain-Machine Interface)** | Patents + trade secrets + ethics review | Intersection with medical device regulations, bioethics |
| **Synthetic Biology** | Patents (gene sequences, bioprocesses) + trade secrets | Utility of natural laws, lessons from CRISPR patent disputes |
| **Edge AI** | Patents (on-device models) + trade secrets (training data processing) | IP protection for model compression techniques |
| **Spatial Computing / XR / Vision Pro-class** | Design rights (virtual space UI) + patents (depth sensing, eye-tracking) + trademarks (virtual brands) | IP infringement jurisdiction in physical-virtual hybrid spaces is unsettled — international arbitration clauses are mandatory in all license agreements |
| **Neurotech / BCI Wearables** | Patents (signal processing algorithms, electrode design) + mandatory ethics review | Neural data is PII at the highest confidentiality tier — apply GDPR/APPI maximum-sensitivity protections |

### Rule 63.361: Building Future Technology IP Portfolios
- **Early filing strategy**: Secure foundational patents before technology matures
- **Defensive publishing**: Defensively publish technology directions you won't pursue to block competitor patents
- **Standards participation**: Join emerging technology standards bodies (W3C / IEEE / IETF) for SEP acquisition
- **Technology roadmap alignment**: Sync 3-5 year technology roadmaps with IP filing strategy

### Rule 63.362: Post-Quantum Cryptography (PQC) IP Strategy
- **NIST PQC Standards finalized (August 2024)**: CRYSTALS-Kyber (ML-KEM), CRYSTALS-Dilithium (ML-DSA), FALCON (FN-DSA), SPHINCS+ (SLH-DSA)
  - The standard algorithms themselves are difficult to patent → **Patent opportunities in high-speed implementation, hardware acceleration, and hybrid migration tooling**
  - Optimizing TLS 1.3 + PQC hybrid key exchange implementations is an important patent territory
- **Harvest Now, Decrypt Later (HNDL) risk mitigation**:
  - Synchronize PQC migration plans with patent strategy; secure patents on migration tools and the migration process itself
  - Early filing recommended for hybrid operation techniques combining legacy cryptographic protocols with PQC

### Rule 63.363: Agentic AI / MCP / A2A Protocol IP Issues
- **Gray Zone IP Attribution — Mandatory Protocol**:
  - Copyright for outputs from multiple AI agents collaborating is not yet legally settled
  - **Principle**: Copyright claims viable only for portions where humans substantially contributed to orchestration design, goal-setting, and output evaluation
  - **Documentation obligation**: Fully preserve agent execution logs (each agent's assigned steps, decision processes) (→ §23)
- **IP Protection for Prompts and Workflow Design**:
  - Complex multi-agent orchestration designs: prioritize **trade secret** protection (public disclosure enables easy competitor replication)
  - Patent focus on technical innovations: inter-agent coordination protocols, task decomposition/assignment algorithms
- **MCP (Model Context Protocol) Usage Precautions**:
  - Business logic and prompt templates embedded in MCP servers: manage as trade secrets
  - When using third-party MCP servers: confirm ToS (data usage and IP attribution clauses)

### Rule 63.364: Open-Source AI Model Fine-Tuning Strategy
- **Commercial License Verification (Mandatory)**:

| Base Model | License | Commercial Use | Fine-Tuning Restrictions |
|---|---|---|---|
| Llama 3.x | Meta Llama 3 Community License | Separate application required if MAU >700M | Permitted (commercial use of logo/name restricted) |
| Mistral / Mixtral | Apache 2.0 | Free | Permitted |
| Gemma 2 | Gemma Terms of Use | Permitted | Restrictions on use against Google-competing products |
| Phi-4 | MIT | Free | Permitted |

- **Fine-Tuned Model Protection Policy**:
  - While inheriting base model license, **protect delta weights (LoRA Adapter / QLoRA) as trade secrets**
  - Proprietary training datasets and data pipelines for fine-tuning: protect via patent or trade secret
  - Novel architectural improvements (new attention mechanisms, positional encoding, etc.): consider patent filing
  - **When serving via SaaS**: AGPL-licensed models may trigger OSS source disclosure obligations for network-based delivery — verify carefully

---

# XIII. IP Monetization Strategy (§53)

---

## §53. IP as a Standalone Revenue Stream

### Rule 63.390: IP Licensing Monetization Framework
- **Monetization Model Types**:

| Model | Overview | Best Fit | Revenue Scale |
|---|---|---|---|
| **Licensing (Non-exclusive)** | Grant same IP license to multiple licensees | Widely adopted tech (incl. SEPs) | Medium–Large |
| **Licensing (Exclusive)** | Exclusive license to single licensee | Strong synergy in specific market | Large |
| **Cross-licensing** | Mutual IP exchange, effectively royalty-free | Litigation avoidance, R&D acceleration with competitors | Cash-neutral |
| **Patent Pool Participation** | Contribute patents to MPEG-LA / Via / Avanci etc. | SEP holders, standards technology | Medium–Large (stable) |
| **IP Holding Company (IPCo)** | Establish dedicated IP holding/licensing entity | Large portfolios, business separation | Large |
| **Outright Assignment** | Transfer full IP ownership to third party | Strategically non-core IP, fundraising | Lump sum |
| **IP Tokenization / Fractional** | Fractional ownership sold on blockchain | Liquidity creation, multi-investor participation | Emerging / uncertain |

### Rule 63.391: Licensing Program Design
- **Royalty Rate-Setting Principles**:
  - Use **industry benchmark rates (§28 Rule 63.202)** as reference
  - **Comparable License Agreements (CLAs)**: Collect and database past comparable licensing precedents as negotiation basis
  - **Nash Bargaining Solution**: Economic framework for rate-setting (SSPPU: Smallest Saleable Patent Practicing Unit as calculation basis)
  - **Royalty Stacking**: Evaluate the reasonableness of total stacked royalties when multiple IPs overlap (especially critical in FRAND context)

- **Licensing Agreement Mandatory Clauses**:
  - [ ] Explicit licensed IP identification (patent numbers, version-controlled IP list as attachment)
  - [ ] Scope of license (geography, field, purpose, sublicense rights)
  - [ ] Royalty basis (SSPPU / end-product price / fixed fee)
  - [ ] Reporting & Audit Rights (annual, cost allocation, trigger conditions)
  - [ ] Most Favored Licensee (MFN) clause consideration (exercise caution for SEP/FRAND)
  - [ ] Grantback clause for improvement inventions (non-exclusive strongly recommended; exclusive creates antitrust risk)
  - [ ] Termination conditions (patent invalidation, payment default, bankruptcy)
  - [ ] Arbitration & governing law (recommend WIPO/ICC arbitration for licensing disputes)

### Rule 63.392: IPCo (IP Holding Company) Strategy
- **IPCo Design Objectives**:
  - Ring-fence IP from operating company risks (litigation, insolvency)
  - Tax efficiency optimization (IP-favorable jurisdictions: Netherlands "Innovation Box", Ireland "Knowledge Development Box", Luxembourg "IP Box")
  - Centralized licensing program management

- **Tax Considerations for IPCo Establishment**:
  - **BEPS (Base Erosion and Profit Shifting)**: Comply with OECD BEPS Action 13 (transfer pricing, country-by-country reporting)
  - **Pillar Two (Global Minimum Tax 15%)**: Confirm effective tax rate in IPCo jurisdiction (calculate top-up tax for erosion prevention)
  - **Transfer pricing documentation**: Prepare ALP (Arm's Length Principle)-based valuation at IP transfer (country-by-country reporting obligation)

### Rule 63.393: Patent Pools and Licensing Consortia
- **Participation Decision Criteria**:
  - Whether company patents are recognized as essential technology within the pool (Essentiality evaluation)
  - Whether the pool's royalty rate meets FRAND conditions accepted in the market
  - Impact on competitor relationships through pool participation (shared licensing → licenses granted to competitors)

- **Major Patent Pools (as of 2025)**:

| Pool | Technology Area | Notes |
|---|---|---|
| **MPEG-LA** | HEVC / VVC / H.264 / AVC | Encoders and decoders covered |
| **Via Licensing (under Sisvel)** | Wi-Fi / Bluetooth / 4G / 5G | Pool for standardized SEPs |
| **Avanci** | IoT / Automotive (4G/5G) | FRAND consolidated licensing model |
| **Access Advance** | VVC / H.266 / HEVC Plus | Next-gen video compression standard |
| **Open Patent Alliance (OPA)** | Wi-Fi / Bluetooth | Low-cost access for SMEs |

### Rule 63.394: PAE (Patent Assertion Entity) vs. Operating Company — Attack & Defense
- **Defensive Strategy (when attacked by PAE)**:
  - File IPR (Inter Partes Review) at PTAB (Patent Trial and Appeal Board) for invalidation
  - Prioritize negotiated settlement (weigh against total litigation cost)
  - Join LOT Network / OIN if not already a member
  - Leverage anti-PAE defense services (RPX / Unified Patents)

- **Offensive Strategy (active enforcement of own IP)**:
  - Always conduct FTO analysis before enforcement actions (pre-assess retaliatory litigation risk)
  - Consider ITC Section 337 (import exclusion orders — fast and powerful but strict requirements)
  - Utilize litigation cost insurance and contingency fee law firms

### Rule 63.395: IP Licensing KPIs and Financial Management
- **Mandatory KPIs**:
  - License revenue (absolute + as percentage of total business revenue)
  - Active licensee count (by region and field)
  - Reporting/audit cycle compliance rate (count of delinquent licensees)
  - Unpaid/delayed royalty incidents and collection rate
  - Average negotiation duration for new license acquisitions

- **Financial Management of License Revenue**:
  - Visualize license revenue as **an independent line item on the P&L** (directly impacts IPO and investor valuations)
  - Separate management of guaranteed fees (fixed) and running royalties (variable) (per ASC 606 / IFRS 15)
  - Map to intangible asset amortization (GAAP/IFRS in-progress intangible asset accounting)

---

# XIV. Antitrust & IP (§54)

---

## §54. IP × Competition Law in the GenAI Era

### Rule 63.400: Overview of Antitrust-IP Intersection
- **Core Tension**: IP grants temporary monopoly rights (patents: 20 years, copyright: 70+ years) — competition law regulates market monopolies
- **IP Exemption Principle**: IP enforcement is generally not anticompetitive, but the following acts are regulated:
  - IP sheltering with intent to monopolize entire markets
  - SEP license refusals in violation of FRAND terms
  - Patent evergreening (artificially extending market monopolies to block competitor entry)
  - Price coordination through anticompetitive patent pools or cross-licensing

### Rule 63.401: GenAI Monopoly Risk (2025-2026 Latest Developments)
- **Global AI Monopoly Investigations**:
  - **EU**: European Commission investigating competitive concerns from OpenAI / Microsoft / Google / AWS / NVIDIA in AI markets (2025–)
  - **US**: DOJ/FTC investigating FANG/Big Tech enclosure of base models (API access restriction, data monopolization)
  - **UK**: CMA identified AI supply chain competition risks in "AI Foundation Models: Initial Report" (2024)
  - **Japan**: Japan Fair Trade Commission investigating dominance abuse risks by AI system providers (2024 report)

- **Specific Antitrust Risk Scenarios**:
  - Exclusive API access restriction → downstream startup market exclusion
  - Training data monopolization (e.g., full internet snapshot → insurmountable entry barrier for later entrants)
  - GPU-AI software bundling (tying arrangement)
  - Patent/model monopolization via acqui-hires of competing startups by AI-capable incumbents

### Rule 63.402: FRAND Principle Extension to GenAI
- **Academic and Regulatory Trends (2025-2026)**:
  - Some regulators and academics advocate FRAND-like access obligations for AI foundation model training data and inference APIs
  - EU AI Act Article 53: GPAI providers must disclose technical documentation and training data summaries → FRAND-like transparency requirements
  - **Key watch point**: Mandatory compulsory access (Compulsory Access) to foundation model APIs is emerging on the regulatory agenda
- **Strategic Implications**:
  - As market share grows, exclusionary IP exercise faces stricter regulation
  - Pre-assess risk that your AI technology/data will face FRAND-like disclosure demands

### Rule 63.403: Global Antitrust Compliance for IP
- **US (DOJ/FTC)**:
  - **IP Licensing Antitrust Guidelines (2017 version)**: DOJ/FTC guidance on IP licensing (currently under revision for AI/digital markets)
  - **Single Entity Doctrine**: Cross-licensing among affiliated entities is generally lawful; price coordination among unrelated competitors is illegal
  - **Market Definition**: Define AI/IP markets (patent class, technology market, innovation market)

- **EU (European Commission / DG COMP)**:
  - **TTBER (Technology Transfer Block Exemption Regulation) 2014/316/EU**: Block exemption for patent and know-how licensing in EU (safe harbor from competition law)
  - TTBER market share thresholds: **20%** or below for competing undertakings; **30%** or below for non-competing undertakings = safe harbor
  - **Hardcore restrictions**: Price-fixing, market partitioning, and output limitations fall outside TTBER safe harbor

- **Japan (Japan Fair Trade Commission)**:
  - **Guidelines for the Use of Intellectual Property under the Antimonopoly Act (2023 revision)**: Criteria for IP licensing restriction assessment
  - **Dominance abuse**: Large platforms refusing IP licenses to startups

- **China (SAMR — State Administration for Market Regulation)**:
  - Comply with provisions prohibiting exclusion of competition through IP abuse (effective 2023)
  - Risk of administrative sanctions for FRAND violations on SEPs (strengthened post-Qualcomm case)

### Rule 63.404: Patent Evergreening vs. Legitimate Continuation Strategy
- **Illegitimate Evergreening (Regulated)**:
  - Artificially extending market monopoly through patent renewal based solely on minor formulation/process changes
  - Mass filing of improvement patents without novelty/inventive step to create blocking positions (especially pharma and AI)
  - Pay-for-Delay (Reverse Payment Settlements): Paying generic companies to delay market entry

- **Distinction from Legitimate Continuation Strategies (→§8 Rule 63.072)**:
  - Filings containing substantive technical improvements are justified
  - Document internal review procedures for assessing the presence of improvement to reduce evergreening classification risk

### Rule 63.405: Digital Markets Act (DMA) & IP Intersection
- **EU Digital Markets Act (DMA) — Effective 2023**:
  - **Gatekeeper designation**: Google / Apple / Meta / Amazon / Microsoft / ByteDance are designated "gatekeepers" — subject to additional obligations
  - **IP Intersection Points**:
    - **Interoperability obligation**: Messaging service interoperability mandate → Protocol patents may effectively require FRAND-like disclosure
    - **Data portability obligation**: User data transfer → Reconcile with database rights and trade secrets
    - **App store reform**: Third-party app distribution obligation → Mandated access to platform IP
  - **Response strategy**: Even non-gatekeepers should assess indirect DMA compliance exposure from transactions with gatekeeper entities

### Rule 63.406: Antitrust Compliance Program for IP
- **Mandatory Elements of IP Licensing Antitrust Compliance**:
  - [ ] Annual antitrust law training for IP licensing staff
  - [ ] "Do's and Don'ts" guide for information exchange and license negotiations with competitors
  - [ ] Antitrust law review (external counsel) before entering cross-licenses or patent pools
  - [ ] Regular verification of TTBER market share thresholds (EU) — establish response flow for threshold breach
  - [ ] Pre-assess competition authority notification obligations for IP-related M&A and JVs

---


# XI. Geopolitical Risk & Export Controls (§51)

---

## §51. IP × Sovereign Risk

### Rule 63.370: IP Risk Landscape in the Tech Sovereignty Era
- **Background**: US-China tech rivalry, Russia sanctions, and Taiwan Strait risks directly impact IP transfer, protection, and enforcement
- **Risk Categories**:
  - **Export Control Risk**: Company IP (patent technology, software, cryptographic tech) triggering export restrictions
  - **Forced IP Transfer Risk**: Countries/contracts requiring technology licensing as a condition for market access
  - **National Jurisdiction IP Invalidation Risk**: Inability to enforce rights in adversarial countries under geopolitical tension
  - **Supply Chain Disruption Risk**: Technology suppliers becoming subject to sanctions or export restrictions

### Rule 63.371: Export Control Regulations & IP Intersection
- **EAR (Export Administration Regulations / US)**:
  - Classify software, code, and algorithms on EAR-controlled items list (ECCN) — especially cryptographic tech: ECCN 5D002, 5E002
  - **Fundamental Research Exclusion (FRE)**: Research conducted with educational institutions intended for publication may be EAR-exempt
  - **License Exception TSR**: Leverage applicable exceptions for technology transfers
  - Disclosing internal technology to non-citizen employees also qualifies as **Deemed Export** and may be subject to EAR controls
- **ITAR (International Traffic in Arms Regulations / US)**:
  - Consult legal counsel on ITAR applicability for defense/space/cyber-weapon IP
  - ITAR restrictions limit technology disclosure to foreign nationals (impacts hiring and development structure)
- **EU Export Control Regulations (EG No 428/2009, as amended)**:
  - Comply with EU dual-use technology export controls
  - Intangible Technology Transfer (ITT) controls for cybersecurity technology
- **Japan: Foreign Exchange and Foreign Trade Act (FEFTA)**:
  - Prior notification required for foreign investment in core sectors with high-technology strategic value
  - Export license may be required for transfer of sensitive technology to foreign countries

```yaml
# Export Control Checklist (IP Perspective)
ip_export_control_checklist:
  eccn_classification:
    - action: "Classify all products, software, and crypto libraries under ECCN"
    - action: "Maintain ledger distinguishing EAR99 (unrestricted) vs. ECCN-classified items"
  deemed_export:
    - action: "Confirm ECCN classification before disclosing technology to non-citizen employees/interns"
    - action: "Assess export control risk for cloud dev environments by location and access permissions"
  license_enforcement:
    - action: "Verify export destination is not on sanctions lists (OFAC SDN / BIS Entity List)"
    - action: "Confirm EAR applicability before embedding into OSS (OSS itself typically EAR99, but combined deployments may trigger controls)"
```

### Rule 63.372: IP Risk Management in China, Russia, & Other Jurisdictions
- **China IP Protection Strategy**:
  - Patent filing in China publicly discloses technology in exchange for rights → Trade secret/patent bifurcation strategy is critical
  - **Confidentiality Examination**: Filing a patent first in a foreign country for inventions developed/held in China requires CNIPA confidentiality examination approval (violation renders Chinese patent rights null)
  - JV Mandatory Requirements: Manage Background IP in a separate legal entity; grant only licensing to JV
  - **Hong Kong**: IP protection currently independent of mainland China, but continue monitoring National Security Law (NSL) impact
- **Russia/Ukraine Situation**:
  - License agreements with sanctioned entities/individuals require OFAC license
  - Russia 2022 law amendment: Authorizes compulsory licensing to sanctioned countries without compensating patent holders → Erodes practical enforcement in Russia
- **India**:
  - Pre-assess compulsory licensing risk under national security provisions (Patents Act §§100-103)
  - Pharmaceutical/AI sector compulsory licensing risk evaluation

### Rule 63.373: Strategies for Technology Decoupling
- **Geopolitical Diversification of IP Portfolio**:
  - Manage IP for high geopolitical risk regions separately from low-risk regions
  - Concentrate critical IP legal domicile in politically stable jurisdictions (Singapore, Netherlands, Ireland, etc.)
- **Technology Partitioning**:
  - Separate core technology (critical competitive advantage) from general-purpose technology
  - Core tech: Managed on-premises/private cloud; restrict access by non-citizen employees
  - General-purpose tech: May be shared with global development teams
- **FDI (Foreign Direct Investment) Review Response**:
  - Pre-assess IP ownership changes that trigger CFIUS (US) / FIRB (Australia) / NSI Act (UK) / Inbound Investment Review (Japan)
  - Develop response plans for M&A transactions requiring CFIUS review (heightened criteria post-FIRRMA)

### Rule 63.374: Security Export Controls & R&D Governance
- **Separation of Basic Research and Applied Research**:
  - Physically segregate open-publication basic research (FRE-eligible) from confidentiality-required applied research (EAR/ITAR-relevant) through org design, processes, and IT systems
  - **Research Security Program**: Implement NIST-recommended Research Security Program (per NSPM-33)
- **International Joint Research IP Clauses**:
  - Be alert to government access rights (march-in rights, etc.) in the IP of joint research involving foreign government funding
  - Mandate DUAL USE EXPORT review for research on dual-use military/civilian technologies

---

# XII. GenAI Supply Chain IP Governance (§52)

---

## §52. IP Accountability Chain Across the GenAI Supply Chain

### Rule 63.380: IP Attribution in AI Agent Collaborative Outputs
- **Core Issue**: LLM → Tool Call → Subagent → Final Output creates a GenAI supply chain where "whose intellectual property is it?" becomes ambiguous
- **Current Legal Position (as of 2026)**:
  - Copyright for multi-agent collaboratively generated content arises only for parts where humans made substantial creative contributions (→ §23)
  - When an **Agent Orchestrator** operates under human direction, the copyright of the final output tends to be attributed to the human or legal entity
  - Fully autonomous AI agent outputs (no human-in-the-loop) are unlikely to receive copyright protection

### Rule 63.381: IP Clause Management with GenAI Service Providers
- **ToS Review When Using Model APIs (Mandatory)**:

| Provider | Output Rights | Training Use | Commercial Use | Enterprise Differences |
|---|---|---|---|---|
| **OpenAI API** | Attributed to user | Opt-out available (API Tier) | Permitted | DPA agreement explicitly prohibits training use |
| **Anthropic API** | Attributed to user | Opt-out available | Permitted | Enterprise tier guarantees non-training |
| **Google Gemini API** | Attributed to user | Conditional (except Enterprise) | Permitted | Vertex AI: non-training |
| **Azure OpenAI** | Attributed to user | Non-training by default | Permitted | Enterprise standard: non-training |

- **Enterprise API Mandate**: For confidential projects, only Enterprise APIs (with contractual non-training guarantees) must be used
- **ToS Change Monitoring**: Review major AI provider ToS quarterly; track changes to IP clauses

### Rule 63.382: Code Generation & Completion Tool IP Risk Management
- **IP Risks When Using GitHub Copilot / Cursor / Codeium, etc.**:
  - **Copyright Infringement Risk**: AI may reproduce copyrighted works from training data (enabling filtering features is recommended)
  - **Patent Infringement Risk**: Certain algorithm patterns may reproduce patented technology
  - **License Breach Risk**: OSS code may be embedded in generated code without license attribution
- **Technical Countermeasures**:

```yaml
# GitHub Copilot: IP Protection Settings
copilot_ip_protection:
  duplicate_detection:
    enabled: true  # Hide suggestions matching public code
  suggestions_matching_public_code: "blocked"  # Block references to public code
  code_referencing:
    enabled: true  # Enable source citation for code suggestions
  
# Cursor: Proprietary Code Leakage Prevention
cursor_privacy:
  privacy_mode: true  # Do not transmit code to Anthropic servers
  indexing_local_only: true  # Restrict indexing to local only
```

- **AI-Generated Code Documentation Obligation**: Record the `% of AI contribution` in commit comments or PR templates (→ §23, §24)

### Rule 63.383: Multi-Modal AI Output IP Management
- **Image, Video, Voice Generation IP Management**:
  - **Images**: Review ToS for DALL·E / Midjourney / Stable Diffusion; understand commercial use restrictions on generated images
  - **Voice**: Note neighboring rights of voice talent/artists (monitor regulatory trends for AI Voice Cloning jurisdiction by jurisdiction)
  - **Video**: Embed C2PA (Content Authenticity Initiative) metadata in AI-generated video to certify provenance
  - **AI-Generated Content Labeling Obligation**: EU AI Act §50 (full enforcement August 2026) mandates technical marking of AI-generated content
- **Deep Fake & Impersonation Risk**:
  - Strengthen brand monitoring to detect Deep Fake usage of company brand, executive faces, and voices
  - Evidence preservation strategy for Cease & Desist targets involving "Synthetic Media" usage

### Rule 63.384: Integrated Quality, Security, and IP Management for AI Output
- **AI-Generated Code Supply Chain Risk**:
  - LLMs may generate code patterns with vulnerabilities (automate cross-checking against CWE Top 25)
  - Integrate SAST/DAST scanning of AI-generated code into CI/CD (→ [000_security_privacy.md](../security/000_security_privacy.md) §AI-SPM)
- **Automated License Detection for AI-Generated Code**:

```python
# AI-generated code license/IP detection pipeline example
# Integrated into CI/CD; runs automatically before merge

steps:
  - name: "Detect AI-generated code fingerprints"
    run: |
      # Detect similarity with public repository code
      scancode-toolkit --output-format json --license --copyright ./src
      
  - name: "AI code attribution check"
    run: |
      # Verify AI-generated code annotations in PRs
      python scripts/check_ai_attribution.py --pr-diff ${{ github.event.pull_request.number }}
      
  - name: "License conflict detection"
    run: |
      # Detect OSS license contamination in AI-generated code
      fossa analyze --include-unused-deps
```

### Rule 63.385: Integrating AI Governance Frameworks with IP
- **AI Bill of Materials (AI BOM / AIBOM)**:
  - Inventory all AI models in use, fine-tuning data, inference engines, and prompt templates
  - Record license, attribution, and export control (EAR/ITAR) classification for each component
  - Integrate AI BOM with SBOM (Software Bill of Materials) and store in VDR (→ §35)
- **AI Governance × IP Integration Checklist**:

```markdown
## GenAI × IP Governance Integration Checklist
### API & Model Management
- [ ] ToS reviewed for all AI model APIs in use (commercial use & training data conditions)
- [ ] Services with Enterprise contracts (non-training guarantee) documented
- [ ] Quarterly ToS change monitoring system in place

### Code Generation
- [ ] AI-generated code copyright attribution recording process established
- [ ] Duplicate Detection enabled for GitHub Copilot, etc.
- [ ] SAST/LINT for AI-generated code integrated into CI/CD
- [ ] AI contribution ratio recorded in PR templates

### Content Generation
- [ ] C2PA metadata attachment process for AI-generated content established
- [ ] EU AI Act §50 labeling compliance completed (before August 2026)
- [ ] Deep Fake / brand impersonation monitoring deployed

### AI BOM
- [ ] AI BOM prepared and integrated with SBOM/VDR
- [ ] AI model ECCN classification reviewed from EAR/ITAR perspective
- [ ] IP clearance for fine-tuning data completed
```


---

# XV. VC Fundraising & IP Milestones (§55)

---

## §55. VC Investment Round IP Milestone Framework

### Rule 63.410: Mandatory IP Readiness Standards by Round

> [!IMPORTANT]
> **IP gaps are a direct driver of valuation haircuts.** Achieve the following milestones at least 3 months before each round closes.

| Round | Target Raise | Required IP Milestones | Risk if Unmet |
|---|---|---|---|
| **Pre-Seed / Seed** | ~$2M | All IP assignment agreements signed, NDAs in place, core IP identified | Founder IP ownership gap surfaces during Series A DD |
| **Series A** | $2M–$15M | ≥1 patent filed, trademark registered (key markets), IP ledger established | 10–20% valuation reduction risk |
| **Series B** | $15M–$50M | ≥5 patents, clean OSS audit, automated SBOM generation | Fails Coatue / a16z DD standards; DDO standby costs incurred |
| **Series C+** | $50M+ | External IP valuation report, Exit Ready Scorecard ≥80%, AI-IP policy adopted | Strategic co-investors withdraw |
| **Pre-IPO** | — | Exit Ready Scorecard 100%, SEC/regulator disclosure prep complete, IP insurance in place | IPO review cites incomplete IP risk disclosure |

### Rule 63.411: Seed-Stage IP Priorities (Founder Checklist)

**Phase 1: Day-1 (Entity Formation)**
- [ ] IP Assignment Agreements executed by all founders (include prior invention exclusions)
- [ ] Copyright attribution confirmed for core code and algorithms (no freelance-era code included)
- [ ] Domain names registered under company entity
- [ ] Template NDAs ready (investor DD, recruiting)

**Phase 2: Before First External Capital or $1M ARR**
- [ ] Trademark pre-clearance search (USPTO/EUIPO/J-PlatPat) and filing decision
- [ ] Patent vs. trade secret analysis meeting for core IP (→ §6 Rule 63.050)
- [ ] Background IP declaration documenting boundary between founders' prior employer IP and company IP
- [ ] AI-generated code usage tracking begins

```yaml
# Seed Stage IP Checklist (store in GitHub repo Wiki)
seed_ip_checklist:
  day_one:
    - item: "IP Assignment Agreement - All Founders"
      owner: "Legal / CEO"
      deadline: "Day 1"
    - item: "Prior Invention Disclosure - All Founders"
      owner: "All Founders"
      deadline: "Day 1"
    - item: "Domain Registration under Company Entity"
      owner: "CTO"
      deadline: "Day 7"
  pre_series_a:
    - item: "Trademark Search + Filing Decision"
      owner: "Legal"
      deadline: "Before public launch"
    - item: "Core Patent Analysis (file vs. trade secret)"
      owner: "CTO + Legal"
      deadline: "Before Series A"
    - item: "OSS License Audit (SCA tool integration)"
      owner: "CTO"
      deadline: "Before Series A"
```

### Rule 63.412: Responding to VC-Side DD at Series A/B

**Common VC IP DD Questions (Prepare These Answers)**:

| VC Question | Required Response / Evidence |
|---|---|
| "Who owns the IP?" | IP Assignment Agreement list (all employees + founders) |
| "What OSS are you using?" | SBOM and SCA report (latest version) |
| "Any AI-generated code?" | AI usage policy and usage logs |
| "Are you infringing any competitor patents?" | FTO analysis report (core product area) |
| "What about the departed co-founder's IP?" | Assignment agreement + departure IP checklist completion certificate |
| "Do you have patents? What's the plan?" | Patent portfolio roadmap and filing timeline |

### Rule 63.413: IP as a Negotiating Asset in VC Term Sheets

- **IP Bargaining Power**: A strong IP portfolio provides valuation justification in Term Sheet negotiations
- **License Revenue Disclosure**: Report any existing license revenue as an MRR-equivalent metric in valuation models
- **IP Reps & Warranties (Preferred Stock Purchase Agreement)**:
  - Understand typical VC-required IP representations in advance
  - **MAC (Material Adverse Change) clauses**: Ensure material IP risks (e.g., pending patent litigation) are disclosed before closing to avoid triggering MAC conditions
- **VC-Led Patent Programs**: a16z, Google Ventures, and similar VCs offer IP-building support programs for portfolio companies — leverage them proactively

---

# XVI. IP Automation Under EU AI Act Full Enforcement (§56)

---

## §56. EU AI Act Article 53/96 Compliant IP Automation Pipeline

### Rule 63.420: EU AI Act IP Impact Map (Full Enforcement: August 2026)

| AI Act Article | Impact on IP Practice | Required Response |
|---|---|---|
| **Art. 10 (Training Data)** | Documentation obligation for data quality and appropriateness | Data Card + license record maintenance |
| **Art. 11 & Annex IV (Technical Documentation)** | GPAI & high-risk AI: create and maintain detailed technical docs | Automated Model Card generation pipeline |
| **Art. 12 (Record-Keeping)** | Autonomous systems must retain operation logs | Structured storage of AI agent logs |
| **Art. 13 (Transparency)** | Users must be notified when interacting with AI | AI usage disclosure in UI/UX |
| **Art. 50 (AI-Generated Content)** | Mandatory machine-readable marking of AI-generated content | Automated C2PA metadata attachment |
| **Art. 53 (GPAI Obligations)** | GPAI providers: publish copyright compliance policy + training data summary | Automated IP clearance reports |
| **Art. 96 (Rollback & Records)** | High-risk AI: maintain change history + decision records | Git-linked AI model version control |

### Rule 63.421: Article 53 Compliant Training Data IP Clearance Pipeline

```yaml
# EU AI Act Art.53 Compliant: Training Data IP Clearance Pipeline
name: GPAI Training Data IP Clearance
on:
  schedule:
    - cron: '0 0 1 * *'  # Monthly
  workflow_dispatch:

jobs:
  ip-clearance:
    runs-on: ubuntu-latest
    steps:
      - name: Scan training data licenses
        run: |
          python scripts/scan_dataset_licenses.py \
            --dataset-manifest datasets/manifest.json \
            --output reports/license_clearance_$(date +%Y%m).json
      
      - name: Check TDM opt-out compliance
        run: |
          # EU DSM Directive Art.4 TDM Opt-out verification
          python scripts/check_tdm_optout.py \
            --sources datasets/web_scrape_sources.txt \
            --output reports/tdm_optout_$(date +%Y%m).json
      
      - name: Generate copyright summary (Art. 53)
        run: |
          # Art.53(1)(d): Generate copyright compliance policy and training data summary
          python scripts/generate_copyright_summary.py \
            --clearance-report reports/license_clearance_$(date +%Y%m).json \
            --output public/training-data-summary.md
      
      - name: Upload to VDR and regulatory docs
        run: |
          ./scripts/upload-to-vdr.sh reports/ --category AI-Compliance
      
      - name: Notify IP team on failure
        if: failure()
        uses: slackapi/slack-github-action@v1
        with:
          channel-id: '#ip-compliance'
          slack-message: "Warning: AI Act Art.53 IP Clearance Failed - Review Required"
```

### Rule 63.422: Article 50 Compliant C2PA Content Authentication Automation

- **C2PA (Content Authenticity Initiative)** metadata must be automatically attached to AI-generated content
- **EU AI Act Art.50** (enforced August 2026): Machine-readable marking mandatory for AI-generated content

```python
# C2PA metadata attachment implementation (reference code)
# Execute in CI/CD after "AI Content Generation" step

from c2pa import Builder, SigningAlg, create_signer

def attach_c2pa_manifest(
    input_file: str,
    output_file: str,
    ai_model_name: str,
    ai_model_version: str,
    human_author: str,
    creation_timestamp: str
) -> None:
    """
    Attach C2PA manifest to AI-generated content to prove
    EU AI Act Art.50 compliance and copyright attribution.
    """
    manifest = {
        "claim_generator": "CompanyName/IPGovernanceSystem@1.0",
        "title": f"AI-Assisted Content - {creation_timestamp}",
        "assertions": [
            {
                "label": "c2pa.training-mining",
                "data": {"entries": {"c2pa.ai_generative_training": "notAllowed"}}
            },
            {
                "label": "stds.schema-org.CreativeWork",
                "data": {
                    "@type": "CreativeWork",
                    "author": [{"@type": "Person", "name": human_author}],
                    "description": (
                        f"Human-AI collaborative work. "
                        f"AI Model: {ai_model_name} v{ai_model_version}. "
                        f"Human creative judgment applied."
                    )
                }
            }
        ]
    }
    builder = Builder(manifest)
    # Retrieve signing keys from HSM/KMS (never hardcode)
    signer = create_signer(
        sign_cert="certs/company_ip_cert.pem",
        private_key="certs/company_ip_key.pem",
        alg=SigningAlg.ES256,
        tsa_url="http://timestamp.digicert.com"
    )
    builder.sign_file(signer, input_file, output_file)
```

### Rule 63.423: GPAI Technical Documentation (Article 11) Auto-Generation Template

```markdown
## GPAI Model Card / Technical Documentation (Art. 11 / Annex XI Compliant)
### Model Information
- Model Name: {model_name}
- Version: {version}  /  Last Updated: {date}
- Provider: {company_name}  /  Risk Tier: {risk_tier}

### Training Data Summary (Art. 53(1)(d))
| Dataset | License | Size | TDM Opt-out Compliant |
|---|---|---|---|
| {dataset_1} | {license} | {size} | Yes / No |

### Copyright Compliance Policy
- TDM opt-out monitoring: Monthly automated scan
- Issue data removal SLA: Within 48 hours
- Reference: [Training Data IP Clearance Report](./reports/license_clearance_latest.json)

### IP Attribution (→ §23 Rule 63.171)
- Human-authored components: {list}
- AI-generated components: {list}
- C2PA manifest: Attached
```

### Rule 63.424: EU AI Act Enforcement Schedule & IP Response Timeline

| Date | Enforcement Event | IP Response Required |
|---|---|---|
| **Aug 1, 2024** | AI Act enters into force | Understand GPAI rules; begin IP policy review |
| **Feb 2, 2025** | Prohibited AI practices apply | Assess IP risks from prohibited-use AI outputs |
| **Aug 2, 2025** | GPAI obligations apply (Art.53) | Training data IP clearance system operational |
| **Aug 2, 2026** | Full enforcement | Art.50 content marking, high-risk AI obligations fully met |
| **Ongoing** | Delegated acts / guidelines updates | Quarterly monitoring of EU AI Office publications |

---

# XVII. Clean Tech & Carbon Credit IP (§57)

---

## §57. Green IP, Carbon Credits & Integrated IP Strategy

### Rule 63.430: 2026 Climate Tech × IP Strategic Importance

- **Context**: Global climate investment surpassing ~$1.8T/year in 2024 makes cleantech patents among the fastest-growing IP categories
- **Investor expectations**: ESG-focused institutional investors evaluate "IP portfolios contributing to environmental improvement" as a non-financial KPI
- **International competition**: China holds 50%+ of global solar/EV/battery patents — early-filing strategies in Japan/EU/US are critical

### Rule 63.431: Green Patent Accelerated Examination Programs

| Office | Program | Examination Speed | Eligibility |
|---|---|---|---|
| **Japan (JPO)** | Super Accelerated Examination | 36 months → ~9 months | "Implemented" environment tech (carbon reduction, energy efficiency) |
| **US (USPTO)** | Climate Change Mitigation Pilot | ~12 months → 6 months | CPC Y02 subclass technologies |
| **Europe (EPO)** | PACE | ~24 months → 6 months | Written request (no conditions) |
| **China (CNIPA)** | Priority Examination (Green Tech) | ~22 months → 9 months | Energy saving, new energy, environmental protection |
| **WIPO** | WIPO GREEN | Matching platform | Register green tech IP for licensee matching |

```markdown
# Green Patent Filing Checklist
- [ ] Confirm technology falls under CPC Y02 (Climate Change Mitigation) subclass
- [ ] Apply for national green accelerated examination simultaneously with PCT base filing
- [ ] Register on WIPO GREEN platform (for licensee discovery)
- [ ] Include quantitative sustainability metrics in filing (e.g., CO₂ reduction/kWh efficiency gains)
```

### Rule 63.432: Carbon Credits × IP Legal Structure

Carbon credits (emission rights) are property rights but not IP rights per se. Indirect IP protection methods:

| Protected Subject | IP Method | Example |
|---|---|---|
| **Carbon Measurement Algorithm** | Patent + Trade Secret | MRV (Measurement, Reporting, Verification) process patents |
| **Carbon Market Platform** | Copyright + Patent | Exchange software, smart contracts |
| **Abatement Technology Itself** | Patent | CCUS (Carbon Capture, Utilization & Storage) process patents |
| **ESG Dataset** | DB Right (EU) + Contract | Proprietary high-precision emissions data collection & processing |
| **Certification Standards** | Copyright + Trademark | Proprietary carbon certification scheme IP protection |

```yaml
# Carbon IP Registry — IP Ledger Extension (→ §42 Rule 63.310)
carbon_ip_registry:
  patents:
    - title: "CO2 Measurement Algorithm v2 (CEMS Integration)"
      filing_date: "2025-01-15"
      jurisdiction: [US, EP, JP, CN]
      green_track: true
      cpc_code: "Y02P90/65"  # Climate Change Mitigation Technologies
      business_unit: "Climate Analytics"
  trade_secrets:
    - name: "Proprietary MRV Calculation Engine"
      access_level: "RESTRICTED"
      authorized_teams: ["climate-tech@company.com"]
      last_audit: "2026-Q1"
  trademarks:
    - mark: "CarbonVerify™"
      jurisdictions: [US, EU, JP]
      class: [42]  # Scientific and technological services
```

### Rule 63.433: Carbon Market IP Risk Management

- **Double-counting & fraud IP countermeasures**:
  - Blockchain-based carbon credit tokenization (→ §22) reduces double-counting risk
  - Protect the smart contract logic underlying token infrastructure as proprietary IP
  - Counter VCS/CORSIA/J-Credit certification imitation schemes: trademark protection of certification brands is effective

### Rule 63.434: Green IP ESG Portfolio Disclosure

- **TCFD/ISSB (IFRS S2) compliant disclosure**:
  - Quantitatively disclose number and technology domains of climate-related IP (CO₂ reduction, energy efficiency, circular economy)
  - Maintain flow diagrams showing how environmental technology patents contribute to product/service environmental performance

- **CSRD (EU Corporate Sustainability Reporting Directive) compliance**:
  - ESRS (European Sustainability Reporting Standards) requires disclosure of intangible assets including IP
  - **Disclosure example**: "Our patented technology (Patent No. EP0000000) reduces CO₂ emissions of Product Y by Z%, validating our climate commitment"

- **Greenwashing prevention (→ linked with §46 Rule 63.341)**:
  - Always separately report patent "acquisition" vs. "actual use and quantified effects"
  - Confirm alignment with EU Corporate Sustainability Due Diligence Directive (CSDDD)

### Rule 63.435: Clean Tech Technology Transfer & Geopolitical IP Risk

- **TRIPS Agreement & Compulsory Licensing (Green Tech)**:
  - TRIPS Article 31: Risk of compulsory licensing in national emergency (including climate response)
  - India, South Africa and others advocate applying compulsory licensing to green technology patents
  - **Mitigation**: Voluntary licensing listings on WIPO GREEN reduce regulatory risk

- **UNFCCC Technology Mechanism**:
  - Strategic engagement with international framework for technology transfer from developed to developing nations
  - Design transparent licensing programs to avoid being characterized as "protectionism"

---

# XVIII. IP Litigation Finance (§58)

---

## §58. Third-Party Litigation Finance (TPLF) for IP Enforcement

### Rule 63.440: IP Litigation Finance Overview \& Strategic Positioning
- **Market size (2025)**: The global TPLF (Third-Party Litigation Finance) market has grown to over $175B, with IP litigation as the largest segment
- **Basic structure**: Litigation financers fund all litigation costs (law firm fees, discovery, expert witnesses) and receive compensation as a percentage (typically 25–40%) or a multiple (2–4x) of the recovery from judgments or settlements
- **Strategic significance**:
  - Enables IP enforcement without equity dilution or balance sheet impact
  - May be the only viable means for cash-constrained startups to resist infringement by large corporations
  - VC investors increasingly view litigation finance as a legitimate IP protection mechanism for portfolio companies

### Rule 63.441: Key Litigation Funders \& Case Suitability

| Funder | Primary Case Types | Minimum Case Value | Notes |
|---|---|---|---|
| **Burford Capital** | Patents, trademarks, license contract breaches | $5M+ | Largest funder; also offers portfolio financing |
| **Harbour Litigation Funding** | Composite IP portfolios | $3M+ | Strong in European and Asian cases |
| **Longford Capital** | US patent litigation (incl. ITC) | $2M+ | Specialized ITC Section 337 team |
| **Woodsford** | UPC-compliant European patents | €1M+ | Focused on European patent litigation post-UPC |
| **Parabellum Capital** | Trade secrets, unfair competition | $5M+ | Specialized in tech company trade secret cases |

```yaml
# IP Litigation Finance — Case Suitability Assessment Checklist
ip_litigation_finance_assessment:
  merit_indicators:
    - "Patent validity confidence ≥ 70% (outside counsel opinion)"
    - "Infringement clearly demonstrable via claim chart"
    - "Recoverable damages ≥ $5M (patent) / ≥ $2M (trade secret)"
    - "Defendant collectability confirmed"
    - "Statute of Limitations has adequate time remaining"
  disqualifiers:
    - "Asserted patent at high risk of invalidation by prior art"
    - "Infringement proof relies solely on circumstantial evidence"
    - "Defendant already in bankruptcy proceedings or asset concealment suspected"
```

### Rule 63.442: Mandatory Clauses in Funding Agreements
- **Disclosure Obligation**: Many US federal courts now require disclosure of litigation finance agreements (2024 NJ and California district court rules) — pre-confirm disclosure scope
- **Funder Control Limitations**:
  - Final settlement authority must remain with the client company (prohibit funder-directed forced settlement)
  - Clearly restrict funder veto rights over litigation strategy changes (law firm substitution, addition)
- **Non-Recourse Confirmation**: Explicitly state this is Non-Recourse financing (no claim on company assets upon losing)
- **Privilege Protection**: Verify Attorney-Client Privilege (ACP) protection for information disclosed to funder — confirm applicability of Common Interest Privilege
- **Assignment Restrictions**: Notice and consent conditions if funding agreement may be sold to secondary market
- **EXIT Provisions**: Treatment of funding agreement upon M\&A or IPO (early repayment terms, rights succession)

### Rule 63.443: IP Finance Disclosure to VCs / Investors
- **DD Positioning**: Litigation finance agreements should be included in financial models as "Contingent Assets" not "Contingent Liabilities"
- **R\&W Impact**: Appropriately disclose existence of litigation finance agreements in M\&A (pre-assess Change of Control clause implications)
- **IPO Impact**: Disclose financed litigation in progress in SEC Form S-1 if the case outcome could materially impact business or financials

### Rule 63.444: Ethical \& Regulatory Considerations
- **Attorney Ethics Rules**: Confirm funder control does not violate Model Rules of Professional Conduct 1.8(f) (third-party compensation) and 5.4 (division of legal fees)
- **Japan**: TPLF legality is a gray zone under Attorney Act §72 (non-attorney legal services) — confirm distinction from direct fee-bearing schemes with legal counsel for domestic cases
- **EU Regulatory Trend**: European Parliament reviewing TPLF directive (2024–2025) — potential mandatory capital requirements and conflict of interest disclosure for funders
- **Tax Treatment**: Tax treatment of litigation finance proceeds (funder's share of recovery) varies by jurisdiction (US: generally treated as Ordinary Income)

---

# XIX. Layered IP Protection Strategy (§59)

---

## §59. IP Stacking: Hybrid Layered IP Protection Framework

### Rule 63.450: Design Principles for Layered IP Protection

> [!IMPORTANT]
> **Never rely on a single IP right. Layer multiple IP rights strategically so that if a competitor circumvents one right, others remain operative — building a "multi-line defense."**

- **IP Stacking defined**: Strategically combining patents, trademarks, copyrights, design rights, trade secrets, database rights, and contractual protections for a single product or technology
- **Why it matters**:
  - Patents expire after 20 years, but trademarks can persist indefinitely through renewal
  - Even if a patent is invalidated in an IPR proceeding, trade secret protection survives
  - Trademark, copyright, and design rights compensate when AI-generated alternatives circumvent patents

### Rule 63.451: Product-Level IP Stacking Matrix

| Protected Asset | Patent | Trademark | Copyright | Design Right | Trade Secret | Database Right | Contract |
|---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| **Core Algorithm** | ✅ | — | △ | — | ✅ | — | ✅ NDA |
| **UI/UX Design** | — | ✅ | ✅ | ✅ | △ | — | ✅ |
| **Brand Name/Logo** | — | ✅✅ | ✅ | ✅ | — | — | ✅ |
| **Trained AI Model** | △ | — | △ | — | ✅✅ | ✅(EU) | ✅ ToS |
| **Dataset** | — | — | — | — | ✅ | ✅✅(EU) | ✅ |
| **API Endpoint Design** | △ | — | ✅ | — | ✅ | — | ✅ |
| **Prompt Templates** | — | — | △ | — | ✅✅ | — | ✅ |
| **Hardware Product** | ✅✅ | ✅ | — | ✅ | ✅ | — | ✅ |

✓✓: Strongly recommended, ✓: Recommended, △: Conditional, —: Not applicable

### Rule 63.452: IP Protection Timeline Strategy

```markdown
## IP Stacking Timeline (10-Year Defense Roadmap from Launch)
| Phase | Period | Primary IP Instruments | Supplementary Instruments |
|---|---|---|---|
| **Launch Phase** | Day 1-12M | Trademark (clearance search → filing) + NDA | Copyright (auto-arises) |
| **Growth Phase** | 12-36M | Patent filing (core inventions) + Design filings | Database rights (EU) |
| **Expansion Phase** | 36-84M | Continuation strategy + International trademark expansion | Trade secret hardening |
| **Maturity Phase** | 84M+ | Patent expiry countermeasures → shift emphasis to trademark/copyright | IPCo utilization (→§53) |
```

### Rule 63.453: Anti-Design-Around Stacking

- **Single-patent dependency risk**: Competitors intentionally design around patents to create non-infringing substitute products
- **Countermeasures**:
  1. **Claim bracketing**: Beyond core patent, file continuation applications covering implementation variations (→ §8 Rule 63.072)
  2. **Design right UI bracketing**: Protect GUI visual expression via design rights so that functional design-arounds still constitute infringement on appearance
  3. **Trademark market lock**: Register product names, logos, sounds, colors as multiple trademarks so competitors cannot launch products that "look the same"
  4. **Trade secret moat**: Keep the most critical "Secret Sauce" undisclosed and maintained as a trade secret (→ §6 Rule 63.050)

### Rule 63.454: IP Stacking for Spatial Computing and Wearables

- **IP strategy for MR/XR products (Apple Vision Pro-class)**:
  - **Depth sensing / eye-tracking**: Patent sensor fusion algorithms
  - **Hand gesture UI**: GUI design rights + touchless interaction patents
  - **Spatial audio**: Patent audio processing algorithms + trademark spatial audio brand
  - **Brand display in virtual space**: 3D trademark registration for virtual brands (USPTO 3D marks)
  - For IP infringement in virtual worlds, **international arbitration clauses (WIPO / ICC) must be mandated in all license agreements**

- **Neurotech / BCI Wearable IP priorities**:
  - **Neural data is PII at the highest confidentiality tier**: Neural signal data carries extremely high re-identification risk; treat as "special category data" under GDPR/APPI maximum-sensitivity provisions
  - **Data collection consent and IP intersection**: Repurposing research neural data for commercial AI model training requires additional consent and copyright clearance
  - **Ethics review integration**: Integrate IP rights attribution clarification into IRB (Institutional Review Board) approval workflows

---

# XX. Sovereign IP & National Security (§60)

---

## §60. Sovereign IP & National Security IP Framework

### Rule 63.460: CHIPS Act and IP Governance (US and Allies)

> [!CAUTION]
> **Companies receiving CHIPS Act subsidies are subject to mandatory government access rights, compulsory license conditions, and Clawback provisions on covered IP. Align IP strategy with subsidy applications before filing.**

- **Key IP-related obligations under the CHIPS and Science Act (2022)**:
  - **Profit-sharing provision**: If profits exceed a defined threshold after subsidy receipt, a portion of the excess must be returned to the government
  - **Compulsory license risk**: Provisions allowing government to obtain licenses to subsidized technologies when national security requires it
  - **Foreign Entity of Concern (FEOC) restrictions**: For 10 years after subsidy receipt, prohibited from material technology sharing or joint ventures with China, Russia, North Korea, or Iran
  - **Reporting obligations**: Periodic reporting on technology usage and licensing activity

```yaml
# CHIPS Act IP Compliance Checklist
chips_act_ip_compliance:
  pre_application:
    - "Identify and catalog subsidy-eligible IP (patents, manufacturing processes, know-how)"
    - "Reflect profit-sharing thresholds in financial models"
    - "Assess FEOC restriction impact on current and future license agreements"
  during_performance:
    - "Establish quarterly IP usage reporting framework"
    - "Implement FEOC pre-clearance workflow for technical sharing with foreign partners"
  post_completion:
    - "Monitor FEOC technology sharing prohibition compliance for 10 years"
    - "Annual assessment of profit levels that trigger Clawback provisions"
```

### Rule 63.461: Dual-Use Research of Concern (DURC) and IP Governance

- **DURC defined**: Research conducted for legitimate scientific purposes that carries an unintended risk of posing a threat to public health, safety, security, economic security, or national security
- **Impact on IP strategy**:
  - Results of DURC-designated research are subject to Research Security rules under US NSPM-33 (National Security Presidential Memorandum)
  - Joint research, publication, and patent filing with foreign researchers may require **government pre-review**
  - OSS releases and tech blog publications of findings may also be subject to controls as "Deemed Exports"

- **DURC Risk Assessment Framework**:
  1. **Technology classification**: Cross-reference against NSPM-33 critical and emerging technology list (AI, quantum, bio, advanced manufacturing, space)
  2. **Funding source verification**: Identify foreign government/corporate funding and conduct FRGC (Foreign Research Grant Compliance) review
  3. **Co-author/access review**: Apply Need-to-Know access restrictions to foreign national researchers
  4. **Document protective measures**: Maintain records of IP protection measures and access controls as DD evidence

### Rule 63.462: EU Critical Raw Materials Act and IP Supply Chains

- **EU Critical Raw Materials Act (CRM Act, in force 2024)**:
  - IP protection for mining and processing technologies for strategic materials (lithium, cobalt, rare earths) is becoming a key European industrial policy issue
  - **IP obligations overview**:
    - Companies receiving public subsidies for CRM Act-targeted projects are expected to disclose IP portfolios and maintain transparency around technology transfer conditions
    - Technology transfers or licenses to Chinese entities may trigger advance notification obligations
  - **Strategic implication**: Integrate CRM-related IP (manufacturing process patents, refining technology) across the supply chain with geopolitical risk assessment (→ §51)

### Rule 63.463: Advanced FDI Review and IP Intersection

- **CFIUS Post-FIRRMA Strengthening (2022 TID Rulesets)**:
  - **Expanded TID US Business definition**: Companies handling Critical Technologies, Critical Infrastructure, or sensitive data face mandatory declaration requirements
  - **Critical Technology**: EAR-controlled, ITAR-controlled, and NSF-designated emerging technologies — cross-reference with IP portfolio is mandatory
  - Pre-assess that IP transfer via M&A to foreign parties is a primary CFIUS trigger (→ §51 Rule 63.373)

- **UK National Security and Investment Act (NSI Act, 2022)**:
  - M&A, IP licensing, and joint ventures in 17 critical sectors (AI, quantum, advanced materials, engineering biology, defense) require **mandatory advance notification**
  - Standalone assignment of IP (patent/trade secret transfer) may also require review (confirm 2024 guidance)

- **Japan FEFTA Tightening Trends**:
  - Scrutiny of foreign capital IP control in core sectors (semiconductors, AI, space, defense) is intensifying
  - For M&A involving IP transfer of "technologies with high technical superiority," pre-consultation with authorities is recommended

### Rule 63.464: Sovereign IP Strategy (Responding to National-Level IP Protection)

- **"Sovereign AI" policies and IP**:
  - Many countries are asserting sovereignty over domestic AI infrastructure and training data. Risk that enterprises face restrictions on transferring or licensing domestically-developed AI models abroad
  - **Countermeasure**: Design "local IP holding structures" via country-specific legal entities (→ §61 IP Deal Architecture)

- **Data Localization Laws vs. IP**:
  - Data localization mandates from Russia (FZ-242), China (PIPL/DSL), India (DPDP), and others impede free movement of global IP data
  - Localization obligations for **training data and model weights** must be pre-assessed with local legal experts in each jurisdiction

---

# XXI. IP-Centric Deal Architecture (§61)

---

## §61. M&A and Fundraising Deal Design with IP at the Core

### Rule 63.470: Principles of IP-Centric Deal Structuring

> [!IMPORTANT]
> **"Where IP sits" determines the deal's tax efficiency, risk allocation, and integration cost. Make IP strategy the first item on the deal design agenda.**

- **Deal design differences by IP Siting**:
  - **OpCo-IPCo structure**: Separate IP holding company (IPCo) from operating company (OpCo); OpCo licenses IP from IPCo
    - In M&A: Acquirer can take only IPCo while leaving OpCo behind (business risk separation)
    - Bankruptcy protection: IPCo remains independent and can continue operations even if OpCo files for bankruptcy
  - **Single-entity structure**: Hold IP integrated within the operating company — practical from a management cost perspective for startups and SMEs

### Rule 63.471: Precision Design of IP Earnout Mechanisms

- **IP Earnout defined**: Structure in which additional consideration is paid after M&A closing when IP achieves specific revenue or milestone triggers
- **Checklist and mandatory clauses**:
  - [ ] **Earnout Base**: Explicitly identify which IP's revenue (license fees / product sales / patent verdict recovery) forms the calculation base
  - [ ] **Calculation period**: Typically 12-36 months; calibrate to technology maturation speed
  - [ ] **Acceleration clause**: Triggers for accelerated payment if acquirer intentionally undermines Earnout by not actively licensing the IP
  - [ ] **Milestone definitions**: Define specifically — "patent grant," "initial license revenue $1M," "FDA/CE Mark obtained," etc.
  - [ ] **Accounting and audit rights**: Seller's right to have an independent accountant verify Earnout calculations (Audit Right)
  - [ ] **MAC carveout**: Clause exempting Earnout shortfall caused by market-wide collapse (pandemic/war)

```yaml
# IP Earnout Calculation Model (Conceptual Example)
ip_earnout_model:
  base_consideration: "$50M (at closing)"
  earn_out_period: "36 months"
  milestones:
    - trigger: "Patent EP0000000 European registration complete"
      payment: "$2M"
      deadline: "Within 18 months of closing"
    - trigger: "Cumulative license revenue $5M achieved"
      payment: "$5M (capped at 20% of profit)"
      deadline: "Within 36 months of closing"
    - trigger: "FTO analysis confirmed clean (core product area)"
      payment: "$1M"
      deadline: "Within 6 months of closing"
  acceleration_trigger: "Acquirer ceases licensing activity on covered IP within 12 months of agreement"
  acceleration_amount: "50% of remaining unclaimed Earnout paid immediately"
```

### Rule 63.472: Advanced IP Escrow Design

- **Enhancing standard Escrow (→ §30 Rule 63.221)**:
  - **IP-dedicated Escrow account**: Segregate a portion of M&A consideration (typically 10-20%) into a dedicated IP Escrow account for IP-related R&W breach coverage
  - **Basket / Deductible**: Set minimum IP claim thresholds (De Minimis: $50K-$200K) and aggregate mini-basket (1-2%)
  - **Reverse Break-up Fee**: Contractually specify compensation to seller if acquirer refuses to close citing CFIUS review or IP regulatory issues

- **Source Code Escrow**:
  - In SaaS company M&A/fundraising, acquirers/investors may require source code to be deposited with a third-party Escrow agent
  - **Major agents**: Iron Mountain / NCC Group / EscrowTech
  - **Release triggers**: Licensee obtains source code access upon business cessation, bankruptcy, or material breach
  - **Update obligations**: Quarterly source code updates and re-deposit to escrow

### Rule 63.473: IP Protection and Financing via SPV (Special Purpose Vehicle)

- **IP-SPV structure**:
  1. Parent company transfers specific IP portfolio to an SPV
  2. SPV securitizes/issues bonds against IP collateral or raises third-party financing
  3. Parent company receives license-back from SPV (maintaining business continuity)

- **IP-SPV use cases**:
  - Debt financing using IP as collateral without impairing the balance sheet
  - Bankruptcy-remote structure protecting IP from litigation and insolvency risks
  - Carve-out sale of only specific IP assets in M&A

- **Tax and accounting considerations**:
  - IP transfer to SPV requires transfer pricing valuation based on Arm's Length Principle (ALP)
  - Confirm compliance with IFRS/GAAP intangible asset recognition and amortization rules
  - Pre-assess whether BEPS Pillar Two global minimum tax of 15% applies to the SPV jurisdiction (→ §53 Rule 63.392)

### Rule 63.474: IP Considerations in Secondary Transactions

- **IP risks in the secondary market**:
  - LP interest transfers and GP succession make portfolio company IP status a key DD target
  - **Continuation Vehicles (CVs)**: Fund-specific entities holding specific portfolio company IP for long-term — IP asset valuation is the core of the reference price
  - IP obsolescence risk and injunction risk fluctuate during the CV operation period — mandate annual IP re-valuation

- **IP protection in GP-led secondaries**:
  - Pre-confirm that Change of Control clauses may apply even when LP interests transfer from old to new investors
  - Review "sponsor change clauses" in target company NDAs and license agreements

---

## Appendix A: Quick Reference Index

> Index for quickly identifying relevant sections by task or keyword.

| Keyword | Related Section |
|---|---|
| CLA / Contributors | §2, §5 |
| IP Assignment / Work for Hire | §1, §4, §5 |
| Joint Development / JV | §3 |
| Employee Departure / IP | §4 |
| Patent Filing / Defensive Publishing | §6, §7, §8 |
| Patent Portfolio | §8, §28 |
| SEP / FRAND | §9, §53, §54 |
| Software Patent / Alice | §10 |
| Design Patent / Design Rights | §11 |
| UPC / Unitary Patent / European IP | §12, §40 |
| Trade Secret | §6, §13 |
| NDA / Confidentiality | §14 |
| Remote Work / BYOD | §15 |
| GenAI / AI Copilot / LLM Risk | §16, §23, §24, §26 |
| Trademark / Brand | §17, §18 |
| Domain / DNS | §19 |
| Copyright Registration / USCO | §20 |
| Data Rights / Database Rights / EU Data Act | §21 |
| NFT / Tokenization / Blockchain | §22 |
| AI Copyright / AI-Generated Content | §23 |
| AI Invention / AI Patent / USPTO | §24 |
| Training Data / TDM | §25 |
| AI-IP Governance | §26 |
| M&A / Acquisition | §27, §30, §33, §36 |
| IPO / Public Listing | §27, §31 |
| SPAC / De-SPAC | §27, §32 |
| Direct Listing | §27 |
| IP Valuation | §28 |
| Exit Readiness / Roadmap | §29 |
| R&W / Representations & Warranties | §30, §45 |
| IPO Disclosure / SEC | §31, §32 |
| Post-Merger / PMI | §33 |
| Carve-out / Spin-off | §34 |
| Data Room / VDR | §35 |
| DD Checklist | §36 |
| Technical DD | §37 |
| OSS DD / License DD | §38 |
| Vendor Lock-in | §39 |
| Cross-border Disputes / ITC / WIPO Arbitration | §40 |
| IP-backed Financing | §41 |
| IP Ledger / Inventory | §42 |
| IP Infringement / Litigation | §43 |
| Maturity Model | §44 |
| IP Insurance | §45 |
| ESG / Sustainability / Green Patent | §46, §57 |
| Open Innovation / CVC / University-Industry | §47 |
| Compliance Timeline | §48 |
| IP Education / IP Champion | §49 |
| Quantum / Web3 / Metaverse / Future Tech | §50 |
| PQC / Post-Quantum Cryptography IP | §50 |
| Agentic AI / MCP / A2A IP | §50, §52 |
| OSS AI Fine-Tuning / LoRA / QLoRA | §50 |
| Garden Leave / Non-compete | §4 |
| UDRP / Domain Disputes | §18 |
| Geopolitics / Export Controls / EAR / ITAR / CFIUS | §51 |
| Tech Decoupling / FDI Review / Inbound Investment | §51 |
| GenAI Supply Chain / AI ToS / AI BOM | §52 |
| Deep Fake / AI-Generated Content / C2PA | §52, §56 |
| AI Agents / Agent Output / Copyright Attribution | §23, §52 |
| IP Monetization / Licensing / Patent Pool / IPCo | §53 |
| PAE / NPE / IPR Review / Patent Invalidation | §53 |
| Antitrust / Competition Law / Monopoly | §54 |
| GenAI Monopoly / AI Foundation Model / DMA / TTBER | §54 |
| Patent Evergreening / Continuation Legitimacy | §54, §8 |
| VC Fundraising / Series A / Seed IP | §55 |
| IP Readiness / Round-by-Round Milestones | §55 |
| EU AI Act / GPAI / Art.53 / Art.50 | §56, §25 |
| C2PA / Content Authentication / AI Content Marking | §52, §56 |
| Green Patent / Carbon / Clean Tech | §57, §46 |
| Carbon Credits / CCUS / MRV | §57 |
| CSRD / TCFD / ISSB / ESG Disclosure | §57, §46 |
| Litigation Finance / TPLF / Burford / Success Fee | §58 |
| IP Enforcement / Non-Recourse / Funding | §58, §43 |
| Contingent Asset / Litigation Cost / IPO Disclosure (Active Suit) | §58, §31 |
| Layered IP Protection / Stacking / Hybrid Strategy | §59 |
| National Security / CHIPS Act / CFIUS / Sovereign IP | §60, §51 |
| DURC / Dual-Use Research / Advanced Export Controls | §60, §51 |
| Deal Architecture / Earnout IP Mechanism / IP Escrow | §61, §30 |
| SPV / IP HoldCo / Ring-Fencing | §61, §53 |
| Spatial Computing / Neurotech / XR | §50, §59 |
| Global Jurisdiction IP Protection Matrix | Appendix B |

---

## Appendix B: Global Jurisdiction IP Protection Matrix

> A quick-reference table for cross-jurisdictional comparison of representative IP rights in major legal systems. For details, see the respective sections (§1-§12, §20-§21, §51).

| Protected Asset | 🇺🇸 US | 🇯🇵 Japan | 🇪🇺 EU (unified) | 🇨🇳 China | 🇮🇳 India | 🇧🇷 Brazil |
|---|---|---|---|---|---|---|
| **Patents** | USPTO (20yr) / AIA first-to-file | JPO (20yr) first-to-file | EPO + UPC (20yr) | CNIPA (20yr) | IPO (20yr) | INPI (20yr) |
| **Utility Models** | — | JPO (10yr) | Country-level (DE etc.) | CNIPA (10yr) | — | INPI (15yr) |
| **Trademarks** | USPTO (10yr renewal) prior-use rights | JPO (10yr renewal) first-to-file | EUIPO (10yr renewal) | CNIPA (10yr renewal) first-to-file | IPO (10yr renewal) | INPI (10yr renewal) |
| **Design Rights** | Design Patent (15yr) | Design Registration (25yr) | RCD (25yr) / UCD (3yr) | CNIPA (15yr) | IPO (15yr) | INPI (10yr) |
| **Copyright** | Author+70yr (optional registration) | Author+70yr (no formality) | Author+70yr (no formality) | Author+50yr | Author+60yr | Author+70yr |
| **Trade Secrets** | DTSA / state laws | Unfair Competition Prevention Act | Trade Secrets Directive | Anti-Unfair Competition Law (2019 amendment) | Trade Secrets Act 2018 | Civil Code |
| **Database Rights** | Copyright law only (no sui generis) | Copyright law (compilation works) | Directive 96/9/EC (15yr) | Copyright law | — | — |
| **AI Inventorship** | Natural persons only (2025 revised guidance) | Natural persons only | Natural persons only (Dabus 2025 final) | Natural persons only | — | — |
| **AI-Authored Works** | Human creative contribution required (USCO 2025 Report) | Human creative contribution required | Labeling obligation + human contribution required | — | — | — |
| **FDI/IP Review Body** | CFIUS (FIRRMA) | Foreign Exchange Council (FEFTA) | EU FDI Screening Framework | SAMR / CSRC | FIPB (abolished) → automatic approval | CADE |
| **Green Patent Fast Track** | USPTO Climate Change Mitigation Pilot | JPO Super Early Examination | EPO PACE | CNIPA Priority Examination | IPO Green Channel | — |

---

## Cross-References

| Reference | Related Topics |
|---|---|
| [000_security_privacy.md](../security/000_security_privacy.md) | Access control, encryption, DLP, Zero Trust, AI-SPM (§13, §15, §16, §52) |
| [100_data_governance.md](../security/100_data_governance.md) | Data protection regulation, AI regulation, GDPR, EU Data Act (§21, §23, §25, §48, §60) |
| [200_oss_compliance.md](../security/200_oss_compliance.md) | SBOM, SCA, license compliance, SLSA, AI BOM (§5, §35, §38, §52) |
| [000_qa_testing.md](../quality/000_qa_testing.md) | Test coverage, code quality metrics (§37) |
| [400_site_reliability.md](../operations/400_site_reliability.md) | Availability, backup, DR (§37) |
| [500_incident_response.md](../operations/500_incident_response.md) | Incident response flow (§43) |
| [000_ai_engineering.md](../ai/000_ai_engineering.md) | AI implementation strategy, guardrails, RAG design, Agentic AI (§23, §24, §26, §52, §59) |
| [000_product_strategy.md](../product/000_product_strategy.md) | Monetization models, exit strategy business perspective (§27, §28, §53, §61) |
| [300_revenue_monetization.md](../product/300_revenue_monetization.md) | FinOps, payments, IP valuation financial perspective (§28, §41, §53, §61) |
