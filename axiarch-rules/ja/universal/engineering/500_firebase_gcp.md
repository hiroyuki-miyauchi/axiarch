# 32. バックエンドエンジニアリング (Backend Engineering - Firebase & GCP)

> [!CAUTION]
> **このファイルは Universal Rule（不変ルール）です。「憲法改正」の明示的指示がない限り編集禁止。**
> 改定日: 2026-07-23

> [!IMPORTANT]
> **Primary Directive（主要方針）**
> 「Firebase/GCPは能力に基づいて採用し、データ・権限・コスト・復旧の責任境界を明示する。」
> Firebase/GCPの実装において、**セキュリティ・プライバシー > データ整合性・信頼性 > コスト効率(FinOps) > パフォーマンス > 開発生産性** の優先順位を厳守せよ。App Check、Security Rules、IAM、冪等性、retry等は利用surfaceと脅威に応じて選ぶcontrolである。
> この文書はFirebase/GCPを採用したシステム向けのプロバイダープロファイルである。
> **57セクション（§0〜§56）・Rule 32.1〜32.175・Appendix A〜E 構成。**

> [!NOTE]
> **Universal適用契約**
> 本ファイルはFirebase/GCPの採用を全プロジェクトへ強制せず、Supabaseその他のデータ基盤に従属させない。採用判断は `engineering/520_cloud_application_platforms.md` に従い、利用する機能に対応する規則だけを適用する。サービス名、generation、runtime、上限、料金、リージョン、CLI、既定値は変動情報として、実装時に公式文書と実効設定を再確認する。固定構成、固定閾値、固有の命名はBlueprintへ配置する。

---

## 目次

**I. 基盤・哲学**
- §0. 主要方針 (Primary Directives)
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

**XVIII. 開発環境の可搬性**
- §41. Firebase Studio Sunset & 開発環境の可搬性

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

**XXIV. アンチパターン・技術lifecycle**
- §54. アンチパターン35選
- §55. 技術lifecycle radar

**XXV. 言語・SDK・runtime support**
- §56. 言語・SDK・runtime support surface

**Appendix**
- Appendix A: サービス別逆引き索引
- Appendix B: クロスリファレンス
- Appendix C: FinOps チェックリスト
- Appendix D: セキュリティチェックリスト
- Appendix E: 公式資料スナップショット

---

## §0. 主要方針 (Primary Directives)

### Primary Directive 0.1: Authoritative Data Boundary（権威データ境界）
-   **Law**: データ領域ごとに権威ある保存先を一つ定義し、Firestore、Data Connect、Cloud SQL、Supabaseその他の候補を整合性、クエリ、オフライン、レイテンシ、運用、規制、退出要件で評価する。
-   **Mandate**:
    1.  **Explicit Ownership**: 各データ集合のowner、system of record、同期方向、競合解決、保持、削除、exportを明示する。
    2.  **Firestore Validity**: Firestoreは文書・リアルタイム・オフライン要件に適合し、Security Rules、IAM、index、cost、backup、portabilityが設計される場合に有効な選択肢である。
    3.  **No Accidental Dual Authority**: 複数ストアへの二重書き込みは、outbox、idempotency、reconciliation、障害時挙動を備えない限り禁止する。

### Primary Directive 0.2: Defense in Depth（多層防御原則）
-   **Law**: セキュリティは単一レイヤーに依存してはならない。client attestation、authentication、Security Rules、IAM、network control、abuse control、監査から、利用surfaceと脅威モデルに適用可能な相互補完controlを選び、各controlが保護しない境界を明記する。
-   **Mandate**:
    1.  **App Check Where Eligible**: 対応するクライアント面とバックエンドではリスクに応じてApp Checkを段階導入する。App CheckはFirebase Authentication、Security Rules、IAM、rate limitの代替ではない。
    2.  **Least Privilege**: 全てのworkload identityとIAM bindingは最小権限にし、broad basic roleを通常の本番実行identityへ付与しない。人間のemergency accessは分離、time-bound、承認、監査する。
    3.  **Zero Trust Network**: VPC Service Controls、Private Google Accessその他のnetwork controlは、対象serviceの対応状況、data exfiltration risk、latency、cost、operational complexityを評価して適用する。

### Primary Directive 0.3: Idempotency First（冪等性最優先原則）
-   **Law**: retry、redelivery、timeout後の再実行が起こり得るevent handler、job、mutation endpoint、外部side effectを冪等または重複安全に設計する。read-only requestまで同一実装patternへ強制せず、side-effect boundaryごとに保証を定義する。
-   **Mandate**:
    1.  **Stable Idempotency Identity**: retry／redeliveryされるside effectは、event ID、resource version、business operation ID等から安定したidempotency keyを定義する。`eventId`だけを全triggerへ固定しない。
    2.  **Atomicity at the Boundary**: 同一database内のclaim、state transition、複数document invariantにはtransaction／conditional write／batchを適用する。単一document writeまで機械的にtransaction化せず、外部side effectはprovider idempotency key、outbox、lease／fencing、reconciliation等でdatabase transaction外のfailureを扱う。
    3.  **Retry Safety**: リトライにより副作用が重複しないことを保証する。

### Primary Directive 0.4: FinOps Guardian（コスト監視原則）
-   **Law**: クラウドコストは「技術的負債」と同等の管理対象である。予算超過は障害と同等に扱う。
-   **Mandate**:
    1.  **Budget Controls**: 通知閾値、forecast、quota、rate limit、spend anomaly、ownerをworkloadの重要度と課金モデルに応じてBlueprintで定義する。Budget alertは支出のhard capではない。
    2.  **Safe Automated Response**: 自動制限は安全性、データ整合性、法令、SLOを損なわない対象に限定し、段階的縮退と手動復旧手順を備える。
    3.  **Cost Attribution**: resourceが対応するlabel／tag、project／folder、billing export、service metadataを用いてenvironment、service、owner、cost centerへ費用を帰属させる。全resourceが同じlabel keyを支持すると仮定せず、非対応resourceはmapping table等で補完する。

### Primary Directive 0.5: Compute Lifecycle（コンピュート世代管理）
-   **Law**: 利用中のfunctions、services、jobsとruntime generationを台帳化し、公式support、EOL、互換性、workload適合性に基づいて選定・移行する。
-   **Mandate**:
    1.  **Naming**: ドキュメント・コード・IaCにおいて「Cloud Run Functions」の名称を使用する。
    2.  **Unified Management**: Cloud Run Functions、Cloud Run Services、Cloud Run Jobsを統一的に監視・管理する。
    3.  **Migration Path**: legacy generationは、公式期限とリスクに基づく移行計画、互換性試験、rollbackを備え、未検証の一括移行を避ける。

---

## §1. Firebase プロジェクト戦略 & GCP 統合

### Rule 32.1: プロジェクト分離戦略
-   **Mandate**: 開発・検証・本番のidentity、data、secret、quota、billing、deploy権限、blast radiusを分離する。別Firebase/GCPプロジェクトは強い標準例であり、共有プロジェクトを選ぶ場合は同等の境界と例外承認を証明する。
-   **Structure**:
    ```
    myapp-dev      → 開発環境（自由にテスト可能）
    myapp-staging  → ステージング環境（本番同等構成）
    myapp-prod     → 本番環境（厳格なIAM制御）
    ```
-   **Rationale**: 環境分離により、開発ミスが本番に影響するリスクを物理的に排除。課金・アクセス制御も分離。

### Rule 32.2: GCPプロジェクト構成
-   **Mandate**: FirebaseプロジェクトはGCPプロジェクトとして、継続可能なowner、resource hierarchy、billing、policy、identity境界へ配置する。企業利用ではOrganization、Folder、Project、group-based IAMをteam、環境、法域、compliance、shared serviceの境界に合わせる。個人・小規模利用へ不要なFolderや専任teamを強制せず、project-level統制を選ぶ場合も所有移管、退職・離脱、billing、break-glass、将来のOrganization編入経路を記録する。
-   **Configuration**:
    -   **Hierarchy**: Organization／Folder／Projectのpolicy inheritanceと例外scopeを検証し、単一巨大projectや個人所有projectを暗黙のteam境界にしない。
    -   **Identity**: 人間の継続権限は可能な範囲で個人bindingではなく管理されたgroupとjob functionへ付与し、workload identity、CI、break-glassを分離する。
    -   **Billing Account**: 環境、service、team、cost centerへ費用を帰属させ、productionと非productionの予算・abuse制御をriskに応じて分離する。
    -   **API Enablement**: 必要なAPIを明示的に有効化する（`firebase.googleapis.com`, `run.googleapis.com`, `artifactregistry.googleapis.com`等）。

### Rule 32.3: リージョン選定
-   **Mandate**: 利用者分布、data residency、サービス間latency、可用性、carbon、価格、復旧、各サービスのlocation互換性を評価してリージョンを選定し、決定をADRへ記録する。
-   **Caution**: 作成後の移動に制約があるデータサービスは、初期作成前に移行・replication・backup・exitを設計する。
-   **Dynamic Availability**: GPU、runtime、multi-region、service availabilityは変動するため、deploy時に公式region matrixを再確認する。

