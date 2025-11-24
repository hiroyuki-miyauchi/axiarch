# 60. セキュリティとプライバシー (Security & Privacy - CISO & Legal View)

## 1. 優先順位の鉄則 (The Golden Rule)
*   **Security > Convenience**:
    *   セキュリティと利便性が競合する場合、**100%の確率でセキュリティを優先**します。
    *   **例**: 「オフラインで個人情報を見たい」という要望があっても、端末内暗号化が不十分ならその機能は実装しません。

## 2. プライバシー・バイ・デザイン (Privacy by Design - GDPR/APPI/CCPA)
*   **データ最小化 (Data Minimization)**:
    *   「念のため取得する」は禁止です。ビジネスに真に必要なデータのみを収集します。
    *   個人情報（PII）は可能な限り匿名化・仮名化して保存します。
*   **ユーザーの権利 (User Rights)**:
    *   **忘れられる権利 (Right to be Forgotten)**: ユーザーが「退会」を選択した場合、関連する全ての個人データ（バックアップ含む）を物理的に削除、または匿名化するプロセスを自動化します。
    *   **データポータビリティ (Data Portability)**: ユーザーが自分のデータを機械可読形式（JSON/CSV）でダウンロードできる機能を提供します。
*   **法的コンプライアンス (Legal Compliance)**:
    *   **GDPR (EU)**, **CCPA (California)**, **APPI (Japan)** の各規制を遵守します。
    *   **Cookie同意**: 必須ではないCookie（マーケティング、分析）については、ユーザーの明示的な同意（Opt-in）を得ます。

## 3. セキュリティ・アーキテクチャ (Security Architecture - Zero Trust)
*   **認証と認可 (Authentication & Authorization)**:
    *   自前で認証基盤を作りません。Firebase AuthやAuth0などの検証済みソリューションを使用します。
    *   **MFA (多要素認証)**: 管理者権限を持つアカウントには多要素認証（MFA）を強制します。
    *   **生体認証 (Biometrics)**: モバイルアプリではFaceID/TouchIDを積極的に活用しますが、これは「利便性」のためであり、バックエンドの認証トークン（Refresh Token）の保護とセットで実装します。
*   **OWASP Top 10 対策**:
    *   **インジェクション**: SQL/NoSQLインジェクションを防ぐため、ORMやパラメータ化されたクエリのみを使用します。
    *   **アクセス制御**: 全てのAPIエンドポイントで、リクエスト元ユーザーがそのリソースにアクセスする権限を持っているか厳密にチェックします（Firestore Security Rules / RLS）。

## 4. インフラセキュリティ (Infrastructure Security)
*   **ネットワークセキュリティ**:
    *   **VPC**: バックエンドサービスはプライベートVPC内に隔離します。データベースをインターネットに直接公開しません。
    *   **Cloud Armor**: DDoSや一般的なWeb攻撃から保護するためにWAFを使用します。
*   **App Check**: リクエストが真正なアプリから来ていることを保証するために、Firebase App Checkを強制します。

## 5. ライセンスと規約遵守 (License & ToS Compliance)
*   **ライセンス汚染防止 (License Contamination Prevention)**:
    *   **GPL禁止**: コピーレフト性のあるライセンス（GPL, AGPL）のライブラリは、法的リスクがあるため原則使用禁止とします。MIT, Apache 2.0, BSDなどのパーミッシブライセンスのみを使用します。
    *   **依存関係チェック**: CIパイプラインでライセンススキャンを実行し、違反ライブラリの混入を防ぎます。
*   **プラットフォーム規約 (Platform ToS)**:
    *   **Google/Apple**: スクレイピングや非公開APIの使用など、プラットフォームの利用規約（ToS）に違反する行為は、たとえ技術的に可能でも絶対に行いません。アカウントBANのリスクは事業継続リスクそのものです。

## 6. 攻撃的セキュリティ (Offensive Security)
*   **セルフ・ペネトレーションテスト**:
    *   開発者は「攻撃者」の視点を持ち、自分のコードに対してSQLインジェクションやXSSを試みる思考実験を行います。
    *   FirestoreのSecurity Rulesは、「誰でも読み書きできる」状態からスタートせず、「誰も何もできない」状態から必要な権限だけを付与します（Allowlist方式）。
