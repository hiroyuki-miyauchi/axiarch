# 32. バックエンドエンジニアリング (Backend Engineering - Firebase & GCP)

> [!CAUTION]
> **このファイルは Universal Rule（不変ルール）です。「憲法改正」の明示的指示がない限り編集禁止。**
> 改定日: 2026-03-24

> [!IMPORTANT]
> **Supreme Directive（最高指令）**
> 「Firebaseは"補助エンジン"であり、データの主権はSupabase (PostgreSQL)にある。」
> Firebase/GCPの実装において、**セキュリティ(App Check + Security Rules) > 信頼性(冪等性 + リトライ) > コスト効率(FinOps) > パフォーマンス > 開発生産性** の優先順位を厳守せよ。
> この文書はFirebase & GCPに関するすべての設計判断の最上位基準である。
> **55パート・Rule 32.1〜32.200+ ・Appendix A〜D 構成。**

> [!WARNING]
> **Deprecated / Auxiliary Mode Only**
> 本プロジェクトの **Single Source of Truth (SSOT)** は **Supabase (PostgreSQL)** です。
> Firestoreをユーザーデータやドメインデータの保存に使用することは原則禁止です。
> Firebaseの利用は、**FCM (Push Notification)**, **Google Analytics**, **Crashlytics**, **App Check**, **Remote Config** などの「周辺機能」に限定してください。

---

## 目次

**I. 基盤・哲学**
- §0. 至高の命令 (Supreme Directives)
- §1. Firebase プロジェクト戦略 & GCP 統合

**II. コンピュート**
- §2. Cloud Run Functions（旧 Cloud Functions 2nd Gen）
- §3. Cloud Run Services & Jobs

**III. イベント駆動**
- §4. イベント駆動設計 (Eventarc / Pub/Sub / Cloud Tasks)

**IV. 認証・認可**
- §5. Firebase Authentication 戦略
- §6. App Check & アプリ認証

**V. データベース**
- §7. Firestore 設計 & Security Rules
- §8. Firebase Data Connect (Cloud SQL) — GA

**VI. ストレージ・ホスティング**
- §9. Cloud Storage for Firebase
- §10. Firebase Hosting & App Hosting (GA)

**VII. クライアントサービス**
- §11. FCM (Push Notification) 戦略
- §12. Remote Config & Feature Flags
- §13. Crashlytics & 安定性監視
- §14. Performance Monitoring
- §15. Google Analytics for Firebase

**VIII. AI & ML**
- §16. Firebase AI Logic & Genkit
- §17. Vertex AI 連携
- §18. AI Agent セキュリティ & ガバナンス

**IX. データ分析・拡張**
- §19. Firebase Extensions 戦略
- §20. BigQuery 連携 & データ分析基盤

**X. セキュリティ多層防御**
- §21. セキュリティ多層防御 (Zero Trust)
- §22. IAM & サービスアカウント管理
- §23. Secret Manager & 機密情報管理
- §24. VPC & ネットワークセキュリティ

**XI. FinOps**
- §25. FinOps & コスト最適化
- §26. 予算アラート & 自動応答

**XII. 可観測性**
- §27. Observability (Cloud Logging / Monitoring / Trace)
- §28. エラーハンドリング & リトライ戦略

**XIII. IaC・CI/CD**
- §29. Terraform / IaC 管理
- §30. Firebase CLI & ローカル開発
- §31. Emulator Suite & テスト戦略
- §32. CI/CD パイプライン統合
- §33. 環境管理 (Dev / Staging / Prod)

**XIV. DR・スケーラビリティ**
- §34. マルチリージョン & DR戦略

**XV. API・キャッシュ**
- §35. API 設計 & エンドポイント管理
- §36. Rate Limiting & API 保護
- §37. キャッシング戦略

**XVI. バッチ・パイプライン**
- §38. バッチ処理 & データパイプライン

**XVII. Google Ecosystem**
- §39. Google Maps Platform 最適化
- §40. Google Ecosystem 統合戦略

**XVIII. Firebase Studio**
- §41. Firebase Studio

**XIX. コンプライアンス・ガバナンス**
- §42. コンプライアンス & データ主権
- §43. サプライチェーンセキュリティ

**XX. 運用・成熟度**
- §44. 運用成熟度モデル
- §45. マイグレーション & 廃止戦略
- §46. トラブルシューティング & デバッグ

**XXI. 言語固有: Node.js (TypeScript)**
- §47. Node.js/TypeScript 固有設計
- §48. Node.js パフォーマンス & テスト
- §49. Node.js デプロイ & パッケージ管理

**XXII. 言語固有: Go**
- §50. Go 固有設計
- §51. Go パフォーマンス & テスト

**XXIII. 言語固有: Python**
- §52. Python 固有設計
- §53. Python パフォーマンス & テスト

**XXIV. アンチパターン・将来展望**
- §54. アンチパターン35選
- §55. 将来展望

**Appendix**
- Appendix A: サービス別逆引き索引
- Appendix B: クロスリファレンス
- Appendix C: FinOps チェックリスト
- Appendix D: セキュリティチェックリスト

---

## §0. 至高の命令 (Supreme Directives)

### Supreme Directive 0.1: Auxiliary Engine Principle（補助エンジン原則）
-   **Law**: Firebaseは「補助エンジン」であり、**データの主権はSupabase (PostgreSQL)** に存在する。Firestoreへの新規データ保存は原則禁止。
-   **Mandate**:
    1.  **Data Sovereignty**: ユーザーデータ・ドメインデータは全てSupabaseに保存する。Firestoreはレガシー保守のみ許可。
    2.  **Peripheral Services Only**: Firebase利用はFCM、Analytics、Crashlytics、App Check、Remote Config、Performance Monitoring等の周辺機能に限定する。
    3.  **No New Firestore Collections**: 新規コレクションの作成は禁止。既存コレクションの保守のみ許可。

### Supreme Directive 0.2: Defense in Depth（多層防御原則）
-   **Law**: セキュリティは単一レイヤーに依存してはならない。App Check + Security Rules + IAM + VPCの多層防御を必須とする。
-   **Mandate**:
    1.  **App Check Mandatory**: 全てのFirebaseサービスおよびカスタムバックエンドでApp Checkを有効化する。
    2.  **Least Privilege**: 全てのサービスアカウントとIAMロールは最小権限の原則に従う。`roles/owner`の本番使用は禁止。
    3.  **Zero Trust Network**: VPC Service ControlsとPrivate Google Accessを活用し、信頼境界を最小化する。

### Supreme Directive 0.3: Idempotency First（冪等性最優先原則）
-   **Law**: 全てのCloud Run FunctionsおよびCloud Runサービスは冪等に設計しなければならない。
-   **Mandate**:
    1.  **Event ID Deduplication**: イベントトリガー関数は`eventId`による重複排除を実装する。
    2.  **Transactional Writes**: Firestoreへの書き込みはトランザクションまたはバッチ書き込みを使用する。
    3.  **Retry Safety**: リトライにより副作用が重複しないことを保証する。

### Supreme Directive 0.4: FinOps Guardian（コスト監視原則）
-   **Law**: クラウドコストは「技術的負債」と同等の管理対象である。予算超過は障害と同等に扱う。
-   **Mandate**:
    1.  **Budget Alerts**: 全プロジェクトに50%/80%/100%/120%の予算アラートを設定する。
    2.  **Automated Response**: 100%超過時はCloud Run Functionsで自動的に非クリティカルリソースを停止する。
    3.  **Cost Tagging**: 全GCPリソースに`environment`/`service`/`owner`ラベルを付与する。

### Supreme Directive 0.5: Cloud Run Unified（Cloud Run統一原則）
-   **Law**: 2025年以降、Cloud Functions (2nd Gen) は**Cloud Run Functions**に名称変更された。全てのサーバーレスコンピュートはCloud Runファミリーとして統一的に管理する。
-   **Mandate**:
    1.  **Naming**: ドキュメント・コード・IaCにおいて「Cloud Run Functions」の名称を使用する。
    2.  **Unified Management**: Cloud Run Functions、Cloud Run Services、Cloud Run Jobsを統一的に監視・管理する。
    3.  **Migration Path**: 1st Gen Functionsは速やかにCloud Run Functionsへ移行する。

---

## §1. Firebase プロジェクト戦略 & GCP 統合

### Rule 32.1: プロジェクト分離戦略
-   **Mandate**: 環境ごとにFirebaseプロジェクト/GCPプロジェクトを分離する。
-   **Structure**:
    ```
    myapp-dev      → 開発環境（自由にテスト可能）
    myapp-staging  → ステージング環境（本番同等構成）
    myapp-prod     → 本番環境（厳格なIAM制御）
    ```
-   **Rationale**: 環境分離により、開発ミスが本番に影響するリスクを物理的に排除。課金・アクセス制御も分離。

### Rule 32.2: GCPプロジェクト構成
-   **Mandate**: Firebaseプロジェクトは常にGCPプロジェクトの上に構築される。
-   **Configuration**:
    -   **Organization**: GCP Organizationの下にフォルダ構造を設定し、ポリシーを階層的に適用。
    -   **Billing Account**: 環境ごとに予算を設定し、本番と開発の課金を分離。
    -   **API Enablement**: 必要なAPIを明示的に有効化する（`firebase.googleapis.com`, `run.googleapis.com`, `artifactregistry.googleapis.com`等）。

### Rule 32.3: リージョン選定
-   **Mandate**: サービスのリージョンは一貫性を保つ。Cloud Run Functions、Cloud Run、Firestoreは同一リージョンに配置する。
-   **Recommended**: `asia-northeast1`（東京）を日本向けサービスのデフォルトとする。
-   **Caution**: Firestoreのリージョンは作成後に変更不可。初期設定を慎重に行う。
-   **GPU Availability**: Cloud Run GPU（NVIDIA L4 GA / RTX PRO 6000 Blackwell Preview）は特定リージョンのみ対応（`us-central1`, `europe-west1`, `europe-west4`, `asia-southeast1`, `asia-south1`等）。AI推論ワークロードのリージョン選定時に考慮。

### Rule 32.4: Blaze Plan 必須化
-   **Mandate**: 2026年2月3日以降、全FirebaseプロジェクトにBlazeプラン（従量課金）が必須。SparkプランではCloud Storage等の主要機能が利用不可。
-   **Action**: 全プロジェクトをBlazeプランに移行し、予算アラートを必ず設定する（§26参照）。

---

## §2. Cloud Run Functions（旧 Cloud Functions 2nd Gen）

### Rule 32.5: Cloud Run Functions 標準化
-   **Mandate**: 新規のサーバーレス関数は**Cloud Run Functions**を使用する。1st Genの新規作成は禁止。
-   **Advantage**:
    -   Cloud Run基盤による高性能（最大32GB RAM、8 vCPU）
    -   並列処理（Concurrency）対応（デフォルト80、最大1000）
    -   Eventarcによる125+イベントソース対応
    -   トラフィック分割・リビジョンロールバック
    -   HTTP関数は最大1時間実行可能
-   **Supported Runtimes（2026年3月時点）**: Node.js 22/24、Go 1.23/1.24/1.26、Python 3.12/3.13/3.14、Java 21/25、Ruby 3.3/4.0、PHP 8.4/8.5、.NET 8/10。

### Rule 32.6: コールドスタート対策
-   **Mandate**: レイテンシに敏感な関数にはコールドスタート対策を必ず実装する。
-   **Strategies**:
    1.  **Min Instances**: ログイン・決済等のクリティカル関数は`minInstances: 1`以上を設定。
    2.  **Concurrency活用**: 並列処理により、単一インスタンスで複数リクエストを処理。
    3.  **グローバル変数の再利用**: DB接続やHTTPクライアントはグローバルスコープで初期化し、呼び出し間で再利用する。
    4.  **軽量な初期化**: 重い初期化はLazy Loadingで遅延実行する。
    5.  **Cloud Schedulerによるウォームアップ**: 低頻度呼び出し関数は定期的にpingを送信。

```typescript
// ✅ Good: グローバル変数でDB接続を再利用
import { initializeApp } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";

const app = initializeApp();
const db = getFirestore(app);

export const myFunction = onRequest(
  { minInstances: 1, concurrency: 80, memory: "512MiB" },
  async (req, res) => {
    const doc = await db.collection("config").doc("main").get();
    res.json(doc.data());
  }
);
```

