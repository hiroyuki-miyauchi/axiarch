# Compliance Matrix

> [!CAUTION]
> **AI Agent Controls**
>
> *   **Layer 1: Universal Constitution**: The files listed in the `1. Layer 1: Universal Rules` section (under `universal/`) are **Read-only**. AI MUST NOT edit or modify these files under any circumstances without explicit user permission (instruction to "Amend Constitution"). Replace `{lang}` with `ja` or `en` based on the `Project Native Language` setting in `AGENTS.md`.
> *   **Layer 2: Blueprint Rules**: The files listed in the `2. Layer 2: Blueprint Rules` section (under `blueprint/`) are the area to be customized for each project. AI SHOULD proactively propose and update these files according to requirements and lessons.

This matrix proves which rule files cover the user's comprehensive requests (prompts).

## 1. Layer 1: Universal Rules (Immutable Constitution)
**Immutable**

| User Request | Covered In | Specific Rule |
| :--- | :--- | :--- |
| **Consistent documentation in project language** | `universal/core/000_core_mindset.md` | "Project Language Consistency" |
| **User-First Perspective** | `universal/core/000_core_mindset.md` | "Level 2: User Experience" |
| **Founder Mode** | `universal/core/000_core_mindset.md` | "Founder Mode (Deep Dive, Bypass)" |
| **HR Perspective** | `universal/product/000_product_strategy.md` | "HR Perspective", "Hiring Bar" |
| **Monetization Perspective** | `universal/product/300_revenue_monetization.md` | "Unit Economics", "Freemium Model" |
| **Financial Perspective** | `universal/product/300_revenue_monetization.md` | "PL Management", "Invoicing" |
| **Google/Apple Guidelines** | `universal/product/700_appstore_compliance.md` | "Human Interface Guidelines" |
| **Mobile-First Perspective** | `universal/design/000_design_ux.md` | "Mobile First Strategy", "Touch Targets" |
| **UI Animation & Performance** | `universal/design/000_design_ux.md` | "60fps Target", "Haptics" |
| **Code Quality & Clean Code** | `universal/engineering/000_engineering_standards.md` | "Zero Warnings", "kebab-case", "Barrel File Ban" |
| **Security by Design (DevSecOps)** | `universal/engineering/000_engineering_standards.md` | "Zero Trust", "Single Source of Config", "Env Drift Prevention" |
| **Technical Debt Management** | `universal/engineering/000_engineering_standards.md` | "Sprint 20% Debt Paydown", "Tech Radar", "Dependency Governance" |
| **AI-First Engineering** | `universal/engineering/000_engineering_standards.md` | "PDD", "RAG Optimization", "Schema Trust Protocol" |
| **Zero Bug Policy** | `universal/engineering/000_engineering_standards.md` | "24-Hour Rule", "Fix Twice Principle" |
| **Git & Version Control** | `universal/engineering/000_engineering_standards.md` | "Trunk Based Development", "Conventional Commits", "Git Hooks 3-Layer Defense" |
| **Documentation Ops** | `universal/engineering/000_engineering_standards.md` | "Living Documentation", "ADR Mandate", "Runbook" |
| **Architecture Quality** | `universal/engineering/000_engineering_standards.md` | "Trinity DTO", "CQRS Separation", "Thin Controller", "Feature Flag Lifecycle" |
| **Cost & Expense Perspective** | `universal/engineering/500_firebase_gcp.md` | "FinOps", "Cloud Bankruptcy Prevention" |
| **Web Tech Coverage** | `universal/engineering/300_web_frontend.md` | "CSS Architecture", "Performance" |
| **PDF/CSV Export** | `universal/engineering/300_web_frontend.md` | "Export Functionality" |
| **Native App Tech Coverage** | `universal/engineering/410_native_platforms.md` | "SwiftUI/Jetpack Compose" |
| **Vision/Voice/Biometrics** | `universal/engineering/410_native_platforms.md` | "Biometrics", "Edge AI" |
| **Offline-First** | `universal/engineering/410_native_platforms.md` | "Offline Architecture" |
| **AI Implementation Perspective** | `universal/ai/000_ai_engineering.md` | "Streaming First", "Optimistic UI" |
| **Analytics & Insights** | `universal/ai/100_data_analytics.md` | "Privacy-First Analytics" |
| **Admin Operations Perspective** | `universal/operations/000_internal_tools.md` | "Low-code/No-code First Evaluation", "Audit Logs" |
| **Support & FAQ Perspective** | `universal/operations/300_customer_experience.md` | "Support Philosophy" |
| **Browser/OS Compatibility** | `universal/operations/400_site_reliability.md` | "Browser Compatibility" |
| **Chaos Engineering** | `universal/operations/400_site_reliability.md` | "Chaos Engineering" |
| **Security First** | `universal/security/000_security_privacy.md` | "Level 1: Security > UX" |
| **Legal Perspective** | `universal/security/100_data_governance.md` | "GDPR/CCPA/ePrivacy", "Terms of Service" |
| **Terms & Privacy Perspective** | `universal/security/100_data_governance.md` | "Privacy Policy", "Data Minimization" |
| **License/Plugin Rules** | `universal/security/200_oss_compliance.md` | "License Whitelist" |
| **Testing Perspective** | `universal/quality/000_qa_testing.md` | "Shift Left Testing", "Flaky Tests" |
| **Growth & Marketing** | `universal/product/500_growth_marketing.md` | "Growth Loops", "Viral Coefficient" |
| **API Design & Microservices** | `universal/engineering/100_api_integration.md` | "API First", "Contract Testing" |
| **Supabase Architecture** | `universal/engineering/200_supabase_architecture.md` | "RLS by Default", "Edge Functions" |
| **Headless CMS** | `universal/engineering/310_headless_cms.md` | "Content Modeling", "API-First CMS" |
| **Flutter / Cross-Platform** | `universal/engineering/400_mobile_flutter.md` | "Widget Architecture", "Platform Channels" |
| **AWS Cloud** | `universal/engineering/510_aws_cloud.md` | "Well-Architected Framework", "IaC" |
| **Incident Response** | `universal/operations/500_incident_response.md` | "Incident Commander", "Blameless Postmortem" |
| **IP Due Diligence** | `universal/security/300_ip_due_diligence.md` | "IP Portfolio", "Trade Secret Protection" |
| **Cloud FinOps** | `universal/operations/600_cloud_finops.md` | "Cost Optimization", "FinOps Lifecycle" |
| **Internationalization & Localization** | `universal/product/800_internationalization.md` | "ICU MessageFormat", "BiDi/RTL" |
| **Governance & Rule Management** | `universal/core/100_governance.md` | "SSOT Architecture", "Amendment Process" |
| **Language Protocol** | `universal/core/200_language_protocol.md` | "Zero Tolerance", "Project Language-First" |