### Rule 32.4: Billing Plan適合性
-   **Mandate**: 採用機能が要求するbilling plan、無料枠、課金単位、quota、停止挙動を公式文書で確認する。App Hosting等の従量課金planを要する機能だけを根拠に、全Firebase projectへ一律のplanを強制しない。
-   **Action**: 従量課金を有効化する前にbudget alert、quota、abuse防止、cost owner、緊急縮退、請求exportを構成する。alert単体はhard capではない。

---

## §2. Cloud Run Functions（旧 Cloud Functions 2nd Gen）

### Rule 32.5: Cloud Run Functions 標準化
-   **Mandate**: 新規functionは公式に推奨され、必要なruntime、trigger、latency、duration、network、observability、costを満たす現行generationを選ぶ。legacy generationの新規採用には期限付き例外が必要である。
-   **Advantage**:
    -   Cloud Run基盤による高性能（最大32GB RAM、8 vCPU）
    -   並列処理（Concurrency）対応（デフォルト80、最大1000）
    -   Eventarcによる125+イベントソース対応
    -   トラフィック分割・リビジョンロールバック
    -   HTTP関数は最大1時間実行可能
-   **Supported Runtimes**: deploy時点の公式runtime一覧とEOLを確認し、`engineering/320_programming_language_governance.md` の選定基準、team能力、library compatibilityに従ってversionをpinする。

### Rule 32.6: コールドスタート対策
-   **Mandate**: latency-sensitive functionはcold-start率、p95／p99、traffic shape、dependency初期化、idle costを計測し、SLOとcost budgetを満たす対策を選ぶ。
-   **Strategies**:
    1.  **Min Instances**: 実測SLOが必要とし、idle billingをownerが承認したenvironmentだけで最小instanceを設定する。test環境や低traffic workloadへ一律設定しない。
    2.  **Concurrency**: handler、SDK、global stateがthread／request safeで、CPU／memory／downstream capacityが許す値をload testで決める。
    3.  **Instance Reuse**: immutable client、connection pool、model等を安全に再利用し、credential refresh、stale state、connection limitをtestする。
    4.  **Initialization**: critical pathをprofileし、lazy load、artifact削減、connection reuse等を比較する。
    5.  **No Synthetic Warmup Default**: scheduler pingを通常のcold-start対策にせず、min instances、architecture変更、SLO緩和との費用・quota・観測歪みを比較し、採用時は期限付き例外にする。

### Rule 32.7: ランタイム設定
-   **Mandate**: memory、CPU、timeout、concurrency、min／max instances、regionをworkloadの実測、downstream limit、SLO、cost、provider defaultから決定し、defaultを採用する場合も理由と解決値をevidence化する。
-   **Configuration**:
    ```typescript
    export const processOrder = onRequest({
      region: "asia-northeast1",
      memory: "512MiB",
      timeoutSeconds: 120,
      minInstances: 0,
      maxInstances: 100,
      concurrency: 80,
      cpu: 1,
    }, handler);
    ```
-   **Guidelines**: 次表はload test前の非規範的な観測開始点であり、release既定値ではない。
    | 用途 | Memory | Timeout | Min Instances | Concurrency |
    |---|---|---|---|---|
    | APIエンドポイント | 256-512MiB | 60s | 1 | 80 |
    | 画像処理 | 1-2GiB | 300s | 0 | 10 |
    | バッチ処理 | 2-4GiB | 540s | 0 | 1 |
    | Webhook受信 | 256MiB | 30s | 0 | 80 |
    | AI推論（CPU） | 4-8GiB | 300s | 0 | 4 |
    | Genkit AIフロー | 1-2GiB | 120s | 0-1 | 20 |

### Rule 32.8: 関数の組織化
-   **Mandate**: ownership、dependency、deploy／rollback、blast radius、build timeに沿ってfunctionをmoduleまたはcodebaseへ分割する。Codebasesは独立lifecycleに価値がある場合の候補である。
-   **Illustrative Structure**:
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
-   **Deployment**: function数の固定上限で分割せず、provider quota、deploy duration、failure isolation、change graphを測定し、再実行可能なdeploy groupを定義する。

### Rule 32.9: 冪等性の実装
-   **Mandate**: redeliveryまたはretryされるevent handlerは冪等またはduplicate-safeに設計し、side effectごとに保証とrecoveryを定義する。
-   **Protocol**:
    1.  **Atomic Claim**: read-then-writeで処理済みを確認しない。transaction／create-if-absent等でidempotency keyを原子的にclaimし、status、lease owner、expiry、attempt、result referenceを保存する。
    2.  **External Side Effect**: payment、email、webhook等は相手providerのidempotency keyを再利用するか、transactional outbox／inboxとreconciliationを使う。database markerをexternal call後に書くだけではcrash windowを閉じられない。
    3.  **Lease Recovery**: `processing`のまま停止したclaimを安全に再取得するtimeoutとfencingを定義し、完了resultを再利用できるようにする。
    4.  **Failure Test**: 同時delivery、claim直後crash、external成功後timeout、marker書込失敗、順序逆転をfault-injection testする。

### Rule 32.10: 1st Gen → Cloud Run Functions 移行
-   **Mandate**: legacy functionは公式support期限、security、runtime、trigger互換、costに基づく期限付き移行計画を持ち、検証済みtarget generationへ段階移行する。
-   **Migration Tool**: GCP提供toolが現行support対象なら候補とし、生成差分、trigger、IAM、rollbackをreviewする。
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
    1.  **Language & Artifact Contract**: Cloud Run Servicesはcontainer contractを満たす任意の言語を候補にできる。source deployのmanaged runtime／buildpackとcustom containerを区別し、base image、Linux ABI／architecture、listening address／`PORT`、dependency、SBOM、patch責任、runtime EOLをartifactへ結び付ける。Cloud Run Functionsのmanaged runtime対応をCloud Run Servicesの言語上限と誤認しない。
    2.  **Stateless**: instance間でlocal memoryや一時filesystemをdurable stateとして共有せず、authority、consistency、latency、costに適合する外部state serviceへ保存する。Firestore、Cloud SQL、Redisは候補である。
    3.  **Startup Budget**: CPU／GPU、image size、dependency、traffic、min instance、SLOからstartup budgetをBlueprintで定義し、測定します。
    4.  **Health Check**: current Cloud Run health mechanismとapplication semanticsに合うstartup／liveness probeまたは同等signalを実装します。固定pathを要件にしません。
    5.  **Graceful Shutdown**: current termination contract内でSIGTERM、request drain、checkpoint、connection closeを処理し、cleanup budgetを実測します。

### Rule 32.14: Cloud Run GPU サポート（GA）
-   **Mandate**: AI/ML workloadでGPUが必要な場合、model fit、latency、throughput、startup、region、quota、driver、security、cost、fallbackを比較し、Cloud Run GPUを候補として評価する。CPU、managed AI、batch、他基盤の方が適合する場合は強制しない。
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
-   **Availability**: GPU type、region、quota、上限はdeploy時に公式文書とproject設定を再確認する。

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
-   **Mandate**: Firebase Authenticationを採用する場合、identity profileとdomain dataの権威境界、UID mapping、account deletion、export、他の認証基盤への移行手順を定義する。domain dataの保存先はPrimary Directive 0.1で選定する。
-   **Selection Matrix**: 次表は候補の例であり、Universal優先順位ではない。user population、platform policy、account recovery、MFA、enterprise federation、privacy、cost、migrationから選ぶ。
    | プロバイダ | 代表用途 | 適用条件 |
    |---|---|---|
    | Google Sign-In | consumer／workspace identity | 対象userとplatformに適合 |
    | Apple Sign-In | Apple platform | App Store policyと採用login構成により必要 |
    | Email／Password | password-based identity | recovery、breach defense、MFAを運用可能 |
    | Phone (SMS) | phone verification／fallback | SIM swap、cost、regional deliveryを受容 |
    | Anonymous | guest access | lifecycle、abuse、linking、cleanupを設計 |
    | SAML／OIDC | enterprise federation | tenant discovery、claim mapping、offboardingを設計 |
-   **Default Deny**: Firestoreは認証・認可を既定とする。意図的な公開コンテンツは、公開範囲、rate limit、abuse防止、PII不在をSecurity Rulesとtestで証明する。

### Rule 32.23: Passkeys / FIDO2 対応
-   **Mandate**: パスワードレス認証としてPasskeys (FIDO2)の導入を推奨する。
-   **Implementation**: Firebase Authentication with Identity Platform（GCIP）の`Passkey`プロバイダを使用。
-   **Benefit**: フィッシング耐性、パスワードリスト攻撃の排除、ユーザーUXの向上。

