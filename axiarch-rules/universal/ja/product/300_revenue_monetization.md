# 11. ビジネス・財務・収益化戦略 (Business, Finance & Monetization Strategy)

> [!CAUTION]
> **このファイルは Universal Rule（不変ルール）です。「憲法改正」の明示的指示がない限り編集禁止。**
> 改定日: 2026-03-24

> [!IMPORTANT]
> **Supreme Directive（最高指令）**
> 「収益は機能ではない — 持続可能なプロダクト開発の生命線である。」
> すべての収益化判断はデータ駆動・倫理的健全性・アーキテクチャ的堅牢性を備えなければならない。
> **ユーザー信頼 > 収益持続性 > 成長速度 > 短期利益** の優先順位を厳守せよ。
> この文書はビジネス・財務・収益化戦略に関するすべての設計判断の最上位基準である。
> **7パート・29セクション構成。**

---

## 目次

| Part | トピック | セクション |
|------|---------|-----------|
| I | ユニットエコノミクスと財務 | §1 |
| II | 収益化モデル | §2 |
| III | 決済とコンプライアンス | §3 |
| IV | ポイント経済圏 | §4 |
| V | 自社広告管理システム | §5 |
| VI | AIトークンエコノミクス | §6 |
| VII | プロモーション・価格戦略 | §7 |

---

## 1. ユニットエコノミクスと財務 (Unit Economics & Finance)
*   **LTV > CAC (The Golden Rule)**:
    *   **原則**: 顧客生涯価値（LTV）が顧客獲得コスト（CAC）を上回ることを常に監視します。理想的には **LTV / CAC > 3** を目指します。
    *   **計測**: 全てのマーケティング施策において、チャネルごとのCACとROIを計測可能な状態にします。
*   **The LTV Calculation Standard Protocol (LTV算出基準)**:
    *   **Formula**: `LTV = ARPU × Gross Margin × Average Lifespan (months)`
    *   **Metrics Definition**:

        | 指標 | 定義 | 計測方法 |
        |:-----|:-----|:---------|
        | **ARPU** | Average Revenue Per User（月間） | MRR ÷ アクティブ有料ユーザー数 |
        | **Gross Margin** | 粗利率 | (売上 - 原価) ÷ 売上 |
        | **Average Lifespan** | 平均契約期間（月） | 1 ÷ Monthly Churn Rate |
        | **CAC** | Customer Acquisition Cost | マーケティング費 ÷ 新規有料ユーザー数 |

    *   **Segmentation**: LTVは**プラン別**（例: Free / Standard / Premium）および**獲得チャネル別**（例: Organic / Paid / Referral）で集計し、セグメントごとの投資対効果を可視化してください。
*   **The AARRR × LTV Optimization Framework（AARRR × LTV最適化フレームワーク）**:
    *   **Context**: AARRR（Acquisition → Activation → Retention → Revenue → Referral）の各ステージをLTV向上の観点で最適化してください。
    *   **Mandate**:

        | Stage | KPI | LTVへの影響 | 施策例 |
        |:------|:----|:-----------|:-------|
        | **Acquisition** | 新規登録数、CPA | 高品質ユーザーの獲得がLTVの起点 | SEO最適化、コンテンツマーケティング |
        | **Activation** | Day1 リテンション、初回体験完了率 | 初回体験の質がLTVを大きく左右 | オンボーディングフロー最適化 |
        | **Retention** | WAU/MAU、Day7/Day30 リテンション | 継続利用がLTVの乗数 | プッシュ通知、パーソナライズ |
        | **Revenue** | ARPU、有料転換率 | 直接的なLTV構成要素 | アップセル、クロスセル施策 |
        | **Referral** | K-Factor、NPS | 紹介経由ユーザーはLTVが高い傾向 | リファラルプログラム |

    *   **Action**: 各ステージのKPIを定期的にモニタリングし、LTVへの寄与度が低いステージを優先的に改善してください。
*   **The Value-Based Customer Segmentation Protocol (顧客セグメンテーション)**:
    *   **Law**: ユーザーを以下のセグメントに分類し、セグメント別の施策を設計してください。

        | セグメント | 定義 | 対応方針 |
        |:----------|:-----|:---------|
        | **Champion** | 有料プラン + 高頻度利用 + 高エンゲージメント | VIP体験、ベータ機能先行提供 |
        | **Loyal** | 有料プラン + 定期利用 | アップセル施策、ロイヤルティプログラム |
        | **Promising** | 無料プラン + 高頻度利用 | 有料転換施策、限定オファー |
        | **Hibernating** | 長期非アクティブ（30日以上未ログイン） | リエンゲージメント施策 |
        | **At Risk** | 離脱予兆シグナル検知 | 即時介入、CS対応 |

    *   **Action**: セグメント分類は日次バッチ処理で自動更新し、管理ダッシュボードで可視化してください。
