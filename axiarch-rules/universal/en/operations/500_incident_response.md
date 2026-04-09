# 53. Crisis Management & BCP

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-03-24

> [!IMPORTANT]
> **Supreme Directive**
> - During a crisis, **business continuity and human safety** take absolute priority over all other concerns (cost, schedule, feature development).
> - "Delayed reporting" is synonymous with "delayed response." Upon detecting an incident, **escalate immediately** regardless of its perceived severity.
> - Ignoring or bypassing the protocols defined in this document constitutes a **serious constitutional violation** under any circumstances.
> **20 Parts, 47 Sections.**

---

## Table of Contents

- [Part I: Foundation & Philosophy](#part-i-foundation--philosophy)
- [Part II: Risk Analysis & Preparation](#part-ii-risk-analysis--preparation)
- [Part III: Incident Response](#part-iii-incident-response)
- [Part IV: AI Threat Response](#part-iv-ai-threat-response)
- [Part V: Communication](#part-v-communication)
- [Part VI: Business Continuity](#part-vi-business-continuity)
- [Part VII: Disaster Recovery](#part-vii-disaster-recovery)
- [Part VIII: Exercises & Verification](#part-viii-exercises--verification)
- [Part IX: Post-Incident](#part-ix-post-incident)
- [Part X: Governance & Maturity](#part-x-governance--maturity)
- [Part XI: DORA/Regulatory Compliance Integration](#part-xi-dora--regulatory-compliance-integration)
- [Part XII: AI-Driven Incident Management](#part-xii-ai-driven-incident-management)
- [Part XIII: Climate Resilience](#part-xiii-climate-resilience)
- [Part XIV: Geopolitical Risk](#part-xiv-geopolitical-risk)
- [Part XV: Pandemic BCP](#part-xv-pandemic-bcp)
- [Part XVI: Incident Automation](#part-xvi-incident-automation)
- [Part XVII: Cyber Insurance](#part-xvii-cyber-insurance)
- [Part XVIII: Reputation Recovery](#part-xviii-reputation-recovery)
- [Part XIX: Human Factors](#part-xix-human-factors)
- [Part XX: Physical Security](#part-xx-physical-security)
- [Part XXI: Crisis Management FinOps](#part-xxi-crisis-management-finops)
- [Part XXII: NIS2 Directive Integration](#part-xxii-nis2-directive-integration)
- [Part XXIII: EU CRA Integration](#part-xxiii-eu-cra-integration)
- [Part XXIV: Incident Reporting International Harmonization](#part-xxiv-incident-reporting-international-harmonization)
- [Part XXV: Quantum Computing Threats](#part-xxv-quantum-computing-threats)
- [Part XXVI: OT/ICS/SCADA Crisis Management](#part-xxvi-oticsscada-crisis-management)
- [Part XXVII: Legal Readiness](#part-xxvii-legal-readiness)
- [Part XXVIII: Advanced Exercise Programs](#part-xxviii-advanced-exercise-programs)
- [Part XXIX: Multi-Cloud DR](#part-xxix-multi-cloud-dr)
- [Part XXX: Zero-Day Vulnerability Response (Details)](#part-xxx-zero-day-vulnerability-response-detailed)
- [Part XXXI: Crisis Management Regulatory Timeline](#part-xxxi-crisis-management-regulatory-timeline)
- [Part XXXII: EU Digital Omnibus Package Integration](#part-xxxii-eu-digital-omnibus-package-integration)
- [Part XXXIII: Crisis Team Education & Training Framework](#part-xxxiii-crisis-management-team-education--training-framework)
- [Part XXXIV: Digital Twin DR](#part-xxxiv-digital-twin-dr)
- [Part XXXV: Incident Fatigue & Alert Optimization](#part-xxxv-incident-fatigue--alert-optimization)
- [Part XXXVI: Cyber Range & AI Red Team](#part-xxxvi-cyber-range--ai-red-team)
- [Part XXXVII: Ransomware Negotiation & IR Retainer](#part-xxxvii-ransomware-negotiation--ir-retainer)
- [Part XXXVIII: CISO/Management Liability & Board Reporting](#part-xxxviii-ciso--management-liability-and-board-reporting)
- [Part XXXIX: Self-Healing & Autonomous Recovery](#part-xxxix-self-healing--autonomous-recovery-systems)
- [Part XL: Crisis Simulation & War Game](#part-xl-crisis-simulation--war-game)
- [Part XLI: Insider Threat Program](#part-xli-insider-threat-program)
- [Part XLII: Cloud-Native Incident Response](#part-xlii-cloud-native-incident-response)
- [Part XLIII: Polycrisis Response](#part-xliii-polycrisis-response)
- [Part XLIV: Information Operations & Disinformation Crisis Response](#part-xliv-information-operations--disinformation-crisis-response)
- [Part XLV: M&A & Organizational Restructuring Crisis Management](#part-xlv-ma--organizational-restructuring-crisis-management)
- [Part XLVI: Edge/IoT Incident Response](#part-xlvi-edgeiot-incident-response)
- [Part XLVII: Non-Technical Crisis Management](#part-xlvii-non-technical-crisis-management)
- [Appendix A: Quick Reference Index](#appendix-a-quick-reference-index)
- [Appendix B: Cross-References](#appendix-b-cross-references)

---

## Part I: Foundation & Philosophy

### §1. Crisis Management Philosophy & Fundamental Principles

-   **Law (Resilience-First Principle)**: The purpose of crisis management is not "achieving zero failures" but "building resilience to recover rapidly and maintain business continuity when failures occur." Operate under the assumption that perfect prevention is impossible, and implement the four capabilities of **Detection, Response, Recovery, and Learning** across the organization.
-   **Proactive vs Reactive**:

    | Approach | Content | Examples |
    |:---------|:--------|:--------|
    | **Proactive** | Prepare before incidents occur | BIA, exercises, runbook creation, chaos engineering |
    | **Reactive** | Respond after incidents occur | Incident response, post-mortem |

    **Mandate**: Target a resource allocation ratio of **Proactive 70% : Reactive 30%**. Organizations consumed by reactive responses are in a low maturity state.

-   **Five Fundamental Principles**:
    1.  **Assume Breach**: Assume not "someday we'll be breached" but "we may already be breached"
    2.  **Blast Radius Minimization**: Always prioritize designs that minimize the scope of impact
    3.  **Graceful Degradation**: Maintain service in degraded mode rather than total shutdown
    4.  **Transparency**: "Silence breeds distrust" — communicate status continuously even without progress
    5.  **Blameless Culture**: Focus on system improvement, not individual blame

-   **Cross-Reference**: `000_core_mindset.md` (Priority hierarchy), `502_site_reliability.md` §4 (SLI/SLO)

### §2. Framework Compliance

-   **Law**: Crisis management and BCP MUST be built using systematic approaches aligned with international standard frameworks. Relying solely on proprietary frameworks is prohibited.
-   **Framework Mapping**:

    | Framework | Application Area | Mapping to This Rule |
    |:---------|:----------------|:--------------------:|
    | **ISO 22301:2019** | Business Continuity Management System (BCMS) | §3 BIA, §11 BCP, §13 DR Strategy |
    | **NIST CSF 2.0** | Cybersecurity Framework (6-function model) | §6 Incident Flow, §7 Cyber Incidents |
    | **NIST SP 800-61 Rev.3** | Incident Response Guide (published April 2025 — **fully revised to CSF 2.0 integrated model**. Retired the legacy 4-phase model and maps IR activities to CSF 2.0's 6 functions) | §6 Incident Flow (CSF 2.0 integrated), §5-§8 Incident Response |
    | **ITIL 4** | IT Service Management | §5 Incident Management, §18 Post-Mortem |
    | **EU DORA** | Digital Operational Resilience (enforced Jan 2025) | §21 DORA Regulatory Integration |
    | **EU NIS2** | Network & Information Security Directive (Oct 2024 transposition deadline) | §32 NIS2 Integration |
    | **EU CRA** | Cyber Resilience Act (entered into force Dec 2024, reporting obligations Sep 2026) | §33 CRA Integration |
    | **APRA CPS 230** | Operational Risk Management Standard (Australia, enforced Jul 2025) | §34 Incident Reporting International Harmonization |

-   **NIST CSF 2.0 Six Functions Mapping**:
    - **Govern**: §19 Crisis Management Governance, §21 DORA Regulatory Integration
    - **Identify**: §3 BIA, §4 Risk Assessment
    - **Protect**: Delegated to `600_security_privacy.md`
    - **Detect**: §5 Incident Response Framework, §22 AIOps, `502_site_reliability.md` §10 Observability
    - **Respond**: §5-§10 Incident Response, §26 Incident Automation
    - **Recover**: §13-§15 DR Strategy & Data Protection, §28 Reputation Recovery

---

## Part II: Risk Analysis & Preparation

### §3. BIA (Business Impact Analysis)

-   **Law**: Before designing crisis management and BCP, a **BIA (Business Impact Analysis)** MUST be conducted to define business process priorities and RTO/RPO. BCP without BIA is a plan with undefined protection targets and is therefore invalid.
-   **Business Priority Classification**:

    | Tier | Classification | RTO Target | RPO Target | Examples |
    |:-----|:--------------|:-----------|:-----------|:---------|
    | **Tier 1 (Mission Critical)** | Immediate recovery required | ≦ 1 hour | ≦ 15 min | Authentication, payments, core API |
    | **Tier 2 (Business Critical)** | Same-day recovery | ≦ 4 hours | ≦ 1 hour | Search, user dashboard |
    | **Tier 3 (Important)** | Next business day | ≦ 24 hours | ≦ 4 hours | Admin panel, report generation |
    | **Tier 4 (General)** | Planned recovery | ≦ 72 hours | ≦ 24 hours | Internal tools, batch processing |

-   **BIA Extended Metrics**:
    - **MTPD (Maximum Tolerable Period of Disruption)**: Maximum downtime the business can sustain
    - **WRT (Work Recovery Time)**: Additional work time required to return to normal business level after RTO
    - **MBCO (Minimum Business Continuity Objective)**: Minimum level of business operations to maintain (e.g., 50% processing capacity)
    - **Relationship**: MTPD ≧ RTO + WRT must always be verified

-   **BIA Execution Obligations**:
    - **Initial**: Conduct BIA at project inception and record in Blueprint
    - **Updates**: Annually, or upon significant feature additions/architecture changes
    - **Record Items**: Business process name, dependent systems/services, impact of downtime (revenue, legal, reputation), RTO/RPO/WRT/MTPD/MBCO
    - **Dependency Mapping**: Visualize upstream/downstream dependencies of each business process to identify cascade failure risks
-   **Cross-Reference**: `502_site_reliability.md` §7 (RPO/RTO), §4 (SLI/SLO)

### §4. Risk Assessment & Threat Modeling

-   **Law**: Regular risk assessments MUST be conducted to systematically manage threat identification, evaluation, and countermeasures.
-   **Threat Catalog (Minimum Coverage)**:

    | Category | Threat Examples | Impact |
    |:---------|:---------------|:------:|
    | **Cyber Attacks** | Ransomware, DDoS, data breach, supply chain attack | Critical |
    | **AI/ML Threats** | Prompt injection, model poisoning, deepfake | Critical |
    | **Infrastructure Failure** | Cloud region outage, DB failure, CDN failure, DNS failure | High |
    | **Human Risk** | Key person departure, insider threat, social engineering | High |
    | **External Dependencies** | Payment service outage, AI API vendor outage, auth infra failure | High |
    | **Natural Disasters** | Earthquake, typhoon, flooding (data center locations) | Medium-High |
    | **Climate Change** | Extreme weather frequency, heat wave DC cooling failure | Medium-High |
    | **Geopolitical Risk** | Sanctions, data sovereignty regulation changes, supply chain disruption | Medium-High |
    | **Pandemic** | Infectious disease outbreak, office closure, staffing shortage | Medium-High |
    | **Regulatory** | Data localization requirements, emergency regulatory changes | Medium |
    | **Quantum Computing** | HNDL attacks, cryptographic breaks, long-term secret data exposure | Medium (future Critical) |
    | **OT/ICS** | Industrial control system attacks, SCADA malware | High (applicable sectors) |

-   **Risk Matrix (Evaluation Criteria)**:

    | | Impact: Low | Impact: Medium | Impact: High | Impact: Critical |
    |:------------|:-----------|:-------------|:------------|:----------------|
    | **Probability: High** | Medium | High | Critical | Critical |
    | **Probability: Medium** | Low | Medium | High | Critical |
    | **Probability: Low** | Low | Low | Medium | High |

    **Action**: Prepare countermeasures (runbooks, failover plans) in advance for all threats rated High or above.
-   **Threat Intelligence Integration**:
    - Participation in industry information sharing organizations such as ISACs (Information Sharing and Analysis Centers) is recommended
    - Threat modeling based on MITRE ATT&CK framework
    - Integration of CTI (Cyber Threat Intelligence) feeds into monitoring systems
-   **Review Cycle**: Review risk assessments quarterly to add new threats and re-evaluate risk levels.

---

## Part III: Incident Response

### §5. Incident Response Framework (War Room)

-   **Severity Levels**:

    | Level | Definition | Initial Response | Resolution Target | Communication |
    |:------|:----------|:----------------|:-----------------|:-------------|
    | **SEV-1 (Critical)** | Full service outage, data loss, security breach | **Within 15 min** | **Within 1 hour** | Status page + company-wide + exec report |
    | **SEV-2 (High)** | Major feature outage (payment, auth failure) | **Within 30 min** | **Within 4 hours** | Status page + team notification |
    | **SEV-3 (Medium)** | Non-critical feature issues, performance degradation | **Within 2 hours** | **Within 24 hours** | Chat notification channel |
    | **SEV-4 (Low)** | Minor bugs, UI breaks, log warning increase | **Next business day** | **Next sprint** | Issue Tracker |

-   **War Room Setup Criteria**: When SEV-1 or SEV-2 occurs, **immediately** establish a War Room.
    - **Physical**: Slack channel `#incident-yyyy-mm-dd-{summary}` + video conference
    - **Automation**: Auto-summon on-call via PagerDuty upon SEV-1 detection

-   **Roles (RACI)**:

    | Role | Responsibility | Prohibited |
    |:-----|:--------------|:-----------|
    | **Incident Commander** | Decision-making, prioritization, escalation decisions | Direct technical work |
    | **Ops Lead** | Direct and execute recovery work, technical decisions | Independent action without Commander |
    | **Comms Lead** | Status updates every 30 min, user/internal notifications | Publishing unverified information |
    | **Scribe** | Timestamped recording of all events and decisions | Deferring documentation |
    | **Subject Matter Expert (SME)** | Domain-specific technical support (DB, infra, security) | Bypassing chain of command |

-   **On-Call Escalation**:
    - Primary → **5 min no response** → Auto-escalate to Secondary
    - Secondary → **10 min no response** → Auto-escalate to Engineering Manager
    - All unresponsive → **15 min** → Emergency notification to CTO/VP

### §6. Incident Response Flow (NIST SP 800-61 Rev.3 / CSF 2.0 Integrated Model)

-   **Law**: Incident response MUST follow **NIST SP 800-61 Rev.3 (published April 2025)**. Rev.3 retired the legacy 4-phase model and introduced an **integrated model that maps IR activities to NIST CSF 2.0's 6 functions**. Incident response is positioned not as a "one-time event" but as "part of continuous cybersecurity risk management."

-   **CSF 2.0 Integrated IR Model (6-Function Mapping)**:

    | CSF Function | IR Activity | This Rule Mapping |
    |:------------|:-----------|:-----------------|
    | **Govern** | IR policy establishment, risk governance, regulatory requirements integration, management responsibility definition | §19 Governance, §48 CISO Responsibility |
    | **Identify** | Asset/risk assessment, BIA, threat intelligence integration, CSF 2.0 Community Profile utilization | §3 BIA, §4 Risk Assessment |
    | **Protect** | Preparation activities (runbook maintenance, contact list maintenance, forensic tool preparation, training) | §17 Runbooks, §43 Training, `600_security_privacy.md` |
    | **Detect** | Monitoring alerts, anomaly detection, triage determination, regulatory reporting trigger assessment | §5 Incident Response Framework, §22 AIOps |
    | **Respond** | Containment, eradication, evidence preservation, communication, regulatory reporting | §5-§10 IR overall, §34 Regulatory Reporting |
    | **Recover** | Service recovery, post-mortem, improvement actions, reputation recovery | §13-§15 DR, §18 Post-Mortem, §28 Reputation |

-   **Legacy Model Compatibility Mapping**:

    > Mapping between Rev.2's legacy 4-phase model and Rev.3's CSF 2.0 integrated model (migration reference):

    | Rev.2 (Legacy 4-Phase) | Rev.3 (CSF 2.0 Integrated) |
    |:----------------------|:--------------------------|
    | **Phase 1: Preparation** | → **Govern** + **Identify** + **Protect** |
    | **Phase 2: Detection & Analysis** | → **Detect** + **Respond** (analysis portion) |
    | **Phase 3: Containment, Eradication & Recovery** | → **Respond** + **Recover** |
    | **Phase 4: Post-Incident Activity** | → **Govern** (improvement feedback) + **Identify** (risk re-assessment) |

-   **Govern + Identify + Protect (Preparation)**:
    - Pre-create and periodically review runbooks (see §17)
    - Maintain emergency contact lists (secure alternatives beyond Slack: phone, SMS, alternative chat)
    - Pre-prepare forensic tools and log preservation procedures
    - **Regulatory Report Templates**: Pre-prepare report templates for DORA/NIS2/CRA/GDPR/Global Privacy Laws/APRA CPS 230 regulations (see §34)
    - **CSF 2.0 Community Profile**: Set IR priorities based on the incident risk management Community Profile defined by NIST SP 800-61 Rev.3
-   **Detect (Detection & Analysis)**:
    - Detection via monitoring alerts or user reports
    - **Triage**: Immediate severity level determination (see §5 matrix)
    - Initial impact assessment (affected users, affected features, data loss status)
    - **Evidence Preservation**: Immediate preservation of logs, screenshots, memory dumps (§37 Chain of Custody compliant)
    - **Regulatory Report Trigger Assessment**: Immediate determination of whether the incident triggers regulatory reporting obligations (see §34)
-   **Respond**:
    - **Short-term containment**: Immediately prevent scope expansion (network isolation, API blocking, Kill Switch)
    - **Eradication**: Remove root cause (malware removal, vulnerability patching, access path closure)
    - **Communication**: Execute stakeholder notifications per §9-§10
    - **Regulatory Reporting**: Execute statutory reporting per §34 (comply with shortest deadline)
-   **Recover (Recovery & Post-Incident)**:
    - **Recovery**: Phased service recovery (canary release validation recommended)
    - Conduct post-mortem **within 48 hours** (see §18)
    - Create and track improvement action items → **Govern** feedback loop
    - Append lessons to project lessons log
    - Submit final report to regulatory authorities (if applicable)

-   **6-Step Incident Flow (Quick Reference)**:
    1.  **Detect**: Monitoring alert or user report
    2.  **Classify**: Severity level determination + War Room setup decision + regulatory report trigger assessment
    3.  **Declare**: Declare in incident channel (e.g., `🔴 SEV-1: Payment Function Outage in Progress`)
    4.  **Respond**: Rollback / Hotfix / Kill Switch / Temporary block
    5.  **Resolve**: Status page update, recovery notification, begin monitoring
    6.  **Review**: Conduct Post-Mortem within 48 hours → Govern feedback

### §7. Cyber Incident-Specific Response

-   **Law**: Cyber incidents require different response protocols than general system failures. Prepare threat-type-specific playbooks in advance.

#### §7.1. Ransomware Response Playbook

-   **Threat Landscape (2025-2026)**:
    - **RaaS (Ransomware-as-a-Service)**: Significantly lowered barrier to entry for ransomware attacks. Even low-skill attackers can execute sophisticated attacks
    - **Double Extortion**: Two-pronged attacks combining data encryption + data exposure threats have become mainstream
    - **Pure Extortion**: Increasing tactic of stealing data without encryption and demanding ransom under threat of publication
    - **AI-Enhanced Phishing**: AI-generated, highly accurate spear phishing and vishing (voice phishing) increasing as initial intrusion vectors
    - **Low-Volume, High-Impact Attacks**: Tactics that exfiltrate large amounts of data without encryption to evade detection
    - **Primary Targets**: Manufacturing, healthcare, education, energy, and financial sectors

-   **Immediate Response (Golden Hour — First Hour)**:
    1.  **Isolate**: Immediately isolate systems suspected of infection from the network (physically/logically disconnect)
    2.  **Payment Prohibition**: Ransom payment is **prohibited in principle** (only exception judgment under legal counsel is permitted)
    3.  **Evidence Preservation**: Forensic preservation of memory dumps, logs, and infected files (see §37)
    4.  **Backup Verification**: Verify backup contamination status (confirm existence of immutable backups)
    5.  **Law Enforcement Notification**: Report to local police, JPCERT/CC (Japan), FBI IC3 (US), etc.
    6.  **Regulatory Reporting**: If DORA/NIS2 applicable, initiate initial notification to regulators (see §34)
    7.  **IR Retainer Contact**: Immediately contact pre-contracted incident response retainer firm (see §47)
    8.  **Cyber Insurance Notification**: Initial notification to insurance company (confirm evidence preservation procedures required for claims)

-   **Recovery Procedures**:
    - Restore from clean backups (see §15)
    - Complete identification and closure of intrusion paths
    - Forced rotation of all credentials
    - Phased service restoration (isolated environment verification → restricted release → full restoration)
    - Initiate dark web monitoring if data theft is confirmed

-   **Defenses**:
    - Strict adherence to **3-2-1-1 Backup Rule** (see §15)
    - Mandatory implementation of **Immutable Backups**
    - **Network Segmentation** for lateral movement prevention
    - **EDR/XDR** deployment on all endpoints
    - **AI-Aware Phishing Training**: Strengthen employee education assuming AI-generated phishing
    - **MFA Mandatory**: Mandate multi-factor authentication for all privileged accounts and VPN access

-   **Cross-Reference**: §27 (Cyber Insurance), §47 (Ransomware Negotiation & IR Retainer)

#### §7.2. Data Breach Response Protocol

-   **Stop the Bleeding**:
    - When data breach or unauthorized access is suspected, execute **Stop the Bleeding without hesitation**
    - **Prioritize**: API key invalidation, affected server isolation, access token revocation
-   **Impact Assessment**:
    - Identify type and volume of leaked data (PII, payment data, credentials)
    - Identify affected users
    - Determine breach timeline (from when to when)
-   **Legal Notification Obligations**:

    | Regulation | Notification Deadline | Notification Target |
    |:----------|:---------------------|:-------------------|
    | **GDPR (EU)** | **Within 72 hours** | Supervisory authority + affected data subjects |
    | **Applicable Regional Law** | **Preliminary: promptly / Final: within 30 days** | PPC + affected individuals |
    | **CCPA/CPRA (US CA)** | **Without unreasonable delay** | CA Attorney General + consumers |
    | **DORA (EU Financial)** | **Major ICT incident: within 4 hours (initial)** | Competent financial supervisory authority |
    | **NIS2 (EU)** | **Early warning: within 24 hours / Notification: within 72 hours** | Competent CSIRT + supervisory authority |

-   **Cross-Reference**: `600_security_privacy.md`, `601_data_governance.md`, §34 (Incident Reporting International Harmonization)

#### §7.3. DDoS Attack Response

-   **Multi-Layer Defense**:
    - **L3/L4**: Traffic filtering via CDN/WAF (Cloudflare, AWS Shield, etc.)
    - **L7**: Dynamic rate limit enforcement, temporary CAPTCHA application
    - **Auto-scaling**: Automatic infrastructure scaling for traffic surges
    - **Anycast**: Traffic distribution via DNS Anycast
-   **Trigger Criteria**: Activate DDoS response protocol upon detecting **10x or more** request surge vs. baseline
-   **Cost Protection**: Set auto-scaling cost limits to prevent cost explosion from DDoS attacks (see §31 FinOps)

#### §7.4. Supply Chain Attack Response

-   **Immediate Response**:
    - Identify and uninstall compromised dependency package versions
    - Rotate all credentials across affected environments
    - Rapid impact assessment based on SBOM
-   **Cross-Reference**: `602_oss_compliance.md` (SBOM/SCA/Supply Chain Security)

#### §7.5. Zero-Day Vulnerability Response

-   **Law**: When a zero-day vulnerability is disclosed, prepare emergency response protocols to prevent attacks until patches are available.
-   **Immediate Response (Pre-Patch)**:
    1.  **Virtual Patching**: Emergency WAF/IPS/IDS rule additions to block attack vectors
    2.  **Attack Surface Reduction**: Temporary disabling of vulnerable features (Kill Switch, Feature Flag)
    3.  **Enhanced Monitoring**: Immediately add detection rules for vulnerability exploitation patterns
    4.  **Threat Intelligence Check**: Verify known Exploits / PoC / IoC (Indicators of Compromise)
-   **Patch Application**:
    - Emergency patch testing → staging validation → canary deploy → full rollout
    - **SLA**: Zero-days with Critical CVSS score 9.0+ must be patched **within 24 hours**
-   **Coordinated Vulnerability Disclosure (CVD)**:
    - For own product vulnerabilities: Follow responsible disclosure policy, publish after fix
    - Under EU CRA, actively exploited vulnerabilities must be reported to ENISA **within 24 hours** (see §33)
-   **Cross-Reference**: `600_security_privacy.md` (Vulnerability Management), §40 (Zero-Day Details)

#### §7.6. Identity-Based Attack Response

-   **Law**: In 2025-2026, identity is the most attacked surface. Attacks that "log in" rather than "break in" have become mainstream. Prepare specific response protocols for identity-based attacks.

-   **Key Attack Vectors & Countermeasures**:

    | Attack Method | Overview | Countermeasure |
    |:-------------|:---------|:--------------|
    | **MFA Fatigue Attack** | Flood of MFA push notifications to trick users into approving | Number Matching MFA, FIDO2/WebAuthn migration, anomalous MFA request detection |
    | **SIM Swapping** | Deceive carrier to hijack SIM, bypassing SMS-MFA | Deprecate SMS-MFA → authenticator apps/FIDO2, telecom PIN setup |
    | **Adversary-in-the-Middle (AiTM)** | Steal session cookies via proxy, bypassing MFA | Token binding, conditional access (compliant device required) |
    | **Session Hijacking** | Unauthorized access via stolen session tokens | Short-lived session tokens, continuous authentication, device binding |
    | **Credential Stuffing** | Automated authentication attempts using leaked credential DBs (Dark Web) | Passwordless authentication, Have I Been Pwned integration, rate limit hardening |
    | **Help Desk Attack** | Impersonate IT to request password resets | Multi-step identity verification, out-of-band confirmation, reset operation audit logs |

-   **Immediate Response (Identity Compromise Detected)**:
    1.  **Invalidate affected account sessions**: Force logout from all sessions and devices
    2.  **Credential rotation**: Immediate reset of passwords, API keys, and tokens
    3.  **Lateral movement investigation**: Investigate impact scope based on compromised account's access privileges
    4.  **Temporary conditional access tightening**: Force MFA re-authentication across the affected organization
    5.  **IDP log preservation**: Immediate preservation of Azure AD/Okta/Google Workspace sign-in and audit logs

-   **Prevention Strategy**:
    - **Passwordless authentication**: Progressive adoption of FIDO2/WebAuthn/Passkeys (ultimate goal: complete password elimination)
    - **Continuous Authentication**: Risk-based re-authentication during sessions (triggered by anomalous behavior)
    - **Privileged Access Management (PAM)**: Just-in-Time (JIT) access, strict least privilege enforcement
    - **ITDR (Identity Threat Detection and Response)**: Deploy dedicated ITDR products or XDR identity capabilities

-   **Cross-Reference**: `600_security_privacy.md` (Authentication & Access Control), §8 (Deepfake/Social Engineering)

#### §7.7. Non-Human Identity (NHI) Security & Incident Response

-   **Law**: API keys, service accounts, OAuth clients, machine-to-machine tokens, and other **Non-Human Identities (NHI)** vastly outnumber human identities (typically 10:1 to 50:1 ratio) yet are often inadequately managed, creating significant security risks. Establish NHI-specific crisis management protocols.

-   **NHI Risk Categories**:

    | Risk | Overview | Impact |
    |:-----|:---------|:-------|
    | **Privilege Sprawl** | Accumulation of overly-permissioned service accounts | Massive blast radius upon compromise |
    | **Lifecycle Management Gap** | API keys/tokens never retired or rotated | Long-term unauthorized access risk |
    | **Hardcoded Secrets** | API keys directly written in source code/CI-CD configs | Public exposure on GitHub etc. → immediate compromise |
    | **Zombie Accounts** | Unused but remaining service accounts | Hard-to-detect attack paths |
    | **OAuth Over-Permission** | OAuth apps with unnecessarily broad scopes | Lateral movement via third parties |

-   **Incident Response (NHI Compromise)**:
    1.  **Immediately invalidate affected NHI**: Revoke API keys, disable service accounts, cancel OAuth tokens
    2.  **Secret scanning**: Scan all repositories, CI/CD pipelines, environment variables (GitGuardian, Trufflehog, etc.)
    3.  **Lateral movement investigation**: Identify impact scope based on compromised NHI's permissions
    4.  **Rotate all related credentials**: Update credentials for all services that interacted with the compromised NHI
    5.  **Audit log review**: Analyze historical logs for anomalous API call patterns by the NHI

-   **Prevention Measures**:
    - **Secret management**: Centralized management via HashiCorp Vault, AWS Secrets Manager, etc. Hardcoding prohibited
    - **Automated rotation**: Periodic automatic rotation of API keys/tokens (maximum 90 days)
    - **Least privilege**: Restrict service account permissions to the minimum required for job execution
    - **NHI inventory**: Complete inventory of all NHIs with periodic updates (quarterly)
    - **Expiration mandate**: Set expiration on all API keys/tokens. Indefinite tokens prohibited
    - **CI/CD pipeline security**: Prioritize OIDC federation/Workload Identity for secret usage in pipelines

    ```yaml
    # GitHub Actions — OIDC Workload Identity Example (avoid hardcoded secrets)
    permissions:
      id-token: write
      contents: read
    steps:
      - uses: google-github-actions/auth@v2
        with:
          workload_identity_provider: 'projects/123/locations/global/workloadIdentityPools/pool/providers/provider'
          service_account: 'deploy@project.iam.gserviceaccount.com'
    ```

-   **Cyber Insurance Impact**: NHI compromises are increasingly excluded from cyber insurance coverage (see §27)
-   **Cross-Reference**: `600_security_privacy.md` (Access Control), §27 (Cyber Insurance), §37 (Forensics)

---

## Part IV: AI Threat Response

### §8. AI-Driven Threat Response

-   **Law**: Prepare specific response procedures for new threat types that exploit AI technology (Deepfake, prompt injection, AI-generated phishing, etc.).
-   **Threat Catalog**:

    | Threat | Impact | Response |
    |:------|:-------|:--------|
    | **Prompt Injection** | AI feature abuse, harmful content generation | Global Kill Switch (see §9.2), guardrail hardening |
    | **AI API Cost Attack** | Cloud bankruptcy via mass requests | Rate limiting, cost circuit breaker |
    | **Deepfake Fraud** | Unauthorized approvals via impersonation | MFA hardening, out-of-band verification |
    | **AI-Generated Phishing** | High-precision phishing emails/sites | Security awareness training, email auth (DMARC) |
    | **Model Poisoning** | AI output manipulation via training data contamination | Data pipeline integrity verification, model signing |
    | **LLM Jailbreak** | Safety guardrail bypass | Multi-layer guardrails, output filtering hardening |
    | **AI-Generated Malware** | Automated mass production of polymorphic malware | EDR/XDR hardening, behavior analysis |
    | **Shadow AI** | Unauthorized AI tool usage in business operations | AI governance policy, DLP integration |
    | **Adversarial ML** | AI model misclassification via input manipulation | Adversarial testing, input validation hardening |

-   **Deepfake Countermeasure Protocol**:
    - **Detection Technology**: Consider deploying deepfake detection tools (Microsoft Video Authenticator, Sensity AI, etc.)
    - **Authentication Hardening**: For CEO fraud countermeasures, mandate **out-of-band authentication** (direct confirmation via separate channel) for high-value transfers and critical decisions
    - **Voice Cloning Countermeasures**: Introduce **codeword system** for voice-based approvals (phone-based wire transfer instructions, etc.) using a pre-agreed secret phrase for identity verification
    - **Video Authentication**: Anti-impersonation protocol for video conferences using real-time action instructions (requesting specific movements) for verification
    - **All-Staff Education**: Regular sharing of deepfake attack case studies and training (see §43)

-   **Shadow AI Management**:
    - DLP (Data Loss Prevention) integration to detect unauthorized AI tool usage in business operations
    - Maintain approved AI tool registry and usage guidelines
    - Quarterly Shadow AI risk assessment and employee awareness

-   **Global Kill Switch Implementation Mandate**:
    - AI feature emergency shutdown switch MUST be implemented via **Edge Config** or **DB flag** (`system_settings`) requiring **no re-deployment**
    - Middleware checks `ai_enabled`, `billing_enabled` flags and immediately returns 503 when OFF
    - **"Fix code and re-deploy" is too slow** — enable shutdown in seconds

    ```typescript
    // Global Kill Switch — Middleware Implementation Example
    import { NextResponse } from 'next/server';

    export async function middleware(request: NextRequest) {
      // Edge Config or DB flags check (no re-deploy required)
      const flags = await getSystemFlags(); // Edge Config / KV Store

      if (!flags.ai_enabled && request.nextUrl.pathname.startsWith('/api/ai')) {
        return NextResponse.json(
          { error: 'AI_SERVICE_TEMPORARILY_DISABLED', message: 'AI features are temporarily suspended' },
          { status: 503 }
        );
      }

      if (!flags.billing_enabled && request.nextUrl.pathname.startsWith('/api/billing')) {
        return NextResponse.json(
          { error: 'BILLING_SERVICE_TEMPORARILY_DISABLED', message: 'Billing features are temporarily suspended' },
          { status: 503 }
        );
      }
    }
    ```

-   **Cross-Reference**: `400_ai_engineering.md` (Guardrails), `502_site_reliability.md` §9.6 (AI Cost Governance)

---

## Part V: Communication

### §9. Crisis Communication Management

-   **Law**: "Silence breeds distrust." During incidents, status MUST be communicated continuously even if not yet resolved.

#### §9.1. Status Page Management

-   **Component-Level Health Monitoring**:
    - Status pages MUST display operational status of each service component **individually in real-time**
    - Maintain visibility so users can immediately identify "which component is affected" rather than "general outage"

-   **Component Categories (Minimum)**:

    | Category | Monitoring Target (Example) | Health Check Method (Example) |
    |:---------|:--------------------------|:----------------------------:|
    | **Web Application** | Frontend / Edge | HTTP 200 response check |
    | **API** | Backend API | Response time ≦ threshold |
    | **Database** | Primary DB | Connection pool utilization |
    | **Authentication** | Auth infrastructure | Login success rate |
    | **Media Delivery** | CDN / Storage | CDN hit rate |
    | **External Integrations** | Payment / AI / Email etc. | Response success rate |

-   **Status Levels (4 Tiers)**:
    - `Operational` — Normal operation
    - `Degraded Performance` — Performance degradation
    - `Partial Outage` — Partial failure
    - `Major Outage` — Full outage

-   **Status Transition Flow**:
    - `Investigating` → `Identified` → `Monitoring` → `Resolved`

#### §9.2. Incident Notification Templates

-   **Law**: Incident notifications MUST be issued based on **pre-prepared templates**. Hastily written free-form text increases the risk of information omission and inappropriate expressions.

-   **Initial Report Template**:
    ```
    [Incident Report] Notice regarding {Component Name}

    Thank you for using {Service Name}.
    We are currently experiencing {Symptom} with {Component Name}.

    ■ Occurrence Time: {YYYY-MM-DD HH:MM UTC}
    ■ Impact Scope: {Affected Features}
    ■ Current Status: Investigating / Recovery in Progress
    ■ Next Update ETA: {HH:MM UTC}

    We sincerely apologize for the inconvenience.
    We will update this page as soon as recovery is confirmed.
    ```

-   **Required Fields (Initial, Update, Recovery Reports)**:
    - **Occurrence Time**: Exact date/time of first detection (with timezone)
    - **Impact Scope**: Identification of affected features and user segments
    - **Current Status**: "Investigating / Cause Identified / Recovery in Progress / Recovered"
    - **Next Update ETA**: Scheduled time for next update (prevents silence)

-   **Update Frequency**:

    | Level | Status Page Update | Internal Update |
    |:------|:-----------------:|:---------------:|
    | **SEV-1** | Every 30 min | Every 15 min |
    | **SEV-2** | Every 1 hour | Every 30 min |
    | **SEV-3** | Every 4 hours or on change | As needed |

#### §9.3. Media & Social Media Response

-   **Principles**: For SEV-1 incidents that may attract external media attention:
    - **Single Spokesperson**: External media communication authority limited to one designated person
    - **Fact-Checking**: Monitor misinformation on social media and issue rapid corrections via official channels
    - **Legal Review**: Press releases for major incidents (data breaches, etc.) require mandatory legal review
    - **Dark Site Preparation**: Pre-prepared notification pages for major incidents (ready for immediate publication)

### §10. Stakeholder Notification & Reputation Management

-   **Stakeholder Notification Matrix**:

    | Stakeholder | SEV-1 | SEV-2 | SEV-3 | Notification Method |
    |:-----------|:-----:|:-----:|:-----:|:-------------------|
    | **Executive Team** | ✅ Immediate | ✅ Within 1 hour | ❌ | Phone + Email |
    | **Company/Team** | ✅ Immediate | ✅ Immediate | ✅ | Slack + Email |
    | **Users** | ✅ Immediate | ✅ Within 1 hour | ❌ | Status Page |
    | **Regulators** | ✅ Within legal deadline | △ If required | ❌ | Official letter/Portal |
    | **Partners** | ✅ Within 1 hour | △ If required | ❌ | Email + Phone |
    | **Cyber Insurance Provider** | ✅ Per contract terms | △ If required | ❌ | Designated contact |

-   **Data Breach User Email**:
    - Use legally vetted templates for swift and transparent notification
    - Required information: what happened, impact scope, user actions required (password change, etc.), contact information
-   **Cross-Reference**: `601_data_governance.md` (GDPR/Global Privacy Laws notification obligations)

---

## Part VI: Business Continuity

### §11. BCP (Business Continuity Plan)

-   **Law**: BCP is not solely an IT department responsibility — it defines the **organization-wide business continuity capability**. Maintain it in compliance with ISO 22301 with executive approval.
-   **BCP Required Elements**:

    | Element | Content |
    |:--------|:--------|
    | **Scope** | Clear definition of target operations, systems, and locations |
    | **BIA Results** | Reflect Business Impact Analysis from §3 |
    | **Recovery Strategy** | Recovery procedures and resources per tier |
    | **Roles & Responsibilities** | Command structure and RACI matrix during BCP activation |
    | **Communication Plan** | Internal/external notification procedures and contact list |
    | **Alternatives** | Remote work, alternative infrastructure, manual operation procedures |
    | **Testing & Training** | See §16 Tabletop Exercises |
    | **Regulatory Requirements Mapping** | Mapping of applicable regulations (DORA/NIS2/CRA) to BCP |

-   **Key Person Risk Elimination**:
    - **Eliminate** "code only a specific engineer can manage"
    - Maintain a state where **anyone** can perform recovery through documentation and code standardization
    - **Bus Factor ≧ 2**: For all critical systems, maintain at least 2 people capable of operation and recovery

-   **Emergency Contact List**:
    - **Secure** emergency contact methods beyond Slack (phone, SMS, alternative chat)
    - Update contact list **quarterly** to prevent staleness
    - **Reachability Test**: Conduct test notifications using the actual emergency contact list semi-annually
    - **Out-of-Band Communication**: Secure alternative communication methods in case primary communication infrastructure itself fails

-   **Remote Work BCP**:
    - Verify VPN/Zero Trust connection capacity can handle simultaneous all-employee connections
    - Guarantee remote access to primary tools (source code, CI/CD, monitoring)
    - Pre-identify alternative work locations when office is unavailable

### §12. Vendor & Supply Chain BCP

-   **Law**: Pre-define the response flow for when external vendor failures (cloud providers, SaaS, payment services, etc.) cascade to your services. "It's the vendor's problem, we can only wait" constitutes **abandonment of business continuity**.
-   **Vendor Failure Response Flow**:
    1.  **Detect**: Vendor status page monitoring + internal monitoring anomaly detection
    2.  **Impact Assessment**: Immediately assess which features/user segments are affected
    3.  **User Notification**: Post impact scope and status on your status page (even while waiting for vendor recovery — **silence is prohibited**)
    4.  **Alternative Execution**: Execute fallback measures (alternative service switchover, degraded mode, etc.)
    5.  **Recovery Verification**: After vendor recovery, verify normal operation of your service

-   **Vendor BCP Verification Obligation**: For critical vendors (High risk tier), verify **annually**:
    - BCP readiness status
    - RPO/RTO settings and SLA alignment
    - Incident history and recovery track record for the past year
    - Redundancy and backup infrastructure
    - **Contractual Exit Strategy**: Migration plans to avoid vendor lock-in

-   **Pre-Prepared Vendor Alternatives**: For vendors that constitute SPOF (Single Point of Failure):
    - Complete alternative service selection in advance
    - Conduct minimum connectivity verification (PoC)
    - Document switchover procedures in runbooks (see §17)
    - **"Searching for alternatives after an outage" is too late**

-   **Vendor Risk Tier Classification**:

    | Tier | Criteria | Alternative Requirements | Examples |
    |:-----|:---------|:----------------------|:---------|
    | **Critical** | Outage = immediate full service outage | Pre-verified alternative service | Cloud provider, auth infra |
    | **High** | Outage = major feature outage | Alternative candidate selected | Payment, CDN, email delivery |
    | **Medium** | Outage = UX degradation | Graceful Degradation design | AI API, analytics tools |
    | **Low** | Outage = minimal impact | Manual alternative possible | CMS, internal tools |

-   **NIS2 Supply Chain Requirements**:
    - Supply chain security assessment based on NIS2 Article 21
    - Regular evaluation of vendor security practices
    - Incorporation of cybersecurity obligation clauses into contracts
    - Integration of incident management plans across the supply chain

-   **Cross-Reference**: §17 (Runbooks), `600_security_privacy.md` §10 (Vendor Security Management)

---

## Part VII: Disaster Recovery

### §13. Disaster Recovery Strategy

-   **Law**: DR (Disaster Recovery) strategy MUST select appropriate DR methods per tier based on RTO/RPO defined in BIA (§3).
-   **DR Tier Classification**:

    | DR Tier | Strategy | RTO | RPO | Cost | Use Case |
    |:--------|:---------|:----|:----|:-----|:---------|
    | **Tier 0: Active-Active** | Multi-region simultaneous operation | ≈ 0 | ≈ 0 | Highest | Mission Critical |
    | **Tier 1: Hot Standby** | DR environment always running and synced | ≦ 15 min | ≦ 5 min | High | Business Critical |
    | **Tier 2: Warm Standby** | DR environment scaled down, periodic sync | ≦ 1 hour | ≦ 15 min | Medium | Important |
    | **Tier 3: Pilot Light** | Minimal configuration in DR environment | ≦ 4 hours | ≦ 1 hour | Low | General |
    | **Tier 4: Backup & Restore** | Restore from backup only | ≦ 24 hours | ≦ 24 hours | Lowest | Non-Critical |

-   **RPO/RTO Design Verification Checklist**:
    - **RPO**: How much data loss is acceptable
    - **RTO**: Maximum time to recovery after downtime
    - **MTPD (Maximum Tolerable Period of Disruption)**: Maximum downtime the business can sustain
    - These values MUST be consistent with BIA results

### §14. Cloud-Native DR

-   **Law**: Cloud-environment DR requires different approaches than traditional on-premises DR. Maximize utilization of IaC (Infrastructure as Code) and cloud-native services.

-   **Multi-Region Failover**:
    - Cross-region replication utilization (DB, object storage)
    - DNS-based failover (Route 53 Health Check, Cloudflare Load Balancing, etc.)
    - Data consistency guarantee during failover (pre-define eventual consistency tolerance)

-   **IaC DR (Infrastructure as Code DR)**:
    - Define all infrastructure in code, maintaining **instant re-creation capability in another region**
    - Establish Terraform/Pulumi/OpenTofu state file backup and restoration procedures
    - **Recovery Playbook**: Document IaC-based environment rebuild procedures in runbooks

-   **Serverless / Edge Computing DR**:
    - Multi-region auto-deployment of serverless functions
    - Natural redundancy via Edge Functions global distribution
    - Failover design considering cold start latency

-   **DRaaS (Disaster Recovery as a Service)**:
    - Maintain minimal resources in DR environment using Pilot Light strategy
    - Auto-scale-up upon failover
    - Monthly failover testing

-   **Container/Kubernetes DR**:
    - Instant deployment to alternative cluster via GitOps management of K8s Manifests
    - Persistent Volume cross-region snapshots
    - Utilization of backup tools (Velero, etc.)

-   **Multi-Cloud DR** (detailed in §39):
    - Assessment of single cloud provider dependency risk
    - Design and verification of cross-cloud failover

-   **Cross-Reference**: `361_aws_cloud.md` (Multi-Region), `502_site_reliability.md` §7 (RPO/RTO), §39 (Multi-Cloud DR)

### §15. Data Protection & Backup Strategy

-   **Law**: Backup "creation" alone is insufficient. The ability to "restore" MUST be regularly verified. Unverified backups are considered **non-existent**.
-   **3-2-1-1 Backup Rule**:
    - **3**: Maintain at least **3** copies of data
    - **2**: Store on **2** different storage media types
    - **1**: Keep **1** off-site (different region/different provider)
    - **1**: Maintain **1** as immutable (tamper-proof) backup

-   **Immutable Backup Mandate**:
    - Counter the risk of ransomware encrypting backups
    - Utilize Object Lock (S3), WORM (Write Once Read Many) storage
    - Maintain a state where **deletion/modification is physically impossible** during retention period

-   **Backup Verification**:
    - **Monthly**: Automated restore test execution (see `502_site_reliability.md` §10.3)
    - **Quarterly**: Manual full restore drill (Fire Drill Protocol)
    - **Verification Items**: Restore completion, table count match, row count integrity, application startup confirmation

-   **Backup Encryption**:
    - Encrypt all backups with AES-256 or higher
    - Store encryption keys **separately** from backups (KMS recommended)
    - **Crypto Agility**: Design for switchable encryption algorithms in preparation for PQC migration (see §35)

-   **Cross-Reference**: `502_site_reliability.md` §7 (Fire Drill Protocol, Off-Site Backup), §10.3 (Automated Backup Verification)

---

## Part VIII: Exercises & Verification

### §16. Tabletop Exercises & GameDay

-   **Law**: Plans cannot be trusted without verification through exercises. Conduct regular tabletop exercises and GameDays to continuously improve response capabilities.

-   **Tabletop Exercise**:

    | Item | Criteria |
    |:-----|:--------|
    | **Frequency** | At least quarterly |
    | **Participants** | Incident response team + executives |
    | **Scenario** | Select from high-risk items in §4 risk assessment |
    | **Deliverables** | Discovered issues, improvement action list |
    | **Recording** | Record entire exercise process for next cycle improvement |

-   **Recommended Scenarios**:
    - Full system encryption by ransomware
    - Cloud provider region outage
    - Data leak via insider threat
    - Supply chain attack (compromised dependency package)
    - Simultaneous DDoS + ransomware (multi-vector attack)
    - AI API runaway / cost explosion
    - Company-wide remote transition due to pandemic
    - Zero-day vulnerability disclosure (critical vulnerability in used OSS)
    - Regulatory authority reporting drill (DORA/NIS2 reporting timeline compliance)

-   **GameDay (Chaos Engineering Integration)**:
    - Intentional fault injection in **staging environment**
    - Utilize tools like ChaosMesh/Gremlin/Litmus
    - Announced → Unannounced → Production (gradually expand based on maturity)
    - **Success Criteria**: Auto-recovery functions correctly, recovery within RTO

-   **Post-Exercise Improvement Cycle**:
    1.  Review exercise results (catalogue discovered issues)
    2.  Create improvement action items (assign owner and deadline)
    3.  Confirm improvements completed before next exercise
    4.  Reflect improvements in runbooks and BCP

-   **Cross-Reference**: `502_site_reliability.md` §1 (Chaos Engineering), `700_qa_testing.md` Part VIII (Resilience Testing), §38 (Advanced Exercise Programs)

### §17. Runbook Framework

-   **Law**: Create specific procedure guides (runbooks) for major failure scenarios **in advance**. Incident response without runbooks is "groping fire-fighting" that significantly extends recovery time.
-   **Runbook Template**:

    | Step | Content | Estimated Duration |
    |:-----|:--------|:-----------------:|
    | **1. Confirm** | Verify incident occurrence (status page, monitoring) | 5 min |
    | **2. Diagnose** | Root cause isolation (metrics, log review) | 15 min |
    | **3. Declare** | Incident declaration, War Room setup decision | 5 min |
    | **4. Mitigate** | Reduce impact scope (config change, resource scaling, Kill Switch) | 15 min |
    | **5. Alternate** | Switch to fallback (redundancy, alternative service) | 30 min |
    | **6. Notify** | Status page, user notification | 10 min |
    | **7. Recover** | Restore to normal state | Variable |
    | **8. Verify** | Normal operation confirmation test | 15 min |
    | **9. Document** | Begin Post-Mortem creation | — |

-   **Required Runbooks (Minimum Coverage)**:

    | Scenario | Primary Response |
    |:---------|:----------------|
    | **Database Failure** | Connection pool exhaustion, replica failover, backup restore |
    | **CDN/Media Delivery Failure** | Cache purge, direct delivery switchover, alternative CDN |
    | **Payment System Failure** | Maintenance banner, unprocessed transaction reconciliation |
    | **Auth Infrastructure Failure** | Session management fallback, emergency auth bypass |
    | **Cloud Region Outage** | Multi-region failover procedure |
    | **Ransomware Infection** | See §7.1 Playbook |
    | **Data Breach** | See §7.2 Protocol |
    | **DDoS Attack** | See §7.3 Response |
    | **AI API Failure/Runaway** | Kill Switch activation, alternative model switchover |
    | **Zero-Day Vulnerability** | See §7.5 Response |
    | **Regulatory Reporting** | See §34 Reporting Timeline Response |

-   **Runbook Quality Standards**:
    - **Executable**: Unambiguous procedures that can be executed by a first-time engineer
    - **Tested**: Verified through tabletop exercises or GameDays
    - **Current**: Reviewed quarterly, reflecting architecture changes
    - **Accessible**: Stored in a location accessible during production incidents (not dependent on production infrastructure)
    - **Versioned**: Under Git management with trackable change history

-   **Cross-Reference**: §5 (Incident Response), §13 (DR Strategy), §16 (Tabletop Exercises)

---

## Part IX: Post-Incident

### §18. Post-Mortem & Continuous Improvement

-   **Law (Blameless Post-Mortem Protocol)**: Assigning individual blame during incidents is **strictly prohibited**. Ask not "why did they make a mistake" but "why did the system allow them to make a mistake."

-   **Post-Mortem Requirements**:

    | Level | Post-Mortem | Deadline |
    |:------|:-----------|:---------|
    | **SEV-1** | Required (all participants) | Within 48 hours |
    | **SEV-2** | Required (stakeholders) | Within 72 hours |
    | **SEV-3** | Recommended | Within 1 week |
    | **SEV-4** | Optional | — |

-   **5 Whys (Root Cause Analysis)**:
    - Repeat "Why?" five times to reach the true Root Cause
    - **"Human error" is not a cause — it is the starting point of investigation**
    - Root Cause MUST always be a "deficiency in systems, processes, or tools"

-   **Post-Mortem Required Sections**:

    | Section | Content |
    |:--------|:--------|
    | **Summary** | What happened (1-2 sentences) |
    | **Timeline** | Chronological: occurrence → detection → initial response → resolution (timestamped) |
    | **Impact Scope** | Affected user count, impact duration, data loss status |
    | **Root Cause** | 5 Whys result (code change, config error, external dependency, etc.) |
    | **Detection Evaluation** | Analysis of detection method and time (TTD: Time to Detect) |
    | **Response Evaluation** | Analysis of response appropriateness and time (TTM: Time to Mitigate) |
    | **Improvement Actions** | Recurrence prevention measures (specific tasks, owners, deadlines) |
    | **Lessons Learned** | Content to append to project lessons log |
    | **Regulatory Response Review** | Regulatory reporting obligation compliance status (if applicable) |

-   **Completion Criteria (Systemic Fix Mandate)**:
    - Post-mortem completion requires submission of a PR that **physically prevents** recurrence through one of:
      - **New automated test** addition
      - **Lint rule** addition
      - **Monitoring alert** creation/threshold adjustment
      - **Architecture change** implementation
    - **"Being more careful" or "updating the manual" are NOT accepted as countermeasures**

-   **Metrics Tracking**:

    | Metric | Definition | Target |
    |:-------|:----------|:-------|
    | **MTTD (Mean Time to Detect)** | Average time from failure to detection | ≦ 5 min |
    | **MTTA (Mean Time to Acknowledge)** | Average time from detection to initial response | ≦ 15 min |
    | **MTTR (Mean Time to Resolve)** | Average time from failure to recovery | ≦ 1 hour (SEV-1) |
    | **MTBF (Mean Time Between Failures)** | Average time between failures | Maintain upward trend |
    | **Recurrence Rate** | Recurrence rate of same Root Cause | 0% (zero recurrence) |

-   **Cross-Reference**: `502_site_reliability.md` §5 (Incident Management)

---

## Part X: Governance & Maturity

### §19. Crisis Management Governance

-   **Law**: Crisis management is not solely the responsibility of the engineering team — it MUST be operated as an organization-wide governance framework.
-   **RACI Matrix**:

    | Activity | CTO/VP | Engineering Manager | SRE/DevOps | Product | Legal |
    |:---------|:------:|:------------------:|:---------:|:-------:|:-----:|
    | BIA Development | A | R | C | C | I |
    | BCP Development/Update | A | R | R | C | C |
    | Incident Response | I | A | R | I | C |
    | Post-Mortem | I | A | R | I | I |
    | Exercise Planning/Execution | A | R | R | I | I |
    | Compliance | I | C | C | I | A/R |
    | Regulatory Reporting | I | C | R | I | A |

    **Legend**: R=Responsible, A=Accountable, C=Consulted, I=Informed

-   **Budget & Investment**:
    - Secure a clear annual budget for crisis management
    - Justify tool investments (monitoring, backup, DRaaS, etc.) from a cost avoidance perspective
    - **ROI Calculation**: Compare past incident costs (downtime cost + reputation impact) against countermeasure costs

-   **KPIs**:

    | KPI | Target | Review Frequency |
    |:----|:------|:----------------:|
    | BCP Update Frequency | At least annually | Annual |
    | Tabletop Exercise Count | At least 4/year | Quarterly |
    | Runbook Coverage | 100% of high-risk scenarios | Quarterly |
    | MTTR (SEV-1) | ≦ 1 hour | Monthly |
    | MTTD | ≦ 5 min | Monthly |
    | Post-Mortem Completion Rate | 100% for SEV-1/2 | Monthly |
    | Improvement Action Completion Rate | ≧ 90% | Monthly |
    | Regulatory Reporting Deadline Compliance Rate | 100% | Monthly |

-   **Compliance Requirements**:
    - **ISO 22301**: Consider BCMS certification (depending on scale)
    - **SOC 2 Type II**: Include BCP/DR as audit evidence for security/availability controls
    - **GDPR/Global Privacy Laws**: Compliance with statutory deadlines for data breach notification (§7.2)
    - **EU DORA**: ICT resilience requirements for the financial sector (§21)
    - **EU NIS2**: Security requirements for essential and important entities (§32)
    - **EU CRA**: Product vulnerability reporting for products with digital elements (§33)

-   **CISO & Management Legal Liability (Management Liability)**:
    - **NIS2 Management Liability**: NIS2 Directive codifies **personal responsibility of management** for cybersecurity measures. Directors may be held personally liable if negligence is established
    - **SEC Disclosure Rules (US)**: Material cyber incidents must be disclosed via Form 8-K **within 4 business days** (effective December 2023)
    - **J-SOX (Internal Control Reporting)**: Incident response framework establishment required as part of IT general controls
    - **Board Reporting**: Establish framework for quarterly cybersecurity risk reporting to the board of directors (see §48)
    - **D&O Insurance**: Confirm scope of Directors & Officers liability insurance coverage for cyber incidents

-   **Cross-Reference**: §48 (CISO & Management Liability and Board Reporting)

### §20. Maturity Model & Periodic Review

-   **Crisis Management Maturity Model (5 Levels)**:

    | Level | Name | Characteristics |
    |:------|:-----|:---------------|
    | **L1: Initial** | Ad Hoc | No BCP. Incident response is ad hoc |
    | **L2: Repeatable** | Reactive | Basic incident response flow and contact lists exist |
    | **L3: Defined** | Proactive | BIA complete, BCP/DR documented, runbooks established, annual exercises |
    | **L4: Managed** | Managed | Quantitative metrics (MTTD/MTTR), quarterly exercises, post-mortem culture established |
    | **L5: Optimizing** | Resilient | Chaos engineering in production, supply chain BCP integrated, auto-recovery established, AIOps integrated, regulatory reporting automated |

    **Target**: All projects MUST meet **L3 minimum** and target **L4**.

-   **Periodic Review Schedule**:

    | Frequency | Target |
    |:----------|:-------|
    | **Monthly** | Incident metrics review (MTTD/MTTR/recurrence rate) |
    | **Quarterly** | Risk assessment update, runbook review, tabletop exercises |
    | **Semi-Annual** | Emergency contact list test, backup restore drill |
    | **Annual** | BIA update, full BCP review, vendor BCP verification, regulatory compliance audit |

-   **20 Critical Anti-Patterns**:
    1.  ❌ BCP does not exist / has never been updated since creation
    2.  ❌ Never conducted a tabletop exercise
    3.  ❌ Taking backups but never performed a restore test
    4.  ❌ Runbooks do not exist / are outdated and unexecutable
    5.  ❌ Key person risk not eliminated (Bus Factor = 1)
    6.  ❌ Post-mortems assign individual blame
    7.  ❌ Kill Switch not implemented (no emergency shutdown for AI/payment)
    8.  ❌ Vendor failure response flow undefined
    9.  ❌ Data breach legal notification procedures not established
    10. ❌ Incident metrics (MTTD/MTTR) not being measured
    11. ❌ Zero incident response automation, manual-only
    12. ❌ Climate change / natural disaster risks not included in BCP
    13. ❌ No cyber insurance / unaware of coverage scope
    14. ❌ No mental health care for incident responders
    15. ❌ Regulatory requirements (DORA, NIS2, etc.) not integrated into crisis management framework
    16. ❌ Zero-day vulnerability response protocol undefined
    17. ❌ Regulatory report templates not pre-prepared
    18. ❌ No preparation for quantum computing threats (HNDL attacks)
    19. ❌ OT/ICS security not included in BCP (applicable sectors)
    20. ❌ Digital forensics Chain of Custody not established

---

## Part XI: DORA / Regulatory Compliance Integration

### §21. DORA (Digital Operational Resilience Act) Integration

-   **Law**: When providing services related to the EU financial sector, you MUST implement an ICT risk management framework compliant with **DORA (Regulation (EU) 2022/2554)**. DORA was enforced on January 17, 2025.

-   **DORA 5 Pillars Mapping**:

    | DORA Pillar | Requirements Summary | This Rule Mapping |
    |:-----------|:--------------------|:-----------------|
    | **ICT Risk Management** | Comprehensive ICT risk management framework | §4 Risk Assessment, §19 Governance |
    | **ICT Incident Reporting** | Reporting major ICT incidents to regulators | §7.2 Legal Notification, §10 Stakeholder Notification |
    | **Digital Operational Resilience Testing** | Including TLPT (Threat-Led Penetration Testing) | §16 Tabletop Exercises, `700_qa_testing.md` |
    | **ICT Third-Party Risk Management** | Oversight of critical ICT vendors | §12 Vendor BCP |
    | **Information Sharing** | Cyber threat information sharing mechanisms | §18 Post-Mortem |

-   **ICT Incident Report Timeline (DORA-Compliant)**:

    | Report Type | Deadline | Content |
    |:-----------|:---------|:--------|
    | **Initial Notification** | **Within 4 hours** after major incident classification | Incident summary, impact scope |
    | **Intermediate Report** | **Within 72 hours** after initial notification | Root cause analysis, response status |
    | **Final Report** | **Within 1 month** after incident resolution | Complete analysis, prevention measures, lessons |

-   **TLPT (Threat-Led Penetration Testing)**:
    - Conduct every 3 years (regulatory requirement)
    - Comply with TIBER-EU framework
    - Execution by independent third-party testing organization
    - Report results to regulatory authority

-   **ICT Third-Party Contract Requirements**:
    - Include DORA mandatory clauses in all critical ICT vendor contracts
    - **Audit Rights**: Secure direct audit access to vendors
    - **Exit Strategy**: Pre-develop migration plans from vendors
    - **Data Protection**: Clarify data location and processing locations
    - **Incident Reporting**: Mandate prompt incident notification from vendors

-   **DORA Delegated Regulations (2025 Entry into Force)**:
    - **Delegated Regulation (EU) 2025/301**: Detailed provisions for incident reporting content, timeline, and format
    - **Implementing Regulation (EU) 2025/302**: Standard forms and procedures for incident reporting
    - **ESA (European Supervisory Authorities) Supervisory Process**:
        - April 30, 2025: Deadline for ICT third-party outsourcing information register submission (Competent authorities → ESAs)
        - July 2025: ESAs complete classification of critical ICT third-party service providers
        - Thereafter: ESAs commence direct oversight of critical ICT providers
    - **Contract Renewal**: If existing ICT outsourcing contracts lack DORA-mandatory clauses, amendments required at contract renewal

-   **Cross-Reference**: `601_data_governance.md` (DORA regulation), `600_security_privacy.md` (Security testing)

---

## Part XII: AI-Driven Incident Management

### §22. AIOps (AI-Driven Incident Management)

-   **Law**: Actively advance incident management enhancement through AI/ML (AIOps). However, AI decisions MUST always be subject to human final confirmation as a principle.

-   **AIOps Application Areas**:

    | Area | AI Utilization | Human Involvement |
    |:-----|:-------------|:-----------------|
    | **Anomaly Detection** | ML-based dynamic baseline + anomaly scoring | Alert confirmation, triage decision |
    | **Predictive Analytics** | Pre-failure prediction (pattern analysis, trend detection) | Prevention measure approval/execution |
    | **Auto-Triage** | Automated incident classification, prioritization, routing | Final confirmation for SEV-1/2 |
    | **Root Cause Suggestion** | Similar case/cause candidate presentation from incident DB | Cause determination |
    | **Auto-Remediation** | Known pattern auto-recovery (restart, scaling, etc.) | Recovery result verification |
    | **Post-Mortem Support** | Automatic timeline generation, impact scope calculation | Review and supplement |
    | **Regulatory Report Support** | Auto-fill report templates, deadline management | Final confirmation and approval |

-   **AIOps Adoption 3 Phases**:
    1.  **Phase 1 (Assist)**: AI reduces alert noise, groups related alerts
    2.  **Phase 2 (Recommend)**: AI recommends response procedures, provides auto-links to runbooks
    3.  **Phase 3 (Autonomous)**: Auto-remediation for low-risk patterns (with Guardrails)

-   **Guardrails**:
    - **Allowed scope for automated remediation**: Only permit auto-remediation for known patterns of SEV-3/4
    - **SEV-1/2 prohibition**: Automated response for critical incidents is **prohibited** (human judgment required)
    - **Rollback**: Immediate rollback mechanism when automated remediation fails
    - **Audit logging**: Complete audit log recording of all AI decisions and actions
    - **Explainability**: Operators must be able to verify the rationale behind AI decisions

-   **Agentic AI & AI SOC Co-pilot (2025-2026 Trends)**:
    - **AI SOC Co-pilot**: AI copilots supporting SOC analysts becoming mainstream. Automated threat prioritization from large data volumes, auto-generation of remediation proposals
    - **Agentic AI**: Rise of AI systems that act autonomously on specific security tasks (executing decisions and mitigation actions with minimal human intervention)
    - **Self-Healing Systems**: Gartner prediction (60%+ of large enterprises will adopt AIOps-based self-healing systems by 2026)
    - **Adoption Principle**: Agentic AI must strictly follow the progression of "assist → recommend → autonomous" with sufficient safety verification at each stage before advancing

-   **SOAR (Security Orchestration, Automation and Response) Integration**:
    - **Definition**: Integrate SOAR as the orchestration layer for AIOps, building automated workflows for detection → triage → response → recovery
    - **SOAR Playbook Design Principles**:
        - 1:1 mapping between detection rules and Playbooks (alerts without corresponding Playbooks are elimination candidates)
        - Human-in-the-loop gates in each Playbook (full automation only for SEV-3/4 known patterns)
        - Playbook version control and testing (Playbook validation in CI/CD pipelines)
    - **SOAR Utilization Metrics**:

        | Metric | Definition | Target |
        |:-------|:----------|:-------|
        | **Playbook Automation Rate** | Playbook-handled incidents / total incidents | ≧ 60% |
        | **MTTR Reduction Rate** | MTTR comparison before/after SOAR deployment | ≧ 50% reduction |
        | **False Positive Reduction Rate** | False positive comparison before/after SOAR | ≧ 70% reduction |
        | **Analyst Productivity** | Incidents processed per analyst | Upward trend |

    - **AI-Generated Incident Response**: Real-time response recommendations from AI SOC Co-pilot:
        - Similar incident historical search and optimal response procedure suggestion
        - Automatic regulatory reporting eligibility determination and report draft generation
        - Post-mortem timeline auto-construction

-   **Alert Fatigue Countermeasures**:
    - **Problem**: Excessive alerts scatter operator attention, leading to missed critical alerts
    - **AI Noise Reduction**: Target 90% noise reduction through ML-based alert correlation and grouping
    - **Metrics**: Regular review of alert reduction rate, false positive rate, alert-to-incident conversion rate
    - **Details**: See §45 (Incident Fatigue & Alert Optimization)

-   **Cross-Reference**: `400_ai_engineering.md` (AI implementation), `502_site_reliability.md` (Observability), §45 (Alert Fatigue), §49 (Self-Healing)

---

## Part XIII: Climate Resilience

### §23. Climate Resilience & Sustainability

-   **Law**: Integrate climate change risks into BCP and crisis management frameworks.
-   **Climate Risk Assessment**:
    - Climate risk assessment for data center / cloud region locations
    - Probability and impact of extreme weather events (floods, heat waves, storms)
    - Data center cooling capacity heat wave resilience assessment
-   **Countermeasures**:
    - Place DR environments to avoid high climate risk regions
    - Power supply redundancy (UPS, generators, renewable energy sources)
    - Green IT promotion and energy efficiency optimization
    - Annual BCP review based on climate risk scenarios

---

## Part XIV: Geopolitical Risk

### §24. Geopolitical Risk & Sovereign Cloud

-   **Law**: Assess the impact of geopolitical risks on business continuity and address data sovereignty requirements.
-   **Geopolitical Risk Assessment**:
    - Political stability assessment of service-providing countries and cloud region host countries
    - Scenario analysis of economic sanctions and export controls on services
    - Data localization regulation compliance (GDPR, China CSL, Russia PDL, etc.)
-   **Sovereign Cloud Strategy**:
    - Cloud provider / region selection based on data sovereignty requirements
    - Vendor risk and geopolitical risk distribution through multi-cloud strategy
    - EU data retention requirements compliance (EU Sovereign Cloud Initiative)
-   **Supply Chain Disruption Countermeasures**:
    - Alternative route assessment for semiconductor/hardware supply chains
    - Geopolitical risk assessment of software licenses (products from sanctioned countries)
-   **Cross-Reference**: `800_internationalization.md` (Data Sovereignty), `601_data_governance.md`

---

## Part XV: Pandemic BCP

### §25. Pandemic BCP

-   **Law**: Develop BCP addressing long-term business continuity risks from infectious disease pandemics.
-   **Pandemic-Specific BCP Elements**:
    - Full remote work transition plan for all employees (within 72 hours)
    - Physical security maintenance plan during office closures
    - Minimum operational structure assuming 50%+ simultaneous absence rate
    - Mental health support enhancement (see §29)
-   **Technology Readiness**:
    - VPN/Zero Trust connection company-wide simultaneous connection testing
    - Online collaboration tool redundancy
    - Paperless workflow promotion and digital workflow establishment
-   **Phased Response Plan**:

    | Phase | Trigger | Action |
    |:------|:--------|:-------|
    | **Monitor** | WHO alerts / early domestic spread | Remote work preparation, BCP review |
    | **Partial Transition** | Regional spread | Regional remote work, office restrictions |
    | **Full Transition** | Pandemic / state of emergency declaration | Company-wide remote, office closure |
    | **Return** | Containment | Phased office reopening |

---

## Part XVI: Incident Automation

### §26. Incident Automation & ChatOps

-   **Law**: Automate repetitive incident response tasks to enable humans to focus on higher-level decision-making.
-   **Automation Targets**:

    | Area | Automation Example | Tool Examples |
    |:-----|:------------------|:-------------|
    | **Detection** | Anomaly detection → auto-alert → Slack channel creation | PagerDuty, OpsGenie, Datadog |
    | **Triage** | Alert classification → severity determination → on-call dispatch | PagerDuty Intelligent Alert Grouping |
    | **Initial Response** | Automated diagnostic data collection (metrics, logs, deploy history) | Slack Bot, Rundeck |
    | **Notification** | Status page auto-update, stakeholder notification | Statuspage API, FireHydrant |
    | **Recovery** | Known pattern auto-remediation (rollback, scaling) | Kubernetes HPA, Lambda |
    | **Documentation** | Auto timeline recording, post-mortem template generation | FireHydrant, Rootly |
    | **Regulatory Reporting** | Auto-generate report templates, deadline countdown | Custom tooling |

-   **ChatOps (Chat-Based Incident Response)**:
    - Immediate action execution via Slack commands (rollback, Kill Switch, etc.)
    - Auto-recording of all response logs in incident channels
    - Bot-driven periodic status reminders

-   **Phased Automation Introduction**:
    1.  **Phase 1**: Notification and documentation automation (low risk)
    2.  **Phase 2**: Diagnostic data auto-collection (medium risk)
    3.  **Phase 3**: Known pattern auto-remediation (high risk — Guardrails required)

---

## Part XVII: Cyber Insurance

### §27. Cyber Insurance & Financial Resilience

-   **Law**: Consider cyber insurance enrollment and adequate coverage to mitigate the financial impact of cyber incidents.
-   **2025-2026 Cyber Insurance Market Trends**:
    - **Market Size**: Global premiums projected to reach $16.4B–$23B by 2026
    - **Risk-Based Segmentation**: Trend toward offering favorable terms to organizations demonstrating robust cyber defenses (MFA deployment, EDR/XDR operation, regular penetration testing as premium reduction requirements)
    - **AI-Related Risks**: Coverage scope for AI-related incidents (prompt injection, AI-generated content breaches, etc.) becoming clarified
    - **Systemic Risk Re-evaluation**: Tightening of insurance underwriting for large-scale, simultaneous incidents such as cloud outages and supply chain attacks
    - **NHI-Related Exclusion Strengthening**: Incidents caused by API key/service account compromise are increasingly excluded from coverage due to inadequate NHI management (see §7.7)
-   **Coverage Checklist**:
    - Ransomware attacks (note: ransom payments often excluded)
    - Data breach response costs (legal, forensics, notification)
    - Business interruption losses
    - Regulatory response costs (fines typically excluded)
    - Third-party liability
    - Reputation recovery costs
    - Indirect losses from supply chain failures
    - **AI-related incident costs** (new coverage category: policy-dependent)
-   **Insurance Claims Process Preparation**:
    - Confirm insurance company's designated forensics provider list
    - Document insurance company notification procedures for incidents
    - Maintain security requirements needed for insurance coverage (MFA, EDR, etc.)
    - **Evidence preservation thoroughness**: Confirm procedures for preserving evidence required for insurance claims (logs, timeline, impact assessment)

-   **IR Retainer Contract (Pre-Contract)**:
    - Recommended to pre-establish retainer contract with IR vendors (CrowdStrike, Mandiant, Secureworks, etc.)
    - Retainer contracts significantly shorten incident response initiation time
    - Pre-establish priority between insurance company-designated IR vendors and self-selected IR vendors
    - Details: See §47 (Ransomware Negotiation & IR Retainer)

-   **Coverage Exclusions Verification**:
    - **Commonly excluded items**: Acts of war, state-sponsored attacks ("war exclusion" clause), neglect of known vulnerabilities, insider threats
    - **Regulatory fines**: Usually not covered (GDPR fines, etc.)
    - **Ransom payments**: Many policies exclude ransom payments from coverage
    - **NHI management failures**: Incidents caused by hardcoded secrets, indefinite tokens, zombie accounts, and other NHI management failures carry high exclusion risk
    - **Unpatched vulnerabilities**: Verify exclusion clauses for failure to patch known vulnerabilities within a defined timeframe
    - Annual review of insurance terms and verification of security posture meeting insurance requirements

-   **Cross-Reference**: §7.7 (NHI Security), §31 (Crisis Management FinOps), §47 (IR Retainer)

---

## Part XVIII: Reputation Recovery

### §28. Reputation Recovery Plan

-   **Law**: Post-major-incident reputation recovery carries equal importance to technical recovery.
-   **Recovery Phases**:
    1.  **Immediate Response (24-72 hours)**: Transparent initial communication, proactive support for affected users
    2.  **Short-Term Recovery (1-4 weeks)**: Third-party audit engagement, improvement progress reporting, regular stakeholder updates
    3.  **Long-Term Recovery (1-6 months)**: Publication of security improvements, trust rebuilding through industry best practice sharing, continuous improvement reporting
-   **Recovery Metrics**:
    - User churn rate monitoring (pre/post incident comparison)
    - NPS (Net Promoter Score) recovery
    - Media sentiment analysis
    - Brand search trend recovery

---

## Part XIX: Human Factors

### §29. Human Factors & Mental Health

-   **Law**: Ensure mental health and sustainable work practices for incident response personnel. Burned-out responders make poor judgments and worsen incidents.
-   **On-Call Load Management**:
    - Appropriate on-call rotation design (max consecutive on-call period limits)
    - Compensation for sleep disruption during on-call (time off, allowances)
    - Ensure minimum 8-hour cooldown time after SEV-1 response during on-call
-   **Post-Incident Care**:
    - Post-major-incident debriefing (psychologically safe retrospective)
    - External counseling resource provision as needed
    - Strict maintenance of Blameless culture in post-mortems
-   **Sustainable Incident Response Team**:
    - Individual dependency elimination (Bus Factor ≧ 2)
    - Incident response skill distribution education across all teams
    - Regular stress checks

---

## Part XX: Physical Security

### §30. Physical Security & BCP

-   **Law**: Include physical security, not just digital security, in BCP.
-   **Physical Security Considerations**:
    - Office/data center entry management and access logs
    - Management and encryption of devices containing sensitive information (laptops, USB, etc.)
    - Clean desk policy enforcement
    - Protection of physical media (backup tapes, etc.) during disasters
-   **Remote Work Environment Security**:
    - Physical security standards for home work (screen lock, privacy filters)
    - Sensitive information printing/removal rules
    - Personal device business use policy (BYOD)

---

## Part XXI: Crisis Management FinOps

### §31. Crisis Management FinOps

-   **Law**: Visualize crisis management activity costs and quantitatively evaluate return on investment.
-   **Cost Visualization**:
    - DR environment operational costs
    - Backup storage costs
    - Monitoring/alerting tool license costs
    - Exercise/training personnel costs
    - Cyber insurance premiums
-   **Cost Optimization Strategies**:
    - DR environment scaling (cost reduction via Pilot Light/Warm Standby)
    - Backup generation management and automated lifecycle management
    - Monitoring tool consolidation and alert noise reduction for operational cost reduction
-   **Incident Cost Tracking**:
    - Direct costs per incident (downtime, recovery work, forensics)
    - Indirect costs (reputation loss, user churn, regulatory response)
    - **Cost Avoidance Quantification**: Estimate costs of incidents prevented by preventive measures
-   **DDoS Attack Cost Protection**:
    - Auto-scaling upper limit settings (cost explosion prevention)
    - Cloud provider DDoS protection service utilization (AWS Shield Advanced cost protection, etc.)
    - Abnormal cost detection alert configuration
-   **Cross-Reference**: `502_site_reliability.md` §9 (FinOps), `361_aws_cloud.md` (Cost Management)

---

## Part XXII: NIS2 Directive Integration

### §32. NIS2 (Network and Information Security Directive 2) Integration

-   **Law**: When providing critical services within the EU or playing a significant role in the technology supply chain, you MUST implement cybersecurity requirements compliant with **NIS2 Directive (Directive (EU) 2022/2555)**. NIS2 has been progressively enforced across member states following the October 17, 2024 national transposition deadline.

-   **NIS2 Key Requirements Mapping**:

    | NIS2 Requirement | Content | This Rule Mapping |
    |:----------------|:--------|:-----------------|
    | **Risk Management Measures** | Technical, operational, and organizational security measures | §4 Risk Assessment, §19 Governance |
    | **Incident Reporting** | Phased reporting obligation for significant incidents | §34 Incident Reporting International Harmonization |
    | **Supply Chain Security** | ICT supply chain security assessment | §12 Vendor BCP |
    | **Business Continuity Management** | BCM, backup management, disaster recovery | §11 BCP, §13-§15 DR |
    | **Encryption & Data Protection** | Encryption policies, data integrity protection | §15 Data Protection, §35 PQC |
    | **Asset Management** | ICT asset identification, classification, and management | `600_security_privacy.md` |

-   **NIS2 Incident Reporting Timeline**:

    | Report Stage | Deadline | Content |
    |:-----------|:---------|:--------|
    | **Early Warning** | **Within 24 hours** after significant incident awareness | Suspected malicious activity, cross-border impact status |
    | **Incident Notification** | **Within 72 hours** after awareness | Severity/impact assessment, indicators of compromise (IoC) |
    | **Final Report** | **Within 1 month** after initial notification | Complete analysis, root cause, corrective measures |
    | **Progress Report** | If unresolved | Periodic progress status reporting |

-   **NIS2 "Significant Incident" Definition**:
    - Causes or potentially causes severe operational disruption to services
    - Causes significant financial losses
    - Causes considerable material or non-material damage to other natural or legal persons

-   **OT Security Requirements (NIS2 Extended Scope)**:
    - NIS2 explicitly includes OT-dependent sectors (energy, manufacturing, transport, healthcare)
    - IT/OT network separation and monitoring
    - Industrial protocol monitoring (Modbus, OPC UA, etc.)
    - Secure backup of legacy systems
    - Vulnerability management avoiding production downtime
    - Coordinate with §36 (OT/ICS Crisis Management)

-   **EU-CyCLONe (European Cyber Crisis Liaison Organisation Network)**:
    - Coordination and information sharing between member states during large-scale incidents
    - Building liaison with each member state's cyber crisis management authority

-   **Cross-Reference**: §34 (Incident Reporting Harmonization), §36 (OT/ICS), `600_security_privacy.md`, `601_data_governance.md`

---

## Part XXIII: EU CRA Integration

### §33. EU CRA (Cyber Resilience Act) Integration

-   **Law**: When manufacturing or selling products with digital elements (software, hardware, IoT devices, etc.), you MUST implement vulnerability management and reporting systems compliant with **EU CRA (Regulation (EU) 2024/2847)**. CRA entered into force on December 10, 2024, with **reporting obligations applying from September 11, 2026**.

-   **CRA Vulnerability Reporting Obligations**:

    | Report Stage | Deadline | Content |
    |:-----------|:---------|:--------|
    | **Early Warning Notification** | **Within 24 hours** after awareness of actively exploited vulnerability | Vulnerability summary, affected products |
    | **Vulnerability Notification** | **Within 72 hours** after awareness | Product details, exploitation nature, mitigation measures |
    | **Final Report** | **Within 14 days** after corrective measures become available | Complete incident details, severity, corrective measures |

-   **Reporting Targets**:
    - **CSIRT (Computer Security Incident Response Team)** of the manufacturer's primary member state
    - **ENISA (European Union Agency for Cybersecurity)**
    - **ENISA SRP (Single Reporting Platform)**: Unified reporting platform scheduled to launch September 2026

-   **CRA Impact on Crisis Management**:
    - **Security-by-Design**: Security assurance throughout the product lifecycle
    - **Vulnerability Handling Obligation**: Obligation to actively manage and remediate product vulnerabilities
    - **User Notification Obligation**: Notify users about incidents affecting product security
    - **SBOM (Software Bill of Materials)**: Maintain and provide product software bill of materials
    - **Crypto Agility**: Encryption algorithm switchover readiness for PQC migration (see §35)

-   **DORA/NIS2/CRA Reporting Overlap Management**:
    - When subject to multiple regulations simultaneously, use §34 integrated reporting workflow
    - Apply the strictest deadline as baseline (DORA: 4h > NIS2: 24h > CRA: 24h)

-   **Cross-Reference**: §34 (Incident Reporting Harmonization), §35 (PQC), `602_oss_compliance.md` (SBOM)

---

## Part XXIV: Incident Reporting International Harmonization

### §34. Incident Reporting International Harmonization

-   **Law**: When incidents span multiple regulatory jurisdictions, you MUST manage each regulation's reporting obligations in an integrated manner and comply with all statutory deadlines.

-   **Regulatory Incident Reporting Timeline Comparison Table**:

    | Regulation | Initial Notification | Intermediate/Detail Report | Final Report | Applicability |
    |:----------|:-------------------|:-------------------------|:------------|:-------------|
    | **DORA** | Within 4 hours | Within 72 hours | Within 1 month | EU financial sector major ICT incident |
    | **NIS2** | Within 24 hours | Within 72 hours | Within 1 month | EU essential/important entity significant incident |
    | **EU CRA** | Within 24 hours | Within 72 hours | Within 14 days | Actively exploited product vulnerability |
    | **GDPR** | Within 72 hours | — | — | Personal data breach |
    | **Applicable Regional Law** | Promptly (preliminary) | — | Within 30 days (final) | Personal data leak |
    | **CCPA/CPRA** | Without unreasonable delay | — | — | CA consumer data breach |
    | **APRA CPS 230 (Australia)** | Within 72 hours based on severity | — | As soon as reasonably practicable | Australian financial institution significant business service disruption |
    | **PIPA (South Korea)** | Within 72 hours | — | — | Personal data breach affecting 10,000+ records |
    | **LGPD (Brazil)** | Within reasonable time (ANPD recommends: within 2 business days) | — | — | Personal data breach |

-   **Multi-Regulation Response Workflow**:
    1.  **Incident Occurs**: Severity determination + impact scope identification
    2.  **Identify Applicable Regulations**: Identify all applicable regulations based on incident content/scope
    3.  **Identify Shortest Deadline**: Adopt the shortest initial notification deadline among applicable regulations (e.g., DORA's 4 hours)
    4.  **Simultaneous Reporting**: Report to all regulatory authorities simultaneously where possible, avoiding one-by-one responses
    5.  **Deadline Management**: Register all intermediate/final report deadlines in calendar, confirm compliance
    6.  **Report Template Utilization**: Pre-prepare regulation-specific report templates (use forms provided by regulatory authorities)

-   **Regulatory Reporting Automation Support**:
    - Auto-population of report templates via incident management tool integration
    - Countdown alerts for regulation-specific deadlines
    - Report history archiving and audit support

-   **EU Digital Omnibus Package (Report Once Principle)**:
    - "Digital Omnibus Package" proposed by the European Commission in November 2025
    - **"Report Once, Share Many" Principle**: Single Entry Point operated by ENISA for unified reporting across NIS2/DORA/GDPR/CER and other regulations
    - **Expected enforcement**: Application starts 18-24 months after adoption (expected late 2026 onwards)
    - **Preparation**: Maintain current individual reporting systems while advancing report data structuring for transition to unified reporting
    - Details: See §42 (EU Digital Omnibus Package Integration)

-   **SEC & Japan Disclosure Requirements**:
    - **SEC (US)**: Form 8-K disclosure obligation within 4 business days for material cyber incidents (see §48)
    - **NYSE / NASDAQ**: Incident disclosure judgment based on listed company timely disclosure rules

-   **Cross-Reference**: §7.2 (Data Breach), §21 (DORA), §32 (NIS2), §33 (CRA), §42 (Digital Omnibus), §48 (SEC Disclosure), `601_data_governance.md`

---

## Part XXV: Quantum Computing Threats

### §35. Quantum Computing Threats & PQC (Post-Quantum Cryptography)

-   **Law**: Assess cryptographic break risks from quantum computing evolution and systematically advance migration preparation to Post-Quantum Cryptography (PQC).

-   **HNDL (Harvest Now, Decrypt Later) Attacks**:
    - Threat where attackers collect currently encrypted data to decrypt with future quantum computers
    - **Long-term classified data** (government data, medical data, intellectual property, authentication credentials) are immediate risk assessment targets
    - Countermeasures must begin now (it will be too late once quantum computers become practical)

-   **CBOM (Cryptographic Bill of Materials)**:
    - Inventory all cryptographic algorithms used in products/services
    - Identify usage locations of quantum-vulnerable algorithms (RSA, ECDSA, DH, etc.)
    - Maintain cryptographic inventory enabling rapid switchover during PQC migration

-   **Crypto Agility**:
    - Design enabling cryptographic algorithm switchover without application changes
    - Ensure crypto agility in TLS libraries, key management systems, backup encryption
    - Eliminate hardcoded cryptographic algorithm dependencies

-   **PQC Migration Roadmap (EU Recommendation-Based)**:

    | Phase | Deadline | Action |
    |:------|:---------|:-------|
    | **Inventory** | 2025-2026 | Create CBOM, identify quantum-vulnerable cryptography |
    | **Planning** | By end of 2026 | Develop PQC migration plan, prioritize |
    | **High-Risk Migration** | By 2030 | Quantum-safe high-risk use cases |
    | **Complete Migration** | By 2035 | Complete migration from quantum-vulnerable cryptography |

-   **NIST PQC Standards**:
    - **ML-KEM (CRYSTALS-Kyber)**: Key encapsulation mechanism
    - **ML-DSA (CRYSTALS-Dilithium)**: Digital signatures
    - **SLH-DSA (SPHINCS+)**: Hash-based digital signatures
    - Incorporate into migration plan once supported by established cryptographic libraries

-   **Cross-Reference**: `600_security_privacy.md` (Encryption), §15 (Backup Encryption)

---

## Part XXVI: OT/ICS/SCADA Crisis Management

### §36. OT/ICS/SCADA Crisis Management

-   **Law**: When operating Industrial Control Systems (ICS), SCADA, and OT environments, you MUST implement crisis management requirements unique to these environments, which differ from IT environments.

-   **IT/OT Integrated Incident Response**:
    - Build integrated IT SOC and OT SOC monitoring systems
    - OT incident severity classification (safety impact as top priority)
    - Maintain **physical segmentation** between IT/OT networks
    - OT environment-specific incident response playbooks (considering operational shutdown risk)

-   **OT-Specific Considerations**:
    - **Safety First**: In OT environments, Safety ALWAYS takes priority over Security
    - **Legacy Systems**: Alternative security measures for legacy ICS where patching is difficult
    - **Availability Requirements**: OT system 24/7 operation requirements and maintenance window constraints
    - **Industrial Protocols**: Fixed protocol monitoring (Modbus, OPC UA, PROFINET, etc.)
    - **Physical Access Control**: Strict access management to OT control rooms

-   **Compliance Frameworks (OT-Specific)**:
    - **IEC 62443**: Industrial communication network security
    - **NERC CIP**: Electric sector critical infrastructure protection
    - **NIS2 OT Requirements**: OT security for energy, manufacturing, transport sectors

-   **OT Environment DR**:
    - PLC/HMI configuration backup and restoration procedures
    - OT environment recovery prioritizes **return to safe state** above all
    - Develop OT-DR plans independent from IT environment DR

-   **Cross-Reference**: §32 (NIS2 OT Requirements), `600_security_privacy.md`

---

## Part XXVII: Legal Readiness

### §37. Legal Readiness & Digital Forensics

-   **Law**: Pre-establish systems to preserve digital evidence in legally valid form during incidents, maintaining evidence integrity and traceability.

-   **Chain of Custody**:
    - Record the entire process of digital evidence collection, storage, transfer, and analysis
    - Clearly document personnel, dates, and methods at each stage
    - Record hash values (SHA-256 or higher) for tampering detection
    - Pre-define procedures for handover to law enforcement

-   **Forensic Readiness**:
    - Ensure sufficient log retention period (minimum 90 days, extend per regulatory requirements)
    - Log tamper prevention (immutable storage, centralized log management)
    - Pre-prepare forensic toolkits (disk imaging, memory dumps, etc.)
    - Secure forensics-capable personnel or retainer contracts

-   **eDiscovery Compliance**:
    - Electronic data preservation obligations for litigation/regulatory investigations (legal hold)
    - Pre-define data preservation scope and procedures
    - Establish cloud environment data preservation methods (cooperation with providers)

-   **Cross-Border Investigation Support**:
    - Consider international legal jurisdiction (MLAT, CLOUD Act, etc.)
    - Understand data provision requirements across different jurisdictions
    - Establish liaison procedures with international law enforcement

-   **Cross-Reference**: §6 (Evidence Preservation), §7 (Cyber Incidents), `601_data_governance.md`

---

## Part XXVIII: Advanced Exercise Programs

### §38. Advanced Exercise Programs

-   **Law**: In addition to tabletop exercises (§16), gradually introduce more advanced and practical exercise programs to continuously improve organizational resilience.

-   **Purple Team Exercises**:
    - Collaborative execution between **Red Team (attack team)** and **Blue Team (defense team)**
    - Identify gaps between attack techniques and detection/response capabilities
    - Recommend quarterly execution (maturity L3+)
    - Directly connect results to runbook and monitoring rule improvements

-   **TLPT (Threat-Led Penetration Testing) Details**:
    - Threat-based testing following TIBER-EU/TIBER-JP frameworks
    - **Threat Intelligence Phase**: Threat information collection and attack scenario development
    - **Red Team Phase**: Actual attack simulation (limited to notified managers)
    - **Blue Team Assessment**: Evaluate defense team detection and response capability
    - **Remediation Phase**: Remediate discovered vulnerabilities and detection gaps
    - DORA-subject organizations must conduct every 3 years

-   **Scenario Design Methodology**:
    - Systematic attack scenario design based on MITRE ATT&CK framework
    - Select realistic attack scenarios based on threat intelligence
    - Multi-vector attack scenarios (e.g., DDoS + ransomware + social engineering)
    - Integrated scenarios including regulatory reporting

-   **Exercise Metrics**:

    | Metric | Measurement Target | Improvement Goal |
    |:-------|:------------------|:----------------|
    | **Detection Rate** | Percentage of injected faults detected | 100% |
    | **Detection Time** | Time from fault injection to detection | ≦ MTTD target |
    | **Response Time** | Time from detection to initial response | ≦ MTTA target |
    | **Recovery Time** | Percentage recovered within RTO from fault injection | 100% |
    | **Communication Accuracy** | Accuracy and timeliness of notifications | 100% |
    | **Regulatory Reporting Compliance** | Regulatory report deadline compliance rate during exercises | 100% |

-   **Cross-Reference**: §16 (Tabletop Exercises), §21 (DORA TLPT), `700_qa_testing.md`

---

## Part XXIX: Multi-Cloud DR

### §39. Multi-Cloud & Hybrid DR

-   **Law**: Assess single cloud provider dependency risk and develop multi-cloud or hybrid cloud DR strategies as needed.

-   **Multi-Cloud DR Strategies**:
    - **Primary/Secondary Cloud**: Place production and DR environments on different cloud providers
    - **Service-Level Distribution**: Select optimal cloud provider per function, avoiding SPOF
    - **Cost/Resilience Tradeoff Evaluation**: Multi-cloud operational cost increase vs resilience improvement

-   **Cross-Cloud Failover Design**:
    - **Abstraction Layer**: Minimize direct dependency on cloud provider-specific APIs
    - **IaC Portability**: Cross-cloud infrastructure code management via Terraform/OpenTofu
    - **Data Synchronization**: Cross-cloud data sync mechanisms (latency/consistency considerations)
    - **DNS Failover**: Multi-cloud capable DNS-based failover

-   **Vendor Lock-in Avoidance**:
    - Decision framework for cloud-specific service usage (benefits vs lock-in risk)
    - Portability assurance through containerization (Docker/Kubernetes)
    - Open standards adoption (OpenTelemetry, CloudEvents, etc.)
    - Regular cross-cloud migration testing

-   **Hybrid Cloud DR**:
    - DR environment design combining on-premises and cloud
    - Secure on-premises–cloud connection via VPN/dedicated lines
    - Placement policies based on data classification (on-premises retention for sensitive data, etc.)

-   **Cross-Reference**: §13-§14 (DR Strategy), `361_aws_cloud.md`

---

## Part XXX: Zero-Day Vulnerability Response (Detailed)

### §40. Zero-Day Vulnerability Response (Detailed Protocol)

-   **Law**: Establish response protocols spanning the entire zero-day vulnerability lifecycle, minimizing time from discovery to remediation completion.

-   **Zero-Day Response Phases**:

    | Phase | Action | SLA |
    |:------|:-------|:----|
    | **Awareness** | Monitor threat intelligence feeds, CERT advisories, vendor notifications | Immediate |
    | **Triage** | Impact assessment on own environment, CVSS score review, attack surface analysis | Within 2 hours |
    | **Mitigation** | Virtual patching (WAF/IPS), feature disabling, network restrictions | Within 4 hours |
    | **Patch Application** | Vendor patch test → staging → canary → full rollout | Within 24 hours (Critical) |
    | **Verification** | Post-patch normality confirmation, IoC monitoring | Immediately post-patch |
    | **Reporting** | If CRA-applicable, report to ENISA/CSIRT within 24 hours | §33 compliant |

-   **Threat Intelligence Integration**:
    - **Threat Feeds**: Auto-monitoring of MITRE, NVD, JPCERT/CC, US-CERT feeds
    - **IoC (Indicators of Compromise)**: Auto-reflection of attack indicators into SIEM/EDR
    - **Vulnerability Scanning**: Auto-execution of scanning upon new CVE publication
    - **Information Sharing**: Industry threat information sharing through ISACs

-   **Coordinated Vulnerability Disclosure (CVD)**:
    - Liaison procedures with external researchers who discover own product vulnerabilities
    - Publication of responsible disclosure policy (security.txt standard adoption)
    - Manage publication timeline after fix/patch application
    - Coordinate with EU CRA vulnerability reporting obligations (see §33)

-   **Cross-Reference**: §7.5 (Zero-Day Immediate Response), §33 (CRA Vulnerability Reporting), `600_security_privacy.md`

---

## Part XXXI: Crisis Management Regulatory Timeline

### §41. Crisis Management Regulatory Timeline 2025-2028

-   **Law**: Understand the enforcement and reporting start dates of major regulations related to crisis management, and systematically advance organizational preparation.

-   **Major Regulatory Timeline**:

    | Regulation | Milestone | Date | Impact |
    |:----------|:---------|:-----|:------|
    | **DORA** | Full enforcement | January 17, 2025 | ICT risk management and reporting obligations effective |
    | **NIS2** | National transposition deadline | October 17, 2024 | Progressive enforcement across member states |
    | **NIS2** | Technical measures adoption (some states) | October 1, 2026 | Security measure implementation obligations |
    | **NIS2** | All security measures implementation deadline | October 31, 2026 | IT/OT protection, BCP, risk management, IR, SC |
    | **EU CRA** | Entry into force | December 10, 2024 | Regulatory framework establishment |
    | **EU CRA** | Conformity assessment body designation | June 11, 2026 | Certification framework establishment |
    | **EU CRA** | Vulnerability reporting obligations start | September 11, 2026 | 24h/72h/14d reporting obligations |
    | **EU CRA** | Full application | December 11, 2027 | All requirements applicable |
    | **Digital Omnibus** | European Commission proposal | November 2025 | Report Once principle proposed |
    | **Digital Omnibus** | Application start (expected) | Late 2026 - 2027 | ENISA unified reporting portal operational |
    | **EU PQC** | PQC migration start | By end of 2026 | Crypto agility readiness |
    | **EU PQC** | High-risk quantum-safe | By 2030 | High-risk use case PQC migration complete |
    | **NIST SP 800-61** | Rev.3 revision | April 2025 | Incident response guide update |

-   **Organizational Readiness Checklist**:
    - [ ] DORA: ICT risk management framework implemented
    - [ ] DORA: Incident reporting process established (4h/72h/1m)
    - [ ] DORA: Reporting forms prepared per delegated regulations 2025/301 & 302
    - [ ] NIS2: Applicability determination completed
    - [ ] NIS2: 24h early warning, 72h notification, 1m final report system established
    - [ ] NIS2: Security measures implementation plan for October 2026 deadline
    - [ ] CRA: Product security system established
    - [ ] CRA: Vulnerability reporting process established (by September 2026)
    - [ ] PQC: CBOM (Cryptographic Bill of Materials) creation started
    - [ ] PQC: Crypto agility design review conducted
    - [ ] Digital Omnibus: Report data structuring for unified reporting transition

-   **Cross-Reference**: §21 (DORA), §32 (NIS2), §33 (CRA), §35 (PQC), §42 (Digital Omnibus)


---

## Part XXXII: EU Digital Omnibus Package Integration

### §42. EU Digital Omnibus Package Integration

-   **Law**: Systematically prepare for the transition to a unified reporting framework based on the "Report Once, Share Many" principle of the EU Digital Omnibus Package (proposed November 2025).

-   **Overview**:
    - Digital regulatory simplification package proposed by the European Commission on November 19, 2025
    - Objective is to consolidate and simplify multiple overlapping incident reporting obligations
    - Establishment of a **Single Entry Point** operated by **ENISA (European Union Agency for Cybersecurity)**

-   **Integrated Regulations**:

    | Regulation | Current Reporting To | After Integration |
    |:----------|:-------------------|:-----------------|
    | **NIS2** | Member state CSIRTs + supervisory authorities | ENISA Single Entry Point |
    | **DORA** | Financial supervisory authorities | ENISA Single Entry Point |
    | **GDPR** | Data protection authorities | ENISA Single Entry Point |
    | **CER Directive** | Critical entity supervisory authorities | ENISA Single Entry Point |
    | **eIDAS Regulation** | Electronic authentication supervisory authorities | ENISA Single Entry Point |

-   **GDPR Amendment Proposal (within Digital Omnibus)**:
    - Proposed extension of personal data breach notification deadline from 72 hours to **96 hours**
    - Proposed raising of notification threshold to high-risk cases only
    - Final determination depends on legislative process progress

-   **Organizational Preparation**:
    1.  **Maintain Current Systems**: Maintain existing individual reporting processes until unified reporting framework is enforced
    2.  **Structuring Report Data**: Map reporting fields from each regulation to a unified format
    3.  **Tool Readiness**: Plan for incident management tool upgrades to support unified reporting
    4.  **Legal Team Coordination**: Regular monitoring of Digital Omnibus legislative progress

-   **Enforcement Timeline**:
    - November 2025: European Commission proposal
    - 2026-2027: European Parliament and Council deliberation
    - 18-24 months after adoption: Application start

-   **Cross-Reference**: §34 (International Incident Reporting Harmonization), §41 (Regulatory Timeline), `601_data_governance.md`

---

## Part XXXIII: Crisis Management Team Education & Training Framework

### §43. Crisis Management Team Education & Training Framework

-   **Law**: Incident response capability depends on individual skills, creating high Bus Factor risk. Establish a systematic education and training program to elevate the organization's overall incident response capability.

-   **Incident Responder Certification (3 Levels)**:

    | Level | Title | Requirements | Authority |
    |:------|:------|:------------|:---------|
    | **L1: Observer** | Trainee | Participated in 1+ tabletop exercises | Incident observation and recording |
    | **L2: Responder** | Responder | L1 + 2+ real incident responses, runbook creation ability | Incident response execution, Ops Lead backup |
    | **L3: Commander** | Commander | L2 + SEV-1 response experience, leadership training completed | Incident Commander, escalation judgment |

-   **Education Roadmap**:
    1.  **Basic Education (All Engineers)**: Incident response flow, post-mortem culture, on-call guidelines
    2.  **Intermediate Education (L2 Candidates)**: Runbook creation, triage judgment, communication practice
    3.  **Advanced Education (L3 Candidates)**: Crisis decision-making, media response, regulatory reporting practice
    4.  **Specialized Education**: Forensics, cyberattack analysis, legal response

-   **Skill Maintenance Requirements**:
    - L2/L3 certification maintenance requires **2+ exercise participations per year** and **1+ real incident response per year**
    - If no incident response involvement for 12+ months, certification level re-evaluation is conducted
    - Mandatory annual update training on latest threats including Deepfake and AI threats

-   **Cross-Training**:
    - Distribute incident response capability for each service across **minimum 2+ personnel** to eliminate single-person dependencies
    - Quarterly cross-assignment of on-call rotation target services
    - Recommend participation in other teams' runbook reviews

-   **Cross-Reference**: §5 (Incident Response Framework), §16 (Tabletop Exercises), §29 (Human Factors)

---

## Part XXXIV: Digital Twin DR

### §44. Digital Twin DR

-   **Law**: Leverage digital twin technology to improve DR environment verification accuracy and simulation capability (consider adoption at maturity L4+).

-   **Digital Twin Application Areas**:

    | Area | Application | Expected Effect |
    |:-----|:-----------|:---------------|
    | **DR Verification** | Failover testing on production environment digital twin | Zero production impact DR verification |
    | **Failure Prediction** | Real-time simulation-based failure prediction | Proactive availability improvement |
    | **Capacity Planning** | Pre-planned capacity through load simulation | Preparation for sudden loads like DDoS |
    | **Change Impact Analysis** | Pre-verification of infrastructure changes on digital twin | Reduction of change-induced failures |

-   **Implementation Approach**:
    - IaC (Infrastructure as Code)-based complete production environment replication
    - Replay of observation data (metrics, logs, traces) to digital twin
    - Safe execution of chaos engineering in digital twin environment
    - Cost management: Build digital twin environments using spot instances/preemptible instances

-   **Cross-Reference**: §13-§14 (DR Strategy), §39 (Multi-Cloud DR), `502_site_reliability.md` (Chaos Engineering)

---

## Part XXXV: Incident Fatigue & Alert Optimization

### §45. Incident Fatigue & Alert Optimization

-   **Law**: Alert Fatigue is the primary cause of missed incidents. Continuously improve alert quality and properly manage responder Cognitive Load.

-   **Alert Fatigue Countermeasure Framework**:

    | Countermeasure | Content | Target |
    |:-------------|:--------|:-------|
    | **Noise Reduction** | Filtering duplicate and low-priority alerts | 70% reduction in total alerts |
    | **Correlation Analysis** | Automated alert grouping (AIOps) | 1 incident = 1 alert group |
    | **Dynamic Thresholds** | ML-based dynamic baselines (elimination of fixed thresholds) | 50% reduction in false positives |
    | **Prioritization** | Automatic prioritization based on business impact | 100% immediate response rate for critical alerts |
    | **Periodic Review** | Quarterly alert rule review and pruning | Continuous elimination of unnecessary alerts |

-   **Alert Quality Metrics**:

    | Metric | Definition | Target |
    |:-------|:----------|:-------|
    | **Signal-to-Noise Ratio** | Actionable alerts / Total alerts | ≧ 80% |
    | **False Positive Rate** | False positive alerts / Total alerts | ≦ 5% |
    | **Alert-to-Incident Ratio** | Percentage of alerts converted to incidents | Track & improve |
    | **MTTA (Mean Time to Acknowledge)** | Time from alert to acknowledgment | ≦ 5 min (SEV-1/2) |
    | **Alert Volume Trend** | Monthly total alert count trend | Decreasing trend |

-   **Cognitive Load Management**:
    - Set upper limit on concurrent alerts during on-call (recommended: 3 or fewer simultaneous)
    - Staged alert notification (relevant team only initially, expanded on escalation)
    - Incident dashboard design guidelines to prevent information overload
    - Include Cognitive Load evaluation in post-on-call retrospectives

-   **Cross-Reference**: §22 (AIOps), §29 (Human Factors & Mental Health), `502_site_reliability.md` (Observability)

---

## Part XXXVI: Cyber Range & AI Red Team

### §46. Cyber Range & AI Red Team

-   **Law**: In addition to traditional tabletop exercises and penetration tests, establish advanced training environments using cyber range platforms and AI Red Teams (consider adoption at maturity L4+).

-   **Cyber Range Platform**:
    - Practical incident response training in virtual environments simulating production
    - Automated attack scenario generation with phased escalation
    - Dynamic difficulty adjustment based on participant skill level
    - Quantitative training result evaluation (detection time, response time, containment success rate)

-   **AI Red Team**:
    - AI-powered automated attack simulation (MITRE ATT&CK framework compliant)
    - Social engineering training using AI-generated phishing emails and deepfake audio
    - Automated gap analysis of defensive team detection capabilities
    - **Human Oversight**: All AI Red Team activities execute within pre-approved scope, results always reviewed by humans

-   **CTF (Capture The Flag) Integrated Training**:
    - Quarterly internal CTF events (maturity improvement and skill assessment)
    - CTF challenge creation themed around incident response
    - Use CTF results as evaluation metrics for incident responder certification (§43)

-   **Cross-Reference**: §38 (Advanced Exercise Programs), §43 (Education & Training Framework), `700_qa_testing.md`

---

## Part XXXVII: Ransomware Negotiation & IR Retainer

### §47. Ransomware Negotiation & IR Retainer

-   **Law**: Pre-establish incident response (IR) retainer contracts and negotiation protocols in preparation for major cyber incidents such as ransomware attacks.

-   **IR Retainer Contract**:
    - **Pre-Contract**: Establish retainer contracts with trusted IR vendors (CrowdStrike, Mandiant, Secureworks, etc.) before incidents occur
    - **SLA**: Explicitly state post-incident response initiation SLA in retainer contract (recommended: remote response start within 2 hours)
    - **Scope**: Specify scope of forensics, malware analysis, log preservation, recovery support, and legal advice in contract
    - **Insurance Company Coordination**: Pre-determine priority when insurance company-designated IR vendors differ from retainer contract vendors

-   **Forensics Vendor Pre-Selection**:
    - Prevent time spent on vendor selection during incident response
    - Pre-execute non-disclosure agreements (NDAs)
    - Pre-verify vendor response capabilities (24/7 availability, multilingual support, etc.)
    - Annual vendor evaluation and contract renewal decisions

-   **Ransomware Negotiation Protocol**:
    - **Prohibited by Default**: Ransom payment is **prohibited in principle** (see §7.1)
    - **Exception Judgment Process**: Escalation flow when payment is considered:
        1.  Management approval (CEO/CTO)
        2.  Legal department risk assessment (payment itself may be illegal if target is a sanctioned nation's group)
        3.  Cyber insurance company notification and advice
        4.  Law enforcement notification and cooperation
    - **Negotiation Specialist**: Delegate payment decisions and negotiation to specialized negotiators (external outsourcing recommended), technical team focuses on recovery
    - **Recording Obligation**: Complete recording of negotiation process and decision rationale (preservation as legal evidence)

-   **Cross-Reference**: §7.1 (Ransomware), §27 (Cyber Insurance), §37 (Legal Preparedness)

---

## Part XXXVIII: CISO & Management Liability and Board Reporting

### §48. CISO & Management Liability and Board Reporting

-   **Law**: Cyber risk is business risk. Recognize the legal liability of CISOs and management, and establish a framework for regular cybersecurity risk reporting to the board of directors.

-   **Management Legal Liability**:

    | Regulation/Framework | Liability Content | Penalties |
    |:--------------------|:-----------------|:---------|
    | **NIS2** | Personal responsibility for approval and oversight of cybersecurity measures | Codified personal liability, sanctions for negligence |
    | **SEC (US)** | Materiality judgment of cyber incidents and disclosure within 4 business days | SEC enforcement actions for disclosure violations |
    | **DORA** | ICT risk management framework implementation responsibility | Financial supervisory authority sanctions |
    | **J-SOX** | Incident response framework as part of IT general controls | Impact on internal control reports |

-   **Board Cybersecurity Risk Reporting Framework**:

    | Report Item | Content | Frequency |
    |:-----------|:--------|:---------|
    | **Risk Dashboard** | Key Cyber Risk Indicator (KRI) summary | Quarterly |
    | **Incident Summary** | Major incident overview and response results for the period | Quarterly |
    | **Compliance Status** | Regulatory requirement compliance status and audit results | Semi-Annual |
    | **Investment ROI** | Security investment ROI and cost avoidance track record | Annual |
    | **Benchmark** | Industry benchmark comparison (maturity model) | Annual |

-   **CISO Organizational Positioning**:
    - Recommended that CISO has direct reporting line to CEO/Board (independent from CTO hierarchy)
    - Secure authority for immediate escalation to management during cyber incidents
    - Participation in security investment decision-making

-   **Cross-Reference**: §19 (Governance), §27 (Cyber Insurance), §34 (SEC Disclosure)

---

## Part XXXIX: Self-Healing & Autonomous Recovery Systems

### §49. Self-Healing & Autonomous Recovery Systems

-   **Law**: Progressively introduce self-healing systems and build automated recovery capability for known failure patterns. However, Guardrails must always be in place, operating under human oversight.

-   **Self-Healing Maturity Model**:

    | Level | Name | Content | Example |
    |:------|:-----|:--------|:--------|
    | **L1: Manual** | Manual | All recovery operations are manual | Operator executes commands |
    | **L2: Scripted** | Scripted | Recovery procedures scripted | Runbook execution button |
    | **L3: Automated** | Automated | Trigger-based automated recovery | Kubernetes Self-Healing, HPA |
    | **L4: Adaptive** | Adaptive | AI-based failure prediction and proactive response | AIOps predictive analysis → preemptive remediation |
    | **L5: Autonomous** | Autonomous | Autonomous response to unknown patterns | Fully autonomous recovery (future goal, Guardrails mandatory) |

-   **Kubernetes Self-Healing (Implementation Example)**:
    - **Liveness Probe**: Container health check → automatic restart on failure
    - **Readiness Probe**: Traffic acceptance check → don't route to unready Pods
    - **PodDisruptionBudget**: Guarantee minimum running Pods during maintenance
    - **Horizontal Pod Autoscaler (HPA)**: Automatic scaling based on CPU/memory usage
    - **Node Auto-repair**: Automatic recovery on node failure and Pod rescheduling

-   **Guardrails (Mandatory)**:
    - **Blast Radius Limitation**: Restrict auto-remediation scope (per cluster/service unit)
    - **Rate Limiting**: Upper limit on auto-remediation count per time unit (infinite loop prevention)
    - **Circuit Breaker**: Stop auto-remediation and escalate to humans on consecutive failures
    - **Audit Trail**: Complete recording and post-review of all auto-remediation actions
    - **SEV-1/2 Prohibition**: Auto-remediation for critical incidents is **prohibited** (§22 Guardrail compliant)

-   **Cross-Reference**: §22 (AIOps), §26 (Incident Automation), `502_site_reliability.md` (Chaos Engineering)

---

## Part XL: Crisis Simulation & War Game

### §50. Crisis Simulation & War Game

-   **Law**: In addition to tabletop exercises (§16) and cyber range (§46), regularly conduct cross-functional crisis simulations (War Games) involving management to validate the organization's overall decision-making capability.

-   **Management War Game**:
    - **Objective**: Validate speed and accuracy of management decisions during cyber incidents
    - **Participants**: CEO, CTO, CISO, Legal Officer, Communications Officer, HR Officer
    - **Scenario Examples**:
        - Large-scale ransomware attack + media coverage + regulatory inquiries
        - Data breach + litigation risk + stock price impact
        - Supply chain attack + business continuity decisions

-   **Cross-Functional Simulation**:
    - Validate coordination between technical team × legal × communications × customer support
    - Practical regulatory reporting process training (mock report creation and submission)
    - Stakeholder notification dry runs

-   **Decision-Making Training**:
    - **Time-Pressured Decision Making**: Simulated decision-making under time constraints
    - **Fog of War**: Judgment training under incomplete and contradictory information
    - **Ethical Dilemmas**: Ethical dilemma scenarios for ransom payment decisions, disclosure timing decisions, etc.

-   **Frequency and Recording**:
    - Management War Game: Recommended **2+ times per year**
    - Recording of training results and tracking of improvement actions
    - Reflect training lessons in §19 Governance KPIs

-   **Cross-Reference**: §16 (Tabletop Exercises), §38 (Advanced Exercise Programs), §43 (Education & Training Framework), §48 (Board Reporting)
---

## Part XLI: Insider Threat Program

### §51. Insider Threat Program

-   **Law**: Insider threats are increasingly manifesting as forms where external attackers actively recruit insiders. Establish a cross-functional insider threat management program in compliance with the CISA 2026 guidance.

-   **Insider Threat Classification**:

    | Type | Overview | Detection Difficulty |
    |:-----|:---------|:-------------------:|
    | **Malicious Insider** | Intentional data theft, system sabotage | High |
    | **Recruited Insider** | Employee recruited by external attackers via financial incentives etc. | Very High |
    | **Negligent Insider** | Mistakes due to low security awareness | Medium |
    | **Compromised Insider** | Legitimate employee whose credentials were stolen externally | High |

-   **Cross-Functional Management Framework (CISA 2026 Compliant)**:
    - **Participating Departments**: Security, HR, Legal, IT, Operations, Compliance collaboration
    - **Integrated Policy**: Integration of technical monitoring and non-technical indicators (behavioral changes, dissatisfaction, financial difficulties)
    - **Transparency**: Clearly communicate monitoring program existence and purpose to employees (trust preservation)
    - **Periodic Review**: Quarterly program effectiveness evaluation

-   **Detection Methods**:
    - **UEBA (User and Entity Behavior Analytics)**: Deviation detection from baseline behavior
    - **DLP (Data Loss Prevention)**: Detection of anomalous external transmission of sensitive data
    - **Access Pattern Monitoring**: Detection of access to systems/at times outside normal duties
    - **OSINT**: Risk assessment via Open Source Intelligence (CISA recommended)
    - **Departing Employee Enhanced Monitoring**: Intensive monitoring of access logs during resignation notice to final working day

-   **Response Protocol**:
    1.  **Investigation Phase**: Legal evidence collection in coordination with legal department (privacy law compliant)
    2.  **Containment Phase**: Graduated access privilege reduction (immediate account suspension determined based on risk)
    3.  **Legal Response**: Law enforcement notification and legal action as needed
    4.  **Post-Incident Response**: Internal reporting system review, security culture strengthening

-   **Cross-Reference**: §7.6 (Identity-Based Attacks), §29 (Human Factors), §37 (Forensics)

---

## Part XLII: Cloud-Native Incident Response

### §52. Cloud-Native Incident Response

-   **Law**: Cloud-native environments such as containers, serverless, and microservice architectures present unique challenges that traditional incident response approaches cannot adequately address. Establish IR protocols specialized for cloud-native environments.

-   **Cloud-Native IR Unique Challenges**:

    | Challenge | Traditional Environment | Cloud-Native Environment |
    |:---------|:----------------------|:------------------------|
    | **Ephemeral Workloads** | Persistent servers | Containers disappear in seconds to minutes, logs and evidence vanish |
    | **Forensics Difficulty** | Disk imaging possible | Container filesystem is volatile, runtime memory dumps difficult |
    | **Lateral Movement Speed** | Network segment level | High-speed propagation via East-West communication between microservices |
    | **Visibility Gaps** | OS/network layer monitorable | Container runtime/service mesh layer monitoring may be insufficient |

-   **Container Forensics**:
    - **Runtime Security**: Container runtime monitoring via Falco, Sysdig, Aqua, etc.
    - **Image Preservation**: Snapshot preservation of compromised container images (as evidence)
    - **Log Persistence**: Immediate transfer of container logs to external storage (before container termination)
    - **Sidecar Forensics**: Pre-deployment of forensics sidecar containers (Kubernetes environments)

-   **Serverless IR**:
    - Preservation of function execution logs for Lambda/Cloud Functions etc.
    - Detection of anomalous initialization processing during cold starts
    - Function-level IAM permission auditing (identifying over-permissions)
    - Visualization of lateral movement paths in serverless environments

-   **Kubernetes-Specific IR**:
    - **Pod Isolation**: Network isolation of compromised Pods via NetworkPolicy
    - **Node Isolation**: Node-level isolation via Cordon + Drain
    - **RBAC Audit**: Investigation of ServiceAccount/ClusterRole privilege escalation
    - **Audit Log**: Preservation and analysis of Kubernetes Audit Logs

-   **Cross-Reference**: §14 (Cloud-Native DR), §37 (Digital Forensics), §49 (Self-Healing)

---

## Part XLIII: Polycrisis Response

### §53. Polycrisis Response Framework

-   **Law**: The 2025-2026 crisis landscape sees an increase in **Polycrisis** — situations where multiple crises occur simultaneously or in cascading fashion. Establish a framework for triage and resource allocation against simultaneous multi-crisis scenarios, beyond individual incident response.

-   **Polycrisis Scenario Examples**:
    - Ransomware attack + simultaneous cloud provider outage (DR environment unavailable)
    - Data breach + pandemic-caused staffing shortage + regulatory investigation
    - DDoS attack + supply chain attack + media scandal
    - Natural disaster + cyber attack (disaster-opportunistic attack)

-   **Multi-Crisis Triage Matrix**:

    | Priority | Criteria | Action |
    |:---------|:---------|:-------|
    | **P0: Safety** | Crisis involving human life/physical safety | Top priority, concentrate all resources |
    | **P1: Service** | Mission-critical service outage | Immediate response after Safety secured |
    | **P2: Data** | Risk of data breach/loss | Prioritize containment, recovery can wait |
    | **P3: Reputation** | Impact on brand/trust | Communication response, parallel with technical response |
    | **P4: Compliance** | Regulatory reporting obligations | Comply with statutory deadlines, parallel with other responses |

-   **Resource Allocation Principles**:
    - **Dual Incident Commander Model**: In multi-crisis situations, cognitive load is excessive for a single IC. Appoint ICs for each major incident with a Unified IC above
    - **Priority-Based Resource Allocation**: Concentrate all specialists on P0/P1, minimum staffing for P2 and below focused on containment
    - **Communication Separation**: Separate communication leads for each crisis to prevent information cross-contamination
    - **Decision-Making Under Incomplete Information**: Training for "sufficient information" decision-making without waiting for complete information (§50 Fog of War)

-   **Cross-Reference**: §5 (War Room), §50 (War Game), §45 (Alert Optimization)

---

## Part XLIV: Information Operations & Disinformation Crisis Response

### §54. Information Operations & Disinformation Crisis Response

-   **Law**: With the advancement of AI-generated content, disinformation attacks against organizations (brand-attack disinformation, fake scandals using Deepfakes, etc.) are increasing. Prepare crisis response protocols for information operations in advance.

-   **Disinformation Threat Categories**:

    | Threat | Overview | Response |
    |:-------|:---------|:---------|
    | **Brand-Attack Disinformation** | Intentional spread of false information about products/services | Monitoring, rapid fact presentation, legal action |
    | **Deepfake PR Crisis** | False statements via Deepfake video/audio of executives | Immediate denial via official channels, presentation of Deepfake detection evidence |
    | **Fake Review/Rating Attacks** | Mass posting of false negative reviews | Platform reporting, promotion of legitimate reviews |
    | **Stock Price Manipulation Disinformation** | False information about the company affecting stock price | Coordination with Legal/IR departments, disclosure obligation verification |
    | **Incident-Opportunistic Disinformation** | Exaggerated/false information spread during actual incidents | Counter with rapid, frequent official information updates |

-   **Response Framework**:
    1.  **Monitor**: Real-time monitoring of social media and news sites
    2.  **Verify**: Fact-check and evidence collection of disinformation
    3.  **Counter**: Rapid fact presentation via official channels, SEO for accurate information ranking
    4.  **Legal Action**: Legal measures against defamation and false information
    5.  **Post-Analysis**: Analysis of disinformation source and propagation paths

-   **AI Disinformation Countermeasure Toolkit**:
    - Deepfake detection tools (Microsoft Video Authenticator, Google SynthID, etc.)
    - Content provenance tracking (C2PA: Coalition for Content Provenance and Authenticity)
    - Social media monitoring automation

-   **Cross-Reference**: §8 (Deepfake Countermeasures), §9 (Crisis Communication), §28 (Reputation Recovery)

---

## Part XLV: M&A & Organizational Restructuring Crisis Management

### §55. M&A & Organizational Restructuring Crisis Management

-   **Law**: During M&A (mergers & acquisitions) and large-scale organizational restructuring, security vulnerability windows emerge during IT environment integration. Plan temporary hardening measures to address inherent risks during the integration period.

-   **M&A Crisis Management Checklist**:

    | Phase | Risk | Countermeasure |
    |:------|:-----|:--------------|
    | **Due Diligence** | Unknown vulnerabilities/past incidents of the acquired company | Security audit, incident history review |
    | **Day 1 (Integration Day)** | Lateral movement risk during network connection | Maintain network isolation, phased integration |
    | **Integration Period** | Temporary weakening of access control during Active Directory/IAM integration | Integration-specific temporary IAM policies, enhanced monitoring |
    | **Stabilization Period** | Residual legacy systems, Shadow IT | Integration completion audit, Shadow IT discovery and integration |

-   **BCP Integration Process**:
    - Evaluate and integrate acquired company's BCP into corporate BCP
    - Redefine RTO/RPO (reflecting new service dependencies post-integration)
    - Consider temporary additional DR environment during integration
    - Unify incident response chain of command (from Day 1)

-   **Cross-Reference**: §11 (BCP), §12 (Vendor BCP), §19 (Governance)

---

## Part XLVI: Edge/IoT Incident Response

### §56. Edge/IoT Incident Response

-   **Law**: Edge computing and IoT device fleets present different challenges from traditional server environments during large-scale incidents. Establish response protocols for mass device failures/compromises.

-   **Edge/IoT-Specific IR Challenges**:
    - **Scale**: Potential for thousands to millions of devices affected simultaneously
    - **Connectivity**: Remote response in intermittent, low-bandwidth connection environments
    - **Resource Constraints**: Difficulty deploying security agents due to CPU/memory/storage constraints
    - **Physical Distribution**: Difficulty of physical access to devices distributed worldwide

-   **Large-Scale IoT Incident Response**:
    1.  **Impact Scope Identification**: Identify affected devices via device fleet management system
    2.  **Remote Isolation**: Network-level isolation of affected devices (IoT gateway/VLAN level)
    3.  **Firmware Update**: Patch distribution via OTA (Over-The-Air) updates
    4.  **Phased Recovery**: Canary group → region-by-region → full deployment rolling recovery
    5.  **Physical Recall**: Physical device recall process for devices that cannot be recovered remotely

-   **Prevention Measures**:
    - Device certificate-based authentication (hardcoded secret keys prohibited)
    - Secure boot mandatory
    - Device lifecycle management (planned EOL/EOS device updates)
    - Network segmentation (separation of IoT and corporate networks)

-   **Cross-Reference**: §36 (OT/ICS), §52 (Cloud-Native IR)

---

## Part XLVII: Non-Technical Crisis Management

### §57. Non-Technical Crisis Management (Legal/HR/Environmental)

-   **Law**: Crises are not limited to cyber incidents. Establish a framework to respond to non-technical crises such as legal disputes, HR crises (harassment, class-action lawsuits), and environmental regulation violations, and integrate with BCP.

-   **Non-Technical Crisis Categories**:

    | Category | Examples | Initial Response |
    |:---------|:---------|:----------------|
    | **Legal Disputes** | Class-action lawsuits, IP infringement litigation, regulatory investigations | Immediate legal response, litigation hold activation |
    | **HR Crisis** | Harassment allegations, mass resignation, whistleblowing | Joint HR + Legal response team |
    | **Environmental Crisis** | Environmental regulation violations, sustainability media scandal | Compliance response, PR response |
    | **Financial Crisis** | Accounting fraud discovery, material financial misstatement | Immediate IR/Legal response, disclosure obligation verification |
    | **Product Safety** | Product safety issues, recall | Joint product team/Legal/PR response |

-   **Integrated Crisis Management Framework**:
    - Manage technical and non-technical crises under **the same chain of command** (enabling integrated response to overlapping crises)
    - Define **common escalation paths** for all crisis types
    - **BCP Integration** for non-technical crises: Business continuity plan for prolonged legal disputes
    - **Unified crisis communication**: Apply §9's crisis communication management to non-technical crises as well

-   **Cross-Reference**: §9 (Crisis Communication), §19 (Governance), §28 (Reputation Recovery), §37 (Legal Readiness)

---

## Appendix A: Quick Reference Index

| Keyword | Related Sections |
|:--------|:----------------|
| AIOps | §22 |
| Agentic AI | §22 |
| AiTM (Adversary-in-the-Middle) | §7.6 |
| Alert Fatigue | §22, §45 |
| Global Privacy Laws (Act on Protection of Personal Information) | §7.2, §34 |
| APRA CPS 230 | §34 |
| Assume Breach | §1 |
| BCP (Business Continuity Plan) | §11 |
| BIA (Business Impact Analysis) | §3 |
| Blameless Post-Mortem | §18 |
| Bus Factor | §11, §43 |
| CBOM (Cryptographic Bill of Materials) | §35 |
| CCPA/CPRA | §7.2, §34 |
| Chain of Custody | §37 |
| ChatOps | §26 |
| CISO Responsibility | §19, §48 |
| Cloud-Native IR | §52 |
| Cognitive Load | §45 |
| CRA (Cyber Resilience Act) | §33, §34 |
| Credential Stuffing | §7.6 |
| CSF 2.0 Integrated IR Model | §6 |
| CTF (Capture The Flag) | §46 |
| CVD (Coordinated Vulnerability Disclosure) | §40 |
| DDoS | §7.3, §31 |
| Deepfake | §8, §54 |
| Digital Omnibus Package | §34, §42 |
| Digital Twin | §44 |
| Disinformation | §54 |
| DORA | §21, §34 |
| DORA Delegated Regulation | §21 |
| DR (Disaster Recovery) | §13, §14 |
| Edge/IoT Incident | §56 |
| eDiscovery | §37 |
| EU-CyCLONe | §32 |
| FIDO2/WebAuthn | §7.6 |
| FinOps | §31 |
| Forensics (Digital Forensics) | §37 |
| GameDay | §16 |
| GDPR | §7.2, §34 |
| Global Kill Switch | §8 |
| Graceful Degradation | §1 |
| HNDL Attack | §35 |
| ICS/SCADA | §36 |
| Identity-Based Attacks | §7.6 |
| Immutable Backup | §15 |
| Incident Responder Certification | §43 |
| Insider Threat | §51 |
| IR Retainer | §27, §47 |
| ISO 22301 | §2, §11 |
| ITDR (Identity Threat Detection and Response) | §7.6 |
| Kill Switch | §8 |
| Kubernetes IR | §52 |
| LGPD (Brazil) | §34 |
| M&A Crisis Management | §55 |
| Management Liability | §19, §48 |
| MFA Fatigue Attack | §7.6 |
| MTTD/MTTA/MTTR/MTBF | §18 |
| Multi-Cloud DR | §39 |
| NHI (Non-Human Identity) | §7.7, §27 |
| NIS2 | §32, §34 |
| NIST CSF 2.0 | §2, §6 |
| NIST SP 800-61 Rev.3 | §6 |
| Non-Technical Crisis | §57 |
| On-Call | §5, §29 |
| OT (Operational Technology) | §36 |
| Pandemic BCP | §25 |
| Passwordless Authentication | §7.6 |
| PIPA (South Korea) | §34 |
| Polycrisis | §53 |
| PQC (Post-Quantum Cryptography) | §35 |
| Purple Team | §38 |
| RaaS (Ransomware-as-a-Service) | §7.1 |
| Ransomware | §7.1, §47 |
| Ransomware Negotiation | §47 |
| Regulatory Reporting Timeline | §34, §41, §42 |
| Reputation Recovery | §28 |
| Risk Matrix | §4 |
| Runbooks | §17 |
| SEC Disclosure Rules | §34, §48 |
| Self-Healing | §22, §49 |
| Session Hijacking | §7.6 |
| Severity Levels | §5 |
| Shadow AI | §8 |
| SIM Swapping | §7.6 |
| SOAR | §22 |
| Status Page | §9.1 |
| Supply Chain Attack | §7.4 |
| Tabletop Exercise | §16 |
| TLPT | §21, §38 |
| 3-2-1-1 Backup | §15 |
| UEBA | §51 |
| Voice Cloning | §8 |
| War Game | §50 |
| War Room | §5 |
| Workload Identity | §7.7 |
| Zero-Day | §7.5, §40 |
| Board Reporting | §48 |
| Crisis Simulation | §50 |
| Cyber Insurance | §27 |
| Cyber Range | §46 |
| Disinformation Crisis | §54 |
| SBOM | §33 |

---

## Appendix B: Cross-References

| Referenced Rule | Related Topics |
|:---------------|:--------------|
| `000_core_mindset.md` | Priority Hierarchy |
| `361_aws_cloud.md` | Multi-Region, Cost Management |
| `400_ai_engineering.md` | AI Guardrails, AI Implementation |
| `502_site_reliability.md` | SLI/SLO, RPO/RTO, Chaos Engineering, Observability, FinOps |
| `600_security_privacy.md` | Security General, Vulnerability Management, Vendor Security, OT Security, Authentication & Access Control |
| `601_data_governance.md` | GDPR/Global Privacy Laws/DORA Notification Obligations, Data Sovereignty, Legal Response, APRA CPS 230 |
| `602_oss_compliance.md` | SBOM, SCA, Supply Chain Security |
| `700_qa_testing.md` | Resilience Testing, Penetration Testing |
| `800_internationalization.md` | Data Sovereignty, Multi-Region Deployment |
| `801_governance.md` | Rule Authority, Governance |