### Rule 32.24: Custom Claims（カスタムクレーム）
-   **Mandate**: Custom Claimsはtoken sizeとrefresh delayを許容できる、粗粒度で安定したauthorization attributeに限定する。高頻度に変わるpermission、subscription状態、resource membershipの正本にせず、database／policy service等と使い分ける。
-   **Rules**:
    1.  Admin SDKでのみ設定（クライアントからの設定は禁止）。
    2.  ペイロードは1000バイト以内に制限。
    3.  変更はtoken refreshまで反映されないため、権限削除、緊急失効、stale claimの許容時間をriskに基づいて設計する。固定猶予時間をUniversal既定にしない。
    ```typescript
    // Admin SDK: カスタムクレーム設定
    await admin.auth().setCustomUserClaims(uid, {
      role: "admin",
      plan: "premium",
    });
    ```

### Rule 32.25: Token管理とセッション設計
-   **Mandate**: ID TokenとRefresh TokenのTTL、更新、失効、再認証は、公式の現行契約とriskに基づいて設計し、client clock、revocation delay、offline behaviorをtestする。
-   **Security**:
    1.  Webではsecure／HTTP-only／SameSite Cookie、nativeではOSのsecure storage、SDK管理session等、surfaceに適した保存方式を使う。任意scriptが読める汎用storageへ高権限tokenを置かない。
    2.  account侵害時はrefresh tokenをrevokeし、高risk backendでは`checkRevoked`またはSecurity Rules等の失効確認を適用する。既発行ID tokenは短命だがstatelessであり、revoke callだけで全resourceが即時拒否すると仮定しない。
    3.  Multi-Factor Authentication (MFA) を管理者・高権限ユーザーに必須化。

### Rule 32.26: 認証イベント監視
-   **Mandate**: 認証イベント（ログイン、失敗、アカウント作成）をCloud Loggingにストリームし、不正アクセスを検知する。
-   **Detectable Events**: 異常なログイン頻度、地理的異常、ブルートフォースパターン。

---

## §6. App Check & アプリ認証

### Rule 32.27: App Check適用
-   **Mandate**: 対応するapp surfaceとbackendについて、脅威モデルとclient compatibilityに基づいてApp Checkを評価・導入する。monitoringで正規trafficのattestation率と失敗影響を確認してからenforcementへ進む。
-   **Attestation Providers**:
    | プラットフォーム | プロバイダ | 推奨 |
    |---|---|---|
    | Android | Play Integrity API | ✅ |
    | iOS | App Attest (Device Check) | ✅ |
    | Web | reCAPTCHA Enterprise | ✅ |
-   **Enforcement Mode**: 正規trafficの成功率、unsupported client、false rejection、rollback手順がBlueprint基準を満たした後に段階enforcementする。

### Rule 32.28: カスタムバックエンドでのApp Check
-   **Mandate**: Firebase clientから呼ばれ、App Check対応SDK／clientとthreat modelが適合するcustom backendではtoken検証を導入する。server-to-server、unsupported client、third-party webhook等へ一律強制せず、IAM、OAuth、mTLS、signature、rate limit等の適切なcontrolを選ぶ。
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
-   **Mandate**: FirestoreはPrimary Directive 0.1の能力評価を通過し、Security Rules、IAM、index、quota、cost、backup、export、data retentionが設計されたデータ領域に使用する。
-   **Representative Use Cases**:
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
    1.  **Default Deny and Explicit Authorization**: 既定denyを基礎とし、許可pathごとにsubject、resource、action、tenant、field、time等を検証する。意図的なpublic readはscope、PII不在、abuse／cost control、testを明示し、`request.auth != null`を全pathへ機械的に追加しない。
    2.  **スキーマ検証**: `request.resource.data`の型・値・サイズを検証する。
    3.  **Custom Claims検証**: 管理者操作は`request.auth.token.role == 'admin'`で制御。
    4.  **Functions活用**: ルールロジックの再利用にはSecurity Rules Functionsを使用。
    5.  **テスト必須**: `@firebase/rules-unit-testing`で全ルールをテスト（§31参照）。
    6.  **バージョン管理**: Security Rulesファイルは必ずGit管理下に置く。

### Rule 32.33: Firestore クエリ最適化
-   **Mandate**: Firestoreクエリは常にパフォーマンスとコストを意識する。
-   **Rules**:
    1.  **Bounded Reads**: user-controlled、collection-wide、反復実行されるreadはlimit、cursor、termination condition、quotaを持つ。unique-key lookupや明確に有界なreadでは不要なpaginationを強制せず、最大結果数をdata contractで証明する。
    2.  **カーソルベースページネーション**: `startAfter()`/`endBefore()`を使用。
    3.  **複合インデックス**: 複合クエリには明示的にインデックスを定義。
    4.  **Document Budget**: access pattern、update contention、index fanout、network、offline requirementからdocument size budgetをBlueprintで定義し、固定10KBをUniversal目標にしない。
    5.  **Collection Shape**: subcollection、reference、denormalizationはquery、transaction、deletion、Security Rules、costのtrade-offで選び、一律のnesting patternを強制しない。
    6.  **Caching**: offline persistenceとcache indexはdevice trust、shared-device privacy、freshness、storage、query profileを評価して有効化する。
    7.  **Hotspot Avoidance**: high-write pathではsequential key、単一document、narrow key rangeによるhotspotをload testで検証し、必要に応じてdistributed IDやshardingを採用する。

---

## §8. Firebase Data Connect (Cloud SQL) — GA

### Rule 32.34: Data Connect 概要
-   **Mandate**: Firebase Data Connect（2025年4月GA）はCloud SQL PostgreSQLを基盤とするBaaSサービス。SQLベースのバックエンドが必要な場合に活用を検討する。
-   **Features**:
    -   GraphQLベースのスキーマ定義とクエリ言語
    -   リレーショナルデータモデルのFirebase統合
    -   AI支援によるオンボーディングとスキーマ生成
    -   Firebase SDK（Web, iOS, Android, Flutter）によるクライアントアクセス
-   **Caution**: Data Connect、Firestore、Cloud SQL、Supabase等は、データモデル、認可境界、SDK統合、運用、lock-in、costを同じ評価表で比較し、既存vendorの存在だけで決定しない。

### Rule 32.35: Relational Backend Capability Decision
-   **Decision Contract**: Data Connect、Supabase、Cloud SQLその他のrelational backendを、特定vendorを既定勝者にせず同一evidenceで比較する。

    | 判断軸 | 必須確認 |
    |---|---|
    | Data ownership | authoritative store、replication、export、retention、deletion |
    | Authorization | client／server境界、row／field control、testability、admin path |
    | Contract | schema、generated SDK、transaction、migration、backward compatibility |
    | Runtime integration | supported client／server runtime、offline／realtime、network path |
    | Operations | backup／restore、observability、SLO、incident、team permission |
    | Economics and exit | usage-based cost、egress、lock-in、migration proof、sunset plan |

---

## §9. Cloud Storage for Firebase

### Rule 32.36: Storage 設計原則
-   **Mandate**: Cloud Storage for Firebaseを採用する場合、object ownership、public／private境界、retention、malware、metadata、egress、restore、exitを設計する。file storageの選定は§0.1と`engineering/520_cloud_application_platforms.md`のcapability評価に従い、本serviceを全projectへ強制しない。
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
-   **Mandate**: file size、network不安定性、mobile background、provider threshold、再送costに基づき、失敗影響が大きいuploadへresumable／multipart方式を採用する。固定サイズ閾値はBlueprintで決める。

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
-   **Mandate**: Firebase統合、自動build/rollout、framework support、region、observability、cost、rollbackが要件に適合する場合、App HostingをSSR/SSGの候補として評価する。全Next.js/Angular projectへの一律強制は禁止する。
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
-   **Supported Frameworks**: 公式の現行framework/version matrixをdeploy時に確認する。
-   **Cost**: App Hostingはbilling accountを伴うplan、build、runtime、bandwidth等の課金境界を確認し、budget alertがhard capではない前提でguardrailを設計する。

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
    3.  **定期クリーンアップ**: providerのstaleness guidance、送信結果、app利用周期、privacy／retention要件からBlueprintの期限を決め、stale tokenを段階的に無効化・削除する。
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

### Rule 32.48: Crashlytics適用
-   **Mandate**: Crashlyticsを採用するmobile appでは、release artifact、symbol、version、environment、privacy-safe contextを結び、代替crash platformとの二重計測を意図なく作らない。
-   **Configuration**:
    1.  **dSYMアップロード**: iOSではビルド時にdSYM（デバッグシンボル）を自動アップロード。
    2.  **Proguardマッピング**: AndroidではProguard/R8のマッピングファイルをアップロード。
    3.  **Non-Fatal Error**: クリティカルでないエラーも`recordError()`で記録。
    4.  **Custom Keys**: デバッグに有用なカスタムキー（ユーザーID、画面名等）を設定。
    5.  **Breadcrumbs**: ユーザー操作のパンくずリストを記録。

### Rule 32.49: Crash-Free Rate 目標
-   **Mandate**: crash-free users／sessions、severity、affected cohortをservice SLOとしてBlueprintに定義し、breach時のrelease停止、rollback、incident基準を持つ。固定率を全appへ強制しない。
-   **Monitoring**: Crashlytics Alertsを設定し、新しいクラッシュクラスタを即座に検知。