*   **リアルタイムPL (Real-time P&L)**:
    *   **可視化**: 売上だけでなく、サーバーコスト（COGS）や広告費（CAC）をAPIで取得し、日次で概算PL（損益計算書）を可視化します。
    *   **限界利益**: 1取引あたりの限界利益（Unit Contribution Margin）がプラスであることを常に監視します。
*   **FinOps (コスト管理)**:
    *   **予算アラート**: AWS/GCP/Firebaseの予算アラート（Budget Alert）を必ず設定し、クラウド破産を低減します。
    *   **コスト配分**: タグ付けにより、機能ごと・チームごとのコストを明確にします。
    *   **Cost Visualization Dashboard**: 管理画面において、「概算コスト($)」「機能別消費トークン」等の指標を日次で可視化し、推測ではなく事実に基づいてコスト対策を行います。
    *   **Exchange Rate Defense (為替リスク監視)**: 外貨建て（USD等）のクラウドサービスを利用する場合、月次決算時にコストを現地通貨に換算して記録し、為替変動による利益率低下を監視してください。急激な為替変動時にはプライシングの見直しトリガーを設定することを推奨します。
    *   **Spend Cap Protocol**: フェーズ1（開発・ローンチ）では「Spend Cap」をONにし、クラウド破産を低減します。フェーズ2（成長期）で初めてOFFにします。
    *   **Scale First Credit Strategy（早すぎる最適化回避）**: マネージドサービスの基本枠（転送量・リクエスト数等）の使用率アラートが鳴るまでは、過剰なコスト削減（早すぎる最適化）を行わず、**ユーザー体験と機能開発に全リソースを集中**してください。基本枠を超過した場合に備え、手動復旧（Spend Cap解除等）の手順を事前に文書化しておくことを推奨します。
    *   **Cloud Bankruptcy Prevention (無限ループ対策)**:
        *   **Infinite Loop Ban**: `useEffect` や再帰処理による「無限DB読み込み（Infinite Reads）」は、数分で数百万リクエストを発生させ破産を招くため、ループ条件の厳格なレビューと、開発環境でのリミット設定を義務付けます。
        *   **Cache Invalidation Storm**: キャッシュ無効化（Revalidation）をループ内で連打する実装は、APIコールの爆発的増加を招くため禁止します。
    *   **ゾンビリソース排除**: 未使用の開発環境や古いバックアップは定期的に削除スクリプトで一掃します。
    *   **Zombie Hunter Protocol（月次監査チェックリスト）**: 月に一度、全クラウド環境を「監査」し、不要なリソースを特定・削除してください。
        *   **対象チェックリスト**:
            *   未使用の固定IPアドレス（保持するだけでコストが発生）
            *   マージ・削除済みPRに紐づくPreview環境やブランチDB
            *   Storage内の孤立ファイル（参照レコードが存在しないアセット）
            *   停止中のDBインスタンスやサーバーレス関数（料金が発生し続けていないか確認）
    *   **Preview Cleanup Protocol**: PRマージ後、CI/CDでPreview環境（ブランチDB等）を自動削除し、「マイグレーションの亡霊」を低減します。
    *   **Storage Tiering Protocol**: アクセス頻度の低いログやアーカイブデータは、Hot Storage（高価）から Cold Storage（S3 Glacier / R2 等の低価格帯）へ移動するライフサイクルポリシーを設定し、ストレージコストを最適化します。
    *   **Cache Hierarchy Standard (Cache-First FinOps)**: DB負荷とコストを最小化するため、全てのクエリに以下のキャッシュ階層を適用します。
        *   **STATIC (86400s)**: マスタデータ（カテゴリ、設定値）— DB負荷ゼロ。
        *   **WARM (300s)**: 検索結果、一覧リスト。
        *   **HOT (60s)**: 詳細ページ、レビュー。
        *   **REALTIME (0s)**: 決済、認証 — キャッシュ禁止。
    *   **Heavy Media Bandwidth Watch（帯域コスト監視基準）**: 高画質画像や動画など帯域を大幅に消費するメディアについて、そのトラフィックがホスティングの転送量枠全体の**30%**を超えた時点で、**専用メディア配信基盤**（動画ストリーミングサービス、画像CDN等）へのオフロードを即座に検討してください。バズ等による帯域の急増は、ホスティング枠を一瞬で食いつぶすリスクがあります。
    *   **The Vendor Cost Governance Protocol（委託先コスト管理）**:
        *   **Law**: 外部委託先（SaaS、IaaS、業務委託先等）のコストは、プロジェクト全体の運用コストに占める割合が大きいにもかかわらず、管理が甘くなりがちな「隠れコスト」です。可視化と定期的な最適化を義務付けます。
        *   **月次コストレビュー**: 全委託先コストを月次で集計・可視化し、予算対比を管理ダッシュボードに表示してください。
        *   **ベンチマーク比較**: 契約更新時（または年次で）、同等サービスの市場価格とのベンチマーク比較を実施し、交渉材料として活用してください。
        *   **コスト超過対応**: 委託先コストが予算の**80%**を超過した時点でアラートを発報し、**100%**超過時はコスト最適化レビューを必須とします。
        *   **契約条件の標準化**: ボリュームディスカウント、年間契約割引、途中解約条件を全ての委託先契約で交渉・文書化してください。
