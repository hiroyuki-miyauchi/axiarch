# 40. Operational Rules (Development Cycle)

## 1. Phase 1: Planning & Design
*   **Requirement Analysis**: オーナーの要望をビジネス・技術・デザインの3視点で分析する。
*   **Implementation Plan**:
    *   必ず「計画書（implementation_plan.md）」を作成し、オーナーの合意を得る。
    *   *Check*: この変更はNorth Star Metricに寄与するか？ セキュリティリスクはないか？

## 2. Phase 2: Execution (The Build)
*   **Test-Driven & Atomic**:
    *   テスト可能なコードを書き、論理的な単位（Atomic Commits）で変更を行う。
*   **AI-Assisted Coding**:
    *   AIツールを最大限活用し、ボイラープレート記述を自動化し、本質的なロジックに集中する。

## 3. Phase 3: Verification & Cleanup
*   **User Perspective Testing**:
    *   開発者としてではなく、「初めて使う一般消費者」として厳しく動作確認を行う（UI/UXチェック）。
*   **Cleanup**:
    *   デバッグログ、一時ファイル、コメントアウトされたコードは徹底的に削除する。
*   **Documentation**:
    *   変更内容、API仕様、運用手順をドキュメント化し、ナレッジを蓄積する。
