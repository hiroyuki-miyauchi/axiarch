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

### 2.1. The Legal Content Consistency Protocol (Terms/Privacy SSOT)
*   **Law**: 利用規約、プライバシーポリシー、特定商取引法に基づく表記などの法的文書をソースコード内にハードコード（`const TERMS = ...`）することは、表記の不整合（Desynchronization）を招き、法務上のリスクとなるため禁止します。
*   **Action**:
    *   **SSOT (Single Source of Truth)**: 法的文書は、必ず **Headless CMS** または **データベース (Database)** を唯一の正とします。
    *   **DB Management**: 全ての法的テキストは `site_settings` または専用テーブルの `text` カラムとして管理し、管理画面から非エンジニアでも即座に修正・公開可能にしてください。
    *   **Versioning**: 改定履歴を残すため、`version`, `valid_from` 等のカラムを用いて履歴管理を行い、ユーザーがいつでも過去の規約を参照できる透明性を確保してください。
    *   **No Code Deployment for Terms**: 法的文言の修正、誤字脱字の訂正のためにアプリの再デプロイを必要とする設計は、設計上の欠陥とみなします。

## 3. プライバシー・バイ・デザイン (Privacy by Design)
*   **データ最小化 (Data Minimization)**:
    *   **原則**: 「いつか使うかも」でデータを取得することは禁止です。ビジネス上の正当な目的（Legitimate Interest）がない入力を Schema Validation (Zod 等) で棄却します。
    *   **Legal Hold**: 法的保管義務のあるデータ（決済履歴等）のみ、別テーブル（Cold Storage）へ厳重に隔離して特定期間保存してください。
    *   **保存期間 (Retention Policy)**:
    *   データの保存期間を定義し、期限が過ぎたデータは自動的に削除または匿名化します。
    *   **Standard**: キャンペーン等の期間限定データは終了後 **90日以内**、一般的なアクセスログは **1年以内** に物理削除するライフサイクルを標準とします。
*   **同意管理 (Consent Management)**:
    *   **Opt-in**: マーケティングメールやトラッキングCookieは、デフォルトでOFF（Opt-in）にします。ユーザーを騙すようなDark Pattern（Opt-outを隠す等）は**絶対禁止**です。
    *   **Anonymized Usage Consent**: 「匿名化された統計データは、サービス改善や研究、公益目的のために利用される可能性がある」旨の同意を、登録プロセスにおいて明示的に取得することを義務付けます。
*   **The Professional Advice Disclaimer (免責規律)**:
    *   **Law**: 健康、医療、法律、財務等の専門的アドバイスを含む可能性のあるサービスでは、「本サービスは専門家（獣医師、医師、弁護士等）の直接的な診断や助言に代わるものではない」旨の免責事項を、フッターや重要操作画面、利用規約に物理的に表示してください。
*   **The "Right to be Forgotten" (忘れられる権利)**:
    *   **Physical Deletion Mandate**: ユーザー退会処理 (`deleteAccount`) は、PII（メールアドレス、氏名、住所、電話番号、口座情報等）を含むレコードを **物理削除 (HARD DELETE)** しなければなりません。単なる `deleted_at` フラグ（論理削除）で個人情報を残し続けることは、**GDPR違反** および重大なプライバシーリスクとみなします。
    *   **Anonymization Exception**: 購買履歴等のトランザクションデータを残す場合は、PII カラムを物理的に `NULL` またはハッシュ値で上書き（Masking）し、個人との紐付けを永久に断ち切ることを条件とします。
    *   **Backup Purge**: DBの自動バックアップ（PITR）に含まれる削除済みデータについては、バックアップ保持期間（例: 7日〜30日）の経過をもって完全消滅とする運用ポリシーを利用規約に明記してください。
*   **The API Output Hygiene**:
    *   Public APIからのレスポンスには、PII（メールアドレス、詳細住所等）、内部パラメーター（内部ID、メモ）、セキュリティフィールド（パスワードハッシュ、Salt）を**物理的に含めてはなりません**（DTOによる除去）。
