# 63. IP Strategy & Due Diligence

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-03-24

> [!IMPORTANT]
> **Supreme Directive**
> "Intellectual property is the invisible moat — unprotected IP is an invitation to competitors."
> All IP decisions must treat protection, ownership clarity, and due diligence as non-negotiable.
> Strictly follow: **IP Protection > Legal Compliance > Business Strategy > Speed**.
> **50 Sections.**

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
- [Appendix A: Quick Reference Index](#appendix-a-quick-reference-index)

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
| **2028** | Japan: Next Unfair Competition Prevention Act amendment (under review) | Monitor trade secret and limited-provision data protection trends |

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
| **Web3/Decentralized Apps** | Patents + trade secrets (smart contract logic) | OSS-first ecosystem — careful license strategy design |
| **Metaverse/XR** | Design rights (virtual space) + trademarks (virtual brands) | Jurisdiction issues for IP infringement in virtual worlds |
| **BMI (Brain-Machine Interface)** | Patents + trade secrets + ethics review | Intersection with medical device regulations, bioethics |
| **Synthetic Biology** | Patents (gene sequences, bioprocesses) + trade secrets | Utility of natural laws, lessons from CRISPR patent disputes |
| **Edge AI** | Patents (on-device models) + trade secrets (training data processing) | IP protection for model compression techniques |

### Rule 63.361: Building Future Technology IP Portfolios
- **Early filing strategy**: Secure foundational patents before technology matures
- **Defensive publishing**: Defensively publish technology directions you won't pursue to block competitor patents
- **Standards participation**: Join emerging technology standards bodies (W3C / IEEE / IETF) for SEP acquisition
- **Technology roadmap alignment**: Sync 3-5 year technology roadmaps with IP filing strategy

---

## Appendix A: Quick Reference Index

> Index for quickly identifying relevant sections from tasks or keywords.

| Keyword | Related Sections |
|---|---|
| CLA / Contributor | §2, §5 |
| IP Assignment / Work for Hire | §1, §4, §5 |
| Joint Development / JV | §3 |
| Employee Departure / Exit IP | §4 |
| Patent Filing / Defensive Publication | §6, §7, §8 |
| Patent Portfolio | §8, §28 |
| SEP / FRAND | §9 |
| Software Patent / Alice Test | §10 |
| Design Patent / Design Rights | §11 |
| UPC / Unitary Patent | §12, §40 |
| Trade Secret | §6, §13 |
| NDA / Confidentiality | §14 |
| Remote Work / BYOD | §15 |
| GenAI / AI Copilot / LLM Risk | §16, §23, §24, §26 |
| Trademark / Branding | §17, §18 |
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
| Representations & Warranties | §30, §45 |
| IPO Disclosure / SEC | §31, §32 |
| Post-Merger / PMI | §33 |
| Carve-out / Spin-off | §34 |
| Data Room / VDR | §35 |
| DD Checklist | §36 |
| Technical DD | §37 |
| OSS DD / License DD | §38 |
| Vendor Lock-in | §39 |
| Cross-Border Disputes / ITC / WIPO Arbitration | §40 |
| IP-backed Financing | §41 |
| IP Ledger / Inventory | §42 |
| IP Infringement / Litigation | §43 |
| Maturity Model | §44 |
| IP Insurance | §45 |
| ESG / Sustainability / Green Patent | §46 |
| Open Innovation / CVC / University-Industry | §47 |
| Compliance Timeline | §48 |
| IP Education / IP Champion | §49 |
| Quantum / Web3 / Metaverse / Future Tech | §50 |
| Garden Leave / Non-compete | §4 |
| UDRP / Domain Disputes | §18 |

---

## Cross-References

| Reference | Related Topics |
|---|---|
| [600_security_privacy.md](../security/000_security_privacy.md) | Access control, encryption, DLP, Zero Trust (§13, §15, §16) |
| [601_data_governance.md](../security/100_data_governance.md) | Data protection regulation, AI regulation, GDPR, EU Data Act (§21, §23, §25, §48) |
| [602_oss_compliance.md](../security/200_oss_compliance.md) | SBOM, SCA, license compliance, SLSA (§5, §35, §38) |
| [700_qa_testing.md](../quality/000_qa_testing.md) | Test coverage, code quality metrics (§37) |
| [502_site_reliability.md](../operations/400_site_reliability.md) | Availability, backup, DR (§37) |
| [503_incident_response.md](../operations/500_incident_response.md) | Incident response flow (§43) |
| [400_ai_engineering.md](../ai/000_ai_engineering.md) | AI implementation strategy, guardrails, RAG design (§23, §24, §26) |
| [100_product_strategy.md](../product/000_product_strategy.md) | Monetization models, exit strategy business perspective (§27, §28) |
| [101_revenue_monetization.md](../product/300_revenue_monetization.md) | FinOps, payments, IP valuation financial perspective (§28, §41) |

### Cross-References

| Section | Related Rules |
|---------|---------------|
| §1–§10 (IP Strategy & Registration) | `100_product_strategy`, `000_core_mindset` |
| §11–§20 (Patent & Trade Secret) | `600_security_privacy` |
| §21–§30 (OSS & License) | `602_oss_compliance` |
| §31–§40 (AI & Data IP) | `400_ai_engineering`, `601_data_governance` |
| §41–§50 (Contracts & Compliance) | `801_governance`, `103_appstore_compliance` |
