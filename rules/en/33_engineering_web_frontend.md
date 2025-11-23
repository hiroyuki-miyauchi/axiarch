# 33. Engineering: Web Frontend (Next.js/React)

## 1. Core Stack (Silicon Valley Standard)
*   **Framework**: **Next.js (App Router)** is the sole choice.
    *   **React Server Components (RSC)**: Use Server Components by default to minimize client-side JavaScript.
    *   **Server Actions**: Perform data mutations via Server Actions instead of creating separate API routes.
*   **Language**: **TypeScript** (Strict Mode) is mandatory.
*   **Styling**: **Tailwind CSS**.
    *   CSS-in-JS (Styled Components, etc.) is prohibited due to runtime overhead.
    *   **Shadcn UI**: Adopt as the component library, customizing via copy-and-paste base.

## 2. AI Integration (AI-Native Web)
*   **Vercel AI SDK**:
    *   Must use **Vercel AI SDK** for implementing AI features (Chat, Streaming Generation).
    *   **Streaming UI**: Display UI in real-time token-by-token without making the user wait for full AI response (`useChat`, `useCompletion`).
    *   **Generative UI**: Dynamically generate and render React components as AI output, not just text.

## 3. Performance & SEO (Web Vitals)
*   **Core Web Vitals**:
    *   Strictly adhere to **LCP (within 2.5s)**, **INP (within 200ms)**, and **CLS (within 0.1)**.
    *   Use `next/image` to automate image optimization and Lazy Loading.
*   **SEO**:
    *   Use Next.js `Metadata` API. Leverage `next/og` (ImageResponse) for dynamic OGP image generation.

## 4. Deployment & Infrastructure
*   **Platform**: **Vercel**.
    *   Utilize automatic deployments via GitHub integration (Preview Deployments).
*   **Edge Functions**:
    *   Execute latency-sensitive processes (AI streaming, Auth Middleware) on the Edge Runtime.
