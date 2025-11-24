# 50. Gitとバージョン管理 (Git & Version Control)

## 1. コミットメッセージ規約 (Commit Message Convention)
*   **Conventional Commits**:
    *   **形式**: `type(scope): subject` を厳守します（例: `feat(auth): add google login`）。
    *   **Type一覧**:
        *   `feat`: 新機能
        *   `fix`: バグ修正
        *   `docs`: ドキュメントのみの変更
        *   `style`: コードの意味に影響しない変更（空白、フォーマット）
        *   `refactor`: バグ修正も機能追加も行わないコード変更
        *   `perf`: パフォーマンスを向上させるコード変更
        *   `test`: テストの追加・修正
        *   `chore`: ビルドプロセスやツールの変更
*   **日本語の説明**:
    *   件名（Subject）は英語でも可ですが、本文（Body）には必ず日本語で「何をしたか」「なぜしたか」を記述します。

## 2. ブランチ戦略 (Branching Strategy)
*   **GitHub Flow**:
    *   シンプルさを重視し、`main` ブランチと機能ブランチ（`feat/xxx`, `fix/xxx`）のみを使用します。`develop` や `release` ブランチは原則として使用しません（CI/CDの自動化でカバーします）。
*   **保護設定 (Branch Protection)**:
    *   `main` ブランチへの直接プッシュ（Direct Push）はシステム的に禁止します。
    *   マージには必ず「1名以上の承認（Review）」と「CIチェック（Test/Lint）の通過」を必須とします。

## 3. プルリクエスト (Pull Requests)
*   **100行ルール**:
    *   PRは小さく保ちます。変更行数が少ないほど、バグ発見率は上がり、レビュー速度も上がります。
*   **説明責任**:
    *   PRの説明欄には、「何をしたか（What）」「なぜしたか（Why）」「どう確認するか（How）」を必ず記述します。スクリーンショットや動画があれば添付します。

## 4. セキュリティと機密情報 (Security & Secrets)
*   **クレデンシャル混入防止**:
    *   APIキー、パスワード、秘密鍵などの機密情報は、**絶対に**Gitリポジトリにコミットしてはなりません。`.env` ファイルを使用し、`.gitignore` に必ず追加します。
*   **署名付きコミット (Verified Commits)**:
    *   可能な限りGPG署名を行い、コミットの真正性を担保します（Verifiedバッジ）。なりすましを防ぎます。