---

## §14. Performance Monitoring

### Rule 32.50: Performance Monitoring 設定
-   **Mandate**: Firebase Performance Monitoringを採用する場合、主要user journeyのperformance metricを計測し、platform共通のSLIと相関可能にする。
-   **Tracked Metrics**:
    1.  **App Start Time**: device／OS／network cohort別にcold／warm startを計測。
    2.  **HTTP Response Time**: APIのp50／p95／p99とerror rateを計測。
    3.  **Screen Rendering**: slow／frozen frameと主要画面のrender時間を計測。
    4.  **Network Payload Size**: 過大なレスポンスサイズの検出。
-   **Custom Traces**: ビジネスクリティカルな操作（ログイン、決済、検索等）にカスタムトレースを設定。

---

## §15. Google Analytics for Firebase

### Rule 32.51: Analytics 統合
-   **Mandate**: 明示したproduct／business outcomeに必要な最小限のeventだけを、data classification、lawful basis／consent、retention、deletion、access、sampling、costとともに計測する。Google Analytics for Firebaseは候補であり、全行動・全属性の収集を禁止する。
-   **Configuration**:
    1.  **Event Contract**: event name、purpose、owner、property schema、PII禁止、retention、downstream consumerをregistry化する。
    2.  **Automatic Events**: providerの自動収集項目とdefaultをinventoryし、不要な収集を無効化または同意前に送信しない。
    3.  **User Properties**: sensitive attribute、精密位置、永続identifierを安易に設定せず、cohort re-identification riskを評価する。
    4.  **Validation**: debug／stagingでschema、duplicate、consent state、deletion、export costを検証する。
-   **Privacy**: 適用法、地域、年齢、platform policyに応じてconsent、opt-out、deletion、data processing termsを設計し、Consent Modeだけを法令遵守の証明にしない。

---

## §16. Firebase AI Logic & Genkit

### Rule 32.52: Firebase AI Logic 概要
-   **Mandate**: clientから生成AIへ接続する場合、Firebase AI Logicを候補として、model、region、data use、App Check、認可、rate、safety、evaluation、cost、server proxyとの責任差を比較する。
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
-   **Mandate**: GenkitはAI workflow frameworkの候補であり、既存AI正本に従ってmodel portability、evaluation、observability、tool security、runtime、team support、exitを比較して採用する。
-   **Language Support**: Node.js、Go、Python等の対応version、status、feature parity、EOLを採用時とupgrade時に公式documentで再確認する。
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
-   **Mandate**: Genkitを採用し、LLMに外部データアクセスやaction実行を許可する場合は、Genkit Tool Calling等のtyped tool contractを使い、任意code実行や無制限権限を与えない。
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
    2.  **Budget Threshold**: AI関連コストの予算、単位経済性、成長率、異常検知thresholdをfeature ownerとFinOps ownerがBlueprintで定義する。
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
-   **Mandate**: 定型integrationではFirebase Extensions、managed integration、自前実装を、権限、data flow、release cadence、support、cost、observability、exitで比較し、第三者codeとconfigurationをsupply-chain reviewする。
-   **Candidate Examples**:
    | Extension | 用途 |
    |---|---|
    | Stream Firestore to BigQuery | Firestoreデータの分析基盤構築 |
    | Resize Images | アップロード画像の自動リサイズ |
    | Translate Text | テキストの自動翻訳 |
    | Trigger Email | メール送信の自動化 |
    | Delete User Data | ユーザー削除時のデータクリーンアップ |

### Rule 32.67: カスタムExtension
-   **Applicability**: 複数environment／projectで再利用し、独立したversion、configuration contract、test、owner、upgrade／deprecationを維持できる処理だけをcustom Extension化する。一度限りのproject logicを無理にpackage化しない。

---

## §20. BigQuery 連携 & データ分析基盤

### Rule 32.68: 分析データ基盤の権威境界
-   **Mandate**: analytics、billing、operational telemetryごとにauthoritative source、warehouse／lakehouse、freshness、lineage、retention、deletion、access、costを定義する。BigQueryはGCP／Firebase workloadの有力候補だが、全データの一律集約や機微dataの不要な複製を強制しない。
-   **Candidate Sources**:
    -   Firebase Analytics → BigQuery Export
    -   Firestore → BigQuery Extension
    -   Cloud Logging → BigQuery Sink
    -   Billing Data → BigQuery Export

### Rule 32.69: ELTパターン
-   **Mandate**: ETL、ELT、stream processingをlatency、volume、privacy、source load、replay、costから選ぶ。raw zoneを持つ場合もimmutable、encryption、access、retention、schema evolution、deletion propagationを設計し、BigQueryやdbtをUniversalの固定実装にしない。
    ```
    Source → Raw Layer (BigQuery) → Staging Layer (dbt) → Mart Layer (dbt) → Dashboard
    ```

### Rule 32.70: データ品質
-   **Mandate**: データパイプラインに自動品質テストを組み込む。
-   **Tests**:
    1.  **Freshness**: データの鮮度チェック。
    2.  **Volume**: 曜日性、seasonality、source別baseline、expected growthを考慮した動的thresholdでrecord数の異常を検知する。
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
    2.  **認証情報のライフサイクル**: keyless／short-lived identityを優先する。長期credentialが不可避なら、risk、provider capability、規制、incident responseに基づくrotationと即時revocationを自動化する。
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
-   **Prohibited**: 通常のproduction workload identity、CI identity、恒久的な人間accessへ`roles/owner`／`roles/editor`等のbroad basic roleを付与してはならない。
-   **Recommended**: predefined roleを最小scopeで組み合わせ、必要な場合だけversion管理されたcustom roleを作る。IAM Recommenderはevidenceとしてreviewし、機械的に適用しない。emergency owner accessは分離、time-bound、強固な認証、承認、alert、監査を備える。

### Rule 32.75: サービスアカウント管理
-   **Mandate**: trust boundary、privilege、environment、lifecycle、blast radiusが異なるworkloadを別service accountへ分離する。全functionへ無条件に個別accountを作らず、過剰なidentity sprawlとshared high privilegeの両方を避ける。
-   **Best Practices**:
    1.  **Boundary-aligned Accounts**: production／non-production、runtime／deployment、異なるdata classやprivilegeを分離し、同じ権限・owner・lifecycleを持つ低risk workloadは根拠を残して共有できる。
    2.  **キーレス認証**: Workload Identity Federationを使用し、サービスアカウントキーの発行を最小化。
    3.  **定期監査**: identity inventory、利用telemetry、risk、compliance cadenceに基づき未使用のservice accountとkeyを監査し、安全に無効化・削除する。

### Rule 32.76: Workload Identity Federation
-   **Mandate**: 対応する外部identity providerやCIからGCPへ接続する場合はWorkload Identity Federation等のshort-lived federationを優先し、subject、repository／project、branch／environment、audience、attribute conditionを限定する。未対応経路で長期keyが不可避なら、期限付き例外、最小権限、保護されたsecret store、rotation、usage alert、失効手順を必須とする。

---

## §23. Secret Manager & 機密情報管理

### Rule 32.77: Approved Secret Store Protocol
-   **Mandate**: productionとshared environmentの機密情報は、承認済みprovider-nativeまたは組織secret storeで暗号化、access control、versioning、audit、rotation、revocationを管理する。GCP workloadではSecret Managerを標準候補とする。
-   **Prohibited**: 機密情報をsource、container image、client bundle、version管理対象の`.env`、平文CI設定、logへ保存・出力してはならない。local-only `.env`を使う場合はignore、sample分離、最小scope、短命value、漏洩scanを適用する。

### Rule 32.78: シークレットの管理
-   **Best Practices**:
    1.  **バージョニング**: シークレットはバージョン管理し、ロールバック可能に。
    2.  **自動ローテーション**: secretの種類、漏洩影響、provider capability、規制に応じてrotation／revocation cadenceをBlueprintで定義し、自動化する。漏洩時はcadenceを待たず即時失効する。
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
-   **Mandate**: 対応serviceでdata exfiltration risk、規制、identity境界が必要な場合にVPC Service Controlsを評価し、dry run、supported-service matrix、ingress／egress policy、break-glass、observabilityを検証して段階導入する。

### Rule 32.81: Private Google Access
-   **Mandate**: public IPを持たないsubnet resourceからGoogle APIへ到達させる場合はPrivate Google Accessその他の承認済みprivate pathを評価し、DNS、route、egress、service support、failure modeを検証する。

### Rule 32.82: Direct VPC Egress
-   **Mandate**: private resourceへの接続が必要なCloud Run Functions／Servicesでは、Direct VPC egress、connector、別architectureをlatency、throughput、IP、cost、availabilityで比較する。
-   **Configuration**: `private-ranges-only`相当か`all-traffic`相当かをthreat model、inspection、NAT、external API到達性で選び、全traffic routingを無条件に強制しない。

