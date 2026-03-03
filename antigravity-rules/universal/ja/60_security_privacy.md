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
*   **Privacy Impact Assessment (PIA / プライバシー影響評価)**:
    *   **Law**: 新機能の実装前に、取り扱う個人情報の種類・保存先・アクセス権限・保持期間を明文化した「プライバシー影響評価書」を作成し、レビューを経なければなりません。
    *   **Action**:
        1.  **PIA Document**: 新たにPIIを取得・処理する機能を追加する際は、データの種類・保存先・アクセス権限・保持期間を明文化してください。
        2.  **Purpose Limitation**: 取得目的を利用規約に明記し、目的外利用を技術的にも運用的にも禁止します。目的変更時はユーザーから再同意を取得してください。
        3.  **Transparency**: ユーザーに対して「何のデータを、なぜ、どのくらいの期間保持するか」をユーザーの母国語で平易に説明するUIを提供してください。
        4.  **Data Flow Mapping**: システム内のPIIの流れ（入力→保存→参照→外部連携→削除）を図示し、各ポイントでの保護措置を明記してください。
        5.  **PR Review Gate**: 新規機能のPRレビュー時に「PIA完了」を確認項目に含めてください。
    *   **Rationale**: プライバシー保護は「事後対応」ではなく「設計段階からの組み込み」が国際標準（ISO 31700, GDPR Art.25）です。
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
*   **The Granular Sharing Protocol (共有範囲制御)**:
    *   **Law**: ユーザー間でデータを共有する機能において、単なる閲覧・編集権限だけでなく、**レコード単位またはフィールド単位**で「共有範囲（全員公開 / 限定メンバーのみ / 本人のみ）」を指定できる設計を推奨します。
    *   **Default Private**: 決済情報、個人的メモ、健康記録詳細など秘匿性の高いフィールドは、デフォルトで **「本人のみ（Private）」** に設定し、ユーザーの明示的な操作なしに共有対象に含まれることを防いでください。
    *   **Visibility Matrix**: 共有設定は、RLS（Row Level Security）またはアプリケーションロジック層で強制し、フロントエンドの表示制御のみに依存しないでください。
*   **Encryption at Rest & In Transit**:
    *   **PII Encryption**: DB内のセンシティブな個人情報（口座情報、本人確認書類ID、住所詳細等）は、Supabase Vault や pgcrypto (`pgp_sym_encrypt`) を用いてアプリケーションレベルで暗号化して保存します。
    *   **TLS 1.3**: すべての通信はHTTPS (TLS 1.2以上、推奨1.3) を強制します。

## 4. セキュリティ・アーキテクチャ (Security Architecture)
*   **サプライチェーン・セキュリティ (Supply Chain Security)**:
    *   **Dependency Watch**: `npm audit` を定期的に実行し、High/Critical な脆弱性は24時間以内にパッチを適用するか、回避策を講じます。未使用の依存パッケージは定期的に削除し、攻撃対象領域（Attack Surface）を最小化してください。
    *   **The Dependency Vulnerability Patrol Protocol（脆弱性定期巡回）**:
        *   **CI連携**: `main` ブランチへのPR作成時、CI内で `npm audit --audit-level=high` を自動実行してください。
        *   **マージブロック**: `high` 以上の脆弱性が検出された場合、**PRマージを禁止**してください。
        *   **対応 SLA**:
            | 脆弱性レベル | 対応期限 | アクション |
            |:-----------|:--------|:---------|
            | **Critical / High** | **72時間以内** | 即時パッチ適用、または影響回避策を実装 |
            | **Medium** | **2週間以内** | 次スプリントで対応 |
            | **Low** | **次メジャーリリース** | バッチ更新で対応 |
        *   **自動更新**: Renovate または Dependabot を導入し、依存パッケージの更新PRを自動生成してください。
        *   **禁止事項**: `package.json` への `*` ワイルドカードバージョン指定、およびHigh以上の脆弱性を放置しての本番デプロイを禁止します。
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
*   **Email Domain Authentication Protocol (メールドメイン認証基準)**:
    *   **Mandate**: メール到達率となりすまし防止を保証するため、以下の3つのDNS認証を**全て**設定しなければなりません。

        | 認証方式 | 設定対象 | 目的 |
        |:--------|:--------|:-----|
        | **SPF** | TXTレコード | 送信元サーバーの正当性検証 |
        | **DKIM** | TXTレコード | メール内容の改竄検知 |
        | **DMARC** | TXTレコード | SPF/DKIM失敗時のポリシー定義 |

    *   **DMARC Policy**: `p=none`（監視）→ `p=quarantine`（隔離）→ `p=reject`（拒否）の段階的強化を推奨します。
    *   **Monitoring**: DMARC Aggregate Report を定期的に確認し、なりすまし送信を検知してください。
    *   **Prohibition**: フリーメールアドレス（`@gmail.com` 等）からのシステムメール送信を禁止します。
