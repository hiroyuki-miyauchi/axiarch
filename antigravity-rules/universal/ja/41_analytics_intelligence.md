# 300. 分析インテリジェンスとオブザーバビリティ (Analytics Intelligence & Observability)

## 1. 行動分析 (Behavioral Analytics - "Amplitude First")
*   **イベント設計 (Event Taxonomy)**:
    *   **アクションベース**: 「ページを見た (Page Viewed)」ではなく「購入ボタンを押した (Clicked Purchase)」「チュートリアルを完了した (Completed Tutorial)」という**ユーザーの意図**を記録します。
    *   **プロパティ**: イベントには必ずコンテキスト（例: `source: "banner_A"`, `item_count: 3`）を付与し、分析の解像度を高めます。
*   **コホート分析 (Cohort Analysis)**:
    *   **リテンション**: 「機能Aを使ったユーザー」と「使わなかったユーザー」の翌週継続率（Retention Rate）を比較し、プロダクトの**マジックナンバー**（例: 「7人フォローすると定着する」）を特定します。

## 2. 実験とA/Bテスト (Experimentation & A/B Testing)
*   **実験文化 (Culture of Experimentation)**:
    *   **ルール**: 新しい主要機能は、必ず**Feature Flag**（LaunchDarkly / Firebase Remote Config）でラップし、段階的にリリースします。
    *   **仮説検証**: 「何となくリリース」は禁止です。必ず「仮説（Hypothesis）」「成功指標（Success Metric）」「ガードレール指標（Guardrail Metric - 例: 解約率が増えないか）」を定義してからテストを開始します。
*   **統計的有意差 (Statistical Significance)**:
    *   結果の判定には、95%以上の信頼区間（Confidence Interval）を使用し、偶然のブレを排除します。

## 41. アナリティクスとインテリジェンス (Analytics & Intelligence)
*   **North Star Metric (NSM)**:
    *   **定義**: プロダクトの長期的価値を最も的確に表す「たった一つの指標」を定義します（例: Spotifyなら「総再生時間」、Airbnbなら「予約泊数」）。
    *   **全社共有**: エンジニアからCSまで、全員がこのNSMを向上させるために動きます。
*   **ファネル分析 (Funnel Analysis)**:
    *   サインアップから課金、主要機能の利用までの離脱ポイントを可視化し、ボトルネックを特定します。

## 4. 課題抽出の自動化 (Automated Issue Extraction)
*   **クラッシュレポート (Crash Reporting)**:
    *   **Crashlytics / Sentry**: 全ての環境に導入します。
    *   **自動起票**: ユーザーの1%以上に影響するクリティカルなクラッシュは、自動的に課題管理ツール（Jira/GitHub Issues）に「最高優先度」で起票されるワークフローを構築します。
*   **UXフリクション検知 (UX Friction Detection)**:
    *   **Rage Taps (イライラ連打)**: ユーザーが同じ箇所を何度も連打している動作を検知し、UIの欠陥（反応しないボタン、わかりにくいUI）として記録します。
    *   **Dead Clicks (無効クリック)**: インタラクティブでない要素へのクリックを追跡し、ユーザーが誤解しているUIパターンを特定します。

## 5. オブザーバビリティ (Observability - The "Why")
*   **分散トレーシング (Distributed Tracing)**:
    *   **OpenTelemetry**: フロントエンドからバックエンド、データベースに至るまでのリクエストを一気通貫で追跡（Trace）できるようにします。「どこで遅くなったか」を即座に特定します。
*   **パフォーマンス監視 (Performance Monitoring)**:
    *   **リアルタイム監視**: TTI (Time to Interactive) や APIレイテンシをリアルタイムで監視し、閾値を超えた場合はSlack等にアラートを通知します。
    *   **Core Web Vitals**: LCP, FID, CLSのスコアを継続的に計測し、SEOやUXへの悪影響を未然に防ぎます。

## 6. プライバシーファースト分析 (Privacy-First Analytics)
*   **PIIの送信禁止 (No PII)**:
    *   **厳禁**: メールアドレス、氏名、電話番号、デバイスID（IDFA/GAID）などの個人特定情報（PII）を分析プラットフォームに送信することは**固く禁じます**。
    *   **ハッシュ化**: ユーザーを識別する必要がある場合は、ソルト付きハッシュIDを使用します。
*   **同意管理 (Consent Management)**:
    *   **GDPR / APPI**: ユーザーのCookie同意ステータス（Do Not Track）を厳格に尊重します。同意がない場合、分析スクリプト自体をロードしません。
