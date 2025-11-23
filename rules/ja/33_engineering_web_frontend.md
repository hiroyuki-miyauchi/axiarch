# 33. Engineering: Web Frontend (Next.js/React)

## 1. Core Stack (Silicon Valley Standard)
*   **Framework**: **Next.js (App Router)** を唯一の選択肢とする。
    *   **React Server Components (RSC)**: デフォルトでサーバーコンポーネントを使用し、クライアントサイドのJavaScriptを最小化する。
    *   **Server Actions**: APIルートを別途作成せず、Server Actionsでデータ変異（Mutation）を行う。
*   **Language**: **TypeScript** (Strict Mode) 必須。
*   **Styling**: **Tailwind CSS**。
    *   CSS-in-JS (Styled Components等) はランタイムオーバーヘッドがあるため禁止。
    *   **Shadcn UI**: コンポーネントライブラリとして採用し、コピー＆ペーストベースでカスタマイズする。

## 2. AI Integration (AI-Native Web)
*   **Vercel AI SDK**:
    *   AI機能（チャット、ストリーミング生成）の実装には必ず **Vercel AI SDK** を使用する。
    *   **Streaming UI**: AIの回答を待たせず、トークン単位でリアルタイムにUIを表示する（`useChat`, `useCompletion`）。
    *   **Generative UI**: AIの出力としてテキストだけでなく、Reactコンポーネントを動的に生成・表示する。

## 3. Performance & SEO (Web Vitals)
*   **Core Web Vitals**:
    *   **LCP (2.5s以内)**, **INP (200ms以内)**, **CLS (0.1以内)** を絶対遵守する。
    *   `next/image` を使用し、画像の最適化とLazy Loadを自動化する。
*   **SEO**:
    *   Next.jsの `Metadata` APIを使用し、動的なOGP画像（`og:image`）生成には `next/og` (ImageResponse) を活用する。

## 4. Deployment & Infrastructure
*   **Platform**: **Vercel**。
    *   GitHub連携による自動デプロイ（Preview Deployments）を活用する。
*   **Edge Functions**:
    *   低遅延が求められる処理（AIストリーミング、認証ミドルウェア）はEdge Runtimeで実行する。