### Rule 32.7: ランタイム設定
-   **Mandate**: 全ての関数にリソース制限とタイムアウトを明示的に設定する。デフォルト値に依存しない。
-   **Configuration**:
    ```typescript
    export const processOrder = onRequest({
      region: "asia-northeast1",
      memory: "512MiB",
      timeoutSeconds: 120,
      minInstances: 1,
      maxInstances: 100,
      concurrency: 80,
      cpu: 1,
    }, handler);
    ```
-   **Guidelines**:
    | 用途 | Memory | Timeout | Min Instances | Concurrency |
    |---|---|---|---|---|
    | APIエンドポイント | 256-512MiB | 60s | 1 | 80 |
    | 画像処理 | 1-2GiB | 300s | 0 | 10 |
    | バッチ処理 | 2-4GiB | 540s | 0 | 1 |
    | Webhook受信 | 256MiB | 30s | 0 | 80 |
    | AI推論（CPU） | 4-8GiB | 300s | 0 | 4 |
    | Genkit AIフロー | 1-2GiB | 120s | 0-1 | 20 |

### Rule 32.8: 関数の組織化
-   **Mandate**: 関数は機能モジュール単位でファイルを分割し、Codebases機能を活用する。
-   **Structure**:
    ```
    functions/
    ├── src/
    │   ├── api/          # HTTP API関数
    │   ├── triggers/     # Firestoreトリガー
    │   ├── scheduled/    # スケジュール関数
    │   ├── pubsub/       # Pub/Subトリガー
    │   ├── tasks/        # Cloud Tasks ハンドラー
    │   ├── genkit/       # Genkit AIフロー
    │   └── shared/       # 共通ユーティリティ
    ├── package.json
    └── tsconfig.json
    ```
-   **Deployment**: 大量の関数をデプロイする場合は10関数以下のグループに分割。

### Rule 32.9: 冪等性の実装
-   **Mandate**: 全てのイベントトリガー関数は冪等に設計する。
-   **Pattern**:
    ```typescript
    export const onOrderCreated = onDocumentCreated(
      "orders/{orderId}",
      async (event) => {
        const eventId = event.id;
        
        // 重複排除: 処理済みイベントをスキップ
        const processedRef = db.collection("processedEvents").doc(eventId);
        const processed = await processedRef.get();
        if (processed.exists) {
          console.log(`Event ${eventId} already processed. Skipping.`);
          return;
        }
        
        await processOrder(event.data);
        await processedRef.set({ processedAt: FieldValue.serverTimestamp() });
      }
    );
    ```

### Rule 32.10: 1st Gen → Cloud Run Functions 移行
-   **Mandate**: 1st Gen FunctionsはCloud Run Functionsへ速やかに移行する。
-   **Migration Tool**: GCPが提供するアップグレードツール（Preview）を活用。
-   **Breaking Changes**: Eventarc統合によるトリガー構文変更に注意。

### Rule 32.11: onCallGenkit トリガー
-   **Mandate**: Genkit AIフローをCallable Functionsとしてデプロイする場合、`onCallGenkit`トリガーを使用する。
-   **Benefit**: Firebase App Check自動統合、Firebase Auth自動検証、型安全なリクエスト/レスポンス。
    ```typescript
    import { onCallGenkit } from "firebase-functions/https";
    import { genkit } from "genkit";
    
    const ai = genkit({ plugins: [googleAI()] });
    
    const summarizeFlow = ai.defineFlow("summarize", async (input: string) => {
      const { text } = await ai.generate({ prompt: `Summarize: ${input}` });
      return text;
    });
    
    export const summarize = onCallGenkit(
      { enforceAppCheck: true },
      summarizeFlow
    );
    ```

---

## §3. Cloud Run Services & Jobs

### Rule 32.12: Cloud Run Functions vs Cloud Run Services 判断マトリクス
-   **Mandate**: 処理の性質に応じて適切に使い分ける。
-   **Decision Matrix**:
    | 要件 | Cloud Run Functions | Cloud Run Services |
    |---|---|---|
    | Firebaseイベントトリガー | ✅ 最適 | ❌ 不向き |
    | 軽量Webhook | ✅ 最適 | ○ 可能 |
    | 複雑なAPI（マルチルート） | △ 制限あり | ✅ 最適 |
    | Docker/カスタムランタイム | ❌ 不可 | ✅ 最適 |
    | バッチ処理（長時間） | △ 最大1h | ✅ 最大24h |
    | WebSocket/gRPC/SSE | ❌ 不可 | ✅ 最適 |
    | GPU（AI推論） | ❌ 不可 | ✅ L4 GPU GA |
    | Genkit AIフロー | ✅ onCallGenkit | ✅ HTTP Server |

### Rule 32.13: Cloud Run Services 設計
-   **Mandate**: Cloud Run Servicesはステートレスかつコンテナ化された設計とする。
-   **Best Practices**:
    1.  **Stateless**: インスタンス間で状態を共有しない。状態はFirestore/Cloud SQL/Redisに保存。
    2.  **Fast Startup**: コンテナの起動時間を最小化（目標: 2秒以内、GPU: 5秒以内）。
    3.  **Health Check**: `/health`エンドポイントを実装し、Startup/Livenessプローブを有効化。
    4.  **Graceful Shutdown**: SIGTERMシグナルを適切にハンドリング（10秒以内にクリーンアップ完了）。

### Rule 32.14: Cloud Run GPU サポート（GA）
-   **Mandate**: AI推論・ML処理にはCloud Run GPU（NVIDIA L4 Tensor Core GA / RTX PRO 6000 Blackwell Preview）を活用する。
-   **Features**:
    -   秒単位課金、ゼロスケール対応
    -   約5秒で起動（ドライバプリインストール）
    -   Cloud Run SLA適用
-   **Use Cases**: LLM推論、画像生成、動画トランスコード、バッチAI処理
-   **Configuration**:
    ```yaml
    # Cloud Run Service with GPU
    metadata:
      annotations:
        run.googleapis.com/gpu-type: nvidia-l4
    spec:
      containers:
        - resources:
            limits:
              nvidia.com/gpu: "1"
              memory: "16Gi"
              cpu: "4"
    ```
-   **Available Regions**: `us-central1`, `europe-west1`, `europe-west4`, `asia-southeast1`, `asia-south1`。

### Rule 32.15: Cloud Run Jobs
-   **Mandate**: 実行完了型のバッチ処理にはCloud Run Jobsを使用する。
-   **Use Cases**: データエクスポート、レポート生成、大量メール送信、データマイグレーション、バッチAI推論。
-   **Configuration**:
    ```yaml
    taskCount: 10        # 並列タスク数
    maxRetries: 3        # リトライ回数
    timeout: 3600s       # タイムアウト（最大24h）
    ```

---

## §4. イベント駆動設計 (Eventarc / Pub/Sub / Cloud Tasks)

### Rule 32.16: 非同期処理の原則
-   **Mandate**: ユーザーの待機時間を最小化するため、重い処理は非同期に実行する。
-   **Anti-Pattern**: Cloud Run Functions内で外部API呼び出し・メール送信・画像処理を同期的に実行すること。

### Rule 32.17: Pub/Sub 設計パターン
-   **Mandate**: サービス間の疎結合な通信にはPub/Subを使用する。
-   **Best Practices**:
    1.  **Push vs Pull**: サーバーレスにはPush配信、常時稼働サービスにはPull配信。
    2.  **Exactly-Once配信**: Pull subscriptionで利用可能。メッセージ順序が重要な場合はOrdering Keys。
    3.  **フィルタリング**: サブスクリプションレベルのフィルタリングで不要なメッセージ処理を削減。
    4.  **バッチ送信**: パブリッシャー側でバッチングを有効化。
    5.  **フロー制御**: パブリッシャー・サブスクライバー双方で設定。
    6.  **Dead Letter Topic**: リトライ上限超過メッセージの退避先を必ず設定。
    7.  **メッセージサイズ**: 最大10MB。大きなペイロードはCloud Storage経由で参照渡し。

### Rule 32.18: Cloud Tasks
-   **Mandate**: レート制御が必要な非同期タスクにはCloud Tasksを使用する。
-   **Best Practices**:
    1.  **Concurrency制御**: ダウンストリームサービスへの同時実行数を制御。
    2.  **指数バックオフ**: ジッター付き指数バックオフを必ず設定。
    3.  **IAMセキュリティ**: タスクの作成・消費にIAMポリシーを適用。
    4.  **スケジュール実行**: 将来の特定時刻に実行するタスクの設定。
    5.  **重複排除**: タスク名にユニークIDを含めて冪等性を保証。

### Rule 32.19: Eventarc
-   **Mandate**: GCPサービスからのイベント駆動処理にはEventarcを使用する。
-   **Supported Sources**: Cloud Audit Logs、Cloud Storage、Firestore、Firebase Authentication、BigQuery、Cloud SQL等125+のイベントソース。
-   **Advanced Channel**: カスタムイベントの発行にはEventarc Advancedチャネルを活用。

### Rule 32.20: Cloud Scheduler
-   **Mandate**: 定期実行タスクにはCloud Schedulerを使用する。
-   **Integration Pattern**:
    ```
    Cloud Scheduler → Pub/Sub Topic → Cloud Run Functions/Services
    Cloud Scheduler → Cloud Tasks Queue → Cloud Run
    Cloud Scheduler → HTTP Endpoint → Cloud Run Functions (ウォームアップ用)
    ```

### Rule 32.21: Cloud Workflows
-   **Mandate**: 複数のGCPサービスを順序制御付きでオーケストレーションする場合、Cloud Workflowsを活用する。
-   **Use Cases**: 承認フロー、マルチステップデータ処理、Saga Pattern実装。
-   **Benefit**: ステート管理・エラーハンドリング・リトライが宣言的に定義可能。

---

## §5. Firebase Authentication 戦略

### Rule 32.22: 認証プロバイダ方針
-   **Mandate**: Firebase Authenticationは「認証レイヤー」として利用し、ユーザーデータはSupabaseに保存する。
-   **Recommended Providers**:
    | プロバイダ | 用途 | 優先度 |
    |---|---|---|
    | Google Sign-In | 一般ユーザー認証 | 最優先 |
    | Apple Sign-In | iOSアプリ（App Store要件） | 必須（iOS） |
    | Email/Password | フォールバック認証 | 標準 |
    | Phone (SMS) | MFA・電話認証 | オプション |
    | Anonymous | ゲストアクセス | 限定的 |
    | SAML/OIDC | エンタープライズSSO | 要件次第 |
-   **Prohibited**: 認証なしでのFirestoreアクセスは禁止。

### Rule 32.23: Passkeys / FIDO2 対応
-   **Mandate**: パスワードレス認証としてPasskeys (FIDO2)の導入を推奨する。
-   **Implementation**: Firebase Authentication with Identity Platform（GCIP）の`Passkey`プロバイダを使用。
-   **Benefit**: フィッシング耐性、パスワードリスト攻撃の排除、ユーザーUXの向上。

### Rule 32.24: Custom Claims（カスタムクレーム）
-   **Mandate**: ロールベースアクセス制御（RBAC）にはCustom Claimsを使用する。
-   **Rules**:
    1.  Admin SDKでのみ設定（クライアントからの設定は禁止）。
    2.  ペイロードは1000バイト以内に制限。
    3.  変更はトークンリフレッシュまで反映されない。1時間の猶予を考慮した設計とする。
    ```typescript
    // Admin SDK: カスタムクレーム設定
    await admin.auth().setCustomUserClaims(uid, {
      role: "admin",
      plan: "premium",
    });
    ```

### Rule 32.25: Token管理とセッション設計
-   **Mandate**: ID TokenのTTLはデフォルト1時間。長時間セッションにはRefresh Tokenを使用する。
-   **Security**:
    1.  Refresh TokenはHTTP-only Cookieに保存。LocalStorage/SessionStorageへの保存は禁止。
    2.  Token Revocationを実装し、アカウント侵害時に即座に無効化可能にする。
    3.  Multi-Factor Authentication (MFA) を管理者・高権限ユーザーに必須化。

