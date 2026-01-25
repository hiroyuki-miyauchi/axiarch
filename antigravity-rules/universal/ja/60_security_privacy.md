# 60. セキュリティとプライバシー (Security & Privacy - CISO & Legal View)

> [!IMPORTANT]
> **Level 1 Priority: Absolute Compliance**
> セキュリティと法的コンプライアンスは、Google Antigravityにおける**最上位の優先事項**です。
> ユーザーの利便性、開発速度、収益性、これら全てよりも優先されます。議論の余地はありません。

> [!CRITICAL]
> **Supreme Directive (最高指令)**
> 個人情報保護とセキュリティは、機能要件・納期・コストよりも常に優先されます。
> 本ドキュメントの内容に違反するコードは、いかなる理由があっても本番環境へデプロイしてはなりません。

## 1. 優先順位の鉄則 (The Golden Rule)
*   **Legal & Security > User Experience**:
    *   **鉄則**: 「ユーザーが望んでも、法的にリスクがあるなら提供しない」。
    *   **例**: ユーザーが「ログインなしで履歴を見たい」と望んでも、プライバシーリスクがあるなら却下します。「オフラインで決済したい」と望んでも、セキュリティリスクがあるなら却下します。
*   **Zero Trust Architecture**:
    *   「内部ネットワークは安全」という前提を捨てます。全てのアクセス、全てのリクエストを検証します。
    *   **Rule 10.1.1: The Untrusted Default**: 内部IP、管理者アカウント、AIエージェントを含む全てのアクセス主体を「信頼しない」前提で、**認証(Authentication)**、**認可(Authorization)**、**暗号化(Encryption)** を強制します。

## 2. 法的コンプライアンス (Legal Compliance)
*   **グローバル規制 (Global Regulations)**:
    *   **GDPR (EU) / CCPA (California) / APPI (Japan)**: これらのプライバシー規制を「最低ライン」として遵守します。
    *   **データ主権**: ユーザーのデータはユーザーのものです。データの削除、エクスポート（データポータビリティ）の権利をシステムレベルで保証します。
*   **特定商取引法 & 資金決済法 (Japan Specifics)**:
    *   **前払い式支払手段**: ポイントやコインを発行する場合、資金決済法に基づく供託義務（1000万円基準）を常に監視し、財務局への届出が必要なラインを超えないよう制御、または届出を行います。
    *   **特商法表記**: 有料販売を行う場合、法的に求められる全ての情報を明記します。

## 3. プライバシー・バイ・デザイン (Privacy by Design)
*   **データ最小化 (Data Minimization)**:
    *   **原則**: 「いつか使うかも」でデータを取得することは禁止です。ビジネスに不可欠なデータのみを収集します。
    *   **保存期間**: データの保存期間（Retention Policy）を定義し、期限が過ぎたデータは自動的に削除または匿名化します。
*   **同意管理 (Consent Management)**:
    *   **Opt-in**: マーケティングメールやトラッキングCookieは、デフォルトでOFF（Opt-in）にします。ユーザーを騙すようなDark Pattern（Opt-outを隠す等）は**絶対禁止**です。
*   **The "Right to be Forgotten" (忘れられる権利)**:
    *   **Physical Deletion**: ユーザー退会処理は、PII（個人特定情報）を含む関連レコードを**物理削除（DELETE）**することを基本とします。論理削除（`deleted_at`）は、PIIを含まないトランザクションデータ（購入履歴や統計データ）にのみ適用を許可します。
*   **The API Output Hygiene**:
    *   Public APIからのレスポンスには、PII（メールアドレス、詳細住所等）、内部パラメーター（内部ID、メモ）、セキュリティフィールド（パスワードハッシュ、Salt）を**物理的に含めてはなりません**（DTOによる除去）。

## 4. セキュリティ・アーキテクチャ (Security Architecture)
*   **認証と認可 (Authentication & Authorization)**:
    *   **MFA (多要素認証)**: 管理者権限を持つアカウントには**MFAを強制**します。例外はありません。
    *   **IDaaS**: 自前で認証基盤を構築しません。Firebase Auth, Auth0, Cognito等の検証済みソリューションを使用します。
    *   **Omnichannel Auth**: Webクッキーだけでなく、ネイティブアプリからの **Bearer Token (JWT)** アクセスにも完全対応します。「Webセッションがあるから」という理由でServer Actions側の検証を省略することは禁止です。
