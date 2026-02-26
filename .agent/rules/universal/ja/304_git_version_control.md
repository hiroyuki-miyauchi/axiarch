# 30. エンジニアリングの卓越性 (Engineering Excellence - General)

## 10. Gitとバージョン管理 (Git & Version Control)
*   **開発フロー (Trunk Based Development)**:
    *   **原則**: 長寿命のブランチは廃止し、短命のブランチから `main` へ頻繁に（毎日）マージします。
    *   **Stacked Diffs**: 巨大なPRを避け、依存関係のある小さなPRを積み重ねる手法を推奨します。
    *   **Branch Naming Standard**:
        *   ブランチ名は `type/summary` 形式で統一します（例: `feat/user-profile`, `fix/login-bug`）。
        *   Types: `feat` (機能), `fix` (修正), `refactor` (改善), `chore` (雑用)。
*   **コミットメッセージ (Conventional Commits)**:
    *   `type(scope): subject` 形式を厳守します（例: `feat(auth): add google login`）。本文には日本語で詳細を記述します。
    *   **Atomic Commits**: 1つのコミットには「1つの論理的変更」のみを含め、バグ発生時に「そのコミットだけ」をRevertすれば直る粒度を保ちます。
*   **プルリクエスト (Pull Requests)**:
    *   **The Pull Request Template Protocol**:
        *   **Law**: `.github/pull_request_template.md` を作成し、レビュワーに「何を、なぜ、どうやって検証するか」を強制的に入力させます。
        *   **Content**: "Type of change", "How to test", "Screenshots" の3項目は必須です。
    *   **The CI Timeout Protocol**:
        *   **Law**: すべてのCIジョブには必ず `timeout-minutes: 10` を設定してください。リソースの浪費と無限ループを防ぐため、10分を超えるビルドは「設計ミス」とみなします。
    *   **100行ルール**: PRは小さく保ちます。
    *   **保護設定**: `main` への直接プッシュは禁止し、CI（Build, Test, Lint）通過とレビュー承認を必須とします。
    *   **Husky Guard (Universal Mandate - Deep Defense)**:
        *   **Law**: 全てのプロジェクトにおいて、**Husky** の導入および `pre-push` フックによる `main` (および `master`) ブランチへの直接プッシュ禁止設定を **義務（Universal Mandate）** とします。サーバーサイドの保護設定が可能な場合でも、防衛線を物理的に二重化（Deep Defense）し、「間違ってプッシュした」という言い訳を物理的に不可能にしてください。
        *   **Law 2 (No Human Trust)**: 「気をつける」という運用ルールは無意味です。物理的にプッシュできない仕組み（Code not Policy）のみを信頼してください。
        *   **Action**: プロジェクト初期化時に必ず `npx husky init` を実行し、ガードレールを設置することを初期化フェーズの必須要件とします。
    *   **The Automated Git Hooks Protocol (Lint Staged)**:
        *   **Law**: 人間の「気をつける」を排除します。`lint-staged` を導入し、コミットされるファイルに対して自動的に `eslint --fix` と `prettier --write` を実行することを義務付けます。
        *   **Outcome**: これにより、「汚いコード」がGit履歴に混入することを物理的に阻止します。
    *   **The Red Button Checklist (Deploy Final Gate)**:
        *   **Law**: 本番デプロイ直前には、以下の項目を**指差し確認**することを義務付けます。
            1. **Legal**: 利用規約・プライバシーポリシーは最新か？
            2. **Security**: RLSポリシーは `Anon` でテスト済みか？
            3. **FinOps**: クラウドの予算上限（Spend Cap）は有効か？
            4. **Data**: 本番用マスターデータは投入済みか？
    *   **Branch Hygiene Mandate (ゴミ屋敷撲滅・最重要規定)**:
        *   **Law**: マージ済みのローカルブランチを放置することは、環境差異による事故と混乱を招く「エンジニアとして恥ずべき行為」であり、開発環境を「ゴミ屋敷」化させる諸悪の根源です。
        *   **Action**: 作業ブランチを閉じる際は、必ず「ローカルとリモートの差異確認」と「不要ブランチの削除（掃除）」を完了条件とします。タスク完了の報告（Final Notify）の直前に、必ず `git branch --merged` を確認し、不要になった作業ブランチを物理削除することを**エンジニアの呼吸**としてください。
    *   **Omnichannel Check**: レビュー時は「Web以外（iOS/Androidアプリ）でも利用可能か？」を最優先で確認します。"Web Only" のロジックは即座にRejectします。
    *   **Deployment Safety Protocol**:
    *   **Supreme Directive: The AI Git Ban (Refer to 00)**:
        *   **Ref**: AIによるGit操作の絶対禁止については、最高法規 000番台（Core & Mindset） の Rule 8.1 を参照し、これを厳守してください。
    *   **The Automated Deployment Mandate (CD First)**:
        *   **No Manual Deployment**: 本番環境へのデプロイ（DB変更含む）を、開発者の手動コマンド（`supabase db push` 等）で行うことは、オペミスと不整合の元凶であり**完全禁止**とします。
        *   **CI/CD Only**: デプロイは必ず「検証されたコード」が「信頼されたパイプライン（GitHub Actions）」を通過した結果としてのみ実行されなければなりません。ヒューマンエラーを排除します。
    *   **The Architectural Preservation Protocol (Code Sanctuary)**:
        *   **Context**: 自動リファクタリングや掃除タスクによる、重要コア機能の誤削除（Friendly Fire）を防ぐ必要があります。
        *   **Action**: プロジェクトの中核機能（Core Features）を構成するファイルには、先頭に **`@preservation_level CRITICAL`** ヘッダーを付与してください。このマークがあるファイルに対し、AIは独断での削除・移動・破壊的変更を行ってはなりません。必ずユーザーの明示的承認を得てください。

