# 60. セキュリティとプライバシー (Security & Privacy - CISO & Legal View)

> [!IMPORTANT]
> **Level 1 Priority: Absolute Compliance**
> セキュリティと法的コンプライアンスは、Google Antigravityにおける**最上位の優先事項**です。
> ユーザーの利便性、開発速度、収益性、これら全てよりも優先されます。議論の余地はありません。

> [!CRITICAL]
> **Supreme Directive (最高指令)**
> 個人情報保護とセキュリティは、機能要件・納期・コストよりも常に優先されます。
> 本ドキュメントの内容に違反するコードは、いかなる理由があっても本番環境へデプロイしてはなりません。
>
> **The Zero Tolerance Protocol**:
> リスクに気づいた時点で、その大小や発生確率に関わらず、**例外なく・即座に・徹底的に** 対応してください。信用こそが最大の資産であり、それを損なう可能性のある事象を放置することは事業への背信行為です。

### 9.1. セマンティックエラー整合性プロトコル (The Semantic Error Consistency Protocol - RFC 7807+)
*   **Law**: API エラーレスポンスは、必ず **RFC 7807 (Problem Details for HTTP APIs)** またはそれに準拠した標準化された JSON フォーマットで返却されなければなりません。
*   **Mandate**:
    *   `type`: エラーの種類を識別する URI。
    *   `title`: 人間が読める抽象的なエラー説明。
    *   `status`: HTTP ステータスコード。
    *   `detail`: 発生した具体的な問題の説明（機密情報を除く）。
    *   `instance`: 発生個所の URI。
*   **Action**: クライアント側（UI）は、この `title` または `detail` をそのままダイアログ等に表示できる「おもてなしの心」を持って、バックエンドからエラー情報を構築してください。

### 9.2. The Function Search Path Lockdown (関数セキュリティ強化)
*   **Law**: PostgreSQLの `SECURITY DEFINER` 関数において、`search_path` を固定しないことは「家の鍵を開けたまま外出する」に等しい脆弱性です。
*   **Threat Model**: 攻撃者が `temp` スキーマや他スキーマに同名のテーブル/関数を配置し、特権関数の実行コンテキストを乗っ取る「Search Path Injection」攻撃が可能になります。
*   **Action**:
    1.  **Empty Search Path**: `SECURITY DEFINER` 関数には必ず `SET search_path = ''`（空文字列）を設定してください。`SET search_path = public` は妥協であり、エイリアス攻撃のリスクを残します。
    2.  **Fully Qualified References**: 関数内の全てのテーブル・関数参照を `public.users`、`public.is_admin()` のように**スキーマ完全修飾**で記述することを義務付けます。
    3.  **System Schema Exclusion**: `storage`, `auth`, `graphql`, `extensions` 等のシステムスキーマ内のオブジェクトへのDDL操作は原則禁止です。これらはSupabaseが管理する領域です。
    4.  **CI Validation**: 新規関数追加時は、CIで `search_path` が正しく設定されていることを検証するスクリプトの導入を推奨します。
*   **Outcome**: Search Path攻撃を物理的に不可能にし、特権エスカレーション（Privilege Escalation）のリスクをゼロにします。

### 9.3. The Strict CSP Nonce Protocol (CSP最高強度義務)
*   **Law**: Content Security Policy（CSP）において、`'unsafe-inline'` や `'unsafe-eval'` を追加してスクリプトブロックを回避することは「防御の放棄」であり禁止します。
*   **Action**:
    1.  **Nonce Propagation**: 全てのインラインスクリプトおよび外部ウィジェット（Turnstile, reCAPTCHA, GTM等）には、Middleware から生成された **Nonce** を伝播させ、ブラウザに正当性を証明してください。
    2.  **Strict Dynamic**: 信頼済みスクリプトが動的に読み込むサブリソースには `'strict-dynamic'` を使用し、明示的なドメインホワイトリストへの依存を最小化してください。
    3.  **Report-Only First**: 新規CSPルール導入時は `Content-Security-Policy-Report-Only` で影響を観測してから本番適用してください。
    4.  **No Compromise**: セキュリティ機能のブロックに対して「`unsafe-inline` を追加すれば動く」という提案は、開発者としての敗北です。正攻法の技術改善で解決してください。
