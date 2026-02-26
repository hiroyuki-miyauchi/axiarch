# 10. プロダクトとビジネス戦略 (Product & Business Strategy)

> [!IMPORTANT]
> **ビジネスの鉄則 (Business Iron Rule)**
> 我々は慈善事業ではありません。しかし、**「法と倫理 (Legal & Ethics)」を犯してまで得る利益に価値はありません**。
> Level 1 (Legal) > Level 3 (Profit) の優先順位を絶対とします。

## 7. 組織DNAフレームワーク (Organizational DNA Frameworks)
*   **Working Backwards (Amazon)**:
    *   **プレスリリース駆動開発**: コードを書く前に、まず「完成時のプレスリリース」と「FAQ」を書きます。顧客が何に喜び、何に疑問を持つかを完全に定義してから、そこから逆算して開発します。
*   **Day 1 Philosophy**:
    *   顧客への執着、結果へのコミットメント、高速な意思決定。大企業病（Day 2）を徹底的に排除します。

## 8. 検索・発見アーキテクチャ (Search & Discovery Architecture)

### 8.1. The Tag-Based Attribute Protocol (タグベース属性設計)
*   **Law**: エンティティ（商品、店舗、記事等）の可変属性（特徴、対応条件等）は、専用カラムの追加ではなく、**タグ（M:N リレーション）** として構造化してください。
*   **Action**:
    1.  **Master Table**: タグの種類を管理するマスターテーブルを用意し、`category`（分類）と `slug`（検索用キー）を定義します。
    2.  **Junction Table**: エンティティとタグの関連付けは中間テーブル（Junction Table）で管理し、動的なフィルタリング・検索を可能にします。
    3.  **No Column Explosion**: 「特徴A対応」「特徴B対応」のようなBoolean カラムの乱立は、スキーマの肥大化と検索クエリの複雑化を招くため禁止します。

### 8.2. The Structured Business Hours Protocol (営業時間の構造化)
*   **Law**: 営業時間は自由テキストではなく、**JSONB 型の構造化データ** として管理してください。
*   **Schema Standard**:
    *   曜日ごとの開始・終了時刻を配列で保持し、複数の営業時間帯（ランチ・ディナー等）に対応します。
    *   休業日は `null` または空配列で表現し、臨時休業にも柔軟に対応します。
*   **Timezone Strategy**: 表示層では、サービスのターゲット市場のタイムゾーン（例: JST）を基準として表示してください。内部保存は UTC を標準とし、表示時に変換します。
*   **Holiday Priority**: 祝日・臨時休業テーブル（例: `entity_holidays`）を用意し、通常の曜日スケジュールより**祝日設定を優先**して判定してください。
*   **Search Optimization**: 「現在営業中」等のリアルタイム検索のために、リクエスト時の時刻計算ではなく、トリガーやバッチで更新される事前計算カラム（例: `next_open_at`, `is_currently_open`）の活用を推奨します。

### 8.3. The Search Freshness SLA (検索鮮度保証)
*   **Law**: ユーザーが更新したデータが検索結果に反映されるまでの遅延（Staleness）に対し、SLA（Service Level Agreement）を定義してください。
*   **Standard**:
    *   **Critical Data** (在庫、価格、ステータス): **5分以内** に検索インデックスに反映。
    *   **Content Data** (説明文、画像): **1時間以内** に反映。
*   **Action**: 検索インデックスの更新トリガー（Webhook、Realtime Subscription、定期バッチ）を適切に設計し、SLA を満たすアーキテクチャを構築してください。
*   **Cache Purge Sync**: 検索インデックスの即時反映が実現されていても、CDNやアプリケーションキャッシュのパージ漏れにより古いデータが表示されるリスクがあります。データ更新時にはキャッシュタグ（例: `revalidateTag`）のパージも同期的に実行してください。

## 9. レビュー・信頼性システム (Review & Trust System)

### 9.1. The Bayesian Average Protocol (ベイズ平均評価)
*   **Law**: レビュー評価の集計には、**単純平均ではなくベイズ平均（Bayesian Average）** を使用してください。
*   **Reason**: レビュー件数が少ない段階では、1件の極端な評価（星5 or 星1）が平均値を大きく歪めます。ベイズ平均はグローバル平均を事前分布として組み込むことで、少数レビューの偏りを緩和します。
*   **Formula**: `bayesian_score = (C × m + Σ(ratings)) / (C + n)` （C: 信頼しきい値、m: グローバル平均、n: レビュー数）
*   **Pre-calculation**: 計算はリクエストごとに行わず、レビュー投稿・更新時にバッチまたはトリガーで事前計算し、エンティティテーブルのカラム（例: `bayesian_score`）に保存してください。

### 9.2. The Pre-Moderation Protocol (事前モデレーション)
*   **Law**: ユーザー生成コンテンツ（UGC）、特にレビューは、**公開前にモデレーション（審査）を通過** させることを標準とします。
*   **Action**:
    1.  **Status Flow**: レビューのステータスは `pending → approved / rejected` の3状態で管理します。
    2.  **Visibility**: `approved` のレビューのみを公開クエリに含め、未審査レビューはユーザーには「審査中」と表示します。
    3.  **Automation**: スパム検知や禁止語句フィルタリングを自動化し、人的モデレーションコストを削減してください。
    4.  **Self-Review Ban**: エンティティの所有者（店舗オーナー等）による自身のエンティティへの投稿は、システム的にブロックしてください。利害関係者の自己レビューは信頼性を毀損します。
    5.  **Trusted User Exception**: 一定の信頼スコアを獲得したユーザー（例: 過去N件以上の承認済みレビュー）については、事前モデレーションをスキップする例外を設けることで、審査コストとユーザー体験のバランスを取ってください。

### 9.3. The Immutable Deletion Protocol (不変削除)
*   **Law**: 一度公開されたレビューデータは、**論理削除（Soft Delete）** を標準とし、物理削除は原則禁止とします。
*   **Reason**: レビューの集計スコア（ベイズ平均）の整合性を保つため、および不正操作（都合の悪いレビューの削除）の監査を可能にするためです。
*   **Action**: 削除フラグ（`deleted_at`）を設定し、公開クエリからは除外しますが、DB上にはレコードを保持してください。
*   **Destructive Action Confirmation**: レビューの論理削除は不可逆的な影響（集計スコアへの反映等）を伴うため、管理画面での削除操作時には **確認ワード入力**（例: 「delete」のタイプ）を必須とし、誤操作を防止してください。

## 10. インタラクティブエンジン (Interactive Engine)

### 10.1. The Unified Interactive Schema (統一インタラクティブスキーマ)
*   **Law**: 投票、診断、クイズ、アンケート等のインタラクティブコンテンツは、個別テーブルではなく **統一されたスキーマ（Polymorphic Pattern）** で管理してください。
*   **Action**:
    1.  **Single Table**: `interactive_contents` テーブルに `type` カラム（`poll`, `quiz`, `survey` 等）を持たせ、設問・選択肢は JSONB で保持します。
    2.  **Responses Table**: 回答は `interactive_responses` テーブルに集約し、`content_id` で紐付けます。
    3.  **Extensibility**: 新しいインタラクティブタイプの追加が、テーブル追加なしに `type` の値の追加のみで可能な設計を維持してください。
    4.  **Deterministic Logic**: 診断やクイズの結果算出アルゴリズムは、**ランダムではなく決定論的**（点数計算等）に実装してください。AI を利用する場合でも、同一入力に対する結果の再現性を担保し、ユーザーからの問い合わせ時に結果を追跡可能にします。