*   **Email Domain Separation Protocol (送信ドメイン分離基準)**:
    *   **Law**: トランザクションメール（パスワードリセット、決済完了等）とマーケティングメール（ニュースレター等）は**異なる送信元アドレス**を使用しなければなりません。
    *   **Rationale**: マーケティングメールの配信停止やスパム判定が、トランザクションメールの到達率に影響するのを防ぐ必須措置です。
    *   **Reply-To**: `noreply@` から送信する場合でも、`Reply-To` ヘッダーにサポート用アドレスを設定し、ユーザーが返信した場合にサポートへ到達できるようにしてください。
*   **Webhook Security Protocol（Webhook検証基準）**:
    *   **Context**: 外部サービスからのWebhookは、偽造・リプレイ攻撃の対象となりえます。全受信エンドポイントで検証を義務付けます。
    *   **Mandate**:
        *   **署名検証（必須）**:
            *   全Webhookリクエストの `signature` ヘッダーを **HMAC-SHA256** 等で検証してください。
            *   署名が一致しないリクエストは即座に `401 Unauthorized` を返し、アラートログに記録してください。
            *   署名シークレットは環境変数で管理してください（Credential Hygiene 参照）。
        *   **リプレイアタック防止**:
            *   Webhookペイロード内の `timestamp` を検証し、**5分以上前のリクエストは拒否**してください。
            *   処理済みイベントIDを一定期間キャッシュし、重複実行を防止してください。
        *   **冪等性保証**:
            *   同一 `event_id` のWebhookが複数回到達しても、副作用は1回のみ発生するよう設計してください。
            *   冪等性キーとしてWebhook固有IDを使用し、処理前にDB上で重複チェックを実施してください。
        *   **エラーハンドリング**:
            *   処理失敗時は `500` を返し、送信元のリトライ機構に依存してください。
            *   連続失敗（例: 3回以上）でアラート通知を発火する仕組みを構築してください。
    *   **Cross-Reference**: §4 (Credential Hygiene), §8.2 (Audit Log Obligation)

## 7. 攻撃的セキュリティ (Offensive Security)
*   **セルフ・ペネトレーションテスト**:
    *   開発者は「攻撃者」の視点を持ち、自分のコードに対してSQLインジェクションやXSSを試みる思考実験を行います。
    *   FirestoreのSecurity Rulesは、「誰でも読み書きできる」状態からスタートせず、「誰も何もできない」状態から必要な権限だけを付与します（Allowlist方式）。
*   **ペネトレーションテスト実施サイクル（Penetration Test Schedule）**:

    | 種別 | 頻度 | 対象 |
    |:-----|:-----|:-----|
    | **自動脆弱性スキャン** | 月次 | 全公開エンドポイント |
    | **手動ペネトレーション** | 年1回 | 認証・決済・管理画面 |
    | **臨時テスト** | 随時 | 重大な機能変更後 |

*   **OWASP Top 10 チェック義務**:
    *   インジェクション（SQL/NoSQL）、Broken Authentication、XSS、CSRF、SSRF 等のトップ10を網羅してください。
    *   各項目の合否を記録し、不合格項目は**48時間以内**に修正着手してください。
    *   対象範囲: 公開APIの全エンドポイント、管理画面（認証バイパス・権限昇格）、RLSポリシー、ファイルアップロード機能。
    *   結果はCritical/High/Medium/Lowに分類して記録し、`01_project_lessons_log.md`（教訓ログ）に追記してください。
*   **The Security Training Protocol（セキュリティ研修基準）**:
    *   **Law**: 技術的対策だけではセキュリティは担保できません。開発者の知識とセキュリティ意識の継続的向上が不可欠です。
    *   **研修プログラム**:
        | 種別 | 頻度 | 対象者 | 内容 |
        |:-----|:-----|:------|:-----|
        | **オンボーディング研修** | 入社時 | 全開発者 | OWASP Top 10、アクセス制御の基礎、PII取り扱い |
        | **定期研修** | 年1回 | 全開発者 | 最新脅威動向、インシデント事例レビュー |
        | **インシデント対応訓練** | 半年1回 | リード以上 | インシデント対応計画に基づく模擬訓練 |
    *   **必須知識チェックリスト**:
        *   SQLインジェクション対策（パラメータバインド、アクセス制御）
        *   XSS対策（テンプレートエンジンの自動エスケープ + CSP）
        *   CSRF対策（SameSite Cookie + Origin検証）
        *   認証・認可の分離（Zero Trust原則）
        *   PII取り扱い規則（ログマスキング、暗号化）
        *   環境変数管理（シークレットの取り扱い）
    *   **記録義務**: 研修受講記録を管理し、未受講者はコードレビュー承認権限を停止してください。


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

