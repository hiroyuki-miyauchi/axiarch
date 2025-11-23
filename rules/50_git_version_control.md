# 50. Git & Version Control Standards (Silicon Valley Style)

## 1. Branching Strategy (Trunk Based Development)
*   **Main Branch is Holy**: `main` ブランチは常にデプロイ可能な状態（Deployable）でなければならない。
*   **Short-Lived Feature Branches**: 機能開発は `feat/user-login` のような短命なブランチで行い、数日以内に `main` にマージする。巨大なブランチ（Long-lived branches）はマージ地獄の元であり、禁止する。

## 2. Commit Convention (Conventional Commits in Japanese)
コミットメッセージは、変更内容が一目でわかるように「日本語」で記述する。シリコンバレー標準の "Conventional Commits" を日本語化して適用する。

*   **Format**: `type(scope): subject`
*   **Types**:
    *   `feat: ...`: 新機能の追加 (Feature)
    *   `fix: ...`: バグ修正 (Bug fix)
    *   `docs: ...`: ドキュメントのみの変更 (Documentation)
    *   `style: ...`: コードの意味に影響しない変更（空白、フォーマット等）
    *   `refactor: ...`: バグ修正も機能追加も行わないコード変更 (Refactoring)
    *   `perf: ...`: パフォーマンスを向上させる変更 (Performance)
    *   `test: ...`: テストの追加・修正 (Tests)
    *   `chore: ...`: ビルドプロセスやドキュメント生成などの雑用 (Chores)

*   **Example**:
    *   ⭕️ `feat(auth): ログイン画面のUI実装`
    *   ⭕️ `fix(api): タイムアウト処理のバグを修正`
    *   ❌ `update code` (具体性がない)
    *   ❌ `fix bug` (英語禁止)

## 3. Pull Requests (PR) & Code Review
*   **The "100 Lines" Rule**: PRは小さく保つ。変更行数が少ないほど、バグ発見率は上がり、レビュー速度も上がる。
*   **Description is Mandatory**: PRの説明欄には、「何をしたか（What）」「なぜしたか（Why）」「どう確認するか（How）」を必ず日本語で記述する。
*   **Review Standard**:
    *   **Nitpicks are Welcome**: 細かい指摘（変数名、可読性）も歓迎する。
    *   **Blockers**: 重大なバグやセキュリティリスクがある場合は、断固としてマージを阻止（Request Changes）する。

## 4. Production Exclusion (Deployment Safety)
*   **Internal Only**: `rules/` フォルダ、`ANTIGRAVITY_RULES.md` などの開発ルールファイルは、**絶対に本番環境（Production）にデプロイしてはならない**。
*   **Configuration**:
    *   Docker使用時: `.dockerignore` に `rules/` を追加する。
    *   Web/Mobileビルド時: ビルド設定でマークダウンファイルを除外する。
    *   これらは「開発チームのための内部文書」であり、ユーザーや競合他社に見せるものではない。

## 5. Security & Risk Management (Silicon Valley Standard)
*   **Branch Protection Rules**:
    *   `main` ブランチへの直接プッシュ（Direct Push）はシステム的に禁止する。
    *   マージには必ず「1名以上の承認（Review）」と「CIチェック（Test/Lint）の通過」を必須とする。
*   **Secret Management (No Credential in Code)**:
    *   APIキー、パスワード、秘密鍵などの機密情報は、**絶対に**Gitリポジトリにコミットしてはならない。
    *   `.env` ファイルを使用し、`.gitignore` に必ず追加する。
    *   万が一コミットしてしまった場合は、即座にそのクレデンシャルを無効化（Revoke）し、再発行する。`git filter-branch` 等で履歴を改変しても、一度漏れた情報は「漏洩済み」とみなす。
*   **Code Signing (Verified Commits)**:
    *   可能な限りGPG署名を行い、コミットの真正性を担保する（Verifiedバッジ）。なりすましを防ぐ。
*   **Dependency Security**:
    *   `npm audit` や `Dependabot` を活用し、依存ライブラリの脆弱性を常に監視する。High以上の脆弱性は即時対応する。

## 6. AI-Managed Workflow (Owner Friendly)
*   **Zero-Touch for Owner**:
    *   オーナー（ユーザー）はGitのコマンドやブランチ戦略を意識する必要はない。これらは全て開発チーム（AI）が裏側で厳格に運用する。
    *   オーナーへの報告は「機能Aの実装が完了しました（内部では `feat/feature-a` をマージ済み）」といった、ビジネス言語で行う。
*   **Automatic Safety**:
    *   AIは、コミット前に必ず自己レビューを行い、機密情報の混入や日本語ルールの違反がないかを確認する。
    *   複雑なGit操作（rebase, cherry-pick等）が必要な場合も、AIが安全に実行し、オーナーには結果のみを報告する。

## 7. Critical Merge Protocol (User Confirmation)
*   **Mandatory Confirmation**:
    *   破壊的変更（Breaking Changes）、データベースのスキーマ変更、セキュリティに関わる重要なマージを行う際は、**必ず事前にオーナー（ユーザー）の承認を得る**こと。独断での実行は厳禁とする。
*   **Layman-Friendly Explanation**:
    *   承認を求める際は、「`DROP TABLE users`を実行します」といった専門用語ではなく、「**ユーザー情報を管理する表を完全に削除し、作り直します。これまでのデータは消えますがよろしいですか？**」のように、**素人でもリスクと結果が完全に理解できる平易な日本語**で説明する。
    *   「マージしていいですか？」と聞く前に、何が起きるかを徹底的に説明する義務がある。
