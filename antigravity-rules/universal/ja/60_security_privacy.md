# 60. セキュリティとプライバシー (Security & Privacy - CISO & Legal View)

## 1. プライバシー・バイ・デザイン (Privacy by Design - GDPR/CCPA Standard)
*   **データ最小化 (Data Minimization)**:
    *   「念のため取得する」は禁止です。ビジネスに真に必要なデータのみを収集します。
    *   個人情報（PII）は可能な限り匿名化・仮名化して保存します。
*   **ユーザーの権利 (User Rights - GDPR/CCPA)**:
    *   **忘れられる権利 (Right to be Forgotten)**: ユーザーが「退会」を選択した場合、関連する全ての個人データ（バックアップ含む）を物理的に削除、または匿名化するプロセスを自動化します。
    *   **データポータビリティ (Data Portability)**: ユーザーが自分のデータを機械可読形式（JSON/CSV）でダウンロードできる機能を提供します。
*   **Cookie同意 (Cookie Consent)**:
    *   必須ではないCookie（マーケティング、分析）については、ユーザーの明示的な同意（Opt-in）を得ます。

## 2. セキュリティ・アーキテクチャ (Security Architecture - Zero Trust & OWASP)
*   **認証と認可 (Authentication & Authorization)**:
    *   自前で認証基盤を作りません。Firebase AuthやAuth0などの検証済みソリューションを使用します。
    *   **MFA (多要素認証)**: 管理者権限を持つアカウントには多要素認証（MFA）を強制します。
*   **OWASP Top 10 対策 (OWASP Top 10 Mitigation)**:
    *   **インジェクション (Injection)**: SQL/NoSQLインジェクションを防ぐため、ORMやパラメータ化されたクエリのみを使用します。文字列連結によるクエリ構築は禁止です。
    *   **アクセス制御の不備 (Broken Access Control)**: 全てのAPIエンドポイントで、リクエスト元ユーザーがそのリソースにアクセスする権限を持っているか厳密にチェックします（Firestore Security Rules / RLS）。
    *   **XSS (クロスサイトスクリプティング)**: ユーザー入力をそのままHTMLとしてレンダリングしません。フレームワーク（React/Flutter）のデフォルトのエスケープ機能を信頼します。

## 3. インフラセキュリティ (Infrastructure Security - Defense in Depth)
*   **ネットワークセキュリティ (Network Security)**:
    *   **VPC**: バックエンドサービスはプライベートVPC内に隔離します。データベースをインターネットに直接公開しません。
    *   **Cloud Armor**: DDoSや一般的なWeb攻撃から保護するためにWAFを使用します。
*   **App Check**: リクエストが真正なアプリから来ていることを保証するために、Firebase App Checkを強制します。

## 4. 攻撃的セキュリティ (Offensive Security - Red Team Mindset)
*   **セルフ・ペネトレーションテスト (Self-Penetration Testing)**:
    *   開発者は「攻撃者」の視点を持ち、自分のコードに対してSQLインジェクションやXSS（クロスサイトスクリプティング）を試みる思考実験を行います。
    *   FirestoreのSecurity Rulesは、「誰でも読み書きできる」状態からスタートせず、「誰も何もできない」状態から必要な権限だけを付与します（Allowlist方式）。

## 5. インシデント対応 (Incident Response)
*   **侵害の前提 (Assume Breach)**:
    *   「侵入されること」を前提に設計します。侵入された場合、被害を最小限に抑えるためのネットワーク分離や権限分離を行います。
    *   ログは改ざん不可能な場所に保存し、異常検知のアラートを設定します。