*   **The Sensitive Asset Mandate (Private Storage)**:
    *   **Law**: 証明書、鑑定書、医療記録等の機密文書画像は、必ず **非公開 (private)** バケットに保存してください。公開 (`public`) バケットの使用は厳禁です。
    *   **Access**: これらのファイルへのアクセスは、サーバー側で生成した **`Signed URL` (署名付きURL)** を通じてのみ、数分〜数時間程度の短い有効期限付きで提供してください。
*   **Encryption at Rest & In Transit**:
    *   **PII Encryption**: DB内のセンシティブな個人情報（口座情報、本人確認書類ID、住所詳細等）は、Supabase Vault や pgcrypto (`pgp_sym_encrypt`) を用いてアプリケーションレベルで暗号化して保存します。
    *   **TLS 1.3**: すべての通信はHTTPS (TLS 1.2以上、推奨1.3) を強制します。

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

## 8. 高度セキュリティ運用プロトコル (Advanced Security Operations)

### 8.1. The Double Security Protocol (Rule 0.0: Turnstile + OTP Mandate)
*   **Law**: すべての重要セキュリティ操作（ログイン、登録、PW変更、メール変更、退会等）は、「Managed Turnstile」と「OTP」による2重防御を実装しなければなりません。
*   **Outcome**:
    1.  **Layer 1 (Pre-Auth & Physical Blocking)**: 
        *   **Managed Turnstile** (`appearance: 'always'`) を必須とし、ユーザーに「認証中」であることを可視化してください。
        *   **Physical Lock**: 認証完了（`onSuccess`）のコールバックが発火するまで、送信ボタン（Submit Button）を**物理的に無効化（disabled）**してください。「見えない処理」でユーザーを待たせることはUXの欠陥であり、重大なセキュリティリスクです。
    2.  **Layer 2 (Auth)**: **OTP** (Email/Authenticator) による本人確認を完了させるまで、最終的なデータ変更（UPDATE/DELETE）を許可してはなりません。
    3.  **Fail-Safe Mechanism**: トークン期限切れ（`onExpire`）やエラー時は即座にボタンを無効化し、状態をリセットして再試行を促すフローを構築してください。
    4.  **No Exception**: セキュリティ強固を最優先とし、UX優先の特例は認めないものとします。
    5.  **Scope Limitation**: このプロトコルは日常操作（下書き、表示切替等）ではなく、重大な「重要操作」にのみ適用してください。
    6.  **Security Incentive Program**: MFA設定等の高セキュリティ認証を有効化したユーザーに対し、システム内特典（リライト制限の緩和、高度機能利用権等）を付与する設計を推奨します。「セキュリティは負担ではなくメリット」と体験させてください。

### 8.1.1. The Tiered Security Protocol (段階的セキュリティ)
*   **Law**: セキュリティ強度は操作のリスク（不可逆性・影響範囲）に応じて段階的に適用します。過剰な認証は「無能なシステム」の証明であり、不十分な認証はセキュリティホールを生みます。
*   **Tier Definition**:
    *   **Tier 1 (Mild)**: 一般的な単体削除（メディア、コメント等）、アーカイブ、ステータス変更 → `Turnstile + Keyword Confirmation ("削除"等の入力)` のみ。OTPは不要（UX優先）。
    *   **Tier 2 (Strict)**: 一括削除、フォルダ削除、重要設定変更、**最重要データの単体削除（ユーザー、プラン、決済関連等）** → `Turnstile + Keyword Confirmation + 高セキュリティ認証 (OTP/MFA) 必須`。
*   **Action**: 新機能実装時は、必ず既存類似機能のUI/ロジックを確認し、100%同一の振る舞いを実装してください。「似ているが違う」は整合性を欠くバグです。

