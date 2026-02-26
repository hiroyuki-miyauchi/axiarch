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

### 8.7. The Admin DTO Defense (Strict Output Hygiene)
*   **Law**: 管理画面 (`/admin`) だからといって、全てのDBカラムを無防備にフロントエンドに送信してはなりません。これは将来的に追加される機密カラム（原価、仕入先連絡先、内部メモ）の漏洩を招きます。
*   **Action**: 管理系API (`getAdminUsers` 等) においても、必ず専用の **DTO (`AdminUserDTO` 等)** を定義し、ホワイトリスト方式で必要なフィールドのみを明示的に選択して返却することを義務付けます。`SELECT *` の使用は厳禁です。

### 8.8. The PII Logging Defense (Masking Protocol)
*   **Action**: Loggerクラス内部で、`password`や`token`等のキーワードを含むフィールドを自動的に `***MASKED***` に置換するロジックを実装し、開発者のミスによる流出を防いでください。

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
    *   **Official Link**: `supabase link` を使用し、Connection Pooler等の適切な経路を確立してください。（詳細は 370番台（Backend & Supabase） の Rule 7.2 を参照）

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