### Rule 32.26: 認証イベント監視
-   **Mandate**: 認証イベント（ログイン、失敗、アカウント作成）をCloud Loggingにストリームし、不正アクセスを検知する。
-   **Detectable Events**: 異常なログイン頻度、地理的異常、ブルートフォースパターン。

---

## §6. App Check & アプリ認証

### Rule 32.27: App Check 必須化
-   **Mandate**: 全てのFirebaseサービス（Firestore、Cloud Storage、Cloud Run Functions）およびカスタムバックエンドでApp Checkを有効化する。
-   **Attestation Providers**:
    | プラットフォーム | プロバイダ | 推奨 |
    |---|---|---|
    | Android | Play Integrity API | ✅ |
    | iOS | App Attest (Device Check) | ✅ |
    | Web | reCAPTCHA Enterprise | ✅ |
-   **Enforcement Mode**: 十分なApp Check導入率（90%以上）を確認後、エンフォースメントモードを有効化。

### Rule 32.28: カスタムバックエンドでのApp Check
-   **Mandate**: Cloud Run Services等のカスタムバックエンドでもApp Check Tokenを検証する。
    ```typescript
    import { getAppCheck } from "firebase-admin/app-check";
    
    async function verifyAppCheck(req: Request): Promise<boolean> {
      const appCheckToken = req.headers["x-firebase-appcheck"];
      if (!appCheckToken) return false;
      
      try {
        await getAppCheck().verifyToken(appCheckToken as string);
        return true;
      } catch {
        return false;
      }
    }
    ```

### Rule 32.29: Replay Protection
-   **Mandate**: 高セキュリティ操作（決済、個人情報変更等）にはApp Check Token Replay Protectionを有効化する。
-   **Caution**: Replay Protectionは毎回新しいトークンを要求するため、レイテンシ増加に注意。一般的なAPI呼び出しには不要。

---

## §7. Firestore 設計 & Security Rules

### Rule 32.30: Firestore 利用制限
-   **Mandate**: Firestoreへの新規データ保存は原則禁止（Supreme Directive 0.1準拠）。
-   **Permitted Use Cases**:
    1.  リアルタイムリスナーが必須のデータ（プレゼンス、チャット等）。
    2.  既存Firestoreコレクションの保守・運用。
    3.  Firebase関連の設定データ（Remote Config用メタデータ等）。

### Rule 32.31: Security Rules 必須パターン
-   **Mandate**: 全てのFirestoreデータベースにSecurity Rulesを設定する。デフォルトDenyパターンを適用。
-   **Default Deny**:
    ```
    rules_version = '2';
    service cloud.firestore {
      match /databases/{database}/documents {
        // デフォルト: 全てのアクセスを拒否
        match /{document=**} {
          allow read, write: if false;
        }
        
        // 明示的に許可するパスのみ定義
        match /users/{userId} {
          allow read: if request.auth != null && request.auth.uid == userId;
          allow write: if request.auth != null && request.auth.uid == userId
            && request.resource.data.keys().hasAll(['name', 'email'])
            && request.resource.data.name is string
            && request.resource.data.name.size() <= 100;
        }
      }
    }
    ```

### Rule 32.32: Security Rules ベストプラクティス
-   **Rules**:
    1.  **認証必須**: `request.auth != null`を全てのルールのベースとする。
    2.  **スキーマ検証**: `request.resource.data`の型・値・サイズを検証する。
    3.  **Custom Claims検証**: 管理者操作は`request.auth.token.role == 'admin'`で制御。
    4.  **Functions活用**: ルールロジックの再利用にはSecurity Rules Functionsを使用。
    5.  **テスト必須**: `@firebase/rules-unit-testing`で全ルールをテスト（§31参照）。
    6.  **バージョン管理**: Security Rulesファイルは必ずGit管理下に置く。

### Rule 32.33: Firestore クエリ最適化
-   **Mandate**: Firestoreクエリは常にパフォーマンスとコストを意識する。
-   **Rules**:
    1.  **`.limit()`必須**: 全てのクエリに`limit()`を設定。無制限クエリは禁止。
    2.  **カーソルベースページネーション**: `startAfter()`/`endBefore()`を使用。
    3.  **複合インデックス**: 複合クエリには明示的にインデックスを定義。
    4.  **ドキュメントサイズ**: 1ドキュメントは小さく保つ（目標: 10KB以内）。
    5.  **サブコレクション**: 大量のネストデータはサブコレクションを使用。
    6.  **キャッシュ**: Firestore SDK のキャッシュ機能を有効化（`enablePersistentCacheIndexAutoCreation`）。
    7.  **Hotspot回避**: ドキュメントIDにシーケンシャルな値を使用しない。

---

## §8. Firebase Data Connect (Cloud SQL) — GA

### Rule 32.34: Data Connect 概要
-   **Mandate**: Firebase Data Connect（2025年4月GA）はCloud SQL PostgreSQLを基盤とするBaaSサービス。SQLベースのバックエンドが必要な場合に活用を検討する。
-   **Features**:
    -   GraphQLベースのスキーマ定義とクエリ言語
    -   リレーショナルデータモデルのFirebase統合
    -   AI支援によるオンボーディングとスキーマ生成
    -   Firebase SDK（Web, iOS, Android, Flutter）によるクライアントアクセス
-   **Caution**: 本プロジェクトのSSOTはSupabase。Data ConnectはSupabaseが提供しない特定のFirebase統合機能が必要な場合にのみ検討。

### Rule 32.35: Data Connect vs. Supabase 判断基準
-   **Decision Matrix**:
    | 要件 | Supabase | Data Connect |
    |---|---|---|
    | SSOT (データ主権) | ✅ 最優先 | △ Firebase統合限定 |
    | RLS / Row Level Security | ✅ 最適 | △ Firebase Security Rules |
    | リアルタイムサブスクリプション | ✅ Realtime | △ 制限あり |
    | Firebase SDK統合 | △ カスタム必要 | ✅ ネイティブ |
    | エッジランタイム | ✅ Edge Functions | ❌ 不可 |
    | GraphQL API | △ pg_graphql | ✅ ネイティブ |

---

## §9. Cloud Storage for Firebase

### Rule 32.36: Storage 設計原則
-   **Mandate**: ファイルストレージにはCloud Storage for Firebaseを使用する。
-   **Architecture**:
    1.  **バケット分離**: 用途別にバケットを分離する（例: `user-uploads`, `public-assets`, `backups`）。
    2.  **Security Rules**: Storage Security Rulesでファイルアクセスを制御（認証必須、ファイルサイズ制限、MIME Type検証）。
    3.  **ライフサイクルルール**: 不要なファイルの自動削除・ストレージクラス変更を設定。

### Rule 32.37: Storage Security Rules
-   **Mandate**: 全バケットにSecurity Rulesを設定する。
    ```
    rules_version = '2';
    service firebase.storage {
      match /b/{bucket}/o {
        match /{allPaths=**} {
          allow read, write: if false; // デフォルトDeny
        }
        
        match /users/{userId}/{allPaths=**} {
          allow read: if request.auth != null && request.auth.uid == userId;
          allow write: if request.auth != null && request.auth.uid == userId
            && request.resource.size < 10 * 1024 * 1024  // 10MB制限
            && request.resource.contentType.matches('image/.*');
        }
      }
    }
    ```

### Rule 32.38: 画像最適化パイプライン
-   **Mandate**: ユーザーアップロード画像の自動最適化パイプラインを構築する。
-   **Architecture**:
    ```
    Upload → Cloud Storage → Eventarc Trigger → Cloud Run Functions (Resize/Compress) → Optimized Storage
    ```
-   **Alternative**: Firebase Extensions「Resize Images」を活用し、サムネイル・中サイズ・大サイズを自動生成。

### Rule 32.39: Resumable Upload
-   **Mandate**: 大きなファイル（10MB以上）のアップロードにはResumable Uploadを使用し、ネットワーク中断からの回復を保証する。

---

## §10. Firebase Hosting & App Hosting (GA)

### Rule 32.40: Firebase Hosting（静的サイト）
-   **Mandate**: 静的サイト・SPA・JAMStackのホスティングにはFirebase Hostingを使用する。
-   **Features**:
    -   グローバルCDN（Firebase CDN）
    -   自動SSL証明書
    -   ワンクリックロールバック
    -   Preview Channels（PR単位のプレビュー環境）
-   **Configuration**:
    ```json
    {
      "hosting": {
        "public": "dist",
        "ignore": ["firebase.json", "**/.*", "**/node_modules/**"],
        "rewrites": [
          { "source": "**", "destination": "/index.html" }
        ],
        "headers": [
          {
            "source": "**/*.@(js|css)",
            "headers": [
              { "key": "Cache-Control", "value": "public, max-age=31536000, immutable" }
            ]
          }
        ]
      }
    }
    ```

### Rule 32.41: App Hosting（GA — SSRアプリケーション）
-   **Mandate**: Next.js/AngularのSSR（Server-Side Rendering）アプリケーションにはFirebase App Hosting（2025年4月GA）を使用する。
-   **Features**:
    -   GitHub連携による自動ロールアウト
    -   Cloud Run上でのSSRコンテンツ配信
    -   Cloud CDNによる静的コンテンツキャッシュ
    -   即座のロールバック機能
    -   マルチリージョン対応（アジア・ヨーロッパ展開）
    -   ワイルドカードドメインサポート
    -   VPCネットワーク接続
    -   Firebase SDK初期化の自動簡略化
    -   ビルドデバッグUI
-   **Supported Frameworks**: Next.js（App Router推奨）、Angular（v17+）。
-   **Cost**: Blaze Planの無料枠超過時に課金（2025年8月以降）。

### Rule 32.42: Hosting vs App Hosting 選択基準
-   **Decision Matrix**:
    | 要件 | Firebase Hosting | App Hosting |
    |---|---|---|
    | SPA (React/Vue/Svelte) | ✅ 最適 | ❌ 不要 |
    | Next.js SSR | ❌ 不可 | ✅ 最適 |
    | Angular SSR/SSG | △ SSGのみ | ✅ 最適 |
    | 静的サイト | ✅ 最適 | ❌ 不要 |
    | カスタムサーバー | ❌ 不可 | ✅ Cloud Run |
    | Preview Channels | ✅ 対応 | ✅ 対応 |

---

## §11. FCM (Push Notification) 戦略

### Rule 32.43: FCM HTTP v1 API 必須化
-   **Mandate**: FCM Legacy APIは廃止済み。全てのPush通知は**FCM HTTP v1 API**を使用する。
-   **Advantages**: リッチコンテンツ、プラットフォーム別カスタマイズ、Analytics連携、OAuth 2.0認証。
-   **Implementation**:
    ```typescript
    import { getMessaging } from "firebase-admin/messaging";
    
    const message = {
      notification: {
        title: "新着通知",
        body: "お知らせがあります",
      },
      android: {
        notification: { channelId: "default" },
      },
      apns: {
        payload: { aps: { badge: 1, sound: "default" } },
      },
      webpush: {
        notification: { icon: "/icon.png" },
      },
      token: deviceToken,
    };
    
    await getMessaging().send(message);
    ```

### Rule 32.44: FCM トークン管理
-   **Mandate**: FCMトークンの適切なライフサイクル管理を実装する。
-   **Rules**:
    1.  **トークン更新**: アプリ起動時にトークンを取得し、サーバーに最新トークンを保存。
    2.  **無効トークンのクリーンアップ**: 送信エラー（`messaging/registration-token-not-registered`）を検知し、DBから無効トークンを削除。
    3.  **定期クリーンアップ**: 90日以上未更新のトークンを自動削除するバッチジョブを設定。
    4.  **Topic Messaging**: 大規模一斉配信にはTopic Messagingを活用。
    5.  **マルチデバイス**: Condition Messagingでユーザーの全デバイスに配信。

### Rule 32.45: FCM 配信最適化
-   **Mandate**: 通知のCTR（クリック率）と配信品質を継続的に改善する。
-   **Strategies**:
    1.  **セグメント配信**: Firebase Audiences + Analytics連携でターゲット配信。
    2.  **A/Bテスト**: 通知文面のA/BテストをRemote Configと連携。
    3.  **送信頻度制御**: ユーザーごとの通知頻度を制御し、通知疲れを防止。
    4.  **サイレント通知**: データ同期にはサイレント通知（`data`メッセージ）を使用。

