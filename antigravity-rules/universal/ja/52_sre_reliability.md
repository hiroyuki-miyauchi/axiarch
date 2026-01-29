# 52. SREと信頼性エンジニアリング (SRE & Reliability Engineering)

## 1. カオスエンジニアリング (Chaos Engineering - "Embrace Failure")
*   **原則**: 「システムは必ず壊れる」という前提に立ち、意図的に障害を注入して回復力をテストします。
*   **Chaos Monkey**:
    *   **ステージング環境**: ステージング環境では、ランダムにAPIを遅延させたり、Podを強制終了させる「カオス」を定期的に実行し、システムの自己修復能力を検証します。
    *   **本番環境**: 成熟度が上がった段階で、本番環境でのGame Day（避難訓練）を実施します。

## 2. デプロイメント戦略 (Deployment Strategy)
*   **Supreme Directive: The Automated Deployment Mandate (CD First Protocol)**:
    *   **Law**: 本番環境（Production）へのデータベース変更およびアプリケーションデプロイは、**いかなる場合も開発者の手動コマンド（ローカル端末からの `supabase db push` 等）で行ってはなりません。**
    *   **Prohibition**: 「手動デプロイ（Manual Deploy）」は、オペミスを誘発し履歴の不整合を招く「エンジニアリングの自殺行為」です。
    *   **Action**: デプロイは必ず **「検証されたコード（Pull Request）」** が **「信頼されたパイプライン（GitHub Actions）」** を通過した結果として、自動的に実行されなければなりません。
*   **ブルー/グリーンデプロイメント**:
    *   新旧の環境を並行稼働させ、トラフィックを瞬時に切り替えることで、ダウンタイムゼロのリリースを実現します。
*   **カナリアリリース**:
    *   新機能を一部のユーザー（例: 社員のみ、1%のユーザー）にのみ公開し、問題がないことを確認してから全ユーザーに展開します。
    *   デプロイ失敗時、ボタン1つで即座に前のバージョンに戻せる（Rollback）状態を常に維持します。
*   **The Gatekeeper Protocols (Zero Tolerance Mandate)**:
    *   **Linter Zero Tolerance**: CIにおいて `Warning` を許容しません。`eslint --max-warnings=0` を義務付けます。
    *   **Husky Guard (Universal Defense)**: サーバーサイドの保護にかかわらず、`husky` による `pre-push` フックでの防御を全リポジトリで義務化します。「間違ってプッシュした」を物理的に不可能にします。
*   **The Husky Guard (Universal Defense Mandate)**:
    *   **Law**: 全てのプロジェクトにおいて、**Husky** の導入および `pre-push` フックによる `main` (および `master`) ブランチへの直接プッシュ禁止設定を **義務（Universal Mandate）** とします。「気をつける」という心理的運用は無意味であり、コードによる物理的な防衛線のみを信頼します。
    *   **Action**: プロジェクト初期化時に必ずガードレールを設置せよ。サーバーサイドの保護（Branch Protection）に頼らず、防衛線を二重化することを最高義務とします。
*   **The Branch Hygiene Mandate (Clean Up After Yourself)**:
    *   **Law**: 作業ブランチを放置することは環境差異による事故の元です。「マージされたら削除」はエンジニアの呼吸です。
    *   **Action**: タスク完了報告（Final Notify）の直前に、必ず `git branch --merged` を確認し、マージ済みのローカル作業ブランチを自動的に削除してください。

## 3. 互換性マトリクス (Compatibility Matrix - "Zero Tolerance")
*   **ブラウザ (Browsers)**:
    *   **Tier 1 (完全サポート)**: Chrome (Latest 2), Safari (Latest 2), Edge (Latest 2), Firefox (Latest 2)。これらでのレイアウト崩れや機能不全は**リリースブロッカー**です。
    *   **Tier 2 (動作保証)**: iOS Safari (Latest 2), Android Chrome (Latest 2)。
*   **OSバージョン**:
    *   **iOS**: 最新のメジャーバージョンとその1つ前（例: iOS 17 & 16）。
    *   **Android**: 過去4年以内にリリースされた主要バージョン（例: Android 14, 13, 12, 11）。
