# [プロジェクト名] 固有開発ルール (Project Specific Rules)

> [!NOTE]
> このドキュメントは `ANTIGRAVITY_RULES.md` および `rules/` 以下の全ルールを継承する。
> 汎用ルールと矛盾する場合は、より具体的な本ルールが優先される場合があるが、基本哲学（Core Philosophy）は絶対である。

---

## 1. Project Vision & Strategy
*   **Mission (What & Why)**:
    *   *例: 世界で最も美しい、AI駆動のToDoアプリ。既存の認知負荷を解消するため。*
*   **Target Audience**:
    *   *例: 30代、シリコンバレーのエンジニア。*
*   **North Star Metric**:
    *   *例: ユーザーの自由時間創出量*
*   **Unit Economics Goals**:
    *   LTV: $XXX, CAC: $YYY

## 2. Technology Stack Selection
> 汎用ルール（Flutter/Firebase）に基づき、本プロジェクトでの具体的な構成を定義する。

*   **Mobile**: Flutter (Riverpod, GoRouter)
*   **Backend**: Firebase (Auth, Firestore, Functions)
*   **AI Models**: GPT-4o, Gemini 1.5 Pro

## 3. Design Identity
*   **Theme**: [例: Minimal, Dark Mode default]
*   **Colors**: Primary `[Code]`, Secondary `[Code]`

## 4. Specific Business Rules
*   **Feature A**: ...
*   **Feature B**: ...

## 5. Project Specific Operations
*   **Deploy Schedule**: ...
*   **Special Security Requirements**: ...
