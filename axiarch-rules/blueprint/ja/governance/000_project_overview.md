# [Project Name] Axiarch Reference Model

> [!NOTE]
> **Blueprint Structure**:
> このドキュメントは、本リポジトリが想定する **「リファレンス・プロダクト仕様」** を定義します。
> AIエージェントは、この架空かつ厳格な製品仕様を用いて、憲法のルールをシミュレーション、検証、進化させます。

---

## 📑 目次 (Table of Contents)

1. [Project Vision & Strategy](#1-project-vision--strategy)
2. [Technology Stack Selection](#2-technology-stack-selection-the-standard)
3. [Design Identity](#3-design-identity-the-universal-ui)
4. [Specific Fitness Functions](#4-specific-fitness-functions-quality-gates)
5. [Standard Feature Modules](#5-standard-feature-modules-reference-specs)
6. [Project Specific Operations](#6-project-specific-operations)
7. [Appendix A: 逆引き索引 & クロスリファレンス](#appendix-a-逆引き索引--クロスリファレンス)

---

## 1. Project Vision & Strategy
*   **Mission (What & Why)**:
    *   Axiarch憲法の **「実装のゴールデンスタンダード（模範解答）」** となることを目指します。
    *   ここで「普遍的なフルスタックSaaS」の構造を定義することで、AIが「ルールが具体的にどうコードに落ちるか」を理解可能にします。
*   **Target Audience**:
    *   **Primary**: AI Agents (自己学習用).
    *   **Secondary**: 憲法を参照する開発者.
    *   **Reference Persona**: *大規模SaaSを構築するプロフェッショナル開発者*
*   **North Star Metric**:
    *   **Constitution Coverage**: アクティブな仕様書によってカバーされているルールの割合（％）。
    *   **Simulation Accuracy**: このBlueprintに基づくAIコード生成の正確性。

## 2. Technology Stack Selection
> ⚠️ このセクションはプロジェクト固有の設定です。
> あなたのスタックに合わせて書き換えてください。
> Axiarch標準スタックの例を参考として記載しています。

**（参考）Axiarch Reference Stack:**

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

---

## Appendix A: 逆引き索引 & クロスリファレンス

### 逆引き索引（キーワード → セクション）

| キーワード | 対応セクション |
|---|---|
| ビジョン・ミッション・ペルソナ | §1 Project Vision & Strategy |
| 技術スタック・Flutter・Supabase・Next.js | §2 Technology Stack Selection |
| ADR・Monorepo・Headless | §2 Technology Stack Selection |
| デザイン・テーマ・フォント | §3 Design Identity |
| 楽観的UI・オフライン | §3 Design Identity |
| パフォーマンス・LCP・100ms | §4 Fitness Functions |
| 型安全・テストカバレッジ | §4 Fitness Functions |
| 認証・MFA・RBAC | §5 Auth Module |
| Stripe・課金・サブスクリプション | §5 Billing Module |
| RAG・AI・トークンコスト | §5 AI Module |
| CMS・トリプルライト | §5 Content Module |
| デプロイ・Vercel・Codemagic | §6 Operations |
| RLS・セキュリティ・東京リージョン | §6 Operations |

### クロスリファレンス（セクション → Universal ルール）

| セクション | 関連 Universal ルール |
|---|---|
| §1 Vision & Strategy | `000_core_mindset`, `100_product_strategy` |
| §2 Tech Stack | `300_engineering_standards`, `320_supabase_architecture`, `340_web_frontend`, `342_mobile_flutter`, `360_firebase_gcp` |
| §3 Design Identity | `200_design_ux` |
| §4 Quality Gates | `300_engineering_standards`, `700_qa_testing` |
| §5 Auth Module | `600_security_privacy`, `320_supabase_architecture` |
| §5 Billing Module | `101_revenue_monetization` |
| §5 AI Module | `400_ai_engineering` |
| §5 Content Module | `341_headless_cms` |
| §6 Operations | `502_site_reliability`, `360_firebase_gcp` |