## 2. Layer 2: Blueprint Rules (Mutable Project State)
**Mutable**

This section defines the "Blueprint" area for project-specific requirements. AI SHOULD proactively reference, propose, and update this section.

| User Request | Covered In | Specific Rule |
| :--- | :--- | :--- |
| **Project Overview & Architecture** | `blueprint/core/000_project_overview.md` | "Tech Stack", "Directory Structure" |
| **Project Lessons Log** | `blueprint/core/010_project_lessons_log.md` | "Context Log", "Specific Constraints" |
| **Feature Specification Template (Blueprint First)** | `blueprint/core/998_feature_spec_template.md` | "Acceptance Criteria", "Given/When/Then" |
| **Other Specific Requirements** | `blueprint/core/999_project_specific_template.md` | (As needed) |

## 3. Layer 3: Prompts (Optional Execution Engine)
**Optional / Mutable**

This section defines the optional prompt templates used to instruct AI agents for specific high-quality tasks.

| User Request | Covered In | Specific Rule |
| :--- | :--- | :--- |
| **Development & Execution Prompts** | `axiarch-prompts/*/develop/` | `feature_development`, `refactoring_audit`, `push_execute`, `ci_fix` |
| **Quality & Integrity Audit Prompts** | `axiarch-prompts/*/audit/` | `fullstack_qa_audit`, `api_architecture_audit`, `data_integrity_audit`, `system_integrity_audit`, `deep_optimization_audit` |
| **Compliance & Governance Prompts** | `axiarch-prompts/*/govern/` | `governance_auditor`, `constitution_compliance_audit`, `compliance_inspector_audit`, `blueprint_governance_audit`, `localization_audit` |
| **Incident Response & Onboarding Prompts** | `axiarch-prompts/*/operate/` | `incident_response`, `onboarding_audit` |

**Compliance Coverage Note**:
This matrix defines the mapping between common engineering request types and the corresponding rule files.
Universal Rules cover general engineering standards; project-specific requirements are supplemented via Blueprint.