### Rule 32.83: Cloud Armor WAF
-   **Mandate**: internet-facing HTTP surfaceの脅威、traffic、architectureが適合する場合、supported load-balancing pathとCloud Armorその他のWAF／DDoS controlを評価する。直接endpointを残す場合はbypass防止を検証する。
-   **Architecture**: Cloud Run → Serverless NEG → Application Load Balancer → Cloud Armor Security Policy。
-   **Policy**:
    1.  **OWASP Top 10 WAFルール**: SQL Injection、XSS等の事前構成ルールを適用。
    2.  **Adaptive Protection**: DDoS攻撃の自動緩和。
    3.  **Rate Limiting**: 不正トラフィックパターンの制限。
    4.  **Geo Restriction**: 必要に応じた地理的制限。
    5.  **Bot Management**: Botトラフィックの検出と制御。
-   **Testing**: 新ポリシーは必ず「preview」モードで影響を評価してからエンフォースメント。

### Rule 32.84: Private Service Connect
-   **Applicability**: private connectivityが脅威モデル、data exfiltration、compliance、latencyに必要な場合、Private Service Connect、private IP、VPC connector、provider-supported同等手段をservice support、DNS、egress、failover、costから選び、public bypassを検証する。

---

## §25. FinOps & コスト最適化

### Rule 32.85: コスト配分の原則
-   **Mandate**: billing export、project／folder hierarchy、supported labels／tags、service metadataを組み合わせ、material costをenvironment、service、owner、cost center、featureへ追跡できるようにする。label非対応resourceはmapping inventoryと代替配賦を持つ。
-   **Candidate Dimensions**:
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
-   **Mandate**: 課金が発生しうる環境には、owner、通知先、実額・予測額、対応runbookを持つ多段階alertを設定する。閾値はBlueprintで定義し、alertがhard capではないことを明記する。
    | 段階 | 実際コスト | 予測コスト | アクション |
    |---|---|---|---|
    | 早期警告 | Blueprint値 | forecast閾値 | cost owner通知・原因確認 |
    | 注意 | Blueprint値 | forecast閾値 | 担当チームへescalation |
    | 危険 | 承認済み上限付近 | 承認済み上限付近 | 安全な縮退・変更凍結を検討 |
    | 超過 | 承認済み上限超過 | — | incident手順と経営判断 |

### Rule 32.90: 自動応答（Budget Automation）
-   **Architecture**:
    ```
    Budget Alert → Cloud Pub/Sub → Cloud Run Functions → アクション実行
    ```
-   **Actions**:
    1.  **Slack/Email通知**: 関連チームへの即時通知。
    2.  **リソース制限**: 事前に分類した非クリティカル機能を段階的に制限し、データ処理中のworkloadを突然停止しない。
    3.  **緊急停止**: 課金停止等の破壊的操作はbreak-glass承認、依存関係評価、復旧手順を満たす最終手段とする。
-   **Caution**: Budget通知は停止装置ではない。安全な自動化を別途設計し、本番停止やデータ損失を防ぐ。

### Rule 32.91: 月次レビュー
-   **Mandate**: spend volatility、予算、criticalityに応じたcadenceで実績・forecast・unit economics・anomaly・commitment・unused resourceをreviewし、ownerと対応期限を記録する。月次は安定workloadの候補であり固定周期ではない。

---

## §27. Observability (Cloud Logging / Monitoring / Trace)

### Rule 32.92: 構造化ログ
-   **Mandate**: machine-queryableなstructured loggingを採用し、runtime／agentがJSON envelopeを生成する場合はapplicationで二重encodeしない。event schema、severity、service、environment、trace／correlation、error class等を用途に応じて標準化する。
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
-   **Reference Fields**: `timestamp`, `severity`, `message`, `service`, `environment`, `traceId`／`correlationId`。provider自動付与とsignal用途を確認し、存在しないtraceを捏造しない。
-   **Prohibited**: 機密情報（パスワード、クレジットカード番号、PII）のログ出力は厳禁。

### Rule 32.93: Cloud Monitoring
-   **Mandate**: user journey、SLO、saturation、backlog、error、cost anomalyに結び付くsignalを選び、owner、severity、notification route、runbook、escalationを設定する。固定thresholdや通知先はUniversalへ置かず、traffic baseline、error budget、capacity test、予算からBlueprintで決める。
-   **Reference Signals**: request error／latency、event age／backlog、instance saturation、quota pressure、AI unit cost、budget consumptionは候補であり、未使用serviceのmetricを義務化しない。

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
-   **Mandate**: transientで、かつ処理が冪等または冪等性keyで保護される失敗だけを、deadlineとretry budget内で再試行する。providerのretry guidance、`Retry-After`、jitter付きbackoff、呼び出し階層全体の増幅を考慮し、回数と時間はBlueprintで決める。
-   **No Retry**: validation、認証／認可、恒久的なquota／configuration error、非冪等side effect、deadline超過を無条件再試行してはならない。event-driven functionのprovider retryを有効化する前にRule 32.15の冪等性とpoison-message処理を証明する。

### Rule 32.99: Dead Letter Queue (DLQ)
-   **Mandate**: リトライ上限を超えたメッセージはDead Letter Queueに転送する。

### Rule 32.100: Circuit Breaker
-   **Applicability**: downstream障害がresource exhaustion、retry storm、latency cascadeを起こし得る同期依存では、Circuit Breaker、concurrency limit、load shedding、fallbackの組み合わせを評価する。短命functionやprovider-managed clientで独自breakerが逆に状態不整合を生む場合は、deadline、bounded retry、queue isolationなどの代替controlと根拠を記録する。

---

## §29. Terraform / IaC 管理

### Rule 32.101: IaC必須化
-   **Mandate**: 再現可能なFirebase/GCP設定は、Terraform、Google Cloud Config Connector、provider-native構成、または承認済み同等手段でversion管理し、review・plan・drift detectionを行う。API未対応の手動操作は承認、監査証跡、再現手順、定期drift確認を必須とする。
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
-   **Mandate**: Terraform Stateは、encryption、access control、lockingまたは同等のconcurrency control、version／recovery、auditを備えた承認済みremote backendで管理する。GCSはGCP workloadの候補であり、backendのcurrent locking semanticsを検証する。stateの手動編集はbreak-glass手順以外禁止する。

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

### Rule 32.108: Emulator and Isolated Test Protocol
-   **Mandate**: 対象serviceをFirebase Emulator Suiteが十分なfidelityで再現する場合はlocal／CIの高速検証に使用する。非対応機能、IAM、quota、network、billing、provider integrationは隔離されたnon-production projectで補完し、emulator-only結果をproduction equivalenceとみなさない。
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
    2.  **Integration Test**: Emulator Suiteまたは隔離projectをfidelityに応じて使う統合テスト。
    3.  **E2E Test**: productionとの差異を記録したstaging環境での端末間テスト。

---

## §32. CI/CD パイプライン統合

### Rule 32.111: Provider-neutral CI/CD Contract
-   **Mandate**: CI providerに依存せず、lint、unit、Security Rules、emulator／isolated integration、IaC plan、artifact provenance、preview、approval、deploy、post-deploy verificationをriskに応じて構成する。次はGitHub Actionsを選定した場合の参考例であり、Universal要件ではない。
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
-   **Mandate**: CI providerがOIDC等の外部identityを提供する場合はWorkload Identity Federationを使用し、provider／repository／branch／environment claimを検証する。例外はRule 32.76に従う。

### Rule 32.113: デプロイメント戦略
-   **Flow**:
    1.  **PR**: 自動テスト + Lint + Security Rules テスト + `firebase hosting:channel:deploy`（プレビュー）。
    2.  **Merge to main**: 自動デプロイ（Staging環境）。
    3.  **本番**: 手動承認後のデプロイ（`git push`禁止プロトコルに準拠）。

---

## §33. 環境管理 (Dev / Staging / Prod)

### Rule 32.114: 環境分離
-   **Mandate**: productionと非productionのidentity、data、secret、billing、quota、deploy authority、observabilityをriskに応じて隔離する。単一project、複数project、folder／organization分離の選択はblast radius、compliance、team topology、costからBlueprintで決める。
-   **Access**: accessは職種名や「開発者全員」で固定せず、least privilege、separation of duties、time-bound elevation、break-glass、audit evidenceで設計する。environment名やproject namingは例でありUniversal契約ではない。

### Rule 32.115: 環境パリティ
-   **Mandate**: Stagingは本番の重要なidentity、policy、runtime、network、data contract、deploy／rollback経路を再現できなければならない。costやprivacy上の理由で縮小・合成dataを使う差分は、test coverageとresidual riskをdocument化する。

### Rule 32.116: 環境変数管理
-   **Non-Secret Configuration**: parameterized configurationまたはversion管理されたenvironment configをschema、default、owner、validation、rolloutとともに管理する。
-   **Secrets**: Secret Managerなどの承認済みsecret storeで管理し、必要なfunction／serviceへだけ明示的にbindingする。plan、log、client bundle、version管理対象へ値を露出しない。
-   **Legacy Migration**: `functions.config()`は非推奨であり、2027年3月以降は新規deploymentを阻害する予定のため、新規導入を禁止し、既存利用をinventoryしてparameterized configurationとSecret Managerへ移行する。
-   **Boundary**: IaC variableは非機密入力とsecret referenceを扱う。Remote Configはclient behavior／feature rollout用であり、secret、認証、server authorizationの保管先にしない。