### 8.1.2. The Security-UX Balance Protocol（セキュリティ-UXバランス原則）
*   **Law**: 過剰なセキュリティ要求（不要な場面での Turnstile/OTP 要求）は、運用者の生産性を低下させ、最終的にサービス利用率の低下を招きます。セキュリティはUXを犠牲にする免罪符ではありません。
*   **Action**:
    1.  **Critical Actions Only**: Turnstile/OTP 認証は、DB書き込み（Save/Publish/Delete）や重要設定の変更など、「不可逆またはリスクの高い操作」の最終段階でのみ要求してください。
    2.  **No UI Friction**: モーダルを開く、タブを切り替える、ファイルを選択する（アップロード前）といった「探索・中間操作」において認証を挟むことを**厳禁**とします。
    3.  **Context Awareness**: すでに認証済みのセッション内で行う軽微な操作に対し、再認証を強いることは「信頼の欠如」であり、システム設計の欠陥とみなします。
*   **Rationale**: ユーザーに過剰な認証を繰り返し要求するシステムは、結果として認証疲れ（Security Fatigue）を誘発し、ユーザーが本当に重要な認証を軽視する逆効果を生みます。

### 8.2. The Audit Log Obligation (No Invisible Hands)
    *   **The Audit Log Obligation**: 監査ログを経由しないDB書き込みはセキュリティ上の死角です。重要な操作（作成・更新・権限変更）は、`actor_id`, `action`, `resource`, `details` を含む所定のスキーマで記録してください。
    *   **The Privileged Data Access Audit (High-Sensitivity Mandate)**:
        *   **Context**: ユーザー本人以外の第三者（運営スタッフ、提携専門家等）が、ユーザーの機密データや高秘匿記録（健康、資産、身分証明等）を閲覧する場合、それは「信頼の預かり」であり、最大の責任を伴います。
        *   **Law**: 高秘匿ドメインのリソースに対し、第三者による **参照（SELECT）** が行われる場合は、必ず **「閲覧理由 (Reason)」** の入力を物理的に強制し、履歴を記録してください。
        *   **Retention**: この全閲覧監査ログは、不正閲覧への強力な抑止力および説明責任の証跡として **永久保存 (Permanent Retention)** を義務付けます。
    *   **The Immutable Log Mandate (WORM)**:
        *   **Law**: `audit_logs` テーブルは **Append-Only (追記のみ)** とし、RLSポリシーにて `UPDATE` および `DELETE` を物理的に禁止してください。
        *   **Archiving**: 古いログの削除は、自動パーティション管理（pg_partman）またはTTL機能によってのみ行い、人間の手動操作を禁じます。
    *   **The Immutable Record Protocol (Edit Window + Correction Log)**:
        *   **Law**: 重要な事実記録（健康記録、契約履歴、資産台帳、検査結果等）は、一度確定したら安易に変更されるべきではない「事実」として扱ってください。
        *   **Edit Window**: ユーザーによる編集・削除は、レコード作成から **一定時間以内**（推奨: 24時間）に制限してください。期限超過後の直接変更は禁止します。
        *   **Correction Log**: 期限後に修正が必要な場合は、元のレコードを保持したまま **「訂正記録（Correction Log）」** として別レコードを作成し、修正理由と修正者を記録する設計としてください。原本の改竄を物理的に防止します。
        *   **Rationale**: 医療・法務・財務等の領域では、記録の改竄防止と追跡可能性（Traceability）が法的要件となる場合があります。Edit Window は利便性を確保しつつ、確定後の不可逆性を保証するバランス設計です。
    *   **The Action Instrumentation Mandate (計装網羅義務)**:
        *   **Law**: `create`, `update`, `delete` 等のデータベース状態を変更するServer Actions / APIハンドラには、**例外なく**監査ログの記録処理を**関数の冒頭付近**に計装してください。
        *   **Zero Blind Spots**: 証跡（Trail）のない操作は「存在しない」と同義であり、法的要請やインシデント調査に応えられない実装は不合格とみなします。
        *   **Cross-Reference**: `61_legal_data_privacy.md` §2 (Legal Snapshot Protocol)

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