---

## §12. Remote Config & Feature Flags

### Rule 32.46: Remote Config 活用戦略
-   **Mandate**: アプリのデプロイなしに動的設定を変更するため、Firebase Remote Configを活用する。
-   **Use Cases**:
    1.  **Feature Flags**: 新機能のグラデーションロールアウト。
    2.  **Kill Switch**: 問題のある機能の即座の無効化。
    3.  **A/Bテスト**: Google Analytics連携による実験。
    4.  **パーソナライゼーション**: ユーザー属性に基づく設定変更。
    5.  **環境設定**: API URL等の環境依存設定。
    6.  **AI Feature Control**: AI機能のモデル切り替え・無効化。

### Rule 32.47: Remote Config ベストプラクティス
-   **Rules**:
    1.  **デフォルト値**: アプリ内にハードコードされたデフォルト値を必ず設定。ネットワーク障害時のフォールバック。
    2.  **フェッチ頻度**: 最小フェッチ間隔を遵守（デフォルト12時間、開発時は短縮可能）。
    3.  **Real-time Config**: リアルタイム更新が必要な場合はReal-time Remote Configリスナーを使用。
    4.  **条件設定**: ユーザー属性・バージョン・プラットフォーム別の条件分岐。
    5.  **Server-side Config**: Cloud Run Functions内でもRemote ConfigのサーバーサイドAPIを活用。

---

## §13. Crashlytics & 安定性監視

### Rule 32.48: Crashlytics 必須化
-   **Mandate**: 全てのモバイルアプリにFirebase Crashlyticsを統合する。
-   **Configuration**:
    1.  **dSYMアップロード**: iOSではビルド時にdSYM（デバッグシンボル）を自動アップロード。
    2.  **Proguardマッピング**: AndroidではProguard/R8のマッピングファイルをアップロード。
    3.  **Non-Fatal Error**: クリティカルでないエラーも`recordError()`で記録。
    4.  **Custom Keys**: デバッグに有用なカスタムキー（ユーザーID、画面名等）を設定。
    5.  **Breadcrumbs**: ユーザー操作のパンくずリストを記録。

### Rule 32.49: Crash-Free Rate 目標
-   **Mandate**: Crash-Free Users率を**99.5%以上**に維持する。99%を下回った場合は緊急対応。
-   **Monitoring**: Crashlytics Alertsを設定し、新しいクラッシュクラスタを即座に検知。

---

## §14. Performance Monitoring

### Rule 32.50: Performance Monitoring 設定
-   **Mandate**: Firebase Performance Monitoringで主要パフォーマンスメトリクスを追跡する。
-   **Tracked Metrics**:
    1.  **App Start Time**: コールドスタートを2秒以内に維持。
    2.  **HTTP Response Time**: API応答時間（p95 < 1秒）。
    3.  **Screen Rendering**: 画面描画時間（p95 < 500ms）。
    4.  **Network Payload Size**: 過大なレスポンスサイズの検出。
-   **Custom Traces**: ビジネスクリティカルな操作（ログイン、決済、検索等）にカスタムトレースを設定。

---

## §15. Google Analytics for Firebase

### Rule 32.51: Analytics 統合
-   **Mandate**: Firebase向けGoogle Analyticsで全てのユーザー行動を計測する。
-   **Configuration**:
    1.  **自動イベント**: `first_open`, `session_start`, `screen_view`等を自動収集。
    2.  **カスタムイベント**: ビジネスメトリクス（購入、登録、機能使用等）を明示的に記録。
    3.  **User Properties**: ユーザー属性（プラン、地域、セグメント等）を設定。
    4.  **Conversion Events**: コンバージョンイベントを定義し、目標達成率を追跡。
    5.  **BigQuery Export**: 生データをBigQueryにエクスポートして詳細分析。
    6.  **DebugView**: 開発中はDebugViewでリアルタイムにイベントを確認。
-   **Privacy**: GDPRに準拠したConsent Modeを実装（§42参照）。

---

## §16. Firebase AI Logic & Genkit

### Rule 32.52: Firebase AI Logic 概要
-   **Mandate**: Firebase AI Logic（旧 Vertex AI in Firebase）を使用し、生成AIモデルをアプリにセキュアに統合する。
-   **Features**:
    -   Gemini Developer API（無料枠アリ）およびVertex AI APIへの直接アクセス
    -   App Check統合によるAIエンドポイント保護
    -   Gemini 3.1 Lite / 3.1（Preview）対応
    -   ハイブリッド推論（オンデバイスモデル + クラウドモデルの自動フォールバック）
    -   画像生成（Imagenモデル統合）
    -   Unity / Android XR サポート
-   **Architecture**:
    ```
    Client App → Firebase AI Logic SDK → App Check → Gemini API / Vertex AI API
    ```

### Rule 32.53: Genkit フレームワーク
-   **Mandate**: AIワークフロー構築にはGenkit（オープンソース）を使用する。
-   **Language Support（2026年3月時点）**:
    | 言語 | バージョン | ステータス | 成熟度 |
    |---|---|---|---|
    | Node.js (TypeScript) | 1.x | GA | ✅ 本番対応 |
    | Go | 1.0 (2025年9月GA) | GA | ✅ 本番対応 |
    | Python | Alpha | Preview | △ 実験的 |
-   **Core Features**:
    -   統一モデルAPI（Gemini、OpenAI、Anthropic、Ollama等マルチプロバイダ）
    -   型安全なAIフロー定義
    -   Tool Calling / Function Calling
    -   RAG（Retrieval-Augmented Generation）
    -   マルチモーダル対応（テキスト、画像、音声、動画）
    -   Genkit Developer UI によるデバッグ・テスト・可観測性
    -   `onCallGenkit`トリガーによるCallable Functions統合（§2参照）

### Rule 32.54: Genkit フロー設計
-   **Mandate**: AIフローは再現性・テスト可能性・可観測性を確保する。
-   **Pattern**:
    ```typescript
    import { genkit, z } from "genkit";
    import { googleAI, gemini20Flash } from "@genkit-ai/googleai";
    
    const ai = genkit({ plugins: [googleAI()] });
    
    const summarizeFlow = ai.defineFlow(
      {
        name: "summarize",
        inputSchema: z.object({ text: z.string(), maxLength: z.number().optional() }),
        outputSchema: z.object({ summary: z.string(), confidence: z.number() }),
      },
      async (input) => {
        const { output } = await ai.generate({
          model: gemini20Flash,
          prompt: `Summarize the following text in ${input.maxLength ?? 200} characters:\n${input.text}`,
          output: { schema: z.object({ summary: z.string(), confidence: z.number() }) },
        });
        return output!;
      }
    );
    ```

### Rule 32.55: Genkit Tool Calling
-   **Mandate**: LLMに外部データアクセスやアクション実行を許可する場合、Genkit Tool Callingを使用する。
-   **Security**: ツールの実行権限を最小限に制限。ユーザー入力に基づくツール呼び出しには入力検証を必須とする。
    ```typescript
    const getWeatherTool = ai.defineTool(
      {
        name: "getWeather",
        description: "Get current weather for a city",
        inputSchema: z.object({ city: z.string() }),
        outputSchema: z.object({ temp: z.number(), condition: z.string() }),
      },
      async (input) => {
        const data = await fetchWeatherAPI(input.city);
        return { temp: data.temperature, condition: data.condition };
      }
    );
    ```

### Rule 32.56: AI ガードレール
-   **Mandate**: AI機能には必ずガードレールを設定する。
-   **Requirements**:
    1.  **入力検証**: ユーザー入力のサニタイズ、プロンプトインジェクション防止。
    2.  **出力フィルタリング**: 有害コンテンツ、PII、機密情報の出力防止（Safety Settings）。
    3.  **トークン制限**: リクエストあたりの最大トークン数を設定（コスト暴走防止）。
    4.  **レート制限**: ユーザーあたりのAI API呼び出し頻度を制限。
    5.  **Kill Switch**: Remote Configを使用し、AI機能の即座の無効化を可能にする（§12参照）。
    6.  **Human-in-the-Loop**: 高リスク操作はAI出力を人間がレビュー後に実行。

---

## §17. Vertex AI 連携

### Rule 32.57: Firebase × Vertex AI 統合
-   **Mandate**: 高度なAI機能にはVertex AIを活用する。
-   **Services**:
    | サービス | 用途 |
    |---|---|
    | Vertex AI Gemini API | テキスト・マルチモーダル生成 |
    | Vertex AI Agent Engine (GA) | AIエージェントのデプロイ・管理 |
    | Vertex AI Imagen | 画像生成・編集 |
    | Vertex AI Search | エンタープライズ検索 |
    | Model Garden | モデルカタログ |

### Rule 32.58: Vertex AI Agent Engine（GA）
-   **Mandate**: AIエージェントの本番デプロイにはVertex AI Agent Engineを使用する。
-   **GA Features（2025年12月〜2026年2月）**:
    -   **Sessions GA**: 会話コンテキストの永続化
    -   **Memory Bank GA**: 過去のインタラクションの記憶と想起
    -   **Code Execution GA**: エージェントによるコード実行（2026年2月GA）
    -   **Agent Development Kit (ADK)**: エージェント開発フレームワーク
    -   **Playground**: テスト・評価環境
    -   **Observability**: エージェント動作の監視
-   **Enterprise Security**: Private VPCデプロイ、CMEK（顧客管理暗号化キー）対応。

### Rule 32.59: Cloud Run GPU × AI推論
-   **Mandate**: 低レイテンシAI推論にはCloud Run GPU（§3参照）を活用する。
-   **Architecture**:
    ```
    Client → Cloud Run Service (NVIDIA L4 GPU) → LLM/Image Model
    Client → Firebase AI Logic → Vertex AI API → Managed Inference
    ```
-   **Selection**: マネージドAPI（低運用負荷）とセルフホスト（カスタマイズ性）の選択は、レイテンシ要件とコスト効率で判断。

---

## §18. AI Agent セキュリティ & ガバナンス

### Rule 32.60: MCP (Model Context Protocol) 連携
-   **Mandate**: Genkit はMCP Client（外部MCPサーバーのツールを消費）およびMCP Server（自身のツール/フローを外部に公開）の双方をサポート。セキュリティガードレールを設定する。
-   **MCP Client Mode**: 外部MCPサーバーからツールを取得し、Genkitフローで使用。
-   **MCP Server Mode**: Genkitで定義したフローとツールをMCPプロトコルで公開し、IDE/AIエージェントからアクセス可能にする。
-   **Security Requirements**:
    1.  **認証・認可**: MCPサーバーへのアクセスにIAMとApp Checkを適用。
    2.  **データアクセス制限**: エージェントがアクセス可能なコレクション/フィールドを明示的に制限。
    3.  **監査ログ**: エージェントの全操作を記録。
    4.  **Rate Limiting**: エージェント単位のリクエスト制限。

### Rule 32.61: A2A (Agent-to-Agent) プロトコル
-   **Mandate**: 異なるフレームワーク（Genkit、LangGraph等）間でのAIエージェント連携には、Google提唱のA2A（Agent-to-Agent）オープンスタンダードを活用する。
-   **Architecture**: HTTP + JSON-RPC 2.0 + Server-Sent Events (SSE) ベース。
-   **Use Cases**: マルチエージェントワークフロー、異種フレームワーク間のタスク委譲。

### Rule 32.62: AI エージェント自律性レベル
-   **Mandate**: AIエージェントの自律性は5段階で分類し、段階的に権限を付与する。
    | Level | 名称 | 権限範囲 |
    |---|---|---|
    | L1 | Assistant | 情報提示のみ |
    | L2 | Copilot | 提案 + 承認後実行 |
    | L3 | Semi-Autonomous | 定義済みタスクの自動実行 |
    | L4 | Autonomous | 広範囲の自律的実行 |
    | L5 | Full Autonomous | 完全自律（人間の監視下） |

