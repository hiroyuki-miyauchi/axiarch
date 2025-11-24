# 37. Engineering: Google Ecosystem & Critical Flows

## 1. Philosophy: "Google First" & Continuous Evolution

### 1.1. Google First Strategy
*   **Default Choice**: 技術選定においては、**Googleエコシステム**（Firebase, GCP, Android, Flutter, Maps, AI）を最優先する。
    *   **Why**: シームレスな統合、世界クラスのスケーラビリティ、統一された請求/管理を実現するため。
    *   **Exception Policy**: サードパーティ製ツール（RevenueCat, Auth0など）は、Google純正品と比較して**圧倒的な**利点（クロスプラットフォームUX、安定性、開発者体験）がある場合にのみ採用する。
# 37. エンジニアリング: Googleエコシステムと重要フロー (Engineering: Google Ecosystem & Critical Flows)

## 1. 哲学: "Google First" と継続的進化 (Philosophy: "Google First" & Continuous Evolution)

### 1.1. Google First 戦略 (Google First Strategy)
*   **デフォルトの選択**: 技術選定においては、**Googleエコシステム**（Firebase, GCP, Android, Flutter, Maps, AI）を最優先する。
    *   **理由**: シームレスな統合、世界クラスのスケーラビリティ、統一された請求/管理を実現するため。
    *   **例外ポリシー**: サードパーティ製ツール（RevenueCat, Auth0など）は、Google純正品と比較して**圧倒的な**利点（クロスプラットフォームUX、安定性、開発者体験）がある場合にのみ採用する。

### 1.2. 継続的なトレンド分析 (Continuous Trend Analysis)
*   **義務**: エンジニアは常に最新のトレンド（Firebase IAP拡張機能、新しいGCP AIモデルなど）を監視し続ける義務がある。
*   **見直し**: Google純正ソリューションが進化し、サードパーティ製ツールの品質に追いついた場合は、**Google純正へ回帰（マイグレーション）**する。
*   **優先順位**: **セキュリティ > パフォーマンス > UX > コスト > トレンド**。セキュリティやユーザー体験を犠牲にしてまでトレンドを採用してはならない。

## 2. Googleエコシステム戦略 (Google Ecosystem Strategy)

### 2.1. Google Maps Platform (Google Maps Platform)
*   **コスト最適化**:
    *   **Static Maps を優先**: 非対話型のビュー（レシート詳細、リストのサムネイルなど）には**Maps Static API**を使用し、コストを大幅に削減する。
    *   **遅延ロード**: マップコンポーネントは、ビューポートに入ったときにのみロードする。
    *   **セッション課金**: **Places Autocomplete**には必ずセッショントークンを使用し、クエリを単一の課金対象セッションにまとめる。
*   **パフォーマンス**:
    *   **ベクターマップ**: よりスムーズなレンダリングとデータ使用量削減のために、Vector Maps (Android/iOS SDK v18+) を使用する。
    *   **軽量マーカー**: マーカーにはシンプルなPNGまたは最適化されたベクタードローアブルを使用する。複雑なSVGの動的レンダリングは避ける。

### 2.2. Firebase & GCP (Firebase & GCP)
*   **Firestore 戦略 (NoSQL 最適化)**:
    *   **フラットなデータ構造**: 深いネストを避ける。スケーラビリティのために**ルートレベルコレクション**（例：`users/{uid}/posts` ではなく `posts/{postId}`）を使用する。
    *   **非正規化**: Read回数を最小化するためにデータを重複（非正規化）させる（例：`posts` 内に `authorName` を持たせる）。**書き込みストレージではなく、読み取りパフォーマンスを最適化する。**
    *   **App Check**: 不正なトラフィック（ボット）をブロックするため、本番アプリでは必須とする。
*   **Security & Networking**:
    *   **VPC Service Controls**: エンタープライズグレードの保護のために、VPC Service Controlsを使用して機密リソース（Cloud Functions, Firestore）の周囲にセキュリティ境界を定義する。
    *   **WAF**: カスタムエンドポイントを公開する場合は、Google Cloud Armorを使用する。
