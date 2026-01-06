# [Project Name] Specific Rules / 固有開発ルール

> [!NOTE]
> **Inheritance / 継承**:
> このドキュメントは `README.md` および `universal/` 以下の全ルールを継承する。
>
> **Priority / 優先順位**:
> 汎用ルールと矛盾する場合は、より具体的な本ルールが優先される場合があるが、基本哲学（Core Philosophy）は絶対である。

---

## 1. プロジェクトビジョンと戦略 (Project Vision & Strategy)
*   **Mission (What & Why)**:
    *   *例: 世界で最も美しい、AI駆動のToDoアプリ。既存の認知負荷を解消するため。*
*   **Target Audience**:
    *   *例: 30代、シリコンバレーのエンジニア。*
*   **North Star Metric**:
    *   *例: ユーザーの1日あたりの自由時間創出量。*
*   **Unit Economics Goals**:
    *   LTV: $XXX, CAC: $YYY

## 2. 技術スタック選定 (Technology Stack Selection)
> 汎用ルール（Flutter/Firebase/Next.js）に基づき、本プロジェクトでの具体的な構成を定義する。

*   **Mobile**: Flutter (Riverpod, GoRouter)
*   **Backend**: Firebase (Auth, Firestore, Functions)
*   **Web**: Next.js (App Router, Tailwind CSS)
*   **AI Models**: GPT-4o, Gemini 1.5 Pro
*   **Architecture Decision Records (ADR)**:
    *   *Link to ADR folder or list key decisions here.*

## 3. デザインアイデンティティ (Design Identity)
*   **Theme**: [Ex: Minimal, Dark Mode default]
*   **Colors**: Primary `[Code]`, Secondary `[Code]`
*   **Key Gestures**: [Ex: Swipe-to-archive]

## 4. 品質基準 (Specific Fitness Functions)
*   **Performance**:
    *   App Launch: < 1.5s
    *   API Latency: < 200ms (p95)
*   **Code Quality**:
    *   Test Coverage: > 80%

## 5. AI戦略 (AI Strategy & Prompts)
*   **System Prompts**:
    *   *AI機能のペルソナや制約を定義する。*
*   **Model Selection Rationale**:
    *   *なぜそのタスクにそのモデルを選んだのか？*

## 6. 固有ビジネスルール (Specific Business Rules)
*   **Feature A**: ...
*   **Feature B**: ...

## 7. プロジェクト固有の運用 (Project Specific Operations)
*   **Deploy Schedule**: ...
*   **Special Security Requirements**: ...
