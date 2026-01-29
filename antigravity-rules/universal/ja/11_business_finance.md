# 11. ビジネス・財務・収益化戦略 (Business, Finance & Monetization Strategy)

## 1. ユニットエコノミクスと財務 (Unit Economics & Finance)
*   **LTV > CAC (The Golden Rule)**:
    *   **原則**: 顧客生涯価値（LTV）が顧客獲得コスト（CAC）を上回ることを常に監視します。理想的には **LTV / CAC > 3** を目指します。
    *   **計測**: 全てのマーケティング施策において、チャネルごとのCACとROIを計測可能な状態にします。
*   **リアルタイムPL (Real-time P&L)**:
    *   **可視化**: 売上だけでなく、サーバーコスト（COGS）や広告費（CAC）をAPIで取得し、日次で概算PL（損益計算書）を可視化します。
    *   **限界利益**: 1取引あたりの限界利益（Unit Contribution Margin）がプラスであることを常に監視します。
*   **FinOps (コスト管理)**:
    *   **予算アラート**: AWS/GCP/Firebaseの予算アラート（Budget Alert）を必ず設定し、クラウド破産を防ぎます。
    *   **コスト配分**: タグ付けにより、機能ごと・チームごとのコストを明確にします。
    *   **Cost Visualization Dashboard**: 管理画面において、「概算コスト($)」「機能別消費トークン」等の指標を日次で可視化し、推測ではなく事実に基づいてコスト対策を行います。
    *   **Spend Cap Protocol**: フェーズ1（開発・ローンチ）では「Spend Cap」をONにし、クラウド破産を防ぎます。フェーズ2（成長期）で初めてOFFにします。
    *   **Cloud Bankruptcy Prevention (無限ループ対策)**:
        *   **Infinite Loop Ban**: `useEffect` や再帰処理による「無限DB読み込み（Infinite Reads）」は、数分で数百万リクエストを発生させ破産を招くため、ループ条件の厳格なレビューと、開発環境でのリミット設定を義務付けます。
        *   **Cache Invalidation Storm**: キャッシュ無効化（Revalidation）をループ内で連打する実装は、APIコールの爆発的増加を招くため禁止します。
    *   **ゾンビリソース排除**: 未使用の開発環境や古いバックアップは定期的に削除スクリプトで一掃します。
    *   **Preview Cleanup Protocol**: PRマージ後、CI/CDでPreview環境（ブランチDB等）を自動削除し、「マイグレーションの亡霊」を防ぎます。
*   **Vendor Lock Avoidance (Exit Strategy)**:
    *   **Portable Schema**: DBスキーマ、RLSポリシー、Triggerは標準SQL (`.sql`) で記述し、特定ベンダー固有機能への依存を最小化します。
    *   **No Proprietary Lock-in**: ベンダー独自のストレージ/KV機能を避け、S3/Redis互換インターフェースを使用します。
    *   **Domain Sovereignty**: ドメインのNS（ネームサーバー）管理権限は、ホスティング事業者に委譲せず、独立した管理アカウント（Cloudflare等）で自ら保持します。
*   **The Domain Auto-Renewal Mandate (Suicide Prevention)**:
    *   **Risk**: クレジットカードの有効期限切れによるドメイン失効（Drop Catch）は、ビジネスの即死を意味します。
    *   **Action**: ドメインレジストラにおいて**Auto-Renewal（自動更新）**を常に有効化し、有効期限の異なるクレジットカードを2枚以上登録するか、プリペイド残高を維持します。

## 2. 収益化モデル (Monetization Models)
*   **サブスクリプション (Subscription)**:
    *   **SKU設計**: プランは「松竹梅（例: Free, Pro, Business）」の3つに絞り、決定麻痺（Decision Paralysis）を防ぎます。
    *   **年額プラン**: 年額プランには明確な割引（例: 2ヶ月分無料）を提示し、キャッシュフローを改善します。
*   **フリーミアム (Freemium)**:
    *   **Aha! Moment**: 価値を実感する瞬間までは無料で体験させます。
    *   **Paywall**: 課金画面では、メリットを視覚的に訴求し、「いつでもキャンセル可能」を明記して不安を取り除きます。
*   **Eコマース (E-Commerce)**:
    *   **カゴ落ち対策**: ゲスト購入を許可し、強制的な会員登録を排除します。
    *   **1クリック決済**: Apple Pay / Google Pay を導入し、入力の手間を極限まで減らします。
*   **Feature Gating Strategy (Tier Restrictions)**:
    *   **Quota Enforcement**: 「登録数上限（Max N）」や「機能制限（Vision AI回数）」は、フロントエンドだけでなく、サーバーサイド（Guard/Policies）で厳格に強制します。
    *   **Upsell Trigger**: 制限超過イベント（`LimitExceeded`）をフックし、単なるエラーではなく上位プランへの明確なアップセル（Upsell UI）を表示する好機と捉えます。