*   **API Key Security**:
    *   **Hashing**: API Key (`sk_live_...`) は、**絶対に平文でDBに保存してはなりません**。必ずハッシュ化して保存し、認証時は入力値をハッシュ化して照合します。
*   **OWASP Top 10 対策**:
    *   **インジェクション**: SQL/NoSQLインジェクションを防ぐため、ORMやパラメータ化されたクエリのみを使用します。
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
*   **多層防御 (Multi-Layered Defense)**:
    *   **Edge (WAF)**: Cloud ArmorやAWS WAFを使用し、GeoIPブロックやBot検知を行い、DDoS攻撃やEDoS攻撃（リソース枯渇）から保護します。
    *   **App Check**: Firebase App Check等を導入し、正規のアプリ以外からのAPIアクセスを遮断します。

## 7. 攻撃的セキュリティ (Offensive Security)
*   **セルフ・ペネトレーションテスト**:
    *   開発者は「攻撃者」の視点を持ち、自分のコードに対してSQLインジェクションやXSSを試みる思考実験を行います。
    *   FirestoreのSecurity Rulesは、「誰でも読み書きできる」状態からスタートせず、「誰も何もできない」状態から必要な権限だけを付与します（Allowlist方式）。

## 8. 高度セキュリティ運用プロトコル (Advanced Security Operations)

### 8.1. The Double Security Protocol (Turnstile + OTP)
*   **Law**: すべての重要セキュリティ操作（ログイン、登録、PW変更、退会等）は、「Managed Turnstile」と「OTP (One-Time Password)」による2重防御を実装しなければなりません。
*   **Action**:
    1.  **Layer 1 (Pre-Auth)**: Turnstile (`appearance: 'always'`) でボットを物理的にブロックします。認証完了（`onSuccess`）まで送信ボタンを**物理的に無効化（disabled）**してください。
    2.  **Layer 2 (Auth)**: OTPによる本人確認完了まで、データの変更（UPDATE/DELETE）を許可してはなりません。
    3.  **Fail-Safe**: エラー時は即座にボタンを無効化し、状態をリセットする再試行フローを構築します。

### 8.2. The Audit Log Obligation (No Invisible Hands)
*   **Law**: 監査ログを経由しないDB書き込みは、セキュリティ上の死角（Blind Spot）です。
*   **Action**:
    *   **Prohibition**: クライアントサイドからの直接的なDB変更操作を原則禁止します。
    *   **Mandate**: 必ず `Server Actions` を経由し、その内部で `recordAuditLog` を呼び出し、誰がいつ何をしたかを記録してください。

### 8.3. The PII Logging Defense (Masking Protocol)
*   **Law**: ログへの個人情報（Email, Token, Password）流出は、システム最大のセキュリティリスクの一つです。
*   **Action**: Loggerクラス内部で、`password`や`token`等のキーワードを含むフィールドを自動的に `***MASKED***` に置換するロジックを実装し、開発者のミスによる流出を防いでください。

### 8.4. The User Experience Preservation Protocol (UX保護プロトコル)

> [!CRITICAL]
> **Supreme UX Directive (UX至上命令)**
>
> - **Principle**: 「セキュリティ」を言い訳にしてユーザー体験（UX）を損なうことは、システム設計上の**完全な敗北**であり、Google Antigravityとして断じて許容しません。過剰な認証はユーザーの離脱を招き、結果としてサービスの価値を毀損します。
> - **Law**: Turnstile (Cloudflare) や OTP (ワンタイムパスワード) などの強力な認証は、**「重大なリスクを伴う操作」** にのみ適用を許可し、それ以外での使用を**厳禁**とします。
> - **Classification**:
>   - **Critical (Authentication Required)**: ログイン、決済、出金、アカウント削除、コンテンツの「公開(Publish)」、重要設定の変更。
>   - **Non-Critical (Authentication Forbidden)**: 下書き保存(Draft Save)、AI生成(Gen-AI)、コンテンツの閲覧(Read)、コンテンツの「下書き更新」。
> - **Mandate**: `StoreForm` 等の編集画面において、下書き保存やAI機能利用時にモーダル認証を要求することは**憲法違反**です。これらはストレスフリーで実行されなければなりません。