*   **Auth**: コアIDプロバイダーとして**Firebase Authentication**を使用する。
    *   **MFA**: 管理者および高権限アカウントには多要素認証（MFA）を必須とする。
    *   **Social Login**: GoogleおよびApple Sign-Inを標準としてサポートする。
*   **Cloud Functions**: 同時実行性とパフォーマンス向上のため、**Gen 2**関数を使用する。
*   **AI Integration**: **Vertex AI** (Gemini API) をFirebase Extensionsまたはセキュアなバックエンド呼び出し経由で使用する。クライアントにAPIキーを絶対に露出させない。

## 3. Critical Flows (Billing & Auth)

### 3.1. Billing (In-App Purchases)
*   **Current Standard: RevenueCat**
    *   **Why Exception?**: AndroidのGoogle Play Billingは優秀だが、**RevenueCat**はクロスプラットフォーム（iOS/Android/Web）でのエンタイトルメント管理、レシート検証、分析において、現状Google純正のみで構築するよりも圧倒的に優れているため。
    *   **Google Integration**: RevenueCatは必ず**Firebase**と連携（Extensions/Webhooks経由）させ、サブスクリプション状態をFirestoreに同期する。
    *   **Review Trigger**: この選定は毎年再評価する。Firebaseが同等の「クロスプラットフォームIAP」拡張機能をリリースした場合、移行を計画する。
*   **Server-Side Validation**: RevenueCatを使用する場合でも、バックエンドで**Webhooks**をリッスンし、ステータスを同期してアクセス権の付与/剥奪を安全に行う。**クライアントサイドのみを信頼してはならない。**

### 3.2. Authentication & Session
*   **Token Management**: IDトークンのリフレッシュを自動的に処理する。
*   **Error Handling**: 認証フロー中のネットワーク障害を適切に処理する。明確でローカライズされたエラーメッセージを提供する（"Error 400"などは不可）。
*   **Account Deletion**: App Store/Play Storeのガイドラインに完全に準拠した**アカウント削除**機能を実装する（即時かつ分かりやすい場所に配置）。

## 4. Data Safety & Integrity

### 4.1. Soft Delete (Logical Deletion)
*   **Rule**: ユーザーデータを**物理的に即時削除しない**（明示的な「アカウント削除」リクエストやGDPR対応を除く）。
*   **Implementation**:
    *   **Flagging**: `isDeleted`（ブール値）または`deletedAt`（タイムスタンプ）フィールドを使用する。
    *   **Archiving**: 複雑なデータの場合、Cloud Functionsトリガーを使用して、削除されたドキュメントを`deleted_collections`または`archive`パスに移動する。
*   **Recovery**: 管理者が誤って削除されたデータを復元できるように、「ゴミ箱」または「復元」機能を提供する。

### 4.2. Backups
*   **Automated Backups**: Firestore/Cloud SQLの自動日次バックアップを有効にする。
*   **Point-in-Time Recovery (PITR)**: 重要なデータベースに対してPITRを有効にし、特定の不正デプロイメントから復旧できるようにする。

## 5. Admin Panel Strategy

### 5.1. Technology Choice
*   **Preference**: **Flutter Web**（アプリとコードを共有する場合）または**Retool/Low-Code**（開発速度優先の場合）。
*   **Separation**: 管理画面は、リスクを隔離するために、メインユーザーアプリとは別のプロジェクト/デプロイメントにする必要がある。

### 5.2. Security (RBAC)
*   **Role-Based Access Control**: 厳格なRBAC（スーパー管理者、サポート、コンテンツ編集者）を実装する。
*   **Read-Only Default**: デフォルトの権限は読み取り専用とする。書き込み権限は明示的に付与する。
*   **Audit Logs**: 管理画面での**すべての**書き込み操作（誰が、何を、いつ）を不変の監査ログコレクションに記録する。