*   **Vendor Lock Avoidance (Exit Strategy)**:
    *   **Portable Schema**: DBスキーマ、RLSポリシー、Triggerは標準SQL (`.sql`) で記述し、特定ベンダー固有機能への依存を最小化します。
    *   **No Proprietary Lock-in**: ベンダー独自のストレージ/KV機能を避け、S3/Redis互換インターフェースを使用します。
    *   **Domain Sovereignty**: ドメインのNS（ネームサーバー）管理権限は、ホスティング事業者に委譲せず、独立した管理アカウント（Cloudflare等）で自ら保持します。
*   **The Domain Auto-Renewal Mandate (Suicide Prevention)**:
    *   **Risk**: クレジットカードの有効期限切れによるドメイン失効（Drop Catch）は、ビジネスの即死を意味します。
    *   **Action**: ドメインレジストラにおいて**Auto-Renewal（自動更新）**を常に有効化し、有効期限の異なるクレジットカードを2枚以上登録するか、プリペイド残高を維持します。

## 2. 収益化モデル (Monetization Models)
*   **サブスクリプション (Subscription)**:
    *   **SKU設計**: プランは「松竹梅（例: Free, Pro, Business）」の3つに絞り、決定麻痺（Decision Paralysis）を低減します。
    *   **年額プラン**: 年額プランには明確な割引（例: 2ヶ月分無料）を提示し、キャッシュフローを改善します。
*   **フリーミアム (Freemium)**:
    *   **Aha! Moment**: 価値を実感する瞬間までは無料で体験させます。
    *   **Paywall**: 課金画面では、メリットを視覚的に訴求し、「いつでもキャンセル可能」を明記して不安を取り除きます。
*   **Eコマース (E-Commerce)**:
    *   **カゴ落ち対策**: ゲスト購入を許可し、強制的な会員登録を抑制します。
    *   **1クリック決済**: Apple Pay / Google Pay を導入し、入力の手間を極限まで減らします。
*   **Feature Gating Strategy (Tier Restrictions)**:
    *   **Quota Enforcement**: 「登録数上限（Max N）」や「機能制限（Vision AI回数）」は、フロントエンドだけでなく、サーバーサイド（Guard/Policies）で厳格に強制します。
    *   **Upsell Trigger**: 制限超過イベント（`LimitExceeded`）をフックし、単なるエラーではなく上位プランへの明確なアップセル（Upsell UI）を表示する好機と捉えます。

## 3. 決済とコンプライアンス (Payment & Compliance)
*   **Payment Gateway Strategy**:
    *   **Stripe First**: 開発者体験と拡張性の観点から、原則として **Stripe** を第一選択とします。
    *   **Vendor Agnostic**: ただし、ビジネスロジックは `PaymentProvider` インターフェースで抽象化し、特定ベンダーへの完全依存リスクをヘッジします。
    *   **The Provider Freeze Resilience Protocol (プロバイダ凍結リスク対策)**:
        *   **Risk**: 決済プロバイダ（Stripe等）のアカウントが凍結された場合、全ての課金が停止し、事業継続が不可能になります。
        *   **Action**:
            1.  **Adapter Pattern**: 課金ロジックは `PaymentProvider` インターフェースで抽象化し、代替プロバイダ（PayPal, Square等）への切り替えが48時間以内に完了できる設計を維持してください。
            2.  **Invoice Archive**: 決済プロバイダ上のInvoiceデータだけでなく、PDFを自社Storageにアーカイブし、プロバイダ凍結時でも税務・法務対応が可能な二重化構成を維持してください。
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
*   **The Smart Retention Protocol (自主解約時引き留めフロー)**:
    *   **Context**: ユーザーが自ら解約を選択した場合でも、適切なフローを通じてチャーン（離脱）を低減できます。
    *   **Action**:
        1.  **Cancel Reason Survey**: 解約ボタン押下後、解約理由を選択式で聴取します（改善のためのデータ収集）。
        2.  **Retention Offer**: 理由に応じたリテンションオファー（翌月無料クーポン、機能改善予定の通知等）を提示します。
    *   **Guardrail**: 解約導線を意図的に複雑にする **Dark Pattern は厳禁** です。オファーを辞退した場合は即座に解約を完了してください。
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
        *   **Async-First Logging**: 計測ログの記録はレスポンスを遅延させないよう、非同期処理（バックグラウンドジョブ、キュー等）で行ってください。
        *   **Zero Exception**: 計測ログの記録に失敗したことを理由に、ユーザーに500エラーを返してはなりません。ログの欠損よりもUXの維持を優先してください。
    *   **Native Access Privilege**: 公式ネイティブアプリ (Native App) からのアクセスには、Stripe契約状態に関わらずTier 2 (Enterprise) 相当の権限を付与する特例を設けます。