### 8.7.1. The Select Specification Mandate（明示的カラム選択義務）
*   **Law**: データベースからのデータ取得において、`SELECT *` またはORMの `.select('*')` の使用を**全面的に禁止**します。全てのクエリは、その用途に必要なカラムのみを明示的に選択しなければなりません。
*   **Action**:
    1.  **Purpose-Specific Select**: 公開用・管理用・内部処理用など、用途ごとに必要なカラムセットを定義し、クエリはその定義に従って明示的にカラムを選択してください。
    2.  **DTO Alignment**: 選択するカラムは、対応する DTO (Data Transfer Object) のフィールドと一致させ、「取得したが使わないカラム」をレスポンスに含めないでください。
    3.  **Future-Proofing**: `SELECT *` を使用していると、将来テーブルに追加される機密カラム（原価、内部メモ、PII等）が意図せずレスポンスに含まれるリスクがあります。明示的選択はこの「未知のカラム漏洩」を構造的に防止します。
*   **Rationale**: 明示的なカラム選択は、①PII漏洩の構造的防止、②不要データの転送・パース負荷の削減によるパフォーマンス向上、③コードの可読性と意図の明確化、の三重の効果をもたらします。

### 8.8. The PII Logging Defense (Masking Protocol)
*   **Action**: Loggerクラス内部で、`password`や`token`等のキーワードを含むフィールドを自動的に `***MASKED***` に置換するロジックを実装し、開発者のミスによる流出を防いでください。

### 8.8.1. The PII Sensitivity Classification Standard (PII機微度分類基準)
*   **Law**: PIIを含むフィールドは、その機微度に応じて分類し、ログ出力・外部連携・分析利用時のマスキングレベルを標準化しなければなりません。分類なき保護は「漏れ」を生みます。
*   **Classification Template**:
    *   以下の3段階分類をベースラインとして、プロジェクト固有のデータに適用してください。

        | 分類 | 定義 | マスキングレベル | 例 |
        |:-----|:-----|:----------------|:---|
        | **機微情報 (Sensitive PII)** | 漏洩時に重大な人権侵害・差別・経済的損害を招く情報 | `[REDACTED]`（完全秘匿） | 診断名、投薬内容、口座情報、マイナンバー、犯歴 |
        | **個人情報 (Personal Info)** | 個人を直接特定可能な情報 | 部分マスキング（例: `山***`、`090-****-1234`） | 氏名、電話番号、メールアドレス、住所 |
        | **準個人情報 (Quasi-Personal Info)** | 単体では個人を特定しないが、他の情報と結合すると特定可能な情報 | マスキング不要（ただしアクセスログは記録） | 所属組織名、施設名、市区町村レベルの地域 |

*   **Action**:
    1.  **PIA連携**: 新規テーブル・カラム追加時のPIA（§3 Privacy Impact Assessment）において、各フィールドを上記3分類のいずれかに割り当ててください。
    2.  **Logger Integration**: PII Logging Defense（§8.8）のマスキングロジックは、この分類表に基づいてマスキングレベルを自動判定する設計としてください。
    3.  **Documentation**: 各プロジェクトのBlueprint（設計書）に、ドメイン固有のPII分類表を作成・維持してください。
*   **Rationale**: すべてのPIIを一律に `[REDACTED]` とすると、運用時のデバッグやサポート対応が困難になります。機微度に応じた段階的マスキングは、プライバシー保護とオペレーション効率のバランスを実現します。

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
*   **Prohibited Examples**:
    - `NODE_TLS_REJECT_UNAUTHORIZED=0`（SSL検証の無効化）
    - `Access-Control-Allow-Origin: *`（本番環境でのCORS全許可）
    - 認証Middlewareの検証ロジックをコメントアウトまたはスキップ

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

### 8.15.1. The RBAC Defense Protocol（RBAC防御プロトコル）
*   **Law**: 全てのAdmin API/Actionは、処理の冒頭でRBACチェックを強制し、操作のリスクレベルに応じた追加認証と監査ログの記録を義務付けます。
*   **Action**:
    1.  **Entry Point Guard**: 全てのAdmin API/Actionの冒頭で、集約された権限チェック関数（Guardian Protocol参照）を呼び出し、ロールベースのアクセス制御を実行してください。
    2.  **Tiered Additional Auth**: 金銭・権限・削除に関わる操作（Tier 2/3相当）は、RBACチェックに加えて Turnstile/OTP による追加認証を必須としてください。
    3.  **Mandatory Audit**: 全てのAdmin操作は例外なく監査ログに記録してください。特に破壊的操作（DELETE、権限変更、設定変更）は変更前後の差分を含めて保持してください。
*   **Rationale**: RBACチェック・追加認証・監査ログの3層を全Admin APIの共通パターンとして標準化することで、個別実装による抜け漏れを構造的に排除します。