---

## §34. マルチリージョン & DR戦略

### Rule 32.117: リージョン選定基準
-   **Primary/Secondary**: §1の評価軸とRTO/RPOに基づきBlueprintで決定する。primaryとsecondaryは同一障害domainへ置かず、data residencyとservice compatibilityを検証する。
-   **Dynamic Availability**: GPU、runtime、multi-region構成は公式の現行region matrixで再確認する。

### Rule 32.118: リージョン一貫性
-   **Mandate**: 関連serviceのregionは、latency、data residency、availability、failure domain、cross-region transfer costを合わせて決める。同一regionはlatency最適化の候補ですが、DR要件と矛盾する場合は明示的なmulti-region boundaryを設計する。

### Rule 32.119: Disaster Recovery
-   **Strategies**:
    1.  **Location Capability**: current official location matrix、residency、consistency、costを確認し、RTO／RPOが必要とするsingle／dual／multi-region構成を選ぶ。
    2.  **Storage and Compute**: data copy、compute deployment、traffic failoverを同じfailure scenarioで設計し、片側だけの冗長化を避ける。
    3.  **Backup**: backup frequencyとretentionをRPO、法令、deletion要件、costから決め、productionとは独立したcredential／failure domainでrestore testする。
    4.  **RTO/RPO Evidence**: serviceごとのRTO／RPO、restore／failover手順、test cadence、last result、ownerを記録する。

---

## §35. API 設計 & エンドポイント管理

### Rule 32.120: API設計原則
-   **Principles**:
    1.  **Contract First**: consumer、error model、idempotency、compatibility、rate／size limit、deprecationを明示する。REST、GraphQL、RPC、event contractは利用形態から選ぶ。
    2.  **Versioning**: path、header、schema evolutionなどの方式をconsumer互換性から選び、breaking changeには移行期間とusage evidenceを持つ。
    3.  **Bounded Retrieval**: cursor、keyset、page token、streamingなどdata consistencyとscaleに合う方式で応答量とscan costを制限する。

### Rule 32.121: 認証 & 認可
-   **Mandate**: endpointごとにcaller identity、token verification、resource authorization、abuse protection、privileged bypassを設計する。Firebase Auth、App Check、custom claimsは対応surfaceの候補であり、server-to-server、public webhook、anonymous flowへ同一の三層patternを強制しない。

### Rule 32.122: OpenAPI仕様
-   **Mandate**: HTTP APIはOpenAPI等のmachine-readable contract、GraphQLはschema、RPCはIDL、eventはversioned schemaで文書化し、CIでimplementation／consumer compatibilityを検証する。

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

### Rule 32.131: Ecosystem Fit 原則
-   **Mandate**: 技術選定は、必要能力、security、privacy、operability、support、cost、portability、既存team skillを比較し、520のdecision recordで根拠を残す。
-   **Provider Boundary**: Google native integrationは有力候補ですが自動的な優先権を持ちません。first-party／third-partyの別だけで採否を決めず、lock-inとexit costを含むtotal valueで判断します。

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

## §41. Firebase Studio Sunset & 開発環境の可搬性

### Rule 32.133: Firebase Studio Sunset
-   **Mandate**: Firebase Studioを新規標準環境として採用しない。新規workspace作成は2026年6月22日に無効化され、serviceは2027年3月22日にsunset予定のため、既存workspace、owner、repository、secret、preview／deploy dependencyをinventoryし、期限前に承認済み開発環境へ移行する。
-   **Continuity**: sunsetはFirebaseのcore productやdeployed appを直ちに停止するものではないが、source、configuration、artifact、runbookをStudio外のversion管理とCIへ保持し、provider UIなしでbuild、test、deploy、rollbackできることを検証する。

### Rule 32.134: 開発環境の選定と移行
-   **Selection**: local／cloud IDE、AI coding environment、remote workspaceは、source portability、identity、secret isolation、network boundary、audit、reproducible CI、cost、vendor exitで比較する。特定IDEやteam sizeをUniversalで固定しない。
-   **Generated Changes**: AI生成codeと自動provisioningはuntrusted changeとしてreview、test、Security Rules／IAM diff、supply-chain scanを通し、productionへ直接deployしない。
-   **Migration Evidence**: source export、secret rotation、environment recreation、CI build、preview、production release、rollback、workspace deletion／retentionのownerとtest resultを残す。

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
-   **Mandate**: productionへ到達するcontainer artifactはdependency／OS vulnerability、provenance、signature／attestation、base image、secret、licenseをriskに応じて検証し、exception ownerと期限を持つ。
-   **Tools**: Artifact Registry scanning、Binary Authorization、SLSA-compatible provenance、policy engineは候補である。
-   **Admission**: supply-chain threat、platform support、criticalityに応じて署名／attestation verificationまたは同等のadmission controlを適用し、break-glassとrollbackをtestする。

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
-   **Mandate**: productionに必要な成熟度targetは、service criticality、data sensitivity、regulation、team size、SLO、blast radiusに応じてBlueprintで決めます。level labelだけでrelease可否を決めず、未達control、compensating control、owner、期限をevidence化します。

---

## §45. マイグレーション & 廃止戦略

### Rule 32.143: Firestoreから別データ基盤へのマイグレーション
-   **Strategy**:
    1.  **Contract & Mapping**: source／targetのschema、identity、ordering、timestamp、TTL、index、authorization、consistency、retentionをmappingし、loss／transform policyを承認する。
    2.  **Backfill & Change Capture**: bulk backfillとCDC、outbox、replay log等を組み合わせ、restartable checkpoint、rate limit、checksum／count／sample validationを持つ。
    3.  **Dual Write Guardrail**: application-levelのbest-effort dual writeは禁止する。dual writeを選ぶ場合はatomicityまたはdurable outbox、ordering、idempotency、retry、reconciliation、partial-failure recoveryを証明する。
    4.  **Shadow Read & Cutover**: production-like trafficでshadow read／compareを行い、error budgetとexit criteriaを満たしてread、次にwriteを段階切替する。RTO、RPO、freeze、rollback pointを事前定義する。
    5.  **Reconciliation & Cleanup**: lagと不一致を解消し、consumerとbackup／restoreを検証してから、法令・retention・rollback windowに従って旧data、credential、index、codeを廃止する。

### Rule 32.144: レガシーAPI廃止
-   **Process**: Deprecation Notice → Migration Guide → Usage Monitoring → Sunset。

### Rule 32.145: 1st Gen Functions 移行
-   **Mandate**: legacy functionはRule 32.10のinventory、公式support期限、互換性test、段階移行、rollbackに従う。provider toolは検証済みの補助手段として使う。

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
    | Cold Start遅延 | instance起動、初期化、artifact、接続 | traceと負荷試験後、初期化削減、再利用、`minInstances`、SLO変更を比較 |
    | CORS エラー | ヘッダー未設定 | `cors`ミドルウェア追加 |
    | Permission Denied | IAM/Security Rules | 権限確認、Emulatorでテスト |
    | Quota Exceeded | API制限超過 | クォータ増加申請、最適化 |
    | Memory Limit | メモリ不足 | メモリ設定増加、ストリーム処理 |
    | Timeout | 処理時間超過 | 非同期化、Cloud Run Jobs移行 |
    | GPU Not Available | リージョン制限 | GPU対応リージョンに移動 |

### Rule 32.148: インシデント対応
-   **Process**:
    1.  **Detection**: SLOとseverityに応じたBlueprint時間内にalertで検知する。
    2.  **Triage**: 影響範囲の特定とSeverity判定。
    3.  **Mitigation**: 一時的な対処（Feature Flag OFF、ロールバック等）。
    4.  **Resolution**: 根本原因の修正と検証。
    5.  **Post-mortem**: 振り返りと再発防止策の策定。

---

## §47. Node.js/TypeScript 固有設計

### Rule 32.149: ランタイム選定
-   **Mandate**: providerが公式対応し、security support期間内にあるNode.js releaseを、dependency互換とEOL計画を確認して選ぶ。
-   **Configuration**: `engines`等のprovider対応機構でexact majorまたは許容範囲を明示し、CIとproductionの解決versionを照合する。
    ```json
    { "engines": { "node": "22" } }
    ```

### Rule 32.150: Node.js型安全性
-   **Mandate**: Node.jsを選択した場合はTypeScriptのstrict modeを標準候補とする。JavaScriptを選択する場合もruntime validation、lint、型check可能なJSDoc、test等で同等の境界安全性を証明する。Cloud Runが公式対応するGo、Python、Java、.NET等をこの節で排除しない。
-   **Configuration**: TypeScriptでは`strict: true`を設定し、境界入力にはruntime validationを併用する。詳細な言語選定は`engineering/320_programming_language_governance.md`に従う。

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
-   **Mandate**: Node.jsのAI workflowでは、Genkitを候補としてmodel portability、evaluation、observability、security、runtime support、exitを比較する。採用時は公式の現行statusと`onCallGenkit`等のintegrationを再確認する。