## 3. 決済とコンプライアンス (Payment & Compliance)
*   **Payment Gateway Strategy**:
    *   **Stripe First**: 開発者体験と拡張性の観点から、原則として **Stripe** を第一選択とします。
    *   **Vendor Agnostic**: ただし、ビジネスロジックは `PaymentProvider` インターフェースで抽象化し、特定ベンダーへの完全依存リスクをヘッジします。
*   **Security Pillars (The 19 Pillars of Trust)**:
    *   **NO RAW CARD DATA (PCI-DSS回避)**: クレジットカード情報（PAN/CVV）は自社サーバーで一切保存・通過させてはなりません。Stripe.js/Checkoutによるトークン化を徹底します。
    *   **Idempotency & State Consistency**: ネットワークエラーや連打による「二重決済」を `Idempotency-Key` で防ぎ、Webhookによる結果整合性を保証します。
    *   **Anti-Fraud**: Stripe Radarを活用し、不正利用（クレジットマスター）を自動ブロックします。
    *   **Auditability**: 金額変更や権限付与の操作は、監査ログとして完全に記録します。
*   **The Payment Fail-Safe Protocol (決済失敗時回復)**:
    *   **Law**: 決済失敗時にユーザーを即座に解約するのではなく、猶予期間 **（Grace Period: 3-7日）** を設けます。
    *   **Action**:
        1.  **Dunning Emails**: 決済失敗時は、1日後、3日後、5日後に「カード情報を更新してください」という督促メールを自動送信します。
        2.  **Service Continuity**: Grace Period中はサービスを継続利用可能にし、意図しない解約（Involuntary Churn）を最小化します。
        3.  **Stripe Smart Retries**: Stripe Billingの自動リトライ機能を有効化し、回収率を最大化します。
*   **Hybrid Architecture Strategy**:
    *   **Dual API Integration**: サブスクリプションは `Stripe Billing`、単発決済は `Stripe Checkout` を使い分けます。
    *   **Metadata-Driven Tiering (Rule 26.2)**: 
        *   **Law (Metadata Segregation)**: プランの性質（BtoB/BtoC, API利用権限等）は、Stripe上の **Metadata (`is_enterprise: true` 等)** に持たせ、コードはそれを参照して動的に振る舞う「データ駆動」を徹底してください。
        *   **Reason**: コード内でプランIDをハードコードすると、Stripe側でプランを作り直すたびにアプリの再審査・再デプロイが必要になり、ビジネスの機動力を損なうためです。
    *   **The API Product Mindset (Rule 26.3)**:
        *   **Law (Data Monetization)**: 全てのデータ出力は「商品（Product）」です。内部APIという甘えを捨て、APIを **Tier 1 (Public/Free)** と **Tier 2 (Enterprise/Paid)** に厳格に分離可能な設計にしてください。
        *   **Action**: 外部公開を想定し、DBの生データをそのまま返さず（Information Leak防止）、必ずDTO（Data Transfer Object）で「商品」としてパッケージ化して提供してください。
    *   **The Metered Billing Mandatory Protocol (Rule 26.4)**:
        *   **Law**: 従量課金（API利用数ベース等）がビジネスモデルに含まれる場合、成功したAPIリクエストごとに `recordUsage` を **Fire-and-forget** パターンで呼び出すことを義務付けます。
        *   **Transparency**: 利用ログはリアルタイムで `api_usage_logs` 等に永続化し、顧客が自身の管理画面から「今いくら使ったか」を100%把握できる透明性を維持してください。
    *   **Native Access Privilege**: 公式ネイティブアプリ (Native App) からのアクセスには、Stripe契約状態に関わらずTier 2 (Enterprise) 相当の権限を付与する特例を設けます。
*   **Admin FinOps (管理機能)**:
    *   経理担当者が管理画面から「日次売上確認」「即時返金」「プラン強制変更」を行えるダッシュボードを実装します。
    *   **Universal Webhook**: Webhookは単一エンドポイントで受け取り、非同期Queueでイベントごとにルーティングします。
