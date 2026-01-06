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
    *   **Spend Cap Protocol**: フェーズ1（開発・ローンチ）では「Spend Cap」をONにし、クラウド破産を防ぎます。フェーズ2（成長期）で初めてOFFにします。
    *   **ゾンビリソース排除**: 未使用の開発環境や古いバックアップは定期的に削除スクリプトで一掃します。

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
*   **Hybrid Architecture Strategy**:
    *   **Dual API Integration**: サブスクリプションは `Stripe Billing`、単発決済は `Stripe Checkout` を使い分けます。
    *   **Metadata-Driven Tiering**: プラン判定には `is_enterprise: "true"` 等のメタデータを使用します。コード内のIDハードコーディングは禁止です。
    *   **Native Access Privilege**: 公式ネイティブアプリ (Native App) からのアクセスには、Stripe契約状態に関わらずTier 2 (Enterprise) 相当の権限を付与する特例を設けます。
*   **Admin FinOps (管理機能)**:
    *   経理担当者が管理画面から「日次売上確認」「即時返金」「プラン強制変更」を行えるダッシュボードを実装します。
    *   **Universal Webhook**: Webhookは単一エンドポイントで受け取り、非同期Queueでイベントごとにルーティングします。
*   **税務 (Tax)**:
    *   **Global Tax Compliance**: ユーザーの居住国に基づいて、適切な税率（消費税、VAT、GST）を自動適用します（Stripe Tax推奨）。
    *   **インボイス制度**: 日本のインボイス制度（適格請求書等保存方式）に完全対応したフォーマットで領収書を自動発行します。
*   **法的表記 (Legal Notation)**:
    *   **特定商取引法**: 現地法（日本の場合は特商法）に基づき、運営者情報、返品特約等を正しく開示するページを設置します。
    *   **資金決済法**: 前払式支払手段（ポイント）の発行は慎重に行い、資金決済法に抵触しない場合のみ実施します。原則としてApple/Google IAPを利用します。

## 4. ポイント経済圏 (Point Economy System)
*   **Ledger Architecture (不変台帳)**:
    *   **Immutable Ledger**: ポイント残高の直接更新 (`UPDATE`) は厳禁です。全ての変動は `point_transactions` への `INSERT` (Credit/Debit) として記録し、残高は集計により算出します。
*   **Security & Fraud Prevention**:
    *   **Idempotency**: ポイント付与・消費にはクライアント生成のUUID（`Idempotency-Key`）を必須とし、二重付与を防ぎます。
    *   **Security-Tiered Allocation**: ユーザーの認証強度に応じて付与量を変動させ、MFA設定を推奨します。
        *   **Tier 1 (Email)**: 1 pt (Minimal / 捨て垢対策)
        *   **Tier 2 (Google Auth)**: 3 pts (Standard / Bot検知済み)
        *   **Tier 3 (MFA/Passkey)**: 5 pts (Premium / 高信頼)

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