---

## §48. Node.js パフォーマンス & テスト

### Rule 32.154: バンドル最適化
-   **Mandate**: Cloud Run Functions のデプロイサイズを最小化する。
-   **Strategies**:
    1.  `devDependencies`と`dependencies`を適切に分離。
    2.  不要な依存関係を定期的にプルーニング。
    3.  `--only=production`または`npm ci --omit=dev`でデプロイ。

### Rule 32.155: テストフレームワーク
-   **Mandate**: repositoryとruntimeに適合するmaintained test frameworkを選び、unit、integration、emulator、contract、failure pathを実行する。Vitest／Jestは参考実装である。
-   **Coverage**: line率だけで合否を決めず、risk、branch、mutation、重要journeyに基づくBlueprint基準を設ける。

---

## §49. Node.js デプロイ & パッケージ管理

### Rule 32.156: パッケージマネージャー
-   **Mandate**: teamがsupportでき、provider buildと互換なmaintained package managerを一つ選び、versionをpinする。npm、pnpm、Yarn等を名称だけで一律除外しない。
-   **Lock File**: deploy可能applicationでは選択したmanagerのlockfileまたは同等のresolved dependency digestをversion管理し、frozen installをCIで検証する。

### Rule 32.157: Monorepo対応
-   **Mandate**: 複数packageのatomic change、共有policy、build graphが必要な場合だけworkspace／monorepoを採用する。npm／pnpm／Yarn workspaces、Bazel、Nx、Turborepo等は要件に応じた参考実装である。

---

## §50. Go 固有設計

### Rule 32.158: Go ランタイム
-   **Mandate**: providerが公式対応し、security support期間内にあるGo releaseを、module、library、build image互換とEOL計画を確認してpinする。

### Rule 32.159: Genkit Go（GA）
-   **Mandate**: GoのAI workflowではGenkitを候補として、公式の現行status、model support、evaluation、observability、security、exitを比較し、採用をADRで決める。
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
-   **Mandate**: providerが公式対応し、security support期間内にあるPython releaseを、dependency、native wheel、build image互換とEOL計画を確認してpinする。

### Rule 32.164: Genkit Python
-   **Mandate**: PythonのAI workflowではGenkitを候補として、公式の現行status、model support、evaluation、observability、security、exitを比較し、採用をADRで決める。
-   **Caution**: preview／pre-GA機能を採用する場合はsupport、breaking change、fallback、退出期限を持つ期限付き例外として扱う。

### Rule 32.165: 型ヒント
-   **Mandate**: public API、domain model、I/O boundary、security／money critical codeへ型を付け、選定したstatic checkerをCIで実行する。動的境界や未型付けdependencyの例外はscope、owner、期限を明示する。`mypy`、Pyright等は候補であり、単一toolをUniversalで固定しない。
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
-   **Mandate**: Python標準または承認済みtest runnerでunit、boundary、integration、emulator／isolated-project testを実施する。async fixtureは実際のconcurrency boundaryがある場合に導入する。
-   **Coverage**: coverage toolはuntested riskを発見するsignalとして使い、固定率だけをrelease条件にしない。critical path、authorization deny、retry／idempotency、migration failureを優先する。

### Rule 32.167: 依存関係管理
-   **Mandate**: supported manifestと、再現可能なresolved dependency／checksum evidenceをversion管理し、index source、transitive dependency、native artifact、license、vulnerability、runtime compatibilityをCIで検証する。
-   **Tools**: `pyproject.toml`、lock／constraints file、`uv`、pip-tools、Poetry、PDM等はprojectのruntimeとpackaging contractに合う候補として比較し、採用toolとupgrade policyをBlueprintへ記録する。

---

## §54. アンチパターン35選

### Rule 32.168: 禁止パターン集

| # | アンチパターン | 正しいアプローチ |
|---|---|---|
| 1 | 評価・Rules・index・cost ownerなしでFirestore collectionを作成 | Primary Directive 0.1の能力評価とdata contractを先に完了 |
| 2 | 1st Gen Cloud Functionsの新規作成 | Cloud Run Functionsを使用 |
| 3 | `roles/owner`を本番SAに付与 | カスタムロールで最小権限 |
| 4 | サービスアカウントキーをGitにコミット | Secret Manager + WIF |
| 5 | version管理対象の`.env`やclient bundleへ機密情報を格納 | 承認済みsecret store、ignore、sample分離で管理 |
| 6 | 対応surfaceでApp Checkを未評価のまま本番運用 | 脅威モデル、monitoring、段階enforcementを実施 |
| 7 | Security Rules未設定のFirestore | Default Deny + Authentication |
| 8 | user-controlled／collection-wide readに上限や終了条件がない | limit、cursor、quota、data contractでbounded readを保証 |
| 9 | 冪等性を無視した関数設計 | stable key、atomic claim、outbox、reconciliationでside effectを保護 |
| 10 | 同期的な重い処理 | Pub/Sub/Cloud Tasksで非同期化 |
| 11 | SLO／cost evidenceなしにcold start対策を固定 | latency、traffic、idle costを計測し必要なserviceだけ`minInstances`等を選定 |
| 12 | default resourceを未検証または過剰設定 | load test、quota、costからmemory／CPU／timeout／concurrencyを決定 |
| 13 | 予算監視とownerが未設定 | Blueprintの予算threshold・通知・安全な対応を設定 |
| 14 | GCPリソースのownership／cost attribution不能 | 組織標準のlabels／tagsとpolicyで追跡可能にする |
| 15 | 手動インフラ設定（ClickOps） | Terraform/IaCで管理 |
| 16 | 本番環境で`firebase deploy`の手動実行 | CI/CDパイプライン経由 |
| 17 | テストなしのSecurity Rulesデプロイ | Emulator Suiteまたは隔離projectでallow／deny双方を自動テスト |
| 18 | 構造化されていないログ出力 | JSON構造化ログ |
| 19 | エラーハンドリングの不統一 | 統一ErrorResponseフォーマット |
| 20 | failure classと冪等性を無視した外部呼び出し | deadline、retry budget、jitter、idempotency、DLQ／reconciliationを設計 |
| 21 | FCMレガシーAPIの使用 | HTTP v1 APIへの移行 |
| 22 | Admin SDKの不適切な使用 | 最小権限IAM + Secret Manager |
| 23 | private data pathのnetwork境界・egress・bypassが未設計 | 対応serviceと脅威に合うprivate path／egress controlを選定 |
| 24 | 機密情報のログ出力 | PII/パスワードのログ禁止 |
| 25 | AI出力のガードレールなし | 入力検証 + 出力フィルタ + Kill Switch |
| 26 | AI関連コストの未追跡 | AI FinOpsラベリング + Blueprintのunit economics／threshold |
| 27 | Staging差分が未管理 | 重要controlのparityとdocument化した差分を維持 |
| 28 | DRテストの未実施 | RTO／RPOとriskに基づくcadenceでrestore／failoverを検証 |
| 29 | SBOMなしのコンテナデプロイ | SBOM生成・保管 |
| 30 | sunset対象のFirebase Studioへsource／deploy経路を依存 | portable source、承認済み開発環境、再現可能CIへ移行 |
| 31 | Genkit フローのテスト未実施 | Developer UIとユニットテスト |
| 32 | provenance／signature／admission riskを未評価の本番container | criticalityに応じてattestation verificationまたは同等controlを適用 |
| 33 | MCPサーバーの認証なし公開 | IAM + App Checkによるアクセス制御 |
| 34 | billing plan／free tierをhard capと誤認 | usage-based billing、quota、abuse、budget、degradationを設計 |
| 35 | tokenをthreat modelなしに永続保存 | platform別にXSS、CSRF、device compromise、rotation、revocationを評価し安全なstorageを選ぶ |

---

## §55. 技術lifecycle radar

### Rule 32.169: 技術トレンド監視
-   **Mandate**: 利用中または採用候補のcapabilityについて、公式release stage、deprecation／EOL、runtime／SDK、region、quota、pricing、security model、data use、support contractの変化を継続監視し、capability manifestの再検証triggerへ接続する。
-   **Signals**:
    1.  **Execution Surface**: managed runtime、buildpack、container、edge／distributed、GPU／accelerator、confidential computeのsupportと責任分界。
    2.  **Language & SDK**: 言語version、official／community SDK、feature parity、experimental／preview／GA、security support、migration guide。
    3.  **Security & Identity**: workload identity、attestation、encryption、data perimeter、supply-chain verification、quantum-safe移行に関する公式controlと適用条件。
    4.  **Data & AI**: database／stream／vector／AI framework／agent protocolのmaturity、evaluation、安全性、data governance、unit economics、exit。
    5.  **Operations & Commercial**: observability、backup／restore、SLA、support、quota、pricing／terms、sunset、provider incident。