### 8.16. The Digital Legacy Protocol (Inheritance)
*   **Problem**: 契約者の死亡や意識不明時、ロックされたアカウント内の「命のデータ（資産、健康記録）」にアクセスできなくなるリスクを回避してください。
*   **Law**: 「緊急時アクセス権（Emergency Contact）」機能を設計に含めることを推奨します。
*   **Inheritance**: 指定された承継者は、法的な手続きが完了する前であっても、緊急時に必要な最低限の情報（ライフライン、重要な健康情報等）への Read-Only アクセス権を、あらかじめ合意されたプロトコルに基づき継承できるアーキテクチャを維持してください。

### 8.17. The Incident Response & Drill Protocol
*   **Law**: セキュリティインシデント（情報漏洩、不正アクセス）発生時の初動対応が遅れることは、二次被害を拡大させる致命的な不手際です。
*   **Action**: 
    1.  **Semi-Annual Drills**: 半年に1回、擬似的なセキュリティインシデント（漏洩、攻撃）を想定した **対応訓練** を実施し、連絡網と Kill Switch 手順を確認してください。
    2.  **Post-Mortem Obligation**: インシデント発生後は、必ず「なぜ起きたか」「どうすれば再発しないか」を言語化し、Blueprint（設計書）を更新することを義務付けます。
*   **Incident Response 5-Step Protocol (初動タイムライン)**:
    *   **Context**: 個人情報保護法制（GDPR 72時間、日本APPI 速報3〜5日+確報30日等）は迅速な初動対応を義務付けています。以下のタイムラインを標準フローとしてください。

    | Step | 時間枠 | アクション | 責任者 |
    |:-----|:-------|:----------|:-------|
    | **1. 検知・隔離** | 0〜1時間 | 影響範囲の特定、アクセス経路の遮断（APIキー無効化、IP遮断）、ログの保全 | 技術責任者 |
    | **2. 影響範囲評価** | 1〜6時間 | 漏洩データの種類・件数の特定、二次被害リスクの評価 | 技術責任者 |
    | **3. 速報** | 3〜5日以内 | 監督機関への速報提出、影響ユーザーへの一次通知 | 事業責任者 |
    | **4. 根本原因分析** | 〜14日 | RCA（Root Cause Analysis）の実施、修正パッチの適用 | 技術責任者 |
    | **5. 確報・再発防止** | 〜30日 | 監督機関への確報提出、設計書への教訓追記、再発防止策の実装 | 事業責任者 |

    *   **Escalation Criteria（即時エスカレーション基準）**:
        *   PII（氏名・メール・住所等）が **1件でも** 外部に漏洩した場合
        *   認証・認可バイパスが確認された場合
        *   データベースの不正アクセス痕跡が検出された場合
    *   **Communication Ban**: インシデント発生中、原因が確定するまでSNS・公開チャネルでの情報開示を**禁止**します。公式発表は法務確認後に一元化してください。


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
*   **CSP Directive Change Governance（CSPディレクティブ変更ガバナンス）**:
    1.  **Centralized Management**: CSPディレクティブは `next.config.ts` の `headers()` 関数（または Middleware）で**一元管理**してください。複数ファイルへの分散は設定漏れや矛盾の温床です。
    2.  **PR Justification**: CSPディレクティブの変更（ドメイン追加、ディレクティブ緩和等）は、PRで**変更理由をセキュリティ観点から明記**し、セキュリティレビューを経なければなりません。
    3.  **Report-Only Staging**: 新しいCSPディレクティブや既存ディレクティブの変更は、本番適用前に `Content-Security-Policy-Report-Only` で**事前検証**し、正常動作を確認してから本番ヘッダーに昇格させてください。
*   **CSP Worker Protocol（Web Worker許可義務）**:
    *   **Law**: 画像処理ライブラリ（HEIC変換、Canvas圧縮等）やWebAssemblyモジュールは、内部で `Web Worker` を生成し `blob:` URLを使用する場合があります。厳格なCSP設定下ではこれがブロックされ、処理が**サイレントにハング**します（エラーすら発生しない場合がある）。
    *   **Action**: Web Workerを使用する可能性があるライブラリを導入する際は、CSP設定に `worker-src 'self' blob:;` を明示的に追加してください。
    *   **Rationale**: `worker-src` ディレクティブが未設定の場合、`script-src` のフォールバックが適用されますが、`blob:` が許可されていなければWorker生成が静かに失敗し、原因特定が極めて困難なバグとなります。

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

