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
*   **The Preview Environment Evacuation Protocol (Abandon, Don't Repair)**:
    *   **Trigger**: Preview環境（ブランチDB等）でマイグレーション履歴の致命的な不整合が発生した場合。
    *   **Law**: 使い捨て環境の整合性を修復するために時間を浪費してはなりません。即座に当該環境を放棄し、新しいブランチ（例: `fix/fresh-start-xxx`）を作成して移行してください。
    *   **Rationale**: Preview環境は「使い捨て前提」で設計されています。修復コストは常に再作成コストを上回ります。

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
*   **API Performance Threshold (The Response Time Standard)**:
    *   **Target**: APIレスポンスは **100ms以内** を目標とします。
    *   **Warning**: 1000msを超えるリクエストはログレベル `warn` で自動記録し、継続的に遅延が観測される場合はキャッシュ戦略またはクエリ最適化を検討してください。

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

### 8.4. The Unified Observability Protocol (統合可観測性)
*   **Law**: ログ、トレース、監査ログが分断された状態では、障害の根本原因を特定するのに膨大な時間を浪費します。
*   **Action**:
    1.  **Trace ID Everywhere**: 全てのリクエストにトレースID（`x-request-id` / `correlation_id`）を付与し、ログ・エラー・監査ログに一貫して含めてください。
    2.  **Structured Logging**: ログは人間向けの平文ではなく、**JSON形式（構造化ログ）**で出力してください。これにより、ログ集約ツール（Datadog, Loki等）での検索・フィルタリングが飛躍的に向上します。
    3.  **PII Masking**: 構造化ログに個人情報（メール、電話番号、トークン等）を含めることは禁止です。Loggerレベルで自動マスキング（`***MASKED***`）を実装してください。
    4.  **Bi-Directional Trace**: 監査ログ（`audit_logs`）にもトレースIDを記録し、「この操作は、このリクエストの一部として実行された」という双方向の追跡を可能にしてください。
    5.  **Log Level Standard**: ログレベルは以下の基準で厳格に運用してください。
        *   `error`: 例外発生、回復不能な状態 — 本番で常時出力。
        *   `warn`: 非推奨使用、パフォーマンス懸念 — 本番で常時出力。
        *   `info`: 重要なビジネスイベント（登録完了、決済成功等） — 本番で常時出力。
        *   `debug`: 開発用詳細情報 — 本番では**無効化**。
    6.  **Canonical Log Lines**: リクエスト終了時に、メソッド・パス・ステータスコード・処理時間・DBクエリ数・キャッシュヒット有無を含む**1行の集約ログ**を出力してください。これにより、リクエストの全体像を1行で把握可能にし、分析・デバッグを高速化します。
*   **Outcome**: 「このエラーは、どのユーザーの、どのリクエストで、どのサービスで、なぜ起きたか」を60秒以内に特定できる状態を維持します。

### 8.5. The Code-Not-Policy Mandate（コード化強制原則）
*   **Law**: 人間の「約束」や「運用ルール」は必ず破られます。ルールの実効性を担保するには、**コード化された物理的制約（CI、Git Hook、自動チェックスクリプト）** でなければなりません。
*   **Action**:
    1.  **Automate Enforcement**: 「〜してはならない」というルールは、CIパイプラインに自動チェック（違反時 `Exit 1`）を実装してください。Wikiやドキュメントに書くだけでは不十分です。
    2.  **Git Hooks**: ローカル開発環境でも、`pre-commit` / `pre-push` フックで最低限のチェック（Lint、型チェック、禁止ブランチへのPush防止）を強制してください。
    3.  **Physical Impossibility**: 理想は「違反が物理的に不可能な設計」です。例えば、環境変数のバリデーションをアプリ起動時に行い、未設定なら起動しないようにしてください。
*   **Rationale**: ドキュメントベースの運用ルールは「誰かが読む」前提に立っており、その前提は常に裏切られます。コードによる強制だけが信頼できる防衛線です。

### 8.6. The Enterprise Audit Traceability Mandate（監査追跡義務）
*   **Law**: 破壊的操作（削除、更新、権限変更、認証イベント等）には、**「誰が・いつ・何を・どのように変更したか」** を記録する監査ログの計装を義務付けます。
*   **Action**:
    1.  **All Destructive Operations**: データの作成・更新・削除、認証状態の変更（ログイン・ログアウト・OTP検証等）、権限の変更には必ず監査ログを記録してください。
    2.  **Before/After**: 変更前後の状態を記録し、差分を追跡可能にしてください。
    3.  **Correlation**: 監査ログにトレースIDを含め、リクエスト全体の文脈から操作を追跡可能にしてください。
    4.  **Human-Readable Labels**: 監査ログの操作名は、非エンジニアの管理者が理解できるラベル（運用者の母国語）で表示してください。
*   **Rationale**: 「誰が変更したかわからない」状態は、複数管理者環境において「無実の証明」も「不正の検知」も不可能にします。これはセキュリティ上の重大な欠陥です。

### 8.7. The Fail-Fast Configuration Mandate（Fail-Fast設定義務）
*   **Law**: アプリケーション起動時に、全てのクリティカルな環境変数（APIキー、DBクレデンシャル、暗号化キー等）の **存在と形式を検証** し、不足・不正の場合はプロセスを即座に終了（Crash）させなければなりません。
*   **Action**:
    1.  **No Silent Fallbacks**: デフォルト値（`|| ''`, `?? 'default'`）によるサイレントなフォールバックはクリティカルな設定項目に対して禁止です。空文字列へのフォールバックは、実行時に不可解な権限エラーやサイレントな書き込み失敗の温床となります。
    2.  **Startup Validation**: `validateConfig()` 等のガード関数をアプリケーション起動時に実行し、必須項目の欠落を即座にクラッシュ（`process.exit(1)`）させてください。
    3.  **Hard Reset Protocol**: 環境変数に関連する疑わしい挙動（権限エラー、サイレント失敗等）が発生した際は、`.env` の記述を確認するだけでなく、**開発サーバープロセスを物理的に終了し、クリーンな状態で再起動**してください。多くのフレームワークは `.env` の変更をホットリロードしません。
    4.  **Diagnostic Logging**: デバッグ時、機密値そのものではなく「キーの長さ」「設定の有無（boolean）」を個別の変数としてログ出力し、自動マスキングの影響を回避してください。
*   **Rationale**: 環境変数の欠落は、アプリケーションを「見た目は正常だが権限が不足した状態」で実行させます。特に特権クライアント用のキーが欠落した場合、書き込みが全てサイレントに拒否される「Phantom Success」を引き起こし、原因特定に膨大な時間を浪費します。

### 8.8. The Decomposition-Based Triage Protocol（分解ベーストリアージ）
*   **Law**: 大規模な変更（複数ファイルにまたがるリファクタリング、セキュリティ強化等）の後に不具合が発生した場合、一斉ロールバックではなく、**機能グループごとの段階的ロールバック**で最小再現単位を特定しなければなりません。
*   **Action**:
    1.  **Isolation by Decomposition**: 複数ファイルを修正した後の不具合は、まず「最も疑わしいUIコンポーネント」をロールバックし、次に「サーバーサイドの変更」を機能グループごとに段階的にロールバックして、原因の所在を絞り込んでください。
    2.  **The "Stash & Verify" Tactic**: 部分的なロールバックで解決しない場合、`git stash` を用いて作業ディレクトリを完全にクリーンな状態（前回のコミット）に戻し、不具合が「今回の変更によるデグレード」なのか「以前から潜んでいた潜在バグ」なのかを確定させてください。
    3.  **Atomic Verification**: 各段階のロールバック後に必ず開発サーバーを再起動し、ビルドキャッシュをクリアした上で動作確認を行ってください。キャッシュの残留による誤判定を防いでください。
    4.  **Server Log Sovereignty**: UI上の不具合がサーバーサイド起因かクライアントサイド起因かを判別するため、サーバーログ（HTTPステータス、エラースタック）を一次情報源として活用してください。全リクエストが `200 OK` であれば、原因はクライアントサイドに限定できます。
*   **Rationale**: 大規模変更の一斉適用は「影響範囲の爆発（Blast Radius）」を引き起こし、どのファイルのどの変更が不具合の原因かの特定を著しく困難にします。特にフロントエンドのライフサイクル（React Hook, useEffect等）とバックエンドの変更が交差する場合、段階的な分解なしでは原因切り分けが事実上不可能です。

### 8.9. The Post-Change Cache Reset Protocol（変更後キャッシュリセット義務）
*   **Law**: アプリケーションのコアクエリロジック（フィルタ条件、データ取得仕様）、可視性ガード（RLSポリシー関連）、または環境変数を変更した場合、検証前に**開発サーバーの強制終了とクリーンリスタート**を行うことを義務化します。
*   **Action**:
    1.  **Kill and Restart**: 変更のテスト前に、開発サーバープロセスを確実に終了し（`lsof -ti:<port> | xargs kill -9` 等）、クリーンな状態で再起動してください。「保存してリロード」だけでは、フレームワークのキャッシュが古い結果を返し続ける場合があります。
    2.  **Cache Purge**: フレームワーク固有のキャッシュディレクトリ（`.next/cache`, `node_modules/.cache` 等）を物理的に削除してから再起動することを推奨します。
    3.  **Env Reload**: 環境変数（`.env` ファイル）の変更は、多くのフレームワークでホットリロードされません。変更後は必ずプロセスの完全再起動が必要です。
    4.  **False Negative Prevention**: キャッシュの残留は「変更が反映されていない」という偽陰性（False Negative）を生み、正しい変更を誤って「効果なし」と判定する原因となります。
*   **Rationale**: モダンなWebフレームワーク（Next.js等）は複数段のキャッシュ（Data Cache、Router Cache、ビルドキャッシュ）を持ち、開発時であっても古い結果を提供することがあります。特にRLSポリシーの変更やService層のクエリ修正は、キャッシュをリセットしない限り反映が確認できず、不要なデバッグ時間を浪費します。

### 8.10. The Schema-Code Synchronization Sovereignty（スキーマ-コード同期主権）
*   **Law**: アプリケーションコードが「Zero Defects（型チェック・ビルド・リント全通過）」であっても、**データベーススキーマ（マイグレーション）が本番/ステージング環境に未適用**の場合、システムは正常に動作しません。コードとスキーマの両方が同期して初めて「Zero Defects」が成立することを認識しなければなりません。
*   **Action**:
    1.  **Migration Status Check**: デプロイ前およびデバッグ時に、`migration list` や `migration status` コマンドで未適用のマイグレーションがないことを確認してください。
    2.  **Schema Drift Detection**: 型定義（`database.types.ts` 等の自動生成型）が参照するカラムやテーブルが、実際のデータベースに物理的に存在することを検証してください。型の存在は物理的存在を保証しません。
    3.  **Deploy Pipeline Integration**: CI/CDパイプラインにおいて、マイグレーション適用をコードデプロイの**前提条件**として組み込んでください。マイグレーション未適用のままコードがデプロイされると、全クエリが失敗するカタストロフィックな障害が発生します。
    4.  **Error Pattern Recognition**: `column "xxx" does not exist` や `relation "xxx" does not exist` エラーが発生した場合、コードのバグではなく**Schema Drift（スキーマ乖離）**を最初に疑ってください。
*   **Rationale**: TypeScriptの型安全は「コンパイル時の整合性」を保証しますが、「実行時のデータベースとの整合性」は保証しません。自動生成された型定義に存在するカラムが、実際のデータベースに存在しない「Phantom Column」は、型チェックを通過しても実行時にクラッシュする最も診断困難なバグの一つです。