*   **Admin FinOps (管理機能)**:
    *   経理担当者が管理画面から「日次売上確認」「即時返金」「プラン強制変更」を行えるダッシュボードを実装します。
    *   **Universal Webhook**: Webhookは単一エンドポイントで受け取り、非同期Queueでイベントごとにルーティングします。
    *   **The Webhook-Driven State Machine Protocol (イベント駆動ステート管理)**:
        *   **Law**: 決済・サブスクリプションの権限状態における「正（Source of Truth）」は常に決済プロバイダ側にあります。自社DBはキャッシュとして扱い、Webhookイベントによる**結果整合性（Eventual Consistency）**を数秒以内に保証してください。
        *   **Action**:
            1.  **Event Routing**: 単一Webhookエンドポイントで全イベントを受信し、イベントタイプ（例: `invoice.payment_succeeded`, `checkout.session.completed`, `customer.subscription.updated`）に応じて非同期Queueにルーティングしてください。
            2.  **State Sync**: サブスクリプションのステータス変更（`active` → `canceled` 等）は、Webhookイベントを起点に自社DBを更新してください。ユーザー操作からの直接DB更新は禁止です。
            3.  **Tier Auto-Sync**: プラン変更に連動してAPIアクセス権限（Tier 1 ⇄ Tier 2）の自動昇格/降格を行う仕組みを実装してください。
*   **The Payment Data Attribution Protocol (決済データアトリビューション)**:
    *   **Law**: 決済時に流入元情報（`utm_source`, `utm_medium`, `campaign_id` 等）を決済プロバイダの **Metadata** または自社DBの決済レコードに記録し、チャネルごとのROI・LTV分析を可能にしてください。
    *   **Action**:
        1.  **UTM Persistence**: ユーザーの初回流入時のUTMパラメータをSession/Cookieに保存し、決済完了時に決済メタデータへ自動引き継ぎしてください。
        2.  **Attribution Analytics**: マーケティングチャネルごとの「獲得ユーザー数 × LTV」を集計可能なレポート基盤を設計してください。
*   **税務 (Tax)**:
    *   **Global Tax Compliance**: ユーザーの居住国に基づいて、適切な税率（消費税、VAT、GST）を自動適用します（Stripe Tax推奨）。
    *   **インボイス制度**: 日本のインボイス制度（適格請求書等保存方式）に完全対応したフォーマットで領収書を自動発行します。
    *   **The Multi-Currency Readiness Protocol (多通貨対応設計)**:
        *   **Law**: 決済システムは多通貨（Multi-Currency）への拡張性を確保した設計を維持してください。
        *   **Action**:
            1.  **Currency Isolation**: 金額を扱うカラム・変数には必ず通貨コード（`currency: 'JPY'`）を併記し、通貨情報のない金額の保存を禁止してください。
            2.  **Provider Delegation**: 通貨変換は自前で計算せず、決済プロバイダ（Stripe等）の多通貨機能に委譲してください。
            3.  **Display Locale**: 金額表示はユーザーのロケールに応じたフォーマット（例: `¥1,000` / `$10.00`）で動的に切り替え可能な設計にしてください。
    *   **The Invoice Preservation Protocol (7年保存)**:
        *   **Law**: 電子帳簿保存法に基づき、発行した領収書・請求データは **7年間** 削除してはなりません。Stripe上のデータだけでなく、PDFをS3/Storageにアーカイブし、アカウント凍結時でも税務調査に対応できる二重化構成をとります。
        *   **検索3要件（技術実装）**: 電子帳簿保存法の検索要件に準拠し、以下の3項目で取引データを検索可能な状態を維持してください。

            | 検索要件 | DB実装例 | インデックス |
            |:--------|:------|:-----------|
            | **取引日** | `transaction_date` (date) | 必須 |
            | **取引先** | `counterparty_name` (text) | 必須 |
            | **金額** | `amount` (integer) | 必須 |

        *   **原本性保証**: 決済プロバイダからのWebhookペイロードを原本として保存する際、`SHA-256` ハッシュを記録し改竄検知を可能にしてください。一度保存した原本データの `UPDATE` は禁止し、訂正が必要な場合は訂正履歴レコードを追加してください。
    *   **The Tax Registration Number Protocol (税務登録番号管理)**:
        *   **Law**: 適格請求書発行事業者登録番号（日本のT番号、EUのVAT番号等）は、システム設定テーブル（例: `site_settings`）で一元管理し、請求書・領収書・PDFに**自動印字**されるようテンプレートを構成しなければなりません。
        *   **Action**:
            1.  **Centralized Storage**: 登録番号は環境変数やコード内にハードコードせず、管理画面から編集可能なDBテーブルで管理してください。番号変更時にデプロイが不要な設計を維持します。
            2.  **Auto-Print**: 決済プロバイダ（Stripe Invoice等）のテンプレートおよび自社発行のPDF領収書に、登録番号が自動的に印字される仕組みを実装してください。
            3.  **Validation**: 登録番号のフォーマットバリデーション（例: 日本のT番号は `T` + 13桁数字）を入力時に実施してください。
    *   **The Secure Write Action Protocol (Tier 2 Mandate)**:
        *   **Law**: 「金銭・重要設定・権限」に関わる全ての Server Action は、例外なく Tier 2 (Strict) 保護対象です。
        *   **Action**: 
            1. **Parameter Mandate**: Server Action は引数に必ず `otp?: string` および `turnstileToken?: string` を受け取ってください。
            2. **Verification First**: 処理冒頭で `verifyActionOtp` または `verifyTurnstileAction` を呼び出し、認証失敗時は即座に例外をスローしてください。
            3. **UI Standard**: フロントエンドは `SecureActionModal` (または `OTPModal`) を使用し、ユーザーに明示的な承認と認証を求めることを義務付けます。
