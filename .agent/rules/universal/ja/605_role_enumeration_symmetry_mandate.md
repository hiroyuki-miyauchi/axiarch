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

### 9.7. The Role Enumeration Symmetry Mandate（ロール列挙対称性義務）
*   **Law**: 同一ドメイン（例: 管理者権限）を検証する複数のガード関数（ページアクセス用、API用、Server Action用等）は、許可するロールの一覧を **共通の定数配列** から取得しなければなりません。
*   **Action**:
    1.  **Shared Constants**: 許可ロール一覧は `ALLOWED_ADMIN_ROLES` 等の単一の定数として定義し、全てのガード関数がこの定数を参照してください。各関数内で個別にロールをリテラル文字列で列挙することは禁止です。
    2.  **Full-Count Verification**: ロールの追加・変更・削除を行った際は、プロジェクト全体で当該ロールを参照している全ガード関数の全数検査を義務付けます。
    3.  **Failure Transparency**: ロール不一致によるガード失敗は、ユーザーに対して明確なエラーメッセージを表示し、開発環境では `Logger.warn` で不整合を即座に検知できるようにしてください。
*   **Rationale**: ページアクセスガードには `master_admin` を含むが、Server Actionガードには含まない、といった不一致は、「管理画面には入れるが書き込みだけが失敗する」という極めて不透明なデッドロックを引き起こします。ロール列挙の構造的な共有は、この種の不整合を物理的に防止します。
*   **Anti-Pattern**: `requireAdmin` と `ensureAdminAction` でそれぞれ独立した文字列リテラル `['admin', 'super_admin']` を保持し、新ロール追加時に片方だけ更新漏れが発生するケース。

### 9.8. The Strict CSP Nonce Protocol（CSP Nonce厳格化プロトコル）
*   **Law**: Content Security Policy（CSP）において、`unsafe-inline` や `unsafe-eval` の使用は「セキュリティ防御の放棄」と定義します。全てのインラインスクリプトには**Middleware で生成された暗号的に安全な Nonce** を使用し、CSP の厳格性を維持しなければなりません。
*   **Action**:
    1.  **Nonce Generation**: Middleware で `crypto.randomUUID()` 等を使用してリクエストごとに一意の Nonce を生成し、`Content-Security-Policy` ヘッダーに `'nonce-{value}'` として設定してください。
    2.  **Nonce Propagation**: 生成された Nonce は、カスタムヘッダー（例: `x-nonce`）を通じてサーバーコンポーネントに伝播し、全てのインラインスクリプト（`<script nonce={nonce}>`）に適用してください。
    3.  **No Fallback to Unsafe**: サードパーティスクリプト（ウィジェット、分析ツール等）の統合時に `unsafe-inline` への妥協を許さないでください。代わりに、外部ファイルとして読み込み `script-src` にドメインを列挙するか、ハッシュベースの許可リストを使用してください。
    4.  **CSP Report**: `report-uri` / `report-to` ディレクティブを設定し、CSP違反をサーバーサイドで収集・監視してください。
*   **Rationale**: `unsafe-inline` はXSS（クロスサイトスクリプティング）攻撃に対するCSPの防御を完全に無効化します。Nonce ベースのCSPは、正当なインラインスクリプトのみを許可し、攻撃者が注入したスクリプトの実行を物理的にブロックします。

### 9.9. The Anti-Permissive RLS Mandate（RLSポリシー衛生義務）
*   **Law**: Row Level Security（RLS）のポリシー設計において、**過度に許容的なポリシーの作成を禁止**します。意図を明確にし、最小権限の原則を厳守してください。
*   **Action**:
    1.  **No `FOR ALL` Policy**: `FOR ALL` は `SELECT`, `INSERT`, `UPDATE`, `DELETE` の全操作を一括で許可するため、権限の粒度が粗くなり意図の把握が困難です。操作ごとに個別のポリシーを作成してください。
    2.  **No `WITH CHECK (true)`**: `WITH CHECK (true)` は「誰でも無条件に書き込み可能」を意味します。書き込み操作には必ず条件（例: `auth.uid() = user_id`）を設定してください。
    3.  **USING (true) の限定使用**: `USING (true)` は公開データの `SELECT` ポリシーで**のみ**許容します。`UPDATE` や `DELETE` の `USING (true)` は原則禁止です。
    4.  **Policy Naming Convention**: ポリシー名は `tablename_action_role_policy`（例: `posts_select_authenticated_policy`）の形式で命名し、ポリシーの意図を名前から即座に把握可能にしてください。