### Rule 32.63: AI FinOps
-   **Mandate**: AI関連コストを独立して追跡・管理する。
-   **Strategies**:
    1.  **トークン消費量追跡**: Genkit Monitoring経由でトークン使用量をダッシュボード化。
    2.  **30%ルール**: AI関連コストが全体の30%を超えた場合にアラート。
    3.  **モデル最適化**: より低コストなモデル（Flash系）への段階的移行を検討。
    4.  **ラベリング**: AI関連リソースに`ai-feature`ラベルを付与してコスト分離。
    5.  **Context Caching**: Vertex AI Context Cachingでトークンコストを削減。

### Rule 32.64: EU AI Act 対応
-   **Mandate**: AI機能の実装においてEU AI Actのリスク分類を考慮する。
-   **Requirements**:
    1.  **リスク分類**: AI機能を低リスク/限定リスク/高リスクに分類。
    2.  **透明性**: AIが生成したコンテンツにはその旨を明示。
    3.  **監査可能性**: AI意思決定の根拠を記録。

### Rule 32.65: App Testing Agent
-   **Mandate**: Firebase App Distribution内のApp Testing Agent（Geminiベース、Preview）を活用し、テストケースの生成・管理・実行を支援する。
-   **Use Cases**: 自動テストケース生成、回帰テスト、UIテスト自動化。

---

## §19. Firebase Extensions 戦略

### Rule 32.66: Extensions の活用方針
-   **Mandate**: 定型的なインテグレーションにはFirebase Extensionsを活用する。
-   **Recommended Extensions**:
    | Extension | 用途 |
    |---|---|
    | Stream Firestore to BigQuery | Firestoreデータの分析基盤構築 |
    | Resize Images | アップロード画像の自動リサイズ |
    | Translate Text | テキストの自動翻訳 |
    | Trigger Email | メール送信の自動化 |
    | Delete User Data | ユーザー削除時のデータクリーンアップ |

### Rule 32.67: カスタムExtension
-   **Mandate**: プロジェクト固有の繰り返し処理はカスタムExtensionとして開発・パッケージ化する。

---

## §20. BigQuery 連携 & データ分析基盤

### Rule 32.68: BigQuery をSSOT（分析用）
-   **Mandate**: 全ての分析データはBigQueryに集約する。
-   **Data Sources**:
    -   Firebase Analytics → BigQuery Export
    -   Firestore → BigQuery Extension
    -   Cloud Logging → BigQuery Sink
    -   Billing Data → BigQuery Export

### Rule 32.69: ELTパターン
-   **Mandate**: データはRaw形式でBigQueryにロードし、BigQuery内でdbt等で変換・テストする。
    ```
    Source → Raw Layer (BigQuery) → Staging Layer (dbt) → Mart Layer (dbt) → Dashboard
    ```

### Rule 32.70: データ品質
-   **Mandate**: データパイプラインに自動品質テストを組み込む。
-   **Tests**:
    1.  **Freshness**: データの鮮度チェック。
    2.  **Volume**: レコード数の異常検知（前日比±30%で警告）。
    3.  **Schema**: スキーマ変更の自動検知。
    4.  **Null Check**: 必須フィールドのNull率監視。

---

## §21. セキュリティ多層防御 (Zero Trust)

### Rule 32.71: Defense in Depth
-   **Mandate**: セキュリティは以下の全レイヤーで実装する。
    ```
    Layer 1: App Check（アプリ認証）
    Layer 2: Firebase Authentication（ユーザー認証）
    Layer 3: Security Rules / IAM（アクセス制御）
    Layer 4: VPC / Network Security（ネットワーク制御）
    Layer 5: Data Encryption（データ暗号化）
    Layer 6: Audit Logging（監査ログ）
    Layer 7: Supply Chain Security（サプライチェーン）
    ```

### Rule 32.72: Admin SDK のセキュリティ
-   **Mandate**: Admin SDKはSecurity Rulesをバイパスする。信頼されたサーバー環境でのみ使用。
-   **Requirements**:
    1.  **最小権限IAM**: 必要最小限のロールのみ付与。
    2.  **認証情報のローテーション**: 90日ごとにローテーション。
    3.  **環境変数管理**: キーファイルはSecret Managerで管理。ソースコードにコミットしない。

### Rule 32.73: OWASP Top 10 2025対策
-   **Mandate**: OWASP Top 10 2025の脅威に対する防御を実装する。
-   **Key Measures**:
    1.  **Injection防止**: パラメータ化クエリ、ユーザー入力のサニタイズ。
    2.  **XSS防止**: Content Security Policy (CSP)ヘッダー。
    3.  **CSRF防止**: SameSite Cookieの設定、CSRFトークン。
    4.  **Broken Access Control**: Security RulesとIAMの厳格な適用。
    5.  **SSRF防止**: Cloud Run Functions/Servicesからの外部リクエスト制限。

---

## §22. IAM & サービスアカウント管理

### Rule 32.74: 最小権限の原則
-   **Mandate**: 全てのIAMロールは最小権限の原則に従う。
-   **Prohibited**: 本番環境での`roles/owner`および`roles/editor`の使用は禁止。
-   **Recommended**: カスタムIAMロールを作成し、必要な権限のみを含める。IAM Recommenderの推奨を適用。

### Rule 32.75: サービスアカウント管理
-   **Mandate**: 機能ごとに専用のサービスアカウントを作成し、権限を分離する。
-   **Best Practices**:
    1.  **専用アカウント**: Cloud Run Functions、Cloud Run、CI/CDそれぞれに専用サービスアカウント。
    2.  **キーレス認証**: Workload Identity Federationを使用し、サービスアカウントキーの発行を最小化。
    3.  **定期監査**: 未使用のサービスアカウントとキーを90日ごとに監査・削除。

### Rule 32.76: Workload Identity Federation
-   **Mandate**: 外部IDプロバイダー（GitHub Actions、AWS等）からGCPへのアクセスにはWorkload Identity Federationを使用する。サービスアカウントキーの発行は原則禁止。

---

## §23. Secret Manager & 機密情報管理

### Rule 32.77: Secret Manager 必須化
-   **Mandate**: 全ての機密情報（APIキー、DBパスワード等）はSecret Managerで管理する。
-   **Prohibited**: 機密情報をソースコード、`.env`ファイル、Firebase Configにハードコードすることは**厳禁**。

### Rule 32.78: シークレットの管理
-   **Best Practices**:
    1.  **バージョニング**: シークレットはバージョン管理し、ロールバック可能に。
    2.  **自動ローテーション**: 90日ごとにローテーション。自動ローテーションを推奨。
    3.  **アクセス制御**: `roles/secretmanager.secretAccessor`を必要なサービスアカウントにのみ付与。
    4.  **CMEK**: コンプライアンス要件がある場合、顧客管理暗号化キー（CMEK）を使用。
    5.  **監査**: Secret Managerへのアクセスログを監視。

### Rule 32.79: Cloud Run Functions/Run での利用
-   **Example**:
    ```typescript
    export const myFunction = onRequest(
      { secrets: ["API_KEY", "DB_PASSWORD"] },
      async (req, res) => {
        const apiKey = process.env.API_KEY;
        // シークレットは自動的に環境変数として注入
      }
    );
    ```

---

## §24. VPC & ネットワークセキュリティ

### Rule 32.80: VPC Service Controls
-   **Mandate**: セキュリティ要件が高い環境ではVPC Service Controlsを設定し、GCPサービスへのアクセス境界を定義する。

### Rule 32.81: Private Google Access
-   **Mandate**: Cloud Run Functions/Servicesから GCPサービスへのアクセスにはPrivate Google Accessを使用。

### Rule 32.82: Direct VPC Egress
-   **Mandate**: Cloud Run FunctionsのDirect VPC Egress（GA）を活用し、VPC内プライベートリソースに安全にアクセスする。
-   **Configuration**: `--egress-settings=all`を設定して全アウトバウンドトラフィックをVPC経由にルーティング。

### Rule 32.83: Cloud Armor WAF
-   **Mandate**: Cloud Run/Load BalancerのフロントにCloud Armorを配置する。
-   **Architecture**: Cloud Run → Serverless NEG → Application Load Balancer → Cloud Armor Security Policy。
-   **Policy**:
    1.  **OWASP Top 10 WAFルール**: SQL Injection、XSS等の事前構成ルールを適用。
    2.  **Adaptive Protection**: DDoS攻撃の自動緩和。
    3.  **Rate Limiting**: 不正トラフィックパターンの制限。
    4.  **Geo Restriction**: 必要に応じた地理的制限。
    5.  **Bot Management**: Botトラフィックの検出と制御。
-   **Testing**: 新ポリシーは必ず「preview」モードで影響を評価してからエンフォースメント。

### Rule 32.84: Private Service Connect
-   **Mandate**: GCPマネージドサービス（Cloud SQL、Memorystore等）へのプライベート接続にはPrivate Service Connectを活用する。

---

## §25. FinOps & コスト最適化

### Rule 32.85: コスト配分の原則
-   **Mandate**: 全てのGCPリソースにラベルを付与する。
-   **Required Labels**:
    | Label Key | Values（例） | Purpose |
    |---|---|---|
    | `environment` | prod / staging / dev | 環境別コスト分析 |
    | `service` | api / worker / web | サービス別コスト分析 |
    | `owner` | team-backend / team-frontend | チーム別コスト配分 |
    | `cost-center` | engineering / marketing | 部門別コスト配分 |
    | `ai-feature` | chatbot / recommendation | AI機能別コスト分離 |

### Rule 32.86: Firebase コスト最適化
-   **最適化マトリクス**:

    | サービス | 最適化手法 |
    |---|---|
    | Firestore | クエリ最適化、クライアントキャッシュ、ページネーション、Hotspot回避 |
    | Cloud Run Functions | コールドスタート最適化、適切なメモリ/タイムアウト、`maxInstances`設定 |
    | Cloud Storage | CDN活用、画像圧縮、ライフサイクルルール、ストレージクラス最適化 |
    | Authentication | セッション管理最適化、MAU監視 |
    | FCM | 無効トークンの定期クリーンアップ |
    | AI (Genkit/Vertex) | Flash系モデル選択、Context Caching、トークン最適化 |
    | App Hosting | Blaze無料枠の監視、Cloud Runインスタンス最適化 |

### Rule 32.87: GCPコスト最適化
-   **Strategies**:
    1.  **ライトサイジング**: CPU/RAMを実際の使用量に合わせて調整。Recommender APIの推奨を適用。
    2.  **オートスケーリング**: サーバーレスおよびマネージドサービスの活用。
    3.  **CUD/SUD**: 予測可能なワークロードにはCommitted Use Discounts。
    4.  **非クリティカルリソースの停止**: dev/staging環境の夜間・週末自動停止。

### Rule 32.88: Billing Export to BigQuery
-   **Mandate**: GCP課金データをBigQueryにエクスポートし、詳細なコスト分析を実施する。

---

## §26. 予算アラート & 自動応答

### Rule 32.89: 予算アラート設定
-   **Mandate**: 全プロジェクトに多段階の予算アラートを設定する。
    | 段階 | 実際コスト | 予測コスト | アクション |
    |---|---|---|---|
    | 警告 | 50% | 75% | チームSlack通知 |
    | 注意 | 80% | 90% | マネージャーEscalation |
    | 危険 | 100% | 100% | 自動リソース制限実行 |
    | 超過 | 120% | — | 緊急対応（全チーム） |

### Rule 32.90: 自動応答（Budget Automation）
-   **Architecture**:
    ```
    Budget Alert → Cloud Pub/Sub → Cloud Run Functions → アクション実行
    ```
-   **Actions**:
    1.  **Slack/Email通知**: 関連チームへの即時通知。
    2.  **リソース制限**: 非クリティカルなCloud Run Functions/Servicesの`maxInstances`を0に設定。
    3.  **課金停止**: 最終手段としてCloud Billing APIでプロジェクトの課金を無効化。
-   **Caution**: 課金停止は全サービスを停止させるため、本番環境では慎重に適用。

### Rule 32.91: 月次レビュー
-   **Mandate**: 月次でコスト実績を予算と照合し、異常なコスト増加の原因を特定。

---

## §27. Observability (Cloud Logging / Monitoring / Trace)