### 8.2. The Audit Log Obligation (No Invisible Hands)
    *   **The Audit Log Obligation**: 監査ログを経由しないDB書き込みはセキュリティ上の死角です。重要な操作（作成・更新・権限変更）は、`actor_id`, `action`, `resource`, `details` を含む所定のスキーマで記録してください。
    *   **The Privileged Data Access Audit (High-Sensitivity Mandate)**:
        *   **Context**: ユーザー本人以外の第三者（運営スタッフ、提携専門家等）が、ユーザーの機密データや高秘匿記録（健康、資産、身分証明等）を閲覧する場合、それは「信頼の預かり」であり、最大の責任を伴います。
        *   **Law**: 高秘匿ドメインのリソースに対し、第三者による **参照（SELECT）** が行われる場合は、必ず **「閲覧理由 (Reason)」** の入力を物理的に強制し、履歴を記録してください。
        *   **Retention**: この全閲覧監査ログは、不正閲覧への強力な抑止力および説明責任の証跡として **永久保存 (Permanent Retention)** を義務付けます。
    *   **The Immutable Log Mandate (WORM)**:
        *   **Law**: `audit_logs` テーブルは **Append-Only (追記のみ)** とし、RLSポリシーにて `UPDATE` および `DELETE` を物理的に禁止してください。
        *   **Archiving**: 古いログの削除は、自動パーティション管理（pg_partman）またはTTL機能によってのみ行い、人間の手動操作を禁じます。

### 8.3. The Information Disclosure Protocol (Error Masking - Rule 8.3)
*   **Law**: エラーメッセージ（特に本番環境）において、DBのテーブル名、カラム名、スタックトレース、外部APIの生レスポンスなどの内部情報（Detailed Information）をエンドユーザーに表示することを物理的に禁止します。
*   **Action**: 
    1. サーバーサイドでエラーをキャッチし、ログには詳細を記録（`error_logs`）します。
    2. フロントエンドには一律で「エラーが発生しました（Error ID: xxxxx）」という抽象的なメッセージのみを返し、攻撃者へのヒント（Information Disclosure）を遮断してください。

### 8.4. The Zero Trust DTO Flow (Rule 8.4)
*   **Law**: APIリクエストおよび Server Action のレスポンスにおいて、DBの生レコード（`Row`）をそのまま返却することを**最高レベルで禁止**します。
*   **Action**: 
    1. 全てのデータ出力は、必ず **DTO (Data Transfer Object)** インターフェースを経由してください。
    2. **Strict Segregation**: 公開用 DTO (`PublicUserDTO`) と管理用 DTO (`AdminUserDTO`) を物理的に分離してください。管理用 DTO は `/admin` コンテキスト以外での使用を禁じます。
    3. ホワイトリスト方式（必要な項目のみを明示的に選択）を徹底し、将来的な機密カラム追加時の「意図しない流出」を構造的に防御してください。

### 8.5. The Security Verification Mandate (Rule 8.5)
*   **Law**: コードが正しいことを確認するだけでは、セキュリティは完成しません。
*   **Action**: セキュリティに関連する変更（RLS変更、認証フロー変更等）を行った際は、必ず **「実際のDB上で権限がないユーザーがエラーになること（Negative test）」** を物理的に確認し、その結果をエビデンスとして記録してください。机上検証のみのデプロイは厳禁です。

### 8.6. The Privacy Guardrail Protocol (Admin Firewall)
*   **Law**: 管理画面からの公式発表やLPにおいて、運用者が誤って個人の携帯番号やメールアドレスを公開してしまう事故は「最大の恥」です。
*   **Action**: 
    1.  **Client-Side Scan**: 管理画面の保存ボタン押下時に、正規表現でコンテンツ全体をスキャンするロジックを実装してください。
    2.  **Explicit Consent**: PII（電話番号、メールアドレス等）のパターンを検出した場合は、必ず `confirm()` ダイアログ等で警告し、「明示的な承認」がない限り、物理的に保存をブロックしてください。

### 8.7. The Admin DTO Defense (Strict Output Hygiene)
*   **Law**: 管理画面 (`/admin`) だからといって、全てのDBカラムを無防備にフロントエンドに送信してはなりません。これは将来的に追加される機密カラム（原価、仕入先連絡先、内部メモ）の漏洩を招きます。
*   **Action**: 管理系API (`getAdminUsers` 等) においても、必ず専用の **DTO (`AdminUserDTO` 等)** を定義し、ホワイトリスト方式で必要なフィールドのみを明示的に選択して返却することを義務付けます。`SELECT *` の使用は厳禁です。

