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

## 4. セキュリティ・アーキテクチャ (Security Architecture)
*   **サプライチェーン・セキュリティ (Supply Chain Security)**:
    *   **Dependency Watch**: `npm audit` を定期的に実行し、High/Critical な脆弱性は24時間以内にパッチを適用するか、回避策を講じます。未使用の依存パッケージは定期的に削除し、攻撃対象領域（Attack Surface）を最小化してください。
*   **認証と認可 (Authentication & Authorization)**:
    *   **Credential Hygiene**: APIキー、シークレット、DB接続文字列をソースコード内に記述することを物理的に禁止します（No Hardcoding）。必ず `process.env` を使用し、機密情報の共有には1Password等の暗号化チャネルを使用してください（Slack貼り付け禁止）。
    *   **MFA (多要素認証)**: 管理者権限を持つアカウントには**MFAを強制**します。例外はありません。
    *   **Admin Privilege Verification Standard**: 管理者権限の確認には、必ず **`public.profiles` テーブルの `role` カラム**（例: `role = 'admin'`）を唯一の正（SSOT）として使用してください。フロントエンドのフラグや、過去の遺物である `admin_users` テーブルへの依存はセキュリティホールの温床となります。
    *   **Official Content Protection**: `news` や `column` などの公式コンテンツの作成・更新・削除は、**「管理者 (Admin)」または「編集者 (Editor)」** の権限を持つユーザーのみに厳格に制限します。単なるログイン状態 (`auth.uid()`) 確認だけでは不十分です。
    *   **IDaaS**: 自前で認証基盤を構築しません。Firebase Auth, Auth0, Cognito等の検証済みソリューションを使用します。
    *   **Omnichannel Auth**: Webクッキーだけでなく、ネイティブアプリからの **Bearer Token (JWT)** アクセスにも完全対応します。「Webセッションがあるから」という理由でServer Actions側の検証を省略することは禁止です。
    *   **The Guardian Protocol (Centralized Auth)**: 権限チェックロジックの散在を禁止します（DRY違反・漏れのリスク）。必ず `src/lib/auth/admin-guard.ts` (AdminGuard) 等の集約されたガードクラス/関数を使用して検証を行い、独自に `supabase.from('user_roles')...` を書くことを「Anti-Pattern」として厳禁とします。
*   **API Key Security**:
    *   **Hashing Mandate**: API Key (`sk_live_...`) は、**絶対に平文でDBに保存してはなりません**。必ず SHA-256 等でハッシュ化して保存し、認証時は入力値をハッシュ化して照合するという「パスワードと同様の扱い」を義務付けます。
    *   **Dual Auth Protocol**: Middlewareは `X-API-KEY` (System) と `Authorization: Bearer` (User) の両方を受け入れ、いずれかが有効であれば通す「OR条件」で実装し、ネイティブアプリ（VIP Lane）からのアクセスをシームレスに許可してください。ログインユーザー（Bearer Token）には、API Keyなしで同等の特権を自動的に付与する設計を推奨します。
*   **OWASP Top 10 対策**:
    *   **インジェクション**: SQL/NoSQLインジェクションを防ぐため、ORMやパラメータ化されたクエリのみを使用します。
    *   **Strict Validation**: クライアントからの入力データはすべて「汚染されている」と仮定し、**Zod** 等のスキーマバリデーションを用いて厳格に型と値を検証します。不正なデータは DB に到達する前に棄却してください。
    *   **アクセス制御**: 全てのAPIエンドポイントで、リクエスト元ユーザーがそのリソースにアクセスする権限を持っているか厳密にチェックします（Firestore Security Rules / RLS）。

## 5. ライセンスと規約遵守 (License & ToS Compliance)
*   **ライセンス汚染防止 (License Contamination Prevention)**:
    *   **GPL禁止**: コピーレフト性のあるライセンス（GPL, AGPL）のライブラリは、プロダクト全体のソースコード公開義務が発生するリスクがあるため、**使用禁止**とします。
    *   **許可ライセンス**: MIT, Apache 2.0, BSD, ISC などのパーミッシブライセンスのみを使用します。
    *   **CIチェック**: CIパイプラインでライセンススキャンを自動実行し、違反ライブラリの混入を阻止します。
