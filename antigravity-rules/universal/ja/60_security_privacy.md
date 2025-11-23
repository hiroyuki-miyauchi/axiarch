# 60. Security & Privacy (CISO & Legal View)

## 1. Privacy by Design (GDPR/CCPA Standard)
*   **Data Minimization**:
    *   「念のため取得する」は禁止。ビジネスに真に必要なデータのみを収集する。
    *   個人情報（PII）は可能な限り匿名化・仮名化して保存する。
*   **User Sovereignty**:
    *   ユーザーが自分のデータを「閲覧」「エクスポート」「完全に削除」できる機能を、MVP段階から実装する。
    *   「退会」は「入会」と同じくらい簡単でなければならない（Dark Patternsの禁止）。

## 2. Security Architecture (Zero Trust)
*   **Authentication & Authorization**:
    *   自前で認証基盤を作らない。Firebase AuthやAuth0などの検証済みソリューションを使用する。
    *   MFA（多要素認証）を管理者権限を持つアカウントに強制する。
*   **Supply Chain Security**:
    *   使用するライブラリは信頼性を確認し、定期的に `npm audit` 等で脆弱性をスキャンする。
    *   不審なパッケージやメンテナンスされていないライブラリは使用しない。

## 3. Infrastructure Security (Defense in Depth)
*   **Network Security**:
    *   **VPC**: バックエンドサービスはプライベートVPC内に隔離する。データベースをインターネットに直接公開しない。
    *   **Cloud Armor**: DDoSや一般的なWeb攻撃から保護するためにWAFを使用する。
*   **App Check**: リクエストが真正なアプリから来ていることを保証するために、Firebase App Checkを強制する。

## 3. Offensive Security (Red Team Mindset)
*   **Self-Penetration Testing**:
    *   開発者は「攻撃者」の視点を持ち、自分のコードに対してSQLインジェクションやXSS（クロスサイトスクリプティング）を試みる思考実験を行う。
    *   FirestoreのSecurity Rulesは、「誰でも読み書きできる」状態からスタートせず、「誰も何もできない」状態から必要な権限だけを付与する（Allowlist方式）。

## 4. Incident Response
*   **Assume Breach**:
    *   「侵入されること」を前提に設計する。侵入された場合、被害を最小限に抑えるためのネットワーク分離や権限分離を行う。
    *   ログは改ざん不可能な場所に保存し、異常検知のアラートを設定する。
