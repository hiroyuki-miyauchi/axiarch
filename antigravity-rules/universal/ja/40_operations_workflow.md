# 40. Operational Rules (Development Cycle)

### 1.1. Phase 1: Planning & Design (The "Blueprint")
*   **Goal**: *何を*作るか、*なぜ*作るかを曖昧さゼロで定義する。
*   **Steps**:
    1.  **Prompt Engineering**: オーナーがゴールを定義するプロンプトを発行する。
    2.  **Trend Scouting (Crucial)**: AI/チームは、機能に関連する**最新のUI/UXトレンド**（Mobbin/Awwwards）と**技術アップデート**（Google I/O, WWDC）をリサーチする。
    3.  **Spec Definition**: `implementation_plan.md`を作成/更新する。
    4.  **Approval**: オーナーが計画をレビューし承認する。**承認があるまでコードは書かない。**   *Check*: この変更はNorth Star Metricに寄与するか？ セキュリティリスクはないか？

### 1.4. Phase 4: Cleanup & Optimization (The "Polish")
*   **Goal**: 長期的な保守性とパフォーマンスを確保する。
*   **Steps**:
    1.  **Code Cleanup**: 未使用のインポート、コメント、デッドコードを削除する。
    2.  **Asset Optimization**: 新しい画像を圧縮（WebP/AVIF）し、未使用アセットを削除する。
    3.  **Refactoring**: 実装フェーズで導入された「一時的なハック」を解消する。
    4.  **Documentation**: 変更を反映するために `README.md` とAPIドキュメントを更新する。

### 1.5. Phase 5: Sunset & Deprecation (The "End")
*   **Goal**: コードベースを身軽に保つために、死んだ機能を削除する。
*   **Protocol**:
    1.  **Identify**: アナリティクスを使用し、使用率が1%未満の機能を特定する。
    2.  **Deprecate**: コードに `@deprecated` を付与し、APIには "Sunset Headers" を追加する。
    3.  **Announce**: ユーザー（機能の場合）または開発者（内部APIの場合）に明確なタイムラインを通知する。
    4.  **Delete**: 猶予期間後、コードを完全に削除する。**コメントアウトして残してはならない。** Git履歴がバックアップである。

## 2. Task Management (Task.md)ion (The Build)
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