*   **Rationale**: RLSはデータアクセスの「最後の砦」です。過度に許容的なポリシーは、アプリケーション層のバグやAPI直接アクセスによるデータ漏洩・改竄のリスクを増大させます。最小権限の原則により、想定外のアクセスを物理的に遮断します。

### 9.10. The Cryptographic Randomness Mandate（暗号学的乱数義務）
*   **Law**: セキュリティ目的（パスワード生成、トークン生成、Nonce生成、セッションID等）において、`Math.random()` の使用は**大罪（Mortal Sin）**です。`Math.random()` は暗号学的に安全ではなく（PRNG）、予測可能な出力を生成するため、攻撃者による推測を許します。
*   **Action**:
    1.  **Client-Side**: 必ず `window.crypto.getRandomValues()` を使用してください。
    2.  **Server-Side (Node.js)**: 必ず `crypto.randomBytes()` または `crypto.randomUUID()` を使用してください。
    3.  **Framework Integration**: フレームワークが提供する暗号学的に安全なランダム生成関数（例: `crypto.randomUUID()`）が利用可能な場合は、それを優先使用してください。
*   **Rationale**: CSPRNG（暗号論的擬似乱数生成器）のみが、トークンやシークレットの推測不能性を保証します。`Math.random()` による生成は、ブルートフォース攻撃の対象となります。

### 9.11. The Cookie Scope Protocol（Cookie スコープ分離義務）
*   **Law**: 一時的な認証状態や権限情報を Cookie に保存する際、スコープの広さは最小限に抑え、リソース単位で分離しなければなりません。
*   **Action**:
    1.  **Specific Naming**: Cookie 名は `{purpose}_{resource_id}` のように、リソース単位で一意かつ推測困難な名前空間を使用してください。汎用的な名前（`auth_token`, `session` 等）の乱用は、Cookie 汚染（Cookie Tossing）のリスクを高めます。
    2.  **Attribute Armor**: セキュリティ属性を必ず付与してください:
        *   `HttpOnly`: JavaScript からの Cookie アクセスを遮断し、XSS 攻撃による Cookie 窃取を防止します。
        *   `Secure`: 本番環境では HTTPS 通信時のみ Cookie を送信します。
        *   `SameSite=Lax` (または `Strict`): CSRF攻撃を防止します。
    3.  **Minimal Lifetime**: 一時的な認証 Cookie の有効期限は、用途に応じた最短期間に設定してください。
*   **Rationale**: Cookie のスコープが広すぎると、異なるリソース間での認証状態の汚染や、攻撃者による不正なセッション乗っ取りのリスクが増大します。

### 9.12. The Server-Side Storage Guard Protocol（サーバーサイドStorage委任義務）
*   **Law**: 公開サイトのフォーム等において、クライアントサイドからストレージサービス（S3、Cloud Storage、Supabase Storage等）へファイルを直接アップロードすることを禁止します。
*   **Action**:
    1.  **Server Delegation**: クライアントはファイルを **Server Action / API Route** へ送信し、サーバーサイドで管理者権限クライアントを用いてアップロードを実行してください。
    2.  **Path Control**: 保存パス（Slug/UUID等）はサーバー側でのみ生成・検証し、クライアントからのパス指定を許可しないでください（Path Traversal 防止）。
    3.  **Validation**: サーバーサイドでファイルの MIME タイプ、サイズ、拡張子を再検証してください。クライアントサイドのバリデーションのみに依存してはなりません。
*   **Rationale**: クライアントサイドからの直接アップロードは、サーバーサイドの監査ログ、バリデーション、パスの正規化をバイパスし、不正ファイルの混入やストレージパスの改竄を許す「ガバナンスの穴」となります。