### Rule 32.92: 構造化ログ
-   **Mandate**: 全てのCloud Run Functions/Servicesのログは構造化JSON形式で出力する。
    ```typescript
    import { log, warn, error } from "firebase-functions/logger";
    
    log("Order processed", {
      orderId: "abc123",
      userId: "user456",
      amount: 1500,
      currency: "JPY",
      processingTimeMs: 234,
    });
    ```
-   **Required Fields**: `timestamp`, `severity`, `message`, `traceId`。
-   **Prohibited**: 機密情報（パスワード、クレジットカード番号、PII）のログ出力は厳禁。

### Rule 32.93: Cloud Monitoring
-   **Mandate**: 主要なメトリクスにアラートポリシーを設定する。
    | メトリクス | 閾値 | アクション |
    |---|---|---|
    | Function Error Rate | > 5% | 即時Slack通知 |
    | Function Latency (p99) | > 5s | 調査開始 |
    | Pub/Sub Unacked Messages | > 1000 | 処理能力スケールアップ |
    | Cloud Run CPU Utilization | > 80% | インスタンス数確認 |
    | AI Token Consumption | > Budget 80% | コスト最適化実施 |

### Rule 32.94: Cloud Trace & OpenTelemetry
-   **Mandate**: 分散システムのリクエストフローを追跡するためにCloud Traceを活用する。
-   **Integration**: OpenTelemetry SDKを使用し、サービス間のトレースを自動伝播。Genkit MonitoringもOpenTelemetryベースで統合。
-   **Genkit Observability**: Genkit Developer UIでAIフローの実行トレース、コスト、レイテンシを可視化。

### Rule 32.95: Error Reporting
-   **Mandate**: Cloud Error Reportingで例外とエラーを自動集約し、新しいエラークラスタ検知時にアラートを送信する。

### Rule 32.96: Cloud Profiler
-   **Mandate**: Cloud Profilerで本番環境のCPU/メモリ使用量を継続的にプロファイリングし、パフォーマンスボトルネックを特定する。

---

## §28. エラーハンドリング & リトライ戦略

### Rule 32.97: 統一エラーハンドリング
-   **Mandate**: 統一されたエラーハンドリングパターンを適用する。
    ```typescript
    interface ErrorResponse {
      error: {
        code: string;        // "INVALID_ARGUMENT" | "NOT_FOUND" | "INTERNAL"
        message: string;     // ユーザー向けメッセージ
        details?: unknown;   // デバッグ情報（本番では省略）
      };
    }
    ```

### Rule 32.98: リトライ戦略
-   **Mandate**: 全ての外部呼び出しにリトライ戦略を実装する。ジッター付き指数バックオフ。
    | パラメータ | 値 |
    |---|---|
    | Initial Delay | 1秒 |
    | Max Delay | 60秒 |
    | Multiplier | 2x |
    | Max Retries | 5回 |
    | Jitter | ±20% |

### Rule 32.99: Dead Letter Queue (DLQ)
-   **Mandate**: リトライ上限を超えたメッセージはDead Letter Queueに転送する。

### Rule 32.100: Circuit Breaker
-   **Mandate**: 外部サービスの障害がシステム全体に波及することを防ぐため、Circuit Breakerパターンを実装する。

---

## §29. Terraform / IaC 管理

### Rule 32.101: IaC必須化
-   **Mandate**: Firebase/GCPの全てのインフラストラクチャ設定はTerraformでコード管理する。手動操作（ClickOps）は禁止。
-   **Scope**: GCPプロジェクト設定、Firebase設定、Cloud Run Functions/Services設定、Security Rules、App Check、Budget Alerts、Monitoring Alert Policies。

### Rule 32.102: プロジェクト構成
-   **ディレクトリ構成**:
    ```
    terraform/
    ├── modules/
    │   ├── firebase/       # Firebase固有リソース
    │   ├── networking/     # VPC/ネットワーク
    │   ├── iam/            # IAMロール/サービスアカウント
    │   └── monitoring/     # アラート/ダッシュボード
    ├── environments/
    │   ├── dev/
    │   ├── staging/
    │   └── prod/
    └── backend.tf          # State管理設定
    ```

### Rule 32.103: State管理
-   **Mandate**: Terraform StateはGCSバケットにリモート保存する。バケットバージョニング有効化、State Lockingを実装、手動編集は禁止。

### Rule 32.104: バージョン管理
-   **設定例**:
    ```hcl
    terraform {
      required_version = ">= 1.6.0"
      required_providers {
        google = {
          source  = "hashicorp/google"
          version = "~> 5.0"
        }
        google-beta = {
          source  = "hashicorp/google-beta"
          version = "~> 5.0"
        }
      }
    }
    ```

### Rule 32.105: CI/CD統合
-   **Mandate**: Terraform操作はCI/CDパイプラインで自動化する。
-   **Workflow**: PR時に`terraform plan`を自動実行 → レビュー・承認 → マージ後に`terraform apply`。
-   **Validation**: `terraform fmt -recursive`と`terraform validate`をCIチェックに含める。

---

## §30. Firebase CLI & ローカル開発

### Rule 32.106: Firebase CLI の活用
-   **Essential Commands**:
    | コマンド | 用途 |
    |---|---|
    | `firebase init` | プロジェクト初期化 |
    | `firebase deploy` | リソースデプロイ |
    | `firebase emulators:start` | ローカルエミュレータ起動 |
    | `firebase use` | プロジェクト切り替え |
    | `firebase functions:log` | 関数ログ確認 |
    | `genkit init:ai-tools` | AIコーディングアシスタント連携初期化 |

### Rule 32.107: プロジェクトエイリアス
-   **設定例**:
    ```json
    {
      "projects": {
        "default": "myapp-dev",
        "staging": "myapp-staging",
        "prod": "myapp-prod"
      }
    }
    ```

---

## §31. Emulator Suite & テスト戦略

### Rule 32.108: Emulator Suite 必須化
-   **Mandate**: ローカル開発およびCIテストにはFirebase Emulator Suiteを使用する。
-   **Supported Emulators**:
    | Emulator | Port | 用途 |
    |---|---|---|
    | Authentication | 9099 | 認証フローのテスト |
    | Firestore | 8080 | データベース操作のテスト |
    | Cloud Functions | 5001 | 関数のローカル実行 |
    | Cloud Storage | 9199 | ファイルアップロードのテスト |
    | Hosting | 5000 | ホスティングのローカルプレビュー |
    | Pub/Sub | 8085 | メッセージングのテスト |
    | Eventarc | 9299 | イベントトリガーのテスト |
    | Data Connect | 9399 | Data Connectのテスト |

### Rule 32.109: Security Rules テスト
-   **Mandate**: Security Rulesのテストは`@firebase/rules-unit-testing`パッケージで自動化する。

### Rule 32.110: テスト戦略
-   **Layers**:
    1.  **Unit Test**: ビジネスロジックの単体テスト（Firebaseに依存しない）。
    2.  **Integration Test**: Emulator Suiteを使用した統合テスト。
    3.  **E2E Test**: ステージング環境での端末間テスト。

---

## §32. CI/CD パイプライン統合

### Rule 32.111: GitHub Actions 推奨
-   **設定例**:
    ```yaml
    name: Firebase CI/CD
    on:
      push:
        branches: [main]
      pull_request:
        branches: [main]
    
    jobs:
      test:
        runs-on: ubuntu-latest
        steps:
          - uses: actions/checkout@v4
          - uses: actions/setup-node@v4
          - run: npm ci
          - run: npm run lint
          - run: npm run test
      
      deploy:
        needs: test
        if: github.ref == 'refs/heads/main'
        runs-on: ubuntu-latest
        permissions:
          id-token: write
        steps:
          - uses: actions/checkout@v4
          - uses: google-github-actions/auth@v2
            with:
              workload_identity_provider: ${{ vars.WIF_PROVIDER }}
              service_account: ${{ vars.SA_EMAIL }}
          - run: npm ci && npm run build
          - run: npx firebase-tools deploy --only functions
    ```

### Rule 32.112: Workload Identity Federation
-   **Mandate**: GitHub ActionsからGCPへの認証にはWorkload Identity Federationを使用する。サービスアカウントキーの使用は禁止。

### Rule 32.113: デプロイメント戦略
-   **Flow**:
    1.  **PR**: 自動テスト + Lint + Security Rules テスト + `firebase hosting:channel:deploy`（プレビュー）。
    2.  **Merge to main**: 自動デプロイ（Staging環境）。
    3.  **本番**: 手動承認後のデプロイ（`git push`禁止プロトコルに準拠）。

---

## §33. 環境管理 (Dev / Staging / Prod)

### Rule 32.114: 環境分離
-   **マトリクス**:

    | 環境 | GCP Project | 用途 | アクセス |
    |---|---|---|---|
    | Dev | `myapp-dev` | 開発・実験 | 開発チーム全員 |
    | Staging | `myapp-staging` | 受け入れテスト | 開発チーム + QA |
    | Prod | `myapp-prod` | 本番運用 | 制限付き（IAM厳格化） |

### Rule 32.115: 環境パリティ
-   **Mandate**: Staging環境は本番と同等の構成を維持する。

### Rule 32.116: 環境変数管理
-   **Methods**:
    1.  **Firebase Config**: `firebase functions:config:set`（非機密情報）。
    2.  **Secret Manager**: 機密情報（§23参照）。
    3.  **Terraform Variables**: インフラ設定。
    4.  **Remote Config**: アプリ動的設定（§12参照）。

---

## §34. マルチリージョン & DR戦略

### Rule 32.117: リージョン選定基準
-   **Primary**: `asia-northeast1`（東京）— 日本向けサービスのデフォルト。
-   **Secondary**: `us-central1`（アイオワ）— グローバルサービス向け。
-   **GPU対応**: Cloud Run GPU（NVIDIA L4 GA）は`us-central1`, `europe-west1`, `europe-west4`, `asia-southeast1`, `asia-south1`等で利用可能。

### Rule 32.118: リージョン一貫性
-   **Mandate**: 関連サービスは同一リージョンに配置する。

### Rule 32.119: Disaster Recovery
-   **Strategies**:
    1.  **Firestore**: マルチリージョンロケーション（`nam5`/`eur3`等）を使用。
    2.  **Cloud Storage**: マルチリージョンバケットまたはDual-regionバケット。
    3.  **Cloud Run**: 複数リージョンへのデプロイとロードバランシング。
    4.  **Backup**: Firestore自動バックアップ（日次）の設定とリカバリテスト。
    5.  **RTO/RPO定義**: サービスごとのRTO（目標復旧時間）・RPO（目標復旧ポイント）を定義。

---

## §35. API 設計 & エンドポイント管理

### Rule 32.120: API設計原則
-   **Principles**:
    1.  **統一インターフェース**: リソース指向のURL設計（`/api/v1/users/{id}`）。
    2.  **バージョニング**: APIバージョンをURLパスに含める。
    3.  **ページネーション**: カーソルベースのページネーションを実装。

### Rule 32.121: 認証 & 認可
-   **Pattern**: App Check（§6） + Firebase Auth Token + Custom Claims（§5）の三層認証。

### Rule 32.122: OpenAPI仕様
-   **Mandate**: APIエンドポイントはOpenAPI (Swagger)仕様で文書化する。

---

## §36. Rate Limiting & API 保護

### Rule 32.123: レート制限の実装
-   **Strategies**:
    1.  **Cloud Armor**: Load Balancer経由のCloud Run向けWAFルール + レート制限。
    2.  **Application Level**: Redisベースのスライディングウィンドウカウンター。
    3.  **API Gateway**: GCP API GatewayまたはApigee。

### Rule 32.124: Abuse Detection
-   **Mandate**: 短時間大量リクエスト、異常アクセスパターン、地理的異常を検知する仕組みを実装。

---

## §37. キャッシング戦略

### Rule 32.125: キャッシュ階層
-   **Layers**:
    1.  **CDN (Firebase Hosting)**: 静的アセットのエッジキャッシュ。
    2.  **Cloud CDN**: Cloud Run/Load Balancer前段のキャッシュ。
    3.  **Memorystore (Redis)**: アプリケーションレベルのキャッシュ。
    4.  **Client-Side**: ブラウザキャッシュ、Service Workerキャッシュ。