-   **Promotion Gate**: 新機能は存在または話題性だけでproduction標準へ昇格させない。workload fit、maturity、feature parity、security、performance、cost、operability、portability、rollback、team ownershipを既存選択肢と同じevidenceで比較し、preview／experimentalは限定scope、exit、revalidation dateを持つ。

---

## §56. 言語・SDK・runtime support surface

### Rule 32.170: Support Claim Decomposition
-   **Mandate**: 「Firebase／GCPが言語Xをsupportする」を単一の真偽値にしない。client SDK、Admin SDK、framework binding、Functions managed runtime、Cloud Run source buildpack、任意container、REST／gRPC、CLI／IaCを別surfaceとして、support主体、maturity、feature parity、runtime、artifact、identity、deployment、observability、EOLをinventory化する。

### Rule 32.171: Firebase Client SDK Surface
-   **Current Snapshot**: 2026-07-23時点の公式資料は、Android、Flutter、Apple platforms、JavaScript、Unity、C++をofficial client SDK surfaceとして示す。Swift、Kotlin／Java、Dart、TypeScript／JavaScript、C#、C++のcode qualityは `engineering/320_programming_language_governance.md`、`engineering/400_mobile_flutter.md`、`engineering/410_native_platforms.md` を継承する。
-   **Framework Boundary**: AngularFire、ReactFire、React Native Firebase、Vuefire等のframework bindingはofficial Firebase SDKと同じsupport契約とは限らない。React Nativeでは `engineering/420_react_native.md` に従い、JS package、iOS／Android SDK、native module、Codegen／bridge、両OS build、release compatibilityを別々にpin・testする。

### Rule 32.172: Firebase Admin SDK Surface
-   **Current Snapshot**: 2026-07-23時点のAdmin SDK公式資料はNode.js、Java、Python、Go、C#をserver-side surfaceとして示し、Dartをexperimentalとして案内する。言語名だけで全機能対応を推定せず、feature matrix、minimum runtime、deprecation、release noteをcapabilityごとに確認する。
-   **Privilege Boundary**: Admin SDKはclient Security Rulesを通るuntrusted client libraryではない。workload identity、least privilege、tenant／project、audit、credential lifecycleをserver boundaryで強制し、mobile／browser bundleへ含めない。

### Rule 32.173: Cloud Run Execution Surface
-   **Current Snapshot**: 2026-07-23時点のCloud Run source deployment資料はGo、Node.js、Python、Java buildpack経由のKotlin／Groovy／Scala、.NET、Ruby、PHPをsource-build surfaceとして示し、Dockerfile／container imageではcontainer contractを満たす任意言語を実行できる。Functions runtime、source buildpack、任意containerを同じsupport契約とみなさない。
-   **Build Contract**: source deploymentでもbuilder、base image、resolved dependency、runtime patch mode、Artifact Registry image、SBOM、provenance、architecture、startup／health、rollbackをrelease evidenceへ結び付ける。自動検出を再現可能性またはsecurity updateの完全な保証にしない。

### Rule 32.174: Language-Native Quality Gates
-   **Mandate**: Node.js／TypeScript、Go、Python以外のJava／Kotlin／Groovy／Scala、C#／F#、Ruby、PHPその他も `engineering/320_programming_language_governance.md` のformatter、compiler／type、test、dependency、artifact、SBOM、runtime EOL gateを適用する。provider profileへ同じ言語規則を複製せず、Firebase／GCP固有のidentity、emulator fidelity、runtime、deployment、quotaだけを追加する。

### Rule 32.175: Polyglot Team Ownership
-   **Mandate**: productionで利用する言語・SDK・runtime surfaceごとにaccountable owner、support level、upgrade／EOL、security advisory route、CI gate、on-call／incident、fallback、decommissionをservice catalogまたは同等台帳へ結ぶ。小規模teamは役割を兼務できるが、experimental／community binding、privileged Admin SDK、native mobile、managed runtimeの責任を一つの「Firebase owner」へ暗黙集約しない。
-   **CI Selection**: change graphから影響するclient、admin、runtime、mobile OS、containerのnative gateとmanaged conformance testを選ぶ。全言語を全PRで一律実行せず、shared schema、Auth／Rules、SDK major、runtime、generated contractの変更では全dependentを再検証する。

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
| Firebase Studioから移行したい | §41 |
| GDPRに対応したい | §42 |
| コンテナセキュリティを強化したい | §43 |
| 運用を改善したい | §44 |
| Firestoreからの移行を計画したい | §45 |
| Node.js/TypeScript固有のガイド | §47, §48, §49 |
| Go固有のガイド | §50, §51 |
| Python固有のガイド | §52, §53 |
| Java／Kotlin／Scala、C#／.NET、Ruby、PHPをCloud Runへ配置したい | §56 |
| Swift／Kotlin／Dart／Unity／C++ client SDKのsupportを判断したい | §56 |
| React Native Firebase等のframework bindingを評価したい | §56、`engineering/420_react_native.md` |

---

## Appendix B: クロスリファレンス

| 関連ルールファイル | 参照目的 |
|---|---|
| `engineering/000_engineering_standards` | ソフトウェアエンジニアリング一般原則 |
| `engineering/300_web_frontend` | フロントエンド統合パターン |
| `engineering/100_api_integration` | API設計・マイクロサービス設計 |
| `engineering/410_native_platforms` | モバイルアプリ統合（iOS/Android） |
| `engineering/420_react_native` | React NativeのJS／native／SDK境界 |
| `engineering/320_programming_language_governance` | 言語native gate、support tier、polyglot team統治 |
| `engineering/200_supabase_architecture` | Supabaseを採用した場合の連携・移行 |
| `engineering/520_cloud_application_platforms` | platform選定・共有責任・退出戦略 |
| `engineering/510_aws_cloud` | マルチクラウド戦略・比較 |
| `ai/000_ai_engineering` | AI/ML実装ガイドライン |
| `ai/100_data_analytics` | 分析・Observability |
| `quality/000_qa_testing` | テスト戦略全般 |
| `security/000_security_privacy` | セキュリティ・プライバシー |
| `operations/600_cloud_finops` | FinOps・コスト管理 |

---

## Appendix C: FinOps チェックリスト

> 対応serviceを採用し、cost／risk modelで必要と判定した項目だけを適用する。BigQuery、Pub/Sub、Recommender、Remote Config等はGCP／Firebase profileの実装例であり、Universalな唯一解ではない。

### 初期セットアップ
- [ ] 全GCPリソースに`environment`/`service`/`owner`/`cost-center`/`ai-feature`ラベルを付与
- [ ] Billing Export to BigQueryを有効化
- [ ] Blueprintで承認された多段階の実額・予測予算アラートを設定
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

> 対応serviceとthreat modelに該当する項目だけを適用し、provider capability、法域、data classに応じた同等controlを認める。

### 初期セットアップ
- [ ] 対応surfaceでApp Checkを評価し、monitoringから段階enforcementへ移行
- [ ] Security Rules のDefault Denyパターンを適用
- [ ] 通常のproduction workload／CI／恒久human accessからbroad basic roleを除去し、break-glassを分離
- [ ] 対応する外部identity経路にshort-lived federationとclaim restrictionを設定
- [ ] production／shared secretを承認済みsecret storeへ移行
- [ ] data exfiltration threatとservice supportに応じてVPC Service Controlsを評価・検証
- [ ] internet-facing surfaceに適合するWAF／DDoS controlとbypass防止を評価
- [ ] container supply-chain threatに応じてBinary Authorizationその他のadmission controlを評価

### 定期監査（risk-based cadence）
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

---

## Appendix E: 公式資料スナップショット

- [Cloud Run container runtime contract](https://cloud.google.com/run/docs/container-contract): 任意言語container、port、filesystem、lifecycle、architectureの実行契約
- [Cloud Run Functions runtimes](https://cloud.google.com/run/docs/runtimes/function-runtimes): managed language runtimeとsupport／decommission期限
- [Firebase supported libraries](https://firebase.google.com/docs/libraries): 公式client／Admin SDKとcommunity framework bindingのsupport境界
- [Firebase Admin SDK setup](https://firebase.google.com/docs/admin/setup): Admin SDKの言語別feature matrix、runtime要件、experimental status
- [Cloud Run deploy from source](https://cloud.google.com/run/docs/deploying-source-code): source buildpack対応言語、container経路、builder／artifact境界
- [Google Cloud resource hierarchy](https://cloud.google.com/resource-manager/docs/cloud-platform-resource-hierarchy): Organization、Folder、Projectのownershipとpolicy継承
- [Cloud Functions retry](https://firebase.google.com/docs/functions/retries): retry、at-least-once、idempotencyの境界
- [Configure environment](https://firebase.google.com/docs/functions/config-env): parameterized config、secret、`functions.config()`廃止移行
- [Manage sessions](https://firebase.google.com/docs/auth/admin/manage-sessions): ID token、refresh token、revocation
- [Firebase App Check](https://firebase.google.com/docs/app-check): app／device attestationと認証・認可の責任分離
- [Firebase Studio release notes](https://firebase.google.com/support/release-notes/firebase-studio): 2026-06-22の新規workspace停止と2027-03-22 sunset