*   **法的表記 (Legal Notation)**:
    *   **特定商取引法**: 現地法（日本の場合はConsumer Protection Laws）に基づき、運営者情報、返品特約等を正しく開示するページを設置します。
    *   **Financial Regulations**: 前払式支払手段（ポイント）の発行は慎重に行い、Financial Regulationsに抵触しない場合のみ実施します。原則としてApple/Google IAPを利用します。
    *   **The Service Termination Refund Protocol (サービス終了時払戻し)**:
        *   **Law**: Financial Regulations第20条第1項に基づき、サービス終了（End of Service）時には、未使用の有償ポイント残高をユーザーへ **全額払い戻す** 義務があります。供託金または保全資産が払戻し総額をカバーできる財務状態を維持してください。
*   **The Zombie Revenue Stop (休眠課金停止)**:
    *   **Risk**: ユーザーが死亡・長期入院等でサービス未利用のまま課金継続は、返金訴訟やブランド毀損リスク。
    *   **Law**: 最終ログインから **12ヶ月** 経過した有料会員には、メールで課金継続確認を行い、応答がない場合はサブスクリプションを自動停止します。
    *   **Action**: `last_login_at` を監視し、休眠検知 → 通知 → 自動停止のフローを実装してください。
*   **The Payment Trust Checklist (決済信頼性チェックリスト)**:
    *   **Context**: 決済システムの導入・拡張時に、信頼性と成長性の両面で必要な要件を漏れなく確認するための統合チェックリストです。個別ルールは上記各項目で詳述していますが、クロスチェック用として一覧化します。
    *   **Checklist**:

        | # | カテゴリ | チェック項目 | 参照 |
        |:--|:--------|:-----------|:-----|
        | 1 | **セキュリティ** | PCI-DSS準拠（トークン化徹底、生カードデータ非保持） | §3 Security Pillars |
        | 2 | **セキュリティ** | 冪等性キー（Idempotency-Key）による二重決済防止 | §3 Security Pillars |
        | 3 | **セキュリティ** | 不正利用検知（Stripe Radar等）の有効化 | §3 Security Pillars |
        | 4 | **セキュリティ** | 監査ログ（金額変更・権限付与の完全記録） | §3 Security Pillars |
        | 5 | **整合性** | Webhook駆動ステート管理（Source of Truthはプロバイダ側） | §3 Webhook State Machine |
        | 6 | **整合性** | プロバイダ凍結リスク対策（Adapter Pattern + Invoice二重化） | §3 Provider Freeze |
        | 7 | **回復性** | 決済失敗時のGrace Period（3-7日）+ Dunningメール | §3 Payment Fail-Safe |
        | 8 | **回復性** | スマートリテンション（解約理由聴取 + オファー提示、Dark Pattern禁止） | §3 Smart Retention |
        | 9 | **法務** | 税務登録番号の一元管理と自動印字 | §3 Tax Registration |
        | 10 | **法務** | 電子帳簿保存法対応（7年保存 + 検索3要件 + 原本性保証） | §3 Invoice Preservation |
        | 11 | **法務** | サービス終了時の有償ポイント全額払戻し準備 | §3 Service Termination Refund |
        | 12 | **法務** | 休眠課金停止（12ヶ月未ログイン時の自動停止） | §3 Zombie Revenue Stop |
        | 13 | **拡張性** | 多通貨対応設計（Currency Isolation + Provider Delegation） | §3 Multi-Currency |
        | 14 | **拡張性** | Metadata駆動のTier分離（IDハードコード禁止） | §3 Metadata-Driven Tiering |
        | 15 | **拡張性** | 従量課金対応（Gateway Metering + Usage Log） | §3 Metered Billing |
        | 16 | **分析** | 決済データアトリビューション（UTM → 決済Metadata連携） | §3 Payment Data Attribution |
        | 17 | **UX** | WCAG 2.1 AA準拠のアクセシブルな決済フロー | — |
        | 18 | **拡張性** | A/Bテスト実験基盤（価格・プランの最適化） | §7.2 Dynamic Pricing |