### Rule 32.126: キャッシュ無効化
-   **Strategies**: TTLベース、バージョニング（Cache Busting）、イベント駆動の無効化。

---

## §38. バッチ処理 & データパイプライン

### Rule 32.127: バッチ処理アーキテクチャ
-   **パターン**:
    ```
    Cloud Scheduler → Pub/Sub → Cloud Run Job (並列タスク)
    Cloud Scheduler → Cloud Tasks → Cloud Run Job (レート制御付き)
    ```

### Rule 32.128: データパイプライン
-   **パターン**:
    ```
    Event Source → Pub/Sub → Cloud Run Functions (軽量変換) → BigQuery
    Event Source → Pub/Sub → Cloud Run Services (重い処理) → Cloud Storage → BigQuery
    Cloud Scheduler → Cloud Run Jobs (バッチETL) → BigQuery
    ```

---

## §39. Google Maps Platform 最適化

### Rule 32.129: コスト最適化
-   **Strategies**:
    1.  **Static Maps**: 非対話型ビューにはStatic Maps APIを使用。
    2.  **Session Token**: Places Autocompleteにはセッショントークンを使用。
    3.  **キャッシング**: Geocoding結果をキャッシュ。
    4.  **Vector Maps**: Maps JavaScript APIのVector Mapsでレンダリング最適化。

### Rule 32.130: 利用制限
-   **Mandate**: Maps APIの日次/月次リクエスト制限を設定。

---

## §40. Google Ecosystem 統合戦略

### Rule 32.131: Google First 原則
-   **Mandate**: 技術選定はGoogleエコシステムを最優先する。
-   **Exception**: サードパーティ製品はGoogleサービスに対する圧倒的な優位性が証明される場合のみ採用を許可。

### Rule 32.132: サービス間統合パターン
-   **マトリクス**:

    | 統合 | 実装方法 |
    |---|---|
    | Firebase → BigQuery | Firebase Extensions / BigQuery Link |
    | Firebase → Vertex AI | Firebase AI Logic / Genkit |
    | GCP → Firebase | Admin SDK / REST API |
    | Firebase → Google Ads | Google Analytics Audiences |
    | Firebase → Google Play | Play Integrity API (App Check) |

---

## §41. Firebase Studio

### Rule 32.133: Firebase Studio の活用
-   **Mandate**: プロトタイピングおよびフルスタックAIアプリケーション開発にはFirebase Studioを活用する。
-   **Features**:
    -   クラウドベースのAIネイティブ開発環境
    -   Gemini 2.5によるプロンプトtoアプリ生成
    -   エージェントモード（自律的タスク実行）
    -   Figmaデザインからの統合
    -   App Hosting統合によるデプロイ
    -   バックエンド自動プロビジョニング（Firestore、Firebase Authentication等の自動検出・設定）
    -   MCP Server ネイティブサポート
-   **Use Cases**:
    1.  **ラピッドプロトタイピング**: AIプロンプトからアプリの骨格を即座に生成。
    2.  **フルスタック開発**: フロントエンド + バックエンド + Firebase連携の一気通貫開発。
    3.  **チーム協調**: クラウドベースで即座に共有可能。

### Rule 32.134: Firebase Studio の制約
-   **Caution**:
    1.  本番コードの直接デプロイは非推奨（CI/CDパイプラインを経由すること）。
    2.  生成されたコードは必ずレビューし、Security Rules・IAM設定を確認。
    3.  大規模プロジェクトでは従来のIDE + CLIワークフローを推奨。

---

## §42. コンプライアンス & データ主権

### Rule 32.135: GDPR/CCPA対応
-   **Requirements**:
    1.  **同意管理**: データ収集前にユーザーの明示的同意を取得。
    2.  **データポータビリティ**: ユーザーデータのエクスポート機能を提供。
    3.  **削除権**: ユーザーデータの完全削除プロセスを実装。
    4.  **DPA**: Googleとのデータ処理契約を締結。

### Rule 32.136: Privacy Laws対応
-   **Requirements**:
    1.  **利用目的の明示**: プライバシーポリシーでデータの利用目的を明記。
    2.  **安全管理措置**: 技術的安全管理措置（暗号化、アクセス制御）を実装。
    3.  **第三者提供制限**: 同意なしの第三者提供は禁止。

### Rule 32.137: データローカリティ
-   **Mandate**: データ主権要件がある場合、GCPリージョンの選定でデータの地理的位置を制御する。Organization Policyでリージョンを制限。

---

## §43. サプライチェーンセキュリティ

### Rule 32.138: コンテナセキュリティ
-   **Mandate**: Cloud Runのコンテナイメージはセキュリティスキャンを実施する。
-   **Tools**: Artifact Registry のコンテナ脆弱性スキャン、Binary Authorization。
-   **Binary Authorization**: 本番環境へのデプロイは署名済みコンテナイメージのみ許可するポリシーを適用。

### Rule 32.139: 依存関係管理
-   **Mandate**: サードパーティライブラリの脆弱性を継続的に監視する。
-   **Tools**: Dependabot / Renovate、npm audit、`snyk`。

### Rule 32.140: SBOM（Software Bill of Materials）
-   **Mandate**: 本番デプロイのコンテナイメージについてSBOMを生成・保管する。

---

## §44. 運用成熟度モデル

### Rule 32.141: 成熟度レベル
-   **マトリクス**:

    | Level | 名称 | 要件 |
    |---|---|---|
    | L1 | Ad-hoc | 手動デプロイ、ログなし、テストなし |
    | L2 | Managed | CI/CD導入、基本ログ、手動テスト |
    | L3 | Defined | IaC導入、構造化ログ、自動テスト、予算アラート |
    | L4 | Measured | Observability統合、SLI/SLO定義、コスト最適化 |
    | L5 | Optimized | 自動スケーリング、自動復旧、AI駆動分析 |

### Rule 32.142: 最低要件
-   **Mandate**: 本番環境は最低L3を達成すること。L2以下での本番運用は禁止。

---

## §45. マイグレーション & 廃止戦略

### Rule 32.143: Firestore → Supabase マイグレーション
-   **Strategy**:
    1.  **データマッピング**: NoSQLスキーマからRDBスキーマへの変換設計。
    2.  **段階的移行**: サービス単位で段階的に移行。
    3.  **Dual Write**: 移行期間中は両方のDBに書き込み。
    4.  **Read Switch**: 読み取り先をSupabaseに切り替え。
    5.  **Write Switch**: 書き込み先をSupabaseに切り替え。
    6.  **Cleanup**: Firestoreのデータとコードを削除。

### Rule 32.144: レガシーAPI廃止
-   **Process**: Deprecation Notice → Migration Guide → Usage Monitoring → Sunset。

### Rule 32.145: 1st Gen Functions 移行
-   **Mandate**: 1st Gen Cloud FunctionsをCloud Run Functionsへ速やかに移行する。GCP提供のアップグレードツールを活用。

---

## §46. トラブルシューティング & デバッグ

### Rule 32.146: デバッグツール
-   **リファレンス**:

    | ツール | 用途 |
    |---|---|
    | Firebase Console | リアルタイム監視、Analytics、Crashlytics |
    | GCP Console | Cloud Logging、Monitoring、Trace |
    | Firebase Emulator Suite | ローカルデバッグ |
    | `firebase functions:log` | 関数ログのストリーミング |
    | Cloud Shell | GCPリソースの直接操作 |
    | Gemini in Firebase Console | AIアシスタントによるデバッグ支援 |

### Rule 32.147: 共通トラブルシューティング
-   **リファレンス**:

    | 問題 | 原因 | 対処 |
    |---|---|---|
    | Cold Start遅延 | インスタンス起動 | `minInstances`設定、コード最適化 |
    | CORS エラー | ヘッダー未設定 | `cors`ミドルウェア追加 |
    | Permission Denied | IAM/Security Rules | 権限確認、Emulatorでテスト |
    | Quota Exceeded | API制限超過 | クォータ増加申請、最適化 |
    | Memory Limit | メモリ不足 | メモリ設定増加、ストリーム処理 |
    | Timeout | 処理時間超過 | 非同期化、Cloud Run Jobs移行 |
    | GPU Not Available | リージョン制限 | GPU対応リージョンに移動 |

### Rule 32.148: インシデント対応
-   **Process**:
    1.  **Detection**: アラートによる検知（<5分）。
    2.  **Triage**: 影響範囲の特定とSeverity判定。
    3.  **Mitigation**: 一時的な対処（Feature Flag OFF、ロールバック等）。
    4.  **Resolution**: 根本原因の修正と検証。
    5.  **Post-mortem**: 振り返りと再発防止策の策定。

---

## §47. Node.js/TypeScript 固有設計

### Rule 32.149: ランタイム選定
-   **Mandate**: Node.js 22+ LTSを標準ランタイムとする（Node.js 24も利用可能）。
-   **Configuration**: `engines`フィールドでバージョンを明示。
    ```json
    { "engines": { "node": "22" } }
    ```

### Rule 32.150: TypeScript 必須
-   **Mandate**: 全てのCloud Run Functions/Servicesコードは**TypeScript**で記述する。JavaScriptの直接使用は禁止。
-   **Configuration**: `strict: true`を`tsconfig.json`に設定。`noUncheckedIndexedAccess: true`を推奨。

### Rule 32.151: ESM vs CJS
-   **Mandate**: 新規プロジェクトではESModulesを推奨する。
-   **Configuration**: `"type": "module"`を`package.json`に設定、または`.mts`拡張子を使用。
-   **Caution**: 一部のFirebase SDKがCJS前提の場合があるため、互換性を事前に確認。

### Rule 32.152: 型安全パターン
-   **Mandate**: Zod等のバリデーションライブラリでランタイム型安全性を確保する。
    ```typescript
    import { z } from "zod";
    
    const OrderSchema = z.object({
      userId: z.string().min(1),
      items: z.array(z.object({
        productId: z.string(),
        quantity: z.number().int().positive(),
      })),
      total: z.number().positive(),
    });
    
    type Order = z.infer<typeof OrderSchema>;
    ```

### Rule 32.153: Genkit Node.js 統合
-   **Mandate**: Node.js 環境でのAIワークフローにはGenkit Node.js SDK（GA）を使用する。`onCallGenkit`トリガーでCallable Functions統合が可能（§2 Rule 32.11参照）。

---

## §48. Node.js パフォーマンス & テスト

### Rule 32.154: バンドル最適化
-   **Mandate**: Cloud Run Functions のデプロイサイズを最小化する。
-   **Strategies**:
    1.  `devDependencies`と`dependencies`を適切に分離。
    2.  不要な依存関係を定期的にプルーニング。
    3.  `--only=production`または`npm ci --omit=dev`でデプロイ。

### Rule 32.155: テストフレームワーク
-   **Mandate**: Vitest（推奨）またはJestでテストを実施する。
-   **Coverage**: ビジネスロジックのカバレッジ80%以上を目標。

---

## §49. Node.js デプロイ & パッケージ管理

### Rule 32.156: パッケージマネージャー
-   **Mandate**: npm（標準）またはpnpmを使用する。yarnは非推奨。
-   **Lock File**: `package-lock.json`（npm）または`pnpm-lock.yaml`を必ずコミット。

### Rule 32.157: Monorepo対応
-   **Mandate**: 大規模プロジェクトではnpm workspacesまたはpnpm workspacesを活用し、共通ユーティリティを共有する。

---

## §50. Go 固有設計

### Rule 32.158: Go ランタイム
-   **Mandate**: Go 1.23+ を使用する（Go 1.24/1.26も利用可能）。Cloud Run FunctionsおよびCloud Run Servicesの双方で利用可能。

### Rule 32.159: Genkit Go（GA）
-   **Mandate**: Go言語でのAIワークフロー構築にはGenkit Go SDK（1.0 GA、2025年9月）を使用する。
    ```go
    import "github.com/firebase/genkit/go/ai"
    
    myFlow := genkit.DefineFlow("myFlow", func(ctx context.Context, input string) (string, error) {
        resp, err := ai.Generate(ctx, ai.WithTextPrompt(input))
        if err != nil {
            return "", err
        }
        return resp.Text(), nil
    })
    ```