### 9.8.1. The Permissions-Policy Header Mandate（ブラウザAPI制限義務）
*   **Law**: `Permissions-Policy`（旧 `Feature-Policy`）ヘッダーを設定し、アプリケーションが使用しないブラウザAPI（カメラ、マイク、位置情報、支払い等）を**明示的に無効化**しなければなりません。
*   **Action**:
    1.  **Deny by Default**: プロジェクトで使用しないブラウザAPIは `()` （空リスト＝全拒否）で明示的に無効化してください。例: `Permissions-Policy: camera=(), microphone=(), geolocation=(), payment=()`.
    2.  **Self Only**: プロジェクトで使用するAPIは `(self)` に制限し、サードパーティ iframe やスクリプトからの不正利用を防いでください。
    3.  **Middleware Integration**: Next.js の `middleware.ts` や `next.config.ts` の `headers` 設定でレスポンスヘッダーとして追加してください。
    4.  **Audit**: 新しいサードパーティスクリプト（分析ツール、ウィジェット等）を追加する際は、そのスクリプトが要求するブラウザAPIを確認し、必要最小限のみ許可してください。
    5.  **DevTools Verification**: 新規ブラウザAPIを使用する際は、DevTools の Console で `Permissions policy violation` エラーが発生しないことを**物理的に確認**してください。ポリシーによるサイレントブロックはデバッグが極めて困難です。
    6.  **PR Justification**: `Permissions-Policy` ヘッダーの変更（API許可の追加・変更）は、PRで**変更理由を明記**し、レビューを経なければなりません。
*   **Rationale**: `Permissions-Policy` を設定しないと、ページに埋め込まれたサードパーティスクリプトや iframe が、ユーザーの同意なくカメラやマイクにアクセスする攻撃ベクタとなります。CSPと併用することで多層防御を実現します。

### 9.9. The Anti-Permissive RLS Mandate（RLSポリシー衛生義務）
*   **Law**: Row Level Security（RLS）のポリシー設計において、**過度に許容的なポリシーの作成を禁止**します。意図を明確にし、最小権限の原則を厳守してください。
*   **Action**:
    1.  **No `FOR ALL` Policy**: `FOR ALL` は `SELECT`, `INSERT`, `UPDATE`, `DELETE` の全操作を一括で許可するため、権限の粒度が粗くなり意図の把握が困難です。操作ごとに個別のポリシーを作成してください。
    2.  **No `WITH CHECK (true)`**: `WITH CHECK (true)` は「誰でも無条件に書き込み可能」を意味します。書き込み操作には必ず条件（例: `auth.uid() = user_id`）を設定してください。
    3.  **USING (true) の限定使用**: `USING (true)` は公開データの `SELECT` ポリシーで**のみ**許容します。`UPDATE` や `DELETE` の `USING (true)` は原則禁止です。
    4.  **Policy Naming Convention**: ポリシー名は `tablename_action_role_policy`（例: `posts_select_authenticated_policy`）の形式で命名し、ポリシーの意図を名前から即座に把握可能にしてください。
*   **Rationale**: RLSはデータアクセスの「最後の砦」です。過度に許容的なポリシーは、アプリケーション層のバグやAPI直接アクセスによるデータ漏洩・改竄のリスクを増大させます。最小権限の原則により、想定外のアクセスを物理的に遮断します。
*   **RLS Best Practices（RLS設計ベストプラクティス）**:
    *   **Service Role Bypass原則**: `service_role` キーは**RLSを完全にバイパス**します。したがって「管理者用ポリシー」（`FOR ALL USING (auth.role() = 'service_role')`）は冗長であり、**作成を禁止**します。冗長なポリシーは「Multiple Permissive Policies」警告の原因となり、各ポリシーが全クエリで評価されるためパフォーマンスも低下します。
    *   **Auth Function InitPlan最適化**: RLSポリシー内で `auth.uid()`, `auth.role()`, `current_setting()` を使用する場合、必ず **`(select ...)`でラップ**し、行ごとの再評価を防いでください。ラップなしの場合、大規模テーブルの各行スキャンごとに関数が再評価され、深刻なパフォーマンス低下を招きます。
        *   ❌ `USING (user_id = auth.uid())`
        *   ✅ `USING (user_id = (select auth.uid()))`
    *   **Single Purpose Policy原則**: 同一テーブル・同一ロール・同一アクション（SELECT/INSERT/UPDATE/DELETE）に対して**複数のPERMISSIVEポリシーを作成してはなりません**。複数ポリシーは OR 条件で評価され、全クエリで全ポリシーが実行されるためパフォーマンスが低下します。条件が複数ある場合は、単一ポリシー内で `OR` 演算子を使用して結合してください。

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

### 9.13. The Admin CMS Injection Defense（管理画面CMS注入防御）
*   **Law**: 管理画面からサイト全体の `<head>` やテンプレートに任意のHTML/スクリプトを埋め込める機能（カスタムヘッド、カスタムCSS、ウィジェット埋め込み等）は、強力なXSSベクタとなります。管理者アカウントが侵害された場合、サイト全体が汚染されるリスクがあります。
*   **Action**:
    1.  **Super Admin Only**: このような機能の編集・保存は、通常の管理者ではなく**最上位権限（System Admin / Super Admin）**を持つユーザーにのみ制限してください。
    2.  **Script Tag Warning**: 入力値に `<script>` タグや `javascript:` URI、`on*` イベントハンドラが含まれる場合、保存前にUI上で明示的な警告ダイアログを表示してください。
    3.  **Change Audit**: これらの変更は必ず監査ログに記録し、変更前後の差分を保持してください。
