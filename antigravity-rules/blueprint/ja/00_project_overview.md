# [Project Name] Antigravity Reference Model

> [!NOTE]
> **Blueprint Structure**:
> このドキュメントは、本リポジトリが想定する **「リファレンス・プロダクト仕様」** を定義します。
> AIエージェントは、この架空かつ厳格な製品仕様を用いて、憲法のルールをシミュレーション、検証、進化させます。

---

## 1. Project Vision & Strategy
*   **Mission (What & Why)**:
    *   Antigravity憲法の **「実装のゴールデンスタンダード（模範解答）」** となることを目指します。
    *   ここで「普遍的なフルスタックSaaS」の構造を定義することで、AIが「ルールが具体的にどうコードに落ちるか」を理解可能にします。
*   **Target Audience**:
    *   **Primary**: AI Agents (自己学習用).
    *   **Secondary**: 憲法を参照する開発者.
    *   **Reference Persona**: *大規模SaaSを構築するプロフェッショナル開発者*
*   **North Star Metric**:
    *   **Constitution Coverage**: アクティブな仕様書によってカバーされているルールの割合（％）。
    *   **Simulation Accuracy**: このBlueprintに基づくAIコード生成の正確性。

## 2. Technology Stack Selection (The Standard)
> 「Antigravity標準スタック」を定義します。

*   **Mobile**: Flutter (Riverpod, GoRouter) - *厳格なレイヤードアーキテクチャ*
*   **Backend**: Supabase (PostgreSQL, Edge Functions, Auth, Storage)
*   **Web**: Next.js (App Router, Shadcn UI, Tailwind CSS, Vercel)
*   **AI Models**: OpenAI (GPT-4o), Anthropic (Claude 3.5), Google (Gemini 1.5)
*   **Architecture Decision Records (ADR)**:
    *   *Monorepo Strategy (Turborepo)*
    *   *Headless First Declaration*

## 3. Design Identity (The Universal UI)
*   **Theme**: `Zinc` (中立的かつプロフェッショナル), with `Inter` font.
*   **Philosophy**: "Functionality over Decoration". ミニマリストで情報密度の高いダッシュボードスタイル。
*   **Key Behavior**: Instant Optimistic UI（楽観的UI）, Full Offline Support (Mobile).

## 4. Specific Fitness Functions (Quality Gates)
*   **Performance (The 100ms Rule)**:
    *   Interaction Latency: < 100ms
    *   LCP: < 1.2s
*   **Code Quality**:
    *   **Strict Type**: `noImplicitAny` は絶対です。
    *   **Test Coverage**: コアロジック > 90%.

## 5. Standard Feature Modules (Reference Specs)
*   **Auth Module**: 多要素認証 (MFA), SSO, ロールベースアクセス制御 (RBAC).
*   **Billing Module**: Stripe連携, サブスクリプションライフサイクル, 請求書ロジック.
*   **AI Module**: RAGパイプライン, ストリーミング応答, トークンコスト管理.
*   **Content Module**: ヘッドレスCMS連携, トリプルライト標準 (Triple Write Standard).

## 6. Project Specific Operations
*   **Deploy**: Vercel (Web), Codemagic (Mobile).
*   **Security**: Tokyo Region Exclusive (東京リージョン固定), RLS Strict Mode.
