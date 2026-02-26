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

### 8.1. The Double Security Protocol (Rule 0.0: Turnstile + OTP Mandate)
*   **Law**: すべての重要セキュリティ操作（ログイン、登録、PW変更、メール変更、退会等）は、「Managed Turnstile」と「OTP」による2重防御を実装しなければなりません。
*   **Outcome**:
    1.  **Layer 1 (Pre-Auth & Physical Blocking)**: 
        *   **Managed Turnstile** (`appearance: 'always'`) を必須とし、ユーザーに「認証中」であることを可視化してください。
        *   **Physical Lock**: 認証完了（`onSuccess`）のコールバックが発火するまで、送信ボタン（Submit Button）を**物理的に無効化（disabled）**してください。「見えない処理」でユーザーを待たせることはUXの欠陥であり、重大なセキュリティリスクです。
    2.  **Layer 2 (Auth)**: **OTP** (Email/Authenticator) による本人確認を完了させるまで、最終的なデータ変更（UPDATE/DELETE）を許可してはなりません。
    3.  **Fail-Safe Mechanism**: トークン期限切れ（`onExpire`）やエラー時は即座にボタンを無効化し、状態をリセットして再試行を促すフローを構築してください。
    4.  **No Exception**: セキュリティ強固を最優先とし、UX優先の特例は認めないものとします。
    5.  **Scope Limitation**: このプロトコルは日常操作（下書き、表示切替等）ではなく、重大な「重要操作」にのみ適用してください。
    6.  **Security Incentive Program**: MFA設定等の高セキュリティ認証を有効化したユーザーに対し、システム内特典（リライト制限の緩和、高度機能利用権等）を付与する設計を推奨します。「セキュリティは負担ではなくメリット」と体験させてください。

### 8.1.1. The Tiered Security Protocol (段階的セキュリティ)
*   **Law**: セキュリティ強度は操作のリスク（不可逆性・影響範囲）に応じて段階的に適用します。過剰な認証は「無能なシステム」の証明であり、不十分な認証はセキュリティホールを生みます。
*   **Tier Definition**:
    *   **Tier 1 (Mild)**: 一般的な単体削除（メディア、コメント等）、アーカイブ、ステータス変更 → `Turnstile + Keyword Confirmation ("削除"等の入力)` のみ。OTPは不要（UX優先）。
    *   **Tier 2 (Strict)**: 一括削除、フォルダ削除、重要設定変更、**最重要データの単体削除（ユーザー、プラン、決済関連等）** → `Turnstile + Keyword Confirmation + 高セキュリティ認証 (OTP/MFA) 必須`。
*   **Action**: 新機能実装時は、必ず既存類似機能のUI/ロジックを確認し、100%同一の振る舞いを実装してください。「似ているが違う」は整合性を欠くバグです。

### 8.1.2. The Security-UX Balance Protocol（セキュリティ-UXバランス原則）
*   **Law**: 過剰なセキュリティ要求（不要な場面での Turnstile/OTP 要求）は、運用者の生産性を低下させ、最終的にサービス利用率の低下を招きます。セキュリティはUXを犠牲にする免罪符ではありません。
*   **Action**:
    1.  **Critical Actions Only**: Turnstile/OTP 認証は、DB書き込み（Save/Publish/Delete）や重要設定の変更など、「不可逆またはリスクの高い操作」の最終段階でのみ要求してください。
    2.  **No UI Friction**: モーダルを開く、タブを切り替える、ファイルを選択する（アップロード前）といった「探索・中間操作」において認証を挟むことを**厳禁**とします。
    3.  **Context Awareness**: すでに認証済みのセッション内で行う軽微な操作に対し、再認証を強いることは「信頼の欠如」であり、システム設計の欠陥とみなします。
*   **Rationale**: ユーザーに過剰な認証を繰り返し要求するシステムは、結果として認証疲れ（Security Fatigue）を誘発し、ユーザーが本当に重要な認証を軽視する逆効果を生みます。