-   **Features**: 型安全AIフロー、統一モデルインターフェース、Tool Calling、RAG、マルチモーダル。

### Rule 32.160: 構造体設計
-   **Mandate**: FirestoreドキュメントのGo構造体マッピングには`firestore`タグを使用する。
-   **Validation**: `go-playground/validator`でバリデーションを実装。

---

## §51. Go パフォーマンス & テスト

### Rule 32.161: テスト
-   **Mandate**: 標準`testing`パッケージでテストを実施する。TableDrivenTestパターンを推奨。
-   **Benchmark**: パフォーマンスクリティカルなコードには`testing.B`でベンチマーク。

### Rule 32.162: エラーハンドリング
-   **Mandate**: Go標準のエラーハンドリングパターン（`errors.Is`/`errors.As`/`fmt.Errorf`+`%w`）に従う。

---

## §52. Python 固有設計

### Rule 32.163: Python ランタイム
-   **Mandate**: Python 3.12+ を使用する（Python 3.13/3.14も利用可能）。Cloud Run FunctionsおよびCloud Run Servicesで利用可能。

### Rule 32.164: Genkit Python
-   **Mandate**: Python でのAIワークフロー構築にはGenkit Python SDK（Alpha）を使用する。
-   **Caution**: Alpha段階のため、本番利用には安定性を慎重に評価。GA予定を注視する。

### Rule 32.165: 型ヒント
-   **Mandate**: 全てのPythonコードに型ヒント（Type Hints）を付与し、`mypy`でチェックする。
    ```python
    from firebase_functions import https_fn
    from pydantic import BaseModel
    
    class OrderRequest(BaseModel):
        user_id: str
        items: list[dict]
        total: float
    
    @https_fn.on_request()
    def process_order(req: https_fn.Request) -> https_fn.Response:
        order = OrderRequest.model_validate_json(req.data)
        # ビジネスロジック
        return https_fn.Response(json.dumps({"status": "ok"}))
    ```

---

## §53. Python パフォーマンス & テスト

### Rule 32.166: テスト
-   **Mandate**: pytestでテストを実施する。`pytest-asyncio`で非同期テストに対応。
-   **Coverage**: `pytest-cov`でカバレッジ計測。

### Rule 32.167: 依存関係管理
-   **Mandate**: `requirements.txt`または`pyproject.toml`で依存関係を管理。`pip-tools`でロックファイルを生成。`uv`の採用も推奨。

---

## §54. アンチパターン35選

### Rule 32.168: 禁止パターン集

| # | アンチパターン | 正しいアプローチ |
|---|---|---|
| 1 | Firestoreに新規コレクションを作成 | Supabaseにテーブルを作成 |
| 2 | 1st Gen Cloud Functionsの新規作成 | Cloud Run Functionsを使用 |
| 3 | `roles/owner`を本番SAに付与 | カスタムロールで最小権限 |
| 4 | サービスアカウントキーをGitにコミット | Secret Manager + WIF |
| 5 | `.env`ファイルに機密情報を記載 | Secret Managerで管理 |
| 6 | App Checkなしでの本番運用 | 全サービスにApp Check適用 |
| 7 | Security Rules未設定のFirestore | Default Deny + Authentication |
| 8 | `.limit()`なしのFirestoreクエリ | 常にページネーション実装 |
| 9 | 冪等性を無視した関数設計 | Event ID重複排除 |
| 10 | 同期的な重い処理 | Pub/Sub/Cloud Tasksで非同期化 |
| 11 | コールドスタート対策なし | `minInstances`設定 |
| 12 | デフォルトのメモリ/タイムアウト使用 | 明示的にリソース設定 |
| 13 | 予算アラート未設定 | 4段階アラート設定 |
| 14 | GCPリソースにラベルなし | 必須ラベル5種を付与 |
| 15 | 手動インフラ設定（ClickOps） | Terraform/IaCで管理 |
| 16 | 本番環境で`firebase deploy`の手動実行 | CI/CDパイプライン経由 |
| 17 | テストなしのSecurity Rulesデプロイ | Emulator Suiteでユニットテスト |
| 18 | 構造化されていないログ出力 | JSON構造化ログ |
| 19 | エラーハンドリングの不統一 | 統一ErrorResponseフォーマット |
| 20 | リトライ戦略なしの外部呼び出し | 指数バックオフ + DLQ |
| 21 | FCMレガシーAPIの使用 | HTTP v1 APIへの移行 |
| 22 | Admin SDKの不適切な使用 | 最小権限IAM + Secret Manager |
| 23 | VPC設定なしでのDB直接アクセス | Direct VPC Egress設定 |
| 24 | 機密情報のログ出力 | PII/パスワードのログ禁止 |
| 25 | AI出力のガードレールなし | 入力検証 + 出力フィルタ + Kill Switch |
| 26 | AI関連コストの未追跡 | AI FinOpsラベリング + 30%ルール |
| 27 | Staging≠Prodの構成 | 環境パリティの維持 |
| 28 | DRテストの未実施 | 四半期ごとのDRテスト |
| 29 | SBOMなしのコンテナデプロイ | SBOM生成・保管 |
| 30 | Firebase Studioの本番直デプロイ | CI/CDパイプライン経由 |
| 31 | Genkit フローのテスト未実施 | Developer UIとユニットテスト |
| 32 | Binary Authorizationなしの本番デプロイ | 署名済みイメージのみ許可 |
| 33 | MCPサーバーの認証なし公開 | IAM + App Checkによるアクセス制御 |
| 34 | App Hosting無料枠の未監視 | Blaze Plan + 予算アラート設定 |
| 35 | Refresh TokenのLocalStorage保存 | HTTP-only Cookie + Token Revocation |

---

## §55. 将来展望

### Rule 32.169: 技術トレンド監視
-   **Mandate**: 以下の技術トレンドを継続的に監視し、採用準備を整える。
-   **Trends**:
    1.  **WebAssembly Functions**: WASM対応のCloud Run Functionsによるパフォーマンス向上。
    2.  **Edge Computing**: Cloud Run on GDC（Google Distributed Cloud）によるエッジ展開。
    3.  **Quantum-Safe Cryptography**: 量子耐性暗号への移行準備。
    4.  **AI-Native Infrastructure**: AIによるインフラ自動最適化・自己修復。
    5.  **Confidential Computing**: TEE（Trusted Execution Environment）でのデータ処理。
    6.  **Multi-Cloud AI**: Cloud Run GPUとVertex AI Agent Engineの融合による分散AI推論。
    7.  **Genkit Python GA**: Python SDKのGA化による機械学習エンジニアの活用拡大。
    8.  **Cloud Run RTX PRO 6000**: 次世代GPU（NVIDIA Blackwell）による高性能AI推論。

---

## Appendix A: サービス別逆引き索引

| やりたいこと | 参照セクション |
|---|---|
| Cloud Run Functionsのコールドスタートを軽減したい | §2 |
| Cloud Run GPUでAI推論を実行したい | §3 |
| バッチ処理を実行したい | §3, §38 |
| 非同期メッセージングを実装したい | §4 |
| ユーザー認証を実装したい | §5 |
| Passkeys/FIDO2を導入したい | §5 |
| アプリの不正利用を防止したい | §6 |
| Firestoreのセキュリティを強化したい | §7 |
| Data Connectを活用したい | §8 |
| ファイルをセキュアに保存したい | §9 |
| SPAをデプロイしたい | §10 |
| Next.jsのSSRをデプロイしたい | §10 |
| Push通知を送信したい | §11 |
| A/Bテスト・Feature Flagを実装したい | §12 |
| クラッシュを監視したい | §13 |
| パフォーマンスを計測したい | §14 |
| 生成AIをアプリに組み込みたい | §16, §17 |
| AIエージェントを構築したい | §17, §18 |
| MCP/A2Aプロトコルを活用したい | §18 |
| コスト分析をしたい | §20, §25, §26 |
| セキュリティを強化したい | §21, §22, §23, §24 |
| ログ・監視を設定したい | §27 |
| エラーハンドリングを統一したい | §28 |
| インフラをコード管理したい | §29 |
| ローカル開発環境を構築したい | §30, §31 |
| CI/CDを構築したい | §32 |
| 環境を分離したい | §33 |
| DRを計画したい | §34 |
| APIを設計したい | §35 |
| レート制限を実装したい | §36 |
| キャッシングを最適化したい | §37 |
| Google Maps を使いたい | §39 |
| Firebase Studioを活用したい | §41 |
| GDPRに対応したい | §42 |
| コンテナセキュリティを強化したい | §43 |
| 運用を改善したい | §44 |
| Firestoreからの移行を計画したい | §45 |
| Node.js/TypeScript固有のガイド | §47, §48, §49 |
| Go固有のガイド | §50, §51 |
| Python固有のガイド | §52, §53 |

---

## Appendix B: クロスリファレンス

| 関連ルールファイル | 参照目的 |
|---|---|
| `300_engineering_standards` | ソフトウェアエンジニアリング一般原則 |
| `340_web_frontend` | フロントエンド統合パターン |
| `301_api_integration` | API設計・マイクロサービス設計 |
| `343_native_platforms` | モバイルアプリ統合（iOS/Android） |
| `320_supabase_architecture` | SSOT (Supabase) との連携・移行 |
| `361_aws_cloud` | マルチクラウド戦略・比較 |
| `400_ai_engineering` | AI/ML実装ガイドライン |
| `401_data_analytics` | 分析・Observability |
| `700_qa_testing` | テスト戦略全般 |
| `600_security_privacy` | セキュリティ・プライバシー |
| `720_cloud_finops` | FinOps・コスト管理 |

---

## Appendix C: FinOps チェックリスト

### 初期セットアップ
- [ ] 全GCPリソースに`environment`/`service`/`owner`/`cost-center`/`ai-feature`ラベルを付与
- [ ] Billing Export to BigQueryを有効化
- [ ] 予算アラート（50%/80%/100%/120%）を設定
- [ ] 予算超過時の自動応答（Pub/Sub + Cloud Run Functions）を設定
- [ ] AI関連コストの独立追跡を設定

### 月次レビュー
- [ ] コスト実績と予算の照合
- [ ] 未使用リソースの監査・削除
- [ ] サービスアカウントの監査
- [ ] Committed Use Discountsの適用検討
- [ ] Recommender APIの推奨事項の確認
- [ ] AI トークン消費量の最適化レビュー

### Cloud Run Functions 最適化
- [ ] メモリ/CPUの適正化（Recommender APIの推奨に基づく）
- [ ] `minInstances`の最適化（不要な常時起動の削減）
- [ ] `maxInstances`の設定（暴走防止）
- [ ] 未使用関数の削除

### Firebase サービス最適化
- [ ] Firestoreの読み取り/書き込みコストの監視
- [ ] Cloud Storageのライフサイクルルール設定
- [ ] FCMトークンの定期クリーンアップ
- [ ] Authentication MAUの監視
- [ ] App Hosting のBlaze無料枠監視

---

## Appendix D: セキュリティチェックリスト

### 初期セットアップ
- [ ] App Checkを全Firebaseサービスに有効化
- [ ] Security Rules のDefault Denyパターンを適用
- [ ] 本番環境から`roles/owner`/`roles/editor`を除去
- [ ] Workload Identity Federationを設定
- [ ] Secret Managerに全機密情報を移行
- [ ] VPC Service Controlsを本番環境に設定
- [ ] Cloud Armor WAFポリシーを適用
- [ ] Binary Authorizationを有効化

### 定期監査（90日ごと）
- [ ] サービスアカウントとキーの棚卸し
- [ ] IAM権限の最小権限レビュー
- [ ] Secret Managerのシークレットローテーション
- [ ] 依存関係の脆弱性スキャン（`npm audit`, `snyk`）
- [ ] コンテナイメージの脆弱性スキャン
- [ ] Security Rulesの見直し
- [ ] OWASP Top 10対策の確認

### AI セキュリティ
- [ ] AI入出力のガードレール設定
- [ ] MCPサーバーのアクセス制御確認
- [ ] AI機能のKill Switch（Remote Config）設定
- [ ] AIエージェントの自律性レベル分類
- [ ] EU AI Act リスク分類の実施