## 4. ポイント経済圏 (Point Economy System)
*   **Ledger Architecture (不変台帳)**:
    *   **Immutable Ledger**: ポイント残高の直接更新 (`UPDATE`) は厳禁です。全ての変動は `point_transactions` への `INSERT` (Credit/Debit) として記録し、残高は集計により算出します。
*   **Security & Fraud Prevention**:
    *   **Idempotency**: ポイント付与・消費にはクライアント生成のUUID（`Idempotency-Key`）を必須とし、二重付与を低減します。
    *   **Security-Tiered Allocation**: ユーザーの認証強度に応じて付与量を変動させ、MFA設定を推奨します。
        *   **Tier 1 (Email)**: 1 pt (Minimal / 捨て垢対策)
        *   **Tier 2 (Google Auth)**: 3 pts (Standard / Bot検知済み)
        *   **Tier 3 (MFA/Passkey)**: 5 pts (Premium / 高信頼)
    *   **The Security-Incentive Resource Allocation Principle（セキュリティインセンティブ配分原則）**:
        *   **Law**: セキュリティレベルに連動したリソース配分は、ポイントに限らず**あらゆるサービスリソース**（API利用枠、ストレージ容量、AI機能利用回数、機能解放等）に適用可能な汎用原則です。
        *   **Action**:
            1.  **Tiered Privileges**: 高セキュリティ認証（MFA、Passkey等）を採用するユーザーに対し、API Rate Limitの緩和、ストレージ容量の拡大、プレミアム機能へのアクセス等の優遇措置を設計してください。
            2.  **Bot Deterrence**: 低セキュリティ認証（Email Only等）のアカウントには最小限のリソースのみ付与し、Bot・捨てアカウントによるリソース浪費を抑制してください。
            3.  **Security Upgrade Incentive**: ユーザーがセキュリティレベルを引き上げた際に、具体的なリソース増量を即座にフィードバックし、セキュリティ強化のインセンティブとして機能させてください。
        *   **Rationale**: セキュリティ強化をユーザーに「義務」ではなく「メリット」として体験させることで、自発的なセキュリティレベルの向上を促進します。
*   **The 180-Day Expiration Protocol (Financial Regulations回避)**:
    *   **Law**: 自示発行ポイントは「前払式支払手段」の供託義務（1000万円超）を回避するため、有効期限を **発行から180日（6ヶ月）** に設定することを推奨します。
    *   **Action**: 毎晩のバッチ処理で期限切れポイントを失効処理し、ユーザーに事前通知（30日前、7日前）を行います。無期限ポイントの発行は原則禁止です。

## 5. 自社広告管理システム (Ad Management Strategy)
*   **Independent Architecture (独立管理原則)**:
    *   **Separation**: 広告データ (`ads`) と画像は、通常のメディアライブラリ (`media_items`) とは完全に分離して管理します（ライフサイクルと公開範囲が異なるため）。
*   **Dynamic Injection**:
    *   **No Hardcoding**: 広告バナーのURLやリンク先をコードに直書きすることは永久に禁止です。必ず管理画面 (`/admin/ads`) から入稿・制御できる仕組みにします。
    *   **The Ad Creative Upload Standard (広告クリエイティブ入稿基準)**:
        *   **Law**: 広告入稿フローにおいて、外部URL指定だけでなく、**画像ファイル自体のアップロード（Storage保存）**をサポートしなければなりません。
        *   **Action**: アップロードされた画像は専用バケット（例: `ads-assets`）に保存し、CDN経由で配信してください。一般ユーザーの投稿画像と同一バケットに混在させることは禁止です。
*   **Placement Strategy**:
    *   **Unified System**: 広告の表示場所は `location` ID（例: `sidebar_top`）で管理し、フロントエンドは配置場所のみを指定して、システムが適切な広告を配信します。
