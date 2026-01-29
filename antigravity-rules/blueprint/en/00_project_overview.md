# [Project Name] Antigravity Reference Model

> [!NOTE]
> **Blueprint Structure**:
> This document defines the **"Reference Product Specification"** assumed by this repository.
> The AI Agent uses this fictional but rigorous product spec to simulate, validate, and evolve the Constitution rules.

---

## 1. Project Vision & Strategy
*   **Mission (What & Why)**:
    *   To serve as the **"Golden Standard" implementation** of the Antigravity Constitution.
    *   By defining a "Universal Full-Stack SaaS" structure here, we enable the AI to understand "How these rules apply to real code".
*   **Target Audience**:
    *   **Primary**: AI Agents (Self-Learning).
    *   **Secondary**: Developers referencing the Constitution.
    *   **Reference Persona**: *Pro Developers building High-Scale SaaS.*
*   **North Star Metric**:
    *   **Constitution Coverage**: % of rules covered by active specifications.
    *   **Simulation Accuracy**: Accuracy of AI code generation based on these blueprints.

## 2. Technology Stack Selection (The Standard)
> Defines the "Antigravity Standard Stack".

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
*   **Security**: Tokyo Region Exclusive, RLS Strict Mode.
