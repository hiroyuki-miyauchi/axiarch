# [Project Name] Axiarch Reference Model

> [!NOTE]
> **Blueprint Structure**:
> This document defines the **"Reference Product Specification"** assumed by this repository.
> The AI Agent uses this fictional but rigorous product spec to simulate, validate, and evolve the Constitution rules.

---

## 📑 Table of Contents

1. [Project Vision & Strategy](#1-project-vision--strategy)
2. [Technology Stack Selection](#2-technology-stack-selection)
3. [Design Identity](#3-design-identity-the-universal-ui)
4. [Specific Fitness Functions](#4-specific-fitness-functions-quality-gates)
5. [Standard Feature Modules](#5-standard-feature-modules-reference-specs)
6. [Project Specific Operations](#6-project-specific-operations)
7. [Appendix A: Reverse Lookup Index & Cross-References](#appendix-a-reverse-lookup-index--cross-references)

---

## 1. Project Vision & Strategy
*   **Mission (What & Why)**:
    *   To serve as the **"Golden Standard" implementation** of the Axiarch Constitution.
    *   By defining a "Universal Full-Stack SaaS" structure here, we enable the AI to understand "How these rules apply to real code".
*   **Target Audience**:
    *   **Primary**: AI Agents (Self-Learning).
    *   **Secondary**: Developers referencing the Constitution.
    *   **Reference Persona**: *Pro Developers building High-Scale SaaS.*
*   **North Star Metric**:
    *   **Constitution Coverage**: % of rules covered by active specifications.
    *   **Simulation Accuracy**: Accuracy of AI code generation based on these blueprints.

## 2. Technology Stack Selection
> ⚠️ This section is project-specific.
> Please rewrite it according to your actual stack.
> The Axiarch standard stack is provided here as a reference example.

**[Reference] Axiarch Reference Stack:**

*   **Mobile**: Flutter (Riverpod, GoRouter) - *Strict Layered Architecture*
*   **Backend**: Supabase (PostgreSQL, Edge Functions, Auth, Storage)
*   **Web**: Next.js (App Router, Shadcn UI, Tailwind CSS, Vercel)
*   **AI Models**: OpenAI (GPT-4o), Anthropic (Claude 3.5), Google (Gemini 1.5)
*   **Architecture Decision Records (ADR)**:
    *   *Monorepo Strategy (Turborepo)*
    *   *Headless First Declaration*

## 3. Design Identity (The Universal UI)
*   **Theme**: `Zinc` (Neutral & Professional), with `Inter` font.
*   **Philosophy**: "Functionality over Decoration". Minimalist, Information-Dense Dashboard style.
*   **Key Behavior**: Instant Optimistic UI, Full Offline Support (Mobile).

## 4. Specific Fitness Functions (Quality Gates)
*   **Performance (The 100ms Rule)**:
    *   Interaction Latency: < 100ms
    *   LCP: < 1.2s
*   **Code Quality**:
    *   **Strict Type**: `noImplicitAny` is absolute.
    *   **Test Coverage**: Core Logic > 90%.

## 5. Standard Feature Modules (Reference Specs)
*   **Auth Module**: Multi-Factor, SSO, Role-Based Access Control (RBAC).
*   **Billing Module**: Stripe Integration, Subscription Lifecycle, Invoice Logic.
*   **AI Module**: RAG Pipeline, Streaming Response, Token Cost Management.
*   **Content Module**: Headless CMS Integration, Triple Write Standard.

## 6. Project Specific Operations
*   **Deploy**: Vercel (Web), Codemagic (Mobile).
*   **Security**: Local Region Exclusive (e.g., US East, EU Frankfurt), RLS Strict Mode.

---

## Appendix A: Reverse Lookup Index & Cross-References

### Reverse Lookup Index (Keyword → Section)

| Keyword | Section |
|---|---|
| Vision, mission, persona | §1 Project Vision & Strategy |
| Tech stack, Flutter, Supabase, Next.js | §2 Technology Stack Selection |
| ADR, Monorepo, Headless | §2 Technology Stack Selection |
| Design, theme, font | §3 Design Identity |
| Optimistic UI, Offline | §3 Design Identity |
| Performance, LCP, 100ms | §4 Fitness Functions |
| Type safety, test coverage | §4 Fitness Functions |
| Auth, MFA, RBAC | §5 Auth Module |
| Stripe, billing, subscription | §5 Billing Module |
| RAG, AI, token cost | §5 AI Module |
| CMS, Triple Write | §5 Content Module |
| Deploy, Vercel, Codemagic | §6 Operations |
| RLS, security, local region | §6 Operations |

### Cross-References (Section → Universal Rules)

| Section | Related Universal Rules |
|---|---|
| §1 Vision & Strategy | `core/000_core_mindset`, `product/000_product_strategy` |
| §2 Tech Stack | `engineering/000_engineering_standards`, `engineering/200_supabase_architecture`, `engineering/300_web_frontend`, `engineering/400_mobile_flutter`, `engineering/500_firebase_gcp` |
| §3 Design Identity | `design/000_design_ux` |
| §4 Quality Gates | `engineering/000_engineering_standards`, `quality/000_qa_testing` |
| §5 Auth Module | `security/000_security_privacy`, `engineering/200_supabase_architecture` |
| §5 Billing Module | `product/300_revenue_monetization` |
| §5 AI Module | `ai/000_ai_engineering` |
| §5 Content Module | `engineering/310_headless_cms` |
| §6 Operations | `operations/400_site_reliability`, `engineering/500_firebase_gcp` |