*   **Ad Quality & Performance Standards (広告品質とパフォーマンス基準)**:
    *   **The CLS/INP Performance Guard (広告パフォーマンス義務)**:
        *   **Context**: 広告の遅延読み込みはCLS（Cumulative Layout Shift）を悪化させ、検索順位に直接影響します。
        *   **Law**: 広告挿入によるCLSは **≦ 0.1**（Core Web Vitals基準）を厳守してください。広告関連のインタラクション（閉じるボタン等）は **≦ 200ms** で応答すること（INP基準）。
        *   **Action**:
            1.  全ての広告スロットには `min-height` と `width` を**CSS固定値**で指定し、レイアウト領域を事前確保してください。
            2.  広告画像には `loading="lazy"` と `decoding="async"` を必須適用してください。
            3.  **Above-the-Fold例外**: ファーストビューの広告は `loading="eager"` + `priority={true}` でプリロードし、空白時間を最小化してください。
*   **The Ad Schema Standard (広告テーブル設計基準)**:
    *   **Law**: 広告管理テーブルには、最低限以下のカラムを含め、配信制御と効果測定を可能にしてください。

        | カラム | 型 | 説明 |
        |:------|:--|:-----|
        | `id` | UUID | 主キー |
        | `title` | Text | 管理用名称 |
        | `image_url` | Text | クリエイティブURL (CDN) |
        | `storage_path` | Text | Storage保存パス（自社入稿時） |
        | `link_url` | Text | 遷移先URL（Optional） |
        | `location` | Text | 配置場所識別子 |
        | `priority` | Int | 表示優先度 |
        | `start_at` | Timestamptz | 掲載開始日時 |
        | `end_at` | Timestamptz | 掲載終了日時 |
        | `is_active` | Boolean | 即時公開/停止フラグ |
        | `views` | Int | インプレッション数 |
        | `clicks` | Int | クリック数 |

*   **The Ads.txt & Sellers.json Integrity Protocol (広告サプライチェーン透明性)**:
    *   **Law**: 認定販売者情報（Ads.txt）を動的に配信し、ドメインなりすまし（Ad Fraud）を防止してください。また、広告在庫の販売者情報を `/sellers.json` で公開し、サプライチェーンの透明性を確保してください。
    *   **Action**:
        1.  **Ads.txt**: Route Handler等で `Cache-Control: public, s-maxage=3600`（1時間）を設定し、クローラーの大量アクセスによるサーバー負荷を回避してください。
        2.  **Sellers.json**: 自社情報およびパートナー情報を `/sellers.json` で公開してください。
        3.  **Validation**: 広告プラットフォーム（Google AdSense / GAM等）のステータスが "Authorized" であることを定期的に監視してください。
*   **The Ad Labeling Protocol (広告表記自動付与 / ステマ規制対応)**:
    *   **Law**: 広告枠、PR記事、スポンサーコンテンツには、ユーザーがひと目で認識できる位置・サイズで「PR」「広告」「Sponsored」等の表記を**システムレベルで自動付与**してください。
    *   **Action**:
        1.  **Auto-Label**: 広告コンポーネントは、配信時に自動的にラベルを表示する設計にしてください。表記のない広告配信をシステムレベルでブロックしてください。
        2.  **Compliance**: 各国の広告表示規制（日本のステマ規制、FTC Endorsement Guides等）に準拠した表記を維持してください。
*   **The Brand Safety Protocol (広告ブランドセーフティ)**:
    *   **Law**: サービスのブランド価値を毀損する不適切なカテゴリの広告を、**システムレベルで配信禁止**としてください。
    *   **Action**:
        1.  **Category Exclusion List**: サービスの性質に応じて、禁止カテゴリリスト（例: ギャンブル、アダルト、暴力、政治広告等）を定義してください。
        2.  **Third-Party Ads**: Google AdSense等の管理画面で該当カテゴリをブロック設定し、設定のスクリーンショットを年次で保存してください。
        3.  **Self-Hosted Ads**: 自社広告テーブルに `category` カラムを追加し、入稿時にカテゴリ分類を義務付けてください。禁止カテゴリに該当する広告はバリデーションでRejectしてください。
*   **The Ads.txt Operations Protocol (Ads.txt運用・定期監査)**:
    *   **Law**: Ads.txt / Sellers.json は、パートナー追加・離脱のたびに更新が必要であり、「一度設定して終わり」ではありません。
    *   **Action**:
        1.  **Monthly Audit**: 毎月、Ads.txt Validator等で構文エラーがないこと、登録パートナーが有効であること、Sellers.jsonの自社情報が正確であることを検証してください。
        2.  **Update Procedure**: 更新はコードリポジトリ経由（PR → レビュー → マージ → デプロイ）で行い、広告プラットフォームの管理画面でステータスを確認してください。
        3.  **Emergency Response**: 不正な広告パートナーが検出された場合、Ads.txtから即時削除し、24時間以内にデプロイしてください。

