# 52. SREと信頼性エンジニアリング (SRE & Reliability Engineering)

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

*   **メンテナンスモード (Maintenance Mode)**:
    *   **Switch**: メンテナンス状態はDB設定（`site_settings`）で管理し、MiddlewareとServer Actionsの両方でチェックします。裏口からの書き込みを物理的にブロックします。
*   **Circuit Breaker**:
    *   外部API呼び出しにはタイムアウトを設定し、障害時はデフォルト値を返します（Fail Safe）。
*   **Job Queue**:
    *   メール送信や画像解析などの重い処理は、APIレスポンスサイクルから切り離し、**Supabase Edge Functions + pgmq** で非同期実行します。