*   **セキュリティ**:
    *   APIキー等の機密情報は絶対にコミットせず、`.env` を使用します。CIでシークレットスキャン（TruffleHog）を義務付けます。
    *   **The Lockfile Regeneration Reflex (CI Consistency)**:
        *   **Problem**: ローカル環境（macOS）で `build/lint` が通過しても、CI環境（Linux）で失敗する場合、原因の9割は `package-lock.json` の不整合（OS間差異や未コミットの更新）です。
        *   **Action**: CIのみが失敗する現象に遭遇したら、調査に時間をかける前にまず `rm -rf package-lock.json node_modules && npm install` を実行し、Lockfileを再生成してプッシュしてください。依存関係ツリーの完全な同期こそが、環境差異バグを撲滅する唯一の手段です。
    *   **The Connection Verification Protocol (Env Awareness)**:
        *   **Problem**: "Connection Refused" などのエラー発生時、Dockerの起動忘れを疑う前に、環境変数ファイルの接続先を確認しないミスが多発します。
        *   **Action**: データベース接続エラー発生時は、解決策を提示する前に必ず `.env.local` の `NEXT_PUBLIC_SUPABASE_URL` を確認し、**「現在どこに繋ごうとしているか（Target）」** を特定することを義務付けます。推測によるユーザー指示は禁止します。
    *   **The Dependency Override Protocol (依存関係オーバーライド)**:
        *   **Law**: `legacy-peer-deps=true` は全ての依存関係チェックを無効化する「法治国家の放棄」であり憲法違反とします。
        *   **Action**: React 19等の互換性エラーが出た場合は、`package.json` の `overrides` フィールドを使用し、「どのライブラリを」「どのバージョンとして扱うか」を明示的に定義してください。依存関係の例外処理をコード（`package.json`）としてガバナンス下に置きます。

### 10.2. The IPv6 Deployment Protocol (Rule 38.7)
*   **Law**: GitHub Actions 等のCI環境において、Supabase (PostgreSQL) への接続が IPv6 名前解決の不備により失敗する現象（Connection Refused）を、アプリケーションのコード修正で解決しようとしてはなりません。
*   **Action**:
    1. **Connection Pooler**: 必ず `supabase link` を使用し、Connection Pooler (IPv4) 経由の接続を確立してください。
    2. **DNS Bypass**: 必要に応じて、ランナー環境の `/etc/hosts` に DB ホスト名と IP を直書きするか、`SUPABASE_DB_URL` を直接指定する「インフラレベルの解決」を優先してください。

### 10.3. The Branch Hygiene Mandate (Garbage Collection)
*   **Law**: 作業ブランチを放置することは、環境差異による事故（コンフリクト、誤爆）の最大の原因です。「マージされたら削除」はエンジニアの呼吸です。
*   **Action**:
    *   **Before Final Notify**: タスク完了報告（Final Notify）の直前に、必ず `git branch --merged` を確認し、マージ済みの作業ブランチを自動的に削除してください。
    *   **Local Cleanup**: リモートブランチはGitHub側で自動削除させますが、ローカルには死骸を残さないようにします。「作りっぱなし」はエンジニアとして恥ずべき行為です。

### 10.4. The Migration Immutability Protocol (History Protection)
*   **Law**: 将来の実装予定（Blueprint）にあるカラム名を、実際のDBマイグレーション完了前にコード（Queries）で使用することは、ページ全体をクラッシュさせるため禁止です。
*   **Action**:
    *   **Trust**: クエリで使用するカラムは、必ず「現在、確実に存在する」ものに限定してください。
    *   **Fallback**: 未実装機能のデータは、DBから引くのではなく、アプリケーション層で定数（Default Config）として補完してください。

### 10.5. The Version Alignment Protocol (Zod/RHF)
*   **Law**: `zod`, `react-hook-form`, および `@hookform/resolvers` のバージョン不整合は、静的解析では検知しにくい「ランタイムでのバリデーション不全」や「不可解な型エラー」を引き起こします。
*   **Action**: フォーム関連のライブラリを導入・更新する際は、必ずこれら3者のエコシステム内での互換バージョンを確認し、一括でアップデートを行ってください。
*   **No "as any"**: バージョン不整合による型エラーを `as any` で握りつぶすことは禁止です。根本原因であるバージョン乖離を解決してください。