## 6. AIトークンエコノミクス (AI Token Economics)
*   **収益性ガードレール (Profitability Guardrails)**:
    *   **The 30% Rule**: AI機能の原価（トークンコスト）は、サブスクリプション月額の **30%以下** に抑えます。超過時はハードリミットを適用します。
    *   **モデル使い分け**: 全てに最高性能モデル（GPT-4等）を使わず、タスクの複雑度に応じて軽量モデル（Flash/Mini）と使い分けます。
    *   **サーキットブレーカー**: コスト急騰時（例: 1時間で予算超過）にAI機能を自動停止する安全装置を実装します。

## 7. プロモーション・価格戦略 (Promotion & Pricing Strategy)

### 7.1. The Coupon Integrity Protocol (クーポン整合性)
*   **Law**: クーポン・割引の適用ロジックは、**サーバーサイドで厳格に検証** してください。フロントエンドのみでの割引適用は、改ざんリスクがあるため禁止します。
*   **Action**:
    1.  **Server-Side Validation**: クーポンコードの有効性（期限、使用回数、対象条件）は必ずサーバーサイドで検証します。
    2.  **Idempotency**: 同一クーポンの二重適用を防ぐため、使用履歴をDB で管理し、一意制約（Unique Constraint）を設定します。
    3.  **Audit Trail**: クーポン使用履歴を監査ログに記録し、不正使用の追跡を可能にします。
    4.  **Budget Guard**: クーポンの総予算（利用上限回数、総割引額上限）をDB で管理し、予算超過時は自動的に無効化します。
    5.  **Per-User Limit**: ユーザーごとの使用回数上限（`max_uses_per_user`）を設定し、複数回の不正利用を防止してください。複数アカウント対策には、SMS認証やデバイスフィンガープリント等を組み合わせることを推奨します。
    6.  **Immutable Redemption History**: クーポン使用履歴（`coupon_redemptions`）は、決済確定後（Webhook受信後等）に記録し、**一切の変更・削除を禁止**してください。監査証跡として永久に保持します。

### 7.2. The Dynamic Pricing Protocol (動的価格設計)
*   **Law**: 価格やサブスクリプションプランの変更は、**コードデプロイなしに管理画面から即座に反映** できる設計を標準とします。
*   **Action**:
    1.  **Price as Data**: 価格情報はDBのテーブル（例: `plans`, `prices`）で管理し、コード内のハードコードを禁止します。
    2.  **Version Control**: 価格変更時は新しいレコードを作成し、`valid_from` / `valid_until` で有効期間を管理します。既存ユーザーの契約は変更の影響を受けないグランドファザリング設計を考慮してください。
    3.  **Display Sync**: 価格変更がフロントエンド（LP、料金ページ等）に即座に反映されるようキャッシュ無効化戦略を設計してください。
    4.  **Server-Side Recalculation**: 価格・割引の最終計算は必ず**サーバーサイド**で再実行してください。フロントエンドでの表示価格はあくまで「参考価格」であり、決済処理時にサーバーサイドで再計算することで、フロントエンドの改ざんリスクを根本から低減します。

### 7.3. The Pricing AB Test Protocol (価格A/Bテスト実験基盤)
*   **Context**: 価格やプラン構成の最適化は、データに基づくA/Bテストにより継続的に行うべきですが、テストのたびにコード変更を要する設計では実験速度が著しく低下します。
*   **Law**: 価格・プラン・割引率の変更をコードデプロイなしに実験可能な基盤を構築してください。
*   **Action**:
    1.  **Feature Flag Integration**: 価格表示やプラン構成の切り替えにフィーチャーフラグ（Feature Flag）を使用し、ユーザーセグメント別にA/Bバリアントを配信可能にしてください。
    2.  **Conversion Tracking**: 各バリアントのコンバージョン率（CVR）・平均単価（ARPU）・チャーン率を自動計測し、統計的有意性の判定を支援するダッシュボード基盤を設計してください。
    3.  **Grandfathering Guard**: A/Bテスト中に契約した既存ユーザーの価格は、テスト終了後も当初の価格を維持するグランドファザリング設計を必ず考慮してください。

---

## Appendix A: 逆引き索引

| キーワード | セクション | 関連ルール |
|-----------|----------|-----------|
| LTV / CAC | §1 | `102_growth_marketing`, `720_cloud_finops` |
| サブスクリプション / SaaS | §2 | `103_appstore_compliance` |
| 決済 / Stripe | §3 | `600_security_privacy`, `601_data_governance` |
| ポイント経済圏 | §4 | `400_ai_engineering` |
| 広告管理 | §5 | `102_growth_marketing` |
| AIトークンエコノミクス | §6 | `400_ai_engineering`, `720_cloud_finops` |
| 価格戦略 / プロモーション | §7 | `102_growth_marketing` |
| チャーン / リテンション | §1, §7 | `102_growth_marketing`, `501_customer_experience` |
| コンプライアンス / 税務 | §3 | `103_appstore_compliance`, `601_data_governance` |
