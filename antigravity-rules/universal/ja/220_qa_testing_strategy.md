# 220. 品質保証とテスト戦略 (QA & Testing Strategy)

## 1. テストピラミッド (Testing Pyramid)
*   **Unit Tests (70%)**:
    *   **対象**: ユーティリティ関数、ドメインロジック、個々のコンポーネント。
    *   **ツール**: Jest, Vitest, JUnit, XCTest。
    *   **基準**: カバレッジ（C0/C1）を指標としつつ、重要なロジックの網羅を優先します。
*   **Integration Tests (20%)**:
    *   **対象**: APIとDBの連携、コンポーネント間の連携。
    *   **ツール**: Supertest, React Testing Library。
*   **E2E Tests (10%)**:
    *   **対象**: ユーザーの主要な操作フロー（サインアップ、決済、コア機能）。
    *   **ツール**: Playwright, Cypress, Maestro (Mobile)。
    *   **運用**: 壊れやすいため、クリティカルパスに絞って実装します。

## 2. CI/CD ゲート (CI/CD Gates)
*   **自動ブロック**:
    *   Lintエラー、型エラー、テスト失敗があるPRはマージできないようにGitHub Actions等でブロックします。
*   **プレビュー環境**:
    *   PRごとにプレビュー環境（Vercel Preview, Firebase Hosting Preview）を自動デプロイし、動作確認を容易にします。

## 3. マニュアルQA (Manual QA)
*   **Dogfooding**:
    *   開発チーム自身が日常的にアプリを使用（ドッグフーディング）し、UXの違和感やバグを早期発見します。
*   **リリースクリテリア**:
    *   リリース前には「リリースチェックリスト」（主要機能の動作、課金テスト、ログ出力確認）を全項目パスすることを義務付けます。

## 4. バグ管理 (Bug Management)
*   **Zero Bug Policy**:
    *   発見されたバグは、優先度（P0: 即時修正 〜 P3: 次回以降）を付けて管理し、P0/P1バグがある状態でのリリースは禁止します。
    *   **再現手順**: バグレポートには必ず「再現手順」「期待値」「実際の結果」を含めます。

## 5. 互換性と実機テスト (Compatibility & Real Device Testing)
*   **ブラウザ・OSサポート**:
    *   **Web**: Chrome, Safari (iOS/Mac), Firefox, Edge の最新2バージョン。
    *   **Mobile**: iOSとAndroidの最新メジャー2バージョン（例: iOS 17/18, Android 14/15）。
*   **実機テスト義務 (Mandatory Real Device Testing)**:
    *   **TestFlight / Internal App Sharing**: シミュレーターだけでなく、必ず実機（TestFlight, Google Play Internal App Sharing）で配布し、インストールから動作確認を行います。
    *   **クラウドテスト**: BrowserStackやAWS Device Farmを活用し、手元にないデバイスや古いAndroid端末でのフラグメンテーションテストを実施します。
*   **エッジケース (Edge Cases)**:
    *   **ネットワーク**: オフライン状態、3G（低速回線）状態での動作とエラーハンドリングを確認します。