### 8.8. The PII Logging Defense (Masking Protocol)
*   **Action**: Loggerクラス内部で、`password`や`token`等のキーワードを含むフィールドを自動的に `***MASKED***` に置換するロジックを実装し、開発者のミスによる流出を防いでください。

### 8.9. The Security-UX Balance Protocol (No Friction Mandate)
*   **Law**: 「セキュリティ」を言い訳にしてUXを損なうことは、システム設計上の**完全な敗北**です。過剰な認証は**「無能なシステム」**の証明であり、ユーザーの離脱を招き、サービスの価値を毀損します。
*   **Action**:
    1.  **Critical Actions Only**: TurnstileやOTPは、DB書き込み、重要設定変更、決済等の「不可逆または高リスクな操作」の最終段階でのみ要求してください。
    2.  **No UI Friction**: モーダルを開く、タブを切り替える、ファイルをアップロード（選択）するといった「探索・中間操作」において認証を挟むことを**厳禁**とします。
    3.  **Daily Operation Exemption**: 下書き保存（Draft Save）や AI 生成、UI の切り替えなど、**「不可逆なデータ破壊や決済を伴わない日常操作」** については、Turnstile や OTP を免除し、UX を最優先してください。システムは操作の重要度（Criticality）を文脈で判断する義務があります。
    4.  **Context Awareness**: 既に認証済みのセッション内で行う軽微な操作に対し再認証を強いることは、ユーザーへの「信頼の欠如」とみなします。

### 8.10. The Strict Nonce Protocol (Highest Security Mandate)
*   **Law**: 外部スクリプト（Turnstile, GTM 等）のブロックに対し、安易に `'unsafe-inline'` や `'unsafe-eval'` を追加する行為は「防御の完全放棄」であり、開発者としての敗北です。Elite Audit において、これらは即時不合格（Automatic Failure）の対象となります。
*   **Action**:
    1.  **Nonce-First Protocol**: `Next.js` の `headers` または `middleware` で生成された `nonce` を、全てのインラインスクリプトおよび外部ウィジェットに伝播させ、ブラウザに「このコードこそが正当な主によるもの」であることを物理的に証明せよ。
    2.  **Strict CSP**: `Content-Security-Policy` ヘッダーにおいて、常に最高強度の設定（Strict CSP）を死守してください。
    3.  **No Scapegoating**: 「ライブラリが古いから一時的に許可する」という判断を禁止します。問題の根本（ライブラリの選定、Nonceの実装ミス）を解決してください。

### 8.11. The IPv6 Deployment Protocol (Connection Hygiene)
*   **Law**: GitHub Actions 等のCI環境とSupabase間の接続において、IPv6名前解決の問題による接続エラーを防ぐための適切な構成を義務付けます。
*   **Action**:
    *   **Official Link**: `supabase link` を使用し、Connection Pooler等の適切な経路を確立してください。（詳細は `37_backend_supabase.md` の Rule 7.2 を参照）

### 8.12. The No Security Bypass Penalty
*   **Law**: 開発効率やCI通過を優先して、セキュリティ機能（SSL検証、CORS制限、Auth Middleware等）を一時的にでも無効化することを厳禁とします。
*   **Action**: これを発見した場合は即座に Revert し、重大な憲法違反として扱います。

### 8.13. The Infrastructure Reality Protocol (WebAuthn/MFA)
*   **Law**: コードが正しくても、インフラ側の設定（Supabase ダッシュボードの MFA 有効化等）が無効であれば、機能は不全に陥ります。
*   **Action**: 認証関連の高度機能を実装する前に、必ずコンソール上の設定状態を確認する「先決義務」を課します。
*   **Graceful Failure**: 基盤設定により機能が使えない場合でも、クラッシュせず「現在ご利用いただけません」等の適切なフィードバックを返すフォールバックを義務付けます。

### 8.14. The Secret Rotation Lifecycle
*   **Lifecycle**: IAMクレデンシャルやJWT署名鍵は、**90日ごと** にローテーション（交換）することを必須とします。
*   **Panic Button**: 万一の漏洩時に、全セッションを一括無効化できる「Kill Switch」手順を常に最新の状態に保ってください。