*   **実機テスト**:
    *   シミュレーターだけでなく、BrowserStack等を使用して、実際のデバイス（特に低スペックなAndroid端末）での動作を確認します。

## 4. SLI / SLO (Service Level Objectives)
*   **定義**:
    *   **SLI (Indicator)**: 計測すべき指標（例: HTTPリクエストの成功率、レイテンシ）。
    *   **SLO (Objective)**: 目標とする水準（例: 99.9%の可用性）。
    *   **The 99.9% Promise**: 月間稼働率 99.9% (停止約43分以内) を目標とし、計画メンテは72時間前通知を義務付けます。
*   **エラーバジェット (Error Budget)**:
    *   **ポリシー**: エラーバジェットが枯渇した場合、**新機能のリリースを凍結（Feature Freeze）**します。エンジニアリングリソースの100%を信頼性向上に充てます。これは経営陣との合意事項です。

## 5. インシデント管理 (Incident Management)
*   **Blameless Post-mortem (非難なき振り返り)**:
    *   **目的**: 「誰が悪かったか」ではなく「なぜシステムが失敗したか」を追求します。
    *   **ドキュメント**: 重大なインシデント（SEV-1/SEV-2）発生後は、必ずポストモーテム（事後検証レポート）を作成し、再発防止策（Action Items）を合意します。
    *   「DBが消えた時」「APIがダウンした時」などの具体的な対応手順書（Playbook）を事前に用意します。
    *   **The 15-Minute Rule**: 重大障害時は検知から15分以内に一次対応を開始し、4時間以内の復旧を目指します。
*   **オンコール (On-Call)**:
    *   **ローテーション**: 特定の個人に負担が集中しないよう、PagerDuty等を用いてオンコール担当をローテーションします。
    *   **エスカレーション**: 一次対応者が反応しない場合の自動エスカレーションルールを設定します。

## 6. 可観測性 (Observability)
*   **3本の柱**:
    *   **Metrics**: 数値データ（CPU使用率、RPS）。傾向把握に使用。
    *   **Logs**: イベントの詳細記録。デバッグに使用。
    *   **Traces**: リクエストの経路追跡。ボトルネック特定に使用。
    *   これらを統合的に監視できるツール（Datadog, Cloud Monitoring）を導入します。
*   **The Request ID Protocol (Zero Search Time)**:
    *   **Law**: APIレスポンスおよびエラーレスポンスには、必ず追跡用の `requestId` (`x-request-id`) を含めなければなりません。
    *   **Source**: ミドルウェアで生成される `x-nonce` ヘッダーまたはUUID等を信頼できるIDとして採用します。
    *   **Usage**: エラー発生時、ユーザーまたはAIエージェントはこのIDを提示することで、開発者はログから即座に原因を特定できる状態にします（Zero Search Time）。
    *   **Mandate**: このIDはレスポンスヘッダーおよびエラーJSONボディの両方に含めることを推奨します。
*   **The Client Observability Mandate (Frontend Monitoring)**:
    *   **Law**: フロントエンド（Browser）でのスクリプトエラー（Uncaught Exception）やハイドレーションエラーを監視するため、**Sentry** または同等の監視ツールの導入を必須とします。
    *   **Scope**: 本番環境 (`NODE_ENV=production`) でのみ有効化し、開発環境のコンソールを汚染しないこと。
    *   **Outcome**: ユーザーに報告されることなく発生するサイレントエラーを可視化し、品質改善につなげます。
*   **The Health Check Protocol (Liveness Probe)**:
    *   **Law**: 全てのアプリケーションは `/api/health` または `/healthz` エンドポイントを常設し、ロードバランサーやモニタリングツールからの死活監視を受け入れなければなりません。
    *   **Response**: ステータスコード `200 OK` と共に、DB接続状態、キャッシュ接続状態等の基本的なヘルス情報を返すことを推奨します。
