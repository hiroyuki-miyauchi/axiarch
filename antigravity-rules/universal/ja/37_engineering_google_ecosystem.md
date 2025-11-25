# 37. エンジニアリング: Googleエコシステムと重要フロー (Engineering: Google Ecosystem & Critical Flows)

## 1. 哲学: "Google First" と継続的進化 (Philosophy: "Google First" & Continuous Evolution)
### 1.1. Google First 戦略 (Google First Strategy)
*   **デフォルトの選択**: 技術選定においては、**Googleエコシステム**（Firebase, GCP, Android, Flutter, Maps, AI）を最優先します。
    *   **理由**: シームレスな統合、世界クラスのスケーラビリティ、統一された請求/管理を実現するためです。
    *   **例外ポリシー**: サードパーティ製ツール（RevenueCat, Auth0など）は、Google純正品と比較して**圧倒的な**利点（クロスプラットフォームUX、安定性、開発者体験）がある場合にのみ採用します。

### 1.2. 継続的なトレンド分析 (Continuous Trend Analysis)
*   **義務**: エンジニアは常に最新のトレンド（Firebase IAP拡張機能、新しいGCP AIモデルなど）を監視し続ける義務があります。
*   **見直し**: Google純正ソリューションが進化し、サードパーティ製ツールの品質に追いついた場合は、**Google純正へ回帰（マイグレーション）**します。

## 2. Googleエコシステム戦略 (Google Ecosystem Strategy)
### 2.1. Google Maps Platform
*   **コスト最適化**:
    *   **Static Maps を優先**: 非対話型のビュー（レシート詳細、リストのサムネイルなど）には**Maps Static API**を使用し、コストを大幅に削減します。
    *   **遅延ロード**: マップコンポーネントは、ビューポートに入ったときにのみロードします。
    *   **セッション課金**: **Places Autocomplete**には必ずセッショントークンを使用し、クエリを単一の課金対象セッションにまとめます。
*   **パフォーマンス**:
    *   **ベクターマップ**: よりスムーズなレンダリングとデータ使用量削減のために、Vector Maps (Android/iOS SDK v18+) を使用します。

### 2.2. Firebase & GCP
*   **Firestore 戦略 (NoSQL 最適化)**:
    *   **フラットなデータ構造**: 深いネストを避けます。スケーラビリティのために**ルートレベルコレクション**（例：`users/{uid}/posts` ではなく `posts/{postId}`）を使用します。
    *   **非正規化**: Read回数を最小化するためにデータを重複（非正規化）させます。**書き込みストレージではなく、読み取りパフォーマンスを最適化します。**
    *   **App Check**: 不正なトラフィック（ボット）をブロックするため、本番アプリでは必須とします。
*   **Security & Networking**:
    *   **VPC Service Controls**: エンタープライズグレードの保護のために、VPC Service Controlsを使用して機密リソース（Cloud Functions, Firestore）の周囲にセキュリティ境界を定義します。
    *   **WAF**: カスタムエンドポイントを公開する場合は、Google Cloud Armorを使用します。

## 3. グロース・エコシステム (Growth Ecosystem)
*   **Remote Config**:
    *   **オンボーディングA/Bテスト**: オンボーディングのステップ数や文言はハードコードせず、**Firebase Remote Config** で管理します。これにより、アプリのアップデートなしでフローを最適化（A/Bテスト）可能にします。
    *   **機能フラグ (Feature Flags)**: 新機能のロールアウトはRemote Configで行い、問題が発生した際に即座に無効化（キルスイッチ）できるようにします。

## 3. 重要フロー (Critical Flows)
### 3.1. 課金 (In-App Purchases)
*   **現在の標準: RevenueCat**:
    *   **例外理由**: クロスプラットフォーム（iOS/Android/Web）でのエンタイトルメント管理、レシート検証、分析において、現状Google純正のみで構築するよりも圧倒的に優れているためです。
    *   **Google連携**: RevenueCatは必ず**Firebase**と連携（Extensions/Webhooks経由）させ、サブスクリプション状態をFirestoreに同期します。
*   **サーバーサイド検証**: RevenueCatを使用する場合でも、バックエンドで**Webhooks**をリッスンし、ステータスを同期してアクセス権の付与/剥奪を安全に行います。**クライアントサイドのみを信頼してはなりません。**

### 3.2. 認証とセッション (Authentication & Session)
*   **アカウント削除**: App Store/Play Storeのガイドラインに完全に準拠した**アカウント削除**機能を実装します（即時かつ分かりやすい場所に配置）。

## 4. データ安全性 (Data Safety & Integrity)
### 4.1. 論理削除 (Soft Delete)
*   **ルール**: ユーザーデータを**物理的に即時削除しません**（明示的な「アカウント削除」リクエストやGDPR対応を除く）。
*   **実装**: `isDeleted`（ブール値）または`deletedAt`（タイムスタンプ）フィールドを使用します。

### 4.2. バックアップ (Backups)
*   **自動バックアップ**: Firestore/Cloud SQLの自動日次バックアップを有効にします。
*   **PITR**: 重要なデータベースに対してポイントインタイムリカバリ（PITR）を有効にし、特定の不正デプロイメントから復旧できるようにします。
