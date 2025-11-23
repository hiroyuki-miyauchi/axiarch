# 80. QA & Testing Strategy (Quality Assurance View)

## 1. The Testing Pyramid (シリコンバレー標準)
テストは「量」ではなく「バランス」が重要である。以下のピラミッド構造を維持する。

*   **Unit Tests (70%)**:
    *   ロジック、ユーティリティ、Firestoreセキュリティルールを対象とする。
    *   高速に実行でき、開発中のフィードバックループを回すための基盤。
*   **Widget/Component Tests (20%)**:
    *   FlutterのWidget単体、あるいは画面単位でのUIテスト。
    *   **Golden Tests (Visual Regression)**: デザイン崩れを防ぐため、ピクセルパーフェクトなスナップショットテスト（Golden File Testing）を導入する。
*   **Integration/E2E Tests (10%)**:
    *   ユーザーの主要なフロー（ログイン -> 決済 -> 完了）をシミュレートする。
    *   Firebase Test Labを使用し、実機での動作を保証する。壊れやすく維持コストが高いため、クリティカルパスに絞る。

## 2. CI/CD Pipeline (GitHub Actions)
*   **Automated Checks**:
    *   PR作成時に、Lint、Unit Test、Buildが自動で走り、パスしない限りマージできない設定にする（Branch Protection）。
*   **Continuous Delivery**:
    *   `main` ブランチへのマージは、即座にStaging環境（Firebase App Distribution）へのデプロイをトリガーする。

## 3. Manual Testing Strategy
*   **Exploratory Testing**:
    *   自動テストでは見つけられない「違和感」や「使いにくさ」を発見するため、人間（オーナーまたはAI）が探索的にアプリを触る時間を設ける。
*   **Dogfooding**:
    *   開発者自身が日常的にアプリを使用し、最初のユーザーとなる。
