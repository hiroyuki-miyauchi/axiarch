## 4. CI/CD Pipeline
*   **Blocker**:
    *   Lintエラー、テスト失敗があるコードはマージできない（Branch Protection）。
*   **Continuous Delivery**:
    *   `main` ブランチへのマージは、即座にStaging環境へのデプロイをトリガーする。