*   **税務 (Tax)**:
    *   **Global Tax Compliance**: ユーザーの居住国に基づいて、適切な税率（消費税、VAT、GST）を自動適用します（Stripe Tax推奨）。
    *   **インボイス制度**: 日本のインボイス制度（適格請求書等保存方式）に完全対応したフォーマットで領収書を自動発行します。
    *   **The Invoice Preservation Protocol (7年保存)**:
        *   **Law**: 電子帳簿保存法に基づき、発行した領収書・請求データは **7年間** 削除してはなりません。Stripe上のデータだけでなく、PDFをS3/Storageにアーカイブし、アカウント凍結時でも税務調査に対応できる二重化構成をとります。
    *   **The Secure Write Action Protocol (Tier 2 Mandate)**:
        *   **Law**: 「金銭・重要設定・権限」に関わる全ての Server Action は、例外なく Tier 2 (Strict) 保護対象です。
        *   **Action**: 
            1. **Parameter Mandate**: Server Action は引数に必ず `otp?: string` および `turnstileToken?: string` を受け取ってください。
            2. **Verification First**: 処理冒頭で `verifyActionOtp` または `verifyTurnstileAction` を呼び出し、認証失敗時は即座に例外をスローしてください。
            3. **UI Standard**: フロントエンドは `SecureActionModal` (または `OTPModal`) を使用し、ユーザーに明示的な承認と認証を求めることを義務付けます。
*   **法的表記 (Legal Notation)**:
    *   **特定商取引法**: 現地法（日本の場合は特商法）に基づき、運営者情報、返品特約等を正しく開示するページを設置します。
    *   **資金決済法**: 前払式支払手段（ポイント）の発行は慎重に行い、資金決済法に抵触しない場合のみ実施します。原則としてApple/Google IAPを利用します。
    *   **The Service Termination Refund Protocol (サービス終了時払戻し)**:
        *   **Law**: 資金決済法第20条第1項に基づき、サービス終了（End of Service）時には、未使用の有償ポイント残高をユーザーへ **全額払い戻す** 義務があります。供託金または保全資産が払戻し総額をカバーできる財務状態を維持してください。
*   **The Zombie Revenue Stop (休眠課金停止)**:
    *   **Risk**: ユーザーが死亡・長期入院等でサービス未利用のまま課金継続は、返金訴訟やブランド毀損リスク。
    *   **Law**: 最終ログインから **12ヶ月** 経過した有料会員には、メールで課金継続確認を行い、応答がない場合はサブスクリプションを自動停止します。
    *   **Action**: `last_login_at` を監視し、休眠検知 → 通知 → 自動停止のフローを実装してください。

## 4. ポイント経済圏 (Point Economy System)
*   **Ledger Architecture (不変台帳)**:
    *   **Immutable Ledger**: ポイント残高の直接更新 (`UPDATE`) は厳禁です。全ての変動は `point_transactions` への `INSERT` (Credit/Debit) として記録し、残高は集計により算出します。
*   **Security & Fraud Prevention**:
    *   **Idempotency**: ポイント付与・消費にはクライアント生成のUUID（`Idempotency-Key`）を必須とし、二重付与を防ぎます。
    *   **Security-Tiered Allocation**: ユーザーの認証強度に応じて付与量を変動させ、MFA設定を推奨します。
        *   **Tier 1 (Email)**: 1 pt (Minimal / 捨て垢対策)
        *   **Tier 2 (Google Auth)**: 3 pts (Standard / Bot検知済み)
        *   **Tier 3 (MFA/Passkey)**: 5 pts (Premium / 高信頼)
*   **The 180-Day Expiration Protocol (資金決済法回避)**:
    *   **Law**: 自示発行ポイントは「前払式支払手段」の供託義務（1000万円超）を回避するため、有効期限を **発行から180日（6ヶ月）** に設定することを推奨します。
    *   **Action**: 毎晩のバッチ処理で期限切れポイントを失効処理し、ユーザーに事前通知（30日前、7日前）を行います。無期限ポイントの発行は原則禁止です。

## 5. 自社広告管理システム (Ad Management Strategy)
*   **Independent Architecture (独立管理原則)**:
    *   **Separation**: 広告データ (`ads`) と画像は、通常のメディアライブラリ (`media_items`) とは完全に分離して管理します（ライフサイクルと公開範囲が異なるため）。
*   **Dynamic Injection**:
    *   **No Hardcoding**: 広告バナーのURLやリンク先をコードに直書きすることは永久に禁止です。必ず管理画面 (`/admin/ads`) から入稿・制御できる仕組みにします。
*   **Placement Strategy**:
    *   **Unified System**: 広告の表示場所は `location` ID（例: `sidebar_top`）で管理し、フロントエンドは配置場所のみを指定して、システムが適切な広告を配信します。

## 6. AIトークンエコノミクス (AI Token Economics)
*   **収益性ガードレール (Profitability Guardrails)**:
    *   **The 30% Rule**: AI機能の原価（トークンコスト）は、サブスクリプション月額の **30%以下** に抑えます。超過時はハードリミットを適用します。
    *   **モデル使い分け**: 全てに最高性能モデル（GPT-4等）を使わず、タスクの複雑度に応じて軽量モデル（Flash/Mini）と使い分けます。
    *   **サーキットブレーカー**: コスト急騰時（例: 1時間で予算超過）にAI機能を自動停止する安全装置を実装します。