*   **Outcome**: XSS攻撃のリスクを構造的に排除し、最高強度のCSPを維持します。

### 9.4. The Cryptographic Consistency Mandate (暗号化整合性義務)
*   **Law**: APIキーやトークンなどの機密情報を扱う際、**生成・保存フェーズと認証・検証フェーズが同一の暗号化アルゴリズムを使用**しなければなりません。
*   **Action**:
    1.  **Algorithm Unity**: 生成時に SHA-256 でハッシュ化した値を保存するなら、検証時も同じ SHA-256 でハッシュ化して比較してください。アルゴリズムの不一致は「永久に認証が通らない」バグの直接原因です。
    2.  **Schema Match**: ハッシュ化した値を保存するカラム名（`key_hash` 等）と、アプリケーションコードで参照するカラム名が完全一致することを型レベルで保証してください。
    3.  **Rotation Ready**: 将来のアルゴリズム変更に備え、保存時にアルゴリズム識別子（`sha256:xxxx`）をプレフィックスとして含める設計を推奨します。
*   **Anti-Pattern**: 生成時に平文保存し、認証時にハッシュ比較を行う（またはその逆）は「永久に不一致」を生む致命的バグです。

### 9.5. The Client-Side Branch Guard Protocol（クライアント側ブランチ保護）
*   **Law**: Git の `pre-push` フックにより、保護ブランチ（`main`, `master` 等）への直接Push を **物理的に不可能** にしてください。サーバーサイドのブランチ保護（GitHub Branch Protection等）が利用可能な場合でも、防衛線を二重化（Deep Defense）してください。
*   **Action**:
    1.  **Mandatory Hook**: プロジェクト初期化時に `husky` 等のGit Hooks管理ツールを導入し、`pre-push` フックを設定してください。
    2.  **Push Block Logic**: フック内で現在のブランチ名を検査し、保護ブランチ名に一致する場合は `exit 1` で強制中断してください。
    3.  **No Human Trust**: 「気をつける」という運用ルールは無意味です。物理的にPushできない仕組み（Code, not Policy）のみを信頼してください。
*   **Rationale**: 保護ブランチへの意図しない直接Pushは、未承認デプロイ、履歴の汚染、およびチームの信頼への背信を招きます。特にGitHub Free Plan等でサーバーサイド保護が制限される環境では、クライアント側ガードが唯一の防衛線です。

### 9.6. The Unconditional Baseline Auth Mandate（無条件ベースライン認証義務）
*   **Law**: 特権クライアント（Service Role等）を呼び出すアクション層のハンドラは、データのステータスや重要度に関わらず、**ベースラインとなる認証・認可チェックを例外なく全コードパスで実行**しなければなりません。
*   **Action**:
    1.  **No Conditional Bypass**: 「下書きだから認証チェックを省略」「内部APIだからガードを緩和」という条件付きバイパスは禁止です。認証強度の切り替え（MFA/OTPの要否等）は許容しますが、「誰が実行しているか」のアイデンティティ検証を条件付きにしてはなりません。
    2.  **Defense in Depth**: 特権クライアントはDBレベルのアクセス制御をバイパスするため、アプリケーション層のチェック漏れが致命的な脆弱性に直結します。全コードパスで最低限の認可チェック（`ensureAuth()` / `ensureRole()` 等）を強制してください。
    3.  **Branch Audit**: ステータスや条件による分岐（`if (status === 'draft') ... else ...`）を持つアクション関数を追加・変更した際は、全分岐パスで認証ガードが一貫して呼び出されているかレビューしてください。
*   **Rationale**: 「非公開だから安全」という仮定は、攻撃者がAPI呼び出しを直接操作できる環境では無効です。特権クライアントを使用するアクションにおける認証チェックの漏れは、権限昇格（Privilege Escalation）の直接的な原因となります。