*   **Rationale**: 管理画面からの任意コード注入は、CSPを正しく設定していても管理者権限経由でバイパスされる可能性があるため、権限レベルでの防御と注入検知の二重防衛が必要です。

### 9.14. The Social Login Security Protocol（ソーシャルログイン設計基準）
*   **Law**: ソーシャルログイン（OAuth 2.0 / OpenID Connect）を実装する際、認証フローの不備はアカウント乗っ取りの温床となります。以下の設計基準を厳守しなければなりません。
*   **Action**:
    1.  **Authorization Code Flow + PKCE 必須**: **Authorization Code Flow with PKCE** を唯一の許可フローとします。Implicit Flow（トークンがURLフラグメントに露出する）の使用は禁止です。
    2.  **CSRF Prevention**: OAuth認証リクエストには必ず `state` パラメータを付与し、コールバック時に照合することでCSRF攻撃を防止してください。
    3.  **Server-Side Token Exchange**: トークンエンドポイントへの通信（`client_secret` を含む）は**サーバーサイドでのみ**実行してください。クライアントサイドでの `client_secret` の露出は厳禁です。
    4.  **Scope Minimization**: 要求スコープは `openid`, `email`, `profile` 等、サービス提供に必要最小限に限定してください。追加スコープの要求は事前レビューと承認を経ること。
    5.  **Explicit Account Link**: 同一メールアドレスのアカウントが既に存在する場合、自動リンクせず**明示的な確認UI**を表示し、ユーザーの意図を確認したうえでアカウントを連携してください。自動マージはアカウント乗っ取りリスクを招きます。
    6.  **Session Verification**: IDプロバイダーから取得したトークンの検証には、署名確認だけでなく `iss`（発行者）、`aud`（対象者）、`exp`（有効期限）の全フィールドを必ず検証してください。
*   **Rationale**: OAuth設定の不備（Implicit Flow、CSRF未対策、スコープ過剰取得等）は、認証基盤そのものの脆弱性となり、全ユーザーのアカウントを危険にさらします。

### 9.15. The Concurrent Session Control Mandate（同時セッション管理義務）
*   **Law**: セッション管理の不備はアカウント乗っ取りや情報漏洩の直接原因となります。セッションライフサイクルの設計は、以下の原則に基づいて行わなければなりません。
*   **Action**:
    1.  **Token Expiration Design**: アクセストークンとリフレッシュトークンの有効期限を適切に設計してください。アクセストークンは短寿命（推奨: 1時間以内）、リフレッシュトークンは中寿命（推奨: 7〜30日）とし、管理画面等の高権限セッションにはより短い有効期限を設定してください。
    2.  **Step-Up Authentication（再認証トリガー）**: パスワード変更、メールアドレス変更、決済情報の閲覧・変更、管理者権限の操作など、高リスクな操作を行う際には、現在のセッションが有効であっても**再認証（Step-Up Auth）**を要求してください。
    3.  **Concurrent Session Policy**: 同一アカウントの同時ログインデバイス数に上限を設け、超過時は最古のセッションを無効化するか、ユーザーに選択させるフローを実装してください。特に管理者アカウントにはより厳格な制限を適用してください。
    4.  **Suspicious Session Detection**: 同一アカウントへの異なるIPアドレスや地理的に離れた地域からの同時アクセスを検出し、ユーザーに通知する仕組みを設計してください。「すべてのデバイスからログアウト」機能の提供を推奨します。
    5.  **Server-Side Invalidation**: ログアウト時にはサーバーサイドでセッションを即時無効化してください。クライアントサイドのトークン削除のみでは不十分であり、サーバーがセッションの有効性を保証する設計が必要です。アカウント停止・削除時には全セッションを即時無効化してください。
*   **Rationale**: セッション管理の甘さは「鍵を差したままの扉」と同義です。トークンの寿命管理、再認証トリガー、同時セッション制御を適切に設計することで、侵害が発生した際の被害範囲を最小化できます。

