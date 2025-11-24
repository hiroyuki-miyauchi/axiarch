# 300. 分析インテリジェンスとオブザーバビリティ (Analytics Intelligence & Observability)

## 1. 課題抽出の自動化 (Automated Issue Extraction)
*   **クラッシュレポート (Crash Reporting)**:
    *   **Crashlytics / Sentry**: 全ての環境に導入します。
    *   **自動起票**: ユーザーの1%以上に影響するクリティカルなクラッシュは、自動的に課題管理ツール（Jira/GitHub Issues）に「最高優先度」で起票されるワークフローを構築します。
*   **UXフリクション検知 (UX Friction Detection)**:
    *   **Rage Taps (イライラ連打)**: ユーザーが同じ箇所を何度も連打している動作を検知し、UIの欠陥（反応しないボタン、わかりにくいUI）として記録します。
    *   **Dead Clicks (無効クリック)**: インタラクティブでない要素へのクリックを追跡し、ユーザーが誤解しているUIパターンを特定します。

## 2. オブザーバビリティ (Observability - The "Why")
*   **分散トレーシング (Distributed Tracing)**:
    *   **OpenTelemetry**: フロントエンドからバックエンド、データベースに至るまでのリクエストを一気通貫で追跡（Trace）できるようにします。「どこで遅くなったか」を即座に特定します。
*   **パフォーマンス監視 (Performance Monitoring)**:
    *   **リアルタイム監視**: TTI (Time to Interactive) や APIレイテンシをリアルタイムで監視し、閾値を超えた場合はSlack等にアラートを通知します。

## 3. プライバシーファースト分析 (Privacy-First Analytics)
*   **PIIの送信禁止 (No PII)**:
    *   **厳禁**: メールアドレス、氏名、電話番号、デバイスID（IDFA/GAID）などの個人特定情報（PII）を分析プラットフォームに送信することは**固く禁じます**。
    *   **ハッシュ化**: ユーザーを識別する必要がある場合は、ソルト付きハッシュIDを使用します。
*   **同意管理 (Consent Management)**:
    *   **GDPR / APPI**: ユーザーのCookie同意ステータス（Do Not Track）を厳格に尊重します。同意がない場合、分析スクリプト自体をロードしません。