*   **プラットフォーム規約 (Platform ToS)**:
    *   **Google/Apple**: スクレイピング、非公開APIの使用、レビュー操作など、プラットフォームの利用規約（ToS）に違反する行為は、たとえ技術的に可能でも**絶対に行いません**。アカウントBANは事業の死を意味します。

## 6. インフラセキュリティ (Infrastructure Security)
*   **ネットワーク分離**:
    *   データベースや内部APIは、インターネットから直接アクセスできないプライベートネットワーク（VPC）内に配置します。
*   **The Tokyo Mandate (Data Residency)**:
    *   **Law**: エンタープライズ顧客のコンプライアンス要件を満たすため、本番データの保存場所（Region）は **Tokyo (ap-northeast-1)** リージョンに固定することを標準とします。
    *   **Compliance**: バックアップデータ（R2/S3等）についても、法的な理由がない限り国内リージョンに集約してください。
*   **The Database Fortress Protocol**:
    *   **Search Path Defenses**: `SECURITY DEFINER` 関数には必ず `SET search_path = ''` (空) を付与し、検索パスへの依存を物理的に断ち切ってください。関数内では全てのテーブル・関数参照を `public.table_name` のように**スキーマ完全修飾**で記述することを義務付けます。
        *   **Reason (Trojan Horse)**: Postgresの仕様上、`search_path`が固定されていないと、攻撃者が用意した同名の罠テーブルを特権で参照させられる脆弱性が生じます。`SET search_path = public` は妥協であり、エイリアス攻撃のリスクを残します。これを怠ることは「家の鍵を開けたまま外出する」に等しい愚行です。
    *   **Explicit RLS**: ポリシー `USING (true)` は無条件開放を意味します。必ず `TO service_role` を付与するか、厳格な条件式を記述し、「デフォルトで安全」という幻想を捨ててください。
*   **多層防御 (Multi-Layered Defense)**:
    *   **L1 (Edge/WAF)**: Cloud Armor や AWS WAF (Managed Rules) を使用し、GeoIP ブロック、Bot 検知を行い、悪意あるトラフィックおよび **EDoS 攻撃（リソース枯渇攻撃）** を物理的に遮断します。
    *   **WAF Policy**: SQL Injection, XSS, Generic Attacks 等のルールセットを常に **「Block」モード** で稼働させてください。
    *   **App Check**: Firebase App Check等を導入し、正規のアプリ以外からのAPIアクセスを遮断します。
    *   **Rate Limiting**:
        *   **Law**: 公開系（Public）のアクション（Inquiry, Auth）には、必ず `checkRateLimit` によるレートリミット（例: 5回/時）を実装し、多層防御（Defense in Depth）を構築します。
        *   **Fail Fast**: レートリミット超過時は、DB接続や重い処理を行う前に即座にエラーを返し、リソースを保護します。
        *   **Implementation**: Vercel KV や Upstash Redis を使用し、エッジでの高速なブロックを実現してください。DB負荷をかけないことが重要です。
    *   **Middleware Matcher Safety**: `middleware.ts` の `config.matcher` に複雑な正規表現を使用することを禁止します。不透明なRegexは適用漏れや ReDoS 攻撃の温床となります。可読性の高い配列形式を採用してください。

## 7. 攻撃的セキュリティ (Offensive Security)
*   **セルフ・ペネトレーションテスト**:
    *   開発者は「攻撃者」の視点を持ち、自分のコードに対してSQLインジェクションやXSSを試みる思考実験を行います。
    *   FirestoreのSecurity Rulesは、「誰でも読み書きできる」状態からスタートせず、「誰も何もできない」状態から必要な権限だけを付与します（Allowlist方式）。
