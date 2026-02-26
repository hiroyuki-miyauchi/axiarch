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
    *   **Storage Tiering Protocol**: アクセス頻度の低いログやアーカイブデータは、Hot Storage（高価）から Cold Storage（S3 Glacier / R2 等の低価格帯）へ移動するライフサイクルポリシーを設定し、ストレージコストを最適化します。
    *   **Cache Hierarchy Standard (Cache-First FinOps)**: DB負荷とコストを最小化するため、全てのクエリに以下のキャッシュ階層を適用します。
        *   **STATIC (86400s)**: マスタデータ（カテゴリ、設定値）— DB負荷ゼロ。
        *   **WARM (300s)**: 検索結果、一覧リスト。
        *   **HOT (60s)**: 詳細ページ、レビュー。
        *   **REALTIME (0s)**: 決済、認証 — キャッシュ禁止。
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
