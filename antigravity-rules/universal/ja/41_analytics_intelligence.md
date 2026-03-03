# 41. 分析インテリジェンスとオブザーバビリティ (Analytics Intelligence & Observability)

## 1. 行動分析 (Behavioral Analytics - "Amplitude First")
*   **イベント設計 (Event Taxonomy)**:
    *   **アクションベース**: 「ページを見た (Page Viewed)」ではなく「購入ボタンを押した (Clicked Purchase)」「チュートリアルを完了した (Completed Tutorial)」という**ユーザーの意図**を記録します。
    *   **Naming Convention (Snake Case)**:
        *   **Law**: イベント名は全て **スネークケース** (`action_completed`) で統一します。スペースやキャメルケースは禁止です。これはDBカラム名との整合性を保つためです。
    *   **プロパティ**: イベントには必ずコンテキスト（例: `source: "banner_A"`, `item_count: 3`）を付与し、分析の解像度を高めます。
*   **コホート分析 (Cohort Analysis)**:
    *   **リテンション**: 「機能Aを使ったユーザー」と「使わなかったユーザー」の翌週継続率（Retention Rate）を比較し、プロダクトの**マジックナンバー**（例: 「7人フォローすると定着する」）を特定します。

## 2. 実験とA/Bテスト (Experimentation & A/B Testing)
*   **実験文化 (Culture of Experimentation)**:
    *   **ルール**: 新しい主要機能は、必ず**Feature Flag**（LaunchDarkly / Firebase Remote Config）でラップし、段階的にリリースします。
    *   **仮説検証**: 「何となくリリース」は禁止です。必ず「仮説（Hypothesis）」「成功指標（Success Metric）」「ガードレール指標（Guardrail Metric - 例: 解約率が増えないか）」を定義してからテストを開始します。
*   **統計的有意差 (Statistical Significance)**:
    *   結果の判定には、95%以上の信頼区間（Confidence Interval）を使用し、偶然のブレを排除します。
*   **The Experimentation Protocol（実験プロトコル）**:
    *   **Context**: 「感覚」ではなく「データ」に基づく意思決定がプロダクトの成長を決定します。全ての重要なUI/UX変更は実験を通じて検証してください。
    *   **4-Phase Process**:

        | フェーズ | 内容 | 成果物 |
        |:--------|:-----|:------|
        | **1. 仮説** | 「○○を変更すれば、△△が□□%改善する」の形式で仮説を立てる | 実験計画書 |
        | **2. 実験** | Feature Flag を用いてA/B群にトラフィックを分配 | 実装PR |
        | **3. 計測** | 最低**2週間**または**各群1,000セッション**以上のデータを収集 | イベントデータ |
        | **4. 判定** | 統計的有意差（**p < 0.05**）が確認された場合のみ採用 | 判定レポート |

    *   **Experiment Priority（実験対象の優先順位）**:
        *   **必須**: 会員登録フロー、検索UI、主要コンバージョン導線
        *   **推奨**: ランディングページ、CTA文言、メール件名
        *   **不要**: セキュリティ機能、法的準拠UI
    *   **Prohibition（禁止事項）**:
        *   統計的有意差なしでの意思決定（HiPPO問題の回避）
        *   ユーザーに不利益を与える実験（ダークパターン）

## 3. アナリティクスとインテリジェンス (Analytics & Intelligence)
*   **North Star Metric (NSM)**:
    *   **定義**: プロダクトの長期的価値を最も的確に表す「たった一つの指標」を定義します（例: Spotifyなら「総再生時間」、Airbnbなら「予約泊数」）。
    *   **全社共有**: エンジニアからCSまで、全員がこのNSMを向上させるために動きます。
*   **ファネル分析 (Funnel Analysis)**:
    *   サインアップから課金、主要機能の利用までの離脱ポイントを可視化し、ボトルネックを特定します。
*   **The AARRR KPI Framework（AARRR KPI計測フレームワーク）**:
    *   **Context**: 成長を定量的に追跡するため、AARRR（海賊指標）に基づく階層化されたKPIフレームワークを定義します。NSMを頂点に、各階層のKPIを計測してください。
    *   **AARRR Hierarchy**:

        | 階層 | KPI例 | 計測手段 |
        |:-----|:------|:--------|
        | **Acquisition（獲得）** | 月間新規登録者数 | アナリティクス `sign_up` イベント |
        | **Activation（活性化）** | 初回アクション完了率 | アナリティクス `first_action` イベント |
        | **Retention（継続）** | 7日後・30日後リテンション率 | コホート分析 |
        | **Revenue（収益）** | ARPU（ユーザーあたり平均収益） | 決済 + 広告収益 |
        | **Referral（紹介）** | 紹介経由登録率 | Referral Code追跡 |

    *   **GA4 Event Design Standard（イベント設計基準）**:
        *   イベント名は `snake_case` で統一してください（例: `store_detail_view`, `review_submit`）。
        *   カスタムディメンションに `user_type`（例: `guest` / `member` / `admin`）を付与してください。
        *   Eコマースイベントはアナリティクスプラットフォームの推奨スキーマに準拠してください。
    *   **Mandate**: 各階層の目標値はプロジェクト固有のBlueprint側で定義してください。本フレームワークはKPI構造の「型」を提供します。

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
    *   **Core Web Vitals**: **LCP, INP, CLS** のスコアを継続的に計測し、SEOやUXへの悪影響を未然に防ぎます。

## 6. プライバシーファースト分析 (Privacy-First Analytics)
*   **PIIの送信禁止 (No PII)**:
    *   **厳禁**: メールアドレス、氏名、電話番号、デバイスID（IDFA/GAID）などの個人特定情報（PII）を分析プラットフォームに送信することは**固く禁じます**。
    *   **ハッシュ化**: ユーザーを識別する必要がある場合は、ソルト付きハッシュIDを使用します。
*   **同意管理 (Consent Management)**:
    *   **GDPR / APPI**: ユーザーのCookie同意ステータス（Do Not Track）を厳格に尊重します。同意がない場合、分析スクリプト自体をロードしません。

## 7. 分析ダッシュボード品質基準 (Analytics Dashboard Integrity Protocol)

### 7.1. The Dashboard Data Integrity Standard (ダッシュボードデータ整合性基準)
*   **Law**: 分析ダッシュボードの品質メトリクスは、DBスキーマの実カラムに基づいて計測し、スキーマとの乖離を防いでください。
*   **Action**:
    1.  **Schema-Based Metrics**: 品質メトリクスの `IS NOT NULL` チェック等は、実在するカラムに基づいてください。カラムの存在はDB型定義ファイルで確認を義務付けます。
    2.  **DTO-UI Type Alignment**: DTOにフィールドを追加した場合、UI側のDestructure（分割代入）も必ず更新してください。`NaN` / `undefined` / `null` がUIに表示されることはバグとして扱います。
    3.  **Distinct Denominator**: ファネル計算の母数には `distinct` 処理を適用し、重複カウントを防止してください。0除算対策として `total > 0` ガードを必須とします。
    4.  **Tooltip Mandate**: 全てのメトリクス項目にツールチップを付与し、「何を計測しているか」+「なぜ重要か」の2要素で構成してください。専門知識のない運用者でも理解できる言語で記述してください。