### 9.16. The Subresource Integrity Mandate (SRI)（外部リソース改竄防止義務）
*   **Law**: CDNやサードパーティから読み込む外部スクリプト・スタイルシートには、改竄検知のための **Subresource Integrity (SRI)** `integrity` 属性を可能な限り付与しなければなりません。
*   **Action**:
    1.  **Integrity Attribute**: CDNから読み込む外部ライブラリの `<script>` および `<link>` タグには、`integrity="sha384-..."` と `crossorigin="anonymous"` 属性を付与し、配信経路でのファイル改竄を検知してください。
    2.  **Third-Party Script Inventory**: サイトに読み込まれる全外部スクリプト（Analytics、CAPTCHA、広告タグ、決済SDK等）の一覧を管理し、各スクリプトの**目的・リスク・CSP設定**を文書化してください。未承認のスクリプトの追加を禁止します。
    3.  **Review Obligation**: 新しいサードパーティスクリプトの追加時には、セキュリティレビューを実施し、そのスクリプトが要求するブラウザAPIやネットワークアクセスを確認したうえで承認してください。
*   **Rationale**: CDN侵害やサプライチェーン攻撃により外部スクリプトが改竄された場合、SRIがなければ改竄されたコードがそのまま全ユーザーのブラウザで実行されます。SRIは「最後の検問」として機能し、改竄を物理的に検知・遮断します。

## 10. 委託先セキュリティ管理 (The Vendor Security Management Protocol)

### 10.1. 委託先セキュリティ評価基準 (Vendor Security Assessment Standards)
*   **Law**: 外部委託先（SaaS、IaaS、業務委託先等）の選定・契約時には、自社のセキュリティ基準を満たしていることを事前に評価しなければなりません。
*   **Mandate**:
    *   **選定時チェックリスト**: 新規委託先との契約前に、以下の項目を評価してください。

        | 評価カテゴリ | チェック項目 | 最低要件 |
        |:---------|:--------|:--------|
        | **認証・認定** | ISO 27001 / SOC 2 Type II等の取得状況 | いずれか1つ以上 |
        | **データ暗号化** | 保存時・転送時の暗号化方式 | AES-256 + TLS 1.2以上 |
        | **アクセス制御** | RBAC、多要素認証の実装状況 | 管理者アカウントはMFA必須 |
        | **インシデント対応** | インシデント対応計画の有無と通知時間 | 24時間以内の初期通知 |
        | **データ保管場所** | データセンターの所在地 | サービス利用地域と同一リージョン |
        | **バックアップ・DR** | バックアップ頻度とリカバリ体制 | 日次バックアップ + RTO 24時間以内 |

    *   **リスク等級分類**: 委託先を取り扱うデータの機密度に応じて以下のリスク等級に分類し、等級に応じた管理強度を適用してください。
        *   **High**: PII・決済データ・認証情報を扱う委託先 → 年次監査 + SLA必須
        *   **Medium**: 業務データ・分析データを扱う委託先 → 年次自己評価 + SLA推奨
        *   **Low**: 公開情報のみ扱う委託先 → 初回評価のみ

### 10.2. 委託先SLAテンプレート (Vendor SLA Template)
*   **Law**: セキュリティに関わる委託先とは、以下の項目を含むSLA（Service Level Agreement）を締結しなければなりません。
*   **SLA必須項目**:

    | SLA項目 | 推奨基準 | 違反時の対応 |
    |:--------|:--------|:-----------|
    | **可用性** | 99.9%以上（月間） | クレジット返金 or ペナルティ条項 |
    | **インシデント通知** | 発覚から24時間以内の初報 | 契約違反として記録 |
    | **データ復旧** | RPO 24時間以内 / RTO 4時間以内 | エスカレーション + 代替策検討 |
    | **セキュリティパッチ適用** | Critical: 72時間以内 / High: 2週間以内 | 改善計画の提出要求 |
    | **監査協力** | 年1回の監査受入義務 | 拒否の場合は契約見直し |

### 10.3. サブプロセッサー管理 (Sub-Processor Management)
*   **Law**: 委託先がさらに第三者（サブプロセッサー）にデータ処理を再委託する場合、委託元への事前通知と承認が必要です。
*   **Mandate**:
    *   **事前通知義務**: 委託先は新たなサブプロセッサーの利用開始**30日前**までに委託元へ通知しなければなりません。
    *   **同等条件の義務付け**: サブプロセッサーに対しても、委託先と同等のセキュリティ・プライバシー条件を契約上義務付けてください。
    *   **チェーン制限**: サブプロセッサーからのさらなる再委託（孫委託）は**原則禁止**とします。やむを得ない場合は個別承認が必要です。
    *   **リスト管理**: 委託先が利用する全サブプロセッサーのリスト（会社名、所在地、処理内容）を維持・更新し、委託元に開示する義務を契約に含めてください。
*   **Rationale**: GDPR Art.28(2)はサブプロセッサーの事前承認を求めており、APPI改正も再委託先の監督義務を強化しています。委託先チェーンの可視化・管理なくしてデータ保護は実現しません。