### 8.15. The Physical Master Key (Bus Factor Defense)
*   **Risk**: 管理者のPC紛失、認証情報の忘却、または不慮の事故によるアクセス権の永久喪失。
*   **Law**: 極めて重要なリカバリー情報は、デジタル管理だけでなく「物理媒体（紙）」に記録し、耐火金庫等に保管する **Analogue Backup** を義務付けます。
*   **Scope**: 
    1. Supabase `service_role` キー (Emergency Access 用)
    2. Cloudflare Super Admin Recovery Code
    3. ドメイン・レジストラ・ロックコード
    4. 主要認証マネージャー (1Password等) のマスターキー
*   **Mandate**: 「デジタルが消滅しても、紙一枚あれば復旧できる」状態を維持してください。

### 8.16. The Digital Legacy Protocol (Inheritance)
*   **Problem**: 契約者の死亡や意識不明時、ロックされたアカウント内の「命のデータ（資産、健康記録）」にアクセスできなくなるリスクを回避してください。
*   **Law**: 「緊急時アクセス権（Emergency Contact）」機能を設計に含めることを推奨します。
*   **Inheritance**: 指定された承継者は、法的な手続きが完了する前であっても、緊急時に必要な最低限の情報（ライフライン、重要な健康情報等）への Read-Only アクセス権を、あらかじめ合意されたプロトコルに基づき継承できるアーキテクチャを維持してください。

### 8.17. The Incident Response & Drill Protocol
*   **Law**: セキュリティインシデント（情報漏洩、不正アクセス）発生時の初動対応が遅れることは、二次被害を拡大させる致命的な不手際です。
*   **Action**: 
    1.  **Semi-Annual Drills**: 半年に1回、擬似的なセキュリティインシデント（漏洩、攻撃）を想定した **対応訓練** を実施し、連絡網と Kill Switch 手順を確認してください。
    2.  **Post-Mortem Obligation**: インシデント発生後は、必ず「なぜ起きたか」「どうすれば再発しないか」を言語化し、Blueprint（設計書）を更新することを義務付けます。

## 9. 勝利のプロトコル (The Victory Protocol - Standard of Excellence)
*   **The Iron Fortress Mandate**: 我々が維持するのは、ただのアプリではなく「城塞」です。
    1.  **Zero Warning Enforcement**: Security Advisor / Performance Advisor の警告（Warning/Error）が1件でも発生している状態でのプルリクエストは、自動的に **Reject** されます。
    2.  **No "True"**: RLSポリシーにおける `USING (true)` および `WITH CHECK (true)` は、いかなる理由があっても記述してはなりません。必ず `TO service_role` を付与するか、厳格な条件式を記述してください。
    3.  **No "No Policy"**: `RLS Enabled` かつポリシーが存在しない状態（INFO警告）は断じて許されません。
    4.  **Admin Lock**: 管理者専用テーブルは `role = 'admin'` 等で鉄壁に守ってください。
*   **Strategic Exception (Info Acceptance)**: `unused_index` 等の「Info（情報）」レベルに限り、意図的な設計であれば許容（Accepted）しますが、警告を消すために必要なインデックスを削除する「過剰防衛」は禁止します。



### 9.1. セマンティックエラー整合性プロトコル (The Semantic Error Consistency Protocol - RFC 7807+)
*   **Law**: API エラーレスポンスは、必ず **RFC 7807 (Problem Details for HTTP APIs)** またはそれに準拠した標準化された JSON フォーマットで返却されなければなりません。
*   **Mandate**:
    *   `type`: エラーの種類を識別する URI。
    *   `title`: 人間が読める抽象的なエラー説明。
    *   `status`: HTTP ステータスコード。
    *   `detail`: 発生した具体的な問題の説明（機密情報を除く）。
    *   `instance`: 発生個所の URI。
*   **Action**: クライアント側（UI）は、この `title` または `detail` をそのままダイアログ等に表示できる「おもてなしの心」を持って、バックエンドからエラー情報を構築してください。