*   **The Correlation ID Tracing Protocol (Distributed Tracing)**:
    *   **Law**: 複雑な分散トランザクション（決済処理、AI生成、メール送信等のマルチステップ処理）には、関連ID (`correlation_id`) を付与し、ログを一気通貫で追跡可能にします（OpenTelemetry思想）。
    *   **Scope**: リクエスト起点で生成されたIDを、関連する全てのサービス呼び出し（Edge Function、外部API）に伝播させてください。
    *   **Outcome**: 障害発生時に「どのリクエストが、どのサービスで、どのステップで失敗したか」を即座に特定できる状態を維持します。

## 7. Data Durability (データ耐久性)
*   **RPO / RTO**:
    *   **RPO (Recovery Point Objective)**: **24時間**。毎日バックアップを取得し、最悪でも前日の状態に復元可能にします。
    *   **RTO (Recovery Time Objective)**: **2時間**。バックアップからのリストア手順を確立し、2時間以内にサービス再開を目指します。
*   **The Fire Drill Protocol (避難訓練義務)**:
    *   **Mandate**: 四半期に1回、実際にバックアップからのリストアを行い、正常稼働を確認する「復旧訓練」を義務付けます。未検証のバックアップは「存在しない」と見なします。
*   **The Off-Site Backup Mandate**:
    *   **Risk**: クラウドプロバイダ自体の障害やアカウント凍結による全データ消失。
    *   **Mandate**: メインDBの自動バックアップに加え、外部ストレージ（S3/R2等）への定期的な論理バックアップ転送を義務付け、「ノアの方舟」運用を行います。


## 8. 保守とレジリエンス (Maintenance & Resilience)
*   **メンテナンスモード (Maintenance Mode)**:
    *   **Switch**: メンテナンス状態はDB設定（`site_settings`）で管理し、MiddlewareとServer Actionsの両方でチェックします。裏口からの書き込みを物理的にブロックします。
*   **Circuit Breaker**:
    *   外部API呼び出しにはタイムアウトを設定し、障害時はデフォルト値を返します（Fail Safe）。
*   **Job Queue**:
    *   メール送信や画像解析などの重い処理は、APIレスポンスサイクルから切り離し、**Supabase Edge Functions + pgmq** で非同期実行します。

### 8.1. The IPv6 Deployment Protocol (Connection Hygiene)
*   **Context**: GitHub Actions 等のCI環境とSupabase間の接続において、IPv6名前解決の問題による接続エラーを防ぐための適切な構成を義務付けます。
*   **Action**:
    *   **Official Link**: `supabase link` を使用し、Connection Pooler等の適切な経路を確立してください。`gai.conf` によるOSハックは脆弱性です。
    *   **Auth Token**: CI環境での認証には、プロジェクトAPIキーではなく、必ず **Personal Access Token (PAT)** を使用してください（`SUPABASE_ACCESS_TOKEN`）。トークン名は `GitHub Actions CI` とし、漏洩時の影響範囲を限定してください。

### 8.2. The Lockfile Integrity Protocol (Lockfile Sanctuary)
*   **Law**: `package-lock.json` (または `pnpm-lock.yaml`, `yarn.lock`) は依存関係の整合性を担保する「聖域」です。CI における "Context Deadline Exceeded" や "Missing from lock file" エラーは、Lockfile の不整合が原因の 9 割を占めます。
*   **Action**: CI で依存関係エラーに遭遇したら、調査に時間を浪費せず、即座に **Lockfile および `node_modules` を削除し、`npm install` を再実行して Lockfile を新規生成してプッシュ** せよ。これが最短かつ唯一の正解です。

### 8.3. The Environment Verification Protocol (Connection Check)
*   **Law**: データベース接続エラー発生時は、解決策を提示する前に必ず `.env.local` の `NEXT_PUBLIC_SUPABASE_URL` を確認し、**「現在どこに繋ごうとしているか（Target）」** を特定することを義務付けます。
*   **Anti-Pattern**: エラーメッセージ（症状）だけで判断し、「Dockerが落ちている」と推測でユーザーに指示することは禁止です。実際はリモートに繋ごうとしているケースが大半です。