### 8.2. The Audit Log Obligation (No Invisible Hands)
    *   **The Audit Log Obligation**: 監査ログを経由しないDB書き込みはセキュリティ上の死角です。重要な操作（作成・更新・権限変更）は、`actor_id`, `action`, `resource`, `details` を含む所定のスキーマで記録してください。
    *   **The Privileged Data Access Audit (High-Sensitivity Mandate)**:
        *   **Context**: ユーザー本人以外の第三者（運営スタッフ、提携専門家等）が、ユーザーの機密データや高秘匿記録（健康、資産、身分証明等）を閲覧する場合、それは「信頼の預かり」であり、最大の責任を伴います。
        *   **Law**: 高秘匿ドメインのリソースに対し、第三者による **参照（SELECT）** が行われる場合は、必ず **「閲覧理由 (Reason)」** の入力を物理的に強制し、履歴を記録してください。
        *   **Retention**: この全閲覧監査ログは、不正閲覧への強力な抑止力および説明責任の証跡として **永久保存 (Permanent Retention)** を義務付けます。
    *   **The Immutable Log Mandate (WORM)**:
        *   **Law**: `audit_logs` テーブルは **Append-Only (追記のみ)** とし、RLSポリシーにて `UPDATE` および `DELETE` を物理的に禁止してください。
        *   **Archiving**: 古いログの削除は、自動パーティション管理（pg_partman）またはTTL機能によってのみ行い、人間の手動操作を禁じます。
    *   **The Immutable Record Protocol (Edit Window + Correction Log)**:
        *   **Law**: 重要な事実記録（健康記録、契約履歴、資産台帳、検査結果等）は、一度確定したら安易に変更されるべきではない「事実」として扱ってください。
        *   **Edit Window**: ユーザーによる編集・削除は、レコード作成から **一定時間以内**（推奨: 24時間）に制限してください。期限超過後の直接変更は禁止します。
        *   **Correction Log**: 期限後に修正が必要な場合は、元のレコードを保持したまま **「訂正記録（Correction Log）」** として別レコードを作成し、修正理由と修正者を記録する設計としてください。原本の改竄を物理的に防止します。
        *   **Rationale**: 医療・法務・財務等の領域では、記録の改竄防止と追跡可能性（Traceability）が法的要件となる場合があります。Edit Window は利便性を確保しつつ、確定後の不可逆性を保証するバランス設計です。

### 8.3. The Information Disclosure Protocol (Error Masking - Rule 8.3)
*   **Law**: エラーメッセージ（特に本番環境）において、DBのテーブル名、カラム名、スタックトレース、外部APIの生レスポンスなどの内部情報（Detailed Information）をエンドユーザーに表示することを物理的に禁止します。
*   **Action**: 
    1. サーバーサイドでエラーをキャッチし、ログには詳細を記録（`error_logs`）します。
    2. フロントエンドには一律で「エラーが発生しました（Error ID: xxxxx）」という抽象的なメッセージのみを返し、攻撃者へのヒント（Information Disclosure）を遮断してください。

### 8.4. The Zero Trust DTO Flow (Rule 8.4)
*   **Law**: APIリクエストおよび Server Action のレスポンスにおいて、DBの生レコード（`Row`）をそのまま返却することを**最高レベルで禁止**します。
*   **Action**: 
    1. 全てのデータ出力は、必ず **DTO (Data Transfer Object)** インターフェースを経由してください。
    2. **Strict Segregation**: 公開用 DTO (`PublicUserDTO`) と管理用 DTO (`AdminUserDTO`) を物理的に分離してください。管理用 DTO は `/admin` コンテキスト以外での使用を禁じます。
    3. ホワイトリスト方式（必要な項目のみを明示的に選択）を徹底し、将来的な機密カラム追加時の「意図しない流出」を構造的に防御してください。

### 8.5. The Security Verification Mandate (Rule 8.5)
*   **Law**: コードが正しいことを確認するだけでは、セキュリティは完成しません。
*   **Action**: セキュリティに関連する変更（RLS変更、認証フロー変更等）を行った際は、必ず **「実際のDB上で権限がないユーザーがエラーになること（Negative test）」** を物理的に確認し、その結果をエビデンスとして記録してください。机上検証のみのデプロイは厳禁です。

### 8.6. The Privacy Guardrail Protocol (Admin Firewall)
*   **Law**: 管理画面からの公式発表やLPにおいて、運用者が誤って個人の携帯番号やメールアドレスを公開してしまう事故は「最大の恥」です。
*   **Action**: 
    1.  **Client-Side Scan**: 管理画面の保存ボタン押下時に、正規表現でコンテンツ全体をスキャンするロジックを実装してください。
    2.  **Explicit Consent**: PII（電話番号、メールアドレス等）のパターンを検出した場合は、必ず `confirm()` ダイアログ等で警告し、「明示的な承認」がない限り、物理的に保存をブロックしてください。
